local M = {}

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

M.resolve_paths = function()
  local vue_language_server_path, tsdk

  if rawget(_G, "O") and O.is_nixos then
    local vue_ls_bin = vim.fn.exepath("vue-language-server")
    if vue_ls_bin ~= "" then
      local vue_ls_pkg = vim.fn.fnamemodify(vue_ls_bin, ":h:h")
      vue_language_server_path = vue_ls_pkg .. "/lib/language-tools/packages/language-server"
    end

    local vtsls_bin = vim.fn.exepath("vtsls")
    if vtsls_bin ~= "" then
      local vtsls_pkg = vim.fn.fnamemodify(vtsls_bin, ":h:h")
      local ts_glob = vim.fn.glob(vtsls_pkg .. "/lib/**/typescript/lib", true)
      if ts_glob ~= "" then
        tsdk = vim.split(ts_glob, "\n")[1]
      end
    end
  else
    local mason_packages = vim.env.MASON and (vim.env.MASON .. "/packages")
      or (vim.fn.stdpath("data") .. "/mason/packages")

    vue_language_server_path = mason_packages .. "/vue-language-server/node_modules/@vue/language-server"
    tsdk = mason_packages .. "/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib"
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
