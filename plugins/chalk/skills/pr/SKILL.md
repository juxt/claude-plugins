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

- **`chalk:voice`**, and its **`references/palette.md`** — the principles, the section palette, the line-format rule.
- **`chalk:mindmap`** — the shape of the content inside each section.
- **`chalk:goal-tree`**, where a section states what the work has to *achieve* rather than what it did — a Future state section, or the remaining steps of a change landing in pieces.
  A PR's Implementation section is retrospective ("what landed") and doesn't want one.

**Structure the description into sections drawn from the palette**, choosing the ones this change needs, and **write each section as a mindmap** — a short tl;dr opening it, then the tree.
A wall of undifferentiated prose is the wrong shape; if you've written one, you skipped this step.

**Your audience is a reviewer about to read the diff, who didn't see the branch and hasn't yet opened the linked issue, but can.**
A PR is the moment the rest of the team learns the change exists, and that reviewer is deciding two things: whether this affects them, and whether the approach holds.
Write the summary for them — see "Name your audience" in `chalk:voice`, and the tl;dr rules in `chalk:mindmap`.

## Your responsibilities

1. **Gather context.**

   - Review the commits on this branch — all of them, not just the latest.
   - Review the conversation history for context that isn't in the commits.
   - If chalk is active, read all chalk comments on the tracked issue via the github agent.
   - Identify the base branch.

2. **Draft a title** — the user's if given, otherwise a short one that captures the intent.

3. **Draft the description.**

   **It MUST NOT just list what changed — the diff shows that.**
   It's reasoning distilled across the branch: context, decisions, tradeoffs, dead ends, scope boundaries. Usage examples, test-plan checklists and commit lists have a reference *shape* but they're illustrations inside the explanation, not separate sections.

   **Issue references come first.**
   If there's a related issue, reference it at the top (`Resolves #123` or `Part of #123`). The issue description is where the problem context lives — don't duplicate it. The PR covers how the issue affected the implementation: approach, decisions, trade-offs, dead ends.
   If there is no related issue, the description MUST carry the problem context itself, acting as both issue and PR description.

   **Manual adoption steps MUST be documented here.**
   If *using* the new functionality requires a teammate to run a migration, set a config value or env var, enable a flag, regenerate something, or observe a deploy-order constraint, those steps go in the **Usage** section.

   **Behaviour-preserving changes SHOULD be called out explicitly.**

4. **Ask clarifying questions** if you can't reconstruct the reasoning from the commits and conversation history.

5. **Delegate to the chalk github agent** to create the PR.

   - Push the branch if needed.
   - Pass the title and the fully-drafted description, ready to post verbatim.
   - Pass any project-specific PR conventions you can see in your current context — default reviewers, labels, base branch, draft status, project boards — verbatim, and let the agent apply them alongside its defaults. They typically live in the project's `CLAUDE.md` or explicit user instructions for this session.
   - The agent assigns the current user by default. Tell it to skip assignment only if the user has asked you to.

## Chalk integration

When chalk is tracking an issue, the chalk comments are the primary source material.
Review all of them, not just the most recent.

**Distil, don't copy.**
Chalk comments are append-only session logs; the PR description synthesises the reasoning across sessions into a coherent narrative for a reviewer.
