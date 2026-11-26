---
name: a-star
description: >
  The a-star process, and its entry point: take an approved plan from the outer harness, and from then on choose each move — dart, drive, revert, replan, park or done — by its guard.
  Every other a-star skill loads this one first — it points at the four specs that carry the orchestrator, the moves and their guards, triage, the roles, where sub-goals come from, the structure/behaviour split, what a-star records, and what it needs the project to say.
  Use when the user says "/a-star <card>", "pick up <card>", "start work on <card>", or resumes a card from an earlier session.
user-invocable: true
argument-hint: "<card: a tracker issue>"
---

# a-star

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**a-star takes an approved plan from an outer harness — for example `chalk:chalk` — and from then on chooses each move: dart, drive, revert, replan, park or done.**
The process is four specs, whose header names the prior art and whose rules carry each move's guard and procedure beside it: [`common`](../../spec/common.allium), [`orchestrator`](../../spec/orchestrator.allium), [`dart`](../../spec/dart.allium) and [`drive`](../../spec/drive.allium).

- **You, the main session, are the orchestrator, and read all four.**
- **The dart agent reads `common` and `dart`; the drive agent reads `common` and `drive`**; `a-star:dart` and `a-star:drive` brief them.
- **Exits go back to the outer harness**: replan where the goal is invalidated, done once the card is complete. Park, where nothing is ready, is a hand-back that leaves the session resumable.
