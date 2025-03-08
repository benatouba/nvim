local lspsaga_ok, lspsaga = pcall(require, "lspsaga")
if not lspsaga_ok then
  vim.notify("Lspsaga not ok", vim.log.levels.ERROR)
  return
end

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  vim.notify("which-key not ok", vim.log.levels.ERROR)
  return
end

local M = {}

M.config = function ()
  lspsaga.setup({
    code_action = {
      num_shortcut = true,
      show_server_name = true,
      extend_gitsigns = true,
      keys = {
        quit = { "q", "<ESC>" },
        exec = "<CR>",
      },
    },
    lightbulb = {
      enable = false,
    },
    hover = {
      enable = true,
      max_width = 0.6,
      open_link = 'gx',
      open_browser = '!brave',
    },
    ui = {
      -- This option only works in Neovim 0.9
      title = true,
      -- Border type can be single, double, rounded, solid, shadow.
      border = "rounded",
      -- lines = { '┗', '┣', '┃', '━', '┏' },
      lines = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      winblend = 0,
      expand = "",
      collapse = "",
      code_action = "💡",
      incoming = " ",
      outgoing = " ",
      hover = ' ',
      kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
    },
    request_timeout = 5000,
  })

  wk.add({
    { "gI",         "<cmd>Lspsaga finder imp<CR>",           desc = "Implementation" },
    { "ga",         "<cmd>Lspsaga code_action<CR>",          desc = "Code Action" },
    { "gF",         "<cmd>Lspsaga finder def+ref<CR>",       desc = "Finder" },
    { "go",         "<cmd>Lspsaga outline<CR>",              desc = "Outline" },
    { "gp",         "<cmd>Lspsaga peek_definition<CR>",      desc = "Peek" },
    { "]d",         "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Next Diagnostic" },
    { "[d",         "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Prev Diagnostic" },
    { "<leader>ld", "<cmd>Lspsaga goto_definition<cr>",      desc = "Definitions" },
  })
  -- vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<cr>')
end


return M
