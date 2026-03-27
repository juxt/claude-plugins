# Chalk Voice — Writing Principles

Optimise for later reading.

Future developers looking back at commits and issues will not care about the trials and tribulations you went through.
They need to understand *why* a change exists, *why* it was done this way, and what would surprise them.
Consider what you'd explain to those developers and write accordingly.
Remember, "future developers" will likely include "future you".

They can read the diff.
They can read the code.
What they can't reconstruct is what was going on in your head.

## What to capture

- **The problem first**: set up *why this matters* before explaining what you did. The reader needs to understand the situation before the solution makes sense.
- **Decisions and tradeoffs**: why you chose approach X over Y, what constraints drove the choice.
- **Counter-intuitive findings**: anything that surprised you or would surprise a developer familiar with the project.
- **Dead ends**: what didn't work and why — this prevents re-investigation. Include *why* the wrong approach seemed right, not just that it was wrong.
- **Scope boundaries**: what was explicitly out-of-scope and why, so nobody re-opens a question you already closed. If there's a natural "next up", say so.
- **The mental model**: when the change introduces or reshapes a concept, explain the model — what the abstractions are, how they relate, why they're shaped this way. Don't assume the reader already has the mental model you built up while implementing.

## What to omit

- Obvious details self-evident from the diff, the code, or the issue description.
- Play-by-play of mechanical steps ("then I ran the tests", "then I edited the file").
- The journey of how you got there — optimise for the reader, not the writer.

## Examples

**Not this** (restates the diff):
> Made TemporalBounds fields volatile and added a snapshot method that reads both atomically.

**This** (captures the decision):
> Volatile over lock — simpler, lower contention, sufficient for read-mostly pattern.
> Immutable TemporalBounds + AtomicReference would be cleanest but requires changing every call site that mutates bounds — out of scope for a bugfix.

**Not this** (mechanical play-by-play):
> Investigated the flaky test. Found it only failed in the full suite. Added logging to narrow it down. Discovered a race condition in TemporalBounds.intersect().

**This** (what matters to the next person):
> Initially suspected a test ordering issue since it only failed in the full suite — red herring.
> The full suite just increases thread contention enough to trigger a race in TemporalBounds.intersect(), which reads validFrom and validTo non-atomically.

**Not this** (obvious from the diff):
> Added a new `resolveTimeout` parameter to the `QueryConfig` class and threaded it through to the executor.

**This** (why it exists):
> Queries against the Kafka log can stall indefinitely when a partition leader is mid-election.
> A per-query timeout lets callers fail fast rather than blocking on a cluster event they can't control.

**Not this** (abstract hand-waving):
> Updated the type system to better represent logical types, improving the separation between compile-time and run-time representations.

**This** (teaches the mental model, uses concrete examples):
> A logical type is one of: Mono (null, scalar, listy, struct), Maybe (nullable mono), or Poly (set of monos).
> Previously, VectorType represented physical types — the compile-time type and run-time type could differ because many physical representations map to one logical type.
> For physical representations, we now exclusively use Arrow's `Field` class.

**Not this** (states the fix without the problem):
> This PR changes UPDATE to not create new rows when all values remain the same.

**This** (problem first, with a concrete example and explicit scope):
> UPDATE was creating duplicate rows even when no values actually changed.
> Uses type-strict equality — `UPDATE docs SET a = 1.0 WHERE _id = 1` on a doc with `{:a 1}` *will* create a new record because `1 ≠ 1.0`.
> PATCH is out of scope of this PR (see #5030).

## Style

- One sentence per line (no 80-char wrapping).
- Lead with the problem or context, not the solution.
- Use concrete examples — specific scenarios, code snippets, data — to ground the reasoning. Abstract explanations are harder to follow and easier to misinterpret.
- When the reasoning is complex but the change is simple, say so. "Simple change in the end: ..." helps the reader calibrate expectations before looking at the diff.
- Be concise but don't strip out the reasoning — a terse note with no *why* is just as unhelpful as a verbose one.
