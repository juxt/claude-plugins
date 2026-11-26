---
name: dart
description: >
  Reach a ready card's goal end-to-end with the dart agent, triaging what it raises as it goes — increments ready to commit, findings that invalidate the plan, questions about the route — and harvesting the sub-goals it found.
  Use when `/a-star` offers a dart, or the user says "dart this", "throw a dart", "throw the dart".
user-invocable: true
argument-hint: "[card, if not already in session]"
---

# a-star Dart

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

Load `a-star:a-star` first.
**Briefing the dart agent is the `TakeDart` rule's guidance; harvesting its report is `DartReports`' and `DartCleared`'s**, in `spec/orchestrator.allium`.
Triage what it raises as it runs per that file's Triage rules, then you are back to choosing.
