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
-- lazy.nvim cannot restore its own running checkout, so pin the bootstrap on
-- every startup, not just the first clone. The initial clone is the stable
-- branch, which may not contain the locked commit, so fetch it first.
local lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json"
local lock = vim.json.decode(table.concat(vim.fn.readfile(lockfile), "\n"))
local pin = lock["lazy.nvim"].commit
-- The initial clone is the stable branch, which may not contain the locked
-- commit; fetch it first, but only when it is missing locally.
vim.fn.system({ "git", "-C", lazypath, "cat-file", "-e", pin })
if vim.v.shell_error ~= 0 then
  local fetch = vim.fn.system({ "git", "-C", lazypath, "fetch", "--quiet", "origin", pin })
  if vim.v.shell_error ~= 0 then
    error("Failed to fetch pinned lazy.nvim: " .. fetch)
  end
end
local checkout = vim.fn.system({ "git", "-C", lazypath, "checkout", "--quiet", pin })
if vim.v.shell_error ~= 0 then
  error("Failed to pin lazy.nvim: " .. checkout)
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  defaults = { lazy = true }, -- every spec declares its own trigger; start plugins say lazy = false
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
