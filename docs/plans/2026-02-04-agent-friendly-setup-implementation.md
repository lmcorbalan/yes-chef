# Agent-Friendly Repo Setup - Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Set up the repo with rules, skills, ADRs, and agent instruction files so AI agents can work effectively without repeated context.

**Architecture:** Create markdown files organized in `docs/rules/`, `docs/skills/`, and `docs/decisions/`. Update root-level CLAUDE.md and create AGENTS.md. All content comes from the design document.

**Tech Stack:** Markdown files only (no code in this phase)

**Design Document:** `docs/plans/2026-02-04-agent-friendly-setup-design.md`

---

## Task 1: Create Folder Structure

**Files:**
- Create: `docs/rules/` (directory)
- Create: `docs/skills/` (directory)
- Create: `docs/decisions/` (directory)

**Step 1: Create directories**

```bash
mkdir -p docs/rules docs/skills docs/decisions
```

**Step 2: Verify structure**

```bash
ls -la docs/
```

Expected: `decisions/`, `plan/`, `plans/`, `rules/`, `sessions/`, `skills/` directories

**Step 3: Commit**

```bash
git add docs/rules/.gitkeep docs/skills/.gitkeep docs/decisions/.gitkeep 2>/dev/null || true
git status
```

Note: Empty directories won't be tracked by git. We'll commit with the first files.

---

## Task 2: Create STRICT Rules

**Files:**
- Create: `docs/rules/security.md`
- Create: `docs/rules/scope.md`
- Create: `docs/rules/decisions.md`

**Step 1: Create security.md**

```markdown
# Security Rules (STRICT)

These rules must never be broken.

## Secrets and Credentials

- Never commit `.env` files, API keys, private keys, or secrets
- Use environment variables for all sensitive config
- Always add sensitive files to `.gitignore` before creating them

## Logging

- Never log sensitive data
- Wallet addresses are OK to log
- Private keys, API keys, and passwords must never be logged

## Supabase Specifics

- Supabase anon key is public (safe to expose in client code)
- Supabase service role key is secret (server-side only, never in client code)
- Never expose Supabase service role key to client-side code

## Enforcement

Violations of these rules are blockers. Do not proceed if you detect a security issue - flag it immediately.
```

**Step 2: Create scope.md**

```markdown
# Scope Rules (STRICT)

These rules must never be broken.

## Stay Focused

- Only implement what's explicitly requested
- No "while I'm here" improvements
- If unsure whether something is in scope, ask

## No Over-Engineering

- No premature abstractions (3 similar lines of code is better than an unnecessary helper)
- No feature flags or backwards-compatibility shims
- No designing for hypothetical future requirements

## Code Hygiene Boundaries

- No adding comments, docstrings, or types to code you didn't change
- No reformatting code you didn't change
- No renaming variables in code you didn't change

## Enforcement

If you find yourself thinking "while I'm here, I should also..." - stop and ask first.
```

**Step 3: Create decisions.md**

```markdown
# Design Decisions (STRICT)

These design decisions have been made. Do not re-litigate or deviate without explicit approval.

## Payment

- Use USDC, not ETH (no price conversion logic needed)
- Use EIP-3009 `transferWithAuthorization`, not Permit
- Buyer pays gas (no relayer, no paymaster)

## Authentication

- Use SIWE (Sign-In with Ethereum) for seller auth, not email/password
- No buyer accounts (guest checkout only)

## Backend

- Use Supabase for everything (database, auth, storage), not separate services

## UX

- No cart (single product purchase flow)
- No multi-step checkout wizard
- Telegram link-out for communication (no in-app messaging)

## Rationale

See `docs/decisions/` for full ADRs explaining why each decision was made.

## Enforcement

If you think a decision should change, raise it explicitly. Do not quietly deviate.
```

**Step 4: Verify files created**

```bash
ls -la docs/rules/
```

Expected: `security.md`, `scope.md`, `decisions.md`

**Step 5: Commit**

```bash
git add docs/rules/security.md docs/rules/scope.md docs/rules/decisions.md
git commit -m "docs: add STRICT rules (security, scope, decisions)"
```

---

## Task 3: Create ADVISORY Rules

**Files:**
- Create: `docs/rules/style.md`
- Create: `docs/rules/workflow.md`

**Step 1: Create style.md**

```markdown
# Style Conventions (ADVISORY)

Follow these conventions. Deviation is acceptable with good reason.

## TypeScript

- Use TypeScript strict mode
- Prefer named exports over default exports
- Use explicit return types for functions

## React

- Functional components with hooks (no class components)
- Colocate tests with source files (`Component.tsx` + `Component.test.tsx`)

## Naming

- File naming: kebab-case (`user-profile.tsx`)
- Component naming: PascalCase (`UserProfile`)
- Function naming: camelCase (`getUserProfile`)

## Imports

- Use absolute imports with `@/` prefix
- Never use relative imports like `../../components/Button`
- Correct: `import { Button } from '@/components/Button'`

## File Organization

- Group by feature, not by type
- Keep files small and focused
- One component per file (with exceptions for tightly coupled small components)
```

**Step 2: Create workflow.md**

```markdown
# Workflow Practices (ADVISORY)

Follow these practices. Deviation is acceptable with good reason.

## Before Committing

- Run `pnpm lint` to check for linting issues
- Run `pnpm typecheck` to verify TypeScript types
- Run `pnpm test` to ensure tests pass

## Commits

- Small commits with descriptive messages
- Use conventional commit prefixes: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`
- Create a checkpoint after each logical piece of work

## Branching

- Don't push directly to main
- Create feature branches for work
- Use descriptive branch names (`feature/add-checkout`, `fix/wallet-connection`)

## Status Updates

- Update "Current Status" in both CLAUDE.md and AGENTS.md when completing phases
- Summarize what was done and what's next

## Code Review

- Self-review your changes before requesting human review
- Check for security issues, scope creep, and style violations
```

**Step 3: Verify files created**

```bash
ls -la docs/rules/
```

Expected: All 5 rule files present

**Step 4: Commit**

```bash
git add docs/rules/style.md docs/rules/workflow.md
git commit -m "docs: add ADVISORY rules (style, workflow)"
```

---

## Task 4: Create Skills

**Files:**
- Create: `docs/skills/add-page.md`
- Create: `docs/skills/add-supabase-table.md`
- Create: `docs/skills/add-wagmi-hook.md`
- Create: `docs/skills/dev-workflow.md`
- Create: `docs/skills/create-checkpoint.md`

**Step 1: Create add-page.md**

```markdown
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
```

**Step 2: Create add-supabase-table.md**

```markdown
# Adding a Supabase Table

**Type:** Checklist

**When to use:** When adding a new table or modifying the database schema

## Steps

1. **Create migration file**
   ```bash
   # File: supabase/migrations/[timestamp]_[description].sql
   touch supabase/migrations/$(date +%Y%m%d%H%M%S)_description.sql
   ```

2. **Write the migration**
   ```sql
   -- Create table
   create table table_name (
     id uuid primary key default gen_random_uuid(),
     created_at timestamptz default now()
   );

   -- Enable RLS (always!)
   alter table table_name enable row level security;

   -- Create policies
   create policy "Description" on table_name
     for select using (condition);
   ```

3. **Define TypeScript types**
   - Add types in `src/types/database.ts`

4. **Regenerate types**
   ```bash
   pnpm supabase gen types typescript --local > src/types/supabase.ts
   ```

5. **Test in Supabase dashboard**
   - Verify query works before using in code

## RLS Policy Patterns

| Table | Read | Write |
|-------|------|-------|
| sellers | Own record only (wallet_address match) | Own record only |
| products | Public | Seller only (seller_id match) |
| orders | Buyer (email match) or Seller (product owner) | Create: public, Update: seller only |

## Remember

- Always enable RLS on new tables
- Default deny - explicit allow
- Test policies before deploying
```

**Step 3: Create add-wagmi-hook.md**

```markdown
# Adding Wallet Interactions

**Type:** Template

**When to use:** When adding contract calls or wallet signing

## Principles

- Use wagmi hooks, don't call ethers/viem directly
- Handle all connection states (connecting, disconnected, wrong network)
- Always show transaction status to user
- Use environment variables for contract addresses

## Template: Contract Write

```tsx
import { useContractWrite, useWaitForTransaction } from 'wagmi'
import { parseUnits } from 'viem'

const USDC_ADDRESS = process.env.NEXT_PUBLIC_USDC_ADDRESS

export function usePayment() {
  const { write, data, isLoading: isWriteLoading, error: writeError } = useContractWrite({
    address: USDC_ADDRESS,
    abi: USDC_ABI,
    functionName: 'transferWithAuthorization',
  })

  const { isLoading: isTxLoading, isSuccess, error: txError } = useWaitForTransaction({
    hash: data?.hash,
  })

  return {
    pay: write,
    isLoading: isWriteLoading || isTxLoading,
    isSuccess,
    error: writeError || txError,
    txHash: data?.hash,
  }
}
```

## Checklist

- [ ] Handles wallet not connected state
- [ ] Handles wrong network state
- [ ] Shows pending transaction state
- [ ] Shows success/error result
- [ ] Uses environment variables for contract addresses
- [ ] Exposes transaction hash for verification
```

**Step 4: Create dev-workflow.md**

```markdown
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
```

**Step 5: Create create-checkpoint.md**

```markdown
# Creating a Checkpoint

**Type:** Checklist

**When to use:** After completing a logical piece of work, before moving to next task

## Steps

### 1. Verify the Work

```bash
pnpm lint && pnpm typecheck && pnpm test
```

All must pass before proceeding.

### 2. Stage Relevant Files

```bash
git add [specific files]
```

Only stage files related to this task. Don't include unrelated changes.

### 3. Write Commit Message

```bash
git commit -m "type: description"
```

Use conventional commit prefixes:
- `feat:` - New feature
- `fix:` - Bug fix
- `refactor:` - Code change that neither fixes nor adds
- `docs:` - Documentation only
- `test:` - Adding tests
- `chore:` - Maintenance tasks

### 4. Update Status (if completing a phase)

Update "Current Status" section in both:
- `CLAUDE.md`
- `AGENTS.md`

### 5. Summarize for Human Review

Provide:
- What was done
- What was tested
- What's next
- Any decisions made or questions that arose

## Example

```
Checkpoint: Added seller registration form

What was done:
- Created /seller/register page
- Added form for Telegram handle
- Integrated with SIWE auth

What was tested:
- Form validation (empty handle rejected)
- Successful registration creates seller record
- Duplicate wallet address shows error

What's next:
- Seller dashboard (Task 5)

Questions:
- None
```
```

**Step 6: Verify files created**

```bash
ls -la docs/skills/
```

Expected: All 5 skill files present

**Step 7: Commit**

```bash
git add docs/skills/
git commit -m "docs: add project skills (add-page, add-supabase-table, add-wagmi-hook, dev-workflow, create-checkpoint)"
```

---

## Task 5: Create ADRs

**Files:**
- Create: `docs/decisions/001-supabase-stack.md`
- Create: `docs/decisions/002-siwe-auth.md`
- Create: `docs/decisions/003-usdc-eip3009.md`
- Create: `docs/decisions/004-no-buyer-accounts.md`
- Create: `docs/decisions/005-dual-agent-files.md`
- Create: `docs/decisions/006-agnostic-folder-structure.md`

**Step 1: Create 001-supabase-stack.md**

```markdown
# ADR-001: Full Supabase Stack

## Status

Accepted

## Context

We need database, authentication, file storage, and potentially realtime capabilities for the MVP. The original plan considered using separate services:
- Prisma for database ORM
- NextAuth for authentication
- S3 or similar for image storage

This would require integrating multiple services and managing their interactions.

## Decision

Use Supabase for all backend needs:
- PostgreSQL database (with Prisma-like query builder)
- Built-in authentication
- Storage for product images
- Realtime subscriptions (if needed later)

## Alternatives Considered

**Prisma + NextAuth + S3**
- More control over each component
- But: More integration work, more services to manage

**Firebase**
- Good developer experience
- But: Less SQL-friendly, Firestore's query model is limiting

**Custom backend (Express/Fastify)**
- Maximum control
- But: Unnecessary complexity for an MVP

## Consequences

**Positive:**
- Single platform reduces integration complexity
- Built-in Row Level Security (RLS) for data protection
- Generous free tier for MVP development
- Good TypeScript support with generated types

**Negative:**
- Vendor lock-in to Supabase
- May need to migrate if scaling beyond Supabase limits
- Less flexibility than fully custom solution
```

**Step 2: Create 002-siwe-auth.md**

```markdown
# ADR-002: SIWE for Seller Auth

## Status

Accepted

## Context

Sellers need to authenticate to manage their products and view orders. Traditional email/password authentication requires:
- Password hashing and storage
- Password reset flow
- Email verification
- Session management

Since this is a crypto-native platform and sellers will receive payments to a wallet, tying identity to the wallet simplifies the architecture.

## Decision

Use Sign-In with Ethereum (SIWE) for seller authentication. The wallet address becomes:
- The seller's identity
- The seller's payment address
- The authentication credential

## Alternatives Considered

**Email/password**
- Familiar to users
- But: Adds complexity (password reset, verification emails)
- Disconnected from crypto identity

**OAuth (Google, GitHub)**
- Easy to implement
- But: Disconnected from crypto identity
- Sellers would still need to add a wallet address separately

**Email magic links**
- Simpler than password (no password reset)
- But: Still disconnected from wallet identity

## Consequences

**Positive:**
- No password recovery flows needed
- Payment address is automatically known
- Single identity (wallet) across the platform
- Crypto-native experience

**Negative:**
- Sellers must have a wallet to use the platform
- Slightly higher barrier for non-crypto-native sellers
- Wallet security becomes account security (no recovery if wallet lost)
```

**Step 3: Create 003-usdc-eip3009.md**

```markdown
# ADR-003: USDC with EIP-3009

## Status

Accepted

## Context

We need to accept cryptocurrency payments. Key considerations:
- Price stability (ETH volatility makes pricing difficult)
- User experience (gas fees, transaction complexity)
- Implementation simplicity (avoid custom smart contracts)

## Decision

Accept USDC only, using EIP-3009 `transferWithAuthorization` for payments.

**Why USDC:**
- 1:1 with USD (no price conversion needed)
- Widely held and understood
- Available on multiple chains

**Why EIP-3009:**
- Native USDC functionality (no custom contracts)
- Allows pre-authorized transfers with signatures
- Buyer signs authorization, then submits transaction
- No approve + transferFrom pattern needed

**Who pays gas:** Buyer submits the transaction and pays gas.

## Alternatives Considered

**ETH payments**
- Native and simple
- But: Volatile, requires price conversion and oracles

**USDC with Permit (EIP-2612)**
- Similar signature-based approach
- But: Designed for spender authorization, not direct transfers

**Custom payment contract**
- More control (could add escrow, batch payments)
- But: Smart contract risk, audit requirements, maintenance

**Relayer/Paymaster (gasless)**
- Better UX (seller or relayer pays gas)
- But: Significant complexity, cost to operate

## Consequences

**Positive:**
- No price conversion logic needed
- No custom smart contracts to audit or maintain
- Uses battle-tested USDC functionality
- Simple implementation

**Negative:**
- Buyer pays gas (may be unfamiliar to some)
- Limited to chains where USDC supports EIP-3009
- No escrow or dispute resolution
```

**Step 4: Create 004-no-buyer-accounts.md**

```markdown
# ADR-004: No Buyer Accounts

## Status

Accepted

## Context

Traditional e-commerce requires buyer accounts for:
- Order history
- Saved shipping addresses
- Wishlists
- Faster checkout

However, accounts add friction:
- Registration step before purchase
- Password management
- Another login to remember

Our goal is minimal friction.

## Decision

Guest checkout only. Buyers provide email and shipping address per order. No buyer accounts.

## Alternatives Considered

**Optional accounts**
- Best of both worlds (guest checkout + account benefits)
- But: Scope creep, complexity in auth and data model

**Wallet-based buyer accounts**
- Consistent with seller auth (SIWE)
- But: Many buyers may not have wallets
- Wallet just for identity feels heavy

**Email-based accounts**
- Familiar to users
- But: Adds registration flow, password management
- Increases friction

## Consequences

**Positive:**
- Minimal friction for buyers
- Simpler data model (no buyer table needed)
- Simpler auth (only sellers authenticate)
- Faster time to first purchase

**Negative:**
- No order history for buyers (they rely on email confirmations)
- No saved addresses (must re-enter each time)
- Can't implement wishlists or "buy again" features
- Harder to identify repeat customers
```

**Step 5: Create 005-dual-agent-files.md**

```markdown
# ADR-005: Dual Agent Files

## Status

Accepted

## Context

This project explores human-agent collaboration in software development. We may use different AI coding tools over time:
- Claude Code (Anthropic)
- Cursor
- GitHub Copilot
- Others

Each tool has its own conventions for reading project instructions. We want instructions that work across tools while preserving tool-specific features.

## Decision

Maintain two instruction files:
- `AGENTS.md` - Generic instructions any AI tool can use
- `CLAUDE.md` - Claude Code-specific instructions and pointers

Both files share core content (project overview, rules, skills) but CLAUDE.md can include Claude-specific features like skill invocation syntax.

## Alternatives Considered

**CLAUDE.md only**
- Simpler, one file
- But: Locks us to Claude Code

**AGENTS.md only**
- More portable
- But: Loses Claude-specific features (auto-loaded context, skill references)

**Tool-specific files only (.cursorrules, etc.)**
- Native experience per tool
- But: Content duplication, drift risk

## Consequences

**Positive:**
- Can switch or compare AI tools easily
- CLAUDE.md can reference Claude-specific features
- AGENTS.md serves as a portable baseline
- Easy to see what's generic vs tool-specific

**Negative:**
- Small maintenance overhead keeping both in sync
- Some duplication between files
- Must remember to update both when making changes
```

**Step 6: Create 006-agnostic-folder-structure.md**

```markdown
# ADR-006: Tool-Agnostic Folder Structure

## Status

Accepted

## Context

Different AI coding tools use different conventions for configuration:
- Claude Code: `.claude/` folder
- Cursor: `.cursor/rules/` or `.cursorrules`
- GitHub Copilot: `.github/copilot-instructions.md`

We want our rules and skills to work regardless of which tool is used.

## Decision

Store all rules and skills in the `docs/` folder:
- `docs/rules/` - Guardrails and conventions
- `docs/skills/` - Workflow templates and checklists
- `docs/decisions/` - Architecture Decision Records

Reference these from AGENTS.md and CLAUDE.md rather than using tool-specific hidden folders.

## Alternatives Considered

**`.claude/` folder**
- Auto-discovered by Claude Code
- But: Tool-specific, invisible to other tools

**`.ai/` folder with symlinks**
- Generic naming
- But: Symlinks are fragile across platforms (Windows issues)
- Some tools might not follow symlinks

**Duplicate per tool**
- Native format for each tool
- But: Maintenance burden, content drift risk

## Consequences

**Positive:**
- Rules and skills visible in normal file browsing (no hidden folders)
- Works with any AI tool that can read markdown
- Easy to version control and review
- No symlink complexity

**Negative:**
- No auto-discovery magic (must be explicitly referenced)
- Requires pointing tools to docs/ via their instruction files
- Slightly more verbose setup in CLAUDE.md and AGENTS.md
```

**Step 7: Verify files created**

```bash
ls -la docs/decisions/
```

Expected: All 6 ADR files present

**Step 8: Commit**

```bash
git add docs/decisions/
git commit -m "docs: add Architecture Decision Records (ADR-001 through ADR-006)"
```

---

## Task 6: Create AGENTS.md

**Files:**
- Create: `AGENTS.md`

**Step 1: Create AGENTS.md**

```markdown
# AGENTS.md

Instructions for AI coding assistants working on this project.

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

## Key Documents

- `docs/plans/2026-02-03-brainstormed-design.md` - Full technical design
- `docs/sessions/` - Session logs with context on past decisions
```

**Step 2: Verify file created**

```bash
cat AGENTS.md | head -20
```

**Step 3: Commit**

```bash
git add AGENTS.md
git commit -m "docs: add AGENTS.md for generic AI tool instructions"
```

---

## Task 7: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

**Step 1: Read current CLAUDE.md**

```bash
cat CLAUDE.md
```

Review the current content to understand what sections exist.

**Step 2: Update CLAUDE.md**

Replace the entire file with updated content that includes:
- Quick Reference section
- Tech Stack with versions
- Rules section with pointers
- Skills section with pointers
- Updated Current Status

```markdown
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
```

**Step 3: Verify changes**

```bash
cat CLAUDE.md | head -30
```

**Step 4: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md with rules, skills, and status sections"
```

---

## Task 8: Final Verification and Summary

**Step 1: Verify all files exist**

```bash
echo "=== Rules ===" && ls docs/rules/
echo "=== Skills ===" && ls docs/skills/
echo "=== Decisions ===" && ls docs/decisions/
echo "=== Root files ===" && ls -la AGENTS.md CLAUDE.md
```

Expected:
- 5 rule files
- 5 skill files
- 6 ADR files
- AGENTS.md and CLAUDE.md present

**Step 2: Verify git log**

```bash
git log --oneline -10
```

Expected: Commits for each task

**Step 3: Create summary for human review**

Summarize:
- What was done (all files created)
- What was tested (file existence verified)
- What's next (Phase 1: Foundation)
- Any questions that arose

---

## Deliverable

After completing all tasks:

- 5 rule files in `docs/rules/`
- 5 skill files in `docs/skills/`
- 6 ADR files in `docs/decisions/`
- `AGENTS.md` created
- `CLAUDE.md` updated
- All changes committed on `feature/agent-friendly-setup` branch

Ready for merge to main and proceeding to Phase 1.
