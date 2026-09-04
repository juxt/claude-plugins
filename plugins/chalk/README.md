# Chalk

Capture intent across issues, commits, and PRs — why, not just what.

Chalk is an intent layer for Claude Code.
It ensures that the *reasoning* behind your work is captured at every level: why you're doing this work (issues), and why each change was made the way it was (commits and PRs).

tl;dr: similar to [beads](https://github.com/steveyegge/beads) but uses the project's existing issue tracker (e.g. GitHub issues).

An agent working through anything non-trivial accumulates reasoning, and that reasoning has to live somewhere.
Held in the model's context it evaporates at the next compaction; kept in a bespoke store it becomes a silo that drifts from wherever the team actually works.
Chalk puts it in the artefacts you already have, each carrying the part it's the natural home for — and writes them for a human who wasn't there, reading months later.

## The Intent Stack

- **Issues** (`/chalk:issue`): file an issue whose description captures the problem, the evidence, and *why now* — enough that a reader can assess it without asking you. Also keeps an existing description accurate as the facts change.
- **Commits** (`/chalk:commit`): create commits with contextual bodies that explain the *why*, referencing the issue where there is one.
- **Pull requests** (`/chalk:pr`): create PRs with descriptions that capture the problem, the approach, key decisions, and scope boundaries. Delegates to the github agent for the actual creation.

Each is written for a different reader, and that's what keeps them from duplicating each other:

- The **issue** is what you read to decide whether to pick the work up.
- The **PR** is what you read to understand why the change was made the way it was, taken across the whole branch.
- The **commit** is what you read when `git blame` drops you on one specific line.

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
- `/chalk:commit <headline>` — create a contextual commit
- `/chalk:pr [title]` — create a PR with an intent-driven description
- `/chalk:sitrep [focus]` — report where the session has got to, and what's still open

## Components

- **Skill** (`issue`): Problem-focused issue descriptions, and keeping them accurate
- **Skill** (`commit`): Contextual commits that capture the why
- **Skill** (`pr`): Pull requests with intent-driven descriptions
- **Skill** (`sitrep`): Where the session has got to — what landed, and what's still open as ID'd ideas, decisions and questions
- **Skill** (`voice`): The shared writing voice — the audience, the specification register, the mindmap structure followable content takes, the line-format rule. `references/palette.md` carries the issue/PR section palette.
- **Skill** (`goal-tree`): Goal trees, where children accomplish their parent rather than argue for it, and each node is tested for sufficiency
- **Skill** (`code-comments`): What earns a code comment and what to delete — load it early in a session that touches code, and again when reviewing a diff
- **Agent** (`github`): Handles all GitHub API interaction, keeping the main context clean
- **Agent** (`weed-comments`): Deletes code comments that don't earn their place, arriving without the context that wrote them
- **Agent** (`weed-prose`): Reviews a drafted commit body or PR description as its pinned reader would, cutting what that reader already holds

The writing skills are loaded by the others rather than run directly.
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
