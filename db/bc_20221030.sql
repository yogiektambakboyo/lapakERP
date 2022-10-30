--
-- PostgreSQL database dump
--

-- Dumped from database version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)

-- Started on 2022-10-30 18:52:21 WIB

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
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    active smallint DEFAULT 1 NOT NULL
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
-- TOC entry 3648 (class 0 OID 0)
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
-- TOC entry 3649 (class 0 OID 0)
-- Dependencies: 249
-- Name: branch_room_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.branch_room_id_seq OWNED BY public.branch_room.id;


--
-- TOC entry 270 (class 1259 OID 18696)
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
-- TOC entry 269 (class 1259 OID 18694)
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
-- TOC entry 3650 (class 0 OID 0)
-- Dependencies: 269
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
-- TOC entry 3651 (class 0 OID 0)
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
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    active smallint DEFAULT 1 NOT NULL
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
-- TOC entry 3652 (class 0 OID 0)
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
-- TOC entry 3653 (class 0 OID 0)
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
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    uom character varying,
    product_name character varying,
    vat integer,
    vat_total numeric(18,0),
    assigned_to_name character varying,
    referral_by_name character varying
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
-- TOC entry 3654 (class 0 OID 0)
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
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    active smallint DEFAULT 1 NOT NULL
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
-- TOC entry 3655 (class 0 OID 0)
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
-- TOC entry 3656 (class 0 OID 0)
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
    total numeric(18,0) DEFAULT 0 NOT NULL,
    tax numeric(18,0) DEFAULT 0 NOT NULL,
    total_payment numeric(18,0) DEFAULT 0 NOT NULL,
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
    printed_count integer DEFAULT 0 NOT NULL
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
-- TOC entry 3657 (class 0 OID 0)
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
-- TOC entry 263 (class 1259 OID 18501)
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
-- TOC entry 3658 (class 0 OID 0)
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
-- TOC entry 3659 (class 0 OID 0)
-- Dependencies: 209
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- TOC entry 283 (class 1259 OID 18873)
-- Name: point_conversion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.point_conversion (
    point_qty integer DEFAULT 0 NOT NULL,
    point_value integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.point_conversion OWNER TO postgres;

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
-- TOC entry 3660 (class 0 OID 0)
-- Dependencies: 218
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- TOC entry 280 (class 1259 OID 18847)
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
-- TOC entry 279 (class 1259 OID 18845)
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
-- TOC entry 3661 (class 0 OID 0)
-- Dependencies: 279
-- Name: price_adjustment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.price_adjustment_id_seq OWNED BY public.price_adjustment.id;


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
-- TOC entry 3662 (class 0 OID 0)
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
-- TOC entry 3663 (class 0 OID 0)
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
-- TOC entry 271 (class 1259 OID 18707)
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
-- TOC entry 3664 (class 0 OID 0)
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
-- TOC entry 3665 (class 0 OID 0)
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
-- TOC entry 262 (class 1259 OID 18492)
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
-- TOC entry 261 (class 1259 OID 18490)
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
-- TOC entry 3666 (class 0 OID 0)
-- Dependencies: 261
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
-- TOC entry 3667 (class 0 OID 0)
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
    create_by integer,
    updated_at timestamp without time zone
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
-- TOC entry 3668 (class 0 OID 0)
-- Dependencies: 244
-- Name: product_uom_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_uom_id_seq OWNED BY public.uom.id;


--
-- TOC entry 268 (class 1259 OID 18669)
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
-- TOC entry 267 (class 1259 OID 18620)
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
-- TOC entry 266 (class 1259 OID 18618)
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
-- TOC entry 3669 (class 0 OID 0)
-- Dependencies: 266
-- Name: purchase_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_master_id_seq OWNED BY public.purchase_master.id;


--
-- TOC entry 278 (class 1259 OID 18814)
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
-- TOC entry 277 (class 1259 OID 18788)
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
-- TOC entry 276 (class 1259 OID 18786)
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
-- TOC entry 3670 (class 0 OID 0)
-- Dependencies: 276
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
-- TOC entry 3671 (class 0 OID 0)
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
-- TOC entry 273 (class 1259 OID 18722)
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
-- TOC entry 272 (class 1259 OID 18720)
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
-- TOC entry 3672 (class 0 OID 0)
-- Dependencies: 272
-- Name: shift_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;


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
    handphone character varying,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
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
-- TOC entry 3673 (class 0 OID 0)
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
-- TOC entry 265 (class 1259 OID 18535)
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
-- TOC entry 264 (class 1259 OID 18533)
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
-- TOC entry 3674 (class 0 OID 0)
-- Dependencies: 264
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
-- TOC entry 3675 (class 0 OID 0)
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
-- TOC entry 3676 (class 0 OID 0)
-- Dependencies: 227
-- Name: users_mutation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;


--
-- TOC entry 274 (class 1259 OID 18734)
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
-- TOC entry 275 (class 1259 OID 18756)
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
-- TOC entry 3677 (class 0 OID 0)
-- Dependencies: 275
-- Name: users_shift_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;


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
-- TOC entry 282 (class 1259 OID 18859)
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
-- TOC entry 281 (class 1259 OID 18857)
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
-- TOC entry 3678 (class 0 OID 0)
-- Dependencies: 281
-- Name: voucher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;


--
-- TOC entry 3148 (class 2604 OID 17977)
-- Name: branch id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);


--
-- TOC entry 3191 (class 2604 OID 18189)
-- Name: branch_room id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);


--
-- TOC entry 3252 (class 2604 OID 18699)
-- Name: company id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);


--
-- TOC entry 3165 (class 2604 OID 18014)
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- TOC entry 3145 (class 2604 OID 17966)
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);


--
-- TOC entry 3134 (class 2604 OID 17831)
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- TOC entry 3199 (class 2604 OID 18265)
-- Name: invoice_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);


--
-- TOC entry 3142 (class 2604 OID 17954)
-- Name: job_title id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);


--
-- TOC entry 3130 (class 2604 OID 17801)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 3153 (class 2604 OID 18004)
-- Name: order_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master ALTER COLUMN id SET DEFAULT nextval('public.order_master_id_seq'::regclass);


--
-- TOC entry 3137 (class 2604 OID 17859)
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- TOC entry 3136 (class 2604 OID 17845)
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- TOC entry 3139 (class 2604 OID 17922)
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- TOC entry 3281 (class 2604 OID 18850)
-- Name: price_adjustment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_adjustment ALTER COLUMN id SET DEFAULT nextval('public.price_adjustment_id_seq'::regclass);


--
-- TOC entry 3178 (class 2604 OID 18079)
-- Name: product_brand id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_brand ALTER COLUMN id SET DEFAULT nextval('public.product_brand_id_seq'::regclass);


--
-- TOC entry 3180 (class 2604 OID 18089)
-- Name: product_category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);


--
-- TOC entry 3174 (class 2604 OID 18068)
-- Name: product_sku id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku ALTER COLUMN id SET DEFAULT nextval('public.product_sku_id_seq'::regclass);


--
-- TOC entry 3219 (class 2604 OID 18495)
-- Name: product_stock_detail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock_detail ALTER COLUMN id SET DEFAULT nextval('public.product_stock_detail_id_seq'::regclass);


--
-- TOC entry 3193 (class 2604 OID 18211)
-- Name: product_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_type ALTER COLUMN id SET DEFAULT nextval('public.product_type_id_seq'::regclass);


--
-- TOC entry 3234 (class 2604 OID 18623)
-- Name: purchase_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master ALTER COLUMN id SET DEFAULT nextval('public.purchase_master_id_seq'::regclass);


--
-- TOC entry 3262 (class 2604 OID 18791)
-- Name: receive_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);


--
-- TOC entry 3138 (class 2604 OID 17872)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 3256 (class 2604 OID 18725)
-- Name: shift id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);


--
-- TOC entry 3217 (class 2604 OID 18337)
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- TOC entry 3187 (class 2604 OID 18137)
-- Name: uom id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);


--
-- TOC entry 3131 (class 2604 OID 17809)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3230 (class 2604 OID 18538)
-- Name: users_experience id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_experience ALTER COLUMN id SET DEFAULT nextval('public.users_experience_id_seq'::regclass);


--
-- TOC entry 3151 (class 2604 OID 17992)
-- Name: users_mutation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_mutation ALTER COLUMN id SET DEFAULT nextval('public.users_mutation_id_seq'::regclass);


--
-- TOC entry 3261 (class 2604 OID 18758)
-- Name: users_shift id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_shift ALTER COLUMN id SET DEFAULT nextval('public.users_shift_id_seq'::regclass);


--
-- TOC entry 3284 (class 2604 OID 18862)
-- Name: voucher id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voucher ALTER COLUMN id SET DEFAULT nextval('public.voucher_id_seq'::regclass);


--
-- TOC entry 3585 (class 0 OID 17974)
-- Dependencies: 226
-- Data for Name: branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
1	HEAD QUARTER	Jalan Jakarta no 3	Jakarta	HQ00	2022-06-01 19:46:05.452925	\N	1
2	OUTLET 01	Jalan Lampung No 23	Jakarta	OL01	2022-06-01 19:46:05.452925	\N	1
3	OUTLET 02	Jalan Sumatera No 88	Sumatera	OL02	2022-06-01 19:46:05.452925	\N	1
\.


--
-- TOC entry 3609 (class 0 OID 18186)
-- Dependencies: 250
-- Data for Name: branch_room; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
11	2	OT01 Bunaken 02	2022-07-16 13:39:55	2022-07-16 13:39:55
1	2	OT01 Sumbawa	2022-06-01 19:47:46.062696	\N
6	3	HQ - Bunaken 01	2022-06-01 19:47:46.062696	\N
3	2	OT01 Flores 02	2022-06-01 19:47:46.062696	\N
4	2	OT01 Jawa 02	2022-06-01 19:47:46.062696	\N
5	3	OT02 Flores 03	2022-06-01 19:47:46.062696	\N
7	3	OT03 Jawa 03	2022-06-01 19:47:46.062696	\N
\.


--
-- TOC entry 3629 (class 0 OID 18696)
-- Dependencies: 270
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
1	Kakiku	Gading Serpong I	Tangerang	admin@kakiku.com	031-3322224	6d4c83f6b695389b860d79e975e13751.png	2022-09-03 00:59:33	2022-08-30 22:06:56.025994
\.


--
-- TOC entry 3591 (class 0 OID 18011)
-- Dependencies: 232
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at) FROM stdin;
12	Test Name	Test Address	Test Phone	1	1	2	2022-08-10 07:51:57	2022-08-10 07:51:57
17	Memp	Jalan Karangn	08576443	1	1	2	2022-08-10 08:32:39	2022-08-10 08:32:39
1	UMUM	Jalan Umum	6285746879090	1	OT01-UM	2	2022-06-02 20:38:02.11776	\N
4	UMUM	Jalan Umum	6285746879090	1	OT02-UM	3	2022-06-02 20:38:02.11776	\N
\.


--
-- TOC entry 3583 (class 0 OID 17963)
-- Dependencies: 224
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
2	OPERASIONAL	2022-06-01 19:49:58.185846	\N	1
3	FINANCE	2022-06-01 19:49:58.185846	\N	1
4	HR	2022-06-01 19:49:58.185846	\N	1
5	IT	2022-06-01 19:49:58.185846	\N	1
1	SALES	2022-06-01 19:49:58.185846	\N	1
6	MANAGEMENT	2022-06-01 19:49:58.185846	\N	1
9	TRAINING	2022-08-06 23:00:27	2022-08-06 23:00:27	1
\.


--
-- TOC entry 3567 (class 0 OID 17828)
-- Dependencies: 208
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- TOC entry 3617 (class 0 OID 18306)
-- Dependencies: 258
-- Data for Name: invoice_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
INV-002-2022-00000001	48	4	110000	439000	1000	0	29	\N	2022-10-09 15:27:43	2022-10-09 15:27:43	60 Menit	Body Cop With Massage	11	48290	John Doe-Terapist	
INV-002-2022-00000001	43	2	135000	268000	2000	1	29	\N	2022-10-09 15:27:43	2022-10-09 15:27:43	90 Menit	Tuina	11	29480	John Doe-Terapist	
INV-002-2022-00000001	85	1	10000	10000	0	2	29	\N	2022-10-09 15:27:43	2022-10-09 15:27:43	Pcs	Extra Charge Room	0	0	John Doe-Terapist	
INV-002-2022-00000001	7	1	150000	150000	0	3	29	\N	2022-10-09 15:27:43	2022-10-09 15:27:43	Bungkus	ACL - MASKER BADAN	11	16500	John Doe-Terapist	
INV-002-2022-00000001	11	1	25000	25000	0	4	29	\N	2022-10-09 15:27:43	2022-10-09 15:27:43	Sacheet	BALI ALUS - DUDUS CELUP 	11	2750	John Doe-Terapist	
INV-002-2022-00000048	46	1	135000	135000	0	0	53	\N	2022-10-09 15:28:42	2022-10-09 15:28:42	90 Menit	Full Body Therapy	11	14850	Fake Hokis-Terapist	
INV-002-2022-00000048	45	1	135000	135000	0	1	53	\N	2022-10-09 15:28:42	2022-10-09 15:28:42	90 Menit	Full Body Reflexology	11	14850	Fake Hokis-Terapist	
INV-002-2022-00000049	48	1	110000	110000	0	0	33	\N	2022-10-15 18:35:37	2022-10-15 18:35:37	60 Menit	Body Cop With Massage	11	12100	Fist Karl-Terapist	
INV-002-2022-00000049	46	1	135000	135000	0	1	33	\N	2022-10-15 18:35:37	2022-10-15 18:35:37	90 Menit	Full Body Therapy	11	14850	Fist Karl-Terapist	
INV-002-2022-00000050	46	1	135000	135000	0	0	29	\N	2022-10-15 18:36:18	2022-10-15 18:36:18	90 Menit	Full Body Therapy	11	14850	John Doe-Terapist	
INV-002-2022-00000051	48	1	110000	110000	0	0	29	\N	2022-10-15 20:09:31	2022-10-15 20:09:31	60 Menit	Body Cop With Massage	11	12100	John Doe-Terapist	
INV-002-2022-00000051	86	1	20000	20000	0	1	29	\N	2022-10-15 20:09:31	2022-10-15 20:09:31	Pcs	Extra Charge Gender	0	0	John Doe-Terapist	
INV-002-2022-00000051	85	1	10000	10000	0	2	29	\N	2022-10-15 20:09:31	2022-10-15 20:09:31	Pcs	Extra Charge Room	0	0	John Doe-Terapist	
INV-002-2022-00000051	83	1	10000	10000	0	3	29	\N	2022-10-15 20:09:31	2022-10-15 20:09:31	Pcs	Extra Charge Midnight 21:00	0	0	John Doe-Terapist	
INV-002-2022-00000051	23	1	100000	100000	0	4	29	\N	2022-10-15 20:09:31	2022-10-15 20:09:31	Tube	BIOKOS - GELK MASK	11	11000	John Doe-Terapist	
INV-002-2022-00000052	35	1	5000	5000	0	0	53	\N	2022-10-15 20:13:34	2022-10-15 20:13:34	Botol	THE BANDULAN 	11	550	Fake Hokis-Terapist	
INV-002-2022-00000053	89	1	10000	10000	0	0	53	\N	2022-10-15 20:41:29	2022-10-15 20:41:29	Botol	Test Kotak	0	0	Fake Hokis-Terapist	
INV-002-2022-00000053	84	1	20000	20000	0	1	53	\N	2022-10-15 20:41:29	2022-10-15 20:41:29	Pcs	Extra Charge Midnight 22:00	0	0	Fake Hokis-Terapist	
INV-002-2022-00000054	48	1	110000	110000	0	0	32	\N	2022-10-23 19:21:43	2022-10-23 19:21:43	60 Menit	Body Cop With Massage	11	12100	Jemm Rakar-Terapist	
INV-002-2022-00000054	44	1	135000	135000	0	1	53	\N	2022-10-23 19:21:43	2022-10-23 19:21:43	90 Menit	Hot Stone	11	14850	Fake Hokis-Terapist	
INV-002-2022-00000054	7	1	150000	150000	0	2	32	\N	2022-10-23 19:21:43	2022-10-23 19:21:43	Bungkus	ACL - MASKER BADAN	11	16500	Jemm Rakar-Terapist	
INV-002-2022-00000055	48	10	110000	1100000	0	0	32	\N	2022-10-23 19:43:08	2022-10-23 19:43:08	60 Menit	Body Cop With Massage	11	121000	Jemm Rakar-Terapist	
INV-002-2022-00000055	44	8	135000	1080000	0	1	30	\N	2022-10-23 19:43:08	2022-10-23 19:43:08	90 Menit	Hot Stone	11	118800	Mark Karl-Terapist	
INV-002-2022-00000056	48	1	110000	110000	0	0	29	\N	2022-10-29 17:07:50	2022-10-29 17:07:50	60 Menit	Body Cop With Massage	11	12100	John Doe-Terapist	
INV-002-2022-00000056	46	1	135000	135000	0	1	29	\N	2022-10-29 17:07:50	2022-10-29 17:07:50	90 Menit	Full Body Therapy	11	14850	John Doe-Terapist	
INV-002-2022-00000056	44	1	135000	135000	0	2	29	\N	2022-10-29 17:07:50	2022-10-29 17:07:50	90 Menit	Hot Stone	11	14850	John Doe-Terapist	
INV-003-2022-00000057	47	4	110000	440000	0	0	31	\N	2022-10-29 17:09:02	2022-10-29 17:09:02	60 Menit	Back Massage / Dry	11	48400	Johny Deep-Terapist	
INV-003-2022-00000057	5	1	175000	175000	0	1	31	\N	2022-10-29 17:09:02	2022-10-29 17:09:02	Botol	ACL - LINEN SPRAY	11	19250	Johny Deep-Terapist	
\.


--
-- TOC entry 3616 (class 0 OID 18262)
-- Dependencies: 257
-- Data for Name: invoice_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
49	INV-002-2022-00000049	2022-10-15	12	271950	53900	271950	0	\N	BCA - Debit	272000	\N	2022-10-15 18:45:00	11	\N	\N	\N	2022-10-15 18:35:37	1	2022-10-15 18:35:37	0	0	Test Name	0
47	INV-002-2022-00000001	2022-10-16	12	989020	194040	989020	0	\N	Cash	1000000	\N	2022-10-09 15:30:00	1	\N	\N	\N	2022-10-09 15:27:43	1	2022-10-09 15:27:43	0	0	Test Name	0
53	INV-002-2022-00000053	2022-10-23	1	30000	0	30000	0	\N	Mandiri - Debit	30000	\N	2022-10-15 20:45:00	4	\N	\N	\N	2022-10-15 20:41:29	1	2022-10-15 20:41:29	0	0	UMUM	0
48	INV-002-2022-00000048	2022-10-16	17	299700	59400	299700	0	\N	Cash	300000	\N	2022-10-09 15:30:00	7	\N	\N	\N	2022-10-09 15:28:42	1	2022-10-09 15:28:42	0	0	Memp	0
50	INV-002-2022-00000050	2022-10-16	12	149850	29700	149850	0	\N	Cash	150000	\N	2022-10-15 18:45:00	1	\N	\N	\N	2022-10-15 18:36:18	1	2022-10-15 18:36:18	0	0	Test Name	0
51	INV-002-2022-00000051	2022-10-16	12	273100	46200	273100	0	\N	BCA - Kredit	280000	\N	2022-10-15 20:15:00	1	\N	\N	\N	2022-10-15 20:09:31	1	2022-10-15 20:09:31	0	0	Test Name	0
52	INV-002-2022-00000052	2022-10-16	12	5550	1100	5550	0	\N	Mandiri - Debit	6000	\N	2022-10-15 20:15:00	11	\N	\N	\N	2022-10-15 20:13:34	1	2022-10-15 20:13:34	0	0	Test Name	0
54	INV-002-2022-00000054	2022-10-23	12	438450	86900	438450	0	\N	Cash	500000	\N	2022-10-23 19:30:00	11	\N	\N	\N	2022-10-23 19:21:43	1	2022-10-23 19:21:43	0	0	Test Name	0
55	INV-002-2022-00000055	2022-10-23	12	2419800	479600	2419800	0	\N	BCA - Debit	3000000	\N	2022-10-23 19:45:00	6	\N	\N	\N	2022-10-23 19:43:08	1	2022-10-23 19:43:08	0	0	Test Name	0
56	INV-002-2022-00000056	2022-10-29	17	421800	83600	421800	0	\N	Cash	500000	\N	2022-10-29 17:15:00	1	\N	\N	\N	2022-10-29 17:07:50	1	2022-10-29 17:07:50	0	0	Memp	0
57	INV-003-2022-00000057	2022-10-29	4	682650	135300	682650	0	\N	BCA - Debit	700000	\N	2022-10-29 17:15:00	4	\N	\N	\N	2022-10-29 17:09:02	1	2022-10-29 17:09:02	0	0	UMUM	0
\.


--
-- TOC entry 3581 (class 0 OID 17951)
-- Dependencies: 222
-- Data for Name: job_title; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_title (id, remark, created_at, active) FROM stdin;
1	Kasir	2022-06-01 19:52:32.509771	1
2	Terapist	2022-06-01 19:52:32.509771	1
3	Owner	2022-06-01 19:52:32.509771	1
6	Administrator	2022-06-01 19:52:32.509771	1
4	Staff Finance & Accounting	2022-06-01 19:52:32.509771	1
5	Staff Human Resource	2022-06-01 19:52:32.509771	1
7	Trainer	2022-06-01 19:52:32.509771	1
\.


--
-- TOC entry 3562 (class 0 OID 17798)
-- Dependencies: 203
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	2014_10_12_000000_create_users_table	1
2	2014_10_12_100000_create_password_resets_table	1
3	2019_08_19_000000_create_failed_jobs_table	1
4	2019_12_14_000001_create_personal_access_tokens_table	1
5	2022_05_28_121734_create_permission_tables	1
6	2022_05_28_121901_create_posts_table	2
7	2022_09_11_141615_create_password_resets_table	0
8	2022_09_11_141615_create_failed_jobs_table	0
9	2022_09_11_141615_create_personal_access_tokens_table	0
10	2022_09_11_142556_create_users_table	0
11	2022_09_11_142556_create_password_resets_table	0
12	2022_09_11_142556_create_failed_jobs_table	0
13	2022_09_11_142556_create_personal_access_tokens_table	0
14	2022_09_11_142556_create_model_has_permissions_table	0
15	2022_09_11_142556_create_roles_table	0
16	2022_09_11_142556_create_model_has_roles_table	0
17	2022_09_11_142556_create_role_has_permissions_table	0
18	2022_09_11_142556_create_permissions_table	0
19	2022_09_11_142556_create_order_master_table	0
20	2022_09_11_142556_create_posts_table	0
21	2022_09_11_143016_create_users_table	0
22	2022_09_11_143016_create_password_resets_table	0
23	2022_09_11_143016_create_failed_jobs_table	0
24	2022_09_11_143016_create_personal_access_tokens_table	0
25	2022_09_11_143016_create_model_has_permissions_table	0
26	2022_09_11_143016_create_roles_table	0
27	2022_09_11_143016_create_model_has_roles_table	0
28	2022_09_11_143016_create_role_has_permissions_table	0
29	2022_09_11_143016_create_permissions_table	0
30	2022_09_11_143016_create_order_master_table	0
31	2022_09_11_143016_create_posts_table	0
32	2022_09_11_143016_create_product_sku_table	0
33	2022_09_11_143016_create_product_brand_table	0
34	2022_09_11_143016_create_product_category_table	0
35	2022_09_11_143016_create_users_skills_table	0
36	2022_09_11_143016_create_product_distribution_table	0
37	2022_09_11_143016_create_product_price_table	0
38	2022_09_11_143016_create_period_table	0
39	2022_09_11_143016_create_order_detail_table	0
40	2022_09_11_143016_create_product_commision_by_year_table	0
41	2022_09_11_143016_create_product_point_table	0
42	2022_09_11_143016_create_product_commisions_table	0
43	2022_09_11_143016_create_departments_table	0
44	2022_09_11_143016_create_job_title_table	0
45	2022_09_11_143016_create_branch_table	0
46	2022_09_11_143016_create_users_mutation_table	0
47	2022_09_11_143016_create_customers_table	0
48	2022_09_11_143016_create_product_uom_table	0
49	2022_09_11_143016_create_branch_room_table	0
50	2022_09_11_143016_create_users_branch_table	0
51	2022_09_11_143016_create_invoice_detail_table	0
52	2022_09_11_143016_create_product_stock_table	0
53	2022_09_11_143016_create_uom_table	0
54	2022_09_11_143016_create_product_type_table	0
55	2022_09_11_143016_create_invoice_master_table	0
56	2022_09_11_143016_create_settings_table	0
57	2022_09_11_143016_create_suppliers_table	0
58	2022_09_11_143016_create_product_stock_detail_table	0
59	2022_09_11_143016_create_receive_detail_table	0
60	2022_09_11_143016_create_period_stock_table	0
61	2022_09_11_143016_create_users_experience_table	0
62	2022_09_11_143016_create_purchase_master_table	0
63	2022_09_11_143016_create_purchase_detail_table	0
64	2022_09_11_143016_create_company_table	0
65	2022_09_11_143016_create_product_ingredients_table	0
66	2022_09_11_143016_create_shift_table	0
67	2022_09_11_143016_create_users_shift_table	0
68	2022_09_11_143016_create_receive_master_table	0
69	2022_09_11_143017_add_foreign_keys_to_model_has_permissions_table	0
70	2022_09_11_143017_add_foreign_keys_to_model_has_roles_table	0
71	2022_09_11_143017_add_foreign_keys_to_role_has_permissions_table	0
72	2022_09_11_143017_add_foreign_keys_to_order_master_table	0
73	2022_09_11_143017_add_foreign_keys_to_posts_table	0
74	2022_09_11_143017_add_foreign_keys_to_users_skills_table	0
75	2022_09_11_143017_add_foreign_keys_to_product_distribution_table	0
76	2022_09_11_143017_add_foreign_keys_to_order_detail_table	0
77	2022_09_11_143017_add_foreign_keys_to_product_commision_by_year_table	0
78	2022_09_11_143017_add_foreign_keys_to_product_uom_table	0
79	2022_09_11_143017_add_foreign_keys_to_branch_room_table	0
80	2022_09_11_143017_add_foreign_keys_to_invoice_detail_table	0
81	2022_09_11_143017_add_foreign_keys_to_invoice_master_table	0
82	2022_09_11_143017_add_foreign_keys_to_receive_detail_table	0
83	2022_09_11_143017_add_foreign_keys_to_purchase_master_table	0
84	2022_09_11_143017_add_foreign_keys_to_purchase_detail_table	0
85	2022_09_11_143017_add_foreign_keys_to_receive_master_table	0
86	2022_09_11_143221_create_users_table	0
87	2022_09_11_143221_create_password_resets_table	0
88	2022_09_11_143221_create_failed_jobs_table	0
89	2022_09_11_143221_create_personal_access_tokens_table	0
90	2022_09_11_143221_create_model_has_permissions_table	0
91	2022_09_11_143221_create_roles_table	0
92	2022_09_11_143221_create_model_has_roles_table	0
93	2022_09_11_143221_create_role_has_permissions_table	0
94	2022_09_11_143221_create_permissions_table	0
95	2022_09_11_143221_create_order_master_table	0
96	2022_09_11_143221_create_posts_table	0
97	2022_09_11_143221_create_product_sku_table	0
98	2022_09_11_143221_create_product_brand_table	0
99	2022_09_11_143221_create_product_category_table	0
100	2022_09_11_143221_create_users_skills_table	0
101	2022_09_11_143221_create_product_distribution_table	0
102	2022_09_11_143221_create_product_price_table	0
103	2022_09_11_143221_create_period_table	0
104	2022_09_11_143221_create_order_detail_table	0
105	2022_09_11_143221_create_product_commision_by_year_table	0
106	2022_09_11_143221_create_product_point_table	0
107	2022_09_11_143221_create_product_commisions_table	0
108	2022_09_11_143221_create_departments_table	0
109	2022_09_11_143221_create_job_title_table	0
110	2022_09_11_143221_create_branch_table	0
111	2022_09_11_143221_create_users_mutation_table	0
112	2022_09_11_143221_create_customers_table	0
113	2022_09_11_143221_create_product_uom_table	0
114	2022_09_11_143221_create_branch_room_table	0
115	2022_09_11_143221_create_users_branch_table	0
116	2022_09_11_143221_create_invoice_detail_table	0
117	2022_09_11_143221_create_product_stock_table	0
118	2022_09_11_143221_create_uom_table	0
119	2022_09_11_143221_create_product_type_table	0
120	2022_09_11_143221_create_invoice_master_table	0
121	2022_09_11_143221_create_settings_table	0
122	2022_09_11_143221_create_suppliers_table	0
123	2022_09_11_143221_create_product_stock_detail_table	0
124	2022_09_11_143221_create_receive_detail_table	0
125	2022_09_11_143221_create_period_stock_table	0
126	2022_09_11_143221_create_users_experience_table	0
127	2022_09_11_143221_create_purchase_master_table	0
128	2022_09_11_143221_create_purchase_detail_table	0
129	2022_09_11_143221_create_company_table	0
130	2022_09_11_143221_create_product_ingredients_table	0
131	2022_09_11_143221_create_shift_table	0
132	2022_09_11_143221_create_users_shift_table	0
133	2022_09_11_143221_create_receive_master_table	0
134	2022_09_11_143222_add_foreign_keys_to_model_has_permissions_table	0
135	2022_09_11_143222_add_foreign_keys_to_model_has_roles_table	0
136	2022_09_11_143222_add_foreign_keys_to_role_has_permissions_table	0
137	2022_09_11_143222_add_foreign_keys_to_order_master_table	0
138	2022_09_11_143222_add_foreign_keys_to_posts_table	0
139	2022_09_11_143222_add_foreign_keys_to_users_skills_table	0
140	2022_09_11_143222_add_foreign_keys_to_product_distribution_table	0
141	2022_09_11_143222_add_foreign_keys_to_order_detail_table	0
142	2022_09_11_143222_add_foreign_keys_to_product_commision_by_year_table	0
143	2022_09_11_143222_add_foreign_keys_to_product_uom_table	0
144	2022_09_11_143222_add_foreign_keys_to_branch_room_table	0
145	2022_09_11_143222_add_foreign_keys_to_invoice_detail_table	0
146	2022_09_11_143222_add_foreign_keys_to_invoice_master_table	0
147	2022_09_11_143222_add_foreign_keys_to_receive_detail_table	0
148	2022_09_11_143222_add_foreign_keys_to_purchase_master_table	0
149	2022_09_11_143222_add_foreign_keys_to_purchase_detail_table	0
150	2022_09_11_143222_add_foreign_keys_to_receive_master_table	0
\.


--
-- TOC entry 3574 (class 0 OID 17880)
-- Dependencies: 215
-- Data for Name: model_has_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
\.


--
-- TOC entry 3575 (class 0 OID 17891)
-- Dependencies: 216
-- Data for Name: model_has_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
1	App\\Models\\User	1
6	App\\Models\\User	5
5	App\\Models\\User	26
5	App\\Models\\User	29
5	App\\Models\\User	31
5	App\\Models\\User	30
5	App\\Models\\User	32
4	App\\Models\\User	4
5	App\\Models\\User	27
5	App\\Models\\User	33
4	App\\Models\\User	38
5	App\\Models\\User	39
5	App\\Models\\User	40
4	App\\Models\\User	45
5	App\\Models\\User	46
5	App\\Models\\User	47
2	App\\Models\\User	53
11	App\\Models\\User	54
2	App\\Models\\User	3
3	App\\Models\\User	2
5	App\\Models\\User	14
\.


--
-- TOC entry 3592 (class 0 OID 18045)
-- Dependencies: 233
-- Data for Name: order_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
SPK-002-2022-00000092	48	1	110000	110000	0	0	33	1	2022-10-03 15:56:00	2022-10-03 15:56:00	60 Menit	Body Cop With Massage	Fist Karl-Terapist	Admin	11	12100
SPK-002-2022-00000092	46	1	135000	135000	0	1	53	1	2022-10-03 15:56:00	2022-10-03 15:56:00	90 Menit	Full Body Therapy	Fake Hokis-Terapist	Admin	11	14850
\.


--
-- TOC entry 3589 (class 0 OID 18001)
-- Dependencies: 230
-- Data for Name: order_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
92	SPK-002-2022-00000092	2022-10-03	12	1	2022-10-03 15:56:00	271950	26950	271950	0	\N	Cash	300000	\N	2022-10-04 14:48:27	2022-10-04 14:48:27	\N	2022-10-03 23:00:00	11	0	0	Test Name	2
\.


--
-- TOC entry 3565 (class 0 OID 17819)
-- Dependencies: 206
-- Data for Name: password_resets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_resets (email, token, created_at) FROM stdin;
\.


--
-- TOC entry 3601 (class 0 OID 18121)
-- Dependencies: 242
-- Data for Name: period; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
202201	January -2022	2022-01-01	2022-01-31
202202	February-2022	2022-02-01	2022-02-28
202203	March -2022	2022-03-01	2022-03-31
202204	April -2022	2022-04-01	2022-04-30
202205	May -2022	2022-05-01	2022-05-31
202206	June-2022	2022-06-01	2022-06-30
202207	July-2022	2022-07-01	2022-07-31
202208	August-2022	2022-08-01	2022-08-31
202209	September -2022	2022-09-01	2022-09-30
202210	October -2022	2022-10-01	2022-10-31
202211	November-2022	2022-11-01	2022-11-30
202212	December-2022	2022-12-01	2022-12-31
202301	January -2023	2023-01-01	2023-01-31
202302	February-2023	2023-02-01	2023-02-28
202303	March -2023	2023-03-01	2023-03-31
202304	April -2023	2023-04-01	2023-04-30
202305	May -2023	2023-05-01	2023-05-31
202306	June-2023	2023-06-01	2023-06-30
202307	July-2023	2023-07-01	2023-07-31
202308	August-2023	2023-08-01	2023-08-31
202309	September -2023	2023-09-01	2023-09-30
202310	October -2023	2023-10-01	2023-10-31
202311	November-2023	2023-11-01	2023-11-30
202312	December-2023	2023-12-01	2023-12-01
\.


--
-- TOC entry 3622 (class 0 OID 18501)
-- Dependencies: 263
-- Data for Name: period_stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
202208	1	1	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	8	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	9	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	10	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	11	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	12	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	13	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	18	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	19	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	20	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	21	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	24	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	28	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	29	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	30	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	31	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	33	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	34	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	2	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	3	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	4	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	5	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	32	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	6	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	22	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	7	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	14	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	15	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	16	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	23	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	35	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	36	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	37	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	25	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	26	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	17	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	39	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	40	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	41	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	42	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	43	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	44	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	45	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	46	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	47	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	48	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	49	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	50	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	51	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	52	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	53	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	54	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	55	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	56	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	57	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	58	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	59	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	60	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	61	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	62	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	63	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	64	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	65	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	66	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	67	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	68	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	70	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	69	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	76	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	1	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	8	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	9	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	10	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	11	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	12	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	13	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	18	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	19	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	20	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	21	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	24	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	27	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	28	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	29	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	30	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	31	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	33	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	34	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	2	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	3	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	4	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	5	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	32	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	6	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	22	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	7	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	14	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	15	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	16	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	23	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	35	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	36	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	37	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	25	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	26	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	17	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	39	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	40	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	41	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	42	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	43	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	44	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	45	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	46	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	47	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	48	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	49	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	50	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	51	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	52	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	53	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	54	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	55	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	56	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	57	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	58	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	59	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	60	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	61	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	62	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	63	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	64	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	65	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	66	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	67	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	68	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	70	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	69	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	2	76	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	1	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	8	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	9	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	10	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	11	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	12	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	13	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	18	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	19	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	20	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	21	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	24	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	27	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	28	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	29	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	30	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	31	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	33	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	34	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	2	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	3	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	4	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	5	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	32	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	6	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	22	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	7	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	14	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	15	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	16	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	23	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	35	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	36	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	37	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	25	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	26	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	17	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	39	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	40	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	41	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	42	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	43	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	44	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	45	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	46	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	47	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	48	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	49	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	50	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	51	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	52	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	53	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	54	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	55	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	56	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	57	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	58	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	59	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	60	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	61	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	62	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	63	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	64	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	65	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	66	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	67	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	68	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	70	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	69	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	3	76	9999	9999	0	0	\N	1	2022-08-20 16:59:20.889677
202208	1	27	9999	10108	109	0	2022-08-20 17:04:38.391888	1	2022-08-20 16:59:20.889677
202209	1	1	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	8	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	9	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	10	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	11	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	12	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	13	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	18	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	19	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	20	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	21	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	24	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	28	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	29	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	30	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	31	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	33	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	34	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	2	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	3	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	4	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	5	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	32	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	6	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	22	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	7	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	14	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	15	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	16	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	23	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	35	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	36	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	37	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	25	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	26	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	17	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	39	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	40	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	41	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	42	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	43	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	44	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	45	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	46	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	47	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	48	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	49	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	50	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	51	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	52	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	53	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	54	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	55	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	56	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	57	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	58	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	59	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	60	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	61	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	62	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	63	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	64	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	65	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	66	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	67	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	68	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	70	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	69	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	76	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	1	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	8	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	9	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	10	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	11	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	12	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	13	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	18	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	19	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	20	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	21	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	24	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	27	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	28	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	29	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	30	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	31	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	33	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	34	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	2	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	3	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	4	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	5	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	32	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	6	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	22	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	7	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	14	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	15	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	16	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	23	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	35	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	36	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	37	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	25	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	26	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	17	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	39	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	40	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	41	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	42	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	43	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	44	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	45	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	46	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	47	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	48	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	49	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	50	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	51	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	52	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	53	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	54	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	55	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	56	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	57	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	58	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	59	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	60	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	61	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	62	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	63	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	64	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	65	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	66	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	67	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	68	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	70	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	69	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	2	76	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	1	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	8	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	9	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	10	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	11	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	12	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	13	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	18	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	19	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	20	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	21	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	24	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	27	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	28	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	29	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	30	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	31	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	33	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	34	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	2	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	3	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	4	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	5	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	32	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	6	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	22	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	7	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	14	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	15	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	16	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	23	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	35	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	36	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	37	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	25	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	26	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	17	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	39	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	40	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	41	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	42	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	43	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	44	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	45	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	46	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	47	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	48	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	49	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	50	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	51	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	52	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	53	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	54	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	55	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	56	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	57	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	58	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	59	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	60	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	61	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	62	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	63	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	64	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	65	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	66	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	67	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	68	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	70	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	69	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	3	76	9999	9999	0	0	\N	1	2022-10-09 09:48:47.563836
202209	1	27	9999	10108	109	0	\N	1	2022-10-09 09:48:47.563836
202210	1	1	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	8	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	9	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	11	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	12	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	13	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	18	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	19	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	20	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	21	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	24	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	28	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	29	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	30	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	31	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	33	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	34	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	2	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	3	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	4	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	5	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	32	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	6	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	22	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	7	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	14	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	15	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	16	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	23	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	35	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	36	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	37	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	25	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	26	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	17	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	39	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	40	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	41	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	42	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	43	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	44	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	45	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	46	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	47	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	48	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	49	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	50	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	51	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	52	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	53	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	54	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	55	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	56	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	57	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	58	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	59	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	60	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	61	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	62	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	63	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	64	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	65	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	66	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	67	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	68	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	70	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	69	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	76	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	1	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	8	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	9	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	10	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	12	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	13	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	18	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	19	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	20	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	21	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	24	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	27	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	28	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	29	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	30	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	31	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	33	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	34	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	2	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	3	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	4	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	32	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	6	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	22	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	14	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	15	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	16	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	36	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	37	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	25	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	26	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	17	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	39	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	40	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	41	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	42	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	45	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	43	9999	9997	0	2	2022-10-09 15:27:43.985868	1	2022-10-09 09:50:22.725205
202210	2	44	9999	9997	0	2	2022-10-29 17:07:50.576813	1	2022-10-09 09:50:22.725205
202210	2	11	9999	9998	0	1	2022-10-09 15:27:43.995219	1	2022-10-09 09:50:22.725205
202210	2	35	9999	9998	0	1	2022-10-15 20:13:34.401883	1	2022-10-09 09:50:22.725205
202210	2	5	9999	9998	0	1	2022-10-29 17:09:02.626411	1	2022-10-09 09:50:22.725205
202210	2	7	9999	9997	0	2	2022-10-23 19:21:43.996324	1	2022-10-09 09:50:22.725205
202210	2	49	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	50	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	51	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	52	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	53	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	54	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	55	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	56	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	57	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	58	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	59	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	60	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	61	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	62	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	63	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	64	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	65	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	66	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	67	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	68	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	70	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	69	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	2	76	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	1	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	8	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	9	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	10	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	11	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	12	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	13	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	18	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	19	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	20	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	21	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	24	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	27	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	28	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	29	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	30	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	31	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	33	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	34	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	2	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	3	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	4	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	5	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	32	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	6	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	22	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	7	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	14	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	15	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	16	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	23	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	35	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	36	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	37	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	25	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	26	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	17	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	39	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	40	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	41	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	42	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	43	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	47	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	49	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	50	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	51	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	52	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	53	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	54	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	55	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	56	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	57	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	58	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	59	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	60	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	61	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	62	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	63	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	64	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	65	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	66	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	67	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	68	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	70	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	69	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	3	76	9999	9999	0	0	\N	1	2022-10-09 09:50:22.725205
202210	1	27	9999	10108	109	0	\N	1	2022-10-09 09:50:22.725205
202210	3	46	9999	9998	0	1	2022-10-09 15:28:42.279891	1	2022-10-09 09:50:22.725205
202210	3	48	9999	9989	0	10	2022-10-23 19:43:08.063975	1	2022-10-09 09:50:22.725205
202210	3	45	9999	9998	0	1	2022-10-09 15:28:42.283651	1	2022-10-09 09:50:22.725205
202210	1	10	9999	10000	1	0	2022-10-23 05:17:47.57105	1	2022-10-09 09:50:22.725205
202210	2	47	9999	9995	0	4	2022-10-29 17:09:02.613855	1	2022-10-09 09:50:22.725205
202210	2	23	9999	9998	0	1	2022-10-15 20:09:31.203747	1	2022-10-09 09:50:22.725205
202210	2	46	9999	9995	0	4	2022-10-29 17:07:50.562418	1	2022-10-09 09:50:22.725205
202210	3	44	9999	9991	0	8	2022-10-23 19:43:08.076969	1	2022-10-09 09:50:22.725205
202210	2	48	9999	9990	0	9	2022-10-29 17:07:50.549092	1	2022-10-09 09:50:22.725205
\.


--
-- TOC entry 3571 (class 0 OID 17856)
-- Dependencies: 212
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
2	logout.perform	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
4	users.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
5	users.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
6	users.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
7	users.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
9	users.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
11	users.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
12	users.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
14	roles.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
15	roles.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
16	posts.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
18	posts.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
19	posts.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
20	posts.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
21	posts.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
22	roles.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
23	roles.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
24	roles.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
25	roles.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
59	products.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/products	Products	Products
65	orders.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
66	orders.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
67	orders.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
68	orders.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
69	orders.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
70	orders.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
71	orders.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
72	orders.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
73	orders.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
75	orders.getproduct	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
76	customers.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
77	customers.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
78	customers.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
26	home.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
17	posts.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
8	posts.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
79	customers.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
80	customers.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
81	customers.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
27	branchs.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
28	branchs.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
29	branchs.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
30	branchs.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
32	branchs.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
33	branchs.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
34	branchs.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
35	departments.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
36	departments.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
37	departments.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
38	departments.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
40	departments.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
41	departments.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
42	departments.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
43	rooms.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
44	rooms.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
45	rooms.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
46	rooms.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
48	rooms.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
49	rooms.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
50	rooms.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
82	customers.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
47	rooms.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/rooms	Room	Settings
51	users.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
52	users.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
53	branchs.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
54	branchs.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
13	permissions.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/permissions	Permissions	Settings
3	users.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/users	Users	Users
74	orders.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/orders	SPK	Transactions
39	departments.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/departments	Departments	Settings
1	roles.index	web	2022-06-05 07:50:24	2022-06-05 07:50:24	/roles	Roles	Settings
55	products.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
56	products.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
57	products.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
58	products.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
60	products.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
61	products.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
62	products.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
63	products.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
64	products.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
83	customers.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
84	customers.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
88	productsbrand.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/productsbrand	Brand	Products
85	customers.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/customers	Customers	Users
86	orders.getorder	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
87	orders.gettimetable	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
90	productsprice.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
91	productsprice.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
92	productsprice.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
93	productsprice.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
94	productsprice.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
95	productsprice.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
96	productsprice.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
97	productsprice.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
98	productsprice.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
89	productsprice.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/productsprice	Price	Products
99	productsbrand.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
100	productsbrand.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
101	productsbrand.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
102	productsbrand.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
103	productsbrand.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
104	productsbrand.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
105	productsstock.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
106	productsstock.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
107	productsstock.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
108	productsstock.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
109	productsstock.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
110	productsstock.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
111	productsstock.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
112	productsstock.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
113	productsstock.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
114	productsstock.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/productsstock	Stock	Products
115	invoices.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
116	invoices.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
117	invoices.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
118	invoices.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
119	invoices.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
120	invoices.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
121	invoices.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
122	invoices.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
123	invoices.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/invoices	Invoices	Transactions
124	invoices.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
125	invoices.getproduct	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
127	invoices.gettimetable	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
126	invoices.getinvoice	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
128	uoms.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
129	uoms.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
130	uoms.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
131	uoms.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
132	uoms.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
133	uoms.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
134	uoms.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
135	uoms.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/uoms	UOM	Products
136	categories.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
137	categories.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
138	categories.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
139	categories.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
140	categories.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
141	categories.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
142	categories.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
143	categories.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/categories	Category	Products
144	types.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
145	types.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
146	types.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
147	types.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
148	types.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
149	types.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
150	types.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
151	types.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/types	Type	Products
152	productsdistribution.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
153	productsdistribution.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
154	productsdistribution.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
155	productsdistribution.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
156	productsdistribution.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
157	productsdistribution.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
158	productsdistribution.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
159	productsdistribution.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
160	productsdistribution.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
161	productsdistribution.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/productsdistribution	Product Distribution	Products
162	productspoint.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
163	productspoint.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
164	productspoint.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
165	productspoint.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
166	productspoint.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
167	productspoint.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
168	productspoint.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
169	productspoint.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
170	productspoint.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
171	productspoint.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/productspoint	Product Point	Products
172	productscommision.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
173	productscommision.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
174	productscommision.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
175	productscommision.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
176	productscommision.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
177	productscommision.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
178	productscommision.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
179	productscommision.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
180	productscommision.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
181	productscommision.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/productscommision	Product Commision	Products
182	productscommisionbyyear.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
183	productscommisionbyyear.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
184	productscommisionbyyear.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
185	productscommisionbyyear.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
186	productscommisionbyyear.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
187	productscommisionbyyear.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
188	productscommisionbyyear.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
189	productscommisionbyyear.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
190	productscommisionbyyear.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
191	productscommisionbyyear.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/productscommisionbyyear	Product Commision Year	Products
192	reports.cashier.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/reports/cashier	Commision Cashier	Reports
193	reports.terapist.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/reports/terapist	Commision Terapist	Reports
194	reports.cashier.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/reports/cashier/search		
195	reports.terapist.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/reports/terapist/search		
196	customers.storeapi	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
197	purchaseorders.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
198	purchaseorders.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
199	purchaseorders.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
200	purchaseorders.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
201	purchaseorders.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
202	purchaseorders.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
203	purchaseorders.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
204	purchaseorders.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
206	purchaseorders.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
207	purchaseorders.getproduct	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
208	purchaseorders.getorder	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
205	purchaseorders.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/purchaseorders	Purchase Order	Transactions
209	purchaseorders.getdocdata	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
210	receiveorders.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
211	receiveorders.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
212	receiveorders.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
213	receiveorders.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
214	receiveorders.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
215	receiveorders.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
216	receiveorders.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
217	receiveorders.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
218	receiveorders.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
219	receiveorders.getproduct	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
220	receiveorders.getorder	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
221	receiveorders.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/receiveorders	Receive Order	Transactions
222	receiveorders.getdocdata	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
223	users.addtraining	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
224	users.deletetraining	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
225	users.addexperience	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
226	users.deleteexperience	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
227	purchaseorders.print	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
31	branchs.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/branchs	Branchs	Settings
228	rooms.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
229	rooms.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
230	company.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
231	company.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
232	company.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/company	Company	Settings
233	suppliers.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
234	suppliers.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
235	suppliers.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
236	suppliers.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
237	suppliers.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
238	suppliers.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
239	suppliers.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
240	suppliers.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
241	suppliers.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
243	suppliers.storeapi	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
242	suppliers.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/suppliers	Suppliers	Users
244	products.addingredients	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
245	products.deleteingredients	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
246	shift.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
247	shift.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
248	shift.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
249	shift.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
250	shift.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
251	shift.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
252	shift.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
253	shift.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
254	shift.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
255	shift.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/shift	Shift	Settings
256	shift.storeapi	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
257	usersshift.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
258	usersshift.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
259	usersshift.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
260	usersshift.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
261	usersshift.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
262	usersshift.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
263	usersshift.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
264	usersshift.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
265	usersshift.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
266	usersshift.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/usersshift	User Shift	Settings
267	usersshift.storeapi	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
268	productspriceadj.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
269	productspriceadj.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
270	productspriceadj.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
271	productspriceadj.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
272	productspriceadj.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
273	productspriceadj.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
274	productspriceadj.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
275	productspriceadj.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
276	productspriceadj.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
277	productspriceadj.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/productspriceadj	Price Adjustment	Products
278	voucher.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
279	voucher.show	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
280	voucher.store	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
281	voucher.update	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
282	voucher.create	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
283	voucher.delete	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
284	voucher.destroy	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
285	voucher.edit	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
286	voucher.export	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
287	voucher.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/voucher	Voucher	Settings
288	receiveorders.print	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
289	orders.checkvoucher	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
290	orders.print	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
291	invoices.print	web	2022-05-28 14:34:15	2022-05-28 14:34:15	\N	\N	\N
293	reports.closeshift.getdata	web	2022-05-28 14:34:15	2022-05-28 14:34:15			
294	reports.closeshift.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15			
296	reports.invoice.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15			
297	reports.invoicedetail.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15			
292	reports.closeshift.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/reports/closeshift	Serah Terima	Reports
295	reports.invoice.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/reports/invoice	Sales 	Reports
298	reports.invoicedetail.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/reports/invoicedetail	Sales Detail	Reports
299	reports.purchase.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15			
300	reports.purchase.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/reports/purchase	Purchase	Reports
301	reports.customer.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15			
303	reports.receive.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15			
305	reports.stockmutation.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15			
302	reports.customer.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/reports/customer	Customer	Reports
304	reports.receive.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/reports/receive	Receive	Reports
306	reports.stockmutation.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/reports/stockmutation	Stock Mutation	Reports
307	reports.stock.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15			
308	reports.stock.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/reports/stock	Stock	Reports
309	reports.referral.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15			
310	reports.referral.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/reports/referral	Referral	Reports
311	reports.usertracking.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/reports/usertracking	User Tracking	Reports
312	reports.usertracking.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/reports/usertracking/search		
313	reports.closeday.getdata	web	2022-05-28 14:34:15	2022-05-28 14:34:15			
314	reports.closeday.search	web	2022-05-28 14:34:15	2022-05-28 14:34:15			
315	reports.closeday.index	web	2022-05-28 14:34:15	2022-05-28 14:34:15	/reports/closeday	Closing Harian	Reports
\.


--
-- TOC entry 3569 (class 0 OID 17842)
-- Dependencies: 210
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 3642 (class 0 OID 18873)
-- Dependencies: 283
-- Data for Name: point_conversion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.point_conversion (point_qty, point_value) FROM stdin;
4	8000
5	12000
6	17000
7	23000
8	30000
1	1000
\.


--
-- TOC entry 3578 (class 0 OID 17919)
-- Dependencies: 219
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
2	1	1	12	1	2022-05-28 15:29:26	2022-05-28 15:29:30
\.


--
-- TOC entry 3639 (class 0 OID 18847)
-- Dependencies: 280
-- Data for Name: price_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
1	1	1	2022-09-01	2022-09-30	500	1	2022-09-18 01:29:54	2022-09-17 12:29:14.427409
5	2	1	2022-09-01	2022-09-30	500	1	2022-09-18 01:29:54	2022-09-17 12:29:14.427409
6	3	1	2022-09-01	2022-09-30	500	1	2022-09-18 01:29:54	2022-09-17 12:29:14.427409
\.


--
-- TOC entry 3596 (class 0 OID 18076)
-- Dependencies: 237
-- Data for Name: product_brand; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_brand (id, remark, created_at, updated_at) FROM stdin;
1	General	2022-06-01 20:47:29.575876	\N
2	ACL	2022-06-01 20:47:29.580415	\N
3	Bali Alus	2022-06-01 20:47:29.582037	\N
4	Green Spa	2022-06-01 20:47:29.583737	\N
5	Biokos	2022-06-01 20:47:29.585597	\N
6	Ianthe	2022-06-01 20:47:29.587679	\N
8	Wardah	2022-07-21 16:34:24	2022-07-21 16:40:55
9	Other	2022-10-09 03:04:25	2022-10-09 03:04:25
\.


--
-- TOC entry 3598 (class 0 OID 18086)
-- Dependencies: 239
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_category (id, remark, created_at, updated_at) FROM stdin;
1	Treatment Body	2022-06-01 20:43:14.593652	\N
2	Treatment Face	2022-06-01 20:43:14.599894	\N
3	Treatment Female	2022-06-01 20:43:14.60163	\N
4	Treatment Scrub	2022-06-01 20:43:14.603521	\N
5	Treatment Foot	2022-06-01 20:43:14.605776	\N
6	Add Ons	2022-06-01 20:43:14.607895	\N
7	Serum	2022-06-01 20:43:14.607895	\N
8	Gel	2022-06-01 20:43:14.607895	\N
9	Cream	2022-06-01 20:43:14.607895	\N
10	Spray	2022-06-01 20:43:14.607895	\N
11	Sabun	2022-06-01 20:43:14.607895	\N
12	Minuman	2022-06-01 20:43:14.607895	\N
13	Masker	2022-06-01 20:43:14.607895	\N
15	Extra	2022-10-09 03:05:29	2022-10-09 03:05:29
\.


--
-- TOC entry 3607 (class 0 OID 18163)
-- Dependencies: 248
-- Data for Name: product_commision_by_year; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
39	2	2	1	30000	1	2022-06-03 18:50:28.944639	\N
40	2	2	1	30000	1	2022-06-03 18:50:28.944639	\N
41	2	2	1	30000	1	2022-06-03 18:50:28.944639	\N
59	2	2	1	30000	1	2022-06-03 18:50:28.944639	\N
43	2	2	5	30000	1	2022-06-03 18:51:09.209737	\N
44	2	2	5	30000	1	2022-06-03 18:51:09.209737	\N
45	2	2	5	30000	1	2022-06-03 18:51:09.209737	\N
46	2	2	5	30000	1	2022-06-03 18:51:09.209737	\N
43	2	2	1	22000	1	2022-06-03 18:50:28.944639	\N
44	2	2	1	22000	1	2022-06-03 18:50:28.944639	\N
45	2	2	1	22000	1	2022-06-03 18:50:28.944639	\N
46	2	2	1	22000	1	2022-06-03 18:50:28.944639	\N
47	2	2	1	17000	1	2022-06-03 18:50:28.944639	\N
48	2	2	1	17000	1	2022-06-03 18:50:28.944639	\N
49	2	2	1	25000	1	2022-06-03 18:50:28.944639	\N
50	2	2	1	15000	1	2022-06-03 18:50:28.944639	\N
51	2	2	1	8000	1	2022-06-03 18:50:28.944639	\N
52	2	2	1	8000	1	2022-06-03 18:50:28.944639	\N
53	2	2	1	40000	1	2022-06-03 18:50:28.944639	\N
54	2	2	1	20000	1	2022-06-03 18:50:28.944639	\N
55	2	2	1	10000	1	2022-06-03 18:50:28.944639	\N
56	2	2	1	10000	1	2022-06-03 18:50:28.944639	\N
57	2	2	1	8000	1	2022-06-03 18:50:28.944639	\N
58	2	2	1	50000	1	2022-06-03 18:50:28.944639	\N
61	2	2	1	55000	1	2022-06-03 18:50:28.944639	\N
62	2	2	1	15000	1	2022-06-03 18:50:28.944639	\N
63	2	2	1	10000	1	2022-06-03 18:50:28.944639	\N
64	2	2	1	8000	1	2022-06-03 18:50:28.944639	\N
65	2	2	1	8000	1	2022-06-03 18:50:28.944639	\N
66	2	2	1	8000	1	2022-06-03 18:50:28.944639	\N
67	2	2	1	8000	1	2022-06-03 18:50:28.944639	\N
69	2	2	1	10000	1	2022-06-03 18:50:28.944639	\N
68	2	2	1	7000	1	2022-06-03 18:50:28.944639	\N
39	2	2	2	32000	1	2022-06-03 18:50:52.711437	\N
39	2	2	3	34000	1	2022-06-03 18:50:57.947429	\N
39	2	2	4	36000	1	2022-06-03 18:51:04.512776	\N
39	2	2	5	38000	1	2022-06-03 18:51:09.209737	\N
40	2	2	2	32000	1	2022-06-03 18:50:52.711437	\N
40	2	2	4	36000	1	2022-06-03 18:51:04.512776	\N
40	2	2	5	38000	1	2022-06-03 18:51:09.209737	\N
41	2	2	2	32000	1	2022-06-03 18:50:52.711437	\N
41	2	2	3	34000	1	2022-06-03 18:50:57.947429	\N
41	2	2	4	36000	1	2022-06-03 18:51:04.512776	\N
41	2	2	5	38000	1	2022-06-03 18:51:09.209737	\N
42	2	2	2	24000	1	2022-06-03 18:50:52.711437	\N
42	2	2	3	26000	1	2022-06-03 18:50:57.947429	\N
42	2	2	4	28000	1	2022-06-03 18:51:04.512776	\N
42	2	2	5	30000	1	2022-06-03 18:51:09.209737	\N
43	2	2	2	24000	1	2022-06-03 18:50:52.711437	\N
43	2	2	3	26000	1	2022-06-03 18:50:57.947429	\N
43	2	2	4	28000	1	2022-06-03 18:51:04.512776	\N
44	2	2	2	24000	1	2022-06-03 18:50:52.711437	\N
44	2	2	4	28000	1	2022-06-03 18:51:04.512776	\N
45	2	2	2	24000	1	2022-06-03 18:50:52.711437	\N
45	2	2	3	26000	1	2022-06-03 18:50:57.947429	\N
45	2	2	4	28000	1	2022-06-03 18:51:04.512776	\N
46	2	2	2	24000	1	2022-06-03 18:50:52.711437	\N
46	2	2	3	26000	1	2022-06-03 18:50:57.947429	\N
46	2	2	4	28000	1	2022-06-03 18:51:04.512776	\N
47	2	2	2	19000	1	2022-06-03 18:50:52.711437	\N
47	2	2	3	21000	1	2022-06-03 18:50:57.947429	\N
47	2	2	4	23000	1	2022-06-03 18:51:04.512776	\N
47	2	2	5	25000	1	2022-06-03 18:51:09.209737	\N
48	2	2	2	19000	1	2022-06-03 18:50:52.711437	\N
48	2	2	3	21000	1	2022-06-03 18:50:57.947429	\N
48	2	2	4	23000	1	2022-06-03 18:51:04.512776	\N
49	2	2	2	27000	1	2022-06-03 18:50:52.711437	\N
49	2	2	3	29000	1	2022-06-03 18:50:57.947429	\N
49	2	2	4	31000	1	2022-06-03 18:51:04.512776	\N
49	2	2	5	33000	1	2022-06-03 18:51:09.209737	\N
50	2	2	2	17000	1	2022-06-03 18:50:52.711437	\N
50	2	2	3	19000	1	2022-06-03 18:50:57.947429	\N
50	2	2	4	21000	1	2022-06-03 18:51:04.512776	\N
51	2	2	2	8000	1	2022-06-03 18:50:52.711437	\N
51	2	2	3	8000	1	2022-06-03 18:50:57.947429	\N
51	2	2	4	9000	1	2022-06-03 18:51:04.512776	\N
52	2	2	2	8000	1	2022-06-03 18:50:52.711437	\N
52	2	2	3	8000	1	2022-06-03 18:50:57.947429	\N
52	2	2	4	8000	1	2022-06-03 18:51:04.512776	\N
53	2	2	2	42000	1	2022-06-03 18:50:52.711437	\N
53	2	2	4	46000	1	2022-06-03 18:51:04.512776	\N
54	2	2	2	22000	1	2022-06-03 18:50:52.711437	\N
54	2	2	3	24000	1	2022-06-03 18:50:57.947429	\N
54	2	2	4	26000	1	2022-06-03 18:51:04.512776	\N
55	2	2	2	10000	1	2022-06-03 18:50:52.711437	\N
55	2	2	3	12000	1	2022-06-03 18:50:57.947429	\N
55	2	2	4	12000	1	2022-06-03 18:51:04.512776	\N
56	2	2	2	10000	1	2022-06-03 18:50:52.711437	\N
56	2	2	3	12000	1	2022-06-03 18:50:57.947429	\N
56	2	2	4	12000	1	2022-06-03 18:51:04.512776	\N
57	2	2	2	8000	1	2022-06-03 18:50:52.711437	\N
57	2	2	3	9000	1	2022-06-03 18:50:57.947429	\N
57	2	2	4	9000	1	2022-06-03 18:51:04.512776	\N
58	2	2	2	52000	1	2022-06-03 18:50:52.711437	\N
58	2	2	4	56000	1	2022-06-03 18:51:04.512776	\N
59	2	2	2	32000	1	2022-06-03 18:50:52.711437	\N
59	2	2	3	34000	1	2022-06-03 18:50:57.947429	\N
59	2	2	4	36000	1	2022-06-03 18:51:04.512776	\N
60	2	2	2	27000	1	2022-06-03 18:50:52.711437	\N
60	2	2	3	29000	1	2022-06-03 18:50:57.947429	\N
60	2	2	4	31000	1	2022-06-03 18:51:04.512776	\N
61	2	2	2	57000	1	2022-06-03 18:50:52.711437	\N
61	2	2	3	59000	1	2022-06-03 18:50:57.947429	\N
61	2	2	4	61000	1	2022-06-03 18:51:04.512776	\N
62	2	2	2	17000	1	2022-06-03 18:50:52.711437	\N
62	2	2	3	19000	1	2022-06-03 18:50:57.947429	\N
62	2	2	4	21000	1	2022-06-03 18:51:04.512776	\N
63	2	2	2	10000	1	2022-06-03 18:50:52.711437	\N
63	2	2	4	16000	1	2022-06-03 18:51:04.512776	\N
64	2	2	2	8000	1	2022-06-03 18:50:52.711437	\N
64	2	2	3	10000	1	2022-06-03 18:50:57.947429	\N
64	2	2	4	10000	1	2022-06-03 18:51:04.512776	\N
65	2	2	2	8000	1	2022-06-03 18:50:52.711437	\N
65	2	2	3	10000	1	2022-06-03 18:50:57.947429	\N
65	2	2	4	10000	1	2022-06-03 18:51:04.512776	\N
66	2	2	2	8000	1	2022-06-03 18:50:52.711437	\N
66	2	2	3	10000	1	2022-06-03 18:50:57.947429	\N
66	2	2	4	10000	1	2022-06-03 18:51:04.512776	\N
67	2	2	2	8000	1	2022-06-03 18:50:52.711437	\N
67	2	2	3	8000	1	2022-06-03 18:50:57.947429	\N
67	2	2	4	9000	1	2022-06-03 18:51:04.512776	\N
68	2	2	2	7000	1	2022-06-03 18:50:52.711437	\N
68	2	2	4	8000	1	2022-06-03 18:51:04.512776	\N
69	2	2	2	10000	1	2022-06-03 18:50:52.711437	\N
69	2	2	3	10000	1	2022-06-03 18:50:57.947429	\N
69	2	2	4	11000	1	2022-06-03 18:51:04.512776	\N
54	2	2	7	30000	1	2022-06-03 18:51:18.966034	\N
39	2	2	7	42000	1	2022-06-03 18:51:18.966034	\N
39	2	2	8	44000	1	2022-06-03 18:51:23.555736	\N
40	2	2	6	40000	1	2022-06-03 18:51:14.244667	\N
40	2	2	7	42000	1	2022-06-03 18:51:18.966034	\N
40	2	2	8	44000	1	2022-06-03 18:51:23.555736	\N
40	2	2	9	46000	1	2022-06-03 18:51:27.832534	\N
41	2	2	6	40000	1	2022-06-03 18:51:14.244667	\N
41	2	2	7	42000	1	2022-06-03 18:51:18.966034	\N
41	2	2	8	44000	1	2022-06-03 18:51:23.555736	\N
41	2	2	9	46000	1	2022-06-03 18:51:27.832534	\N
42	2	2	6	32000	1	2022-06-03 18:51:14.244667	\N
42	2	2	7	34000	1	2022-06-03 18:51:18.966034	\N
42	2	2	8	36000	1	2022-06-03 18:51:23.555736	\N
42	2	2	9	38000	1	2022-06-03 18:51:27.832534	\N
43	2	2	6	32000	1	2022-06-03 18:51:14.244667	\N
43	2	2	7	34000	1	2022-06-03 18:51:18.966034	\N
43	2	2	9	38000	1	2022-06-03 18:51:27.832534	\N
44	2	2	6	32000	1	2022-06-03 18:51:14.244667	\N
44	2	2	7	34000	1	2022-06-03 18:51:18.966034	\N
44	2	2	8	36000	1	2022-06-03 18:51:23.555736	\N
44	2	2	9	38000	1	2022-06-03 18:51:27.832534	\N
45	2	2	6	32000	1	2022-06-03 18:51:14.244667	\N
45	2	2	7	34000	1	2022-06-03 18:51:18.966034	\N
45	2	2	8	36000	1	2022-06-03 18:51:23.555736	\N
45	2	2	9	38000	1	2022-06-03 18:51:27.832534	\N
46	2	2	6	32000	1	2022-06-03 18:51:14.244667	\N
46	2	2	7	34000	1	2022-06-03 18:51:18.966034	\N
46	2	2	8	36000	1	2022-06-03 18:51:23.555736	\N
46	2	2	9	38000	1	2022-06-03 18:51:27.832534	\N
47	2	2	6	27000	1	2022-06-03 18:51:14.244667	\N
47	2	2	8	31000	1	2022-06-03 18:51:23.555736	\N
47	2	2	9	33000	1	2022-06-03 18:51:27.832534	\N
48	2	2	6	27000	1	2022-06-03 18:51:14.244667	\N
48	2	2	7	29000	1	2022-06-03 18:51:18.966034	\N
48	2	2	8	31000	1	2022-06-03 18:51:23.555736	\N
48	2	2	9	33000	1	2022-06-03 18:51:27.832534	\N
49	2	2	6	34000	1	2022-06-03 18:51:14.244667	\N
49	2	2	7	35000	1	2022-06-03 18:51:18.966034	\N
49	2	2	8	36000	1	2022-06-03 18:51:23.555736	\N
49	2	2	9	37000	1	2022-06-03 18:51:27.832534	\N
50	2	2	5	23000	1	2022-06-03 18:51:09.209737	\N
50	2	2	6	25000	1	2022-06-03 18:51:14.244667	\N
50	2	2	7	27000	1	2022-06-03 18:51:18.966034	\N
50	2	2	8	29000	1	2022-06-03 18:51:23.555736	\N
51	2	2	5	9000	1	2022-06-03 18:51:09.209737	\N
51	2	2	6	9000	1	2022-06-03 18:51:14.244667	\N
51	2	2	7	10000	1	2022-06-03 18:51:18.966034	\N
51	2	2	8	10000	1	2022-06-03 18:51:23.555736	\N
51	2	2	9	10000	1	2022-06-03 18:51:27.832534	\N
52	2	2	5	8000	1	2022-06-03 18:51:09.209737	\N
52	2	2	6	8000	1	2022-06-03 18:51:14.244667	\N
52	2	2	7	8000	1	2022-06-03 18:51:18.966034	\N
52	2	2	8	8000	1	2022-06-03 18:51:23.555736	\N
52	2	2	9	8000	1	2022-06-03 18:51:27.832534	\N
53	2	2	5	48000	1	2022-06-03 18:51:09.209737	\N
53	2	2	6	50000	1	2022-06-03 18:51:14.244667	\N
53	2	2	7	52000	1	2022-06-03 18:51:18.966034	\N
53	2	2	8	54000	1	2022-06-03 18:51:23.555736	\N
54	2	2	5	28000	1	2022-06-03 18:51:09.209737	\N
54	2	2	6	29000	1	2022-06-03 18:51:14.244667	\N
54	2	2	8	31000	1	2022-06-03 18:51:23.555736	\N
54	2	2	9	32000	1	2022-06-03 18:51:27.832534	\N
55	2	2	5	14000	1	2022-06-03 18:51:09.209737	\N
55	2	2	6	14000	1	2022-06-03 18:51:14.244667	\N
55	2	2	7	16000	1	2022-06-03 18:51:18.966034	\N
55	2	2	8	16000	1	2022-06-03 18:51:23.555736	\N
55	2	2	9	18000	1	2022-06-03 18:51:27.832534	\N
56	2	2	5	14000	1	2022-06-03 18:51:09.209737	\N
56	2	2	6	14000	1	2022-06-03 18:51:14.244667	\N
56	2	2	7	16000	1	2022-06-03 18:51:18.966034	\N
56	2	2	8	16000	1	2022-06-03 18:51:23.555736	\N
56	2	2	9	18000	1	2022-06-03 18:51:27.832534	\N
57	2	2	6	10000	1	2022-06-03 18:51:14.244667	\N
57	2	2	7	11000	1	2022-06-03 18:51:18.966034	\N
57	2	2	8	11000	1	2022-06-03 18:51:23.555736	\N
57	2	2	9	12000	1	2022-06-03 18:51:27.832534	\N
58	2	2	5	58000	1	2022-06-03 18:51:09.209737	\N
58	2	2	6	60000	1	2022-06-03 18:51:14.244667	\N
58	2	2	7	62000	1	2022-06-03 18:51:18.966034	\N
58	2	2	8	64000	1	2022-06-03 18:51:23.555736	\N
58	2	2	9	66000	1	2022-06-03 18:51:27.832534	\N
59	2	2	5	38000	1	2022-06-03 18:51:09.209737	\N
59	2	2	6	39000	1	2022-06-03 18:51:14.244667	\N
59	2	2	7	40000	1	2022-06-03 18:51:18.966034	\N
59	2	2	8	41000	1	2022-06-03 18:51:23.555736	\N
59	2	2	9	42000	1	2022-06-03 18:51:27.832534	\N
60	2	2	6	34000	1	2022-06-03 18:51:14.244667	\N
60	2	2	7	35000	1	2022-06-03 18:51:18.966034	\N
60	2	2	8	36000	1	2022-06-03 18:51:23.555736	\N
60	2	2	9	37000	1	2022-06-03 18:51:27.832534	\N
61	2	2	5	63000	1	2022-06-03 18:51:09.209737	\N
61	2	2	6	65000	1	2022-06-03 18:51:14.244667	\N
61	2	2	7	67000	1	2022-06-03 18:51:18.966034	\N
61	2	2	8	69000	1	2022-06-03 18:51:23.555736	\N
61	2	2	9	71000	1	2022-06-03 18:51:27.832534	\N
62	2	2	5	23000	1	2022-06-03 18:51:09.209737	\N
62	2	2	6	25000	1	2022-06-03 18:51:14.244667	\N
62	2	2	7	27000	1	2022-06-03 18:51:18.966034	\N
62	2	2	8	29000	1	2022-06-03 18:51:23.555736	\N
63	2	2	5	18000	1	2022-06-03 18:51:09.209737	\N
63	2	2	7	20000	1	2022-06-03 18:51:18.966034	\N
63	2	2	8	21000	1	2022-06-03 18:51:23.555736	\N
64	2	2	5	12000	1	2022-06-03 18:51:09.209737	\N
64	2	2	6	12000	1	2022-06-03 18:51:14.244667	\N
64	2	2	7	14000	1	2022-06-03 18:51:18.966034	\N
64	2	2	8	14000	1	2022-06-03 18:51:23.555736	\N
65	2	2	5	12000	1	2022-06-03 18:51:09.209737	\N
65	2	2	6	12000	1	2022-06-03 18:51:14.244667	\N
65	2	2	7	14000	1	2022-06-03 18:51:18.966034	\N
65	2	2	8	14000	1	2022-06-03 18:51:23.555736	\N
66	2	2	5	12000	1	2022-06-03 18:51:09.209737	\N
66	2	2	6	12000	1	2022-06-03 18:51:14.244667	\N
66	2	2	7	14000	1	2022-06-03 18:51:18.966034	\N
66	2	2	8	14000	1	2022-06-03 18:51:23.555736	\N
67	2	2	6	9000	1	2022-06-03 18:51:14.244667	\N
67	2	2	7	10000	1	2022-06-03 18:51:18.966034	\N
67	2	2	8	10000	1	2022-06-03 18:51:23.555736	\N
68	2	2	5	8000	1	2022-06-03 18:51:09.209737	\N
68	2	2	6	8000	1	2022-06-03 18:51:14.244667	\N
68	2	2	7	9000	1	2022-06-03 18:51:18.966034	\N
68	2	2	8	9000	1	2022-06-03 18:51:23.555736	\N
69	2	2	5	11000	1	2022-06-03 18:51:09.209737	\N
69	2	2	6	11000	1	2022-06-03 18:51:14.244667	\N
69	2	2	7	12000	1	2022-06-03 18:51:18.966034	\N
69	2	2	8	12000	1	2022-06-03 18:51:23.555736	\N
42	2	2	1	22000	1	2022-06-03 18:50:28.944639	\N
60	2	2	1	25000	1	2022-06-03 18:50:28.944639	\N
39	2	2	6	40000	1	2022-06-03 18:51:14.244667	\N
39	2	2	9	46000	1	2022-06-03 18:51:27.832534	\N
39	2	2	10	48000	1	2022-06-03 18:51:32.672537	\N
40	2	2	3	34000	1	2022-06-03 18:50:57.947429	\N
40	2	2	10	48000	1	2022-06-03 18:51:32.672537	\N
41	2	2	10	48000	1	2022-06-03 18:51:32.672537	\N
42	2	2	10	40000	1	2022-06-03 18:51:32.672537	\N
43	2	2	8	36000	1	2022-06-03 18:51:23.555736	\N
43	2	2	10	40000	1	2022-06-03 18:51:32.672537	\N
44	2	2	3	26000	1	2022-06-03 18:50:57.947429	\N
44	2	2	10	40000	1	2022-06-03 18:51:32.672537	\N
45	2	2	10	40000	1	2022-06-03 18:51:32.672537	\N
46	2	2	10	40000	1	2022-06-03 18:51:32.672537	\N
47	2	2	7	29000	1	2022-06-03 18:51:18.966034	\N
47	2	2	10	35000	1	2022-06-03 18:51:32.672537	\N
48	2	2	5	25000	1	2022-06-03 18:51:09.209737	\N
48	2	2	10	35000	1	2022-06-03 18:51:32.672537	\N
49	2	2	10	38000	1	2022-06-03 18:51:32.672537	\N
50	2	2	9	31000	1	2022-06-03 18:51:27.832534	\N
50	2	2	10	33000	1	2022-06-03 18:51:32.672537	\N
51	2	2	10	11000	1	2022-06-03 18:51:32.672537	\N
52	2	2	10	8000	1	2022-06-03 18:51:32.672537	\N
53	2	2	3	44000	1	2022-06-03 18:50:57.947429	\N
53	2	2	9	56000	1	2022-06-03 18:51:27.832534	\N
53	2	2	10	58000	1	2022-06-03 18:51:32.672537	\N
54	2	2	10	33000	1	2022-06-03 18:51:32.672537	\N
55	2	2	10	18000	1	2022-06-03 18:51:32.672537	\N
56	2	2	10	18000	1	2022-06-03 18:51:32.672537	\N
57	2	2	5	10000	1	2022-06-03 18:51:09.209737	\N
57	2	2	10	12000	1	2022-06-03 18:51:32.672537	\N
58	2	2	3	54000	1	2022-06-03 18:50:57.947429	\N
58	2	2	10	68000	1	2022-06-03 18:51:32.672537	\N
59	2	2	10	43000	1	2022-06-03 18:51:32.672537	\N
60	2	2	5	33000	1	2022-06-03 18:51:09.209737	\N
60	2	2	10	38000	1	2022-06-03 18:51:32.672537	\N
61	2	2	10	73000	1	2022-06-03 18:51:32.672537	\N
62	2	2	9	31000	1	2022-06-03 18:51:27.832534	\N
62	2	2	10	33000	1	2022-06-03 18:51:32.672537	\N
63	2	2	3	14000	1	2022-06-03 18:50:57.947429	\N
63	2	2	6	19000	1	2022-06-03 18:51:14.244667	\N
63	2	2	9	22000	1	2022-06-03 18:51:27.832534	\N
63	2	2	10	23000	1	2022-06-03 18:51:32.672537	\N
64	2	2	9	16000	1	2022-06-03 18:51:27.832534	\N
64	2	2	10	16000	1	2022-06-03 18:51:32.672537	\N
65	2	2	9	16000	1	2022-06-03 18:51:27.832534	\N
65	2	2	10	16000	1	2022-06-03 18:51:32.672537	\N
66	2	2	9	16000	1	2022-06-03 18:51:27.832534	\N
66	2	2	10	16000	1	2022-06-03 18:51:32.672537	\N
67	2	2	5	9000	1	2022-06-03 18:51:09.209737	\N
67	2	2	9	10000	1	2022-06-03 18:51:27.832534	\N
67	2	2	10	11000	1	2022-06-03 18:51:32.672537	\N
68	2	2	3	7000	1	2022-06-03 18:50:57.947429	\N
68	2	2	9	9000	1	2022-06-03 18:51:27.832534	\N
68	2	2	10	10000	1	2022-06-03 18:51:32.672537	\N
69	2	2	9	12000	1	2022-06-03 18:51:27.832534	\N
69	2	2	10	13000	1	2022-06-03 18:51:32.672537	\N
\.


--
-- TOC entry 3605 (class 0 OID 18143)
-- Dependencies: 246
-- Data for Name: product_commisions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
33	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
34	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
35	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
36	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
37	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
39	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
40	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
41	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
42	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
43	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
44	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
45	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
46	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
47	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
48	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
49	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
50	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
51	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
52	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
53	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
54	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
55	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
56	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
57	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
58	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
59	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
60	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
61	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
62	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
63	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
64	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
65	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
66	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
67	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
68	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
70	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
69	2	0	0	0	2022-06-03 18:34:36.005823	1		\N
1	2	0	0	25000	2022-06-03 18:34:36.005823	1		\N
2	2	2000	10000	12000	2022-06-03 18:34:36.005823	1		\N
3	2	0	0	50000	2022-06-03 18:34:36.005823	1		\N
4	2	0	0	25000	2022-06-03 18:34:36.005823	1		\N
5	2	0	0	25000	2022-06-03 18:34:36.005823	1		\N
6	2	0	0	10000	2022-06-03 18:34:36.005823	1		\N
7	2	0	0	50000	2022-06-03 18:34:36.005823	1		\N
8	2	0	0	30000	2022-06-03 18:34:36.005823	1		\N
9	2	0	0	10000	2022-06-03 18:34:36.005823	1		\N
11	2	0	0	10000	2022-06-03 18:34:36.005823	1		\N
14	2	0	0	5000	2022-06-03 18:34:36.005823	1		\N
15	2	0	0	15000	2022-06-03 18:34:36.005823	1		\N
16	2	0	0	15000	2022-06-03 18:34:36.005823	1		\N
17	2	0	0	10000	2022-06-03 18:34:36.005823	1		\N
18	2	0	0	10000	2022-06-03 18:34:36.005823	1		\N
19	2	0	0	50000	2022-06-03 18:34:36.005823	1		\N
20	2	0	0	20000	2022-06-03 18:34:36.005823	1		\N
21	2	0	0	20000	2022-06-03 18:34:36.005823	1		\N
22	2	0	0	20000	2022-06-03 18:34:36.005823	1		\N
23	2	0	0	15000	2022-06-03 18:34:36.005823	1		\N
24	2	0	0	15000	2022-06-03 18:34:36.005823	1		\N
25	2	0	0	10000	2022-06-03 18:34:36.005823	1		\N
26	2	0	0	25000	2022-06-03 18:34:36.005823	1		\N
27	2	0	0	10000	2022-06-03 18:34:36.005823	1		\N
10	2	4000	16000	20000	2022-06-03 18:34:36.005823	1		\N
12	2	4000	16000	20000	2022-06-03 18:34:36.005823	1		\N
13	2	3000	12000	15000	2022-06-03 18:34:36.005823	1		\N
28	2	0	0	50000	2022-06-03 18:34:36.005823	1		\N
29	2	0	0	30000	2022-06-03 18:34:36.005823	1		\N
30	2	0	0	5000	2022-06-03 18:34:36.005823	1		\N
31	2	0	0	10000	2022-06-03 18:34:36.005823	1		\N
32	2	0	0	10000	2022-06-03 18:34:36.005823	1		\N
76	1	5000	7000	6000	2022-07-28 10:56:18	1	\N	2022-07-28 10:57:53
\.


--
-- TOC entry 3599 (class 0 OID 18094)
-- Dependencies: 240
-- Data for Name: product_distribution; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
1	1	2022-06-02 21:03:50.006459	\N	1
8	1	2022-06-02 21:03:50.006459	\N	1
9	1	2022-06-02 21:03:50.006459	\N	1
10	1	2022-06-02 21:03:50.006459	\N	1
11	1	2022-06-02 21:03:50.006459	\N	1
12	1	2022-06-02 21:03:50.006459	\N	1
13	1	2022-06-02 21:03:50.006459	\N	1
18	1	2022-06-02 21:03:50.006459	\N	1
19	1	2022-06-02 21:03:50.006459	\N	1
20	1	2022-06-02 21:03:50.006459	\N	1
21	1	2022-06-02 21:03:50.006459	\N	1
24	1	2022-06-02 21:03:50.006459	\N	1
27	1	2022-06-02 21:03:50.006459	\N	1
28	1	2022-06-02 21:03:50.006459	\N	1
29	1	2022-06-02 21:03:50.006459	\N	1
30	1	2022-06-02 21:03:50.006459	\N	1
31	1	2022-06-02 21:03:50.006459	\N	1
33	1	2022-06-02 21:03:50.006459	\N	1
34	1	2022-06-02 21:03:50.006459	\N	1
2	1	2022-06-02 21:03:50.006459	\N	1
3	1	2022-06-02 21:03:50.006459	\N	1
4	1	2022-06-02 21:03:50.006459	\N	1
5	1	2022-06-02 21:03:50.006459	\N	1
32	1	2022-06-02 21:03:50.006459	\N	1
6	1	2022-06-02 21:03:50.006459	\N	1
22	1	2022-06-02 21:03:50.006459	\N	1
7	1	2022-06-02 21:03:50.006459	\N	1
14	1	2022-06-02 21:03:50.006459	\N	1
15	1	2022-06-02 21:03:50.006459	\N	1
16	1	2022-06-02 21:03:50.006459	\N	1
23	1	2022-06-02 21:03:50.006459	\N	1
35	1	2022-06-02 21:03:50.006459	\N	1
36	1	2022-06-02 21:03:50.006459	\N	1
37	1	2022-06-02 21:03:50.006459	\N	1
25	1	2022-06-02 21:03:50.006459	\N	1
26	1	2022-06-02 21:03:50.006459	\N	1
17	1	2022-06-02 21:03:50.006459	\N	1
39	1	2022-06-02 21:03:50.006459	\N	1
40	1	2022-06-02 21:03:50.006459	\N	1
41	1	2022-06-02 21:03:50.006459	\N	1
42	1	2022-06-02 21:03:50.006459	\N	1
43	1	2022-06-02 21:03:50.006459	\N	1
44	1	2022-06-02 21:03:50.006459	\N	1
45	1	2022-06-02 21:03:50.006459	\N	1
46	1	2022-06-02 21:03:50.006459	\N	1
47	1	2022-06-02 21:03:50.006459	\N	1
48	1	2022-06-02 21:03:50.006459	\N	1
49	1	2022-06-02 21:03:50.006459	\N	1
50	1	2022-06-02 21:03:50.006459	\N	1
51	1	2022-06-02 21:03:50.006459	\N	1
52	1	2022-06-02 21:03:50.006459	\N	1
53	1	2022-06-02 21:03:50.006459	\N	1
54	1	2022-06-02 21:03:50.006459	\N	1
55	1	2022-06-02 21:03:50.006459	\N	1
56	1	2022-06-02 21:03:50.006459	\N	1
57	1	2022-06-02 21:03:50.006459	\N	1
58	1	2022-06-02 21:03:50.006459	\N	1
59	1	2022-06-02 21:03:50.006459	\N	1
60	1	2022-06-02 21:03:50.006459	\N	1
61	1	2022-06-02 21:03:50.006459	\N	1
62	1	2022-06-02 21:03:50.006459	\N	1
63	1	2022-06-02 21:03:50.006459	\N	1
64	1	2022-06-02 21:03:50.006459	\N	1
65	1	2022-06-02 21:03:50.006459	\N	1
66	1	2022-06-02 21:03:50.006459	\N	1
67	1	2022-06-02 21:03:50.006459	\N	1
68	1	2022-06-02 21:03:50.006459	\N	1
1	2	2022-06-02 21:03:50.006459	\N	1
8	2	2022-06-02 21:03:50.006459	\N	1
9	2	2022-06-02 21:03:50.006459	\N	1
10	2	2022-06-02 21:03:50.006459	\N	1
11	2	2022-06-02 21:03:50.006459	\N	1
12	2	2022-06-02 21:03:50.006459	\N	1
13	2	2022-06-02 21:03:50.006459	\N	1
18	2	2022-06-02 21:03:50.006459	\N	1
19	2	2022-06-02 21:03:50.006459	\N	1
20	2	2022-06-02 21:03:50.006459	\N	1
21	2	2022-06-02 21:03:50.006459	\N	1
24	2	2022-06-02 21:03:50.006459	\N	1
27	2	2022-06-02 21:03:50.006459	\N	1
28	2	2022-06-02 21:03:50.006459	\N	1
29	2	2022-06-02 21:03:50.006459	\N	1
30	2	2022-06-02 21:03:50.006459	\N	1
31	2	2022-06-02 21:03:50.006459	\N	1
33	2	2022-06-02 21:03:50.006459	\N	1
34	2	2022-06-02 21:03:50.006459	\N	1
2	2	2022-06-02 21:03:50.006459	\N	1
3	2	2022-06-02 21:03:50.006459	\N	1
4	2	2022-06-02 21:03:50.006459	\N	1
5	2	2022-06-02 21:03:50.006459	\N	1
32	2	2022-06-02 21:03:50.006459	\N	1
6	2	2022-06-02 21:03:50.006459	\N	1
22	2	2022-06-02 21:03:50.006459	\N	1
7	2	2022-06-02 21:03:50.006459	\N	1
14	2	2022-06-02 21:03:50.006459	\N	1
15	2	2022-06-02 21:03:50.006459	\N	1
16	2	2022-06-02 21:03:50.006459	\N	1
23	2	2022-06-02 21:03:50.006459	\N	1
35	2	2022-06-02 21:03:50.006459	\N	1
36	2	2022-06-02 21:03:50.006459	\N	1
37	2	2022-06-02 21:03:50.006459	\N	1
25	2	2022-06-02 21:03:50.006459	\N	1
26	2	2022-06-02 21:03:50.006459	\N	1
17	2	2022-06-02 21:03:50.006459	\N	1
39	2	2022-06-02 21:03:50.006459	\N	1
40	2	2022-06-02 21:03:50.006459	\N	1
41	2	2022-06-02 21:03:50.006459	\N	1
42	2	2022-06-02 21:03:50.006459	\N	1
43	2	2022-06-02 21:03:50.006459	\N	1
44	2	2022-06-02 21:03:50.006459	\N	1
45	2	2022-06-02 21:03:50.006459	\N	1
46	2	2022-06-02 21:03:50.006459	\N	1
47	2	2022-06-02 21:03:50.006459	\N	1
48	2	2022-06-02 21:03:50.006459	\N	1
49	2	2022-06-02 21:03:50.006459	\N	1
50	2	2022-06-02 21:03:50.006459	\N	1
51	2	2022-06-02 21:03:50.006459	\N	1
52	2	2022-06-02 21:03:50.006459	\N	1
53	2	2022-06-02 21:03:50.006459	\N	1
54	2	2022-06-02 21:03:50.006459	\N	1
55	2	2022-06-02 21:03:50.006459	\N	1
56	2	2022-06-02 21:03:50.006459	\N	1
57	2	2022-06-02 21:03:50.006459	\N	1
58	2	2022-06-02 21:03:50.006459	\N	1
59	2	2022-06-02 21:03:50.006459	\N	1
60	2	2022-06-02 21:03:50.006459	\N	1
61	2	2022-06-02 21:03:50.006459	\N	1
62	2	2022-06-02 21:03:50.006459	\N	1
63	2	2022-06-02 21:03:50.006459	\N	1
64	2	2022-06-02 21:03:50.006459	\N	1
65	2	2022-06-02 21:03:50.006459	\N	1
66	2	2022-06-02 21:03:50.006459	\N	1
67	2	2022-06-02 21:03:50.006459	\N	1
68	2	2022-06-02 21:03:50.006459	\N	1
1	3	2022-06-02 21:03:50.006459	\N	1
8	3	2022-06-02 21:03:50.006459	\N	1
9	3	2022-06-02 21:03:50.006459	\N	1
10	3	2022-06-02 21:03:50.006459	\N	1
11	3	2022-06-02 21:03:50.006459	\N	1
12	3	2022-06-02 21:03:50.006459	\N	1
13	3	2022-06-02 21:03:50.006459	\N	1
18	3	2022-06-02 21:03:50.006459	\N	1
19	3	2022-06-02 21:03:50.006459	\N	1
20	3	2022-06-02 21:03:50.006459	\N	1
21	3	2022-06-02 21:03:50.006459	\N	1
24	3	2022-06-02 21:03:50.006459	\N	1
27	3	2022-06-02 21:03:50.006459	\N	1
28	3	2022-06-02 21:03:50.006459	\N	1
29	3	2022-06-02 21:03:50.006459	\N	1
30	3	2022-06-02 21:03:50.006459	\N	1
31	3	2022-06-02 21:03:50.006459	\N	1
33	3	2022-06-02 21:03:50.006459	\N	1
34	3	2022-06-02 21:03:50.006459	\N	1
2	3	2022-06-02 21:03:50.006459	\N	1
3	3	2022-06-02 21:03:50.006459	\N	1
4	3	2022-06-02 21:03:50.006459	\N	1
5	3	2022-06-02 21:03:50.006459	\N	1
32	3	2022-06-02 21:03:50.006459	\N	1
6	3	2022-06-02 21:03:50.006459	\N	1
22	3	2022-06-02 21:03:50.006459	\N	1
7	3	2022-06-02 21:03:50.006459	\N	1
14	3	2022-06-02 21:03:50.006459	\N	1
15	3	2022-06-02 21:03:50.006459	\N	1
16	3	2022-06-02 21:03:50.006459	\N	1
23	3	2022-06-02 21:03:50.006459	\N	1
35	3	2022-06-02 21:03:50.006459	\N	1
36	3	2022-06-02 21:03:50.006459	\N	1
37	3	2022-06-02 21:03:50.006459	\N	1
25	3	2022-06-02 21:03:50.006459	\N	1
26	3	2022-06-02 21:03:50.006459	\N	1
17	3	2022-06-02 21:03:50.006459	\N	1
39	3	2022-06-02 21:03:50.006459	\N	1
40	3	2022-06-02 21:03:50.006459	\N	1
41	3	2022-06-02 21:03:50.006459	\N	1
42	3	2022-06-02 21:03:50.006459	\N	1
43	3	2022-06-02 21:03:50.006459	\N	1
44	3	2022-06-02 21:03:50.006459	\N	1
45	3	2022-06-02 21:03:50.006459	\N	1
46	3	2022-06-02 21:03:50.006459	\N	1
47	3	2022-06-02 21:03:50.006459	\N	1
48	3	2022-06-02 21:03:50.006459	\N	1
49	3	2022-06-02 21:03:50.006459	\N	1
50	3	2022-06-02 21:03:50.006459	\N	1
51	3	2022-06-02 21:03:50.006459	\N	1
52	3	2022-06-02 21:03:50.006459	\N	1
53	3	2022-06-02 21:03:50.006459	\N	1
54	3	2022-06-02 21:03:50.006459	\N	1
55	3	2022-06-02 21:03:50.006459	\N	1
56	3	2022-06-02 21:03:50.006459	\N	1
57	3	2022-06-02 21:03:50.006459	\N	1
58	3	2022-06-02 21:03:50.006459	\N	1
59	3	2022-06-02 21:03:50.006459	\N	1
60	3	2022-06-02 21:03:50.006459	\N	1
61	3	2022-06-02 21:03:50.006459	\N	1
62	3	2022-06-02 21:03:50.006459	\N	1
63	3	2022-06-02 21:03:50.006459	\N	1
64	3	2022-06-02 21:03:50.006459	\N	1
65	3	2022-06-02 21:03:50.006459	\N	1
66	3	2022-06-02 21:03:50.006459	\N	1
67	3	2022-06-02 21:03:50.006459	\N	1
68	3	2022-06-02 21:03:50.006459	\N	1
83	1	2022-10-09 03:15:42	2022-10-09 03:15:42	1
83	2	2022-10-09 03:16:03	2022-10-09 03:16:03	1
83	3	2022-10-09 03:16:12	2022-10-09 03:16:12	1
86	1	2022-10-09 03:16:21	2022-10-09 03:16:21	1
86	3	2022-10-09 03:16:32	2022-10-09 03:16:32	1
84	1	2022-10-09 03:16:43	2022-10-09 03:16:43	1
84	3	2022-10-09 03:16:56	2022-10-09 03:16:56	1
85	1	2022-10-09 03:17:05	2022-10-09 03:17:05	1
85	2	2022-10-09 03:17:15	2022-10-09 03:17:15	1
85	3	2022-10-09 03:17:26	2022-10-09 03:17:26	1
89	1	2022-10-15 20:39:51	2022-10-15 20:39:51	1
89	2	2022-10-15 20:40:02	2022-10-15 20:40:02	1
89	3	2022-10-15 20:40:14	2022-10-15 20:40:14	1
\.


--
-- TOC entry 3630 (class 0 OID 18707)
-- Dependencies: 271
-- Data for Name: product_ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
52	53	1	1	\N	1	2022-09-07 20:23:11.759266
1	9	17	1	2022-09-07 14:28:25	1	2022-09-07 14:28:25
53	34	17	100	2022-09-07 14:56:43	1	2022-09-07 14:56:43
1	8	12	2	2022-09-18 01:41:45	1	2022-09-18 01:41:45
\.


--
-- TOC entry 3606 (class 0 OID 18157)
-- Dependencies: 247
-- Data for Name: product_point; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
1	1	1	1	2022-06-02 21:09:40.977165	\N
8	1	1	1	2022-06-02 21:09:40.977165	\N
9	1	1	1	2022-06-02 21:09:40.977165	\N
10	1	1	1	2022-06-02 21:09:40.977165	\N
11	1	1	1	2022-06-02 21:09:40.977165	\N
12	1	1	1	2022-06-02 21:09:40.977165	\N
13	1	1	1	2022-06-02 21:09:40.977165	\N
18	1	1	1	2022-06-02 21:09:40.977165	\N
19	1	1	1	2022-06-02 21:09:40.977165	\N
20	1	1	1	2022-06-02 21:09:40.977165	\N
21	1	1	1	2022-06-02 21:09:40.977165	\N
24	1	1	1	2022-06-02 21:09:40.977165	\N
27	1	1	1	2022-06-02 21:09:40.977165	\N
28	1	1	1	2022-06-02 21:09:40.977165	\N
29	1	1	1	2022-06-02 21:09:40.977165	\N
30	1	1	1	2022-06-02 21:09:40.977165	\N
31	1	1	1	2022-06-02 21:09:40.977165	\N
33	1	1	1	2022-06-02 21:09:40.977165	\N
34	1	1	1	2022-06-02 21:09:40.977165	\N
2	1	1	1	2022-06-02 21:09:40.977165	\N
3	1	1	1	2022-06-02 21:09:40.977165	\N
4	1	1	1	2022-06-02 21:09:40.977165	\N
5	1	1	1	2022-06-02 21:09:40.977165	\N
32	1	1	1	2022-06-02 21:09:40.977165	\N
6	1	1	1	2022-06-02 21:09:40.977165	\N
22	1	1	1	2022-06-02 21:09:40.977165	\N
7	1	1	1	2022-06-02 21:09:40.977165	\N
14	1	1	1	2022-06-02 21:09:40.977165	\N
15	1	1	1	2022-06-02 21:09:40.977165	\N
16	1	1	1	2022-06-02 21:09:40.977165	\N
23	1	1	1	2022-06-02 21:09:40.977165	\N
35	1	1	1	2022-06-02 21:09:40.977165	\N
36	1	1	1	2022-06-02 21:09:40.977165	\N
37	1	1	1	2022-06-02 21:09:40.977165	\N
25	1	1	1	2022-06-02 21:09:40.977165	\N
26	1	1	1	2022-06-02 21:09:40.977165	\N
17	1	1	1	2022-06-02 21:09:40.977165	\N
39	1	1	1	2022-06-02 21:09:40.977165	\N
40	1	1	1	2022-06-02 21:09:40.977165	\N
41	1	1	1	2022-06-02 21:09:40.977165	\N
42	1	1	1	2022-06-02 21:09:40.977165	\N
43	1	1	1	2022-06-02 21:09:40.977165	\N
44	1	1	1	2022-06-02 21:09:40.977165	\N
45	1	1	1	2022-06-02 21:09:40.977165	\N
46	1	1	1	2022-06-02 21:09:40.977165	\N
47	1	1	1	2022-06-02 21:09:40.977165	\N
48	1	1	1	2022-06-02 21:09:40.977165	\N
49	1	1	1	2022-06-02 21:09:40.977165	\N
50	1	1	1	2022-06-02 21:09:40.977165	\N
53	1	1	1	2022-06-02 21:09:40.977165	\N
54	1	1	1	2022-06-02 21:09:40.977165	\N
59	1	1	1	2022-06-02 21:09:40.977165	\N
60	1	1	1	2022-06-02 21:09:40.977165	\N
61	1	1	1	2022-06-02 21:09:40.977165	\N
62	1	1	1	2022-06-02 21:09:40.977165	\N
63	1	1	1	2022-06-02 21:09:40.977165	\N
1	2	1	1	2022-06-02 21:09:40.977165	\N
8	2	1	1	2022-06-02 21:09:40.977165	\N
9	2	1	1	2022-06-02 21:09:40.977165	\N
10	2	1	1	2022-06-02 21:09:40.977165	\N
11	2	1	1	2022-06-02 21:09:40.977165	\N
12	2	1	1	2022-06-02 21:09:40.977165	\N
13	2	1	1	2022-06-02 21:09:40.977165	\N
18	2	1	1	2022-06-02 21:09:40.977165	\N
19	2	1	1	2022-06-02 21:09:40.977165	\N
20	2	1	1	2022-06-02 21:09:40.977165	\N
21	2	1	1	2022-06-02 21:09:40.977165	\N
24	2	1	1	2022-06-02 21:09:40.977165	\N
27	2	1	1	2022-06-02 21:09:40.977165	\N
28	2	1	1	2022-06-02 21:09:40.977165	\N
29	2	1	1	2022-06-02 21:09:40.977165	\N
30	2	1	1	2022-06-02 21:09:40.977165	\N
31	2	1	1	2022-06-02 21:09:40.977165	\N
33	2	1	1	2022-06-02 21:09:40.977165	\N
34	2	1	1	2022-06-02 21:09:40.977165	\N
2	2	1	1	2022-06-02 21:09:40.977165	\N
3	2	1	1	2022-06-02 21:09:40.977165	\N
4	2	1	1	2022-06-02 21:09:40.977165	\N
5	2	1	1	2022-06-02 21:09:40.977165	\N
32	2	1	1	2022-06-02 21:09:40.977165	\N
6	2	1	1	2022-06-02 21:09:40.977165	\N
22	2	1	1	2022-06-02 21:09:40.977165	\N
7	2	1	1	2022-06-02 21:09:40.977165	\N
14	2	1	1	2022-06-02 21:09:40.977165	\N
15	2	1	1	2022-06-02 21:09:40.977165	\N
16	2	1	1	2022-06-02 21:09:40.977165	\N
23	2	1	1	2022-06-02 21:09:40.977165	\N
35	2	1	1	2022-06-02 21:09:40.977165	\N
36	2	1	1	2022-06-02 21:09:40.977165	\N
37	2	1	1	2022-06-02 21:09:40.977165	\N
25	2	1	1	2022-06-02 21:09:40.977165	\N
26	2	1	1	2022-06-02 21:09:40.977165	\N
17	2	1	1	2022-06-02 21:09:40.977165	\N
39	2	1	1	2022-06-02 21:09:40.977165	\N
40	2	1	1	2022-06-02 21:09:40.977165	\N
41	2	1	1	2022-06-02 21:09:40.977165	\N
42	2	1	1	2022-06-02 21:09:40.977165	\N
43	2	1	1	2022-06-02 21:09:40.977165	\N
44	2	1	1	2022-06-02 21:09:40.977165	\N
45	2	1	1	2022-06-02 21:09:40.977165	\N
46	2	1	1	2022-06-02 21:09:40.977165	\N
47	2	1	1	2022-06-02 21:09:40.977165	\N
48	2	1	1	2022-06-02 21:09:40.977165	\N
49	2	1	1	2022-06-02 21:09:40.977165	\N
50	2	1	1	2022-06-02 21:09:40.977165	\N
51	2	1	1	2022-06-02 21:09:40.977165	\N
53	2	1	1	2022-06-02 21:09:40.977165	\N
54	2	1	1	2022-06-02 21:09:40.977165	\N
59	2	1	1	2022-06-02 21:09:40.977165	\N
60	2	1	1	2022-06-02 21:09:40.977165	\N
61	2	1	1	2022-06-02 21:09:40.977165	\N
62	2	1	1	2022-06-02 21:09:40.977165	\N
63	2	1	1	2022-06-02 21:09:40.977165	\N
1	3	1	1	2022-06-02 21:09:40.977165	\N
8	3	1	1	2022-06-02 21:09:40.977165	\N
9	3	1	1	2022-06-02 21:09:40.977165	\N
10	3	1	1	2022-06-02 21:09:40.977165	\N
11	3	1	1	2022-06-02 21:09:40.977165	\N
12	3	1	1	2022-06-02 21:09:40.977165	\N
13	3	1	1	2022-06-02 21:09:40.977165	\N
18	3	1	1	2022-06-02 21:09:40.977165	\N
19	3	1	1	2022-06-02 21:09:40.977165	\N
20	3	1	1	2022-06-02 21:09:40.977165	\N
21	3	1	1	2022-06-02 21:09:40.977165	\N
24	3	1	1	2022-06-02 21:09:40.977165	\N
27	3	1	1	2022-06-02 21:09:40.977165	\N
28	3	1	1	2022-06-02 21:09:40.977165	\N
29	3	1	1	2022-06-02 21:09:40.977165	\N
30	3	1	1	2022-06-02 21:09:40.977165	\N
31	3	1	1	2022-06-02 21:09:40.977165	\N
33	3	1	1	2022-06-02 21:09:40.977165	\N
34	3	1	1	2022-06-02 21:09:40.977165	\N
2	3	1	1	2022-06-02 21:09:40.977165	\N
3	3	1	1	2022-06-02 21:09:40.977165	\N
4	3	1	1	2022-06-02 21:09:40.977165	\N
5	3	1	1	2022-06-02 21:09:40.977165	\N
52	2	0	1	2022-06-02 21:09:40.977165	\N
55	2	0	1	2022-06-02 21:09:40.977165	\N
55	1	0	1	2022-06-02 21:09:40.977165	\N
56	1	0	1	2022-06-02 21:09:40.977165	\N
56	2	0	1	2022-06-02 21:09:40.977165	\N
57	2	0	1	2022-06-02 21:09:40.977165	\N
57	1	0	1	2022-06-02 21:09:40.977165	\N
58	2	2	1	2022-06-02 21:09:40.977165	\N
58	1	2	1	2022-06-02 21:09:40.977165	\N
65	1	0	1	2022-06-02 21:09:40.977165	\N
65	2	0	1	2022-06-02 21:09:40.977165	\N
66	2	0	1	2022-06-02 21:09:40.977165	\N
66	1	0	1	2022-06-02 21:09:40.977165	\N
67	2	0	1	2022-06-02 21:09:40.977165	\N
68	2	0	1	2022-06-02 21:09:40.977165	\N
68	1	0	1	2022-06-02 21:09:40.977165	\N
64	2	0	1	2022-06-02 21:09:40.977165	\N
64	1	0	1	2022-06-02 21:09:40.977165	\N
32	3	1	1	2022-06-02 21:09:40.977165	\N
6	3	1	1	2022-06-02 21:09:40.977165	\N
22	3	1	1	2022-06-02 21:09:40.977165	\N
7	3	1	1	2022-06-02 21:09:40.977165	\N
14	3	1	1	2022-06-02 21:09:40.977165	\N
15	3	1	1	2022-06-02 21:09:40.977165	\N
16	3	1	1	2022-06-02 21:09:40.977165	\N
23	3	1	1	2022-06-02 21:09:40.977165	\N
35	3	1	1	2022-06-02 21:09:40.977165	\N
36	3	1	1	2022-06-02 21:09:40.977165	\N
37	3	1	1	2022-06-02 21:09:40.977165	\N
25	3	1	1	2022-06-02 21:09:40.977165	\N
26	3	1	1	2022-06-02 21:09:40.977165	\N
17	3	1	1	2022-06-02 21:09:40.977165	\N
39	3	1	1	2022-06-02 21:09:40.977165	\N
40	3	1	1	2022-06-02 21:09:40.977165	\N
41	3	1	1	2022-06-02 21:09:40.977165	\N
42	3	1	1	2022-06-02 21:09:40.977165	\N
43	3	1	1	2022-06-02 21:09:40.977165	\N
44	3	1	1	2022-06-02 21:09:40.977165	\N
45	3	1	1	2022-06-02 21:09:40.977165	\N
46	3	1	1	2022-06-02 21:09:40.977165	\N
47	3	1	1	2022-06-02 21:09:40.977165	\N
48	3	1	1	2022-06-02 21:09:40.977165	\N
49	3	1	1	2022-06-02 21:09:40.977165	\N
50	3	1	1	2022-06-02 21:09:40.977165	\N
51	3	1	1	2022-06-02 21:09:40.977165	\N
53	3	1	1	2022-06-02 21:09:40.977165	\N
54	3	1	1	2022-06-02 21:09:40.977165	\N
59	3	1	1	2022-06-02 21:09:40.977165	\N
60	3	1	1	2022-06-02 21:09:40.977165	\N
61	3	1	1	2022-06-02 21:09:40.977165	\N
62	3	1	1	2022-06-02 21:09:40.977165	\N
63	3	1	1	2022-06-02 21:09:40.977165	\N
51	1	1	1	2022-06-02 21:09:40.977165	\N
52	1	0	1	2022-06-02 21:09:40.977165	\N
52	3	0	1	2022-06-02 21:09:40.977165	\N
55	3	0	1	2022-06-02 21:09:40.977165	\N
56	3	0	1	2022-06-02 21:09:40.977165	\N
57	3	0	1	2022-06-02 21:09:40.977165	\N
58	3	2	1	2022-06-02 21:09:40.977165	\N
65	3	0	1	2022-06-02 21:09:40.977165	\N
66	3	0	1	2022-06-02 21:09:40.977165	\N
67	1	0	1	2022-06-02 21:09:40.977165	\N
67	3	0	1	2022-06-02 21:09:40.977165	\N
68	3	0	1	2022-06-02 21:09:40.977165	\N
64	3	0	1	2022-06-02 21:09:40.977165	\N
\.


--
-- TOC entry 3600 (class 0 OID 18115)
-- Dependencies: 241
-- Data for Name: product_price; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
1	150000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
2	20000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
3	250000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
3	250000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
4	175000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
4	175000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
5	175000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
5	175000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
6	40000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
7	150000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
7	150000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
8	150000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
8	150000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
9	60000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
9	60000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
10	60000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
10	60000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
11	25000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
11	25000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
12	65000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
12	65000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
13	40000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
13	40000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
14	35000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
14	35000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
15	60000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
16	60000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
16	60000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
17	50000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
17	50000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
18	50000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
18	50000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
19	175000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
19	175000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
20	100000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
20	100000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
21	150000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
21	150000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
22	125000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
22	125000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
23	100000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
23	100000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
24	100000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
24	100000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
25	25000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
26	250000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
26	250000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
27	50000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
27	50000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
28	60000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
28	60000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
29	500000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
29	500000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
30	25000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
30	25000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
31	200000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
31	200000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
32	50000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
32	50000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
33	50000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
33	50000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
34	40000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
35	5000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
35	5000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
36	5000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
36	5000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
37	5000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
37	5000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
39	160000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
39	160000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
40	160000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
40	160000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
41	160000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
41	160000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
42	135000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
43	135000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
44	135000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
45	135000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
46	135000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
47	110000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
49	160000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
50	110000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
51	80000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
52	70000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
53	300000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
54	160000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
55	100000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
56	100000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
57	65000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
58	325000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
59	185000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
60	100000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
61	80000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
62	75000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
63	70000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
65	70000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
64	75000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
67	70000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
66	70000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
1	150000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
1	150000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
2	20000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
3	250000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
4	175000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
5	175000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
6	40000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
6	40000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
7	150000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
8	150000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
9	60000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
10	60000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
11	25000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
12	65000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
13	40000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
14	35000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
15	60000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
15	60000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
16	60000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
17	50000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
18	50000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
19	175000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
20	100000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
21	150000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
22	125000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
23	100000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
24	100000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
25	25000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
25	25000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
26	250000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
27	50000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
28	60000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
29	500000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
30	25000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
31	200000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
32	50000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
33	50000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
34	40000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
34	40000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
35	5000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
36	5000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
37	5000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
39	160000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
40	160000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
41	160000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
42	135000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
42	135000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
43	135000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
43	135000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
44	135000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
44	135000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
45	135000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
45	135000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
46	135000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
46	135000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
47	110000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
47	110000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
48	110000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
48	110000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
48	110000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
49	160000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
49	160000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
50	110000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
50	110000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
51	80000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
51	80000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
52	70000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
52	70000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
53	300000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
53	300000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
54	160000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
54	160000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
55	100000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
55	100000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
56	100000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
56	100000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
57	65000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
57	65000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
58	325000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
58	325000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
59	185000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
59	185000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
60	100000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
60	100000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
61	80000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
62	75000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
62	75000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
63	70000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
63	70000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
61	80000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
64	75000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
65	70000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
65	70000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
66	70000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
64	75000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
68	50000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
68	50000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
68	50000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
69	60000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
67	70000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
66	70000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
69	60000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
69	60000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
70	60000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
70	60000	2	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
70	60000	1	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
67	70000	3	1	2022-06-02 21:08:26.621553	1	2022-06-02 21:08:26.621553
76	1000	1	\N	2022-07-20 15:24:29	1	2022-07-20 15:24:29
83	10000	1	\N	2022-10-09 03:13:14	1	2022-10-09 03:13:14
83	10000	2	\N	2022-10-09 03:13:24	1	2022-10-09 03:13:24
83	10000	3	\N	2022-10-09 03:13:34	1	2022-10-09 03:13:34
84	20000	1	\N	2022-10-09 03:13:46	1	2022-10-09 03:13:46
84	20000	2	\N	2022-10-09 03:13:57	1	2022-10-09 03:13:57
84	20000	3	\N	2022-10-09 03:14:06	1	2022-10-09 03:14:06
86	20000	1	\N	2022-10-09 03:14:29	1	2022-10-09 03:14:29
86	20000	2	\N	2022-10-09 03:14:39	1	2022-10-09 03:14:39
86	20000	3	\N	2022-10-09 03:14:48	1	2022-10-09 03:14:48
85	10000	1	\N	2022-10-09 03:15:02	1	2022-10-09 03:15:02
85	10000	2	\N	2022-10-09 03:15:14	1	2022-10-09 03:15:14
85	10000	3	\N	2022-10-09 03:15:24	1	2022-10-09 03:15:24
89	10000	1	\N	2022-10-15 20:38:38	1	2022-10-15 20:38:38
89	1000	2	\N	2022-10-15 20:38:50	1	2022-10-15 20:38:50
89	10000	3	\N	2022-10-15 20:39:01	1	2022-10-15 20:39:01
\.


--
-- TOC entry 3594 (class 0 OID 18065)
-- Dependencies: 235
-- Data for Name: product_sku; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo) FROM stdin;
65	Mandi Susu	SRVC ADN MND SSU	\N	\N	4	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
66	Body Cop Package	SRVC ADN BDY CP	\N	\N	4	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
67	Masker Badan	SRVC ADN MSK BDN	\N	\N	4	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
68	Steam Badan	SRVC STRM BDN	\N	\N	4	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
70	CELANA KAIN JUMBO	G CLN JMB	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
69	Extra Time	SRVC ADN EXT TME	\N	\N	4	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
83	Extra Charge Midnight 21:00	EXT-M21	\N	\N	15	8	9	2022-10-09 03:11:13	\N	2022-10-09 03:11:13	1	0	1	goods.png
86	Extra Charge Gender	EXT-GD	\N	\N	15	8	9	2022-10-09 03:12:42	\N	2022-10-09 03:12:42	1	0	1	goods.png
1	ACL - ANTISEPTIK GEL	ACL AG	\N	\N	8	1	2	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
8	ACL - MILK BATH	ACL MB	\N	\N	8	1	2	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
9	ACL - PENYEGAR WAJAH 	ACL PYGR WJ	\N	\N	8	1	2	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
84	Extra Charge Midnight 22:00	EXT-M22	\N	\N	15	8	9	2022-10-09 03:11:41	\N	2022-10-09 03:11:41	1	0	1	goods.png
85	Extra Charge Room	EXT-RM	\N	\N	15	8	9	2022-10-09 03:12:11	\N	2022-10-09 03:12:11	1	0	1	goods.png
89	Test Kotak	KTK	\N	\N	8	1	9	2022-10-15 20:37:29	\N	2022-10-15 20:37:29	1	0	1	goods.png
10	BALI ALUS - BODY WITHENING	BA BW	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
11	BALI ALUS - DUDUS CELUP 	BA DC	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
12	BALI ALUS - LIGHTENING	BA LGHTN	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
13	BALI ALUS - LULUR GREENTEA	BA LLR GRNT	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
18	BALI ALUS - SWETY SLIMM	BA SWTY SLM	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
19	NELAYAN NUSANTARA BATHSALT VCO RELAX	NN BTHSLT VCO	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
20	GREEN SPA LULUR BALI ALUS	GS LLR BA	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
21	BIOKOS - CLEANSER	BK CLNSR	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
24	BIOKOS - PEELING	BK  PLNG	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
27	CELANA KAIN STANDAR	G CLN STD	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
28	HERBAL COMPRESS	G HRBL COMPS	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
29	KOP BADAN BESAR	G KOP BDN L	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
30	LILIN EC	G LLN EC	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
31	TATAKAN WAJAH JELLY	G WJH JLLY	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
33	KAYU REFLEKSI SEGITIGA	G KYU RFL S3	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
34	KAYU REFLEKSI BINTANG	G KYU RFL STR	\N	\N	8	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
2	ACL - CREAM HANGAT BUNGKUS	ACL CH B	\N	\N	9	1	2	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
3	ACL - CREAM HANGAT BOTOL	ACL CH BT	\N	\N	9	1	2	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
4	ACL - FOOT SPRAY	ACL FS	\N	\N	10	1	2	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
5	ACL - LINEN SPRAY	ACL LS	\N	\N	10	1	2	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
32	PEELING SPRAY	G PLLG SPRY	\N	\N	10	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
6	ACL - MASSAGE CREAM BUNGAN JEPUN	ACL MSG CRM BJ	\N	\N	9	1	2	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
22	BIOKOS - CREAM MASSAGE 	BK CRM MSSG	\N	\N	9	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
7	ACL - MASKER BADAN	ACL MSK BD	\N	\N	13	1	2	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
14	BALI ALUS - MASKER ARMPIT	BA MSK ARMP	\N	\N	13	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
15	BALI ALUS - MASKER PAYUDARA B	BA MSK PYDR B	\N	\N	13	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
16	BALI ALUS - MASKER PAYUDARA K	BA MSK PYDR K	\N	\N	13	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
23	BIOKOS - GELK MASK	BK GLK MSK	\N	\N	13	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
35	THE BANDULAN 	BDLN	\N	\N	12	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
36	GOLDA	GLDA	\N	\N	12	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
37	GREAT	G GRT	\N	\N	12	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
25	IANTHE SERUM VITAMIN C 5 ML	IT SRM VIT C 5ML	\N	\N	7	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
26	IANTHE SERUM VITAMIN C 100 ML	IT SRM VIT C 100ML	\N	\N	7	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
17	BALI ALUS - SABUN SIRIH	BA SBN SRH	\N	\N	11	1	3	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
39	Mixing Thai	SRVC B MT	\N	\N	1	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
40	Body Herbal Compress 	SRVC B BHC	\N	\N	1	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
41	Shiatsu	SRVC B SHSU	\N	\N	1	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
42	Dry Massage	SRVC B DRY MSG	\N	\N	1	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
43	Tuina	SRVC B TNA	\N	\N	1	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
44	Hot Stone	SRVC B HOT STN	\N	\N	1	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
45	Full Body Reflexology	SRVC B FULL BD RF	\N	\N	1	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
46	Full Body Therapy	SRVC B FULL BD TR	\N	\N	1	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
47	Back Massage / Dry	SRVC B BCK MSG	\N	\N	1	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
48	Body Cop With Massage	SRVC B BCOP MSG	\N	\N	1	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
49	Facial Biokos and Accu Aura With Vitamin	SRVC F BKOS AUR	\N	\N	2	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
50	Face Refreshing Biokos	SRVC F BKOS RFHS	\N	\N	2	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
51	Ear Candling	SRVC F EAR CDL	\N	\N	2	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
52	Accu Aura	SRVC F ACC AURA	\N	\N	2	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
53	V- Spa	SRVC FL VSPA	\N	\N	3	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
54	Breast and Slimming Therapy	SRVC FL BRST SLMM TRP	\N	\N	3	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
55	Slimming	SRVC FL SLMM	\N	\N	3	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
56	Breast	SRVC FL BRST	\N	\N	3	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
57	Ratus With Hand Massage	SRVC FL RTS HND MSG	\N	\N	3	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
58	Executive Bali Body Scrub	SRVC SC BDY SCRB	\N	\N	3	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
59	Body Bleacing Package	SRVC SC BDY  BLCH	\N	\N	4	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
60	Bali Alus Body Scrub	SRVC BA BDY SCRB	\N	\N	4	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
61	Lulur Aromatherapy	SRVC BA LLR ARMTRY	\N	\N	4	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
62	Foot Reflexology	SRVC FT REFKS	\N	\N	4	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
63	Foot Express	SRVC FT REFKS EPRS	\N	\N	4	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
64	Herbal Compress	SRVC ADN HRBL CMPS	\N	\N	4	2	1	\N	\N	2022-06-01 21:06:02.021847	1	11	1	goods.png
\.


--
-- TOC entry 3614 (class 0 OID 18253)
-- Dependencies: 255
-- Data for Name: product_stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
53	2	9999	\N	2022-07-25 18:26:06.816842	1
55	2	9999	\N	2022-07-25 18:26:06.816842	1
1	1	9999	\N	2022-07-25 18:26:06.816842	1
8	1	9999	\N	2022-07-25 18:26:06.816842	1
9	1	9999	\N	2022-07-25 18:26:06.816842	1
11	1	9999	\N	2022-07-25 18:26:06.816842	1
12	1	9999	\N	2022-07-25 18:26:06.816842	1
13	1	9999	\N	2022-07-25 18:26:06.816842	1
18	1	9999	\N	2022-07-25 18:26:06.816842	1
19	1	9999	\N	2022-07-25 18:26:06.816842	1
20	1	9999	\N	2022-07-25 18:26:06.816842	1
21	1	9999	\N	2022-07-25 18:26:06.816842	1
24	1	9999	\N	2022-07-25 18:26:06.816842	1
28	1	9999	\N	2022-07-25 18:26:06.816842	1
29	1	9999	\N	2022-07-25 18:26:06.816842	1
30	1	9999	\N	2022-07-25 18:26:06.816842	1
31	1	9999	\N	2022-07-25 18:26:06.816842	1
33	1	9999	\N	2022-07-25 18:26:06.816842	1
34	1	9999	\N	2022-07-25 18:26:06.816842	1
2	1	9999	\N	2022-07-25 18:26:06.816842	1
3	1	9999	\N	2022-07-25 18:26:06.816842	1
4	1	9999	\N	2022-07-25 18:26:06.816842	1
5	1	9999	\N	2022-07-25 18:26:06.816842	1
32	1	9999	\N	2022-07-25 18:26:06.816842	1
6	1	9999	\N	2022-07-25 18:26:06.816842	1
22	1	9999	\N	2022-07-25 18:26:06.816842	1
7	1	9999	\N	2022-07-25 18:26:06.816842	1
14	1	9999	\N	2022-07-25 18:26:06.816842	1
15	1	9999	\N	2022-07-25 18:26:06.816842	1
16	1	9999	\N	2022-07-25 18:26:06.816842	1
23	1	9999	\N	2022-07-25 18:26:06.816842	1
35	1	9999	\N	2022-07-25 18:26:06.816842	1
36	1	9999	\N	2022-07-25 18:26:06.816842	1
37	1	9999	\N	2022-07-25 18:26:06.816842	1
25	1	9999	\N	2022-07-25 18:26:06.816842	1
26	1	9999	\N	2022-07-25 18:26:06.816842	1
17	1	9999	\N	2022-07-25 18:26:06.816842	1
39	1	9999	\N	2022-07-25 18:26:06.816842	1
41	1	9999	\N	2022-07-25 18:26:06.816842	1
42	1	9999	\N	2022-07-25 18:26:06.816842	1
43	1	9999	\N	2022-07-25 18:26:06.816842	1
44	1	9999	\N	2022-07-25 18:26:06.816842	1
45	1	9999	\N	2022-07-25 18:26:06.816842	1
46	1	9999	\N	2022-07-25 18:26:06.816842	1
47	1	9999	\N	2022-07-25 18:26:06.816842	1
48	1	9999	\N	2022-07-25 18:26:06.816842	1
49	1	9999	\N	2022-07-25 18:26:06.816842	1
50	1	9999	\N	2022-07-25 18:26:06.816842	1
51	1	9999	\N	2022-07-25 18:26:06.816842	1
52	1	9999	\N	2022-07-25 18:26:06.816842	1
53	1	9999	\N	2022-07-25 18:26:06.816842	1
54	1	9999	\N	2022-07-25 18:26:06.816842	1
55	1	9999	\N	2022-07-25 18:26:06.816842	1
56	1	9999	\N	2022-07-25 18:26:06.816842	1
57	1	9999	\N	2022-07-25 18:26:06.816842	1
58	1	9999	\N	2022-07-25 18:26:06.816842	1
60	1	9999	\N	2022-07-25 18:26:06.816842	1
61	1	9999	\N	2022-07-25 18:26:06.816842	1
62	1	9999	\N	2022-07-25 18:26:06.816842	1
63	1	9999	\N	2022-07-25 18:26:06.816842	1
64	1	9999	\N	2022-07-25 18:26:06.816842	1
65	1	9999	\N	2022-07-25 18:26:06.816842	1
66	1	9999	\N	2022-07-25 18:26:06.816842	1
67	1	9999	\N	2022-07-25 18:26:06.816842	1
68	1	9999	\N	2022-07-25 18:26:06.816842	1
70	1	9999	\N	2022-07-25 18:26:06.816842	1
69	1	9999	\N	2022-07-25 18:26:06.816842	1
76	1	9999	\N	2022-07-25 18:26:06.816842	1
9	2	9999	\N	2022-07-25 18:26:06.816842	1
10	2	9999	\N	2022-07-25 18:26:06.816842	1
12	2	9999	\N	2022-07-25 18:26:06.816842	1
13	2	9999	\N	2022-07-25 18:26:06.816842	1
18	2	9999	\N	2022-07-25 18:26:06.816842	1
19	2	9999	\N	2022-07-25 18:26:06.816842	1
20	2	9999	\N	2022-07-25 18:26:06.816842	1
21	2	9999	\N	2022-07-25 18:26:06.816842	1
24	2	9999	\N	2022-07-25 18:26:06.816842	1
27	2	9999	\N	2022-07-25 18:26:06.816842	1
28	2	9999	\N	2022-07-25 18:26:06.816842	1
29	2	9999	\N	2022-07-25 18:26:06.816842	1
30	2	9999	\N	2022-07-25 18:26:06.816842	1
31	2	9999	\N	2022-07-25 18:26:06.816842	1
33	2	9999	\N	2022-07-25 18:26:06.816842	1
32	2	9999	\N	2022-07-25 18:26:06.816842	1
22	2	9999	\N	2022-07-25 18:26:06.816842	1
14	2	9999	\N	2022-07-25 18:26:06.816842	1
15	2	9999	\N	2022-07-25 18:26:06.816842	1
16	2	9999	\N	2022-07-25 18:26:06.816842	1
36	2	9999	\N	2022-07-25 18:26:06.816842	1
37	2	9999	\N	2022-07-25 18:26:06.816842	1
25	2	9999	\N	2022-07-25 18:26:06.816842	1
26	2	9999	\N	2022-07-25 18:26:06.816842	1
17	2	9999	\N	2022-07-25 18:26:06.816842	1
39	2	9999	\N	2022-07-25 18:26:06.816842	1
41	2	9999	\N	2022-07-25 18:26:06.816842	1
42	2	9999	\N	2022-07-25 18:26:06.816842	1
62	2	9999	\N	2022-07-25 18:26:06.816842	1
4	2	9996	\N	2022-07-25 18:26:06.816842	1
27	1	10108	2022-08-20 17:04:38.386827	2022-07-25 18:26:06.816842	1
8	2	9996	\N	2022-07-25 18:26:06.816842	1
47	2	9988	\N	2022-07-25 18:26:06.816842	1
56	2	9998	\N	2022-07-25 18:26:06.816842	1
54	2	9998	\N	2022-07-25 18:26:06.816842	1
61	2	9996	\N	2022-07-25 18:26:06.816842	1
6	2	9993	\N	2022-07-25 18:26:06.816842	1
60	2	9998	\N	2022-07-25 18:26:06.816842	1
34	2	9996	\N	2022-07-25 18:26:06.816842	1
3	2	9995	\N	2022-07-25 18:26:06.816842	1
64	2	9998	\N	2022-07-25 18:26:06.816842	1
2	2	9996	\N	2022-07-25 18:26:06.816842	1
65	2	9998	\N	2022-07-25 18:26:06.816842	1
57	2	9998	\N	2022-07-25 18:26:06.816842	1
51	2	9996	\N	2022-07-25 18:26:06.816842	1
50	2	9997	\N	2022-07-25 18:26:06.816842	1
48	2	9983	\N	2022-07-25 18:26:06.816842	1
66	2	9995	\N	2022-07-25 18:26:06.816842	1
63	2	9998	\N	2022-07-25 18:26:06.816842	1
59	2	10002	2022-09-17 10:24:26.045019	2022-07-25 18:26:06.816842	1
40	2	10006	2022-09-17 10:24:26.041486	2022-07-25 18:26:06.816842	1
58	2	10000	2022-09-17 10:24:26.047956	2022-07-25 18:26:06.816842	1
40	1	10000	2022-09-17 08:40:20.881436	2022-07-25 18:26:06.816842	1
43	2	9996	\N	2022-07-25 18:26:06.816842	1
5	2	9996	\N	2022-07-25 18:26:06.816842	1
45	2	9997	\N	2022-07-25 18:26:06.816842	1
44	2	9997	\N	2022-07-25 18:26:06.816842	1
11	2	9998	\N	2022-07-25 18:26:06.816842	1
23	2	9998	\N	2022-07-25 18:26:06.816842	1
35	2	9998	\N	2022-07-25 18:26:06.816842	1
10	1	10000	2022-10-23 05:17:47.563971	2022-07-25 18:26:06.816842	1
46	2	9990	\N	2022-07-25 18:26:06.816842	1
7	2	9997	\N	2022-07-25 18:26:06.816842	1
67	2	9999	\N	2022-07-25 18:26:06.816842	1
68	2	9999	\N	2022-07-25 18:26:06.816842	1
70	2	9999	\N	2022-07-25 18:26:06.816842	1
69	2	9999	\N	2022-07-25 18:26:06.816842	1
76	2	9999	\N	2022-07-25 18:26:06.816842	1
1	3	9999	\N	2022-07-25 18:26:06.816842	1
8	3	9999	\N	2022-07-25 18:26:06.816842	1
9	3	9999	\N	2022-07-25 18:26:06.816842	1
11	3	9999	\N	2022-07-25 18:26:06.816842	1
18	3	9999	\N	2022-07-25 18:26:06.816842	1
19	3	9999	\N	2022-07-25 18:26:06.816842	1
21	3	9999	\N	2022-07-25 18:26:06.816842	1
28	3	9999	\N	2022-07-25 18:26:06.816842	1
29	3	9999	\N	2022-07-25 18:26:06.816842	1
30	3	9999	\N	2022-07-25 18:26:06.816842	1
31	3	9999	\N	2022-07-25 18:26:06.816842	1
33	3	9999	\N	2022-07-25 18:26:06.816842	1
34	3	9999	\N	2022-07-25 18:26:06.816842	1
5	3	9999	\N	2022-07-25 18:26:06.816842	1
32	3	9999	\N	2022-07-25 18:26:06.816842	1
6	3	9999	\N	2022-07-25 18:26:06.816842	1
22	3	9999	\N	2022-07-25 18:26:06.816842	1
7	3	9999	\N	2022-07-25 18:26:06.816842	1
14	3	9999	\N	2022-07-25 18:26:06.816842	1
15	3	9999	\N	2022-07-25 18:26:06.816842	1
16	3	9999	\N	2022-07-25 18:26:06.816842	1
23	3	9999	\N	2022-07-25 18:26:06.816842	1
35	3	9999	\N	2022-07-25 18:26:06.816842	1
36	3	9999	\N	2022-07-25 18:26:06.816842	1
37	3	9999	\N	2022-07-25 18:26:06.816842	1
25	3	9999	\N	2022-07-25 18:26:06.816842	1
26	3	9999	\N	2022-07-25 18:26:06.816842	1
17	3	9999	\N	2022-07-25 18:26:06.816842	1
39	3	9999	\N	2022-07-25 18:26:06.816842	1
40	3	9999	\N	2022-07-25 18:26:06.816842	1
41	3	9999	\N	2022-07-25 18:26:06.816842	1
42	3	9999	\N	2022-07-25 18:26:06.816842	1
43	3	9999	\N	2022-07-25 18:26:06.816842	1
49	3	9999	\N	2022-07-25 18:26:06.816842	1
50	3	9999	\N	2022-07-25 18:26:06.816842	1
51	3	9999	\N	2022-07-25 18:26:06.816842	1
53	3	9999	\N	2022-07-25 18:26:06.816842	1
54	3	9999	\N	2022-07-25 18:26:06.816842	1
55	3	9999	\N	2022-07-25 18:26:06.816842	1
56	3	9999	\N	2022-07-25 18:26:06.816842	1
57	3	9999	\N	2022-07-25 18:26:06.816842	1
58	3	9999	\N	2022-07-25 18:26:06.816842	1
59	3	9999	\N	2022-07-25 18:26:06.816842	1
60	3	9999	\N	2022-07-25 18:26:06.816842	1
62	3	9999	\N	2022-07-25 18:26:06.816842	1
63	3	9999	\N	2022-07-25 18:26:06.816842	1
64	3	9999	\N	2022-07-25 18:26:06.816842	1
65	3	9999	\N	2022-07-25 18:26:06.816842	1
66	3	9999	\N	2022-07-25 18:26:06.816842	1
67	3	9999	\N	2022-07-25 18:26:06.816842	1
68	3	9999	\N	2022-07-25 18:26:06.816842	1
70	3	9999	\N	2022-07-25 18:26:06.816842	1
69	3	9999	\N	2022-07-25 18:26:06.816842	1
76	3	9999	\N	2022-07-25 18:26:06.816842	1
3	3	9996	\N	2022-07-25 18:26:06.816842	1
10	3	9996	\N	2022-07-25 18:26:06.816842	1
12	3	9997	\N	2022-07-25 18:26:06.816842	1
20	3	9995	\N	2022-07-25 18:26:06.816842	1
61	3	9998	\N	2022-07-25 18:26:06.816842	1
49	2	9996	\N	2022-07-25 18:26:06.816842	1
52	2	9999	2022-08-20 01:41:24	2022-07-25 18:26:06.816842	1
52	3	10114	\N	2022-07-25 18:26:06.816842	1
4	3	10000	2022-08-20 15:13:26.026441	2022-07-25 18:26:06.816842	1
13	3	10004	2022-08-20 15:13:26.028804	2022-07-25 18:26:06.816842	1
27	3	10000	2022-08-20 15:13:26.030577	2022-07-25 18:26:06.816842	1
24	3	10030	2022-08-20 16:47:12.514929	2022-07-25 18:26:06.816842	1
2	3	9997	2022-08-20 16:47:12.522531	2022-07-25 18:26:06.816842	1
59	1	10005	2022-09-17 08:40:20.886402	2022-07-25 18:26:06.816842	1
47	3	9997	\N	2022-07-25 18:26:06.816842	1
1	2	9994	\N	2022-07-25 18:26:06.816842	1
46	3	9998	\N	2022-07-25 18:26:06.816842	1
45	3	9998	\N	2022-07-25 18:26:06.816842	1
48	3	9989	\N	2022-07-25 18:26:06.816842	1
44	3	9991	\N	2022-07-25 18:26:06.816842	1
\.


--
-- TOC entry 3621 (class 0 OID 18492)
-- Dependencies: 262
-- Data for Name: product_stock_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
1	24	3	1	2024-08-20	\N	2022-08-20 16:47:12.517217	1
2	2	3	1	2024-08-20	\N	2022-08-20 16:47:12.524593	1
3	27	1	109	2024-08-20	\N	2022-08-20 17:04:38.389528	1
4	59	2	1	2024-09-17	\N	2022-09-17 05:09:51.417976	1
5	59	2	1	2024-09-17	\N	2022-09-17 05:11:24.298061	1
6	59	1	1	2024-09-17	\N	2022-09-17 05:57:02.361339	1
7	59	1	1	2024-09-17	\N	2022-09-17 05:59:18.113439	1
8	59	2	1	2024-09-17	\N	2022-09-17 06:00:24.352683	1
9	59	1	1	2024-09-17	\N	2022-09-17 06:05:50.611678	1
10	59	2	1	2024-09-17	\N	2022-09-17 06:07:29.884734	1
11	40	2	2	2024-09-17	\N	2022-09-17 06:07:29.889569	1
12	59	1	1	2024-09-17	\N	2022-09-17 06:08:55.307898	1
13	40	2	1	2024-09-17	\N	2022-09-17 06:11:14.696036	1
14	59	1	1	2024-09-17	\N	2022-09-17 06:12:48.258854	1
15	40	1	1	2024-09-17	\N	2022-09-17 08:40:20.882859	1
16	59	1	1	2024-09-17	\N	2022-09-17 08:40:20.888736	1
17	40	2	4	2024-09-17	\N	2022-09-17 10:24:26.042447	1
18	59	2	1	2024-09-17	\N	2022-09-17 10:24:26.045884	1
19	58	2	1	2024-09-17	\N	2022-09-17 10:24:26.048671	1
20	10	1	1	2024-10-23	\N	2022-10-23 05:17:47.566843	1
\.


--
-- TOC entry 3611 (class 0 OID 18208)
-- Dependencies: 252
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_type (id, remark, created_at, updated_at) FROM stdin;
3	Goods & Services	2022-06-01 21:02:38.43164	\N
2	Services	2022-06-01 21:02:38.43164	\N
1	Goods	2022-06-01 21:02:38.43164	\N
7	Misc	2022-07-25 14:53:50	2022-07-25 14:53:50
8	Extra	2022-10-09 03:05:18	2022-10-09 03:05:18
\.


--
-- TOC entry 3612 (class 0 OID 18216)
-- Dependencies: 253
-- Data for Name: product_uom; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
1	1	2022-06-03 17:38:00.278845	1	\N
9	1	2022-06-03 17:38:00.278845	1	\N
21	1	2022-06-03 17:38:00.278845	1	\N
24	1	2022-06-03 17:38:00.278845	1	\N
30	1	2022-06-03 17:38:00.278845	1	\N
3	1	2022-06-03 17:38:00.278845	1	\N
4	1	2022-06-03 17:38:00.278845	1	\N
5	1	2022-06-03 17:38:00.278845	1	\N
35	1	2022-06-03 17:38:00.278845	1	\N
36	1	2022-06-03 17:38:00.278845	1	\N
37	1	2022-06-03 17:38:00.278845	1	\N
26	1	2022-06-03 17:38:00.278845	1	\N
17	1	2022-06-03 17:38:00.278845	1	\N
2	2	2022-06-03 17:38:00.278845	1	\N
6	2	2022-06-03 17:38:00.278845	1	\N
7	2	2022-06-03 17:38:00.278845	1	\N
8	2	2022-06-03 17:38:00.278845	1	\N
19	2	2022-06-03 17:38:00.278845	1	\N
20	2	2022-06-03 17:38:00.278845	1	\N
10	3	2022-06-03 17:38:00.278845	1	\N
12	3	2022-06-03 17:38:00.278845	1	\N
18	3	2022-06-03 17:38:00.278845	1	\N
22	3	2022-06-03 17:38:00.278845	1	\N
23	3	2022-06-03 17:38:00.278845	1	\N
11	5	2022-06-03 17:38:00.278845	1	\N
14	5	2022-06-03 17:38:00.278845	1	\N
13	4	2022-06-03 17:38:00.278845	1	\N
28	4	2022-06-03 17:38:00.278845	1	\N
31	4	2022-06-03 17:38:00.278845	1	\N
32	4	2022-06-03 17:38:00.278845	1	\N
33	4	2022-06-03 17:38:00.278845	1	\N
34	4	2022-06-03 17:38:00.278845	1	\N
15	6	2022-06-03 17:38:00.278845	1	\N
16	6	2022-06-03 17:38:00.278845	1	\N
29	6	2022-06-03 17:38:00.278845	1	\N
25	7	2022-06-03 17:38:00.278845	1	\N
27	8	2022-06-03 17:38:00.278845	1	\N
70	8	2022-06-03 17:38:00.278845	1	\N
39	9	2022-06-03 17:38:00.278845	1	\N
40	12	2022-06-03 17:38:00.278845	1	\N
41	9	2022-06-03 17:38:00.278845	1	\N
42	9	2022-06-03 17:38:00.278845	1	\N
43	9	2022-06-03 17:38:00.278845	1	\N
44	9	2022-06-03 17:38:00.278845	1	\N
45	9	2022-06-03 17:38:00.278845	1	\N
46	9	2022-06-03 17:38:00.278845	1	\N
47	19	2022-06-03 17:38:00.278845	1	\N
48	19	2022-06-03 17:38:00.278845	1	\N
49	9	2022-06-03 17:38:00.278845	1	\N
50	19	2022-06-03 17:38:00.278845	1	\N
51	11	2022-06-03 17:38:00.278845	1	\N
52	10	2022-06-03 17:38:00.278845	1	\N
53	9	2022-06-03 17:38:00.278845	1	\N
54	19	2022-06-03 17:38:00.278845	1	\N
55	10	2022-06-03 17:38:00.278845	1	\N
56	10	2022-06-03 17:38:00.278845	1	\N
57	16	2022-06-03 17:38:00.278845	1	\N
58	20	2022-06-03 17:38:00.278845	1	\N
59	21	2022-06-03 17:38:00.278845	1	\N
60	19	2022-06-03 17:38:00.278845	1	\N
61	12	2022-06-03 17:38:00.278845	1	\N
62	19	2022-06-03 17:38:00.278845	1	\N
63	11	2022-06-03 17:38:00.278845	1	\N
64	10	2022-06-03 17:38:00.278845	1	\N
65	16	2022-06-03 17:38:00.278845	1	\N
66	16	2022-06-03 17:38:00.278845	1	\N
67	10	2022-06-03 17:38:00.278845	1	\N
68	16	2022-06-03 17:38:00.278845	1	\N
69	10	2022-06-03 17:38:00.278845	1	\N
83	8	2022-06-03 17:38:00.278845	1	\N
84	8	2022-06-03 17:38:00.278845	1	\N
85	8	2022-06-03 17:38:00.278845	1	\N
86	8	2022-06-03 17:38:00.278845	1	\N
89	1	2022-10-15 20:37:29	\N	2022-10-15 20:37:29
\.


--
-- TOC entry 3627 (class 0 OID 18669)
-- Dependencies: 268
-- Data for Name: purchase_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
PO-001-2022-00000001	59	Body Bleacing Package	100 Menit	0	1	185000	0	11.00	20350.00	185000	205350.00	2022-09-16 07:00:40	2022-09-16 07:00:40
PO-001-2022-00000001	61	Lulur Aromatherapy	120 Menit	1	1	80000	0	11.00	8800.00	80000	88800.00	2022-09-16 07:00:40	2022-09-16 07:00:40
PO-001-2022-00000001	58	Executive Bali Body Scrub	150 Menit	2	1	325000	3000	11.00	35420.00	322000	357420.00	2022-09-16 07:00:40	2022-09-16 07:00:40
PO-001-2022-00000012	59	Body Bleacing Package	100 Menit	0	1	185000	1000	11.00	20240.00	184000	204240.00	2022-09-17 00:06:28	2022-09-17 00:06:28
PO-001-2022-00000012	40	Body Herbal Compress	120 Menit	1	1	160000	2000	11.00	17380.00	158000	175380.00	2022-09-17 00:06:28	2022-09-17 00:06:28
PO-001-2022-00000013	59	Body Bleacing Package	100 Menit	0	1	185000	0	11.00	20350.00	185000	205350.00	2022-10-22 15:53:51	2022-10-22 15:53:51
\.


--
-- TOC entry 3626 (class 0 OID 18620)
-- Dependencies: 267
-- Data for Name: purchase_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
11	PO-001-2022-00000001	2022-09-16	2	Test Supplier 02	1	HEAD QUARTER	651570	64570	0	3000	\N	\N	0	2022-09-16 14:00:40.80491	\N	\N	\N	2022-09-16 07:00:40	1	2022-09-16 07:00:40	0	0
12	PO-001-2022-00000012	2022-09-16	2	2 - Test Supplier 02	1	HEAD QUARTER	379620	37620	0	3000	ABC	\N	0	2022-09-17 06:13:16.979111	\N	\N	1	2022-09-17 00:06:28	1	2022-09-16 23:13:16	0	0
15	PO-001-2022-00000013	2022-10-22	2	Test Supplier 02	1	HEAD QUARTER	205350	20350	0	0	\N	\N	0	2022-10-22 15:53:51.479455	\N	\N	\N	2022-10-22 15:53:51	1	2022-10-22 15:53:51	0	0
\.


--
-- TOC entry 3637 (class 0 OID 18814)
-- Dependencies: 278
-- Data for Name: receive_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
RC-001-2022-00000001	59	Body Bleacing Package	1	185000	184000	1000	0	2023-09-17	A	2022-09-16 23:08:55	2022-09-16 23:08:55	100 Menit	11
RC-002-2022-00000011	40	Body Herbal Compress	1	160000	160000	0	0	2023-09-17	\N	2022-09-16 23:11:14	2022-09-16 23:11:14	120 Menit	11
RC-001-2022-00000012	10	BALI ALUS - BODY WITHENING	1	60000	60000	0	0	2023-10-23	\N	2022-10-23 05:17:47	2022-10-23 05:17:47	Tube	11
\.


--
-- TOC entry 3636 (class 0 OID 18788)
-- Dependencies: 277
-- Data for Name: receive_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
10	RC-001-2022-00000001	2022-09-16	1	1 - Test Supplier 010	204240	20240	0	1000	\N	\N	0	2022-09-17 06:08:55.300007	1	HEAD QUARTER	\N	\N	\N	2022-09-16 23:08:55	1	2022-09-16 23:08:55	0	0
11	RC-002-2022-00000011	2022-09-16	2	2 - Test Supplier 02	177600	17600	0	0	\N	\N	0	2022-09-17 06:11:14.689121	2	OUTLET 01	\N	\N	\N	2022-09-16 23:11:14	1	2022-09-16 23:11:14	0	0
15	RC-001-2022-00000012	2022-10-23	2	2 - Test Supplier 02	66600	6600	0	0	\N	\N	0	2022-10-23 05:17:47.551842	1	HEAD QUARTER	\N	\N	\N	2022-10-23 05:17:47	1	2022-10-23 05:17:47	0	0
\.


--
-- TOC entry 3576 (class 0 OID 17902)
-- Dependencies: 217
-- Data for Name: role_has_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
39	1
28	1
29	1
27	1
30	1
31	1
32	1
33	1
34	1
35	1
36	1
37	1
38	1
40	1
41	1
42	1
43	1
44	1
45	1
46	1
47	1
48	1
49	1
50	1
51	1
52	1
53	1
54	1
59	1
55	1
56	1
57	1
58	1
60	1
61	1
62	1
63	1
64	1
65	1
66	1
67	1
68	1
69	1
70	1
71	1
72	1
73	1
74	1
76	1
77	1
78	1
79	1
80	1
1	1
2	1
3	1
4	1
5	1
6	1
7	1
9	1
11	1
12	1
13	1
14	1
15	1
8	1
16	1
17	1
18	1
19	1
20	1
21	1
22	1
23	1
24	1
25	1
26	1
81	1
82	1
83	1
84	1
85	1
75	1
86	1
87	1
88	1
89	1
90	1
91	1
92	1
93	1
94	1
95	1
96	1
97	1
98	1
99	1
100	1
101	1
102	1
103	1
104	1
105	1
106	1
107	1
108	1
109	1
110	1
111	1
112	1
113	1
114	1
115	1
116	1
117	1
119	1
118	1
120	1
121	1
122	1
123	1
124	1
125	1
126	1
127	1
128	1
129	1
130	1
131	1
132	1
133	1
134	1
135	1
136	1
137	1
138	1
139	1
140	1
141	1
142	1
143	1
144	1
145	1
146	1
147	1
148	1
149	1
150	1
151	1
152	1
153	1
154	1
155	1
156	1
157	1
158	1
159	1
160	1
161	1
162	1
163	1
164	1
165	1
166	1
167	1
168	1
169	1
170	1
171	1
172	1
173	1
174	1
175	1
176	1
177	1
178	1
179	1
180	1
181	1
182	1
183	1
184	1
185	1
186	1
187	1
188	1
189	1
190	1
191	1
116	3
2	3
123	3
124	3
75	3
125	3
127	3
87	3
192	1
192	3
193	1
193	3
194	1
194	3
195	3
195	1
2	11
26	11
3	11
73	3
74	3
77	3
76	3
78	3
80	3
79	3
81	3
85	3
84	3
196	3
196	1
66	3
197	1
198	1
199	1
200	1
201	1
202	1
203	1
204	1
205	1
206	1
207	1
208	1
209	1
210	1
212	1
211	1
213	1
214	1
215	1
216	1
217	1
218	1
219	1
220	1
221	1
222	1
210	3
212	3
211	3
213	3
214	3
215	3
216	3
217	3
218	3
219	3
220	3
221	3
222	3
223	1
223	3
224	1
224	3
225	1
226	1
227	1
228	1
229	1
230	1
231	1
232	1
233	1
234	1
235	1
236	1
237	1
238	1
239	1
240	1
241	1
242	1
243	1
244	1
245	1
249	1
250	1
251	1
252	1
253	1
254	1
255	1
256	1
257	1
258	1
259	1
260	1
261	1
262	1
263	1
264	1
265	1
266	1
267	1
246	1
247	1
268	1
269	1
270	1
271	1
272	1
273	1
274	1
275	1
276	1
277	1
278	1
279	1
280	1
281	1
282	1
283	1
284	1
285	1
286	1
287	1
288	1
289	1
290	1
291	1
292	1
293	1
294	1
296	1
297	1
298	1
295	1
299	1
300	1
301	1
302	1
303	1
304	1
305	1
306	1
307	1
308	1
309	1
310	1
311	1
312	1
313	1
314	1
315	1
\.


--
-- TOC entry 3573 (class 0 OID 17869)
-- Dependencies: 214
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
1	admin	web	2022-05-28 12:40:11	2022-05-28 12:40:11
2	owner	web	2022-05-28 12:40:11	2022-05-28 12:40:11
3	cashier	web	2022-05-28 12:40:11	2022-05-28 12:40:11
5	terapist	web	2022-05-28 12:40:11	2022-05-28 12:40:11
4	admin_finance	web	2022-05-28 12:40:11	2022-05-28 12:40:11
6	hr	web	2022-05-28 12:40:11	2022-05-28 12:40:11
11	trainer	web	2022-08-06 23:01:46	2022-08-06 23:01:46
\.


--
-- TOC entry 3602 (class 0 OID 18128)
-- Dependencies: 243
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
2022-07-16	202207	Kakiku	Lapak ERP	v0.0.1	logo_kakiku.png
\.


--
-- TOC entry 3632 (class 0 OID 18722)
-- Dependencies: 273
-- Data for Name: shift; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
2	Shift II Sore	15:00:00	21:00:00	\N	\N	2022-09-09 10:14:57.221863
1	Shift I Pagi	08:00:00	15:00:00	\N	\N	2022-09-09 10:14:57.221863
\.


--
-- TOC entry 3619 (class 0 OID 18334)
-- Dependencies: 260
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
2	Test Supplier 02	Jalan Mawar Mandiri No 01	2	test@gmail.com	085746879090	\N	\N	2022-09-04 11:31:10.765461
1	Test Supplier 010	Jalan Pangeran Parit 210	1	testa@gmail.com	0857468790909	2022-09-04 12:57:56	\N	2022-09-04 11:31:10.765461
\.


--
-- TOC entry 3604 (class 0 OID 18134)
-- Dependencies: 245
-- Data for Name: uom; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.uom (id, remark, conversion, created_at, updated_at) FROM stdin;
1	Botol	1	2022-06-01 20:55:39.248472	\N
2	Bungkus	1	2022-06-01 20:55:39.248472	\N
3	Tube	1	2022-06-01 20:55:39.248472	\N
4	Buah	1	2022-06-01 20:55:39.248472	\N
5	Sacheet	1	2022-06-01 20:55:39.248472	\N
6	Kotak	1	2022-06-01 20:55:39.248472	\N
7	Amplus	1	2022-06-01 20:55:39.248472	\N
8	Pcs	1	2022-06-01 20:55:39.248472	\N
9	90 Menit	90	2022-06-01 20:55:39.248472	\N
10	30 Menit	30	2022-06-01 20:55:39.248472	\N
11	45 Menit	45	2022-06-01 20:55:39.248472	\N
12	120 Menit	120	2022-06-01 20:55:39.248472	\N
13	5 Menit	5	2022-06-01 20:55:39.248472	\N
14	10 Menit	10	2022-06-01 20:55:39.248472	\N
15	15 Menit	15	2022-06-01 20:55:39.248472	\N
16	20 Menit	20	2022-06-01 20:55:39.248472	\N
17	1 Menit	1	2022-06-01 20:55:39.248472	\N
18	Pasang	1	2022-06-01 20:55:39.248472	\N
19	60 Menit	60	2022-06-01 20:55:39.248472	\N
20	150 Menit	150	2022-06-01 20:55:39.248472	\N
21	100 Menit	100	2022-06-01 20:55:39.248472	\N
23	Renceng	1	2022-07-25 14:17:17	2022-07-25 14:17:24
\.


--
-- TOC entry 3564 (class 0 OID 17806)
-- Dependencies: 205
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
3	User-Owner	owner@gmail.com	user-owner	\N	$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta	\N	2022-05-28 12:40:11	2022-08-21 03:25:52	6285746879090	JALAN JAKARTA	2022-01-01	1	Male	3524111233144330001	JAKARTA	20210101OWN	man.png	draft_netizen_01.jpg	3	1	6	\N	JAKARTA	2022-01-01	On Job Training	1
1	Admin	admin@gmail.com	admin	\N	$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta	\N	2022-05-28 12:40:11	2022-05-28 12:40:11	6285746879090	JALAN JAKARTA	2020-01-01	2	Male	3524111233144330001	JAKARTA	20210101ADM	user-13.jpg	user-13.jpg	6	2	5	\N	JAKARTA	2022-01-01	On Job Training	1
26	Test User	purnomo.yogiaditya@gmail.com	test_123	\N	$2y$10$bIEbT.3PQ4tHVbn9St.oreO5diYJGTV6TqNuWmgGqE8wScBqIxO1S	\N	2022-07-12 06:19:07	2022-07-12 08:02:57	085746879090	Lmg	2013-07-11	9	Male	35241112331443300021	Lmg	20000109YG	user-13.jpg	\N	3	2	2	3	test	2022-07-03	On Job Training	1
32	Jemm Rakar-Terapist	jemm@gmail.com	jem	\N	$2y$10$DtwhuxLX7GD5Mkcdtk3nK.9D.shExDpmeqeNaffU.KOTnAKhPmRrS	\N	2022-07-30 08:09:55	2022-07-30 08:09:55	082311111	Solo	2022-07-04	1	Male	35241112331443300012	Sragen	JR20220101102	user-13.jpg	\N	2	1	2	\N	Solo	2022-07-10	On Job Training	1
33	Fist Karl-Terapist	fist@gmail.com	pass123	\N	$2y$10$hv3IVYi39yFzGYmh3Th8KeuHaIRbKS/NHrL3QrypF46oOWYXFPy9a	\N	2022-07-30 08:48:31	2022-07-30 08:48:31	0813453211	Medan	2022-07-17	1	Male	35241112331443300021	Medan	2011010022	user-13.jpg	\N	2	1	2	14	Medan	2022-04-17	On Job Training	1
5	User-HR	hr@gmail.com	user-hr	\N	$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta	\N	2022-05-28 12:40:11	2022-07-06 14:26:35	6285746879090	JALAN JAKARTA	2021-01-01	1	Male	3524111233144330001	JAKARTA	20210101HR	user-13.jpg	user-13.jpg	5	1	4	1	JAKARTA	2022-01-01	On Job Training	1
29	John Doe-Terapist	johndoe@gmail.com	johndoe	\N	$2y$10$D8C5.ba4RGNeN9Q6uH82HeAm0P6S5jp.Y6e5IK11hypYnOByDW0rS	\N	2022-07-30 07:29:53	2022-07-30 07:56:32	085746879090	Pekanbaru	2022-05-22	1	Male	35241112331443300021	Pekanbaru	JD2022073001	user-13.jpg	\N	2	2	2	3	Suwoko	2020-12-28	On Job Training	1
2	User-Kasir	kasir@gmail.com	user-kasir	\N	$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta	\N	2022-05-28 12:40:11	2022-08-21 04:21:09	6285746879090	JALAN JAKARTA	2019-05-01	3	Female	35241112331443300012	JAKARTA	20210101KSR	user-13.jpg	draft_netizen.jpg	1	2	2	1	JAKARTA	2022-01-01	Contract	1
53	Fake Hokis-Terapist	dada@gmill.com	Faaee	\N	$2y$10$AcOnNDUrWd/nha4KRSySa.i2OiFXR4PP.UBjc4LWjQSLnwuhbCcAm	\N	2022-07-30 11:33:55	2022-07-30 11:33:55	085746879090	Lamongan	2022-07-10	1	Male	35241112331443300021	Lamongan	HK022133	0769c4c63be92e17c0bf06d131baca96.png	eddac66b535aa161c61b06d77f26b5e0.jpg	2	2	2	1	Jakarta	2022-07-11	On Job Training	1
54	Coach-Andy	trainer@gmail.com	trainer	\N	$2y$10$NeF32GFPD7LysV2ggx9OROXX0XuZorwFM9kxlSu8WGZtFnTljTmqG	\N	2022-08-20 11:30:05	2022-08-20 11:30:05	085746879090	Lamongan	2022-08-01	1	Male	35241112331443300021	Lamongan	TR-ADY-001	804e42dadef82ee18bcbf174a3ad9090.png	b8074bdb86f8572480601bf1cd2a42ad.jpg	7	1	9	\N	Test	2022-08-09	On Job Training	1
31	Johny Deep-Terapist	serang@gmail.com	johnydeep	\N	$2y$10$ZfgXjRK5S86XP2cJtmA6QOku/.v9jSEHfOIBxsZDmCAkKFTLA/MRW	\N	2022-07-30 08:03:28	2022-07-30 08:03:51	0844312333	Serang	2015-07-18	7	Male	35241112331443300021	Banten	JD202204011	user-13.jpg	\N	2	2	2	\N	Serang	2020-04-19	On Job Training	1
30	Mark Karl-Terapist	maxkarl@gmail.com	karlmax	\N	$2y$10$Ohj/K.hR2an/GZWn0ONjMe/xd02ZbPniiDcDkY6EcVr8smyPZMhHG	\N	2022-07-30 08:00:11	2022-07-30 08:07:59	081323	Lamongan	2016-07-18	6	Male	35241112331443300021	Lamongan	MK20220102	user-13.jpg	\N	2	3	2	27	Lamongan	2022-07-04	On Job Training	1
4	User-Admin Keuangan	finance@gmail.com	user-finance	\N	$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta	\N	2022-05-28 12:40:11	2022-07-30 08:27:49	6285746879090	JALAN JAKARTA	2022-01-01	1	Male	3524111233144330001	JAKARTA	20210101ADU	user-13.jpg	draft_netizen_01.jpg	4	1	3	\N	JAKARTA	2022-01-01	On Job Training	1
14	User-Terapist	terapist@gmail.com	user-terapist	\N	$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta	\N	2022-05-28 12:40:11	2022-06-11 12:06:30	6285746879090	JALAN JAKARTA	2017-01-01	5	Male	3524111233144330001	JAKARTA	20210101TRP	user-13.jpg	user-13.jpg	2	1	2	5	JAKARTA	2022-01-01	On Job Training	1
27	UserTerapist_2	yogiektambakboyo@gmail.com	userterapist2	\N	$2y$10$KUxgpNxhdNzyGOxkrjvsJ.e6Pm264gbZC7roqsC4nru/ALpI28PS.	\N	2022-07-25 11:46:21	2022-07-30 08:28:42	085746879090	Lamongan	2018-07-18	4	Male	35241112331443300021	Lamongan	20210021UU	user-13.jpg	draft_netizen_01.jpg	2	1	2	26	Jakarta	2022-07-10	On Job Training	1
\.


--
-- TOC entry 3613 (class 0 OID 18231)
-- Dependencies: 254
-- Data for Name: users_branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
25	3	2022-07-06 12:09:12	2022-07-06 12:09:12
1	1	2022-07-06 12:09:12	2022-07-06 12:09:12
14	2	2022-07-06 12:09:12	2022-07-06 12:09:12
5	2	2022-07-06 14:26:35	2022-07-06 14:26:35
5	3	2022-07-06 14:26:35	2022-07-06 14:26:35
1	3	2022-07-06 12:09:12	2022-07-06 12:09:12
1	2	2022-07-06 12:09:12	2022-07-06 12:09:12
26	2	2022-07-12 08:02:57	2022-07-12 08:02:57
28	2	2022-07-30 07:23:56	2022-07-30 07:23:56
29	2	2022-07-30 07:56:32	2022-07-30 07:56:32
31	2	2022-07-30 08:03:51	2022-07-30 08:03:51
30	3	2022-07-30 08:07:59	2022-07-30 08:07:59
32	2	2022-07-30 08:09:55	2022-07-30 08:09:55
4	1	2022-07-30 08:27:49	2022-07-30 08:27:49
27	1	2022-07-30 08:28:42	2022-07-30 08:28:42
33	2	2022-07-30 08:48:31	2022-07-30 08:48:31
34	2	2022-07-30 08:59:40	2022-07-30 08:59:40
35	2	2022-07-30 09:05:58	2022-07-30 09:05:58
36	2	2022-07-30 09:18:56	2022-07-30 09:18:56
37	2	2022-07-30 09:23:18	2022-07-30 09:23:18
38	2	2022-07-30 09:25:19	2022-07-30 09:25:19
39	2	2022-07-30 09:44:52	2022-07-30 09:44:52
40	2	2022-07-30 09:48:35	2022-07-30 09:48:35
41	2	2022-07-30 10:04:19	2022-07-30 10:04:19
42	2	2022-07-30 10:06:14	2022-07-30 10:06:14
43	2	2022-07-30 10:09:02	2022-07-30 10:09:02
44	2	2022-07-30 10:10:46	2022-07-30 10:10:46
45	2	2022-07-30 10:14:51	2022-07-30 10:14:51
46	2	2022-07-30 10:21:18	2022-07-30 10:21:18
47	2	2022-07-30 10:25:09	2022-07-30 10:25:09
48	2	2022-07-30 10:31:09	2022-07-30 10:31:09
52	2	2022-07-30 11:31:36	2022-07-30 11:31:36
53	2	2022-07-30 11:33:55	2022-07-30 11:33:55
54	1	2022-08-20 11:30:05	2022-08-20 11:30:05
3	1	2022-08-21 03:25:52	2022-08-21 03:25:52
2	2	2022-08-21 04:21:09	2022-08-21 04:21:09
\.


--
-- TOC entry 3624 (class 0 OID 18535)
-- Dependencies: 265
-- Data for Name: users_experience; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
1	2	Astra	Coordinator Sales	2019-2020	\N	1	2022-08-21 11:41:24.412471
\.


--
-- TOC entry 3587 (class 0 OID 17989)
-- Dependencies: 228
-- Data for Name: users_mutation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
1	2	2	1	1	Test	2022-07-12 11:48:14.272853	\N
2	2	2	1	2	Test	2022-07-12 12:00:46.39511	\N
4	26	1	2	1	\N	2022-07-12 06:53:32	2022-07-12 06:53:32
5	26	2	2	3	\N	2022-07-12 08:02:57	2022-07-12 08:02:57
7	27	1	2	2	\N	2022-07-25 11:49:24	2022-07-25 11:49:24
9	29	2	2	2	\N	2022-07-30 07:29:53	2022-07-30 07:29:53
10	29	2	2	2	\N	2022-07-30 07:53:12	2022-07-30 07:53:12
11	30	3	2	2	\N	2022-07-30 08:00:11	2022-07-30 08:00:11
12	31	2	2	2	\N	2022-07-30 08:03:28	2022-07-30 08:03:28
13	31	2	2	2	\N	2022-07-30 08:03:51	2022-07-30 08:03:51
14	30	3	2	2	\N	2022-07-30 08:07:59	2022-07-30 08:07:59
15	32	2	2	2	\N	2022-07-30 08:09:55	2022-07-30 08:09:55
16	2	2	2	1	\N	2022-07-30 08:26:07	2022-07-30 08:26:07
17	2	3	2	1	\N	2022-07-30 08:26:07	2022-07-30 08:26:07
18	4	1	3	4	\N	2022-07-30 08:27:49	2022-07-30 08:27:49
19	33	2	2	2	\N	2022-07-30 08:48:31	2022-07-30 08:48:31
20	34	2	2	2	\N	2022-07-30 08:59:40	2022-07-30 08:59:40
21	35	2	3	1	\N	2022-07-30 09:05:58	2022-07-30 09:05:58
22	36	2	4	1	\N	2022-07-30 09:18:56	2022-07-30 09:18:56
23	37	2	2	2	\N	2022-07-30 09:23:18	2022-07-30 09:23:18
24	38	2	2	2	\N	2022-07-30 09:24:32	2022-07-30 09:24:32
25	38	2	2	2	\N	2022-07-30 09:25:19	2022-07-30 09:25:19
26	39	2	2	2	\N	2022-07-30 09:44:52	2022-07-30 09:44:52
27	40	2	2	2	\N	2022-07-30 09:48:35	2022-07-30 09:48:35
28	41	2	2	2	\N	2022-07-30 10:04:19	2022-07-30 10:04:19
29	42	2	2	2	\N	2022-07-30 10:06:14	2022-07-30 10:06:14
30	43	2	2	1	\N	2022-07-30 10:09:02	2022-07-30 10:09:02
31	44	2	2	2	\N	2022-07-30 10:10:46	2022-07-30 10:10:46
32	45	2	2	2	\N	2022-07-30 10:14:02	2022-07-30 10:14:02
33	45	2	2	2	\N	2022-07-30 10:14:51	2022-07-30 10:14:51
34	46	2	2	2	\N	2022-07-30 10:21:18	2022-07-30 10:21:18
35	47	2	2	2	\N	2022-07-30 10:25:09	2022-07-30 10:25:09
36	48	2	2	2	\N	2022-07-30 10:31:09	2022-07-30 10:31:09
37	52	2	2	2	\N	2022-07-30 11:31:36	2022-07-30 11:31:36
38	53	2	2	2	\N	2022-07-30 11:33:55	2022-07-30 11:33:55
39	2	2	2	1	\N	2022-08-01 08:18:48	2022-08-01 08:18:48
40	54	1	9	7	\N	2022-08-20 11:30:05	2022-08-20 11:30:05
\.


--
-- TOC entry 3633 (class 0 OID 18734)
-- Dependencies: 274
-- Data for Name: users_shift; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
1	2	2022-09-01	1	Shift I Pagi	08:00:00	15:00:00	Test II	2022-09-15 12:02:50	2022-09-12 09:20:34.369454	1
\.


--
-- TOC entry 3579 (class 0 OID 17935)
-- Dependencies: 220
-- Data for Name: users_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
2	40	54	Failed	2022-08-21	\N	1	2022-08-21 09:29:19.91552
2	48	54	In Training	2022-08-26	\N	1	2022-08-21 10:08:40.959154
\.


--
-- TOC entry 3641 (class 0 OID 18859)
-- Dependencies: 282
-- Data for Name: voucher; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark) FROM stdin;
4	TESTAAVC23	1	2022-09-18	2022-09-23	0	2022-09-18 01:22:56	1	2022-09-18 01:22:42	18	50	test Voucher
5	CSSKR	1	2022-09-05	2022-09-20	0	2022-09-18 01:23:32	1	2022-09-18 01:23:32	1	50	TEst II
1	ABC	1	2022-09-01	2022-10-30	0	2022-09-26 12:21:12	1	2022-09-17 12:45:52.973274	1	100	VOUCHER 100%
\.


--
-- TOC entry 3679 (class 0 OID 0)
-- Dependencies: 225
-- Name: branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_id_seq', 11, true);


--
-- TOC entry 3680 (class 0 OID 0)
-- Dependencies: 249
-- Name: branch_room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_room_id_seq', 13, true);


--
-- TOC entry 3681 (class 0 OID 0)
-- Dependencies: 269
-- Name: company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.company_id_seq', 1, true);


--
-- TOC entry 3682 (class 0 OID 0)
-- Dependencies: 231
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_id_seq', 17, true);


--
-- TOC entry 3683 (class 0 OID 0)
-- Dependencies: 223
-- Name: department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.department_id_seq', 10, true);


--
-- TOC entry 3684 (class 0 OID 0)
-- Dependencies: 207
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- TOC entry 3685 (class 0 OID 0)
-- Dependencies: 256
-- Name: invoice_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invoice_master_id_seq', 57, true);


--
-- TOC entry 3686 (class 0 OID 0)
-- Dependencies: 221
-- Name: job_title_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);


--
-- TOC entry 3687 (class 0 OID 0)
-- Dependencies: 202
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);


--
-- TOC entry 3688 (class 0 OID 0)
-- Dependencies: 229
-- Name: order_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_master_id_seq', 92, true);


--
-- TOC entry 3689 (class 0 OID 0)
-- Dependencies: 211
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 315, true);


--
-- TOC entry 3690 (class 0 OID 0)
-- Dependencies: 209
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);


--
-- TOC entry 3691 (class 0 OID 0)
-- Dependencies: 218
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 2, true);


--
-- TOC entry 3692 (class 0 OID 0)
-- Dependencies: 279
-- Name: price_adjustment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.price_adjustment_id_seq', 6, true);


--
-- TOC entry 3693 (class 0 OID 0)
-- Dependencies: 236
-- Name: product_brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_brand_id_seq', 9, true);


--
-- TOC entry 3694 (class 0 OID 0)
-- Dependencies: 238
-- Name: product_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_category_id_seq', 15, true);


--
-- TOC entry 3695 (class 0 OID 0)
-- Dependencies: 234
-- Name: product_sku_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_sku_id_seq', 89, true);


--
-- TOC entry 3696 (class 0 OID 0)
-- Dependencies: 261
-- Name: product_stock_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 20, true);


--
-- TOC entry 3697 (class 0 OID 0)
-- Dependencies: 251
-- Name: product_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);


--
-- TOC entry 3698 (class 0 OID 0)
-- Dependencies: 244
-- Name: product_uom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_uom_id_seq', 23, true);


--
-- TOC entry 3699 (class 0 OID 0)
-- Dependencies: 266
-- Name: purchase_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_master_id_seq', 15, true);


--
-- TOC entry 3700 (class 0 OID 0)
-- Dependencies: 276
-- Name: receive_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.receive_master_id_seq', 15, true);


--
-- TOC entry 3701 (class 0 OID 0)
-- Dependencies: 213
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 11, true);


--
-- TOC entry 3702 (class 0 OID 0)
-- Dependencies: 272
-- Name: shift_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shift_id_seq', 9, true);


--
-- TOC entry 3703 (class 0 OID 0)
-- Dependencies: 259
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 4, true);


--
-- TOC entry 3704 (class 0 OID 0)
-- Dependencies: 264
-- Name: users_experience_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);


--
-- TOC entry 3705 (class 0 OID 0)
-- Dependencies: 204
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 54, true);


--
-- TOC entry 3706 (class 0 OID 0)
-- Dependencies: 227
-- Name: users_mutation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_mutation_id_seq', 40, true);


--
-- TOC entry 3707 (class 0 OID 0)
-- Dependencies: 275
-- Name: users_shift_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_shift_id_seq', 4, true);


--
-- TOC entry 3708 (class 0 OID 0)
-- Dependencies: 281
-- Name: voucher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.voucher_id_seq', 5, true);


--
-- TOC entry 3329 (class 2606 OID 17984)
-- Name: branch branch_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);


--
-- TOC entry 3363 (class 2606 OID 18195)
-- Name: branch_room branch_room_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);


--
-- TOC entry 3331 (class 2606 OID 17986)
-- Name: branch branch_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);


--
-- TOC entry 3391 (class 2606 OID 18704)
-- Name: company company_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);


--
-- TOC entry 3339 (class 2606 OID 18021)
-- Name: customers customers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);


--
-- TOC entry 3300 (class 2606 OID 17837)
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- TOC entry 3302 (class 2606 OID 17839)
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- TOC entry 3375 (class 2606 OID 18319)
-- Name: invoice_detail invoice_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);


--
-- TOC entry 3371 (class 2606 OID 18280)
-- Name: invoice_master invoice_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);


--
-- TOC entry 3373 (class 2606 OID 18282)
-- Name: invoice_master invoice_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);


--
-- TOC entry 3291 (class 2606 OID 17803)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3318 (class 2606 OID 17890)
-- Name: model_has_permissions model_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);


--
-- TOC entry 3321 (class 2606 OID 17901)
-- Name: model_has_roles model_has_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);


--
-- TOC entry 3341 (class 2606 OID 18057)
-- Name: order_detail order_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);


--
-- TOC entry 3335 (class 2606 OID 18029)
-- Name: order_master order_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);


--
-- TOC entry 3337 (class 2606 OID 18031)
-- Name: order_master order_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);


--
-- TOC entry 3381 (class 2606 OID 18514)
-- Name: period_stock period_stock_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);


--
-- TOC entry 3309 (class 2606 OID 17866)
-- Name: permissions permissions_name_guard_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_name_guard_name_unique UNIQUE (name, guard_name);


--
-- TOC entry 3311 (class 2606 OID 17864)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3304 (class 2606 OID 17850)
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3306 (class 2606 OID 17853)
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- TOC entry 3411 (class 2606 OID 18879)
-- Name: point_conversion point_conversion_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);


--
-- TOC entry 3325 (class 2606 OID 17927)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- TOC entry 3405 (class 2606 OID 18854)
-- Name: price_adjustment price_adjustment_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);


--
-- TOC entry 3407 (class 2606 OID 18856)
-- Name: price_adjustment price_adjustment_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);


--
-- TOC entry 3361 (class 2606 OID 18168)
-- Name: product_commision_by_year product_commision_by_year_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);


--
-- TOC entry 3357 (class 2606 OID 18156)
-- Name: product_commisions product_commisions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3347 (class 2606 OID 18100)
-- Name: product_distribution product_distribution_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3393 (class 2606 OID 18713)
-- Name: product_ingredients product_ingredients_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pk PRIMARY KEY (product_id, product_id_material);


--
-- TOC entry 3359 (class 2606 OID 18162)
-- Name: product_point product_point_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3349 (class 2606 OID 18120)
-- Name: product_price product_price_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3343 (class 2606 OID 18107)
-- Name: product_sku product_sku_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);


--
-- TOC entry 3345 (class 2606 OID 18109)
-- Name: product_sku product_sku_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_un UNIQUE (abbr);


--
-- TOC entry 3379 (class 2606 OID 18500)
-- Name: product_stock_detail product_stock_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock_detail
    ADD CONSTRAINT product_stock_detail_pk PRIMARY KEY (id);


--
-- TOC entry 3369 (class 2606 OID 18259)
-- Name: product_stock product_stock_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3365 (class 2606 OID 18221)
-- Name: product_uom product_uom_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_pk PRIMARY KEY (product_id, uom_id);


--
-- TOC entry 3389 (class 2606 OID 18685)
-- Name: purchase_detail purchase_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_pk PRIMARY KEY (purchase_no, product_id);


--
-- TOC entry 3385 (class 2606 OID 18638)
-- Name: purchase_master purchase_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_pk PRIMARY KEY (id);


--
-- TOC entry 3387 (class 2606 OID 18640)
-- Name: purchase_master purchase_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_un UNIQUE (purchase_no);


--
-- TOC entry 3403 (class 2606 OID 18828)
-- Name: receive_detail receive_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_pk PRIMARY KEY (receive_no, product_id, expired_at);


--
-- TOC entry 3399 (class 2606 OID 18806)
-- Name: receive_master receive_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_pk PRIMARY KEY (id);


--
-- TOC entry 3401 (class 2606 OID 18808)
-- Name: receive_master receive_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_un UNIQUE (receive_no);


--
-- TOC entry 3323 (class 2606 OID 17916)
-- Name: role_has_permissions role_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);


--
-- TOC entry 3313 (class 2606 OID 17879)
-- Name: roles roles_name_guard_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);


--
-- TOC entry 3315 (class 2606 OID 17877)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3351 (class 2606 OID 18252)
-- Name: settings settings_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (company_name, app_name);


--
-- TOC entry 3395 (class 2606 OID 18733)
-- Name: shift shift_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pk PRIMARY KEY (time_start, time_end);


--
-- TOC entry 3377 (class 2606 OID 18693)
-- Name: suppliers suppliers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pk PRIMARY KEY (id);


--
-- TOC entry 3353 (class 2606 OID 18228)
-- Name: uom uom_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);


--
-- TOC entry 3355 (class 2606 OID 18230)
-- Name: uom uom_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_un UNIQUE (remark);


--
-- TOC entry 3367 (class 2606 OID 18236)
-- Name: users_branch users_branch_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_branch
    ADD CONSTRAINT users_branch_pk PRIMARY KEY (user_id, branch_id);


--
-- TOC entry 3293 (class 2606 OID 17816)
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- TOC entry 3383 (class 2606 OID 18543)
-- Name: users_experience users_experience_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_experience
    ADD CONSTRAINT users_experience_pk PRIMARY KEY (id);


--
-- TOC entry 3333 (class 2606 OID 17998)
-- Name: users_mutation users_mutation_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_mutation
    ADD CONSTRAINT users_mutation_pk PRIMARY KEY (id);


--
-- TOC entry 3295 (class 2606 OID 17814)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3397 (class 2606 OID 18742)
-- Name: users_shift users_shift_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_shift
    ADD CONSTRAINT users_shift_pk PRIMARY KEY (branch_id, users_id, dated, shift_id);


--
-- TOC entry 3327 (class 2606 OID 18532)
-- Name: users_skills users_skills_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_pk PRIMARY KEY (users_id, modul, dated, status);


--
-- TOC entry 3297 (class 2606 OID 17818)
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- TOC entry 3409 (class 2606 OID 18869)
-- Name: voucher voucher_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voucher
    ADD CONSTRAINT voucher_pk PRIMARY KEY (voucher_code, branch_id);


--
-- TOC entry 3316 (class 1259 OID 17883)
-- Name: model_has_permissions_model_id_model_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);


--
-- TOC entry 3319 (class 1259 OID 17894)
-- Name: model_has_roles_model_id_model_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);


--
-- TOC entry 3298 (class 1259 OID 17825)
-- Name: password_resets_email_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);


--
-- TOC entry 3307 (class 1259 OID 17851)
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- TOC entry 3426 (class 2606 OID 18201)
-- Name: branch_room branch_room_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3430 (class 2606 OID 18320)
-- Name: invoice_detail invoice_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);


--
-- TOC entry 3428 (class 2606 OID 18283)
-- Name: invoice_master invoice_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3429 (class 2606 OID 18288)
-- Name: invoice_master invoice_master_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);


--
-- TOC entry 3412 (class 2606 OID 17884)
-- Name: model_has_permissions model_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 3413 (class 2606 OID 17895)
-- Name: model_has_roles model_has_roles_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 3420 (class 2606 OID 18058)
-- Name: order_detail order_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);


--
-- TOC entry 3418 (class 2606 OID 18032)
-- Name: order_master order_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3419 (class 2606 OID 18037)
-- Name: order_master order_master_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);


--
-- TOC entry 3416 (class 2606 OID 17928)
-- Name: posts posts_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3423 (class 2606 OID 18169)
-- Name: product_commision_by_year product_commision_by_year_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3424 (class 2606 OID 18174)
-- Name: product_commision_by_year product_commision_by_year_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3425 (class 2606 OID 18179)
-- Name: product_commision_by_year product_commision_by_year_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3421 (class 2606 OID 18101)
-- Name: product_distribution product_distribution_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3422 (class 2606 OID 18110)
-- Name: product_distribution product_distribution_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3427 (class 2606 OID 18222)
-- Name: product_uom product_uom_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3432 (class 2606 OID 18686)
-- Name: purchase_detail purchase_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);


--
-- TOC entry 3431 (class 2606 OID 18641)
-- Name: purchase_master purchase_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3434 (class 2606 OID 18829)
-- Name: receive_detail receive_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);


--
-- TOC entry 3433 (class 2606 OID 18809)
-- Name: receive_master receive_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3414 (class 2606 OID 17905)
-- Name: role_has_permissions role_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 3415 (class 2606 OID 17910)
-- Name: role_has_permissions role_has_permissions_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 3417 (class 2606 OID 17944)
-- Name: users_skills users_skills_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);


-- Completed on 2022-10-30 18:52:22 WIB

--
-- PostgreSQL database dump complete
--

