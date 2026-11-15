---
name: primary
description: >
  Put this chalk session in primary mode: the user is actively watching its progress, so they steer as it goes. A session starts primary, unless it runs headless or scheduled, when it starts secondary; use this to switch back from secondary.
  Use when the user says "/chalk:primary", "I'm back" or "switch to primary".
user-invocable: true
---

# chalk Primary

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**The user is watching, so the session is theirs to steer.**

Load `chalk:chalk` first.

- **A session starts primary, unless it runs headless or scheduled, when it starts secondary.**
  Record the mode in the plan file's journal, and each switch as it happens.

- **Coming back from secondary, record the mode, then refresh the user's context** with a sitrep (`chalk:sitrep`) — leading with the decisions made while they were away and the questions left for them.

- **Offer the user what is theirs, and take it only on their yes**: plan approval, a reversed finish, a question only they can answer.
  A question from the user is not that yes.

- **Escalate what the user should decide, and decide the rest yourself**; every question costs them context.

## Under a harness

**An implementation harness says what primary means for its own moves**, in its own skills — for a-star, `a-star:a-star`'s Primary and secondary.
