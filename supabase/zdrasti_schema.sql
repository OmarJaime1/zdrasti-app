
-- USERS table
create table if not exists users (
    id uuid primary key references auth.users(id) on delete cascade,
    name text,
    email text,
    safe_mode boolean default false,
    native_language text,
    current_level text, -- CEFR level: A1, A2, ..., C2
    xp_total int default 0,
    streak int default 0,
	last_activity_date date;
    donation_status text,
    last_certificate_link text,
    last_writing_attempt timestamptz, 
    created_at timestamptz default now()
);


-- USER SETTINGS table
create table if not exists user_settings (
    user_id uuid primary key references users(id) on delete cascade,
    reminder_frequency text default 'every_3_days',
    reminder_window text default '08:00–10:00',
    kuker_notifications boolean default true,
    safe_mode boolean default false
);

-- LESSONS table
create table if not exists lessons (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references users(id) on delete cascade,
    lesson_id text not null,
    level text,
    completed boolean default false,
    score int,
    flawless boolean default false,
    failed_attempts int default 0,
    created_at timestamptz default now()
);

-- BOOSTERS table
create table if not exists boosters (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references users(id) on delete cascade,
    word text,
    strength int default 0,
    last_seen date,
    created_at timestamptz default now()
);

-- CHAT_HISTORY table
create table if not exists chat_history (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references users(id) on delete cascade,
    timestamp timestamptz default now(),
    xp_earned int default 0,
    messages jsonb
);

-- CERTIFICATES table
create table if not exists certificates (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references users(id) on delete cascade,
    level text,
    passed_on date,
    link_to_pdf text,
    writing_feedback text,
    created_at timestamptz default now()
);

-- USER SETTINGS table
create table if not exists user_settings (
    user_id uuid primary key references users(id) on delete cascade,
    reminder_frequency text default 'every_3_days',
    reminder_window text default '08:00–10:00',
    kuker_notifications boolean default true,
    updated_at timestamptz default now()
);

--Boss Battle table
CREATE TABLE boss_results (
  user_id UUID REFERENCES users(id),
  boss_id TEXT NOT NULL,
  passed BOOLEAN NOT NULL DEFAULT false,
  xp_awarded BOOLEAN NOT NULL DEFAULT false,
  PRIMARY KEY (user_id, boss_id)
);

create table kuker_customization (
  user_id uuid primary key references auth.users(id),
  mask text not null,
  horns text not null,
  costume text not null,
  accessory text not null,
  expression text not null,
  shoes text not null,
  updated_at timestamptz default now()
);

create table unlocked_items (
  user_id uuid references auth.users(id),
  item_id text not null, -- e.g. 'mask_01', 'horns_03'
  unlocked_at timestamptz default now(),
  primary key (user_id, item_id)
);

create table kuker_items (
  id text primary key,             -- 'mask_01'
  category text not null,          -- 'Mask'
  asset_path text not null,        -- 'mask/mask_01.png'
  xp_required int default 0,
  rarity text default 'common',    -- 'common', 'rare', etc.
  source text default 'base',      -- 'base', 'event', 'donation'
  created_at timestamptz default now()
);

create table if not exists user_xp_monthly (
  user_id uuid references users(id) on delete cascade,
  month_year text not null, -- format: '2025-05'
  xp_by_day jsonb default '{}', -- example: {"24": {"base": 50, "streak": 10}}
  primary key (user_id, month_year)
);
