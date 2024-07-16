local M = {}

M.config = function()
  local dap_ok, dap = pcall(require, "dap")
  if not dap_ok then
    return
  end
  dap.configurations.lua = {
    {
      type = 'nlua',
      request = 'attach',
      name = "Attach to running Neovim instance",
      host = function()
        local value = vim.fn.input('Host [127.0.0.1]: ')
        if value ~= "" then
          return value
        end
        return '127.0.0.1'
      end,
      port = function()
        local val = tonumber(vim.fn.input('Port: '))
        assert(val, "Please provide a port number")
        return val
      end,
    }
  }

  dap.adapters.nlua = function(callback, config)
    callback({ type = 'server', host = config.host, port = config.port })
  end

  local wk_ok, wk = pcall(require, 'which-key')
  if not wk_ok then
    return
  end
  wk.add({
    { "<leader>dv", group = "vimkind" },
    { "<leader>dvS", "<cmd>lua require'osv'.launch()<cr>", desc = "Start server" },
    { "<leader>dvd", "<cmd>lua require'osv'.run_this()<cr>", desc = "this file" },
  })

end

return M
