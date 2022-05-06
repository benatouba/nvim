local lsp = require 'lspconfig'
lsp.vuels.setup {
    root_dir = lsp.util.root_pattern(".git", "."),
    on_attach = common_on_attach
}
require 'lspconfig'.volar.setup {
    on_new_config = function(new_config)
        new_config.init_options.documentFeatures.documentFormatting = false
    end,
}
