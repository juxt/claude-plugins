# Chalk

Capture intent across issues and commits — why, not just what.

Chalk is an intent layer for Claude Code.
It ensures that the *reasoning* behind your work is captured at every level: why you're doing this work (issues), and why each change was made the way it was (commits).

Similar to [beads](https://github.com/steveyegge/beads) but uses GitHub Issues as the storage backend, for projects that already have their issue tracking in GitHub.

## The Intent Stack

- **Issues** (`chalk #N`): track session progress against a GitHub Issue. The issue description holds current state; each session gets a comment capturing decisions, tradeoffs, and dead ends.
- **Commits** (`/chalk:commit`): create commits with contextual bodies that explain the *why*. When chalk is tracking an issue, commits automatically reference it and draw on the session context for richer messages.
- **Pull requests** (`/chalk:pr`): create PRs with descriptions that capture the problem, the approach, key decisions, and scope boundaries. Delegates to the github agent for the actual creation.

The issue description is what you read to get up to speed quickly.
The comments are what you read when you need to understand *how* you got here.
The commits are what you read when you need to understand why a specific change was made.

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

- `chalk #N` — track this session against issue N
- `chalk new` — create a new issue and track against it
- `chalk status` — show what you're tracking
- `chalk off` — stop tracking
- `/chalk:commit <headline>` — create a contextual commit (references tracked issue when chalk is active)
- `/chalk:pr [title]` — create a PR with an intent-driven description

Chalk also auto-activates when you mention a GitHub issue number (e.g. "#123").

## Components

- **Skill** (`chalk`): Session tracking against GitHub Issues
- **Skill** (`commit`): Contextual commits that capture the why, with chalk integration
- **Skill** (`pr`): Pull requests with intent-driven descriptions
- **Agent** (`github`): Handles all GitHub API interaction, keeping the main context clean

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
Capture those conventions in the project's `CLAUDE.md` so they're in the main agent's context; the chalk and pr skills will pass them through to the github agent when it creates issues and PRs.

Example `CLAUDE.md` section:

```markdown
## GitHub conventions

- New issues go on the `Platform` project board.
- Apply the `needs-triage` label to new issues unless labels are already specified.
- Request review from `@alice` on every new PR.
- PRs target `develop`, not `main`.
```

Anything the main agent can see, the chalk/pr skills can pass through — there's no separate config file to maintain.
