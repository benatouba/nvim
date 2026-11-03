-- Salt's default renderer is Jinja -> YAML, not plain YAML. Keep its own
-- filetype so YAML language servers and formatters cannot rewrite templates.
local o = vim.opt_local
o.expandtab = true
o.shiftwidth = 2
o.softtabstop = 2
o.tabstop = 2
o.commentstring = "# %s"
o.comments = ":#"
-- Preserve indentation rather than guessing across YAML and Jinja blocks.
o.autoindent = true
o.smartindent = false
o.indentexpr = ""
o.foldmethod = "indent"
o.foldlevel = 99
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "")
  .. " | setlocal expandtab< shiftwidth< softtabstop< tabstop< commentstring< comments< autoindent< smartindent< indentexpr< foldmethod< foldlevel<"
