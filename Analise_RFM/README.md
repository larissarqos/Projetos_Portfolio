<h1 align="center"> Análise de Vendas e Clientes com Técnica RFM </h1>

<p align="center">
  <img src="https://github.com/user-attachments/assets/f4ad952c-19f4-4e2a-a73c-94b8aa0facdc" alt="img" width="1100"/>
</p>

<br>


## 📃 Contexto 
Nesse projeto, analisaremos os dados de uma empresa fictícia, a fim de identificar seu desempenho nas vendas (produtos e períodos com maior retorno) e o perfil de seus clientes através da análise RFM. Os insights obtidos servirão de base para a sugestão de uma série de medidas estratégicas que poderão ser adotadas pela corporação a fim de melhorar seus resultados nas vendas e no relacionamento com seus clientes.

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
O objetivo do projeto é fornecer à empresa insights e sugestões de valor, que resultem na melhoria de seus resultados, seja nas vendas ou no relacionamento com seus clientes.

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
Contamos com homens e mulhes, de 18 a +50 anos. O perfil majoritário é de mulheres +50 entre 41 e +50 anos.
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

#### 📌 1. Qual categoria foi a mais comprada por nossos clientes e qual o valor total?  
A categoria mais comprada foi **Clothing: 714 vendas** (35,75% do total), contando também com o maior faturamento: 315.500,00 dólares. 
  ```sql
SELECT category,
	COUNT(*) AS total_pedidos,
	SUM(total_sale) AS valor_total
FROM retail_sales
GROUP BY category 
ORDER BY total_pedidos DESC
```
--

#### 📌 2. A quantidade de vendas e o faturamento apresenta grande diferença por gênero?  
Sim. A maior parte dos clientes é do gênero feminino, com maior parte nas vendas e faturamento, sendo:
* Feminino: 1298 pedidos (50.93% do total de vendas); Valor total de 606.910 dólares (50.99% do faturamento);
* Masculino: 699 pedidos (49,07% do total de vendas); Valor total de 304.810 dólares (49,01% do faturamento)

```sql
SELECT gender,
COUNT(*) AS total_pedidos,
	SUM(total_sale) AS valor_total
FROM retail_sales
GROUP BY gender 
ORDER BY valor_total DESC
```
--

#### 📌 3. Quais os 5 clientes que mais compraram conosco?  
 Os clientes de maior valor do período foram os de ID: 3, 1, 5, 2 e 4.
  ```sql
SELECT TOP 5 customer_id,
	SUM(total_sale) as valor_total
FROM retail_sales
GROUP BY customer_id
ORDER BY valor_total DESC
```
--

#### 📌 5. Qual o total de vendas, considerando o gênero dos clientes e categoria dos produtos?
  ```sql
SELECT category,
	gender,
	COUNT(*) AS total_vendas
	FROM retail_sales
GROUP BY category, gender
ORDER BY total_vendas DESC
```
--

#### 📌 6. Qual a média de idade dos clientes que compram na categoria 'Beauty', do gênero feminino?  
-- De acordo com a categoria Beauty, a média de idade pa é de 40 anos para o gênero feminino.
  ```sql
SELECT 
	category,
	gender,
	ROUND(AVG(age), 2) AS media_idade
FROM retail_sales
WHERE category = 'Beauty' AND gender = 'Female'
GROUP BY gender, category
ORDER BY gender
```
--

#### 📌 7. Gere uma amostra das vendas realizadas em maio de 2022  
Arquivo gerado como "sale_05_2022.csv".
  ```sql
SELECT *
FROM retail_sales
WHERE sale_date LIKE '2022-05%'
ORDER BY sale_date ASC
```
--

#### 📌 8. Retorne as transações de categoria 'Clothing', em que a quantidade vendida é mais que 10, no mês de novembro   
 Não há quantidade de vendas maior ou igual a 10.
  ```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND sale_date LIKE '2022-11%'
	AND quantity >= 4
```
--

#### 📌 9. Indique o valor médio em vendas de cada mês
  ```sql
SELECT
	DATEPART(yyyy, sale_date) AS ano_venda,
	DATEPART(month, sale_date) AS mes_venda,
	ROUND(AVG(total_sale), 2) AS total_vendas
FROM retail_sales
GROUP BY DATEPART(yyyy, sale_date), DATEPART(month, sale_date)
ORDER BY ano_venda, total_vendas DESC
```
--

#### 📌 10. Qual o mês de melhor desempenho em cada ano?  
2022: mês de julho; 2023: mês de fevereiro
  ```sql
SELECT * FROM
(	
	SELECT
			DATEPART(yyyy, sale_date) AS ano_venda,
			DATEPART(month, sale_date) AS mes_venda,
			ROUND(AVG(total_sale), 2) AS total_vendas,
			RANK() OVER(PARTITION BY DATEPART(yyyy, sale_date) ORDER BY ROUND(AVG(total_sale), 2) DESC) AS ranking
	FROM retail_sales
	GROUP BY DATEPART(yyyy, sale_date), DATEPART(month, sale_date)
) AS resultado
```
--

#### 📌 11. Organize os horários de compra em turnos (manhã, tarde e noite) e indique que turnos contém mais transações. Considere: Manhã <=12; Tarde > 12, <=17; Noite > 17.**  
O turno da noite possui o maior número de transações: 1062 pedidos (53,45% do total).

```sql
WITH horario_vendas
AS(
	SELECT *,
		CASE
			WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Manhã'
			WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Tarde'
			ELSE 'Noite'
		END AS turno
	FROM retail_sales
)
SELECT
	turno,
	COUNT(*) AS total_pedidos
FROM horario_vendas
GROUP BY turno
ORDER BY total_pedidos DESC
```

***

<br>

### 📈 Recomendações Estratégicas


***

<br>

*Este projeto foi desenvolvido como parte do meu portfólio em análise de dados. Sinta-se à vontade para explorar os dados, sugerir melhorias ou entrar em contato!*
