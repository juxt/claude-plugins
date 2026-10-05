---
name: spike
description: >
  Reach a ready card's goal end-to-end with the spiker, triaging what it raises as it goes — open questions, assumptions, risks, decisions, and increments ready to land — and harvesting what it found into the plan.
  Use when `/a-star` routes here on a ready card, or the user says "spike this", "run the spike", "throw the dart".
user-invocable: true
argument-hint: "[card, if not already in session]"
---

# a-star Spike

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: the route to the goal is known, cheaply, with nothing landed** — the data structures that match the problem, landings that demonstrably complete the card, each small enough for a human to hold in their head, and every question, assumption and risk on the way surfaced while it could still change the route.

**A spike's goal is broad and end-to-end; it lands nothing.**
It finds the route, and breaks the card into the landings the route revealed.

Load `a-star:a-star` first.

## Brief the spiker

**Spawn the `spiker` agent with the card as its whole brief** — the goal, invariants and out of scope from the tracker issue, the landings already found and the decisions in force — plus the branch to start from and its head.
You MAY give it the plan's path instead of copying the plan out, told to read it and never write it.
That's the card's feature branch where it has one, else the project's base branch: a card's first spike comes before anything has landed.
Pass `isolation: "worktree"`, and run it in the background: only a background sub-agent can `SendMessage` the main session, which is how it reports increments without stopping.
The spiker checks its own base first, since the worktree is cut from wherever the session is.

**Every spike starts fresh from the current base; an old spike is evidence, never resumed.**
The base has probably moved since, and spikes are cheap.

## While it runs

**The spiker writes nothing shared**: it messages what can't wait, and reports the rest at the end. In primary, relay what matters to the user as it arrives.

- **An increment it messages you** — a tidy, or an atomic change of value to the user, it's reasonably sure no later increment will redo.
  Record it as a landing in the plan, and tell the user it could land now, while the spike carries on.
  In primary it lands only on their go-ahead; in secondary, per `a-star:secondary`.

- **A finding that invalidates the plan** — the card's contract, a decision already made, an invariant, or the cost of the route the card agreed.
  It goes to the user in either mode, never decided by the super agent: in secondary, record it as an open question, halt the line of work it bears on, and move to other ready work.
  The bigger the gap between what was agreed and what the spike found, the less the agreement still stands for.

- **A turn it ends on** — stuck, or a question whose answer would change its route.
  Decide it yourself, or — in primary — escalate it to the user; in secondary, where nobody can answer, decide, assume or halt per `a-star:secondary`.
  Record the answer as a decision in the plan, with who made it, and resume the spiker with `SendMessage`.
  A question the card itself can't answer means the card wasn't ready: end the spike and route to `a-star:refine`.

## Harvest

**The super agent decides what stands; the spiker's report and branch are the evidence.**
Write into the plan what you accept:

- **The landings that break the card down** — a section each, in landing order; together they MUST demonstrably complete the card.
- **The decisions** — the spiker's that you keep, as decided by the agent, or answered by the user.
- **The questions** — answered, or carried as open questions in the section each blocks.
- **The assumptions and risks** — in the section each concerns; a broken invariant becomes whichever fits: a risk, an assumption the work carried on past, or a decision to accept it.
- **The data structures that matched the problem** — card-level, since every later landing is built on them.
- **The spike's branch, head and what its route showed** — card-level.
  The branch stays as a reference until the landings it informed have landed; `a-star:landed` removes it then.

## After

**Offer what's next, and wait**: `a-star:drive` or `a-star:tidy` on a recorded increment, another spike from the new base where part of the goal is still unwalked, or `a-star:refine` where a spike exposed a gap.

**Each spike's diff against the base should be smaller than the last**, as increments land under it.
**The card is done when every landing in the plan has landed** — `a-star:landed` checks, once their commits are on the target.
