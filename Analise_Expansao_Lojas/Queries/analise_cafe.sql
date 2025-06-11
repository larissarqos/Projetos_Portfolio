USE COFFEE

SELECT * FROM city
SELECT * FROM customers
SELECT * FROM products
SELECT * FROM sales

-- ========== ANÁLISE EXPLORATÓRIA ==========

-- 1. Qual o período avaliado?
-- 01/01/2023 a 01/10/2024
SELECT 
    MIN(sale_date) AS start_date,
    MAX(sale_date) AS end_date
FROM sales

-- 2. Qual a receita total?
-- A receita total foi de mais de 6 Mi de dólares (6.070.190)
SELECT SUM(total) AS revenue
FROM sales

-- 2. Qual o total de clientes?
-- A rede conta com um total de 497 clientes
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM customers

-- 3. Qual o total de vendas?
-- Para o período avaliado, tivemos 10.388 vendas
SELECT COUNT(DISTINCT sale_id) AS total_sales
FROM sales

-- 4. Quantos e quais são os produtos vendidos?
-- Há um total de 28 produtos no cátalogo da rede
SELECT
	product_id,
	product_name
FROM products

-- 5. Qual o total de clientes por loja?
-- Organizando um "TOP 3", Jaipur, Delhi e Pune possuem maior quantidade de clientes (acima de 50)
SELECT
	ci.city_name,
	COUNT(DISTINCT cs.customer_id) AS total_customers
FROM city as ci
LEFT JOIN
customers as cs ON cs.city_id = ci.city_id
GROUP BY ci.city_name
ORDER BY total_customers DESC

-- 2. Qual é o valor médio de receita por cliente em cada cidade?
-- Em termos de receita, analisando novamente os 3 maiores índices, Pune, Chennai e Bangalore encabeçam a lista
SELECT
	ci.city_name,
	SUM(total) AS revenue,
	COUNT(DISTINCT s.customer_id) AS total_customers,
	FORMAT(SUM(total) / COUNT(DISTINCT s.customer_id), 'N2') AS avg_revenue_per_customer
FROM sales AS s
JOIN customers AS cs
ON s.customer_id = cs.customer_id
JOIN city as ci
ON ci.city_id = cs.city_id
GROUP BY ci.city_name
ORDER BY revenue DESC

-- 3. Quantas unidades de cada produto foram vendidas?
-- Há 4 produtos com maior destaque nas vendas:
-- Cold Brew Coffee Pack (6 Bottles), Ground Espresso Coffee (250g), Instant Coffee Powder (100g) e Coffee Beans (500g)
SELECT
	p.product_name,
	COUNT(s.sale_id) AS total_sales,
	SUM(s.total) AS revenue
FROM products AS p
LEFT JOIN
sales AS s
ON s.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC

-- 4. Quais são os três produtos mais vendidos em cada cidade?
-- Mesmo em diferentes cidades, os 4 produtos listados anteriormente com maior quantidade de vendas ocupam ao menos
-- uma das posições no TOP 3 de cada cidade
SELECT *
FROM
(
	SELECT ci.city_name,
		p.product_name,
		COUNT(s.sale_id) AS total_sales,
		DENSE_RANK() OVER(PARTITION BY ci.city_name ORDER BY COUNT(s.sale_id) DESC) AS ranking
	FROM sales AS s
	JOIN
	products AS p
	ON s.product_id = p.product_id
	JOIN customers as cs
	ON cs.customer_id = s.customer_id
	JOIN city as ci
	ON ci.city_id = cs.city_id
	GROUP BY ci.city_name, p.product_name
) AS rank_sales
WHERE ranking <= 3

-- 5. Forneça o valor médio de vendas e aluguel estimado por cliente, de cada cidade.
-- As cidades com maior receita média são Pune, Chennai e Bangalore
-- Analisando o custo benefício x receita média, Pune, Chennai e Jaipur têm melhor desempenho
SELECT
	ci.city_name,
	ci.estimated_rent,
	COUNT(DISTINCT s.customer_id) AS total_customers,
	ROUND(SUM(s.total) * 1.0 / COUNT(DISTINCT s.customer_id), 2) AS avg_revenue_per_customer,
	ROUND(ci.estimated_rent * 1.0 / COUNT(DISTINCT cs.customer_id), 2) AS avg_rent_per_customer
FROM sales AS s
JOIN customers AS cs
ON s.customer_id = cs.customer_id
JOIN city as ci
ON ci.city_id = cs.city_id
GROUP BY ci.city_name, ci.estimated_rent
ORDER BY avg_revenue_per_customer DESC

-- 6. Qual a estimativa, por cidade, do consumo de café, considerando o comportamento de 25% da população?
-- Delhi e Mumbai têm maiores populações e, consequentemente, uma maior estimativa de consumo
SELECT
	city_name,
	population,
	FORMAT((population * 0.25) / 1000000, 'N2') AS consumption_estimate_millions
FROM city
ORDER BY population DESC

-- 7. Gere uma lista de cidades com seus clientes e estimativa de consumidores de café.
-- Delhi possui uma maior quantidade de clientes e também maior estimativa de consumidores
-- Especialmente se comparada com Jaipur, que possui quase a mesma quantidade de clientes, mas uma estimativa 7x menor
SELECT 
	ci.city_name,
	COUNT(DISTINCT cs.customer_id) as total_customers,
	FORMAT((ci.population * 0.25) / 1000000, 'N2') AS consumption_estimate_millions
FROM sales as s
JOIN customers as cs
ON cs.customer_id = s.customer_id
JOIN city as ci
ON ci.city_id = cs.city_id
GROUP BY ci.city_name, ci.population
ORDER BY (ci.population * 0.25) / 1000000 DESC

-- 8. Qual é a receita total das vendas, considerando todas as cidades, no último trimestre de 2023?
-- Dado o último trimestre, Pune, Chennai, Bangalore, Jaipur e Delhi têm maior desempenho
-- Essas mesmas 5 cidades também têm receita geral mais alta
SELECT
	ci.city_name,
	SUM(total) AS revenue
FROM sales AS s
JOIN customers AS cs
ON s.customer_id = cs.customer_id
JOIN city as ci
ON ci.city_id = cs.city_id
WHERE
	DATEPART(YEAR, s.sale_date) = 2023
	AND
	DATEPART(QUARTER, s.sale_date) = 4
GROUP BY ci.city_name
ORDER BY revenue DESC

-- 9. Informe as taxas de crescimento ou declínio nas vendas de café, ao longo do período
WITH monthly_sales AS
(
	SELECT 
		DATEPART(MONTH, sale_date) AS sale_month,
		DATEPART(YEAR, sale_date) AS sale_year,
		SUM(s.total) AS revenue
	FROM sales AS s
	JOIN customers AS cs ON cs.customer_id = s.customer_id
	GROUP BY DATEPART(MONTH, sale_date), DATEPART(YEAR, sale_date)
),
sales_comparison AS
(
	SELECT
		sale_year,
		sale_month,
		revenue,
		LAG(revenue, 1) OVER(ORDER BY sale_year, sale_month) AS last_month_sales
	FROM monthly_sales
)

SELECT
	sale_year,
	sale_month,
	revenue,
	last_month_sales,
	ROUND((revenue - last_month_sales)/last_month_sales * 100, 2) AS growth_rate
FROM sales_comparison
WHERE last_month_sales IS NOT NULL
ORDER BY sale_year, sale_month;

-- 10. Identifique as 3  cidades com a maior receita média por cliente.
-- Considere: cidade, venda, aluguel, clientes e consumidor estimado de café).
-- Pune, Chennai e Bangalore possuem maior receita média por cliente
WITH revenue_city
AS
(
	SELECT
		ci.city_name AS city_name,
		SUM(s.total) as revenue,
		COUNT(DISTINCT s.customer_id) as total_customers,
		ROUND(SUM(s.total)/COUNT(DISTINCT s.customer_id),2) as avg_revenue_per_customer
	FROM sales as s
	JOIN customers as cs
	ON s.customer_id = cs.customer_id
	JOIN city as ci
	ON ci.city_id = cs.city_id
	GROUP BY ci.city_name
),

rent_city
AS
(
	SELECT
		city_name, 
		estimated_rent,
		FORMAT((population * 0.25)/1000000, 'N2') as consumption_estimate_millions
	FROM city
)

SELECT TOP 3
	ca.city_name AS city_name,
	revenue,
	cr.total_customers,
	ca.estimated_rent,
	cr.avg_revenue_per_customer,
	FORMAT(ca.estimated_rent/cr.total_customers, 'N2') as estimated_rent_per_customer,
	consumption_estimate_millions
FROM rent_city as ca
JOIN revenue_city as cr
ON ca.city_name = cr.city_name
ORDER BY revenue DESC







WITH monthly_sales AS
(
	SELECT 
		DATEPART(MONTH, sale_date) AS sale_month,
		DATEPART(YEAR, sale_date) AS sale_year,
		SUM(s.total) AS revenue
	FROM sales AS s
	JOIN customers AS cs ON cs.customer_id = s.customer_id
	GROUP BY DATEPART(MONTH, sale_date), DATEPART(YEAR, sale_date)
),
sales_comparison AS
(
	SELECT
		sale_year,
		sale_month,
		revenue,
		LAG(revenue, 1) OVER(ORDER BY sale_year, sale_month) AS last_month_sales
	FROM monthly_sales
)

SELECT
	sale_year,
	sale_month,
	revenue,
	last_month_sales,
	ROUND((revenue - last_month_sales)/last_month_sales * 100, 2) AS growth_rate
FROM sales_comparison
WHERE last_month_sales IS NOT NULL
ORDER BY sale_year, sale_month;







