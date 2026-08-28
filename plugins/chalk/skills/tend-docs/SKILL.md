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
**This skill MUST decline, politely, if asked to write for a non-technical audience** — marketing copy, end-user help aimed at non-technical readers, general-audience prose.
Suggest a different approach instead.

## Your Responsibilities

1. **Name the audience.**

   **The audience MUST be named** — to the user, or in a code comment on the draft — before the page is written.

   Technical is not specific enough — pick one:

   - **Newcomer** — has never used this product.
     Needs just enough context to evaluate or get started.
     Will re-read.
   - **Returning power-user**
     Has used it before, coming back for a specific detail.
     Skims, looks up, leaves.
     Values terseness.
   - **Operator mid-task**
     Is running this thing in production and needs to make it do a thing now.
     Values step-order and concrete identifiers.
   - **Developer integrating**
     Is wiring this into their own code.
     Values signatures, examples, failure modes.

   If you can't tell from the page's location and surrounding pages, **ask**.

2. **Identify the Diataxis quadrant(s).**

   Diataxis names four: **tutorial**, **how-to**, **reference**, **explanation**.
   **Load `chalk:voice`'s `references/docs-quadrants.md`** — it carries the voice for the three that nothing else here needs.

   **Each section MUST commit to one quadrant, and sections MUST NOT blur.**
   A how-to section that drifts into explanation loses the reader mid-task; an explanation section that drifts into reference buries the mental model.

   The test isn't "where does this page live?" — it's "what is *this paragraph or section* for?".
   Decide the quadrant of the page as a whole, and of each section, before writing.

3. **Discover project conventions.**

   Read the repo before writing.

   In order of priority:
   - A docs README (e.g. `docs/README.md`) — if present, it's the authoritative style guide.
     Follow it even where it disagrees with your defaults.
   - A `CLAUDE.md` at the repo root or in the docs directory.
   - Existing sibling pages — match their shape (frontmatter, heading depth, changelog format, version-marker style, callout syntax, cross-link style).
   - Recent commits and PRs touching docs — they show what's been landing.

   Project-specific conventions you're looking for:
   - **Frontmatter** shape (title, description, sidebar fields, etc.).
   - **Version markers**
     Is there an inline marker convention like `(v2.1+)`?
     Does it go on headings, in code comments, both?
   - **Changelog blocks**
     Does each page carry a `<details>` changelog?
     What's the format?
     What counts as a transition vs. an additive feature?
   - **Callout style**
     Starlight `:::note` / `:::caution`, MDX admonitions, plain blockquotes?
   - **Cross-link style** — site-relative paths?
     Anchors?
     What's the house convention?
   - **Diagrams**
     Inline D2, Mermaid, PNG assets?

   **Conventions MUST be discovered from the repo, not invented.**
   Where the project has one, match it; where it doesn't, make a call and be consistent within the page.

4. **Pull the "why" from the issue-graph neighbourhood.**

   Cast the net at least one hop beyond the immediately-tracked issue.

   Read:

   - The **tracked chalk issue** and its comments — the primary source.
   - **Related issues**
     Parent, sub-issues, blocked-by, blocks.
     See the "Issue Relationships" section of the main chalk skill.
     The github agent's neighbourhood query is the cheapest way to pull this.
   - The **landing PR(s)** — description *and* review discussion.
   - The **landing commit body(ies)**.

   For a feature that's touched multiple issues and PRs, read across them — contradictions between old and new thinking usually mark where the docs need the clearest framing.

   These carry the *why* that isn't visible in the code — root causes, operational guarantees, invariants, rejected alternatives, real-world failure modes.

   Distil, don't copy.

5. **Apply the chalk voice.**

   **Load the `chalk:voice` skill** (via the Skill tool) for the universal principles, then apply the per-quadrant voice from its `references/docs-quadrants.md` to each section.
   **Load `chalk:mindmap`** too, for the shape of anything the reader has to follow — a how-to's steps, an explainer's reasoning, a failure-mode section.
   Don't restate those rules inline — they live in those skills.

   **Line format: sentence-per-line.**

6. **Ask clarifying questions** — don't invent.

   **A rationale MUST NOT be fabricated** when the issue graph, PR or commits don't carry one; ask the user instead.
   `chalk:voice`'s "Establish the why and the why now" applies here.

   Ask when:

   - The **audience** isn't clear from the page context.
   - The **quadrant** isn't clear from the request ("document X" is ambiguous — tutorial, how-to, reference, or explainer?).
   - The **why** isn't clear from the issue graph / PR / commits, and the section needs one.
   - A **project convention** is missing and the call has material effect on the output (e.g. no changelog-format precedent and the change is a transition worth recording).

## Chalk Integration

When chalk is active (tracking a GitHub issue):

- **Read the issue and its comments** before writing a non-trivial section.
- **After updating the page**, update the chalk comment directly — don't ask first.
- A docs change is often a natural checklist item on the chalk progress section ("document X behaviour"). Check it off when the page lands.

## What this skill is not

- Not a marketing-copy writer.
- Not a spec for non-technical end-user help.
- Not an opinion on how *any specific project* should organise its docs — conventions come from the repo.
- Not a drift-detector — for "which pages does this diff affect?", use `chalk:weed-docs`.
