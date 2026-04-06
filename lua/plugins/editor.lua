return {
  { "direnv/direnv.vim", event = "BufReadPre" },
  "nvim-lua/plenary.nvim", -- most important functions (very important)
  { "nvim-mini/mini.ai", version = false, opts = {}, event = "VeryLazy" },
  {
    "nvim-mini/mini.sessions",
    version = false,
    keys = {
      {
        "<leader>Sw",
        "<cmd>lua require('mini.sessions').write()<cr>",
        desc = "Write Session",
        remap = false,
        mode = "n",
      },
      {
        "<leader>Sr",
        "<cmd>lua require('mini.sessions').read()<cr>",
        desc = "Read Session",
        remap = false,
        mode = "n",
      },
    },
    opts = { autoread = false },
  },
  {
    "nvim-mini/mini.bracketed",
    version = false,
    opts = {},
    event = "VeryLazy",
    enabled = O.language_parsing,
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    enabled = vim.fn.has("nvim-0.13") == 0,
  },
  {
    "kylechui/nvim-surround",
    opts = {},
    event = "VeryLazy",
    enabled = O.language_parsing,
  },
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
  }, -- increment/decrement basically everything
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
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
    "MagicDuck/grug-far.nvim",
    config = function()
      require("grug-far").setup({})
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
  -- help me find my way around
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local which_key = require("which-key")
      which_key.setup()
      which_key.add({
        { "<leader>a", group = "+Actions", icon = { icon = "", color = "yellow" } },
        { "<leader>A", group = "+Avante", icon = { icon = "󱐒 ", color = "purple" }, remap = false, mode = "n" },
        { "<leader>c", group = "+Configuration", icon = { icon = "", color = "orange" } },
        { "<leader>E", group = "+Ecolog", icon = { icon = "󰒃  ", color = "green" }, remap = false, mode = "n" },
        { "<leader>g", group = "+Git", icon = { icon = "󰊢 ", color = "red" }, remap = false, mode = "n" },
        { "<leader>L", group = "+Logs", icon = { icon = " ", color = "green" } },
        { "<leader>l", group = "+LSP", icon = { icon = "", color = "yellow" } },
        { "<leader>m", group = "Marks", icon = { icon = "", color = "red" } },
        { "<leader>n", group = "+Annotations", icon = { icon = " ", color = "orange" }, remap = false, mode = "n" },
        { "<leader>o", group = "+Org", icon = { icon = " ", color = "purple" }, nowait = false, remap = false },
        { "<leader>p", group = "+Plugins", icon = { icon = " ", color = "blue" } },
        { "<leader>R", group = "+Refactor", icon = { icon = "󰈏 ", color = "grey" }, mode = { "x", "n" } },
        { "<leader>r", group = "+Run", icon = { icon = "󰑮  ", color = "yellow" }, remap = false, mode = "n" },
        { "<leader>s", group = "+Search", icon = { icon = " ", color = "azure" }, remap = false, mode = "n" },
        { "<localleader>s", group = "+SearchReplace", icon = { icon = " ", color = "azure" }, remap = false, mode = "n" },
        { "<leader>S", group = "+Sessions", icon = " ", remap = false, mode = "n" },
        { "<leader>T", group = "+Terminal", icon = { icon = " ", color = "orange" } },
        { "<leader>t", group = "+Test", icon = { icon = "󰙨 ", color = "yellow" } },
        { "<leader>v", group = "+Vivere", icon = { icon = "󰇈 ", color = "purple" }, remap = false },
        { "<localleader>o", group = "+Obsidian", icon = { icon = "󰇈 ", color = "purple" }, mode = { "n", "v", "x" } },
        {
          "<leader>t",
          "<cmd>ToggleTermSendVisualLines<cr>",
          desc = "Send to terminal",
          icon = { icon = " ", color = "purple" },
          mode = "v",
        },
        { "<leader>u", ":UndotreeToggle<cr>", desc = "Undotree", icon = { icon = " ", color = "green" } },
        {
          "<leader>f",
          "<cmd>lua P(vim.api.nvim_buf_get_name(0))<cr>",
          desc = "Show Filename",
          icon = { icon = "", color = "blue" },
        },
        -- Buffers
        { "<leader><leader>", ":bprevious<cr>", desc = "Switch Buffer" },
        -- Actions
        { "<leader>ac", ":BufferClose<CR>", desc = "Close Buffer" },
        { "<leader>ad", "<cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<cr>", desc = "Toggle diagnostics" },
        { "<leader>ah", "<cmd>let @/ = ''<cr>", desc = "Highlights" },
        { "<leader>as", "<cmd>source %<cr>", desc = "Source file" },
        { "<leader>ar", "<cmd>syntax sync fromstart<cr><cmd>redraw!<cr>", desc = "Redraw" },
        { "<leader>aw", "<cmd>call TrimWhitespace()<cr>", desc = "Trim Whitespaces" },
        -- Configuration
        { "<leader>cc", "<cmd>e ~/.config/nvim/init.lua<cr>", desc = "Open Config" },
        { "<leader>cC", "<cmd>ColorizerToggle<cr>", desc = "Colorizer" },
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
        -- Diagnostics
        { "]D", "<cmd>lua require('trouble').next({skip_groups = true, desc = jump = true})<cr>" },
        { "]T", "<cmd>lua require('todo-comments').jump_next()<cr>", desc = "Next todo comment" },
        { "[D", "<cmd>lua require('trouble').previous({skip_groups = true, desc = jump = true})<cr>" },
        { "[T", "<cmd>lua require('todo-comments').jump_prev()<cr>", desc = "Previous todo comment" },
        -- Tabs
        { "]t", "<cmd>tabNext<cr>", desc = "Next tab" },
        { "[t", "<cmd>tabprevious<cr>", desc = "Tab" },
        -- Logs
        { "<leader>Ll", "<cmd>LspLog<cr>", desc = "LSP" },
        { "<leader>Lp", "<cmd>Lazy profile<cr>", desc = "Lazy Profile" },
        -- Generate Annotations
        { "<leader>nn", "<cmd>lua require('neogen').generate()<CR>", desc = "Auto" },
        { "<leader>nc", "<cmd>lua require('neogen').generate({ type = 'class'})<CR>", desc = "Class" },
        { "<leader>nf", "<cmd>lua require('neogen').generate({ type = 'func'})<CR>", desc = "Function" },
        { "<leader>nt", "<cmd>lua require('neogen').generate({ type = 'type'})<CR>", desc = "Type" },
      })
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
    config = true,
  },
}
