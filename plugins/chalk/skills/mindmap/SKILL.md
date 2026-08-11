---
name: mindmap
description: How to structure anything the reader has to follow — a mindmap of nested bullets whose parents are claims and whose children back them up. Load before drafting any commit body, issue, PR description, chalk comment, code comment or docs section with more than a couple of steps of reasoning in it; the chalk, chalk:issue, chalk:commit, chalk:pr and chalk:tend-docs skills load it alongside chalk:voice. Also covers tags, typed cross-reference IDs, tl;dr placement, and the per-artefact rules for commit bodies and code comments.
user-invocable: true
---

# Chalk Mindmaps — Structuring What the Reader Must Follow

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

You're reading this because you're about to write something with structure the reader has to follow.
This skill covers the *shape*; `chalk:voice` covers the register and the section palette.
Load both.

## The default

Anything the reader has to *follow* — a sequence of events, a multi-step rationale, a set of conditions, a decision and its grounds — **defaults to a mindmap: nested bullets forming a tree**, not a prose paragraph.

Focus is the reader's scarce resource.
A tree lets them checkpoint their understanding as they go and jump straight to the branch they care about.
A dense paragraph makes them hold the whole chain in their head and trust they reassembled it the way you meant.

Reserve prose for a short causal argument where the connectives ("because", "so", "but only when") carry the meaning and the chain is only two or three links long.
This is about the *followable* parts, not the tone — an explanation can still read discursively and lay its reasoning out as a tree.

## The tree is a support structure

**A parent is a claim; its direct children are what back it up.**

- **Read downwards it's a summary** that expands on demand — the reader stops at whatever depth answers their question.
- **Read upwards it's an argument** — if each child holds, and the children are enough, the parent holds.
- **If the relation is *serves* rather than *supports*, you're writing a goal tree** — load `chalk:goal-tree`, which has its own completeness test.

**An arbitrary bullet list is not a mindmap.**
The test: pick any node and ask whether its children *back it up*.
If they're merely *related* to it, you've written a flat list with indentation, and the reader gets no argument out of it.

## Subject lines carry the reasoning

Same contract as a git commit subject: **reading only the top line of each bullet must be enough to follow the whole argument.**
A paragraph underneath is *elaboration* — always an optional read, never load-bearing.
If the point only lands once the reader reaches the third sentence of the elaboration, the subject line has failed and the bullet needs rewriting, not expanding.

- **One checkpoint per bullet.** Each bullet is a place the reader stops, confirms they've followed, and moves on.
- **Bold the load-bearing words.** The tree should be graspable from the bolded phrases alone, before a word of the surrounding prose is read.
- **Nest for sub-points, but stay shallow** — about two levels. A third level of indentation is usually its own wall, so promote it or flatten it.
- **Cut hard.** Less text beats better-formatted text — a bullet the reader doesn't need is noise, and noise hides the ones that matter.

## Say how you decomposed a node

Where a node's children aren't obviously exhaustive, **name the rule you split on** — "one per subsystem", "one per failure mode", "one per call site".

An argument tree can demonstrate soundness but not completeness.
With nothing to test the child set against, **a missing sibling looks exactly like no sibling** — naming the rule at least makes the gap visible to the reader.

This pays off most in the palette sections where a reader's next question is "is that all of them?": **Alternatives considered**, **Out of scope**, **Symptoms**.
Goal trees don't need it — there the parent *is* the yardstick (see `chalk:goal-tree`).

## Tags

**Prefix a bullet with a tag where it sharpens the point** — `goal:`, `pro:`, `con:`, `idea:`, `assumption:`, `check:`.

- **The vocabulary is open.** These are the common ones; invent others where they carry meaning, and expect readers to do the same.
- **Tag a bullet and you've made a claim** — mean it precisely, per RFC 2119. `assumption:` says you haven't verified it. `check:` says it needs verifying before anyone relies on it.
- **In an issue, `assumption:` on a line in Root cause** tells the reader it's unverified at a fraction of what prose would spend, and stops the next person building on it as though it were established.
- **Don't tag for the sake of it.** An untagged bullet is the norm; a tag is a signal, and signals dilute.

## Cross-references

**Give a node a typed ID where a reader might want to point at it in reply.**
The letter comes from the tag — `G1` for a goal, `D1` for a decision, `I1` for an idea — so the scheme extends itself as new tags appear.
Nest them to mirror the tree: `D2.1` is the first child of `D2`.

- **Use them where reply-by-reference actually happens**: **Alternatives considered**, **Decision rationale**, **Open Questions**. Not every bullet everywhere — IDs on scaffolding are noise.
- **GitHub gives a bullet no anchor**, so without IDs a reviewer has to quote your text back to you to disagree with one branch. With them they can answer `D2`, accept the rest, and the thread stays legible.
- **Where IDs already exist, cite them.** If an issue or PR numbers its nodes, refer back by ID rather than re-describing the node.
- **IDs beat numbered lists.** Inserting a sibling renumbers an ordered list and silently breaks every reference into it; an ID stays pinned to its node.

## tl;dr

**A tl;dr goes at the top.**
Every chalk artefact is read top-to-bottom — putting it at the bottom is a chat convention, where the reader scrolls upward.

**The tl;dr is a mindmap too**, optionally opening with a single summary sentence: one top-level bullet per takeaway, subject lines carrying the point.
It's a summary of the argument, so it gets the same treatment as the argument.
"tl;dr" conventionally means a paragraph — here it's a tree.

**Summarise the artefact for its audience, not the work for its author.**
This failure is invisible from the inside: recapping what you did and what changed since some earlier state is accurate, and useless to a reader who never saw that state.

- **The tell**: the tl;dr only parses if you already know the history — a prior commit by SHA, a decision from the session, a "the missing half" that assumes the reader knows which half landed first.
- **The fix**: make the first bullet tell a cold reader what this *is* and what it means for them, and push the provenance down into the body where someone who wants it will find it.
- **Who that reader is** is settled in "Name your audience" in `chalk:voice` — for chalk artefacts, nearly always a teammate, which includes you in six months and a future agent session with no context.

**In a commit body it's optional.**
The subject line usually does the job, so most bodies don't want one — but a long body whose argument needs summarising MAY open with a tl;dr, and then it's a mindmap like any other.
A code comment never wants one: the first line is it, per the subject-line rule.

## Per artefact

### Issues, PRs and chalk comments

- **The palette decides which sections exist; the mindmap shapes what's inside them.** Draw sections from `chalk:voice`; then per section it's the heading, the mindmap, and a short tl;dr as its opening.
- **A `<details>` block behaves like a bullet** — its summary line is the subject line, and it carries the same contract.
- **Not every section wants a tree.** Two sentences of causal argument shouldn't be forced into one; the default is strong, not absolute.

### Commit bodies

- **No headings.** The tree's top-level bullets already partition the body, so a heading layer is a second, coarser structure doing the same job. Needing one is a signal the commit is too big.
- **Lead-in line, then the tree.** The lead-in sets up the problem or context; the tree carries the reasoning.
- **A tl;dr is optional and usually unnecessary** — the subject line normally covers it. Reach for one only when the body is long enough that its argument needs summarising before the reader starts it.
- **The tell that this was missed** is the same material coming out bulleted in a PR description and as prose in the commit that carries it. If you've just written the PR, the commit gets the same shape.

### Code comments

- **Only where the comment has structure to show** — more than two or three sentences, or an enumeration the reader has to work through. Most comments are one line and should stay one line: `// volatile — reads race with the flush thread` doesn't want a bullet.
- **Match the markup to what the language's tooling renders.** KDoc, Javadoc and docstrings are rendered, so bullets and emphasis land as intended. A bare `//` or `;;` comment is read raw — use plain `-` and indentation, and drop the bold, because `**like this**` is just noise in a source buffer.
- **No tl;dr** — the first line is it, per the subject-line rule.
- **`chalk:voice` still decides *what* belongs in the comment**: the current contract, not the story of how the code got here. The mindmap only shapes it.

### Docs pages

- **Same default, applied per section.** A section's steps, conditions or failure modes are followable content and take the tree.
- **The tree doesn't let a section straddle quadrants.** A how-to's numbered steps and an explainer's reasoning are both trees; they still belong in different sections.

## Line format inside a bullet

**Whatever line-break rule the calling skill states, it applies inside a bullet too** — this is where it's most often forgotten.
Like `chalk:voice`, this skill doesn't decide the rule: the skill you came from does, including any project override.

- **Where it's paragraph-per-line**, a bullet's elaboration stays on **one line**. Breaking it sentence-per-line fragments into `<br>` staccato exactly as it would in a paragraph — same trap, new shape.
- **Where it's sentence-per-line**, break inside the bullet as normal.

## Constraints

- Followable content MUST default to a mindmap; prose MUST be a deliberate exception, not a fallback.
- Every parent node MUST be a claim its children back up. A bullet list whose children are merely *related* to the parent MUST be restructured.
- Subject lines MUST carry the argument on their own. Elaboration MUST NOT be load-bearing.
- A tag MUST be meant precisely — `assumption:` and `check:` are claims about verification status, not decoration.
- Typed IDs MUST be stable once published. Renaming or renumbering a node breaks inbound references and MUST be avoided.
- A tl;dr MUST go at the top of the artefact, never the bottom. It is optional in a commit body and MUST NOT appear in a code comment.
- A tl;dr MUST summarise the artefact for its audience, not the work for its author. It MUST be readable by someone who did not see the session, the branch or the prior state.
- Bold emphasis MUST NOT be used in comment markup that is read raw rather than rendered.
