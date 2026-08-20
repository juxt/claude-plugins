---
name: allium-voice
description: The chalk writing voice applied to Allium specifications — a spec states the aim, and what it does not state, it excludes. Load before writing or editing any `.allium` file, any obligation, invariant, guarantee or guidance annotation, or any `--` comment body within one. Use when the user says "edit the spec", "add an obligation", "tend the spec", "/chalk:allium-voice", or mentions `.allium`, an obligation name, a contract, an invariant or a surface guarantee. `allium:tend` does not load this itself — the caller must.
version: 0.1.0
user-invocable: true
disable-model-invocation: false
---

# Chalk Allium Voice — Writing `.allium` Specs

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

Load **`chalk:voice`** for the universal principles and **`chalk:mindmap`** for the shape of anything the reader has to follow.
This skill carries only what's specific to a spec.

`allium:tend` governs what belongs in a spec and `allium check` validates its syntax.
Neither governs how it is said, which is the gap this fills.

## A spec states the aim. What it does not state, it excludes.

**Absence is assertion.**
A spec that never names a follower has already said there isn't one.
Naming a thing in order to deny it creates the thing the denial was avoiding — and it dates the spec to the moment someone was arguing about it.

**So a spec MUST NOT be defined by contrast with a design it does not contain.**
The alternative isn't here. Nothing needs to be said about it.

Three things follow, and they're the same rule seen from three angles:

- **An obligation MUST NOT be named after what it is not.**
  `XNotY` names two things and obliges one. Name the one: what the system does.

- **An obligation whose subject the spec does not otherwise name MUST be deleted, not renamed.**
  It exists to deny something absent, and the denial is what put the subject on the page. Removing the name leaves the obligation with nothing to say.

- **A spec MUST NOT argue for its own design over another.**
  Why this arrangement and not the one you rejected is a commit body's job and a PR's job. Both are read once, around the change; a spec is read long after by someone who doesn't care what it used to be, or might have been. See "Transitions vs. current state" in `chalk:voice`.

### The discriminator: about the system, or about a rival?

**A negation that constrains the system is content and stays.**
"Accepted records are never withdrawn", "leadership ending disturbs no other database", "reading needs nothing but an ordered log" — each bounds what the system does. None rejects an alternative design.

The two shapes are syntactically identical and the test is semantic, so **there is no grep for this**.
Cover the name, read what the obligation obliges, and ask what the system would be free to do without it.
Nothing → it was arguing, not obliging.

## Names are reference; bodies are explanation

An obligation's identifier is a **look-up surface** — someone cites `SingleWriterCommittedRole` from KDoc, from a sibling module, from a review comment. Its body is where the reasoning goes.

- **Name the obligation, not the mechanism that satisfies it.**
  A mechanism is how the obligation is currently met, so a name carrying one dates at the next refactor and the citation outlives it.

- **One claim, one obligation.**
  A claim split across two names reads as two obligations, and a reader checking coverage counts it twice. Collapse them.

- **Rationale MUST stay out of a name.**
  Reference is unforgiving about this — the reader looking up an obligation wants what it obliges, not why it was chosen.

## Register

`chalk:voice`'s specification register is the whole point here, and its tells are the ones that showed up: **ranking your own material** ("the distinction is the whole of the design"), **justifying a clause's presence** ("worth stating because…"), and **narrating the document's own shape** ("stated as prose because it is a property of a sequence of states").

Each is commentary on what is *not* being said, which is the same failure as arguing with an absent alternative.
The exception `chalk:voice` already grants holds: **naming how a decomposition was split is a checkable fact about completeness**, not a claim about worth.

### Requirement keywords

Allium grades normativity structurally — `@invariant` and `@guarantee` are normative, `@guidance` is explicitly non-normative — and that is a switch on the whole block.
RFC 2119 keywords grade individual clauses within one, so the two compose.

- **Uppercase MUST, MUST NOT, SHOULD, SHOULD NOT, MAY are graded keywords; lowercase `must` and `should` are ordinary English.**
  Allium's own language reference uses the lowercase forms freely, so the distinction MUST be carried by case or it is invisible.

- **SHOULD, SHOULD NOT and MAY MUST NOT appear inside an `@invariant` or `@guarantee`.**
  An invariant holds or it does not; it is a MUST by construction, and a graded clause inside one is a contradiction the checker cannot see. That material belongs in `@guidance`.

- **`@guidance` is where SHOULD and MAY live**, which is what it's for.

## Comments

A `--` body is the spec's explanation payload, not incidental annotation.

- **It takes a mindmap** where it has structure to show — `chalk:mindmap`'s rules unchanged: subject lines carrying the argument, one checkpoint per bullet, shallow nesting.

- **The first sentence or paragraph is the tl;dr, and MUST NOT be labelled as one.**
  Same contract as a commit subject: reading it alone tells the reader what this obliges. Everything after it is elaboration and MUST NOT be load-bearing.

- **Markup is raw, so use plain `-` and indentation and no bold.**
  A `--` comment is read in a source buffer, where `**like this**` is noise.

- **Sentence-per-line.**
  A spec is reviewed as a `git diff`, so a one-word fix should touch one line. This overrides any column wrap in the surrounding file.
