---
name: security-review
description: Quick security check for any code, config, or infrastructure change. Auto-invoked when touching auth, payments, file uploads, external APIs, or user data. Lighter than the security-auditor agent — use for per-change checks.
user-invocable: true
---

# Security Review Skill

Run this mental model on every change that touches sensitive surfaces.

## The five questions

**1. Who can reach this code?**
- Is it behind authentication?
- Is it behind authorization (right user for this specific resource)?
- Is it rate-limited?

**2. What data flows through it?**
- Does it receive user input? → Validate type, length, format, allowed values
- Does it return data? → Only return what the caller is allowed to see
- Does it log anything? → No PII, no credentials in logs

**3. What external systems does it call?**
- Are credentials stored securely (env vars, secrets manager)?
- Are timeouts configured? (unhandled hangs = DoS vector)
- Is the response validated before being trusted?

**4. What can go wrong?**
- If the external service is down?
- If input is malformed?
- If two requests arrive simultaneously?

**5. What's the blast radius if this is exploited?**
- One user affected? All users? All data?
- Is the damage reversible?

## Quick scan patterns

```bash
# Hardcoded secrets
grep -r "api[_-]?key\s*=" --include="*.ts" --include="*.js" --include="*.py"

# SQL injection candidates
grep -r "query.*\+.*req\.\|execute.*\$\{" --include="*.ts"

# Missing await on async
grep -rn "async.*{" --include="*.ts" | head -20

# console.log with potential data leakage
grep -rn "console.log.*user\|console.log.*password\|console.log.*token"
```

## Output
For each concern: location, risk, severity (CRITICAL/HIGH/MEDIUM/LOW), fix.
