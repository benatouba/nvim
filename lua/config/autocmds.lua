local set_cmdline = vim.api.nvim_create_augroup("set_cmdline", { clear = true })

vim.api.nvim_create_autocmd("CmdlineEnter", {
  pattern = { "*" },
  callback = function()
    vim.opt.relativenumber = false
  end,
  group = set_cmdline,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = { "*" },
  callback = function()
    vim.opt.relativenumber = true
  end,
  group = set_cmdline,
})

return require("autocommands")
