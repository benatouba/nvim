# Provisioning: NixOS vs Mason

Fresh-machine behavior for editor tools across platforms.

## NixOS (`vim.g.is_nixos`)

Mason specs (`mason-lspconfig`, `mason-nvim-dap`, `mason-tool-installer`)
are disabled. Language intelligence resolves through:

1. `vim.lsp.enable()` over the shared list in `lua/lsp/servers.lua`,
   with binaries from the Nix system profile or project environments.
2. Node-based servers prefer project pins via `lua/lsp/resolve.lua`:
   `node_modules/.bin` → `.devenv/profile/bin` → `$PATH`.
3. Formatters and linters resolve from `$PATH` (system profile, devenv,
   project virtualenvs).

## Other Linux

Mason provisions with no manual steps after first file interaction:

- Servers: `mason-lspconfig` installs `lua/lsp/servers.lua` and enables them.
- Debug adapters: `mason-nvim-dap` installs `js-debug-adapter`, the only
  adapter this config consumes.
- Editor-level formatter/linter binaries: `mason-tool-installer` installs
  the list in its spec (stylua, codespell, jq, yamlfmt, markdownlint,
  markdownlint-cli2, latexindent, typstyle, djlint, proselint, commitlint,
  editorconfig-checker, air, statix, nixfmt).

## Project-owned tools (never Mason-managed)

- Python (`ruff` and friends): owned by uv per project (see issue #4).
  Ruff is excluded from Mason so a Mason copy can never shadow it.
- Node tools (`oxfmt` and friends): resolved from `node_modules/.bin`
  before `$PATH` (see `lua/lsp/resolve.lua` and conform's oxfmt definition).
- Not in the Mason registry, install from the system instead:
  `markdownfmt`, `commitmsgfmt`.
