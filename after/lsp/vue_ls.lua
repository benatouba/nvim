local vue = require("lsp.vue")

return {
  cmd = require("lsp.resolve").rpc("vue-language-server"),
  filetypes = { "vue" },
  root_markers = { "package.json" },
  before_init = function(init_params, config)
    local _, tsdk = vue.resolve_paths(config.root_dir)

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
