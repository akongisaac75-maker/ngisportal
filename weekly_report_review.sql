-- NGIS Live: Weekly Report Cards -> Class Teachers (observation & recommendation)
-- Run ONCE in Supabase -> SQL Editor. Safe to run again.

create extension if not exists pgcrypto;

-- One row per class per week = "this week's report cards were sent to the class teacher"
create table if not exists weekly_report_dispatch(
  id uuid primary key default gen_random_uuid(),
  class_id text not null,
  week_id text not null,
  teacher_id text,
  teacher_name text,
  status text default 'sent',            -- sent | in_progress | completed
  auto boolean default false,            -- true when the app sent it automatically
  sent_by text,
  sent_by_name text,
  sent_at timestamptz default now(),
  teacher_seen boolean default false,
  seen_at timestamptz,
  completed_at timestamptz,
  unique(class_id, week_id));

-- The class teacher's observation & recommendation for each learner, per week
create table if not exists weekly_remarks(
  id uuid primary key default gen_random_uuid(),
  student_id text not null,
  class_id text,
  week_id text not null,
  observation text,
  recommendation text,
  teacher_id text,
  teacher_name text,
  updated_at timestamptz default now(),
  unique(student_id, week_id));

-- Small key/value settings (e.g. auto_send = on/off)
create table if not exists weekly_report_settings(
  key text primary key,
  value text,
  updated_at timestamptz default now());

create index if not exists idx_wrd_class on weekly_report_dispatch(class_id);
create index if not exists idx_wrd_week on weekly_report_dispatch(week_id);
create index if not exists idx_wrr_week on weekly_remarks(week_id);
create index if not exists idx_wrr_class on weekly_remarks(class_id);

alter table weekly_report_dispatch enable row level security;
alter table weekly_remarks enable row level security;
alter table weekly_report_settings enable row level security;

drop policy if exists "wrd_all" on weekly_report_dispatch;
drop policy if exists "wrr_all" on weekly_remarks;
drop policy if exists "wrs_all" on weekly_report_settings;
create policy "wrd_all" on weekly_report_dispatch for all using(true) with check(true);
create policy "wrr_all" on weekly_remarks for all using(true) with check(true);
create policy "wrs_all" on weekly_report_settings for all using(true) with check(true);

notify pgrst, 'reload schema';
