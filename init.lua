vim.loader.enable()
if vim.g.neovide then
  require("user-defaults")
  require("utils.globals")
  require("utils")
  require("keymappings")
  require("user-settings")
  require("settings")
  require("plugins")
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
  end
  require("autocommands")
  require("colorscheme")
  require("utils.after")
end
if O.is_nixos then
  -- LSPs
  vim.lsp.enable({
    "nil_ls",
    "lua_ls",
    "basedpyright",
    "ty",
    "eslint",
    "jsonls",
    "ltex_plus",
    "matlab_ls",
    "oxlint",
    "texlab",
    "tinymist",
    "vtsls",
    "vue_ls",
    "yamlls",
  })
end
