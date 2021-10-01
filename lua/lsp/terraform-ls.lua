require'lspconfig'.terraformls.setup{
    cmd = {DATA_PATH .. "/lsp_servers/terraformls/terraform-ls", "serve"},
    on_attach = require'lsp'.common_on_attach
}
