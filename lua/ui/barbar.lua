local M = {}

M.config = function()
  local ok, barbar = pcall(require, "barbar")
  if not ok then
    vim.notify("barbar.nvim not found", vim.log.levels.ERROR)
    return
  end

  vim.g.barbar_auto_setup = true

  barbar.setup({
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
  })
end
return M
