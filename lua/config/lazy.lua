local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local lazy_ok, lazy = pcall(require, "lazy")
if not lazy_ok then
  vim.notify("lazy.nvim not okay")
  return
end

lazy.setup({
  { import = "plugins.editor" },
  { import = "plugins.ui" },
  { import = "plugins.colorschemes" },
  { import = "plugins.lsp" },
  { import = "plugins.completion" },
  { import = "plugins.formatting" },
  { import = "plugins.linting" },
  { import = "plugins.git" },
  { import = "plugins.treesitter" },
  { import = "plugins.tools" },
  { import = "plugins.lang" },
  { import = "plugins.notes" },
  { import = "plugins.dap" },
  { import = "plugins.test" },
  { import = "plugins.notebooks" },
  { import = "plugins.databases" },
  { import = "plugins.ai" },
}, {})
