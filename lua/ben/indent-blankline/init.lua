local M = {}

local highlight = {
  -- "CursorColumn",
  "Whitespace",
}

M.opts = {
  indent = { highlight = highlight, tab_char = "" },
  scope = { enabled = false },
  whitespace = {
    highlight = highlight,
    remove_blankline_trail = true,
  },
  exclude = {
    buftypes = { "terminal", "fugitive", "neogit" },
    filetypes = { "help", "startify", "dashboard", "packer", "neogitstatus", "fugitive" },
  },
}

return M
