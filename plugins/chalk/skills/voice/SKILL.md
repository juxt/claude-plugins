---
name: voice
description: Shared Chalk writing voice — the audience for Chalk artefacts, the specification register, the mindmap structure that followable content MUST take, and the line format rule. The chalk:issue, chalk:commit and chalk:pr skills MUST load this before drafting any prose.
---

# Chalk Voice — Writing Principles

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

## Audience

Your audience for Chalk artefacts is a professional, competent, senior engineer familiar with the product and codebase you are writing about.
They are reading the Chalk artefact to understand the change, to update their mental model of the product and codebase, and to understand/review any new implications, risks or constraints that may affect them.

You are therefore writing to convey understanding - Diátaxis 'explanation'.
Your success metric is whether that knowledge is accurately and succinctly transferred.

## In Chalk artefacts, you MUST write in "specification register"

- **You MUST NOT write to impress anyone.**
  You MUST NOT produce flourishes, alternatives no reasonable reader would take, and caveats that change nothing.
  You are writing as a respected, professional, competent peer, not as a performer seeking plaudits.

  - **You MUST prioritise what the reader needs, not necessarily what you did.**
    The two diverge most sharply in summaries: a summary of the *work* reads as a session changelog, where a summary for the *reader* states what's true now and what it means for them.

- **You MUST NOT write to persuade anyone.**
  Remain objective, not promotional - if this type of reader senses marketing fluff they will lose trust.
  "Powerful", "seamless", "blazing-fast", "revolutionary" — cut them.
  State the capability; let the reader draw the conclusion.

- **You MUST NOT write to flatter the reader.**
  The reader knows that an AI wrote it, so it decreases trust.

- **You SHOULD NOT include anything that is obvious to the above audience.**
  The products and codebases you are writing about may be complex. 
  You should assume that your audience has a lot of other information to keep in mind - brevity and clarity is key.
  Cut anything that any reasonable senior developer working on the project would know.
  Cut any options that no reasonable senior developer would consider.
  Focus on what might surprise them, what they might not consider.

- **A sentence MUST NOT exist to tell the reader that another one matters.**
  **Ranking your own material** ("the single highest-leverage rule here"), **justifying its presence** ("this is the one reason this needs saying"), **narrating the document's shape** ("what follows is") and **advertising your diligence** ("checked carefully") each cost a read before the reader arrives at the thing being advertised.

  If there is a subtle detail that the reader may miss, or under-value, or with an impact that's higher than they might expect, state the consequence clearly and objectively, and let the reader determine its importance to them.

- **You MUST NOT use filler in headings or lead-ins.**
  Every sentence should carry a fact, a constraint or a decision - none exists to convey that a person is delivering it.
  **The tells to avoid**: an opening reaction line, a sign-off offer, an aside carrying attitude rather than a fact, a frame wrapped around a claim instead of the claim.
  "Caveat:" not "One honest caveat"; "Agreed:" not "Agreed — and here's why that's the stronger design".

- **You SHOULD use technically precise terms rather than a restricted vocabulary.**
  For example, "sufficient" and "necessary" each carry an exact meaning that a paraphrase spends a clause on and still blurs, so **precision beats simplicity where the two conflict**: what gets cut is the decorative metaphor, not the exact term.

- **You SHOULD use one term for one concept throughout an artefact.**
  Elegance through synonym variation is unnecessary and costs the reader a re-check every time they have to ask whether you meant something different.

- **You MUST NOT assume the reader has any of your session's context.**
  A sentence that only parses if you know which files were touched, which commit came before, or what was said in chat is a sentence the audience can't use.

## In Chalk artefacts, anything the reader has to *follow* MUST be a mindmap: a nested bullet-tree.**

e.g. A sequence of events, a multi-step rationale, a set of conditions, an interleaving of threads in a race condition, a decision and its grounds. 

Prose MUST be a deliberate exception, never a fallback — reserve it for a causal argument two or three links long, where "because", "so" and "but only when" carry the meaning.

- **Every parent MUST be a claim that its direct children back up.**
  Read downwards it is a summary that expands on demand; read upwards it is an argument. 
  **A list whose items are merely *related* to their parent is not a mindmap** — the reader gets no argument out of it, and you MUST restructure it.

- **Reading only the subject line of each bullet MUST be sufficient to follow the whole argument.**
  The elaboration beneath it is an optional read and MUST NOT be load-bearing. 
  Where the point only lands three sentences in, rewrite the subject line rather than expanding it.

- **You MUST give the subject its own line**, with any elaboration indented to line up under its first character — two spaces under a top-level bullet, four under a nested one.
  **You MUST bold the load-bearing words in the subject**, so the tree is graspable from the bold alone.

- **You MUST separate sibling bullets with a blank line, and MUST NOT leave one after the subject.**
  The elaboration starts on the line immediately below its subject, so the two read as a single block; the blank line falls between blocks.

  - **Exception: a destination rendered as plain CommonMark needs a blank line after the subject too.**
    A single newline is a *soft* break there — it collapses to a space, so the subject and its elaboration merge onto one line and the bold subject stops reading as a subject.
    That is an `.md` file rendered on github.com or by a docs site.
  - **A GitHub comment field is not that case.**
    Issue bodies, PR descriptions and comments render a single newline as `<br>`, which is why the rule above holds there unchanged — and why the line-format rule below asks for paragraph-per-line on those destinations.

- **Where a node's children aren't obviously exhaustive, name the rule you split on** — one per subsystem, one per failure mode, one per call site.
  A missing sibling otherwise looks exactly like no sibling.

- **You SHOULD tag a bullet where the tag sharpens it**, prefixing the subject line — 'goal:', 'pro:', 'con:', 'idea:', 'assumption:', 'check:'.
  A tag is a claim, not decoration: 'assumption:' says you have not verified it, which stops the next reader building on it as though you had.

- **Nodes that a reader might want to reply to SHOULD have a typed ID**, prefixing the subject line.
  e.g. 'D1' for a decision, 'Q1' for a question, 'I1' for an idea, 'D2.1' for its first child.
  IDs beat numbered lists, which renumber silently when a sibling is inserted. 
  **A published ID MUST be stable** — reuse it rather than minting a second one for the same node.

- **A citation MUST carry the node's subject line, not the ID alone.**
  The ID is a handle for replying, not a substitute for the content. A reader who cannot see the original — a later artefact, a fresh session, a sitrep picked up after a compaction — gets nothing from "Q1 is still open", and the ID's stability is what makes restating it cheap rather than what excuses omitting it.

## References

**Anything the artefact points at — a commit, an issue number, a file path, a named section — MUST exist and MUST say what the sentence claims it says.**
Verify before publishing rather than from memory: `git cat-file -e <sha>^{commit}`, and read the subject.

- **A SHA is quotable only once it has landed on the target branch.**
  A commit on the branch you are on can still be rebased, amended or squashed, and a PR that lands as a single squashed commit destroys every SHA in it — so a body citing one ages into a reference to nothing, in the artefact whose whole job is to still be readable in six months.

- **Refer to an unlanded commit by a shortened form of its subject line instead.**
  That survives the rewrite, and it tells the reader what the commit did without a lookup — which a SHA never does.

## tl;dr

**A tl;dr is a mindmap at takeaway grain**: one top-level bullet per takeaway, children backing it up, optionally after a single summary sentence.
A flat row of one-liners is the failure mode, and the one that looks finished.

**It summarises the artefact for its reader, not the session for its author**, and MUST be readable by someone who did not see the session, the branch or the prior state.
Provenance goes down into the body, where whoever wants it will find it.

**It goes at the top by default**, under its own heading.
Destinations MAY override the placement and whether one appears at all — `chalk:sitrep` puts it at the bottom, `chalk:commit` usually omits it — but not the two rules above.

## Line format

**The destination decides it: paragraph-per-line where the artefact is read rendered, sentence-per-line where it's reviewed as a diff.**

- **Paragraph-per-line** — commit bodies, issue and PR descriptions.
  These are read rendered on GitHub, and GitHub renders a single newline as `<br>`, so sentence-per-line fragments into staccato. 
  Put each paragraph on one line, separate paragraphs with a blank line, and let the rendering wrap.

- **Sentence-per-line** — in-repo dev documentation, code comments, per [Semantic Line Breaks](https://sembr.org): break at sentence and clause boundaries.
- **Whichever applies, it applies inside a bullet too**, which is where it's most often forgotten.
  On a paragraph-per-line destination a bullet's elaboration stays on one line however long it runs; the single break after the subject is the only exception.
  The blank line between siblings is a separate rule and holds on every destination.
