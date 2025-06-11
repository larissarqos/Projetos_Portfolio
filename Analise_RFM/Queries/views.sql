
-- ========== CRIANDO VIEWS ========== 

-- == VIEW COM INFORMAÇÕES DOS CLIENTES
IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'VW_CUSTOMER' AND TYPE = 'V')
	BEGIN
		DROP VIEW VW_CUSTOMER
	END
GO

CREATE VIEW VW_CUSTOMERS AS
SELECT
	DISTINCT customer_id,
	gender,
	age_range
FROM RETAIL_SALES


-- == VIEW COM INFORMAÇÕES DAS VENDAS
IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'VW_SALES' AND TYPE = 'V')
	BEGIN
		DROP VIEW VW_SALES
	END
GO

CREATE VIEW VW_SALES AS
SELECT
	transactions_id,
	sale_date,
	sale_time,
	customer_id,
	category,
	quantity,
	price_per_unit,
	cogs,
	total_sale,
	profit
FROM RETAIL_SALES


-- == VIEW DA SEGMENTAÇÃO RFM

IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'VW_RFM_SCORE' AND TYPE = 'V')
	BEGIN
		DROP VIEW VW_RFM_SCORE
	END
GO
CREATE VIEW VW_RFM_SCORE AS
WITH base AS (
	SELECT
		customer_id,
		DATEDIFF(day, MAX(sale_date),'2024-01-01') AS recency,
		COUNT(transactions_id) AS frequency,
		SUM(total_sale) AS monetary
	FROM RETAIL_SALES
	WHERE YEAR(sale_date) = (SELECT MAX(YEAR(sale_date)) FROM RETAIL_SALES)
	GROUP BY customer_id
),

rfm_score AS (
	SELECT
		customer_id,
		recency,
		frequency,
		monetary,

	NTILE(5) OVER (ORDER BY recency DESC) AS R_score,
	NTILE(5) OVER (ORDER BY frequency ASC) AS F_score,
	NTILE(5) OVER (ORDER BY monetary ASC) AS M_score
	FROM base
),

rfm AS (
  SELECT *,
    CAST(R_score AS VARCHAR) + CAST(F_score AS VARCHAR) + CAST(M_score AS VARCHAR) AS RFM
  FROM rfm_score
)

SELECT *,
  CASE
    WHEN R_score = 5 AND F_score = 5 AND M_score = 5 THEN 'Champions'
    WHEN R_score >= 4 AND F_score >= 4 AND M_score >= 4 THEN 'Loyal Customers'
    WHEN R_score >= 5 AND F_score BETWEEN 2 AND 3 AND M_score >= 3 THEN 'Potential Loyalists'
    WHEN R_score = 5 AND F_score <= 3 AND M_score <= 4 THEN 'Recent Customers'
    WHEN R_score >= 4 AND F_score <= 5 AND M_score <= 5 THEN 'Promising'
    WHEN R_score BETWEEN 2 AND 3 AND F_score BETWEEN 2 AND 4 AND M_score BETWEEN 2 AND 3 THEN 'Needs Attention'
    WHEN R_score = 2 AND F_score <= 3 AND M_score <= 3 THEN 'About to Sleep'
    WHEN R_score BETWEEN 2 AND 3 AND F_score >= 4 AND M_score >= 4 THEN 'At Risk'
    WHEN R_score <= 2 AND F_score BETWEEN 3 AND 4 AND M_score >= 4 THEN 'Cant Lose Them'
    WHEN R_score <= 2 AND F_score <= 2 AND M_score >= 2 THEN 'Hibernating'
    WHEN R_score = 1 AND F_score = 1 AND M_score = 1 THEN 'Lost'
    ELSE 'Others'
  END AS segment
FROM rfm
