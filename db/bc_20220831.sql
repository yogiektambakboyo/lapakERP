--
-- PostgreSQL database dump
--

-- Dumped from database version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)

-- Started on 2022-08-31 23:01:24 WIB

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 226 (class 1259 OID 17974)
-- Name: branch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.branch (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    address character varying NOT NULL,
    city character varying NOT NULL,
    abbr character varying NOT NULL,
    active bit(1) DEFAULT '1'::"bit" NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.branch OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 17972)
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
-- TOC entry 3568 (class 0 OID 0)
-- Dependencies: 225
-- Name: branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.branch_id_seq OWNED BY public.branch.id;


--
-- TOC entry 250 (class 1259 OID 18186)
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
-- TOC entry 249 (class 1259 OID 18184)
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
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 249
-- Name: branch_room_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.branch_room_id_seq OWNED BY public.branch_room.id;


--
-- TOC entry 273 (class 1259 OID 18696)
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
-- TOC entry 272 (class 1259 OID 18694)
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
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 272
-- Name: company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.company_id_seq OWNED BY public.company.id;


--
-- TOC entry 232 (class 1259 OID 18011)
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
-- TOC entry 231 (class 1259 OID 18009)
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
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 231
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- TOC entry 224 (class 1259 OID 17963)
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    active bit(1) DEFAULT '1'::"bit" NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17961)
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
-- TOC entry 3572 (class 0 OID 0)
-- Dependencies: 223
-- Name: department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.department_id_seq OWNED BY public.departments.id;


--
-- TOC entry 208 (class 1259 OID 17828)
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
-- TOC entry 207 (class 1259 OID 17826)
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
-- TOC entry 3573 (class 0 OID 0)
-- Dependencies: 207
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- TOC entry 258 (class 1259 OID 18306)
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
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.invoice_detail OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 18262)
-- Name: invoice_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invoice_master (
    id bigint NOT NULL,
    invoice_no character varying NOT NULL,
    dated date DEFAULT (now())::date NOT NULL,
    customers_id integer NOT NULL,
    is_canceled bit(1) DEFAULT '0'::"bit" NOT NULL,
    total numeric(18,0) DEFAULT 0 NOT NULL,
    tax numeric(18,0) DEFAULT 0 NOT NULL,
    total_payment numeric(18,0) DEFAULT 0 NOT NULL,
    total_discount numeric(18,0) DEFAULT 0 NOT NULL,
    remark character varying,
    payment_type character varying NOT NULL,
    payment_nominal numeric(18,0) DEFAULT 0 NOT NULL,
    is_checkout bit(1) DEFAULT '0'::"bit" NOT NULL,
    voucher_code character varying,
    scheduled_at timestamp without time zone DEFAULT now() NOT NULL,
    branch_room_id integer NOT NULL,
    ref_no character varying,
    updated_by integer,
    printed_at timestamp without time zone,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.invoice_master OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 18260)
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
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 256
-- Name: invoice_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.invoice_master_id_seq OWNED BY public.invoice_master.id;


--
-- TOC entry 222 (class 1259 OID 17951)
-- Name: job_title; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_title (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    active bit(1) DEFAULT '1'::"bit" NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.job_title OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17949)
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
-- TOC entry 3575 (class 0 OID 0)
-- Dependencies: 221
-- Name: job_title_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.job_title_id_seq OWNED BY public.job_title.id;


--
-- TOC entry 203 (class 1259 OID 17798)
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 17796)
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
-- TOC entry 3576 (class 0 OID 0)
-- Dependencies: 202
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- TOC entry 215 (class 1259 OID 17880)
-- Name: model_has_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.model_has_permissions (
    permission_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);


ALTER TABLE public.model_has_permissions OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 17891)
-- Name: model_has_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.model_has_roles (
    role_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);


ALTER TABLE public.model_has_roles OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 18045)
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
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.order_detail OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 18001)
-- Name: order_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_master (
    id bigint NOT NULL,
    order_no character varying NOT NULL,
    dated date DEFAULT (now())::date NOT NULL,
    customers_id integer NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    is_canceled bit(1) DEFAULT '0'::"bit" NOT NULL,
    total numeric(18,0) DEFAULT 0 NOT NULL,
    tax numeric(18,0) DEFAULT 0 NOT NULL,
    total_payment numeric(18,0) DEFAULT 0 NOT NULL,
    total_discount numeric(18,0) DEFAULT 0 NOT NULL,
    remark character varying,
    payment_type character varying NOT NULL,
    payment_nominal numeric(18,0) DEFAULT 0 NOT NULL,
    is_checkout bit(1) DEFAULT '0'::"bit" NOT NULL,
    voucher_code character varying,
    printed_at timestamp without time zone,
    updated_at timestamp without time zone,
    updated_by integer,
    scheduled_at timestamp without time zone DEFAULT now() NOT NULL,
    branch_room_id integer NOT NULL
);


ALTER TABLE public.order_master OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17999)
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
-- TOC entry 3577 (class 0 OID 0)
-- Dependencies: 229
-- Name: order_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_master_id_seq OWNED BY public.order_master.id;


--
-- TOC entry 206 (class 1259 OID 17819)
-- Name: password_resets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_resets (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_resets OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 18121)
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
-- TOC entry 266 (class 1259 OID 18501)
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
-- TOC entry 212 (class 1259 OID 17856)
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
-- TOC entry 211 (class 1259 OID 17854)
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
-- TOC entry 3578 (class 0 OID 0)
-- Dependencies: 211
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- TOC entry 210 (class 1259 OID 17842)
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
-- TOC entry 209 (class 1259 OID 17840)
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
-- TOC entry 3579 (class 0 OID 0)
-- Dependencies: 209
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- TOC entry 219 (class 1259 OID 17919)
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
-- TOC entry 218 (class 1259 OID 17917)
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
-- TOC entry 3580 (class 0 OID 0)
-- Dependencies: 218
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- TOC entry 237 (class 1259 OID 18076)
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
-- TOC entry 236 (class 1259 OID 18074)
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
-- TOC entry 3581 (class 0 OID 0)
-- Dependencies: 236
-- Name: product_brand_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_brand_id_seq OWNED BY public.product_brand.id;


--
-- TOC entry 239 (class 1259 OID 18086)
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
-- TOC entry 238 (class 1259 OID 18084)
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
-- TOC entry 3582 (class 0 OID 0)
-- Dependencies: 238
-- Name: product_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;


--
-- TOC entry 248 (class 1259 OID 18163)
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
-- TOC entry 246 (class 1259 OID 18143)
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
-- TOC entry 240 (class 1259 OID 18094)
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
-- TOC entry 247 (class 1259 OID 18157)
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
-- TOC entry 241 (class 1259 OID 18115)
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
-- TOC entry 235 (class 1259 OID 18065)
-- Name: product_sku; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_sku (
    id bigint NOT NULL,
    remark character varying NOT NULL,
    abbr character varying NOT NULL,
    alias_code character varying,
    barcode character varying,
    active bit(1) DEFAULT '1'::"bit" NOT NULL,
    category_id integer NOT NULL,
    type_id integer NOT NULL,
    brand_id integer NOT NULL,
    updated_at timestamp without time zone,
    updated_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer NOT NULL,
    vat numeric(10,0) DEFAULT 0.0 NOT NULL
);


ALTER TABLE public.product_sku OWNER TO postgres;

--
-- TOC entry 3583 (class 0 OID 0)
-- Dependencies: 235
-- Name: COLUMN product_sku.type_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_sku.type_id IS '''Product/Service''';


--
-- TOC entry 234 (class 1259 OID 18063)
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
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 234
-- Name: product_sku_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_sku_id_seq OWNED BY public.product_sku.id;


--
-- TOC entry 255 (class 1259 OID 18253)
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
-- TOC entry 265 (class 1259 OID 18492)
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
-- TOC entry 264 (class 1259 OID 18490)
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
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 264
-- Name: product_stock_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_stock_detail_id_seq OWNED BY public.product_stock_detail.id;


--
-- TOC entry 252 (class 1259 OID 18208)
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
-- TOC entry 251 (class 1259 OID 18206)
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
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 251
-- Name: product_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_type_id_seq OWNED BY public.product_type.id;


--
-- TOC entry 253 (class 1259 OID 18216)
-- Name: product_uom; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_uom (
    product_id integer NOT NULL,
    uom_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    create_by integer
);


ALTER TABLE public.product_uom OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 18134)
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
-- TOC entry 244 (class 1259 OID 18132)
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
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 244
-- Name: product_uom_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_uom_id_seq OWNED BY public.uom.id;


--
-- TOC entry 271 (class 1259 OID 18669)
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
-- TOC entry 270 (class 1259 OID 18620)
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
    is_canceled bit(1) DEFAULT '0'::"bit" NOT NULL,
    total numeric(18,0) DEFAULT 0 NOT NULL,
    total_vat numeric(18,0) DEFAULT 0 NOT NULL,
    total_payment numeric(18,0) DEFAULT 0 NOT NULL,
    total_discount numeric(18,0) DEFAULT 0 NOT NULL,
    remark character varying,
    payment_type character varying,
    payment_nominal numeric(18,0) DEFAULT 0 NOT NULL,
    is_receive bit(1) DEFAULT '0'::"bit" NOT NULL,
    scheduled_at timestamp without time zone DEFAULT now() NOT NULL,
    ref_no character varying,
    printed_at timestamp without time zone,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.purchase_master OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 18618)
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
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 269
-- Name: purchase_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_master_id_seq OWNED BY public.purchase_master.id;


--
-- TOC entry 263 (class 1259 OID 18449)
-- Name: receive_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receive_detail (
    receive_no character varying NOT NULL,
    product_id integer NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    price numeric(18,0) DEFAULT 0 NOT NULL,
    total numeric(18,0) DEFAULT 0 NOT NULL,
    discount numeric(18,0) DEFAULT 0 NOT NULL,
    seq smallint DEFAULT 0 NOT NULL,
    expired_at date DEFAULT (now() + '1 year'::interval) NOT NULL,
    batch_no character varying,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.receive_detail OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 18423)
-- Name: receive_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receive_master (
    id bigint NOT NULL,
    receive_no character varying NOT NULL,
    dated date DEFAULT (now())::date NOT NULL,
    supplier_id integer NOT NULL,
    is_canceled bit(1) DEFAULT '0'::"bit" NOT NULL,
    total numeric(18,0) DEFAULT 0 NOT NULL,
    tax numeric(18,0) DEFAULT 0 NOT NULL,
    total_payment numeric(18,0) DEFAULT 0 NOT NULL,
    total_discount numeric(18,0) DEFAULT 0 NOT NULL,
    remark character varying,
    payment_type character varying,
    payment_nominal numeric(18,0) DEFAULT 0 NOT NULL,
    is_receive bit(1) DEFAULT '0'::"bit" NOT NULL,
    scheduled_at timestamp without time zone DEFAULT now() NOT NULL,
    branch_id integer NOT NULL,
    ref_no character varying,
    updated_by integer,
    printed_at timestamp without time zone,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.receive_master OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 18421)
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
-- TOC entry 3589 (class 0 OID 0)
-- Dependencies: 261
-- Name: receive_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;


--
-- TOC entry 217 (class 1259 OID 17902)
-- Name: role_has_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_has_permissions (
    permission_id bigint NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE public.role_has_permissions OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 17869)
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
-- TOC entry 213 (class 1259 OID 17867)
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
-- TOC entry 3590 (class 0 OID 0)
-- Dependencies: 213
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 243 (class 1259 OID 18128)
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
-- TOC entry 260 (class 1259 OID 18334)
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    id bigint NOT NULL,
    name character varying,
    address character varying,
    branch_id integer NOT NULL,
    email character varying,
    handphone character varying
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 18332)
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
-- TOC entry 3591 (class 0 OID 0)
-- Dependencies: 259
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;


--
-- TOC entry 205 (class 1259 OID 17806)
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
    active bit(1) DEFAULT '1'::"bit" NOT NULL,
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
    employee_status character varying
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 18231)
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
-- TOC entry 268 (class 1259 OID 18535)
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
-- TOC entry 267 (class 1259 OID 18533)
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
-- TOC entry 3592 (class 0 OID 0)
-- Dependencies: 267
-- Name: users_experience_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;


--
-- TOC entry 204 (class 1259 OID 17804)
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
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 204
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 228 (class 1259 OID 17989)
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
-- TOC entry 227 (class 1259 OID 17987)
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
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 227
-- Name: users_mutation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;


--
-- TOC entry 220 (class 1259 OID 17935)
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
-- TOC entry 3113 (class 2604 OID 17977)
-- Name: branch id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);


--
-- TOC entry 3155 (class 2604 OID 18189)
-- Name: branch_room id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);


--
-- TOC entry 3232 (class 2604 OID 18699)
-- Name: company id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);


--
-- TOC entry 3129 (class 2604 OID 18014)
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- TOC entry 3110 (class 2604 OID 17966)
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);


--
-- TOC entry 3099 (class 2604 OID 17831)
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- TOC entry 3163 (class 2604 OID 18265)
-- Name: invoice_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);


--
-- TOC entry 3107 (class 2604 OID 17954)
-- Name: job_title id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);


--
-- TOC entry 3095 (class 2604 OID 17801)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 3118 (class 2604 OID 18004)
-- Name: order_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master ALTER COLUMN id SET DEFAULT nextval('public.order_master_id_seq'::regclass);


--
-- TOC entry 3102 (class 2604 OID 17859)
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- TOC entry 3101 (class 2604 OID 17845)
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- TOC entry 3104 (class 2604 OID 17922)
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- TOC entry 3142 (class 2604 OID 18079)
-- Name: product_brand id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_brand ALTER COLUMN id SET DEFAULT nextval('public.product_brand_id_seq'::regclass);


--
-- TOC entry 3144 (class 2604 OID 18089)
-- Name: product_category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);


--
-- TOC entry 3138 (class 2604 OID 18068)
-- Name: product_sku id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku ALTER COLUMN id SET DEFAULT nextval('public.product_sku_id_seq'::regclass);


--
-- TOC entry 3199 (class 2604 OID 18495)
-- Name: product_stock_detail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock_detail ALTER COLUMN id SET DEFAULT nextval('public.product_stock_detail_id_seq'::regclass);


--
-- TOC entry 3157 (class 2604 OID 18211)
-- Name: product_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_type ALTER COLUMN id SET DEFAULT nextval('public.product_type_id_seq'::regclass);


--
-- TOC entry 3212 (class 2604 OID 18623)
-- Name: purchase_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master ALTER COLUMN id SET DEFAULT nextval('public.purchase_master_id_seq'::regclass);


--
-- TOC entry 3181 (class 2604 OID 18426)
-- Name: receive_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);


--
-- TOC entry 3103 (class 2604 OID 17872)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 3180 (class 2604 OID 18337)
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- TOC entry 3151 (class 2604 OID 18137)
-- Name: uom id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);


--
-- TOC entry 3096 (class 2604 OID 17809)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3210 (class 2604 OID 18538)
-- Name: users_experience id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_experience ALTER COLUMN id SET DEFAULT nextval('public.users_experience_id_seq'::regclass);


--
-- TOC entry 3116 (class 2604 OID 17992)
-- Name: users_mutation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_mutation ALTER COLUMN id SET DEFAULT nextval('public.users_mutation_id_seq'::regclass);


--
-- TOC entry 3515 (class 0 OID 17974)
-- Dependencies: 226
-- Data for Name: branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.branch VALUES (1, 'HEAD QUARTER', 'Jalan Jakarta no 3', 'Jakarta', 'HQ00', B'1', '2022-06-01 19:46:05.452925', NULL);
INSERT INTO public.branch VALUES (2, 'OUTLET 01', 'Jalan Lampung No 23', 'Jakarta', 'OL01', B'1', '2022-06-01 19:46:05.452925', NULL);
INSERT INTO public.branch VALUES (3, 'OUTLET 02', 'Jalan Sumatera No 88', 'Sumatera', 'OL02', B'1', '2022-06-01 19:46:05.452925', NULL);


--
-- TOC entry 3539 (class 0 OID 18186)
-- Dependencies: 250
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
-- TOC entry 3562 (class 0 OID 18696)
-- Dependencies: 273
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.company VALUES (1, 'Kakiku', 'Gading Serpong', 'tangerang', 'admin@kakiku.com', '031-332222', 'Logo_512.png', NULL, '2022-08-30 22:06:56.025994');


--
-- TOC entry 3521 (class 0 OID 18011)
-- Dependencies: 232
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.customers VALUES (1, 'UMUM', 'UMUM', '6285746879090', 1, 'OT01-UM', 2, '2022-06-02 20:38:02.11776', NULL);
INSERT INTO public.customers VALUES (4, 'UMUM', 'UMUM', '6285746879090', 1, 'OT02-UM', 3, '2022-06-02 20:38:02.11776', NULL);
INSERT INTO public.customers VALUES (12, 'Test Name', 'Test Address', 'Test Phone', 1, '1', 2, '2022-08-10 07:51:57', '2022-08-10 07:51:57');
INSERT INTO public.customers VALUES (13, 'Test Hr', 'Test Hr', '08573434', 1, '1', 2, '2022-08-10 08:01:40', '2022-08-10 08:01:40');
INSERT INTO public.customers VALUES (14, 'Test 2', 'Cirebon', '085746879090', 1, '1', 2, '2022-08-10 08:29:16', '2022-08-10 08:29:16');
INSERT INTO public.customers VALUES (15, 'Wkwk', 'KWKk', '02323`', 1, '1', 2, '2022-08-10 08:29:35', '2022-08-10 08:29:35');
INSERT INTO public.customers VALUES (16, 'Gor', 'Gorw', '08574644', 1, '1', 2, '2022-08-10 08:30:23', '2022-08-10 08:30:23');
INSERT INTO public.customers VALUES (17, 'Memp', 'Jalan Karangn', '08576443', 1, '1', 2, '2022-08-10 08:32:39', '2022-08-10 08:32:39');


--
-- TOC entry 3513 (class 0 OID 17963)
-- Dependencies: 224
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.departments VALUES (2, 'OPERASIONAL', B'1', '2022-06-01 19:49:58.185846', NULL);
INSERT INTO public.departments VALUES (3, 'FINANCE', B'1', '2022-06-01 19:49:58.185846', NULL);
INSERT INTO public.departments VALUES (4, 'HR', B'1', '2022-06-01 19:49:58.185846', NULL);
INSERT INTO public.departments VALUES (5, 'IT', B'1', '2022-06-01 19:49:58.185846', NULL);
INSERT INTO public.departments VALUES (1, 'SALES', B'1', '2022-06-01 19:49:58.185846', NULL);
INSERT INTO public.departments VALUES (6, 'MANAGEMENT', B'1', '2022-06-01 19:49:58.185846', NULL);
INSERT INTO public.departments VALUES (9, 'TRAINING', B'1', '2022-08-06 23:00:27', '2022-08-06 23:00:27');


--
-- TOC entry 3497 (class 0 OID 17828)
-- Dependencies: 208
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3547 (class 0 OID 18306)
-- Dependencies: 258
-- Data for Name: invoice_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000001', 1, 2, 150000, 300000, 0, 0, 14, 1, '2022-07-25 11:43:19', '2022-07-25 11:43:19');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000001', 66, 3, 70000, 210000, 0, 1, 14, 1, '2022-07-25 11:43:19', '2022-07-25 11:43:19');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000001', 56, 1, 100000, 100000, 0, 2, 14, 1, '2022-07-25 11:43:19', '2022-07-25 11:43:19');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000001', 5, 2, 175000, 350000, 0, 3, 14, 1, '2022-07-25 11:43:19', '2022-07-25 11:43:19');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000016', 54, 1, 160000, 160000, 0, 0, 14, 1, '2022-07-25 11:44:37', '2022-07-25 11:44:37');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000016', 51, 2, 80000, 160000, 0, 1, 14, 1, '2022-07-25 11:44:37', '2022-07-25 11:44:37');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000016', 49, 2, 160000, 320000, 0, 2, 14, 1, '2022-07-25 11:44:37', '2022-07-25 11:44:37');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000016', 52, 1, 70000, 70000, 0, 3, 14, 1, '2022-07-25 11:44:37', '2022-07-25 11:44:37');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000016', 61, 2, 80000, 160000, 0, 4, 14, 1, '2022-07-25 11:44:37', '2022-07-25 11:44:37');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000016', 34, 3, 40000, 120000, 0, 5, 14, 1, '2022-07-25 11:44:37', '2022-07-25 11:44:37');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000017', 2, 3, 20000, 60000, 0, 0, 14, 1, '2022-07-31 11:45:37', '2022-07-31 11:45:37');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000017', 3, 3, 250000, 750000, 0, 1, 14, 1, '2022-07-31 11:45:37', '2022-07-31 11:45:37');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000017', 10, 3, 60000, 180000, 0, 2, 27, 1, '2022-07-31 11:45:37', '2022-07-31 11:45:37');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000017', 12, 2, 65000, 130000, 0, 3, 31, 1, '2022-07-31 11:45:37', '2022-07-31 11:45:37');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000017', 13, 2, 40000, 80000, 0, 4, 31, 1, '2022-07-31 11:45:37', '2022-07-31 11:45:37');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000017', 20, 4, 100000, 400000, 0, 5, 27, 1, '2022-07-31 11:45:37', '2022-07-31 11:45:37');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000017', 61, 1, 80000, 80000, 0, 6, 27, 1, '2022-07-31 11:45:37', '2022-07-31 11:45:37');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000018', 2, 1, 20000, 20000, 0, 0, 29, 2, '2022-08-02 05:28:23', '2022-08-02 05:28:23');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000018', 4, 2, 175000, 350000, 0, 1, 29, 2, '2022-08-02 05:28:23', '2022-08-02 05:28:23');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000018', 8, 3, 150000, 450000, 0, 2, 31, 2, '2022-08-02 05:28:23', '2022-08-02 05:28:23');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000018', 6, 4, 40000, 160000, 0, 3, 53, 2, '2022-08-02 05:28:23', '2022-08-02 05:28:23');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000019', 1, 1, 150000, 150000, 0, 0, 14, 1, '2022-08-04 09:37:39', '2022-08-04 09:37:39');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000019', 6, 1, 40000, 40000, 0, 1, 14, 1, '2022-08-04 09:37:39', '2022-08-04 09:37:39');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000019', 64, 1, 75000, 75000, 0, 2, 14, 1, '2022-08-04 09:37:39', '2022-08-04 09:37:39');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000019', 65, 1, 70000, 70000, 0, 3, 27, 1, '2022-08-04 09:37:39', '2022-08-04 09:37:39');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000020', 57, 1, 65000, 65000, 0, 0, 14, 57, '2022-08-04 09:42:14', '2022-08-04 09:42:14');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000020', 51, 1, 80000, 80000, 0, 1, 14, 51, '2022-08-04 09:42:14', '2022-08-04 09:42:14');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000020', 49, 1, 160000, 160000, 0, 2, 14, 49, '2022-08-04 09:42:14', '2022-08-04 09:42:14');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000020', 52, 3, 70000, 210000, 0, 3, 27, 52, '2022-08-04 09:42:14', '2022-08-04 09:42:14');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000020', 6, 1, 40000, 40000, 0, 4, 27, 6, '2022-08-04 09:42:14', '2022-08-04 09:42:14');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000021', 2, 1, 20000, 20000, 0, 0, 30, 27, '2022-08-04 09:52:29', '2022-08-04 09:52:29');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000021', 3, 3, 250000, 750000, 0, 1, 30, 27, '2022-08-04 09:52:29', '2022-08-04 09:52:29');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000021', 52, 5, 70000, 350000, 0, 2, 30, 27, '2022-08-04 09:52:29', '2022-08-04 09:52:29');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000021', 61, 1, 80000, 80000, 0, 3, 30, 27, '2022-08-04 09:52:29', '2022-08-04 09:52:29');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000021', 60, 1, 100000, 100000, 0, 4, 30, 14, '2022-08-04 09:52:29', '2022-08-04 09:52:29');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000021', 50, 2, 110000, 220000, 0, 5, 30, 27, '2022-08-04 09:52:29', '2022-08-04 09:52:29');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000022', 43, 1, 135000, 135000, 0, 0, 29, NULL, '2022-08-07 00:56:26', '2022-08-07 00:56:26');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000022', 66, 1, 70000, 70000, 0, 1, 29, 29, '2022-08-07 00:56:26', '2022-08-07 00:56:26');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000022', 48, 1, 110000, 110000, 0, 2, 29, NULL, '2022-08-07 00:56:26', '2022-08-07 00:56:26');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000023', 63, 1, 70000, 70000, 0, 0, 53, NULL, '2022-08-07 00:57:44', '2022-08-07 00:57:44');
INSERT INTO public.invoice_detail VALUES ('INV-002-2022-00000023', 59, 2, 185000, 370000, 0, 1, 30, NULL, '2022-08-07 00:57:44', '2022-08-07 00:57:44');


--
-- TOC entry 3546 (class 0 OID 18262)
-- Dependencies: 257
-- Data for Name: invoice_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.invoice_master VALUES (15, 'INV-002-2022-00000001', '2022-07-25', 1, B'0', 960000, 0, 960000, 0, 'Test Invoice', 'Cash', 1000000, B'0', NULL, '2022-07-25 18:45:00', 11, NULL, NULL, NULL, '2022-07-25 11:43:19', 1, '2022-07-25 11:43:19');
INSERT INTO public.invoice_master VALUES (16, 'INV-002-2022-00000016', '2022-07-25', 1, B'0', 990000, 0, 990000, 0, 'Test 2', 'Cash', 1000000, B'0', NULL, '2022-07-25 18:45:00', 1, NULL, NULL, NULL, '2022-07-25 11:44:37', 1, '2022-07-25 11:44:37');
INSERT INTO public.invoice_master VALUES (17, 'INV-002-2022-00000017', '2022-07-31', 1, B'0', 1680000, 0, 1680000, 0, NULL, 'Cash', 2000000, B'0', NULL, '2022-07-31 18:45:00', 6, NULL, NULL, NULL, '2022-07-31 11:45:37', 1, '2022-07-31 11:45:37');
INSERT INTO public.invoice_master VALUES (18, 'INV-002-2022-00000018', '2022-08-02', 1, B'0', 980000, 0, 980000, 0, 'Test Cashier', 'Cash', 500000, B'0', NULL, '2022-08-02 12:30:00', 3, NULL, NULL, NULL, '2022-08-02 05:28:23', 2, '2022-08-02 05:28:23');
INSERT INTO public.invoice_master VALUES (19, 'INV-002-2022-00000019', '2022-08-04', 1, B'0', 335000, 0, 335000, 0, 'Test', 'Cash', 500000, B'0', NULL, '2022-08-04 16:45:00', 11, NULL, NULL, NULL, '2022-08-04 09:37:39', 1, '2022-08-04 09:37:39');
INSERT INTO public.invoice_master VALUES (20, 'INV-002-2022-00000020', '2022-08-04', 1, B'0', 555000, 0, 555000, 0, 'Test Referral', 'Cash', 600000, B'0', NULL, '2022-08-04 16:45:00', 1, NULL, NULL, NULL, '2022-08-04 09:42:14', 1, '2022-08-04 09:42:14');
INSERT INTO public.invoice_master VALUES (21, 'INV-002-2022-00000021', '2022-08-04', 1, B'0', 1520000, 0, 1520000, 0, 'Test', 'Cash', 10000000, B'0', NULL, '2022-08-04 17:00:00', 11, NULL, NULL, NULL, '2022-08-04 09:52:29', 1, '2022-08-04 09:52:29');
INSERT INTO public.invoice_master VALUES (22, 'INV-002-2022-00000022', '2022-08-07', 1, B'0', 315000, 0, 315000, 0, 'Test 1', 'Cash', 400000, B'0', NULL, '2022-08-07 08:00:00', 11, NULL, NULL, NULL, '2022-08-07 00:56:26', 1, '2022-08-07 00:56:26');
INSERT INTO public.invoice_master VALUES (23, 'INV-002-2022-00000023', '2022-08-07', 1, B'0', 440000, 0, 440000, 0, 'Test 2', 'Cash', 500000, B'0', NULL, '2022-08-07 10:00:00', 1, NULL, NULL, NULL, '2022-08-07 00:57:44', 1, '2022-08-07 00:57:44');


--
-- TOC entry 3511 (class 0 OID 17951)
-- Dependencies: 222
-- Data for Name: job_title; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.job_title VALUES (1, 'Kasir', B'1', '2022-06-01 19:52:32.509771');
INSERT INTO public.job_title VALUES (2, 'Terapist', B'1', '2022-06-01 19:52:32.509771');
INSERT INTO public.job_title VALUES (3, 'Owner', B'1', '2022-06-01 19:52:32.509771');
INSERT INTO public.job_title VALUES (6, 'Administrator', B'1', '2022-06-01 19:52:32.509771');
INSERT INTO public.job_title VALUES (4, 'Staff Finance & Accounting', B'1', '2022-06-01 19:52:32.509771');
INSERT INTO public.job_title VALUES (5, 'Staff Human Resource', B'1', '2022-06-01 19:52:32.509771');
INSERT INTO public.job_title VALUES (7, 'Trainer', B'1', '2022-06-01 19:52:32.509771');


--
-- TOC entry 3492 (class 0 OID 17798)
-- Dependencies: 203
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.migrations VALUES (1, '2014_10_12_000000_create_users_table', 1);
INSERT INTO public.migrations VALUES (2, '2014_10_12_100000_create_password_resets_table', 1);
INSERT INTO public.migrations VALUES (3, '2019_08_19_000000_create_failed_jobs_table', 1);
INSERT INTO public.migrations VALUES (4, '2019_12_14_000001_create_personal_access_tokens_table', 1);
INSERT INTO public.migrations VALUES (5, '2022_05_28_121734_create_permission_tables', 1);
INSERT INTO public.migrations VALUES (6, '2022_05_28_121901_create_posts_table', 2);


--
-- TOC entry 3504 (class 0 OID 17880)
-- Dependencies: 215
-- Data for Name: model_has_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3505 (class 0 OID 17891)
-- Dependencies: 216
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
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 42);
INSERT INTO public.model_has_roles VALUES (4, 'App\Models\User', 45);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 46);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 47);
INSERT INTO public.model_has_roles VALUES (2, 'App\Models\User', 53);
INSERT INTO public.model_has_roles VALUES (11, 'App\Models\User', 54);
INSERT INTO public.model_has_roles VALUES (2, 'App\Models\User', 3);
INSERT INTO public.model_has_roles VALUES (3, 'App\Models\User', 2);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 14);


--
-- TOC entry 3522 (class 0 OID 18045)
-- Dependencies: 233
-- Data for Name: order_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.order_detail VALUES ('ORD-002-2022-00000001', 1, 1, 150000, 150000, 0, 0, 14, 1, '2022-07-24 11:29:46', '2022-07-24 11:29:46');
INSERT INTO public.order_detail VALUES ('ORD-002-2022-00000001', 10, 1, 60000, 60000, 0, 1, 14, 1, '2022-07-24 11:29:46', '2022-07-24 11:29:46');
INSERT INTO public.order_detail VALUES ('ORD-002-2022-00000001', 50, 1, 110000, 110000, 0, 2, 14, 1, '2022-07-24 11:29:46', '2022-07-24 11:29:46');
INSERT INTO public.order_detail VALUES ('ORD-002-2022-00000054', 1, 1, 150000, 150000, 0, 0, NULL, 2, '2022-08-10 08:48:42', '2022-08-10 08:48:42');


--
-- TOC entry 3519 (class 0 OID 18001)
-- Dependencies: 230
-- Data for Name: order_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.order_master VALUES (53, 'ORD-002-2022-00000001', '2022-07-24', 1, 1, '2022-07-24 11:24:55', B'0', 320000, 0, 320000, 0, NULL, 'Cash', 450000, B'0', NULL, NULL, '2022-07-24 11:29:46', 1, '2022-07-24 18:30:00', 11);
INSERT INTO public.order_master VALUES (54, 'ORD-002-2022-00000054', '2022-08-10', 17, 2, '2022-08-10 08:48:42', B'0', 150000, 0, 150000, 0, 'Tste', 'Debit Card', 300000, B'0', NULL, NULL, '2022-08-10 08:48:42', NULL, '2022-08-10 15:45:00', 11);


--
-- TOC entry 3495 (class 0 OID 17819)
-- Dependencies: 206
-- Data for Name: password_resets; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3531 (class 0 OID 18121)
-- Dependencies: 242
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
-- TOC entry 3555 (class 0 OID 18501)
-- Dependencies: 266
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


--
-- TOC entry 3501 (class 0 OID 17856)
-- Dependencies: 212
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
INSERT INTO public.permissions VALUES (59, 'products.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/products', 'Products', 'Products');
INSERT INTO public.permissions VALUES (65, 'orders.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (66, 'orders.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (67, 'orders.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (68, 'orders.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (69, 'orders.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (70, 'orders.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (71, 'orders.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (72, 'orders.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (74, 'orders.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/orders', 'Sales Orders', 'Transactions');
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
INSERT INTO public.permissions VALUES (47, 'rooms.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/rooms', 'Room', 'Settings');
INSERT INTO public.permissions VALUES (51, 'users.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (52, 'users.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (53, 'branchs.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (54, 'branchs.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (1, 'roles.index', 'web', '2022-06-05 07:50:24', '2022-06-05 07:50:24', '/roles', 'Roles', 'Users');
INSERT INTO public.permissions VALUES (3, 'users.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/users', 'Users', 'Users');
INSERT INTO public.permissions VALUES (13, 'permissions.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/permissions', 'Permissions', 'Users');
INSERT INTO public.permissions VALUES (39, 'departments.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/departments', 'Departments', 'Settings');
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
INSERT INTO public.permissions VALUES (88, 'productsbrand.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productsbrand', 'Brand', 'Products');
INSERT INTO public.permissions VALUES (85, 'customers.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/customers', 'Customers', 'Users');
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
INSERT INTO public.permissions VALUES (89, 'productsprice.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productsprice', 'Price', 'Products');
INSERT INTO public.permissions VALUES (99, 'productsbrand.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (100, 'productsbrand.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (101, 'productsbrand.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (102, 'productsbrand.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (103, 'productsbrand.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (104, 'productsbrand.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (105, 'productsstock.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (106, 'productsstock.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (107, 'productsstock.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (108, 'productsstock.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (109, 'productsstock.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (110, 'productsstock.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (111, 'productsstock.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (112, 'productsstock.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (113, 'productsstock.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (114, 'productsstock.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productsstock', 'Stock', 'Products');
INSERT INTO public.permissions VALUES (115, 'invoices.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (116, 'invoices.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (117, 'invoices.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (118, 'invoices.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (119, 'invoices.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (120, 'invoices.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (121, 'invoices.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (122, 'invoices.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (123, 'invoices.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/invoices', 'Invoices', 'Transactions');
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
INSERT INTO public.permissions VALUES (135, 'uoms.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/uoms', 'UOM', 'Products');
INSERT INTO public.permissions VALUES (136, 'categories.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (137, 'categories.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (138, 'categories.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (139, 'categories.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (140, 'categories.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (141, 'categories.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (142, 'categories.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (143, 'categories.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/categories', 'Category', 'Products');
INSERT INTO public.permissions VALUES (144, 'types.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (145, 'types.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (146, 'types.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (147, 'types.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (148, 'types.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (149, 'types.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (150, 'types.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (151, 'types.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/types', 'Type', 'Products');
INSERT INTO public.permissions VALUES (152, 'productsdistribution.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (153, 'productsdistribution.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (154, 'productsdistribution.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (155, 'productsdistribution.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (156, 'productsdistribution.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (157, 'productsdistribution.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (158, 'productsdistribution.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (159, 'productsdistribution.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (160, 'productsdistribution.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (161, 'productsdistribution.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productsdistribution', 'Product Distribution', 'Products');
INSERT INTO public.permissions VALUES (162, 'productspoint.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (163, 'productspoint.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (164, 'productspoint.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (165, 'productspoint.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (166, 'productspoint.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (167, 'productspoint.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (168, 'productspoint.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (169, 'productspoint.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (170, 'productspoint.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (171, 'productspoint.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productspoint', 'Product Point', 'Products');
INSERT INTO public.permissions VALUES (172, 'productscommision.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (173, 'productscommision.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (174, 'productscommision.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (175, 'productscommision.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (176, 'productscommision.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (177, 'productscommision.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (178, 'productscommision.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (179, 'productscommision.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (180, 'productscommision.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (181, 'productscommision.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productscommision', 'Product Commision', 'Products');
INSERT INTO public.permissions VALUES (182, 'productscommisionbyyear.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (183, 'productscommisionbyyear.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (184, 'productscommisionbyyear.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (185, 'productscommisionbyyear.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (186, 'productscommisionbyyear.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (187, 'productscommisionbyyear.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (188, 'productscommisionbyyear.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (189, 'productscommisionbyyear.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (190, 'productscommisionbyyear.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (191, 'productscommisionbyyear.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productscommisionbyyear', 'Product Commision Year', 'Products');
INSERT INTO public.permissions VALUES (192, 'reports.cashier.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/cashier', 'Commision Cashier', 'Reports');
INSERT INTO public.permissions VALUES (193, 'reports.terapist.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/terapist', 'Commision Terapist', 'Reports');
INSERT INTO public.permissions VALUES (194, 'reports.cashier.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/cashier/search', '', '');
INSERT INTO public.permissions VALUES (195, 'reports.terapist.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/terapist/search', '', '');
INSERT INTO public.permissions VALUES (196, 'customers.storeapi', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (197, 'purchaseorders.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (198, 'purchaseorders.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (199, 'purchaseorders.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (200, 'purchaseorders.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (201, 'purchaseorders.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (202, 'purchaseorders.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (203, 'purchaseorders.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (204, 'purchaseorders.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (206, 'purchaseorders.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (207, 'purchaseorders.getproduct', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (208, 'purchaseorders.getorder', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (205, 'purchaseorders.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/purchaseorders', 'Purchase Order', 'Transactions');
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
INSERT INTO public.permissions VALUES (221, 'receiveorders.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/receiveorders', 'Receive Order', 'Transactions');
INSERT INTO public.permissions VALUES (222, 'receiveorders.getdocdata', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (223, 'users.addtraining', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (224, 'users.deletetraining', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (225, 'users.addexperience', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (226, 'users.deleteexperience', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (227, 'purchaseorders.print', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (31, 'branchs.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/branchs', 'Branchs', 'Settings');
INSERT INTO public.permissions VALUES (228, 'rooms.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (229, 'rooms.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);


--
-- TOC entry 3499 (class 0 OID 17842)
-- Dependencies: 210
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3508 (class 0 OID 17919)
-- Dependencies: 219
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.posts VALUES (2, 1, '1', '12', '1', '2022-05-28 15:29:26', '2022-05-28 15:29:30');


--
-- TOC entry 3526 (class 0 OID 18076)
-- Dependencies: 237
-- Data for Name: product_brand; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_brand VALUES (1, 'General', '2022-06-01 20:47:29.575876', NULL);
INSERT INTO public.product_brand VALUES (2, 'ACL', '2022-06-01 20:47:29.580415', NULL);
INSERT INTO public.product_brand VALUES (3, 'Bali Alus', '2022-06-01 20:47:29.582037', NULL);
INSERT INTO public.product_brand VALUES (4, 'Green Spa', '2022-06-01 20:47:29.583737', NULL);
INSERT INTO public.product_brand VALUES (5, 'Biokos', '2022-06-01 20:47:29.585597', NULL);
INSERT INTO public.product_brand VALUES (6, 'Ianthe', '2022-06-01 20:47:29.587679', NULL);
INSERT INTO public.product_brand VALUES (8, 'Wardah', '2022-07-21 16:34:24', '2022-07-21 16:40:55');


--
-- TOC entry 3528 (class 0 OID 18086)
-- Dependencies: 239
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


--
-- TOC entry 3537 (class 0 OID 18163)
-- Dependencies: 248
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
-- TOC entry 3535 (class 0 OID 18143)
-- Dependencies: 246
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
-- TOC entry 3529 (class 0 OID 18094)
-- Dependencies: 240
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
INSERT INTO public.product_distribution VALUES (76, 1, '2022-07-26 09:54:28', '2022-07-26 10:05:18', 0);


--
-- TOC entry 3536 (class 0 OID 18157)
-- Dependencies: 247
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
-- TOC entry 3530 (class 0 OID 18115)
-- Dependencies: 241
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
INSERT INTO public.product_price VALUES (76, 100, 3, NULL, '2022-07-20 15:22:37', 1, '2022-07-20 15:22:37');
INSERT INTO public.product_price VALUES (76, 1000, 1, NULL, '2022-07-20 15:24:29', 1, '2022-07-20 15:24:29');


--
-- TOC entry 3524 (class 0 OID 18065)
-- Dependencies: 235
-- Data for Name: product_sku; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_sku VALUES (1, 'ACL - ANTISEPTIK GEL', 'ACL AG', NULL, NULL, B'1', 8, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (8, 'ACL - MILK BATH', 'ACL MB', NULL, NULL, B'1', 8, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (9, 'ACL - PENYEGAR WAJAH ', 'ACL PYGR WJ', NULL, NULL, B'1', 8, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (10, 'BALI ALUS - BODY WITHENING', 'BA BW', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (11, 'BALI ALUS - DUDUS CELUP ', 'BA DC', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (12, 'BALI ALUS - LIGHTENING', 'BA LGHTN', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (13, 'BALI ALUS - LULUR GREENTEA', 'BA LLR GRNT', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (18, 'BALI ALUS - SWETY SLIMM', 'BA SWTY SLM', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (19, 'NELAYAN NUSANTARA BATHSALT VCO RELAX', 'NN BTHSLT VCO', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (20, 'GREEN SPA LULUR BALI ALUS', 'GS LLR BA', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (21, 'BIOKOS - CLEANSER', 'BK CLNSR', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (24, 'BIOKOS - PEELING', 'BK  PLNG', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (27, 'CELANA KAIN STANDAR', 'G CLN STD', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (28, 'HERBAL COMPRESS', 'G HRBL COMPS', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (29, 'KOP BADAN BESAR', 'G KOP BDN L', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (30, 'LILIN EC', 'G LLN EC', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (31, 'TATAKAN WAJAH JELLY', 'G WJH JLLY', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (33, 'KAYU REFLEKSI SEGITIGA', 'G KYU RFL S3', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (34, 'KAYU REFLEKSI BINTANG', 'G KYU RFL STR', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (2, 'ACL - CREAM HANGAT BUNGKUS', 'ACL CH B', NULL, NULL, B'1', 9, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (3, 'ACL - CREAM HANGAT BOTOL', 'ACL CH BT', NULL, NULL, B'1', 9, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (4, 'ACL - FOOT SPRAY', 'ACL FS', NULL, NULL, B'1', 10, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (5, 'ACL - LINEN SPRAY', 'ACL LS', NULL, NULL, B'1', 10, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (32, 'PEELING SPRAY', 'G PLLG SPRY', NULL, NULL, B'1', 10, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (6, 'ACL - MASSAGE CREAM BUNGAN JEPUN', 'ACL MSG CRM BJ', NULL, NULL, B'1', 9, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (22, 'BIOKOS - CREAM MASSAGE ', 'BK CRM MSSG', NULL, NULL, B'1', 9, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (7, 'ACL - MASKER BADAN', 'ACL MSK BD', NULL, NULL, B'1', 13, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (14, 'BALI ALUS - MASKER ARMPIT', 'BA MSK ARMP', NULL, NULL, B'1', 13, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (15, 'BALI ALUS - MASKER PAYUDARA B', 'BA MSK PYDR B', NULL, NULL, B'1', 13, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (16, 'BALI ALUS - MASKER PAYUDARA K', 'BA MSK PYDR K', NULL, NULL, B'1', 13, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (23, 'BIOKOS - GELK MASK', 'BK GLK MSK', NULL, NULL, B'1', 13, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (35, 'THE BANDULAN ', 'BDLN', NULL, NULL, B'1', 12, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (36, 'GOLDA', 'GLDA', NULL, NULL, B'1', 12, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (37, 'GREAT', 'G GRT', NULL, NULL, B'1', 12, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (25, 'IANTHE SERUM VITAMIN C 5 ML', 'IT SRM VIT C 5ML', NULL, NULL, B'1', 7, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (26, 'IANTHE SERUM VITAMIN C 100 ML', 'IT SRM VIT C 100ML', NULL, NULL, B'1', 7, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (17, 'BALI ALUS - SABUN SIRIH', 'BA SBN SRH', NULL, NULL, B'1', 11, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (39, 'Mixing Thai', 'SRVC B MT', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (40, 'Body Herbal Compress ', 'SRVC B BHC', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (41, 'Shiatsu', 'SRVC B SHSU', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (42, 'Dry Massage', 'SRVC B DRY MSG', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (43, 'Tuina', 'SRVC B TNA', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (44, 'Hot Stone', 'SRVC B HOT STN', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (45, 'Full Body Reflexology', 'SRVC B FULL BD RF', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (46, 'Full Body Therapy', 'SRVC B FULL BD TR', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (47, 'Back Massage / Dry', 'SRVC B BCK MSG', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (48, 'Body Cop With Massage', 'SRVC B BCOP MSG', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (49, 'Facial Biokos and Accu Aura With Vitamin', 'SRVC F BKOS AUR', NULL, NULL, B'1', 2, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (50, 'Face Refreshing Biokos', 'SRVC F BKOS RFHS', NULL, NULL, B'1', 2, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (51, 'Ear Candling', 'SRVC F EAR CDL', NULL, NULL, B'1', 2, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (52, 'Accu Aura', 'SRVC F ACC AURA', NULL, NULL, B'1', 2, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (53, 'V- Spa', 'SRVC FL VSPA', NULL, NULL, B'1', 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (54, 'Breast and Slimming Therapy', 'SRVC FL BRST SLMM TRP', NULL, NULL, B'1', 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (55, 'Slimming', 'SRVC FL SLMM', NULL, NULL, B'1', 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (56, 'Breast', 'SRVC FL BRST', NULL, NULL, B'1', 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (57, 'Ratus With Hand Massage', 'SRVC FL RTS HND MSG', NULL, NULL, B'1', 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (58, 'Executive Bali Body Scrub', 'SRVC SC BDY SCRB', NULL, NULL, B'1', 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (59, 'Body Bleacing Package', 'SRVC SC BDY  BLCH', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (60, 'Bali Alus Body Scrub', 'SRVC BA BDY SCRB', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (61, 'Lulur Aromatherapy', 'SRVC BA LLR ARMTRY', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (62, 'Foot Reflexology', 'SRVC FT REFKS', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (63, 'Foot Express', 'SRVC FT REFKS EPRS', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (64, 'Herbal Compress', 'SRVC ADN HRBL CMPS', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (65, 'Mandi Susu', 'SRVC ADN MND SSU', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (66, 'Body Cop Package', 'SRVC ADN BDY CP', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (67, 'Masker Badan', 'SRVC ADN MSK BDN', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (68, 'Steam Badan', 'SRVC STRM BDN', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (70, 'CELANA KAIN JUMBO', 'G CLN JMB', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (69, 'Extra Time', 'SRVC ADN EXT TME', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 11);
INSERT INTO public.product_sku VALUES (76, 'Tester', 'tssser', NULL, NULL, B'1', 13, 2, 2, '2022-07-12 15:03:18', NULL, '2022-07-12 14:42:24', 1, 11);


--
-- TOC entry 3544 (class 0 OID 18253)
-- Dependencies: 255
-- Data for Name: product_stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_stock VALUES (53, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (55, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (1, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (8, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (9, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (10, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (11, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (12, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (13, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (18, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (19, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (20, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (21, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
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
INSERT INTO public.product_stock VALUES (17, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (39, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (40, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
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
INSERT INTO public.product_stock VALUES (59, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
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
INSERT INTO public.product_stock VALUES (9, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (10, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (11, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (12, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (13, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (18, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (19, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (20, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (21, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (24, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (27, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (28, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (29, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (30, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (31, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (33, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (32, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (22, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (7, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (14, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (15, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (16, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (23, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (35, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (36, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (37, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (25, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (26, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (17, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (39, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (40, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (41, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (42, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (44, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (45, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (46, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (47, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (58, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (62, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (4, 2, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (27, 1, 10108, '2022-08-20 17:04:38.386827', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (8, 2, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (48, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (56, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (5, 2, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (54, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (61, 2, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (6, 2, 9993, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (60, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (34, 2, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (3, 2, 9995, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (64, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (2, 2, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (65, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (57, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (51, 2, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (50, 2, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (43, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (66, 2, 9995, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (63, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (59, 2, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (67, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (68, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (70, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (69, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (76, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (1, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (8, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (9, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (11, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (18, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (19, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (21, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (28, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (29, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (30, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (31, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (33, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (34, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (5, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (32, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (6, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (22, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
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
INSERT INTO public.product_stock VALUES (17, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (39, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (40, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (41, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (42, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (43, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (44, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (45, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (46, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (47, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (48, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
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
INSERT INTO public.product_stock VALUES (10, 3, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (12, 3, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (20, 3, 9995, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (61, 3, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (1, 2, 9995, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (49, 2, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (52, 2, 9999, '2022-08-20 01:41:24', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (52, 3, 10114, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (4, 3, 10000, '2022-08-20 15:13:26.026441', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (13, 3, 10004, '2022-08-20 15:13:26.028804', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (27, 3, 10000, '2022-08-20 15:13:26.030577', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (24, 3, 10030, '2022-08-20 16:47:12.514929', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (2, 3, 9997, '2022-08-20 16:47:12.522531', '2022-07-25 18:26:06.816842', 1);


--
-- TOC entry 3554 (class 0 OID 18492)
-- Dependencies: 265
-- Data for Name: product_stock_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_stock_detail VALUES (1, 24, 3, 1, '2024-08-20', NULL, '2022-08-20 16:47:12.517217', 1);
INSERT INTO public.product_stock_detail VALUES (2, 2, 3, 1, '2024-08-20', NULL, '2022-08-20 16:47:12.524593', 1);
INSERT INTO public.product_stock_detail VALUES (3, 27, 1, 109, '2024-08-20', NULL, '2022-08-20 17:04:38.389528', 1);


--
-- TOC entry 3541 (class 0 OID 18208)
-- Dependencies: 252
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_type VALUES (3, 'Goods & Services', '2022-06-01 21:02:38.43164', NULL);
INSERT INTO public.product_type VALUES (2, 'Services', '2022-06-01 21:02:38.43164', NULL);
INSERT INTO public.product_type VALUES (1, 'Goods', '2022-06-01 21:02:38.43164', NULL);
INSERT INTO public.product_type VALUES (7, 'Misc', '2022-07-25 14:53:50', '2022-07-25 14:53:50');


--
-- TOC entry 3542 (class 0 OID 18216)
-- Dependencies: 253
-- Data for Name: product_uom; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_uom VALUES (1, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (9, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (21, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (24, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (30, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (3, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (4, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (5, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (35, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (36, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (37, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (26, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (17, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (2, 2, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (6, 2, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (7, 2, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (8, 2, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (19, 2, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (20, 2, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (10, 3, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (12, 3, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (18, 3, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (22, 3, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (23, 3, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (11, 5, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (14, 5, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (13, 4, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (28, 4, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (31, 4, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (32, 4, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (33, 4, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (34, 4, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (15, 6, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (16, 6, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (29, 6, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (25, 7, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (27, 8, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (70, 8, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (39, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (40, 12, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (41, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (42, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (43, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (44, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (45, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (46, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (47, 19, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (48, 19, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (49, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (50, 19, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (51, 11, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (52, 10, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (53, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (54, 19, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (55, 10, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (56, 10, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (57, 16, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (58, 20, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (59, 21, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (60, 19, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (61, 12, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (62, 19, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (63, 11, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (64, 10, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (65, 16, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (66, 16, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (67, 10, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (68, 16, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom VALUES (69, 10, '2022-06-03 17:38:00.278845', 1);


--
-- TOC entry 3560 (class 0 OID 18669)
-- Dependencies: 271
-- Data for Name: purchase_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.purchase_detail VALUES ('PO-001-2022-00000009', 59, 'Body Bleacing Package', '100 Menit', 0, 1, 185000, 185000, 11.00, 0.00, 0, 0.00, '2022-08-28 12:09:54', '2022-08-28 12:09:54');
INSERT INTO public.purchase_detail VALUES ('PO-002-2022-00000010', 59, 'Body Bleacing Package', '100 Menit', 0, 1, 185000, 1000, 11.00, 20240.00, 184000, 204240.00, '2022-08-28 12:26:55', '2022-08-28 12:26:55');
INSERT INTO public.purchase_detail VALUES ('PO-002-2022-00000010', 40, 'Body Herbal Compress', '120 Menit', 1, 1, 160000, 0, 11.00, 17600.00, 160000, 177600.00, '2022-08-28 12:26:55', '2022-08-28 12:26:55');


--
-- TOC entry 3559 (class 0 OID 18620)
-- Dependencies: 270
-- Data for Name: purchase_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.purchase_master VALUES (9, 'PO-001-2022-00000009', '2022-08-28', 1, 'Test Supplier 01', 1, 'HEAD QUARTER', B'0', 0, 0, 0, 185000, NULL, NULL, 0, B'0', '2022-08-28 19:09:54.020705', NULL, NULL, NULL, '2022-08-28 12:09:54', 1, '2022-08-28 12:09:54');
INSERT INTO public.purchase_master VALUES (10, 'PO-002-2022-00000010', '2022-08-28', 1, 'Test Supplier 01', 2, 'OUTLET 01', B'0', 381840, 37840, 0, 1000, NULL, NULL, 0, B'0', '2022-08-28 19:26:55.492603', NULL, NULL, NULL, '2022-08-28 12:26:55', 1, '2022-08-28 12:26:55');


--
-- TOC entry 3552 (class 0 OID 18449)
-- Dependencies: 263
-- Data for Name: receive_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.receive_detail VALUES ('RC-003-2022-00000001', 24, 5, 100000, 500000, 0, 0, '2023-08-20', NULL, '2022-08-20 08:09:19', '2022-08-20 08:09:19');
INSERT INTO public.receive_detail VALUES ('RC-003-2022-00000001', 13, 1, 40000, 40000, 0, 1, '2023-08-20', NULL, '2022-08-20 08:09:19', '2022-08-20 08:09:19');
INSERT INTO public.receive_detail VALUES ('RC-003-2022-00000001', 52, 10, 70000, 700000, 0, 2, '2023-08-20', NULL, '2022-08-20 08:09:19', '2022-08-20 08:09:19');
INSERT INTO public.receive_detail VALUES ('RC-003-2022-00000013', 4, 1, 175000, 175000, 0, 0, '2023-08-20', NULL, '2022-08-20 08:13:26', '2022-08-20 08:13:26');
INSERT INTO public.receive_detail VALUES ('RC-003-2022-00000013', 13, 1, 40000, 40000, 0, 1, '2023-08-20', NULL, '2022-08-20 08:13:26', '2022-08-20 08:13:26');
INSERT INTO public.receive_detail VALUES ('RC-003-2022-00000013', 27, 1, 50000, 50000, 0, 2, '2023-08-20', NULL, '2022-08-20 08:13:26', '2022-08-20 08:13:26');
INSERT INTO public.receive_detail VALUES ('RC-003-2022-00000014', 24, 1, 100000, 100000, 0, 0, '2023-08-20', 'AA', '2022-08-20 09:47:12', '2022-08-20 09:47:12');
INSERT INTO public.receive_detail VALUES ('RC-003-2022-00000014', 2, 1, 20000, 20000, 0, 1, '2023-08-20', 'AA', '2022-08-20 09:47:12', '2022-08-20 09:47:12');
INSERT INTO public.receive_detail VALUES ('RC-001-2022-00000015', 27, 109, 50000, 5450000, 0, 0, '2023-08-20', 'ACCC', '2022-08-20 10:04:38', '2022-08-20 10:04:38');


--
-- TOC entry 3551 (class 0 OID 18423)
-- Dependencies: 262
-- Data for Name: receive_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.receive_master VALUES (12, 'RC-003-2022-00000001', '2022-08-20', 1, B'0', 1240000, 0, 0, 0, 'Tets Q', NULL, 0, B'0', '2022-08-20 15:09:19.408989', 3, 'PO-003-2022-00000012', NULL, NULL, '2022-08-20 08:09:19', 1, '2022-08-20 08:09:19');
INSERT INTO public.receive_master VALUES (13, 'RC-003-2022-00000013', '2022-08-20', 1, B'0', 265000, 0, 0, 0, NULL, NULL, 0, B'0', '2022-08-20 15:13:26.023212', 3, 'PO-003-2022-00000013', NULL, NULL, '2022-08-20 08:13:26', 1, '2022-08-20 08:13:26');
INSERT INTO public.receive_master VALUES (14, 'RC-003-2022-00000014', '2022-08-20', 1, B'0', 120000, 0, 0, 0, NULL, NULL, 0, B'0', '2022-08-20 16:47:12.506299', 3, NULL, NULL, NULL, '2022-08-20 09:47:12', 1, '2022-08-20 09:47:12');
INSERT INTO public.receive_master VALUES (15, 'RC-001-2022-00000015', '2022-08-20', 2, B'0', 5450000, 0, 0, 0, 'Test', NULL, 0, B'0', '2022-08-20 17:04:38.378022', 1, NULL, NULL, NULL, '2022-08-20 10:04:38', 1, '2022-08-20 10:04:38');


--
-- TOC entry 3506 (class 0 OID 17902)
-- Dependencies: 217
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


--
-- TOC entry 3503 (class 0 OID 17869)
-- Dependencies: 214
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
-- TOC entry 3532 (class 0 OID 18128)
-- Dependencies: 243
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.settings VALUES ('2022-07-16', 202207, 'Kakiku', 'Lapak ERP', 'v0.0.1', 'Logo_512.png');


--
-- TOC entry 3549 (class 0 OID 18334)
-- Dependencies: 260
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.suppliers VALUES (1, 'Test Supplier 01', 'Jalan Pangeran Parit 21', 1, 'test@gmail.com', '085746879090');
INSERT INTO public.suppliers VALUES (2, 'Test Supplier 02', 'Jalan Mawar Mandiri No 01', 2, 'test@gmail.com', '085746879090');


--
-- TOC entry 3534 (class 0 OID 18134)
-- Dependencies: 245
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


--
-- TOC entry 3494 (class 0 OID 17806)
-- Dependencies: 205
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES (3, 'User-Owner', 'owner@gmail.com', 'user-owner', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-08-21 03:25:52', '6285746879090', 'JALAN JAKARTA', '2022-01-01', 1, 'Male', '3524111233144330001', B'1', 'JAKARTA', '20210101OWN', 'man.png', 'draft_netizen_01.jpg', 3, 1, 6, NULL, 'JAKARTA', '2022-01-01', 'On Job Training');
INSERT INTO public.users VALUES (1, 'Admin', 'admin@gmail.com', 'admin', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-05-28 12:40:11', '6285746879090', 'JALAN JAKARTA', '2020-01-01', 2, 'Male', '3524111233144330001', B'1', 'JAKARTA', '20210101ADM', 'user-13.jpg', 'user-13.jpg', 6, 2, 5, NULL, 'JAKARTA', '2022-01-01', 'On Job Training');
INSERT INTO public.users VALUES (26, 'Test User', 'purnomo.yogiaditya@gmail.com', 'test_123', NULL, '$2y$10$bIEbT.3PQ4tHVbn9St.oreO5diYJGTV6TqNuWmgGqE8wScBqIxO1S', NULL, '2022-07-12 06:19:07', '2022-07-12 08:02:57', '085746879090', 'Lmg', '2013-07-11', 9, 'Male', '35241112331443300021', B'1', 'Lmg', '20000109YG', 'user-13.jpg', NULL, 3, 2, 2, 3, 'test', '2022-07-03', 'On Job Training');
INSERT INTO public.users VALUES (33, 'Fist Karl-Terapist', 'fist@gmail.com', 'pass123', NULL, '$2y$10$hv3IVYi39yFzGYmh3Th8KeuHaIRbKS/NHrL3QrypF46oOWYXFPy9a', NULL, '2022-07-30 08:48:31', '2022-07-30 08:48:31', '0813453211', 'Medan', '2022-07-17', 1, 'Male', '35241112331443300021', B'1', 'Medan', '2011010022', 'user-13.jpg', NULL, 2, NULL, 2, 14, 'Medan', '2022-04-17', 'On Job Training');
INSERT INTO public.users VALUES (32, 'Jemm Rakar-Terapist', 'jemm@gmail.com', 'jem', NULL, '$2y$10$DtwhuxLX7GD5Mkcdtk3nK.9D.shExDpmeqeNaffU.KOTnAKhPmRrS', NULL, '2022-07-30 08:09:55', '2022-07-30 08:09:55', '082311111', 'Solo', '2022-07-04', 1, 'Male', '35241112331443300012', B'1', 'Sragen', 'JR20220101102', 'user-13.jpg', NULL, 2, NULL, 2, NULL, 'Solo', '2022-07-10', 'On Job Training');
INSERT INTO public.users VALUES (5, 'User-HR', 'hr@gmail.com', 'user-hr', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-07-06 14:26:35', '6285746879090', 'JALAN JAKARTA', '2021-01-01', 1, 'Male', '3524111233144330001', B'1', 'JAKARTA', '20210101HR', 'user-13.jpg', 'user-13.jpg', 5, 1, 4, 1, 'JAKARTA', '2022-01-01', 'On Job Training');
INSERT INTO public.users VALUES (29, 'John Doe-Terapist', 'johndoe@gmail.com', 'johndoe', NULL, '$2y$10$D8C5.ba4RGNeN9Q6uH82HeAm0P6S5jp.Y6e5IK11hypYnOByDW0rS', NULL, '2022-07-30 07:29:53', '2022-07-30 07:56:32', '085746879090', 'Pekanbaru', '2022-05-22', 1, 'Male', '35241112331443300021', B'1', 'Pekanbaru', 'JD2022073001', 'user-13.jpg', NULL, 2, 2, 2, 3, 'Suwoko', '2020-12-28', 'On Job Training');
INSERT INTO public.users VALUES (2, 'User-Kasir', 'kasir@gmail.com', 'user-kasir', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-08-21 04:21:09', '6285746879090', 'JALAN JAKARTA', '2019-05-01', 3, 'Female', '35241112331443300012', B'1', 'JAKARTA', '20210101KSR', 'user-13.jpg', 'draft_netizen.jpg', 1, 2, 2, 1, 'JAKARTA', '2022-01-01', 'Contract');
INSERT INTO public.users VALUES (54, 'Coach-Andy', 'trainer@gmail.com', 'trainer', NULL, '$2y$10$NeF32GFPD7LysV2ggx9OROXX0XuZorwFM9kxlSu8WGZtFnTljTmqG', NULL, '2022-08-20 11:30:05', '2022-08-20 11:30:05', '085746879090', 'Lamongan', '2022-08-01', 1, 'Male', '35241112331443300021', B'1', 'Lamongan', 'TR-ADY-001', '804e42dadef82ee18bcbf174a3ad9090.png', 'b8074bdb86f8572480601bf1cd2a42ad.jpg', 7, 1, 9, NULL, 'Test', '2022-08-09', 'On Job Training');
INSERT INTO public.users VALUES (42, 'Fake Yuki-Terapist', 'dadmin@gamisbrandgresik.com', 'fghsaaa', NULL, '$2y$10$xBeCTMHwKmJDTPFzsRbVr.TH1ocEZpLx6wvLtSoSwCS2DfwMyZe6u', NULL, '2022-07-30 10:06:14', '2022-07-30 10:06:14', '085746879090', 'Lamongan', '2014-07-11', 8, 'Male', '35241112331443300021', B'1', 'Lamongan', 'YK011122', 'user-13.jpg', NULL, 2, NULL, 2, NULL, 'Test', '2022-07-11', 'On Job Training');
INSERT INTO public.users VALUES (31, 'Johny Deep-Terapist', 'serang@gmail.com', 'johnydeep', NULL, '$2y$10$ZfgXjRK5S86XP2cJtmA6QOku/.v9jSEHfOIBxsZDmCAkKFTLA/MRW', NULL, '2022-07-30 08:03:28', '2022-07-30 08:03:51', '0844312333', 'Serang', '2015-07-18', 7, 'Male', '35241112331443300021', B'1', 'Banten', 'JD202204011', 'user-13.jpg', NULL, 2, 2, 2, NULL, 'Serang', '2020-04-19', 'On Job Training');
INSERT INTO public.users VALUES (30, 'Mark Karl-Terapist', 'maxkarl@gmail.com', 'karlmax', NULL, '$2y$10$Ohj/K.hR2an/GZWn0ONjMe/xd02ZbPniiDcDkY6EcVr8smyPZMhHG', NULL, '2022-07-30 08:00:11', '2022-07-30 08:07:59', '081323', 'Lamongan', '2016-07-18', 6, 'Male', '35241112331443300021', B'1', 'Lamongan', 'MK20220102', 'user-13.jpg', NULL, 2, 3, 2, 27, 'Lamongan', '2022-07-04', 'On Job Training');
INSERT INTO public.users VALUES (53, 'Fake Hokis-Terapist', 'dada@gmill.com', 'Faaee', NULL, '$2y$10$AcOnNDUrWd/nha4KRSySa.i2OiFXR4PP.UBjc4LWjQSLnwuhbCcAm', NULL, '2022-07-30 11:33:55', '2022-07-30 11:33:55', '085746879090', 'Lamongan', '2022-07-10', 1, 'Male', '35241112331443300021', B'1', 'Lamongan', 'HK022133', '0769c4c63be92e17c0bf06d131baca96.png', 'eddac66b535aa161c61b06d77f26b5e0.jpg', 2, 2, 2, 1, 'Jakarta', '2022-07-11', 'On Job Training');
INSERT INTO public.users VALUES (4, 'User-Admin Keuangan', 'finance@gmail.com', 'user-finance', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-07-30 08:27:49', '6285746879090', 'JALAN JAKARTA', '2022-01-01', 1, 'Male', '3524111233144330001', B'1', 'JAKARTA', '20210101ADU', 'user-13.jpg', 'draft_netizen_01.jpg', 4, 1, 3, NULL, 'JAKARTA', '2022-01-01', 'On Job Training');
INSERT INTO public.users VALUES (14, 'User-Terapist', 'terapist@gmail.com', 'user-terapist', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-06-11 12:06:30', '6285746879090', 'JALAN JAKARTA', '2017-01-01', 5, 'Male', '3524111233144330001', B'1', 'JAKARTA', '20210101TRP', 'user-13.jpg', 'user-13.jpg', 2, 1, 2, 5, 'JAKARTA', '2022-01-01', 'On Job Training');
INSERT INTO public.users VALUES (27, 'UserTerapist_2', 'yogiektambakboyo@gmail.com', 'userterapist2', NULL, '$2y$10$KUxgpNxhdNzyGOxkrjvsJ.e6Pm264gbZC7roqsC4nru/ALpI28PS.', NULL, '2022-07-25 11:46:21', '2022-07-30 08:28:42', '085746879090', 'Lamongan', '2018-07-18', 4, 'Male', '35241112331443300021', B'1', 'Lamongan', '20210021UU', 'user-13.jpg', 'draft_netizen_01.jpg', 2, 1, 2, 26, 'Jakarta', '2022-07-10', 'On Job Training');


--
-- TOC entry 3543 (class 0 OID 18231)
-- Dependencies: 254
-- Data for Name: users_branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users_branch VALUES (25, 3, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (1, 1, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (14, 2, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (5, 2, '2022-07-06 14:26:35', '2022-07-06 14:26:35');
INSERT INTO public.users_branch VALUES (5, 3, '2022-07-06 14:26:35', '2022-07-06 14:26:35');
INSERT INTO public.users_branch VALUES (1, 3, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (1, 2, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (26, 2, '2022-07-12 08:02:57', '2022-07-12 08:02:57');
INSERT INTO public.users_branch VALUES (28, 2, '2022-07-30 07:23:56', '2022-07-30 07:23:56');
INSERT INTO public.users_branch VALUES (29, 2, '2022-07-30 07:56:32', '2022-07-30 07:56:32');
INSERT INTO public.users_branch VALUES (31, 2, '2022-07-30 08:03:51', '2022-07-30 08:03:51');
INSERT INTO public.users_branch VALUES (30, 3, '2022-07-30 08:07:59', '2022-07-30 08:07:59');
INSERT INTO public.users_branch VALUES (32, 2, '2022-07-30 08:09:55', '2022-07-30 08:09:55');
INSERT INTO public.users_branch VALUES (4, 1, '2022-07-30 08:27:49', '2022-07-30 08:27:49');
INSERT INTO public.users_branch VALUES (27, 1, '2022-07-30 08:28:42', '2022-07-30 08:28:42');
INSERT INTO public.users_branch VALUES (33, 2, '2022-07-30 08:48:31', '2022-07-30 08:48:31');
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


--
-- TOC entry 3557 (class 0 OID 18535)
-- Dependencies: 268
-- Data for Name: users_experience; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users_experience VALUES (1, 2, 'Astra', 'Coordinator Sales', '2019-2020', NULL, 1, '2022-08-21 11:41:24.412471');


--
-- TOC entry 3517 (class 0 OID 17989)
-- Dependencies: 228
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
-- TOC entry 3509 (class 0 OID 17935)
-- Dependencies: 220
-- Data for Name: users_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users_skills VALUES (2, 40, 54, 'Failed', '2022-08-21', NULL, 1, '2022-08-21 09:29:19.91552');
INSERT INTO public.users_skills VALUES (2, 48, 54, 'In Training', '2022-08-26', NULL, 1, '2022-08-21 10:08:40.959154');


--
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 225
-- Name: branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_id_seq', 11, true);


--
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 249
-- Name: branch_room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_room_id_seq', 13, true);


--
-- TOC entry 3597 (class 0 OID 0)
-- Dependencies: 272
-- Name: company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.company_id_seq', 1, true);


--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 231
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_id_seq', 17, true);


--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 223
-- Name: department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.department_id_seq', 9, true);


--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 207
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 256
-- Name: invoice_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invoice_master_id_seq', 23, true);


--
-- TOC entry 3602 (class 0 OID 0)
-- Dependencies: 221
-- Name: job_title_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);


--
-- TOC entry 3603 (class 0 OID 0)
-- Dependencies: 202
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 6, true);


--
-- TOC entry 3604 (class 0 OID 0)
-- Dependencies: 229
-- Name: order_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_master_id_seq', 54, true);


--
-- TOC entry 3605 (class 0 OID 0)
-- Dependencies: 211
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 229, true);


--
-- TOC entry 3606 (class 0 OID 0)
-- Dependencies: 209
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);


--
-- TOC entry 3607 (class 0 OID 0)
-- Dependencies: 218
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 2, true);


--
-- TOC entry 3608 (class 0 OID 0)
-- Dependencies: 236
-- Name: product_brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_brand_id_seq', 8, true);


--
-- TOC entry 3609 (class 0 OID 0)
-- Dependencies: 238
-- Name: product_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_category_id_seq', 14, true);


--
-- TOC entry 3610 (class 0 OID 0)
-- Dependencies: 234
-- Name: product_sku_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_sku_id_seq', 77, true);


--
-- TOC entry 3611 (class 0 OID 0)
-- Dependencies: 264
-- Name: product_stock_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 3, true);


--
-- TOC entry 3612 (class 0 OID 0)
-- Dependencies: 251
-- Name: product_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_type_id_seq', 7, true);


--
-- TOC entry 3613 (class 0 OID 0)
-- Dependencies: 244
-- Name: product_uom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_uom_id_seq', 23, true);


--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 269
-- Name: purchase_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_master_id_seq', 10, true);


--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 261
-- Name: receive_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.receive_master_id_seq', 15, true);


--
-- TOC entry 3616 (class 0 OID 0)
-- Dependencies: 213
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 11, true);


--
-- TOC entry 3617 (class 0 OID 0)
-- Dependencies: 259
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 2, true);


--
-- TOC entry 3618 (class 0 OID 0)
-- Dependencies: 267
-- Name: users_experience_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);


--
-- TOC entry 3619 (class 0 OID 0)
-- Dependencies: 204
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 54, true);


--
-- TOC entry 3620 (class 0 OID 0)
-- Dependencies: 227
-- Name: users_mutation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_mutation_id_seq', 40, true);


--
-- TOC entry 3273 (class 2606 OID 17984)
-- Name: branch branch_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);


--
-- TOC entry 3307 (class 2606 OID 18195)
-- Name: branch_room branch_room_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);


--
-- TOC entry 3275 (class 2606 OID 17986)
-- Name: branch branch_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);


--
-- TOC entry 3341 (class 2606 OID 18704)
-- Name: company company_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);


--
-- TOC entry 3283 (class 2606 OID 18021)
-- Name: customers customers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);


--
-- TOC entry 3244 (class 2606 OID 17837)
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- TOC entry 3246 (class 2606 OID 17839)
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- TOC entry 3319 (class 2606 OID 18319)
-- Name: invoice_detail invoice_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);


--
-- TOC entry 3315 (class 2606 OID 18280)
-- Name: invoice_master invoice_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);


--
-- TOC entry 3317 (class 2606 OID 18282)
-- Name: invoice_master invoice_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);


--
-- TOC entry 3235 (class 2606 OID 17803)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3262 (class 2606 OID 17890)
-- Name: model_has_permissions model_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);


--
-- TOC entry 3265 (class 2606 OID 17901)
-- Name: model_has_roles model_has_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);


--
-- TOC entry 3285 (class 2606 OID 18057)
-- Name: order_detail order_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);


--
-- TOC entry 3279 (class 2606 OID 18029)
-- Name: order_master order_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);


--
-- TOC entry 3281 (class 2606 OID 18031)
-- Name: order_master order_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);


--
-- TOC entry 3331 (class 2606 OID 18514)
-- Name: period_stock period_stock_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);


--
-- TOC entry 3253 (class 2606 OID 17866)
-- Name: permissions permissions_name_guard_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_name_guard_name_unique UNIQUE (name, guard_name);


--
-- TOC entry 3255 (class 2606 OID 17864)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3248 (class 2606 OID 17850)
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3250 (class 2606 OID 17853)
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- TOC entry 3269 (class 2606 OID 17927)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- TOC entry 3305 (class 2606 OID 18168)
-- Name: product_commision_by_year product_commision_by_year_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);


--
-- TOC entry 3301 (class 2606 OID 18156)
-- Name: product_commisions product_commisions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3291 (class 2606 OID 18100)
-- Name: product_distribution product_distribution_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3303 (class 2606 OID 18162)
-- Name: product_point product_point_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3293 (class 2606 OID 18120)
-- Name: product_price product_price_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3287 (class 2606 OID 18107)
-- Name: product_sku product_sku_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);


--
-- TOC entry 3289 (class 2606 OID 18109)
-- Name: product_sku product_sku_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_un UNIQUE (abbr);


--
-- TOC entry 3329 (class 2606 OID 18500)
-- Name: product_stock_detail product_stock_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock_detail
    ADD CONSTRAINT product_stock_detail_pk PRIMARY KEY (id);


--
-- TOC entry 3313 (class 2606 OID 18259)
-- Name: product_stock product_stock_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3309 (class 2606 OID 18221)
-- Name: product_uom product_uom_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_pk PRIMARY KEY (product_id, uom_id);


--
-- TOC entry 3339 (class 2606 OID 18685)
-- Name: purchase_detail purchase_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_pk PRIMARY KEY (purchase_no, product_id);


--
-- TOC entry 3335 (class 2606 OID 18638)
-- Name: purchase_master purchase_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_pk PRIMARY KEY (id);


--
-- TOC entry 3337 (class 2606 OID 18640)
-- Name: purchase_master purchase_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_un UNIQUE (purchase_no);


--
-- TOC entry 3327 (class 2606 OID 18474)
-- Name: receive_detail receive_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_pk PRIMARY KEY (receive_no, product_id, expired_at);


--
-- TOC entry 3323 (class 2606 OID 18441)
-- Name: receive_master receive_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_pk PRIMARY KEY (id);


--
-- TOC entry 3325 (class 2606 OID 18443)
-- Name: receive_master receive_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_un UNIQUE (receive_no);


--
-- TOC entry 3267 (class 2606 OID 17916)
-- Name: role_has_permissions role_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);


--
-- TOC entry 3257 (class 2606 OID 17879)
-- Name: roles roles_name_guard_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);


--
-- TOC entry 3259 (class 2606 OID 17877)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3295 (class 2606 OID 18252)
-- Name: settings settings_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (company_name, app_name);


--
-- TOC entry 3321 (class 2606 OID 18693)
-- Name: suppliers suppliers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pk PRIMARY KEY (id);


--
-- TOC entry 3297 (class 2606 OID 18228)
-- Name: uom uom_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);


--
-- TOC entry 3299 (class 2606 OID 18230)
-- Name: uom uom_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_un UNIQUE (remark);


--
-- TOC entry 3311 (class 2606 OID 18236)
-- Name: users_branch users_branch_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_branch
    ADD CONSTRAINT users_branch_pk PRIMARY KEY (user_id, branch_id);


--
-- TOC entry 3237 (class 2606 OID 17816)
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- TOC entry 3333 (class 2606 OID 18543)
-- Name: users_experience users_experience_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_experience
    ADD CONSTRAINT users_experience_pk PRIMARY KEY (id);


--
-- TOC entry 3277 (class 2606 OID 17998)
-- Name: users_mutation users_mutation_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_mutation
    ADD CONSTRAINT users_mutation_pk PRIMARY KEY (id);


--
-- TOC entry 3239 (class 2606 OID 17814)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3271 (class 2606 OID 18532)
-- Name: users_skills users_skills_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_pk PRIMARY KEY (users_id, modul, dated, status);


--
-- TOC entry 3241 (class 2606 OID 17818)
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- TOC entry 3260 (class 1259 OID 17883)
-- Name: model_has_permissions_model_id_model_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);


--
-- TOC entry 3263 (class 1259 OID 17894)
-- Name: model_has_roles_model_id_model_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);


--
-- TOC entry 3242 (class 1259 OID 17825)
-- Name: password_resets_email_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);


--
-- TOC entry 3251 (class 1259 OID 17851)
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- TOC entry 3356 (class 2606 OID 18201)
-- Name: branch_room branch_room_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3360 (class 2606 OID 18320)
-- Name: invoice_detail invoice_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);


--
-- TOC entry 3358 (class 2606 OID 18283)
-- Name: invoice_master invoice_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3359 (class 2606 OID 18288)
-- Name: invoice_master invoice_master_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);


--
-- TOC entry 3342 (class 2606 OID 17884)
-- Name: model_has_permissions model_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 3343 (class 2606 OID 17895)
-- Name: model_has_roles model_has_roles_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 3350 (class 2606 OID 18058)
-- Name: order_detail order_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);


--
-- TOC entry 3348 (class 2606 OID 18032)
-- Name: order_master order_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3349 (class 2606 OID 18037)
-- Name: order_master order_master_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);


--
-- TOC entry 3346 (class 2606 OID 17928)
-- Name: posts posts_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3353 (class 2606 OID 18169)
-- Name: product_commision_by_year product_commision_by_year_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3354 (class 2606 OID 18174)
-- Name: product_commision_by_year product_commision_by_year_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3355 (class 2606 OID 18179)
-- Name: product_commision_by_year product_commision_by_year_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3351 (class 2606 OID 18101)
-- Name: product_distribution product_distribution_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3352 (class 2606 OID 18110)
-- Name: product_distribution product_distribution_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3357 (class 2606 OID 18222)
-- Name: product_uom product_uom_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3364 (class 2606 OID 18686)
-- Name: purchase_detail purchase_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);


--
-- TOC entry 3363 (class 2606 OID 18641)
-- Name: purchase_master purchase_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3362 (class 2606 OID 18463)
-- Name: receive_detail receive_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);


--
-- TOC entry 3361 (class 2606 OID 18444)
-- Name: receive_master receive_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3344 (class 2606 OID 17905)
-- Name: role_has_permissions role_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 3345 (class 2606 OID 17910)
-- Name: role_has_permissions role_has_permissions_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 3347 (class 2606 OID 17944)
-- Name: users_skills users_skills_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);


-- Completed on 2022-08-31 23:01:24 WIB

--
-- PostgreSQL database dump complete
--

