USE RETAIL_SALES

SELECT *
FROM RETAIL_SALES

-- ========== LIMPEZA E TRATAMENTO DOS DADOS ==========

-- 1. VERIFICANDO VALORES NULOS
-- Na tabela, os valores nulos estão como texto "NULL", há 3 linhas com valores NULL
DECLARE @sql NVARCHAR(MAX)
SELECT @sql = STRING_AGG('[' + COLUMN_NAME + '] = ''NULL''', ' OR ')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'RETAIL_SALES'
SET @sql = 'SELECT * FROM RETAIL_SALES WHERE ' + @sql
EXEC(@sql)


-- 2. VERIFICANDO TRANSAÇÕES DUPLICADAS
-- Não há valores duplicados
SELECT transactions_id,
	COUNT(*) AS total_duplicates
FROM RETAIL_SALES
GROUP BY transactions_id
HAVING COUNT(*) > 1


-- 3. DELETANDO VALORES NULOS
-- Como são apenas 3 linhas (0,15% do total de 2000 registros), excluí-las não vai gerar impacto na análise dos dados
DECLARE @sql NVARCHAR(MAX)
SELECT @sql = STRING_AGG('[' + COLUMN_NAME + '] = ''NULL''', ' OR ')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'RETAIL_SALES'
SET @sql = 'DELETE FROM RETAIL_SALES WHERE ' + @sql
EXEC(@sql)


-- 4. VERIFICANDO NOVAMENTE OS DADOS
-- Não há mais valores nulos
DECLARE @sql NVARCHAR(MAX)
SELECT @sql = STRING_AGG('[' + COLUMN_NAME + '] = ''NULL''', ' OR ')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'RETAIL_SALES'
SET @sql = 'SELECT * FROM RETAIL_SALES WHERE ' + @sql
EXEC(@sql)


-- 5. ALTERANDO VÍRGULA PARA PONTO NA COLUNA cogs, PARA CONVERTÊ-LA PARA UM TIPO NUMÉRICO
-- A coluna cogs possui vírgula no lugar de ponto, que não é aceito para números no sql. Vamos converter a vírgula em ponto
SELECT cogs
FROM RETAIL_SALES

-- Convertendo (,) em (.)
UPDATE RETAIL_SALES
SET cogs = REPLACE(cogs, ',', '.')
WHERE cogs LIKE '%,%';

-- Alterando o tipo de dados da coluna para DECIMAL(10,2)
ALTER TABLE RETAIL_SALES
ALTER COLUMN cogs DECIMAL(10,2)


-- 6. RENOMEANDO A COLUNA quantiy PARA quantity
-- A coluna quantity está com o nome errado: "quantiy", vamos corrigi-lo
EXEC sp_rename 'RETAIL_SALES.quantiy', 'quantity', 'COLUMN'


-- 7. CRIANDO UMA COLUNA LUCRO (DIFERENÇA ENTRE total_sale e cogs)
ALTER TABLE RETAIL_SALES
ADD profit DECIMAL(10,2)

UPDATE RETAIL_SALES
SET profit = total_sale - cogs


-- 8. CRIANDO UMA COLUNA DE FAIXA ETÁRIA
ALTER TABLE RETAIL_SALES
ADD age_range AS
  CASE 
    WHEN age BETWEEN 18 AND 24 THEN '18-24'
    WHEN age BETWEEN 25 AND 30 THEN '25-30'
    WHEN age BETWEEN 31 AND 40 THEN '31-40'
	WHEN age BETWEEN 41 AND 50 THEN '41-50'
    WHEN age >= 50 THEN '+50'
    ELSE 'error'
  END


-- VERIFICANDO DADOS APÓS LIMPEZA, TRATAMENTO E ENGENHARIA DE ATRIBUTOS
SELECT * FROM RETAIL_SALES



-- ========== ANÁLISE EXPLORATÓRIA DOS DADOS ==========

-- 1. Qual o período avaliado?
-- O período avaliado é de 01/01/2022 a 31/12/2023
SELECT 
    MIN(sale_date) AS start_date,
    MAX(sale_date) AS end_date
FROM RETAIL_SALES

-- 2. Qual o total de vendas?
-- Contamos com 1997 vendas
SELECT COUNT(*) AS total_sales
FROM RETAIL_SALES

-- 3. Qual o faturamento total?
-- O faturamento total é de 911.720 dólares
SELECT SUM(total_sale) AS revenue
FROM RETAIL_SALES

-- 4. Quais são as categorias dos nossos produtos?
-- Contamos com 3 categorias: Clothing, Eletronics e Beauty
SELECT DISTINCT category
FROM RETAIL_SALES

-- 5. Qual o total de clientes?
-- Contamos com 155 clientes
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM RETAIL_SALES


-- 6. Qual o perfil dos clientes?
-- Contamos com homens e mulheres, de 18 a +50 anos. O perfil majoritário é de mulheres +50 entre 41 e +50 anos.
SELECT
	gender,
	age_range,
	COUNT(DISTINCT customer_id) AS total_customers
FROM RETAIL_SALES
GROUP BY gender, age_range
ORDER BY total_customers DESC


-- ========== RESPONDENDO ÀS PERGUNTAS DE NEGÓCIO ==========
-- 1. Indique o total de vendas e faturamento de cada categoria.
SELECT category,
	COUNT(*) AS total_sales,
	SUM(total_sale) AS revenue
FROM retail_sales
GROUP BY category 
ORDER BY total_sales DESC


-- 2. Qual a categoria mais lucrativa?
-- As categorias mais lucrativa é Clothing.
SELECT category,
	SUM(profit) AS total_profit
FROM RETAIL_SALES
GROUP BY category 
ORDER BY total_profit DESC

-- 3. Qual o perfil de cliente de maior valor para a empresa?
-- O perfil de maior valor é do gênero feminino, com faixa etária entre 31-50 anos.
SELECT TOP 3 gender,
	age_range,
	COUNT(DISTINCT customer_id) AS total_customers,
	COUNT(*) AS total_sales,
	SUM(total_sale) AS revenue
FROM RETAIL_SALES
GROUP BY gender, age_range
ORDER BY revenue DESC

-- 4. Qual o perfil de clientes de maior valor em cada categoria?

SELECT
    category,
    gender,
    age_range,
    revenue
FROM (
    SELECT
        category,
        gender,
        age_range,
        SUM(total_sale) AS revenue,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY SUM(total_sale) DESC) AS ranking
    FROM RETAIL_SALES
    GROUP BY category, gender, age_range
) AS ranked
WHERE ranking = 1
ORDER BY revenue DESC

-- 5. Indique o desempenho ano a ano, considerando total de vendas, faturamento, custo e lucro.
SELECT DATEPART(yyyy, sale_date) AS year,
	COUNT(*) AS total_sales,
	SUM(total_sale) AS revenue,
	SUM(cogs) AS cogs,
	SUM(profit) AS profit
FROM RETAIL_SALES
GROUP BY DATEPART(yyyy, sale_date)
ORDER BY year

-- 6. Indique o total de vendas e faturamento médio de cada mês, por ano
SELECT
	DATEPART(yyyy, sale_date) AS year,
	DATEPART(month, sale_date) AS month,
	COUNT(*) AS total_sales,
	ROUND(AVG(total_sale), 2) AS revenue
FROM RETAIL_SALES
GROUP BY DATEPART(yyyy, sale_date), DATEPART(month, sale_date)
ORDER BY year, month ASC

-- 7. Quais os 3 meses de melhor desempenho em cada ano, considerando média de vendas e faturamento?
-- Os melhores meses de 2022 foram outubro, novembro em dezembro. 2023 contou com um desempenho similar para o mesmo período, com melhores
-- meses sendo setembro, outubro e dezembro.
WITH monthly_revenue AS (
    SELECT
        DATEPART(YEAR, sale_date) AS year,
        DATEPART(MONTH, sale_date) AS month,
        COUNT(*) AS total_sales,
        SUM(total_sale) AS revenue
    FROM RETAIL_SALES
    GROUP BY DATEPART(YEAR, sale_date), DATEPART(MONTH, sale_date)
),
ranked_months AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY revenue DESC) AS ranking
    FROM monthly_revenue
)
SELECT year, month, total_sales, revenue, ranking AS ranking
FROM ranked_months
WHERE ranking <= 3
ORDER BY year, ranking

-- 8. Quais os 3 meses de pior desempenho em cada ano, considerando média de vendas e faturamento?
-- Os piores meses de 2022 foram: fevereiro, junho e agosto. Já em 2023 foram janeiro, março e abril.
WITH monthly_revenue AS (
    SELECT
        DATEPART(YEAR, sale_date) AS year,
        DATEPART(MONTH, sale_date) AS month,
        COUNT(*) AS total_sales,
        SUM(total_sale) AS revenue
    FROM RETAIL_SALES
    GROUP BY DATEPART(YEAR, sale_date), DATEPART(MONTH, sale_date)
),
ranked_months AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY revenue ASC) AS ranking
    FROM monthly_revenue
)
SELECT year, month, total_sales, revenue, ranking AS ranking
FROM ranked_months
WHERE ranking <= 3
ORDER BY year, ranking

-- 9. Qual o turno preferido dos clientes para realizar compras em nossa loja?
-- Os cliente fazem mais pedidos no turno da noite, mais de 50% das compras são realizadas nesse período.
WITH sales_period
AS(
	SELECT *,
		CASE
			WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
			WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS period
	FROM retail_sales
)
SELECT
	period,
	COUNT(*) AS total_sales
FROM sales_period
GROUP BY period
ORDER BY total_sales DESC
