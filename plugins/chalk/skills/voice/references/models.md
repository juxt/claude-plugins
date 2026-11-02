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
