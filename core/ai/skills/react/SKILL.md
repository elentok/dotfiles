---
name: react
description: How to use React. Use when working on a React codebase.
---

# React Best Practices & Composition Patterns

Based on [Vercel Agent Skills](https://github.com/vercel-labs/agent-skills)

---

## Part 1: React Best Practices

### 1. Eliminating Waterfalls (CRITICAL)

- **Defer await until needed** — move `await` into the branch that uses the result; don't block
  early-return paths.
- **Parallelize with `Promise.all()`** — never `await` independent operations sequentially; run them
  concurrently.
- **Dependency-based parallelization** — for partial dependencies, start promises eagerly and
  `Promise.all()` at the end:
  ```ts
  const userPromise = fetchUser()
  const profilePromise = userPromise.then((u) => fetchProfile(u.id))
  const [user, config, profile] = await Promise.all([userPromise, fetchConfig(), profilePromise])
  ```
- **Strategic Suspense boundaries** — wrap only the data-dependent section in `<Suspense>` so layout
  renders immediately. Share promises across sibling components via `use()`.

### 2. Bundle Size Optimization (CRITICAL)

- **Avoid barrel file imports** — import directly from source (`lucide-react/dist/esm/icons/check`)
  instead of barrel re-exports. Barrel imports can load 1,500+ modules.
- **Dynamic imports for heavy components** — use `React.lazy` / `next/dynamic` with `{ ssr: false }`
  for large components (editors, charts).
- **Defer non-critical libraries** — load analytics/logging after hydration via dynamic import.
- **Preload on user intent** — trigger `import()` on `onMouseEnter`/`onFocus` to reduce perceived
  latency.
- **Conditional module loading** — `import()` large data/modules only when a feature is activated.

### 3. Server-Side Performance (HIGH)

- **Authenticate Server Actions** — treat `"use server"` functions as public endpoints; always
  verify auth + authorization inside each action.
- **Minimize serialization at RSC boundaries** — only pass the fields the client component actually
  uses, not entire objects.
- **Parallel data fetching with component composition** — make the parent a sync component that
  renders async children in parallel (not a sequential async parent).
- **Per-request dedup with `React.cache()`** — wrap DB queries/auth checks; avoid inline objects as
  args (uses `Object.is`).
- **Hoist static I/O to module level** — fonts, logos, config files read once at import, not
  per-request.
- **Use `after()` for non-blocking ops** — schedule logging/analytics after the response is sent.

### 4. Client-Side Data Fetching (MEDIUM-HIGH)

- **Use SWR** for automatic request deduplication, caching, and revalidation across component
  instances.
- **Passive event listeners** — add `{ passive: true }` to touch/wheel listeners that don't call
  `preventDefault()`.
- **Deduplicate global event listeners** — use a shared subscription (e.g., `useSWRSubscription`)
  instead of N listeners for N component instances.
- **Version localStorage keys** — prefix with version, store minimal fields, always wrap in
  try-catch.

### 5. Re-render Optimization (MEDIUM)

- **Derive state during render** — if computable from props/state, don't store in state or sync via
  useEffect.
- **Don't define components inside components** — creates new component type every render,
  destroying state/DOM.
- **Functional `setState` updates** — `setState(prev => ...)` avoids stale closures and removes
  state from dependency arrays.
- **Lazy state initialization** — `useState(() => expensive())` runs only once; without the arrow,
  it runs every render.
- **Split combined hook computations** — separate `useMemo`/`useEffect` with independent deps so
  they recompute independently.
- **Subscribe to derived state** — e.g., `useMediaQuery('(max-width:767px)')` instead of subscribing
  to continuous `width` changes.
- **Extract default non-primitive values to constants** — `const NOOP = () => {}` as default prop
  for `memo()`'d components.
- **Use `useRef` for transient values** — mouse position, interval IDs, flags that shouldn't trigger
  re-renders.
- **`useDeferredValue`** for expensive derived renders — keeps input responsive while heavy
  computation catches up.
- **`startTransition`** for non-urgent updates — marks frequent state updates (scroll, resize) as
  interruptible.
- **Put interaction logic in event handlers** — not as state + effect; avoids duplicate side
  effects.

### 6. Rendering Performance (MEDIUM)

- **CSS `content-visibility: auto`** — skip layout/paint for off-screen items in long lists (10×
  faster initial render for 1000 items).
- **Animate SVG wrapper div, not SVG element** — enables hardware-accelerated CSS transforms.
- **Hoist static JSX** — extract constant JSX outside components to avoid re-creation.
- **`<Activity mode="visible|hidden">`** — React API to preserve state/DOM for toggled components.
- **`defer`/`async` on scripts** — never block HTML parsing with synchronous script tags.
- **Explicit conditional rendering** — use ternary (`? :`) not `&&` when condition can be `0` or
  `NaN`.
- **React DOM resource hints** — `prefetchDNS`, `preconnect`, `preload`, `preinit` for critical
  resources.
- **Prevent hydration flicker** — inject synchronous `<script>` to read localStorage before React
  hydrates.

### 7. JavaScript Performance (LOW-MEDIUM)

- **`Set`/`Map` for O(1) lookups** — convert arrays to Set for repeated `.includes()` checks.
- **Build index Maps** for repeated `.find()` by key — `new Map(users.map(u => [u.id, u]))`.
- **`flatMap` to map+filter in one pass** — `arr.flatMap(x => x.valid ? [x.value] : [])`.
- **`toSorted()` over `sort()`** — immutable sorting; `.sort()` mutates arrays which breaks React
  state.
- **Early return** — skip unnecessary processing once result is determined.
- **Early length check** — before expensive array comparisons, check `a.length !== b.length`.
- **Combine multiple array iterations** — single `for..of` loop instead of chained `.filter()`
  calls.
- **Hoist RegExp creation** — to module scope or `useMemo`; don't recreate in render.
- **Cache repeated function calls** — module-level Map cache for pure functions called with same
  inputs.
- **Cache storage API calls** — `localStorage`/`sessionStorage`/cookies are sync & expensive; cache
  in memory.
- **Avoid layout thrashing** — batch all style writes, then read; don't interleave reads and writes.

### 8. Advanced Patterns (LOW)

- **Initialize app once, not per mount** — module-level `didInit` guard for one-time setup (auth,
  storage load).
- **`useEffectEvent`** — stable callback ref that always calls latest handler without adding to
  effect deps.
- **Store handlers in refs** — for effects that shouldn't re-subscribe when callbacks change.

---

## Part 2: Composition Patterns

### 1. Component Architecture (CRITICAL/HIGH)

- **Avoid boolean prop proliferation** — each boolean doubles possible states. Instead of
  `<Composer isThread isEditing isDMThread>`, create explicit variants: `<ThreadComposer>`,
  `<EditComposer>`, `<ForwardComposer>`.
- **Use compound components** — structure complex components with shared context. Export as
  namespace object:
  ```tsx
  const Composer = {
    Provider: ComposerProvider,
    Frame: ComposerFrame,
    Input: ComposerInput,
    Submit: ComposerSubmit,
    Footer: ComposerFooter,
  }
  ```
  Consumers compose exactly what they need; no hidden conditionals.

### 2. State Management (HIGH/MEDIUM)

- **Lift state into provider components** — move state out of UI components into dedicated
  providers. This lets sibling components (buttons, previews outside the main component frame)
  access shared state via context without prop drilling.
- **Decouple state management from UI** — the provider is the only place that knows how state is
  managed (useState, Zustand, server sync). UI components consume a generic context interface:
  ```tsx
  interface ComposerContextValue {
    state: ComposerState
    actions: ComposerActions
    meta: ComposerMeta
  }
  ```
- **Define generic context interfaces for dependency injection** — same UI components work with
  completely different providers (local state for ephemeral forms, global synced state for
  channels). Swap the provider, keep the UI.
- **Provider boundary is what matters** — components don't need to be visually nested inside each
  other; they just need to be within the same provider to access shared state.

### 3. Implementation Patterns (MEDIUM)

- **Create explicit component variants** — `<ThreadComposer>`, `<EditMessageComposer>`,
  `<ForwardMessageComposer>` instead of one component with boolean flags. Each variant is
  self-documenting about what provider, UI elements, and actions it uses.
- **Prefer children over render props** — `children` compose naturally and are more readable. Use
  render props only when the parent needs to pass data back to the child (e.g., `renderItem` in a
  list).

### 4. React 19 APIs (MEDIUM)

- **No more `forwardRef`** — `ref` is a regular prop in React 19.
- **`use()` replaces `useContext()`** — and can be called conditionally.

### Core Principles Summary

1. **Composition > Configuration** — enable consumers to compose rather than adding config props
2. **Centralize state in providers** — keep state in providers, not individual components
3. **Internal composition via context** — subcomponents access shared state directly, not via props
4. **Explicit variants** — named component variations instead of generic components with boolean
   flags
5. **Swap provider, keep UI** — the same composed UI works with any provider implementing the
   interface

## Part 3: Coding style

- Only use font sizes, font weights, border radiuses, gaps and from styles.ts, if you need to add
  new ones please ask me first.
- Prefer Chakra's `<Flex>` over `<Box display="flex">`
- Prefer Chakra's `<Button>` ov
- Only use colors from the Chakra theme, if you're adding new colors, add them to the theme
- Avoid large components, if the component is over 150 lines try to break it to smaller components.
- Avoid default exports (it makes it more difficult to do refactors)
