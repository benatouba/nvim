return {
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
    version = "1.*",
    build = "cargo build --release",
    event = "VeryLazy",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "mikavilpas/blink-ripgrep.nvim",
      "Kaiser-Yang/blink-cmp-git",
      "hrsh7th/cmp-nvim-lua",
      "joelazar/blink-calc",
      "moyiz/blink-emoji.nvim",
      "onsails/lspkind.nvim",
      "disrupted/blink-cmp-conventional-commits",
      "mayromr/blink-cmp-dap",
      "alexandre-abrioux/blink-cmp-npm.nvim",
    },
    opts = require("lsp.blink").opts,
    opts_extend = { "sources.default" },
  },
}
