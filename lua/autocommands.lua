local utils = require("utils")
local api = vim.api
api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 })
  end,
})
api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  { pattern = "*/node_modules/*", command = "lua vim.diagnostic.disable(0)" }
)
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.txt", "*.md", "*.tex" },
  command = "setlocal spell",
})
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.txt", "*.md", "*.json" },
  command = "setlocal conceallevel=0",
})

utils.add_autocommands({
  _general_settings = {
    { "BufRead", "*_p3d*", "setfiletype fortran" },
    { "BufRead", "*.pro", "setfiletype idlang" },
    { "BufRead", "*.bash*", "setfiletype bash" },
    { "BufRead", "*.R", "setfiletype r" },
    { "BufRead", "*.r", "setfiletype r" },
    { "BufRead", "*.Rmd", "setfiletype rmd" },
    { "BufRead", "*.rmd", "setfiletype rmd" },
    { "BufRead", "*.ipynb", "setfiletype ipynb" },
    { "BufRead", "w*_namelist*", "setfiletype fortran" },
    { "BufRead", "*swa*.conf*", "setfiletype i3config" },
    -- { "BufWritePost", "plugins.lua", "lua R('plugins')" },
    -- { "BufWritePost", "~/.config/nvim/init.lua", "lua require('functions').reload_config()" },
    -- { "BufWritePre", "*", ":%s/\\s\\+$//e" },
    -- { "VimLeavePre", "*", "set title set titleold=" },
    { "BufRead", "*.sls", "setf sls" },
    { "BufWritePost", "*.py", "silent lua Pyflyby()" },
  },
  _markdown = { { "FileType", "markdown", "setlocal wrap" } },
  _buffer_bindings = {
    { "FileType", "neotest-*", "nnoremap <silent> <buffer> q :q<CR>" },
    { "FileType", "neotest-output-panel", "nnoremap <silent> <buffer> q :q<CR>" },
    {
      "FileType",
      "checkhealth,help,lsp-installer,qf,fugitive,lspinfo,dashboard,notify,query,floaterm,dashboard",
      "nnoremap <silent> <buffer> q :q<CR>",
    },
    {
      "FileType",
      "checkhealth,help,lsp-installer,qf,fugitive,lspinfo,dashboard,notify,query,floaterm,dashboard",
      "nnoremap <silent> <buffer> <esc> :q<CR>",
    },
    { "FileType", "nofile,httpResult", "nnoremap <silent> <buffer> q :q<CR>" },
    { "FileType", "nofile,httpResult", "nnoremap <silent> <buffer> <esc> :q<CR>" },
    { "FileType", "norg", ":lua vim.o.conceallevel=2" },
    -- { "FileType", "org", ":lua vim.o.conceallevel=2" },
    { "FileType", "org", ":lua vim.o.concealcursor='nc'" },
  },
  firenvim = {
    { "BufEnter", "*ipynb_er-DIV*.txt", "set filetype=python" },
    { "BufEnter", "*ipynb_ontainer-DIV*.txt", "set filetype=markdown" },
  },
  -- jupyter = {
  -- 	{"FileType", "ipynb", "\\call jobstart('jupyter qtconsole --JupyterWidget.include_other_output=True')"}
  -- }
})
