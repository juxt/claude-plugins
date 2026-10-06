# A⭐ (a-star)

Harness to spike to an end-to-end quickly, then land atomic, comprehensible, correct, compliant changes from what the spike found.

1. **Spike** to an end-to-end as quickly as possible.
2. **Use what the spike found to land atomic, comprehensible, correct, compliant changes.** Go to 1 as required.

It optimises for sustainability — what the human has to hold in their head, and how many decisions they make per hour — not throughput.
A **card** is the unit of work: an issue in the project's tracker, or whatever the project calls one.
Changes are split per Kent Beck's *Tidy First?* — a **tidy** changes structure, a **drive** changes behaviour, and the two never share a commit.

## What A⭐ does, and what it doesn't

**A⭐ owns the spike/tidy/drive loop, and nothing else.**

- **It does:**
  - check a card is ready to spike, and agree what it's for with you where it isn't;
  - spike to the goal with a cheap sub-agent, and turn what the spike found into sub-goals;
  - land each sub-goal as one tidy or one drive, and keep the two apart;
  - choose the next step from the ready sub-goals;
  - adjust to whether you're watching the session (primary or secondary).

- **It doesn't, and leaves to your project's conventions:**
  - picking a card up and putting it down, and the tracker;
  - planning, and where sub-goals, decisions and open questions are recorded;
  - coding standards, and the definition of done;
  - ship/show/ask, and code review;
  - writing commit messages, PR descriptions and issue updates.

- **Three choices are A⭐'s own, and your project answers them**: how a tidy lands, how a drive lands, and branch cleanup.
  Where it doesn't answer one, A⭐ asks rather than guessing.

## Why

- **The human's context is now the scarce resource.**
  Writing the code was never the hard part; most of an engineer's work is now the thinking — the analysis, the judgement — and working alongside AI makes that thinking more taxing, not less, especially in naturally complex domains.
  A⭐ aims to shrink what the human has to hold in their head at any one time: each landed change is small enough to review and then page out.

- **The route should come from evidence, not from reading.**
  Many agent harnesses plan the whole change from the code as it reads, then execute the plan; decades of agile practice say the route is found by building, in small steps, with feedback from each.

- **Spiking is now cheap.**
  A spiker on a cheaper model reaches an end-to-end in minutes, for a fraction of what the main session costs, so throwing a spike away and throwing another is affordable in a way it never was when a person wrote it.
  The sub-goals are what the spike found, rather than what was guessed before it.

## Usage

- `/a-star <card>` — start or resume the loop on a card, once your project's conventions have picked it up
- `/a-star:spike` — reach the goal end-to-end, and break the card into sub-goals
- `/a-star:drive <sub-goal>` — land one behaviour change
- `/a-star:tidy <what>` — land one structure change, interrupting the work in hand if need be
- `/a-star:primary`, `/a-star:secondary` — say whether you're watching this session; it starts primary

## On the name

**A\* is a search algorithm that finds a route to a goal by repeatedly estimating how far the goal is from each place it could go next.**
The estimate is a heuristic: the straight-line distance, ignoring the walls the real route will have to go round.
A\* follows the most promising place, re-estimates from wherever it has got to, and finishes when the place it reaches is the goal.

- **A spike is that straight line**, from the current base to the goal, ignoring the project's usual rules the way the heuristic ignores walls.
  It's cheap, so it's thrown again from wherever the work has got to.

- **Each landed change is a real step along the route**, and the next spike estimates from there.
  The distance a spike still has to cover — its diff against the base — shrinks as the work converges, and the card is done when nothing is left between the base and the goal.

## Setup

```
/plugin install a-star@juxt-plugins
```

## Recommended alongside

[chalk](../chalk/) writes the commit messages, PR descriptions and issue updates A⭐'s work produces, for the colleague who wasn't there, and its `pick-up` records the sub-goals and decisions A⭐ asks for in the session's plan.
A⭐ names neither; it works with whatever your project's conventions load.
