---
# See: https://code.claude.com/docs/en/memory#path-specific-rules
paths:
  - "src/api/**/*"
  - "src/routes/**/*"
  - "src/controllers/**/*"
  - "src/handlers/**/*"
  - "src/middleware/**/*"
  - "app/api/**/*"
  - "pages/api/**/*"
---

# API Rules

## Design
- RESTful conventions: GET retrieves, POST creates, PUT/PATCH updates, DELETE removes
- Use plural nouns for resources: `/users`, `/orders`, not `/user`, `/getOrder`
- Nest related resources up to 2 levels: `/users/:id/posts` — deeper than that, reconsider
- Versioning in the URL: `/api/v1/...` — never break a published API, deprecate instead

## Request validation
- Validate ALL inputs at the API boundary — trust nothing from the client
- Use a schema validation library (Zod, Joi, Yup, etc.) — define schemas as the source of truth
- Validate: type, format, length, range, required fields, unexpected fields
- Return `400 Bad Request` with a structured error body showing exactly what failed

## Authentication & authorization
- Authenticate before processing any request on protected routes
- Check authorization on every request — authn ≠ authz (user is logged in ≠ user can do this)
- Never expose internal IDs in URLs if they allow enumeration — use UUIDs
- Rate-limit auth endpoints — login, password reset, token refresh

## Response format
Consistent structure across all endpoints:
```json
// Success
{ "data": { ... }, "meta": { "page": 1, "total": 42 } }

// Error
{ "error": { "code": "VALIDATION_ERROR", "message": "Human-readable", "details": [...] } }
```

## HTTP status codes
- `200` — success (GET, PUT, PATCH)
- `201` — created (POST)
- `204` — no content (DELETE)
- `400` — bad request (validation error)
- `401` — unauthenticated
- `403` — unauthorized (authenticated but not permitted)
- `404` — not found
- `409` — conflict (duplicate, version mismatch)
- `422` — unprocessable entity (business logic rejection)
- `429` — rate limited
- `500` — unexpected server error

## Error handling
- Never return stack traces to clients in production
- Log the full error server-side with request context
- Return a consistent error body regardless of error type
- All async handlers must have error handling — uncaught promise rejections crash the server

## Performance
- Paginate every list endpoint — default page size ≤ 50
- Support `fields` projection for large resources
- Cache GET responses where data is stable — use `Cache-Control` headers
- Set request body size limits — reject oversized payloads early
