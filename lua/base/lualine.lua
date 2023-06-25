local ll_ok, ll = pcall(require, "lualine")
if not ll_ok then
  vim.notify('lualine not okay')
  return
    end

local get_lsp_client = function()
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

local M = {}
M.config = function()
  local config = ll.get_config()
  -- config.sections.lualine_c = {}
  config.sections.lualine_x = {{get_lsp_client}, 'encoding', 'fileformat', 'filetype',
      {
        require("noice").api.status.mode.get,
        cond = require("noice").api.status.mode.has,
        color = { fg = "#ff9e64" },
      },
      {
        require("noice").api.status.search.get,
        cond = require("noice").api.status.search.has,
        color = { fg = "#ff9e64" },
      },
  }
  config.options.extensions = { "quickfix", "fugitive", "nvim-tree", "toggleterm", "nvim-dap-ui", }
  if O.colorscheme == 'catppuccin' then
    config.options.theme = O.colorscheme
  else
    config.options.theme = "tokyonight"
  end
  ll.setup(config)
end

return M