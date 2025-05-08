--
-- PostgreSQL database dump
--
-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4
SET
  statement_timeout = 0;

SET
  lock_timeout = 0;

SET
  idle_in_transaction_session_timeout = 0;

SET
  transaction_timeout = 0;

SET
  client_encoding = 'UTF8';

SET
  standard_conforming_strings = on;

SELECT
  pg_catalog.set_config ('search_path', '', false);

SET
  check_function_bodies = false;

SET
  xmloption = content;

SET
  client_min_messages = warning;

SET
  row_security = off;

SET
  default_tablespace = '';

SET
  default_table_access_method = heap;

--
-- Name: availability; Type: TABLE; Schema: public; Owner: neondb_owner
--
CREATE TABLE public.availability (
  id integer NOT NULL,
  date date,
  hours numeric,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT NULL
);

ALTER TABLE public.availability OWNER TO neondb_owner;

--
-- Name: availability_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--
ALTER TABLE public.availability
ALTER COLUMN id
ADD GENERATED ALWAYS AS IDENTITY (
  SEQUENCE NAME public.availability_id_seq START
  WITH
    1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

--
-- Name: contracts; Type: TABLE; Schema: public; Owner: neondb_owner
--
CREATE TABLE public.contracts (
  id text DEFAULT gen_random_uuid () NOT NULL,
  name text,
  purpose text,
  status text DEFAULT 'initiated'::text NOT NULL,
  action text DEFAULT ''::text NOT NULL,
  external_template_id text NOT NULL,
  external_contract_id text,
  contract_params jsonb DEFAULT '{}'::jsonb,
  creation_state jsonb DEFAULT '{"active_step": 0}'::jsonb,
  sign_page_url text,
  user_id text NOT NULL,
  created_at timestamptz DEFAULT now() NOT NULL,
  updated_at timestamptz DEFAULT NULL,
);

ALTER TABLE public.contracts OWNER TO neondb_owner;

--
-- Name: organizations; Type: TABLE; Schema: public; Owner: neondb_owner
--
CREATE TABLE public.organizations (
  id integer NOT NULL,
  external_organization_id text NOT NULL,
  name text NOT NULL,
  status text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT NULL
);

ALTER TABLE public.organizations OWNER TO neondb_owner;

--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--
ALTER TABLE public.organizations
ALTER COLUMN id
ADD GENERATED ALWAYS AS IDENTITY (
  SEQUENCE NAME public.organizations_id_seq START
  WITH
    1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

--
-- Name: prices; Type: TABLE; Schema: public; Owner: neondb_owner
--
CREATE TABLE public.prices (
  id text DEFAULT gen_random_uuid () NOT NULL,
  price_name:text,
  external_price_id text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT NULL
);

ALTER TABLE public.prices OWNER TO neondb_owner;

--
-- Name: products; Type: TABLE; Schema: public; Owner: neondb_owner
--
CREATE TABLE public.products (
  id text DEFAULT gen_random_uuid () NOT NULL,
  product_name text NOT NULL,
  external_product_id text,
  payment_product_id text,
  price_id text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT NULL
);

ALTER TABLE public.products OWNER TO neondb_owner;

--
-- Name: users; Type: TABLE; Schema: public; Owner: neondb_owner
--
CREATE TABLE public.users (
  id integer NOT NULL,
  first_name text NOT NULL,
  last_name text NOT NULL,
  email_address text NOT NULL,
  username text,
  status text NOT NULL organization_id integer,
  external_user_id text NOT NULL,
  payment_user_id text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT NULL
);

ALTER TABLE public.users OWNER TO neondb_owner;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: neondb_owner
--
ALTER TABLE public.users
ALTER COLUMN id
ADD GENERATED ALWAYS AS IDENTITY (
  SEQUENCE NAME public.users_id_seq START
  WITH
    1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

--
-- Name: availability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--
SELECT
  pg_catalog.setval ('public.availability_id_seq', 1, false);

--
-- Name: organizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--
SELECT
  pg_catalog.setval ('public.organizations_id_seq', 4, true);

--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: neondb_owner
--
SELECT
  pg_catalog.setval ('public.users_id_seq', 16, true);

--
-- Name: availability availability_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--
ALTER TABLE ONLY public.availability
ADD CONSTRAINT availability_pkey PRIMARY KEY (id);

--
-- Name: products contract_templates_template_name_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--
ALTER TABLE ONLY public.products
ADD CONSTRAINT contract_templates_template_name_key UNIQUE (product_name);

--
-- Name: contracts contracts_external_contract_id_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--
ALTER TABLE ONLY public.contracts
ADD CONSTRAINT contracts_external_contract_id_key UNIQUE (external_contract_id);

--
-- Name: contracts contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--
ALTER TABLE ONLY public.contracts
ADD CONSTRAINT contracts_pkey PRIMARY KEY (id);

--
-- Name: organizations organizations_external_organization_id_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--
ALTER TABLE ONLY public.organizations
ADD CONSTRAINT organizations_external_organization_id_key UNIQUE (external_organization_id);

--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--
ALTER TABLE ONLY public.organizations
ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);

--
-- Name: prices prices_external_price_id_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--
ALTER TABLE ONLY public.prices
ADD CONSTRAINT prices_external_price_id_key UNIQUE (external_price_id);

--
-- Name: prices prices_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--
ALTER TABLE ONLY public.prices
ADD CONSTRAINT prices_pkey PRIMARY KEY (id);

--
-- Name: products products_external_product_id_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--
ALTER TABLE ONLY public.products
ADD CONSTRAINT products_external_product_id_key UNIQUE (external_product_id);

--
-- Name: products products_payment_product_id_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--
ALTER TABLE ONLY public.products
ADD CONSTRAINT products_payment_product_id_key UNIQUE (payment_product_id);

--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--
ALTER TABLE ONLY public.products
ADD CONSTRAINT products_pkey PRIMARY KEY (id);

--
-- Name: users users_email_address_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--
ALTER TABLE ONLY public.users
ADD CONSTRAINT users_email_address_key UNIQUE (email_address);

--
-- Name: users users_external_user_id_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--
ALTER TABLE ONLY public.users
ADD CONSTRAINT users_external_user_id_key UNIQUE (external_user_id);

--
-- Name: users users_payment_user_id_key; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--
ALTER TABLE ONLY public.users
ADD CONSTRAINT users_payment_user_id_key UNIQUE (payment_user_id);

--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: neondb_owner
--
ALTER TABLE ONLY public.users
ADD CONSTRAINT users_pkey PRIMARY KEY (id);

--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public
GRANT ALL ON SEQUENCES TO neon_superuser
WITH
GRANT OPTION;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--
ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public
GRANT ALL ON TABLES TO neon_superuser
WITH
GRANT OPTION;

--
-- PostgreSQL database dump complete
--
CREATE OR REPLACE FUNCTION update_timestamp () RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$
CREATE TRIGGER update_timestamp_trigger_availability BEFORE
UPDATE ON public.availability FOR EACH ROW
EXECUTE FUNCTION update_timestamp ();

CREATE TRIGGER update_timestamp_trigger_contracts BEFORE
UPDATE ON public.contracts FOR EACH ROW
EXECUTE FUNCTION update_timestamp ();

CREATE TRIGGER update_timestamp_trigger_organizations BEFORE
UPDATE ON public.organizations FOR EACH ROW
EXECUTE FUNCTION update_timestamp ();

CREATE TRIGGER update_timestamp_trigger_prices BEFORE
UPDATE ON public.prices FOR EACH ROW
EXECUTE FUNCTION update_timestamp ();

CREATE TRIGGER update_timestamp_trigger_products BEFORE
UPDATE ON public.products FOR EACH ROW
EXECUTE FUNCTION update_timestamp ();

CREATE TRIGGER update_timestamp_trigger_users BEFORE
UPDATE ON public.users FOR EACH ROW
EXECUTE FUNCTION update_timestamp ();
