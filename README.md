## De que maneira a transformação de dados estruturados de contratos e processos jurídicos em indicadores de Business Intelligence pode apoiar gestores na identificação de riscos recorrentes e na gestão da carga de trabalho das equipes?

## Contexto

Um escritório de advocacia fictício, com uma equipe de 15 advogados distribuídos entre as áreas cível, trabalhista, tributária e empresarial, atende contratos de diferentes clientes — de construtoras a redes de alimentação. Cada contrato pode originar múltiplos processos, cada processo pode envolver mais de um advogado, e cada processo pode carregar riscos de diferentes níveis de gravidade.

## O problema

Sem um sistema estruturado, esse é o cenário: **um escritório perdido com a demanda de processos**. Advogados sobrecarregados sem que isso seja percebido a tempo. Prazos de contrato que não são visualmente identificados com facilidade, aumentando o risco de perdê-los. Uma equipe com potencial técnico real, mas desorganizada por falta de uma estrutura de apoio que centralize a informação.

O problema não é falta de competência jurídica — é falta de **visibilidade**. Decisões de alocação de equipe, priorização de risco e gestão de prazo são tomadas de forma reativa, não estratégica.

## A solução

Este projeto estrutura os dados de clientes, contratos, processos, equipe e riscos num banco de dados relacional, servindo de base para um dashboard analítico que reúne essas informações em um só lugar, de fácil acesso e visualização.

O design pensa em dois públicos, com necessidades diferentes:

- **Os advogados**, que precisam acompanhar sua própria carga de processos e prazos no dia a dia — sem precisar entender de BI ou de jargões técnicos de TI para compreender a dinâmica do escritório.
- **O gestor/dono do escritório**, que precisa de uma visão estratégica: acompanhar o andamento dos processos, identificar riscos altos em aberto e tomar decisões de alocação de equipe **sem gerar sobrecarga em quem já está no limite, nem comprometer o andamento de outras demandas**.

## Abordagem técnica (visão geral)

O projeto percorreu o ciclo completo de modelagem de dados antes de qualquer construção de dashboard:

1. **Levantamento de requisitos** — perguntas de negócio reais guiaram cada decisão de modelagem, evitando um banco "genérico" desconectado da necessidade do gestor.
2. **Modelagem conceitual e lógica** — entidades, relacionamentos e regras de negócio (como a diferença entre Contrato e Processo, e a necessidade de rastrear riscos por nível de gravidade).
3. **Modelo físico** — implementação em MySQL, com constraints que garantem a integridade das regras de negócio diretamente no banco (não apenas na aplicação).
4. **Validação via queries** — cada pergunta de negócio original foi respondida com SQL antes de qualquer visualização, garantindo que os dados realmente sustentam as perguntas que o projeto se propõe a responder.
5. **Camada de BI** — o banco relacional serve como fonte de dados viva para um dashboard em Power BI, fechando o pipeline da modelagem à visualização.

Detalhes técnicos completos (schema, decisões de modelagem, constraints) estão documentados no [README técnico](./MODELAGEM.md).

## Impacto esperado

Ao transformar dados dispersos em indicadores acessíveis, o projeto endereça diretamente os dois sintomas do problema original:

- **Riscos recorrentes** deixam de ser descobertos tarde — processos com riscos de nível alto ficam visíveis e rastreáveis até o cliente de origem.
- **Sobrecarga da equipe** deixa de ser invisível — a carga de processos por advogado é calculada e visualizada, permitindo decisões de alocação mais equilibradas.
