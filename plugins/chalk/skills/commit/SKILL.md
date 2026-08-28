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
  The `weed-comments` agent applies it to the diff (step 2 below); its **Misfiled** list is material for the body.

**The body MUST NOT contain headings** — needing them is a signal the commit is too big, or that you're writing the PR description in the wrong place.
A tl;dr is optional; the subject line normally serves as one.

## Your responsibilities

1. **Stage relevant changes.**

   **Each commit MUST be an atomic, cohesive unit of change** — a transition from one valid state to another — and **unrelated changes MUST NOT be staged together**.

   - If two changes don't make sense independently, they're one commit; if they're distinct, they're two.
   - Keep unrelated bugfixes separate.
   - Where reasonable, separate behaviour-preserving changes (refactorings) from behaviour-advancing ones.

2. **Weed the staged comments.**

   **Delegate to the `weed-comments` agent**, passing the paths of the staged files and nothing else.

   - **You MUST NOT tell it what the change is for.** Not the issue, not the problem, not what you decided. It stands in for a reader who has none of that, and briefing it makes it a second opinion from your own context rather than a first opinion from the reader's.
   - **Its deletions apply.** They land in the working tree and you stage them; you do not review them back into place. The user sees them in the commit diff, which is the human review point.
   - **Its Misfiled list is input to step 4** — a comment deleted for being design rationale is rationale the body now has to carry.
   - Where a comment survives, its **Kept** line names the misunderstanding it prevents; that belongs in neither the body nor the code.

3. **Review the conversation history** to extract the reasoning behind the change.

   Optimise for later reading: your reader is whoever runs `git blame` on one of these lines while debugging something else, months on. They won't care about the journey — they need *why* this change exists and *why* it was done this way.

4. **Draft the body.**

   **It MUST NOT describe what changed — the diff shows that.**
   The body explains *why* it exists: decisions, alternatives rejected, constraints, dead ends, counter-intuitive findings, scope boundaries.
   Embed concrete examples — code snippets, call sites, specific scenarios — as illustrative material.

   Open with the lead-in line, then shape the reasoning per "Commit bodies" in `chalk:mindmap`.

5. **Weed the draft.**

   Write the drafted body to a file and **delegate to the `weed-prose` agent**, naming the artefact as a commit body and passing the path.

   - **You MUST NOT give it the session.** It holds the diff and, where the body carries a `Refs #N`, that issue — the same reach as the reader it stands for.
   - **Its cuts apply.** It deletes only; a sentence it kept is unchanged.
   - **Its Gaps are questions for you, not for it.** It reports a missing *why* or *why now* and MUST NOT invent one.

6. **Put `weed-prose`'s gaps to the user.**

   Not "ask if you're unsure" — that is a judgement made by the context that just spent the session building the *why*, and it always comes back confident. `weed-prose` has already decided, from the draft alone, which questions the artefact fails to answer.

   - **A gap MUST be closed by adding a sentence that answers it**, then re-running `weed-prose` on the redraft. **You MUST NOT close a gap by deciding it doesn't apply.**
   - **Relay each question as written.** Composing your own is where the ask gets dropped.
   - **A `blocking` gap — a missing *why now* — MUST be resolved before you commit.** Why-this can be recovered from the diff and the issue in six months; why-now exists only in the user's head and is gone tomorrow.
   - **Answer from the session where the session genuinely has it**, and say which part of it you're drawing on so the user can correct you. Where it doesn't, ask.
   - Ask about the same things you would have anyway: whether something was a deliberate choice or a constraint, and whether something was intentionally out of scope or overlooked.

7. **Make the commit.**

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
