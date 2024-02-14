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

lazy.setup({
  -- Packer can manage itself as an lazyional plugin
  -- "nvim-lua/popup.nvim", -- handle popup (important)
  "nvim-lua/plenary.nvim", -- most important functions (very important)
  {
    "microsoft/python-type-stubs",
    enabled = O.python and O.lsp,
  },
  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      colorcolumn = "101",
      custom_colorcolumn = {
        markdown = "121",
      },
      disabled_filetypes = {
        "NvimTree",
        "lazy",
        "mason",
        "help",
        "checkhealth",
        "lspinfo",
        "noice",
        "Trouble",
        "text",
      },
    },
    enabled = O.misc,
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("lsp.lspsaga").config()
    end,
    dependencies = {
      "nvim-web-devicons",
      "nvim-treesitter",
      "nvim-lspconfig",
    },
    enabled = O.lsp,
  },
  {
    "ls-devs/nvim-notify",
    config = function()
      require("notify").setup({
        timeout = 3000,
        render = "minimal",
        max_width = 80,
        max_height = 10,
        top_down = false,
      })
      vim.notify = require("notify")
      require("telescope").load_extension("notify")
    end,
    dependencies = "telescope.nvim",
    enabled = O.misc,
  },
  {
    "nvim-neorg/neorg",
    lazy = false,
    -- event = { "BufReadPost", "VimEnter" },
    config = function()
      require("management.neorg").config()
    end,
    build = ":Neorg sync-parsers",
    dependencies = {
      "plenary.nvim",
      "nvim-neorg/neorg-telescope",
      "max397574/neorg-contexts",
      { "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } },
    },
    enabled = O.project_management and false,
  },
  {
    "epwalsh/obsidian.nvim",
    event = { "BufReadPost" },
    config = function()
      require("management.obsidian").config()
    end,
    enabled = O.obsidian,
  },
  {
    "lewis6991/impatient.nvim",
    config = function()
      require("impatient")
    end,
    enabled = vim.fn.has("nvim-0.10") == 0,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    dependencies = "telescope.nvim",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    dependencies = {
      "telescope.nvim",
      "tami5/sql.nvim",
    },
    enabled = false,
    config = function()
      require("telescope").load_extension("frecency")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("ben.telescope").config()
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("ben.project").setup()
    end,
    dependencies = "telescope.nvim",
    enabled = O.lsp,
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
    enabled = O.misc,
  },

  -- Icons and visuals
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
      require("nvim-web-devicons").set_icon({
        nvim = {
          icon = "",
          color = "#67B25E",
          cterm_color = "83",
          name = "Neovim",
        },
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ben.indent-blankline").config()
    end,
    dependencies = "nvim-treesitter",
    event = "BufReadPost",
    enabled = O.language_parsing,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-web-devicons",
      {
        "AndreM222/copilot-lualine",
        enabled = tonumber(string.sub(Capture("node --version"), 2, 3)) >= 18 and O.copilot,
      },
      {
        "arkav/lualine-lsp-progress",
        enabled = O.lsp,
      },
    },
    config = function()
      require("ben.lualine").config()
    end,
    enabled = true,
  },
  {
    "romgrk/barbar.nvim",
    config = function()
      require("ui.barbar").config()
    end,
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = true,
    enabled = O.misc,
  },
  {
    "echasnovski/mini.bracketed",
    version = "*",
    config = function()
      require("mini.bracketed").setup()
    end,
    enabled = O.language_parsing,
  },
  {
    "kyazdani42/nvim-tree.lua",
    lazy = true,
    cmd = "NvimTreeToggle",
    config = function()
      require("ben.nvim-tree").config()
    end,
    enabled = true,
  },

  -- manipulation
  {
    "monaqa/dial.nvim",
    config = function()
      require("ben.dial").config()
    end,
    keys = { "<C-a>", "<C-x>" },
  }, -- increment/decrement basically everything,
  {
    "numToStr/Comment.nvim",
    config = function()
      require("ben.comment_nvim").config()
    end,
    event = { "InsertEnter", "CmdlineEnter", "CursorMoved" },
    keys = { "g", "gc" },
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
    config = function()
      require("nvim-surround").setup({})
    end,
    event = "VeryLazy",
    enabled = O.language_parsing,
  },

  -- language specific,
  { "saltstack/salt-vim", ft = "sls", enabled = O.salt },
  { "Glench/Vim-Jinja2-Syntax", ft = { "sls", "Jinja2" }, enabled = O.salt },

  -- Treesitter,
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "LiadOz/nvim-dap-repl-highlights",
        config = function()
          require("nvim-dap-repl-highlights").setup()
        end,
        enabled = O.dap,
      },
      "RRethy/nvim-treesitter-endwise",
      "nvim-treesitter/nvim-treesitter-refactor",
      "windwp/nvim-ts-autotag",
      "windwp/nvim-autopairs",
    },
    build = ":TSUpdate",
    config = function()
      require("language_parsing.treesitter").config()
    end,
    enabled = O.language_parsing,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter",
    enabled = O.language_parsing,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    ft = { "vue", "typescript", "javascript" },
    dependencies = "nvim-treesitter",
    enabled = O.webdev and O.language_parsing,
  },
  {
    "OlegGulevskyy/better-ts-errors.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = {
      keymaps = {
        toggle = "<leader>at",
        go_to_definition = "gt",
      },
    },
    ft = { "vue", "typescript", "typescriptreact" },
    enabled = O.webdev and O.lsp,
  },
  {
    "zbirenbaum/copilot.lua",
    config = function()
      require("lsp.copilot").config()
    end,
    enabled = tonumber(string.sub(Capture("node --version"), 2, 3)) >= 18 and O.copilot,
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
    enabled = O.lsp,
  },
  { "williamboman/mason-lspconfig.nvim", enabled = O.lsp },
  { "nvimtools/none-ls.nvim", enabled = O.lsp },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("lsp.null-ls").config()
    end,
    enabled = O.lsp,
  },
  { "jay-babu/mason-nvim-dap.nvim", enabled = O.lsp },
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
    config = function()
      require("lsp").config()
    end,
    enabled = O.lsp,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      -- "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-cmdline",
      "dmitmel/cmp-cmdline-history",
      "rcarriga/cmp-dap",
      "petertriho/cmp-git",
      "andersevenrud/cmp-tmux",
      "ray-x/cmp-treesitter",
      "lukas-reineke/cmp-under-comparator",
      "lukas-reineke/cmp-rg",
      {
        "David-Kunz/cmp-npm",
        ft = "json",
        config = function()
          require("cmp-npm").setup({})
        end,
        enabled = false,
      },
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        dependencies = "friendly-snippets",
        build = "make install_jsregexp",
        config = function()
          require("snippets.luasnip").config()
        end,
      },
      "saadparwaiz1/cmp_luasnip",
      "amarakon/nvim-cmp-lua-latex-symbols",
      -- "f3fora/cmp-spell",
      -- "quangnguyen30192/cmp-nvim-tags",
      -- "octaltree/cmp-look",
      "onsails/lspkind-nvim",
    },
    config = function()
      require("lsp.cmp").config()
    end,
    enabled = O.language_parsing or O.lsp,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble", "Gitsigns setqflist", "Gitsigns setloclist" },
    event = "LspAttach",
    enabled = O.language_parsing or O.lsp,
  },
  {
    "tpope/vim-dadbod",
    lazy = false,
    -- cmd = {"G", "Git push", "Git pull", "Gdiffsplit!", "Gvdiffsplit!"},
    enabled = O.git and O.databases,
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
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_use_nerd_fonts = 1
    end,
    enabled = O.databases,
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    lazy = true,
    -- cmd = {"G", "Git push", "Git pull", "Gdiffsplit!", "Gvdiffsplit!"},
    config = function()
      vim.cmd([[
				  autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
				]])
    end,
    enabled = O.databases and O.language_parsing,
  },
  {
    "tpope/vim-fugitive",
    lazy = false,
    -- cmd = {"G", "Git push", "Git pull", "Gdiffsplit!", "Gvdiffsplit!"},
    enabled = false,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "sindrets/diffview.nvim",
      keys = "<leader>g",
      cmd = "DiffviewOpen",
      event = "BufReadPost",
      config = function()
        require("git.diffview").config()
      end,
    },
    cmd = "Neogit",
    event = "InsertEnter",
    keys = "<leader>g",
    config = function()
      require("git.neogit").config()
    end,
    enabled = O.git,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("git.gitsigns").config()
    end,
    event = "BufReadPost",
    enabled = O.git,
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
    config = function()
      require("test.neotest").config()
    end,
    enabled = O.test,
  },
  {
    "vuki656/package-info.nvim",
    config = function()
      require("misc.package_info").config()
    end,
    enabled = O.webdev and O.misc,
    ft = { "json" },
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
    event = "InsertEnter",
    enabled = O.dap,
  },
  {
    "folke/neodev.nvim",
    opts = {},
    ft = "lua",
    enabled = O.lsp,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "InsertEnter",
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "folke/neodev.nvim",
        config = function()
          require("neodev").setup({
            library = { plugins = { "nvim-dap-ui", "neotest" }, types = true },
          })
        end,
        enabled = true,
      },
    },
    config = function()
      require("debug.dapui").config()
    end,
    enabled = O.dap,
  },
  {
    "jbyuki/one-small-step-for-vimkind",
    dependencies = "nvim-dap",
    ft = "lua",
    config = function()
      require("debug.one_small_step_for_vimkind").config()
    end,
    enabled = O.dap,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = { "nvim-dap", "telescope.nvim" },
    keys = { "<leader>" },
    config = function()
      require("telescope").load_extension("dap")
    end,
    enabled = O.dap,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("debug.vscode_js").config()
    end,
    ft = { "javascript", "vue", "javascriptreact", "typescriptreact", "typescript" },
    enabled = O.webdev and O.dap,
  },
  {
    "microsoft/vscode-js-debug",
    lazy = true,
    build = "npm ci --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    enabled = tonumber(string.sub(Capture("node --version"), 2, 3)) >= 18 and O.webdev and O.dap,
  },
  {
    "Joakker/lua-json5",
    build = "./install.sh",
    enabled = vim.fn.executable("cargo") == 1 and O.webdev and false,
  },

  -- project management
  {
    "nvim-orgmode/orgmode.nvim",
    config = function()
      require("management.orgmode")
    end,
    enabled = O.project_management,
  },
  {
    "renerocksai/telekasten.nvim",
    event = "BufReadPost",
    dependencies = { "telescope.nvim", "renerocksai/calendar-vim" },
    config = function()
      require("management.telekasten").config()
    end,
    enabled = false,
  },

  -- miscellaneous,
  { "kevinhwang91/nvim-bqf", event = "InsertEnter", enabled = O.misc },
  {
    "stevearc/overseer.nvim",
    config = function()
      require("misc.overseer").config()
    end,
    enabled = O.misc,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        tex = { "vale" },
        zsh = { "zsh" },
        jinja = { "djlint" },
        htmldjango = { "djlint" },
        NeogitCommitMessage = { "gitlint" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
    enabled = O.language_parsing,
  },
  {
    "barreiroleo/ltex_extra.nvim",
    ft = { "markdown", "tex" },
    dependencies = { "neovim/nvim-lspconfig" },
    enabled = O.lsp,
  },
  {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "ruff_fix", "ruff_format" },
          -- ["javascript"] = { "prettier" },
          -- ["javascriptreact"] = { "prettier" },
          -- ["typescript"] = { "prettier" },
          -- ["typescriptreact"] = { "prettier" },
          -- ["vue"] = { "prettier" },
          -- ["css"] = { "prettier" },
          -- ["scss"] = { "prettier" },
          -- ["less"] = { "prettier" },
          -- ["html"] = { "prettier" },
          -- ["json"] = { "prettier" },
          -- ["jsonc"] = { "prettier" },
          -- ["yaml"] = { "prettier" },
          ["markdown"] = { "prettier" },
          -- ["markdown.mdx"] = { "prettier" },
          -- ["graphql"] = { "prettier" },
          -- ["handlebars"] = { "prettier" },
        },
      })
      local maps = {
        f = {
          "<cmd>lua require('conform').format({ lsp_fallback = 'always', timeout_ms = 1000 })<cr>",
          "Format",
        },
      }
      require("which-key").register(maps, { prefix = "<leader>l" })
    end,
    enabled = O.language_parsing,
  },
  {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      vim.g.matchup_surround_enabled = 1
    end,
    keys = { "%" },
    event = "InsertEnter",
    enabled = O.language_parsing,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
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
        "<c-s>",
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
    enabled = O.misc,
  },
  {
    "folke/todo-comments.nvim",
    config = function()
      require("todo-comments").setup()
    end,
    event = "InsertEnter",
    enabled = O.language_parsing,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("misc.toggleterm").config()
    end,
    enabled = O.misc,
  },
  {
    "danymat/neogen",
    config = function()
      require("misc.neogen")
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
    enabled = O.language_parsing,
    event = "InsertEnter",
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    config = function()
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
    enabled = O.language_parsing,
  },
  {
    "folke/tokyonight.nvim",
    lazy = vim.cmd("colorscheme") ~= "tokyonight",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "storm",
        transparent = false,
        hide_inactive_statusline = false,
      })
    end,
    enabled = true,
  },
  {
    "rebelot/kanagawa.nvim",
    config = function()
      require("kanagawa").setup({
        compile = true,
        dimInactive = true,
      })
    end,
    lazy = vim.cmd("colorscheme") ~= "kanagawa",
    enabled = O.misc or vim.cmd("colorscheme") == "kanagawa",
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = vim.cmd("colorscheme") ~= "rose-pine",
    config = function()
      require("rose-pine").setup({
        dim_inactive_windows = true,
        highlight_groups = {
          TelescopeBorder = { fg = "highlight_high", bg = "none" },
          TelescopeNormal = { bg = "none" },
          TelescopePromptNormal = { bg = "base" },
          TelescopeResultsNormal = { fg = "subtle", bg = "none" },
          TelescopeSelection = { fg = "text", bg = "base" },
          TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
          Comment = { fg = "foam" },
          VertSplit = { fg = "muted", bg = "muted" },
        },
      })
    end,
    enabled = O.misc or vim.cmd("colorscheme") == "rose-pine",
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = vim.cmd("colorscheme") ~= "catppuccin",
    config = function()
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
    enabled = O.misc or vim.cmd("colorscheme") == "catppuccin",
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("misc.harpoon").config()
      require("misc.harpoon").maps()
    end,
    enabled = O.misc and O.language_parsing,
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
    enabled = O.language_parsing and O.misc,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      if tonumber(string.sub(Capture("node --version"), 2, 3)) >= 16 then
        return "cd app && npm install"
      else
        vim.fn["mkdp#util#install"]()
      end
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    enabled = O.markdown,
  },
  -- { "szw/vim-maximizer", enabled = false },
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
    enabled = O.notebooks,
  },
  { "stevearc/dressing.nvim" },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "ls-devs/nvim-notify",
    },
    config = function()
      require("ui.noice").config()
    end,
    enabled = O.misc,
  },
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      require("misc.vimtex").config()
    end,
    enabled = O.latex,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
    config = function()
      require("misc.typescript_tools").config()
    end,
    ft = { "vue", "typescript", "typescriptreact" },
    enabled = O.webdev or O.typescript,
  },
  {
    "rest-nvim/rest.nvim",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("rest-nvim").setup({
        -- Open request results in a horizontal split
        result_split_horizontal = false,
        -- Keep the http file buffer above|left when split horizontal|vertical
        result_split_in_place = false,
        -- stay in current windows (.http file) or change to results window (default)
        stay_in_current_window_after_split = false,
        -- Skip SSL verification, useful for unknown certificates
        skip_ssl_verification = false,
        -- Encode URL before making request
        encode_url = true,
        -- Highlight request on run
        highlight = {
          enabled = true,
          timeout = 150,
        },
        result = {
          -- toggle showing URL, HTTP info, headers at top the of result window
          show_url = true,
          -- show the generated curl command in case you want to launch
          -- the same request via the terminal (can be verbose)
          show_curl_command = false,
          show_http_info = true,
          show_headers = true,
          -- table of curl `--write-out` variables or false if disabled
          -- for more granular control see Statistics Spec
          show_statistics = false,
          -- executables or functions for formatting response body [optional]
          -- set them to false if you want to disable them
          formatters = {
            json = "jq",
            html = function(body)
              return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end,
          },
        },
        -- Jump to request line on run
        jump_to_request = false,
        env_file = ".env",
        custom_dynamic_variables = {},
        yank_dry_run = true,
        search_back = true,
      })
      require("which-key").register({
        ["<leader>Rr"] = { "<Plug>RestNvim<cr>", "Rest Run" },
        ["<leader>Rp"] = { "<Plug>RestNvimPreview<cr>", "Rest Run Preview" },
        ["<leader>Rl"] = { "<Plug>RestNvimLast<cr>", "Rest Run Last" },
      })
    end,
    enabled = O.webdev and O.misc,
  },
}, {})
