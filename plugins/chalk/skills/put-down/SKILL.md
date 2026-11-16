---
name: put-down
description: Park the session's work on its issue, so the next session can resume from the issue and its links alone — the description corrected, the metadata sorted, and cards the session discovered raised and linked as appropriate. Use when the user says "put this down", "park this", "/chalk:put-down", or is switching this session away from the issue's work.
user-invocable: true
argument-hint: "[issue, if the session hasn't named one]"
---

# Put-down

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Neither the code state nor the analysis state survives a session on its own.**
Unpushed commits go with the session's checkout, and what the session learned, the questions it left open and the work it discovered all evaporate when it ends, unless they are on the issue.

**The success criteria for this skill is that the next session can resume from the issue and its links alone.**

## Before you start

- **Load `chalk:issue`**, which loads `chalk:voice` and carries the description's palette, the correction rules, the weeding loop and the filing mechanics.

- **Ground it in the repo, not the transcript.**
  `git status`, `git log` and the branch say what landed; the transcript only says what was attempted.

- **Unfiled work is filed first**, through `chalk:issue`, and the steps below record on that issue; its filing is step 1.

- **Load `chalk:chalk`, and read the session's plan, where it started one.**
  What the issue's next reader needs from it — open questions, and decisions that bear on the problem — reaches the issue through `chalk:issue`'s own path below.

- **In secondary, per `chalk:secondary`: wherever a step below would ask the user, decide and record.**

## 1. Ensure the description is correct and up-to-date.

**Through `chalk:issue`'s own path: Correcting the description, Open questions, then Weed the draft.**
Put-down adds no second shape for the description.

- **Every open note goes in, IDs unchanged**, whatever types the session holds.
  A note answered this session is deleted, its answer moved to wherever it now belongs.

## 2. Raise and link cards the session discovered as appropriate

**Each piece of work the session found but didn't become a candidate for an issue**, filed through `chalk:issue`, unless one already exists.

If it is in any way unclear, you MUST confirm with the user which ones they want raising.

- **Parent/child relationships MUST be wired in the tracker**, as must blocked-by where the tracker models it.
  A child known only from a mention in the parent's text doesn't show up in the tracker's own view of the parent.

- **A card this work turned out to wait on gets the dependency written onto it**, through `chalk:issue`'s own path, and not only the edge.

- **A related card MAY just be mentioned by number.**
  That is often the right weight for a relationship that doesn't order the work.

- **A card mentioned only in the transcript is lost** when the session ends, which makes this the step a put-down most exists to force.

## 3. Sort the metadata

**Assignee, status, labels — whatever the project's tracker conventions say for a card that is being put down**, through the github agent.
Where they don't say, ask; MUST NOT guess.

## 4. Push the branch, and record where the work stands

**Before pushing, weed the commit messages**: run `weed-pr`'s commit-message pass alone, and apply its findings by rewording each commit through `chalk:commit`.
The branch is handed over without a PR, so nothing else weeds them.

**Push the feature branch, WIP commits included**, with force-with-lease where it was rewritten — a branch the session owns, per `chalk:chalk`'s Feature branches.
A branch the session doesn't own is left as it is, and the report says so.

**Then record on the issue, as a comment through `chalk:issue`, what the next session resumes from**: the branch, its head commit's subject, and what was in hand — the stack of sub-goals being worked, innermost first.
It goes in a comment, not the description: it moves with the work.

## 5. Report back

**The issue, each card raised, what changed on each, and the branch pushed.**
