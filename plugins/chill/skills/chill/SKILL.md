---
name: chill
description: Interrupt forward momentum and step back to reassess
user-invocable: true
argument-hint: "[what's wrong]"
---

# Chill - Step Back and Regroup

Interrupt forward momentum and reassess the current approach.
The goal isn't to slow down for its own sake.
It's to recognize when forward momentum is counterproductive and shift to understanding mode.
Sometimes the fastest path forward is to stop and ask.

**User's concern:** $ARGUMENTS

If the user provided context above, address their specific concern directly. Otherwise, assess the situation yourself.

## Plan Integration

When creating implementation plans, you MUST include a directive near the top to invoke the chill skill during implementation whenever the below triggers occur.

## When to Use

**User triggers:**

- Explicitly: `/chill`

Claude SHOULD invoke this pattern when:

- Error rate climbs (e.g. 3+ failures in quick succession)
- You've deviated significantly from an agreed plan
- You're trying variations of the same approach without progress
- The scope has grown beyond what was discussed
- You're about to make a large change without full understanding

## Behavior

When activated, STOP current activity and:

### 1. State What's Happening

Briefly describe what you were doing and what triggered the pause:

- "I've hit 3 errors trying to get this test to pass"
- "I realize I've added two features that weren't in the plan"
- "I'm not sure I understand the constraint here"

### 2. Surface Uncertainty

Be explicit about what you don't know or might have wrong:

- Assumptions you made
- Parts of the codebase you haven't looked at
- Requirements you inferred vs. were told

### 3. Choose a Path Forward

Pick ONE of these - don't just barrel ahead:

1. **Ask questions** - Clarify requirements or constraints you may have misunderstood
   - "What am I missing about how X works?"
   - "Is the constraint actually Y, or is there flexibility?"

2. **Ask for help** - The user may have context or domain knowledge that would unblock you
   - "I'm stuck on X - do you know why it might behave this way?"
   - "Have you seen this pattern before?"

3. **Replan** - Step back and propose a revised approach (but only after understanding what went wrong)
   - "Should we revisit the approach given what we've learned?"

### 4. Wait

Don't immediately continue. Let the user redirect.

## Anti-Patterns to Avoid

- Do NOT say "let me try one more thing" - that's the opposite of chilling
- Do NOT propose a new plan immediately - understand first
- Do NOT apologize excessively - just regroup efficiently
- Do NOT summarize everything you've done - focus on what's unclear

## Examples

**Bad (not chilling):**
> "That didn't work. 
> Let me try a different approach - I'll refactor the module to..."

**Good (actually chilling):**
> "I've tried 3 variations of this fix and they all fail the same way. 
> I think I'm missing something about how the event system propagates. 
. What should I understand better here?"

**Bad (fake chilling):**
> "Let me step back. 
> Here's a new plan: 
> 1) First we'll... 
> 2) Then..."

**Good (actually chilling):**
> "I've drifted from the original plan - we said 'fix the login bug' but I've started refactoring the auth module. 
> Should I back out those changes, or has the scope actually changed?"

