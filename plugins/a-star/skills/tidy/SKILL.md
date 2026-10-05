---
name: tidy
description: >
  Own the interruption for a structure change: decide now or later, and if now, whether it lands on the feature branch or main; park the work in hand, make the change, land it, and resume. Recursive — a tidy can be interrupted by another.
  Use when the user says "tidy <what>", "this needs a tidy first", "pause, let's tidy that", or a spike or drive turns up a structure change.
user-invocable: true
argument-hint: "<what: a tidy landing in the plan, or the structure change needed>"
---

# a-star Tidy

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: a small equivalence change, landed, that gives us options** — reviewable by asking only *could this change anything?*, and letting the user page out part of their context.

**A tidy changes structure, never behaviour, and MUST NOT share a commit with a behaviour change** (Beck, *Tidy First?*).

Load `a-star:a-star` first.

## Now or later

**What decides it is how certain the option is to be worth having, whatever else happens.**

- **Now** — the tidy is a good option to hold however the rest of the card turns out, or the work in hand would be easier, or only possible, on the tidied structure.
- **Later** — its value depends on how the behaviour change turns out: record it as a tidy landing in the plan, noting what found it, and carry on.
  The spike that settles the route is what settles whether it's wanted.
- **Never** — it opens no option; don't record it.

The super agent applies the test, escalating in primary where the call is the user's; a call it makes itself is a decision by the agent.

## If now: feature branch or main

- **Feature branch** — it travels with the card's behaviour changes, and lands when they do.
- **Main** — a tidy branch off main, which the user merges on their own time; the feature branch rebases onto the tidy commit as soon as it's committed, without waiting for the merge.
  That's the optimistic part: the tidy MUST run enough of the suite to be confident it breaks nothing, since the feature branch now rests on it.

**The project's answer to how a tidy lands decides where it says**; otherwise the super agent does, escalating in primary where it's unsure, and defaulting to the feature branch, which disturbs nothing else.

## Doing it

1. **Set the work in hand aside, whichever way it will be cheaper to resume.**
   - **Park it as a WIP commit, and rebase it onto the tidy afterwards** — where it's substantial and the tidy won't move much under it.
   - **Discard it, and redo it on the tidied structure** — where the tidy changes what it was written against, and redoing is cheaper than resolving the conflict.

   You MUST NOT use `git stash`: the stash is shared across worktrees.

2. **Push the tidy onto the stack**: give it a section in the plan, ahead of the landing it interrupted, if it hasn't one yet, and put it at the top as the work in hand.

3. **Make the change, on a branch off the chosen target.**
   Its review is one question, answerable from the diff alone: *could this change anything?*
   A change that fails that question isn't a tidy.

4. **Commit it** per the project's writing conventions, after the verification its answer to how a tidy lands asks for, and push where that says to.

5. **Pop, as soon as it's committed.**
   - **Rebase the feature branch onto the tidy, and resume** — rebasing the parked WIP commit, or redoing the work.
   - **Give its section the commit's `<sha> <subject>`**, once it counts as done by the project's answer to how a tidy lands — on either target, without waiting for a merge.
   - **A spike branch under it is rebased or redone — the spiker's call**, since it keeps few commits so a rebase stays practical.

## Recursion

**A tidy can itself need a smaller tidy first**: park this one's work in hand, push another ahead of it, and pop back the same way.

**Stopping with the stack unpopped parks the card**: put it down per the project's conventions; the WIP commits, and the stack as it reached the issue, are what the next session resumes from.
