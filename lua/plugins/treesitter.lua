return {
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
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
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
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      vim.g.matchup_surround_enabled = 1
    end,
    keys = { "%" },
    event = "InsertEnter",
    enabled = O.language_parsing and vim.fn.has("nvim-0.13") == 0,
  },
}
