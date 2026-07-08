local M = {}

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
      { "<leader>li", "<cmd>LspConfig<cr>", desc = "Server Config" },
      { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens" },
      { "<leader>lL", "<cmd>LspLog<CR>", desc = "Logs", icon = { icon = " ", color = "green" } },
      { "<leader>lq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
      { "<leader>lr", "<cmd>LspRestart<cr>", desc = "Restart Server" },
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

M.setup = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
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

      -- Deferred so config.on_attach callbacks (which fire after LspAttach)
      -- can modify server_capabilities before we act on them.
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end
        local c = vim.lsp.get_client_by_id(client.id)
        if c and c.server_capabilities.semanticTokensProvider then
          vim.lsp.semantic_tokens.enable(true, { bufnr = bufnr })
        end
      end)

      add_keymaps(event, bufnr)
      vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
  })
end

return M
