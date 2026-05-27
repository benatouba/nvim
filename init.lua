vim.loader.enable()

require("user-defaults")
require("utils.globals")
require("utils")
require("config.keymaps")
require("user-settings")
require("config.options")

if not vim.g.vscode then
  require("config.lazy")
end

require("config.autocmds")
require("colorscheme")
require("utils.after")

if vim.g.neovide then
  require("config.neovide")
end

require("lsp").enable_nixos()
