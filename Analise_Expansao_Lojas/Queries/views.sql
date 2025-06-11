USE COFFEE

-- ========== CRIANDO VIEWS ==========

-- 1. Informações gerais sobre as vendas (id, data, cliente, cidade, receita)
IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'vw_sales' AND TYPE = 'V')
	BEGIN
		DROP VIEW vw_sales
	END
GO

CREATE VIEW vw_sales AS
SELECT
    s.sale_id,
	s.sale_date,
    s.customer_id,
	ci.city_id,
	ci.city_name,
	p.product_id,
	p.product_name,
    SUM(s.total) AS revenue
FROM sales AS s
JOIN customers AS cs ON s.customer_id = cs.customer_id
JOIN city AS ci ON cs.city_id = ci.city_id
JOIN products AS p ON s.product_id = p.product_id
GROUP BY s.customer_id, s.sale_id, ci.city_id, ci.city_name, p.product_id, p.product_name, s.sale_date

SELECT * FROM vw_sales


---- 2. Receita por cidade e receita média por cliente
--IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'vw_revenue_per_city' AND TYPE = 'V')
--	BEGIN
--		DROP VIEW vw_revenue_per_city
--	END
--GO

--CREATE VIEW vw_revenue_per_city AS
--SELECT
--    ci.city_name AS city_name,
--    SUM(s.total) AS revenue,
--    COUNT(DISTINCT s.customer_id) AS total_customers,
--    ROUND(SUM(s.total) * 1.0 / COUNT(DISTINCT s.customer_id), 2) AS avg_revenue_per_customer
--FROM sales AS s
--JOIN customers AS cs ON s.customer_id = cs.customer_id
--JOIN city AS ci ON cs.city_id = ci.city_id
--GROUP BY ci.city_name;

--SELECT * FROM vw_revenue_per_city


---- 3. Vendas por produto
--IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'vw_sales_per_product' AND TYPE = 'V')
--	BEGIN
--		DROP VIEW vw_sales_per_product
--	END
--GO

--CREATE VIEW vw_sales_per_product AS
--SELECT
--    p.product_name AS product_name,
--    COUNT(s.sale_id) AS total_sales,
--    SUM(s.total) AS revenue
--FROM products AS p
--LEFT JOIN sales AS s ON s.product_id = p.product_id
--GROUP BY p.product_name

--SELECT * FROM vw_sales_per_product


---- 4. CREATE VIEW vw_top3_produtos_por_cidade AS
--IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'vw_revenue_per_city' AND TYPE = 'V')
--	BEGIN
--		DROP VIEW vw_revenue_per_city
--	END
--GO

--SELECT *
--FROM (
--    SELECT
--        ci.city_name AS city_name,
--        p.product_name AS product,
--        COUNT(s.sale_id) AS total_sales,
--        DENSE_RANK() OVER(PARTITION BY ci.city_name ORDER BY COUNT(s.sale_id) DESC) AS ranking
--    FROM sales AS s
--    JOIN products AS p ON s.product_id = p.product_id
--    JOIN customers AS cs ON s.customer_id = cs.customer_id
--    JOIN city AS ci ON cs.city_id = ci.city_id
--    GROUP BY ci.city_name, p.product_name
--) AS sub
--WHERE ranking <= 3

----SELECT * FROM vw_revenue_per_city


-- Estimativas de consumo, aluguel e médias de receita 
IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'vw_estimates' AND TYPE = 'V')
	BEGIN
		DROP VIEW vw_estimates
	END
GO

CREATE VIEW vw_estimates AS
SELECT
    ci.city_id AS city_id,
	ci.city_name AS city_name,
	ci.population AS population,
	FORMAT((ci.population * 0.25) / 1000000, 'N2') AS consumption_estimate_millions,
    ci.estimated_rent AS estimated_rent,
    COUNT(DISTINCT s.customer_id) AS total_customers,
    ROUND(SUM(s.total) * 1.0 / COUNT(DISTINCT s.customer_id), 2) AS avg_revenue_per_customer,
    ROUND(ci.estimated_rent * 1.0 / COUNT(DISTINCT cs.customer_id), 2) AS avg_rent_per_customer
FROM sales AS s
JOIN customers AS cs ON s.customer_id = cs.customer_id
JOIN city AS ci ON ci.city_id = cs.city_id
GROUP BY ci.city_id, ci.city_name, ci.population, ci.estimated_rent

SELECT * FROM vw_estimates


-- Consumo estimado de café por cidade
--IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'vw_estimated_consumption' AND TYPE = 'V')
--	BEGIN
--		DROP VIEW vw_estimated_consumption
--	END
--GO

--CREATE VIEW vw_estimated_consumption AS
--SELECT
--    city_name AS city_name,
--    population,
--	FORMAT((population * 0.25) / 1000000, 'N2') AS consumption_estimate_millions
--FROM city;

--SELECT * FROM vw_estimated_consumption


-- Taxa de crescimento de receita mês a mês
IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE NAME = 'vw_sales_growth' AND TYPE = 'V')
	BEGIN
		DROP VIEW vw_sales_growth
	END
GO

CREATE VIEW vw_revenue_growth AS
WITH monthly_revenue AS 
(
	SELECT 
		ci.city_name AS city_name,
		DATEPART(MONTH, sale_date) AS sale_month,
		DATEPART(YEAR, sale_date) AS sale_year,
		SUM(s.total) AS revenue
	FROM sales AS s
	JOIN customers AS cs ON cs.customer_id = s.customer_id
	JOIN city AS ci ON ci.city_id = cs.city_id
	GROUP BY 
		ci.city_name, 
		DATEPART(MONTH, sale_date), 
		DATEPART(YEAR, sale_date)
),
sales_comparison AS
(
	SELECT
		city_name,
		sale_year,
		sale_month,
		revenue,
		LAG(revenue, 1) OVER(PARTITION BY city_name ORDER BY sale_year, sale_month) AS revenue_last_month
	FROM monthly_revenue
)
SELECT
	city_name,
	sale_year,
	sale_month,
	revenue,
	revenue_last_month,
	ROUND((revenue - revenue_last_month) / revenue_last_month * 100, 2) AS growth_rate
FROM sales_comparison
WHERE revenue_last_month IS NOT NULL;

SELECT * FROM vw_revenue_growth

