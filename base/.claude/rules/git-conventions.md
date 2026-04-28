---
paths:
  - ".github/**/*"
  - "**/.gitignore"
  - "CHANGELOG.md"
---

# Git & Version Control Rules

## Commits
- Conventional commits format: `type(scope): description`
- Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `perf`, `ci`
- Description: imperative mood, lowercase, no period: `fix: handle null user in auth middleware`
- Body (optional): explain WHY, not what. The diff shows what.
- Breaking changes: add `!` after type: `feat!: rename API endpoint` and document in body

## Branches
- Branch from `main` (or `develop` if the project uses gitflow)
- Naming: `feat/short-description`, `fix/short-description`, `chore/short-description`
- Delete branches after merging
- Protected branches: `main`, `master`, `production` — never commit directly

## Pull Requests
- One concern per PR — mixing features with refactors obscures intent
- PR title follows the same format as a commit message
- Description includes: what changed, why, how to test, any deployment notes
- Link the relevant issue: `closes #123`
- PR size: under 400 lines of meaningful change is reviewable; larger PRs get split

## What to commit
- Commit: source code, tests, migrations, config (non-secret), documentation
- Never commit: `.env`, secrets, `node_modules`, build artifacts, IDE files
- `.gitignore` must include: `.env*`, `dist/`, `build/`, `.DS_Store`, `*.local`

## Tags and releases
- Semantic versioning: `MAJOR.MINOR.PATCH`
- Tag every production release: `git tag v1.2.3`
- `CHANGELOG.md` updated on every release
