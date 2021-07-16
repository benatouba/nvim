local util = require('lspconfig/util')

local config = {
    filetypes = {"python"},
    on_attach = common_on_attach,
    root_dir = util.root_pattern(".git"),
    handlers = {
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = O.diagnostics.virtual_text,
            signs = O.diagnostics.signs,
            underline = O.diagnostics.underline,
            update_in_insert = true,
        })
    },
    cmd = {vim.fn.stdpath('data') .. "/lspinstall/python_jedi/venv/bin/jedi-language-server"},
    install_script = [[
        ! pip3 install --upgrade jedi-language-server || true
    ]],
    uninstall_script = [[
        ! pip3 uninstall jedi-language-server || true
    ]]
}

require'lspconfig'.jedi_language_server.setup {config}
require'lspinstall/servers'.python_jedi = config
