# Global Preferences

> Copy this file to ~/.claude/CLAUDE.md
> These preferences apply to EVERY project. Keep it under 15 lines.
> Project-specific context goes in ./CLAUDE.md (committed to git).
> Personal project overrides go in ./CLAUDE.local.md (gitignored).

## How I work

- Run tests after any logic change — don't wait for me to ask
- Ask before making architectural changes — propose, don't just implement
- Prefer simple, readable code over clever code
- When in doubt, do less and ask

## My defaults

- Conventional commits: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`
- Branch naming: `feat/`, `fix/`, `chore/` — never commit to main/master directly
- Comments: explain WHY, not WHAT — the code shows what

## What I always want to know

- If you spot a security issue in unrelated code while working, flag it
- If a change you're about to make is irreversible, confirm first
- If tests are failing before you start, tell me before doing anything else

## Self-improvement

After every correction I give you, ask yourself:
"Should this go in CLAUDE.md so I don't repeat this mistake?"
If yes, suggest the addition and I'll approve it.
