local M = {}
M.config = function ()
  local pi_ok, pi = pcall(require, "package-info")
  if not pi_ok then
    vim.notify("package-info not ok", vim.log.levels.ERROR)
    return
  end
  pi.setup({
    package_manager = "pnpm",
    colors = {
        up_to_date = "237",
        outdated = "173",
    },
    hide_up_to_date = true,
  })
  local wk_ok, wk = pcall(require, "which-key")
  if not wk_ok then
    vim.notify("which-key not ok in package-info", vim.log.levels.ERROR)
    return
  end
  local maps = {
    { "<leader>lp", group = "Packages", icon = { icon = "", color = "red" } },
    { "<leader>lpa", "<cmd>lua require('package-info').install()<cr>", desc = "Add" },
    { "<leader>lpc", "<cmd>lua require('package-info').change_version()<cr>", desc = "Change version" },
    { "<leader>lpd", "<cmd>lua require('package-info').delete()<cr>", desc = "Delete" },
    { "<leader>lph", "<cmd>lua require('package-info').hide()<cr>", desc = "Hide" },
    { "<leader>lpi", "<cmd>lua require('package-info').install()<cr>", desc = "Install" },
    { "<leader>lps", "<cmd>lua require('package-info').show()<cr>", desc = "Show" },
    { "<leader>lpt", "<cmd>lua require('package-info').toggle()<cr>", desc = "Toggle" },
    { "<leader>lpu", "<cmd>lua require('package-info').update()<cr>", desc = "Update" },
  }
  wk.add(maps)
end
return M
