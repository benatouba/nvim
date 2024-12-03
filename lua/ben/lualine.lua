local ll_ok, ll = pcall(require, "lualine")
if not ll_ok then
  vim.notify("lualine not okay")
  return
end
local lualine_require = require("lualine_require")
local modules = lualine_require.lazy_require({
  highlight = "lualine.highlight",
  utils = "lualine.utils.utils",
})
local remote_ok, remote = pcall(require, "remote-nvim")

local get_lsp_client = function ()
  local msg = "LSP Inactive"
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_clients()
  if next(clients) == nil then
    return msg
  end
  local lsps = ""
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      if lsps == "" then
        lsps = client.name
      else
        if not string.find(lsps, client.name) then
          lsps = lsps .. "|" .. client.name
        end
      end
    end
  end
  if lsps == "" then
    return msg
  else
    return " " .. lsps
  end
end

local rstt =
{
  { "-", "#aaaaaa" },  -- 1: ftplugin/* sourced, but nclientserver not started yet.
  { "S", "#757755" },  -- 2: nclientserver started, but not ready yet.
  { "S", "#117711" },  -- 3: nclientserver is ready.
  { "S", "#ff8833" },  -- 4: nclientserver started the TCP server
  { "S", "#3388ff" },  -- 5: TCP server is ready
  { "R", "#ff8833" },  -- 6: R started, but nvimcom was not loaded yet.
  { "R", "#3388ff" },  -- 7: nvimcom is loaded.
}

local rstatus = function ()
  if not vim.g.R_Nvim_status or vim.g.R_Nvim_status == 0 then
    -- No R file type (R, Quarto, Rmd, Rhelp) opened yet
    return ""
  end
  return rstt[vim.g.R_Nvim_status][1]
end

local rsttcolor = function ()
  if not vim.g.R_Nvim_status or vim.g.R_Nvim_status == 0 then
    -- No R file type (R, Quarto, Rmd, Rhelp) opened yet
    return { fg = "#000000" }
  end
  return { fg = rstt[vim.g.R_Nvim_status][2] }
end

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local function window()
  return vim.api.nvim_win_get_number(0)
end

-- local function package_status()
--   local pi_ok, pi = pcall(require, "package-info")
--   if not pi_ok then
--     return
--   end
--   return pi.get_status()
-- end
local lint_ok, lint = pcall(require, "lint")
local lint_progress = function ()
  return false
end
if lint_ok then
  lint_progress = function ()
    local linters = lint.get_running()
    if #linters == 0 then
      return "󰦕"
    end
    return "󱉶 " .. table.concat(linters, ", ")
  end
end

local M = {}
M.config = function ()
  local config = ll.get_config()
  config.options.component_separators = { left = "", right = "" }
  config.options.section_separators = { left = "", right = "" }
  config.sections.lualine_a = { window }
  config.sections.lualine_b = { { "b:gitsigns_head", icon = "" } }
  if remote_ok then
    table.insert(config.sections.lualine_b, {
      function ()
        return vim.g.remote_neovim_host and ("Remote: %s"):format(vim.uv.os_gethostname()) or ""
      end,
      padding = { right = 1, left = 1 },
      separator = { left = "", right = "" },
    })
  end
  config.sections.lualine_c = { { "diff", source = diff_source }, "diagnostics", "oil" }
  config.sections.lualine_x = {
    "overseer",
    { get_lsp_client },
    { lint_progress },
    { "copilot", show_colors = true },
  }
  config.sections.lualine_y = {
    "encoding",
    "fileformat",
    { rstatus, color = rsttcolor },
    "filetype",
    {
      require("noice").api.status.mode.get,
      cond = require("noice").api.status.mode.has,
      color = { fg = "#ff9e64" },
    },
  }
  config.sections.lualine_z = { "progress", "location" }
  config.options.extensions = {
    "quickfix",
    "mason",
    "lazy",
    "overseer",
    "trouble",
    "nvim-tree",
    "toggleterm",
    "nvim-dap-ui",
    "oil",
  }
  ll.setup(config)
end

return M
