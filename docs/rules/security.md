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
