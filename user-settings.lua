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
O.snippets = true
O.format = true
O.test = true
O.dap = true -- debugging
O.project_management = true
O.misc = true

O.auto_complete = true
O.colorscheme = 'lunar'
O.auto_close_tree = 0
O.wrap_lines = true

-- special keys
O.mapleader = " "

-- if you don't want all the parsers change this to a table of the ones you want
O.treesitter.ensure_installed = "all"
O.treesitter.ignore_install = {"haskell"}
O.treesitter.highlight.enabled = true

O.clang.diagnostics.virtual_text = false
O.clang.diagnostics.signs = false
O.clang.diagnostics.underline = false

-- lsp
O.diagnostics.virtual_text.active = true
O.diagnostics.signs = true
O.diagnostics.underline = true

-- python
vim.cmd("let g:python3_host_prog = '/home/ben/.pyenv/shims/python3'")
O.python.format.auto = false
O.python.format.exe = 'black'
O.python.format.args = {'-l 120'}
O.python.format.cwd = vim.fn.getcwd()
O.python.format.stdin = false
O.python.format.isort = true
O.python.linter = 'flake8'
O.python.analysis.type_checking = "off"
O.python.analysis.auto_search_paths = true
O.python.analysis.use_library_code_types = true

-- lua
-- TODO look into stylua
O.lua.format.auto = false
O.lua.format.exe = 'lua-format'
O.lua.format.args = {'-i'}
O.lua.format.stdin = false
O.lua.format.cwd = false

-- javascript and typescript
O.jsts.format.auto = false
O.jsts.format.exe = 'prettier'
O.jsts.format.args = {}
O.jsts.format.stdin = false
O.jsts.format.cwd = false
O.jsts.linter = nil

-- json
O.json.format.auto = false
O.json.format.exe = 'prettier'
O.json.format.args = {}
O.json.format.stdin = false
O.json.format.cwd = false

-- ruby
O.ruby.format.auto = false
O.ruby.format.exe = ''
O.ruby.format.args = {}
O.ruby.format.stdin = false
O.ruby.format.cwd = false

-- create custom autocommand field (This would be easy with lua)

-- org-mode
O.org.agenda_files = {'~/Documents/org/*'}
O.org.default_notes_file = '~/Documents/org/refile.org'
