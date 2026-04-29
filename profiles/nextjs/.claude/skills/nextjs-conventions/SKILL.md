---
# See: https://code.claude.com/docs/en/skills.md#frontmatter-reference
name: nextjs-conventions
description: Next.js-specific patterns and conventions. Auto-invoked when working on Next.js app structure, routing, data fetching, or deployment configuration.
---

# Next.js Conventions Skill

## Server vs Client component decision tree

```
Does this component need:
  - onClick, onChange, other event listeners? → Client
  - useState, useEffect, useReducer? → Client
  - Browser-only APIs (window, localStorage)? → Client
  - Real-time updates? → Client
  Otherwise → Server Component (preferred)
```

## Folder structure (App Router)
```
src/
├── app/
│   ├── (marketing)/         ← route group, no URL segment
│   │   ├── layout.tsx
│   │   └── page.tsx
│   ├── (app)/
│   │   ├── dashboard/
│   │   │   ├── page.tsx
│   │   │   ├── loading.tsx
│   │   │   └── error.tsx
│   │   └── layout.tsx
│   └── api/
│       └── webhooks/
│           └── route.ts
├── components/
│   ├── ui/                  ← primitives (shadcn, etc.)
│   └── features/            ← feature-specific components
├── lib/                     ← utilities, db clients, auth
└── types/                   ← shared TypeScript types
```

## Server Actions pattern
```typescript
// app/actions/user.ts
"use server"
import { z } from "zod"
import { revalidatePath } from "next/cache"

const schema = z.object({ name: z.string().min(1) })

export async function updateUser(formData: FormData) {
  const parsed = schema.safeParse({ name: formData.get("name") })
  if (!parsed.success) return { error: parsed.error.flatten() }
  
  // do the update
  revalidatePath("/dashboard")
  return { success: true }
}
```

## Metadata pattern
```typescript
// app/blog/[slug]/page.tsx
import type { Metadata } from "next"

export async function generateMetadata({ params }): Promise<Metadata> {
  const post = await getPost(params.slug)
  return {
    title: post.title,
    description: post.excerpt,
    openGraph: { images: [post.coverImage] },
  }
}
```

## Deployment checklist (Vercel)
- [ ] `NEXT_PUBLIC_*` vars set in Vercel dashboard
- [ ] Server-only vars set (no NEXT_PUBLIC prefix)
- [ ] `next.config.js` has correct `images.domains` or `remotePatterns`
- [ ] Build passes locally: `npm run build`
- [ ] No `console.error` in build output
