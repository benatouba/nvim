AddAutocommands({
  _general_settings = {
    { "TextYankPost", "*", "lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 40})" },
    { "BufWinEnter", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" },
    { "BufRead", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" },
    { "BufRead", "*", "tnoremap <silent> <esc> <c-\\><c-n>" },
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
    { "BufWritePre", "*", ":%s/\\s\\+$//e" },
    { "BufNewFile", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" },
    -- { "VimLeavePre", "*", "set title set titleold=" },
    { "BufRead", "*.sls", "setf sls" },
    { "BufWritePost", "*.py", "silent lua Pyflyby()" },
  },
  _markdown = { { "FileType", "markdown", "setlocal wrap" } },
  _buffer_bindings = {
    { "FileType", "dashboard", "nnoremap <silent> <buffer> q :q<CR>" },
    { "FileType", "neotest-*", "nnoremap <silent> <buffer> q :q<CR>" },
    { "FileType", "neotest-output-panel", "nnoremap <silent> <buffer> q :q<CR>" },
    { "FileType", "notify", "nnoremap <silent> <buffer> q :q<CR>" },
    { "FileType", "lspinfo", "nnoremap <silent> <buffer> q :q<CR>" },
    { "FileType", "floaterm", "nnoremap <silent> <buffer> q :q<CR>" },
    { "FileType", "fugitive", "nnoremap <silent> <buffer> q :q<CR>" },
    { "FileType", "qf", "nnoremap <silent> <buffer> q :q<CR>" },
    { "FileType", "query", "nnoremap <silent> <buffer> q :q<CR>" },
    { "FileType", "checkhealth,help,lsp-installer,qf,fugitive,lspinfo,dashboard",
      "nnoremap <silent> <buffer> q :q<CR>" },
    { "FileType", "checkhealth,help,lsp-installer,qf,fugitive,lspinfo,dashboard",
      "nnoremap <silent> <buffer> <esc> :q<CR>" },
    { "FileType", "nofile", "nnoremap <silent> <buffer> q :q<CR>" },
    { "FileType", "norg", ":lua vim.o.conceallevel=2" },
  },
  firenvim = {
    { "BufEnter", "*ipynb_er-DIV*.txt", "set filetype=python" },
    { "BufEnter", "*ipynb_ontainer-DIV*.txt", "set filetype=markdown" }
  },
  -- jupyter = {
  -- 	{"FileType", "ipynb", "\\call jobstart('jupyter qtconsole --JupyterWidget.include_other_output=True')"}
  -- }
})
