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
map('n', '<cr>', 'i<cr><esc>d0i', defaultOpts) -- split lines ()
map('n', '<leader>br', ':syntax sync fromstart<cr>:redraw!<cr>', defaultOpts) -- treesitter fails sometimes
map('n', 'n', 'nzzzv', defaultOpts) -- split lines ()
map('n', 'N', 'Nzzzv', defaultOpts) -- split lines ()

-- better window movement
-- map('n', '<C-h>', '<C-w>h', {silent = true})
-- map('n', '<C-j>', '<C-w>j', {silent = true})
-- map('n', '<C-k>', '<C-w>k', {silent = true})
-- map('n', '<C-l>', '<C-w>l', {silent = true})
map('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', defaultOpts)
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', defaultOpts)
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', defaultOpts)
map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', defaultOpts)
map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', defaultOpts)
map('n', 'gds', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<cr>')
map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<cr>')

-- map('n', '<leader>d', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')
-- map('n', '<leader>ln', '<cmd>lua vim.lsp.diagnostic.get_line_diagnostics()<CR>')

vim.cmd('command! -nargs=0 LspVirtualTextToggle lua require("lsp/virtual_text").toggle()')

map('t', '<C-j>', '<C-\\><C-N><C-w>j', {noremap = true})
map('t', '<C-k>', '<C-\\><C-N><C-w>k', {noremap = true})
-- map('t', '<Esc>', '<C-\\><C-n>', {noremap = true})

map('n', '<C-Up>', ':resize +2<CR>')
map('n', '<C-Down>', ':resize -2<CR>')
map('n', '<C-Left>', ':vertical resize +2<CR>')
map('n', '<C-Right>', ':vertical resize -2<CR>')

-- switch buffer
map('n', '<c-l>', ':BufferNext<CR>')
map('n', '<c-h>', ':BufferPrevious<CR>')
map('i', '<c-l>', ':BufferNext<CR>')
map('i', '<c-h>', ':BufferPrevious<CR>')
map('t', '<C-l>', '<C-\\><C-N><C-w>:BufferNext<CR>', {noremap = true})
map('t', '<C-h>', '<C-\\><C-N><C-w>:BufferPrevious<CR>', {noremap = true})

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

