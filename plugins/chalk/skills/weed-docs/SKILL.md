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
Mirror of `allium:weed` for prose.

**This skill MUST NOT edit docs pages** — it reports, the user acts, and resolving the drift is a separate step (usually `chalk:tend-docs`).
**The audit MUST be scoped to user-facing docs.**
Internal READMEs, code comments and developer notes are out of scope unless the user asks otherwise.

## Your Responsibilities

1. **Determine the audit scope.**

   Default: the current branch's diff against its base branch.
   If the user provides a commit, commit range, or path, use that instead.

   **If the diff is empty, say so and stop** — don't produce a fake empty punch list.

2. **Enumerate the code surfaces that changed.**

   Walk the diff and extract the things a docs page could mention:

   - **Renames** — classes, functions, modules, config keys, CLI flags, environment variables.
   - **Signature changes** — added/removed/renamed parameters, changed return types, changed error types.
   - **Behavioural changes** — changed defaults, new required fields, relaxed or tightened constraints.
   - **New public surfaces** — new commands, endpoints, config keys, public APIs.
     These have *no* existing docs, so the audit must flag them as coverage gaps.
   - **Removed surfaces** — deleted commands, endpoints, config keys. Docs that still reference them are stale.
   - **Error messages and log lines** — if a docs page quotes them, they need updating.
   - **Examples in the code** — if docstrings or README snippets changed, paired docs examples may need syncing.

   Internal refactors that don't change observable behaviour don't need docs updates.

3. **Cross-reference the issue-graph neighbourhood.**

   If chalk is active (or the diff references an issue or PR), cast one hop out — the tracked chalk issue and its comments, related issues (parent, sub-issues, blocked-by, blocks), and the PR description and review discussion.

   What to harvest:

   - **Stated intent for new public surfaces**
     Turns a bare coverage-gap item ("no docs for `--foo` flag") into a rationaled one ("no docs for `--foo`; issue #123 names it as the way operators opt into Y").

   - **Operational invariants and failure modes** named in review discussion — often absent from the diff but load-bearing for the docs page that covers the feature.
   - **Paired behaviour**
     A sub-issue naming a knock-on behaviour change in another module points at docs pages for that module too.

   The diff still drives what's flagged; the issue graph sharpens why.

4. **Locate the docs tree.**

   Look for the conventional root (`docs/`, `website/`, `content/docs/`).
   If there's a docs README, read it — it names the site structure and any quadrant layout.

   **If there's no identifiable docs tree, say so and stop.**

5. **Scan for references.**

   For each changed code surface, search the docs tree for literal mentions of the name (fully-qualified and short forms), mentions of the concept or behaviour even where the name differs, code snippets and config blocks and CLI examples and SQL and YAML (these drift silently), and cross-links pointing at removed or renamed pages.

   **A hit isn't always drift.**
   A page mentioning a class name might still be accurate.

6. **Classify each hit by confidence.**

   - **High** — the page names something renamed or removed, and the current text is demonstrably wrong.
   - **Medium** — the page describes behaviour that changed, and the description probably needs updating.
   - **Low** — the page mentions something adjacent to the change; a human should check.
   - **Coverage gap** — a new public surface with no existing docs mention.

   Default to high + medium + coverage gaps.
   Don't pad the output with low-confidence hits unless the user asks for an exhaustive sweep.

7. **Produce the punch list.**

   **Each item MUST cite the page path** (with line numbers where specific) **and the code surface that triggered the flag**, so the reviewer can judge in seconds.
   **Confidence MUST be stated on every item** — unlabelled drift claims are noise.
   **Coverage gaps MUST appear**, not just stale pages.

   Each item also carries a one-sentence rationale: "Kafka page still describes the old single-topic layout; v2.2 introduced a replica topic".
   **A rationale MUST NOT be fabricated** — if the issue graph and PRs don't carry the intent, say so on the item ("rationale unclear — ask the author"). See "Establish the why and the why now" in `chalk:voice`.

   Group by page — multiple hits in one page are one item with sub-bullets, not repeated items.
   Order by confidence, high first, with coverage gaps at the top.

8. **If chalk is active, offer to land the punch list.**

   Offer — don't assume — to add unchecked items under a "Docs drift" heading.
   The user acts on each item individually, usually via `chalk:tend-docs`.

## What this skill is not

- **Not a spec-to-code drift detector** — that's `allium:weed`.
- **Not a full docs health check** — it's scoped to drift caused by a specific code change.
- **Not a substitute for human review of the PR** — it's a first-pass punch list.
