# Chalk

GitHub Issue-backed agent session memory.

Similar to [beads](https://github.com/steveyegge/beads) but uses GitHub Issues as the storage backend, for projects that already have their issue tracking in GitHub.

Chalk tracks your Claude Code session progress against a GitHub Issue.
The issue description holds the current-state checklist (a `## Progress` section); each implementation loop gets its own comment capturing decisions, progress, and blockers.

## Conventions

- **Issue description** = current state (mutable). The `## Progress` section is the canonical checklist of where things stand. Updated in-place as items are completed or added.
- **Comments** = implementation log (append-only). One comment per implementation loop (plan → implement → commit). Each comment captures what was tried, decided, and learned.

The issue description is what you read to get up to speed quickly.
The comments are what you read when you need to understand *how* you got here — essential context for resuming after compaction or picking up someone else's work.

## Installation

Add this plugin to your `.claude/settings.json`:

```json
{
  "plugins": ["path/to/chalk"]
}
```

Requires the `gh` CLI to be installed and authenticated (`gh auth login`).

## Usage

- `chalk #N` — track this session against issue N
- `chalk new` — create a new issue and track against it
- `chalk status` — show what you're tracking
- `chalk off` — stop tracking

Chalk also auto-activates when you mention a GitHub issue number (e.g. "#123").

## Components

- **Skill** (`chalk`): The main user-facing skill for session tracking commands
- **Agent** (`github`): Handles all GitHub API interaction, keeping the main context clean

## Permissions

Chalk needs permission to run `gh` commands.
Add these to your project's `.claude/settings.json` under `allowedTools`:

```
Bash(gh issue view *)
Bash(gh issue comment *)
Bash(gh issue edit *)
Bash(gh issue create *)
Bash(gh repo view *)
Bash(gh api *)
```
