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
			add          = { text = '▎' },
			change       = { text = '▎' },
			delete       = { text = '_' },
			topdelete    = { text = '‾' },
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
			virt_text_pos = 'right_align',
			delay = 500,
		},
		current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
		sign_priority                = 6,
		update_debounce              = 100,
		status_formatter             = nil, -- Use default
		max_file_length = 10000, -- Disable if file is longer than this (in lines)
		preview_config = {
			border = 'single',
			style = 'minimal',
			relative = 'cursor',
			row = 0,
			col = 1
		},
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
	wk.add({
    { "<leader>g", group = "Git", nowait = false, remap = false },
    { "<leader>gB", "<cmd>Gitsigns blame_line<cr>", desc = "Blame line", nowait = false, remap = false },
    { "<leader>gD", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff this HEAD", nowait = false, remap = false },
    { "<leader>gR", "<cmd>lua require'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer", nowait = false, remap = false },
    { "<leader>gS", "<cmd>lua require'gitsigns'.stage_buffer()<cr>", desc = "Stage Buffer", nowait = false, remap = false },
    { "<leader>gT", "<cmd>lua require'gitsigns'.toggle_deleted()<cr>", desc = "Toggle Deleted", nowait = false, remap = false },
    { "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff this", nowait = false, remap = false },
    { "<leader>gh", "<cmd>lua require'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk", nowait = false, remap = false },
    { "<leader>gj", "<cmd>lua require'gitsigns.actions'.next_hunk()<cr>", desc = "Next Hunk", nowait = false, remap = false },
    { "<leader>gk", "<cmd>lua require'gitsigns.actions'.prev_hunk()<cr>", desc = "Prev Hunk", nowait = false, remap = false },
    { "<leader>gl", "<cmd>Gitsigns setloclist<cr>", desc = "Set loclist", nowait = false, remap = false },
    { "<leader>gq", "<cmd>Gitsigns setqflist<cr>", desc = "Set quickfix", nowait = false, remap = false },
    { "<leader>gr", "<cmd>lua require'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk", nowait = false, remap = false },
    { "<leader>gs", "<cmd>lua require'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk", nowait = false, remap = false },
    { "<leader>gu", "<cmd>lua require'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk", nowait = false, remap = false },
  })
end

return M
