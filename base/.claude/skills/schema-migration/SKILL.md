---
name: schema-migration
description: Guides the full lifecycle of a database schema change — design, migration file, rollback, and deployment checklist. Auto-invoked when touching database schema, migration files, or asking about database changes.
user-invocable: true
---

# Schema Migration Skill

Database schema changes are the riskiest changes you make. Follow this protocol.

## Step 1 — Design first
Before writing any migration:
- What is the business requirement this change enables?
- What is the minimal schema change that satisfies it?
- Could this be done without a migration (application-level, feature flag)?
- Will this break any existing queries in production?

## Step 2 — Categorize the change
**Safe (can run on live DB with no downtime):**
- Adding a nullable column
- Adding a new table
- Adding an index (use `CONCURRENTLY` on PostgreSQL)
- Adding a constraint on an empty table or with a valid default

**Risky (requires careful coordination):**
- Renaming a column or table
- Removing a column or table
- Adding a NOT NULL constraint to an existing column
- Changing a column type
- Adding a foreign key on a large table

**Risky migrations require a multi-step deployment — ask before proceeding.**

## Step 3 — Write the migration
```sql
-- UP: what this migration does
-- Description: [what and why]
-- Reversible: yes/no

BEGIN;

-- your DDL here

COMMIT;

-- DOWN: rollback
-- BEGIN;
-- your rollback DDL here
-- COMMIT;
```

## Step 4 — Check the migration
- Does it run idempotently? (safe to run twice if something fails mid-way)
- Does the DOWN migration fully reverse the UP?
- Are there indexes needed for the new queries this enables?
- Will this lock the table? How long? Is that acceptable in production?

## Step 5 — Deployment checklist
- [ ] Migration tested on a copy of the production database
- [ ] Application code is backward compatible with both old and new schema
- [ ] Rollback plan documented
- [ ] Team informed of deployment window
- [ ] Monitoring in place for post-deploy
