local vue = require("lsp.vue")

return {
  cmd = require("lsp.resolve").rpc("typescript-language-server"),
  init_options = {
    hostInfo = "neovim",
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
  before_init = function(init_params, config)
    local _, fallback_tsdk = vue.resolve_paths(config.root_dir)
    local tsdk = vue.workspace_tsdk(config.root_dir) or fallback_tsdk
    if tsdk then
      init_params.initializationOptions =
        vim.tbl_deep_extend("force", init_params.initializationOptions or {}, { typescript = { tsdk = tsdk } })
    end
  end,
}
