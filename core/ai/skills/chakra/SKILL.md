---
name: chakra
description:
  How to use the Chakra component library for React. Use when working on a React+Chakra codebase.
---

# Chakra UI v3 Highlights

## Key API Changes (v2 → v3)

- Compound components with dot notation: `Dialog.Root`, `Dialog.Content`, etc.
- No more `forwardRef` (React 19 — `ref` is a regular prop)
- `colorPalette` replaces `colorScheme`
- `NativeSelect` replaces `Select` for simple selects
- `Field.Root` / `Field.Label` / `Field.ErrorText` replaces `FormControl`

## Style Props

```tsx
<Box bg="blue.500" color="white" p="4" rounded="lg" shadow="md" _hover={{ bg: 'blue.600' }}>
```

Common: `bg`, `color`, `p/px/py`, `m/mx/my`, `w/h`, `rounded`, `shadow`, `gap`, `display`

## Layout

```tsx
<Flex gap="4" justify="space-between" align="center">
<Grid templateColumns="repeat(3, 1fr)" gap="4">
<HStack gap="4"> / <VStack gap="4">
<Stack gap="4">          // vertical by default
<Center h="100vh">
<Container maxW="6xl">
```

## Responsive Styles

```tsx
// Object syntax (preferred)
<Box fontSize={{ base: 'sm', md: 'md', lg: 'lg' }} p={{ base: '2', md: '4' }}>

// Array syntax (mobile-first)
<Box fontSize={['sm', 'md', 'lg']}>
```

Breakpoints: `base` 0px · `sm` 480px · `md` 768px · `lg` 992px · `xl` 1280px

## Common Components

### Button

```tsx
<Button colorPalette="blue">Solid</Button>
<Button colorPalette="blue" variant="outline">Outline</Button>
<Button colorPalette="blue" variant="ghost">Ghost</Button>
<Button loading loadingText="Saving...">Submit</Button>
```

### Forms

```tsx
<Field.Root invalid>
  <Field.Label>Email</Field.Label>
  <Input placeholder="..." />
  <Field.ErrorText>Required</Field.ErrorText>
</Field.Root>
```

### Dialog (Modal)

```tsx
<Dialog.Root open={open} onOpenChange={(e) => setOpen(e.open)}>
  <Dialog.Trigger asChild>
    <Button>Open</Button>
  </Dialog.Trigger>
  <Portal>
    <Dialog.Backdrop />
    <Dialog.Positioner>
      <Dialog.Content>
        <Dialog.Header>
          <Dialog.Title>Title</Dialog.Title>
        </Dialog.Header>
        <Dialog.Body>...</Dialog.Body>
        <Dialog.Footer>
          <Dialog.ActionTrigger asChild>
            <Button variant="outline">Cancel</Button>
          </Dialog.ActionTrigger>
          <Button colorPalette="blue">Confirm</Button>
        </Dialog.Footer>
        <Dialog.CloseTrigger />
      </Dialog.Content>
    </Dialog.Positioner>
  </Portal>
</Dialog.Root>
```

### Menu

```tsx
<Menu.Root>
  <Menu.Trigger asChild>
    <Button>Actions</Button>
  </Menu.Trigger>
  <Portal>
    <Menu.Positioner>
      <Menu.Content>
        <Menu.Item value="edit">Edit</Menu.Item>
        <Menu.Separator />
        <Menu.Item value="delete" color="red.500">
          Delete
        </Menu.Item>
      </Menu.Content>
    </Menu.Positioner>
  </Portal>
</Menu.Root>
```

### Tabs

```tsx
<Tabs.Root defaultValue="tab1">
  <Tabs.List>
    <Tabs.Trigger value="tab1">Tab 1</Tabs.Trigger>
    <Tabs.Trigger value="tab2">Tab 2</Tabs.Trigger>
  </Tabs.List>
  <Tabs.Content value="tab1">...</Tabs.Content>
</Tabs.Root>
```

## Theming

```ts
// theme.ts
import { createSystem, defaultConfig, defineConfig } from '@chakra-ui/react'

const config = defineConfig({
  theme: {
    tokens: {
      colors: { brand: { 500: { value: '#0073e6' }, ... } },
      fonts: { heading: { value: 'Inter, sans-serif' } },
    },
    semanticTokens: {
      colors: {
        brand: {
          solid: { value: '{colors.brand.500}' },   // bg for solid buttons
          contrast: { value: 'white' },              // text on solid bg
          fg: { value: '{colors.brand.700}' },       // foreground text
          muted: { value: '{colors.brand.100}' },
          subtle: { value: '{colors.brand.50}' },
          emphasized: { value: '{colors.brand.200}' }, // hover states
          focusRing: { value: '{colors.brand.500}' },
        },
      },
    },
  },
})

export const system = createSystem(defaultConfig, config)
```

Prefer `brand.subtle` / `brand.fg` over raw `brand.500` for dark-mode compatibility.

## Recipes (Component Variants)

```ts
import { defineRecipe, defineSlotRecipe } from "@chakra-ui/react"

// Single element
const buttonRecipe = defineRecipe({
  base: { display: "inline-flex", rounded: "lg" },
  variants: {
    visual: {
      solid: { bg: "brand.500", color: "white", _hover: { bg: "brand.600" } },
      outline: { border: "2px solid", borderColor: "brand.500" },
    },
    size: {
      sm: { h: "8", px: "3", fontSize: "sm" },
      md: { h: "10", px: "4", fontSize: "md" },
    },
  },
  defaultVariants: { visual: "solid", size: "md" },
})

// Multi-part component
const cardRecipe = defineSlotRecipe({
  slots: ["root", "header", "body", "footer"],
  base: { root: { bg: "white", rounded: "xl", shadow: "md" } },
  variants: { variant: { elevated: { root: { shadow: "xl" } } } },
})
```

## Best Practices

- Use compound components (`Dialog.Root`, `Menu.Content`, etc.)
- Use semantic tokens (`brand.solid`) not raw values (`brand.500`) for theme flexibility
  - If you need to add a new color, ask me first, then add it to the theme
- Use `recipes` for component variants — not inline conditionals
- Responsive object syntax is clearer than array syntax for complex styles
