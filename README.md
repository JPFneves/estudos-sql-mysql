# 🗄️ Estudos de SQL e modelagem de dados

Repositório de estudo de bancos de dados relacionais: do curso **SQL do básico ao avançado (com MySQL e Projeto)** (Udemy, 19,5 h, concluído em maio de 2026) às modelagens que uso nos meus projetos reais.

## 📚 O que estudei

- DDL e DML: criação e gerenciamento de bancos e tabelas, CRUD
- Constraints: chave primária, chave estrangeira, auto increment e not null
- JOINs (INNER, LEFT e RIGHT), funções de agregação e subqueries
- Funções de texto, números e datas
- Relacionamentos 1:1, 1:N e N:N
- Levantamento de requisitos, normalização e diagrama entidade-relacionamento
- Integração de PHP com MySQL

## 🏗️ Modelagens de projetos reais — [`projetos-reais/`](projetos-reais)

| Arquivo | Projeto | Banco | Destaques da modelagem |
|---|---|---|---|
| [`sapa-supabase-postgresql.sql`](projetos-reais/sapa-supabase-postgresql.sql) | [SAPA](https://github.com/JPFneves/sapa-presenca-academica) | PostgreSQL (Supabase) | Fila de sincronização em JSONB para o modo offline, `CHECK` nos status de presença, índices para os filtros do Power BI e uma `VIEW` pronta para o BI |
| [`jornada-cientifica-mysql.sql`](projetos-reais/jornada-cientifica-mysql.sql) | [Jornada Científica](https://github.com/JPFneves/jornada-cientifica-unisep) | MySQL | 10 tabelas, relacionamentos N:N (coautores, coorientadores e avaliadores) e avaliações da banca |
| [`erp-industria-postgresql.sql`](projetos-reais/erp-industria-postgresql.sql) | [ERP Indústria de Alimentos](https://github.com/JPFneves/erp-industria-alimentos) | PostgreSQL 16 | 14 tabelas: rastreabilidade da produção, estoque de insumos e câmara fria, vendas, financeiro e RH |

> Os arquivos contêm apenas a estrutura e dados de exemplo fictícios.

## 🎓 Exercícios da faculdade

Os trabalhos de banco de dados do curso (sistema hospitalar, clínica médica e consultas com JOIN) estão em [faculdade-ads-projetos/04-banco-de-dados](https://github.com/JPFneves/faculdade-ads-projetos/tree/main/04-banco-de-dados).
