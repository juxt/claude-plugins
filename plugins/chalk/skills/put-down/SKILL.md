---
name: put-down
description: Park the session's work on its issue, so the next session can resume from the issue and its links alone — the description corrected, the metadata sorted, and cards the session discovered raised and linked as appropriate. Use when the user says "put this down", "park this", "/chalk:put-down", or is switching this session away from the issue's work.
user-invocable: true
argument-hint: "[issue, if the session hasn't named one]"
---

# Put-down

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**The code state survives a session on its own; the analysis state does not.**
What the session learned, the questions it left open and the work it discovered all evaporate when it ends, unless they are on the issue.

**The success criteria for this skill is that the next session can resume from the issue and its links alone.**

## Before you start

- **Load `chalk:issue`**, which loads `chalk:voice` and carries the description's palette, the correction rules, the weeding loop and the filing mechanics.

- **Ground it in the repo, not the transcript.**
  `git status`, `git log` and the branch say what landed; the transcript only says what was attempted.

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

- **A related card MAY just be mentioned by number.**
  That is often the right weight for a relationship that doesn't order the work.

- **A card mentioned only in the transcript is lost** when the session ends, which makes this the step a put-down most exists to force.

## 3. Sort the metadata

**Assignee, status, labels — whatever the project's tracker conventions say for a card that is being put down.**
Where they don't say, ask; MUST NOT guess.

## 4. Report back

**The issue, each card raised, and what changed on each.**
