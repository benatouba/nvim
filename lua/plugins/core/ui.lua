-- Core interface: the active colorscheme, statusline and icons.
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
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      override = {
        nvim = { icon = "", color = "#67B25E", cterm_color = "83", name = "Neovim" },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "AndreM222/copilot-lualine",
        enabled = function()
          return vim.fn.executable("node") == 1
        end,
      },
    },
    opts = function()
      return require("plugins.configs.lualine").opts()
    end,
  },
}
