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
