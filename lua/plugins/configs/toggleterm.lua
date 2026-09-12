-- toggleterm options plus the custom terminals bound under <leader>T.
local M = {}

M.opts = {
  direction = "horizontal",
  float_opts = { border = "single", width = 120, height = 30, winblend = 3 }, -- was misspelt float_lazys (ignored)
  winbar = {
    enabled = true,
    name_formatter = function(term)
      return term.name
    end,
  },
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = term.bufnr, silent = true })
    vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { buffer = term.bufnr, silent = true })
  end,
}

-- A toggleable terminal running `cmd`; q (and <esc> in terminal mode) closes it.
local function terminal(spec)
  local Terminal = require("toggleterm.terminal").Terminal
  return Terminal:new(vim.tbl_extend("force", {
    on_open = function(term)
      vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = term.bufnr, silent = true })
      if spec.esc_closes then
        vim.keymap.set("t", "<esc>", "<cmd>close<CR>", { buffer = term.bufnr, silent = true })
      end
    end,
  }, spec))
end

M.btop = function()
  return terminal({ cmd = "btop", direction = "tab", esc_closes = true }):toggle()
end

M.lazygit = function()
  return terminal({ cmd = "lazygit", direction = "tab", esc_closes = true }):toggle()
end

M.visidata = function(file)
  return terminal({ cmd = "vd " .. file, direction = "float" }):toggle()
end

-- Pick the dependency-update command for the project in the cwd.
local function update_command()
  local exists = function(p)
    return vim.uv.fs_stat(p) ~= nil
  end
  if exists("pyproject.toml") then
    for _, line in ipairs(vim.fn.readfile("pyproject.toml")) do
      if line == "[tool.uv]" then
        return "uv sync"
      elseif line == "[tool.poetry]" then
        return "poetry update"
      elseif line:sub(1, 3) == "dep" and exists(".venv") then
        return "uv sync"
      end
    end
  end
  if exists("requirements.txt") then
    return "pip install --upgrade -r requirements.txt"
  elseif exists("package.json") then
    return "pnpm update"
  end
end

M.update_project = function()
  local cmd = update_command()
  if not cmd then
    vim.notify("No project manifest found in " .. vim.fn.getcwd(), vim.log.levels.WARN)
    return
  end
  return terminal({ cmd = cmd, direction = "float", close_on_exit = false }):toggle()
end

-- Live-coding helpers: boot the dirt sampler / tidal ghci from the project devenv.
local function boot(cmd_prefix, env_var, hint)
  local value = vim.env[env_var]
  if not value or value == "" then
    vim.notify(env_var .. " is not set (" .. hint .. ")", vim.log.levels.ERROR)
    return
  end
  vim.cmd("ToggleTerm direction=horizontal cmd=" .. vim.fn.shellescape(cmd_prefix .. vim.fn.shellescape(value)))
end

M.dirt_boot = function()
  boot("dirt -s ", "TIDAL_SAMPLE_DIR", "enter project devenv")
end

M.tidal_boot = function()
  boot("ghci -ghci-script ", "TIDAL_BOOT", "enter project devenv")
end

return M
