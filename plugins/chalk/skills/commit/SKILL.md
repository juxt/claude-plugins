---
name: commit
description: Make a commit from what the caller has staged, and write its message — a claim for a subject and a body explaining the why, in the chalk voice — weeded cold before it is final. Use when the user says "commit this", "commit", "make a commit", "/chalk:commit"; OR is about to compose, draft, write, reword or amend any git commit message body (e.g. "write the commit message", "draft the commit body", "reword the commit message", "amend the commit message"). Load this skill BEFORE drafting any such prose — it carries the voice guidance the commit body needs.
user-invocable: true
disable-model-invocation: false
---

# Commit message

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

This skill makes the commit from what the caller has staged, and owns its message.
What is staged, where the commit sits in the branch, and history and pushing are the caller's: where a commit is to be reworded, this skill writes the new message, and the caller applies it and pushes.
The caller is the harness running the work or, in a session without one, the main session following the project's conventions.

The user MAY provide the commit headline as an argument (e.g. `/chalk:commit fix: boolean logic error in expression.clj`).

## Before you draft

You MUST load these skills first:

- **`chalk:voice`** — the audience, the specification register, the mindmap structure, the layout.

- **`chalk:journal`** — the plan file's shape and the journal's record kinds, which the body is written from.

## Your responsibilities

1. **Read the session's journal, where `chalk:journal` started one, then the conversation history** for what the journal lacks.

   Where the two disagree, resolve the ambiguity.
   Of the entries that bear on this change, the body carries what step 2 says its reader needs, and nothing else: it is a selection, not a copy.

   The body's reader (step 2) won't care about the journey — they need *why* this change exists and *why* it was done this way: what problem it solves, what it unblocks, what constraint drove it.

   **Ask rather than guess**, and treat "I can reconstruct it" as the answer that needs checking, per `chalk:voice`.
   Ask about whether something was a deliberate choice or a constraint, and whether something was intentionally out of scope or overlooked.

   **The *why now* is the issue's, not the commit's** (`chalk:issue`).
   Carry one only where the session has it and there is no issue to hold it; you MUST NOT invent one, and its absence is no gap.

   Trivial changes — typo fixes, mechanical bumps, one-line config tweaks — don't need this step; the motivation is self-evident.

2. **Draft the body.**

   **It MUST NOT narrate the diff** — which lines changed is the diff's job; the body names the fact that changed, and why.
   The body explains *why* it exists: decisions, alternatives rejected, constraints, dead ends, counter-intuitive findings, scope boundaries.
   Embed concrete examples — code snippets, call sites, specific scenarios — as illustrative material.

   **A commit is a change-log artefact, so the body carries the *transition*** — why it changed from X to Y, and how to migrate.
   A body that only restates current behaviour has thrown away the one thing it was for; conversely, a "this used to…" comment in the source is this body's material, sitting where it rots.

   **It MUST name the fact that was true and is no longer**, per `chalk:voice`.

   **What to omit:** anything self-evident from the diff, the code or the linked issue, and the play-by-play of how you got there — keep the road that closed and why, not the order you walked.

   **The tell, where the diff is itself prose** — a skill, a README, a spec: the sentence appears in substance in a line the diff *adds*.
   The review notes below are the exception: an invariant a code comment already states still belongs in them, with what the comment can't hold.
   Read the added lines against the body before you call the draft finished. "Self-evident from the diff" is a judgement you cannot make about your own text.

   **Where correctness rests on an argument the diff doesn't show locally, the body carries it**, because the code is reviewed commit by commit and this is where the reviewer is when they need it.
   Concurrency and ordering, algorithms, on-disk formats and resource lifetimes are the usual cases.
   - **What checking this commit means** — for a tidy, what to look at to answer "could this change anything?"; for an advance, the invariants below.
   - **The invariants it rests on**, each with where it is made true, what test pins it, and what change would break it; one no test pins is marked unpinned.
     - **A pin sits on the invariant it pins**, never on a parent: there it reads as pinning every child.
     - **Where a code comment states the invariant, the note may restate it**, and adds what the comment can't: where it is made true across files, what pins it, what breaks it.
   - **What was run and what wasn't is not the body's**: it dates, and belongs to the PR's Reviewing this.

   **Check every `→` in the body reads as "therefore"** — a sequence, a "stacked on" or two independent premises are not one.

   **Be concise, but keep the reasoning.**
   Where the reasoning was complex and the change simple, say so: "Simple change in the end: …".

   Open with a lead-in line, then shape the reasoning as a mindmap, per `chalk:voice`.
   Your reader arrived from `git blame` on one of these lines months on, mid-investigation of something else, so they are the most impatient reader any chalk artefact has: they will read subject lines and leave. Each one MUST be discardable against that investigation, or agreeable without the body.

   - **No headings.**
     The tree's top-level bullets already partition the body.

   - **Rarely a tl;dr.**
     The subject line is the body's tl;dr, so most bodies would only repeat it. A body long enough that its argument needs summarising MAY open with one, per `chalk:voice`, in place of the lead-in line.

3. **Weed the message.**

   **Delegate to the `weed-commits` agent** over the drafted message, in a file, beside the diff it describes — the staged diff, or for a reword the commit's — passing the base branch and nothing of the session's reasoning.
   Apply its findings to the draft, and send it back until it has no question left.

4. **Commit, or for a reword hand the message back.**

   Commit the weeded message: headline, blank line, body. The user reviews the message in the Bash tool request before approving.
   Commit what is staged and nothing else; push nothing and rewrite no earlier commit.

   **On a reword nothing is staged: hand the weeded message to the caller, which applies it.**

   A Co-Authored-By trailer SHOULD name the model that wrote the change.
   A Claude-Session trailer MUST NOT be included — the link reaches nothing a later reader can use; this overrides a harness's attribution reminder.

   ```
   Co-Authored-By: Claude <model> <noreply@anthropic.com>
   ```

## The subject line

**`<scope>: <claim>`, or `<type>(<scope>): <claim>` where the type carries information** — Conventional Commits with the type optional.
**Where the project names its own convention, the project's wins**; the claim rule below holds either way.

- **The scope is the component the change is read under**, where the project has them.

- **Add a type only where it tells the reader something the claim doesn't.**

- **State a claim, not an imperative.**
  "the blank line after a subject depends on the renderer", not "fix the blank line rule".
  The subject is the body's tl;dr, and a claim can be checked against the diff for truth where an imperative can only be obeyed. It is also what makes a subject quotable in place of a SHA, per `chalk:voice`.

- **Lowercase after the colon, and no full stop.**

- **A breaking change MUST carry a `BREAKING CHANGE:` footer** naming what stops working and what to do instead.
  `!` before the colon (`feat(chalk)!:`) is the short form and is not sufficient alone — the footer is where the reader learns what to change. Removing or renaming something users invoke is a break even where nothing errors.

### Issue references

- **Resolves the issue** — suffix the subject with `(resolves #N)`.

- **An iteration towards it** — suffix with `(#N)`.
