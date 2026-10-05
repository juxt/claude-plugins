---
name: sitrep
description: >
  Refresh the user's context on a card: the plan's state — where the work is, open questions, decisions, risks, assumptions, what's next — plus what the plan can't see: the repo's state, and where the two disagree.
  Use when the user says "/a-star:sitrep", "where are we", "recap", "what's still open", or is coming back to a card after a break or a compaction.
user-invocable: true
argument-hint: "[card, if not already in session]"
---

# a-star Sitrep

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: the user's context is refreshed in a few subject lines** — enough to agree with where the card stands, or redirect it, without reading the transcript.

**The card's state is in the plan, so the report reads it back rather than reconstructing it from the transcript.**
Where the project has its own sitrep conventions, they shape the report; this skill says what goes in it.

Load `a-star:a-star` first.

## The plan's state

- **Where the work is** — the top of the plan: the landing in hand, and any tidy that interrupted it.
- **Open questions** — each with the landing it blocks.
- **Decisions** — with who made them; the agent's first, since they're the ones awaiting review.
- **Assumptions and risks.**
- **What's next** — the first unlanded section with nothing open blocking it.
- **Spikes** — what each route showed, and the one still running.

**Keep the plan's IDs and wording.**

## What the plan can't see

**The plan records what the super agent wrote; the repo records what happened.**

- **Check the repo** — `git status`, the card's feature and spike branches, uncommitted work, whether a section the plan calls unlanded has a commit.
- **Say where the two disagree, and which is right.**
  A section with a SHA that isn't on the branch, or a branch the plan points at that no longer exists, is a finding.

## tl;dr

**Where the card stands, and what it's waiting on**, readable by someone who wasn't in the session.
Where the next move is obvious, name it as a lean.

**Layout follows the user's chosen output style.**
