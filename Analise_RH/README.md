<h1 align="center"> Dashboard RH - Análise de Performance </h1>

<p align="center">
  <img src="https://github.com/user-attachments/assets/0b4a00d9-5935-47c4-85c9-ded57cc69eb0" alt="img" width="1100"/>
</p>

<br>

## 📃 Contexto 
Neste projeto, faremos a **análise de performance de funcionários e suas avaliações em relação à satisfação com a empresa**. O objetivo é ajudar o setor de RH a **detectar que fatores estão relacionados ao baixo desempenho e satisfação** no ambiente de trabalho e que **medidas podem ser adotadas para melhorar esses resultados**. Começaremos com uma **análise exploratória dos dados**, partindo para a **captura de insights** úteis para nossa análise e por fim uma série de **recomendações** com base nas conclusões obtidas.

***

<br>

## 🛠️ Ferramentas e Métodos Utilizados
### 🔸 Métodos
- Limpeza e tratamento de dados
- Análise exploratória
- Engenharia de atributos
- Análise descritiva, diagnóstica e prescritiva

### 🔸 Ferramentas
- Excel (fonte de dados)
- Power BI (visualização)
  
***

<br>

## 🎯 Objetivos 
O foco do projeto é entregar recomendações que podem ajudar o RH a melhorar a satisfação e desempenho dos funcionários da empresa.

***

<br>

## 🧱 Estrutura do Projeto

#### 🔸 Banco de Dados
#### 🔸 Compreendendo os Dados
#### 🔸 Insights Obtidos
#### 🔸 Recomendações Estratégicas

***

<br>

### 🗄 Banco de dados
A base de dados está em inglês e possui a tabela analytics_data. Estão listadas aqui apenas as colunas que foram utilizadas na análise.

| Coluna | Descrição | Tipo de Dado |
|----------|----------|----------|
| city_id | ID da cidade  | varchar(15), chave primária da tabela  |
| city_name   | Nome da cidade   | varchar(20)  |
| population   | Quantidade de habitantes  |  bigint |
| estimated_rent  | Valor estimado do aluguel   | float  |
| city_rank  | Ranking das cidades  | int  |


***

<br>


### 📍 Compreendendo os Dados
Aqui, vamos analisar as diferentes partes que compoem a empresa e suas características, sendo elas: o perfil dos funcionários e os setores da empresa.

#### 📌 1. Perfil dos funcionários
A empresa possui **1470 funcionários**. Considerando suas características de **gênero**, **faixa etária**, **estado civil** e anos na empresa, temos:

**Gênero**  
Maioria é do gênero masculino.
- **Homens:** 882 (60%)
- **Mulheres:** 588 (40%)

--

**Faixa Etária**  
Maioria entre 31-50 anos.
- **31-40:** 619 ()
- **41-50:** 322 ()
- **26-30:** 263 ()
- **50+:** 143 ()
- **18-25:** 123 ()

--

**Estado Civil**  
Maioria é casado.
- **Casado:** 673 (46%)
- **Solteiro:** 470 (32%)
- **Divorciado:** 327 (22%)

--

**Anos na Empresa**  
Maior parte está entre 0 e 7 anos na empresa.
- **4-7:** 472 ()
- **0-3:** 470 ()
- **8-10:** 282 ()
- **11-15:** 108 ()
- **16-20:** 72 ()
- **20+:** 66 ()

--

#### 📌 2. Departamentos da Empresa
A empresa possui 3 departamentos: Human Resources, Research & Development e Sales. Vamos avaliar o total de funcionários, 
| Departamento | Total Funcionários | Média Anos na Empresa | Média Anos Desde Ult. Promoção | Total para Promover | Total para Demitir |
|--------------|--------------------|-----------------------|--------------------------------|---------------------|--------------------|
| Human Resources        | 63  | 7,24  | 1,78 | 2   | 1   |
| Research & Development | 961 | 6,86  | 2,14 | 38  | 11  |
| Sales                  | 446 | 7,28  | 2,35 | 16  | 10  |


Considerando o nível de satisfação por departamento, temos:

| Departamento           | Alta Satisfação | Média Satisfação | Baixa Satisfação |
|------------------------|-----------------|------------------|------------------|
| Human Resources        | 31  (49%)       | 15  (24%)        | 17  (27%)        |
| Research & Development | 366 (38%)       | 300 (31%)        | 295 (31%)        |
| Sales   | 151          | 172 (39%)       | 127 (28%)        | 147 (33%)        |




  **Sales**  
- **Alto** 172 (39%)
- **Médio:** 127 (28%)
- **Baixo:** 147 (33%)

  
--

#### 📌 3. Quais foram os produtos mais vendidos?  
As vendas foram bem distribuídas entre os produtos. Porém, em termos de faturamento, os destaques foram **Camisa Linho**, **Oxford** e **Joa**, que juntas representaram mais de **70% do faturamento**.

| Produto         | Nº de Vendas | Quantidade | Faturamento Anual | % do Total  |
|-----------------|--------------|------------|-------------------|-------------|
| Camisa Oxford   | 158          | 480        | R$100.464,00      | 21,75%      |
| Camiseta Navy   | 157          | 479        | R$80.136,70       | 17,36%      |
| Camiseta Joa    | 151          | 480        | R$97.104,00       | 21,03%      |
| Camiseta Pima   | 149          | 423        | R$50.506,20       | 10,94%      |
| Camisa Linho    | 144          | 446        | R$133.532,40      | 28,92%      |
| **Total**       | **759**      | **2.308**  | **R$461.743,30**  | **100%**    |

--

#### 📌 4. As lojas atingiram a meta mensal estabelecida de R$7.000,00? **  
Com base no faturamento médio mensal por loja (faturamento total ÷ 12), apenas **3 das 5 filiais** alcançaram ou superaram a meta: **Leblon, Ipanema e Botafogo**.

**Resumo por loja:**

- **Leblon** – R$10.388,30/mês: Melhor desempenho do ano. Abaixo da meta apenas em setembro, com crescimento contínuo a partir de outubro.

- **Ipanema** – R$8.370,72/mês: Crescimento a partir de março. Consistente no restante do ano, sempre próxima ou acima da meta.

- **Botafogo** – R$7.600,00/mês: Regular ao longo do ano, exceto em julho.

- **Barra** – R$6.115,42/mês: Acima da meta apenas em julho, novembro e dezembro. Desempenho fraco em setembro.

- **Tijuca** – R$5.610,17/mês: Atingiu ou superou a meta em apenas 5 meses. Início e fim do ano com queda nas vendas.

***

<br>

### 📈 Recomendações Estratégicas
Com base na análise dos dados e padrões identificados, algumas ações podem ser adotadas:

#### 🟦 Ações por loja
- **Campanhas promocionais focadas nas lojas com menor desempenho:** Promoções sazonais, descontos progressivos e ações em datas comemorativas podem ajudar a impulsionar vendas, principalmente no primeiro trimestre.
  
#### 🟦 Ações por produto
- **Aproveitar o potencial dos produtos mais lucrativos:** Campanhas de marketing direcionadas para os best-sellers (como Camisa Linho e Oxford) podem alavancar ainda mais o faturamento.

***

<br>

### 🚀 Impacto Esperado
A adoção das estratégias sugeridas pode gerar impactos positivos tanto no aumento de faturamento quanto na eficiência operacional da rede de lojas. Com base nos dados de 2024, os seguintes resultados são projetados:

#### 🟩 Aumento no faturamento das lojas de pior desempenho (Barra e Tijuca)
- **Projeção:** Se as lojas Barra e Tijuca alcançarem o faturamento médio de Ipanema e Botafogo (aproximadamente R$8.000/mês), o ganho potencial anual para cada uma das lojas é de ~ R$96.000. O faturamento total anual subiria de R$461,743 para  ~R$508.800, um **aumento percentual de ~11,4%**. 
- **Impacto:** Redução da disparidade entre filiais e maior previsibilidade de receita.
  
#### 🧮 Cálculo da projeção:
Média mensal de Ipanema e Botafogo: (R$8.370 + R$7.600) / 2 = R$7.985, arredondado para R$8.000
Projeção anual para Barra e Tijuca: R$8.000 * 12 = R$96.000 (cada)

* Novo faturamento anual estimado:

  Leblon: R$10.400 * 12 = R$124.800
  
  Ipanema: R$8.400 * 12 = R$100.800
  
  Botafogo: R$7.600 * 12 = R$91.200
  
  Barra: R$8.000 * 12 = R$96.000  
  
  Tijuca: R$8.000 * 12 = R$96.000
  
  Total: ~R$508.800

--

#### 🟩 Aumento de 10% nas vendas dos produtos mais lucrativos (Camisa Linho, Oxford e Joa)
- **Projeção:** Um aumento de apenas 10% nas vendas dos três produtos mais lucrativos pode gerar um acréscimo de aproximadamente R$32.800 ao faturamento anual, um **aumento percentual de ~ 7,1%**.
- **Impacto:** Elevação direta da receita sem necessidade de ampliar a cartela de produtos.
  
#### 🧮 Cálculo da projeção:

* **Camisa Linho:**
  Vendas atuais: 144 unidades + 10% = 158 unidades
  
  Valor médio por unidade: R$133.530 / 144 = ~ R$927,30
  
  Novo faturamento: 158 * R$927,30 ~ R$146.513



* **Camisa Oxford:**
  
  Vendas atuais: 158 unidades + 10% = 174 unidades
  
  Valor médio por unidade: R$100.460,00 ÷ 158= ~ R$636
  
  Novo faturamento: 174 * R$636 ~ R$110.664


* **Camiseta Joa:**
  
  Vendas atuais: 151 unidades + 10% = 166 unidades
  
  Valor médio por unidade: R$97.100 / 151 = ~ R$643,00
  
  Novo faturamento: 166 * R$643,00 ~ R$106.738

* **Total:**
  
  Novo total dos 3 produtos: R$146.513 + R$110.664 + R$106.738 = R$363.915  
  
  Faturamento atual dos 3 produtos: R$331.100  
  
  Acréscimo estimado: R$363.915 − R$331.100 = ~ R$32.815  

  Aumento percentual no faturamento total: (R$32.815 / R$461.743) * 100 = ~7,1%

***

<br>

*Este projeto foi desenvolvido como parte do meu portfólio em análise de dados. Sinta-se à vontade para explorar os dados, sugerir melhorias ou entrar em contato!*
