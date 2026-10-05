---
name: pick-up
description: Pick up an issue's work in this session — read the issue and its neighbourhood, state the why-now and wait, sort the tracker metadata, and start the plan that journals the session's decisions, questions and constraints as they happen, so its commits and PR are written from them. Use when the user says "pick this up", "pick up #N", "start on #N", "/chalk:pick-up", or a session is starting work on an issue.
user-invocable: true
argument-hint: "[issue]"
---

# Pick-up

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**The success criteria for this skill: the session works from the issue alone, the user has agreed why it's being done now, and every commit and PR the session drafts finds its reasoning already written in the plan.**

**A session's reasoning evaporates at the next compaction unless it's written down when it happens.**
Reconstructed later, it comes back confident and wrong — the *why now* most of all, which `chalk:commit` says exists only in the user's head.
Pick-up is where that writing starts; `chalk:put-down` is its mirror.

## Before you start

- **Load `chalk:issue`**, which loads `chalk:voice` and carries the palette the issue is read against.

- **Ground it in the repo, not the transcript.**
  The branch, `git log` and any linked PRs say what has already landed.

## 1. Read the issue and its neighbourhood

**The issue, its parent, its sub-issues, what blocks it and what it blocks, and its linked PRs.**
The last put-down's correction of the description is what an earlier session left for this one.

## 2. State the why-now, and wait

**Say why this issue is being worked now, traceable to something you can name** — a blocked card, a deadline, the user's say-so.
Where you can't name one, say so; you MUST NOT pick the most plausible-looking sub-task instead.

**Wait for the user's agreement before changing anything**, the tracker included.

## 3. Report gaps in the issue

**Against `chalk:issue`'s palette: a missing goal, unclear scope, open questions nobody has answered.**
Report them; don't fill them.
Settling them is a conversation with the user, and the answers reach the issue through `chalk:issue`.

## 4. Sort the metadata

**Assignee, status, board — whatever the project's tracker conventions say for a card being picked up.**
Where they don't say, ask; MUST NOT guess.

## 5. Start the plan

**The session's plan — Claude Code's plan file, or the host's equivalent — unless the project names another place.**
The session is its only writer.

- **It opens with one line: `Journalled per chalk:pick-up — <issue link>`.**
  The plan survives a compaction whole; this skill's guidance may not, and the line says which skill to reload.

- **It links the issue rather than copying it.**
  What the issue says stays on the issue; a copy drifts.

- **Its structure is the work's, not this skill's.**
  Whatever is driving the work — the user, a harness, the plan itself — decides the sections; where the work lands as several commits, one section per commit is what lets `chalk:commit` find its own reasoning.

- **It answers what has to land, not which files to touch.**
  Granular execution — which step is next, what was tried — is the session's, and the code says it better once written.

## 6. Journal as you go

**Write each entry at the moment it happens, by the session that holds the context.**
Not at the end, and not from memory: an entry written later is the reconstruction this skill exists to prevent.

**What earns an entry:**

- **`D<n>` decision** — the claim, who decided (`decided-by: user` or `decided-by: agent`), and its grounds.
  An alternative rejected is its child, with why.
  A revised decision stays, marked `superseded by D<m>`.

- **`Q<n>` question** — what it blocks, and what would settle it.

- **`constraint:`, `assumption:`, `risk:`** — what the work leans on that it doesn't control, and what could stop it.

- **`dead-end:`** — a road that closed, and what closed it, where that constrains what comes next.

- **`why-now:`** — what prompted a piece of work, whenever it isn't the issue's own.

**When:** the user answers a question, you make a call yourself, a premise turns out wrong, scope is cut or a risk accepted.
Cutting scope and accepting a risk leave no other trace, so those two MUST be recorded.

**Where:**

- **A decision that changes the problem or the agreed scope goes to the issue now**, through `chalk:issue`; the plan records only that it went.
- **One that bears on a single commit goes in that commit's section.**
- **The rest goes at the top, under the issue link.**

**Each entry is a claim in `chalk:voice`'s register: one per subject line, terse.**
The plan is not a log of the session; an entry that would mean nothing in a commit body, a PR or the issue doesn't belong.

**Once a commit lands, its section gains `<sha> <subject>`**, so the plan maps onto git.

## Who reads it

- **`chalk:commit`** picks what's relevant from its own section; the commit body is a selection, not a copy.
- **`chalk:pr`** reads all of it, and lists every `decided-by: agent` decision and every assumption for the reviewer.
- **`chalk:put-down`** carries what's still open onto the issue.
- **A sub-agent MAY be given the plan's path to read**, told not to write it.
  The `weed-*` agents MUST NOT be given it: they work because they arrive without the reasoning, and the plan is the reasoning.
