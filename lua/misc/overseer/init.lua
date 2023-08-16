local M = {}

M.config = function()
	local status_ok, overseer = pcall(require, "overseer")
	if not status_ok then
		vim.notify("Overseer.nvim not okay")
		return
	end
	overseer.setup()
end

return M