---
name: ship
argument-hint: [optional commit message]
description: Run the full pre-ship pipeline — lint, typecheck, test, commit, push to current branch. Blocks on any failure.
---

Run the full ship pipeline for the current branch:

1. **Status check**
   `git status` — confirm we're on the right branch (not main/master)
   `git diff --stat` — summarise what's changed

2. **Type check** (if applicable)
   Run `{{TYPECHECK_COMMAND}}` (e.g. `npx tsc --noEmit`)
   **Block on failure.** Report exact errors. Do not proceed.

3. **Lint**
   Run `{{LINT_COMMAND}}`
   **Block on failure.** Auto-fix if the linter supports `--fix`, then re-run.

4. **Tests**
   Run `{{TEST_COMMAND}}`
   **Block on failure.** Report which tests failed and why.

5. **Build check** (optional — skip if no build step)
   Run `{{BUILD_COMMAND}}`
   **Block on failure.**

6. **Stage and commit**
   `git add -A`
   Commit message: "$ARGUMENTS" (if provided) or prompt for one.
   Follow conventional commit format: `feat:`, `fix:`, `chore:`, etc.

7. **Push**
   `git push origin HEAD`
   Report the branch URL and suggest opening a PR if one doesn't exist.

8. **Summary**
   Report: branch name, commit hash, what was committed, pipeline results.
