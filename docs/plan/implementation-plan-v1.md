# Implementation Plan: Ultra-Simple E-Commerce MVP

## Overview
Build a minimalist e-commerce platform for buying new electronics with Ethereum payments. Core constraint: buyers complete purchases in **≤4 clicks**.

---

## Technology Stack

| Layer | Technology | Rationale |
|-------|------------|-----------|
| Frontend | **Next.js 14 (App Router)** | Server components, file-based routing, API routes |
| Styling | **Tailwind CSS** | Fast prototyping |
| Wallet | **wagmi + viem + RainbowKit** | Type-safe ETH interactions, wallet connect UI |
| Backend | **Next.js API Routes** | Collocated with frontend |
| Auth | **NextAuth.js** | Seller authentication |
| Database | **PostgreSQL + Prisma** | Type-safe ORM, free tier on Supabase/Neon |
| Blockchain | **Alchemy RPC** | Payment verification |
| Hosting | **Vercel** | Free tier, native Next.js support |

---

## Database Schema (Prisma)

```prisma
model Seller {
  id             String    @id @default(cuid())
  email          String    @unique
  passwordHash   String
  name           String
  walletAddress  String    // ETH address for payments
  telegramHandle String    // For buyer contact
  products       Product[]
  createdAt      DateTime  @default(now())
  updatedAt      DateTime  @updatedAt
}

model Product {
  id           String        @id @default(cuid())
  seller       Seller        @relation(fields: [sellerId], references: [id])
  sellerId     String
  title        String
  description  String        @db.Text
  priceUsd     Decimal       @db.Decimal(10, 2)
  images       String[]
  specs        Json
  shippingInfo String
  status       ProductStatus @default(ACTIVE)
  stock        Int           @default(1)
  orders       Order[]
}

enum ProductStatus { ACTIVE, DELISTED, SOLD_OUT }

model Order {
  id           String      @id @default(cuid())
  product      Product     @relation(fields: [productId], references: [id])
  productId    String
  quantity     Int         @default(1)
  priceUsd     Decimal     @db.Decimal(10, 2)
  priceEth     Decimal     @db.Decimal(18, 8)
  buyerEmail   String
  buyerAddress String      @db.Text
  sellerWallet String
  txHash       String?
  status       OrderStatus @default(PENDING_PAYMENT)
}

enum OrderStatus { PENDING_PAYMENT, PAYMENT_SENT, PAID, SHIPPED, CANCELLED }
```

---

## 4-Click Buyer Flow

| Click | Action | Page |
|-------|--------|------|
| 1 | Select product from catalog | `/` |
| 2 | Click "Buy Now" | `/product/[id]` |
| 3 | Submit checkout (email + address) | `/checkout/[productId]` |
| 4 | Confirm wallet transaction | Wallet popup → `/order/[id]` |

---

## File Structure

```
src/
├── app/
│   ├── layout.tsx, page.tsx (catalog), providers.tsx
│   ├── product/[id]/page.tsx
│   ├── checkout/[productId]/page.tsx
│   ├── order/[id]/page.tsx
│   ├── seller/
│   │   ├── login/, register/, dashboard/
│   │   ├── products/new/
│   │   └── orders/
│   └── api/
│       ├── products/, products/[id]/
│       ├── orders/, orders/[id]/, orders/[id]/verify-payment/
│       ├── seller/orders/
│       └── auth/[...nextauth]/
├── components/
│   ├── ui/ (Button, Card, Input, Modal, Spinner)
│   ├── product/ (ProductCard, ProductGrid, ProductDetails)
│   ├── checkout/ (CheckoutForm, PriceSummary, PaymentButton)
│   ├── order/ (OrderStatus, OrderDetails)
│   └── wallet/ (ConnectButton)
├── services/
│   ├── product.service.ts
│   ├── order.service.ts
│   ├── payment.service.ts (ETH verification via viem)
│   └── price.service.ts (ETH/USD via CoinGecko)
├── hooks/
│   ├── usePayment.ts, useEthPrice.ts, useOrderStatus.ts
├── lib/
│   └── prisma.ts, auth.ts, utils.ts
└── types/
    └── product.ts, order.ts, seller.ts
prisma/
├── schema.prisma
└── seed.ts
```

---

## Phased Roadmap

### Phase 1: Foundation
- Initialize Next.js 14 + TypeScript + Tailwind
- Configure Prisma + PostgreSQL (Supabase)
- Create schema + migrations + seed data

### Phase 2: Product Catalog
- `GET /api/products` - list products
- `GET /api/products/[id]` - product detail
- Home page (catalog grid) + product detail page

### Phase 3: Checkout & Orders
- `POST /api/orders` - create order
- `GET /api/orders/[id]` - order status
- Checkout form (email, address)
- ETH price conversion (CoinGecko)
- Order confirmation page

### Phase 4: Ethereum Payment
- Set up wagmi + RainbowKit
- Wallet connect flow
- ETH transfer prompt
- Payment verification service (viem + Alchemy RPC)
- `POST /api/orders/[id]/verify-payment`
- Order status polling

### Phase 5: Seller Authentication
- NextAuth.js with credentials
- Registration page (email, password, wallet, Telegram)
- Login page
- Auth middleware for seller routes

### Phase 6: Seller Product Management
- `POST /api/products` - create product
- Product creation form with image upload
- Seller dashboard
- Delist functionality

### Phase 7: Seller Order Management
- `GET /api/seller/orders`
- Orders list page
- Mark as shipped functionality
- Telegram link for buyer contact

### Phase 8: Polish
- Loading states, error handling
- Mobile responsive
- Order timeout (auto-cancel after 30min)
- Deploy to Vercel

---

## Payment Flow (Non-Custodial)

1. **Order Created**: Store `expectedAmountETH`, `sellerWallet`, `orderId`
2. **Buyer Pays**: wagmi `sendTransaction` to seller wallet
3. **Capture txHash**: Store on order record
4. **Verify**: Server-side via Alchemy RPC
   - Check `to === sellerWallet`
   - Check `value >= expectedAmount`
   - Check `confirmations >= 1`
5. **Update Status**: Order → PAID

---

## Verification

1. **Buyer flow test**: Browse → select → checkout → pay → confirm (≤4 clicks)
2. **Seller flow test**: Register → create product → view orders → mark shipped
3. **Payment test (Sepolia)**: Verify correct wallet receives correct amount
4. **Deploy**: Vercel deployment succeeds

---

## Critical Files

1. `/src/app/providers.tsx` - wagmi/RainbowKit setup
2. `/prisma/schema.prisma` - data model
3. `/src/services/payment.service.ts` - ETH verification
4. `/src/app/checkout/[productId]/page.tsx` - purchase flow orchestration
5. `/src/app/api/orders/[id]/verify-payment/route.ts` - payment verification API
