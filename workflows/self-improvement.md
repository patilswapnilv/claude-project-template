# The Self-Improvement Loop

The single highest-leverage habit for Claude Code users.

---

## The pattern

After every correction you give Claude, say:

> "Update CLAUDE.md so you don't make that mistake again."

That's it. Claude will propose an addition to CLAUDE.md. Review it. Approve the ones that are right.

---

## Why this works

Claude is good at writing rules for itself. When you correct Claude, you've identified a gap between Claude's default behavior and your project's needs. That gap is exactly what CLAUDE.md is for. By making Claude write the rule immediately after the correction, you capture the learning while the context is fresh.

Over time, your CLAUDE.md accumulates rules that are specific to your codebase — not generic best practices, but the precise patterns that matter for your project.

---

## Examples

**Situation:** Claude uses `fetch()` directly in a component.
You correct it: "We don't use fetch directly — use the tRPC client."
You say: "Update CLAUDE.md so you don't make that mistake again."

Claude adds to CLAUDE.md:
```markdown
## Conventions
- No fetch() in components — all API calls through the tRPC client at src/lib/trpc.ts
```

---

**Situation:** Claude adds a `console.log` in the payments module.
You correct it: "Never log in the payments module — PCI compliance."
You say: "This should also go in src/payments/CLAUDE.md."

Claude adds to `src/payments/CLAUDE.md`:
```markdown
CRITICAL: NEVER use console.log or any logging in this module — PCI compliance.
```

---

**Situation:** Claude suggests a migration without writing the rollback.
You correct it: "Always write the DOWN migration alongside the UP."
You say: "Update CLAUDE.md or the database rules."

Claude adds to `.claude/rules/database.md`:
```markdown
- ALWAYS write the DOWN migration alongside the UP — no migration without a rollback path
```

---

## What accumulates

After a month of using this habit:

- Domain-specific terminology Claude kept getting wrong → explicit definitions in CLAUDE.md
- Architecture patterns that aren't obvious from the code → Architecture section gets more precise
- Recurring mistakes → explicit NEVER rules
- Workflow preferences → Commands and "Always do" sections get sharper
- Module-specific concerns → Subdirectory CLAUDE.md files grow

The result is a CLAUDE.md that reflects how your team actually works — a living document that gets smarter with every session.

---

## Managing growth

CLAUDE.md can grow bloated over time with this habit. Do a monthly review:

1. Read every rule — ask "is this still true?"
2. Cut anything a hook or linter now enforces (no need to burn tokens on it)
3. Cut rules that address patterns that no longer exist in the codebase
4. Consolidate duplicate rules
5. Move deep rules to path-scoped rule files if they're file-type-specific
6. Verify the file is still under 80 lines

The monthly review is also a good team exercise — CLAUDE.md is a living artifact of your team's coding decisions.

---

## Auto memory vs. CLAUDE.md

Claude Code also maintains auto memory at `~/.claude/projects/<project>/memory/`. It accumulates:
- Build commands it discovers
- Patterns from your corrections
- Debugging insights

Run `/memory` to see what's loaded.

**The distinction:** Auto memory handles facts Claude discovers organically. CLAUDE.md handles constraints and conventions you explicitly want enforced. Both are necessary. Neither replaces the other.
