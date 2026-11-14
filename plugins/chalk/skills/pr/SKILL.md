---
name: pr
description: Create a pull request with a description that captures the intent and reasoning behind the change, in the chalk voice. Use when the user says "create a PR", "open a PR", "submit a PR", "raise a PR", "make a PR", "PR this", "/chalk:pr"; OR is about to compose, draft, write or update any pull request title or body (e.g. "write a PR description", "draft the PR body", "update the PR description", "let's put that in the PR"). Load this skill BEFORE drafting any such prose — it carries the voice guidance the PR body needs.
user-invocable: true
disable-model-invocation: false
---

# Pull Request

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

This skill owns the PR description.
**Which sections the body gets comes from `chalk:voice`'s `references/palette.md`**; this skill covers what a PR description is for, and how it gets opened.

**A PR description freezes at merge.**
Unlike an issue, it has no mechanism for resolving what it doesn't yet know, so it states what is now true rather than what might be — and it hands the change over rather than arguing for it.

**What it hands over is the author's theory of the change** — what the change is for, why each part is the way it is, and what would break if it changed (Naur, *Programming as Theory Building*).
The code is a lossy projection of that theory: a reader can rebuild it from the diff, at far more cost and less faithfully than by reading it.
Where the author worked in a session nobody watched — a background agent, a long run — the description is the only place the theory reaches a human.

## Your readers

`chalk:voice` says who they are; here they are doing one of three things.
Any one reader is doing one of the three; you are writing for all of them at once, so the description MUST serve each and satisfying one is not a licence to drop another.

- **Reader 0 is the reviewer, who has to own the change once it merges.**
  They review it commit by commit, and afterwards they maintain it, debug it and defend it.
  They hold the diff, so argument where they could just look reads as something you couldn't show; what they can't look at is the theory.
  **Success — the bus test:** holding only the description and what it links, they can explain the change to a teammate, predict its behaviour in a case the description doesn't mention, and notice when a later change breaks an invariant it relies on.

- **Reader 1 is a peer updating their mental model**, now.
  They need the delta, and above all **the belief they hold that no longer holds**.
  A PR is the moment the rest of the team learns the change exists, so their first question is whether it affects them.
  **Success:** the reader can tell how this affects their work, and what they believe about the system afterwards is true - the understanding is conveyed accurately and concisely.

- **Reader 2 is the same person in a year**, asking why one aspect of this mattered.
  **Success:** they don't accidentally revert it, and they don't rehash from scratch a decision this description already settled.

## Which path

- **Resolves an issue** — the issue carries the problem and the direction, so this description MUST NOT restate the problem.
  Reference it at the top (`Resolves #N`, or `Part of #N`) and assume the reader has read it. What this adds is the theory as built: the model, how the problem shaped it, the decisions, the trade-offs, the dead ends.
  **The model is stated here even where the issue's Potential approach states it too** — the issue holds the direction a reader can follow, the description holds the model as it landed, and the overlap is the price of each standing on its own.

  **tl;dr → What changes → Usage / migration → Reviewing this → Consequences → Out of scope → Alternative approaches → Open questions**

- **Standalone** — there is no issue, so this description carries the problem itself, acting as both.
  **The first line MUST state what and why** — the line that would have been a reference has to do the issue's opening job instead.
  A *why now* belongs there only where the session has one; you MUST NOT invent one.
  **This is the path that leads with the problem.** On the other one, leading with the problem is the duplication the pairing exists to prevent.
  It inserts the problem sections, and only those: the rest of the issue side is design-space or forward-looking material, and a PR is retrospective.

  - **fixing a bug** — **tl;dr → Symptoms → Root cause → What changes → Usage / migration → Reviewing this → Consequences → Alternative approaches (optional) → Open questions**

  - **adding a feature** — **tl;dr → Problem → What changes → Usage / migration → Reviewing this → Consequences → Out of scope → Alternative approaches → Open questions**

Each section's content is in the palette, and not every change needs every section — but where a section appears, this is its position.

## Before you draft

A PR description is an **explanation** artefact, and it MUST be drafted against the chalk voice.
Load, via the Skill tool:

- **`chalk:voice`** — the register, the audience, the mindmap shape, the line-format rule.

- **`chalk:voice`'s `references/palette.md`** — the sections on your path. Not every change needs every section.

- **`chalk:chalk`** — the plan file's shape and the journal's record kinds, which the description is written from.

**Write each section as a mindmap** — a short tl;dr opening it, then the tree.
Reader 0 is working through the change in the order it can be checked, reader 1 is scanning for what touches their work, and reader 2 for one decision, so all three skip most of the body: every subject line MUST let them discard the bullet against that goal, or take it unread.
**The skill is in helping the reader see quickly what they can skip**, not in making the body short: depth below a subject line costs a skipping reader almost nothing, and a missing model sentence costs every reviewer the rebuild.
A wall of undifferentiated prose means this step was skipped.

**The body MUST open with a tl;dr**, per `chalk:voice` — the summary sentence, then the mindmap, with no heading over it.
The first `##` in the body is the section after it.

## Gather the context

- Review the commits on this branch — all of them, not just the latest.

- Read the session's plan journal, all of it, where `chalk:chalk` started one.
  It's material, not a draft: what reaches the description is what *Your readers* and the palette call for — a decision because it matters to them, whoever made it.
  Its `review:` entries are Reviewing this's raw material.

- Review the conversation history for context that isn't in the commits or the plan.

- Where there is a linked issue, read its description and comments via the github agent.

- Identify the base branch.

## Correct the issue

**Before you draft the description, correct the linked issue** wherever the work contradicted something it asserted.
A confident, wrong problem statement with a PR that silently disagrees is worse for the later reader than either alone.

Do it first because the description is drafted against the issue and passed to `weed-pr` beside it: a stale issue makes the description either repeat the error or look as though it contradicts the problem.
Where there is no linked issue, there is nothing to correct and this step is empty.

## Draft the title

The user MAY pass one as an argument (`/chalk:pr feat: read-only secondaries`); use it if they did.
Otherwise draft one from the branch's commits that captures the intent rather than the mechanism.

**Success: a reader recognises the change from the title alone**, without opening the PR.
It is the first stage of the filter the tl;dr's abstract then runs — reader 1 scans a list of merged PRs for the one that touched their area, and reader 2 searches it a year later.

- **State the delta: "X no longer Ys", "X now Zs".**
  This is the accomplished form of the issue title's `should`, and it disambiguates the same way — "leader election in the replica log" doesn't say which side of the change this PR is on.
  It also puts What changes' obligation in the title: the fact that was true and no longer is.

## Draft the description

**It MUST NOT just list what changed — the diff shows that.**
It is the theory distilled across the branch.
Usage examples and commit lists have a reference *shape*, but they are illustrations inside the explanation.

**The test for a sentence is whether a reader holding only the diff would arrive at it cheaply — not whether the diff contains it.**
"Each group's ranks are offsets into the sorted stream" is derivable from a diff, at the cost of reconstructing the algorithm; it stays.
"`aggregate` now calls `append`" is read off the diff at a glance; it goes.

**Open one or two levels of abstraction above the work, and assume everything above that** — per `chalk:voice`'s hourglass.
Work inside an aggregate's internals opens at the operator and the engine's memory model; the reader brings the storage format and the query engine themselves.

**Teach the mental model the change assumes, before any type name.**
State the model in a sentence, then descend: the mechanism, then the decisions inside it, then the specifics.
Name what would surprise someone familiar with the subsystem, and don't assume the reader holds the model you built while implementing.

- **A new algorithm or process gets a worked example, aimed at the path that isn't obvious.**
  A model the reader can't run is one they can't check; a trace turns "I think I follow" into a prediction they confirm.

- **A before-state goes in only where it doesn't follow from the after.**
  "X now spills" makes "X didn't spill before" surplus; a before that was erratic — data-dependent, version-dependent — is not the negation of the after, and stays.

- **The order of the sections carries the arc, and needs no closing summary.**
  Each section leans only on those above it; where it does, the reader arrives at the inherited costs already holding what they are costs of.

**Before handing it to `weed-pr`, ask what the reader will ask first, and answer it in place.**
A question a reader asks after reading is a gap the description had; the cheapest place to find it is before they do.

Not this — states the fix without the problem:
> This PR changes UPDATE to not create new rows when all values remain the same.

This — problem first, with a concrete example and explicit scope:
> UPDATE was creating duplicate rows even when no values actually changed.
> Uses type-strict equality — `UPDATE docs SET a = 1.0 WHERE _id = 1` on a doc with `{:a 1}` *will* create a new record because `1 ≠ 1.0`.
> PATCH is out of scope of this PR (see #5030).

## Weed the draft

Write the drafted description to a file and **delegate to the `weed-pr` agent**, passing the path, the base branch, and the linked issue if there is one.
It reads the description cold, as the reviewer, attempts the reviewer's job from it, and reports where it gets stuck.

**Pass the linked issue as a file, written verbatim** (`gh issue view <n> --json body -q .body`), with no summary, no annotation and no comments.
A body you have described rather than copied tells the agent what you think the issue says, which is the session leaking in through the one input that was meant to keep it out.

- **You MUST NOT give it the session, the plan or the branch's commit bodies.**
  It holds what the reviewer holds: the base branch, the diff, the linked issue and the description.
  The author can't see what the description leaves out, because the author holds the theory it was meant to carry.

- **Where there is no linked issue, say so**, so it reads the description as carrying the problem too.

**Its questions are for you to answer in the description, not to judge.**
That judgement is made by the context that just spent the session building the theory, and it always comes back confident.

- **A question MUST be closed by adding what answers it.**
  **You MUST NOT close one by deciding it doesn't apply.**
  A node it couldn't decide on is closed by restructuring that node.

- **Where only the user can answer, relay the question as written.**
  Answer from the branch where the branch genuinely has it, naming the commit you draw on so the user can correct you.

- **The redraft MUST go back to `weed-pr`**, until it has no question left that it would ask before approving.
  You MUST NOT judge your own redraft.

## Opening it

**Delegate to the chalk github agent.**

- Push the branch if needed.

- Pass the title and the fully-drafted description, ready to post verbatim.

- Pass any project-specific PR conventions in your context verbatim — default reviewers, labels, base branch, draft status, project boards — and let the agent apply them alongside its own defaults.
  They typically live in the project's `CLAUDE.md` or in explicit user instructions for this session.

- The agent assigns the current user by default. Tell it to skip assignment only if the user has asked you to.
