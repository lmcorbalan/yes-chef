# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Project Overview

**Ultra-Simple Commerce MVP** - A minimalist e-commerce platform for buying new electronics with cryptocurrency (USDC) payments.

**Meta-goal:** This project is a test bed for exploring human-agent collaboration in software development. The product itself matters less than the development process.

**Collaboration model:** Agent proposes small pieces → human reviews → iterate. Short cycles with frequent checkpoints.

## Current Status

**Phase:** Phase 0 complete (agent-friendly setup), ready for Phase 1 (Foundation)

**Next:** Initialize Next.js 14 + Tailwind + Supabase, create database schema, set up wagmi + RainbowKit

## Quick Reference

```bash
# Development
pnpm install          # Install dependencies
pnpm dev              # Start dev server
pnpm lint             # Check linting
pnpm typecheck        # Check types
pnpm test             # Run tests

# Supabase
pnpm supabase start   # Start local Supabase
pnpm supabase stop    # Stop local Supabase
```

## Tech Stack

| Layer | Technology | Version |
|-------|------------|---------|
| Frontend | Next.js (App Router) | 14.x |
| Styling | Tailwind CSS | 3.x |
| Wallet | wagmi + RainbowKit | wagmi 2.x |
| Backend | Supabase | Latest |
| Payment | USDC (EIP-3009) | - |

## Rules

Read these before making changes:

| Rule | Type | File |
|------|------|------|
| Security | STRICT | `docs/rules/security.md` |
| Scope | STRICT | `docs/rules/scope.md` |
| Decisions | STRICT | `docs/rules/decisions.md` |
| Style | Advisory | `docs/rules/style.md` |
| Workflow | Advisory | `docs/rules/workflow.md` |

**STRICT rules must never be broken. Advisory rules can be deviated from with good reason.**

## Skills

Use these for common tasks:

| Skill | Type | When to Use |
|-------|------|-------------|
| `docs/skills/add-page.md` | Template | Creating new routes |
| `docs/skills/add-supabase-table.md` | Checklist | Database changes |
| `docs/skills/add-wagmi-hook.md` | Template | Wallet interactions |
| `docs/skills/dev-workflow.md` | Reference | Development commands |
| `docs/skills/create-checkpoint.md` | Checklist | Completing work |

## Key Design Decisions

Major decisions have been made and documented. Don't re-litigate without explicit approval.

| Decision | Summary | ADR |
|----------|---------|-----|
| Supabase | Use for all backend (DB, auth, storage) | `docs/decisions/001-supabase-stack.md` |
| SIWE Auth | Wallet-based seller authentication | `docs/decisions/002-siwe-auth.md` |
| USDC + EIP-3009 | Stablecoin payments, buyer pays gas | `docs/decisions/003-usdc-eip3009.md` |
| Guest Checkout | No buyer accounts | `docs/decisions/004-no-buyer-accounts.md` |
| Dual Agent Files | AGENTS.md + CLAUDE.md | `docs/decisions/005-dual-agent-files.md` |
| Tool-Agnostic Structure | Rules/skills in docs/, not .claude/ | `docs/decisions/006-agnostic-folder-structure.md` |

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

## Key Documents

- `docs/plans/2026-02-03-brainstormed-design.md` - Full technical design
- `docs/sessions/` - Session logs with context on past decisions

## Working With This Project

1. **Always use the brainstorming skill** before creative/design work
2. **Propose small pieces** and wait for review before proceeding
3. **Reference the design doc** for technical decisions already made
4. **Check session logs** for context on past decisions and user preferences
5. **Read the rules** before making changes (especially STRICT rules)
6. **Use the skills** for common tasks to maintain consistency
