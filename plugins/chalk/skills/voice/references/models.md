# Describing a model

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**A model is objects, their roles and their responsibilities, and these are the terms to state one in.**
Files, packages and steps are not the model: a description that opens with a list of files has skipped the level where a disagreement about the design lives.

## What a model states

- **Which objects exist, and where the boundaries between them fall.**

- **The role each holds** — exactly one of three.
  - **Active** — offers a choice among simultaneously-ready events; it is defined by the choice it offers, not by owning a thread.
  - **Passive** — completes everything it does on the caller's control flow.
  - **Monitor** — passive state that someone waits on; its wait condition MUST be re-evaluable, so a latching condition is a defect in the monitor rather than a subtlety of the runtime.

- **The state each owns** — what counts as one value, whether it is swapped whole or accumulated in place, and the single point that writes it.
  Try to name a value the identity holds in between two writes: if you can, it is two values.

- **The lifetimes** — which region holds each thing, and what it outlives.
  Regions form a tree, and a reference MUST NOT outlive its owner.

- **Who waits on whom**, and who signals.

## A change is a model diff

**State the current model and the target in the same form, covering only the elements the change touches**, so the difference between them reads as a diff.
A reader can correct a model diff in one line; a file list or a finished diff gives them nothing to correct but the code.

## The prior art behind the terms

**Naming the source is what keeps a design disagreement short**: each term above carries the decisions of the work it comes from, and a disagreement with one of these is the interesting part of a plan.

| idea | source | what it informs |
|---|---|---|
| Functional core, imperative shell | Bernhardt, *Boundaries* (2012) | where autonomy lives, and where it must not |
| Active Object, Monitor Object | Schmidt et al., *POSA2* (2000) | the three roles, and that an object holds exactly one |
| External choice `□` vs internal choice `⊓` | Hoare, *CSP* (1978); occam's `ALT` | that a process is defined by the choice it *offers*, not by owning a thread |
| A monitor's wait condition must be re-evaluable | Hoare (1974); Brinch Hansen (1973) | that a latching condition is a defect in the monitor, not a subtlety of the runtime |
| Identity, state, time — the epochal model | Hickey, *Are We There Yet?* (2009) | what counts as one value |
| Transients | Clojure | the second shape of a value — one owner, mutated in place, never published mid-flight |
| Aggregates | Evans (2003); Vernon, *Effective Aggregate Design* (2011) | the same boundary, with an atomic swap doing the transaction's job; Vernon for *placement* — keep it small, and ask who must see a change immediately and who can wait |
| `runST` | Launchbury & Peyton Jones (1994) | that local mutation which cannot escape is observationally pure, so a scope-local mutable is not a state question at all |
| Structured concurrency | Sústrik (2016); Smith (2018) | that lifetimes form a tree, and a region is a node in it |
| Ownership, RAII | C++; Rust | that a reference MUST NOT outlive its owner |
| Safe publication | Goetz, *Java Concurrency in Practice* (2006) | how a value crosses to another thread where there is no lock to point at |
