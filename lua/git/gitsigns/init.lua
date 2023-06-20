local isOk, gitsigns = pcall(require, "gitsigns")
if not isOk then
	vim.notify("Gitsigns not okay")
	return
end

local wkOk, wk = pcall(require, "which-key")
if not wkOk then
	vim.notify("Which-key not okay in gitsigns")
	return
end
local M = {}

M.config = function()
	gitsigns.setup({
		signs                        = {
			add          = { text = '│' },
			change       = { text = '│' },
			delete       = { text = '契' },
			topdelete    = { text = '契' },
			changedelete = { text = '┆' },
			untracked    = { text = '┆' },
		},
		signcolumn                   = true,
		numhl                        = true,
		linehl                       = false,
		word_diff                    = false,
		watch_gitdir                 = {
			interval = 1000,
			follow_files = true,
		},
		attach_to_untracked          = true,
		current_line_blame           = false,
		current_line_blame_opts      = {
			virt_text = true,
			virt_text_pos = 'eol',
			delay = 1000,
		},
		current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
		sign_priority                = 6,
		update_debounce              = 100,
		status_formatter             = nil, -- Use default
		on_attach                    = function(bufnr)
			local gs = package.loaded.gitsigns

			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end

			-- Navigation
			map("n", "]g", "", {
				desc = "Git hunk",
				callback = function()
					if vim.wo.diff then
						return "]g"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end,
				expr = true,
			})

			map("n", "[g", "", {
				desc = "Git hunk",
				callback = function()
					if vim.wo.diff then
						return "[g"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end,
				expr = true,
			})
		end,
	})
	local maps = {
		["g"] = {
			name = "+Git",
			b = { "<cmd>Gitsigns blame_line<cr>", "Blame line" },
			B = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Blame line (toggle)" },
			h = { "<cmd>lua require'gitsigns'.preview_hunk()<cr>", "preview Hunk" },
			j = { "<cmd>lua require'gitsigns.actions'.next_hunk()<cr>", "Next Hunk" },
			k = { "<cmd>lua require'gitsigns.actions'.prev_hunk()<cr>", "Prev Hunk" },
			r = { "<cmd>lua require'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
			R = { "<cmd>lua require'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
			s = { "<cmd>lua require'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
			u = { "<cmd>lua require'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
		}
	}
	local opts = {
		mode = "n", -- NORMAL mode
		prefix = "<leader>",
		-- buffer = nil, -- Global maps. Specify a buffer number for buffer local maps
		silent = true, -- use `silent` when creating keymaps
		noremap = true, -- use `remap` when creating keymaps
		nowait = false, -- use `nowait` when creating keymaps
	}
	wk.register(maps, opts)
end

return M