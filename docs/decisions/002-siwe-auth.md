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
