#!/bin/bash
# Generate a new custom React hook with TanStack Query

set -e

# Check if hook name is provided
if [ -z "$1" ]; then
  echo "Error: Hook name is required"
  echo "Usage: ./new-hook.sh hook-name [type]"
  echo "Types: query (default), mutation, state"
  echo "Example: ./new-hook.sh use-categories query"
  exit 1
fi

HOOK_NAME=$1
HOOK_TYPE=${2:-"query"}

# Validate hook type
if [[ ! "$HOOK_TYPE" =~ ^(query|mutation|state)$ ]]; then
  echo "Error: Invalid hook type. Must be: query, mutation, or state"
  exit 1
fi

# Ensure hook name starts with 'use-'
if [[ ! "$HOOK_NAME" =~ ^use- ]]; then
  HOOK_NAME="use-${HOOK_NAME}"
fi

# Determine if we're in a Next.js project
if [ ! -d "src" ]; then
  echo "Error: Must be run from Next.js project root (src directory not found)"
  exit 1
fi

HOOKS_DIR="src/hooks"
HOOK_FILE="${HOOKS_DIR}/${HOOK_NAME}.ts"
TEST_FILE="${HOOKS_DIR}/__tests__/${HOOK_NAME}.test.ts"

# Create directories
mkdir -p "${HOOKS_DIR}/__tests__"

# Check if hook already exists
if [ -f "$HOOK_FILE" ]; then
  echo "Error: Hook already exists at $HOOK_FILE"
  exit 1
fi

# Convert kebab-case to camelCase for function name
CAMEL_NAME=$(echo "$HOOK_NAME" | sed 's/-\([a-z]\)/\U\1/g')

# Generate hook file based on type
if [ "$HOOK_TYPE" == "query" ]; then
  cat > "$HOOK_FILE" << 'EOF'
"use client";

import { useQuery } from "@tanstack/react-query";

// Define your data type
interface DataType {
  id: string;
  // Add your fields here
}

export function CAMEL_NAME(id?: string) {
  return useQuery<DataType[]>({
    queryKey: ["resource-name", id],
    queryFn: async () => {
      const params = new URLSearchParams();
      if (id) params.append('id', id);

      const queryString = params.toString();
      const endpoint = queryString ? `/api/endpoint?${queryString}` : '/api/endpoint';

      const response = await fetch(endpoint);
      if (!response.ok) {
        throw new Error('Failed to fetch data');
      }
      return response.json();
    },
    enabled: !!id, // Only run if id exists
    staleTime: 5 * 60 * 1000, // 5 minutes
    gcTime: 10 * 60 * 1000, // 10 minutes
  });
}
EOF
elif [ "$HOOK_TYPE" == "mutation" ]; then
  cat > "$HOOK_FILE" << 'EOF'
"use client";

import { useMutation, useQueryClient } from "@tanstack/react-query";

// Define your input type
interface CreateInput {
  name: string;
  // Add your fields here
}

// Define your response type
interface CreateResponse {
  id: string;
  name: string;
}

export function CAMEL_NAME() {
  const queryClient = useQueryClient();

  return useMutation<CreateResponse, Error, CreateInput>({
    mutationFn: async (data) => {
      const response = await fetch('/api/endpoint', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        throw new Error('Failed to create resource');
      }

      return response.json();
    },
    onSuccess: () => {
      // Invalidate and refetch related queries
      queryClient.invalidateQueries({ queryKey: ['resource-name'] });
    },
    onError: (error) => {
      console.error('Mutation error:', error);
    },
  });
}
EOF
else # state hook
  cat > "$HOOK_FILE" << 'EOF'
"use client";

import { useState, useEffect } from 'react';

export function CAMEL_NAME<T>(initialValue: T) {
  const [value, setValue] = useState<T>(initialValue);

  // Add your custom logic here

  return {
    value,
    setValue,
  };
}
EOF
fi

# Replace CAMEL_NAME with actual name
sed -i.bak "s/CAMEL_NAME/${CAMEL_NAME}/g" "$HOOK_FILE"
rm "${HOOK_FILE}.bak"

echo "✅ Created hook: $HOOK_FILE"

# Generate test file
if [ "$HOOK_TYPE" == "query" ]; then
  cat > "$TEST_FILE" << 'EOF'
import { describe, it, expect, beforeEach, vi } from 'vitest'
import { renderHook, waitFor } from '@testing-library/react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { CAMEL_NAME } from '../HOOK_NAME'

const createWrapper = () => {
  const queryClient = new QueryClient({
    defaultOptions: {
      queries: { retry: false },
    },
  })
  return ({ children }: { children: React.ReactNode }) => (
    <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
  )
}

describe('CAMEL_NAME', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('should fetch data successfully', async () => {
    // Mock fetch
    global.fetch = vi.fn(() =>
      Promise.resolve({
        ok: true,
        json: () => Promise.resolve([{ id: '1' }]),
      } as Response)
    )

    const { result } = renderHook(() => CAMEL_NAME('1'), {
      wrapper: createWrapper(),
    })

    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    expect(result.current.data).toEqual([{ id: '1' }])
  })

  it('should handle errors', async () => {
    global.fetch = vi.fn(() =>
      Promise.resolve({
        ok: false,
      } as Response)
    )

    const { result } = renderHook(() => CAMEL_NAME('1'), {
      wrapper: createWrapper(),
    })

    await waitFor(() => expect(result.current.isError).toBe(true))
  })
})
EOF
elif [ "$HOOK_TYPE" == "mutation" ]; then
  cat > "$TEST_FILE" << 'EOF'
import { describe, it, expect, beforeEach, vi } from 'vitest'
import { renderHook, waitFor } from '@testing-library/react'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { CAMEL_NAME } from '../HOOK_NAME'

const createWrapper = () => {
  const queryClient = new QueryClient({
    defaultOptions: {
      mutations: { retry: false },
    },
  })
  return ({ children }: { children: React.ReactNode }) => (
    <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
  )
}

describe('CAMEL_NAME', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('should create resource successfully', async () => {
    global.fetch = vi.fn(() =>
      Promise.resolve({
        ok: true,
        json: () => Promise.resolve({ id: '1', name: 'Test' }),
      } as Response)
    )

    const { result } = renderHook(() => CAMEL_NAME(), {
      wrapper: createWrapper(),
    })

    result.current.mutate({ name: 'Test' })

    await waitFor(() => expect(result.current.isSuccess).toBe(true))
    expect(result.current.data).toEqual({ id: '1', name: 'Test' })
  })
})
EOF
else # state hook
  cat > "$TEST_FILE" << 'EOF'
import { describe, it, expect } from 'vitest'
import { renderHook, act } from '@testing-library/react'
import { CAMEL_NAME } from '../HOOK_NAME'

describe('CAMEL_NAME', () => {
  it('should initialize with provided value', () => {
    const { result } = renderHook(() => CAMEL_NAME('initial'))
    expect(result.current.value).toBe('initial')
  })

  it('should update value', () => {
    const { result } = renderHook(() => CAMEL_NAME('initial'))

    act(() => {
      result.current.setValue('updated')
    })

    expect(result.current.value).toBe('updated')
  })
})
EOF
fi

# Replace placeholders in test file
sed -i.bak "s/CAMEL_NAME/${CAMEL_NAME}/g" "$TEST_FILE"
sed -i.bak "s/HOOK_NAME/${HOOK_NAME}/g" "$TEST_FILE"
rm "${TEST_FILE}.bak"

echo "✅ Created test: $TEST_FILE"

echo ""
echo "🎉 Custom hook created successfully!"
echo ""
echo "Hook: ${CAMEL_NAME}"
echo "Type: ${HOOK_TYPE}"
echo "File: $HOOK_FILE"
echo "Tests: $TEST_FILE"
echo ""
echo "Next steps:"
echo "1. Customize your hook logic in $HOOK_FILE"
echo "2. Update types and interfaces"
echo "3. Write comprehensive tests in $TEST_FILE"
echo "4. Use in components: const { data, isLoading } = ${CAMEL_NAME}()"
echo "5. Run tests: pnpm test"
