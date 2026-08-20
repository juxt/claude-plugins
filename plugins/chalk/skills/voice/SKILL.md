---
name: voice
description: Shared chalk writing voice — the universal principles, the explanation quadrant, and the line-format rule. The chalk, chalk:issue, chalk:commit, chalk:pr and chalk:tend-docs skills load this before drafting any GitHub-bound or docs prose; a human may run it to read the guide. Companion skills chalk:mindmap (the shape of followable content) and chalk:goal-tree (goal trees) carry the structure this one deliberately leaves out.
user-invocable: true
---

# Chalk Voice — Writing Principles

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

You're reading this because you're about to write something in the chalk voice — a commit body, an issue, a PR description, a chalk comment, a code comment, a docs page.
Draft against this guidance, not your own default prose habits: the defaults read wrong and lose the reasoning the reader actually needs.

**Optimise for the reader, not the writer.**

Whatever you're writing, the reader is trying to do one of four things, and [Diataxis](https://diataxis.fr) names them:

| | Acquire | Apply |
| --- | --- | --- |
| **Cognition** | Explanation | Reference |
| **Action** | Tutorial | How-to |

They apply recursively, from a whole docs site down to a paragraph inside a commit body.

**Nearly everything in this plugin is explanation, end to end** — commit bodies, issue and PR descriptions, chalk comments, code comments.
Reference-shaped material inside them (log excerpts, usage examples, commit lists, test plans) is illustration embedded in the explanation, not a section of its own.
A docs page is the only artefact that plays all four.

## Load alongside this

- **`chalk:mindmap`** — always.
  The shape of followable content: nested bullets, subject lines, tags, cross-reference IDs, tl;dr placement. It applies in every quadrant.

- **`chalk:goal-tree`** — where a node's children *accomplish* it rather than argue for it.
  The direction of a piece of work, a Future state or Implementation section.

- **`references/palette.md`** — before drafting an issue, PR or chalk comment.
  The section palette, their ordering, and the annotated-trace technique for sequencing bugs.

- **`references/docs-quadrants.md`** — before writing a docs page.
  How-to, reference and tutorial voice; the three quadrants nothing else here needs.

- **`chalk:code-comments`** — before writing or editing any comment.
  The reader model, the counter-intuition test, and where the rejected material goes instead.

## Line format

**The destination decides it: paragraph-per-line where the artefact is read rendered, sentence-per-line where it's reviewed as a diff.**

- **Paragraph-per-line** — commit bodies, issue and PR descriptions, chalk comments.
  These are read rendered on GitHub, and GitHub renders a single newline as `<br>`, so sentence-per-line fragments into staccato. Put each paragraph on one line, separate paragraphs with a blank line, and let the rendering wrap.

- **Sentence-per-line** — docs pages.
  A page lives in the repo and is reviewed as a diff, where a one-line paragraph makes a one-word fix an unreadable whole-paragraph change.

- **No rule at all** — code comments, which are read in-source.
- **Whichever applies, it applies inside a bullet too**, which is where it's most often forgotten.
  On a paragraph-per-line destination a bullet's elaboration stays on one line however long it runs; the single break after the subject (`chalk:mindmap`) is the only exception.

- **A project MAY override this** and ask for sentence-per-line in commit messages.
  Follow the project's convention where it states one; see "Discover project conventions" below.

## Universal principles

### Establish the why and the why now

A prerequisite, not a style rule: you cannot write the *why* if you never found it out, and the diff won't carry it for you.

- **Why this** — what problem it solves, what it unblocks, what constraint drove it.
- **Why now** — what prompted it today. A deadline, a dependent piece of work, a recent incident, someone else blocked on it?

**Ask rather than guess.**
If either isn't clear from the conversation, the issue and its neighbours, or the code you've read, ask the user — ideally before starting the work, and at the latest before drafting.
A one-sentence answer now is cheaper than a reader reconstructing it later from the artefact, which is the only place they'll be able to look.

Trivial changes — typo fixes, mechanical bumps, one-line config tweaks — don't need this step; the motivation is self-evident.
Everything else does, and one answer serves every artefact.

*Why now* is the half that goes missing, and its absence is what leaves an issue un-triageable in the backlog and a commit unexplainable six months on.

### Name your audience

"Optimise for the reader" is only actionable once you've said who the reader is.

**For everything in this plugin it's nearly always your teammates** — including the two who are easiest to forget and who between them are most of the readership: **you in six months**, with none of the context you have while writing, and **a future agent session**, starting cold from the artefact and nothing else.

- **Lead with what they need, not with what you did.**
  The two diverge most sharply in summaries: a summary of the *work* reads as a session changelog, where a summary for the *reader* states what's true now and what it means for them.

- **Assume none of your session's shared context.**
  A sentence that only parses if you know which files were touched, which commit came before, or what was said in chat is a sentence the audience can't use.

- **Name the audience explicitly whenever it isn't the default**
  A docs page for end users, an issue aimed at another team, a comment for whoever next debugs this function.

### Concrete over abstract

Ground the reasoning in specific scenarios, code snippets, data, real identifiers — not placeholders.
Abstract explanations are harder to follow and easier to misinterpret.

Not this:
> Updated the type system to better represent logical types, improving the separation between compile-time and run-time representations.

This:
> A logical type is one of: Mono (null, scalar, listy, struct), Maybe (nullable mono), or Poly (set of monos).
> Previously, VectorType represented physical types — the compile-time type and run-time type could differ because many physical representations map to one logical type.
> For physical representations, we now exclusively use Arrow's `Field` class.

**Raw evidence MUST be annotated.**
A log dump or stack trace with no explanation of what the reader is looking at is noise.

### Lead with the problem or context

Set up *why this matters* before the solution.
The reader needs the situation before the fix makes sense.
A how-to opens with the goal, an explanation opens with what needs explaining, a reference block sits under the concept it references.

### Be concise — but keep the reasoning

A terse note with no *why* is just as unhelpful as a verbose one.
When the reasoning is complex but the change is simple, say so: "Simple change in the end: ..." helps the reader calibrate.

### Structure what the reader must follow

**Followable content MUST default to a mindmap; prose MUST be a deliberate exception, not a fallback.**
The rules are in `chalk:mindmap` — load it rather than improvising the shape, because getting the format roughly right and the *relation* wrong produces a tidy bullet list that carries no argument, and this guide can't catch that for you.

### Write in specification register

**Every sentence carries a fact, a constraint or a decision.**
None exists to convey that a person is delivering it.

**You're not writing to impress anyone.**
Your reader is a teammate trying to get something done, not an assessor — so there's nothing here to reward the motive that produces flourishes, alternatives nobody would take, and caveats that change nothing.
Drop the motive and most of the specific tics go with it.

**A sentence MUST NOT exist to tell the reader that another one matters.**
Same rule turned on the text rather than the author. The reader takes it as read that everything present earns its place, so **ranking your own material** ("the single highest-leverage rule here"), **justifying its presence** ("this is the one reason this needs saying"), **narrating the document's shape** ("what follows is") and **advertising your diligence** ("checked carefully") each cost a read before the reader arrives at the thing being advertised.

- **An importance claim backed by a reason is an argument, and it stays.**
  "Blocked-by pays back most: a filter for open, un-blocked becomes the queue of workable cards" earns its ranking in the same breath. The unbacked assertion is the one to cut.

- **State priority operationally, not evaluatively**
  Ordering, RFC 2119 strength, a stated constraint, or "where this conflicts with X, this wins". Those survive repetition; a superlative doesn't, because if three rules each claim to matter most, none of them does.

- **No filler in headings or lead-ins.**
  "Caveat:" not "One honest caveat"; "Agreed:" not "Agreed — and here's why that's the stronger design".
- **Personality is fine exactly where removing it would change how the reader acts on the sentence.**
  Otherwise it's decoration they have to read past to reach the claim.
- **Depth isn't the problem.**
  Expand a section as far as it needs; every sentence in it earns its place on the same test.
- **The tells**
  An opening reaction line, a sign-off offer, an aside carrying attitude rather than a fact, a frame wrapped around a claim instead of the claim.

### One word, one meaning

Aim for what [ASD-STE100](https://www.asd-ste100.org) aims for — the reader gets the meaning with minimum effort and no ambiguity — but get there by **technical precision rather than a restricted vocabulary**.

`sufficient` and `necessary` each carry an exact meaning that a paraphrase spends a clause on and still blurs, so **precision beats simplicity where the two conflict**: what gets cut is the decorative metaphor, not the exact term.

**Use one word for one concept throughout an artefact.**
Synonym variation reads as elegant and costs the reader a re-check every time they have to ask whether you meant something different.

### Transitions vs. current state

Every *why* belongs in one of two homes, and the artefact's job decides which.

- **Change-log artefacts carry the *transition*.**
  Commit bodies, PR descriptions, changelog entries: why it changed from X to Y, and how to migrate. Read once, around the change.

- **Durable artefacts carry the *current contract*.**
  Code comments, docs bodies, reference: written as if it had always been this way, for someone who doesn't care what it used to be.

So a "this used to…" comment in the source, or a "previously we…" line in a docs body, is misfiled — the transition it describes belongs in the commit or the changelog, and it rots where it sits.
Conversely a commit body that only restates current behaviour, not what changed and why, has thrown away the one thing it was for.

### No marketing fluff

"Powerful", "seamless", "blazing-fast", "revolutionary" — cut them.
State the capability; let the reader draw the conclusion.

### Discover project conventions, don't impose them

Version markers, changelog shapes, file layout, cross-link style, commit line format — these vary between projects.
Read the docs README, existing pages, and recent commits before writing, and match what's there.

## Explanation — the quadrant everything here lands in

The reader wants to *understand*: mental models, why-this-way, decisions, tradeoffs, dead ends, invariants.

**Voice:** discursive, grounded in concrete examples, leading with the problem or the concept being explained.
Capture the *why*, not the *what* — the reader can see the what in the diff, the config, the code.
Teach the mental model when the change introduces or reshapes a concept; don't assume the reader has the one you built up while implementing.

**What to capture:**

- **The problem first** — why this matters, before what you did.
- **Decisions and tradeoffs** — why X over Y, what constraints drove the choice.
- **Counter-intuitive findings** — anything that surprised you, or would surprise a developer familiar with the project.
- **Dead ends** — what didn't work and why, including *why* the wrong approach seemed right. This is what prevents re-investigation.
- **Scope boundaries** — what was explicitly out of scope and why, so nobody re-opens a question you already closed.
- **The mental model** — what the abstractions are, how they relate, why they're shaped this way.

**What to omit:** details self-evident from the diff, the code or the issue description; play-by-play of mechanical steps ("then I ran the tests"); the journey of how you got there.

Not this (mechanical play-by-play):
> Investigated the flaky test. Found it only failed in the full suite. Added logging to narrow it down. Discovered a race condition in TemporalBounds.intersect().

This (what matters to the next person):
> Initially suspected a test ordering issue since it only failed in the full suite — red herring.
> The full suite just increases thread contention enough to trigger a race in TemporalBounds.intersect(), which reads validFrom and validTo non-atomically.

Not this (states the fix without the problem):
> This PR changes UPDATE to not create new rows when all values remain the same.

This (problem first, with a concrete example and explicit scope):
> UPDATE was creating duplicate rows even when no values actually changed.
> Uses type-strict equality — `UPDATE docs SET a = 1.0 WHERE _id = 1` on a doc with `{:a 1}` *will* create a new record because `1 ≠ 1.0`.
> PATCH is out of scope of this PR (see #5030).
