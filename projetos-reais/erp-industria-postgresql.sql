--
-- PostgreSQL database dump
--


-- Dumped from database version 16.14 (Ubuntu 16.14-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.14 (Ubuntu 16.14-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    id integer NOT NULL,
    nome text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- Name: clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clientes_id_seq OWNER TO postgres;

--
-- Name: clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;


--
-- Name: controle_camara_fria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.controle_camara_fria (
    id integer NOT NULL,
    responsavel text DEFAULT 'Responsável'::text,
    created_at timestamp with time zone DEFAULT now(),
    temperatura_c numeric,
    qtd_caixas integer,
    observacao text,
    data date
);


ALTER TABLE public.controle_camara_fria OWNER TO postgres;

--
-- Name: controle_camara_fria_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.controle_camara_fria_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.controle_camara_fria_id_seq OWNER TO postgres;

--
-- Name: controle_camara_fria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.controle_camara_fria_id_seq OWNED BY public.controle_camara_fria.id;


--
-- Name: controle_fritura; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.controle_fritura (
    id integer NOT NULL,
    turno text DEFAULT '01'::text,
    operador text,
    created_at timestamp with time zone DEFAULT now(),
    temperatura_c numeric,
    temperatura_segundos numeric,
    data date
);


ALTER TABLE public.controle_fritura OWNER TO postgres;

--
-- Name: controle_fritura_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.controle_fritura_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.controle_fritura_id_seq OWNER TO postgres;

--
-- Name: controle_fritura_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.controle_fritura_id_seq OWNED BY public.controle_fritura.id;


--
-- Name: controle_higienizacao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.controle_higienizacao (
    id integer NOT NULL,
    frequencia text,
    equipamento text,
    produto_limpeza text DEFAULT 'Detergente Neutro'::text,
    responsavel text DEFAULT 'Responsável'::text,
    observacao text,
    created_at timestamp with time zone DEFAULT now(),
    verificacao text,
    data date
);


ALTER TABLE public.controle_higienizacao OWNER TO postgres;

--
-- Name: controle_higienizacao_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.controle_higienizacao_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.controle_higienizacao_id_seq OWNER TO postgres;

--
-- Name: controle_higienizacao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.controle_higienizacao_id_seq OWNED BY public.controle_higienizacao.id;


--
-- Name: controle_oleo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.controle_oleo (
    id integer NOT NULL,
    volume_reposto_kg numeric,
    responsavel text DEFAULT 'Responsável'::text,
    created_at timestamp with time zone DEFAULT now(),
    horas_uso numeric,
    filtragem text,
    troca_total text,
    data date
);


ALTER TABLE public.controle_oleo OWNER TO postgres;

--
-- Name: controle_oleo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.controle_oleo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.controle_oleo_id_seq OWNER TO postgres;

--
-- Name: controle_oleo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.controle_oleo_id_seq OWNED BY public.controle_oleo.id;


--
-- Name: estoque_camara_fria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estoque_camara_fria (
    id bigint NOT NULL,
    data_registro date NOT NULL,
    produto_nome text NOT NULL,
    qtd_caixas numeric NOT NULL,
    tipo_movimento text NOT NULL,
    responsavel text,
    created_at timestamp with time zone DEFAULT now(),
    data_validade date,
    codigo_lote text
);


ALTER TABLE public.estoque_camara_fria OWNER TO postgres;

--
-- Name: estoque_camara_fria_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.estoque_camara_fria ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.estoque_camara_fria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: estoque_insumos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estoque_insumos (
    id integer NOT NULL,
    data_entrada date DEFAULT CURRENT_DATE,
    insumo text,
    fornecedor text,
    quantidade_kg numeric(10,2),
    custo_total numeric(10,2),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.estoque_insumos OWNER TO postgres;

--
-- Name: estoque_insumos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.estoque_insumos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.estoque_insumos_id_seq OWNER TO postgres;

--
-- Name: estoque_insumos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.estoque_insumos_id_seq OWNED BY public.estoque_insumos.id;


--
-- Name: financeiro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.financeiro (
    id integer NOT NULL,
    data date DEFAULT CURRENT_DATE,
    descricao text,
    valor numeric(10,2),
    tipo text,
    created_at timestamp with time zone DEFAULT now(),
    categoria text,
    forma_pagamento text,
    data_vencimento date,
    status_pagamento text DEFAULT 'Pago'::text
);


ALTER TABLE public.financeiro OWNER TO postgres;

--
-- Name: financeiro_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.financeiro_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.financeiro_id_seq OWNER TO postgres;

--
-- Name: financeiro_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.financeiro_id_seq OWNED BY public.financeiro.id;


--
-- Name: funcionarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.funcionarios (
    id integer NOT NULL,
    nome text NOT NULL,
    cargo text,
    salario_combinado numeric,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.funcionarios OWNER TO postgres;

--
-- Name: funcionarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.funcionarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.funcionarios_id_seq OWNER TO postgres;

--
-- Name: funcionarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.funcionarios_id_seq OWNED BY public.funcionarios.id;


--
-- Name: historico_rh; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.historico_rh (
    id integer NOT NULL,
    data_registro date DEFAULT CURRENT_DATE,
    funcionario_id integer,
    tipo_registro text,
    observacao text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.historico_rh OWNER TO postgres;

--
-- Name: historico_rh_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.historico_rh_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.historico_rh_id_seq OWNER TO postgres;

--
-- Name: historico_rh_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.historico_rh_id_seq OWNED BY public.historico_rh.id;


--
-- Name: produtos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produtos (
    id integer NOT NULL,
    embalagem text,
    un_por_caixa integer,
    peso_caixa_kg integer
);


ALTER TABLE public.produtos OWNER TO postgres;

--
-- Name: produtos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produtos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.produtos_id_seq OWNER TO postgres;

--
-- Name: produtos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produtos_id_seq OWNED BY public.produtos.id;


--
-- Name: rastreabilidade_producao; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rastreabilidade_producao (
    id integer NOT NULL,
    data_producao date DEFAULT CURRENT_DATE,
    codigo_lote text,
    fornecedor_batata text,
    qtd_produzida_kg numeric(10,2),
    turno text DEFAULT '01'::text,
    destino text DEFAULT 'R.J'::text,
    responsavel text DEFAULT 'Responsável'::text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.rastreabilidade_producao OWNER TO postgres;

--
-- Name: rastreabilidade_producao_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rastreabilidade_producao_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rastreabilidade_producao_id_seq OWNER TO postgres;

--
-- Name: rastreabilidade_producao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rastreabilidade_producao_id_seq OWNED BY public.rastreabilidade_producao.id;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    nome text NOT NULL,
    senha text NOT NULL,
    perfil text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- Name: vendas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendas (
    id integer NOT NULL,
    data_venda date DEFAULT CURRENT_DATE,
    cliente_id integer,
    produto_id integer,
    qtd_caixas integer,
    valor_caixa numeric(10,2),
    prazo_dias integer,
    status_pagamento text DEFAULT 'Pendente'::text,
    devolvido boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    forma_pagamento text,
    valor_pago numeric DEFAULT '0'::numeric
);


ALTER TABLE public.vendas OWNER TO postgres;

--
-- Name: vendas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vendas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vendas_id_seq OWNER TO postgres;

--
-- Name: vendas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vendas_id_seq OWNED BY public.vendas.id;


--
-- Name: clientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);


--
-- Name: controle_camara_fria id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.controle_camara_fria ALTER COLUMN id SET DEFAULT nextval('public.controle_camara_fria_id_seq'::regclass);


--
-- Name: controle_fritura id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.controle_fritura ALTER COLUMN id SET DEFAULT nextval('public.controle_fritura_id_seq'::regclass);


--
-- Name: controle_higienizacao id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.controle_higienizacao ALTER COLUMN id SET DEFAULT nextval('public.controle_higienizacao_id_seq'::regclass);


--
-- Name: controle_oleo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.controle_oleo ALTER COLUMN id SET DEFAULT nextval('public.controle_oleo_id_seq'::regclass);


--
-- Name: estoque_insumos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estoque_insumos ALTER COLUMN id SET DEFAULT nextval('public.estoque_insumos_id_seq'::regclass);


--
-- Name: financeiro id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.financeiro ALTER COLUMN id SET DEFAULT nextval('public.financeiro_id_seq'::regclass);


--
-- Name: funcionarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcionarios ALTER COLUMN id SET DEFAULT nextval('public.funcionarios_id_seq'::regclass);


--
-- Name: historico_rh id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historico_rh ALTER COLUMN id SET DEFAULT nextval('public.historico_rh_id_seq'::regclass);


--
-- Name: produtos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos ALTER COLUMN id SET DEFAULT nextval('public.produtos_id_seq'::regclass);


--
-- Name: rastreabilidade_producao id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rastreabilidade_producao ALTER COLUMN id SET DEFAULT nextval('public.rastreabilidade_producao_id_seq'::regclass);


--
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- Name: vendas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendas ALTER COLUMN id SET DEFAULT nextval('public.vendas_id_seq'::regclass);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- Name: controle_camara_fria controle_camara_fria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.controle_camara_fria
    ADD CONSTRAINT controle_camara_fria_pkey PRIMARY KEY (id);


--
-- Name: controle_fritura controle_fritura_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.controle_fritura
    ADD CONSTRAINT controle_fritura_pkey PRIMARY KEY (id);


--
-- Name: controle_higienizacao controle_higienizacao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.controle_higienizacao
    ADD CONSTRAINT controle_higienizacao_pkey PRIMARY KEY (id);


--
-- Name: controle_oleo controle_oleo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.controle_oleo
    ADD CONSTRAINT controle_oleo_pkey PRIMARY KEY (id);


--
-- Name: estoque_camara_fria estoque_camara_fria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estoque_camara_fria
    ADD CONSTRAINT estoque_camara_fria_pkey PRIMARY KEY (id);


--
-- Name: estoque_insumos estoque_insumos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estoque_insumos
    ADD CONSTRAINT estoque_insumos_pkey PRIMARY KEY (id);


--
-- Name: financeiro financeiro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.financeiro
    ADD CONSTRAINT financeiro_pkey PRIMARY KEY (id);


--
-- Name: funcionarios funcionarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (id);


--
-- Name: historico_rh historico_rh_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historico_rh
    ADD CONSTRAINT historico_rh_pkey PRIMARY KEY (id);


--
-- Name: produtos produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (id);


--
-- Name: rastreabilidade_producao rastreabilidade_producao_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rastreabilidade_producao
    ADD CONSTRAINT rastreabilidade_producao_pkey PRIMARY KEY (id);


--
-- Name: usuarios usuarios_nome_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_nome_key UNIQUE (nome);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: vendas vendas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_pkey PRIMARY KEY (id);


--
-- Name: idx_financeiro_saldo_inicial_unico; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_financeiro_saldo_inicial_unico ON public.financeiro USING btree (categoria) WHERE (categoria = 'Saldo Inicial'::text);


--
-- Name: historico_rh fk_historico_rh_funcionario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historico_rh
    ADD CONSTRAINT fk_historico_rh_funcionario FOREIGN KEY (funcionario_id) REFERENCES public.funcionarios(id) ON DELETE SET NULL;


--
-- Name: vendas fk_vendas_cliente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT fk_vendas_cliente FOREIGN KEY (cliente_id) REFERENCES public.clientes(id) ON DELETE RESTRICT;


--
-- Name: vendas fk_vendas_produto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT fk_vendas_produto FOREIGN KEY (produto_id) REFERENCES public.produtos(id) ON DELETE RESTRICT;


--
-- Name: historico_rh historico_rh_funcionario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historico_rh
    ADD CONSTRAINT historico_rh_funcionario_id_fkey FOREIGN KEY (funcionario_id) REFERENCES public.funcionarios(id);


--
-- Name: vendas vendas_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.clientes(id);


--
-- Name: vendas vendas_produto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendas
    ADD CONSTRAINT vendas_produto_id_fkey FOREIGN KEY (produto_id) REFERENCES public.produtos(id);


--
-- Name: controle_camara_fria Permitir tudo em camara_fria; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir tudo em camara_fria" ON public.controle_camara_fria USING (true) WITH CHECK (true);


--
-- Name: clientes Permitir tudo em clientes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir tudo em clientes" ON public.clientes USING (true) WITH CHECK (true);


--
-- Name: estoque_insumos Permitir tudo em estoque; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir tudo em estoque" ON public.estoque_insumos USING (true) WITH CHECK (true);


--
-- Name: financeiro Permitir tudo em financeiro; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir tudo em financeiro" ON public.financeiro USING (true) WITH CHECK (true);


--
-- Name: controle_fritura Permitir tudo em fritura; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir tudo em fritura" ON public.controle_fritura USING (true) WITH CHECK (true);


--
-- Name: funcionarios Permitir tudo em funcionarios; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir tudo em funcionarios" ON public.funcionarios USING (true) WITH CHECK (true);


--
-- Name: controle_higienizacao Permitir tudo em higienizacao; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir tudo em higienizacao" ON public.controle_higienizacao USING (true) WITH CHECK (true);


--
-- Name: historico_rh Permitir tudo em historico_rh; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir tudo em historico_rh" ON public.historico_rh USING (true) WITH CHECK (true);


--
-- Name: controle_oleo Permitir tudo em oleo; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir tudo em oleo" ON public.controle_oleo USING (true) WITH CHECK (true);


--
-- Name: produtos Permitir tudo em produtos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir tudo em produtos" ON public.produtos USING (true) WITH CHECK (true);


--
-- Name: rastreabilidade_producao Permitir tudo em rastreabilidade; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir tudo em rastreabilidade" ON public.rastreabilidade_producao USING (true) WITH CHECK (true);


--
-- Name: usuarios Permitir tudo em usuarios; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir tudo em usuarios" ON public.usuarios USING (true) WITH CHECK (true);


--
-- Name: vendas Permitir tudo em vendas; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir tudo em vendas" ON public.vendas USING (true) WITH CHECK (true);


--
-- Name: clientes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.clientes ENABLE ROW LEVEL SECURITY;

--
-- Name: controle_camara_fria; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.controle_camara_fria ENABLE ROW LEVEL SECURITY;

--
-- Name: controle_fritura; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.controle_fritura ENABLE ROW LEVEL SECURITY;

--
-- Name: controle_higienizacao; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.controle_higienizacao ENABLE ROW LEVEL SECURITY;

--
-- Name: controle_oleo; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.controle_oleo ENABLE ROW LEVEL SECURITY;

--
-- Name: estoque_camara_fria; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.estoque_camara_fria ENABLE ROW LEVEL SECURITY;

--
-- Name: estoque_insumos; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.estoque_insumos ENABLE ROW LEVEL SECURITY;

--
-- Name: financeiro; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.financeiro ENABLE ROW LEVEL SECURITY;

--
-- Name: funcionarios; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.funcionarios ENABLE ROW LEVEL SECURITY;

--
-- Name: historico_rh; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.historico_rh ENABLE ROW LEVEL SECURITY;

--
-- Name: produtos; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.produtos ENABLE ROW LEVEL SECURITY;

--
-- Name: rastreabilidade_producao; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.rastreabilidade_producao ENABLE ROW LEVEL SECURITY;

--
-- Name: estoque_camara_fria service_role_full_access_camara_fria; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY service_role_full_access_camara_fria ON public.estoque_camara_fria USING (true);


--
-- Name: estoque_insumos service_role_full_access_estoque_insumos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY service_role_full_access_estoque_insumos ON public.estoque_insumos USING (true);


--
-- Name: financeiro service_role_full_access_financeiro; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY service_role_full_access_financeiro ON public.financeiro USING (true);


--
-- Name: usuarios service_role_full_access_usuarios; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY service_role_full_access_usuarios ON public.usuarios USING (true);


--
-- Name: vendas service_role_full_access_vendas; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY service_role_full_access_vendas ON public.vendas USING (true);


--
-- Name: usuarios; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;

--
-- Name: vendas; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.vendas ENABLE ROW LEVEL SECURITY;

--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO erp_user;


--
-- Name: TABLE clientes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.clientes TO erp_user;


--
-- Name: SEQUENCE clientes_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.clientes_id_seq TO erp_user;


--
-- Name: TABLE controle_camara_fria; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.controle_camara_fria TO erp_user;


--
-- Name: SEQUENCE controle_camara_fria_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.controle_camara_fria_id_seq TO erp_user;


--
-- Name: TABLE controle_fritura; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.controle_fritura TO erp_user;


--
-- Name: SEQUENCE controle_fritura_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.controle_fritura_id_seq TO erp_user;


--
-- Name: TABLE controle_higienizacao; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.controle_higienizacao TO erp_user;


--
-- Name: SEQUENCE controle_higienizacao_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.controle_higienizacao_id_seq TO erp_user;


--
-- Name: TABLE controle_oleo; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.controle_oleo TO erp_user;


--
-- Name: SEQUENCE controle_oleo_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.controle_oleo_id_seq TO erp_user;


--
-- Name: TABLE estoque_camara_fria; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.estoque_camara_fria TO erp_user;


--
-- Name: SEQUENCE estoque_camara_fria_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.estoque_camara_fria_id_seq TO erp_user;


--
-- Name: TABLE estoque_insumos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.estoque_insumos TO erp_user;


--
-- Name: SEQUENCE estoque_insumos_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.estoque_insumos_id_seq TO erp_user;


--
-- Name: TABLE financeiro; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.financeiro TO erp_user;


--
-- Name: SEQUENCE financeiro_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.financeiro_id_seq TO erp_user;


--
-- Name: TABLE funcionarios; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.funcionarios TO erp_user;


--
-- Name: SEQUENCE funcionarios_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.funcionarios_id_seq TO erp_user;


--
-- Name: TABLE historico_rh; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.historico_rh TO erp_user;


--
-- Name: SEQUENCE historico_rh_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.historico_rh_id_seq TO erp_user;


--
-- Name: TABLE produtos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.produtos TO erp_user;


--
-- Name: SEQUENCE produtos_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.produtos_id_seq TO erp_user;


--
-- Name: TABLE rastreabilidade_producao; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.rastreabilidade_producao TO erp_user;


--
-- Name: SEQUENCE rastreabilidade_producao_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.rastreabilidade_producao_id_seq TO erp_user;


--
-- Name: TABLE usuarios; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.usuarios TO erp_user;


--
-- Name: SEQUENCE usuarios_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.usuarios_id_seq TO erp_user;


--
-- Name: TABLE vendas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.vendas TO erp_user;


--
-- Name: SEQUENCE vendas_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.vendas_id_seq TO erp_user;


--
-- PostgreSQL database dump complete
--


