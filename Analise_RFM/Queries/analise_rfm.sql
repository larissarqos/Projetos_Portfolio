
-- Análise RFM dos clientes, considerando o último ano de vendas, 2023

USE RETAIL_SALES

-- Como os dados vão até 31/12/2023, vamos usar 01/01/2024 como a data de hoje, para que 2023 seja o ano mais recente analisado
DECLARE @today_date AS DATE = '2024-01-01';

-- Definindo os valores de recency, frequency e monetary de cada cliente
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

-- Divisão dos valores em quintis, através de NTILE(5). Cada parâmetro (recency, frequency e monetary) receberá uma nota de 1 a 5
-- 1 = pior desempenho; 5 = melhor desempenho
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

-- Criando o RFM geral, que receberá uma combinação das notas de cada parâmetro
rfm_segment AS (
  SELECT *,
    CAST(R_score AS VARCHAR) + CAST(F_score AS VARCHAR) + CAST(M_score AS VARCHAR) AS RFM
  FROM rfm_score
)

-- Atribuindo uma classificação a cada nota
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
FROM rfm_segment
ORDER BY customer_id



