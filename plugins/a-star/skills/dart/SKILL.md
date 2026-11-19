---
name: dart
description: >
  Reach a ready card's goal end-to-end with the dart agent, triaging what it raises as it goes — increments ready to commit, findings that invalidate the plan, questions about the route — and harvesting the sub-goals it found.
  Use when `/a-star` offers a dart, or the user says "dart this", "throw a dart", "throw the dart".
user-invocable: true
argument-hint: "[card, if not already in session]"
---

# a-star Dart

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success is the `dart` agent's, as it states it: enough information back to decide the next steps, as soon as it can be had**.

Load `a-star:a-star` first.

## Brief the dart agent

**Spawn the `dart` agent with the card as its whole brief** — the goal, invariants and out of scope from the tracker issue, the sub-goals already found, the decisions in force, the record's `principle:` entries — plus the branch to start from and its head: the card's feature branch, else the project's base branch.
You MAY point it at where the card's work is recorded instead, to read and never write.

- **The brief MUST ask for a spike: the route built, not analysed.**
  Constraints that analysis misses turn up at drive time, after the sub-goals before them have been committed.

- **The brief MUST NOT ask for a green suite, the project's definition of done, or proof of the end-to-end**, which sets the bar the dart then aims for.
  It MUST ask the dart to report as soon as the next steps are decidable.
- **Pass `isolation: "worktree"`, and run it in the background**, so it can message you as it goes.
- **`.claude/worktrees/` MUST be ignored by git**; add it to `.git/info/exclude` where it isn't.
- **Every dart starts fresh from the current base**; an old dart is evidence, never resumed.
- **A dart branch is local: it MUST NOT be pushed**, by the dart agent or by you, since nothing outside this session needs it.
- **A dart MAY start from another dart's branch instead of the base**, where what it needs hasn't been committed yet.

## While it runs

**The dart agent only reports; you triage what it reports**, per `a-star:a-star`'s Triage, and it acts on nothing it found.
Record it as in flight, so a session resumed after this one ends knows it was lost, and darts again where it is still needed.

- **An increment ready to commit** — record it as a sub-goal.
  Driving it is a move like any other, offered or taken per `a-star:a-star`'s Primary and secondary.

- **A finding that invalidates the plan** — the card's contract, a decision already made, an invariant, or the cost of the agreed route.
  It is the user's to settle, in either mode: in secondary, record it as an open question, halt the line of work it bears on, and move to other ready work.
  One that changes the card's target is a revert; one that changes its goal, a replan.

- **A question about the route** — answer it, or put it to the user, per `a-star:a-star`'s Triage; record the decision and resume the dart agent with `SendMessage`.
  A question the card itself can't answer means the plan has a gap, and is the user's, like a finding that invalidates the plan: the dart waits on the answer, and it is a replan where the answer changes the goal.

## Harvest

**Record what you accept from the dart agent's report, in the plan and the journal, and add a task for each sub-goal recorded:**

- **the sub-goals**, each with its kind, what it depends on, and whether the dart exercised it — together they MUST complete the card; you assign each where it would be committed.
  Each refines the plan leaf it walked, whose task theirs replace.
  **One not exercised is darted before it is driven**, however confident its description — its shape is still an unknown — unless you judge it straightforward, and record that as a decision.
- **the decisions** — the dart agent's you keep;
- **the questions**, each with what it blocks;
- **the assumptions and risks**, including each invariant it broke;
- **the data structures that matched the problem**, and the dart's branch and head.

**Keep the dart branch only while its code is still evidence a drive needs.**
Once the sub-goals it informed have been committed, or what it found is recorded well enough that nothing needs its code, whichever comes first, record what it taught that the record doesn't yet hold, then remove it and its worktree, per `a-star:a-star`'s [What the project says](../a-star/SKILL.md#what-the-project-says).

**Then you are back to choosing, per `a-star:a-star`.**
