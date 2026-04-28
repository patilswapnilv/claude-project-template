---
name: pr-review
argument-hint: [pr-number]
description: Pull and review a GitHub PR — code quality, security, test coverage, and a go/no-go verdict.
---

Review GitHub PR #$ARGUMENTS:

1. **Fetch the PR**
   `gh pr view $ARGUMENTS`
   `gh pr diff $ARGUMENTS`
   Read the PR description, linked issues, and any review comments already posted.

2. **Understand the intent**
   What is this PR trying to accomplish?
   Does the implementation match the description?

3. **Run the code-reviewer agent**
   Delegate to the `code-reviewer` agent with the diff as input.
   It will handle security scan, correctness, performance, and quality checks.

4. **Check tests**
   - Are there tests for the new behavior?
   - Do the existing tests still pass? (`{{TEST_COMMAND}}`)
   - Is coverage adequate for the risk level of the change?

5. **Check the PR itself**
   - Is the PR small enough to review? (> 500 lines is a smell — flag it)
   - Is the description clear enough for future git blame readers?
   - Are there migration steps, deploy notes, or config changes missing?

6. **Post review**
   `gh pr review $ARGUMENTS --[approve|request-changes|comment] --body "[review body]"`

   Review body format:
   ```
   ## Summary
   [What the PR does in 1-2 sentences]

   ## Verdict: APPROVE | REQUEST CHANGES | NEEDS DISCUSSION

   ## Findings
   [Paste code-reviewer output here]

   ## Test coverage
   [Assessment]
   ```
