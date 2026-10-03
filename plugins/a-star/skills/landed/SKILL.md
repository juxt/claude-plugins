---
name: landed
description: >
  Catch beads up after the user lands something: confirm it's on the target, check the tracker holds what has to survive, close the card once all of it has landed and prune its nodes, remove the branches and worktrees that only served it, and offer the next task.
  Use when the user says "/a-star:landed <what>", "that's landed", "merged", "cherry-picked", or otherwise reports that a tidy or a behaviour change has reached its target.
user-invocable: true
argument-hint: "<what landed: a bd ID, branch or PR>"
---

# a-star Landed

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: beads and the repo agree with what landed, nothing that had to survive was lost, and the user chooses what's next with a clear view of it.**

**Landing is the user's act; `landed` is the super agent catching up with it.**

Load `a-star:a-star` first.

## 1. Confirm it landed

**Check the target, not the transcript**: the commit is on the target branch, or the PR is merged.
Match by subject (`git log --grep`, or `git cherry`) rather than by sha: a rebase onto a tidy, or a cherry-pick, rewrites the sha a task was closed with.
Where it hasn't landed, say what you found and stop.

## 2. Check the tracker holds what has to survive

**bd is the working state, and gets pruned; the tracker is the record.**
Before pruning, confirm the tracker — the PR, the issue — durably holds:

- **the decisions** the landed work rests on, with their reasons;
- **the agent-decided decisions and the assumptions**, flagged for the user's review.

Write what's missing through the project's writing policy; where there is none, flag the gap rather than writing it yourself.

## 3. Close and prune

- **Tasks and chores are already closed**: `drive` and `tidy` close each once its commit meets the definition of done.
- **Close the card once everything under it is on the target**: `bd close <card>`, after checking each closed task's commit is there.
  Not `bd epic close-eligible`, which closes every eligible epic in the workspace — including cards whose committed work hasn't merged.
- **Prune only once the card itself has closed**: `bd prune --pattern '<card>' --force`, then `--pattern '<card>.*'`, after step 2 has passed for it.
  A bare `'<card>*'` also matches any other card whose ID starts with this one's.
  Without `--force` prune only previews; until the card closes, its decisions are still the working record.

## 4. Remove what only served it

**Per the project's branch-cleanup policy**; where it says nothing:

- **Delete local branches and worktrees whose work has landed**, after checking each is fully contained in the target.
  One carrying commits that haven't landed is reported, not deleted.
- **Offer redundant remote branches for deletion, and delete them only on the user's yes.**
- **Keep a spike branch** until its spike bead is closed and the tasks it informed have landed.

## 5. Offer the next task

**Offer, and wait: the next task MUST NOT start without the user's choice.**
Each with its ID and subject line:

- **Ready** — `bd ready --exclude-type epic --parent <card>`, filtered by a-star's readiness test.
- **Blocked on a question** — `bd blocked --parent <card>`, each with the question it waits on: an answer is the quickest way to unblock it.
- **Needs refining** — nodes that fail readiness, for `a-star:refine`.

**Where one is clearly next, say which and why**, as a lean.
