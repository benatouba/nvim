local M = {}

M.setup = function()
  vim.api.nvim_create_user_command("LspConfig", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    local attached = {}
    for _, c in ipairs(clients) do
      attached[c.name] = (attached[c.name] or 0) + 1
    end

    local configs = vim.lsp.get_configs({ enabled = nil }) or {}
    local lines = { "# LSP Server Status", "" }
    local count = 0

    for _, config in ipairs(configs) do
      local name = config and config.name or "?"
      local status = "  "
      if vim.lsp.is_enabled(name) then
        status = " ✓"
      end
      local n = attached[name] or 0
      local info = string.format("%s %s%s", status, name, n > 0 and ("  (" .. n .. " attached)") or "")
      lines[#lines + 1] = info
      count = count + 1
    end

    if count == 0 then
      lines[#lines + 1] = "(no LSP configs found)"
    else
      lines[#lines + 1] = ""
      lines[#lines + 1] = string.format("✓ enabled   (no mark) = available   Total: %d servers", count)
    end

    vim.notify(table.concat(lines, "\n"), "trace", {
      on_open = function(win)
        local buf = vim.api.nvim_win_get_buf(win)
        vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
      end,
      timeout = 15000,
    })
  end, { desc = "List configured LSP servers and their status" })

  vim.api.nvim_create_user_command("LspCapabilities", function()
    local curBuf = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = curBuf })

    for _, client in pairs(clients) do
      if client.name ~= "null-ls" then
        local capAsList = {}
        for key, value in pairs(client.server_capabilities) do
          if value and key:find("Provider") then
            local capability = key:gsub("Provider$", "")
            table.insert(capAsList, "- " .. capability)
          end
        end
        table.sort(capAsList) -- sorts alphabetically
        local msg = "# " .. client.name .. "\n" .. table.concat(capAsList, "\n")
        vim.notify(msg, "trace", {
          on_open = function(win)
            local buf = vim.api.nvim_win_get_buf(win)
            vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
          end,
          timeout = 14000,
        })
        vim.fn.setreg("+", "Capabilities = " .. vim.inspect(client.server_capabilities))
      end
    end
  end, {})
end

return M
