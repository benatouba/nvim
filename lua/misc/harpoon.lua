local M = {}

M.config = function ()
  local status_ok, harpoon = pcall(require, "harpoon")
  if not status_ok then
    vim.notify("Harpoon not okay", vim.log.levels.ERROR)
    return
  end
  local telescope_ok, telescope = pcall(require, "telescope")
  if not telescope_ok then
    vim.notify("Telescope not okay", vim.log.levels.ERROR)
    return
  end
  telescope.load_extension("harpoon")

  harpoon.setup({
    settings = {
      save_on_toggle = true,
      save_on_change = true,
    },
  })
end

M.maps = function ()
  local status_ok, harpoon = pcall(require, "harpoon")
  if not status_ok then
    vim.notify("Harpoon not okay", vim.log.levels.ERROR)
    return
  end
  local wk_ok, wk = pcall(require, "which-key")
  if not wk_ok then
    vim.notify("WhichKey not okay", vim.log.levels.ERROR)
    return
  end
  local maps = {
    { "<C-e>", "<cmd>lua require('harpoon.ui').toggle_quick_menu(require('harpoon').list())<cr>", desc = "Toggle harpoon menu" },
    { "<leader>m", group = "Marks", icon = { icon = "", color = "red" } },
    { "<leader>m0", "<cmd>lua require('harpoon'):list():select(10)<cr>", desc = "Go to mark 10" },
    { "<leader>m1", "<cmd>lua require('harpoon'):list():select(1)<cr>", desc = "Go to mark 1" },
    { "<leader>m2", "<cmd>lua require('harpoon'):list():select(2)<cr>", desc = "Go to mark 2" },
    { "<leader>m3", "<cmd>lua require('harpoon'):list():select(3)<cr>", desc = "Go to mark 3" },
    { "<leader>m4", "<cmd>lua require('harpoon'):list():select(4)<cr>", desc = "Go to mark 4" },
    { "<leader>m5", "<cmd>lua require('harpoon'):list():select(5)<cr>", desc = "Go to mark 5" },
    { "<leader>m6", "<cmd>lua require('harpoon'):list():select(6)<cr>", desc = "Go to mark 6" },
    { "<leader>m7", "<cmd>lua require('harpoon'):list():select(7)<cr>", desc = "Go to mark 7" },
    { "<leader>m8", "<cmd>lua require('harpoon'):list():select(8)<cr>", desc = "Go to mark 8" },
    { "<leader>m9", "<cmd>lua require('harpoon'):list():select(9)<cr>", desc = "Go to mark 9" },
    { "<leader>mm", "<cmd>lua require('harpoon'):list():append()<cr>", desc = "Add mark" },
    { "<leader>mn", "<cmd>lua require('harpoon.mark').nav_next()<cr>", desc = "Next mark" },
    { "<leader>mp", "<cmd>lua require('harpoon.mark').nav_prev()<cr>", desc = "Prev mark" },
    { "<leader>mt", "<cmd>Telescope harpoon marks<cr>", desc = "Toggle menu" },
    { "[m", "<cmd>lua require('harpoon.mark').nav_prev()<cr>", desc = "Prev mark" },
    { "]m", "<cmd>lua require('harpoon.mark').nav_next()<cr>", desc = "Next mark" },
  }
  wk.add(maps)
end

return M
