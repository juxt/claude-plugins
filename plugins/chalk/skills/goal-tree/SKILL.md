---
name: goal-tree
description: Write the goal as a goal tree — a tree whose children accomplish their parent rather than argue for it, the notation of a KAOS goal model, with each node tested for sufficiency. Load whenever writing something with a goal structure in it — the direction or target end state of a piece of work, an issue's Potential approach section, the shape of a problem, or a plan. Covers the shape, the `C<n>`/`A<n>` annotations on the node they bound, where the tree sits in an issue, and linking a child to its issue. The chalk:issue skill loads it alongside chalk:voice.
user-invocable: true
---

# Chalk Goal Trees

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

A goal tree is a mindmap whose relation is **serves**, not **supports**.
Load `chalk:voice` first — its tree rules, tags and typed IDs apply here unchanged.

**A goal tree is a KAOS goal model** (van Lamsweerde, *Requirements Engineering*, 2009), in its terms: complete refinement, requirement, expectation, domain property, obstacle, and the obstacle-resolution tactics.

## The shape

**The root is the goal.**
Each node's children are what it takes to achieve it, recursively, down to leaves that are directly actionable.

**Every node's children MUST be work that accomplishes it, not evidence that argues for it.**
If they argue rather than accomplish, it's an argument tree; see `chalk:voice`.

## Constraints and assumptions annotate the node they bound

**A constraint bounds which children may accomplish a node; it accomplishes nothing itself.**
So it is an annotation on the node, not a child of it, and so is an assumption the node leans on.

- **Two kinds, each with a typed ID** (`chalk:voice`), written as the node's first sub-bullets, ahead of its children — the ID is what tells an annotation from a child.

  - **`C<n>` — constraint**, marked `essential` where the problem imposes it, `accidental` where only the current system does and the work may remove it.
    An invariant is an essential constraint: something any solution must preserve.

  - **`A<n>` — assumption**: what the node leans on that it doesn't control.
    Distinct from the `assumption:` tag, which marks a node itself as unverified.

- **An annotation scopes to the node's subtree.**
  One that bounds the whole card annotates the root; one written higher than it binds reads as card-wide and constrains work it doesn't touch.

- **Where Current state carries the coupling, the annotation names it in a clause** rather than restating it — the palette puts each thing in one place.

- **A constraint a test can pin SHOULD be a test, not an annotation.**
  Prose asks someone not to revert a constraint; a test refuses to let them, and only a test has a decay alarm.
  Annotations carry the ones no test can hold.

- **A constraint this work creates is not an annotation** — it is inherited, and lives in the PR's Consequences.

## Marks on the tree

- **Each node is tested for sufficiency — complete refinement:** its children, with the domain properties relied on, entail it within its constraints; a set of children that reaches the parent by breaking one of its constraints is not sufficient.
  A node whose children aren't clearly sufficient is marked `check:`, per `chalk:voice`, rather than left to read as settled.

- **A leaf declares its kind where that isn't obvious** — requirement (something we do), expectation (something expected of someone or something else) or domain property (a plain fact relied on) — so an expectation never reads as work.
  `assumption:` marks a leaf as unverified; the kind is the separate question of who is on the hook.

- **Goal weakening and obstacle tolerance leave no trace in the tree**, so what was cut or accepted is recorded in **Out of scope** or **Alternative approaches**.

## In an issue description

**An issue's goal tree sits higher than a plan's.**
The issue answers what has to be true for this to be done; the session's plan answers what has to land to get there.

- **A child may be a link to another issue that owns that part.**
  `- [ ] Secondaries serve stale reads without blocking the primary — #412`

- **If a child is doing real work, it probably wants to be a sub-issue.**
  Then the tree is a readable map *of* the sub-issue graph rather than a second copy of it that drifts. Wire the relationship, don't just write the link — see `chalk:issue`.

- **Palette placement**
  **Potential approach** for the target end state and the direction to it — and anywhere else a section has a goal structure to express.

- **A goal tree proposing a solution MUST NOT be written into an issue the session didn't earn.**
  Include it when the session genuinely worked the direction; leave it out when the session was about noticing the problem. A speculative tree reads as a decision the next person can't distinguish from a settled one — the rule is `chalk:issue`'s.

- **Done-ness is not the tree's job.**
  A node is tested for sufficiency — whether its children accomplish it — and that question is unchanged by whether anyone has started. Tracking state belongs to GitHub's own: issue state, blocked-by, and the linked PRs. See "One piece, or it has children" in `chalk:issue`.
