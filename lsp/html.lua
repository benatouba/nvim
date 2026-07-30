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

local M = {
  capabilities = capabilities,
  cmd = function(dispatchers, config)
    local resolved = resolve_cmd((config or {}).root_dir, "vscode-html-language-server")
      or { "vscode-html-language-server", "--stdio" }
    return vim.lsp.rpc.start(resolved, dispatchers)
  end,
  -- xhtml is shared with lemminx: this server brings the HTML5 element and
  -- attribute knowledge plus embedded CSS/JS, lemminx brings the XML side.
  filetypes = { "html", "xhtml" },
  init_options = {
    -- Formatting is oxfmt's job on html and lemminx's on xhtml. Left on, both
    -- servers would rewrite the same xhtml buffer, since conform's LSP
    -- fallback runs every attached client that advertises formatting.
    provideFormatter = false,
  },
  root_markers = { "package.json", ".git" },
}

return M
