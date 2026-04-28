---
paths:
  - "src/**/*.tsx"
  - "src/**/*.ts"
  - "app/**/*.tsx"
  - "components/**/*.tsx"
  - "screens/**/*.tsx"
  - "navigation/**/*.tsx"
---

# React Native Rules

## Project structure
```
src/
  screens/           ← full-screen views
  components/        ← reusable components
    ui/              ← primitive components (Button, Text, etc.)
    features/        ← feature-specific components
  navigation/        ← React Navigation setup
  hooks/             ← custom hooks
  stores/            ← state management
  services/          ← API calls, native modules
  utils/             ← helpers
  types/             ← shared TypeScript types
  theme/             ← colors, spacing, typography tokens
```

## Platform considerations
- Use `Platform.OS` for platform-specific behavior — not file extensions unless the difference is large
- Large platform differences: use `.ios.tsx` / `.android.tsx` file splitting
- Always test on both iOS and Android — assumptions about one often break the other
- Safe area: always use `SafeAreaView` or `useSafeAreaInsets` — never hardcode padding

## Performance
- `FlatList` / `SectionList` for any list — never `ScrollView` + `.map()` for dynamic data
- `useCallback` for functions passed as props to `FlatList` items
- `React.memo` for list item components — prevents re-renders on unrelated state changes
- Avoid state updates in render — they cause infinite loops
- Images: specify explicit `width` and `height` — RN cannot infer from flex alone

## Navigation (React Navigation)
- Type all navigation params: `RootStackParamList`
- Navigate with typed hooks: `useNavigation<StackNavigationProp<RootStackParamList>>()`
- Don't put business logic in navigation files — they're routing only
- Deep links: handle in the navigation config, not scattered in screens

## Styling
- StyleSheet.create() for static styles — not inline objects (avoids re-creation on every render)
- Use theme tokens from `src/theme/` — no hardcoded colors or spacing values
- No absolute units for font sizes — use a scaling function for different screen sizes

## Native modules
- Document any native module with its iOS and Android setup steps
- Wrap native module calls in try/catch — they can throw on unsupported platforms
- Test on physical devices for anything involving camera, GPS, biometrics, or notifications
