{ pkgs, ... }:
{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    nixd
    nil
    lua-language-server
    stylua
    editorconfig-checker
  ];
  enterShell = ''
    git --version # Use packages
  '';
}
