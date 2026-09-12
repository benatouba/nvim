vim.loader.enable()

require("config.options")

-- Plugins (skipped inside VS Code, which provides its own UI/LSP)
if not vim.g.vscode then
  require("config.lazy")
end

require("config.keymaps")
require("config.autocmds")

if vim.g.neovide then
  require("config.neovide")
end
