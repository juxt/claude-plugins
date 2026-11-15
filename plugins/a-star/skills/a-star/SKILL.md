---
name: a-star
description: >
  The a-star process, and its entry point: take an approved plan from the outer harness, and from then on choose each move — dart, drive, revert, replan, park or done — by its guard.
  Every other a-star skill loads this one first — it carries the orchestrator, the moves and their guards, triage, the roles, where sub-goals come from, the structure/behaviour split, what a-star records, and what it needs the project to say.
  Use when the user says "/a-star <card>", "pick up <card>", "start work on <card>", or resumes a card from an earlier session.
user-invocable: true
argument-hint: "<card: a tracker issue>"
---

# a-star

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**a-star is three state machines — the orchestrator, the dart and the drive — joined by what darts and drives turn up.**
[`spec/a-star.allium`](../../spec/a-star.allium) states them: each move's guard (`requires`) and what it records (`ensures`).
The skills say how a move is carried out; where a skill and the spec disagree, the spec governs, and the disagreement is a question for the user.

**Its inspiration is the Mikado Method** (Ellnestam & Brolund, 2014): try the goal, revert, work the graph of prerequisites backwards, commit the leaves.
The dart is the try, the revert is the revert, and each drive commits a leaf.

## Roles

- **You, the main session, are the orchestrator.**
  You hold the state machine, the drive stack and triage, and nothing else.
- **The dart agent reaches the goal end-to-end and reports.** Its code never lands.
- **The drive agent commits one frame and reports.** You may rewrite that commit — its place in the branch, or its message.
- **Agents only report; every decision about what happens next is yours, and only you update the plan, the journal and the task list.**

**A user's question is a question, not a go-ahead.**
"Is that a good idea?" wants an answer, not the step it asks about.

## Entry and exit

**a-star starts from a plan whose goal the user has approved**, handed in by whatever harness surrounds it — chalk's planning is one.
How the goal gets understood and agreed is that harness's; a-star only checks it is.

- **A card is ready once its goal, its constraints and what's out of scope are agreed with the user, and no open question bears on it.**
- **A card's goal is what it is for; its target is what its branch is to contain — the commit plan.**
  The target changes as darts and drives teach; the goal changes only with the user.

**a-star exits back to that harness**, and doesn't care what it is:

- **replan** — the goal itself is invalidated, and the harness re-plans with the user;
- **done** — the done sub-goals complete the card, and the branch has had its review-unit pass.

**park hands the work back to that harness** — nothing is ready, and what's blocked waits on the user or someone else.
Parked work is resumed by a later session, from what `chalk:put-down` recorded on the issue — its stack recorded there, its branch pushed — or the project's equivalent.

**A finding that leaves the goal standing is never an exit**: a revert, a re-split of sub-goals, or a question, all inside a-star.
Only the replan exit re-enters the harness's planning.

## The orchestrator

**Every move is taken from one state, choosing.**
In primary, a move is first offered, and only the user's yes takes it; in secondary it is taken directly, and what would have been offered is recorded (`a-star:primary`, `a-star:secondary`).

- **The first move, where the approved plan names it, is already accepted.**
  Approving the plan was the yes, so it is taken without being offered again; every later move is offered as usual.

- **dart** — part of the goal is still unwalked, or a sub-goal no dart has exercised, and nothing in flight covers it.
  Darts run in parallel, with each other and with a drive. `a-star:dart`.

- **drive** — a ready sub-goal, and no drive in hand: drives run one at a time.
  Ready: everything it depends on is done, and no open question blocks it.
  It is drivable once a dart has exercised it — built and run it, not reasoned about it — or once you judge it straightforward, which you record as a decision.
  `a-star:drive`.

- **revert** — what is now known changes the card's target, while its goal still stands.
  Tag the old head, restart from the base, and replay the commits that still hold.
  Frames in hand are thrown away; a done sub-goal whose commit isn't replayed is outstanding again, or superseded where the new target doesn't need it.
  It is a move of its own, not a failure path: what the branch cost so far is no argument against it.

- **replan, done** — the exits above; **park** — the hand-back above.

## Triage

**Darts and drives turn up the same kinds of thing, and you triage each:**

- **an increment ready to commit, or a new or better-split sub-goal** — first apply `chalk:commit`'s completion test against the unlanded commits; scope that completes one is an amend of it, below.
  Otherwise record it as a sub-goal, with its kind and where it would be committed, what it depends on, and whether a dart exercised it.
  This holds for scope the user adds mid-card and for findings from your own review of a frame alike;
- **a stretch of the route not yet walked** — a dart;
- **an earlier, unlanded commit superseded or incomplete** — an amend, per `a-star:drive`; pushed ahead of the frame in hand only if that frame can't be committed correctly on the commit as it stands, otherwise recorded to drive after it;
- **a change that would replace the approach of an unlanded commit, anywhere in the branch** — never a sub-goal on top: an amend of the commit that introduced the approach, or a revert where the approach spans several commits;
- **a constraint, assumption or risk** — recorded on the goal-tree node it bounds;
- **a question about the route** — answer it, or in primary escalate it, then resume;
- **a finding that changes the card's target** — revert; **one that changes its goal** — replan;
- **a decision that is the user's** — offer it in primary; in secondary, record it and move to other ready work;
- **two reports that conflict** — you settle it, by your own check where one is cheap, and record the decision.

## Sub-goals

- **Sub-goals come from darts, not from reading the code.**
  The approved plan's leaves are provisional until a dart has exercised them: harvesting a dart refines each leaf it walked into sub-goals, and the leaf's task is replaced by theirs.
- **A sub-goal is one tidy, one advance or one amend**, committed by a drive.
- **Each sub-goal is atomic, and goes from green to green.**
  One unit of change, its own tests and docs included.
  A sub-goal that can't be committed green wants another ordered before it; that's a question to ask when it's recorded, not one for its drive to discover.
- **Together, a card's sub-goals MUST complete it.**
- **The code a drive commits keeps the data structures a dart got right**, and leaves out what it built around the ones it didn't.
- **Before the done exit, a review-unit pass shapes the unlanded branch for its reviewer, not the order the work happened in.**
  Reorder, merge or split its commits until each is independently acceptable and none is a slice of another, leaving the final tree unchanged.
  **The test is the `review:` entries**: a commit whose entry can't say what checking it means apart from its neighbours' is a slice of one of them, and an entry that needs two different checks is two units.
  **A tidy and an advance stay separate**, however closely they belong together — they are checked differently.
  Merging two commits merges their `review:` entries, and redrafts the merged body through `chalk:commit`.
  A rewritten subject updates the journal entries keyed by it.
  It rewrites the branch, per `chalk:chalk`'s Feature branches.

**A structure change and a behaviour change never share a commit**: a tidy changes structure, an advance changes behaviour, and `a-star:drive` commits either.

- **Which one a change is, is judged against the commits in the branch, not against a dart's intermediate states.**
  A change that would be a tidy relative to a state no commit holds is part of the commit that reaches past that state.
  For example, a byte-identical rerouting that only exists on the way to a behaviour change goes in with that behaviour change.

## What to record

In whatever the session tracks its work with — the outer harness's journal, where it has one:

- **a sub-goal: its kind (tidy, advance or amend) and where it would be committed, what it depends on, and whether a dart exercised it;**
- **a decision** — a call you aren't sure of is an open question instead;
- **an open question, and what it blocks;**
- **a sub-goal done**, with its commits;
- **a revert or a re-split** — what changed, and which sub-goals it superseded or reopened, as a `re-split:` entry; the replan exit's is a `replan:`, journalled as it exits;
- **what's in hand** — the drive stack, innermost first — **recorded before the first edit;**
- **a dart in flight**, so a resumed session knows it was lost;
- **whether the user is watching** (`a-star:primary`, `a-star:secondary`).
  A session starts primary, unless it runs headless or scheduled, when it starts secondary.

**Keep the host's task list current as sub-goals move**, per `chalk:chalk`'s task list, where the session journals there — a tidy, amend or prequel pushed onto the stack included.

## `/a-star <card>`

1. **Check the plan is approved, and the card [ready](#entry-and-exit)**, by the outer harness or on the tracker issue.
   Where it isn't, choose how to make it ready, taking the first that applies:
   1. the user has said how to ready it — do that;
   2. `chalk:chalk` is installed — hand to it to plan the card;
   3. otherwise ask the user how, agreeing the root with them — what the card is for, never how it gets there.
   **Agreed here, it goes on the tracker issue before you move on**: every decision that bears on the problem or the agreed scope, not only the root.
   In secondary, record the questions and park instead.
   **Resuming a card from an earlier session**, start from what `chalk:put-down` recorded on its issue — the branch, its head and the stack in hand — or the project's equivalent.

2. **Load the project's answers to the [three choices](#what-the-project-says)**, and check no open question bears on the card itself.
   Look for the answers in the project's skills and agent instructions first; only a choice answered nowhere there becomes a question.

3. **Choose the first move**: the one the approved plan names, taken directly; otherwise a dart where the card has no sub-goals yet or part of its goal is still unwalked, else a drive.

## What the project says

**Everything not here follows the project's conventions** — writing, tracking, planning, picking a card up and putting it down, the base branch, ship/show/ask, the definition of done, coding standards, and how a commit is written.
What goes in a commit is a-star's: one atomic unit of change.

**A commit has landed once it reaches the project's base branch, and not before.**
A frame is committed, not landed: pushing the feature branch, or opening a PR on it, lands nothing.
Until it lands, a commit is amendable, per `chalk:chalk`'s Feature branches.

**The project MUST answer three choices of a-star's own**:

- **Where a tidy is committed** — feature branch or main; what to verify before committing; when to push; whether it's done at commit or once CI is green.
- **Where an advance is committed** — what to verify before committing, and whether to push the feature branch as each is committed.
- **Branch cleanup** — what happens to a branch once its work has landed.

**Raise an unanswered one as a question; don't fill it with a default.**
The exception is branch cleanup: absent an answer, delete local branches and worktrees whose work has fully landed, and only offer to delete remote ones.
A spent dart's branch and worktree are removed whatever the answer, since its code never lands.
