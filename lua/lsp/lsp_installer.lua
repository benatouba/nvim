local lspi_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not lspi_ok then
	print("nvim-lsp-installer not okay")
	return
end
local servers = require("nvim-lsp-installer.servers")
local path = require("nvim-lsp-installer.path")
local shell = require("nvim-lsp-installer.installers.shell")
local server = require("nvim-lsp-installer.server")
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
-- capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities.textDocument.completion.completionItem.preselectSupport = true
-- capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
-- capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
-- capabilities.textDocument.completion.completionItem.deprecatedSupport = true
-- capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
-- capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
-- capabilities.textDocument.completion.completionItem.resolveSupport = {
--   properties = {
--     'documentation',
--     'detail',
--     'additionalTextEdits',
--   },
-- }

-- local register_salt_ls = function()
-- local root_dir = server.get_server_root_path("salt")
-- local root_dir = vim.fn.stdpath("data") .. "/lsp_servers/salt"
-- local installer_chain = {
-- 	shell.polyshell("Not implemented. Install manually."),
-- shell.polyshell("mkdir -p " .. root_dir),
-- shell.polyshell("cd " .. root_dir .. " && git clone https://github.com/dcermak/salt-lsp.git ."),
-- shell.polyshell("cd " .. root_dir .. " && python3 -m venv venv"),
-- shell.polyshell("cd " .. root_dir .. " && ./venv/bin/pip3 install poetry"),
-- shell.polyshell("cd " .. root_dir .. " && git pull"),
-- shell.polyshell(
-- 	"cd "
-- 		.. root_dir
-- 		.. " && ./venv/bin/poetry install && ./venv/bin/poetry run dump_state_name_completions && ./venv/bin/poetry build"
-- ),
-- shell.polyshell(
-- 	"cd " .. root_dir .. " && ./venv/bin/pip3 install --force-reinstall dist/salt_lsp-0.0.1-py3-none-any.whl"
-- ),
-- }

-- 	local salt_ls = server.Server:new({
-- 		name = "salt",
-- 		root_dir = root_dir,
-- 		installer = installer_chain,
-- 		default_options = {
-- 			cmd = { root_dir .. "/venv/bin/python3", "-m", "salt_lsp" },
-- 		},
-- 	})
-- 	servers.register(salt_ls)
-- end

local M = {}

M.setup = function()
	-- if lspconfig_ok then
	-- 	register_salt_ls()
	-- else
	-- 	P("lspconfig not okay")
	-- end
	lsp_installer.on_server_ready(function(serv)
		local opts = {}
		opts.capabilities = capabilities
		if serv.name == "sumneko_lua" then
			opts.settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
						path = vim.split(package.path, ";"),
					},
					diagnostics = {
						globals = { "vim", "execute" },
					},
					workspace = {
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
						},
						maxPreload = 10000,
						preloadFileSize = 1000,
					},
				},
			}
		end
		opts.workspace = serv:setup({ opts })
		vim.cmd([[ do User LspAttachBuffers ]])
	end)
end

return M
