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

-- LSP core setup: completeopt, diagnostics signs, commands, LspAttach keymaps, watchman.
-- Needs nvim-lspconfig on the runtime path (loaded above with lazy=false) so that
-- its lsp/*.lua configs are auto-discovered.  Server configs in our own lsp/*.lua
-- and after/lsp/*.lua are also auto-loaded by Neovim (see vim.lsp.config config priority).
require("lsp").config()

require("config.autocmds")
require("colorscheme")
require("utils.after")

if vim.g.neovide then
  require("config.neovide")
end

-- NixOS: enable the native LSP server list (no Mason).  Must run after the configs
-- from nvim-lspconfig and our own lsp/*.lua are already on the runtime path.
require("lsp").enable_nixos()
