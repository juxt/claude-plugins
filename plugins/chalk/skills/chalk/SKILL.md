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
The issue description is the user's territory; comments belong to chalk.

## Injecting Chalk Into Plans

When chalk is active, **every implementation plan MUST include chalk steps as concrete plan steps**.
This is how chalk stays in sync — it rides the plan, not the session.
Always include the issue number in each chalk step so it survives context compaction.

Inject these steps into the plan document:

1. **Create chalk comment** on #N (via chalk agent) with the planned work items — if one doesn't already exist for this session.
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
4. Tell the user you're tracking against #N.

## Activation: `chalk new`

1. Ask the user for a title and brief context.
2. Use the chalk agent to create the issue with a `## Progress` section in the body.
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

**Restructuring the issue description** (beyond the Progress section) is only appropriate if the issue's direction or aim has genuinely changed — not as routine maintenance.

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

**Update** as the session progresses:
- Check off completed items.
- Fill in details blocks with decisions, findings, dead ends.
- Add any items that emerged during implementation.

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
- The `## Progress` section MUST be the canonical state of the issue checklist.
- All GitHub interaction MUST go through the chalk agent. The main context MUST NOT call `gh` directly for chalk updates.
- The issue description MUST NOT be restructured unless the issue's direction has genuinely changed.
- `<details>` blocks MUST contain enough context that a future session can pick up where you left off.
- All writing MUST follow the chalk voice (`VOICE.md` at the plugin root).
