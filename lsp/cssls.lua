local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Prefer a server from the project itself (devenv profile or node_modules) so
-- each project pins its own version, falling back to whatever is on PATH.
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

-- Tailwind v4 keeps its configuration in CSS (@theme, @source, @utility,
-- @custom-variant, @apply, @plugin), none of which the vscode CSS server
-- knows. Left at the default "warning" every such file is a wall of
-- "Unknown at rule" diagnostics, which drowns out the real ones.
local lint = { unknownAtRules = "ignore" }

local M = {
  capabilities = capabilities,
  cmd = function(dispatchers, config)
    local resolved = resolve_cmd((config or {}).root_dir, "vscode-css-language-server")
      or { "vscode-css-language-server", "--stdio" }
    return vim.lsp.rpc.start(resolved, dispatchers)
  end,
  filetypes = { "css", "scss", "less" },
  -- style blocks inside .vue files stay with vue_ls/vtsls
  root_markers = { "package.json", ".git" },
  settings = {
    css = { lint = lint, validate = true },
    less = { lint = lint, validate = true },
    scss = { lint = lint, validate = true },
  },
}

return M
