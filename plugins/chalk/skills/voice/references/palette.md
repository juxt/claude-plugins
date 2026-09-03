# The issue and PR section palette

Issue and PR descriptions are **explanation** artefacts with reference-shaped evidence embedded where useful.

Not every description needs every section.
A flaky test issue might need only the failure mode, stack trace and conditions; a small bugfix PR only a summary and test plan; a large feature PR context, usage examples, implementation notes and scope.
A refactor PR SHOULD call out that behaviour is intentionally preserved.

## The sections

- **Summary**
  One or two sentences on what's happening. Largely redundant where the body opens with a tl;dr — drop it, or hold it to those one or two sentences rather than letting it grow into what the tl;dr already carries.

- **Context / Motivation**
  How was this observed, or why does this matter? Environment, deployment, test configuration, links to CI runs, logs, dashboards, prior PRs, the broader initiative.

- **Symptoms** (bugs / incidents)
  Observable behaviour, error messages, affected conditions ("multi-writer only", "under chaos monkey testing"). Evidence-shaped.

- **Root cause / Analysis** (bugs / incidents)
  Why it's happening, grounded in evidence — log excerpts, stack traces, block file analysis, annotated offset tables.

- **Evidence** (bugs / incidents)
  Concrete artefacts: replica log dumps, application log excerpts with timestamps, block file contents, message type distributions. **Annotate them** — raw dumps without explanation are noise.

- **Current state** (refactors / features)
  A concrete sketch of what exists today, in enough detail that the gap to the future state is visible. Reference-shaped: name the specific types, functions, flags or files the change touches.

- **Future state** (refactors / features)
  The target end state, concrete and structural — the reader should be able to picture the resulting code or system shape from this section alone. Takes a **goal tree** (`chalk:goal-tree`), not a plain list.

- **Invariants / Constraints**
  Non-obvious things the solution must preserve.

- **Out of scope**
  What's explicitly not in this change, with reasons. Reference the issues or PRs that pick those pieces up.

- **Alternatives considered**
  Other designs at the same level of abstraction as the chosen one, with a sketch of each and the trade-offs that ruled it in or out. Dated rejections ("Rejected on 2026-05-23 because …") help the next reader. Implementation-strategy choices (refactor-in-place vs. parallel impl, big-bang vs. incremental) aren't alternatives at this level — they belong in Implementation.

- **Decision rationale**
  Compare the chosen approach against each alternative on the points that differentiate them. Reads as a side-by-side, not a re-summary of the chosen approach.

- **Implementation**
  Direction and high-level plan for an issue; what landed for a PR. Step-by-step granular execution — which sub-task next, what files to touch — belongs in the chalk comment, not here. Shape it as a **goal tree** (`chalk:goal-tree`), and name whose each item is: **an expectation of someone else, written like a task, is a dependency nobody owns**.

## PRs additionally draw from

- **Usage** (user-visible features)
  Concrete examples — SQL queries with realistic output, CLI invocations, config snippets. This is also where any **manual steps to adopt the change** belong: if using it requires a teammate to run a migration, set a config value or env var, enable a flag, regenerate something, or observe a deploy-order constraint, spell those steps out. **If a reader can't act on the change without a step that isn't in the diff, the step MUST go here.**

- **Rollout / compatibility**
  When the change is only safe under conditions the diff can't express: a deploy order, a mixed-version window, an "upgrade the whole fleet to X before enabling Y" constraint. State which versions interoperate and the safe sequence. Distinct from Usage — Usage is how to *use* the feature; this is how to *land* it without breaking a running system.

- **Changes** (multi-commit)
  A numbered list of commits with a sentence each, so the reviewer knows the intended reading order.

- **Implementation notes**
  Grouped by sub-concern, not a flat list. Non-obvious design choices, key invariants, counter-intuitive bits.

- **Dead ends**
  "Tried X, didn't work because Y" prevents the reviewer from suggesting X.

- **Test plan**
  What was tested and how.

## Ordering

Sections roughly flow **setup → state → decision → plan**.

- **Setup** — Summary, Context / Motivation. The why-we're-here.
- **State** — Current state and Future state (refactors / features); Symptoms, Root cause, Evidence (bugs / incidents). The what-it-looks-like, today and at completion.
- **Decision** — Out of scope, Alternatives considered, Decision rationale, Invariants / Constraints. The why-this-path-and-not-others.
- **Plan** — Implementation, and for PRs Test plan. At the end.

The explanatory material (why this, why this way) sits above the reference-shaped step list.

## Annotated traces for sequencing bugs

When the bug *is* an ordering — a race, a leadership transition, a distributed-log divergence — the explanation **is** the sequence of events.
Prose describing that sequence is much harder to follow than the sequence itself; a raw log dump is the opposite failure — all the data, none of the causality, so it reads as noise.

Reconstruct a chronological trace and annotate it.
Name the actors (`[A]`/`[B]`, leader/follower) rather than "the node".
Show the load-bearing state inline as it changes, mark the point where things diverge, and end at the failure.
Distil from a real trace (a captured log, a debugger session) down to the events that carry the causality; drop everything else.

```
TERM 1 — node A is leader:
  leader ← source 0..4             [A] watermark → 4   (local, NOT replicated)
  leader → replica: ResolvedTx     [B] follower stays at -1   ← B never sees A's progress

FLIP: A → follower (keeps src=4),  B → leader
  B resumes from -1 (its own stale watermark) → re-reads source 0 → emits BlockBoundary(src=0)

FAILURE — follower A applies it:   notifyMsg(0) while watermark=4   →   0 < 4, throws
```
