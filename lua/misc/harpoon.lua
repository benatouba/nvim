local M = {}

M.config = function()
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
    global_settings = {
      save_on_toggle = true,
      save_on_change = true,
    },
  })
end

M.maps = function ()
  local status_ok, _ = pcall(require, "harpoon")
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
    m = {
      name = "+Marks",
      m = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add mark" },
      t = { "<cmd>Telescope harpoon marks<cr>", "Toggle menu" },
      n = { "<cmd>lua require('harpoon.mark').nav_next()<cr>", "Next mark" },
      p = { "<cmd>lua require('harpoon.mark').nav_prev()<cr>", "Prev mark" },
      ["1"] = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "Go to mark 1" },
      ["2"] = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "Go to mark 2" },
      ["3"] = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "Go to mark 3" },
      ["4"] = { "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", "Go to mark 4" },
      ["5"] = { "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", "Go to mark 5" },
      ["6"] = { "<cmd>lua require('harpoon.ui').nav_file(6)<cr>", "Go to mark 6" },
      ["7"] = { "<cmd>lua require('harpoon.ui').nav_file(7)<cr>", "Go to mark 7" },
      ["8"] = { "<cmd>lua require('harpoon.ui').nav_file(8)<cr>", "Go to mark 8" },
      ["9"] = { "<cmd>lua require('harpoon.ui').nav_file(9)<cr>", "Go to mark 9" },
      ["0"] = { "<cmd>lua require('harpoon.ui').nav_file(10)<cr>", "Go to mark 10" },
    }
  }
  local opts = {
    mode = "n",
    prefix = "<leader>",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = false,
  }
  wk.register(maps, opts)

  local nmaps = {}
  nmaps["]m"] = { "<cmd>lua require('harpoon.mark').nav_next()<cr>", "Next mark" }
  nmaps["[m"] = { "<cmd>lua require('harpoon.mark').nav_prev()<cr>", "Prev mark" }
  local nopts = {
    mode = "n",
    prefix = "",
    buffer = nil,
    silent = true,
    noremap = true,
    nowait = false,
  }
  wk.register(nmaps, nopts)
end

return M
