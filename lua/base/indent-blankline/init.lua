local M = {}

M.config = function()
vim.g.indent_blankline_buftype_exclude = {'terminal', 'fugitive'}
vim.g.indent_blankline_filetype_exclude = {'help', 'startify', 'dashboard', 'packer', 'neogitstatus', 'fugitive'}
vim.g.indent_blankline_char = '▏'
vim.g.indent_blankline_use_treesitter = O.language_parsing
vim.g.indent_blankline_show_trailing_blankline_indent = false
vim.g.indent_blankline_show_current_context = true
vim.g.indent_blankline_context_patterns = {
  'class', 'function', 'method', '^if', '^while', 'div', '^for', '^object', '^table', 'block',
  'arguments', 'if_statement', 'else_clause', 'jsx_element', 'jsx_self_closing_element', 'try_statement',
  'catch_clause', 'import_statement'
}
end

return M
