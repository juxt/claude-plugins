---
name: commit
description: Create a commit with a contextual body explaining the why, in the chalk voice. Use when the user says "commit this", "commit", "make a commit", "/chalk:commit"; OR is about to compose, draft, write or amend any git commit message body (e.g. "write a commit message", "draft the commit body", "amend the commit message"). Load this skill BEFORE drafting any such prose — it carries the voice guidance the commit body needs.
user-invocable: true
disable-model-invocation: false
---

# Contextual Git Commit

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

The user will provide the commit headline as an argument to this command (e.g., `/commit fix: boolean logic error in expression.clj`).

## Your Responsibilities

1. **Stage relevant changes**:
   - Review unstaged changes and stage files related to this commit
   - Only stage changes that belong together logically — don't bundle unrelated work
   - Each commit is an atomic unit of change: a transition from one valid state to another
   - If two changes don't make sense independently, they're one commit; if they're distinct, they're two commits
   - Keep unrelated bugfixes separate so they can be merged independently
   - Where reasonable, separate behaviour-preserving changes (refactorings) from behaviour-advancing changes — it's much easier to review a change knowing it's supposed to behave exactly the same as before

2. **Review the conversation history** to extract the reasoning behind the change.
   Optimise for later reading — a future developer looking at this commit won't care about the journey, they need to understand *why* this change exists and *why* it was done this way.
   Consider what you'd explain to that developer and organise the commit accordingly.

3. **Draft a commit body.**

   A commit body is an **explanation** artefact (see `VOICE.md` at the plugin root).
   The diff is the code change; the body explains *why* it exists — decisions, alternatives rejected, constraints, dead ends, counter-intuitive findings, scope boundaries.
   Open with the problem or context, then the reasoning.
   Embed concrete examples (code snippets, call sites, specific scenarios) as illustrative material.

4. **Ask clarifying questions** if you can't reconstruct the *why* from the conversation history — particularly around whether something was a deliberate choice vs. a constraint, or intentionally out-of-scope vs. overlooked.

5. **Make the commit** directly with the commit body you've drafted:
   - Use the user's provided headline as the first line
   - Add a blank line
   - Add your drafted commit body
   - The user will review the commit message in the Bash tool request before approving

## Issue References in the Subject Line

When the work relates to a GitHub issue:

- If the commit **resolves** the issue, suffix the subject line with `(resolves #N)`.
- If the commit is an **iteration towards** resolving the issue (partial progress), suffix the subject line with `(#N)`.

## Chalk Integration

When chalk is active (tracking a GitHub issue), the commit is part of a larger story:

- **Reference the issue** in the commit body footer (e.g., `Refs #123`) so the commit links back to the issue context.
- **Draw on the session context**: the chalk issue and comments capture the broader intent — use that to write a richer commit body.
  You have the full conversation history; the chalk comment captures what was planned and why.
  The commit body should stand alone but benefit from that context.
- **After committing**, update the chalk comment with the outcome directly — don't ask first.
  Chalk updates are part of the work, not an optional extra step requiring permission.
  A one-line nudge to the user after the update is fine; a question isn't.

## Constraints

- The commit body MUST follow the explanation-quadrant voice in `VOICE.md`.
- Each commit MUST be an atomic, cohesive unit of change.
- Unrelated changes MUST NOT be staged together.
- The commit body MUST NOT describe what changed — the diff shows that.
- A co-author header SHOULD be included (replacing the model as appropriate):
  ```
  Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
  ```

## Workflow

1. Parse the commit headline from the command arguments
2. Review changes and stage relevant files (only those related to this commit)
3. Review the session to extract salient context
4. Draft the commit body
5. Ask any clarifying questions if needed
6. Make the commit with git commit (the user will review the commit message in the Bash tool request)
