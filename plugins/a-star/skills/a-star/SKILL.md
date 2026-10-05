---
name: a-star
description: >
  The a-star process, and its entry point: resolve a card, test it for readiness, and offer refine, spike, drive or tidy.
  Every other a-star skill loads this one first — it carries the two steps, that children demonstrably complete their parent, the structure/behaviour split, what gets raised and its form in beads, and the policy a-star reads from the project.
  Use when the user says "/a-star <card>", "pick up <card>", "start work on <card>", or resumes a card from an earlier session.
user-invocable: true
argument-hint: "<card: a bd ID or a tracker issue>"
---

# a-star

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

1. **Spike to an end-to-end as quickly as possible.**
2. **Use what the spike found to land atomic, comprehensible, correct, compliant changes.** Go to 1 as required.

**Throwing a tidy or a drive away is always an option.**
Where one turns out not to work the way the spike suggested, revert it, `bd reopen` its task or chore, and spike again with what it taught; none is ever big enough for its cost to be a reason to keep it.

## Roles

- **The super agent is the main session, and is accountable for the end state** — correctness, code quality, the project's standards and processes.
  It plans with the user, triages what spikes raise, and writes everything that lands, including the tests: the spiker may have written none.
  It runs on the strongest model available: finding seams, choosing and sequencing what a spike reveals, and spotting where a spike only worked because it broke an invariant is the hard judgement.

- **The spiker is a sub-agent on a cheaper model, and is accountable for none of it.**
  Its code never lands; it exists to show the route.
  It owns its `spike` bead's subtree in bd, and nothing else there.

**A user's question is a question, not a go-ahead.**
"Is that a good idea?" wants an answer; an offer of the next step waits for a yes.

**The super agent decides which calls are its own and which to escalate to the user, in either mode.**
Each call it takes is recorded `decided-by=agent`; in secondary, escalation isn't available, so each call is halt, decide or assume.

## Children demonstrably complete their parent

**Assume every child is done, then ask whether the parent is thereby achieved.**
Not "do these look related to the parent?" but "do these, plus what we already know about this system, get us there?"
Refinement agrees the card's root and writes no children; a spike's harvest writes them, and applies this test as it does.

## The split

**A structure change and a behaviour change never share a commit** (Beck, *Tidy First?*).

- **A tidy changes structure, never behaviour.** `a-star:tidy` lands one, and owns interrupting other work to do so.
- **A drive changes behaviour.** `a-star:drive` lands one.

**A tidy is worth its diff when it increases options** (Beck).
Software's value is what it does now plus what it could cheaply be made to do next; behaviour changes add the first, structure changes the second.
A tidy that makes the change in hand easy is one case — *make the change easy, then make the easy change* — but not the only one, and a tidy that opens no option is just more diff to read.

## How code is written

**A show or ask landing MUST get a code-review pass over its diff before it's handed over**, by a reviewer briefed without the session's reasoning — the `/code-review` skill, or a code-review agent.
Ship landings are exempt; the project's landing policy says which is which, and where it says more about review, it wins.

- **The code the super agent lands MUST have obviously no deficiencies, not merely no obvious deficiencies** (Hoare).
  a-star is for complex projects — concurrency, distributed systems, essential state, performance-critical code whose optimisations add incidental complexity — where a deficiency nobody can see is the one that ships.
  The route there is simple code in Hickey's sense (*Simple Made Easy*): concerns un-braided, not merely familiar.
  The spiker optimises for easy; turning what it found into simple code is the super agent's job.

- **Both the super agent and the spiker SHOULD make illegal states unrepresentable** (Minsky).
  A nil check, a flag or a special case marks a state the types could have ruled out; the fix removes the state rather than keeping the guard.
  A named field has one meaning everywhere it appears, and no caller passes a placeholder to satisfy a parameter that doesn't apply to it — either is two concerns sharing one type.

- **Landed code SHOULD be a functional core inside an imperative shell** (Bernhardt, *Boundaries*).
  What that means in a given codebase is the project's to say, in its coding standards.

- **State that changes together SHOULD be one value, swapped whole by its one writer.**
  - **Two questions find it**: what is this field's lifetime, and what resets it? Fields that share both are one value; an asymmetry in what resets them is where a stale read comes from.
  - **A swap function MUST be pure**, because a compare-and-swap may run it more than once.
  - **Needing to swap two values atomically means the boundary between them is in the wrong place** — a signal to move it, not a reason for a bigger lock.

- **A test SHOULD sit at a different level of abstraction from the code it tests, never the same one.**
  A test at the code's own level restates the code, so it agrees with it whatever it does: very general code, like a type checker, is tested with many specific cases, and specific code against the general property it serves.

- **A spike's most valuable finding is the data structures that match the real world.**
  They are the problem's essential complexity (Moseley and Marks, *Out of the Tar Pit*); everything a spike builds around a structure that doesn't match is accidental, and is what the landed changes leave out.

## The card's state lives in beads

**a-star depends on beads (`bd`) and reimplements none of it** — IDs, status, blocking, readiness and history are bd's.

| What | Its form in bd |
|---|---|
| the card | an `epic` titled for the card, `--external-ref` to its tracker issue, and nothing more |
| a behaviour change | a `task` |
| a structure change | a `chore` |
| an open question | an open `decision` issue, a dependency of the node waiting on its answer |
| a decision | a closed `decision` issue, `--reason` saying what was decided |
| who decided | `bd set-state <decision> decided-by=user` or `decided-by=agent` |
| an assumption or a risk | a `bd note` on the node it concerns, starting `Assumption:` or `Risk:` |
| a spike | a `spike` under the card; the spiker writes below it, and its close reason names the branch and head |
| where the work is now | the chain of `in_progress` nodes |

- **The card's root has one home: its tracker issue.**
  The goal, invariants and out of scope live in the issue's description, written through the project's writing policy and read live through its tracker policy; bd copies none of it, because a copy drifts.
  A card with no tracker issue keeps them in the epic's description instead.

- **Who decided is state on the decision, not bd's actor.**
  The actor records who *wrote* the issue, and when the super agent records the user's call, that's the agent either way.

- **A question about a node's own readiness can't block that node** — bd won't let a node depend on its own descendant.
  Put it under the node's parent, depending from the node.
  A question about the card itself has no parent to go under: it sits directly under the card with nothing depending on it, which is how readiness tells it from a question blocking one task.

- **A revised decision is `bd supersede <old> --with <new>`**, so the old reasoning stays readable from the new one.

- **A citation carries the subject line, not the ID alone** — a session after a compaction can't see what the ID points at.

## What gets raised, and who writes it down

**The spiker writes open questions, assumptions, risks and decisions into its own `spike` subtree as it goes**, and messages the super agent with increments that could land now.
**The super agent decides what stands**: at harvest it promotes what it accepts into the card's tree, and it is the only writer outside a `spike` subtree.

**At landing, only agent-decided decisions and assumptions need review.**
A user's decision was reviewed when it was made; `bd query 'id="<card>.*" AND type=decision AND label=decided-by:agent' --all` and the assumption notes are the review list.

## Primary or secondary

**A property of the session: whether the user is actively watching its progress.**
A session starts primary; the user switches it with `a-star:secondary`, and back with `a-star:primary`. Each says what its mode needs.

- **The mode MUST survive a compaction**: carry it into the summary, so a secondary session doesn't come back primary and start asking questions nobody will answer.
- **A session nobody can watch — headless, cloud or scheduled — MUST start secondary.**

## `/a-star <card>`

1. **Resolve the card.**
   A bd ID is the card; a tracker issue is found by its epic's `--external-ref`. One with no epic yet isn't refined — route to `a-star:refine`, which creates it.

2. **Read the card** — the tracker issue for its root, then `bd show <card>`, its children and its dependencies for everything below.
   That is the whole brief: nothing needs rehydrating from an earlier session.

3. **Test readiness.** A card is ready when a spike can start from it alone:
   - **its root is agreed** — goal, invariants and out of scope, on the tracker issue;
   - **no open question about the card itself** — an open `decision` directly under it that nothing depends on;
   - **`bd ready` lists the node about to be worked**, where it's a task or chore — or it's the top of the `in_progress` chain, being resumed; a question blocking a different task doesn't hold this one up;
   - **the project's readiness policy holds.**

4. **Offer the next step.**
   Not ready → `a-star:refine`. Ready → `a-star:spike`, or `a-star:drive` / `a-star:tidy` on a named task or chore where the spikes have already found the route.

## Policy

**a-star carries the process; the project carries the policy**, in its `AGENTS.md`, `CLAUDE.md` or equivalent (including any nearer the code being changed), or in a project-specific a-star config skill.

| Slot | Read by | What it says |
|---|---|---|
| Readiness | `/a-star`, `refine` | what a card needs beyond an agreed root before a spike can start |
| Base branch | `spike`, `drive`, `tidy` | the project's local main, which feature branches come off |
| Landing | `drive`, `tidy` | ship, show or ask, per landing |
| Tidy target | `tidy` | whether a tidy lands on the feature branch or on main, where the user isn't choosing |
| Early push | `drive`, `tidy` | whether to push the feature branch as work lands on it, so CI backstops |
| Definition of done | `drive` | what the final tidy checks against |
| Coding standards | `drive`, `tidy` | what the super agent writes landed code to |
| Writing | `refine`, `drive`, `tidy`, `landed` | what writes the tracker issue, commit messages and PR descriptions |
| Tracker | `/a-star`, `landed` | the tracker, and its conventions for a card being worked |
| Put-down | `refine`, `drive`, `tidy`, `secondary` | how a card is parked on the tracker when work on it stops |
| Branch cleanup | `landed` | what happens to a landed branch, locally and on the remote |

**A slot with no answer MUST be raised as a question, and MUST NOT be filled with a default** — a guessed definition of done reads as settled.

- **Branch cleanup is the one exception**: where the project says nothing, `landed` deletes local branches and worktrees whose work has landed, and only offers redundant remote branches.

## Setup

**Check it before the first step: `bd where` finds this repo's bd workspace.**
Where it doesn't, run `a-star:setup`, and carry on once it's done.
