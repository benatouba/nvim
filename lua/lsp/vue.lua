local M = {}

local function is_dir(path)
  return path and path ~= "" and vim.fn.isdirectory(path) == 1
end

local function is_file(path)
  return path and path ~= "" and vim.fn.filereadable(path) == 1
end

local function walk_ancestors(start_dir, cb)
  local dir = start_dir
  while dir and dir ~= "" do
    local done, value = cb(dir)
    if done then
      return value
    end

    local parent = vim.fs.dirname(dir)
    if not parent or parent == dir then
      break
    end

    dir = parent
  end

  return nil
end

local function bin_cmd(bin_path)
  if vim.fn.executable(bin_path) == 1 then
    return { bin_path, "--stdio" }
  end

  local win_candidate = bin_path .. ".cmd"
  if is_file(win_candidate) then
    return { win_candidate, "--stdio" }
  end

  return nil
end

local function workspace_bin_cmd(root_dir, bin)
  if not root_dir or root_dir == "" then
    return nil
  end

  return walk_ancestors(root_dir, function(dir)
    local cmd = bin_cmd(dir .. "/node_modules/.bin/" .. bin)
    return cmd ~= nil, cmd
  end)
end

local function devenv_bin_cmd(root_dir, bin)
  if not root_dir or root_dir == "" then
    return nil
  end

  return walk_ancestors(root_dir, function(dir)
    local cmd = bin_cmd(dir .. "/.devenv/profile/bin/" .. bin)
    return cmd ~= nil, cmd
  end)
end

local function resolve_cmd(root_dir, bin)
  local local_cmd = workspace_bin_cmd(root_dir, bin)
  if local_cmd then
    return local_cmd
  end

  local devenv_cmd = devenv_bin_cmd(root_dir, bin)
  if devenv_cmd then
    return devenv_cmd
  end

  if vim.fn.executable(bin) == 1 then
    return { bin, "--stdio" }
  end

  return nil
end

local function resolve_typescript_relative_to(bin_path)
  local pkg_root = vim.fn.fnamemodify(bin_path, ":h:h")
  local ts_glob = vim.fn.glob(pkg_root .. "/lib/**/typescript/lib", true)
  if ts_glob == "" then
    return nil
  end
  local candidate = vim.split(ts_glob, "\n")[1]
  if not is_dir(candidate) then
    return nil
  end
  return candidate
end

local function resolve_typescript_lib_from_bin(bin)
  local server_bin = vim.fn.exepath(bin)
  if server_bin == "" then
    return nil
  end
  return resolve_typescript_relative_to(server_bin)
end

M.node_root_dir = function(bufnr)
  local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }
  root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers, { ".git" } }
    or vim.list_extend(root_markers, { ".git" })

  local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
  local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
  local project_root = vim.fs.root(bufnr, root_markers)

  if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
    return nil
  end

  if deno_root and (not project_root or #deno_root >= #project_root) then
    return nil
  end

  return project_root or vim.fn.getcwd()
end

M.workspace_tsdk = function(root_dir)
  if not root_dir or root_dir == "" then
    return nil
  end

  local candidate = root_dir .. "/node_modules/typescript/lib"
  if vim.fn.isdirectory(candidate) == 1 then
    return candidate
  end

  return nil
end

M.workspace_vue_ls_cmd = function(root_dir)
  return workspace_bin_cmd(root_dir, "vue-language-server")
end

M.resolve_vue_ls_cmd = function(root_dir)
  return resolve_cmd(root_dir, "vue-language-server")
end

M.workspace_vtsls_cmd = function(root_dir)
  return workspace_bin_cmd(root_dir, "vtsls")
end

M.workspace_ts_ls_cmd = function(root_dir)
  return workspace_bin_cmd(root_dir, "typescript-language-server")
end

M.resolve_vtsls_cmd = function(root_dir)
  return resolve_cmd(root_dir, "vtsls")
end

M.resolve_ts_ls_cmd = function(root_dir)
  return resolve_cmd(root_dir, "typescript-language-server")
end

M.has_vtsls = function(root_dir)
  return M.resolve_vtsls_cmd(root_dir) ~= nil
end

M.workspace_vue_language_server_path = function(root_dir)
  if not root_dir or root_dir == "" then
    return nil
  end

  local candidate = root_dir .. "/node_modules/@vue/language-server"
  if vim.fn.isdirectory(candidate) == 1 then
    return candidate
  end

  return nil
end

M.resolve_paths = function(root_dir)
  local vue_language_server_path, tsdk

  vue_language_server_path = M.workspace_vue_language_server_path(root_dir)
  tsdk = M.workspace_tsdk(root_dir)

  if vue_language_server_path and tsdk then
    return vue_language_server_path, tsdk
  end

  if rawget(_G, "O") and O.is_nixos then
    local vue_ls_cmd = M.resolve_vue_ls_cmd(root_dir)
      or (vim.fn.executable("vue-language-server") == 1 and { vim.fn.exepath("vue-language-server") })
    if vue_ls_cmd then
      local vue_ls_pkg = vim.fn.fnamemodify(vue_ls_cmd[1], ":h:h")
      local nix_vue_path = vue_ls_pkg .. "/lib/language-tools/packages/language-server"
      if is_dir(nix_vue_path) then
        vue_language_server_path = vue_language_server_path or nix_vue_path
      end
    end

    if not tsdk then
      local vtsls_cmd = M.resolve_vtsls_cmd(root_dir)
        or (vim.fn.executable("vtsls") == 1 and { vim.fn.exepath("vtsls") })
      tsdk = tsdk or (vtsls_cmd and resolve_typescript_relative_to(vtsls_cmd[1]))

      local ts_cmd = M.resolve_ts_ls_cmd(root_dir)
        or (vim.fn.executable("typescript-language-server") == 1 and { vim.fn.exepath("typescript-language-server") })
      tsdk = tsdk or (ts_cmd and resolve_typescript_relative_to(ts_cmd[1]))
    end
  else
    local mason_packages = vim.env.MASON and (vim.env.MASON .. "/packages")
      or (vim.fn.stdpath("data") .. "/mason/packages")

    local mason_vue_path = mason_packages .. "/vue-language-server/node_modules/@vue/language-server"
    if is_dir(mason_vue_path) then
      vue_language_server_path = vue_language_server_path or mason_vue_path
    end

    local mason_tsdk = mason_packages .. "/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib"
    if is_dir(mason_tsdk) then
      tsdk = tsdk or mason_tsdk
    end

    tsdk = tsdk or resolve_typescript_lib_from_bin("vtsls")
    tsdk = tsdk or resolve_typescript_lib_from_bin("typescript-language-server")
  end

  return vue_language_server_path, tsdk
end

M.find_ts_client = function(bufnr)
  local ts_client = vim.lsp.get_clients({ bufnr = bufnr, name = "vtsls" })[1]
    or vim.lsp.get_clients({ bufnr = bufnr, name = "ts_ls" })[1]
    or vim.lsp.get_clients({ bufnr = bufnr, name = "typescript-tools" })[1]

  if ts_client then
    return ts_client
  end

  return vim.lsp.get_clients({ name = "vtsls" })[1]
    or vim.lsp.get_clients({ name = "ts_ls" })[1]
    or vim.lsp.get_clients({ name = "typescript-tools" })[1]
end

M.vue_on_init = function(client)
  local retries = 0

  local function typescriptHandler(_, result, context)
    local ts_client = M.find_ts_client(context.bufnr)

    if not ts_client then
      if retries <= 50 then
        retries = retries + 1
        vim.defer_fn(function()
          typescriptHandler(_, result, context)
        end, 200)
      else
        vim.notify(
          "Could not find `vtsls`, `ts_ls`, or `typescript-tools` lsp client required by `vue_ls`.",
          vim.log.levels.ERROR
        )
      end
      return
    end

    retries = 0
    local param = result[1]
    local id, command, payload = param[1], param[2], param[3]
    ts_client:exec_cmd({
      title = "vue_request_forward",
      command = "typescript.tsserverRequest",
      arguments = {
        command,
        payload,
      },
    }, { bufnr = context.bufnr }, function(_, r)
      local response_data = { { id, r and r.body } }
      ---@diagnostic disable-next-line: param-type-mismatch
      client:notify("tsserver/response", response_data)
    end)
  end

  client.handlers["tsserver/request"] = typescriptHandler
end

return M
