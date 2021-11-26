require'lspconfig'.clangd.setup {
    cmd = {DATA_PATH .. "/lsp_servers/cpp/clangd/bin/clangd"},
    on_attach = common_on_attach,
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            update_in_insert = true
        })
    }
}
