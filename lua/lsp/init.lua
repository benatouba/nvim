local M = {}

M.config = function()
  vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }

  require("lsp.servers").setup()
  require("lsp.diagnostics").setup()
  require("lsp.commands").setup()
  require("lsp.attach").setup()
  require("lsp.watchman").setup()
end

M.enable_nixos = function()
  require("lsp.servers").enable_nixos()
end

return M
