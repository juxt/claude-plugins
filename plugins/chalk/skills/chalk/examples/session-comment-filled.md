### Session — 2026-02-18

**Status**: in-progress

- [x] Investigate flaky test in `expression_test`
- [x] Fix root cause: race condition in temporal bounds
- [ ] Add regression test for concurrent temporal queries

<details><summary>Investigate flaky test in expression_test</summary>

Test `can-compare-temporal-bounds` fails intermittently on CI.
Reproduced locally by running with `-Piterations=500`.

Root cause: `TemporalBounds.intersect()` reads `validFrom` and `validTo` non-atomically.
Under concurrent access from the compactor, the bounds can be mid-update.

Initially suspected a test ordering issue since it only failed in the full suite.
That was a red herring — the full suite just increases thread contention enough to trigger the race.

Key files:
- `src/main/kotlin/xtdb/temporal/TemporalBounds.kt:89`
- `src/test/clojure/xtdb/expression_test.clj:342`

</details>

<details><summary>Fix root cause: race condition in temporal bounds</summary>

Made `TemporalBounds` fields volatile and added a snapshot method that reads both atomically.

Considered alternatives:
- **Lock on intersect()**: correct but adds contention on a hot path the compactor calls frequently. Rejected.
- **Immutable TemporalBounds + AtomicReference**: cleanest but requires changing every call site that mutates bounds. Out of scope for a bugfix.
- **Volatile fields + snapshot read**: sufficient here since we only need consistency between the two reads, not mutual exclusion. Lowest risk.

Decision: volatile over lock — simpler, lower contention, sufficient for read-mostly pattern.

</details>

<details><summary>Add regression test for concurrent temporal queries</summary>

Not yet started.
Plan: spin up 4 threads doing overlapping temporal range queries while compactor runs.
Assert no `IllegalStateException` from bounds intersection.

</details>
