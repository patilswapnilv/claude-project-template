# claude-project-template

![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)
![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)
![Status: v1.0 — early](https://img.shields.io/badge/status-v1.0--early-orange.svg)

> A composable Claude Code setup — global preferences, project brain, and stack overlays — installed in one command. Claude knows your stack on the first prompt of every session.

---

## Why

Every new project, you spend 10–20 minutes telling Claude your stack, your conventions, what not to touch, which commands to run. Then again next session. And again when a teammate opens Claude Code.

This template captures that context once — in the three files Claude Code actually reads — so you stop repeating yourself.

---

## What you get

After install, your project has:

- `CLAUDE.md` — project name, stack, and commands filled in. You'll edit a few sections (architecture, conventions) by hand.
- `CLAUDE.local.md` — personal overrides scaffold, gitignored.
- `.claude/` — 6 agents, 4 slash commands, 5 path-scoped rule files, 6 skills, and 2 hooks.
- A stack profile merged in: Next.js, Go, Python data, React Native, or fullstack SaaS.

Setup is about **5 minutes** end-to-end, and you can adopt the template before publishing the global file or any of the optional pieces.

---

## Quick start

**Recommended path — clone + init.**

```bash
git clone https://github.com/patilswapnilv/claude-project-template.git
cd claude-project-template
./scripts/init.sh /path/to/your/project
```

**Without git history (degit).**

```bash
npx degit patilswapnilv/claude-project-template claude-template
cd claude-template
./scripts/init.sh ../your-project
```

**Once published to npm:**

```bash
# npx claude-project-template --target /path/to/your/project
```

### Verify it worked

```bash
cd /path/to/your/project
grep -c '{{' CLAUDE.md   # 0 means every placeholder was filled
ls .claude               # should list agents, commands, hooks, rules, skills
```

Open Claude Code in the project and ask: *"What's my dev command?"* If it answers from `CLAUDE.md`, you're set.

---

## Compatibility

| Requirement | Version |
|---|---|
| Claude Code | 1.0+ |
| OS | macOS, Linux, WSL2. (Windows-native: use the `npx` CLI when published, not `init.sh`.) |
| Node.js | ≥ 18 (only for the `npx` path) |
| bash | 3.2+ |
| git | 2.x |

---

## The 3-level hierarchy

Claude Code reads instructions from three locations:

```
~/.claude/CLAUDE.md       Global   loaded into every session on this machine
./CLAUDE.md               Project  loaded when Claude Code opens this project
./CLAUDE.local.md         Local    loaded if present; gitignored
```

| File | What goes in it | Who edits it |
|---|---|---|
| `~/.claude/CLAUDE.md` | Personal preferences across every project | You, once |
| `CLAUDE.md` | Project brain — stack, commands, architecture | The team |
| `CLAUDE.local.md` | Local paths, ports, machine-specific config | Each dev |

After init, copy `global/CLAUDE.md` to `~/.claude/CLAUDE.md` *only if you don't already have one* — `init.sh` won't overwrite it for you. To merge with an existing global file, diff first:

```bash
diff -u ~/.claude/CLAUDE.md global/CLAUDE.md
```

---

## What's inside (this repo)

```
claude-project-template/
├── global/
│   └── CLAUDE.md                   ← Template for ~/.claude/CLAUDE.md
├── base/                           ← Stack-agnostic foundation
│   ├── CLAUDE.md
│   ├── CLAUDE.local.md.example     ← Installed as CLAUDE.local.md
│   └── .claude/
│       ├── settings.json
│       ├── agents/                 ← 6 specialists
│       ├── commands/               ← 4 slash commands
│       ├── hooks/                  ← pre-commit + lint-on-save
│       ├── rules/                  ← 5 path-scoped rules
│       └── skills/                 ← 6 situational skills
├── profiles/                       ← Stack-specific overlays
│   ├── nextjs/   go-service/   python-data/   react-native/   fullstack-saas/
├── docs/                           ← Principles, cheatsheet, guides
├── workflows/                      ← Self-improvement, prompting patterns
├── cli/index.js                    ← npx entry point
└── scripts/init.sh                 ← Bash bootstrap
```

After install, your project gets:

```
your-project/
├── CLAUDE.md                       ← Filled with your stack + commands
├── CLAUDE.local.md                 ← Personal overrides (gitignored)
└── .claude/                        ← Full Claude Code config
```

---

## Components

### Agents

| Agent | Use it for |
|---|---|
| `code-reviewer` | Pre-merge scan — security, correctness, quality |
| `debugger` | Errors, stack traces, "it doesn't work" |
| `test-writer` | Adding tests after implementation |
| `refactorer` | Structural improvements; behavior must not change |
| `doc-writer` | READMEs, API docs, ADRs, runbooks |
| `security-auditor` | Pre-launch deep audit; auth/payment changes |

### Commands

| Command | What it does |
|---|---|
| `/ship [message]` | typecheck → lint → test → commit → push |
| `/fix-issue 42` | read issue → implement → test → commit |
| `/pr-review 12` | fetch diff → review → post findings |
| `/scaffold auth` | read patterns → propose structure → create files |

### Rules — load only when relevant

Rules in `.claude/rules/` use a `paths:` frontmatter so they're scoped to specific files. Editing `components/Button.tsx`? Frontend rules apply. Touching `migrations/`? Database rules apply. Nothing else.

### Hooks — guardrails that fire automatically

- **`pre-commit.sh`** — runs before every commit. Blocks commits that contain plausible secrets or target a protected branch (`main`/`master`/`production`). Type-check and test gates are scaffolded but commented — uncomment to opt in.
- **`lint-on-save.sh`** — runs after each Edit/Write. Scaffolded for ESLint, ruff, gofmt — uncomment the line for your language after install.

Exit `2` blocks; `0` allows. See [`docs/HOOKS.md`](docs/HOOKS.md).

### Profiles — composable overlays

Profiles extend base, never override it. To add another profile's rules to an already-initialised project:

```bash
npx degit patilswapnilv/claude-project-template/profiles/go-service/.claude/rules .claude/_go-rules
mv .claude/_go-rules/* .claude/rules/ && rmdir .claude/_go-rules
```

---

## CLAUDE.md quality rules

- **Under 80 lines.** Past that, instruction adherence drops. Under 60 is better.
- **Don't repeat what hooks enforce.** A linter handles style; CLAUDE.md is for what a linter can't see.
- **No personality prompts.** "Be a senior engineer" wastes tokens.
- **Pitch docs, don't embed them.** Write *"For Stripe issues, see docs/stripe.md"* — Claude will read it when relevant. Avoid `@docs/...`.
- **Use the self-improvement loop.** After every correction, ask Claude to add the rule. Your CLAUDE.md compounds.

[`docs/PRINCIPLES.md`](docs/PRINCIPLES.md) has the research behind every rule above.

---

## Troubleshooting

**Claude doesn't seem to know my project.** Restart Claude Code — it loads `CLAUDE.md` on session start, not on file change. Then `grep -c '{{' CLAUDE.md` to confirm 0 placeholders remain.

**`/ship` complains about `{{TYPECHECK_COMMAND}}`.** Re-run init on a recent template version, or open `.claude/commands/ship.md` and replace the placeholder with your actual command (or delete that step).

**Pre-commit secret scan doesn't catch a fake key on my Mac.** macOS BSD `grep` doesn't support `-P`. Patch the hook with the portable form in [`docs/HOOKS.md`](docs/HOOKS.md) or install ripgrep.

**I want to upgrade the template.** Re-running init prompts before overwriting `.claude/` and the seeded `CLAUDE.md`. With `--yes`, it aborts if either exists unless you also pass `--force`. Back up your edited `CLAUDE.md` first; merge by diff.

---

## Upgrade

1. `cd` to the template clone, `git pull`.
2. Diff your project's `.claude/` against `base/.claude/` from the new template.
3. Re-run init on a scratch directory and pull in only the deltas you want.
4. Your `CLAUDE.md` edits stay yours — init won't help here; merge by hand.

A `--diff` flag is on the roadmap.

## Uninstall

```bash
rm -rf .claude/ CLAUDE.md CLAUDE.local.md
sed -i.bak '/CLAUDE.local.md/d' .gitignore && rm -f .gitignore.bak
```

Global file (`~/.claude/CLAUDE.md`) and Claude Code's auto memory are unaffected — remove manually if you want a clean slate.

---

## FAQ

**Does this work outside Claude Code?** No — agents, commands, hooks, and `paths:`-scoped rules are Claude Code primitives. The CLAUDE.md hierarchy is portable to any AI tool that reads markdown context.

**Can I run init twice?** Yes, but it'll prompt before overwriting `CLAUDE.md` and `.claude/`. With `--yes`, init aborts on existing files unless you also pass `--force`.

**Does it work on Windows?** Use the `npx` CLI; `init.sh` is bash and assumes a POSIX shell. WSL2 works with both.

**Can I publish my customised version?** Yes — GPL-3.0. Fork it. PRs welcome on the upstream too.

---

## Contributing

PRs welcome for new profiles (Vue, Elixir, Rails, Rust, Laravel), new agents/commands/skills, and CLI improvements. See [`CONTRIBUTING.md`](.github/CONTRIBUTING.md).

**Hard rule:** `base/` stays stack-agnostic. Profiles extend, never override.

---

## Related

- [Anthropic — Claude Code docs](https://docs.claude.com)
- [HumanLayer — Writing a good CLAUDE.md](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
- [`davila7/claude-code-templates`](https://github.com/davila7/claude-code-templates)
- [`abhishekray07/claude-md-templates`](https://github.com/abhishekray07/claude-md-templates)
- [`josix/awesome-claude-md`](https://github.com/josix/awesome-claude-md)

---

GPL v3 — see [LICENSE](LICENSE).
