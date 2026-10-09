---
name: drive
description: >
  Land one ready sub-goal to the project's standards, in one of two modes: a tidy changes structure, an advance changes behaviour.
  Where a dart takes the straight line to the goal, a drive takes the road — the coding standards, tests, definition of done and review the dart ignored.
  A tidy can interrupt the work in hand: decide now, later or never, park the work, land the tidy, and resume. Recursive — a tidy can be interrupted by another.
  Use when the user says "drive <sub-goal>", "land this", "tidy <what>", "this needs a tidy first", "pause, let's tidy that", picks a sub-goal offered by `/a-star`, `a-star:dart` or another drive, or a dart or drive turns up a structure change.
user-invocable: true
argument-hint: "<sub-goal, or the structure change needed>"
---

# a-star Drive

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: a small change, ready to merge, that the user can review from its diff and message alone** — and, once it lands, page that part of the card out of their head.

**A dart takes the straight line to the goal; a drive takes the road.**
The walls the dart ignored — the project's coding standards, its tests, its definition of done, its code review — are what a drive navigates.

Load `a-star:a-star` first.

## Modes

**Every drive is a tidy or an advance, decided before it starts, and the two never share a commit.**

- **Tidy** — changes structure, never behaviour.
  **Success: an equivalence change that gives us options**, reviewable by asking only *could this change anything?*
  A change that could change anything isn't a tidy.

- **Advance** — changes behaviour, moving the base a step towards the goal.
  **A structure change turning up mid-advance is a tidy**, never part of this commit: decide [now, later or never](#a-tidy-now-later-or-never), and if now, it interrupts the advance.

## In either mode

- **One ready sub-goal, small enough for a reviewer to hold in their head**; one too big is two — record both before starting.
- **What the darts found is evidence, never code to edit into shape.**
- **Write it to the project's coding standards.**
- **Obviously no bugs, not no obvious bugs** — Hoare's distinction.
  **The test: a human reviewing the change in isolation can see it has none** — for a tidy, this is its success criterion.
  Where they can, they confirm it and page it out, which takes far more off their mind than any review that leaves them unsure they've looked hard enough.
  A change that fails the test wants a tidy under it first, or is two sub-goals.
- **Simple, not easy** — Rich Hickey's *Simple Made Easy*.
  Un-braid concerns rather than reach for what's nearest to hand; state that can be derived, or can drift from what it mirrors, shouldn't exist.
  **The test: a human reviewing the change in isolation can see each concern on its own**, confirming one without holding the rest of the change in their head.
- **No generality the sub-goal didn't ask for.**
- **No dead code.** Everything the commit adds has a caller outside the tests in this commit; a new abstraction nothing yet calls lands with the first change that calls it.
  A tidy reshapes code that already runs.
- **The suite stays green.** A test weakened or disabled to get past it is a broken invariant: report it, don't commit it.

## A tidy: now, later or never

- **Now** — it's worth having however the rest of the card turns out, or the work in hand needs it.
- **Later** — whether it's worth having depends on the behaviour change: record it as a sub-goal, and carry on.
- **Never** — it opens no option; don't record it.

**Where it lands is per the project's answer to how a tidy lands**; where it's silent, the feature branch.

- **Feature branch** — it lands with the card's advances.
- **Main** — a tidy branch off main, for the user to merge; rebase the feature branch onto it as soon as it's committed.

## Doing it

1. **Record it as what's in hand.**
   A tidy interrupting the work in hand first sets that work aside — as a WIP commit to rebase afterwards, or discarded to redo on the tidied structure, whichever is cheaper — and goes on the stack: a sub-goal the interrupted one depends on, in hand on top of it.
   You MUST NOT use `git stash`: it's shared across worktrees.

2. **Work on a branch off its target**, in its own worktree — for an advance, the card's feature branch off the project's base branch; for a tidy, where it lands.

3. **Write it**, per [In either mode](#in-either-mode).

4. **Verify it** against the project's definition of done and its answer to how this mode lands, with the code review the project's conventions call for.

5. **Commit**, and push where the project's answer says to.

6. **Record the sub-goal done**, with its commit.
   A tidy that interrupted something pops: rebase the feature branch onto it, and resume what it interrupted.
   A dart branch under it is the dart agent's to rebase or redo.

**A tidy can itself need a smaller tidy first** — push another on top, and pop back the same way.

**Hand over** the branch, its head, and what the reviewer has to check — the decisions and assumptions the change rests on.
**Then offer the next step from the ready sub-goals, and wait.**
Merging is the user's; once they have, remove what only served it per the project's branch cleanup.

**Stopping before it's done**: WIP-commit the work, leave it recorded as in hand, and put the card down.
With the stack unpopped, the WIP commits and what's recorded as in hand are what the next session resumes from.
