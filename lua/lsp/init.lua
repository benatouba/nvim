local M = {}

M.config = function()
  vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }

  -- Enable inlay hints
  -- vim.api.nvim_create_autocmd("LspAttach", {
  --   desc = "Enable inlay hints",
  --   callback = function (event)
  --     local id = vim.tbl_get(event, "data", "client_id")
  --     local client = id and vim.lsp.get_client_by_id(id)
  --     if client == nil or not client:supports_method("textDocument/inlayHint") then
  --       return
  --     end
  --
  --     vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
  --   end,
  -- })

  -- LSP signs default
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "✘",
        [vim.diagnostic.severity.WARN] = "▲",
        [vim.diagnostic.severity.HINT] = "⚑",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
  })

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

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end
      vim.lsp.semantic_tokens.enable()
      local bufnr = vim.api.nvim_get_current_buf()
      local isOk, wk = pcall(require, "which-key")
      if not isOk then
        vim.notify("which-key not okay in lspconfig")
        return
      end
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client then
        vim.notify("LSP client not found for bufnr: " .. bufnr, vim.log.levels.ERROR)
        return
      end
      if client.server_capabilities.completionProvider then
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
      end
      if client.name == "basedpyright" then
        client.server_capabilities.declarationProvider = true
        client.server_capabilities.definitionProvider = true
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        client.server_capabilities.hoverProvider = true
        client.server_capabilities.referencesProvider = true
        client.server_capabilities.renameProvider = false
      -- elseif client.name == "texlab" then
      --   -- Disable in favour of Conform
      --   client.server_capabilities.documentFormattingProvider = true
      --   client.server_capabilities.documentRangeFormattingProvider = true
      elseif client.name == "ty" then
        client.server_capabilities.declarationProvider = true
        client.server_capabilities.definitionProvider = true
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentHighlightProvider = true
        client.server_capabilities.documentRangeFormattingProvider = false
        client.server_capabilities.hoverProvider = true
        client.server_capabilities.referencesProvider = true
        client.server_capabilities.renameProvider = true
        client.server_capabilities.semanticTokensProvider = false
      elseif client.name == "mutt_ls" then
        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
      elseif client.name == "ruff" then
        -- Disable hover in favour of pyright
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.definitionProvider = false
      elseif client.name == "r_language_server" then
        client.server_capabilities.completionProvider = false
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      elseif client.name == "ts_ls" then
        --   client.server_capabilities.documentFormattingProvider = false
        --   client.server_capabilities.documentRangeFormattingProvider = false
        --   client.server_capabilities.documentHighlightProvider = true
        client.server_capabilities.semanticTokensProvider = false
      elseif client.name == "vue_ls" then
        --   client.server_capabilities.documentHighlightProvider = true
        client.server_capabilities.semanticTokensProvider = false
      --   client.server_capabilities.documentFormattingProvider = true
      --   client.server_capabilities.documentRangeFormattingProvider = false
      --   client.server_capabilities.definitionProvider = false
      elseif client.name == "cssmodules_ls" then
        client.server_capabilities.definitionProvider = true
      end
      vim.keymap.set("i", "<C-Space>", "<cmd>lua vim.lsp.completion.trigger()<cr>")
      wk.add({
        {
          { buffer = bufnr },
          { "<C-K>", vim.lsp.buf.signature_help, desc = "Signature", mode = { "n", "i" } },
          { "<F2>", vim.lsp.buf.rename, desc = "Rename" },
          { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
          { "<leader>lc", "<cmd>e $HOME/.config/nvim/lua/lsp/init.lua<cr>", desc = "Config" },
          { "<leader>lC", "<cmd>LspCapabilities<cr>", desc = "Server Capabilities" },
          { "<leader>lD", "<cmd>Telescope lsp_declarations<cr>", desc = "Declarations" },
          { "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },
          { "<leader>lF", "<cmd>lua vim.lsp.buf.format({ async = false })<CR>", desc = "Format Document (Sync)" },
          { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
          { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens" },
          { "<leader>lL", "<cmd>LspLog<CR>", desc = "Logs", icon = { icon = " ", color = "green" } },
          { "<leader>lq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
          { "<leader>lr", "<cmd>LspRestart<cr>", desc = "Restart Server" },
          {
            "<leader>lR",
            "<cmd>lua vim.lsp.buf.code_action({context = {only = {'refactor'}}})<cr>",
            desc = "Refactor",
          },
          { "<leader>lv", "<cmd>lua vim.lsp.diagnostic.get_line_diagnostics()<CR>", desc = "Virtual Text" },
          { "<leader>lw", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", desc = "Workspace" },
          { "<leader>lx", "<cmd>cclose<cr>", desc = "Close Quickfix" },
          { "<leader>s", group = "Search" },
          { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
          { "<leader>sD", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
          { "<leader>si", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
          { "<leader>sr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
          { "<leader>sS", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols (LSP)" },
          { "<leader>ss", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols (LSP)" },
          { "K", vim.lsp.buf.hover, desc = "Hover" },
          -- f = { "<cmd>lua vim.lsp.buf.format()<CR>", "Format Document" }, covered by conform.nvim
          -- with lsp_fallback
          {
            mode = { "n", "x", "v" },
            { "gD", vim.lsp.buf.declaration, desc = "Declaration" },
            { "gd", vim.lsp.buf.definition, desc = "Definition" },
            { "gI", vim.lsp.buf.implementation, desc = "Implementations" },
            { "gO", vim.lsp.buf.document_symbol, desc = "Document Symbols" },
            { "gR", vim.lsp.buf.references, desc = "References" },
            { "grr", vim.lsp.buf.references, desc = "References" },
            { "grn", vim.lsp.buf.rename, desc = "Rename" },
            { "gra", vim.lsp.buf.code_action, desc = "Code Action" },
            { "gri", vim.lsp.buf.implementation, desc = "Implementations" },
            { "gtd", vim.lsp.buf.type_definition, desc = "Type Definition" },
            { "gth", vim.lsp.buf.typehierarchy, desc = "Type Hierarchy" },
            { "gs", vim.lsp.buf.signature_help, desc = "Signature" },
          },
        },
      })
      vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        local highlight_group = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          group = highlight_group,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          group = highlight_group,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })

  local watch_type = require("vim._watch").FileChangeType

  local function handler(res, callback)
    if not res.files or res.is_fresh_instance then
      return
    end

    for _, file in ipairs(res.files) do
      local path = res.root .. "/" .. file.name
      local change = watch_type.Changed
      if file.new then
        change = watch_type.Created
      end
      if not file.exists then
        change = watch_type.Deleted
      end
      callback(path, change)
    end
  end

  local function watchman(path, opts, callback)
    vim.system({ "watchman", "watch", path }):wait()

    local buf = {}
    local sub = vim.system({
      "watchman",
      "-j",
      "--server-encoding=json",
      "-p",
    }, {
      stdin = vim.json.encode({
        "subscribe",
        path,
        "nvim:" .. path,
        {
          expression = { "anyof", { "type", "f" }, { "type", "d" } },
          fields = { "name", "exists", "new" },
        },
      }),
      stdout = function(_, data)
        if not data then
          return
        end
        for line in vim.gsplit(data, "\n", { plain = true, trimempty = true }) do
          table.insert(buf, line)
          if line == "}" then
            local res = vim.json.decode(table.concat(buf))
            handler(res, callback)
            buf = {}
          end
        end
      end,
      text = true,
    })

    return function()
      sub:kill("sigint")
    end
  end

  if vim.fn.executable("watchman") == 1 then
    require("vim.lsp._watchfiles")._watchfunc = watchman
  end
  vim.lsp.enable({ "codebook", "vtsls", "vue_ls" }) -- If using `ts_ls` replace `vtsls` to `ts_ls`
end
return M
