<h1 align="center"> Análise de Vendas e Segmentação de Clientes com Técnica RFM </h1>

<p align="center">
  <img src="https://github.com/user-attachments/assets/f4ad952c-19f4-4e2a-a73c-94b8aa0facdc" alt="img" width="1100"/>
</p>

<br>


## 📃 Contexto 
Nesse projeto, analisaremos os dados de uma empresa fictícia para identificar seu desempenho nas vendas e compreender o perfil de seus clientes através da análise RFM. Os insights obtidos servirão de base para a sugestão de uma série de medidas estratégicas que poderão ser adotadas pela corporação a fim de melhorar sua receita e o relacionamento com seus consumidores.  

*Caso não conheça a análise RFM, segue artigo claro e objetivo sobre o método, [leia aqui](https://medium.com/@larissarqos17/an%C3%A1lise-rfm-defini%C3%A7%C3%A3o-aplica%C3%A7%C3%A3o-e-import%C3%A2ncia-8c7e8d911cdd).*


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
O período avaliado é de 01/01/2022 a 31/12/2023.

```sql
SELECT 
    MIN(sale_date) AS start_date,
    MAX(sale_date) AS end_date
FROM RETAIL_SALES
```
--

#### 📌 2. Qual o total de vendas?  
Contamos com 1997 vendas.

```sql
SELECT COUNT(*) AS total_sales
FROM RETAIL_SALES
```
--

#### 📌 3. Qual o faturamento total?  
O faturamento total é de 911.720 dólares.

```sql
SELECT SUM(total_sale) AS revenue
FROM RETAIL_SALES
```
--

#### 📌  4. Quais são as categorias dos nossos produtos?  

Contamos com 3 categorias: Clothing, Eletronics e Beauty.
```sql
SELECT DISTINCT category
FROM RETAIL_SALES
```
--

#### 📌  5. Qual o total de clientes?  
Contamos com 155 clientes.

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
impactam as vendas e faturamento, considerando o perfil dos clientes, categoria dos produtos e o período de venda.

#### 📌 1. Indique o total de vendas e faturamento de cada categoria.

| Categoria  | Total Vendas | Total Faturamento |
|------------|--------------|-------------------|
| Clothing   | 714          | $315.500          |
| Eletronics | 674          | $309.500          |
| Beauty     | 609          | $286.730          |

<br>

```sql
	SELECT category,
		COUNT(*) AS total_sales,
		SUM(total_sale) AS revenue
	FROM retail_sales
	GROUP BY category 
	ORDER BY total_sales DESC
```

--

#### 📌 2. Que categoria gerou maior lucro?
Clothing, 250.730 doláres (quase 35% do lucro total da empresa).

```sql
	SELECT category,
		SUM(profit) AS total_profit
	FROM RETAIL_SALES
	GROUP BY category 
	ORDER BY total_profit DESC
```
--

#### 📌 3. Qual o perfil de cliente de maior valor para a empresa?
O perfil de maior valor é do gênero **feminino, com faixa etária entre 31-50 anos**, responsável por **32% da receita total**.
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

| Categoria  | Perfil        | Total Faturamento |
|------------|---------------|-------------------|
| Clothing   | Female, 41-50 | $315.500          |
| Eletronics | Male, 41-50   | $309.500          |
| Beauty     | Female, 41-50 | $286.730          |

<br>

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
*Acompanhar dashboard no Power BI*

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
*Acompanhar dashboard no Power BI*

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
- **2022:** Outubro, novembro e dezembro.  
- **2023:** Setembro, outubro e dezembro.

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
- **2022:** Fevereiro, junho e agosto.  
- **2023:** Janeiro, Março e Abril.

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
--

#### 📌 10. Qual a classificação dos clientes de acordo com a análise RFM do último ano de vendas?
Após a segmentação dos clientes com base em seu perfil de compras (recência, frequência e valor), esse foi o resultado:

| Classificação       | Total |
|---------------------|-------|
| Promising           | 22    |
| At Risk             | 19    |
| Needs Attention     | 19    |
| Others              | 14    | 
| Hibernating         | 13    |
| Loyal Customers     | 13    | 
| About to Sleep      | 12    | 
| Champions           | 10    | 
| Lost                | 8     | 
| Recent Customers    | 7     | 
| Potential Loyalists | 6     |
| Can't Lose Them     | 4     | 

*Verificar dashboard no Power BI para visualização completa da classificação.*

<br><br>

```sql
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
```

***

<br>

#### 💡 Insights Obtidos  
Os insights estão dividos nos dois pontos da análise: vendas e perfil dos clientes. 

#### 🟨 Vendas
- **Público que mais compra**: Majoritariamente mulheres de 40+, em todas as categorias de produtos

<br>

- **Potencial da categoria Beauty:** Considerando o último ano de vendas, **Beauty é categoria de menor custo (19% do faturamento) e de maior receita média por venda**. Se Beauty contasse com a mesma quantidade de vendas que Clothing em 2023, o faturamento iria dos quase 139 mil dólares para mais de 175 mil. Abaixo tabela comparando desempenho do último ano (2023):

| Categoria  | Vendas     | Receita  | Custo         | Lucro          | Receita média por venda |
|------------|------------|----------|---------------|----------------|-------------------------|
| Clothing   | 378        | $164.650 | $33.100 (20%) | $131.550 (80%) | $435,60                 |
| Eletronics | 344        | $155.340 | $34.650 (22%) | $120.690 (77%) | $451,57                 |
| Beauty     | 299        | $138.920 | $26.010 (19%) | $112.910 (81%) | $464,62                 |

<br>

**Melhores resultados a partir de setembro:** Nos dois anos avaliados e para ambas as categorias, o desempenho nas vendas melhora consideravelmente a partir de setembro, mantendo-se em alta até o fim do ano.

<br>

**Preferem comprar à noite:** É o principal turno escolhido pelos clientes, somando 44% das vendas em 2022 e subindo para 61% em 2023.

--

#### 🟨 Perfil dos Clientes
Os insights aqui listados são com base na análise RFM do último ano (2023), em que constam 147 clientes.

**38% do público precisa de atenção:** Mais de 1/4 dos clientes se encontra em risco de perda.
- Classificações: At risk, Needs attention, Can't Lose Them e Others

<br>

**24% de promissores:** Esse é o percentual de clientes com potencial de fidelização.  
- Classificações: Promissing, Recent Customers e Potential Loyalists

<br>

**17% quase indo embora:** É o total de clientes quase perdidos, com recência e frequência muito abaixo da média.
- Classificações: Hibernating e About to Sleep

<br>

**16% valendo ouro:** É o percentual de clientes de maior valor e o perfil que queremos multiplicar.
- Classificações: Champions e Loyal customers

<br>

**5% perdidos no último ano:** É preciso melhorar o relacionamento com os consumidores, para que esse número não passe a subir.
- Classificação: Lost

****

<br>

### 🚀 Recomendações Estratégicas
As recomendações estão dividas nos dois pontos da análise: vendas e perfil dos clientes. 

#### 🟦 Vendas

**Focar no público majoritário:** Com maioria de clientes sendo mulheres acima dos 40 anos, podemos direcionar campanhas para esse perfil, fazendo:
- Campanhas de marketing específicas, com temas de autocuidado, bem-estar, casa e estilo (considerando as categorias que consomem);
- Parcerias com influenciadoras dessa faixa etária (40+);
- Ofertas especiais para esse perfil, incluindo combos com foco em autocuidado.

<br>

**Buscar aumentar as vendas da categoria Beauty:** Dado o potencial da categoria, devemos voltar estratégias para alavancar suas vendas, como:
- Destacar Beauty com mais espaço nas plataformas virtuais ou loja física;
- Oferecer frete grátis acima de certo valor, promoções relâmpago ou descontos progressivos;
- Estratégias de Upsell relacionando Beauty às outras categorias, especialmente Clothing (ex.: Compre o vestido e leve esse perfume com 30% de desconto).

<br>

**Lançar campanhas sazonais para os períodos de maior venda:** Devemos aproveitar o pico de vendas (setembro–dezembro) explorando o máximo de oportunidades possíveis, a começar pelas datas comemorativas da época:
- Utilizar um calendário de ações relacionando campanhas de marketing e datas comemorativas, como "Primavera do autocuidado" (setembro), black friday antecipada (outubro-dezembro), kits de presente para Natal, Ano Novo (novembro-dezembro).

<br>

**Chame mais atenção à noite:** Como melhor turno para vendas, é o horário perfeito para maior atenção e incentivo a compras para os clientes, através de:
- Lançamento de ofertas exclusivas nesse horário (promoções, descontos, frete grátis das 18:00 às 23:00, por exemplo);
- Disparo e-mails, notificações de ofertas e similares durante a noite;
- Lives commerce ou novos lançamentos nesse horário.

--

#### 🟦 Perfil dos Clientes
As sugestões estão agrupadas de acordo com os resultados apresentados em Insights.

**Fortalecendo o relacionamento** Para os 38% que precisam de atenção, é necessário recuperar o interesse, fortalecendo o laço com a empresa para aumentar seus indicadores RFM, fazendo:
- Ofertas relâmpago exclusivas;
- Programas de pontos com descontos ou brindes de acordo com valor gasto;
- Descontos na compra de produtos complementares;
- Personalizar e-mails de acordo com o perfil do cliente, data de aniversário ou similares, de modo a fazê-lo sentir que a empresa o considera importante

<br>

**Aproximar e fidelizar:** Para os 24% promissores, devemos fidelizar esses clientes:
- Lançar programas de fidelidade ("clube" com benefícios exclusivos)
- Cupons de desconto para próximas compras, com prazo de validade
- Upsell com produtos complementares

<br>

**Trazer de volta:** Os 17% quase partindo devem ser trazidos de volta fazendo-o enxergar as vantagens e o diferencial de comprar na empresa, através de:
- Frete grátis ou brinde surpresa em caso de compras naquele mês;
- Reforçar novidas da marca, como mudanças e lançamentos;
- Combos especiais com desconto e produto extra grátis.

<br>

**Fidelizar e multiplicar:** Os 16% de maior valor são o perfil desejado pela empresa e devem ser recompensados por isso. Boas formas de premiá-los e multiplicá-los são:
- Criar um "clube VIP", com acesso antecipado a lançamentos, cupons exclusivos e brindes;
- Programas de indicação com benefício duplo, para atrair potenciais clientes de perfil semelhante;
- Mensagem de agradecimento com cupons especiais.

<br>

**Um último suspiro:** Para os 5% considerados perdidos, é possível tentar uma última alternativa de recuperação:
- Cupom especial de desconto para compra até uma certa data;
- Oferta de combos com descontos especiais em datas comemorativas (dias das mães, Natal), a fim de incentivá-lo a voltar a comprar.

***

<br>

*Este projeto foi desenvolvido como parte do meu portfólio em análise de dados. Sinta-se à vontade para explorar os dados, sugerir melhorias ou entrar em contato!*
