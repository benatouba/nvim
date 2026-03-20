return {
  cmd = { "nil" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", "shell.nix", "default.nix", ".git" },
  settings = {
    ["nil"] = {
      formatting = {
        command = { "nixfmt" },
      },
      nix = {
        flake = {
          autoArchive = false,
          autoEvalInputs = true,
        },
      },
    },
  },
}
