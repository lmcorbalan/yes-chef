# Phase 1: Foundation Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Set up the project foundation with Next.js 14, Tailwind, Supabase, and wagmi/RainbowKit, ending with a working app that has database tables and a wallet connect button.

**Architecture:** Next.js 14 App Router with Tailwind for styling. Supabase for database (PostgreSQL). wagmi + RainbowKit for wallet connections. All providers wrapped in a client-side providers component.

**Tech Stack:** Next.js 14, TypeScript, Tailwind CSS 3, Supabase, wagmi 2.x, RainbowKit, pnpm

---

## Task 0: Verify Prerequisites

**Files:** None (verification only)

**Step 1: Verify Node.js 18+**

```bash
node -v
```

Expected: `v18.x.x` or higher (v20+ recommended).

**Step 2: Verify pnpm**

```bash
pnpm -v
```

Expected: Version number. If not installed: `npm install -g pnpm`

**Step 3: Verify Supabase CLI**

```bash
supabase --version
```

Expected: Version number. If not installed: `brew install supabase/tap/supabase`

**Step 4: Get WalletConnect Project ID**

1. Go to https://cloud.walletconnect.com
2. Create a free account (if needed)
3. Create a new project
4. Copy the Project ID

Save this value - you'll need it for `.env.local` later.

---

## Task 1: Initialize Next.js Project

**Files:**
- Create: `package.json`, `next.config.js`, `tsconfig.json`, `tailwind.config.ts`, `postcss.config.js`
- Create: `src/app/layout.tsx`, `src/app/page.tsx`, `src/app/globals.css`

**Step 1: Create Next.js app with TypeScript and Tailwind**

```bash
pnpm create next-app@14 . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" --use-pnpm
```

When prompted:
- Would you like to use TypeScript? **Yes**
- Would you like to use ESLint? **Yes**
- Would you like to use Tailwind CSS? **Yes**
- Would you like to use `src/` directory? **Yes**
- Would you like to use App Router? **Yes**
- Would you like to customize the default import alias? **Yes** (@/*)

**Step 2: Verify the app runs**

```bash
pnpm dev
```

Expected: App starts at http://localhost:3000, shows Next.js welcome page.

**Step 3: Clean up default content**

Replace `src/app/page.tsx`:

```tsx
export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <h1 className="text-4xl font-bold">Ultra-Simple Commerce</h1>
      <p className="mt-4 text-gray-600">Coming soon...</p>
    </main>
  );
}
```

**Step 4: Verify clean page renders**

```bash
pnpm dev
```

Expected: Page shows "Ultra-Simple Commerce" heading.

**Step 5: Commit**

```bash
git add -A
git commit -m "feat: initialize Next.js 14 with TypeScript and Tailwind"
```

---

## Task 2: Configure ESLint and TypeScript Strictness

**Files:**
- Modify: `.eslintrc.json`
- Verify: `tsconfig.json`

**Step 1: Update ESLint config**

Replace `.eslintrc.json`:

```json
{
  "extends": ["next/core-web-vitals", "next/typescript"],
  "rules": {
    "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    "@typescript-eslint/no-explicit-any": "error"
  }
}
```

**Step 2: Verify TypeScript strict mode is enabled**

Check `tsconfig.json` has `"strict": true` (Next.js default). If not, add it.

**Step 3: Run lint**

```bash
pnpm lint
```

Expected: No errors.

**Step 4: Commit**

```bash
git add .eslintrc.json tsconfig.json
git commit -m "chore: configure stricter ESLint rules"
```

---

## Task 3: Initialize Supabase

**Files:**
- Create: `supabase/config.toml`
- Create: `.env.example`
- Create: `.env.local`

**Step 1: Initialize Supabase project**

```bash
supabase init
```

Expected: Creates `supabase/` directory with `config.toml`.

**Step 2: Start local Supabase**

```bash
supabase start
```

Expected: Outputs local URLs and keys. Note the `API URL` and `anon key` from the output.

**Step 3: Create .env.example**

Create `.env.example`:

```
# Supabase (values from `supabase start` output)
NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-from-supabase-start

# WalletConnect (get from https://cloud.walletconnect.com)
NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID=your-project-id

# Chain (1 = mainnet, 11155111 = sepolia)
NEXT_PUBLIC_CHAIN_ID=11155111
```

**Step 4: Create .env.local with actual values**

```bash
cp .env.example .env.local
```

Then edit `.env.local`:
- Copy `NEXT_PUBLIC_SUPABASE_ANON_KEY` from `supabase start` output (or run `supabase status`)
- Paste your WalletConnect Project ID from Task 0

**Step 5: Verify Supabase is running**

```bash
supabase status
```

Expected: Shows running services with URLs.

**Step 6: Commit**

```bash
git add supabase/config.toml .env.example
git commit -m "feat: initialize Supabase local development"
```

---

## Task 4: Create Database Schema

**Files:**
- Create: `supabase/migrations/[timestamp]_create_tables.sql` (via CLI)

**Step 1: Create migration file using Supabase CLI**

```bash
supabase migration new create_tables
```

Expected: Creates file like `supabase/migrations/20260204120000_create_tables.sql`

**Step 2: Write the migration**

Edit the created migration file with this SQL:

```sql
-- Create sellers table
create table sellers (
  id uuid primary key default gen_random_uuid(),
  wallet_address text unique not null,
  telegram_handle text not null,
  created_at timestamptz default now()
);

-- Create products table
create table products (
  id uuid primary key default gen_random_uuid(),
  seller_id uuid references sellers(id) on delete cascade not null,
  title text not null,
  description text,
  price_usdc decimal(10,2) not null,
  images text[] default '{}',
  specs jsonb default '{}',
  shipping_info text,
  status text default 'active' check (status in ('active', 'delisted', 'sold_out')),
  stock int default 1,
  created_at timestamptz default now()
);

-- Create orders table
create table orders (
  id uuid primary key default gen_random_uuid(),
  product_id uuid references products(id) on delete restrict not null,
  buyer_email text not null,
  buyer_address text not null,
  amount_usdc decimal(10,2) not null,
  seller_wallet text not null,
  tx_hash text,
  status text default 'pending' check (status in ('pending', 'paid', 'shipped', 'cancelled')),
  created_at timestamptz default now()
);

-- Enable Row Level Security
alter table sellers enable row level security;
alter table products enable row level security;
alter table orders enable row level security;

-- Products: anyone can read active products
create policy "Anyone can view active products" on products
  for select using (status = 'active');

-- Sellers: no public access (will add auth policies later)
-- Orders: no public access (will add auth policies later)

-- Create indexes for common queries
create index idx_products_seller_id on products(seller_id);
create index idx_products_status on products(status);
create index idx_orders_product_id on orders(product_id);
create index idx_sellers_wallet on sellers(wallet_address);
```

**Step 3: Apply migration**

```bash
supabase db reset
```

Expected: Migration applies successfully, shows "Finished supabase db reset".

**Step 4: Verify tables exist**

```bash
supabase db push --dry-run
```

Expected: "No changes to push" (schema is current).

**Step 5: Commit**

```bash
git add supabase/migrations/
git commit -m "feat: create database schema (sellers, products, orders)"
```

---

## Task 5: Install and Configure Supabase Client

**Files:**
- Modify: `package.json`
- Create: `src/lib/supabase.ts`
- Create: `src/types/database.ts` (via CLI)

**Step 1: Install Supabase client**

```bash
pnpm add @supabase/supabase-js
```

**Step 2: Generate TypeScript types from database**

```bash
mkdir -p src/types
supabase gen types typescript --local > src/types/database.ts
```

This generates types automatically from your actual database schema.

**Step 3: Create Supabase client**

Create `src/lib/supabase.ts`:

```typescript
import { createClient } from '@supabase/supabase-js';
import { Database } from '@/types/database';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient<Database>(supabaseUrl, supabaseAnonKey);
```

**Step 4: Test the client compiles**

```bash
pnpm typecheck
```

Expected: No type errors.

**Step 5: Commit**

```bash
git add package.json pnpm-lock.yaml src/lib/supabase.ts src/types/database.ts
git commit -m "feat: add Supabase client with generated TypeScript types"
```

---

## Task 6: Install wagmi and RainbowKit

**Files:**
- Modify: `package.json`

**Step 1: Install wagmi, viem, and RainbowKit**

```bash
pnpm add wagmi viem@2.x @tanstack/react-query @rainbow-me/rainbowkit
```

**Step 2: Verify packages installed**

```bash
pnpm list wagmi viem @rainbow-me/rainbowkit
```

Expected: Shows installed versions.

**Step 3: Commit**

```bash
git add package.json pnpm-lock.yaml
git commit -m "feat: add wagmi, viem, and RainbowKit dependencies"
```

---

## Task 7: Configure wagmi and RainbowKit

**Files:**
- Create: `src/lib/wagmi.ts`
- Create: `src/app/providers.tsx`
- Modify: `src/app/layout.tsx`

**Step 1: Create wagmi config**

Create `src/lib/wagmi.ts`:

```typescript
import { getDefaultConfig } from '@rainbow-me/rainbowkit';
import { mainnet, sepolia } from 'wagmi/chains';

const chainId = parseInt(process.env.NEXT_PUBLIC_CHAIN_ID || '11155111');
const chains = chainId === 1 ? [mainnet] : [sepolia];

export const config = getDefaultConfig({
  appName: 'Ultra-Simple Commerce',
  projectId: process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID!,
  chains: chains as any,
  ssr: true,
});
```

**Step 2: Create providers component**

Create `src/app/providers.tsx`:

```typescript
'use client';

import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { WagmiProvider } from 'wagmi';
import { RainbowKitProvider } from '@rainbow-me/rainbowkit';
import { config } from '@/lib/wagmi';
import '@rainbow-me/rainbowkit/styles.css';

const queryClient = new QueryClient();

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <RainbowKitProvider>
          {children}
        </RainbowKitProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
}
```

**Why `'use client'`?** In Next.js 14 App Router, components are Server Components by default (rendered on server, no JS sent to browser). The `'use client'` directive marks this as a Client Component because:
- RainbowKit uses React hooks and browser APIs
- wagmi requires client-side state management
- QueryClient needs to persist across renders

**Step 3: Update layout to use providers**

Replace `src/app/layout.tsx`:

```typescript
import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import { Providers } from './providers';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'Ultra-Simple Commerce',
  description: 'Buy electronics with crypto',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
```

**Step 4: Verify app compiles**

```bash
pnpm typecheck
```

Expected: No type errors.

**Step 5: Commit**

```bash
git add src/lib/wagmi.ts src/app/providers.tsx src/app/layout.tsx
git commit -m "feat: configure wagmi and RainbowKit providers"
```

---

## Task 8: Add Connect Wallet Button to Home Page

**Files:**
- Modify: `src/app/page.tsx`

**Step 1: Update home page with ConnectButton**

Replace `src/app/page.tsx`:

```typescript
'use client';

import { ConnectButton } from '@rainbow-me/rainbowkit';

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <h1 className="text-4xl font-bold mb-8">Ultra-Simple Commerce</h1>
      <ConnectButton />
    </main>
  );
}
```

**Why `'use client'` here?** The `ConnectButton` component from RainbowKit uses React hooks internally (`useState`, `useEffect`) and needs to run in the browser to interact with wallet extensions.

**Step 2: Verify wallet connect works**

```bash
pnpm dev
```

1. Open http://localhost:3000
2. Click "Connect Wallet" button
3. Modal should appear with wallet options

Expected: RainbowKit modal appears with wallet choices.

**Step 3: Commit**

```bash
git add src/app/page.tsx
git commit -m "feat: add wallet connect button to home page"
```

---

## Task 9: Test Database Connection

**Files:**
- Modify: `src/app/page.tsx` (temporarily, then revert)

**Step 1: Add database test to home page**

Update `src/app/page.tsx`:

```typescript
'use client';

import { ConnectButton } from '@rainbow-me/rainbowkit';
import { useEffect, useState } from 'react';
import { supabase } from '@/lib/supabase';

export default function Home() {
  const [dbStatus, setDbStatus] = useState<'checking' | 'connected' | 'error'>('checking');

  useEffect(() => {
    async function checkDb() {
      const { error } = await supabase.from('products').select('count').limit(0);
      setDbStatus(error ? 'error' : 'connected');
    }
    checkDb();
  }, []);

  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <h1 className="text-4xl font-bold mb-4">Ultra-Simple Commerce</h1>
      <p className="text-sm text-gray-500 mb-8">
        Database: {dbStatus === 'checking' ? '...' : dbStatus === 'connected' ? '✓ Connected' : '✗ Error'}
      </p>
      <ConnectButton />
    </main>
  );
}
```

**Step 2: Verify database connection**

```bash
pnpm dev
```

1. Open http://localhost:3000
2. Should show "Database: ✓ Connected"

Expected: Database shows connected status.

**Step 3: Remove test code (keep it clean)**

Replace `src/app/page.tsx`:

```typescript
'use client';

import { ConnectButton } from '@rainbow-me/rainbowkit';

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <h1 className="text-4xl font-bold mb-8">Ultra-Simple Commerce</h1>
      <ConnectButton />
    </main>
  );
}
```

**Step 4: Commit**

```bash
git add src/app/page.tsx
git commit -m "test: verify database connection works"
```

---

## Task 10: Create README

**Files:**
- Create: `README.md`

**Step 1: Create README.md**

```markdown
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
- **Wallet:** wagmi, RainbowKit
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
```

**Step 2: Commit**

```bash
git add README.md
git commit -m "docs: add project README"
```

---

## Task 11: Final Verification

**Files:** None (verification only)

**Step 1: Run all checks**

```bash
pnpm lint && pnpm typecheck
```

Expected: No errors.

**Step 2: Start fresh and test**

```bash
supabase stop
supabase start
pnpm dev
```

1. Open http://localhost:3000
2. Page loads with "Ultra-Simple Commerce" heading
3. "Connect Wallet" button visible and functional

**Step 3: Review git log**

```bash
git log --oneline
```

Expected: Clean commit history showing all tasks.

---

## Deliverables Checklist

- [ ] Next.js 14 app with TypeScript and Tailwind
- [ ] ESLint configured with strict rules
- [ ] Supabase local development running
- [ ] Database schema: sellers, products, orders tables with RLS
- [ ] Supabase client with auto-generated TypeScript types
- [ ] wagmi + RainbowKit configured for Sepolia testnet
- [ ] Home page with working wallet connect button
- [ ] README with setup instructions
- [ ] All code passes lint and typecheck

## Next Phase

Phase 2: Seller Auth (SIWE) - Implement Sign-In with Ethereum for seller authentication.
