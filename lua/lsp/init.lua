-- LSP signs default
vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "", numhl = "DiagnosticSignHint" })
vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", text = "", numhl = "DiagnosticSignInfo" })
vim.fn.sign_define(
	"DiagnosticSignWarning",
	{ texthl = "DiagnosticSignWarning", text = "", numhl = "DiagnosticSignWarning", }
)
vim.fn.sign_define(
	"DiagnosticSignError",
	{ texthl = "DiagnosticSignError", text = "", numhl = "DiagnosticSignError" }
)

-- LSP Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = false,
	underline = true,
	signs = true,
	update_in_insert = true,
	severity_sort = true,
})

local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
	vim.notify("mason not okay in lspconfig")
	return
end
mason.setup({})

local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then
	vim.notify("mason-lspconfig not okay in lspconfig")
	return
end
mason_lspconfig.setup({})

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
	vim.notify("lspconfig not okay in lspconfig")
	return
end

-- local mason_nvim_dap_ok, mason_nvim_dap = pcall(require, "mason-nvim-dap")
-- if not mason_nvim_dap_ok then
-- 	vim.notify("mason-nvim-dap not okay in lspconfig")
-- 	return
-- end
-- mason_nvim_dap.setup({
--   ensure_installed = { "python" },
--   -- handlers = {},
-- })

local common_on_attach = function(client, bufnr)
	vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })
	if client.server_capabilities.documentSymbolProvider then
		require("nvim-navic").attach(client, bufnr)
	end
end

local lsp_defaults = {
	flags = {
		debounce_text_changes = 150,
	},
	capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
	on_attach = common_on_attach,
}

lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, lsp_defaults)
require("mason-lspconfig").setup_handlers({
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup({})
	end,
	["bashls"] = function()
		lspconfig.bashls.setup({
			filetypes = { "sh", "zsh", "bash", "ksh", "dash" },
		})
	end,
	["pylsp"] = function()
		local lsputil = require("lspconfig/util")

		Get_python_venv = function()
			vim.fn.system("pyenv init")
			vim.fn.system("pyenv init -")

			if vim.env.VIRTUAL_ENV then
				return vim.env.VIRTUAL_ENV
			end

			local match = vim.fn.glob(lsputil.path.join(vim.fn.getcwd(), "Pipfile"))
			if match ~= "" then
				return vim.fn.trim(vim.fn.system("PIPENV_PIPFILE=" .. match .. " pipenv --venv"))
			end

			match = vim.fn.glob(lsputil.path.join(vim.fn.getcwd(), "poetry.lock"))
			if match ~= "" then
				return vim.fn.trim(vim.fn.system("poetry env info -p"))
			end
			match = vim.fn.glob(lsputil.path.join(vim.fn.getcwd(), ".python_version"))
			if match ~= "" then
				return vim.fn.trim(vim.fn.system("pyenv prefix"))
			end
		end
		local venv = Get_python_venv()

		lspconfig.pylsp.setup({
			filetypes = { "python", "djangopython", "django", "jupynium" },
			capabilities = lsp_defaults.capabilities,
			cmd = { "pylsp", "-v" },
			cmd_env = { VIRTUAL_ENV = venv, PATH = lsputil.path.join(venv, "bin") .. ":" .. vim.env.PATH },
			on_attach = lsp_defaults.on_attach,
			single_file_support = true,
			settings = {
				pylsp = {
					plugins = {
						autopep8 = { enabled = false },
						flake8 = { enabled = false },
						pycodestyle = { enabled = false, maxLineLength = 100 },
						pyflakes = { enabled = false },
						pydocstyle = { enabled = false },
						mccabe = { enabled = false },
						memestra = { enabled = false },
						mypy = { enabled = true },
						pylint = { enabled = false },
						rope_autimport = { enabled = true },
						rope_completion = { enabled = false },
						ruff = { enabled = false, lineLength = 100 },
						black = { enabled = true, line_length = 100 },
						yapf = { enabled = false },
						jedi = {
							auto_import_modules = {
								"numpy",
								"pandas",
								"salem",
								"matplotlib",
								"Django",
								"djangorestframework",
								"manim",
								"typing",
								"plotly",
								"dash",
								"dash_bootstrap_components",
							},
						},
						jedi_completion = { enabled = true, eager = true, fuzzy = true },
					},
				},
			},
		})
	end,
	["lua_ls"] = function()
		local runtime_path = vim.split(package.path, ";", {})
		table.insert(runtime_path, "lua/?.lua")
		table.insert(runtime_path, "lua/?/init.lua")
		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
						path = runtime_path,
					},
					diagnostics = {
						enable = true,
						globals = { "vim" },
					},
					workspace = {
						library = {
							vim.api.nvim_get_runtime_file("", true),
							"${3rd}/luv/library",
						},
						maxPreload = 10000,
						preloadFileSize = 1000,
						checkThirdParty = true,
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})
	end,
	["sourcery"] = function()
		lspconfig.sourcery.setup({
			init_options = {
				token = require("secrets").sourcery,
				extension_version = "vim.lsp",
				editor_version = "nvim",
			},
			settings = {
				sourcery = {
					metricsEnabled = false,
				},
			},
		})
	end,
	["eslint"] = function()
		lspconfig.eslint.setup({
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
		})
	end,
	["volar"] = function()
		local util = require("lspconfig.util")
		local function get_typescript_server_path(root_dir)
			-- local global_ts = "$PNPM_HOME/global/5"
			local global_ts = "/home/ben/.local/share/pnpm/global/5/node_modules/typescript/lib"
			-- local global_ts = "/usr/local/lib"
			local found_ts = ""
			local function check_dir(path)
				found_ts = util.path.join(path, "node_modules", "typescript", "lib")
				if util.path.exists(found_ts) then
					return path
				end
			end

			if util.search_ancestors(root_dir, check_dir) then
				return found_ts
			else
				util.path.exists(global_ts)
				-- vim.notify("Using global typescript")
				return global_ts
			end
		end

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		lspconfig.volar.setup({
			capabilities = lsp_defaults.capabilities,
			cmd = { "vue-language-server", "--stdio" },
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
			init_options = {
				volar = {
					format = {
						initialIndent = true,
					}
				},
				documentFeatures = {
					documentColor = true,
					documentFormatting = {
						defaultPrintWidth = 100,
					},
					documentSymbol = true,
					foldingRange = true,
					linkedEditingRange = true,
					selectionRange = true,
				},
				languageFeatures = {
					callHierarchy = true,
					codeAction = true,
					codeLens = {
						references = true,
						pugTools = true,
						scriptSetupTools = true,
					},
					completion = {
						defaultAttrNameCase = "kebabCase",
						defaultTagNameCase = "both",
					},
					definition = true,
					diagnostics = true,
					documentHighlight = true,
					documentLink = true,
					hover = true,
					implementation = true,
					references = true,
					rename = true,
					renameFileRefactoring = true,
					schemaRequestService = true,
					semanticTokens = true,
					signatureHelp = true,
					typeDefinition = true,
				},
				typescript = {
					tsdk = "",
				},
			},
			on_attach = function(client)
				client.server_capabilities.documentFormattingProvider = true
				client.server_capabilities.documentRangeFormattingProvider = true
				client.server_capabilities.renameProvider = true
			end,
			on_new_config = function(new_config, new_root_dir)
				new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
			end,
		})
	end,
	["texlab"] = function()
		lspconfig.texlab.setup({
			settings = {
				texlab = {
					build = {
						args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
						executable = "latexmk",
						forwardSearchAfter = false,
						onSave = false,
					},
					chktex = {
						onEdit = true,
						onOpenAndSave = true,
					},
					diagnosticsDelay = 300,
					forwardSearch = {
						args = {},
						executable = "zathura",
						onSave = true,
					},
					latexFormatter = "latexindent",
					latexindent = {
						modifyLineBreaks = false,
					},
				},
			},
		})
	end,
})