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
-- local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
--
local capabilities = function() return require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()) end


local M = {}

M.setup = function()
	lsp_status.register_progress()
	lsp_installer.on_server_ready(function(serv)
		local opts = {}
		opts.capabilities = capabilities()
		opts.on_attach = lsp_status.on_attach
		-- if serv.name == "sumneko_lua" then
		-- 	local runtime_path = vim.split(package.path, ';')
		-- 	table.insert(runtime_path, "lua/?.lua")
		-- 	table.insert(runtime_path, "lua/?/init.lua")
		-- 	opts.settings = {
		-- 		Lua = {
		-- 			runtime = {
		-- 				version = "LuaJIT",
		-- 				path = runtime_path,
		-- 			},
		-- 			diagnostics = {
		-- 				globals = { "vim", "execute" },
		-- 			},
		-- 			workspace = {
		-- 				library = {
		-- 					-- [vim.fn.expand("$VIMRUNTIME/lua")] = true,
		-- 					vim.api.nvim_get_runtime_file("", true),
		-- 					-- [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
		-- 				},
		-- 				maxPreload = 10000,
		-- 				preloadFileSize = 1000,
		-- 			},
		-- 		},
		-- 	}
		-- end
		serv:setup(opts)
		vim.cmd([[ do User LspAttachBuffers ]])
	end)
end


return M
