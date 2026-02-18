---
name: chalk
description: This skill should be used when the user says "chalk #N", "chalk new", "chalk status", "chalk off", "track issue #N", mentions a GitHub issue number (e.g. "#123", "issue 456", "GH-789"), or references a github.com issue URL. Tracks agent session progress against GitHub Issues via session comments.
version: 0.1.0
user-invocable: true
disable-model-invocation: false
allowed-tools: Bash(gh issue *), Bash(gh api *)
---

# Chalk — GitHub Issue Session Tracking

Track your work against a GitHub Issue.
The issue description is shared territory (respect existing format); session comments are yours.

## Auto-Activation

This skill auto-activates when the user mentions a GitHub issue number.
When activated this way, offer chalk tracking briefly — e.g. "Want me to chalk #123?"
If the user accepts, activate as if they said `chalk #N`.
If declined, don't ask again for that issue in the same session.

## Commands

- `chalk #N` — track this session against issue N
- `chalk new` — create a new issue and track against it
- `chalk status` — show what you're tracking
- `chalk off` — stop tracking

## Activation: `chalk #N`

1. Read the issue:
   ```
   gh issue view N
   gh issue view N --comments --json comments
   ```
2. Internalize the issue context without repeating the entire issue to the user.
3. Read the last 2-3 comments to understand recent history.
4. Create your session comment (see format below).
5. Note the comment URL from the creation output — you'll need it to edit in-place later.
6. Tell the user you're tracking against #N.

## Activation: `chalk new`

1. Ask the user for a title and brief context.
2. Create the issue:
   ```
   gh issue create --title "..." --body "..."
   ```
3. Note the issue number from the output.
4. Create your session comment.
5. Tell the user you're tracking against the new issue.

## Session Comment Format

Create one comment per session.
Edit it in-place as work progresses — don't create multiple comments.

```markdown
### Session — YYYY-MM-DD

**Status**: in-progress

- [ ] First work item
- [ ] Second work item

<details><summary>First work item</summary>

Details of what was explored, decided, implemented...

</details>

<details><summary>Second work item</summary>

Details...

</details>
```

**Rules:**
- The checklist is the scannable overview.
  Each item mirrors a `<details>` block below.
- Check items off as you complete them.
- Add new items as work emerges.
- Keep details blocks focused — one per theme or work item.
- Update **Status** to `completed` or `blocked` at session end.

**Writing style — focus on the why, not the what:**
Details blocks should read like knowledge-sharing, not a changelog.
A future developer (or a future session after compaction) needs to understand *reasoning*, not just *actions*.

Include:
- **Decisions and tradeoffs**: why you chose approach X over Y, what constraints drove the choice.
- **Counter-intuitive findings**: anything that surprised you or would surprise someone reading the code.
- **What didn't work and why**: dead ends are valuable context — they prevent re-investigation.
- **What was explicitly out-of-scope**: if you deliberately skipped something, say so and say why.

Omit:
- Obvious details self-evident from the diff or issue description.
- Play-by-play of mechanical steps ("then I ran the tests", "then I edited the file").

## Updating the Issue Description

You don't own the issue description — respect whatever format exists.
Your job is to ensure two things exist:

1. **Current Status** — a section (usually `## Current Status`) near the bottom with a concise summary of where things stand.
2. **Open Questions** — a checklist section (usually `## Open Questions`) if there are unresolved items.
   Link to comments for longer discussions.

**How to update:**
- Read the current description.
- If a status section exists, update it in-place.
- If not, append one at the bottom.
- Same for open questions.
- Leave everything else untouched.

Use `gh issue edit N --body "..."` to update.
You must pass the full body (GH replaces the entire body), so read it first, modify, then write back.

## When to Update Your Session Comment

Keep the comment current as you work — don't wait until the end.
Edit it in-place whenever something worth recording happens:

- **On a decision**: you chose approach X over Y, or ruled something out.
- **On a discovery**: you found something surprising, or confirmed a hypothesis.
- **On a dead end**: you tried something that didn't work — record what and why.
- **On a scope change**: something was added, dropped, or deferred.
- **On a blocker**: you're stuck and need input.

Don't update on routine mechanical steps — only when a future reader would benefit from knowing.

**Before stopping or ending the session**: finalize your session comment (mark checklist items, set status to `completed` or `blocked`).
Update the issue description's Current Status section if the overall picture changed.

**Before context compaction**: ensure your session comment captures all progress so far.
Include the issue number in your compaction summary so you can resume tracking afterward.

## Editing Your Session Comment

Before each edit, verify your session comment is still the last one on the issue:

```
gh issue view N --json comments --jq '.comments[-1].body' | head -1
```

If the output starts with `### Session —`, it's yours — proceed with the edit:

```
gh issue comment N --edit-last --body "..."
```

If it doesn't match (e.g. you manually commented on the issue since the session started), `--edit-last` would edit the wrong comment.
Fall back to editing by comment ID:

```
gh api --method PATCH /repos/{owner}/{repo}/issues/comments/{comment_id} -f body="..."
```

To find the session comment ID, search backwards through comments for the one starting with `### Session —`:

```
gh issue view N --json comments --jq '[.comments[] | select(.body | startswith("### Session —"))] | last | .id'
```

## Example Session Comment

See `examples/session-comment-filled.md` for a realistic filled-in example.

## Important

- **Don't create multiple comments per session.** One comment, edited in-place.
- **Don't restructure the issue description.** Only touch status and open questions.
- **Do update at milestones.** The value is in the live progress, not just the final summary.
- **Do include enough detail in `<details>` blocks** that a future session (possibly after compaction) can pick up where you left off.
  Key files, decisions and why, what was tried, what didn't work and why.
