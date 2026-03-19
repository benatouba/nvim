return {
  {
    "folke/tokyonight.nvim",
    lazy = string.find(O.colorscheme, "tokyonight") == nil,
    priority = 1000,
    opts = {
      style = "storm",
      transparent = false,
      hide_inactive_statusline = false,
    },
    enabled = true,
  },
  {
    "rebelot/kanagawa.nvim",
    opts = { compile = true, dimInactive = true },
    lazy = string.find(O.colorscheme, "kanagawa") == nil,
    enabled = O.misc or string.find(O.colorscheme, "kanagawa") ~= nil,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    enabled = O.misc or string.find(O.colorscheme, "rose-pine") ~= nil,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = string.find(O.colorscheme, "catppuccin") == nil,
    opts = require("ui.catppuccin").opts,
    enabled = O.misc or string.find(O.colorscheme, "catppuccin") ~= nil,
  },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("everforest").setup({})
    end,
  },
}
