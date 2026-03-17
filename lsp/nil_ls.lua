return {
  cmd = { "nil" },
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
