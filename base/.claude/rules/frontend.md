---
# See: https://code.claude.com/docs/en/memory#path-specific-rules
paths:
  - "src/components/**/*.tsx"
  - "src/components/**/*.jsx"
  - "src/app/**/*.tsx"
  - "src/pages/**/*.tsx"
  - "src/views/**/*.tsx"
  - "src/ui/**/*.tsx"
---

# Frontend Rules

## Component structure
- Functional components with hooks only — no class components
- One component per file
- Component file name matches the exported component name (PascalCase)
- Co-locate: `ComponentName/index.tsx`, `ComponentName/ComponentName.test.tsx`, `ComponentName/ComponentName.module.css` (if using CSS modules)

## State management
- Local state: `useState` / `useReducer`
- Shared state: use the project's global store (check CLAUDE.md for which one)
- No prop drilling past 2 levels — lift or use context/store
- Derived state computed inline or in a `useMemo`, not stored in state

## Styling
- Use the project's designated styling system (check CLAUDE.md)
- No inline `style={}` except for truly dynamic values (e.g. animation positions)
- Responsive design: mobile-first
- Dark mode: account for it from the start, not as an afterthought

## Performance
- No anonymous functions in JSX that cause re-renders: `onClick={() => fn()}` → extract or `useCallback`
- Images: use the framework's optimized image component if available
- Heavy components: wrap with `React.lazy` + `Suspense` if not in the critical path
- Lists: always provide a stable, unique `key` — never array index for dynamic lists

## Accessibility
- Interactive elements are keyboard-navigable
- Images have meaningful `alt` text (or `alt=""` if decorative)
- Form inputs are associated with labels
- Color is not the only conveyor of information

## TypeScript
- No `any` — use `unknown` and narrow it, or define a proper type
- Props interface defined and exported for every component
- Event handlers typed with React's event types: `React.ChangeEvent<HTMLInputElement>`
