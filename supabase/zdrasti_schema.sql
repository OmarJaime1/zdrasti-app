
-- User progress
create table user_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  xp integer default 0,
  streak integer default 0,
  last_login date,
  goal text,
  inserted_at timestamp default now()
);

-- Lesson log
create table lesson_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  lesson_key text,
  completed_at timestamp default now(),
  score integer
);
