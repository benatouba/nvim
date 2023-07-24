-- local execute = vim.api.nvim_command
-- local fn = vim.fn

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local lazy_ok, lazy = pcall(require, "lazy")
if not lazy_ok then
	vim.notify("lazy.nvim not okay")
	return
end

-- vim.cmd("autocmd BufWritePost plugins.lua PackerCompile profile=true")

lazy.setup({
		-- Packer can manage itself as an lazyional plugin
		"nvim-lua/popup.nvim", -- handle popup (important)
		"nvim-lua/plenary.nvim", -- most important functions (very important)
		{
			"glepnir/lspsaga.nvim",
			-- lazy = true,
			branch = "main",
			event = "LspAttach",
			config = function()
				require("lsp.lspsaga").config()
			end,
			dependencies = {
				"nvim-web-devicons",
				"nvim-treesitter",
			}
		},
		{
			"rcarriga/nvim-notify",
			config = function()
				vim.notify = require("notify")
				require("telescope").load_extension("notify")
			end,
			dependencies = "telescope.nvim",
		},
		{
			"nvim-neorg/neorg",
			event = { "BufReadPost", "VimEnter" },
			config = function()
				require("management.neorg").config()
			end,
			build = ":Neorg sync-parsers",
			dependencies = { "plenary.nvim", "nvim-neorg/neorg-telescope" },
		},
		{
			"benatouba/obsidian.nvim",
			event = { "BufReadPost" },
			config = function()
				require("management.obsidian").config()
			end
		},
		{
			"Tastyep/structlog.nvim",
			-- deactivate = false,
			dependencies = "nvim-notify",
			-- config = function()
			-- 	require("base.structlog")
			-- end,
		},
		{
			"lewis6991/impatient.nvim",
			config = function()
				require("impatient")
			end,
			enabled = false,
		}
		,
		{
			"SmiteshP/nvim-navic",
			event = "InsertEnter",
			dependencies = "nvim-lspconfig"
		},
		{
			"nvim-telescope/telescope-fzf-writer.nvim",
			dependencies = "telescope.nvim",
		},
		-- {
		--     "nvim-telescope/telescope-fzf-native.nvim",
		--     build = "make",
		--     dependencies = "telescope.nvim",
		--     lazy = true,
		--     cmd = "Telescope",
		--     event = "BufReadPost",
		--     config = function()
		--         require("telescope").load_extension("fzf")
		--     end,
		-- },
		-- "tami5/sql.nvim",
		{
			"nvim-telescope/telescope-frecency.nvim",
			dependencies = {
				"telescope.nvim",
				"tami5/sql.nvim",
			},
			-- config = function() require('telescope').load_extension('frecency') end,
		},
		{
			"nvim-telescope/telescope.nvim",
			config = function()
				require("base.telescope").config()
			end,
			-- cmd = "Telescope",
			-- event = "InsertEnter",
		},
		{
			"ahmedkhalf/project.nvim",
			config = function()
				require("base.project").setup()
			end,
			dependencies = "telescope.nvim",
		},

		-- help me find my way  around,
		"folke/which-key.nvim",

		-- Colorize hex and other colors in code,
		{
			"nvchad/nvim-colorizer.lua",
			config = function()
				require("colorizer").setup()
			end,
			event = "BufReadPost",
		},
		-- use("sheerun/vim-polyglot")

		-- Icons and visuals
		"kyazdani42/nvim-web-devicons",
		{
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("base.indent-blankline").config()
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = {
				"nvim-web-devicons",
				-- "nvim-lua/lsp-status.nvim",
				-- "arkav/lualine-lsp-progress",
			},
			config = function()
				require("base.lualine").config()
			end,
		},
		{
			"romgrk/barbar.nvim",
			config = function()
				require("ui.barbar").config()
			end,
		},
		{
			'echasnovski/mini.bracketed',
			version = false,
			config = function()
				require("mini.bracketed").setup({})
			end
		},
		{
			"kyazdani42/nvim-tree.lua",
			lazy = true,
			cmd = "NvimTreeToggle",
			config = function()
				require("base.nvim-tree").config()
			end,
		},

		-- manipulation
		{
			"monaqa/dial.nvim",
			config = function()
				require("base.dial").config()
			end,
		}, -- increment/decrement basically everything,
		{
			"numToStr/Comment.nvim",
			config = function()
				require("base.comment_nvim").config()
			end,
		},
		{ "mbbill/undotree",                             lazy = true, cmd = "UndotreeToggle" },
		{
			"kylechui/nvim-surround",
			config = function()
				require("nvim-surround").setup({})
			end,
		},

		-- language specific,
		"saltstack/salt-vim",
		"Glench/Vim-Jinja2-Syntax",

		-- Treesitter,
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				require("language_parsing.treesitter").config()
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter-refactor",
			dependencies = "nvim-treesitter",
		},
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			dependencies = "nvim-treesitter",
		},
		{ "p00f/nvim-ts-rainbow",           dependencies = "nvim-treesitter" },
		{ "RRethy/nvim-treesitter-endwise", dependencies = "nvim-treesitter" },
		{ "windwp/nvim-ts-autotag",         dependencies = "nvim-treesitter" },
		{
			"windwp/nvim-autopairs",
			dependencies = "nvim-treesitter",
			config = function()
				require("language_parsing.autopairs")
			end,
		},
		{
			"JoosepAlviste/nvim-ts-context-commentstring",
			dependencies = "nvim-treesitter",
		},
		{
			"ray-x/lsp_signature.nvim",
			config = function()
				require("lsp_signature").setup({
					bind = true, -- This is mandatory, otherwise border config won't get registered.
					handler_lazys = {
						border = "rounded"
					}
				})
				vim.keymap.set({ 'i' }, '<C-k>', function()
					require('lsp_signature').signature_help()
				end, { silent = true, noremap = true, desc = 'toggle signature' })
			end,
			enabled = false,
		},
		{
			"zbirenbaum/copilot.lua",
			config = function()
				require("lsp.copilot").config()
			end,
		},
		{"williamboman/mason.nvim", build = ":MasonUpdate", config = function()
			require("mason").setup()
		end,},
		"williamboman/mason-lspconfig.nvim",
		"jay-babu/mason-null-ls.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		{
			"neovim/nvim-lspconfig",
			event = "BufReadPre",
			config = function()
				require("lsp")
			end,
		},
		{
			"hrsh7th/nvim-cmp",
			event = { "InsertEnter", "CmdlineEnter" },
			dependencies = {
				"rafamadriz/friendly-snippets",
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
				{ "David-Kunz/cmp-npm", filetype = { "javascript", "vue", "typescript" } },
				{ "L3MON4D3/LuaSnip",   dependencies = "friendly-snippets", build = "make install_jsregexp", },
				"saadparwaiz1/cmp_luasnip",
				{ "kdheepak/cmp-latex-symbols", ft = "latex" },
				"f3fora/cmp-spell",
				"quangnguyen30192/cmp-nvim-tags",
				"octaltree/cmp-look",
				"tamago324/cmp-zsh",
				"onsails/lspkind-nvim",
			},
			config = function()
				require("lsp.cmp").config()
			end,
		},
		{
			"jose-elias-alvarez/nvim-lsp-ts-utils",
			dependencies = "nvim-lspconfig",
			ft = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
		},
		{
			"folke/trouble.nvim",
			cmd = { "TroubleToggle", "Trouble", "Gitsigns setqflist", "Gitsigns setloclist" },
			keys = { "]d", "[d", "<leader>g" }
		},
		{
			"jose-elias-alvarez/null-ls.nvim",
			-- event = { "BufReadPost", "InsertEnter" },
			-- fn = { "edit", "e" },
			-- cmd = { "LspStart", "LspInfo", "TSUpdate" },
			-- config = function()
			-- require("null-ls").setup()
			-- require("lsp.null-ls").config()
			-- end,
		}
		,
		{
			"tpope/vim-fugitive",
			lazy = false,
			-- cmd = {"G", "Git push", "Git pull", "Gdiffsplit!", "Gvdiffsplit!"}
		},
		{
			"NeogitOrg/neogit",
			dependencies = { "sindrets/diffview.nvim" },
			cmd = "Neogit",
			keys = "<leader>g",
			config = function()
				require("git.neogit").config()
			end,
		},
		{
			"lewis6991/gitsigns.nvim",
			config = function()
				require("git.gitsigns").config()
			end,
			event = "BufReadPost",
		},
		{
			"nvim-neotest/neotest",
			event = "BufReadPost",
			lazy = true,
			dependencies = {
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
		},

		-- debug adapter protocol
		{
			"mfussenegger/nvim-dap",
			dependencies = {
				"theHamsta/nvim-dap-virtual-text",
			},
			config = function()
				require("debug.dap").config()
			end,
		},
		{
			"rcarriga/nvim-dap-ui",
			event = "BufReadPost",
			dependencies = {
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
		},
		{
			"jbyuki/one-small-step-for-vimkind",
			dependencies = "nvim-dap",
			ft = "lua",
			config = function()
				require("debug.one_small_step_for_vimkind").config()
			end,
		},
		{
			"nvim-telescope/telescope-dap.nvim",
			dependencies = { "nvim-dap", "telescope.nvim" },
			keys = "<leader>d",
			config = function()
				require("telescope").load_extension("dap")
			end,
		},
		{
			"mxsdev/nvim-dap-vscode-js",
			dependencies = { "mfussenegger/nvim-dap" },
			config = function()
				require("debug.vscode_js")
			end,
			ft = { "javascript", "typescript", },
		},
		{
			"microsoft/vscode-js-debug",
			lazy = true,
			build = "pnpm install --legacy-peer-deps && pnpm run compile",
		},

		-- project management
		{
			"nvim-orgmode/orgmode.nvim",
			-- keys = "<leader>o",
			config = function()
				require("management.orgmode")
			end,
		},
		{
			"renerocksai/telekasten.nvim",
			event = "BufReadPost",
			dependencies = { "telescope.nvim", "renerocksai/calendar-vim" },
			config = function()
				require("management.telekasten").config()
			end,
		},

		-- miscellaneous,
		"kevinhwang91/nvim-bqf",
		{ "stevearc/overseer.nvim", config = function() require("overseer").setup() end },
		{
			"andymass/vim-matchup",
			config = function()
				vim.g.matchup_matchparen_offscreen = { method = "popup" }
				vim.g.matchup_surround_enabled = 1
			end,
			enabled = true,
		},
		{
			"folke/todo-comments.nvim",
			config = function()
				require("todo-comments").setup()
			end,
		},
		{
			"akinsho/toggleterm.nvim",
			-- tag = "*",
			config = function()
				require("toggleterm").setup({
					open_mapping = [[<c-\>]],
					direction = "horizontal",
					float_lazys = {
						border = "single",
						width = 120,
						height = 30,
						winblend = 3,
					},
				})
			end,
		},
		{
			"danymat/neogen",
			config = function()
				require("misc.neogen")
			end,
			dependencies = "nvim-treesitter/nvim-treesitter",
		},
		{
			"nvim-colortils/colortils.nvim",
			config = function()
				require("misc.colortils").config()
			end,
		},
		"wuelnerdotexe/vim-enfocado",
		{
			"folke/tokyonight.nvim",
			config = function()
				if O.colorscheme ~= "tokyonight" then
					return
				end
				require("tokyonight").setup({
					style = "storm",
					transparent = false,
					hide_inactive_statusline = false,
				})
			end,
		},
		{
			"catppuccin/nvim",
			as = "catppuccin",
			config = function()
				if O.colorscheme ~= "catppuccin" then
					return
				end
				require("catppuccin").setup({
					flavour = "mocha", -- mocha, macchiato, frappe, latte
					integrations = {
						barbar = true,
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
						vimwiki = false,
						which_key = true,
					},
				})
			end,
		},
		{
			"ThePrimeagen/refactoring.nvim",
			event = "BufReadPost",
			dependencies = {
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-treesitter/nvim-treesitter" },
			},
			config = function()
				require("misc.refactoring").config()
				require("misc.refactoring").maps()
			end,
		},
		{
			"iamcco/markdown-preview.nvim",
			ft = "markdown",
			build = "cd app && yarn install",
		},
		{ "szw/vim-maximizer" },
		{
			"anuvyklack/windows.nvim",
			dependencies = {
				"anuvyklack/middleclass",
				"anuvyklack/animation.nvim",
			},
			config = function()
				vim.o.winwidth = 10
				vim.o.winminwidth = 10
				vim.o.equalalways = false
				require("windows").setup()
			end,
		},
		-- { "dstein64/vim-startuptime" },
		{
			"kevinhwang91/nvim-hlslens",
			config = function()
				require("ui.hlslens").config()
			end,
		},
		-- for notebooks,
		-- use({
		-- 	"bfredl/nvim-ipy",
		-- 	ft = "ipynb",
		-- 	config = function()
		-- 		require("notebooks.nvim-ipy").config()
		-- 	end,
		-- })
		{
			"kiyoon/jupynium.nvim",
			build = "pip3 install --user .",
			-- config = function()
			-- 	require("jupynium").setup()
			-- end,
		},
		-- { "stevearc/dressing.nvim" },
		{
			"folke/noice.nvim",
			dependencies = {
				"MunifTanjim/nui.nvim",
				"rcarriga/nvim-notify",
			},
			config = function()
				require("ui.noice").config()
			end,
		}
	},
	{})