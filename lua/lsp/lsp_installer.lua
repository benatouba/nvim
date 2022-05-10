local lspi_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not lspi_ok then
	print("nvim-lsp-installer not okay")
	return
end

local lsp_status_ok, lsp_status = pcall(require, "lsp-status")
if not lsp_status_ok then
	print("lsp-status not okay in lsp_installer")
end

-- local servers = require("nvim-lsp-installer.servers")
-- local path = require("nvim-lsp-installer.path")
-- local shell = require("nvim-lsp-installer.installers.shell")
-- local server = require("nvim-lsp-installer.server")
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
		print("lspconfig not okay in lsp_installer")
	return
end

local capabilities = function() return require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()) end

local M = {}

M.setup = function()
	local opts = {}
	opts.capabilities = capabilities()
	opts.on_attach = lsp_status.on_attach

	lsp_installer.setup {}
	lsp_status.register_progress()

	lspconfig.tsserver.setup {opts}
	lspconfig.vimls.setup {opts}
	lspconfig.sumneko_lua.setup {opts}
	lspconfig.rls.setup {opts}
	lspconfig.gopls.setup {opts}
	lspconfig.pyright.setup {opts}
  lspconfig.cssls.setup {opts}
	lspconfig.rust_analyzer.setup {opts}
	lspconfig.bashls.setup {opts}
	lspconfig.jsonls.setup {opts}
	lspconfig.html.setup {opts}
  lspconfig.salt_ls.setup {opts}
  lspconfig.clangd.setup {opts}
  lspconfig.cmake.setup {opts}
	lspconfig.dockerls.setup {opts}
	lspconfig.fortls.setup {opts}
  lspconfig.grammarly.setup {opts}
	lspconfig.jedi_language_server.setup {opts}
	lspconfig.vuels.setup {opts}
	lspconfig.pyright.setup {opts}
	lspconfig.texlab.setup {opts}
	lspconfig.yamlls.setup {opts}


	local runtime_path = vim.split(package.path, ';')
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")
	opts.settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = runtime_path,
			},
			diagnostics = {
				globals = { "vim", "execute" },
			},
			workspace = {
				library = {
					-- [vim.fn.expand("$VIMRUNTIME/lua")] = true,
					vim.api.nvim_get_runtime_file("", true),
					-- [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
				maxPreload = 10000,
				preloadFileSize = 1000,
			},
		},
	}
	lspconfig.sumneko_lua.setup {opts}

	vim.cmd([[ do User LspAttachBuffers ]])
end

return M
