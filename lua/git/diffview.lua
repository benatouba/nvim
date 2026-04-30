local M = {}

local diffview_ok, diffview = pcall(require, "diffview")
if not diffview_ok then
  vim.notify("Diffview not found", vim.log.levels.ERROR)
  return
end

M.config = function()
  vim.opt.diffopt = {
    "internal",
    "filler",
    "closeoff",
    "context:12",
    "algorithm:histogram",
    "linematch:200",
    "indent-heuristic",
    "iwhite", -- I toggle this one, it doesn't fit all cases.
  }
  diffview.setup({
    diff_binaries = false,
    enhanced_diff_hl = true,
    hide_merge_artifacts = true,
    clean_up_buffers = true,
    auto_close_on_empty = true,
    diffopt = { algorithm = "histogram" },
    default_args = {
      DiffviewOpen = { "--imply-local" },
    },
    file_panel = {
      show_branch_name = true,
      always_show_sections = true,
    },
    view = {
      default = {
        layout = "diff2_horizontal",
        winbar_info = true,
        disable_diagnostics = true,
      },
      merge_tool = {
        layout = "diff4_mixed",
        disable_diagnostics = true,
        winbar_info = true,
      },
      cycle_layouts = {
        merge_tool = { "diff4_mixed", "diff3_mixed", "diff3_horizontal", "diff1_plain" },
      },
      file_history = {
        layout = "diff2_horizontal",
        winbar_info = true,
      },
    },
    keymaps = {
      view = {
        { "n", "q", require("diffview.config").actions.close, { desc = "Close help menu" } },
      },
      file_panel = {
        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close help menu" } },
      },
      file_history_panel = {
        { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close help menu" } },
      },
    },
  })
end

return M
