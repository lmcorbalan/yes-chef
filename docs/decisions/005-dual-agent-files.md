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
