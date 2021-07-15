local funcs = require('functions')

local auto_formatters = {            }

local python_autoformat = {'BufWritePre', '*.py', 'lua vim.lsp.buf.formatting_sync(nil, 1000)'}
if O.python.autoformat then table.insert(auto_formatters, python_autoformat) end

local javascript_autoformat = {'BufWritePre', '*.js', 'lua vim.lsp.buf.formatting_sync(nil, 1000)'}

local lua_format = {'BufWritePre', '*.lua', 'lua vim.lsp.buf.formatting_sync(nil, 1000)'}
if O.lua.autoformat then table.insert(auto_formatters, lua_format) end

local json_format = {'BufWritePre', '*.json', 'lua vim.lsp.buf.formatting_sync(nil, 1000)'}
if O.json.autoformat then table.insert(auto_formatters, json_format) end

local ruby_format = {'BufWritePre', '*.rb', 'lua vim.lsp.buf.formatting_sync(nil,1000)'}
if O.ruby.autoformat then table.insert(auto_formatters, ruby_format) end
funcs.define_augroups({
    _general_settings = {
        {'TextYankPost', '*', 'lua require(\'vim.highlight\').on_yank({higroup = \'Search\', timeout = 200})'},
        {'BufWinEnter', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
        {'BufRead', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
        {'BufWinEnter,BufRead,BufNewFile', '*_p3d*', 'setfiletype fortran'},
        {'BufWinEnter,BufRead,BufNewFile', '*.pro', 'setfiletype idlang'},
        {'BufWinEnter,BufRead,BufNewFile', '.bash*', 'setfiletype bash'},
        {'BufRead', '*_p3d*', 'setfiletype fortran'},
        {"BufWritePost", "[init|plugins].lua", "lua require('funcs').reload_config()"},
	{'BufWritePre', '*', ':%s/\\s\\+$//e'},
        {'BufNewFile', '*', 'setlocal formatoptions-=c formatoptions-=r formatoptions-=o'},
        {'VimLeavePre', '*', 'set title set titleold='}
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
    _auto_formatters = auto_formatters
})
