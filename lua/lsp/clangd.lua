require'lspconfig'.clangd.setup {
    cmd = {DATA_PATH .. "/lsp_servers/cpp/clangd/bin/clangd"},
    on_attach = common_on_attach,
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = O.clang.diagnostics.virtual_text,
            signs = O.clang.diagnostics.signs,
            underline = O.clang.diagnostics.underline,
            update_in_insert = true

        })
    }
}
