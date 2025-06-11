USE RETAIL_SALES;

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

    NTILE(5) OVER (ORDER BY recency ASC) AS R_score,
    NTILE(5) OVER (ORDER BY frequency DESC) AS F_score,
    NTILE(5) OVER (ORDER BY monetary DESC) AS M_score
  FROM base
),

rfm_segmentado AS (
  SELECT *,
    CAST(R_score AS VARCHAR) + CAST(F_score AS VARCHAR) + CAST(M_score AS VARCHAR) AS RFM_Grupo
  FROM rfm_ranked
)

SELECT *,
  CASE
    WHEN R_score = 5 AND F_score >= 4 AND M_score >= 4 THEN 'Champions'
    WHEN F_score >= 4 AND M_score >= 3 THEN 'Loyal Customers'
    WHEN R_score >= 4 AND F_score >= 3 THEN 'Potential Loyalist'
    WHEN R_score >= 4 AND F_score <= 2 THEN 'Promising'
    WHEN R_score = 5 AND F_score = 1 THEN 'New Customers'
    WHEN R_score <= 3 AND F_score <= 2 THEN 'About to Sleep'
    WHEN R_score = 1 AND F_score <= 2 AND M_score <= 2 THEN 'Hibernating'
    WHEN R_score <= 3 AND F_score >= 3 AND M_score >= 3 THEN 'Need Attention'
    WHEN R_score <= 2 AND F_score >= 4 AND M_score >= 4 THEN 'At Risk'
    WHEN R_score = 1 AND F_score = 5 AND M_score = 5 THEN 'Cannot Lose Them'
    WHEN R_score = 1 AND F_score = 1 AND M_score = 1 THEN 'Lost Customers'
    ELSE
      -- Se nenhum dos anteriores, vamos classificar baseado em:
      CASE
        WHEN R_score >= 4 THEN 'Potential Loyalist'
        WHEN F_score >= 3 THEN 'Loyal Customers'
        WHEN M_score >= 3 THEN 'Need Attention'
        ELSE 'Hibernating'
      END
  END AS Segmento
FROM rfm_segmentado
ORDER BY customer_id;
