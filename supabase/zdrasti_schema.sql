
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
    donation_status text,
    last_certificate_link text,
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