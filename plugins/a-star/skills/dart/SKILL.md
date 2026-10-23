---
name: dart
description: >
  Reach a ready card's goal end-to-end with the dart agent, triaging what it raises as it goes — increments ready to land, findings that invalidate the plan, questions about the route — and harvesting the sub-goals it found.
  Use when `/a-star` offers a dart, or the user says "dart this", "throw a dart", "throw the dart".
user-invocable: true
argument-hint: "[card, if not already in session]"
---

# a-star Dart

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: the unknowns and constraints on the route to the goal are surfaced while they could still change it, the next steps are suggested, and the dart wrote no more than that took, with nothing landed.**
The next steps are sub-goals that together complete the card, each small enough for a human to hold in their head, on data structures that match the problem.
A passing suite is not part of it.

Load `a-star:a-star` first.

## Brief the dart agent

**Spawn the `dart` agent with the card as its whole brief** — the goal, invariants and out of scope from the tracker issue, the sub-goals already found, the decisions in force — plus the branch to start from and its head: the card's feature branch, else the project's base branch.
You MAY point it at where the card's work is recorded instead, to read and never write.

- **The brief MUST NOT ask for a green suite or for proof of the end-to-end**, which sets the bar the dart then aims for.
- **Pass `isolation: "worktree"`, and run it in the background**, so it can message you as it goes.
- **`.claude/worktrees/` MUST be ignored by git**; add it to `.git/info/exclude` where it isn't.
- **Every dart starts fresh from the current base**; an old dart is evidence, never resumed.
- **A dart branch is local: it MUST NOT be pushed**, by the dart agent or by you.
  Its code never lands, so nothing outside this session needs it.
- **Darts run in parallel — with each other, and with a drive; drives run one at a time.**
  Dart whatever is ready that nothing in flight already covers.
  A dart MAY start from another dart's branch instead of the base, where what it needs hasn't landed yet.

## While it runs

- **An increment ready to land** — record it as a sub-goal, and tell the user.
  In primary it lands only on their go-ahead; in secondary, per `a-star:secondary`.

- **A finding that invalidates the plan** — the card's contract, a decision already made, an invariant, or the cost of the agreed route.
  It is the user's to settle, in either mode: in secondary, record it as an open question, halt the line of work it bears on, and move to other ready work.

- **A question about the route** — answer it, or in primary escalate it; record the decision and resume the dart agent with `SendMessage`.
  A question the card itself can't answer means the card isn't ready: end the dart, and make it ready.

## Harvest

**Record what you accept from the dart agent's report:**

- **the sub-goals**, each with what it depends on — together they MUST complete the card;
- **the decisions** — the dart agent's you keep;
- **the questions**, each with what it blocks;
- **the assumptions and risks**, including each invariant it broke;
- **the data structures that matched the problem**, and the dart's branch and head.

**Keep the dart branch only while its code is still evidence a drive needs.**
Once the sub-goals it informed have landed, or what it found is recorded well enough that nothing needs its code, whichever comes first, remove it and its worktree per the project's branch cleanup.

**Then move to the next step from the ready sub-goals, per the mode** — or another dart, where part of the goal is still unwalked.
