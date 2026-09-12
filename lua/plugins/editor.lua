-- Editing primitives, sessions, search/replace, which-key.
return {
  { "nvim-lua/plenary.nvim", lazy = true }, -- library; loaded as a dependency
  {
    "direnv/direnv.vim",
    event = "BufReadPre",
    init = function()
      vim.g.direnv_silent_load = 1
    end,
  },
  { "nvim-mini/mini.ai", version = false, event = "VeryLazy", opts = {} },
  { "nvim-mini/mini.bracketed", version = false, event = "VeryLazy", opts = {} },
  { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
  {
    "nvim-mini/mini.sessions",
    version = false,
    keys = {
      {
        "<leader>Sw",
        function()
          require("mini.sessions").write()
        end,
        desc = "Write Session",
      },
      {
        "<leader>Sr",
        function()
          require("mini.sessions").read()
        end,
        desc = "Read Session",
      },
    },
    opts = { autoread = false },
  },
  {
    "mbbill/undotree",
    -- Disabled on Neovim >= 0.12 (kept for the day it is wanted back).
    enabled = vim.fn.has("nvim-0.12") == 0,
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undotree" } },
  },
  {
    "monaqa/dial.nvim", -- increment/decrement basically everything
    keys = function()
      local map = function(lhs, action, mode)
        return {
          lhs,
          function()
            require("dial.map").manipulate(action, mode)
          end,
          mode = mode:find("visual") and "x" or "n",
          desc = action:sub(1, 1):upper() .. action:sub(2),
        }
      end
      return {
        map("<C-a>", "increment", "normal"),
        map("<C-x>", "decrement", "normal"),
        map("<C-a>", "increment", "visual"),
        map("<C-x>", "decrement", "visual"),
        map("g<C-a>", "increment", "gnormal"),
        map("g<C-x>", "decrement", "gnormal"),
        map("g<C-a>", "increment", "gvisual"),
        map("g<C-x>", "decrement", "gvisual"),
      }
    end,
    config = function()
      local augend = require("dial.augend")
      local default_augends = {
        augend.integer.alias.decimal,
        augend.constant.alias.bool,
        augend.constant.alias.de_weekday,
        augend.constant.alias.de_weekday_full,
        augend.date.alias["%d/%m/%Y"],
        augend.constant.new({ elements = { "yes", "no" } }),
        augend.constant.new({ elements = { "let", "const", "var" } }),
        augend.constant.new({ elements = { "T", "F" } }),
        augend.constant.new({ elements = { "True", "False" } }),
        augend.constant.new({ elements = { "TRUE", "FALSE" } }),
        augend.constant.new({ elements = { "def", "class" } }),
        augend.hexcolor.new({ case = "lower" }),
        augend.semver.alias.semver,
        augend.constant.new({ elements = { "[ ]", "[x]" }, word = false, cyclic = true }),
      }
      local config = require("dial.config")
      config.augends:register_group({
        default = default_augends,
        visual = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%d/%m/%Y"],
        },
      })
      config.augends:on_filetype({
        default = vim.tbl_extend("keep", {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.new({ elements = { "true", "false" } }),
          augend.constant.new({ elements = { "let", "const" } }),
        }, default_augends),
        lua = vim.tbl_extend("keep", {
          augend.integer.alias.decimal,
          augend.constant.new({ elements = { "true", "false" } }),
        }, default_augends),
        markdown = vim.tbl_extend("keep", {
          augend.integer.alias.decimal,
          augend.misc.alias.markdown_header,
          augend.constant.alias.de_weekday,
          augend.constant.alias.de_weekday_full,
        }, default_augends),
      })
    end,
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = {},
    keys = {
      { "gS", "<cmd>GrugFar<cr>", desc = "Find in Files (grug-far)" },
      { "gS", "<cmd>GrugFarWithin<cr>", mode = "x", desc = "SearchReplace in Selection" },
      {
        "<localleader>sw",
        function()
          require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
        end,
        desc = "Replace word under Cursor",
      },
      {
        "<localleader>sf",
        function()
          require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
        end,
        desc = "Replace in Current File",
      },
    },
  },
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = { { "<leader>e", "<cmd>Oil<cr>", desc = "Explorer" } },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      { "benomahony/oil-git.nvim", lazy = true },
    },
    init = function()
      if vim.env.GIT_DIFFTOOL or vim.env.GIT_DIFF_OPT then
        vim.g.oil_manual_open = true
      end
    end,
    opts = function()
      return require("plugins.configs.oil").opts
    end,
  },
  {
    "chrishrb/gx.nvim",
    keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    cmd = { "Browse" },
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- Group names for the leader menu; the mappings themselves live in each plugin's `keys`.
      spec = {
        { "<leader>a", group = "+Actions", icon = { icon = "", color = "yellow" } },
        { "<leader>c", group = "+Configuration", icon = { icon = "", color = "orange" } },
        { "<leader>g", group = "+Git", icon = { icon = "󰊢 ", color = "red" } },
        { "<leader>L", group = "+Logs", icon = { icon = " ", color = "green" } },
        { "<leader>l", group = "+LSP", icon = { icon = "", color = "yellow" } },
        { "<leader>m", group = "Marks", icon = { icon = "", color = "red" } },
        { "<leader>M", group = "+Music", icon = { icon = "󰎈 ", color = "orange" } },
        { "<leader>n", group = "+Annotations", icon = { icon = " ", color = "orange" } },
        { "<leader>o", group = "+Org", icon = { icon = " ", color = "purple" } },
        { "<leader>p", group = "+Plugins", icon = { icon = " ", color = "blue" } },
        { "<leader>R", group = "+Refactor", icon = { icon = "󰈏 ", color = "grey" }, mode = { "x", "n" } },
        { "<leader>r", group = "+Run", icon = { icon = "󰑮  ", color = "yellow" } },
        { "<leader>s", group = "+Search", icon = { icon = " ", color = "azure" } },
        { "<leader>S", group = "+Sessions", icon = " " },
        { "<leader>T", group = "+Terminal", icon = { icon = " ", color = "orange" } },
        { "<leader>t", group = "+Test", icon = { icon = "󰙨 ", color = "yellow" } },
        { "<localleader>s", group = "+SearchReplace", icon = { icon = " ", color = "azure" } },
        { "<localleader>o", group = "+Obsidian", icon = { icon = "󰇈 ", color = "purple" }, mode = { "n", "x" } },

        {
          "<leader>f",
          function()
            vim.print(vim.api.nvim_buf_get_name(0))
          end,
          desc = "Show Filename",
          icon = { icon = "", color = "blue" },
        },
        { "<leader><leader>", "<cmd>bprevious<cr>", desc = "Switch Buffer" },
        -- Actions
        { "<leader>ah", "<cmd>let @/ = ''<cr>", desc = "Highlights" },
        { "<leader>ar", "<cmd>syntax sync fromstart<cr><cmd>redraw!<cr>", desc = "Redraw" },
        {
          "<leader>aw",
          function()
            local view = vim.fn.winsaveview()
            vim.cmd([[keeppatterns %s/\s\+$//e]])
            vim.fn.winrestview(view)
          end,
          desc = "Trim Whitespaces",
        },
        -- Configuration
        { "<leader>cc", "<cmd>e ~/.config/nvim/init.lua<cr>", desc = "Open Config" },
        { "<leader>ch", "<cmd>set hlsearch!<CR>", desc = "Highlight Search" },
        {
          "<leader>cr",
          function()
            vim.cmd([[source $MYVIMRC]])
            vim.notify("Nvim config successfully reloaded", vim.log.levels.INFO, { title = "nvim-config" })
          end,
          desc = "Reload Config",
        },
        { "<leader>cR", "<cmd>set norelativenumber!<cr>", desc = "Relative line numbers" },
        -- Plugins
        { "<leader>pc", "<cmd>Lazy clean<cr>", desc = "Clean" },
        { "<leader>pC", "<cmd>Lazy check<cr>", desc = "Check" },
        { "<leader>pd", "<cmd>Lazy debug<cr>", desc = "Debug" },
        { "<leader>ph", "<cmd>Lazy help<cr>", desc = "Help" },
        { "<leader>pi", "<cmd>Lazy install<cr>", desc = "Install" },
        { "<leader>pl", "<cmd>Lazy log<cr>", desc = "Log" },
        { "<leader>pp", "<cmd>Lazy profile<cr>", desc = "Profile" },
        { "<leader>pr", "<cmd>Lazy restore<cr>", desc = "Restore" },
        { "<leader>ps", "<cmd>Lazy sync<cr>", desc = "Sync" },
        { "<leader>pu", "<cmd>Lazy update<cr>", desc = "Update" },
        -- Tabs
        { "]t", "<cmd>tabNext<cr>", desc = "Next tab" },
        { "[t", "<cmd>tabprevious<cr>", desc = "Tab" },
        -- Logs
        { "<leader>Ll", "<cmd>LspLog<cr>", desc = "LSP" },
        { "<leader>Lp", "<cmd>Lazy profile<cr>", desc = "Lazy Profile" },
      },
    },
  },
}
