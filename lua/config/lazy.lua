-- Bootstrap lazy.nvim and load every spec under lua/plugins/.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" } }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "catppuccin-mocha", "habamax" } },
  checker = { enabled = true, notify = false }, -- check for updates quietly; see :Lazy
  change_detection = { notify = false },
  ui = { border = "rounded" },
  rocks = { enabled = false }, -- nothing here needs luarocks
  performance = {
    rtp = {
      -- netrw is disabled via vim.g.loaded_netrw* in config/options.lua
      disabled_plugins = { "gzip", "tarPlugin", "zipPlugin", "tohtml", "tutor", "rplugin" },
    },
  },
})
