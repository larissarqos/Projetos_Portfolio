
-- SELECT * FROM VW_RFM_SCORE


IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'VW_RFM_SCORE' AND TYPE = 'V')
	BEGIN
		DROP VIEW VW_RFM_SCORE
	END
GO

CREATE VIEW VW_RFM_SCORE AS
	WITH base AS (
        SELECT
            customer_id,
            DATEDIFF(DAY, MAX(sale_date), '2024-01-01') AS recency,
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
            NTILE(5) OVER (ORDER BY recency DESC) AS R_score,
            NTILE(5) OVER (ORDER BY frequency ASC) AS F_score,
            NTILE(5) OVER (ORDER BY monetary ASC) AS M_score
        FROM base
    )

    SELECT *,
           (R_score + F_score + M_score) / 3  AS RFM
    FROM rfm_ranked;
