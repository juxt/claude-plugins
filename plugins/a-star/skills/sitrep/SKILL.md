---
name: sitrep
description: >
  Refresh the user's context on a card: beads' own state — where the work is, open questions, decisions, risks, assumptions, what's ready — plus what beads can't see: the repo's state, and where the two disagree.
  Use when the user says "/a-star:sitrep", "where are we", "recap", "what's still open", or is coming back to a card after a break or a compaction.
user-invocable: true
argument-hint: "[card, if not already in session]"
---

# a-star Sitrep

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: the user's context is refreshed in a few subject lines** — enough to agree with where the card stands, or redirect it, without reading the transcript.

**A sitrep refreshes the user's context: where the card stands, and what it's waiting on.**
The card's state is in bd, so the report reads it back rather than reconstructing it from the transcript.

Load `a-star:a-star` first.

## Beads' state, as beads gives it

- **Where the work is** — `bd list --tree --parent <card>`; the `in_progress` chain is the yak stack.
- **Open questions** — the open `decision` issues under the card, each with what it blocks.
- **Decisions** — the closed `decision` issues, with their reasons and who decided.
- **Assumptions and risks** — the notes on the card's nodes.
- **Ready** — `bd ready --exclude-type epic --parent <card>`.
- **Spikes** — the `spike` beads under the card: what each route showed, and the one still running.

**Keep bd's IDs and wording**; `bd show <id>` has the rest.

## What beads can't see

**Beads records what the super agent told it; the repo records what happened.**

- **Check the repo** — `git status`, the card's feature and spike branches, uncommitted work, whether anything bd calls open has already landed.
- **Say where the two disagree, and which is right.**
  A node `in_progress` in bd but already merged, or a branch bd points at that no longer exists, is a finding.

## tl;dr

**Where the card stands, and what it's waiting on**, readable by someone who wasn't in the session.
Where the next move is obvious, name it as a lean.

**Layout follows the user's chosen output style.**
