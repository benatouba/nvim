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
    key_bindings = {
      disable_defaults = false,
    },
    use_icons = true,
    view = {
      default = {
        layout = "diff2_horizontal",
      },
      merge_tool = {
        layout = "diff3_mixed",
        disable_diagnostics = true,
      },
      file_history = {
        layout = "diff2_horizontal",
      },
    },
  })

  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.add({
      { "<leader>gt", "<cmd>lua require('git.diffview').DiffviewToggle()<cr>", desc = "Diffview" },
    })
  else
    vim.notify("Which-key not found in diffview", vim.log.levels.ERROR)
  end
end

return M
