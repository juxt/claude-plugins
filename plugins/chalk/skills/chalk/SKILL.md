---
name: chalk
description: Track session intent and progress against GitHub Issues, and write every GitHub-bound prose body (issue, comment, description, progress update) in the chalk voice. Use when the user says "chalk #N", "chalk new", "chalk status", "chalk off", "track issue #N"; mentions a GitHub issue number (e.g. "#123", "issue 456", "GH-789"); references a github.com issue URL; OR is about to compose, draft, write, update or edit any GitHub issue body, issue description, issue comment, chalk comment, or progress section (e.g. "open an issue", "file a bug", "comment on #123", "update the issue description", "note that in the chalk comment", "add to the progress", "write up what we found on the ticket"). Load this skill BEFORE drafting any such prose — it carries the voice guidance the body needs.
version: 0.3.0
user-invocable: true
disable-model-invocation: false
---

# Chalk — GitHub Issue Tracking

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

## Before you draft anything GitHub-bound

Every issue body, issue description, chalk comment, progress section, and PR description you touch in this session MUST be drafted in the chalk voice — not your own default prose habits, which read wrong and lose the reasoning the reader needs.

`chalk` carries the issue-tracking mechanics, not the writing voice.
Before drafting any such prose, **load the `chalk:voice` skill** (via the Skill tool) — it holds the Diataxis framing, the universal principles, and the issue/PR section palette.
Then structure the body into sections drawn from that palette, choosing the ones the issue or PR needs.

**Line format: paragraph-per-line.**
Issue bodies, comments, and progress sections are read rendered on GitHub, never as a `git diff`, so put each paragraph on a single line and separate paragraphs with a blank line — GitHub renders single newlines as `<br>`, which would fragment sentence-per-line prose into staccato.

## What chalk does

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

## Issue Relationships

Use parent/child and blocked-by liberally — they carry structure the description can't, and they answer two questions cheaply that prose would answer expensively.

- **Parent / sub-issues**: when work naturally nests, link them. A sub-issue inherits the parent's motivation, so its own description can stay focused on the specific slice. Good fit for epic → sub-tasks, or a broad refactor split into reviewable pieces.
- **Blocked-by**: for order-dependent work. This is the one that pays back most — a filter for "open, un-blocked" becomes the queue of workable cards, and nobody has to triage to find out what they can pick up today.

Wire relationships in the same session they emerge.
When creating a new issue that depends on or belongs under existing work, link it immediately — deferring it usually means the link never gets made.
When starting on an issue, scan its neighbours for why-now context: a parent epic or a recently-unblocked predecessor often explains why *this* is the card to pick up today.

The github agent has GraphQL recipes for reading and mutating these relationships (`addSubIssue`, `addBlockedBy`, and the neighbourhood query).

## Injecting Chalk Into Plans

When chalk is active, **every implementation plan MUST include chalk steps as concrete plan steps**.
This is how chalk stays in sync — it rides the plan, not the session.
Always include the issue number in each chalk step so it survives context compaction.

Inject these steps into the plan document:

1. **Draft and create chalk comment** on #N — compose the comment body in the main context, then hand it to the chalk agent to post — if one doesn't already exist for this session. Unless the user has specified otherwise, the same agent call MUST ensure the current user is an assignee on the issue (add `@me` if not already present — do not displace existing assignees).
2. *(... implementation steps ...)*
3. **Draft and update chalk comment** on #N — compose the updated body in the main context (outcomes, decisions, dead ends, and anything surprising), then hand it to the chalk agent.
4. **Draft and update progress** on #N — compose the new Progress section in the main context, then hand it to the chalk agent to write it back.

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

1. Use the chalk agent to read the issue, its recent comments, and its one-hop neighbourhood (parent, sub-issues, blocked-by, blocking).
2. Internalize the issue context without repeating the entire issue to the user.
3. If no `## Progress` section exists in the issue description, ask the chalk agent to add one.
4. If the change is non-trivial and the *why* or *why now* isn't obvious from the issue or its neighbours (see "Understanding Why"), ask the user before starting.
5. Tell the user you're tracking against #N.

## Activation: `chalk new`

1. Ask the user for a title and brief context — including *why now*, if it's not already clear. See "Understanding Why".
2. **Draft the issue body yourself** in the main context, following the section palette and voice in the `chalk:voice` skill. Include a `## Progress` section at the end. Do not delegate this drafting to the agent — it won't have the conversation context and will produce a thinner description than you can.
3. Pass the title and the fully-drafted body to the chalk agent to create the issue.
4. Note the issue number from the agent's response.
5. Tell the user you're tracking against the new issue.

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

**You compose; the agent executes.**
The agent is a small-model mechanics layer — it runs `gh` and reports results.
It does not have your conversation history, the chalk comments you've read, the diff, or the voice guidance in full.
Draft issue bodies, comment bodies, Progress sections and PR descriptions **in the main context** before calling the agent, following the section palette and voice in the `chalk:voice` skill.
The agent's prompt MUST include the full content ready to post verbatim.
Passing "here are some bullet points, write this up" is not acceptable — that pushes an explanation-quadrant job onto a model that can't do it well and loses the reasoning the reader actually needs.

To create or update a chalk comment, launch the chalk agent via the Task tool:

```
Task(subagent_type="chalk:github", prompt="...")
```

The prompt MUST contain:
- The issue number
- What action to take (create comment, update comment, update progress, create issue, create PR)
- The **fully-drafted content** to write, ready to paste verbatim into GitHub
- Any project-specific GitHub conventions that apply to this operation (see below)

Run chalk agent write calls in the background.
Await read calls (activation) — the result is needed to proceed.

### Passing project-specific conventions

The chalk agent is deliberately generic — it doesn't know which project board new issues should land on, what the default labels are, or who reviews PRs.
Those conventions live in the calling project (typically the project's `CLAUDE.md`, or explicit user instructions during the session).

Before calling the agent, scan your current context for project-specific GitHub conventions relevant to the operation — project boards, default labels, milestones, assignees, reviewers, base branches — and include them verbatim in the agent's prompt.
Do not try to paraphrase or pre-interpret them; pass them through and let the agent apply them alongside its defaults.

If a convention is session-specific or has been overridden by the user for this operation (e.g. "don't add this one to the board"), reflect that in the prompt rather than the project default.

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

**Writing style**: each `<details>` block is an **explanation** chunk — what was explored, decided, tried. The checklist above is navigation, not a separate quadrant. Follow the explanation-quadrant voice in the `chalk:voice` skill.
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
- An item MUST be checked, and `Status` advanced, only when the work is genuinely done — verified, not merely attempted. The Progress section is read as the issue's current truth.
- All GitHub interaction MUST go through the chalk agent. The main context MUST NOT call `gh` directly for chalk updates.
- The issue description MUST be kept accurate — update facts when they change, but preserve the user's framing and intent.
- `<details>` blocks MUST contain enough context that a future session can pick up where you left off.
- All writing MUST follow the voice in the `chalk:voice` skill — issues, PRs, and chalk comments are explanation artefacts.
