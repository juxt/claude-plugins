---
name: drive
description: >
  Commit one ready sub-goal to the project's standards through the drive agent, as one of three kinds of frame: a tidy changes structure, an advance changes behaviour, an amend makes an earlier unlanded commit fit for purpose.
  Where a dart takes the straight line to the goal, a drive takes the road — the coding standards, tests, definition of done and review the dart ignored.
  A drive is a stack: a tidy, an amend or a prequel can interrupt the frame in hand, and a better drive can pre-empt it; each is committed at the lowest point in the branch its dependencies allow.
  Use when the user says "drive <sub-goal>", "land this", "tidy <what>", "this needs a tidy first", "pause, let's tidy that", "fix up that earlier commit", picks a sub-goal offered by `/a-star`, `a-star:dart` or another drive, or a dart or drive turns up a structure change.
user-invocable: true
argument-hint: "<sub-goal, or the structure change needed>"
---

# a-star Drive

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: a small change, ready to merge, that the user can review from its diff and message alone** — and, once it lands, page that part of the card out of their head.

Load `a-star:a-star` first; the drive's states are in its spec.
Read [references/frame.md](references/frame.md): what a frame is, where it is committed, and the rules it is written to.

**You, the orchestrator, hold the stack; the `drive` agent commits each frame.**
It reports what it turns up and makes the commit; you triage, choose, record, and may rewrite its commit.

## Doing it

1. **Record it as what's in hand, before anything is edited.** Its task already exists, from when the sub-goal was recorded at triage — a tidy, amend or prequel pushed onto the stack included.
   **An amend raised by your own review of a frame MAY be driven without a dart**, recorded as a decision that you judged it straightforward.

2. **Record the branch's head, then spawn the `drive` agent with the frame as its brief, and nothing else** — its sub-goal, its kind and placement, the branch to work from and its head, and where the card's work is recorded: for an advance, the card's feature branch off the project's base branch; for a tidy, where it is committed.
   The record carries the decisions, principles and darts' evidence, which it reads and never writes.
   The brief MUST NOT restate what the agent loads for itself — the project's conventions, the skills' rules, how to verify — nor dictate a format a named skill owns, such as a commit message's.
   A restatement is a second copy to drift, and a wrong one overrides the right one.
   It works in the card's own checkout, with no worktree: drives run one at a time, so nothing else needs the checkout.
   **You check out the branch it works from before briefing it** — the feature branch, or for a tidy committed on main, its tidy branch off main, and the feature branch again once that tidy is taken.
   Run it in the background, so it can message you as it goes, and MUST NOT otherwise touch the checkout until it ends — you work on the plan only.
   A harness hook that reports uncommitted changes while it runs is reporting the frame's work in progress; leave it.

3. **Triage what it reports as it goes**, per `a-star:a-star` — a stretch of route nobody darted, a better split of a later sub-goal, a constraint, an earlier commit that wants amending but doesn't block the frame — without stopping the frame.
   The amend is recorded as a sub-goal, driven after the frame in hand is committed.
   **The drive agent spawns the sub-agents the project's conventions call for — a comment weeder, a test-log reader — itself, and hands back a frame they have already run over.**
   Where it has no Agent tool, as in a Claude Code cloud session, it asks you for them instead: spawn each with exactly the inputs it names, and resume it with the results.
   Your review in step 5 is the frame's code review, so it doesn't ask for another.
   **It asks you, too, the questions the project's commit conventions would put to the user**: it has none of the session's history, and the user doesn't see its calls, so answer from the record, or in primary escalate.

4. **When it ends its turn**, decide: a sub-agent request is spawned and answered, per step 3; a user's decision is offered in primary; an earlier commit this frame can't be committed on is an amend frame, pushed first; a better drive is a pre-emption; a failure is [Handling Drive Failure](#handling-drive-failure).
   Then resume it with `SendMessage`, or push the new frame.

5. **Review the frame's diff from the head you recorded, before taking its commit**, with the review the project's conventions call for, over its code and its comments.
   **The review checks that a tidy changes no behaviour**: a commit typed as one whose diff or body shows a behaviour change, error paths included, is split or retyped before it is taken.
   A finding inside the frame's scope resumes the drive agent with `SendMessage` to fix it; anything else is triaged like any other report — including one that completes an earlier unlanded commit, which triage makes an amend of it.
   A finding the drive agent could only have missed because something it reads was silent or wrong is also a gap: triage where its fix belongs — the project's instructions or skills, the record, a skill of a-star's own, or the session's setup — and fix it there, so the next frame doesn't repeat it.
   A fresh drive's mistake is the signal that the plan or the project is missing something, and amending the commit alone leaves the miss in place.

6. **Take its commit**, which is already on the feature branch at the frame's placement, rewriting its place or message where the branch should read otherwise.
   **The gate first: check the review notes the drive agent wrote into the commit's body, and reported, stand apart from the unlanded commits' `review:` entries.**
   Rewrite the message, to the project's commit conventions, only where the notes fall short of what a `review:` entry holds, per `a-star:a-star`'s What to record.
   Where `a-star:a-star`'s completion test, in its Triage, finds the frame completes an earlier unlanded commit, fold it in as an amend rather than taking it on top.
   A rewrite that changes a commit's subject updates the journal entries keyed by it.
   **Then push, where the project's answer says to**, and in secondary wherever its answers allow, per `a-star:a-star`'s Primary and secondary; the drive agent never pushes.

7. **Record the sub-goal done**, with its commits, and complete its task; record what its report taught, and add a task for any sub-goal it turned up.
   **Record the gate's notes as the commit's `review:` entry**, against its subject, with what your own review added — the PR's Reviewing this takes what spans commits and what was verified from these.
   A frame that interrupted another pops: rebase the WIP onto it, and resume what it interrupted.
   A dart branch under it is the dart agent's to rebase or redo.

8. **Clear the darts this drive superseded** — each whose code no longer holds evidence a remaining sub-goal needs.
   First record what it taught that the record doesn't yet hold: what it found, and where the road departed from its route.
   Then remove its branch and worktree, per `a-star:a-star`'s [What the project says](../a-star/SKILL.md#what-the-project-says).

**Hand over** the branch, its head, and what the reviewer has to check — the decisions and assumptions the change rests on, as the `review:` entries record them.
In secondary, the handover goes in the session's record and doesn't end the turn.
**Then you are back to choosing, per `a-star:a-star`.**
Merging is the user's; once they have, remove what only served it per the project's branch cleanup.

## Interrupting the frame in hand

**A tidy needed first, an amend of a commit the frame in hand can't be committed on, or a prequel pushes a frame on top of the one in hand**, committed by a drive agent of its own.
The agent in hand has WIP-committed its work before ending its turn; rebase that afterwards — or discard it to redo on the new structure, whichever is cheaper — and mark its task blocked by the new frame's.

**A frame can itself be interrupted** — push another on top, and pop back the same way.

**A better drive found mid-drive pre-empts the one in hand.**
Set the original aside as a WIP commit, commit the pre-empting drive, then rebase the WIP onto it and resume the original with what is left of it.
A pre-empted drive is kept and resumed; a failed one is thrown away and re-split.

**Stopping before it's done**: WIP-commit the work, leave it recorded as in hand, and park — whatever else is ready.
With the stack unpopped, the next session resumes from what the park leaves, per `a-star:a-star`'s Entry and exit, not from this session's plan file.

## Handling Drive Failure

**A drive has failed once its change is no longer atomic, or no longer comprehensible** — more than one change, or more than a reviewer can hold in their head.
Other signs: the same failure twice; a fix reaching into code the sub-goal didn't name; a test you'd have to weaken to get past; the code not being what the plan assumed.

**Step back rather than push on**: set the drive aside — WIP-commit it, or `git reset --hard` to the head you recorded before it — mark its sub-goal not ready, and remove its task.
It is readied again once its re-split's tidies have been committed, or superseded by the sub-goals that replace it.

- **Break it down again, per *Tidy First?*'s "Getting Untangled"** — by default, discard the drive and redo it tidying first, with what it taught.
  However the work then splits, each change is atomic and comprehensible, recorded as a sub-goal.
- **Throw a dart where the route is what's unknown**, from where the work is, with what the drive taught.
- **Take it back to the user where a decision is** — the sub-goal's scope, the plan, an invariant.
  In secondary, record it as an open question blocking the sub-goal, and move to other ready work.
