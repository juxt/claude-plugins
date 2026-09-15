---
name: voice
description: Shared Chalk writing voice — the audience for Chalk artefacts, the specification register, the mindmap structure that two propositions in a relation MUST take, and the layout rules. The chalk:issue, chalk:commit, chalk:pr and chalk:sitrep skills load this before drafting any prose, and the weed-prose agent loads it to review one.
---

# Chalk Voice — Writing Principles

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

## Audience

Your audience for Chalk artefacts is a professional, competent, senior engineer familiar with the product and codebase you are writing about.
Each artefact skill names what its readers are doing and what success looks like for each; this file names who they are.

You are writing to convey understanding — Diátaxis 'explanation'.
Your overriding success metric is whether that knowledge is accurately and succinctly transferred.

## The register

Three claims, and every rule under one is a way of failing it.
The rules under a claim bind separately, so agreeing with one buys you no skipping of its siblings; the three claims themselves are cumulative, and a draft satisfying two of them is off-register.
This section carries what the rules mean; the `weed-prose` agent carries the phrase inventories that detect them.

### Every sentence serves the reader, not you

- **You MUST NOT write to impress anyone.**
  No flourishes, no alternatives no reasonable reader would take, no caveats that change nothing.
  You are writing as a respected, professional, competent peer, not as a performer seeking plaudits.

- **You MUST NOT write to persuade anyone.**
  State the capability and let the reader draw the conclusion.
  **The test is deletion**: where a sentence carries the same fact with its evaluative words removed, those words were doing persuasion.

- **You MUST NOT write to flatter the reader.**
  The reader knows an AI wrote it, so it decreases trust.

- **You MUST NOT defend a decision the reader has not questioned.**
  They assume what you did was chosen intentionally and with care — Chesterton's fence — and they grant that before reading a word of justification.
  **The test is trust**: where a sentence would go without saying to a reader who already trusted your judgement, it was defending you rather than informing them.

  - **What they can't supply for themselves is the constraint.**
    Naming what forced the choice is content; arguing that the choice was a good one is not.

- **A clause MUST NOT exist to tell the reader that another one matters.**
  Four ways to do it: ranking your own material, justifying its presence, narrating the document's shape, advertising your diligence.
  The tell they share: the clause answers "so what?" about the writing rather than about the system.

  - **The unit is the clause, and the tail is where it hides.**
    Appended to a sentence that has already made its point, so the sentence passes and the clause rides in.
    "…, and that's the gap". "…, which is the point". "…, and that's what makes it work".

  - **The test is deletion.**
    Cover the clause; if what remains says the same thing about the system, the clause was about the writing.

  - **What goes there instead is a consequence, or nothing.**
    The pull is to supply connective tissue; there is usually nothing to connect.

- **You MUST NOT use filler in a heading or a lead-in.**
  Every sentence carries a fact, a constraint or a decision; none exists to convey that a person is delivering it.
  **Four shapes**: an opening reaction line, a sign-off offer, an aside carrying attitude rather than a fact, a frame wrapped around a claim instead of the claim.

- **You MUST prioritise what the reader needs over what you did.**
  The two diverge most sharply in summaries: a summary of the *work* reads as a session changelog, where a summary for the *reader* states what is true now and what it means for them.

### The reader's context is the artefact plus what a senior engineer on this project knows

- **You SHOULD NOT include anything obvious to that reader.**
  Cut what any reasonable senior developer on the project would know, and any option none of them would consider.
  Assume they have a great deal else to hold in mind, and focus on what might surprise them.

- **You MUST NOT assume the reader has any of your session's context.**
  A sentence that only parses if you know which files were touched, which commit came before, or what was said in chat is a sentence the audience can't use.

### Word choice costs the reader a re-read

- **You SHOULD use technically precise terms rather than a restricted vocabulary.**
  "Sufficient" and "necessary" each carry an exact meaning that a paraphrase spends a clause on and still blurs.

  - **Precision beats simplicity where the two conflict.**
    What gets cut is the decorative metaphor, not the exact term.

- **You SHOULD use one term for one concept throughout an artefact.**
  Synonym variation costs the reader a re-check every time they have to ask whether you meant something different.

## Two propositions in a relation MUST take one of two forms

**One proposition, developed at whatever length that takes, is prose.
Two standing in a relation are a structure**, and the relations are the ones below: grounds, narrowing, exception, conjunction, disjunction, consequence, succession.
A sequence of events, a multi-step rationale, a set of conditions, a race between threads, a decision and its grounds are each this.

**Route it by this chain, taking the first that applies:**

- **Concurrent, distributed or multi-actor → it MUST be an interleaving.**
  **An actor has independent control flow** — a thread, a process, a node, a human.
  Not an object, a module or a function, or every call chain would owe one.

- **Otherwise → it MUST be a nested bullet-tree**, a mindmap.

**A relation between propositions MUST NOT be written as prose.**
A single chain of cause is not a third form: it is a tree whose children are consequents, and `A → B → C` is its compressed spelling, licensed below.

### The tree

**Your job is the reader's working memory.**
Every node they read is context they hold while reading the next, their capacity is small, and it is already spoken for.
*Paging in* a node costs them that capacity and evicts something else, so the tree exists to let them page in what their goal needs and nothing more.

- **Every node is a conclusion stated in its subject line.**

  - **It recurses.**
    A child becomes a conclusion in its own right the moment it takes children, and every rule here applies to it unchanged.

- **At each node the reader takes one of three decisions, and the subject line is what they take it from.**

  1. **Irrelevant to my goal** — skip the node and its whole subtree, unread.
  2. **Understood and agreed** — take the claim, skip the body, move on.
  3. **Neither** — page in the body, and recurse into it.

  - **Decision 3 is the expensive one**, and every rule below exists to let the reader reach 1 or 2 more often.

  - **Disagreement routes to 3**, not to a fourth option.
    A reader who doubts the subject descends to find out whether they are convinced, which is what the body is for.

- **Decision 1 needs a subject the reader can place.**
  Relevance is judged against the goal they arrived with, so the subject must give them something to hold that goal against.

  - **A subject stating a claim can be checked against a goal; one naming a topic cannot.**
    "Background", "Notes", "Details" leave the reader nothing to decide on.

- **Decision 2 needs a subject that is safe to agree with.**
  Safe means that agreeing without reading the body costs them nothing they needed.

  - **The subject carries one claim and nothing else.**
    A second claim, a qualification, or the reason the claim holds all go below: each is only useful to a reader who has already taken the first, and two claims leave them unable to agree with half.
    **A contrast stays where the contrast is the claim** — "carry the subject line, not the ID alone" defines by exclusion, and loses its content if you cut the second half.
    What must go is a second obligation riding in on an `and`, and a qualification appended to a claim that was finished without it.

  - **An elaboration MUST NOT carry a proposition its subject does not reach.**
    That is decision 2 turned into a trap: the reader takes the subject, skips the body as invited, and never learns what was under it.
    Prose that is *not* a separate proposition may stay, and may run — the subject has already let them skip it, so length below a subject costs far less than a proposition they never saw.
    **What sits there**: the mechanism, an example, a measurement, a contrast, the same claim in other terms, the context the subject assumes, and what is at stake in it.
    **The stake is a consequence the reader bears, and is not a clause saying the subject matters** — that one is banned above, and survives its own deletion.

    - **A deduction MUST NOT be prose, inside an elaboration or anywhere else.**
      Two or more steps joined by *therefore* take the `A → B → C` form, or become consequent children.
      The licence above is to develop one proposition at whatever length that takes; it never extends to carrying an argument in sentences.

  - **A node the reader cannot simply agree with MUST say so** — `assumption:`, `idea:`, `check:`, below.
    Decision 2 assumes every subject is **decidable** — the reader can understand it and judge whether to accept it — and a tag is what withdraws that assumption for one node instead of forcing decision 3 on the whole tree.

  - **Where the point only lands three sentences in, rewrite the subject line** rather than expanding it.

- **Decision 3 needs children worth what they cost to page in.**

  - **A child grounds its parent, narrows it, or excepts it.**
    Grounds read upwards as an argument, and are what a bug report or a root-cause analysis is made of.
    A narrowing is the same rule applied to a narrower case, which is how a specification reads downwards — most of what a rules document holds, this file included.

    - **Narrowing is not inference, which is why the parent stays the conclusion.**
      A child that *follows from* its parent would make the child the consequence and the parent a premise, and the subject rule would then be pointing at the wrong end of the tree.

    - **A narrowing MUST be a case of its parent, not a neighbour of it.**
      The test is whether the parent, applied to this situation, gives you the child.
      Association readmits the related-items list below, wearing this vocabulary.

    - **An exception is where the parent does not hold.**
      It is the one relation that takes scope away instead of adding to it, so it MUST say what falls outside and what applies there instead.
      A reader who meets the uncovered case with no replacement is worse off than before they read the parent.

  - **A child MUST sit at a different level of detail from its parent** — Ousterhout's rule, from *A Philosophy of Software Design*.
    A child at the parent's own level is restatement wearing a bullet, and the reader pays to page in something they already hold.

  - **A list whose items are merely *related* to their parent is not a mindmap.**
    The reader gets no argument out of it, and you MUST restructure it.

  - **A node MUST be decidable from its ancestors alone.**
    They hold the path they descended, not the tree, so a node leaning on a sibling they were invited to skip is one they cannot decide — and they will not know that is why.
    The consequent is the declared exception below, and the extra context it demands is what it costs.

  - **Depth needs no bound.**
    A node goes deeper while it still has grounds to give or cases to narrow to, and stops when it runs out, so depth that is doing work is self-limiting.
    Depth from nested topics has already failed the rules above.

- **The relation among siblings is the reader's skip rights over the set, so the parent MUST make it clear.**
  It is what tells them how many of the siblings their goal obliges them to page in, which is a larger saving than anything a single subject line buys.

  - **An example, a clarification or a restatement is not one of these relations.**
    Each develops a single proposition instead of standing beside it, so each is that proposition's elaboration.
    Promoting one is how a tree acquires siblings that turn out not to be siblings.

  - **A ground**, combining with its siblings to justify the parent, in one of three ways.
    All three look identical on the page, and a reader who takes one for another misreads what the argument rests on.

    - **Linked** — they reach the parent only together, so the reader must take all of them, and a gap is fatal.
      The set MUST be complete or say that it is not.

    - **Convergent** — each reaches the parent alone, so the reader may stop at the first they accept.
      Each MUST therefore stand without its siblings, and they SHOULD run strongest first.

    - **Cumulative** — the parent rests on the balance of them, none sufficient alone, and dropping one weakens the conclusion without destroying it.
      The reader must weigh all of them, so this is the mode that buys them no skipping at all.
      A decision rationale is usually this, and it MUST say so: a reader who takes it for convergent comes away believing a single ground carried the decision.

  - **A disjunct** — one of a set of alternatives, of which the reader takes the one their circumstances select.
    Each MUST name the condition that picks it, or the reader cannot tell which is theirs and has to read all of them.

  - **A successor** — one stage of an ordered process, where the order is part of what the reader has to get right.
    **Succession is not consequence**: a stage follows the one above it in time, not from it, which is why `→` is wrong here and a plain ordered list is right.
    A short process MAY stay in a sentence where no stage needs anything of its own, and that licence lapses on the first stage carrying a precondition, a branch, or a way to get it wrong alone.

  - **A consequent** — what follows from the siblings above it, where two or more combine into a step neither gives alone.
    A derivation would nest it, with the siblings it follows from as its children. The reader arrives at it already carrying those, so nesting would send them down a level to collect a conclusion they had just earned.
    It is the one relation that obliges the reader to hold its prior siblings, which is why it MUST come after them.

    - **A run of consequents MAY be compressed inline to `A → B → C`.**
      The licence is that no step needs children of its own — a short derivation, a state transition with its trigger.
      Where any step acquires grounds, a tag or an ID, it wants a bullet, and the run expands with it.
      **`→` MUST mean *therefore* and nothing else**: sequence without causation is a list, and a state change is `:=`.

- **Siblings are read in order, and dependency fixes it.**
  A proposition that depends on an earlier sibling MUST come after it; strength, frequency or severity only break ties among siblings that do not depend on each other.

### Nodes carry labels a reader can act on

- **You SHOULD tag a bullet where the tag sharpens it**, prefixing the subject line — 'goal:', 'pro:', 'con:', 'idea:', 'assumption:', 'check:'.
  A tag is a claim, not decoration: 'assumption:' says you have not verified it, which stops the next reader building on it as though you had.
  It is also what withdraws decision 2 from one node, per the tree above: a reader who cannot agree from the subject alone needs telling before they do it anyway.

- **Nodes a reader might want to refer to SHOULD have a typed ID**, prefixing the subject line.
  **D1** for a decision, **Q1** for a question, **I1** for an idea, **D2.1** for its first child.
  IDs beat numbered lists, which renumber silently when a sibling is inserted.

  - **A published ID MUST be stable.**
    Reuse it rather than minting a second one for the same node.

- **A citation MUST carry the node's subject line, not the ID alone.**
  The ID is a handle for replying, not a substitute for the content.

  - **A reader who cannot see the original gets nothing from "Q1 is still open"** — a later artefact, a fresh session, a sitrep picked up after a compaction.

  - **The ID's stability is what makes restating it cheap**, not what excuses omitting it.

### The interleaving

**A trace of one interleaving, in columns: the shared state, then one per actor.**
The rules below are linked — a trace missing any one of them is not readable as a trace — so the set is read whole rather than sampled.

- **The shared state the actors contend for MUST take the leftmost column.**
  A row that changes it MUST carry the new state there, and a row that does not MUST leave it blank.

  - **Append-only state accumulates**, so the column reads downwards as the medium itself — `@20 BlockBoundary(4, b7)`, `@21 NoOp(5)`.

  - **Mutable state replaces**, so it reads downwards as a timeline — `held(A)`, `free`, `held(B)`.

- **Where the medium addresses its entries, the address MUST sit in that column beside them.**
  An LSN for anything log-backed, otherwise a sequence number or a lock acquisition.
  It MUST NOT be wall-clock.

- **Each actor MUST take a column, headed with its identity and its initial state.**
  `[A] leading at 4`, `[B] following, fence=4`.
  Its cells carry the local reasoning behind each operation — `poll empty → w`, `5 > 4 → leads@5`.

- **A row MUST hold one operation**, and vertical position carries happens-before.

- **A read MUST cite what it observed** — `r(@20)` against a log, `r(free)` against a lock, `r(x=0)` against a field.
  A read citing anything but the column's latest is a stale read.

- **A row SHOULD carry a label** — `a1`, `b2`: one letter per actor, then a counter.
  Prose MUST cite a row by its label rather than paraphrasing it.

- **An outcome block below the trace SHOULD attribute each resulting field to the row that produced it**, with `←`.
  `termId = 5 ← b4, B's term`, `boundaryReplicaMsgId = 20 ← a1, A's cut`.

- **An actor leaving MUST be a row** — `a3  crash` — changing no shared state.

- **`→` and `:=` MUST keep their meanings inside a cell.**
  `5 > 4 → admitted` is *therefore*; `fence := 5` is a state change.

A promotion finishing a block the previous leader left open:

```
      log                      A (leading@4)      B (following, fence=4)
a1    @20 BlockBoundary(4,b7)  cutting b7 → w
a2                             writes b7's files
b1                                                r(@20) → holds b7's boundary
b2    @21 NoOp(5)                                 poll empty → w
b3                                                r(@21); 5>4 → leads@5
b4    @22 BlockUploaded(b7,5)                     produces b7 → w
a3                             crash
b5                                                r(@22) → adopts b7

persisted b7:  termId               = 5   ← b4, B's term
               boundaryReplicaMsgId = 20  ← a1, A's cut
```

### Layout

- **A blank line marks a block boundary** — between one bullet and the next, and between paragraphs of an elaboration.

- **A subject and its elaboration are one block**, so no blank line falls between them and the elaboration begins on the line immediately below.
  A strict CommonMark renderer takes that single newline as a *soft* break and merges the subject into the first line under it; the destinations Chalk publishes to take it as `<br>`, and the skill files are read as source.

- **The line format is the one thing the destination decides**, according to whether the artefact is read rendered or reviewed as a diff.

  - **Paragraph-per-line** — commit bodies, issue and PR descriptions, chat.
    A single newline renders as `<br>` on those destinations, so sentence-per-line fragments into staccato.
    Put each paragraph on one line, separate paragraphs with a blank line, and let the rendering wrap.

  - **Sentence-per-line** — in-repo dev documentation, code comments, per [Semantic Line Breaks](https://sembr.org): break at sentence and clause boundaries.

  - **Whichever applies, it applies inside a bullet too**, which is where it is most often forgotten.

- **You MUST give the subject its own line**, with any elaboration indented to line up under its first character — two spaces under a top-level bullet, four under a nested one, etc.

  - **You MUST bold the subject's claim**, which on a subject that is nothing but its claim is the whole line.
    The bold is what separates a subject from the elaboration directly below it, where no blank line falls between the two.
    It is not a terser skim layer inside the subject: a claim chopped into load-bearing fragments stops reading as a claim, and the skim path is the subject lines themselves.
    What stays unbolded is a trailing qualifier that is not part of the claim — ", prefixing the subject line", ", per `chalk:voice`".

  - **On a paragraph-per-line destination the break after the subject is the one exception to the line format.**
    Each paragraph of the elaboration stays on one line, however long it runs.

## tl;dr

- **A tl;dr is a mindmap at takeaway grain**: one top-level bullet per takeaway, children backing it up.
  It is the reader's first paging decision over the whole artefact, so its subjects carry the same obligations as any other: placeable against a goal, and safe to agree with unread.

  - **The mindmap is the part that is not optional.**
    A summary sentence MAY come before it; the tree MUST be there either way.
    A tl;dr written as prose has spent the reader's first decision on a paragraph they have to read in full before they can navigate anything.

  - **That sentence is an abstract, and MUST be one sentence.**
    It says what is true now, in the terms the reader arrives with.
    **It MUST NOT argue the change**: the grounds are the body's, and a summary that starts giving them is the body arriving early.

  - **Avoiding the flat row of one-liners walks into a paragraph of prose.**
    The flat row has the shape and no argument; the paragraph has the argument and no shape, and it is the one that looks finished.

- **It summarises the artefact for its reader, not the session for its author**, and MUST be readable by someone who did not see the session, the branch or the prior state.
  Provenance goes down into the body, where whoever wants it will find it.

- **It opens the artefact by default, and takes no heading there.**
  Nothing else can be in that position, so a heading only labels what the reader has already worked out — the body starts with the summary sentence, then the mindmap, then the first real section.

  - **Displaced from the opening, it MUST carry a `tl;dr` heading.**
    The position was what marked it; once something else holds that position, only the heading tells the reader they are looking at the summary and not at more body.
    Chat is the case: `chalk:sitrep` and the chalk output style put it at the bottom, because a terminal scrolls upward.

- **A destination MAY override the placement, and whether one appears at all, by saying so itself.**
  Neither the takeaway-grain rule nor the readable-cold rule is overridable.

## References

**Anything the artefact points at — a commit, an issue number, a file path, a named section — MUST exist and MUST say what the sentence claims it says.**
Verify before publishing rather than from memory: `git cat-file -e <sha>^{commit}`, and read the subject.

- **A SHA is quotable only once it has landed on the target branch.**
  A commit on the branch you are on can still be rebased, amended or squashed, and a PR that lands as a single squashed commit destroys every SHA in it — so a body citing one ages into a reference to nothing, in the artefact whose whole job is to still be readable in six months.

- **Refer to an unlanded commit by a shortened form of its subject line instead.**
  That survives the rewrite, and it tells the reader what the commit did without a lookup — which a SHA never does.
