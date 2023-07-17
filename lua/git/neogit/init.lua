local isOk, neogit = pcall(require, "neogit")
if not isOk then
    vim.notify('Neogit not okay')
end

local M = {}

M.config = function()
    neogit.setup {
        integrations = { diffview = true },
        disable_commit_confirmation = true,
    }
end

return M