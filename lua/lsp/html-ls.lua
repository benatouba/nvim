-- npm install -g vscode-html-languageserver-bin
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.html.setup {
    cmd = {"node", DATA_PATH .. "/lsp_servers/html/vscode-html/html-language-features/server/dist/node/htmlServerMain.js", "--stdio"},
    on_attach = common_on_attach,
    capabilities = capabilities
}
