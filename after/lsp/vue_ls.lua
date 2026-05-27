local vue = require("lsp.vue")

return {
  cmd = { "vue-language-server", "--stdio" },
  filetypes = { "vue" },
  root_markers = { "package.json" },
  on_new_config = function(new_config, root)
    local _, fallback_tsdk = vue.resolve_paths()
    local tsdk = vue.workspace_tsdk(root) or fallback_tsdk

    if not tsdk then
      return
    end

    new_config.init_options = new_config.init_options or {}
    new_config.init_options.typescript = new_config.init_options.typescript or {}
    new_config.init_options.typescript.tsdk = tsdk
  end,
  on_init = vue.vue_on_init,
}
