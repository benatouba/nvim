local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config("jsonls", {
  capabilities = capabilities,
  root_markers = { "package.json", "init.lua", "pyproject.toml", ".git" },
  workspace_required = true,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})
