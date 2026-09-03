---
name: sitrep
description: >
  Report where the current session has got to as a mindmap — what has landed, what is still open
  as ID'd ideas, decisions and questions, and a tl;dr.
  Use when the user says "/sitrep", "where are we", "where were we", "recap the session",
  "what's still open", or is picking a session back up after a break, a compaction or a handover.
user-invocable: true
argument-hint: "[optional focus, e.g. a subsystem, or \"just the open questions\"]"
---

# Chalk Sitrep — Where the Session Has Got To

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

A sitrep is written for whoever picks the session up next — the user after a break, a future agent after a compaction, or the user's colleague reading over their shoulder.
It is not a log of the session. It is the state the session has reached, and what still needs a decision.

`$ARGUMENTS`, if given, narrows the scope; report only on that and say in one line what you left out.

## Before you write

- **Load `chalk:mindmap`** — every parent a claim its children back up, and the typed-ID scheme the Open section runs on.
- **`chalk:voice`'s register applies, its palette doesn't.**
  A sitrep is a terminal reply, not a GitHub artefact: no sections drawn from the palette, and no self-ranking, no smoke, no mea culpas.

## Ground the report before writing it

**A sitrep that trusts the transcript reports intentions as achievements.**
The transcript records what was attempted; the repo records what happened.

- **Check the working tree** — `git status`, `git diff --stat`, and `git log` back to where the session started.
  This is what settles the Done/Open boundary for anything touching code.

- **Re-read the artefacts the session claims to have produced** where cheap — the file, the issue, the PR body.
  A file written three edits ago may not say what the session thinks it says.

- **Say so if the context was compacted.**
  One line, at the top: the earlier part of the session is a summary, so coverage before that point is partial. The reader needs to know which half of the report is first-hand.

## Section 1: Done

**One bullet per change that actually landed, children carrying the specifics.**
No IDs here — Done is not up for reply, and IDs on it are noise.

- **Landed means verified**, not attempted: the file is written, the test passed, the commit exists.
- **Tag anything claimed but unchecked with `unverified:`** rather than promoting or dropping it.
  A test that was written but never run is a real result and a real caveat; both belong on the line.
- **Something discussed but not built is not Done** — it is an idea, and belongs in Open.

## Section 2: Open

**One bullet per live item, each with a typed ID so the user can answer `Q2` and leave the rest alone.**
This is the section that earns the sitrep — answering by reference is how the user will reply.

- **`I<n>` — idea**: raised, not adopted. Nobody is committed to it.
- **`D<n>` — decision**: a fork the work is standing at. Say what the options are and which way you lean, per the voting scale.
- **`Q<n>` — question**: needs the user's answer, and the work is blocked or guessing without it.

Per item, children say **why it is still open and what would settle it** — the missing fact, the answer needed, the experiment to run.
Where an item blocks something in flight, say which.

- **An ID's scope is the session, not the sitrep.**
  `chalk:mindmap` requires a published ID to be stable; here that means `Q2` stays `Q2` across every sitrep in the session, even once `Q1` is closed. Renumbering breaks every reference the user has already made, including in their own notes.
- **Newly-raised items take the next free number**, never a recycled one.
- **A closed item drops out silently.**
  Don't keep a struck-through graveyard; if resolving it changed the state, that shows up in Done.
- **Nothing open is a legitimate result.**
  Say so in one line and stop. Manufacturing open questions to fill the section is the main way this skill goes wrong — it hands the user work that does not exist and buries the items that are real.

## Section 3: tl;dr

**At the bottom, under a `tl;dr` heading, and not duplicated at the top.**
This overrides `chalk:mindmap`'s top-of-artefact rule, and only here: a terminal scrolls upward, so in a chat reply the last thing written is the first thing read. Everything else that skill says about a tl;dr still holds.

- **Still a mindmap** — one top-level bullet per takeaway, children backing it up. A flat row of one-liners is the failure mode, and the one that looks finished.
- **Readable cold.**
  Someone who did not see the session should get where the work stands and what it is waiting on.
- **Where there is an obvious next move, it is the last bullet.**
  Where there isn't, don't invent one.

## When the work has an issue or an open PR

**Those are grounding sources, and they are where anything durable belongs.**
A sitrep is chat: it survives until the terminal is closed.

- **Read them before writing.**
  The issue description states the problem as it currently stands; the PR states what landed. A Done item that contradicts either is worth catching before you report it.

- **Nothing in a sitrep should be material that isn't already in one of them, or on its way there.**
  A sitrep is a view over durable artefacts, not a third place state lives. Where it turns out to be the only place something is written down, that's the finding — say so.

- **Offer to write an Open item up where it would outlive the session.**
  An unresolved `Q` goes to the **Open questions** section of whichever artefact owns it — the issue for the problem or the direction, the PR for the change that landed — via `chalk:issue` or `chalk:pr`. Offer, don't do it unasked: a sitrep is a read.

## Cut hard

**Length is the enemy here.** A sitrep the user skims is worse than three bullets they read.

- **Summarise at the altitude of the work, not the tool calls.**
  "Reworked the retry path to back off on 429s" — not the six edits that got there.
- **Drop dead ends** unless the reason they failed constrains what comes next, in which case that constraint is the point and the attempt is the elaboration.
- **Don't recap the user's own instructions back to them.**
