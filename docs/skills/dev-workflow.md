# Development Workflow

**Type:** Checklist

**When to use:** Reference for common development commands

## Getting Started

```bash
pnpm install          # Install dependencies
cp .env.example .env.local  # Create local env file
# Fill in .env.local values
pnpm dev              # Start dev server (localhost:3000)
```

## With Supabase

```bash
pnpm supabase start   # Start local Supabase
pnpm supabase stop    # Stop local Supabase
pnpm supabase db reset # Reset database to clean state
```

## Before Committing

```bash
pnpm lint             # Check for linting issues
pnpm typecheck        # Verify TypeScript types
pnpm test             # Run tests
```

## Type Generation

```bash
pnpm supabase gen types typescript --local > src/types/supabase.ts
```

## Environment Variables

| Variable | Description | Where |
|----------|-------------|-------|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase project URL | Client + Server |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase anon key (public) | Client + Server |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase service key (secret!) | Server only |
| `NEXT_PUBLIC_USDC_ADDRESS` | USDC contract address | Client |
| `NEXT_PUBLIC_CHAIN_ID` | Target chain ID | Client |

## Important

- Never commit `.env.local`
- The `.env.example` file documents required variables
- Supabase anon key is safe to expose (RLS protects data)
- Supabase service role key must stay server-side
