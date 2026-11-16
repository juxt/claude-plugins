# Reading a draft cold

Interpret MUST, MUST NOT, SHOULD, SHOULD NOT, MAY, etc. per RFC 2119.

**A weed agent reads a draft holding what its readers hold, and nothing of the session that wrote it.**
The author can't see what the draft leaves out, because the author holds what it was meant to carry; a reader attempting the reader's job meets the gaps where they are.

## The caller's side

- **Write the draft to a file and delegate**, passing its path and the inputs the agent names.

- **Pass a linked or parent issue as a file holding its body verbatim** — no comments, no summary, no annotation — fetched by the chalk github agent.
  A body you have described rather than copied tells the agent what you think it says, which is the session leaking in through the one input that was meant to keep it out.

- **You MUST NOT give it the session or the plan.**

- **Its questions are for you to answer in the draft, not to judge**, per `chalk:voice`.

  - **A question MUST be closed by adding what answers it.**
    You MUST NOT close one by deciding it doesn't apply.
    A node it couldn't decide on is closed by restructuring that node.

  - **Where only the user can answer, relay the question as written.**
    In secondary, per `chalk:secondary`: record it, and carry it into the artefact as an open question marked for the user.

- **The loop ends when the agent has no question left**, or in secondary when only questions marked for the user remain.

- **A redraft keeps every answer earlier rounds settled.**
  Restructuring a node to close one gap is where an earlier answer gets dropped.

- **The redraft MUST go back to the same agent, until the loop ends.**
  You MUST NOT judge your own redraft.

## The weeder's side

### What you hold

- **Exactly what the draft's readers hold, and no more** — your agent file lists it.

- **A linked or parent issue is used as the caller's file gives it, verbatim.**
  Reject a summarised, annotated or truncated copy and fetch the issue yourself.
  The tell is commentary — a body that explains itself, or refers to what "we" decided.

- **You MUST NOT be given, and MUST NOT ask for, the session that produced the draft or its plan.**
  If the caller volunteers them, ignore them.

### What you change

**You cut whole sentences from the draft file, and report each cut**: deletion only, never adding a sentence or rewording one.
A commit message isn't a file you hold, so its cuts are reported for the caller to apply by rewording.

### Walk the tree as the reader takes it

**Test each node for the three decisions `chalk:voice` gives the reader.**
The drafter built the tree holding what they knew, so a node can look sound to them and still leave the reader nowhere to go.

- **Skip: the subject states a claim the reader can hold their goal against.**
  A topic — "Background", "Notes", "Details" — fails.

- **Agree: the subject carries one claim, acceptable from its ancestors alone**, and in a walkthrough the earlier steps.
  A second claim riding on an `and`, a qualification appended to a finished claim, or a term defined only further down fails.

- **Descend: where the subject can't be agreed with unread, its body settles it, and carries nothing the subject doesn't reach.**

  - **An elaboration carrying a proposition of its own is a gap**: the reader who agreed with the subject skipped it, and never met it.

  - **A deduction in prose is a gap**, inside an elaboration as much as anywhere.
    A run of "so", "because", "therefore" or "which means" across clauses, or reasoning carried in table cells — "p2's A@3 precedes it, so p2 moves up" — belongs as consequent children or an `A → B → C` chain.
    A table of data is not reasoning, and stays unrestricted.

  - **Children that are only related to their parent**, rather than grounding, narrowing or excepting it, are a gap, as is a sibling set whose relation the parent leaves unclear.

Report each, naming the node, the decision it fails, and what it leans on.

### Check the references

**Check that every reference resolves to what the sentence implies** — an issue, a commit, a path, a named step or section.
A SHA on an unlanded branch is a gap, per `chalk:voice`.

**Collect every reference first, then test existence in a single command.**
Whether a target exists is mechanical, and one lookup per reference is the slowest thing you do — a `gh issue view` is a network round-trip on its own.

```bash
git cat-file -e <sha>^{commit} && echo "sha ok"
test -e <path> && echo "path ok"
gh issue view <n> --json number,title
```

**Spend judgement only on what that command says exists**, on the half it cannot answer: is this the target the sentence implies?
Report what fails; do not repair it.

### Re-reading a redraft

- **Re-run everything on the redraft**, not only the gaps you raised: the sentences added to close one are as likely as any to open another, or to argue.

- **A question stays open until the draft answers it.**
  A question the draft carries as an open question marked for the user is answered, as far as the weed goes.
  The caller cannot close it by asserting it is closed, or by explaining to you why it doesn't apply.
  An added sentence that mentions the topic without answering fails — "makes the retry path more robust" mentions the why; "we were paged at 3am because 429s weren't backing off" answers it.

- **Recheck every question you closed in earlier rounds**: a restructure that answers one gap tends to drop an answer an earlier round settled.

- **An answer is tested against the tree as well as against the question**: one that arrives as a new sentence in an elaboration, carrying a proposition the subject doesn't reach, closes the question and opens a descend gap.
