# A⭐ (a-star)

Agentic coding harness for complex domains: a cheap agent finds the route to the goal end-to-end, then each change lands small and simple enough for a human to review and put down.

If you're not familiar with the A\* path-finding algorithm, imagine driving a car through a high-walled maze, trying to find the shortest path to the exit.
(If you are familiar with it, please allow me some artistic license in the following description!)

You can fire a dart at the exit, over the walls, and know how far away it is.
Once you've fired the dart, though, you have to obey the walls when you drive.
So you drive a little, fire another dart, and repeat.
Hopefully you're closer! If not, you adapt your path — you might even backtrack — but you make another small decision, then measure again.

![A car partway through a walled maze: its track so far, a dead end it backed out of, and darts fired over the walls to the exit — faint ones from where it was, a bold one from where it is now](maze.svg)

**A⭐ is that process applied to agentic coding.**

1. **Dart** to an end-to-end as quickly as possible.
   A cheap sub-agent reaches the goal ignoring the project's usual rules, the way the dart ignores the walls; its code never lands.
2. **Drive**: use what the dart found to commit atomic, comprehensible, correct, compliant changes.
   A drive obeys the walls — the project's coding standards, tests and review — and each change it commits is a real step along the route.
3. **Go to 1** from wherever the work has got to.
   The distance a dart still has to cover — its diff against the base — shrinks as the work converges, and the card is done when nothing is left between the base and the goal.

A **card** is the unit of work: an issue in the project's tracker, or whatever the project calls one.
Changes are split per Kent Beck's *Tidy First?* — a **tidy** changes structure, an **advance** changes behaviour, and the two never share a commit.
A **drive** makes either one, in commits that are each one atomic unit of change carrying its own tests and docs, so a reviewer reading the branch commit by commit can agree with each before moving to the next.

## Why

A⭐ aims to solve the following problems, and optimises for sustainability — what the human has to hold in their head, and how many decisions they make per hour — not throughput.

- **The human's context is now the scarce resource.**
  Writing the code was never the hard part; most of an engineer's work is now the thinking — the analysis, the judgement — and working alongside AI makes that thinking more taxing, not less, especially in naturally complex domains.

  - **Agentic coding has made reviewing exhausting.**
    An agent hands you in minutes a change that would have taken a person days.

    On a project where the domain itself is complex, you can't just wave it through: before you can have confidence that it's correct and maintainable, you have to build the mental model in your head — every concern it touches, and how each one meets the rest of the system.

    You can't do much about the essential complexity — that's the domain's, and it's why you're needed.
    A⭐ goes after the incidental complexity piled on top of it: concerns braided together, structure and behaviour in one diff, workarounds an agent left behind — so each change is small and simple enough to confirm, then put down.

  - **Each increment is optimised for simplicity: "obviously no bugs", rather than "no obvious bugs".**
    [Hoare's distinction](https://en.wikiquote.org/wiki/C._A._R._Hoare) — a design so simple there are obviously no deficiencies, against one so complicated there are no obvious deficiencies.
    Confirming the first is a check the human finishes; the second they carry on holding, since they can't know when they've looked hard enough.

    - **Simple, not easy** — Rich Hickey's distinction, from [*Simple Made Easy*](https://www.infoq.com/presentations/Simple-Made-Easy/).
      Simple is un-braided: one concern per piece, so a reviewer can confirm each on its own.
      Easy is near to hand, and the near-to-hand change usually braids a new concern into an existing one, leaving the reviewer to hold both at once.

    - **Tidy First makes each increment independently reasonable.**
      A human can understand a smaller part of the change in isolation, then page it out of their working memory to focus on the next.
      A tidy is reviewed by asking only *could this change anything?*; an advance, made on a structure already tidied for it, is small enough to hold whole.

- **The route should come from evidence, not from reading.**
  Many agent harnesses plan the whole change from the code as it reads, then execute the plan; decades of agile practice say the route is found by building — XP's spike, the Mikado Method's naive attempt — in small steps, with feedback from each.

- **Darting is now cheap.**
  A dart agent on a cheaper model reaches an end-to-end in minutes, for a fraction of what the main session costs, so throwing a dart away and throwing another is affordable in a way it never was when a person wrote it.
  The sub-goals are what the dart found, rather than what was guessed before it.

## What A⭐ does, and what it doesn't

**A⭐ owns the whole process, and `/a-star <card>` is the way in.**
It is stated as state machines in [`spec/`](spec/) (`common`, `orchestrator`, `dart`, `drive`): what each move needs to be true, and what it records.

- **It does:**
  - plan the goal with you in plan mode, until you approve the goal and the route:
    the goal tree is reasoned as a KAOS goal model (van Lamsweerde) — each node tested for sufficiency, missing children found through obstacles, each leaf's owner named, each gap closed by a chosen tactic;
  - pick the card up: update the tracker, create or check out the branch;
  - dart to the goal with a cheap sub-agent, and turn what the dart found into sub-goals;
  - drive each sub-goal to a commit through a drive sub-agent, as one tidy, advance or amend, each as early in the branch as makes sense;
  - triage what darts and drives turn up, and choose each move — dart, drive, revert, replan, park or done;
  - decide the finish with you, a PR or not;
  - park the work so a later session resumes from the issue;
  - adjust all of this to whether you're watching: `/a-star:primary` and `/a-star:secondary`.

- **It doesn't, and leaves to your project's conventions:**
  - coding standards, and the definition of done;
  - ship/show/ask, and code review;
  - how a commit message, PR description or issue is written, and what the tracker wants.

- **Three choices are A⭐'s own, and your project answers them**: where a tidy is committed, where an advance is committed, and branch cleanup.
  Where it doesn't answer one, A⭐ asks, bar the defaults in `spec/orchestrator.allium`'s `BeginPlanning` guidance.

## Usage

- `/a-star [issue]` — plan the work with you, then pick it up and carry it through; also "pick up #N", "start on #N", "let's plan this"
- `/a-star:primary`, `/a-star:secondary` — say whether you're watching ("I'm back", "I'm going AFK"); a session starts primary, unless it runs headless or scheduled
  In secondary the session decides what it can, records every decision for review, and parks what it can't; plan approval and merging stay yours
- `/a-star:dart` — reach the goal end-to-end, and break the card into sub-goals
- `/a-star:drive <sub-goal>` — commit one sub-goal to the project's standards: a tidy, an advance, or an amend of an earlier commit, interrupting the work in hand if need be

## Setup

```
/plugin install a-star@juxt-plugins
```

## What A⭐ needs from its surroundings

**A⭐ follows ports and adapters (Cockburn's hexagonal architecture): the specs name each need as a plain verb, and your project binds each verb to whatever provides it.**
The needs: read the issue and its neighbourhood, search existing cards, update the tracker, file an issue, update the issue's description, comment on the issue, put a dependency onto another card, record in the session's journal, write the commit message (rewording included), weed the comments, raise a PR, write the work up on its issue, report where the session has got to, and write the goal as a goal tree.
A⭐ doesn't know who provides them; your user-level or project instructions and installed skills say which does.
