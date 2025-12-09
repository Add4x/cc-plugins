# Next.js Frontend Development Plugin

A comprehensive Claude Code plugin for modern Next.js development with TypeScript, Tailwind CSS v4, shadcn/ui, TanStack Query, and Zustand.

## Overview

This plugin helps Claude generate consistent, production-ready Next.js code following modern best practices and patterns extracted from real-world applications. It includes intelligent guidance, code generation scripts, and comprehensive templates.

## Features

### 🎯 Skills
- **nextjs-patterns**: Comprehensive patterns for Next.js App Router development
  - Server vs Client Component decisions
  - TypeScript best practices
  - Tailwind CSS v4 patterns
  - shadcn/ui component patterns
  - TanStack Query data fetching
  - Zustand state management
  - API route patterns
  - Testing strategies

### 🛠️ Scripts
- **new-component.sh**: Generate React components with tests
- **new-api-route.sh**: Create API routes with validation
- **new-store.sh**: Build Zustand stores with persistence
- **new-hook.sh**: Create custom hooks (query, mutation, state)

### 📋 Templates
- Component templates
- API route templates
- Store templates
- Hook templates

## Installation

### Prerequisites
- Claude Code CLI installed
- A Next.js project (v14+)
- pnpm package manager (recommended)

### Add Plugin to Your Project

```bash
# Navigate to your project
cd /path/to/your/nextjs-project

# Add the development plugins marketplace (if not already added)
/plugin marketplace add /Users/shyjuviswambaran/add4x/cc-plugins

# Install the plugin
/plugin install nextjs-frontend-dev@development-plugins-marketplace

# Verify installation
/plugin list
```

## Usage

### Using the Skill

The skill automatically enhances Claude's understanding of Next.js patterns. When you ask Claude to:
- Create a component
- Build an API route
- Set up state management
- Implement data fetching

Claude will automatically follow the patterns defined in this skill, ensuring:
- ✅ Correct Server/Client component usage
- ✅ Proper TypeScript typing
- ✅ `cn()` utility for className management
- ✅ shadcn/ui component patterns
- ✅ TanStack Query for data fetching
- ✅ Zustand for state management

**Example prompts:**

```
"Create a menu item card component with image, title, description, and price"
→ Claude generates a properly typed component with cn(), responsive design, and tests

"Build an API route for fetching categories with pagination"
→ Claude creates route with Zod validation, error handling, and tests

"Create a shopping cart store with persistence"
→ Claude builds Zustand store with localStorage, TypeScript, and tests
```

### Using the Scripts

All scripts are located in `scripts/` and are executable shell scripts.

#### Generate a Component

```bash
# Basic usage (creates in src/components/)
./scripts/new-component.sh Button

# Specify custom path
./scripts/new-component.sh MenuCard components/menu

# Creates:
# - src/components/menu/menu-card.tsx
# - src/components/menu/__tests__/menu-card.test.tsx
# - Updates/creates index.ts
```

**Interactive prompts:**
- Is this a client component? (y/N)

#### Generate an API Route

```bash
# Create API route
./scripts/new-api-route.sh categories

# Creates:
# - src/app/api/categories/route.ts
# - src/app/api/categories/__tests__/route.test.ts
```

**Interactive prompts:**
- Select HTTP methods (GET, POST, PUT, DELETE, PATCH)

#### Generate a Zustand Store

```bash
# Create store
./scripts/new-store.sh cart

# Creates:
# - src/stores/cart-store.ts
# - src/stores/__tests__/cart-store.test.ts
```

**Interactive prompts:**
- Enable localStorage persistence? (y/N)

#### Generate a Custom Hook

```bash
# Create a query hook (default)
./scripts/new-hook.sh use-categories query

# Create a mutation hook
./scripts/new-hook.sh use-create-category mutation

# Create a state hook
./scripts/new-hook.sh use-toggle state

# Creates:
# - src/hooks/use-categories.ts
# - src/hooks/__tests__/use-categories.test.ts
```

**Hook types:**
- `query` - TanStack Query useQuery hook
- `mutation` - TanStack Query useMutation hook
- `state` - Custom state management hook

## Technology Stack

### Core Technologies
- **Next.js**: 14/15/16+ with App Router
- **React**: 18/19+ (Server & Client Components)
- **TypeScript**: Strict mode enabled
- **Package Manager**: pnpm (recommended)

### Styling
- **Tailwind CSS**: v4 (utility-first)
- **shadcn/ui**: Radix UI components
- **class-variance-authority**: Variant management
- **clsx + tailwind-merge**: `cn()` utility

### State & Data
- **Zustand**: Global state management
- **TanStack Query**: Server state & caching
- **Zod**: Runtime validation

### Testing
- **Vitest**: Unit & integration testing
- **Testing Library**: React component testing

## Project Structure

The plugin expects and enforces this structure:

```
your-nextjs-project/
├── src/
│   ├── app/
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   ├── globals.css
│   │   ├── (main)/              # Route groups
│   │   │   ├── layout.tsx
│   │   │   └── menu/
│   │   │       ├── page.tsx
│   │   │       └── components/  # Page-specific components
│   │   └── api/
│   │       └── categories/
│   │           ├── route.ts
│   │           └── __tests__/
│   ├── components/
│   │   ├── ui/                  # shadcn/ui components
│   │   ├── menu/                # Feature components
│   │   ├── cart/
│   │   └── providers/
│   ├── hooks/
│   │   ├── use-categories.ts
│   │   └── __tests__/
│   ├── stores/
│   │   ├── cart-store.ts
│   │   └── __tests__/
│   ├── lib/
│   │   ├── utils.ts             # cn() utility
│   │   └── api/
│   ├── types/
│   ├── config/
│   └── actions/
├── public/
├── package.json
└── tsconfig.json
```

## Key Patterns

### 1. Server Components First

By default, all components are Server Components. Only add `'use client'` when necessary:

**Server Component (default):**
```typescript
// app/page.tsx
export default function Page() {
  return <div>Static content</div>
}
```

**Client Component (when needed):**
```typescript
// components/counter.tsx
'use client'

import { useState } from 'react'

export function Counter() {
  const [count, setCount] = useState(0)
  return <button onClick={() => setCount(c => c + 1)}>{count}</button>
}
```

### 2. The cn() Utility

**Always use `cn()` for className management:**

```typescript
import { cn } from "@/lib/utils"

<div className={cn("base-class", isActive && "active-class", className)} />
```

### 3. TypeScript Strict Mode

All code uses strict TypeScript:

```typescript
// ✅ Good
interface ButtonProps {
  variant?: 'primary' | 'secondary'
  onClick?: () => void
}

// ❌ Avoid
interface ButtonProps {
  variant?: any
  onClick?: Function
}
```

### 4. Data Fetching with TanStack Query

**Client-side data fetching:**

```typescript
"use client"

import { useQuery } from "@tanstack/react-query"

export function useCategories() {
  return useQuery({
    queryKey: ["categories"],
    queryFn: async () => {
      const res = await fetch('/api/categories')
      if (!res.ok) throw new Error('Failed to fetch')
      return res.json()
    },
    staleTime: 5 * 60 * 1000,
  })
}
```

### 5. State Management with Zustand

**Global state with persistence:**

```typescript
import { create } from "zustand"
import { persist } from "zustand/middleware"

interface CartState {
  items: Item[]
  addItem: (item: Item) => void
}

export const useCartStore = create<CartState>()(
  persist(
    (set) => ({
      items: [],
      addItem: (item) => set((state) => ({
        items: [...state.items, item]
      })),
    }),
    { name: "cart-storage" }
  )
)
```

## Examples

### Complete Feature: Product Card

```typescript
// types/product.ts
export interface Product {
  id: string
  name: string
  price: number
  imageUrl: string | null
}

// components/product-card.tsx
import Image from 'next/image'
import { Card } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'
import type { Product } from '@/types/product'

interface ProductCardProps {
  product: Product
  onAddToCart?: (product: Product) => void
  className?: string
}

export function ProductCard({ product, onAddToCart, className }: ProductCardProps) {
  return (
    <Card className={cn("overflow-hidden hover:shadow-lg transition-shadow", className)}>
      {product.imageUrl && (
        <div className="relative aspect-video">
          <Image
            src={product.imageUrl}
            alt={product.name}
            fill
            className="object-cover"
          />
        </div>
      )}
      <div className="p-4">
        <h3 className="font-semibold text-lg">{product.name}</h3>
        <div className="flex items-center justify-between mt-4">
          <span className="text-2xl font-bold">${product.price.toFixed(2)}</span>
          {onAddToCart && (
            <Button onClick={() => onAddToCart(product)}>
              Add to Cart
            </Button>
          )}
        </div>
      </div>
    </Card>
  )
}
```

## Best Practices

### ✅ Do

- Use Server Components by default
- Always use `cn()` for classNames
- Type everything with TypeScript
- Use absolute imports (`@/`)
- Co-locate tests with code
- Implement proper error handling
- Add loading states
- Use kebab-case for files
- Use PascalCase for components

### ❌ Don't

- Don't use hooks in Server Components
- Don't forget `'use client'` when needed
- Don't use `any` type
- Don't use inline styles
- Don't hardcode values
- Don't skip error boundaries
- Don't mix file naming conventions
- Don't create unnecessary Client Components

## Testing

All generated code includes test files:

```bash
# Run all tests
pnpm test

# Run tests in watch mode
pnpm test:watch

# Run tests with coverage
pnpm test:coverage

# Run tests with UI
pnpm test:ui
```

## Configuration

### Required Dependencies

Ensure your project has these dependencies:

```json
{
  "dependencies": {
    "next": "^14.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "@tanstack/react-query": "^5.0.0",
    "zustand": "^5.0.0",
    "zod": "^3.0.0",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.0.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "vitest": "^1.0.0",
    "@testing-library/react": "^14.0.0",
    "tailwindcss": "^4.0.0"
  }
}
```

### tsconfig.json

```json
{
  "compilerOptions": {
    "strict": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
```

## Troubleshooting

### Scripts not executable

```bash
chmod +x scripts/*.sh
```

### Import path issues

Ensure `tsconfig.json` has path aliases configured:

```json
{
  "compilerOptions": {
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
```

### Tests failing

Make sure testing setup is correct:

```bash
pnpm add -D vitest @testing-library/react @testing-library/jest-dom happy-dom
```

## Contributing

To enhance this plugin:

1. Add new patterns to `skills/nextjs-patterns/SKILL.md`
2. Create new scripts in `scripts/`
3. Add templates to `templates/`
4. Update this README
5. Test with real projects

## License

MIT

## Support

For issues or questions:
- Check the [SKILL.md](./skills/nextjs-patterns/SKILL.md) for pattern documentation
- Review existing scripts for examples
- Create an issue in the repository

---

**Version**: 1.0.0
**Author**: Shyju Viswambaran
**Last Updated**: December 2024
