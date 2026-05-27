# AGENTS.md

## Repo Shape
- This is a personal Neovim config, not an app or Lua package; `init.lua` is the real entrypoint.
- Startup order is `user-defaults` -> `utils.globals` -> `utils` -> `config.keymaps` -> root `user-settings.lua` -> `config.options` -> `config.lazy` -> `config.autocmds` -> `colorscheme` -> `utils.after` -> optional `config.neovide` -> `require("lsp").enable_nixos()`; the VS Code path skips only `config.lazy`.
- `lua/user-defaults.lua` creates global `O`; root `user-settings.lua` flips feature flags. Most plugin specs use `enabled = O.*`, so check those flags before assuming a plugin should load.
- `lua/config/` owns startup-facing modules; `lua/settings.lua`, `lua/keymappings.lua`, and `lua/plugins/init.lua` are compatibility shims or legacy module names.
- lazy.nvim is bootstrapped and wired in `lua/config/lazy.lua`; plugin specs are split across focused `lua/plugins/*.lua` buckets, with detailed setup modules under `lua/ben/`, `lua/lsp/`, `lua/git/`, `lua/debug/`, `lua/test/`, `lua/misc/`, `lua/ui/`, and `lua/language_parsing/`.
- Base keymaps are still in `lua/keymappings.lua` via `config.keymaps`; which-key groups and many leader maps are in `lua/plugins/editor.lua`; LSP maps are registered on `LspAttach` in `lua/lsp/attach.lua`.

## LSP And Nix
- Root `lsp/*.lua` and `after/lsp/*.lua` files are native `vim.lsp.config()` runtime configs, not lazy.nvim specs; use `after/lsp/` for local overrides that must win over nvim-lspconfig defaults.
- `vtsls` and `vue_ls` runtime overrides live in `after/lsp/` and use `lua/lsp/vue.lua` helpers to derive Nix/Mason paths dynamically; never hard-code `/nix/store/...` paths because they change after NixOS rebuilds.
- `lua/lsp/init.lua` is only the LSP orchestrator; diagnostics signs, commands, attach keymaps, NixOS enablement, and watchman live in sibling `lua/lsp/*.lua` modules.
- `O.is_nixos` is detected from `/etc/NIXOS`; on NixOS Mason LSP/DAP install helpers are disabled and `require("lsp").enable_nixos()` enables the native server list with `vim.lsp.enable()`.
- Non-Nix paths still assume Mason-installed packages for some LSP integration; Nix paths are derived from executables in `$PATH`.

## Commands
- Tooling comes from `devenv shell` via `.envrc`/direnv, or fallback `nix-shell`; current Nix configs provide `lua-language-server` and `stylua` (`shell.nix` also has `selene`).
- Smoke-test startup with `nvim --headless -u init.lua +qa`.
- Format/check only touched Lua files with `stylua <paths>` or `stylua --check <paths>`; full `stylua --check .` is not a clean baseline in this checkout.
- There is no repo-level test runner; neotest is configured as an editor plugin when `O.test = true`, with test keymaps in `lua/plugins/test.lua`.
- Treat `lazy-lock.json` as lazy.nvim-managed state; prefer in-Neovim `:Lazy sync`/`:Lazy restore` over hand-editing lock entries.

## Commit Notes
- `commitlint.config.js` and `.gitlint` enforce conventional commit titles. Allowed types are `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style`, and `test`.
- Commit headers must be 100 chars or less, type must be lowercase, subjects must not end with `.`, and sentence/start/pascal/upper-case subjects are rejected.
