local vue = require("lsp.vue")

return {
  cmd = function(dispatchers, config)
    local resolved = vue.resolve_ts_ls_cmd(config and config.root_dir)
    if not resolved then
      resolved = { "typescript-language-server", "--stdio" }
    end
    return vim.lsp.rpc.start(resolved, dispatchers)
  end,
  init_options = {
    hostInfo = "neovim",
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
  on_new_config = function(new_config, root)
    local _, fallback_tsdk = vue.resolve_paths(root)
    local tsdk = vue.workspace_tsdk(root) or fallback_tsdk

    if tsdk then
      new_config.init_options = new_config.init_options or {}
      new_config.init_options.typescript = new_config.init_options.typescript or {}
      new_config.init_options.typescript.tsdk = tsdk
    end
  end,
}
