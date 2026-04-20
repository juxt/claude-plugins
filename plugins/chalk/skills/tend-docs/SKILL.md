---
name: tend-docs
description: Write or update a technical documentation page in the chalk voice, structured around Diataxis. Use when the user says "tend the docs", "update the docs", "write a docs page", "document this feature", "add a how-to for X", "/chalk:tend-docs", or references adding/editing an end-user-facing docs page in a technical project.
version: 0.1.0
user-invocable: true
disable-model-invocation: false
---

# Tend — Technical Documentation

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

Write or update a docs page for a **technical audience** — developers, operators, integrators.
This skill is not for marketing copy, end-user help aimed at non-technical readers, or general-audience prose.
If the user asks for those, decline politely and suggest a different approach.

## Your Responsibilities

1. **Name the audience.**

   Before writing, know who you're writing for.
   Technical is not specific enough — pick one:

   - **Newcomer** — has never used this product.
     Needs just enough context to evaluate or get started.
     Will re-read.
   - **Returning power-user** — has used it before, coming back for a specific detail.
     Skims, looks up, leaves.
     Values terseness.
   - **Operator mid-task** — is running this thing in production and needs to make it do a thing now.
     Values step-order and concrete identifiers.
   - **Developer integrating** — is wiring this into their own code.
     Values signatures, examples, failure modes.

   Different audiences change everything — pacing, depth, what's assumed, what's spelled out.
   If you can't tell from the page's location and surrounding pages, **ask**.

2. **Identify the Diataxis quadrant(s).**

   Diataxis names four quadrants: **tutorial**, **how-to**, **reference**, **explanation** (see `VOICE.md` at the plugin root).
   Each page leans toward one at the top level; each sub-section within it may hit a different quadrant.

   The test isn't "where does this page live?" — it's "what is *this paragraph/section* for?".

   Before writing, decide:
   - What quadrant is this page as a whole?
   - What quadrant is each section?

   Don't blur them.
   A how-to section that drifts into explanation loses the reader mid-task; an explanation section that drifts into reference buries the mental model.

3. **Discover project conventions.**

   Conventions differ between projects and this skill does not prescribe them.
   Read the repo before writing.

   In order of priority:
   - A docs README (e.g. `docs/README.md`) — if present, it's the authoritative style guide.
     Follow it even where it disagrees with your defaults.
   - A `CLAUDE.md` at the repo root or in the docs directory.
   - Existing sibling pages — match their shape (frontmatter, heading depth, changelog format, version-marker style, callout syntax, cross-link style).
   - Recent commits and PRs touching docs — they show what's been landing.

   Project-specific conventions you're looking for:
   - **Frontmatter** shape (title, description, sidebar fields, etc.).
   - **Version markers** — is there an inline marker convention like `(v2.1+)`?
     Does it go on headings, in code comments, both?
   - **Changelog blocks** — does each page carry a `<details>` changelog?
     What's the format?
     What counts as a transition vs. an additive feature?
   - **Callout style** — Starlight `:::note` / `:::caution`, MDX admonitions, plain blockquotes?
   - **Cross-link style** — site-relative paths?
     Anchors?
     What's the house convention?
   - **Diagrams** — inline D2, Mermaid, PNG assets?

   Where the project has a convention, match it.
   Where it doesn't, make a call and be consistent within the page.

4. **Pull the "why" from the issue-graph neighbourhood.**

   Like `chalk:commit`, this skill draws *motivation* from upstream context.
   Cast the net at least one hop beyond the immediately-tracked issue — a single issue rarely carries all the reasoning that ends up mattering on a docs page.

   Read:

   - The **tracked chalk issue** and its comments — the primary source.
   - **Related issues** — parent, sub-issues, blocked-by, blocks.
     See the "Issue Relationships" section of the main chalk skill; the one-hop graph surfaces operational context, rejected alternatives, and why-now that don't fit in any single issue.
     The github agent's neighbourhood query is the cheapest way to pull this.
   - The **landing PR(s)** — description *and* review discussion.
     Review discussion in particular catches edge cases and invariants that only got clarified during review.
   - The **landing commit body(ies)** — multi-commit PRs often have per-commit rationales the PR description glosses over.

   For a feature that's touched multiple issues and PRs, read across them — contradictions between old and new thinking usually mark where the docs need the clearest framing.

   These carry the *why* that isn't visible in the code — root causes, operational guarantees, invariants, rejected alternatives, real-world failure modes.
   They noticeably improve the resulting docs.

   Distil, don't copy.
   A chalk comment is author-to-maintainer; a docs page is author-to-user.
   The audience is different; the phrasing has to be too.

5. **Apply the per-quadrant voice from `VOICE.md`.**

   Universal principles first (concrete examples, sentence-per-line, problem-first, no marketing fluff).
   Then the quadrant-specific voice.
   Don't restate the rules inline — reference `VOICE.md`.

6. **Ask clarifying questions** — don't invent.

   The main chalk skill's "Understanding Why" rule applies here: if the *why* isn't obvious from the issue graph, the PR, or the conversation, ask.
   A one-sentence answer from the user beats a fabricated rationale every time, and fabricated rationales in docs are particularly corrosive — they look authoritative and they rot silently.

   Ask when:

   - The **audience** isn't clear from the page context.
   - The **quadrant** isn't clear from the request ("document X" is ambiguous — tutorial, how-to, reference, or explainer?).
   - The **why** isn't clear from the issue graph / PR / commits, and the section needs one.
     Don't make it up.
   - A **project convention** is missing and the call has material effect on the output (e.g. no changelog-format precedent and the change is a transition worth recording).

## Constraints

- The audience MUST be named (to the user or in a code comment on the draft) before the page is written.
- Each section MUST commit to one Diataxis quadrant.
  Sections MUST NOT blur quadrants.
- The page MUST follow `VOICE.md` — universal principles plus the quadrant-specific voice.
- Project-specific conventions (version markers, changelog shape, frontmatter fields, callout style) MUST be discovered from the repo, not invented.
- The skill MUST decline (politely) if asked to write for a non-technical audience — that's not what this skill is for.
- If chalk is active, the skill SHOULD read the tracked issue, its one-hop issue-graph neighbourhood, and the landing PR(s) before writing a non-trivial section — the *why* lives across them, not in any single artefact.
- The skill MUST NOT fabricate a rationale for a section when the issue graph / PR / commits don't carry one.
  Ask the user instead (see the main chalk skill's "Understanding Why" section).

## Workflow

1. Parse the user's directive (update page X, write a page about Y, add a section to Z).
2. Locate the docs tree.
   Read the docs README if present; otherwise scan sibling pages for conventions.
3. Name the audience.
   If ambiguous, ask.
4. Identify the quadrant of the page (and each section).
5. Pull the *why* from chalk context — tracked issue, one-hop neighbourhood (parent/sub/blocked-by), landing PR(s) including review discussion, and landing commit body(ies).
6. Draft.
   Apply `VOICE.md` — universal principles plus per-quadrant voice.
7. Match discovered project conventions (frontmatter, version markers, changelog, callouts, cross-links).
8. Ask clarifying questions if the audience, quadrant, or a material project convention is unclear.

## Chalk Integration

When chalk is active (tracking a GitHub issue):

- **Read the issue and its comments** before writing a non-trivial section — the chalk comments are the richest source of reasoning.
- **After updating the page**, update the chalk comment directly — don't ask first.
  Chalk updates are part of the work, same as with `chalk:commit`.
- A docs change is often a natural checklist item on the chalk progress section ("document X behaviour"). Check it off when the page lands.

## What this skill is not

- Not a marketing-copy writer.
- Not a spec for non-technical end-user help.
- Not an opinion on how *any specific project* should organise its docs — conventions come from the repo.
- Not a drift-detector — for "which pages does this diff affect?", use `chalk:weed-docs`.
