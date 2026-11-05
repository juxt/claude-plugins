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
- **Skills that load this one take the plan file and the journal from it**, and nothing from `/chalk` below, which only runs when the user invokes it.

## The plan file

**The session's plan — Claude Code's plan file, or the host's equivalent — unless the project names another place.**
Only the main session writes it; a sub-agent MAY be given its path to read, told not to write it — never a `weed-*` agent, which works because it arrives without the reasoning.

- **It opens with one line: `Journalled per chalk:chalk — commits via chalk:commit — <issue link, or "unfiled">`**, so a session after a compaction knows which skill to reload, and a sub-agent pointed at the plan knows how its commits are written.

- **It holds the plan, and below it, apart, the journal.**

- **It outlives plan mode.**
  Approving the plan exits plan mode, and the session goes on journalling into the same file through implementation.

- **What's in hand sits at the top**: the sub-goal being worked, and anything that interrupted it, innermost first.

- **It links an issue rather than copying it.**

## The journal

**The record kinds are the interface an implementation harness records through**; a harness names what to record, and records it here in these kinds.

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

- **Sub-goals, in the plan above** — each names what it depends on, and is ready once everything it depends on is done and no open question blocks it.
  When a sub-goal's commit is made, mark it done with the commit's subject, not its SHA, which a rebase rewrites.

- **`replan:`** — what changed, and which sub-goals and decisions it invalidated; those are marked, not deleted.

**Cutting scope and accepting a risk MUST be recorded**; they leave no other trace.

**A decision that changes the problem or the agreed scope goes to the issue now**, through `chalk:issue`; the journal records that it went.
**So does a dependency the session discovers**, onto the card it depends on rather than this one, per `chalk:issue`.
Everything else stays in the journal, naming the sub-goal it bears on only where the entry doesn't make that obvious.

## The task list

**The host's task list — Claude Code's tasks, or the host's equivalent — is a view of the plan's goal tree, never a second source.**
At any point it holds the current tree's open leaves; it is what the user sees of the work in progress.

- **A task carries a leaf's ID and subject line, and nothing the leaf doesn't.**
  Anything worth adding to a task belongs in the plan first.

- **Approving a plan that implements creates a task per open leaf.**
- **A `replan:` removes the tasks of the leaves it drops, and creates those of the leaves it adds.**
- **A sub-goal marked done completes its task.**
- **An implementation harness keeps it current as sub-goals move**, through the same rules.

## `/chalk [issue]`

**Enter plan mode first** — `EnterPlanMode`, or the host's equivalent — unless the session is already in it.
Exploring the problem is the planning, and plan mode is what holds every edit back until the user approves.

**The plan this skill describes replaces the host's plan-mode template.**
Claude Code's plan-mode reminders ask, every turn, for an implementation plan — context, critical files, verification, Explore and Plan agents.
Those are the host's defaults for a plan; where they conflict with this skill, this skill governs: no file lists, and sub-agents only where the exploration wants them.

### 1. Read the problem and its neighbourhood

- **With a card: the issue, its parent, its sub-issues, what blocks it and what it blocks, and its linked PRs.**
  Ground it in the repo, not the transcript: the branch, `git log` and linked PRs say what has landed.

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

- **Either way, the plan says what has to be true, not which files to touch.**
  Where the change reshapes the design, what has to be true is the target model, stated as a model diff at the goal tree's root ([`chalk:voice`'s models reference](../voice/references/models.md)).

**The route is part of the plan**: file and stop, implement an existing card, file and implement, or implement unfiled.
Implement unfiled where a card would carry nothing the commit or a standalone PR can't: a PR, where there is one, takes the standalone path in `chalk:pr` and carries the problem itself.

**A route that implements predicts whether its finish opens a PR**, by the rules under [the finish](#when-an-implementation-harness-exits).
Approving the plan approves the prediction.

**A route that implements names its implementation harness, and that is `a-star:a-star` where a-star is installed and the user hasn't stated another preference.**
Where a-star isn't installed, or the user prefers another harness or none, the plan says that instead.

### 3. Close the gaps while planning

**Report gaps against `chalk:issue`'s palette** — a missing goal, unclear scope, open questions nobody has answered.

- **Ask the user what they can answer now**, rather than parking it in the plan.
- **Open questions keep only what nobody can answer yet** — needing investigation, or deliberately deferred.

### 4. The plan's first step updates the card's metadata

**On a route that implements, the plan MUST open with the tracker update**: the user as assignee, then status and board as the project's tracker conventions say for a card being picked up.
Where they don't say, ask.

- **It is a step in the plan, not something done while planning.**
  Plan mode is read-only, and until the plan is approved nobody has agreed to do the work.

- **A card already assigned to someone else changes the picture**, per step 1.

### 5. Exiting plan mode is the user approving the goal and the route

**`ExitPlanMode`, or the host's equivalent, asks for that approval**; you MUST NOT ask for it any other way.
A rejection with comments is planning continuing: revise the plan, journal what changed, and ask again.

**Asking is a claim that the plan is aligned, not that it is finished**, so you MUST answer three questions first:

1. Is any part of the plan a guess you'd revise if you asked the user one question?
2. Have you taken a neutral acknowledgement from the user for agreement?
3. Is there a decision inside the plan you made without surfacing it?

- **Yes to any → ask that instead**, and stay in plan mode.
- **Uncertain → stay in plan mode.**
  Exiting is the one move within the turn that can't be taken back; staying costs nothing.

Once approved, take the route:

- **File and stop** — file through `chalk:issue`.
- **Implement**, filed first or not — hand the plan to the implementation harness, or implement it directly where the session has none.

## When an implementation harness exits

**A harness hands back to chalk when it can't continue on the plan as approved.**

- **Re-plan where the goal is invalidated — re-enter plan mode first**, with `EnterPlanMode` or the host's equivalent, before any other step.
  The approved plan no longer holds, so nothing more is built until the user approves the revised one.
  Journal a `replan:` entry naming what it invalidated, revise the plan, and ask for approval as in step 5.
- **Park where the work can't continue** — `chalk:put-down`.
- **Finish where the sub-goals complete the goal, opening a PR or not as the plan predicted.**
  A PR exists to share what the commit doesn't, so the prediction follows where that knowledge lives.
  - **Ask the user only where the work reverses the prediction.**
    Whether the implementation turned out counter-intuitive, or changed what the issue should say, is only known at the end; a prediction those leave standing needs no question.
  - **The prediction is one of three outcomes, each selected by its condition.**
    - **No PR, where the commit carries it all, or an issue carries the knowledge and nothing in the implementation is counter-intuitive** — offer a `chalk:issue` update first where the work changed what the issue should say.
      The finish then hands to nothing: it ends with a report naming the branch and its head sha.
    - **A standalone PR, where there is no issue and something to share beyond the commit** — `chalk:pr`'s standalone path.
    - **A PR resolving the issue, where the implementation is worth sharing in its own right** — `chalk:pr`.
