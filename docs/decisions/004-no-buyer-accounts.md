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
