<h1 align="center"> Análise de Vendas e Segmentação de Clientes com Técnica RFM </h1>

<p align="center">
  <img src="https://github.com/user-attachments/assets/f4ad952c-19f4-4e2a-a73c-94b8aa0facdc" alt="img" width="1100"/>
</p>

<br>


## 📃 Contexto 
Nesse projeto, analisaremos os dados de uma empresa fictícia para identificar seu desempenho nas vendas e compreender o perfil de seus clientes através da análise RFM. Os insights obtidos servirão de base para a sugestão de uma série de medidas estratégicas que poderão ser adotadas pela corporação a fim de melhorar sua receita e o relacionamento com seus consumidores.

***

<br>

## 🛠️ Ferramentas e Métodos Utilizados
### 🔸 Métodos
- Limpeza e tratamento de dados
- Análise exploratória
- Engenharia de atributos
- Métodos estatísticos
- Businnes Intelligence

### 🔸 Ferramentas
- SQL Server (CTEs, window function, manipulação de data e hora)
- Excel (fonte de dados)
- Power BI (visualização)

***

<br>

## 🎯 Objetivos  
O objetivo do projeto é fornecer à empresa insights e sugestões de valor, que resultem na melhoria de seus resultados, seja no faturamento ou no relação com seus clientes.

***

<br>

## 🧱 Estrutura do Projeto

#### 🔸 Banco de Dados
#### 🔸 Análise Exploratória
#### 🔸 Respondendo a Perguntas de Negócio
#### 🔸 Insights Obtidos
#### 🔸 Recomendações Estratégicas

***

<br>

### 🗄 Banco de dados 
A base de dados está em inglês e se encontra em anexo como "retail_sales.csv". As datas estão no formato americano (mês/dia/ano) e os valores relacionados a dinheiro são em dólar. Abaixo o dicionário dos dados:

| Coluna | Descrição | Tipo de Dado |
|----------|----------|----------|
| transactions_id | ID da venda  | varchar (chave primária da tabela)  |
| sale_date   | Data da venda   | date  |
| sale_time   | Hora da venda   | time(7)   |
| customer_id   | ID do cliente   | varchar(50)  |
| gender  | Gênero  | varchar(20)   |
| age   | Idade   | int  |
| category  | Categoria   | varchar(20)  |
| quantity   | Quantidade   | int   |
| price_per_unit   | Preço por unidade  | float   |
| cogs   | Custo por unidade   | float   |
| total_sale   | Valor total da venda   | float   |

***

<br>

### 🔎 Análise exploratória dos dados

#### 📌 1. Qual o período avaliado?  
O período avaliado é de 01/01/2022 a 31/12/2023
```sql
SELECT 
    MIN(sale_date) AS start_date,
    MAX(sale_date) AS end_date
FROM RETAIL_SALES
```
--

#### 📌 2. Qual o total de vendas?  
Contamos com 1997 vendas
```sql
SELECT COUNT(*) AS total_sales
FROM RETAIL_SALES
```
--

#### 📌 3. Qual o faturamento total?  
O faturamento total é de 911.720 dólares
```sql
SELECT SUM(total_sale) AS revenue
FROM RETAIL_SALES
```
--

#### 📌  4. Quais são as categorias dos nossos produtos?  
Contamos com 3 categorias: Clothing, Eletronics e Beauty
```sql
SELECT DISTINCT category
FROM RETAIL_SALES
```
--

#### 📌  5. Qual o total de clientes?  
Contamos com 155 clientes
```sql
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM RETAIL_SALES
```
--

#### 📌  6. Qual o perfil dos clientes?  
Contamos com homens e mulheres, de 18 a +50 anos. O perfil majoritário é de mulheres entre 41 e +50 anos.
```sql
SELECT
	gender,
	age_range,
	COUNT(DISTINCT customer_id) AS total_customers
FROM RETAIL_SALES
GROUP BY gender, age_range
ORDER BY total_customers DESC
```

***

<br>

### 📍 Solução de problemas de negócios
Aqui, serão respondidas uma série de perguntas de negócio para entendermos os principais fatores que
impactam as vendas e faturamento, considerando o perfil dos clientes, categoria dos produtos e o período de venda

#### 📌 1. Indique o total de vendas e faturamento de cada categoria.
```sql
	SELECT category,
		COUNT(*) AS total_sales,
		SUM(total_sale) AS revenue
	FROM retail_sales
	GROUP BY category 
	ORDER BY total_sales DESC
```

--

#### 📌 2. Qual a categoria mais lucrativa?
As categorias mais lucrativa é Clothing.

```sql
	SELECT category,
		SUM(profit) AS total_profit
	FROM RETAIL_SALES
	GROUP BY category 
	ORDER BY total_profit DESC
```
--

#### 📌 3. Qual o perfil de cliente de maior valor para a empresa?
-- O perfil de maior valor é do gênero feminino, com faixa etária entre 31-50 anos.
```sql
	SELECT TOP 3 gender,
		age_range,
		COUNT(DISTINCT customer_id) AS total_customers,
		COUNT(*) AS total_sales,
		SUM(total_sale) AS revenue
	FROM RETAIL_SALES
	GROUP BY gender, age_range
	ORDER BY revenue DESC
```
--

#### 📌 4. Qual o perfil de clientes de maior valor em cada categoria?
```sql
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
```
--

#### 📌 5. Indique o desempenho ano a ano, considerando total de vendas, faturamento, custo e lucro.

```sql
	SELECT DATEPART(yyyy, sale_date) AS year,
		COUNT(*) AS total_sales,
		SUM(total_sale) AS revenue,
		SUM(cogs) AS cogs,
		SUM(profit) AS profit
	FROM RETAIL_SALES
	GROUP BY DATEPART(yyyy, sale_date)
	ORDER BY year
```
--

#### 📌 6. Indique o total de vendas e faturamento médio de cada mês, por ano

```sql
	SELECT
		DATEPART(yyyy, sale_date) AS year,
		DATEPART(month, sale_date) AS month,
		COUNT(*) AS total_sales,
		ROUND(AVG(total_sale), 2) AS revenue
	FROM RETAIL_SALES
	GROUP BY DATEPART(yyyy, sale_date), DATEPART(month, sale_date)
	ORDER BY year, month ASC
```
--

#### 📌 7. Quais os 3 meses de melhor desempenho em cada ano, considerando média de vendas e faturamento?  
**2022:** Outubro, novembro e dezembro.  
**2023:** Setembro, outubro e dezembro.

```sql
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
```
--

#### 📌 8. Quais os 3 meses de pior desempenho em cada ano, considerando média de vendas e faturamento?
**2022:** Fevereiro, junho e agosto.  
**2023:** Janeiro, Março e Abril.

```sql
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
```
--

#### 📌 9. Qual o turno preferido dos clientes para realizar compras em nossa loja?  
Os cliente fazem mais pedidos no turno da noite, mais de 50% das compras são realizadas nesse período.
```sql
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
```

***

<br>

### 📈 Recomendações Estratégicas


***

<br>

*Este projeto foi desenvolvido como parte do meu portfólio em análise de dados. Sinta-se à vontade para explorar os dados, sugerir melhorias ou entrar em contato!*
