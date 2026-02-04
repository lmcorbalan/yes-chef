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
