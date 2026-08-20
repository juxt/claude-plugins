---
name: issue
description: Create a GitHub issue, or update an existing issue's description, with a body that captures the problem and why it matters, in the chalk voice. Use when the user says "open an issue", "file a bug", "raise an issue", "create an issue", "file a ticket", "/chalk:issue"; OR is about to compose, draft, write or update any GitHub issue title, issue body or issue description (e.g. "write up an issue for this", "update the issue description", "put the analysis on the ticket"). Load this skill BEFORE drafting any such prose — it carries the voice guidance the body needs.
version: 0.1.0
user-invocable: true
disable-model-invocation: false
---

# Issue

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

The user MAY provide a title as an argument (e.g. `/chalk:issue flaky expression_test under load`).
If no title is provided, draft one from the conversation.

**This skill owns the issue description** — drafting it, creating the issue, and keeping the description accurate later.
It does not track a session against the issue: "open an issue for this so we don't lose it" is this skill on its own, and most issues are filed that way and never need the tracking machinery.
Filing *and picking it up* is `chalk new`, which runs this skill to produce the issue and then starts tracking.

## Before you draft

An issue description is an **explanation** artefact, and it MUST be drafted against the chalk voice.
`chalk:issue` pulls in nothing on its own, so load these first (via the Skill tool):

- **`chalk:voice`**, and its **`references/palette.md`** — the principles, the section palette, the line-format rule.
- **`chalk:mindmap`** — the shape of the content inside each section.
- **`chalk:goal-tree`** — wherever a section's children *accomplish* their parent rather than argue for it.

**Structure the body into sections drawn from the palette**, choosing the ones this issue needs, and **write each section as a mindmap** — a short tl;dr opening it, then the tree.
A wall of undifferentiated prose is the wrong shape; if you've written one, you skipped this step.

**The body MUST open with a tl;dr at the top**, per `chalk:mindmap`.
An issue is the clearest case for it: whoever triages the card should get the whole argument before they open a single section.
That makes a separate **Summary** section largely redundant — drop it, or hold it to the one or two sentences the palette asks for.

**Your audience is whoever triages this card and whoever picks it up** — most often not you, and often months from now.
They are deciding whether it applies to them and whether it's workable today, from the description alone.

## Your responsibilities

1. **Establish the *why* and the *why now*.**

   **An issue MUST NOT be filed without a *why*** — if the motivation isn't recoverable, ask rather than guessing. The rule is a universal principle in `chalk:voice`.

   What's specific to an issue: *why now* is the line most often missing from a filed card, and its absence is what makes it un-triageable. A reader deciding whether to pick this up needs to know what made it worth writing down today, and there's no diff to fall back on.

2. **Check whether the issue already exists.**

   Ask the github agent to search open and recently-closed issues before filing.
   A duplicate splits the discussion across two cards and neither ends up with the full picture. If a close match exists, propose updating that issue's description or commenting on it instead, and let the user choose.

3. **Gather the concrete material.**

   Error messages, failing test names, log excerpts with timestamps, the specific types and files involved, links to CI runs.
   Collect these before drafting rather than reaching for placeholders mid-sentence. **Raw evidence MUST be annotated** — a log dump or stack trace with no explanation of what the reader is looking at is noise.

4. **Draft a title in acceptance-test voice.**

   Use the user's if given. Otherwise state the behaviour you want to be true, with a lowercase `should` — "the replica log should elect its own leader", "a restarted node should not reset the leader term".

   - **A title MUST say whether it states the desired behaviour or the current defect.**
     A bare statement of the current condition reads identically on a card that wants it fixed and one that wants it kept: "leader election borrows Kafka's consumer group" sits equally well above a plan to replace it and a plan to harden it. `should` settles that in one word, and it holds whether the card turns out to be a bug, a feature or a refactor.

   - **Lowercase `should`, never `SHOULD`.**
     An RFC 2119 keyword grades how strongly something is required, which is a body concern; a title names the behaviour, not its priority.

   - **Name the behaviour, not the mechanism that delivers it.**
     "The replica log should elect its own leader" is the outcome; "add a RaftElector" is the implementation, and it dates the moment the design moves.

5. **Draft the body — problem-focused.**

   **The description MUST be understandable on its own**, without trawling the comments. It is the source of truth for the issue's current state.

   Default to the palette sections that describe **the problem**: context/motivation, symptoms, evidence, root cause, invariants, out of scope.

   **The solution-shaped sections — Implementation, Alternatives considered, Decision rationale, Future state — MUST NOT appear unless the session genuinely worked the implementation.**
   An issue that arrives pre-committed to a solution closes off the design discussion before anyone else has seen the problem, and it dates badly, because the solution is the part most likely to change.

   - **Include them** when you traced the code, weighed approaches, or the user talked through a design. Then the reasoning is real and losing it is the expensive outcome.
   - **Leave them out** when the session was about *noticing* the problem. A guess at the fix, written up as though it were a decision, is worse than no section at all — the next reader can't tell speculation from a conclusion.
   - **When a fix is obvious but unconsidered**, one line under the problem ("probably wants X") is enough. Don't inflate it into an Implementation section.

   **Where you do include them, they MUST be shaped as a goal tree** (`chalk:goal-tree`) rather than a flat list of tasks — Implementation and Future state, where earned, always are.
   An issue's goal tree sits higher than a plan's — it answers what has to be true for this to be done, not which files to touch — and a child may be a link to the issue that owns that part, which is what keeps it high-level. Wire that link as a sub-issue relationship too, so the tree maps the issue graph rather than duplicating it.

6. **Wire up relationships.**

   Parent/child and blocked-by carry structure the description can't, and they answer cheaply what prose answers expensively.

   - **Parent / sub-issues** — when work nests. A sub-issue inherits its parent's motivation, so its own description stays focused on the specific slice.
   - **Blocked-by** — for order-dependent work. This pays back most: a filter for "open, un-blocked" becomes the queue of workable cards, and nobody has to triage to find out what they can pick up today.

   Wire them **in the same session the issue is created** — a link deferred is usually a link never made.
   The github agent has the GraphQL recipes (`addSubIssue`, `addBlockedBy`).

7. **Delegate to the chalk github agent** to create the issue.

   **All GitHub interaction MUST go through the agent; the main context MUST NOT call `gh issue` directly.**

   - **Pass the fully-drafted body, ready to post verbatim.**
     Passing bullet points and asking the agent to "write this up" is not acceptable — it pushes an explanation-quadrant job onto a model that can't do it well.
   - Pass any project-specific conventions you can see in your current context — project boards, default labels, milestones, assignees — verbatim, and let the agent apply them alongside its defaults.
   - Note the issue number from the agent's response and report it to the user.

## Updating an existing description

The description is the source of truth, so it MUST be kept accurate as facts change — a new failure mode, updated analysis, revised scope, a root cause that turned out to be something else.

- **Update facts; preserve framing.**
  Don't rewrite someone else's narrative or reorder their sections to your taste — keep their intent and correct what's now wrong.

- **Read before writing.**
  GitHub replaces the entire body on edit, so the agent needs the full new body.
- **Transitions don't belong here.**
  A description states the problem as it is now; "we originally thought X" belongs in a comment, which is timestamped and append-only. See "Transitions vs. current state" in `chalk:voice`.

## The `## Progress` section is chalk's, not this skill's

**An issue body written here MUST NOT contain a `## Progress` section** — not on create, not on update, not under `chalk new`.

Progress is chalk's tracking state, not part of the problem statement.
It's added by `chalk #N` when someone actually picks the issue up, and a checklist on an untouched issue asserts work is underway when it isn't.
Where one already exists, leave it alone and route changes through the `chalk` skill; its checklist is read as the issue's current truth.

The same line applies to implementation detail — which sub-task is next, what files to touch, what was tried. That belongs in the chalk comment, not the description.
