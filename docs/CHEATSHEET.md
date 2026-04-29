# CLAUDE.md Cheatsheet

One page. Print it. Bookmark it.

---

## The 3 files

| File | Scope | Committed? |
|---|---|---|
| `~/.claude/CLAUDE.md` | All your projects | No |
| `./CLAUDE.md` | This project, whole team | Yes |
| `./CLAUDE.local.md` | This project, just you | No (gitignored) |

---

## CLAUDE.md must-haves

```markdown
# Project Brain

## Stack
[your stack here — framework, DB, infra]

## Commands
[dev, build, test, lint commands]

## Layout
[key directories and what lives in them]

## Conventions
[language, branching, commits, testing approach]

## Always do
[things Claude must do on every task]

## Never do
[hard constraints — branch protection, secret handling, etc.]
```

---

## Rules file template

See: https://code.claude.com/docs/en/memory#path-specific-rules

```yaml
---
paths:
  - "src/components/**/*.tsx"
  - "app/**/*.tsx"
---

# [Layer Name] Rules

- [Rule 1 — specific, actionable]
- [Rule 2 — Don't X — Do Y instead]
```

---

## Agent frontmatter

See: https://code.claude.com/docs/en/sub-agents#supported-frontmatter-fields

```yaml
---
name: my-agent
description: [What it does — Claude uses this to decide when to invoke it]
tools: Read, Glob, Grep, Bash, Write, Edit
model: claude-sonnet-4-6  # prefer pinned full model IDs for deterministic behavior
memory: project
maxTurns: 20
---
```

---

## Command template

```yaml
---
name: my-command
argument-hint: [what to pass]
description: [what it does]
---

Do the thing with $ARGUMENTS:
1. Step one
2. Step two
...
```

---

## Skill template

```yaml
---
name: my-skill
description: [When Claude should auto-invoke this — be specific]
user-invocable: true
---

# Skill Name

[Instructions for Claude when this skill activates]
```

---

## settings.json skeleton

```json
{
  "model": "claude-sonnet-4-6",
  "autoMemoryEnabled": true,
  "permissions": {
    "allow": ["Bash(npm run *)", "Bash(git diff *)"],
    "deny": ["Read(.env)", "Bash(rm -rf *)", "Bash(git push --force *)"]
  },
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash(git commit*)",
      "hooks": [{"type": "command", "command": ".claude/hooks/pre-commit.sh"}]
    }],
    "PostToolUse": [{
      "matcher": "Edit|Write",
      "hooks": [{"type": "command", "command": ".claude/hooks/lint-on-save.sh"}]
    }]
  }
}
```

---

## Hook exit codes

| Exit code | Meaning |
|---|---|
| `0` | Allow the action |
| `2` | Block the action |
| `1` | Error (logged, action may proceed) |

---

## The limits

| Thing | Limit | Why |
|---|---|---|
| CLAUDE.md length | < 80 lines | Instruction adherence drops past this |
| Global CLAUDE.md | < 15 lines | Applies to every project — keep it lean |
| Module CLAUDE.md | < 50 lines | Deep context for a specific folder |
| Emphasis keywords | Use sparingly | `IMPORTANT:` loses power if overused |

---

## The self-improvement loop

After every correction → *"Update CLAUDE.md so you don't make that mistake again."*

This single habit compounds. Do it every time.

---

## What to never put in CLAUDE.md

- Style rules a linter enforces
- "Be a senior engineer" / personality prompts
- `@docs/file.md` embeds (pitch instead: "For X, see docs/file.md")
- Duplicate rules (global + project saying the same thing)
- Vague preferences ("write clean code")
