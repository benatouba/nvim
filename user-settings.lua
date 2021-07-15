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

-- python
vim.cmd("let g:python3_host_prog = '/home/ben/.pyenv/shims/python3'")
O.python.formatter = 'yapf'
O.python.linter = 'flake8'
O.python.isort = true
O.python.autoformat = true
O.python.diagnostics.virtual_text = true
O.python.diagnostics.signs = true
O.python.diagnostics.underline = true
O.python.analysis.type_checking = "off"
O.python.analysis.auto_search_paths = true
O.python.analysis.use_library_code_types = true

-- lua
-- TODO look into stylua
O.lua.format.exe = 'lua-format'
O.lua.format.args = {'-i'}
O.lua.format.stdin = false
O.lua.format.cwd = false
O.lua.format.autoformat = false

-- javascript and typescript
O.jsts.formatter = 'prettier'
O.jsts.linter = nil
O.jsts.autoformat = true

-- json
O.json.autoformat = true

-- ruby
O.ruby.autoformat = true
-- create custom autocommand field (This would be easy with lua)
