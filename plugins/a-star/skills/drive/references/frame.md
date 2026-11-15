# A frame

What a frame is, where it is committed, and the rules it is written to.
They bind whoever is writing the frame — the `drive` agent, and the orchestrator where it rewrites the agent's commit.

## Frames

**A drive is a stack of frames, and every frame is a tidy, an advance or an amend, decided before it starts.**
No two kinds share a commit — `a-star:a-star`'s rule that a structure change and a behaviour change never do.

- **Tidy** — changes structure, never behaviour.
  **Success: an equivalence change that gives us options**, reviewable by asking only *could this change anything?*

- **Advance** — changes behaviour, moving the base a step towards the goal.
  **A structure change turning up mid-advance is a tidy**, never part of this commit: decide [now, later or never](#a-tidy-now-later-or-never), and if now, it interrupts the advance.

- **Amend** — makes an unlanded commit on the branch fit for the drive's purpose, or completes it, and is committed inside that commit.
  It keeps the kind of the commit it amends: an amended tidy still changes no behaviour, and an amended advance keeps its subject line true.
  - **An advance's scope is its commit's claim, its subject line.**
    An amend may change the mechanism completely while the subject still holds.
    One that would change the subject is a new sub-goal, or a revert.
  Once that commit has landed on the project's base branch, a change to its code is an ordinary tidy or advance.
  - **A new approach to an unlanded commit is an amend of that commit, wherever it sits in the branch, and never a later commit on top.**
    A reviewer would otherwise read an approach and then its replacement, agreeing with a commit the branch goes on to undo.
    Where the approach spans several commits, it's a revert instead.

## Where a frame is committed

**Every frame is committed at the lowest point in the branch its dependencies allow.**
The user reviews the branch commit by commit, so its order is the order a reviewer is best shown, not the order the work happened in.

- **A prequel — usually a tidy depending on nothing in the branch — is committed at the branch's base.**
  It can then be cherry-picked onto main, and drops out of the PR once the branch is rebased.
- **An amend is committed inside the commit it amends.**
- **Anything else is committed at the top.**

**Anywhere but the top rewrites the branch**, per `chalk:chalk`'s Feature branches.

**The branch reads as though each commit was right first time.**
An intermediate shape and its correction are two things for the reviewer to page in where one would do.
An amended commit's message describes its final shape, the PR mentions an amend only where it leaves a consequence the reader bears, and the journey stays in the session's record.

## In every frame

- **One ready sub-goal, small enough for a reviewer to hold in their head**; one too big is two — record both before starting.
- **What the darts found is evidence, never code to edit into shape.**
- **Write it to the project's coding standards.**
- **Obviously no bugs, not no obvious bugs** — Hoare's distinction.
  **The test: a human reviewing the change in isolation can see it has none** — for a tidy, this is its success criterion.
  A change that fails the test wants a tidy under it first, or is two sub-goals.
- **Simple, not easy** — Rich Hickey's *Simple Made Easy*.
  Un-braid concerns rather than reach for what's nearest to hand; state that can be derived, or can drift from what it mirrors, shouldn't exist.
  **The test: a human reviewing the change in isolation can see each concern on its own**, confirming one without holding the rest of the change in their head.
- **Accidental complexity recognised for what it is** — Moseley & Marks, *Out of the Tar Pit*.
  Complexity the problem doesn't impose has to earn its place — performance is the usual reason — and the commit says what it buys.
- **Illegal states unrepresentable** — Minsky, *Effective ML*.
  A field guarded at every use wants a type, not another check.
- **No generality the sub-goal didn't ask for.**
- **No dead code.** Everything the commit adds has a caller outside the tests in this commit; a new abstraction nothing yet calls is committed with the first change that calls it.
  A tidy reshapes code that already runs.
- **The suite stays green.** A test weakened or disabled to get past it is a broken invariant: report it, don't commit it.

## A tidy: now, later or never

**A structure change to code this branch introduced, before that code has landed, is not a tidy: it is an amend of the commit that introduced it.**

- **Now** — it's worth having however the rest of the card turns out, or the work in hand needs it.
- **Later** — whether it's worth having depends on the behaviour change: record it as a sub-goal, and carry on.
- **Never** — it opens no option; don't record it.

**Where it is committed is per the project's answer to where a tidy is committed**; an unanswered one is a question, per `a-star:a-star`'s [What the project says](../../a-star/SKILL.md#what-the-project-says).

- **Feature branch** — it lands with the card's advances.
- **Main** — a tidy branch off main, for the user to merge; rebase the feature branch onto it as soon as it's committed.
