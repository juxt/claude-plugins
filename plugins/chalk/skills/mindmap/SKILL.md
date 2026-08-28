---
name: mindmap
description: How to structure anything the reader has to follow — a mindmap of nested bullets whose parents are claims and whose children back them up. Load before drafting any commit body, issue, PR description, chalk comment, code comment or docs section with more than a couple of steps of reasoning in it; the chalk, chalk:issue, chalk:commit, chalk:pr and chalk:tend-docs skills load it alongside chalk:voice. Also covers tags, typed cross-reference IDs, tl;dr placement, and the per-artefact rules for commit bodies and code comments.
user-invocable: true
---

# Chalk Mindmaps — Structuring What the Reader Must Follow

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

`chalk:voice` covers the register and the line-format rule. Load both.

## The default

**Anything the reader has to *follow* MUST default to a mindmap: nested bullets forming a tree.**
A sequence of events, a multi-step rationale, a set of conditions, a decision and its grounds.

**Prose MUST be a deliberate exception, never a fallback** — reserve it for a short causal argument where the connectives ("because", "so", "but only when") carry the meaning and the chain is only two or three links long.

## The tree is a support structure

**Every parent node MUST be a claim its direct children back up.**

- **Read downwards it's a summary** that expands on demand — the reader stops at whatever depth answers their question.
- **Read upwards it's an argument**
  If each child holds, and the children are enough, the parent holds.
- **If the relation is *serves* rather than *supports*, you're writing a goal tree**
  Load `chalk:goal-tree`, which has its own completeness test.

**An arbitrary bullet list is not a mindmap.**
The test: pick any node and ask whether its children *back it up*.
If they're merely *related* to it, you've written a flat list with indentation, the reader gets no argument out of it, and it MUST be restructured.

## Subject lines carry the reasoning

**Reading only the top line of each bullet MUST be enough to follow the whole argument.**
A paragraph underneath is *elaboration* — always an optional read, and it MUST NOT be load-bearing.
If the point only lands once the reader reaches the third sentence of the elaboration, the subject line has failed and the bullet needs rewriting, not expanding.

- **One checkpoint per bullet.**
  Each bullet is a place the reader stops, confirms they've followed, and moves on.
- **Bold the load-bearing words.**
  The tree should be graspable from the bolded phrases alone, before a word of the surrounding prose is read.
- **Nest for sub-points, but stay shallow** — about two levels.
  A third level of indentation is usually its own wall, so promote it or flatten it.
- **Cut hard.**

## Give the subject its own line

**A subject MUST sit on its own line, with any elaboration broken beneath it and indented to line up with the subject's first character** — two spaces under a top-level bullet, four under a nested one.

```markdown
- **The subject sits alone on its line**
  The elaboration goes here, aligned under the subject's first character.

  - **A nested bullet works the same way**
    Four spaces, so it lines up under its own subject.
```

- **One break, not sentence-per-line — on a paragraph-per-line destination.**
  The break after the subject is the single exception to the paragraph-per-line rule in `chalk:voice`; the elaboration itself stays on one line however long it runs. Breaking it fragments into `<br>` staccato exactly as it would in a paragraph.

- **A bullet whose elaboration runs long SHOULD be followed by a blank line** before the next bullet.

- **A blank line anywhere in a list makes the whole list loose** in CommonMark, so the extra spacing lands on every item rather than just the long one.
  That's the intent — don't fight it by padding the short ones to match.

- **In a comment read raw, the alignment goes after the comment marker.**
  `// ` or `;; `, then the same indentation under the subject.

## Say how you decomposed a node

Where a node's children aren't obviously exhaustive, **name the rule you split on** — "one per subsystem", "one per failure mode", "one per call site".

With nothing to test the child set against, **a missing sibling looks exactly like no sibling** — naming the rule at least makes the gap visible to the reader.

This pays off most where a reader's next question is "is that all of them?": **Alternatives considered**, **Out of scope**, **Symptoms**.
Goal trees don't need it — there the parent *is* the yardstick (see `chalk:goal-tree`).

## Tags

**Prefix a bullet with a tag where it sharpens the point** — `goal:`, `pro:`, `con:`, `idea:`, `assumption:`, `check:`.

- **The vocabulary is open.**
  These are the common ones; invent others where they carry meaning, and expect readers to do the same.
- **A tag MUST be meant precisely**, per RFC 2119 — it is a claim, not decoration.
  `assumption:` says you haven't verified it. `check:` says it needs verifying before anyone relies on it.

- **In an issue, `assumption:` on a line in Root cause** tells the reader it's unverified and stops the next person building on it as though it were established.
- **Don't tag for the sake of it.**
  An untagged bullet is the norm; a tag is a signal, and signals dilute.

## Cross-references

**Give a node a typed ID where a reader might want to point at it in reply.**
The letter comes from the tag — `G1` for a goal, `D1` for a decision, `I1` for an idea — so the scheme extends itself as new tags appear.
Nest them to mirror the tree: `D2.1` is the first child of `D2`.

- **Use them where reply-by-reference actually happens**
  **Alternatives considered**, **Decision rationale**, **Open Questions**. Not every bullet everywhere — IDs on scaffolding are noise.

- **A published ID MUST be stable.**
  Renaming or renumbering a node breaks every inbound reference. Where IDs already exist, cite them rather than re-describing the node.

- **IDs beat numbered lists.**
  Inserting a sibling renumbers an ordered list and silently breaks every reference into it; an ID stays pinned to its node.

## tl;dr

**A tl;dr MUST go at the top of the artefact, never the bottom.**

**The tl;dr is a mindmap too**, optionally opening with a single summary sentence: one top-level bullet per takeaway, subject lines carrying the point.

**It MUST summarise the artefact for its audience, not the work for its author**, and MUST be readable by someone who did not see the session, the branch or the prior state.
This failure is invisible from the inside: recapping what you did and what changed since some earlier state is accurate, and useless to a reader who never saw that state.

- **The tell**
  The tl;dr only parses if you already know the history — a prior commit by SHA, a decision from the session, a "the missing half" that assumes the reader knows which half landed first.

- **The fix**
  Make the first bullet tell a cold reader what this *is* and what it means for them, and push the provenance down into the body where someone who wants it will find it.

- **Who that reader is** is pinned per artefact in "Name your audience" in `chalk:voice` — by the task they're in the middle of, not by their seniority.

**It's optional in a commit body and MUST NOT appear in a code comment.**
The commit subject line usually does the job, so most bodies don't want one; a long body whose argument needs summarising MAY open with one. A code comment's first line is its own tl;dr, per the subject-line rule.

## Per artefact

### Issues, PRs and chalk comments

- **The palette decides which sections exist; the mindmap shapes what's inside them.**
  Draw sections from `chalk:voice`'s `references/palette.md`; then per section it's the heading, a short tl;dr as its opening, then the tree.

- **A `<details>` block behaves like a bullet**
  Its summary line is the subject line, and it carries the same contract.
- **Not every section wants a tree.**
  Two sentences of causal argument shouldn't be forced into one.

### Commit bodies

- **No headings.**
  The tree's top-level bullets already partition the body, so a heading layer is a second, coarser structure doing the same job. Needing one is a signal the commit is too big.

- **Lead-in line, then the tree.**
  The lead-in sets up the problem or context; the tree carries the reasoning.
- **The tell that this was missed** is the same material coming out bulleted in a PR description and as prose in the commit that carries it.
  If you've just written the PR, the commit gets the same shape.

### Code comments

- **Only where the comment has structure to show**
  More than two or three sentences, or an enumeration the reader has to work through. Most comments are one line and should stay one line: `// volatile — reads race with the flush thread` doesn't want a bullet.

- **Match the markup to what the language's tooling renders.**
  KDoc, Javadoc and docstrings are rendered, so bullets and emphasis land as intended.
- **Bold emphasis MUST NOT be used in comment markup that is read raw.**
  A bare `//` or `;;` comment gets plain `-` and indentation.

- **`chalk:code-comments` still decides *whether* the comment belongs at all**
  The mindmap only shapes one that has earned its place, and most haven't. Load it before writing the comment, not after.

### Docs pages

- **Same default, applied per section.**
  A section's steps, conditions or failure modes are followable content and take the tree.
- **The tree doesn't let a section straddle quadrants.**
  A how-to's numbered steps and an explainer's reasoning are both trees; they still belong in different sections.
