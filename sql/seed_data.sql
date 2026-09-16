==========================
SEED DATA: Legal Ops (dados fictícios)
Ordem de inserção respeita as dependências de FK.
==========================

USE legal_ops;

INSERT INTO cliente (nome, cpf_cnpj, contato) VALUES
('Construtora PE Ltda.', '12.345.678/0001-90', 'contato@peconstrutora.com.br'),
('Ana Beatriz Ferreira', '123.456.789-01', 'ana.ferreira@email.com'),
('Distribuidora Vale Verde S.A.', '23.456.789/0001-11', '@juridico@valeverde.com.br'),
('Marcos Antônio Ribeiro', '234.567.890-12', 'marcos.ribeiro@email.com'),
('Rede Sabor & Cia Alimentos Ltda.', '34.567.890/0001-22', 'compliance@saborcia.com.br');


INSERT INTO advogado (nome, especialidade, senioridade) VALUES
('Fernanda Lima Souza', 'cível', 'sênior'),
('Rafael Augusto Mendes', 'cível', 'pleno'),
('Camila Torres Nogueira', 'cível', 'pleno'),
('Bruno Cardoso Alves', 'cível', 'júnior'),
('Patrícia Gomes Rocha', 'trabalhista', 'sênior' ),
('Thiago Martins Barros', 'trabalhista', 'pleno'),
('Juliana Castro Pires', 'trabalhista', 'pleno'),
('Diego Fernandes Costa', 'trabalhista', 'júnior'),
('Renata Almeida Duarte', 'tributário', 'sênior'),
('Gustavo Henrique Prado', 'tributário', 'pleno'),
('Larissa Monteiro Vaz', 'tributário', 'pleno'),
('Eduardo Silva Nascimento', 'tributário', 'sênior'),
('Marina Costa Ribeiro', 'empresarial', 'sênior'),
('Felipe Andrade Santos', 'empresarial', 'pleno'),
('Isabela Rezende Moura', 'empresarial', 'júnior');

INSERT INTO contrato (id_cliente, data_inicio, data_fim, status) VALUES
(1, '2024-03-01', '2026-09-15', 'ativo'),
(1, '2025-01-10', '2027-01-10', 'ativo'),
(2, '2024-06-01', '2026-09-05', 'em renovação'),
(3, '2023-05-15', '2025-05-15', 'encerrado'),
(3, '2025-08-01', '2027-08-01', 'ativo'),
(4, '2024-11-20', '2026-11-20', 'ativo'),
(5, '2022-02-10', '2024-02-10', 'cancelado'),
(5, '2025-03-01', '2026-10-01', 'ativo');

INSERT INTO processo (id_contrato, complexidade) VALUES
(1, 'alta'),
(1, 'média'),
(2, 'baixa'),
(3, 'média'),
(3, 'alta'),
(4, 'baixa'),
(5, 'média'),
(5, 'alta'),
(5, 'baixa'),
(6, 'média'),
(7, 'baixa'),
(8, 'alta'),
(8, 'média'),
(8, 'baixa');

INSERT INTO processo_advogado (id_processo, id_advogado) VALUES
(1,1), (1,2),
(2,3),
(3,8),
(4,10),
(5,9), (5,10),
(6,15),
(7,14),
(8,13), (8,14),
(9,4),
(10,6),
(11,4),
(12,5), (12,7), (12,8),
(13,11),
(14,15);

INSERT INTO risco (id_processo, tipo, nivel, descricao) VALUES
(1, 'risco de multa', 'alto', 'Cláusula de multa rescisória pode gerar passivo relevante caso o contrato seja rompido antes do prazo'),
(1, 'risco de prazo', 'médio', NULL),
(3, 'risco trabalhista', 'baixo', NULL),
(5, 'risco de autuação fiscal', 'alto', 'Divergência identificada no recolhimento do ICMS pode motivar autuação da Receita Estadual'),
(5, 'risco reputacional', 'baixo', NULL),
(8, 'risco societário', 'alto', 'Alteração no quadro societário sem registro pode invalidar decisões tomadas em assembleia recente.'),
(8, 'risco contratual', 'médio', NULL),
(12, 'risco de indenização coletiva', 'alto', 'Ação trabalhista coletiva envolve múltiplos reclamantes e pode resultar em indenização de valor elevado'),
(12, 'risco de prazo', 'médio', NULL),
(13, 'risco tributário', 'baixo', NULL);

SELECT * FROM cliente;

SELECT contrato.id_contrato, cliente.nome, contrato.data_fim
FROM contrato
JOIN cliente ON contrato.id_cliente = cliente.id_cliente
WHERE contrato.status = 'ativo';
