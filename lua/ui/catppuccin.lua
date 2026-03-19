local M = {}

M.opts = {
  flavour = "mocha", -- mocha, macchiato, frappe, latte
  transparent_background = false,
  background = { -- :h background
    light = "latte",
    dark = "mocha",
  },
  compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
  integrations = {
    barbar = true,
    blink_cmp = O.lsp,
    cmp = O.lsp,
    dadbod_ui = true,
    dap = O.dap,
    dap_ui = O.dap,
    gitsigns = O.git,
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
}

return M
