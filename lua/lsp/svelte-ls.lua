require'lspconfig'.svelte.setup {
    cmd = {DATA_PATH .. "/lsp_servers/svelte/node_modules/.bin/svelteserver", "--stdio"},
    on_attach = require'lsp'.common_on_attach
}
