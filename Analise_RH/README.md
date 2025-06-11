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

#### 📌 Perfil dos funcionários
A empresa possui **1470 funcionários**. Considerando suas características de **gênero**, **estado civil** e **faixa etária**, temos:

**Gênero -** Maioria é do gênero masculino.
- **Homens:** 60%
- **Mulheres:** 40%

<br>

**Estado Civil -** Maioria é casado.
- **Casado:** 46%
- **Solteiro:** 32%
- **Divorciado:** 22%

<br>

**Faixa Etária -** Maioria entre 31-50 anos.
- **31-40:** 42%
- **41-50:** 22%
- **26-30:** 18%
- **50+:** 10%
- **18-25:** 8%

--

#### 📌 Relação com a empresa
Sobre sua relação com a empresa, considerando departamento, anos de serviço, nível de desempenho e satisfação, temos:

**Departamento -** Research & Development possui 65% dos funcionários.
- **Research & Development:** 65%
- **Human Resources:** 30%
- **Sales:** 4%

<br>

**Anos na Serviço -** Maior parte está entre 0 e 7 anos na empresa.
- **4-7:** 32%
- **0-3:** 32%
- **8-10:** 19%
- **11-15:** 7%
- **16-20:** 5%
- **20+:** 4%

<br>

**Performance -** A maior parte dos funcionários possui bons resultados em performance.
- **Alta:** 85%
- **Baixa:** 15%
  
<br>

**Nível Satisfação -** Quase 40% dos funcionários está muito satisfeito com a empresa. Média e Baixa satisfação se encontram praticamente empatados.
- **Alto:** 39%
- **Médio:** 30%
- **Baixo:** 31%

--

#### 📌 Departamentos
A empresa possui 3 departamentos: Human Resources, Research & Development e Sales. Vamos verificar algumas informações por departamento, conforme tabela:

| Departamento | Total Funcionários | Média Anos na Empresa | Média Anos Desde Ult. Promoção | Total para Promover | Total para Desligar|
|--------------|--------------------|-----------------------|--------------------------------|---------------------|--------------------|
| Human Resources        | 63       | 7,24                  | 1,78                           | 2                   | 1                  |
| Research & Development | 961      | 6,86                  | 2,14                           | 38                  | 11                 |
| Sales                  | 446      | 7,28                  | 2,35                           | 16                  | 10                 |

<br>

Considerando os níveis de satisfação e performance por departamento, temos:

| Departamento           | Alta Satisfação | Média Satisfação | Baixa Satisfação | Alta Performance | Baixa Performance |
|------------------------|-----------------|------------------|------------------| -----------------|-------------------|
| Human Resources        | 49%             | 24%              | 27%              | 86%              | 14%               |
| Research & Development | 38%             | 31%              | 31%              | 84%              | 16%               |
| Sales                  | 39%             | 28%              | 33%              | 86%              | 14%               |

***

<br>

#### 💡 Insights Obtidos  
Com base nos dados, podemos tirar algumas conclusões em relação à performance e satisfação dos colaboradores. 

*Obs.: Os insights foram obtidos com base na análise dos dados através dos gráficos. Por favor, abrir o dashboard no Power BI para acompanhar as conclusões.*

#### 🟨 Baixa Performance
- **Gênero e Faixa Etária:** Os fatores de gênero e faixa etária não têm diferença significativa nos resultados de performance, ambos apresentaram valores semelhantes. A **principal diferença se dá na faixa dos 50+, para o gênero feminino, em que 20% das colaboradoras está com baixo rendimento**, comparado ao geral da empresa com 14% de funcionários em baixo desempenho.

- **Tempo de Serviço:** Há um crescimento sutil no baixo desempenho com o passar dos anos de serviço, o pico se dá na faixa dos 11-15 anos na empresa. Enquanto os demais períodos se encontram próximos à média geral, **11-15 possui 22% do total com baixo desempenho**, que passa a melhorar com o tempo, chegando a 12% na faixa dos 20+ anos de trabalho.

- **Departamento:** Dentre os departamentos, **Research & Development possui 16% dos colaboradores com baixo rendimento**, isso se acentua para o período de **11-15 anos de serviço, indo para 28%**. Sobe para **33% quando consideramos apenas o gênero masculino**.

--

#### 🟨 Alta Performance
- **Tempo de Serviço:** Funcionários com **0-3 anos de serviço** têm melhor desempenho, especialmente nos setores de **Human Resources (90%) e Sales (93%)**. **Research & Development possui 86% dos colabores com alto desempenho** para esse período.
Para o perfil com **mais de 20 anos na empresa, Research & Development possui a parcela 93% com alta performance**, enquanto os demais setores estão na faixa dos 80%.

--

#### 🟨 Baixa Satisfação
- **Gênero e Faixa Etária:** Em comparação com a média geral, não há grande disparidade no nível de satisfação por gênero ou faixa etária. 

- **Tempo de Serviço:** No geral, a maior parte dos funcionários com 0 a 15 anos de serviço indicou baixa satisfação em relação à empresa. Colaboradores com 11-15 anos de serviço têm maior soma de insatisfação, 37% do total.

- **Departamento:** Os departamentos de Sales e Research & Development possuem a maior quantidade de funcionários não satisfeitos**. Em termos de proporção, juntos eles representam **30% dos colaboradores** insatisfeitos, com HR somando apenas 1,6% desse total. Para além disso, também possuem maior percentual de funcionários prontos para promoção.

- **Tempo para Promoção:** Associada às baixas avaliações está também a média de tempo para promoção, que pesa especialmente para o setor de Sales, que possui maior parte de insatisfeitos com **33% de colaboradores do setor** e tempo médio de **2,35 anos**, contra 1,78 de HR, mesmo ambos contando com os mesmos valores de desempenho.

--

#### 🟨 Alta Satisfação
- **Tempo de Serviço:** Os colaboradores com +20 anos de serviço possuem maior contentamento em relação a empresa, 45% indicou alta satisfação.

- **Departamento:** Human Resources é o setor mais satisfeito na empresa (e também o com menor tempo médio para promoção).

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
