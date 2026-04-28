# Project Brain

> **Setup instructions:** Replace all `{{PLACEHOLDER}}` values with your project specifics.
> Delete this instruction block when done.

## Project

**Name:** {{PROJECT_NAME}}
**Purpose:** {{ONE_LINE_DESCRIPTION}}
**Status:** {{active | maintenance | greenfield}}

## Stack

{{LIST_YOUR_STACK_HERE}}
Example: Next.js 14, TypeScript, Tailwind CSS, Supabase, Vercel

## Key Commands

```bash
# Development
{{DEV_COMMAND}}          # e.g. npm run dev

# Build & Test
{{BUILD_COMMAND}}        # e.g. npm run build
{{TEST_COMMAND}}         # e.g. npm test
{{LINT_COMMAND}}         # e.g. npm run lint

# Database
{{DB_MIGRATE_COMMAND}}   # e.g. npx prisma migrate dev
{{DB_STUDIO_COMMAND}}    # e.g. npx prisma studio
```

## Repository Layout

```
{{PROJECT_NAME}}/
├── {{SOURCE_DIR}}/      # {{DESCRIBE_SOURCE}}
├── {{TEST_DIR}}/        # {{DESCRIBE_TESTS}}
├── {{CONFIG_DIR}}/      # {{DESCRIBE_CONFIG}}
└── {{DOCS_DIR}}/        # {{DESCRIBE_DOCS}}
```

## Architecture

{{BRIEF_ARCHITECTURE_DESCRIPTION}}
Example: REST API → Service layer → Repository layer → PostgreSQL. No ORM — raw SQL via pgx.

## Conventions

- **Language:** {{PRIMARY_LANGUAGE}} — strict mode, no `any` / no untyped
- **Branching:** `main` is protected. All changes via PR. Branch naming: `feat/`, `fix/`, `chore/`
- **Commits:** Conventional commits — `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`
- **Tests:** {{TESTING_PHILOSOPHY}} — e.g. "unit tests for business logic, integration tests for APIs"
- **Error handling:** {{ERROR_PATTERN}} — e.g. "never swallow errors, always log with context"

## What Claude should always do

- Read existing patterns before writing new code — match the style in the file you're editing
- Run `{{LINT_COMMAND}}` after every edit
- Write tests alongside implementation, not after
- Ask before making architectural changes
- Never modify `.env` or `.env.*` files directly

## What Claude should never do

- Force push to any branch
- Delete files without confirmation
- Install packages without stating why
- Use `any` types or bypass type checking
- Hardcode secrets, API keys, or credentials

## External docs

- {{LINK_TO_ARCHITECTURE_DOC}}
- {{LINK_TO_API_DOCS}}
- {{LINK_TO_TEAM_RUNBOOK}}

## Active work

<!-- Update this section as work progresses. Claude reads it every session. -->
- [ ] {{CURRENT_TASK_1}}
- [ ] {{CURRENT_TASK_2}}
