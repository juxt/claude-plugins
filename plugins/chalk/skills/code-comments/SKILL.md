---
name: code-comments
description: What earns a code comment, and what to delete — the pinned reader, the usefulness test, and where rejected material goes instead. Load early in any session that touches code, before writing or editing any comment, docstring or kdoc, and again when reviewing a diff, where weeding the comments is part of the review.
user-invocable: true
---

# Chalk Code Comments — What Earns a Comment

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

## The reader

**A competent developer on this project, arriving at this line in a year, mid-investigation of a different bug.**
They did not read the commit that added it, do not know a change happened here, and will read this line and the twenty around it — nothing else.

**Simulate that reader before there's a comment on the screen**, not after.

What each clause rules out:

- **"in a year", "did not read the commit"** — they have no referent for the change.
  "Now we…", "instead of…", "this handles the case we hit" say nothing to them.
- **"a different bug"** — they want one fact and they're leaving.
  Orientation, summary and section-label comments cost them and give nothing.
- **"this line and the twenty around it"** — nothing that depends on reading elsewhere.
  No caller lists, no "phase 2 of teardown", no re-narrating a pattern's rationale at each site.

## Don't answer questions the reader won't ask

**A comment MUST carry a concept that does not manifest in the code constructs around it, and that the reader could not easily derive by reading them.**
**No clause of that is yours to adjudicate** — the reader's derivation decides, not your sense of what's subtle.

- **A comment MUST NOT justify the code's existence, or defend a choice that reader would have made unprompted.**
- **A comment MUST NOT restate the code, echo the function name or narrate the steps.**
- **Justifying a choice is right where the question is one they'd genuinely ask.**
  "Why support X as well as Y?" earns a comment where nothing in the code suggests Y is needed; it doesn't where the question only occurs to someone who just finished deciding it.

## The test

**Cover the comment, read the code, and name what the reader would get wrong. Nothing → delete it.**

**A comment that fails MUST be deleted, not shortened.**
Reaching for a length budget instead is how justification survives a pass and comes back trimmed — so if you're rewriting a comment for the second time, apply the test rather than the budget.

**Apply it to existing comments too** — docstrings, kdoc, javadoc and doc attributes included.

## What survives, and only where the code can't show it

- A non-obvious constraint or invariant — "may be mutated by…", "the obvious solution is X, but that fails because Y".
- A gotcha or edge case — "can be null if…".
- A stated precondition, or a threading and locking discipline.
- A link to issue or external context — "see #1234", "per RFC 7231 §6.5.1".
- A warning about subtle behaviour that would trip up *that* reader.
- Rationale for a choice the reader would otherwise undo — the one needing the test applied hardest.

**These are instances of what the code can't show, not licences.**
A comment matching one of these shapes still has to pass the test.

## Where the rejected material goes

- **Design rationale MUST go in the commit body**, not the source.
  Why the code is allowed to exist, why a surface is shaped as it is, why one option beat another. **An answer to a question raised in review is the case to watch**: it's neither repetition, step-narration nor history, so it passes every other rule here while being precisely what the reader never asks.

- **A comment about the change goes in the commit body** — the reader has no referent for it.
  There it's read once, by someone who wants it. See "Transitions vs. current state" in `chalk:voice`.

- **Anything true beyond these twenty lines → the one place that owns it.**
  A pattern's rationale goes at the pattern, once, not re-narrated at every site; a call site's oddity goes at that call site, not as a caller list on the function.

## You're not writing to impress anyone

A comment defending a choice **advertises diligence** — the same move as ranking your own material — and it reads as care, which is exactly why it survives review.

## Reviewing the comments in a diff

**A code review MUST cover the diff's comments as well as its code.**

Per comment in the diff:

1. **Apply the test.**
2. **If nothing, report a deletion** — not a rewrite, and not "make it shorter".
3. **If it's misfiled rather than wrong, say where it goes** — commit body, canonical place, call site.
4. **Scrutinise the confident ones hardest.** A comment restating a decision in assured prose is the one a reviewer waves through.

## Markup

- **Most comments are one line and stay one line.**
  `// volatile — reads race with the flush thread` doesn't want a bullet.
- **A comment with real structure takes a mindmap**, at a higher threshold than prose, with markup depending on whether the language's tooling renders it — see the code-comment rules in `chalk:mindmap`.
- **Sentence-per-line**, per `chalk:voice`.
