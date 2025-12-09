#!/bin/bash
# Generate a new React component with TypeScript and tests

set -e

# Check if component name is provided
if [ -z "$1" ]; then
  echo "Error: Component name is required"
  echo "Usage: ./new-component.sh ComponentName [path]"
  echo "Example: ./new-component.sh Button components/ui"
  exit 1
fi

COMPONENT_NAME=$1
COMPONENT_PATH=${2:-"components"}
KEBAB_NAME=$(echo "$COMPONENT_NAME" | sed 's/\([A-Z]\)/-\1/g' | sed 's/^-//' | tr '[:upper:]' '[:lower:]')

# Determine if we're in a Next.js project
if [ ! -d "src" ]; then
  echo "Error: Must be run from Next.js project root (src directory not found)"
  exit 1
fi

FULL_PATH="src/${COMPONENT_PATH}"
COMPONENT_FILE="${FULL_PATH}/${KEBAB_NAME}.tsx"
TEST_FILE="${FULL_PATH}/__tests__/${KEBAB_NAME}.test.tsx"

# Create directories if they don't exist
mkdir -p "${FULL_PATH}/__tests__"

# Check if component already exists
if [ -f "$COMPONENT_FILE" ]; then
  echo "Error: Component already exists at $COMPONENT_FILE"
  exit 1
fi

# Determine if this should be a client component
read -p "Is this a client component? (y/N): " IS_CLIENT
USE_CLIENT=""
if [[ "$IS_CLIENT" =~ ^[Yy]$ ]]; then
  USE_CLIENT="'use client'\n\n"
fi

# Generate component file
cat > "$COMPONENT_FILE" << EOF
${USE_CLIENT}import { cn } from "@/lib/utils"

interface ${COMPONENT_NAME}Props {
  className?: string
  children?: React.ReactNode
}

export function ${COMPONENT_NAME}({ className, children }: ${COMPONENT_NAME}Props) {
  return (
    <div className={cn("", className)}>
      {children}
    </div>
  )
}
EOF

echo "✅ Created component: $COMPONENT_FILE"

# Generate test file
cat > "$TEST_FILE" << EOF
import { render, screen } from '@testing-library/react'
import { expect, test, describe } from 'vitest'
import { ${COMPONENT_NAME} } from '../${KEBAB_NAME}'

describe('${COMPONENT_NAME}', () => {
  test('renders children correctly', () => {
    render(<${COMPONENT_NAME}>Test content</${COMPONENT_NAME}>)
    expect(screen.getByText('Test content')).toBeInTheDocument()
  })

  test('applies custom className', () => {
    const { container } = render(<${COMPONENT_NAME} className="custom-class">Content</${COMPONENT_NAME}>)
    expect(container.firstChild).toHaveClass('custom-class')
  })
})
EOF

echo "✅ Created test: $TEST_FILE"

# Create index file if it doesn't exist
INDEX_FILE="${FULL_PATH}/index.ts"
if [ ! -f "$INDEX_FILE" ]; then
  cat > "$INDEX_FILE" << EOF
export * from './${KEBAB_NAME}'
EOF
  echo "✅ Created index: $INDEX_FILE"
else
  # Add export to existing index
  if ! grep -q "export.*${KEBAB_NAME}" "$INDEX_FILE"; then
    echo "export * from './${KEBAB_NAME}'" >> "$INDEX_FILE"
    echo "✅ Updated index: $INDEX_FILE"
  fi
fi

echo ""
echo "🎉 Component ${COMPONENT_NAME} created successfully!"
echo ""
echo "Next steps:"
echo "1. Edit: $COMPONENT_FILE"
echo "2. Write tests: $TEST_FILE"
echo "3. Run tests: pnpm test"
