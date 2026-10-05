---
name: spike
description: >
  Reach a ready card's goal end-to-end with the spiker, triaging what it raises as it goes — increments ready to land, findings that invalidate the plan, questions about the route — and harvesting the sub-goals it found.
  Use when `/a-star` offers a spike, or the user says "spike this", "run the spike", "throw the dart".
user-invocable: true
argument-hint: "[card, if not already in session]"
---

# a-star Spike

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: the route to the goal is known, cheaply, with nothing landed** — the data structures that match the problem, sub-goals that together complete the card, each small enough for a human to hold in their head, and every question, assumption and risk on the way surfaced while it could still change the route.

Load `a-star:a-star` first.

## Brief the spiker

**Spawn the `spiker` agent with the card as its whole brief** — the goal, invariants and out of scope from the tracker issue, the sub-goals already found, the decisions in force — plus the branch to start from and its head: the card's feature branch, else the project's base branch.
You MAY point it at where the card's work is recorded instead, to read and never write.

- **Pass `isolation: "worktree"`, and run it in the background**, so it can message you as it goes.
- **`.claude/worktrees/` MUST be ignored by git**; add it to `.git/info/exclude` where it isn't.
- **Every spike starts fresh from the current base**; an old spike is evidence, never resumed.

## While it runs

- **An increment ready to land** — record it as a sub-goal, and tell the user.
  In primary it lands only on their go-ahead; in secondary, per `a-star:secondary`.

- **A finding that invalidates the plan** — the card's contract, a decision already made, an invariant, or the cost of the agreed route.
  It is the user's to settle, in either mode: in secondary, record it as an open question, halt the line of work it bears on, and move to other ready work.

- **A question about the route** — answer it, or in primary escalate it; record the decision and resume the spiker with `SendMessage`.
  A question the card itself can't answer means the card isn't ready: end the spike, and make it ready.

## Harvest

**Record what you accept from the spiker's report:**

- **the sub-goals**, each with what it depends on — together they MUST complete the card;
- **the decisions** — the spiker's you keep;
- **the questions**, each with what it blocks;
- **the assumptions and risks**, including each invariant it broke;
- **the data structures that matched the problem**, and the spike's branch and head.

**Keep the spike branch until the sub-goals it informed have landed**, then remove it per the project's branch cleanup.

**Then offer the next step from the ready sub-goals, and wait** — or another spike, where part of the goal is still unwalked.
