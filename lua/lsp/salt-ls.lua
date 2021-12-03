local lspconfig = require("lspconfig")
local configs = require("lspconfig/configs")

local root_dir = vim.fn.stdpath("data") .. "/lsp_servers/salt"

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

configs["salt"] = {
	default_config = {
		cmd = { root_dir .. "/venv/bin/python3", "-m", "salt_lsp" },
		filetypes = { "sls" },
		root_dir = lspconfig.util.root_pattern("top.sls", ".git", vim.fn.getcwd()),
		settings = {},
	},
	--   docs = {
	--       package_json = "https://github.com/dcermak/salt-lsp/tree/main",
	--       description = [[
	--           `salt-lsp` can be installed via `poetry` and `pip`:
	--           ```sh
	--           poetry install
	--           poetry run dump_state_name_completions
	--           poetry build
	--
	--           pip install --user --force-reinstall dist/salt_lsp-0.0.1*whl
	--           ```
	--       ]],
	--       default_config = {
	--           root_dir = [[root_pattern("top.sls", ".git", vim.fn.getcwd())]]
	--       }
	--   }
}

lspconfig.salt.setup({
	on_attach = function(client, bufnr)
		local function buf_set_keymap(...)
			vim.api.nvim_buf_set_keymap(bufnr, ...)
		end
		local function buf_set_option(...)
			vim.api.nvim_buf_set_option(bufnr, ...)
		end
		buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
		local opts = { noremap = true, silent = true }
		buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	end,
	capabilities = capabilities,
	flags = {
		debounce_text_changes = 150,
	},
})
