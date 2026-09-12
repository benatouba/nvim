-- The active colorscheme loads eagerly with high priority and applies itself; every
-- other scheme is lazy and can be loaded on demand with :Lazy load <name>.
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = require("ui.catppuccin").opts,
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "storm",
      transparent = false,
      hide_inactive_statusline = false,
    },
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = { compile = true, dimInactive = true },
  },
  { "rose-pine/neovim", name = "rose-pine", lazy = true },
  { "neanias/everforest-nvim", version = false, lazy = true, opts = {} },
}
