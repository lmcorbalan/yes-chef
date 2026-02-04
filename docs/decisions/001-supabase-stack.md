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
