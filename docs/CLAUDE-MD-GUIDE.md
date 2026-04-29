# Writing Effective CLAUDE.md Files

A practical guide to getting the most instruction adherence out of every line.

---

## Start with the structure

Every project CLAUDE.md should cover these sections — in this order:

1. **Project** — name, one-line purpose, status
2. **Stack** — technologies, versions where relevant
3. **Commands** — dev, build, test, lint (copy-pasteable)
4. **Layout** — key directories and what lives in them
5. **Architecture** — how the pieces fit together (2-3 sentences)
6. **Conventions** — branching, commits, code style, testing approach
7. **Always do** — things Claude must do on every task
8. **Never do** — hard constraints
9. **Active work** — current tasks (update this as work progresses)

That's it. If a section doesn't apply, skip it. Don't add sections just to have them.

---

## The architecture section

This is the most underrated section. It prevents the most expensive mistakes.

Bad:
```markdown
## Architecture
This is a web app with a backend and frontend.
```

Good:
```markdown
## Architecture
Next.js App Router → tRPC → service layer → Prisma → PostgreSQL.
All mutations go through tRPC procedures — no direct DB calls in components.
Auth is NextAuth — the session object is the source of truth for user identity.
```

With the good version, Claude understands the data flow, knows where mutations belong, and won't suggest a shortcut that bypasses your architecture.

---

## The "Active work" section

Most CLAUDE.md files are static documents. Add a living section that Claude reads every session:

```markdown
## Active work
<!-- Update this as work progresses -->
- [ ] Migrating from Prisma to Drizzle — use Drizzle syntax in new code
- [ ] Auth refactor in progress — don't touch src/auth/ without asking
- [ ] Sprint goal: payment flow complete by Friday
```

This gives Claude real-time context about what's happening, not just what's always true.

---

## Writing rules that stick

The single most effective pattern — from real-world data on Claude Code instruction adherence:

```markdown
## Never do
- NEVER commit directly to main or master
- NEVER read or write .env files
- NEVER use `any` types — use `unknown` and narrow it, or define an interface
```

The `NEVER` keyword measurably increases adherence. Use it for genuine constraints.

For paired rules (don't X, do Y):
```markdown
## Conventions
- No inline SQL — all queries in repository files under src/repositories/
- No prop drilling past 2 levels — use the Zustand store for shared state
- No fetch() in components — all API calls through the tRPC client
```

The negative + positive pair eliminates ambiguity about what to do instead.

---

## The 80-line test

Before committing your CLAUDE.md, count the lines. If it's over 80:

1. Cut anything a hook or linter already enforces
2. Cut vague preferences ("write clean code")
3. Move deep rules to `.claude/rules/` with path scoping
4. Move module-specific context to subdirectory CLAUDE.md files
5. Move docs references to pitches ("For X, see docs/file.md")

If it's still over 80 after those cuts, the remaining content is probably important — but reconsider whether each line is earning its place.

---

## Path-scoped rules vs. CLAUDE.md

Rules in `.claude/rules/` with `paths:` frontmatter load only when Claude is working in matching files. See: https://code.claude.com/docs/en/memory#path-specific-rules

Use them for:

- Frontend rules (load for component files only)
- Database rules (load for migration files only)
- API rules (load for route handler files only)
- Test rules (load for test files only)

This keeps the root CLAUDE.md lean while giving Claude deep context exactly where it's needed.

**Decision:** Does this rule apply to every file in the project, or only certain files?
- Every file → CLAUDE.md
- Specific files → `.claude/rules/` with `paths:`

---

## Module-specific CLAUDE.md files

For areas of the codebase with meaningfully different concerns:

```
src/payments/CLAUDE.md
```

```markdown
# Payments Module

CRITICAL: This module is PCI-scoped.
- NEVER log request bodies containing payment data
- NEVER add console.log statements that could capture card numbers
- All Stripe interactions must go through src/payments/stripe-client.ts
- Test with Stripe test mode only — never production keys in dev

See docs/payments-runbook.md for the Stripe integration architecture.
```

This loads only when Claude is working in that directory. The root CLAUDE.md stays clean.

---

## The doc pitching pattern

Instead of embedding docs:
```markdown
❌ @docs/stripe-integration.md
```

Pitch instead:
```markdown
✅ For Stripe integration questions, read docs/stripe-integration.md before making changes.
```

The pitch tells Claude *when* to read the doc, not just that it exists. Claude will fetch and read it at the right moment — not load it into every session regardless of relevance.

---

## Keeping it current

CLAUDE.md is documentation. It rots like all documentation.

Build these habits:
1. **When stack changes** — update the Stack section immediately
2. **When commands change** — update Commands immediately (outdated commands are worse than no commands)
3. **After every major architectural decision** — update Architecture
4. **Every sprint** — update Active work
5. **After every Claude correction** — ask Claude to update CLAUDE.md

The self-improvement loop is the most sustainable maintenance mechanism: Claude maintains the doc that makes Claude more useful.
