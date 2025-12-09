'use client'

import { useState } from 'react'
import { cn } from "@/lib/utils"

interface ComponentNameProps {
  className?: string
  initialValue?: string
  onValueChange?: (value: string) => void
}

/**
 * ComponentName - Client component with interactivity
 *
 * @example
 * ```tsx
 * <ComponentName
 *   initialValue="hello"
 *   onValueChange={(v) => console.log(v)}
 * />
 * ```
 */
export function ComponentName({
  className,
  initialValue = '',
  onValueChange
}: ComponentNameProps) {
  const [value, setValue] = useState(initialValue)

  const handleChange = (newValue: string) => {
    setValue(newValue)
    onValueChange?.(newValue)
  }

  return (
    <div className={cn("", className)}>
      {/* Your interactive UI here */}
    </div>
  )
}
