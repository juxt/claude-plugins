---
name: code-comments
description: What earns a code comment, and what to delete — interface versus implementation comments, the pinned readers, the triggers and the test, and where rejected material goes instead. Load early in any session that touches code, before writing or editing any comment, docstring or kdoc, and again when reviewing a diff, where weeding the comments is part of the review.
user-invocable: true
---

# Chalk Code Comments — What Earns a Comment

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

## Two kinds of comment

**An interface comment says what a caller needs in order to use the thing without reading its body. 
An implementation comment says what the code inside it doesn't already say.**

Their defaults are opposite, and everything below is about implementation comments unless it says otherwise.

- **An interface comment on a public surface exists by default**, and is judged on completeness.
  Parameters, return, errors, preconditions, units, ownership, thread-safety. 
  A caller who has to read the body to find one of those has been failed.
- **A non-public surface takes implementation rules whatever its markup** — a kdoc on a private function still faces the triggers.

## The readers

**An implementation comment's reader is a competent developer on this project, arriving at this line in a year, mid-investigation of a different bug.**
They did not read the commit that added it, do not know a change happened here, and will read this line and the twenty around it — nothing else.

**Simulate that reader before there's a comment on the screen**, not after.

What each clause rules out:

- **"in a year", "did not read the commit"** — they have no referent for the change.
  "Now we…", "instead of…", "this handles the case we hit" say nothing to them.
- **"a different bug"** — they want one fact and they're leaving.
  Orientation, summary and section-label comments cost them and give nothing.
- **"this line and the twenty around it"** — nothing that depends on reading elsewhere.
  No "phase 2 of teardown".

**An interface comment's reader is deciding whether to call this**, from the signature and the doc alone, and will not read the body.

**Every comment you keep is spent out of the attention the next one needs.**
That reader arrived mid-investigation of something else, so they read a few of the comments in front of them and skim the rest — and which few is settled by the density around them rather than by which ones you meant them to stop at. Where four in five are worth stopping for, the fifth gets read too; at one in five, the ordering constraint that would have saved them an afternoon reads like more of the same. So a comment that merely does no harm is not free: its cost is charged to the load-bearing one three lines down. A diff whose added lines run a third comment has already spent that budget, however each one reads on its own.

## The triggers

**An implementation comment MUST answer *yes* to one of these, asked of the code rather than of the comment.** 
None applies → no comment.
One per way the code under-determines what the reader does next.

- **Can a value here be absent or invalid, with nothing in the types saying so?**
- **Is this state reachable from more than one thread, with the discipline that keeps it safe not visible here?**
  A lock the caller holds, a happens-before, why a field is `volatile`.
- **Would a reader reorder these statements?**
  Two adjacent lines whose order matters and whose names don't say so.
- **Is there a constant with no derivation?**
  A timeout, a retry count, a buffer size, a threshold.
- **Is this a workaround for a defect outside this repo?**
  Name it — the library and version, the spec clause, the issue.
- **Would a reader replace this with the obvious implementation?**
  Say what the obvious one is and how it fails.
- **Must a caller do something the signature can't express?**
  A precondition, a required close, an ordering between two calls.
- **Does something here read as an oversight?**
  An empty catch, a discarded return, a branch that deliberately does nothing.
- **Would a reader delete this as unnecessary?**
  A branch, a parameter or a supported case that nothing else in the code motivates.

**A yes is necessary, not sufficient** — the comment still has to pass the test.

## The test

**These are implementation-comment tests.**
An interface comment is judged on completeness for a caller who will not read the body, so a test asking what a reader of the surrounding *code* would get wrong does not apply to it.

**Cover the comment, read the code, and name what the reader would get wrong. Nothing → delete it.**

**Getting it wrong is an edit they make, not a fact they lack.**
Name the change the reader makes without the comment and what it silently breaks — the call they add, the line they move, the branch they delete, the parameter they inline, the constant they tune. "Would wonder why this is here", "wouldn't know that X is specified elsewhere", "would have to go and look" describe a gap in what they know rather than a mistake in what they do, and every comment ever written closes one of those. A test anything can pass sorts nothing.

**No clause of either test is yours to adjudicate** — the reader's derivation decides, not your sense of what's subtle.

**A comment MUST sit at a different level of detail from the code it describes** — higher, saying what the code accomplishes, or lower, giving precision the code omits: units, ranges, boundary conditions, what "empty" means here.
Same level as the code is restatement, and **the red flag is a comment built from the identifiers beneath it**.

**A comment carries what its trigger asked for, and stops.**
The trigger names its own scope: a constant with no derivation buys the derivation, not the case for that value over the one you rejected; "would a reader reorder these" buys the constraint, not an account of what goes wrong when they do. Everything past that is surplus however well it reads, and cutting it is the same judgement as deleting a comment no trigger fired for — most of the length in a reviewed diff is here, in comments that were right to exist and went on afterwards.

**A comment no trigger fires for is deleted, not reduced until it looks proportionate.**
That is how justification survives a pass and comes back shorter. The two cuts look alike, so name which one you are making: scoping a comment the code earned, or shrinking one it didn't.

**Apply them to existing implementation comments too**, and check an existing interface comment for completeness the same way you would a new one.

## Where the rejected material goes

- **Design rationale MUST go in the commit body**, not the source.
  Why the code is allowed to exist, why a surface is shaped as it is, why one option beat another. 
  **An answer to a question raised in review is the case to watch**: it's neither repetition, step-narration nor history, so it passes every other rule here while being precisely what the reader never asks.

- **A comment about the change goes in the commit body** — the reader has no referent for it.
  There it's read once, by someone who wants it. 
  **A comment is durable and carries the current contract**, written as if the code had always been this way; a transition left in the source rots where it sits.
  **The tell is a comparative with nothing on the other side of it** — "rather than", "instead of", "no longer", "used to", a bare "now". Look for the thing being contrasted with: if it isn't in the file, the comment is arguing with a design the reader can't see, and the argument goes to the body. This is the shape that survives every other rule here, because it reads as rationale rather than as history.

- **The journey belongs nowhere.**
  "First tried X, then Y" is the play-by-play a commit body omits too, and the source is the worse place for it. 
  A dead end that closes a road is different: that goes in the body, as rationale.

- **Anything true beyond these twenty lines → the one place that owns it.**
  A pattern's rationale goes at the pattern, once, not re-narrated at every site; a call site's oddity goes at that call site, not as a caller list on the function.

## Reviewing the comments in a diff

**A code review MUST cover the diff's comments as well as its code.**

Per comment in the diff:

1. **Decide which kind it is first**, from the surface's reach.
2. **Interface comment → check completeness**, and never report a deletion for failing a trigger it was never subject to.
3. **Implementation comment → apply the triggers, then the test.**
4. **If nothing, report a deletion.**
5. **If it passes but runs past what its trigger asked for, report the surplus as a cut**, naming the sentence that goes. A review that only ever reports whole comments leaves the long ones untouched, and those are the ones burying the rest.
6. **If it's misfiled rather than wrong, say where it goes** — commit body, canonical place, call site.
7. **Scrutinise the confident ones hardest.** A comment restating a decision in assured prose is the one a reviewer waves through.

## Markup

- **Most comments are one line and stay one line.**
  `// volatile — reads race with the flush thread` doesn't want a bullet.
- **A comment with real structure takes a mindmap** (`chalk:voice`), at a higher threshold than prose.
  More than two or three sentences, or an enumeration the reader has to work through.
- **Match the markup to what the language's tooling renders.**
  KDoc, Javadoc and docstrings are rendered, so bullets and emphasis land as intended. **A comment read raw takes plain `-` and indentation after the comment marker, and MUST NOT use bold.**
- **Sentence-per-line**, per `chalk:voice`.
