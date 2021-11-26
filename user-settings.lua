--[[
O is the global options object

Formatters and linters should be
filled in as strings with either
a global executable or a path to
an executable
]] -- general
O.lsp = true -- boolean, activates lsp packages
O.language_parsing = true
O.git = true
O.format = true
O.test = false
O.dap = true -- debugging
O.project_management = true
O.misc = true

O.auto_complete = true
O.colorscheme = 'tokyonight'
O.auto_close_tree = 0
O.wrap_lines = true

-- special keys
O.mapleader = " "

-- paths
O.packer_compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'

-- if you don't want all the parsers change this to a table of the ones you want
O.treesitter.ensure_installed = "all"
O.treesitter.ignore_install = {"haskell"}
O.treesitter.highlight.enabled = true

-- lsp
O.diagnostics.virtual_text.active = true
O.diagnostics.signs = true
O.diagnostics.underline = true

-- org-mode
O.org.agenda_files = {'~/Documents/org/*'}
O.org.default_notes_file = '~/Documents/org/refile.org'
