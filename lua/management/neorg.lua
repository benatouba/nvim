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

local neorg_callbacks = require("neorg.callbacks")

neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
    -- Map all the below keybinds only when the "norg" mode is active
    keybinds.map_event_to_mode("norg", {
        n = { -- Bind keys in normal mode
            { "<leader>oO", "core.integrations.telescope.find_linkable" },
        },
        i = { -- Bind in insert mode
            { "<C-l>", "core.integrations.telescope.insert_link" },
        },
    }, {
        silent = true,
        noremap = true,
    })
end)

M.config = function()
	neorg.setup({
		load = {
			["core.defaults"] = {},    -- Loads default behaviour
			["core.concealer"] = {}, -- Adds pretty icons to your documents
			["core.export"] = {},
			["core.export.markdown"] = {},
			["core.completion"] = { config = { engine = "nvim-cmp" } },
			["core.dirman"] = {   -- Manages Neorg workspaces
				config = {
					workspaces = {
						notes = "~/documents/vivere/neorg",
						work = "~/documents/vivere/neorg/work",
						home = "~/documents/vivere/neorg/home",
					},
					default_workspace = "notes",
				},
			},
			["core.integrations.telescope"] = {}, -- Allows for use of telescope
			["core.integrations.treesitter"] = {}, -- Allows for use of treesitter
		},
	})
	local maps = {
		-- o is for organising
		o = {
			name = "+neorg",
			w = { "<cmd>Neorg workspace notes<CR>", "Notes Workspace" },
		},
	}

	wk.register(maps, {
		mode = "n", -- NORMAL mode
		prefix = "<leader>",
	})
end

return M