local M = {}

local diffview_ok, diffview = pcall(require, "diffview")
if not diffview_ok then
  vim.notify("Diffview not found", vim.log.levels.ERROR)
  return
end


M.DiffviewToggle = function ()
  local lib = require("diffview.lib")
  local view = lib.get_current_view()
  if view then
    vim.cmd(":DiffviewClose")
  else
    vim.cmd(":DiffviewOpen")
  end
end

M.config = function ()
  diffview.setup({
    diff_binaries = false,
    enhanced_diff_hl = true,
    view = {
      default = {
        layout = "diff2_horizontal",
        winbar_info = true,
        disable_diagnostics = true,
      },
      merge_tool = {
        layout = "diff3_horizontal",
        disable_diagnostics = true,
        winbar_info = true,
      },
      file_history = {
        layout = "diff2_horizontal",
        winbar_info = true,
      },
    },
  })
end

return M
