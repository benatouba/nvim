--[[
O is the global options object

Formatters and linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- packages
O.lsp = true -- boolean, activates lsp packages
O.webdev = true
O.copilot = true
O.language_parsing = true
O.git = true
O.format = true
O.test = true
O.dap = true -- debugging
O.project_management = true
O.notebooks = true
O.misc = true

-- language specific
O.python = true
O.markdown = true
O.typescript = true
O.latex = true

-- program adapters
O.obsidian = true
O.salt = false
O.databases = true

-- general
O.auto_complete = true
O.colorscheme = "catppuccin-mocha"
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

