
-- ================== VERSÃO ANALISANDO APENAS O ÚLTIMO ANO ==================

USE RETAIL_SALES

DECLARE @today_date AS DATE = '2024-01-01';

WITH base AS (
  SELECT
	DATEPART(yyyy, sale_date) AS year,
	customer_id,
	DATEDIFF(day, MAX(sale_date), @today_date) AS recency,
	COUNT(transactions_id) AS frequency,
	SUM(total_sale) AS monetary
	FROM RETAIL_SALES
	WHERE YEAR(sale_date) = 2022
	GROUP BY DATEPART(yyyy, sale_date), customer_id
)

SELECT
  year,
  customer_id,
  recency,
  frequency,
  monetary,

  -- Score de Recência: quanto menor, melhor
  CASE
    WHEN recency <= 30 THEN 5
    WHEN recency <= 60 THEN 4
    WHEN recency <= 90 THEN 3
    WHEN recency <= 180 THEN 2
    ELSE 1
  END AS R,

  -- Score de Frequência: quanto maior, melhor
  CASE
    WHEN frequency > 15 THEN 5
    WHEN frequency >= 13 THEN 4
    WHEN frequency >= 10 THEN 3
    WHEN frequency >= 7 THEN 2
    ELSE 1
  END AS F_score,

  -- Score Monetário: quanto maior, melhor
  CASE
    WHEN monetary > 7500 THEN 5
    WHEN monetary >= 7500 THEN 4
    WHEN monetary >= 5000 THEN 3
    WHEN monetary >= 2500 THEN 2
    ELSE 1
  END AS M_score

FROM base;
