# Chalk

GitHub Issue-backed agent session memory.

Similar to [beads](https://github.com/steveyegge/beads) but uses GitHub Issues as the storage backend, for projects that already have their issue tracking in GitHub.

Chalk tracks your Claude Code session progress against a GitHub Issue.
It creates a single session comment and edits it in-place as work progresses, giving you a live log of decisions, progress, and blockers.

## Conventions

- **Issue description** = current state (mutable). The tl;dr of where things stand — status, open questions, key decisions. Updated in-place as the picture changes.
- **Comments** = session log (append-only). One comment per session, edited in-place during the session, but never deleted. Each comment captures what was tried, decided, and learned.

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

## Permissions

Chalk needs permission to run `gh issue` commands.
Add these permission rules to allow non-interactive use:

```
Bash(gh issue view *)
Bash(gh issue comment *)
Bash(gh issue edit *)
Bash(gh issue create *)
```
