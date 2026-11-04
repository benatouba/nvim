-- Core editing: shared library, key hints and the file explorer.
return {
  { "nvim-lua/plenary.nvim", lazy = true }, -- library; loaded as a dependency
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
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- Group names for the leader menu; the mappings themselves live in each plugin's `keys`.
      spec = {
        { "<leader>a", group = "+Actions", icon = { icon = " ", color = "yellow" } },
        { "<leader>c", group = "+Configuration", icon = { icon = " ", color = "orange" } },
        { "<leader>d", group = "+Debug", icon = { icon = " ", color = "red" } },
        { "<leader>ds", group = "+Debug search", icon = { icon = " ", color = "red" } },
        { "<leader>g", group = "+Git", icon = { icon = "󰊢 ", color = "red" } },
        { "<leader>L", group = "+Logs", icon = { icon = " ", color = "green" } },
        { "<leader>l", group = "+LSP", icon = { icon = "󰋦 ", color = "yellow" } },
        { "<leader>lp", group = "+Packages", icon = { icon = " ", color = "red" } },
        { "<localleader>r", group = "+Refactor", icon = { icon = "󰈏 ", color = "grey" } },
        { "<localleader>p", group = "+Debug print", icon = { icon = "󰃤 ", color = "red" } },
        {
          "<localleader>l",
          group = "+VimTeX",
          icon = { icon = " ", color = "green" },
          mode = { "n", "x" },
        },
        { "<localleader>t", group = "+Typst", icon = { icon = " ", color = "blue" } },
        { "<leader>m", group = "+Marks", icon = { icon = " ", color = "red" } },
        { "<leader>M", group = "+Music", icon = { icon = "󰎈 ", color = "orange" } },
        { "<leader>O", group = "+Tasks", icon = { icon = "󰒓 ", color = "green" } },
        { "<leader>N", group = "+Annotations", icon = { icon = "󰍕 ", color = "orange" } },
        { "<leader>o", group = "+Org", icon = { icon = " ", color = "cyan" } },
        { "<leader>p", group = "+Plugins", icon = { icon = " ", color = "blue" } },
        { "<leader>R", group = "+REST", icon = { icon = "󰖟 ", color = "green" } },
        {
          "<leader>r",
          group = "+Run",
          icon = { icon = "󰑮 ", color = "yellow" },
          mode = { "n", "x" },
        },
        { "<leader>rm", group = "+Mark", icon = { icon = " ", color = "yellow" } },
        { "<leader>s", group = "+Search", icon = { icon = " ", color = "azure" } },
        { "<leader>S", group = "+Sessions", icon = { icon = " ", color = "cyan" } },
        { "<leader>T", group = "+Terminal", icon = { icon = "  ", color = "orange" } },
        { "<leader>t", group = "+Test", icon = { icon = "󰙨 ", color = "yellow" } },
        { "<leader>tj", group = "+Jump (tests)", icon = { icon = "󰒭 ", color = "yellow" } },
        {
          "<localleader>s",
          group = "+SearchReplace",
          icon = { icon = "󰛔 ", color = "azure" },
        },
        { "<localleader>n", group = "+Obsidian", icon = { icon = "󰇈 ", color = "purple" }, mode = { "n", "x" } },
        { "<leader>n", group = "+Notes", icon = { icon = "󰇈 ", color = "magenta" } },
        -- Singleton leaves: no rhs here (the mapping lives in its plugin's
        -- `keys`); these entries only lend them an icon in the menu.
        { "<leader>b", desc = "Buffers", icon = { icon = "󰓩 ", color = "blue" } },
        { "<leader>e", desc = "Explorer", icon = { icon = "󰉋 ", color = "green" } },
        { "<leader>z", desc = "Zen Mode", icon = { icon = "󰚀 ", color = "cyan" } },
        { "<leader>.", desc = "Toggle Scratch Buffer", icon = { icon = "󰙏 ", color = "grey" } },

        {
          "<leader>f",
          function()
            vim.print(vim.api.nvim_buf_get_name(0))
          end,
          desc = "Show Filename",
          icon = { icon = " ", color = "blue" },
        },
        { "<leader><leader>", "<cmd>bprevious<cr>", desc = "Switch Buffer", icon = { icon = "󰓩 ", color = "blue" } },
        -- Actions
        { "<leader>ah", "<cmd>let @/ = ''<cr>", desc = "Highlights", icon = { icon = " ", color = "yellow" } },
        {
          "<leader>ar",
          "<cmd>syntax sync fromstart<cr><cmd>redraw!<cr>",
          desc = "Redraw",
          icon = { icon = " ", color = "yellow" },
        },
        {
          "<leader>aw",
          function()
            local view = vim.fn.winsaveview()
            vim.cmd([[keeppatterns %s/\s\+$//e]])
            vim.fn.winrestview(view)
          end,
          desc = "Trim Whitespaces",
          icon = { icon = "󰃢 ", color = "yellow" },
        },
        -- Configuration
        {
          "<leader>cc",
          "<cmd>e ~/.config/nvim/init.lua<cr>",
          desc = "Open Config",
          icon = { icon = " ", color = "orange" },
        },
        {
          "<leader>ch",
          "<cmd>set hlsearch!<CR>",
          desc = "Highlight Search",
          icon = { icon = " ", color = "orange" },
        },
        {
          "<leader>cr",
          function()
            vim.cmd([[source $MYVIMRC]])
            vim.notify("Nvim config successfully reloaded", vim.log.levels.INFO, { title = "nvim-config" })
          end,
          desc = "Reload Config",
          icon = { icon = "󰑓 ", color = "orange" },
        },
        {
          "<leader>cR",
          "<cmd>set norelativenumber!<cr>",
          desc = "Relative line numbers",
          icon = { icon = " ", color = "orange" },
        },
        -- Plugins
        { "<leader>pc", "<cmd>Lazy clean<cr>", desc = "Clean", icon = { icon = "󰃢 ", color = "blue" } },
        { "<leader>pC", "<cmd>Lazy check<cr>", desc = "Check", icon = { icon = " ", color = "blue" } },
        { "<leader>pd", "<cmd>Lazy debug<cr>", desc = "Debug", icon = { icon = " ", color = "blue" } },
        { "<leader>ph", "<cmd>Lazy help<cr>", desc = "Help", icon = { icon = " ", color = "blue" } },
        { "<leader>pi", "<cmd>Lazy install<cr>", desc = "Install", icon = { icon = " ", color = "blue" } },
        { "<leader>pl", "<cmd>Lazy log<cr>", desc = "Log", icon = { icon = " ", color = "blue" } },
        { "<leader>pp", "<cmd>Lazy profile<cr>", desc = "Profile", icon = { icon = " ", color = "blue" } },
        { "<leader>pr", "<cmd>Lazy restore<cr>", desc = "Restore", icon = { icon = " ", color = "blue" } },
        { "<leader>ps", "<cmd>Lazy sync<cr>", desc = "Sync", icon = { icon = " ", color = "blue" } },
        { "<leader>pu", "<cmd>Lazy update<cr>", desc = "Update", icon = { icon = " ", color = "blue" } },
        -- Tabs
        { "]t", "<cmd>tabNext<cr>", desc = "Next tab", icon = { icon = " ", color = "cyan" } },
        { "[t", "<cmd>tabprevious<cr>", desc = "Tab", icon = { icon = " ", color = "cyan" } },
        -- Logs
        { "<leader>Ll", "<cmd>LspLog<cr>", desc = "LSP", icon = { icon = " ", color = "green" } },
        { "<leader>Lp", "<cmd>Lazy profile<cr>", desc = "Lazy Profile", icon = { icon = " ", color = "green" } },
      },
    },
  },
}
