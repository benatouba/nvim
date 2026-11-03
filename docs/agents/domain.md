# Domain Docs

This repo uses a single-context layout:
- `GLOSSARY.md` at the repository root.
- `docs/adr/` for architecture decision records.

## Before exploring

Read the root `GLOSSARY.md` and ADRs relevant to the area of work.

If these files or directories are absent, proceed silently.
`/domain-modeling`, also reached through `/grill-with-docs` and
`/improve-codebase-architecture`, creates them lazily as terms
and decisions are resolved.

## Use the glossary's vocabulary

Use the glossary's terms when naming concepts in issue titles,
refactor proposals, hypotheses, and tests.

If a needed concept is missing, reconsider whether it fits the
project's language; note genuine gaps for `/domain-modeling`.

## Flag ADR conflicts

Explicitly surface proposals that contradict an existing ADR,
identifying the ADR and explaining why the decision merits reopening.
