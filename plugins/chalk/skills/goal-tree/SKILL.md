---
name: goal-tree
description: Structure a goal as a tree whose children accomplish their parent rather than argue for it, and test each node for sufficiency. Load whenever writing something with a goal structure in it — the direction or target end state of a piece of work, an issue's Potential approach section, the shape of a problem, or a plan. Covers the sufficiency test, the three kinds of leaf, and the named moves for closing a gap. The chalk:issue skill loads it alongside chalk:voice.
user-invocable: true
---

# Chalk Goal Trees

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

A goal tree is a mindmap whose relation is **serves**, not **supports**.
Load `chalk:voice` first — subject lines, bolding, shallow nesting, tags and typed IDs all apply here unchanged.

## The shape

**The root is the goal.**
Each node's children are what it takes to achieve it, recursively, down to leaves that are directly actionable.

**Every node's children MUST be work that accomplishes it, not evidence that argues for it.**
If they argue rather than accomplish, it's an argument tree; see `chalk:voice`.

## The test at each node is sufficiency

**Assume every child is done, then ask whether the parent is thereby achieved.**

Not "do these look related to the parent?" but "do these, **plus what we already know about this system**, get us there?"

- **The domain knowledge is part of the test.**
  Say that out loud rather than leaning on it silently.

- **Each node MUST be tested for sufficiency explicitly** rather than assumed, and any node whose children are not clearly sufficient MUST be marked `check:` rather than left to read as settled.
- **This is why goal trees don't need the decomposition note** an argument tree needs (see `chalk:voice`).

**To find a missing child, ask what would stop the parent** rather than what would achieve it.

## Every leaf is one of three things — say which

**A leaf MUST declare which kind it is wherever that isn't obvious.**

- **Something we do.**
- **Something expected of someone or something else**
  The user, CI, another team, an upstream library, existing behaviour.
- **A plain fact about the world** we're relying on.

**An expectation of someone else MUST NOT be written as though it were our own task**.
It reads as covered, it sits in the tree looking like work, and nothing happens until someone notices it was never assigned.

`assumption:` covers whether a leaf has been *verified*; this is the separate question of who's *on the hook*.
A leaf can be both — a verified fact about an upstream library is still someone else's to keep true.

## A gap anywhere invalidates everything above it

**A gap MUST be surfaced rather than papered over.**

**Closing a gap MUST be a deliberate choice from these named moves**, rather than reflexively adding a task:

- **Achieve the parent a different way.**
- **Reassign it** to someone or something that won't fail like that.
- **Add a step that prevents it.**
- **Make it less likely** without eliminating it.
- **Let it happen and recover afterwards.**
- **Let it happen and limit the damage.**
- **Weaken the goal** so the gap no longer matters.
- **Accept the risk** and move on.

**"Weaken the goal" and "accept the risk" are real answers, and both MUST be recorded** in **Out of scope** or **Alternative approaches** — they are the two moves that leave no trace in the tree itself.
Scope that was deliberately cut is a decision someone will want the reasoning for later; scope that silently evaporated reads as an oversight, and a reader can't tell the two apart.

## In an issue description

**An issue's goal tree sits higher than a plan's.**
The issue answers what has to be true for this to be done; a plan answers which files to touch in what order.
Granular execution — which sub-task is next, what was tried — is session state and stays in the plan you're working from.

- **A child may be a link to another issue that owns that part.**
  `- [ ] Secondaries serve stale reads without blocking the primary — #412`

- **If a child is doing real work, it probably wants to be a sub-issue.**
  Then the tree is a readable map *of* the sub-issue graph rather than a second copy of it that drifts. Wire the relationship, don't just write the link — see `chalk:issue`.

- **Palette placement**
  **Potential approach** for the target end state and the direction to it — and anywhere else a section has a goal structure to express.

- **A goal tree proposing a solution MUST NOT be written into an issue the session didn't earn.**
  Include it when the session genuinely worked the direction; leave it out when the session was about noticing the problem. A speculative tree reads as a decision the next person can't distinguish from a settled one — the rule is `chalk:issue`'s.

- **Done-ness is not the tree's job.**
  A node is tested for sufficiency — whether its children accomplish it — and that question is unchanged by whether anyone has started. Tracking state belongs to GitHub's own: issue state, blocked-by, and the linked PRs. See "An issue either lands in one piece, or it has children" in `chalk:issue`.
