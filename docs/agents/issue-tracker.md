# Issue tracker: GitHub

Issues and specs live in GitHub Issues for `benatouba/nvim`.
Use the `gh` CLI for all operations.

This clone has both GitHub and GitLab remotes. Pass
`--repo benatouba/nvim` to every `gh issue` or `gh pr` command;
use `repos/benatouba/nvim/...` for REST API endpoints.

## Conventions

- **Create**: `gh issue create --repo benatouba/nvim --title "..." --body "..."`
  For multi-line bodies, use `--body-file -` with a heredoc.
- **Read**: `gh issue view <number> --repo benatouba/nvim --comments`.
  Fetch labels and structured comments with `--json number,title,body,labels,comments`.
- **List**: `gh issue list --repo benatouba/nvim --state open --json number,title,body,labels,comments`.
  Add appropriate `--label` and `--state` filters; use `--jq` to filter the JSON.
- **Comment**: `gh issue comment <number> --repo benatouba/nvim --body "..."`
- **Label**: `gh issue edit <number> --repo benatouba/nvim --add-label "..."` or `--remove-label "..."`
- **Close**: `gh issue close <number> --repo benatouba/nvim --comment "..."`

## Pull requests as a triage surface

**PRs as a request surface: no.**

If changed to `yes`, use the `gh pr` equivalents for reading,
commenting, labelling, and closing. Read the diff with `gh pr diff`.
For external PR triage, retain authors whose association is
`CONTRIBUTOR`, `FIRST_TIME_CONTRIBUTOR`, or `NONE`.
Fetch author association through `gh api` if needed.

GitHub shares issue and PR numbers. When the type is unknown,
try `gh pr view <number>` and fall back to `gh issue view <number>`.

## When a skill says "publish to the issue tracker"

Create a GitHub issue.

## When a skill says "fetch the relevant ticket"

Run `gh issue view <number> --repo benatouba/nvim --comments`.

## Wayfinding operations

Used by `/wayfinder`. The map is one issue with child issues as tickets.

- **Map**: create an issue labelled `wayfinder:map`, holding the
  Notes / Decisions-so-far / Fog body.
- **Child ticket**: link it to the map through GitHub's sub-issues API.
  If unavailable, add it to a task list in the map and put `Part of #<map>`
  at the top of its body. Use `wayfinder:<type>` labels
  (`research`, `prototype`, `grilling`, or `task`).
- **Blocking**: use native issue dependencies:
  `gh api --method POST repos/benatouba/nvim/issues/<child>/dependencies/blocked_by -F issue_id=<blocker-db-id>`.
  Get the numeric database ID with
  `gh api repos/benatouba/nvim/issues/<blocker> --jq .id`.
  If dependencies are unavailable, put `Blocked by: #<n>, #<n>`
  at the top of the child body. All blockers must be closed.
- **Frontier**: list the map's open children, exclude assigned tickets
  and tickets with open blockers, and select the first in map order.
  Native dependencies expose the live gate as
  `issue_dependencies_summary.blocked_by`.
- **Claim**: `gh issue edit <n> --repo benatouba/nvim --add-assignee @me`,
  as the session's first write.
- **Resolve**: comment with the answer, close the ticket, and append
  a context pointer (gist + link) to the map's Decisions-so-far.
