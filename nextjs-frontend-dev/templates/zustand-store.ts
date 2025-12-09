import { create } from 'zustand'
import { persist } from 'zustand/middleware'

// Types
export interface Item {
  id: string
  name: string
  // Add your fields
}

interface StoreState {
  // State
  items: Item[]
  selectedId: string | null

  // Actions
  addItem: (item: Item) => void
  removeItem: (id: string) => void
  updateItem: (id: string, updates: Partial<Item>) => void
  selectItem: (id: string | null) => void
  clearItems: () => void

  // Computed values
  getItemById: (id: string) => Item | undefined
  getItemCount: () => number
  getSelectedItem: () => Item | null
}

export const useStore = create<StoreState>()(
  persist(
    (set, get) => ({
      // Initial state
      items: [],
      selectedId: null,

      // Actions
      addItem: (item) => {
        set((state) => ({
          items: [...state.items, item],
        }))
      },

      removeItem: (id) => {
        set((state) => ({
          items: state.items.filter((item) => item.id !== id),
          selectedId: state.selectedId === id ? null : state.selectedId,
        }))
      },

      updateItem: (id, updates) => {
        set((state) => ({
          items: state.items.map((item) =>
            item.id === id ? { ...item, ...updates } : item
          ),
        }))
      },

      selectItem: (id) => {
        set({ selectedId: id })
      },

      clearItems: () => {
        set({ items: [], selectedId: null })
      },

      // Computed values
      getItemById: (id) => {
        return get().items.find((item) => item.id === id)
      },

      getItemCount: () => {
        return get().items.length
      },

      getSelectedItem: () => {
        const { items, selectedId } = get()
        if (!selectedId) return null
        return items.find((item) => item.id === selectedId) || null
      },
    }),
    {
      name: 'store-storage', // localStorage key
    }
  )
)
