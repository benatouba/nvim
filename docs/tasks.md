# Project tasks

Overseer owns tasks; toggleterm owns interactive terminals and iron owns REPLs.
Neotest remains the entry point for nearest/file tests. No extra task plugin or
global tool installation is required by this configuration.

## Shortcuts

| Key | Action |
| --- | --- |
| `<leader>Or` | Refresh discovery, then choose a task |
| `<leader>Ot` | Toggle Overseer's task list/output |
| `<leader>Ol` | Rerun this project's last task |
| `<leader>Os` | Choose a running task to stop |
| `<leader>Oc` | Discover and choose a check/test/lint task |
| `<leader>Ob` | Discover and choose a build task |

Selection is always explicit, even with one result. Canceling launches nothing.
Check/build filtering uses conventional command names and explicit template tags;
use the full picker for custom names that do not match those conventions.
The stop picker includes running tasks from all projects and displays their cwd.
Rerun history is in memory, scoped to the Git root (or nearest project marker).
Already-running tasks are not silently restarted or duplicated by rerun.

Nothing discovers or starts tasks on startup, file open/save, project entry, or
session restore. Merely opening the task list does not refresh discovery.
Templates have automatic save/completion restart components removed, including
VS Code background-task retries. A watcher you explicitly start can still use
its own native watching; stop it explicitly when finished. Detached/external
services may need their own shutdown commands.

## Discovery

Projects are trusted. There are no trust prompts or operational allowlists:
public deployment/update/cleanup recipes are visible alongside development
commands. Selecting one really executes it, including any dependencies.
No deployment or activation is implied by a generic Nix build task.

Discovery starts when requested from the picker and can execute project code:
Make expands expressions, and environment-aware recipe discovery may enter
devenv and run its shell setup hooks. Devenv's own task/script discovery uses
metadata evaluation instead of shell entry, but evaluation can fetch/build
inputs. This is not a sandbox or a guarantee of side-effect-free listing.
Cold metadata evaluation is allowed a longer timeout than Overseer's default.

| Project files | Discovered actions |
| --- | --- |
| `devenv.nix` | Tasks from `devenv tasks list --json`; script names from `devenv eval scripts` |
| `package.json` | Scripts and an explicit dependency-install action |
| `justfile` / `.justfile` (case-insensitive) | Public recipes, modules, parameter prompts |
| `GNUmakefile` / `makefile` / `Makefile` | Make targets from its database |
| `uv.lock` | pytest, Ruff and type-check tasks for detected tools; saved current Python file |
| StyLua / Luacheck / Selene / Busted config | Corresponding Lua checks/tests |
| Neovim `init.lua` + `lua/config` | Documented style/startup checks; headless tests declaring `-u NONE` in their first three lines |
| `flake.nix` | Evaluate checks, build checks, prompt for a named output to build |
| `.salt-lint` | Existing Salt-specific fixture/lint/test/VM tasks |

The environment-aware providers replace Overseer's built-in devenv/npm/just/make
providers to avoid duplicate tasks and inconsistent environments. Other built-in
providers, including `.vscode/tasks.json`, remain available.

The nearest package.json owns package-script tasks. `packageManager` selects the
manager; otherwise the nearest lockfile directory selects npm/pnpm/yarn/bun.
Conflicting managers without a declaration produce an error, not a guess.
The declaration does not install or enforce a manager version. Open a workspace
package to discover its scripts: this adapter does not recursively scan workspace
globs or node_modules. Just discovery likewise uses the nearest justfile.

Python tool detection checks project declarations and available executables;
it does not parse arbitrary TOML entry points or invent project commands. Put
custom commands in just, Make, devenv, package scripts, or tasks.json. Unsafe
bare-Python/module-path templates are disabled; module execution belongs in an
explicit project command rather than deriving imports from a filename.

## Environment and output

The project-aware tasks use their project/package cwd. Where an ancestor devenv exists, ordinary
commands run through `devenv --from path:<root> shell -- ...`, preserving nested
package cwd. Native `devenv` and `nix` commands are not wrapped again. Without
devenv, executables prefer project node_modules/.bin, .venv/bin and
.devenv/profile/bin, then PATH. Nothing installs tools while listing scripts.
For metadata commands run inside devenv, stdout framing separates shell banners
from structured output without interpolating project arguments into shell code.

Python commands use `uv run --locked`: stale locks fail instead of being updated,
but uv may still synchronize/install the local environment. Nix tasks refuse lock
updates; evaluation/building may fetch inputs and consume substantial resources.
Package install and any project-defined mutating commands run only if selected.
File-execution tasks require the file to be saved.

Task output and status remain in Overseer (`<leader>Ot`). No blanket quickfix or
diagnostic publisher is added: existing LSP/nvim-lint diagnostics and VS Code
problem matchers retain their own behavior. Discovery errors do not echo raw
evaluation output or script bodies; rerun the indicated command in a terminal
when deeper diagnostics are needed.

## Verification

From this repository:

```sh
nvim --headless -u NONE -l tests/tasks.lua
nvim --headless -u NONE -l tests/salt.lua
stylua --check lua after init.lua tests/tasks.lua
nvim --headless -u init.lua +qa
```

The task regression uses synthetic projects/mocked metadata commands, then real
harmless shell tasks to test selection, completion, rerun, disposal, stopping and
the absence of save-triggered restarts. It never executes real deployment recipes.
See [the source-linked research](overseer-research.md) for upstream API context.
