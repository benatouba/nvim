local M = {}

M.init = function()
  vim.g.barbar_auto_setup = true
end

M.opts = {
  animation = true,
  auto_hide = 1,
  clickable = false,
  tabpages = true,
  highlight_alternate = true,
  exclude_ft = { "oil" },
  icons = {
    gitsigns = {
      added = { enabled = true, icon = "+" },
      changed = { enabled = true, icon = "~" },
      deleted = { enabled = true, icon = "-" },
    },
    inactive = { button = false },
    button = false,
  },
}

return M
