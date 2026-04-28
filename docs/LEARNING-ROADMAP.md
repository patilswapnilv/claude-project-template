# Learning Roadmap

From zero Claude Code setup to a fully configured project in stages.
Go at your own pace. Each stage is independently useful.

---

## Stage 1 — First 10 minutes (highest ROI)

**Goal:** Claude knows your project. Zero re-explaining.

1. Run `./scripts/init.sh` on your project
2. Open `CLAUDE.md` and fill in the remaining `{{PLACEHOLDER}}` values
3. Run `cp global/CLAUDE.md ~/.claude/CLAUDE.md` and edit your global preferences
4. Open Claude Code in your project — verify it reads the files: ask "What's my dev command?"

**What you get:** Claude knows your stack, commands, conventions, and what not to touch. Every session.

**Time:** 10 minutes.

---

## Stage 2 — First hour (hooks and rules)

**Goal:** Claude can't make the mistakes that matter most.

1. Enable the hooks you need in `.claude/hooks/pre-commit.sh` (uncomment the relevant sections)
2. Verify `settings.json` deny list matches your project's sensitive files
3. Add module-specific CLAUDE.md files to high-risk areas:
   - `src/auth/CLAUDE.md` — auth rules, what never to log
   - `src/payments/CLAUDE.md` — PCI scope, what to never expose
4. Test a hook: try a commit with a fake secret in a test file — it should be blocked

**What you get:** Automated quality gates. Claude literally cannot push to main or expose secrets.

**Time:** 30–60 minutes.

---

## Stage 3 — First week (agents and commands)

**Goal:** Claude handles full workflows end to end.

1. Try each agent in context:
   - Ask Claude to review a recent change → `code-reviewer` activates
   - Show Claude an error → `debugger` takes over
   - Ask for tests on a function → `test-writer` works through it
2. Set up `/fix-issue` with your GitHub integration (`gh` CLI)
3. Use `/ship` for your next commit — verify it runs your full pipeline
4. Edit agents to match your project's actual patterns (your test runner, your linter)

**What you get:** Claude handles PR reviews, bug fixes, and commits as complete workflows — not step-by-step prompting.

**Time:** 1–3 days of regular use.

---

## Stage 4 — First month (self-improvement loop)

**Goal:** CLAUDE.md evolves to reflect how your team actually works.

1. After every correction you give Claude, end with: *"Update CLAUDE.md so you don't make that mistake again."*
2. Weekly review: look at what was added, prune what's redundant
3. Run `/memory` to see what Claude Code has learned automatically
4. Share CLAUDE.md improvements with your team as PRs — let them weigh in on team conventions

**What you get:** A CLAUDE.md that is specific to your codebase, not a generic template. The longer you use it, the better it gets.

**Time:** Ongoing — 5 minutes per session.

---

## Stage 5 — Advanced (optional)

For larger teams or complex codebases.

**Multiple module CLAUDE.md files:**
```
src/
  auth/CLAUDE.md         ← Auth-specific rules
  payments/CLAUDE.md     ← PCI rules
  api/CLAUDE.md          ← API conventions
```

**Composing multiple profiles:**
```bash
# Go backend + SaaS product concerns
cp -r profiles/go-service/.claude/rules/* .claude/rules/
cp -r profiles/fullstack-saas/.claude/rules/* .claude/rules/
```

**Custom agents for your domain:**
Duplicate an agent file, change the `name:`, `description:`, and instructions. Domain-specific agents (e.g., a `schema-designer` for a data-heavy project) beat generic ones.

**Contributing back:**
If you build a good profile for a stack not covered (Vue, Elixir, Rust, Laravel, etc.), open a PR. One good profile helps every developer on that stack.

---

## Reference

- `docs/PRINCIPLES.md` — the research behind these patterns
- `docs/CHEATSHEET.md` — one-page syntax reference
- `docs/CLAUDE-MD-GUIDE.md` — deep dive on writing effective CLAUDE.md files
- `workflows/self-improvement.md` — the habit that makes everything compound
- `workflows/prompting-patterns.md` — 12 copy-paste prompts for common situations
