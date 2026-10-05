---
name: a-star
description: >
  The a-star process, and its entry point: pick a card up, make it ready, and offer the next spike, tidy or drive from its ready sub-goals.
  Every other a-star skill loads this one first — it carries the loop, the roles, where sub-goals come from, the structure/behaviour split, what a-star records, and what it needs the project to say.
  Use when the user says "/a-star <card>", "pick up <card>", "start work on <card>", "refine this card", or resumes a card from an earlier session.
user-invocable: true
argument-hint: "<card: a tracker issue>"
---

# a-star

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

1. **Spike to an end-to-end as quickly as possible.**
2. **Use what the spike found to land atomic, comprehensible, correct, compliant changes.** Go to 1 as required.

**Throwing a tidy or a drive away is always an option**: revert it, mark its sub-goal not done, and spike again with what it taught.

## Roles

- **You, the main session, are the super agent.**
  You triage what spikes raise, and write everything that lands, including the tests.
- **The spiker reaches the goal end-to-end and reports.** Its code never lands.

**A user's question is a question, not a go-ahead.**
"Is that a good idea?" wants an answer; an offer of the next step waits for a yes.

## Sub-goals

- **Sub-goals come from spikes, not from reading the code.**
- **A sub-goal is one tidy or one drive**, landing as one commit.
- **Together, a card's sub-goals MUST complete it.**
- **The landed code keeps the data structures a spike got right**, and leaves out what it built around the ones it didn't.

**A structure change and a behaviour change never share a commit**: a tidy changes structure (`a-star:tidy`), a drive changes behaviour (`a-star:drive`).

## What to record

In whatever the session tracks its work with:

- **a sub-goal, and what it depends on;**
- **a decision** — a call you aren't sure of is an open question instead;
- **an open question, and what it blocks;**
- **a sub-goal done**, with its commit;
- **what's in hand** — the sub-goal being worked, and anything that interrupted it;
- **whether the user is watching** (`a-star:primary`, `a-star:secondary`).
  A session starts primary, unless nobody can watch it — headless, cloud or scheduled — when it starts secondary.

**Take the next step from the ready sub-goals.**

## `/a-star <card>`

1. **Pick the card up** per the project's conventions — for example, reading the issue and its neighbourhood, agreeing why it's being done now, then assigning it and marking it in progress.

2. **Make it ready.** A card is ready when a spike can start from it alone:
   - **its root is agreed** — goal, invariants and out of scope, on the tracker issue;
   - **no open question bears on the card itself**;
   - **the project's readiness conventions hold.**

   **Where it isn't, agree the root with the user** — what the card is for, never how it gets there.
   In secondary, record the questions and put the card down instead.
   **Before it ends, update the tracker issue with what was agreed**: every decision that bears on the problem or the agreed scope, not only the root.

3. **Offer the next step, and wait** — a spike where the card has no sub-goals yet or part of its goal is still unwalked, else a drive or tidy on a ready sub-goal.

## What the project says

**Everything not here follows the project's conventions** — writing, tracking, planning, picking a card up and putting it down, the base branch, ship/show/ask, the definition of done, coding standards.

**The project MUST answer three choices of a-star's own**:

- **How a tidy lands** — feature branch or main; what to verify before committing; when to push; whether it's done at commit or once CI is green.
- **How a drive lands** — what to verify before committing, and whether to push the feature branch as work lands.
- **Branch cleanup** — what happens to a branch once its work has landed.

**Raise an unanswered one as a question; don't fill it with a default.**
The exception is branch cleanup: absent an answer, delete local branches and worktrees whose work has fully landed, and only offer to delete remote ones.
