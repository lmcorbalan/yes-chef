# AGENTS.md

Instructions for AI coding assistants working on this project.

## Project Overview

**Ultra-Simple Commerce MVP** - A minimalist e-commerce platform for buying new electronics with cryptocurrency (USDC) payments.

**Meta-goal:** This project is a test bed for exploring human-agent collaboration in software development. The product itself matters less than the development process.

**Collaboration model:** Agent proposes small pieces → human reviews → iterate. Short cycles with frequent checkpoints.

## Current Status

**Phase:** Phase 1 complete (Foundation)

**Next:** Phase 2 - Seller Auth (SIWE): Wallet-based login, registration with Telegram handle, protected seller routes

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

## Key Documents

- `docs/plans/2026-02-03-brainstormed-design.md` - Full technical design
- `docs/sessions/` - Session logs with context on past decisions
