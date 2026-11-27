---
name: drive
description: >
  Commit one ready sub-goal to the project's standards through the drive agent, as one of three kinds of frame: a tidy changes structure, an advance changes behaviour, an amend makes an earlier unlanded commit fit for purpose.
  Where a dart takes the straight line to the goal, a drive takes the road — the coding standards, tests, definition of done and review the dart ignored.
  A drive is a stack: a tidy or an amend can interrupt the frame in hand, and a better drive can pre-empt it; a main-bound tidy reaches the user on a pushed branch of its own, a tidy that only eases an advance goes directly under it, an amend inside its commit, and the rest on top.
  Use when the user says "drive <sub-goal>", "land this", "tidy <what>", "this needs a tidy first", "pause, let's tidy that", "fix up that earlier commit", picks a sub-goal offered by `/a-star`, `a-star:dart` or another drive, or a dart or drive turns up a structure change.
user-invocable: true
argument-hint: "<sub-goal, or the structure change needed>"
---

# a-star Drive

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: a small change, ready to merge, that the user can review from its diff, its message and its `review:` entry.**

Load `a-star:a-star` first.
**You, the orchestrator, hold the stack; the `drive` agent commits each frame.**
The steps from recording the frame to handing over are the `TakeDrive` rule's guidance in `spec/orchestrator.allium`, as are the `Interrupt`, `PreEmpt` and `Fail` rules; the frame, slicing and branch rules you rewrite commits by are in `spec/drive.allium`.
