local isOk, which_key = pcall(require, "which-key")
if not isOk then
	return
end

which_key.setup()

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	-- buffer = nil, -- Global maps. Specify a buffer number for buffer local maps
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `remap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

local terminal_maps = {}
local terminal_opts = { mode = "t" }
local visual_maps = {}
local visual_opts = { mode = "v" }
local vmaps = {
	['<leader>t'] = { "<cmd>ToggleTermSendVisualLines<cr>", "Send to terminal" }
}
which_key.register(vmaps, visual_opts)
-- Set leader
-- vim.keymap.del("n", " ")
vim.g.mapleader = " "

local nmaps = {}

local maps = {
	-- ["h"] = {":HopChar2<cr>", "hop to 2 char sequence"},
	-- ["H"] = {":HopWord<cr>", "hop to word"},
	["e"] = { ":NvimTreeToggle<cr>", "Explorer" },
	["u"] = { ":UndotreeToggle<cr>", "Undotree" },
	-- a is for actions
	a = {
		name = "+Actions",
		c = { ":BufferClose<CR>", "Close Buffer" },
		C = { "<cmd>ColorizerToggle<cr>", "Toggle Colorizer" },
		h = { "<cmd>let @/ = ''<cr>", "remove highlighted" },
		H = { ":set hlsearch!<CR>", "turn off highlight" },
		-- i = {"<cmd>IndentBlanklineToggle<cr>", "toggle indent lines"},
		-- m = {"<cmd>MaximizerToggle<cr>", "maximize"},
		n = { "<cmd>set nonumber<cr>!", "line-numbers" },
		N = { "<cmd>set norelativenumber!<cr>", "relative line nums" },
		m = { "<cmd>MaximizerToggle<cr>", "Maximize/Minimize" },
		-- s = { "<cmd>s/\\%V\\(.*\\)\\%V/'\\1'/<cr>", "surround" },
		s = { "<cmd>source %<cr>", "Source file" },
		-- r = { "<cmd>Root<cr>", "root working dir" },
		w = { "<cmd>call TrimWhitespace()<cr>", "trim Whitespaces" },
		-- t = {"<cmd>TSHighlightCapturesUnderCursor<cr>", "treesitter highlight"},
		R = { ":nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>", "redraw" },
	},
	p = {
		name = "+Plugins",
		c = { "<cmd>Lazy clean<cr>", "Clean" },
		C = { "<cmd>Lazy check<cr>", "Check" },
		d = { "<cmd>Lazy debug<cr>", "Debug" },
		h = { "<cmd>Lazy help<cr>", "Help" },
		i = { "<cmd>Lazy install<cr>", "Install" },
		l = { "<cmd>Lazy log<cr>", "Log" },
		p = { "<cmd>Lazy profile<cr>", "Profile" },
		r = { "<cmd>Lazy restore<cr>", "Restore" },
		s = { "<cmd>Lazy sync<cr>", "Sync" },
		u = { "<cmd>Lazy update<cr>", "Update" },
	},
	b = { "<cmd>Telescope buffers<cr>", "Buffers" },
	s = {
		name = "+Search",
		b = { "<cmd>Telescope git_branches<cr>", "Branches" },
		B = { "<cmd>Telescope file_browser<cr>", "Browser" },
		c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		f = { "<cmd>Telescope find_files<cr>", "Find File" },
		g = { "<cmd>Telescope git_files<cr>", "Git Files" },
		h = { "<cmd>Telescope howdoi<cr>", "How Do I .." },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		m = { "<cmd>Telescope marks<cr>", "Marks" },
		M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		n = { "<cmd>Telescope notify<cr>", "Notifications" },
		o = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		p = { "<cmd>Telescope projects<cr>", "Projects" },
		q = { "<cmd>Telescope quickfix<cr>", "Quickfix List" },
		r = { "<cmd>Telescope frecency<cr>", "Frecency" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		t = { "<cmd>Telescope live_grep<cr>", "Text" },
		T = { "<cmd>Telescope treesitter<cr>", "Treesitter Symbols" },
	},
	-- S = {name = "+Session", s = {"<cmd>SessionSave<cr>", "Save Session"}, l = {"<cmd>SessionLoad<cr>", "Load Session"}}
}
maps["m"] = {
	name = "+Mason",
	m = { "<cmd>Mason<cr>", "Info" },
	u = { "<cmd>MasonUpdate<cr>", "Update Servers" },
	l = { "<cmd>MasonLog<cr>", "Log" },
}
nmaps["]"] = {
	-- b = { "<cmd>bNext<cr>", "Buffer" },
	d = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
	D = { "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<cr>", "Next Trouble" },
	E = { "<cmd>lua require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>", "Next Error" },
	T = { "<cmd>lua require('todo-comments').jump_next()<cr>", "Next todo comment" },
	t = { "<cmd>tabNext<cr>", "Next tab" },
}
nmaps["["] = {
	-- b = { "<cmd>bprevious<cr>", "Buffer" },
	d = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
	D = { "<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<cr>", "Next Trouble" },
	E = { "<cmd>lua require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })<cr>", "Prev Error" },
	T = { "<cmd>lua require('todo-comments').jump_prev()<cr>", "Previous todo comment" },
	t = { "<cmd>tabprevious<cr>", "Tab" },
}

maps["L"] = {
	name = "+Logs",
	c = { "<cmd>LuaCacheProfile<cr>", "CacheProfile" },
	p = { "<cmd>Lazy profile<cr>", "Lazy Profile" },
	l = { "<cmd>LspLog<cr>", "LSP" },
}

maps["g"] = {
	name = "+Git",
	c = { "<cmd>Git commit %<cr>", "Commit File" },
	C = { "<cmd>Git commit<cr>", "Commit staged" },
	g = { "<cmd>G<cr>", "Fugitive" },
	l = { "<cmd>Git log<cr>", "Log" },
	n = { "<cmd>Neogit<cr>", "Neogit" },
	N = { "<cmd>Neogit commit %<cr>", "(Neogit) Commit Menu" },
	p = { "<cmd>Git pull<cr>", "pull" },
	P = { "<cmd>Git push<cr>", "Push" },
}

maps["n"] = {
	name = "+Generate Annotations",
	n = { "<cmd>lua require('neogen').generate()<CR>", "Auto" },
	c = { "<cmd>lua require('neogen').generate({ type = 'class'})<CR>", "Class" },
	f = { "<cmd>lua require('neogen').generate({ type = 'func'})<CR>", "Function" },
	t = { "<cmd>lua require('neogen').generate({ type = 'type'})<CR>", "Type" },
}

-- if O.testing then
-- 	maps["T"] = {
-- 		name = "+Tests",
-- 	}
-- end

local diffmaps = {
	["dr"] = { ":diffget RE<CR>", "Diffget remote" },
	["dl"] = { ":diffget LO<CR>", "Diffget local" },
	["db"] = { ":diffget BA<CR>", "Diffget base" },
}
which_key.register(maps, opts)
which_key.register(diffmaps, {
	mode = "n", -- NORMAL mode
	-- buffer = nil, -- Global maps. Specify a buffer number for buffer local maps
})
which_key.register(terminal_maps, terminal_opts)

local gmaps = {
	I = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Implementations" },
	r = { "<cmd>lua require('nvim-treesitter-refactor.smart_rename')<cr>", "Rename" },
	R = { "<cmd>lua vim.lsp.buf.references()<CR>", "References" },
	s = { "<cmd>lua vim.lsp.buf.document_symbol()<CR>", "Symbols" },
	S = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature" },
}
which_key.register(gmaps, {
	mode = "n", -- NORMAL mode
	prefix = "g",
})

which_key.register(nmaps, {
	mode = "n", -- NORMAL mode
})