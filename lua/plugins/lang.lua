return {
  {
    "R-nvim/R.nvim",
    ft = { "r", "rmd" },
    config = function()
      require("misc.r-nvim").config()
    end,
  },
  { "saltstack/salt-vim", ft = "sls", enabled = O.salt },
  { "Glench/Vim-Jinja2-Syntax", ft = { "sls", "Jinja2" }, enabled = O.salt },
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      require("misc.vimtex").config()
    end,
    enabled = O.latex,
  },
  {
    "chomosuke/typst-preview.nvim",
    ft = { "typst" },
    version = "1.*",
    opts = {},
    keys = {
      { "<localleader>tt", "<cmd>TypstPreviewToggle<cr>", desc = "Typst Preview Toggle" },
    },
  },
  {
    "wllfaria/ledger.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
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
    "vuki656/package-info.nvim",
    config = function()
      require("misc.package_info").config()
    end,
    enabled = O.webdev and O.misc,
    ft = { "json" },
  },
  {
    "danymat/neogen",
    opts = require("misc.neogen").opts,
    dependencies = "nvim-treesitter/nvim-treesitter",
    enabled = O.language_parsing,
    event = "InsertEnter",
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
}
