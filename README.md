# Ultra-Simple Commerce

A minimalist e-commerce platform for buying electronics with cryptocurrency (USDC) payments.

## Prerequisites

- Node.js 18+ (`node -v`)
- pnpm (`npm install -g pnpm`)
- Supabase CLI (`brew install supabase/tap/supabase`)
- WalletConnect Project ID (free at https://cloud.walletconnect.com)

## Setup

1. **Install dependencies**

   ```bash
   pnpm install
   ```

2. **Set up environment variables**

   ```bash
   cp .env.example .env.local
   ```

   Edit `.env.local` and fill in:
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY` - from `supabase status` output
   - `NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID` - from WalletConnect Cloud

3. **Start local Supabase**

   ```bash
   supabase start
   ```

4. **Start development server**

   ```bash
   pnpm dev
   ```

   Open http://localhost:3000

## Development Commands

| Command | Description |
|---------|-------------|
| `pnpm dev` | Start dev server |
| `pnpm build` | Build for production |
| `pnpm lint` | Check linting |
| `pnpm typecheck` | Check TypeScript types |
| `supabase start` | Start local Supabase |
| `supabase stop` | Stop local Supabase |
| `supabase db reset` | Reset database |
| `supabase gen types typescript --local > src/types/database.ts` | Regenerate DB types |

## Tech Stack

- **Frontend:** Next.js 14 (App Router), Tailwind CSS
- **Wallet:** wagmi 2.x, RainbowKit
- **Backend:** Supabase (PostgreSQL, Auth, Storage)
- **Payments:** USDC (EIP-3009)

## Project Structure

```
src/
├── app/           # Next.js App Router pages
├── components/    # React components
├── lib/           # Utilities (supabase, wagmi config)
├── types/         # TypeScript types
└── hooks/         # Custom React hooks
supabase/
├── config.toml    # Supabase config
└── migrations/    # Database migrations
```

## Database Schema

- **sellers** - Wallet address, Telegram handle
- **products** - Title, description, price (USDC), images, specs
- **orders** - Buyer info, amount, transaction hash, status
