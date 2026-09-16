
-- PROJETO: Modelagem de Banco de Dados — Legal Ops 
-- SGBD: MySQL 8+



CREATE DATABASE IF NOT EXISTS legal_ops;
USE legal_ops;

CREATE TABLE cliente (
    id_cliente      INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(150) NOT NULL,
    cpf_cnpj        VARCHAR(18) NOT NULL,
    contato         VARCHAR(100),
    CONSTRAINT uq_cliente_cpf_cnpj UNIQUE (cpf_cnpj)
);

CREATE TABLE contrato (
    id_contrato     INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente      INT NOT NULL,
    data_inicio     DATE NOT NULL,
    data_fim        DATE,
    status          VARCHAR(20) NOT NULL,
    CONSTRAINT fk_contrato_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_contrato_status
        CHECK (status IN ('ativo', 'em renovação', 'encerrado', 'cancelado')),
    CONSTRAINT chk_contrato_datas
        CHECK (data_fim IS NULL OR data_fim >= data_inicio)
);


CREATE TABLE processo (
    id_processo     INT AUTO_INCREMENT PRIMARY KEY,
    id_contrato     INT NOT NULL,
    complexidade    VARCHAR(20) NOT NULL,
    CONSTRAINT fk_processo_contrato
        FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_processo_complexidade
        CHECK (complexidade IN ('baixa', 'média', 'alta'))

);

CREATE TABLE advogado (
    id_advogado     INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(150) NOT NULL,
    especialidade   VARCHAR(100) NOT NULL,
    senioridade     VARCHAR(20) NOT NULL,
    CONSTRAINT chk_advogado_senioridade
        CHECK (senioridade IN ('júnior', 'pleno', 'sênior'))
);


CREATE TABLE processo_advogado (
    id_processo     INT NOT NULL,
    id_advogado     INT NOT NULL,
    PRIMARY KEY (id_processo, id_advogado),
    CONSTRAINT fk_pa_processo
        FOREIGN KEY (id_processo) REFERENCES processo(id_processo)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pa_advogado
        FOREIGN KEY (id_advogado) REFERENCES advogado(id_advogado)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE risco (
    id_risco        INT AUTO_INCREMENT PRIMARY KEY,
    id_processo     INT NOT NULL,
    tipo            VARCHAR(100) NOT NULL,
    nivel           VARCHAR(10) NOT NULL,
    descricao       TEXT,
    CONSTRAINT fk_risco_processo
        FOREIGN KEY (id_processo) REFERENCES processo(id_processo)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_risco_nivel
        CHECK (nivel IN ('baixo', 'médio', 'alto')),
    CONSTRAINT chk_risco_descricao_obrigatoria
        CHECK (nivel <> 'alto' OR (descricao IS NOT NULL AND descricao <> ''))
);

CREATE INDEX idx_contrato_status ON contrato(status);

CREATE INDEX idx_contrato_data_fim ON contrato(data_fim);

SHOW TABLES;

SELECT * FROM processo_advogado;

SELECT id_advogado, COUNT(id_processo)
FROM processo_advogado
GROUP BY id_advogado;

SELECT advogado.nome, COUNT(processo_advogado.id_processo) AS total_processos
FROM processo_advogado
JOIN advogado ON processo_advogado.id_advogado = advogado.id_advogado
GROUP BY advogado.id_advogado, advogado.nome
ORDER BY total_processos DESC;

SELECT id_contrato, id_cliente, data_fim 
FROM contrato
WHERE data_fim >= CURDATE() AND data_fim <= DATE_ADD(CURDATE(), INTERVAL 30 DAY);

SELECT risco.tipo, risco.descricao, processo.complexidade
FROM risco 
JOIN processo ON risco.id_processo = processo.id_processo 
WHERE risco.nivel = 'alto'

SELECT risco.tipo, risco.descricao, processo.complexidade, cliente.nome
FROM risco
JOIN processo ON risco.id_processo = processo.id_processo
JOIN contrato ON processo.id_contrato = contrato.id_contrato
JOIN cliente ON contrato.id_cliente = cliente.id_cliente
WHERE risco.nivel = 'alto';
