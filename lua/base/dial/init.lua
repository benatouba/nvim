local M = {}

M.config = function()

  local dial_ok, config = pcall(require, "dial.config")
  if not dial_ok then
      P("dial not okay")
      return
  end

  local augend = require("dial.augend")

  config.augends:register_group{
    default = {
      augend.integer.alias.decimal,
      augend.constant.alias.bool,
      augend.date.alias["%m/%d"],
      augend.date.alias["%Y/%m/%d"],
      augend.constant.alias.alpha,
      augend.constant.new{ elements = {"yes", "no"} },
    },
    fortran = {
      augend.constant.new{ elements = {"T", "F"} },
    },
    javascript = {
      augend.constant.new{ elements = {"let", "const", "var"} },
    },
    python = {
      augend.constant.new{ elements = {"def", "class"}}
    }
  }

  vim.cmd([[
    imap <C-a> <esc>b<Plug>(dial-increment)a
    imap <C-x> <esc>b<Plug>(dial-decrement)a
    nmap <C-a> <Plug>(dial-increment)
    nmap <C-c> <Plug>(dial-increment)
    nmap <C-x> <Plug>(dial-decrement)
    vmap <C-c> <Plug>(dial-increment)
    vmap <C-x> <Plug>(dial-decrement)
    vmap g<C-c> <Plug>(dial-increment-additional)
    vmap g<C-x> <Plug>(dial-decrement-additional)
    autocmd FileType javascript lua vim.api.nvim_buf_set_keymap(0, "n", "<C-a>", require("dial.map").inc_normal("javascript"), {noremap = true})
    autocmd FileType javascript lua vim.api.nvim_buf_set_keymap(0, "n", "<C-x>", require("dial.map").dec_normal("javascript"), {noremap = true})
    autocmd FileType fortran lua vim.api.nvim_buf_set_keymap(0, "n", "<C-a>", require("dial.map").inc_normal("fortran"), {noremap = true})
    autocmd FileType fortran lua vim.api.nvim_buf_set_keymap(0, "n", "<C-x>", require("dial.map").dec_normal("fortran"), {noremap = true})
    autocmd FileType python lua vim.api.nvim_buf_set_keymap(0, "n", "<C-a>", require("dial.map").inc_normal("python"), {noremap = true})
    autocmd FileType python lua vim.api.nvim_buf_set_keymap(0, "n", "<C-x>", require("dial.map").dec_normal("python"), {noremap = true})
  ]])

end

return M
