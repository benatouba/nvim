local lspsaga_ok, lspsaga = pcall(require, "lspsaga")
if not lspsaga_ok then
	vim.notify("Lspsaga not ok", vim.log.levels.ERROR)
	return
end

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
	vim.notify("which-key not ok", vim.log.levels.ERROR)
	return
end

local M = {}

M.config = function()
	lspsaga.setup({
		code_action = {
			num_shortcut = true,
			show_server_name = true,
			extend_gitsigns = true,
			keys = {
				quit = {"q", "<ESC>"},
				exec = "<CR>",
			},
		},
		lightbulb = {
			enable = false,
		},
		hover = {
			enable = true,
			max_width = 0.6,
			open_link = 'gx',
			open_browser = '!brave',
		},
		ui = {
			-- This option only works in Neovim 0.9
			title = true,
			-- Border type can be single, double, rounded, solid, shadow.
			border = "rounded",
			winblend = 0,
			expand = "",
			collapse = "",
			code_action = "💡",
			incoming = " ",
			outgoing = " ",
			hover = ' ',
			kind = {},
		},
		request_timeout = 5000,
	})

	local gmaps = {
		a = { "<cmd>Lspsaga code_action<CR>", "Code Action" },
		d = { "<cmd>Lspsaga goto_definition<CR>", "Definition" },
		h = { "<cmd>Lspsaga finder<CR>", "Help" },
		I = { "<cmd>Lspsaga finder imp<CR>", "Implementation" },
		o = { "<cmd>Lspsaga outline<CR>", "Outline" },
		p = { "<cmd>Lspsaga peek_definition<CR>", "Peek" },
	}
	wk.register(gmaps, { mode = "n", prefix = "g"})
	local forward_maps = {
		d = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next Diagnostic" },
	}
	local backward_maps = {
		d = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Prev Diagnostic" },
	}
	wk.register(forward_maps, { mode = "n", prefix = "]"})
	wk.register(backward_maps, { mode = "n", prefix = "["})
	vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<cr>')
end


return M