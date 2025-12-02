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
  "nvim-lua/plenary.nvim", -- most important functions (very important)
  { "nvim-mini/mini.ai", version = false, opts = {} },
  {
    "nvim-mini/mini.sessions",
    version = false,
    keys = {
      {
        "<leader>Sw",
        "<cmd>lua require('mini.sessions').write()<cr>",
        -- icon = " ",
        desc = "Write Session",
        remap = false,
        mode = "n",
      },
      {
        "<leader>Sr",
        "<cmd>lua require('mini.sessions').read()<cr>",
        -- icon = " ",
        desc = "Read Session",
        remap = false,
        mode = "n",
      },
    },
    config = function()
      require("mini.sessions").setup({
        autoread = false,
      })
    end,
  },
  {
    "nvim-mini/mini.bracketed",
    version = false,
    opts = {},
    enabled = O.language_parsing,
  },
  {
    "obsidian-nvim/obsidian.nvim",
    ft = "markdown",
    keys = {
      -- { "<localleader>of", "<cmd>Obsidian follow_link<CR>", desc = "Follow link", remap = false },
      { "<leader>od", "<cmd>Obsidian dailies<CR>", desc = "Dailies", remap = false },
      { "<leader>on", "<cmd>Obsidian new<CR>", desc = "New note", remap = false },
      { "<leader>oN", "<cmd>Obsidian new_from_template<CR>", desc = "New note from Template", remap = false },
      { "<leader>ot", "<cmd>Obsidian today<CR>", desc = "Today note", remap = false },
      { "<leader>oT", "<cmd>Obsidian tomorrow<CR>", desc = "Tomorrow note", remap = false },
      { "<leader>os", "<cmd>Obsidian search<CR>", desc = "Search Workspace", remap = false },
      { "<leader>ov", "<cmd>Obsidian workspace vivere<CR>", desc = "Vivere (Workspace)", remap = false },
      { "<leader>ow", "<cmd>Obsidian workspace work<CR>", desc = "Work (Workspace)", remap = false },
      { "<leader>oy", "<cmd>Obsidian yesterday<CR>", desc = "Yesterday note", remap = false },
      { "<localleader>ob", "<cmd>Obsidian backlinks<CR>", desc = "Backlinks", remap = false },
      { "<localleader>ol", "<cmd>Obsidian links<CR>", desc = "Links", remap = false },
      { "<localleader>oo", "<cmd>Obsidian open<CR>", desc = "Open in Obsidian", remap = false },
      { "<localleader>op", "<cmd>Obsidian paste_img<CR>", desc = "Paste image", remap = false },
      { "<localleader>or", "<cmd>Obsidian rename<CR>", desc = "Rename", remap = false },
      { "<localleader>os", "<cmd>Obsidian quick_switch<CR>", desc = "Quick switch", remap = false },
      { "<localleader>ot", "<cmd>Obsidian tags<CR>", desc = "Tags", remap = false },
      { "<localleader>oT", "<cmd>Obsidian template<CR>", desc = "Template", remap = false },
      { "<C-Space>", "<cmd>Obsidian toggle_checkbox<CR>", desc = "Toggle Checkbox", remap = false },
    },
    lazy = true,
    version = "*",
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
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        dependencies = "telescope.nvim",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
    },
    lazy = true,
    keys = {
      { "<leader>b", "<cmd>Telescope buffers theme=dropdown<cr>", desc = "Buffers" },
      { "<leader>sB", "<cmd>Telescope file_browser<cr>", desc = "Browser" },
      { "<leader>sb", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
      { "<leader>sC", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
      { "<leader>sf", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find File" },
      { "<leader>sg", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { "<leader>sN", "<cmd>Noice telescope<cr>", desc = "Noice Notifications" },
      { "<leader>so", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File" },
      { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
      { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>st", "<cmd>Telescope live_grep<cr>", desc = "Text" },
    },
    config = function()
      require("ben.telescope").config()
    end,
  },
  {
    "DrKJeff16/project.nvim",
    keys = {
      { "<leader>sp", "<cmd>Telescope projects<cr>", desc = "Projects" },
    },
    dependencies = { "telescope.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    ---@module 'project'
    ---@type Project.Config.Options
    opts = {
      patterns = {
        ".git",
        "src",
        ">projects",
        ">scripts",
        "pyproject.toml",
        "package.json",
        "*.latexmain",
        "pillar",
        "=nvim",
      },
      ignore_lsp = { "null-ls", "salt-lsp", "copilot" },
      exclude_dirs = { "*/node_modules/*" },
    },
    cond = vim.fn.has("nvim-0.11") == 1,
    enabled = O.lsp,
  },

  -- help me find my way  around,
  "folke/which-key.nvim",
  {
    "folke/snacks.nvim",
    enabled = true,
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      animate = { enabled = false },
      bigfile = { enabled = false },
      keys = {
        {
          "<leader>sc",
          function()
            Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
          end,
          desc = "Find Config File",
        },
      },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "t", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            {
              icon = " ",
              key = "o",
              desc = "Orgmode",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.expand('~') .. '/documents/vivere/org'})",
            },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "keys", gap = 1, padding = 1 },
          { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
      },
      rename = { enabled = false },
      indent = { enabled = false },
      input = { enabled = false },
      notifier = {
        enabled = true,
      },
      notify = { enabled = true },
      quickfile = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      terminal = { enabled = false },
      toggle = { enabled = false },
      win = { enabled = false },
      words = { enabled = true },
      zen = { enabled = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("LspProgress", {
        ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(ev)
          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(vim.lsp.status(), "info", {
            id = "lsp_progress",
            title = "LSP Progress",
            opts = function(notif)
              notif.icon = ev.data.params.value.kind == "end" and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end,
      })
    end,
    keys = {
      {
        "<leader>sn",
        function()
          Snacks.picker.notifications()
        end,
        desc = "Notifications",
      },
      {
        "<leader>z",
        function()
          Snacks.zen()
        end,
        desc = "Zen Mode",
      },
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
    },
  },

  -- Colorize hex and other colors in code,
  {
    "nvchad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        lazy_load = false,
        user_default_options = {
          names_opts = {
            uppercase = true,
          },
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          AARRGGBB = true, -- 0xAARRGGBB hex codes
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = true, -- CSS hsl() and hsla() functions
          css = true, -- Enable all CSS *features*:
          -- names, RGB, RGBA, RRGGBB, RRGGBBAA, AARRGGBB, rgb_fn, hsl_fn
          css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          -- Tailwind colors.  boolean|'normal'|'lsp'|'both'.  True sets to 'normal'
          tailwind = true, -- Enable tailwind colors
          tailwind_opts = { -- Options for highlighting tailwind names
            update_names = true, -- When using tailwind = 'both', update tailwind names from LSP results.  See tailwind section
          },
          -- parsers can contain values used in `user_default_options`
          sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
        },
      })
    end,
    lazy = true,
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
    "stevearc/oil.nvim",
    -- keys = {
    --   { "<leader>e", ":Oil<cr>", desc = "Explorer" },
    -- },
    config = function()
      require("ben.oil").config()
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "benomahony/oil-git.nvim",
    dependencies = { "stevearc/oil.nvim" },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = require("ben.indent-blankline").opts,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = "nvim-treesitter",
    enabled = O.language_parsing,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- "nvim-web-devicons",
      {
        "AndreM222/copilot-lualine",
        enabled = tonumber(string.sub(Capture("node --version"), 2, 3)) >= 20 and O.copilot,
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

  -- manipulation
  {
    "monaqa/dial.nvim",
    config = function()
      require("ben.dial").config()
    end,
    event = { "BufReadPost", "BufNewFile" },
    ft = { "markdown", "text", "html", "javascript", "typescript", "vue", "svelte", "css", "scss", "less" },
    keys = {
      {
        "<C-a>",
        function()
          require("dial.map").manipulate("increment", "normal")
        end,
        desc = "Increment",
      },
      {
        "<C-x>",
        function()
          require("dial.map").manipulate("decrement", "normal")
        end,
        desc = "Decrement",
      },
      {
        "<C-a>",
        function()
          require("dial.map").manipulate("increment", "visual")
        end,
        mode = { "x" },
        desc = "Increment",
      },
      {
        "<C-x>",
        function()
          require("dial.map").manipulate("decrement", "visual")
        end,
        mode = { "x" },
        desc = "Decrement",
      },
      {
        "g<C-a>",
        function()
          require("dial.map").manipulate("increment", "gnormal")
        end,
        desc = "Increment",
      },
      {
        "g<C-x>",
        function()
          require("dial.map").manipulate("decrement", "gnormal")
        end,
        desc = "Decrement",
      },
      {
        "g<C-a>",
        function()
          require("dial.map").manipulate("increment", "gvisual")
        end,
        mode = { "x" },
        desc = "Increment",
      },
      {
        "g<C-x>",
        function()
          require("dial.map").manipulate("decrement", "gvisual")
        end,
        mode = { "x" },
        desc = "Decrement",
      },
    },
  }, -- increment/decrement basically everything,
  {
    "mbbill/undotree",
    -- lazy = true,
    -- cmd = "UndotreeToggle",
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
    "windwp/nvim-ts-autotag",
    event = { "InsertEnter", "BufNewFile" },
    ft = { "html", "javascript", "typescript", "vue", "svelte", "markdown", "xml", "php" },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
      })
    end,
    enabled = O.language_parsing,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "LiadOz/nvim-dap-repl-highlights",
        config = function()
          require("nvim-dap-repl-highlights").setup()
        end,
      },
    },
    build = ":TSUpdate",
    config = function()
      require("language_parsing.treesitter").config()
    end,
    enabled = O.language_parsing,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("language_parsing.autopairs").config()
    end,
    enabled = O.language_parsing,
  },
  {
    "dmmulroy/tsc.nvim",
    enabled = O.typescript,
    ft = { "typescript", "typescriptreact", "vue" },
    config = function()
      require("tsc").setup({
        use_trouble_qflist = true,
        use_diagnostics = true,
      })
      vim.keymap.set("n", "<leader>lt", ":TSC<CR>")
    end,
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    enabled = O.typescript,
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact", "vue" },
    config = function()
      require("ts-error-translator").setup()
    end,
  },
  {
    "Exafunction/codeium.vim",
    config = function()
      vim.g.codeium_disable_bindings = 1
      -- Change '<C-g>' here to any keycode you like.
      vim.keymap.set("i", "<C-l>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<C-a>", function()
        return vim.fn["codeium#AcceptNextWord"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<C-S-a>", function()
        return vim.fn["codeium#AcceptNextLine"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-n>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-p>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<c-h>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, silent = true })
    end,
    enabled = O.codeium,
  },
  {
    "supermaven-inc/supermaven-nvim",
    event = { "InsertEnter" },
    config = function()
      require("supermaven-nvim").setup({
        keymaps = {
          accept_suggestion = "<C-l>",
          clear_suggestion = "<C-h>",
          accept_word = "<C-a>",
        },
        ignore_filetypes = { "env" },
        color = {
          cterm = 244,
        },
      })
    end,
    enabled = O.supermaven,
  },
  {
    "zbirenbaum/copilot.lua",
    -- dependencies = {
    --   "copilotlsp-nvim/copilot-lsp",
    --   config = function()
    --     vim.g.copilot_nes_debounce = 500
    --   end,
    -- },
    event = { "InsertEnter" },
    config = function()
      require("lsp.copilot").config()
    end,
    enabled = tonumber(string.sub(Capture("node --version"), 2, 3)) >= 20 and O.copilot,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "InsertEnter", "CmdlineEnter", "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>pm", "<cmd>Mason<cr>", desc = "Info" },
      { "<leader>Lm", "<cmd>MasonLog<cr>", desc = "Log" },
    },
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          pip = {
            upgrade_pip = true,
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
    opts = {
      auto_install = false,
    },
    enabled = O.lsp,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "InsertEnter",
    dependencies = {
      "mason.nvim",
    },
    opts = {
      handlers = {},
      automatic_installation = false,
    },
    enabled = O.dap,
  },
  {
    "nvimdev/lspsaga.nvim",
    keys = {
      { "gI", "<cmd>Lspsaga finder imp<CR>", desc = "Implementation" },
      { "ga", "<cmd>Lspsaga code_action<CR>", desc = "Code Action" },
      { "gF", "<cmd>Lspsaga finder def+ref<CR>", desc = "Finder" },
      { "go", "<cmd>Lspsaga outline<CR>", desc = "Outline" },
      { "gp", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek" },
      { "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Next Diagnostic" },
      { "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Prev Diagnostic" },
      { "<leader>ld", "<cmd>Lspsaga goto_definition<cr>", desc = "Definitions" },
    },
    event = { "LspAttach", "InsertEnter", "CmdlineEnter" },
    opts = require("lsp.lspsaga"),
    dependencies = {
      "nvim-web-devicons",
      "nvim-treesitter",
    },
  },
  {
    "xzbdmw/colorful-menu.nvim",
    config = function()
      -- You don't need to set these options.
      require("colorful-menu").setup({
        ls = {
          lua_ls = {
            -- Maybe you want to dim arguments a bit.
            arguments_hl = "@comment",
          },
          gopls = {
            -- By default, we render variable/function's type in the right most side,
            -- to make them not to crowd together with the original label.

            -- when true:
            -- foo             *Foo
            -- ast         "go/ast"

            -- when false:
            -- foo *Foo
            -- ast "go/ast"
            align_type_to_right = true,
            -- When true, label for field and variable will format like "foo: Foo"
            -- instead of go's original syntax "foo Foo". If align_type_to_right is
            -- true, this option has no effect.
            add_colon_before_type = false,
          },
          -- for lsp_config or typescript-tools
          ts_ls = {
            extra_info_hl = "@comment",
          },
          vtsls = {
            extra_info_hl = "@comment",
          },
          ["rust-analyzer"] = {
            -- Such as (as Iterator), (use std::io).
            extra_info_hl = "@comment",
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
          },
          clangd = {
            -- Such as "From <stdio.h>".
            extra_info_hl = "@comment",
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
            -- the hl group of leading dot of "•std::filesystem::permissions(..)"
            import_dot_hl = "@comment",
          },
          zls = {
            -- Similar to the same setting of gopls.
            align_type_to_right = true,
          },
          roslyn = {
            extra_info_hl = "@comment",
          },
          -- The same applies to pyright/pylance
          basedpyright = {
            -- It is usually import path such as "os"
            extra_info_hl = "@comment",
          },

          -- If true, try to highlight "not supported" languages.
          fallback = true,
        },
        -- If the built-in logic fails to find a suitable highlight group,
        -- this highlight is applied to the label.
        fallback_highlight = "@variable",
        -- If provided, the plugin truncates the final displayed text to
        -- this width (measured in display cells). Any highlights that extend
        -- beyond the truncation point are ignored. When set to a float
        -- between 0 and 1, it'll be treated as percentage of the width of
        -- the window: math.floor(max_width * vim.api.nvim_win_get_width(0))
        -- Default 60.
        max_width = 60,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- "hrsh7th/cmp-nvim-lsp",
      {
        "saghen/blink.compat",
        version = "*",
        event = "VeryLazy",
        opts = {
          impersonate_nvim_cmp = false,
        },
      },
      {
        "saghen/blink.cmp",
        enabled = true,
        version = "*",
        build = "cargo build --release",
        event = "VeryLazy",
        dependencies = {
          "rafamadriz/friendly-snippets",
          "mikavilpas/blink-ripgrep.nvim",
          "Kaiser-Yang/blink-cmp-git",
          -- { dir = "/home/ben/projects/blink-cmp-ledger" },
          "hrsh7th/cmp-nvim-lua",
          "joelazar/blink-calc",
          "hrsh7th/cmp-emoji",
          "onsails/lspkind.nvim",
          {
            "rcarriga/cmp-dap",
            ft = { "dap-repl", "dapui_watches", "dapui_hover" },
          },
          {
            "michhernand/RLDX.nvim",
            enabled = false,
            -- lazy = true,
            -- event = {
            --   "BufReadPost *.org", "BufNewFile *.org",
            --   "BufReadPost *.md", "BufNewFile *.md",
            -- },
            opts = {
              filename = os.getenv("HOME") .. "/documents/rolodex_db.json",
              schema_ver = "latest",
              encryption = "plaintext",
            },
          },
          {
            "philosofonusus/ecolog.nvim",
            keys = {
              { "<leader>Eg", "<cmd>EcologGoto<cr>", desc = "Go to env file" },
              { "<leader>Ep", "<cmd>EcologPeek<cr>", desc = "Ecolog peek variable" },
              { "<leader>Es", "<cmd>EcologSelect<cr>", desc = "Switch env file" },
              { "<leader>se", "<cmd>EcologTelescope<cr>", desc = "Env" },
            },
            event = { "InsertEnter", "CmdlineEnter", "BufNewFile", "BufReadPre" },
            opts = {
              integrations = {
                blink_cmp = true,
                lspsaga = true,
              },
              shelter = {
                configuration = {
                  partial_mode = {
                    show_start = 1,
                    show_end = 1,
                    min_mask = 4,
                  },
                  mask_char = "*",
                },
                modules = {
                  cmp = true,
                  peek = false,
                  files = true,
                  telescope = false,
                  telescope_previewer = false,
                  fzf = false,
                  fzf_previewer = false,
                  snacks_previewer = false,
                  snacks = false,
                },
              },
              types = true,
              path = vim.fn.getcwd(),
              preferred_environment = "development",
              provider_patterns = true,
            },
          },
        },
        opts = require("lsp.blink").opts,
        opts_extend = { "sources.default" },
      },
      "b0o/SchemaStore.nvim",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("lsp").config()
    end,
    enabled = O.lsp,
  },
  {
    "R-nvim/R.nvim",
    -- lazy = false,
    ft = { "r", "rmd" },
    config = function()
      -- Create a table with the options to be passed to setup()
      local opts = {
        R_args = { "--quiet", "--no-save" },
        objbr_mappings = { -- Object browser keymap
          c = "class", -- Call R functions
          ["<localleader>gg"] = "head({object}, n = 15)", -- Use {object} notation to write arbitrary R code.
          v = function()
            -- Run lua functions
            require("r.browser").toggle_view()
          end,
        },
        Rout_more_colors = true,
        Rout_follow_colorscheme = true,
        hook = {
          on_filetype = function()
            -- This function will be called at the FileType event
            -- of files supported by R.nvim. This is an
            -- opportunity to create mappings local to buffers.
            vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
            vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
          end,
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
        view_df = {
          -- open_app = ":TermExec cmd='vd %'",
          open_app = "terminal:vd",
          -- open_app = ":TermExec cmd='vd %s'"
        },
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
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },
  {
    "folke/trouble.nvim",
    enabled = O.language_parsing or O.lsp,
  },
  {
    "pwntester/octo.nvim",
    keys = {
      { "<leader>go", "<cmd>Octo pr list<cr>", desc = "Octo PR List" },
      { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "Octo Issue List" },
    },
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup()
    end,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    ft = { "sql", "mysql", "plsql" },
    dependencies = {
      "tpope/vim-dadbod",
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
        lazy = true,
        enabled = O.language_parsing,
      },
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
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gd", "<cmd>lua DiffviewToggle()<cr>", desc = "Diffview" },
      { "<leader>gS", "<cmd>DiffviewFileHistory -g --range=stash<cr>", desc = "Check Stash" },
      { "<leader>gm", "<cmd>lua DiffviewToggle('DiffviewOpen master..HEAD')<cr>", desc = "Diff master" },
      {
        "<leader>gf",
        "<cmd>lua DiffviewToggle('DiffviewFileHistory %')<cr>",
        desc = "Open diffs for current File",
      },
    },
    cmd = "DiffviewOpen",
    -- opts = {},
    config = function()
      require("git.diffview").config()
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = { "diffview.nvim" },
    keys = {
      { "<leader>g", group = "+Git", nowait = false, remap = false },
      { "<leader>gb", "<cmd>Neogit branch<cr>", desc = "Branch (Menu)", nowait = false, remap = false },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Commit (Menu)", nowait = false, remap = false },
      { "<leader>gC", "<cmd>Neogit cherry_pick<cr>", desc = "Cherry Pick (Menu)", nowait = false, remap = false },
      { "<leader>gD", "<cmd>Neogit diff<cr>", desc = "Diff (Menu)", nowait = false, remap = false },
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit (alias)", nowait = false, remap = false },
      { "<leader>gl", "<cmd>NeogitLogCurrent<cr>", desc = "Log", nowait = false, remap = false },
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit", nowait = false, remap = false },
      { "<leader>gp", "<cmd>Neogit pull<cr>", desc = "Pull", nowait = false, remap = false },
      { "<leader>gP", "<cmd>Neogit push<cr>", desc = "Push", nowait = false, remap = false },
    },
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
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>g", group = "Git" },
      { "<leader>gB", "<cmd>Gitsigns blame_line<cr>", desc = "Blame line" },
      { "<leader>gD", "<cmd>Gitsigns diffthis<cr>", desc = "Diff this" },
      { "<leader>gR", "<cmd>lua require'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
      { "<leader>gT", "<cmd>lua require'gitsigns'.toggle_deleted()<cr>", desc = "Toggle Deleted" },
      { "<leader>gh", "<cmd>lua require'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk" },
      { "<leader>gj", "<cmd>lua require'gitsigns.actions'.next_hunk()<cr>", desc = "Next Hunk" },
      { "<leader>gk", "<cmd>lua require'gitsigns.actions'.prev_hunk()<cr>", desc = "Prev Hunk" },
      { "<leader>gl", "<cmd>Gitsigns setloclist<cr>", desc = "Set loclist" },
      { "<leader>gq", "<cmd>Gitsigns setqflist<cr>", desc = "Set quickfix" },
      { "<leader>gr", "<cmd>lua require'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },
      { "<leader>gs", "<cmd>lua require'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk" },
    },
    enabled = O.git,
  },
  {
    "nvim-neotest/neotest",
    keys = {
      { "<leader>tA", "<cmd>lua require('neotest').state.adapter_ids()<CR>", desc = "Adapters" },
      {
        "<leader>tD",
        "<cmd>lua require('neotest').run.run({ vim.fn.expand('%'), strategy = 'dap' })<CR>",
        desc = "Debug File",
      },
      { "<leader>tL", "<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<CR>", desc = "Last (Debug)" },
      {
        "<leader>tO",
        "<cmd>lua require('neotest').output.open({ enter = true, short = true, last_run = true })<CR>",
        desc = "Output (short)",
      },
      { "<leader>tP", "<cmd>lua require('test.neotest').NeotestSetupProject()<CR>", desc = "Project" },
      { "<leader>tS", "<cmd>lua require('neotest').run.run({ suite = true })<CR>", desc = "Suite" },
      { "<leader>ta", "<cmd>lua require('neotest').run.attach()<CR>", desc = "Attach to nearest" },
      { "<leader>td", "<cmd>lua require('neotest').run.run({ strategy = 'dap' })<CR>", desc = "Debug" },
      { "<leader>tf", "<cmd>lua require('neotest').run.run({ vim.fn.expand('%') })<CR>", desc = "File" },
      { "<leader>tl", "<cmd>lua require('neotest').run.run_last()<CR>", desc = "Last" },
      { "<leader>tj", group = "+Jump" },
      { "<leader>tjp", "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<CR>", desc = "Previous (failed)" },
      { "<leader>tjn", "<cmd>lua require('neotest').jump.next({ status = 'failed' })<CR>", desc = "Next (failed)" },
      { "<leader>tn", "<cmd>lua require('neotest').run.run()<CR>", desc = "Nearest" },
      { "<leader>to", "<cmd>lua require('neotest').output.open({ enter = true })<CR>", desc = "Output" },
      { "<leader>tp", "<cmd>lua require('neotest').output_panel.toggle()<CR>", desc = "Panel" },
      { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<CR>", desc = "Summary" },
      { "<leader>tt", "<cmd>lua require('neotest').run.run({ suite = true})<CR>", desc = "Run Tests" },
      { "<leader>tw", "<cmd>lua require('neotest').watch.toggle()<CR>", desc = "Watch" },
      { "<leader>tx", "<cmd>lua require('neotest').run.stop()<CR>", desc = "Stop" },
      { "[T", "<cmd>lua require('neotest').jump.prev({ status = 'failed' })<CR>", desc = "Test (failed)" },
      { "]T", "<cmd>lua require('neotest').jump.next({ status = 'failed' })<CR>", desc = "Test (failed)" },
    },
    dependencies = {
      "nvim-neotest/neotest-python",
      "shunsambongi/neotest-testthat",
      "marilari88/neotest-vitest",
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
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
    config = function()
      require("debug.dap").config()
    end,
    event = "InsertEnter",
    enabled = O.dap,
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup({})
        end,
      },
      { "mfussenegger/nvim-dap-python" },
      {
        "nvim-telescope/telescope-dap.nvim",
        setup = function()
          require("telescope").load_extension("dap")
        end,
      },
      {
        "rcarriga/cmp-dap",
        ft = { "dap-repl", "dapui_watches", "dapui_hover" },
        config = function()
          local cmp = require("cmp")
          -- local config = cmp.get_config()
          -- config.enabled = function()
          --   return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
          --       or require("cmp_dap").is_dap_buffer()
          -- end
          -- cmp.setup(config)
          cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
            sources = {
              { name = "dap" },
            },
          })
        end,
        enabled = false,
      },
      {
        "rcarriga/nvim-dap-ui",
        event = "InsertEnter",
        dependencies = {
          "nvim-neotest/nvim-nio",
        },
        config = function()
          require("debug.dapui").config()
        end,
        enabled = O.dap,
      },
      {
        "jbyuki/one-small-step-for-vimkind",
        ft = "lua",
        config = function()
          require("debug.one_small_step_for_vimkind").config()
        end,
        enabled = O.dap and false,
      },
      {
        "microsoft/vscode-js-debug",
        lazy = true,
        build = "npm ci --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
        enabled = tonumber(string.sub(Capture("node --version"), 2, 3)) >= 18 and O.webdev and O.dap,
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ---@alias lazydev.Library {path:string, words:string[], mods:string[]}
    ---@alias lazydev.Library.spec string|{path:string, words?:string[], mods?:string[]}
    ---@class lazydev.Config
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = vim.fn.stdpath("config") .. "/lua", words = { "^ben%." } },
      },
      cmp = {
        enable = false,
      },
    },
    ft = "lua",
    enabled = function(root_dir)
      return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
    end,
  },

  -- project management
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      "danilshvalov/org-modern.nvim",
      {
        "akinsho/org-bullets.nvim",
        config = function()
          require("org-bullets").setup()
        end,
      },
    },
    ft = { "org" },
    keys = {
      {
        "<leader>oa",
        "<cmd>lua require('orgmode').action('agenda.prompt')<CR>",
        desc = "org-Agenda",
        nowait = true,
        remap = false,
      },
      {
        "<leader>oc",
        "<cmd>lua require('orgmode').action('capture.prompt')<CR>",
        desc = "org-Capture",
        nowait = true,
        remap = false,
      },
    },
    enabled = O.project_management,
    config = function()
      require("management.orgmode").config()
    end,
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
    ---@module 'overseer'
    ---@type overseer.SetupOpts
    opts = {
      -- disable dap initially and enable only after dap is loaded
      dap = false,
    },
    enabled = O.misc,
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      require("lint").linters_by_ft = {
        NeogitCommitMessage = { "commitlint" },
        c = { "trivy", "compiler" },
        cxx = { "trivy" },
        docker = { "trivy" },
        elixir = { "trivy" },
        gitcommit = { "commitlint" },
        go = { "trivy" },
        helm = { "trivy" },
        htmldjango = { "djlint" },
        java = { "trivy" },
        -- javascript = { "oxlint" },
        -- javascriptreact = { "oxlint" },
        jinja = { "djlint" },
        lua = { "trivy" },
        markdown = { "alex" },
        php = { "trivy" },
        python = { "trivy" },
        ruby = { "trivy" },
        rust = { "trivy" },
        terraform = { "trivy" },
        tex = { "proselint" },
        toml = { "trivy" },
        -- typescript = { "oxlint" },
        -- typescriptreact = { "oxlint" },
        vue = { "eslint" },
        zsh = { "zsh", "trivy" },
        [".*/.github/workflows/.*%.yml"] = { "yaml.ghaction" },
      }
      local trivy = require("lint").linters.trivy
      trivy.args = { "--scanners", "vuln,misconfig,secret", "--format", "json", "fs" }
      local ns = require("lint").get_namespace("commitlint")
      vim.diagnostic.config({ virtual_text = true, signs = true, update_in_insert = true }, ns)
      vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        group = "lint",
        callback = function()
          require("lint").try_lint()
        end,
      })
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = "lint",
        callback = function()
          require("lint").try_lint("editorconfig-checker")
        end,
      })
      vim.api.nvim_create_autocmd({ "TextChanged" }, {
        group = "lint",
        pattern = "*COMMIT_EDITMSG*",
        callback = function()
          require("lint").try_lint("commitlint")
        end,
      })
    end,
    enabled = O.language_parsing,
  },
  {
    "barreiroleo/ltex_extra.nvim",
    branch = "dev",
    ft = { "markdown", "tex", "norg", "org" },
    event = "BufReadPost",
    dependencies = { "nvim-lspconfig" },
    opts = {
      load_langs = { "en-US" },
      path = vim.fn.stdpath("config") .. "/spell/",
    },
    enabled = false,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        css = { "prettierd", "prettier", stop_after_first = true },
        gitcommit = { "commitmsgfmt" },
        html = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "jq", stop_after_first = true },
        jsonc = { "jq", stop_after_first = true },
        lua = { "stylua", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        nix = { "nixfmt", stop_after_first = true },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports", "docformatter", stop_after_first = false },
        quarto = { "injected" },
        r = { "air", stop_after_first = true },
        rmd = { "injected" },
        scss = { "prettierd", "prettier", stop_after_first = true },
        tex = { "latexindent", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        typst = { "typstyle", stop_after_first = true },
        vue = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        ["*"] = { "codespell" },
        ["_"] = { "trim_whitespace" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.api.nvim_create_autocmd("InsertLeave", {
        pattern = "*COMMIT_EDITMSG*",
        callback = function(args)
          require("conform").format({ bufnr = args.buf, timeout_ms = 2500, lsp_format = "fallback" })
        end,
      })
    end,
    ft = { "gitcommit" },
    keys = {
      { "<leader>Lf", "<cmd>ConformInfo<cr>", desc = "Conform Info" },
      {
        "<leader>lf",
        '<cmd>lua require("conform").format({ lsp_format = "fallback", timeout_ms = 5000 })<cr>',
        desc = "Format",
      },
    },
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
    "folke/todo-comments.nvim",
    opts = {},
    lazy = false,
    enabled = O.language_parsing,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("misc.toggleterm").config()
    end,
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>T", group = "+Terminal" },
      { "<leader>TT", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal" },
      { "<leader>Tt", "<cmd>ToggleTerm<cr>", desc = "Terminal (bot)" },
      { "<leader>gL", "<cmd>lua require('misc.toggleterm').LazyGit()<cr>", desc = "LazyGit" },
      {
        "<leader>Tb",
        "<cmd>lua require('misc.toggleterm').btop()<cr>",
        desc = "BTop",
      },
      { "<leader>Tv", 'yi"<cmd>lua P(vim.cmd[[p]])<cr>"', desc = "VisiData" },
      {
        "<leader>TV",
        "<cmd>lua require('misc.toggleterm').VisiData(vim.api.nvim_buf_get_name(0))<cr>",
        desc = "VisiData (File)",
      },
      { "<leader>Tu", "<cmd>lua require('misc.toggleterm').UpdateProject()<cr>", desc = "Update Project" },
    },
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
      ---@type rainbow_delimiters.config
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = "rainbow-delimiters.strategy.global",
          vim = "rainbow-delimiters.strategy.local",
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        priority = {
          [""] = 110,
          lua = 210,
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
    lazy = function()
      return vim.cmd("colorscheme") ~= "tokyonight"
    end,
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
    lazy = function()
      return vim.cmd("colorscheme") ~= "kanagawa"
    end,
    enabled = O.misc or vim.cmd("colorscheme") == "kanagawa",
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      if string.find(O.colorscheme, "rose-pine") ~= nil then
        vim.cmd("colorscheme " .. O.colorscheme)
      end
    end,
    enabled = O.misc or string.find(O.colorscheme, "rose-pine") ~= nil,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = function()
      return string.find(O.colorscheme, "catppuccin") ~= nil
    end,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- mocha, macchiato, frappe, latte
        transparent_background = false,
        background = { -- :h background
          light = "latte",
          dark = "mocha",
        },
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        integrations = {
          barbar = true,
          blink_cmp = O.lsp,
          cmp = O.lsp,
          dadbod_ui = true,
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
          mini = {
            enabled = true,
          },
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
          nvim_surround = true,
          nvimtree = true,
          octo = true,
          overseer = true,
          rainbow_delimiters = true,
          render_markdown = true,
          snacks = true,
          semantic_tokens = true,
          telekasten = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
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
    event = { "InsertEnter" },
    keys = { "m", "'" },
    config = function()
      require("misc.harpoon").config()
      require("misc.harpoon").maps()
    end,
    enabled = O.misc and O.language_parsing,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    event = "InsertEnter",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      require("misc.refactoring").config()
    end,
    keys = require("misc.refactoring").maps,
    enabled = O.language_parsing and O.misc,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ft = { "markdown", "norg", "org", "rmd", "rst", "tex", "Avante" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { "markdown", "norg", "org", "rmd", "Avante" },
      completions = { lsp = { enabled = true } },
    },
    enabled = O.markdown,
  },
  {
    "brianhuster/live-preview.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
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
    },
    config = function()
      require("ui.noice").config()
    end,
    enabled = true,
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
    dependencies = { "nvim-lua/plenary.nvim", "nvim-lspconfig" },
    config = function()
      require("misc.typescript_tools").config()
    end,
    ft = { "vue", "typescript", "typescriptreact", "javascript", "javascriptreact" },
    enabled = false,
  },
  { "nvim-neotest/nvim-nio" },
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "luarocks.nvim", "telescope.nvim" },
    ft = "http",
    config = function()
      require("ben.rest").config()
    end,
    enabled = O.webdev and O.misc and false,
  },
  {
    "neo451/feed.nvim",
    keys = {
      {
        "<leader>F",
        "<cmd>Feed<cr>",
        desc = "Feed",
        remap = false,
        mode = "n",
      },
    },
    config = function()
      require("feed").setup({
        -- rsshub = {
        --   instance = "https://rsshub.app"
        -- },
        feeds = {
          -- { "https://neovim.io/news.xml",                                                    name = "Neovim News",                                                  tags = { "tech", "news" } },
          {
            "rsshub://sciencedirect/journal/advances-in-climate-change-research",
            name = "ScienceDirect Advances in Climate Change Research",
            tags = { "science" },
          },
          {
            "rsshub://sciencedirect/journal/journal-of-the-european-meteorological-society",
            name = "ScienceDirect Journal of the European Meteorological Society",
            tags = { "science" },
          },
          {
            "rsshub://sciencedirect/journal/results-in-earth-sciences",
            name = "ScienceDirect Results in Earth Sciences",
            tags = { "science" },
          },
          {
            "rsshub://sciencedirect/journal/weather-and-climate-extremes",
            name = "ScienceDirect Weather and Climate Extremes",
            tags = { "science" },
          },
          {
            "rsshub://nature/research/nclimate",
            name = "Nature Climate Change",
            tags = { "science" },
          },
          {
            "rsshub://nature/research/ngeo",
            name = "Nature Geoscience",
            tags = { "science" },
          },
          {
            "rsshub://nature/research/natrevearthenviron",
            name = "Nature Review Earth and Environment",
            tags = { "science" },
          },
          {
            "rsshub://nature/research/natwater",
            name = "Nature Water",
            tags = { "science" },
          },
          {
            "rsshub://nature/research/npjclimatsci",
            name = "npj Climate Science",
            tags = { "science" },
          },
        },
      })
    end,
    enabled = O.misc,
  },
  {
    "MagicDuck/grug-far.nvim",
    config = function()
      require("grug-far").setup({
        -- options, see Configuration section below
        -- there are no required options atm
      })
    end,
    keys = {
      {
        "gS",
        "<cmd>GrugFar<cr>",
        desc = "Find in Files (grug-far)",
        remap = false,
        mode = "n",
      },
      {
        "<localleader>sw",
        "<cmd>lua require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })<cr>",
        desc = "Replace word under Cursor",
        remap = false,
        mode = "n",
      },
      {
        "<localleader>sf",
        "<cmd>lua require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })<cr>",
        desc = "Replace in Current File",
        remap = false,
        mode = "n",
      },
      {
        "gS",
        "<cmd>GrugFarWithin<cr>",
        desc = "SearchReplace in Selection",
        remap = false,
        mode = "x",
      },
    },
    enabled = O.misc,
  },
  {
    "yetone/avante.nvim",
    keys = {
      { "<leader>Aa", "<cmd>AvanteAsk<cr>", desc = "Avante Ask" },
      { "<leader>AC", "<cmd>AvanteChat<cr>", desc = "Avante Chat" },
    },
    version = false, -- Never set this value to "*"! Never!
    opts = {
      -- add any opts here
      -- for example
      provider = "claude",
      providers = {
        gemini = {
          model = "gemini-2.5-pro-exp-03-25",
        },
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
        copilot = {
          endpoint = "https://api.githubcopilot.com",
          model = "gpt-5-mini", -- or "gpt-4o-2024-08-06", "o1", etc.
          timeout = 30000,
          temperature = 0,
          extra_request_body = { max_tokens = 20480 },
        },
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "gpt-5", -- your desired model (or use gpt-4o, etc.)
          extra_request_body = {
            timeout = 45000, -- Timeout in milliseconds, increase this for reasoning models
            temperature = 0.75,
            max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
            --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
          },
        },
      },
      file_selector = {
        --- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string | fun(params: avante.file_selector.IParams|nil): nil
        provider = "telescope",
        -- Options override for custom providers
        provider_opts = {},
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "zbirenbaum/copilot.lua", -- for providers='copilot'
    },
  },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    -- Optional; default configuration will be used if setup isn't called.
    config = function()
      require("everforest").setup({
        -- Your config here
      })
    end,
  },
  {
    "wllfaria/ledger.nvim",
    -- tree sitter needs to be loaded before ledger.nvim loads
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      -- { dir = "/home/ben/projects/blink-cmp-ledger" },
    },
    ft = { "hledger", "ledger" },
    opts = {
      extensions = {
        "ledger",
        "hledger",
        "journal",
      },
      completion = {
        cmp = { enabled = false },
      },
      snippets = {
        cmp = { enabled = false },
        luasnip = { enabled = false },
        native = { enabled = true },
      },
      keymaps = {
        snippets = {
          new_posting = { "tt" },
          new_account = { "acc" },
          new_posting_today = { "td" },
          new_commodity = { "cm" },
        },
        reports = {},
      },
      diagnostics = {
        lsp_diagnostics = true,
        strict = false,
      },
    },
  },
  {
    "chomosuke/typst-preview.nvim",
    ft = { "typst" },
    version = "1.*",
    opts = {}, -- lazy.nvim will implicitly calls `setup {}`
  },
  {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" }, -- Required for Neovim < 0.10.0
    config = true, -- default settings
  },
}, {})
