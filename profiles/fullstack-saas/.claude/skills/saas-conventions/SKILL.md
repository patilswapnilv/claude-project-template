---
# See: https://code.claude.com/docs/en/skills.md#frontmatter-reference
name: saas-conventions
description: Fullstack SaaS-specific patterns — auth flows, billing integration, multi-tenancy, and feature flags. Auto-invoked when working on subscription management, user onboarding, or tenant-scoped features.
---

# SaaS Conventions Skill

## Feature flag pattern
```typescript
// lib/features.ts
export function hasFeature(user: User, feature: Feature): boolean {
  const plan = PLAN_FEATURES[user.subscription.plan]
  return plan?.includes(feature) ?? false
}

// Usage — always check server-side, client is just UX
if (!hasFeature(user, "advanced_export")) {
  return NextResponse.json({ error: "upgrade_required" }, { status: 402 })
}
```

## Stripe webhook handler pattern
```typescript
// app/api/webhooks/stripe/route.ts
export async function POST(req: Request) {
  const body = await req.text()
  const sig = req.headers.get("stripe-signature")!
  
  let event: Stripe.Event
  try {
    event = stripe.webhooks.constructEvent(body, sig, process.env.STRIPE_WEBHOOK_SECRET!)
  } catch {
    return new Response("Invalid signature", { status: 400 })
  }

  // Idempotency check — process each event ID only once
  const processed = await db.webhookEvent.findUnique({ where: { stripeEventId: event.id } })
  if (processed) return new Response("Already processed", { status: 200 })

  switch (event.type) {
    case "customer.subscription.updated":
      await handleSubscriptionUpdate(event.data.object as Stripe.Subscription)
      break
    // handle other events
  }

  await db.webhookEvent.create({ data: { stripeEventId: event.id } })
  return new Response("OK", { status: 200 })
}
```

## Tenant-scoped query pattern
```typescript
// repositories/project.repository.ts
export async function getProjects(userId: string, orgId: string) {
  // Always scope to both user AND org — defense in depth
  return db.project.findMany({
    where: {
      organizationId: orgId,
      organization: { members: { some: { userId } } }, // verify membership
    },
  })
}
```

## Onboarding checklist pattern
```typescript
// Track completion state server-side, not in localStorage
type OnboardingStep = "profile" | "invite_team" | "first_project" | "connect_integration"

async function getOnboardingProgress(orgId: string): Promise<Record<OnboardingStep, boolean>> {
  const org = await db.organization.findUnique({ where: { id: orgId }, include: { members: true, projects: true } })
  return {
    profile: Boolean(org?.name && org?.logoUrl),
    invite_team: (org?.members.length ?? 0) > 1,
    first_project: (org?.projects.length ?? 0) > 0,
    connect_integration: Boolean(org?.integrationConnectedAt),
  }
}
```
