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
	['<leader>t'] = {"<cmd>ToggleTermSendVisualLines<cr>", "Send to terminal"}
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
		name = "+Packer",
		c = { "<cmd>PackerClean<cr>", "Clean" },
		C = { "<cmd>PackerCompile profile=true<cr>", "Compile" },
		i = { "<cmd>PackerInstall<cr>", "Install" },
		s = { "<cmd>PackerSync<cr>", "Sync" },
		S = { "<cmd>PackerStatus<cr>", "Status" },
		u = { "<cmd>PackerUpdate<cr>", "Update" },
	},
	b = { "<cmd>Telescope buffers<cr>", "Buffers" },
	s = {
		name = "+Search",
		b = { "<cmd>Telescope git_branches<cr>", "Branches" },
		B = { "<cmd>Telescope file_browser<cr>", "Browser" },
		c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		d = { "<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics" },
		D = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Document Diagnostics" },
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
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols (LSP)" },
		S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols (LSP)" },
		t = { "<cmd>Telescope live_grep<cr>", "Text" },
		T = { "<cmd>Telescope treesitter<cr>", "Treesitter Symbols" },
	},
	-- S = {name = "+Session", s = {"<cmd>SessionSave<cr>", "Save Session"}, l = {"<cmd>SessionLoad<cr>", "Load Session"}}
}
if O.lsp then
	maps["l"] = {
		name = "+LSP",
		a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
		A = { "<cmd>lua vim.lsp.buf.range_code_action()<cr>", "Selected Action" },
		c = { "<cmd>lua =vim.lsp.get_active_clients()[2].server_capabilities<cr>", "Server Capabilities" },
		d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Definition" },
		D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Declaration" },
		l = { "<cmd>LspLog<CR>", "Logs" },
		f = { "<cmd>lua vim.lsp.buf.format()<CR>", "Format Document" },
		F = { "<cmd>lua vim.lsp.buf.format({ async = false })<CR>", "Format Document (Sync)" },
		h = { "<cmd>lua require('pretty_hover').hover()<cr>", "Hover" },
		i = { "<cmd>LspInfo<cr>", "Info" },
		n = { "<cmd>NullLsInfo<cr>", "Null-Ls Info" },
		j = { "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<cr>", "Next Diagnostic" },
		k = { "<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<cr>", "Prev Diagnostic" },
		q = { "<cmd>Telescope quickfix<cr>", "Quickfix" },
		r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
		t = { "<cmd>LspTypeDefinition<cr>", "Type Definition" },
		x = { "<cmd>cclose<cr>", "Close Quickfix" },
		s = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help" },
	}
	maps["m"] = {
		name = "+Mason",
		m = { "<cmd>Mason<cr>", "Info" },
		u = { "<cmd>MasonUpdate<cr>", "Update Servers" },
		l = { "<cmd>MasonLog<cr>", "Log" },
	}
	nmaps["]"] = {
		-- defined in gitsigns for now
		-- g = { "<cmd>lua require'gitsigns.actions'.next_hunk()<cr>", "Next Hunk" },
		b = { "<cmd>bNext<cr>", "Buffer" },
		d = { "<cmd>lua vim.diagnostic.goto_next { wrap = true }<cr>", "Next Diagnostic" },
		D = { "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<cr>", "Next Trouble" },
		E = { "<cmd>lua require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })"},
		T = { "<cmd>lua require('todo-comments').jump_next()<cr>", "Next todo comment" },
		t = { "<cmd>tabNext<cr>", "Next tab" },
	}
	nmaps["["] = {
		-- defined in gitsigns for now
		-- g = { "<cmd>lua require'gitsigns.actions'.prev_hunk()<cr>", "Prev Hunk" },
		b = { "<cmd>bprevious<cr>", "Buffer" },
		d = { "<cmd>lua vim.diagnostic.goto_prev { wrap = true }<cr>", "Prev Diagnostic" },
		D = { "<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<cr>", "Next Trouble" },
		E = { "<cmd>lua require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })"},
		T = { "<cmd>lua require('todo-comments').jump_prev()<cr>", "Previous todo comment" },
		t = { "<cmd>tabprevious<cr>", "Tab" },
	}
end

maps["L"] = {
	name = "+Logs",
	c = { "<cmd>LuaCacheProfile<cr>", "CacheProfile" },
	p = { "<cmd>PackerProfile<cr>", "PackerProfile" },
	l = { "<cmd>LspLog<cr>", "LSP" },
}

if O.git then
	maps["g"] = {
		name = "+Git",
		a = { "<cmd>Git add %<cr>", "Add/Stage File" },
		b = { "<cmd>Gitsigns blame_line<cr>", "Blame line" },
		B = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Blame line (toggle)" },
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
		r = { "<cmd>lua require'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
		R = { "<cmd>lua require'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
		s = { "<cmd>lua require'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
		u = { "<cmd>lua require'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
	}
end

if O.misc then
	maps["n"] = {
		name = "+Generate Annotations",
		n = { "<cmd>lua require('neogen').generate()<CR>", "Auto" },
		c = { "<cmd>lua require('neogen').generate({ type = 'class'})<CR>", "Class" },
		f = { "<cmd>lua require('neogen').generate({ type = 'func'})<CR>", "Function" },
		t = { "<cmd>lua require('neogen').generate({ type = 'type'})<CR>", "Type" },
	}
end

-- if O.testing then
-- 	maps["T"] = {
-- 		name = "+Tests",
-- 	}
-- end

if O.project_management then
	maps["o"] = {
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
which_key.register(maps, opts)
which_key.register(diffmaps, {
	mode = "n", -- NORMAL mode
	-- buffer = nil, -- Global maps. Specify a buffer number for buffer local maps
})
which_key.register(terminal_maps, terminal_opts)

local gmaps = {
	a = { "<cmd>Lspsaga code_action<CR>", "Code Action" },
	h = { "<cmd>Lspsaga lsp_finder<CR>", "Help" },
	d = { "<cmd>Lspsaga goto_definition<<CR>", "Definition" },
	D = { "<cmd>Lspsaga peek_definition<CR>", "Declaration" },
	I = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Implementations" },
	r = { "<cmd>lua require('nvim-treesitter-refactor.smart_rename')<cr>", "Rename" },
	R = { "<cmd>lua vim.lsp.buf.references()<CR>", "References" },
	s = { "<cmd>lua vim.lsp.buf.document_symbol()<CR>", "Symbols" },
}
which_key.register(gmaps, {
	mode = "n", -- NORMAL mode
	prefix = "g",
})

which_key.register(nmaps, {
	mode = "n", -- NORMAL mode
	prefix = "",
})