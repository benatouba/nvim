local M = {}

M.opts = {
  enabled = true,
  languages = {
    lua = { template = { annotation_convention = "emmylua" } },
    python = { template = { annotation_convention = "google_docstrings" } },
    javascript = { template = { annotation_convention = "jsdoc" } },
    typescript = { template = { annotation_convention = "tsdoc" } },
    vue = { template = { annotation_convention = "jsdoc" } },
  },
}

return M
