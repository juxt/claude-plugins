# Chalk

**Human context is now the scarce resource.**
An agent produces more change than anyone can hold in their head, so what limits the work is what the human has to read, decide and remember.

Chalk manages that context: what a person takes in, when they take it in, and what they can safely let go of.

It writes issues, agents' plans, commits and PRs in a style that lets the reader focus on what's important to them at the time: drilling down into the details when they need them, and not getting bogged down in them when they don't.

## The intent stack

**Each artefact carries the part of the reasoning its own reader needs, which is what keeps them from duplicating each other.**

- **Plan** (`/chalk [issue]`) — the goal and the route, agreed in plan mode; then the session's journal of decisions, questions and constraints, written as they happen.
  Its reader is the session itself, and the next one after a compaction; it is what the issue, commits and PR are written from.

- **Issue** (`/chalk:issue`) — the problem, the evidence, and *why now* where there is one, kept accurate as the facts change.
  Its reader has decided to pick the work up, or is checking whether it is what they are hitting.

- **Pull request** (`/chalk:pr`) — the approach, key decisions and scope boundaries, taken across the whole branch.
  Its reader is a peer updating their mental model now, or the same person in a year asking why.

- **Commit** (`/chalk:commit`) — why this change exists, and why it was done this way.
  Its reader arrived from `git blame` on one line, mid-investigation of something else.

## With an implementation harness

**chalk plans and journals; how the work is implemented is left to a harness, or to none.**

- **A harness records through chalk's journal**
  Its record kinds — decision, question, requirement, principle, constraint, assumption, risk, dead-end, replan — are the interface, so the harness names what to record and chalk says where.

- **A harness hands back to chalk when it can't continue on the plan as approved**
  chalk re-plans where the goal is invalidated, parks the work on its issue where it can't continue, and opens the PR where the goal is complete.

- **[A⭐](../a-star/) is one such harness**
  It lands each change *"small and simple enough for a human to review and put down"* — the same scarce attention, spent at review time rather than planning time.

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

- `/chalk [issue]` — plan the session's work in plan mode, with or without a card, until the goal and route are approved; then journal decisions in the plan as they happen

- `/chalk:issue [title]` — file an issue, or update an existing issue's description

- `/chalk:commit <headline>` — create a contextual commit

- `/chalk:pr [title]` — create a PR with an intent-driven description

- `/chalk:sitrep [focus]` — report where the session has got to, and what's still open

- `/chalk:put-down [issue]` — park the session's work on its issue: description corrected, metadata sorted, discovered cards raised and linked

- `/chalk:explicate <area> [focus or since-point]` — unfold an area of the code: how it works now, the decisions behind it and their consequences, then follow-ups as a depth-first walk

- `/chalk:rubber-duck [topic]` — talk a design through in whatever order it comes: decisions, constraints, questions and ideas kept under stable IDs, and turned into whatever the user picks at the end

- `/chalk:root-cause [symptom]` — find why something happened, as a fault tree: the observed symptom at the root, immediate causes beneath it, each settled against evidence kept in one file

## Components

- **Skill** (`chalk`): Plans a session's work and keeps its journal — the plan file the session's commits, PR and issue updates are written from, and the record kinds an implementation harness journals through

- **Skill** (`issue`): Problem-focused issue descriptions, and keeping them accurate

- **Skill** (`commit`): Contextual commits that capture the why

- **Skill** (`pr`): Pull requests with intent-driven descriptions

- **Skill** (`sitrep`): Where the session has got to — what landed, and what's still open as ID'd ideas, decisions and questions

- **Skill** (`put-down`): Parks the session's work on its issue, so the next session resumes from the issue and its links alone

- **Skill** (`explicate`): Unfolds an area of the code for an engineer catching up on it — its model, the decisions that shaped it, cited or marked inferred, and their consequences elsewhere — and keeps the map as follow-ups go deeper. Fires on "explicate"

- **Skill** (`rubber-duck`): Talks a design through with the user — files what they say by kind and area whatever order it arrives in, pushes back with consequences and conflicts, keeps its questions from blocking, and leaves the output to the user at the end

- **Skill** (`voice`): The shared writing voice — the audience, the specification register, the mindmap structure two propositions in a relation take, the line-format rule. `references/palette.md` carries the issue/PR section palette.

- **Skill** (`goal-tree`): Goal trees, where children accomplish their parent rather than argue for it, and each node is tested for sufficiency

- **Skill** (`root-cause`): Fault trees — a goal tree turned over, whose children are the causes that could directly produce their parent, each marked open, confirmed or refuted against evidence; a confirmed cause hands over to `goal-tree`'s moves for closing a gap

- **Skill** (`code-comments`): The default is no comment — what earns an exception, what dissolves one, and what to delete. Load it early in a session that touches code, and again when reviewing a diff

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
