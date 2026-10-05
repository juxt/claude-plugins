---
name: a-star
description: >
  The a-star process, and its entry point: pick a card up, test it for readiness, and offer refine, spike, drive or tidy.
  Every other a-star skill loads this one first — it carries the two steps, that children demonstrably complete their parent, the structure/behaviour split, the shape of the card's plan, and what a-star needs the project to say.
  Use when the user says "/a-star <card>", "pick up <card>", "start work on <card>", or resumes a card from an earlier session.
user-invocable: true
argument-hint: "<card: a tracker issue>"
---

# a-star

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

1. **Spike to an end-to-end as quickly as possible.**
2. **Use what the spike found to land atomic, comprehensible, correct, compliant changes.** Go to 1 as required.

**Throwing a tidy or a drive away is always an option.**
Where one turns out not to work the way the spike suggested, revert it, take its SHA off its section of the plan, and spike again with what it taught; none is ever big enough for its cost to be a reason to keep it.

## Roles

- **The super agent is the main session, and is accountable for the end state** — correctness, code quality, the project's standards and processes.
  It plans with the user, triages what spikes raise, and writes everything that lands, including the tests: the spiker may have written none.
  It runs on the strongest model available: finding seams, choosing and sequencing what a spike reveals, and spotting where a spike only worked because it broke an invariant is the hard judgement.

- **The spiker is a sub-agent on a cheaper model, and is accountable for none of it.**
  Its code never lands; it exists to show the route.
  It writes nothing shared: what it finds comes back as messages and a report.

**A user's question is a question, not a go-ahead.**
"Is that a good idea?" wants an answer; an offer of the next step waits for a yes.

**The super agent decides which calls are its own and which to escalate to the user, in either mode.**
Each call it takes is recorded as decided by the agent; in secondary, escalation isn't available, so each call is halt, decide or assume.

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
Ship landings are exempt; the project's ship/show/ask conventions say which is which, and where they say more about review, they win.

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

## The card's state lives in the session's plan

**The session's plan holds everything below the card's root**, and the session is its only writer — Claude Code's plan file, or the host's equivalent.
It survives a compaction whole, so nothing needs rehydrating from the transcript.

- **The root has one home: the tracker issue.**
  The goal, invariants and out of scope live in its description; the plan links the issue rather than copying it, because a copy drifts.

- **a-star decides the plan's sections.**
  - **One per landing, in landing order** — each a tidy or a drive, with the claim its commit will make.
  - **A card-level section** — what spans landings: the data structures the spikes found, decisions and risks about the card as a whole, and each spike's branch and head.
  - **A landed section gains its `<sha> <subject>`**, so the plan maps onto git.
  - **Where the work is now is at the top** — the section in hand, and any tidy that interrupted it.

- **The plan says what lands, never how to write it.**
  No files to touch, no steps: the spike found the route, and the code says it better once written.

- **The plan is updated at the end of every spike, tidy and drive**, and as decisions are made in between.
  How an entry is written — a decision and who made it, a question and what it blocks, an assumption, a risk — is the project's writing conventions' to say.

- **A citation carries the subject line, not the ID alone** — a session after a compaction can't see what the ID points at.

## What gets raised, and who writes it down

**The spiker reports; the super agent decides what stands, and writes it into the plan.**
The spiker messages increments that could land now and questions that would change its route, and ends with a report.

**At landing, only the agent's decisions and the assumptions need review.**
A user's decision was reviewed when it was made; the plan's agent-decided entries and assumptions are the review list.

## Primary or secondary

**A property of the session: whether the user is actively watching its progress.**
A session starts primary; the user switches it with `a-star:secondary`, and back with `a-star:primary`. Each says what its mode needs.

- **The mode MUST survive a compaction**: record it at the top of the plan, so a secondary session doesn't come back primary and start asking questions nobody will answer.
- **A session nobody can watch — headless, cloud or scheduled — MUST start secondary.**

## `/a-star <card>`

1. **Pick the card up** per the project's conventions: its issue and neighbourhood read, why it's being done now agreed with the user, the tracker updated, and the plan started.
   Resuming in a session that already holds the card's plan skips straight to readiness.

2. **Test readiness.** A card is ready when a spike can start from it alone:
   - **its root is agreed** — goal, invariants and out of scope, on the tracker issue;
   - **no open question bears on the card itself** — one blocking a single landing doesn't hold the others up;
   - **the project's readiness conventions hold.**

3. **Offer the next step, and wait.**
   Not ready → `a-star:refine`. Ready → `a-star:spike`, or `a-star:drive` / `a-star:tidy` on a landing where the spikes have already found the route.

## What the project says

**a-star carries the process, and defers the rest to the project's own conventions without naming them** — writing, the tracker, picking a card up and putting it down, the base branch, ship/show/ask, the definition of done, coding standards.
A project's `AGENTS.md`, `CLAUDE.md` or equivalent says those whether or not a-star is in use.

**A few choices are a-star's own, and generic conventions are silent on them**, so the project has to answer them — in its own instructions, or a project-specific a-star skill:

| Choice | Read by | What it says |
|---|---|---|
| Tidy landing | `tidy` | feature branch or main; what to verify before committing; when to push; whether a tidy is done at commit or once CI is green |
| Drive landing | `drive` | what to verify before committing, and whether to push the feature branch as work lands |
| Branch cleanup | `landed` | what happens to a landed branch, locally and on the remote |

**One with no answer MUST be raised as a question, and MUST NOT be filled with a default** — a guessed verification step reads as settled.

- **Branch cleanup is the exception**: where the project says nothing, `landed` deletes local branches and worktrees whose work has landed, and only offers redundant remote branches.
