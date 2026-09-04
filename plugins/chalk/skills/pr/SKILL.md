---
name: pr
description: Create a pull request with a description that captures the intent and reasoning behind the change, in the chalk voice. Use when the user says "create a PR", "open a PR", "submit a PR", "raise a PR", "make a PR", "PR this", "/chalk:pr"; OR is about to compose, draft, write or update any pull request title or body (e.g. "write a PR description", "draft the PR body", "update the PR description", "let's put that in the PR"). Load this skill BEFORE drafting any such prose — it carries the voice guidance the PR body needs.
user-invocable: true
disable-model-invocation: false
---

# Pull Request

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

The user MAY provide a PR title as an argument (e.g. `/chalk:pr feat: read-only secondaries`).
If no title is provided, draft one from the branch's commits.

## Before you draft

A PR description is an **explanation** artefact, and it MUST be drafted against the chalk voice.
Load these first (via the Skill tool):

- **`chalk:voice`**, and its **`references/palette.md`** — the audience, the specification register, the mindmap structure each section takes, the section palette, the line-format rule.
- **`chalk:goal-tree`**, where a section states what the work has to *achieve* rather than what it did — a Future state section, or the remaining steps of a change landing in pieces.
  A PR's Implementation section is retrospective ("what landed") and doesn't want one.

**Structure the description into sections drawn from the palette**, choosing the ones this change needs, and **write each section as a mindmap** — a short tl;dr opening it, then the tree.
A wall of undifferentiated prose is the wrong shape; if you've written one, you skipped this step.

**Your audience is a reviewer about to read the diff, who didn't see the branch and hasn't yet opened the linked issue, but can.**
A PR is the moment the rest of the team learns the change exists, and that reviewer is deciding two things: whether this affects them, and whether the approach holds.
Write the tl;dr for them — the palette's first section, and the audience rules in `chalk:voice`.

## Your responsibilities

1. **Gather context.**

   - Review the commits on this branch — all of them, not just the latest.
   - Review the conversation history for context that isn't in the commits.
   - Where there's a linked issue, read its description and comments via the github agent.
   - Identify the base branch.

2. **Draft a title** — the user's if given, otherwise a short one that captures the intent.

3. **Draft the description.**

   **It MUST NOT just list what changed — the diff shows that.**
   It's reasoning distilled across the branch: context, decisions, tradeoffs, dead ends, scope boundaries. Usage examples, test-plan checklists and commit lists have a reference *shape* but they're illustrations inside the explanation, not separate sections.

   **Teach the mental model the change assumes, and lead with the problem.**
   Your reader is updating their model of how the system works, so name what surprised you, or would surprise someone familiar with the subsystem — and don't assume they hold the model you built while implementing.

   Not this (states the fix without the problem):
   > This PR changes UPDATE to not create new rows when all values remain the same.

   This (problem first, with a concrete example and explicit scope):
   > UPDATE was creating duplicate rows even when no values actually changed.
   > Uses type-strict equality — `UPDATE docs SET a = 1.0 WHERE _id = 1` on a doc with `{:a 1}` *will* create a new record because `1 ≠ 1.0`.
   > PATCH is out of scope of this PR (see #5030).

   **Issue references come first.**
   If there's a related issue, reference it at the top (`Resolves #123` or `Part of #123`). The issue description is where the problem context lives — don't duplicate it. The PR covers how the issue affected the implementation: approach, decisions, trade-offs, dead ends.
   If there is no related issue, the description MUST carry the problem context itself, acting as both issue and PR description.
   **Then the first line MUST state what, why and why now** — there is no issue for the reader to open, so the line that would have been a reference has to do the issue's opening job instead.

   **Manual adoption steps MUST be documented here.**
   If *using* the new functionality requires a teammate to run a migration, set a config value or env var, enable a flag, regenerate something, or observe a deploy-order constraint, those steps go in the **Usage** section.

   **Behaviour-preserving changes SHOULD be called out explicitly.**

   **What the change left unanswered goes in Open questions**, tagged `Q<n>`.
   A decision the branch deferred, a measurement not taken, a hypothesis the tests don't settle. Distinct from **Out of scope**, which records a decision that something is excluded; this records the absence of one.

4. **Weed the draft.**

   Write the drafted description to a file and **delegate to the `weed-prose` agent**, naming the artefact as a PR description and passing the path, the base branch, and the linked issue number if there is one.

   - **You MUST NOT give it the session or the branch's commit bodies.** It holds the branch diff and the linked issue — what the later reader can reach, and nothing they can't.
   - **Passing the issue is what lets it cut duplication.** Without the issue, repeated problem context reads as necessary; with it, the cut is obvious and the link does the work.
   - **Where there is no linked issue, say so.** It will otherwise strip the problem context this PR is required to carry, and it checks the first line for what, why and why now instead.
   - **Its cuts apply; its Gaps are questions for you**, and it MUST NOT invent an answer to one.

5. **Put `weed-prose`'s gaps to the user.**

   Not "ask if you're unsure" — that is a judgement made by the context that just spent the session building the reasoning, and it always comes back confident. `weed-prose` has already decided, from the draft alone, which questions the description fails to answer.

   - **A gap MUST be closed by adding a sentence that answers it, and the redraft MUST go back to `weed-prose`.** **You MUST NOT close a gap by deciding it doesn't apply**, and you MUST NOT judge your own redraft — the agent that raised the gap is the one that closes it. Loop until it reports no blocking gaps.
   - **Relay each question as written.** Composing your own is where the ask gets dropped.
   - **A `blocking` gap — a missing *why now*, or a first line that doesn't state what, why and why now on an issue-less PR — MUST be resolved before you open the PR.**
   - **Answer from the branch where the branch genuinely has it**, and say which commit you're drawing on so the user can correct you. Where it doesn't, ask.

6. **Delegate to the chalk github agent** to create the PR.

   - Push the branch if needed.
   - Pass the title and the fully-drafted description, ready to post verbatim.
   - Pass any project-specific PR conventions you can see in your current context — default reviewers, labels, base branch, draft status, project boards — verbatim, and let the agent apply them alongside its defaults. They typically live in the project's `CLAUDE.md` or explicit user instructions for this session.
   - The agent assigns the current user by default. Tell it to skip assignment only if the user has asked you to.
