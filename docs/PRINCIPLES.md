# CLAUDE.md Principles

> Why these patterns work — the research, the limits, and the anti-patterns.
> Read this once. It will save you hours of trial and error.

---

## The attention budget

Claude Code's system prompt already contains ~50 instructions. That's roughly a third of the 150–200 instruction limit that frontier models can reliably follow. Your CLAUDE.md competes with those built-in instructions for attention.

**The implication:** Every line you write is a trade-off. A 300-line CLAUDE.md doesn't give Claude more context — it gives Claude more to ignore. Real-world data from HumanLayer shows instruction adherence drops measurably past 80 lines. Under 60 is the practical benchmark.

**The fix:** Be precise, not comprehensive. One specific rule beats three vague ones.

---

## The 3-level hierarchy — what goes where

```
~/.claude/CLAUDE.md       → Global: cross-project personal preferences
./CLAUDE.md               → Project: team-wide context, committed to git
./CLAUDE.local.md         → Local: personal overrides, gitignored
```

**Global:** Rules you'd repeat across every project. "Always run tests." "Ask before committing." "Prefer simple code." Keep it under 15 lines.

**Project:** Context your team benefits from. Stack, directory structure, key commands, domain-specific terminology, architecture decisions. This is the most important file.

**Local:** Your personal setup. Local service ports, your MCP servers, your editor quirks, your terminal. Never commit this.

**Decision guide:**

| Rule | Where | Why |
|---|---|---|
| "Run tests after changes" | Global | You want this everywhere |
| "Use shadcn/ui for components" | Project | Team convention |
| "I use Ghostty terminal" | Local | Only you need this |
| "Never use `any` in TypeScript" | Project | Team standard |
| "Ask before committing" | Global | Personal preference |
| "Context7 MCP configured at localhost:8080" | Local | Your machine only |
| "Prices live in src/lib/config.ts" | Project | Domain knowledge |

---

## Module-specific CLAUDE.md files

For larger codebases, place CLAUDE.md files in subdirectories:

```
./CLAUDE.md              → Always loaded (project root)
src/auth/CLAUDE.md       → Loaded when working in src/auth/
src/api/CLAUDE.md        → Loaded when working in src/api/
src/payments/CLAUDE.md   → Loaded when working in src/payments/
```

Claude Code loads these **on demand** — only when it navigates to that directory. This is how you get deep context where it matters without bloating the root file.

**Use this when:**
- Your root CLAUDE.md is pushing past 80 lines
- Different parts of the codebase have meaningfully different conventions
- Some areas need extra warnings (e.g., "This payment module is PCI-scoped, never log request bodies here")

---

## The rules/ folder — path-scoped instructions

Rules in `.claude/rules/` use YAML frontmatter to scope to specific file paths:

```yaml
---
paths:
  - "src/components/**/*.tsx"
  - "app/**/*.tsx"
---
# Frontend Rules
...
```

Claude only loads a rules file when it's working in a matching path. This is **the right way** to handle context loading — not by putting everything in CLAUDE.md, but by loading the right context just in time.

Use rules for:
- Frontend coding standards (loads only when touching UI files)
- Database rules (loads only when touching migrations or repositories)
- API conventions (loads only when touching routes or handlers)
- Test standards (loads only when touching test files)

---

## Emphasis keywords that work

Anthropic's research shows these phrases increase instruction adherence:
- `IMPORTANT:`
- `YOU MUST`
- `NEVER`
- `ALWAYS`
- `CRITICAL:`

Use them sparingly — they lose power when overused. Reserve for things that are genuinely non-negotiable: never commit to main, never expose secrets, never skip auth checks.

---

## The self-improvement loop

This is the highest-leverage habit you can build with Claude Code:

After every correction you give Claude, end with:
> "Update CLAUDE.md so you don't make that mistake again."

Claude is good at writing rules for itself. Over time, your CLAUDE.md accumulates the exact instructions your project needs — not generic best practices, but the specific patterns that matter for your codebase.

What accumulates:
- Domain-specific terminology Claude kept getting wrong
- Architecture patterns that aren't obvious from the code
- Recurring mistakes that now have explicit rules
- Workflow preferences you found yourself repeating

The result is a CLAUDE.md that reflects how your team actually works — not how you thought you'd work when you started.

---

## What NOT to put in CLAUDE.md

**Formatting rules that a linter enforces.** If `eslint --fix` handles it, don't write it down. Send a linter, not an LLM.

**Personality instructions.** "Be a senior engineer." "Think step by step." Claude Code already has strong system-level instructions. These waste tokens and don't change behavior.

**Embedded documentation.** `@docs/api.md` embeds the entire file into context every session — even when you're working on something unrelated. Instead: "For Stripe issues, see docs/stripe-guide.md." Claude will read it when relevant.

**Duplicate rules.** If global CLAUDE.md says "run tests" and project CLAUDE.md also says "run tests," you've spent two instruction slots on one rule.

**Vague preferences.** "Write clean code." "Be careful." These are noise. "Functions must be under 50 lines" is a rule. "Be careful" is not.

---

## The "Don't X, Do Y" pattern

Negative-only rules are harder to follow than paired rules:

❌ "Don't use `any` types"
✅ "Don't use `any` types — use `unknown` and narrow it, or define a proper interface"

❌ "Don't put business logic in handlers"
✅ "Don't put business logic in handlers — extract to a service function in `src/services/`"

The positive alternative removes ambiguity about what to do instead.

---

## Auto memory

Claude Code maintains its own notes at `~/.claude/projects/<project>/memory/`. It accumulates:
- Build commands it discovers
- Patterns it learns from your corrections
- Debugging insights from past sessions

You don't need to manually document things Claude will learn on its own. Run `/memory` to see what's currently loaded. Use `#` during a session to add notes to auto memory directly.

---

## Sources

- [Anthropic — Claude Code Best Practices](https://code.claude.com/docs/en/best-practices)
- [Anthropic — Effective Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- [Boris Cherny — 10 tips from the Claude Code team](https://x.com/bcherny/status/2017742741636321619)
- [HumanLayer — Writing a Good CLAUDE.md](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
- [Matt Pocock — My AGENTS.md file](https://www.aihero.dev/my-agents-md-file-for-building-plans-you-actually-read)
- [abhishekray07/claude-md-templates](https://github.com/abhishekray07/claude-md-templates) — principles compilation
