---
name: journal
description: >
  The session's journal, and the plan file it lives in: start or read the session's plan file, and record in the session's journal a decision, open question, requirement, assumption, constraint, risk, dead end, sub-goal, review note, re-split or replan, what is in hand, or an agent in flight.
  Load it before recording anything, before reading the record to write a commit, PR, issue update or sitrep, and when a compaction has left the session to rebuild what it knew.
  The record kinds are open vocabulary: a caller fills them in and MAY add its own.
user-invocable: false
---

# Journal

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**The journal is where a session's reasoning is written as it happens, so that every commit, PR and issue update drafted from it finds the reasoning already there.**
Load `chalk:voice`: each entry is one claim in its register.

## The plan file

**The session's plan — Claude Code's plan file, or the host's equivalent — unless the project names another place.**
Only the main session writes it; a sub-agent MAY be given its path to read, told not to write it — never a `weed-*` agent, which works because it arrives without the reasoning.

- **It opens with one line: `Journalled per chalk:journal — commits via chalk:commit — <issue link, or "unfiled">`**, so a session after a compaction knows which skill to reload, and a sub-agent pointed at the plan knows how its commits are written.

- **It holds the plan, and below it, apart, the journal.**

- **It outlives plan mode.**
  Approving the plan exits plan mode, and the session goes on journalling into the same file.

- **What's in hand sits at the top**: the work being done, and anything that interrupted it, innermost first.

- **It links an issue rather than copying it.**

## What has landed

**What has landed is the repo's to say, not the transcript's.**
The branch, `git status`, `git log` and the linked PRs say what happened; the transcript records only what was attempted.

## The record kinds

**Write each entry when it happens, not at the end and not from memory.**
Each is one claim, terse; an entry that would mean nothing in a commit body, a PR or the issue doesn't belong.
A caller MAY keep entries of its own besides these.

- **`D<n>` decision** — the claim, and its grounds.
  A call you aren't sure of is a question, not a decision.
  An alternative rejected is its child, with why.
  A revised decision stays, marked `superseded by D<m>`.

- **`Q<n>` question** — what it blocks, and what would settle it.

- **`R<n>` requirement** — what the goal needs to be true, as the user or the card states it.

- **`principle:`** — a rule the user states for how the work is done, beyond this one call.
  Briefing a sub-agent passes these on.

- **`C<n>` constraint** — what bounds the solution, marked `essential` where the problem imposes it, `accidental` where the current system does and the change may remove it.

- **`A<n>` assumption** — what the work leans on that it doesn't control.

- **`risk:`** — what could stop it.

- **A constraint or assumption sits on the goal-tree node it bounds** (`chalk:goal-tree`), so it carries into the issue's tree under the same ID.

- **`dead-end:`** — a road that closed, and what closed it, where that constrains what comes next.

- **`inbox:`** — an arrival held for the user until their current thread closes.
  It is cleared once raised.

- **`review:`** — what a reviewer needs to check a commit, by its subject: what checking it means, the invariants it rests on with where each is made true, what pins it and what would break it, and what was verified and what wasn't.
  Whoever knows it writes it when the commit is made, into the commit's body through `chalk:commit`.
  `chalk:pr`'s Reviewing this finds what spans commits and what was verified here.

- **Sub-goals** — each names what it depends on, and is ready once everything it depends on is done and no open question blocks it.
  When a sub-goal's commit is made, mark it done with the commit's subject, not its SHA, which a rebase rewrites.

- **`re-split:`** — what changed inside an approved plan, and which sub-goals it superseded or reopened; those are marked, not deleted.

- **`replan:`** — what changed, and which sub-goals and decisions it invalidated; those are marked, not deleted.

- **In hand** — the work being done, innermost first, before its first edit.
  **An agent in flight** — so a resumed session knows it was lost.

**An entry keyed by a commit's subject follows the subject**: a step that rewrites a subject updates the entries keyed by it.

**Cutting scope and accepting a risk MUST be recorded**; they leave no other trace.

**Everything not the issue's stays in the journal**, naming the sub-goal it bears on only where the entry doesn't make that obvious.

## The task list

**The host's task list — Claude Code's tasks, or the host's equivalent — is a view of the plan's goal tree, never a second source.**
A task carries a leaf's ID and subject line, and nothing the leaf doesn't; anything worth adding belongs in the plan first.
Recording a change to a leaf changes its task: added, completed, reopened, marked blocked by another's, or removed.
