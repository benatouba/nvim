local vue = require("lsp.vue")

return {
  cmd = function(dispatchers, config)
    local resolved = vue.resolve_vue_ls_cmd(config and config.root_dir) or { "vue-language-server", "--stdio" }
    return vim.lsp.rpc.start(resolved, dispatchers)
  end,
  filetypes = { "vue" },
  root_markers = { "package.json" },
  before_init = function(init_params, config)
    local _, fallback_tsdk = vue.resolve_paths(config.root_dir)
    local tsdk = vue.workspace_tsdk(config.root_dir) or fallback_tsdk

    if tsdk then
      init_params.initializationOptions =
        vim.tbl_deep_extend("force", init_params.initializationOptions or {}, { typescript = { tsdk = tsdk } })
    end
  end,
  on_init = {
    vue.vue_on_init,
    function(client)
      client.server_capabilities.definitionProvider = true
    end,
  },
}
