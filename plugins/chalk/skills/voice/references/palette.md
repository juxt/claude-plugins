# The issue and PR section palette

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**These sections are a checklist against forgetting, not a taxonomy to file into.**
Nothing reads the headings but a person, so a section's *existence* buys the reader somewhere to look and its *boundary* buys almost nothing.
Where two entries below overlap, put the material in one of them and don't split it.

`chalk:voice` carries the register and the shape; `chalk:issue` and `chalk:pr` carry what each artefact is for, who reads it, and **which sections its path takes, in order**.
This file carries what goes in each section.

## The three modes

- **issue, no PR expected** — nothing about the implementation is interesting enough to warrant one.

- **issue + PR** — the issue carries the problem, the prior art and the constraints.
  The PR opens `Resolves #N` and is about what changes in the implementation.
  **It MUST NOT restate the issue**: assume the reader has read it.

- **standalone PR** — it carries the problem too, so the problem sections are inserted between the tl;dr and What changes: **Symptoms → Root cause** for a bug fix, **Problem** for a feature.
  **Those only.** Properties of a good solution, Prior art, Invariants and Potential approach are design-space or forward-looking material, and a PR is retrospective — evaluation criteria written after the choice read as justification for it.

**The issue is a living document; the PR freezes at merge.**
That is why an issue MAY hold marked speculation — it has a mechanism for resolving it — and a PR mostly may not.

**In `issue + PR`, the issue is the artefact that goes stale.**
Where the work contradicted a constraint the issue asserted, or the prior art didn't transfer, the issue MUST be corrected before the PR closes.
Otherwise the later reader finds a confident, wrong problem statement and a PR that silently disagrees with it.

## State the confidence, not just the content

**The reader needs to know whether they can act on a line or must re-check it**, and that is a different fact from the line itself.
It surfaces in three places, and MUST be carried in each.

- **A speculative claim on an issue MUST be marked** — `assumption:` or `idea:` - per `chalk:voice`.
  On the bug path that is the default rather than the exception.

- **An Alternative approaches entry MUST say which road it was**: reasoned against, or tried and abandoned.
  "Tried it and the driver deadlocked" closes a road harder than "considered, and write amplification ruled it out".

- **A rejection whose premise could expire MUST be dated.**
  "Rejected on 2026-05-23 because the driver had no batch API" tells the next reader what to re-check; an undated one asks them to take it on trust forever.

## The sections

- **tl;dr** — **compulsory on every path.**
  It fills the two slots `chalk:voice` gives a tl;dr: the opening summary sentence, then the mindmap.

  **The abstract is that sentence, and it works like a bloom filter.**
  A reader scanning a list gets a definite *no* from it, or a *maybe*, without opening anything else.
  **False negatives are the failure that matters**: someone with this exact problem MUST NOT be able to rule it out from the abstract, where a false positive costs them one more section.
  So it names the problem in the terms the reader arrives with — "queries not performing" — not the mechanism they don't yet know about.

  **The mindmap carries context and motivation as one tree, not two labelled groups** 
  The motivation is only legible against the context, and splitting them makes the reader hold one half while they go looking for the other.
  **Context SHOULD come first in the tree**, because that is the order a reader processes them in.

  - **Context runs in both directions**: where this sits — the user-facing effect, the initiative it belongs to, the deployment it showed up under — and **what it unblocks**, the work that can't proceed until it lands.
  - **A named downstream is the strongest form of *why now*, because it is checkable.**
    "The replica log work can't start until this lands" can be confirmed or refuted; "this is important" can't.
  - **It MUST be objective, not persuasive.**
    The tell is a sentence that carries the same fact with its evaluative words deleted: if "seriously degrades" and "degrades" say the same thing, the adverb was doing persuasion.
    **"Unblocks future work" fails that test by surviving deletion entirely** — name the work, or cut the claim.
  - **Where the unblocking is a graph edge, wire the edge.**
    GitHub renders blocked-by with nobody maintaining it, so name the downstream in a clause rather than re-listing what the graph already shows.

  On a PR resolving an issue the abstract is **what changes in the implementation**, and the context half compresses to the issue link.
  Where the change adds a capability, name the capability — "you can now query across blocks without a full scan" — never its significance.

- **Problem**
  **What someone can't do today, and what it costs them.**
  Stated as the deficiency, not the implementation: "you can't filter by timestamp without reading every block", never "`BlockScanner` has no predicate pushdown".

  - **A problem stated in code dates the moment work starts**, because it describes the implementation the fix replaces — and it doesn't survive a change of approach, where the deficiency does.
  - **It also presupposes one.** Naming the types that need changing is Potential approach arriving early, in the section least equipped to mark itself speculative.
  - **Where implementation detail is what makes the gap legible it is evidence for the problem, not the problem** — one sentence, then back out.
    The code-level account belongs in What changes on the PR side, which is retrospective and so can't date.

  **What writers drop is the gap itself.**
  A description of today's behaviour with no statement of what it can't do leaves the reader to infer the problem from the absence of a feature.

- **Symptoms**
  Observable behaviour, error messages, affected conditions ("multi-writer only", "under chaos monkey testing"), and the repro.

  **It MUST carry the literal strings** — the exact error text, the version, the condition that triggers it.
  `chalk:issue`'s reader 2 is matching their failure against this section rather than reading it, so this is the one section written for search: `chalk:voice`'s cut-what's-obvious rule does not license paraphrasing an error message, and its mindmap default does not license turning a trace into prose.

- **Root cause / Analysis**
  The mechanism, grounded in evidence, and **marked speculative until confirmed**.

  **Evidence is annotated in place, never a section of its own**: log excerpts, block-file contents, offset tables and message-type distributions sit next to the claim they support.
  **Raw material MUST be annotated wherever it appears** — a dump with no statement of what the reader is looking at is noise.
  Where the bug *is* an ordering, see *Annotated traces* below.

- **Properties of a good solution** — **contested changes only, and never on a bug**: a bug has a correct answer, not a design space.
  The criteria any answer will be judged against. Unnecessary where the change is uncontroversial.
  It is an **input**: written before the choice, it constrains it, and it is what stops Invariants and Potential approach being argued in a vacuum.

  *Known failure mode, accepted:* written after choosing, it retrofits criteria the chosen approach happens to satisfy and reads as persuasion.
  There is deliberately no machinery here to police that.

- **Prior art** — **contested changes only, and never on a bug**; where there is a correct answer, or nobody would push back on the direction, there is no constraint left to discover.
  Who has done this before, why, and **what constraints they had that we also do or don't**.

  This is constraint discovery, not endorsement.
  "Here's what Swift does" as a reason to do the same thing is the framing that fails `chalk:voice`'s no-persuasion rule; "Swift can do this because it has no stable ABI, and we do" is the same sentence carrying a fact.
  **What writers drop is the *don't*** — an entry listing only the constraints we share has done half the work.

- **Invariants**
  The non-obvious things any solution must preserve. An **input** to the design.

  **An invariant a test can pin SHOULD be a test, not a sentence here.**
  Prose asks someone not to revert a constraint; a test refuses to let them, and only a test has a decay alarm. This section carries the ones no test can hold.
  Against Consequences: an invariant any solution **must preserve** is an input and lives here, where a constraint this change **created** is inherited and lives there.

- **Potential approach**
  One **goal tree** (`chalk:goal-tree`) of what has to be true when this is done — not which files to touch.
  **Named "potential" deliberately**: it is a direction nobody has walked yet, and the heading is the one place a reader can't skip that.
  **Future state** and **Implementation** both land here; neither is a section of its own.

  A child MAY be a link to the issue that owns that part, and under `chalk:issue`'s one-piece-or-children rule the tree doubles as the sub-issue skeleton — which is why it is compulsory on a parent issue.
  **It dies on the PR side**: a PR is retrospective, and what landed is What changes and Consequences.

- **What changes** — **compulsory.**
  Written to PEP's **"How to Teach This"** test: how would you explain this to someone who already knows the old system?
  A drafter can *fail* that question, where "state the delta" is satisfiable vacuously.

  **It MUST name the fact that was true and is no longer**, stated objectively and never as a belief attributed to the reader: "the watermark wasn't being replicated", not "you believed the watermark was replicated".
  **Compulsory rather than palette-optional, because it is invisible from the author's side** — the author holds the new model, so the delta reads as obvious. Palette-optional and reliably-dropped are the same outcome.

  - **For an equivalence change: "Behaviour is unchanged."**
    Three words. Usage / migration is then omitted, and this section is an implementation-model delta — `chalk:pr`'s reader 1 holds a model of the code, not only of the behaviour.

  Kept as one section deliberately: split into a delta and a compatibility note, the drafter writes it twice and the second copy decays into the first.

- **Usage / migration** — **where the change is user-visible, or needs a step that isn't in the diff.**
  A worked example or a before/after, concrete — SQL with realistic output, a CLI invocation, a config snippet.

  **Manual adoption steps MUST be here.**
  If a reader can't act on the change without a step that isn't in the diff — a migration to run, a config value or env var, a flag to enable, something to regenerate, a deploy-order constraint — the step goes here.
  **Rollout and compatibility land here too**: where the change is only safe under conditions the diff can't express, say which versions interoperate and what the safe sequence is.
  Where it's an end-user feature the full guide is in the docs, so keep this short; the reader is a senior engineer on the project.

- **Consequences**
  Nygard's ADR field: what is different as a result, and now inherited.

  - **Risks / constraints** — what we now need to be careful of.
  - **Breaking changes** — users with problem A will need to B.
  - **Operational** — what is different for whoever is on call: a new failure mode, a metric that now means something else, a thing that fails differently.
  - **Gotchas** — Chesterton's fence: **we do it like X because Y**. "Be careful of Z" with no reason is an unlabelled fence.
  - **Measurements**, where one exists nowhere else — "p99 340ms → 40ms on the 10M-row fixture", "verified the rolling deploy by hand on staging".
    **A test-plan checklist does not belong anywhere in the description** — CI renders it. The measurement is what survives.

  **Why not Rust's "Drawbacks":** theirs prices a cost so a reviewer can weigh it before saying yes, and it disappears once the answer is yes.
  This is a handover section — the cost is already accepted, and the reader needs to know they inherited it.

- **Out of scope**
  **Only the counter-intuitive exclusions**: what would a reasonable reader think is in scope here, and isn't?
  A list of corrected expectations, not an inventory of everything adjacent.

  - **It carries as much weight as what the change does include**, because a wrong expectation is the one that gets acted on — someone builds on a behaviour that isn't there, or re-opens a decision that was never made.
  - **The test is `chalk:voice`'s cut-what's-obvious rule run in the other direction**: cut what a reasonable senior engineer already knows, and *keep* what they would reasonably get wrong.
    An exclusion nobody would have expected here isn't out of scope, it is just absent.
  - **Give each entry its reason**, and the issue or PR that picks it up where one exists.
  - **Name the rule you split on** (`chalk:voice`) — this is a section where the reader's next question is "is that all of them?", and a missing sibling otherwise looks exactly like no sibling.
  - **Rust's "Future possibilities" lands here**: an adjacent thing we deliberately didn't do is out of scope.
  - Against the tl;dr's *what it unblocks*: something we chose not to do here is out of scope, where something that couldn't start until this landed is context.

- **Alternative approaches**
  The decision record. **One entry per road** — the design sketched, and what ruled it out.

  **Alternatives considered, Decision rationale and Dead ends all land here**, because one entry per road covers both the reasoned-against and the tried-and-abandoned, and *State the confidence* above requires the entry to say which.
  **Name what ruled a road out; do not argue that the chosen one is good.**
  The reader has the diff and can check, so argument where evidence would do reads as something you couldn't show.
  Implementation-strategy choices — refactor-in-place versus parallel implementation, big-bang versus incremental — aren't alternatives at this level; they are Potential approach.
  **Name the rule you split on**, for the same reason as Out of scope.

  **The position is deliberate**: a reader arrives here by searching for a road, not by reading forward.

- **Open questions**
  What is still unanswered, and **what would settle each** — a decision owed, a hypothesis nobody verified, a measurement not taken.
  Tagged `Q<n>` (`chalk:voice`) so it can be answered by reference, and **an entry MUST be deleted once it is answered**, with the answer moved to wherever it now belongs.
  **Distinct from Out of scope**, which records a decision that something is excluded; this records the absence of one.

  - **On an issue** — a to-do with a route to an answer.
    A closed issue still carrying live questions reads as unfinished work, and `chalk:issue`'s reader 3 can't tell that it isn't.
  - **On a PR** — what this change did not settle.
    A PR freezes at merge, so it has no mechanism for resolving one: **anything actionable MUST become an issue the PR links**, and what stays is provenance. "Nobody measured this" stops the next reader assuming somebody did.

## Annotated traces for sequencing bugs

When the bug *is* an ordering — a race, a leadership transition, a distributed-log divergence — the explanation **is** the sequence of events.
Prose describing that sequence is much harder to follow than the sequence itself; a raw log dump is the opposite failure — all the data, none of the causality, so it reads as noise.

Reconstruct a chronological trace and annotate it.
Name the actors (`[A]`/`[B]`, leader/follower) rather than "the node".
Show the load-bearing state inline as it changes, mark the point where things diverge, and end at the failure.
Distil from a real trace (a captured log, a debugger session) down to the events that carry the causality; drop everything else.

```
TERM 1 — node A is leader:
  leader ← source 0..4             [A] watermark → 4   (local, NOT replicated)
  leader → replica: ResolvedTx     [B] follower stays at -1   ← B never sees A's progress

FLIP: A → follower (keeps src=4),  B → leader
  B resumes from -1 (its own stale watermark) → re-reads source 0 → emits BlockBoundary(src=0)

FAILURE — follower A applies it:   notifyMsg(0) while watermark=4   →   0 < 4, throws
```
