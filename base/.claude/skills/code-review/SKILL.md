---
name: code-review
description: Apply structured code review to any code snippet or file. Auto-invoked when asked to "review", "check", or "audit" code. Also invoked when code quality issues are suspected.
user-invocable: true
---

# Code Review Skill

When reviewing code, work through these lenses in order:

## 1. Correctness
- Does it do what it's supposed to do?
- Are all code paths handled (including null, empty, error)?
- Are async operations handled correctly?
- Could there be race conditions?

## 2. Security
- Any hardcoded secrets or credentials?
- Is user input validated before use?
- Are there SQL/command injection vectors?
- Is authorization checked, not just authentication?

## 3. Performance
- Any N+1 patterns?
- Any unnecessary work in hot paths?
- Memory leaks (listeners not removed, closures holding references)?

## 4. Maintainability
- Would a new team member understand this in 5 minutes?
- Functions doing more than one thing?
- Appropriate abstraction level — not too clever, not too verbose?
- Are names accurate? Does the name match what it actually does?

## 5. Tests
- Is the code testable? (If not, why — and can it be refactored to be?)
- Are error paths tested, not just happy path?

## Output format
Report with severity labels:
- **CRITICAL** — bug, security issue, data loss risk
- **WARNING** — likely problem, should fix before merge
- **SUGGESTION** — improvement, non-blocking

End with a one-line verdict.
