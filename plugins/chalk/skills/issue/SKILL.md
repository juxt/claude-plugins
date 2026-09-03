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

## Before you draft

An issue description is an **explanation** artefact, and it MUST be drafted against the chalk voice.
Load these first (via the Skill tool):

- **`chalk:voice`**, and its **`references/palette.md`** — the principles, the section palette, the line-format rule.
- **`chalk:mindmap`** — the shape of the content inside each section.
- **`chalk:goal-tree`** — wherever a section's children *accomplish* their parent rather than argue for it.

**Structure the body into sections drawn from the palette**, choosing the ones this issue needs, and **write each section as a mindmap** — a short tl;dr opening it, then the tree.
A wall of undifferentiated prose is the wrong shape; if you've written one, you skipped this step.

**The body MUST open with a tl;dr at the top**, per `chalk:mindmap`.
That makes a separate **Summary** section largely redundant — drop it, or hold it to the one or two sentences the palette asks for.

**Your audience is whoever is scanning a backlog, deciding whether to pick this card up this sprint.**
Write for that decision: a summary of the session's work doesn't serve it.

## Your responsibilities

1. **Establish the *why* and the *why now*.**

   **An issue MUST NOT be filed without a *why*** — if the motivation isn't recoverable, ask rather than guessing. The rule is a universal principle in `chalk:voice`.

   What's specific to an issue: *why now* is the line most often missing from a filed card, and its absence is what makes it un-triageable.
   **It MUST be traceable to something the user said, a commit or a file you can name.** There is no diff here to fall back on, and a motivation you assembled yourself reads exactly like one you were told.

2. **Check whether the issue already exists.**

   Ask the github agent to search open and recently-closed issues before filing.
   If a close match exists, propose updating that issue's description or commenting on it instead, and let the user choose.

3. **Gather the concrete material.**

   Error messages, failing test names, log excerpts with timestamps, the specific types and files involved, links to CI runs.
   Collect these before drafting rather than reaching for placeholders mid-sentence. **Raw evidence MUST be annotated** — a log dump or stack trace with no explanation of what the reader is looking at is noise.

4. **Draft a title in acceptance-test voice.**

   Use the user's if given. Otherwise state the behaviour you want to be true — "the replica log should elect its own leader", "a restarted node should not reset the leader term".

   - **A title MUST say whether it states the desired behaviour or the current defect.**
     A bare statement of the current condition reads identically on a card that wants it fixed and one that wants it kept: "leader election borrows Kafka's consumer group" sits equally well above a plan to replace it and a plan to harden it. `should` settles that in one word.

   - **Lowercase `should`, never `SHOULD`.**
     An RFC 2119 keyword grades how strongly something is required, which is a body concern; a title names the behaviour, not its priority.

   - **Name the behaviour, not the mechanism that delivers it.**
     "The replica log should elect its own leader" is the outcome; "add a RaftElector" is the implementation, and it dates the moment the design moves.

5. **Draft the body — problem-focused.**

   **The description MUST be understandable on its own**, without trawling the comments.

   Default to the palette sections that describe **the problem**: context/motivation, symptoms, evidence, root cause, invariants, out of scope, open questions.

   **The solution-shaped sections — Implementation, Alternatives considered, Decision rationale, Future state — MUST NOT appear unless the session genuinely worked the implementation.**

   - **Include them** when you traced the code, weighed approaches, or the user talked through a design.
   - **Leave them out** when the session was about *noticing* the problem. A guess at the fix, written up as though it were a decision, is worse than no section at all — the next reader can't tell speculation from a conclusion.
   - **When a fix is obvious but unconsidered**, one line under the problem ("probably wants X") is enough. Don't inflate it into an Implementation section.

   - **What the session left unanswered goes in Open questions**, one entry each, tagged `Q<n>` per `chalk:mindmap` so it can be answered by reference.
     A decision still owed or a hypothesis nobody verified has no other home in the plugin — a commit body explains a change that exists and a PR explains a branch that exists, so an open question left out here is one the next person rediscovers from scratch. Say what would settle each. Delete an entry once it's answered, and put the answer wherever it now belongs.

   **Where you do include them, they MUST be shaped as a goal tree** (`chalk:goal-tree`) rather than a flat list of tasks — Implementation and Future state, where earned, always are.
   An issue's goal tree sits higher than a plan's — it answers what has to be true for this to be done, not which files to touch — and a child may be a link to the issue that owns that part.

6. **Wire up relationships.**

   - **Parent / sub-issues** — when work nests. A sub-issue inherits its parent's motivation, so its own description stays focused on the specific slice.
   - **Blocked-by** — for order-dependent work.

   Wire them **in the same session the issue is created** — a link deferred is usually a link never made.
   The github agent has the GraphQL recipes (`addSubIssue`, `addBlockedBy`).

7. **Delegate to the chalk github agent** to create the issue.

   **All GitHub interaction MUST go through the agent; the main context MUST NOT call `gh issue` directly.**

   - **Pass the fully-drafted body, ready to post verbatim.**
     Passing bullet points and asking the agent to "write this up" is not acceptable.
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

## An issue either lands in one piece, or it has children

**Every issue MUST be small enough to land as a single commit or PR, or MUST have sub-issues or PRs carrying its parts.**
There is no third shape. An issue that is neither asserts a body of work with no visible unit of delivery, so whoever picks it up has to redo the decomposition from the description alone — with less context than you have while filing it.

- **Where the work plainly exceeds one landing, file the children in the same session.**
  Same rule as the relationships above, for the same reason: a decomposition deferred is one that never happens.

- **This is what a progress checklist was for, and it does the job better.**
  The sub-issue graph and the linked PRs already say which parts are done, and GitHub renders both with nobody maintaining them. A checklist inside the description drifts down to items like "raise PR" — self-evident, which is what "What to omit" in `chalk:voice` rules out.

- **An issue body MUST NOT contain a `## Progress` section or a status line.**
  Whether the issue is open, what's blocking it, and what's landed are GitHub's own state: issue state, blocked-by, and linked PRs. A second copy inside the description is read as the truth and is wrong the moment anything moves.

## Implementation detail doesn't go here either

Which sub-task is next, what files to touch, what was tried — that's session state, not the problem.
It belongs in the plan you're working from, and once it lands, in the commit body or the PR description.
