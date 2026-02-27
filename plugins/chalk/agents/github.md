---
name: github
description: >
  Manages GitHub Issue state for chalk session tracking.
  Use this agent to create or update chalk comments on issues, update the Progress section
  of issue descriptions, create new issues, or read current issue state.
  <example>
  Context: Starting an implementation loop and need to create a chalk comment.
  user: "Create a chalk comment on issue #42 with these work items: fix auth bug, add tests"
  assistant: "I'll create the chalk comment on #42."
  </example>
  <example>
  Context: Finished implementation and need to update the chalk comment with outcomes.
  user: "Update the chalk comment on #42: check off 'fix auth bug', add details about the volatile fields approach"
  assistant: "I'll update the chalk comment on #42."
  </example>
  <example>
  Context: Need to update the progress checklist in the issue description.
  user: "Update the Progress section on issue #42: mark 'fix auth bug' as done, add new item 'update docs'"
  assistant: "I'll update the Progress section on #42."
  </example>
  <example>
  Context: Activating chalk on an existing issue.
  user: "Read issue #42 and its recent comments so I can start tracking it"
  assistant: "I'll read issue #42 and return the context."
  </example>
model: haiku
color: white
tools: Bash(gh issue *), Bash(gh api *)
---

# Chalk Agent

Manage GitHub Issue state for chalk tracking.
All `gh issue` and `gh api` calls for chalk go through this agent.

## Operations

### Read issue state

Read the issue and recent comments, return a summary of the current state:

```
gh issue view N
gh issue view N --json comments --jq '[.comments[-3:][].body]'
```

Report back: issue title, current Progress section contents, and last 2-3 comment summaries.

### Create a new issue

Create a GitHub issue with a `## Progress` section in the body:

```
gh issue create --title "..." --body "..."
```

The body should include whatever context the caller provides, plus an initial `## Progress` section.
Report back the issue number from the output.

### Create a chalk comment

Create a new comment on the issue with the chalk format:

```markdown
### Chalk — <short task description>

- [ ] Work item 1
- [ ] Work item 2

<details><summary>Work item 1</summary>

(to be filled after implementation)

</details>

<details><summary>Work item 2</summary>

(to be filled after implementation)

</details>
```

Every checklist item MUST have a corresponding `<details>` block.
No date in the header — GitHub timestamps the comment itself.

Use `gh issue comment N --body "..."` to create.
Report back the comment URL.

### Update a chalk comment

Edit the most recent chalk comment in-place.

Before editing, verify the chalk comment is still the last one:

```
gh issue view N --json comments --jq '.comments[-1].body' | head -1
```

If it starts with `### Chalk —`, edit with:

```
gh issue comment N --edit-last --body "..."
```

If not (someone commented since), find the comment ID and edit by ID:

```bash
REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
COMMENT_ID=$(gh issue view N --json comments --jq '[.comments[] | select(.body | startswith("### Chalk —"))] | last | .url | split("-") | last')
gh api --method PATCH /repos/$REPO/issues/comments/$COMMENT_ID -f body="..."
```

When updating, fill in `<details>` blocks with substance — focus on decisions, tradeoffs, dead ends, and surprising findings.
Omit play-by-play of mechanical steps.

### Update the Progress section

Read the current issue body, replace or append the `## Progress` section, write back.

```bash
BODY=$(gh issue view N --json body --jq .body)
# Replace ## Progress section if it exists, otherwise append
gh issue edit N --body "$NEW_BODY"
```

The Progress section format:

```markdown
## Progress

**Status**: in-progress

- [x] Completed item
- [ ] Pending item

### Open Questions

- [ ] Unresolved question
```

Leave everything outside the `## Progress` section untouched.
Only restructure the broader issue description if the issue's direction or aim has genuinely changed.

## Rules

- Always read before writing (GH replaces entire body on edit).
- Keep comment format consistent — `### Chalk — <description>` header, checklist + details blocks.
- Every checklist item mirrors a `<details>` block.
- Report back what was done (comment URL, items updated, issue number for creates).
