return {
  cmd = { "nil" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", "shell.nix", "default.nix", ".git" },
  -- Completions come from nixd, which has full nixpkgs awareness.
  on_init = function(client)
    client.server_capabilities.completionProvider = false
  end,
  settings = {
    ["nil"] = {
      formatting = {
        command = { "nixfmt-rfc-style" },
      },
      nix = {
        flake = {
          autoArchive = false,
          autoEvalInputs = false,
        },
      },
    },
  },
}
