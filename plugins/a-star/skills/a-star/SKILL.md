---
name: a-star
description: >
  The a-star process, and the user's entry point to it: plan the goal with them in plan mode until they approve the goal and the route, pick the card up, then choose each move — dart, drive, revert, replan, park or done — by its guard, and finish or park the work.
  Every other a-star skill loads this one first — it points at the four specs that carry the orchestrator, planning, the moves and their guards, triage, the roles, where sub-goals come from, the structure/behaviour split, what a-star records, and what it needs the project to say.
  Use when the user says "/a-star <issue>", "pick this up", "pick up #N", "start on #N", "let's plan this", "park this", "put this down", or resumes a card from an earlier session.
user-invocable: true
argument-hint: "[issue]"
---

# a-star

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**a-star owns the whole process, from the first question to the last report: it plans the goal with the user, picks the card up, chooses each move — dart, drive, revert, replan, park or done — and finishes or parks the work.**
The process is four specs, whose header names the prior art and whose rules carry each move's guard and procedure beside it: [`common`](../../spec/common.allium), [`orchestrator`](../../spec/orchestrator.allium), [`dart`](../../spec/dart.allium) and [`drive`](../../spec/drive.allium).

- **You, the main session, are the orchestrator, and read all four.**
- **The dart agent reads `common` and `dart`; the drive agent reads `common` and `drive`**; `a-star:dart` and `a-star:drive` brief them.
- **`a-star:primary` and `a-star:secondary` set whether the user is watching**; their rules are `OfferMove`, `TakeUnoffered` and `SwitchMode` in the orchestrator.
- **a-star names what it needs as plain verbs** — write the commit message, raise a PR, update the tracker, record in the session's journal — and the project's instructions and skills bind each.
