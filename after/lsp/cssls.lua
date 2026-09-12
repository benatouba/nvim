-- Tailwind v4 keeps its configuration in CSS (@theme, @source, @utility,
-- @custom-variant, @apply, @plugin), none of which the vscode CSS server
-- knows. Left at the default "warning" every such file is a wall of
-- "Unknown at rule" diagnostics, which drowns out the real ones.
local lint = { unknownAtRules = "ignore" }

local M = {
  cmd = require("lsp.resolve").rpc("vscode-css-language-server"),
  filetypes = { "css", "scss", "less" },
  -- style blocks inside .vue files stay with vue_ls/vtsls
  root_markers = { "package.json", ".git" },
  settings = {
    css = { lint = lint, validate = true },
    less = { lint = lint, validate = true },
    scss = { lint = lint, validate = true },
  },
}

return M
