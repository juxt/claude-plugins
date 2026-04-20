---
name: weed-docs
description: Audit technical documentation for drift against a code change. Produce a punch list of user-facing docs pages that probably need updating. Use when the user says "weed the docs", "check docs for drift", "audit docs against this diff", "which docs does this change affect", "/chalk:weed-docs", or is about to open a PR and wants a docs-impact check.
version: 0.1.0
user-invocable: true
disable-model-invocation: false
---

# Weed — Documentation Drift Audit

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

Given a code change, identify the user-facing docs pages that probably need updating.
Mirror of `allium:weed` for prose: audit, don't edit.
This skill reports drift; resolving it is a separate step (often via `chalk:tend-docs`).

## Your Responsibilities

1. **Determine the audit scope.**

   Default: the current branch's diff against its base branch (usually `main` or `master`).
   If the user provides a commit, commit range, or path, use that instead.

   If the diff is empty (nothing to audit), say so and stop.

2. **Enumerate the code surfaces that changed.**

   Walk the diff and extract the things a docs page could mention:

   - **Renames** — classes, functions, modules, config keys, CLI flags, environment variables.
   - **Signature changes** — added/removed/renamed parameters, changed return types, changed error types.
   - **Behavioural changes** — changed defaults, new required fields, relaxed/tightened constraints.
   - **New public surfaces** — new commands, endpoints, config keys, public APIs.
     These have *no* existing docs; the audit must flag them as coverage gaps.
   - **Removed surfaces** — deleted commands, endpoints, config keys.
     Docs that still reference them are stale.
   - **Error messages and log lines** — if a docs page quotes them, they need updating.
   - **Examples in the code** — if docstrings or README snippets changed, paired docs examples may need syncing.

   Internal refactors that don't change observable behaviour don't need docs updates.
   Don't flag them.

3. **Cross-reference the issue-graph neighbourhood.**

   Code surfaces are the left-hand column of the audit; intent is the right-hand column.
   If chalk is active (or if the diff references an issue/PR), cast one hop out:

   - The **tracked chalk issue** and its comments.
   - **Related issues** — parent, sub-issues, blocked-by, blocks.
     See the "Issue Relationships" section of the main chalk skill.
   - The **PR description and review discussion**.

   What to harvest:

   - **Stated intent for new public surfaces** — turns a bare coverage-gap item ("no docs for `--foo` flag") into a rationaled one ("no docs for `--foo`; issue #123 names it as the way operators opt into Y").
   - **Operational invariants and failure modes** named in review discussion — often absent from the diff but load-bearing for the docs page that covers the feature.
   - **Paired behaviour** — a sub-issue that names a knock-on behaviour change in another module points at docs pages for that module too.

   This section is about improving the *quality* of the punch-list items, not expanding their scope.
   The diff still drives what's flagged; the issue graph sharpens why.

3. **Locate the docs tree.**

   Look for the conventional root (e.g. `docs/`, `website/`, `content/docs/`).
   If there's a docs README (e.g. `docs/README.md`), read it — it names the site structure and any quadrant layout.

   If there's no identifiable docs tree, say so and stop.
   Drift-auditing against nothing is nothing.

4. **Scan for references.**

   For each code surface that changed, search the docs tree for:
   - Literal mentions of the name (fully-qualified and short forms).
   - Mentions of the concept or behaviour, even if the name is different.
   - Code snippets, config blocks, CLI examples, SQL queries, YAML — these drift silently.
   - Cross-links that point to removed/renamed pages.

   A hit isn't always drift.
   A page mentioning a class name might still be accurate.
   Your job is to flag *candidates* for human review, with enough context that the reviewer can judge in seconds.

5. **Classify each hit by confidence.**

   - **High confidence** — the page names something that was renamed or removed, and the current text is demonstrably wrong.
   - **Medium confidence** — the page describes behaviour that changed, and the description probably needs updating.
   - **Low confidence** — the page mentions something adjacent to the change; a human should check.
   - **Coverage gap** — a new public surface with no existing docs mention.

   Don't pad the output with low-confidence hits unless the user asks for an exhaustive sweep.
   Default to high + medium + coverage gaps.

6. **Produce the punch list.**

   For each item:
   - Page path (with line numbers where specific).
   - One-sentence rationale ("Kafka page still describes the old single-topic layout; v2.2 introduced a replica topic").
   - The changed code surface(s) that triggered the flag.
   - Confidence.

   Group by page — multiple hits in one page are one item with sub-bullets, not repeated items.
   Order by confidence (high first).

   Include coverage gaps at the top — a feature with no docs is usually the most important thing to fix.

7. **If chalk is active, offer to land the punch list.**

   The drift list is a natural checklist for the tracked issue's progress.
   Offer (don't assume) to add unchecked items under a "Docs drift" heading.
   The user acts on each item individually, usually via `chalk:tend-docs`.

## Constraints

- The skill MUST NOT edit docs pages.
  It reports; the user acts.
- The audit MUST be scoped to user-facing docs.
  Internal READMEs, code comments, and developer notes are out of scope unless the user asks otherwise.
- Each punch-list item MUST cite the page path (line numbers where applicable) and the code surface that triggered the flag, so the reviewer can judge in seconds.
- Confidence MUST be stated on each item.
  Unlabelled drift claims are noise.
- Coverage gaps (new public surfaces with no docs) MUST appear in the output, not just stale pages.
- The skill MUST state when there's nothing to audit (empty diff, no docs tree) rather than producing a fake empty punch list.
- The skill MUST NOT fabricate rationales for punch-list items.
  If the issue graph and PRs don't carry the intent, say so on the item ("rationale unclear — ask the author").
  See the main chalk skill's "Understanding Why" section.

## Workflow

1. Parse the audit scope from the user's directive (default: branch diff vs base).
2. Enumerate changed code surfaces from the diff.
3. Locate the docs tree; bail with a clear message if none.
4. Read the docs README (if any) for site structure and conventions.
5. Scan the docs tree for references to each changed surface.
6. Classify hits by confidence; drop low-confidence unless the user asked for exhaustive.
7. Produce the punch list, grouped by page, ordered by confidence, with coverage gaps at the top.
8. If chalk is active, offer to add the items to the tracked issue's progress.

## What this skill is not

- Not an auto-editor.
  It audits; `chalk:tend-docs` edits.
- Not a spec-to-code drift detector — that's `allium:weed`.
- Not a full docs health check.
  It's scoped to drift caused by a specific code change.
- Not a substitute for a human review of the PR.
  It's a first-pass punch list.
