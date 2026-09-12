-- The active colorscheme loads eagerly with high priority and applies itself; every
-- other scheme is lazy and can be loaded on demand with :Lazy load <name>.
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha", -- mocha, macchiato, frappe, latte
      transparent_background = false,
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
      integrations = {
        barbar = true,
        blink_cmp = true,
        cmp = true,
        dadbod_ui = true,
        dap = true,
        dap_ui = true,
        gitsigns = true,
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
    },
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
