---
name: explicate
description: >
  Explicate an area of the codebase for an engineer catching up on it — how it works now, the decisions that shaped it and their consequences elsewhere, grounded in the code and its recorded history — then answer follow-ups as a depth-first walk, keeping track of where the user has been.
  Use only when the user runs "/chalk:explicate".
user-invocable: true
disable-model-invocation: true
argument-hint: "<area: a path, namespace or concept> [focus, or a since-point]"
---

# Chalk Explicate — Unfolding an Area of the Code

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

To explicate is to unfold: to make explicit what is implicit.
An area's decisions and their consequences are folded into its code; the record — commits, PRs, issues — holds some of the why, and the rest has to be inferred.
The reader is an engineer who has lost touch with the area, or never had it, and whose attention is the scarce resource.

**Success: the user holds a working model of the area as it stands, knows which decisions shaped it and what they cost elsewhere, and can tell which of that is on the record and which is inferred.**

`$ARGUMENTS` names the area, and may carry a focus or a since-point.
A since-point is a commit, tag or date; anything else is a focus.

## Before you start

- **Load `chalk:voice`.**
  Its register applies; its palette doesn't.
  An explication is a terminal reply, not a GitHub artefact.

## 1. Bound the area

**A path or namespace is the area as given.**

**A concept — "how does our disk caching work" — MUST be located and its boundary confirmed before it's explicated.**
Find its entry points, the namespaces and classes that implement it, and where it meets the rest of the system; propose that boundary, and wait.
An explication of the wrong boundary spends the attention it exists to save.

## 2. Ground it in the code and the record

**The code says how the area works now; the record says why.**

- **Now is the checkout's HEAD**, and the overview names it.

- **Read the record back from the code**: `git log` and blame over the area → the commits → the PRs that landed them → the issues those PRs name.

- **Read what's in flight**: open PRs and issues touching the area.

- **The since-point is the one in the arguments, else the user's own last commit in the area, else none.**
  A user new to the area gets no account of what's changed.

- **You MAY fan out read-only sub-agents** — history, structure, dependents — and combine their findings here.
  The combining stays in this context, where the follow-ups are answered.

## 3. Every why is cited or marked `inferred:`

**A confident rationale that nobody recorded is the failure this skill is most prone to.**
The reader can't tell it from a recorded one, and will act on it.

- **A recorded why cites its commit, PR or issue.**

- **A why reconstructed from the code alone is tagged `inferred:`.**

- **Where the area's history is thin, say so once, at the top, and infer anyway.**

## 4. Open with a quick general overview

**The first reply is an overview at the grain of the whole area, unless the invocation names a focus**, which narrows it to that.
Depth is the user's to ask for, so the overview stops at subjects they can agree with, and gives children only to those they can't.

**It covers, in this order:**

1. **The model** — the objects, their roles and their responsibilities, not a tour of the files.
2. **The decisions that shaped it**, each with its why.
3. **Its consequences elsewhere** — outward, what it requires of its callers; inward, what it assumes of the rest of the system.
4. **What's changed since the since-point**, where there is one.

**Each angle below is answerable on request, and appears in the overview only where it has something the user would want unasked.**

- **Deliberate oddities** — code that looks wrong and is load-bearing, with what explains it.

- **In flight** — open PRs and issues, half-finished migrations, where the area is heading, and risks accepted on the way.

- **Recently fixed bugs** — what broke, and what that says about where it breaks.

- **Invariants and their guards** — what must hold, which tests pin it, and what nothing pins.

- **Failure and observability** — how it fails, what that looks like in logs and metrics, and the configuration that changes its behaviour.

- **Rejected alternatives** — approaches tried or turned down, and why, so they aren't proposed again.

- **Churn hotspots** — where the area changes most often, from the history.

- **Who knows it** — recent authors and reviewers, and how thin that knowledge is.

## 5. Follow-ups are a depth-first walk, and you keep the map

**A narrow follow-up is a step down one branch, and the user will want to step back up and take another.**

- **Every node of the overview carries a typed ID**, per `chalk:voice`: `M` the model, `D` a decision, `C` a consequence, `S` a change since, `A` an angle.
  A node opened by a follow-up takes children under its own ID — `D2.1` — numbered from the next free one.

- **An ID is stable for the session.**
  The user replies "down D2" or "back to C1", and every reference they've made has to keep pointing where it did.

- **Each answer opens with its path from the overview**, every step by ID and subject line.

- **Each answer closes with the unvisited branches along that path**, by ID and subject line, so stepping back up is one reply.

- **The map is the overview and what has been opened under it, in the chat.**
  It has no other store.

- **The path and the unvisited branches restate each node in full, never by ID alone.**
  After a compaction the latest answer is what carries the walk on, and a new node numbers past the highest ID it shows.

## 6. A gap in the record is a finding

**Where a decision's why isn't recorded, say so**; the next engineer to come here will hit the same gap.

- **Offer to write recovered rationale back** — to the area's issue through `chalk:issue`, or as a comment where `chalk:code-comments` admits one.
  Offer, don't do it unasked: an explication is a read.

## Layout

**Chat, per `chalk:voice`.**

- **The overview ends with a tl;dr under a `tl;dr` heading**, as `chalk:sitrep`'s does: a terminal scrolls upward.

- **A follow-up ends with its unvisited branches instead**, which are what the user reads first when choosing where to go next.
