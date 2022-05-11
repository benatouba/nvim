local isOk, which_key = pcall(require, "which-key")
if not isOk then
	return
end

which_key.setup()

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	-- buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `remap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

local terminal_mappings = {}
local terminal_opts = { mode = "t" }
-- Set leader
-- vim.keymap.del("n", " ")
vim.g.mapleader = " "

local mappings = {
	["m"] = { ":MaximizerToggle<CR>", "Maximize/Minimize" },
	["c"] = { ":BufferClose<CR>", "Close Buffer" },
	-- ["h"] = {":HopChar2<cr>", "hop to 2 char sequence"},
	-- ["H"] = {":HopWord<cr>", "hop to word"},
	["e"] = { ":CHADopen<cr>", "Explorer" },
	["u"] = { ":UndotreeToggle<cr>", "Undotree" },

	-- a is for actions
	a = {
		name = "+Actions",
		-- c = {"<cmd>ColorizerToggle<cr>", "colorizer"},
		h = { "<cmd>let @/ = ''<cr>", "remove highlighted" },
		H = { ":set hlsearch!<CR>", "turn off highlight" },
		-- i = {"<cmd>IndentBlanklineToggle<cr>", "toggle indent lines"},
		-- m = {"<cmd>MaximizerToggle<cr>", "maximize"},
		n = { "<cmd>set nonumber<cr>!", "line-numbers" },
		N = { "<cmd>set norelativenumber!<cr>", "relative line nums" },
		s = { "<cmd>s/\\%V\\(.*\\)\\%V/'\\1'/<cr>", "surround" },
		r = { "<cmd>Root<cr>", "root working dir" },
		w = { "<cmd>call TrimWhitespace()<cr>", "trim Whitespaces" },
		-- t = {"<cmd>TSHighlightCapturesUnderCursor<cr>", "treesitter highlight"},
		R = { ":nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>", "redraw" },
	},

	p = {
		name = "+Packer",
		c = { "<cmd>PackerClean<cr>", "Clean" },
		C = { "<cmd>PackerCompile profile=true<cr>", "Compile" },
		i = { "<cmd>PackerInstall<cr>", "Install" },
		s = { "<cmd>PackerSync<cr>", "Sync" },
		S = { "<cmd>PackerStatus<cr>", "Status" },
		u = { "<cmd>PackerUpdate<cr>", "Update" },
	},

	s = {
		name = "+Search",
		b = { "<cmd>Telescope git_branches<cr>", "Branches" },
		B = { "<cmd>Telescope file_browser<cr>", "Browser" },
		c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		d = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Document Diagnostics" },
		D = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
		f = { "<cmd>Telescope find_files<cr>", "Find File" },
		g = { "<cmd>Telescope git_files<cr>", "Git Files" },
		m = { "<cmd>Telescope marks<cr>", "Marks" },
		M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		o = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		p = { "<cmd>Telescope projects<cr>", "Projects" },
		q = { "<cmd>Telescope quickfix<cr>", "Quickfix List" },
		r = { "<cmd>Telescope frecency<cr>", "Frecency" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols (LSP)" },
		S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols (LSP)" },
		t = { "<cmd>Telescope live_grep<cr>", "Text" },
		T = { "<cmd>Telescope treesitter<cr>", "Treesitter Symbols" },
	},

	-- S = {name = "+Session", s = {"<cmd>SessionSave<cr>", "Save Session"}, l = {"<cmd>SessionLoad<cr>", "Load Session"}}
}
if O.lsp then
	mappings["l"] = {
		name = "+LSP",
		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
		A = { "<cmd>lua vim.lsp.buf.range_code_action()<cr>", "Selected Action" },
		d = { "<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics" },
		D = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics" },
		f = { "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", "Format Document" },
		h = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Find definition" },
		i = { "<cmd>LspInstallInfo<cr>", "Install Info" },
		I = { "<cmd>LspInfo<cr>", "Info" },
		n = { "<cmd>NullLsInfo<cr>", "Null-Ls Info" },
		j = {
			"<cmd>lua vim.diagnostic.goto_next({popup_opts = {border = O.lsp.popup_border}})<cr>",
			"Next Diagnostic",
		},
		k = {
			"<cmd>lua vim.diagnostic.goto_prev({popup_opts = {border = O.lsp.popup_border}})<cr>",
			"Prev Diagnostic",
		},
		q = { "<cmd>Telescope quickfix<cr>", "Quickfix" },
		r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		t = { "<cmd>LspTypeDefinition<cr>", "Type Definition" },
		x = { "<cmd>cclose<cr>", "Close Quickfix" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
		S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols" },
	}
end

mappings["L"] = {
	name = "+Logs",
	c = { "<cmd>LuaCacheProfile<cr>", "CacheProfile" },
	p = { "<cmd>PackerProfile<cr>", "PackerProfile" },
}

if O.git then
	mappings["g"] = {
		name = "+Git",
		a = { "<cmd>Git add %<cr>", "Add/Stage File" },
		c = { "<cmd>Git commit %<cr>", "Commit File" },
		C = { "<cmd>Git commit<cr>", "Commit staged" },
		g = { "<cmd>G<cr>", "Fugitive" },
		h = { "<cmd>lua require'gitsigns'.preview_hunk()<cr>", "preview Hunk" },
		l = { "<cmd>Git log<cr>", "Log" },
		n = { "<cmd>Neogit<cr>", "Neogit" },
		N = { "<cmd>Neogit commit %<cr>", "(Neogit) Commit Menu" },
		j = { "<cmd>lua require'gitsigns.actions'.next_hunk()<cr>", "Next Hunk" },
		k = { "<cmd>lua require'gitsigns.actions'.prev_hunk()<cr>", "Prev Hunk" },
		p = { "<cmd>Git pull<cr>", "pull" },
		P = { "<cmd>Git push<cr>", "Push" },
		r = { "<cmd>lua require'gitsigns'.reset_hunk()<CR>',<cr>", "Reset Hunk" },
		R = { "<cmd>lua require'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
		s = { "<cmd>lua require'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
		u = { "<cmd>lua require'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
	}
end

if O.misc then
	mappings["t"] = { "<cmd>lua require('FTerm').open()<cr>", "Terminal" }
	terminal_mappings["<esc>"] = { "<C-n><cmd>lua require('FTerm').close()<cr>", "Close Terminal" }
	terminal_mappings["<c-q>"] = { "<C-n><cmd>lua require('FTerm').exit()<cr>", "Close Terminal" }
	mappings["n"] = {
		name = "+Generate Annotations",
		n = { "<cmd>lua require('neogen').generate()<CR>", "Auto" },
		c = { "<cmd>lua require('neogen').generate({ type = 'class'})<CR>", "Class" },
		f = { "<cmd>lua require('neogen').generate({ type = 'func'})<CR>", "Function" },
		t = { "<cmd>lua require('neogen').generate({ type = 'type'})<CR>", "Type" },
	}
end

if O.testing then
	mappings["T"] = {
		name = "+Tests",
	}
end

if O.project_management then
	mappings["o"] = {
		name = "+Organisation",
		a = { "<cmd>lua require('orgmode').action('agenda.prompt')<CR>", "Agenda" },
		c = { "<cmd>lua require('orgmode').action('capture.prompt')<CR>", "Capture" },
	}
end
local diffmaps = {
	["dr"] = { ":diffget RE<CR>", "Diffget remote" },
	["dl"] = { ":diffget LO<CR>", "Diffget local" },
	["db"] = { ":diffget BA<CR>", "Diffget base" },
}
which_key.register(mappings, opts)
which_key.register(diffmaps, {
	mode = "n", -- NORMAL mode
	-- buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
})
which_key.register(terminal_mappings, terminal_opts)

local gmaps = {
	["rr"] = { "<cmd>lua require('nvim-treesitter-refactor.smart_rename')<cr>", "TS Rename" }
}
which_key.register(gmaps, {
	mode = "n", -- NORMAL mode
	prefix = "g"
})
