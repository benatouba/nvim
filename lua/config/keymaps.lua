-- Base keymaps that do not belong to any plugin. Plugin keymaps live in their spec's `keys`.

local map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { silent = true }, opts or {}))
end

map("n", "Y", "y$", { desc = "Yank to end of line" })
map("", "Q", "<Nop>", { desc = "No Ex mode" })
map("", "q:", "<cmd>q<CR>", { desc = "Quit (typo guard for :q)" })
map("n", "n", "nzzzv", { desc = "Next match, centred" })
map("n", "N", "Nzzzv", { desc = "Previous match, centred" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Terminal: leave insert / navigate windows / switch buffers without leaving the terminal
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Terminal normal mode" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Window down" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Window up" })
map("t", "<C-l>", "<C-\\><C-n><cmd>BufferNext<CR>", { desc = "Next buffer" })
map("t", "<C-h>", "<C-\\><C-n><cmd>BufferPrevious<CR>", { desc = "Previous buffer" })

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Taller" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Shorter" })
map("n", "<C-Left>", "<cmd>vertical resize +2<CR>", { desc = "Wider" })
map("n", "<C-Right>", "<cmd>vertical resize -2<CR>", { desc = "Narrower" })

-- Move the selected lines
map("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

-- Forgive a held shift on the most common commands
for typo, cmd in pairs({
  W = "w",
  ["W!"] = "w!",
  Wq = "wq",
  wQ = "wq",
  WQ = "wq",
  Wa = "wa",
  Q = "q",
  ["Q!"] = "q!",
  Qall = "qall",
  ["Qall!"] = "qall!",
}) do
  vim.cmd.cnoreabbrev(typo, cmd)
end
