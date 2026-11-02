---
name: drive
description: >
  Land one ready sub-goal to the project's standards through the drive agent, as one of three kinds of frame: a tidy changes structure, an advance changes behaviour, an amend makes an earlier unlanded commit fit for purpose.
  Where a dart takes the straight line to the goal, a drive takes the road — the coding standards, tests, definition of done and review the dart ignored.
  A drive is a stack: a tidy, an amend or a prequel can interrupt the frame in hand, and a better drive can pre-empt it; each lands at the lowest point in the branch its dependencies allow.
  Use when the user says "drive <sub-goal>", "land this", "tidy <what>", "this needs a tidy first", "pause, let's tidy that", "fix up that earlier commit", picks a sub-goal offered by `/a-star`, `a-star:dart` or another drive, or a dart or drive turns up a structure change.
user-invocable: true
argument-hint: "<sub-goal, or the structure change needed>"
---

# a-star Drive

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: a small change, ready to merge, that the user can review from its diff and message alone** — and, once it lands, page that part of the card out of their head.

**A dart takes the straight line to the goal; a drive takes the road.**
The walls the dart ignored — the project's coding standards, its tests, its definition of done, its code review — are what a drive navigates.

Load `a-star:a-star` first; the drive's states are in its spec.

**You, the orchestrator, hold the stack; the `drive` agent lands each frame.**
It reports what it turns up and commits what it lands; you triage, choose, record, and may rewrite its commit.
The rules below bind whoever is writing the frame — the agent, and you where you rewrite.

## Frames

**A drive is a stack of frames, and every frame is a tidy, an advance or an amend, decided before it starts.**
No two kinds share a commit.

- **Tidy** — changes structure, never behaviour.
  **Success: an equivalence change that gives us options**, reviewable by asking only *could this change anything?*
  A change that could change anything isn't a tidy.

- **Advance** — changes behaviour, moving the base a step towards the goal.
  **A structure change turning up mid-advance is a tidy**, never part of this commit: decide [now, later or never](#a-tidy-now-later-or-never), and if now, it interrupts the advance.

- **Amend** — makes an unlanded commit on the branch fit for the drive's purpose, or completes it, and lands inside that commit.
  It keeps the kind of the commit it amends: an amended tidy still changes no behaviour, an amended advance stays within its scope; anything beyond that is a new sub-goal.
  Once that commit has landed on the target branch, a change to its code is an ordinary tidy or advance.

## Where a frame lands

**Every frame lands at the lowest point in the branch its dependencies allow.**
The user reviews the branch commit by commit, so its order is the order a reviewer is best shown, not the order the work happened in.

- **A prequel — usually a tidy depending on nothing in the branch — lands at the branch's base.**
  It can then be cherry-picked onto main, and drops out of the PR once the branch is rebased.
- **An amend lands inside the commit it amends.**
- **Anything else lands at the top.**

**Anywhere but the top rewrites the branch**, so it needs the project's answer to whether its feature branches may be rewritten, and a force-with-lease push where they're pushed.
Without that answer, it's a question for the user.

**The branch reads as though each commit was right first time.**
An intermediate shape and its correction are two things for the reviewer to page in where one would do.
An amended commit's message describes its final shape, the PR mentions an amend only where it leaves a consequence the reader bears, and the journey stays in the session's record.

## In every frame

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

**A structure change to code this branch introduced, before that code has landed, is not a tidy: it is an amend of the commit that introduced it.**
There is no earlier shape worth a commit, and a reviewer would read the complex version and then its simplification where one simple commit would do.

- **Now** — it's worth having however the rest of the card turns out, or the work in hand needs it.
- **Later** — whether it's worth having depends on the behaviour change: record it as a sub-goal, and carry on.
- **Never** — it opens no option; don't record it.

**Where it lands is per the project's answer to how a tidy lands**; where it's silent, the feature branch, as a prequel where it depends on nothing in the branch.

- **Feature branch** — it lands with the card's advances.
- **Main** — a tidy branch off main, for the user to merge; rebase the feature branch onto it as soon as it's committed.

## Doing it

1. **Record it as what's in hand, before anything is edited.** Its task already exists, from when the sub-goal was recorded at triage — a tidy, amend or prequel pushed onto the stack included.

2. **Spawn the `drive` agent with the frame as its brief** — its sub-goal, kind and placement; the decisions and principles in force; the darts' evidence — plus the branch to work from and its head: for an advance, the card's feature branch off the project's base branch; for a tidy, where it lands.
   You MAY point it at where the card's work is recorded instead, to read and never write.
   Pass `isolation: "worktree"`, and run it in the background, so it can message you as it goes.

3. **Triage what it reports as it goes**, per `a-star:a-star` — a stretch of route nobody darted, a better split of a later sub-goal, a constraint — without stopping the frame.

4. **When it ends its turn on something that stops the frame**, decide: a user's decision is offered in primary; an earlier commit to fix is an amend frame; a better drive is a pre-emption; a failure is [Handling Drive Failure](#handling-drive-failure).
   Then resume it with `SendMessage`, or push the new frame.

5. **Take its commit onto the feature branch at the frame's placement**, rewriting its place or message where the branch should read otherwise, and push where the project's answer says to.

6. **Record the sub-goal done**, with its commits, and complete its task; record what its report taught, and add a task for any sub-goal it turned up.
   A frame that interrupted another pops: rebase the WIP onto it, and resume what it interrupted.
   A dart branch under it is the dart agent's to rebase or redo.

7. **Clear the darts this drive superseded** — each whose code no longer holds evidence a remaining sub-goal needs.
   First record what it taught that the record doesn't yet hold: what it found, and where the road departed from its route.
   Then remove its branch and worktree per the project's branch cleanup.

**Hand over** the branch, its head, and what the reviewer has to check — the decisions and assumptions the change rests on.
In secondary, the handover goes in the session's record and doesn't end the turn.
**Then you are back to choosing, per `a-star:a-star`.**
Merging is the user's; once they have, remove what only served it per the project's branch cleanup.

## Interrupting the frame in hand

**A tidy needed now, an amend, or a prequel pushes a frame on top of the one in hand**, landed by a drive agent of its own.
The agent in hand has WIP-committed its work before ending its turn; rebase that afterwards — or discard it to redo on the new structure, whichever is cheaper — and mark its task blocked by the new frame's.
You MUST NOT use `git stash`: it's shared across worktrees.

**A frame can itself be interrupted** — push another on top, and pop back the same way.

**A better drive found mid-drive pre-empts the one in hand.**
Set the original aside as a WIP commit, land the pre-empting drive, then rebase the WIP onto it and resume the original with what is left of it.
A pre-empted drive is kept and resumed; a failed one is thrown away and re-split.

**Stopping before it's done**: WIP-commit the work, leave it recorded as in hand, and park — whatever else is ready.
With the stack unpopped, the WIP commits and what's recorded as in hand are what the next session resumes from.

## Handling Drive Failure

**A drive has failed once its change is no longer atomic, or no longer comprehensible** — more than one change, or more than a reviewer can hold in their head.
Other signs: the same failure twice; a fix reaching into code the sub-goal didn't name; a test you'd have to weaken to get past; the code not being what the plan assumed.

**Step back rather than push on**: set the drive aside — WIP-commit it or revert it — mark its sub-goal not ready, and remove its task.
It is readied again once its re-split's tidies have landed, or superseded by the sub-goals that replace it.

- **Break it down again, per *Tidy First?*'s "Getting Untangled"** — by default, discard the drive and redo it tidying first, with what it taught.
  However the work then splits, each change is atomic and comprehensible, recorded as a sub-goal.
- **Throw a dart where the route is what's unknown**, from where the work is, with what the drive taught.
- **Take it back to the user where a decision is** — the sub-goal's scope, the plan, an invariant.
  In secondary, record it as an open question blocking the sub-goal, and move to other ready work.
