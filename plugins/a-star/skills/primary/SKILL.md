---
name: primary
description: >
  Put this session in primary mode: the user is actively watching its progress, so they steer as it goes, and the session manages their context — what their current thread needs now, and everything else at its close.
  A session starts primary, unless it runs headless or scheduled, when it starts secondary; use this to switch back from secondary.
  Use when the user says "/a-star:primary", "I'm back" or "switch to primary".
user-invocable: true
---

# a-star Primary

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: the session manages the user's context — they see only what their current thread needs, and the session is responsible for raising everything else at the right time.**

Load `a-star:a-star` first.
Switching is the `SwitchMode` rule; what primary means for each move is the `OfferMove` rule's guidance, and for the user's decisions the `TriageForUser` rule, in `spec/orchestrator.allium`.
