-- Summary views the public dashboard reads. The tickets table itself stays locked.

-- 1. Headline numbers
create view public.ticket_stats as
select
  count(*)                                                       as total_tickets,
  count(*) filter (where created_at > now() - interval '7 days') as this_week,
  count(*) filter (where urgency = 'high')                       as urgent,
  round(avg(priority_score), 1)                                  as avg_priority
from public.tickets;

-- 2. Tickets per category
create view public.tickets_by_category as
select category, count(*) as tickets
from public.tickets
group by category
order by tickets desc;

-- 3. Tickets per day, last 30 days
create view public.tickets_per_day as
select date(created_at) as day, count(*) as tickets
from public.tickets
where created_at > now() - interval '30 days'
group by day
order by day;

-- 4. Recent urgent tickets (no names or emails)
create view public.recent_urgent as
select created_at, category, priority_score, summary
from public.tickets
where urgency = 'high'
order by created_at desc
limit 5;

-- The public (anon) role can read ONLY these four views
grant select on public.ticket_stats, public.tickets_by_category,
                public.tickets_per_day, public.recent_urgent to anon;
