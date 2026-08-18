{ pkgs, ... }:
{
  packages = with pkgs; [
    editorconfig-checker
    stylua
    vscode-json-languageserver
  ];
  languages = {
    lua = {
      enable = true;
      package = pkgs.lua5_2;
      lsp = {
        enable = true;
        package = pkgs.lua-language-server;
      };
    };
  };
  enterShell = ''
    echo "Tooling versions:"
    echo "  editorconfig-checker: $(editorconfig-checker --version)"
    echo "  lua-language-server: $(lua-language-server --version)"
    echo "  stylua: $(stylua --version)"
  '';
}
