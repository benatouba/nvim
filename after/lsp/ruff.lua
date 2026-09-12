return {
  on_init = function(client)
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.definitionProvider = false
  end,
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "ruff.toml",
    ".ruff.toml",
    ".git",
  },
}
