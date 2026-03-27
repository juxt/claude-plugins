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

- **Decisions and tradeoffs**: why you chose approach X over Y, what constraints drove the choice.
- **Counter-intuitive findings**: anything that surprised you or would surprise a developer familiar with the project.
- **Dead ends**: what didn't work and why — this prevents re-investigation.
- **Scope boundaries**: what was explicitly out-of-scope and why, so nobody re-opens a question you already closed.

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

## Style

- One sentence per line (no 80-char wrapping).
- Lead with the decision or finding, not the process.
- Be concise but don't strip out the reasoning — a terse note with no *why* is just as unhelpful as a verbose one.
