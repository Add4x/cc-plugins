"use client";

import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";

// Types
interface Resource {
  id: string;
  name: string;
  // Add your fields
}

interface CreateResourceInput {
  name: string;
  // Add your fields
}

// Query hook
export function useResources(filters?: Record<string, string>) {
  return useQuery<Resource[]>({
    queryKey: ["resources", filters],
    queryFn: async () => {
      const params = new URLSearchParams(filters);
      const endpoint = `/api/resources?${params.toString()}`;

      const response = await fetch(endpoint);
      if (!response.ok) {
        throw new Error('Failed to fetch resources');
      }
      return response.json();
    },
    staleTime: 5 * 60 * 1000, // 5 minutes
    gcTime: 10 * 60 * 1000, // 10 minutes
  });
}

// Query by ID
export function useResource(id: string) {
  return useQuery<Resource>({
    queryKey: ["resource", id],
    queryFn: async () => {
      const response = await fetch(`/api/resources/${id}`);
      if (!response.ok) {
        throw new Error('Failed to fetch resource');
      }
      return response.json();
    },
    enabled: !!id,
    staleTime: 5 * 60 * 1000,
  });
}

// Mutation hook
export function useCreateResource() {
  const queryClient = useQueryClient();

  return useMutation<Resource, Error, CreateResourceInput>({
    mutationFn: async (data) => {
      const response = await fetch('/api/resources', {
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
      // Invalidate and refetch
      queryClient.invalidateQueries({ queryKey: ['resources'] });
    },
  });
}
