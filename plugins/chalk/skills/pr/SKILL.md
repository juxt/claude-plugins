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

## Your readers

`chalk:voice` says who they are; here they are doing one of two things, and **neither of them is a gate**.
A PR does get approved, but the approver is not who you write for: they hold the diff, so argument where they could just look reads as something you couldn't show.

- **Reader 1 is a peer updating their mental model**, now.
  They need the delta, and above all **the belief they hold that no longer holds**.
  A PR is the moment the rest of the team learns the change exists, so their first question is whether it affects them.
  **Success:** the reader can tell how this affects their work, and what they believe about the system afterwards is true - the understanding is conveyed accurately and concisely.

- **Reader 2 is the same person in a year**, asking why one aspect of this mattered.
  **Success:** they don't accidentally revert it, and they don't rehash from scratch a decision this description already settled.

## Which path

- **Resolves an issue** — the issue carries the problem, so this description MUST NOT restate it.
  Reference it at the top (`Resolves #N`, or `Part of #N`) and assume the reader has read it. What this adds is how the problem shaped the implementation: the approach, the decisions, the trade-offs, the dead ends.

  **tl;dr → What changes → Usage / migration → Consequences → Out of scope → Alternative approaches → Open questions**

- **Standalone** — there is no issue, so this description carries the problem itself, acting as both.
  **The first line MUST state what, why and why now** — the line that would have been a reference has to do the issue's opening job instead.
  **This is the path that leads with the problem.** On the other one, leading with the problem is the duplication the pairing exists to prevent.
  It inserts the problem sections, and only those: the rest of the issue side is design-space or forward-looking material, and a PR is retrospective.

  - **fixing a bug** — **tl;dr → Symptoms → Root cause → What changes → Usage / migration → Consequences → Alternative approaches (optional) → Open questions**
  - **adding a feature** — **tl;dr → Problem → What changes → Usage / migration → Consequences → Out of scope → Alternative approaches → Open questions**

Each section's content is in the palette, and not every change needs every section — but where a section appears, this is its position.

## Before you draft

A PR description is an **explanation** artefact, and it MUST be drafted against the chalk voice.
Load, via the Skill tool:

- **`chalk:voice`** — the register, the audience, the mindmap shape, the line-format rule.
- **`chalk:voice`'s `references/palette.md`** — the sections on your path. Not every change needs every section.

**Write each section as a mindmap** — a short tl;dr opening it, then the tree.
A wall of undifferentiated prose means this step was skipped.

## Gather the context

- Review the commits on this branch — all of them, not just the latest.
- Review the conversation history for context that isn't in the commits.
- Where there is a linked issue, read its description and comments via the github agent.
- Identify the base branch.

**Correct the issue before opening the PR** where the work contradicted something it asserted.
A confident, wrong problem statement with a PR that silently disagrees is worse for the later reader than either alone.

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
It is the reasoning distilled across the branch. 
Usage examples and commit lists have a reference *shape*, but they are illustrations inside the explanation.

**Teach the mental model the change assumes.**
Name what would surprise someone familiar with the subsystem, and don't assume the reader holds the model you built while implementing.

Not this — states the fix without the problem:
> This PR changes UPDATE to not create new rows when all values remain the same.

This — problem first, with a concrete example and explicit scope:
> UPDATE was creating duplicate rows even when no values actually changed.
> Uses type-strict equality — `UPDATE docs SET a = 1.0 WHERE _id = 1` on a doc with `{:a 1}` *will* create a new record because `1 ≠ 1.0`.
> PATCH is out of scope of this PR (see #5030).

## Weed the draft

Write the drafted description to a file and **delegate to the `weed-prose` agent**, naming the artefact as a PR description and passing the path, the base branch, and the linked issue number if there is one.

- **You MUST NOT give it the session or the branch's commit bodies.**
  It holds the branch diff and the linked issue — what the later reader can reach, and nothing they can't.
- **Passing the issue is what lets it cut duplication.**
  Without the issue, repeated problem context reads as necessary; with it, the cut is obvious and the link does the work.
- **Where there is no linked issue, say so.**
  It will otherwise strip the problem context a standalone PR is required to carry, and it checks the first line for what, why and why now instead.
- **Its cuts apply; its Gaps are questions for you**, and it MUST NOT invent an answer to one.

**Put the gaps to the user.**
Not "ask if you're unsure" — that judgement is made by the context that just spent the session building the reasoning, and it always comes back confident.
`weed-prose` has already decided, from the draft alone, which questions the description fails to answer.

- **A gap MUST be closed by adding a sentence that answers it, and the redraft MUST go back to `weed-prose`.**
  **You MUST NOT close a gap by deciding it doesn't apply**, and you MUST NOT judge your own redraft — the agent that raised the gap is the one that closes it. 
  Loop until it reports no blocking gaps.
- **Relay each question as written.** Composing your own is where the ask gets dropped.
- **A `blocking` gap — a missing *why now*, or a standalone PR whose first line doesn't state what, why and why now — MUST be resolved before you open the PR.**
- **Answer from the branch where the branch genuinely has it**, naming the commit you are drawing on so the user can correct you. Where it doesn't, ask.

## Opening it

**Delegate to the chalk github agent.**

- Push the branch if needed.
- Pass the title and the fully-drafted description, ready to post verbatim.
- Pass any project-specific PR conventions in your context verbatim — default reviewers, labels, base branch, draft status, project boards — and let the agent apply them alongside its own defaults.
  They typically live in the project's `CLAUDE.md` or in explicit user instructions for this session.
- The agent assigns the current user by default. Tell it to skip assignment only if the user has asked you to.
