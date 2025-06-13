def gerar_previsoes():
    import warnings
    import pandas as pd
    import matplotlib.pyplot as plt
    import seaborn as sns
    from sklearn.ensemble import RandomForestClassifier
    from sklearn.model_selection import GridSearchCV
    from sklearn.model_selection import train_test_split
    import time
    import numpy as np
    import joblib
    from sklearn.preprocessing import LabelEncoder
    from sklearn.metrics import mean_squared_error, precision_score, recall_score, accuracy_score, roc_auc_score, confusion_matrix
    from imblearn import under_sampling, over_sampling
    from imblearn.over_sampling import SMOTE
    from sklearn.preprocessing import MinMaxScaler # fazer a padronização
    from sklearn.metrics import r2_score # medir a acurácia
    import pymssql as sql
    import socket

    warnings.filterwarnings('ignore')
    pd.set_option('display.max_columns', None)
    pd.set_option('display.max_rows', None)

    clf = joblib.load('modelo_treinado.pk')

    print('Pacotes carregados com sucesso!')

    # Criando conexão com SQL Server
    conexao = sql.connect(
        server='DESKTOP-CR5F8QN',
        user='sa',
        password='137',
        database='MODELOS_PREDITIVOS')

    # Consulta ao banco de dados
    df = pd.read_sql_query('SELECT * FROM EXTRACAO_DADOS_SISTEMA', conexao)
    conexao.close()

    # Exclusão de valores nulos
    df.dropna(inplace=True)

    # Criando faixa de prazos
    bins = [-1, 120, 180, 240]
    labels = ['Até 120 meses', '121 até 180 meses', '181 até 240 meses']
    df['FAIXA_PRAZO_FINANCIAMENTO'] = pd.cut(df['PZ_FINANCIAMENTO'], bins=bins, labels=labels)
    pd.value_counts(df.FAIXA_PRAZO_FINANCIAMENTO)

    # Criando faixa de valor financiado
    bins = [-1, 100000, 200000, 300000, 400000, 500000, 750000, 1000000, 900000000]
    labels = ['Até 100 mil', '101 até 200 mil', '201 até 300 mil', '301 até 400 mil',
            '401 até 500 mil', '501 até 750 mil', '750 mil até 1 milhão', 'Acima de 1 milhão']
    df['FAIXA_VALOR_FINANCIADO'] = pd.cut(df['VALOR_FINANCIAMENTO'], bins=bins, labels=labels)
    pd.value_counts(df.FAIXA_VALOR_FINANCIADO)

    # Selecionando colunas
    columns = ['TAXA_AO_ANO', 'CIDADE_CLIENTE', 'ESTADO_CLIENTE','RENDA_MENSAL_CLIENTE', 
            'QT_PC_ATRASO', 'QT_DIAS_PRIM_PC_ATRASO','QT_TOTAL_PC_PAGAS',
            'VL_TOTAL_PC_PAGAS', 'QT_PC_PAGA_EM_DIA','QT_DIAS_MIN_ATRASO',
            'QT_DIAS_MAX_ATRASO', 'QT_DIAS_MEDIA_ATRASO','VALOR_PARCELA',
            'IDADE_DATA_ASSINATURA_CONTRATO', 'FAIXA_VALOR_FINANCIADO',
            'FAIXA_PRAZO_FINANCIAMENTO','INADIMPLENTE_COBRANCA']

    df_tratado = pd.DataFrame(df, columns=columns)

    # Carregando as variáveis categóricas para OneHotEncoding (exceto a variável target)
    var_categoricas = []
    for i in df_tratado.columns[0:16].tolist():
        if df_tratado.dtypes[i] == 'object' or df_tratado.dtypes[i] == 'category':
            var_categoricas.append(i)

            # Criando o encoder e aplicando o OneHotEncoder
    lb = LabelEncoder()

    for var in var_categoricas:
        df_tratado[var] = lb.fit_transform(df_tratado[var])

        # Separar variáveis preditoras e target
    PREDITORAS = df_tratado.iloc[:, 0:15]

    # Normalizando as variáveis
    normalizador = MinMaxScaler()
    dados_normalizados = normalizador.fit_transform(PREDITORAS)

    # Gerando previsões
    previsoes = clf.predict(dados_normalizados)
    probabilidades = clf.predict_proba(dados_normalizados)
    df['PREVISOES'] = previsoes
    df['PROBABILIDADES'] = probabilidades[:,1]

    # Separando as colunas que serão utilizadas para inserção
    columns = ['NUMERO_CONTRATO', 'PREVISOES', 'PROBABILIDADES']
    df_conversao = pd.DataFrame(df, columns=columns)

    # Criando conexão com o SQL Server
    conexao = sql.connect(
        server='DESKTOP-CR5F8QN',
        user='sa',
        password='137',
        database='MODELOS_PREDITIVOS'
    )

    # Criando um cursor e executando um LOOP no DataFrame para fazer o insert no banco SQL Server
    cursor = conexao.cursor()

    for index, row in df_conversao.iterrows():
        sql = 'INSERT INTO RESULTADOS_INTERMEDIARIOS (NUMERO_CONTRATO, PREVISOES, PROBABILIDADES) VALUES (%s, %s, %s)'
        val = (row['NUMERO_CONTRATO'], row['PREVISOES'], row['PROBABILIDADES'])
        cursor.execute(sql, val)
        conexao.commit()
        
    print("Previsões geradas com sucesso!")

    cursor.execute('EXEC SP_INPUT_RESULTADOS_MODELO_PREDITIVO')
    conexao.commit()
    conexao.close()
    print('Tabelas atualizadas!')

def main():
   gerar_previsoes()

if __name__ == '__main__':
    main()