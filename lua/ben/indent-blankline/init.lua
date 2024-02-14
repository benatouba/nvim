local M = {}

M.config = function()
	local ibl_ok, ibl = pcall(require, "ibl")
	if not ibl_ok then
		vim.notify("ibl not okay")
		return
	end
	local highlight = {
		-- "CursorColumn",
		"Whitespace",
	}
	ibl.setup({
		indent = { highlight = highlight, tab_char = "" },
		scope = { enabled = true },
		whitespace = {
			highlight = highlight,
			remove_blankline_trail = true,
		},
		exclude = {
			buftypes = { "terminal", "fugitive", "neogit" },
			filetypes = { "help", "startify", "dashboard", "packer", "neogitstatus", "fugitive" },
		}
	})
end

return M
