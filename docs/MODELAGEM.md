# Legal Ops — Modelagem de Banco de Dados do Zero

Projeto de estudo de caso completo: modelagem de um banco de dados relacional para um escritório de advocacia fictício, cobrindo todo o ciclo — levantamento de requisitos, modelo conceitual, lógico, físico (DDL), povoamento com dados fictícios e queries analíticas.

Projeto construído com foco em **entender cada decisão de modelagem**, não apenas produzir um schema funcional — por isso este README documenta o raciocínio por trás das escolhas, não só o resultado.

## Contexto e escopo

Domínio fictício: um escritório de advocacia que precisa responder perguntas como:
- Quais contratos estão ativos, e quais vencem em breve?
- Quantos processos cada advogado está tocando (carga de trabalho)?
- Quais processos têm riscos de nível alto, e de qual cliente são?

Essas perguntas de negócio guiaram todo o levantamento de requisitos — cada entidade e atributo do modelo existe porque uma pergunta real precisava dela, não porque "parecia fazer sentido" ter.

## Modelo conceitual

Entidades identificadas e seus relacionamentos:

- **Cliente** — assina Contratos
- **Contrato** — pertence a um Cliente; contém um ou mais Processos
- **Processo** — pertence a um Contrato; tem uma equipe de Advogados (N:N); pode ter vários Riscos
- **Advogado** — atua em vários Processos, inclusive de clientes diferentes
- **Risco** — pertence a um Processo; tem tipo, nível e (condicionalmente) descrição

## Decisões de modelagem e seus porquês

Esta seção é o coração do projeto — cada decisão abaixo foi tomada conscientemente, considerando trade-offs reais.

**Cliente ↔ Contrato ↔ Processo é uma cadeia, não uma rede.** Um cliente assina contratos; dentro de cada contrato podem existir vários processos judiciais. Essa hierarquia reflete como um escritório real organiza o trabalho de um cliente.

**Advogado ↔ Processo é N:N, resolvido via tabela intermediária (`processo_advogado`).** Um processo pode ter uma equipe de vários advogados (dependendo da complexidade do caso); um advogado pode atuar em processos de clientes diferentes simultaneamente. Optamos por manter essa tabela simples (sem atributos próprios como "papel" ou "data de entrada") para controlar o escopo do projeto — uma evolução natural seria adicionar esses atributos caso o negócio precisasse rastrear responsabilidades dentro da equipe.

**"Carga de processos" de um advogado não é uma coluna — é um valor derivado.** Em vez de armazenar um contador que precisaria ser atualizado manualmente, a carga é calculada em tempo real via `COUNT()` sobre a tabela `processo_advogado`. Isso evita inconsistência entre o dado armazenado e a realidade.

**Complexidade do Processo é um campo único, sem histórico.** Decisão consciente de escopo: reconhecemos que a complexidade poderia mudar ao longo do processo (e que isso poderia justificar uma tabela de auditoria/histórico no futuro), mas optamos por manter simples nesta versão.

**Risco é uma entidade própria, não um campo do Processo.** Um processo pode ter múltiplos riscos distintos (ex: risco de multa, risco de prazo), cada um com seu próprio nível. A regra de negócio "descrição só é obrigatória quando o nível é alto" foi implementada via `CHECK constraint` no banco — não depende de validação na aplicação, o banco garante a integridade.

**Chaves primárias técnicas (id auto-incrementado), não CPF/CNPJ.** CPF/CNPJ pode ter fragmentos coincidentes entre pessoas diferentes e, em teoria, pode ser retificado — uma chave primária não deveria depender de um dado que pode mudar. O CPF/CNPJ é mantido como campo `UNIQUE`, garantindo não-duplicidade sem sustentar os relacionamentos do banco.

**Regras de integridade referencial pensadas caso a caso:**
- `Cliente → Contrato`: **RESTRICT** — impede excluir um cliente que ainda tenha contratos, preservando histórico jurídico/financeiro.
- `Contrato → Processo`, `Processo → Risco`, tabela `processo_advogado`: **CASCADE** — esses registros não têm valor de existir sem o "pai" (um risco não existe sem o processo, uma linha de alocação não existe sem o vínculo).

**Tipos de dado escolhidos com justificativa, não por padrão:**
- Campos de valores fixos (`status`, `nivel`, `complexidade`) usam `VARCHAR` + `CHECK constraint` em vez de `ENUM` — mais fácil de alterar os valores permitidos no futuro, sem depender de sintaxe específica de ENUM do MySQL.
- Campos de texto curto e previsível (`nome`, `especialidade`) usam `VARCHAR`; só `descricao` do Risco (que pode ser um texto mais longo e explicativo) usa `TEXT`.

## Estrutura do banco

6 tabelas: `cliente`, `contrato`, `processo`, `advogado`, `processo_advogado` (tabela associativa), `risco`.

SGBD: **MySQL 8+**

Arquivos:
- `schema.sql` — DDL completo (estrutura das tabelas, constraints, índices)
- `seed_data.sql` — dados fictícios para testes e demonstração

## Queries de negócio

O projeto fecha o ciclo respondendo, via SQL, às perguntas de negócio originais:

1. **Contratos ativos** — `SELECT` com `WHERE` e `JOIN` até Cliente
2. **Carga de processos por advogado** — `GROUP BY` + `COUNT()` + `JOIN` + `ORDER BY`
3. **Contratos vencendo nos próximos 30 dias** — filtro de intervalo de datas com `CURDATE()` e `DATE_ADD()`
4. **Riscos de nível alto, com cliente de origem** — encadeamento de 3 `JOIN`s (`risco → processo → contrato → cliente`)

## Possíveis evoluções futuras

- Histórico de mudanças de complexidade do Processo (tabela de auditoria)
- Atributos na relação Advogado-Processo (papel, data de alocação)
- Views para as queries de negócio mais usadas
- Camada de aplicação (API) consumindo esse banco

## Autor

Jullya — projeto desenvolvido como estudo de caso para portfólio, com foco em Data Governance e Legal Ops.
