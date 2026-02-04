# Adding a New Page

**Type:** Template

**When to use:** When creating a new route in the app (e.g., `/seller/orders`)

## File Structure

```
src/app/[route]/page.tsx     # The page component (required)
src/app/[route]/loading.tsx  # Loading state (optional)
src/app/[route]/error.tsx    # Error boundary (optional)
```

## Template

```tsx
import { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'Page Title | Ultra-Simple Commerce',
  description: 'Page description for SEO',
}

export default function PageName() {
  return (
    <main>
      {/* Page content */}
    </main>
  )
}
```

## Checklist

- [ ] Uses `@/` absolute imports
- [ ] Exports metadata for SEO
- [ ] Handles loading/error states if fetching data
- [ ] Follows existing page patterns in codebase
- [ ] File uses kebab-case naming
- [ ] Component uses PascalCase naming
