#!/bin/bash
# Generate a new Next.js API route with tests

set -e

# Check if route name is provided
if [ -z "$1" ]; then
  echo "Error: Route name is required"
  echo "Usage: ./new-api-route.sh route-name"
  echo "Example: ./new-api-route.sh categories"
  echo "Creates: src/app/api/categories/route.ts"
  exit 1
fi

ROUTE_NAME=$1

# Determine if we're in a Next.js project
if [ ! -d "src/app" ]; then
  echo "Error: Must be run from Next.js project root (src/app directory not found)"
  exit 1
fi

ROUTE_DIR="src/app/api/${ROUTE_NAME}"
ROUTE_FILE="${ROUTE_DIR}/route.ts"
TEST_FILE="${ROUTE_DIR}/__tests__/route.test.ts"

# Create directories
mkdir -p "${ROUTE_DIR}/__tests__"

# Check if route already exists
if [ -f "$ROUTE_FILE" ]; then
  echo "Error: API route already exists at $ROUTE_FILE"
  exit 1
fi

# Ask for HTTP methods
echo "Select HTTP methods to implement (space-separated):"
echo "1) GET"
echo "2) POST"
echo "3) PUT"
echo "4) DELETE"
echo "5) PATCH"
read -p "Enter numbers (e.g., '1 2' for GET and POST): " METHODS

# Generate route file
cat > "$ROUTE_FILE" << 'ROUTE_START'
import { NextRequest, NextResponse } from 'next/server'
import { z } from 'zod'

ROUTE_START

# Add GET method if selected
if echo "$METHODS" | grep -q "1"; then
  cat >> "$ROUTE_FILE" << 'GET_METHOD'
// GET - Fetch records
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)

    // Add your fetch logic here
    const data = [] // Replace with actual data fetching

    return NextResponse.json(data)
  } catch (error) {
    console.error('GET error:', error)
    return NextResponse.json(
      { error: 'Failed to fetch data' },
      { status: 500 }
    )
  }
}

GET_METHOD
fi

# Add POST method if selected
if echo "$METHODS" | grep -q "2"; then
  cat >> "$ROUTE_FILE" << 'POST_METHOD'
// Validation schema
const createSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  // Add more fields as needed
})

// POST - Create new record
export async function POST(request: NextRequest) {
  try {
    const body = await request.json()

    // Validate request body
    const validatedData = createSchema.parse(body)

    // Add your creation logic here
    const created = validatedData // Replace with actual creation

    return NextResponse.json(created, { status: 201 })
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Validation failed', details: error.errors },
        { status: 400 }
      )
    }
    console.error('POST error:', error)
    return NextResponse.json(
      { error: 'Failed to create record' },
      { status: 500 }
    )
  }
}

POST_METHOD
fi

# Add PUT method if selected
if echo "$METHODS" | grep -q "3"; then
  cat >> "$ROUTE_FILE" << 'PUT_METHOD'
// PUT - Update record
export async function PUT(request: NextRequest) {
  try {
    const body = await request.json()

    // Add your update logic here
    const updated = body // Replace with actual update

    return NextResponse.json(updated)
  } catch (error) {
    console.error('PUT error:', error)
    return NextResponse.json(
      { error: 'Failed to update record' },
      { status: 500 }
    )
  }
}

PUT_METHOD
fi

# Add DELETE method if selected
if echo "$METHODS" | grep -q "4"; then
  cat >> "$ROUTE_FILE" << 'DELETE_METHOD'
// DELETE - Delete record
export async function DELETE(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const id = searchParams.get('id')

    if (!id) {
      return NextResponse.json(
        { error: 'ID is required' },
        { status: 400 }
      )
    }

    // Add your deletion logic here

    return NextResponse.json({ success: true })
  } catch (error) {
    console.error('DELETE error:', error)
    return NextResponse.json(
      { error: 'Failed to delete record' },
      { status: 500 }
    )
  }
}

DELETE_METHOD
fi

# Add PATCH method if selected
if echo "$METHODS" | grep -q "5"; then
  cat >> "$ROUTE_FILE" << 'PATCH_METHOD'
// PATCH - Partial update
export async function PATCH(request: NextRequest) {
  try {
    const body = await request.json()

    // Add your partial update logic here
    const updated = body // Replace with actual update

    return NextResponse.json(updated)
  } catch (error) {
    console.error('PATCH error:', error)
    return NextResponse.json(
      { error: 'Failed to update record' },
      { status: 500 }
    )
  }
}

PATCH_METHOD
fi

echo "✅ Created API route: $ROUTE_FILE"

# Generate test file
cat > "$TEST_FILE" << 'EOF'
import { describe, it, expect, vi } from 'vitest'
import { NextRequest } from 'next/server'
import { GET, POST } from '../route'

describe('API Route Tests', () => {
  describe('GET', () => {
    it('should return data successfully', async () => {
      const request = new NextRequest('http://localhost:3000/api/${ROUTE_NAME}')
      const response = await GET(request)
      const data = await response.json()

      expect(response.status).toBe(200)
      expect(Array.isArray(data)).toBe(true)
    })
  })

  describe('POST', () => {
    it('should create record with valid data', async () => {
      const request = new NextRequest('http://localhost:3000/api/${ROUTE_NAME}', {
        method: 'POST',
        body: JSON.stringify({ name: 'Test' }),
      })

      const response = await POST(request)
      const data = await response.json()

      expect(response.status).toBe(201)
      expect(data).toHaveProperty('name', 'Test')
    })

    it('should validate request body', async () => {
      const request = new NextRequest('http://localhost:3000/api/${ROUTE_NAME}', {
        method: 'POST',
        body: JSON.stringify({ name: '' }), // Invalid
      })

      const response = await POST(request)

      expect(response.status).toBe(400)
    })
  })
})
EOF

# Replace ${ROUTE_NAME} in test file
sed -i.bak "s/\${ROUTE_NAME}/${ROUTE_NAME}/g" "$TEST_FILE"
rm "${TEST_FILE}.bak"

echo "✅ Created test: $TEST_FILE"

echo ""
echo "🎉 API route created successfully!"
echo ""
echo "Route: /api/${ROUTE_NAME}"
echo "File: $ROUTE_FILE"
echo "Tests: $TEST_FILE"
echo ""
echo "Next steps:"
echo "1. Implement your business logic in $ROUTE_FILE"
echo "2. Update Zod schemas for validation"
echo "3. Write comprehensive tests in $TEST_FILE"
echo "4. Run tests: pnpm test"
