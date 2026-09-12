local M = {
  cmd = require("lsp.resolve").rpc("vscode-html-language-server"),
  -- xhtml is shared with lemminx: this server brings the HTML5 element and
  -- attribute knowledge plus embedded CSS/JS, lemminx brings the XML side.
  filetypes = { "html", "xhtml" },
  init_options = {
    -- Formatting is oxfmt's job on html and lemminx's on xhtml. Left on, both
    -- servers would rewrite the same xhtml buffer, since conform's LSP
    -- fallback runs every attached client that advertises formatting.
    provideFormatter = false,
  },
  root_markers = { "package.json", ".git" },
}

return M
