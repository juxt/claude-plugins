---
name: setup
description: >
  Set a repo up for a-star: spike worktrees ignored, and the project's answers to a-star's own choices checked for gaps.
  Use when the user says "/a-star:setup" or "set up a-star here", or before a repo's first spike.
user-invocable: true
---

# a-star Setup

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: `/a-star <card>` can run in this repo, and nothing tracked changed to make it so.**

**Each step checks before it acts, so running setup on a repo that's already set up changes nothing.**

1. **Spike worktrees are ignored** — `.claude/worktrees/` is in `.git/info/exclude` or the project's `.gitignore`.
   Where it isn't, add it to `.git/info/exclude`.

2. **Report the project's gaps**: each of a-star's own choices (`a-star:a-star`, *What the project says*) that the project's `AGENTS.md`, `CLAUDE.md` or a-star skill doesn't answer.
   Raise them as questions; don't fill them — writing the project's conventions is the project's job.
