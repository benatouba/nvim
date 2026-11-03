-- Personal policy only; salt-vim owns syntax, comments and basic style.
local o = vim.opt_local
-- Preserve indentation rather than guessing across YAML and Jinja blocks.
o.smartindent = false
o.indentexpr = ""
o.foldmethod = "indent"
o.foldlevel = 99
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. " | setlocal smartindent< indentexpr< foldmethod< foldlevel<"
