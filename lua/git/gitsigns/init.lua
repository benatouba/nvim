local isOk, gitsigns = pcall(require, "gitsigns")
if not isOk then
	vim.notify("Gitsigns not okay")
	return
end

gitsigns.setup({
	signs = {
		add          = { text = '│' },
		change       = { text = '│' },
		delete       = { text = '契' },
		topdelete    = { text = '契' },
		changedelete = { text = '┆' },
		untracked    = { text = '┆' },
	},
	signcolumn = true,
	numhl = true,
	linehl = false,
	word_diff  = false,
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
	attach_to_untracked = true,
	current_line_blame = false,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = 'eol',
		delay = 1000,
	},
	current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	on_attach = function(bufnr)
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