---
name: pr
description: Create a pull request with a description that captures the intent and reasoning behind the change, in the chalk voice. Use when the user says "create a PR", "open a PR", "submit a PR", "raise a PR", "make a PR", "PR this", "/chalk:pr"; OR is about to compose, draft, write or update any pull request title or body (e.g. "write a PR description", "draft the PR body", "update the PR description", "let's put that in the PR"). Load this skill BEFORE drafting any such prose — it carries the voice guidance the PR body needs.
user-invocable: true
disable-model-invocation: false
---

# Pull Request

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

The user MAY provide a PR title as an argument (e.g., `/chalk:pr feat: read-only secondaries`).
If no title is provided, draft one from the branch's commits.

## Before you draft

A PR description is an **explanation** artefact, and it MUST be drafted against the chalk voice — not your own default prose habits, which read wrong and lose the reasoning the reviewer needs.

`chalk:pr` loads on its own and does **not** pull the shared voice into context.
Before drafting the description, **load the `chalk:voice` skill** (via the Skill tool) — it carries the Diataxis framing, the universal principles, and the issue/PR section palette.
Then **structure the description into sections drawn from that palette**, choosing the ones this change needs.
A wall of undifferentiated prose is the wrong shape; if you've written one, you skipped this step.

**Line format: paragraph-per-line.**
A PR description is read rendered on GitHub, never as a `git diff`.
GitHub renders single newlines as `<br>`, so sentence-per-line fragments into staccato — put each paragraph on a single line, separate paragraphs with a blank line, and let the rendering wrap.

## Your Responsibilities

1. **Gather context**:
   - Review the commits on this branch (all of them, not just the latest)
   - Review the conversation history for context that isn't in the commits
   - If chalk is active, read all chalk comments on the tracked issue via the github agent — these are the richest source of reasoning, decisions, dead ends, and scope boundaries. Distil them into the PR description rather than duplicating them verbatim.
   - Identify the base branch (usually `main` or `master`)

2. **Draft a PR title**:
   - Use the user's provided title if given
   - Otherwise, draft a short title that captures the intent

3. **Draft a PR description.**

   A PR description is an **explanation** artefact (see the `chalk:voice` skill) — reasoning distilled across the branch: context, decisions, tradeoffs, dead ends, scope boundaries.
   Usage examples, test-plan checklists and commit lists have a reference *shape* but they're illustrations inside the explanation, not separate reference sections.

   Draw the sections from the palette in the `chalk:voice` skill you loaded in **Before you draft** above — don't default to flat prose.

   **Issue references come first.**
   If there's a related issue, reference it at the top (`Resolves #123` or `Part of #123`).
   The issue description is where the problem context lives — don't duplicate it in the PR.
   The PR description covers how the issue affected the implementation: approach, decisions, trade-offs, dead ends.

   If there is no related issue (unusual but possible), the PR description MUST include the problem context itself — effectively acting as both issue and PR description.

   **A PR is knowledge sharing with the team.**
   It's the moment the rest of the team learns this change exists and how to work with it.
   So if *using* the new functionality requires any manual steps a teammate has to take themselves — running a migration, setting a config value or env var, enabling a flag, regenerating something, a deploy-order constraint — those steps MUST be documented in the PR body (the **Usage** section is the natural home).
   Don't assume the steps are obvious or that they live somewhere else: if a reader can't act on the change without a step that isn't in the diff, the step belongs in the description.

4. **Ask clarifying questions** if you can't reconstruct the reasoning from the commits and conversation history.

5. **Delegate to the chalk github agent** to create the PR:
   - Push the branch if needed
   - Pass the title and description to the agent
   - Pass any project-specific PR conventions relevant to this operation — default reviewers, labels, base branch, draft status, project boards — that you can see in your current context (typically the project's `CLAUDE.md` or explicit user instructions for this session). Include them verbatim; let the agent apply them alongside its defaults.
   - The agent handles the platform-specific mechanics — including assigning the current user by default (opening a PR is the signal that you own the review cycle). Tell the agent to skip assignment only if the user has asked you to.

## Chalk Integration

When chalk is tracking an issue:

- The chalk comments are the primary source material for the PR description. They capture the decisions, tradeoffs, dead ends, and scope boundaries from each session. Review all of them — not just the most recent.
- Distil, don't copy. The PR description should synthesise the reasoning across sessions into a coherent narrative. Chalk comments are append-only session logs; the PR description is the polished summary for a reviewer.

## Constraints

- The PR description MUST follow the explanation-quadrant voice in the `chalk:voice` skill.
- The PR description MUST NOT just list what changed — the diff shows that.
- Behaviour-preserving changes (refactorings) SHOULD be called out explicitly so the reviewer knows the change is supposed to behave exactly the same as before.

## Workflow

1. Parse the PR title from the command arguments (if provided)
2. Review all commits on the branch and the conversation history
3. Draft the PR title and description
4. Ask any clarifying questions if needed
5. Push the branch if not already pushed
6. Delegate to the chalk github agent to create the PR (the user will review the description before approving)
