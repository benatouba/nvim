local isOk, which_key = pcall(require, "which-key")
if not isOk then
  return
end

which_key.setup()

local opts = {
  mode = "n",  -- NORMAL mode
  prefix = "<leader>",
  -- buffer = nil, -- Global maps. Specify a buffer number for buffer local maps
  silent = true,  -- use `silent` when creating keymaps
  noremap = true,  -- use `remap` when creating keymaps
  nowait = false,  -- use `nowait` when creating keymaps
}

local terminal_maps = {}
local terminal_opts = { mode = "t" }
local visual_maps = {}
local visual_opts = { mode = "v" }
local vmaps = {
  ["<leader>t"] = { "<cmd>ToggleTermSendVisualLines<cr>", "Send to terminal" }
}
which_key.register(vmaps, visual_opts)
-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local nmaps = {}

local maps = {
  ["e"] = { ":Oil<cr>", "Explorer" },
  ["u"] = { ":UndotreeToggle<cr>", "Undotree" },
  ["<leader>"] = {":bprevious<cr>", "Switch Buffer"},
  -- a is for actions
  a = {
    name = "+Actions",
    c = { ":BufferClose<CR>", "Close Buffer" },
    h = { "<cmd>let @/ = ''<cr>", "Highlights" },
    s = { "<cmd>source %<cr>", "Source file" },
    r = { "<cmd>syntax sync fromstart<cr><cmd>redraw!<cr>", "Redraw" },
    w = { "<cmd>call TrimWhitespace()<cr>", "Trim Whitespaces" },
  },
  c = {
    name = "+Configuration",
    c = { "<cmd>e ~/.config/nvim/init.lua<cr>", "Open" },
    C = { "<cmd>ColorizerToggle<cr>", "Colorizer" },
    h = { "<cmd>set hlsearch!<CR>", "Highlightsearch" },
    r = { "<cmd>set norelativenumber!<cr>", "Relative line nums" },
  },
  p = {
    name = "+Plugins",
    c = { "<cmd>Lazy clean<cr>", "Clean" },
    C = { "<cmd>Lazy check<cr>", "Check" },
    d = { "<cmd>Lazy debug<cr>", "Debug" },
    h = { "<cmd>Lazy help<cr>", "Help" },
    i = { "<cmd>Lazy install<cr>", "Install" },
    l = { "<cmd>Lazy log<cr>", "Log" },
    m = { "<cmd>Mason<cr>", "Info" },
    p = { "<cmd>Lazy profile<cr>", "Profile" },
    r = { "<cmd>Lazy restore<cr>", "Restore" },
    s = { "<cmd>Lazy sync<cr>", "Sync" },
    u = { "<cmd>Lazy update<cr>", "Update" },
  },
}

nmaps["]"] = {
  -- b = { "<cmd>bNext<cr>", "Buffer" },
  d = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
  D = { "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<cr>", "Next Trouble" },
  -- E = { "<cmd>lua require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>", "Next Error" },
  T = { "<cmd>lua require('todo-comments').jump_next()<cr>", "Next todo comment" },
  t = { "<cmd>tabNext<cr>", "Next tab" },
}
nmaps["["] = {
  -- b = { "<cmd>bprevious<cr>", "Buffer" },
  d = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Prev Diagnostic" },
  D = { "<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<cr>", "Next Trouble" },
  -- E = { "<cmd>lua require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })<cr>", "Prev Error" },
  T = { "<cmd>lua require('todo-comments').jump_prev()<cr>", "Previous todo comment" },
  t = { "<cmd>tabprevious<cr>", "Tab" },
}

maps["L"] = {
  name = "+Logs",
  c = { "<cmd>LuaCacheProfile<cr>", "CacheProfile" },
  l = { "<cmd>LspLog<cr>", "LSP" },
  m = { "<cmd>MasonLog<cr>", "Log" },
  p = { "<cmd>Lazy profile<cr>", "Lazy Profile" },
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

local diffmaps = {
  ["dr"] = { ":diffget RE<CR>", "Diffget remote" },
  ["dl"] = { ":diffget LO<CR>", "Diffget local" },
  ["db"] = { ":diffget BA<CR>", "Diffget base" },
}
which_key.register(maps, opts)
which_key.register(diffmaps, {
  mode = "n",  -- NORMAL mode
  -- buffer = nil, -- Global maps. Specify a buffer number for buffer local maps
})
which_key.register(terminal_maps, terminal_opts)

local gmaps = {
  r = { "<cmd>lua require('nvim-treesitter-refactor.smart_rename')<cr>", "Rename" },
}
which_key.register(gmaps, {
  mode = "n",  -- NORMAL mode
  prefix = "g",
})

which_key.register(nmaps, {
  mode = "n",  -- NORMAL mode
})
