{ pkgs, ... }:
{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    nixd
    nil
    lua-language-server
    stylua
  ];
  enterShell = ''
    git --version # Use packages
  '';
}
