---
name: setup
description: >
  Set a repo up for a-star: the beads plugin and `bd` installed, a bd workspace initialised without touching tracked files, and the project's a-star policy checked for gaps.
  Use when `/a-star` finds no bd workspace, or the user says "/a-star:setup", "set up a-star here", or "set up beads".
user-invocable: true
---

# a-star Setup

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**Success: `/a-star <card>` can run in this repo, and nothing tracked changed to make it so.**

**Each step checks before it acts, so running setup on a repo that's already set up changes nothing.**
Installing software and editing the user's machine are the user's to approve: say what each install will do, and wait.

1. **The beads plugin is installed** — a-star depends on it, for its `bd prime` hooks at session start and before compaction.
   Where it isn't, the user adds it: `/plugin marketplace add gastownhall/beads`, then reinstalls a-star.

2. **`bd` is on the path** — `bd version`.
   Where it isn't, offer `mise use -g github:gastownhall/beads@1.3.1`, or `npm install -g @beads/bd`.

3. **This repo has a bd workspace** — `bd where`.
   Where it doesn't: `bd init --setup-exclude --skip-agents --skip-hooks`.
   - **`.gitignore` MUST have no uncommitted changes first** — `git diff --quiet -- .gitignore`.
     Where it has, stop and raise it: the revert below would take the user's edits with it.
   - **`bd init` edits the tracked `.gitignore` despite those flags.**
     Check its lines are in `.git/info/exclude` — `--setup-exclude` normally puts them there — then `git checkout -- .gitignore`; `git status` MUST show nothing tracked changed.
   - **You MUST NOT run `bd setup`.**
     It writes a repo-root `CLAUDE.md` and `.claude/settings.json`, with instructions broader than a-star wants.

4. **Spike worktrees are ignored** — `.claude/worktrees/` is in `.git/info/exclude` or the project's `.gitignore`.
   Where it isn't, add it to `.git/info/exclude`.

5. **Report the project's policy gaps**: each slot in `a-star:a-star`'s policy table the project's `AGENTS.md`, `CLAUDE.md` or a-star config skill doesn't answer.
   Raise them as questions; don't fill them — writing the project's policy is the project's job.
