local neorg_ok, neorg = pcall(require, "neorg")
if not neorg_ok then
	vim.notify("neorg not ok")
	return
end

local which_key_ok, wk = pcall(require, "which-key")
if not which_key_ok then
	vim.notify("which-key not ok in neorg")
	return
end

local M = {}

M.config = function()
	neorg.setup({
		load = {
			["core.defaults"] = {}, -- Loads default behaviour
			["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
			["core.norg.dirman"] = { -- Manages Neorg workspaces
				config = {
					workspaces = {
						notes = "~/documents/vivere",
					},
				},
			},
		},
	})
	local maps = {
		-- o is for organising
		o = {
			name = "+neorg",
			w = { "<cmd>Neorg workspace main<CR>", "Main Workspace" },
		},
	}

	wk.register(maps, {
		mode = "n", -- NORMAL mode
		prefix = "<leader>",
	})
end

return M