---
name: commit
description: Create a commit with a contextual body explaining the why, in the chalk voice. Use when the user says "commit this", "commit", "make a commit", "/chalk:commit"; OR is about to compose, draft, write or amend any git commit message body (e.g. "write a commit message", "draft the commit body", "amend the commit message"). Load this skill BEFORE drafting any such prose — it carries the voice guidance the commit body needs.
user-invocable: true
disable-model-invocation: false
---

# Contextual Git Commit

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

The user MAY provide the commit headline as an argument (e.g. `/chalk:commit fix: boolean logic error in expression.clj`).

## Before you draft

A commit body is an **explanation** artefact and MUST be drafted in the chalk voice, not your own default prose habits.

You MUST load these skills first:

- **`chalk:voice`** — the audience, the specification register, the mindmap structure, the line-format rule.
- **`chalk:code-comments`** — the body is where a comment's design rationale belongs, so this is the moment the misfiled ones surface.

## Your responsibilities

1. **Stage relevant changes.**

   **Each commit MUST be an atomic, cohesive unit of change** — a transition from one valid state to another — and **unrelated changes MUST NOT be staged together**.

   - If two changes don't make sense independently, they're one commit; if they're distinct, they're two.
   - Keep unrelated bugfixes separate.
   - Where reasonable, separate behaviour-preserving changes (refactorings) from behaviour-advancing ones.

2. **Weed the staged comments.**

   **Delegate to the `weed-comments` agent**, passing the paths of the staged files and nothing else.

   - **You MUST NOT tell it what the change is for.** Not the issue, not the problem, not what you decided. 
     It stands in for a reader who has none of that, and briefing it makes it a second opinion from your own context rather than a first opinion from the reader's.
   - **Its deletions apply.** They land in the working tree and you stage them; you do not review them back into place. 
     The user sees them in the commit diff, which is the human review point.
   - **Its Misfiled list is input to Draft the body** — a comment deleted for being design rationale is rationale the body now has to carry.
   - Where a comment survives, its **Kept** line names the misunderstanding it prevents; that belongs in neither the body nor the code.

3. **Review the conversation history** to extract the reasoning behind the change.

   Optimise for later reading: your reader is whoever runs `git blame` on one of these lines while debugging something else, months on. 
   They won't care about the journey — they need *why* this change exists and *why* it was done this way.

   - **Why this** — what problem it solves, what it unblocks, what constraint drove it.
   - **Why now** — what prompted it today: a deadline, a dependent piece of work, a recent incident, someone else blocked on it.

   **Ask rather than guess**, and treat "I can reconstruct it" as the answer that needs checking — that judgement is made by the context that just built the *why*, so it always comes back confident. **Where a *why now* isn't traceable to something the user said, a commit or a file you can name, you don't have it.**

   Trivial changes — typo fixes, mechanical bumps, one-line config tweaks — don't need this step; the motivation is self-evident.

4. **Draft the body.**

   **It MUST NOT describe what changed — the diff shows that.**
   The body explains *why* it exists: decisions, alternatives rejected, constraints, dead ends, counter-intuitive findings, scope boundaries.
   Embed concrete examples — code snippets, call sites, specific scenarios — as illustrative material.

   **A commit is a change-log artefact, so the body carries the *transition*** — why it changed from X to Y, and how to migrate.
   A body that only restates current behaviour has thrown away the one thing it was for; conversely, a "this used to…" comment in the source is this body's material, sitting where it rots.

   **What to omit:** 

   - anything self-evident from the diff, the code or the linked issue;
   - play-by-play of mechanical steps ("then I ran the tests"); the journey of how you got there.

     Not this (mechanical play-by-play):
     > Investigated the flaky test. Found it only failed in the full suite. Added logging to narrow it down. Discovered a race condition in TemporalBounds.intersect().

     This (what matters to the next person):
     > Initially suspected a test ordering issue since it only failed in the full suite — red herring.
     > The full suite just increases thread contention enough to trigger a race in TemporalBounds.intersect(), which reads validFrom and validTo non-atomically.

   **Be concise, but keep the reasoning.**
   A terse note with no *why* is as unhelpful as a verbose one. 
   Where the reasoning was complex and the change simple, say so: "Simple change in the end: …".

   Open with a lead-in line, then shape the reasoning as a mindmap, per `chalk:voice`.

   - **No headings.**
     The tree's top-level bullets already partition the body, and a body short enough to read in a `git log` doesn't want a second, coarser structure laid over the top of them.

   - **Rarely a tl;dr.**
     The subject line is the body's tl;dr, so most bodies would only repeat it. A body long enough that its argument needs summarising MAY open with one in place of the lead-in line, shaped as a mindmap like anything else.

5. **Weed the draft.**

   Write the drafted body to a file and **delegate to the `weed-prose` agent**, naming the artefact as a commit body, passing the path and the bodies of any issues referenced in the commit.

   - **You MUST NOT give it the session.**
     It holds the diff and, where the body references an issue, that issue — the same reach as the reader it stands for.
   - **Its cuts apply.** It deletes only; a sentence it kept is unchanged.
   - **Its Gaps are questions for you, not for it.** It reports a missing *why* or *why now* and MUST NOT invent one.

6. **Put `weed-prose`'s gaps to the user.**

   Not "ask if you're unsure" — that is a judgement made by the context that just spent the session building the *why*, and it always comes back confident. 
   `weed-prose` has already decided, from the draft alone, which questions the artefact fails to answer.

   - **A gap MUST be closed by adding a sentence that answers it, and the redraft MUST go back to `weed-prose`.** **You MUST NOT close a gap by deciding it doesn't apply**, and you MUST NOT judge your own redraft — the agent that raised the gap is the one that closes it. 
     Loop until it reports no blocking gaps.
   - **Relay each question as written.** Composing your own is where the ask gets dropped.
   - **A `blocking` gap — a missing *why now* — MUST be resolved before you commit.** Why-this can be recovered from the diff and the issue in six months; why-now exists only in the user's head and is gone tomorrow.
   - **Answer from the session where the session genuinely has it**, and say which part of it you're drawing on so the user can correct you. Where it doesn't, ask.
   - Ask about the same things you would have anyway: whether something was a deliberate choice or a constraint, and whether something was intentionally out of scope or overlooked.

7. **Make the commit.**

   Headline, blank line, body. The user reviews the message in the Bash tool request before approving.

   A co-author header SHOULD be included, replacing the model as appropriate:
   A Claude-Session header MUST NOT be included.

   ```
   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
   ```

## Issue references

- **Resolves the issue** — suffix the subject with `(resolves #N)`.
- **An iteration towards it** — suffix with `(#N)`.
