---
name: chalk
description: >
  chalk's root skill, and the entry point for a building session: plan in plan mode until the user approves the goal and the route, then keep the session's journal in the plan file.
  The skills that read or write the plan — commit, pr, put-down, sitrep — load this one for the plan file's shape and the journal's record kinds; an implementation harness records through the same kinds.
  Use when the user says "/chalk", "/chalk <issue>", "pick this up", "pick up #N", "start on #N", "let's plan this", or a session is starting work, with or without a card.
user-invocable: true
argument-hint: "[issue]"
---

# chalk

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**chalk plans a session's work, journals it as it happens, and writes the issues, commits and PRs from that journal.**
How the work gets implemented is a separate concern, left to whichever implementation harness the session uses, or to none.

**Success: nothing is built before the user has agreed the goal, and every commit, PR and issue update the session drafts finds its reasoning already written in the plan.**

- **Load `chalk:voice`.**
- **Skills that load this one take the plan file, the journal and the other sections above `/chalk` from it**, and nothing from `/chalk` itself, which only runs when the user invokes it.

## The plan file

**The session's plan — Claude Code's plan file, or the host's equivalent — unless the project names another place.**
Only the main session writes it; a sub-agent MAY be given its path to read, told not to write it — never a `weed-*` agent, which works because it arrives without the reasoning.

- **It opens with one line: `Journalled per chalk:chalk — commits via chalk:commit — <issue link, or "unfiled">`**, so a session after a compaction knows which skill to reload, and a sub-agent pointed at the plan knows how its commits are written.

- **It holds the plan, and below it, apart, the journal.**

- **It outlives plan mode.**
  Approving the plan exits plan mode, and the session goes on journalling into the same file through implementation.

- **What's in hand sits at the top**: the sub-goal being worked, and anything that interrupted it, innermost first.

- **It links an issue rather than copying it.**

## Branches and commits

**A branch the session owns may be rewritten, and pushed with force-with-lease; the base branch is never rewritten.**
A commit on it not yet pushed is still local, and MAY be reworded.
The session owns a branch it created for its work, one the user handed it, or one an earlier session created for the same card; someone else's branch or PR is theirs.

**A commit's own code calls what it adds, outside its tests**: a commit whose additions only a later commit calls is a slice of that commit, and a caller in another commit's tests doesn't count.
**A preparatory refactoring stands alone only where a reviewer would accept it without what it prepares** — worth landing if that change never came, or materially easing its diff; otherwise it is part of that commit.
**The completion test: where an unlanded commit's subject still holds with this change inside it, amend it** — a fixup and an autosquash — rather than following it, and never across kinds: a refactoring never folds into a behaviour change.

Amending, reordering and rewording unlanded commits is how a branch reaches review, so it is not left to the project.
An implementation harness refines how a branch is sliced.

## Mode

**Whether the user is watching is the session's mode** — primary unless the session runs headless or scheduled, when it starts secondary.
The session records it in the journal, and each switch as it happens, per `chalk:primary` and `chalk:secondary`.

## What has landed

**What has landed is the repo's to say, not the transcript's.**
The branch, `git status`, `git log` and the linked PRs say what happened; the transcript records only what was attempted.

## The journal

**The record kinds are the interface an implementation harness records through**; a harness names what to record, and records it here.
A harness records through these kinds, and MAY keep entries of its own besides.

**Write each entry when it happens, not at the end and not from memory.**
Each is one claim in `chalk:voice`'s register, terse; an entry that would mean nothing in a commit body, a PR or the issue doesn't belong.

- **`D<n>` decision** — the claim, and its grounds.
  A call you aren't sure of is a question, not a decision.
  An alternative rejected is its child, with why.
  A revised decision stays, marked `superseded by D<m>`.

- **`Q<n>` question** — what it blocks, and what would settle it.

- **`R<n>` requirement** — what the goal needs to be true, as the user or the card states it.

- **`principle:`** — a rule the user states for how the work is done, beyond this one call.
  A harness briefing a sub-agent passes these on.

- **`C<n>` constraint** — what bounds the solution, marked `essential` where the problem imposes it, `accidental` where the current system does and the change may remove it.

- **`A<n>` assumption** — what the work leans on that it doesn't control.

- **`risk:`** — what could stop it.

- **A constraint or assumption sits on the goal-tree node it bounds** (`chalk:goal-tree`), so it carries into the issue's tree under the same ID.

- **`dead-end:`** — a road that closed, and what closed it, where that constrains what comes next.

- **`inbox:`** — in primary, an arrival held for the user until their current thread closes, per `chalk:primary`.
  It is cleared once raised.

- **`review:`** — what a reviewer needs to check a commit, by its subject: what checking it means, the invariants it rests on with where each is made true, what pins it and what would break it, and what was verified and what wasn't.
  Whoever knows it writes it when the commit is made — before `chalk:commit`, which carries it into the commit's body, or, where a harness's agent made the commit, from the review notes that agent wrote into the body and reported.
  `chalk:pr`'s Reviewing this finds what spans commits and what was verified here.

- **Sub-goals, in the plan above** — each names what it depends on, and is ready once everything it depends on is done and no open question blocks it.
  When a sub-goal's commit is made, mark it done with the commit's subject, not its SHA, which a rebase rewrites.

- **`re-split:`** — what changed inside an approved plan, and which sub-goals it superseded or reopened; those are marked, not deleted.
  A harness re-splits its sub-goals without leaving the plan, so a re-split never re-enters plan mode.

- **`replan:`** — what changed, and which sub-goals and decisions it invalidated; those are marked, not deleted.
  Only a replan re-enters plan mode, per [the harness exits](#when-an-implementation-harness-exits).
  The harness journals it as it exits; chalk journals one only where no harness did.

**An entry keyed by a commit's subject follows the subject**: a step that rewrites a subject — a gate, a review-unit pass, a weed — updates the entries keyed by it.

**Cutting scope and accepting a risk MUST be recorded**; they leave no other trace.

**A decision that changes the problem or the agreed scope goes to the issue now**, through `chalk:issue`; the journal records that it went.
On an unfiled route it goes into the standalone PR where there is one, and otherwise stays in the journal.
**So does a dependency the session discovers**, onto the card it depends on rather than this one, per `chalk:issue`.
Everything else stays in the journal, naming the sub-goal it bears on only where the entry doesn't make that obvious.

## The task list

**The host's task list — Claude Code's tasks, or the host's equivalent — is a view of the plan's goal tree, never a second source.**
At any point it holds the current tree's open leaves; it is what the user sees of the work in progress.

- **A task carries a leaf's ID and subject line, and nothing the leaf doesn't.**
  Anything worth adding to a task belongs in the plan first.

- **Approving a plan that implements creates a task per open leaf.**
- **A sub-goal recorded after approval adds its task**; one that refines a leaf replaces the leaf's task.
- **A `replan:` or `re-split:` removes the tasks of the leaves it drops, and creates those of the leaves it adds.**
- **A sub-goal superseded or thrown away removes its task.**
- **A sub-goal interrupted by another has its task marked blocked by the other's.**
- **A sub-goal marked done completes its task**, and one reopened reopens it.
- **An implementation harness keeps it current as sub-goals move**, through the same rules.

## `/chalk [issue]`

**Enter plan mode first** — `EnterPlanMode`, or the host's equivalent — unless the session is already in it.
Exploring the problem is the planning, and plan mode is what holds every edit back until the user approves.

**The plan this skill describes replaces the host's plan-mode template.**
Claude Code's plan-mode reminders ask, every turn, for an implementation plan — context, critical files, verification, Explore and Plan agents.
Those are the host's defaults for a plan; where they conflict with this skill, this skill governs: no file lists, and sub-agents only where the exploration wants them.

### 1. Read the problem and its neighbourhood

- **With a card: the issue, its parent, its sub-issues, what blocks it and what it blocks, and its linked PRs**, via the github agent's reads.
  Ground it in the repo, not the transcript, per [What has landed](#what-has-landed).

- **Without one: what the user asked, and the existing cards it might duplicate or belong under**, via the github agent's search.

**Say what the scan tells you about this work being done now**, and carry on.
The *why now*, where there is one, is the issue's own (`chalk:issue`); work without one is opportunistic.

- **Where the scan changes the picture, wait for the user's agreement before changing anything, the tracker included.**
  An open blocker, a duplicate, or a card that supersedes this one.

- **Where the user named an umbrella rather than a piece of it, ask which piece.**
  You MUST NOT pick the most plausible-looking sub-task instead.

### 2. Ascertain what the session produces

**The session's output is an issue, or the implementation, and the plan takes that output's shape.**
Ask where the user hasn't said and the request doesn't settle it.

- **An issue** — the plan is the issue body's draft, on `chalk:issue`'s path, against the palette.
  With a card, planning explores and corrects it; without one, it drafts one.

- **The implementation** — the plan is what has to land, as a goal tree (`chalk:goal-tree`): the goal at the root, what lands at the leaves.
  With a card, its description is read and its gaps resolved through `chalk:issue`, not redrafted in the plan.
  Test each node for sufficiency, mark `check:` where unsure, and say where sufficiency leans on what the user already knows about the system.
  The leaves are provisional until the harness has exercised them: one that builds its route, as a-star's darts do, refines each leaf it walked into sub-goals.

- **Either way, the plan says what has to be true, not which files to touch.**
  Where the change reshapes the design, what has to be true is the target model, stated as a model diff at the goal tree's root ([`chalk:voice`'s models reference](../voice/references/models.md)).

**The route is part of the plan**: file and stop, implement an existing card, file and implement, or implement unfiled.
With an existing card, file and stop corrects that card through `chalk:issue` rather than filing a new one.
Implement unfiled where a card would carry nothing the commit or a standalone PR can't: a PR, where there is one, takes the standalone path in `chalk:pr` and carries the problem itself.

**A route that implements predicts whether its finish opens a PR**, by the rules under [the finish](#when-an-implementation-harness-exits).
Approving the plan approves the prediction.

**A route that implements names its implementation harness, and that is `a-star:a-star` where a-star is installed and the user hasn't stated another preference.**
Where a-star isn't installed, or the user prefers another harness or none, the plan says that instead.
The plan MAY name the harness's moves, in order — for a-star, darts and drives of named sub-goals — and approving the plan then approves them.
The harness takes each in that order without offering it again; a move off them is offered as usual.

### 3. Close the gaps while planning

**Report gaps against `chalk:issue`'s palette** — a missing goal, unclear scope, open questions nobody has answered.

- **Ask the user what they can answer now**, rather than parking it in the plan.
- **Open questions keep only what nobody can answer yet** — needing investigation, or deliberately deferred.

### 4. The plan's first step updates the card's metadata and its branch

**On an implementing route with a card, the plan MUST open with the tracker update**: the user as assignee, then status and board as the project's tracker conventions say for a card being picked up, through the github agent.
Where they don't say, ask.
**Every implementing route's first step creates or checks out the feature branch**, after the tracker update where there is one, off the project's base branch, and named by the project's convention.

- **It is a step in the plan, not something done while planning.**
  Plan mode is read-only, and until the plan is approved nobody has agreed to do the work.

- **A card already assigned to someone else changes the picture**, per step 1.

### 5. Exiting plan mode is the user approving the goal and the route

**`ExitPlanMode`, or the host's equivalent, asks for that approval**; you MUST NOT ask for it any other way.
In secondary, per `chalk:secondary`: the session never approves its own plan.
A rejection with comments is planning continuing: revise the plan, journal what changed as decisions, each one it replaces marked `superseded by D<m>`, and ask again.

**Asking is a claim that the plan is aligned, not that it is finished**, so you MUST answer three questions first:

1. Is any part of the plan a guess you'd revise if you asked the user one question?
2. Have you taken a neutral acknowledgement from the user for agreement?
3. Is there a decision inside the plan you made without surfacing it?

- **Yes to any → ask that instead**, and stay in plan mode.
- **Uncertain → stay in plan mode.**
  Exiting is the one move within the turn that can't be taken back; staying costs nothing.

Once approved, take the route:

- **File and stop** — file through `chalk:issue`, or with an existing card, correct it there.
- **Implement**, filed first or not — hand the plan to the implementation harness, or implement it directly where the session has none, taking the same exits as a harness's hand-back: finish, replan and park.
  - **Before handing the plan to a harness, carry out its first step yourself** — the tracker update and the branch checked out; a-star does neither.
  - **A plan re-approved after the harness's replan exit goes back to the harness without redoing that pickup**, and a file-and-implement route re-approved after a replan goes straight to implementing without filing again.

## When an implementation harness exits

**A harness hands back to chalk when it can't continue on the plan as approved**, and a session implementing without one takes the same exits.

- **Re-plan where the goal is invalidated — re-enter plan mode first**, with `EnterPlanMode` or the host's equivalent, before any other step.
  The approved plan no longer holds, so nothing more is built until the user approves the revised one.
  The harness journalled the `replan:` entry as it exited; implementing without one, journal it here, naming what it invalidated.
  Revise the plan, and ask for approval as in step 5.
- **Park where the work can't continue** — `chalk:put-down`, which ends the session.
- **Finish where the sub-goals complete the goal, opening a PR or not as the plan predicted.**
  A PR exists to share what the commit doesn't, so the prediction follows where that knowledge lives.
  - **Ask the user only where the work reverses the prediction.**
    In secondary, per `chalk:secondary`: decide, record the reversal and its grounds, and take it.
  - **The finish ends only once its drafts are cleared**: the branch's commit messages by `weed-commits`, and for a PR the description by `weed-pr` too, as `chalk:pr` sets out.
    A no-PR finish weeds the commit messages before its report.
  - **The prediction is one of three outcomes, the first whose condition holds, in the order listed**; where none holds, ask the user.
    - **No PR, where the commit carries it all, or an issue carries the knowledge and nothing in the implementation is counter-intuitive** — first update the issue through `chalk:issue` where the work changed what it should say.
      The finish then hands to nothing: it ends with a report naming the branch and its head sha.
    - **A standalone PR, where there is no issue and something to share beyond the commit** — `chalk:pr`'s standalone path.
    - **A PR on the issue — Resolves or Part of — where the implementation is worth sharing in its own right** — `chalk:pr`.
