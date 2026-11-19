---
name: primary
description: >
  Put this chalk session in primary mode: the user is actively watching its progress, so they steer as it goes, and the session manages their context — what their current thread needs now, and everything else at its close. A session starts primary, unless it runs headless or scheduled, when it starts secondary; use this to switch back from secondary.
  Use when the user says "/chalk:primary", "I'm back" or "switch to primary".
user-invocable: true
---

# chalk Primary

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: the session manages the user's context — they see only what their current thread needs, and the session is responsible for raising everything else at the right time.**

Load `chalk:chalk` first.

- **A session starts primary, unless it runs headless or scheduled, when it starts secondary.**
  Record the mode in the plan file's journal, and each switch as it happens.

- **Coming back from secondary, record the mode, then refresh the user's context** with a sitrep (`chalk:sitrep`) — leading with the decisions made while they were away and the questions left for them.

- **Offer the user what is theirs, and take it only on their yes**: plan approval, a reversed finish, a question only they can answer.
  A question from the user is not that yes.

- **Escalate what the user should decide, and decide the rest yourself**; every question costs them context.

## Arrivals wait for the thread's close

**This is interruption management: defer to breakpoints (Iqbal & Bailey), with the session mediating (McFarlane), and GTD's inbox, open loops and review.**
chalk's deltas:

- **A thread is the topic the user's last message engages with, and its close is the breakpoint.**
  It lasts until it resolves: a decision is reached, the user drops it, or they change the subject.

  - **Raising several questions opens one thread each.**
    The one the user answers is wrapped up first; the rest stay open loops.

- **Mid-thread, a background arrival goes to the inbox** — a sub-agent's report, a gate, a test run, CI, a weeder's output, a move to offer.

  - **A reply inside the thread carries no "meanwhile…" tail.**

  - **A turn woken only by an arrival writes at most one short line, and never the arrival's content.**
    The harness forces visible output after a silent turn.

  - **Work an arrival unblocks goes on silently, where it needs no yes.**

- **An arrival breaks into the thread only where it materially affects it** — it breaks a premise the user is reasoning from, or answers the question under discussion.
  It is framed as what it changes for the thread.

  - **The session judges materiality, never the user**: asking would itself interrupt.

- **At the breakpoint, raise the inbox triaged, not in the order it arrived**, in `chalk:sitrep`'s shape where that serves:

  1. decisions, with the pending move offers batched into one;
  2. what changes the user's picture;
  3. the open loops, and one line for the rest.

  - **With no thread open, raise each arrival as it lands**, under the same triage.

- **The inbox is the journal's `inbox:` entries**, per `chalk:chalk`, so a compaction loses nothing.
  An entry is cleared once raised.

## Under a harness

**An implementation harness says what primary means for its own moves**, in its own skills — for a-star, `a-star:a-star`'s Primary and secondary.
What it turns up reaches the user through the inbox above.
