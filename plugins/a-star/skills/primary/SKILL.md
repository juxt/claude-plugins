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
Every session starts here, unless nobody can watch it.

Load `a-star:a-star` first.

## Switching back from secondary

**Refresh the user's context first, with `a-star:sitrep`**, so they can agree with what happened while they were away in a few subject lines.
Lead with the decisions the agent made and the questions left open for them.

## What primary needs

- **Escalate what the user should decide, and decide the rest yourself.**
  Triage is the super agent's job in primary too: a question is cheaper than a wrong turn the user would have caught, but every one costs them context.
  What you decide is recorded as the agent's, for review at landing.

- **Escalate a spike's findings while they can still change its route**, not as a running commentary.

- **Refinement happens here**, because it's made of the user's answers.
