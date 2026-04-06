local flake = "/home/ben/projects/flakes"

return {
  cmd = { "nixd" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", "shell.nix", "default.nix", ".git" },
  settings = {
    nixd = {
      nixpkgs = {
        -- Evaluate nixpkgs from the actual flake input for accurate package completions
        expr = ('import (builtins.getFlake "%s").inputs.nixpkgs { }'):format(flake),
      },
      formatting = {
        -- Delegate formatting to nil_ls; disable here to avoid conflicts
        command = nil,
      },
      options = {
        nixos = {
          expr = ('(builtins.getFlake "%s").nixosConfigurations.thinkpad.options'):format(flake),
        },
        home_manager = {
          expr = ('(builtins.getFlake "%s").nixosConfigurations.thinkpad.options.home-manager.users.type.functor.wrapped'):format(
            flake
          ),
        },
      },
    },
  },
}
