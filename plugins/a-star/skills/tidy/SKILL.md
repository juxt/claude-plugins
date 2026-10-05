---
name: tidy
description: >
  Own the interruption for a structure change: decide now or later, and if now, whether it lands on the feature branch or main; park the work in hand, make the change, land it, and resume. Recursive — a tidy can be interrupted by another.
  Use when the user says "tidy <what>", "this needs a tidy first", "pause, let's tidy that", or a spike or drive turns up a structure change.
user-invocable: true
argument-hint: "<what: a tidy sub-goal, or the structure change needed>"
---

# a-star Tidy

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: a small equivalence change, landed, that gives us options** — reviewable by asking only *could this change anything?*, and letting the user page out part of their context.

**A tidy changes structure, never behaviour, and never shares a commit with a behaviour change.**

Load `a-star:a-star` first.

## Now, later or never

- **Now** — it's worth having however the rest of the card turns out, or the work in hand needs it.
- **Later** — whether it's worth having depends on the behaviour change: record it as a sub-goal, and carry on.
- **Never** — it opens no option; don't record it.

## Where it lands

**Per the project's answer to how a tidy lands**; where it's silent, the feature branch.

- **Feature branch** — it lands with the card's behaviour changes.
- **Main** — a tidy branch off main, for the user to merge; rebase the feature branch onto it as soon as it's committed.

## Doing it

1. **Set the work in hand aside** — as a WIP commit to rebase afterwards, or discarded to redo on the tidied structure, whichever is cheaper.
   You MUST NOT use `git stash`: it's shared across worktrees.

2. **Push it onto the stack**: record it as a sub-goal the interrupted one depends on, and as in hand on top of it.

3. **Make the change, on a branch off its target.**
   A change that could change anything isn't a tidy.

4. **Commit it**, after the verification the project's answer asks for, and push where it says to.

5. **Pop**: record it done, rebase the feature branch onto it, and resume.
   A spike branch under it is the spiker's to rebase or redo.

**A tidy can itself need a smaller tidy first** — push another on top, and pop back the same way.

Merging is the user's; once they have, remove what only served it per the project's branch cleanup.
**Stopping with the stack unpopped**: put the card down; the WIP commits and what's recorded as in hand are what the next session resumes from.
