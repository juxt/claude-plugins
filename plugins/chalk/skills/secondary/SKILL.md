---
name: secondary
description: >
  Put this chalk session in secondary mode: the user isn't watching, so the session decides what it can, records every decision for review, and parks what it can't — rather than waiting on an answer.
  Use when the user says "/chalk:secondary", "I'm going AFK", "carry on without me", "switch to secondary", or hands a ready card to a session they won't watch.
user-invocable: true
---

# chalk Secondary

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**The user isn't watching, so nobody answers a question until they're back.**
Record the mode in the plan file's journal.

Load `chalk:chalk` first.

- **Each call is halt, decide or assume.**
  Record each decision, and each point you carry on past as an assumption.

- **Halt a line of work only on a show-stopper, or a change that would move the outcome significantly from the plan.**
  Record it as an open question naming what it blocks, and move to other ready work; with none left, park (`chalk:put-down`).
  - **An open question blocks a line of work only where it is a halt** — work whose plan routes around it stays ready.

- **Push wherever the project's answers allow**, so CI backstops what nobody is watching.

- **Merging stays the user's.**

## chalk's own stages

- **Plan approval is always the user's.**
  A secondary session never approves its own plan: it starts implementing only from a plan the user approved.
  With none, it plans, records its questions, and parks through `chalk:put-down`, the draft plan recorded.

- **The finish: where the work reverses the predicted finish, decide, record the reversal and its grounds, and take it.**
  Opening a PR the plan predicted, or one the reversal calls for, is allowed; merging it isn't.

- **The weed loops, for a PR and an issue: a question only the user can answer is recorded, and carried into the artefact as an open question marked for the user.**
  The loop ends when only such questions remain.

- **Put-down: where it would ask the user, decide and record.**

## Under a harness

**An implementation harness says what secondary means for its own moves** — for a-star, in the `OfferMove` and `TakeUnoffered` guidance of `a-star/spec/orchestrator.allium`.

## Switching back

**The session stays secondary until the user switches it back explicitly** — `/chalk:primary`, "I'm back".
A message while it runs doesn't change the mode; `chalk:primary` is what hands the session back.
