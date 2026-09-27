-- 在 Supabase Dashboard → SQL Editor 中执行一次。
create table if not exists public.user_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.user_state enable row level security;
revoke all on table public.user_state from anon;
grant select, insert, update on table public.user_state to authenticated;

drop policy if exists "Users can read their own state" on public.user_state;
drop policy if exists "Users can insert their own state" on public.user_state;
drop policy if exists "Users can update their own state" on public.user_state;

create policy "Users can read their own state"
on public.user_state for select to authenticated
using ((select auth.uid()) = user_id);

create policy "Users can insert their own state"
on public.user_state for insert to authenticated
with check ((select auth.uid()) = user_id);

create policy "Users can update their own state"
on public.user_state for update to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);
