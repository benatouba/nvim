# AGENTS.md

## Repo Shape
- Personal Neovim config, not an app or Lua package; `init.lua` is the real entrypoint and is
  six lines: `config.options` -> `config.lazy` (skipped inside VS Code) -> `config.keymaps` ->
  `config.autocmds` -> optional `config.neovide`.
- `lua/config/` owns startup-facing modules. There is no global feature-flag table any more:
  a plugin is on or off through `enabled =` on its spec, and `vim.g.is_nixos` (set in
  `config/options.lua`) is the only environment switch.
- lazy.nvim is bootstrapped in `lua/config/lazy.lua` with `spec = require("config.groups").spec()`
  and `defaults.lazy = true`. `lua/plugins/core/` is always loaded; every `lua/plugins/<name>.lua`
  is an optional group. All groups load unless `NVIM_GROUPS` or a `groups.local` file in the
  config dir lists the ones to keep (e.g. `git,lang`; empty means core only). Unselected groups
  are never imported or installed. Do not rely on `import = "plugins"`: lazy does not recurse
  into `core/`. Each spec carries
  its own `opts`, trigger (`event`/`cmd`/`ft`/`keys`) and keymaps. Configs too large to inline
  live in `lua/plugins/configs/<plugin>.lua` and are consumed through `opts = function()`.
- Optional groups extend core plugin `opts` for their integrations (completion sources,
  statusline components, picker/explorer actions). Keep core usable without any groups.
  `provisioning` owns automatic Mason installs, parser installs/updates and native build hooks;
  without it, existing tools/parsers still work and Telescope uses its Lua sorter.
- which-key group names are declared in the which-key spec in `lua/plugins/core/editor.lua`; do not
  put `group =` or rhs-less entries inside a lazy `keys` list (lazy turns them into bare load
  triggers).
- `lua/lsp/` is LSP core only (attach keymaps, diagnostics, commands, server list, binary
  resolver, vue helpers). It is invoked from the nvim-lspconfig spec's `config`.

## LSP And Nix
- Per-server settings are `after/lsp/<server>.lua` files in native `vim.lsp.config()` shape.
  `after/` (not `lsp/`) so they merge over nvim-lspconfig's defaults; there is no manual
  re-scan of that directory.
- `lua/lsp/servers.lua` holds the single server list: `vim.lsp.enable()` on NixOS,
  mason-lspconfig `ensure_installed` + `automatic_enable` elsewhere.
- Node-based servers resolve their binary through `lua/lsp/resolve.lua`
  (node_modules/.bin -> .devenv/profile/bin -> $PATH); never hard-code `/nix/store/...` paths.
- Neovim 0.11 defaults (`grn`, `gra`, `grr`, `gri`, `K`, `<C-s>`, omnifunc, semantic tokens)
  are relied on; `lua/lsp/attach.lua` only adds maps on top of them, buffer-locally.

## Commands
- Tooling comes from `devenv shell` via `.envrc`/direnv (fallback `nix-shell`): lua-language-server,
  stylua, editorconfig-checker, commitlint.
- Smoke-test startup with `nvim --headless -u init.lua +qa` (must be silent).
- Format/check Lua with `stylua --check lua after init.lua`.
- Check group selection and isolation with `nvim --headless -u NONE -l tests/groups.lua`
  (installed plugins required; uses temporary lockfiles and installs nothing).
- There is no repo-level test runner; neotest is an editor plugin with keys in `lua/plugins/test.lua`.
- Treat `lazy-lock.json` as lazy.nvim-managed state; use `:Lazy sync`/`:Lazy restore`.

## Commit Notes
- `commitlint.config.js` and `.gitlint` enforce conventional commit titles with an emoji after
  the colon. Allowed types: build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test.
- Headers at most 100 chars, lowercase type, subject must not end with `.`.

## Agent skills

### Issue tracker

Issues and specs live in GitHub Issues for `benatouba/nvim`. Before tracker operations, read `docs/agents/issue-tracker.md`.

### Triage labels

The five canonical triage roles use their default label names. Before applying triage labels, read `docs/agents/triage-labels.md`.

### Domain docs

Single-context: root `GLOSSARY.md` and `docs/adr/`. Before exploring the codebase, read `docs/agents/domain.md`.
