Weighted DSO by Industry : For accurate calculation of DSO eliminating variances in NET terms, Invoice amount.
o	SQL Query used :
o	SELECT
o	    industry,
o	    SUM(invoice_amount * delay_days) / SUM(invoice_amount) AS weighted_dso
o	FROM (
o	    SELECT
o	        industry,
o	        invoice_amount,
o	        DATEDIFF(payment_date, invoice_date) AS delay_days
o	    FROM oracle_ar
o	    WHERE payment_date IS NOT NULL
o	           ) t
o	GROUP BY industry;
Aging Risk Distribution :  To identify the cash in age buckets, and understand the risk assocaited with it.
o	SQL Query used :
o	SELECT
o	    age_bucket,
o	    SUM(invoice_amount) AS total_ar,
o	    ROUND(
o	        SUM(invoice_amount) / SUM(SUM(invoice_amount)) OVER () * 100,
o	        2
o	    ) AS open_ar_pct
o	FROM oracle_ar
o	WHERE payment_date IS NULL
o	GROUP BY age_bucket;
Pareto Analysis (Customer concentration) : Helps to prioritize Collection efforts and manage resources.
o	SQL Query Used :
o	SELECT
o	    customer_name,
o	    total_ar,
o	    RANK() OVER (ORDER BY total_ar DESC) AS risk_rank,
o	    SUM(total_ar) OVER (ORDER BY total_ar DESC) AS cumu_exp,
o	    ROUND(
o	        SUM(total_ar) OVER (ORDER BY total_ar DESC)  / SUM(total_ar) OVER () * 100, 2
o	    ) AS cumu_pct
o	FROM (
o	        SELECT
o	            customer_name,
o	            SUM(invoice_amount) AS total_ar
o	        FROM oracle_ar
o	        WHERE payment_date IS NULL
o	        GROUP BY customer_name
o	            ) t;
Chronic Late-Payer Identification : Used to identify structural payment issues rather than isolated incidents.
o	SQL Query Used :
o	SELECT
o	    customer_name,
o	    COUNT(*) AS overdue_invoices,
o	    ROUND(
o	        AVG(DATEDIFF(COALESCE(payment_date, CURDATE()), due_date)),  1
o	                  ) AS avg_delay_days,
o	    SUM(invoice_amount) AS overdue_exposure
o	FROM oracle_ar
o	WHERE DATEDIFF(COALESCE(payment_date, CURDATE()), due_date) > 0
o	GROUP BY customer_name;
