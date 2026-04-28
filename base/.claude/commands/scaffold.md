---
name: scaffold
argument-hint: [feature-name]
description: Scaffold a complete feature — folder structure, types, tests, and basic implementation stub — following the project's existing patterns.
---

Scaffold a new feature: **$ARGUMENTS**

1. **Read existing patterns first**
   Find a similar feature that already exists in this codebase.
   Read its structure end-to-end — don't assume, read.
   The new scaffold must match the existing style exactly.

2. **Plan the structure**
   Propose the full file list before creating anything:
   ```
   src/features/$ARGUMENTS/
   ├── index.ts          ← public API (what other modules import)
   ├── types.ts          ← types and interfaces
   ├── service.ts        ← business logic
   ├── repository.ts     ← data access (if applicable)
   └── __tests__/
       ├── service.test.ts
       └── repository.test.ts
   ```
   Adjust based on the project's actual conventions.

3. **Wait for approval**
   Show the plan. Ask "Does this structure look right?" before creating any files.

4. **Create the scaffold**
   Create each file with:
   - Correct imports (matching project's import style)
   - Types defined
   - Function signatures with TODO bodies
   - Test file with one placeholder test per public function
   - Barrel export in `index.ts`

5. **Register the feature**
   Wire it into the app: router, DI container, module registry — wherever the project registers features.

6. **Summary**
   List every file created.
   List every file modified (registrations).
   State what the developer needs to implement next.
