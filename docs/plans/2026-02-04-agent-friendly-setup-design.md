# Agent-Friendly Repo Setup - Design Document

**Date:** 2026-02-04
**Status:** Ready for implementation

---

## Overview

Before implementing the product (Phase 1), set up the repo so AI agents can work effectively. This is "Phase 0" - preparing the collaboration infrastructure.

**Goal:** A repo where any AI agent can start working by reading AGENTS.md or CLAUDE.md and following the documented rules/skills without needing repeated context from the human.

---

## Design Decisions

### Dual Agent Files (ADR-005)

Maintain two instruction files:
- `AGENTS.md` - Generic instructions any AI tool can use
- `CLAUDE.md` - Claude Code-specific instructions and pointers

This allows switching or comparing AI tools while keeping Claude-specific features available.

### Tool-Agnostic Folder Structure (ADR-006)

Store all rules and skills in `docs/` folder instead of tool-specific folders like `.claude/` or `.cursor/`:
- `docs/rules/` - Guardrails and conventions
- `docs/skills/` - Workflow templates and checklists

Reference these from AGENTS.md and CLAUDE.md. This keeps content visible, portable, and works with any AI tool that reads markdown.

---

## Folder Structure

```
docs/
├── rules/
│   ├── security.md          # STRICT
│   ├── scope.md             # STRICT
│   ├── decisions.md         # STRICT
│   ├── style.md             # ADVISORY
│   └── workflow.md          # ADVISORY
├── skills/
│   ├── add-page.md
│   ├── add-supabase-table.md
│   ├── add-wagmi-hook.md
│   ├── dev-workflow.md
│   └── create-checkpoint.md
├── decisions/
│   ├── 001-supabase-stack.md
│   ├── 002-siwe-auth.md
│   ├── 003-usdc-eip3009.md
│   ├── 004-no-buyer-accounts.md
│   ├── 005-dual-agent-files.md
│   └── 006-agnostic-folder-structure.md
AGENTS.md                    # Generic agent instructions
CLAUDE.md                    # Claude-specific instructions + pointers
```

---

## Rules Content

### security.md (STRICT)

These rules must never be broken.

- Never commit `.env` files, API keys, private keys, or secrets
- Use environment variables for all sensitive config
- Never log sensitive data (wallet addresses OK, private keys never)
- Supabase anon key is public, service role key is secret
- Never expose Supabase service role key to client-side code
- Always add sensitive files to `.gitignore` before creating them

### scope.md (STRICT)

These rules must never be broken.

- Only implement what's explicitly requested
- No "while I'm here" improvements
- No premature abstractions (3 similar lines > unnecessary helper)
- No feature flags or backwards-compatibility shims
- No adding comments, docstrings, or types to code you didn't change
- If unsure whether something is in scope, ask

### decisions.md (STRICT)

These design decisions have been made. Do not re-litigate or deviate without explicit approval.

- Use USDC, not ETH (no price conversion logic)
- Use EIP-3009 transferWithAuthorization, not Permit
- Use SIWE for seller auth, not email/password
- Use Supabase for everything (DB, auth, storage), not separate services
- Buyer pays gas, no relayer/paymaster
- No cart, no buyer accounts, no multi-step checkout
- Telegram link-out for communication, no in-app messaging

See `docs/decisions/` for full rationale on each decision.

### style.md (ADVISORY)

Follow these conventions. Deviation is acceptable with good reason.

- TypeScript strict mode
- Functional components with hooks
- File naming: kebab-case for files, PascalCase for components
- Use absolute imports with `@/` prefix, no relative imports (e.g., `@/components/Button`, not `../../components/Button`)
- Colocate tests with source files
- Prefer named exports over default exports

### workflow.md (ADVISORY)

Follow these practices. Deviation is acceptable with good reason.

- Run `pnpm lint` before committing
- Write tests for business logic
- Small commits with descriptive messages
- Create checkpoint after each logical piece of work
- Don't push directly to main
- Update "Current Status" in both CLAUDE.md and AGENTS.md when completing phases

---

## Skills Content

### add-page.md (Template)

**When to use:** When creating a new route in the app (e.g., /seller/orders)

**Structure:**
```
src/app/[route]/page.tsx     # The page component
src/app/[route]/loading.tsx  # Loading state (optional)
src/app/[route]/error.tsx    # Error boundary (optional)
```

**Template:**
```tsx
import { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'Page Title | Ultra-Simple Commerce',
}

export default function PageName() {
  return (
    <main>
      {/* Page content */}
    </main>
  )
}
```

**Checklist:**
- [ ] Uses `@/` absolute imports
- [ ] Exports metadata for SEO
- [ ] Handles loading/error states if data fetching
- [ ] Follows existing page patterns in codebase

### add-supabase-table.md (Checklist)

**When to use:** When adding a new table or modifying the database schema

**Steps:**
1. Add migration in `supabase/migrations/[timestamp]_[description].sql`
2. Define TypeScript types in `src/types/database.ts`
3. Create RLS policies (default deny, explicit allow)
4. Regenerate types: `pnpm supabase gen types typescript --local > src/types/supabase.ts`
5. Test query in Supabase dashboard first

**RLS Policy Patterns:**
- Sellers: can only access own records (wallet_address match)
- Products: public read, seller-only write
- Orders: buyer sees own (by email), seller sees own products' orders

**Template migration:**
```sql
-- Create table
create table table_name (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz default now()
);

-- Enable RLS
alter table table_name enable row level security;

-- Create policies
create policy "Description" on table_name
  for select using (condition);
```

### add-wagmi-hook.md (Template)

**When to use:** When adding contract calls or wallet signing

**Principles:**
- Use wagmi hooks, don't call ethers/viem directly
- Handle all connection states (connecting, disconnected, wrong network)
- Always show transaction status to user
- Use the USDC contract address from environment variables

**Template for contract write:**
```tsx
import { useContractWrite, useWaitForTransaction } from 'wagmi'

export function usePayment() {
  const { write, data, isLoading: isWriteLoading } = useContractWrite({
    // contract config
  })

  const { isLoading: isTxLoading, isSuccess } = useWaitForTransaction({
    hash: data?.hash,
  })

  return {
    pay: write,
    isLoading: isWriteLoading || isTxLoading,
    isSuccess,
  }
}
```

**Checklist:**
- [ ] Handles wallet not connected state
- [ ] Handles wrong network state
- [ ] Shows pending transaction state
- [ ] Shows success/error result
- [ ] Uses environment variables for contract addresses

### dev-workflow.md (Checklist)

**When to use:** Reference for common development commands

**Start working:**
```bash
pnpm install          # Install dependencies
pnpm dev              # Start dev server (localhost:3000)
pnpm supabase start   # Start local Supabase (if needed)
```

**Before committing:**
```bash
pnpm lint             # Check for linting issues
pnpm typecheck        # Verify TypeScript types
pnpm test             # Run tests
```

**Environment setup:**
1. Copy `.env.example` to `.env.local`
2. Fill in required values (see .env.example for descriptions)
3. Never commit `.env.local`

**Supabase commands:**
```bash
pnpm supabase start   # Start local instance
pnpm supabase stop    # Stop local instance
pnpm supabase db reset # Reset to clean state
pnpm supabase gen types typescript --local > src/types/supabase.ts
```

### create-checkpoint.md (Checklist)

**When to use:** After completing a logical piece of work, before moving to next task

**Steps:**
1. Verify the work:
   ```bash
   pnpm lint && pnpm typecheck && pnpm test
   ```
2. Stage only relevant files (not unrelated changes):
   ```bash
   git add [specific files]
   ```
3. Write descriptive commit message:
   ```bash
   git commit -m "feat: description of what was added"
   ```
4. Update "Current Status" section in both CLAUDE.md and AGENTS.md if completing a phase
5. Summarize for human review:
   - What was done
   - What was tested
   - What's next
   - Any decisions made or questions that arose

**Commit message prefixes:**
- `feat:` - New feature
- `fix:` - Bug fix
- `refactor:` - Code change that neither fixes nor adds
- `docs:` - Documentation only
- `test:` - Adding tests
- `chore:` - Maintenance tasks

---

## ADR Format

Each ADR follows this structure:

```markdown
# ADR-NNN: Title

## Status
Accepted | Superseded | Deprecated

## Context
What problem were we solving? What constraints existed?

## Decision
What we chose and why.

## Alternatives Considered
What else we looked at and why we rejected it.

## Consequences
What this decision enables or limits.
```

---

## ADRs to Create

### ADR-001: Full Supabase Stack

**Context:** Need database, auth, file storage, and realtime capabilities. Original plan used Prisma + NextAuth + separate image hosting.

**Decision:** Use Supabase for all backend needs (Postgres DB, Auth, Storage, Realtime).

**Alternatives Considered:**
- Prisma + NextAuth + S3: More control but more integration work
- Firebase: Good DX but less SQL-friendly
- Custom backend: Maximum control but unnecessary complexity for MVP

**Consequences:**
- Single platform reduces integration complexity
- Vendor lock-in to Supabase
- Built-in RLS for security
- May need to migrate if scaling beyond Supabase limits

### ADR-002: SIWE for Seller Auth

**Context:** Sellers need to authenticate to manage products. Traditional email/password requires password management, recovery flows, etc.

**Decision:** Use Sign-In with Ethereum (SIWE). Wallet address = identity = payment address.

**Alternatives Considered:**
- Email/password: Familiar but adds complexity (password reset, verification)
- OAuth (Google, etc.): Easy but disconnected from crypto identity
- Email magic links: Simpler than password but still separate from wallet

**Consequences:**
- No password recovery needed (wallet is the auth)
- Sellers must have a wallet to use the platform
- Payment address is automatically known
- Slightly higher barrier to entry for non-crypto-native sellers

### ADR-003: USDC with EIP-3009

**Context:** Need to accept crypto payments. ETH price volatility makes pricing difficult. Need a simple transfer mechanism.

**Decision:** Accept USDC only, using EIP-3009 `transferWithAuthorization` for payments.

**Alternatives Considered:**
- ETH payments: Native but volatile, requires price conversion
- USDC with Permit (EIP-2612): Similar but less suited to third-party transfers
- Custom payment contract: More control but adds smart contract risk and maintenance

**Consequences:**
- 1:1 pricing with USD (no conversion needed)
- No custom smart contracts to audit or maintain
- Buyer pays gas (no relayer complexity)
- Limited to USDC-supported chains

### ADR-004: No Buyer Accounts

**Context:** Traditional e-commerce requires buyer accounts for order history, saved addresses, etc. This adds friction.

**Decision:** Guest checkout only. Buyers provide email and shipping address per order.

**Alternatives Considered:**
- Optional accounts: More features but scope creep
- Wallet-based buyer accounts: Consistent with seller auth but adds complexity
- Email-based accounts: Familiar but adds auth flows

**Consequences:**
- Minimal friction for buyers
- No order history feature (buyers track via email)
- No saved addresses (must re-enter each time)
- Simpler data model and auth logic

### ADR-005: Dual Agent Files

**Context:** The project explores human-agent collaboration. We may use different AI tools over time. Need instructions that work across tools.

**Decision:** Maintain two files:
- `AGENTS.md` - Generic instructions any AI tool can use
- `CLAUDE.md` - Claude Code-specific instructions and pointers

**Alternatives Considered:**
- CLAUDE.md only: Simpler but locks us to one tool
- AGENTS.md only: More portable but loses Claude-specific features (skills invocation)

**Consequences:**
- Can switch or compare AI tools easily
- Small maintenance overhead keeping both in sync
- CLAUDE.md can reference Claude-specific features

### ADR-006: Tool-Agnostic Folder Structure

**Context:** Different AI tools use different conventions (`.claude/`, `.cursor/`, etc.). We want rules and skills that work regardless of tool.

**Decision:** Store all rules and skills in `docs/` folder. Reference from AGENTS.md and CLAUDE.md.

**Alternatives Considered:**
- `.claude/` folder: Auto-discovered by Claude Code but tool-specific
- `.ai/` with symlinks: Generic but symlinks are fragile across platforms
- Duplicate per tool: Native format but maintenance burden

**Consequences:**
- Rules/skills visible in normal file browsing
- Works with any AI tool that reads markdown
- No auto-discovery; must be referenced explicitly
- Easy to version control and review

---

## AGENTS.md Structure

```markdown
# AGENTS.md

## Project Overview
[Same as CLAUDE.md - what this is, meta-goal]

## Current Status
[Current phase, what's being worked on]

## Quick Reference
[Key commands, file locations]

## Tech Stack
[Technologies with versions]

## Rules
[Pointers to docs/rules/]

## Skills
[Pointers to docs/skills/]

## Key Decisions
[Pointers to docs/decisions/]
```

---

## CLAUDE.md Updates

Add to existing CLAUDE.md:

1. **Quick Reference section** - Commands, file locations
2. **Tech Stack with versions** - Specific versions to use
3. **Rules section** - Brief summary + pointers to docs/rules/
4. **Skills section** - List of skills + when to use + pointers to docs/skills/
5. **Update Current Status** - Reflect Phase 0 completion when done

---

## Implementation Checklist

- [ ] Create `docs/rules/security.md`
- [ ] Create `docs/rules/scope.md`
- [ ] Create `docs/rules/decisions.md`
- [ ] Create `docs/rules/style.md`
- [ ] Create `docs/rules/workflow.md`
- [ ] Create `docs/skills/add-page.md`
- [ ] Create `docs/skills/add-supabase-table.md`
- [ ] Create `docs/skills/add-wagmi-hook.md`
- [ ] Create `docs/skills/dev-workflow.md`
- [ ] Create `docs/skills/create-checkpoint.md`
- [ ] Create `docs/decisions/001-supabase-stack.md`
- [ ] Create `docs/decisions/002-siwe-auth.md`
- [ ] Create `docs/decisions/003-usdc-eip3009.md`
- [ ] Create `docs/decisions/004-no-buyer-accounts.md`
- [ ] Create `docs/decisions/005-dual-agent-files.md`
- [ ] Create `docs/decisions/006-agnostic-folder-structure.md`
- [ ] Create `AGENTS.md`
- [ ] Update `CLAUDE.md` with new sections
- [ ] Commit all changes

---

## Deliverable

A repo where:
1. Any AI tool can read AGENTS.md and understand the project
2. Claude Code gets Claude-specific guidance via CLAUDE.md
3. Rules prevent common mistakes (security, scope creep, breaking decisions)
4. Skills standardize repetitive workflows
5. ADRs explain why decisions were made so agents don't re-litigate
