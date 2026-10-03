# a-star

Harness to spike to an end-to-end quickly, then land atomic, comprehensible, correct, compliant changes from what the spike found.

1. **Spike** to an end-to-end as quickly as possible.
2. **Use what the spike found to land atomic, comprehensible, correct, compliant changes.** Go to 1 as required.

It optimises for sustainability — what the human has to hold in their head, and how many decisions they make per hour — not throughput.
A **card** is the unit of work: an issue in the project's tracker, or whatever the project calls one.
Changes are split per Kent Beck's *Tidy First?* — a **tidy** changes structure, a **drive** changes behaviour, and the two never share a commit.

A card's root — its goal, invariants and out of scope — stays on its tracker issue; everything below it, from the tasks a spike finds to the open questions and decisions, lives in [beads](https://github.com/gastownhall/beads), which a-star uses as it is.

## Why

- **The human's context is now the scarce resource.**
  Writing the code was never the hard part; most of an engineer's work is now the thinking — the analysis, the judgement — and working alongside AI makes that thinking more taxing, not less, especially in naturally complex domains.
  a-star aims to shrink what the human has to hold in their head at any one time: each landed change is small enough to review and then page out.

- **Plans should come from evidence, not from reading.**
  Many agent harnesses plan the whole change from the code as it reads, then execute the plan; decades of agile practice say the route is found by building, in small steps, with feedback from each.

- **Spiking is now cheap.**
  A spiker on a cheaper model reaches an end-to-end in minutes, for a fraction of what the main session costs, so throwing a spike away and throwing another is affordable in a way it never was when a person wrote it.
  The plan becomes what the spike found, rather than what was guessed before it.

## Usage

- `/a-star <card>` — start or resume a card, from a bd ID or a tracker issue
- `/a-star:refine` — agree a card's goal, invariants and out of scope
- `/a-star:spike` — reach the goal end-to-end, and break the card into tasks
- `/a-star:drive <task>` — land one behaviour change
- `/a-star:tidy <what>` — land one structure change, interrupting the work in hand if need be
- `/a-star:landed <what>` — catch up after you've merged something, and choose what's next
- `/a-star:sitrep` — refresh your context on a card
- `/a-star:setup` — set a repo up for a-star
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

a-star depends on the `beads` plugin, from beads' own marketplace, which runs `bd prime` at session start and before compaction.
Add that marketplace first:

```
/plugin marketplace add gastownhall/beads
/plugin install a-star@juxt-plugins
```

Then run `/a-star:setup` in each repo: it installs `bd` if need be, initialises a bd workspace without touching tracked files, and lists the policy slots your project hasn't answered.
`/a-star` runs it for you the first time it finds no workspace.

## Policy

a-star carries the process; your project carries the policy — readiness, landing, definition of done, coding standards, writing, and the rest, in its `AGENTS.md` or equivalent.
Where a slot is missing, a-star asks rather than guessing.

## Recommended alongside

[chalk](../chalk/) writes the commit messages, PR descriptions and issue updates a-star's work produces, for the colleague who wasn't there.
Name it in your project's writing policy; neither plugin depends on the other.
