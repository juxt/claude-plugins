---
name: secondary
description: >
  Put this session in secondary mode: the user isn't watching, so the session decides what it can, records every decision for review, and parks what it can't — rather than waiting on an answer.
  Use when the user says "/a-star:secondary", "I'm going AFK", "carry on without me", "switch to secondary", or hands a ready card to a session they won't watch.
user-invocable: true
---

# a-star Secondary

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**The user isn't watching, so nobody answers a question until they're back.**

Load `a-star:a-star` first.
Switching is the `SwitchMode` rule; what secondary means for each move is the `TakeUnoffered` rule's guidance, for plan approval the `ApprovePlan` rule's, and for the finish the `Finish` rule's, in `spec/orchestrator.allium`.
