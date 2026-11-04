# Provisioning: NixOS vs Mason

Fresh-machine behavior for editor tools across platforms.

## NixOS (`vim.g.is_nixos`)

Mason specs (`mason-lspconfig`, `mason-nvim-dap`, `mason-tool-installer`)
are disabled. Language intelligence resolves through:

1. `vim.lsp.enable()` over the shared list in `lua/lsp/servers.lua`,
   with binaries from the Nix system profile or project environments.
2. Node-based servers prefer project pins via `lua/lsp/resolve.lua`:
   `node_modules/.bin` → `.devenv/profile/bin` → `$PATH`.
3. Ruff and ty resolve per project at launch: ancestor `.venv/bin` →
   `.devenv/profile/bin` → non-Mason `$PATH`. Conform uses the same resolver
   for all three Ruff steps, salt-lint, yamllint and yamlfmt. Other
   formatters/linters use `$PATH`.

## Other Linux

Mason provisions with no manual steps after first file interaction:

- Servers: `mason-lspconfig` installs and enables the editor-owned subset
  derived from `lua/lsp/servers.lua`. Ruff and ty are enabled directly;
  previously installed Mason servers outside that subset are not auto-enabled.
  After the first install, reopen buffers so newly installed servers attach.
- Debug adapters: `mason-nvim-dap` installs the `js` adapter (package
  `js-debug-adapter`), the only adapter this config consumes.
- Editor-level formatter/linter binaries: `mason-tool-installer` installs
   the list in its spec (stylua, jq, markdownlint,
  markdownlint-cli2, latexindent, typstyle, djlint, proselint, commitlint,
  editorconfig-checker, air, statix, nixfmt).

## Project-owned tools (never Mason-managed)

- Salt (`salt-lint`, `yamllint`, `yamlfmt`): provided by the Salt checkout's
  `devenv.nix`, not installed globally. Enter `devenv shell` once to build its
  `.devenv/profile`; tools then resolve from that profile even outside the shell.
  SLS buffers use the canonical `salt` filetype and salt-lint; plain YAML uses yamllint and
  manual yamlfmt. SLS formatting and codespell are disabled.
  Salt snippets start with `s` (e.g. `spkg`, `sfile`, `ssvc`, `smap`).
  In the Salt checkout, `<leader>Or` offers lint, fixture render/compile,
  behavioral tests and the existing isolated VM integration test. File lint
  tasks require saved buffers. Render/compile tasks deliberately accept only
  the allowlisted synthetic fixture, not arbitrary production states: Salt
  renderers execute code, and `test=True` is not isolation. The experimental
  sibling salt-lsp checkout is not automatically installed or enabled.

  Syntax, detection and basic buffer defaults come from `benatouba/salt-vim`.
  It currently runs eagerly as a lazy.nvim development plugin from
  `~/projects/salt-vim` (the sibling checkout), because the continuation is
  not yet pushed. Clone that checkout before starting Neovim; this is not yet
  a portable remote-only install. Local policy retains safe indentation and
  folding, snippets, lint/task integration and formatting protection; legacy
  `sls` tooling aliases remain supported.
- Python (`ruff`, `ty`): owned by uv per project (e.g. `uv add --dev ruff ty`
  followed by `uv sync`). Both are excluded from Mason provisioning, and
  the shared executable resolver ignores old Mason installations on PATH.
- Node tools (`oxfmt` and friends): resolved from `node_modules/.bin`
  before `$PATH` (see `lua/lsp/resolve.lua` and conform's oxfmt definition).
- Not in the Mason registry, install from the system instead:
  `markdownfmt`, `commitmsgfmt`.

## Project tasks

Project-task commands use their project environment rather than provisioning
another global toolchain; see [Project tasks](tasks.md). Discovering commands is
separate from choosing an install/build/check task.

## Notebook runtime

Restoring plugins does not install Jupynium's Python/browser runtime. The old
build hook required a pre-existing home virtualenv and treated `user` as a
package name. Provision the locked checkout explicitly, e.g.
`uv venv ~/.virtualenvs/jupynium && uv pip install --python ~/.virtualenvs/jupynium/bin/python <locked-jupynium-checkout>`
(adjust for XDG paths), plus a supported browser and Jupyter environment
before using notebook sync.
