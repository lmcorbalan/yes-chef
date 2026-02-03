# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Ultra-Simple Commerce MVP** - A minimalist e-commerce platform for buying new electronics with cryptocurrency (USDC) payments.

**Meta-goal:** This project is a test bed for exploring human-agent collaboration in software development. The product itself matters less than the development process.

**Collaboration model:** Agent proposes small pieces → human reviews → iterate. Short cycles with frequent checkpoints.

## Technology Stack

| Layer | Technology |
|-------|------------|
| Frontend | Next.js 14 (App Router) + Tailwind CSS |
| Wallet | wagmi + RainbowKit |
| Backend | Supabase (Database + Auth + Storage + Realtime) |
| Hosting | Vercel |
| Payment | USDC on Ethereum (EIP-3009 transferWithAuthorization) |

## Key Design Decisions

- **Seller auth:** Sign-In with Ethereum (SIWE) - wallet = identity = payment address
- **Buyer auth:** None required (guest checkout)
- **Payment:** USDC only (1:1 with USD, no price conversion)
- **Payment method:** EIP-3009 `transferWithAuthorization` (no custom contracts)
- **Communication:** Telegram link-out only (no in-app messaging)
- **Minimal friction:** Spirit over letter - aim for fewest steps, not strict click counting

## Data Model

Three tables:
- `sellers`: id, wallet_address (unique), telegram_handle, created_at
- `products`: id, seller_id, title, description, price_usdc, images[], specs (JSON), shipping_info, status, stock
- `orders`: id, product_id, buyer_email, buyer_address, amount_usdc, seller_wallet, tx_hash, status

## Implementation Phases

1. **Foundation** - Next.js + Tailwind + Supabase + wagmi/RainbowKit setup
2. **Seller Auth (SIWE)** - Wallet-based login, registration with Telegram handle
3. **Product Management** - Create/delist products, image upload
4. **Buyer Catalog** - Browse products, view details
5. **Checkout & Payment** - USDC transferWithAuthorization flow
6. **Order Status** - Confirmation pages, seller order list

## Current Status

**Phase:** Planning complete, ready for Phase 1 implementation

## Key Documents

- `docs/Product 1-Pager — Ultra-Simple Commerce MVP.md` - Original product vision
- `docs/Lean MVP PRD — Ultra-Simple Commerce.md` - Detailed requirements
- `docs/plan/2026-02-03-brainstormed-design.md` - Technical design (use this)
- `docs/plan/implementation-plan-v1.md` - Earlier plan (superseded)
- `docs/sessions/2026-02-03-brainstorming-session.md` - Session log with context

## Working With This Project

1. **Always use the brainstorming skill** before creative/design work
2. **Propose small pieces** and wait for review before proceeding
3. **Reference the design doc** for technical decisions already made
4. **Check session logs** for context on past decisions and user preferences

## Commands

_To be added as the project develops_
