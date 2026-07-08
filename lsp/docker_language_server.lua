return {
  cmd = function(dispatchers, config)
    local binary = config
      and config.root_dir
      and vim.fs.joinpath(config.root_dir, ".devenv", "profile", "bin", "docker-language-server")
    local cmd = binary and vim.uv.fs_stat(binary) and { binary, "start", "--stdio" }
      or { "docker-language-server", "start", "--stdio" }
    return vim.lsp.rpc.start(cmd, dispatchers)
  end,
  filetypes = { "dockerfile", "yaml.docker-compose" },
  root_markers = {
    "Dockerfile",
    { "docker-compose.yaml", "docker-compose.yml", "compose.yaml", "compose.yml" },
    "docker-bake.hcl",
    "docker-bake.override.hcl",
  },
  settings = {
    docker = {
      languageserver = {
        formatter = {
          ignoreMultilineInstructions = true,
        },
      },
    },
  },
}
