# Neovim configuration

A personal [Neovim](https://neovim.io) setup, written in Lua, managed with
[lazy.nvim](https://github.com/folke/lazy.nvim). Targets Neovim 0.11+ (developed on
nightly) and relies on the editor's native LSP, treesitter and folding APIs wherever they
exist instead of plugins.

## Layout

```
init.lua                    options -> lazy.nvim -> keymaps -> autocmds
lua/config/
  options.lua               editor options (vim.o), vim.g.is_nixos, leader keys
  keymaps.lua               keymaps that belong to no plugin
  autocmds.lua              filetype detection rules and general autocommands
  lazy.lua                  lazy.nvim bootstrap and setup()
lua/plugins/<area>.lua      plugin specs, one file per area (editor, ui, lsp, git, ...)
lua/plugins/configs/        the few plugin configs too large to inline (blink, lualine, ...)
lua/lsp/                    LSP core: attach keymaps, diagnostics, commands, server list
after/lsp/<server>.lua      per-server settings (native vim.lsp.config discovery)
after/ftplugin/, ftdetect/, snippets/, spell/, syntax/   runtime files
```

Every plugin spec is self-contained: its options (`opts`), its lazy-loading trigger
(`event`/`cmd`/`ft`/`keys`) and its keymaps live together. `lazy.setup()` runs with
`defaults.lazy = true`; the only start plugins are the colorscheme, snacks.nvim and
nvim-lspconfig (with blink.cmp).

## Setup

```sh
git clone <this repo> ~/.config/nvim
nvim            # lazy.nvim bootstraps itself and installs plugins on first start
```

Tools (language servers, formatters, linters, debug adapters) come from the system:

- **NixOS** (`/etc/NIXOS` present, `vim.g.is_nixos`): everything is expected from Nix /
  `$PATH`; the server list in `lua/lsp/servers.lua` is enabled directly.
- **Elsewhere**: mason.nvim + mason-lspconfig install the same server list.

Project-local node servers (`node_modules/.bin`, devenv profiles) are preferred over global
ones, see `lua/lsp/resolve.lua`.

Working on this repository itself: `devenv shell` (or `nix-shell`) provides
`lua-language-server`, `stylua`, `editorconfig-checker` and `commitlint`. Check formatting
with `stylua --check lua after init.lua`; smoke-test startup with
`nvim --headless -u init.lua +qa`.

## Keys

`<Space>` is the leader, `\` the local leader. Press `<Space>` and wait: which-key lists
every group. The group names are declared in `lua/plugins/editor.lua` (which-key spec);
the mappings themselves sit in each plugin's `keys`.

| Prefix | Area |
|---|---|
| `<leader>s` | search / pickers (telescope, snacks) |
| `<leader>l` | LSP (native `grn`/`gra`/`grr`/`gri`/`K` also apply) |
| `<leader>g` | git (gitsigns, neogit, diffview, octo) |
| `<leader>d` | debugging (nvim-dap) |
| `<leader>t` | tests (neotest) |
| `<leader>T` | terminals (toggleterm) |
| `<leader>r` | REPL (iron) |
| `<leader>m` | harpoon marks |
| `<leader>M` | live coding (SuperCollider, Tidal, Sonic Pi) |
| `<leader>o` | notes (obsidian, orgmode) |
| `<leader>p` | plugin manager |
| `<leader>e` | file explorer (oil) |

Completion (blink.cmp): `<C-n>`/`<C-p>` move, `<C-l>` or `<C-y>` accept, `<Tab>`/`<S-Tab>`
jump between snippet placeholders. Copilot ghost text: `<C-a>` word, `<C-s>` line, `<C-d>`
all.

## Commits

Conventional Commits with an emoji, enforced by commitlint and gitlint:
`type(scope): <emoji> description`, header at most 100 characters.
