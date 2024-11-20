local M = {}
local tt_ok, tt = pcall(require, "toggleterm")
if not tt_ok then
  vim.notify("Toggleterm not found", vim.log.levels.ERROR)
  return
end

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  vim.notify("Which-key not found", vim.log.levels.ERROR)
  return
end

M.config = function()
  tt.setup({
    direction = "horizontal",
    float_lazys = {
      border = "single",
      width = 120,
      height = 30,
      winblend = 3,
    },
    winbar = {
      enabled = true,
      name_formatter = function(term)
        return term.name
      end,
    },
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(
        term.bufnr,
        "n",
        "q",
        "<cmd>close<cr>",
        { noremap = true, silent = true }
      )
      vim.api.nvim_buf_set_keymap(
        term.bufnr,
        "n",
        "<esc>",
        "<cmd>close<cr>",
        { noremap = true, silent = true }
      )
    end,
  })

  wk.add({
    { "<leader>T", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal" },
    { "<leader>gL", "<cmd>lua require('misc.toggleterm').LazyGit()<cr>", desc = "LazyGit" },
    -- { "<leader>tv", "yi\"<cmd>lua require('misc.toggleterm').VisiData(vim.cmd[[p]])<cr>", desc = "VisiData" },
    { "<leader>tv", "yi\"<cmd>lua P(vim.cmd[[p]])<cr>", desc = "VisiData" },
    { "<leader>tV", "<cmd>lua require('misc.toggleterm').VisiData(vim.api.nvim_buf_get_name(0))<cr>", desc = "VisiData (File)" },
  })
end

M.LazyGit = function()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    direction = "float",
    float_opts = {
      border = "rounded",
      width = 125,
      height = 35,
    },
    on_open = function(term)
      local keymap = vim.api.nvim_buf_set_keymap
      keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      keymap(term.bufnr, "t", "<esc>", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
  })
  return lazygit:toggle()
end

M.VisiData = function(file)
  local Terminal = require("toggleterm.terminal").Terminal
  local visidata = Terminal:new({
    cmd = "vd " .. file,
    direction = "float",
    -- float_opts = {
    --   border = "rounded",
    --   width = 125,
    --   height = 35,
    -- },
    on_open = function(term)
      local keymap = vim.api.nvim_buf_set_keymap
      keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      -- keymap(term.bufnr, "t", "<esc>", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
  })
  return visidata:toggle()
end

return M
