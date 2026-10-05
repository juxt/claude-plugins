---
name: landed
description: >
  Catch the plan up after the user lands something: confirm it's on the target, check the tracker holds what has to survive the session, remove the branches and worktrees that only served it, and offer what's next.
  Use when the user says "/a-star:landed <what>", "that's landed", "merged", "cherry-picked", or otherwise reports that a tidy or a behaviour change has reached its target.
user-invocable: true
argument-hint: "<what landed: a plan section, branch or PR>"
---

# a-star Landed

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: the plan and the repo agree with what landed, nothing that had to survive was lost, and the user chooses what's next with a clear view of it.**

**Landing is the user's act; `landed` is the super agent catching up with it.**

Load `a-star:a-star` first.

## 1. Confirm it landed

**Check the target, not the transcript**: the commit is on the target branch, or the PR is merged.
Match by subject (`git log --grep`, or `git cherry`) rather than by sha: a rebase onto a tidy, or a cherry-pick, rewrites the sha a section was given.
Where it hasn't landed, say what you found and stop.
Where it has under a new sha, give its section the new one.

## 2. Check the tracker holds what has to survive

**The plan is the session's, and goes with it; the tracker is the record.**
Confirm the tracker — the PR, the issue — durably holds:

- **the decisions** the landed work rests on, with their reasons;
- **the agent's decisions and the assumptions**, flagged for the user's review.

Write what's missing through the project's writing conventions; where there are none, flag the gap rather than writing it yourself.

## 3. Remove what only served it

**Per the project's answer on branch cleanup**; where it says nothing:

- **Delete local branches and worktrees whose work has landed**, after checking each is fully contained in the target.
  One carrying commits that haven't landed is reported, not deleted.
- **Offer redundant remote branches for deletion, and delete them only on the user's yes.**
- **Keep a spike branch** until the landings it informed have landed.

## 4. Offer what's next

**Offer, and wait: the next landing MUST NOT start without the user's choice.**
Each with its subject line:

- **Next** — the first unlanded section with nothing open blocking it.
- **Blocked on a question** — each with the question it waits on: an answer is the quickest way to unblock it.
- **Needs refining** — where the card fails readiness, for `a-star:refine`.
- **Done** — every section has landed: the card is ready to close, per the project's tracker conventions.

**Where one is clearly next, say which and why**, as a lean.
