---
name: chalk
description: Track session intent and progress against GitHub Issues. Use when the user says "chalk #N", "chalk new", "chalk status", "chalk off", "track issue #N", mentions a GitHub issue number (e.g. "#123", "issue 456", "GH-789"), or references a github.com issue URL.
version: 0.2.0
user-invocable: true
disable-model-invocation: false
---

# Chalk — GitHub Issue Tracking

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

Track work against a GitHub Issue.
The issue description is the source of truth — a developer should be able to understand the current state of the issue by reading the description alone, without trawling through comments.
Keep the description accurate as facts change (new failure modes, updated analysis, revised scope).
Comments are the append-only session log — what was tried, decided, and learned.

## Understanding Why

Chalk's job is to capture the *why*, not just the *what* — and the diff won't carry that reasoning on its own.
Before starting anything beyond a trivial change, make sure you understand two things:

- **Why this change** — what problem it solves, what it unblocks, what constraint drove it.
- **Why now** — what prompted it today. A deadline, a dependent piece of work, a recent incident, someone else blocked on it?

If either isn't obvious from the issue, the conversation, or the code you've read, **ask the user before starting**.
A one-sentence answer now is cheaper than reconstructing the reasoning later from the diff.

Trivial changes (typo fixes, mechanical bumps, one-line config tweaks) don't need this step — the motivation is self-evident.
Non-trivial changes (refactors, new features, non-obvious fixes, scope decisions) do: the issue description, the chalk comment, and the commit message all depend on you having it.

## Writing Descriptions

Don't impose a rigid structure, but good issue and PR descriptions typically draw from sections like:

- **Summary** — what's happening, in a sentence or two
- **Context** — how was this observed? what environment, deployment, test configuration? link to CI runs, logs, dashboards, prior PRs, or the broader initiative. This is often the most valuable section — without it, a reader can't assess whether the issue applies to them or where a PR fits
- **Symptoms** — observable behaviour, error messages, affected conditions (e.g. "multi-writer only", "under chaos monkey testing")
- **Root cause** / **Analysis** — why it's happening, with evidence (log excerpts, stack traces, block file analysis, annotated offset tables)
- **Evidence** — concrete artefacts: replica log dumps, application log excerpts with timestamps, block file contents, message type distributions. Annotate them — raw dumps without explanation are noise
- **Motivation** — for features/refactors: why this matters, what it unblocks
- **Key invariants** / **Constraints** — non-obvious things the solution must preserve
- **Proposed approach** / **Fix** — the design direction or fix strategy (but not a step-by-step implementation plan — that belongs in the chalk comment)
- **Reasons for / against** — for decisions or removals: the trade-offs

PRs additionally draw from:

- **Usage** — for user-visible features: concrete examples (SQL queries with realistic output, CLI invocations, config snippets). Show what the feature looks like, not just that it exists
- **Changes** — for multi-commit PRs: a numbered list of commits with a sentence each, so the reviewer knows the intended reading order
- **Implementation notes** — grouped by sub-concern, not a flat list. Call out non-obvious design choices, key invariants, or anything counter-intuitive
- **Dead ends** — "we tried X, it didn't work because Y" prevents the reviewer from suggesting X
- **Scope** — what's explicitly out of scope, what's deferred to follow-up. Reference related issues/PRs
- **Test plan** — what was tested and how

Not every description needs all of these.
A flaky test issue might just need the failure mode, stack trace, and conditions.
A small bugfix PR might just need summary and test plan.
A large feature PR might need context, usage examples, implementation notes, and scope.
A refactor PR should call out that behaviour is intentionally preserved.
Use judgement.

## Injecting Chalk Into Plans

When chalk is active, **every implementation plan MUST include chalk steps as concrete plan steps**.
This is how chalk stays in sync — it rides the plan, not the session.
Always include the issue number in each chalk step so it survives context compaction.

Inject these steps into the plan document:

1. **Create chalk comment** on #N (via chalk agent) with the planned work items — if one doesn't already exist for this session. Unless the user has specified otherwise, the same agent call MUST ensure the current user is an assignee on the issue (add `@me` if not already present — do not displace existing assignees).
2. *(... implementation steps ...)*
3. **Update chalk comment** on #N (via chalk agent) with outcomes, decisions, dead ends, and anything surprising.
4. **Update progress** on #N (via chalk agent) if the overall checklist changed.

All GitHub interaction goes through the chalk agent (`Task(subagent_type="chalk:github")`).
Run chalk agent write calls (create comment, update comment, update progress) in the background.
Activation reads must be awaited — the result is needed before proceeding.

## Plan Mode Integration

When chalk is active and you write a plan, the plan document MUST include:

1. **First step**: create or update the session comment with the plan's work items before any implementation begins.
2. **Final step** (after commit): update the session comment with outcomes, decisions, and anything surprising.

These are plan steps like any other — they appear in the plan file the user reviews.

## Auto-Activation

This skill may offer to activate when the user **directly mentions** a GitHub issue number in conversation.
Only offer when the issue number appears in the user's own message — not in code, file contents, build output, or other non-conversational context.

When offering, keep it brief: "Want to track this session against #123? (type `chalk #123` to activate)"

Do NOT automatically read the issue. Issue content is only fetched after the user explicitly invokes `chalk #N`.
If the user does not explicitly invoke chalk, do not read or fetch any issue content.

## Commands

- `chalk #N` — track this session against issue N
- `chalk new` — create a new issue and track against it
- `chalk status` — show what you're tracking (report the issue number and current Progress summary)
- `chalk off` — finalize the current comment (if one is in progress) via the chalk agent, then stop tracking

## Activation: `chalk #N`

1. Use the chalk agent to read the issue and its recent comments.
2. Internalize the issue context without repeating the entire issue to the user.
3. If no `## Progress` section exists in the issue description, ask the chalk agent to add one.
4. If the change is non-trivial and the *why* or *why now* isn't obvious from the issue (see "Understanding Why"), ask the user before starting.
5. Tell the user you're tracking against #N.

## Activation: `chalk new`

1. Ask the user for a title and brief context — including *why now*, if it's not already clear. See "Understanding Why".
2. Use the chalk agent to create the issue. Provide enough context for a good description — the agent will write it for a developer who needs to understand the situation without reading comments.
3. Note the issue number from the agent's response.
4. Tell the user you're tracking against the new issue.

## Two Layers of State

### Issue Description — The Progress Checklist

Chalk owns a `## Progress` section within the issue description.
Leave everything else untouched.

The `## Progress` section contains:
- A checklist of all known work items (checked/unchecked).
- A **Status** line (`in-progress`, `completed`, `blocked`).
- An **Open Questions** checklist if there are unresolved items.

```markdown
## Progress

**Status**: in-progress

- [x] Investigate flaky test in expression_test
- [x] Fix root cause: race condition in temporal bounds
- [ ] Add regression test for concurrent temporal queries

### Open Questions

- [ ] Should we also make TemporalBounds immutable? (see comment)
```

Update the progress section (via the chalk agent) whenever the checklist changes — items added, completed, or deferred.

**Updating the issue description** (beyond the Progress section): update factual content when the current state has changed (new failure mode, updated context, revised scope).
Preserve the user's framing and intent — don't rewrite the narrative, just keep the facts current.

### Comments — One Per Session

Each session gets one comment.
The comment is created when work begins and updated as the session progresses.

Across sessions, this gives you an append-only log: scroll down = chronological history of implementation.

## Delegating to the Chalk Agent

**All GitHub interaction goes through the chalk agent.**
The main conversation MUST NOT call `gh issue` or `gh api` directly for chalk updates.
This keeps the main context clean and avoids filling it with API output.

To create or update a chalk comment, launch the chalk agent via the Task tool:

```
Task(subagent_type="chalk:github", prompt="...")
```

The prompt should contain:
- The issue number
- What action to take (create comment, update comment, update progress)
- The content to write

Run chalk agent write calls in the background.
Await read calls (activation) — the result is needed to proceed.

## Comment Format

```markdown
### Chalk — Short description of this task

- [ ] First work item
- [ ] Second work item

<details><summary>First work item</summary>

Details of what was explored, decided, implemented...

</details>

<details><summary>Second work item</summary>

Details...

</details>
```

No date in the header — GitHub timestamps the comment itself.

**Rules:**
- The checklist is the scannable overview.
  Each item mirrors a `<details>` block below.
- Check items off as you complete them.
- Add new items as work emerges.
- Keep details blocks focused — one per theme or work item.

**Writing style**: follow the chalk voice (see `VOICE.md` at the plugin root).
Details blocks should read like knowledge-sharing, not a changelog.

## Lifecycle of a Comment

**Create** when starting work — when you have a plan and are about to implement.
If there's no formal plan (e.g. a quick bugfix), still create a comment before starting work.
Creating the chalk comment is the signal that you're picking the issue up: unless the user has specified otherwise, the same agent call ensures the current user is an assignee (adding `@me` if not already present — chalk only adds, never displaces).

**Update** as the session progresses — frequently, and without asking.
Chalk updates are part of the work, not a separate task that needs the user's permission each time.
Treat them like staging a file before committing: just do it, then move on.

- Check off completed items as they land.
- Fill in details blocks with decisions, findings, dead ends.
- Add any items that emerged during implementation.

The user MUST NOT have to prompt each update.
If there's something new to record (a decision, a dead end, a completed item, a surprising finding), update the comment — don't ask "should I update chalk?" first.

**Before stopping or ending the session**: finalize the comment via the chalk agent.
Update the Progress section if the overall picture changed.

**Before context compaction**: ensure the comment captures all progress so far.
Include the issue number in your compaction summary so you can resume tracking afterward.

**After context compaction (resuming)**: if your compaction summary mentions a chalk issue number, re-activate by reading the issue and the session comment.
Continue updating the existing comment — do not create a new one.

## Example Comment

See `examples/implementation-comment.md` for a realistic filled-in example.

## Constraints

- There MUST be one comment per session.
- Chalk MUST NOT edit a chalk comment authored by a different user without the user's express permission for that specific update. If another developer's chalk comment is the most recent, create a new comment instead of editing theirs.
- The `## Progress` section MUST be the canonical state of the issue checklist.
- All GitHub interaction MUST go through the chalk agent. The main context MUST NOT call `gh` directly for chalk updates.
- The issue description MUST be kept accurate — update facts when they change, but preserve the user's framing and intent.
- `<details>` blocks MUST contain enough context that a future session can pick up where you left off.
- All writing MUST follow the chalk voice (`VOICE.md` at the plugin root).
