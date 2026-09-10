-- ================================================================
-- SAPA v9.0 — Banco Supabase CORRIGIDO
-- Correções aplicadas vs. versão anterior:
--   1. grade_horarios.dia_semana: INTEGER → TEXT  (compatível com calendar_engine.py)
--   2. logs.ra_aluno: ON DELETE RESTRICT → ON DELETE SET NULL  (permite excluir alunos)
--   3. logs: coluna "hora TEXT" adicionada  (usada por faltas automáticas e sync)
-- Cole TUDO no SQL Editor do Supabase e clique em RUN
-- ================================================================

-- Limpa tudo na ordem certa (CASCADE cuida das FKs)
DROP TABLE IF EXISTS public.sync_queue     CASCADE;
DROP TABLE IF EXISTS public.logs           CASCADE;
DROP TABLE IF EXISTS public.grade_horarios CASCADE;
DROP TABLE IF EXISTS public.disciplinas    CASCADE;
DROP TABLE IF EXISTS public.professores    CASCADE;
DROP TABLE IF EXISTS public.alunos         CASCADE;
DROP VIEW  IF EXISTS public.vw_presenca;

-- ── 1. ALUNOS ─────────────────────────────────────────────────────────────────
CREATE TABLE public.alunos (
    ra        INTEGER PRIMARY KEY,
    nome      TEXT    NOT NULL,
    turma     TEXT    NOT NULL,
    criado_em TIMESTAMPTZ DEFAULT NOW()
);

-- ── 2. PROFESSORES ────────────────────────────────────────────────────────────
CREATE TABLE public.professores (
    id             SERIAL PRIMARY KEY,
    nome_professor TEXT    NOT NULL UNIQUE,
    email          TEXT,
    telefone       TEXT,
    senha_hash     TEXT,
    is_admin       BOOLEAN DEFAULT FALSE,
    criado_em      TIMESTAMPTZ DEFAULT NOW()
);

-- ── 3. DISCIPLINAS ────────────────────────────────────────────────────────────
CREATE TABLE public.disciplinas (
    id             SERIAL PRIMARY KEY,
    nome_materia   TEXT,
    professor_nome TEXT,
    semestre       TEXT,
    bloco          TEXT,
    data_inicio    TEXT,
    data_fim       TEXT,
    dia_semana     TEXT,   -- "Segunda-feira", "Terça-feira" … "Domingo"
    criado_em      TIMESTAMPTZ DEFAULT NOW()
);

-- ── 4. GRADE DE HORÁRIOS ──────────────────────────────────────────────────────
CREATE TABLE public.grade_horarios (
    id            SERIAL PRIMARY KEY,
    disciplina_id INTEGER REFERENCES public.disciplinas(id) ON DELETE CASCADE,
    -- CORREÇÃO 1: era INTEGER (0-6). Agora TEXT para bater com calendar_engine.py
    -- que salva "Segunda-feira", "Terça-feira" etc.
    dia_semana    TEXT,
    hora_inicio   TEXT,
    hora_fim      TEXT,
    turma         TEXT,
    criado_em     TIMESTAMPTZ DEFAULT NOW()
);

-- ── 5. LOGS DE PRESENÇA ───────────────────────────────────────────────────────
CREATE TABLE public.logs (
    id            BIGSERIAL PRIMARY KEY,
    -- CORREÇÃO 2: era ON DELETE RESTRICT — impedia excluir alunos com histórico.
    -- SET NULL preserva o log mas desvincula o aluno excluído.
    ra_aluno      INTEGER REFERENCES public.alunos(ra) ON DELETE SET NULL,
    data          TEXT,
    -- CORREÇÃO 3: coluna "hora" faltava. Usada por faltas automáticas e sync_manager.
    hora          TEXT,
    hora_entrada  TEXT,
    hora_saida    TEXT,
    disciplina    TEXT,
    tipo          TEXT CHECK (tipo IN ('ENTRADA','SAIDA','FALTA','JUSTIFICADO')),
    justificativa TEXT,
    registrado_em TIMESTAMPTZ DEFAULT NOW()
);

-- Índices para queries do Power BI (filtros por data, aluno e status)
CREATE INDEX idx_logs_data ON public.logs(data);
CREATE INDEX idx_logs_ra   ON public.logs(ra_aluno);
CREATE INDEX idx_logs_tipo ON public.logs(tipo);

-- ── 6. FILA DE SYNC ───────────────────────────────────────────────────────────
CREATE TABLE public.sync_queue (
    id         BIGSERIAL PRIMARY KEY,
    payload    JSONB       NOT NULL,
    tentativas SMALLINT    DEFAULT 0,
    enviado    BOOLEAN     DEFAULT FALSE,
    criado_em  TIMESTAMPTZ DEFAULT NOW()
);

-- ⚠️ Protótipo: as policies abaixo liberam tudo. Em produção, use a service_role
--    só no backend e crie policies restritivas por tabela.
-- ── 7. RLS — libera service_role (chave usada pelo Python) ───────────────────
ALTER TABLE public.alunos         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.professores    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.disciplinas    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.grade_horarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.logs           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sync_queue     ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_all" ON public.alunos         USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON public.professores    USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON public.disciplinas    USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON public.grade_horarios USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON public.logs           USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON public.sync_queue     USING (true) WITH CHECK (true);

-- ── 8. VIEW PARA POWER BI ────────────────────────────────────────────────────
-- Conecte direto a esta view no Power BI: fica muito mais simples.
CREATE OR REPLACE VIEW public.vw_presenca AS
SELECT
    l.id            AS log_id,
    l.data,
    l.hora,
    l.hora_entrada,
    l.hora_saida,
    l.tipo          AS status,
    l.justificativa,
    l.disciplina,
    l.registrado_em,
    a.ra,
    a.nome          AS aluno_nome,
    a.turma,
    d.nome_materia,
    d.semestre,
    d.bloco,
    d.data_inicio   AS disciplina_inicio,
    d.data_fim      AS disciplina_fim,
    p.nome_professor AS professor
FROM public.logs l
LEFT JOIN public.alunos      a ON a.ra = l.ra_aluno
LEFT JOIN public.disciplinas d
    ON  d.nome_materia   || ' - '
     || d.semestre       || ' ('
     || d.bloco          || ') - '
     || d.professor_nome = l.disciplina
LEFT JOIN public.professores p ON p.nome_professor = d.professor_nome;

-- ── 9. ALUNOS DE EXEMPLO (FICTÍCIOS — dados reais não são versionados, LGPD) ──
INSERT INTO public.alunos (ra, nome, turma) VALUES
(10001,'Aluno Exemplo A1','A'),
(10002,'Aluno Exemplo A2','A'),
(20001,'Aluno Exemplo B1','B'),
(20002,'Aluno Exemplo B2','B'),
(30001,'Aluno Exemplo C1','C'),
(30002,'Aluno Exemplo C2','C')
ON CONFLICT (ra) DO UPDATE SET nome = EXCLUDED.nome, turma = EXCLUDED.turma;

-- ── 10. PROFESSOR INICIAL ─────────────────────────────────────────────────────
INSERT INTO public.professores (nome_professor, email, senha_hash) VALUES
('Professor Exemplo', 'professor@exemplo.com', NULL)
ON CONFLICT (nome_professor) DO UPDATE SET email = EXCLUDED.email;

-- ── VERIFICAÇÃO FINAL ─────────────────────────────────────────────────────────
SELECT
    'alunos'         AS tabela, COUNT(*) AS registros FROM public.alunos
UNION ALL SELECT 'professores',    COUNT(*) FROM public.professores
UNION ALL SELECT 'disciplinas',    COUNT(*) FROM public.disciplinas
UNION ALL SELECT 'grade_horarios', COUNT(*) FROM public.grade_horarios
UNION ALL SELECT 'logs',           COUNT(*) FROM public.logs;
