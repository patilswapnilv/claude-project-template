---
# See: https://code.claude.com/docs/en/skills.md#frontmatter-reference
name: debug-session
description: Structured debugging protocol. Auto-invoked when error messages, stack traces, or "it doesn't work" style descriptions are present. Prevents random trial-and-error.
---

# Debug Session Skill

When debugging, follow this protocol. Do not skip steps.

## Step 1 — Get the full picture
Before proposing anything:
- What is the **exact** error message (full, not truncated)?
- What is the **stack trace** (where does the error originate, not where it's reported)?
- What is the **expected** behavior?
- What is the **actual** behavior?
- Was it **ever working**? What changed?

## Step 2 — Locate the origin
The error is reported somewhere. The bug lives somewhere else. Find:
- The file and line where execution goes wrong
- The call chain leading to that point
- Any shared state involved

## Step 3 — Form 3 hypotheses
State them before investigating. Ranked by likelihood.
This prevents tunnel vision on the first plausible explanation.

## Step 4 — Disprove each hypothesis
For each: find the evidence that would disprove it. Check that evidence.
Don't stop at the first one that fits — check all three.

## Step 5 — Minimal reproduction
The smallest code that reproduces the bug. If you cannot write it, explain why.

## Step 6 — Fix + verify
- Minimal fix — don't refactor while fixing
- Run the tests — if they don't catch this bug, add one that does
- Check if the same pattern exists elsewhere

## Principle
Good debugging is about disproving hypotheses, not confirming them.
The fix should be obvious once you have the right root cause.
If it still feels uncertain, go back to Step 2.
