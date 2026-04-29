---
# See: https://code.claude.com/docs/en/memory#path-specific-rules
paths:
  - "**/*.test.ts"
  - "**/*.test.tsx"
  - "**/*.test.js"
  - "**/*.spec.ts"
  - "**/*.spec.js"
  - "**/__tests__/**/*"
  - "tests/**/*"
  - "test/**/*"
---

# Testing Rules

## Test structure
- One test file per source file, co-located or in a parallel `__tests__/` directory
- Group related tests with `describe()` — named after the unit under test
- Test names describe behavior, not implementation: `should return 404 when user not found` not `test getUserById error case`
- Arrange-Act-Assert structure in every test (blank line between each section)

## What to test
- Public behavior — what the function returns or the side effects it produces
- NOT private/internal implementation — if you need to test a private method, extract it
- Error paths are as important as the happy path
- Edge cases: empty, null, zero, max, concurrent

## Test isolation
- Each test must be able to run independently in any order
- No shared mutable state between tests
- Reset mocks and stubs in `beforeEach` or `afterEach`
- No real I/O in unit tests — mock databases, APIs, file system, clocks

## Assertions
- One logical assertion per test (multiple `.expect()` calls for one concept is fine)
- Assert the specific value, not just truthiness: `expect(count).toBe(3)` not `expect(count).toBeTruthy()`
- For objects: assert the specific fields that matter, not the full object (less brittle)
- Use snapshot tests sparingly — they break on any whitespace change and reviewers stop reading diffs

## Mocking
- Mock at the system boundary: HTTP calls, database, file system, external services
- Do NOT mock internal functions or utilities — that's testing implementation
- If you need to mock something deeply internal, the design might need rethinking

## Coverage
- Coverage is a minimum bar, not a goal — 80% with bad tests is worse than 60% with good ones
- 100% coverage on critical paths (auth, payments, data mutations)
- Don't add tests just to hit a number — add them where bugs would be expensive
