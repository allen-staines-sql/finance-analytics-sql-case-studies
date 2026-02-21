Spend Volatility: Higher fluctuations would indicate unstable cash flow.
o	SQL query used:
o	select
o	    avg(amount) as avg_spend,
o	    stddev(amount) as spend_volatility
o	from finance_transactions;
Spend by Day (Behavioural Timing):
o	SQL query used:
o	select weekday,
o	       round(sum(amount),2) as total_spend
o	from finance_transactions
o	group by weekday
o	order by total_spend desc;
Spend by Category (Merchant split up spend):
o	SQL query used:
o	select merchant_type,
o	       round(sum(amount),2) as total_spend
o	from finance_transactions
o	group by merchant_type
o	order by total_spend desc;
Early Warning Signal (Daily spend):
o	SQL query used:
o	select transaction_date,
o	       weekday,
o	       sum(amount) as daily_spend
o	from finance_transactions
o	group by transaction_date, weekday
o	order by daily_spend desc;


