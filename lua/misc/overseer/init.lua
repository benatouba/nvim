local M = {}

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  vim.notify("Which-key not found in overseer", vim.log.levels.ERROR)
end

M.config = function ()
  local status_ok, overseer = pcall(require, "overseer")
  if not status_ok then
    vim.notify("Overseer.nvim not okay")
    return
  end
  overseer.setup()
  wk.add({
    { "<leader>O", group = "+Overseer" },
    { "<leader>OO", "<cmd>lua require('misc.overseer').OverseerToggle()<cr>", desc = "Toggle" },
    { "<leader>Os", "<cmd>lua require('overseer').start()<cr>", desc = "Start" },
  })
end

local isOpen = false
M.OverseerToggle = function ()
  if not isOpen then
    vim.cmd(":OverseerToggle")
    if vim.fn.exists(":WindowsDisableAutowidth") ~= 0 then
      vim.cmd(":WindowsDisableAutowidth")
    end
    if vim.fn.exists(":WindowsEqualize") ~= 0 then
      vim.cmd(":WindowsEqualize")
    end
    isOpen = true
  else
    vim.cmd(":OverseerToggle")
    if vim.fn.exists(":WindowsEnableAutowidth") ~= 0 then
      vim.cmd(":WindowsEnableAutowidth")
    end
    isOpen = false
  end
end

return M
