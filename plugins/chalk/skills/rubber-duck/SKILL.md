---
name: rubber-duck
description: >
  Rubber-duck a design with the user — take their thinking in whatever order it arrives, file each decision, constraint, question and idea under a stable ID as it goes, push back with consequences and conflicts, and keep a running record the user turns into whatever they want at the end.
  Use when the user says "/chalk:rubber-duck", "rubber-duck this", "let's rubber-duck", or "brain dump".
user-invocable: true
argument-hint: "[topic]"
---

# Chalk Rubber-duck — Talking a Design Through

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

The user is thinking out loud, and won't do it in order.
A remark answers a question from twenty minutes ago, opens a new area and settles a decision in the same breath; a question you asked goes unanswered while they chase something else.
You keep the record, so that they don't have to hold it in their head.

**Success: at the end, every decision, constraint, question and idea the conversation produced is in the record under a stable ID, with its consequences, and nothing the user said was lost for arriving out of order.**

`$ARGUMENTS`, if given, names the topic.

## Before you start

- **Load `chalk:voice`.**
  Its register applies to the record and to your replies; its palette doesn't.

- **Start the record as a local scratch file**, in the session's scratchpad where it has one.
  Where the host has no filesystem, keep it in the host's equivalent, and say which.

- **The record's first line is `Rubber-ducked per chalk:rubber-duck — <path>`**, so a session after a compaction knows which skill to reload and where the record is.

## 1. Take the input in whatever order it arrives

**Each remark is filed where it belongs, not answered in the order it was said.**

- **One remark may carry several items.**
  Split it: a decision, the constraint behind it, and the question it raises are three entries.

- **File each by kind and by area.**
  A tangent goes into its own area, and the conversation carries on from wherever the user takes it next.

- **You MUST NOT ask the user to slow down, restate, or go back to finish a thread.**
  An area left half-done is the record's to hold, not the user's.

## 2. Push back

**A duck that only transcribes is a scribe.**

- **Work out each decision's consequences**, and file them under it with `→`.

- **Say when two entries conflict**, naming both by ID and subject line.

- **Say when a new remark reopens a settled decision.**
  The user decides whether it does; until they do, it's a question.

- **Check claims about the code against the code where it's cheap**, and cite the file.
  Where it isn't, tag the claim `assumption:` and carry on; the user's flow comes before the check.

## 3. Your questions don't block

**Ask what you need to, and carry on whether or not it's answered.**

- **An unanswered question stays open under its ID.**
  You MUST NOT repeat it unprompted; raise it again only where a later entry depends on it.

- **A later remark that answers it in passing closes it**, and the reply says which.

- **Where an answer is needed to go on, take the likelier reading and tag it `assumption:`**, rather than stopping.
  The question stays open, with the assumption filed under it, so what builds on the guess is visible as resting on it.

## 4. Keep the record

**Update the scratch file before every reply.**
The conversation is the input; the record is the state.

- **Every entry has a typed ID**, prefixed by its kind, per `chalk:voice`.
  D for a decision and Q for a question; a constraint, an idea or anything else takes whatever prefix fits.

- **An ID is stable for the session.**
  A superseded decision keeps its ID, marked `superseded by D<n>`, so a reference the user made earlier still points where it did.
  A gap in the numbering is a decision that was revised away, not one to fill.

- **The record is organised by area, not by when things were said.**
  It opens with a one-line thesis once there is one, then the settled claims, then a section per area opening with its claim, then what's out of scope.

- **Out of scope is a section, not a deletion.**
  What the user parked keeps its ID there.

## 5. Each reply says what changed

**The reply is short: what was filed, what it leads to, and what you're asking.**

- **Name each entry you filed or changed by ID and subject line.**

- **Give the whole record only when asked for it**, or when the user asks what's still open — `chalk:sitrep` reports it.

- **Consequences and conflicts go at the bottom of the reply**, which is what the user reads first, per `chalk:voice`'s placement for chat.

## 6. The user chooses the output

**When the user is done, offer what the record could become, and let them pick.**
A Claude Docs doc or an artifact, cards through `chalk:issue`, a plan through `chalk:pick-up` once there's a card for it, or nothing beyond the scratch file.

- **You MUST NOT choose for them** or publish before they've chosen.

- **Whatever they choose is written from the record**, in that destination's own form, with its IDs kept where it has a reader who might reply on one.

- **Rubber-ducking stops where a card starts.**
  Once the work is one card's, `chalk:pick-up` journals its plan, taking what bears on that card from the record.
