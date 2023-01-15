--
-- PostgreSQL database dump
--

-- Dumped from database version 15.0
-- Dumped by pg_dump version 15.0

-- Started on 2022-12-16 19:30:02

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
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 4007 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 16399)
-- Name: branch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.branch (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    address character varying NOT NULL,
    city character varying NOT NULL,
    abbr character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    active smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.branch OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16406)
-- Name: branch_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.branch_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.branch_id_seq OWNER TO postgres;

--
-- TOC entry 4008 (class 0 OID 0)
-- Dependencies: 215
-- Name: branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.branch_id_seq OWNED BY public.branch.id;


--
-- TOC entry 216 (class 1259 OID 16407)
-- Name: branch_room; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.branch_room (
    id integer NOT NULL,
    branch_id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.branch_room OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16413)
-- Name: branch_room_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.branch_room_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.branch_room_id_seq OWNER TO postgres;

--
-- TOC entry 4009 (class 0 OID 0)
-- Dependencies: 217
-- Name: branch_room_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.branch_room_id_seq OWNED BY public.branch_room.id;


--
-- TOC entry 218 (class 1259 OID 16414)
-- Name: company; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    address character varying NOT NULL,
    city character varying,
    email character varying,
    phone_no character varying,
    icon_file character varying,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.company OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16420)
-- Name: company_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.company_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.company_id_seq OWNER TO postgres;

--
-- TOC entry 4010 (class 0 OID 0)
-- Dependencies: 219
-- Name: company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.company_id_seq OWNED BY public.company.id;


--
-- TOC entry 220 (class 1259 OID 16421)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    id bigint NOT NULL,
    name character varying NOT NULL,
    address character varying NOT NULL,
    phone_no character varying,
    membership_id integer DEFAULT 1 NOT NULL,
    abbr character varying,
    branch_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16428)
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_id_seq OWNER TO postgres;

--
-- TOC entry 4011 (class 0 OID 0)
-- Dependencies: 221
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- TOC entry 222 (class 1259 OID 16429)
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    active smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16436)
-- Name: department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.department_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.department_id_seq OWNER TO postgres;

--
-- TOC entry 4012 (class 0 OID 0)
-- Dependencies: 223
-- Name: department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.department_id_seq OWNED BY public.departments.id;


--
-- TOC entry 224 (class 1259 OID 16437)
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.failed_jobs OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16443)
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.failed_jobs_id_seq OWNER TO postgres;

--
-- TOC entry 4013 (class 0 OID 0)
-- Dependencies: 225
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- TOC entry 226 (class 1259 OID 16444)
-- Name: invoice_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice_detail (
    invoice_no character varying NOT NULL,
    product_id integer NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    price numeric(18,0) DEFAULT 0 NOT NULL,
    total numeric(18,0) DEFAULT 0 NOT NULL,
    discount numeric(18,0) DEFAULT 0 NOT NULL,
    seq smallint DEFAULT 0 NOT NULL,
    assigned_to integer,
    referral_by integer,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    uom character varying,
    product_name character varying,
    vat integer,
    vat_total numeric(18,0),
    assigned_to_name character varying,
    referral_by_name character varying,
    price_purchase numeric(18,0) DEFAULT 0
);


ALTER TABLE public.invoice_detail OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16455)
-- Name: invoice_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice_master (
    id bigint NOT NULL,
    invoice_no character varying NOT NULL,
    dated date DEFAULT (now())::date NOT NULL,
    customers_id integer NOT NULL,
    total numeric(18,0) DEFAULT 0 NOT NULL,
    tax numeric(18,0) DEFAULT 0 NOT NULL,
    total_payment numeric(18,0) DEFAULT 0 NOT NULL,
    total_discount numeric(18,0) DEFAULT 0 NOT NULL,
    remark character varying,
    payment_type character varying NOT NULL,
    payment_nominal numeric(18,0) DEFAULT 0 NOT NULL,
    voucher_code character varying,
    scheduled_at timestamp without time zone DEFAULT now() NOT NULL,
    branch_room_id integer NOT NULL,
    ref_no character varying,
    updated_by integer,
    printed_at timestamp without time zone,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    is_checkout smallint DEFAULT 0 NOT NULL,
    is_canceled smallint DEFAULT 0 NOT NULL,
    customers_name character varying,
    printed_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.invoice_master OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16471)
-- Name: invoice_master_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.invoice_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.invoice_master_id_seq OWNER TO postgres;

--
-- TOC entry 4014 (class 0 OID 0)
-- Dependencies: 228
-- Name: invoice_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.invoice_master_id_seq OWNED BY public.invoice_master.id;


--
-- TOC entry 229 (class 1259 OID 16472)
-- Name: job_title; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_title (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    active smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.job_title OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16479)
-- Name: job_title_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.job_title_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.job_title_id_seq OWNER TO postgres;

--
-- TOC entry 4015 (class 0 OID 0)
-- Dependencies: 230
-- Name: job_title_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.job_title_id_seq OWNED BY public.job_title.id;


--
-- TOC entry 231 (class 1259 OID 16480)
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16483)
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.migrations_id_seq OWNER TO postgres;

--
-- TOC entry 4016 (class 0 OID 0)
-- Dependencies: 232
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- TOC entry 233 (class 1259 OID 16484)
-- Name: model_has_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.model_has_permissions (
    permission_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);


ALTER TABLE public.model_has_permissions OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16487)
-- Name: model_has_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.model_has_roles (
    role_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);


ALTER TABLE public.model_has_roles OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16490)
-- Name: order_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_detail (
    order_no character varying NOT NULL,
    product_id integer NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    price numeric(18,0) DEFAULT 0 NOT NULL,
    total numeric(18,0) DEFAULT 0 NOT NULL,
    discount numeric(18,0) DEFAULT 0 NOT NULL,
    seq smallint DEFAULT 0 NOT NULL,
    assigned_to integer,
    referral_by integer,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    uom character varying,
    product_name character varying,
    assigned_to_name character varying,
    referral_by_name character varying,
    vat integer,
    vat_total numeric(18,0)
);


ALTER TABLE public.order_detail OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16501)
-- Name: order_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_master (
    id bigint NOT NULL,
    order_no character varying NOT NULL,
    dated date DEFAULT (now())::date NOT NULL,
    customers_id integer NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    total numeric(18,0) DEFAULT 0 NOT NULL,
    tax numeric(18,0) DEFAULT 0 NOT NULL,
    total_payment numeric(18,0) DEFAULT 0,
    total_discount numeric(18,0) DEFAULT 0 NOT NULL,
    remark character varying,
    payment_type character varying NOT NULL,
    payment_nominal numeric(18,0) DEFAULT 0 NOT NULL,
    voucher_code character varying,
    printed_at timestamp without time zone,
    updated_at timestamp without time zone,
    updated_by integer,
    scheduled_at timestamp without time zone DEFAULT now() NOT NULL,
    branch_room_id integer NOT NULL,
    is_checkout smallint DEFAULT 0 NOT NULL,
    is_canceled smallint DEFAULT 0 NOT NULL,
    customers_name character varying,
    printed_count integer DEFAULT 0 NOT NULL,
    queue_no character varying
);


ALTER TABLE public.order_master OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16517)
-- Name: order_master_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_master_id_seq OWNER TO postgres;

--
-- TOC entry 4017 (class 0 OID 0)
-- Dependencies: 237
-- Name: order_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_master_id_seq OWNED BY public.order_master.id;


--
-- TOC entry 238 (class 1259 OID 16518)
-- Name: password_resets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_resets (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_resets OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16523)
-- Name: period; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.period (
    period_no integer NOT NULL,
    remark character varying NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL
);


ALTER TABLE public.period OWNER TO postgres;

--
-- TOC entry 299 (class 1259 OID 17074)
-- Name: period_price_sell; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.period_price_sell (
    id bigint NOT NULL,
    period integer NOT NULL,
    product_id integer NOT NULL,
    value numeric(18,2),
    updated_at timestamp without time zone,
    updated_by integer,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    branch_id integer NOT NULL
);


ALTER TABLE public.period_price_sell OWNER TO postgres;

--
-- TOC entry 298 (class 1259 OID 17073)
-- Name: period_price_sell_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.period_price_sell_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.period_price_sell_id_seq OWNER TO postgres;

--
-- TOC entry 4018 (class 0 OID 0)
-- Dependencies: 298
-- Name: period_price_sell_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.period_price_sell_id_seq OWNED BY public.period_price_sell.id;


--
-- TOC entry 240 (class 1259 OID 16528)
-- Name: period_stock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.period_stock (
    periode integer NOT NULL,
    branch_id integer NOT NULL,
    product_id integer DEFAULT 0 NOT NULL,
    balance_begin integer DEFAULT 0 NOT NULL,
    balance_end integer DEFAULT 0 NOT NULL,
    qty_in integer DEFAULT 0 NOT NULL,
    qty_out integer DEFAULT 0 NOT NULL,
    updated_at timestamp without time zone,
    created_by integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.period_stock OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16538)
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    url character varying,
    remark character varying,
    parent character varying
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16543)
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_id_seq OWNER TO postgres;

--
-- TOC entry 4019 (class 0 OID 0)
-- Dependencies: 242
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- TOC entry 243 (class 1259 OID 16544)
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.personal_access_tokens OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 16549)
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personal_access_tokens_id_seq OWNER TO postgres;

--
-- TOC entry 4020 (class 0 OID 0)
-- Dependencies: 244
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- TOC entry 245 (class 1259 OID 16550)
-- Name: point_conversion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.point_conversion (
    point_qty integer DEFAULT 0 NOT NULL,
    point_value integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.point_conversion OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 16555)
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    title character varying(70) NOT NULL,
    description character varying(320) NOT NULL,
    body text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.posts OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 16560)
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.posts_id_seq OWNER TO postgres;

--
-- TOC entry 4021 (class 0 OID 0)
-- Dependencies: 247
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- TOC entry 248 (class 1259 OID 16561)
-- Name: price_adjustment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_adjustment (
    id bigint NOT NULL,
    branch_id integer NOT NULL,
    product_id integer NOT NULL,
    dated_start date NOT NULL,
    dated_end date NOT NULL,
    value integer DEFAULT 0 NOT NULL,
    created_by integer,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.price_adjustment OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 16566)
-- Name: price_adjustment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.price_adjustment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.price_adjustment_id_seq OWNER TO postgres;

--
-- TOC entry 4022 (class 0 OID 0)
-- Dependencies: 249
-- Name: price_adjustment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.price_adjustment_id_seq OWNED BY public.price_adjustment.id;


--
-- TOC entry 250 (class 1259 OID 16567)
-- Name: product_brand; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_brand (
    id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.product_brand OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 16573)
-- Name: product_brand_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_brand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_brand_id_seq OWNER TO postgres;

--
-- TOC entry 4023 (class 0 OID 0)
-- Dependencies: 251
-- Name: product_brand_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_brand_id_seq OWNED BY public.product_brand.id;


--
-- TOC entry 252 (class 1259 OID 16574)
-- Name: product_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_category (
    id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.product_category OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 16580)
-- Name: product_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_category_id_seq OWNER TO postgres;

--
-- TOC entry 4024 (class 0 OID 0)
-- Dependencies: 253
-- Name: product_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;


--
-- TOC entry 254 (class 1259 OID 16581)
-- Name: product_commision_by_year; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_commision_by_year (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    jobs_id integer NOT NULL,
    years integer DEFAULT 1 NOT NULL,
    "values" integer NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.product_commision_by_year OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 16585)
-- Name: product_commisions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_commisions (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    created_by_fee integer,
    assigned_to_fee integer,
    referral_fee integer,
    created_at timestamp without time zone NOT NULL,
    created_by integer NOT NULL,
    remark character varying,
    updated_at timestamp without time zone
);


ALTER TABLE public.product_commisions OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 16590)
-- Name: product_distribution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_distribution (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    active smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.product_distribution OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 16595)
-- Name: product_ingredients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_ingredients (
    product_id integer NOT NULL,
    product_id_material integer NOT NULL,
    uom_id integer NOT NULL,
    qty integer DEFAULT 1 NOT NULL,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.product_ingredients OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 16600)
-- Name: product_point; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_point (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    point integer DEFAULT 0 NOT NULL,
    created_by integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.product_point OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 16604)
-- Name: product_price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_price (
    product_id integer NOT NULL,
    price numeric(18,0) DEFAULT 0 NOT NULL,
    branch_id integer NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.product_price OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 16608)
-- Name: product_sku; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_sku (
    id bigint NOT NULL,
    remark character varying NOT NULL,
    abbr character varying NOT NULL,
    alias_code character varying,
    barcode character varying,
    category_id integer NOT NULL,
    type_id integer NOT NULL,
    brand_id integer NOT NULL,
    updated_at timestamp without time zone,
    updated_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    vat numeric(10,0) DEFAULT 0.0 NOT NULL,
    active smallint DEFAULT 1 NOT NULL,
    photo character varying
);


ALTER TABLE public.product_sku OWNER TO postgres;

--
-- TOC entry 4025 (class 0 OID 0)
-- Dependencies: 260
-- Name: COLUMN product_sku.type_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_sku.type_id IS '''Product/Service''';


--
-- TOC entry 261 (class 1259 OID 16616)
-- Name: product_sku_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_sku_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_sku_id_seq OWNER TO postgres;

--
-- TOC entry 4026 (class 0 OID 0)
-- Dependencies: 261
-- Name: product_sku_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_sku_id_seq OWNED BY public.product_sku.id;


--
-- TOC entry 262 (class 1259 OID 16617)
-- Name: product_stock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_stock (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer
);


ALTER TABLE public.product_stock OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 16622)
-- Name: product_stock_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_stock_detail (
    id bigint NOT NULL,
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    expired_at date DEFAULT (now() + '2 years'::interval) NOT NULL,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer
);


ALTER TABLE public.product_stock_detail OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 16628)
-- Name: product_stock_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_stock_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_stock_detail_id_seq OWNER TO postgres;

--
-- TOC entry 4027 (class 0 OID 0)
-- Dependencies: 264
-- Name: product_stock_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_stock_detail_id_seq OWNED BY public.product_stock_detail.id;


--
-- TOC entry 265 (class 1259 OID 16629)
-- Name: product_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_type (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.product_type OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 16635)
-- Name: product_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_type_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_type_id_seq OWNER TO postgres;

--
-- TOC entry 4028 (class 0 OID 0)
-- Dependencies: 266
-- Name: product_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_type_id_seq OWNED BY public.product_type.id;


--
-- TOC entry 267 (class 1259 OID 16636)
-- Name: product_uom; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_uom (
    product_id integer NOT NULL,
    uom_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    create_by integer,
    updated_at timestamp without time zone
);


ALTER TABLE public.product_uom OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 16640)
-- Name: uom; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uom (
    id integer NOT NULL,
    remark character varying NOT NULL,
    conversion integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.uom OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 16647)
-- Name: product_uom_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_uom_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_uom_id_seq OWNER TO postgres;

--
-- TOC entry 4029 (class 0 OID 0)
-- Dependencies: 269
-- Name: product_uom_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_uom_id_seq OWNED BY public.uom.id;


--
-- TOC entry 270 (class 1259 OID 16648)
-- Name: purchase_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_detail (
    purchase_no character varying NOT NULL,
    product_id integer NOT NULL,
    product_remark character varying,
    uom character varying,
    seq smallint DEFAULT 0 NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    price numeric(18,0) DEFAULT 0 NOT NULL,
    discount numeric(18,0) DEFAULT 0 NOT NULL,
    vat numeric(10,2) DEFAULT 0 NOT NULL,
    vat_total numeric(18,2) DEFAULT 0 NOT NULL,
    subtotal numeric(18,0) DEFAULT 0 NOT NULL,
    subtotal_vat numeric(18,2) DEFAULT 0,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.purchase_detail OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 16662)
-- Name: purchase_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchase_master (
    id bigint NOT NULL,
    purchase_no character varying NOT NULL,
    dated date DEFAULT (now())::date NOT NULL,
    supplier_id integer NOT NULL,
    supplier_name character varying,
    branch_id integer NOT NULL,
    branch_name character varying,
    total numeric(18,0) DEFAULT 0 NOT NULL,
    total_vat numeric(18,0) DEFAULT 0 NOT NULL,
    total_payment numeric(18,0) DEFAULT 0 NOT NULL,
    total_discount numeric(18,0) DEFAULT 0 NOT NULL,
    remark character varying,
    payment_type character varying,
    payment_nominal numeric(18,0) DEFAULT 0 NOT NULL,
    scheduled_at timestamp without time zone DEFAULT now() NOT NULL,
    ref_no character varying,
    printed_at timestamp without time zone,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    is_receive smallint DEFAULT 0 NOT NULL,
    is_canceled smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.purchase_master OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 16677)
-- Name: purchase_master_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchase_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchase_master_id_seq OWNER TO postgres;

--
-- TOC entry 4030 (class 0 OID 0)
-- Dependencies: 272
-- Name: purchase_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_master_id_seq OWNED BY public.purchase_master.id;


--
-- TOC entry 273 (class 1259 OID 16678)
-- Name: receive_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receive_detail (
    receive_no character varying NOT NULL,
    product_id integer NOT NULL,
    product_remark character varying,
    qty integer DEFAULT 0 NOT NULL,
    price numeric(18,0) DEFAULT 0 NOT NULL,
    total numeric(18,0) DEFAULT 0 NOT NULL,
    discount numeric(18,0) DEFAULT 0 NOT NULL,
    seq smallint DEFAULT 0 NOT NULL,
    expired_at date DEFAULT (now() + '1 year'::interval) NOT NULL,
    batch_no character varying,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    uom character varying,
    vat smallint DEFAULT 11 NOT NULL
);


ALTER TABLE public.receive_detail OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 16691)
-- Name: receive_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receive_master (
    id bigint NOT NULL,
    receive_no character varying NOT NULL,
    dated date DEFAULT (now())::date NOT NULL,
    supplier_id integer NOT NULL,
    supplier_name character varying,
    total numeric(18,0) DEFAULT 0 NOT NULL,
    total_vat numeric(18,0) DEFAULT 0 NOT NULL,
    total_payment numeric(18,0) DEFAULT 0 NOT NULL,
    total_discount numeric(18,0) DEFAULT 0 NOT NULL,
    remark character varying,
    payment_type character varying,
    payment_nominal numeric(18,0) DEFAULT 0 NOT NULL,
    scheduled_at timestamp without time zone DEFAULT now() NOT NULL,
    branch_id integer NOT NULL,
    branch_name character varying,
    ref_no character varying,
    updated_by integer,
    printed_at timestamp without time zone,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    is_receive smallint DEFAULT 0 NOT NULL,
    is_canceled smallint DEFAULT 0 NOT NULL
);


ALTER TABLE public.receive_master OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 16706)
-- Name: receive_master_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.receive_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.receive_master_id_seq OWNER TO postgres;

--
-- TOC entry 4031 (class 0 OID 0)
-- Dependencies: 275
-- Name: receive_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;


--
-- TOC entry 302 (class 1259 OID 17111)
-- Name: return_sell_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_sell_detail (
    return_sell_no character varying NOT NULL,
    product_id integer NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    price numeric(18,0) DEFAULT 0 NOT NULL,
    total numeric(18,0) DEFAULT 0 NOT NULL,
    discount numeric(18,0) DEFAULT 0 NOT NULL,
    seq smallint DEFAULT 0 NOT NULL,
    assigned_to integer,
    referral_by integer,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    uom character varying,
    product_name character varying,
    vat integer,
    vat_total numeric(18,0),
    assigned_to_name character varying,
    referral_by_name character varying
);


ALTER TABLE public.return_sell_detail OWNER TO postgres;

--
-- TOC entry 301 (class 1259 OID 17080)
-- Name: return_sell_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_sell_master (
    id bigint NOT NULL,
    return_sell_no character varying NOT NULL,
    dated date DEFAULT (now())::date NOT NULL,
    customers_id integer NOT NULL,
    total numeric(18,0) DEFAULT 0 NOT NULL,
    tax numeric(18,0) DEFAULT 0 NOT NULL,
    total_payment numeric(18,0) DEFAULT 0 NOT NULL,
    total_discount numeric(18,0) DEFAULT 0 NOT NULL,
    remark character varying,
    payment_type character varying NOT NULL,
    payment_nominal numeric(18,0) DEFAULT 0 NOT NULL,
    voucher_code character varying,
    scheduled_at timestamp without time zone DEFAULT now() NOT NULL,
    branch_room_id integer NOT NULL,
    ref_no character varying,
    updated_by integer,
    printed_at timestamp without time zone,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    is_checkout smallint DEFAULT 0 NOT NULL,
    is_canceled smallint DEFAULT 0 NOT NULL,
    customers_name character varying,
    printed_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.return_sell_master OWNER TO postgres;

--
-- TOC entry 300 (class 1259 OID 17079)
-- Name: return_sell_master_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.return_sell_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.return_sell_master_id_seq OWNER TO postgres;

--
-- TOC entry 4032 (class 0 OID 0)
-- Dependencies: 300
-- Name: return_sell_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;


--
-- TOC entry 276 (class 1259 OID 16707)
-- Name: role_has_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_has_permissions (
    permission_id bigint NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE public.role_has_permissions OWNER TO postgres;

--
-- TOC entry 277 (class 1259 OID 16710)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 278 (class 1259 OID 16715)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO postgres;

--
-- TOC entry 4033 (class 0 OID 0)
-- Dependencies: 278
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 297 (class 1259 OID 17057)
-- Name: setting_document_counter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.setting_document_counter (
    id bigint NOT NULL,
    doc_type character varying NOT NULL,
    abbr character varying NOT NULL,
    period character varying NOT NULL,
    current_value integer DEFAULT 0 NOT NULL,
    updated_at timestamp without time zone,
    updated_by integer,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    branch_id integer
);


ALTER TABLE public.setting_document_counter OWNER TO postgres;

--
-- TOC entry 4034 (class 0 OID 0)
-- Dependencies: 297
-- Name: COLUMN setting_document_counter.period; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';


--
-- TOC entry 296 (class 1259 OID 17056)
-- Name: setting_document_counter_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.setting_document_counter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.setting_document_counter_id_seq OWNER TO postgres;

--
-- TOC entry 4035 (class 0 OID 0)
-- Dependencies: 296
-- Name: setting_document_counter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;


--
-- TOC entry 279 (class 1259 OID 16716)
-- Name: settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.settings (
    transaction_date date DEFAULT now() NOT NULL,
    period_no integer NOT NULL,
    company_name character varying NOT NULL,
    app_name character varying NOT NULL,
    version character varying,
    icon_file character varying
);


ALTER TABLE public.settings OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 16722)
-- Name: shift; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shift (
    id integer NOT NULL,
    remark character varying,
    time_start time without time zone DEFAULT '08:00:00'::time without time zone NOT NULL,
    time_end time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    created_by integer,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.shift OWNER TO postgres;

--
-- TOC entry 303 (class 1259 OID 17129)
-- Name: shift_counter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shift_counter (
    users_id integer NOT NULL,
    queue_no smallint NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    branch_id integer NOT NULL
);


ALTER TABLE public.shift_counter OWNER TO postgres;

--
-- TOC entry 281 (class 1259 OID 16730)
-- Name: shift_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shift_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shift_id_seq OWNER TO postgres;

--
-- TOC entry 4036 (class 0 OID 0)
-- Dependencies: 281
-- Name: shift_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;


--
-- TOC entry 282 (class 1259 OID 16731)
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    id bigint NOT NULL,
    name character varying,
    address character varying,
    branch_id integer NOT NULL,
    email character varying,
    handphone character varying,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- TOC entry 283 (class 1259 OID 16737)
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.suppliers_id_seq OWNER TO postgres;

--
-- TOC entry 4037 (class 0 OID 0)
-- Dependencies: 283
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;


--
-- TOC entry 284 (class 1259 OID 16738)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255),
    email character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    phone_no character varying(50),
    address character varying,
    join_date date,
    join_years smallint DEFAULT 0 NOT NULL,
    gender character varying,
    netizen_id character varying,
    city character varying,
    employee_id character varying,
    photo character varying,
    photo_netizen_id character varying,
    job_id integer,
    branch_id integer,
    department_id integer,
    referral_id integer,
    birth_place character varying,
    birth_date date,
    employee_status character varying,
    active smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 285 (class 1259 OID 16745)
-- Name: users_branch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_branch (
    user_id integer NOT NULL,
    branch_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.users_branch OWNER TO postgres;

--
-- TOC entry 286 (class 1259 OID 16749)
-- Name: users_experience; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_experience (
    id bigint NOT NULL,
    users_id integer NOT NULL,
    company character varying,
    job_position character varying,
    years character varying,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users_experience OWNER TO postgres;

--
-- TOC entry 287 (class 1259 OID 16755)
-- Name: users_experience_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_experience_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_experience_id_seq OWNER TO postgres;

--
-- TOC entry 4038 (class 0 OID 0)
-- Dependencies: 287
-- Name: users_experience_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;


--
-- TOC entry 288 (class 1259 OID 16756)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 4039 (class 0 OID 0)
-- Dependencies: 288
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 289 (class 1259 OID 16757)
-- Name: users_mutation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_mutation (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    branch_id integer NOT NULL,
    department_id integer NOT NULL,
    job_id integer NOT NULL,
    remark character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.users_mutation OWNER TO postgres;

--
-- TOC entry 290 (class 1259 OID 16763)
-- Name: users_mutation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_mutation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_mutation_id_seq OWNER TO postgres;

--
-- TOC entry 4040 (class 0 OID 0)
-- Dependencies: 290
-- Name: users_mutation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;


--
-- TOC entry 291 (class 1259 OID 16764)
-- Name: users_shift; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_shift (
    branch_id integer NOT NULL,
    users_id integer NOT NULL,
    dated date NOT NULL,
    shift_id integer NOT NULL,
    shift_remark character varying,
    shift_time_start time without time zone,
    shift_time_end time without time zone,
    remark character varying,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    id bigint NOT NULL
);


ALTER TABLE public.users_shift OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 16770)
-- Name: users_shift_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_shift_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_shift_id_seq OWNER TO postgres;

--
-- TOC entry 4041 (class 0 OID 0)
-- Dependencies: 292
-- Name: users_shift_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;


--
-- TOC entry 293 (class 1259 OID 16771)
-- Name: users_skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_skills (
    users_id integer NOT NULL,
    modul integer NOT NULL,
    trainer integer NOT NULL,
    status character varying NOT NULL,
    dated date DEFAULT (now())::date NOT NULL,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users_skills OWNER TO postgres;

--
-- TOC entry 294 (class 1259 OID 16778)
-- Name: voucher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.voucher (
    id bigint NOT NULL,
    voucher_code character varying NOT NULL,
    branch_id integer NOT NULL,
    dated_start date NOT NULL,
    dated_end date,
    is_used smallint DEFAULT 0 NOT NULL,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    product_id integer,
    value smallint DEFAULT 0 NOT NULL,
    remark character varying NOT NULL
);


ALTER TABLE public.voucher OWNER TO postgres;

--
-- TOC entry 295 (class 1259 OID 16786)
-- Name: voucher_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.voucher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.voucher_id_seq OWNER TO postgres;

--
-- TOC entry 4042 (class 0 OID 0)
-- Dependencies: 295
-- Name: voucher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;


--
-- TOC entry 3429 (class 2604 OID 16787)
-- Name: branch id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);


--
-- TOC entry 3432 (class 2604 OID 16788)
-- Name: branch_room id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);


--
-- TOC entry 3434 (class 2604 OID 16789)
-- Name: company id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);


--
-- TOC entry 3436 (class 2604 OID 16790)
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- TOC entry 3439 (class 2604 OID 16791)
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);


--
-- TOC entry 3442 (class 2604 OID 16792)
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- TOC entry 3451 (class 2604 OID 16793)
-- Name: invoice_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);


--
-- TOC entry 3463 (class 2604 OID 16794)
-- Name: job_title id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);


--
-- TOC entry 3466 (class 2604 OID 16795)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 3473 (class 2604 OID 16796)
-- Name: order_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master ALTER COLUMN id SET DEFAULT nextval('public.order_master_id_seq'::regclass);


--
-- TOC entry 3593 (class 2604 OID 17077)
-- Name: period_price_sell id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.period_price_sell ALTER COLUMN id SET DEFAULT nextval('public.period_price_sell_id_seq'::regclass);


--
-- TOC entry 3492 (class 2604 OID 16797)
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- TOC entry 3493 (class 2604 OID 16798)
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- TOC entry 3496 (class 2604 OID 16799)
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- TOC entry 3497 (class 2604 OID 16800)
-- Name: price_adjustment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_adjustment ALTER COLUMN id SET DEFAULT nextval('public.price_adjustment_id_seq'::regclass);


--
-- TOC entry 3500 (class 2604 OID 16801)
-- Name: product_brand id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_brand ALTER COLUMN id SET DEFAULT nextval('public.product_brand_id_seq'::regclass);


--
-- TOC entry 3502 (class 2604 OID 16802)
-- Name: product_category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);


--
-- TOC entry 3511 (class 2604 OID 16803)
-- Name: product_sku id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku ALTER COLUMN id SET DEFAULT nextval('public.product_sku_id_seq'::regclass);


--
-- TOC entry 3517 (class 2604 OID 16804)
-- Name: product_stock_detail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock_detail ALTER COLUMN id SET DEFAULT nextval('public.product_stock_detail_id_seq'::regclass);


--
-- TOC entry 3521 (class 2604 OID 16805)
-- Name: product_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_type ALTER COLUMN id SET DEFAULT nextval('public.product_type_id_seq'::regclass);


--
-- TOC entry 3536 (class 2604 OID 16806)
-- Name: purchase_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master ALTER COLUMN id SET DEFAULT nextval('public.purchase_master_id_seq'::regclass);


--
-- TOC entry 3555 (class 2604 OID 16807)
-- Name: receive_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);


--
-- TOC entry 3595 (class 2604 OID 17083)
-- Name: return_sell_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_master ALTER COLUMN id SET DEFAULT nextval('public.return_sell_master_id_seq'::regclass);


--
-- TOC entry 3566 (class 2604 OID 16808)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 3590 (class 2604 OID 17060)
-- Name: setting_document_counter id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.setting_document_counter ALTER COLUMN id SET DEFAULT nextval('public.setting_document_counter_id_seq'::regclass);


--
-- TOC entry 3568 (class 2604 OID 16809)
-- Name: shift id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);


--
-- TOC entry 3572 (class 2604 OID 16810)
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- TOC entry 3524 (class 2604 OID 16811)
-- Name: uom id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);


--
-- TOC entry 3574 (class 2604 OID 16812)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3578 (class 2604 OID 16813)
-- Name: users_experience id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_experience ALTER COLUMN id SET DEFAULT nextval('public.users_experience_id_seq'::regclass);


--
-- TOC entry 3580 (class 2604 OID 16814)
-- Name: users_mutation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_mutation ALTER COLUMN id SET DEFAULT nextval('public.users_mutation_id_seq'::regclass);


--
-- TOC entry 3583 (class 2604 OID 16815)
-- Name: users_shift id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_shift ALTER COLUMN id SET DEFAULT nextval('public.users_shift_id_seq'::regclass);


--
-- TOC entry 3586 (class 2604 OID 16816)
-- Name: voucher id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voucher ALTER COLUMN id SET DEFAULT nextval('public.voucher_id_seq'::regclass);


--
-- TOC entry 3912 (class 0 OID 16399)
-- Dependencies: 214
-- Data for Name: branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.branch VALUES (1, 'HEAD QUARTER', 'Jalan Jakarta no 3', 'Jakarta', 'HQ00', '2022-06-01 19:46:05.452925', NULL, 1);
INSERT INTO public.branch VALUES (2, 'OUTLET 01', 'Jalan Lampung No 23', 'Jakarta', 'OL01', '2022-06-01 19:46:05.452925', NULL, 1);
INSERT INTO public.branch VALUES (3, 'OUTLET 02', 'Jalan Sumatera No 88', 'Sumatera', 'OL02', '2022-06-01 19:46:05.452925', NULL, 1);


--
-- TOC entry 3914 (class 0 OID 16407)
-- Dependencies: 216
-- Data for Name: branch_room; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.branch_room VALUES (11, 2, 'OT01 Bunaken 02', '2022-07-16 13:39:55', '2022-07-16 13:39:55');
INSERT INTO public.branch_room VALUES (1, 2, 'OT01 Sumbawa', '2022-06-01 19:47:46.062696', NULL);
INSERT INTO public.branch_room VALUES (6, 3, 'HQ - Bunaken 01', '2022-06-01 19:47:46.062696', NULL);
INSERT INTO public.branch_room VALUES (3, 2, 'OT01 Flores 02', '2022-06-01 19:47:46.062696', NULL);
INSERT INTO public.branch_room VALUES (4, 2, 'OT01 Jawa 02', '2022-06-01 19:47:46.062696', NULL);
INSERT INTO public.branch_room VALUES (5, 3, 'OT02 Flores 03', '2022-06-01 19:47:46.062696', NULL);
INSERT INTO public.branch_room VALUES (7, 3, 'OT03 Jawa 03', '2022-06-01 19:47:46.062696', NULL);


--
-- TOC entry 3916 (class 0 OID 16414)
-- Dependencies: 218
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.company VALUES (1, 'Kakiku', 'Gading Serpong I', 'Tangerang', 'admin@kakiku.com', '031-3322224', '6d4c83f6b695389b860d79e975e13751.png', '2022-09-03 00:59:33', '2022-08-30 22:06:56.025994');


--
-- TOC entry 3918 (class 0 OID 16421)
-- Dependencies: 220
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.customers VALUES (12, 'Test Name', 'Test Address', 'Test Phone', 1, '1', 2, '2022-08-10 07:51:57', '2022-08-10 07:51:57');
INSERT INTO public.customers VALUES (17, 'Memp', 'Jalan Karangn', '08576443', 1, '1', 2, '2022-08-10 08:32:39', '2022-08-10 08:32:39');
INSERT INTO public.customers VALUES (1, 'UMUM', 'Jalan Umum', '6285746879090', 1, 'OT01-UM', 2, '2022-06-02 20:38:02.11776', NULL);
INSERT INTO public.customers VALUES (4, 'UMUM', 'Jalan Umum', '6285746879090', 1, 'OT02-UM', 3, '2022-06-02 20:38:02.11776', NULL);


--
-- TOC entry 3920 (class 0 OID 16429)
-- Dependencies: 222
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.departments VALUES (2, 'OPERASIONAL', '2022-06-01 19:49:58.185846', NULL, 1);
INSERT INTO public.departments VALUES (3, 'FINANCE', '2022-06-01 19:49:58.185846', NULL, 1);
INSERT INTO public.departments VALUES (4, 'HR', '2022-06-01 19:49:58.185846', NULL, 1);
INSERT INTO public.departments VALUES (5, 'IT', '2022-06-01 19:49:58.185846', NULL, 1);
INSERT INTO public.departments VALUES (1, 'SALES', '2022-06-01 19:49:58.185846', NULL, 1);
INSERT INTO public.departments VALUES (6, 'MANAGEMENT', '2022-06-01 19:49:58.185846', NULL, 1);
INSERT INTO public.departments VALUES (9, 'TRAINING', '2022-08-06 23:00:27', '2022-08-06 23:00:27', 1);


--
-- TOC entry 3922 (class 0 OID 16437)
-- Dependencies: 224
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3924 (class 0 OID 16444)
-- Dependencies: 226
-- Data for Name: invoice_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000001', 48, 4, 110000, 439000, 1000, 0, 29, NULL, '2022-10-09 15:27:43', '2022-10-09 15:27:43', '60 Menit', 'Body Cop With Massage', 11, 48290, 'John Doe-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000001', 43, 2, 135000, 268000, 2000, 1, 29, NULL, '2022-10-09 15:27:43', '2022-10-09 15:27:43', '90 Menit', 'Tuina', 11, 29480, 'John Doe-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000001', 85, 1, 10000, 10000, 0, 2, 29, NULL, '2022-10-09 15:27:43', '2022-10-09 15:27:43', 'Pcs', 'Extra Charge Room', 0, 0, 'John Doe-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000001', 7, 1, 150000, 150000, 0, 3, 29, NULL, '2022-10-09 15:27:43', '2022-10-09 15:27:43', 'Bungkus', 'ACL - MASKER BADAN', 11, 16500, 'John Doe-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000001', 11, 1, 25000, 25000, 0, 4, 29, NULL, '2022-10-09 15:27:43', '2022-10-09 15:27:43', 'Sacheet', 'BALI ALUS - DUDUS CELUP ', 11, 2750, 'John Doe-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000048', 46, 1, 135000, 135000, 0, 0, 53, NULL, '2022-10-09 15:28:42', '2022-10-09 15:28:42', '90 Menit', 'Full Body Therapy', 11, 14850, 'Fake Hokis-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000048', 45, 1, 135000, 135000, 0, 1, 53, NULL, '2022-10-09 15:28:42', '2022-10-09 15:28:42', '90 Menit', 'Full Body Reflexology', 11, 14850, 'Fake Hokis-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000049', 48, 1, 110000, 110000, 0, 0, 33, NULL, '2022-10-15 18:35:37', '2022-10-15 18:35:37', '60 Menit', 'Body Cop With Massage', 11, 12100, 'Fist Karl-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000049', 46, 1, 135000, 135000, 0, 1, 33, NULL, '2022-10-15 18:35:37', '2022-10-15 18:35:37', '90 Menit', 'Full Body Therapy', 11, 14850, 'Fist Karl-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000050', 46, 1, 135000, 135000, 0, 0, 29, NULL, '2022-10-15 18:36:18', '2022-10-15 18:36:18', '90 Menit', 'Full Body Therapy', 11, 14850, 'John Doe-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000051', 48, 1, 110000, 110000, 0, 0, 29, NULL, '2022-10-15 20:09:31', '2022-10-15 20:09:31', '60 Menit', 'Body Cop With Massage', 11, 12100, 'John Doe-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000051', 86, 1, 20000, 20000, 0, 1, 29, NULL, '2022-10-15 20:09:31', '2022-10-15 20:09:31', 'Pcs', 'Extra Charge Gender', 0, 0, 'John Doe-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000051', 85, 1, 10000, 10000, 0, 2, 29, NULL, '2022-10-15 20:09:31', '2022-10-15 20:09:31', 'Pcs', 'Extra Charge Room', 0, 0, 'John Doe-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000051', 83, 1, 10000, 10000, 0, 3, 29, NULL, '2022-10-15 20:09:31', '2022-10-15 20:09:31', 'Pcs', 'Extra Charge Midnight 21:00', 0, 0, 'John Doe-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000051', 23, 1, 100000, 100000, 0, 4, 29, NULL, '2022-10-15 20:09:31', '2022-10-15 20:09:31', 'Tube', 'BIOKOS - GELK MASK', 11, 11000, 'John Doe-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000052', 35, 1, 5000, 5000, 0, 0, 53, NULL, '2022-10-15 20:13:34', '2022-10-15 20:13:34', 'Botol', 'THE BANDULAN ', 11, 550, 'Fake Hokis-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000053', 89, 1, 10000, 10000, 0, 0, 53, NULL, '2022-10-15 20:41:29', '2022-10-15 20:41:29', 'Botol', 'Test Kotak', 0, 0, 'Fake Hokis-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000053', 84, 1, 20000, 20000, 0, 1, 53, NULL, '2022-10-15 20:41:29', '2022-10-15 20:41:29', 'Pcs', 'Extra Charge Midnight 22:00', 0, 0, 'Fake Hokis-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000054', 48, 1, 110000, 110000, 0, 0, 32, NULL, '2022-10-23 19:21:43', '2022-10-23 19:21:43', '60 Menit', 'Body Cop With Massage', 11, 12100, 'Jemm Rakar-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000054', 44, 1, 135000, 135000, 0, 1, 53, NULL, '2022-10-23 19:21:43', '2022-10-23 19:21:43', '90 Menit', 'Hot Stone', 11, 14850, 'Fake Hokis-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000054', 7, 1, 150000, 150000, 0, 2, 32, NULL, '2022-10-23 19:21:43', '2022-10-23 19:21:43', 'Bungkus', 'ACL - MASKER BADAN', 11, 16500, 'Jemm Rakar-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000055', 48, 10, 110000, 1100000, 0, 0, 32, NULL, '2022-10-23 19:43:08', '2022-10-23 19:43:08', '60 Menit', 'Body Cop With Massage', 11, 121000, 'Jemm Rakar-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000055', 44, 8, 135000, 1080000, 0, 1, 30, NULL, '2022-10-23 19:43:08', '2022-10-23 19:43:08', '90 Menit', 'Hot Stone', 11, 118800, 'Mark Karl-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000056', 48, 1, 110000, 110000, 0, 0, 29, NULL, '2022-10-29 17:07:50', '2022-10-29 17:07:50', '60 Menit', 'Body Cop With Massage', 11, 12100, 'John Doe-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000056', 46, 1, 135000, 135000, 0, 1, 29, NULL, '2022-10-29 17:07:50', '2022-10-29 17:07:50', '90 Menit', 'Full Body Therapy', 11, 14850, 'John Doe-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000056', 44, 1, 135000, 135000, 0, 2, 29, NULL, '2022-10-29 17:07:50', '2022-10-29 17:07:50', '90 Menit', 'Hot Stone', 11, 14850, 'John Doe-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000057', 47, 4, 110000, 440000, 0, 0, 31, NULL, '2022-10-29 17:09:02', '2022-10-29 17:09:02', '60 Menit', 'Back Massage / Dry', 11, 48400, 'Johny Deep-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000057', 5, 1, 175000, 175000, 0, 1, 31, NULL, '2022-10-29 17:09:02', '2022-10-29 17:09:02', 'Botol', 'ACL - LINEN SPRAY', 11, 19250, 'Johny Deep-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000058', 9, 1, 60000, 60000, 0, 0, 33, NULL, '2022-11-15 17:49:42', '2022-11-15 17:49:42', 'Botol', 'ACL - PENYEGAR WAJAH ', 11, 6600, 'Fist Karl-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000058', 57, 3, 65000, 195000, 0, 1, 33, NULL, '2022-11-15 17:49:42', '2022-11-15 17:49:42', '20 Menit', 'Ratus With Hand Massage', 11, 21450, 'Fist Karl-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000058', 47, 1, 110000, 110000, 0, 2, 33, NULL, '2022-11-15 17:49:42', '2022-11-15 17:49:42', '60 Menit', 'Back Massage / Dry', 11, 12100, 'Fist Karl-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000059', 10, 1, 60000, 60000, 0, 0, 33, NULL, '2022-11-15 17:51:30', '2022-11-15 17:51:30', 'Tube', 'BALI ALUS - BODY WITHENING', 11, 6600, 'Fist Karl-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000059', 22, 4, 125000, 500000, 0, 1, 29, NULL, '2022-11-15 17:51:30', '2022-11-15 17:51:30', 'Tube', 'BIOKOS - CREAM MASSAGE ', 11, 55000, 'John Doe-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000059', 45, 1, 135000, 135000, 0, 2, 30, NULL, '2022-11-15 17:51:30', '2022-11-15 17:51:30', '90 Menit', 'Full Body Reflexology', 11, 14850, 'Mark Karl-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000059', 48, 1, 110000, 110000, 0, 3, 30, NULL, '2022-11-15 17:51:30', '2022-11-15 17:51:30', '60 Menit', 'Body Cop With Massage', 11, 12100, 'Mark Karl-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000060', 20, 1, 100000, 100000, 0, 0, 33, NULL, '2022-11-15 20:08:58', '2022-11-15 20:08:58', 'Bungkus', 'GREEN SPA LULUR BALI ALUS', 11, 11000, 'Fist Karl-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000001', 20, 1, 100000, 100000, 0, 0, 33, NULL, '2022-11-26 01:15:01', '2022-11-26 01:15:01', 'Bungkus', 'GREEN SPA LULUR BALI ALUS', 11, 11000, 'Fist Karl-Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000002', 20, 1, 100000, 100000, 0, 0, 32, NULL, '2022-12-03 18:39:17', '2022-12-03 18:39:17', 'Bungkus', 'GREEN SPA LULUR BALI ALUS', 11, 11000, 'Anni -Terapist', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000003', 11, 1, 25000, 25000, 0, 0, 32, NULL, '2022-12-03 18:46:55', '2022-12-03 18:46:55', 'Sacheet', 'BALI ALUS - DUDUS CELUP ', 11, 2750, 'Anni -Terapist', '', 25000);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000003', 28, 1, 60000, 60000, 0, 1, 33, NULL, '2022-12-03 18:46:55', '2022-12-03 18:46:55', 'Buah', 'HERBAL COMPRESS', 11, 6600, 'Zilong -Terapist', '', 60000);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000004', 20, 1, 100000, 100000, 0, 0, 32, NULL, '2022-12-03 20:50:36', '2022-12-03 20:50:36', 'Bungkus', 'GREEN SPA LULUR BALI ALUS', 11, 11000, 'Anni -Terapist', '', 99000);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000004', 9, 1, 60000, 60000, 0, 1, 14, NULL, '2022-12-03 20:50:36', '2022-12-03 20:50:36', 'Botol', 'ACL - PENYEGAR WAJAH ', 11, 6600, 'Nana  -Terapist', '', 59000);
INSERT INTO public.invoice_detail VALUES ('INV-003-2022-00000004', 21, 1, 150000, 150000, 0, 2, 32, NULL, '2022-12-03 20:50:36', '2022-12-03 20:50:36', 'Botol', 'BIOKOS - CLEANSER', 11, 16500, 'Anni -Terapist', '', 149000);
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000058', 9, 1, 60000, 60000, 0, 0, 53, 1, '2022-12-11 11:05:58', '2022-12-11 11:05:58', 'Botol', 'ACL - PENYEGAR WAJAH ', 11, 6600, 'Fake Hokis -Terapist', 'Admin', 59000);


--
-- TOC entry 3925 (class 0 OID 16455)
-- Dependencies: 227
-- Data for Name: invoice_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.invoice_master VALUES (49, 'INV-002-2022-00000049', '2022-10-15', 12, 271950, 53900, 271950, 0, NULL, 'BCA - Debit', 272000, NULL, '2022-10-15 18:45:00', 11, NULL, NULL, NULL, '2022-10-15 18:35:37', 1, '2022-10-15 18:35:37', 0, 0, 'Test Name', 0);
INSERT INTO public.invoice_master VALUES (47, 'INV-002-2022-00000001', '2022-10-16', 12, 989020, 194040, 989020, 0, NULL, 'Cash', 1000000, NULL, '2022-10-09 15:30:00', 1, NULL, NULL, NULL, '2022-10-09 15:27:43', 1, '2022-10-09 15:27:43', 0, 0, 'Test Name', 0);
INSERT INTO public.invoice_master VALUES (53, 'INV-002-2022-00000053', '2022-10-23', 1, 30000, 0, 30000, 0, NULL, 'Mandiri - Debit', 30000, NULL, '2022-10-15 20:45:00', 4, NULL, NULL, NULL, '2022-10-15 20:41:29', 1, '2022-10-15 20:41:29', 0, 0, 'UMUM', 0);
INSERT INTO public.invoice_master VALUES (48, 'INV-002-2022-00000048', '2022-10-16', 17, 299700, 59400, 299700, 0, NULL, 'Cash', 300000, NULL, '2022-10-09 15:30:00', 7, NULL, NULL, NULL, '2022-10-09 15:28:42', 1, '2022-10-09 15:28:42', 0, 0, 'Memp', 0);
INSERT INTO public.invoice_master VALUES (50, 'INV-002-2022-00000050', '2022-10-16', 12, 149850, 29700, 149850, 0, NULL, 'Cash', 150000, NULL, '2022-10-15 18:45:00', 1, NULL, NULL, NULL, '2022-10-15 18:36:18', 1, '2022-10-15 18:36:18', 0, 0, 'Test Name', 0);
INSERT INTO public.invoice_master VALUES (51, 'INV-002-2022-00000051', '2022-10-16', 12, 273100, 46200, 273100, 0, NULL, 'BCA - Kredit', 280000, NULL, '2022-10-15 20:15:00', 1, NULL, NULL, NULL, '2022-10-15 20:09:31', 1, '2022-10-15 20:09:31', 0, 0, 'Test Name', 0);
INSERT INTO public.invoice_master VALUES (52, 'INV-002-2022-00000052', '2022-10-16', 12, 5550, 1100, 5550, 0, NULL, 'Mandiri - Debit', 6000, NULL, '2022-10-15 20:15:00', 11, NULL, NULL, NULL, '2022-10-15 20:13:34', 1, '2022-10-15 20:13:34', 0, 0, 'Test Name', 0);
INSERT INTO public.invoice_master VALUES (54, 'INV-002-2022-00000054', '2022-10-23', 12, 438450, 86900, 438450, 0, NULL, 'Cash', 500000, NULL, '2022-10-23 19:30:00', 11, NULL, NULL, NULL, '2022-10-23 19:21:43', 1, '2022-10-23 19:21:43', 0, 0, 'Test Name', 0);
INSERT INTO public.invoice_master VALUES (55, 'INV-002-2022-00000055', '2022-10-23', 12, 2419800, 479600, 2419800, 0, NULL, 'BCA - Debit', 3000000, NULL, '2022-10-23 19:45:00', 6, NULL, NULL, NULL, '2022-10-23 19:43:08', 1, '2022-10-23 19:43:08', 0, 0, 'Test Name', 0);
INSERT INTO public.invoice_master VALUES (56, 'INV-002-2022-00000056', '2022-10-29', 17, 421800, 83600, 421800, 0, NULL, 'Cash', 500000, NULL, '2022-10-29 17:15:00', 1, NULL, NULL, NULL, '2022-10-29 17:07:50', 1, '2022-10-29 17:07:50', 0, 0, 'Memp', 0);
INSERT INTO public.invoice_master VALUES (57, 'INV-003-2022-00000057', '2022-10-29', 4, 682650, 135300, 682650, 0, NULL, 'BCA - Debit', 700000, NULL, '2022-10-29 17:15:00', 4, NULL, NULL, NULL, '2022-10-29 17:09:02', 1, '2022-10-29 17:09:02', 0, 0, 'UMUM', 0);
INSERT INTO public.invoice_master VALUES (61, 'INV-003-2022-00000001', '2022-11-26', 4, 111000, 22000, 11, 0, NULL, 'BCA - Debit', 11, NULL, '2022-11-26 01:15:00', 11, NULL, NULL, NULL, '2022-11-26 01:15:01', 1, '2022-11-26 01:15:01', 0, 0, 'UMUM', 0);
INSERT INTO public.invoice_master VALUES (59, 'INV-003-2022-00000059', '2022-11-15', 4, 893550, 177100, 893550, 0, NULL, 'BCA - Kredit', 900000, NULL, '2022-11-15 18:00:00', 5, NULL, NULL, NULL, '2022-11-15 17:53:20', 1, '2022-11-15 17:51:30', 0, 0, 'UMUM', 2);
INSERT INTO public.invoice_master VALUES (60, 'INV-003-2022-00000060', '2022-11-15', 4, 111000, 22000, 111000, 0, NULL, 'Cash', 120000, NULL, '2022-11-15 20:15:00', 1, NULL, NULL, NULL, '2022-11-15 20:08:58', 1, '2022-11-15 20:08:58', 0, 0, 'UMUM', 0);
INSERT INTO public.invoice_master VALUES (65, 'INV-003-2022-00000002', '2022-12-03', 4, 111000, 22000, 1, 0, NULL, 'Cash', 1, NULL, '2022-12-03 18:45:00', 1, NULL, NULL, NULL, '2022-12-03 18:39:17', 1, '2022-12-03 18:39:17', 0, 0, 'UMUM', 0);
INSERT INTO public.invoice_master VALUES (66, 'INV-003-2022-00000003', '2022-12-03', 4, 94350, 18700, 94350, 0, NULL, 'Cash', 95000, NULL, '2022-12-03 18:45:00', 11, NULL, NULL, NULL, '2022-12-03 18:46:55', 1, '2022-12-03 18:46:55', 0, 0, 'UMUM', 0);
INSERT INTO public.invoice_master VALUES (69, 'INV-003-2022-00000004', '2022-12-03', 4, 344100, 68200, 344100, 0, NULL, 'Cash', 540000, NULL, '2022-12-03 21:00:00', 6, NULL, NULL, NULL, '2022-12-03 20:50:36', 1, '2022-12-03 20:50:36', 0, 0, 'UMUM', 0);
INSERT INTO public.invoice_master VALUES (72, 'INV-002-2022-00000058', '2022-12-11', 17, 66600, 6600, 66600, 0, NULL, 'Cash', 67000, NULL, '2022-12-03 15:30:00', 1, 'SPK-002-2022-00000006', NULL, NULL, '2022-12-11 11:05:58', 1, '2022-12-11 11:05:58', 0, 0, 'Memp', 0);
INSERT INTO public.invoice_master VALUES (58, 'INV-003-2022-00000058', '2022-11-15', 4, 405150, 80300, 405150, 0, 'Test 2', 'Cash', 500000, NULL, '2022-11-15 18:00:00', 3, NULL, NULL, NULL, '2022-11-20 15:07:51', 1, '2022-11-15 17:49:42', 0, 0, 'UMUM', 25);


--
-- TOC entry 3927 (class 0 OID 16472)
-- Dependencies: 229
-- Data for Name: job_title; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.job_title VALUES (1, 'Kasir', '2022-06-01 19:52:32.509771', 1);
INSERT INTO public.job_title VALUES (2, 'Terapist', '2022-06-01 19:52:32.509771', 1);
INSERT INTO public.job_title VALUES (3, 'Owner', '2022-06-01 19:52:32.509771', 1);
INSERT INTO public.job_title VALUES (6, 'Administrator', '2022-06-01 19:52:32.509771', 1);
INSERT INTO public.job_title VALUES (4, 'Staff Finance & Accounting', '2022-06-01 19:52:32.509771', 1);
INSERT INTO public.job_title VALUES (5, 'Staff Human Resource', '2022-06-01 19:52:32.509771', 1);
INSERT INTO public.job_title VALUES (7, 'Trainer', '2022-06-01 19:52:32.509771', 1);


--
-- TOC entry 3929 (class 0 OID 16480)
-- Dependencies: 231
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.migrations VALUES (1, '2014_10_12_000000_create_users_table', 1);
INSERT INTO public.migrations VALUES (2, '2014_10_12_100000_create_password_resets_table', 1);
INSERT INTO public.migrations VALUES (3, '2019_08_19_000000_create_failed_jobs_table', 1);
INSERT INTO public.migrations VALUES (4, '2019_12_14_000001_create_personal_access_tokens_table', 1);
INSERT INTO public.migrations VALUES (5, '2022_05_28_121734_create_permission_tables', 1);
INSERT INTO public.migrations VALUES (6, '2022_05_28_121901_create_posts_table', 2);
INSERT INTO public.migrations VALUES (7, '2022_09_11_141615_create_password_resets_table', 0);
INSERT INTO public.migrations VALUES (8, '2022_09_11_141615_create_failed_jobs_table', 0);
INSERT INTO public.migrations VALUES (9, '2022_09_11_141615_create_personal_access_tokens_table', 0);
INSERT INTO public.migrations VALUES (10, '2022_09_11_142556_create_users_table', 0);
INSERT INTO public.migrations VALUES (11, '2022_09_11_142556_create_password_resets_table', 0);
INSERT INTO public.migrations VALUES (12, '2022_09_11_142556_create_failed_jobs_table', 0);
INSERT INTO public.migrations VALUES (13, '2022_09_11_142556_create_personal_access_tokens_table', 0);
INSERT INTO public.migrations VALUES (14, '2022_09_11_142556_create_model_has_permissions_table', 0);
INSERT INTO public.migrations VALUES (15, '2022_09_11_142556_create_roles_table', 0);
INSERT INTO public.migrations VALUES (16, '2022_09_11_142556_create_model_has_roles_table', 0);
INSERT INTO public.migrations VALUES (17, '2022_09_11_142556_create_role_has_permissions_table', 0);
INSERT INTO public.migrations VALUES (18, '2022_09_11_142556_create_permissions_table', 0);
INSERT INTO public.migrations VALUES (19, '2022_09_11_142556_create_order_master_table', 0);
INSERT INTO public.migrations VALUES (20, '2022_09_11_142556_create_posts_table', 0);
INSERT INTO public.migrations VALUES (21, '2022_09_11_143016_create_users_table', 0);
INSERT INTO public.migrations VALUES (22, '2022_09_11_143016_create_password_resets_table', 0);
INSERT INTO public.migrations VALUES (23, '2022_09_11_143016_create_failed_jobs_table', 0);
INSERT INTO public.migrations VALUES (24, '2022_09_11_143016_create_personal_access_tokens_table', 0);
INSERT INTO public.migrations VALUES (25, '2022_09_11_143016_create_model_has_permissions_table', 0);
INSERT INTO public.migrations VALUES (26, '2022_09_11_143016_create_roles_table', 0);
INSERT INTO public.migrations VALUES (27, '2022_09_11_143016_create_model_has_roles_table', 0);
INSERT INTO public.migrations VALUES (28, '2022_09_11_143016_create_role_has_permissions_table', 0);
INSERT INTO public.migrations VALUES (29, '2022_09_11_143016_create_permissions_table', 0);
INSERT INTO public.migrations VALUES (30, '2022_09_11_143016_create_order_master_table', 0);
INSERT INTO public.migrations VALUES (31, '2022_09_11_143016_create_posts_table', 0);
INSERT INTO public.migrations VALUES (32, '2022_09_11_143016_create_product_sku_table', 0);
INSERT INTO public.migrations VALUES (33, '2022_09_11_143016_create_product_brand_table', 0);
INSERT INTO public.migrations VALUES (34, '2022_09_11_143016_create_product_category_table', 0);
INSERT INTO public.migrations VALUES (35, '2022_09_11_143016_create_users_skills_table', 0);
INSERT INTO public.migrations VALUES (36, '2022_09_11_143016_create_product_distribution_table', 0);
INSERT INTO public.migrations VALUES (37, '2022_09_11_143016_create_product_price_table', 0);
INSERT INTO public.migrations VALUES (38, '2022_09_11_143016_create_period_table', 0);
INSERT INTO public.migrations VALUES (39, '2022_09_11_143016_create_order_detail_table', 0);
INSERT INTO public.migrations VALUES (40, '2022_09_11_143016_create_product_commision_by_year_table', 0);
INSERT INTO public.migrations VALUES (41, '2022_09_11_143016_create_product_point_table', 0);
INSERT INTO public.migrations VALUES (42, '2022_09_11_143016_create_product_commisions_table', 0);
INSERT INTO public.migrations VALUES (43, '2022_09_11_143016_create_departments_table', 0);
INSERT INTO public.migrations VALUES (44, '2022_09_11_143016_create_job_title_table', 0);
INSERT INTO public.migrations VALUES (45, '2022_09_11_143016_create_branch_table', 0);
INSERT INTO public.migrations VALUES (46, '2022_09_11_143016_create_users_mutation_table', 0);
INSERT INTO public.migrations VALUES (47, '2022_09_11_143016_create_customers_table', 0);
INSERT INTO public.migrations VALUES (48, '2022_09_11_143016_create_product_uom_table', 0);
INSERT INTO public.migrations VALUES (49, '2022_09_11_143016_create_branch_room_table', 0);
INSERT INTO public.migrations VALUES (50, '2022_09_11_143016_create_users_branch_table', 0);
INSERT INTO public.migrations VALUES (51, '2022_09_11_143016_create_invoice_detail_table', 0);
INSERT INTO public.migrations VALUES (52, '2022_09_11_143016_create_product_stock_table', 0);
INSERT INTO public.migrations VALUES (53, '2022_09_11_143016_create_uom_table', 0);
INSERT INTO public.migrations VALUES (54, '2022_09_11_143016_create_product_type_table', 0);
INSERT INTO public.migrations VALUES (55, '2022_09_11_143016_create_invoice_master_table', 0);
INSERT INTO public.migrations VALUES (56, '2022_09_11_143016_create_settings_table', 0);
INSERT INTO public.migrations VALUES (57, '2022_09_11_143016_create_suppliers_table', 0);
INSERT INTO public.migrations VALUES (58, '2022_09_11_143016_create_product_stock_detail_table', 0);
INSERT INTO public.migrations VALUES (59, '2022_09_11_143016_create_receive_detail_table', 0);
INSERT INTO public.migrations VALUES (60, '2022_09_11_143016_create_period_stock_table', 0);
INSERT INTO public.migrations VALUES (61, '2022_09_11_143016_create_users_experience_table', 0);
INSERT INTO public.migrations VALUES (62, '2022_09_11_143016_create_purchase_master_table', 0);
INSERT INTO public.migrations VALUES (63, '2022_09_11_143016_create_purchase_detail_table', 0);
INSERT INTO public.migrations VALUES (64, '2022_09_11_143016_create_company_table', 0);
INSERT INTO public.migrations VALUES (65, '2022_09_11_143016_create_product_ingredients_table', 0);
INSERT INTO public.migrations VALUES (66, '2022_09_11_143016_create_shift_table', 0);
INSERT INTO public.migrations VALUES (67, '2022_09_11_143016_create_users_shift_table', 0);
INSERT INTO public.migrations VALUES (68, '2022_09_11_143016_create_receive_master_table', 0);
INSERT INTO public.migrations VALUES (69, '2022_09_11_143017_add_foreign_keys_to_model_has_permissions_table', 0);
INSERT INTO public.migrations VALUES (70, '2022_09_11_143017_add_foreign_keys_to_model_has_roles_table', 0);
INSERT INTO public.migrations VALUES (71, '2022_09_11_143017_add_foreign_keys_to_role_has_permissions_table', 0);
INSERT INTO public.migrations VALUES (72, '2022_09_11_143017_add_foreign_keys_to_order_master_table', 0);
INSERT INTO public.migrations VALUES (73, '2022_09_11_143017_add_foreign_keys_to_posts_table', 0);
INSERT INTO public.migrations VALUES (74, '2022_09_11_143017_add_foreign_keys_to_users_skills_table', 0);
INSERT INTO public.migrations VALUES (75, '2022_09_11_143017_add_foreign_keys_to_product_distribution_table', 0);
INSERT INTO public.migrations VALUES (76, '2022_09_11_143017_add_foreign_keys_to_order_detail_table', 0);
INSERT INTO public.migrations VALUES (77, '2022_09_11_143017_add_foreign_keys_to_product_commision_by_year_table', 0);
INSERT INTO public.migrations VALUES (78, '2022_09_11_143017_add_foreign_keys_to_product_uom_table', 0);
INSERT INTO public.migrations VALUES (79, '2022_09_11_143017_add_foreign_keys_to_branch_room_table', 0);
INSERT INTO public.migrations VALUES (80, '2022_09_11_143017_add_foreign_keys_to_invoice_detail_table', 0);
INSERT INTO public.migrations VALUES (81, '2022_09_11_143017_add_foreign_keys_to_invoice_master_table', 0);
INSERT INTO public.migrations VALUES (82, '2022_09_11_143017_add_foreign_keys_to_receive_detail_table', 0);
INSERT INTO public.migrations VALUES (83, '2022_09_11_143017_add_foreign_keys_to_purchase_master_table', 0);
INSERT INTO public.migrations VALUES (84, '2022_09_11_143017_add_foreign_keys_to_purchase_detail_table', 0);
INSERT INTO public.migrations VALUES (85, '2022_09_11_143017_add_foreign_keys_to_receive_master_table', 0);
INSERT INTO public.migrations VALUES (86, '2022_09_11_143221_create_users_table', 0);
INSERT INTO public.migrations VALUES (87, '2022_09_11_143221_create_password_resets_table', 0);
INSERT INTO public.migrations VALUES (88, '2022_09_11_143221_create_failed_jobs_table', 0);
INSERT INTO public.migrations VALUES (89, '2022_09_11_143221_create_personal_access_tokens_table', 0);
INSERT INTO public.migrations VALUES (90, '2022_09_11_143221_create_model_has_permissions_table', 0);
INSERT INTO public.migrations VALUES (91, '2022_09_11_143221_create_roles_table', 0);
INSERT INTO public.migrations VALUES (92, '2022_09_11_143221_create_model_has_roles_table', 0);
INSERT INTO public.migrations VALUES (93, '2022_09_11_143221_create_role_has_permissions_table', 0);
INSERT INTO public.migrations VALUES (94, '2022_09_11_143221_create_permissions_table', 0);
INSERT INTO public.migrations VALUES (95, '2022_09_11_143221_create_order_master_table', 0);
INSERT INTO public.migrations VALUES (96, '2022_09_11_143221_create_posts_table', 0);
INSERT INTO public.migrations VALUES (97, '2022_09_11_143221_create_product_sku_table', 0);
INSERT INTO public.migrations VALUES (98, '2022_09_11_143221_create_product_brand_table', 0);
INSERT INTO public.migrations VALUES (99, '2022_09_11_143221_create_product_category_table', 0);
INSERT INTO public.migrations VALUES (100, '2022_09_11_143221_create_users_skills_table', 0);
INSERT INTO public.migrations VALUES (101, '2022_09_11_143221_create_product_distribution_table', 0);
INSERT INTO public.migrations VALUES (102, '2022_09_11_143221_create_product_price_table', 0);
INSERT INTO public.migrations VALUES (103, '2022_09_11_143221_create_period_table', 0);
INSERT INTO public.migrations VALUES (104, '2022_09_11_143221_create_order_detail_table', 0);
INSERT INTO public.migrations VALUES (105, '2022_09_11_143221_create_product_commision_by_year_table', 0);
INSERT INTO public.migrations VALUES (106, '2022_09_11_143221_create_product_point_table', 0);
INSERT INTO public.migrations VALUES (107, '2022_09_11_143221_create_product_commisions_table', 0);
INSERT INTO public.migrations VALUES (108, '2022_09_11_143221_create_departments_table', 0);
INSERT INTO public.migrations VALUES (109, '2022_09_11_143221_create_job_title_table', 0);
INSERT INTO public.migrations VALUES (110, '2022_09_11_143221_create_branch_table', 0);
INSERT INTO public.migrations VALUES (111, '2022_09_11_143221_create_users_mutation_table', 0);
INSERT INTO public.migrations VALUES (112, '2022_09_11_143221_create_customers_table', 0);
INSERT INTO public.migrations VALUES (113, '2022_09_11_143221_create_product_uom_table', 0);
INSERT INTO public.migrations VALUES (114, '2022_09_11_143221_create_branch_room_table', 0);
INSERT INTO public.migrations VALUES (115, '2022_09_11_143221_create_users_branch_table', 0);
INSERT INTO public.migrations VALUES (116, '2022_09_11_143221_create_invoice_detail_table', 0);
INSERT INTO public.migrations VALUES (117, '2022_09_11_143221_create_product_stock_table', 0);
INSERT INTO public.migrations VALUES (118, '2022_09_11_143221_create_uom_table', 0);
INSERT INTO public.migrations VALUES (119, '2022_09_11_143221_create_product_type_table', 0);
INSERT INTO public.migrations VALUES (120, '2022_09_11_143221_create_invoice_master_table', 0);
INSERT INTO public.migrations VALUES (121, '2022_09_11_143221_create_settings_table', 0);
INSERT INTO public.migrations VALUES (122, '2022_09_11_143221_create_suppliers_table', 0);
INSERT INTO public.migrations VALUES (123, '2022_09_11_143221_create_product_stock_detail_table', 0);
INSERT INTO public.migrations VALUES (124, '2022_09_11_143221_create_receive_detail_table', 0);
INSERT INTO public.migrations VALUES (125, '2022_09_11_143221_create_period_stock_table', 0);
INSERT INTO public.migrations VALUES (126, '2022_09_11_143221_create_users_experience_table', 0);
INSERT INTO public.migrations VALUES (127, '2022_09_11_143221_create_purchase_master_table', 0);
INSERT INTO public.migrations VALUES (128, '2022_09_11_143221_create_purchase_detail_table', 0);
INSERT INTO public.migrations VALUES (129, '2022_09_11_143221_create_company_table', 0);
INSERT INTO public.migrations VALUES (130, '2022_09_11_143221_create_product_ingredients_table', 0);
INSERT INTO public.migrations VALUES (131, '2022_09_11_143221_create_shift_table', 0);
INSERT INTO public.migrations VALUES (132, '2022_09_11_143221_create_users_shift_table', 0);
INSERT INTO public.migrations VALUES (133, '2022_09_11_143221_create_receive_master_table', 0);
INSERT INTO public.migrations VALUES (134, '2022_09_11_143222_add_foreign_keys_to_model_has_permissions_table', 0);
INSERT INTO public.migrations VALUES (135, '2022_09_11_143222_add_foreign_keys_to_model_has_roles_table', 0);
INSERT INTO public.migrations VALUES (136, '2022_09_11_143222_add_foreign_keys_to_role_has_permissions_table', 0);
INSERT INTO public.migrations VALUES (137, '2022_09_11_143222_add_foreign_keys_to_order_master_table', 0);
INSERT INTO public.migrations VALUES (138, '2022_09_11_143222_add_foreign_keys_to_posts_table', 0);
INSERT INTO public.migrations VALUES (139, '2022_09_11_143222_add_foreign_keys_to_users_skills_table', 0);
INSERT INTO public.migrations VALUES (140, '2022_09_11_143222_add_foreign_keys_to_product_distribution_table', 0);
INSERT INTO public.migrations VALUES (141, '2022_09_11_143222_add_foreign_keys_to_order_detail_table', 0);
INSERT INTO public.migrations VALUES (142, '2022_09_11_143222_add_foreign_keys_to_product_commision_by_year_table', 0);
INSERT INTO public.migrations VALUES (143, '2022_09_11_143222_add_foreign_keys_to_product_uom_table', 0);
INSERT INTO public.migrations VALUES (144, '2022_09_11_143222_add_foreign_keys_to_branch_room_table', 0);
INSERT INTO public.migrations VALUES (145, '2022_09_11_143222_add_foreign_keys_to_invoice_detail_table', 0);
INSERT INTO public.migrations VALUES (146, '2022_09_11_143222_add_foreign_keys_to_invoice_master_table', 0);
INSERT INTO public.migrations VALUES (147, '2022_09_11_143222_add_foreign_keys_to_receive_detail_table', 0);
INSERT INTO public.migrations VALUES (148, '2022_09_11_143222_add_foreign_keys_to_purchase_master_table', 0);
INSERT INTO public.migrations VALUES (149, '2022_09_11_143222_add_foreign_keys_to_purchase_detail_table', 0);
INSERT INTO public.migrations VALUES (150, '2022_09_11_143222_add_foreign_keys_to_receive_master_table', 0);


--
-- TOC entry 3931 (class 0 OID 16484)
-- Dependencies: 233
-- Data for Name: model_has_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3932 (class 0 OID 16487)
-- Dependencies: 234
-- Data for Name: model_has_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.model_has_roles VALUES (1, 'App\Models\User', 1);
INSERT INTO public.model_has_roles VALUES (6, 'App\Models\User', 5);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 26);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 29);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 31);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 30);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 32);
INSERT INTO public.model_has_roles VALUES (4, 'App\Models\User', 4);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 27);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 33);
INSERT INTO public.model_has_roles VALUES (4, 'App\Models\User', 38);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 39);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 40);
INSERT INTO public.model_has_roles VALUES (4, 'App\Models\User', 45);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 46);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 47);
INSERT INTO public.model_has_roles VALUES (2, 'App\Models\User', 53);
INSERT INTO public.model_has_roles VALUES (11, 'App\Models\User', 54);
INSERT INTO public.model_has_roles VALUES (2, 'App\Models\User', 3);
INSERT INTO public.model_has_roles VALUES (3, 'App\Models\User', 2);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 14);


--
-- TOC entry 3933 (class 0 OID 16490)
-- Dependencies: 235
-- Data for Name: order_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.order_detail VALUES ('SPK-002-2022-00000092', 48, 1, 110000, 110000, 0, 0, 33, 1, '2022-10-03 15:56:00', '2022-10-03 15:56:00', '60 Menit', 'Body Cop With Massage', 'Fist Karl-Terapist', 'Admin', 11, 12100);
INSERT INTO public.order_detail VALUES ('SPK-002-2022-00000092', 46, 1, 135000, 135000, 0, 1, 53, 1, '2022-10-03 15:56:00', '2022-10-03 15:56:00', '90 Menit', 'Full Body Therapy', 'Fake Hokis-Terapist', 'Admin', 11, 14850);
INSERT INTO public.order_detail VALUES ('SPK-003-2022-00000093', 59, 1, 185000, 185000, 0, 0, 29, 1, '2022-11-15 17:47:32', '2022-11-15 17:47:32', '100 Menit', 'Body Bleacing Package', 'John Doe-Terapist', 'Admin', 11, 20350);
INSERT INTO public.order_detail VALUES ('SPK-003-2022-00000093', 60, 4, 100000, 100000, 0, 1, 30, 1, '2022-11-15 17:47:32', '2022-11-15 17:47:32', '60 Menit', 'Bali Alus Body Scrub', 'Mark Karl-Terapist', 'Admin', 11, 44000);
INSERT INTO public.order_detail VALUES ('SPK-003-2022-00000093', 13, 1, 40000, 40000, 0, 2, 29, 1, '2022-11-15 17:47:32', '2022-11-15 17:47:32', 'Buah', 'BALI ALUS - LULUR GREENTEA', 'John Doe-Terapist', 'Admin', 11, 4400);
INSERT INTO public.order_detail VALUES ('SPK-003-2022-00000094', 23, 3, 100000, 100000, 0, 0, 30, 1, '2022-11-15 19:56:17', '2022-11-15 19:56:17', 'Tube', 'BIOKOS - GELK MASK', 'Mark Karl-Terapist', 'Admin', 11, 33000);
INSERT INTO public.order_detail VALUES ('SPK-003-2022-00000094', 46, 1, 135000, 135000, 0, 1, 30, 1, '2022-11-15 19:56:17', '2022-11-15 19:56:17', '90 Menit', 'Full Body Therapy', 'Mark Karl-Terapist', 'Admin', 11, 14850);
INSERT INTO public.order_detail VALUES ('SPK-003-2022-00000094', 2, 1, 20000, 20000, 0, 2, 30, 1, '2022-11-15 19:56:17', '2022-11-15 19:56:17', 'Bungkus', 'ACL - CREAM HANGAT BUNGKUS', 'Mark Karl-Terapist', 'Admin', 11, 2200);
INSERT INTO public.order_detail VALUES ('SPK-003-2022-00000001', 9, 1, 60000, 60000, 0, 0, 33, 1, '2022-11-26 00:30:52', '2022-11-26 00:30:52', 'Botol', 'ACL - PENYEGAR WAJAH', 'Fist Karl-Terapist', 'Admin', 11, 6600);
INSERT INTO public.order_detail VALUES ('SPK-003-2022-00000002', 9, 1, 60000, 60000, 0, 0, 33, 1, '2022-11-26 00:36:35', '2022-11-26 00:36:35', 'Botol', 'ACL - PENYEGAR WAJAH', 'Fist Karl-Terapist', 'Admin', 11, 6600);
INSERT INTO public.order_detail VALUES ('SPK-002-2022-00000002', 20, 1, 100000, 100000, 0, 0, 53, 1, '2022-11-26 00:55:33', '2022-11-26 00:55:33', 'Bungkus', 'GREEN SPA LULUR BALI ALUS', 'Fake Hokis-Terapist', 'Admin', 11, 11000);
INSERT INTO public.order_detail VALUES ('SPK-003-2022-00000003', 20, 1, 100000, 100000, 0, 0, 14, 1, '2022-12-01 09:22:28', '2022-12-01 09:22:28', 'Bungkus', 'GREEN SPA LULUR BALI ALUS', 'Nana  -Terapist', 'Admin', 11, 11000);
INSERT INTO public.order_detail VALUES ('SPK-002-2022-00000003', 3, 1, 250000, 250000, 0, 0, 14, 1, '2022-12-01 09:25:01', '2022-12-01 09:25:01', 'Botol', 'ACL - CREAM HANGAT BOTOL', 'Nana  -Terapist', 'Admin', 11, 27500);
INSERT INTO public.order_detail VALUES ('SPK-002-2022-00000004', 20, 1, 100000, 100000, 0, 0, 32, 1, '2022-12-01 09:37:23', '2022-12-01 09:37:23', 'Bungkus', 'GREEN SPA LULUR BALI ALUS', 'Anni -Terapist', 'Admin', 11, 11000);
INSERT INTO public.order_detail VALUES ('SPK-002-2022-00000005', 9, 1, 60000, 60000, 0, 0, 29, 1, '2022-12-03 08:13:58', '2022-12-03 08:13:58', 'Botol', 'ACL - PENYEGAR WAJAH', 'John Doe-Terapist', 'Admin', 11, 6600);
INSERT INTO public.order_detail VALUES ('SPK-002-2022-00000006', 9, 1, 60000, 60000, 0, 0, 53, 1, '2022-12-03 16:02:09', '2022-12-03 16:02:09', 'Botol', 'ACL - PENYEGAR WAJAH', 'Fake Hokis -Terapist', 'Admin', 11, 6600);
INSERT INTO public.order_detail VALUES ('SPK-003-2022-00000004', 20, 1, 100000, 100000, 0, 0, 32, 1, '2022-12-03 16:35:48', '2022-12-03 16:35:48', 'Bungkus', 'GREEN SPA LULUR BALI ALUS', 'Anni -Terapist', 'Admin', 11, 11000);


--
-- TOC entry 3934 (class 0 OID 16501)
-- Dependencies: 236
-- Data for Name: order_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.order_master VALUES (92, 'SPK-002-2022-00000092', '2022-10-03', 12, 1, '2022-10-03 15:56:00', 271950, 26950, 271950, 0, NULL, 'Cash', 300000, NULL, '2022-11-13 18:26:39', '2022-11-13 18:26:39', NULL, '2022-10-03 23:00:00', 11, 0, 0, 'Test Name', 91, NULL);
INSERT INTO public.order_master VALUES (94, 'SPK-003-2022-00000094', '2022-11-15', 4, 1, '2022-11-15 19:56:17', 505050, 50050, 505050, 0, NULL, 'Cash', 510000, NULL, NULL, '2022-11-15 19:56:17', NULL, '2022-11-15 20:15:00', 3, 0, 0, 'UMUM', 0, NULL);
INSERT INTO public.order_master VALUES (93, 'SPK-003-2022-00000093', '2022-11-15', 4, 1, '2022-11-15 17:47:31', 693750, 68750, 693750, 0, 'Test 2', 'Cash', 700000, NULL, '2022-11-20 15:09:32', '2022-11-20 15:09:32', NULL, '2022-11-15 17:45:00', 11, 0, 0, 'UMUM', 8, NULL);
INSERT INTO public.order_master VALUES (95, 'SPK-003-2022-00000001', '2022-11-26', 4, 1, '2022-11-26 00:30:52', 66600, 6600, 66600, 0, 'Test 2', 'Cash', 70000, NULL, NULL, '2022-11-26 00:30:52', NULL, '2022-11-26 00:30:00', 1, 0, 0, 'UMUM', 0, NULL);
INSERT INTO public.order_master VALUES (96, 'SPK-003-2022-00000002', '2022-11-26', 4, 1, '2022-11-26 00:36:35', 66600, 6600, 66600, 0, '184;20350;204350', 'BCA - Kredit', 70000, NULL, NULL, '2022-11-26 00:36:35', NULL, '2022-11-26 00:45:00', 1, 0, 0, 'UMUM', 0, NULL);
INSERT INTO public.order_master VALUES (97, 'SPK-002-2022-00000002', '2022-11-26', 12, 1, '2022-11-26 00:55:33', 111000, 11000, 1000, 0, NULL, 'BCA - Debit', 1000, NULL, NULL, '2022-11-26 00:55:33', NULL, '2022-11-26 01:00:00', 1, 0, 0, 'Test Name', 0, '0');
INSERT INTO public.order_master VALUES (101, 'SPK-003-2022-00000003', '2022-12-01', 4, 1, '2022-12-01 09:22:28', 111000, 11000, 1, 0, NULL, 'BCA - Debit', 1, NULL, NULL, '2022-12-01 09:22:28', NULL, '2022-12-01 09:30:00', 1, 0, 0, 'UMUM', 0, '1');
INSERT INTO public.order_master VALUES (102, 'SPK-002-2022-00000003', '2022-12-01', 17, 1, '2022-12-01 09:25:01', 277500, 27500, 1, 0, NULL, 'Cash', 1, NULL, NULL, '2022-12-01 09:25:01', NULL, '2022-12-01 09:30:00', 11, 0, 0, 'Memp', 0, '1');
INSERT INTO public.order_master VALUES (106, 'SPK-002-2022-00000004', '2022-12-01', 17, 1, '2022-12-01 09:37:23', 111000, 11000, 1, 0, NULL, 'Cash', 1, NULL, NULL, '2022-12-01 09:37:23', NULL, '2022-12-01 09:45:00', 1, 0, 0, 'Memp', 0, '2');
INSERT INTO public.order_master VALUES (107, 'SPK-002-2022-00000005', '2022-12-03', 17, 1, '2022-12-03 08:13:58', 66600, 6600, 66600, 0, NULL, 'Cash', 70000, NULL, NULL, '2022-12-03 08:13:58', NULL, '2022-12-03 08:15:00', 6, 0, 0, 'Memp', 0, '1');
INSERT INTO public.order_master VALUES (109, 'SPK-003-2022-00000004', '2022-12-03', 4, 1, '2022-12-03 16:35:48', 111000, 11000, 0, 0, NULL, 'Cash', 0, NULL, NULL, '2022-12-03 16:35:48', NULL, '2022-12-03 16:45:00', 11, 0, 0, 'UMUM', 0, '1');
INSERT INTO public.order_master VALUES (108, 'SPK-002-2022-00000006', '2022-12-03', 17, 1, '2022-12-03 16:02:09', 66600, 6600, 66600, 0, NULL, 'Cash', 67000, NULL, NULL, '2022-12-11 11:05:58', NULL, '2022-12-03 15:30:00', 1, 1, 0, 'Memp', 0, '2');


--
-- TOC entry 3936 (class 0 OID 16518)
-- Dependencies: 238
-- Data for Name: password_resets; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3937 (class 0 OID 16523)
-- Dependencies: 239
-- Data for Name: period; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.period VALUES (202201, 'January -2022', '2022-01-01', '2022-01-31');
INSERT INTO public.period VALUES (202202, 'February-2022', '2022-02-01', '2022-02-28');
INSERT INTO public.period VALUES (202203, 'March -2022', '2022-03-01', '2022-03-31');
INSERT INTO public.period VALUES (202204, 'April -2022', '2022-04-01', '2022-04-30');
INSERT INTO public.period VALUES (202205, 'May -2022', '2022-05-01', '2022-05-31');
INSERT INTO public.period VALUES (202206, 'June-2022', '2022-06-01', '2022-06-30');
INSERT INTO public.period VALUES (202207, 'July-2022', '2022-07-01', '2022-07-31');
INSERT INTO public.period VALUES (202208, 'August-2022', '2022-08-01', '2022-08-31');
INSERT INTO public.period VALUES (202209, 'September -2022', '2022-09-01', '2022-09-30');
INSERT INTO public.period VALUES (202210, 'October -2022', '2022-10-01', '2022-10-31');
INSERT INTO public.period VALUES (202211, 'November-2022', '2022-11-01', '2022-11-30');
INSERT INTO public.period VALUES (202212, 'December-2022', '2022-12-01', '2022-12-31');
INSERT INTO public.period VALUES (202301, 'January -2023', '2023-01-01', '2023-01-31');
INSERT INTO public.period VALUES (202302, 'February-2023', '2023-02-01', '2023-02-28');
INSERT INTO public.period VALUES (202303, 'March -2023', '2023-03-01', '2023-03-31');
INSERT INTO public.period VALUES (202304, 'April -2023', '2023-04-01', '2023-04-30');
INSERT INTO public.period VALUES (202305, 'May -2023', '2023-05-01', '2023-05-31');
INSERT INTO public.period VALUES (202306, 'June-2023', '2023-06-01', '2023-06-30');
INSERT INTO public.period VALUES (202307, 'July-2023', '2023-07-01', '2023-07-31');
INSERT INTO public.period VALUES (202308, 'August-2023', '2023-08-01', '2023-08-31');
INSERT INTO public.period VALUES (202309, 'September -2023', '2023-09-01', '2023-09-30');
INSERT INTO public.period VALUES (202310, 'October -2023', '2023-10-01', '2023-10-31');
INSERT INTO public.period VALUES (202311, 'November-2023', '2023-11-01', '2023-11-30');
INSERT INTO public.period VALUES (202312, 'December-2023', '2023-12-01', '2023-12-01');


--
-- TOC entry 3997 (class 0 OID 17074)
-- Dependencies: 299
-- Data for Name: period_price_sell; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.period_price_sell VALUES (12, 202211, 8, 149000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (13, 202211, 8, 149000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (14, 202211, 9, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (15, 202211, 9, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (16, 202211, 10, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (17, 202211, 10, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (18, 202211, 11, 24000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (19, 202211, 11, 24000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (20, 202211, 12, 64000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (21, 202211, 12, 64000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (22, 202211, 13, 39000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (23, 202211, 13, 39000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (24, 202211, 14, 34000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (25, 202211, 14, 34000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (26, 202211, 15, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (27, 202211, 16, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (28, 202211, 16, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (29, 202211, 17, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (30, 202211, 17, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (31, 202211, 18, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (32, 202211, 18, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (33, 202211, 19, 174000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (34, 202211, 19, 174000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (35, 202211, 20, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (36, 202211, 20, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (37, 202211, 21, 149000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (443, 202212, 1, 149000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (39, 202211, 22, 124000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (40, 202211, 22, 124000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (41, 202211, 23, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (42, 202211, 23, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (43, 202211, 24, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (44, 202211, 24, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (45, 202211, 25, 24000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (46, 202211, 26, 249000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (47, 202211, 26, 249000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (48, 202211, 27, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (49, 202211, 27, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (50, 202211, 28, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (51, 202211, 28, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (52, 202211, 29, 499000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (53, 202211, 29, 499000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (54, 202211, 30, 24000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (55, 202211, 30, 24000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (56, 202211, 31, 199000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (57, 202211, 31, 199000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (58, 202211, 32, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (59, 202211, 32, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (60, 202211, 33, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (61, 202211, 33, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (62, 202211, 34, 39000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (63, 202211, 35, 4000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (64, 202211, 35, 4000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (65, 202211, 36, 4000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (66, 202211, 36, 4000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (67, 202211, 37, 4000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (68, 202211, 37, 4000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (69, 202211, 39, 159000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (70, 202211, 39, 159000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (71, 202211, 40, 159000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (72, 202211, 40, 159000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (73, 202211, 41, 159000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (74, 202211, 41, 159000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (75, 202211, 42, 134000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (76, 202211, 43, 134000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (77, 202211, 44, 134000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (78, 202211, 45, 134000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (79, 202211, 46, 134000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (80, 202211, 47, 109000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (81, 202211, 49, 159000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (82, 202211, 50, 109000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (83, 202211, 51, 79000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (84, 202211, 52, 69000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (85, 202211, 53, 299000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (86, 202211, 54, 159000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (87, 202211, 55, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (88, 202211, 56, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (89, 202211, 57, 64000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (90, 202211, 58, 324000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (91, 202211, 59, 184000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (92, 202211, 60, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (93, 202211, 61, 79000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (94, 202211, 62, 74000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (95, 202211, 63, 69000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (96, 202211, 65, 69000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (97, 202211, 64, 74000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (98, 202211, 67, 69000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (99, 202211, 66, 69000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (100, 202211, 1, 149000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (101, 202211, 1, 149000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (102, 202211, 2, 19000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (103, 202211, 3, 249000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (104, 202211, 4, 174000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (105, 202211, 5, 174000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (106, 202211, 6, 39000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (107, 202211, 6, 39000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (108, 202211, 7, 149000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (109, 202211, 8, 149000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (110, 202211, 9, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (111, 202211, 10, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (112, 202211, 11, 24000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (113, 202211, 12, 64000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (114, 202211, 13, 39000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (115, 202211, 14, 34000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (116, 202211, 15, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (117, 202211, 15, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (118, 202211, 16, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (119, 202211, 17, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (120, 202211, 18, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (121, 202211, 19, 174000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (122, 202211, 20, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (123, 202211, 21, 149000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (124, 202211, 22, 124000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (125, 202211, 23, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (126, 202211, 24, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (127, 202211, 25, 24000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (128, 202211, 25, 24000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (129, 202211, 26, 249000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (130, 202211, 27, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (131, 202211, 28, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (132, 202211, 29, 499000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (133, 202211, 30, 24000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (134, 202211, 31, 199000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (135, 202211, 32, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (136, 202211, 33, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (137, 202211, 34, 39000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (138, 202211, 34, 39000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (139, 202211, 35, 4000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (140, 202211, 36, 4000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (141, 202211, 37, 4000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (142, 202211, 39, 159000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (143, 202211, 40, 159000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (144, 202211, 41, 159000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (145, 202211, 42, 134000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (146, 202211, 42, 134000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (147, 202211, 43, 134000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (148, 202211, 43, 134000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (149, 202211, 44, 134000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (150, 202211, 44, 134000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (151, 202211, 45, 134000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (152, 202211, 45, 134000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (153, 202211, 46, 134000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (154, 202211, 46, 134000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (155, 202211, 47, 109000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (156, 202211, 47, 109000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (157, 202211, 48, 109000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (158, 202211, 48, 109000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (159, 202211, 48, 109000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (160, 202211, 49, 159000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (161, 202211, 49, 159000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (162, 202211, 50, 109000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (163, 202211, 50, 109000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (164, 202211, 51, 79000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (165, 202211, 51, 79000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (166, 202211, 52, 69000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (167, 202211, 52, 69000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (168, 202211, 53, 299000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (169, 202211, 53, 299000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (170, 202211, 54, 159000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (171, 202211, 54, 159000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (172, 202211, 55, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (173, 202211, 55, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (174, 202211, 56, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (175, 202211, 56, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (176, 202211, 57, 64000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (177, 202211, 57, 64000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (178, 202211, 58, 324000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (179, 202211, 58, 324000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (180, 202211, 59, 184000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (181, 202211, 59, 184000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (182, 202211, 60, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (183, 202211, 60, 99000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (184, 202211, 61, 79000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (185, 202211, 62, 74000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (186, 202211, 62, 74000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (187, 202211, 63, 69000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (188, 202211, 63, 69000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (189, 202211, 61, 79000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (190, 202211, 64, 74000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (191, 202211, 65, 69000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (192, 202211, 65, 69000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (193, 202211, 66, 69000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (194, 202211, 64, 74000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (195, 202211, 68, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (196, 202211, 68, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (197, 202211, 68, 49000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (198, 202211, 69, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (199, 202211, 67, 69000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (200, 202211, 66, 69000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (201, 202211, 69, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (202, 202211, 69, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (203, 202211, 70, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (204, 202211, 70, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (205, 202211, 70, 59000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (38, 202211, 21, 149000.00, '2022-11-26 15:35:45', NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (206, 202211, 67, 69000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (207, 202211, 83, 9000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (208, 202211, 83, 9000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (209, 202211, 83, 9000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (210, 202211, 84, 19000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (211, 202211, 84, 19000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (212, 202211, 84, 19000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (213, 202211, 86, 19000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (214, 202211, 86, 19000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (215, 202211, 86, 19000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (216, 202211, 85, 9000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (217, 202211, 85, 9000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (218, 202211, 85, 9000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (219, 202211, 89, 9000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (220, 202211, 89, 0.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (221, 202211, 89, 9000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 3);
INSERT INTO public.period_price_sell VALUES (444, 202212, 2, 19000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (445, 202212, 3, 249000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (446, 202212, 3, 249000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (447, 202212, 4, 174000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (448, 202212, 4, 174000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (449, 202212, 5, 174000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (450, 202212, 5, 174000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (451, 202212, 6, 39000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (452, 202212, 7, 149000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (453, 202212, 7, 149000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (454, 202212, 8, 149000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (455, 202212, 8, 149000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (456, 202212, 9, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (457, 202212, 9, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (458, 202212, 10, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (459, 202212, 10, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (460, 202212, 11, 24000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (461, 202212, 11, 24000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (462, 202212, 12, 64000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (463, 202212, 12, 64000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (464, 202212, 13, 39000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (465, 202212, 13, 39000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (466, 202212, 14, 34000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (467, 202212, 14, 34000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (468, 202212, 15, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (469, 202212, 16, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (470, 202212, 16, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (471, 202212, 17, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (472, 202212, 17, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (473, 202212, 18, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (474, 202212, 18, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (475, 202212, 19, 174000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (476, 202212, 19, 174000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (477, 202212, 20, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (478, 202212, 20, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (479, 202212, 21, 149000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (480, 202212, 22, 124000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (481, 202212, 22, 124000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (482, 202212, 23, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (483, 202212, 23, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (484, 202212, 24, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (485, 202212, 24, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (486, 202212, 25, 24000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (487, 202212, 26, 249000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (488, 202212, 26, 249000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (489, 202212, 27, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (490, 202212, 27, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (491, 202212, 28, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (492, 202212, 28, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (493, 202212, 29, 499000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (494, 202212, 29, 499000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (495, 202212, 30, 24000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (496, 202212, 30, 24000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (497, 202212, 31, 199000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (498, 202212, 31, 199000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (499, 202212, 32, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (500, 202212, 32, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (501, 202212, 33, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (502, 202212, 33, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (503, 202212, 34, 39000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (504, 202212, 35, 4000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (505, 202212, 35, 4000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (506, 202212, 36, 4000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (507, 202212, 36, 4000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (508, 202212, 37, 4000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (509, 202212, 37, 4000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (510, 202212, 39, 159000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (511, 202212, 39, 159000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (512, 202212, 40, 159000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (513, 202212, 40, 159000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (514, 202212, 41, 159000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (515, 202212, 41, 159000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (516, 202212, 42, 134000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (517, 202212, 43, 134000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (518, 202212, 44, 134000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (519, 202212, 45, 134000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (520, 202212, 46, 134000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (521, 202212, 47, 109000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (522, 202212, 49, 159000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (523, 202212, 50, 109000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (524, 202212, 51, 79000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (525, 202212, 52, 69000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (526, 202212, 53, 299000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (527, 202212, 54, 159000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (528, 202212, 55, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (529, 202212, 56, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (530, 202212, 57, 64000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (531, 202212, 58, 324000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (532, 202212, 59, 184000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (533, 202212, 60, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (534, 202212, 61, 79000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (535, 202212, 62, 74000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (536, 202212, 63, 69000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (537, 202212, 65, 69000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (538, 202212, 64, 74000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (539, 202212, 67, 69000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (540, 202212, 66, 69000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (541, 202212, 1, 149000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (542, 202212, 1, 149000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (543, 202212, 2, 19000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (544, 202212, 3, 249000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (545, 202212, 4, 174000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (546, 202212, 5, 174000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (547, 202212, 6, 39000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (548, 202212, 6, 39000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (549, 202212, 7, 149000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (550, 202212, 8, 149000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (551, 202212, 9, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (552, 202212, 10, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (553, 202212, 11, 24000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (554, 202212, 12, 64000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (555, 202212, 13, 39000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (556, 202212, 14, 34000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (557, 202212, 15, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (558, 202212, 15, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (559, 202212, 16, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (560, 202212, 17, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (561, 202212, 18, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (562, 202212, 19, 174000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (563, 202212, 20, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (564, 202212, 21, 149000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (565, 202212, 22, 124000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (566, 202212, 23, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (567, 202212, 24, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (568, 202212, 25, 24000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (569, 202212, 25, 24000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (570, 202212, 26, 249000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (571, 202212, 27, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (572, 202212, 28, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (573, 202212, 29, 499000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (574, 202212, 30, 24000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (575, 202212, 31, 199000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (576, 202212, 32, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (577, 202212, 33, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (578, 202212, 34, 39000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (579, 202212, 34, 39000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (580, 202212, 35, 4000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (581, 202212, 36, 4000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (582, 202212, 37, 4000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (583, 202212, 39, 159000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (584, 202212, 40, 159000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (585, 202212, 41, 159000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (586, 202212, 42, 134000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (587, 202212, 42, 134000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (588, 202212, 43, 134000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (589, 202212, 43, 134000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (590, 202212, 44, 134000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (591, 202212, 44, 134000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (592, 202212, 45, 134000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (593, 202212, 45, 134000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (594, 202212, 46, 134000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (595, 202212, 46, 134000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (596, 202212, 47, 109000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (597, 202212, 47, 109000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (630, 202212, 61, 79000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (631, 202212, 64, 74000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (632, 202212, 65, 69000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (633, 202212, 65, 69000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (634, 202212, 66, 69000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (635, 202212, 64, 74000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (636, 202212, 68, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (637, 202212, 68, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (638, 202212, 68, 49000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (639, 202212, 69, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (640, 202212, 67, 69000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (641, 202212, 66, 69000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (642, 202212, 69, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (643, 202212, 69, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (644, 202212, 70, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (645, 202212, 70, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (646, 202212, 70, 59000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (647, 202212, 67, 69000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (648, 202212, 83, 9000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (649, 202212, 83, 9000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (650, 202212, 83, 9000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (651, 202212, 84, 19000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (663, 202212, 21, 149000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (1, 202211, 1, 149000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (2, 202211, 2, 19000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (3, 202211, 3, 249000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (4, 202211, 3, 249000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (5, 202211, 4, 174000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (6, 202211, 4, 174000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (7, 202211, 5, 174000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (8, 202211, 5, 174000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (9, 202211, 6, 39000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (10, 202211, 7, 149000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (11, 202211, 7, 149000.00, NULL, NULL, 1, '2022-11-26 14:19:07.145434', 2);
INSERT INTO public.period_price_sell VALUES (598, 202212, 48, 109000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (599, 202212, 48, 109000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (600, 202212, 48, 109000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (601, 202212, 49, 159000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (602, 202212, 49, 159000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (603, 202212, 50, 109000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (604, 202212, 50, 109000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (605, 202212, 51, 79000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (606, 202212, 51, 79000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (607, 202212, 52, 69000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (608, 202212, 52, 69000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (609, 202212, 53, 299000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (610, 202212, 53, 299000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (611, 202212, 54, 159000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (612, 202212, 54, 159000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (613, 202212, 55, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (614, 202212, 55, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (615, 202212, 56, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (616, 202212, 56, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (617, 202212, 57, 64000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (618, 202212, 57, 64000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (619, 202212, 58, 324000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (620, 202212, 58, 324000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (621, 202212, 59, 184000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (622, 202212, 59, 184000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (623, 202212, 60, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (624, 202212, 60, 99000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (625, 202212, 61, 79000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (626, 202212, 62, 74000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (627, 202212, 62, 74000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (628, 202212, 63, 69000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (629, 202212, 63, 69000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (652, 202212, 84, 19000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (653, 202212, 84, 19000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (654, 202212, 86, 19000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (655, 202212, 86, 19000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (656, 202212, 86, 19000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (657, 202212, 85, 9000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (658, 202212, 85, 9000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (659, 202212, 85, 9000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);
INSERT INTO public.period_price_sell VALUES (660, 202212, 89, 9000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (661, 202212, 89, 0.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 2);
INSERT INTO public.period_price_sell VALUES (662, 202212, 89, 9000.00, NULL, NULL, 1, '2022-12-03 17:10:01.508925', 3);


--
-- TOC entry 3938 (class 0 OID 16528)
-- Dependencies: 240
-- Data for Name: period_stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.period_stock VALUES (202208, 1, 1, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 8, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 9, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 10, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 11, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 12, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 13, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 18, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 19, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 20, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 21, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 24, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 28, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 29, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 30, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 31, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 33, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 34, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 2, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 3, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 4, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 5, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 32, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 6, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 22, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 7, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 14, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 15, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 16, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 23, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 35, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 36, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 37, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 25, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 26, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 17, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 39, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 40, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 41, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 42, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 43, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 44, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 45, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 46, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 47, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 48, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 49, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 50, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 51, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 52, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 53, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 54, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 55, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 56, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 57, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 58, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 59, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 60, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 61, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 62, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 63, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 64, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 65, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 66, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 67, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 68, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 70, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 69, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 76, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 1, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 8, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 9, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 10, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 11, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 12, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 13, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 18, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 19, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 20, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 21, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 24, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 27, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 28, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 29, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 30, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 31, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 33, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 34, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 2, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 3, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 4, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 5, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 32, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 6, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 22, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 7, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 14, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 15, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 16, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 23, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 35, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 36, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 37, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 25, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 26, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 17, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 39, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 40, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 41, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 42, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 43, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 44, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 45, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 46, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 47, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 48, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 49, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 50, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 51, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 52, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 53, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 54, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 55, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 56, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 57, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 58, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 59, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 60, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 61, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 62, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 63, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 64, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 65, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 66, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 67, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 68, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 70, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 69, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 2, 76, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 1, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 8, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 9, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 10, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 11, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 12, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 13, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 18, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 19, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 20, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 21, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 24, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 27, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 28, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 29, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 30, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 31, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 33, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 34, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 2, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 3, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 4, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 5, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 32, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 6, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 22, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 7, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 14, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 15, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 16, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 23, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 35, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 36, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 37, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 25, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 26, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 17, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 39, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 40, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 41, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 42, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 43, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 44, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 45, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 46, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 47, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 48, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 49, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 50, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 51, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 52, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 53, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 54, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 55, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 56, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 57, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 58, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 59, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 60, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 61, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 62, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 63, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 64, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 65, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 66, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 67, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 68, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 70, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 69, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 3, 76, 9999, 9999, 0, 0, NULL, 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202208, 1, 27, 9999, 10108, 109, 0, '2022-08-20 17:04:38.391888', 1, '2022-08-20 16:59:20.889677');
INSERT INTO public.period_stock VALUES (202209, 1, 1, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 8, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 9, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 10, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 11, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 12, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 13, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 18, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 19, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 20, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 21, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 24, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 28, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 29, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 30, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 31, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 33, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 34, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 2, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 3, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 4, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 5, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 32, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 6, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 22, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 7, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 14, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 15, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 16, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 23, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 35, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 36, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 37, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 25, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 26, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 17, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 39, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 40, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 41, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 42, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 43, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 44, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 45, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 46, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 47, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 48, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 49, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 50, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 51, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 52, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 53, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 54, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 55, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 56, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 57, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 58, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 59, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 60, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 61, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 62, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 63, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 64, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 65, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 66, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 67, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 68, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 70, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 69, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 76, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 1, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 8, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 9, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 10, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 11, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 12, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 13, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 18, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 19, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 20, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 21, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 24, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 27, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 28, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 29, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 30, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 31, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 33, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 34, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 2, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 3, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 4, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 5, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 32, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 6, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 22, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 7, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 14, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 15, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 16, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 23, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 35, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 36, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 37, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 25, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 26, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 17, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 39, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 40, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 41, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 42, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 43, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 44, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 45, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 46, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 47, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 48, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 49, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 50, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 51, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 52, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 53, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 54, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 55, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 56, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 57, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 58, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 59, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 60, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 61, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 62, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 63, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 64, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 65, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 66, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 67, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 68, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 70, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 69, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 2, 76, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 1, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 8, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 9, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 10, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 11, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 12, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 13, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 18, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 19, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 20, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 21, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 24, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 27, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 28, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 29, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 30, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 31, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 33, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 34, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 2, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 3, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 4, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 5, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 32, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 6, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 22, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 7, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 14, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 15, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 16, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 23, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 35, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 36, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 37, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 25, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 26, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 17, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 39, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 40, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 41, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 42, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 43, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 44, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 45, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 46, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 47, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 48, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 49, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 50, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 51, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 52, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 53, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 54, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 55, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 56, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 57, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 58, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 59, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 60, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 61, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 62, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 63, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 64, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 65, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 66, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 67, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 68, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 70, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 69, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 3, 76, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202209, 1, 27, 9999, 10108, 109, 0, NULL, 1, '2022-10-09 09:48:47.563836');
INSERT INTO public.period_stock VALUES (202210, 1, 1, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 8, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 9, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 11, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 12, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 13, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 18, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 19, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 20, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 21, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 24, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 28, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 29, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 30, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 31, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 33, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 34, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 2, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 3, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 4, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 5, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 32, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 6, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 22, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 7, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 14, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 15, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 16, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 23, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 35, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 36, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 37, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 25, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 26, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 17, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 39, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 40, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 41, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 42, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 43, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 44, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 45, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 46, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 47, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 48, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 49, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 50, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 51, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 52, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 53, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 54, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 55, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 56, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 57, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 58, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 59, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 60, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 61, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 62, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 63, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 64, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 65, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 66, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 67, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 68, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 70, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 69, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 76, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 1, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 8, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 9, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 10, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 12, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 13, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 18, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 19, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 20, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 21, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 24, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 27, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 28, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 29, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 30, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 31, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 33, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 34, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 2, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 3, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 4, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 32, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 6, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 22, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 14, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 15, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 16, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 36, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 37, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 25, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 26, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 17, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 39, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 40, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 41, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 42, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 45, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 43, 9999, 9997, 0, 2, '2022-10-09 15:27:43.985868', 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 44, 9999, 9997, 0, 2, '2022-10-29 17:07:50.576813', 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 11, 9999, 9998, 0, 1, '2022-10-09 15:27:43.995219', 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 35, 9999, 9998, 0, 1, '2022-10-15 20:13:34.401883', 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 5, 9999, 9998, 0, 1, '2022-10-29 17:09:02.626411', 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 7, 9999, 9997, 0, 2, '2022-10-23 19:21:43.996324', 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 49, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 50, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 51, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 52, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 53, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 54, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 55, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 56, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 57, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 58, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 59, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 60, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 61, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 62, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 63, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 64, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 65, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 66, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 67, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 68, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 70, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 69, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 76, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 1, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 8, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 9, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 10, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 11, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 12, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 13, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 18, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 19, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 20, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 21, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 24, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 27, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 28, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 29, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 30, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 31, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 33, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 34, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 2, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 3, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 4, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 5, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 32, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 6, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 22, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 7, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 14, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 15, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 16, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 23, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 35, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 36, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 37, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 25, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 26, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 17, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 39, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 40, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 41, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 42, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 43, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 47, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 49, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 50, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 51, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 52, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 53, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 54, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 55, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 56, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 57, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 58, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 59, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 60, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 61, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 62, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 63, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 64, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 65, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 66, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 67, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 68, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 70, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 69, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 76, 9999, 9999, 0, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 27, 9999, 10108, 109, 0, NULL, 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 46, 9999, 9998, 0, 1, '2022-10-09 15:28:42.279891', 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 48, 9999, 9989, 0, 10, '2022-10-23 19:43:08.063975', 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 45, 9999, 9998, 0, 1, '2022-10-09 15:28:42.283651', 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 1, 10, 9999, 10000, 1, 0, '2022-10-23 05:17:47.57105', 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 47, 9999, 9995, 0, 4, '2022-10-29 17:09:02.613855', 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 23, 9999, 9998, 0, 1, '2022-10-15 20:09:31.203747', 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 46, 9999, 9995, 0, 4, '2022-10-29 17:07:50.562418', 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 3, 44, 9999, 9991, 0, 8, '2022-10-23 19:43:08.076969', 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202210, 2, 48, 9999, 9990, 0, 9, '2022-10-29 17:07:50.549092', 1, '2022-10-09 09:50:22.725205');
INSERT INTO public.period_stock VALUES (202211, 1, 21, 9999, 10000, 1, 0, '2022-11-26 15:35:45.621519', 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 1, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 8, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 9, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 11, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 12, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 13, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 18, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 19, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 20, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 24, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 28, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 29, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 30, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 31, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 33, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 34, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 2, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 3, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 4, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 5, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 32, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 6, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 22, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 7, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 14, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 15, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 16, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 23, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 35, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 36, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 37, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 25, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 26, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 39, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 40, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 41, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 42, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 43, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 44, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 45, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 46, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 47, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 48, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 49, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 50, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 51, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 52, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 53, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 54, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 55, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 56, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 57, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 58, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 59, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 60, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 61, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 62, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 63, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 64, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 65, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 66, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 67, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 68, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 70, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 69, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 76, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 1, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 8, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 9, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 10, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 12, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 13, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 18, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 19, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 21, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 24, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 27, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 28, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 29, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 30, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 31, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 33, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 34, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 2, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 3, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 4, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 32, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 6, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 22, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 14, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 15, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 16, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 36, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 37, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 25, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 26, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 17, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 39, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 40, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 41, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 42, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 45, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 43, 9999, 9997, 0, 2, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 44, 9999, 9997, 0, 2, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 11, 9999, 9998, 0, 1, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 35, 9999, 9998, 0, 1, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 5, 9999, 9998, 0, 1, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 7, 9999, 9997, 0, 2, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 49, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 50, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 51, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 52, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 53, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 54, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 55, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 17, 9999, 10000, 1, 0, '2022-11-26 15:33:25.883612', 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 56, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 57, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 58, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 59, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 60, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 61, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 62, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 63, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 64, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 65, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 66, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 67, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 68, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 70, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 69, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 76, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 1, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 8, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 9, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 10, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 11, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 12, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 13, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 18, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 19, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 20, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 21, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 24, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 27, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 28, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 29, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 30, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 31, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 33, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 34, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 2, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 3, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 4, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 5, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 32, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 6, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 22, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 7, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 14, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 15, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 16, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 23, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 35, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 36, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 37, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 25, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 26, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 39, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 40, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 41, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 42, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 43, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 47, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 49, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 50, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 51, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 52, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 53, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 54, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 55, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 56, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 57, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 58, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 59, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 60, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 61, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 62, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 63, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 64, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 65, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 66, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 67, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 68, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 70, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 69, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 76, 9999, 9999, 0, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 27, 9999, 10108, 109, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 46, 9999, 9998, 0, 1, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 48, 9999, 9989, 0, 10, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 45, 9999, 9998, 0, 1, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 1, 10, 9999, 10000, 1, 0, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 47, 9999, 9995, 0, 4, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 23, 9999, 9998, 0, 1, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 46, 9999, 9995, 0, 4, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 44, 9999, 9991, 0, 8, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 48, 9999, 9990, 0, 9, NULL, 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 2, 20, 9999, 9998, 0, 1, '2022-11-26 01:15:01.876205', 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202211, 3, 17, 9999, 10000, 1, 0, '2022-11-26 01:26:53.044911', 1, '2022-11-20 15:23:07.457258');
INSERT INTO public.period_stock VALUES (202212, 1, 1, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 8, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 9, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 11, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 12, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 13, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 18, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 19, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 20, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 21, 10000, 10000, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 24, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 28, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 29, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 30, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 31, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 33, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 34, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 2, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 3, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 4, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 5, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 32, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 6, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 22, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 7, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 14, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 15, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 16, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 23, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 35, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 36, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 37, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 25, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 26, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 17, 10000, 10000, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 39, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 40, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 41, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 42, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 43, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 44, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 45, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 46, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 47, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 48, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 49, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 50, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 51, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 52, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 53, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 54, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 55, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 56, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 57, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 58, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 59, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 60, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 61, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 62, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 63, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 64, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 65, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 66, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 67, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 68, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 70, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 69, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 76, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 1, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 8, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 10, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 12, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 13, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 18, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 19, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 21, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 24, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 27, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 29, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 30, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 31, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 33, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 34, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 2, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 3, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 4, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 32, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 6, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 22, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 14, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 15, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 16, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 36, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 37, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 25, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 26, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 17, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 39, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 40, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 41, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 42, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 45, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 43, 9997, 9997, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 44, 9997, 9997, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 35, 9998, 9998, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 5, 9998, 9998, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 7, 9997, 9997, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 49, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 50, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 51, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 52, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 53, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 54, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 55, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 56, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 57, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 58, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 28, 9999, 9998, 0, 1, '2022-12-03 18:46:55.616969', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 9, 9999, 9998, 0, 1, '2022-12-11 11:05:58.571901', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 59, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 60, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 61, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 62, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 63, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 64, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 65, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 66, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 67, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 68, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 70, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 69, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 76, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 1, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 8, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 10, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 11, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 12, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 13, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 18, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 19, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 24, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 27, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 28, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 29, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 30, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 31, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 33, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 34, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 2, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 3, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 4, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 5, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 32, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 6, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 22, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 7, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 14, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 15, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 16, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 23, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 35, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 36, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 37, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 25, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 26, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 17, 10000, 10000, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 39, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 40, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 41, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 42, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 43, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 47, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 49, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 50, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 51, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 52, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 53, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 54, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 55, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 56, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 57, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 58, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 59, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 60, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 61, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 62, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 63, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 64, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 65, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 66, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 67, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 68, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 70, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 69, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 76, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 27, 10108, 10108, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 46, 9998, 9998, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 48, 9989, 9989, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 45, 9998, 9998, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 10, 10000, 10000, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 47, 9995, 9995, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 23, 9998, 9998, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 46, 9995, 9995, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 44, 9991, 9991, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 48, 9990, 9990, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 20, 9998, 9995, 0, 3, '2022-12-03 18:39:17.103005', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 11, 9998, 9997, 0, 1, '2022-12-03 18:46:55.58333', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 20, 9999, 9998, 0, 1, '2022-12-03 20:50:36.686543', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 9, 9999, 9998, 0, 1, '2022-12-03 20:50:36.696737', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 3, 21, 9999, 9998, 0, 1, '2022-12-03 20:50:36.703038', 1, '2022-12-01 08:01:37.55494');


--
-- TOC entry 3939 (class 0 OID 16538)
-- Dependencies: 241
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.permissions VALUES (2, 'logout.perform', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (4, 'users.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (5, 'users.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (6, 'users.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (7, 'users.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (9, 'users.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (11, 'users.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (12, 'users.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (14, 'roles.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (15, 'roles.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (16, 'posts.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (18, 'posts.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (19, 'posts.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (20, 'posts.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (21, 'posts.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (22, 'roles.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (23, 'roles.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (24, 'roles.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (25, 'roles.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (65, 'orders.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (66, 'orders.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (67, 'orders.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (68, 'orders.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (69, 'orders.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (70, 'orders.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (71, 'orders.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (72, 'orders.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (73, 'orders.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (75, 'orders.getproduct', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (76, 'customers.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (77, 'customers.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (78, 'customers.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (26, 'home.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (17, 'posts.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (8, 'posts.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (79, 'customers.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (80, 'customers.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (81, 'customers.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (27, 'branchs.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (28, 'branchs.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (29, 'branchs.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (30, 'branchs.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (32, 'branchs.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (33, 'branchs.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (34, 'branchs.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (35, 'departments.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (36, 'departments.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (37, 'departments.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (38, 'departments.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (40, 'departments.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (41, 'departments.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (42, 'departments.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (43, 'rooms.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (44, 'rooms.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (45, 'rooms.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (46, 'rooms.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (48, 'rooms.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (49, 'rooms.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (50, 'rooms.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (82, 'customers.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (51, 'users.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (52, 'users.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (53, 'branchs.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (54, 'branchs.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (74, 'orders.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/orders', 'SPK', 'Transactions');
INSERT INTO public.permissions VALUES (55, 'products.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (56, 'products.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (57, 'products.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (58, 'products.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (60, 'products.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (61, 'products.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (62, 'products.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (63, 'products.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (64, 'products.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (83, 'customers.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (84, 'customers.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (86, 'orders.getorder', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (87, 'orders.gettimetable', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (90, 'productsprice.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (91, 'productsprice.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (92, 'productsprice.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (93, 'productsprice.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (94, 'productsprice.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (95, 'productsprice.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (96, 'productsprice.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (97, 'productsprice.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (98, 'productsprice.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (99, 'productsbrand.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (100, 'productsbrand.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (101, 'productsbrand.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (102, 'productsbrand.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (103, 'productsbrand.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (104, 'productsbrand.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (105, 'productsstock.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (106, 'productsstock.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (47, 'rooms.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/rooms', 'Ruangan', 'Settings');
INSERT INTO public.permissions VALUES (3, 'users.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/users', 'Pengguna', 'Users');
INSERT INTO public.permissions VALUES (39, 'departments.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/departments', 'Departemen', 'Settings');
INSERT INTO public.permissions VALUES (1, 'roles.index', 'web', '2022-06-05 07:50:24', '2022-06-05 07:50:24', '/roles', 'Aturan', 'Settings');
INSERT INTO public.permissions VALUES (88, 'productsbrand.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productsbrand', 'Merek', 'Products');
INSERT INTO public.permissions VALUES (85, 'customers.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/customers', 'Pelanggan', 'Users');
INSERT INTO public.permissions VALUES (13, 'permissions.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/permissions', 'Hak Akses', 'Settings');
INSERT INTO public.permissions VALUES (107, 'productsstock.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (108, 'productsstock.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (109, 'productsstock.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (110, 'productsstock.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (111, 'productsstock.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (112, 'productsstock.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (113, 'productsstock.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (115, 'invoices.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (116, 'invoices.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (117, 'invoices.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (118, 'invoices.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (119, 'invoices.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (120, 'invoices.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (121, 'invoices.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (122, 'invoices.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (124, 'invoices.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (125, 'invoices.getproduct', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (127, 'invoices.gettimetable', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (126, 'invoices.getinvoice', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (128, 'uoms.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (129, 'uoms.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (130, 'uoms.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (131, 'uoms.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (132, 'uoms.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (133, 'uoms.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (134, 'uoms.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (136, 'categories.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (137, 'categories.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (138, 'categories.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (139, 'categories.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (140, 'categories.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (141, 'categories.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (142, 'categories.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (144, 'types.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (145, 'types.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (146, 'types.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (147, 'types.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (148, 'types.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (149, 'types.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (150, 'types.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (152, 'productsdistribution.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (153, 'productsdistribution.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (154, 'productsdistribution.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (155, 'productsdistribution.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (156, 'productsdistribution.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (157, 'productsdistribution.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (158, 'productsdistribution.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (159, 'productsdistribution.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (160, 'productsdistribution.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (162, 'productspoint.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (163, 'productspoint.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (164, 'productspoint.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (165, 'productspoint.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (166, 'productspoint.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (167, 'productspoint.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (168, 'productspoint.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (169, 'productspoint.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (170, 'productspoint.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (172, 'productscommision.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (173, 'productscommision.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (174, 'productscommision.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (175, 'productscommision.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (176, 'productscommision.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (177, 'productscommision.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (178, 'productscommision.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (179, 'productscommision.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (180, 'productscommision.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (182, 'productscommisionbyyear.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (183, 'productscommisionbyyear.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (184, 'productscommisionbyyear.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (185, 'productscommisionbyyear.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (186, 'productscommisionbyyear.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (187, 'productscommisionbyyear.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (188, 'productscommisionbyyear.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (189, 'productscommisionbyyear.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (190, 'productscommisionbyyear.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (194, 'reports.cashier.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/cashier/search', '', '');
INSERT INTO public.permissions VALUES (195, 'reports.terapist.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/terapist/search', '', '');
INSERT INTO public.permissions VALUES (196, 'customers.storeapi', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (197, 'purchaseorders.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (198, 'purchaseorders.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (199, 'purchaseorders.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (200, 'purchaseorders.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (201, 'purchaseorders.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (123, 'invoices.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/invoices', 'Faktur', 'Transactions');
INSERT INTO public.permissions VALUES (135, 'uoms.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/uoms', 'Satuan', 'Products');
INSERT INTO public.permissions VALUES (143, 'categories.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/categories', 'Kategori', 'Products');
INSERT INTO public.permissions VALUES (151, 'types.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/types', 'Tipe', 'Products');
INSERT INTO public.permissions VALUES (171, 'productspoint.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productspoint', 'Poin Produk', 'Products');
INSERT INTO public.permissions VALUES (181, 'productscommision.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productscommision', 'Produk Komisi', 'Products');
INSERT INTO public.permissions VALUES (192, 'reports.cashier.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/cashier', 'Komisi Kasir', 'Reports');
INSERT INTO public.permissions VALUES (193, 'reports.terapist.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/terapist', 'Komisi Terapis', 'Reports');
INSERT INTO public.permissions VALUES (191, 'productscommisionbyyear.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productscommisionbyyear', 'Produk Komisi Tahun', 'Products');
INSERT INTO public.permissions VALUES (202, 'purchaseorders.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (203, 'purchaseorders.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (204, 'purchaseorders.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (206, 'purchaseorders.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (207, 'purchaseorders.getproduct', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (208, 'purchaseorders.getorder', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (209, 'purchaseorders.getdocdata', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (210, 'receiveorders.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (211, 'receiveorders.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (212, 'receiveorders.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (213, 'receiveorders.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (214, 'receiveorders.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (215, 'receiveorders.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (216, 'receiveorders.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (217, 'receiveorders.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (218, 'receiveorders.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (219, 'receiveorders.getproduct', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (220, 'receiveorders.getorder', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (222, 'receiveorders.getdocdata', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (223, 'users.addtraining', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (224, 'users.deletetraining', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (225, 'users.addexperience', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (226, 'users.deleteexperience', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (227, 'purchaseorders.print', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (228, 'rooms.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (229, 'rooms.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (230, 'company.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (231, 'company.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (233, 'suppliers.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (234, 'suppliers.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (235, 'suppliers.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (236, 'suppliers.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (237, 'suppliers.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (238, 'suppliers.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (239, 'suppliers.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (240, 'suppliers.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (241, 'suppliers.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (243, 'suppliers.storeapi', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (244, 'products.addingredients', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (245, 'products.deleteingredients', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (246, 'shift.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (247, 'shift.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (248, 'shift.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (249, 'shift.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (250, 'shift.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (251, 'shift.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (252, 'shift.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (253, 'shift.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (254, 'shift.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (255, 'shift.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/shift', 'Shift', 'Settings');
INSERT INTO public.permissions VALUES (256, 'shift.storeapi', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (257, 'usersshift.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (258, 'usersshift.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (259, 'usersshift.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (260, 'usersshift.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (261, 'usersshift.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (262, 'usersshift.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (263, 'usersshift.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (264, 'usersshift.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (265, 'usersshift.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (267, 'usersshift.storeapi', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (268, 'productspriceadj.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (269, 'productspriceadj.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (270, 'productspriceadj.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (271, 'productspriceadj.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (272, 'productspriceadj.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (273, 'productspriceadj.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (274, 'productspriceadj.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (275, 'productspriceadj.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (276, 'productspriceadj.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (278, 'voucher.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (279, 'voucher.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (280, 'voucher.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (281, 'voucher.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (282, 'voucher.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (283, 'voucher.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (284, 'voucher.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (285, 'voucher.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (286, 'voucher.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (287, 'voucher.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/voucher', 'Voucher', 'Settings');
INSERT INTO public.permissions VALUES (288, 'receiveorders.print', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (289, 'orders.checkvoucher', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (290, 'orders.print', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (291, 'invoices.print', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (293, 'reports.closeshift.getdata', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (294, 'reports.closeshift.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (296, 'reports.invoice.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (297, 'reports.invoicedetail.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (292, 'reports.closeshift.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/closeshift', 'Serah Terima', 'Reports');
INSERT INTO public.permissions VALUES (221, 'receiveorders.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/receiveorders', 'Penerimaan Barang', 'Transactions');
INSERT INTO public.permissions VALUES (31, 'branchs.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/branchs', 'Cabang', 'Settings');
INSERT INTO public.permissions VALUES (266, 'usersshift.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/usersshift', 'Shift Staff', 'Settings');
INSERT INTO public.permissions VALUES (242, 'suppliers.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/suppliers', 'Vendor', 'Users');
INSERT INTO public.permissions VALUES (277, 'productspriceadj.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productspriceadj', 'Penyesuaian Harga', 'Products');
INSERT INTO public.permissions VALUES (295, 'reports.invoice.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/invoice', 'Faktur', 'Reports');
INSERT INTO public.permissions VALUES (232, 'company.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/company', 'Profil Perusahaan', 'Settings');
INSERT INTO public.permissions VALUES (299, 'reports.purchase.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (301, 'reports.customer.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (303, 'reports.receive.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (305, 'reports.stockmutation.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (307, 'reports.stock.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (309, 'reports.referral.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (310, 'reports.referral.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/referral', 'Referral', 'Reports');
INSERT INTO public.permissions VALUES (312, 'reports.usertracking.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/usertracking/search', '', '');
INSERT INTO public.permissions VALUES (313, 'reports.closeday.getdata', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (314, 'reports.closeday.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (315, 'reports.closeday.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/closeday', 'Closing Harian', 'Reports');
INSERT INTO public.permissions VALUES (316, 'orders.grid', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (317, 'orders.printthermal', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (318, 'invoices.printthermal', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (319, 'returnsell.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (320, 'returnsell.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (321, 'returnsell.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (322, 'returnsell.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (323, 'returnsell.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (324, 'returnsell.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (325, 'returnsell.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (326, 'returnsell.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (328, 'returnsell.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (329, 'returnsell.getproduct', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (330, 'returnsell.gettimetable', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (331, 'returnsell.getinvoice', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (332, 'returnsell.print', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (333, 'returnsell.invoice.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (334, 'returnsell.invoicedetail.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (343, 'productsbrand.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productsbrand', 'Merek', 'Services');
INSERT INTO public.permissions VALUES (337, 'reports.omsetdetail.search', 'web', '2022-12-03 19:35:33', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (338, 'reports.omsetdetail.index', 'web', '2022-12-03 19:35:33', '2022-05-28 14:34:15', '/reports/omsetdetail', 'Omset', 'Reports');
INSERT INTO public.permissions VALUES (339, 'returnsell.getproducts', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (59, 'products.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/products', 'Produk', 'Products');
INSERT INTO public.permissions VALUES (89, 'productsprice.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productsprice', 'Harga', 'Products');
INSERT INTO public.permissions VALUES (114, 'productsstock.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productsstock', 'Stok', 'Products');
INSERT INTO public.permissions VALUES (161, 'productsdistribution.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productsdistribution', 'Distribusi Produk', 'Products');
INSERT INTO public.permissions VALUES (205, 'purchaseorders.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/purchaseorders', 'Pembelian Barang', 'Transactions');
INSERT INTO public.permissions VALUES (298, 'reports.invoicedetail.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/invoicedetail', 'Fatur Detail per Barang', 'Reports');
INSERT INTO public.permissions VALUES (300, 'reports.purchase.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/purchase', 'Pembelian', 'Reports');
INSERT INTO public.permissions VALUES (302, 'reports.customer.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/customer', 'Pelanggan', 'Reports');
INSERT INTO public.permissions VALUES (304, 'reports.receive.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/receive', 'Penerimaan Barang', 'Reports');
INSERT INTO public.permissions VALUES (306, 'reports.stockmutation.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/stockmutation', 'Mutasi Stok', 'Reports');
INSERT INTO public.permissions VALUES (308, 'reports.stock.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/stock', 'Stok Barang', 'Reports');
INSERT INTO public.permissions VALUES (311, 'reports.usertracking.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/usertracking', 'Mutasi Pengguna', 'Reports');
INSERT INTO public.permissions VALUES (327, 'returnsell.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/returnsell', 'Pengembalian', 'Transactions');
INSERT INTO public.permissions VALUES (335, 'returnsell.invoice.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/invoice', 'Pengembalian', 'Reports');
INSERT INTO public.permissions VALUES (336, 'returnsell.invoicedetail.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/returnselldetail', 'Pengembalian Detail per Barang', 'Reports');
INSERT INTO public.permissions VALUES (346, 'productspoint.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productspoint', 'Poin Produk', 'Services');
INSERT INTO public.permissions VALUES (347, 'productscommision.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productscommision', 'Produk Komisi', 'Services');
INSERT INTO public.permissions VALUES (348, 'productscommisionbyyear.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productscommisionbyyear', 'Produk Komisi Tahun', 'Services');
INSERT INTO public.permissions VALUES (349, 'productspriceadj.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productspriceadj', 'Penyesuaian Harga', 'Services');
INSERT INTO public.permissions VALUES (351, 'productsprice.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productsprice', 'Harga', 'Services');
INSERT INTO public.permissions VALUES (352, 'productsstock.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productsstock', 'Stok', 'Services');
INSERT INTO public.permissions VALUES (344, 'uoms.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/uoms', 'Satuan', 'Services');
INSERT INTO public.permissions VALUES (345, 'categories.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/categories', 'Kategori', 'Services');
INSERT INTO public.permissions VALUES (350, 'products.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/products', 'Produk', 'Services');
INSERT INTO public.permissions VALUES (353, 'productsdistribution.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productsdistribution', 'Distribusi Produk', 'Services');


--
-- TOC entry 3941 (class 0 OID 16544)
-- Dependencies: 243
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3943 (class 0 OID 16550)
-- Dependencies: 245
-- Data for Name: point_conversion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.point_conversion VALUES (4, 8000);
INSERT INTO public.point_conversion VALUES (5, 12000);
INSERT INTO public.point_conversion VALUES (6, 17000);
INSERT INTO public.point_conversion VALUES (7, 23000);
INSERT INTO public.point_conversion VALUES (8, 30000);
INSERT INTO public.point_conversion VALUES (1, 1000);


--
-- TOC entry 3944 (class 0 OID 16555)
-- Dependencies: 246
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.posts VALUES (2, 1, '1', '12', '1', '2022-05-28 15:29:26', '2022-05-28 15:29:30');


--
-- TOC entry 3946 (class 0 OID 16561)
-- Dependencies: 248
-- Data for Name: price_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.price_adjustment VALUES (1, 1, 1, '2022-09-01', '2022-09-30', 500, 1, '2022-09-18 01:29:54', '2022-09-17 12:29:14.427409');
INSERT INTO public.price_adjustment VALUES (5, 2, 1, '2022-09-01', '2022-09-30', 500, 1, '2022-09-18 01:29:54', '2022-09-17 12:29:14.427409');
INSERT INTO public.price_adjustment VALUES (6, 3, 1, '2022-09-01', '2022-09-30', 500, 1, '2022-09-18 01:29:54', '2022-09-17 12:29:14.427409');


--
-- TOC entry 3948 (class 0 OID 16567)
-- Dependencies: 250
-- Data for Name: product_brand; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_brand VALUES (1, 'General', '2022-06-01 20:47:29.575876', NULL);
INSERT INTO public.product_brand VALUES (2, 'ACL', '2022-06-01 20:47:29.580415', NULL);
INSERT INTO public.product_brand VALUES (3, 'Bali Alus', '2022-06-01 20:47:29.582037', NULL);
INSERT INTO public.product_brand VALUES (4, 'Green Spa', '2022-06-01 20:47:29.583737', NULL);
INSERT INTO public.product_brand VALUES (5, 'Biokos', '2022-06-01 20:47:29.585597', NULL);
INSERT INTO public.product_brand VALUES (6, 'Ianthe', '2022-06-01 20:47:29.587679', NULL);
INSERT INTO public.product_brand VALUES (8, 'Wardah', '2022-07-21 16:34:24', '2022-07-21 16:40:55');
INSERT INTO public.product_brand VALUES (9, 'Other', '2022-10-09 03:04:25', '2022-10-09 03:04:25');


--
-- TOC entry 3950 (class 0 OID 16574)
-- Dependencies: 252
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_category VALUES (1, 'Treatment Body', '2022-06-01 20:43:14.593652', NULL);
INSERT INTO public.product_category VALUES (2, 'Treatment Face', '2022-06-01 20:43:14.599894', NULL);
INSERT INTO public.product_category VALUES (3, 'Treatment Female', '2022-06-01 20:43:14.60163', NULL);
INSERT INTO public.product_category VALUES (4, 'Treatment Scrub', '2022-06-01 20:43:14.603521', NULL);
INSERT INTO public.product_category VALUES (5, 'Treatment Foot', '2022-06-01 20:43:14.605776', NULL);
INSERT INTO public.product_category VALUES (6, 'Add Ons', '2022-06-01 20:43:14.607895', NULL);
INSERT INTO public.product_category VALUES (7, 'Serum', '2022-06-01 20:43:14.607895', NULL);
INSERT INTO public.product_category VALUES (8, 'Gel', '2022-06-01 20:43:14.607895', NULL);
INSERT INTO public.product_category VALUES (9, 'Cream', '2022-06-01 20:43:14.607895', NULL);
INSERT INTO public.product_category VALUES (10, 'Spray', '2022-06-01 20:43:14.607895', NULL);
INSERT INTO public.product_category VALUES (11, 'Sabun', '2022-06-01 20:43:14.607895', NULL);
INSERT INTO public.product_category VALUES (12, 'Minuman', '2022-06-01 20:43:14.607895', NULL);
INSERT INTO public.product_category VALUES (13, 'Masker', '2022-06-01 20:43:14.607895', NULL);
INSERT INTO public.product_category VALUES (15, 'Extra', '2022-10-09 03:05:29', '2022-10-09 03:05:29');


--
-- TOC entry 3952 (class 0 OID 16581)
-- Dependencies: 254
-- Data for Name: product_commision_by_year; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_commision_by_year VALUES (39, 2, 2, 1, 30000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 2, 2, 1, 30000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 2, 2, 1, 30000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 2, 2, 1, 30000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 2, 2, 5, 30000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 2, 2, 5, 30000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 2, 2, 5, 30000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 2, 2, 5, 30000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 2, 2, 1, 22000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 2, 2, 1, 22000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 2, 2, 1, 22000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 2, 2, 1, 22000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 2, 2, 1, 17000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 2, 2, 1, 17000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 2, 2, 1, 25000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 2, 2, 1, 15000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 2, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 2, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 2, 2, 1, 40000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 2, 2, 1, 20000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 2, 2, 1, 10000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 2, 2, 1, 10000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 2, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 2, 2, 1, 50000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 2, 2, 1, 55000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 2, 2, 1, 15000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 2, 2, 1, 10000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 2, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 2, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 2, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 2, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 2, 2, 1, 10000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 2, 2, 1, 7000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 2, 2, 2, 32000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 2, 2, 3, 34000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 2, 2, 4, 36000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 2, 2, 5, 38000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 2, 2, 2, 32000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 2, 2, 4, 36000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 2, 2, 5, 38000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 2, 2, 2, 32000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 2, 2, 3, 34000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 2, 2, 4, 36000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 2, 2, 5, 38000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 2, 2, 2, 24000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 2, 2, 3, 26000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 2, 2, 4, 28000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 2, 2, 5, 30000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 2, 2, 2, 24000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 2, 2, 3, 26000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 2, 2, 4, 28000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 2, 2, 2, 24000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 2, 2, 4, 28000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 2, 2, 2, 24000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 2, 2, 3, 26000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 2, 2, 4, 28000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 2, 2, 2, 24000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 2, 2, 3, 26000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 2, 2, 4, 28000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 2, 2, 2, 19000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 2, 2, 3, 21000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 2, 2, 4, 23000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 2, 2, 5, 25000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 2, 2, 2, 19000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 2, 2, 3, 21000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 2, 2, 4, 23000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 2, 2, 2, 27000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 2, 2, 3, 29000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 2, 2, 4, 31000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 2, 2, 5, 33000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 2, 2, 2, 17000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 2, 2, 3, 19000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 2, 2, 4, 21000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 2, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 2, 2, 3, 8000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 2, 2, 4, 9000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 2, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 2, 2, 3, 8000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 2, 2, 4, 8000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 2, 2, 2, 42000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 2, 2, 4, 46000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 2, 2, 2, 22000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 2, 2, 3, 24000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 2, 2, 4, 26000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 2, 2, 2, 10000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 2, 2, 3, 12000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 2, 2, 4, 12000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 2, 2, 2, 10000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 2, 2, 3, 12000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 2, 2, 4, 12000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 2, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 2, 2, 3, 9000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 2, 2, 4, 9000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 2, 2, 2, 52000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 2, 2, 4, 56000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 2, 2, 2, 32000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 2, 2, 3, 34000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 2, 2, 4, 36000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 2, 2, 2, 27000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 2, 2, 3, 29000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 2, 2, 4, 31000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 2, 2, 2, 57000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 2, 2, 3, 59000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 2, 2, 4, 61000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 2, 2, 2, 17000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 2, 2, 3, 19000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 2, 2, 4, 21000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 2, 2, 2, 10000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 2, 2, 4, 16000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 2, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 2, 2, 3, 10000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 2, 2, 4, 10000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 2, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 2, 2, 3, 10000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 2, 2, 4, 10000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 2, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 2, 2, 3, 10000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 2, 2, 4, 10000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 2, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 2, 2, 3, 8000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 2, 2, 4, 9000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 2, 2, 2, 7000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 2, 2, 4, 8000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 2, 2, 2, 10000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 2, 2, 3, 10000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 2, 2, 4, 11000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 2, 2, 7, 30000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 2, 2, 7, 42000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 2, 2, 8, 44000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 2, 2, 6, 40000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 2, 2, 7, 42000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 2, 2, 8, 44000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 2, 2, 9, 46000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 2, 2, 6, 40000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 2, 2, 7, 42000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 2, 2, 8, 44000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 2, 2, 9, 46000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 2, 2, 6, 32000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 2, 2, 7, 34000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 2, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 2, 2, 9, 38000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 2, 2, 6, 32000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 2, 2, 7, 34000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 2, 2, 9, 38000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 2, 2, 6, 32000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 2, 2, 7, 34000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 2, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 2, 2, 9, 38000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 2, 2, 6, 32000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 2, 2, 7, 34000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 2, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 2, 2, 9, 38000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 2, 2, 6, 32000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 2, 2, 7, 34000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 2, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 2, 2, 9, 38000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 2, 2, 6, 27000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 2, 2, 8, 31000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 2, 2, 9, 33000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 2, 2, 6, 27000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 2, 2, 7, 29000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 2, 2, 8, 31000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 2, 2, 9, 33000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 2, 2, 6, 34000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 2, 2, 7, 35000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 2, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 2, 2, 9, 37000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 2, 2, 5, 23000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 2, 2, 6, 25000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 2, 2, 7, 27000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 2, 2, 8, 29000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 2, 2, 5, 9000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 2, 2, 6, 9000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 2, 2, 7, 10000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 2, 2, 8, 10000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 2, 2, 9, 10000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 2, 2, 5, 8000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 2, 2, 6, 8000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 2, 2, 7, 8000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 2, 2, 8, 8000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 2, 2, 9, 8000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 2, 2, 5, 48000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 2, 2, 6, 50000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 2, 2, 7, 52000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 2, 2, 8, 54000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 2, 2, 5, 28000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 2, 2, 6, 29000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 2, 2, 8, 31000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 2, 2, 9, 32000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 2, 2, 5, 14000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 2, 2, 6, 14000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 2, 2, 7, 16000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 2, 2, 8, 16000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 2, 2, 9, 18000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 2, 2, 5, 14000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 2, 2, 6, 14000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 2, 2, 7, 16000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 2, 2, 8, 16000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 2, 2, 9, 18000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 2, 2, 6, 10000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 2, 2, 7, 11000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 2, 2, 8, 11000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 2, 2, 9, 12000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 2, 2, 5, 58000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 2, 2, 6, 60000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 2, 2, 7, 62000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 2, 2, 8, 64000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 2, 2, 9, 66000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 2, 2, 5, 38000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 2, 2, 6, 39000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 2, 2, 7, 40000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 2, 2, 8, 41000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 2, 2, 9, 42000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 2, 2, 6, 34000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 2, 2, 7, 35000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 2, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 2, 2, 9, 37000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 2, 2, 5, 63000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 2, 2, 6, 65000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 2, 2, 7, 67000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 2, 2, 8, 69000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 2, 2, 9, 71000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 2, 2, 5, 23000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 2, 2, 6, 25000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 2, 2, 7, 27000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 2, 2, 8, 29000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 2, 2, 5, 18000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 2, 2, 7, 20000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 2, 2, 8, 21000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 2, 2, 5, 12000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 2, 2, 6, 12000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 2, 2, 7, 14000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 2, 2, 8, 14000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 2, 2, 5, 12000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 2, 2, 6, 12000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 2, 2, 7, 14000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 2, 2, 8, 14000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 2, 2, 5, 12000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 2, 2, 6, 12000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 2, 2, 7, 14000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 2, 2, 8, 14000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 2, 2, 6, 9000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 2, 2, 7, 10000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 2, 2, 8, 10000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 2, 2, 5, 8000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 2, 2, 6, 8000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 2, 2, 7, 9000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 2, 2, 8, 9000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 2, 2, 5, 11000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 2, 2, 6, 11000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 2, 2, 7, 12000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 2, 2, 8, 12000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 2, 2, 1, 22000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 2, 2, 1, 25000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 2, 2, 6, 40000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 2, 2, 9, 46000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 2, 2, 10, 48000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 2, 2, 3, 34000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 2, 2, 10, 48000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 2, 2, 10, 48000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 2, 2, 10, 40000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 2, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 2, 2, 10, 40000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 2, 2, 3, 26000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 2, 2, 10, 40000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 2, 2, 10, 40000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 2, 2, 10, 40000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 2, 2, 7, 29000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 2, 2, 10, 35000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 2, 2, 5, 25000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 2, 2, 10, 35000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 2, 2, 10, 38000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 2, 2, 9, 31000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 2, 2, 10, 33000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 2, 2, 10, 11000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 2, 2, 10, 8000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 2, 2, 3, 44000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 2, 2, 9, 56000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 2, 2, 10, 58000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 2, 2, 10, 33000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 2, 2, 10, 18000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 2, 2, 10, 18000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 2, 2, 5, 10000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 2, 2, 10, 12000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 2, 2, 3, 54000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 2, 2, 10, 68000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 2, 2, 10, 43000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 2, 2, 5, 33000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 2, 2, 10, 38000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 2, 2, 10, 73000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 2, 2, 9, 31000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 2, 2, 10, 33000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 2, 2, 3, 14000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 2, 2, 6, 19000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 2, 2, 9, 22000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 2, 2, 10, 23000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 2, 2, 9, 16000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 2, 2, 10, 16000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 2, 2, 9, 16000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 2, 2, 10, 16000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 2, 2, 9, 16000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 2, 2, 10, 16000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 2, 2, 5, 9000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 2, 2, 9, 10000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 2, 2, 10, 11000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 2, 2, 3, 7000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 2, 2, 9, 9000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 2, 2, 10, 10000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 2, 2, 9, 12000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 2, 2, 10, 13000, 1, '2022-06-03 18:51:32.672537', NULL);


--
-- TOC entry 3953 (class 0 OID 16585)
-- Dependencies: 255
-- Data for Name: product_commisions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_commisions VALUES (33, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (34, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (35, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (36, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (37, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (39, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (40, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (41, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (42, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (43, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (44, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (45, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (46, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (47, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (48, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (49, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (50, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (51, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (52, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (53, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (54, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (55, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (56, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (57, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (58, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (59, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (60, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (61, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (62, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (63, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (64, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (65, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (66, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (67, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (68, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (70, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (69, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (1, 2, 0, 0, 25000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (2, 2, 2000, 10000, 12000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (3, 2, 0, 0, 50000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (4, 2, 0, 0, 25000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (5, 2, 0, 0, 25000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (6, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (7, 2, 0, 0, 50000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (8, 2, 0, 0, 30000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (9, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (11, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (14, 2, 0, 0, 5000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (15, 2, 0, 0, 15000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (16, 2, 0, 0, 15000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (17, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (18, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (19, 2, 0, 0, 50000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (20, 2, 0, 0, 20000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (21, 2, 0, 0, 20000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (22, 2, 0, 0, 20000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (23, 2, 0, 0, 15000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (24, 2, 0, 0, 15000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (25, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (26, 2, 0, 0, 25000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (27, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (10, 2, 4000, 16000, 20000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (12, 2, 4000, 16000, 20000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (13, 2, 3000, 12000, 15000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (28, 2, 0, 0, 50000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (29, 2, 0, 0, 30000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (30, 2, 0, 0, 5000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (31, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (32, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (76, 1, 5000, 7000, 6000, '2022-07-28 10:56:18', 1, NULL, '2022-07-28 10:57:53');


--
-- TOC entry 3954 (class 0 OID 16590)
-- Dependencies: 256
-- Data for Name: product_distribution; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_distribution VALUES (1, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (8, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (9, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (10, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (11, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (12, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (13, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (18, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (19, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (20, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (21, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (24, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (27, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (28, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (29, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (30, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (31, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (33, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (34, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (2, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (3, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (4, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (5, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (32, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (6, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (22, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (7, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (14, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (15, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (16, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (23, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (35, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (36, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (37, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (25, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (26, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (17, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (39, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (40, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (41, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (42, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (43, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (44, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (45, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (46, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (47, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (48, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (49, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (50, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (51, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (52, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (53, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (54, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (55, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (56, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (57, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (58, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (59, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (60, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (61, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (62, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (63, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (64, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (65, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (66, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (67, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (68, 1, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (1, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (8, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (9, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (10, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (11, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (12, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (13, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (18, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (19, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (20, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (21, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (24, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (27, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (28, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (29, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (30, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (31, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (33, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (34, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (2, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (3, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (4, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (5, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (32, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (6, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (22, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (7, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (14, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (15, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (16, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (23, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (35, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (36, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (37, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (25, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (26, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (17, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (39, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (40, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (41, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (42, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (43, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (44, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (45, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (46, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (47, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (48, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (49, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (50, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (51, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (52, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (53, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (54, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (55, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (56, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (57, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (58, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (59, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (60, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (61, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (62, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (63, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (64, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (65, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (66, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (67, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (68, 2, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (1, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (8, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (9, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (10, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (11, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (12, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (13, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (18, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (19, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (20, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (21, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (24, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (27, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (28, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (29, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (30, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (31, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (33, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (34, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (2, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (3, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (4, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (5, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (32, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (6, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (22, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (7, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (14, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (15, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (16, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (23, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (35, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (36, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (37, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (25, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (26, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (17, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (39, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (40, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (41, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (42, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (43, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (44, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (45, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (46, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (47, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (48, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (49, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (50, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (51, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (52, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (53, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (54, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (55, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (56, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (57, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (58, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (59, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (60, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (61, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (62, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (63, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (64, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (65, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (66, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (67, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (68, 3, '2022-06-02 21:03:50.006459', NULL, 1);
INSERT INTO public.product_distribution VALUES (83, 1, '2022-10-09 03:15:42', '2022-10-09 03:15:42', 1);
INSERT INTO public.product_distribution VALUES (83, 2, '2022-10-09 03:16:03', '2022-10-09 03:16:03', 1);
INSERT INTO public.product_distribution VALUES (83, 3, '2022-10-09 03:16:12', '2022-10-09 03:16:12', 1);
INSERT INTO public.product_distribution VALUES (86, 1, '2022-10-09 03:16:21', '2022-10-09 03:16:21', 1);
INSERT INTO public.product_distribution VALUES (86, 3, '2022-10-09 03:16:32', '2022-10-09 03:16:32', 1);
INSERT INTO public.product_distribution VALUES (84, 1, '2022-10-09 03:16:43', '2022-10-09 03:16:43', 1);
INSERT INTO public.product_distribution VALUES (84, 3, '2022-10-09 03:16:56', '2022-10-09 03:16:56', 1);
INSERT INTO public.product_distribution VALUES (85, 1, '2022-10-09 03:17:05', '2022-10-09 03:17:05', 1);
INSERT INTO public.product_distribution VALUES (85, 2, '2022-10-09 03:17:15', '2022-10-09 03:17:15', 1);
INSERT INTO public.product_distribution VALUES (85, 3, '2022-10-09 03:17:26', '2022-10-09 03:17:26', 1);
INSERT INTO public.product_distribution VALUES (89, 1, '2022-10-15 20:39:51', '2022-10-15 20:39:51', 1);
INSERT INTO public.product_distribution VALUES (89, 2, '2022-10-15 20:40:02', '2022-10-15 20:40:02', 1);
INSERT INTO public.product_distribution VALUES (89, 3, '2022-10-15 20:40:14', '2022-10-15 20:40:14', 1);


--
-- TOC entry 3955 (class 0 OID 16595)
-- Dependencies: 257
-- Data for Name: product_ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_ingredients VALUES (52, 53, 1, 1, NULL, 1, '2022-09-07 20:23:11.759266');
INSERT INTO public.product_ingredients VALUES (1, 9, 17, 1, '2022-09-07 14:28:25', 1, '2022-09-07 14:28:25');
INSERT INTO public.product_ingredients VALUES (53, 34, 17, 100, '2022-09-07 14:56:43', 1, '2022-09-07 14:56:43');
INSERT INTO public.product_ingredients VALUES (1, 8, 12, 2, '2022-09-18 01:41:45', 1, '2022-09-18 01:41:45');


--
-- TOC entry 3956 (class 0 OID 16600)
-- Dependencies: 258
-- Data for Name: product_point; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_point VALUES (1, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (8, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (9, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (10, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (11, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (12, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (13, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (18, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (19, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (20, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (21, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (24, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (27, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (28, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (29, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (30, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (31, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (33, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (34, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (2, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (3, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (4, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (5, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (32, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (6, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (22, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (7, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (14, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (15, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (16, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (23, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (35, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (36, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (37, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (25, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (26, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (17, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (39, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (40, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (41, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (42, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (43, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (44, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (45, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (46, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (47, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (48, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (49, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (50, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (53, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (54, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (59, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (60, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (61, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (62, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (63, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (1, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (8, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (9, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (10, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (11, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (12, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (13, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (18, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (19, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (20, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (21, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (24, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (27, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (28, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (29, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (30, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (31, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (33, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (34, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (2, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (3, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (4, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (5, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (32, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (6, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (22, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (7, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (14, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (15, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (16, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (23, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (35, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (36, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (37, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (25, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (26, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (17, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (39, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (40, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (41, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (42, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (43, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (44, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (45, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (46, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (47, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (48, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (49, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (50, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (51, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (53, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (54, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (59, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (60, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (61, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (62, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (63, 2, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (1, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (8, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (9, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (10, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (11, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (12, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (13, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (18, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (19, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (20, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (21, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (24, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (27, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (28, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (29, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (30, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (31, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (33, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (34, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (2, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (3, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (4, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (5, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (52, 2, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (55, 2, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (55, 1, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (56, 1, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (56, 2, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (57, 2, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (57, 1, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (58, 2, 2, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (58, 1, 2, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (65, 1, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (65, 2, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (66, 2, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (66, 1, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (67, 2, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (68, 2, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (68, 1, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (64, 2, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (64, 1, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (32, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (6, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (22, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (7, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (14, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (15, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (16, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (23, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (35, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (36, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (37, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (25, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (26, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (17, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (39, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (40, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (41, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (42, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (43, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (44, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (45, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (46, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (47, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (48, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (49, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (50, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (51, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (53, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (54, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (59, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (60, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (61, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (62, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (63, 3, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (51, 1, 1, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (52, 1, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (52, 3, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (55, 3, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (56, 3, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (57, 3, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (58, 3, 2, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (65, 3, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (66, 3, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (67, 1, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (67, 3, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (68, 3, 0, 1, '2022-06-02 21:09:40.977165', NULL);
INSERT INTO public.product_point VALUES (64, 3, 0, 1, '2022-06-02 21:09:40.977165', NULL);


--
-- TOC entry 3957 (class 0 OID 16604)
-- Dependencies: 259
-- Data for Name: product_price; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_price VALUES (1, 150000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (2, 20000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (3, 250000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (3, 250000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (4, 175000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (4, 175000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (5, 175000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (5, 175000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (6, 40000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (7, 150000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (7, 150000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (8, 150000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (8, 150000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (9, 60000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (9, 60000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (10, 60000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (10, 60000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (11, 25000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (11, 25000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (12, 65000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (12, 65000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (13, 40000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (13, 40000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (14, 35000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (14, 35000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (15, 60000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (16, 60000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (16, 60000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (17, 50000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (17, 50000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (18, 50000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (18, 50000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (19, 175000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (19, 175000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (20, 100000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (20, 100000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (21, 150000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (21, 150000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (22, 125000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (22, 125000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (23, 100000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (23, 100000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (24, 100000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (24, 100000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (25, 25000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (26, 250000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (26, 250000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (27, 50000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (27, 50000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (28, 60000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (28, 60000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (29, 500000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (29, 500000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (30, 25000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (30, 25000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (31, 200000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (31, 200000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (32, 50000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (32, 50000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (33, 50000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (33, 50000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (34, 40000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (35, 5000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (35, 5000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (36, 5000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (36, 5000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (37, 5000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (37, 5000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (39, 160000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (39, 160000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (40, 160000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (40, 160000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (41, 160000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (41, 160000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (42, 135000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (43, 135000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (44, 135000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (45, 135000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (46, 135000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (47, 110000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (49, 160000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (50, 110000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (51, 80000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (52, 70000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (53, 300000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (54, 160000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (55, 100000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (56, 100000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (57, 65000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (58, 325000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (59, 185000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (60, 100000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (61, 80000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (62, 75000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (63, 70000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (65, 70000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (64, 75000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (67, 70000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (66, 70000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (1, 150000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (1, 150000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (2, 20000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (3, 250000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (4, 175000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (5, 175000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (6, 40000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (6, 40000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (7, 150000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (8, 150000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (9, 60000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (10, 60000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (11, 25000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (12, 65000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (13, 40000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (14, 35000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (15, 60000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (15, 60000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (16, 60000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (17, 50000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (18, 50000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (19, 175000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (20, 100000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (21, 150000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (22, 125000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (23, 100000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (24, 100000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (25, 25000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (25, 25000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (26, 250000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (27, 50000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (28, 60000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (29, 500000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (30, 25000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (31, 200000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (32, 50000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (33, 50000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (34, 40000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (34, 40000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (35, 5000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (36, 5000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (37, 5000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (39, 160000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (40, 160000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (41, 160000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (42, 135000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (42, 135000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (43, 135000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (43, 135000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (44, 135000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (44, 135000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (45, 135000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (45, 135000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (46, 135000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (46, 135000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (47, 110000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (47, 110000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (48, 110000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (48, 110000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (48, 110000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (49, 160000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (49, 160000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (50, 110000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (50, 110000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (51, 80000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (51, 80000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (52, 70000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (52, 70000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (53, 300000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (53, 300000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (54, 160000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (54, 160000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (55, 100000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (55, 100000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (56, 100000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (56, 100000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (57, 65000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (57, 65000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (58, 325000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (58, 325000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (59, 185000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (59, 185000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (60, 100000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (60, 100000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (61, 80000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (62, 75000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (62, 75000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (63, 70000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (63, 70000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (61, 80000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (64, 75000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (65, 70000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (65, 70000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (66, 70000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (64, 75000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (68, 50000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (68, 50000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (68, 50000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (69, 60000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (67, 70000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (66, 70000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (69, 60000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (69, 60000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (70, 60000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (70, 60000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (70, 60000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (67, 70000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price VALUES (76, 1000, 1, NULL, '2022-07-20 15:24:29', 1, '2022-07-20 15:24:29');
INSERT INTO public.product_price VALUES (83, 10000, 1, NULL, '2022-10-09 03:13:14', 1, '2022-10-09 03:13:14');
INSERT INTO public.product_price VALUES (83, 10000, 2, NULL, '2022-10-09 03:13:24', 1, '2022-10-09 03:13:24');
INSERT INTO public.product_price VALUES (83, 10000, 3, NULL, '2022-10-09 03:13:34', 1, '2022-10-09 03:13:34');
INSERT INTO public.product_price VALUES (84, 20000, 1, NULL, '2022-10-09 03:13:46', 1, '2022-10-09 03:13:46');
INSERT INTO public.product_price VALUES (84, 20000, 2, NULL, '2022-10-09 03:13:57', 1, '2022-10-09 03:13:57');
INSERT INTO public.product_price VALUES (84, 20000, 3, NULL, '2022-10-09 03:14:06', 1, '2022-10-09 03:14:06');
INSERT INTO public.product_price VALUES (86, 20000, 1, NULL, '2022-10-09 03:14:29', 1, '2022-10-09 03:14:29');
INSERT INTO public.product_price VALUES (86, 20000, 2, NULL, '2022-10-09 03:14:39', 1, '2022-10-09 03:14:39');
INSERT INTO public.product_price VALUES (86, 20000, 3, NULL, '2022-10-09 03:14:48', 1, '2022-10-09 03:14:48');
INSERT INTO public.product_price VALUES (85, 10000, 1, NULL, '2022-10-09 03:15:02', 1, '2022-10-09 03:15:02');
INSERT INTO public.product_price VALUES (85, 10000, 2, NULL, '2022-10-09 03:15:14', 1, '2022-10-09 03:15:14');
INSERT INTO public.product_price VALUES (85, 10000, 3, NULL, '2022-10-09 03:15:24', 1, '2022-10-09 03:15:24');
INSERT INTO public.product_price VALUES (89, 10000, 1, NULL, '2022-10-15 20:38:38', 1, '2022-10-15 20:38:38');
INSERT INTO public.product_price VALUES (89, 1000, 2, NULL, '2022-10-15 20:38:50', 1, '2022-10-15 20:38:50');
INSERT INTO public.product_price VALUES (89, 10000, 3, NULL, '2022-10-15 20:39:01', 1, '2022-10-15 20:39:01');


--
-- TOC entry 3958 (class 0 OID 16608)
-- Dependencies: 260
-- Data for Name: product_sku; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_sku VALUES (65, 'Mandi Susu', 'SRVC ADN MND SSU', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (66, 'Body Cop Package', 'SRVC ADN BDY CP', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (67, 'Masker Badan', 'SRVC ADN MSK BDN', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (68, 'Steam Badan', 'SRVC STRM BDN', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (70, 'CELANA KAIN JUMBO', 'G CLN JMB', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (69, 'Extra Time', 'SRVC ADN EXT TME', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (83, 'Extra Charge Midnight 21:00', 'EXT-M21', NULL, NULL, 15, 8, 9, '2022-10-09 03:11:13', NULL, '2022-10-09 03:11:13', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (86, 'Extra Charge Gender', 'EXT-GD', NULL, NULL, 15, 8, 9, '2022-10-09 03:12:42', NULL, '2022-10-09 03:12:42', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (1, 'ACL - ANTISEPTIK GEL', 'ACL AG', NULL, NULL, 8, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (8, 'ACL - MILK BATH', 'ACL MB', NULL, NULL, 8, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (9, 'ACL - PENYEGAR WAJAH ', 'ACL PYGR WJ', NULL, NULL, 8, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (84, 'Extra Charge Midnight 22:00', 'EXT-M22', NULL, NULL, 15, 8, 9, '2022-10-09 03:11:41', NULL, '2022-10-09 03:11:41', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (85, 'Extra Charge Room', 'EXT-RM', NULL, NULL, 15, 8, 9, '2022-10-09 03:12:11', NULL, '2022-10-09 03:12:11', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (89, 'Test Kotak', 'KTK', NULL, NULL, 8, 1, 9, '2022-10-15 20:37:29', NULL, '2022-10-15 20:37:29', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (10, 'BALI ALUS - BODY WITHENING', 'BA BW', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (11, 'BALI ALUS - DUDUS CELUP ', 'BA DC', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (12, 'BALI ALUS - LIGHTENING', 'BA LGHTN', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (13, 'BALI ALUS - LULUR GREENTEA', 'BA LLR GRNT', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (18, 'BALI ALUS - SWETY SLIMM', 'BA SWTY SLM', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (19, 'NELAYAN NUSANTARA BATHSALT VCO RELAX', 'NN BTHSLT VCO', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (20, 'GREEN SPA LULUR BALI ALUS', 'GS LLR BA', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (21, 'BIOKOS - CLEANSER', 'BK CLNSR', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (24, 'BIOKOS - PEELING', 'BK  PLNG', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (27, 'CELANA KAIN STANDAR', 'G CLN STD', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (28, 'HERBAL COMPRESS', 'G HRBL COMPS', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (29, 'KOP BADAN BESAR', 'G KOP BDN L', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (30, 'LILIN EC', 'G LLN EC', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (31, 'TATAKAN WAJAH JELLY', 'G WJH JLLY', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (33, 'KAYU REFLEKSI SEGITIGA', 'G KYU RFL S3', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (34, 'KAYU REFLEKSI BINTANG', 'G KYU RFL STR', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (2, 'ACL - CREAM HANGAT BUNGKUS', 'ACL CH B', NULL, NULL, 9, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (3, 'ACL - CREAM HANGAT BOTOL', 'ACL CH BT', NULL, NULL, 9, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (4, 'ACL - FOOT SPRAY', 'ACL FS', NULL, NULL, 10, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (5, 'ACL - LINEN SPRAY', 'ACL LS', NULL, NULL, 10, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (32, 'PEELING SPRAY', 'G PLLG SPRY', NULL, NULL, 10, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (6, 'ACL - MASSAGE CREAM BUNGAN JEPUN', 'ACL MSG CRM BJ', NULL, NULL, 9, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (22, 'BIOKOS - CREAM MASSAGE ', 'BK CRM MSSG', NULL, NULL, 9, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (7, 'ACL - MASKER BADAN', 'ACL MSK BD', NULL, NULL, 13, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (14, 'BALI ALUS - MASKER ARMPIT', 'BA MSK ARMP', NULL, NULL, 13, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (15, 'BALI ALUS - MASKER PAYUDARA B', 'BA MSK PYDR B', NULL, NULL, 13, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (16, 'BALI ALUS - MASKER PAYUDARA K', 'BA MSK PYDR K', NULL, NULL, 13, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (23, 'BIOKOS - GELK MASK', 'BK GLK MSK', NULL, NULL, 13, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (35, 'THE BANDULAN ', 'BDLN', NULL, NULL, 12, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (36, 'GOLDA', 'GLDA', NULL, NULL, 12, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (37, 'GREAT', 'G GRT', NULL, NULL, 12, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (25, 'IANTHE SERUM VITAMIN C 5 ML', 'IT SRM VIT C 5ML', NULL, NULL, 7, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (26, 'IANTHE SERUM VITAMIN C 100 ML', 'IT SRM VIT C 100ML', NULL, NULL, 7, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (17, 'BALI ALUS - SABUN SIRIH', 'BA SBN SRH', NULL, NULL, 11, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (39, 'Mixing Thai', 'SRVC B MT', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (40, 'Body Herbal Compress ', 'SRVC B BHC', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (41, 'Shiatsu', 'SRVC B SHSU', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (42, 'Dry Massage', 'SRVC B DRY MSG', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (43, 'Tuina', 'SRVC B TNA', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (44, 'Hot Stone', 'SRVC B HOT STN', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (45, 'Full Body Reflexology', 'SRVC B FULL BD RF', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (46, 'Full Body Therapy', 'SRVC B FULL BD TR', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (47, 'Back Massage / Dry', 'SRVC B BCK MSG', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (48, 'Body Cop With Massage', 'SRVC B BCOP MSG', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (49, 'Facial Biokos and Accu Aura With Vitamin', 'SRVC F BKOS AUR', NULL, NULL, 2, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (50, 'Face Refreshing Biokos', 'SRVC F BKOS RFHS', NULL, NULL, 2, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (51, 'Ear Candling', 'SRVC F EAR CDL', NULL, NULL, 2, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (52, 'Accu Aura', 'SRVC F ACC AURA', NULL, NULL, 2, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (53, 'V- Spa', 'SRVC FL VSPA', NULL, NULL, 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (54, 'Breast and Slimming Therapy', 'SRVC FL BRST SLMM TRP', NULL, NULL, 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (55, 'Slimming', 'SRVC FL SLMM', NULL, NULL, 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (56, 'Breast', 'SRVC FL BRST', NULL, NULL, 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (57, 'Ratus With Hand Massage', 'SRVC FL RTS HND MSG', NULL, NULL, 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (58, 'Executive Bali Body Scrub', 'SRVC SC BDY SCRB', NULL, NULL, 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (59, 'Body Bleacing Package', 'SRVC SC BDY  BLCH', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (60, 'Bali Alus Body Scrub', 'SRVC BA BDY SCRB', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (61, 'Lulur Aromatherapy', 'SRVC BA LLR ARMTRY', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (62, 'Foot Reflexology', 'SRVC FT REFKS', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (63, 'Foot Express', 'SRVC FT REFKS EPRS', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (64, 'Herbal Compress', 'SRVC ADN HRBL CMPS', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11, 1, 'goods.png');


--
-- TOC entry 3960 (class 0 OID 16617)
-- Dependencies: 262
-- Data for Name: product_stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_stock VALUES (53, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (55, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (1, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (8, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (9, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (11, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (12, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (13, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (18, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (19, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (20, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (24, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (28, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (29, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (30, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (31, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (33, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (34, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (2, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (3, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (4, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (5, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (32, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (6, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (22, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (7, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (14, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (15, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (16, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (23, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (35, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (36, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (37, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (25, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (26, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (39, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (41, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (42, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (43, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (44, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (45, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (46, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (47, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (48, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (49, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (50, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (51, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (52, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (53, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (54, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (55, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (56, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (57, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (58, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (60, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (61, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (62, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (63, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (64, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (65, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (66, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (67, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (68, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (70, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (69, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (76, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (10, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (12, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (13, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (18, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (19, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (21, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (24, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (27, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (29, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (30, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (31, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (33, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (32, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (22, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (14, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (15, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (16, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (36, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (37, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (25, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (26, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (17, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (39, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (41, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (42, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (62, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (4, 2, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (27, 1, 10108, '2022-08-20 17:04:38.386827', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (8, 2, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (56, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (54, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (61, 2, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (6, 2, 9993, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (60, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (34, 2, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (3, 2, 9995, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (64, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (2, 2, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (65, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (51, 2, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (50, 2, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (48, 2, 9983, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (66, 2, 9995, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (63, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (59, 2, 10002, '2022-09-17 10:24:26.045019', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (40, 2, 10006, '2022-09-17 10:24:26.041486', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (58, 2, 10000, '2022-09-17 10:24:26.047956', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (40, 1, 10000, '2022-09-17 08:40:20.881436', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (43, 2, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (5, 2, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (45, 2, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (44, 2, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (23, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (35, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (10, 1, 10000, '2022-10-23 05:17:47.563971', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (46, 2, 9990, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (7, 2, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (67, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (68, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (70, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (69, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (57, 2, 9995, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (47, 2, 9987, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (21, 1, 10000, '2022-11-26 15:35:45.617375', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (11, 2, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (20, 2, 9994, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (28, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (76, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (1, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (8, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (11, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (18, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (19, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (28, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (29, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (30, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (31, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (33, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (34, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (5, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (32, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (6, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (7, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (14, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (15, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (16, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (23, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (35, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (36, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (37, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (25, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (26, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (39, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (40, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (41, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (42, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (43, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (49, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (50, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (51, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (53, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (54, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (55, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (56, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (57, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (58, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (59, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (60, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (62, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (63, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (64, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (65, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (66, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (67, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (68, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (70, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (69, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (76, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (3, 3, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (12, 3, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (61, 3, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (49, 2, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (52, 2, 9999, '2022-08-20 01:41:24', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (52, 3, 10114, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (4, 3, 10000, '2022-08-20 15:13:26.026441', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (13, 3, 10004, '2022-08-20 15:13:26.028804', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (27, 3, 10000, '2022-08-20 15:13:26.030577', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (24, 3, 10030, '2022-08-20 16:47:12.514929', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (2, 3, 9997, '2022-08-20 16:47:12.522531', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (59, 1, 10005, '2022-09-17 08:40:20.886402', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (47, 3, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (1, 2, 9994, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (46, 3, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (44, 3, 9991, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (10, 3, 9995, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (22, 3, 9995, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (45, 3, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (48, 3, 9988, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (17, 3, 10000, '2022-11-26 01:26:53.038577', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (17, 1, 10000, '2022-11-26 15:33:25.859684', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (20, 3, 9994, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (9, 3, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (21, 3, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (9, 2, 9997, NULL, '2022-07-25 18:26:06.816842', 1);


--
-- TOC entry 3961 (class 0 OID 16622)
-- Dependencies: 263
-- Data for Name: product_stock_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_stock_detail VALUES (1, 24, 3, 1, '2024-08-20', NULL, '2022-08-20 16:47:12.517217', 1);
INSERT INTO public.product_stock_detail VALUES (2, 2, 3, 1, '2024-08-20', NULL, '2022-08-20 16:47:12.524593', 1);
INSERT INTO public.product_stock_detail VALUES (3, 27, 1, 109, '2024-08-20', NULL, '2022-08-20 17:04:38.389528', 1);
INSERT INTO public.product_stock_detail VALUES (4, 59, 2, 1, '2024-09-17', NULL, '2022-09-17 05:09:51.417976', 1);
INSERT INTO public.product_stock_detail VALUES (5, 59, 2, 1, '2024-09-17', NULL, '2022-09-17 05:11:24.298061', 1);
INSERT INTO public.product_stock_detail VALUES (6, 59, 1, 1, '2024-09-17', NULL, '2022-09-17 05:57:02.361339', 1);
INSERT INTO public.product_stock_detail VALUES (7, 59, 1, 1, '2024-09-17', NULL, '2022-09-17 05:59:18.113439', 1);
INSERT INTO public.product_stock_detail VALUES (8, 59, 2, 1, '2024-09-17', NULL, '2022-09-17 06:00:24.352683', 1);
INSERT INTO public.product_stock_detail VALUES (9, 59, 1, 1, '2024-09-17', NULL, '2022-09-17 06:05:50.611678', 1);
INSERT INTO public.product_stock_detail VALUES (10, 59, 2, 1, '2024-09-17', NULL, '2022-09-17 06:07:29.884734', 1);
INSERT INTO public.product_stock_detail VALUES (11, 40, 2, 2, '2024-09-17', NULL, '2022-09-17 06:07:29.889569', 1);
INSERT INTO public.product_stock_detail VALUES (12, 59, 1, 1, '2024-09-17', NULL, '2022-09-17 06:08:55.307898', 1);
INSERT INTO public.product_stock_detail VALUES (13, 40, 2, 1, '2024-09-17', NULL, '2022-09-17 06:11:14.696036', 1);
INSERT INTO public.product_stock_detail VALUES (14, 59, 1, 1, '2024-09-17', NULL, '2022-09-17 06:12:48.258854', 1);
INSERT INTO public.product_stock_detail VALUES (15, 40, 1, 1, '2024-09-17', NULL, '2022-09-17 08:40:20.882859', 1);
INSERT INTO public.product_stock_detail VALUES (16, 59, 1, 1, '2024-09-17', NULL, '2022-09-17 08:40:20.888736', 1);
INSERT INTO public.product_stock_detail VALUES (17, 40, 2, 4, '2024-09-17', NULL, '2022-09-17 10:24:26.042447', 1);
INSERT INTO public.product_stock_detail VALUES (18, 59, 2, 1, '2024-09-17', NULL, '2022-09-17 10:24:26.045884', 1);
INSERT INTO public.product_stock_detail VALUES (19, 58, 2, 1, '2024-09-17', NULL, '2022-09-17 10:24:26.048671', 1);
INSERT INTO public.product_stock_detail VALUES (20, 10, 1, 1, '2024-10-23', NULL, '2022-10-23 05:17:47.566843', 1);
INSERT INTO public.product_stock_detail VALUES (21, 17, 3, 1, '2024-11-26', NULL, '2022-11-26 01:26:53.042067', 1);
INSERT INTO public.product_stock_detail VALUES (22, 17, 1, 1, '2024-11-26', NULL, '2022-11-26 15:33:25.881752', 1);
INSERT INTO public.product_stock_detail VALUES (23, 21, 1, 1, '2024-11-26', NULL, '2022-11-26 15:35:45.619727', 1);


--
-- TOC entry 3963 (class 0 OID 16629)
-- Dependencies: 265
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_type VALUES (3, 'Goods & Services', '2022-06-01 21:02:38.43164', NULL);
INSERT INTO public.product_type VALUES (2, 'Services', '2022-06-01 21:02:38.43164', NULL);
INSERT INTO public.product_type VALUES (1, 'Goods', '2022-06-01 21:02:38.43164', NULL);
INSERT INTO public.product_type VALUES (7, 'Misc', '2022-07-25 14:53:50', '2022-07-25 14:53:50');
INSERT INTO public.product_type VALUES (8, 'Extra', '2022-10-09 03:05:18', '2022-10-09 03:05:18');


--
-- TOC entry 3965 (class 0 OID 16636)
-- Dependencies: 267
-- Data for Name: product_uom; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_uom VALUES (1, 1, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (9, 1, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (21, 1, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (24, 1, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (30, 1, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (3, 1, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (4, 1, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (5, 1, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (35, 1, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (36, 1, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (37, 1, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (26, 1, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (17, 1, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (2, 2, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (6, 2, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (7, 2, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (8, 2, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (19, 2, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (20, 2, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (10, 3, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (12, 3, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (18, 3, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (22, 3, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (23, 3, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (11, 5, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (14, 5, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (13, 4, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (28, 4, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (31, 4, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (32, 4, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (33, 4, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (34, 4, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (15, 6, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (16, 6, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (29, 6, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (25, 7, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (27, 8, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (70, 8, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (39, 9, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (40, 12, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (41, 9, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (42, 9, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (43, 9, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (44, 9, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (45, 9, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (46, 9, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (47, 19, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (48, 19, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (49, 9, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (50, 19, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (51, 11, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (52, 10, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (53, 9, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (54, 19, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (55, 10, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (56, 10, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (57, 16, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (58, 20, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (59, 21, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (60, 19, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (61, 12, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (62, 19, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (63, 11, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (64, 10, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (65, 16, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (66, 16, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (67, 10, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (68, 16, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (69, 10, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (83, 8, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (84, 8, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (85, 8, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (86, 8, '2022-06-03 17:38:00.278845', 1, NULL);
INSERT INTO public.product_uom VALUES (89, 1, '2022-10-15 20:37:29', NULL, '2022-10-15 20:37:29');


--
-- TOC entry 3968 (class 0 OID 16648)
-- Dependencies: 270
-- Data for Name: purchase_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.purchase_detail VALUES ('PO-001-2022-00000012', 59, 'Body Bleacing Package', '100 Menit', 0, 1, 185000, 1000, 11.00, 20240.00, 184000, 204240.00, '2022-09-17 00:06:28', '2022-09-17 00:06:28');
INSERT INTO public.purchase_detail VALUES ('PO-001-2022-00000012', 40, 'Body Herbal Compress', '120 Menit', 1, 1, 160000, 2000, 11.00, 17380.00, 158000, 175380.00, '2022-09-17 00:06:28', '2022-09-17 00:06:28');
INSERT INTO public.purchase_detail VALUES ('PO-001-2022-00000013', 59, 'Body Bleacing Package', '100 Menit', 0, 1, 185000, 0, 11.00, 20350.00, 185000, 205350.00, '2022-10-22 15:53:51', '2022-10-22 15:53:51');
INSERT INTO public.purchase_detail VALUES ('PO-001-2022-00000001', 13, 'BALI ALUS - LULUR GREENTEA', 'Buah', 0, 1, 40000, 0, 11.00, 4400.00, 40000, 44400.00, '2022-11-26 01:26:29', '2022-11-26 01:26:29');


--
-- TOC entry 3969 (class 0 OID 16662)
-- Dependencies: 271
-- Data for Name: purchase_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.purchase_master VALUES (12, 'PO-001-2022-00000012', '2022-09-16', 2, '2 - Test Supplier 02', 1, 'HEAD QUARTER', 379620, 37620, 0, 3000, 'ABC', NULL, 0, '2022-09-17 06:13:16.979111', NULL, NULL, 1, '2022-09-17 00:06:28', 1, '2022-09-16 23:13:16', 0, 0);
INSERT INTO public.purchase_master VALUES (15, 'PO-001-2022-00000013', '2022-10-22', 2, 'Test Supplier 02', 1, 'HEAD QUARTER', 205350, 20350, 0, 0, NULL, NULL, 0, '2022-10-22 15:53:51.479455', NULL, NULL, NULL, '2022-10-22 15:53:51', 1, '2022-10-22 15:53:51', 0, 0);
INSERT INTO public.purchase_master VALUES (17, 'PO-001-2022-00000001', '2022-11-26', 1, 'Test Supplier 010', 1, 'HEAD QUARTER', 44400, 4400, 0, 0, NULL, NULL, 0, '2022-11-26 01:26:29.149969', NULL, NULL, NULL, '2022-11-26 01:26:29', 1, '2022-11-26 01:26:29', 0, 0);


--
-- TOC entry 3971 (class 0 OID 16678)
-- Dependencies: 273
-- Data for Name: receive_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.receive_detail VALUES ('RCV-001-2022-00000001', 17, 'BALI ALUS - SABUN SIRIH', 1, 50000, 50000, 0, 0, '2023-11-26', NULL, '2022-11-26 15:33:25', '2022-11-26 15:33:25', 'Botol', 11);
INSERT INTO public.receive_detail VALUES ('RCV-001-2022-00000002', 21, 'BIOKOS - CLEANSER', 1, 150000, 150000, 0, 0, '2023-11-26', NULL, '2022-11-26 15:35:45', '2022-11-26 15:35:45', 'Botol', 11);


--
-- TOC entry 3972 (class 0 OID 16691)
-- Dependencies: 274
-- Data for Name: receive_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.receive_master VALUES (22, 'RCV-001-2022-00000001', '2022-11-26', 1, '1 - Test Supplier 010', 55500, 5500, 0, 0, NULL, NULL, 0, '2022-11-26 15:33:25.853342', 1, 'HEAD QUARTER', NULL, NULL, NULL, '2022-11-26 15:33:25', 1, '2022-11-26 15:33:25', 0, 0);
INSERT INTO public.receive_master VALUES (23, 'RCV-001-2022-00000002', '2022-11-26', 1, '1 - Test Supplier 010', 166500, 16500, 0, 0, NULL, NULL, 0, '2022-11-26 15:35:45.277264', 1, 'HEAD QUARTER', NULL, NULL, NULL, '2022-11-26 15:35:45', 1, '2022-11-26 15:35:45', 0, 0);


--
-- TOC entry 4000 (class 0 OID 17111)
-- Dependencies: 302
-- Data for Name: return_sell_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3999 (class 0 OID 17080)
-- Dependencies: 301
-- Data for Name: return_sell_master; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3974 (class 0 OID 16707)
-- Dependencies: 276
-- Data for Name: role_has_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.role_has_permissions VALUES (39, 1);
INSERT INTO public.role_has_permissions VALUES (28, 1);
INSERT INTO public.role_has_permissions VALUES (29, 1);
INSERT INTO public.role_has_permissions VALUES (27, 1);
INSERT INTO public.role_has_permissions VALUES (30, 1);
INSERT INTO public.role_has_permissions VALUES (31, 1);
INSERT INTO public.role_has_permissions VALUES (32, 1);
INSERT INTO public.role_has_permissions VALUES (33, 1);
INSERT INTO public.role_has_permissions VALUES (34, 1);
INSERT INTO public.role_has_permissions VALUES (35, 1);
INSERT INTO public.role_has_permissions VALUES (36, 1);
INSERT INTO public.role_has_permissions VALUES (37, 1);
INSERT INTO public.role_has_permissions VALUES (38, 1);
INSERT INTO public.role_has_permissions VALUES (40, 1);
INSERT INTO public.role_has_permissions VALUES (41, 1);
INSERT INTO public.role_has_permissions VALUES (42, 1);
INSERT INTO public.role_has_permissions VALUES (43, 1);
INSERT INTO public.role_has_permissions VALUES (44, 1);
INSERT INTO public.role_has_permissions VALUES (45, 1);
INSERT INTO public.role_has_permissions VALUES (46, 1);
INSERT INTO public.role_has_permissions VALUES (47, 1);
INSERT INTO public.role_has_permissions VALUES (48, 1);
INSERT INTO public.role_has_permissions VALUES (49, 1);
INSERT INTO public.role_has_permissions VALUES (50, 1);
INSERT INTO public.role_has_permissions VALUES (51, 1);
INSERT INTO public.role_has_permissions VALUES (52, 1);
INSERT INTO public.role_has_permissions VALUES (53, 1);
INSERT INTO public.role_has_permissions VALUES (54, 1);
INSERT INTO public.role_has_permissions VALUES (59, 1);
INSERT INTO public.role_has_permissions VALUES (55, 1);
INSERT INTO public.role_has_permissions VALUES (56, 1);
INSERT INTO public.role_has_permissions VALUES (57, 1);
INSERT INTO public.role_has_permissions VALUES (58, 1);
INSERT INTO public.role_has_permissions VALUES (60, 1);
INSERT INTO public.role_has_permissions VALUES (61, 1);
INSERT INTO public.role_has_permissions VALUES (62, 1);
INSERT INTO public.role_has_permissions VALUES (63, 1);
INSERT INTO public.role_has_permissions VALUES (64, 1);
INSERT INTO public.role_has_permissions VALUES (65, 1);
INSERT INTO public.role_has_permissions VALUES (66, 1);
INSERT INTO public.role_has_permissions VALUES (67, 1);
INSERT INTO public.role_has_permissions VALUES (68, 1);
INSERT INTO public.role_has_permissions VALUES (69, 1);
INSERT INTO public.role_has_permissions VALUES (70, 1);
INSERT INTO public.role_has_permissions VALUES (71, 1);
INSERT INTO public.role_has_permissions VALUES (72, 1);
INSERT INTO public.role_has_permissions VALUES (73, 1);
INSERT INTO public.role_has_permissions VALUES (74, 1);
INSERT INTO public.role_has_permissions VALUES (76, 1);
INSERT INTO public.role_has_permissions VALUES (77, 1);
INSERT INTO public.role_has_permissions VALUES (78, 1);
INSERT INTO public.role_has_permissions VALUES (79, 1);
INSERT INTO public.role_has_permissions VALUES (80, 1);
INSERT INTO public.role_has_permissions VALUES (1, 1);
INSERT INTO public.role_has_permissions VALUES (2, 1);
INSERT INTO public.role_has_permissions VALUES (3, 1);
INSERT INTO public.role_has_permissions VALUES (4, 1);
INSERT INTO public.role_has_permissions VALUES (5, 1);
INSERT INTO public.role_has_permissions VALUES (6, 1);
INSERT INTO public.role_has_permissions VALUES (7, 1);
INSERT INTO public.role_has_permissions VALUES (9, 1);
INSERT INTO public.role_has_permissions VALUES (11, 1);
INSERT INTO public.role_has_permissions VALUES (12, 1);
INSERT INTO public.role_has_permissions VALUES (13, 1);
INSERT INTO public.role_has_permissions VALUES (14, 1);
INSERT INTO public.role_has_permissions VALUES (15, 1);
INSERT INTO public.role_has_permissions VALUES (8, 1);
INSERT INTO public.role_has_permissions VALUES (16, 1);
INSERT INTO public.role_has_permissions VALUES (17, 1);
INSERT INTO public.role_has_permissions VALUES (18, 1);
INSERT INTO public.role_has_permissions VALUES (19, 1);
INSERT INTO public.role_has_permissions VALUES (20, 1);
INSERT INTO public.role_has_permissions VALUES (21, 1);
INSERT INTO public.role_has_permissions VALUES (22, 1);
INSERT INTO public.role_has_permissions VALUES (23, 1);
INSERT INTO public.role_has_permissions VALUES (24, 1);
INSERT INTO public.role_has_permissions VALUES (25, 1);
INSERT INTO public.role_has_permissions VALUES (26, 1);
INSERT INTO public.role_has_permissions VALUES (81, 1);
INSERT INTO public.role_has_permissions VALUES (82, 1);
INSERT INTO public.role_has_permissions VALUES (83, 1);
INSERT INTO public.role_has_permissions VALUES (84, 1);
INSERT INTO public.role_has_permissions VALUES (85, 1);
INSERT INTO public.role_has_permissions VALUES (75, 1);
INSERT INTO public.role_has_permissions VALUES (86, 1);
INSERT INTO public.role_has_permissions VALUES (87, 1);
INSERT INTO public.role_has_permissions VALUES (88, 1);
INSERT INTO public.role_has_permissions VALUES (89, 1);
INSERT INTO public.role_has_permissions VALUES (90, 1);
INSERT INTO public.role_has_permissions VALUES (91, 1);
INSERT INTO public.role_has_permissions VALUES (92, 1);
INSERT INTO public.role_has_permissions VALUES (93, 1);
INSERT INTO public.role_has_permissions VALUES (94, 1);
INSERT INTO public.role_has_permissions VALUES (95, 1);
INSERT INTO public.role_has_permissions VALUES (96, 1);
INSERT INTO public.role_has_permissions VALUES (97, 1);
INSERT INTO public.role_has_permissions VALUES (98, 1);
INSERT INTO public.role_has_permissions VALUES (99, 1);
INSERT INTO public.role_has_permissions VALUES (100, 1);
INSERT INTO public.role_has_permissions VALUES (101, 1);
INSERT INTO public.role_has_permissions VALUES (102, 1);
INSERT INTO public.role_has_permissions VALUES (103, 1);
INSERT INTO public.role_has_permissions VALUES (104, 1);
INSERT INTO public.role_has_permissions VALUES (105, 1);
INSERT INTO public.role_has_permissions VALUES (106, 1);
INSERT INTO public.role_has_permissions VALUES (107, 1);
INSERT INTO public.role_has_permissions VALUES (108, 1);
INSERT INTO public.role_has_permissions VALUES (109, 1);
INSERT INTO public.role_has_permissions VALUES (110, 1);
INSERT INTO public.role_has_permissions VALUES (111, 1);
INSERT INTO public.role_has_permissions VALUES (112, 1);
INSERT INTO public.role_has_permissions VALUES (113, 1);
INSERT INTO public.role_has_permissions VALUES (114, 1);
INSERT INTO public.role_has_permissions VALUES (115, 1);
INSERT INTO public.role_has_permissions VALUES (116, 1);
INSERT INTO public.role_has_permissions VALUES (117, 1);
INSERT INTO public.role_has_permissions VALUES (119, 1);
INSERT INTO public.role_has_permissions VALUES (118, 1);
INSERT INTO public.role_has_permissions VALUES (120, 1);
INSERT INTO public.role_has_permissions VALUES (121, 1);
INSERT INTO public.role_has_permissions VALUES (122, 1);
INSERT INTO public.role_has_permissions VALUES (123, 1);
INSERT INTO public.role_has_permissions VALUES (124, 1);
INSERT INTO public.role_has_permissions VALUES (125, 1);
INSERT INTO public.role_has_permissions VALUES (126, 1);
INSERT INTO public.role_has_permissions VALUES (127, 1);
INSERT INTO public.role_has_permissions VALUES (128, 1);
INSERT INTO public.role_has_permissions VALUES (129, 1);
INSERT INTO public.role_has_permissions VALUES (130, 1);
INSERT INTO public.role_has_permissions VALUES (131, 1);
INSERT INTO public.role_has_permissions VALUES (132, 1);
INSERT INTO public.role_has_permissions VALUES (133, 1);
INSERT INTO public.role_has_permissions VALUES (134, 1);
INSERT INTO public.role_has_permissions VALUES (135, 1);
INSERT INTO public.role_has_permissions VALUES (136, 1);
INSERT INTO public.role_has_permissions VALUES (137, 1);
INSERT INTO public.role_has_permissions VALUES (138, 1);
INSERT INTO public.role_has_permissions VALUES (139, 1);
INSERT INTO public.role_has_permissions VALUES (140, 1);
INSERT INTO public.role_has_permissions VALUES (141, 1);
INSERT INTO public.role_has_permissions VALUES (142, 1);
INSERT INTO public.role_has_permissions VALUES (143, 1);
INSERT INTO public.role_has_permissions VALUES (144, 1);
INSERT INTO public.role_has_permissions VALUES (145, 1);
INSERT INTO public.role_has_permissions VALUES (146, 1);
INSERT INTO public.role_has_permissions VALUES (147, 1);
INSERT INTO public.role_has_permissions VALUES (148, 1);
INSERT INTO public.role_has_permissions VALUES (149, 1);
INSERT INTO public.role_has_permissions VALUES (150, 1);
INSERT INTO public.role_has_permissions VALUES (151, 1);
INSERT INTO public.role_has_permissions VALUES (152, 1);
INSERT INTO public.role_has_permissions VALUES (153, 1);
INSERT INTO public.role_has_permissions VALUES (154, 1);
INSERT INTO public.role_has_permissions VALUES (155, 1);
INSERT INTO public.role_has_permissions VALUES (156, 1);
INSERT INTO public.role_has_permissions VALUES (157, 1);
INSERT INTO public.role_has_permissions VALUES (158, 1);
INSERT INTO public.role_has_permissions VALUES (159, 1);
INSERT INTO public.role_has_permissions VALUES (160, 1);
INSERT INTO public.role_has_permissions VALUES (161, 1);
INSERT INTO public.role_has_permissions VALUES (162, 1);
INSERT INTO public.role_has_permissions VALUES (163, 1);
INSERT INTO public.role_has_permissions VALUES (164, 1);
INSERT INTO public.role_has_permissions VALUES (165, 1);
INSERT INTO public.role_has_permissions VALUES (166, 1);
INSERT INTO public.role_has_permissions VALUES (167, 1);
INSERT INTO public.role_has_permissions VALUES (168, 1);
INSERT INTO public.role_has_permissions VALUES (169, 1);
INSERT INTO public.role_has_permissions VALUES (170, 1);
INSERT INTO public.role_has_permissions VALUES (171, 1);
INSERT INTO public.role_has_permissions VALUES (172, 1);
INSERT INTO public.role_has_permissions VALUES (173, 1);
INSERT INTO public.role_has_permissions VALUES (174, 1);
INSERT INTO public.role_has_permissions VALUES (175, 1);
INSERT INTO public.role_has_permissions VALUES (176, 1);
INSERT INTO public.role_has_permissions VALUES (177, 1);
INSERT INTO public.role_has_permissions VALUES (178, 1);
INSERT INTO public.role_has_permissions VALUES (179, 1);
INSERT INTO public.role_has_permissions VALUES (180, 1);
INSERT INTO public.role_has_permissions VALUES (181, 1);
INSERT INTO public.role_has_permissions VALUES (182, 1);
INSERT INTO public.role_has_permissions VALUES (183, 1);
INSERT INTO public.role_has_permissions VALUES (184, 1);
INSERT INTO public.role_has_permissions VALUES (185, 1);
INSERT INTO public.role_has_permissions VALUES (186, 1);
INSERT INTO public.role_has_permissions VALUES (187, 1);
INSERT INTO public.role_has_permissions VALUES (188, 1);
INSERT INTO public.role_has_permissions VALUES (189, 1);
INSERT INTO public.role_has_permissions VALUES (190, 1);
INSERT INTO public.role_has_permissions VALUES (191, 1);
INSERT INTO public.role_has_permissions VALUES (116, 3);
INSERT INTO public.role_has_permissions VALUES (2, 3);
INSERT INTO public.role_has_permissions VALUES (123, 3);
INSERT INTO public.role_has_permissions VALUES (124, 3);
INSERT INTO public.role_has_permissions VALUES (75, 3);
INSERT INTO public.role_has_permissions VALUES (125, 3);
INSERT INTO public.role_has_permissions VALUES (127, 3);
INSERT INTO public.role_has_permissions VALUES (87, 3);
INSERT INTO public.role_has_permissions VALUES (192, 1);
INSERT INTO public.role_has_permissions VALUES (192, 3);
INSERT INTO public.role_has_permissions VALUES (193, 1);
INSERT INTO public.role_has_permissions VALUES (193, 3);
INSERT INTO public.role_has_permissions VALUES (194, 1);
INSERT INTO public.role_has_permissions VALUES (194, 3);
INSERT INTO public.role_has_permissions VALUES (195, 3);
INSERT INTO public.role_has_permissions VALUES (195, 1);
INSERT INTO public.role_has_permissions VALUES (2, 11);
INSERT INTO public.role_has_permissions VALUES (26, 11);
INSERT INTO public.role_has_permissions VALUES (3, 11);
INSERT INTO public.role_has_permissions VALUES (73, 3);
INSERT INTO public.role_has_permissions VALUES (74, 3);
INSERT INTO public.role_has_permissions VALUES (77, 3);
INSERT INTO public.role_has_permissions VALUES (76, 3);
INSERT INTO public.role_has_permissions VALUES (78, 3);
INSERT INTO public.role_has_permissions VALUES (80, 3);
INSERT INTO public.role_has_permissions VALUES (79, 3);
INSERT INTO public.role_has_permissions VALUES (81, 3);
INSERT INTO public.role_has_permissions VALUES (85, 3);
INSERT INTO public.role_has_permissions VALUES (84, 3);
INSERT INTO public.role_has_permissions VALUES (196, 3);
INSERT INTO public.role_has_permissions VALUES (196, 1);
INSERT INTO public.role_has_permissions VALUES (66, 3);
INSERT INTO public.role_has_permissions VALUES (197, 1);
INSERT INTO public.role_has_permissions VALUES (198, 1);
INSERT INTO public.role_has_permissions VALUES (199, 1);
INSERT INTO public.role_has_permissions VALUES (200, 1);
INSERT INTO public.role_has_permissions VALUES (201, 1);
INSERT INTO public.role_has_permissions VALUES (202, 1);
INSERT INTO public.role_has_permissions VALUES (203, 1);
INSERT INTO public.role_has_permissions VALUES (204, 1);
INSERT INTO public.role_has_permissions VALUES (205, 1);
INSERT INTO public.role_has_permissions VALUES (206, 1);
INSERT INTO public.role_has_permissions VALUES (207, 1);
INSERT INTO public.role_has_permissions VALUES (208, 1);
INSERT INTO public.role_has_permissions VALUES (209, 1);
INSERT INTO public.role_has_permissions VALUES (210, 1);
INSERT INTO public.role_has_permissions VALUES (212, 1);
INSERT INTO public.role_has_permissions VALUES (211, 1);
INSERT INTO public.role_has_permissions VALUES (213, 1);
INSERT INTO public.role_has_permissions VALUES (214, 1);
INSERT INTO public.role_has_permissions VALUES (215, 1);
INSERT INTO public.role_has_permissions VALUES (216, 1);
INSERT INTO public.role_has_permissions VALUES (217, 1);
INSERT INTO public.role_has_permissions VALUES (218, 1);
INSERT INTO public.role_has_permissions VALUES (219, 1);
INSERT INTO public.role_has_permissions VALUES (220, 1);
INSERT INTO public.role_has_permissions VALUES (221, 1);
INSERT INTO public.role_has_permissions VALUES (222, 1);
INSERT INTO public.role_has_permissions VALUES (210, 3);
INSERT INTO public.role_has_permissions VALUES (212, 3);
INSERT INTO public.role_has_permissions VALUES (211, 3);
INSERT INTO public.role_has_permissions VALUES (213, 3);
INSERT INTO public.role_has_permissions VALUES (214, 3);
INSERT INTO public.role_has_permissions VALUES (215, 3);
INSERT INTO public.role_has_permissions VALUES (216, 3);
INSERT INTO public.role_has_permissions VALUES (217, 3);
INSERT INTO public.role_has_permissions VALUES (218, 3);
INSERT INTO public.role_has_permissions VALUES (219, 3);
INSERT INTO public.role_has_permissions VALUES (220, 3);
INSERT INTO public.role_has_permissions VALUES (221, 3);
INSERT INTO public.role_has_permissions VALUES (222, 3);
INSERT INTO public.role_has_permissions VALUES (223, 1);
INSERT INTO public.role_has_permissions VALUES (223, 3);
INSERT INTO public.role_has_permissions VALUES (224, 1);
INSERT INTO public.role_has_permissions VALUES (224, 3);
INSERT INTO public.role_has_permissions VALUES (225, 1);
INSERT INTO public.role_has_permissions VALUES (226, 1);
INSERT INTO public.role_has_permissions VALUES (227, 1);
INSERT INTO public.role_has_permissions VALUES (228, 1);
INSERT INTO public.role_has_permissions VALUES (229, 1);
INSERT INTO public.role_has_permissions VALUES (230, 1);
INSERT INTO public.role_has_permissions VALUES (231, 1);
INSERT INTO public.role_has_permissions VALUES (232, 1);
INSERT INTO public.role_has_permissions VALUES (233, 1);
INSERT INTO public.role_has_permissions VALUES (234, 1);
INSERT INTO public.role_has_permissions VALUES (235, 1);
INSERT INTO public.role_has_permissions VALUES (236, 1);
INSERT INTO public.role_has_permissions VALUES (237, 1);
INSERT INTO public.role_has_permissions VALUES (238, 1);
INSERT INTO public.role_has_permissions VALUES (239, 1);
INSERT INTO public.role_has_permissions VALUES (240, 1);
INSERT INTO public.role_has_permissions VALUES (241, 1);
INSERT INTO public.role_has_permissions VALUES (242, 1);
INSERT INTO public.role_has_permissions VALUES (243, 1);
INSERT INTO public.role_has_permissions VALUES (244, 1);
INSERT INTO public.role_has_permissions VALUES (245, 1);
INSERT INTO public.role_has_permissions VALUES (249, 1);
INSERT INTO public.role_has_permissions VALUES (250, 1);
INSERT INTO public.role_has_permissions VALUES (251, 1);
INSERT INTO public.role_has_permissions VALUES (252, 1);
INSERT INTO public.role_has_permissions VALUES (253, 1);
INSERT INTO public.role_has_permissions VALUES (254, 1);
INSERT INTO public.role_has_permissions VALUES (255, 1);
INSERT INTO public.role_has_permissions VALUES (256, 1);
INSERT INTO public.role_has_permissions VALUES (257, 1);
INSERT INTO public.role_has_permissions VALUES (258, 1);
INSERT INTO public.role_has_permissions VALUES (259, 1);
INSERT INTO public.role_has_permissions VALUES (260, 1);
INSERT INTO public.role_has_permissions VALUES (261, 1);
INSERT INTO public.role_has_permissions VALUES (262, 1);
INSERT INTO public.role_has_permissions VALUES (263, 1);
INSERT INTO public.role_has_permissions VALUES (264, 1);
INSERT INTO public.role_has_permissions VALUES (265, 1);
INSERT INTO public.role_has_permissions VALUES (266, 1);
INSERT INTO public.role_has_permissions VALUES (267, 1);
INSERT INTO public.role_has_permissions VALUES (246, 1);
INSERT INTO public.role_has_permissions VALUES (247, 1);
INSERT INTO public.role_has_permissions VALUES (268, 1);
INSERT INTO public.role_has_permissions VALUES (269, 1);
INSERT INTO public.role_has_permissions VALUES (270, 1);
INSERT INTO public.role_has_permissions VALUES (271, 1);
INSERT INTO public.role_has_permissions VALUES (272, 1);
INSERT INTO public.role_has_permissions VALUES (273, 1);
INSERT INTO public.role_has_permissions VALUES (274, 1);
INSERT INTO public.role_has_permissions VALUES (275, 1);
INSERT INTO public.role_has_permissions VALUES (276, 1);
INSERT INTO public.role_has_permissions VALUES (277, 1);
INSERT INTO public.role_has_permissions VALUES (278, 1);
INSERT INTO public.role_has_permissions VALUES (279, 1);
INSERT INTO public.role_has_permissions VALUES (280, 1);
INSERT INTO public.role_has_permissions VALUES (281, 1);
INSERT INTO public.role_has_permissions VALUES (282, 1);
INSERT INTO public.role_has_permissions VALUES (283, 1);
INSERT INTO public.role_has_permissions VALUES (284, 1);
INSERT INTO public.role_has_permissions VALUES (285, 1);
INSERT INTO public.role_has_permissions VALUES (286, 1);
INSERT INTO public.role_has_permissions VALUES (287, 1);
INSERT INTO public.role_has_permissions VALUES (288, 1);
INSERT INTO public.role_has_permissions VALUES (289, 1);
INSERT INTO public.role_has_permissions VALUES (290, 1);
INSERT INTO public.role_has_permissions VALUES (291, 1);
INSERT INTO public.role_has_permissions VALUES (292, 1);
INSERT INTO public.role_has_permissions VALUES (293, 1);
INSERT INTO public.role_has_permissions VALUES (294, 1);
INSERT INTO public.role_has_permissions VALUES (296, 1);
INSERT INTO public.role_has_permissions VALUES (297, 1);
INSERT INTO public.role_has_permissions VALUES (298, 1);
INSERT INTO public.role_has_permissions VALUES (295, 1);
INSERT INTO public.role_has_permissions VALUES (299, 1);
INSERT INTO public.role_has_permissions VALUES (300, 1);
INSERT INTO public.role_has_permissions VALUES (301, 1);
INSERT INTO public.role_has_permissions VALUES (302, 1);
INSERT INTO public.role_has_permissions VALUES (303, 1);
INSERT INTO public.role_has_permissions VALUES (304, 1);
INSERT INTO public.role_has_permissions VALUES (305, 1);
INSERT INTO public.role_has_permissions VALUES (306, 1);
INSERT INTO public.role_has_permissions VALUES (307, 1);
INSERT INTO public.role_has_permissions VALUES (308, 1);
INSERT INTO public.role_has_permissions VALUES (309, 1);
INSERT INTO public.role_has_permissions VALUES (310, 1);
INSERT INTO public.role_has_permissions VALUES (311, 1);
INSERT INTO public.role_has_permissions VALUES (312, 1);
INSERT INTO public.role_has_permissions VALUES (313, 1);
INSERT INTO public.role_has_permissions VALUES (314, 1);
INSERT INTO public.role_has_permissions VALUES (315, 1);
INSERT INTO public.role_has_permissions VALUES (316, 1);
INSERT INTO public.role_has_permissions VALUES (317, 1);
INSERT INTO public.role_has_permissions VALUES (318, 1);
INSERT INTO public.role_has_permissions VALUES (319, 1);
INSERT INTO public.role_has_permissions VALUES (320, 1);
INSERT INTO public.role_has_permissions VALUES (321, 1);
INSERT INTO public.role_has_permissions VALUES (322, 1);
INSERT INTO public.role_has_permissions VALUES (323, 1);
INSERT INTO public.role_has_permissions VALUES (324, 1);
INSERT INTO public.role_has_permissions VALUES (325, 1);
INSERT INTO public.role_has_permissions VALUES (326, 1);
INSERT INTO public.role_has_permissions VALUES (327, 1);
INSERT INTO public.role_has_permissions VALUES (328, 1);
INSERT INTO public.role_has_permissions VALUES (329, 1);
INSERT INTO public.role_has_permissions VALUES (330, 1);
INSERT INTO public.role_has_permissions VALUES (331, 1);
INSERT INTO public.role_has_permissions VALUES (332, 1);
INSERT INTO public.role_has_permissions VALUES (333, 1);
INSERT INTO public.role_has_permissions VALUES (334, 1);
INSERT INTO public.role_has_permissions VALUES (335, 1);
INSERT INTO public.role_has_permissions VALUES (336, 1);
INSERT INTO public.role_has_permissions VALUES (337, 1);
INSERT INTO public.role_has_permissions VALUES (338, 1);
INSERT INTO public.role_has_permissions VALUES (339, 1);
INSERT INTO public.role_has_permissions VALUES (346, 1);
INSERT INTO public.role_has_permissions VALUES (347, 1);
INSERT INTO public.role_has_permissions VALUES (348, 1);
INSERT INTO public.role_has_permissions VALUES (349, 1);
INSERT INTO public.role_has_permissions VALUES (350, 1);
INSERT INTO public.role_has_permissions VALUES (351, 1);
INSERT INTO public.role_has_permissions VALUES (352, 1);
INSERT INTO public.role_has_permissions VALUES (353, 1);
INSERT INTO public.role_has_permissions VALUES (343, 1);
INSERT INTO public.role_has_permissions VALUES (344, 1);
INSERT INTO public.role_has_permissions VALUES (345, 1);


--
-- TOC entry 3975 (class 0 OID 16710)
-- Dependencies: 277
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles VALUES (1, 'admin', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles VALUES (2, 'owner', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles VALUES (3, 'cashier', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles VALUES (5, 'terapist', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles VALUES (4, 'admin_finance', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles VALUES (6, 'hr', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles VALUES (11, 'trainer', 'web', '2022-08-06 23:01:46', '2022-08-06 23:01:46');


--
-- TOC entry 3995 (class 0 OID 17057)
-- Dependencies: 297
-- Data for Name: setting_document_counter; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.setting_document_counter VALUES (3, 'Invoice', 'INV', 'Yearly', 0, NULL, NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (1, 'Order', 'SPK', 'Yearly', 1, '2022-11-26 00:30:52', NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (10, 'Receive', 'RCV', 'Yearly', 0, NULL, NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (12, 'Purchase', 'PO', 'Yearly', 0, NULL, NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (17, 'Purchase', 'PO', 'Yearly', 0, NULL, NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (4, 'Purchase', 'PO', 'Yearly', 1, '2022-11-26 01:26:29', NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (15, 'Receive', 'RCV', 'Yearly', 1, '2022-11-26 01:26:53', NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (5, 'Receive', 'RCV', 'Yearly', 2, '2022-11-26 15:35:45', NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (19, 'Return Invoice', 'REI', 'Yearly', 1, '2022-11-26 01:15:01', NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (20, 'Return Invoice', 'REI', 'Yearly', 1, '2022-11-26 01:15:01', NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (21, 'Return Invoice', 'REI', 'Yearly', 1, '2022-11-26 01:15:01', NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (13, 'Order', 'SPK', 'Yearly', 6, '2022-12-03 16:02:09', NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (18, 'Order', 'SPK', 'Yearly', 4, '2022-12-03 16:35:48', NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (16, 'Invoice', 'INV', 'Yearly', 4, '2022-12-03 20:50:36', NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (11, 'Invoice', 'INV', 'Yearly', 58, '2022-12-11 11:05:58', NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (2, 'Order_Queue', 'SPK', 'Daily', 0, '2022-12-16 13:10:21', NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (9, 'Order_Queue', 'SPK', 'Daily', 0, '2022-12-16 13:10:21', NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (14, 'Order_Queue', 'SPK', 'Daily', 0, '2022-12-16 13:10:21', NULL, NULL, '2022-11-25 20:43:40.854575', 3);


--
-- TOC entry 3977 (class 0 OID 16716)
-- Dependencies: 279
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.settings VALUES ('2022-07-16', 202207, 'Kakiku', 'Lapak ERP', 'v0.0.1', 'logo_kakiku.png');


--
-- TOC entry 3978 (class 0 OID 16722)
-- Dependencies: 280
-- Data for Name: shift; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.shift VALUES (2, 'Shift II Sore', '15:00:00', '21:00:00', NULL, NULL, '2022-09-09 10:14:57.221863');
INSERT INTO public.shift VALUES (1, 'Shift I Pagi', '08:00:00', '15:00:00', NULL, NULL, '2022-09-09 10:14:57.221863');


--
-- TOC entry 4001 (class 0 OID 17129)
-- Dependencies: 303
-- Data for Name: shift_counter; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.shift_counter VALUES (27, 2, NULL, NULL, 1, '2022-12-03 07:30:22.230869', 1);
INSERT INTO public.shift_counter VALUES (14, 3, NULL, NULL, 1, '2022-12-03 07:30:22.230869', 1);
INSERT INTO public.shift_counter VALUES (33, 4, NULL, NULL, 1, '2022-12-03 07:30:22.230869', 1);
INSERT INTO public.shift_counter VALUES (31, 1, NULL, '2022-12-03 16:02:09.554428', 1, '2022-12-03 07:30:22.230869', 2);
INSERT INTO public.shift_counter VALUES (29, 2, NULL, '2022-12-03 16:02:09.554428', 1, '2022-12-03 07:30:22.230869', 2);
INSERT INTO public.shift_counter VALUES (53, 3, NULL, '2022-12-03 16:02:09.554428', 1, '2022-12-03 07:30:22.230869', 2);
INSERT INTO public.shift_counter VALUES (32, 2, NULL, '2022-12-03 16:35:48.812912', 1, '2022-12-03 07:30:22.230869', 1);
INSERT INTO public.shift_counter VALUES (30, 0, NULL, '2022-12-03 16:35:48.814707', 1, '2022-12-03 07:30:22.230869', 3);


--
-- TOC entry 3980 (class 0 OID 16731)
-- Dependencies: 282
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.suppliers VALUES (2, 'Test Supplier 02', 'Jalan Mawar Mandiri No 01', 2, 'test@gmail.com', '085746879090', NULL, NULL, '2022-09-04 11:31:10.765461');
INSERT INTO public.suppliers VALUES (1, 'Test Supplier 010', 'Jalan Pangeran Parit 210', 1, 'testa@gmail.com', '0857468790909', '2022-09-04 12:57:56', NULL, '2022-09-04 11:31:10.765461');


--
-- TOC entry 3966 (class 0 OID 16640)
-- Dependencies: 268
-- Data for Name: uom; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.uom VALUES (1, 'Botol', 1, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (2, 'Bungkus', 1, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (3, 'Tube', 1, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (4, 'Buah', 1, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (5, 'Sacheet', 1, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (6, 'Kotak', 1, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (7, 'Amplus', 1, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (8, 'Pcs', 1, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (9, '90 Menit', 90, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (10, '30 Menit', 30, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (11, '45 Menit', 45, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (12, '120 Menit', 120, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (13, '5 Menit', 5, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (14, '10 Menit', 10, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (15, '15 Menit', 15, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (16, '20 Menit', 20, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (17, '1 Menit', 1, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (18, 'Pasang', 1, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (19, '60 Menit', 60, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (20, '150 Menit', 150, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (21, '100 Menit', 100, '2022-06-01 20:55:39.248472', NULL);
INSERT INTO public.uom VALUES (23, 'Renceng', 1, '2022-07-25 14:17:17', '2022-07-25 14:17:24');
INSERT INTO public.uom VALUES (24, '200 Menit', 1, '2022-11-15 19:34:12', '2022-11-15 19:34:12');


--
-- TOC entry 3982 (class 0 OID 16738)
-- Dependencies: 284
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES (3, 'User-Owner', 'owner@gmail.com', 'user-owner', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-08-21 03:25:52', '6285746879090', 'JALAN JAKARTA', '2022-01-01', 1, 'Male', '3524111233144330001', 'JAKARTA', '20210101OWN', 'man.png', 'draft_netizen_01.jpg', 3, 1, 6, NULL, 'JAKARTA', '2022-01-01', 'On Job Training', 1);
INSERT INTO public.users VALUES (1, 'Admin', 'admin@gmail.com', 'admin', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-05-28 12:40:11', '6285746879090', 'JALAN JAKARTA', '2020-01-01', 2, 'Male', '3524111233144330001', 'JAKARTA', '20210101ADM', 'user-13.jpg', 'user-13.jpg', 6, 2, 5, NULL, 'JAKARTA', '2022-01-01', 'On Job Training', 1);
INSERT INTO public.users VALUES (26, 'Test User', 'purnomo.yogiaditya@gmail.com', 'test_123', NULL, '$2y$10$bIEbT.3PQ4tHVbn9St.oreO5diYJGTV6TqNuWmgGqE8wScBqIxO1S', NULL, '2022-07-12 06:19:07', '2022-07-12 08:02:57', '085746879090', 'Lmg', '2013-07-11', 9, 'Male', '35241112331443300021', 'Lmg', '20000109YG', 'user-13.jpg', NULL, 3, 2, 2, 3, 'test', '2022-07-03', 'On Job Training', 1);
INSERT INTO public.users VALUES (32, 'Anni -Terapist', 'jemm@gmail.com', 'anni', NULL, '$2y$10$DtwhuxLX7GD5Mkcdtk3nK.9D.shExDpmeqeNaffU.KOTnAKhPmRrS', NULL, '2022-07-30 08:09:55', '2022-07-30 08:09:55', '082311111', 'Solo', '2022-07-04', 1, 'Female', '35241112331443300012', 'Sragen', 'JR20220101102', 'user-13.jpg', NULL, 2, 1, 2, NULL, 'Solo', '2022-07-10', 'On Job Training', 1);
INSERT INTO public.users VALUES (33, 'Zilong -Terapist', 'fist@gmail.com', 'zilong', NULL, '$2y$10$hv3IVYi39yFzGYmh3Th8KeuHaIRbKS/NHrL3QrypF46oOWYXFPy9a', NULL, '2022-07-30 08:48:31', '2022-07-30 08:48:31', '0813453211', 'Medan', '2022-07-17', 1, 'Male', '35241112331443300021', 'Medan', '2011010022', 'user-13.jpg', NULL, 2, 1, 2, 14, 'Medan', '2022-04-17', 'On Job Training', 1);
INSERT INTO public.users VALUES (14, 'Nana  -Terapist', 'terapist@gmail.com', 'user-terapist', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-06-11 12:06:30', '6285746879090', 'JALAN JAKARTA', '2017-01-01', 5, 'Female', '3524111233144330001', 'JAKARTA', '20210101TRP', 'user-13.jpg', 'user-13.jpg', 2, 1, 2, 5, 'JAKARTA', '2022-01-01', 'On Job Training', 1);
INSERT INTO public.users VALUES (5, 'User-HR', 'hr@gmail.com', 'user-hr', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-07-06 14:26:35', '6285746879090', 'JALAN JAKARTA', '2021-01-01', 1, 'Male', '3524111233144330001', 'JAKARTA', '20210101HR', 'user-13.jpg', 'user-13.jpg', 5, 1, 4, 1, 'JAKARTA', '2022-01-01', 'On Job Training', 1);
INSERT INTO public.users VALUES (29, 'John Doe-Terapist', 'johndoe@gmail.com', 'johndoe', NULL, '$2y$10$D8C5.ba4RGNeN9Q6uH82HeAm0P6S5jp.Y6e5IK11hypYnOByDW0rS', NULL, '2022-07-30 07:29:53', '2022-07-30 07:56:32', '085746879090', 'Pekanbaru', '2022-05-22', 1, 'Male', '35241112331443300021', 'Pekanbaru', 'JD2022073001', 'user-13.jpg', NULL, 2, 2, 2, 3, 'Suwoko', '2020-12-28', 'On Job Training', 1);
INSERT INTO public.users VALUES (2, 'User-Kasir', 'kasir@gmail.com', 'user-kasir', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-08-21 04:21:09', '6285746879090', 'JALAN JAKARTA', '2019-05-01', 3, 'Female', '35241112331443300012', 'JAKARTA', '20210101KSR', 'user-13.jpg', 'draft_netizen.jpg', 1, 2, 2, 1, 'JAKARTA', '2022-01-01', 'Contract', 1);
INSERT INTO public.users VALUES (53, 'Fake Hokis -Terapist', 'dada@gmill.com', 'fake', NULL, '$2y$10$AcOnNDUrWd/nha4KRSySa.i2OiFXR4PP.UBjc4LWjQSLnwuhbCcAm', NULL, '2022-07-30 11:33:55', '2022-07-30 11:33:55', '085746879090', 'Lamongan', '2022-07-10', 1, 'Male', '35241112331443300021', 'Lamongan', 'HK022133', '0769c4c63be92e17c0bf06d131baca96.png', 'eddac66b535aa161c61b06d77f26b5e0.jpg', 2, 2, 2, 1, 'Jakarta', '2022-07-11', 'On Job Training', 1);
INSERT INTO public.users VALUES (54, 'Coach-Andy', 'trainer@gmail.com', 'trainer', NULL, '$2y$10$NeF32GFPD7LysV2ggx9OROXX0XuZorwFM9kxlSu8WGZtFnTljTmqG', NULL, '2022-08-20 11:30:05', '2022-08-20 11:30:05', '085746879090', 'Lamongan', '2022-08-01', 1, 'Male', '35241112331443300021', 'Lamongan', 'TR-ADY-001', '804e42dadef82ee18bcbf174a3ad9090.png', 'b8074bdb86f8572480601bf1cd2a42ad.jpg', 7, 1, 9, NULL, 'Test', '2022-08-09', 'On Job Training', 1);
INSERT INTO public.users VALUES (4, 'User-Admin Keuangan', 'finance@gmail.com', 'user-finance', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-07-30 08:27:49', '6285746879090', 'JALAN JAKARTA', '2022-01-01', 1, 'Male', '3524111233144330001', 'JAKARTA', '20210101ADU', 'user-13.jpg', 'draft_netizen_01.jpg', 4, 1, 3, NULL, 'JAKARTA', '2022-01-01', 'On Job Training', 1);
INSERT INTO public.users VALUES (31, 'Johny Deep -Terapist', 'serang@gmail.com', 'johnydeep', NULL, '$2y$10$ZfgXjRK5S86XP2cJtmA6QOku/.v9jSEHfOIBxsZDmCAkKFTLA/MRW', NULL, '2022-07-30 08:03:28', '2022-07-30 08:03:51', '0844312333', 'Serang', '2015-07-18', 7, 'Male', '35241112331443300021', 'Banten', 'JD202204011', 'user-13.jpg', NULL, 2, 2, 2, NULL, 'Serang', '2020-04-19', 'On Job Training', 1);
INSERT INTO public.users VALUES (30, 'Mark Karl -Terapist', 'maxkarl@gmail.com', 'karlmax', NULL, '$2y$10$Ohj/K.hR2an/GZWn0ONjMe/xd02ZbPniiDcDkY6EcVr8smyPZMhHG', NULL, '2022-07-30 08:00:11', '2022-07-30 08:07:59', '081323', 'Lamongan', '2016-07-18', 6, 'Male', '35241112331443300021', 'Lamongan', 'MK20220102', 'user-13.jpg', NULL, 2, 3, 2, 27, 'Lamongan', '2022-07-04', 'On Job Training', 1);
INSERT INTO public.users VALUES (27, 'Lilia - Terapist', 'yogiektambakboyo@gmail.com', 'lilia', NULL, '$2y$10$KUxgpNxhdNzyGOxkrjvsJ.e6Pm264gbZC7roqsC4nru/ALpI28PS.', NULL, '2022-07-25 11:46:21', '2022-07-30 08:28:42', '085746879090', 'Lamongan', '2018-07-18', 4, 'Female', '35241112331443300021', 'Lamongan', '20210021UU', 'user-13.jpg', 'draft_netizen_01.jpg', 2, 1, 2, 26, 'Jakarta', '2022-07-10', 'On Job Training', 1);


--
-- TOC entry 3983 (class 0 OID 16745)
-- Dependencies: 285
-- Data for Name: users_branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users_branch VALUES (25, 3, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (1, 1, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (5, 2, '2022-07-06 14:26:35', '2022-07-06 14:26:35');
INSERT INTO public.users_branch VALUES (5, 3, '2022-07-06 14:26:35', '2022-07-06 14:26:35');
INSERT INTO public.users_branch VALUES (1, 3, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (1, 2, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (26, 2, '2022-07-12 08:02:57', '2022-07-12 08:02:57');
INSERT INTO public.users_branch VALUES (28, 2, '2022-07-30 07:23:56', '2022-07-30 07:23:56');
INSERT INTO public.users_branch VALUES (29, 2, '2022-07-30 07:56:32', '2022-07-30 07:56:32');
INSERT INTO public.users_branch VALUES (31, 2, '2022-07-30 08:03:51', '2022-07-30 08:03:51');
INSERT INTO public.users_branch VALUES (30, 3, '2022-07-30 08:07:59', '2022-07-30 08:07:59');
INSERT INTO public.users_branch VALUES (4, 1, '2022-07-30 08:27:49', '2022-07-30 08:27:49');
INSERT INTO public.users_branch VALUES (27, 1, '2022-07-30 08:28:42', '2022-07-30 08:28:42');
INSERT INTO public.users_branch VALUES (34, 2, '2022-07-30 08:59:40', '2022-07-30 08:59:40');
INSERT INTO public.users_branch VALUES (35, 2, '2022-07-30 09:05:58', '2022-07-30 09:05:58');
INSERT INTO public.users_branch VALUES (36, 2, '2022-07-30 09:18:56', '2022-07-30 09:18:56');
INSERT INTO public.users_branch VALUES (37, 2, '2022-07-30 09:23:18', '2022-07-30 09:23:18');
INSERT INTO public.users_branch VALUES (38, 2, '2022-07-30 09:25:19', '2022-07-30 09:25:19');
INSERT INTO public.users_branch VALUES (39, 2, '2022-07-30 09:44:52', '2022-07-30 09:44:52');
INSERT INTO public.users_branch VALUES (40, 2, '2022-07-30 09:48:35', '2022-07-30 09:48:35');
INSERT INTO public.users_branch VALUES (41, 2, '2022-07-30 10:04:19', '2022-07-30 10:04:19');
INSERT INTO public.users_branch VALUES (42, 2, '2022-07-30 10:06:14', '2022-07-30 10:06:14');
INSERT INTO public.users_branch VALUES (43, 2, '2022-07-30 10:09:02', '2022-07-30 10:09:02');
INSERT INTO public.users_branch VALUES (44, 2, '2022-07-30 10:10:46', '2022-07-30 10:10:46');
INSERT INTO public.users_branch VALUES (45, 2, '2022-07-30 10:14:51', '2022-07-30 10:14:51');
INSERT INTO public.users_branch VALUES (46, 2, '2022-07-30 10:21:18', '2022-07-30 10:21:18');
INSERT INTO public.users_branch VALUES (47, 2, '2022-07-30 10:25:09', '2022-07-30 10:25:09');
INSERT INTO public.users_branch VALUES (48, 2, '2022-07-30 10:31:09', '2022-07-30 10:31:09');
INSERT INTO public.users_branch VALUES (52, 2, '2022-07-30 11:31:36', '2022-07-30 11:31:36');
INSERT INTO public.users_branch VALUES (53, 2, '2022-07-30 11:33:55', '2022-07-30 11:33:55');
INSERT INTO public.users_branch VALUES (54, 1, '2022-08-20 11:30:05', '2022-08-20 11:30:05');
INSERT INTO public.users_branch VALUES (3, 1, '2022-08-21 03:25:52', '2022-08-21 03:25:52');
INSERT INTO public.users_branch VALUES (2, 2, '2022-08-21 04:21:09', '2022-08-21 04:21:09');
INSERT INTO public.users_branch VALUES (14, 1, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (32, 1, '2022-07-30 08:09:55', '2022-07-30 08:09:55');
INSERT INTO public.users_branch VALUES (33, 1, '2022-07-30 08:48:31', '2022-07-30 08:48:31');


--
-- TOC entry 3984 (class 0 OID 16749)
-- Dependencies: 286
-- Data for Name: users_experience; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users_experience VALUES (1, 2, 'Astra', 'Coordinator Sales', '2019-2020', NULL, 1, '2022-08-21 11:41:24.412471');


--
-- TOC entry 3987 (class 0 OID 16757)
-- Dependencies: 289
-- Data for Name: users_mutation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users_mutation VALUES (1, 2, 2, 1, 1, 'Test', '2022-07-12 11:48:14.272853', NULL);
INSERT INTO public.users_mutation VALUES (2, 2, 2, 1, 2, 'Test', '2022-07-12 12:00:46.39511', NULL);
INSERT INTO public.users_mutation VALUES (4, 26, 1, 2, 1, NULL, '2022-07-12 06:53:32', '2022-07-12 06:53:32');
INSERT INTO public.users_mutation VALUES (5, 26, 2, 2, 3, NULL, '2022-07-12 08:02:57', '2022-07-12 08:02:57');
INSERT INTO public.users_mutation VALUES (7, 27, 1, 2, 2, NULL, '2022-07-25 11:49:24', '2022-07-25 11:49:24');
INSERT INTO public.users_mutation VALUES (9, 29, 2, 2, 2, NULL, '2022-07-30 07:29:53', '2022-07-30 07:29:53');
INSERT INTO public.users_mutation VALUES (10, 29, 2, 2, 2, NULL, '2022-07-30 07:53:12', '2022-07-30 07:53:12');
INSERT INTO public.users_mutation VALUES (11, 30, 3, 2, 2, NULL, '2022-07-30 08:00:11', '2022-07-30 08:00:11');
INSERT INTO public.users_mutation VALUES (12, 31, 2, 2, 2, NULL, '2022-07-30 08:03:28', '2022-07-30 08:03:28');
INSERT INTO public.users_mutation VALUES (13, 31, 2, 2, 2, NULL, '2022-07-30 08:03:51', '2022-07-30 08:03:51');
INSERT INTO public.users_mutation VALUES (14, 30, 3, 2, 2, NULL, '2022-07-30 08:07:59', '2022-07-30 08:07:59');
INSERT INTO public.users_mutation VALUES (15, 32, 2, 2, 2, NULL, '2022-07-30 08:09:55', '2022-07-30 08:09:55');
INSERT INTO public.users_mutation VALUES (16, 2, 2, 2, 1, NULL, '2022-07-30 08:26:07', '2022-07-30 08:26:07');
INSERT INTO public.users_mutation VALUES (17, 2, 3, 2, 1, NULL, '2022-07-30 08:26:07', '2022-07-30 08:26:07');
INSERT INTO public.users_mutation VALUES (18, 4, 1, 3, 4, NULL, '2022-07-30 08:27:49', '2022-07-30 08:27:49');
INSERT INTO public.users_mutation VALUES (19, 33, 2, 2, 2, NULL, '2022-07-30 08:48:31', '2022-07-30 08:48:31');
INSERT INTO public.users_mutation VALUES (20, 34, 2, 2, 2, NULL, '2022-07-30 08:59:40', '2022-07-30 08:59:40');
INSERT INTO public.users_mutation VALUES (21, 35, 2, 3, 1, NULL, '2022-07-30 09:05:58', '2022-07-30 09:05:58');
INSERT INTO public.users_mutation VALUES (22, 36, 2, 4, 1, NULL, '2022-07-30 09:18:56', '2022-07-30 09:18:56');
INSERT INTO public.users_mutation VALUES (23, 37, 2, 2, 2, NULL, '2022-07-30 09:23:18', '2022-07-30 09:23:18');
INSERT INTO public.users_mutation VALUES (24, 38, 2, 2, 2, NULL, '2022-07-30 09:24:32', '2022-07-30 09:24:32');
INSERT INTO public.users_mutation VALUES (25, 38, 2, 2, 2, NULL, '2022-07-30 09:25:19', '2022-07-30 09:25:19');
INSERT INTO public.users_mutation VALUES (26, 39, 2, 2, 2, NULL, '2022-07-30 09:44:52', '2022-07-30 09:44:52');
INSERT INTO public.users_mutation VALUES (27, 40, 2, 2, 2, NULL, '2022-07-30 09:48:35', '2022-07-30 09:48:35');
INSERT INTO public.users_mutation VALUES (28, 41, 2, 2, 2, NULL, '2022-07-30 10:04:19', '2022-07-30 10:04:19');
INSERT INTO public.users_mutation VALUES (29, 42, 2, 2, 2, NULL, '2022-07-30 10:06:14', '2022-07-30 10:06:14');
INSERT INTO public.users_mutation VALUES (30, 43, 2, 2, 1, NULL, '2022-07-30 10:09:02', '2022-07-30 10:09:02');
INSERT INTO public.users_mutation VALUES (31, 44, 2, 2, 2, NULL, '2022-07-30 10:10:46', '2022-07-30 10:10:46');
INSERT INTO public.users_mutation VALUES (32, 45, 2, 2, 2, NULL, '2022-07-30 10:14:02', '2022-07-30 10:14:02');
INSERT INTO public.users_mutation VALUES (33, 45, 2, 2, 2, NULL, '2022-07-30 10:14:51', '2022-07-30 10:14:51');
INSERT INTO public.users_mutation VALUES (34, 46, 2, 2, 2, NULL, '2022-07-30 10:21:18', '2022-07-30 10:21:18');
INSERT INTO public.users_mutation VALUES (35, 47, 2, 2, 2, NULL, '2022-07-30 10:25:09', '2022-07-30 10:25:09');
INSERT INTO public.users_mutation VALUES (36, 48, 2, 2, 2, NULL, '2022-07-30 10:31:09', '2022-07-30 10:31:09');
INSERT INTO public.users_mutation VALUES (37, 52, 2, 2, 2, NULL, '2022-07-30 11:31:36', '2022-07-30 11:31:36');
INSERT INTO public.users_mutation VALUES (38, 53, 2, 2, 2, NULL, '2022-07-30 11:33:55', '2022-07-30 11:33:55');
INSERT INTO public.users_mutation VALUES (39, 2, 2, 2, 1, NULL, '2022-08-01 08:18:48', '2022-08-01 08:18:48');
INSERT INTO public.users_mutation VALUES (40, 54, 1, 9, 7, NULL, '2022-08-20 11:30:05', '2022-08-20 11:30:05');


--
-- TOC entry 3989 (class 0 OID 16764)
-- Dependencies: 291
-- Data for Name: users_shift; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users_shift VALUES (1, 2, '2022-09-01', 1, 'Shift I Pagi', '08:00:00', '15:00:00', 'Test II', '2022-09-15 12:02:50', '2022-09-12 09:20:34.369454', 1);
INSERT INTO public.users_shift VALUES (2, 14, '2022-12-03', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:23.681639', '2022-11-29 21:24:23.681639', 71);
INSERT INTO public.users_shift VALUES (2, 14, '2022-12-03', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:23.681639', '2022-11-29 21:24:23.681639', 72);
INSERT INTO public.users_shift VALUES (2, 14, '2022-11-29', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:26.257789', '2022-11-29 21:23:26.257789', 7);
INSERT INTO public.users_shift VALUES (2, 14, '2022-11-29', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:26.257789', '2022-11-29 21:23:26.257789', 8);
INSERT INTO public.users_shift VALUES (2, 29, '2022-11-29', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:26.257789', '2022-11-29 21:23:26.257789', 9);
INSERT INTO public.users_shift VALUES (2, 29, '2022-11-29', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:26.257789', '2022-11-29 21:23:26.257789', 10);
INSERT INTO public.users_shift VALUES (2, 31, '2022-11-29', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:26.257789', '2022-11-29 21:23:26.257789', 11);
INSERT INTO public.users_shift VALUES (2, 31, '2022-11-29', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:26.257789', '2022-11-29 21:23:26.257789', 12);
INSERT INTO public.users_shift VALUES (3, 30, '2022-11-29', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:26.257789', '2022-11-29 21:23:26.257789', 13);
INSERT INTO public.users_shift VALUES (3, 30, '2022-11-29', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:26.257789', '2022-11-29 21:23:26.257789', 14);
INSERT INTO public.users_shift VALUES (2, 32, '2022-11-29', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:26.257789', '2022-11-29 21:23:26.257789', 15);
INSERT INTO public.users_shift VALUES (2, 32, '2022-11-29', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:26.257789', '2022-11-29 21:23:26.257789', 16);
INSERT INTO public.users_shift VALUES (1, 27, '2022-11-29', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:26.257789', '2022-11-29 21:23:26.257789', 17);
INSERT INTO public.users_shift VALUES (1, 27, '2022-11-29', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:26.257789', '2022-11-29 21:23:26.257789', 18);
INSERT INTO public.users_shift VALUES (2, 33, '2022-11-29', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:26.257789', '2022-11-29 21:23:26.257789', 19);
INSERT INTO public.users_shift VALUES (2, 33, '2022-11-29', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:26.257789', '2022-11-29 21:23:26.257789', 20);
INSERT INTO public.users_shift VALUES (2, 53, '2022-11-29', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:26.257789', '2022-11-29 21:23:26.257789', 21);
INSERT INTO public.users_shift VALUES (2, 53, '2022-11-29', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:26.257789', '2022-11-29 21:23:26.257789', 22);
INSERT INTO public.users_shift VALUES (2, 14, '2022-11-30', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:41.952469', '2022-11-29 21:23:41.952469', 23);
INSERT INTO public.users_shift VALUES (2, 14, '2022-11-30', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:41.952469', '2022-11-29 21:23:41.952469', 24);
INSERT INTO public.users_shift VALUES (2, 29, '2022-11-30', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:41.952469', '2022-11-29 21:23:41.952469', 25);
INSERT INTO public.users_shift VALUES (2, 29, '2022-11-30', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:41.952469', '2022-11-29 21:23:41.952469', 26);
INSERT INTO public.users_shift VALUES (2, 31, '2022-11-30', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:41.952469', '2022-11-29 21:23:41.952469', 27);
INSERT INTO public.users_shift VALUES (2, 31, '2022-11-30', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:41.952469', '2022-11-29 21:23:41.952469', 28);
INSERT INTO public.users_shift VALUES (3, 30, '2022-11-30', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:41.952469', '2022-11-29 21:23:41.952469', 29);
INSERT INTO public.users_shift VALUES (3, 30, '2022-11-30', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:41.952469', '2022-11-29 21:23:41.952469', 30);
INSERT INTO public.users_shift VALUES (2, 32, '2022-11-30', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:41.952469', '2022-11-29 21:23:41.952469', 31);
INSERT INTO public.users_shift VALUES (2, 32, '2022-11-30', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:41.952469', '2022-11-29 21:23:41.952469', 32);
INSERT INTO public.users_shift VALUES (1, 27, '2022-11-30', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:41.952469', '2022-11-29 21:23:41.952469', 33);
INSERT INTO public.users_shift VALUES (1, 27, '2022-11-30', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:41.952469', '2022-11-29 21:23:41.952469', 34);
INSERT INTO public.users_shift VALUES (2, 33, '2022-11-30', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:41.952469', '2022-11-29 21:23:41.952469', 35);
INSERT INTO public.users_shift VALUES (2, 33, '2022-11-30', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:41.952469', '2022-11-29 21:23:41.952469', 36);
INSERT INTO public.users_shift VALUES (2, 53, '2022-11-30', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:41.952469', '2022-11-29 21:23:41.952469', 37);
INSERT INTO public.users_shift VALUES (2, 53, '2022-11-30', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:41.952469', '2022-11-29 21:23:41.952469', 38);
INSERT INTO public.users_shift VALUES (2, 14, '2022-12-01', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:49.83084', '2022-11-29 21:23:49.83084', 39);
INSERT INTO public.users_shift VALUES (2, 14, '2022-12-01', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:49.83084', '2022-11-29 21:23:49.83084', 40);
INSERT INTO public.users_shift VALUES (2, 29, '2022-12-01', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:49.83084', '2022-11-29 21:23:49.83084', 41);
INSERT INTO public.users_shift VALUES (2, 29, '2022-12-01', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:49.83084', '2022-11-29 21:23:49.83084', 42);
INSERT INTO public.users_shift VALUES (2, 31, '2022-12-01', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:49.83084', '2022-11-29 21:23:49.83084', 43);
INSERT INTO public.users_shift VALUES (2, 31, '2022-12-01', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:49.83084', '2022-11-29 21:23:49.83084', 44);
INSERT INTO public.users_shift VALUES (3, 30, '2022-12-01', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:49.83084', '2022-11-29 21:23:49.83084', 45);
INSERT INTO public.users_shift VALUES (3, 30, '2022-12-01', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:49.83084', '2022-11-29 21:23:49.83084', 46);
INSERT INTO public.users_shift VALUES (2, 32, '2022-12-01', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:49.83084', '2022-11-29 21:23:49.83084', 47);
INSERT INTO public.users_shift VALUES (2, 32, '2022-12-01', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:49.83084', '2022-11-29 21:23:49.83084', 48);
INSERT INTO public.users_shift VALUES (1, 27, '2022-12-01', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:49.83084', '2022-11-29 21:23:49.83084', 49);
INSERT INTO public.users_shift VALUES (1, 27, '2022-12-01', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:49.83084', '2022-11-29 21:23:49.83084', 50);
INSERT INTO public.users_shift VALUES (2, 33, '2022-12-01', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:49.83084', '2022-11-29 21:23:49.83084', 51);
INSERT INTO public.users_shift VALUES (2, 33, '2022-12-01', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:49.83084', '2022-11-29 21:23:49.83084', 52);
INSERT INTO public.users_shift VALUES (2, 53, '2022-12-01', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:23:49.83084', '2022-11-29 21:23:49.83084', 53);
INSERT INTO public.users_shift VALUES (2, 53, '2022-12-01', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:23:49.83084', '2022-11-29 21:23:49.83084', 54);
INSERT INTO public.users_shift VALUES (2, 14, '2022-12-02', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:17.024435', '2022-11-29 21:24:17.024435', 55);
INSERT INTO public.users_shift VALUES (2, 14, '2022-12-02', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:17.024435', '2022-11-29 21:24:17.024435', 56);
INSERT INTO public.users_shift VALUES (2, 29, '2022-12-02', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:17.024435', '2022-11-29 21:24:17.024435', 57);
INSERT INTO public.users_shift VALUES (2, 29, '2022-12-02', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:17.024435', '2022-11-29 21:24:17.024435', 58);
INSERT INTO public.users_shift VALUES (2, 31, '2022-12-02', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:17.024435', '2022-11-29 21:24:17.024435', 59);
INSERT INTO public.users_shift VALUES (2, 31, '2022-12-02', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:17.024435', '2022-11-29 21:24:17.024435', 60);
INSERT INTO public.users_shift VALUES (3, 30, '2022-12-02', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:17.024435', '2022-11-29 21:24:17.024435', 61);
INSERT INTO public.users_shift VALUES (3, 30, '2022-12-02', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:17.024435', '2022-11-29 21:24:17.024435', 62);
INSERT INTO public.users_shift VALUES (2, 32, '2022-12-02', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:17.024435', '2022-11-29 21:24:17.024435', 63);
INSERT INTO public.users_shift VALUES (2, 32, '2022-12-02', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:17.024435', '2022-11-29 21:24:17.024435', 64);
INSERT INTO public.users_shift VALUES (1, 27, '2022-12-02', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:17.024435', '2022-11-29 21:24:17.024435', 65);
INSERT INTO public.users_shift VALUES (1, 27, '2022-12-02', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:17.024435', '2022-11-29 21:24:17.024435', 66);
INSERT INTO public.users_shift VALUES (2, 33, '2022-12-02', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:17.024435', '2022-11-29 21:24:17.024435', 67);
INSERT INTO public.users_shift VALUES (2, 33, '2022-12-02', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:17.024435', '2022-11-29 21:24:17.024435', 68);
INSERT INTO public.users_shift VALUES (2, 53, '2022-12-02', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:17.024435', '2022-11-29 21:24:17.024435', 69);
INSERT INTO public.users_shift VALUES (2, 53, '2022-12-02', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:17.024435', '2022-11-29 21:24:17.024435', 70);
INSERT INTO public.users_shift VALUES (2, 29, '2022-12-03', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:23.681639', '2022-11-29 21:24:23.681639', 73);
INSERT INTO public.users_shift VALUES (2, 29, '2022-12-03', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:23.681639', '2022-11-29 21:24:23.681639', 74);
INSERT INTO public.users_shift VALUES (2, 31, '2022-12-03', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:23.681639', '2022-11-29 21:24:23.681639', 75);
INSERT INTO public.users_shift VALUES (2, 31, '2022-12-03', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:23.681639', '2022-11-29 21:24:23.681639', 76);
INSERT INTO public.users_shift VALUES (3, 30, '2022-12-03', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:23.681639', '2022-11-29 21:24:23.681639', 77);
INSERT INTO public.users_shift VALUES (3, 30, '2022-12-03', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:23.681639', '2022-11-29 21:24:23.681639', 78);
INSERT INTO public.users_shift VALUES (2, 32, '2022-12-03', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:23.681639', '2022-11-29 21:24:23.681639', 79);
INSERT INTO public.users_shift VALUES (2, 32, '2022-12-03', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:23.681639', '2022-11-29 21:24:23.681639', 80);
INSERT INTO public.users_shift VALUES (1, 27, '2022-12-03', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:23.681639', '2022-11-29 21:24:23.681639', 81);
INSERT INTO public.users_shift VALUES (1, 27, '2022-12-03', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:23.681639', '2022-11-29 21:24:23.681639', 82);
INSERT INTO public.users_shift VALUES (2, 33, '2022-12-03', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:23.681639', '2022-11-29 21:24:23.681639', 83);
INSERT INTO public.users_shift VALUES (2, 33, '2022-12-03', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:23.681639', '2022-11-29 21:24:23.681639', 84);
INSERT INTO public.users_shift VALUES (2, 53, '2022-12-03', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:23.681639', '2022-11-29 21:24:23.681639', 85);
INSERT INTO public.users_shift VALUES (2, 53, '2022-12-03', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:23.681639', '2022-11-29 21:24:23.681639', 86);
INSERT INTO public.users_shift VALUES (2, 14, '2022-12-04', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:30.13063', '2022-11-29 21:24:30.13063', 87);
INSERT INTO public.users_shift VALUES (2, 14, '2022-12-04', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:30.13063', '2022-11-29 21:24:30.13063', 88);
INSERT INTO public.users_shift VALUES (2, 29, '2022-12-04', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:30.13063', '2022-11-29 21:24:30.13063', 89);
INSERT INTO public.users_shift VALUES (2, 29, '2022-12-04', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:30.13063', '2022-11-29 21:24:30.13063', 90);
INSERT INTO public.users_shift VALUES (2, 31, '2022-12-04', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:30.13063', '2022-11-29 21:24:30.13063', 91);
INSERT INTO public.users_shift VALUES (2, 31, '2022-12-04', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:30.13063', '2022-11-29 21:24:30.13063', 92);
INSERT INTO public.users_shift VALUES (3, 30, '2022-12-04', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:30.13063', '2022-11-29 21:24:30.13063', 93);
INSERT INTO public.users_shift VALUES (3, 30, '2022-12-04', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:30.13063', '2022-11-29 21:24:30.13063', 94);
INSERT INTO public.users_shift VALUES (2, 32, '2022-12-04', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:30.13063', '2022-11-29 21:24:30.13063', 95);
INSERT INTO public.users_shift VALUES (2, 32, '2022-12-04', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:30.13063', '2022-11-29 21:24:30.13063', 96);
INSERT INTO public.users_shift VALUES (1, 27, '2022-12-04', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:30.13063', '2022-11-29 21:24:30.13063', 97);
INSERT INTO public.users_shift VALUES (1, 27, '2022-12-04', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:30.13063', '2022-11-29 21:24:30.13063', 98);
INSERT INTO public.users_shift VALUES (2, 33, '2022-12-04', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:30.13063', '2022-11-29 21:24:30.13063', 99);
INSERT INTO public.users_shift VALUES (2, 33, '2022-12-04', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:30.13063', '2022-11-29 21:24:30.13063', 100);
INSERT INTO public.users_shift VALUES (2, 53, '2022-12-04', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:30.13063', '2022-11-29 21:24:30.13063', 101);
INSERT INTO public.users_shift VALUES (2, 53, '2022-12-04', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:30.13063', '2022-11-29 21:24:30.13063', 102);
INSERT INTO public.users_shift VALUES (2, 14, '2022-12-05', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:34.65448', '2022-11-29 21:24:34.65448', 103);
INSERT INTO public.users_shift VALUES (2, 14, '2022-12-05', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:34.65448', '2022-11-29 21:24:34.65448', 104);
INSERT INTO public.users_shift VALUES (2, 29, '2022-12-05', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:34.65448', '2022-11-29 21:24:34.65448', 105);
INSERT INTO public.users_shift VALUES (2, 29, '2022-12-05', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:34.65448', '2022-11-29 21:24:34.65448', 106);
INSERT INTO public.users_shift VALUES (2, 31, '2022-12-05', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:34.65448', '2022-11-29 21:24:34.65448', 107);
INSERT INTO public.users_shift VALUES (2, 31, '2022-12-05', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:34.65448', '2022-11-29 21:24:34.65448', 108);
INSERT INTO public.users_shift VALUES (3, 30, '2022-12-05', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:34.65448', '2022-11-29 21:24:34.65448', 109);
INSERT INTO public.users_shift VALUES (3, 30, '2022-12-05', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:34.65448', '2022-11-29 21:24:34.65448', 110);
INSERT INTO public.users_shift VALUES (2, 32, '2022-12-05', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:34.65448', '2022-11-29 21:24:34.65448', 111);
INSERT INTO public.users_shift VALUES (2, 32, '2022-12-05', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:34.65448', '2022-11-29 21:24:34.65448', 112);
INSERT INTO public.users_shift VALUES (1, 27, '2022-12-05', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:34.65448', '2022-11-29 21:24:34.65448', 113);
INSERT INTO public.users_shift VALUES (1, 27, '2022-12-05', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:34.65448', '2022-11-29 21:24:34.65448', 114);
INSERT INTO public.users_shift VALUES (2, 33, '2022-12-05', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:34.65448', '2022-11-29 21:24:34.65448', 115);
INSERT INTO public.users_shift VALUES (2, 33, '2022-12-05', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:34.65448', '2022-11-29 21:24:34.65448', 116);
INSERT INTO public.users_shift VALUES (2, 53, '2022-12-05', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:34.65448', '2022-11-29 21:24:34.65448', 117);
INSERT INTO public.users_shift VALUES (2, 53, '2022-12-05', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:34.65448', '2022-11-29 21:24:34.65448', 118);
INSERT INTO public.users_shift VALUES (2, 14, '2022-12-06', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:40.216835', '2022-11-29 21:24:40.216835', 119);
INSERT INTO public.users_shift VALUES (2, 14, '2022-12-06', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:40.216835', '2022-11-29 21:24:40.216835', 120);
INSERT INTO public.users_shift VALUES (2, 29, '2022-12-06', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:40.216835', '2022-11-29 21:24:40.216835', 121);
INSERT INTO public.users_shift VALUES (2, 29, '2022-12-06', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:40.216835', '2022-11-29 21:24:40.216835', 122);
INSERT INTO public.users_shift VALUES (2, 31, '2022-12-06', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:40.216835', '2022-11-29 21:24:40.216835', 123);
INSERT INTO public.users_shift VALUES (2, 31, '2022-12-06', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:40.216835', '2022-11-29 21:24:40.216835', 124);
INSERT INTO public.users_shift VALUES (3, 30, '2022-12-06', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:40.216835', '2022-11-29 21:24:40.216835', 125);
INSERT INTO public.users_shift VALUES (3, 30, '2022-12-06', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:40.216835', '2022-11-29 21:24:40.216835', 126);
INSERT INTO public.users_shift VALUES (2, 32, '2022-12-06', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:40.216835', '2022-11-29 21:24:40.216835', 127);
INSERT INTO public.users_shift VALUES (2, 32, '2022-12-06', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:40.216835', '2022-11-29 21:24:40.216835', 128);
INSERT INTO public.users_shift VALUES (1, 27, '2022-12-06', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:40.216835', '2022-11-29 21:24:40.216835', 129);
INSERT INTO public.users_shift VALUES (1, 27, '2022-12-06', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:40.216835', '2022-11-29 21:24:40.216835', 130);
INSERT INTO public.users_shift VALUES (2, 33, '2022-12-06', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:40.216835', '2022-11-29 21:24:40.216835', 131);
INSERT INTO public.users_shift VALUES (2, 33, '2022-12-06', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:40.216835', '2022-11-29 21:24:40.216835', 132);
INSERT INTO public.users_shift VALUES (2, 53, '2022-12-06', 2, 'Shift II Sore', '15:00:00', '21:00:00', '', '2022-11-29 21:24:40.216835', '2022-11-29 21:24:40.216835', 133);
INSERT INTO public.users_shift VALUES (2, 53, '2022-12-06', 1, 'Shift I Pagi', '08:00:00', '15:00:00', '', '2022-11-29 21:24:40.216835', '2022-11-29 21:24:40.216835', 134);


--
-- TOC entry 3991 (class 0 OID 16771)
-- Dependencies: 293
-- Data for Name: users_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users_skills VALUES (2, 40, 54, 'Failed', '2022-08-21', NULL, 1, '2022-08-21 09:29:19.91552');
INSERT INTO public.users_skills VALUES (2, 48, 54, 'In Training', '2022-08-26', NULL, 1, '2022-08-21 10:08:40.959154');
INSERT INTO public.users_skills VALUES (27, 69, 54, 'Pass', '2022-11-15', NULL, 1, '2022-11-15 20:15:08.684723');


--
-- TOC entry 3992 (class 0 OID 16778)
-- Dependencies: 294
-- Data for Name: voucher; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.voucher VALUES (4, 'TESTAAVC23', 1, '2022-09-18', '2022-09-23', 0, '2022-09-18 01:22:56', 1, '2022-09-18 01:22:42', 18, 50, 'test Voucher');
INSERT INTO public.voucher VALUES (5, 'CSSKR', 1, '2022-09-05', '2022-09-20', 0, '2022-09-18 01:23:32', 1, '2022-09-18 01:23:32', 1, 50, 'TEst II');
INSERT INTO public.voucher VALUES (1, 'ABC', 1, '2022-09-01', '2022-10-30', 0, '2022-09-26 12:21:12', 1, '2022-09-17 12:45:52.973274', 1, 100, 'VOUCHER 100%');


--
-- TOC entry 4043 (class 0 OID 0)
-- Dependencies: 215
-- Name: branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_id_seq', 11, true);


--
-- TOC entry 4044 (class 0 OID 0)
-- Dependencies: 217
-- Name: branch_room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_room_id_seq', 13, true);


--
-- TOC entry 4045 (class 0 OID 0)
-- Dependencies: 219
-- Name: company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.company_id_seq', 1, true);


--
-- TOC entry 4046 (class 0 OID 0)
-- Dependencies: 221
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_id_seq', 18, true);


--
-- TOC entry 4047 (class 0 OID 0)
-- Dependencies: 223
-- Name: department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.department_id_seq', 10, true);


--
-- TOC entry 4048 (class 0 OID 0)
-- Dependencies: 225
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- TOC entry 4049 (class 0 OID 0)
-- Dependencies: 228
-- Name: invoice_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invoice_master_id_seq', 72, true);


--
-- TOC entry 4050 (class 0 OID 0)
-- Dependencies: 230
-- Name: job_title_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);


--
-- TOC entry 4051 (class 0 OID 0)
-- Dependencies: 232
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);


--
-- TOC entry 4052 (class 0 OID 0)
-- Dependencies: 237
-- Name: order_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_master_id_seq', 109, true);


--
-- TOC entry 4053 (class 0 OID 0)
-- Dependencies: 298
-- Name: period_price_sell_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.period_price_sell_id_seq', 663, true);


--
-- TOC entry 4054 (class 0 OID 0)
-- Dependencies: 242
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 353, true);


--
-- TOC entry 4055 (class 0 OID 0)
-- Dependencies: 244
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);


--
-- TOC entry 4056 (class 0 OID 0)
-- Dependencies: 247
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 2, true);


--
-- TOC entry 4057 (class 0 OID 0)
-- Dependencies: 249
-- Name: price_adjustment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.price_adjustment_id_seq', 6, true);


--
-- TOC entry 4058 (class 0 OID 0)
-- Dependencies: 251
-- Name: product_brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_brand_id_seq', 9, true);


--
-- TOC entry 4059 (class 0 OID 0)
-- Dependencies: 253
-- Name: product_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_category_id_seq', 15, true);


--
-- TOC entry 4060 (class 0 OID 0)
-- Dependencies: 261
-- Name: product_sku_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_sku_id_seq', 89, true);


--
-- TOC entry 4061 (class 0 OID 0)
-- Dependencies: 264
-- Name: product_stock_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 23, true);


--
-- TOC entry 4062 (class 0 OID 0)
-- Dependencies: 266
-- Name: product_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);


--
-- TOC entry 4063 (class 0 OID 0)
-- Dependencies: 269
-- Name: product_uom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_uom_id_seq', 24, true);


--
-- TOC entry 4064 (class 0 OID 0)
-- Dependencies: 272
-- Name: purchase_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_master_id_seq', 17, true);


--
-- TOC entry 4065 (class 0 OID 0)
-- Dependencies: 275
-- Name: receive_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.receive_master_id_seq', 23, true);


--
-- TOC entry 4066 (class 0 OID 0)
-- Dependencies: 300
-- Name: return_sell_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);


--
-- TOC entry 4067 (class 0 OID 0)
-- Dependencies: 278
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 11, true);


--
-- TOC entry 4068 (class 0 OID 0)
-- Dependencies: 296
-- Name: setting_document_counter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 21, true);


--
-- TOC entry 4069 (class 0 OID 0)
-- Dependencies: 281
-- Name: shift_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shift_id_seq', 9, true);


--
-- TOC entry 4070 (class 0 OID 0)
-- Dependencies: 283
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 4, true);


--
-- TOC entry 4071 (class 0 OID 0)
-- Dependencies: 287
-- Name: users_experience_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);


--
-- TOC entry 4072 (class 0 OID 0)
-- Dependencies: 288
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 54, true);


--
-- TOC entry 4073 (class 0 OID 0)
-- Dependencies: 290
-- Name: users_mutation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_mutation_id_seq', 40, true);


--
-- TOC entry 4074 (class 0 OID 0)
-- Dependencies: 292
-- Name: users_shift_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);


--
-- TOC entry 4075 (class 0 OID 0)
-- Dependencies: 295
-- Name: voucher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.voucher_id_seq', 5, true);


--
-- TOC entry 3615 (class 2606 OID 16818)
-- Name: branch branch_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);


--
-- TOC entry 3619 (class 2606 OID 16820)
-- Name: branch_room branch_room_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);


--
-- TOC entry 3617 (class 2606 OID 16822)
-- Name: branch branch_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);


--
-- TOC entry 3621 (class 2606 OID 16824)
-- Name: company company_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);


--
-- TOC entry 3623 (class 2606 OID 16826)
-- Name: customers customers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);


--
-- TOC entry 3625 (class 2606 OID 16828)
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- TOC entry 3627 (class 2606 OID 16830)
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- TOC entry 3629 (class 2606 OID 16832)
-- Name: invoice_detail invoice_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);


--
-- TOC entry 3631 (class 2606 OID 16834)
-- Name: invoice_master invoice_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);


--
-- TOC entry 3633 (class 2606 OID 16836)
-- Name: invoice_master invoice_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);


--
-- TOC entry 3635 (class 2606 OID 16838)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3638 (class 2606 OID 16840)
-- Name: model_has_permissions model_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);


--
-- TOC entry 3641 (class 2606 OID 16842)
-- Name: model_has_roles model_has_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);


--
-- TOC entry 3643 (class 2606 OID 16844)
-- Name: order_detail order_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);


--
-- TOC entry 3645 (class 2606 OID 16846)
-- Name: order_master order_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);


--
-- TOC entry 3647 (class 2606 OID 16848)
-- Name: order_master order_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);


--
-- TOC entry 3650 (class 2606 OID 16850)
-- Name: period_stock period_stock_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);


--
-- TOC entry 3652 (class 2606 OID 16854)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3654 (class 2606 OID 16856)
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3656 (class 2606 OID 16858)
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- TOC entry 3659 (class 2606 OID 16860)
-- Name: point_conversion point_conversion_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);


--
-- TOC entry 3661 (class 2606 OID 16862)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- TOC entry 3663 (class 2606 OID 16864)
-- Name: price_adjustment price_adjustment_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);


--
-- TOC entry 3665 (class 2606 OID 16866)
-- Name: price_adjustment price_adjustment_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);


--
-- TOC entry 3667 (class 2606 OID 16868)
-- Name: product_commision_by_year product_commision_by_year_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);


--
-- TOC entry 3669 (class 2606 OID 16870)
-- Name: product_commisions product_commisions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3671 (class 2606 OID 16872)
-- Name: product_distribution product_distribution_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3673 (class 2606 OID 16874)
-- Name: product_ingredients product_ingredients_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pk PRIMARY KEY (product_id, product_id_material);


--
-- TOC entry 3675 (class 2606 OID 16876)
-- Name: product_point product_point_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3677 (class 2606 OID 16878)
-- Name: product_price product_price_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3679 (class 2606 OID 16880)
-- Name: product_sku product_sku_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);


--
-- TOC entry 3681 (class 2606 OID 16882)
-- Name: product_sku product_sku_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_un UNIQUE (abbr);


--
-- TOC entry 3685 (class 2606 OID 16884)
-- Name: product_stock_detail product_stock_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock_detail
    ADD CONSTRAINT product_stock_detail_pk PRIMARY KEY (id);


--
-- TOC entry 3683 (class 2606 OID 16886)
-- Name: product_stock product_stock_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3687 (class 2606 OID 16888)
-- Name: product_uom product_uom_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_pk PRIMARY KEY (product_id, uom_id);


--
-- TOC entry 3693 (class 2606 OID 16890)
-- Name: purchase_detail purchase_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_pk PRIMARY KEY (purchase_no, product_id);


--
-- TOC entry 3695 (class 2606 OID 16892)
-- Name: purchase_master purchase_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_pk PRIMARY KEY (id);


--
-- TOC entry 3697 (class 2606 OID 16894)
-- Name: purchase_master purchase_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_un UNIQUE (purchase_no);


--
-- TOC entry 3699 (class 2606 OID 16896)
-- Name: receive_detail receive_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_pk PRIMARY KEY (receive_no, product_id, expired_at);


--
-- TOC entry 3701 (class 2606 OID 16898)
-- Name: receive_master receive_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_pk PRIMARY KEY (id);


--
-- TOC entry 3703 (class 2606 OID 16900)
-- Name: receive_master receive_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_un UNIQUE (receive_no);


--
-- TOC entry 3743 (class 2606 OID 17123)
-- Name: return_sell_detail return_sell_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_pk PRIMARY KEY (return_sell_no, product_id);


--
-- TOC entry 3739 (class 2606 OID 17098)
-- Name: return_sell_master return_sell_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_pk PRIMARY KEY (id);


--
-- TOC entry 3741 (class 2606 OID 17100)
-- Name: return_sell_master return_sell_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_un UNIQUE (return_sell_no);


--
-- TOC entry 3705 (class 2606 OID 16902)
-- Name: role_has_permissions role_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);


--
-- TOC entry 3707 (class 2606 OID 16904)
-- Name: roles roles_name_guard_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);


--
-- TOC entry 3709 (class 2606 OID 16906)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3735 (class 2606 OID 17070)
-- Name: setting_document_counter setting_document_counter_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_pk PRIMARY KEY (id);


--
-- TOC entry 3737 (class 2606 OID 17072)
-- Name: setting_document_counter setting_document_counter_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_un UNIQUE (doc_type, branch_id);


--
-- TOC entry 3711 (class 2606 OID 16908)
-- Name: settings settings_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (company_name, app_name);


--
-- TOC entry 3713 (class 2606 OID 16910)
-- Name: shift shift_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pk PRIMARY KEY (time_start, time_end);


--
-- TOC entry 3715 (class 2606 OID 16912)
-- Name: suppliers suppliers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pk PRIMARY KEY (id);


--
-- TOC entry 3689 (class 2606 OID 16914)
-- Name: uom uom_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);


--
-- TOC entry 3691 (class 2606 OID 16916)
-- Name: uom uom_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_un UNIQUE (remark);


--
-- TOC entry 3723 (class 2606 OID 16918)
-- Name: users_branch users_branch_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_branch
    ADD CONSTRAINT users_branch_pk PRIMARY KEY (user_id, branch_id);


--
-- TOC entry 3717 (class 2606 OID 16920)
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- TOC entry 3725 (class 2606 OID 16922)
-- Name: users_experience users_experience_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_experience
    ADD CONSTRAINT users_experience_pk PRIMARY KEY (id);


--
-- TOC entry 3727 (class 2606 OID 16924)
-- Name: users_mutation users_mutation_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_mutation
    ADD CONSTRAINT users_mutation_pk PRIMARY KEY (id);


--
-- TOC entry 3719 (class 2606 OID 16926)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3729 (class 2606 OID 16928)
-- Name: users_shift users_shift_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_shift
    ADD CONSTRAINT users_shift_pk PRIMARY KEY (branch_id, users_id, dated, shift_id);


--
-- TOC entry 3731 (class 2606 OID 16930)
-- Name: users_skills users_skills_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_pk PRIMARY KEY (users_id, modul, dated, status);


--
-- TOC entry 3721 (class 2606 OID 16932)
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- TOC entry 3733 (class 2606 OID 16934)
-- Name: voucher voucher_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voucher
    ADD CONSTRAINT voucher_pk PRIMARY KEY (voucher_code, branch_id);


--
-- TOC entry 3636 (class 1259 OID 16935)
-- Name: model_has_permissions_model_id_model_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);


--
-- TOC entry 3639 (class 1259 OID 16936)
-- Name: model_has_roles_model_id_model_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);


--
-- TOC entry 3648 (class 1259 OID 16937)
-- Name: password_resets_email_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);


--
-- TOC entry 3657 (class 1259 OID 16938)
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- TOC entry 3744 (class 2606 OID 16939)
-- Name: branch_room branch_room_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3745 (class 2606 OID 16944)
-- Name: invoice_detail invoice_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);


--
-- TOC entry 3746 (class 2606 OID 16949)
-- Name: invoice_master invoice_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3747 (class 2606 OID 16954)
-- Name: invoice_master invoice_master_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);


--
-- TOC entry 3748 (class 2606 OID 16959)
-- Name: model_has_permissions model_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 3749 (class 2606 OID 16964)
-- Name: model_has_roles model_has_roles_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 3750 (class 2606 OID 16969)
-- Name: order_detail order_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);


--
-- TOC entry 3751 (class 2606 OID 16974)
-- Name: order_master order_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3752 (class 2606 OID 16979)
-- Name: order_master order_master_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);


--
-- TOC entry 3753 (class 2606 OID 16984)
-- Name: posts posts_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3754 (class 2606 OID 16989)
-- Name: product_commision_by_year product_commision_by_year_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3755 (class 2606 OID 16994)
-- Name: product_commision_by_year product_commision_by_year_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3756 (class 2606 OID 16999)
-- Name: product_commision_by_year product_commision_by_year_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3757 (class 2606 OID 17004)
-- Name: product_distribution product_distribution_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3758 (class 2606 OID 17009)
-- Name: product_distribution product_distribution_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3759 (class 2606 OID 17014)
-- Name: product_uom product_uom_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3760 (class 2606 OID 17019)
-- Name: purchase_detail purchase_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);


--
-- TOC entry 3761 (class 2606 OID 17024)
-- Name: purchase_master purchase_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3762 (class 2606 OID 17029)
-- Name: receive_detail receive_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);


--
-- TOC entry 3763 (class 2606 OID 17034)
-- Name: receive_master receive_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3769 (class 2606 OID 17124)
-- Name: return_sell_detail return_sell_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);


--
-- TOC entry 3767 (class 2606 OID 17101)
-- Name: return_sell_master return_sell_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3768 (class 2606 OID 17106)
-- Name: return_sell_master return_sell_master_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);


--
-- TOC entry 3764 (class 2606 OID 17039)
-- Name: role_has_permissions role_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 3765 (class 2606 OID 17044)
-- Name: role_has_permissions role_has_permissions_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 3766 (class 2606 OID 17049)
-- Name: users_skills users_skills_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);


-- Completed on 2022-12-16 19:30:04

--
-- PostgreSQL database dump complete
--

