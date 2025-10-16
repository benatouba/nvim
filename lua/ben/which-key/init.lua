local isOk, which_key = pcall(require, "which-key")
if not isOk then
  return
end

which_key.setup()

which_key.add({
  { "<leader>a", group = "+Actions", icon = { icon = "", color = "yellow" } },
  { "<leader>A", group = "+Avante", icon = { icon = "󱐒 ", color = "purple" }, remap = false, mode = "n" },
  { "<leader>c", group = "+Configuration", icon = { icon = "", color = "orange" } },
  { "<leader>E", group = "+Ecolog", icon = { icon = "󰒃  ", color = "green" }, remap = false, mode = "n" },
  { "<leader>g", group = "+Git", icon = { icon = "󰊢 ", color = "red" }, remap = false, mode = "n" },
  { "<leader>L", group = "+Logs", icon = { icon = " ", color = "green" } },
  { "<leader>l", group = "+LSP", icon = { icon = "", color = "yellow" } },
  { "<leader>m", group = "Marks", icon = { icon = "", color = "red" } },
  { "<leader>n", group = "+Annotations", icon = { icon = " ", color = "orange" }, remap = false, mode = "n" },
  { "<leader>o", group = "+Org", icon = { icon = " ", color = "purple" }, nowait = false, remap = false },
  { "<leader>p", group = "+Plugins", icon = { icon = " ", color = "blue" } },
  { "<leader>R", group = "+Refactor", icon = { icon = "󰈏 ", color = "grey" }, mode = { "x", "n" } },
  { "<leader>r", group = "+Run", icon = { icon = "󰑮  ", color = "yellow" }, remap = false, mode = "n" },
  { "<leader>s", group = "+Search", icon = { icon = " ", color = "azure" }, remap = false, mode = "n" },
  { "<localleader>s", group = "+SearchReplace", icon = { icon = " ", color = "azure" }, remap = false, mode = "n" },
  { "<leader>S", group = "+Sessions", icon = " ", remap = false, mode = "n" },
  { "<leader>T", group = "+Terminal", icon = { icon = " ", color = "orange" } },
  { "<leader>t", group = "+Test", icon = { icon = "󰙨 ", color = "yellow" } },
  { "<leader>v", group = "+Vivere", icon = { icon = "󰇈 ", color = "purple" }, remap = false },
  { "<localleader>o", group = "+Obsidian", icon = { icon = "󰇈 ", color = "purple" }, mode = { "n", "v", "x" } },
  {
    "<leader>t",
    "<cmd>ToggleTermSendVisualLines<cr>",
    desc = "Send to terminal",
    icon = { icon = " ", color = "purple" },
    mode = "v",
  },
  { "<leader>u", ":UndotreeToggle<cr>", desc = "Undotree", icon = { icon = " ", color = "green" } },
  {
    "<leader>f",
    "<cmd>lua P(vim.api.nvim_buf_get_name(0))<cr>",
    desc = "Show Filename",
    icon = { icon = "", color = "blue" },
  },
  -- Buffers
  -- { "<leader>b", group = "+Buffers" },
  { "<leader><leader>", ":bprevious<cr>", desc = "Switch Buffer" },
  -- Actions
  { "<leader>ac", ":BufferClose<CR>", desc = "Close Buffer" },
  { "<leader>ad", "<cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<cr>", desc = "Toggle diagnostics" },
  { "<leader>ah", "<cmd>let @/ = ''<cr>", desc = "Highlights" },
  { "<leader>as", "<cmd>source %<cr>", desc = "Source file" },
  { "<leader>ar", "<cmd>syntax sync fromstart<cr><cmd>redraw!<cr>", desc = "Redraw" },
  { "<leader>aw", "<cmd>call TrimWhitespace()<cr>", desc = "Trim Whitespaces" },
  -- Configuration
  { "<leader>cc", "<cmd>e ~/.config/nvim/init.lua<cr>", desc = "Open Config" },
  { "<leader>cC", "<cmd>ColorizerToggle<cr>", desc = "Colorizer" },
  { "<leader>ch", "<cmd>set hlsearch!<CR>", desc = "Highlight Search" },
  {
    "<leader>cr",
    function()
      vim.cmd([[source $MYVIMRC]])
      vim.notify("Nvim config successfully reloaded", vim.log.levels.INFO, { title = "nvim-config" })
    end,
    desc = "Reload Config",
  },
  { "<leader>cR", "<cmd>set norelativenumber!<cr>", desc = "Relative line numbers" },
  -- Plugins
  { "<leader>pc", "<cmd>Lazy clean<cr>", desc = "Clean" },
  { "<leader>pC", "<cmd>Lazy check<cr>", desc = "Check" },
  { "<leader>pd", "<cmd>Lazy debug<cr>", desc = "Debug" },
  { "<leader>ph", "<cmd>Lazy help<cr>", desc = "Help" },
  { "<leader>pi", "<cmd>Lazy install<cr>", desc = "Install" },
  { "<leader>pl", "<cmd>Lazy log<cr>", desc = "Log" },
  { "<leader>pp", "<cmd>Lazy profile<cr>", desc = "Profile" },
  { "<leader>pr", "<cmd>Lazy restore<cr>", desc = "Restore" },
  { "<leader>ps", "<cmd>Lazy sync<cr>", desc = "Sync" },
  { "<leader>pu", "<cmd>Lazy update<cr>", desc = "Update" },
  -- Diagnostics
  -- { "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next Diagnostic" },
  { "]D", "<cmd>lua require('trouble').next({skip_groups = true, desc = jump = true})<cr>" },
  -- { "]E", "<cmd>lua require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>", desc = "Next Error" },
  { "]T", "<cmd>lua require('todo-comments').jump_next()<cr>", desc = "Next todo comment" },
  -- { "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
  { "[D", "<cmd>lua require('trouble').previous({skip_groups = true, desc = jump = true})<cr>" },
  -- { "[E", "<cmd>lua require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })<cr>", desc = "Prev Error" },
  { "[T", "<cmd>lua require('todo-comments').jump_prev()<cr>", desc = "Previous todo comment" },
  -- Tabs
  { "]t", "<cmd>tabNext<cr>", desc = "Next tab" },
  { "[t", "<cmd>tabprevious<cr>", desc = "Tab" },
  -- Logs
  { "<leader>Ll", "<cmd>LspLog<cr>", desc = "LSP" },
  { "<leader>Lp", "<cmd>Lazy profile<cr>", desc = "Lazy Profile" },
  -- Generate Annotations
  { "<leader>nn", "<cmd>lua require('neogen').generate()<CR>", desc = "Auto" },
  { "<leader>nc", "<cmd>lua require('neogen').generate({ type = 'class'})<CR>", desc = "Class" },
  { "<leader>nf", "<cmd>lua require('neogen').generate({ type = 'func'})<CR>", desc = "Function" },
  { "<leader>nt", "<cmd>lua require('neogen').generate({ type = 'type'})<CR>", desc = "Type" },
  -- Diffmaps
  -- { "dr", ":diffget RE<CR>", "Diffget remote", group = "+Diffmaps", mode = "n", },
  -- { "dl", ":diffget LO<CR>", "Diffget local", group = "+Diffmaps", },
  -- { "db", ":diffget BA<CR>", "Diffget base", group = "+Diffmaps", },

  -- gmaps
  -- { "gr", "<cmd>lua require('nvim-treesitter-refactor.smart_rename')<cr>", desc = "Rename" },
})
