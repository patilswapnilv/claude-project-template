# claude-project-template

![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)
![GitHub Template](https://img.shields.io/badge/Use%20as-Template-blue)

> Stop re-explaining your stack to Claude every session. One setup. Every project. Zero repeated instructions.

---

## The problem

Every new project, you spend 10–20 minutes explaining to Claude: your stack, your conventions, what not to touch, which commands to run. Then again next session. And again when a teammate opens Claude Code.

**This template fixes that.** Install once. Claude knows your project cold, every session.

---

## Quick start

```bash
# Option 1 — npx (no install needed)
npx claude-project-template

# Option 2 — degit (zero deps, fastest)
npx degit patilswapnilv/claude-project-template/base .claude-setup
cd .claude-setup && chmod +x scripts/init.sh && ./scripts/init.sh ..

# Option 3 — clone
git clone https://github.com/patilswapnilv/claude-project-template.git
cd claude-project-template && ./scripts/init.sh /path/to/your/project
```

60 seconds later you have:
- `CLAUDE.md` filled with your project specifics
- 6 specialist agents (reviewer, debugger, test-writer, refactorer, doc-writer, security-auditor)
- 4 slash commands (`/ship`, `/fix-issue`, `/pr-review`, `/scaffold`)
- Hardened hooks (secret scanning, branch protection, lint-on-save)
- 5 path-scoped rule files that auto-load only what's relevant
- 6 skills (code-review, debug-session, schema-migration, security-review, frontend-design, devrel-post)
- Stack-specific profile merged in (Next.js / Go / Python / React Native / SaaS)

---

## The 3-level hierarchy

Claude Code reads instructions from three locations:

```
~/.claude/CLAUDE.md       → Global: your personal preferences, every project
./CLAUDE.md               → Project: shared with your team, committed to git
./CLAUDE.local.md         → Local: your overrides, gitignored, never shared
```

| File | What's in it | Who edits it |
|---|---|---|
| `global/CLAUDE.md` | Personal preferences, cross-project conventions | You, once |
| `base/CLAUDE.md` | Project brain — stack, commands, architecture | Team |
| `base/CLAUDE.local.md.example` | Local overrides template | Each dev, privately |

---

## What's inside

```
claude-project-template/
├── global/
│   └── CLAUDE.md                    ← Copy to ~/.claude/CLAUDE.md
├── base/                            ← Stack-agnostic foundation
│   ├── CLAUDE.md
│   ├── CLAUDE.local.md.example
│   └── .claude/
│       ├── settings.json            ← Permissions, hooks, model config
│       ├── agents/                  ← 6 specialist subagents
│       ├── commands/                ← 4 slash commands
│       ├── hooks/                   ← pre-commit + lint-on-save
│       ├── rules/                   ← 5 path-scoped rule files
│       └── skills/                  ← 6 situational intelligence packs
├── profiles/                        ← Stack-specific overlays
│   ├── nextjs/
│   ├── go-service/
│   ├── python-data/
│   ├── react-native/
│   └── fullstack-saas/
├── docs/
│   ├── PRINCIPLES.md                ← Why these patterns work
│   ├── CHEATSHEET.md                ← One-page quick reference
│   ├── CLAUDE-MD-GUIDE.md           ← Writing effective CLAUDE.md files
│   └── LEARNING-ROADMAP.md          ← From basics to advanced
├── workflows/
│   ├── self-improvement.md          ← The habit that makes CLAUDE.md smarter
│   └── prompting-patterns.md        ← 12 copy-paste prompts
└── scripts/
    └── init.sh                      ← Interactive bootstrap
```

---

## Components

### Agents — your AI team

| Agent | Activates when |
|---|---|
| `code-reviewer` | Before any PR — security scan, correctness, quality |
| `debugger` | Error messages, stack traces, unexpected behavior |
| `test-writer` | After implementation — tests that actually catch bugs |
| `refactorer` | Structural improvements, zero behavior change |
| `doc-writer` | READMEs, API docs, ADRs, runbooks |
| `security-auditor` | Deep audit before launches, after auth/payment changes |

### Commands

| Command | What it does |
|---|---|
| `/ship [message]` | typecheck → lint → test → commit → push |
| `/fix-issue 42` | Read issue → implement → test → commit |
| `/pr-review 12` | Fetch diff → review → post findings |
| `/scaffold auth` | Read patterns → propose structure → create files |

### Rules — right context, not all context

Rules use `paths:` frontmatter. Working on `components/Button.tsx`? Frontend rules load. Touching `migrations/`? Database rules load. Nothing else. Context stays lean.

### Hooks — things Claude cannot override

`pre-commit.sh` blocks commits with hardcoded secrets, direct pushes to protected branches, and (optionally) failing type checks or tests. Exit code `2` = block. Exit code `0` = allow.

### Profiles — composable stack overlays

Profiles extend the base, never override it. Merge multiple for hybrid stacks:

```bash
# Go backend + SaaS product concerns
cp -r profiles/go-service/.claude/rules/* .claude/rules/
cp -r profiles/fullstack-saas/.claude/rules/* .claude/rules/
```

---

## CLAUDE.md quality rules

**Keep it under 80 lines.** Past 80, Claude starts ignoring parts. Under 60 is better.

**Don't repeat what hooks enforce.** If lint-on-save auto-formats, don't burn CLAUDE.md lines on style rules.

**No personality instructions.** "Be a senior engineer" wastes tokens. Claude Code has strong system-level instructions already.

**Don't embed docs — pitch them.** Instead of `@docs/api-guide.md` (embeds the whole file every session), write: "For Stripe issues, see docs/stripe-guide.md."

**Use the self-improvement loop.** After every correction, say: *"Update CLAUDE.md so you don't make that mistake again."* Your CLAUDE.md gets smarter over time.

See `docs/PRINCIPLES.md` for the full research behind these patterns.

---

## Contributing

PRs welcome for new profiles (Vue, Elixir, Ruby/Rails, Rust, Laravel), new agents/commands/skills, and init.sh improvements. See [CONTRIBUTING.md](.github/CONTRIBUTING.md).

**One rule:** `base/` must stay stack-agnostic. Profiles extend, never override.

---

## Related

- [Anthropic Claude Code Docs](https://code.claude.com/docs)
- [davila7/claude-code-templates](https://github.com/davila7/claude-code-templates) — large component library, npx CLI
- [abhishekray07/claude-md-templates](https://github.com/abhishekray07/claude-md-templates) — CLAUDE.md best practices research
- [luongnv89/claude-howto](https://github.com/luongnv89/claude-howto) — structured learning guide
- [josix/awesome-claude-md](https://github.com/josix/awesome-claude-md) — real CLAUDE.md files from OSS

---

GPL v3 License — see [LICENSE](LICENSE) for details.
