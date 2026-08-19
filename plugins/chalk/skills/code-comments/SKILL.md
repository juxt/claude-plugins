---
name: code-comments
description: What earns a code comment, and what to delete — the reader model, the counter-intuition test, and where rejected material goes instead. Load early in any session that touches code, before writing or editing any comment, docstring or kdoc, and again when reviewing a diff, where weeding the comments is part of the review.
user-invocable: true
---

# Chalk Code Comments — What Earns a Comment

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

## When to load this

**The comment that needs stopping never feels tricky — it feels like diligence**, so this is not a skill to reach for once you've decided a comment is hard.
The failure is writing one without consulting anything, not failing to find the rules.
Load it, unprompted, at four moments:

- **Early in any session that will write or change code.**
  Not at the moment you type `//` — by then you've decided.
- **Before writing or editing any comment**, docstring, kdoc, javadoc or doc attribute.
  Editing counts: a comment you're shortening is one you've decided to keep.
- **When reviewing a diff**, over its comments as well as its code.
- **Before writing a commit body**, which is where most of what this rejects belongs. `chalk:commit` loads it for you.

## The reader

**A reasonable, competent senior developer who knows this language and this codebase, reading the code in front of them.**
Not a novice, not a stranger to the project — and not you, five minutes after deciding something.

## Don't answer questions the reader won't ask

**Comments are for the *counter*-intuitive**: what that reader wouldn't have thought of, and why you couldn't do it the way that's obvious to them.

- **If they'd have written the same code for the same reasons, it needs no justification.**
  A choice they'd make unprompted is not a choice that needs defending.
- **Justifying a choice is right where the question is one they'd genuinely ask.**
  "Why support X as well as Y?" earns a comment where nothing in the code suggests Y is needed; it doesn't where the question only occurs to someone who just finished deciding it.
- **"Counter-intuitive" is the word that leaks**, because the author decides what counts — and having just thought hard about something is what makes it feel counter-intuitive to them and obvious to everyone else.

## The test

**Cover the comment, read the code, and name what the reader would get wrong. Nothing → delete it.**

A comment that fails wants deleting, not shortening.
Reaching for a length budget instead is how justification survives a pass and comes back trimmed — so if you're rewriting a comment for the second time, apply the test rather than the budget.

## What survives, and only where the code can't show it

- A non-obvious constraint or invariant — "may be mutated by…", "the obvious solution is X, but that fails because Y".
- A gotcha or edge case — "can be null if…".
- A stated precondition, or a threading and locking discipline.
- A link to issue or external context — "see #1234", "per RFC 7231 §6.5.1".
- A warning about subtle behaviour that would trip up *that* reader.
- Rationale for a genuinely counter-intuitive choice — the one needing the test applied hardest.

**These are instances of what the code can't show, not licences.**
A comment matching one of these shapes still has to pass the test.

## Where the rejected material goes

Most of it isn't waste, it's misfiled.

- **Design rationale → the commit body.**
  Why the code is allowed to exist, why a surface is shaped as it is, why one option beat another. **An answer to a question raised in review is the case to watch**: it's neither repetition, step-narration nor history, so it passes every other rule here while being precisely what the reader never asks.
- **What the code used to do → the commit that changed it.**
  Comments carry the *current contract*, written as if it had always been so (see "Transitions vs. current state" in `chalk:voice`). A comment that only lands as a contrast with the previous code rots at the next refactor.
- **A pattern's rationale → the pattern's canonical place**, once.
  Not re-narrated at every site. A `close()` that closes things needs no comment, nor a "phase 2 of teardown" label.
- **A specific call site's oddity → that call site.**
  Not a caller list on the function. Document the function's own contract; the contract is stable, the call graph isn't, so a caller list becomes a lie or a chore.

## You're not writing to impress anyone

This is specification register turned on the code rather than the prose.
A comment defending a choice **advertises diligence** — the same move as ranking your own material — and it reads as care, which is exactly why it survives review.
A respected colleague states the constraint and moves on.

## Reviewing the comments in a diff

**Weeding is part of the review, not a tidy-up afterwards**: deleting a comment costs nothing at review time and never happens later.

Per comment in the diff:

1. **Apply the test.**
2. **If nothing, report a deletion** — not a rewrite, and not "make it shorter".
3. **If it's misfiled rather than wrong, say where it goes** — commit body, canonical place, call site.
4. **Scrutinise the confident ones hardest.** A comment restating a decision in assured prose is the shape this skill exists to stop, and the one a reviewer waves through.

## Markup

- **Most comments are one line and stay one line.**
  `// volatile — reads race with the flush thread` doesn't want a bullet.
- **A comment with real structure takes a mindmap**, at a higher threshold than prose, with markup depending on whether the language's tooling renders it — see the code-comment rules in `chalk:mindmap`.
- **The calling skill's line-break rule doesn't apply** — comments are read in-source. Terse, why-first and concrete still do.

## Constraints

- A comment MUST carry something that reader could not derive from the code in front of them.
- A comment MUST NOT justify the code's existence, or defend a choice that reader would have made unprompted.
- A comment failing the test MUST be deleted, not shortened.
- Design rationale, and any answer to a question raised in review, MUST go in the commit body rather than the source.
- A comment MUST describe the current contract; "used to be" narration MUST NOT appear in source.
- A comment MUST NOT restate the code, echo the function name, narrate the steps, or list a function's callers.
- A code review MUST cover the diff's comments, and MUST report a failing one as a deletion.
