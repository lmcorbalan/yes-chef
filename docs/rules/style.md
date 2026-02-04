# Style Conventions (ADVISORY)

Follow these conventions. Deviation is acceptable with good reason.

## TypeScript

- Use TypeScript strict mode
- Prefer named exports over default exports
- Use explicit return types for functions

## React

- Functional components with hooks (no class components)
- Colocate tests with source files (`Component.tsx` + `Component.test.tsx`)

## Naming

- File naming: kebab-case (`user-profile.tsx`)
- Component naming: PascalCase (`UserProfile`)
- Function naming: camelCase (`getUserProfile`)

## Imports

- Use absolute imports with `@/` prefix
- Never use relative imports like `../../components/Button`
- Correct: `import { Button } from '@/components/Button'`

## File Organization

- Group by feature, not by type
- Keep files small and focused
- One component per file (with exceptions for tightly coupled small components)
