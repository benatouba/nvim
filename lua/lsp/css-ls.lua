-- npm install -g vscode-css-languageserver-bin
require'lspconfig'.cssls.setup {
    cmd = {
        "node", DATA_PATH .. "/lsp_servers/css/vscode-css/css-language-features/server/dist/node/cssServerMain.js",
        "--stdio"
    },
    on_attach = common_on_attach
}
