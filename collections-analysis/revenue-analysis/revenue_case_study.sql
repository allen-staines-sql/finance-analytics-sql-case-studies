Return on Advertising Spend (ROAS) – Measure conversion spends to revenue
-	SQL Query Used :
o	SELECT
o	    SUM(revenue) AS total_revenue,
o	    SUM(ad_spend) AS total_spend,
o	    SUM(revenue) / SUM(ad_spend) AS roas
o	FROM sales_data;
Funnel Efficiency Analysis (Impressions → Clicks → Sales) – Evaluates customer engagement and actual purchase rate
-	SQL Query Used :
o	SELECT
o	    category,
o	    SUM(impressions) AS impressions,
o	    SUM(clicks) AS clicks,
o	    SUM(units_sold) AS units_sold,
o	    ROUND(SUM(clicks)/SUM(impressions)*100,2) AS ctr_pct,
o	    ROUND(SUM(units_sold)/SUM(clicks)*100,2) AS conversion_pct
o	FROM sales_data
o	GROUP BY category;
Revenue Velocity (M-o-M Revenue Movement) – Revenue trends over time for consistency.
-	SQL Query Used : 
o	SELECT
o	    month,
o	    monthly_rev,
o	    LAG(monthly_rev) OVER (ORDER BY month) AS prev_month,
o	    ROUND( (monthly_rev - LAG(monthly_rev) OVER (ORDER BY month))
o	        / LAG(monthly_rev) OVER (ORDER BY month) * 100,2) AS mom_growth
o	FROM (
o	        SELECT
o	            DATE_FORMAT(transaction_date,'%Y-%m') AS month,
o	            SUM(revenue) AS monthly_rev
o	        FROM sales_data
o	        GROUP BY month
o	            ) t;
Discount Sensitivity Analysis - Assessed whether revenue growth is driven by pricing incentives or organic demand.
-	SQL Query Used :
o	SELECT
o	    category,
o	    CASE
o	        WHEN discount_applied = 0 THEN 'No Discount'
o	        WHEN discount_applied <= 10 THEN 'Low Discount'
o	        WHEN discount_applied <= 25 THEN 'Medium Discount'
o	        ELSE 'High Discount'
o	    END AS discount_band,
o	    SUM(units_sold) AS units_sold,
o	    SUM(revenue) AS revenue,
o	    ROUND(SUM(revenue)/SUM(units_sold),2) AS revenue_per_unit
o	FROM sales_data
o	GROUP BY category, discount_band;



