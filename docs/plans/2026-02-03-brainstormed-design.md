# Ultra-Simple Commerce MVP - Brainstormed Design

## Context

**Meta-goal:** Explore human-agent collaboration patterns in software development
**Collaboration model:** Agent proposes small pieces → human reviews → iterate
**Product fidelity:** Working prototype (functional on testnet)

---

## Core Constraints

- **Minimal friction** is the north star (spirit over letter, not strict click-counting)
- No cart, no buyer accounts, no multi-step checkout wizard
- No refunds, no escrow, no variants, no reviews, no seller dashboards
- Telegram link-out for communication (no in-app messaging)

---

## Technology Stack

| Layer | Technology |
|-------|------------|
| Frontend | Next.js 14 (App Router) + Tailwind CSS |
| Wallet | wagmi + RainbowKit |
| Backend | Supabase (Database + Auth + Storage + Realtime) |
| Hosting | Vercel |
| Payment | USDC on Ethereum (EIP-3009 transferWithAuthorization) |

**Key differences from original plan:**
- Supabase replaces Prisma + NextAuth + separate image hosting
- SIWE replaces email/password for sellers
- USDC replaces ETH (no price conversion needed)
- EIP-3009 transferWithAuthorization (no helper contracts needed)

---

## Data Model

### sellers
```sql
id              uuid primary key
wallet_address  text unique not null  -- auth via SIWE, also payment address
telegram_handle text not null
created_at      timestamptz default now()
```

### products
```sql
id            uuid primary key
seller_id     uuid references sellers(id)
title         text not null
description   text
price_usdc    decimal(10,2) not null  -- 1:1 with USD
images        text[]                   -- URLs from Supabase Storage
specs         jsonb
shipping_info text
status        text default 'active'    -- active, delisted, sold_out
stock         int default 1
created_at    timestamptz default now()
```

### orders
```sql
id             uuid primary key
product_id     uuid references products(id)
buyer_email    text not null
buyer_address  text not null           -- shipping address
amount_usdc    decimal(10,2) not null
seller_wallet  text not null           -- snapshot at order time
tx_hash        text
status         text default 'pending'  -- pending, paid, shipped, cancelled
created_at     timestamptz default now()
```

---

## Authentication

**Sellers:** Sign-In with Ethereum (SIWE)
1. Connect wallet (RainbowKit)
2. Sign message proving ownership
3. Backend verifies signature → creates/retrieves seller
4. Wallet address = identity = payment address

**Buyers:** No authentication (guest checkout)

---

## Payment Flow (USDC + EIP-3009)

1. Product price displayed in USD = USDC amount (1:1)
2. Buyer fills checkout (email + shipping address)
3. Order created with `status: pending`, `amount_usdc`
4. Buyer connects wallet (if not already connected)
5. Buyer signs `transferWithAuthorization` message:
   - `from`: buyer wallet
   - `to`: seller wallet
   - `value`: order amount in USDC
   - `validAfter`, `validBefore`: time window
   - `nonce`: replay protection
6. Buyer submits transaction calling USDC's `transferWithAuthorization`
7. Buyer pays gas
8. Backend verifies Transfer event on-chain
9. Order updated to `status: paid`

**No custom contracts required** - uses native USDC functionality.

---

## Buyer Flow

1. Browse catalog (home page with product grid)
2. Click product → view details (title, images, price, specs, shipping)
3. Click "Buy Now" → checkout form (email, shipping address)
4. Connect wallet (if not connected) → sign authorization → submit transaction
5. See order confirmation / status page
6. Contact seller via Telegram link if needed

---

## Seller Flow

1. Connect wallet → sign SIWE message
2. Enter Telegram handle → registration complete
3. Dashboard: list of products, list of orders
4. Create product: title, description, price (USDC), images, specs, shipping info
5. Delist product when needed
6. View incoming orders, see buyer contact info

---

## Implementation Phases

### Phase 1: Foundation
- Initialize Next.js 14 + Tailwind + Supabase
- Create database schema (3 tables)
- Set up wagmi + RainbowKit providers
- **Deliverable:** Empty app with DB connection and wallet connect button

### Phase 2: Seller Auth (SIWE)
- Implement Sign-In with Ethereum
- Seller registration (connect → sign → add Telegram)
- Seller dashboard shell
- **Deliverable:** Seller can log in with wallet

### Phase 3: Product Management
- Create product form
- Image upload to Supabase Storage
- Product listing/delisting
- **Deliverable:** Seller can create and manage products

### Phase 4: Buyer Catalog
- Home page with product grid
- Product detail page
- **Deliverable:** Buyers can browse and view products

### Phase 5: Checkout & Payment
- Checkout form (email, shipping)
- USDC transferWithAuthorization integration
- Order creation and verification
- **Deliverable:** End-to-end purchase works (testnet)

### Phase 6: Order Status
- Order confirmation page for buyers
- Seller order list with buyer info
- Telegram link-out
- **Deliverable:** Complete MVP

---

## File Structure

```
src/
├── app/
│   ├── layout.tsx
│   ├── page.tsx                    # Catalog
│   ├── providers.tsx               # wagmi, Supabase
│   ├── product/[id]/page.tsx       # Product detail
│   ├── checkout/[productId]/page.tsx
│   ├── order/[id]/page.tsx         # Order status
│   └── seller/
│       ├── page.tsx                # Dashboard
│       ├── products/new/page.tsx
│       └── orders/page.tsx
├── components/
│   ├── ui/
│   ├── product/
│   ├── checkout/
│   └── seller/
├── lib/
│   ├── supabase.ts
│   ├── siwe.ts
│   └── usdc.ts                     # transferWithAuthorization helpers
└── hooks/
    ├── useAuth.ts
    └── usePayment.ts
```

---

## Verification

1. **Buyer flow:** Browse → select → checkout → pay → confirm (minimal friction)
2. **Seller flow:** SIWE login → create product → view orders
3. **Payment test:** USDC transfer on Sepolia testnet
4. **Deploy:** Vercel deployment succeeds
