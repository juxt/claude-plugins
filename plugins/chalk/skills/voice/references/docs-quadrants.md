# The other three quadrants

Load this before writing a docs page.
Everything else in this plugin is explanation end-to-end; a docs page is the only artefact that plays all four quadrants.

**Each page leans toward one quadrant at the top level; sections within it may hit others.**
A how-to page often has a short explanation intro (what this setup is for), numbered steps (how-to), a commented config block (reference), and a closing section on failure modes (explanation).
Each section does one quadrant's job; they MUST NOT blur together.

The test isn't "where does this page live?" — it's "what is *this paragraph or section* for?"

## How-to — apply action

The reader has a goal and wants to *achieve it*: deployment, configuration, integration, a specific operational task.

- **Goal stated up top** — "To do X, ...".
- **Numbered, imperative steps.**
- **Terse** — no narrative padding.
- **Concrete identifiers, not placeholders** — `my-kafka`, not `cluster-name`.
- **Prerequisites and assumptions before the steps**, not mid-flow.
- **A closing "you should now see …" check**, so the reader knows whether it worked.

How-tos don't teach — they assume the reader already has enough cognition to recognise the steps.
If the reader needs to *understand* something first, that's an explanation, and it belongs in a different section or a different page.

## Reference — apply cognition

The reader is working and needs to *look something up*: a CLI flag, an API signature, a config key, a SQL clause.

- **Neutral, exhaustive, structured** — tables, definition lists, grammar productions.
- **No narrative, no "we"/"you".**
- **Alphabetised or structurally ordered**, not narratively ordered.
- **Complete** — every flag, every field, every case.
- **Rationale MUST stay out of the body.**
  This is the one quadrant where chalk's usual "always capture the why" does not apply inline. The *why* — tradeoffs, motivation, upgrade story — belongs in an adjacent explanation section or changelog block, not next to the definition. A reader looking up a flag wants the semantics, not the story behind it.

Reference is unforgiving: if it's incomplete, the reader gets burned.
Better to generate it from the source of truth (schema, CLI help, spec) than to hand-write and drift.

**Watch for rationale that drifts in unnoticed.**
*"This exists for compatibility with…"*, *"These functions are provided so that…"*, *"This was added because…"* are explanation-quadrant sentences wearing reference clothing.
Strip them, or relocate them to the adjacent changelog or explainer.

## Tutorial — acquire action

The reader is new and wants to *learn by doing*: a guided first experience.

- **Gentle pacing, small wins, hand-holding.**
- **"You should see X" after each step**, so the reader can confirm progress.
- **Friendly and reassuring** — confidence-building.
- **Single working path** — no branching ("or you could do Y"), no optionality.
- **Ends with a clear next step** — "now that you've done X, try Y".

Tutorials are the hardest quadrant to get right.
Explanation can be shortened; reference can be incomplete; a bad tutorial *strands the reader* and they don't come back.
