# Salt Vim integration research

Research date: 2026-11-03. Investigation only; no installations, Salt rendering,
project tasks, or implementation changes. This note is the only authored change;
the pre-existing modified `lazy-lock.json` was not touched. Recommendations are
proposals, not an ADR. GitHub metadata and default-branch source were inspected
directly; most source links pin inspected revisions, with explicitly identified
live references and incomplete audits in the expanded inventory.

## Recommendation: maintain a community continuation of salt-vim

**The explicit goal is maintenance ownership.** The earlier recommendation to
avoid a permanent fork is superseded. Use archived `vmware-archive/salt-vim`
at `6ca9e35` as the traceable Apache-2.0 base, then consolidate useful fork
changes rather than adopting an arbitrary fork unchanged. The
[maintenance takeover ecosystem inventory](#maintenance-takeover-ecosystem-inventory)
below identifies concrete donors, additional projects and a phased shortlist.

Start with the newer requisite/global-argument highlighting in
`terminalmage/salt-vim`, regression cases from `sakateka/salt-vim` and
`cAtilre/salt-vim`, and a cleanup of the original plugin's intrusive settings.
Reuse native YAML/Jinja where suitable; maintenance need not mean duplicating
all generic language support. Treat snippets, folding and lint adapters as
separable capabilities; Salt LSP maintenance belongs to the user's other repo,
not this roadmap. Retain project-specific tasks and local
formatting policy in this configuration.

**Authorization remains research only:** this report proposes a continuation;
it does not create a fork, claim official succession, contact owners, or change
editor behavior. An actual repository transfer or community-fork launch requires
a subsequent request.

## Collaboration targets alongside our maintained continuation

Maintaining salt-vim and contributing generic fixes to existing language
upstreams are complementary. Candidate collaboration targets:

1. **Vim's Salt runtime maintainer / `vim/vim` for Salt-specific syntax or
   detection.** The native Salt file names Gregory Anders as maintainer; Vim
   [introduced this support in patch 9.1.0735][vim-salt-add] in September 2024.
   Neovim's [contribution guide][nvim-contributing] explicitly says most Vimscript
   runtime files are maintained by Vim, and filetype-detection changes should go
   to Vim first. Thus do not open the first generic runtime PR against Neovim
   merely because this configuration uses Neovim. Propose Salt requisite/include
   highlighting or renderer-sensitive detection only with current-Salt examples
   and tests; these are candidate enhancements, not reproduced upstream bugs.
2. **`HiPhish/jinja.vim` for generic Jinja syntax bugs.** Native Jinja's header
   names it as upstream. Unlike the old Salt plugins, its inspected head
   `d3ab7a8` is dated 2026-10-21; this shows recent code activity, not a guaranteed
   response time. Its [README][hiphish-readme] gives MIT licensing except where
   otherwise noted and identifies syntax provenance. Its [contribution policy][hiphish-contributing]
   requires **GitLab merge requests**, not PRs to its GitHub mirror, and asks for
   an issue/discussion before new features. Appropriate fixes would be
   demonstrated mis-highlighting of raw blocks, nested expressions, whitespace
   control or host-language composition—not merely features our smaller custom
   syntax omitted that native Jinja already implements.
3. **Own mixed-language indentation in the continuation if fixtures demonstrate
   a gap.** No examined Salt plugin establishes a proven modern YAML/Jinja
   indentation solution; native Salt has no dedicated indent file. The newer
   other-editor tools below provide additional implementation/fixture leads,
   not demonstrated correctness in Vim. Keep any indentation feature optional
   rather than imposing this configuration's no-guess preference on all users.

**Takeover context:** `vmware-archive/salt-vim` is archived and
`ben-grande/vim-salt` expressly declines further improvements. These are reasons
to establish an explicitly maintained continuation, not reasons to reject the
user's ownership goal. Preserve attribution, audit provenance, add tests and
publish compatibility/release policy before inviting downstream adoption.

Keep environment resolution, whether to format SLS, preferred folds/indent,
curated snippet choices, and the checkout's fixture/VM tasks here or in the
project that owns those commands. These are policy/project integration, not
generic language-support contributions. A genuine nvim-lint adapter bug would
belong to nvim-lint, not to a Salt syntax repository; no such bug was established
in this investigation. **No forks, issues, PRs, commits or code changes were
authorized or performed.**

## Neovim already supplies the generic syntax

- [Native detection][nvim-filetype] maps `sls = 'salt'`. [Native Salt syntax][nvim-salt]
  loads the runtime YAML and Jinja syntax; no dedicated Salt ftplugin or indent
  file appeared in the inspected runtime tree. The local override in
  [autocmds.lua][local-detect] deliberately selects `sls` instead, bypassing this
  native syntax name. Its introductory claim that all listed files are
  unrecognized by Neovim is therefore inaccurate for `.sls`.
- This is not merely a future-upstream finding: installed Neovim reports
  `v0.13.0-nightly+92ea326`; a clean, configuration-free probe returned `salt`
  for `example.sls`, found `syntax/salt.vim`, and found no `ftplugin/salt.*`.
  Reading that installed syntax confirmed the same YAML-plus-Jinja composition.
- [Native Jinja syntax][nvim-jinja] already handles variables, attributes,
  numbers, operators, nested delimiters, raw blocks, strings and filters. Our
  27-line implementation has useful Salt globals/extensions and renderer-line
  highlighting, but manually enumerates a smaller subset of Jinja and has no
  raw-block or nested-expression handling. Reusing native syntax would reduce
  duplicated language maintenance; visual equivalence still needs testing.
- The inspected current native extension rule does not perform salt-vim's
  `#!py` detection or special-case `Saltfile`. Our override does not either.
  Renderer-sensitive detection is a separate potential enhancement, not a
  reason to load the entire old plugin. Do not blanket-classify all files under
  `/etc/salt` or all `.top` files without checking actual contents/use.

## What the GitHub projects actually provide

Dates below are **latest inspected default-branch commit dates**, not GitHub's
`updated_at` (which also changes for non-code activity). Non-archived does not
mean actively maintained. Repository API endpoints in the sources expose the
archive status observed on the research date.

| Project | Status and licensing | Actual scope and fit |
| --- | --- | --- |
| [`saltstack/salt-vim`][salt-old] → [`vmware-archive/salt-vim`][salt-repo] | Redirect confirmed by GitHub API; **archived**; head `6ca9e35`, 2017-07-01. [LICENSE][salt-license] explicitly grants Apache-2.0 despite GitHub reporting `NOASSERTION`. | YAML + Jinja/Django syntax, Salt include/requisite/likely-typo keyword groups, `.sls`/`Saltfile` detection and `#!py` → Python; ftplugin indentation/folding/comment settings. No lint/format/task/snippet implementation. |
| [`keitheis/vim-salt`][keitheis] | Not archived; head `9e47db6`, 2014-02-06; repository license Apache-2.0. | Earlier cleanup of salt-vim; Django-based syntax and custom YAML indentation, not a maintained modern replacement. Its indent file installs **wildcard** window/insert autocmds and `clearmatches()`. |
| [`ben-grande/vim-salt`][ben-grande] | Not archived; head `3bedc0a`, 2023-11-11. README explicitly says **no further improvements planned**. No repository-wide LICENSE; file headers identify Apache-2.0 for syntax/detection and Vim license for ftplugin/indent. | Compilation of older files, requires `ben-grande/vim-jinja`; uses `salt`, textwidth 160 and copied YAML indentation. Syntax documents known templated-key/keyword-matching limitations. Native Neovim now already supplies the basic syntax composition. |
| [`kmalinich/salt-jinja-vim`][salt-jinja] | Not archived; head `f30b387`, 2017-03-03; no repository-wide license file/API license identified. | Specialist Jinja map-file indentation/syntax, assembled from other sources. Ftplugin adds non-ASCII/trailing-whitespace matches and clears matches on window exit; not a replacement for our Salt tooling. Verify permission/provenance before copying code. |
| [`StephenPCG/vim-snippets-salt`][stephen] | Not archived; default head `bbf6f5e`, 2014-06-17 (repository `pushed_at` is 2019-01-15). No repository-wide license file/API license identified. | Generated state-function snippets for Salt **0.17.2 and 2014.1.5**, neosnippet/snipMate format; generator imports Salt state modules. Neither current coverage nor our VS Code JSON/LuaSnip format. |
| [`thaligar/vim-salt-autocomplete`][thaligar] | Not archived; head `71cd5c4`, 2019-01-16; no repository-wide license file/API license identified. | README calls it early alpha: generates UltiSnips state-function snippets/all parameters, not semantic completion or an LSP. No compelling replacement for ten curated local snippets. |

The same-name `egonSchiele/salt-vim` concerns **Salty**, not SaltStack. Salt
formulas that install/configure Vim are provisioning projects, not editor
integrations; a GitHub name match alone is insufficient evidence of relevance.

### Why not load the original plugin unchanged?

The [actual ftplugin][salt-ftplugin], rather than its older README feature list,
sets a custom global `GetYamlIndent()`/`indentexpr`, changes `formatoptions`,
installs non-ASCII warning matches, and calls `clearmatches()` on buffer-window
exit. It has no `b:did_ftplugin` guard or `b:undo_ftplugin` cleanup. Our after
ftplugin would override some settings but would not undo its autocmds, matches
or formatoptions. Its [syntax][salt-syntax] also assigns the whole global
`g:NERDCustomDelimiters` dictionary. These are real integration side effects;
the README's listed Space/visual mappings are **not present** in the inspected
ftplugin. Do not repeat them as current behavior.

Its positive contribution is the small Salt-specific keyword layer, not superior
mixed-language tooling. The keyword lists are finite historical lists, not
validation against the installed Salt version. If vendoring, follow
[Apache-2.0 redistribution conditions][apache] (include license, retain relevant
notices, identify modifications, and carry relevant NOTICE content if supplied).
Attribution alone is not the whole license obligation. No-license repositories
are not automatically free to vendor; per-file provenance may matter.

## Comparison with the local ownership boundaries

| Local surface | Existing behavior | What to retain/reuse |
| --- | --- | --- |
| [after/ftplugin/sls.lua][local-ftplugin] | Two-space indentation, comments, predictable autoindent; explicitly clears indentexpr/smartindent; indent folds start open; restores options via undo_ftplugin. | Keep this small policy layer. Old YAML-only indent guesses are not a reason to change mixed YAML/Jinja behavior. Native syntax reuse does not require native indentation. |
| [syntax/sls.vim][local-syntax] | Runtime YAML plus small custom Jinja regions, Salt identifiers/extensions and renderer-line highlight. | Main deepening opportunity: native Salt/Jinja syntax, with a small extension only if needed. Native support is still syntax highlighting, not Salt compilation validation. |
| [snippets/salt.json][local-snippets] | Ten curated package/file/service/requisite/include/map/pillar/grains/Jinja snippets. | Keep; old generators offer breadth but dated APIs, other formats/engines and uncertain redistribution permission. Review modern state arguments before importing ideas. |
| [lua/plugins/linting.lua][local-lint] | `sls` → nvim-lint `saltlint`, project-resolved executable and root cwd; plain YAML → yamllint; no raw SLS passed to yamllint. | Keep nvim-lint as non-LSP diagnostics owner. None of the surveyed plugins provides this environment-aware integration. |
| [lua/plugins/formatting.lua][local-format] | `sls = { lsp_format = 'never' }`; no general save formatter; suppresses generic trim fallback. YAML has separate yamlfmt. | Keep explicit protection against rewriting templates. Syntax plugin adoption does not make YAML formatters safe for Jinja. |
| [lua/plugins/treesitter.lua][local-ts] | Excludes `sls` from automatic Tree-sitter highlight/indent; keeps legacy syntax; SLS percent pairing. | Keep exclusion unless a tested mixed-language parser setup replaces it. A native-filetype migration must preserve the exclusion and pairing. |
| [Salt task template][local-tasks] | Root `.salt-lint` gating, saved-file lint tasks, explicit project fixture render/compile/pytest and isolated VM build entries through devenv; no arbitrary state application. | Keep project-specific commands and trust policy local/project-owned. These are not missing generic Vim plugin features; preserve Overseer's task ownership. Filename existence gates are convenience discovery, not a sandbox or proof that a checkout is trusted. |

A later `sls` → `salt` migration must update the detection override, ftplugin and
syntax paths, snippet language registration, lint/format tables and callback
checks, both relevant Tree-sitter behaviors, autopairs rule and task filetype
checks together. Changing only filetype would silently lose local policies.

## Tree-sitter is an option, not a prerequisite

The current [nvim-treesitter registry][ts-parsers] has `jinja`, `jinja_inline` and
`yaml`, but no dedicated `salt`/`sls` parser. Jinja uses
[`cathaysia/tree-sitter-jinja`][jinja-repo] at **v0.13.1**, requires `jinja_inline`,
and is described as basic highlighting. The inspected [injection query][ts-inject]
injects `jinja_inline` into inline nodes, **not YAML**; its presence is not proof
of complete Salt YAML+Jinja highlighting or indentation. Installed Neovim maps
`salt` and `sls` to those same respective language names, not automatically to
Jinja or YAML.

Notably, the Jinja grammar repository API currently reports **archived: true**,
even though its inspected head `f46e979` is dated 2026-11-02. Its LICENSE is
Apache-2.0. This illustrates why commit age alone is a poor maintenance test.
Do not promise active parser maintenance or switch to plain YAML parsing without
testing injections, template-generated keys, block scalars and indentation.
No parser installation or rendering experiments were performed here.

## Verification before any implementation

Use synthetic fixtures for quoted/unquoted Jinja expressions, nested dicts,
raw blocks, whitespace-control tags, multiline strings, YAML block scalars,
Salt `load_yaml`/`import_yaml`, templated keys and representative requisites.
Compare native versus current highlights and verify unchanged two-space
autoindent, manual-only formatting/no YAML LSP on SLS, snippet availability,
saltlint cwd, and task eligibility. The source comparison establishes reuse
potential, **not** visual parity or correctness on every renderer.

## Maintenance takeover ecosystem inventory

Expanded search: 2026-11-03. This section supersedes the initial narrow survey's
assessment that no useful continuation source had been established. **There
are useful unmerged fixes, additional Vim plugins and recent adjacent tools.**
Dates below distinguish code changes from README, packaging and formatting
activity. Source inspection is not a runtime correctness test.

### 1. Original salt-vim fork network: concrete consolidation donors

The [paginated original fork list](https://api.github.com/repos/vmware-archive/salt-vim/forks?per_page=100)
returned **72 public forks**, matching repository metadata (247 stars, 72 forks).
Every returned default branch was compared against original head `6ca9e35` using
GitHub's compare API. **Eleven had ahead commits**; the others were identical or
behind on their default branch. This is stronger evidence than repository
`updated_at`, but does not inspect every non-default branch or private/deleted
fork. The original itself exposes only `master` and no open PRs at inspection.

All forks below belong to the original network, not to `keitheis/vim-salt` or
`ben-grande/vim-salt`. They inherit original Apache-2.0 material; selected donor
metadata reports non-archived. This establishes provenance, **not** a promise of
active maintenance. Compare links expose exact commits and patches.

| Fork / last unique code activity | Verified difference and maintenance use |
| --- | --- |
| [`terminalmage/salt-vim`](https://github.com/terminalmage/salt-vim/commit/d44e57ab3c), 2022-11-03 | **Highest-priority syntax donor:** one commit expands requisite/global arguments (`require_any`, `onchanges_any`, `creates`, `retry`, reload options, etc.) and suspected-typo groups. Validate each entry against current Salt; highlighting is not a validator. [Compare](https://api.github.com/repos/vmware-archive/salt-vim/compare/HEAD...terminalmage:master). |
| [`t0fik/salt-vim`](https://api.github.com/repos/vmware-archive/salt-vim/compare/HEAD...t0fik:master), 2022-11-03 | Same `d44e57ab3c` as terminalmage: **one change, not two independent improvements**. |
| [`eitrtechnologies/salt-vim`](https://api.github.com/repos/vmware-archive/salt-vim/compare/HEAD...eitrtechnologies:master), code 2022-11-03; README/merge 2024-04 | Equivalent keyword patch under `0f076e25ee`; later commits update VMware links and merge that documentation. A possible collaboration contact, but 2024 head is not evidence of newer syntax work. |
| [`Sjd-Risca-salt/salt-vim`](https://api.github.com/repos/vmware-archive/salt-vim/compare/HEAD...Sjd-Risca-salt:master), 2023-04-03 | `7d3140f711` has the same keyword changes as the 2022 patch despite a different message/date. Do not triple-count this code. |
| [`cAtilre/salt-vim`](https://github.com/cAtilre/salt-vim/commit/8400e80bc5), 2024-10-15 | Same expanded keywords plus changes old regexp workaround from engine 1 to 2, claiming to address `redrawtime` errors. **Important defect report**, but guard still compares literal `'&regexpengine'` to zero instead of reading the option; do not cherry-pick as a proven fix. [Compare](https://api.github.com/repos/vmware-archive/salt-vim/compare/HEAD...cAtilre:master). |
| [`sakateka/salt-vim`](https://github.com/sakateka/salt-vim/commit/d99212100f), 2024-12-20 | Replaces workaround with unconditional `setlocal regexpengine=0`; commit reports `E369: Invalid item in \\%[]`. Use as a regression case and investigate removing the forced engine entirely. No tests were run here; do not promise this fixes every regexp failure. [Compare](https://api.github.com/repos/vmware-archive/salt-vim/compare/HEAD...sakateka:master). |
| [`wyattanderson/salt-vim`](https://api.github.com/repos/vmware-archive/salt-vim/compare/HEAD...wyattanderson:master), 2015-09-07 | Removes forced `softtabstop`/`shiftwidth`; useful policy-separation precedent. Diverged from an older original revision, so compare output also includes missing upstream changes; port the unique commit, not the full fork tree. |
| [`andoriyu/salt-vim`](https://api.github.com/repos/vmware-archive/salt-vim/compare/HEAD...andoriyu:master), 2021-03-24 | Simplifies detection to unconditional `filetype=sls`, **losing `#!py` handling and overwriting existing filetype decisions**. Keep as a detection test case, not preferred behavior. |
| [`flaport/salt-vim`](https://api.github.com/repos/vmware-archive/salt-vim/compare/HEAD...flaport:master), 2022-04-08 | Renames detection/ftplugin/syntax to apply Salt rules to ordinary YAML. Not appropriate as the general continuation base: it changes all YAML ownership. |
| [`puneetk/salt-vim`](https://api.github.com/repos/vmware-archive/salt-vim/compare/HEAD...puneetk:master), 2015-03-20 | Older diverged Jinja/YAML experiment; commit history explicitly points to `Glench/Vim-Jinja2-Syntax`. Historical composition/provenance lead, not a modern replacement. |
| [`jgmize/salt-vim`](https://api.github.com/repos/vmware-archive/salt-vim/compare/HEAD...jgmize:master), 2013-03-27 | Older diverged four-space preference. No distinctive language-support improvement to consolidate. |

**Base shortlist:** start from original `6ca9e35` and import reviewed changes
with their authorship. `terminalmage` is the cleanest alternative starting tip
if the expanded keyword commit is desired immediately: exactly one ahead commit
and no upstream commits missing. `sakateka` is newer but contains only an engine
workaround, not a broader maintained implementation. Do not pick a base by date
or star count alone, and do not describe any fork as official succession.

### 2. Additional direct Vim/Neovim sources

These are **additional discoveries**, separate from the six historical Salt
repositories and HiPhish already covered above.

| Repository / activity / provenance | Verified scope; what to consolidate |
| --- | --- |
| [`pedrohdz/vim-yaml-folds`](https://github.com/pedrohdz/vim-yaml-folds/tree/890ccd8e53) | Non-archived; 112 stars / 15 forks; latest head 2020-07-18 is README-only, last `after/` change 2017-10-26. Actual `after/ftplugin/sls/folding.vim` and YAML equivalent implement indentation-based expression folds, fold text and `undo_ftplugin`. **Useful optional folding feature**, not Jinja-structural folding. Global functions and division by raw `&shiftwidth` need review. No top-level license or API license identified: resolve permission before copying. |
| [`noseka1/vim-yaml-folds`](https://github.com/noseka1/vim-yaml-folds/commit/53dadb25cf), 2024-07-08 | Fork of pedrohdz; moves logic into `autoload/yamlfolds.vim` plus `plugin/entry.vim`, broadening activation beyond the original after-ftplugin layout. Useful modularization reference; review activation side effects. No new independent permission grant established. |
| [`Kagemaru/vim-yaml-folds`](https://github.com/Kagemaru/vim-yaml-folds/commit/12325f5d90), 2024-03-04 | Same parent; two unique commits add YAML document start/end-marker folding and fix indentation. Potential fixture/feature donor after licensing review. `uriahcat`'s 2021 fork instead changes initial fold-open preference. [Network](https://api.github.com/repos/pedrohdz/vim-yaml-folds/forks?per_page=100). |
| [`SaltStackExperiments/salt_vim_env`](https://github.com/SaltStackExperiments/salt_vim_env/tree/098a009941), 2018-10-02 | Non-archived assembled Vim environment, not a fork of salt-vim. `.gitmodules` references original salt-vim, Glench Jinja and UltiSnips; owns a sizeable `UltiSnips/sls.snippets` with Python helpers. Useful curated-snippet ideas, **not** a safe drop-in: source visibly has mismatches such as `file.rename` snippet expanding `file.absent`. No top-level license established. |
| [`hvnsweeting/saltvimplus`](https://github.com/hvnsweeting/saltvimplus/tree/79cd3859b1), 2013-11-28 | Non-archived setup scripts, not a new syntax implementation; installs original salt-vim and author's snipMate fork. Its installer moves `~/.vim` and overwrites `~/.vimrc`. Read-only historical integration reference; **do not run installer**. No top-level license established. |
| [`hvnsweeting/snipmate.vim`](https://github.com/hvnsweeting/snipmate.vim/blob/master/snippets/sls.snippets) | Additional Salt snippet location discovered through saltvimplus; API confirms fork of `msanders/snipmate.vim`, not of StephenPCG's generator. File existence verified, not a complete content/license/history audit. Treat as a lower-priority provenance lead. |
| [`Glench/Vim-Jinja2-Syntax`](https://github.com/Glench/Vim-Jinja2-Syntax/tree/2c17843b07), code 2021-06-22 | Non-archived; BSD-3-Clause; generic Jinja syntax, detection, ftplugin and indent. Latest functional patch adds `+` whitespace-control detection. `indent/jinja.vim` layers Jinja tags over HTML/fallback indent and defines global `GetDjangoIndent()`: not a Salt YAML/Jinja indent solution unchanged. Useful legacy syntax/fixture donor; HiPhish/native Jinja remains the more recent baseline. |
| [`lepture/vim-jinja`](https://github.com/lepture/vim-jinja/tree/7c54e2320c), code 2021-08-17 / merge 2021-08-26 | Non-archived generic Jinja/HTML plugin. Indent rules include trimmed tags and macros; syntax recognizes `endset`, but the inspected indent block list does **not** include `set`/`endset` (corrected 2026-11-04). HTML-based, globally named indent function. README's “great indent support” is not proof for Salt. No top-level license/API license identified. |
| [`geigerzaehler/tree-sitter-jinja2`](https://github.com/geigerzaehler/tree-sitter-jinja2/tree/7af726f7ac), functional Neovim change 2026-07-17 | **New direct Neovim plugin as well as grammar.** Non-archived; 7 stars / 5 forks. README requires Neovim 0.12 and Tree-sitter CLI; source confirms native Tree-sitter setup, `.j2/.jinja/.jinja2` detection and HTML injection, **no SLS registration**. Good optional parser experiment, not Salt support out of the box. No top-level LICENSE/API license found; clarify permission before vendoring. |

The `geigerzaehler` [five-fork network](https://api.github.com/repos/geigerzaehler/tree-sitter-jinja2/forks?per_page=100)
was also compared. `HiPhish/tree-sitter-jinja2` has **no unique default-branch
commits** (six behind), so do not confuse its name with a newer Salt grammar.
[`savetheclocktower/tree-sitter-jinja2`](https://github.com/savetheclocktower/tree-sitter-jinja2/tree/caa8e2e5ff)
does have five unique commits on 2025-03-16: different parse-node choices,
updated corpus/highlights and an external scanner for raw blocks. That is a
credible parser/fixture donor, but requires query compatibility and licensing
review. `dgethings` only changes Go module URLs; remaining forks add no unique
default-branch commits. No dedicated `tree-sitter-salt` repository was found.

Smaller prior networks were checked too: keitheis (one fork), ben-grande (zero),
kmalinich (one), thaligar (one) add no unique default-branch commits in returned
forks. StephenPCG has two forks; **[`g2g/vim-snippets-salt`](https://github.com/g2g/vim-snippets-salt/commit/c4b6205a00)**
adds a 2019-01-15 generator fix, importing `salt.version` and explicitly selecting
Python 2. Useful historical bug evidence, not a modern Python 3 generator.
Its repository license remains unspecified. The other fork adds no unique commit.

### 3. Editor-independent tooling and LSP (separate ownership scope)

**Historical inventory, not the current roadmap:** the user maintains Salt LSP
functionality in another repository. The LSP entries below preserve prior research;
they do not propose adopting, implementing or maintaining an LSP in salt-vim.

| Project | Verified capability, activity and proposed role |
| --- | --- |
| [`dcermak/salt-lsp`](https://github.com/dcermak/salt-lsp/tree/1442c42132) | Non-archived, Apache-2.0, 24 stars. README explicitly calls it an early prototype, says Jinja support was not solved and original authors lack time. Head 2023-06-29 is a maintenance-warning merge, **not** a new language implementation. Inspected `server.py` registers state/include completion, requisite go-to-definition and document symbols; parser scans YAML. Keep separate from the Vim plugin, with tests/trust boundaries, if adopted later. |
| [`lkubb/salt-lsp`](https://api.github.com/repos/dcermak/salt-lsp/compare/HEAD...lkubb:main) | Non-archived Apache-2.0 fork of dcermak, **14 ahead commits**. Substantive 2025-05 changes upgrade pygls to 1.3.1 and logging/build behavior; 2025-08-18 makes state-data location configurable and drops Python 3.8; 2025-08-19 head is formatting. **Best packaging/API modernization donor**, not evidence of a solved mixed-language parser. Source can regenerate state data via Salt and loads pickle data: do not treat arbitrary downloaded pickle files as safe. |
| [`ekacnet/salt-lsp`](https://api.github.com/repos/dcermak/salt-lsp/compare/HEAD...ekacnet:main) | Non-archived Apache-2.0 fork, **15 ahead commits**. Functional Jinja/parser and completion work 2023-10 through 2024-01-11; head 2024-01-16 includes lint/docs. **Most interesting semantic experiment**: source renders through ordinary `jinja2.Environment` with filesystem loader and fake `grains`/`pillar`/`salt`, skips `{% from ... %}` lines, then scans rendered YAML. This is not full Salt rendering or an inert parser; source-position fidelity and template execution/trust require review before reuse. |
| [`linw1995/salt-lsp`](https://api.github.com/repos/dcermak/salt-lsp/compare/HEAD...linw1995:main) | Non-archived Apache-2.0 fork; two 2024-10-09/10 packaging commits add PDM/Nix flake and completion-data generation at build time. Useful Nix packaging reference, no parser fix. |
| [`warpnet/salt-lint`](https://github.com/warpnet/salt-lint/commit/172f9121d82ff8452f7852877ccf34b33b50db8e) | Non-archived MIT editor-independent linter; latest code 2026-05-06 adds Code Climate output. Existing integration partner, **not** functionality that needs moving inside salt-vim. Do not confuse with older `johanek/salt-lint` or the nonexistent `saltstack/salt-lint` path. |

The [salt-lsp fork endpoint](https://api.github.com/repos/dcermak/salt-lsp/forks?per_page=100)
returned nine public entries although metadata reports eleven forks; all nine
were compared. `klippo` has older pygls modernization (2023-08), overlapping
lkubb; `benatouba` and `arvin422` are identical to original head, while `koppchen`,
`cbosdo` and `agraul` are behind with no unique default-branch commits. This is
not proof that non-default branches or unreturned forks have nothing useful.

**Existing Vim/Neovim lint adapters are also consolidation references, not new
Salt language servers:** source-confirmed
[`dense-analysis/ale`](https://github.com/dense-analysis/ale/blob/master/ale_linters/salt/salt_lint.vim)
registers `salt` and parses `salt-lint --json`;
[`nvimtools/none-ls.nvim`](https://github.com/nvimtools/none-ls.nvim/blob/main/lua/null-ls/builtins/diagnostics/saltlint.lua)
registers `sls`, runs on save and maps JSON severities. Alongside our existing
`mfussenegger/nvim-lint`, they show why filetype compatibility matters. These
specific files were inspected, not the full projects' histories/licenses;
prefer documented integrations over copying their adapters or enabling multiple
diagnostic owners simultaneously.

### 4. Other-editor donors worth studying, not direct Vim plugins

| Repository | Maintenance evidence and consolidation value |
| --- | --- |
| [`naqoyqatsi83/salt-syntax`](https://github.com/naqoyqatsi83/salt-syntax/tree/1174b954a6d20c098d8eb87db2c4ea932bd1e690) | Non-archived MIT VS Code extension. Latest functional commit 2026-10-03 (`ba73f70c58`) adds Salt-release introduction hints; 2026-10-05 head only edits agent docs. **Strong modern fixture/metadata donor:** README describes version-selected real Salt signatures, templated-key grammar, argument checks, block matching, preview and source mapping. Tree inspection confirms corresponding source and numerous parity/preview/grammar tests, but behavior/coverage claims were not executed or independently proven. Preview renders Jinja/Python; do not adopt automatic rendering while browsing untrusted projects. |
| [`akrikun/saltstack-toolkit`](https://github.com/akrikun/saltstack-toolkit/tree/6ab566937a) and [`saltstack-toolkit-jetbrains`](https://github.com/akrikun/saltstack-toolkit-jetbrains/tree/9d44379f2b) | Both non-archived MIT, code changes through 2026-10-01. README claims navigation, completions, snippets, Saltcheck and pillar support; source trees confirm providers/implementations, shared fixture shapes and tests, not an editor-independent LSP. VS Code completion/definition provider files were inspected. Good feature/fixture and snippet donors, **not drop-in Vim code**. VS Code README enables formatting-on-save and leading trim-tag enforcement by default; those policies must not be silently imported. |
| [`relkian/zed-extension-salt`](https://github.com/relkian/zed-extension-salt/tree/fd92b89466), 2026-09-21 | Non-archived Apache-2.0; source confirms outer Jinja grammar and **combined YAML injection into `(content)` nodes**. Uses `relkian/tree-sitter-jinja` fork of cathaysia; extension manifest explicitly describes an untouched availability/security mirror, not a new Salt parser. Useful concrete mixed-language query architecture to test in Neovim, unlike assuming the nvim-treesitter registry already injects YAML. |
| [`perfecto25/zed-saltstack-jinja`](https://github.com/perfecto25/zed-saltstack-jinja/tree/1529364192), 2026-03-19 | Non-archived MIT extension. Source instead uses geigerzaehler's grammar and combined `SaltStack YAML` injection into `(text)` nodes. Different node schemas mean queries are **not interchangeable** with cathaysia. Separate extension licensing does not establish permission to redistribute the underlying grammar. |
| [`vmware-archive/sublime-text`](https://github.com/vmware-archive/sublime-text/tree/f8a8cf90b1), code 2016-04-01 / merge 2016-05-25 | Archived official-era Salt syntax/snippet bundle, Apache license file despite API `NOASSERTION`. Broad Salt/Jinja snippet corpus and TextMate/Sublime grammars are potential attributed donors after per-file provenance/API modernization checks. Not a Vim runtime. |

### 5. Proposed consolidation sequence

1. **Establish the continuation base** from original `6ca9e35` (or its clean
   one-commit-ahead terminalmage tip), preserving history, license and notices.
   Document community maintenance rather than implying an official transfer.
2. **First release: safe language support.** Review terminalmage's keyword delta;
   add regression fixtures from the two regexp forks; remove forced engine and
   destructive match/autocmd/global-setting behavior after testing. Provide
   proper ftplugin/indent guards and undo. Explicitly support/document both
   historical `sls` and native `salt` consumers; do not change all YAML files.
3. **Use modern Jinja as a dependency/composition baseline**, working with
   HiPhish/native runtime where appropriate. Test Salt extensions separately.
   Study Glench/lepture only for gaps and fixtures, not as evidence that
   HTML-oriented indentation handles YAML/Jinja safely.
4. **Add optional capabilities independently.** Folding: pedrohdz/noseka1/Kagemaru
   ideas after permission checks. Snippets: modern MIT toolkit/salt-syntax data
   and licensed official-era Sublime material first; old unlicensed generators
   and snippet collections only after permission/provenance resolution. Keep a
   curated subset plus versioned generation/validation rather than importing
   obsolete state signatures wholesale. Linters stay external integrations.
5. **Experimental track, not release prerequisite:** test both Zed injection
   designs and raw-block fixtures for optional Neovim highlighting. Salt LSP work
   remains in the user's separate repository, outside this continuation's roadmap.
   Do not claim Jinja semantics, source mapping or safe rendering are already solved.

### 6. Discovery breadth, exclusions and limitations

- Queried GitHub repository search for `salt vim`, `saltstack vim fork:true`,
  `saltstack neovim`, `sls vim`, Salt snippets/editor/language variants,
  `salt-lsp`, `salt language server` and `tree-sitter-salt`; used README searches
  and code searches for `sls.vim`, Salt/Vim/Lua and Salt documentation references.
  Inspected the original 72-fork network, all returned small Salt plugin
  networks, 15 YAML-fold forks, nine LSP forks and five geigerzaehler forks.
  Broad README searches had hundreds/thousands of matches: only the first
  100 results per query were retrieved, not an exhaustive dotfile audit.
- Public GitLab project API searches for `salt-vim`, `vim-salt`, `salt-lsp` and
  `tree-sitter-salt` returned empty lists. This does **not** exclude projects
  under other names, unindexed content, private projects or historical mirrors.
  HiPhish's already-identified GitLab upstream remains relevant.
- Checked Salt's [community projects source](https://github.com/saltstack/salt/blob/master/doc/topics/projects/index.rst)
  and [YAML troubleshooting docs](https://docs.saltproject.io/en/latest/topics/troubleshooting/yaml_idiosyncrasies.html).
  These did not reveal an additional editor-plugin directory; current Salt
  repository search for `salt-vim` returned no matches. This is not a claim that
  every historical Salt documentation version was searched.
- GitHub code-search eventually returned **rate-limit errors** on follow-up
  `"vim-salt"` and SLS-query searches; earlier successful repository, tree,
  fork and compare calls supplied the inventory above. No assertion of global
  completeness; non-default branch changes and full Jinja fork networks remain
  follow-up work. Adapter references and a few low-priority snippet leads are
  live links rather than pinned/full-history audits, explicitly noted above.
- Excluded `egonSchiele/salt-vim` / `GaloisInc/vim-salty` (other Salty languages),
  `jkoz/vim-sls` (Simple Language Server), `basyura/vimshell-sls` (ls command),
  unrelated password-salting projects, and ordinary install/configure formulas.
  `nooranordenstedt/salt-vim` contains `vim/init.sls`, not editor support;
  `gmarone/salt-vim` is empty. **Exception worth recording:** provisioning repo
  [`saltstack-formulas/vim-formula`](https://github.com/saltstack-formulas/vim-formula/tree/master/vim/files/salt)
  actually vendors old Salt syntax/ftplugin files (last path change 2018-04-18);
  inspected syntax is the earlier Django/YAML implementation, not a new plugin
  or preferred base. Its provisioning role alone should not hide copied code.

Only this existing report was edited. No plugin installation, fork creation,
owner contact, issue/PR creation, rendering, execution of downloaded code or
editor implementation occurred; `lazy-lock.json` was left untouched.

## Glench/Jinja fork investigation — 2026-11-04

Read-only follow-up using primary GitHub metadata, source, commit, compare,
branch and pull-request APIs. No downloaded plugin code was executed, sourced
in an editor or used to render templates. This section supersedes the earlier
limitation that the Glench fork network remained unexamined.

### Coverage and meaningful donors

[`Glench/Vim-Jinja2-Syntax`](https://api.github.com/repos/Glench/Vim-Jinja2-Syntax)
is non-archived, BSD-3-Clause, default `master` at `2c17843b074b` (2021-06-22).
The [fork endpoint](https://api.github.com/repos/Glench/Vim-Jinja2-Syntax/forks?per_page=100)
returned **68 public forks**, versus metadata's **71**. Every returned default
branch was compared with that upstream tip: **20 ahead, 16 identical, 32 behind
without unique commits**. Branch lists for all 68 returned forks exposed **19
additional non-default branches**, all also compared. Most are already-merged
contribution branches; useful exceptions appear below. All upstream PRs returned
by the API were inspected at metadata level, with selected patches read directly.
This covers returned branches, not deleted/private/unreturned forks, unpublished
work or every PR-only ref. No API rate-limit failure occurred in this follow-up;
the earlier report's code-search rate-limit caveat still applies to that search.

| Donor / exact change | Audit result and reuse priority |
| --- | --- |
| [`haggishunk`, non-default `fix/filetype-detection-regex`, `9d4bb5faccaf`](https://github.com/Glench/Vim-Jinja2-Syntax/pull/39), 2025-12-26; [`sebastianmathes`, `275e567d2916`](https://github.com/sebastianmathes/Vim-Jinja2-Syntax/commit/275e567d29162059cb36e6db95471c4f0fede73a), 2026-07-23 | **Same one-line fix, not two features:** replace the unescaped alternation in `htm\|nunj|jinja\|j2` with `htm\|nunj\|jinja\|j2` in syntax host selection. PR #39 reports Neovim 0.11.5 `E169: Command too recursive` and `main_syntax` errors. Source explains a self-load route for `.jinja` when the runtime contains `syntax/jinja.vim`. Best concrete generic bug donor; PR remains open. Neither patch fixes the same malformed regexp in `indent/jinja.vim`. |
| [`ningsuhen`, non-default `macro-indent`, functional `f894b9ed7c48`](https://github.com/ningsuhen/Vim-Jinja2-Syntax/commit/f894b9ed7c48), 2020-05-23 | **Useful missing indent delta:** accepts `{%-`/`-%}` in tag recognition, plus reformatting; branch has three ahead commits including merges. Macro support itself was already merged upstream, so do not count that again. Still no `+` support or YAML-aware indentation. A fixture/fix donor, not a complete mixed-language engine. |
| [`dzeban`, default `518dee8d65f8`](https://github.com/dzeban/Vim-Jinja2-Syntax/commit/518dee8d65f8cd7335aa21bb679d838aef30de64), 2025-10-21; [closed, unmerged upstream PR #38](https://github.com/Glench/Vim-Jinja2-Syntax/pull/38) | Default branch only adds explicit `elif`/`for` keywords and a sample file (plus merge). **PR-only `d1f2052e79c3` additionally adds vim-matchup middle-block rules** for if/elif/else and for/else; these are absent from the returned branch tips. Useful navigation design/fixtures after review, not proven matching correctness. Default sample includes Python-style comprehension/`elif`-expression examples that are not valid ordinary Jinja; do not import it as an authoritative passing language corpus. |
| [`AckslD`, non-default `only-syntax`, `c7341be098ed`](https://github.com/AckslD/Vim-Jinja2-Syntax/commit/c7341be098ed), 2022-02-09 | Deletes detection, ftplugin and indent, retaining syntax. **Boundary precedent**, not improved parsing: users wanted syntax without unrelated editor policy. |
| [`denisalevi`, `84226e17b898`](https://github.com/denisalevi/Vim-Jinja2-Syntax/tree/84226e17b898766664a3b716ecc4350d57cd1b83), 2017-10-12 | Eight ahead / 34 behind: C++/CUDA dotted filetypes, embedded-region overlay, highlighting/matchit switches, named-end matching. Explicit history says it assembled chase and PR #5/#10/#13 ideas. Interesting host-composition/navigation precedent, **not a preferred full-tree base**; GPL-marked ftplugin and extra global functions/runtime loading require separate review. |
| [`nnnell/jinja2-alt-delimiters`, non-default `mods`, `1e303b2044eb`](https://github.com/nnnell/jinja2-alt-delimiters/tree/1e303b2044eb), 2023-05-16 | Renames support to `jinjaalt` and substitutes `[[...]]`, `[%...%]`, `[#...#]`; six ahead commits including merge. Genuine custom-delimiter experiment, **not Salt-default syntax** or a configurable general delimiter engine. |
| [`gabesoft`, `6040c1d356a5`](https://github.com/gabesoft/vim-jinja2-syntax/commit/6040c1d356a59a260b2ce42d90d088ee9c98fb92); [`MaicoTimmerman`, `2d27640cca83`](https://github.com/MaicoTimmerman/Vim-Jinja2-Syntax/commit/2d27640cca83c5ff36c9ff3f20475459bdb01840) | Historical copies of the Steve Losh-attributed Jinja-over-HTML indentation pattern. Upstream already incorporated the same substantive approach in [`2650ec3ff385`](https://github.com/Glench/Vim-Jinja2-Syntax/commit/2650ec3ff385). An ahead SHA does **not** establish an unmet feature. |
| [`chase`, `dfe3fe9a235c`](https://github.com/chase/Vim-Jinja2-Syntax/commit/dfe3fe9a235c582fc963bb0f0f19806ed8be229f); [`icook`, `21c17d369423`](https://github.com/icook/Vim-Jinja2-Syntax/commit/21c17d369423dc240850d92f947bea7e42d97705) | Historical matchit/Endwise approaches, with GPL-3.0-or-later ftplugin headers. Chase loads HTML, HTML indent and optional Eclim runtime; its endwise word list includes `while`, not an ordinary Jinja statement. Study navigation behavior, not a clean permissively licensed drop-in. |

The remaining default-branch differences are detection/host-policy changes, not
Salt implementations: `armyers` adds `.tpl`; `hankchiutw` drops interpolation-only
HTML detection to avoid Angular conflicts; `kbulygin` adds XML/dotted types;
`barlik`/`infokiller` use dotted HTML types; `Valloric` adds Jinja extensions
already substantively supported upstream; `hwgao` sets `.yaml.jinja` to plain
`yaml` without supplying a Jinja overlay; `wltr` unconditionally adds SystemVerilog;
`jiexu` specializes for C; `studio-vx` removes syntax guards; `joehanchoi` disables
HTML indentation. `jyyan`/`yukpiz` are **Volt/PHP**, not Salt/Jinja continuations.
Non-default `naokirin/add_extension_jj2` adds `.jj2`;
`schrodervictor/php-experiment` loads PHP for `.php.j2` and leaves a debug global.
These may supply detection/conflict fixtures, not a better general base.

**Concise donor shortlist:** generic self-loading fix (`haggishunk` or
`sebastianmathes`, once); trim-tag indent fixtures (`ningsuhen`); reviewed
middle-block navigation ideas (dzeban PR-only patch); policy separation (AckslD).
No audited fork demonstrated a maintained, tested Salt YAML/Jinja indentation
implementation. For ownership, Glench `2c17843b074b` plus selected audited deltas
is more traceable than adopting a heavily diverged fork. That is an available
generic continuation base, **not a requirement to launch a second project**.

### Actual runtime behavior and composition limits

At the [inspected Glench tree](https://github.com/Glench/Vim-Jinja2-Syntax/tree/2c17843b074b06a835f88587e1023ceff7e2c7d1)
there are only README/license plus one detection, syntax, ftplugin and indent file;
no test suite, snippets, lint adapter, Salt renderer handling or Salt vocabulary.

- **Syntax:** variables/attributes, arbitrary filter names, strings, numbers,
  nested braces/brackets/parentheses, raw regions and comments. Generic tag-name
  highlighting already accepts names beyond its explicit keyword list, so
  dzeban's added keywords do not establish that `{% for %}` was wholly unsupported.
  The 2021 `+` patch changes tag delimiters/statement matching and matchit starts;
  it does **not** update filetype detection or indentation. Raw-region delimiters
  remain untrimmed-only (`{% raw %}`/`{% endraw %}`), unlike generic tag delimiters.
- **Host selection is not a YAML/Jinja parser:** `g:jinja_syntax_html` defaults
  on; syntax attempts to load the final filename extension's runtime syntax,
  otherwise HTML. `.sls` would look for `syntax/sls.vim`, while `.yaml.jinja`
  does not infer the preceding `.yaml`. Disabling the global prevents host loading
  but does not itself compose YAML. Guard/unlet behavior must be tested when Salt
  first loads YAML then Jinja; switching plugin order can select different providers.
- **Detection:** scans only lines 1–49 of HTML/Nunjucks-like files for selected
  tags/interpolations and assigns `jinja.html`; directly assigns `jinja` to
  `.jinja2/.j2/.jinja/.tera`. It neither detects `.sls` nor interprets shebang
  renderers. Uses `set ft=...`, not a preserve-existing-filetype decision. Detection
  still misses a template whose only qualifying tag starts `{%+`.
- **Ftplugin:** sets Jinja block comments and `formatoptions+=tcqln`; provides
  matchit start/end matching plus HTML rules, **not** full middle-block navigation.
  Checks `b:did_ftplugin` without setting it; undo restores the three options but
  not `b:match_*`. Mixed-filetype ordering can therefore skip settings after the
  host sets its guard, or leave buffer variables after a filetype change.
- **Indent:** conditionally loads HTML, then adds/subtracts raw `&sw` around a
  fixed tag list on adjacent nonblank lines. No YAML sequence/mapping/block-scalar
  model, Salt `load_yaml`/`load_text`/`import_yaml` rules, trimmed opening tags in
  upstream, or block `set`/`endset` in the block list. It defines global
  `GetDjangoIndent()` only if absent: whichever Django/Salt/Jinja plugin defines
  that name first wins. It sets `b:did_indent` but adds no own `b:undo_indent`;
  any inherited HTML undo is insufficient evidence of full cleanup.
- **Vim and Neovim:** implementation is ordinary legacy Vimscript with no Lua,
  Tree-sitter or Neovim API requirement. That makes it a portability donor, not
  proof of correctness on every editor version. Multiple installed Jinja plugins
  compete for `syntax/jinja.vim`, `ftplugin/jinja.vim`, `indent/jinja.vim`, syntax
  group names and detection autocmds; `runtime!` may source multiple copies.
  Use one explicit Jinja owner, and test runtime-path ordering and guard cleanup.
  Tree-sitter highlighting/indentation is a separate Neovim ownership decision.

### Provenance and licensing, not just GitHub fork labels

Glench's [merged PR #26](https://github.com/Glench/Vim-Jinja2-Syntax/pull/26)
contains a direct statement from Jinja maintainer David Lord: he was removing
the syntax file from the Jinja repository because he did not know Vim and could
not maintain it responsibly. Glench repeatedly imported official syntax updates
through 2020. Thus it is not an unrelated independent Jinja implementation.

HiPhish's [README][hiphish-readme] separately credits adapting Armin Ronacher's
official syntax; GitHub metadata marks it **not a fork** of Glench. Its
[LICENSE.txt](https://github.com/HiPhish/jinja.vim/blob/d3ab7a8f9d084aa30e93e8d891c872ab32cdbb34/LICENSE.txt)
specifically preserves **BSD-3-Clause for `syntax/jinja.vim`**, MIT for other
parts. Shared official ancestry is verified; direct Glench→HiPhish Git history
was not established. Its dotted-host composition and test suite make it a useful
baseline, but it is **not a feature superset**: the inspected syntax still uses
minus-only tag delimiters, versus Glench's explicit `+` handling. Compare behavior
with fixtures rather than assuming the newer repository date solves every gap.

`lepture/vim-jinja` is also not a GitHub-network fork. Its indent source shares
the Evan Hammer/Steve Losh-attributed `GetDjangoIndent()` structure and adds trim
handling; this establishes source similarity, not the direction or permission
of every transfer. Its syntax is materially different, HTML-oriented and
enumerates filters; `raw` is a keyword rather than a dedicated raw-body region.
No repository-wide redistribution license was identified; preserve this caveat.

[`ben-grande/vim-jinja`](https://github.com/ben-grande/vim-jinja/tree/35fa42156468bbbcf63c4c9d9ea67e538f89301b)
is an explicitly unsupported compilation, not a network fork. Its syntax and
ftplugin **directly credit Glench**; syntax/indent headers say BSD-3-Clause,
ftplugin says Vim license. Those added labels are provenance evidence, not
independent proof that every copied contributor authorized relicensing. Its
syntax also adds YAML-comment exceptions/line-comment behavior, so it should
not be mistaken for neutral unchanged generic Jinja.

Glench's current BSD license requires retained copyright/conditions/disclaimer,
binary-documentation notices and no endorsement. Keep these notices alongside
the Salt continuation's Apache notices; do not relabel imported code as solely
Apache/MIT. **Older chase/icook/denisalevi ftplugins explicitly carry GPL-3.0-or-later**;
a current upstream BSD file does not retroactively erase those donor headers.
These forks also predate Glench's 2019 license addition. Resolve per-file
permission, preserve applicable GPL obligations if deliberately incorporating
that material, or independently implement the desired behavior. This is a
specific consolidation gate, not a reason to abandon maintenance ownership.

## Proposed product scope and release gates — 2026-11-04

**Approved for implementation on 2026-11-04:** maintain **one Salt-focused Vim plugin
initially**, with an explicit generic Jinja dependency/runtime contract. Do not
automatically create a second generic Jinja fork. A second owned project is
justified only by a reproduced reusable gap and a deliberate commitment to its
broader maintenance responsibility, not repository dates or numbers of donors.
The fork audit supplies worthwhile fixes/fixtures, not proof that two public
products are necessary. Internally separate host composition and Salt extensions
so a future generic extraction remains possible.

**In scope:** portable Vimscript for Vim **and** Neovim; canonical native `salt`
filetype plus documented legacy `sls` compatibility; renderer-sensitive detection
that does not overwrite an existing correct decision or claim all YAML; reuse
one chosen generic Jinja provider; own Salt globals/extensions/requisite rules;
safe buffer-local settings with complete undo; curated modern, licensed snippets;
documented external lint integrations. Optional indentation and folds require
fixtures proving their behavior, with no forced formatting or fold preference.

**Out of scope:** Salt LSP implementation or completion-metadata pipeline (owned
in the user's other repository), template rendering, executable/environment
management, project task orchestration, state execution, and blanket ownership
of YAML/Jinja tooling. Optional Neovim Tree-sitter support may follow; it is not
a prerequisite and must not replace the portable baseline without equivalent tests.

1. **First release:** traceable continuation base; reviewed Salt keyword delta;
   native/legacy filetype contract; syntax/ftplugin cleanup; no forced regexp
   engine, destructive match clearing, global dictionary replacement or wildcard
   autocmd effects. Synthetic regression suite and CI on declared supported Vim
   and Neovim versions are release gates, not future nice-to-haves.
2. **Required fixtures:** both filetypes; YAML quoted/unquoted templating,
   templated keys and block scalars; nested Jinja, raw/trimmed raw and whitespace
   control; Salt extension blocks; Python renderer detection; unrelated YAML/HTML
   unaffected; filetype switches/undo; dependency/runtime-path order; no plugin
   source recursion or global indent-function collision. Highlight assertions
   and option-state checks must not execute templates or project commands.
3. **Next:** modern licensed snippets with current-Salt review, then opt-in
   indentation/folds only after mixed-language regression fixtures demonstrate
   value. Document ALE/nvim-lint/none-ls filetype integration without running
   multiple diagnostic owners by default. Consider generic Jinja upstream fixes
   or a second project on their merits; neither blocks the first Salt release.

### Implementation follow-through — 2026-11-04

After the research was completed, the user approved this proposal and explicitly
chose a GitHub fork plus sibling checkout. Created
[`benatouba/salt-vim`](https://github.com/benatouba/salt-vim) from the archived
original, preserving its history, with checkout at `/home/ben/projects/salt-vim`.
The foundation is being implemented there, not in this Neovim configuration.
Earlier statements that no forks or plugin execution occurred describe the
research passes only, before this approval.

The implementation reuses one generic Jinja syntax provider; it does not fork
Glench or copy its indent/ftplugin. Actual editor tests now exercise runtime,
pinned HiPhish and Glench syntax, including safe host composition and restored
globals. Runtime-path testing reproduced a multiline synchronization difference;
the Salt host now synchronizes from the start of the buffer for correctness.
The synthetic trimmed-raw fixture also reproduces a generic-provider defect:
`{%- raw -%}` does not prevent interpolation highlighting. An explicit failing
probe records this as a release blocker; it is not silently counted as passing.
Snippets, custom indentation/folds, Tree-sitter and LSP remain outside this
foundation. No release or upstream PR has been published.

Later on 2026-11-04 that blocker was fixed in the plugin: all three providers
share one raw pattern that rejects whitespace control, so `syntax/salt.vim`
extends their `jinjaRaw` group, and the assertions are now blocking. This
configuration was also migrated to the plugin as a lazy.nvim development
checkout. `syntax/sls.vim` no longer exists here, so the comparison table above
and its links describe the state before that migration.

## Primary sources

Repository API links are live metadata snapshots; source links are pinned.

[salt-old]: https://api.github.com/repos/saltstack/salt-vim
[salt-repo]: https://api.github.com/repos/vmware-archive/salt-vim
[salt-license]: https://github.com/vmware-archive/salt-vim/blob/6ca9e3500cc39dd417b411435d58a1b720b331cc/LICENSE
[salt-syntax]: https://github.com/vmware-archive/salt-vim/blob/6ca9e3500cc39dd417b411435d58a1b720b331cc/syntax/sls.vim
[salt-ftplugin]: https://github.com/vmware-archive/salt-vim/blob/6ca9e3500cc39dd417b411435d58a1b720b331cc/ftplugin/sls.vim
[keitheis]: https://github.com/keitheis/vim-salt/tree/9e47db63a39c12e14a1356bffb1177449ccfefe1
[ben-grande]: https://github.com/ben-grande/vim-salt/tree/3bedc0a08aa1cfda9d7824309a20fa69a210eff1
[salt-jinja]: https://github.com/kmalinich/salt-jinja-vim/tree/f30b3870c244057e4556ba083615180f896c0be9
[stephen]: https://github.com/StephenPCG/vim-snippets-salt/tree/bbf6f5e73295a0773a809c515e7bc892fc63a963
[thaligar]: https://github.com/thaligar/vim-salt-autocomplete/tree/71cd5c482ec6964906ef9a4bb930dd08958ac46f
[nvim-filetype]: https://github.com/neovim/neovim/blob/b4d549f439e833f4e4b58770ac03caa641a71efe/runtime/lua/vim/filetype.lua
[nvim-salt]: https://github.com/neovim/neovim/blob/b4d549f439e833f4e4b58770ac03caa641a71efe/runtime/syntax/salt.vim
[nvim-jinja]: https://github.com/neovim/neovim/blob/b4d549f439e833f4e4b58770ac03caa641a71efe/runtime/syntax/jinja.vim
[ts-parsers]: https://github.com/nvim-treesitter/nvim-treesitter/blob/0195cd62fa89950f34c0e0d648ea7897ab85d4d3/lua/nvim-treesitter/parsers.lua
[ts-inject]: https://github.com/nvim-treesitter/nvim-treesitter/blob/0195cd62fa89950f34c0e0d648ea7897ab85d4d3/runtime/queries/jinja/injections.scm
[jinja-repo]: https://api.github.com/repos/cathaysia/tree-sitter-jinja
[apache]: https://www.apache.org/licenses/LICENSE-2.0
[nvim-contributing]: https://github.com/neovim/neovim/blob/b4d549f439e833f4e4b58770ac03caa641a71efe/CONTRIBUTING.md
[vim-salt-add]: https://github.com/vim/vim/commit/89b9bb4ac8ceb701ebecb8c02aca3d047dff9991
[hiphish-readme]: https://gitlab.com/HiPhish/jinja.vim/-/blob/d3ab7a8f9d084aa30e93e8d891c872ab32cdbb34/README.rst
[hiphish-contributing]: https://gitlab.com/HiPhish/jinja.vim/-/blob/d3ab7a8f9d084aa30e93e8d891c872ab32cdbb34/CONTRIBUTING.rst
[local-detect]: ../lua/config/autocmds.lua
[local-ftplugin]: ../after/ftplugin/sls.lua
[local-syntax]: ../syntax/sls.vim
[local-snippets]: ../snippets/salt.json
[local-lint]: ../lua/plugins/linting.lua
[local-format]: ../lua/plugins/formatting.lua
[local-ts]: ../lua/plugins/treesitter.lua
[local-tasks]: ../lua/overseer/template/user/salt.lua
