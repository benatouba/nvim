-- LSP core, invoked from the nvim-lspconfig spec once its defaults are on the runtimepath.
-- Client capabilities: blink.cmp registers its own via vim.lsp.config("*", ...) on load.
local M = {}

M.setup = function()
  require("lsp.diagnostics").setup()
  require("lsp.commands").setup()
  require("lsp.attach").setup()
  require("lsp.servers").enable()
end

return M
