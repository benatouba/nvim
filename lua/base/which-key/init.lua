local isOk, which_key = pcall(require, "which-key")
if not isOk then
    return
end

which_key.setup {
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
vim.g.mapleader = O.mapleader

-- Comments
vim.api.nvim_set_keymap("v", "<leader>/", ":CommentToggle<CR>", {noremap = true, silent = true})

-- TODO create entire treesitter section

local mappings = {
    ["/"] = {":CommentToggle<CR>", "Comment"},
    ["c"] = {":BufferClose<CR>", "Close Buffer"},
	-- ["h"] = {":HopChar2<cr>", "hop to 2 char sequence"},
	-- ["H"] = {":HopWord<cr>", "hop to word"},
    ["e"] = {":NvimTreeToggle<cr>", "Explorer"},
    ["u"] = {":UndotreeToggle<cr>", "Undotree"},

    -- a is for actions
    a = {
        name = "+Actions",
        -- c = {"<cmd>ColorizerToggle<cr>", "colorizer"},
        h = {"<cmd>let @/ = ''<cr>", "remove highlighted"},
		H = {":set hlsearch!<CR>", "turn off highlight"},
        -- i = {"<cmd>IndentBlanklineToggle<cr>", "toggle indent lines"},
        -- m = {"<cmd>MaximizerToggle<cr>", "maximize"},
        n = {"<cmd>set nonumber<cr>!", "line-numbers"},
        N = {"<cmd>set norelativenumber!<cr>", "relative line nums"},
        s = {"<cmd>s/\\%V\\(.*\\)\\%V/'\\1'/<cr>", "surround"},
        r = {"<cmd>Root<cr>", "root working dir"},
		w = {"<cmd>call TrimWhitespace()<cr>", "trim Whitespaces"},
        -- t = {"<cmd>TSHighlightCapturesUnderCursor<cr>", "treesitter highlight"},
        R = {':nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>', 'redraw'}


    },

    p = {
        name = "+Packer",
        c = {"<cmd>PackerClean<cr>", 					"Clean" 					},
        C = {"<cmd>PackerCompile profile=true<cr>", 	"Compile" 					},
        i = {"<cmd>PackerInstall<cr>", 					"Install" 			 		},
        s = {"<cmd>PackerSync<cr>", 					"Sync" 	 					},
        S = {"<cmd>PackerStatus<cr>", 					"Status" 	 				},
        u = {"<cmd>PackerUpdate<cr>", 					"Update" 					},
    },

    s = {
        name = "+Search",
        b = {"<cmd>Telescope git_branches<cr>", "Branches"},
        B = {"<cmd>Telescope file_browser<cr>", "Browser"},
        c = {"<cmd>Telescope colorscheme<cr>", "Colorscheme"},
        d = {"<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics"},
        D = {"<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics"},
        f = {"<cmd>Telescope find_files<cr>", "Find File"},
        g = {"<cmd>Telescope git_files<cr>", "Git Files"},
        m = {"<cmd>Telescope marks<cr>", "Marks"},
        M = {"<cmd>Telescope man_pages<cr>", "Man Pages"},
        o = {"<cmd>Telescope oldfiles<cr>", "Open Recent File"},
        p = {"<cmd>Telescope projects<cr>", "Projects"},
        q = {"<cmd>Telescope quickfix<cr>", "Quickfix List"},
        r = {"<cmd>Telescope frecency<cr>", "Frecency"},
        R = {"<cmd>Telescope registers<cr>", "Registers"},
        s = {"<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols (LSP)"},
        S = {"<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols (LSP)"},
        t = {"<cmd>Telescope live_grep<cr>", "Text"},
        T = {"<cmd>Telescope treesitter<cr>", "Treesitter Symbols"},
    },

    -- S = {name = "+Session", s = {"<cmd>SessionSave<cr>", "Save Session"}, l = {"<cmd>SessionLoad<cr>", "Load Session"}}
}
if O.lsp then
    mappings["l"] = {
        name = "+LSP",
        a = {"<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action"},
        A = {"<cmd>lua vim.lsp.buf.range_code_action()<cr>", "Selected Action"},
        d = {"<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics"},
        D = {"<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics"},
        h = {'<cmd>lua vim.lsp.buf.definition()<CR>', "Find definition"},
        i = {"<cmd>LspInfo<cr>", "Info"},
        j = {"<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = O.lsp.popup_border}})<cr>", "Next Diagnostic"},
        k = {"<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = O.lsp.popup_border}})<cr>", "Prev Diagnostic"},
        q = {"<cmd>Telescope quickfix<cr>", "Quickfix"},
        r = {"<cmd>lua vim.lsp.buf.rename()<cr>", "Rename"},
        t = {"<cmd>LspTypeDefinition<cr>", "Type Definition"},
        x = {"<cmd>cclose<cr>", "Close Quickfix"},
        s = {"<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols"},
        S = {"<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols"}
    }
end

if O.git then
    mappings["g"] = {
        name = "+Git",
		a = {"<cmd>Git add %<cr>", "Add File"},
		c = {"<cmd>Git commit %<cr>", "Commit File"},
		C = {"<cmd>Git commit<cr>", "Commit staged"},
		g = {"<cmd>G<cr>", "Fugitive"},
		l = {"<cmd>Git log<cr>", "Log"},
		n = {"<cmd>Neogit<cr>", "Neogit"},
        j = {"<cmd>lua require'gitsigns.actions'.next_hunk()<cr>", "Next Hunk"},
        k = {"<cmd>lua require'gitsigns.actions'.prev_hunk()<cr>", "Prev Hunk"},
        p = {"<cmd>lua require'gitsigns'.preview_hunk()<cr>", "Preview Hunk"},
        P = {"<cmd>Git push<cr>", "Push"},
        r = {"<cmd>lua require'gitsigns'.reset_hunk()<CR>',<cr>", "Reset Hunk"},
        R = {"<cmd>lua require'gitsigns'.reset_buffer()<cr>", "Reset Buffer"},
        s = {"<cmd>lua require'gitsigns'.stage_hunk()<cr>", "Stage Hunk"},
        u = {"<cmd>lua require'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk"}
    }
end

if O.misc then
    mappings["t"] = {"<cmd>lua require('FTerm').toggle()<cr>", "Terminal"}
    mappings["n"] = {
        name = "+Generate Annotations",
        n = {"<cmd>lua require('neogen').generate()<CR>", "Auto"},
        c = {"<cmd>lua require('neogen').generate({ type = 'class'})<CR>", "Class"},
        f = {"<cmd>lua require('neogen').generate({ type = 'func'})<CR>", "Function"},
        t = {"<cmd>lua require('neogen').generate({ type = 'type'})<CR>", "Type"},
    }
end

if O.dap then
    mappings["d"] = {
        name = "+Debug",
            b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
            c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
            C = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run To Cursor" },
            d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
            g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
            i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
            o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
            O = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },
            p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
            q = { "<cmd>lua require'dap'.stop()<cr>", "Quit" },
            r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
            s = { "<cmd>lua require'dap'.step_back()<cr>", "Step Back" },
    }
end

if O.testing then
    mappings["T"] = {
        name = "+Tests",
    }
end

if O.format then
    mappings["f"] = {"<cmd>Format<cr>", "Format"}
end

if O.project_management then
    mappings["o"] = {
        name = "+Organisation",
        a = { "<cmd>lua require('orgmode').action('agenda.prompt')<CR>", "Agenda"},
        c = { "<cmd>lua require('orgmode').action('capture.prompt')<CR>", "Capture"},
        }
end
which_key.register(mappings, opts)
