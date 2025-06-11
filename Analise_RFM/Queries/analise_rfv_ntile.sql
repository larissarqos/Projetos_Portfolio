USE RETAIL_SALES

DECLARE @today_date AS DATE = '2024-01-01';

WITH base AS (
  SELECT
    customer_id,
	DATEDIFF(day, MAX(sale_date), @today_date) AS recency,
    COUNT(transactions_id) AS frequency,
    SUM(total_sale) AS monetary
  FROM RETAIL_SALES
  WHERE YEAR(sale_date) = (SELECT MAX(YEAR(sale_date)) FROM RETAIL_SALES)
  GROUP BY customer_id
),

rfm_ranked AS (
  SELECT
    customer_id,
    recency,
    frequency,
    monetary,

    -- Quanto menor a recência, melhor: invertido
    NTILE(5) OVER (ORDER BY recency DESC) AS R_score,

    -- Quanto maior a frequência, melhor
    NTILE(5) OVER (ORDER BY frequency ASC) AS F_score,

    -- Quanto maior o valor monetário, melhor
    NTILE(5) OVER (ORDER BY monetary ASC) AS M_score

  FROM base
)

SELECT *,
	(R_score + F_score + M_score) /3 AS RFM
FROM rfm_ranked
ORDER BY customer_id
