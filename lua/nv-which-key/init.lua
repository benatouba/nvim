require("which-key").setup {
    plugins = {
        marks = true, -- shows a list of your marks on " and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = true, -- adds help for operators like d, y, ...
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true -- bindings for prefixed with g
        }
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it"s label
        group = "+" -- symbol prepended to a group
    },
    window = {
        border = "single", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = {1, 0, 1, 0}, -- extra window margin [top, right, bottom, left]
        padding = {2, 2, 2, 2} -- extra window padding [top, right, bottom, left]
    },
    layout = {
        height = {min = 4, max = 25}, -- min and max height of the columns
        width = {min = 20, max = 50}, -- min and max width of the columns
        spacing = 3 -- spacing between columns
    },
    hidden = {"<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
    show_help = true -- show help message on the command line when the popup is visible
}

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    -- buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false -- use `nowait` when creating keymaps
}

-- Set leader
vim.api.nvim_set_keymap("n", "<Space>", "<NOP>", {noremap = true, silent = true})
vim.g.mapleader = " "

-- Comments
vim.api.nvim_set_keymap("v", "<leader>/", ":CommentToggle<CR>", {noremap = true, silent = true})

-- TODO create entire treesitter section

local mappings = {
    ["/"] = {":CommentToggle<CR>", "Comment"},
    ["c"] = {":BufferClose<CR>", "Close Buffer"},
	["h"] = {":HopChar2<cr>", "hop to 2 char sequence"},
	["H"] = {":HopWord<cr>", "hop to word"},

    -- a is for actions
    a = {
        name = "+Actions",
        -- c = {"<cmd>ColorizerToggle<cr>", "colorizer"},
        h = {"<cmd>let @/ = ''<cr>", "remove highlighted"},
		H = {":set hlsearch!<CR>", "turn off highlight"},
        -- i = {"<cmd>IndentBlanklineToggle<cr>", "toggle indent lines"},
        -- m = {"<cmd>MaximizerToggle<cr>", "maximize"},
        n = {"<cmd>set nonumber<cr>!", "line-numbers"},
        s = {"<cmd>s/\\%V\\(.*\\)\\%V/'\\1'/<cr>", "surround"},
        r = {"<cmd>set norelativenumber!<cr>", "relative line nums"},
		w = {"<cmd>call TrimWhitespace()<cr>", "trim Whitespaces"}
        -- t = {"<cmd>TSHighlightCapturesUnderCursor<cr>", "treesitter highlight"},
    },

    -- d = {
    --     name = "+Debug",
    --     b = {"<cmd>DebugToggleBreakpoint<cr>", "Toggle Breakpoint"},
    --     c = {"<cmd>DebugContinue<cr>", "Continue"},
    --     i = {"<cmd>DebugStepInto<cr>", "Step Into"},
    --     o = {"<cmd>DebugStepOver<cr>", "Step Over"},
    --     r = {"<cmd>DebugToggleRepl<cr>", "Toggle Repl"},
    --     s = {"<cmd>DebugStart<cr>", "Start"}
    -- },

    g = {
        name = "+Git",
		a = {"<cmd>Git add %<cr>", "Add File"},
		c = {"<cmd>Git commit %<cr>", "Commit File"},
		C = {"<cmd>Git commit<cr>", "Commit staged"},
		g = {"<cmd>G<cr>", "Fugitive"},
		l = {"<cmd>Git log<cr>", "Log"},
		n = {"<cmd>Neogit<cr>", "Neogit"},
        j = {"<cmd>NextHunk<cr>", "Next Hunk"},
        k = {"<cmd>PrevHunk<cr>", "Prev Hunk"},
        p = {"<cmd>PreviewHunk<cr>", "Preview Hunk"},
        P = {"<cmd>Git push<cr>", "Preview Hunk"},
        r = {"<cmd>ResetHunk<cr>", "Reset Hunk"},
        R = {"<cmd>ResetBuffer<cr>", "Reset Buffer"},
        s = {"<cmd>StageHunk<cr>", "Stage Hunk"},
        u = {"<cmd>UndoStageHunk<cr>", "Undo Stage Hunk"}
    },

    l = {
        name = "+LSP",
        a = {"<cmd>Lspsaga code_action<cr>", "Code Action"},
        A = {"<cmd>Lspsaga range_code_action<cr>", "Selected Action"},
        d = {"<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics"},
        D = {"<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics"},
        f = {"<cmd>LspFormatting<cr>", "Format"},
        i = {"<cmd>LspInfo<cr>", "Info"},
        l = {"<cmd>Lspsaga lsp_finder<cr>", "LSP Finder"},
        L = {"<cmd>Lspsaga show_line_diagnostics<cr>", "Line Diagnostics"},
        p = {"<cmd>Lspsaga preview_definition<cr>", "Preview Definition"},
        q = {"<cmd>Telescope quickfix<cr>", "Quickfix"},
        r = {"<cmd>Lspsaga rename<cr>", "Rename"},
        t = {"<cmd>LspTypeDefinition<cr>", "Type Definition"},
        x = {"<cmd>cclose<cr>", "Close Quickfix"},
        s = {"<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols"},
        S = {"<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols"}
    },

    p = {
        name = "+Packer",
        c = {"<cmd>PackerClean<cr>", 					"Clean" 					},
        C = {"<cmd>PackerCompile profile=true<cr>", 	"Compile" 					},
        i = {"<cmd>PackerInstall<cr>", 					"Install" 			 		},
        l = {"<cmd>PackerLoad ", 						"Load <plugin>" 		 	},
        s = {"<cmd>PackerSync<cr>", 					"Sync" 	 					},
        S = {"<cmd>PackerStatus<cr>", 					"Status" 	 				},
        u = {"<cmd>PackerUpdate<cr>", 					"Update" 					},
    },

    s = {
        name = "+Search",
        b = {"<cmd>Telescope git_branches<cr>", "Branches"},
        c = {"<cmd>Telescope colorscheme<cr>", "Colorscheme"},
        d = {"<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics"},
        D = {"<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics"},
        f = {"<cmd>Telescope find_files<cr>", "Find File"},
        m = {"<cmd>Telescope marks<cr>", "Marks"},
        M = {"<cmd>Telescope man_pages<cr>", "Man Pages"},
        o = {"<cmd>Telescope oldfiles<cr>", "Open Recent File"},
        p = {"<cmd>Telescope project<cr>", "Projects"},
        r = {"<cmd>Telescope frecency<cr>", "Frecency"},
        R = {"<cmd>Telescope registers<cr>", "Registers"},
        t = {"<cmd>Telescope live_grep<cr>", "Text"}
    },

    -- S = {name = "+Session", s = {"<cmd>SessionSave<cr>", "Save Session"}, l = {"<cmd>SessionLoad<cr>", "Load Session"}}
}

local wk = require("which-key")
wk.register(mappings, opts)
