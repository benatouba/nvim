{ pkgs, ... }:
{
  packages = with pkgs; [
    editorconfig-checker
    lua-language-server
    stylua
  ];
  enterShell = ''
    echo "Tooling versions:"
    echo "  editorconfig-checker: $(editorconfig-checker --version)"
    echo "  lua-language-server: $(lua-language-server --version)"
    echo "  stylua: $(stylua --version)"
  '';
}
