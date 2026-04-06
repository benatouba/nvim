-- lsp/oxlint.lua
-- Exclude .vue files: oxlint can't properly parse <template> blocks and
-- produces incorrect diagnostics there. ESLint + eslint-plugin-vue handles
-- Vue SFC linting; eslint-plugin-oxlint disables the overlapping rules.
return {
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  single_file_support = true,
}
