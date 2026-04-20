---
name: pr
description: Create a pull request with a description that captures the intent and reasoning behind the change. Use when the user says "create a PR", "open a PR", "submit a PR", "raise a PR", "make a PR", "PR this", or "/chalk:pr".
user-invocable: true
disable-model-invocation: false
---

# Pull Request

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

The user MAY provide a PR title as an argument (e.g., `/chalk:pr feat: read-only secondaries`).
If no title is provided, draft one from the branch's commits.

## Your Responsibilities

1. **Gather context**:
   - Review the commits on this branch (all of them, not just the latest)
   - Review the conversation history for context that isn't in the commits
   - If chalk is active, read all chalk comments on the tracked issue via the github agent — these are the richest source of reasoning, decisions, dead ends, and scope boundaries. Distil them into the PR description rather than duplicating them verbatim.
   - Identify the base branch (usually `main` or `master`)

2. **Draft a PR title**:
   - Use the user's provided title if given
   - Otherwise, draft a short title (under 70 chars) that captures the intent

3. **Draft a PR description.**

   A PR description is an **explanation** artefact (see `VOICE.md` at the plugin root) — reasoning distilled across the branch: context, decisions, tradeoffs, dead ends, scope boundaries.
   Usage examples, test-plan checklists and commit lists have a reference *shape* but they're illustrations inside the explanation, not separate reference sections.

   See the chalk skill's "Writing issue and PR descriptions" section for the section palette you can draw from.

   **Issue references come first.**
   If there's a related issue, reference it at the top (`Resolves #123` or `Part of #123`).
   The issue description is where the problem context lives — don't duplicate it in the PR.
   The PR description covers how the issue affected the implementation: approach, decisions, trade-offs, dead ends.

   If there is no related issue (unusual but possible), the PR description MUST include the problem context itself — effectively acting as both issue and PR description.

4. **Ask clarifying questions** if you can't reconstruct the reasoning from the commits and conversation history.

5. **Delegate to the chalk github agent** to create the PR:
   - Push the branch if needed
   - Pass the title and description to the agent
   - The agent handles the platform-specific mechanics — including assigning the current user by default (opening a PR is the signal that you own the review cycle). Tell the agent to skip assignment only if the user has asked you to.

## Chalk Integration

When chalk is tracking an issue:

- The chalk comments are the primary source material for the PR description. They capture the decisions, tradeoffs, dead ends, and scope boundaries from each session. Review all of them — not just the most recent.
- Distil, don't copy. The PR description should synthesise the reasoning across sessions into a coherent narrative. Chalk comments are append-only session logs; the PR description is the polished summary for a reviewer.

## Constraints

- The PR description MUST follow the explanation-quadrant voice in `VOICE.md`.
- The PR description MUST NOT just list what changed — the diff shows that.
- The PR title MUST be under 70 characters.
- Behaviour-preserving changes (refactorings) SHOULD be called out explicitly so the reviewer knows the change is supposed to behave exactly the same as before.

## Workflow

1. Parse the PR title from the command arguments (if provided)
2. Review all commits on the branch and the conversation history
3. Draft the PR title and description
4. Ask any clarifying questions if needed
5. Push the branch if not already pushed
6. Delegate to the chalk github agent to create the PR (the user will review the description before approving)
