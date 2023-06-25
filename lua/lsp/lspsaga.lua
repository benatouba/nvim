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
			enable = false,
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
		h = { "<cmd>Lspsaga lsp_finder<CR>", "Help" },
		d = { "<cmd>Lspsaga goto_definition<CR>", "Definition" },
		p = { "<cmd>Lspsaga peek_definition<CR>", "Declaration" },
		o = { "<cmd>Lspsaga outline<CR>", "Outline" },
	}
	wk.register(gmaps, { mode = "n", prefix = "g"})
end


return M