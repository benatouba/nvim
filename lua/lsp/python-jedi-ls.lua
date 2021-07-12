local config = {
    filetypes = {"python"},
    on_attach = common_on_attach,
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = O.python.diagnostics.virtual_text,
            signs = O.python.diagnostics.signs,
            underline = O.python.diagnostics.underline,
            update_in_insert = true,
        })
    },
    cmd = {"jedi-language-server"},
    install_script = [[
        ! pip3 install jedi-language-server || true
    ]],
    uninstall_script = [[
        ! pip3 uninstall jedi-language-server || true
    ]]
}

require'lspconfig'.jedi_language_server.setup {config}
require'lspinstall/servers'.python_jedi = config
