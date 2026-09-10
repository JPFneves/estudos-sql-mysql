-- Jornada Científica UNISEP — Schema v2
-- MySQL 8.0+ | utf8mb4_unicode_ci
-- Run: mysql -u root -p jornada < schema_v2.sql

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ────────────────────────────────────────────────────────────────────────────
-- 1. Usuários (Single-Table Inheritance: estudante | orientador | coordenador | visitante)
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS usuarios (
    id          CHAR(36)     NOT NULL,
    tipo        ENUM('estudante','orientador','coordenador','visitante') NOT NULL,
    nome        VARCHAR(120) NOT NULL,
    email       VARCHAR(150)          UNIQUE,
    senha_hash  VARCHAR(255) NOT NULL,
    ra          VARCHAR(20)           UNIQUE,   -- estudante
    cpf         VARCHAR(14)           UNIQUE,   -- visitante
    curso       VARCHAR(100),
    criado_em   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    INDEX idx_usuarios_tipo (tipo),
    INDEX idx_usuarios_email (email),
    INDEX idx_usuarios_ra (ra)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ────────────────────────────────────────────────────────────────────────────
-- 2. Eventos / Palestras
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS eventos (
    id           CHAR(36)     NOT NULL,
    titulo       VARCHAR(200) NOT NULL,
    tipo         ENUM('palestra','minicurso','workshop','mesa-redonda','poster') NOT NULL,
    descricao    TEXT,
    ementa       TEXT,
    speaker      VARCHAR(150),
    speaker_bio  TEXT,
    carga_horaria TINYINT UNSIGNED NOT NULL DEFAULT 0,
    local        VARCHAR(150),
    vagas        SMALLINT UNSIGNED NOT NULL DEFAULT 0,    -- 0 = sem limite
    data_inicio  DATETIME     NOT NULL,
    data_fim     DATETIME     NOT NULL,
    status       ENUM('rascunho','aberto','encerrado','concluido') NOT NULL DEFAULT 'rascunho',
    criado_em    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id),
    INDEX idx_eventos_status (status),
    INDEX idx_eventos_datas (data_inicio, data_fim)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ────────────────────────────────────────────────────────────────────────────
-- 3. Inscrições em Eventos
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS inscricoes (
    id                   CHAR(36)    NOT NULL,
    evento_id            CHAR(36)    NOT NULL,
    usuario_id           CHAR(36)    NOT NULL,
    inscrito_em          DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    presenca             TINYINT(1)  NOT NULL DEFAULT 0,
    codigo_certificado   VARCHAR(20)          UNIQUE,

    PRIMARY KEY (id),
    UNIQUE KEY uq_inscricao (evento_id, usuario_id),
    CONSTRAINT fk_insc_evento   FOREIGN KEY (evento_id)  REFERENCES eventos  (id) ON DELETE CASCADE,
    CONSTRAINT fk_insc_usuario  FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE,
    INDEX idx_inscricoes_cert (codigo_certificado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ────────────────────────────────────────────────────────────────────────────
-- 4. Trabalhos Científicos
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS trabalhos (
    id              CHAR(36)    NOT NULL,
    lider_id        CHAR(36)    NOT NULL,
    orientador_id   CHAR(36)    NOT NULL,
    titulo          VARCHAR(250) NOT NULL,
    curso           VARCHAR(100) NOT NULL,

    -- Seções do artigo
    sec_introducao  TEXT,
    sec_objetivo    TEXT,
    sec_metodologia TEXT,
    sec_resultados  TEXT,
    sec_conclusao   TEXT,

    -- Arquivo PDF (caminho relativo ou URL)
    arquivo_url     VARCHAR(500),

    -- Status do fluxo
    status          ENUM('rascunho','aguardando','aprovado','reprovado','correcao') NOT NULL DEFAULT 'rascunho',
    observacoes     TEXT,

    -- RF11: Gestão da banca
    num_banca       VARCHAR(30),
    destaque        TINYINT(1)  NOT NULL DEFAULT 0,
    publicar_anais  TINYINT(1)  NOT NULL DEFAULT 0,
    media_final     DECIMAL(4,1),

    criado_em       DATE        NOT NULL,
    atualizado_em   DATE        NOT NULL,

    PRIMARY KEY (id),
    CONSTRAINT fk_trab_lider      FOREIGN KEY (lider_id)      REFERENCES usuarios (id),
    CONSTRAINT fk_trab_orientador FOREIGN KEY (orientador_id) REFERENCES usuarios (id),
    INDEX idx_trabalhos_status   (status),
    INDEX idx_trabalhos_destaque (destaque),
    INDEX idx_trabalhos_anais    (publicar_anais)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ────────────────────────────────────────────────────────────────────────────
-- 5. Coautores (RF10: até 9)
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS co_autores (
    id           INT UNSIGNED AUTO_INCREMENT,
    trabalho_id  CHAR(36)    NOT NULL,
    nome         VARCHAR(120) NOT NULL,
    ra           VARCHAR(20),
    curso        VARCHAR(100),
    ordem        TINYINT UNSIGNED NOT NULL DEFAULT 1,

    PRIMARY KEY (id),
    CONSTRAINT fk_coaut_trabalho FOREIGN KEY (trabalho_id) REFERENCES trabalhos (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ────────────────────────────────────────────────────────────────────────────
-- 6. Coorientadores (RF10: até 3)
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS co_orientadores (
    id           INT UNSIGNED AUTO_INCREMENT,
    trabalho_id  CHAR(36)    NOT NULL,
    nome         VARCHAR(120) NOT NULL,
    ordem        TINYINT UNSIGNED NOT NULL DEFAULT 1,

    PRIMARY KEY (id),
    CONSTRAINT fk_coori_trabalho FOREIGN KEY (trabalho_id) REFERENCES trabalhos (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ────────────────────────────────────────────────────────────────────────────
-- 7. Palavras-chave
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS palavras_chave (
    id           INT UNSIGNED AUTO_INCREMENT,
    trabalho_id  CHAR(36)    NOT NULL,
    palavra      VARCHAR(80) NOT NULL,
    ordem        TINYINT UNSIGNED NOT NULL DEFAULT 1,

    PRIMARY KEY (id),
    CONSTRAINT fk_kw_trabalho FOREIGN KEY (trabalho_id) REFERENCES trabalhos (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ────────────────────────────────────────────────────────────────────────────
-- 8. Referências bibliográficas
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS referencias (
    id           INT UNSIGNED AUTO_INCREMENT,
    trabalho_id  CHAR(36)    NOT NULL,
    referencia   TEXT        NOT NULL,
    ordem        TINYINT UNSIGNED NOT NULL DEFAULT 1,

    PRIMARY KEY (id),
    CONSTRAINT fk_ref_trabalho FOREIGN KEY (trabalho_id) REFERENCES trabalhos (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ────────────────────────────────────────────────────────────────────────────
-- 9. Avaliadores designados por trabalho (RF11: até 3)
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS avaliadores_trabalho (
    trabalho_id  CHAR(36) NOT NULL,
    avaliador_id CHAR(36) NOT NULL,

    PRIMARY KEY (trabalho_id, avaliador_id),
    CONSTRAINT fk_avt_trabalho  FOREIGN KEY (trabalho_id)  REFERENCES trabalhos (id) ON DELETE CASCADE,
    CONSTRAINT fk_avt_avaliador FOREIGN KEY (avaliador_id) REFERENCES usuarios  (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ────────────────────────────────────────────────────────────────────────────
-- 10. Avaliações (RF10: 10 critérios, 0-10 cada)
-- ────────────────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS avaliacoes (
    trabalho_id  CHAR(36)      NOT NULL,
    avaliador_id CHAR(36)      NOT NULL,
    notas        JSON          NOT NULL,       -- array de 10 valores numéricos
    media        DECIMAL(4,1)  NOT NULL,
    comentario   TEXT,
    avaliado_em  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (trabalho_id, avaliador_id),
    CONSTRAINT fk_aval_trabalho  FOREIGN KEY (trabalho_id)  REFERENCES trabalhos (id) ON DELETE CASCADE,
    CONSTRAINT fk_aval_avaliador FOREIGN KEY (avaliador_id) REFERENCES usuarios  (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- ────────────────────────────────────────────────────────────────────────────
-- Seed: coordenador padrão (senha: coord@2025)
-- bcrypt($2y$12$...) gerado fora do SQL — substitua pelo hash real
-- ────────────────────────────────────────────────────────────────────────────
INSERT IGNORE INTO usuarios (id, tipo, nome, email, senha_hash) VALUES
(
    'coord-0000-0000-0000-000000000001',
    'coordenador',
    'Coordenador UNISEP',
    'coordenador@unisep.edu.br',
    -- Hash de 'coord@2025' (bcrypt cost=12) — gere com: php -r "echo password_hash('coord@2025', PASSWORD_BCRYPT, ['cost'=>12]);"
    '$2y$12$REPLACEME_WITH_REAL_BCRYPT_HASH_HERE_XXXXXXXXXXXXXXXXXXXX'
);
