--[[
O is the global options object

Formatters and linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- packages
O.lsp = true -- boolean, activates lsp packages
O.webdev = false
O.copilot = false
O.language_parsing = true
O.git = true
O.format = true
O.test = false
O.dap = false -- debugging
O.project_management = false
O.notebooks = false
O.misc = false

-- language specific
O.python = true
O.markdown = false
O.typescript = false
O.latex = false

-- program adapters
O.obsidian = false
O.salt = false
O.databases = false

-- general
O.auto_complete = true
O.colorscheme = "rose-pine-moon"
O.auto_close_tree = 0
O.wrap_lines = true

-- if you don't want all the parsers change this to a table of the ones you want
O.treesitter.ensure_installed = "all"
O.treesitter.ignore_install = {}
O.treesitter.highlight.enabled = true

-- lsp
O.diagnostics.virtual_text.active = true
O.diagnostics.signs = true
O.diagnostics.underline = true

