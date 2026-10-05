---
name: refine
description: >
  Make a card ready to spike by agreeing its root with the user — the what: its goal, invariants and out of scope, on the tracker issue, with its open questions in the session's plan.
  Breaking the card into landings is the spike's job, not refine's.
  Use when `/a-star` routes here, or the user says "refine this card", "plan this the a-star way", or is about to plan a-star work.
user-invocable: true
argument-hint: "[card, if not already in session]"
---

# a-star Refine

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: the user and the super agent agree what the card is for**, so a spike can start from the tracker issue alone, and the user no longer has to hold the card's intent in their head.

**Refinement agrees what the card is for, never how it gets there.**
The breakdown into landings is what a spike finds, against the current base; writing it down first is writing down the spike's work before the evidence exists.

**Refinement is made of the user's answers, so it happens in a primary session.**
In a secondary session, record the questions in the plan and park the card per the project's conventions for putting one down, rather than answering them yourself.

Load `a-star:a-star` first.

**Refining changes the tracker issue and the plan, and nothing else**: no code, no other files.

## The root

**The tracker issue holds the card's root**, written through the project's writing conventions:

- **Goal** — what is true once the card is done, stated as behaviour, not as code.
- **Invariants** — what must stay true however the spike gets there; where the project names core invariants, the ones this card touches.
- **Out of scope** — what the card deliberately doesn't cover.

**What else the issue carries is the writing conventions' call**, an approach included; a-star needs only the root agreed.

**A card with no tracker issue keeps its root at the top of the plan instead.**

**Refine writes no landings into the plan.**
The spike's harvest does.

## Testing the root

**Ask what would stop the goal**, not what would achieve it — that is where the questions are.

- **Say out loud what the goal leans on that we don't do ourselves** — the user, CI, another team, an upstream library, existing behaviour, a plain fact about the world.
  Each is an assumption in the plan's card-level section, so the spike is briefed on it and a broken one is noticed.

- **A question the user has to answer is an open question in the plan.**
  A spike can't start past it.

## Closing a gap

**A gap in the root MUST be surfaced, not papered over.**
Close it deliberately, with one of:

- **Achieve the goal a different way.**
- **Reassign it** to someone or something that won't fail like that.
- **Add an invariant that prevents it.**
- **Make it less likely** without eliminating it.
- **Let it happen, and recover afterwards.**
- **Let it happen, and limit the damage.**
- **Weaken the goal** — and update out of scope, so the next spike isn't briefed on the stronger goal.
- **Accept the risk** — a risk in the plan's card-level section.

**Every move is recorded as a decision in the plan**, *weaken the goal* and *accept the risk* most of all, because they leave no other trace.

## It ends at readiness

**The card is ready when a spike can start from it alone** — the test in `a-star:a-star`.

**Before refinement ends, the tracker issue says what it agreed**, written through the project's writing conventions: every decision that bears on the problem or the agreed scope, not only the root.
A decision left only in the session's working state is one the issue's next reader never sees.

**Once it's ready, offer `a-star:spike`, or putting the card down** per the project's conventions.
Stopping short of ready puts its open questions on the issue as it goes down, so the next `/a-star <card>` resumes from there.
