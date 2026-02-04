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
