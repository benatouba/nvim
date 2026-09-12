# Fallback for machines without devenv; keep the package list in sync with devenv.nix.
{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    commitlint
    editorconfig-checker
    lua-language-server
    stylua
  ];
}
