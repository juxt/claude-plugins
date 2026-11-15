---
name: issue
description: Create a GitHub issue, or update an existing issue's description, with a body that captures the problem and why it matters, in the chalk voice. Use when the user says "open an issue", "file a bug", "raise an issue", "create an issue", "file a ticket", "write up a feature request", "/chalk:issue"; OR is about to compose, draft, write or update any GitHub issue title, issue body or issue description (e.g. "write up an issue for this", "update the issue description", "put the analysis on the ticket"). Load this skill BEFORE drafting any such prose — it carries the voice guidance the body needs.
user-invocable: true
disable-model-invocation: false
---

# Issue

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

This skill owns the issue description — drafting it, filing the issue, and correcting the description afterwards.
**Which sections the body gets comes from `chalk:voice`'s `references/palette.md`**; this skill covers what an issue is for, and how it gets filed.

**An issue is a living document**, per the palette.
It states the problem as it is now, written as if it had always been that way.

## Your readers

`chalk:voice` says who they are; here they are doing one of three things, and **none of them is deciding whether the work is worth doing**.

- **Reader 1 has decided to pick this up**, and needs to understand the problem in enough detail to solve it.

- **Reader 2 is checking whether this issue is what they're hitting right now** — usually a bug.
  They are **matching, not reading**: an error string, a version or a triggering condition either matches theirs or it doesn't.

- **Reader 3 arrives after it closed**, to find out why.
  A description that only parses alongside the comments has failed them, and so has an Open question nobody deleted.

## Which path

**A bug issue is an investigation log; a feature issue is a design brief.**
They draw different palette sections because one converges on a fact and the other on a choice.

- **Fork on what the issue converges on, not on the label.**
  "Queries got 10x slower" converges on a fact — bug.
  "Make queries faster" converges on a choice — feature.

- **A task, chore or refactor is the feature path with sections empty**, and an epic is a feature large enough to have children.
  There is no third path.

- **An incident takes the bug path** — what it wants beyond one is an annotated trace, which the palette carries inside Root cause.

- **A spike takes the feature path** — its deliverable is knowledge rather than code, which changes what *done* means, not which sections it has.

## Before you draft

Load, via the Skill tool:

- **`chalk:voice`** — the register, the audience, the mindmap shape, the line-format rule.

- **`chalk:voice`'s `references/palette.md`** — the sections on your path.

- **`chalk:goal-tree`** — wherever a section's children *accomplish* their parent rather than argue for it.

**Write each section as a mindmap**, per `chalk:voice`.
Reader 1 arrives with a question and reader 2 with a symptom, so each of them is skipping most of what you write: every subject line MUST let them discard the bullet against that goal, or agree with it and move on without reading the body.

**The body MUST open with a tl;dr**, per `chalk:voice` — the summary sentence, then the mindmap, with no heading over it.
The first `##` in the body is the section after it.

## Establish the why

**An issue MUST NOT be filed without a clear and concise *why*.**
There is no diff here to recover it from in six months, so a missing one is blocking, wherever it surfaces — `weed-issue` included.
Where the motivation isn't recoverable, ask — "I can reconstruct it" is the answer that needs checking, per `chalk:voice`.

- **The issue is the one place a *why now* lives.**
  Commits and PRs link the issue rather than carrying their own, so whatever prompts the work belongs here.
  Either of these alone is one, and you cite whichever you can evidence rather than both:
  1. impact (stated objectively)
  2. unblocking downstream dependencies

  - **An issue with no *why now* is opportunistic, and that is a valid state.**
    It needs no tag and blocks nothing; you MUST NOT invent one to fill the line.

  - **A session that finds its work waits on another card writes that onto the other card**, through this skill: the named downstream in its context, and the blocked-by edge in the tracker.
    The session that learns of the dependency is the only one holding it, so it is the one that records it.

## Check it doesn't already exist

You SHOULD ask the github agent to search open and recently-closed issues before filing.
Where a close match exists, you SHOULD propose updating that description or commenting on it instead, and let the user choose.

**Where the work plainly exceeds one landing, it has children** — see *One piece, or it has children*, and file them in the same session.

## Draft the title

The user MAY pass one as an argument (`/chalk:issue flaky expression_test under load`); use it if they did.
Otherwise state the behaviour you want to be true — "the replica log should elect its own leader", "a restarted node should not reset the leader term".

**Success: a reader recognises the issue from the title alone**, without opening it.
Someone scanning thirty titles must be able to discard this one confidently, or open it. An acceptance test is usually the shape that manages it.

- **A title MUST say whether it states the desired behaviour or the current defect**, and **on the bug path that needs deliberate care.**
  A bug's natural phrasing is its symptom, and a symptom reads identically on a card that wants it fixed and one that wants it kept: "leader election borrows Kafka's consumer group" sits equally well above a plan to replace it and a plan to harden it.
  **`should` and `should not` settle it in one word** — "a restarted node should not reset the leader term" is a symptom stated as the behaviour someone wants.

- **Lowercase `should`, never `SHOULD`.**
  An RFC 2119 keyword grades how strongly something is required, which is a body concern; a title names the behaviour.

- **Name the behaviour, not the mechanism that delivers it.**
  "The replica log should elect its own leader" survives a design change; "add a RaftElector" dates the moment the design moves.

## Writing a bug

An investigation log: it converges on a fact, and until it gets there its central claim is a guess.
**tl;dr → Symptoms → Current state → Root cause / Analysis → Out of scope → Alternative approaches → Open questions**

Each section's content is in the palette, and not every bug needs every section — but where a section appears, this is its position.

- **Gather the concrete material before drafting** — the error text, failing test names, log excerpts with timestamps, the types and files involved, links to CI runs.
  Reaching for these mid-sentence is how placeholders get in.

- **Current state comes before Root cause**, so the mechanism is read against the behaviour it breaks.
  Its essential couplings are what a fix must preserve.

## Writing a feature

A design brief: it converges on a choice, and its job is to **constrain** that choice rather than to make it.
**tl;dr → Problem → Properties of a good solution → Prior art → Potential approach → Out of scope → Alternative approaches → Open questions**

Each section's content is in the palette, and not every feature needs every section — but where a section appears, this is its position.

- **The solution-shaped sections MUST NOT appear unless the session genuinely worked the implementation.**
  Properties of a good solution, Prior art, Potential approach, Alternative approaches.
  The test is whether you traced the code, weighed approaches, or the user talked a design through — not whether you can think of a fix.

  - **Where a fix is obvious but unconsidered, one line under the problem is enough** ("probably wants X").
    A guess written up as a decision is worse than no section at all: reader 1 can't tell it from a conclusion, and will build it.

- **Problem carries a Current state subsection only where today's behaviour bears on the problem** — see the palette.
  Its couplings are the constraints the design has to respect, so where it appears it is drafted before Potential approach.

- **Potential approach MUST be a goal tree** (`chalk:goal-tree`), not a task list.
  It answers what has to be true for this to be done, not which files to touch.
  A child MAY be a link to the issue that owns that part.

- **On a parent issue, Potential approach is compulsory.**
  The tree *is* the decomposition, so a parent without one asserts a body of work with no visible unit of delivery.

## Any issue

### One piece, or it has children

**Every issue MUST be small enough to land as a single commit or PR, or MUST have sub-issues or PRs carrying its parts.**
An issue that is neither leaves whoever picks it up to redo the decomposition from the description alone, with less context than you have while filing it.

- **Wire the relationships in the same session the issue is created** — parent/sub-issue where work nests, blocked-by where order matters.
  A sub-issue inherits its parent's motivation, so its own description stays on its slice.
  The github agent has the GraphQL recipes (`addSubIssue`, `addBlockedBy`).

- **Wanting a progress checklist means the granularity is wrong.**
  An issue that needs progress needs sub-issues; at the right granularity it needs neither.
  The github agent refuses to post a body carrying a `## Progress` section or a status line.

### Open questions

**What the session left unanswered goes in Open questions**, one entry each — what each carries, and when it is deleted, is the palette's.

### Correcting the description

The description is the source of truth, so it MUST be corrected as the facts change — a new failure mode, revised scope, a root cause that turned out to be something else.

- **Current state is the exception: it stays as the *before*** once the work lands — see the palette.

- **Update facts; preserve framing.**
  Don't rewrite someone else's narrative or reorder their sections to your taste — keep their intent and correct what is now wrong.

- **Read the current body first.**
  GitHub replaces the whole body on edit, so the agent needs the full new text.

- **Transitions MUST NOT appear in the description.**
  "We originally thought X" MAY belong in a comment, which is timestamped and append-only.

- **Where a PR is coming or open, `chalk:pr`'s *Correct the issue* corrects it before the PR closes.**

### Weed the draft

**Delegate to the `weed-issue` agent** as the caller's side of `chalk:voice`'s `references/cold-read.md` sets out, passing the body's path, plus the parent issue if there is one.
It reads the body cold, as each of the issue's readers, attempts each one's job from it, and reports where they get stuck.

- **Passing the parent is what lets it treat the inherited motivation as the reader's**, and cut a restatement of it.

### Filing it

**All GitHub interaction MUST go through the chalk github agent**; the main context MUST NOT call `gh issue` directly.

- **Pass the fully-drafted body, ready to post verbatim.**
  Passing bullet points and asking the agent to write them up is not acceptable.

- **Pass any project-specific conventions in your context verbatim** — project boards, default labels, milestones, assignees — and let the agent apply them alongside its own defaults.

- Report the issue number back to the user.
