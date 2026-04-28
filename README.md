# claude-project-template

A reusable, composable `.claude/` folder template for Claude Code projects.

One setup. Every project. Zero repeated instructions.

---

## What this is

Claude Code reads configuration from a `.claude/` folder in your project root. This repo gives you a **battle-tested base** plus **stack-specific profiles** you compose together — so Claude always has the right context without you re-explaining your conventions.

## Structure

```
claude-project-template/
├── scripts/
│   └── init.sh               ← Interactive bootstrap (run this first)
├── base/                     ← Stack-agnostic foundation
│   ├── CLAUDE.md
│   ├── CLAUDE.local.md.example
│   └── .claude/
│       ├── settings.json
│       ├── agents/           ← 6 specialist subagents
│       ├── commands/         ← Slash commands
│       ├── hooks/            ← Enforced scripts
│       ├── rules/            ← Path-scoped instructions
│       └── skills/           ← Situational intelligence packs
└── profiles/                 ← Stack-specific overlays
    ├── nextjs/
    ├── go-service/
    ├── python-data/
    ├── react-native/
    └── fullstack-saas/
```

## Quick start

```bash
# Clone this repo
git clone https://github.com/patilswapnilv/claude-project-template.git
cd claude-project-template

# Run the interactive bootstrap
chmod +x scripts/init.sh
./scripts/init.sh /path/to/your/project
```

The `init.sh` script will:
1. Ask you for project name, stack, and primary concerns
2. Copy the base template to your project
3. Merge the right profile overlay
4. Fill in placeholders in `CLAUDE.md`
5. Set correct permissions on hooks

## Manual setup

If you prefer manual control:

```bash
# Copy base to your project
cp -r base/.claude /your/project/
cp base/CLAUDE.md /your/project/
cp base/CLAUDE.local.md.example /your/project/CLAUDE.local.md

# Merge a profile (example: Next.js)
cp -r profiles/nextjs/.claude/rules/* /your/project/.claude/rules/
cp -r profiles/nextjs/.claude/skills/* /your/project/.claude/skills/

# Set hook permissions
chmod +x /your/project/.claude/hooks/*.sh

# Edit CLAUDE.md and fill in your project specifics
```

## How the components work

| Component | What it does | Auto or manual |
|---|---|---|
| `CLAUDE.md` | Project brain — loaded every session | Auto |
| `agents/` | Specialist subagents (reviewer, debugger, etc.) | Auto-delegated |
| `commands/` | Slash commands like `/fix-issue 42` | Manual invocation |
| `hooks/` | Scripts that run before/after actions | Auto (via settings.json) |
| `rules/` | Path-scoped instructions — only loads for matching files | Auto |
| `skills/` | Situational intelligence — auto or manually invoked | Both |
| `settings.json` | Permissions, hook wiring, model config | Auto |
| `CLAUDE.local.md` | Personal overrides, gitignored | Auto |

## Rules for contributing

- Keep `base/` stack-agnostic. No framework-specific imports, no language-specific linters.
- Profile overlays should **extend**, never override, base rules.
- Keep `CLAUDE.md` under 200 lines. Longer files reduce instruction adherence.
- Every hook must be idempotent and exit with code `0` (allow) or `2` (block).
- Skills must have a clear `description:` — Claude uses this to decide when to invoke.

## Adding your own profile

```bash
mkdir -p profiles/my-stack/.claude/{rules,skills/my-skill}
# Add rules/my-stack.md with path: frontmatter
# Add skills/my-skill/SKILL.md with name: and description:
```

Then send a PR.

