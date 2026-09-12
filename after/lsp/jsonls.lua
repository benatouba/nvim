local M = {
  cmd = require("lsp.resolve").rpc("vscode-json-language-server"),
  root_markers = { "package.json", "init.lua", "pyproject.toml", ".git" },
  workspace_required = true,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}
return M
