local M = {}

-- Buffer-local keymaps added on top of Neovim's own LSP defaults. Neovim 0.11+ already
-- provides K (hover), grn (rename), gra (code action), grr (references),
-- gri (implementation), grt (type definition), gO (document symbol), <C-s> (signature
-- help, insert mode), omnifunc, semantic tokens and the ]d/[d diagnostic motions.
local function add_keymaps(bufnr)
  local wk = require("which-key")
  -- `buffer` on the parent table is inherited by every child (a sibling entry would be ignored).
  wk.add({
    buffer = bufnr,
    { "<C-K>", vim.lsp.buf.signature_help, desc = "Signature", mode = { "n", "i" } },
    { "<F2>", vim.lsp.buf.rename, desc = "Rename" },
    { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
    { "<leader>lc", "<cmd>e $HOME/.config/nvim/lua/lsp/init.lua<cr>", desc = "Config" },
    { "<leader>lC", "<cmd>LspCapabilities<cr>", desc = "Server Capabilities" },
    { "<leader>lI", "<cmd>checkhealth vim.lsp<cr>", desc = "Health" },
    { "<leader>lD", "<cmd>Telescope lsp_declarations<cr>", desc = "Declarations" },
    { "<leader>lh", vim.lsp.buf.hover, desc = "Hover" },
    {
      "<leader>lF",
      function()
        vim.lsp.buf.format({ async = false })
      end,
      desc = "Format Document (Sync)",
    },
    { "<leader>li", "<cmd>LspConfig<cr>", desc = "Server Config" },
    { "<leader>ll", vim.lsp.codelens.run, desc = "CodeLens" },
    { "<leader>lL", "<cmd>LspLog<CR>", desc = "Logs", icon = { icon = " ", color = "green" } },
    { "<leader>lq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
    { "<leader>lr", "<cmd>LspRestart<cr>", desc = "Restart Server" },
    {
      "<leader>lR",
      function()
        vim.lsp.buf.code_action({ context = { only = { "refactor" } } })
      end,
      desc = "Refactor",
    },
    {
      "<leader>lH",
      function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end,
      desc = "Toggle Inlay Hints",
    },
    {
      "<leader>lv",
      function()
        vim.diagnostic.open_float(0, { scope = "line", border = "rounded", source = true })
      end,
      desc = "Line Diagnostics",
    },
    {
      "<leader>lw",
      function()
        vim.print(vim.lsp.buf.list_workspace_folders())
      end,
      desc = "Workspace",
    },
    { "<leader>lx", "<cmd>cclose<cr>", desc = "Close Quickfix" },
    { "<leader>s", group = "Search" },
    { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
    { "<leader>sD", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
    { "<leader>si", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
    { "<leader>sr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
    { "<leader>sS", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols (LSP)" },
    { "<leader>ss", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols (LSP)" },
    {
      mode = { "n", "x" },
      { "gD", vim.lsp.buf.declaration, desc = "Declaration" },
      { "gd", vim.lsp.buf.definition, desc = "Definition" },
      { "gI", vim.lsp.buf.implementation, desc = "Implementations" },
      { "gR", vim.lsp.buf.references, desc = "References" },
      { "gtd", vim.lsp.buf.type_definition, desc = "Type Definition" },
      { "gth", vim.lsp.buf.typehierarchy, desc = "Type Hierarchy" },
      { "gs", vim.lsp.buf.signature_help, desc = "Signature" },
    },
  })
end

M.setup = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("ben_lsp_attach", { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if not client then
        return
      end
      add_keymaps(event.buf)
      if client:supports_method("textDocument/inlayHint", event.buf) then
        vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
      end
    end,
  })
end

return M
