---
name: voice
description: Shared chalk writing voice — Diataxis quadrants, universal principles, and the issue/PR section palette. The chalk, chalk:commit, chalk:pr and chalk:tend-docs skills load this before drafting any GitHub-bound or docs prose; a human may run it to read the guide.
user-invocable: true
---

# Chalk Voice — Writing Principles

You're reading this because you're about to write something in the chalk voice — a commit body, an issue, a PR description, a docs page.
Draft against this guidance, not your own default prose habits: the defaults read wrong and lose the reasoning the reader actually needs.

Optimise for the reader, not the writer.

Whatever you're writing, the reader is trying to do one of four things: acquire cognition, acquire action, apply cognition, apply action.
[Diataxis](https://diataxis.fr) names these quadrants (explanation, tutorial, reference, how-to) and they apply recursively at every level, from a whole docs site down to a paragraph inside a commit body.

What follows: **universal principles** (apply everywhere), **the four quadrants** (what each is for), **artefacts as compositions** (which quadrants each chalk artefact occupies), and the **issue/PR section palette**.

One thing this skill deliberately does *not* cover: **line-break style** — sentence-per-line vs paragraph-per-line.
That depends on the artefact's destination — whether it's read as a `git diff` or rendered — so the skill you came from (`chalk:commit`, `chalk:pr`, `chalk`, `chalk:tend-docs`) states its own rule.

## Universal principles

These apply to all writing in this plugin's voice.

### Concrete over abstract

Ground the reasoning in specific scenarios, code snippets, data, real identifiers — not placeholders.
Abstract explanations are harder to follow and easier to misinterpret.

Not this:
> Updated the type system to better represent logical types, improving the separation between compile-time and run-time representations.

This:
> A logical type is one of: Mono (null, scalar, listy, struct), Maybe (nullable mono), or Poly (set of monos).
> Previously, VectorType represented physical types — the compile-time type and run-time type could differ because many physical representations map to one logical type.
> For physical representations, we now exclusively use Arrow's `Field` class.

### Lead with the problem or context

Set up *why this matters* before the solution.
The reader needs the situation before the fix makes sense.
This applies across quadrants — a how-to opens with the goal, an explanation opens with what needs explaining, a reference block sits under the concept it references.

### Be concise — but keep the reasoning

A terse note with no *why* is just as unhelpful as a verbose one.
When the reasoning is complex but the change is simple, say so.
"Simple change in the end: ..." helps the reader calibrate.

### Structure what the reader must follow

When you want the reader to *follow* a chain — a sequence of events, a multi-step rationale, a set of conditions — reach for structure (a numbered or bulleted list, a short tree) over a prose paragraph.
Structure lets the reader checkpoint their understanding step by step; a dense paragraph makes them hold the whole thing in their head and trust they reassembled it the way you meant.
Reserve prose for short causal arguments where the connectives ("because", "so", "but only when") carry the meaning and the chain is two or three links long.
This is about the *followable* parts, not the tone — an explanation can read discursively and still lay its reasoning out as steps.

### No marketing fluff

"Powerful", "seamless", "blazing-fast", "revolutionary" — cut them.
State the capability; let the reader draw the conclusion.

### Discover project conventions, don't impose them

Version markers, changelog shapes, file layout, cross-link style — these vary between projects.
Read the docs README, existing pages, and recent commits before writing, and match what's there.

## The four quadrants

Diataxis's axes: **acquisition vs application** × **cognition vs action**.

| | Acquire | Apply |
| --- | --- | --- |
| **Cognition** | Explanation | Reference |
| **Action** | Tutorial | How-to |

### Explanation — acquire cognition

The reader wants to *understand*.
Mental models, why-this-way, decisions, tradeoffs, dead ends, invariants.

**Voice:**
- Discursive.
  Grounded in concrete examples that ground abstractions.
- Lead with the problem or the concept you're explaining.
- Capture the *why*, not the *what* — the reader can see the what elsewhere (the diff, the config, the code).
- Teach the mental model when the change introduces or reshapes a concept.
  Don't assume the reader has the model you built up while implementing.

**What to capture:**
- **The problem first**: why this matters, before what you did.
- **Decisions and tradeoffs**: why X over Y, what constraints drove the choice.
- **Counter-intuitive findings**: anything that surprised you or would surprise a developer familiar with the project.
- **Dead ends**: what didn't work and why — this prevents re-investigation.
  Include *why* the wrong approach seemed right, not just that it was wrong.
- **Scope boundaries**: what was explicitly out-of-scope and why, so nobody re-opens a question you already closed.
  If there's a natural "next up", say so.
- **The mental model**: when the change introduces or reshapes a concept, explain the model — what the abstractions are, how they relate, why they're shaped this way.

**What to omit:**
- Obvious details self-evident from the diff, the code, or the issue description.
- Play-by-play of mechanical steps ("then I ran the tests", "then I edited the file").
- The journey of how you got there — optimise for the reader, not the writer.

**Examples.**

Not this (restates the diff):
> Made TemporalBounds fields volatile and added a snapshot method that reads both atomically.

This (captures the decision):
> Volatile over lock — simpler, lower contention, sufficient for read-mostly pattern.
> Immutable TemporalBounds + AtomicReference would be cleanest but requires changing every call site that mutates bounds — out of scope for a bugfix.

Not this (mechanical play-by-play):
> Investigated the flaky test. Found it only failed in the full suite. Added logging to narrow it down. Discovered a race condition in TemporalBounds.intersect().

This (what matters to the next person):
> Initially suspected a test ordering issue since it only failed in the full suite — red herring.
> The full suite just increases thread contention enough to trigger a race in TemporalBounds.intersect(), which reads validFrom and validTo non-atomically.

Not this (obvious from the diff):
> Added a new `resolveTimeout` parameter to the `QueryConfig` class and threaded it through to the executor.

This (why it exists):
> Queries against the Kafka log can stall indefinitely when a partition leader is mid-election.
> A per-query timeout lets callers fail fast rather than blocking on a cluster event they can't control.

Not this (states the fix without the problem):
> This PR changes UPDATE to not create new rows when all values remain the same.

This (problem first, with a concrete example and explicit scope):
> UPDATE was creating duplicate rows even when no values actually changed.
> Uses type-strict equality — `UPDATE docs SET a = 1.0 WHERE _id = 1` on a doc with `{:a 1}` *will* create a new record because `1 ≠ 1.0`.
> PATCH is out of scope of this PR (see #5030).

### How-to — apply action

The reader has a goal and wants to *achieve it*.
Deployment, configuration, integration, a specific operational task.

**Voice:**
- Goal stated up top: "To do X, ...".
- Numbered, imperative steps.
- Terse — no narrative padding.
- Concrete identifiers, not placeholders (`my-kafka`, not `cluster-name`).
- Prerequisites and assumptions stated before the steps, not mid-flow.
- A closing "you should now see …" check, so the reader knows whether it worked.

How-tos don't teach — they assume the reader already has enough cognition to recognise the steps.
If the reader needs to *understand* something first, that's an explanation, and it belongs in a different section (or a different page).

### Reference — apply cognition

The reader is working and needs to *look something up*.
A CLI flag, an API signature, a config key, a SQL clause.

**Voice:**
- Neutral, exhaustive, structured.
- Tables, definition lists, grammar productions.
- No narrative, no "we"/"you".
- Alphabetised or structurally ordered (not narratively ordered).
- Complete — every flag, every field, every case.
- **Keep rationale out of the body.** This is the one quadrant where chalk's usual "always capture the why" does not apply inline. 
  The *why* — tradeoffs, motivation, upgrade story — belongs in an adjacent explanation section or changelog block, not next to the definition. 
  A reader looking up a flag wants the semantics, not the story behind it.

Reference is unforgiving: if it's incomplete, the reader gets burned.
Better to generate it from the source of truth (schema, CLI help, spec) than to hand-write and drift.

Watch for rationale that drifts in unnoticed — phrases like *"This exists for compatibility with..."*, *"These functions are provided so that..."*, *"This was added because..."* are explanation quadrant sentences wearing reference clothing.
Strip them, or relocate them to the adjacent changelog or explainer.

### Tutorial — acquire action

The reader is new and wants to *learn by doing*.
A guided first experience.

**Voice:**
- Gentle pacing, small wins, hand-holding.
- "You should see X" after each step, so the reader can confirm progress.
- Friendly and reassuring — confidence-building.
- Single working path — no branching ("or you could do Y"), no optionality.
- Ends with a clear next step ("now that you've done X, try Y").

Tutorials are the hardest quadrant to get right.
Explanation can be shortened; reference can be incomplete; a bad tutorial *strands the reader* and they don't come back.

## Artefacts as compositions

Most things you write aren't one quadrant — they're a composition.
Each paragraph, section, or code block does one quadrant's job; don't blur them.

**Commit bodies** are **explanation** artefacts, end-to-end.
The diff is the code change, not a reference section inside the commit.
Open with the problem (explanation framing), deliver the reasoning (explanation payload).

**Issue descriptions** are **explanation** artefacts, with reference-shaped evidence embedded (log excerpts, stack traces, block dumps).
The evidence is illustrative material inside the explanation; it's not a separate reference section.

**PR descriptions** are **explanation** artefacts.
Context, decisions, tradeoffs, dead ends, scope — all explanation.
Usage examples, test-plan checklists, and commit lists have a reference *shape* but they're illustrations embedded in explanation, not standalone reference.

**Docs pages** play all four.
Each page leans toward one quadrant at the top level; sections within it may hit other quadrants.
A how-to page often has a short explanation intro (what this setup is for), numbered steps (how-to), a commented config block (reference), and a closing section on failure modes (explanation).
Each section does one quadrant's job; they don't blur together.

The test isn't "where does this page live?"
It's "what is *this paragraph/section* for?"

## Writing issue and PR descriptions

Issue and PR descriptions are **explanation** artefacts (see the quadrants above).
The reader needs to understand *why* this matters and *why* the approach is shaped this way.

Common sections — all explanation, with reference-shaped evidence embedded where useful:

- **Summary** — one or two sentences on what's happening.
- **Context / Motivation** — how was this observed, or why does this matter? Environment, deployment, test configuration, links to CI runs, logs, dashboards, prior PRs, the broader initiative. Often the most valuable section — without it, a reader can't assess whether the issue applies to them or where a PR fits.
- **Symptoms** (bugs / incidents) — observable behaviour, error messages, affected conditions (e.g. "multi-writer only", "under chaos monkey testing"). Evidence-shaped.
- **Root cause / Analysis** (bugs / incidents) — why it's happening, grounded in evidence (log excerpts, stack traces, block file analysis, annotated offset tables).
- **Evidence** (bugs / incidents) — concrete artefacts: replica log dumps, application log excerpts with timestamps, block file contents, message type distributions. Annotate them — raw dumps without explanation are noise.
- **Current state** (refactors / features) — a concrete sketch of what exists today, in enough detail that the gap to the future state is visible. Reference-shaped: name the specific types, functions, flags, or files that the change touches.
- **Future state** (refactors / features) — the target end state. What the new world looks like once the change is shipped. Concrete and structural — the reader should be able to picture the resulting code or system shape from this section alone.
- **Invariants / Constraints** — non-obvious things the solution must preserve.
- **Out of scope** — what's explicitly not in this change, with reasons. Reference related issues/PRs that pick those pieces up.
- **Alternatives considered** — other designs or approaches at the same level of abstraction as the chosen one, with a sketch of each and the trade-offs that ruled it in or out. Dated rejections ("Rejected on 2026-05-23 because …") help the next reader who's tempted to reopen the question. Implementation-strategy choices (refactor-in-place vs. parallel impl, big-bang vs. incremental) aren't alternatives at this level — they belong in Implementation.
- **Decision rationale** — compare the chosen approach against each alternative on the points that differentiate them. Reads as a side-by-side, not a re-summary of the chosen approach.
- **Implementation** — direction and high-level plan for an issue; what landed for a PR. Step-by-step granular execution (which sub-task next, what files to touch) belongs in the chalk comment, not here.

PRs additionally draw from:

- **Usage** (user-visible features) — concrete examples (SQL queries with realistic output, CLI invocations, config snippets).
  Show what the feature looks like.
  This is also where any **manual steps to adopt the change** belong — a PR is how the team learns the change exists, so if using it requires a teammate to run a migration, set a config value or env var, enable a flag, regenerate something, or observe a deploy-order constraint, spell those steps out.
  If a reader can't act on the change without a step that isn't in the diff, the step goes here.
- **Changes** (multi-commit) — a numbered list of commits with a sentence each, so the reviewer knows the intended reading order.
- **Implementation notes** — grouped by sub-concern, not a flat list. Non-obvious design choices, key invariants, counter-intuitive bits.
- **Dead ends** — "tried X, didn't work because Y" prevents the reviewer from suggesting X.
- **Test plan** — what was tested and how.

Not every description needs all of these.
A flaky test issue might just need the failure mode, stack trace, and conditions.
A small bugfix PR might just need summary and test plan.
A large feature PR might need context, usage examples, implementation notes, and scope.
A refactor PR should call out that behaviour is intentionally preserved.
Use judgement.

### Annotated traces for sequencing bugs

When the bug *is* an ordering — a race, a leadership transition, a distributed-log divergence — the explanation **is** the sequence of events.
Prose describing that sequence is much harder to follow than the sequence itself; a raw log dump is the opposite failure — all the data, none of the causality, so it reads as noise.

Reconstruct a chronological trace and annotate it.
Name the actors (`[A]`/`[B]`, leader/follower) rather than "the node" — the reader is tracking several at once.
Show the load-bearing state inline as it changes, mark the point where things diverge, and end at the failure.
Distil from a real trace (a captured log, a debugger session) down to the events that carry the causality; drop everything else.

A multi-actor race told this way lands in a way a paragraph can't:

```
TERM 1 — node A is leader:
  leader ← source 0..4             [A] watermark → 4   (local, NOT replicated)
  leader → replica: ResolvedTx     [B] follower stays at -1   ← B never sees A's progress

FLIP: A → follower (keeps src=4),  B → leader
  B resumes from -1 (its own stale watermark) → re-reads source 0 → emits BlockBoundary(src=0)

FAILURE — follower A applies it:   notifyMsg(0) while watermark=4   →   0 < 4, throws
```

### Ordering

Sections roughly flow: **setup → state → decision → plan**.

- **Setup**: Summary, Context / Motivation. The why-we're-here.
- **State**: Current state and Future state (refactors / features); Symptoms, Root cause, Evidence (bugs / incidents). The what-it-looks-like, today and at completion.
- **Decision**: Out of scope, Alternatives considered, Decision rationale, Invariants / Constraints. The why-this-path-and-not-others.
- **Plan**: Implementation, and (for PRs) Test plan. At the end.

The explanation-quadrant material (why this, why this way) sits above the reference-shaped step list.
A reader who only scans the top of the issue should still understand the *what* and *why*; the *how* lives at the bottom.
