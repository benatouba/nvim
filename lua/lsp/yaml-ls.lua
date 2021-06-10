-- npm install -g yaml-language-server
require'lspconfig'.yamlls.setup{
	cmcmd = {DATA_PATH .. "/lspinstall/yaml/node_modules/.bin/yaml-language-server", "--stdio"},
    on_attach = require'lsp'.common_on_attach,
}
