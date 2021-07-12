local defaultOpts = {silent = true, noremap = true}
-- vim.api.nvim_set_keymap('n', '<C-j>', 'ciW<CR><Esc>:if match( @", "^\\s*$") < 0<Bar>exec "norm P-$diw+"<Bar>endif<CR>', {noremap = true, silent = true, expr = true})
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
-- map('n', '<Space>',    '<NOP>',                      defaultOpts)
-- map('n', '<Leader>h',  ':set hlsearch!<CR>',         defaultOpts)
-- map('n', '<Leader>e',  ':NvimTreeToggle<CR>',        defaultOpts)  -- set in whichkey
map('n', 'Y', 'y$', defaultOpts) -- yank to end of line
map('n', '<leader>u', ':call UpdatePlugins()<CR>', defaultOpts) -- update all plugins with packer
map('', 'Q', '<Nop>', defaultOpts) -- no ex mode
map('', 'q:', ':q', defaultOpts) -- fix my typing
map('n', '<cr>', 'i<cr><esc>', defaultOpts) -- split lines ()
map('n', '<leader>br', ':syntax sync fromstart<cr>:redraw!<cr>', defaultOpts) -- treesitter fails sometimes
map('n', 'n', 'nzzzv', defaultOpts) -- split lines ()
map('n', 'N', 'Nzzzv', defaultOpts) -- split lines ()

-- better window movement
map('n', '<C-h>', '<C-w>h', {silent = true})
map('n', '<C-j>', '<C-w>j', {silent = true})
map('n', '<C-k>', '<C-w>k', {silent = true})
map('n', '<C-l>', '<C-w>l', {silent = true})
map('n', 'gh', '<cmd>lua require"lspsaga.provider".lsp_finder()<CR>', defaultOpts)
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', defaultOpts)
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', defaultOpts)
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', defaultOpts)
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', defaultOpts)
map('n', 'gds', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
map('n', 'gds', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
map('n', 'K', ':Lspsaga hover_doc<CR>')
map('n', '<C-p>', ':Lspsaga diagnostic_jump_prev<CR>')
map('n', '<C-n>', ':Lspsaga diagnostic_jump_next<CR>')
map('n', '<C-f>', '<cmd>lua require"lspsaga.action".smart_scroll_with_saga(1)<CR>')
map('n', '<C-b>', '<cmd>lua require"lspsaga.action".smart_scroll_with_saga(-1)<CR>')
map('n', '[g', '<cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<cr>')
map('n', ']g', '<cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<cr>')
map('t', '<leader>tt', '<C-\\><C-n>:lua require("lspsaga.floaterm").close_float_terminal()<CR>')
map('n', '<leader>tt', '<cmd>lua require("lspsaga.floaterm").open_float_terminal()<CR>')

-- map('n', '<leader>d', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
-- map('n', '<leader>ln', '<cmd>lua vim.lsp.diagnostic.get_line_diagnostics()<CR>')

vim.cmd('command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()')
vim.cmd('nnoremap <silent> gs <cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>')

map('t', '<C-h>', '<C-\\><C-N><C-w>h', {noremap = true})
map('t', '<C-j>', '<C-\\><C-N><C-w>j', {noremap = true})
map('t', '<C-k>', '<C-\\><C-N><C-w>k', {noremap = true})
map('t', '<C-l>', '<C-\\><C-N><C-w>l', {noremap = true})
map('i', '<C-h>', '<C-\\><C-N><C-w>h', {noremap = true})
map('i', '<C-j>', '<C-\\><C-N><C-w>j', {noremap = true})
map('i', '<C-k>', '<C-\\><C-N><C-w>k', {noremap = true})
map('i', '<C-l>', '<C-\\><C-N><C-w>l', {noremap = true})
map('t', '<Esc>', '<C-\\><C-n>', {noremap = true})

map('n', '<C-Up>', ':resize +2<CR>')
map('n', '<C-Down>', ':resize -2<CR>')
map('n', '<C-Left>', ':vertical resize -2<CR>')
map('n', '<C-Right>', ':vertical resize +2<CR>')

-- tabs switch buffer
map('n', '<TAB>', ':BufferNext<CR>')
map('n', '<S-TAB>', ':BufferPrevious<CR>')

-- move selected line / block in  v mode
map('x', 'K', ':move \'<-2<CR>gv-gv\'<ESC>')
map('x', 'J', ':move \'>+1<CR>gv-gv\'<ESC>')

-- TAB completion
map('i', '<C-TAB>', 'compe#complete()')

-- Redraw and fix everything
map('n', '<C-l>', ':nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>', defaultOpts)

vim.cmd([[
    cnoreabbrev W w
    cnoreabbrev W! w!
    cnoreabbrev Wq wq
    cnoreabbrev wQ wq
    cnoreabbrev WQ wq
    cnoreabbrev Wa wa
    cnoreabbrev Q q
    cnoreabbrev Q! q!
    cnoreabbrev Qall! qall!
    cnoreabbrev Qall qall
]])

