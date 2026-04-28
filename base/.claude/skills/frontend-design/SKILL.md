---
name: frontend-design
description: Apply structured design decisions to any UI component or page. Auto-invoked when building or styling UI elements, landing pages, dashboards, or any visual component. Ensures consistency and avoids generic-looking output.
user-invocable: true
---

# Frontend Design Skill

> This is the generic baseline. Override colors, fonts, and spacing in your project's `CLAUDE.local.md` or in a project-specific skill that extends this one.

## Design decision process

Before writing any CSS or layout code, answer:
1. What is the user trying to do on this screen?
2. What is the single most important element? (That gets the most visual weight)
3. What is the reading order? (Guide the eye)
4. What happens on mobile?

## Visual hierarchy rules
- One primary action per screen — everything else is secondary
- Size, weight, and contrast establish hierarchy — use them consistently
- White space is structure — don't fill every pixel
- Alignment creates calm — random alignment creates noise

## Typography baseline
- Use a system font stack or a single loaded typeface — not both
- Body text: 15-16px, 1.5-1.6 line-height, comfortable contrast (WCAG AA minimum)
- Headings: tight line-height (1.1-1.2), slightly tracked (letter-spacing: -0.02em)
- Limit to 2 font sizes in most components — hero and body

## Spacing system
Use a consistent scale — pick one and stick to it:
- 4px base: `4, 8, 12, 16, 24, 32, 48, 64, 96`
- 8px base: `8, 16, 24, 32, 48, 64, 96, 128`
- Never use arbitrary values like `17px` or `23px`

## Color usage
- Background → Surface → Component: 3 levels of depth
- One accent color for interactive elements — used sparingly
- Error: always red-adjacent. Success: green-adjacent. Warning: amber-adjacent.
- Test every color combination for contrast before shipping

## Component patterns
- Cards: consistent padding, consistent border-radius, consistent shadow
- Forms: label above input, error below input, consistent field height
- Tables: zebra striping or clear row separation, sticky header on scroll
- Empty states: always design them — never show a blank div

## Interaction states
Every interactive element needs:
- Default
- Hover
- Focus (keyboard-navigable — visible focus ring)
- Active (press)
- Disabled

## Dark mode
If the project supports dark mode:
- Never use pure black (#000) — use dark grays (#0A0A0F, #111, #1A1A1A)
- Depth through elevation: darker = lower, lighter = higher (opposite of light mode)
- Shadows don't work in dark mode — use borders and subtle gradients instead
