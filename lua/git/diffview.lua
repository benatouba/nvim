local M = {}

local diffview_ok, diffview = pcall(require, "diffview")
if not diffview_ok then
  vim.notify("Diffview not found", vim.log.levels.ERROR)
  return
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
        disable_diagnostics =true,
      },
      file_history = {
        layout = "diff2_horizontal",
      }
    }
  })
end

return M
