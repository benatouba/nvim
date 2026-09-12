-- Editor options. Loaded first from init.lua, before lazy.nvim, so leader keys and
-- globals that plugin specs read (vim.g.is_nixos) are in place when specs are built.

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- On NixOS every tool comes from Nix, so Mason-style installers are disabled.
vim.g.is_nixos = vim.uv.fs_stat("/etc/NIXOS") ~= nil

-- Disabled built-in plugins / providers
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_netrw_gitignore = 1
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

local o = vim.o

-- UI
o.termguicolors = true
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes:1" -- always reserve the sign column so text does not shift
o.showmode = false -- the statusline shows the mode
o.showcmd = true
o.pumheight = 10
o.scrolloff = 999 -- keep the cursor line vertically centred
o.sidescrolloff = 7
o.conceallevel = 2 -- e.g. hide markup in markdown
o.list = true
vim.opt.listchars:append("nbsp:␣,trail:•,extends:⟩,precedes:⟨")
vim.opt.fillchars:append("stl: ")
o.titlestring = "%<%F%=%l/%L - nvim"
o.mouse = "c" -- mouse only in command-line mode
o.syntax = "on"

-- Splits, wrapping, movement
o.splitbelow = true
o.splitright = true
o.wrap = true
vim.opt.whichwrap:append("<,>,[,]")

-- Editing
o.expandtab = true
o.smartindent = true
o.tabstop = 2
o.shiftwidth = 2
o.textwidth = 0
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- no auto-continued comments
o.clipboard = "unnamedplus"
o.spelllang = "en"
o.fileencoding = "utf-8"
o.exrc = false

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true
o.inccommand = "split"
vim.opt.shortmess:append("c")

-- Folding: LSP folding ranges, falling back to treesitter. Everything open by default.
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.lsp.foldexpr()"
o.foldlevelstart = 99

-- Timing
o.updatetime = 200
o.timeoutlen = 400

-- Backups, undo and swap live under stdpath("data") so they never land in a project tree.
local data = vim.fn.stdpath("data")
for _, dir in ipairs({ data .. "/backup", data .. "/directory" }) do
  if not vim.uv.fs_stat(dir) then
    vim.fn.mkdir(dir, "p")
  end
end
o.backup = true
o.writebackup = true
o.backupdir = data .. "/backup"
o.directory = data .. "/directory"
o.undofile = true
o.undodir = data .. "/undo"

-- Python host: prefer the pyenv shim when present.
local pyenv_python = vim.fn.expand("$HOME/.pyenv/shims/python3")
if vim.uv.fs_stat(pyenv_python) then
  vim.g.python3_host_prog = pyenv_python
end

-- Plugin globals that must be set before the plugin loads
vim.g.lazydev_enabled = true
vim.g.skip_ts_context_commentstring_module = true
vim.g.cursorhold_updatetime = 100

vim.lsp.log.set_level("WARN")

-- Experimental TUI (nightly-internal module; tolerate it moving).
pcall(function()
  require("vim._core.ui2").enable()
end)
