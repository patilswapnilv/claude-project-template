---
paths:
  - "src/db/**/*"
  - "src/repositories/**/*"
  - "src/models/**/*"
  - "prisma/**/*"
  - "drizzle/**/*"
  - "migrations/**/*"
  - "**/*.sql"
  - "src/lib/db*"
  - "src/lib/supabase*"
---

# Database Rules

## Migrations
- Every schema change goes through a migration file — never alter production schema manually
- Migration files are immutable once merged — never edit a past migration
- Migration file names include timestamp and description: `20240115_add_user_preferences.sql`
- Every migration must have a rollback path — write the down migration alongside the up
- Test migrations on a copy of production data before applying to production

## Queries
- No raw string concatenation in queries — use parameterized queries or the ORM's query builder
- Queries live in repository files — no inline SQL/ORM calls in controllers or services
- Paginate all list queries — no unbounded `SELECT *`
- Add `LIMIT` even when you expect one result — use `.first()` not `.findMany()`
- Index every foreign key and every column that appears in a `WHERE` clause in production queries

## Transactions
- Wrap multi-step operations in a transaction
- Keep transactions short — no external API calls inside a transaction
- On transaction failure, always propagate the error — never silently swallow

## Data integrity
- Enforce constraints at the database level, not only in application code
- NOT NULL on columns that must always have a value
- Foreign key constraints enabled
- Unique constraints for uniqueness guarantees
- Check constraints for value validation (enums, ranges)

## Sensitive data
- Never log query results that may contain PII
- Hash passwords at the application layer before storing (bcrypt, argon2)
- Encrypt sensitive fields (PII, secrets) at rest if required
- Never return raw database rows to the API layer — always map to a DTO

## Performance
- Use `EXPLAIN ANALYZE` before adding a complex query to production
- Avoid N+1: batch or join instead of querying in a loop
- Cache expensive read queries where the data is slow-changing
