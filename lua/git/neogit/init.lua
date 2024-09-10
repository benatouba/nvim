local isOk, neogit = pcall(require, "neogit")
if not isOk then
  vim.notify("Neogit not okay")
end

local M = {}

M.config = function ()
  local dvOk, _ = pcall(require, "diffview")
  if not dvOk then
    vim.notify("Diffview not okay in neogit")
  end
  local tsOk, _ = pcall(require, "diffview")
  if not tsOk then
    vim.notify("Telescope not okay in neogit")
  end
  neogit.setup {
    integrations = {
      diffview = dvOk,
      telescope = tsOk,
    },
    disable_commit_confirmation = true,
  }
end

return M
