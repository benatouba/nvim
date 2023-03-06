local M = {}
local isOk, colortils = pcall(require, 'colortils')
if not isOk then
	vim.notify('Colortils not okay')
	return
end

local wkOk, which_key = pcall(require, 'which-key')
if not isOk then
	vim.notify('Which key not okay in Colortils')
	return
end

M.config = function()
	colortils.setup()
	local maps = {
		C = {
			name = "+Colors",
			c = { "<cmd>Colortils css list<cr>", "CSS Colors list" },
			d = { "<cmd>Colortils darken<cr>", "Darken" },
			g = { "<cmd>Colortils gradient<cr>", "Gradient" },
			G = { "<cmd>Colortils greyscale<cr>", "Greyscale" },
			l = { "<cmd>Colortils lighten<cr>", "Lighten" },
			p = { "<cmd>Colortils picker<cr><cr>", "Picker" },
		}
	}
	which_key.register(maps, {
		mode = "n", -- NORMAL mode
		prefix = "<leader>",
	})
end
return M