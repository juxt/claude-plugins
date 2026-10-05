---
name: drive
description: >
  Take one behaviour change — a ready sub-goal — from what the spikes found to committed, tested and ready to merge into main, written by the super agent to the project's standards.
  Use when the user says "drive <sub-goal>", "land this", or picks a sub-goal offered by `/a-star`, `spike`, `tidy` or another drive.
user-invocable: true
argument-hint: "<sub-goal>"
---

# a-star Drive

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: a small behaviour change, ready to merge, that the user can review from its diff and message alone** — and, once it lands, page that part of the card out of their head.

Load `a-star:a-star` first.

**A drive takes one ready sub-goal, small enough for a reviewer to hold in their head**; one too big is two — record both before starting.
**What the spikes found is evidence, never code to edit into shape.**

1. **Record it as what's in hand.**

2. **Work on the card's feature branch**, in its own worktree, off the project's base branch.

3. **Write it to the project's coding standards.**
   - **No generality the sub-goal didn't ask for.**
   - **The suite stays green.** A test weakened or disabled to get past it is a broken invariant: report it, don't commit it.
   - **A structure change turning up mid-drive is a tidy** (`a-star:tidy`), not part of this commit.

4. **Verify it** against the project's definition of done and its answer to how a drive lands, with the code review its ship/show/ask conventions call for.

5. **Commit**, and push where the project's answer says to.

6. **Record the sub-goal done**, with its commit.

**Hand over** the branch, its head, and what the reviewer has to check — the decisions and assumptions the change rests on.
**Then offer the next step from the ready sub-goals, and wait.**
Merging is the user's; once they have, remove what only served it per the project's branch cleanup.

**Stopping before it's done**: WIP-commit the work, leave it recorded as in hand, and put the card down.
