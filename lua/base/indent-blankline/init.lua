local M = {}

M.config = function()
	local ibl_ok, ibl = pcall(require, "ibl")
	if not ibl_ok then
		vim.notify("ibl not okay")
		return
	end
	local highlight = {
		"CursorColumn",
		"Whitespace",
	}
	ibl.setup({
		indent = { highlight = highlight, char = " ", tab_char = "▎" },
		scope = { enabled = false },
		whitespace = {
			highlight = highlight,
			char = "·",
			remove_blankline_trail = true,
		},
		exclude = {
			buftypes = { "terminal", "fugitive", "neogit" },
			filetypes = { "help", "startify", "dashboard", "packer", "neogitstatus", "fugitive" },
		}
	})
end

return M