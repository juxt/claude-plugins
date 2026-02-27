---
name: chalk
description: Tracks agent session progress against GitHub Issues. This skill should be used when the user says "chalk #N", "chalk new", "chalk status", "chalk off", "track issue #N", mentions a GitHub issue number (e.g. "#123", "issue 456", "GH-789"), or references a github.com issue URL.
version: 0.2.0
user-invocable: true
disable-model-invocation: false
---

# Chalk — GitHub Issue Tracking

Track work against a GitHub Issue.
The issue description is the user's territory; comments belong to chalk.

## Injecting Chalk Into Plans

When chalk is active, **every implementation plan MUST include chalk steps as concrete plan steps**.
This is how chalk stays in sync — it rides the plan, not the session.
Always include the issue number in each chalk step so it survives context compaction.

Inject these steps into the plan document:

1. **Create chalk comment** on #N (via chalk agent) with the planned work items.
2. *(... implementation steps ...)*
3. **Update chalk comment** on #N (via chalk agent) with outcomes, decisions, dead ends, and anything surprising.
4. **Update progress** on #N (via chalk agent) if the overall checklist changed.

Each plan = one comment. Next plan = new comment.

All GitHub interaction goes through the chalk agent (`Task(subagent_type="chalk:github")`).
Run chalk agent write calls (create comment, update comment, update progress) in the background.
Activation reads must be awaited — the result is needed before proceeding.

## Plan Mode Integration

When chalk is active and you write a plan, the plan document MUST include:

1. **First step**: update the session comment with the plan's work items before any implementation begins.
2. **Final step** (after commit): update the session comment with outcomes, decisions, and anything surprising.

These are plan steps like any other — they appear in the plan file the user reviews.

## Auto-Activation

This skill auto-activates when the user mentions a GitHub issue number.
When activated this way, offer chalk tracking briefly — e.g. "Want me to chalk #123?"
If the user accepts, activate as if they said `chalk #N`.
If declined, don't ask again for that issue in the same session.

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

### Comments — One Per Implementation Loop

Each implementation loop (plan → implement → commit) gets its own comment.
Comments are created at the start of a loop and updated at the end.

This gives you an append-only log: scroll down = chronological history of implementation.

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

**Writing style — focus on the why, not the what:**
Details blocks should read like knowledge-sharing, not a changelog.
A future developer (or a future session after compaction) needs to understand *reasoning*, not just *actions*.

Include:
- **Decisions and tradeoffs**: why you chose approach X over Y, what constraints drove the choice.
- **Counter-intuitive findings**: anything that surprised you or would surprise someone reading the code.
- **What didn't work and why**: dead ends are valuable context — they prevent re-investigation.
- **What was explicitly out-of-scope**: if you deliberately skipped something, say so and say why.

Omit:
- Obvious details self-evident from the diff or issue description.
- Play-by-play of mechanical steps ("then I ran the tests", "then I edited the file").

## Lifecycle of a Comment

**Create** when starting an implementation loop — when you have a plan and are about to implement.
If there's no formal plan (e.g. a quick bugfix), still create a comment before starting work.

**Update** when the loop is done:
- Check off completed items.
- Fill in details blocks with decisions, findings, dead ends.
- Add any items that emerged during implementation.

**Before stopping or ending the session**: finalize your current comment via the chalk agent.
Update the Progress section if the overall picture changed.

**Before context compaction**: ensure your current comment captures all progress so far.
Include the issue number in your compaction summary so you can resume tracking afterward.

**After context compaction (resuming)**: if your compaction summary mentions a chalk issue number, re-activate by reading the issue and the last chalk comment.
If the last comment has unchecked items and you are resuming the same implementation loop (not starting new work), continue updating it.
If starting a new plan, always create a new comment.

## Example Comment

See `examples/implementation-comment.md` for a realistic filled-in example.

## Important

- **One comment per implementation loop.** Not per session — per unit of planned work.
- **Issue description owns the checklist.** The `## Progress` section is the canonical state.
- **All GH interaction through the chalk agent.** Keep the main context clean.
- **Don't restructure the issue description** unless the issue's direction has genuinely changed.
- **Do include enough detail in `<details>` blocks** that a future session can pick up where you left off.
