-- npm install -g yaml-language-server
require'lspconfig'.yamlls.setup{
	cmcmd = {DATA_PATH .. "/lsp_servers/yaml/node_modules/.bin/yaml-language-server", "--stdio"},
    on_attach = common_on_attach,
}
