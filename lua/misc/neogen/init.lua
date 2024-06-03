local status_ok, neogen = pcall(require, "neogen")
if not status_ok then return end

neogen.setup {
  enabled = true,
  languages = {
    lua = { template = { annotation_convention = "emmylua" } },
    python = { template = { annotation_convention = "google_docstrings" } },
    -- python = {template = {annotation_convention = "numpydoc"}},
    -- python = {template = {annotation_convention = "reST"}},
    javascript = { template = { annotation_convention = "jsdoc" } },
    typescript = { template = { annotation_convention = "tsdoc" } },
    vue = { template = { annotation_convention = "jsdoc" } },
  }
}
