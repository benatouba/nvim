local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local function resolve_cmd(root_dir, bin)
  while root_dir and root_dir ~= "/" do
    local local_cmd = root_dir .. "/node_modules/.bin/" .. bin
    if vim.fn.executable(local_cmd) == 1 then
      return { local_cmd, "--stdio" }
    end
    local devenv_cmd = root_dir .. "/.devenv/profile/bin/" .. bin
    if vim.fn.executable(devenv_cmd) == 1 then
      return { devenv_cmd, "--stdio" }
    end
    root_dir = vim.fn.fnamemodify(root_dir, ":h")
  end
  if vim.fn.executable(bin) == 1 then
    return { bin, "--stdio" }
  end
end

local M = {
  cmd = function(dispatchers, config)
    local resolved = resolve_cmd((config or {}).root_dir, "vscode-json-language-server")
      or { "vscode-json-language-server", "--stdio" }
    return vim.lsp.rpc.start(resolved, dispatchers)
  end,
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
