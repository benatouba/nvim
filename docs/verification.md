# Verification set

Shared checks every later ticket runs against. All commands run from the
repository root unless noted.

## Reproducibility

`lazy-lock.json` is tracked and pins the exact revision of every plugin,
including the lazy.nvim bootstrap itself (re-pinned on every startup in
`lua/config/lazy.lua`, since lazy cannot restore its own checkout).
A fresh clone restores those revisions without manual intervention. The
clone must be installed as the `nvim/` subdirectory of an isolated
`XDG_CONFIG_HOME`, and the entrypoint must be absolute — a bare
`XDG_CONFIG_HOME` pointing at an empty directory has no config to load,
and a relative `-u init.lua` breaks as soon as the cwd changes:

```sh
git clone <repo> nvim-repro # replace <repo> with the source URL
mkdir -p /tmp/repro-test/config/nvim /tmp/repro-test/data /tmp/repro-test/state /tmp/repro-test/cache
cp -a nvim-repro/. /tmp/repro-test/config/nvim/
XDG_CONFIG_HOME=/tmp/repro-test/config \
XDG_DATA_HOME=/tmp/repro-test/data \
XDG_STATE_HOME=/tmp/repro-test/state \
XDG_CACHE_HOME=/tmp/repro-test/cache \
nvim --headless +"Lazy! restore" +qa
```

`restore` checks out the locked commit of each plugin; `sync` would move
them forward instead and must not be used for verification. Specs with
`enabled = false` (and platform-gated specs off their platform) are
neither installed nor loaded, so a few lockfile entries legitimately have
no directory. The executable form of the spot-check is
`tests/lockfile.lua` (run headless against the isolated dirs above):
every installed plugin's `HEAD` must equal its lockfile entry.
`tests/workflows.lua` is the executable functional sweep (formatting,
picker selection, task execution, Python lint/types/imports/format plus
completion, and org/markdown/supercollider file probes).

Restore evidence is only valid for a clean tree: record `git status --short`
(empty) and `git rev-parse HEAD` alongside the results, so the tested
configuration is the committed one rather than uncommitted worktree state.

## Checks

Run in order; every step must be silent unless stated.

1. Formatting: `stylua --check lua after init.lua` — clean, no output.
2. Silent startup: `nvim --headless -u init.lua +qa` — no output.
3. Empty startup: from a fresh empty directory
   (`dir=$(mktemp -d) && cd "$dir"`), `nvim --headless -u <repro>/init.lua +qa`
   with no file arguments — no output, exit 0, where `<repro>` is the
   absolute path of the isolated config (e.g. `/tmp/repro-test/config/nvim`).
   The temporary directory must exist first and the entrypoint must stay
   absolute, since the cwd no longer contains `init.lua`.
4. File startup: `nvim --headless -u <repro>/init.lua <file> +qa` for one core
   workflow file (e.g. a Lua file) and one specialist workflow file
   (e.g. a TeX file) — no output, exit 0. Both fixture files must exist.
   Host-tool caveat: on hosts without the specialist toolchain installed
   (e.g. no `latexmk` on PATH), the owning plugin may print its own
   missing-executable warning on open. That message is a provisioning gap
   on the host, not a config failure; it fires identically with or without
   eager loading, since opening the file loads the owner either way.
   The same applies to runtime-dependent owners (notebooks, R): without
   their runtime on the host, opening a representative file surfaces the
   owner's own error, which is likewise out of scope with this reason.
   Known reasoned exclusions: ledger.nvim fails internally on BufEnter
   (`loop or previous error loading module 'ledger.context'` from its own
   `commands.lua`), independent of this config — needs an upstream report,
   not a config change. The HTTP client (kulala.nvim) is disabled, so there
   is no http/rest probe; re-enable with a working spec before covering it.
5. Directory startup: `nvim --headless -u <repro>/init.lua <dir> +qa` against an
   existing directory — no output, exit 0.
6. First-use probes for the ticket's workflow: open a representative file
   and assert the owning plugin is loaded and active (e.g. highlighting
   enabled for a Treesitter language). Prefer the executable probes in
   `tests/workflows.lua` (Lua formatting, Telescope selection, Overseer
   execution, Python lint/types/imports/format plus completion, and
   org/markdown/supercollider file probes) over ad-hoc checks. Record the
   exact probe and its result in the ticket's verification comment.
