local ll_ok, ll = pcall(require, "lualine")
if not ll_ok then
  vim.notify("lualine not okay")
  return
end

local get_lsp_client = function ()
  local msg = "LSP Inactive "
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_active_clients()
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
          lsps = lsps .. ", " .. client.name
        end
      end
    end
  end
  if lsps == "" then
    return msg
  else
    return lsps
  end
end

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end

local function window()
  return vim.api.nvim_win_get_number(0)
end

local M = {}
M.config = function ()
  local config = ll.get_config()
  config.sections.lualine_a = { window }
  config.sections.lualine_b = { { "b:gitsigns_head", icon = "" } }
  config.sections.lualine_c = { { "diff", source = diff_source }, "diagnostics" }
  config.sections.lualine_x = { { get_lsp_client }, "encoding", "fileformat", "filetype",
    {
      require("noice").api.status.mode.get,
      cond = require("noice").api.status.mode.has,
      color = { fg = "#ff9e64" },
    },
  }
  config.options.extensions = { "quickfix", "mason", "lazy", "overseer", "trouble", "nvim-tree",
    "toggleterm", "nvim-dap-ui", }
  ll.setup(config)
end

return M
