# A frame

What a frame is, where it is committed, and the rules it is written to.
They bind whoever is writing the frame — the `drive` agent, and the orchestrator where it rewrites the agent's commit.

## Frames

**A drive is a stack of frames, and every frame is a tidy, an advance or an amend, decided before it starts.**
No two kinds share a commit, per `a-star:a-star`'s [Sub-goals](../../a-star/SKILL.md#sub-goals).

- **Tidy** — changes structure, never behaviour.
  **Success: an equivalence change that gives us options**, reviewable by asking only *could this change anything?*

- **Advance** — changes behaviour, moving the base a step towards the goal.
  **A structure change turning up mid-advance is a tidy**, never part of this commit: decide [first, later or never](#a-tidy-first-later-or-never), and if first, it interrupts the advance.

- **Amend** — git's `fixup!` commit: it makes an unlanded commit on the branch fit for the drive's purpose, or completes it, and is autosquashed into it.
  a-star's deltas:
  - **It keeps the kind of the commit it amends**: an amended tidy still changes no behaviour, and an amended advance keeps its subject line true.
    That subject is the advance's claim: an amend may change the mechanism completely while it still holds, and one that would change it is a new sub-goal, or a revert.
  - **A new approach to an unlanded commit is an amend of that commit, wherever it sits in the branch, and never a later commit on top**; where the approach spans several commits, it's a revert instead.
  - **Pushed is not landed**: a commit stays amendable until it reaches the project's base branch, per `a-star:a-star`'s [Feature branches](../../a-star/SKILL.md#feature-branches), and from then on a change to its code is an ordinary tidy or advance.

## Where a frame is committed

**The branch is a stack of diffs, reviewed commit by commit, so its order is the order a reviewer is best shown, not the order the work happened in.**
Every frame is committed as early in the branch as makes sense, which the orchestrator decides at triage and the user may override:

- **A prequel — a tidy that would reasonably land on main by itself — goes at the branch's base.**
  It's worth having however the advance turns out, so it can be cherry-picked onto main, and drops out of the PR once the branch is rebased.
- **A tidy that only makes sense beside the advance it enables goes directly under that advance.**
  A reviewer sees why it's there only with the advance beside it, so it isn't a candidate for main.
- **An amend is autosquashed into the commit it amends.**
- **Anything else goes on top.**

**Anywhere but the top rewrites the branch**, per `a-star:a-star`'s [Feature branches](../../a-star/SKILL.md#feature-branches).

**The branch reads as though each commit was right first time**, as autosquash leaves it.
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
- **YAGNI**: no generality the sub-goal didn't ask for.
- **No dead code.** Everything the commit adds has a caller outside the tests in this commit; a new abstraction nothing yet calls is committed with the first change that calls it.
  A tidy reshapes code that already runs.
- **The suite stays green.** A test weakened or disabled to get past it is a broken invariant: report it, don't commit it.
- **Work set aside is a WIP commit, never `git stash`**: the stash is shared across worktrees.

## A tidy: first, later or never

**When to tidy is *Tidy First?*'s first, later or never; its *after* is an amend here**: a structure change to code this branch introduced, before that code has landed, is not a tidy but an amend of the commit that introduced it.

- **First** — it's worth having however the rest of the card turns out, or the work in hand needs it.
- **Later** — whether it's worth having depends on the behaviour change: record it as a sub-goal, and carry on.
- **Never** — it opens no option; don't record it.

**Which branch it is committed on is per the project's answer to where a tidy is committed**, per `a-star:a-star`'s [What the project says](../../a-star/SKILL.md#what-the-project-says):

- **Feature branch, the default** — it lands with the card's advances, at its place in the branch per [Where a frame is committed](#where-a-frame-is-committed).
- **Main, where the project says so** — a tidy branch off main, for the user to merge; rebase the feature branch onto it as soon as it's committed.
