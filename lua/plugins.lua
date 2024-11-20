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

lazy.setup({
  { "mistweaverco/kulala.nvim", config = function () require("kulala").setup() end, enabled = false, },
  "nvim-lua/plenary.nvim",  -- most important functions (very important)
  -- {
  --   "microsoft/python-type-stubs",
  --   enabled = O.python and O.lsp,
  -- },
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
        "latex",
        "tex",
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
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    config = function ()
      require("tiny-inline-diagnostic").setup()
    end,
    enabled = O.misc and false,
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "InsertEnter",
    config = function ()
      require("lsp.lspsaga").config()
    end,
    dependencies = {
      "nvim-web-devicons",
      "nvim-treesitter",
      "nvim-lspconfig",
    },
    enabled = O.lsp,
  },
  { "echasnovski/mini.notify", version = false },
  {
    "rcarriga/nvim-notify",
    config = function ()
      ---@diagnostic disable-next-line: missing-fields
      require("notify").setup({
        timeout = 3000,
        render = "minimal",
        level = 2,
        stages = "fade_in_slide_out",
        icons = {
          DEBUG = "",
          ERROR = "",
          INFO = "",
          TRACE = "✎",
          WARN = ""
        },
        time_formats = {
          notification = "%T",
          notification_history = "%FT%T"
        },
        minimum_width = 50,
        fps = 30,
        max_width = 80,
        max_height = 10,
        top_down = false,
      })
      vim.notify = require("notify")
      require("telescope").load_extension("notify")
    end,
    dependencies = "telescope.nvim",
    enabled = O.misc and O.lsp,
  },
  {
    "nvim-neorg/neorg",
    -- event = "VeryLazy",
    -- lazy = false,
    -- event = { "BufReadPost", "BufNewFile", "VimEnter" },
    version = "*",
    ft = "norg",
    keys = { "<leader>", "g" },
    config = function ()
      require("management.neorg").config()
    end,
    dependencies = {
      "nvim-neorg/neorg-telescope",
      "max397574/neorg-contexts",
      "benlubas/neorg-se",
      "benlubas/neorg-interim-ls",
      -- { "pysan3/neorg-templates", dependencies = { "L3MON4D3/LuaSnip" } },
    },
    enabled = O.project_management and false,
  },
  {
    "epwalsh/obsidian.nvim",
    event = { "BufReadPost", "InsertEnter" },
    version = "*",
    config = function ()
      require("management.obsidian").config()
    end,
    enabled = O.obsidian,
  },
  {
    "lewis6991/impatient.nvim",
    config = function ()
      require("impatient")
    end,
    enabled = vim.fn.has("nvim-0.10") == 0,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build =
    "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    dependencies = "telescope.nvim",
    config = function ()
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
    config = function ()
      require("telescope").load_extension("frecency")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    config = function ()
      require("ben.telescope").config()
    end,
  },
  {
    "benatouba/project.nvim",
    config = function ()
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
    config = function ()
      require("colorizer").setup({})
    end,
    event = "BufReadPost",
    enabled = O.misc,
  },

  -- Icons and visuals
  {
    "nvim-tree/nvim-web-devicons",
    config = function ()
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
  require("ben.oil"),
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function ()
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
    config = function ()
      require("ben.lualine").config()
    end,
    enabled = true,
  },
  {
    "romgrk/barbar.nvim",
    config = function ()
      require("ui.barbar").config()
    end,
    init = function ()
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
    config = function ()
      require("mini.bracketed").setup()
    end,
    enabled = O.language_parsing,
  },
  {
    "kyazdani42/nvim-tree.lua",
    lazy = true,
    cmd = "NvimTreeToggle",
    config = function ()
      require("ben.nvim-tree").config()
    end,
    enabled = false,
  },

  -- manipulation
  {
    "monaqa/dial.nvim",
    config = function ()
      require("ben.dial").config()
    end,
    keys = { "<C-a>", "<C-x>" },
  },  -- increment/decrement basically everything,
  -- {
  --   "numToStr/Comment.nvim",
  --   config = function ()
  --     require("ben.comment_nvim").config()
  --   end,
  --   event = { "InsertEnter", "CmdlineEnter", "CursorMoved" },
  --   keys = { "g", "gc" },
  --   enabled = false,
  -- },
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
        config = function ()
          require("nvim-dap-repl-highlights").setup()
        end,
        enabled = false,
      },
      -- "RRethy/nvim-treesitter-endwise",
      -- "nvim-treesitter/nvim-treesitter-refactor",
    },
    build = ":TSUpdate",
    lazy = true,
    config = function ()
      require("language_parsing.treesitter").config()
    end,
    enabled = O.language_parsing,
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    config = function ()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
      }
      )
    end,
    enabled = O.language_parsing,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function ()
      require("language_parsing.autopairs").config()
    end,
    enabled = O.language_parsing,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter",
    lazy = true,
    enabled = O.language_parsing,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    ft = { "vue", "svelte", "typescriptreat", "html" },
    -- dependencies = { "nvim-treesitter", "Comment.nvim" },
    -- config = function ()
    --   local tsc_ok, tsc = pcall(require, "ts_context_commentstring")
    --   if not tsc_ok then
    --     vim.notify("TS-Context-Commentstring not ok")
    --   end
    --   local opts = {
    --     ignore = "^$",
    --   }
    --   if tsc_ok then
    --     tsc.setup({
    --       enable_autocmd = false,
    --     })
    --     opts.pre_hook =
    --       require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
    --   end
    --   require("Comment").setup(opts)
    -- end,
    enabled = O.webdev and O.language_parsing,
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    config = function ()
      require("ts-error-translator").setup()
    end,
  },
  {
    "catgoose/vue-goto-definition.nvim",
    event = "BufReadPre",
    enabled = O.webdev and O.language_parsing,
    opts = {
      filters = {
        auto_imports = true,
        auto_components = true,
        import_same_file = true,
        declaration = true,
        duplicate_filename = true,
      },
      filetypes = { "vue", "typescript" },
      detection = {
        nuxt = function ()
          return vim.fn.glob(".nuxt/") ~= ""
        end,
        vue3 = function ()
          return vim.fn.filereadable("vite.config.ts") == 1
            or vim.fn.filereadable("src/app.vue") == 1
        end,
        priority = { "nuxt", "vue3" },
      },
      lsp = {
        override_definition = true,  -- override vim.lsp.buf.definition
      },
      debounce = 300,
    },
  },
  {
    "Exafunction/codeium.vim",
    config = function ()
      vim.g.codeium_disable_bindings = 1
      -- Change '<C-g>' here to any keycode you like.
      vim.keymap.set("i", "<C-l>", function () return vim.fn["codeium#Accept"]() end,
        { expr = true, silent = true })
      vim.keymap.set("i", "<C-a>", function () return vim.fn["codeium#AcceptNextWord"]() end,
        { expr = true, silent = true })
      vim.keymap.set("i", "<C-S-a>", function () return vim.fn["codeium#AcceptNextLine"]() end,
        { expr = true, silent = true })
      vim.keymap.set("i", "<c-n>", function () return vim.fn["codeium#CycleCompletions"](1) end,
        { expr = true, silent = true })
      vim.keymap.set("i", "<c-p>", function () return vim.fn["codeium#CycleCompletions"](-1) end,
        { expr = true, silent = true })
      vim.keymap.set("i", "<c-h>", function () return vim.fn["codeium#Clear"]() end,
        { expr = true, silent = true })
    end,
    enabled = O.codeium,
  },
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function ()
      require("codeium").setup({
        enable_chat = true,
        tools = {
          curl = "/usr/bin/curl",
          gzip = "/usr/bin/gzip",
          -- language_server = vim.fn.expand("~") .. "/.local/bin/termium_language_server_linux_x64"
          -- language_server = "/home/ben/.local/bin/termium_language_server_linux_x64"
        }
      })
    end,
    enabled = O.codeium and false,
  },
  {
    "supermaven-inc/supermaven-nvim",
    lazy = true,
    config = function ()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-l>",
          clear_suggestion = "<C-h>",
          accept_word = "<C-a>",
        },
        ignore_filetypes = { env = true },
        color = {
          -- suggestion_color = "#ffffff",
          cterm = 244,
        }
      })
    end,
    enabled = O.supermaven,
  },
  {
    "zbirenbaum/copilot.lua",
    config = function ()
      require("lsp.copilot").config()
    end,
    enabled = tonumber(string.sub(Capture("node --version"), 2, 3)) >= 18 and O.copilot,
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function ()
      require("mason").setup({})
    end,
    enabled = O.lsp,
  },
  { "williamboman/mason-lspconfig.nvim", enabled = O.lsp },
  --[[ {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function ()
      require("lsp.null-ls").config()
    end,
    enabled = false,
  }, ]]
  { "jay-babu/mason-nvim-dap.nvim", enabled = O.dap },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "b0o/SchemaStore.nvim",
    },
    -- lazy = true,
    event = { "BufReadPre", "BufNewFile", "InsertEnter" },
    -- cmd = {"LspInfo", "LspStart", "LspInstallInfo"},
    -- keys = { "<leader>l", "i"},
    config = function ()
      require("lsp").config()
    end,
    enabled = O.lsp,
  },
  {
    "R-nvim/R.nvim",
    lazy = false,
    ft = { "r", "rmd" },
    config = function ()
      -- Create a table with the options to be passed to setup()
      local opts = {
        R_args = { "--quiet", "--no-save" },
        hook = {
          on_filetype = function ()
            -- This function will be called at the FileType event
            -- of files supported by R.nvim. This is an
            -- opportunity to create mappings local to buffers.
            vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
            vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
          end
        },
        min_editor_width = 72,
        rconsole_width = 78,
        disable_cmds = {
          "RClearConsole",
          "RCustomStart",
          "RSPlot",
          "RSaveClose",
        },
        auto_start = "always",
        -- csv_app = ":TermExec cmd='vd %'",
        csv_app = "terminal:vd",
        -- csv_app = ":TermExec cmd='vd %s'"
      }
      -- alias r "R_AUTO_START=true nvim"
      if vim.env.R_AUTO_START == "true" then
        opts.auto_start = 1
        opts.objbr_auto_start = true
      end
      vim.g.rout_follow_colorscheme = true
      require("r").setup(opts)
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "rafamadriz/friendly-snippets",
      -- "hrsh7th/cmp-buffer",
      { "hrsh7th/cmp-nvim-lsp", enabled = O.lsp },
      { "hrsh7th/cmp-nvim-lsp-document-symbol", enabled = O.lsp },
      -- "hrsh7th/cmp-nvim-lsp-signature-help",
      "micangl/cmp-vimtex",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-cmdline",
      "dmitmel/cmp-cmdline-history",
      { "rcarriga/cmp-dap", enabled = O.dap },
      { "petertriho/cmp-git", enabled = O.git },
      "andersevenrud/cmp-tmux",
      { "ray-x/cmp-treesitter", enabled = O.language_parsing },
      "lukas-reineke/cmp-under-comparator",
      "lukas-reineke/cmp-rg",
      "R-nvim/cmp-r",
      {
        "David-Kunz/cmp-npm",
        ft = "json",
        config = function ()
          require("cmp-npm").setup({})
        end,
        enabled = false,
      },
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        dependencies = "friendly-snippets",
        build = "make install_jsregexp",
        config = function ()
          require("snippets.luasnip").config()
        end,
      },
      "saadparwaiz1/cmp_luasnip",
      "amarakon/nvim-cmp-lua-latex-symbols",
      -- "f3fora/cmp-spell",
      -- "quangnguyen30192/cmp-nvim-tags",
      -- "octaltree/cmp-look",
      {
        "onsails/lspkind-nvim",
        lazy = true,
      },
    },
    config = function ()
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
    init = function ()
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
    config = function ()
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
      keys = {"<leader>", "g", "<c-o>"},
      cmd = "DiffviewOpen",
      event = "BufReadPost",
      config = function ()
        require("git.diffview").config()
      end,
    },
    -- branch = "nightly",
    cmd = "Neogit",
    event = "InsertEnter",
    keys = {"<leader>", "g", "<c-o>"},
    config = function ()
      require("git.neogit").config()
    end,
    enabled = O.git,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function ()
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
    config = function ()
      require("test.neotest").config()
    end,
    enabled = O.test,
  },
  {
    "vuki656/package-info.nvim",
    config = function ()
      require("misc.package_info").config()
    end,
    enabled = O.webdev and O.misc,
    ft = { "json" },
  },

  -- debug adapter protocol
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function ()
          require("nvim-dap-virtual-text").setup({})
        end
      },
    },
    config = function ()
      require("debug.dap").config()
    end,
    event = "InsertEnter",
    enabled = O.dap,
  },
  {
    "folke/lazydev.nvim",
    opts = {
      library = {
        -- Library items can be absolute paths
        -- "~/projects/my-awesome-lib",
        -- Or relative, which means they will be resolved as a plugin
        -- "LazyVim",
        -- When relative, you can also provide a path to the library in the plugin dir
        "luvit-meta/library",  -- see below
      },
    },
    ft = "lua",
    enabled = O.lsp,
  },
  { "Bilal2453/luvit-meta", lazy = true, enabled = O.lsp },
  {
    "rcarriga/nvim-dap-ui",
    event = "InsertEnter",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    config = function ()
      require("debug.dapui").config()
    end,
    enabled = O.dap,
  },
  {
    "jbyuki/one-small-step-for-vimkind",
    dependencies = "nvim-dap",
    ft = "lua",
    config = function ()
      require("debug.one_small_step_for_vimkind").config()
    end,
    enabled = O.dap,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = { "nvim-dap", "telescope.nvim" },
    keys = { "<leader>" },
    config = function ()
      require("telescope").load_extension("dap")
    end,
    enabled = O.dap,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function ()
      require("debug.vscode_js").config()
    end,
    ft = { "javascript", "vue", "javascriptreact", "typescriptreact", "typescript" },
    enabled = O.webdev and O.dap,
  },
  {
    "microsoft/vscode-js-debug",
    lazy = true,
    build = "npm ci --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    enabled = tonumber(string.sub(Capture("node --version"), 2, 3)) >= 18
      and O.webdev
      and O.dap
      and false,
  },
  {
    "Joakker/lua-json5",
    build = "./install.sh",
    enabled = vim.fn.executable("cargo") == 1 and O.webdev and false,
  },

  -- project management
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      {
        "akinsho/org-bullets.nvim",
        config = function ()
          require("org-bullets").setup()
        end
      },
    },
    event = "VeryLazy",
    ft = { "org" },
    keys = { "<leader>" },
    enabled = O.project_management,
    config = function ()
      require("management.orgmode").config()
    end,
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
  { "kevinhwang91/nvim-bqf", event = "InsertEnter", enabled = O.misc },
  {
    "stevearc/overseer.nvim",
    config = function ()
      require("misc.overseer").config()
    end,
    enabled = O.misc,
  },
  {
    "mfussenegger/nvim-lint",
    config = function ()
      require("lint").linters_by_ft = {
        tex = { "proselint" },
        -- latex = { "vale" },
        zsh = { "zsh" },
        jinja = { "djlint" },
        htmldjango = { "djlint" },
        NeogitCommitMessage = { "gitlint" },
        typescript = { "eslint" },
        javascript = { "eslint" },
        javascriptreact = { "eslint" },
        typescriptreact = { "eslint" },
        vue = { "eslint" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "TextChanged" }, {
        callback = function ()
          require("lint").try_lint()
        end,
      })
    end,
    enabled = O.language_parsing,
  },
  {
    "barreiroleo/ltex_extra.nvim",
    ft = { "markdown", "tex", "norg", "org" },
    dependencies = { "neovim/nvim-lspconfig" },
    enabled = O.lsp,
  },
  {
    "stevearc/conform.nvim",
    config = function ()
      require("conform").setup({
        formatters_by_ft = {
          python = { "ruff_fix", "ruff_format", "ruff_organize_imports", "docformatter", stop_after_first = false },
          javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
          javascriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
          typescript = { "biome", "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
          -- tex = { "latexindent", "llf", stop_after_first = true },
          vue = { "prettierd", "prettier", stop_after_first = true },
          css = { "prettierd", "prettier", stop_after_first = true },
          scss = { "prettierd", "prettier", stop_after_first = true },
          html = { "prettierd", "prettier", stop_after_first = true },
          json = { "prettierd", "prettier", stop_after_first = true },
          yaml = { "prettierd", "prettier", stop_after_first = true },
          markdown = { "prettierd", "prettier", stop_after_first = true },
          gitcommit = { "commitmsgfmt", },
          ["*"] = { "codespell" },
          ["_"] = { "trim_whitespace" },
        },
        default_format_opts = {
          lsp_format = "fallback",
        },
      })
      local maps = {
        { "<leader>lf", function () require("conform").format({ lsp_format = "fallback", timeout_ms = 1000 }) end, desc = "Format" },
      }
      require("which-key").add(maps)
    end,
    enabled = O.language_parsing,
  },
  {
    "andymass/vim-matchup",
    config = function ()
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
    config = function ()
      require("todo-comments").setup()
    end,
    event = "InsertEnter",
    enabled = O.language_parsing,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function ()
      require("misc.toggleterm").config()
    end,
    enabled = O.misc,
  },
  {
    "danymat/neogen",
    config = function ()
      require("misc.neogen")
    end,
    dependencies = "nvim-treesitter/nvim-treesitter",
    enabled = O.language_parsing,
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
    enabled = O.language_parsing,
  },
  {
    "folke/tokyonight.nvim",
    lazy = function ()
      return vim.cmd("colorscheme") ~= "tokyonight"
    end,
    priority = 1000,
    config = function ()
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
    config = function ()
      require("kanagawa").setup({
        compile = true,
        dimInactive = true,
      })
    end,
    lazy = function ()
      return vim.cmd("colorscheme") ~= "kanagawa"
    end,
    enabled = O.misc or vim.cmd("colorscheme") == "kanagawa",
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = function () return vim.cmd("colorscheme") ~= "rose-pine" end,
    config = function ()
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
    enabled = O.misc or O.colorscheme == "rose-pine-moon",
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = function ()
      return vim.cmd("colorscheme") ~= "catppuccin"
    end,
    config = function ()
      require("catppuccin").setup({
        flavour = "mocha",  -- mocha, macchiato, frappe, latte
        transparent_background = false,
        background = {  -- :h background
          light = "latte",
          dark = "mocha",
        },
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        integrations = {
          barbar = true,
          cmp = true,
          dap = O.dap,
          dap_ui = O.dap,
          gitsigns = O.git,
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
    event = { "BufReadPost" },
    keys = { "<leader>", "<localleader>", "m", "'" },
    config = function ()
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
    config = function ()
      require("misc.refactoring").config()
      require("misc.refactoring").maps()
    end,
    enabled = O.language_parsing and O.misc,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function ()
      if tonumber(string.sub(Capture("node --version"), 2, 3)) >= 16 then
        return "cd app && npm install"
      else
        vim.fn["mkdp#util#install"]()
      end
    end,
    init = function ()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    enabled = O.markdown,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },  -- if you prefer nvim-web-devicons
    ft = { "markdown", "norg", "org" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
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
    ft = "ipynb",
    enabled = O.notebooks,
  },
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      -- "rcarriga/nvim-notify",
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
    enabled = O.latex,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function ()
      require("misc.typescript_tools").config()
    end,
    ft = { "vue", "typescript", "typescriptreact" },
    enabled = O.webdev or O.typescript,
  },
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
    opts = {
      "magick",
    },
    enabled = false,
  },
  {
    "3rd/image.nvim",
    event = "InsertEnter",
    ft = { "markdown", "vimwiki", "norg", "org", "typst", "css", "html" },
    config = function ()
      require("image").setup({
        backend = "ueberzug",
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "markdown", "vimwiki" },  -- markdown extensions (ie. quarto) can go here
          },
          neorg = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
            filetypes = { "norg" },
          },
          html = {
            enabled = true,
          },
          css = {
            enabled = true,
          },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = false,  -- toggles images when windows are overlapped
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        editor_only_render_when_focused = false,  -- auto show/hide images when the editor gains/looses focus
        tmux_show_only_in_active_window = false,  -- auto show/hide images in the correct Tmux window (needs visual-activity off)
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },  -- render image files as images when opened
      })
    end,
    enabled = vim.fn.executable("ueberzugpp") == 1 and O.misc,
  },
  { "nvim-neotest/nvim-nio" },
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "luarocks.nvim", "telescope.nvim" },
    ft = "http",
    config = function ()
      require("ben.rest").config()
    end,
    enabled = O.webdev and O.misc and false,
  },
}, {})
