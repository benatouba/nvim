local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

local packer_ok, _ = pcall(require, "packer")
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({
		"git",
		"clone",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	execute("packadd packer.nvim")
	if not packer_ok then
		vim.notify("Packer not okay")
		return
	end
	execute("PackerSync")
end

if not packer_ok then
	vim.notify("Packer not okay")
	return
end

vim.cmd("autocmd BufWritePost plugins.lua PackerCompile profile=true")

return require("packer").startup({
	function(use)
		-- Packer can manage itself as an optional plugin
		use("wbthomason/packer.nvim") -- plugin manager
		use("nvim-lua/popup.nvim") -- handle popup (important)
		use("nvim-lua/plenary.nvim") -- most important functions (very important)
		use({
			"glepnir/lspsaga.nvim",
			opt = true,
			branch = "main",
			event = "LspAttach",
			config = function()
				require("lsp.lspsaga").config()
			end,
			requires = {
				{ "nvim-tree/nvim-web-devicons" },
				--Please make sure you install markdown and markdown_inline parser
				{ "nvim-treesitter/nvim-treesitter" }
			}
		})
		use({
			"rcarriga/nvim-notify",
			config = function()
				vim.notify = require("notify")
				require("telescope").load_extension("notify")
			end,
			after = "telescope.nvim",
		})
		use({
			"nvim-neorg/neorg",
			config = function()
				require("management.neorg").config()
			end,
			run = ":Neorg sync-parsers",
			requires = { "nvim-lua/plenary.nvim", "nvim-neorg/neorg-telescope" },
		})
		use({
			"benatouba/obsidian.nvim",
			config = function()
				require("management.obsidian").config()
			end
		})
		use({
			"Tastyep/structlog.nvim",
			deactivate = false,
			requires = "rcarriga/nvim-notify",
			after = "nvim-notify",
			-- config = function()
			-- 	require("base.structlog")
			-- end,
		})
		use({
			"lewis6991/impatient.nvim",
			config = function()
				require("impatient")
			end,
			disable = true,
		})

		use({
			"SmiteshP/nvim-navic",
			requires = "neovim/nvim-lspconfig"
		})
		use({
			"nvim-telescope/telescope-fzf-writer.nvim",
			after = "telescope.nvim",
		})
		use({
			"nvim-telescope/telescope-fzf-native.nvim",
			run = "make",
			after = "telescope.nvim",
			config = function()
				require("telescope").load_extension("fzf")
			end,
		})
		use({
			"nvim-telescope/telescope-frecency.nvim",
			requires = {
				"tami5/sql.nvim",
				{
					"zane-/howdoi.nvim",
					config = function()
						require("telescope").load_extension("howdoi")
					end,
				},
			},
			after = "telescope.nvim",
			-- config = function() require('telescope').load_extension('frecency') end,
		})
		use({
			"nvim-telescope/telescope.nvim",
			config = function()
				require("base.telescope").config()
			end,
			-- cmd = "Telescope",
			-- event = "InsertEnter",
		})
		use({
			"ahmedkhalf/project.nvim",
			config = function()
				require("base.project").setup()
			end,
			after = "telescope.nvim",
		})

		-- help me find my way  around
		use("folke/which-key.nvim")

		-- Color
		use({ "christianchiarulli/nvcode-color-schemes.vim", opt = true })
		use({
			"nvchad/nvim-colorizer.lua",
			config = function()
				require("colorizer").setup()
			end,
			event = "BufReadPost",
		})
		-- use("sheerun/vim-polyglot")

		-- Icons and visuals
		use("kyazdani42/nvim-web-devicons")
		use({
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("base.indent-blankline").config()
			end,
		})

		use({
			"nvim-lualine/lualine.nvim",
			requires = {
				{ "kyazdani42/nvim-web-devicons", opt = true },
				-- "nvim-lua/lsp-status.nvim",
				-- "arkav/lualine-lsp-progress",
			},
			config = function()
				require("base.lualine").config()
			end,
		})
		use({
			"nanozuki/tabby.nvim",
			config = function()
				require("base.tabby").config()
			end,
		})
		-- use("romgrk/barbar.nvim")
		use({
			"kyazdani42/nvim-tree.lua",
			-- opt = true,
			config = function()
				require("base.nvim-tree").config()
			end,
		})
		-- use({ "ms-jpq/chadtree", branch = "chad", run = ":CHADdeps" })

		-- manipulation
		use({
			"monaqa/dial.nvim",
			config = function()
				require("base.dial").config()
			end,
		}) -- increment/decrement basically everything
		use({
			"numToStr/Comment.nvim",
			config = function()
				require("base.comment_nvim").config()
			end,
		})
		use({ "mbbill/undotree", opt = true, cmd = "UndotreeToggle" })
		use({
			"kylechui/nvim-surround",
			config = function()
				require("nvim-surround").setup({})
			end,
		})

		-- language specific
		use("saltstack/salt-vim")
		use("Glench/Vim-Jinja2-Syntax")

		if O.language_parsing then
			-- Treesitter
			use({
				"nvim-treesitter/nvim-treesitter",
				run = ":TSUpdate",
			})
			use({
				"nvim-treesitter/nvim-treesitter-refactor",
				after = "nvim-treesitter",
			})
			use({
				"nvim-treesitter/nvim-treesitter-textobjects",
				after = "nvim-treesitter",
			})
			use({ "p00f/nvim-ts-rainbow", after = "nvim-treesitter" })
			use({ "RRethy/nvim-treesitter-endwise", after = "nvim-treesitter" })
			use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" })
			use({
				"windwp/nvim-autopairs",
				after = "nvim-treesitter",
				config = function()
					require("language_parsing.autopairs")
				end,
			})
			use({
				"JoosepAlviste/nvim-ts-context-commentstring",
				after = "nvim-treesitter",
			})
		end

		use({
			"ray-x/lsp_signature.nvim",
			config = function()
				require("lsp_signature").setup({
					bind = true, -- This is mandatory, otherwise border config won't get registered.
					handler_opts = {
						border = "rounded"
					}
				})
				vim.keymap.set({ 'i' }, '<C-k>', function()
					require('lsp_signature').signature_help()
				end, { silent = true, noremap = true, desc = 'toggle signature' })
			end,
			disable = true,
		})
		use({
			"zbirenbaum/copilot.lua",
			config = function()
				require("lsp.copilot").config()
			end,
		})
		use({
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			{ "ckipp01/stylua-nvim", run = "cargo install stylua" },
			"jay-babu/mason-null-ls.nvim",
			"jay-babu/mason-nvim-dap.nvim",
			{
				"neovim/nvim-lspconfig",
				config = function()
					require("lsp")
				end,
			},
			-- event = { "CmdlineEnter", "InsertEnter" },
		})
		use({
			"hrsh7th/nvim-cmp",
			-- event = "InsertEnter",
			requires = {
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-nvim-lsp-document-symbol",
				"hrsh7th/cmp-nvim-lsp-signature-help",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-calc",
				"hrsh7th/cmp-emoji",
				"hrsh7th/cmp-cmdline",
				"rcarriga/cmp-dap",
				"petertriho/cmp-git",
				"andersevenrud/compe-tmux",
				"ray-x/cmp-treesitter",
				"lukas-reineke/cmp-under-comparator",
				"lukas-reineke/cmp-rg",
				{ "David-Kunz/cmp-npm",         filetype = { "javascript", "vue", "typescript" } },
				{"L3MON4D3/LuaSnip", requires = "rafamadriz/friendly-snippets"},
				"saadparwaiz1/cmp_luasnip",
				{ "kdheepak/cmp-latex-symbols", ft = "latex" },
				"f3fora/cmp-spell",
				"quangnguyen30192/cmp-nvim-tags",
				"octaltree/cmp-look",
				"tamago324/cmp-zsh",
				"onsails/lspkind-nvim",
				-- {
				-- 	"zbirenbaum/copilot-cmp",
				-- 	after = { "copilot.lua" },
				-- 	config = function()
				-- 		require("copilot_cmp").setup()
				-- 	end,
				-- },
			},
			config = function()
				require("lsp.cmp").config()
			end,
		})
		use({
			"jose-elias-alvarez/nvim-lsp-ts-utils",
			-- after = "nvim-lspconfig",
			ft = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
		})
		use({
			"folke/trouble.nvim",
			cmd = { "TroubleToggle", "Trouble", "Gitsigns setqflist", "Gitsigns setloclist" },
			keys = { "]d", "[d", "<leader>g" }
		})
		use({
			"jose-elias-alvarez/null-ls.nvim",
			-- event = { "BufReadPost", "InsertEnter" },
			-- fn = { "edit", "e" },
			-- cmd = { "LspStart", "LspInfo", "TSUpdate" },
			-- config = function()
			-- require("null-ls").setup()
			-- require("lsp.null-ls").config()
			-- end,
		})

		use({
			"tpope/vim-fugitive",
			opt = false,
			-- cmd = {"G", "Git push", "Git pull", "Gdiffsplit!", "Gvdiffsplit!"}
		})
		use({
			"NeogitOrg/neogit",
			requires = { "sindrets/diffview.nvim" },
			cmd = "Neogit",
		})
		use({
			"lewis6991/gitsigns.nvim",
			config = function()
				require("git.gitsigns").config()
			end,
			event = "BufReadPost",
		})

		use({
			"nvim-neotest/neotest",
			requires = {
				"nvim-neotest/neotest-python",
				"marilari88/neotest-vitest",
				"nvim-neotest/neotest-vim-test",
				"vim-test/vim-test",
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
				"antoinemadec/FixCursorHold.nvim",
			},
			config = function()
				require("test.neotest").config()
			end,
		})

		-- debug adapter protocol
		use({
			"mfussenegger/nvim-dap",
			requires = {
				"theHamsta/nvim-dap-virtual-text",
			},
			config = function()
				require("debug.dap").config()
			end,
		})
		-- use({
		-- 	"mfussenegger/nvim-dap-python",
		-- 	ft = "python",
		-- 	config = function()
		-- 		require("debug.dap_python").config()
		-- 	end,
		-- })
		use({
			"rcarriga/nvim-dap-ui",
			requires = {
				"mfussenegger/nvim-dap",
				{
					"folke/neodev.nvim",
					config = function()
						require("neodev").setup({
							library = { plugins = { "nvim-dap-ui", "neotest" }, types = true },
						})
					end,
				},
			},
			config = function()
				require("debug.dapui").config()
			end,
			deactivate = true,
		})
		-- use({ "Pocco81/DAPInstall.nvim", after = "nvim-dap" })
		use({
			"jbyuki/one-small-step-for-vimkind",
			after = "nvim-dap",
			ft = "lua",
			config = function()
				require("debug.one_small_step_for_vimkind").config()
			end,
		})
		use({
			"nvim-telescope/telescope-dap.nvim",
			config = function()
				require("telescope").load_extension("dap")
			end,
		})
		use({
			"mxsdev/nvim-dap-vscode-js",
			requires = { "mfussenegger/nvim-dap" },
			config = function()
				require("debug.vscode_js")
			end,
			ft = { "javascript", "typescript", "vue" },
		})
		use({
			"microsoft/vscode-js-debug",
			opt = true,
			run = "pnpm install --legacy-peer-deps && pnpm run compile",
		})

		-- project management
		use({
			"nvim-orgmode/orgmode.nvim",
			-- keys = "<leader>o",
			config = function()
				require("management.orgmode")
			end,
		})
		use({
			"renerocksai/telekasten.nvim",
			after = "telescope.nvim",
			requires = { "renerocksai/calendar-vim" },
			config = function()
				require("management.telekasten").config()
			end,
		})

		-- miscellaneous
		use("kevinhwang91/nvim-bqf")
		use({ "stevearc/overseer.nvim", config = function() require("overseer").setup() end })
		use("andymass/vim-matchup")
		use({
			"GustavoKatel/sidebar.nvim",
			config = function()
				require("sidebar-nvim").setup({
					bindings = {
						["q"] = function()
							require("sidebar-nvim").close()
						end,
					},
				})
			end,
			disable = true,
		})
		use({
			"folke/todo-comments.nvim",
			config = function()
				require("todo-comments").setup()
			end,
		})
		use({
			"numtostr/FTerm.nvim",
			disable = true,
			-- config = function() require("FTerm") end
		})
		use({
			"akinsho/toggleterm.nvim",
			tag = "*",
			config = function()
				require("toggleterm").setup({
					open_mapping = [[<c-\>]],
					direction = "horizontal",
					float_opts = {
						border = "single",
						width = 120,
						height = 30,
						winblend = 3,
					},
				})
			end,
		})
		use({
			"danymat/neogen",
			config = function()
				require("misc.neogen")
			end,
			requires = "nvim-treesitter/nvim-treesitter",
		})
		use({
			"nvim-colortils/colortils.nvim",
			config = function()
				require("misc.colortils").config()
			end,
		})
		use("wuelnerdotexe/vim-enfocado")
		use({
			"folke/tokyonight.nvim",
			config = function()
				require("tokyonight").setup({
					style = "night",
					transparent = false,
					hide_inactive_statusline = false,
				})
			end,
		})
		use({
			"catppuccin/nvim",
			as = "catppuccin",
			config = function()
				require("catppuccin").setup({
					flavour = "mocha", -- mocha, macchiato, frappe, latte
					integrations = {
						barbar = false,
						cmp = true,
						dap = {
							enabled = true,
							enable_ui = true,
						},
						gitsigns = true,
						harpoon = true,
						indent_blankline = {
							enabled = true,
							colored_indent_levels = true,
						},
						lsp_saga = true,
						lsp_trouble = true,
						markdown = true,
						mason = true,
						native_lsp = {
							enabled = true,
							virtual_text = {
								errors = { "italic" },
								hints = { "italic" },
								warnings = { "italic" },
								information = { "italic" },
							},
							underlines = {
								errors = { "underline" },
								hints = { "underline" },
								warnings = { "underline" },
								information = { "underline" },
							},
							inlay_hints = {
								background = true,
							},
						},
						neogit = true,
						neotest = true,
						noice = true,
						notify = true,
						nvimtree = true,
						telekasten = true,
						telescope = true,
						treesitter = true,
						treesitter_context = true,
						ts_rainbow = true,
						overseer = true,
						vimwiki = true,
						which_key = true,
					},
				})
			end,
		})
		use({
			"ThePrimeagen/refactoring.nvim",
			requires = {
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-treesitter/nvim-treesitter" },
			},
			config = function()
				require("misc.refactoring").config()
				require("misc.refactoring").maps()
			end,
		})
		use({ "iamcco/markdown-preview.nvim", ft = "markdown", run = "cd app && yarn install" })
		use({ "szw/vim-maximizer" })
		use({
			"anuvyklack/windows.nvim",
			requires = {
				"anuvyklack/middleclass",
				-- "anuvyklack/animation.nvim",
			},
			config = function()
				vim.o.winwidth = 10
				vim.o.winminwidth = 10
				vim.o.equalalways = false
				require("windows").setup()
			end,
		})
		use({ "dstein64/vim-startuptime" })
		use({
			"kevinhwang91/nvim-hlslens",
			config = function()
				require("hlslens").setup({
					calm_down = true,
				})
			end,
		})
		-- for notebooks
		-- use({
		-- 	"bfredl/nvim-ipy",
		-- 	ft = "ipynb",
		-- 	config = function()
		-- 		require("notebooks.nvim-ipy").config()
		-- 	end,
		-- })
		use({
			"kiyoon/jupynium.nvim",
			run = "pip3 install --user .",
			-- config = function()
			-- 	require("jupynium").setup()
			-- end,
		})
		use({ "stevearc/dressing.nvim" })
		use({
			"folke/noice.nvim",
			requires = {
				"MunifTanjim/nui.nvim",
				"rcarriga/nvim-notify",
			},
			config = function()
				require("noice").setup({
					lsp = {
						override = {
							["vim.lsp.util.convert_input_to_markdown_lines"] = false,
							["vim.lsp.util.stylize_markdown"] = false,
							["cmp.entry.get_documentation"] = false,
						}
					},
					-- you can enable a preset for easier configuration
					presets = {
						bottom_search = true, -- use a classic bottom cmdline for search
						command_palette = false, -- position the cmdline and popupmenu together
						long_message_to_split = true, -- long messages will be sent to a split
						inc_rename = false, -- enables an input dialog for inc-rename.nvim
						lsp_doc_border = true, -- add a border to hover docs and signature help
					},
					cmdline = {
						enabled = true,
						view = "cmdline"
					}
				})
			end,
		})
	end,
	config = {
		profile = {
			enable = true,
			threshold = 1, -- the amount in ms that a plugins load time must be over for it to be included in the profile
		},
		compile_path = O.packer_compile_path,
	},
})