# Overseer task workflow research

Research date: 2026-11-03. Investigation only; no tasks, evaluations, installations,
services, or configuration changes were performed. Local observations below were
verified by the parent investigation; upstream findings were independently checked
against primary documentation and source. Recommendations are proposals, not an ADR.

Subsequent implementation and shortcuts are documented in [Project tasks](tasks.md).

## Version and ownership

- Upstream's default branch is **`master`, not `main`**. Its checked head is
  [`a93d9f6d6defdac4bcd6d2c8ba988650e42e0a0e`][head] (2026-05-24).
  The parent verified that both [lazy-lock.json](../lazy-lock.json) and installed
  HEAD match it. Thus the built-ins described here are already installed, not an
  argument for upgrading.
- The [2.0 changelog][changelog] records removal of task bundles, the toggleterm
  and terminal strategies, and `OverseerQuickAction`; `run_template` became
  `run_task`. Use current source/reference, not older configuration snippets.
  The opening paragraph of [strategies documentation][strategies] still describes
  the removed terminal strategy; [task.lua][task] actually defaults to `jobstart`.
- [Ownership](ownership.md) assigns tasks to Overseer, terminals to toggleterm,
  REPLs to iron, and separate document workflows to their existing owners.
  Preserve these boundaries. Local [tools.lua](../lua/plugins/tools.lua) sets
  only `dap = false`, with `<leader>Or`/`<leader>Ot`; existing neotest configuration
  already has Python/Vitest adapters and the Overseer consumer (parent finding).
  Do not add another task runner or silently replace neotest's test UI.

## Built-ins versus missing adapters

The [upstream template directory][templates] contains `npm`, `devenv`, `just`,
`make`, and `vscode`; **no dedicated `uv`, Lua, or Nix-flake provider**. The parent
verified the same installed inventory. Current providers are discovered from the
runtimepath; current configuration exposes `disable_template_modules` and
`template_dirs`, not an old `templates = { "builtin", ... }` recipe.
See [configuration source][config] and [custom-template guide][guides].

| Workflow | Available behavior | Practical implication |
| --- | --- | --- |
| Vue / package.json | Built-in `npm` provider reads script names and invokes the selected manager's `run` command. | Reuse project scripts; Vue-specific command duplication is unnecessary. |
| devenv.nix | Built-in discovers **tasks**, using a shell environment variable. | Existing support needs compatibility scrutiny, not a duplicate generic provider. Scripts are a distinct missing surface. |
| justfile | Built-in structured JSON dump, public recipes, parameters, module handling. | Reuse after trust/allowlist review; not every recipe belongs in a default development picker. |
| Makefile | Built-in invokes make's database output and parses targets. | Discovery itself crosses an execution boundary. |
| Python uv | No dedicated provider. | Small explicit project-scoped templates or project-owned tasks are proposed. |
| Lua | No dedicated provider. | Prefer actual project check commands; do not assume every Lua file is executable outside Neovim. |
| Nix flake | No dedicated provider. | Prefer reviewed project check recipes or explicit non-activation templates. |

Provider details and limitations follow directly from the sources below; absence
of a provider is not absence of the ability to run that command as a custom task.

### package.json: npm, yarn, pnpm, bun

[npm.lua][npm] searches upward from the search directory to the working-directory
boundary, with a fallback upward search from cwd. It prefers candidate packages
with scripts/workspaces **and a lockfile**, otherwise the closest eligible package
with npm fallback. Lockfiles are `package-lock.json`, `pnpm-lock.yaml`, `yarn.lock`,
and `bun.lockb`/`bun.lock`. It checks the chosen binary is executable.

Important limits in that implementation:

- It does **not** inspect `packageManager`, validate versions, or invoke Corepack.
  Multiple lockfiles are ambiguous: manager iteration uses Lua `pairs`, with no
  specified preference policy.
- Workspace entries are treated as literal directories; there is no glob
  expansion or `pnpm-workspace.yaml` parsing. Nested candidate selection can
  favor a root lockfile over a leaf package's scripts. Do not promise complete
  monorepo discovery.
- Workspace glob/pnpm-workspace support was explicitly
  [reverted in January 2026][workspace-revert] because traversal could freeze the
  UI and discover packages under node_modules. Reintroducing broad recursive
  scanning would reopen a known problem.
- Listing reads JSON, rather than executing `npm run`; selecting a script still
  executes project-owned code. The provider also offers a manager `install` task;
  installation should not be the default check/build action.

**Recommendation:** retain this provider for ordinary Vue projects. If local
projects need better selection, narrowly add an explicit manager override and/or
validated `packageManager` policy; fail visibly on conflicting lockfiles instead
of choosing unpredictably. Do not infer that a pnpm workspace is fully covered.

### devenv: existing provider and a concrete compatibility problem

[devenv.lua][devenv-provider] finds the nearest `devenv.nix`, then **during
discovery** executes `devenv shell 'echo $DEVENV_TASKS'`, decodes stdout as a JSON
array, and builds `devenv tasks run <name>` tasks. It neither discovers
`scripts.<name>` nor creates a `devenv up` task. The provider was added on
[2026-01-15][devenv-add], after the 2.1.0 release.

This discovery is not read-only in operational terms: [devenv's task docs][devenv-tasks]
say entering the shell runs `devenv:enterShell` dependencies, including possible
git-hook installation. Shell setup can also contaminate stdout before JSON.
The provider does not first check the subprocess exit code.

More importantly, [current tasks.nix][devenv-module] explicitly sets
`DEVENV_TASKS` to an empty string for the native process manager with CLI >= 2.0,
using `DEVENV_TASK_FILE` instead. Therefore the old environment-variable technique
can fail even when tasks exist. This is a source-backed compatibility risk, not a
locally reproduced failure.

The parent verified installed **devenv 2.4.0** and that
`devenv tasks list --help` advertises `--json`; no project evaluation was run.
[Current CLI source][devenv-cli] also defines `tasks list --json`.
**Prefer a version-compatible structured-list adapter** to the shell-variable
provider. Verify the actual 2.4.0 JSON schema and evaluation side effects before
implementation; do not silently fall back to shell entry. Structured listing
still entails trusting Nix evaluation and possibly fetching/building inputs; it
is not a sandbox promise.

Local scope from parent: [salt/devenv.nix](../../salt/devenv.nix) has `scripts.check.exec`, but no user
tasks; this repository's [devenv.nix](../devenv.nix) has no scripts/tasks.
Consequently a working built-in task provider still would not surface that
`check` script. Prefer a small explicit `check` template running in the approved
environment over attempting to parse arbitrary Nix source for script names.

Version caveat: latest [devenv task docs][devenv-tasks] distinguish `tasks run`
from shell entry (`enterShell` is not automatically selected by `tasks run`) and
say processes started by a task graph stop when that run finishes. Use a reviewed
`devenv up` workflow for persistent services, not an assumption that a process
task will remain alive. Recheck these semantics against the installed version.

### just and make: discovery is not uniformly safe

- [just.lua][just] executes `just --unstable --dump --dump-format json` for
  candidate ancestor justfiles. It omits private recipes, builds parameter
  prompts, and handles modules. [Current just source][just-source] dispatches
  dump through compilation and serialization, separately from recipe execution
  and evaluation. **Do not claim the dump executes recipes/backticks merely
  because it launches just.** It still reads/imports project files and depends
  on the installed binary/schema; this research did not test its installed version.
- [make.lua][make] finds only exact `Makefile`, not GNUmakefile or lowercase
  makefile, and invokes `make -rRpq`. This is not a safe text parser:
  GNU make's [`shell` function and `!=`][make-shell] execute commands during
  expansion; even [`-q` has recipe exceptions][make-question] for `+`/recursive
  make. Never auto-preload it for untrusted repositories.
- Parent inspection found [flakes/justfile](../../flakes/justfile) mixes useful check/format/build
  recipes with activation, remote changes, secrets, updates, and cleanup.
  Use an **explicit reviewed development allowlist** there; do not expose all
  public recipes as equally safe defaults. An allowlist must review dependency
  recipes too; labels alone do not make execution harmless.

### Python uv, Lua, and flakes: proposed minimal additions

- **uv:** propose explicit `uv run --locked ...` tasks only for uv projects and
  known commands (e.g. a project-owned check entry). [uv docs][uv-sync] explain
  that plain `uv run` automatically locks and syncs. `--locked` rejects an
  outdated lockfile rather than changing it, but **still syncs/installs**;
  `--frozen` skips freshness validation, and `--no-sync` skips environment
  freshness checks. None means arbitrary project code is safe. A read-only-ish
  environment policy needs an intentional pre-provisioning/no-sync decision.
  Existing local [script](../lua/overseer/template/user/run_script.lua) and
  [module](../lua/overseer/template/user/run_python_module.lua) templates use bare Python; the module template derives
  a module from `%:r`, which is not a validated dotted import path (parent finding).
  File execution and module execution need separate, project-root-aware policies;
  do not mechanically replace Python and preserve that derivation bug.
- **Lua:** propose repository-specific check tasks rather than a generic
  `lua <current-file>` runner. In this config, respect the documented StyLua and
  headless-Neovim checks in [AGENTS.md](../AGENTS.md), and do not enable automatic
  writes or downloads while discovering tasks. Interactive evaluation stays iron's
  responsibility; formatting ownership does not move to Overseer.
- **Flakes:** prefer the parent's reviewed existing just/check commands. Optional
  explicit tasks could distinguish evaluation (`nix flake check --no-build
  --no-update-lock-file <root>`) from building checks (`nix flake check
  --no-update-lock-file <root>`). The [Nix manual][nix-check] confirms default
  check builds derivations; `--no-build` does not. `--no-update-lock-file` forbids
  lock updates, unlike merely declining to write a newly generated lockfile.
  Evaluation/builds can fetch inputs and consume substantial resources.
  Named host builds must specify a host, never imply switch/boot/deploy.
  Parent found [flakes/cells/dev/shell.nix](../../flakes/cells/dev/shell.nix) already supplies nixfmt, deadnix,
  statix, actionlint and hooks, with x86_64-linux-only flake support. Avoid a
  duplicate generic lint stack or assumptions about other architectures.

## Diagnostics, watches, services, and persistence

- Default components are exit status, completion notification, and delayed
  disposal; **ordinary tasks do not automatically publish diagnostics**.
  `default_vscode` additionally includes `on_result_diagnostics` ([config][config]).
- [Components][components] support `on_output_quickfix` with a per-task
  `errorformat`, task-relative paths, `items_only`, and optional diagnostics.
  Alternatively `on_output_parse` accepts **one of** errorformat, a problem
  matcher, or a parser, then `on_result_diagnostics` publishes parsed results.
  Choose parsers by command output, not `.vue`/`.py` alone; test multiline and
  colored output, wrapper cwd, and empty-result cleanup. Avoid globally
  overwriting quickfix or duplicating LSP/nvim-lint diagnostics. Trouble remains
  the existing aggregated-list owner.
- [VS Code support][guides] already reads `.vscode/tasks.json`, supporting
  dependencies, background matchers, input/standard variables and common task
  types. It is **not** full VS Code parity: extension-provided matchers/types
  need implementation; command/config variables and custom shells are among
  documented gaps, and custom JS regex can differ from Vim regex. Prefer shared
  tasks.json when projects already maintain it; don't introduce it only to
  duplicate package scripts.
- [Components][components] distinguish restarting on save from a tool's native
  watch mode. Scope `restart_on_save.paths`; avoid globally watching every save
  or adding restart behavior atop an existing Vite/TypeScript watcher.
  `on_result_notify` handles repeated watch results; `unique` can prevent
  duplicate service launches, but equality policy needs cwd/command awareness.
- The default [jobstart strategy][jobstart] stops jobs with `jobstop` and performs
  `VimLeavePre` cleanup/waiting. The [system strategy][system] sends SIGTERM then
  SIGKILL after five seconds. These are child-process cleanup mechanisms, **not
  proof that detached grandchildren, external process managers, containers, or
  remote services stop correctly**. Test explicit stop/restart/exit against the
  actual runner. The historical [shutdown discussion #46][shutdown] motivates
  cleanup, not a current universal failure claim.
- [Task serialization][task] includes command, cwd, explicit env, metadata and
  component parameters; event subscriptions are not serialized. [Session recipes][third-party]
  can restore and **start** saved tasks. Therefore do not persist credentials
  in task fields, commit session state, or enable automatic task restart on
  session restore without review. Old v1 bundle advice is obsolete.
- Treat trusted project configuration, permitted discovery, and permitted
  execution as separate decisions. An `on_pre_start` gate can block a task
  ([guide][guides]), but cannot undo a provider subprocess already executed
  during discovery. `.nvim.lua` recipes also require an intentional Neovim
  trust/exrc policy, not automatic trust of every cloned repository.

## Community evidence and recommendation

Two concrete community configurations were inspected, not a survey or consensus:

- [LazyVim's optional extra][lazyvim] uses a small run/toggle/action surface,
  `dap = false` with later explicit DAP enabling, optional neotest consumer and
  UI integrations. It does **not** implement a comprehensive custom provider
  layer for these languages. Borrow the small surface, not its keybindings or
  automatic neotest policy over this repo's ownership decisions.
- [AstroCommunity's module][astro] exposes run/shell/action/health entrypoints,
  but still contains `strategy = "toggleterm"` and `task_list.bindings`.
  These are older-API patterns relative to the current v2 changelog/config;
  this is a caution about copying recipes, not evidence they work on this pin.

**Recommended sequence (no implementation performed):**

1. Keep Overseer as the core task UI; retain existing project scripts/just/make
   definitions as the command owners. No new plugin is necessary.
2. Agree project trust and a default allowlist **before** discovery subprocesses;
   keep deployment/secrets/update/cleanup operations out of the default dev picker.
3. Prioritize the devenv structured-list compatibility fix and explicit script
   entries; npm/just/make already exist. Add uv/Lua/flake templates only where
   local findings prove a gap, with argv commands and explicit cwd.
4. Add task-specific diagnostics and lifecycle behavior incrementally. Test with
   synthetic fixture projects: lockfile conflicts, workspace glob limitations,
   spaced paths, stale uv lock, malformed/empty list JSON, changed roots, watcher
   stop, editor exit, and session restore that does **not** auto-run tasks.
5. Keep evaluation/build/format/install/service/activation actions visibly
   distinct. Recheck tool versions and actual JSON/error output before claiming
   adapters work. This research deliberately did not run projects to prove that.

## Primary sources

Overseer links are pinned to the inspected head. External docs are live snapshots
accessed on the research date; just/devenv source links below pin their inspected
heads, which are **not** assertions about locally installed revisions.

[head]: https://github.com/stevearc/overseer.nvim/commit/a93d9f6d6defdac4bcd6d2c8ba988650e42e0a0e
[changelog]: https://github.com/stevearc/overseer.nvim/blob/a93d9f6d6defdac4bcd6d2c8ba988650e42e0a0e/CHANGELOG.md
[templates]: https://github.com/stevearc/overseer.nvim/tree/a93d9f6d6defdac4bcd6d2c8ba988650e42e0a0e/lua/overseer/template
[config]: https://github.com/stevearc/overseer.nvim/blob/a93d9f6d6defdac4bcd6d2c8ba988650e42e0a0e/lua/overseer/config.lua
[guides]: https://github.com/stevearc/overseer.nvim/blob/a93d9f6d6defdac4bcd6d2c8ba988650e42e0a0e/doc/guides.md
[strategies]: https://github.com/stevearc/overseer.nvim/blob/a93d9f6d6defdac4bcd6d2c8ba988650e42e0a0e/doc/strategies.md
[task]: https://github.com/stevearc/overseer.nvim/blob/a93d9f6d6defdac4bcd6d2c8ba988650e42e0a0e/lua/overseer/task.lua
[npm]: https://github.com/stevearc/overseer.nvim/blob/a93d9f6d6defdac4bcd6d2c8ba988650e42e0a0e/lua/overseer/template/npm.lua
[workspace-revert]: https://github.com/stevearc/overseer.nvim/commit/fe4c8a06796c3da68b4dbbb0fcc3aa4ba8971385
[devenv-provider]: https://github.com/stevearc/overseer.nvim/blob/a93d9f6d6defdac4bcd6d2c8ba988650e42e0a0e/lua/overseer/template/devenv.lua
[devenv-add]: https://github.com/stevearc/overseer.nvim/commit/5828bdbd86677497613033c142f0a8624489216f
[devenv-tasks]: https://devenv.sh/tasks/
[devenv-module]: https://github.com/cachix/devenv/blob/9655d320b8f9df74dbecf681f52a7334574606c3/src/modules/tasks.nix
[devenv-cli]: https://github.com/cachix/devenv/blob/9655d320b8f9df74dbecf681f52a7334574606c3/devenv/src/cli.rs
[just]: https://github.com/stevearc/overseer.nvim/blob/a93d9f6d6defdac4bcd6d2c8ba988650e42e0a0e/lua/overseer/template/just.lua
[just-source]: https://github.com/casey/just/blob/7b7b51bec9359a5b4a76321018db65d07978fecc/src/subcommand.rs
[make]: https://github.com/stevearc/overseer.nvim/blob/a93d9f6d6defdac4bcd6d2c8ba988650e42e0a0e/lua/overseer/template/make.lua
[make-shell]: https://www.gnu.org/software/make/manual/html_node/Shell-Function.html
[make-question]: https://www.gnu.org/software/make/manual/html_node/Instead-of-Execution.html
[uv-sync]: https://docs.astral.sh/uv/concepts/projects/sync/
[nix-check]: https://nix.dev/manual/nix/2.35/command-ref/new-cli/nix3-flake-check
[components]: https://github.com/stevearc/overseer.nvim/blob/a93d9f6d6defdac4bcd6d2c8ba988650e42e0a0e/doc/components.md
[jobstart]: https://github.com/stevearc/overseer.nvim/blob/a93d9f6d6defdac4bcd6d2c8ba988650e42e0a0e/lua/overseer/strategy/jobstart.lua
[system]: https://github.com/stevearc/overseer.nvim/blob/a93d9f6d6defdac4bcd6d2c8ba988650e42e0a0e/lua/overseer/strategy/system.lua
[shutdown]: https://github.com/stevearc/overseer.nvim/issues/46
[third-party]: https://github.com/stevearc/overseer.nvim/blob/a93d9f6d6defdac4bcd6d2c8ba988650e42e0a0e/doc/third_party.md
[lazyvim]: https://github.com/LazyVim/LazyVim/blob/301a3f71007c4aa5da5dab82f1a7a08389091224/lua/lazyvim/plugins/extras/editor/overseer.lua
[astro]: https://github.com/AstroNvim/astrocommunity/blob/d79a4b5d88bc38cf4f5926c0f32655c8e3d12b2b/lua/astrocommunity/code-runner/overseer-nvim/init.lua
