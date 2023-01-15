--
-- PostgreSQL database dump
--

-- Dumped from database version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 15.0

-- Started on 2023-01-10 23:20:06

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
-- TOC entry 6 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3783 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 202 (class 1259 OID 17914)
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
-- TOC entry 203 (class 1259 OID 17922)
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
-- TOC entry 3785 (class 0 OID 0)
-- Dependencies: 203
-- Name: branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.branch_id_seq OWNED BY public.branch.id;


--
-- TOC entry 204 (class 1259 OID 17924)
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
-- TOC entry 205 (class 1259 OID 17931)
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
-- TOC entry 3786 (class 0 OID 0)
-- Dependencies: 205
-- Name: branch_room_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.branch_room_id_seq OWNED BY public.branch_room.id;


--
-- TOC entry 293 (class 1259 OID 18720)
-- Name: branch_shift; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.branch_shift (
    id smallint NOT NULL,
    branch_id integer NOT NULL,
    shift_id integer NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.branch_shift OWNER TO postgres;

--
-- TOC entry 292 (class 1259 OID 18718)
-- Name: branch_shift_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.branch_shift_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.branch_shift_id_seq OWNER TO postgres;

--
-- TOC entry 3787 (class 0 OID 0)
-- Dependencies: 292
-- Name: branch_shift_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.branch_shift_id_seq OWNED BY public.branch_shift.id;


--
-- TOC entry 305 (class 1259 OID 26919)
-- Name: calendar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.calendar (
    id bigint NOT NULL,
    dated date NOT NULL,
    week character varying,
    period character varying NOT NULL,
    updated_at timestamp without time zone,
    updated_by integer,
    created_by integer,
    created_at timestamp without time zone
);


ALTER TABLE public.calendar OWNER TO postgres;

--
-- TOC entry 304 (class 1259 OID 26917)
-- Name: calendar_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.calendar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.calendar_id_seq OWNER TO postgres;

--
-- TOC entry 3788 (class 0 OID 0)
-- Dependencies: 304
-- Name: calendar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.calendar_id_seq OWNED BY public.calendar.id;


--
-- TOC entry 206 (class 1259 OID 17933)
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
-- TOC entry 207 (class 1259 OID 17940)
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
-- TOC entry 3789 (class 0 OID 0)
-- Dependencies: 207
-- Name: company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.company_id_seq OWNED BY public.company.id;


--
-- TOC entry 208 (class 1259 OID 17942)
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
    updated_at timestamp without time zone,
    sales_id integer,
    city character varying,
    notes character varying,
    credit_limit integer,
    longitude character varying,
    latitude character varying,
    email character varying,
    handphone character varying,
    whatsapp_no character varying,
    citizen_id character varying,
    tax_id character varying,
    contact_person character varying,
    type character varying,
    clasification character varying,
    contact_person_job_position character varying,
    contact_person_level character varying
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 17950)
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
-- TOC entry 3790 (class 0 OID 0)
-- Dependencies: 209
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- TOC entry 303 (class 1259 OID 18774)
-- Name: customers_registration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers_registration (
    id bigint NOT NULL,
    name character varying NOT NULL,
    address character varying NOT NULL,
    phone_no character varying,
    membership_id integer DEFAULT 1 NOT NULL,
    abbr character varying,
    branch_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    sales_id integer,
    city character varying,
    notes character varying,
    credit_limit integer,
    longitude character varying,
    latitude character varying,
    email character varying,
    handphone character varying,
    whatsapp_no character varying,
    citizen_id character varying,
    tax_id character varying,
    contact_person character varying,
    type character varying,
    clasification character varying,
    contact_person_job_position character varying,
    contact_person_level character varying,
    is_approved smallint DEFAULT 0 NOT NULL,
    photo character varying
);


ALTER TABLE public.customers_registration OWNER TO postgres;

--
-- TOC entry 302 (class 1259 OID 18772)
-- Name: customers_registration_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_registration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_registration_id_seq OWNER TO postgres;

--
-- TOC entry 3791 (class 0 OID 0)
-- Dependencies: 302
-- Name: customers_registration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_registration_id_seq OWNED BY public.customers_registration.id;


--
-- TOC entry 210 (class 1259 OID 17952)
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
-- TOC entry 211 (class 1259 OID 17960)
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
-- TOC entry 3792 (class 0 OID 0)
-- Dependencies: 211
-- Name: department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.department_id_seq OWNED BY public.departments.id;


--
-- TOC entry 212 (class 1259 OID 17962)
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
-- TOC entry 213 (class 1259 OID 17969)
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
-- TOC entry 3793 (class 0 OID 0)
-- Dependencies: 213
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- TOC entry 214 (class 1259 OID 17971)
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
-- TOC entry 215 (class 1259 OID 17984)
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
    payment_type character varying,
    payment_nominal numeric(18,0) DEFAULT 0 NOT NULL,
    voucher_code character varying,
    scheduled_at timestamp without time zone DEFAULT now() NOT NULL,
    branch_room_id integer,
    ref_no character varying,
    updated_by integer,
    printed_at timestamp without time zone,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    is_checkout smallint DEFAULT 0 NOT NULL,
    is_canceled smallint DEFAULT 0 NOT NULL,
    customers_name character varying,
    printed_count integer DEFAULT 0 NOT NULL,
    customer_type character varying
);


ALTER TABLE public.invoice_master OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 18001)
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
-- TOC entry 3794 (class 0 OID 0)
-- Dependencies: 216
-- Name: invoice_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.invoice_master_id_seq OWNED BY public.invoice_master.id;


--
-- TOC entry 217 (class 1259 OID 18003)
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
-- TOC entry 218 (class 1259 OID 18011)
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
-- TOC entry 3795 (class 0 OID 0)
-- Dependencies: 218
-- Name: job_title_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.job_title_id_seq OWNED BY public.job_title.id;


--
-- TOC entry 295 (class 1259 OID 18727)
-- Name: login_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login_session (
    id bigint NOT NULL,
    session character varying(50) NOT NULL,
    sellercode character varying(20) NOT NULL,
    description character varying(100) NOT NULL,
    created_date timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.login_session OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 18013)
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 18016)
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
-- TOC entry 3796 (class 0 OID 0)
-- Dependencies: 220
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- TOC entry 221 (class 1259 OID 18018)
-- Name: model_has_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.model_has_permissions (
    permission_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);


ALTER TABLE public.model_has_permissions OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 18021)
-- Name: model_has_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.model_has_roles (
    role_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);


ALTER TABLE public.model_has_roles OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 18024)
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
-- TOC entry 224 (class 1259 OID 18036)
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
-- TOC entry 225 (class 1259 OID 18053)
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
-- TOC entry 3797 (class 0 OID 0)
-- Dependencies: 225
-- Name: order_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_master_id_seq OWNED BY public.order_master.id;


--
-- TOC entry 226 (class 1259 OID 18055)
-- Name: password_resets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_resets (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_resets OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 18061)
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
-- TOC entry 228 (class 1259 OID 18067)
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
-- TOC entry 229 (class 1259 OID 18071)
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
-- TOC entry 3798 (class 0 OID 0)
-- Dependencies: 229
-- Name: period_price_sell_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.period_price_sell_id_seq OWNED BY public.period_price_sell.id;


--
-- TOC entry 230 (class 1259 OID 18073)
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
-- TOC entry 231 (class 1259 OID 18083)
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
-- TOC entry 232 (class 1259 OID 18089)
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
-- TOC entry 3799 (class 0 OID 0)
-- Dependencies: 232
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- TOC entry 233 (class 1259 OID 18091)
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
-- TOC entry 234 (class 1259 OID 18097)
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
-- TOC entry 3800 (class 0 OID 0)
-- Dependencies: 234
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- TOC entry 235 (class 1259 OID 18099)
-- Name: point_conversion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.point_conversion (
    point_qty integer DEFAULT 0 NOT NULL,
    point_value integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.point_conversion OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 18104)
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
-- TOC entry 237 (class 1259 OID 18110)
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
-- TOC entry 3801 (class 0 OID 0)
-- Dependencies: 237
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;


--
-- TOC entry 238 (class 1259 OID 18112)
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
-- TOC entry 239 (class 1259 OID 18117)
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
-- TOC entry 3802 (class 0 OID 0)
-- Dependencies: 239
-- Name: price_adjustment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.price_adjustment_id_seq OWNED BY public.price_adjustment.id;


--
-- TOC entry 240 (class 1259 OID 18119)
-- Name: product_brand; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_brand (
    id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.product_brand OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 18127)
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
-- TOC entry 3803 (class 0 OID 0)
-- Dependencies: 241
-- Name: product_brand_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_brand_id_seq OWNED BY public.product_brand.id;


--
-- TOC entry 242 (class 1259 OID 18129)
-- Name: product_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_category (
    id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.product_category OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 18137)
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
-- TOC entry 3804 (class 0 OID 0)
-- Dependencies: 243
-- Name: product_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;


--
-- TOC entry 244 (class 1259 OID 18139)
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
-- TOC entry 245 (class 1259 OID 18143)
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
-- TOC entry 246 (class 1259 OID 18149)
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
-- TOC entry 247 (class 1259 OID 18154)
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
-- TOC entry 248 (class 1259 OID 18159)
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
-- TOC entry 249 (class 1259 OID 18163)
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
-- TOC entry 250 (class 1259 OID 18167)
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
-- TOC entry 3805 (class 0 OID 0)
-- Dependencies: 250
-- Name: COLUMN product_sku.type_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.product_sku.type_id IS '''Product/Service''';


--
-- TOC entry 251 (class 1259 OID 18176)
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
-- TOC entry 3806 (class 0 OID 0)
-- Dependencies: 251
-- Name: product_sku_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_sku_id_seq OWNED BY public.product_sku.id;


--
-- TOC entry 252 (class 1259 OID 18178)
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
-- TOC entry 253 (class 1259 OID 18183)
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
-- TOC entry 254 (class 1259 OID 18189)
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
-- TOC entry 3807 (class 0 OID 0)
-- Dependencies: 254
-- Name: product_stock_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_stock_detail_id_seq OWNED BY public.product_stock_detail.id;


--
-- TOC entry 255 (class 1259 OID 18191)
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
-- TOC entry 256 (class 1259 OID 18198)
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
-- TOC entry 3808 (class 0 OID 0)
-- Dependencies: 256
-- Name: product_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_type_id_seq OWNED BY public.product_type.id;


--
-- TOC entry 257 (class 1259 OID 18200)
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
-- TOC entry 258 (class 1259 OID 18204)
-- Name: uom; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uom (
    id integer NOT NULL,
    remark character varying NOT NULL,
    conversion integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.uom OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 18213)
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
-- TOC entry 3809 (class 0 OID 0)
-- Dependencies: 259
-- Name: product_uom_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_uom_id_seq OWNED BY public.uom.id;


--
-- TOC entry 260 (class 1259 OID 18215)
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
-- TOC entry 261 (class 1259 OID 18230)
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
-- TOC entry 262 (class 1259 OID 18246)
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
-- TOC entry 3810 (class 0 OID 0)
-- Dependencies: 262
-- Name: purchase_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchase_master_id_seq OWNED BY public.purchase_master.id;


--
-- TOC entry 263 (class 1259 OID 18248)
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
-- TOC entry 264 (class 1259 OID 18262)
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
-- TOC entry 265 (class 1259 OID 18278)
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
-- TOC entry 3811 (class 0 OID 0)
-- Dependencies: 265
-- Name: receive_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;


--
-- TOC entry 266 (class 1259 OID 18280)
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
-- TOC entry 267 (class 1259 OID 18292)
-- Name: return_sell_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.return_sell_master (
    id bigint NOT NULL,
    return_sell_no character varying NOT NULL,
    dated date DEFAULT (now())::date NOT NULL,
    customers_id integer NOT NULL,
    total numeric(18,0) DEFAULT 0 NOT NULL,
    tax numeric(18,0) DEFAULT 0 NOT NULL,
    total_payment numeric(18,0) DEFAULT 0,
    total_discount numeric(18,0) DEFAULT 0,
    remark character varying,
    payment_type character varying,
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
-- TOC entry 268 (class 1259 OID 18309)
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
-- TOC entry 3812 (class 0 OID 0)
-- Dependencies: 268
-- Name: return_sell_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;


--
-- TOC entry 269 (class 1259 OID 18311)
-- Name: role_has_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_has_permissions (
    permission_id bigint NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE public.role_has_permissions OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 18314)
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
-- TOC entry 271 (class 1259 OID 18320)
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
-- TOC entry 3813 (class 0 OID 0)
-- Dependencies: 271
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 297 (class 1259 OID 18736)
-- Name: sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales (
    id bigint NOT NULL,
    name character varying,
    username character varying,
    password character varying,
    address character varying,
    branch_id integer,
    active smallint DEFAULT 1 NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sales OWNER TO postgres;

--
-- TOC entry 296 (class 1259 OID 18734)
-- Name: sales_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_id_seq OWNER TO postgres;

--
-- TOC entry 3814 (class 0 OID 0)
-- Dependencies: 296
-- Name: sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;


--
-- TOC entry 299 (class 1259 OID 18750)
-- Name: sales_trip; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_trip (
    id bigint NOT NULL,
    dated date DEFAULT now() NOT NULL,
    sales_id integer NOT NULL,
    time_start timestamp without time zone DEFAULT now() NOT NULL,
    time_end timestamp without time zone DEFAULT now() NOT NULL,
    active smallint DEFAULT 1 NOT NULL,
    updated_at timestamp without time zone,
    updated_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    photo character varying,
    notes character varying,
    created_by integer
);


ALTER TABLE public.sales_trip OWNER TO postgres;

--
-- TOC entry 301 (class 1259 OID 18762)
-- Name: sales_trip_detail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_trip_detail (
    id bigint NOT NULL,
    trip_id integer NOT NULL,
    longitude character varying,
    latitude character varying,
    georeverse character varying,
    updated_at timestamp without time zone,
    updated_by integer,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sales_trip_detail OWNER TO postgres;

--
-- TOC entry 300 (class 1259 OID 18760)
-- Name: sales_trip_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sales_trip_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_trip_detail_id_seq OWNER TO postgres;

--
-- TOC entry 3815 (class 0 OID 0)
-- Dependencies: 300
-- Name: sales_trip_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;


--
-- TOC entry 298 (class 1259 OID 18748)
-- Name: sales_trip_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sales_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_trip_id_seq OWNER TO postgres;

--
-- TOC entry 3816 (class 0 OID 0)
-- Dependencies: 298
-- Name: sales_trip_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;


--
-- TOC entry 272 (class 1259 OID 18322)
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
-- TOC entry 3817 (class 0 OID 0)
-- Dependencies: 272
-- Name: COLUMN setting_document_counter.period; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';


--
-- TOC entry 273 (class 1259 OID 18330)
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
-- TOC entry 3818 (class 0 OID 0)
-- Dependencies: 273
-- Name: setting_document_counter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;


--
-- TOC entry 274 (class 1259 OID 18332)
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
-- TOC entry 275 (class 1259 OID 18339)
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
-- TOC entry 276 (class 1259 OID 18348)
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
-- TOC entry 277 (class 1259 OID 18352)
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
-- TOC entry 3819 (class 0 OID 0)
-- Dependencies: 277
-- Name: shift_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;


--
-- TOC entry 278 (class 1259 OID 18354)
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
-- TOC entry 279 (class 1259 OID 18361)
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
-- TOC entry 3820 (class 0 OID 0)
-- Dependencies: 279
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;


--
-- TOC entry 294 (class 1259 OID 18725)
-- Name: sv_login_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sv_login_session_id_seq OWNER TO postgres;

--
-- TOC entry 3821 (class 0 OID 0)
-- Dependencies: 294
-- Name: sv_login_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;


--
-- TOC entry 280 (class 1259 OID 18363)
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
-- TOC entry 281 (class 1259 OID 18371)
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
-- TOC entry 282 (class 1259 OID 18375)
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
-- TOC entry 283 (class 1259 OID 18382)
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
-- TOC entry 3822 (class 0 OID 0)
-- Dependencies: 283
-- Name: users_experience_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;


--
-- TOC entry 284 (class 1259 OID 18384)
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
-- TOC entry 3823 (class 0 OID 0)
-- Dependencies: 284
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 285 (class 1259 OID 18386)
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
-- TOC entry 286 (class 1259 OID 18393)
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
-- TOC entry 3824 (class 0 OID 0)
-- Dependencies: 286
-- Name: users_mutation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;


--
-- TOC entry 287 (class 1259 OID 18395)
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
-- TOC entry 288 (class 1259 OID 18402)
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
-- TOC entry 3825 (class 0 OID 0)
-- Dependencies: 288
-- Name: users_shift_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;


--
-- TOC entry 289 (class 1259 OID 18404)
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
-- TOC entry 290 (class 1259 OID 18412)
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
-- TOC entry 291 (class 1259 OID 18421)
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
-- TOC entry 3826 (class 0 OID 0)
-- Dependencies: 291
-- Name: voucher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;


--
-- TOC entry 3170 (class 2604 OID 18423)
-- Name: branch id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);


--
-- TOC entry 3173 (class 2604 OID 18424)
-- Name: branch_room id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);


--
-- TOC entry 3358 (class 2604 OID 18723)
-- Name: branch_shift id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_shift ALTER COLUMN id SET DEFAULT nextval('public.branch_shift_id_seq'::regclass);


--
-- TOC entry 3377 (class 2604 OID 26922)
-- Name: calendar id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);


--
-- TOC entry 3175 (class 2604 OID 18425)
-- Name: company id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);


--
-- TOC entry 3177 (class 2604 OID 18426)
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- TOC entry 3373 (class 2604 OID 18777)
-- Name: customers_registration id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_registration ALTER COLUMN id SET DEFAULT nextval('public.customers_registration_id_seq'::regclass);


--
-- TOC entry 3180 (class 2604 OID 18427)
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);


--
-- TOC entry 3183 (class 2604 OID 18428)
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- TOC entry 3192 (class 2604 OID 18429)
-- Name: invoice_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);


--
-- TOC entry 3204 (class 2604 OID 18430)
-- Name: job_title id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);


--
-- TOC entry 3360 (class 2604 OID 18730)
-- Name: login_session id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);


--
-- TOC entry 3207 (class 2604 OID 18431)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 3214 (class 2604 OID 18432)
-- Name: order_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master ALTER COLUMN id SET DEFAULT nextval('public.order_master_id_seq'::regclass);


--
-- TOC entry 3226 (class 2604 OID 18433)
-- Name: period_price_sell id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.period_price_sell ALTER COLUMN id SET DEFAULT nextval('public.period_price_sell_id_seq'::regclass);


--
-- TOC entry 3235 (class 2604 OID 18434)
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- TOC entry 3236 (class 2604 OID 18435)
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- TOC entry 3239 (class 2604 OID 18436)
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- TOC entry 3240 (class 2604 OID 18437)
-- Name: price_adjustment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_adjustment ALTER COLUMN id SET DEFAULT nextval('public.price_adjustment_id_seq'::regclass);


--
-- TOC entry 3243 (class 2604 OID 18438)
-- Name: product_brand id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_brand ALTER COLUMN id SET DEFAULT nextval('public.product_brand_id_seq'::regclass);


--
-- TOC entry 3246 (class 2604 OID 18439)
-- Name: product_category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);


--
-- TOC entry 3256 (class 2604 OID 18440)
-- Name: product_sku id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku ALTER COLUMN id SET DEFAULT nextval('public.product_sku_id_seq'::regclass);


--
-- TOC entry 3262 (class 2604 OID 18441)
-- Name: product_stock_detail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock_detail ALTER COLUMN id SET DEFAULT nextval('public.product_stock_detail_id_seq'::regclass);


--
-- TOC entry 3266 (class 2604 OID 18442)
-- Name: product_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_type ALTER COLUMN id SET DEFAULT nextval('public.product_type_id_seq'::regclass);


--
-- TOC entry 3282 (class 2604 OID 18443)
-- Name: purchase_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master ALTER COLUMN id SET DEFAULT nextval('public.purchase_master_id_seq'::regclass);


--
-- TOC entry 3301 (class 2604 OID 18444)
-- Name: receive_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);


--
-- TOC entry 3318 (class 2604 OID 18445)
-- Name: return_sell_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_master ALTER COLUMN id SET DEFAULT nextval('public.return_sell_master_id_seq'::regclass);


--
-- TOC entry 3330 (class 2604 OID 18446)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 3362 (class 2604 OID 18739)
-- Name: sales id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);


--
-- TOC entry 3365 (class 2604 OID 18753)
-- Name: sales_trip id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_trip ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_id_seq'::regclass);


--
-- TOC entry 3371 (class 2604 OID 18765)
-- Name: sales_trip_detail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);


--
-- TOC entry 3331 (class 2604 OID 18447)
-- Name: setting_document_counter id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.setting_document_counter ALTER COLUMN id SET DEFAULT nextval('public.setting_document_counter_id_seq'::regclass);


--
-- TOC entry 3335 (class 2604 OID 18448)
-- Name: shift id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);


--
-- TOC entry 3340 (class 2604 OID 18449)
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- TOC entry 3269 (class 2604 OID 18450)
-- Name: uom id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);


--
-- TOC entry 3342 (class 2604 OID 18451)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3346 (class 2604 OID 18452)
-- Name: users_experience id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_experience ALTER COLUMN id SET DEFAULT nextval('public.users_experience_id_seq'::regclass);


--
-- TOC entry 3348 (class 2604 OID 18453)
-- Name: users_mutation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_mutation ALTER COLUMN id SET DEFAULT nextval('public.users_mutation_id_seq'::regclass);


--
-- TOC entry 3351 (class 2604 OID 18454)
-- Name: users_shift id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_shift ALTER COLUMN id SET DEFAULT nextval('public.users_shift_id_seq'::regclass);


--
-- TOC entry 3354 (class 2604 OID 18455)
-- Name: voucher id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voucher ALTER COLUMN id SET DEFAULT nextval('public.voucher_id_seq'::regclass);


--
-- TOC entry 3674 (class 0 OID 17914)
-- Dependencies: 202
-- Data for Name: branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.branch VALUES (1, 'HEAD QUARTER', 'Jalan Jakarta no 3', 'Jakarta', 'HQ00', '2022-06-01 19:46:05.452925', NULL, 1);
INSERT INTO public.branch VALUES (13, 'Makassar', 'Makassar', 'Makassar', 'MKS', '2023-01-10 23:08:23', '2023-01-10 23:08:23', 1);
INSERT INTO public.branch VALUES (14, 'Jakarta', 'Jakarta', 'Jakarta', 'JKT', '2023-01-10 23:08:57', '2023-01-10 23:08:57', 1);
INSERT INTO public.branch VALUES (15, 'Bandung', 'Bandung', 'Bandung', 'BDG', '2023-01-10 23:09:17', '2023-01-10 23:09:17', 1);
INSERT INTO public.branch VALUES (16, 'Sidaorjo', 'Sidaorjo', 'Sidaorjo', 'SDA', '2023-01-10 23:09:43', '2023-01-10 23:09:43', 1);
INSERT INTO public.branch VALUES (17, 'Surabaya', 'Surabaya', 'Surabaya', 'SBY', '2023-01-10 23:09:58', '2023-01-10 23:09:58', 1);
INSERT INTO public.branch VALUES (18, 'Solo', 'Solo', 'Solo', 'SLO', '2023-01-10 23:10:18', '2023-01-10 23:10:18', 1);
INSERT INTO public.branch VALUES (19, 'Gresik', 'Gresik', 'Gresik', 'GRS', '2023-01-10 23:10:50', '2023-01-10 23:10:50', 1);
INSERT INTO public.branch VALUES (20, 'Mojokerto', 'Mojokerto', 'Mojokerto', 'MJO', '2023-01-10 23:11:08', '2023-01-10 23:11:08', 1);
INSERT INTO public.branch VALUES (21, 'Kendari', 'Kendari', 'Kendari', 'KDI', '2023-01-10 23:11:30', '2023-01-10 23:11:30', 1);


--
-- TOC entry 3676 (class 0 OID 17924)
-- Dependencies: 204
-- Data for Name: branch_room; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.branch_room VALUES (6, 1, 'HQ - Bunaken 01', '2022-06-01 19:47:46.062696', NULL);
INSERT INTO public.branch_room VALUES (3, 1, 'HQ - Flores 02', '2022-06-01 19:47:46.062696', NULL);


--
-- TOC entry 3765 (class 0 OID 18720)
-- Dependencies: 293
-- Data for Name: branch_shift; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.branch_shift VALUES (1, 1, 1, NULL, '2022-12-30 09:11:18', NULL, '2022-12-30 09:11:18');
INSERT INTO public.branch_shift VALUES (2, 1, 2, NULL, '2022-12-30 09:11:28', NULL, '2022-12-30 09:11:28');


--
-- TOC entry 3777 (class 0 OID 26919)
-- Dependencies: 305
-- Data for Name: calendar; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.calendar VALUES (2, '2023-01-02', '1', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (3, '2023-01-03', '1', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (4, '2023-01-04', '1', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (5, '2023-01-05', '1', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (6, '2023-01-06', '1', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (7, '2023-01-07', '1', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (8, '2023-01-08', '1', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (9, '2023-01-09', '2', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (10, '2023-01-10', '2', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (11, '2023-01-11', '2', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (12, '2023-01-12', '2', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (13, '2023-01-13', '2', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (14, '2023-01-14', '2', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (15, '2023-01-15', '2', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (16, '2023-01-16', '3', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (17, '2023-01-17', '3', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (18, '2023-01-18', '3', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (19, '2023-01-19', '3', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (20, '2023-01-20', '3', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (21, '2023-01-21', '3', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (22, '2023-01-22', '3', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (30, '2023-01-30', '1', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (31, '2023-01-31', '1', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (32, '2023-02-01', '1', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (33, '2023-02-02', '1', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (34, '2023-02-03', '1', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (35, '2023-02-04', '1', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (36, '2023-02-05', '1', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (37, '2023-02-06', '2', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (38, '2023-02-07', '2', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (39, '2023-02-08', '2', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (40, '2023-02-09', '2', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (41, '2023-02-10', '2', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (42, '2023-02-11', '2', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (43, '2023-02-12', '2', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (44, '2023-02-13', '3', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (45, '2023-02-14', '3', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (46, '2023-02-15', '3', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (47, '2023-02-16', '3', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (48, '2023-02-17', '3', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (49, '2023-02-18', '3', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (50, '2023-02-19', '3', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (58, '2023-02-27', '1', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (59, '2023-02-28', '1', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (60, '2023-03-01', '1', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (61, '2023-03-02', '1', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (62, '2023-03-03', '1', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (63, '2023-03-04', '1', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (64, '2023-03-05', '1', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (65, '2023-03-06', '2', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (66, '2023-03-07', '2', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (67, '2023-03-08', '2', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (68, '2023-03-09', '2', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (69, '2023-03-10', '2', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (70, '2023-03-11', '2', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (71, '2023-03-12', '2', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (72, '2023-03-13', '3', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (73, '2023-03-14', '3', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (74, '2023-03-15', '3', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (75, '2023-03-16', '3', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (76, '2023-03-17', '3', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (77, '2023-03-18', '3', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (78, '2023-03-19', '3', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (86, '2023-03-27', '1', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (87, '2023-03-28', '1', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (88, '2023-03-29', '1', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (89, '2023-03-30', '1', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (90, '2023-03-31', '1', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (91, '2023-04-01', '1', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (92, '2023-04-02', '1', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (93, '2023-04-03', '2', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (94, '2023-04-04', '2', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (95, '2023-04-05', '2', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (96, '2023-04-06', '2', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (97, '2023-04-07', '2', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (98, '2023-04-08', '2', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (99, '2023-04-09', '2', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (100, '2023-04-10', '3', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (101, '2023-04-11', '3', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (102, '2023-04-12', '3', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (103, '2023-04-13', '3', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (104, '2023-04-14', '3', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (105, '2023-04-15', '3', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (106, '2023-04-16', '3', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (114, '2023-04-24', '1', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (115, '2023-04-25', '1', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (116, '2023-04-26', '1', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (117, '2023-04-27', '1', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (118, '2023-04-28', '1', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (119, '2023-04-29', '1', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (120, '2023-04-30', '1', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (121, '2023-05-01', '2', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (122, '2023-05-02', '2', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (123, '2023-05-03', '2', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (124, '2023-05-04', '2', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (125, '2023-05-05', '2', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (126, '2023-05-06', '2', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (127, '2023-05-07', '2', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (128, '2023-05-08', '3', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (129, '2023-05-09', '3', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (130, '2023-05-10', '3', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (131, '2023-05-11', '3', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (132, '2023-05-12', '3', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (133, '2023-05-13', '3', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (134, '2023-05-14', '3', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (142, '2023-05-22', '1', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (143, '2023-05-23', '1', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (144, '2023-05-24', '1', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (145, '2023-05-25', '1', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (146, '2023-05-26', '1', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (147, '2023-05-27', '1', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (148, '2023-05-28', '1', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (149, '2023-05-29', '2', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (150, '2023-05-30', '2', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (151, '2023-05-31', '2', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (152, '2023-06-01', '2', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (153, '2023-06-02', '2', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (154, '2023-06-03', '2', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (155, '2023-06-04', '2', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (156, '2023-06-05', '3', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (157, '2023-06-06', '3', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (158, '2023-06-07', '3', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (159, '2023-06-08', '3', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (160, '2023-06-09', '3', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (161, '2023-06-10', '3', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (162, '2023-06-11', '3', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (170, '2023-06-19', '1', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (171, '2023-06-20', '1', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (172, '2023-06-21', '1', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (173, '2023-06-22', '1', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (174, '2023-06-23', '1', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (175, '2023-06-24', '1', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (176, '2023-06-25', '1', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (177, '2023-06-26', '2', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (178, '2023-06-27', '2', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (179, '2023-06-28', '2', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (180, '2023-06-29', '2', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (181, '2023-06-30', '2', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (182, '2023-07-01', '2', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (183, '2023-07-02', '2', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (184, '2023-07-03', '3', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (185, '2023-07-04', '3', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (186, '2023-07-05', '3', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (187, '2023-07-06', '3', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (188, '2023-07-07', '3', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (189, '2023-07-08', '3', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (190, '2023-07-09', '3', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (198, '2023-07-17', '1', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (199, '2023-07-18', '1', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (200, '2023-07-19', '1', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (201, '2023-07-20', '1', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (202, '2023-07-21', '1', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (203, '2023-07-22', '1', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (204, '2023-07-23', '1', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (205, '2023-07-24', '2', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (206, '2023-07-25', '2', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (207, '2023-07-26', '2', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (208, '2023-07-27', '2', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (209, '2023-07-28', '2', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (210, '2023-07-29', '2', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (211, '2023-07-30', '2', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (212, '2023-07-31', '3', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (213, '2023-08-01', '3', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (214, '2023-08-02', '3', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (215, '2023-08-03', '3', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (216, '2023-08-04', '3', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (217, '2023-08-05', '3', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (218, '2023-08-06', '3', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (226, '2023-08-14', '1', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (227, '2023-08-15', '1', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (228, '2023-08-16', '1', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (229, '2023-08-17', '1', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (230, '2023-08-18', '1', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (231, '2023-08-19', '1', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (232, '2023-08-20', '1', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (233, '2023-08-21', '2', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (234, '2023-08-22', '2', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (235, '2023-08-23', '2', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (236, '2023-08-24', '2', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (237, '2023-08-25', '2', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (238, '2023-08-26', '2', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (239, '2023-08-27', '2', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (240, '2023-08-28', '3', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (241, '2023-08-29', '3', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (242, '2023-08-30', '3', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (243, '2023-08-31', '3', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (244, '2023-09-01', '3', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (245, '2023-09-02', '3', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (246, '2023-09-03', '3', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (254, '2023-09-11', '1', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (255, '2023-09-12', '1', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (256, '2023-09-13', '1', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (257, '2023-09-14', '1', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (258, '2023-09-15', '1', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (259, '2023-09-16', '1', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (260, '2023-09-17', '1', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (261, '2023-09-18', '2', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (262, '2023-09-19', '2', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (263, '2023-09-20', '2', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (264, '2023-09-21', '2', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (265, '2023-09-22', '2', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (266, '2023-09-23', '2', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (267, '2023-09-24', '2', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (268, '2023-09-25', '3', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (269, '2023-09-26', '3', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (270, '2023-09-27', '3', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (271, '2023-09-28', '3', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (272, '2023-09-29', '3', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (273, '2023-09-30', '3', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (274, '2023-10-01', '3', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (282, '2023-10-09', '1', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (283, '2023-10-10', '1', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (284, '2023-10-11', '1', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (285, '2023-10-12', '1', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (286, '2023-10-13', '1', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (287, '2023-10-14', '1', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (288, '2023-10-15', '1', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (289, '2023-10-16', '2', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (290, '2023-10-17', '2', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (291, '2023-10-18', '2', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (292, '2023-10-19', '2', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (293, '2023-10-20', '2', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (294, '2023-10-21', '2', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (295, '2023-10-22', '2', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (296, '2023-10-23', '3', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (297, '2023-10-24', '3', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (298, '2023-10-25', '3', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (299, '2023-10-26', '3', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (300, '2023-10-27', '3', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (301, '2023-10-28', '3', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (302, '2023-10-29', '3', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (310, '2023-11-06', '1', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (311, '2023-11-07', '1', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (312, '2023-11-08', '1', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (313, '2023-11-09', '1', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (314, '2023-11-10', '1', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (315, '2023-11-11', '1', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (316, '2023-11-12', '1', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (317, '2023-11-13', '2', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (318, '2023-11-14', '2', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (319, '2023-11-15', '2', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (320, '2023-11-16', '2', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (321, '2023-11-17', '2', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (322, '2023-11-18', '2', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (323, '2023-11-19', '2', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (324, '2023-11-20', '3', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (325, '2023-11-21', '3', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (326, '2023-11-22', '3', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (327, '2023-11-23', '3', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (328, '2023-11-24', '3', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (329, '2023-11-25', '3', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (330, '2023-11-26', '3', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (338, '2023-12-04', '1', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (339, '2023-12-05', '1', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (340, '2023-12-06', '1', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (341, '2023-12-07', '1', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (342, '2023-12-08', '1', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (343, '2023-12-09', '1', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (344, '2023-12-10', '1', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (345, '2023-12-11', '2', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (346, '2023-12-12', '2', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (347, '2023-12-13', '2', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (348, '2023-12-14', '2', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (349, '2023-12-15', '2', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (350, '2023-12-16', '2', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (351, '2023-12-17', '2', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (352, '2023-12-18', '3', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (353, '2023-12-19', '3', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (354, '2023-12-20', '3', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (355, '2023-12-21', '3', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (356, '2023-12-22', '3', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (357, '2023-12-23', '3', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (358, '2023-12-24', '3', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (366, '2024-01-01', '1', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (367, '2024-01-02', '1', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (368, '2024-01-03', '1', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (369, '2024-01-04', '1', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (370, '2024-01-05', '1', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (371, '2024-01-06', '1', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (372, '2024-01-07', '1', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (373, '2024-01-08', '2', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (374, '2024-01-09', '2', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (375, '2024-01-10', '2', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (376, '2024-01-11', '2', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (377, '2024-01-12', '2', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (378, '2024-01-13', '2', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (379, '2024-01-14', '2', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (380, '2024-01-15', '3', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (381, '2024-01-16', '3', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (382, '2024-01-17', '3', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (383, '2024-01-18', '3', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (384, '2024-01-19', '3', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (385, '2024-01-20', '3', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (386, '2024-01-21', '3', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (394, '2024-01-29', '1', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (395, '2024-01-30', '1', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (396, '2024-01-31', '1', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (397, '2024-02-01', '1', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (398, '2024-02-02', '1', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (399, '2024-02-03', '1', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (400, '2024-02-04', '1', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (401, '2024-02-05', '2', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (402, '2024-02-06', '2', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (403, '2024-02-07', '2', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (404, '2024-02-08', '2', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (405, '2024-02-09', '2', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (406, '2024-02-10', '2', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (407, '2024-02-11', '2', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (408, '2024-02-12', '3', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (409, '2024-02-13', '3', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (410, '2024-02-14', '3', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (411, '2024-02-15', '3', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (412, '2024-02-16', '3', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (413, '2024-02-17', '3', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (414, '2024-02-18', '3', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (422, '2024-02-26', '1', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (423, '2024-02-27', '1', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (424, '2024-02-28', '1', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (425, '2024-02-29', '1', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (426, '2024-03-01', '1', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (427, '2024-03-02', '1', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (428, '2024-03-03', '1', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (429, '2024-03-04', '2', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (430, '2024-03-05', '2', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (431, '2024-03-06', '2', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (432, '2024-03-07', '2', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (433, '2024-03-08', '2', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (434, '2024-03-09', '2', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (435, '2024-03-10', '2', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (436, '2024-03-11', '3', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (437, '2024-03-12', '3', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (438, '2024-03-13', '3', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (439, '2024-03-14', '3', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (440, '2024-03-15', '3', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (441, '2024-03-16', '3', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (442, '2024-03-17', '3', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (450, '2024-03-25', '1', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (451, '2024-03-26', '1', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (452, '2024-03-27', '1', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (453, '2024-03-28', '1', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (454, '2024-03-29', '1', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (455, '2024-03-30', '1', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (456, '2024-03-31', '1', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (457, '2024-04-01', '2', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (458, '2024-04-02', '2', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (459, '2024-04-03', '2', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (460, '2024-04-04', '2', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (461, '2024-04-05', '2', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (462, '2024-04-06', '2', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (463, '2024-04-07', '2', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (464, '2024-04-08', '3', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (465, '2024-04-09', '3', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (466, '2024-04-10', '3', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (467, '2024-04-11', '3', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (468, '2024-04-12', '3', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (469, '2024-04-13', '3', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (470, '2024-04-14', '3', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (478, '2024-04-22', '1', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (479, '2024-04-23', '1', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (480, '2024-04-24', '1', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (481, '2024-04-25', '1', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (482, '2024-04-26', '1', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (483, '2024-04-27', '1', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (484, '2024-04-28', '1', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (485, '2024-04-29', '2', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (486, '2024-04-30', '2', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (487, '2024-05-01', '2', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (488, '2024-05-02', '2', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (489, '2024-05-03', '2', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (490, '2024-05-04', '2', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (491, '2024-05-05', '2', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (492, '2024-05-06', '3', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (493, '2024-05-07', '3', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (494, '2024-05-08', '3', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (495, '2024-05-09', '3', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (496, '2024-05-10', '3', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (497, '2024-05-11', '3', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (498, '2024-05-12', '3', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (506, '2024-05-20', '1', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (507, '2024-05-21', '1', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (508, '2024-05-22', '1', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (509, '2024-05-23', '1', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (510, '2024-05-24', '1', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (511, '2024-05-25', '1', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (512, '2024-05-26', '1', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (513, '2024-05-27', '2', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (514, '2024-05-28', '2', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (515, '2024-05-29', '2', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (516, '2024-05-30', '2', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (517, '2024-05-31', '2', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (518, '2024-06-01', '2', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (519, '2024-06-02', '2', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (520, '2024-06-03', '3', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (521, '2024-06-04', '3', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (522, '2024-06-05', '3', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (523, '2024-06-06', '3', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (524, '2024-06-07', '3', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (525, '2024-06-08', '3', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (526, '2024-06-09', '3', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (534, '2024-06-17', '1', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (535, '2024-06-18', '1', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (536, '2024-06-19', '1', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (537, '2024-06-20', '1', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (538, '2024-06-21', '1', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (539, '2024-06-22', '1', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (540, '2024-06-23', '1', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (541, '2024-06-24', '2', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (542, '2024-06-25', '2', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (543, '2024-06-26', '2', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (544, '2024-06-27', '2', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (545, '2024-06-28', '2', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (546, '2024-06-29', '2', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (547, '2024-06-30', '2', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (548, '2024-07-01', '3', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (549, '2024-07-02', '3', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (550, '2024-07-03', '3', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (551, '2024-07-04', '3', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (552, '2024-07-05', '3', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (553, '2024-07-06', '3', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (554, '2024-07-07', '3', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (562, '2024-07-15', '1', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (563, '2024-07-16', '1', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (564, '2024-07-17', '1', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (565, '2024-07-18', '1', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (566, '2024-07-19', '1', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (567, '2024-07-20', '1', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (568, '2024-07-21', '1', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (569, '2024-07-22', '2', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (570, '2024-07-23', '2', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (571, '2024-07-24', '2', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (572, '2024-07-25', '2', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (573, '2024-07-26', '2', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (574, '2024-07-27', '2', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (575, '2024-07-28', '2', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (576, '2024-07-29', '3', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (577, '2024-07-30', '3', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (578, '2024-07-31', '3', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (579, '2024-08-01', '3', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (580, '2024-08-02', '3', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (581, '2024-08-03', '3', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (582, '2024-08-04', '3', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (590, '2024-08-12', '1', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (591, '2024-08-13', '1', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (592, '2024-08-14', '1', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (593, '2024-08-15', '1', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (594, '2024-08-16', '1', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (595, '2024-08-17', '1', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (596, '2024-08-18', '1', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (597, '2024-08-19', '2', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (598, '2024-08-20', '2', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (599, '2024-08-21', '2', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (600, '2024-08-22', '2', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (601, '2024-08-23', '2', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (602, '2024-08-24', '2', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (603, '2024-08-25', '2', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (604, '2024-08-26', '3', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (605, '2024-08-27', '3', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (606, '2024-08-28', '3', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (607, '2024-08-29', '3', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (608, '2024-08-30', '3', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (609, '2024-08-31', '3', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (610, '2024-09-01', '3', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (618, '2024-09-09', '1', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (619, '2024-09-10', '1', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (620, '2024-09-11', '1', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (621, '2024-09-12', '1', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (622, '2024-09-13', '1', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (623, '2024-09-14', '1', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (624, '2024-09-15', '1', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (625, '2024-09-16', '2', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (626, '2024-09-17', '2', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (627, '2024-09-18', '2', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (628, '2024-09-19', '2', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (629, '2024-09-20', '2', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (630, '2024-09-21', '2', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (631, '2024-09-22', '2', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (632, '2024-09-23', '3', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (633, '2024-09-24', '3', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (634, '2024-09-25', '3', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (635, '2024-09-26', '3', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (636, '2024-09-27', '3', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (637, '2024-09-28', '3', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (638, '2024-09-29', '3', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (646, '2024-10-07', '1', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (647, '2024-10-08', '1', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (648, '2024-10-09', '1', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (649, '2024-10-10', '1', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (650, '2024-10-11', '1', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (651, '2024-10-12', '1', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (652, '2024-10-13', '1', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (653, '2024-10-14', '2', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (654, '2024-10-15', '2', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (655, '2024-10-16', '2', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (656, '2024-10-17', '2', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (657, '2024-10-18', '2', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (658, '2024-10-19', '2', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (659, '2024-10-20', '2', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (660, '2024-10-21', '3', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (661, '2024-10-22', '3', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (662, '2024-10-23', '3', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (663, '2024-10-24', '3', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (664, '2024-10-25', '3', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (665, '2024-10-26', '3', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (666, '2024-10-27', '3', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (674, '2024-11-04', '1', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (675, '2024-11-05', '1', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (676, '2024-11-06', '1', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (677, '2024-11-07', '1', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (678, '2024-11-08', '1', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (679, '2024-11-09', '1', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (680, '2024-11-10', '1', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (681, '2024-11-11', '2', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (682, '2024-11-12', '2', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (683, '2024-11-13', '2', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (684, '2024-11-14', '2', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (685, '2024-11-15', '2', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (686, '2024-11-16', '2', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (687, '2024-11-17', '2', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (688, '2024-11-18', '3', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (689, '2024-11-19', '3', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (690, '2024-11-20', '3', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (691, '2024-11-21', '3', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (692, '2024-11-22', '3', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (693, '2024-11-23', '3', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (694, '2024-11-24', '3', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (702, '2024-12-02', '1', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (703, '2024-12-03', '1', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (704, '2024-12-04', '1', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (705, '2024-12-05', '1', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (706, '2024-12-06', '1', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (707, '2024-12-07', '1', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (708, '2024-12-08', '1', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (709, '2024-12-09', '2', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (710, '2024-12-10', '2', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (711, '2024-12-11', '2', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (712, '2024-12-12', '2', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (713, '2024-12-13', '2', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (714, '2024-12-14', '2', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (715, '2024-12-15', '2', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (716, '2024-12-16', '3', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (717, '2024-12-17', '3', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (718, '2024-12-18', '3', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (719, '2024-12-19', '3', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (720, '2024-12-20', '3', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (721, '2024-12-21', '3', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (722, '2024-12-22', '3', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (730, '2024-12-30', '1', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (731, '2024-12-31', '1', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (732, '2025-01-01', '1', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (733, '2025-01-02', '1', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (734, '2025-01-03', '1', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (735, '2025-01-04', '1', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (736, '2025-01-05', '1', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (737, '2025-01-06', '2', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (738, '2025-01-07', '2', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (739, '2025-01-08', '2', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (740, '2025-01-09', '2', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (741, '2025-01-10', '2', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (742, '2025-01-11', '2', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (743, '2025-01-12', '2', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (744, '2025-01-13', '3', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (745, '2025-01-14', '3', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (746, '2025-01-15', '3', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (747, '2025-01-16', '3', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (748, '2025-01-17', '3', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (749, '2025-01-18', '3', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (750, '2025-01-19', '3', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (758, '2025-01-27', '1', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (759, '2025-01-28', '1', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (760, '2025-01-29', '1', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (761, '2025-01-30', '1', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (762, '2025-01-31', '1', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (763, '2025-02-01', '1', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (764, '2025-02-02', '1', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (765, '2025-02-03', '2', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (766, '2025-02-04', '2', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (767, '2025-02-05', '2', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (768, '2025-02-06', '2', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (769, '2025-02-07', '2', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (770, '2025-02-08', '2', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (771, '2025-02-09', '2', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (772, '2025-02-10', '3', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (773, '2025-02-11', '3', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (774, '2025-02-12', '3', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (775, '2025-02-13', '3', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (776, '2025-02-14', '3', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (777, '2025-02-15', '3', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (778, '2025-02-16', '3', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (786, '2025-02-24', '1', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (787, '2025-02-25', '1', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (788, '2025-02-26', '1', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (789, '2025-02-27', '1', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (790, '2025-02-28', '1', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (791, '2025-03-01', '1', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (792, '2025-03-02', '1', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (793, '2025-03-03', '2', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (794, '2025-03-04', '2', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (795, '2025-03-05', '2', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (796, '2025-03-06', '2', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (797, '2025-03-07', '2', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (798, '2025-03-08', '2', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (799, '2025-03-09', '2', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (800, '2025-03-10', '3', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (801, '2025-03-11', '3', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (802, '2025-03-12', '3', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (803, '2025-03-13', '3', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (804, '2025-03-14', '3', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (805, '2025-03-15', '3', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (806, '2025-03-16', '3', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (814, '2025-03-24', '1', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (815, '2025-03-25', '1', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (816, '2025-03-26', '1', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (817, '2025-03-27', '1', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (818, '2025-03-28', '1', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (819, '2025-03-29', '1', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (820, '2025-03-30', '1', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (821, '2025-03-31', '2', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (822, '2025-04-01', '2', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (823, '2025-04-02', '2', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (824, '2025-04-03', '2', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (825, '2025-04-04', '2', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (826, '2025-04-05', '2', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (827, '2025-04-06', '2', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (828, '2025-04-07', '3', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (829, '2025-04-08', '3', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (830, '2025-04-09', '3', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (831, '2025-04-10', '3', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (832, '2025-04-11', '3', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (833, '2025-04-12', '3', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (834, '2025-04-13', '3', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (842, '2025-04-21', '1', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (843, '2025-04-22', '1', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (844, '2025-04-23', '1', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (845, '2025-04-24', '1', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (846, '2025-04-25', '1', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (847, '2025-04-26', '1', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (848, '2025-04-27', '1', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (849, '2025-04-28', '2', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (850, '2025-04-29', '2', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (851, '2025-04-30', '2', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (852, '2025-05-01', '2', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (853, '2025-05-02', '2', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (854, '2025-05-03', '2', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (855, '2025-05-04', '2', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (856, '2025-05-05', '3', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (857, '2025-05-06', '3', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (858, '2025-05-07', '3', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (859, '2025-05-08', '3', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (860, '2025-05-09', '3', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (861, '2025-05-10', '3', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (862, '2025-05-11', '3', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (870, '2025-05-19', '1', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (871, '2025-05-20', '1', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (872, '2025-05-21', '1', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (873, '2025-05-22', '1', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (874, '2025-05-23', '1', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (875, '2025-05-24', '1', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (876, '2025-05-25', '1', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (877, '2025-05-26', '2', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (878, '2025-05-27', '2', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (879, '2025-05-28', '2', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (880, '2025-05-29', '2', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (881, '2025-05-30', '2', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (882, '2025-05-31', '2', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (883, '2025-06-01', '2', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (884, '2025-06-02', '3', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (885, '2025-06-03', '3', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (886, '2025-06-04', '3', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (887, '2025-06-05', '3', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (888, '2025-06-06', '3', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (889, '2025-06-07', '3', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (890, '2025-06-08', '3', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (898, '2025-06-16', '1', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (899, '2025-06-17', '1', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (900, '2025-06-18', '1', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (901, '2025-06-19', '1', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (902, '2025-06-20', '1', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (903, '2025-06-21', '1', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (904, '2025-06-22', '1', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (905, '2025-06-23', '2', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (906, '2025-06-24', '2', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (907, '2025-06-25', '2', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (908, '2025-06-26', '2', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (909, '2025-06-27', '2', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (910, '2025-06-28', '2', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (911, '2025-06-29', '2', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (912, '2025-06-30', '3', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (913, '2025-07-01', '3', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (914, '2025-07-02', '3', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (915, '2025-07-03', '3', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (916, '2025-07-04', '3', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (917, '2025-07-05', '3', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (918, '2025-07-06', '3', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (926, '2025-07-14', '1', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (927, '2025-07-15', '1', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (928, '2025-07-16', '1', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (929, '2025-07-17', '1', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (930, '2025-07-18', '1', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (931, '2025-07-19', '1', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (932, '2025-07-20', '1', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (933, '2025-07-21', '2', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (934, '2025-07-22', '2', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (935, '2025-07-23', '2', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (936, '2025-07-24', '2', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (937, '2025-07-25', '2', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (938, '2025-07-26', '2', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (939, '2025-07-27', '2', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (940, '2025-07-28', '3', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (941, '2025-07-29', '3', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (942, '2025-07-30', '3', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (943, '2025-07-31', '3', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (944, '2025-08-01', '3', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (945, '2025-08-02', '3', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (946, '2025-08-03', '3', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (954, '2025-08-11', '1', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (955, '2025-08-12', '1', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (956, '2025-08-13', '1', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (957, '2025-08-14', '1', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (958, '2025-08-15', '1', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (959, '2025-08-16', '1', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (960, '2025-08-17', '1', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (961, '2025-08-18', '2', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (962, '2025-08-19', '2', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (963, '2025-08-20', '2', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (964, '2025-08-21', '2', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (965, '2025-08-22', '2', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (966, '2025-08-23', '2', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (967, '2025-08-24', '2', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (968, '2025-08-25', '3', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (969, '2025-08-26', '3', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (970, '2025-08-27', '3', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (971, '2025-08-28', '3', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (972, '2025-08-29', '3', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (973, '2025-08-30', '3', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (974, '2025-08-31', '3', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (982, '2025-09-08', '1', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (983, '2025-09-09', '1', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (984, '2025-09-10', '1', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (985, '2025-09-11', '1', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (986, '2025-09-12', '1', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (987, '2025-09-13', '1', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (988, '2025-09-14', '1', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (989, '2025-09-15', '2', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (990, '2025-09-16', '2', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (991, '2025-09-17', '2', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (992, '2025-09-18', '2', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (993, '2025-09-19', '2', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (994, '2025-09-20', '2', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (995, '2025-09-21', '2', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (996, '2025-09-22', '3', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (997, '2025-09-23', '3', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (998, '2025-09-24', '3', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (999, '2025-09-25', '3', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1000, '2025-09-26', '3', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1001, '2025-09-27', '3', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1002, '2025-09-28', '3', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1010, '2025-10-06', '1', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1011, '2025-10-07', '1', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1012, '2025-10-08', '1', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1013, '2025-10-09', '1', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1014, '2025-10-10', '1', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1015, '2025-10-11', '1', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1016, '2025-10-12', '1', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1017, '2025-10-13', '2', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1018, '2025-10-14', '2', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1019, '2025-10-15', '2', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1020, '2025-10-16', '2', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1021, '2025-10-17', '2', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1022, '2025-10-18', '2', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1023, '2025-10-19', '2', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1024, '2025-10-20', '3', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1025, '2025-10-21', '3', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1026, '2025-10-22', '3', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1027, '2025-10-23', '3', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1028, '2025-10-24', '3', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1029, '2025-10-25', '3', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1030, '2025-10-26', '3', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1038, '2025-11-03', '1', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1039, '2025-11-04', '1', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1040, '2025-11-05', '1', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1041, '2025-11-06', '1', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1042, '2025-11-07', '1', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1043, '2025-11-08', '1', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1044, '2025-11-09', '1', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1045, '2025-11-10', '2', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1046, '2025-11-11', '2', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1047, '2025-11-12', '2', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1048, '2025-11-13', '2', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1049, '2025-11-14', '2', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1050, '2025-11-15', '2', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1051, '2025-11-16', '2', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1052, '2025-11-17', '3', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1053, '2025-11-18', '3', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1054, '2025-11-19', '3', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1055, '2025-11-20', '3', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1056, '2025-11-21', '3', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1057, '2025-11-22', '3', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1058, '2025-11-23', '3', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1066, '2025-12-01', '1', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1067, '2025-12-02', '1', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1068, '2025-12-03', '1', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1069, '2025-12-04', '1', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1070, '2025-12-05', '1', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1071, '2025-12-06', '1', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1072, '2025-12-07', '1', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1073, '2025-12-08', '2', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1074, '2025-12-09', '2', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1075, '2025-12-10', '2', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1076, '2025-12-11', '2', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1077, '2025-12-12', '2', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1078, '2025-12-13', '2', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1079, '2025-12-14', '2', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1080, '2025-12-15', '3', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1081, '2025-12-16', '3', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1082, '2025-12-17', '3', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1083, '2025-12-18', '3', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1084, '2025-12-19', '3', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1085, '2025-12-20', '3', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1086, '2025-12-21', '3', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1094, '2025-12-29', '1', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1095, '2025-12-30', '1', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1096, '2025-12-31', '1', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1, '2023-01-01', '4', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (23, '2023-01-23', '4', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (24, '2023-01-24', '4', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (25, '2023-01-25', '4', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (26, '2023-01-26', '4', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (27, '2023-01-27', '4', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (28, '2023-01-28', '4', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (29, '2023-01-29', '4', '202301', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (51, '2023-02-20', '4', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (52, '2023-02-21', '4', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (53, '2023-02-22', '4', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (54, '2023-02-23', '4', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (55, '2023-02-24', '4', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (56, '2023-02-25', '4', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (57, '2023-02-26', '4', '202302', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (79, '2023-03-20', '4', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (80, '2023-03-21', '4', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (81, '2023-03-22', '4', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (82, '2023-03-23', '4', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (83, '2023-03-24', '4', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (84, '2023-03-25', '4', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (85, '2023-03-26', '4', '202303', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (107, '2023-04-17', '4', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (108, '2023-04-18', '4', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (109, '2023-04-19', '4', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (110, '2023-04-20', '4', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (111, '2023-04-21', '4', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (112, '2023-04-22', '4', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (113, '2023-04-23', '4', '202304', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (135, '2023-05-15', '4', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (136, '2023-05-16', '4', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (137, '2023-05-17', '4', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (138, '2023-05-18', '4', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (139, '2023-05-19', '4', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (140, '2023-05-20', '4', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (141, '2023-05-21', '4', '202305', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (163, '2023-06-12', '4', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (164, '2023-06-13', '4', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (165, '2023-06-14', '4', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (166, '2023-06-15', '4', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (167, '2023-06-16', '4', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (168, '2023-06-17', '4', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (169, '2023-06-18', '4', '202306', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (191, '2023-07-10', '4', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (192, '2023-07-11', '4', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (193, '2023-07-12', '4', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (194, '2023-07-13', '4', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (195, '2023-07-14', '4', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (196, '2023-07-15', '4', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (197, '2023-07-16', '4', '202307', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (219, '2023-08-07', '4', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (220, '2023-08-08', '4', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (221, '2023-08-09', '4', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (222, '2023-08-10', '4', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (223, '2023-08-11', '4', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (224, '2023-08-12', '4', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (225, '2023-08-13', '4', '202308', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (247, '2023-09-04', '4', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (248, '2023-09-05', '4', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (249, '2023-09-06', '4', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (250, '2023-09-07', '4', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (251, '2023-09-08', '4', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (252, '2023-09-09', '4', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (253, '2023-09-10', '4', '202309', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (275, '2023-10-02', '4', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (276, '2023-10-03', '4', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (277, '2023-10-04', '4', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (278, '2023-10-05', '4', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (279, '2023-10-06', '4', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (280, '2023-10-07', '4', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (281, '2023-10-08', '4', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (303, '2023-10-30', '4', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (304, '2023-10-31', '4', '202310', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (305, '2023-11-01', '4', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (306, '2023-11-02', '4', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (307, '2023-11-03', '4', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (308, '2023-11-04', '4', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (309, '2023-11-05', '4', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (331, '2023-11-27', '4', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (332, '2023-11-28', '4', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (333, '2023-11-29', '4', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (334, '2023-11-30', '4', '202311', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (335, '2023-12-01', '4', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (336, '2023-12-02', '4', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (337, '2023-12-03', '4', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (359, '2023-12-25', '4', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (360, '2023-12-26', '4', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (361, '2023-12-27', '4', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (362, '2023-12-28', '4', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (363, '2023-12-29', '4', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (364, '2023-12-30', '4', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (365, '2023-12-31', '4', '202312', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (387, '2024-01-22', '4', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (388, '2024-01-23', '4', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (389, '2024-01-24', '4', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (390, '2024-01-25', '4', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (391, '2024-01-26', '4', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (392, '2024-01-27', '4', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (393, '2024-01-28', '4', '202401', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (415, '2024-02-19', '4', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (416, '2024-02-20', '4', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (417, '2024-02-21', '4', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (418, '2024-02-22', '4', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (419, '2024-02-23', '4', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (420, '2024-02-24', '4', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (421, '2024-02-25', '4', '202402', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (443, '2024-03-18', '4', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (444, '2024-03-19', '4', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (445, '2024-03-20', '4', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (446, '2024-03-21', '4', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (447, '2024-03-22', '4', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (448, '2024-03-23', '4', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (449, '2024-03-24', '4', '202403', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (471, '2024-04-15', '4', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (472, '2024-04-16', '4', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (473, '2024-04-17', '4', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (474, '2024-04-18', '4', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (475, '2024-04-19', '4', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (476, '2024-04-20', '4', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (477, '2024-04-21', '4', '202404', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (499, '2024-05-13', '4', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (500, '2024-05-14', '4', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (501, '2024-05-15', '4', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (502, '2024-05-16', '4', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (503, '2024-05-17', '4', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (504, '2024-05-18', '4', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (505, '2024-05-19', '4', '202405', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (527, '2024-06-10', '4', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (528, '2024-06-11', '4', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (529, '2024-06-12', '4', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (530, '2024-06-13', '4', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (531, '2024-06-14', '4', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (532, '2024-06-15', '4', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (533, '2024-06-16', '4', '202406', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (555, '2024-07-08', '4', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (556, '2024-07-09', '4', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (557, '2024-07-10', '4', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (558, '2024-07-11', '4', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (559, '2024-07-12', '4', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (560, '2024-07-13', '4', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (561, '2024-07-14', '4', '202407', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (583, '2024-08-05', '4', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (584, '2024-08-06', '4', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (585, '2024-08-07', '4', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (586, '2024-08-08', '4', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (587, '2024-08-09', '4', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (588, '2024-08-10', '4', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (589, '2024-08-11', '4', '202408', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (611, '2024-09-02', '4', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (612, '2024-09-03', '4', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (613, '2024-09-04', '4', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (614, '2024-09-05', '4', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (615, '2024-09-06', '4', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (616, '2024-09-07', '4', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (617, '2024-09-08', '4', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (639, '2024-09-30', '4', '202409', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (640, '2024-10-01', '4', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (641, '2024-10-02', '4', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (642, '2024-10-03', '4', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (643, '2024-10-04', '4', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (644, '2024-10-05', '4', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (645, '2024-10-06', '4', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (667, '2024-10-28', '4', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (668, '2024-10-29', '4', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (669, '2024-10-30', '4', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (670, '2024-10-31', '4', '202410', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (671, '2024-11-01', '4', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (672, '2024-11-02', '4', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (673, '2024-11-03', '4', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (695, '2024-11-25', '4', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (696, '2024-11-26', '4', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (697, '2024-11-27', '4', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (698, '2024-11-28', '4', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (699, '2024-11-29', '4', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (700, '2024-11-30', '4', '202411', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (701, '2024-12-01', '4', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (723, '2024-12-23', '4', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (724, '2024-12-24', '4', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (725, '2024-12-25', '4', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (726, '2024-12-26', '4', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (727, '2024-12-27', '4', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (728, '2024-12-28', '4', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (729, '2024-12-29', '4', '202412', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (751, '2025-01-20', '4', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (752, '2025-01-21', '4', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (753, '2025-01-22', '4', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (754, '2025-01-23', '4', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (755, '2025-01-24', '4', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (756, '2025-01-25', '4', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (757, '2025-01-26', '4', '202501', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (779, '2025-02-17', '4', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (780, '2025-02-18', '4', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (781, '2025-02-19', '4', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (782, '2025-02-20', '4', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (783, '2025-02-21', '4', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (784, '2025-02-22', '4', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (785, '2025-02-23', '4', '202502', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (807, '2025-03-17', '4', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (808, '2025-03-18', '4', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (809, '2025-03-19', '4', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (810, '2025-03-20', '4', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (811, '2025-03-21', '4', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (812, '2025-03-22', '4', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (813, '2025-03-23', '4', '202503', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (835, '2025-04-14', '4', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (836, '2025-04-15', '4', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (837, '2025-04-16', '4', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (838, '2025-04-17', '4', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (839, '2025-04-18', '4', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (840, '2025-04-19', '4', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (841, '2025-04-20', '4', '202504', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (863, '2025-05-12', '4', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (864, '2025-05-13', '4', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (865, '2025-05-14', '4', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (866, '2025-05-15', '4', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (867, '2025-05-16', '4', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (868, '2025-05-17', '4', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (869, '2025-05-18', '4', '202505', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (891, '2025-06-09', '4', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (892, '2025-06-10', '4', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (893, '2025-06-11', '4', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (894, '2025-06-12', '4', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (895, '2025-06-13', '4', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (896, '2025-06-14', '4', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (897, '2025-06-15', '4', '202506', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (919, '2025-07-07', '4', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (920, '2025-07-08', '4', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (921, '2025-07-09', '4', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (922, '2025-07-10', '4', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (923, '2025-07-11', '4', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (924, '2025-07-12', '4', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (925, '2025-07-13', '4', '202507', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (947, '2025-08-04', '4', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (948, '2025-08-05', '4', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (949, '2025-08-06', '4', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (950, '2025-08-07', '4', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (951, '2025-08-08', '4', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (952, '2025-08-09', '4', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (953, '2025-08-10', '4', '202508', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (975, '2025-09-01', '4', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (976, '2025-09-02', '4', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (977, '2025-09-03', '4', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (978, '2025-09-04', '4', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (979, '2025-09-05', '4', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (980, '2025-09-06', '4', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (981, '2025-09-07', '4', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1003, '2025-09-29', '4', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1004, '2025-09-30', '4', '202509', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1005, '2025-10-01', '4', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1006, '2025-10-02', '4', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1007, '2025-10-03', '4', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1008, '2025-10-04', '4', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1009, '2025-10-05', '4', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1031, '2025-10-27', '4', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1032, '2025-10-28', '4', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1033, '2025-10-29', '4', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1034, '2025-10-30', '4', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1035, '2025-10-31', '4', '202510', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1036, '2025-11-01', '4', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1037, '2025-11-02', '4', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1059, '2025-11-24', '4', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1060, '2025-11-25', '4', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1061, '2025-11-26', '4', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1062, '2025-11-27', '4', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1063, '2025-11-28', '4', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1064, '2025-11-29', '4', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1065, '2025-11-30', '4', '202511', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1087, '2025-12-22', '4', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1088, '2025-12-23', '4', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1089, '2025-12-24', '4', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1090, '2025-12-25', '4', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1091, '2025-12-26', '4', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1092, '2025-12-27', '4', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');
INSERT INTO public.calendar VALUES (1093, '2025-12-28', '4', '202512', NULL, NULL, 1, '2023-01-08 05:45:49.093234');


--
-- TOC entry 3678 (class 0 OID 17933)
-- Dependencies: 206
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.company VALUES (1, 'Lapak Kreatif Lamogan', 'Lamongan', 'Lamongan', 'admin@lapakkreatif.com', '085746879090', '6d4c83f6b695389b860d79e975e13751.png', '2023-01-10 21:52:39', '2022-08-30 22:06:56.025994');


--
-- TOC entry 3680 (class 0 OID 17942)
-- Dependencies: 208
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.customers VALUES (1, 'UMUM', 'Jalan Umum', '6285746879090', 1, '1', 1, '2022-06-02 20:38:02.11776', '2022-12-30 19:12:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 3775 (class 0 OID 18774)
-- Dependencies: 303
-- Data for Name: customers_registration; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.customers_registration VALUES (1, 'test', 'test', 'test', 1, 'test', 1, '2023-01-08 21:02:50.995066', NULL, 1, 'test', 'test', 1000, NULL, NULL, 'test', '088', '0998', '3213123', '312312', '3213', NULL, NULL, NULL, NULL, 0, NULL);
INSERT INTO public.customers_registration VALUES (2, '1', '1', NULL, 1, '', 1, '2023-01-08 23:14:37.074191', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL);
INSERT INTO public.customers_registration VALUES (3, 'Test Inpu', 'Tess Alamat', '', 1, '', 1, '2023-01-08 23:23:59.560097', NULL, 1, '', 'Test', 1000, '112.4260812', '-7.1326306', '', '', '', '', '', '', '', '', '', '', 0, 'PicRegForm_1_20230108112046.jpg');
INSERT INTO public.customers_registration VALUES (4, 'jshhs', 'jjhhd', '', 1, '', 1, '2023-01-08 23:25:02.563927', NULL, 1, '', '', 10, '112.4260804', '-7.1326334', '', '', '', '', '', '', '', '', '', '', 0, 'PicRegForm_1_20230108112431.jpg');
INSERT INTO public.customers_registration VALUES (5, 'Maju Lancar Jaya', 'Jalan Kerapuh No 23', '08574663', 1, '', 1, '2023-01-08 23:29:38.309959', NULL, 1, 'Lamongan', 'test', 4500, '112.4260746', '-7.1326316', 'testenail', '08574663', '08362527', '4544222', '112223', 'Bu Nando', 'Small', 'Large', 'kasir', 'II', 0, 'PicRegForm_1_20230108112922.jpg');
INSERT INTO public.customers_registration VALUES (6, 'Toko Makmur 88', 'Jalan Raya Karet no 45', '085746879090', 1, '', 1, '2023-01-09 00:28:04.981422', NULL, 1, 'Lamongan', 'Test', 1000000, '112.4270975', '-7.134619', '', '085746879090', '', '', '', 'Ibu Ana', '', '', '', '', 0, 'PicRegForm_1_20230109122706.jpg');
INSERT INTO public.customers_registration VALUES (7, 'AA 5201 JAYA, TK', 'Blok AA 5201 Pergudangan Safe N Lock ', '', 1, '', 1, '2023-01-09 10:30:11.832609', NULL, 2, 'Sidoarjo', 'Test 1', 0, '112.7541371', '-7.4595594', '', '', '', '', '', '', 'Distributor', '', '', '', 0, 'PicRegForm_2_20230109102924.jpg');
INSERT INTO public.customers_registration VALUES (8, 'panggon kulak 2', 'Wahidin Sudirohusodo no 18', '052148114114', 1, '', 1, '2023-01-10 10:35:37.409465', NULL, 13, 'gresik', '', 0, '112.6276382', '-7.163278', '', '052148114114', '', '', '', '052148114114', 'grosir', 'grosir', 'owner', '', 0, 'PicRegForm_13_20230110103514.jpg');
INSERT INTO public.customers_registration VALUES (9, 'Arsya', 'JL.Syid Mahmud Desa Kintelan Kecamatan Puri Kabupaten Mojokerto, Jawa Timur ', '', 1, '', 1, '2023-01-10 12:09:29.175189', NULL, 12, 'Mojokerto ', 'Ambil 1 dos serbuuu 100gr+10pouch serbuuu 230 gr', 65000, '112.4299928', '-7.5414205', '', '', '083144396842', '', '', '', '', '', '', '', 0, 'PicRegForm_12_20230110120838.jpg');
INSERT INTO public.customers_registration VALUES (10, 'KAMAL', 'JL.RAYA BRANGKAL NO.38 KEDUNG MALING SOOKO MOJOKERTO ', '', 1, '', 1, '2023-01-10 14:54:36.298406', NULL, 12, 'Mojokerto ', 'siap jadi mitra serbuuu ', 22000, '112.4136868', '-7.5251225', '', '', '08980013257', '', '', 'Muhammad Amali', '', '', 'owner ', '', 0, 'PicRegForm_12_20230110025331.jpg');
INSERT INTO public.customers_registration VALUES (11, 'panggon kulak 2', 'rubiIX no 5A', '', 1, '', 1, '2023-01-10 15:08:35.775367', NULL, 13, '', '', 0, '112.5922605', '-7.1517302', '', '', '', '', '', '082148114114', 'grosir', '', 'PO', '', 0, 'PicRegForm_13_20230110030817.jpg');


--
-- TOC entry 3682 (class 0 OID 17952)
-- Dependencies: 210
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
-- TOC entry 3684 (class 0 OID 17962)
-- Dependencies: 212
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3686 (class 0 OID 17971)
-- Dependencies: 214
-- Data for Name: invoice_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3687 (class 0 OID 17984)
-- Dependencies: 215
-- Data for Name: invoice_master; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3689 (class 0 OID 18003)
-- Dependencies: 217
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
-- TOC entry 3767 (class 0 OID 18727)
-- Dependencies: 295
-- Data for Name: login_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.login_session VALUES (1, '20230107074921Demo', 'DEMO', 'LOGIN', '2023-01-07 07:49:24.169809');
INSERT INTO public.login_session VALUES (2, '20230107074936Demo', 'DEMO', 'LOGIN', '2023-01-07 07:49:37.653955');
INSERT INTO public.login_session VALUES (3, '20230107075836Demo', 'DEMO', 'LOGIN', '2023-01-07 07:58:40.976858');
INSERT INTO public.login_session VALUES (4, '20230107075857demo', 'DEMO', 'LOGIN', '2023-01-07 07:58:58.772962');
INSERT INTO public.login_session VALUES (5, '20230107075859demo', 'DEMO', 'LOGIN', '2023-01-07 07:59:00.521229');
INSERT INTO public.login_session VALUES (6, '20230107075907demo', 'DEMO', 'LOGIN', '2023-01-07 07:59:08.525534');
INSERT INTO public.login_session VALUES (7, '20230107080011demo', 'DEMO', 'LOGIN', '2023-01-07 08:00:12.13521');
INSERT INTO public.login_session VALUES (8, '20230107080012demo', 'DEMO', 'LOGIN', '2023-01-07 08:00:13.125771');
INSERT INTO public.login_session VALUES (9, '20230107080012demo', 'DEMO', 'LOGIN', '2023-01-07 08:00:13.719507');
INSERT INTO public.login_session VALUES (10, '20230107080013demo', 'DEMO', 'LOGIN', '2023-01-07 08:00:14.106044');
INSERT INTO public.login_session VALUES (11, '20230107080013demo', 'DEMO', 'LOGIN', '2023-01-07 08:00:14.292773');
INSERT INTO public.login_session VALUES (12, '20230107080013demo', 'DEMO', 'LOGIN', '2023-01-07 08:00:14.713755');
INSERT INTO public.login_session VALUES (13, '20230107080934demo', 'DEMO', 'LOGIN', '2023-01-07 08:09:35.997133');
INSERT INTO public.login_session VALUES (14, '20230107135849DEMO', 'DEMO', 'LOGIN', '2023-01-07 13:58:50.704957');
INSERT INTO public.login_session VALUES (15, '20230107140418DEMO', 'DEMO', 'LOGIN', '2023-01-07 14:04:19.835108');
INSERT INTO public.login_session VALUES (16, '20230107140819DEMO', 'DEMO', 'LOGIN', '2023-01-07 14:08:20.580564');
INSERT INTO public.login_session VALUES (17, '20230107144922DEMO', 'DEMO', 'LOGIN', '2023-01-07 14:49:23.262184');
INSERT INTO public.login_session VALUES (18, '20230107221419DEMO', 'DEMO', 'LOGIN', '2023-01-07 22:14:20.920819');
INSERT INTO public.login_session VALUES (19, '20230107221511DEMO', 'DEMO', 'LOGIN', '2023-01-07 22:15:12.029969');
INSERT INTO public.login_session VALUES (20, '20230107221714DEMO', 'DEMO', 'LOGIN', '2023-01-07 22:17:15.918213');
INSERT INTO public.login_session VALUES (21, '20230107221858DEMO', 'DEMO', 'LOGIN', '2023-01-07 22:18:59.597029');
INSERT INTO public.login_session VALUES (22, '20230107221917DEMO', 'DEMO', 'LOGIN', '2023-01-07 22:19:18.888268');
INSERT INTO public.login_session VALUES (23, '20230108094516DEMO', 'DEMO', 'LOGIN', '2023-01-08 09:45:17.803808');
INSERT INTO public.login_session VALUES (24, '20230108094538DEMO', 'DEMO', 'LOGIN', '2023-01-08 09:45:38.825065');
INSERT INTO public.login_session VALUES (25, '20230108095050Demo', 'DEMO', 'LOGIN', '2023-01-08 09:50:51.283998');
INSERT INTO public.login_session VALUES (26, '20230108112251DEMO', 'DEMO', 'LOGIN', '2023-01-08 11:22:52.79834');
INSERT INTO public.login_session VALUES (27, '20230108112348DEMO', 'DEMO', 'LOGIN', '2023-01-08 11:23:49.672861');
INSERT INTO public.login_session VALUES (28, '20230108112655DEMO', 'DEMO', 'LOGIN', '2023-01-08 11:26:55.886346');
INSERT INTO public.login_session VALUES (29, '20230108124012DEMO', 'DEMO', 'LOGIN', '2023-01-08 12:40:13.345378');
INSERT INTO public.login_session VALUES (30, '20230108133502DEMO', 'DEMO', 'LOGIN', '2023-01-08 13:35:04.918867');
INSERT INTO public.login_session VALUES (31, '20230108142518DEMO', 'DEMO', 'LOGIN', '2023-01-08 14:25:19.222039');
INSERT INTO public.login_session VALUES (32, '20230108142525DEMO', 'DEMO', 'LOGIN', '2023-01-08 14:25:26.581718');
INSERT INTO public.login_session VALUES (33, '20230108142646DEMO', 'DEMO', 'LOGIN', '2023-01-08 14:26:47.597314');
INSERT INTO public.login_session VALUES (34, '20230108142729DEMO', 'DEMO', 'LOGIN', '2023-01-08 14:27:30.644742');
INSERT INTO public.login_session VALUES (35, '20230108143104DEMO', 'DEMO', 'LOGIN', '2023-01-08 14:31:05.747657');
INSERT INTO public.login_session VALUES (36, '20230108143220DEMO', 'DEMO', 'LOGIN', '2023-01-08 14:32:21.657383');
INSERT INTO public.login_session VALUES (37, '20230108143837DEMO', 'DEMO', 'LOGIN', '2023-01-08 14:38:38.772662');
INSERT INTO public.login_session VALUES (38, '20230108145042DEMO', 'DEMO', 'LOGIN', '2023-01-08 14:50:43.749964');
INSERT INTO public.login_session VALUES (39, '20230108145253DEMO', 'DEMO', 'LOGIN', '2023-01-08 14:53:01.127323');
INSERT INTO public.login_session VALUES (40, '20230108153709DEMO', 'DEMO', 'LOGIN', '2023-01-08 15:37:08.819616');
INSERT INTO public.login_session VALUES (41, '20230108153733DEMO', 'DEMO', 'LOGIN', '2023-01-08 15:37:32.561074');
INSERT INTO public.login_session VALUES (42, '20230108161608DEMO', 'DEMO', 'LOGIN', '2023-01-08 16:16:08.219153');
INSERT INTO public.login_session VALUES (43, '20230108161937DEMO', 'DEMO', 'LOGIN', '2023-01-08 16:19:37.002035');
INSERT INTO public.login_session VALUES (44, '20230108162929DEMO', 'DEMO', 'LOGIN', '2023-01-08 16:29:28.564319');
INSERT INTO public.login_session VALUES (45, '20230108163704DEMO', 'DEMO', 'LOGIN', '2023-01-08 16:37:04.243504');
INSERT INTO public.login_session VALUES (46, '20230108170813DEMO', 'DEMO', 'LOGIN', '2023-01-08 17:08:12.63807');
INSERT INTO public.login_session VALUES (47, '20230108171708DEMO', 'DEMO', 'LOGIN', '2023-01-08 17:17:08.083338');
INSERT INTO public.login_session VALUES (48, '20230108172641DEMO', 'DEMO', 'LOGIN', '2023-01-08 17:26:41.383919');
INSERT INTO public.login_session VALUES (49, '20230108174925DEMO', 'DEMO', 'LOGIN', '2023-01-08 17:49:24.865091');
INSERT INTO public.login_session VALUES (50, '20230108175320DEMO', 'DEMO', 'LOGIN', '2023-01-08 17:53:20.069957');
INSERT INTO public.login_session VALUES (51, '20230108184622DEMO', 'DEMO', 'LOGIN', '2023-01-08 18:46:21.740335');
INSERT INTO public.login_session VALUES (52, '20230108184918DEMO', 'DEMO', 'LOGIN', '2023-01-08 18:49:18.008887');
INSERT INTO public.login_session VALUES (53, '20230108185041DEMO', 'DEMO', 'LOGIN', '2023-01-08 18:50:40.69958');
INSERT INTO public.login_session VALUES (54, '20230108194414DEMO', 'DEMO', 'LOGIN', '2023-01-08 19:44:14.002439');
INSERT INTO public.login_session VALUES (55, '20230108194441DEMO', 'DEMO', 'LOGIN', '2023-01-08 19:44:42.507511');
INSERT INTO public.login_session VALUES (56, '20230108194621DEMO', 'DEMO', 'LOGIN', '2023-01-08 19:46:21.73535');
INSERT INTO public.login_session VALUES (57, '20230108194906DEMO', 'DEMO', 'LOGIN', '2023-01-08 19:49:06.743052');
INSERT INTO public.login_session VALUES (58, '20230108194945DEMO', 'DEMO', 'LOGIN', '2023-01-08 19:49:45.470169');
INSERT INTO public.login_session VALUES (59, '20230108195748DEMO', 'DEMO', 'LOGIN', '2023-01-08 19:57:48.44161');
INSERT INTO public.login_session VALUES (60, '20230108200124DEMO', 'DEMO', 'LOGIN', '2023-01-08 20:01:24.468215');
INSERT INTO public.login_session VALUES (61, '20230108200502DEMO', 'DEMO', 'LOGIN', '2023-01-08 20:05:01.787177');
INSERT INTO public.login_session VALUES (62, '20230108200510DEMO', 'DEMO', 'LOGIN', '2023-01-08 20:05:09.905836');
INSERT INTO public.login_session VALUES (63, '20230108201936DEMO', 'DEMO', 'LOGIN', '2023-01-08 20:19:36.030275');
INSERT INTO public.login_session VALUES (64, '20230108205210DEMO', 'DEMO', 'LOGIN', '2023-01-08 20:52:10.27105');
INSERT INTO public.login_session VALUES (65, '20230108213416DEMO', 'DEMO', 'LOGIN', '2023-01-08 21:34:16.215529');
INSERT INTO public.login_session VALUES (66, '20230108213937DEMO', 'DEMO', 'LOGIN', '2023-01-08 21:39:36.76294');
INSERT INTO public.login_session VALUES (67, '20230108214022DEMO', 'DEMO', 'LOGIN', '2023-01-08 21:40:22.597598');
INSERT INTO public.login_session VALUES (68, '20230108214029DEMO', 'DEMO', 'LOGIN', '2023-01-08 21:40:29.125562');
INSERT INTO public.login_session VALUES (69, '20230108221252DEMO', 'DEMO', 'LOGIN', '2023-01-08 22:12:52.012749');
INSERT INTO public.login_session VALUES (70, '20230108221613DEMO', 'DEMO', 'LOGIN', '2023-01-08 22:16:13.28302');
INSERT INTO public.login_session VALUES (71, '20230108221709DEMO', 'DEMO', 'LOGIN', '2023-01-08 22:17:09.508298');
INSERT INTO public.login_session VALUES (72, '20230108230902DEMO', 'DEMO', 'LOGIN', '2023-01-08 23:09:02.058203');
INSERT INTO public.login_session VALUES (73, '20230108230920DEMO', 'DEMO', 'LOGIN', '2023-01-08 23:09:20.075641');
INSERT INTO public.login_session VALUES (74, '20230108232003DEMO', 'DEMO', 'LOGIN', '2023-01-08 23:20:03.201758');
INSERT INTO public.login_session VALUES (75, '20230108232722DEMO', 'DEMO', 'LOGIN', '2023-01-08 23:27:21.531308');
INSERT INTO public.login_session VALUES (76, '20230108234017demo', 'DEMO', 'LOGIN', '2023-01-08 23:40:18.698464');
INSERT INTO public.login_session VALUES (77, '20230108234330sales01', 'SALES01', 'LOGIN', '2023-01-08 23:43:31.020018');
INSERT INTO public.login_session VALUES (78, '20230108234347SALES02', 'SALES02', 'LOGIN', '2023-01-08 23:43:48.300989');
INSERT INTO public.login_session VALUES (79, '20230108234400SALES023', 'SALES023', 'LOGIN', '2023-01-08 23:44:01.633947');
INSERT INTO public.login_session VALUES (80, '20230109002538demo', 'DEMO', 'LOGIN', '2023-01-09 00:25:39.887382');
INSERT INTO public.login_session VALUES (81, '20230109102713sales01', 'SALES01', 'LOGIN', '2023-01-09 10:27:15.601601');
INSERT INTO public.login_session VALUES (82, '20230109103249SALES01', 'SALES01', 'LOGIN', '2023-01-09 10:32:51.634615');
INSERT INTO public.login_session VALUES (83, '20230109103729SALES01', 'SALES01', 'LOGIN', '2023-01-09 10:37:31.391906');
INSERT INTO public.login_session VALUES (84, '20230109103747sales01', 'SALES01', 'LOGIN', '2023-01-09 10:37:48.338613');
INSERT INTO public.login_session VALUES (85, '20230109104242SALES01', 'SALES01', 'LOGIN', '2023-01-09 10:42:45.628523');
INSERT INTO public.login_session VALUES (86, '20230109104611SALES01', 'SALES01', 'LOGIN', '2023-01-09 10:46:14.405939');
INSERT INTO public.login_session VALUES (87, '20230109112218SALES01', 'SALES01', 'LOGIN', '2023-01-09 11:22:20.83871');
INSERT INTO public.login_session VALUES (88, '20230109115208SALES01', 'SALES01', 'LOGIN', '2023-01-09 11:52:11.783473');
INSERT INTO public.login_session VALUES (89, '20230109120937Sales02', 'SALES02', 'LOGIN', '2023-01-09 12:09:38.117964');
INSERT INTO public.login_session VALUES (90, '20230109122032sales02', 'SALES02', 'LOGIN', '2023-01-09 12:20:33.201686');
INSERT INTO public.login_session VALUES (91, '20230109141633SALES02', 'SALES02', 'LOGIN', '2023-01-09 14:16:34.224322');
INSERT INTO public.login_session VALUES (92, '20230109142359JKT01', 'JKT01', 'LOGIN', '2023-01-09 14:24:00.702359');
INSERT INTO public.login_session VALUES (93, '20230109142808JKT01', 'JKT01', 'LOGIN', '2023-01-09 14:28:11.149252');
INSERT INTO public.login_session VALUES (94, '20230109162409GRES01', 'GRES01', 'LOGIN', '2023-01-09 16:24:10.848998');
INSERT INTO public.login_session VALUES (95, '20230109172810sales01', 'SALES01', 'LOGIN', '2023-01-09 16:28:12.139262');
INSERT INTO public.login_session VALUES (96, '20230109164723sales02', 'SALES02', 'LOGIN', '2023-01-09 16:47:24.650829');
INSERT INTO public.login_session VALUES (97, '20230109165703JKT01', 'JKT01', 'LOGIN', '2023-01-09 16:57:05.865498');
INSERT INTO public.login_session VALUES (98, '20230109175709SALES01', 'SALES01', 'LOGIN', '2023-01-09 16:57:11.250203');
INSERT INTO public.login_session VALUES (99, '20230110002124JKT01', 'JKT01', 'LOGIN', '2023-01-10 00:21:25.405582');
INSERT INTO public.login_session VALUES (100, '20230110061409JKT01', 'JKT01', 'LOGIN', '2023-01-10 06:14:10.140896');
INSERT INTO public.login_session VALUES (101, '20230110061937JKT01', 'JKT01', 'LOGIN', '2023-01-10 06:19:38.653318');
INSERT INTO public.login_session VALUES (102, '20230110083646SALES02', 'SALES02', 'LOGIN', '2023-01-10 07:36:47.856101');
INSERT INTO public.login_session VALUES (103, '20230110091204Lukman', 'LUKMAN', 'LOGIN', '2023-01-10 08:12:05.69926');
INSERT INTO public.login_session VALUES (104, '20230110092943SALES01', 'SALES01', 'LOGIN', '2023-01-10 08:29:45.468951');
INSERT INTO public.login_session VALUES (105, '20230110084317MOJO01', 'MOJO01', 'LOGIN', '2023-01-10 08:43:20.368391');
INSERT INTO public.login_session VALUES (106, '20230110085117Sales03', 'SALES03', 'LOGIN', '2023-01-10 08:51:18.813873');
INSERT INTO public.login_session VALUES (107, '20230110092425SIDO01', 'SIDO01', 'LOGIN', '2023-01-10 09:24:24.9902');
INSERT INTO public.login_session VALUES (108, '20230110094456JKT01', 'JKT01', 'LOGIN', '2023-01-10 09:44:58.415679');
INSERT INTO public.login_session VALUES (109, '20230110111649SALES01', 'SALES01', 'LOGIN', '2023-01-10 10:16:50.742719');
INSERT INTO public.login_session VALUES (110, '20230110101935SALES03', 'SALES03', 'LOGIN', '2023-01-10 10:19:36.64513');
INSERT INTO public.login_session VALUES (111, '20230110102135SALES03', 'SALES03', 'LOGIN', '2023-01-10 10:21:36.827681');
INSERT INTO public.login_session VALUES (112, '20230110102154SALES03', 'SALES03', 'LOGIN', '2023-01-10 10:21:55.211056');
INSERT INTO public.login_session VALUES (113, '20230110103301GRES01', 'GRES01', 'LOGIN', '2023-01-10 10:33:03.010675');
INSERT INTO public.login_session VALUES (114, '20230110104445SALES03', 'SALES03', 'LOGIN', '2023-01-10 10:44:46.820823');
INSERT INTO public.login_session VALUES (115, '20230110105943GRES01', 'GRES01', 'LOGIN', '2023-01-10 10:59:46.622044');
INSERT INTO public.login_session VALUES (116, '20230110110128JKT01', 'JKT01', 'LOGIN', '2023-01-10 11:01:30.682225');
INSERT INTO public.login_session VALUES (117, '20230110110224BDG01', 'BDG01', 'LOGIN', '2023-01-10 11:02:26.895885');
INSERT INTO public.login_session VALUES (118, '20230110110332GRES01', 'GRES01', 'LOGIN', '2023-01-10 11:03:34.809796');
INSERT INTO public.login_session VALUES (119, '20230110134744SALES01', 'SALES01', 'LOGIN', '2023-01-10 12:47:46.590718');
INSERT INTO public.login_session VALUES (120, '20230110130113GRES01', 'GRES01', 'LOGIN', '2023-01-10 13:01:15.863153');
INSERT INTO public.login_session VALUES (121, '20230110133945SIDO01', 'SIDO01', 'LOGIN', '2023-01-10 13:39:45.208693');
INSERT INTO public.login_session VALUES (122, '20230110140947MOJO01', 'MOJO01', 'LOGIN', '2023-01-10 14:09:49.323226');
INSERT INTO public.login_session VALUES (123, '20230110141048SIDO01', 'SIDO01', 'LOGIN', '2023-01-10 14:10:47.712652');
INSERT INTO public.login_session VALUES (124, '20230110141701SIDO01', 'SIDO01', 'LOGIN', '2023-01-10 14:17:00.758908');
INSERT INTO public.login_session VALUES (125, '20230110143639MOJO01', 'MOJO01', 'LOGIN', '2023-01-10 14:36:41.45885');
INSERT INTO public.login_session VALUES (126, '20230110150630GRES01', 'GRES01', 'LOGIN', '2023-01-10 15:06:32.851221');
INSERT INTO public.login_session VALUES (127, '20230110150644GRES01', 'GRES01', 'LOGIN', '2023-01-10 15:06:46.237101');
INSERT INTO public.login_session VALUES (128, '20230110171350SALES01', 'SALES01', 'LOGIN', '2023-01-10 16:13:51.099338');
INSERT INTO public.login_session VALUES (129, '20230110174513GRES01', 'GRES01', 'LOGIN', '2023-01-10 17:45:15.27717');
INSERT INTO public.login_session VALUES (130, '20230110174515GRES01', 'GRES01', 'LOGIN', '2023-01-10 17:45:16.622473');
INSERT INTO public.login_session VALUES (131, '20230110174517GRES01', 'GRES01', 'LOGIN', '2023-01-10 17:45:18.402276');
INSERT INTO public.login_session VALUES (132, '20230110174532GRES01', 'GRES01', 'LOGIN', '2023-01-10 17:45:32.995949');


--
-- TOC entry 3691 (class 0 OID 18013)
-- Dependencies: 219
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
-- TOC entry 3693 (class 0 OID 18018)
-- Dependencies: 221
-- Data for Name: model_has_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3694 (class 0 OID 18021)
-- Dependencies: 222
-- Data for Name: model_has_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.model_has_roles VALUES (1, 'App\Models\User', 1);
INSERT INTO public.model_has_roles VALUES (4, 'App\Models\User', 38);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 39);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 40);
INSERT INTO public.model_has_roles VALUES (4, 'App\Models\User', 45);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 46);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 47);
INSERT INTO public.model_has_roles VALUES (12, 'App\Models\User', 56);


--
-- TOC entry 3695 (class 0 OID 18024)
-- Dependencies: 223
-- Data for Name: order_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3696 (class 0 OID 18036)
-- Dependencies: 224
-- Data for Name: order_master; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3698 (class 0 OID 18055)
-- Dependencies: 226
-- Data for Name: password_resets; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3699 (class 0 OID 18061)
-- Dependencies: 227
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
-- TOC entry 3700 (class 0 OID 18067)
-- Dependencies: 228
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
INSERT INTO public.period_price_sell VALUES (445, 202212, 3, 250000.00, '2022-12-30 16:01:45', NULL, 1, '2022-12-03 17:10:01.508925', 1);
INSERT INTO public.period_price_sell VALUES (3, 202211, 3, 250000.00, '2022-12-30 16:01:45', NULL, 1, '2022-11-26 14:19:07.145434', 1);
INSERT INTO public.period_price_sell VALUES (664, 202301, 1, 149000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (665, 202301, 2, 19000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (666, 202301, 3, 249000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (667, 202301, 4, 174000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (668, 202301, 4, 174000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (669, 202301, 5, 174000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (670, 202301, 5, 174000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (671, 202301, 6, 39000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (672, 202301, 7, 149000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (673, 202301, 7, 149000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (674, 202301, 8, 149000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (675, 202301, 8, 149000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (676, 202301, 9, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (677, 202301, 9, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (678, 202301, 10, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (679, 202301, 10, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (680, 202301, 11, 24000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (681, 202301, 11, 24000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (682, 202301, 12, 64000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (683, 202301, 12, 64000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (684, 202301, 13, 39000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (685, 202301, 13, 39000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (686, 202301, 14, 34000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (687, 202301, 14, 34000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (688, 202301, 15, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (689, 202301, 16, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (690, 202301, 16, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (691, 202301, 17, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (692, 202301, 17, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (693, 202301, 18, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (694, 202301, 18, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (695, 202301, 19, 174000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (696, 202301, 19, 174000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (697, 202301, 20, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (698, 202301, 20, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (699, 202301, 21, 149000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (700, 202301, 22, 124000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (701, 202301, 22, 124000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (702, 202301, 23, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (703, 202301, 23, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (704, 202301, 24, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (705, 202301, 24, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (706, 202301, 25, 24000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (707, 202301, 26, 249000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (708, 202301, 26, 249000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (709, 202301, 27, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (710, 202301, 27, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (711, 202301, 28, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (712, 202301, 28, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (713, 202301, 29, 499000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (714, 202301, 29, 499000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (715, 202301, 30, 24000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (716, 202301, 30, 24000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (717, 202301, 31, 199000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (718, 202301, 31, 199000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (719, 202301, 32, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (720, 202301, 32, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (721, 202301, 33, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (722, 202301, 33, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (723, 202301, 34, 39000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (724, 202301, 35, 4000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (725, 202301, 35, 4000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (726, 202301, 36, 4000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (727, 202301, 36, 4000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (728, 202301, 37, 4000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (729, 202301, 37, 4000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (730, 202301, 39, 159000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (731, 202301, 39, 159000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (732, 202301, 40, 159000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (733, 202301, 40, 159000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (734, 202301, 41, 159000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (735, 202301, 41, 159000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (736, 202301, 42, 134000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (737, 202301, 43, 134000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (738, 202301, 44, 134000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (739, 202301, 45, 134000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (740, 202301, 46, 134000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (741, 202301, 47, 109000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (742, 202301, 49, 159000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (743, 202301, 50, 109000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (744, 202301, 51, 79000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (745, 202301, 52, 69000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (746, 202301, 53, 299000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (747, 202301, 54, 159000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (748, 202301, 55, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (749, 202301, 56, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (750, 202301, 57, 64000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (751, 202301, 58, 324000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (752, 202301, 59, 184000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (753, 202301, 60, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (754, 202301, 61, 79000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (755, 202301, 62, 74000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (756, 202301, 63, 69000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (757, 202301, 65, 69000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (758, 202301, 64, 74000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (759, 202301, 67, 69000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (760, 202301, 66, 69000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (761, 202301, 1, 149000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (762, 202301, 1, 149000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (763, 202301, 2, 19000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (764, 202301, 3, 249000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (765, 202301, 4, 174000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (766, 202301, 5, 174000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (767, 202301, 6, 39000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (768, 202301, 6, 39000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (769, 202301, 7, 149000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (770, 202301, 8, 149000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (771, 202301, 9, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (772, 202301, 10, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (773, 202301, 11, 24000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (774, 202301, 12, 64000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (775, 202301, 13, 39000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (776, 202301, 14, 34000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (777, 202301, 15, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (778, 202301, 15, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (779, 202301, 16, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (780, 202301, 17, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (781, 202301, 18, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (782, 202301, 19, 174000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (783, 202301, 20, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (784, 202301, 21, 149000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (785, 202301, 22, 124000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (786, 202301, 23, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (787, 202301, 24, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (788, 202301, 25, 24000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (789, 202301, 25, 24000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (790, 202301, 26, 249000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (791, 202301, 27, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (792, 202301, 28, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (793, 202301, 29, 499000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (794, 202301, 30, 24000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (795, 202301, 31, 199000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (796, 202301, 32, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (797, 202301, 33, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (798, 202301, 34, 39000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (799, 202301, 34, 39000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (800, 202301, 35, 4000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (801, 202301, 36, 4000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (802, 202301, 37, 4000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (803, 202301, 39, 159000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (804, 202301, 40, 159000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (805, 202301, 41, 159000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (806, 202301, 42, 134000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (807, 202301, 42, 134000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (808, 202301, 43, 134000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (809, 202301, 43, 134000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (810, 202301, 44, 134000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (811, 202301, 44, 134000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (812, 202301, 45, 134000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (813, 202301, 45, 134000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (814, 202301, 46, 134000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (815, 202301, 46, 134000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (816, 202301, 47, 109000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (817, 202301, 47, 109000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (818, 202301, 61, 79000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (819, 202301, 64, 74000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (820, 202301, 65, 69000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (821, 202301, 65, 69000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (822, 202301, 66, 69000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (823, 202301, 64, 74000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (824, 202301, 68, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (825, 202301, 68, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (826, 202301, 68, 49000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (827, 202301, 69, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (828, 202301, 67, 69000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (829, 202301, 66, 69000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (830, 202301, 69, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (831, 202301, 69, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (832, 202301, 70, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (833, 202301, 70, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (834, 202301, 70, 59000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (835, 202301, 67, 69000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (836, 202301, 83, 9000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (837, 202301, 83, 9000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (838, 202301, 83, 9000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (839, 202301, 84, 19000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (840, 202301, 21, 149000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (841, 202301, 48, 109000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (842, 202301, 48, 109000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (843, 202301, 48, 109000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (844, 202301, 49, 159000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (845, 202301, 49, 159000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (846, 202301, 50, 109000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (847, 202301, 50, 109000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (848, 202301, 51, 79000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (849, 202301, 51, 79000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (850, 202301, 52, 69000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (851, 202301, 52, 69000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (852, 202301, 53, 299000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (853, 202301, 53, 299000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (854, 202301, 54, 159000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (855, 202301, 54, 159000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (856, 202301, 55, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (857, 202301, 55, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (858, 202301, 56, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (859, 202301, 56, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (860, 202301, 57, 64000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (861, 202301, 57, 64000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (862, 202301, 58, 324000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (863, 202301, 58, 324000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (864, 202301, 59, 184000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (865, 202301, 59, 184000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (866, 202301, 60, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (867, 202301, 60, 99000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (868, 202301, 61, 79000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (869, 202301, 62, 74000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (870, 202301, 62, 74000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (871, 202301, 63, 69000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (872, 202301, 63, 69000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (873, 202301, 84, 19000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (874, 202301, 84, 19000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (875, 202301, 86, 19000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (876, 202301, 86, 19000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (877, 202301, 86, 19000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (878, 202301, 85, 9000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (879, 202301, 85, 9000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (880, 202301, 85, 9000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (881, 202301, 89, 9000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (882, 202301, 89, 0.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 2);
INSERT INTO public.period_price_sell VALUES (883, 202301, 89, 9000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 3);
INSERT INTO public.period_price_sell VALUES (884, 202301, 3, 250000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);


--
-- TOC entry 3702 (class 0 OID 18073)
-- Dependencies: 230
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
INSERT INTO public.period_stock VALUES (202212, 1, 8, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 9, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 11, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 13, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 19, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 20, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 24, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 28, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 29, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 18, 9999, 9998, 0, 1, '2022-12-18 10:40:28.120636', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 21, 10000, 9999, 0, 1, '2022-12-18 11:12:23.953146', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 30, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 31, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 33, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 34, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 2, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 32, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 22, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 7, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 14, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 15, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 16, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 23, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 37, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 26, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 17, 10000, 10000, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 40, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 41, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 44, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 49, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 53, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 54, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 55, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 56, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 57, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 58, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 61, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 62, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
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
INSERT INTO public.period_stock VALUES (202212, 1, 6, 9999, 9998, 0, 1, '2022-12-18 10:40:28.131334', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 39, 9999, 9998, 0, 1, '2022-12-18 10:40:28.136896', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 4, 9999, 9996, 0, 3, '2022-12-18 12:07:02.357244', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 59, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 60, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 2, 61, 9999, 9999, 0, 0, NULL, 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 5, 9999, 9998, 0, 1, '2022-12-18 13:52:24.382913', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 48, 9999, 9998, 0, 1, '2022-12-28 08:09:00.730958', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 25, 9999, 9998, 0, 1, '2022-12-23 14:41:20.279077', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 42, 9999, 9998, 0, 1, '2022-12-24 02:13:45.557229', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 46, 9999, 9998, 0, 1, '2022-12-24 02:40:27.426746', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 43, 9999, 9998, 0, 1, '2022-12-28 08:09:01.044681', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 36, 9999, 9997, 0, 2, '2022-12-28 07:49:03.297848', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 50, 9999, 9997, 0, 2, '2022-12-28 07:26:57.020246', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 45, 9999, 9995, 0, 4, '2022-12-28 07:49:02.967183', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 35, 9999, 9997, 0, 2, '2022-12-28 08:09:00.85344', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 60, 9999, 9997, 0, 2, '2022-12-30 09:04:21.941304', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 52, 9999, 9994, 0, 5, '2022-12-30 09:04:22.027433', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 47, 9999, 9994, 0, 5, '2022-12-30 09:04:22.121621', 1, '2022-12-01 08:01:37.55494');
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
INSERT INTO public.period_stock VALUES (202212, 1, 1, 9999, 9988, 0, 11, '2022-12-18 15:05:59.698429', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 12, 9999, 9993, 0, 6, '2022-12-28 07:49:03.108402', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 3, 9999, 9997, 1, 3, '2022-12-30 09:01:45.523289', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 51, 9999, 9997, 0, 2, '2022-12-28 07:11:33.292326', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 59, 9999, 9995, 0, 4, '2022-12-31 06:15:15.3061', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202212, 1, 63, 9999, 9998, 0, 1, '2022-12-30 09:04:21.846741', 1, '2022-12-01 08:01:37.55494');
INSERT INTO public.period_stock VALUES (202301, 1, 8, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 9, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 11, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 13, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 19, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 20, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 24, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 28, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 29, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 18, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 21, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 30, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 31, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 33, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 34, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 2, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 5, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 32, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 22, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 7, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 14, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 15, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 16, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 23, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 35, 9997, 9997, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 36, 9997, 9997, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 37, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 25, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 26, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 17, 10000, 10000, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 40, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 41, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 42, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 43, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 44, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 45, 9995, 9995, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 46, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 47, 9994, 9994, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 48, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 49, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 50, 9997, 9997, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 53, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 54, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 55, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 56, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 57, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 58, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 60, 9997, 9997, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 61, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 62, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 64, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 65, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 66, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 67, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 68, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 70, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 69, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 76, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 1, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 8, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 10, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 12, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 13, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 18, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 19, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 21, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 24, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 27, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 29, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 30, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 31, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 33, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 34, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 2, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 3, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 4, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 32, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 6, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 22, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 14, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 15, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 16, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 36, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 37, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 25, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 26, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 17, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 39, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 40, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 41, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 42, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 45, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 43, 9997, 9997, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 44, 9997, 9997, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 35, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 5, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 7, 9997, 9997, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 49, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 50, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 51, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 52, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 53, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 54, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 55, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 56, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 57, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 58, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 28, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 9, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 6, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 39, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 4, 9996, 9996, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 52, 9994, 9994, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 59, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 60, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 61, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 62, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 63, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 64, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 65, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 66, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 67, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 68, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 70, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 69, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 76, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 1, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 8, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 10, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 11, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 12, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 13, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 18, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 19, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 24, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 27, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 28, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 29, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 30, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 31, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 33, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 34, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 2, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 3, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 4, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 5, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 32, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 6, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 22, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 7, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 14, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 15, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 16, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 23, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 35, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 36, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 37, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 25, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 26, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 17, 10000, 10000, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 39, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 40, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 41, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 42, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 43, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 47, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 49, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 50, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 51, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 52, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 53, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 54, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 55, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 56, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 57, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 58, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 59, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 60, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 61, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 62, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 63, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 64, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 65, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 66, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 67, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 68, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 70, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 69, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 76, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 27, 10108, 10108, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 46, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 48, 9989, 9989, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 45, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 10, 10000, 10000, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 47, 9995, 9995, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 23, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 46, 9995, 9995, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 44, 9991, 9991, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 48, 9990, 9990, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 20, 9995, 9995, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 11, 9997, 9997, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 20, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 9, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 3, 21, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 3, 9997, 9997, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 1, 9988, 9988, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 12, 9993, 9993, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 51, 9997, 9997, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 63, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 59, 9995, 9993, 0, 2, '2023-01-10 21:53:34.224131', 1, '2023-01-02 20:54:24.132802');


--
-- TOC entry 3703 (class 0 OID 18083)
-- Dependencies: 231
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
INSERT INTO public.permissions VALUES (135, 'uoms.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/uoms', 'Satuan', 'Products');
INSERT INTO public.permissions VALUES (143, 'categories.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/categories', 'Kategori', 'Products');
INSERT INTO public.permissions VALUES (151, 'types.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/types', 'Tipe', 'Products');
INSERT INTO public.permissions VALUES (191, 'productscommisionbyyear.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productscommisionbyyear', 'Komisi Produk Tahun', 'Products');
INSERT INTO public.permissions VALUES (123, 'invoices.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/invoices', 'Faktur Jual', 'Transactions');
INSERT INTO public.permissions VALUES (171, 'productspoint.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productspoint', 'Poin', 'Products');
INSERT INTO public.permissions VALUES (192, 'reports.cashier.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/cashier', 'Komisi Kasir', 'Reports');
INSERT INTO public.permissions VALUES (181, 'productscommision.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productscommision', 'Komisi Produk', 'Products');
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
INSERT INTO public.permissions VALUES (221, 'receiveorders.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/receiveorders', 'Penerimaan Barang', 'Transactions');
INSERT INTO public.permissions VALUES (31, 'branchs.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/branchs', 'Cabang', 'Settings');
INSERT INTO public.permissions VALUES (266, 'usersshift.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/usersshift', 'Shift Staff', 'Settings');
INSERT INTO public.permissions VALUES (242, 'suppliers.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/suppliers', 'Vendor', 'Users');
INSERT INTO public.permissions VALUES (277, 'productspriceadj.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productspriceadj', 'Penyesuaian Harga', 'Products');
INSERT INTO public.permissions VALUES (232, 'company.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/company', 'Profil Perusahaan', 'Settings');
INSERT INTO public.permissions VALUES (299, 'reports.purchase.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (301, 'reports.customer.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (303, 'reports.receive.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (305, 'reports.stockmutation.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (307, 'reports.stock.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (309, 'reports.referral.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (292, 'reports.closeshift.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/closeshift', 'Serah Terima Shift', 'Reports');
INSERT INTO public.permissions VALUES (310, 'reports.referral.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/referral', 'Referral', 'Reports');
INSERT INTO public.permissions VALUES (312, 'reports.usertracking.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/usertracking/search', '', '');
INSERT INTO public.permissions VALUES (313, 'reports.closeday.getdata', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (314, 'reports.closeday.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
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
INSERT INTO public.permissions VALUES (337, 'reports.omsetdetail.search', 'web', '2022-12-03 19:35:33', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (338, 'reports.omsetdetail.index', 'web', '2022-12-03 19:35:33', '2022-05-28 14:34:15', '/reports/omsetdetail', 'Omset', 'Reports');
INSERT INTO public.permissions VALUES (339, 'returnsell.getproducts', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (59, 'products.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/products', 'Produk', 'Products');
INSERT INTO public.permissions VALUES (114, 'productsstock.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productsstock', 'Stok', 'Products');
INSERT INTO public.permissions VALUES (161, 'productsdistribution.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productsdistribution', 'Distribusi Produk', 'Products');
INSERT INTO public.permissions VALUES (205, 'purchaseorders.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/purchaseorders', 'Pembelian Barang', 'Transactions');
INSERT INTO public.permissions VALUES (300, 'reports.purchase.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/purchase', 'Pembelian', 'Reports');
INSERT INTO public.permissions VALUES (302, 'reports.customer.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/customer', 'Pelanggan', 'Reports');
INSERT INTO public.permissions VALUES (304, 'reports.receive.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/receive', 'Penerimaan Barang', 'Reports');
INSERT INTO public.permissions VALUES (306, 'reports.stockmutation.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/stockmutation', 'Mutasi Stok', 'Reports');
INSERT INTO public.permissions VALUES (308, 'reports.stock.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/stock', 'Stok Barang', 'Reports');
INSERT INTO public.permissions VALUES (311, 'reports.usertracking.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/usertracking', 'Mutasi Pengguna', 'Reports');
INSERT INTO public.permissions VALUES (327, 'returnsell.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/returnsell', 'Pengembalian', 'Transactions');
INSERT INTO public.permissions VALUES (346, 'servicespoint.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/servicespoint', 'Poin', 'Services');
INSERT INTO public.permissions VALUES (350, 'services.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/services', 'Perawatan', 'Services');
INSERT INTO public.permissions VALUES (347, 'servicescommision.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/servicescommision', 'Komisi Perawatan', 'Services');
INSERT INTO public.permissions VALUES (89, 'productsprice.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/productsprice', ' Harga Produk', 'Products');
INSERT INTO public.permissions VALUES (351, 'servicesprice.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/servicesprice', 'Harga Perawatan', 'Services');
INSERT INTO public.permissions VALUES (343, 'servicesbrand.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/servicesbrand', 'Merek', 'Services');
INSERT INTO public.permissions VALUES (344, 'uomservice.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/uomservice', 'Satuan', 'Services');
INSERT INTO public.permissions VALUES (348, 'servicescommisionbyyear.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/servicescommisionbyyear', 'Komisi Perawatan Tahun', 'Services');
INSERT INTO public.permissions VALUES (345, 'categoriesservice.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/categoriesservice', 'Kategori', 'Services');
INSERT INTO public.permissions VALUES (349, 'servicespriceadj.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/servicespriceadj', 'Penyesuaian Harga', 'Services');
INSERT INTO public.permissions VALUES (354, 'services.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (355, 'services.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (356, 'services.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (357, 'services.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (358, 'products.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (359, 'services.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (360, 'services.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (361, 'services.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (362, 'services.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (363, 'services.addingredients', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (364, 'services.deleteingredients', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (366, 'servicesprice.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (367, 'servicesprice.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (368, 'servicesprice.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (369, 'servicesprice.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (370, 'servicesprice.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (371, 'servicesprice.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (372, 'servicesprice.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (373, 'servicesprice.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (365, 'servicesprice.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (374, 'servicesbrand.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (375, 'servicesbrand.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (376, 'servicesbrand.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (377, 'servicesbrand.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (378, 'servicesbrand.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (379, 'servicesbrand.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (380, 'uomservice.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (381, 'uomservice.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (382, 'uomservice.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (383, 'uomservice.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (384, 'uomservice.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (385, 'uomservice.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (386, 'uomservice.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (387, 'categoriesservice.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (388, 'categoriesservice.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (389, 'categoriesservice.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (315, 'reports.invoice.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/invoice', 'Faktur', 'Reports');
INSERT INTO public.permissions VALUES (335, 'reports.returnsell.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/returnsell', 'Pengembalian', 'Reports');
INSERT INTO public.permissions VALUES (390, 'categoriesservice.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (391, 'categoriesservice.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (392, 'categoriesservice.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (393, 'categoriesservice.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (439, 'invoices.printspk', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (353, 'servicesdistribution.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/servicesdistribution', 'Distribusi Perawatan', 'Services');
INSERT INTO public.permissions VALUES (394, 'servicesdistribution.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (395, 'servicesdistribution.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (396, 'servicesdistribution.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (397, 'servicesdistribution.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (398, 'servicesdistribution.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (399, 'servicesdistribution.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (400, 'servicesdistribution.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (401, 'servicesdistribution.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (402, 'servicesdistribution.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (403, 'servicespoint.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (404, 'servicespoint.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (405, 'servicespoint.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (406, 'servicespoint.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (407, 'servicespoint.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (408, 'servicespoint.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (409, 'servicespoint.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (410, 'servicespoint.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (411, 'servicespoint.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (412, 'servicescommision.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (413, 'servicescommision.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (414, 'servicescommision.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (415, 'servicescommision.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (416, 'servicescommision.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (417, 'servicescommision.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (418, 'servicescommision.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (419, 'servicescommision.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (420, 'servicescommision.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (421, 'servicescommisionbyyear.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (422, 'servicescommisionbyyear.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (423, 'servicescommisionbyyear.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (424, 'servicescommisionbyyear.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (425, 'servicescommisionbyyear.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (426, 'servicescommisionbyyear.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (427, 'servicescommisionbyyear.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (428, 'servicescommisionbyyear.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (429, 'servicescommisionbyyear.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (430, 'servicespriceadj.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (431, 'servicespriceadj.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (432, 'servicespriceadj.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (433, 'servicespriceadj.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (434, 'servicespriceadj.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (435, 'servicespriceadj.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (436, 'servicespriceadj.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (437, 'servicespriceadj.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (438, 'servicespriceadj.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (298, 'reports.invoicedetail.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/invoicedetail', 'Faktur Detail per Barang', 'Reports');
INSERT INTO public.permissions VALUES (295, 'reports.closeday.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/closeday', 'Serah Terima Harian', 'Reports');
INSERT INTO public.permissions VALUES (440, 'invoices.checkout', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (193, 'reports.terapist.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/terapist', 'Komisi Terapis Detail', 'Reports');
INSERT INTO public.permissions VALUES (441, 'reports.terapistdaily.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/terapistdaily', 'Komisi Terapis Harian', 'Reports');
INSERT INTO public.permissions VALUES (442, 'reports.terapistdaily.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (443, 'invoices.printsj', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (444, 'branchshift.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (446, 'branchshift.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (447, 'branchshift.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (448, 'branchshift.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (449, 'branchshift.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (450, 'branchshift.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (451, 'branchshift.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (452, 'branchshift.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (453, 'branchshift.storeapi', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (454, 'branchshift.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/branchshift', 'Shift Cabang', 'Settings');
INSERT INTO public.permissions VALUES (445, 'branchshift.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (336, 'reports.returnselldetail.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/returnselldetail', 'Pengembalian Detail per Barang', 'Reports');
INSERT INTO public.permissions VALUES (455, 'reports.returnsell.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (456, 'reports.returnselldetail.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (457, 'purchaseordersinternal.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (458, 'purchaseordersinternal.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (459, 'purchaseorders.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (460, 'purchaseorders.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (461, 'purchaseordersinternal.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (462, 'purchaseordersinternal.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (463, 'purchaseordersinternal.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (464, 'purchaseordersinternal.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (465, 'purchaseordersinternal.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (466, 'purchaseordersinternal.getproduct', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (467, 'purchaseordersinternal.getorder', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (468, 'purchaseorders.getdocdata', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (469, 'purchaseordersinternal.print', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (470, 'purchaseordersinternal.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/purchaseordersinternal', 'Pembelian Internal Cabang', 'Transactions');
INSERT INTO public.permissions VALUES (471, 'purchaseordersinternal.updatestatus', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '', '', '');
INSERT INTO public.permissions VALUES (472, 'invoicesinternal.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (473, 'invoicesinternal.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (474, 'invoicesinternal.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (475, 'invoicesinternal.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (476, 'invoicesinternal.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (477, 'invoicesinternal.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (478, 'invoicesinternal.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (479, 'invoicesinternal.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (480, 'invoicesinternal.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (481, 'invoicesinternal.getproduct', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (482, 'invoicesinternal.gettimetable', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (483, 'invoicesinternal.getinvoice', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (485, 'invoicesinternal.print', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (486, 'invoicesinternal.printthermal', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (487, 'invoicesinternal.printspk', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (488, 'invoicesinternal.checkout', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (489, 'invoicesinternal.printsj', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (484, 'invoicesinternal.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/invoicesinternal', 'Faktur Jual Internal', 'Transactions');
INSERT INTO public.permissions VALUES (490, 'sales.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (491, 'sales.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (492, 'sales.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (493, 'sales.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (494, 'sales.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (495, 'sales.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (496, 'sales.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (497, 'sales.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (498, 'sales.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions VALUES (499, 'sales.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/sales', 'Sales', 'Users');
INSERT INTO public.permissions VALUES (500, 'sales.storeapi', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);


--
-- TOC entry 3705 (class 0 OID 18091)
-- Dependencies: 233
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3707 (class 0 OID 18099)
-- Dependencies: 235
-- Data for Name: point_conversion; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.point_conversion VALUES (4, 8000);
INSERT INTO public.point_conversion VALUES (5, 12000);
INSERT INTO public.point_conversion VALUES (6, 17000);
INSERT INTO public.point_conversion VALUES (7, 23000);
INSERT INTO public.point_conversion VALUES (8, 30000);
INSERT INTO public.point_conversion VALUES (9, 30000);
INSERT INTO public.point_conversion VALUES (10, 30000);
INSERT INTO public.point_conversion VALUES (11, 30000);
INSERT INTO public.point_conversion VALUES (12, 30000);
INSERT INTO public.point_conversion VALUES (13, 30000);
INSERT INTO public.point_conversion VALUES (14, 30000);
INSERT INTO public.point_conversion VALUES (15, 30000);
INSERT INTO public.point_conversion VALUES (16, 30000);
INSERT INTO public.point_conversion VALUES (17, 30000);
INSERT INTO public.point_conversion VALUES (18, 30000);
INSERT INTO public.point_conversion VALUES (19, 30000);
INSERT INTO public.point_conversion VALUES (20, 30000);


--
-- TOC entry 3708 (class 0 OID 18104)
-- Dependencies: 236
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.posts VALUES (2, 1, '1', '12', '1', '2022-05-28 15:29:26', '2022-05-28 15:29:30');


--
-- TOC entry 3710 (class 0 OID 18112)
-- Dependencies: 238
-- Data for Name: price_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.price_adjustment VALUES (1, 1, 1, '2022-09-01', '2022-09-30', 500, 1, '2022-09-18 01:29:54', '2022-09-17 12:29:14.427409');
INSERT INTO public.price_adjustment VALUES (5, 2, 1, '2022-09-01', '2022-09-30', 500, 1, '2022-09-18 01:29:54', '2022-09-17 12:29:14.427409');
INSERT INTO public.price_adjustment VALUES (6, 3, 1, '2022-09-01', '2022-09-30', 500, 1, '2022-09-18 01:29:54', '2022-09-17 12:29:14.427409');
INSERT INTO public.price_adjustment VALUES (7, 1, 70, '2022-12-15', '2022-12-17', 100000, 1, '2022-12-17 21:55:29', '2022-12-17 21:55:29');
INSERT INTO public.price_adjustment VALUES (8, 1, 57, '2022-12-17', '2022-12-17', 1000, 1, '2022-12-17 21:57:01', '2022-12-17 21:57:01');


--
-- TOC entry 3712 (class 0 OID 18119)
-- Dependencies: 240
-- Data for Name: product_brand; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_brand VALUES (2, 'ACL', '2022-06-01 20:47:29.580415', NULL, 1);
INSERT INTO public.product_brand VALUES (3, 'Bali Alus', '2022-06-01 20:47:29.582037', NULL, 1);
INSERT INTO public.product_brand VALUES (4, 'Green Spa', '2022-06-01 20:47:29.583737', NULL, 1);
INSERT INTO public.product_brand VALUES (5, 'Biokos', '2022-06-01 20:47:29.585597', NULL, 1);
INSERT INTO public.product_brand VALUES (6, 'Ianthe', '2022-06-01 20:47:29.587679', NULL, 1);
INSERT INTO public.product_brand VALUES (8, 'Wardah', '2022-07-21 16:34:24', '2022-07-21 16:40:55', 1);
INSERT INTO public.product_brand VALUES (9, 'Other', '2022-10-09 03:04:25', '2022-10-09 03:04:25', 1);
INSERT INTO public.product_brand VALUES (1, 'General', '2022-06-01 20:47:29.575876', NULL, 2);


--
-- TOC entry 3714 (class 0 OID 18129)
-- Dependencies: 242
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_category VALUES (7, 'Serum', '2022-06-01 20:43:14.607895', NULL, 1);
INSERT INTO public.product_category VALUES (8, 'Gel', '2022-06-01 20:43:14.607895', NULL, 1);
INSERT INTO public.product_category VALUES (9, 'Cream', '2022-06-01 20:43:14.607895', NULL, 1);
INSERT INTO public.product_category VALUES (10, 'Spray', '2022-06-01 20:43:14.607895', NULL, 1);
INSERT INTO public.product_category VALUES (11, 'Sabun', '2022-06-01 20:43:14.607895', NULL, 1);
INSERT INTO public.product_category VALUES (12, 'Minuman', '2022-06-01 20:43:14.607895', NULL, 1);
INSERT INTO public.product_category VALUES (13, 'Masker', '2022-06-01 20:43:14.607895', NULL, 1);
INSERT INTO public.product_category VALUES (1, 'Treatment Body', '2022-06-01 20:43:14.593652', NULL, 2);
INSERT INTO public.product_category VALUES (2, 'Treatment Face', '2022-06-01 20:43:14.599894', NULL, 2);
INSERT INTO public.product_category VALUES (3, 'Treatment Female', '2022-06-01 20:43:14.60163', NULL, 2);
INSERT INTO public.product_category VALUES (4, 'Treatment Scrub', '2022-06-01 20:43:14.603521', NULL, 2);
INSERT INTO public.product_category VALUES (5, 'Treatment Foot', '2022-06-01 20:43:14.605776', NULL, 2);
INSERT INTO public.product_category VALUES (6, 'Add Ons', '2022-06-01 20:43:14.607895', NULL, 2);
INSERT INTO public.product_category VALUES (15, 'Extra', '2022-10-09 03:05:29', '2022-10-09 03:05:29', 2);


--
-- TOC entry 3716 (class 0 OID 18139)
-- Dependencies: 244
-- Data for Name: product_commision_by_year; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_commision_by_year VALUES (39, 1, 2, 1, 30000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 1, 2, 1, 30000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 1, 2, 1, 30000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 1, 2, 1, 30000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 1, 2, 5, 30000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 1, 2, 5, 30000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 1, 2, 5, 30000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 1, 2, 5, 30000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 1, 2, 1, 22000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 1, 2, 1, 22000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 1, 2, 1, 22000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 1, 2, 1, 22000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 1, 2, 1, 17000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 1, 2, 1, 17000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 1, 2, 1, 25000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 1, 2, 1, 15000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 1, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 1, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 1, 2, 1, 40000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 1, 2, 1, 20000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 1, 2, 1, 10000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 1, 2, 1, 10000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 1, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 1, 2, 1, 50000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 1, 2, 1, 55000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 1, 2, 1, 15000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 1, 2, 1, 10000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 1, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 1, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 1, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 1, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 1, 2, 1, 10000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 1, 2, 1, 7000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 1, 2, 2, 32000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 1, 2, 3, 34000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 1, 2, 4, 36000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 1, 2, 5, 38000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 1, 2, 2, 32000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 1, 2, 4, 36000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 1, 2, 5, 38000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 1, 2, 2, 32000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 1, 2, 3, 34000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 1, 2, 4, 36000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 1, 2, 5, 38000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 1, 2, 2, 24000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 1, 2, 3, 26000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 1, 2, 4, 28000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 1, 2, 5, 30000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 1, 2, 2, 24000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 1, 2, 3, 26000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 1, 2, 4, 28000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 1, 2, 2, 24000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 1, 2, 4, 28000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 1, 2, 2, 24000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 1, 2, 3, 26000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 1, 2, 4, 28000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 1, 2, 2, 24000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 1, 2, 3, 26000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 1, 2, 4, 28000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 1, 2, 2, 19000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 1, 2, 3, 21000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 1, 2, 4, 23000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 1, 2, 5, 25000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 1, 2, 2, 19000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 1, 2, 3, 21000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 1, 2, 4, 23000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 1, 2, 2, 27000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 1, 2, 3, 29000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 1, 2, 4, 31000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 1, 2, 5, 33000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 1, 2, 2, 17000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 1, 2, 3, 19000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 1, 2, 4, 21000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 1, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 1, 2, 3, 8000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 1, 2, 4, 9000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 1, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 1, 2, 3, 8000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 1, 2, 4, 8000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 1, 2, 2, 42000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 1, 2, 4, 46000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 1, 2, 2, 22000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 1, 2, 3, 24000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 1, 2, 4, 26000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 1, 2, 2, 10000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 1, 2, 3, 12000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 1, 2, 4, 12000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 1, 2, 2, 10000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 1, 2, 3, 12000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 1, 2, 4, 12000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 1, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 1, 2, 3, 9000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 1, 2, 4, 9000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 1, 2, 2, 52000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 1, 2, 4, 56000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 1, 2, 2, 32000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 1, 2, 3, 34000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 1, 2, 4, 36000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 1, 2, 2, 27000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 1, 2, 3, 29000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 1, 2, 4, 31000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 1, 2, 2, 57000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 1, 2, 3, 59000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 1, 2, 4, 61000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 1, 2, 2, 17000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 1, 2, 3, 19000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 1, 2, 4, 21000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 1, 2, 2, 10000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 1, 2, 4, 16000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 1, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 1, 2, 3, 10000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 1, 2, 4, 10000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 1, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 1, 2, 3, 10000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 1, 2, 4, 10000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 1, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 1, 2, 3, 10000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 1, 2, 4, 10000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 1, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 1, 2, 3, 8000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 1, 2, 4, 9000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 1, 2, 2, 7000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 1, 2, 4, 8000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 1, 2, 2, 10000, 1, '2022-06-03 18:50:52.711437', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 1, 2, 3, 10000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 1, 2, 4, 11000, 1, '2022-06-03 18:51:04.512776', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 1, 2, 7, 30000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 1, 2, 7, 42000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 1, 2, 8, 44000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 1, 2, 6, 40000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 1, 2, 7, 42000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 1, 2, 8, 44000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 1, 2, 9, 46000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 1, 2, 6, 40000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 1, 2, 7, 42000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 1, 2, 8, 44000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 1, 2, 9, 46000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 1, 2, 6, 32000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 1, 2, 7, 34000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 1, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 1, 2, 9, 38000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 1, 2, 6, 32000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 1, 2, 7, 34000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 1, 2, 9, 38000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 1, 2, 6, 32000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 1, 2, 7, 34000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 1, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 1, 2, 9, 38000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 1, 2, 6, 32000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 1, 2, 7, 34000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 1, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 1, 2, 9, 38000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 1, 2, 6, 32000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 1, 2, 7, 34000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 1, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 1, 2, 9, 38000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 1, 2, 6, 27000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 1, 2, 8, 31000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 1, 2, 9, 33000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 1, 2, 6, 27000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 1, 2, 7, 29000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 1, 2, 8, 31000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 1, 2, 9, 33000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 1, 2, 6, 34000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 1, 2, 7, 35000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 1, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 1, 2, 9, 37000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 1, 2, 5, 23000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 1, 2, 6, 25000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 1, 2, 7, 27000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 1, 2, 8, 29000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 1, 2, 5, 9000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 1, 2, 6, 9000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 1, 2, 7, 10000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 1, 2, 8, 10000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 1, 2, 9, 10000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 1, 2, 5, 8000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 1, 2, 6, 8000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 1, 2, 7, 8000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 1, 2, 8, 8000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 1, 2, 9, 8000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 1, 2, 5, 48000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 1, 2, 6, 50000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 1, 2, 7, 52000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 1, 2, 8, 54000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 1, 2, 5, 28000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 1, 2, 6, 29000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 1, 2, 8, 31000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 1, 2, 9, 32000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 1, 2, 5, 14000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 1, 2, 6, 14000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 1, 2, 7, 16000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 1, 2, 8, 16000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 1, 2, 9, 18000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 1, 2, 5, 14000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 1, 2, 6, 14000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 1, 2, 7, 16000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 1, 2, 8, 16000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 1, 2, 9, 18000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 1, 2, 6, 10000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 1, 2, 7, 11000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 1, 2, 8, 11000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 1, 2, 9, 12000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 1, 2, 5, 58000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 1, 2, 6, 60000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 1, 2, 7, 62000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 1, 2, 8, 64000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 1, 2, 9, 66000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 1, 2, 5, 38000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 1, 2, 6, 39000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 1, 2, 7, 40000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 1, 2, 8, 41000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 1, 2, 9, 42000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 1, 2, 6, 34000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 1, 2, 7, 35000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 1, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 1, 2, 9, 37000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 1, 2, 5, 63000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 1, 2, 6, 65000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 1, 2, 7, 67000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 1, 2, 8, 69000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 1, 2, 9, 71000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 1, 2, 5, 23000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 1, 2, 6, 25000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 1, 2, 7, 27000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 1, 2, 8, 29000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 1, 2, 5, 18000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 1, 2, 7, 20000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 1, 2, 8, 21000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 1, 2, 5, 12000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 1, 2, 6, 12000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 1, 2, 7, 14000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 1, 2, 8, 14000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 1, 2, 5, 12000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 1, 2, 6, 12000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 1, 2, 7, 14000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 1, 2, 8, 14000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 1, 2, 5, 12000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 1, 2, 6, 12000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 1, 2, 7, 14000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 1, 2, 8, 14000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 1, 2, 6, 9000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 1, 2, 7, 10000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 1, 2, 8, 10000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 1, 2, 5, 8000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 1, 2, 6, 8000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 1, 2, 7, 9000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 1, 2, 8, 9000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 1, 2, 5, 11000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 1, 2, 6, 11000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 1, 2, 7, 12000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 1, 2, 8, 12000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 1, 2, 1, 22000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 1, 2, 1, 25000, 1, '2022-06-03 18:50:28.944639', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 1, 2, 6, 40000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 1, 2, 9, 46000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (39, 1, 2, 10, 48000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 1, 2, 3, 34000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (40, 1, 2, 10, 48000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (41, 1, 2, 10, 48000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (42, 1, 2, 10, 40000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 1, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736', NULL);
INSERT INTO public.product_commision_by_year VALUES (43, 1, 2, 10, 40000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 1, 2, 3, 26000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (44, 1, 2, 10, 40000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (45, 1, 2, 10, 40000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (46, 1, 2, 10, 40000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 1, 2, 7, 29000, 1, '2022-06-03 18:51:18.966034', NULL);
INSERT INTO public.product_commision_by_year VALUES (47, 1, 2, 10, 35000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 1, 2, 5, 25000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (48, 1, 2, 10, 35000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (49, 1, 2, 10, 38000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 1, 2, 9, 31000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (50, 1, 2, 10, 33000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (51, 1, 2, 10, 11000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (52, 1, 2, 10, 8000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 1, 2, 3, 44000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 1, 2, 9, 56000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (53, 1, 2, 10, 58000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (54, 1, 2, 10, 33000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (55, 1, 2, 10, 18000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (56, 1, 2, 10, 18000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 1, 2, 5, 10000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (57, 1, 2, 10, 12000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 1, 2, 3, 54000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (58, 1, 2, 10, 68000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (59, 1, 2, 10, 43000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 1, 2, 5, 33000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (60, 1, 2, 10, 38000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (61, 1, 2, 10, 73000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 1, 2, 9, 31000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (62, 1, 2, 10, 33000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 1, 2, 3, 14000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 1, 2, 6, 19000, 1, '2022-06-03 18:51:14.244667', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 1, 2, 9, 22000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (63, 1, 2, 10, 23000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 1, 2, 9, 16000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (64, 1, 2, 10, 16000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 1, 2, 9, 16000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (65, 1, 2, 10, 16000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 1, 2, 9, 16000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (66, 1, 2, 10, 16000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 1, 2, 5, 9000, 1, '2022-06-03 18:51:09.209737', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 1, 2, 9, 10000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (67, 1, 2, 10, 11000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 1, 2, 3, 7000, 1, '2022-06-03 18:50:57.947429', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 1, 2, 9, 9000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (68, 1, 2, 10, 10000, 1, '2022-06-03 18:51:32.672537', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 1, 2, 9, 12000, 1, '2022-06-03 18:51:27.832534', NULL);
INSERT INTO public.product_commision_by_year VALUES (69, 1, 2, 10, 13000, 1, '2022-06-03 18:51:32.672537', NULL);


--
-- TOC entry 3717 (class 0 OID 18143)
-- Dependencies: 245
-- Data for Name: product_commisions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_commisions VALUES (33, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (34, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (35, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (36, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (37, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (39, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (40, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (41, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (42, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (43, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (44, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (45, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (46, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (47, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (48, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (49, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (50, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (51, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (52, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (53, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (54, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (55, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (56, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (57, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (58, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (59, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (60, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (61, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (62, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (63, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (64, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (65, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (66, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (67, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (68, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (70, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (69, 1, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (1, 1, 0, 0, 25000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (2, 1, 2000, 10000, 12000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (3, 1, 0, 0, 50000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (4, 1, 0, 0, 25000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (5, 1, 0, 0, 25000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (6, 1, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (7, 1, 0, 0, 50000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (8, 1, 0, 0, 30000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (9, 1, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (11, 1, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (14, 1, 0, 0, 5000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (15, 1, 0, 0, 15000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (16, 1, 0, 0, 15000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (17, 1, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (18, 1, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (19, 1, 0, 0, 50000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (20, 1, 0, 0, 20000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (21, 1, 0, 0, 20000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (22, 1, 0, 0, 20000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (23, 1, 0, 0, 15000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (24, 1, 0, 0, 15000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (25, 1, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (26, 1, 0, 0, 25000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (27, 1, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (10, 1, 4000, 16000, 20000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (12, 1, 4000, 16000, 20000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (13, 1, 3000, 12000, 15000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (28, 1, 0, 0, 50000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (29, 1, 0, 0, 30000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (30, 1, 0, 0, 5000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (31, 1, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (32, 1, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '', NULL);
INSERT INTO public.product_commisions VALUES (76, 1, 5000, 7000, 6000, '2022-07-28 10:56:18', 1, NULL, '2022-07-28 10:57:53');


--
-- TOC entry 3718 (class 0 OID 18149)
-- Dependencies: 246
-- Data for Name: product_distribution; Type: TABLE DATA; Schema: public; Owner: postgres
--

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
INSERT INTO public.product_distribution VALUES (83, 1, '2022-10-09 03:15:42', '2022-10-09 03:15:42', 1);
INSERT INTO public.product_distribution VALUES (86, 1, '2022-10-09 03:16:21', '2022-10-09 03:16:21', 1);
INSERT INTO public.product_distribution VALUES (84, 1, '2022-10-09 03:16:43', '2022-10-09 03:16:43', 1);
INSERT INTO public.product_distribution VALUES (85, 1, '2022-10-09 03:17:05', '2022-10-09 03:17:05', 1);
INSERT INTO public.product_distribution VALUES (89, 1, '2022-10-15 20:39:51', '2022-10-15 20:39:51', 1);
INSERT INTO public.product_distribution VALUES (8, 1, '2022-06-02 21:03:50.006459', '2022-12-28 15:35:09', 1);
INSERT INTO public.product_distribution VALUES (1, 1, '2022-06-02 21:03:50.006459', '2022-12-30 19:16:18', 0);


--
-- TOC entry 3719 (class 0 OID 18154)
-- Dependencies: 247
-- Data for Name: product_ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_ingredients VALUES (52, 53, 1, 1, NULL, 1, '2022-09-07 20:23:11.759266');
INSERT INTO public.product_ingredients VALUES (1, 9, 17, 1, '2022-09-07 14:28:25', 1, '2022-09-07 14:28:25');
INSERT INTO public.product_ingredients VALUES (53, 34, 17, 100, '2022-09-07 14:56:43', 1, '2022-09-07 14:56:43');
INSERT INTO public.product_ingredients VALUES (1, 8, 12, 2, '2022-09-18 01:41:45', 1, '2022-09-18 01:41:45');


--
-- TOC entry 3720 (class 0 OID 18159)
-- Dependencies: 248
-- Data for Name: product_point; Type: TABLE DATA; Schema: public; Owner: postgres
--

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
INSERT INTO public.product_point VALUES (1, 1, 2, 1, '2022-06-02 21:09:40.977165', '2022-12-28 15:28:25');


--
-- TOC entry 3721 (class 0 OID 18163)
-- Dependencies: 249
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
-- TOC entry 3722 (class 0 OID 18167)
-- Dependencies: 250
-- Data for Name: product_sku; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_sku VALUES (36, 'GOLDA', 'GLDA', NULL, NULL, 12, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (65, 'Mandi Susu', 'SRVC ADN MND SSU', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (66, 'Body Cop Package', 'SRVC ADN BDY CP', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (67, 'Masker Badan', 'SRVC ADN MSK BDN', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (68, 'Steam Badan', 'SRVC STRM BDN', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (70, 'CELANA KAIN JUMBO', 'G CLN JMB', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (69, 'Extra Time', 'SRVC ADN EXT TME', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (83, 'Extra Charge Midnight 21:00', 'EXT-M21', NULL, NULL, 15, 8, 9, '2022-10-09 03:11:13', NULL, '2022-10-09 03:11:13', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (86, 'Extra Charge Gender', 'EXT-GD', NULL, NULL, 15, 8, 9, '2022-10-09 03:12:42', NULL, '2022-10-09 03:12:42', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (1, 'ACL - ANTISEPTIK GEL', 'ACL AG', NULL, NULL, 8, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (8, 'ACL - MILK BATH', 'ACL MB', NULL, NULL, 8, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (9, 'ACL - PENYEGAR WAJAH ', 'ACL PYGR WJ', NULL, NULL, 8, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (84, 'Extra Charge Midnight 22:00', 'EXT-M22', NULL, NULL, 15, 8, 9, '2022-10-09 03:11:41', NULL, '2022-10-09 03:11:41', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (85, 'Extra Charge Room', 'EXT-RM', NULL, NULL, 15, 8, 9, '2022-10-09 03:12:11', NULL, '2022-10-09 03:12:11', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (89, 'Test Kotak', 'KTK', NULL, NULL, 8, 1, 9, '2022-10-15 20:37:29', NULL, '2022-10-15 20:37:29', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (10, 'BALI ALUS - BODY WITHENING', 'BA BW', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (11, 'BALI ALUS - DUDUS CELUP ', 'BA DC', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (12, 'BALI ALUS - LIGHTENING', 'BA LGHTN', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (13, 'BALI ALUS - LULUR GREENTEA', 'BA LLR GRNT', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (18, 'BALI ALUS - SWETY SLIMM', 'BA SWTY SLM', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (19, 'NELAYAN NUSANTARA BATHSALT VCO RELAX', 'NN BTHSLT VCO', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (20, 'GREEN SPA LULUR BALI ALUS', 'GS LLR BA', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (21, 'BIOKOS - CLEANSER', 'BK CLNSR', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (24, 'BIOKOS - PEELING', 'BK  PLNG', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (27, 'CELANA KAIN STANDAR', 'G CLN STD', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (28, 'HERBAL COMPRESS', 'G HRBL COMPS', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (29, 'KOP BADAN BESAR', 'G KOP BDN L', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (30, 'LILIN EC', 'G LLN EC', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (31, 'TATAKAN WAJAH JELLY', 'G WJH JLLY', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (33, 'KAYU REFLEKSI SEGITIGA', 'G KYU RFL S3', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (34, 'KAYU REFLEKSI BINTANG', 'G KYU RFL STR', NULL, NULL, 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (2, 'ACL - CREAM HANGAT BUNGKUS', 'ACL CH B', NULL, NULL, 9, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (3, 'ACL - CREAM HANGAT BOTOL', 'ACL CH BT', NULL, NULL, 9, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (4, 'ACL - FOOT SPRAY', 'ACL FS', NULL, NULL, 10, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (5, 'ACL - LINEN SPRAY', 'ACL LS', NULL, NULL, 10, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (32, 'PEELING SPRAY', 'G PLLG SPRY', NULL, NULL, 10, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (6, 'ACL - MASSAGE CREAM BUNGAN JEPUN', 'ACL MSG CRM BJ', NULL, NULL, 9, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (22, 'BIOKOS - CREAM MASSAGE ', 'BK CRM MSSG', NULL, NULL, 9, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (7, 'ACL - MASKER BADAN', 'ACL MSK BD', NULL, NULL, 13, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (14, 'BALI ALUS - MASKER ARMPIT', 'BA MSK ARMP', NULL, NULL, 13, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (15, 'BALI ALUS - MASKER PAYUDARA B', 'BA MSK PYDR B', NULL, NULL, 13, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (16, 'BALI ALUS - MASKER PAYUDARA K', 'BA MSK PYDR K', NULL, NULL, 13, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (23, 'BIOKOS - GELK MASK', 'BK GLK MSK', NULL, NULL, 13, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (35, 'THE BANDULAN ', 'BDLN', NULL, NULL, 12, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (37, 'GREAT', 'G GRT', NULL, NULL, 12, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (25, 'IANTHE SERUM VITAMIN C 5 ML', 'IT SRM VIT C 5ML', NULL, NULL, 7, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (26, 'IANTHE SERUM VITAMIN C 100 ML', 'IT SRM VIT C 100ML', NULL, NULL, 7, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (17, 'BALI ALUS - SABUN SIRIH', 'BA SBN SRH', NULL, NULL, 11, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (39, 'Mixing Thai', 'SRVC B MT', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (40, 'Body Herbal Compress ', 'SRVC B BHC', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (41, 'Shiatsu', 'SRVC B SHSU', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (42, 'Dry Massage', 'SRVC B DRY MSG', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (43, 'Tuina', 'SRVC B TNA', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (44, 'Hot Stone', 'SRVC B HOT STN', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (45, 'Full Body Reflexology', 'SRVC B FULL BD RF', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (46, 'Full Body Therapy', 'SRVC B FULL BD TR', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (47, 'Back Massage / Dry', 'SRVC B BCK MSG', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (48, 'Body Cop With Massage', 'SRVC B BCOP MSG', NULL, NULL, 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (49, 'Facial Biokos and Accu Aura With Vitamin', 'SRVC F BKOS AUR', NULL, NULL, 2, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (50, 'Face Refreshing Biokos', 'SRVC F BKOS RFHS', NULL, NULL, 2, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (51, 'Ear Candling', 'SRVC F EAR CDL', NULL, NULL, 2, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (52, 'Accu Aura', 'SRVC F ACC AURA', NULL, NULL, 2, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (53, 'V- Spa', 'SRVC FL VSPA', NULL, NULL, 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (54, 'Breast and Slimming Therapy', 'SRVC FL BRST SLMM TRP', NULL, NULL, 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (55, 'Slimming', 'SRVC FL SLMM', NULL, NULL, 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (56, 'Breast', 'SRVC FL BRST', NULL, NULL, 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (57, 'Ratus With Hand Massage', 'SRVC FL RTS HND MSG', NULL, NULL, 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (58, 'Executive Bali Body Scrub', 'SRVC SC BDY SCRB', NULL, NULL, 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (59, 'Body Bleacing Package', 'SRVC SC BDY  BLCH', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (60, 'Bali Alus Body Scrub', 'SRVC BA BDY SCRB', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (61, 'Lulur Aromatherapy', 'SRVC BA LLR ARMTRY', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (62, 'Foot Reflexology', 'SRVC FT REFKS', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (63, 'Foot Express', 'SRVC FT REFKS EPRS', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (64, 'Herbal Compress', 'SRVC ADN HRBL CMPS', NULL, NULL, 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1, 0, 1, 'goods.png');
INSERT INTO public.product_sku VALUES (90, 'GARAM NETRAL', 'GI NETRAL', NULL, NULL, 11, 1, 3, '2022-12-28 14:26:27', NULL, '2022-12-28 14:26:27', 1, 0, 1, 'goods.png');


--
-- TOC entry 3724 (class 0 OID 18178)
-- Dependencies: 252
-- Data for Name: product_stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_stock VALUES (53, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (55, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (8, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (9, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (11, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (13, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
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
INSERT INTO public.product_stock VALUES (32, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (22, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (7, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (14, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (15, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (16, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (37, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (26, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (41, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (44, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (49, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (53, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (54, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (55, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (56, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (57, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (58, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (61, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (62, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (64, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (65, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
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
INSERT INTO public.product_stock VALUES (11, 2, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (20, 2, 9994, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (28, 2, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (67, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (40, 1, 9999, '2022-09-17 08:40:20.881436', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (18, 1, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (39, 1, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (6, 1, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (4, 1, 9996, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (76, 2, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (1, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (8, 3, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (1, 1, 9989, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (60, 1, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (23, 1, 9999, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (66, 1, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (5, 1, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (48, 1, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (12, 1, 9993, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (25, 1, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (46, 1, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (42, 1, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (43, 1, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (51, 1, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (50, 1, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (36, 1, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (35, 1, 9997, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (3, 1, 9997, '2022-12-30 09:01:45.474171', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (47, 1, 9994, NULL, '2022-07-25 18:26:06.816842', 1);
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
INSERT INTO public.product_stock VALUES (21, 1, 9999, '2022-11-26 15:35:45.617375', '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (45, 1, 9995, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (63, 1, 9998, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (52, 1, 9995, NULL, '2022-07-25 18:26:06.816842', 1);
INSERT INTO public.product_stock VALUES (59, 1, 10000, '2022-09-17 08:40:20.886402', '2022-07-25 18:26:06.816842', 1);


--
-- TOC entry 3725 (class 0 OID 18183)
-- Dependencies: 253
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
INSERT INTO public.product_stock_detail VALUES (24, 3, 1, 1, '2024-12-30', NULL, '2022-12-30 09:01:45.497399', 1);


--
-- TOC entry 3727 (class 0 OID 18191)
-- Dependencies: 255
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_type VALUES (3, 'Goods & Services', '2022-06-01 21:02:38.43164', NULL);
INSERT INTO public.product_type VALUES (2, 'Services', '2022-06-01 21:02:38.43164', NULL);
INSERT INTO public.product_type VALUES (1, 'Goods', '2022-06-01 21:02:38.43164', NULL);
INSERT INTO public.product_type VALUES (7, 'Misc', '2022-07-25 14:53:50', '2022-07-25 14:53:50');
INSERT INTO public.product_type VALUES (8, 'Extra', '2022-10-09 03:05:18', '2022-10-09 03:05:18');


--
-- TOC entry 3729 (class 0 OID 18200)
-- Dependencies: 257
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
INSERT INTO public.product_uom VALUES (90, 2, '2022-12-28 14:26:27', NULL, '2022-12-28 14:26:27');


--
-- TOC entry 3732 (class 0 OID 18215)
-- Dependencies: 260
-- Data for Name: purchase_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.purchase_detail VALUES ('PO-001-2022-00000012', 59, 'Body Bleacing Package', '100 Menit', 0, 1, 185000, 1000, 11.00, 20240.00, 184000, 204240.00, '2022-09-17 00:06:28', '2022-09-17 00:06:28');
INSERT INTO public.purchase_detail VALUES ('PO-001-2022-00000012', 40, 'Body Herbal Compress', '120 Menit', 1, 1, 160000, 2000, 11.00, 17380.00, 158000, 175380.00, '2022-09-17 00:06:28', '2022-09-17 00:06:28');
INSERT INTO public.purchase_detail VALUES ('PO-001-2022-00000013', 59, 'Body Bleacing Package', '100 Menit', 0, 1, 185000, 0, 11.00, 20350.00, 185000, 205350.00, '2022-10-22 15:53:51', '2022-10-22 15:53:51');
INSERT INTO public.purchase_detail VALUES ('PO-001-2022-00000001', 13, 'BALI ALUS - LULUR GREENTEA', 'Buah', 0, 1, 40000, 0, 11.00, 4400.00, 40000, 44400.00, '2022-11-26 01:26:29', '2022-11-26 01:26:29');
INSERT INTO public.purchase_detail VALUES ('PO-001-2022-00000002', 3, 'ACL - CREAM HANGAT BOTOL', 'Botol', 0, 1, 250000, 0, 0.00, 0.00, 250000, 250000.00, '2022-12-30 15:53:56', '2022-12-30 15:53:56');


--
-- TOC entry 3733 (class 0 OID 18230)
-- Dependencies: 261
-- Data for Name: purchase_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.purchase_master VALUES (12, 'PO-001-2022-00000012', '2022-09-16', 2, '2 - Test Supplier 02', 1, 'HEAD QUARTER', 379620, 37620, 0, 3000, 'ABC', NULL, 0, '2022-09-17 06:13:16.979111', NULL, NULL, 1, '2022-09-17 00:06:28', 1, '2022-09-16 23:13:16', 0, 0);
INSERT INTO public.purchase_master VALUES (15, 'PO-001-2022-00000013', '2022-10-22', 2, 'Test Supplier 02', 1, 'HEAD QUARTER', 205350, 20350, 0, 0, NULL, NULL, 0, '2022-10-22 15:53:51.479455', NULL, NULL, NULL, '2022-10-22 15:53:51', 1, '2022-10-22 15:53:51', 0, 0);
INSERT INTO public.purchase_master VALUES (17, 'PO-001-2022-00000001', '2022-11-26', 1, 'Test Supplier 010', 1, 'HEAD QUARTER', 44400, 4400, 0, 0, NULL, NULL, 0, '2022-11-26 01:26:29.149969', NULL, NULL, NULL, '2022-11-26 01:26:29', 1, '2022-11-26 01:26:29', 0, 0);
INSERT INTO public.purchase_master VALUES (18, 'PO-001-2022-00000002', '2022-12-30', 1, 'Test Supplier 010', 1, 'HEAD QUARTER', 250000, 0, 0, 0, NULL, NULL, 0, '2022-12-30 08:53:56.920677', NULL, NULL, NULL, '2022-12-30 15:53:56', 1, '2022-12-30 15:53:56', 0, 0);


--
-- TOC entry 3735 (class 0 OID 18248)
-- Dependencies: 263
-- Data for Name: receive_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.receive_detail VALUES ('RCV-001-2022-00000003', 3, 'ACL - CREAM HANGAT BOTOL', 1, 250000, 250000, 0, 0, '2023-12-30', NULL, '2022-12-30 16:01:45', '2022-12-30 16:01:45', 'Botol', 11);


--
-- TOC entry 3736 (class 0 OID 18262)
-- Dependencies: 264
-- Data for Name: receive_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.receive_master VALUES (31, 'RCV-001-2022-00000003', '2022-12-30', 1, '1 - Test Supplier 010', 250000, 0, 0, 0, NULL, NULL, 0, '2022-12-30 09:01:45.338489', 1, 'HEAD QUARTER', 'PO-001-2022-00000002', NULL, NULL, '2022-12-30 16:01:45', 1, '2022-12-30 16:01:45', 0, 0);


--
-- TOC entry 3738 (class 0 OID 18280)
-- Dependencies: 266
-- Data for Name: return_sell_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3739 (class 0 OID 18292)
-- Dependencies: 267
-- Data for Name: return_sell_master; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3741 (class 0 OID 18311)
-- Dependencies: 269
-- Data for Name: role_has_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.role_has_permissions VALUES (461, 1);
INSERT INTO public.role_has_permissions VALUES (462, 1);
INSERT INTO public.role_has_permissions VALUES (463, 1);
INSERT INTO public.role_has_permissions VALUES (464, 1);
INSERT INTO public.role_has_permissions VALUES (465, 1);
INSERT INTO public.role_has_permissions VALUES (466, 1);
INSERT INTO public.role_has_permissions VALUES (467, 1);
INSERT INTO public.role_has_permissions VALUES (468, 1);
INSERT INTO public.role_has_permissions VALUES (469, 1);
INSERT INTO public.role_has_permissions VALUES (470, 1);
INSERT INTO public.role_has_permissions VALUES (471, 1);
INSERT INTO public.role_has_permissions VALUES (472, 1);
INSERT INTO public.role_has_permissions VALUES (473, 1);
INSERT INTO public.role_has_permissions VALUES (474, 1);
INSERT INTO public.role_has_permissions VALUES (475, 1);
INSERT INTO public.role_has_permissions VALUES (476, 1);
INSERT INTO public.role_has_permissions VALUES (477, 1);
INSERT INTO public.role_has_permissions VALUES (478, 1);
INSERT INTO public.role_has_permissions VALUES (479, 1);
INSERT INTO public.role_has_permissions VALUES (480, 1);
INSERT INTO public.role_has_permissions VALUES (481, 1);
INSERT INTO public.role_has_permissions VALUES (482, 1);
INSERT INTO public.role_has_permissions VALUES (483, 1);
INSERT INTO public.role_has_permissions VALUES (484, 1);
INSERT INTO public.role_has_permissions VALUES (485, 1);
INSERT INTO public.role_has_permissions VALUES (486, 1);
INSERT INTO public.role_has_permissions VALUES (487, 1);
INSERT INTO public.role_has_permissions VALUES (2, 1);
INSERT INTO public.role_has_permissions VALUES (4, 1);
INSERT INTO public.role_has_permissions VALUES (5, 1);
INSERT INTO public.role_has_permissions VALUES (6, 1);
INSERT INTO public.role_has_permissions VALUES (7, 1);
INSERT INTO public.role_has_permissions VALUES (9, 1);
INSERT INTO public.role_has_permissions VALUES (11, 1);
INSERT INTO public.role_has_permissions VALUES (12, 1);
INSERT INTO public.role_has_permissions VALUES (14, 1);
INSERT INTO public.role_has_permissions VALUES (15, 1);
INSERT INTO public.role_has_permissions VALUES (16, 1);
INSERT INTO public.role_has_permissions VALUES (18, 1);
INSERT INTO public.role_has_permissions VALUES (2, 11);
INSERT INTO public.role_has_permissions VALUES (26, 11);
INSERT INTO public.role_has_permissions VALUES (3, 11);
INSERT INTO public.role_has_permissions VALUES (19, 1);
INSERT INTO public.role_has_permissions VALUES (20, 1);
INSERT INTO public.role_has_permissions VALUES (21, 1);
INSERT INTO public.role_has_permissions VALUES (22, 1);
INSERT INTO public.role_has_permissions VALUES (23, 1);
INSERT INTO public.role_has_permissions VALUES (24, 1);
INSERT INTO public.role_has_permissions VALUES (25, 1);
INSERT INTO public.role_has_permissions VALUES (65, 1);
INSERT INTO public.role_has_permissions VALUES (66, 1);
INSERT INTO public.role_has_permissions VALUES (67, 1);
INSERT INTO public.role_has_permissions VALUES (68, 1);
INSERT INTO public.role_has_permissions VALUES (69, 1);
INSERT INTO public.role_has_permissions VALUES (70, 1);
INSERT INTO public.role_has_permissions VALUES (71, 1);
INSERT INTO public.role_has_permissions VALUES (72, 1);
INSERT INTO public.role_has_permissions VALUES (73, 1);
INSERT INTO public.role_has_permissions VALUES (75, 1);
INSERT INTO public.role_has_permissions VALUES (76, 1);
INSERT INTO public.role_has_permissions VALUES (77, 1);
INSERT INTO public.role_has_permissions VALUES (78, 1);
INSERT INTO public.role_has_permissions VALUES (26, 1);
INSERT INTO public.role_has_permissions VALUES (17, 1);
INSERT INTO public.role_has_permissions VALUES (8, 1);
INSERT INTO public.role_has_permissions VALUES (79, 1);
INSERT INTO public.role_has_permissions VALUES (80, 1);
INSERT INTO public.role_has_permissions VALUES (81, 1);
INSERT INTO public.role_has_permissions VALUES (27, 1);
INSERT INTO public.role_has_permissions VALUES (2, 12);
INSERT INTO public.role_has_permissions VALUES (65, 12);
INSERT INTO public.role_has_permissions VALUES (66, 12);
INSERT INTO public.role_has_permissions VALUES (67, 12);
INSERT INTO public.role_has_permissions VALUES (68, 12);
INSERT INTO public.role_has_permissions VALUES (69, 12);
INSERT INTO public.role_has_permissions VALUES (70, 12);
INSERT INTO public.role_has_permissions VALUES (71, 12);
INSERT INTO public.role_has_permissions VALUES (72, 12);
INSERT INTO public.role_has_permissions VALUES (73, 12);
INSERT INTO public.role_has_permissions VALUES (75, 12);
INSERT INTO public.role_has_permissions VALUES (76, 12);
INSERT INTO public.role_has_permissions VALUES (77, 12);
INSERT INTO public.role_has_permissions VALUES (78, 12);
INSERT INTO public.role_has_permissions VALUES (79, 12);
INSERT INTO public.role_has_permissions VALUES (80, 12);
INSERT INTO public.role_has_permissions VALUES (81, 12);
INSERT INTO public.role_has_permissions VALUES (27, 12);
INSERT INTO public.role_has_permissions VALUES (30, 12);
INSERT INTO public.role_has_permissions VALUES (32, 12);
INSERT INTO public.role_has_permissions VALUES (33, 12);
INSERT INTO public.role_has_permissions VALUES (34, 12);
INSERT INTO public.role_has_permissions VALUES (82, 12);
INSERT INTO public.role_has_permissions VALUES (53, 12);
INSERT INTO public.role_has_permissions VALUES (54, 12);
INSERT INTO public.role_has_permissions VALUES (74, 12);
INSERT INTO public.role_has_permissions VALUES (83, 12);
INSERT INTO public.role_has_permissions VALUES (84, 12);
INSERT INTO public.role_has_permissions VALUES (86, 12);
INSERT INTO public.role_has_permissions VALUES (87, 12);
INSERT INTO public.role_has_permissions VALUES (85, 12);
INSERT INTO public.role_has_permissions VALUES (196, 12);
INSERT INTO public.role_has_permissions VALUES (289, 12);
INSERT INTO public.role_has_permissions VALUES (290, 12);
INSERT INTO public.role_has_permissions VALUES (31, 12);
INSERT INTO public.role_has_permissions VALUES (301, 12);
INSERT INTO public.role_has_permissions VALUES (316, 12);
INSERT INTO public.role_has_permissions VALUES (302, 12);
INSERT INTO public.role_has_permissions VALUES (28, 1);
INSERT INTO public.role_has_permissions VALUES (29, 1);
INSERT INTO public.role_has_permissions VALUES (30, 1);
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
INSERT INTO public.role_has_permissions VALUES (48, 1);
INSERT INTO public.role_has_permissions VALUES (49, 1);
INSERT INTO public.role_has_permissions VALUES (50, 1);
INSERT INTO public.role_has_permissions VALUES (82, 1);
INSERT INTO public.role_has_permissions VALUES (51, 1);
INSERT INTO public.role_has_permissions VALUES (52, 1);
INSERT INTO public.role_has_permissions VALUES (53, 1);
INSERT INTO public.role_has_permissions VALUES (54, 1);
INSERT INTO public.role_has_permissions VALUES (55, 1);
INSERT INTO public.role_has_permissions VALUES (56, 1);
INSERT INTO public.role_has_permissions VALUES (57, 1);
INSERT INTO public.role_has_permissions VALUES (58, 1);
INSERT INTO public.role_has_permissions VALUES (60, 1);
INSERT INTO public.role_has_permissions VALUES (61, 1);
INSERT INTO public.role_has_permissions VALUES (62, 1);
INSERT INTO public.role_has_permissions VALUES (63, 1);
INSERT INTO public.role_has_permissions VALUES (64, 1);
INSERT INTO public.role_has_permissions VALUES (83, 1);
INSERT INTO public.role_has_permissions VALUES (84, 1);
INSERT INTO public.role_has_permissions VALUES (86, 1);
INSERT INTO public.role_has_permissions VALUES (87, 1);
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
INSERT INTO public.role_has_permissions VALUES (47, 1);
INSERT INTO public.role_has_permissions VALUES (3, 1);
INSERT INTO public.role_has_permissions VALUES (39, 1);
INSERT INTO public.role_has_permissions VALUES (1, 1);
INSERT INTO public.role_has_permissions VALUES (88, 1);
INSERT INTO public.role_has_permissions VALUES (85, 1);
INSERT INTO public.role_has_permissions VALUES (13, 1);
INSERT INTO public.role_has_permissions VALUES (107, 1);
INSERT INTO public.role_has_permissions VALUES (108, 1);
INSERT INTO public.role_has_permissions VALUES (109, 1);
INSERT INTO public.role_has_permissions VALUES (110, 1);
INSERT INTO public.role_has_permissions VALUES (111, 1);
INSERT INTO public.role_has_permissions VALUES (112, 1);
INSERT INTO public.role_has_permissions VALUES (113, 1);
INSERT INTO public.role_has_permissions VALUES (115, 1);
INSERT INTO public.role_has_permissions VALUES (116, 1);
INSERT INTO public.role_has_permissions VALUES (117, 1);
INSERT INTO public.role_has_permissions VALUES (118, 1);
INSERT INTO public.role_has_permissions VALUES (119, 1);
INSERT INTO public.role_has_permissions VALUES (120, 1);
INSERT INTO public.role_has_permissions VALUES (121, 1);
INSERT INTO public.role_has_permissions VALUES (122, 1);
INSERT INTO public.role_has_permissions VALUES (124, 1);
INSERT INTO public.role_has_permissions VALUES (125, 1);
INSERT INTO public.role_has_permissions VALUES (127, 1);
INSERT INTO public.role_has_permissions VALUES (126, 1);
INSERT INTO public.role_has_permissions VALUES (128, 1);
INSERT INTO public.role_has_permissions VALUES (129, 1);
INSERT INTO public.role_has_permissions VALUES (130, 1);
INSERT INTO public.role_has_permissions VALUES (131, 1);
INSERT INTO public.role_has_permissions VALUES (132, 1);
INSERT INTO public.role_has_permissions VALUES (133, 1);
INSERT INTO public.role_has_permissions VALUES (134, 1);
INSERT INTO public.role_has_permissions VALUES (136, 1);
INSERT INTO public.role_has_permissions VALUES (137, 1);
INSERT INTO public.role_has_permissions VALUES (138, 1);
INSERT INTO public.role_has_permissions VALUES (139, 1);
INSERT INTO public.role_has_permissions VALUES (140, 1);
INSERT INTO public.role_has_permissions VALUES (141, 1);
INSERT INTO public.role_has_permissions VALUES (142, 1);
INSERT INTO public.role_has_permissions VALUES (144, 1);
INSERT INTO public.role_has_permissions VALUES (145, 1);
INSERT INTO public.role_has_permissions VALUES (146, 1);
INSERT INTO public.role_has_permissions VALUES (147, 1);
INSERT INTO public.role_has_permissions VALUES (246, 3);
INSERT INTO public.role_has_permissions VALUES (247, 3);
INSERT INTO public.role_has_permissions VALUES (248, 3);
INSERT INTO public.role_has_permissions VALUES (249, 3);
INSERT INTO public.role_has_permissions VALUES (250, 3);
INSERT INTO public.role_has_permissions VALUES (251, 3);
INSERT INTO public.role_has_permissions VALUES (252, 3);
INSERT INTO public.role_has_permissions VALUES (253, 3);
INSERT INTO public.role_has_permissions VALUES (254, 3);
INSERT INTO public.role_has_permissions VALUES (255, 3);
INSERT INTO public.role_has_permissions VALUES (256, 3);
INSERT INTO public.role_has_permissions VALUES (257, 3);
INSERT INTO public.role_has_permissions VALUES (258, 3);
INSERT INTO public.role_has_permissions VALUES (259, 3);
INSERT INTO public.role_has_permissions VALUES (260, 3);
INSERT INTO public.role_has_permissions VALUES (261, 3);
INSERT INTO public.role_has_permissions VALUES (262, 3);
INSERT INTO public.role_has_permissions VALUES (263, 3);
INSERT INTO public.role_has_permissions VALUES (264, 3);
INSERT INTO public.role_has_permissions VALUES (265, 3);
INSERT INTO public.role_has_permissions VALUES (267, 3);
INSERT INTO public.role_has_permissions VALUES (278, 3);
INSERT INTO public.role_has_permissions VALUES (279, 3);
INSERT INTO public.role_has_permissions VALUES (287, 3);
INSERT INTO public.role_has_permissions VALUES (289, 3);
INSERT INTO public.role_has_permissions VALUES (290, 3);
INSERT INTO public.role_has_permissions VALUES (291, 3);
INSERT INTO public.role_has_permissions VALUES (293, 3);
INSERT INTO public.role_has_permissions VALUES (294, 3);
INSERT INTO public.role_has_permissions VALUES (296, 3);
INSERT INTO public.role_has_permissions VALUES (297, 3);
INSERT INTO public.role_has_permissions VALUES (266, 3);
INSERT INTO public.role_has_permissions VALUES (301, 3);
INSERT INTO public.role_has_permissions VALUES (305, 3);
INSERT INTO public.role_has_permissions VALUES (307, 3);
INSERT INTO public.role_has_permissions VALUES (292, 3);
INSERT INTO public.role_has_permissions VALUES (313, 3);
INSERT INTO public.role_has_permissions VALUES (314, 3);
INSERT INTO public.role_has_permissions VALUES (316, 3);
INSERT INTO public.role_has_permissions VALUES (317, 3);
INSERT INTO public.role_has_permissions VALUES (318, 3);
INSERT INTO public.role_has_permissions VALUES (337, 3);
INSERT INTO public.role_has_permissions VALUES (338, 3);
INSERT INTO public.role_has_permissions VALUES (59, 3);
INSERT INTO public.role_has_permissions VALUES (161, 3);
INSERT INTO public.role_has_permissions VALUES (302, 3);
INSERT INTO public.role_has_permissions VALUES (308, 3);
INSERT INTO public.role_has_permissions VALUES (350, 3);
INSERT INTO public.role_has_permissions VALUES (89, 3);
INSERT INTO public.role_has_permissions VALUES (351, 3);
INSERT INTO public.role_has_permissions VALUES (355, 3);
INSERT INTO public.role_has_permissions VALUES (356, 3);
INSERT INTO public.role_has_permissions VALUES (357, 3);
INSERT INTO public.role_has_permissions VALUES (359, 3);
INSERT INTO public.role_has_permissions VALUES (360, 3);
INSERT INTO public.role_has_permissions VALUES (361, 3);
INSERT INTO public.role_has_permissions VALUES (362, 3);
INSERT INTO public.role_has_permissions VALUES (363, 3);
INSERT INTO public.role_has_permissions VALUES (364, 3);
INSERT INTO public.role_has_permissions VALUES (366, 3);
INSERT INTO public.role_has_permissions VALUES (387, 3);
INSERT INTO public.role_has_permissions VALUES (388, 3);
INSERT INTO public.role_has_permissions VALUES (389, 3);
INSERT INTO public.role_has_permissions VALUES (439, 3);
INSERT INTO public.role_has_permissions VALUES (353, 3);
INSERT INTO public.role_has_permissions VALUES (394, 3);
INSERT INTO public.role_has_permissions VALUES (395, 3);
INSERT INTO public.role_has_permissions VALUES (396, 3);
INSERT INTO public.role_has_permissions VALUES (397, 3);
INSERT INTO public.role_has_permissions VALUES (398, 3);
INSERT INTO public.role_has_permissions VALUES (399, 3);
INSERT INTO public.role_has_permissions VALUES (400, 3);
INSERT INTO public.role_has_permissions VALUES (401, 3);
INSERT INTO public.role_has_permissions VALUES (402, 3);
INSERT INTO public.role_has_permissions VALUES (295, 3);
INSERT INTO public.role_has_permissions VALUES (440, 3);
INSERT INTO public.role_has_permissions VALUES (193, 3);
INSERT INTO public.role_has_permissions VALUES (443, 3);
INSERT INTO public.role_has_permissions VALUES (444, 3);
INSERT INTO public.role_has_permissions VALUES (446, 3);
INSERT INTO public.role_has_permissions VALUES (447, 3);
INSERT INTO public.role_has_permissions VALUES (448, 3);
INSERT INTO public.role_has_permissions VALUES (449, 3);
INSERT INTO public.role_has_permissions VALUES (450, 3);
INSERT INTO public.role_has_permissions VALUES (451, 3);
INSERT INTO public.role_has_permissions VALUES (452, 3);
INSERT INTO public.role_has_permissions VALUES (453, 3);
INSERT INTO public.role_has_permissions VALUES (454, 3);
INSERT INTO public.role_has_permissions VALUES (445, 3);
INSERT INTO public.role_has_permissions VALUES (148, 1);
INSERT INTO public.role_has_permissions VALUES (149, 1);
INSERT INTO public.role_has_permissions VALUES (150, 1);
INSERT INTO public.role_has_permissions VALUES (152, 1);
INSERT INTO public.role_has_permissions VALUES (153, 1);
INSERT INTO public.role_has_permissions VALUES (154, 1);
INSERT INTO public.role_has_permissions VALUES (155, 1);
INSERT INTO public.role_has_permissions VALUES (156, 1);
INSERT INTO public.role_has_permissions VALUES (157, 1);
INSERT INTO public.role_has_permissions VALUES (158, 1);
INSERT INTO public.role_has_permissions VALUES (159, 1);
INSERT INTO public.role_has_permissions VALUES (160, 1);
INSERT INTO public.role_has_permissions VALUES (162, 1);
INSERT INTO public.role_has_permissions VALUES (163, 1);
INSERT INTO public.role_has_permissions VALUES (164, 1);
INSERT INTO public.role_has_permissions VALUES (165, 1);
INSERT INTO public.role_has_permissions VALUES (166, 1);
INSERT INTO public.role_has_permissions VALUES (167, 1);
INSERT INTO public.role_has_permissions VALUES (168, 1);
INSERT INTO public.role_has_permissions VALUES (169, 1);
INSERT INTO public.role_has_permissions VALUES (170, 1);
INSERT INTO public.role_has_permissions VALUES (172, 1);
INSERT INTO public.role_has_permissions VALUES (173, 1);
INSERT INTO public.role_has_permissions VALUES (174, 1);
INSERT INTO public.role_has_permissions VALUES (175, 1);
INSERT INTO public.role_has_permissions VALUES (176, 1);
INSERT INTO public.role_has_permissions VALUES (177, 1);
INSERT INTO public.role_has_permissions VALUES (178, 1);
INSERT INTO public.role_has_permissions VALUES (179, 1);
INSERT INTO public.role_has_permissions VALUES (180, 1);
INSERT INTO public.role_has_permissions VALUES (182, 1);
INSERT INTO public.role_has_permissions VALUES (183, 1);
INSERT INTO public.role_has_permissions VALUES (184, 1);
INSERT INTO public.role_has_permissions VALUES (185, 1);
INSERT INTO public.role_has_permissions VALUES (186, 1);
INSERT INTO public.role_has_permissions VALUES (187, 1);
INSERT INTO public.role_has_permissions VALUES (188, 1);
INSERT INTO public.role_has_permissions VALUES (189, 1);
INSERT INTO public.role_has_permissions VALUES (190, 1);
INSERT INTO public.role_has_permissions VALUES (194, 1);
INSERT INTO public.role_has_permissions VALUES (195, 1);
INSERT INTO public.role_has_permissions VALUES (196, 1);
INSERT INTO public.role_has_permissions VALUES (197, 1);
INSERT INTO public.role_has_permissions VALUES (198, 1);
INSERT INTO public.role_has_permissions VALUES (199, 1);
INSERT INTO public.role_has_permissions VALUES (200, 1);
INSERT INTO public.role_has_permissions VALUES (201, 1);
INSERT INTO public.role_has_permissions VALUES (135, 1);
INSERT INTO public.role_has_permissions VALUES (143, 1);
INSERT INTO public.role_has_permissions VALUES (151, 1);
INSERT INTO public.role_has_permissions VALUES (191, 1);
INSERT INTO public.role_has_permissions VALUES (123, 1);
INSERT INTO public.role_has_permissions VALUES (171, 1);
INSERT INTO public.role_has_permissions VALUES (192, 1);
INSERT INTO public.role_has_permissions VALUES (181, 1);
INSERT INTO public.role_has_permissions VALUES (202, 1);
INSERT INTO public.role_has_permissions VALUES (203, 1);
INSERT INTO public.role_has_permissions VALUES (204, 1);
INSERT INTO public.role_has_permissions VALUES (206, 1);
INSERT INTO public.role_has_permissions VALUES (207, 1);
INSERT INTO public.role_has_permissions VALUES (208, 1);
INSERT INTO public.role_has_permissions VALUES (2, 3);
INSERT INTO public.role_has_permissions VALUES (66, 3);
INSERT INTO public.role_has_permissions VALUES (73, 3);
INSERT INTO public.role_has_permissions VALUES (75, 3);
INSERT INTO public.role_has_permissions VALUES (76, 3);
INSERT INTO public.role_has_permissions VALUES (77, 3);
INSERT INTO public.role_has_permissions VALUES (78, 3);
INSERT INTO public.role_has_permissions VALUES (26, 3);
INSERT INTO public.role_has_permissions VALUES (79, 3);
INSERT INTO public.role_has_permissions VALUES (80, 3);
INSERT INTO public.role_has_permissions VALUES (81, 3);
INSERT INTO public.role_has_permissions VALUES (57, 3);
INSERT INTO public.role_has_permissions VALUES (58, 3);
INSERT INTO public.role_has_permissions VALUES (60, 3);
INSERT INTO public.role_has_permissions VALUES (84, 3);
INSERT INTO public.role_has_permissions VALUES (86, 3);
INSERT INTO public.role_has_permissions VALUES (87, 3);
INSERT INTO public.role_has_permissions VALUES (90, 3);
INSERT INTO public.role_has_permissions VALUES (91, 3);
INSERT INTO public.role_has_permissions VALUES (98, 3);
INSERT INTO public.role_has_permissions VALUES (47, 3);
INSERT INTO public.role_has_permissions VALUES (85, 3);
INSERT INTO public.role_has_permissions VALUES (115, 3);
INSERT INTO public.role_has_permissions VALUES (116, 3);
INSERT INTO public.role_has_permissions VALUES (117, 3);
INSERT INTO public.role_has_permissions VALUES (118, 3);
INSERT INTO public.role_has_permissions VALUES (209, 1);
INSERT INTO public.role_has_permissions VALUES (210, 1);
INSERT INTO public.role_has_permissions VALUES (211, 1);
INSERT INTO public.role_has_permissions VALUES (212, 1);
INSERT INTO public.role_has_permissions VALUES (213, 1);
INSERT INTO public.role_has_permissions VALUES (214, 1);
INSERT INTO public.role_has_permissions VALUES (215, 1);
INSERT INTO public.role_has_permissions VALUES (216, 1);
INSERT INTO public.role_has_permissions VALUES (217, 1);
INSERT INTO public.role_has_permissions VALUES (218, 1);
INSERT INTO public.role_has_permissions VALUES (219, 1);
INSERT INTO public.role_has_permissions VALUES (220, 1);
INSERT INTO public.role_has_permissions VALUES (222, 1);
INSERT INTO public.role_has_permissions VALUES (223, 1);
INSERT INTO public.role_has_permissions VALUES (224, 1);
INSERT INTO public.role_has_permissions VALUES (225, 1);
INSERT INTO public.role_has_permissions VALUES (226, 1);
INSERT INTO public.role_has_permissions VALUES (227, 1);
INSERT INTO public.role_has_permissions VALUES (228, 1);
INSERT INTO public.role_has_permissions VALUES (229, 1);
INSERT INTO public.role_has_permissions VALUES (230, 1);
INSERT INTO public.role_has_permissions VALUES (231, 1);
INSERT INTO public.role_has_permissions VALUES (233, 1);
INSERT INTO public.role_has_permissions VALUES (234, 1);
INSERT INTO public.role_has_permissions VALUES (235, 1);
INSERT INTO public.role_has_permissions VALUES (236, 1);
INSERT INTO public.role_has_permissions VALUES (237, 1);
INSERT INTO public.role_has_permissions VALUES (238, 1);
INSERT INTO public.role_has_permissions VALUES (239, 1);
INSERT INTO public.role_has_permissions VALUES (240, 1);
INSERT INTO public.role_has_permissions VALUES (241, 1);
INSERT INTO public.role_has_permissions VALUES (243, 1);
INSERT INTO public.role_has_permissions VALUES (244, 1);
INSERT INTO public.role_has_permissions VALUES (245, 1);
INSERT INTO public.role_has_permissions VALUES (246, 1);
INSERT INTO public.role_has_permissions VALUES (247, 1);
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
INSERT INTO public.role_has_permissions VALUES (267, 1);
INSERT INTO public.role_has_permissions VALUES (268, 1);
INSERT INTO public.role_has_permissions VALUES (269, 1);
INSERT INTO public.role_has_permissions VALUES (270, 1);
INSERT INTO public.role_has_permissions VALUES (271, 1);
INSERT INTO public.role_has_permissions VALUES (272, 1);
INSERT INTO public.role_has_permissions VALUES (273, 1);
INSERT INTO public.role_has_permissions VALUES (274, 1);
INSERT INTO public.role_has_permissions VALUES (275, 1);
INSERT INTO public.role_has_permissions VALUES (276, 1);
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
INSERT INTO public.role_has_permissions VALUES (293, 1);
INSERT INTO public.role_has_permissions VALUES (294, 1);
INSERT INTO public.role_has_permissions VALUES (296, 1);
INSERT INTO public.role_has_permissions VALUES (297, 1);
INSERT INTO public.role_has_permissions VALUES (221, 1);
INSERT INTO public.role_has_permissions VALUES (31, 1);
INSERT INTO public.role_has_permissions VALUES (266, 1);
INSERT INTO public.role_has_permissions VALUES (242, 1);
INSERT INTO public.role_has_permissions VALUES (277, 1);
INSERT INTO public.role_has_permissions VALUES (232, 1);
INSERT INTO public.role_has_permissions VALUES (299, 1);
INSERT INTO public.role_has_permissions VALUES (301, 1);
INSERT INTO public.role_has_permissions VALUES (303, 1);
INSERT INTO public.role_has_permissions VALUES (305, 1);
INSERT INTO public.role_has_permissions VALUES (307, 1);
INSERT INTO public.role_has_permissions VALUES (309, 1);
INSERT INTO public.role_has_permissions VALUES (292, 1);
INSERT INTO public.role_has_permissions VALUES (310, 1);
INSERT INTO public.role_has_permissions VALUES (312, 1);
INSERT INTO public.role_has_permissions VALUES (313, 1);
INSERT INTO public.role_has_permissions VALUES (314, 1);
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
INSERT INTO public.role_has_permissions VALUES (328, 1);
INSERT INTO public.role_has_permissions VALUES (329, 1);
INSERT INTO public.role_has_permissions VALUES (330, 1);
INSERT INTO public.role_has_permissions VALUES (331, 1);
INSERT INTO public.role_has_permissions VALUES (332, 1);
INSERT INTO public.role_has_permissions VALUES (333, 1);
INSERT INTO public.role_has_permissions VALUES (334, 1);
INSERT INTO public.role_has_permissions VALUES (337, 1);
INSERT INTO public.role_has_permissions VALUES (338, 1);
INSERT INTO public.role_has_permissions VALUES (339, 1);
INSERT INTO public.role_has_permissions VALUES (59, 1);
INSERT INTO public.role_has_permissions VALUES (114, 1);
INSERT INTO public.role_has_permissions VALUES (161, 1);
INSERT INTO public.role_has_permissions VALUES (205, 1);
INSERT INTO public.role_has_permissions VALUES (300, 1);
INSERT INTO public.role_has_permissions VALUES (302, 1);
INSERT INTO public.role_has_permissions VALUES (304, 1);
INSERT INTO public.role_has_permissions VALUES (306, 1);
INSERT INTO public.role_has_permissions VALUES (308, 1);
INSERT INTO public.role_has_permissions VALUES (311, 1);
INSERT INTO public.role_has_permissions VALUES (327, 1);
INSERT INTO public.role_has_permissions VALUES (346, 1);
INSERT INTO public.role_has_permissions VALUES (350, 1);
INSERT INTO public.role_has_permissions VALUES (347, 1);
INSERT INTO public.role_has_permissions VALUES (89, 1);
INSERT INTO public.role_has_permissions VALUES (351, 1);
INSERT INTO public.role_has_permissions VALUES (343, 1);
INSERT INTO public.role_has_permissions VALUES (344, 1);
INSERT INTO public.role_has_permissions VALUES (119, 3);
INSERT INTO public.role_has_permissions VALUES (120, 3);
INSERT INTO public.role_has_permissions VALUES (124, 3);
INSERT INTO public.role_has_permissions VALUES (125, 3);
INSERT INTO public.role_has_permissions VALUES (127, 3);
INSERT INTO public.role_has_permissions VALUES (126, 3);
INSERT INTO public.role_has_permissions VALUES (152, 3);
INSERT INTO public.role_has_permissions VALUES (153, 3);
INSERT INTO public.role_has_permissions VALUES (154, 3);
INSERT INTO public.role_has_permissions VALUES (155, 3);
INSERT INTO public.role_has_permissions VALUES (156, 3);
INSERT INTO public.role_has_permissions VALUES (157, 3);
INSERT INTO public.role_has_permissions VALUES (158, 3);
INSERT INTO public.role_has_permissions VALUES (159, 3);
INSERT INTO public.role_has_permissions VALUES (160, 3);
INSERT INTO public.role_has_permissions VALUES (194, 3);
INSERT INTO public.role_has_permissions VALUES (195, 3);
INSERT INTO public.role_has_permissions VALUES (196, 3);
INSERT INTO public.role_has_permissions VALUES (123, 3);
INSERT INTO public.role_has_permissions VALUES (192, 3);
INSERT INTO public.role_has_permissions VALUES (228, 3);
INSERT INTO public.role_has_permissions VALUES (229, 3);
INSERT INTO public.role_has_permissions VALUES (348, 1);
INSERT INTO public.role_has_permissions VALUES (345, 1);
INSERT INTO public.role_has_permissions VALUES (349, 1);
INSERT INTO public.role_has_permissions VALUES (354, 1);
INSERT INTO public.role_has_permissions VALUES (355, 1);
INSERT INTO public.role_has_permissions VALUES (356, 1);
INSERT INTO public.role_has_permissions VALUES (357, 1);
INSERT INTO public.role_has_permissions VALUES (359, 1);
INSERT INTO public.role_has_permissions VALUES (360, 1);
INSERT INTO public.role_has_permissions VALUES (361, 1);
INSERT INTO public.role_has_permissions VALUES (362, 1);
INSERT INTO public.role_has_permissions VALUES (363, 1);
INSERT INTO public.role_has_permissions VALUES (364, 1);
INSERT INTO public.role_has_permissions VALUES (366, 1);
INSERT INTO public.role_has_permissions VALUES (367, 1);
INSERT INTO public.role_has_permissions VALUES (368, 1);
INSERT INTO public.role_has_permissions VALUES (369, 1);
INSERT INTO public.role_has_permissions VALUES (370, 1);
INSERT INTO public.role_has_permissions VALUES (371, 1);
INSERT INTO public.role_has_permissions VALUES (372, 1);
INSERT INTO public.role_has_permissions VALUES (373, 1);
INSERT INTO public.role_has_permissions VALUES (365, 1);
INSERT INTO public.role_has_permissions VALUES (374, 1);
INSERT INTO public.role_has_permissions VALUES (375, 1);
INSERT INTO public.role_has_permissions VALUES (376, 1);
INSERT INTO public.role_has_permissions VALUES (377, 1);
INSERT INTO public.role_has_permissions VALUES (378, 1);
INSERT INTO public.role_has_permissions VALUES (379, 1);
INSERT INTO public.role_has_permissions VALUES (380, 1);
INSERT INTO public.role_has_permissions VALUES (381, 1);
INSERT INTO public.role_has_permissions VALUES (382, 1);
INSERT INTO public.role_has_permissions VALUES (383, 1);
INSERT INTO public.role_has_permissions VALUES (384, 1);
INSERT INTO public.role_has_permissions VALUES (385, 1);
INSERT INTO public.role_has_permissions VALUES (386, 1);
INSERT INTO public.role_has_permissions VALUES (387, 1);
INSERT INTO public.role_has_permissions VALUES (388, 1);
INSERT INTO public.role_has_permissions VALUES (389, 1);
INSERT INTO public.role_has_permissions VALUES (315, 1);
INSERT INTO public.role_has_permissions VALUES (335, 1);
INSERT INTO public.role_has_permissions VALUES (390, 1);
INSERT INTO public.role_has_permissions VALUES (391, 1);
INSERT INTO public.role_has_permissions VALUES (392, 1);
INSERT INTO public.role_has_permissions VALUES (393, 1);
INSERT INTO public.role_has_permissions VALUES (439, 1);
INSERT INTO public.role_has_permissions VALUES (353, 1);
INSERT INTO public.role_has_permissions VALUES (394, 1);
INSERT INTO public.role_has_permissions VALUES (395, 1);
INSERT INTO public.role_has_permissions VALUES (396, 1);
INSERT INTO public.role_has_permissions VALUES (397, 1);
INSERT INTO public.role_has_permissions VALUES (398, 1);
INSERT INTO public.role_has_permissions VALUES (399, 1);
INSERT INTO public.role_has_permissions VALUES (400, 1);
INSERT INTO public.role_has_permissions VALUES (401, 1);
INSERT INTO public.role_has_permissions VALUES (402, 1);
INSERT INTO public.role_has_permissions VALUES (403, 1);
INSERT INTO public.role_has_permissions VALUES (404, 1);
INSERT INTO public.role_has_permissions VALUES (405, 1);
INSERT INTO public.role_has_permissions VALUES (406, 1);
INSERT INTO public.role_has_permissions VALUES (407, 1);
INSERT INTO public.role_has_permissions VALUES (408, 1);
INSERT INTO public.role_has_permissions VALUES (409, 1);
INSERT INTO public.role_has_permissions VALUES (410, 1);
INSERT INTO public.role_has_permissions VALUES (411, 1);
INSERT INTO public.role_has_permissions VALUES (412, 1);
INSERT INTO public.role_has_permissions VALUES (413, 1);
INSERT INTO public.role_has_permissions VALUES (414, 1);
INSERT INTO public.role_has_permissions VALUES (415, 1);
INSERT INTO public.role_has_permissions VALUES (416, 1);
INSERT INTO public.role_has_permissions VALUES (417, 1);
INSERT INTO public.role_has_permissions VALUES (418, 1);
INSERT INTO public.role_has_permissions VALUES (419, 1);
INSERT INTO public.role_has_permissions VALUES (420, 1);
INSERT INTO public.role_has_permissions VALUES (421, 1);
INSERT INTO public.role_has_permissions VALUES (422, 1);
INSERT INTO public.role_has_permissions VALUES (423, 1);
INSERT INTO public.role_has_permissions VALUES (424, 1);
INSERT INTO public.role_has_permissions VALUES (425, 1);
INSERT INTO public.role_has_permissions VALUES (426, 1);
INSERT INTO public.role_has_permissions VALUES (427, 1);
INSERT INTO public.role_has_permissions VALUES (428, 1);
INSERT INTO public.role_has_permissions VALUES (429, 1);
INSERT INTO public.role_has_permissions VALUES (430, 1);
INSERT INTO public.role_has_permissions VALUES (431, 1);
INSERT INTO public.role_has_permissions VALUES (432, 1);
INSERT INTO public.role_has_permissions VALUES (433, 1);
INSERT INTO public.role_has_permissions VALUES (434, 1);
INSERT INTO public.role_has_permissions VALUES (435, 1);
INSERT INTO public.role_has_permissions VALUES (436, 1);
INSERT INTO public.role_has_permissions VALUES (437, 1);
INSERT INTO public.role_has_permissions VALUES (438, 1);
INSERT INTO public.role_has_permissions VALUES (298, 1);
INSERT INTO public.role_has_permissions VALUES (295, 1);
INSERT INTO public.role_has_permissions VALUES (440, 1);
INSERT INTO public.role_has_permissions VALUES (193, 1);
INSERT INTO public.role_has_permissions VALUES (441, 1);
INSERT INTO public.role_has_permissions VALUES (442, 1);
INSERT INTO public.role_has_permissions VALUES (443, 1);
INSERT INTO public.role_has_permissions VALUES (444, 1);
INSERT INTO public.role_has_permissions VALUES (446, 1);
INSERT INTO public.role_has_permissions VALUES (447, 1);
INSERT INTO public.role_has_permissions VALUES (448, 1);
INSERT INTO public.role_has_permissions VALUES (449, 1);
INSERT INTO public.role_has_permissions VALUES (450, 1);
INSERT INTO public.role_has_permissions VALUES (451, 1);
INSERT INTO public.role_has_permissions VALUES (452, 1);
INSERT INTO public.role_has_permissions VALUES (453, 1);
INSERT INTO public.role_has_permissions VALUES (454, 1);
INSERT INTO public.role_has_permissions VALUES (445, 1);
INSERT INTO public.role_has_permissions VALUES (336, 1);
INSERT INTO public.role_has_permissions VALUES (455, 1);
INSERT INTO public.role_has_permissions VALUES (456, 1);
INSERT INTO public.role_has_permissions VALUES (490, 1);
INSERT INTO public.role_has_permissions VALUES (491, 1);
INSERT INTO public.role_has_permissions VALUES (492, 1);
INSERT INTO public.role_has_permissions VALUES (493, 1);
INSERT INTO public.role_has_permissions VALUES (495, 1);
INSERT INTO public.role_has_permissions VALUES (496, 1);
INSERT INTO public.role_has_permissions VALUES (497, 1);
INSERT INTO public.role_has_permissions VALUES (498, 1);
INSERT INTO public.role_has_permissions VALUES (499, 1);
INSERT INTO public.role_has_permissions VALUES (500, 1);
INSERT INTO public.role_has_permissions VALUES (490, 12);
INSERT INTO public.role_has_permissions VALUES (491, 12);
INSERT INTO public.role_has_permissions VALUES (492, 12);
INSERT INTO public.role_has_permissions VALUES (493, 12);
INSERT INTO public.role_has_permissions VALUES (495, 12);
INSERT INTO public.role_has_permissions VALUES (496, 12);
INSERT INTO public.role_has_permissions VALUES (497, 12);
INSERT INTO public.role_has_permissions VALUES (498, 12);
INSERT INTO public.role_has_permissions VALUES (499, 12);
INSERT INTO public.role_has_permissions VALUES (500, 12);


--
-- TOC entry 3742 (class 0 OID 18314)
-- Dependencies: 270
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles VALUES (1, 'admin', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles VALUES (2, 'owner', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles VALUES (3, 'cashier', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles VALUES (5, 'terapist', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles VALUES (4, 'admin_finance', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles VALUES (6, 'hr', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles VALUES (11, 'trainer', 'web', '2022-08-06 23:01:46', '2022-08-06 23:01:46');
INSERT INTO public.roles VALUES (12, 'smd_admin', 'web', '2023-01-10 22:01:51', '2023-01-10 22:01:51');


--
-- TOC entry 3769 (class 0 OID 18736)
-- Dependencies: 297
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sales VALUES (1, 'demo', 'demo', 'demo', 'demo', 1, 1, NULL, NULL, NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (2, 'Sales 01', 'sales01', '123456', 'demo', 1, 1, NULL, NULL, NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (3, 'Sales 02', 'sales02', '123456', 'demo', 1, 1, NULL, NULL, NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (4, 'Sales 03', 'sales03', '123456', 'demo', 1, 1, NULL, NULL, NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (5, 'Sales 04', 'sales04', '123456', 'demo', 1, 1, NULL, NULL, NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (6, 'Sales 05', 'sales05', '123456', 'demo', 1, 1, NULL, NULL, NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (24, 'Test012', 'Test012', 'Test012', 'Test012', 1, 1, NULL, '2023-01-10 23:02:57', NULL, '2023-01-10 22:55:31');
INSERT INTO public.sales VALUES (7, 'JKT01', 'JKT01', 'JKT01', 'JKT01', 14, 1, NULL, '2023-01-10 23:14:23', NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (8, 'BDG01', 'BDG01', 'BDG01', 'BDG01', 15, 1, NULL, '2023-01-10 23:14:34', NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (9, 'SLO01', 'SLO01', 'SLO01', 'SLO01', 18, 1, NULL, '2023-01-10 23:14:40', NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (11, 'KDI01', 'KDI01', 'KDI01', 'KDI01', 21, 1, NULL, '2023-01-10 23:14:50', NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (12, 'MOJO01', 'MOJO01', 'MOJO01', 'MOJO01', 20, 1, NULL, '2023-01-10 23:14:58', NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (13, 'GRES01', 'GRES01', 'GRES01', 'GRES01', 19, 1, NULL, '2023-01-10 23:15:04', NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (14, 'SIDO01', 'SIDO01', 'SIDO01', 'SIDO01', 16, 1, NULL, '2023-01-10 23:15:11', NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (15, 'SURA01', 'SURA01', 'SURA01', 'SURA01', 17, 1, NULL, '2023-01-10 23:15:19', NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (19, 'MKS08', 'MKS08', 'MKS08', 'MKS08', 13, 1, NULL, '2023-01-10 23:15:23', NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (18, 'MKS03', 'MKS03', 'MKS03', 'MKS03', 13, 1, NULL, '2023-01-10 23:15:28', NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (21, 'MKS05', 'MKS05', 'MKS05', 'MKS05', 13, 1, NULL, '2023-01-10 23:15:32', NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (22, 'MKS06', 'MKS06', 'MKS06', 'MKS06', 13, 1, NULL, '2023-01-10 23:15:36', NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (23, 'MKS07', 'MKS07', 'MKS07', 'MKS07', 13, 1, NULL, '2023-01-10 23:15:42', NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (17, 'MKS02', 'MKS02', 'MKS02', 'MKS02', 13, 1, NULL, '2023-01-10 23:15:46', NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (20, 'MKS04', 'MKS04', 'MKS04', 'MKS04', 13, 1, NULL, '2023-01-10 23:15:57', NULL, '2023-01-10 22:15:17.971655');
INSERT INTO public.sales VALUES (16, 'MKS01', 'MKS01', 'MKS01', 'MKS01', 13, 1, NULL, '2023-01-10 23:16:03', NULL, '2023-01-10 22:15:17.971655');


--
-- TOC entry 3771 (class 0 OID 18750)
-- Dependencies: 299
-- Data for Name: sales_trip; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sales_trip VALUES (6, '2023-01-09', 2, '2023-01-09 10:34:41.668351', '2023-01-09 16:57:50.510997', 0, '2023-01-09 16:57:50.510997', 2, '2023-01-09 10:34:41.668351', 'PicTrip_2_20230109103409.jpg', 'Bertemu Bagian Penjualan
', 2);
INSERT INTO public.sales_trip VALUES (9, '2023-01-10', 2, '2023-01-10 08:32:13.958791', '2023-01-10 08:32:13.958791', 0, NULL, NULL, '2023-01-10 08:32:13.958791', 'PicTrip_2_20230110093127.jpg', 'tes ..1', 2);
INSERT INTO public.sales_trip VALUES (10, '2023-01-10', 2, '2023-01-10 10:18:04.062227', '2023-01-10 10:18:04.062227', 0, NULL, NULL, '2023-01-10 10:18:04.062227', 'PicTrip_2_20230110111700.jpg', 'toko GP', 2);
INSERT INTO public.sales_trip VALUES (11, '2023-01-10', 2, '2023-01-10 10:19:44.292637', '2023-01-10 10:19:44.292637', 0, NULL, NULL, '2023-01-10 10:19:44.292637', 'PicTrip_2_20230110111904.jpg', 'ibu Arni
', 2);
INSERT INTO public.sales_trip VALUES (13, '2023-01-10', 2, '2023-01-10 10:24:22.659738', '2023-01-10 10:24:22.659738', 0, NULL, NULL, '2023-01-10 10:24:22.659738', 'PicTrip_2_20230110112146.jpg', 'Andi Asliah', 2);
INSERT INTO public.sales_trip VALUES (28, '2023-01-10', 12, '2023-01-10 14:24:44.309186', '2023-01-10 14:24:44.309186', 0, NULL, NULL, '2023-01-10 14:24:44.309186', 'PicTrip_12_20230110021020.jpg', 'sudah taruh kartu nama, owner-nya keluar ', 12);
INSERT INTO public.sales_trip VALUES (29, '2023-01-10', 12, '2023-01-10 14:24:44.329555', '2023-01-10 14:24:44.329555', 0, NULL, NULL, '2023-01-10 14:24:44.329555', 'PicTrip_12_20230110021020.jpg', 'sudah taruh kartu nama, owner-nya keluar ', 12);
INSERT INTO public.sales_trip VALUES (30, '2023-01-10', 12, '2023-01-10 14:24:44.362608', '2023-01-10 14:24:44.362608', 0, NULL, NULL, '2023-01-10 14:24:44.362608', 'PicTrip_12_20230110021020.jpg', 'sudah taruh kartu nama, owner-nya keluar ', 12);
INSERT INTO public.sales_trip VALUES (31, '2023-01-10', 12, '2023-01-10 14:24:44.389198', '2023-01-10 14:24:44.389198', 0, NULL, NULL, '2023-01-10 14:24:44.389198', 'PicTrip_12_20230110021020.jpg', 'sudah taruh kartu nama, owner-nya keluar ', 12);
INSERT INTO public.sales_trip VALUES (18, '2023-01-10', 12, '2023-01-10 12:02:17.485889', '2023-01-10 12:02:17.485889', 0, NULL, NULL, '2023-01-10 12:02:17.485889', 'PicTrip_12_20230110115821.jpg', 'JL.Sayid Mahmud desa kintelan kecamatan Puri kabupaten Mojokerto, Jawa Timur ', 12);
INSERT INTO public.sales_trip VALUES (8, '2023-01-09', 13, '2023-01-09 16:36:51.650501', '2023-01-09 16:39:37.180798', 0, '2023-01-09 16:39:37.180798', 13, '2023-01-09 16:36:51.650501', 'PicTrip_13_20230109043607.jpg', 'pusat grosir dan umkm', 13);
INSERT INTO public.sales_trip VALUES (15, '2023-01-10', 13, '2023-01-10 11:13:18.832754', '2023-01-10 11:13:18.832754', 0, NULL, NULL, '2023-01-10 11:13:18.832754', 'PicTrip_13_20230110111253.jpg', '', 13);
INSERT INTO public.sales_trip VALUES (16, '2023-01-10', 13, '2023-01-10 11:19:03.756326', '2023-01-10 11:19:03.756326', 0, NULL, NULL, '2023-01-10 11:19:03.756326', 'PicTrip_13_20230110111841.jpg', '', 13);
INSERT INTO public.sales_trip VALUES (17, '2023-01-10', 13, '2023-01-10 11:37:34.300397', '2023-01-10 11:37:34.300397', 0, NULL, NULL, '2023-01-10 11:37:34.300397', 'PicTrip_13_20230110113715.jpg', '', 13);
INSERT INTO public.sales_trip VALUES (19, '2023-01-10', 13, '2023-01-10 13:09:09.592647', '2023-01-10 13:09:09.592647', 0, NULL, NULL, '2023-01-10 13:09:09.592647', 'PicTrip_13_20230110010851.jpg', '', 13);
INSERT INTO public.sales_trip VALUES (20, '2023-01-10', 13, '2023-01-10 13:17:04.694967', '2023-01-10 13:17:04.694967', 0, NULL, NULL, '2023-01-10 13:17:04.694967', 'PicTrip_13_20230110011645.jpg', '', 13);
INSERT INTO public.sales_trip VALUES (21, '2023-01-10', 13, '2023-01-10 13:22:30.242754', '2023-01-10 13:22:30.242754', 0, NULL, NULL, '2023-01-10 13:22:30.242754', 'PicTrip_13_20230110012211.jpg', '', 13);
INSERT INTO public.sales_trip VALUES (22, '2023-01-10', 13, '2023-01-10 13:32:05.876068', '2023-01-10 13:32:05.876068', 0, NULL, NULL, '2023-01-10 13:32:05.876068', 'PicTrip_13_20230110013149.jpg', '', 13);
INSERT INTO public.sales_trip VALUES (24, '2023-01-10', 13, '2023-01-10 13:58:38.717181', '2023-01-10 13:58:38.717181', 0, NULL, NULL, '2023-01-10 13:58:38.717181', 'PicTrip_13_20230110015813.jpg', '', 13);
INSERT INTO public.sales_trip VALUES (7, '2023-01-09', 3, '2023-01-09 12:23:06.834709', '2023-01-09 12:23:06.834709', 1, NULL, NULL, '2023-01-09 12:23:06.834709', 'PicTrip_3_20230109122236.jpg', 'AA 5208 MAKMUR, TK', 3);
INSERT INTO public.sales_trip VALUES (14, '2023-01-10', 2, '2023-01-10 10:41:40.747499', '2023-01-10 16:16:13.405774', 0, '2023-01-10 16:16:13.405774', 2, '2023-01-10 10:41:40.747499', 'PicTrip_2_20230110114038.jpg', 'Toko Wahyu jl. asrama haji sudiang', 2);
INSERT INTO public.sales_trip VALUES (25, '2023-01-10', 13, '2023-01-10 14:05:07.197762', '2023-01-10 17:45:42.479069', 1, '2023-01-10 17:45:42.479069', 13, '2023-01-10 14:05:07.197762', 'PicTrip_13_20230110020446.jpg', '', 13);
INSERT INTO public.sales_trip VALUES (12, '2023-01-10', 4, '2023-01-10 10:20:50.656824', '2023-01-10 10:20:50.656824', 1, NULL, NULL, '2023-01-10 10:20:50.656824', 'PicTrip_4_20230110101958.jpg', 'start dri Hotel Sendang Sari', 4);
INSERT INTO public.sales_trip VALUES (23, '2023-01-10', 14, '2023-01-10 13:40:38.510189', '2023-01-10 13:40:38.510189', 0, NULL, NULL, '2023-01-10 13:40:38.510189', 'PicTrip_14_20230110014011.jpg', 'Erwin, Kodam wr', 14);
INSERT INTO public.sales_trip VALUES (26, '2023-01-10', 14, '2023-01-10 14:11:28.476679', '2023-01-10 14:11:28.476679', 0, NULL, NULL, '2023-01-10 14:11:28.476679', 'PicTrip_14_20230110021110.jpg', 'ERWIN , KODAM WR', 14);
INSERT INTO public.sales_trip VALUES (27, '2023-01-10', 14, '2023-01-10 14:17:39.086808', '2023-01-10 14:17:39.086808', 0, NULL, NULL, '2023-01-10 14:17:39.086808', 'PicTrip_14_20230110021724.jpg', 'ERWIN, JOYOBOYO WR', 14);
INSERT INTO public.sales_trip VALUES (32, '2023-01-10', 12, '2023-01-10 14:24:44.424557', '2023-01-10 14:24:44.424557', 0, NULL, NULL, '2023-01-10 14:24:44.424557', 'PicTrip_12_20230110021201.jpg', 'owner-nya keluar tinggalkan kartu nama ', 12);
INSERT INTO public.sales_trip VALUES (33, '2023-01-10', 12, '2023-01-10 14:24:44.4723', '2023-01-10 14:24:44.4723', 0, NULL, NULL, '2023-01-10 14:24:44.4723', 'PicTrip_12_20230110021020.jpg', 'sudah taruh kartu nama, owner-nya keluar ', 12);
INSERT INTO public.sales_trip VALUES (34, '2023-01-10', 12, '2023-01-10 14:25:03.252069', '2023-01-10 14:25:03.252069', 0, NULL, NULL, '2023-01-10 14:25:03.252069', 'PicTrip_12_20230110021201.jpg', 'owner-nya keluar tinggalkan kartu nama ', 12);
INSERT INTO public.sales_trip VALUES (35, '2023-01-10', 12, '2023-01-10 14:26:14.05608', '2023-01-10 14:26:14.05608', 0, NULL, NULL, '2023-01-10 14:26:14.05608', 'PicTrip_12_20230110022518.jpg', 'stok sabun cuci piring yang lama masih banyak ', 12);
INSERT INTO public.sales_trip VALUES (36, '2023-01-10', 12, '2023-01-10 14:37:51.059724', '2023-01-10 14:37:51.059724', 0, NULL, NULL, '2023-01-10 14:37:51.059724', 'PicTrip_12_20230110023649.jpg', 'konsumen maunya beli merk terkenal ', 12);
INSERT INTO public.sales_trip VALUES (38, '2023-01-10', 12, '2023-01-10 14:50:56.349682', '2023-01-10 14:50:56.349682', 1, NULL, NULL, '2023-01-10 14:50:56.349682', 'PicTrip_12_20230110024855.jpg', 'ambil 8 pouch 100gr serbuuu+4pouch 230gr serbuuu ', 12);
INSERT INTO public.sales_trip VALUES (37, '2023-01-10', 14, '2023-01-10 14:48:19.815848', '2023-01-10 14:48:19.815848', 0, NULL, NULL, '2023-01-10 14:48:19.815848', 'PicTrip_14_20230110024747.jpg', 'ERWIN, JOYOBOYO WR', 14);
INSERT INTO public.sales_trip VALUES (39, '2023-01-10', 14, '2023-01-10 15:59:33.333887', '2023-01-10 15:59:33.333887', 0, NULL, NULL, '2023-01-10 15:59:33.333887', 'PicTrip_14_20230110035911.jpg', 'ERWIN, JAMBANGAN TK', 14);
INSERT INTO public.sales_trip VALUES (40, '2023-01-10', 14, '2023-01-10 16:08:28.166334', '2023-01-10 16:08:28.166334', 0, NULL, NULL, '2023-01-10 16:08:28.166334', 'PicTrip_14_20230110040812.jpg', 'ERWIN JAMBANGAN TK', 14);
INSERT INTO public.sales_trip VALUES (41, '2023-01-10', 14, '2023-01-10 18:35:47.335113', '2023-01-10 18:35:47.335113', 0, NULL, NULL, '2023-01-10 18:35:47.335113', 'PicTrip_14_20230110063521.jpg', 'ERWIN, TOKO SOFIA  JAMBANGAN ', 14);
INSERT INTO public.sales_trip VALUES (42, '2023-01-10', 14, '2023-01-10 18:41:10.062338', '2023-01-10 18:41:10.062338', 1, NULL, NULL, '2023-01-10 18:41:10.062338', 'PicTrip_14_20230110064040.jpg', 'ERWIN, TOKO SRI MURNI DAN TOKO ARI JAYA', 14);


--
-- TOC entry 3773 (class 0 OID 18762)
-- Dependencies: 301
-- Data for Name: sales_trip_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sales_trip_detail VALUES (1, 1, '-7.132442', '112.426190', 'VC8G+WF Tambakrigadung, Lamongan Regency, East Java', NULL, NULL, 1, '2023-01-08 06:06:05.654884');
INSERT INTO public.sales_trip_detail VALUES (3, 1, '-7.111111', '172.22222', 'Jalan Missisipi No 5', NULL, NULL, 1, '2023-01-08 12:31:11.661301');
INSERT INTO public.sales_trip_detail VALUES (4, 1, '-7.111111', '172.22222', 'Jalan Missisipi No 5', NULL, NULL, 1, '2023-01-08 12:35:30.336559');
INSERT INTO public.sales_trip_detail VALUES (5, 1, '-7.111111', '172.22222', 'Jalan Missisipi No 5', NULL, NULL, 1, '2023-01-08 12:39:10.093449');
INSERT INTO public.sales_trip_detail VALUES (6, 1, '-7.111111', '172.22222', 'Jalan Missisipi No 5', NULL, NULL, 1, '2023-01-08 12:42:21.488191');
INSERT INTO public.sales_trip_detail VALUES (7, 1, '-7.111111', '172.22222', 'Jalan Missisipi No 5', NULL, NULL, 1, '2023-01-08 12:46:31.982205');
INSERT INTO public.sales_trip_detail VALUES (8, 1, '-7.111111', '172.22222', 'Jalan Missisipi No 5', NULL, NULL, 1, '2023-01-08 12:47:40.433827');
INSERT INTO public.sales_trip_detail VALUES (9, 1, '112.4260764', '-7.1326333', 'VC8G+X9Q, Tambakboyo, Tambakrigadung, Kec. Tikung, Kabupaten Lamongan, Jawa Timur 62281, Indonesia', NULL, NULL, 1, '2023-01-08 14:26:54.57561');
INSERT INTO public.sales_trip_detail VALUES (10, 1, '112.4260738', '-7.1326339', 'VC8G+X9Q, Tambakboyo, Tambakrigadung, Kec. Tikung, Kabupaten Lamongan, Jawa Timur 62281, Indonesia', NULL, NULL, 1, '2023-01-08 14:31:11.554829');
INSERT INTO public.sales_trip_detail VALUES (11, 1, '112.4260721', '-7.1326317', 'VC8G+X9Q, Tambakboyo, Tambakrigadung, Kec. Tikung, Kabupaten Lamongan, Jawa Timur 62281, Indonesia', NULL, NULL, 1, '2023-01-08 14:31:35.623438');
INSERT INTO public.sales_trip_detail VALUES (12, 1, '112.4260728', '-7.1326316', 'VC8G+X9Q, Tambakboyo, Tambakrigadung, Kec. Tikung, Kabupaten Lamongan, Jawa Timur 62281, Indonesia', NULL, NULL, 1, '2023-01-08 14:32:24.383778');
INSERT INTO public.sales_trip_detail VALUES (13, 1, '112.4260753', '-7.1326318', 'VC8G+X9Q, Tambakboyo, Tambakrigadung, Kec. Tikung, Kabupaten Lamongan, Jawa Timur 62281, Indonesia', NULL, NULL, 1, '2023-01-08 14:32:38.951818');
INSERT INTO public.sales_trip_detail VALUES (14, 2, '-7.111111', '172.22222', 'Jalan Missisipi No 5', NULL, NULL, 1, '2023-01-08 12:47:40.433827');
INSERT INTO public.sales_trip_detail VALUES (15, 2, '-7.111111', '172.22222', 'Jalan Missisipi No 5', NULL, NULL, 1, '2023-01-08 20:39:54.964319');
INSERT INTO public.sales_trip_detail VALUES (16, 2, '-7.111111', '172.22222', 'Jalan Missisipi No 5', NULL, NULL, 1, '2023-01-08 20:41:05.931984');
INSERT INTO public.sales_trip_detail VALUES (17, 3, '-7.111111', '172.22222', 'Jalan Missisipi No 5', NULL, NULL, 1, '2023-01-08 20:51:20.630116');
INSERT INTO public.sales_trip_detail VALUES (18, 3, '112.4260759', '-7.1326323', 'VC8G+X9Q, Tambakboyo, Tambakrigadung, Kec. Tikung, Kabupaten Lamongan, Jawa Timur 62281, Indonesia', NULL, NULL, 1, '2023-01-08 20:56:32.160788');
INSERT INTO public.sales_trip_detail VALUES (19, 4, '112.4260767', '-7.1326326', 'VC8G+X9Q, Tambakboyo, Tambakrigadung, Kec. Tikung, Kabupaten Lamongan, Jawa Timur 62281, Indonesia', NULL, NULL, 1, '2023-01-08 20:57:09.975792');
INSERT INTO public.sales_trip_detail VALUES (20, 4, '112.4260782', '-7.1326333', 'VC8G+X9Q, Tambakboyo, Tambakrigadung, Kec. Tikung, Kabupaten Lamongan, Jawa Timur 62281, Indonesia', NULL, NULL, 1, '2023-01-08 20:57:29.853881');
INSERT INTO public.sales_trip_detail VALUES (21, 4, '112.4260749', '-7.1326328', 'VC8G+X9Q, Tambakboyo, Tambakrigadung, Kec. Tikung, Kabupaten Lamongan, Jawa Timur 62281, Indonesia', NULL, NULL, 1, '2023-01-08 20:58:15.861857');
INSERT INTO public.sales_trip_detail VALUES (22, 4, '112.4260971', '-7.1326302', 'VC8G+X9Q, Tambakboyo, Tambakrigadung, Kec. Tikung, Kabupaten Lamongan, Jawa Timur 62281, Indonesia', NULL, NULL, 1, '2023-01-08 22:28:12.851334');
INSERT INTO public.sales_trip_detail VALUES (23, 4, '112.4260971', '-7.1326302', 'VC8G+X9Q, Tambakboyo, Tambakrigadung, Kec. Tikung, Kabupaten Lamongan, Jawa Timur 62281, Indonesia', NULL, NULL, 1, '2023-01-08 22:28:16.589301');
INSERT INTO public.sales_trip_detail VALUES (24, 5, '112.4270975', '-7.134619', 'VC8G+4P7, Tambakboyo, Tambakrigadung, Kec. Tikung, Kabupaten Lamongan, Jawa Timur 62281, Indonesia', NULL, NULL, 1, '2023-01-09 00:26:07.439029');
INSERT INTO public.sales_trip_detail VALUES (25, 5, '112.4270975', '-7.134619', 'VC8G+4P7, Tambakboyo, Tambakrigadung, Kec. Tikung, Kabupaten Lamongan, Jawa Timur 62281, Indonesia', NULL, NULL, 1, '2023-01-09 00:28:19.034787');
INSERT INTO public.sales_trip_detail VALUES (26, 5, '112.4270975', '-7.134619', 'VC8G+4P7, Tambakboyo, Tambakrigadung, Kec. Tikung, Kabupaten Lamongan, Jawa Timur 62281, Indonesia', NULL, NULL, 1, '2023-01-09 00:28:36.405796');
INSERT INTO public.sales_trip_detail VALUES (27, 6, '112.7540981', '-7.4595697', 'GQR3+4M4, Rangkah Kidul, Kec. Sidoarjo, Kabupaten Sidoarjo, Jawa Timur 61234, Indonesia', NULL, NULL, 2, '2023-01-09 10:34:41.704239');
INSERT INTO public.sales_trip_detail VALUES (28, 6, '112.754096', '-7.4595716', 'GQR3+4M4, Rangkah Kidul, Kec. Sidoarjo, Kabupaten Sidoarjo, Jawa Timur 61234, Indonesia', NULL, NULL, 2, '2023-01-09 10:46:26.905243');
INSERT INTO public.sales_trip_detail VALUES (29, 7, '112.7545227', '-7.4597071', 'GQR3+5R4, Rangkah Kidul, Kec. Sidoarjo, Kabupaten Sidoarjo, Jawa Timur 61234, Indonesia', NULL, NULL, 3, '2023-01-09 12:23:07.663231');
INSERT INTO public.sales_trip_detail VALUES (30, 8, '112.5922413', '-7.1517073', 'Jl. Ruby IX No.1, Tebalo, Kec. Manyar, Kabupaten Gresik, Jawa Timur 61151, Indonesia', NULL, NULL, 13, '2023-01-09 16:36:51.6847');
INSERT INTO public.sales_trip_detail VALUES (31, 8, '112.5922502', '-7.1517081', 'Jl. Ruby IX No.1, Tebalo, Kec. Manyar, Kabupaten Gresik, Jawa Timur 61151, Indonesia', NULL, NULL, 13, '2023-01-09 16:39:37.15413');
INSERT INTO public.sales_trip_detail VALUES (32, 6, '119.4969339', '-5.050453', 'WFXW+RR4, Pabentengang, Kec. Marusu, Kabupaten Maros, Sulawesi Selatan 90552, Indonesia', NULL, NULL, 2, '2023-01-09 16:57:26.581664');
INSERT INTO public.sales_trip_detail VALUES (33, 6, '119.4969339', '-5.0504531', 'WFXW+RR4, Pabentengang, Kec. Marusu, Kabupaten Maros, Sulawesi Selatan 90552, Indonesia', NULL, NULL, 2, '2023-01-09 16:57:50.477103');
INSERT INTO public.sales_trip_detail VALUES (34, 9, '119.496934', '-5.050453', '', NULL, NULL, 2, '2023-01-10 08:32:13.994859');
INSERT INTO public.sales_trip_detail VALUES (35, 10, '119.5293273', '-5.1021855', 'VGXH+4P3, Jl. Laikang, Sudiang Raya, Kec. Biringkanaya, Kota Makassar, Sulawesi Selatan 90552, Indonesia', NULL, NULL, 2, '2023-01-10 10:18:04.09772');
INSERT INTO public.sales_trip_detail VALUES (36, 11, '119.5287028', '-5.1025718', 'Jl. Laikang Raya Ruko 4 No.1, RT.2/RW.7, Sudiang Raya, Kec. Biringkanaya, Kota Makassar, Sulawesi Selatan 90242, Indonesia', NULL, NULL, 2, '2023-01-10 10:19:44.324304');
INSERT INTO public.sales_trip_detail VALUES (37, 12, '109.7245554', '-6.9059868', 'Jl. Jendral Sudirman No.29, Kasepuhan, Kec. Batang, Kabupaten Batang, Jawa Tengah 51216, Indonesia', NULL, NULL, 4, '2023-01-10 10:20:51.118672');
INSERT INTO public.sales_trip_detail VALUES (38, 13, '119.5270926', '-5.1037271', 'VGWG+GV6, Jl. Pajjaiang, Sudiang Raya, Kec. Biringkanaya, Kota Makassar, Sulawesi Selatan 90552, Indonesia', NULL, NULL, 2, '2023-01-10 10:24:22.715643');
INSERT INTO public.sales_trip_detail VALUES (39, 14, '119.5317282', '-5.0849112', 'WG7J+XPR, Sudiang, Kec. Biringkanaya, Kota Makassar, Sulawesi Selatan 90552, Indonesia', NULL, NULL, 2, '2023-01-10 10:41:40.774972');
INSERT INTO public.sales_trip_detail VALUES (40, 15, '112.6230449', '-7.1615754', 'Jl. Asahan No.52, RW.02, Setingi, Randuagung, Kec. Gresik, Kabupaten Gresik, Jawa Timur 61121, Indonesia', NULL, NULL, 13, '2023-01-10 11:13:18.860167');
INSERT INTO public.sales_trip_detail VALUES (41, 16, '112.6237758', '-7.1616462', 'RJQF+9H2, Setingi, Randuagung, Kec. Kebomas, Kabupaten Gresik, Jawa Timur 61121, Indonesia', NULL, NULL, 13, '2023-01-10 11:19:03.800898');
INSERT INTO public.sales_trip_detail VALUES (42, 17, '112.6154882', '-7.1441469', 'Jl. Kalimantan No.149, Wonorejo, Yosowilangun, Kec. Manyar, Kabupaten Gresik, Jawa Timur 61151, Indonesia', NULL, NULL, 13, '2023-01-10 11:37:34.340804');
INSERT INTO public.sales_trip_detail VALUES (43, 18, '112.4299994', '-7.5414615', 'FC5H+FX4, Jl. Plososari - Padangan, Brongkol Wetan, Kintelan, Kec. Puri, Kabupaten Mojokerto, Jawa Timur 61363, Indonesia', NULL, NULL, 12, '2023-01-10 12:02:17.523024');
INSERT INTO public.sales_trip_detail VALUES (44, 19, '112.6126446', '-7.1446873', 'Jl. Barabai No.2, Ponganganrejo, Yosowilangun, Kec. Manyar, Kabupaten Gresik, Jawa Timur 61151, Indonesia', NULL, NULL, 13, '2023-01-10 13:09:09.626042');
INSERT INTO public.sales_trip_detail VALUES (45, 20, '112.6040381', '-7.1490051', 'Jl. Panggang No.99, Suci, Kec. Manyar, Kabupaten Gresik, Jawa Timur 61151, Indonesia', NULL, NULL, 13, '2023-01-10 13:17:04.728901');
INSERT INTO public.sales_trip_detail VALUES (46, 21, '112.6029352', '-7.148071', 'Jl. Panggang Raya Suci RT.03/RW.05, Suci, Kec. Manyar, Kabupaten Gresik, Jawa Timur 61151, Indonesia', NULL, NULL, 13, '2023-01-10 13:22:30.274114');
INSERT INTO public.sales_trip_detail VALUES (47, 22, '112.6022827', '-7.1478382', 'Gg. .H.Romli No.116, Suci, Kec. Manyar, Kabupaten Gresik, Jawa Timur 61151, Indonesia', NULL, NULL, 13, '2023-01-10 13:32:05.916918');
INSERT INTO public.sales_trip_detail VALUES (48, 23, '112.7250983', '-7.2973967', 'Jl. Kesatriyan No.15, Sawunggaling, Kec. Wonokromo, Kota SBY, Jawa Timur 60242, Indonesia', NULL, NULL, 14, '2023-01-10 13:40:38.544209');
INSERT INTO public.sales_trip_detail VALUES (49, 24, '112.6020447', '-7.1415246', 'VJ52+9RC, Jl. Kyai H. Syafiꞌi, Suci, Kec. Manyar, Kabupaten Gresik, Jawa Timur 61151, Indonesia', NULL, NULL, 13, '2023-01-10 13:58:38.749215');
INSERT INTO public.sales_trip_detail VALUES (50, 25, '112.6091602', '-7.1392377', 'Jl. Kyai H. Syafiꞌi No.10, Suci, Kec. Manyar, Kabupaten Gresik, Jawa Timur 61151, Indonesia', NULL, NULL, 13, '2023-01-10 14:05:07.230001');
INSERT INTO public.sales_trip_detail VALUES (51, 26, '112.72897', '-7.29724', 'Jl. Brawijaya No.38, Sawunggaling, Kec. Wonokromo, Kota SBY, Jawa Timur 60242, Indonesia', NULL, NULL, 14, '2023-01-10 14:11:28.512398');
INSERT INTO public.sales_trip_detail VALUES (52, 27, '112.7306567', '-7.2986883', 'Jl. Brawijaya No.10, Sawunggaling, Kec. Wonokromo, Kota SBY, Jawa Timur 60242, Indonesia', NULL, NULL, 14, '2023-01-10 14:17:39.125576');
INSERT INTO public.sales_trip_detail VALUES (53, 28, '112.4184534', '-7.5277968', 'FCC9+VC6, Jl. Raya Perjuangan, Brangkal, Kec. Sooko, Kabupaten Mojokerto, Jawa Timur 61361, Indonesia', NULL, NULL, 12, '2023-01-10 14:24:44.364356');
INSERT INTO public.sales_trip_detail VALUES (54, 29, '112.4184534', '-7.5277968', 'FCC9+VC6, Jl. Raya Perjuangan, Brangkal, Kec. Sooko, Kabupaten Mojokerto, Jawa Timur 61361, Indonesia', NULL, NULL, 12, '2023-01-10 14:24:44.390892');
INSERT INTO public.sales_trip_detail VALUES (55, 30, '112.4184534', '-7.5277968', 'FCC9+VC6, Jl. Raya Perjuangan, Brangkal, Kec. Sooko, Kabupaten Mojokerto, Jawa Timur 61361, Indonesia', NULL, NULL, 12, '2023-01-10 14:24:44.42714');
INSERT INTO public.sales_trip_detail VALUES (56, 31, '112.4184534', '-7.5277968', 'FCC9+VC6, Jl. Raya Perjuangan, Brangkal, Kec. Sooko, Kabupaten Mojokerto, Jawa Timur 61361, Indonesia', NULL, NULL, 12, '2023-01-10 14:24:44.474824');
INSERT INTO public.sales_trip_detail VALUES (57, 32, '112.4188966', '-7.5287563', '', NULL, NULL, 12, '2023-01-10 14:24:44.496116');
INSERT INTO public.sales_trip_detail VALUES (58, 33, '112.4184534', '-7.5277968', 'FCC9+VC6, Jl. Raya Perjuangan, Brangkal, Kec. Sooko, Kabupaten Mojokerto, Jawa Timur 61361, Indonesia', NULL, NULL, 12, '2023-01-10 14:24:44.527191');
INSERT INTO public.sales_trip_detail VALUES (59, 34, '112.4188966', '-7.5287563', '', NULL, NULL, 12, '2023-01-10 14:25:03.281001');
INSERT INTO public.sales_trip_detail VALUES (60, 35, '112.4191086', '-7.523453', 'FCG9+JJ4, Jl. Raya Perjuangan, Brangkal, Kec. Sooko, Kabupaten Mojokerto, Jawa Timur 61361, Indonesia', NULL, NULL, 12, '2023-01-10 14:26:14.083884');
INSERT INTO public.sales_trip_detail VALUES (61, 36, '112.4142281', '-7.5239482', 'Jl. Wringin Rejo No.9, Kedung Maling 3, Sambiroto, Kec. Sooko, Kabupaten Mojokerto, Jawa Timur 61361, Indonesia', NULL, NULL, 12, '2023-01-10 14:37:51.092669');
INSERT INTO public.sales_trip_detail VALUES (62, 37, '112.7307717', '-7.3002608', 'Jl. Gunungsari No.33, Sawunggaling, Kec. Wonokromo, Kota SBY, Jawa Timur 60242, Indonesia', NULL, NULL, 14, '2023-01-10 14:48:19.850727');
INSERT INTO public.sales_trip_detail VALUES (63, 38, '112.413673', '-7.5251162', 'FCF7+WFC, Kedung Maling 3, Kedungmaling, Kec. Sooko, Kabupaten Mojokerto, Jawa Timur 61361, Indonesia', NULL, NULL, 12, '2023-01-10 14:50:56.374749');
INSERT INTO public.sales_trip_detail VALUES (64, 39, '112.7116688', '-7.316766', 'Jl. Jambangan No.47-B, RT.004/RW.01, Jambangan, Kec. Jambangan, Kota SBY, Jawa Timur 60232, Indonesia', NULL, NULL, 14, '2023-01-10 15:59:33.370919');
INSERT INTO public.sales_trip_detail VALUES (65, 40, '112.7116623', '-7.3175037', 'Jl. Jambangan No.65, Jambangan, Kec. Jambangan, Kota SBY, Jawa Timur 60232, Indonesia', NULL, NULL, 14, '2023-01-10 16:08:28.293628');
INSERT INTO public.sales_trip_detail VALUES (66, 14, '119.4969345', '-5.0504526', 'WFXW+RR4, Pabentengang, Kec. Marusu, Kabupaten Maros, Sulawesi Selatan 90552, Indonesia', NULL, NULL, 2, '2023-01-10 16:14:07.947676');
INSERT INTO public.sales_trip_detail VALUES (67, 14, '119.4969271', '-5.0504537', 'WFXW+RR4, Pabentengang, Kec. Marusu, Kabupaten Maros, Sulawesi Selatan 90552, Indonesia', NULL, NULL, 2, '2023-01-10 16:16:13.371478');
INSERT INTO public.sales_trip_detail VALUES (68, 25, '112.5919224', '-7.1383476', 'Jl. Optima 6 No.14, Banjarsari, Suci, Kec. Manyar, Kabupaten Gresik, Jawa Timur 61151, Indonesia', NULL, NULL, 13, '2023-01-10 17:45:42.446721');
INSERT INTO public.sales_trip_detail VALUES (69, 41, '112.7161435', '-7.3289055', 'Kebonsari Regency No.33, Kebonsari, Kec. Jambangan, Kota SBY, Jawa Timur 60233, Indonesia', NULL, NULL, 14, '2023-01-10 18:35:48.184557');
INSERT INTO public.sales_trip_detail VALUES (70, 42, '112.7113019', '-7.3301067', 'Jl. Kebonsari Tengah No.86, Kebonsari, Kec. Jambangan, Kota SBY, Jawa Timur 60233, Indonesia', NULL, NULL, 14, '2023-01-10 18:41:10.099179');


--
-- TOC entry 3744 (class 0 OID 18322)
-- Dependencies: 272
-- Data for Name: setting_document_counter; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.setting_document_counter VALUES (10, 'Receive', 'RCV', 'Yearly', 0, NULL, NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (12, 'Purchase', 'PO', 'Yearly', 0, NULL, NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (17, 'Purchase', 'PO', 'Yearly', 0, NULL, NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (15, 'Receive', 'RCV', 'Yearly', 1, '2022-11-26 01:26:53', NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (19, 'Return Invoice', 'REI', 'Yearly', 1, '2022-11-26 01:15:01', NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (20, 'Return Invoice', 'REI', 'Yearly', 1, '2022-11-26 01:15:01', NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (21, 'Return Invoice', 'REI', 'Yearly', 1, '2022-11-26 01:15:01', NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (4, 'Purchase', 'PO', 'Yearly', 0, '2023-01-02 12:36:55', NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (25, 'Invoice', 'INV', 'Yearly', 0, '2023-01-02 08:23:30', NULL, NULL, '2022-11-25 20:43:40.854575', 4);
INSERT INTO public.setting_document_counter VALUES (26, 'Invoice', 'INV', 'Yearly', 0, '2023-01-02 08:23:30', NULL, NULL, '2022-11-25 20:43:40.854575', 5);
INSERT INTO public.setting_document_counter VALUES (27, 'Invoice Internal', 'INVI', 'Yearly', 0, '2023-01-02 08:23:30', NULL, NULL, '2022-11-25 20:43:40.854575', 4);
INSERT INTO public.setting_document_counter VALUES (28, 'Invoice Internal', 'INVI', 'Yearly', 0, '2023-01-02 08:23:30', NULL, NULL, '2022-11-25 20:43:40.854575', 5);
INSERT INTO public.setting_document_counter VALUES (22, 'Invoice Internal', 'INVI', 'Yearly', 0, '2023-01-02 08:23:30', NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (23, 'Invoice Internal', 'INVI', 'Yearly', 0, '2023-01-02 08:23:30', NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (24, 'Invoice Internal', 'INVI', 'Yearly', 0, '2023-01-02 08:23:30', NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (29, 'Order', 'SPK', 'Yearly', 0, '2023-01-02 12:33:33', NULL, NULL, '2022-11-25 20:43:40.854575', 4);
INSERT INTO public.setting_document_counter VALUES (30, 'Order', 'SPK', 'Yearly', 0, '2023-01-02 12:33:33', NULL, NULL, '2022-11-25 20:43:40.854575', 5);
INSERT INTO public.setting_document_counter VALUES (33, 'Purchase', 'PO', 'Yearly', 0, '2023-01-02 12:36:55', NULL, NULL, '2022-11-25 20:43:40.854575', 4);
INSERT INTO public.setting_document_counter VALUES (34, 'Purchase', 'PO', 'Yearly', 0, '2023-01-02 12:36:55', NULL, NULL, '2022-11-25 20:43:40.854575', 5);
INSERT INTO public.setting_document_counter VALUES (35, 'Receive', 'RCV', 'Yearly', 3, '2022-12-30 16:01:45', NULL, NULL, '2022-11-25 20:43:40.854575', 4);
INSERT INTO public.setting_document_counter VALUES (36, 'Receive', 'RCV', 'Yearly', 3, '2022-12-30 16:01:45', NULL, NULL, '2022-11-25 20:43:40.854575', 5);
INSERT INTO public.setting_document_counter VALUES (38, 'Return Invoice', 'REI', 'Yearly', 1, '2022-11-26 01:15:01', NULL, NULL, '2022-11-25 20:43:40.854575', 5);
INSERT INTO public.setting_document_counter VALUES (39, 'Return Invoice', 'REI', 'Yearly', 1, '2022-11-26 01:15:01', NULL, NULL, '2022-11-25 20:43:40.854575', 4);
INSERT INTO public.setting_document_counter VALUES (3, 'Invoice', 'INV', 'Yearly', 2, '2023-01-10 21:53:34', NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (31, 'Order_Queue', 'SPK', 'Daily', 0, '2023-01-10 22:09:13', NULL, NULL, '2022-11-25 20:43:40.854575', 4);
INSERT INTO public.setting_document_counter VALUES (32, 'Order_Queue', 'SPK', 'Daily', 0, '2023-01-10 22:09:13', NULL, NULL, '2022-11-25 20:43:40.854575', 5);
INSERT INTO public.setting_document_counter VALUES (9, 'Order_Queue', 'SPK', 'Daily', 0, '2023-01-10 22:09:13', NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (14, 'Order_Queue', 'SPK', 'Daily', 0, '2023-01-10 22:09:13', NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (2, 'Order_Queue', 'SPK', 'Daily', 0, '2023-01-10 22:09:13', NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (5, 'Receive', 'RCV', 'Yearly', 3, '2022-12-30 16:01:45', NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (16, 'Invoice', 'INV', 'Yearly', 0, '2023-01-02 08:23:30', NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (11, 'Invoice', 'INV', 'Yearly', 0, '2023-01-02 08:23:30', NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (13, 'Order', 'SPK', 'Yearly', 0, '2023-01-02 12:33:33', NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (18, 'Order', 'SPK', 'Yearly', 0, '2023-01-02 12:33:33', NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (1, 'Order', 'SPK', 'Yearly', 0, '2023-01-02 12:33:33', NULL, NULL, '2022-11-25 20:43:40.854575', 1);


--
-- TOC entry 3746 (class 0 OID 18332)
-- Dependencies: 274
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.settings VALUES ('2022-07-16', 202207, 'Kakiku', 'Lapak ERP', 'v0.0.1', 'logo_kakiku.png');


--
-- TOC entry 3747 (class 0 OID 18339)
-- Dependencies: 275
-- Data for Name: shift; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.shift VALUES (1, 'Shift I Pagi 08-15', '08:00:00', '15:00:00', NULL, '2022-12-29 22:11:42', '2022-09-09 10:14:57.221863');
INSERT INTO public.shift VALUES (2, 'Shift II Sore 15-21', '15:00:00', '21:00:00', NULL, '2022-12-29 22:11:51', '2022-09-09 10:14:57.221863');


--
-- TOC entry 3748 (class 0 OID 18348)
-- Dependencies: 276
-- Data for Name: shift_counter; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.shift_counter VALUES (31, 1, NULL, '2022-12-03 16:02:09.554428', 1, '2022-12-03 07:30:22.230869', 2);
INSERT INTO public.shift_counter VALUES (29, 2, NULL, '2022-12-03 16:02:09.554428', 1, '2022-12-03 07:30:22.230869', 2);
INSERT INTO public.shift_counter VALUES (53, 3, NULL, '2022-12-03 16:02:09.554428', 1, '2022-12-03 07:30:22.230869', 2);
INSERT INTO public.shift_counter VALUES (30, 0, NULL, '2022-12-03 16:35:48.814707', 1, '2022-12-03 07:30:22.230869', 3);
INSERT INTO public.shift_counter VALUES (27, -7, NULL, '2022-12-28 08:02:33.356619', 1, '2022-12-03 07:30:22.230869', 1);
INSERT INTO public.shift_counter VALUES (32, -6, NULL, '2022-12-28 08:02:33.356619', 1, '2022-12-03 07:30:22.230869', 1);
INSERT INTO public.shift_counter VALUES (14, 3, NULL, '2022-12-28 08:02:33.356619', 1, '2022-12-03 07:30:22.230869', 1);
INSERT INTO public.shift_counter VALUES (33, 4, NULL, '2022-12-28 08:02:33.356619', 1, '2022-12-03 07:30:22.230869', 1);


--
-- TOC entry 3750 (class 0 OID 18354)
-- Dependencies: 278
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.suppliers VALUES (2, 'Test Supplier 02', 'Jalan Mawar Mandiri No 01', 2, 'test@gmail.com', '085746879090', NULL, NULL, '2022-09-04 11:31:10.765461');


--
-- TOC entry 3730 (class 0 OID 18204)
-- Dependencies: 258
-- Data for Name: uom; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.uom VALUES (1, 'Botol', 1, '2022-06-01 20:55:39.248472', NULL, 1);
INSERT INTO public.uom VALUES (2, 'Bungkus', 1, '2022-06-01 20:55:39.248472', NULL, 1);
INSERT INTO public.uom VALUES (3, 'Tube', 1, '2022-06-01 20:55:39.248472', NULL, 1);
INSERT INTO public.uom VALUES (4, 'Buah', 1, '2022-06-01 20:55:39.248472', NULL, 1);
INSERT INTO public.uom VALUES (5, 'Sacheet', 1, '2022-06-01 20:55:39.248472', NULL, 1);
INSERT INTO public.uom VALUES (6, 'Kotak', 1, '2022-06-01 20:55:39.248472', NULL, 1);
INSERT INTO public.uom VALUES (7, 'Amplus', 1, '2022-06-01 20:55:39.248472', NULL, 1);
INSERT INTO public.uom VALUES (8, 'Pcs', 1, '2022-06-01 20:55:39.248472', NULL, 1);
INSERT INTO public.uom VALUES (18, 'Pasang', 1, '2022-06-01 20:55:39.248472', NULL, 1);
INSERT INTO public.uom VALUES (23, 'Renceng', 1, '2022-07-25 14:17:17', '2022-07-25 14:17:24', 1);
INSERT INTO public.uom VALUES (9, '90 Menit', 90, '2022-06-01 20:55:39.248472', NULL, 2);
INSERT INTO public.uom VALUES (10, '30 Menit', 30, '2022-06-01 20:55:39.248472', NULL, 2);
INSERT INTO public.uom VALUES (11, '45 Menit', 45, '2022-06-01 20:55:39.248472', NULL, 2);
INSERT INTO public.uom VALUES (12, '120 Menit', 120, '2022-06-01 20:55:39.248472', NULL, 2);
INSERT INTO public.uom VALUES (13, '5 Menit', 5, '2022-06-01 20:55:39.248472', NULL, 2);
INSERT INTO public.uom VALUES (14, '10 Menit', 10, '2022-06-01 20:55:39.248472', NULL, 2);
INSERT INTO public.uom VALUES (15, '15 Menit', 15, '2022-06-01 20:55:39.248472', NULL, 2);
INSERT INTO public.uom VALUES (16, '20 Menit', 20, '2022-06-01 20:55:39.248472', NULL, 2);
INSERT INTO public.uom VALUES (17, '1 Menit', 1, '2022-06-01 20:55:39.248472', NULL, 2);
INSERT INTO public.uom VALUES (19, '60 Menit', 60, '2022-06-01 20:55:39.248472', NULL, 2);
INSERT INTO public.uom VALUES (20, '150 Menit', 150, '2022-06-01 20:55:39.248472', NULL, 2);
INSERT INTO public.uom VALUES (21, '100 Menit', 100, '2022-06-01 20:55:39.248472', NULL, 2);
INSERT INTO public.uom VALUES (24, '200 Menit', 1, '2022-11-15 19:34:12', '2022-11-15 19:34:12', 2);


--
-- TOC entry 3752 (class 0 OID 18363)
-- Dependencies: 280
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES (56, 'admin_smd', 'adminsmd@gmail.com', 'admin_smd', NULL, '$2y$10$f8iq3Oa6Ibn7HbAFPdtEEOyP4cn/41oAaRGIC2qgzJTwBExV2ledC', NULL, '2023-01-10 22:03:43', '2023-01-10 22:03:43', '085746879090', 'Lamongan', '2023-01-08', 1, 'Male', '35241112331443300021', 'Lamongan', '11111', NULL, NULL, 6, 1, 5, NULL, 'Tempat Lahir', '2023-01-31', 'Permanent', 1);
INSERT INTO public.users VALUES (1, 'Admin', 'admin@gmail.com', 'admin', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-05-28 12:40:11', '6285746879090', 'JALAN JAKARTA', '2020-01-01', 3, 'Male', '3524111233144330001', 'JAKARTA', '20210101ADM', 'user-13.jpg', 'user-13.jpg', 6, 1, 5, NULL, 'JAKARTA', '2022-01-01', 'On Job Training', 1);


--
-- TOC entry 3753 (class 0 OID 18371)
-- Dependencies: 281
-- Data for Name: users_branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users_branch VALUES (1, 1, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (56, 1, '2023-01-10 22:03:43', '2023-01-10 22:03:43');
INSERT INTO public.users_branch VALUES (1, 13, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (1, 14, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (1, 15, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (1, 16, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (1, 17, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (1, 18, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (1, 19, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (1, 20, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (1, 21, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (56, 13, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (56, 14, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (56, 15, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (56, 16, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (56, 17, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (56, 18, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (56, 19, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (56, 20, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (56, 21, '2022-07-06 12:09:12', '2022-07-06 12:09:12');


--
-- TOC entry 3754 (class 0 OID 18375)
-- Dependencies: 282
-- Data for Name: users_experience; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users_experience VALUES (1, 2, 'Astra', 'Coordinator Sales', '2019-2020', NULL, 1, '2022-08-21 11:41:24.412471');


--
-- TOC entry 3757 (class 0 OID 18386)
-- Dependencies: 285
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
INSERT INTO public.users_mutation VALUES (41, 55, 1, 3, 1, NULL, '2022-12-30 18:54:14', '2022-12-30 18:54:14');
INSERT INTO public.users_mutation VALUES (42, 56, 1, 5, 6, NULL, '2023-01-10 22:03:43', '2023-01-10 22:03:43');


--
-- TOC entry 3759 (class 0 OID 18395)
-- Dependencies: 287
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
-- TOC entry 3761 (class 0 OID 18404)
-- Dependencies: 289
-- Data for Name: users_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3762 (class 0 OID 18412)
-- Dependencies: 290
-- Data for Name: voucher; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.voucher VALUES (4, 'TESTAAVC23', 1, '2022-09-18', '2022-09-23', 0, '2022-09-18 01:22:56', 1, '2022-09-18 01:22:42', 18, 50, 'test Voucher');
INSERT INTO public.voucher VALUES (5, 'CSSKR', 1, '2022-09-05', '2022-09-20', 0, '2022-09-18 01:23:32', 1, '2022-09-18 01:23:32', 1, 50, 'TEst II');
INSERT INTO public.voucher VALUES (1, 'ABC', 1, '2022-09-01', '2022-10-30', 0, '2022-09-26 12:21:12', 1, '2022-09-17 12:45:52.973274', 1, 100, 'VOUCHER 100%');


--
-- TOC entry 3827 (class 0 OID 0)
-- Dependencies: 203
-- Name: branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_id_seq', 21, true);


--
-- TOC entry 3828 (class 0 OID 0)
-- Dependencies: 205
-- Name: branch_room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_room_id_seq', 13, true);


--
-- TOC entry 3829 (class 0 OID 0)
-- Dependencies: 292
-- Name: branch_shift_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_shift_id_seq', 2, true);


--
-- TOC entry 3830 (class 0 OID 0)
-- Dependencies: 304
-- Name: calendar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);


--
-- TOC entry 3831 (class 0 OID 0)
-- Dependencies: 207
-- Name: company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.company_id_seq', 1, true);


--
-- TOC entry 3832 (class 0 OID 0)
-- Dependencies: 209
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_id_seq', 30, true);


--
-- TOC entry 3833 (class 0 OID 0)
-- Dependencies: 302
-- Name: customers_registration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_registration_id_seq', 11, true);


--
-- TOC entry 3834 (class 0 OID 0)
-- Dependencies: 211
-- Name: department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.department_id_seq', 10, true);


--
-- TOC entry 3835 (class 0 OID 0)
-- Dependencies: 213
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- TOC entry 3836 (class 0 OID 0)
-- Dependencies: 216
-- Name: invoice_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invoice_master_id_seq', 106, true);


--
-- TOC entry 3837 (class 0 OID 0)
-- Dependencies: 218
-- Name: job_title_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);


--
-- TOC entry 3838 (class 0 OID 0)
-- Dependencies: 220
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);


--
-- TOC entry 3839 (class 0 OID 0)
-- Dependencies: 225
-- Name: order_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);


--
-- TOC entry 3840 (class 0 OID 0)
-- Dependencies: 229
-- Name: period_price_sell_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.period_price_sell_id_seq', 884, true);


--
-- TOC entry 3841 (class 0 OID 0)
-- Dependencies: 232
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 500, true);


--
-- TOC entry 3842 (class 0 OID 0)
-- Dependencies: 234
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);


--
-- TOC entry 3843 (class 0 OID 0)
-- Dependencies: 237
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 2, true);


--
-- TOC entry 3844 (class 0 OID 0)
-- Dependencies: 239
-- Name: price_adjustment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);


--
-- TOC entry 3845 (class 0 OID 0)
-- Dependencies: 241
-- Name: product_brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_brand_id_seq', 9, true);


--
-- TOC entry 3846 (class 0 OID 0)
-- Dependencies: 243
-- Name: product_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_category_id_seq', 15, true);


--
-- TOC entry 3847 (class 0 OID 0)
-- Dependencies: 251
-- Name: product_sku_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_sku_id_seq', 90, true);


--
-- TOC entry 3848 (class 0 OID 0)
-- Dependencies: 254
-- Name: product_stock_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 24, true);


--
-- TOC entry 3849 (class 0 OID 0)
-- Dependencies: 256
-- Name: product_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);


--
-- TOC entry 3850 (class 0 OID 0)
-- Dependencies: 259
-- Name: product_uom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_uom_id_seq', 24, true);


--
-- TOC entry 3851 (class 0 OID 0)
-- Dependencies: 262
-- Name: purchase_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_master_id_seq', 18, true);


--
-- TOC entry 3852 (class 0 OID 0)
-- Dependencies: 265
-- Name: receive_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.receive_master_id_seq', 31, true);


--
-- TOC entry 3853 (class 0 OID 0)
-- Dependencies: 268
-- Name: return_sell_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);


--
-- TOC entry 3854 (class 0 OID 0)
-- Dependencies: 271
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 12, true);


--
-- TOC entry 3855 (class 0 OID 0)
-- Dependencies: 296
-- Name: sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_id_seq', 24, true);


--
-- TOC entry 3856 (class 0 OID 0)
-- Dependencies: 300
-- Name: sales_trip_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 70, true);


--
-- TOC entry 3857 (class 0 OID 0)
-- Dependencies: 298
-- Name: sales_trip_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_trip_id_seq', 42, true);


--
-- TOC entry 3858 (class 0 OID 0)
-- Dependencies: 273
-- Name: setting_document_counter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 39, true);


--
-- TOC entry 3859 (class 0 OID 0)
-- Dependencies: 277
-- Name: shift_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shift_id_seq', 10, true);


--
-- TOC entry 3860 (class 0 OID 0)
-- Dependencies: 279
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 4, true);


--
-- TOC entry 3861 (class 0 OID 0)
-- Dependencies: 294
-- Name: sv_login_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sv_login_session_id_seq', 132, true);


--
-- TOC entry 3862 (class 0 OID 0)
-- Dependencies: 283
-- Name: users_experience_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);


--
-- TOC entry 3863 (class 0 OID 0)
-- Dependencies: 284
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 56, true);


--
-- TOC entry 3864 (class 0 OID 0)
-- Dependencies: 286
-- Name: users_mutation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_mutation_id_seq', 42, true);


--
-- TOC entry 3865 (class 0 OID 0)
-- Dependencies: 288
-- Name: users_shift_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);


--
-- TOC entry 3866 (class 0 OID 0)
-- Dependencies: 291
-- Name: voucher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.voucher_id_seq', 5, true);


--
-- TOC entry 3379 (class 2606 OID 18459)
-- Name: branch branch_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);


--
-- TOC entry 3383 (class 2606 OID 18461)
-- Name: branch_room branch_room_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);


--
-- TOC entry 3381 (class 2606 OID 18463)
-- Name: branch branch_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);


--
-- TOC entry 3521 (class 2606 OID 26927)
-- Name: calendar calendar_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);


--
-- TOC entry 3385 (class 2606 OID 18465)
-- Name: company company_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);


--
-- TOC entry 3387 (class 2606 OID 18467)
-- Name: customers customers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);


--
-- TOC entry 3519 (class 2606 OID 18784)
-- Name: customers_registration customers_registration_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_registration
    ADD CONSTRAINT customers_registration_pk PRIMARY KEY (id);


--
-- TOC entry 3389 (class 2606 OID 18469)
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- TOC entry 3391 (class 2606 OID 18471)
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- TOC entry 3393 (class 2606 OID 18473)
-- Name: invoice_detail invoice_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);


--
-- TOC entry 3395 (class 2606 OID 18475)
-- Name: invoice_master invoice_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);


--
-- TOC entry 3397 (class 2606 OID 18477)
-- Name: invoice_master invoice_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);


--
-- TOC entry 3399 (class 2606 OID 18479)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3402 (class 2606 OID 18481)
-- Name: model_has_permissions model_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);


--
-- TOC entry 3405 (class 2606 OID 18483)
-- Name: model_has_roles model_has_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);


--
-- TOC entry 3407 (class 2606 OID 18485)
-- Name: order_detail order_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);


--
-- TOC entry 3409 (class 2606 OID 18487)
-- Name: order_master order_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);


--
-- TOC entry 3411 (class 2606 OID 18489)
-- Name: order_master order_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);


--
-- TOC entry 3414 (class 2606 OID 18491)
-- Name: period_stock period_stock_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);


--
-- TOC entry 3416 (class 2606 OID 18493)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3418 (class 2606 OID 18495)
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3420 (class 2606 OID 18497)
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- TOC entry 3423 (class 2606 OID 18499)
-- Name: point_conversion point_conversion_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);


--
-- TOC entry 3425 (class 2606 OID 18501)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- TOC entry 3427 (class 2606 OID 18503)
-- Name: price_adjustment price_adjustment_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);


--
-- TOC entry 3429 (class 2606 OID 18505)
-- Name: price_adjustment price_adjustment_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);


--
-- TOC entry 3431 (class 2606 OID 18507)
-- Name: product_commision_by_year product_commision_by_year_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);


--
-- TOC entry 3433 (class 2606 OID 18509)
-- Name: product_commisions product_commisions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3435 (class 2606 OID 18511)
-- Name: product_distribution product_distribution_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3437 (class 2606 OID 18513)
-- Name: product_ingredients product_ingredients_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pk PRIMARY KEY (product_id, product_id_material);


--
-- TOC entry 3439 (class 2606 OID 18515)
-- Name: product_point product_point_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3441 (class 2606 OID 18517)
-- Name: product_price product_price_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3443 (class 2606 OID 18519)
-- Name: product_sku product_sku_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);


--
-- TOC entry 3445 (class 2606 OID 18521)
-- Name: product_sku product_sku_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_un UNIQUE (abbr);


--
-- TOC entry 3449 (class 2606 OID 18523)
-- Name: product_stock_detail product_stock_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock_detail
    ADD CONSTRAINT product_stock_detail_pk PRIMARY KEY (id);


--
-- TOC entry 3447 (class 2606 OID 18525)
-- Name: product_stock product_stock_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3451 (class 2606 OID 18527)
-- Name: product_uom product_uom_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_pk PRIMARY KEY (product_id, uom_id);


--
-- TOC entry 3457 (class 2606 OID 18529)
-- Name: purchase_detail purchase_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_pk PRIMARY KEY (purchase_no, product_id);


--
-- TOC entry 3459 (class 2606 OID 18531)
-- Name: purchase_master purchase_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_pk PRIMARY KEY (id);


--
-- TOC entry 3461 (class 2606 OID 18533)
-- Name: purchase_master purchase_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_un UNIQUE (purchase_no);


--
-- TOC entry 3463 (class 2606 OID 18535)
-- Name: receive_detail receive_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_pk PRIMARY KEY (receive_no, product_id, expired_at);


--
-- TOC entry 3465 (class 2606 OID 18537)
-- Name: receive_master receive_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_pk PRIMARY KEY (id);


--
-- TOC entry 3467 (class 2606 OID 18539)
-- Name: receive_master receive_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_un UNIQUE (receive_no);


--
-- TOC entry 3469 (class 2606 OID 18541)
-- Name: return_sell_detail return_sell_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_pk PRIMARY KEY (return_sell_no, product_id);


--
-- TOC entry 3471 (class 2606 OID 18543)
-- Name: return_sell_master return_sell_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_pk PRIMARY KEY (id);


--
-- TOC entry 3473 (class 2606 OID 18545)
-- Name: return_sell_master return_sell_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_un UNIQUE (return_sell_no);


--
-- TOC entry 3475 (class 2606 OID 18547)
-- Name: role_has_permissions role_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);


--
-- TOC entry 3477 (class 2606 OID 18549)
-- Name: roles roles_name_guard_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);


--
-- TOC entry 3479 (class 2606 OID 18551)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3511 (class 2606 OID 18745)
-- Name: sales sales_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pk PRIMARY KEY (id);


--
-- TOC entry 3517 (class 2606 OID 18771)
-- Name: sales_trip_detail sales_trip_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_trip_detail
    ADD CONSTRAINT sales_trip_detail_pk PRIMARY KEY (id);


--
-- TOC entry 3515 (class 2606 OID 18759)
-- Name: sales_trip sales_trip_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_trip
    ADD CONSTRAINT sales_trip_pk PRIMARY KEY (id);


--
-- TOC entry 3513 (class 2606 OID 18747)
-- Name: sales sales_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_un UNIQUE (username);


--
-- TOC entry 3481 (class 2606 OID 18553)
-- Name: setting_document_counter setting_document_counter_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_pk PRIMARY KEY (id);


--
-- TOC entry 3483 (class 2606 OID 18555)
-- Name: setting_document_counter setting_document_counter_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_un UNIQUE (doc_type, branch_id);


--
-- TOC entry 3485 (class 2606 OID 18557)
-- Name: settings settings_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (company_name, app_name);


--
-- TOC entry 3487 (class 2606 OID 18559)
-- Name: shift shift_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pk PRIMARY KEY (time_start, time_end);


--
-- TOC entry 3489 (class 2606 OID 18561)
-- Name: suppliers suppliers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pk PRIMARY KEY (id);


--
-- TOC entry 3509 (class 2606 OID 18733)
-- Name: login_session sv_login_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_session
    ADD CONSTRAINT sv_login_session_pkey PRIMARY KEY (id);


--
-- TOC entry 3453 (class 2606 OID 18563)
-- Name: uom uom_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);


--
-- TOC entry 3455 (class 2606 OID 18565)
-- Name: uom uom_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_un UNIQUE (remark);


--
-- TOC entry 3497 (class 2606 OID 18567)
-- Name: users_branch users_branch_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_branch
    ADD CONSTRAINT users_branch_pk PRIMARY KEY (user_id, branch_id);


--
-- TOC entry 3491 (class 2606 OID 18569)
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- TOC entry 3499 (class 2606 OID 18571)
-- Name: users_experience users_experience_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_experience
    ADD CONSTRAINT users_experience_pk PRIMARY KEY (id);


--
-- TOC entry 3501 (class 2606 OID 18573)
-- Name: users_mutation users_mutation_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_mutation
    ADD CONSTRAINT users_mutation_pk PRIMARY KEY (id);


--
-- TOC entry 3493 (class 2606 OID 18575)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3503 (class 2606 OID 18577)
-- Name: users_shift users_shift_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_shift
    ADD CONSTRAINT users_shift_pk PRIMARY KEY (branch_id, users_id, dated, shift_id);


--
-- TOC entry 3505 (class 2606 OID 18579)
-- Name: users_skills users_skills_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_pk PRIMARY KEY (users_id, modul, dated, status);


--
-- TOC entry 3495 (class 2606 OID 18581)
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- TOC entry 3507 (class 2606 OID 18583)
-- Name: voucher voucher_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voucher
    ADD CONSTRAINT voucher_pk PRIMARY KEY (voucher_code, branch_id);


--
-- TOC entry 3400 (class 1259 OID 18584)
-- Name: model_has_permissions_model_id_model_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);


--
-- TOC entry 3403 (class 1259 OID 18585)
-- Name: model_has_roles_model_id_model_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);


--
-- TOC entry 3412 (class 1259 OID 18586)
-- Name: password_resets_email_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);


--
-- TOC entry 3421 (class 1259 OID 18587)
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- TOC entry 3522 (class 2606 OID 18588)
-- Name: branch_room branch_room_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3523 (class 2606 OID 18593)
-- Name: invoice_detail invoice_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);


--
-- TOC entry 3524 (class 2606 OID 18598)
-- Name: invoice_master invoice_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3525 (class 2606 OID 18603)
-- Name: invoice_master invoice_master_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);


--
-- TOC entry 3526 (class 2606 OID 18608)
-- Name: model_has_permissions model_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 3527 (class 2606 OID 18613)
-- Name: model_has_roles model_has_roles_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 3528 (class 2606 OID 18618)
-- Name: order_detail order_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);


--
-- TOC entry 3529 (class 2606 OID 18623)
-- Name: order_master order_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3530 (class 2606 OID 18628)
-- Name: order_master order_master_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);


--
-- TOC entry 3531 (class 2606 OID 18633)
-- Name: posts posts_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3532 (class 2606 OID 18638)
-- Name: product_commision_by_year product_commision_by_year_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3533 (class 2606 OID 18643)
-- Name: product_commision_by_year product_commision_by_year_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3534 (class 2606 OID 18648)
-- Name: product_commision_by_year product_commision_by_year_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3535 (class 2606 OID 18653)
-- Name: product_distribution product_distribution_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3536 (class 2606 OID 18658)
-- Name: product_distribution product_distribution_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3537 (class 2606 OID 18663)
-- Name: product_uom product_uom_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3538 (class 2606 OID 18668)
-- Name: purchase_detail purchase_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);


--
-- TOC entry 3539 (class 2606 OID 18673)
-- Name: purchase_master purchase_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3540 (class 2606 OID 18678)
-- Name: receive_detail receive_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);


--
-- TOC entry 3541 (class 2606 OID 18683)
-- Name: receive_master receive_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3542 (class 2606 OID 18688)
-- Name: return_sell_detail return_sell_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);


--
-- TOC entry 3543 (class 2606 OID 18693)
-- Name: return_sell_master return_sell_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3544 (class 2606 OID 18698)
-- Name: return_sell_master return_sell_master_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);


--
-- TOC entry 3545 (class 2606 OID 18703)
-- Name: role_has_permissions role_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 3546 (class 2606 OID 18708)
-- Name: role_has_permissions role_has_permissions_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 3547 (class 2606 OID 18713)
-- Name: users_skills users_skills_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);


--
-- TOC entry 3784 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2023-01-10 23:20:19

--
-- PostgreSQL database dump complete
--

