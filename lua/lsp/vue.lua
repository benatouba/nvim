local M = {}

local function is_dir(path)
  return path and path ~= "" and vim.fn.isdirectory(path) == 1
end

local resolve = require("lsp.resolve")
local function workspace_package(root, package)
  return resolve.walk_ancestors(root, function(dir)
    local path = dir .. "/node_modules/" .. package
    return is_dir(path), path
  end)
end

local function typescript_package(pkg_root)
  local bundled = pkg_root .. "/node_modules/typescript/lib"
  if is_dir(bundled) then
    return bundled
  end
  for _, path in ipairs(vim.fn.glob(pkg_root .. "/lib/**/typescript/lib", true, true)) do
    if is_dir(path) then
      return path
    end
  end
end

local function vue_package(pkg_root)
  if vim.endswith(pkg_root, "/@vue/language-server") and is_dir(pkg_root) then
    return pkg_root
  end
  local path = pkg_root .. "/lib/language-tools/packages/language-server"
  return is_dir(path) and path or nil
end

local function path_cmd(_, bin)
  local path = vim.fn.exepath(bin)
  return path ~= "" and { path } or nil
end

-- Inspect both physical and profile locations: symlinks describe package identity,
-- while a profile may also expose supporting files beside its executable.
local function package_from_commands(root, bins, sources, find_package)
  for _, source in ipairs(sources) do
    for _, bin in ipairs(bins) do
      local cmd = source(root, bin)
      if cmd then
        local physical = vim.uv.fs_realpath(cmd[1]) or cmd[1]
        for _, path in ipairs({ physical, cmd[1] }) do
          local package = find_package(vim.fn.fnamemodify(path, ":h:h"))
          if package then
            return package
          end
        end
      end
    end
  end
end

M.node_root_dir = function(bufnr)
  -- lockfiles first, .git only as a fallback tier
  local root_markers = { { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock" }, { ".git" } }

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

-- Supporting packages may come from different installations. Workspace packages
-- win; try project-owned executable layouts, then Mason (off Nix), then PATH.
M.resolve_paths = function(root_dir)
  local vue_bins = { "vue-language-server" }
  local ts_bins = { "vtsls", "typescript-language-server" }
  local sources = { resolve.workspace, resolve.devenv }
  local vue_language_server_path = workspace_package(root_dir, "@vue/language-server")
    or package_from_commands(root_dir, vue_bins, sources, vue_package)
  local tsdk = workspace_package(root_dir, "typescript/lib")
    or package_from_commands(root_dir, ts_bins, sources, typescript_package)

  if not vim.g.is_nixos and (not vue_language_server_path or not tsdk) then
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
  end
  vue_language_server_path = vue_language_server_path
    or package_from_commands(root_dir, vue_bins, { path_cmd }, vue_package)
  tsdk = tsdk or package_from_commands(root_dir, ts_bins, { path_cmd }, typescript_package)
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
