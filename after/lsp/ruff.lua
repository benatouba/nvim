return {
  on_init = function(client)
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.definitionProvider = false
  end,
  cmd = require("util.python").rpc("ruff"),
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "ruff.toml",
    ".ruff.toml",
    ".git",
  },
}
