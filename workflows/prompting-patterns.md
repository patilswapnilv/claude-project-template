# Prompting Patterns

12 copy-paste prompts for common Claude Code situations.
Use these verbatim, or adapt them to your workflow.

---

## 1. Start a new feature

```
I'm starting a new feature: [FEATURE NAME].

Before writing any code:
1. Read the existing code in [RELEVANT DIRECTORY] to understand current patterns
2. Propose a file structure that matches how the codebase is organized
3. Ask me to confirm before creating any files

The feature should: [ONE-LINE DESCRIPTION OF WHAT IT DOES]
```

**Why:** Prevents Claude from creating files that don't match your patterns and forces a plan-first approach.

---

## 2. Investigate a bug (no guessing)

```
I have a bug. Before suggesting any fix:
1. Form 3 hypotheses about the cause — list them before investigating any
2. Find evidence to disprove each one
3. Only after disproval: propose the minimal fix

Bug description: [EXACT ERROR MESSAGE OR BEHAVIOR]
Steps to reproduce: [HOW TO REPRODUCE]
Expected: [WHAT SHOULD HAPPEN]
Actual: [WHAT IS HAPPENING]
```

**Why:** Forces systematic debugging instead of the first-plausible-explanation trap.

---

## 3. Review code before merge

```
Review this code before I merge it.

For each finding, use:
CRITICAL — must fix before merge
WARNING — should fix, not blocking
SUGGESTION — nice to have

Check in this order:
1. Security — secrets, auth, injection vectors
2. Correctness — edge cases, error handling, async
3. Performance — N+1, memory, hot paths
4. Quality — naming, length, duplication

End with: APPROVE, REQUEST CHANGES, or BLOCK and one-line reason.

[PASTE CODE OR DIFF HERE]
```

**Why:** Structured reviews catch more than "does this look good."

---

## 4. Write tests that actually catch bugs

```
Write tests for [FUNCTION/MODULE].

Before writing any test:
1. List the test cases you plan to write:
   - Happy path cases
   - Error cases (invalid input, dependency failure)
   - Edge cases (empty, null, zero, max, concurrent)
   - Boundary cases (exactly at the limit)

Wait for my approval of the test plan before writing tests.

Rules:
- One logical assertion per test
- Test behavior, not implementation
- No logic in tests (no if/else, no loops)
- Mock at the system boundary only
```

**Why:** Test plan approval prevents writing tests that don't cover the right things.

---

## 5. Refactor without changing behavior

```
Refactor [FILE/FUNCTION] for readability and maintainability.

IMPORTANT constraints:
1. Run the tests first — if any are failing, stop and tell me
2. Do not change behavior — only structure
3. Do not add features or fix bugs while refactoring
4. Run tests after each significant change
5. Tell me what you changed and why — separate from what you did NOT change

If tests don't exist for this code, write characterization tests first.
```

**Why:** The "don't add features while refactoring" constraint prevents scope creep that breaks things.

---

## 6. Explain a confusing codebase area

```
Explain how [AREA] works in this codebase.

I want to understand:
1. What problem this area solves
2. The key files and what each does
3. The data flow — what comes in, what happens, what comes out
4. The non-obvious decisions — why it's built this way vs. the obvious approach
5. What I should NOT touch without understanding deeply

Don't show me code unless it's the clearest way to explain something.
Assume I know the language but not this specific system.
```

**Why:** Gets you oriented fast, surfaces the "gotchas" before you hit them.

---

## 7. Security review before launch

```
Security review before we launch [FEATURE/COMPONENT].

Work through these in order:
1. Who can reach this code? (auth, authz, rate limits)
2. What data flows through it? (user input, what's returned, what's logged)
3. What external systems does it call? (credentials, timeouts, response validation)
4. What can go wrong? (service down, malformed input, concurrent requests)
5. What's the blast radius if this is exploited?

For each finding: location, attack scenario, severity (CRITICAL/HIGH/MEDIUM/LOW), fix.

Don't just list theoretical risks — I want realistic attack scenarios.
```

**Why:** Realistic attack scenarios are more useful than theoretical vulnerability lists.

---

## 8. Database migration (safe)

```
I need to make this schema change: [DESCRIBE THE CHANGE]

Before writing any migration:
1. Categorize the change: safe (additive) or risky (destructive/breaking)?
2. If risky — propose the multi-step migration plan
3. Write the UP migration
4. Write the DOWN (rollback) migration alongside it
5. Note: will this lock the table? How long? Is that acceptable?

Rules:
- Never alter a table without a rollback path
- If adding NOT NULL to an existing column — propose the safe 3-step approach
- Test on a copy of production data first
```

**Why:** The rollback requirement and lock analysis prevent the two most common migration disasters.

---

## 9. Document this for a new team member

```
Write documentation for [COMPONENT/FEATURE] that a new team member could use to:
1. Understand what it does and why it exists
2. Make a simple change without breaking anything
3. Know what to ask before making a complex change

Format: [README section | ADR | runbook | inline comments]

Rules:
- Show, don't tell — working code examples over descriptions
- Don't document the obvious — focus on the non-obvious decisions
- Include: what NOT to do and why
- Keep it short enough that someone will actually read it
```

**Why:** Specifying the audience and format produces much more useful documentation.

---

## 10. Self-improvement after a correction

```
I just corrected you on: [WHAT YOU GOT WRONG]

The correct behavior is: [WHAT SHOULD HAPPEN INSTEAD]

Now:
1. Identify which file should capture this rule: CLAUDE.md, a .claude/rules/ file, or a module-level CLAUDE.md
2. Write the specific rule
3. Show me the exact addition before making any changes

The rule should be specific enough that if another Claude instance read it, it would know exactly what to do.
```

**Why:** Forces precision in rule-writing. Vague rules don't stick.

---

## 11. Plan before you code

```
Before writing any code for [TASK]:

1. Read the relevant existing code
2. Write an implementation plan:
   - Files to create or modify
   - Key decisions and why
   - What you're NOT doing and why
   - Risks or things to verify first
3. Wait for my approval before writing any code

I'll approve, modify, or reject the plan. Then implement.
```

**Why:** The most expensive bugs come from building the wrong thing. Plans are cheap.

---

## 12. End-of-session capture

```
Before we end this session:

1. What did we build or change today? (1-2 sentences)
2. What's the current state — done, in-progress, blocked?
3. What should I tell the next Claude session to get them oriented fast?
4. Does CLAUDE.md need any updates based on what we learned today?

Format your answer so I can paste it directly into a handoff note.
```

**Why:** Prevents the "where did we leave off" problem at the start of the next session.
