-- One row per support ticket
create table public.tickets (
  id             bigint generated always as identity primary key,
  created_at     timestamptz not null default now(),
  name           text not null,
  email          text not null,
  message        text not null,
  category       text not null
                 check (category in ('technical_issue','billing','sales','general','spam')),
  urgency        text not null
                 check (urgency in ('low','medium','high')),
  priority_score int  not null check (priority_score between 1 and 10),
  summary        text,
  ai_ok          boolean not null default true
);

-- Lock the table: nothing can read or write it through the public API
alter table public.tickets enable row level security;
