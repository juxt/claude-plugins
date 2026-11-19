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

You MUST load these skills first:

- **`chalk:voice`** — the audience, the specification register, the mindmap structure, the line-format rule.

- **`chalk:code-comments`** — the body is where a comment's design rationale belongs, so this is the moment the misfiled ones surface.

- **`chalk:chalk`** — the plan file's shape and the journal's record kinds, which the body is written from.

## Your responsibilities

1. **Stage relevant changes.**

   **Each commit MUST be an atomic, cohesive unit of change** — a transition from one valid state to another — and **unrelated changes MUST NOT be staged together**.

   - If two changes don't make sense independently, they're one commit; if they're distinct, they're two.

   - Behaviour-preserving changes (refactorings) and behaviour-changing ones MUST NOT share a commit.

   - **On a branch with commits not yet on its base, test the change against their subject lines first**, where no harness has decided the commit's placement — under a-star the drive brief's placement wins, since the orchestrator made the completion call.
     Where one still holds with this change inside it, the change completes that commit: amend it there — a fixup and an autosquash — rather than committing on top.
     A reviewer shown a slice and then the rest of the same change agrees with one change twice.
     - **The test: could a reviewer be told what checking this commit means, apart from its neighbours?**
       A tidy is checked by "could this change anything?", an advance against its invariants; a commit with no check of its own completes the one whose check it shares.
     - **It never folds a refactoring into a behaviour change**, however closely they belong together: they are checked differently, so they are two units.
     - **Amending rewrites the branch**, per `chalk:chalk`'s Feature branches.

2. **Weed the staged comments.**

   **Delegate to the `weed-comments` agent**, passing the paths of the staged files and nothing else.

   - **You MUST NOT tell it what the change is for.** Not the issue, not the problem, not what you decided. 
     It stands in for a reader who has none of that, and briefing it makes it a second opinion from your own context rather than a first opinion from the reader's.

   - **Its deletions apply.** They land in the working tree and you stage them; you do not review them back into place. 
     The user sees them in the commit diff, which is the human review point.

   - **Its Misfiled list is input to Draft the body** — a comment deleted for being design rationale is rationale the body now has to carry.

   - Where a comment survives, its **Kept** line names the misunderstanding it prevents; that belongs in neither the body nor the code.

   - **Its Dissolvable list goes to the user, not into the commit.** A rename or a simplification is a code change, and staging one here would break the atomicity the step above just established.

3. **Read the session's plan journal, where `chalk:chalk` started one, then the conversation history** for what the journal lacks.

   Where the two disagree, resolve the ambiguity.
   Of the entries that bear on this change, the body carries what step 4 says its reader needs, and nothing else: it is a selection, not a copy.

   The body's reader (step 4) won't care about the journey — they need *why* this change exists and *why* it was done this way: what problem it solves, what it unblocks, what constraint drove it.

   **Ask rather than guess**, and treat "I can reconstruct it" as the answer that needs checking, per `chalk:voice`.
   Ask about whether something was a deliberate choice or a constraint, and whether something was intentionally out of scope or overlooked.

   **The *why now* is the issue's, not the commit's** (`chalk:issue`).
   Carry one only where the session has it and there is no issue to hold it; you MUST NOT invent one, and its absence is no gap.

   Trivial changes — typo fixes, mechanical bumps, one-line config tweaks — don't need this step; the motivation is self-evident.

4. **Draft the body.**

   **It MUST NOT narrate the diff** — which lines changed is the diff's job; the body names the fact that changed, and why.
   The body explains *why* it exists: decisions, alternatives rejected, constraints, dead ends, counter-intuitive findings, scope boundaries.
   Embed concrete examples — code snippets, call sites, specific scenarios — as illustrative material.

   **A commit is a change-log artefact, so the body carries the *transition*** — why it changed from X to Y, and how to migrate.
   A body that only restates current behaviour has thrown away the one thing it was for; conversely, a "this used to…" comment in the source is this body's material, sitting where it rots.

   **It MUST name the fact that was true and is no longer**, per `chalk:voice`.

   **What to omit:** 

   - anything self-evident from the diff, the code or the linked issue;

   - play-by-play of mechanical steps ("then I ran the tests"); the journey of how you got there.
     Not this (mechanical play-by-play):
     > Investigated the flaky test. Found it only failed in the full suite. Added logging to narrow it down. Discovered a race condition in TemporalBounds.intersect().

     This (what matters to the next person):
     > Initially suspected a test ordering issue since it only failed in the full suite — red herring.
     > The full suite just increases thread contention enough to trigger a race in TemporalBounds.intersect(), which reads validFrom and validTo non-atomically.

   **The tell, where the diff is itself prose** — a skill, a README, a spec: the sentence appears in substance in a line the diff *adds*.
   The review notes below are the exception: an invariant a code comment already states still belongs in them, with what the comment can't hold.
   Read the added lines against the body before you call the draft finished. "Self-evident from the diff" is a judgement you cannot make about your own text.

   **Where correctness rests on an argument the diff doesn't show locally, the body carries it**, because the code is reviewed commit by commit and this is where the reviewer is when they need it.
   Concurrency and ordering, algorithms, on-disk formats and resource lifetimes are the usual cases.
   - **What checking this commit means** — for a tidy, what to look at to answer "could this change anything?"; for an advance, the invariants below.
   - **The invariants it rests on**, each with where it is made true, what test pins it, and what change would break it; one no test pins is marked unpinned.
     - **A pin sits on the invariant it pins**, never on a parent: there it reads as pinning every child.
     - **Where a code comment states the invariant, the note may restate it**, and adds what the comment can't: where it is made true across files, what pins it, what breaks it.
   - **The journal's `review:` entry for the commit is its raw material**, where `chalk:chalk` keeps one.
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

   **The body is weeded cold when the branch is raised**, by `weed-pr` from `chalk:pr`, so a commit doesn't wait on a weed of its own.
   Where the branch never reaches a PR — a no-PR finish, a park — the messages are weeded by running `weed-pr`'s commit-message pass on its own before the branch is handed over.
   A commit going straight to the base branch is weeded the same way before it is pushed, while it is still local; once it is pushed, findings are not applied.

5. **Make the commit.**

   Headline, blank line, body. The user reviews the message in the Bash tool request before approving.

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
