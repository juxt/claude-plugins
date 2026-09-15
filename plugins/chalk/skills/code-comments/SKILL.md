---
name: code-comments
description: What earns a code comment, and what to delete — the default of silence, the moves that dissolve a comment before you write it, the exceptions that earn one, the pinned readers and the test, and where rejected material goes instead. Load early in any session that touches code, before writing or editing any comment, docstring or kdoc, and again when reviewing a diff, where weeding the comments is part of the review.
user-invocable: true
---

# Chalk Code Comments — What Earns a Comment

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

## You SHOULD NOT write any code comments

**The code is the artefact; a comment is a second copy of part of it that nothing verifies.**
No compiler checks it, no test fails when it drifts, and a reader who trusts a stale comment ends up worse off than one who had nothing.
Everything below this section is the narrow set of cases where that cost is worth paying.

- **Where a comment is tempting, change the code instead.**
  Kernighan and Plauger's rule from *The Elements of Programming Style* is still the first move: don't comment bad code — rewrite it.
  The [Linux kernel coding style](https://www.kernel.org/doc/html/latest/process/coding-style.html) puts the same thing as a prohibition — never explain in a comment how your code works, because it is better to write code whose working is obvious.

- **The reader already assumes you chose this deliberately and with care.**
  They apply Chesterton's fence before they touch it, so you MUST NOT spend a comment defending the code against a reader who was never sceptical.
  Explaining a constraint the reader can't see is a different act from justifying yourself, and only the first has an audience.

- **A comment that does survive is a Chalk artefact.**
  It MUST be written in the chalk voice — `chalk:voice` carries the register, the audience and the rule that two propositions in a relation take a mindmap rather than prose.

## Interface comments are the standing exception

**An interface comment says what a caller needs in order to use the thing without reading its body.
An implementation comment says what the code inside it doesn't already say.**

The default above is about implementation comments, and so is everything below unless it says otherwise.

- **An interface comment on a public surface exists by default**, and is judged on completeness rather than on necessity.
  Parameters, return, errors, preconditions, units, ownership, thread-safety — Diátaxis *reference*, held to the standard of Javadoc's own doc-comment conventions.
  A caller who has to read the body to find one of those has been failed.
  You SHOULD NOT document what the signature already expresses.

- **A non-public surface takes the implementation rules whatever its markup.**
  A comment on a private function still has to earn its place.

- **An obligation the signature can't express belongs here and nowhere else.**
  A precondition, a required close, an ordering between two calls.

## Three moves that dissolve a comment

**Each removes the need for the comment rather than shortening it, and you MUST exhaust them before writing one.**

- **Rename the thing.**
  Before describing a variable, a parameter or a function, try a name that makes the description unnecessary.
  A comment saying what `n` holds is a naming decision deferred; `retryBudgetMs` needs no comment at all.

- **Simplify the code.**
  **If what you've written is the simplest way of satisfying the constraints, it doesn't need a comment.**
  If it isn't the simplest way, make it as simple as possible (but no simpler) and the comment goes with it.
  Only where the simple version genuinely fails a constraint does a comment become the right answer — and then it names the constraint, not the mechanism.

- **Move it to the place that owns it.**
  Anything true beyond these twenty lines goes to the one place that owns it, once.
  A pattern's rationale goes at the pattern, not re-narrated at every site that uses it.
  **A caller's constraints and foibles get documented at that caller**; you SHOULD NOT restate them in the callee, which MAY refer to them and nothing more.
  A callee that carries a caller's list is wrong the moment a second caller arrives, and nothing will tell you.

## What earns an implementation comment

**One of these MUST apply, asked of the code rather than of the comment.**
None applies → no comment.
A yes is necessary, not sufficient: the comment MUST still pass the test below.

- **The order of two mutating operations is critical, and non-obvious to an experienced engineer.**
  Non-obvious is the load-bearing half — an experienced reader already knows you close before you flush, and a comment saying so costs them a read for nothing.
  What earns it is an order enforced by something they can't see from here: a listener that fires on the first write, a field the second call reads back, a lock whose scope ends between the two.

- **State here is reachable from more than one thread, and the discipline that keeps it safe isn't visible.**
  Which lock the caller holds, the happens-before that makes the read safe, why a field is `volatile`.
  **A race the code avoids is invisible by construction** — the reader sees only code that works, so nothing warns them that the obvious edit reintroduces it.

- **The simplest code isn't sufficiently performant, and this is what replaced it.**
  Name the simple version and how it failed: the measurement, the input size, the allocation profile.
  Without that the next reader simplifies it back, correctly by every other standard they hold.

- **A value can be absent or invalid with nothing in the types saying so.**
  **You MUST NOT comment what the type system already prevents** — Kotlin's nullability, a sealed hierarchy's exhaustiveness, a newtype's invariant.
  A competent developer reads the types, and a comment restating them goes stale the moment the signature changes.
  This fires only where the types are silent: a `String` that must be an absolute URL, an `Int` that must be positive, a field the constructor leaves unset.

- **It's a workaround for a defect outside this repo.**
  Name the library and version, the spec clause, the upstream issue, and what tells you it can go.

- **It deliberately deviates from what the surrounding code does.**
  The reader's prior is the local convention, so a one-off that contradicts it reads as an oversight rather than a decision.

- **It implements a published algorithm or wire format.**
  Name it and cite it: the reader gets the whole literature for one line, where the alternative is re-deriving it from the loop.

- **It reads as an oversight.**
  An empty catch, a discarded return, a branch that deliberately does nothing.

- **A reader would delete it, and something not visible here would break.**
  A branch, a parameter or a supported case that nothing nearby motivates.

## Cite the card or the PR

**Where the code is as it is because of a bug or a performance problem that was carded, or a PR whose description set out the rationale, the comment MUST carry that number.**

- **The reference is worth more than anything that fits on the line.**
  It gives the reader the reproduction, the measurements, the discussion, the related cards and the history — and, crucially, whether any of it is still true.

- **It replaces the explanation rather than accompanying it.**
  One clause naming what breaks, then the reference: `// serialised — a concurrent flush corrupts the index (#4821)`.

- **Anything deferred takes the Google style guides' TODO convention**: the marker, then a tracked issue, then the explanatory clause.
  A TODO with no issue behind it is a comment nobody will ever act on.

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

## The test

**These are implementation-comment tests.**
An interface comment is judged on completeness for a caller who will not read the body, so a test asking what a reader of the surrounding *code* would get wrong does not apply to it.

**Cover the comment, read the code, and name what the reader would get wrong. Nothing → delete it.**

**No clause of the test is yours to adjudicate** — the reader's derivation decides, not your sense of what's subtle.

**A comment MUST sit at a different level of detail from the code it describes**
Higher, saying what the code accomplishes, or lower, giving precision the code omits: units, ranges, boundary conditions, what "empty" means here.
This is Ousterhout's rule from *A Philosophy of Software Design*: a comment that repeats the code's own level of detail has added nothing to it.
Same level as the code is restatement, and **the red flag is a comment built from the identifiers beneath it**.

**Consider first deleting a comment that fails, not just shortening it.**
Reaching for a length budget instead is how justification survives a pass and comes back trimmed — so if you're rewriting a comment for the second time, apply the test rather than the budget.

**Apply all of this to existing implementation comments too**, and check an existing interface comment for completeness the same way you would a new one.

## Where the rejected material goes

- **Design rationale MUST go in the commit body**, not the source.
  Why the code is allowed to exist, why a surface is shaped as it is, why one option beat another.
  **An answer to a question raised in review is the case to watch**: it's neither repetition, step-narration nor history, so it passes every other rule here while being precisely what the reader never asks.

- **A comment about the change goes in the commit body** — the reader has no referent for it.
  There it's read once, by someone who wants it.
  **A comment is durable and carries the current contract**, written as if the code had always been this way; a transition left in the source rots where it sits.

- **The journey belongs nowhere.**
  "First tried X, then Y" is the play-by-play a commit body omits too, and the source is the worse place for it.
  A dead end that closes a road is different: that goes in the body, as rationale.

## Reviewing the comments in a diff

**A code review MUST cover the diff's comments as well as its code.**

Per comment in the diff:

1. **Decide which kind it is first**, from the surface's reach.
2. **Interface comment → check completeness**, and never report a deletion for failing an exception it was never subject to.
3. **Implementation comment → check it against the exceptions, then the test.**
4. **If nothing fires, report a deletion.**
5. **If a move would dissolve it, say which** — the rename, the simplification, or the place that owns it.
6. **If it's misfiled rather than wrong, say where it goes** — commit body, canonical place, call site, card.
7. **Scrutinise the confident ones hardest.** A comment restating a decision in assured prose is the one a reviewer waves through.

## Markup

- **Most comments are one line and stay one line.**
  `// volatile — reads race with the flush thread` doesn't want a bullet.

- **A comment with real structure takes a mindmap** (`chalk:voice`), at a higher threshold than prose.
  The threshold is higher because the reader is mid-investigation of something else: a comment they must page in wholesale to discover it was irrelevant has cost them more than it can repay.
  More than two or three sentences, or an enumeration the reader has to work through.

- **Match the markup to what the language's tooling renders.**
  KDoc, Javadoc and docstrings are rendered, so bullets and emphasis land as intended. 
  **A comment read raw takes plain `-` and indentation after the comment marker, and MUST NOT use bold.**

- **Sentence-per-line**, per `chalk:voice`, perhaps contrary to column limits - diffs containing the comment will then be shorter and easier to read.
