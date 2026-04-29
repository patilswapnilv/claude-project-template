---
# See: https://code.claude.com/docs/en/memory#path-specific-rules
paths:
  - "app/**/*"
  - "src/app/**/*"
  - "components/**/*"
  - "src/components/**/*"
  - "pages/**/*"
  - "src/pages/**/*"
  - "lib/**/*"
  - "src/lib/**/*"
---

# Next.js Rules

## App Router (Next.js 13+)
- Server Components by default — only add `"use client"` when you need interactivity, browser APIs, or hooks
- Never use `"use client"` at a layout level — push it down to the leaf component that needs it
- Data fetching: `async/await` in Server Components, not `useEffect` + `useState`
- Loading states: `loading.tsx` at the route segment level
- Error boundaries: `error.tsx` at the route segment level
- `not-found.tsx` for 404 handling

## Routing
- File-based routing — respect the convention: `page.tsx`, `layout.tsx`, `loading.tsx`, `error.tsx`
- Dynamic routes: `[id]` for single, `[...slug]` for catch-all
- Route groups: `(group)` for organization without affecting URL
- Parallel routes and intercepting routes for advanced layouts — use sparingly

## Data fetching
- Server-side: `async` Server Component with `fetch()` (Next.js extends it with caching)
- Cache control: `fetch(url, { cache: 'no-store' })` for dynamic, `{ next: { revalidate: 60 } }` for ISR
- Mutations: Server Actions (`"use server"`) — no separate API route needed for simple mutations
- API routes: `app/api/route.ts` only for external webhooks or third-party integrations

## Performance
- `next/image` for all images — never `<img>`
- `next/font` for fonts — never load fonts from `<link>` in layout
- `next/link` for internal navigation — never `<a href>`
- Dynamic import (`next/dynamic`) for heavy client components
- Avoid putting large dependencies in Server Components' client bundle

## TypeScript
- `PageProps`, `LayoutProps` from Next.js types for page components
- Type `params` and `searchParams` properly in page components
- Use `Metadata` type for `export const metadata`

## Environment variables
- Server-only vars: no `NEXT_PUBLIC_` prefix — they never reach the browser
- Browser-safe vars: `NEXT_PUBLIC_` prefix — but treat them as public
- Access with `process.env.VAR_NAME` — validate at startup, not at runtime

## Database command examples
```bash
# Prisma (common Next.js stack)
npx prisma migrate dev
npx prisma studio
```
