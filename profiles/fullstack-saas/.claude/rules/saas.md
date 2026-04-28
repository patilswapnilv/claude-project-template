---
paths:
  - "src/**/*"
  - "app/**/*"
  - "lib/**/*"
  - "server/**/*"
---

# Fullstack SaaS Rules

## Multi-tenancy
- Every database query must be scoped to the authenticated user's organization/tenant
- Never rely on client-provided tenant IDs for authorization — derive from the authenticated session
- Test cross-tenant data isolation — a user from org A must never see org B's data
- Row-level security (RLS) at the database level as a second line of defense

## Authentication
- Auth state is the source of truth — derive everything else from it
- Protected routes check auth before rendering any content or making any queries
- Session expiry: handle gracefully — redirect to login, preserve intended destination
- Remember: authenticated ≠ authorized. Check both.

## Billing and subscriptions
- Feature flags driven by subscription tier — centralized, not scattered
- Never trust client-side billing state — verify against the billing provider server-side
- Webhooks for billing events: idempotent handlers — Stripe/Paddle can deliver twice
- Test the free tier limits — they're often forgotten during development
- Graceful degradation when a subscription lapses — don't hard-error, guide to upgrade

## Background jobs
- All long-running operations are background jobs — never block the HTTP request
- Jobs must be idempotent — they may run more than once
- Retry with exponential backoff — not immediate retry loops
- Dead letter queue for repeatedly failing jobs — alert on accumulation
- Job status visible to users for operations they initiated

## Emails and notifications
- Transactional emails: triggered by system events, never user data in subject lines
- Unsubscribe link required in all marketing emails
- Test email rendering in multiple clients before launch
- Never send emails from background jobs without rate limiting

## Observability
- Structured logging: JSON format, consistent field names (`user_id`, `org_id`, `request_id`)
- Error tracking: every unhandled exception captured with context
- Performance monitoring: p50/p95/p99 on critical paths
- Business metrics: track events that matter to the business, not just technical metrics

## Launch checklist additions
- [ ] GDPR/privacy policy up to date and linked from footer
- [ ] Terms of service in place
- [ ] Data deletion process exists (can you honor a GDPR deletion request?)
- [ ] Support contact visible and working
- [ ] Billing webhook endpoint configured and tested
- [ ] Rate limiting on all public endpoints
- [ ] Error page (500) and not-found page (404) designed and deployed
