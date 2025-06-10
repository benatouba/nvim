local defaultOpts = { silent = true, remap = false }
-- vim.keymap.set('n', '<C-j>', 'ciW<CR><Esc><cmd>if match( @", "^\\s*$") < 0<Bar>exec "norm P-$diw+"<Bar>endif<CR>', {remap = false, silent = true, expr = true})
local function map(mode, lhs, rhs, opts)
    local options = { remap = false, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

map("n", "Y", "y$", defaultOpts) -- yank to end of line
map("", "Q", "<Nop>", defaultOpts) -- no ex mode
map("", "q:", "<cmd>q", defaultOpts) -- fix my typing
map("n", "n", "nzzzv", defaultOpts)
map("n", "N", "Nzzzv", defaultOpts)
map("n", "<esc>", "<cmd>nohlsearch<CR>")

map("t", "<C-j>", "<C-\\><C-N><C-w>j", { remap = false })
map("t", "<C-k>", "<C-\\><C-N><C-w>k", { remap = false })
map("t", "<Esc>", "<C-\\><C-n>", { remap = false })

map("n", "<C-Up>", "<cmd>resize +2<CR>")
map("n", "<C-Down>", "<cmd>resize -2<CR>")
map("n", "<C-Left>", "<cmd>vertical resize +2<CR>")
map("n", "<C-Right>", "<cmd>vertical resize -2<CR>")

-- switch buffer
map("t", "<C-l>", "<C-\\><C-N><C-w><cmd>BufferNext<CR>", { remap = false })
map("t", "<C-h>", "<C-\\><C-N><C-w><cmd>BufferPrevious<CR>", { remap = false })

-- move selected line / block in  v mode
map("x", "K", "<cmd>move '<-2<CR>gv-gv'<ESC>")
map("x", "J", "<cmd>move '>+1<CR>gv-gv'<ESC>")

-- TAB completion
map("i", "<C-TAB>", "cmp#complete()")

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
