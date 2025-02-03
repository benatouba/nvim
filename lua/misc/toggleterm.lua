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

M.config = function ()
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
      name_formatter = function (term)
        return term.name
      end,
    },
    on_open = function (term)
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
    { "<leader>t", group = "+Terminal", remap = false, icon = { icon = " ", color = "green" } },
    { "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal", remap = false, icon = { icon = " ", color = "green" } },
    { "<leader>gL", "<cmd>lua require('misc.toggleterm').LazyGit()<cr>", desc = "LazyGit", remap = false, icon = { icon = " ", color = "cyan" } },
    { "<leader>B", "<cmd>lua require('misc.toggleterm').btop()<cr>", desc = "BTop", remap = false, icon = { icon = " ", color = "orange" } },
    -- { "<leader>tv", "yi\"<cmd>lua require('misc.toggleterm').VisiData(vim.cmd[[p]])<cr>", desc = "VisiData" },
    { "<leader>tv", "yi\"<cmd>lua P(vim.cmd[[p]])<cr>\"", desc = "VisiData", remap = false, icon = { icon = " ", color = "orange" } },
    { "<leader>tV", "<cmd>lua require('misc.toggleterm').VisiData(vim.api.nvim_buf_get_name(0))<cr>", desc = "VisiData (File)" },
    { "<leader>tu", "<cmd>lua require('misc.toggleterm').UpdateProject()<cr>", desc = "Update Project", remap = false, icon = { icon = " ", color = "yellow" } },
  })
end
M.btop = function ()
  local Terminal = require("toggleterm.terminal").Terminal
  local btop = Terminal:new({
    cmd = "btop",
    direction = "tab",
    on_open = function (term)
      local keymap = vim.api.nvim_buf_set_keymap
      keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      keymap(term.bufnr, "t", "<esc>", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
  })
  return btop:toggle()
end

M.LazyGit = function ()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    direction = "tab",
    on_open = function (term)
      local keymap = vim.api.nvim_buf_set_keymap
      keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      keymap(term.bufnr, "t", "<esc>", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
  })
  return lazygit:toggle()
end

M.VisiData = function (file)
  local Terminal = require("toggleterm.terminal").Terminal
  local visidata = Terminal:new({
    cmd = "vd " .. file,
    direction = "float",
    -- float_opts = {
    --   border = "rounded",
    --   width = 125,
    --   height = 35,
    -- },
    on_open = function (term)
      local keymap = vim.api.nvim_buf_set_keymap
      keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      -- keymap(term.bufnr, "t", "<esc>", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
  })
  return visidata:toggle()
end
local function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

local function lines_from(file)
  if not file_exists(file) then return {} end
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end

local update_project = function ()
  if file_exists("./pyproject.toml") then
    local lines = lines_from("./pyproject.toml")
    for _, v in pairs(lines) do
      if v == "[tool.poetry]" then
        return "poetry update"
      elseif string.sub(v, 1, 3) == "dep" and file_exists("./.venv/") then
        return "uv sync"
      end
    end
  end
  if file_exists("./requirements.txt") then
    return "pip install --upgrade -r requirements.txt"
  elseif file_exists("./package.json") then
    return "pnpm update"
  end
end

M.UpdateProject = function ()
  local Terminal = require("toggleterm.terminal").Terminal
  local updater = Terminal:new({
    cmd = update_project(),
    direction = "float",
    -- float_opts = {
    --   border = "rounded",
    --   width = 125,
    --   height = 35,
    -- },
    close_on_exit = false,
    on_open = function (term)
      local keymap = vim.api.nvim_buf_set_keymap
      keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      -- keymap(term.bufnr, "t", "<esc>", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
  })
  return updater:toggle()
end
return M
