---
name: nextjs-patterns
description: Modern Next.js frontend development patterns with TypeScript, Tailwind CSS v4, shadcn/ui, TanStack Query, and Zustand
version: 1.0.0
---

# Next.js Frontend Development Patterns

This skill provides comprehensive guidance for building modern Next.js applications following production-ready patterns and best practices.

## Technology Stack

- **Next.js**: 14/15/16+ with App Router (NOT Pages Router)
- **React**: 18/19+ with Server and Client Components
- **TypeScript**: Strict mode with comprehensive typing
- **Styling**: Tailwind CSS v4 with utility-first approach
- **Components**: shadcn/ui (Radix UI primitives)
- **State Management**: Zustand with persist middleware
- **Data Fetching**: TanStack Query (React Query)
- **Validation**: Zod schemas
- **Package Manager**: pnpm preferred

## Core Principles

### 1. Server Components First

**By default, all components are Server Components**. Only add 'use client' when necessary:

✅ **Use Server Components for:**
- Pages that fetch data
- Static content
- Layouts
- Components that don't need interactivity

✅ **Use Client Components for:**
- Interactive elements (onClick, onChange, etc.)
- React hooks (useState, useEffect, etc.)
- Browser APIs (localStorage, window, etc.)
- Event listeners
- Third-party libraries that require client-side

**Example Server Component:**
```typescript
// app/(main)/page.tsx
import { HeroSection } from "@/components/hero-section";
import { FavoritesSection } from "@/components/main/favorites-section";

export default function Home() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-orange-50/30 via-white to-red-50/20">
      <HeroSection />
      <FavoritesSection />
    </div>
  );
}
```

**Example Client Component:**
```typescript
// components/ui/button-with-state.tsx
'use client'

import { useState } from 'react'
import { Button } from '@/components/ui/button'

export function Counter() {
  const [count, setCount] = useState(0)

  return (
    <Button onClick={() => setCount(c => c + 1)}>
      Count: {count}
    </Button>
  )
}
```

### 2. The cn() Utility Pattern

**ALWAYS use the `cn()` utility for className management**:

```typescript
// lib/utils.ts (standard implementation)
import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

**Usage patterns:**

```typescript
import { cn } from "@/lib/utils"

// Basic usage
<div className={cn("p-4 rounded-md", className)} />

// Conditional classes
<div className={cn(
  "base-class",
  isActive && "active-class",
  isDisabled && "disabled-class"
)} />

// Variant-based classes with props
<div className={cn(
  "base-class",
  variant === "primary" && "bg-primary text-white",
  variant === "secondary" && "bg-secondary text-gray-900"
)} />
```

### 3. Project Structure

```
src/
├── app/
│   ├── layout.tsx              # Root layout
│   ├── page.tsx                # Home page
│   ├── globals.css             # Global styles
│   ├── (main)/                 # Route group for main site
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   ├── menu/
│   │   │   ├── page.tsx
│   │   │   └── components/     # Page-specific components
│   │   └── cart/
│   │       └── page.tsx
│   └── api/                    # API routes
│       ├── health/
│       │   ├── route.ts
│       │   └── __tests__/
│       │       └── route.test.ts
│       └── locations/
│           └── route.ts
├── components/
│   ├── ui/                     # shadcn/ui components
│   │   ├── button.tsx
│   │   ├── card.tsx
│   │   ├── dialog.tsx
│   │   └── __tests__/
│   ├── menu/                   # Feature-specific components
│   ├── cart/
│   └── providers/              # Context providers
├── hooks/                      # Custom React hooks
│   ├── use-categories.ts
│   ├── use-menu-items.ts
│   └── __tests__/
├── stores/                     # Zustand stores
│   ├── cart-store.ts
│   ├── location-store.ts
│   └── __tests__/
├── lib/
│   ├── utils.ts               # cn() and other utilities
│   ├── api/                   # API client functions
│   │   ├── types.ts
│   │   └── __tests__/
│   └── __tests__/
├── types/                     # TypeScript type definitions
│   └── tenant.ts
├── config/                    # App configuration
├── actions/                   # Server actions
└── styles/                    # Additional styles
```

**Key conventions:**
- Use route groups `(name)` for logical grouping without affecting URLs
- Co-locate tests with `__tests__/` directories
- Keep page-specific components near the page
- Use absolute imports with `@/` prefix

### 4. Component Patterns

#### A. shadcn/ui Button Component

```typescript
// components/ui/button.tsx
import * as React from "react";
import { Slot } from "@radix-ui/react-slot";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";

const buttonVariants = cva(
  "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 cursor-pointer [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground shadow-sm hover:bg-primary/90",
        destructive: "bg-destructive text-destructive-foreground shadow-xs hover:bg-destructive/90",
        outline: "border border-input bg-background shadow-xs hover:bg-accent hover:text-accent-foreground",
        secondary: "bg-secondary text-secondary-foreground shadow-xs hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        default: "h-9 px-4 py-2",
        sm: "h-8 rounded-md px-3 text-xs",
        lg: "h-10 rounded-md px-8",
        icon: "h-9 w-9",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
);

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  asChild?: boolean;
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, ...props }, ref) => {
    const Comp = asChild ? Slot : "button";
    return (
      <Comp
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    );
  }
);
Button.displayName = "Button";

export { Button, buttonVariants };
```

**Key patterns:**
- Use `class-variance-authority` for variant management
- Always use `React.forwardRef` for ref forwarding
- Export both component and variants
- Use `asChild` prop for polymorphic components
- Always use `cn()` for className merging

#### B. Extending shadcn/ui Components

```typescript
// components/ui/button.tsx (with loading state)
export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  asChild?: boolean;
  isLoading?: boolean;
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, isLoading, children, disabled, ...props }, ref) => {
    const Comp = asChild ? Slot : "button";
    return (
      <Comp
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        disabled={disabled || isLoading}
        {...props}
      >
        {isLoading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
        {children}
      </Comp>
    );
  }
);
```

### 5. Data Fetching Patterns

#### A. TanStack Query (Client-Side)

```typescript
// hooks/use-categories.ts
"use client";

import { useQuery } from "@tanstack/react-query";
import type { Category } from "@/lib/api/types";

export function useCategories(brandName?: string, locationSlug?: string, menuSlug?: string) {
  return useQuery<Category[]>({
    queryKey: ["categories", brandName, locationSlug, menuSlug],
    queryFn: async () => {
      const params = new URLSearchParams();
      if (brandName) params.append('brandName', brandName);
      if (locationSlug) params.append('locationSlug', locationSlug);
      if (menuSlug) params.append('menuSlug', menuSlug);

      const queryString = params.toString();
      const endpoint = queryString ? `/api/categories?${queryString}` : '/api/categories';

      const response = await fetch(endpoint);
      if (!response.ok) {
        throw new Error('Failed to fetch categories');
      }
      return response.json();
    },
    staleTime: 5 * 60 * 1000, // 5 minutes
    gcTime: 10 * 60 * 1000, // 10 minutes
  });
}

export function useCategoryBySlug(slug: string) {
  return useQuery<Category>({
    queryKey: ["category", "slug", slug],
    queryFn: async () => {
      const response = await fetch(`/api/categories/slug/${slug}`);
      if (!response.ok) {
        throw new Error('Failed to fetch category');
      }
      return response.json();
    },
    enabled: !!slug, // Only run query if slug exists
    staleTime: 5 * 60 * 1000,
    gcTime: 10 * 60 * 1000,
  });
}
```

**Key patterns:**
- Always mark data-fetching hooks with `'use client'`
- Use descriptive `queryKey` arrays for caching
- Set appropriate `staleTime` and `gcTime` (formerly `cacheTime`)
- Use `enabled` option for conditional queries
- Handle errors with proper error messages
- Type the return data with TypeScript

#### B. Query Provider Setup

```typescript
// components/providers/query-provider.tsx
'use client'

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'
import { useState } from 'react'

export function QueryProvider({ children }: { children: React.ReactNode }) {
  const [queryClient] = useState(
    () => new QueryClient({
      defaultOptions: {
        queries: {
          staleTime: 60 * 1000, // 1 minute
          gcTime: 5 * 60 * 1000, // 5 minutes
        },
      },
    })
  )

  return (
    <QueryClientProvider client={queryClient}>
      {children}
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  )
}
```

### 6. State Management with Zustand

```typescript
// stores/cart-store.ts
import { create } from "zustand";
import { persist } from "zustand/middleware";
import { MenuItem, MenuItemDetailProtein, MenuItemModification } from "@/lib/types";

export interface CartItem {
  id: string;
  menuItem: MenuItem;
  quantity: number;
  selectedProtein: MenuItemDetailProtein | null;
  selectedModifications?: MenuItemModification[];
  totalPrice: number;
  spiceLevel: string | null;
  specialInstructions: string;
}

interface CartState {
  items: CartItem[];
  addItem: (
    menuItem: MenuItem,
    selectedProtein: MenuItemDetailProtein | null,
    spiceLevel?: string | null,
    specialInstructions?: string,
    quantity?: number,
    selectedModifications?: MenuItemModification[]
  ) => void;
  removeItem: (id: string) => void;
  updateQuantity: (id: string, quantity: number) => void;
  clearCart: () => void;
  getTotalItems: () => number;
  getTotalPrice: () => number;
}

export const useCartStore = create<CartState>()(
  persist(
    (set, get) => ({
      items: [],
      addItem: (menuItem, selectedProtein, spiceLevel = null, specialInstructions = "", quantity = 1, selectedModifications = []) => {
        const { items } = get();
        const itemId = `${menuItem.id}-${selectedProtein?.name || "base"}-${Date.now()}`;

        // Calculate price with modifications
        const modificationsTotal = selectedModifications.reduce(
          (sum, mod) => sum + mod.additionalCost,
          0
        );
        const itemPrice =
          menuItem.price +
          (selectedProtein?.additionalCost || 0) +
          modificationsTotal;

        set({
          items: [
            ...items,
            {
              id: itemId,
              menuItem,
              selectedProtein,
              selectedModifications,
              spiceLevel,
              specialInstructions,
              quantity,
              totalPrice: itemPrice * quantity,
            },
          ],
        });
      },
      removeItem: (id) => {
        set((state) => ({
          items: state.items.filter((item) => item.id !== id),
        }));
      },
      updateQuantity: (id, quantity) => {
        set((state) => ({
          items: state.items.map((item) => {
            if (item.id === id) {
              const modificationsTotal = (item.selectedModifications || []).reduce(
                (sum, mod) => sum + mod.additionalCost,
                0
              );
              const price =
                item.menuItem.price +
                (item.selectedProtein?.additionalCost || 0) +
                modificationsTotal;

              return {
                ...item,
                quantity,
                totalPrice: price * quantity,
              };
            }
            return item;
          }),
        }));
      },
      clearCart: () => {
        set({ items: [] });
      },
      getTotalItems: () => {
        return get().items.reduce((total, item) => total + item.quantity, 0);
      },
      getTotalPrice: () => {
        return get().items.reduce((total, item) => total + item.totalPrice, 0);
      },
    }),
    {
      name: "cart-storage", // localStorage key
    }
  )
);
```

**Key patterns:**
- Use TypeScript interfaces for state and actions
- Use `persist` middleware for localStorage persistence
- Expose computed values as functions (getTotalItems, getTotalPrice)
- Handle optional properties for backward compatibility
- Use immutable state updates
- Calculate derived values on the fly

### 7. TypeScript Patterns

#### A. Strict Type Definitions

```typescript
// types/menu.ts
export interface MenuItem {
  id: string;
  name: string;
  description: string | null;
  price: number;
  imageUrl: string | null;
  category: Category;
  proteins?: MenuItemDetailProtein[];
  modifications?: MenuItemModification[];
}

export interface MenuItemDetailProtein {
  id: string;
  name: string;
  additionalCost: number;
}

export interface MenuItemModification {
  id: string;
  name: string;
  additionalCost: number;
}

export interface Category {
  id: string;
  name: string;
  description: string | null;
  slug: string;
  imageUrl: string | null;
}
```

**Key patterns:**
- Use `interface` for object shapes
- Use `type` for unions, intersections, and utilities
- Always type function parameters and return values
- Use `null` instead of `undefined` for optional backend data
- Use `?` for optional properties

#### B. Component Props Typing

```typescript
import { ReactNode } from 'react'

// Inline props
export function Card({ children, className }: {
  children: ReactNode
  className?: string
}) {
  return <div className={cn("rounded-lg border p-4", className)}>{children}</div>
}

// Separate interface (preferred for complex props)
interface CardProps {
  children: ReactNode
  className?: string
  variant?: 'default' | 'outlined' | 'elevated'
  onClick?: () => void
}

export function Card({ children, className, variant = 'default', onClick }: CardProps) {
  return (
    <div
      className={cn("rounded-lg p-4", variantClasses[variant], className)}
      onClick={onClick}
    >
      {children}
    </div>
  )
}
```

### 8. Tailwind CSS Patterns

#### A. Responsive Design

```typescript
// Mobile-first approach
<div className="
  grid
  grid-cols-1          /* Mobile: 1 column */
  md:grid-cols-2       /* Tablet: 2 columns */
  lg:grid-cols-3       /* Desktop: 3 columns */
  xl:grid-cols-4       /* Large desktop: 4 columns */
  gap-4 md:gap-6       /* Responsive gaps */
">
  {items.map(item => <ItemCard key={item.id} {...item} />)}
</div>
```

#### B. Dark Mode Support

```typescript
<div className="
  bg-white dark:bg-slate-900
  text-slate-900 dark:text-slate-100
  border border-gray-200 dark:border-gray-800
">
  Content
</div>
```

#### C. Animation and Transitions

```typescript
<div className="
  transition-all
  duration-300
  ease-in-out
  hover:scale-105
  hover:shadow-lg
  active:scale-95
">
  Animated content
</div>
```

#### D. Gradient Backgrounds

```typescript
<div className="min-h-screen bg-gradient-to-b from-orange-50/30 via-white to-red-50/20">
  Content
</div>
```

### 9. API Routes Pattern

```typescript
// app/api/categories/route.ts
import { NextRequest, NextResponse } from 'next/server';

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const brandName = searchParams.get('brandName');
    const locationSlug = searchParams.get('locationSlug');

    // Fetch data from backend or database
    const categories = await fetchCategories({ brandName, locationSlug });

    return NextResponse.json(categories);
  } catch (error) {
    console.error('Failed to fetch categories:', error);
    return NextResponse.json(
      { error: 'Failed to fetch categories' },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    // Validate with Zod
    const validatedData = categorySchema.parse(body);

    // Create category
    const category = await createCategory(validatedData);

    return NextResponse.json(category, { status: 201 });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Validation failed', details: error.errors },
        { status: 400 }
      );
    }
    return NextResponse.json(
      { error: 'Failed to create category' },
      { status: 500 }
    );
  }
}
```

### 10. Testing Patterns

#### A. Component Tests with Vitest

```typescript
// components/ui/__tests__/button.test.tsx
import { render, screen } from '@testing-library/react'
import { expect, test } from 'vitest'
import { Button } from '../button'

test('renders button with text', () => {
  render(<Button>Click me</Button>)
  expect(screen.getByRole('button', { name: /click me/i })).toBeInTheDocument()
})

test('applies variant classes correctly', () => {
  render(<Button variant="destructive">Delete</Button>)
  const button = screen.getByRole('button')
  expect(button).toHaveClass('bg-destructive')
})
```

#### B. API Route Tests

```typescript
// app/api/health/__tests__/route.test.ts
import { describe, it, expect } from 'vitest'
import { GET } from '../route'

describe('Health Check API', () => {
  it('returns healthy status', async () => {
    const response = await GET()
    const data = await response.json()

    expect(response.status).toBe(200)
    expect(data).toEqual({ status: 'healthy' })
  })
})
```

## Common Decision Trees

### When to use Server vs Client Component?

```
Does the component need interactivity or browser APIs?
├─ YES → Use Client Component ('use client')
│   └─ Examples: forms, modals, dropdowns, state management
└─ NO → Use Server Component (default)
    └─ Examples: layouts, static content, data display
```

### When to use TanStack Query vs Direct Fetch?

```
Is this client-side data fetching?
├─ YES → Use TanStack Query (React Query)
│   └─ Benefits: caching, refetching, loading states
└─ NO → Use direct fetch in Server Component
    └─ Benefits: faster initial load, SEO-friendly
```

### When to use Zustand vs Context API?

```
Do you need persistence or complex state logic?
├─ YES → Use Zustand
│   └─ Examples: cart, user preferences, auth state
└─ NO → Use Context API
    └─ Examples: theme, locale, simple flags
```

## Code Quality Checklist

When generating code, ensure:

- [ ] Server Components by default (no unnecessary 'use client')
- [ ] Always use `cn()` for className management
- [ ] Proper TypeScript types (no `any`)
- [ ] Responsive design (mobile-first)
- [ ] Accessibility (semantic HTML, ARIA labels)
- [ ] Error handling (try-catch, error boundaries)
- [ ] Loading states for async operations
- [ ] Proper file naming (kebab-case)
- [ ] Component exports use named exports
- [ ] Absolute imports with `@/` prefix

## Anti-Patterns to Avoid

❌ **Don't:**
- Use hooks in Server Components
- Forget 'use client' directive when needed
- Use inline styles instead of Tailwind
- Use `any` type in TypeScript
- Hardcode values that should be configurable
- Create unnecessary Client Components
- Forget error boundaries
- Skip loading states
- Use relative imports for cross-directory imports
- Mix camelCase and kebab-case file naming

✅ **Do:**
- Keep components small and focused
- Use Server Components when possible
- Leverage TypeScript for type safety
- Use cn() for all className logic
- Implement proper error handling
- Add loading states for better UX
- Use absolute imports with @/ prefix
- Follow kebab-case for files, PascalCase for components

## Example: Complete Feature Implementation

**Scenario:** Create a menu item card component

```typescript
// types/menu.ts
export interface MenuItem {
  id: string
  name: string
  description: string | null
  price: number
  imageUrl: string | null
}

// components/menu/menu-item-card.tsx
import Image from 'next/image'
import { Card } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { cn } from '@/lib/utils'
import type { MenuItem } from '@/types/menu'

interface MenuItemCardProps {
  item: MenuItem
  onAddToCart?: (item: MenuItem) => void
  className?: string
}

export function MenuItemCard({ item, onAddToCart, className }: MenuItemCardProps) {
  return (
    <Card className={cn("overflow-hidden transition-shadow hover:shadow-lg", className)}>
      {item.imageUrl && (
        <div className="relative aspect-video w-full">
          <Image
            src={item.imageUrl}
            alt={item.name}
            fill
            className="object-cover"
          />
        </div>
      )}
      <div className="p-4 space-y-2">
        <h3 className="text-lg font-semibold">{item.name}</h3>
        {item.description && (
          <p className="text-sm text-muted-foreground line-clamp-2">
            {item.description}
          </p>
        )}
        <div className="flex items-center justify-between pt-2">
          <span className="text-xl font-bold">${item.price.toFixed(2)}</span>
          {onAddToCart && (
            <Button onClick={() => onAddToCart(item)} size="sm">
              Add to Cart
            </Button>
          )}
        </div>
      </div>
    </Card>
  )
}

// app/(main)/menu/page.tsx
import { MenuItemCard } from '@/components/menu/menu-item-card'

export default function MenuPage() {
  // Server-side data fetching
  const menuItems = await fetchMenuItems()

  return (
    <div className="container mx-auto py-8">
      <h1 className="text-3xl font-bold mb-6">Our Menu</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {menuItems.map(item => (
          <MenuItemCard key={item.id} item={item} />
        ))}
      </div>
    </div>
  )
}
```

## Summary

This skill enforces modern Next.js development patterns focused on:
1. **Server-first architecture** - Leverage Server Components
2. **Type safety** - Comprehensive TypeScript usage
3. **Modern styling** - Tailwind CSS v4 with cn() utility
4. **Component libraries** - shadcn/ui patterns
5. **State management** - Zustand for complex state, Context for simple cases
6. **Data fetching** - TanStack Query for client, direct fetch for server
7. **Testing** - Vitest for unit and integration tests
8. **Code quality** - Consistent patterns, proper error handling

When generating Next.js code, always refer to these patterns to ensure consistency, maintainability, and production-readiness.
