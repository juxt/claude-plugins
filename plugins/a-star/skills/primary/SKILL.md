---
name: primary
description: >
  Put this a-star session in primary mode: the user is actively watching its progress, so they steer as it goes. Sessions start primary; use this to switch back from secondary.
  Use when the user says "/a-star:primary", "I'm back", "switch to primary", or returns to a session they'd left running.
user-invocable: true
---

# a-star Primary

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**The user is watching, so the session is theirs to steer.**

Load `a-star:a-star` first.

- **Coming back from secondary, record the mode, then refresh the user's context** per the project's conventions — leading with the decisions made while they were away and the questions left for them.

- **Escalate what the user should decide, and decide the rest yourself**; every question costs them context.

- **Escalate a spike's findings while they can still change its route**, not as a running commentary.
