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
