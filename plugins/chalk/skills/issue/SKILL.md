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

## Filing is not tracking

This skill owns the **issue description** — drafting it, creating the issue, and keeping the description accurate later.
It does not track a session against the issue.

- **Filing and walking away** — "open an issue for this so we don't lose it" — is this skill on its own. Most issues are filed this way and never need the tracking machinery.
- **Filing and picking it up** is `chalk new`: the `chalk` skill runs this one to produce the issue, then starts tracking against it.
- **The comment and Progress layers belong to `chalk`**, not here. Never write a `## Progress` section from this skill — not on create, not on update. See "Chalk integration" below.

## Before you draft

An issue description is an **explanation** artefact, and it MUST be drafted against the chalk voice — not your own default prose habits, which read wrong and lose the reasoning the reader needs.

`chalk:issue` loads on its own and does **not** pull the shared voice into context.
Before drafting the body, **load the `chalk:voice` skill** (via the Skill tool) — it carries the Diataxis framing, the universal principles, and the issue/PR section palette.
Then **structure the body into sections drawn from that palette**, choosing the ones this issue needs.
A wall of undifferentiated prose is the wrong shape; if you've written one, you skipped this step.

**Line format: paragraph-per-line.**
An issue body is read rendered on GitHub, never as a `git diff`.
GitHub renders single newlines as `<br>`, so sentence-per-line fragments into staccato — put each paragraph on a single line, separate paragraphs with a blank line, and let the rendering wrap.

## Your Responsibilities

1. **Establish the *why* and the *why now*.**

   The rule is a universal principle in `chalk:voice` — see "Establish the why and the why now" there, and **ask rather than guess**.

   What's specific to an issue: *why now* is the line most often missing from a filed card, and its absence is what makes it un-triageable.
   A reader deciding whether to pick this up needs to know what made it worth writing down today, and there's no diff for them to fall back on.

2. **Check whether the issue already exists.**

   Ask the github agent to search open (and recently-closed) issues before filing.
   A duplicate splits the discussion across two cards and neither ends up with the full picture.
   If a close match exists, propose updating that issue's description or commenting on it instead, and let the user choose.

3. **Gather the concrete material.**

   The palette's evidence-shaped sections are only as good as what you put in them — error messages, failing test names, log excerpts with timestamps, the specific types and files involved, links to CI runs.
   Collect these before drafting rather than reaching for placeholders mid-sentence.

4. **Draft a title** — use the user's if given; otherwise a short one that names the problem, not the fix.

5. **Draft the body — problem-focused.**

   An issue description is an **explanation** artefact with reference-shaped evidence embedded (log excerpts, stack traces, trace dumps).
   Draw the sections from the palette in the `chalk:voice` skill you loaded above, and default to the ones that describe **the problem**: summary, context/motivation, symptoms, evidence, root cause, invariants, out of scope.

   **Stay on the problem unless the conversation was actually about implementation.**
   An issue that arrives pre-committed to a solution closes off the design discussion before anyone else has seen the problem — and it dates badly, because the solution is the part most likely to change.
   So the solution-shaped sections — Implementation, Alternatives considered, Decision rationale, Future state — are **earned, not default**:

   - **Include them** when the session genuinely worked the implementation: you traced the code, weighed approaches, or the user talked through a design. Then the reasoning is real and losing it is the expensive outcome.
   - **Leave them out** when the session was about *noticing* the problem. A guess at the fix, written up as though it were a decision, is worse than no section at all — the next reader can't tell your speculation from a conclusion.
   - **When a fix is obvious but unconsidered**, one line under the problem ("probably wants X") is enough. Don't inflate it into an Implementation section.

   **The description is the source of truth.**
   A developer MUST be able to understand the current state of the issue by reading the description alone, without trawling the comments.

   **Don't write a `## Progress` section.**
   Progress is chalk's tracking state, not part of the problem statement, and it's added by `chalk #N` when someone actually picks the issue up.
   A checklist on an untouched issue asserts work is underway when it isn't.

6. **Wire up relationships.**

   Parent/child and blocked-by carry structure the description can't, and they answer cheaply what prose answers expensively.

   - **Parent / sub-issues** — when work nests. A sub-issue inherits its parent's motivation, so its own description stays focused on the specific slice.
   - **Blocked-by** — for order-dependent work. This is the one that pays back most: a filter for "open, un-blocked" becomes the queue of workable cards, and nobody has to triage to find out what they can pick up today.

   Wire them **in the same session the issue is created**.
   A link deferred is usually a link never made.
   The github agent has the GraphQL recipes (`addSubIssue`, `addBlockedBy`).

7. **Delegate to the chalk github agent** to create the issue.

   - Pass the title and the fully-drafted body, ready to post verbatim.
   - Pass any project-specific conventions relevant to this operation — project boards, default labels, milestones, assignees — that you can see in your current context (typically the project's `CLAUDE.md`, or explicit user instructions for this session). Include them verbatim; let the agent apply them alongside its defaults.
   - Note the issue number from the agent's response and report it to the user.

## Updating an existing description

The description is the source of truth, so it MUST be kept accurate as facts change — a new failure mode, updated analysis, revised scope, a root cause that turned out to be something else.

- **Update facts; preserve framing.** Don't rewrite someone else's narrative or reorder their sections to your taste — keep their intent and correct what's now wrong.
- **Read before writing.** GitHub replaces the entire body on edit, so the agent needs the full new body.
- **Leave `## Progress` alone.** It's chalk's section and its checklist is read as the issue's current truth; route changes to it through the `chalk` skill.
- **Transitions don't belong here.** A description states the problem as it is now; "we originally thought X" belongs in a comment, which is timestamped and append-only. See "Transitions vs. current state" in `chalk:voice`.

## Chalk integration

- **`chalk new`** loads this skill to produce the issue, then starts tracking against the number it returns. The drafting rules above are the same either way — including no `## Progress` section; chalk adds it as part of picking the issue up.
- **When chalk is tracking this issue**, the `## Progress` section and the session comment are chalk's. Route changes to either through the `chalk` skill rather than editing them here.
- **Implementation detail belongs in the chalk comment**, not the description — which sub-task is next, what files to touch, what was tried. That's the same line the section palette draws in `chalk:voice`.

## Constraints

- The issue body MUST follow the explanation-quadrant voice in the `chalk:voice` skill.
- The body MUST be drafted in the main context and handed to the github agent ready to post verbatim. Passing bullet points and asking the agent to "write this up" is not acceptable — it pushes an explanation-quadrant job onto a model that can't do it well.
- All GitHub interaction MUST go through the github agent. The main context MUST NOT call `gh issue` directly.
- The description MUST be understandable on its own, without reading the comments.
- An issue MUST NOT be filed without a *why* — if the motivation isn't recoverable, ask rather than guessing.
- The body MUST NOT contain a `## Progress` section. That's chalk's tracking state, added when someone picks the issue up.
- The solution-shaped sections (Implementation, Alternatives considered, Decision rationale, Future state) MUST NOT appear unless the session genuinely worked the implementation. Speculation presented as a decision is worse than an omission.
- Raw evidence MUST be annotated. A log dump or stack trace with no explanation of what the reader is looking at is noise.

## Workflow

1. Parse the title from the command arguments (if provided)
2. Establish the *why* and *why now*; ask if either is unclear
3. Search for an existing issue covering this
4. Gather the concrete evidence
5. Load `chalk:voice`, then draft the title and body against the problem-focused sections of the palette
6. Ask any clarifying questions if needed
7. Delegate to the github agent to create the issue, and wire up any parent / blocked-by relationships
8. Report the issue number back to the user
