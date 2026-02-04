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
