local M = {}

-- The single vim.diagnostic.config() site (nvim-lint adds a namespaced one for commitlint).
M.setup = function()
  vim.diagnostic.config({
    virtual_text = false,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "✘",
        [vim.diagnostic.severity.WARN] = "▲",
        [vim.diagnostic.severity.HINT] = "⚑",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
    float = {
      show_header = true,
      source = true,
      border = "rounded",
      focusable = true,
    },
  })
end

return M
