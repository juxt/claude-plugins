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
The dart is the naive attempt, the revert is the revert, and each drive commits a leaf.

## Roles

- **You, the main session, are the orchestrator.**
  You hold the state machine, the drive stack and triage, and nothing else.
- **The dart agent reaches the goal end-to-end and reports.** Its code never lands.
- **The drive agent commits one frame and reports.** You may rewrite that commit — its place in the branch, or its message.
- **You never write code yourself: every code change, an amend included, is a drive's.**
  Rewriting a commit's place or message is the only change you make to the branch.
- **Agents only report; every decision about what happens next is yours, and only you update the plan, the journal and the task list.**

**A user's question is a question, not a go-ahead.**
"Is that a good idea?" wants an answer, not the step it asks about.

## Entry and exit

**a-star starts from a plan whose goal the user has approved**, handed in by whatever harness surrounds it — for example, chalk's planning.
How the goal gets understood and agreed is that harness's; a-star only checks it is.

- **A card is ready once its goal, its constraints and what's out of scope are agreed with the user, and no open question bears on it.**
- **A card's goal is what it is for; its target is what its branch is to contain — the commit plan.**
  The target changes as darts and drives teach; the goal changes only with the user.

**a-star exits back to that harness**, and doesn't care what it is:

- **replan** — the goal itself is invalidated, and the harness re-plans with the user;
- **done** — the done sub-goals complete the card, and the branch has had its review-unit pass and its code review.

**park hands the work back to that harness** — nothing is ready, and what's blocked waits on the user or someone else.
**A park leaves what a later session needs to resume**: the branch pushed — with `--force-with-lease`, per [Feature branches](#feature-branches) — and its head, the drive stack and any WIP commits recorded where the project tracks the card.
Resuming starts from that record.

**A finding that leaves the goal standing is never an exit**: a revert, a re-split of sub-goals, or a question, all inside a-star.
Only the replan exit re-enters the harness's planning.

## The orchestrator

**Every move is taken from one state, choosing.**
In primary, a move off the approved route is first offered, and only the user's yes takes it; in secondary it is taken directly, and what would have been offered is recorded, per [Primary and secondary](#primary-and-secondary).

- **The approved route, the moves the approved plan names, is already accepted in its order**, per the outer harness's approval — `chalk:chalk`'s step 2, where chalk planned it.

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

### Primary and secondary

**The mode — whether the user is watching — is the session's, as the session records it, and a-star reads it rather than sets it**; with none recorded, a session is primary unless it runs headless or scheduled.
These are what each mode means for a-star's own moves.

**In primary, the user's context is managed per `chalk:primary`**: what darts and drives turn up waits for the close of the user's current thread, unless it materially affects that thread.

- **Offer a move off the approved route, and take it only on a yes** — the offered state in the spec.
  The offer waits for the breakpoint, batched with any others pending; a move on the route is taken without one, per [The orchestrator](#the-orchestrator).
  A question from the user is not that yes.
- **A dart's route question waits for the user like any other arrival, unless it's yours to answer.**

**In secondary:**

- **Work only on a ready card.**
  One that isn't, or a question the card can't answer, gets its questions recorded and the card parked.
- **A halt is recorded as an open question blocking that sub-goal**, and other ready sub-goals go on; with none left, park.
  - **An open question blocks a sub-goal only where it is a halt** — a sub-goal whose plan routes around it stays ready.
- **Take each move out of choosing without offering it** — the offered state is bypassed — and record what you'd have offered or handed over.
- **Push a drive's branch after each frame's gate, wherever the project's answers allow**, so CI backstops what nobody is watching — never a dart's.

## Triage

**The completion test: where an unlanded commit's claim — its subject line — still holds with new scope inside it, that scope is an amend of the commit — a `fixup!` autosquashed into it — not a new commit on top** — never across kinds, per [Sub-goals](#sub-goals).

**Darts and drives turn up the same kinds of thing, and you triage each:**

- **an increment ready to commit, or a new or better-split sub-goal** — first apply the completion test against the unlanded commits; scope that completes one is an amend of it, below.
  Otherwise record it as a sub-goal, with its kind and where it would be committed, what it depends on, and whether a dart exercised it.
  This holds for scope the user adds mid-card and for findings from the pre-landing code review alike;
- **a stretch of the route not yet walked** — a dart;
- **an earlier, unlanded commit superseded or incomplete** — an amend, per `a-star:drive`; pushed ahead of the frame in hand only if that frame can't be committed correctly on the commit as it stands, otherwise recorded to drive after it;
- **a change that would replace the approach of an unlanded commit, anywhere in the branch** — an amend of that commit, or a revert, per `a-star:drive`'s [frame rules](../drive/references/frame.md#frames);
- **a constraint, assumption or risk** — recorded on the goal-tree node it bounds;
- **a question about the route** — answer it where it's yours, and otherwise it's the user's, per [Primary and secondary](#primary-and-secondary); then resume;
- **a report that its brief breaks one of the frame's standards** — the brief is wrong: re-brief within the standard, or put the conflict to the user; never record the standard as waived for the brief's sake;
- **a finding that changes the card's target** — revert; **one that changes its goal** — replan;
- **a decision that is the user's** — offer it in primary, per [Primary and secondary](#primary-and-secondary); in secondary, record it and move to other ready work;
- **two reports that conflict** — you settle it, by your own check where one is cheap, and record the decision.

## Sub-goals

- **Sub-goals come from darts, not from reading the code.**
  The approved plan's leaves are provisional until a dart has exercised them: harvesting a dart refines each leaf it walked into sub-goals, and the leaf's task is replaced by theirs.
- **A sub-goal is one tidy, one advance or one amend**, committed by a drive.
- **Each sub-goal is atomic, and goes from green to green.**
  One unit of change, its own tests and docs included.
  A sub-goal that can't be committed green wants another ordered before it; that's a question to ask when it's recorded, not one for its drive to discover.
- **A sub-goal is recorded already shaped as a review unit**, per the review-unit pass's tests below, before it is offered to the user or driven.
  A proposed sub-goal that fails them is merged into the one it serves at harvest or triage, not at the done exit: by then the user has already been shown the split, and asked to agree with a slice.
  A dart's proposed split is evidence of what the route needs, in the order it was built, and never the commit plan as it stands.
- **Together, a card's sub-goals MUST complete it.**
- **The code a drive commits keeps the data structures a dart got right**, and leaves out what it built around the ones it didn't.
- **Before the done exit, a review-unit pass shapes the unlanded branch for its reviewer, not the order the work happened in.**
  Reorder, merge or split its commits until each is independently acceptable and none is a slice of another, leaving the final tree unchanged.
  **The test is the `review:` entries**: a commit whose entry can't say what checking it means apart from its neighbours' is a slice of one of them, and an entry that needs two different checks is two units — so a tidy and an advance never merge, however closely they belong together.
  **A commit's own code calls everything it adds**, per the frame's [no dead code](../drive/references/frame.md#in-every-frame): a commit whose additions only a later commit calls is a slice of that later commit, however well its own tests let a reviewer check it.
  A caller in another commit's tests doesn't count.
  **A preparatory tidy stands alone only where a reviewer would accept it without the change it prepares**: it is worth landing even if that change never came, or it makes that change's diff materially easier to review — a large mechanical move, a rename across many sites.
  One whose only reason to exist is the next commit, and that a reviewer reads as easily inside it, is part of that commit, per [the structure/behaviour split](#sub-goals) below.
  Merging two commits merges their `review:` entries, and redrafts the merged body to the project's commit conventions.
  A rewritten subject updates the journal entries keyed by it.
  It rewrites the branch, per [Feature branches](#feature-branches).
- **Then the code review runs once, over the whole unlanded branch from its base to its head, before the done exit** — not frame by frame as the branch is built.
  You run it, at the level the project's conventions set: the review its conventions name, or a code-review agent, over the code and its comments.
  - **Its findings are triaged like any other report, and each is driven as an amend of the commit it belongs to**, never fixed by you.
    An amend raised by this review MAY be driven without a dart, recorded as a decision that you judged it straightforward.
  - **A finding a drive could only have missed because something it reads was silent or wrong is also a gap**: triage where its fix belongs — the project's instructions or skills, the record, a skill of a-star's own, or the session's setup — and fix it there, so the next card doesn't repeat it.
  - **Amends reopen both passes**: rerun the review-unit pass, and the code review over what the amends changed, until a pass turns up nothing to drive.

**A structure change and a behaviour change never share a commit**: a tidy changes structure, an advance changes behaviour, and `a-star:drive` commits either.

- **Which one a change is, is judged against the commits in the branch, not against a dart's intermediate states.**
  A change that would be a tidy relative to a state no commit holds is part of the commit that reaches past that state.
  For example, a byte-identical rerouting that only exists on the way to a behaviour change goes in with that behaviour change.
- **A structure change is a tidy only where it is worth reviewing on its own**, per the review-unit pass's preparatory-tidy test above.
  One that exists only for the behaviour change after it, and reads as easily inside it, is part of that behaviour change's mechanism rather than a tidy beside it — moving a handful of consumers onto an API the behaviour change introduces, say.

## What to record

In whatever the session tracks its work with — the outer harness's journal, where it has one:

- **a sub-goal: its kind (tidy, advance or amend) and where it would be committed, what it depends on, and whether a dart exercised it;**
- **a decision** — a call you aren't sure of is an open question instead;
- **an open question, and what it blocks;**
- **a sub-goal done**, with its commits;
- **a commit's `review:` entry**, against its subject — the review notes its body also carries: what checking the commit means; the invariants it rests on, each with where it is made true, what pins it and what would break it; and what was verified and what wasn't;
- **a revert or a re-split** — what changed, and which sub-goals it superseded or reopened, as a `re-split:` entry; the replan exit's is a `replan:`, journalled as it exits;
- **what's in hand** — the drive stack, innermost first — **recorded before the first edit;**
- **a dart in flight**, so a resumed session knows it was lost;

**Keep the host's task list current as sub-goals move**: a sub-goal recorded adds its task — a tidy, amend or prequel pushed onto the stack included — one done completes it, one superseded or thrown away removes it, and a frame interrupting a drive marks the drive's task blocked by its own.

## `/a-star <card>`

1. **Check the plan is approved, and the card [ready](#entry-and-exit)**, by the outer harness or on the tracker issue.
   Where it isn't, choose how to make it ready, taking the first that applies:
   1. the user has said how to ready it — do that;
   2. the project has a planning skill — hand to it to plan the card;
   3. otherwise ask the user how, agreeing the root with them — what the card is for, never how it gets there.
   **Agreed here, it goes on the tracker issue before you move on**: every decision that bears on the problem or the agreed scope, not only the root.
   In secondary, record the questions and park instead.
   **Resuming a card from an earlier session**, start from the record its park left, per [Entry and exit](#entry-and-exit) — the branch, its head and the stack in hand.

2. **Load the project's answers to the [three choices](#what-the-project-says)**, and check no open question bears on the card itself.
   Look for the answers in the project's skills and agent instructions first; only a choice answered nowhere there becomes a question.

3. **Choose the first move**: the first the approved plan names, taken directly; otherwise a dart where the card has no sub-goals yet or part of its goal is still unwalked, else a drive.

## Feature branches

**A feature branch the session owns MAY be rewritten, and pushed with `--force-with-lease`; the project's base branch never is.**
The session owns a branch it created for the card, one the user handed it, or one an earlier session created for the same card.

**A commit has landed once it reaches the project's base branch, and not before.**
A frame is committed, not landed: pushing the feature branch, or opening a PR on it, lands nothing.
Until it lands, a commit is amendable.

## What the project says

**Everything not here follows the project's conventions** — writing, tracking, planning, picking a card up and putting it down, the base branch, ship/show/ask, the definition of done, coding standards, and how a commit is written.
What goes in a commit is a-star's: one atomic unit of change.

**The project MUST answer three choices of a-star's own**:

- **Where a tidy is committed** — feature branch or main, the feature branch by default; what to verify before committing; when to push; whether it's done at commit or once CI is green.
- **Where an advance is committed** — what to verify before committing, and whether to push the feature branch as each is committed.
- **Branch cleanup** — what happens to a branch once its work has landed.

**Raise an unanswered one as a question; don't fill it with a default.**
The exceptions are a tidy's branch, which absent an answer is the feature branch, and branch cleanup: absent an answer, delete local branches and worktrees whose work has fully landed, and only offer to delete remote ones.
A spent dart's branch and worktree are removed whatever the answer, since its code never lands.
