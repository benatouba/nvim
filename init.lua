vim.loader.enable()
if vim.g.neovide then
  require("user-defaults")
  require("utils.globals")
  require("utils")
  require("keymappings")
  require("user-settings")
  require("settings")
  require("plugins")
  require("ben")
  require("autocommands")
  require("colorscheme")
  require("utils.after")
  vim.opt.linespace = 0
  vim.g.neovide_scale_factor = 0.9
  vim.o.guifont = "Source Code Pro:h14"
else
  require("user-defaults")
  require("utils.globals")
  require("utils")
  require("keymappings")
  require("user-settings")
  require("settings")
  if vim.g.vscode then
  else
    require("plugins")
    require("ben")
  end
  require("autocommands")
  require("colorscheme")
  require("utils.after")
end
if O.is_nixos then

  -- vim.lsp.config("nil_ls", lspconfig.nil_ls.document_config.default_config)
  vim.lsp.enable("nil_ls")

  -- vim.lsp.config("lua_ls", lspconfig.lua_ls.document_config.default_config)
  vim.lsp.enable("lua_ls")
end
