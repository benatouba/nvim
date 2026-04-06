return {
  cmd = { "nil" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", "shell.nix", "default.nix", ".git" },
  -- Disable completions — handled by nixd which has full nixpkgs awareness
  capabilities = {
    completionProvider = false,
  },
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
