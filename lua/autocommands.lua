local formatters = {}

local javascript_autoformat = {'BufWritePre', '*.js', 'lua vim.lsp.buf.formatting_sync(nil, 1000)'}
if O.jsts.format.auto then table.insert(formatters, javascript_autoformat) end

local python_autocommands = {'BufWritePre', '*.py', 'Format'}
if O.python.format.auto then table.insert(formatters, python_autocommands) end

local lua_format = {'BufWritePre', '*.lua', 'Format'}
if O.lua.format.auto then table.insert(formatters, lua_format) end

local json_format = {'BufWritePre', '*.json', 'lua vim.lsp.buf.formatting_sync(nil, 1000)'}
if O.json.format.auto then table.insert(formatters, json_format) end

local ruby_format = {'BufWritePre', '*.rb', 'lua vim.lsp.buf.formatting_sync(nil,1000)'}
if O.ruby.format.auto then table.insert(formatters, ruby_format) end

AddAutocommands({
    _general_settings = {
        {'TextYankPost', '*', 'lua require(\'vim.highlight\').on_yank({higroup = \'Search\', timeout = 200})'},
        {'BufWinEnter', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
        {'BufRead', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
        {'BufWinEnter,BufRead,BufNewFile', '*_p3d*', 'setfiletype fortran'},
        {'BufWinEnter,BufRead,BufNewFile', '*.pro', 'setfiletype idlang'},
        {'BufWinEnter,BufRead,BufNewFile', '*.bash*', 'setfiletype bash'},
        {"BufWritePost", "plugins.lua", "lua R('plugins')"},
        {"BufWritePost", "~/.config/nvim/init.lua", "lua require('functions').reload_config()"},
        {'BufWritePre', '*', ':%s/\\s\\+$//e'},
        {'BufNewFile', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
        {'VimLeavePre', '*', 'set title set titleold='},
        {'BufWinEnter,BufRead,BufNewFile', '*.sls', 'setf sls'}
    },
    _markdown = {{'FileType', 'markdown', 'setlocal wrap'}},
    _buffer_bindings = {
        {'FileType', 'dashboard', 'nnoremap <silent> <buffer> q :q<CR>'},
        {'FileType', 'lspinfo', 'nnoremap <silent> <buffer> q :q<CR>'},
        {'FileType', 'floaterm', 'nnoremap <silent> <buffer> q :q<CR>'},
        {'FileType', 'fugitive', 'nnoremap <silent> <buffer> q :q<CR>'},
        {'FileType', 'qf', 'nnoremap <silent> <buffer> q :q<CR>'},
        {'FileType', 'help', 'nnoremap <silent> <buffer> q :q<CR>'},
    },
    _auto_formatters = formatters,
})
