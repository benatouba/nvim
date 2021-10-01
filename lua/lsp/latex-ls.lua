require'lspconfig'.texlab.setup{
    cmd = {DATA_PATH .. "/lsp_servers/texlab/texlab"},
    on_attach = common_on_attach
}
