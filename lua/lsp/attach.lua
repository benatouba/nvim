local M = {}

local function patch_capabilities(client)
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
    client.server_capabilities.callHierarchyProvider = false
    client.server_capabilities.codeActionProvider = true
    client.server_capabilities.codeLensProvider = false
    client.server_capabilities.colorProvider = false
    client.server_capabilities.declarationProvider = true
    client.server_capabilities.definitionProvider = true
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentHighlightProvider = true
    client.server_capabilities.documentLinkProvider = false
    client.server_capabilities.documentOnTypeFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.documentSymbolProvider = true
    client.server_capabilities.foldingRangeProvider = false
    client.server_capabilities.hoverProvider = true
    client.server_capabilities.implementationProvider = false
    client.server_capabilities.referencesProvider = true
    client.server_capabilities.renameProvider = true
    -- client.server_capabilities.semanticTokensProvider = false
    client.server_capabilities.typeDefinitionProvider = true
    client.server_capabilities.typeHierarchyProvider = false
    client.server_capabilities.workspaceSymbolProvider = true
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
end

local function add_keymaps(event, bufnr)
  vim.keymap.set("i", "<C-Space>", "<cmd>lua vim.lsp.completion.trigger()<cr>")

  local isOk, wk = pcall(require, "which-key")
  if not isOk then
    vim.notify("which-key not okay in lspconfig")
    return
  end

  wk.add({
    {
      { buffer = bufnr },
      { "<C-K>", vim.lsp.buf.signature_help, desc = "Signature", mode = { "n", "i" } },
      { "<F2>", vim.lsp.buf.rename, desc = "Rename" },
      { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
      { "<leader>lc", "<cmd>e $HOME/.config/nvim/lua/lsp/init.lua<cr>", desc = "Config" },
      { "<leader>lC", "<cmd>LspCapabilities<cr>", desc = "Server Capabilities" },
      { "<leader>lI", "<cmd>checkhealth vim.lsp<cr>", desc = "Health" },
      { "<leader>lD", "<cmd>Telescope lsp_declarations<cr>", desc = "Declarations" },
      { "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },
      { "<leader>lF", "<cmd>lua vim.lsp.buf.format({ async = false })<CR>", desc = "Format Document (Sync)" },
      { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
      { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens" },
      { "<leader>lL", "<cmd>LspLog<CR>", desc = "Logs", icon = { icon = " ", color = "green" } },
      { "<leader>lq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
      { "<leader>lr", "<cmd>lsp restart<cr>", desc = "Restart Server" },
      {
        "<leader>lR",
        "<cmd>lua vim.lsp.buf.code_action({context = {only = {'refactor'}}})<cr>",
        desc = "Refactor",
      },
      {
        "<leader>lv",
        function()
          vim.diagnostic.open_float(0, { scope = "line", border = "rounded", source = true })
        end,
        desc = "Line Diagnostics",
      },
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
end

local function add_document_highlight(event, client)
  if not client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
    return
  end

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

M.setup = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
      local bufnr = vim.api.nvim_get_current_buf()
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client then
        vim.notify("LSP client not found for bufnr: " .. bufnr, vim.log.levels.ERROR)
        return
      end

      if client.server_capabilities.completionProvider then
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
      end

      patch_capabilities(client)

      if client.server_capabilities.semanticTokensProvider then
        vim.lsp.semantic_tokens.enable(true, { bufnr = event.buf })
      end

      add_keymaps(event, bufnr)
      vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
      add_document_highlight(event, client)
    end,
  })
end

return M
