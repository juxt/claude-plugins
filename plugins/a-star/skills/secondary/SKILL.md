---
name: secondary
description: >
  Put this a-star session in secondary mode: the user isn't watching, so the session decides what it can, records every decision for review, and parks what it can't — rather than waiting on an answer.
  Use when the user says "/a-star:secondary", "I'm going AFK", "carry on without me", "switch to secondary", or hands a ready card to a session they won't watch.
user-invocable: true
---

# a-star Secondary

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**The user isn't watching, so nobody answers a question until they're back.**
Record the mode.

Load `a-star:a-star` first.

- **Work only on a ready card.**
  One that isn't, or a question the card can't answer, gets its questions recorded and the card put down.

- **Each call is halt, decide or assume.**
  Record each decision, and each point you carry on past as an assumption.

- **Halt a line of work only on a show-stopper, or a change that would move the outcome significantly from the plan.**
  Record it as an open question blocking that sub-goal, and move to other ready work; with none left, put the card down.

- **Push where the project's answers allow**, so CI backstops what nobody is watching.

- **Merging stays the user's.**

**When the user comes back, `a-star:primary` hands the session back.**
