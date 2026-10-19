---
name: root-cause
description: >
  Find why something happened, as a fault tree — a goal tree turned over, with one observed symptom at the root, decomposed one step at a time into the causes that could directly produce it, and each node marked open, confirmed or refuted against evidence.
  Use when the user says "/chalk:root-cause", "RCA", "root cause", "fault tree", "why did X happen", or is investigating an incident or divergence whose cause isn't known; and whenever a debugging session has more than one live hypothesis.
user-invocable: true
argument-hint: "[symptom]"
---

# Chalk Root Cause — Fault Trees

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Load `chalk:goal-tree` first**, and `chalk:voice` with it.
A fault tree is a goal tree turned over:

- **The root is something that happened** that we didn't want, not something we want to happen.
- **The relation is *produces*, not *serves***: each node's children are what could directly have made it true.
- **`chalk:goal-tree`'s "ask what would stop the parent" is the whole method here** — the fault tree is that question, asked of a failure that has already happened, and answered with evidence.

**Success: a path from the symptom down to a single cause is `confirmed` against evidence anyone can check, and every alternative beside it is settled or named as still open.**

`$ARGUMENTS`, if given, describes the symptom.

## An example

```
T open — XT returns row `a` from `events`; Postgres has no row `a`
  Seen: n2
  Not seen: n1, n3
- OR:
  - H1 open — n2 is serving stale data
    - OR:
      - H1.1 open — n2 stopped applying the replica log
      - H1.2 open — n2's query read an earlier basis
  - H2 refuted — Postgres never emitted the DELETE
  - H3 refuted — XT never received the DELETE
  - H4 open — n2 received the DELETE but didn't apply it
    - AND:
      - H4.1 confirmed — a block flush was in flight on n2
      - H4.2 open — n2 closed before the DELETE was applied
```

- **The root, `T`, is the symptom**: something someone observed.
  Beneath it, `Seen:` and `Not seen:` record where the symptom shows and where it doesn't.
- **Every other node is a hypothesis** about why its parent happened.
- **Each parent's children hang under a gate**:
  - **`OR:`** — any one child alone would produce the parent;
  - **`AND:`** — the children produce it only together.
- **Each node has a typed ID, a status, and a one-line subject.** Evidence for it is kept beside the tree (see *The file*).

## The root

**`T` MUST be a single, observed, specific event — the symptom, never a guess at its cause.**

- **Observed**: "XT returns row `a`; Postgres has no row `a`".
  "XT dropped the DELETE" is already a hypothesis, and belongs one level down.
- **Specific**: name the system, the object, the instance and the time, as far as they're known.

**`Seen:` and `Not seen:` are the first evidence to gather.**
They compare places you'd expect to behave the same: other nodes, tables, times, environments, versions.

- **They're the cheapest pruning there is**: a hypothesis that would also produce the symptom where it's `Not seen` is refuted on the spot.
  In the example, H2 and H3 would leave `a` on every node, so `Not seen: n1, n3` refutes both without running a test.
- **An empty `Not seen:` is evidence too**: a symptom seen everywhere refutes hypotheses that are specific to one place.
- **Each entry SHOULD be short** — where it was observed. How it was observed goes in `T`'s evidence.

## Children

**Each child MUST be an immediate cause of its parent.**
Ask "what could *directly* make this node true?", never "what's the root cause?".
A child that skips a step hides the alternatives that lived in that step.

**The gate is `chalk:goal-tree`'s sufficiency test, made explicit.**
Under `OR:`, each child alone, plus what we know about this system, MUST be enough to produce the parent; under `AND:`, the children together MUST be, and each MUST be needed.
As in a goal tree, say the domain knowledge out loud rather than leaning on it silently.

- **After listing a node's children, ask "what else could immediately cause this?"** until the answer is nothing.
  Where the list may still be incomplete, add a child `other — not yet enumerated` with status `open` — the fault tree's `check:`.
- **Children SHOULD be mutually exclusive.** Two that overlap make evidence ambiguous — split them on the difference.
- **MUST NOT add a node that can't physically happen in this system.**
- **Check every new node against `Seen:` and `Not seen:`** as soon as it's written.

**A node needs no children when one probe can settle it.**
A probe is one of `chalk:goal-tree`'s three kinds of leaf, and MUST say which where it isn't obvious:

- **Something we do** — a test, a log query, a code read.
- **Something we need from someone else** — a question to whoever reported it, a log only ops can pull.
  Name who; a question nobody was asked reads as a probe in flight.
- **A fact about the system we're relying on** — tag it `assumption:` until it's verified, because every status above it rests on it.

## IDs

IDs follow `chalk:voice` — stable, never renumbered, and cited with their subject line.
The root is `T`; its children `H1`, `H2`, …; theirs `H1.1`, `H1.2`, …; and so on.

- **A new sibling takes the next unused number. IDs MUST NOT be reused**, even after a node is refuted or removed.
- **"H2 (Postgres never emitted the DELETE) is refuted, H1.1 (n2 stopped applying the replica log) is next"** is a complete message.

## Status

Unlike a goal tree, where done-ness is not the tree's job, **a fault tree's status is its whole content**: it says what the evidence has shown, not how far the work has got.

| Status | Meaning |
|---|---|
| `open` | not settled yet |
| `likely` | evidence points to it, but doesn't settle it |
| `confirmed` | shown to have happened in this incident |
| `possible` | shown to be able to happen, not shown to have happened here |
| `unreproduced` | tried to make it happen, and couldn't — not shown not to have happened here |
| `refuted` | shown not to have happened here |
| `out of scope` | can't produce this symptom, given `Seen:` and `Not seen:` |
| `conflict` | the node's own evidence disagrees with its children |

**Any node can carry evidence, and every status other than `open` MUST cite some.**

- **A node with no children takes its status from its own evidence.**
- **A node with children takes its status from its own evidence where that settles it**, otherwise from its children:
  - an `OR:` is `refuted` once every child is `refuted` or `out of scope`, and `confirmed` once any child is;
  - an `AND:` is `refuted` once any child is, and `confirmed` once every child is.
- **A node keeps its evidence when it gains children.** Evidence about the node as a whole stays on it.
- **When its own evidence and its children disagree, the node is `conflict`**: the tree is wrong somewhere, and that's the next thing to resolve.
- **`possible` is not `confirmed`.** A bug reproduced in a lab stays `possible` until evidence ties it to this incident.
- **`unreproduced` is not `refuted`.** Failing to make it happen in a lab says nothing about whether it happened here.

## The loop

1. **Write `T`**, with its `Seen:` and `Not seen:`.
2. **Add one level of children**, and run the "what else?" check.
3. **Mark what the evidence in hand already settles.**
4. **Pick the next probes** from the open nodes: the cheapest among the likeliest first.
   A question to whoever reported the problem is often the cheapest probe of all.
5. **Run them, record the evidence, update statuses**, and add children to any node that turned out to need them.
6. **Repeat until a path from `T` down to a node with no children is `confirmed`** — that node is the root cause.
   If every branch ends up `refuted`, `T` or the tree is wrong: revisit both.

## From the cause to the fix

**A confirmed root cause is a gap, in `chalk:goal-tree`'s sense, in whatever the system was meant to achieve.**
The fix is a goal tree whose root is that `T` no longer happens, and closing the gap MUST be a deliberate choice from `chalk:goal-tree`'s named moves — prevent it, make it less likely, recover, limit the damage, reassign, weaken the goal, or accept the risk — rather than reflexively patching the confirmed leaf.

- **Every `confirmed` node on the path is a place the fix could go**, not only the deepest.
  In the example, H4 (n2 received the DELETE but didn't apply it) could be fixed at H4.1 or H4.2, or at H4 itself.
- **A `likely` or `possible` node left beside the confirmed path is a second fault the fix doesn't cover**; say so where the fix is written up.
- **Where the work goes on an issue, its confirmed path is the issue's evidence** — write it through `chalk:issue`, and link the file.

## The file

**The tree and its evidence MUST live in one file**, `rca/<slug>.md` in the working directory unless the user names another place, so the investigation survives compaction and handover.
**Its first line is `Investigated per chalk:root-cause — <path>`**, so a session after a compaction knows which skill to reload.

````markdown
Investigated per chalk:root-cause — rca/xt-keeps-deleted-row.md

# XT keeps a row Postgres deleted

```
T open — XT returns row `a` from `events`; Postgres has no row `a`
  Seen: n2
  Not seen: n1, n3
- OR:
  - H1 open — n2 is serving stale data
  - H2 refuted — Postgres never emitted the DELETE
  …
```

## Evidence

### T
- Queried `SELECT * FROM events WHERE _id = 'a'` on each node, 2026-10-02 09:30–09:31: present on n2, absent on n1 and n3.

### H2
- Refuted by `Not seen: n1, n3`: those nodes don't have `a`, so the DELETE reached them.

### H4.1
<details><summary>n2 log, 09:14 — block flush in flight</summary>

```
09:14:02.118 INFO … [cdc] flushing block 12
…
```
</details>
````

- **Evidence MUST be a pointer you can check**: a test and its result, a commit, a log line, a query and its output, a file:line.
- **Long evidence goes in a `<details>` block**, with a summary saying what it shows.
- **In chat, show only what changed**: the updated nodes and the open frontier, not the whole tree again.
