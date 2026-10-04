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

## LSP UI (core workflow)

Native LSP is the default; lspsaga is kept for its selector, finder,
outline, peek, and jumps; Trouble owns aggregated lists and the Telescope
bridge; Noice owns messages and history; nvim-lint owns non-LSP linters.

| Layer | Owner | Entry |
| --- | --- | --- |
| Code actions (apply) | native LSP | `<leader>la`, builtin `gra` |
| Action selector (choosing UI) | lspsaga | `ga` |
| Definitions (jump) | native LSP | `gd`, `gD` declaration |
| Finder (combined def+ref view) | lspsaga | `gF` |
| References (jump) | native LSP | `gR`, builtin `grr` |
| Implementations (lookup) | native LSP | `gI` buffer-local; builtin `gri` stays as Neovim fallback |
| Type definitions | native LSP | `gtd`, builtin `grt` |
| Symbols pickers | Telescope (bridge into Trouble via `<c-t>`) | `<leader>sr/si/ss/sS/sd/sD` |
| Outline (symbol tree) | lspsaga | `go` |
| Definitions peek | lspsaga | `gp` |
| Diagnostic jumps | lspsaga | `]d`/`[d` (global; shadows the Neovim defaults) |
| Diagnostics lists | Trouble | `:Trouble`, `]D`/`[D` next/prev item |
| Line diagnostics, hover | native LSP (rendered via Noice) | `<leader>lv`, `K` / `<leader>lh` |
| Messages and history | Noice | `<leader>sN` (`:Noice`), `<leader>sn` |
| Non-LSP linters | nvim-lint | per-filetype table; namespaced commitlint config |

Resolved overlaps (one winner each, no conflicting duplicate mapping):

- Diagnostic jumps: lspsaga wins. Its global `]d`/`[d` shadows Neovim's
  defaults and `lua/lsp/attach.lua` adds no buffer-local rival.
- Implementation lookup: native `gI` wins. Saga's `finder imp` on the same
  key never ran (buffer-local beats global) and was removed; the builtin
  `gri` remains only as an unconfigured Neovim fallback under the same
  native owner.
- Definitions: native `gd` wins. Saga's `<leader>ld` goto_definition was a
  second definition tool outside the kept surface and was removed.

`ga` and `<leader>la` invoke the same code-action method through different
keys and UIs (selector vs default apply); neither shadows the other.

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
