# Contributing

Contributions welcome. This is a community resource — the more stacks covered and the more patterns documented, the more useful it is for everyone.

---

## What to contribute

### High-value contributions
- **New profiles** — Vue, Elixir, Ruby/Rails, Rust, Java/Spring, Laravel, Django, .NET, Flutter
- **New agents** — domain-specific specialists (data-engineer, api-designer, performance-auditor)
- **New skills** — situational intelligence packs for common workflows
- **New commands** — `/deploy`, `/rollback`, `/migrate`, `/benchmark`
- **Improved hooks** — better secret scanning, language-specific formatters
- **Improved rules** — more precise path-scoped instructions based on real-world use

### Medium-value contributions
- Bug fixes in `scripts/init.sh`
- Improvements to existing agent or skill content
- Documentation improvements (`docs/`, `workflows/`)
- Additional prompting patterns in `workflows/prompting-patterns.md`

### Low-value (don't bother)
- Reformatting without content changes
- Adding more files to `base/` that are stack-specific (that's what profiles are for)
- Generic advice that's already covered in `docs/PRINCIPLES.md`

---

## Rules

**The most important rule: `base/` must be stack-agnostic.**

Everything in `base/` installs for every developer on every stack. If it's TypeScript-specific, it belongs in `profiles/nextjs/`. If it's Python-specific, it belongs in `profiles/python-data/`. If it's stack-agnostic, it belongs in `base/`.

**Profiles extend, never override.**
A profile adds rules and skills. It does not modify or replace anything in `base/`. A developer who uses your profile should get their base + your additions.

**Keep CLAUDE.md under 80 lines.**
If your contribution to `base/CLAUDE.md` pushes it over 80 lines, find a way to move content to rules files or module-level CLAUDE.md files.

**Test your init.sh changes.**
Run `./scripts/init.sh /tmp/test-project` after any changes to init.sh and verify the output is correct.

---

## Adding a new profile

```bash
# Create the profile structure
mkdir -p profiles/my-stack/.claude/{rules,skills/my-skill}

# Add a rules file with path: frontmatter
cat > profiles/my-stack/.claude/rules/my-stack.md << 'EOF'
---
paths:
  - "src/**/*.ext"
  - "lib/**/*.ext"
---

# My Stack Rules

- [Rule 1]
- [Rule 2]
EOF

# Add a skill
cat > profiles/my-stack/.claude/skills/my-skill/SKILL.md << 'EOF'
---
name: my-skill
description: [When Claude should invoke this — be specific]
user-invocable: true
---

# My Skill

[Instructions]
EOF
```

Then update `scripts/init.sh` to include your profile in the selection menu.

---

## Adding a new agent

Create `.claude/agents/my-agent.md` in `base/`:

```yaml
---
name: my-agent
description: [What it does — Claude uses this to decide when to delegate to it]
tools: Read, Glob, Grep, Bash
model: sonnet
memory: project
maxTurns: 20
---

You are a [specialist].

## Your process

Step 1 — [First thing you do]
Step 2 — [Second thing]
...

## Output format

[How you structure your findings]
```

**Critical:** The `description:` field is what Claude reads to decide when to invoke this agent. Make it specific — Claude uses it for matching, not just documentation.

---

## PR checklist

Before opening a PR:

- [ ] `base/` contains nothing stack-specific
- [ ] Any new profile is in `profiles/` not `base/`
- [ ] `init.sh` updated if you added a new profile
- [ ] All new files have correct YAML frontmatter (agents, skills, rules)
- [ ] Tested: `./scripts/init.sh /tmp/test-project` completes without errors
- [ ] `base/CLAUDE.md` is still under 80 lines
- [ ] PR description explains what the contribution adds and why

---

## Questions?

Open an issue with the `question` label. Discussion welcome.
