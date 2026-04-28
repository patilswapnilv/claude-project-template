# Changelog

All notable changes to this project will be documented in this file.
Format: [Semantic Versioning](https://semver.org/)

---

## [1.0.0] — 2026-04-28

### Added
- Base template: 6 agents, 4 commands, 2 hooks, 5 rules, 6 skills
- 5 stack profiles: nextjs, go-service, python-data, react-native, fullstack-saas
- `scripts/init.sh` — interactive bash bootstrap
- `cli/index.js` — `npx claude-project-template` CLI (zero external deps)
- `global/CLAUDE.md` — template for `~/.claude/CLAUDE.md` personal preferences
- `docs/PRINCIPLES.md` — research behind effective CLAUDE.md patterns
- `docs/CHEATSHEET.md` — one-page quick reference
- `docs/CLAUDE-MD-GUIDE.md` — deep dive on writing effective CLAUDE.md files
- `docs/LEARNING-ROADMAP.md` — staged setup guide
- `workflows/self-improvement.md` — the habit that makes CLAUDE.md smarter
- `workflows/prompting-patterns.md` — 12 copy-paste prompts for common situations
- `CLAUDE.local.md.example` — personal overrides template (gitignored)
- `package.json` — npm package for `npx` usage
- `.github/CONTRIBUTING.md` — contribution guidelines
- `.github/ISSUE_TEMPLATE/` — bug report and profile request templates
- GPL v3 license

### Architecture decisions
- Composable profile system: profiles extend base, never override
- 3-level hierarchy: `~/.claude/CLAUDE.md` → `./CLAUDE.md` → `./CLAUDE.local.md`
- CLI: zero external dependencies (pure Node.js stdlib) to keep `npx` fast
- `init.sh` and `cli/index.js` are parallel implementations of the same logic — bash for local use, Node.js for npx
