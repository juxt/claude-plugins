---
name: spike
description: >
  Reach a ready card's goal end-to-end with the spiker, triaging what it raises as it goes — open questions, assumptions, risks, decisions, and increments ready to land — and harvesting what it found into beads.
  Use when `/a-star` routes here on a ready card, or the user says "spike this", "run the spike", "throw the dart".
user-invocable: true
argument-hint: "[card, if not already in session]"
---

# a-star Spike

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: the route to the goal is known, cheaply, with nothing landed** — the data structures that match the problem, tasks and chores that demonstrably complete the card, each small enough for a human to hold in their head, and every question, assumption and risk on the way surfaced while it could still change the route.

**A spike's goal is broad and end-to-end; it lands nothing.**
It finds the route, and breaks the card into the tasks and chores the route revealed.

Load `a-star:a-star` first.

## Brief the spiker

1. **Create the spike's bead**: `bd create --type spike --parent <card>`, titled for the route it tries, and claim it.

2. **Spawn the `spiker` agent with the card as its whole brief** — the goal, invariants and out of scope from the tracker issue, `bd show` on the card and its children, the decisions in force — plus the branch to start from and its head, and the spike's bead.
   That's the card's feature branch where it has one, else the project's base branch: a card's first spike comes before anything has landed.
   Pass `isolation: "worktree"`, and run it in the background: only a background sub-agent can `SendMessage` the main session, which is how it reports increments without stopping.
   The spiker checks its own base first, since the worktree may be cut from the default branch.

**Every spike starts fresh from the current base; an old spike is evidence, never resumed.**
The base has probably moved since, and spikes are cheap.

## While it runs

**The spiker writes what it finds into its spike bead's subtree**; in primary, relay what matters to the user as it appears there.

- **An increment it messages you** — a tidy, or an atomic change of value to the user, it's reasonably sure no later increment will redo.
  Record it as a `chore` or a `task` under the card, and tell the user it could land now, while the spike carries on.
  In primary it lands only on their go-ahead; in secondary, per `a-star:secondary`.

- **A finding that invalidates the plan** — the card's contract, a decision already made, an invariant, or the cost of the route the card agreed.
  It goes to the user in either mode, never decided by the super agent: in secondary, record it as an open question, halt the line of work it bears on, and move to other ready work.
  The bigger the gap between what was agreed and what the spike found, the less the agreement still stands for.

- **A turn it ends on** — stuck, or a question whose answer would change its route.
  Decide it yourself, or — in primary — escalate it to the user; in secondary, where nobody can answer, decide, assume or halt per `a-star:secondary`.
  Record the answer as a decision under the card, `decided-by` whoever made it, and resume the spiker with `SendMessage`.
  A question the card itself can't answer means the card wasn't ready: end the spike and route to `a-star:refine`.

## Harvest

**The super agent decides what stands; the spike's subtree is the evidence.**
Read the spiker's report and walk its subtree, then promote into the card's tree what you accept:

- **The tasks and chores that break the card down** — under the card; together they MUST demonstrably complete it.
- **The decisions** — re-recorded under the card, `decided-by=agent` for the spiker's that you keep, or answered by the user.
- **The questions** — answered, or carried as open `decision` issues under the card.
- **The assumptions and risks** — notes on the node each concerns; a broken invariant becomes whichever fits: a `Risk:`, an `Assumption:` the work carried on past, or a decision to accept it.
- **The data structures that matched the problem** — a note on the card, since every later task is built on them.

**Close the spike bead and everything under it** — its questions included, once each is answered or re-recorded under the card — with the spike's branch, head, and what the route showed as the reason.
The branch stays as a reference until the tasks it informed have landed; `a-star:landed` removes it then.

## After

**Offer what's next**: `a-star:drive` or `a-star:tidy` on a recorded increment, another spike from the new base where part of the goal is still unwalked, or `a-star:refine` where a spike exposed a gap.

**Each spike's diff against the base should be smaller than the last**, as increments land under it.
**The card is done when every task and chore under it has landed** — `a-star:landed` closes it, once their commits are on the target.
