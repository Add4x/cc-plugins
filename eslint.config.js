// Minimal ESLint configuration for template repository
// This repo contains templates and examples, not production code
export default [
  {
    ignores: [
      'nextjs-frontend-dev/**',
      '**/templates/**',
      '**/node_modules/**',
      '**/.git/**',
      '**/dist/**',
      '**/build/**',
    ]
  }
];
