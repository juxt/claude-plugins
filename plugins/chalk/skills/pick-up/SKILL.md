---
name: pick-up
description: Pick up an issue's work in this session — read the issue and its neighbourhood, state the why-now and wait, sort the tracker metadata, and start the plan that journals the session's decisions, questions and constraints as they happen, so its commits and PR are written from them. Use when the user says "pick this up", "pick up #N", "start on #N", "/chalk:pick-up", or a session is starting work on an issue.
user-invocable: true
argument-hint: "[issue]"
---

# Pick-up

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: the session works from the issue alone, the user has agreed why it's being done now, and every commit and PR the session drafts finds its reasoning already written in the plan.**

## Before you start

- **Load `chalk:issue`**, which loads `chalk:voice`.
- **Ground it in the repo, not the transcript**: the branch, `git log` and linked PRs say what has landed.

## 1. Read the issue and its neighbourhood

**The issue, its parent, its sub-issues, what blocks it and what it blocks, and its linked PRs.**

## 2. State the why-now, and wait

**Say why this issue is being worked now, traceable to something you can name** — a blocked card, a deadline, the user's say-so.
Where you can't name one, say so; you MUST NOT pick the most plausible-looking sub-task instead.

**Wait for the user's agreement before changing anything**, the tracker included.

## 3. Report and resolve gaps in the issue

**Against `chalk:issue`'s palette: a missing goal, unclear scope, open questions nobody has answered.**
Report them and resolve them; the answers reach the issue through `chalk:issue`.

## 4. Sort the metadata

**Assignee, status, board — whatever the project's tracker conventions say for a card being picked up.**
Where they don't say, ask.

## 5. Start the plan

**The session's plan — Claude Code's plan file, or the host's equivalent — unless the project names another place.**
Only the session writes it.

- **It opens with one line: `Journalled per chalk:pick-up — <issue link>`**, so a session after a compaction knows which skill to reload.
- **It links the issue rather than copying it.**
- **It holds what has to land, and below it, apart, the journal.**
- **What has to land, not which files to touch.**
- **Where it has a goal structure, it's a goal tree** (`chalk:goal-tree`): the issue's goal at the root, what lands at the leaves.
  Test each node for sufficiency, mark `check:` where unsure, and say where sufficiency leans on what the user already knows about the system.
- **A sub-goal names what it depends on.**
  **It's ready once everything it depends on is done and no open question blocks it.**
- **What's in hand sits at the top**: the sub-goal being worked, and anything that interrupted it, innermost first.
- **When a sub-goal's commit is made, mark it done with the commit's subject**, not its SHA, which a rebase rewrites.

## 6. Journal as you go

**Write each entry when it happens, not at the end and not from memory.**

- **`D<n>` decision** — the claim, and its grounds.
  A call you aren't sure of is a question, not a decision.
  An alternative rejected is its child, with why.
  A revised decision stays, marked `superseded by D<m>`.
- **`Q<n>` question** — what it blocks, and what would settle it.
- **`constraint:`, `assumption:`, `risk:`** — what the work leans on that it doesn't control, and what could stop it.
- **`dead-end:`** — a road that closed, and what closed it, where that constrains what comes next.
- **`why-now:`** — what prompted a piece of work, whenever it isn't the issue's own.

**Cutting scope and accepting a risk MUST be recorded**; they leave no other trace.

**A decision that changes the problem or the agreed scope goes to the issue now**, through `chalk:issue`; the journal records that it went.
**Everything else goes in the journal**, naming the sub-goal it bears on only where the entry doesn't make that obvious.

**Each entry is one claim in `chalk:voice`'s register, terse.**
An entry that would mean nothing in a commit body, a PR or the issue doesn't belong.

**You MAY give a sub-agent the plan's path to read**, told not to write it — never a `weed-*` agent, which works because it arrives without the reasoning.
