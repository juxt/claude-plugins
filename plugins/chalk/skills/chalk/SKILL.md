---
name: chalk
description: Track session intent and progress against GitHub Issues, and write chalk comments and Progress sections in the chalk voice. Use when the user says "chalk #N", "chalk new", "chalk status", "chalk off", "track issue #N"; mentions a GitHub issue number (e.g. "#123", "issue 456", "GH-789"); references a github.com issue URL; OR is about to compose, draft, write, update or edit any GitHub issue comment, chalk comment, or progress section (e.g. "comment on #123", "note that in the chalk comment", "add to the progress", "write up what we found on the ticket"). Load this skill BEFORE drafting any such prose — it carries the voice guidance the body needs. For drafting an issue body or description itself ("open an issue", "file a bug", "update the issue description"), use the `chalk:issue` skill.
version: 0.4.0
user-invocable: true
disable-model-invocation: false
---

# Chalk — GitHub Issue Tracking

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

Track work against a GitHub Issue.
**The issue description is the source of truth**, and it MUST be kept accurate as facts change.
**Comments are the append-only session log**: what was tried, decided and learned.

## Before you draft anything GitHub-bound

**Every chalk comment and Progress section MUST be drafted in the chalk voice** and shaped per `chalk:mindmap`.
Load these first (via the Skill tool):

- **`chalk:voice`**, and its **`references/palette.md`**.
- **`chalk:mindmap`**.
- **`chalk:goal-tree`** — when the artefact carries the direction of the work rather than its history.

Two artefacts have their own skill — load it instead of drafting from here:
**the issue description** is `chalk:issue`'s, and **the PR description** is `chalk:pr`'s.

**Your audience is the next session on this issue** — a teammate, or you, or an agent starting cold with only the issue in front of it.
"Name your audience" (`chalk:voice`): a comment written for whoever already sat through this session helps nobody, because they've gone.

## Issue relationships

Parent/child and blocked-by carry structure the description can't — use them liberally.
`chalk:issue` covers what each is for.

- **Wire relationships in the same session they emerge**
  A dependency discovered mid-implementation ("this is blocked by #45") gets linked as soon as you find it. Deferring it usually means the link never gets made.

The github agent has GraphQL recipes for reading and mutating these (`addSubIssue`, `addBlockedBy`, and the neighbourhood query).

## Commands

- `chalk #N` — track this session against issue N
- `chalk new` — create a new issue and track against it
- `chalk status` — report the issue number and current Progress summary
- `chalk off` — finalize the current comment (if one is in progress) via the agent, then stop tracking

### Activation: `chalk #N`

1. Use the agent to read the issue, its recent comments, and its one-hop neighbourhood (parent, sub-issues, blocked-by, blocking).
2. Internalize the issue context without repeating the entire issue to the user.
3. If no `## Progress` section exists in the description, ask the agent to add one.
4. If the change is non-trivial and the *why* or *why now* isn't obvious from the issue or its neighbours, ask the user before starting.
   Per "Establish the why and the why now" (`chalk:voice`), a *why now* you can't trace to something the user said, a commit or a file you can name is one you don't have.
5. Tell the user you're tracking against #N.

### Activation: `chalk new`

`chalk new` is *file an issue, then track against it*.

1. **Load the `chalk:issue` skill** and follow it to draft and create the issue.
2. Take the issue number from the result and start tracking, as for `chalk #N`.
3. Add the `## Progress` section.
4. Tell the user you're tracking against the new issue.

### Auto-activation

Offer to activate when the user **directly mentions** a GitHub issue number in their own message — not in code, file contents, build output, or other non-conversational context.
Keep the offer brief: "Want to track this session against #123? (type `chalk #123` to activate)"

**Do NOT read the issue until the user explicitly invokes `chalk #N`.**

## Two layers of state

### The `## Progress` checklist, in the issue description

Chalk owns a `## Progress` section within the description and leaves everything else untouched.
**It MUST be the canonical state of the issue checklist**, and it contains a checklist of all known work items, a **Status** line (`in-progress`, `completed`, `blocked`), and an **Open Questions** checklist if there are unresolved items.

```markdown
## Progress

**Status**: in-progress

- [x] Investigate flaky test in expression_test
- [x] Fix root cause: race condition in temporal bounds
- [ ] Add regression test for concurrent temporal queries

### Open Questions

- [ ] Should we also make TemporalBounds immutable? (see comment)
```

Update it via the agent whenever the checklist changes — items added, completed or deferred.

**An item MUST be checked, and `Status` advanced, only when the work is genuinely done** — verified, not merely attempted.

**Updating the description beyond `## Progress` is `chalk:issue`'s job** — load it rather than editing the body from here.

### The comment — one per session

**There MUST be one comment per session**, created when work begins and updated as the session progresses.

**Chalk MUST NOT edit a chalk comment authored by a different user** without the user's express permission for that specific update.
If another developer's chalk comment is the most recent, create a new comment instead of editing theirs.

## Comment format

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

No date in the header.

- **The checklist is the scannable overview**, one item per `<details>` block below. Check items off as you complete them, and add new items as work emerges.
- **Each `<details>` block is an explanation chunk** — what was explored, decided, tried. Shape its contents as a mindmap; the summary line is the block's subject line and carries the same contract, so a reader who only reads the summaries still follows the session.
- **A `<details>` block MUST contain enough context that a future session can pick up where you left off.**
  Details blocks read like knowledge-sharing, not a changelog.

See `examples/implementation-comment.md` for a realistic filled-in example.

## Lifecycle of a comment

**Create** when starting work — when you have a plan and are about to implement.
If there's no formal plan (e.g. a quick bugfix), still create a comment before starting.
Unless the user has specified otherwise, the same agent call ensures the current user is an assignee, adding `@me` if not already present. Chalk only adds, never displaces.

**Update** as the session progresses — frequently, and without asking.
Check off completed items, fill in details blocks with decisions, findings and dead ends, add items that emerged during implementation.

If there's something new to record — a decision, a dead end, a completed item, a surprising finding — update the comment; don't ask "should I update chalk?" first.

**Collect** when the approach changes significantly — start a new comment, and reduce the old one in the same breath.
Starting a fresh comment *without* collecting the old one is what turns a long-running issue into a log nobody reads.

- **What survives is the complement of the description, not a summary of it**
  Reasoning that never landed, dead ends and what they cost, hypotheses still unverified, and decisions still owed. Those have no other home.

- **What goes is anything whose subject reached a durable home**
  A merged commit body, a spec, a docs page, or the `## Progress` checklist. A block's job ends when its subject lands in one, and the block is then **deleted, not archived**.

- **Collecting is a judgement call, so it stays in the main context**
  Never ask the agent which blocks to drop.

- **Declare the reduction when you hand it over**
  The agent refuses a write that loses `<details>` blocks unless the caller says so, so state it plainly: "reducing 74 blocks to 9".

**Before stopping, ending the session, or context compaction**: finalize the comment via the agent, and update Progress if the overall picture changed.
Include the issue number in your compaction summary — and on resuming, continue updating the existing comment rather than creating a new one.

## Injecting chalk into plans

When chalk is active, **every implementation plan MUST include chalk steps as concrete plan steps**.
They appear in the plan document the user reviews, like any other step.
**Always include the issue number in each step.**

1. **Draft and create the chalk comment** on #N, with the plan's work items, before any implementation begins — if one doesn't already exist for this session.
2. *(... implementation steps ...)*
3. **Draft and update the chalk comment** on #N with outcomes, decisions, dead ends, and anything surprising.
4. **Draft and update Progress** on #N.

## Delegating to the chalk agent

**All GitHub interaction MUST go through the agent** (`Task(subagent_type="chalk:github")`).
The main conversation MUST NOT call `gh issue` or `gh api` directly for chalk updates.

**You compose; the agent executes.**
It does not have your conversation history, the chalk comments you've read, the diff, or the voice guidance.

The agent's prompt MUST contain:

- The issue number.
- What action to take (create comment, update comment, update progress, create issue, create PR).
- **The fully-drafted content, ready to paste verbatim.**
  Passing "here are some bullet points, write this up" is not acceptable.
- **Any project-specific GitHub conventions** relevant to the operation — project boards, default labels, milestones, assignees, reviewers, base branches. They live in the calling project, typically its `CLAUDE.md` or explicit user instructions. Pass them through verbatim rather than paraphrasing, and reflect any session-specific override ("don't add this one to the board") in the prompt rather than the project default.

**Run write calls in the background. Await read calls** — activation needs the result before proceeding.
