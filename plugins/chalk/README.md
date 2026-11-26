# Chalk

**Human context is now the scarce resource.**
An agent produces more change than anyone can hold in their head, so what limits the work is what the human has to read, decide and remember.

Chalk manages that context: what a person takes in, when they take it in, and what they can safely let go of.

It keeps the session's journal, and writes issues, commits and PRs in a style that lets the reader focus on what's important to them at the time: drilling down into the details when they need them, and not getting bogged down in them when they don't.

## The intent stack

**Each artefact carries the part of the reasoning its own reader needs, which is what keeps them from duplicating each other.**

- **Journal** — the session's decisions, questions and constraints, written into the plan file as they happen.
  Its reader is the session itself, and the next one after a compaction; it is what the issue, commits and PR are written from.

- **Issue** (`/chalk:issue`) — the problem, the evidence, and *why now* where there is one, kept accurate as the facts change.
  Its reader has decided to pick the work up, or is checking whether it is what they are hitting.

- **Pull request** (`/chalk:pr`) — the approach, key decisions and scope boundaries, taken across the whole branch.
  Its reader is a peer updating their mental model now, or the same person in a year asking why.

- **Commit** (`/chalk:commit`) — why this change exists, and why it was done this way.
  Its reader arrived from `git blame` on one line, mid-investigation of something else.

## The boundary

**chalk owns the record and the writing; it doesn't run the work.**
It plans nothing, picks nothing up, and never pushes or rewrites a branch.

chalk is the adapter side of ports and adapters (Cockburn's hexagonal architecture).
A process that needs something written or recorded names the need as a plain verb — write the commit message, raise a PR, weed the commit messages, record in the session's journal, put the work down on its issue — and chalk claims it through its skill and agent descriptions.
The user's own instructions bind the two.

## Installation

Add the marketplace (one-time):
```
/plugin marketplace add juxt/claude-plugins
```

Then install chalk:
```
/plugin install chalk@juxt-plugins
```

Or use the interactive `/plugin` UI and find chalk under the **Discover** tab.

Requires the `gh` CLI to be installed and authenticated (`gh auth login`).

## Usage

- `/chalk:issue [title]` — file an issue, or update an existing issue's description

- `/chalk:commit <headline>` — write a contextual commit message

- `/chalk:pr [title]` — create a PR with an intent-driven description

- `/chalk:sitrep [focus]` — report where the session has got to, and what's still open

- `/chalk:put-down [issue]` — put the work down on its issue: description corrected, metadata sorted, discovered cards raised and linked

- `/chalk:explicate <area> [focus or since-point]` — unfold an area of the code: how it works now, the decisions behind it and their consequences, then follow-ups as a depth-first walk

- `/chalk:rubber-duck [topic]` — talk a design through in whatever order it comes: decisions, constraints, questions and ideas kept under stable IDs, and turned into whatever the user picks at the end

## Components

Each skill and agent says what it is for in its own description.
The writing skills (`voice`, `goal-tree`, `journal`, and the `weed-*` agents behind `issue`, `commit` and `pr`) are loaded by the others rather than run directly.
`code-comments` is the exception: nothing else can know you're about to write a comment, so load it yourself.

## Permissions

Chalk needs permission to run `gh` commands.
Add these to your project's `.claude/settings.json` under `allowedTools`:

```
Bash(gh issue view *)
Bash(gh issue comment *)
Bash(gh issue edit *)
Bash(gh issue create *)
Bash(gh pr create *)
Bash(gh pr edit *)
Bash(gh project *)
Bash(gh repo view *)
Bash(gh api *)
```

## Project-specific conventions

Chalk itself is generic — it doesn't know which project board your new issues should land on, which labels to apply, or who should review your PRs.
Capture those conventions in the project's `CLAUDE.md` so they're in the main agent's context; the issue and pr skills will pass them through to the github agent when it creates issues and PRs.

Example `CLAUDE.md` section:

```markdown
## GitHub conventions

- New issues go on the `Platform` project board.
- Apply the `needs-triage` label to new issues unless labels are already specified.
- Request review from `@alice` on every new PR.
- PRs target `develop`, not `main`.
```

Anything the main agent can see, the issue and pr skills can pass through — there's no separate config file to maintain.
