CREATE OR REPLACE PROCEDURE Inserir_Dados_Aleatorios(p_qtde IN NUMBER) AS
    v_id_instituicao NUMBER;
    v_id_localidade NUMBER;
    v_id_agencia NUMBER;
    v_id_cliente NUMBER;
    v_id_conta NUMBER;
    v_id_transacao NUMBER;

BEGIN
    FOR i IN 1..p_qtde LOOP
        -- Inserir na tabela INSTITUICAO
        v_id_instituicao := i;
        INSERT INTO INSTITUICAO (id_instituicao, nome_instituicao)
        VALUES (
            v_id_instituicao, 
            DBMS_RANDOM.STRING('U', 60)  -- Nome da instituição
        );

        -- Inserir na tabela LOCALIDADE
        v_id_localidade := i;
        INSERT INTO LOCALIDADE (id_localidade, cidade, estado, pais, cep, bairro, logradouro)
        VALUES (
            v_id_localidade, 
            DBMS_RANDOM.STRING('U', 60),  -- Cidade
            DBMS_RANDOM.STRING('U', 60),  -- Estado
            DBMS_RANDOM.STRING('U', 60),  -- País
            LPAD(ROUND(DBMS_RANDOM.VALUE(100000000, 999999999)), 9, '0'),  -- CEP
            DBMS_RANDOM.STRING('U', 120),  -- Bairro
            DBMS_RANDOM.STRING('U', 120)   -- Logradouro
        );

        -- Inserir na tabela AGENCIA
        v_id_agencia := i;
        INSERT INTO AGENCIA (id_agencia, nome_agencia, numero_agencia, id_instituicao, id_localidade)
        VALUES (
            v_id_agencia, 
            DBMS_RANDOM.STRING('U', 60),  -- Nome da agência
            ROUND(DBMS_RANDOM.VALUE(1, 99999)),  -- Número da agência
            v_id_instituicao, 
            v_id_localidade
        );

        -- Inserir na tabela CLIENTE
        v_id_cliente := i;
        INSERT INTO CLIENTE (id_cliente, tipo_cliente, cpf, nome, sobrenome, sexo, razao_social, cnpj, id_localidade)
        VALUES (
            v_id_cliente, 
            'PF',  -- Tipo de cliente
            LPAD(ROUND(DBMS_RANDOM.VALUE(10000000000, 99999999999)), 11, '0'),  -- CPF
            DBMS_RANDOM.STRING('U', 5) || ' ' || v_id_cliente,  -- Nome
            DBMS_RANDOM.STRING('U', 5) || ' ' || v_id_cliente,  -- Sobrenome
            CASE WHEN MOD(v_id_cliente, 2) = 0 THEN 'M' ELSE 'F' END,  -- Sexo alternando entre M e F
            DBMS_RANDOM.STRING('U', 60),  -- Razão social
            LPAD(ROUND(DBMS_RANDOM.VALUE(10000000000000, 99999999999999)), 14, '0'),  -- CNPJ
            v_id_localidade
        );

        -- Inserir na tabela CONTA
        v_id_conta := i;
        INSERT INTO CONTA (id_conta, numero_conta, digito, data_abertura, id_agencia, id_cliente)
        VALUES (
            v_id_conta, 
            LPAD(ROUND(DBMS_RANDOM.VALUE(10000000, 99999999)), 8, '0'),  -- Número da conta
            '0',  -- Dígito
            SYSDATE, 
            v_id_agencia, 
            v_id_cliente
        );

        -- Inserir na tabela TRANSACAO
        v_id_transacao := i;
        INSERT INTO TRANSACAO (id_transacao, data_transacao, tipo_transacao, valor, descricao, id_conta)
        VALUES (
            v_id_transacao, 
            SYSDATE, 
            CASE WHEN MOD(v_id_transacao, 2) = 0 THEN 'D' ELSE 'C' END,  -- Tipo de transação (D ou C)
            ROUND(DBMS_RANDOM.VALUE(10, 1000), 2),  -- Valor
            'Transacao ' || v_id_transacao,  -- Descrição
            v_id_conta
        );
    END LOOP;

    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Valor duplicado encontrado. Insira menos registros ou ajuste os dados.');
        ROLLBACK;
END Inserir_Dados_Aleatorios;
