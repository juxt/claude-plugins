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

3. **Draft a PR description** following the chalk voice (see `VOICE.md` at the plugin root):
   - **Lead with the problem or context** — why does this change exist? What situation motivated it?
   - **Explain the approach and key decisions** — not what the diff does, but why it's shaped this way. Include tradeoffs, alternatives considered, and anything counter-intuitive.
   - **Use concrete examples** — scenarios, code snippets, data — to ground the reasoning. If a concept is new or reshaped, explain the mental model.
   - **Note dead ends** if they'd save a reviewer time — "we tried X, it didn't work because Y" prevents the reviewer from suggesting X.
   - **State scope boundaries** — what's explicitly out of scope, and what's a natural follow-on. Reference related issues/PRs.
   - **When the reasoning is complex but the change is simple**, say so — helps the reviewer calibrate before looking at the diff.

4. **Ask clarifying questions** if you can't reconstruct the reasoning from the commits and conversation history.

5. **Delegate to the chalk github agent** to create the PR:
   - Push the branch if needed
   - Pass the title and description to the agent
   - The agent handles the platform-specific mechanics

## Chalk Integration

When chalk is tracking an issue:

- The PR description SHOULD reference the issue (e.g., `Resolves #123` or `Part of #123`).
- The chalk comments are the primary source material for the PR description. They capture the decisions, tradeoffs, dead ends, and scope boundaries from each session. Review all of them — not just the most recent.
- Distil, don't copy. The PR description should synthesise the reasoning across sessions into a coherent narrative. Chalk comments are append-only session logs; the PR description is the polished summary for a reviewer.

## Constraints

- The PR description MUST follow the chalk voice (`VOICE.md`).
- The PR description MUST NOT just list what changed — the diff shows that.
- The PR description MUST use sentence-per-line formatting.
- The PR title MUST be under 70 characters.
- Behaviour-preserving changes (refactorings) SHOULD be called out explicitly so the reviewer knows the change is supposed to behave exactly the same as before.

## Workflow

1. Parse the PR title from the command arguments (if provided)
2. Review all commits on the branch and the conversation history
3. Draft the PR title and description
4. Ask any clarifying questions if needed
5. Push the branch if not already pushed
6. Delegate to the chalk github agent to create the PR (the user will review the description before approving)
