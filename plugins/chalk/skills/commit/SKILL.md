---
name: commit
description: Create a commit with a contextual body explaining the why, in the chalk voice. Use when the user says "commit this", "commit", "make a commit", "/chalk:commit"; OR is about to compose, draft, write or amend any git commit message body (e.g. "write a commit message", "draft the commit body", "amend the commit message"). Load this skill BEFORE drafting any such prose — it carries the voice guidance the commit body needs.
user-invocable: true
disable-model-invocation: false
---

# Contextual Git Commit

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

The user will provide the commit headline as an argument (e.g. `/chalk:commit fix: boolean logic error in expression.clj`).

## Before you draft

A commit body is an **explanation** artefact and MUST be drafted in the chalk voice, not your own default prose habits.
`chalk:commit` pulls in nothing on its own, so load these first (via the Skill tool):

- **`chalk:voice`** — the principles, the explanation quadrant, the line-format rule.
- **`chalk:mindmap`** — a commit body is a lead-in line then a tree, not prose. See "Commit bodies" there.
- **`chalk:code-comments`** — the body is where a comment's design rationale belongs, so this is the moment the misfiled ones surface.
  Weed the diff's comments against it before drafting, and move what they were trying to say into the body.

**The body MUST NOT contain headings** — needing them is a signal the commit is too big, or that you're writing the PR description in the wrong place.
A tl;dr is optional; the subject line normally serves as one.

## Your responsibilities

1. **Stage relevant changes.**

   **Each commit MUST be an atomic, cohesive unit of change** — a transition from one valid state to another — and **unrelated changes MUST NOT be staged together**.

   - If two changes don't make sense independently, they're one commit; if they're distinct, they're two.
   - Keep unrelated bugfixes separate.
   - Where reasonable, separate behaviour-preserving changes (refactorings) from behaviour-advancing ones.

2. **Review the conversation history** to extract the reasoning behind the change.

   Optimise for later reading: your reader is whoever runs `git blame` on one of these lines while debugging something else, months on. They won't care about the journey — they need *why* this change exists and *why* it was done this way.

3. **Draft the body.**

   **It MUST NOT describe what changed — the diff shows that.**
   The body explains *why* it exists: decisions, alternatives rejected, constraints, dead ends, counter-intuitive findings, scope boundaries.
   Embed concrete examples — code snippets, call sites, specific scenarios — as illustrative material.

   Open with the lead-in line, then shape the reasoning per "Commit bodies" in `chalk:mindmap`.

4. **Ask clarifying questions** if you can't reconstruct the *why* from the conversation history.

   Particularly around whether something was a deliberate choice or a constraint, and whether something was intentionally out of scope or overlooked.

5. **Make the commit.**

   Headline, blank line, body. The user reviews the message in the Bash tool request before approving.

   A co-author header SHOULD be included, replacing the model as appropriate:
   ```
   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
   ```

## Issue references in the subject line

- **Resolves the issue** — suffix the subject with `(resolves #N)`.
- **An iteration towards it** — suffix with `(#N)`.

## Chalk integration

When chalk is active:

- **Reference the issue** in the body footer (`Refs #123`).
- **Draw on the session context.**
  The chalk issue and comments capture the broader intent. The commit body should stand alone but benefit from that context.
- **After committing, update the chalk comment with the outcome directly** — don't ask first.
  A one-line nudge to the user after the update is fine; a question isn't.
