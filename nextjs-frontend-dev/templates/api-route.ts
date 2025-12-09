import { NextRequest, NextResponse } from 'next/server'
import { z } from 'zod'

// Request validation schema
const requestSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  email: z.string().email('Invalid email'),
  // Add more fields
})

// GET - Fetch resources
export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const page = searchParams.get('page') || '1'
    const limit = searchParams.get('limit') || '10'

    // Fetch data from database or external API
    const data = [] // Replace with actual data fetching

    return NextResponse.json({
      data,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: 0,
      }
    })
  } catch (error) {
    console.error('GET error:', error)
    return NextResponse.json(
      { error: 'Failed to fetch resources' },
      { status: 500 }
    )
  }
}

// POST - Create resource
export async function POST(request: NextRequest) {
  try {
    const body = await request.json()

    // Validate request body
    const validatedData = requestSchema.parse(body)

    // Create resource in database
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
      { error: 'Failed to create resource' },
      { status: 500 }
    )
  }
}
