-- local execute = vim.api.nvim_command
-- local fn = vim.fn

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",  -- latest stable release
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
  "nvim-lua/popup.nvim",  -- handle popup (important)
  "nvim-lua/plenary.nvim",  -- most important functions (very important)
  {
    "nvimdev/lspsaga.nvim",
    -- lazy = true,
    branch = "main",
    event = "LspAttach",
    config = function ()
      require("lsp.lspsaga").config()
    end,
    dependencies = {
      "nvim-web-devicons",
      "nvim-treesitter",
      "nvim-lspconfig",
    },
  },
  {
    "rcarriga/nvim-notify",
    config = function ()
      vim.notify = require("notify")
      require("telescope").load_extension("notify")
    end,
    dependencies = "telescope.nvim",
    enabled = true,
  },
  {
    "nvim-neorg/neorg",
    -- lazy = true,
    -- event = { "BufReadPost", "VimEnter" },
    config = function ()
      require("management.neorg").config()
    end,
    build = ":Neorg sync-parsers",
    dependencies = { "plenary.nvim", "nvim-neorg/neorg-telescope" },
    enabled = true,
  },
  {
    "epwalsh/obsidian.nvim",
    event = { "BufReadPost" },
    config = function ()
      require("management.obsidian").config()
    end,
    enabled = false,
  },
  {
    "lewis6991/impatient.nvim",
    config = function ()
      require("impatient")
    end,
    enabled = false,
  },
  {
    "nvim-telescope/telescope-fzf-writer.nvim",
    dependencies = "telescope.nvim",
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    -- dependencies = "telescope.nvim",
    -- lazy = true,
    -- cmd = "Telescope",
    -- event = "BufReadPost",
    -- config = function()
    -- 	require("telescope").load_extension("fzf")
    -- end,
  },
  -- "tami5/sql.nvim",
  {
    "nvim-telescope/telescope-frecency.nvim",
    dependencies = {
      "telescope.nvim",
      "tami5/sql.nvim",
    },
    enabled = false,
    -- config = function() require('telescope').load_extension('frecency') end,
  },
  {
    "nvim-telescope/telescope.nvim",
    config = function ()
      require("base.telescope").config()
    end,
    dependencies = "telescope-fzf-native.nvim",
    -- cmd = "Telescope",
    -- event = "InsertEnter",
  },
  {
    "ahmedkhalf/project.nvim",
    config = function ()
      require("base.project").setup()
    end,
    dependencies = "telescope.nvim",
  },

  -- help me find my way  around,
  "folke/which-key.nvim",

  -- Colorize hex and other colors in code,
  {
    "nvchad/nvim-colorizer.lua",
    config = function ()
      require("colorizer").setup()
    end,
    event = "BufReadPost",
    enabled = true,
  },
  -- use("sheerun/vim-polyglot")

  -- Icons and visuals
  "kyazdani42/nvim-web-devicons",
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function ()
      require("base.indent-blankline").config()
    end,
    dependencies = "nvim-treesitter",
    event = "BufReadPost",
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-web-devicons",
      -- "nvim-lua/lsp-status.nvim",
      -- "arkav/lualine-lsp-progress",
    },
    config = function ()
      require("base.lualine").config()
    end,
    enabled = true,
  },
  {
    "romgrk/barbar.nvim",
    config = function ()
      require("ui.barbar").config()
    end,
    lazy = true,
    enabled = true,
  },
  {
    "echasnovski/mini.bracketed",
    version = false,
    config = function ()
      require("mini.bracketed").setup()
    end,
  },
  {
    "kyazdani42/nvim-tree.lua",
    lazy = true,
    cmd = "NvimTreeToggle",
    config = function ()
      require("base.nvim-tree").config()
    end,
    enabled = true,
  },

  -- manipulation
  {
    "monaqa/dial.nvim",
    config = function ()
      require("base.dial").config()
    end,
    keys = { "<C-a>", "<C-x>" },
  },  -- increment/decrement basically everything,
  {
    "numToStr/Comment.nvim",
    config = function ()
      require("base.comment_nvim").config()
    end,
    event = { "InsertEnter", "CmdlineEnter", "CursorMoved" },
    keys = { "gc", "gcc" },
    enabled = true,
  },
  {
    "mbbill/undotree",
    lazy = true,
    cmd = "UndotreeToggle",
    enabled = true,
  },
  {
    "kylechui/nvim-surround",
    config = function ()
      require("nvim-surround").setup({})
    end,
    event = { "InsertEnter", "CursorMoved" },
    keys = { "c", "d", "y" },
    enabled = true,
  },

  -- language specific,
  { "saltstack/salt-vim", ft = "sls" },
  { "Glench/Vim-Jinja2-Syntax", ft = { "sls", "Jinja2" } },

  -- Treesitter,
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      require("language_parsing.treesitter").config()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-refactor",
    dependencies = "nvim-treesitter",
    enabled = false,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter",
    enabled = true,
  },
  { "RRethy/nvim-treesitter-endwise", dependencies = "nvim-treesitter", enabled = false },
  { "windwp/nvim-ts-autotag", dependencies = "nvim-treesitter", enabled = false },
  {
    "windwp/nvim-autopairs",
    dependencies = "nvim-treesitter",
    config = function ()
      require("language_parsing.autopairs")
    end,
    event = "InsertEnter",
    enabled = true,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    ft = { "vue", "typescript", "javascript" },
    dependencies = "nvim-treesitter",
    enabled = true,
  },
  {
    "ray-x/lsp_signature.nvim",
    config = function ()
      require("lsp_signature").setup({
        bind = true,  -- This is mandatory, otherwise border config won't get registered.
        handler_lazys = {
          border = "rounded",
        },
      })
      vim.keymap.set({ "i" }, "<C-k>", function ()
        require("lsp_signature").signature_help()
      end, { silent = true, noremap = true, desc = "toggle signature" })
    end,
    enabled = false,
  },
  {
    "zbirenbaum/copilot.lua",
    config = function ()
      require("lsp.copilot").config()
    end,
    enabled = true,
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function ()
      require("mason").setup()
    end,
    enabled = true,
  },
  { "williamboman/mason-lspconfig.nvim" },
  "jay-babu/mason-nvim-dap.nvim",
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
    },
    -- lazy = true,
    event = { "BufReadPre", "BufNewFile", "InsertEnter" },
    -- cmd = {"LspInfo", "LspStart", "LspInstallInfo"},
    -- keys = { "<leader>l", "i"},
    config = function ()
      require("lsp").config()
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
      "dmitmel/cmp-cmdline-history",
      "rcarriga/cmp-dap",
      "petertriho/cmp-git",
      "andersevenrud/compe-tmux",
      "ray-x/cmp-treesitter",
      "lukas-reineke/cmp-under-comparator",
      "lukas-reineke/cmp-rg",
      {
        "David-Kunz/cmp-npm",
        ft = "json",
        config = function ()
          require("cmp-npm").setup({})
        end,
      },
      { "L3MON4D3/LuaSnip", dependencies = "friendly-snippets", build = "make install_jsregexp" },
      "saadparwaiz1/cmp_luasnip",
      { "kdheepak/cmp-latex-symbols", ft = { "latex", "tex" } },
      "f3fora/cmp-spell",
      -- "quangnguyen30192/cmp-nvim-tags",
      "octaltree/cmp-look",
      "onsails/lspkind-nvim",
    },
    config = function ()
      require("lsp.cmp").config()
    end,
    enabled = true,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble", "Gitsigns setqflist", "Gitsigns setloclist" },
    event = "LspAttach",
    enabled = true,
  },
  {
    "tpope/vim-dadbod",
    lazy = false,
    -- cmd = {"G", "Git push", "Git pull", "Gdiffsplit!", "Gvdiffsplit!"},
    enabled = true,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function ()
      -- Your DBUI configuration
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    lazy = true,
    -- cmd = {"G", "Git push", "Git pull", "Gdiffsplit!", "Gvdiffsplit!"},
    config = function ()
      vim.cmd([[
				  autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
				]])
    end,
    enabled = true,
  },
  {
    "tpope/vim-fugitive",
    lazy = false,
    -- cmd = {"G", "Git push", "Git pull", "Gdiffsplit!", "Gvdiffsplit!"},
    enabled = false,
  },
  {
    "NeogitOrg/neogit",
    dependencies = { "sindrets/diffview.nvim" },
    cmd = "Neogit",
    event = "InsertEnter",
    keys = "<leader>g",
    config = function ()
      require("git.neogit").config()
    end,
    enabled = true,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function ()
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
      -- "antoinemadec/FixCursorHold.nvim",
    },
    config = function ()
      require("test.neotest").config()
    end,
  },

  -- debug adapter protocol
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function ()
      require("debug.dap").config()
    end,
    event = "InsertEnter",
    enabled = true,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "InsertEnter",
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "folke/neodev.nvim",
        config = function ()
          require("neodev").setup({
            library = { plugins = { "nvim-dap-ui", "neotest" }, types = true },
          })
        end,
        enabled = true,
      },
    },
    config = function ()
      require("debug.dapui").config()
    end,
    enabled = true,
  },
  {
    "jbyuki/one-small-step-for-vimkind",
    dependencies = "nvim-dap",
    ft = "lua",
    config = function ()
      require("debug.one_small_step_for_vimkind").config()
    end,
    enabled = false,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = { "nvim-dap", "telescope.nvim" },
    keys = { "<leader>" },
    config = function ()
      require("telescope").load_extension("dap")
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function ()
      require("debug.vscode_js")
    end,
    ft = { "javascript", "typescript" },
    enabled = false,
  },
  {
    "microsoft/vscode-js-debug",
    lazy = true,
    build = "pnpm install --legacy-peer-deps && pnpm run compile",
    enabled = false,
  },

  -- project management
  {
    "nvim-orgmode/orgmode.nvim",
    -- keys = "<leader>o",
    config = function ()
      require("management.orgmode")
    end,
    enabled = false,
  },
  {
    "renerocksai/telekasten.nvim",
    event = "BufReadPost",
    dependencies = { "telescope.nvim", "renerocksai/calendar-vim" },
    config = function ()
      require("management.telekasten").config()
    end,
    enabled = false,
  },

  -- miscellaneous,
  { "kevinhwang91/nvim-bqf", event = "InsertEnter" },
  {
    "stevearc/overseer.nvim",
    config = function ()
      require("misc.overseer").config()
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {},
    config = function ()
      require("conform").setup({
        formatters_by_ft = {
          -- Conform will run multiple formatters sequentially
          python = { "ruff_fix", "ruff_format" },
        },
      })
      local maps = {
        f = {
          "<cmd>lua require('conform').format({ lsp_fallback = 'always', timeout_ms = 1000 })<cr>",
          "Format" }
      }
      require("which-key").register(maps, { prefix = "<leader>l" })
    end,
  },
  {
    "andymass/vim-matchup",
    config = function ()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      vim.g.matchup_surround_enabled = 1
    end,
    keys = { "%" },
    event = "InsertEnter",
    enabled = true,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function ()
      require("flash").setup({
        highlight = {
          backdrop = false,
        },
        label = {
          uppercase = false,
        },
        jump = {
          nohlsearch = true,
        },
        modes = {
          search = {
            enabled = false,
          },
          char = {
            highlight = { backdrop = false },
          },
          treesitter = {
            highlight = {
              backdrop = false,
            },
          },
        },
      })
    end,
    ---@diagnostic disable-next-line: undefined-doc-name
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function () require("flash").jump() end,
        desc = "Flash"
      },
      {
        "S",
        mode = { "n", "x", "o" },
        function () require("flash").treesitter() end,
        desc = "Flash Treesitter"
      },
      {
        "r",
        mode = "o",
        function () require("flash").remote() end,
        desc = "Remote Flash"
      },
      {
        "R",
        mode = { "o", "x" },
        function () require("flash").treesitter_search() end,
        desc = "Treesitter Search"
      },
      {
        "<c-s>",
        mode = { "c" },
        function () require("flash").toggle() end,
        desc = "Toggle Flash Search"
      },
    },
    enabled = true,
  },
  {
    "folke/todo-comments.nvim",
    config = function ()
      require("todo-comments").setup()
    end,
    event = "InsertEnter",
    enabled = true,
  },
  {
    "akinsho/toggleterm.nvim",
    -- tag = "*",
    config = function ()
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
    config = function ()
      require("misc.neogen")
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
    enabled = true,
    event = "InsertEnter",
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    config = function ()
      -- This module contains a number of default definitions
      local rainbow_delimiters = require("rainbow-delimiters")

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
    event = "BufReadPost",
    enabled = true,
  },
  {
    "wuelnerdotexe/vim-enfocado",
    lazy = vim.cmd("colorscheme") ~= "enfocado",
    keys = { "<leader>s" },
  },
  {
    "folke/tokyonight.nvim",
    lazy = vim.cmd("colorscheme") ~= "tokyonight",
    priority = 1000,
    config = function ()
      require("tokyonight").setup({
        style = "storm",
        transparent = false,
        hide_inactive_statusline = false,
      })
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = vim.cmd("colorscheme") ~= "catppuccin",
    config = function ()
      require("catppuccin").setup({
        flavour = "mocha",  -- mocha, macchiato, frappe, latte
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
    config = function ()
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
    config = function ()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require("windows").setup()
    end,
    enabled = false,
  },
  -- { "dstein64/vim-startuptime" },
  {
    "kevinhwang91/nvim-hlslens",
    config = function ()
      require("ui.hlslens").config()
    end,
    enabled = false,
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
    enabled = false,
  },
  -- { "stevearc/dressing.nvim" },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function ()
      require("ui.noice").config()
    end,
    enabled = true,
  },
  {
    "lervag/vimtex",
    ft = "tex",
    config = function ()
      require("misc.vimtex").config()
    end,
  },
}, {})
