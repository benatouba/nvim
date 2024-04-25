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
    ["p"] = {
      name= "+Packages",
      ["a"] = {"<cmd>lua require('package-info').install()<cr>", "Add"},
      ["c"] = {"<cmd>lua require('package-info').change_version()<cr>", "Change version"},
      ["d"] = {"<cmd>lua require('package-info').delete()<cr>", "Delete"},
      ["h"] = {"<cmd>lua require('package-info').hide()<cr>", "Hide"},
      ["i"] = {"<cmd>lua require('package-info').install()<cr>", "Install"},
      ["s"] = {"<cmd>lua require('package-info').show()<cr>", "Show"},
      ["t"] = {"<cmd>lua require('package-info').toggle()<cr>", "Toggle"},
      ["u"] = {"<cmd>lua require('package-info').update()<cr>", "Update"},
    }
  }
  wk.register(maps, { prefix = "<leader>l" })
end
return M
