local python_path = vim.fn.stdpath('home') .. "/.venv/nvim/bin/python3"
local lsp_path = DATA_PATH .. "/lspinstall/salt/lsp_server.py"
require'lspconfig'.salt.setup{
	cmcmd = {python_path .. " " .. lsp_path , "--tcp"},
    on_attach = require'lsp'.common_on_attach,
}
