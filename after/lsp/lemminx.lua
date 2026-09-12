-- Shares xhtml with the html server rather than replacing it: lemminx is the
-- one that knows XML (well-formedness, DTD/XSD validation, catalogs) and
-- formats grammar-aware, while vscode-html-language-server contributes HTML5
-- completions and hover. Neither covers the other's ground.

local M = {
  -- lspconfig's default list plus xhtml; assigning filetypes replaces it
  filetypes = { "xml", "xsd", "xsl", "xslt", "svg", "xhtml" },
  -- XML mostly turns up inside Maven/Gradle projects, where the module that
  -- owns pom.xml is a more useful root than the enclosing repo
  root_markers = { "pom.xml", ".git" },
  settings = {
    xml = {
      format = { enabled = true },
      validation = {
        -- svg and hand-written xml usually reference no schema at all; at the
        -- default "warning" every such buffer opens with a diagnostic
        noGrammar = "hint",
      },
      -- XHTML doctypes point at w3.org DTDs. Fetching them would validate
      -- against the real grammar, at the price of a network round trip on
      -- open, so structural checks only.
      downloadExternalResources = { enabled = false },
    },
  },
}

return M
