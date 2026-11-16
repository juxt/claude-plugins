# The interleaving

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**A trace of one interleaving, in columns: the shared state, then one per actor.**
`chalk:voice`'s routing chain requires one of anything concurrent, distributed or multi-actor.

- **The shared state the actors contend for MUST take the leftmost column.**
  A row that changes it MUST carry the new state there, and a row that does not MUST leave it blank.

  - **Append-only state accumulates**, so the column reads downwards as the medium itself — `@20 BlockBoundary(4, b7)`, `@21 NoOp(5)`.

  - **Mutable state replaces**, so it reads downwards as a timeline — `held(A)`, `free`, `held(B)`.

- **Where the medium addresses its entries, the address MUST sit in that column beside them.**
  An LSN for anything log-backed, otherwise a sequence number or a lock acquisition.
  It MUST NOT be wall-clock.

- **Each actor MUST take a column, headed with its identity and its initial state.**
  `[A] leading at 4`, `[B] following, fence=4`.
  Its cells carry the local reasoning behind each operation — `poll empty → w`, `5 > 4 → leads@5`.

- **A row MUST hold one operation**, and vertical position carries happens-before.

- **A read MUST cite what it observed** — `r(@20)` against a log, `r(free)` against a lock, `r(x=0)` against a field.
  A read citing anything but the column's latest is a stale read.

- **A row SHOULD carry a label** — `a1`, `b2`: one letter per actor, then a counter.
  Prose MUST cite a row by its label rather than paraphrasing it.

- **An outcome block below the trace SHOULD attribute each resulting field to the row that produced it**, with `←`.
  `termId = 5 ← b4, B's term`, `boundaryReplicaMsgId = 20 ← a1, A's cut`.

- **An actor leaving MUST be a row** — `a3  crash` — changing no shared state.

- **`→` and `:=` MUST keep their meanings inside a cell.**
  `5 > 4 → admitted` is *therefore*; `fence := 5` is a state change.

A promotion finishing a block the previous leader left open:

```
      log                      A (leading@4)      B (following, fence=4)
a1    @20 BlockBoundary(4,b7)  cutting b7 → w
a2                             writes b7's files
b1                                                r(@20) → holds b7's boundary
b2    @21 NoOp(5)                                 poll empty → w
b3                                                r(@21); 5>4 → leads@5
b4    @22 BlockUploaded(b7,5)                     produces b7 → w
a3                             crash
b5                                                r(@22) → adopts b7

persisted b7:  termId               = 5   ← b4, B's term
               boundaryReplicaMsgId = 20  ← a1, A's cut
```
