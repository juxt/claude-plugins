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
Nothing needs parking on the switch: the card's state is already in the plan. Record the mode at its top.

Load `a-star:a-star` first.

## What secondary needs

- **Only a ready card.**
  One that fails readiness, or a spike that finds a question the card can't answer, goes back to `a-star:refine` — record the question and park the card, rather than holding it as context.

- **With nobody to escalate to, each call is halt, decide or assume.**
  Every decision you make is recorded as the agent's, for review at landing; every point you carry on past is an assumption in the plan.

- **Stop a line of work only on a show-stopper, or a change that would move the outcome significantly from the plan.**
  Record it as an open question in the plan, against the landing it blocks, then move to other ready work; with none left, put the card down per the project's conventions.

- **A tidy's target follows the project's answer to how a tidy lands**, else the feature branch.

- **Push where the project's answers allow**, so CI backstops what nobody is watching.

- **Land nothing outside the project's ship/show/ask conventions.**
  Merging stays the user's act.

**When the user comes back, `a-star:primary` hands the session back.**
