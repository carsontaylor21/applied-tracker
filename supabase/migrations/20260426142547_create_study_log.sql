-- Daily study log: one row per (user, date)
create table public.study_log (
  user_id    uuid not null references auth.users(id) on delete cascade default auth.uid(),
  date       date not null,
  am_anki    boolean not null default false,
  read_done  boolean not null default false,
  new_cards  boolean not null default false,
  photos     boolean not null default false,
  qbank      boolean not null default false,
  energy     int    check (energy between 1 and 5),
  journal    text,
  updated_at timestamptz not null default now(),
  primary key (user_id, date)
);

-- Auto-update updated_at on row change
create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

create trigger study_log_touch
  before update on public.study_log
  for each row execute function public.touch_updated_at();

-- Row Level Security: each user only sees their own rows
alter table public.study_log enable row level security;

create policy "users read own logs"
  on public.study_log for select
  using (auth.uid() = user_id);

create policy "users insert own logs"
  on public.study_log for insert
  with check (auth.uid() = user_id);

create policy "users update own logs"
  on public.study_log for update
  using (auth.uid() = user_id);

create policy "users delete own logs"
  on public.study_log for delete
  using (auth.uid() = user_id);