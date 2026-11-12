-- Add 150 realistic test tickets spread over the last 30 days
-- (fake names; @example.com is reserved for testing)
insert into public.tickets
  (created_at, name, email, message, category, urgency, priority_score, summary)
select
  now() - (random() * interval '30 days'),
  n.name,
  lower(replace(n.name, ' ', '.')) || '@example.com',
  t.message, t.category, t.urgency, t.score, t.summary
from generate_series(1, 150) as g
cross join lateral (
  select * from (values
    ('Our website is down and customers cannot order.', 'technical_issue', 'high', 9, 'Website outage blocking customer orders.'),
    ('Checkout page shows an error when paying by card.', 'technical_issue', 'high', 8, 'Card payments failing at checkout.'),
    ('I cannot log in to my account after resetting my password.', 'technical_issue', 'medium', 6, 'Login fails after password reset.'),
    ('The mobile site loads very slowly.', 'technical_issue', 'low', 4, 'Slow mobile site performance.'),
    ('Email notifications stopped arriving this week.', 'technical_issue', 'medium', 5, 'Order emails not being delivered.'),
    ('I was charged twice for the same order.', 'billing', 'high', 8, 'Duplicate charge on one order.'),
    ('Can I get a copy of last month''s invoice?', 'billing', 'low', 3, 'Customer requesting a past invoice.'),
    ('My refund has not shown up yet.', 'billing', 'medium', 6, 'Refund not received.'),
    ('Do you offer discounts for large orders?', 'sales', 'low', 3, 'Question about bulk pricing.'),
    ('We want to set up a weekly order for our office.', 'sales', 'medium', 5, 'Business interested in recurring orders.'),
    ('Can someone call me about a quote for an event?', 'sales', 'medium', 6, 'Event quote request.'),
    ('What are your holiday hours?', 'general', 'low', 2, 'Question about holiday hours.'),
    ('Do you deliver to Santa Monica?', 'general', 'low', 2, 'Delivery area question.'),
    ('How do I change my delivery address?', 'general', 'low', 3, 'Help updating delivery address.'),
    ('CLICK HERE to claim your free prize!!!', 'spam', 'low', 1, 'Spam message.')
  ) as t(message, category, urgency, score, summary)
  order by random() + g * 0
  limit 1
) as t
cross join lateral (
  select * from (values
    ('Dana Whitfield'), ('Marcus Lee'), ('Priya Shah'), ('Tom Becker'),
    ('Alicia Gomez'), ('Kevin Ortiz'), ('Hannah Brooks'), ('Sam Patel'),
    ('Rachel Kim'), ('Chris Nguyen'), ('Laura Chen'), ('Mike Russo')
  ) as n(name)
  order by random() + g * 0
  limit 1
) as n;
