---
name: fix-issue
argument-hint: [issue-number]
description: Read a GitHub issue, implement the fix, write a regression test, and commit — end to end.
---

Fix GitHub issue #$ARGUMENTS end to end:

1. **Read the issue**
   `gh issue view $ARGUMENTS`
   Understand the reported behavior, expected behavior, and any reproduction steps.

2. **Locate the relevant code**
   Search for the files, functions, and modules related to the issue.
   Read the surrounding context — not just the line in question.

3. **Reproduce first**
   Before writing any fix, confirm you can reproduce the bug with a minimal test case.
   If you cannot reproduce it, stop and comment on the issue asking for clarification.

4. **Implement the minimal fix**
   Fix the root cause, not the symptom.
   Do not refactor unrelated code in the same commit.
   Keep the diff small and reviewable.

5. **Write a regression test**
   Write a test that would have caught this bug.
   Run `{{TEST_COMMAND}}` — all tests must be green.

6. **Commit**
   Stage only the relevant files.
   Commit with: `fix: [description] (closes #$ARGUMENTS)`
   Follow the project's commit conventions from CLAUDE.md.

7. **Summary**
   Report what was changed, why, and where the regression test lives.
