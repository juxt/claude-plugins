---
name: drive
description: >
  Take one behaviour change — a bd task — from what the spikes found to committed, tested and ready to merge into main, written by the super agent to the project's standards.
  Use when the user says "drive <task>", "land this", or picks a task offered by `/a-star`, `spike` or `landed`.
user-invocable: true
argument-hint: "<task: a bd task ID>"
---

# a-star Drive

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: a small behaviour change, ready to merge, that the user can review from its diff and message alone** — and, once it lands, page that part of the card out of their head.

**One behaviour change, written by the super agent, ending committed, tested and ready to merge into main.**
Merging is the user's act; `a-star:landed` catches up with it.

Load `a-star:a-star` first.

## The task

**A drive takes one task that lands in isolation, within what a reviewer can hold in their head at once.**
A task too big for that is two tasks: split it in bd before starting.

**What the spikes found is evidence for what gets written, never code to edit into shape.**

## Doing it

1. **Claim it**: `bd update <task> --claim`.

2. **Work on the card's feature branch**, in its own worktree, off the project's base branch; create it if this is the card's first landing.

3. **Write the behaviour change to the project's coding standards** — nothing here is exempt the way the spiker was.
   - **Smallest behavioural residue**: no generality the task didn't ask for.
   - **The suite stays green.** A test weakened or disabled to get past it is a broken invariant: report it, don't commit it.
   - **A structure change turning up mid-drive is a tidy**, not part of this commit: `a-star:tidy` owns that interruption.

4. **Final tidy, against the project's definition of done.**
   Then the code-review pass `a-star:a-star` requires for a show or ask landing.

5. **Commit**, per the project's writing policy, and push early where the project's policy says to.

6. **Close the task**: `bd close <task> --reason "<sha> <subject>"`.
   A task is done once its commit meets the project's definition of done — merging is a separate event, which `a-star:landed` catches up with.

## Handing over

**Name the branch and its head, and list what the reviewer has to check**: the agent-decided decisions and the assumption notes under the card (`a-star:a-star`).

**Then offer what's next** — the next ready task, another spike, or `a-star:landed` once the user has merged.

**Stopping before the task is done parks it**: WIP-commit the work in hand, leave the task `in_progress`, and park the card per the project's put-down policy.
