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

**A PR description states what is now true, and hands the change over rather than arguing for it**; it freezes at merge, per the palette.

**What it hands over is the author's theory of the change** — what the change is for, why each part is the way it is, and what would break if it changed (Naur, *Programming as Theory Building*).
The code is a lossy projection of that theory: a reader can rebuild it from the diff, at far more cost and less faithfully than by reading it.
Where the author worked in a session nobody watched — a background agent, a long run — the description is the only place the theory reaches a human.

## Your readers

`chalk:voice` says who they are; here they are doing one of three things.

- **Reader 0 is the reviewer, who has to own the change once it merges.**
  They review it commit by commit, and afterwards they maintain it, debug it and defend it.
  They hold the diff, so argument where they could just look reads as something you couldn't show; what they can't look at is the theory.
  **Success — the bus test:** holding only the description and what it links, they can explain the change to a teammate, predict its behaviour in a case the description doesn't mention, and notice when a later change breaks an invariant it relies on.

- **Reader 1 is a peer updating their mental model**, now.
  They need the delta, and above all **the belief they hold that no longer holds**.
  A PR is the moment the rest of the team learns the change exists, so their first question is whether it affects them.
  **Success:** the reader can tell how this affects their work, and what they believe about the system afterwards is true.

- **Reader 2 is the same person in a year**, asking why one aspect of this mattered.
  **Success:** they don't accidentally revert it, and they don't rehash from scratch a decision this description already settled.

## Which path

- **Resolves an issue** — the palette's `issue + PR` mode.
  Reference it at the top: `Resolves #N` where merging it finishes the issue, `Part of #N` where the issue stays open afterwards. What this adds is the theory as built: the model, how the problem shaped it, the decisions, the trade-offs, the dead ends.

  **tl;dr → What changes → Usage / migration → Reviewing this → Consequences → Out of scope → Alternative approaches → Open questions**

- **Standalone** — the palette's `standalone PR` mode: there is no issue, so this description carries the problem itself.
  **The first line MUST state what and why** — the line that would have been a reference has to do the issue's opening job instead.
  A *why now* belongs there only where the session has one; you MUST NOT invent one.

  - **fixing a bug** — **tl;dr → Symptoms → Root cause → What changes → Usage / migration → Reviewing this → Consequences → Alternative approaches (optional) → Open questions**

  - **adding a feature** — **tl;dr → Problem → What changes → Usage / migration → Reviewing this → Consequences → Out of scope → Alternative approaches → Open questions**

Each section's content is in the palette, and not every change needs every section — but where a section appears, this is its position.

## Before you draft

Load, via the Skill tool:

- **`chalk:voice`** — the register, the audience, the mindmap shape, the line-format rule.

- **`chalk:voice`'s `references/palette.md`** — the sections on your path.

- **`chalk:chalk`** — the plan file's shape and the journal's record kinds, which the description is written from.

**Write each section as a mindmap**, per `chalk:voice`.
Reader 0 is working through the change in the order it can be checked, reader 1 is scanning for what touches their work, and reader 2 for one decision, so all three skip most of the body: every subject line MUST let them discard the bullet against that goal, or take it unread.
**The skill is in helping the reader see quickly what they can skip**, not in making the body short: depth below a subject line costs a skipping reader almost nothing, and a missing model sentence costs every reviewer the rebuild.

**The body MUST open with a tl;dr**, per `chalk:voice` — the summary sentence, then the mindmap, with no heading over it.
The first `##` in the body is the section after it.

## Gather the context

- Review the commits on this branch — all of them, not just the latest.

- Read the session's plan journal, all of it, where `chalk:chalk` started one.
  It's material, not a draft: what reaches the description is what *Your readers* and the palette call for — a decision because it matters to them, whoever made it.
  Its `review:` entries: their durable part is already in the commit bodies, and Reviewing this takes from them only what spans commits, and the evidence.

- Review the conversation history for context that isn't in the commits or the plan.

- Where there is a linked issue, have the github agent fetch its description and comments.

- Identify the base branch.

## Correct the issue

**Before you draft the description, correct the linked issue** wherever the work contradicted something it asserted.
A confident, wrong problem statement with a PR that silently disagrees is worse for the later reader than either alone.

Do it first because the description is drafted against the issue and passed to `weed-pr` beside it: a stale issue makes the description either repeat the error or look as though it contradicts the problem.
Where there is no linked issue, there is nothing to correct and this step is empty.

**Where the work answers one of the issue's open questions, move the answer onto the issue**, through `chalk:issue`, per the palette's Open questions; the description cites the issue rather than answering it in a section of its own.
The issue outlives the PR as the problem's living record, and a "Part of" PR leaves the issue open with its questions still reading as live.

## Draft the title

The user MAY pass one as an argument (`/chalk:pr feat: read-only secondaries`); use it if they did.
Otherwise draft one from the branch's commits that captures the intent rather than the mechanism.

**Success: a reader recognises the change from the title alone**, without opening the PR.
Reader 1 scans a list of merged PRs for the one that touched their area, and reader 2 searches it a year later.

- **State the delta: "X no longer Ys", "X now Zs".**
  This is the accomplished form of the issue title's `should`, and it disambiguates the same way — "leader election in the replica log" doesn't say which side of the change this PR is on.

## Draft the description

**It MUST NOT just list what changed — the diff shows that.**
It is the theory distilled across the branch.

**The test for a sentence is whether a reader holding only the diff would arrive at it cheaply — not whether the diff contains it.**
"Each group's ranks are offsets into the sorted stream" is derivable from a diff, at the cost of reconstructing the algorithm; it stays.
"`aggregate` now calls `append`" is read off the diff at a glance; it goes.

**Open one or two levels of abstraction above the work**, per `chalk:voice`'s hourglass.

**Teach the mental model the change assumes, before any type name.**
State the model in a sentence, then descend: the mechanism, then the decisions inside it, then the specifics.
Name what would surprise someone familiar with the subsystem, and don't assume the reader holds the model you built while implementing.

- **A new algorithm or process gets a worked example, aimed at the path that isn't obvious.**
  A model the reader can't run is one they can't check; a trace turns "I think I follow" into a prediction they confirm.

**Before handing it to `weed-pr`, ask what the reader will ask first, and answer it in place**, and check every `→` reads as "therefore".

Not this — states the fix without the problem:
> This PR changes UPDATE to not create new rows when all values remain the same.

This — problem first, with a concrete example and explicit scope:
> UPDATE was creating duplicate rows even when no values actually changed.
> Uses type-strict equality — `UPDATE docs SET a = 1.0 WHERE _id = 1` on a doc with `{:a 1}` *will* create a new record because `1 ≠ 1.0`.
> PATCH is out of scope of this PR (see #5030).

## Weed the draft

**Delegate to the `weed-pr` agent** as the caller's side of `chalk:voice`'s `references/cold-read.md` sets out, passing the description's path, the base branch, and the linked issue if there is one.
It reads the description cold, as the reviewer, attempts the reviewer's job from it, and reports where it gets stuck.

- **Where there is no linked issue, say so**, so it reads the description as carrying the problem too.

- **Where only the user can answer, answer from the branch where the branch genuinely has it**, naming the commit you draw on so the user can correct you.
  In secondary, per `chalk:secondary`: one the branch can't answer goes into Open questions, marked for the user.

**Delegate the branch's commit messages to the `weed-commits` agent beside it**, per `chalk:commit`, passing the base branch and the head.

- **Apply its findings by rewording each commit through `chalk:commit`**, a rewrite of the branch, per `chalk:chalk`'s Feature branches.

- **Update the journal entries keyed by any subject that changed**, so they still name the commit.

- **The reworded commits go back to `weed-commits`**, until it has no question left.

## Opening it

**The PR opens only after both the description and the branch's commit messages are weeded**, each until its agent has no question left; neither weed stands in for the other.

**Delegate to the chalk github agent.**

- Push the branch if needed.

- Pass the title and the fully-drafted description, ready to post verbatim.

- Pass any project-specific PR conventions in your context verbatim — default reviewers, labels, base branch, draft status, project boards — and let the agent apply them alongside its own defaults.
  They typically live in the project's `CLAUDE.md` or in explicit user instructions for this session.

- The agent assigns the current user by default. Tell it to skip assignment only if the user has asked you to.

**The finish doesn't end while a blocking question on the PR is unsettled**; in secondary, one marked for the user is left open on the PR, and the finish ends.
