# Ownership: Git, execution, documents, Nix

One owner per layer. Reach each owner from its keymap or command; do not add a
second tool for an owned layer without reopening the owning ticket.

## Git (core workflow)

| Layer | Owner | Entry |
| --- | --- | --- |
| Hunks, blame, stage | gitsigns | `<leader>gj`/`<leader>gk` next/prev hunk, `<leader>gs` stage |
| Status and commit | Neogit | `<leader>gn` status, `<leader>gc` commit |
| History and diffs | diffview | `<leader>gd` toggle, `<leader>gf` file history |
| Review (GitHub) | Octo | `<leader>go` PR list, `<leader>gi` issue list |
| Fallback terminal client | LazyGit via toggleterm | `<leader>gL` |

## Execution

| Context | Owner | Entry |
| --- | --- | --- |
| Terminal (core) | toggleterm | `<leader>TT` float, `<leader>Tt` tab, `<leader>Tv` vertical |
| REPL (core) | iron | `<leader>rs` open, `<leader>rl` send line, `<leader>rc` send |
| Task (core) | overseer | `<leader>Ot` toggle, `<leader>Or` run |
| Notebook (specialist) | jupynium | `:JupyniumStartAndAttachToServer` (Python files) |
| R (specialist) | R.nvim | R and Rmd files (auto-starts console) |
| Live-coding (specialist) | scnvim / tidal / sonicpi + Dirt/Tidal boots | `<leader>M*`, `:DirtBoot`, `:TidalBoot` |

REPL evaluation belongs to iron even when the terminal underneath is toggleterm's.

## Documents (specialist workflows)

| Layer | Owner | Entry |
| --- | --- | --- |
| LaTeX build and preview | VimTeX | `<localleader>l*` (compile, view, toc) |
| LaTeX intelligence | texlab | hover, diagnostics, chktex; build and forward search on save stay off |
| Typst preview | typst-preview | `<localleader>tt` toggle (Tinymist + websocat binaries) |
| Typst intelligence and export | Tinymist | hover, diagnostics, PDF export on type |
| Markdown preview | live-preview | `:LivePreview` (manual only) |

VimTeX never shares builds with texlab; typst-preview never shares previews
with another Typst viewer.

## Nix

Single server: nixd (completion with full nixpkgs awareness, NixOS and
Home Manager options). Formatting is owned by Conform (`nixfmt`), never by a
server. `statix` (nvim-lint) reports diagnostics only.
