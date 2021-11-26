-- npm i -g pyright
require'lspconfig'.pyright.setup {
    cmd = {DATA_PATH .. "/lsp_servers/pyright/node_modules/.bin/pyright-langserver", "--stdio"},
}
