#!/bin/bash
# Generate a new Zustand store with TypeScript

set -e

# Check if store name is provided
if [ -z "$1" ]; then
  echo "Error: Store name is required"
  echo "Usage: ./new-store.sh store-name"
  echo "Example: ./new-store.sh cart"
  echo "Creates: src/stores/cart-store.ts"
  exit 1
fi

STORE_NAME=$1
KEBAB_NAME="${STORE_NAME}-store"

# Convert to PascalCase for type names
PASCAL_NAME=$(echo "$STORE_NAME" | sed 's/-\([a-z]\)/\U\1/g' | sed 's/^./\U&/')

# Determine if we're in a Next.js project
if [ ! -d "src" ]; then
  echo "Error: Must be run from Next.js project root (src directory not found)"
  exit 1
fi

STORE_DIR="src/stores"
STORE_FILE="${STORE_DIR}/${KEBAB_NAME}.ts"
TEST_FILE="${STORE_DIR}/__tests__/${KEBAB_NAME}.test.ts"

# Create directories
mkdir -p "${STORE_DIR}/__tests__"

# Check if store already exists
if [ -f "$STORE_FILE" ]; then
  echo "Error: Store already exists at $STORE_FILE"
  exit 1
fi

# Ask if persistence is needed
read -p "Enable localStorage persistence? (y/N): " PERSIST

# Generate store file
cat > "$STORE_FILE" << EOF
import { create } from 'zustand'
EOF

if [[ "$PERSIST" =~ ^[Yy]$ ]]; then
  cat >> "$STORE_FILE" << 'EOF'
import { persist } from 'zustand/middleware'
EOF
fi

cat >> "$STORE_FILE" << EOF

// Define your state interface
export interface ${PASCAL_NAME}Item {
  id: string
  // Add your fields here
}

interface ${PASCAL_NAME}State {
  items: ${PASCAL_NAME}Item[]
  // Actions
  addItem: (item: ${PASCAL_NAME}Item) => void
  removeItem: (id: string) => void
  clearItems: () => void
  // Computed values
  getItemCount: () => number
}

EOF

if [[ "$PERSIST" =~ ^[Yy]$ ]]; then
  cat >> "$STORE_FILE" << EOF
export const use${PASCAL_NAME}Store = create<${PASCAL_NAME}State>()(
  persist(
    (set, get) => ({
      items: [],
      addItem: (item) => {
        set((state) => ({
          items: [...state.items, item],
        }))
      },
      removeItem: (id) => {
        set((state) => ({
          items: state.items.filter((item) => item.id !== id),
        }))
      },
      clearItems: () => {
        set({ items: [] })
      },
      getItemCount: () => {
        return get().items.length
      },
    }),
    {
      name: '${STORE_NAME}-storage', // localStorage key
    }
  )
)
EOF
else
  cat >> "$STORE_FILE" << EOF
export const use${PASCAL_NAME}Store = create<${PASCAL_NAME}State>()((set, get) => ({
  items: [],
  addItem: (item) => {
    set((state) => ({
      items: [...state.items, item],
    }))
  },
  removeItem: (id) => {
    set((state) => ({
      items: state.items.filter((item) => item.id !== id),
    }))
  },
  clearItems: () => {
    set({ items: [] })
  },
  getItemCount: () => {
    return get().items.length
  },
}))
EOF
fi

echo "✅ Created store: $STORE_FILE"

# Generate test file
cat > "$TEST_FILE" << EOF
import { describe, it, expect, beforeEach } from 'vitest'
import { use${PASCAL_NAME}Store } from '../${KEBAB_NAME}'

describe('${PASCAL_NAME}Store', () => {
  beforeEach(() => {
    // Reset store before each test
    use${PASCAL_NAME}Store.getState().clearItems()
  })

  it('should initialize with empty items', () => {
    const { items } = use${PASCAL_NAME}Store.getState()
    expect(items).toEqual([])
  })

  it('should add item', () => {
    const testItem = { id: '1' }
    use${PASCAL_NAME}Store.getState().addItem(testItem)

    const { items } = use${PASCAL_NAME}Store.getState()
    expect(items).toHaveLength(1)
    expect(items[0]).toEqual(testItem)
  })

  it('should remove item by id', () => {
    const testItem = { id: '1' }
    use${PASCAL_NAME}Store.getState().addItem(testItem)
    use${PASCAL_NAME}Store.getState().removeItem('1')

    const { items } = use${PASCAL_NAME}Store.getState()
    expect(items).toHaveLength(0)
  })

  it('should clear all items', () => {
    use${PASCAL_NAME}Store.getState().addItem({ id: '1' })
    use${PASCAL_NAME}Store.getState().addItem({ id: '2' })
    use${PASCAL_NAME}Store.getState().clearItems()

    const { items } = use${PASCAL_NAME}Store.getState()
    expect(items).toHaveLength(0)
  })

  it('should get item count', () => {
    use${PASCAL_NAME}Store.getState().addItem({ id: '1' })
    use${PASCAL_NAME}Store.getState().addItem({ id: '2' })

    const count = use${PASCAL_NAME}Store.getState().getItemCount()
    expect(count).toBe(2)
  })
})
EOF

echo "✅ Created test: $TEST_FILE"

echo ""
echo "🎉 Zustand store created successfully!"
echo ""
echo "Store: use${PASCAL_NAME}Store"
echo "File: $STORE_FILE"
echo "Tests: $TEST_FILE"
if [[ "$PERSIST" =~ ^[Yy]$ ]]; then
  echo "Persistence: Enabled (localStorage key: ${STORE_NAME}-storage)"
fi
echo ""
echo "Next steps:"
echo "1. Customize your state interface in $STORE_FILE"
echo "2. Add more actions and computed values"
echo "3. Write comprehensive tests in $TEST_FILE"
echo "4. Use in components: const { items, addItem } = use${PASCAL_NAME}Store()"
echo "5. Run tests: pnpm test"
