--
-- PostgreSQL database dump
--

-- Dumped from database version 12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 15.0

-- Started on 2023-02-18 08:18:55

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
-- TOC entry 3811 (class 0 OID 0)
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
-- TOC entry 3813 (class 0 OID 0)
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
-- TOC entry 3814 (class 0 OID 0)
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
-- TOC entry 3815 (class 0 OID 0)
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
-- TOC entry 3816 (class 0 OID 0)
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
-- TOC entry 3817 (class 0 OID 0)
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
    contact_person_level character varying,
    visit_week character varying,
    ref_id character varying,
    external_code character varying,
    segment_id integer DEFAULT 1 NOT NULL
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
-- TOC entry 3818 (class 0 OID 0)
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
-- TOC entry 3819 (class 0 OID 0)
-- Dependencies: 302
-- Name: customers_registration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_registration_id_seq OWNED BY public.customers_registration.id;


--
-- TOC entry 309 (class 1259 OID 28173)
-- Name: customers_segment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers_segment (
    id integer NOT NULL,
    remark character varying,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.customers_segment OWNER TO postgres;

--
-- TOC entry 308 (class 1259 OID 28171)
-- Name: customers_segment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_segment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.customers_segment_id_seq OWNER TO postgres;

--
-- TOC entry 3820 (class 0 OID 0)
-- Dependencies: 308
-- Name: customers_segment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_segment_id_seq OWNED BY public.customers_segment.id;


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
-- TOC entry 3821 (class 0 OID 0)
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
-- TOC entry 3822 (class 0 OID 0)
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
-- TOC entry 3823 (class 0 OID 0)
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
-- TOC entry 3824 (class 0 OID 0)
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
-- TOC entry 3825 (class 0 OID 0)
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
    created_by integer,
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
    queue_no character varying,
    sales_id integer,
    delivery_date character varying
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
-- TOC entry 3826 (class 0 OID 0)
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
-- TOC entry 3827 (class 0 OID 0)
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
-- TOC entry 3828 (class 0 OID 0)
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
-- TOC entry 3829 (class 0 OID 0)
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
-- TOC entry 3830 (class 0 OID 0)
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
-- TOC entry 3831 (class 0 OID 0)
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
-- TOC entry 3832 (class 0 OID 0)
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
-- TOC entry 3833 (class 0 OID 0)
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
    photo character varying,
    external_code character varying
);


ALTER TABLE public.product_sku OWNER TO postgres;

--
-- TOC entry 3834 (class 0 OID 0)
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
-- TOC entry 3835 (class 0 OID 0)
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
-- TOC entry 3836 (class 0 OID 0)
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
    updated_at timestamp without time zone,
    abbr character varying
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
-- TOC entry 3837 (class 0 OID 0)
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
-- TOC entry 3838 (class 0 OID 0)
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
-- TOC entry 3839 (class 0 OID 0)
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
-- TOC entry 3840 (class 0 OID 0)
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
-- TOC entry 3841 (class 0 OID 0)
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
-- TOC entry 3842 (class 0 OID 0)
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
    external_code character varying
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
-- TOC entry 3843 (class 0 OID 0)
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
-- TOC entry 3844 (class 0 OID 0)
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
-- TOC entry 3845 (class 0 OID 0)
-- Dependencies: 298
-- Name: sales_trip_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;


--
-- TOC entry 307 (class 1259 OID 27180)
-- Name: sales_visit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales_visit (
    id bigint NOT NULL,
    dated date DEFAULT (now())::date NOT NULL,
    sales_id integer,
    customer_id integer,
    time_start timestamp without time zone,
    time_end timestamp without time zone,
    updated_at timestamp without time zone,
    created_at timestamp without time zone,
    created_by integer,
    updated_by integer,
    georeverse character varying,
    longitude character varying,
    latitude character varying,
    photo character varying,
    is_checkout integer
);


ALTER TABLE public.sales_visit OWNER TO postgres;

--
-- TOC entry 306 (class 1259 OID 27178)
-- Name: sales_visit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sales_visit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_visit_id_seq OWNER TO postgres;

--
-- TOC entry 3846 (class 0 OID 0)
-- Dependencies: 306
-- Name: sales_visit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;


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
-- TOC entry 3847 (class 0 OID 0)
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
-- TOC entry 3848 (class 0 OID 0)
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
-- TOC entry 3849 (class 0 OID 0)
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
-- TOC entry 3850 (class 0 OID 0)
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
-- TOC entry 3851 (class 0 OID 0)
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
    email character varying(255),
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
-- TOC entry 3852 (class 0 OID 0)
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
-- TOC entry 3853 (class 0 OID 0)
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
-- TOC entry 3854 (class 0 OID 0)
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
-- TOC entry 3855 (class 0 OID 0)
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
-- TOC entry 3856 (class 0 OID 0)
-- Dependencies: 291
-- Name: voucher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;


--
-- TOC entry 3184 (class 2604 OID 18423)
-- Name: branch id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);


--
-- TOC entry 3187 (class 2604 OID 18424)
-- Name: branch_room id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);


--
-- TOC entry 3373 (class 2604 OID 18723)
-- Name: branch_shift id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_shift ALTER COLUMN id SET DEFAULT nextval('public.branch_shift_id_seq'::regclass);


--
-- TOC entry 3391 (class 2604 OID 26922)
-- Name: calendar id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);


--
-- TOC entry 3189 (class 2604 OID 18425)
-- Name: company id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);


--
-- TOC entry 3191 (class 2604 OID 18426)
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- TOC entry 3387 (class 2604 OID 18777)
-- Name: customers_registration id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_registration ALTER COLUMN id SET DEFAULT nextval('public.customers_registration_id_seq'::regclass);


--
-- TOC entry 3394 (class 2604 OID 28176)
-- Name: customers_segment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_segment ALTER COLUMN id SET DEFAULT nextval('public.customers_segment_id_seq'::regclass);


--
-- TOC entry 3195 (class 2604 OID 18427)
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);


--
-- TOC entry 3198 (class 2604 OID 18428)
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- TOC entry 3207 (class 2604 OID 18429)
-- Name: invoice_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);


--
-- TOC entry 3219 (class 2604 OID 18430)
-- Name: job_title id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);


--
-- TOC entry 3375 (class 2604 OID 18730)
-- Name: login_session id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);


--
-- TOC entry 3222 (class 2604 OID 18431)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 3229 (class 2604 OID 18432)
-- Name: order_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master ALTER COLUMN id SET DEFAULT nextval('public.order_master_id_seq'::regclass);


--
-- TOC entry 3241 (class 2604 OID 18433)
-- Name: period_price_sell id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.period_price_sell ALTER COLUMN id SET DEFAULT nextval('public.period_price_sell_id_seq'::regclass);


--
-- TOC entry 3250 (class 2604 OID 18434)
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- TOC entry 3251 (class 2604 OID 18435)
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- TOC entry 3254 (class 2604 OID 18436)
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- TOC entry 3255 (class 2604 OID 18437)
-- Name: price_adjustment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_adjustment ALTER COLUMN id SET DEFAULT nextval('public.price_adjustment_id_seq'::regclass);


--
-- TOC entry 3258 (class 2604 OID 18438)
-- Name: product_brand id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_brand ALTER COLUMN id SET DEFAULT nextval('public.product_brand_id_seq'::regclass);


--
-- TOC entry 3261 (class 2604 OID 18439)
-- Name: product_category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);


--
-- TOC entry 3271 (class 2604 OID 18440)
-- Name: product_sku id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku ALTER COLUMN id SET DEFAULT nextval('public.product_sku_id_seq'::regclass);


--
-- TOC entry 3277 (class 2604 OID 18441)
-- Name: product_stock_detail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock_detail ALTER COLUMN id SET DEFAULT nextval('public.product_stock_detail_id_seq'::regclass);


--
-- TOC entry 3281 (class 2604 OID 18442)
-- Name: product_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_type ALTER COLUMN id SET DEFAULT nextval('public.product_type_id_seq'::regclass);


--
-- TOC entry 3297 (class 2604 OID 18443)
-- Name: purchase_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master ALTER COLUMN id SET DEFAULT nextval('public.purchase_master_id_seq'::regclass);


--
-- TOC entry 3316 (class 2604 OID 18444)
-- Name: receive_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);


--
-- TOC entry 3333 (class 2604 OID 18445)
-- Name: return_sell_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_master ALTER COLUMN id SET DEFAULT nextval('public.return_sell_master_id_seq'::regclass);


--
-- TOC entry 3345 (class 2604 OID 18446)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 3377 (class 2604 OID 18739)
-- Name: sales id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);


--
-- TOC entry 3379 (class 2604 OID 18753)
-- Name: sales_trip id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_trip ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_id_seq'::regclass);


--
-- TOC entry 3385 (class 2604 OID 18765)
-- Name: sales_trip_detail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);


--
-- TOC entry 3392 (class 2604 OID 27183)
-- Name: sales_visit id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_visit ALTER COLUMN id SET DEFAULT nextval('public.sales_visit_id_seq'::regclass);


--
-- TOC entry 3346 (class 2604 OID 18447)
-- Name: setting_document_counter id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.setting_document_counter ALTER COLUMN id SET DEFAULT nextval('public.setting_document_counter_id_seq'::regclass);


--
-- TOC entry 3350 (class 2604 OID 18448)
-- Name: shift id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);


--
-- TOC entry 3355 (class 2604 OID 18449)
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- TOC entry 3284 (class 2604 OID 18450)
-- Name: uom id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);


--
-- TOC entry 3357 (class 2604 OID 18451)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3361 (class 2604 OID 18452)
-- Name: users_experience id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_experience ALTER COLUMN id SET DEFAULT nextval('public.users_experience_id_seq'::regclass);


--
-- TOC entry 3363 (class 2604 OID 18453)
-- Name: users_mutation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_mutation ALTER COLUMN id SET DEFAULT nextval('public.users_mutation_id_seq'::regclass);


--
-- TOC entry 3366 (class 2604 OID 18454)
-- Name: users_shift id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_shift ALTER COLUMN id SET DEFAULT nextval('public.users_shift_id_seq'::regclass);


--
-- TOC entry 3369 (class 2604 OID 18455)
-- Name: voucher id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voucher ALTER COLUMN id SET DEFAULT nextval('public.voucher_id_seq'::regclass);


--
-- TOC entry 3698 (class 0 OID 17914)
-- Dependencies: 202
-- Data for Name: branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.branch VALUES (1, 'HEAD QUARTER', 'Jalan Jakarta no 3', 'Jakarta', 'HQ00', '2022-06-01 19:46:05.452925', NULL, 1);
INSERT INTO public.branch VALUES (14, 'KAKIKU WAY HALIM', 'JL. SULTAN AGUNG NO. 19, RUKO S DAN T, WAY HALIM PERMAI', 'BANDAR LAMPUNG', 'KKK WAY HALIM', '2023-02-04 10:38:56', '2023-02-04 10:38:56', 1);


--
-- TOC entry 3700 (class 0 OID 17924)
-- Dependencies: 204
-- Data for Name: branch_room; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.branch_room VALUES (14, 14, '1 UMUM 1', '2023-02-06 14:18:05', '2023-02-06 14:18:05');
INSERT INTO public.branch_room VALUES (15, 14, '1 UMUM 2', '2023-02-06 14:21:06', '2023-02-06 14:21:06');
INSERT INTO public.branch_room VALUES (16, 14, '1 UMUM 3', '2023-02-06 14:21:29', '2023-02-06 14:21:29');
INSERT INTO public.branch_room VALUES (17, 14, '1 REFLEXY 1', '2023-02-06 14:22:43', '2023-02-06 14:22:43');
INSERT INTO public.branch_room VALUES (18, 14, '1 REFLEXY 2', '2023-02-06 14:23:09', '2023-02-06 14:23:09');
INSERT INTO public.branch_room VALUES (19, 14, '1 REFLEXY 3', '2023-02-06 14:23:30', '2023-02-06 14:23:30');
INSERT INTO public.branch_room VALUES (20, 14, '1 BALE 1', '2023-02-06 14:23:51', '2023-02-06 14:23:51');
INSERT INTO public.branch_room VALUES (21, 14, '1 BALE 2', '2023-02-06 14:24:08', '2023-02-06 14:24:08');
INSERT INTO public.branch_room VALUES (22, 14, '1 BALE 3', '2023-02-06 14:24:28', '2023-02-06 14:24:28');
INSERT INTO public.branch_room VALUES (23, 14, '1 BALE 4', '2023-02-06 14:24:46', '2023-02-06 14:24:46');
INSERT INTO public.branch_room VALUES (24, 14, '1 VIP1 1', '2023-02-06 14:29:38', '2023-02-06 14:29:38');
INSERT INTO public.branch_room VALUES (25, 14, '1 VIP1 2', '2023-02-06 14:30:03', '2023-02-06 14:30:03');
INSERT INTO public.branch_room VALUES (26, 14, '2 COWOK 1', '2023-02-06 14:30:36', '2023-02-06 14:30:36');
INSERT INTO public.branch_room VALUES (27, 14, '2 COWOK 2', '2023-02-06 14:30:47', '2023-02-06 14:30:47');
INSERT INTO public.branch_room VALUES (28, 14, '2 COWOK 3', '2023-02-06 14:30:55', '2023-02-06 14:30:55');
INSERT INTO public.branch_room VALUES (29, 14, '2 COWOK 4', '2023-02-06 14:31:05', '2023-02-06 14:31:05');
INSERT INTO public.branch_room VALUES (30, 14, '2 COWOK 5', '2023-02-06 14:31:15', '2023-02-06 14:31:15');
INSERT INTO public.branch_room VALUES (31, 14, '2 COWOK 6', '2023-02-06 14:31:25', '2023-02-06 14:31:25');
INSERT INTO public.branch_room VALUES (32, 14, '2 COWOK 7', '2023-02-06 14:32:19', '2023-02-06 14:32:19');
INSERT INTO public.branch_room VALUES (33, 14, '2 COWOK 8', '2023-02-06 14:33:26', '2023-02-06 14:33:26');
INSERT INTO public.branch_room VALUES (34, 14, '2 CEWEK 1', '2023-02-06 14:33:54', '2023-02-06 14:33:54');
INSERT INTO public.branch_room VALUES (35, 14, '2 CEWEK 2', '2023-02-06 14:34:04', '2023-02-06 14:34:04');
INSERT INTO public.branch_room VALUES (36, 14, '2 CEWEK 3', '2023-02-06 14:34:14', '2023-02-06 14:34:14');
INSERT INTO public.branch_room VALUES (37, 14, '2 CEWEK 4', '2023-02-06 14:34:46', '2023-02-06 14:34:46');
INSERT INTO public.branch_room VALUES (38, 14, '2 VIP2 1', '2023-02-06 14:36:24', '2023-02-06 14:36:24');
INSERT INTO public.branch_room VALUES (39, 14, '2 VIP2 2', '2023-02-06 14:36:33', '2023-02-06 14:36:33');
INSERT INTO public.branch_room VALUES (40, 14, '2 VIP3 1', '2023-02-06 14:36:47', '2023-02-06 14:36:47');
INSERT INTO public.branch_room VALUES (41, 14, '2 VIP3 2', '2023-02-06 14:36:58', '2023-02-06 14:36:58');


--
-- TOC entry 3789 (class 0 OID 18720)
-- Dependencies: 293
-- Data for Name: branch_shift; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.branch_shift VALUES (3, 14, 11, NULL, '2023-02-15 17:16:29', NULL, '2023-02-15 17:16:29');
INSERT INTO public.branch_shift VALUES (4, 14, 12, NULL, '2023-02-15 17:16:35', NULL, '2023-02-15 17:16:35');


--
-- TOC entry 3801 (class 0 OID 26919)
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
-- TOC entry 3702 (class 0 OID 17933)
-- Dependencies: 206
-- Data for Name: company; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.company VALUES (1, 'Kakiku', 'Gading Serpong I', 'Tangerang', 'admin@kakiku.com', '031-3322224', '6d4c83f6b695389b860d79e975e13751.png', '2022-09-03 00:59:33', '2022-08-30 22:06:56.025994');


--
-- TOC entry 3704 (class 0 OID 17942)
-- Dependencies: 208
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.customers VALUES (35, 'IBU RIKA', 'BDL', '08', 1, '1', 14, '2023-02-15 11:02:42', '2023-02-15 11:02:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (38, 'BP WAHYU', 'WAYHALIM', '081272045555', 1, '1', 14, '2023-02-15 11:59:54', '2023-02-15 11:59:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (39, 'IBU OLIVIA', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 12:27:54', '2023-02-15 12:27:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (40, 'IBU LIDYA', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 12:30:59', '2023-02-15 12:30:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (41, 'IBU SARI', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 14:00:32', '2023-02-15 14:00:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (42, 'IBU MERI', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 14:08:29', '2023-02-15 14:08:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (43, 'IBU LIA', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 14:11:35', '2023-02-15 14:11:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (44, 'BP AJI', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 14:15:54', '2023-02-15 14:15:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (45, 'BP ADI', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 14:57:06', '2023-02-15 14:57:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (46, 'BP ANDI', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 14:59:06', '2023-02-15 14:59:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (47, 'BP YOGA', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 15:00:51', '2023-02-15 15:00:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (48, 'BP RIDWAN', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 15:03:16', '2023-02-15 15:03:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (49, 'ANITA', 'BDL', '0', 1, '1', 14, '2023-02-15 15:30:46', '2023-02-15 15:30:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (50, 'TERAPIS AYU', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 15:57:46', '2023-02-15 15:57:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (51, 'IBU TETTY', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 17:25:29', '2023-02-15 17:25:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (52, 'BP YUDA', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 17:34:26', '2023-02-15 17:34:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (53, 'IBU OKTA', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 17:58:32', '2023-02-15 17:58:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (54, 'IBU JULITA', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 18:45:29', '2023-02-15 18:45:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (55, 'BP HENDRA', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 19:17:35', '2023-02-15 19:17:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (56, 'BP ALAY', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 19:22:17', '2023-02-15 19:22:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (57, 'BP IRFAN', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 19:26:14', '2023-02-15 19:26:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (58, 'BP ZAKY', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 19:27:36', '2023-02-15 19:27:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (59, 'BP ARAYA', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 19:29:57', '2023-02-15 19:29:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (60, 'IBU ARAYA', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 19:33:06', '2023-02-15 19:33:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (61, 'DEMI', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 19:34:27', '2023-02-15 19:34:27', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (62, 'IBU DESI', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 19:52:20', '2023-02-15 19:52:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (63, 'JUNI', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 20:18:35', '2023-02-15 20:18:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (64, 'BP BAGUS', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 20:49:40', '2023-02-15 20:49:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (65, 'BP IRFAN', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 20:54:13', '2023-02-15 20:54:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (66, 'BP ADIT', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 20:56:00', '2023-02-15 20:56:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (67, 'BP BILAL', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 20:57:15', '2023-02-15 20:57:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (68, 'BP JEFRI', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 21:20:26', '2023-02-15 21:20:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (69, 'BP AHMAD', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 22:34:36', '2023-02-15 22:34:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (70, 'IBU AHMAD', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 22:36:54', '2023-02-15 22:36:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (71, 'BP AHMAD', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 22:39:06', '2023-02-15 22:39:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (72, 'BP NIKO', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 22:40:28', '2023-02-15 22:40:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);
INSERT INTO public.customers VALUES (73, 'MELATI', 'WAYHALIM', '08', 1, '1', 14, '2023-02-15 22:43:00', '2023-02-15 22:43:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1);


--
-- TOC entry 3799 (class 0 OID 18774)
-- Dependencies: 303
-- Data for Name: customers_registration; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3805 (class 0 OID 28173)
-- Dependencies: 309
-- Data for Name: customers_segment; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3706 (class 0 OID 17952)
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
-- TOC entry 3708 (class 0 OID 17962)
-- Dependencies: 212
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3710 (class 0 OID 17971)
-- Dependencies: 214
-- Data for Name: invoice_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000003', 301, 1, 300000, 300000, 0, 0, 76, NULL, '2023-02-16 16:00:41', '2023-02-16 16:00:41', '150 MENIT', 'EXECUTIVE BALI BODY SCRUB GREENTEA', 0, 0, 'AYU', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000005', 284, 1, 150000, 150000, 0, 0, 80, NULL, '2023-02-16 16:01:21', '2023-02-16 16:01:21', '90 MENIT', 'TUINA', 0, 0, 'DESI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000005', 251, 1, 20000, 20000, 0, 1, 80, 80, '2023-02-16 16:01:21', '2023-02-16 16:01:21', 'SACHET', 'BUNGAN JEPUN - CREAM HANGAT SACHET', 0, 0, 'DESI', 'DESI', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000007', 289, 1, 150000, 150000, 0, 0, 65, NULL, '2023-02-16 16:02:16', '2023-02-16 16:02:16', '90 MENIT', 'FULL BODY THERAPY', 0, 0, 'MARSELI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000007', 251, 1, 20000, 20000, 0, 1, 65, 65, '2023-02-16 16:02:16', '2023-02-16 16:02:16', 'SACHET', 'BUNGAN JEPUN - CREAM HANGAT SACHET', 0, 0, 'MARSELI', 'MARSELI', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000009', 289, 1, 150000, 150000, 0, 0, 68, NULL, '2023-02-16 16:02:52', '2023-02-16 16:02:52', '90 MENIT', 'FULL BODY THERAPY', 0, 0, 'NOVI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000011', 289, 1, 150000, 150000, 0, 0, 73, NULL, '2023-02-16 16:04:15', '2023-02-16 16:04:15', '90 MENIT', 'FULL BODY THERAPY', 0, 0, 'DEMI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000011', 275, 1, 5000, 5000, 0, 1, 73, NULL, '2023-02-16 16:04:15', '2023-02-16 16:04:15', 'BOTOL', 'LE MINERAL', 0, 0, 'DEMI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000012', 289, 1, 150000, 150000, 0, 0, 67, NULL, '2023-02-16 16:04:50', '2023-02-16 16:04:50', '90 MENIT', 'FULL BODY THERAPY', 0, 0, 'JUPANDI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000013', 289, 1, 150000, 150000, 0, 0, 79, NULL, '2023-02-16 16:15:30', '2023-02-16 16:15:30', '90 MENIT', 'FULL BODY THERAPY', 0, 0, 'RULI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000023', 289, 1, 150000, 150000, 0, 0, 79, NULL, '2023-02-15 19:21:16', '2023-02-15 19:21:16', '90 MENIT', 'FULL BODY THERAPY', 0, 0, 'RULI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000015', 93, 1, 60000, 60000, 0, 0, 76, NULL, '2023-02-15 15:49:25', '2023-02-15 15:49:25', 'TUBE', 'BALI ALUS - BODY WHITENING', 0, 0, 'AYU', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000017', 293, 1, 110000, 110000, 0, 0, 72, NULL, '2023-02-15 17:28:14', '2023-02-15 17:28:14', '60 MENIT', 'BACK DRY MASSAGE', 0, 0, 'SELA', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000017', 307, 1, 100000, 100000, 0, 1, 72, NULL, '2023-02-15 17:28:14', '2023-02-15 17:28:14', '60 MENIT', 'FOOT REFLEXOLOGY', 0, 0, 'SELA', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000014', 291, 1, 150000, 150000, 0, 0, 64, NULL, '2023-02-15 17:33:55', '2023-02-15 17:33:55', '90 MENIT', 'FULL BODY REFLEXOLOGY', 0, 0, 'TONO', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000023', 92, 1, 65000, 65000, 0, 1, 79, NULL, '2023-02-15 19:21:16', '2023-02-15 19:21:16', 'TUBE', 'BALI ALUS - LIGHTENING', 0, 0, 'RULI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000021', 289, 1, 150000, 150000, 0, 0, 66, NULL, '2023-02-15 17:59:59', '2023-02-15 17:59:59', '90 MENIT', 'FULL BODY THERAPY', 0, 0, 'TINI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000022', 284, 1, 150000, 150000, 0, 0, 69, NULL, '2023-02-15 18:48:19', '2023-02-15 18:48:19', '90 MENIT', 'TUINA', 0, 0, 'YANTI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000023', 274, 1, 5000, 5000, 0, 2, 79, NULL, '2023-02-15 19:21:16', '2023-02-15 19:21:16', 'BOTOL', 'TEH BANDULAN BOTOL', 0, 0, 'RULI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000024', 289, 1, 150000, 150000, 0, 0, 73, NULL, '2023-02-15 19:25:14', '2023-02-15 19:25:14', '90 MENIT', 'FULL BODY THERAPY', 0, 0, 'DEMI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000025', 288, 1, 150000, 150000, 0, 0, 78, NULL, '2023-02-15 19:27:11', '2023-02-15 19:27:11', '90 MENIT', 'DRY MASSAGE', 0, 0, 'JUNI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000026', 291, 1, 150000, 150000, 0, 0, 67, NULL, '2023-02-15 19:28:45', '2023-02-15 19:28:45', '90 MENIT', 'FULL BODY REFLEXOLOGY', 0, 0, 'JUPANDI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000027', 284, 1, 150000, 150000, 0, 0, 76, NULL, '2023-02-15 19:31:53', '2023-02-15 19:31:53', '90 MENIT', 'TUINA', 0, 0, 'AYU', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000027', 274, 1, 5000, 5000, 0, 1, 76, NULL, '2023-02-15 19:31:53', '2023-02-15 19:31:53', 'BOTOL', 'TEH BANDULAN BOTOL', 0, 0, 'AYU', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000028', 289, 1, 150000, 150000, 0, 0, 80, NULL, '2023-02-15 19:34:07', '2023-02-15 19:34:07', '90 MENIT', 'FULL BODY THERAPY', 0, 0, 'DESI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000029', 322, 1, 5000, 5000, 0, 0, 73, NULL, '2023-02-15 19:51:11', '2023-02-15 19:51:11', 'BOTOL', 'FLORIDINA', 0, 0, 'DEMI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000029', 274, 1, 5000, 5000, 0, 1, 73, NULL, '2023-02-15 19:51:11', '2023-02-15 19:51:11', 'BOTOL', 'TEH BANDULAN BOTOL', 0, 0, 'DEMI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000030', 284, 1, 150000, 150000, 0, 0, 71, NULL, '2023-02-15 19:53:38', '2023-02-15 19:53:38', '90 MENIT', 'TUINA', 0, 0, 'ERNI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000030', 251, 1, 20000, 20000, 0, 1, 71, NULL, '2023-02-15 19:53:38', '2023-02-15 19:53:38', 'SACHET', 'BUNGAN JEPUN - CREAM HANGAT SACHET', 0, 0, 'ERNI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000031', 276, 1, 5000, 5000, 0, 0, 78, NULL, '2023-02-15 20:19:36', '2023-02-15 20:19:36', 'BOTOL', 'GOLDA', 0, 0, 'JUNI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000032', 289, 1, 150000, 150000, 0, 0, 79, NULL, '2023-02-15 20:53:45', '2023-02-15 20:53:45', '90 MENIT', 'FULL BODY THERAPY', 0, 0, 'RULI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000032', 310, 1, 70000, 70000, 0, 1, 79, NULL, '2023-02-15 20:53:45', '2023-02-15 20:53:45', '30 MENIT', 'EXTRA TIME BODY COP', 0, 0, 'RULI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000032', 275, 1, 5000, 5000, 0, 2, 79, NULL, '2023-02-15 20:53:45', '2023-02-15 20:53:45', 'BOTOL', 'LE MINERAL', 0, 0, 'RULI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000033', 289, 1, 150000, 150000, 0, 0, 64, NULL, '2023-02-15 20:55:36', '2023-02-15 20:55:36', '90 MENIT', 'FULL BODY THERAPY', 0, 0, 'TONO', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000033', 275, 1, 5000, 5000, 0, 1, 64, NULL, '2023-02-15 20:55:36', '2023-02-15 20:55:36', 'BOTOL', 'LE MINERAL', 0, 0, 'TONO', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000034', 289, 1, 150000, 150000, 0, 0, 75, NULL, '2023-02-15 20:56:54', '2023-02-15 20:56:54', '90 MENIT', 'FULL BODY THERAPY', 0, 0, 'AHMAD', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000035', 284, 1, 150000, 150000, 0, 0, 73, NULL, '2023-02-15 20:58:24', '2023-02-15 20:58:24', '90 MENIT', 'TUINA', 0, 0, 'DEMI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000035', 251, 1, 20000, 20000, 0, 1, 73, NULL, '2023-02-15 20:58:25', '2023-02-15 20:58:25', 'SACHET', 'BUNGAN JEPUN - CREAM HANGAT SACHET', 0, 0, 'DEMI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000036', 291, 1, 150000, 150000, 0, 0, 78, NULL, '2023-02-15 21:21:24', '2023-02-15 21:21:24', '90 MENIT', 'FULL BODY REFLEXOLOGY', 0, 0, 'JUNI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000037', 284, 1, 150000, 150000, 0, 0, 67, NULL, '2023-02-15 22:36:28', '2023-02-15 22:36:28', '90 MENIT', 'TUINA', 0, 0, 'JUPANDI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000037', 251, 1, 20000, 20000, 0, 1, 67, NULL, '2023-02-15 22:36:28', '2023-02-15 22:36:28', 'SACHET', 'BUNGAN JEPUN - CREAM HANGAT SACHET', 0, 0, 'JUPANDI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000038', 284, 1, 150000, 150000, 0, 0, 65, NULL, '2023-02-15 22:38:07', '2023-02-15 22:38:07', '90 MENIT', 'TUINA', 0, 0, 'MARSELI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000038', 251, 1, 20000, 20000, 0, 1, 65, NULL, '2023-02-15 22:38:07', '2023-02-15 22:38:07', 'SACHET', 'BUNGAN JEPUN - CREAM HANGAT SACHET', 0, 0, 'MARSELI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000039', 284, 1, 150000, 150000, 0, 0, 64, NULL, '2023-02-15 22:40:05', '2023-02-15 22:40:05', '90 MENIT', 'TUINA', 0, 0, 'TONO', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000040', 284, 1, 150000, 150000, 0, 0, 79, NULL, '2023-02-15 22:41:26', '2023-02-15 22:41:26', '90 MENIT', 'TUINA', 0, 0, 'RULI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000041', 274, 1, 5000, 5000, 0, 0, 65, NULL, '2023-02-15 22:44:11', '2023-02-15 22:44:11', 'BOTOL', 'TEH BANDULAN BOTOL', 0, 0, 'MARSELI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000018', 251, 1, 20000, 20000, 0, 0, 72, 72, '2023-02-16 09:31:16', '2023-02-16 09:31:16', 'SACHET', 'BUNGAN JEPUN - CREAM HANGAT SACHET', 0, 0, 'SELA', 'SELA', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000020', 282, 1, 175000, 175000, 0, 0, 75, 75, '2023-02-16 09:31:52', '2023-02-16 09:31:52', '120 MENIT', 'FULL BODY HERBAL COMPRESS', 0, 0, 'AHMAD', 'AHMAD', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000020', 251, 1, 20000, 20000, 0, 1, 75, NULL, '2023-02-16 09:31:52', '2023-02-16 09:31:52', 'SACHET', 'BUNGAN JEPUN - CREAM HANGAT SACHET', 0, 0, 'AHMAD', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000004', 284, 1, 150000, 150000, 0, 0, 81, NULL, '2023-02-16 16:01:06', '2023-02-16 16:01:06', '90 MENIT', 'TUINA', 0, 0, 'RINA', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000004', 251, 1, 20000, 20000, 0, 1, 81, 81, '2023-02-16 16:01:06', '2023-02-16 16:01:06', 'SACHET', 'BUNGAN JEPUN - CREAM HANGAT SACHET', 0, 0, 'RINA', 'RINA', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000006', 289, 1, 150000, 150000, 0, 0, 71, NULL, '2023-02-16 16:01:55', '2023-02-16 16:01:55', '90 MENIT', 'FULL BODY THERAPY', 0, 0, 'ERNI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000006', 251, 1, 20000, 20000, 0, 1, 71, 71, '2023-02-16 16:01:55', '2023-02-16 16:01:55', 'SACHET', 'BUNGAN JEPUN - CREAM HANGAT SACHET', 0, 0, 'ERNI', 'ERNI', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000008', 289, 1, 150000, 150000, 0, 0, 70, NULL, '2023-02-16 16:02:35', '2023-02-16 16:02:35', '90 MENIT', 'FULL BODY THERAPY', 0, 0, 'NISA', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000008', 251, 1, 20000, 20000, 0, 1, 70, 70, '2023-02-16 16:02:35', '2023-02-16 16:02:35', 'SACHET', 'BUNGAN JEPUN - CREAM HANGAT SACHET', 0, 0, 'NISA', 'NISA', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000010', 294, 1, 110000, 110000, 0, 0, 75, NULL, '2023-02-16 16:04:42', '2023-02-16 16:04:42', '60 MENIT', 'BACK MASSAGE', 0, 0, 'AHMAD', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000010', 285, 1, 110000, 110000, 0, 1, 74, NULL, '2023-02-16 16:04:43', '2023-02-16 16:04:43', '60 MENIT', 'FACE REFRESHING BIOKOS', 0, 0, 'POVI', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000010', 274, 1, 5000, 5000, 0, 2, 75, NULL, '2023-02-16 16:04:43', '2023-02-16 16:04:43', 'BOTOL', 'TEH BANDULAN BOTOL', 0, 0, 'AHMAD', '', 0);
INSERT INTO public.invoice_detail VALUES ('INV-014-2023-00000016', 274, 2, 5000, 10000, 0, 0, 76, NULL, '2023-02-16 16:08:13', '2023-02-16 16:08:13', 'BOTOL', 'TEH BANDULAN BOTOL', 0, 0, 'AYU', '', 0);


--
-- TOC entry 3711 (class 0 OID 17984)
-- Dependencies: 215
-- Data for Name: invoice_master; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.invoice_master VALUES (149, 'INV-014-2023-00000022', '2023-02-15', 54, 150000, 0, 150000, 0, NULL, 'BCA - Debit', 150000, NULL, '2023-02-15 16:40:00', 15, NULL, NULL, NULL, '2023-02-15 18:48:18', 84, '2023-02-15 18:48:18', 0, 0, 'IBU JULITA', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (150, 'INV-014-2023-00000023', '2023-02-15', 55, 220000, 0, 220000, 0, NULL, 'BCA - Debit', 220000, NULL, '2023-02-15 16:45:00', 26, NULL, NULL, NULL, '2023-02-15 19:21:16', 84, '2023-02-15 19:21:16', 0, 0, 'BP HENDRA', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (142, 'INV-014-2023-00000015', '2023-02-15', 35, 60000, 0, 60000, 0, NULL, 'Cash', 60000, NULL, '2023-02-15 09:30:00', 38, NULL, NULL, NULL, '2023-02-15 15:49:25', 63, '2023-02-15 15:49:25', 0, 0, 'IBU RIKA', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (151, 'INV-014-2023-00000024', '2023-02-15', 56, 150000, 0, 150000, 0, NULL, 'Cash', 150000, NULL, '2023-02-15 17:15:00', 27, NULL, NULL, NULL, '2023-02-15 19:25:14', 84, '2023-02-15 19:25:14', 0, 0, 'BP ALAY', 0, 'Berdua');
INSERT INTO public.invoice_master VALUES (152, 'INV-014-2023-00000025', '2023-02-15', 57, 150000, 0, 150000, 0, NULL, 'Cash', 150000, NULL, '2023-02-15 17:15:00', 28, NULL, NULL, NULL, '2023-02-15 19:27:11', 84, '2023-02-15 19:27:11', 0, 0, 'BP IRFAN', 0, 'Berdua');
INSERT INTO public.invoice_master VALUES (153, 'INV-014-2023-00000026', '2023-02-15', 58, 150000, 0, 150000, 0, NULL, 'QRIS', 150000, NULL, '2023-02-15 17:25:00', 29, NULL, NULL, NULL, '2023-02-15 19:28:45', 84, '2023-02-15 19:28:45', 0, 0, 'BP ZAKY', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (154, 'INV-014-2023-00000027', '2023-02-15', 59, 155000, 0, 155000, 0, NULL, 'Cash', 155000, NULL, '2023-02-15 17:55:00', 24, NULL, NULL, NULL, '2023-02-15 19:31:53', 84, '2023-02-15 19:31:53', 0, 0, 'BP ARAYA', 0, 'Berdua');
INSERT INTO public.invoice_master VALUES (144, 'INV-014-2023-00000017', '2023-02-15', 51, 210000, 0, 210000, 0, NULL, 'BCA - Debit', 210000, NULL, '2023-02-15 15:20:00', 16, NULL, NULL, NULL, '2023-02-15 17:28:14', 63, '2023-02-15 17:28:14', 0, 0, 'IBU TETTY', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (155, 'INV-014-2023-00000028', '2023-02-15', 60, 150000, 0, 150000, 0, NULL, 'Cash', 150000, NULL, '2023-02-15 17:55:00', 25, NULL, NULL, NULL, '2023-02-15 19:34:07', 84, '2023-02-15 19:34:07', 0, 0, 'IBU ARAYA', 0, 'Berdua');
INSERT INTO public.invoice_master VALUES (156, 'INV-014-2023-00000029', '2023-02-15', 61, 10000, 0, 10000, 0, NULL, 'Cash', 10000, NULL, '2023-02-15 18:15:00', 29, NULL, NULL, NULL, '2023-02-15 19:51:11', 84, '2023-02-15 19:51:11', 0, 0, 'DEMI', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (157, 'INV-014-2023-00000030', '2023-02-15', 62, 170000, 0, 170000, 0, NULL, 'Cash', 170000, NULL, '2023-02-15 18:00:00', 16, NULL, NULL, NULL, '2023-02-15 19:53:38', 84, '2023-02-15 19:53:38', 0, 0, 'IBU DESI', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (158, 'INV-014-2023-00000031', '2023-02-15', 63, 5000, 0, 5000, 0, NULL, 'Cash', 5000, NULL, '2023-02-15 20:00:00', 26, NULL, NULL, NULL, '2023-02-15 20:19:36', 84, '2023-02-15 20:19:36', 0, 0, 'JUNI', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (141, 'INV-014-2023-00000014', '2023-02-15', 48, 150000, 0, 150000, 0, NULL, 'Cash', 150000, NULL, '2023-02-15 14:00:00', 30, NULL, 63, NULL, '2023-02-17 09:16:17', 63, '2023-02-15 15:05:13', 0, 0, 'BP RIDWAN', 1, 'Rombongan');
INSERT INTO public.invoice_master VALUES (159, 'INV-014-2023-00000032', '2023-02-15', 64, 225000, 0, 225000, 0, NULL, 'Cash', 225000, NULL, '2023-02-15 18:40:00', 30, NULL, NULL, NULL, '2023-02-15 20:53:45', 84, '2023-02-15 20:53:45', 0, 0, 'BP BAGUS', 0, 'Berdua');
INSERT INTO public.invoice_master VALUES (148, 'INV-014-2023-00000021', '2023-02-15', 53, 150000, 0, 150000, 0, NULL, 'QRIS', 150000, NULL, '2023-02-15 15:45:00', 14, NULL, NULL, NULL, '2023-02-15 17:59:59', 63, '2023-02-15 17:59:59', 0, 0, 'IBU OKTA', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (160, 'INV-014-2023-00000033', '2023-02-15', 65, 155000, 0, 155000, 0, NULL, 'Cash', 155000, NULL, '2023-02-15 18:40:00', 31, NULL, NULL, NULL, '2023-02-15 20:55:36', 84, '2023-02-15 20:55:36', 0, 0, 'BP IRFAN', 0, 'Berdua');
INSERT INTO public.invoice_master VALUES (161, 'INV-014-2023-00000034', '2023-02-15', 66, 150000, 0, 150000, 0, NULL, 'QRIS', 150000, NULL, '2023-02-15 19:05:00', 28, NULL, NULL, NULL, '2023-02-15 20:56:54', 84, '2023-02-15 20:56:54', 0, 0, 'BP ADIT', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (162, 'INV-014-2023-00000035', '2023-02-15', 67, 170000, 0, 170000, 0, NULL, 'QRIS', 170000, NULL, '2023-02-15 19:15:00', 29, NULL, NULL, NULL, '2023-02-15 20:58:24', 84, '2023-02-15 20:58:24', 0, 0, 'BP BILAL', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (163, 'INV-014-2023-00000036', '2023-02-15', 68, 150000, 0, 150000, 0, NULL, 'Cash', 150000, NULL, '2023-02-15 19:40:00', 27, NULL, NULL, NULL, '2023-02-15 21:21:24', 84, '2023-02-15 21:21:24', 0, 0, 'BP JEFRI', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (164, 'INV-014-2023-00000037', '2023-02-15', 69, 170000, 0, 170000, 0, NULL, 'BCA - Debit', 170000, NULL, '2023-02-15 20:10:00', 32, NULL, NULL, NULL, '2023-02-15 22:36:28', 84, '2023-02-15 22:36:28', 0, 0, 'BP AHMAD', 0, 'Keluarga');
INSERT INTO public.invoice_master VALUES (165, 'INV-014-2023-00000038', '2023-02-15', 70, 170000, 0, 170000, 0, NULL, 'BCA - Debit', 170000, NULL, '2023-02-15 20:10:00', 14, NULL, NULL, NULL, '2023-02-15 22:38:07', 84, '2023-02-15 22:38:07', 0, 0, 'IBU AHMAD', 0, 'Keluarga');
INSERT INTO public.invoice_master VALUES (166, 'INV-014-2023-00000039', '2023-02-15', 71, 150000, 0, 150000, 0, NULL, 'BCA - Debit', 150000, NULL, '2023-02-15 20:25:00', 31, NULL, NULL, NULL, '2023-02-15 22:40:05', 84, '2023-02-15 22:40:05', 0, 0, 'BP AHMAD', 0, 'Keluarga');
INSERT INTO public.invoice_master VALUES (167, 'INV-014-2023-00000040', '2023-02-15', 72, 150000, 0, 150000, 0, NULL, 'Cash', 150000, NULL, '2023-02-15 20:45:00', 23, NULL, NULL, NULL, '2023-02-15 22:41:25', 84, '2023-02-15 22:41:25', 0, 0, 'BP NIKO', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (168, 'INV-014-2023-00000041', '2023-02-15', 73, 5000, 0, 5000, 0, NULL, 'Cash', 5000, NULL, '2023-02-15 21:00:00', 14, NULL, NULL, NULL, '2023-02-15 22:44:11', 84, '2023-02-15 22:44:11', 0, 0, 'MELATI', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (131, 'INV-014-2023-00000004', '2023-02-15', 38, 170000, 0, 170000, 0, NULL, 'QRIS', 170000, NULL, '2023-02-16 14:15:00', 28, NULL, 83, NULL, '2023-02-16 16:01:06', 63, '2023-02-15 12:01:55', 0, 0, 'BP WAHYU', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (145, 'INV-014-2023-00000018', '2023-02-15', 51, 20000, 0, 20000, 0, NULL, 'Cash', 20000, NULL, '2023-02-16 09:45:00', 16, NULL, 1, NULL, '2023-02-16 09:31:16', 63, '2023-02-15 17:29:15', 0, 0, 'IBU TETTY', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (139, 'INV-014-2023-00000012', '2023-02-15', 46, 150000, 0, 150000, 0, NULL, 'Cash', 150000, NULL, '2023-02-16 14:30:00', 28, NULL, 83, NULL, '2023-02-16 16:04:50', 63, '2023-02-15 15:00:18', 0, 0, 'BP ANDI', 0, 'Rombongan');
INSERT INTO public.invoice_master VALUES (138, 'INV-014-2023-00000011', '2023-02-15', 45, 155000, 0, 155000, 0, NULL, 'Cash', 155000, NULL, '2023-02-16 14:30:00', 27, NULL, 83, NULL, '2023-02-16 16:04:15', 63, '2023-02-15 14:58:38', 0, 0, 'BP ADI', 0, 'Rombongan');
INSERT INTO public.invoice_master VALUES (143, 'INV-014-2023-00000016', '2023-02-15', 50, 10000, 0, 10000, 0, NULL, 'Cash', 10000, NULL, '2023-02-16 14:30:00', 14, NULL, 83, NULL, '2023-02-16 16:08:13', 63, '2023-02-15 16:05:36', 0, 0, 'TERAPIS AYU', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (140, 'INV-014-2023-00000013', '2023-02-15', 47, 150000, 0, 150000, 0, NULL, 'Cash', 150000, NULL, '2023-02-16 14:30:00', 29, NULL, 83, NULL, '2023-02-16 16:15:30', 63, '2023-02-15 15:02:47', 0, 0, 'BP YOGA', 0, 'Rombongan');
INSERT INTO public.invoice_master VALUES (134, 'INV-014-2023-00000007', '2023-02-15', 41, 170000, 0, 170000, 0, NULL, 'Cash', 170000, NULL, '2023-02-16 14:30:00', 16, NULL, 83, NULL, '2023-02-16 16:02:16', 63, '2023-02-15 14:03:31', 0, 0, 'IBU SARI', 0, 'Berdua');
INSERT INTO public.invoice_master VALUES (135, 'INV-014-2023-00000008', '2023-02-15', 42, 170000, 0, 170000, 0, NULL, 'Cash', 170000, NULL, '2023-02-16 14:30:00', 15, NULL, 83, NULL, '2023-02-16 16:02:34', 63, '2023-02-15 14:10:17', 0, 0, 'IBU MERI', 0, 'Berdua');
INSERT INTO public.invoice_master VALUES (136, 'INV-014-2023-00000009', '2023-02-15', 43, 150000, 0, 150000, 0, NULL, 'BCA - Debit', 150000, NULL, '2023-02-16 14:30:00', 14, NULL, 83, NULL, '2023-02-16 16:02:52', 63, '2023-02-15 14:15:13', 0, 0, 'IBU LIA', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (137, 'INV-014-2023-00000010', '2023-02-15', 44, 225000, 0, 225000, 0, NULL, 'BCA - Debit', 225000, NULL, '2023-02-16 14:30:00', 26, NULL, 83, NULL, '2023-02-16 16:04:42', 63, '2023-02-15 14:35:32', 0, 0, 'BP AJI', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (147, 'INV-014-2023-00000020', '2023-02-15', 52, 195000, 0, 195000, 0, NULL, 'QRIS', 195000, NULL, '2023-02-16 09:45:00', 31, NULL, 1, NULL, '2023-02-16 09:31:52', 63, '2023-02-15 17:58:04', 0, 0, 'BP YUDA', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (130, 'INV-014-2023-00000003', '2023-02-15', 35, 300000, 0, 300000, 0, NULL, 'QRIS', 300000, NULL, '2023-02-16 14:15:00', 38, NULL, 83, NULL, '2023-02-16 16:00:40', 63, '2023-02-15 11:55:34', 0, 0, 'IBU RIKA', 0, 'Sendiri');
INSERT INTO public.invoice_master VALUES (132, 'INV-014-2023-00000005', '2023-02-15', 39, 170000, 0, 170000, 0, NULL, 'Cash', 170000, NULL, '2023-02-16 14:15:00', 24, NULL, 83, NULL, '2023-02-16 16:01:21', 63, '2023-02-15 12:30:17', 0, 0, 'IBU OLIVIA', 0, 'Berdua');
INSERT INTO public.invoice_master VALUES (133, 'INV-014-2023-00000006', '2023-02-15', 40, 170000, 0, 170000, 0, NULL, 'Cash', 170000, NULL, '2023-02-16 14:30:00', 25, NULL, 83, NULL, '2023-02-16 16:01:55', 63, '2023-02-15 12:32:27', 0, 0, 'IBU LIDYA', 0, 'Berdua');


--
-- TOC entry 3713 (class 0 OID 18003)
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
-- TOC entry 3791 (class 0 OID 18727)
-- Dependencies: 295
-- Data for Name: login_session; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3715 (class 0 OID 18013)
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
-- TOC entry 3717 (class 0 OID 18018)
-- Dependencies: 221
-- Data for Name: model_has_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3718 (class 0 OID 18021)
-- Dependencies: 222
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
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 14);
INSERT INTO public.model_has_roles VALUES (3, 'App\Models\User', 55);
INSERT INTO public.model_has_roles VALUES (3, 'App\Models\User', 57);
INSERT INTO public.model_has_roles VALUES (3, 'App\Models\User', 63);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 64);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 65);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 67);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 68);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 69);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 70);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 71);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 72);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 73);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 74);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 75);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 76);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 77);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 78);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 79);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 80);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 81);
INSERT INTO public.model_has_roles VALUES (3, 'App\Models\User', 82);
INSERT INTO public.model_has_roles VALUES (3, 'App\Models\User', 83);
INSERT INTO public.model_has_roles VALUES (3, 'App\Models\User', 84);
INSERT INTO public.model_has_roles VALUES (5, 'App\Models\User', 66);


--
-- TOC entry 3719 (class 0 OID 18024)
-- Dependencies: 223
-- Data for Name: order_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3720 (class 0 OID 18036)
-- Dependencies: 224
-- Data for Name: order_master; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3722 (class 0 OID 18055)
-- Dependencies: 226
-- Data for Name: password_resets; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3723 (class 0 OID 18061)
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
-- TOC entry 3724 (class 0 OID 18067)
-- Dependencies: 228
-- Data for Name: period_price_sell; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.period_price_sell VALUES (886, 202302, 1, 149000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (887, 202302, 2, 19000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (888, 202302, 3, 249000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (889, 202302, 4, 174000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (890, 202302, 4, 174000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (891, 202302, 5, 174000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (892, 202302, 5, 174000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (893, 202302, 6, 39000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (894, 202302, 7, 149000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (895, 202302, 7, 149000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (896, 202302, 8, 149000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (897, 202302, 8, 149000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (898, 202302, 9, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (899, 202302, 9, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (900, 202302, 10, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (901, 202302, 10, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (902, 202302, 11, 24000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (903, 202302, 11, 24000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (904, 202302, 12, 64000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (905, 202302, 12, 64000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (906, 202302, 13, 39000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (907, 202302, 13, 39000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (908, 202302, 14, 34000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (909, 202302, 14, 34000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (910, 202302, 15, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (911, 202302, 16, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (912, 202302, 16, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (913, 202302, 17, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (914, 202302, 17, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (915, 202302, 18, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (916, 202302, 18, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (917, 202302, 19, 174000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (918, 202302, 19, 174000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (919, 202302, 20, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (920, 202302, 20, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (921, 202302, 21, 149000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (922, 202302, 22, 124000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (923, 202302, 22, 124000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (924, 202302, 23, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (925, 202302, 23, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (926, 202302, 24, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (927, 202302, 24, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (928, 202302, 25, 24000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (929, 202302, 26, 249000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (930, 202302, 26, 249000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (931, 202302, 27, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (932, 202302, 27, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (933, 202302, 28, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (934, 202302, 28, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (935, 202302, 29, 499000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (936, 202302, 29, 499000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (937, 202302, 30, 24000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (938, 202302, 30, 24000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (939, 202302, 31, 199000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (940, 202302, 31, 199000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (941, 202302, 32, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (942, 202302, 32, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (943, 202302, 33, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (944, 202302, 33, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (945, 202302, 34, 39000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (946, 202302, 35, 4000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (947, 202302, 35, 4000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (948, 202302, 36, 4000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (949, 202302, 36, 4000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (950, 202302, 37, 4000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (951, 202302, 37, 4000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (952, 202302, 39, 159000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (953, 202302, 39, 159000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (954, 202302, 40, 159000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (955, 202302, 40, 159000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (956, 202302, 41, 159000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (957, 202302, 41, 159000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (958, 202302, 42, 134000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (959, 202302, 43, 134000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (960, 202302, 44, 134000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (961, 202302, 45, 134000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (962, 202302, 46, 134000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (963, 202302, 47, 109000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (964, 202302, 49, 159000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (965, 202302, 50, 109000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (966, 202302, 51, 79000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (967, 202302, 52, 69000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (968, 202302, 53, 299000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (969, 202302, 54, 159000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (970, 202302, 55, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (971, 202302, 56, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (972, 202302, 57, 64000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (973, 202302, 58, 324000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (974, 202302, 59, 184000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (975, 202302, 60, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (976, 202302, 61, 79000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (977, 202302, 62, 74000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (978, 202302, 63, 69000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (979, 202302, 65, 69000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (980, 202302, 64, 74000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (981, 202302, 67, 69000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (982, 202302, 66, 69000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (983, 202302, 1, 149000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (984, 202302, 1, 149000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (985, 202302, 2, 19000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (986, 202302, 3, 249000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (987, 202302, 4, 174000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (988, 202302, 5, 174000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (989, 202302, 6, 39000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (990, 202302, 6, 39000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (991, 202302, 7, 149000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (992, 202302, 8, 149000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (993, 202302, 9, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (994, 202302, 10, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (995, 202302, 11, 24000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (996, 202302, 12, 64000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (997, 202302, 13, 39000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (998, 202302, 14, 34000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (999, 202302, 15, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1000, 202302, 15, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1001, 202302, 16, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1002, 202302, 17, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1003, 202302, 18, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1004, 202302, 19, 174000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1005, 202302, 20, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1006, 202302, 21, 149000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1007, 202302, 22, 124000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1008, 202302, 23, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1009, 202302, 24, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1010, 202302, 25, 24000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (1011, 202302, 25, 24000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1012, 202302, 26, 249000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1013, 202302, 27, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1014, 202302, 28, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1015, 202302, 29, 499000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1016, 202302, 30, 24000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1017, 202302, 31, 199000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1018, 202302, 32, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1019, 202302, 33, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1020, 202302, 34, 39000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1021, 202302, 34, 39000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (1022, 202302, 35, 4000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1023, 202302, 36, 4000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1024, 202302, 37, 4000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1025, 202302, 39, 159000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1026, 202302, 40, 159000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1027, 202302, 41, 159000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1028, 202302, 42, 134000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1029, 202302, 42, 134000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1030, 202302, 43, 134000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1031, 202302, 43, 134000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1032, 202302, 44, 134000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1033, 202302, 44, 134000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1034, 202302, 45, 134000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1035, 202302, 45, 134000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1036, 202302, 46, 134000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1037, 202302, 46, 134000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1038, 202302, 47, 109000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1039, 202302, 47, 109000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1040, 202302, 61, 79000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1041, 202302, 64, 74000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1042, 202302, 65, 69000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1043, 202302, 65, 69000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1044, 202302, 66, 69000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1045, 202302, 64, 74000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1046, 202302, 68, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1047, 202302, 68, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1048, 202302, 68, 49000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (1049, 202302, 69, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1050, 202302, 67, 69000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1051, 202302, 66, 69000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1052, 202302, 69, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1053, 202302, 69, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (1054, 202302, 70, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1055, 202302, 70, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1056, 202302, 70, 59000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (1057, 202302, 67, 69000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1058, 202302, 83, 9000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (1059, 202302, 83, 9000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1060, 202302, 83, 9000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1061, 202302, 84, 19000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (1062, 202302, 21, 149000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (1063, 202302, 48, 109000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1064, 202302, 48, 109000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1065, 202302, 48, 109000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (1066, 202302, 49, 159000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1067, 202302, 49, 159000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1068, 202302, 50, 109000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1069, 202302, 50, 109000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1070, 202302, 51, 79000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1071, 202302, 51, 79000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1072, 202302, 52, 69000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1073, 202302, 52, 69000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1074, 202302, 53, 299000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1075, 202302, 53, 299000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1076, 202302, 54, 159000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1077, 202302, 54, 159000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1078, 202302, 55, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1079, 202302, 55, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1080, 202302, 56, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1081, 202302, 56, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1082, 202302, 57, 64000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1083, 202302, 57, 64000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1084, 202302, 58, 324000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1085, 202302, 58, 324000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
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
INSERT INTO public.period_price_sell VALUES (1086, 202302, 59, 184000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
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
INSERT INTO public.period_price_sell VALUES (885, 202301, 2, 250000.00, NULL, NULL, 1, '2023-01-02 20:50:17.877671', 1);
INSERT INTO public.period_price_sell VALUES (1087, 202302, 59, 184000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1088, 202302, 60, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1089, 202302, 60, 99000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1090, 202302, 61, 79000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1091, 202302, 62, 74000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1092, 202302, 62, 74000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1093, 202302, 63, 69000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1094, 202302, 63, 69000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1095, 202302, 84, 19000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1096, 202302, 84, 19000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1097, 202302, 86, 19000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (1098, 202302, 86, 19000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1099, 202302, 86, 19000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1100, 202302, 85, 9000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (1101, 202302, 85, 9000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1102, 202302, 85, 9000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1103, 202302, 89, 9000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (1104, 202302, 89, 0.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 2);
INSERT INTO public.period_price_sell VALUES (1105, 202302, 89, 9000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 3);
INSERT INTO public.period_price_sell VALUES (1106, 202302, 3, 250000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (1107, 202302, 2, 250000.00, NULL, NULL, 1, '2023-02-04 09:34:09.490973', 1);
INSERT INTO public.period_price_sell VALUES (1108, 202302, 251, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1109, 202302, 256, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1110, 202302, 261, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1111, 202302, 266, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1112, 202302, 271, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1113, 202302, 275, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1114, 202302, 279, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1115, 202302, 284, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1116, 202302, 289, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1117, 202302, 293, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1118, 202302, 297, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1119, 202302, 305, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1120, 202302, 313, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1121, 202302, 317, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1122, 202302, 309, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1123, 202302, 301, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1124, 202302, 321, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1125, 202302, 104, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1126, 202302, 105, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1127, 202302, 94, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1128, 202302, 93, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1129, 202302, 101, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1130, 202302, 113, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1131, 202302, 115, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1132, 202302, 98, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1133, 202302, 124, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1134, 202302, 118, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1135, 202302, 280, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1136, 202302, 117, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1137, 202302, 131, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1138, 202302, 96, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1139, 202302, 285, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1140, 202302, 91, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1141, 202302, 99, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1142, 202302, 120, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1143, 202302, 106, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1144, 202302, 125, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1145, 202302, 121, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1146, 202302, 95, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1147, 202302, 138, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1148, 202302, 137, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1149, 202302, 102, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1150, 202302, 100, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1151, 202302, 103, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1152, 202302, 136, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1153, 202302, 109, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1154, 202302, 110, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1155, 202302, 134, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1156, 202302, 108, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1157, 202302, 133, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1158, 202302, 112, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1159, 202302, 116, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1160, 202302, 130, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1161, 202302, 127, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1162, 202302, 114, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1163, 202302, 142, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1164, 202302, 119, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1165, 202302, 123, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1166, 202302, 122, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1167, 202302, 126, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1168, 202302, 252, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1169, 202302, 128, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1170, 202302, 129, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1171, 202302, 92, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1172, 202302, 107, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1173, 202302, 132, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1174, 202302, 97, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1175, 202302, 257, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1176, 202302, 135, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1177, 202302, 262, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1178, 202302, 139, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1179, 202302, 140, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1180, 202302, 141, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1181, 202302, 267, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1182, 202302, 143, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1183, 202302, 206, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1184, 202302, 202, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1185, 202302, 147, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1186, 202302, 111, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1187, 202302, 149, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1188, 202302, 150, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1189, 202302, 151, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1190, 202302, 152, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1191, 202302, 153, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1192, 202302, 154, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1193, 202302, 155, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1194, 202302, 156, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1195, 202302, 157, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1196, 202302, 158, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1197, 202302, 159, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1198, 202302, 160, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1199, 202302, 161, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1200, 202302, 162, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1201, 202302, 164, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1202, 202302, 146, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1203, 202302, 174, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1204, 202302, 166, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1205, 202302, 167, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1206, 202302, 168, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1207, 202302, 169, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1208, 202302, 170, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1209, 202302, 165, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1210, 202302, 171, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1211, 202302, 172, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1212, 202302, 173, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1213, 202302, 175, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1214, 202302, 176, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1215, 202302, 177, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1216, 202302, 178, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1217, 202302, 179, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1218, 202302, 180, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1219, 202302, 193, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1220, 202302, 187, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1221, 202302, 182, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1222, 202302, 183, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1223, 202302, 181, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1224, 202302, 184, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1225, 202302, 185, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1226, 202302, 186, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1227, 202302, 188, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1228, 202302, 189, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1229, 202302, 190, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1230, 202302, 191, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1231, 202302, 192, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1232, 202302, 194, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1233, 202302, 195, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1234, 202302, 163, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1235, 202302, 198, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1236, 202302, 200, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1237, 202302, 201, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1238, 202302, 203, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1239, 202302, 204, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1240, 202302, 205, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1241, 202302, 207, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1242, 202302, 208, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1243, 202302, 209, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1244, 202302, 272, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1245, 202302, 237, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1246, 202302, 211, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1247, 202302, 210, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1248, 202302, 212, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1249, 202302, 213, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1250, 202302, 214, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1251, 202302, 215, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1252, 202302, 216, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1253, 202302, 217, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1254, 202302, 199, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1255, 202302, 253, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1256, 202302, 220, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1257, 202302, 221, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1258, 202302, 281, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1259, 202302, 223, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1260, 202302, 225, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1261, 202302, 226, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1262, 202302, 227, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1263, 202302, 228, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1264, 202302, 263, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1265, 202302, 229, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1266, 202302, 231, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1267, 202302, 232, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1268, 202302, 233, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1269, 202302, 234, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1270, 202302, 235, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1271, 202302, 236, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1272, 202302, 238, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1273, 202302, 239, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1274, 202302, 241, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1275, 202302, 242, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1276, 202302, 243, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1277, 202302, 244, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1278, 202302, 268, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1279, 202302, 246, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1280, 202302, 247, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1281, 202302, 248, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1282, 202302, 249, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1283, 202302, 250, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1284, 202302, 286, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1285, 202302, 290, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1286, 202302, 294, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1287, 202302, 298, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1288, 202302, 276, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1289, 202302, 302, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1290, 202302, 306, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1291, 202302, 310, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1292, 202302, 318, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1293, 202302, 322, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1294, 202302, 282, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1295, 202302, 287, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1296, 202302, 277, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1297, 202302, 291, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1298, 202302, 295, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1299, 202302, 299, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1300, 202302, 307, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1301, 202302, 315, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1302, 202302, 254, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1303, 202302, 319, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1304, 202302, 323, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1305, 202302, 264, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1306, 202302, 269, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1307, 202302, 273, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1308, 202302, 283, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1309, 202302, 288, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1310, 202302, 292, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1311, 202302, 296, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1312, 202302, 304, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1313, 202302, 308, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1314, 202302, 312, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1315, 202302, 255, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1316, 202302, 260, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1317, 202302, 265, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1318, 202302, 270, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1319, 202302, 274, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1320, 202302, 316, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1321, 202302, 300, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1322, 202302, 320, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);
INSERT INTO public.period_price_sell VALUES (1323, 202302, 278, 0.00, '2023-02-15 11:47:23.150915', 1, 1, '2023-02-15 11:47:23.150915', 14);


--
-- TOC entry 3726 (class 0 OID 18073)
-- Dependencies: 230
-- Data for Name: period_stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

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
INSERT INTO public.period_stock VALUES (202301, 1, 26, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 17, 10000, 10000, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 40, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 41, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 44, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 49, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 53, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 54, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 55, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 57, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 58, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 61, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 64, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 65, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 67, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 68, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 70, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
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
INSERT INTO public.period_stock VALUES (202301, 2, 59, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 60, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 61, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 62, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 2, 63, 9999, 9999, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 47, 9994, 9993, 0, 1, '2023-01-09 20:17:56.829445', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 48, 9998, 9996, 0, 2, '2023-01-18 18:07:58.225047', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 25, 9998, 9997, 0, 1, '2023-01-18 17:43:59.356723', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 50, 9997, 9995, 0, 2, '2023-01-18 17:43:59.103207', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 45, 9995, 9992, 0, 3, '2023-01-20 11:15:45.388117', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 46, 9998, 9994, 0, 4, '2023-01-20 10:56:02.742354', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 43, 9998, 9997, 0, 1, '2023-01-20 10:59:41.918638', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 2, 9999, 9986, 0, 13, '2023-01-30 18:50:12.345735', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 62, 9999, 9998, 0, 1, '2023-01-20 10:24:04.463235', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 52, 9994, 9992, 0, 2, '2023-01-20 10:24:04.296806', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 69, 9999, 9997, 0, 2, '2023-01-20 10:48:36.529688', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 5, 9998, 9997, 0, 1, '2023-01-30 18:25:17.072838', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 42, 9998, 9995, 0, 3, '2023-01-30 18:50:12.252044', 1, '2023-01-02 20:54:24.132802');
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
INSERT INTO public.period_stock VALUES (202301, 1, 1, 9988, 9988, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 63, 9998, 9998, 0, 0, NULL, 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 60, 9997, 9996, 0, 1, '2023-01-18 18:17:40.389643', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 56, 9999, 9998, 0, 1, '2023-01-09 19:29:37.452638', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 66, 9999, 9996, 0, 3, '2023-01-09 20:56:14.981575', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 3, 9997, 9996, 0, 1, '2023-01-09 20:56:15.189691', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 51, 9997, 9996, 0, 1, '2023-01-18 17:57:35.062713', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 59, 9995, 9993, 0, 2, '2023-01-18 18:17:09.870517', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 12, 9993, 9992, 0, 1, '2023-01-20 10:48:36.685813', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202301, 1, 13, 9999, 9997, 0, 2, '2023-01-20 10:59:41.809592', 1, '2023-01-02 20:54:24.132802');
INSERT INTO public.period_stock VALUES (202302, 1, 8, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 9, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 11, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 19, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 20, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 24, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 28, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 29, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 18, 9998, 9998, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 21, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 30, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 31, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 33, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 34, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 2, 9986, 9986, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 5, 9997, 9997, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 32, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 22, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 7, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 14, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 15, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 16, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 23, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 35, 9997, 9997, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 36, 9997, 9997, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 37, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 25, 9997, 9997, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 26, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 17, 10000, 10000, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 40, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 41, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 42, 9995, 9995, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 43, 9997, 9997, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 44, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 45, 9992, 9992, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 46, 9994, 9994, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 47, 9993, 9993, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 48, 9996, 9996, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 49, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 50, 9995, 9995, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 53, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 54, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 55, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 57, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 58, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 61, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 62, 9998, 9998, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 64, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 65, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 67, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 68, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 70, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 69, 9997, 9997, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 76, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 1, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 8, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 10, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 12, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 13, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 18, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 19, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 21, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 24, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 27, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 29, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 30, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 31, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 33, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 34, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 2, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 3, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 4, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 32, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 6, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 22, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 14, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 15, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 16, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 36, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 37, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 25, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 26, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 17, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 39, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 40, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 41, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 42, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 45, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 43, 9997, 9997, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 44, 9997, 9997, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 35, 9998, 9998, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 5, 9998, 9998, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 7, 9997, 9997, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 49, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 50, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 51, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 52, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 53, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 54, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 55, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 56, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 57, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 58, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 28, 9998, 9998, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 9, 9998, 9998, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 6, 9998, 9998, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 39, 9998, 9998, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 4, 9996, 9996, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 52, 9992, 9992, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 59, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 60, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 61, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 62, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 63, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 64, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 65, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 66, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 67, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 68, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 70, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 69, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 76, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 1, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 8, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 10, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 11, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 12, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 13, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 18, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 19, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 24, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 27, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 28, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 29, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 30, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 31, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 33, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 34, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 2, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 3, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 4, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 5, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 32, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 6, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 22, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 7, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 14, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 15, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 16, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 23, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 35, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 36, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 37, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 25, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 26, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 17, 10000, 10000, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 39, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 40, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 41, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 42, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 43, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 47, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 49, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 50, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 51, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 52, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 53, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 54, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 55, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 56, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 57, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 58, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 59, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 60, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 61, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 62, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 63, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 64, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 65, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 66, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 67, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 68, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 70, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 69, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 76, 9999, 9999, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 27, 10108, 10108, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 46, 9998, 9998, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 48, 9989, 9989, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 45, 9998, 9998, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 10, 10000, 10000, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 47, 9995, 9995, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 23, 9998, 9998, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 46, 9995, 9995, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 44, 9991, 9991, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 48, 9990, 9990, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 20, 9995, 9995, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 2, 11, 9997, 9997, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 20, 9998, 9998, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 9, 9998, 9998, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 3, 21, 9998, 9998, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 3, 9996, 9996, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 1, 9988, 9988, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 59, 9993, 9993, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 12, 9992, 9992, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 51, 9996, 9996, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 63, 9998, 9998, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 60, 9996, 9996, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 56, 9998, 9998, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 66, 9996, 9996, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 1, 13, 9997, 9997, 0, 0, NULL, 1, '2023-02-04 09:34:09.461216');
INSERT INTO public.period_stock VALUES (202302, 14, 256, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 261, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 266, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 271, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 279, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 297, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 305, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 313, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 275, 0, -2, 0, 2, '2023-02-15 20:55:36.458745', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 289, 0, -14, 0, 14, '2023-02-15 20:56:54.920749', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 251, 0, -12, 0, 12, '2023-02-15 22:38:07.175114', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 317, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 309, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 321, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 104, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 105, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 94, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 101, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 113, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 115, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 98, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 124, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 118, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 280, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 117, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 131, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 96, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 285, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 91, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 99, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 120, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 106, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 125, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 121, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 95, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 138, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 137, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 102, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 100, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 103, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 136, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 109, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 110, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 134, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 108, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 133, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 112, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 116, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 130, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 127, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 114, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 142, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 119, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 123, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 122, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 126, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 252, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 128, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 129, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 107, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 132, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 97, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 257, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 135, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 262, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 139, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 140, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 141, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 267, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 143, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 206, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 202, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 147, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 111, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 149, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 150, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 151, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 152, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 153, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 154, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 155, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 156, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 157, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 158, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 159, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 160, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 161, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 162, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 164, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 146, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 174, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 166, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 167, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 168, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 169, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 170, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 165, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 171, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 172, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 173, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 175, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 176, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 177, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 178, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 179, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 93, 0, -1, 0, 1, '2023-02-15 15:49:25.084332', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 92, 0, -1, 0, 1, '2023-02-15 19:21:16.859936', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 180, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 193, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 187, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 182, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 183, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 181, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 184, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 185, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 186, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 188, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 189, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 190, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 191, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 192, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 194, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 195, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 163, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 198, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 200, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 201, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 203, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 204, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 205, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 207, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 208, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 209, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 272, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 237, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 211, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 210, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 212, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 213, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 214, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 215, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 216, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 217, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 199, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 253, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 220, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 221, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 281, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 223, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 225, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 226, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 227, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 228, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 263, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 229, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 231, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 232, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 233, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 234, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 235, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 236, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 238, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 239, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 241, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 242, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 243, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 244, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 268, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 246, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 247, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 248, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 249, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 250, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 286, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 298, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 302, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 306, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 287, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 277, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 295, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 299, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 315, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 254, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 319, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 323, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 264, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 269, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 273, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 283, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 292, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 296, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 304, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 308, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 312, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 290, 0, -1, 0, 1, '2023-02-15 14:35:33.077941', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 322, 0, -1, 0, 1, '2023-02-15 19:51:11.188204', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 307, 0, -1, 0, 1, '2023-02-15 17:28:14.401339', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 288, 0, -1, 0, 1, '2023-02-15 19:27:11.341449', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 318, 0, -1, 0, 1, '2023-02-15 17:38:42.325382', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 276, 0, -1, 0, 1, '2023-02-15 20:19:36.2502', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 310, 0, -1, 0, 1, '2023-02-15 20:53:45.819209', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 291, 0, -3, 0, 3, '2023-02-15 21:21:24.89858', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 255, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 260, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 265, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 270, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 316, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 300, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 320, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 278, 0, 0, 0, 0, '2023-02-15 11:40:53.599407', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 301, 0, -1, 0, 1, '2023-02-15 11:55:34.973955', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 294, 0, -1, 0, 1, '2023-02-15 14:35:32.921344', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 293, 0, -3, 0, 3, '2023-02-15 17:28:14.28924', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 282, 0, -2, 0, 2, '2023-02-15 17:58:05.56715', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 284, 0, -10, 0, 10, '2023-02-15 22:41:26.06521', 1, '2023-02-15 11:40:53.599407');
INSERT INTO public.period_stock VALUES (202302, 14, 274, 0, -7, 0, 7, '2023-02-15 22:44:11.766868', 1, '2023-02-15 11:40:53.599407');


--
-- TOC entry 3727 (class 0 OID 18083)
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
INSERT INTO public.permissions VALUES (151, 'types.pindex', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/types', 'Tipe', 'Products');
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
INSERT INTO public.permissions VALUES (347, 'servicescommision.pindex', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/servicescommision', 'Komisi Perawatan', 'Services');
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
INSERT INTO public.permissions VALUES (295, 'reports.closeday.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/reports/closeday', 'Closing Harian', 'Reports');
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


--
-- TOC entry 3729 (class 0 OID 18091)
-- Dependencies: 233
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3731 (class 0 OID 18099)
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
-- TOC entry 3732 (class 0 OID 18104)
-- Dependencies: 236
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.posts VALUES (2, 1, '1', '12', '1', '2022-05-28 15:29:26', '2022-05-28 15:29:30');


--
-- TOC entry 3734 (class 0 OID 18112)
-- Dependencies: 238
-- Data for Name: price_adjustment; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3736 (class 0 OID 18119)
-- Dependencies: 240
-- Data for Name: product_brand; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_brand VALUES (10, 'BALI ALUS', '2023-02-04 12:45:26', '2023-02-04 12:45:26', 1);
INSERT INTO public.product_brand VALUES (11, 'ACL', '2023-02-06 12:30:53', '2023-02-06 12:30:53', 1);
INSERT INTO public.product_brand VALUES (12, 'BUNGAN JEPUN', '2023-02-06 12:31:32', '2023-02-06 12:31:32', 1);
INSERT INTO public.product_brand VALUES (13, 'BIOKOS', '2023-02-06 12:32:01', '2023-02-06 12:32:01', 1);
INSERT INTO public.product_brand VALUES (14, 'IANTHE', '2023-02-06 12:32:51', '2023-02-06 12:32:51', 1);
INSERT INTO public.product_brand VALUES (15, 'INTRA JAHE', '2023-02-06 12:36:07', '2023-02-06 12:36:07', 1);
INSERT INTO public.product_brand VALUES (16, 'LAIN LAIN', '2023-02-06 12:38:11', '2023-02-06 12:38:11', 1);
INSERT INTO public.product_brand VALUES (17, 'ENIGMA', '2023-02-08 19:57:17', '2023-02-08 19:57:17', 1);
INSERT INTO public.product_brand VALUES (20, 'PAKAI', '2023-02-09 18:51:20', '2023-02-09 18:51:20', 1);
INSERT INTO public.product_brand VALUES (19, 'LAIN-LAIN', '2023-02-09 18:43:48', '2023-02-09 18:43:48', 2);


--
-- TOC entry 3738 (class 0 OID 18129)
-- Dependencies: 242
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_category VALUES (16, 'CREAM', '2023-02-08 18:51:13', '2023-02-08 18:51:13', 1);
INSERT INTO public.product_category VALUES (17, 'SCRUB', '2023-02-08 18:51:42', '2023-02-08 18:51:42', 1);
INSERT INTO public.product_category VALUES (18, 'GEL', '2023-02-08 18:51:55', '2023-02-08 18:51:55', 1);
INSERT INTO public.product_category VALUES (19, 'CRYSTAL', '2023-02-08 19:01:20', '2023-02-08 19:01:20', 1);
INSERT INTO public.product_category VALUES (20, 'SERBUK', '2023-02-08 19:04:00', '2023-02-08 19:04:00', 1);
INSERT INTO public.product_category VALUES (21, 'MASKER', '2023-02-08 19:09:01', '2023-02-08 19:09:01', 1);
INSERT INTO public.product_category VALUES (22, 'LAIN-LAIN', '2023-02-08 19:17:59', '2023-02-08 19:17:59', 1);
INSERT INTO public.product_category VALUES (23, 'SABUN', '2023-02-08 19:33:40', '2023-02-08 19:33:40', 1);
INSERT INTO public.product_category VALUES (24, 'SHAMPO', '2023-02-08 19:34:53', '2023-02-08 19:34:53', 1);
INSERT INTO public.product_category VALUES (25, 'SPRAY', '2023-02-08 19:42:41', '2023-02-08 19:42:41', 1);
INSERT INTO public.product_category VALUES (26, 'MINUMAN', '2023-02-08 19:52:59', '2023-02-08 19:52:59', 1);
INSERT INTO public.product_category VALUES (27, 'MINYAK', '2023-02-08 19:56:54', '2023-02-08 19:56:54', 1);
INSERT INTO public.product_category VALUES (28, 'MESIN', '2023-02-08 20:02:13', '2023-02-08 20:02:13', 1);
INSERT INTO public.product_category VALUES (29, 'BUKU', '2023-02-08 20:06:01', '2023-02-08 20:06:01', 1);
INSERT INTO public.product_category VALUES (7, 'SERUM', '2022-06-01 20:43:14.607895', '2023-02-09 11:06:43', 1);
INSERT INTO public.product_category VALUES (44, 'FULL BODY CATEGORY', '2023-02-09 18:40:57', '2023-02-09 18:40:57', 2);
INSERT INTO public.product_category VALUES (6, 'ADD ONS', '2022-06-01 20:43:14.607895', NULL, 2);
INSERT INTO public.product_category VALUES (48, 'FACE CATEGORY', '2023-02-10 10:27:18', '2023-02-10 10:27:18', 2);
INSERT INTO public.product_category VALUES (49, 'FEMALE CATEGORY', '2023-02-10 10:27:32', '2023-02-10 10:27:32', 2);
INSERT INTO public.product_category VALUES (50, 'SCRUB CATEGORY', '2023-02-10 10:28:07', '2023-02-10 10:28:07', 2);
INSERT INTO public.product_category VALUES (51, 'FOOT CATEGORY', '2023-02-10 10:28:39', '2023-02-10 10:28:39', 2);
INSERT INTO public.product_category VALUES (52, 'EXTRA', '2023-02-10 10:29:45', '2023-02-10 10:29:45', 2);


--
-- TOC entry 3740 (class 0 OID 18139)
-- Dependencies: 244
-- Data for Name: product_commision_by_year; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_commision_by_year VALUES (280, 14, 2, 1, 30000, 1, '2023-02-11 09:24:58', '2023-02-11 09:24:58');
INSERT INTO public.product_commision_by_year VALUES (280, 14, 2, 3, 34000, 1, '2023-02-11 09:26:01', '2023-02-11 09:26:01');
INSERT INTO public.product_commision_by_year VALUES (284, 14, 2, 3, 29000, 1, '2023-02-11 09:27:19', '2023-02-11 09:27:19');
INSERT INTO public.product_commision_by_year VALUES (284, 14, 2, 6, 35000, 1, '2023-02-11 09:28:40', '2023-02-11 09:28:40');
INSERT INTO public.product_commision_by_year VALUES (284, 14, 2, 9, 41000, 1, '2023-02-11 09:30:31', '2023-02-11 09:30:31');
INSERT INTO public.product_commision_by_year VALUES (286, 14, 2, 2, 27000, 1, '2023-02-11 09:31:34', '2023-02-11 09:31:34');
INSERT INTO public.product_commision_by_year VALUES (286, 14, 2, 5, 33000, 1, '2023-02-11 09:32:36', '2023-02-11 09:32:36');
INSERT INTO public.product_commision_by_year VALUES (286, 14, 2, 8, 39000, 1, '2023-02-11 09:33:32', '2023-02-11 09:33:32');
INSERT INTO public.product_commision_by_year VALUES (288, 14, 2, 1, 25000, 1, '2023-02-11 09:34:51', '2023-02-11 09:34:51');
INSERT INTO public.product_commision_by_year VALUES (288, 14, 2, 4, 31000, 1, '2023-02-11 09:35:58', '2023-02-11 09:35:58');
INSERT INTO public.product_commision_by_year VALUES (288, 14, 2, 7, 37000, 1, '2023-02-11 09:37:05', '2023-02-11 09:37:05');
INSERT INTO public.product_commision_by_year VALUES (288, 14, 2, 10, 43000, 1, '2023-02-11 09:38:13', '2023-02-11 09:38:13');
INSERT INTO public.product_commision_by_year VALUES (291, 14, 2, 3, 29000, 1, '2023-02-11 09:39:26', '2023-02-11 09:39:26');
INSERT INTO public.product_commision_by_year VALUES (280, 14, 2, 6, 40000, 1, '2023-02-11 09:40:42', '2023-02-11 09:40:42');
INSERT INTO public.product_commision_by_year VALUES (280, 14, 2, 8, 44000, 1, '2023-02-11 09:41:24', '2023-02-11 09:41:24');
INSERT INTO public.product_commision_by_year VALUES (291, 14, 2, 6, 35000, 1, '2023-02-11 09:42:17', '2023-02-11 09:42:17');
INSERT INTO public.product_commision_by_year VALUES (282, 14, 2, 1, 30000, 1, '2023-02-11 09:44:42', '2023-02-11 09:44:42');
INSERT INTO public.product_commision_by_year VALUES (282, 14, 2, 4, 36000, 1, '2023-02-11 09:45:48', '2023-02-11 09:45:48');
INSERT INTO public.product_commision_by_year VALUES (289, 14, 2, 1, 25000, 1, '2023-02-11 09:46:31', '2023-02-11 09:46:31');
INSERT INTO public.product_commision_by_year VALUES (282, 14, 2, 7, 42000, 1, '2023-02-11 09:46:57', '2023-02-11 09:46:57');
INSERT INTO public.product_commision_by_year VALUES (308, 14, 2, 6, 19000, 1, '2023-02-11 10:45:25', '2023-02-11 10:45:25');
INSERT INTO public.product_commision_by_year VALUES (308, 14, 2, 7, 20000, 1, '2023-02-11 10:45:49', '2023-02-11 10:45:49');
INSERT INTO public.product_commision_by_year VALUES (289, 14, 2, 4, 31000, 1, '2023-02-11 09:47:21', '2023-02-11 09:47:21');
INSERT INTO public.product_commision_by_year VALUES (282, 14, 2, 10, 48000, 1, '2023-02-11 09:48:07', '2023-02-11 09:48:07');
INSERT INTO public.product_commision_by_year VALUES (293, 14, 2, 1, 17000, 1, '2023-02-11 09:50:13', '2023-02-11 09:50:13');
INSERT INTO public.product_commision_by_year VALUES (283, 14, 2, 2, 32000, 1, '2023-02-11 09:50:41', '2023-02-11 09:50:41');
INSERT INTO public.product_commision_by_year VALUES (293, 14, 2, 4, 23000, 1, '2023-02-11 09:51:07', '2023-02-11 09:51:07');
INSERT INTO public.product_commision_by_year VALUES (293, 14, 2, 6, 27000, 1, '2023-02-11 09:51:51', '2023-02-11 09:51:51');
INSERT INTO public.product_commision_by_year VALUES (293, 14, 2, 7, 29000, 1, '2023-02-11 09:52:08', '2023-02-11 09:52:08');
INSERT INTO public.product_commision_by_year VALUES (293, 14, 2, 8, 31000, 1, '2023-02-11 09:52:31', '2023-02-11 09:52:31');
INSERT INTO public.product_commision_by_year VALUES (293, 14, 2, 9, 33000, 1, '2023-02-11 09:52:58', '2023-02-11 09:52:58');
INSERT INTO public.product_commision_by_year VALUES (283, 14, 2, 8, 44000, 1, '2023-02-11 09:53:49', '2023-02-11 09:53:49');
INSERT INTO public.product_commision_by_year VALUES (283, 14, 2, 10, 48000, 1, '2023-02-11 09:54:28', '2023-02-11 09:54:28');
INSERT INTO public.product_commision_by_year VALUES (294, 14, 2, 4, 23000, 1, '2023-02-11 09:55:35', '2023-02-11 09:55:35');
INSERT INTO public.product_commision_by_year VALUES (285, 14, 2, 2, 17000, 1, '2023-02-11 09:56:08', '2023-02-11 09:56:08');
INSERT INTO public.product_commision_by_year VALUES (285, 14, 2, 3, 19000, 1, '2023-02-11 09:56:24', '2023-02-11 09:56:24');
INSERT INTO public.product_commision_by_year VALUES (294, 14, 2, 8, 31000, 1, '2023-02-11 09:57:08', '2023-02-11 09:57:08');
INSERT INTO public.product_commision_by_year VALUES (294, 14, 2, 9, 33000, 1, '2023-02-11 09:57:29', '2023-02-11 09:57:29');
INSERT INTO public.product_commision_by_year VALUES (294, 14, 2, 10, 35000, 1, '2023-02-11 09:57:49', '2023-02-11 09:57:49');
INSERT INTO public.product_commision_by_year VALUES (285, 14, 2, 8, 29000, 1, '2023-02-11 09:58:11', '2023-02-11 09:58:11');
INSERT INTO public.product_commision_by_year VALUES (295, 14, 2, 1, 17000, 1, '2023-02-11 09:58:55', '2023-02-11 09:58:55');
INSERT INTO public.product_commision_by_year VALUES (295, 14, 2, 2, 19000, 1, '2023-02-11 09:59:11', '2023-02-11 09:59:11');
INSERT INTO public.product_commision_by_year VALUES (306, 14, 2, 8, 34000, 1, '2023-02-11 10:46:45', '2023-02-11 10:46:45');
INSERT INTO public.product_commision_by_year VALUES (295, 14, 2, 6, 27000, 1, '2023-02-11 10:01:39', '2023-02-11 10:01:39');
INSERT INTO public.product_commision_by_year VALUES (287, 14, 2, 2, 8000, 1, '2023-02-11 10:02:23', '2023-02-11 10:02:23');
INSERT INTO public.product_commision_by_year VALUES (295, 14, 2, 8, 31000, 1, '2023-02-11 10:03:24', '2023-02-11 10:03:24');
INSERT INTO public.product_commision_by_year VALUES (287, 14, 2, 6, 9000, 1, '2023-02-11 10:04:29', '2023-02-11 10:04:29');
INSERT INTO public.product_commision_by_year VALUES (287, 14, 2, 8, 10000, 1, '2023-02-11 10:05:37', '2023-02-11 10:05:37');
INSERT INTO public.product_commision_by_year VALUES (292, 14, 2, 3, 44000, 1, '2023-02-11 10:08:40', '2023-02-11 10:08:40');
INSERT INTO public.product_commision_by_year VALUES (292, 14, 2, 5, 48000, 1, '2023-02-11 10:09:40', '2023-02-11 10:09:40');
INSERT INTO public.product_commision_by_year VALUES (292, 14, 2, 8, 54000, 1, '2023-02-11 10:10:37', '2023-02-11 10:10:37');
INSERT INTO public.product_commision_by_year VALUES (312, 14, 2, 1, 55000, 1, '2023-02-11 10:47:39', '2023-02-11 10:47:39');
INSERT INTO public.product_commision_by_year VALUES (292, 14, 2, 9, 56000, 1, '2023-02-11 10:11:36', '2023-02-11 10:11:36');
INSERT INTO public.product_commision_by_year VALUES (296, 14, 2, 3, 24000, 1, '2023-02-11 10:13:22', '2023-02-11 10:13:22');
INSERT INTO public.product_commision_by_year VALUES (296, 14, 2, 5, 28000, 1, '2023-02-11 10:14:18', '2023-02-11 10:14:18');
INSERT INTO public.product_commision_by_year VALUES (296, 14, 2, 6, 29000, 1, '2023-02-11 10:14:45', '2023-02-11 10:14:45');
INSERT INTO public.product_commision_by_year VALUES (281, 14, 2, 4, 31000, 1, '2023-02-11 10:15:12', '2023-02-11 10:15:12');
INSERT INTO public.product_commision_by_year VALUES (281, 14, 2, 6, 34000, 1, '2023-02-11 10:16:01', '2023-02-11 10:16:01');
INSERT INTO public.product_commision_by_year VALUES (281, 14, 2, 7, 35000, 1, '2023-02-11 10:16:38', '2023-02-11 10:16:38');
INSERT INTO public.product_commision_by_year VALUES (290, 14, 2, 4, 8000, 1, '2023-02-11 10:17:01', '2023-02-11 10:17:01');
INSERT INTO public.product_commision_by_year VALUES (281, 14, 2, 9, 37000, 1, '2023-02-11 10:17:28', '2023-02-11 10:17:28');
INSERT INTO public.product_commision_by_year VALUES (281, 14, 2, 10, 38000, 1, '2023-02-11 10:17:54', '2023-02-11 10:17:54');
INSERT INTO public.product_commision_by_year VALUES (290, 14, 2, 7, 8000, 1, '2023-02-11 10:18:17', '2023-02-11 10:18:17');
INSERT INTO public.product_commision_by_year VALUES (299, 14, 2, 1, 8000, 1, '2023-02-11 10:18:46', '2023-02-11 10:18:46');
INSERT INTO public.product_commision_by_year VALUES (299, 14, 2, 3, 9000, 1, '2023-02-11 10:19:17', '2023-02-11 10:19:17');
INSERT INTO public.product_commision_by_year VALUES (297, 14, 2, 6, 14000, 1, '2023-02-11 10:19:37', '2023-02-11 10:19:37');
INSERT INTO public.product_commision_by_year VALUES (297, 14, 2, 7, 16000, 1, '2023-02-11 10:20:04', '2023-02-11 10:20:04');
INSERT INTO public.product_commision_by_year VALUES (297, 14, 2, 9, 18000, 1, '2023-02-11 10:20:40', '2023-02-11 10:20:40');
INSERT INTO public.product_commision_by_year VALUES (299, 14, 2, 8, 11000, 1, '2023-02-11 10:21:55', '2023-02-11 10:21:55');
INSERT INTO public.product_commision_by_year VALUES (298, 14, 2, 2, 10000, 1, '2023-02-11 10:22:40', '2023-02-11 10:22:40');
INSERT INTO public.product_commision_by_year VALUES (298, 14, 2, 3, 12000, 1, '2023-02-11 10:22:55', '2023-02-11 10:22:55');
INSERT INTO public.product_commision_by_year VALUES (298, 14, 2, 5, 14000, 1, '2023-02-11 10:23:41', '2023-02-11 10:23:41');
INSERT INTO public.product_commision_by_year VALUES (298, 14, 2, 10, 18000, 1, '2023-02-11 10:27:26', '2023-02-11 10:27:26');
INSERT INTO public.product_commision_by_year VALUES (301, 14, 2, 3, 48000, 1, '2023-02-11 10:29:22', '2023-02-11 10:29:22');
INSERT INTO public.product_commision_by_year VALUES (301, 14, 2, 5, 52000, 1, '2023-02-11 10:30:18', '2023-02-11 10:30:18');
INSERT INTO public.product_commision_by_year VALUES (302, 14, 2, 3, 34000, 1, '2023-02-11 10:30:41', '2023-02-11 10:30:41');
INSERT INTO public.product_commision_by_year VALUES (302, 14, 2, 4, 36000, 1, '2023-02-11 10:31:03', '2023-02-11 10:31:03');
INSERT INTO public.product_commision_by_year VALUES (302, 14, 2, 5, 38000, 1, '2023-02-11 10:31:24', '2023-02-11 10:31:24');
INSERT INTO public.product_commision_by_year VALUES (302, 14, 2, 6, 39000, 1, '2023-02-11 10:31:54', '2023-02-11 10:31:54');
INSERT INTO public.product_commision_by_year VALUES (301, 14, 2, 10, 62000, 1, '2023-02-11 10:32:35', '2023-02-11 10:32:35');
INSERT INTO public.product_commision_by_year VALUES (302, 14, 2, 8, 41000, 1, '2023-02-11 10:32:52', '2023-02-11 10:32:52');
INSERT INTO public.product_commision_by_year VALUES (300, 14, 2, 8, 64000, 1, '2023-02-11 10:33:23', '2023-02-11 10:33:23');
INSERT INTO public.product_commision_by_year VALUES (300, 14, 2, 10, 68000, 1, '2023-02-11 10:34:03', '2023-02-11 10:34:03');
INSERT INTO public.product_commision_by_year VALUES (305, 14, 2, 2, 24000, 1, '2023-02-11 10:34:32', '2023-02-11 10:34:32');
INSERT INTO public.product_commision_by_year VALUES (305, 14, 2, 4, 28000, 1, '2023-02-11 10:36:00', '2023-02-11 10:36:00');
INSERT INTO public.product_commision_by_year VALUES (300, 14, 2, 5, 58000, 1, '2023-02-11 10:38:43', '2023-02-11 10:38:43');
INSERT INTO public.product_commision_by_year VALUES (304, 14, 2, 1, 25000, 1, '2023-02-11 10:39:15', '2023-02-11 10:39:15');
INSERT INTO public.product_commision_by_year VALUES (304, 14, 2, 3, 29000, 1, '2023-02-11 10:39:59', '2023-02-11 10:39:59');
INSERT INTO public.product_commision_by_year VALUES (304, 14, 2, 4, 31000, 1, '2023-02-11 10:40:23', '2023-02-11 10:40:23');
INSERT INTO public.product_commision_by_year VALUES (304, 14, 2, 6, 34000, 1, '2023-02-11 10:40:54', '2023-02-11 10:40:54');
INSERT INTO public.product_commision_by_year VALUES (304, 14, 2, 7, 35000, 1, '2023-02-11 10:41:11', '2023-02-11 10:41:11');
INSERT INTO public.product_commision_by_year VALUES (304, 14, 2, 9, 37000, 1, '2023-02-11 10:41:45', '2023-02-11 10:41:45');
INSERT INTO public.product_commision_by_year VALUES (307, 14, 2, 5, 23000, 1, '2023-02-11 10:42:05', '2023-02-11 10:42:05');
INSERT INTO public.product_commision_by_year VALUES (307, 14, 2, 6, 25000, 1, '2023-02-11 10:42:38', '2023-02-11 10:42:38');
INSERT INTO public.product_commision_by_year VALUES (307, 14, 2, 9, 31000, 1, '2023-02-11 10:43:49', '2023-02-11 10:43:49');
INSERT INTO public.product_commision_by_year VALUES (306, 14, 2, 2, 22000, 1, '2023-02-11 10:44:33', '2023-02-11 10:44:33');
INSERT INTO public.product_commision_by_year VALUES (316, 14, 2, 1, 10000, 1, '2023-02-11 10:48:40', '2023-02-11 10:48:40');
INSERT INTO public.product_commision_by_year VALUES (316, 14, 2, 3, 10000, 1, '2023-02-11 10:49:15', '2023-02-11 10:49:15');
INSERT INTO public.product_commision_by_year VALUES (315, 14, 2, 4, 9000, 1, '2023-02-11 10:49:41', '2023-02-11 10:49:41');
INSERT INTO public.product_commision_by_year VALUES (316, 14, 2, 5, 11000, 1, '2023-02-11 10:49:57', '2023-02-11 10:49:57');
INSERT INTO public.product_commision_by_year VALUES (315, 14, 2, 6, 9000, 1, '2023-02-11 10:50:30', '2023-02-11 10:50:30');
INSERT INTO public.product_commision_by_year VALUES (316, 14, 2, 8, 12000, 1, '2023-02-11 10:51:20', '2023-02-11 10:51:20');
INSERT INTO public.product_commision_by_year VALUES (316, 14, 2, 10, 13000, 1, '2023-02-11 10:52:06', '2023-02-11 10:52:06');
INSERT INTO public.product_commision_by_year VALUES (312, 14, 2, 10, 73000, 1, '2023-02-11 10:52:39', '2023-02-11 10:52:39');
INSERT INTO public.product_commision_by_year VALUES (317, 14, 2, 10, 10000, 1, '2023-02-11 10:53:40', '2023-02-11 10:53:40');
INSERT INTO public.product_commision_by_year VALUES (317, 14, 2, 9, 9000, 1, '2023-02-11 10:53:54', '2023-02-11 10:53:54');
INSERT INTO public.product_commision_by_year VALUES (317, 14, 2, 8, 9000, 1, '2023-02-11 10:54:05', '2023-02-11 10:54:05');
INSERT INTO public.product_commision_by_year VALUES (317, 14, 2, 7, 9000, 1, '2023-02-11 10:54:19', '2023-02-11 10:54:19');
INSERT INTO public.product_commision_by_year VALUES (309, 14, 2, 5, 12000, 1, '2023-02-11 10:55:04', '2023-02-11 10:55:04');
INSERT INTO public.product_commision_by_year VALUES (309, 14, 2, 8, 14000, 1, '2023-02-11 10:56:11', '2023-02-11 10:56:11');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 2, 2, 8000, 1, '2023-02-11 10:56:52', '2023-02-11 10:56:52');
INSERT INTO public.product_commision_by_year VALUES (310, 14, 2, 1, 8000, 1, '2023-02-11 10:57:58', '2023-02-11 10:57:58');
INSERT INTO public.product_commision_by_year VALUES (310, 14, 2, 3, 10000, 1, '2023-02-11 11:00:15', '2023-02-11 11:00:15');
INSERT INTO public.product_commision_by_year VALUES (310, 14, 2, 5, 12000, 1, '2023-02-11 11:00:52', '2023-02-11 11:00:52');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 2, 10, 8000, 1, '2023-02-11 11:01:23', '2023-02-11 11:01:23');
INSERT INTO public.product_commision_by_year VALUES (310, 14, 2, 8, 14000, 1, '2023-02-11 11:01:51', '2023-02-11 11:01:51');
INSERT INTO public.product_commision_by_year VALUES (280, 14, 2, 2, 32000, 1, '2023-02-11 09:25:32', '2023-02-11 09:25:32');
INSERT INTO public.product_commision_by_year VALUES (284, 14, 2, 2, 27000, 1, '2023-02-11 09:26:11', '2023-02-11 09:26:11');
INSERT INTO public.product_commision_by_year VALUES (284, 14, 2, 4, 31000, 1, '2023-02-11 09:27:45', '2023-02-11 09:27:45');
INSERT INTO public.product_commision_by_year VALUES (284, 14, 2, 7, 37000, 1, '2023-02-11 09:29:29', '2023-02-11 09:29:29');
INSERT INTO public.product_commision_by_year VALUES (284, 14, 2, 10, 43000, 1, '2023-02-11 09:30:48', '2023-02-11 09:30:48');
INSERT INTO public.product_commision_by_year VALUES (286, 14, 2, 3, 29000, 1, '2023-02-11 09:31:54', '2023-02-11 09:31:54');
INSERT INTO public.product_commision_by_year VALUES (286, 14, 2, 6, 35000, 1, '2023-02-11 09:32:50', '2023-02-11 09:32:50');
INSERT INTO public.product_commision_by_year VALUES (286, 14, 2, 9, 41000, 1, '2023-02-11 09:33:58', '2023-02-11 09:33:58');
INSERT INTO public.product_commision_by_year VALUES (288, 14, 2, 2, 27000, 1, '2023-02-11 09:35:10', '2023-02-11 09:35:10');
INSERT INTO public.product_commision_by_year VALUES (288, 14, 2, 5, 33000, 1, '2023-02-11 09:36:19', '2023-02-11 09:36:19');
INSERT INTO public.product_commision_by_year VALUES (288, 14, 2, 8, 39000, 1, '2023-02-11 09:37:22', '2023-02-11 09:37:22');
INSERT INTO public.product_commision_by_year VALUES (291, 14, 2, 1, 25000, 1, '2023-02-11 09:38:35', '2023-02-11 09:38:35');
INSERT INTO public.product_commision_by_year VALUES (291, 14, 2, 4, 31000, 1, '2023-02-11 09:39:48', '2023-02-11 09:39:48');
INSERT INTO public.product_commision_by_year VALUES (291, 14, 2, 5, 33000, 1, '2023-02-11 09:40:56', '2023-02-11 09:40:56');
INSERT INTO public.product_commision_by_year VALUES (291, 14, 2, 7, 37000, 1, '2023-02-11 09:41:44', '2023-02-11 09:41:44');
INSERT INTO public.product_commision_by_year VALUES (280, 14, 2, 10, 48000, 1, '2023-02-11 09:43:15', '2023-02-11 09:43:15');
INSERT INTO public.product_commision_by_year VALUES (291, 14, 2, 9, 39000, 1, '2023-02-11 09:44:27', '2023-02-11 09:44:27');
INSERT INTO public.product_commision_by_year VALUES (291, 14, 2, 10, 43000, 1, '2023-02-11 09:44:43', '2023-02-11 09:44:43');
INSERT INTO public.product_commision_by_year VALUES (282, 14, 2, 3, 34000, 1, '2023-02-11 09:45:24', '2023-02-11 09:45:24');
INSERT INTO public.product_commision_by_year VALUES (291, 14, 2, 8, 39000, 1, '2023-02-11 09:46:02', '2023-02-11 09:46:02');
INSERT INTO public.product_commision_by_year VALUES (282, 14, 2, 6, 40000, 1, '2023-02-11 09:46:41', '2023-02-11 09:46:41');
INSERT INTO public.product_commision_by_year VALUES (289, 14, 2, 3, 29000, 1, '2023-02-11 09:47:01', '2023-02-11 09:47:01');
INSERT INTO public.product_commision_by_year VALUES (289, 14, 2, 5, 33000, 1, '2023-02-11 09:47:43', '2023-02-11 09:47:43');
INSERT INTO public.product_commision_by_year VALUES (289, 14, 2, 6, 35000, 1, '2023-02-11 09:48:20', '2023-02-11 09:48:20');
INSERT INTO public.product_commision_by_year VALUES (283, 14, 2, 1, 30000, 1, '2023-02-11 09:50:16', '2023-02-11 09:50:16');
INSERT INTO public.product_commision_by_year VALUES (293, 14, 2, 3, 21000, 1, '2023-02-11 09:50:47', '2023-02-11 09:50:47');
INSERT INTO public.product_commision_by_year VALUES (293, 14, 2, 5, 25000, 1, '2023-02-11 09:51:26', '2023-02-11 09:51:26');
INSERT INTO public.product_commision_by_year VALUES (283, 14, 2, 5, 38000, 1, '2023-02-11 09:51:52', '2023-02-11 09:51:52');
INSERT INTO public.product_commision_by_year VALUES (289, 14, 2, 9, 41000, 1, '2023-02-11 09:52:21', '2023-02-11 09:52:21');
INSERT INTO public.product_commision_by_year VALUES (289, 14, 2, 10, 43000, 1, '2023-02-11 09:52:41', '2023-02-11 09:52:41');
INSERT INTO public.product_commision_by_year VALUES (283, 14, 2, 7, 42000, 1, '2023-02-11 09:53:10', '2023-02-11 09:53:10');
INSERT INTO public.product_commision_by_year VALUES (283, 14, 2, 9, 46000, 1, '2023-02-11 09:54:05', '2023-02-11 09:54:05');
INSERT INTO public.product_commision_by_year VALUES (294, 14, 2, 2, 19000, 1, '2023-02-11 09:54:31', '2023-02-11 09:54:31');
INSERT INTO public.product_commision_by_year VALUES (294, 14, 2, 5, 25000, 1, '2023-02-11 09:56:11', '2023-02-11 09:56:11');
INSERT INTO public.product_commision_by_year VALUES (294, 14, 2, 6, 27000, 1, '2023-02-11 09:56:29', '2023-02-11 09:56:29');
INSERT INTO public.product_commision_by_year VALUES (294, 14, 2, 7, 29000, 1, '2023-02-11 09:56:46', '2023-02-11 09:56:46');
INSERT INTO public.product_commision_by_year VALUES (285, 14, 2, 7, 27000, 1, '2023-02-11 09:57:52', '2023-02-11 09:57:52');
INSERT INTO public.product_commision_by_year VALUES (285, 14, 2, 10, 33000, 1, '2023-02-11 09:58:59', '2023-02-11 09:58:59');
INSERT INTO public.product_commision_by_year VALUES (295, 14, 2, 4, 23000, 1, '2023-02-11 09:59:54', '2023-02-11 09:59:54');
INSERT INTO public.product_commision_by_year VALUES (308, 14, 2, 8, 21000, 1, '2023-02-11 10:46:13', '2023-02-11 10:46:13');
INSERT INTO public.product_commision_by_year VALUES (308, 14, 2, 9, 22000, 1, '2023-02-11 10:46:41', '2023-02-11 10:46:41');
INSERT INTO public.product_commision_by_year VALUES (308, 14, 2, 10, 23000, 1, '2023-02-11 10:46:58', '2023-02-11 10:46:58');
INSERT INTO public.product_commision_by_year VALUES (306, 14, 2, 10, 38000, 1, '2023-02-11 10:47:13', '2023-02-11 10:47:13');
INSERT INTO public.product_commision_by_year VALUES (287, 14, 2, 1, 8000, 1, '2023-02-11 10:01:58', '2023-02-11 10:01:58');
INSERT INTO public.product_commision_by_year VALUES (287, 14, 2, 3, 8000, 1, '2023-02-11 10:02:38', '2023-02-11 10:02:38');
INSERT INTO public.product_commision_by_year VALUES (295, 14, 2, 9, 33000, 1, '2023-02-11 10:03:46', '2023-02-11 10:03:46');
INSERT INTO public.product_commision_by_year VALUES (295, 14, 2, 10, 35000, 1, '2023-02-11 10:04:38', '2023-02-11 10:04:38');
INSERT INTO public.product_commision_by_year VALUES (287, 14, 2, 9, 10000, 1, '2023-02-11 10:06:29', '2023-02-11 10:06:29');
INSERT INTO public.product_commision_by_year VALUES (292, 14, 2, 1, 40000, 1, '2023-02-11 10:08:17', '2023-02-11 10:08:17');
INSERT INTO public.product_commision_by_year VALUES (292, 14, 2, 2, 42000, 1, '2023-02-11 10:09:03', '2023-02-11 10:09:03');
INSERT INTO public.product_commision_by_year VALUES (292, 14, 2, 6, 50000, 1, '2023-02-11 10:10:01', '2023-02-11 10:10:01');
INSERT INTO public.product_commision_by_year VALUES (312, 14, 2, 2, 57000, 1, '2023-02-11 10:48:15', '2023-02-11 10:48:15');
INSERT INTO public.product_commision_by_year VALUES (296, 14, 2, 1, 20000, 1, '2023-02-11 10:12:43', '2023-02-11 10:12:43');
INSERT INTO public.product_commision_by_year VALUES (296, 14, 2, 4, 26000, 1, '2023-02-11 10:13:42', '2023-02-11 10:13:42');
INSERT INTO public.product_commision_by_year VALUES (290, 14, 2, 1, 8000, 1, '2023-02-11 10:14:28', '2023-02-11 10:14:28');
INSERT INTO public.product_commision_by_year VALUES (281, 14, 2, 3, 29000, 1, '2023-02-11 10:14:48', '2023-02-11 10:14:48');
INSERT INTO public.product_commision_by_year VALUES (290, 14, 2, 3, 8000, 1, '2023-02-11 10:15:12', '2023-02-11 10:15:12');
INSERT INTO public.product_commision_by_year VALUES (281, 14, 2, 5, 33000, 1, '2023-02-11 10:15:34', '2023-02-11 10:15:34');
INSERT INTO public.product_commision_by_year VALUES (296, 14, 2, 9, 32000, 1, '2023-02-11 10:16:15', '2023-02-11 10:16:15');
INSERT INTO public.product_commision_by_year VALUES (290, 14, 2, 5, 8000, 1, '2023-02-11 10:17:22', '2023-02-11 10:17:22');
INSERT INTO public.product_commision_by_year VALUES (290, 14, 2, 6, 8000, 1, '2023-02-11 10:17:54', '2023-02-11 10:17:54');
INSERT INTO public.product_commision_by_year VALUES (297, 14, 2, 4, 12000, 1, '2023-02-11 10:18:26', '2023-02-11 10:18:26');
INSERT INTO public.product_commision_by_year VALUES (290, 14, 2, 9, 8000, 1, '2023-02-11 10:18:59', '2023-02-11 10:18:59');
INSERT INTO public.product_commision_by_year VALUES (290, 14, 2, 10, 8000, 1, '2023-02-11 10:19:17', '2023-02-11 10:19:17');
INSERT INTO public.product_commision_by_year VALUES (299, 14, 2, 4, 9000, 1, '2023-02-11 10:19:43', '2023-02-11 10:19:43');
INSERT INTO public.product_commision_by_year VALUES (297, 14, 2, 8, 16000, 1, '2023-02-11 10:20:25', '2023-02-11 10:20:25');
INSERT INTO public.product_commision_by_year VALUES (297, 14, 2, 10, 18000, 1, '2023-02-11 10:21:01', '2023-02-11 10:21:01');
INSERT INTO public.product_commision_by_year VALUES (299, 14, 2, 9, 12000, 1, '2023-02-11 10:22:11', '2023-02-11 10:22:11');
INSERT INTO public.product_commision_by_year VALUES (298, 14, 2, 6, 14000, 1, '2023-02-11 10:23:58', '2023-02-11 10:23:58');
INSERT INTO public.product_commision_by_year VALUES (298, 14, 2, 8, 16000, 1, '2023-02-11 10:26:21', '2023-02-11 10:26:21');
INSERT INTO public.product_commision_by_year VALUES (301, 14, 2, 1, 44000, 1, '2023-02-11 10:28:24', '2023-02-11 10:28:24');
INSERT INTO public.product_commision_by_year VALUES (301, 14, 2, 4, 50000, 1, '2023-02-11 10:29:56', '2023-02-11 10:29:56');
INSERT INTO public.product_commision_by_year VALUES (302, 14, 2, 2, 32000, 1, '2023-02-11 10:30:19', '2023-02-11 10:30:19');
INSERT INTO public.product_commision_by_year VALUES (301, 14, 2, 6, 54000, 1, '2023-02-11 10:30:43', '2023-02-11 10:30:43');
INSERT INTO public.product_commision_by_year VALUES (300, 14, 2, 3, 54000, 1, '2023-02-11 10:31:03', '2023-02-11 10:31:03');
INSERT INTO public.product_commision_by_year VALUES (301, 14, 2, 8, 58000, 1, '2023-02-11 10:31:33', '2023-02-11 10:31:33');
INSERT INTO public.product_commision_by_year VALUES (301, 14, 2, 9, 60000, 1, '2023-02-11 10:31:58', '2023-02-11 10:31:58');
INSERT INTO public.product_commision_by_year VALUES (302, 14, 2, 7, 40000, 1, '2023-02-11 10:32:37', '2023-02-11 10:32:37');
INSERT INTO public.product_commision_by_year VALUES (300, 14, 2, 7, 62000, 1, '2023-02-11 10:33:01', '2023-02-11 10:33:01');
INSERT INTO public.product_commision_by_year VALUES (302, 14, 2, 10, 43000, 1, '2023-02-11 10:33:23', '2023-02-11 10:33:23');
INSERT INTO public.product_commision_by_year VALUES (305, 14, 2, 1, 22000, 1, '2023-02-11 10:34:12', '2023-02-11 10:34:12');
INSERT INTO public.product_commision_by_year VALUES (305, 14, 2, 3, 26000, 1, '2023-02-11 10:34:49', '2023-02-11 10:34:49');
INSERT INTO public.product_commision_by_year VALUES (305, 14, 2, 6, 29000, 1, '2023-02-11 10:36:23', '2023-02-11 10:36:23');
INSERT INTO public.product_commision_by_year VALUES (305, 14, 2, 7, 31000, 1, '2023-02-11 10:39:08', '2023-02-11 10:39:08');
INSERT INTO public.product_commision_by_year VALUES (305, 14, 2, 8, 32000, 1, '2023-02-11 10:39:36', '2023-02-11 10:39:36');
INSERT INTO public.product_commision_by_year VALUES (307, 14, 2, 1, 15000, 1, '2023-02-11 10:40:17', '2023-02-11 10:40:17');
INSERT INTO public.product_commision_by_year VALUES (307, 14, 2, 2, 17000, 1, '2023-02-11 10:40:36', '2023-02-11 10:40:36');
INSERT INTO public.product_commision_by_year VALUES (307, 14, 2, 3, 19000, 1, '2023-02-11 10:40:55', '2023-02-11 10:40:55');
INSERT INTO public.product_commision_by_year VALUES (304, 14, 2, 8, 36000, 1, '2023-02-11 10:41:26', '2023-02-11 10:41:26');
INSERT INTO public.product_commision_by_year VALUES (308, 14, 2, 1, 10000, 1, '2023-02-11 10:41:46', '2023-02-11 10:41:46');
INSERT INTO public.product_commision_by_year VALUES (304, 14, 2, 10, 38000, 1, '2023-02-11 10:42:05', '2023-02-11 10:42:05');
INSERT INTO public.product_commision_by_year VALUES (308, 14, 2, 4, 16000, 1, '2023-02-11 10:42:51', '2023-02-11 10:42:51');
INSERT INTO public.product_commision_by_year VALUES (307, 14, 2, 8, 29000, 1, '2023-02-11 10:43:24', '2023-02-11 10:43:24');
INSERT INTO public.product_commision_by_year VALUES (307, 14, 2, 10, 33000, 1, '2023-02-11 10:44:12', '2023-02-11 10:44:12');
INSERT INTO public.product_commision_by_year VALUES (306, 14, 2, 3, 24000, 1, '2023-02-11 10:44:57', '2023-02-11 10:44:57');
INSERT INTO public.product_commision_by_year VALUES (306, 14, 2, 5, 28000, 1, '2023-02-11 10:45:28', '2023-02-11 10:45:28');
INSERT INTO public.product_commision_by_year VALUES (315, 14, 2, 2, 8000, 1, '2023-02-11 10:48:35', '2023-02-11 10:48:35');
INSERT INTO public.product_commision_by_year VALUES (315, 14, 2, 3, 8000, 1, '2023-02-11 10:48:51', '2023-02-11 10:48:51');
INSERT INTO public.product_commision_by_year VALUES (312, 14, 2, 4, 61000, 1, '2023-02-11 10:49:13', '2023-02-11 10:49:13');
INSERT INTO public.product_commision_by_year VALUES (312, 14, 2, 5, 63000, 1, '2023-02-11 10:49:41', '2023-02-11 10:49:41');
INSERT INTO public.product_commision_by_year VALUES (312, 14, 2, 6, 65000, 1, '2023-02-11 10:50:06', '2023-02-11 10:50:06');
INSERT INTO public.product_commision_by_year VALUES (315, 14, 2, 7, 10000, 1, '2023-02-11 10:50:45', '2023-02-11 10:50:45');
INSERT INTO public.product_commision_by_year VALUES (315, 14, 2, 8, 10000, 1, '2023-02-11 10:51:12', '2023-02-11 10:51:12');
INSERT INTO public.product_commision_by_year VALUES (312, 14, 2, 7, 67000, 1, '2023-02-11 10:51:22', '2023-02-11 10:51:22');
INSERT INTO public.product_commision_by_year VALUES (316, 14, 2, 9, 12000, 1, '2023-02-11 10:51:51', '2023-02-11 10:51:51');
INSERT INTO public.product_commision_by_year VALUES (312, 14, 2, 9, 71000, 1, '2023-02-11 10:52:15', '2023-02-11 10:52:15');
INSERT INTO public.product_commision_by_year VALUES (317, 14, 2, 2, 7000, 1, '2023-02-11 10:52:53', '2023-02-11 10:52:53');
INSERT INTO public.product_commision_by_year VALUES (317, 14, 2, 3, 7000, 1, '2023-02-11 10:53:41', '2023-02-11 10:53:41');
INSERT INTO public.product_commision_by_year VALUES (317, 14, 2, 4, 8000, 1, '2023-02-11 10:53:58', '2023-02-11 10:53:58');
INSERT INTO public.product_commision_by_year VALUES (317, 14, 2, 5, 8000, 1, '2023-02-11 10:54:16', '2023-02-11 10:54:16');
INSERT INTO public.product_commision_by_year VALUES (317, 14, 2, 6, 8000, 1, '2023-02-11 10:54:31', '2023-02-11 10:54:31');
INSERT INTO public.product_commision_by_year VALUES (309, 14, 2, 6, 12000, 1, '2023-02-11 10:55:23', '2023-02-11 10:55:23');
INSERT INTO public.product_commision_by_year VALUES (309, 14, 2, 9, 16000, 1, '2023-02-11 10:56:30', '2023-02-11 10:56:30');
INSERT INTO public.product_commision_by_year VALUES (309, 14, 2, 10, 16000, 1, '2023-02-11 10:56:56', '2023-02-11 10:56:56');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 2, 7, 8000, 1, '2023-02-11 10:58:56', '2023-02-11 10:58:56');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 2, 8, 8000, 1, '2023-02-11 10:59:55', '2023-02-11 10:59:55');
INSERT INTO public.product_commision_by_year VALUES (310, 14, 2, 4, 10000, 1, '2023-02-11 11:00:33', '2023-02-11 11:00:33');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 2, 9, 8000, 1, '2023-02-11 11:00:53', '2023-02-11 11:00:53');
INSERT INTO public.product_commision_by_year VALUES (284, 14, 2, 1, 25000, 1, '2023-02-11 09:25:36', '2023-02-11 09:25:36');
INSERT INTO public.product_commision_by_year VALUES (280, 14, 2, 4, 36000, 1, '2023-02-11 09:26:30', '2023-02-11 09:26:30');
INSERT INTO public.product_commision_by_year VALUES (284, 14, 2, 5, 33000, 1, '2023-02-11 09:28:05', '2023-02-11 09:28:05');
INSERT INTO public.product_commision_by_year VALUES (284, 14, 2, 8, 39000, 1, '2023-02-11 09:30:01', '2023-02-11 09:30:01');
INSERT INTO public.product_commision_by_year VALUES (286, 14, 2, 1, 25000, 1, '2023-02-11 09:31:14', '2023-02-11 09:31:14');
INSERT INTO public.product_commision_by_year VALUES (286, 14, 2, 4, 31000, 1, '2023-02-11 09:32:16', '2023-02-11 09:32:16');
INSERT INTO public.product_commision_by_year VALUES (286, 14, 2, 7, 37000, 1, '2023-02-11 09:33:12', '2023-02-11 09:33:12');
INSERT INTO public.product_commision_by_year VALUES (286, 14, 2, 10, 43000, 1, '2023-02-11 09:34:14', '2023-02-11 09:34:14');
INSERT INTO public.product_commision_by_year VALUES (288, 14, 2, 3, 29000, 1, '2023-02-11 09:35:36', '2023-02-11 09:35:36');
INSERT INTO public.product_commision_by_year VALUES (288, 14, 2, 6, 35000, 1, '2023-02-11 09:36:38', '2023-02-11 09:36:38');
INSERT INTO public.product_commision_by_year VALUES (288, 14, 2, 9, 41000, 1, '2023-02-11 09:37:39', '2023-02-11 09:37:39');
INSERT INTO public.product_commision_by_year VALUES (291, 14, 2, 2, 27000, 1, '2023-02-11 09:38:58', '2023-02-11 09:38:58');
INSERT INTO public.product_commision_by_year VALUES (280, 14, 2, 5, 38000, 1, '2023-02-11 09:40:02', '2023-02-11 09:40:02');
INSERT INTO public.product_commision_by_year VALUES (280, 14, 2, 7, 42000, 1, '2023-02-11 09:41:04', '2023-02-11 09:41:04');
INSERT INTO public.product_commision_by_year VALUES (280, 14, 2, 9, 46000, 1, '2023-02-11 09:41:47', '2023-02-11 09:41:47');
INSERT INTO public.product_commision_by_year VALUES (282, 14, 2, 2, 32000, 1, '2023-02-11 09:45:02', '2023-02-11 09:45:02');
INSERT INTO public.product_commision_by_year VALUES (282, 14, 2, 5, 38000, 1, '2023-02-11 09:46:12', '2023-02-11 09:46:12');
INSERT INTO public.product_commision_by_year VALUES (289, 14, 2, 2, 27000, 1, '2023-02-11 09:46:46', '2023-02-11 09:46:46');
INSERT INTO public.product_commision_by_year VALUES (282, 14, 2, 8, 44000, 1, '2023-02-11 09:47:17', '2023-02-11 09:47:17');
INSERT INTO public.product_commision_by_year VALUES (302, 14, 2, 9, 42000, 1, '2023-02-11 10:33:07', '2023-02-11 10:33:07');
INSERT INTO public.product_commision_by_year VALUES (300, 14, 2, 9, 66000, 1, '2023-02-11 10:33:41', '2023-02-11 10:33:41');
INSERT INTO public.product_commision_by_year VALUES (282, 14, 2, 9, 46000, 1, '2023-02-11 09:47:49', '2023-02-11 09:47:49');
INSERT INTO public.product_commision_by_year VALUES (289, 14, 2, 7, 37000, 1, '2023-02-11 09:48:51', '2023-02-11 09:48:51');
INSERT INTO public.product_commision_by_year VALUES (293, 14, 2, 2, 19000, 1, '2023-02-11 09:50:32', '2023-02-11 09:50:32');
INSERT INTO public.product_commision_by_year VALUES (283, 14, 2, 3, 34000, 1, '2023-02-11 09:50:58', '2023-02-11 09:50:58');
INSERT INTO public.product_commision_by_year VALUES (283, 14, 2, 4, 36000, 1, '2023-02-11 09:51:33', '2023-02-11 09:51:33');
INSERT INTO public.product_commision_by_year VALUES (289, 14, 2, 8, 39000, 1, '2023-02-11 09:52:04', '2023-02-11 09:52:04');
INSERT INTO public.product_commision_by_year VALUES (283, 14, 2, 6, 40000, 1, '2023-02-11 09:52:50', '2023-02-11 09:52:50');
INSERT INTO public.product_commision_by_year VALUES (293, 14, 2, 10, 35000, 1, '2023-02-11 09:53:16', '2023-02-11 09:53:16');
INSERT INTO public.product_commision_by_year VALUES (294, 14, 2, 1, 17000, 1, '2023-02-11 09:54:06', '2023-02-11 09:54:06');
INSERT INTO public.product_commision_by_year VALUES (294, 14, 2, 3, 21000, 1, '2023-02-11 09:54:53', '2023-02-11 09:54:53');
INSERT INTO public.product_commision_by_year VALUES (285, 14, 2, 1, 15000, 1, '2023-02-11 09:55:44', '2023-02-11 09:55:44');
INSERT INTO public.product_commision_by_year VALUES (285, 14, 2, 4, 21000, 1, '2023-02-11 09:56:42', '2023-02-11 09:56:42');
INSERT INTO public.product_commision_by_year VALUES (285, 14, 2, 5, 23000, 1, '2023-02-11 09:56:59', '2023-02-11 09:56:59');
INSERT INTO public.product_commision_by_year VALUES (285, 14, 2, 6, 25000, 1, '2023-02-11 09:57:19', '2023-02-11 09:57:19');
INSERT INTO public.product_commision_by_year VALUES (285, 14, 2, 9, 31000, 1, '2023-02-11 09:58:36', '2023-02-11 09:58:36');
INSERT INTO public.product_commision_by_year VALUES (295, 14, 2, 3, 21000, 1, '2023-02-11 09:59:31', '2023-02-11 09:59:31');
INSERT INTO public.product_commision_by_year VALUES (305, 14, 2, 5, 29000, 1, '2023-02-11 10:38:16', '2023-02-11 10:38:16');
INSERT INTO public.product_commision_by_year VALUES (304, 14, 2, 2, 27000, 1, '2023-02-11 10:39:39', '2023-02-11 10:39:39');
INSERT INTO public.product_commision_by_year VALUES (295, 14, 2, 5, 25000, 1, '2023-02-11 10:00:26', '2023-02-11 10:00:26');
INSERT INTO public.product_commision_by_year VALUES (295, 14, 2, 7, 29000, 1, '2023-02-11 10:02:04', '2023-02-11 10:02:04');
INSERT INTO public.product_commision_by_year VALUES (287, 14, 2, 4, 9000, 1, '2023-02-11 10:03:18', '2023-02-11 10:03:18');
INSERT INTO public.product_commision_by_year VALUES (287, 14, 2, 5, 9000, 1, '2023-02-11 10:04:08', '2023-02-11 10:04:08');
INSERT INTO public.product_commision_by_year VALUES (287, 14, 2, 7, 10000, 1, '2023-02-11 10:04:45', '2023-02-11 10:04:45');
INSERT INTO public.product_commision_by_year VALUES (287, 14, 2, 10, 11000, 1, '2023-02-11 10:07:14', '2023-02-11 10:07:14');
INSERT INTO public.product_commision_by_year VALUES (292, 14, 2, 4, 46000, 1, '2023-02-11 10:09:20', '2023-02-11 10:09:20');
INSERT INTO public.product_commision_by_year VALUES (305, 14, 2, 9, 33000, 1, '2023-02-11 10:40:19', '2023-02-11 10:40:19');
INSERT INTO public.product_commision_by_year VALUES (292, 14, 2, 7, 52000, 1, '2023-02-11 10:10:19', '2023-02-11 10:10:19');
INSERT INTO public.product_commision_by_year VALUES (292, 14, 2, 10, 58000, 1, '2023-02-11 10:11:05', '2023-02-11 10:11:05');
INSERT INTO public.product_commision_by_year VALUES (304, 14, 2, 5, 33000, 1, '2023-02-11 10:40:38', '2023-02-11 10:40:38');
INSERT INTO public.product_commision_by_year VALUES (296, 14, 2, 2, 22000, 1, '2023-02-11 10:13:03', '2023-02-11 10:13:03');
INSERT INTO public.product_commision_by_year VALUES (281, 14, 2, 1, 25000, 1, '2023-02-11 10:14:13', '2023-02-11 10:14:13');
INSERT INTO public.product_commision_by_year VALUES (281, 14, 2, 2, 27000, 1, '2023-02-11 10:14:32', '2023-02-11 10:14:32');
INSERT INTO public.product_commision_by_year VALUES (290, 14, 2, 2, 8000, 1, '2023-02-11 10:14:56', '2023-02-11 10:14:56');
INSERT INTO public.product_commision_by_year VALUES (296, 14, 2, 7, 30000, 1, '2023-02-11 10:15:29', '2023-02-11 10:15:29');
INSERT INTO public.product_commision_by_year VALUES (296, 14, 2, 8, 31000, 1, '2023-02-11 10:15:56', '2023-02-11 10:15:56');
INSERT INTO public.product_commision_by_year VALUES (296, 14, 2, 10, 33000, 1, '2023-02-11 10:16:32', '2023-02-11 10:16:32');
INSERT INTO public.product_commision_by_year VALUES (281, 14, 2, 8, 36000, 1, '2023-02-11 10:17:01', '2023-02-11 10:17:01');
INSERT INTO public.product_commision_by_year VALUES (297, 14, 2, 1, 10000, 1, '2023-02-11 10:17:26', '2023-02-11 10:17:26');
INSERT INTO public.product_commision_by_year VALUES (297, 14, 2, 2, 10000, 1, '2023-02-11 10:17:44', '2023-02-11 10:17:44');
INSERT INTO public.product_commision_by_year VALUES (297, 14, 2, 3, 12000, 1, '2023-02-11 10:18:01', '2023-02-11 10:18:01');
INSERT INTO public.product_commision_by_year VALUES (290, 14, 2, 8, 8000, 1, '2023-02-11 10:18:41', '2023-02-11 10:18:41');
INSERT INTO public.product_commision_by_year VALUES (299, 14, 2, 2, 8000, 1, '2023-02-11 10:19:00', '2023-02-11 10:19:00');
INSERT INTO public.product_commision_by_year VALUES (297, 14, 2, 5, 14000, 1, '2023-02-11 10:19:18', '2023-02-11 10:19:18');
INSERT INTO public.product_commision_by_year VALUES (299, 14, 2, 5, 10000, 1, '2023-02-11 10:20:01', '2023-02-11 10:20:01');
INSERT INTO public.product_commision_by_year VALUES (299, 14, 2, 6, 10000, 1, '2023-02-11 10:20:37', '2023-02-11 10:20:37');
INSERT INTO public.product_commision_by_year VALUES (299, 14, 2, 7, 11000, 1, '2023-02-11 10:21:21', '2023-02-11 10:21:21');
INSERT INTO public.product_commision_by_year VALUES (298, 14, 2, 1, 10000, 1, '2023-02-11 10:22:26', '2023-02-11 10:22:26');
INSERT INTO public.product_commision_by_year VALUES (299, 14, 2, 10, 12000, 1, '2023-02-11 10:22:47', '2023-02-11 10:22:47');
INSERT INTO public.product_commision_by_year VALUES (298, 14, 2, 4, 12000, 1, '2023-02-11 10:23:07', '2023-02-11 10:23:07');
INSERT INTO public.product_commision_by_year VALUES (298, 14, 2, 7, 16000, 1, '2023-02-11 10:24:40', '2023-02-11 10:24:40');
INSERT INTO public.product_commision_by_year VALUES (298, 14, 2, 9, 18000, 1, '2023-02-11 10:26:37', '2023-02-11 10:26:37');
INSERT INTO public.product_commision_by_year VALUES (301, 14, 2, 2, 46000, 1, '2023-02-11 10:28:59', '2023-02-11 10:28:59');
INSERT INTO public.product_commision_by_year VALUES (302, 14, 2, 1, 30000, 1, '2023-02-11 10:30:02', '2023-02-11 10:30:02');
INSERT INTO public.product_commision_by_year VALUES (300, 14, 2, 1, 50000, 1, '2023-02-11 10:30:22', '2023-02-11 10:30:22');
INSERT INTO public.product_commision_by_year VALUES (300, 14, 2, 2, 52000, 1, '2023-02-11 10:30:45', '2023-02-11 10:30:45');
INSERT INTO public.product_commision_by_year VALUES (301, 14, 2, 7, 56000, 1, '2023-02-11 10:31:13', '2023-02-11 10:31:13');
INSERT INTO public.product_commision_by_year VALUES (300, 14, 2, 4, 56000, 1, '2023-02-11 10:31:34', '2023-02-11 10:31:34');
INSERT INTO public.product_commision_by_year VALUES (300, 14, 2, 6, 60000, 1, '2023-02-11 10:32:43', '2023-02-11 10:32:43');
INSERT INTO public.product_commision_by_year VALUES (305, 14, 2, 10, 35000, 1, '2023-02-11 10:40:59', '2023-02-11 10:40:59');
INSERT INTO public.product_commision_by_year VALUES (307, 14, 2, 4, 21000, 1, '2023-02-11 10:41:42', '2023-02-11 10:41:42');
INSERT INTO public.product_commision_by_year VALUES (308, 14, 2, 2, 10000, 1, '2023-02-11 10:42:04', '2023-02-11 10:42:04');
INSERT INTO public.product_commision_by_year VALUES (308, 14, 2, 3, 14000, 1, '2023-02-11 10:42:31', '2023-02-11 10:42:31');
INSERT INTO public.product_commision_by_year VALUES (307, 14, 2, 7, 27000, 1, '2023-02-11 10:43:06', '2023-02-11 10:43:06');
INSERT INTO public.product_commision_by_year VALUES (308, 14, 2, 5, 18000, 1, '2023-02-11 10:43:34', '2023-02-11 10:43:34');
INSERT INTO public.product_commision_by_year VALUES (306, 14, 2, 1, 20000, 1, '2023-02-11 10:44:20', '2023-02-11 10:44:20');
INSERT INTO public.product_commision_by_year VALUES (306, 14, 2, 4, 26000, 1, '2023-02-11 10:45:13', '2023-02-11 10:45:13');
INSERT INTO public.product_commision_by_year VALUES (306, 14, 2, 6, 30000, 1, '2023-02-11 10:45:42', '2023-02-11 10:45:42');
INSERT INTO public.product_commision_by_year VALUES (306, 14, 2, 7, 32000, 1, '2023-02-11 10:46:20', '2023-02-11 10:46:20');
INSERT INTO public.product_commision_by_year VALUES (306, 14, 2, 9, 36000, 1, '2023-02-11 10:46:59', '2023-02-11 10:46:59');
INSERT INTO public.product_commision_by_year VALUES (315, 14, 2, 1, 8000, 1, '2023-02-11 10:48:20', '2023-02-11 10:48:20');
INSERT INTO public.product_commision_by_year VALUES (312, 14, 2, 3, 59000, 1, '2023-02-11 10:48:37', '2023-02-11 10:48:37');
INSERT INTO public.product_commision_by_year VALUES (316, 14, 2, 2, 10000, 1, '2023-02-11 10:48:59', '2023-02-11 10:48:59');
INSERT INTO public.product_commision_by_year VALUES (316, 14, 2, 4, 11000, 1, '2023-02-11 10:49:36', '2023-02-11 10:49:36');
INSERT INTO public.product_commision_by_year VALUES (315, 14, 2, 5, 9000, 1, '2023-02-11 10:50:06', '2023-02-11 10:50:06');
INSERT INTO public.product_commision_by_year VALUES (316, 14, 2, 6, 11000, 1, '2023-02-11 10:50:30', '2023-02-11 10:50:30');
INSERT INTO public.product_commision_by_year VALUES (316, 14, 2, 7, 12000, 1, '2023-02-11 10:50:45', '2023-02-11 10:50:45');
INSERT INTO public.product_commision_by_year VALUES (315, 14, 2, 9, 10000, 1, '2023-02-11 10:51:34', '2023-02-11 10:51:34');
INSERT INTO public.product_commision_by_year VALUES (312, 14, 2, 8, 69000, 1, '2023-02-11 10:51:51', '2023-02-11 10:51:51');
INSERT INTO public.product_commision_by_year VALUES (317, 14, 2, 1, 7000, 1, '2023-02-11 10:52:35', '2023-02-11 10:52:35');
INSERT INTO public.product_commision_by_year VALUES (315, 14, 2, 10, 11000, 1, '2023-02-11 10:53:16', '2023-02-11 10:53:16');
INSERT INTO public.product_commision_by_year VALUES (309, 14, 2, 1, 8000, 1, '2023-02-11 10:53:42', '2023-02-11 10:53:42');
INSERT INTO public.product_commision_by_year VALUES (309, 14, 2, 2, 8000, 1, '2023-02-11 10:53:59', '2023-02-11 10:53:59');
INSERT INTO public.product_commision_by_year VALUES (309, 14, 2, 3, 10000, 1, '2023-02-11 10:54:17', '2023-02-11 10:54:17');
INSERT INTO public.product_commision_by_year VALUES (309, 14, 2, 4, 10000, 1, '2023-02-11 10:54:40', '2023-02-11 10:54:40');
INSERT INTO public.product_commision_by_year VALUES (309, 14, 2, 7, 14000, 1, '2023-02-11 10:55:49', '2023-02-11 10:55:49');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 2, 1, 8000, 1, '2023-02-11 10:56:31', '2023-02-11 10:56:31');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 2, 4, 8000, 1, '2023-02-11 10:57:48', '2023-02-11 10:57:48');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 2, 3, 8000, 1, '2023-02-11 10:58:11', '2023-02-11 10:58:11');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 2, 5, 8000, 1, '2023-02-11 10:59:25', '2023-02-11 10:59:25');
INSERT INTO public.product_commision_by_year VALUES (310, 14, 2, 2, 8000, 1, '2023-02-11 10:59:55', '2023-02-11 10:59:55');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 2, 6, 8000, 1, '2023-02-11 11:00:37', '2023-02-11 11:00:37');
INSERT INTO public.product_commision_by_year VALUES (310, 14, 2, 6, 12000, 1, '2023-02-11 11:01:11', '2023-02-11 11:01:11');
INSERT INTO public.product_commision_by_year VALUES (310, 14, 2, 7, 14000, 1, '2023-02-11 11:01:33', '2023-02-11 11:01:33');
INSERT INTO public.product_commision_by_year VALUES (310, 14, 2, 9, 16000, 1, '2023-02-11 11:02:12', '2023-02-11 11:02:12');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 1, 1, 2000, 1, '2023-02-11 11:02:28', '2023-02-11 11:02:28');
INSERT INTO public.product_commision_by_year VALUES (310, 14, 2, 10, 16000, 1, '2023-02-11 11:02:32', '2023-02-11 11:02:32');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 1, 2, 2000, 1, '2023-02-11 11:02:44', '2023-02-11 11:02:44');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 1, 3, 2000, 1, '2023-02-11 11:02:59', '2023-02-11 11:02:59');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 1, 4, 2000, 1, '2023-02-11 11:03:36', '2023-02-11 11:03:36');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 1, 5, 2000, 1, '2023-02-11 11:04:26', '2023-02-11 11:04:26');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 1, 6, 2000, 1, '2023-02-11 11:04:44', '2023-02-11 11:04:44');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 1, 7, 2000, 1, '2023-02-11 11:05:02', '2023-02-11 11:05:02');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 1, 8, 2000, 1, '2023-02-11 11:05:18', '2023-02-11 11:05:18');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 1, 9, 2000, 1, '2023-02-11 11:05:37', '2023-02-11 11:05:37');
INSERT INTO public.product_commision_by_year VALUES (318, 14, 1, 10, 2000, 1, '2023-02-11 11:05:52', '2023-02-11 11:05:52');
INSERT INTO public.product_commision_by_year VALUES (313, 14, 2, 1, 8000, 1, '2023-02-11 11:05:57', '2023-02-11 11:05:57');
INSERT INTO public.product_commision_by_year VALUES (313, 14, 2, 2, 8000, 1, '2023-02-11 11:06:16', '2023-02-11 11:06:16');
INSERT INTO public.product_commision_by_year VALUES (313, 14, 2, 3, 10000, 1, '2023-02-11 11:07:03', '2023-02-11 11:07:03');
INSERT INTO public.product_commision_by_year VALUES (313, 14, 2, 4, 10000, 1, '2023-02-11 11:07:32', '2023-02-11 11:07:32');
INSERT INTO public.product_commision_by_year VALUES (313, 14, 2, 5, 12000, 1, '2023-02-11 11:07:53', '2023-02-11 11:07:53');
INSERT INTO public.product_commision_by_year VALUES (313, 14, 2, 6, 12000, 1, '2023-02-11 11:08:22', '2023-02-11 11:08:22');
INSERT INTO public.product_commision_by_year VALUES (313, 14, 2, 7, 14000, 1, '2023-02-11 11:08:59', '2023-02-11 11:08:59');
INSERT INTO public.product_commision_by_year VALUES (313, 14, 2, 9, 16000, 1, '2023-02-11 11:10:04', '2023-02-11 11:10:04');
INSERT INTO public.product_commision_by_year VALUES (313, 14, 2, 10, 16000, 1, '2023-02-11 11:10:21', '2023-02-11 11:10:21');
INSERT INTO public.product_commision_by_year VALUES (313, 14, 2, 8, 14000, 1, '2023-02-11 11:11:33', '2023-02-11 11:11:33');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 1, 1, 5000, 1, '2023-02-11 11:15:28', '2023-02-11 11:15:28');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 1, 2, 5000, 1, '2023-02-11 11:15:43', '2023-02-11 11:15:43');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 1, 3, 5000, 1, '2023-02-11 11:16:10', '2023-02-11 11:16:10');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 1, 4, 5000, 1, '2023-02-11 11:16:28', '2023-02-11 11:16:28');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 1, 5, 5000, 1, '2023-02-11 11:17:09', '2023-02-11 11:17:09');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 1, 6, 5000, 1, '2023-02-11 11:17:29', '2023-02-11 11:17:29');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 1, 7, 5000, 1, '2023-02-11 11:17:44', '2023-02-11 11:17:44');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 1, 8, 5000, 1, '2023-02-11 11:18:12', '2023-02-11 11:18:12');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 1, 9, 5000, 1, '2023-02-11 11:18:28', '2023-02-11 11:18:28');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 1, 10, 5000, 1, '2023-02-11 11:19:07', '2023-02-11 11:19:07');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 2, 1, 15000, 1, '2023-02-11 11:19:35', '2023-02-11 11:19:35');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 2, 2, 15000, 1, '2023-02-11 11:19:50', '2023-02-11 11:19:50');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 2, 3, 15000, 1, '2023-02-11 11:20:06', '2023-02-11 11:20:06');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 2, 4, 15000, 1, '2023-02-11 11:20:21', '2023-02-11 11:20:21');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 2, 5, 15000, 1, '2023-02-11 11:20:36', '2023-02-11 11:20:36');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 2, 6, 15000, 1, '2023-02-11 11:20:54', '2023-02-11 11:20:54');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 2, 7, 15000, 1, '2023-02-11 11:21:10', '2023-02-11 11:21:10');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 2, 8, 15000, 1, '2023-02-11 11:21:43', '2023-02-11 11:21:43');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 2, 9, 15000, 1, '2023-02-11 11:22:02', '2023-02-11 11:22:02');
INSERT INTO public.product_commision_by_year VALUES (319, 14, 2, 10, 15000, 1, '2023-02-11 11:22:21', '2023-02-11 11:22:21');


--
-- TOC entry 3741 (class 0 OID 18143)
-- Dependencies: 245
-- Data for Name: product_commisions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_commisions VALUES (12, 14, 4000, 16000, 20000, '2023-02-09 09:36:19', 1, NULL, '2023-02-09 10:43:10');
INSERT INTO public.product_commisions VALUES (101, 14, NULL, NULL, 20000, '2023-02-09 10:44:47', 1, NULL, '2023-02-09 10:44:47');
INSERT INTO public.product_commisions VALUES (105, 14, NULL, NULL, 20000, '2023-02-09 10:56:50', 1, NULL, '2023-02-09 10:56:50');
INSERT INTO public.product_commisions VALUES (103, 14, NULL, NULL, 15000, '2023-02-09 10:57:19', 1, NULL, '2023-02-09 10:57:19');
INSERT INTO public.product_commisions VALUES (107, 14, NULL, NULL, 15000, '2023-02-09 10:58:12', 1, NULL, '2023-02-09 10:58:12');
INSERT INTO public.product_commisions VALUES (142, 14, NULL, NULL, 25000, '2023-02-09 11:01:19', 1, NULL, '2023-02-09 13:06:08');
INSERT INTO public.product_commisions VALUES (129, 14, NULL, NULL, 10000, '2023-02-09 13:36:31', 1, NULL, '2023-02-09 13:36:31');
INSERT INTO public.product_commisions VALUES (132, 14, NULL, NULL, 10000, '2023-02-09 13:36:49', 1, NULL, '2023-02-09 13:36:49');
INSERT INTO public.product_commisions VALUES (165, 14, NULL, NULL, 15000, '2023-02-09 13:37:27', 1, NULL, '2023-02-09 13:37:27');
INSERT INTO public.product_commisions VALUES (188, 14, NULL, NULL, 50000, '2023-02-09 13:37:56', 1, NULL, '2023-02-09 13:37:56');
INSERT INTO public.product_commisions VALUES (217, 14, NULL, NULL, 5000, '2023-02-09 13:38:22', 1, NULL, '2023-02-09 13:38:22');
INSERT INTO public.product_commisions VALUES (221, 14, NULL, NULL, 30000, '2023-02-09 13:38:38', 1, NULL, '2023-02-09 13:38:38');
INSERT INTO public.product_commisions VALUES (108, 14, NULL, NULL, 10000, '2023-02-09 13:39:32', 1, NULL, '2023-02-09 13:39:32');
INSERT INTO public.product_commisions VALUES (106, 14, NULL, NULL, 10000, '2023-02-09 13:39:52', 1, NULL, '2023-02-09 13:39:52');
INSERT INTO public.product_commisions VALUES (98, 14, NULL, NULL, 15000, '2023-02-09 13:40:19', 1, NULL, '2023-02-09 13:40:19');
INSERT INTO public.product_commisions VALUES (99, 14, NULL, NULL, 15000, '2023-02-09 13:40:52', 1, NULL, '2023-02-09 13:40:52');
INSERT INTO public.product_commisions VALUES (91, 14, 3000, 12000, 15000, '2023-02-09 13:41:55', 1, NULL, '2023-02-09 13:41:55');
INSERT INTO public.product_commisions VALUES (95, 14, NULL, NULL, 10000, '2023-02-09 13:42:46', 1, NULL, '2023-02-09 13:42:46');
INSERT INTO public.product_commisions VALUES (125, 14, NULL, NULL, 10000, '2023-02-09 13:43:34', 1, NULL, '2023-02-09 13:43:34');
INSERT INTO public.product_commisions VALUES (206, 14, NULL, NULL, 30000, '2023-02-09 13:43:55', 1, NULL, '2023-02-09 13:43:55');
INSERT INTO public.product_commisions VALUES (202, 14, NULL, NULL, 50000, '2023-02-09 13:44:20', 1, NULL, '2023-02-09 13:44:20');
INSERT INTO public.product_commisions VALUES (124, 14, NULL, NULL, 25000, '2023-02-09 13:45:41', 1, NULL, '2023-02-09 13:45:41');
INSERT INTO public.product_commisions VALUES (131, 14, NULL, NULL, 25000, '2023-02-09 13:46:00', 1, NULL, '2023-02-09 13:46:00');
INSERT INTO public.product_commisions VALUES (194, 14, NULL, NULL, 50000, '2023-02-09 13:46:20', 1, NULL, '2023-02-09 13:46:20');
INSERT INTO public.product_commisions VALUES (111, 14, NULL, NULL, 25000, '2023-02-09 13:46:36', 1, NULL, '2023-02-09 13:46:36');
INSERT INTO public.product_commisions VALUES (252, 14, NULL, NULL, 10000, '2023-02-09 14:54:20', 1, NULL, '2023-02-09 14:54:20');
INSERT INTO public.product_commisions VALUES (253, 14, NULL, NULL, 5000, '2023-02-09 18:09:58', 1, NULL, '2023-02-09 18:09:58');
INSERT INTO public.product_commisions VALUES (97, 14, NULL, NULL, 20000, '2023-02-09 18:14:41', 1, NULL, '2023-02-09 18:14:41');
INSERT INTO public.product_commisions VALUES (96, 14, NULL, NULL, 40000, '2023-02-09 18:15:26', 1, NULL, '2023-02-09 18:15:26');
INSERT INTO public.product_commisions VALUES (94, 14, NULL, NULL, 50000, '2023-02-09 13:39:07', 1, NULL, '2023-02-09 18:18:51');
INSERT INTO public.product_commisions VALUES (93, 14, 4000, 16000, 20000, '2023-02-09 13:43:16', 1, NULL, '2023-02-09 18:19:54');
INSERT INTO public.product_commisions VALUES (92, 14, 4000, 16000, 20000, '2023-02-09 13:42:24', 1, NULL, '2023-02-09 18:20:05');
INSERT INTO public.product_commisions VALUES (251, 14, 2000, 10000, 0, '2023-02-09 13:53:47', 1, NULL, '2023-02-16 10:11:25');


--
-- TOC entry 3742 (class 0 OID 18149)
-- Dependencies: 246
-- Data for Name: product_distribution; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_distribution VALUES (111, 14, '2023-02-10 15:28:26', '2023-02-10 15:28:26', 1);
INSERT INTO public.product_distribution VALUES (131, 14, '2023-02-10 15:28:40', '2023-02-10 15:28:40', 1);
INSERT INTO public.product_distribution VALUES (124, 14, '2023-02-10 15:29:15', '2023-02-10 15:29:15', 1);
INSERT INTO public.product_distribution VALUES (125, 14, '2023-02-10 15:29:27', '2023-02-10 15:29:27', 1);
INSERT INTO public.product_distribution VALUES (121, 14, '2023-02-10 15:31:14', '2023-02-10 15:31:14', 1);
INSERT INTO public.product_distribution VALUES (122, 14, '2023-02-10 15:31:25', '2023-02-10 15:31:25', 1);
INSERT INTO public.product_distribution VALUES (157, 14, '2023-02-10 15:32:23', '2023-02-10 15:32:23', 1);
INSERT INTO public.product_distribution VALUES (94, 14, '2023-02-10 15:32:42', '2023-02-10 15:32:42', 1);
INSERT INTO public.product_distribution VALUES (93, 14, '2023-02-10 15:32:55', '2023-02-10 15:32:55', 1);
INSERT INTO public.product_distribution VALUES (95, 14, '2023-02-10 15:33:06', '2023-02-10 15:33:06', 1);
INSERT INTO public.product_distribution VALUES (104, 14, '2023-02-10 15:33:19', '2023-02-10 15:33:19', 1);
INSERT INTO public.product_distribution VALUES (278, 14, '2023-02-10 15:33:46', '2023-02-10 15:33:46', 1);
INSERT INTO public.product_distribution VALUES (92, 14, '2023-02-10 15:34:18', '2023-02-10 15:34:18', 1);
INSERT INTO public.product_distribution VALUES (97, 14, '2023-02-10 15:34:31', '2023-02-10 15:34:31', 1);
INSERT INTO public.product_distribution VALUES (96, 14, '2023-02-10 15:34:41', '2023-02-10 15:34:41', 1);
INSERT INTO public.product_distribution VALUES (91, 14, '2023-02-10 15:34:53', '2023-02-10 15:34:53', 1);
INSERT INTO public.product_distribution VALUES (253, 14, '2023-02-10 15:35:16', '2023-02-10 15:35:16', 1);
INSERT INTO public.product_distribution VALUES (98, 14, '2023-02-10 15:35:51', '2023-02-10 15:35:51', 1);
INSERT INTO public.product_distribution VALUES (256, 14, '2023-02-10 15:36:09', '2023-02-10 15:36:09', 1);
INSERT INTO public.product_distribution VALUES (99, 14, '2023-02-10 15:36:27', '2023-02-10 15:36:27', 1);
INSERT INTO public.product_distribution VALUES (257, 14, '2023-02-10 15:36:44', '2023-02-10 15:36:44', 1);
INSERT INTO public.product_distribution VALUES (100, 14, '2023-02-10 15:37:05', '2023-02-10 15:37:05', 1);
INSERT INTO public.product_distribution VALUES (262, 14, '2023-02-10 15:37:22', '2023-02-10 15:37:22', 1);
INSERT INTO public.product_distribution VALUES (102, 14, '2023-02-10 15:37:34', '2023-02-10 15:37:34', 1);
INSERT INTO public.product_distribution VALUES (279, 14, '2023-02-10 15:37:46', '2023-02-10 15:37:46', 1);
INSERT INTO public.product_distribution VALUES (106, 14, '2023-02-10 15:38:02', '2023-02-10 15:38:02', 1);
INSERT INTO public.product_distribution VALUES (108, 14, '2023-02-10 15:38:17', '2023-02-10 15:38:17', 1);
INSERT INTO public.product_distribution VALUES (272, 14, '2023-02-10 15:38:42', '2023-02-10 15:38:42', 1);
INSERT INTO public.product_distribution VALUES (139, 14, '2023-02-10 15:39:15', '2023-02-10 15:39:15', 1);
INSERT INTO public.product_distribution VALUES (141, 14, '2023-02-10 15:39:34', '2023-02-10 15:39:34', 1);
INSERT INTO public.product_distribution VALUES (268, 14, '2023-02-10 15:39:52', '2023-02-10 15:39:52', 1);
INSERT INTO public.product_distribution VALUES (101, 14, '2023-02-10 15:40:08', '2023-02-10 15:40:08', 1);
INSERT INTO public.product_distribution VALUES (103, 14, '2023-02-10 15:40:22', '2023-02-10 15:40:22', 1);
INSERT INTO public.product_distribution VALUES (105, 14, '2023-02-10 15:40:36', '2023-02-10 15:40:36', 1);
INSERT INTO public.product_distribution VALUES (107, 14, '2023-02-10 15:40:58', '2023-02-10 15:40:58', 1);
INSERT INTO public.product_distribution VALUES (194, 14, '2023-02-10 15:41:22', '2023-02-10 15:41:22', 1);
INSERT INTO public.product_distribution VALUES (251, 14, '2023-02-10 15:41:36', '2023-02-10 15:41:36', 1);
INSERT INTO public.product_distribution VALUES (193, 14, '2023-02-10 15:41:54', '2023-02-10 15:41:54', 1);
INSERT INTO public.product_distribution VALUES (202, 14, '2023-02-10 15:42:09', '2023-02-10 15:42:09', 1);
INSERT INTO public.product_distribution VALUES (254, 14, '2023-02-10 15:42:38', '2023-02-10 15:42:38', 1);
INSERT INTO public.product_distribution VALUES (255, 14, '2023-02-10 15:43:15', '2023-02-10 15:43:15', 1);
INSERT INTO public.product_distribution VALUES (206, 14, '2023-02-10 15:43:55', '2023-02-10 15:43:55', 1);
INSERT INTO public.product_distribution VALUES (199, 14, '2023-02-10 15:44:17', '2023-02-10 15:44:17', 1);
INSERT INTO public.product_distribution VALUES (128, 14, '2023-02-10 15:45:04', '2023-02-10 15:45:04', 1);
INSERT INTO public.product_distribution VALUES (112, 14, '2023-02-10 15:48:00', '2023-02-10 15:48:00', 1);
INSERT INTO public.product_distribution VALUES (266, 14, '2023-02-10 15:48:34', '2023-02-10 15:48:34', 1);
INSERT INTO public.product_distribution VALUES (135, 14, '2023-02-10 15:48:52', '2023-02-10 15:48:52', 1);
INSERT INTO public.product_distribution VALUES (163, 14, '2023-02-10 15:49:07', '2023-02-10 15:49:07', 1);
INSERT INTO public.product_distribution VALUES (276, 14, '2023-02-10 15:49:27', '2023-02-10 15:49:27', 1);
INSERT INTO public.product_distribution VALUES (273, 14, '2023-02-10 15:49:47', '2023-02-10 15:49:47', 1);
INSERT INTO public.product_distribution VALUES (180, 14, '2023-02-10 15:50:21', '2023-02-10 15:50:21', 1);
INSERT INTO public.product_distribution VALUES (182, 14, '2023-02-10 15:50:35', '2023-02-10 15:50:35', 1);
INSERT INTO public.product_distribution VALUES (183, 14, '2023-02-10 15:50:46', '2023-02-10 15:50:46', 1);
INSERT INTO public.product_distribution VALUES (165, 14, '2023-02-10 15:51:04', '2023-02-10 15:51:04', 1);
INSERT INTO public.product_distribution VALUES (252, 14, '2023-02-10 15:51:25', '2023-02-10 15:51:25', 1);
INSERT INTO public.product_distribution VALUES (142, 14, '2023-02-10 15:51:59', '2023-02-10 15:51:59', 1);
INSERT INTO public.product_distribution VALUES (146, 14, '2023-02-10 15:52:18', '2023-02-10 15:52:18', 1);
INSERT INTO public.product_distribution VALUES (267, 14, '2023-02-10 15:52:39', '2023-02-10 15:52:39', 1);
INSERT INTO public.product_distribution VALUES (161, 14, '2023-02-10 15:52:54', '2023-02-10 15:52:54', 1);
INSERT INTO public.product_distribution VALUES (162, 14, '2023-02-10 15:53:14', '2023-02-10 15:53:14', 1);
INSERT INTO public.product_distribution VALUES (164, 14, '2023-02-10 15:53:28', '2023-02-10 15:53:28', 1);
INSERT INTO public.product_distribution VALUES (191, 14, '2023-02-10 15:53:50', '2023-02-10 15:53:50', 1);
INSERT INTO public.product_distribution VALUES (192, 14, '2023-02-10 15:54:02', '2023-02-10 15:54:02', 1);
INSERT INTO public.product_distribution VALUES (275, 14, '2023-02-10 15:54:50', '2023-02-10 15:54:50', 1);
INSERT INTO public.product_distribution VALUES (261, 14, '2023-02-10 15:55:12', '2023-02-10 15:55:12', 1);
INSERT INTO public.product_distribution VALUES (217, 14, '2023-02-10 15:55:39', '2023-02-10 15:55:39', 1);
INSERT INTO public.product_distribution VALUES (277, 14, '2023-02-10 15:56:02', '2023-02-10 15:56:02', 1);
INSERT INTO public.product_distribution VALUES (188, 14, '2023-02-10 15:56:46', '2023-02-10 15:56:46', 1);
INSERT INTO public.product_distribution VALUES (244, 14, '2023-02-10 15:57:51', '2023-02-10 15:57:51', 1);
INSERT INTO public.product_distribution VALUES (270, 14, '2023-02-10 15:58:13', '2023-02-10 15:58:13', 1);
INSERT INTO public.product_distribution VALUES (186, 14, '2023-02-10 15:58:33', '2023-02-10 15:58:33', 1);
INSERT INTO public.product_distribution VALUES (203, 14, '2023-02-10 15:58:43', '2023-02-10 15:58:43', 1);
INSERT INTO public.product_distribution VALUES (223, 14, '2023-02-10 16:02:13', '2023-02-10 16:02:13', 1);
INSERT INTO public.product_distribution VALUES (225, 14, '2023-02-10 16:02:25', '2023-02-10 16:02:25', 1);
INSERT INTO public.product_distribution VALUES (227, 14, '2023-02-10 16:02:50', '2023-02-10 16:02:50', 1);
INSERT INTO public.product_distribution VALUES (228, 14, '2023-02-10 16:03:12', '2023-02-10 16:03:12', 1);
INSERT INTO public.product_distribution VALUES (231, 14, '2023-02-10 16:03:32', '2023-02-10 16:03:32', 1);
INSERT INTO public.product_distribution VALUES (233, 14, '2023-02-10 16:03:55', '2023-02-10 16:03:55', 1);
INSERT INTO public.product_distribution VALUES (236, 14, '2023-02-10 16:04:14', '2023-02-10 16:04:14', 1);
INSERT INTO public.product_distribution VALUES (265, 14, '2023-02-10 16:04:51', '2023-02-10 16:04:51', 1);
INSERT INTO public.product_distribution VALUES (264, 14, '2023-02-10 16:05:12', '2023-02-10 16:05:12', 1);
INSERT INTO public.product_distribution VALUES (320, 14, '2023-02-10 16:05:31', '2023-02-10 16:05:31', 1);
INSERT INTO public.product_distribution VALUES (269, 14, '2023-02-10 16:06:12', '2023-02-10 16:06:12', 1);
INSERT INTO public.product_distribution VALUES (221, 14, '2023-02-10 16:06:42', '2023-02-10 16:06:42', 1);
INSERT INTO public.product_distribution VALUES (274, 14, '2023-02-10 16:06:56', '2023-02-10 16:06:56', 1);
INSERT INTO public.product_distribution VALUES (271, 14, '2023-02-10 16:07:09', '2023-02-10 16:07:09', 1);
INSERT INTO public.product_distribution VALUES (260, 14, '2023-02-10 16:07:26', '2023-02-10 16:07:26', 1);
INSERT INTO public.product_distribution VALUES (293, 14, '2023-02-11 10:55:13', '2023-02-11 10:55:13', 1);
INSERT INTO public.product_distribution VALUES (281, 14, '2023-02-11 10:57:17', '2023-02-11 10:57:17', 1);
INSERT INTO public.product_distribution VALUES (280, 14, '2023-02-11 10:57:34', '2023-02-11 10:57:34', 1);
INSERT INTO public.product_distribution VALUES (285, 14, '2023-02-11 10:57:40', '2023-02-11 10:57:40', 1);
INSERT INTO public.product_distribution VALUES (287, 14, '2023-02-11 10:57:55', '2023-02-11 10:57:55', 1);
INSERT INTO public.product_distribution VALUES (282, 14, '2023-02-11 10:58:04', '2023-02-11 10:58:04', 1);
INSERT INTO public.product_distribution VALUES (290, 14, '2023-02-11 10:58:14', '2023-02-11 10:58:14', 1);
INSERT INTO public.product_distribution VALUES (292, 14, '2023-02-11 10:58:35', '2023-02-11 10:58:35', 1);
INSERT INTO public.product_distribution VALUES (283, 14, '2023-02-11 10:58:39', '2023-02-11 10:58:39', 1);
INSERT INTO public.product_distribution VALUES (297, 14, '2023-02-11 10:58:56', '2023-02-11 10:58:56', 1);
INSERT INTO public.product_distribution VALUES (284, 14, '2023-02-11 10:58:57', '2023-02-11 10:58:57', 1);
INSERT INTO public.product_distribution VALUES (298, 14, '2023-02-11 10:59:05', '2023-02-11 10:59:05', 1);
INSERT INTO public.product_distribution VALUES (286, 14, '2023-02-11 10:59:10', '2023-02-11 10:59:10', 1);
INSERT INTO public.product_distribution VALUES (296, 14, '2023-02-11 10:59:23', '2023-02-11 10:59:23', 1);
INSERT INTO public.product_distribution VALUES (299, 14, '2023-02-11 10:59:34', '2023-02-11 10:59:34', 1);
INSERT INTO public.product_distribution VALUES (288, 14, '2023-02-11 10:59:35', '2023-02-11 10:59:35', 1);
INSERT INTO public.product_distribution VALUES (289, 14, '2023-02-11 10:59:53', '2023-02-11 10:59:53', 1);
INSERT INTO public.product_distribution VALUES (301, 14, '2023-02-11 10:59:55', '2023-02-11 10:59:55', 1);
INSERT INTO public.product_distribution VALUES (300, 14, '2023-02-11 11:00:06', '2023-02-11 11:00:06', 1);
INSERT INTO public.product_distribution VALUES (291, 14, '2023-02-11 11:00:09', '2023-02-11 11:00:09', 1);
INSERT INTO public.product_distribution VALUES (294, 14, '2023-02-11 11:00:23', '2023-02-11 11:00:23', 1);
INSERT INTO public.product_distribution VALUES (302, 14, '2023-02-11 11:00:25', '2023-02-11 11:00:25', 1);
INSERT INTO public.product_distribution VALUES (295, 14, '2023-02-11 11:00:36', '2023-02-11 11:00:36', 1);
INSERT INTO public.product_distribution VALUES (304, 14, '2023-02-11 11:00:53', '2023-02-11 11:00:53', 1);
INSERT INTO public.product_distribution VALUES (306, 14, '2023-02-11 11:01:01', '2023-02-11 11:01:01', 1);
INSERT INTO public.product_distribution VALUES (305, 14, '2023-02-11 11:01:01', '2023-02-11 11:01:01', 1);
INSERT INTO public.product_distribution VALUES (312, 14, '2023-02-11 11:01:12', '2023-02-11 11:01:12', 1);
INSERT INTO public.product_distribution VALUES (307, 14, '2023-02-11 11:01:18', '2023-02-11 11:01:18', 1);
INSERT INTO public.product_distribution VALUES (309, 14, '2023-02-11 11:01:31', '2023-02-11 11:01:31', 1);
INSERT INTO public.product_distribution VALUES (308, 14, '2023-02-11 11:01:41', '2023-02-11 11:01:41', 1);
INSERT INTO public.product_distribution VALUES (310, 14, '2023-02-11 11:01:44', '2023-02-11 11:01:44', 1);
INSERT INTO public.product_distribution VALUES (313, 14, '2023-02-11 11:01:55', '2023-02-11 11:01:55', 1);
INSERT INTO public.product_distribution VALUES (316, 14, '2023-02-11 11:02:06', '2023-02-11 11:02:06', 1);
INSERT INTO public.product_distribution VALUES (317, 14, '2023-02-11 11:02:16', '2023-02-11 11:02:16', 1);
INSERT INTO public.product_distribution VALUES (318, 14, '2023-02-11 11:02:29', '2023-02-11 11:02:29', 1);
INSERT INTO public.product_distribution VALUES (315, 14, '2023-02-11 11:02:34', '2023-02-11 11:02:34', 1);
INSERT INTO public.product_distribution VALUES (319, 14, '2023-02-11 11:02:37', '2023-02-11 11:02:37', 1);
INSERT INTO public.product_distribution VALUES (322, 14, '2023-02-14 16:57:09', '2023-02-14 16:57:09', 1);


--
-- TOC entry 3743 (class 0 OID 18154)
-- Dependencies: 247
-- Data for Name: product_ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3744 (class 0 OID 18159)
-- Dependencies: 248
-- Data for Name: product_point; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_point VALUES (293, 14, 1, NULL, '2023-02-10 14:19:02', '2023-02-10 14:19:02');
INSERT INTO public.product_point VALUES (295, 14, 1, NULL, '2023-02-10 14:19:32', '2023-02-10 14:19:32');
INSERT INTO public.product_point VALUES (287, 14, 1, NULL, '2023-02-10 14:19:51', '2023-02-10 14:19:51');
INSERT INTO public.product_point VALUES (281, 14, 1, NULL, '2023-02-10 14:20:12', '2023-02-10 14:20:12');
INSERT INTO public.product_point VALUES (291, 14, 1, NULL, '2023-02-10 14:20:37', '2023-02-10 14:20:37');
INSERT INTO public.product_point VALUES (289, 14, 1, NULL, '2023-02-10 14:21:25', '2023-02-10 14:21:25');
INSERT INTO public.product_point VALUES (292, 14, 1, NULL, '2023-02-10 14:21:45', '2023-02-10 14:21:45');
INSERT INTO public.product_point VALUES (283, 14, 1, NULL, '2023-02-10 14:22:08', '2023-02-10 14:22:08');
INSERT INTO public.product_point VALUES (284, 14, 1, NULL, '2023-02-10 14:22:28', '2023-02-10 14:22:28');
INSERT INTO public.product_point VALUES (296, 14, 1, NULL, '2023-02-10 14:47:08', '2023-02-10 14:47:08');
INSERT INTO public.product_point VALUES (298, 14, 0, NULL, '2023-02-10 14:47:38', '2023-02-10 14:47:38');
INSERT INTO public.product_point VALUES (310, 14, 0, NULL, '2023-02-10 14:51:40', '2023-02-10 14:51:40');
INSERT INTO public.product_point VALUES (299, 14, 0, NULL, '2023-02-10 14:56:05', '2023-02-10 14:56:05');
INSERT INTO public.product_point VALUES (301, 14, 2, NULL, '2023-02-10 14:57:05', '2023-02-10 14:57:05');
INSERT INTO public.product_point VALUES (304, 14, 1, NULL, '2023-02-10 14:56:33', '2023-02-10 14:57:22');
INSERT INTO public.product_point VALUES (312, 14, 1, NULL, '2023-02-10 14:57:47', '2023-02-10 14:57:47');
INSERT INTO public.product_point VALUES (307, 14, 1, NULL, '2023-02-10 14:58:25', '2023-02-10 14:58:25');
INSERT INTO public.product_point VALUES (316, 14, 0, NULL, '2023-02-10 14:58:59', '2023-02-10 14:58:59');
INSERT INTO public.product_point VALUES (315, 14, 0, NULL, '2023-02-10 15:00:36', '2023-02-10 15:00:36');
INSERT INTO public.product_point VALUES (294, 14, 1, NULL, '2023-02-10 14:19:12', '2023-02-10 14:19:12');
INSERT INTO public.product_point VALUES (288, 14, 1, NULL, '2023-02-10 14:19:41', '2023-02-10 14:19:41');
INSERT INTO public.product_point VALUES (285, 14, 1, NULL, '2023-02-10 14:20:03', '2023-02-10 14:20:03');
INSERT INTO public.product_point VALUES (282, 14, 1, NULL, '2023-02-10 14:20:26', '2023-02-10 14:20:26');
INSERT INTO public.product_point VALUES (286, 14, 1, NULL, '2023-02-10 14:21:34', '2023-02-10 14:21:34');
INSERT INTO public.product_point VALUES (280, 14, 1, NULL, '2023-02-10 14:21:56', '2023-02-10 14:21:56');
INSERT INTO public.product_point VALUES (290, 14, 0, NULL, '2023-02-10 14:22:18', '2023-02-10 14:22:18');
INSERT INTO public.product_point VALUES (297, 14, 0, NULL, '2023-02-10 14:47:21', '2023-02-10 14:47:21');
INSERT INTO public.product_point VALUES (309, 14, 0, NULL, '2023-02-10 14:49:23', '2023-02-10 14:49:23');
INSERT INTO public.product_point VALUES (302, 14, 1, NULL, '2023-02-10 14:56:48', '2023-02-10 14:56:48');
INSERT INTO public.product_point VALUES (305, 14, 1, NULL, '2023-02-10 14:56:22', '2023-02-10 14:57:13');
INSERT INTO public.product_point VALUES (300, 14, 2, NULL, '2023-02-10 14:57:34', '2023-02-10 14:57:34');
INSERT INTO public.product_point VALUES (306, 14, 1, NULL, '2023-02-10 14:58:09', '2023-02-10 14:58:09');
INSERT INTO public.product_point VALUES (308, 14, 1, NULL, '2023-02-10 14:58:42', '2023-02-10 14:58:42');
INSERT INTO public.product_point VALUES (313, 14, 0, NULL, '2023-02-10 14:59:22', '2023-02-10 14:59:22');
INSERT INTO public.product_point VALUES (317, 14, 0, NULL, '2023-02-10 15:00:58', '2023-02-10 15:00:58');


--
-- TOC entry 3745 (class 0 OID 18163)
-- Dependencies: 249
-- Data for Name: product_price; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_price VALUES (3, 250000, 14, NULL, '2023-02-09 10:18:28', 1, '2023-02-09 10:18:28');
INSERT INTO public.product_price VALUES (9, 60000, 14, NULL, '2023-02-09 10:21:08', 1, '2023-02-09 10:21:08');
INSERT INTO public.product_price VALUES (14, 35000, 14, NULL, '2023-02-09 10:22:01', 1, '2023-02-09 10:22:01');
INSERT INTO public.product_price VALUES (17, 50000, 14, NULL, '2023-02-09 10:22:47', 1, '2023-02-09 10:22:47');
INSERT INTO public.product_price VALUES (21, 150000, 14, NULL, '2023-02-09 10:26:47', 1, '2023-02-09 10:26:47');
INSERT INTO public.product_price VALUES (142, 250000, 14, NULL, '2023-02-09 10:36:33', 1, '2023-02-09 10:36:33');
INSERT INTO public.product_price VALUES (165, 60000, 14, NULL, '2023-02-09 10:38:58', 1, '2023-02-09 10:38:58');
INSERT INTO public.product_price VALUES (221, 200000, 14, NULL, '2023-02-09 10:41:51', 1, '2023-02-09 10:41:51');
INSERT INTO public.product_price VALUES (194, 250000, 14, NULL, '2023-02-09 13:11:39', 1, '2023-02-09 13:11:39');
INSERT INTO public.product_price VALUES (93, 60000, 14, NULL, '2023-02-09 13:23:01', 1, '2023-02-09 13:23:01');
INSERT INTO public.product_price VALUES (92, 65000, 14, NULL, '2023-02-09 13:26:05', 1, '2023-02-09 13:26:05');
INSERT INTO public.product_price VALUES (99, 60000, 14, NULL, '2023-02-09 13:28:46', 1, '2023-02-09 13:28:46');
INSERT INTO public.product_price VALUES (103, 100000, 14, NULL, '2023-02-09 13:33:14', 1, '2023-02-09 13:33:14');
INSERT INTO public.product_price VALUES (129, 50000, 14, NULL, '2023-02-09 13:34:22', 1, '2023-02-09 13:34:22');
INSERT INTO public.product_price VALUES (253, 35000, 14, NULL, '2023-02-09 18:09:03', 1, '2023-02-09 18:09:03');
INSERT INTO public.product_price VALUES (96, 200000, 14, NULL, '2023-02-09 18:15:06', 1, '2023-02-09 18:13:37');
INSERT INTO public.product_price VALUES (276, 5000, 14, NULL, '2023-02-09 19:16:01', 1, '2023-02-09 19:16:01');
INSERT INTO public.product_price VALUES (293, 110000, 14, NULL, '2023-02-10 14:32:25', 1, '2023-02-10 14:32:25');
INSERT INTO public.product_price VALUES (298, 100000, 14, NULL, '2023-02-10 14:33:56', 1, '2023-02-10 14:33:56');
INSERT INTO public.product_price VALUES (287, 80000, 14, NULL, '2023-02-10 14:34:58', 1, '2023-02-10 14:34:58');
INSERT INTO public.product_price VALUES (281, 160000, 14, NULL, '2023-02-10 14:36:35', 1, '2023-02-10 14:36:35');
INSERT INTO public.product_price VALUES (289, 150000, 14, NULL, '2023-02-10 14:37:42', 1, '2023-02-10 14:37:42');
INSERT INTO public.product_price VALUES (305, 140000, 14, NULL, '2023-02-10 14:42:02', 1, '2023-02-10 14:42:02');
INSERT INTO public.product_price VALUES (292, 300000, 14, NULL, '2023-02-10 14:43:13', 1, '2023-02-10 14:43:13');
INSERT INTO public.product_price VALUES (297, 100000, 14, NULL, '2023-02-10 14:43:52', 1, '2023-02-10 14:43:52');
INSERT INTO public.product_price VALUES (284, 150000, 14, NULL, '2023-02-10 14:45:04', 1, '2023-02-10 14:45:04');
INSERT INTO public.product_price VALUES (308, 80000, 14, NULL, '2023-02-10 15:21:46', 1, '2023-02-10 15:21:46');
INSERT INTO public.product_price VALUES (312, 185000, 14, NULL, '2023-02-10 15:22:23', 1, '2023-02-10 15:22:23');
INSERT INTO public.product_price VALUES (316, 60000, 14, NULL, '2023-02-10 15:23:12', 1, '2023-02-10 15:23:12');
INSERT INTO public.product_price VALUES (319, 20000, 14, NULL, '2023-02-10 15:24:09', 1, '2023-02-10 15:24:09');
INSERT INTO public.product_price VALUES (4, 175000, 14, NULL, '2023-02-09 10:18:45', 1, '2023-02-09 10:18:45');
INSERT INTO public.product_price VALUES (202, 150000, 14, NULL, '2023-02-09 10:19:57', 1, '2023-02-09 10:19:57');
INSERT INTO public.product_price VALUES (10, 60000, 14, NULL, '2023-02-09 10:21:26', 1, '2023-02-09 10:21:26');
INSERT INTO public.product_price VALUES (15, 60000, 14, NULL, '2023-02-09 10:22:16', 1, '2023-02-09 10:22:16');
INSERT INTO public.product_price VALUES (18, 50000, 14, NULL, '2023-02-09 10:23:01', 1, '2023-02-09 10:23:01');
INSERT INTO public.product_price VALUES (22, 125000, 14, NULL, '2023-02-09 10:27:23', 1, '2023-02-09 10:27:23');
INSERT INTO public.product_price VALUES (27, 50000, 14, NULL, '2023-02-09 10:37:42', 1, '2023-02-09 10:37:42');
INSERT INTO public.product_price VALUES (188, 500000, 14, NULL, '2023-02-09 10:40:02', 1, '2023-02-09 10:40:02');
INSERT INTO public.product_price VALUES (141, 400000, 14, NULL, '2023-02-09 10:42:10', 1, '2023-02-09 10:42:10');
INSERT INTO public.product_price VALUES (131, 175000, 14, NULL, '2023-02-09 13:12:12', 1, '2023-02-09 13:12:12');
INSERT INTO public.product_price VALUES (91, 40000, 14, NULL, '2023-02-09 13:26:22', 1, '2023-02-09 13:26:22');
INSERT INTO public.product_price VALUES (106, 50000, 14, NULL, '2023-02-09 13:29:03', 1, '2023-02-09 13:29:03');
INSERT INTO public.product_price VALUES (107, 100000, 14, NULL, '2023-02-09 13:33:36', 1, '2023-02-09 13:33:36');
INSERT INTO public.product_price VALUES (251, 20000, 14, NULL, '2023-02-09 14:00:21', 1, '2023-02-09 14:00:21');
INSERT INTO public.product_price VALUES (101, 150000, 14, NULL, '2023-02-09 18:10:58', 1, '2023-02-09 18:10:58');
INSERT INTO public.product_price VALUES (105, 125000, 14, NULL, '2023-02-09 18:15:52', 1, '2023-02-09 18:15:52');
INSERT INTO public.product_price VALUES (274, 5000, 14, NULL, '2023-02-09 19:13:57', 1, '2023-02-09 19:13:57');
INSERT INTO public.product_price VALUES (277, 5000, 14, NULL, '2023-02-09 19:16:42', 1, '2023-02-09 19:16:42');
INSERT INTO public.product_price VALUES (294, 110000, 14, NULL, '2023-02-10 14:32:42', 1, '2023-02-10 14:32:42');
INSERT INTO public.product_price VALUES (288, 150000, 14, NULL, '2023-02-10 14:34:18', 1, '2023-02-10 14:34:18');
INSERT INTO public.product_price VALUES (285, 110000, 14, NULL, '2023-02-10 14:35:46', 1, '2023-02-10 14:35:46');
INSERT INTO public.product_price VALUES (282, 175000, 14, NULL, '2023-02-10 14:36:48', 1, '2023-02-10 14:36:48');
INSERT INTO public.product_price VALUES (301, 300000, 14, NULL, '2023-02-10 14:38:11', 1, '2023-02-10 14:38:11');
INSERT INTO public.product_price VALUES (304, 160000, 14, NULL, '2023-02-10 14:42:16', 1, '2023-02-10 14:42:16');
INSERT INTO public.product_price VALUES (299, 65000, 14, NULL, '2023-02-10 14:43:24', 1, '2023-02-10 14:43:24');
INSERT INTO public.product_price VALUES (296, 160000, 14, NULL, '2023-02-10 14:44:32', 1, '2023-02-10 14:44:32');
INSERT INTO public.product_price VALUES (280, 175000, 14, NULL, '2023-02-10 14:45:29', 1, '2023-02-10 14:45:29');
INSERT INTO public.product_price VALUES (309, 75000, 14, NULL, '2023-02-10 14:49:45', 1, '2023-02-10 14:49:45');
INSERT INTO public.product_price VALUES (313, 70000, 14, NULL, '2023-02-10 15:22:38', 1, '2023-02-10 15:22:38');
INSERT INTO public.product_price VALUES (317, 50000, 14, NULL, '2023-02-10 15:23:29', 1, '2023-02-10 15:23:29');
INSERT INTO public.product_price VALUES (322, 5000, 14, NULL, '2023-02-15 19:46:07', 1, '2023-02-15 19:46:07');
INSERT INTO public.product_price VALUES (1, 150000, 14, NULL, '2023-02-09 10:18:09', 1, '2023-02-09 10:18:09');
INSERT INTO public.product_price VALUES (5, 175000, 14, NULL, '2023-02-09 10:18:57', 1, '2023-02-09 10:18:57');
INSERT INTO public.product_price VALUES (206, 150000, 14, NULL, '2023-02-09 10:20:22', 1, '2023-02-09 10:20:22');
INSERT INTO public.product_price VALUES (11, 25000, 14, NULL, '2023-02-09 10:21:42', 1, '2023-02-09 10:21:42');
INSERT INTO public.product_price VALUES (16, 60000, 14, NULL, '2023-02-09 10:22:32', 1, '2023-02-09 10:22:32');
INSERT INTO public.product_price VALUES (94, 175000, 14, NULL, '2023-02-09 10:23:48', 1, '2023-02-09 10:23:48');
INSERT INTO public.product_price VALUES (24, 100000, 14, NULL, '2023-02-09 10:28:43', 1, '2023-02-09 10:28:43');
INSERT INTO public.product_price VALUES (132, 60000, 14, NULL, '2023-02-09 10:38:02', 1, '2023-02-09 10:38:02');
INSERT INTO public.product_price VALUES (217, 25000, 14, NULL, '2023-02-09 10:41:21', 1, '2023-02-09 10:41:21');
INSERT INTO public.product_price VALUES (111, 150000, 14, NULL, '2023-02-09 13:08:26', 1, '2023-02-09 13:08:26');
INSERT INTO public.product_price VALUES (124, 175000, 14, NULL, '2023-02-09 13:12:57', 1, '2023-02-09 13:12:57');
INSERT INTO public.product_price VALUES (95, 25000, 14, NULL, '2023-02-09 13:25:43', 1, '2023-02-09 13:25:43');
INSERT INTO public.product_price VALUES (98, 60000, 14, NULL, '2023-02-09 13:27:22', 1, '2023-02-09 13:27:22');
INSERT INTO public.product_price VALUES (108, 50000, 14, NULL, '2023-02-09 13:29:20', 1, '2023-02-09 13:29:20');
INSERT INTO public.product_price VALUES (125, 60000, 14, NULL, '2023-02-09 13:34:04', 1, '2023-02-09 13:34:04');
INSERT INTO public.product_price VALUES (252, 25000, 14, NULL, '2023-02-09 14:53:57', 1, '2023-02-09 14:53:57');
INSERT INTO public.product_price VALUES (97, 100000, 14, NULL, '2023-02-09 18:13:04', 1, '2023-02-09 18:13:04');
INSERT INTO public.product_price VALUES (128, 5000, 14, NULL, '2023-02-09 19:00:48', 1, '2023-02-09 19:00:48');
INSERT INTO public.product_price VALUES (275, 5000, 14, NULL, '2023-02-09 19:14:37', 1, '2023-02-09 19:14:37');
INSERT INTO public.product_price VALUES (102, 35000, 14, NULL, '2023-02-09 19:20:16', 1, '2023-02-09 19:20:16');
INSERT INTO public.product_price VALUES (295, 110000, 14, NULL, '2023-02-10 14:33:34', 1, '2023-02-10 14:33:34');
INSERT INTO public.product_price VALUES (300, 325000, 14, NULL, '2023-02-10 14:36:01', 1, '2023-02-10 14:36:01');
INSERT INTO public.product_price VALUES (291, 150000, 14, NULL, '2023-02-10 14:37:11', 1, '2023-02-10 14:37:11');
INSERT INTO public.product_price VALUES (286, 150000, 14, NULL, '2023-02-10 14:39:13', 1, '2023-02-10 14:39:13');
INSERT INTO public.product_price VALUES (306, 110000, 14, NULL, '2023-02-10 14:42:57', 1, '2023-02-10 14:42:57');
INSERT INTO public.product_price VALUES (283, 175000, 14, NULL, '2023-02-10 14:43:38', 1, '2023-02-10 14:43:38');
INSERT INTO public.product_price VALUES (290, 70000, 14, NULL, '2023-02-10 14:44:52', 1, '2023-02-10 14:44:52');
INSERT INTO public.product_price VALUES (302, 185000, 14, NULL, '2023-02-10 14:45:49', 1, '2023-02-10 14:45:49');
INSERT INTO public.product_price VALUES (307, 100000, 14, NULL, '2023-02-10 15:20:57', 1, '2023-02-10 15:20:57');
INSERT INTO public.product_price VALUES (310, 70000, 14, NULL, '2023-02-10 15:22:10', 1, '2023-02-10 15:22:10');
INSERT INTO public.product_price VALUES (315, 70000, 14, NULL, '2023-02-10 15:22:54', 1, '2023-02-10 15:22:54');
INSERT INTO public.product_price VALUES (318, 10000, 14, NULL, '2023-02-10 15:23:58', 1, '2023-02-10 15:23:58');


--
-- TOC entry 3746 (class 0 OID 18167)
-- Dependencies: 250
-- Data for Name: product_sku; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_sku VALUES (251, 'BUNGAN JEPUN - CREAM HANGAT SACHET', 'CH SACHET', NULL, NULL, 16, 1, 10, '2023-02-09 14:45:28', NULL, '2023-02-09 13:52:58', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (256, 'BALI ALUS - MASKER PAYUDARA BESAR SACHET', 'MPD BESAR SACHET', NULL, NULL, 22, 1, 20, '2023-02-09 18:58:17', NULL, '2023-02-09 18:58:17', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (261, 'LILIN AROMATERAPI PAKAI', 'LILIN AROM', NULL, NULL, 22, 1, 19, '2023-02-09 19:03:39', NULL, '2023-02-09 19:03:38', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (266, 'CLING PAKAI', 'CLING PAKAI', NULL, NULL, 22, 1, 19, '2023-02-09 19:07:57', NULL, '2023-02-09 19:07:57', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (271, 'VIXAL PAKAI', 'VIXAL PAKAI', NULL, NULL, 22, 1, 19, '2023-02-09 19:11:17', NULL, '2023-02-09 19:11:17', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (275, 'LE MINERAL', 'LE MINERAL', NULL, NULL, 26, 1, 19, '2023-02-09 19:14:23', NULL, '2023-02-09 19:14:23', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (279, 'BALI ALUS - ROYAL JELLY PAKAI', 'ROYAL JELLY PAKAI', NULL, NULL, 19, 1, 10, '2023-02-09 19:21:30', NULL, '2023-02-09 19:19:50', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (284, 'TUINA', 'TT', NULL, NULL, 44, 2, 19, '2023-02-10 10:34:26', NULL, '2023-02-10 10:34:26', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (289, 'FULL BODY THERAPY', 'FBT', NULL, NULL, 44, 2, 19, '2023-02-10 10:35:35', NULL, '2023-02-10 10:35:35', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (293, 'BACK DRY MASSAGE', 'BACK DRY', NULL, NULL, 44, 2, 19, '2023-02-10 10:37:02', NULL, '2023-02-10 10:37:02', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (297, 'SLIMMING', 'SLIM', NULL, NULL, 49, 2, 19, '2023-02-10 14:32:26', NULL, '2023-02-10 14:32:26', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (305, 'BALI ALUS BODY SCRUB GREENTEA', 'BABS', NULL, NULL, 50, 2, 19, '2023-02-10 14:39:56', NULL, '2023-02-10 14:39:56', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (313, 'MANDI SUSU', 'MSU', NULL, NULL, 6, 2, 19, '2023-02-10 14:53:39', NULL, '2023-02-10 14:53:38', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (317, 'STEAM BADAN', 'STEAM B', NULL, NULL, 6, 2, 19, '2023-02-10 14:55:43', NULL, '2023-02-10 14:55:43', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (301, 'EXECUTIVE BALI BODY SCRUB GREENTEA', 'EBBS', NULL, NULL, 50, 2, 19, '2023-02-10 15:07:14', NULL, '2023-02-10 14:36:46', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (321, 'TEST PERAWATAN', 'TP', NULL, NULL, 52, 2, 19, '2023-02-11 14:07:20', NULL, '2023-02-11 14:07:20', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (309, 'EXTRA TIME HERBAL COMPRESS', 'ETHC', NULL, NULL, 6, 8, 19, '2023-02-10 15:06:21', NULL, '2023-02-10 14:48:27', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (104, 'BALI ALUS - GARAM JELLY BUNGKUS', 'GARAM JELLY BUNGKUS', NULL, NULL, 19, 1, 10, '2023-02-09 19:22:07', NULL, '2023-02-08 19:21:19', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (105, 'BIOKOS - MASSAGE CREAM', 'MASSAGE CREAM', NULL, NULL, 16, 1, 13, '2023-02-09 14:59:31', NULL, '2023-02-08 19:22:20', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (94, 'BALI ALUS - BATH SALT BUNGKUS', 'GARAM', NULL, NULL, 19, 1, 10, '2023-02-09 14:43:17', NULL, '2023-02-08 19:02:06', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (93, 'BALI ALUS - BODY WHITENING', 'BLC', NULL, NULL, 16, 1, 10, '2023-02-09 14:44:01', NULL, '2023-02-08 19:01:44', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (101, 'BIOKOS - CLEANSER', 'CLEANSER', NULL, NULL, 16, 1, 13, '2023-02-09 14:44:23', NULL, '2023-02-08 19:19:27', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (113, 'ACL - CONDITIONER', 'CONDITIONER', NULL, NULL, 24, 1, 11, '2023-02-09 14:44:45', NULL, '2023-02-08 19:35:45', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (115, 'ACL - CREAMBATH AVOCADO', 'CRB AVOCADO', NULL, NULL, 16, 1, 11, '2023-02-09 14:45:46', NULL, '2023-02-08 19:38:04', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (98, 'BALI ALUS - MASKER PAYUDARA BESAR', 'MPD BESAR', NULL, NULL, 21, 1, 10, '2023-02-09 14:58:22', NULL, '2023-02-08 19:12:29', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (124, 'ACL - LINEN SPRAY', 'LINEN', NULL, NULL, 25, 1, 11, '2023-02-09 14:55:39', NULL, '2023-02-08 19:43:50', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (118, 'ACL - CREAMBATH LIDAH BUAYA', 'CRB LIDAH BUAYA', NULL, NULL, 16, 1, 11, '2023-02-09 14:46:18', NULL, '2023-02-08 19:40:04', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (280, 'THAI', 'TH', NULL, NULL, 44, 2, 19, '2023-02-10 10:31:40', NULL, '2023-02-10 10:31:40', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (117, 'ACL - CREAMBATH GINSENG', 'CRB GINSENG', NULL, NULL, 16, 1, 11, '2023-02-09 14:46:05', NULL, '2023-02-08 19:39:06', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (131, 'ACL - FOOT SPRAY', 'FOOT SPRAY', NULL, NULL, 25, 1, 11, '2023-02-09 14:48:34', NULL, '2023-02-08 19:45:26', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (96, 'BALI ALUS - LULUR GREENSPA EMBER', 'L. GREEN SPA EMBER', NULL, NULL, 17, 1, 10, '2023-02-09 18:12:35', NULL, '2023-02-08 19:06:52', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (285, 'FACE REFRESHING BIOKOS', 'FR', NULL, NULL, 48, 2, 19, '2023-02-10 10:34:38', NULL, '2023-02-10 10:34:38', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (91, 'BALI ALUS - LULUR GREENTEA', 'LGT', NULL, NULL, 17, 1, 10, '2023-02-09 14:57:19', NULL, '2023-02-08 18:53:03', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (99, 'BALI ALUS - MASKER PAYUDARA KENCANG', 'MPD KENCANG', NULL, NULL, 21, 1, 10, '2023-02-09 14:58:50', NULL, '2023-02-08 19:14:35', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (120, 'ACL - CREAMBATH MINT', 'CRB MINT', NULL, NULL, 16, 1, 11, '2023-02-09 14:46:37', NULL, '2023-02-08 19:41:04', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (106, 'BALI ALUS - SABUN SIRIH', 'SIRIH', NULL, NULL, 18, 1, 10, '2023-02-09 15:00:54', NULL, '2023-02-08 19:24:27', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (125, 'ACL - PENYEGAR WAJAH', 'TONER', NULL, NULL, 25, 1, 11, '2023-02-09 14:47:04', NULL, '2023-02-08 19:44:03', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (121, 'ACL - SHAMPOO', 'SHAMPOO', NULL, NULL, 24, 1, 11, '2023-02-09 15:02:01', NULL, '2023-02-08 19:41:10', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (95, 'BALI ALUS - DUDUS CELUP', 'DUDUS', NULL, NULL, 20, 1, 10, '2023-02-09 14:47:25', NULL, '2023-02-08 19:04:49', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (138, 'ACL - HAND & BODY LOTION', 'HANDBODY', NULL, NULL, 16, 1, 11, '2023-02-09 14:50:52', NULL, '2023-02-08 19:48:06', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (137, 'ACL - FOOTBATH FRESH MINT', 'FOOTBATH FRESH MISNT', NULL, NULL, 25, 1, 11, '2023-02-09 14:48:53', NULL, '2023-02-08 19:47:34', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (102, 'BALI ALUS - ROYAL JELLY', 'JELLY', NULL, NULL, 20, 1, 10, '2023-02-09 15:01:12', NULL, '2023-02-08 19:19:47', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (100, 'BALI ALUS - RATUS BUBUK', 'RATUS BUBUK', NULL, NULL, 20, 1, 10, '2023-02-09 15:00:27', NULL, '2023-02-08 19:16:11', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (103, 'BIOKOS - GELK MASK', 'GELK MASK', NULL, NULL, 18, 1, 13, '2023-02-09 14:50:13', NULL, '2023-02-08 19:21:08', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (136, 'ACL - HANDWASH APEL', 'H. APEL', NULL, NULL, 23, 1, 11, '2023-02-09 14:51:12', NULL, '2023-02-08 19:47:10', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (109, 'BOTOL MASSAGE CREAM', 'BOTOL CREAM', NULL, NULL, 22, 1, 16, '2023-02-08 19:29:49', NULL, '2023-02-08 19:29:49', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (110, 'BOTOL KACA SERUM', 'BOTOL SERUM', NULL, NULL, 22, 1, 16, '2023-02-08 19:32:00', NULL, '2023-02-08 19:32:00', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (134, 'ACL - HANDWASH JASMINE', 'H. JASMINE', NULL, NULL, 23, 1, 11, '2023-02-09 14:51:27', NULL, '2023-02-08 19:46:36', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (108, 'BALI ALUS - SWEETY SLIM', 'S. SLIM', NULL, NULL, 18, 1, 10, '2023-02-09 15:03:14', NULL, '2023-02-08 19:29:18', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (133, 'ACL - HANDWASH LEMON', 'H. LEMON', NULL, NULL, 23, 1, 11, '2023-02-09 14:51:40', NULL, '2023-02-08 19:45:54', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (112, 'ACL - SHOWER GELL WHITE PEARL', 'S. GELL WHITE PEARL', NULL, NULL, 23, 1, 11, '2023-02-09 15:02:49', NULL, '2023-02-08 19:35:21', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (116, 'BOTOL SPRAY', 'BOTOL SPRAY', NULL, NULL, 22, 1, 16, '2023-02-08 19:38:17', NULL, '2023-02-08 19:38:17', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (130, 'ACL - HANDWASH PINK PEARLIZED', 'H. PINK PEARLIZED', NULL, NULL, 23, 1, 11, '2023-02-09 14:51:58', NULL, '2023-02-08 19:45:17', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (127, 'ACL - HANDWASH STRAWBERRY', 'H. STRAWBERY', NULL, NULL, 23, 1, 11, '2023-02-09 14:52:20', NULL, '2023-02-08 19:44:32', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (114, 'ACL - SHOWER GELL GOAT MILK REFILE', 'S. GOAT MILK REFILE', NULL, NULL, 23, 1, 11, '2023-02-09 15:02:39', NULL, '2023-02-08 19:36:47', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (142, 'IANTHE -  SERUM 100 ML', 'SERUM BOTOL', NULL, NULL, 18, 1, 14, '2023-02-09 14:52:47', NULL, '2023-02-08 19:52:07', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (119, 'ACL - SHOWER GELL GOAT MILK BOTOL', 'S. GOAT BOTOL', NULL, NULL, 23, 1, 11, '2023-02-09 15:02:27', NULL, '2023-02-08 19:40:22', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (123, 'BOTOL TEKAN', 'BOTOL TEKAN', NULL, NULL, 22, 1, 16, '2023-02-08 19:42:25', NULL, '2023-02-08 19:42:25', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (122, 'ACL - LIQUID SOAP', 'TIPOL', NULL, NULL, 23, 1, 11, '2023-02-09 14:55:55', NULL, '2023-02-08 19:41:40', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (126, 'BUKU BON PENJUALAN', 'BUKU BON', NULL, NULL, 22, 1, 16, '2023-02-08 19:44:11', NULL, '2023-02-08 19:44:10', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (252, 'IANTHE - SERUM 5 ML', 'SERUM SACHET', NULL, NULL, 7, 1, 14, '2023-02-09 14:53:35', NULL, '2023-02-09 14:53:35', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (128, 'CD KERTAS', 'CD KERTAS', NULL, NULL, 22, 1, 16, '2023-02-08 19:44:40', NULL, '2023-02-08 19:44:40', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (129, 'CELANA TAMU STANDAR', 'CELANA STANDAR', NULL, NULL, 22, 1, 16, '2023-02-08 19:45:14', NULL, '2023-02-08 19:45:14', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (92, 'BALI ALUS - LIGHTENING', 'LLG', NULL, NULL, 17, 1, 10, '2023-02-09 14:55:25', NULL, '2023-02-08 18:53:26', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (107, 'BIOKOS - PEELING', 'PEELING', NULL, NULL, 17, 1, 13, '2023-02-09 15:00:07', NULL, '2023-02-08 19:26:03', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (132, 'CELANA TAMU JUMBO', 'CELANA JUMBO', NULL, NULL, 22, 1, 16, '2023-02-08 19:45:52', NULL, '2023-02-08 19:45:52', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (97, 'BALI ALUS - LULUR GREENSPA BUNGKUS', 'GREENSPA BUNGKUS', NULL, NULL, 17, 1, 10, '2023-02-09 18:12:01', NULL, '2023-02-08 19:10:36', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (257, 'BALI ALUS - MASKER PAYUDARA KENCANG SACHET', 'MPD KENCANG SACHET', NULL, NULL, 22, 1, 20, '2023-02-09 18:59:06', NULL, '2023-02-09 18:59:06', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (135, 'COTTON BUD', 'COTTON BUD', NULL, NULL, 22, 1, 16, '2023-02-08 19:46:56', NULL, '2023-02-08 19:46:56', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (262, 'BALI ALUS - RATUS BUBUK SACHET', 'RATUS BUBUK SACHET', NULL, NULL, 22, 1, 20, '2023-02-09 19:04:40', NULL, '2023-02-09 19:04:40', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (139, 'BANDO', 'BANDO', NULL, NULL, 22, 1, 16, '2023-02-08 19:49:07', NULL, '2023-02-08 19:49:07', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (140, 'BANTAL TAMU DAKRON', 'BANTAL DAKRON', NULL, NULL, 22, 1, 16, '2023-02-08 19:49:55', NULL, '2023-02-08 19:49:55', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (141, 'BANTAL HANGAT BESAR', 'BANTAL HANGAT BESAR', NULL, NULL, 22, 1, 16, '2023-02-08 19:50:36', NULL, '2023-02-08 19:50:36', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (267, 'KAMPER PAKAI', 'KAMPER PAKAI', NULL, NULL, 22, 1, 19, '2023-02-09 19:08:29', NULL, '2023-02-09 19:08:29', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (143, 'AMPLAS BENGKOK', 'AMPLAS', NULL, NULL, 22, 1, 16, '2023-02-08 19:52:13', NULL, '2023-02-08 19:52:13', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (206, 'BUNGAN JEPUN - MILK BATH', 'M. BATH', NULL, NULL, 20, 1, 12, '2023-02-09 14:59:51', NULL, '2023-02-08 20:22:23', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (202, 'BUNGAN JEPUN - MASKER BADAN', 'M. BADAN', NULL, NULL, 21, 1, 12, '2023-02-09 14:57:55', NULL, '2023-02-08 20:21:12', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (147, 'JAM BEKER', 'JAM BEKER', NULL, NULL, 22, 1, 16, '2023-02-08 19:54:06', NULL, '2023-02-08 19:54:06', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (111, 'ACL - ANTISEPTIK GEL', 'ANTIS', NULL, NULL, 18, 1, 11, '2023-02-09 14:42:32', NULL, '2023-02-08 19:33:14', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (149, 'KACA LASER BULAT', 'KACA LASER BULAT', NULL, NULL, 22, 1, 16, '2023-02-08 19:54:47', NULL, '2023-02-08 19:54:46', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (150, 'AMPLAS BINTILAN HITAM', 'AMPLAS BINTILAN', NULL, NULL, 22, 1, 16, '2023-02-08 19:54:57', NULL, '2023-02-08 19:54:56', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (151, 'KACA LASER OVAL', 'KACA LASER OVAL', NULL, NULL, 22, 1, 16, '2023-02-08 19:55:12', NULL, '2023-02-08 19:55:12', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (152, 'AMPLAS COKLAT', 'AMPLAS COKLAT', NULL, NULL, 22, 1, 16, '2023-02-08 19:55:32', NULL, '2023-02-08 19:55:32', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (153, 'KACA LASER PANJANG', 'KACA LASER PANJANG', NULL, NULL, 22, 1, 16, '2023-02-08 19:55:40', NULL, '2023-02-08 19:55:40', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (154, 'AMPLAS HIJAU', 'AMPLAS HIJAU', NULL, NULL, 22, 1, 16, '2023-02-08 19:56:02', NULL, '2023-02-08 19:56:02', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (155, 'KACA SEDOT LEMAK ANGKA 8', 'SEDOT LEMAK ANGKA 8', NULL, NULL, 22, 1, 16, '2023-02-08 19:56:15', NULL, '2023-02-08 19:56:15', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (156, 'KACA SEDOT LEMAK BULAT', 'SEDOT LEMAK BULAT', NULL, NULL, 22, 1, 16, '2023-02-08 19:56:59', NULL, '2023-02-08 19:56:59', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (157, 'BABY OIL', 'BABY OIL', NULL, NULL, 27, 1, 16, '2023-02-08 19:57:41', NULL, '2023-02-08 19:57:41', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (158, 'KACA SEDOT LEMAK GEPENG', 'SEDOT LEMAK GEPENG', NULL, NULL, 22, 1, 16, '2023-02-08 19:58:59', NULL, '2023-02-08 19:58:58', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (159, 'BAJU KIMONO', 'BAJU', NULL, NULL, 22, 1, 16, '2023-02-08 19:59:36', NULL, '2023-02-08 19:59:36', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (160, 'KAIN ALAS HERBAL', 'ALAS HERBAL', NULL, NULL, 22, 1, 16, '2023-02-08 19:59:47', NULL, '2023-02-08 19:59:46', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (161, 'KAPAS WAJAH', 'KAPAS', NULL, NULL, 22, 1, 16, '2023-02-08 20:00:14', NULL, '2023-02-08 20:00:14', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (162, 'KAYU REFLEXY BINTANG', 'KAYU REF BINTANG', NULL, NULL, 22, 1, 16, '2023-02-08 20:00:54', NULL, '2023-02-08 20:00:54', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (164, 'KAYU REFLEXY SEGITIGA', 'KAYU REF SEGITIGA', NULL, NULL, 22, 1, 16, '2023-02-08 20:01:23', NULL, '2023-02-08 20:01:23', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (146, 'INTRA - JAHE WANGI', 'JAHE', NULL, NULL, 26, 1, 15, '2023-02-09 14:54:57', NULL, '2023-02-08 19:53:28', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (174, 'MESIN FOGGING', 'MESIN FOGGING', NULL, NULL, 28, 1, 16, '2023-02-08 20:07:29', NULL, '2023-02-08 20:07:29', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (166, 'KEMBEN UNTUK RATUS', 'KEMBEN RATUS', NULL, NULL, 22, 1, 16, '2023-02-08 20:02:26', NULL, '2023-02-08 20:02:26', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (167, 'LAMPU FACIAL', 'LAMPU FACIAL', NULL, NULL, 28, 1, 16, '2023-02-08 20:02:55', NULL, '2023-02-08 20:02:55', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (168, 'MESIN FACIAL', 'MESIN FACIAL', NULL, NULL, 28, 1, 16, '2023-02-08 20:03:20', NULL, '2023-02-08 20:03:20', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (169, 'STEAM UAP FACIAL', 'STEAM UAP FACIAL', NULL, NULL, 28, 1, 16, '2023-02-08 20:03:51', NULL, '2023-02-08 20:03:51', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (170, 'KERANJANG PERLENGKAPAN FACIAL', 'KERANJANG FACIAL', NULL, NULL, 22, 1, 16, '2023-02-08 20:04:09', NULL, '2023-02-08 20:04:09', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (165, 'HERBAL COMPRES', 'HERBAL COMPRES', NULL, NULL, 22, 1, 16, '2023-02-08 20:04:17', NULL, '2023-02-08 20:01:30', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (171, 'KERANJANG PERLENGKAPAN PERAWATAN', 'KERANJANG PERAWATAN', NULL, NULL, 22, 1, 16, '2023-02-08 20:04:47', NULL, '2023-02-08 20:04:47', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (172, 'FLASKDISK MUSIK', 'FLASKDISK MUSIK', NULL, NULL, 22, 1, 16, '2023-02-08 20:05:18', NULL, '2023-02-08 20:05:18', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (173, 'FORM LAPORAN HARIAN', 'FORM LAPORAN HARIAN', NULL, NULL, 29, 1, 16, '2023-02-08 20:06:50', NULL, '2023-02-08 20:06:50', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (175, 'CAIRAN FOGGING', 'CAIRAN FOGGING', NULL, NULL, 25, 1, 16, '2023-02-08 20:08:06', NULL, '2023-02-08 20:08:06', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (176, 'GORDEN', 'GORDEN', NULL, NULL, 22, 1, 16, '2023-02-08 20:08:28', NULL, '2023-02-08 20:08:28', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (177, 'HANDUK MANDI COWOK', 'HANDUK MANDI COWOK', NULL, NULL, 22, 1, 16, '2023-02-08 20:09:08', NULL, '2023-02-08 20:09:08', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (178, 'HANDUK MANDI CEWEK', 'HANDUK MANDI CEWEK', NULL, NULL, 22, 1, 16, '2023-02-08 20:09:36', NULL, '2023-02-08 20:09:36', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (179, 'HANDUK REFLEKSI BIRU', 'HANDUK REFLEKSI BIRU', NULL, NULL, 22, 1, 16, '2023-02-08 20:10:16', NULL, '2023-02-08 20:10:16', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (180, 'HANDUK REFLEKSI HIJAU', 'HANDUK REFLEKSI HIJAU', NULL, NULL, 22, 1, 16, '2023-02-08 20:10:46', NULL, '2023-02-08 20:10:46', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (193, 'BUNGAN JEPUN - FOAMBATH AROMATHERAPY', 'BUBBLE BATH', NULL, NULL, 23, 1, 12, '2023-02-09 15:05:48', NULL, '2023-02-08 20:18:16', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (187, 'HANDUK REFLEKSI UNGU', 'HANDUK REFLEKSI UNGU', NULL, NULL, 22, 1, 16, '2023-02-08 20:13:58', NULL, '2023-02-08 20:13:58', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (182, 'HANDUK REFLEKSI KUNING', 'HANDUK REFLEKSI KUNING', NULL, NULL, 22, 1, 16, '2023-02-08 20:11:30', NULL, '2023-02-08 20:11:30', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (183, 'HANDUK REFLEKSI PINK', 'HANDUK REFLEKSI PINK', NULL, NULL, 22, 1, 16, '2023-02-08 20:12:07', NULL, '2023-02-08 20:12:07', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (181, 'SARUNG BANTAL HANGAT BESAR', 'S. BANTAL HANGAT BESAR', NULL, NULL, 22, 1, 16, '2023-02-08 20:12:10', NULL, '2023-02-08 20:11:30', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (184, 'KESET KAKI HANDUK', 'KESET', NULL, NULL, 22, 1, 16, '2023-02-08 20:12:30', NULL, '2023-02-08 20:12:30', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (185, 'HANDUK REFLEKSI MERAH', 'HANDUK REFLEKSI MERAH', NULL, NULL, 22, 1, 16, '2023-02-08 20:12:49', NULL, '2023-02-08 20:12:48', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (186, 'RATUS MANGKOK', 'RATUS MANGKOK', NULL, NULL, 22, 1, 16, '2023-02-08 20:12:55', NULL, '2023-02-08 20:12:55', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (188, 'KOP BADAN BESAR', 'KOP BADAN B', NULL, NULL, 22, 1, 16, '2023-02-08 20:14:16', NULL, '2023-02-08 20:14:16', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (189, 'HANDUK REFLEKSI COKLAT', 'HANDUK REFLEKSI COKLAT', NULL, NULL, 22, 1, 16, '2023-02-08 20:14:23', NULL, '2023-02-08 20:14:23', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (190, 'HANDUK SHIATSU', 'HANDUK SHIATSU', NULL, NULL, 22, 1, 16, '2023-02-08 20:14:58', NULL, '2023-02-08 20:14:58', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (191, 'KUAS MASKER BADAN', 'KUAS MB', NULL, NULL, 22, 1, 16, '2023-02-08 20:15:03', NULL, '2023-02-08 20:15:03', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (192, 'KUAS MASKER WAJAH', 'KUAS MASKER WJH', NULL, NULL, 22, 1, 16, '2023-02-08 20:15:58', NULL, '2023-02-08 20:15:58', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (194, 'BUNGA JEPUN - CREAM HANGAT BOTOL', 'CH BOTOL', NULL, NULL, 16, 1, 12, '2023-02-09 14:45:05', NULL, '2023-02-08 20:18:55', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (195, 'SPREI SARUNG STEAM BADAN', 'SPREI SARUNG STEAM BADAN', NULL, NULL, 22, 1, 16, '2023-02-08 20:19:28', NULL, '2023-02-08 20:19:28', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (163, 'ENIGMA -  PEELING SPRAY', 'PEELING SPRAY', NULL, NULL, 25, 1, 17, '2023-02-09 14:47:56', NULL, '2023-02-08 20:00:55', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (198, 'BANGKU STEAM BADAN', 'BANGKU STEAM BADAN', NULL, NULL, 22, 1, 16, '2023-02-08 20:20:18', NULL, '2023-02-08 20:20:18', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (200, 'MESIN STEAM BADAN', 'MESIN STEAM BADAN', NULL, NULL, 28, 1, 16, '2023-02-08 20:20:50', NULL, '2023-02-08 20:20:50', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (201, 'KURSI RATUS', 'KURSI RATUS', NULL, NULL, 22, 1, 16, '2023-02-08 20:20:54', NULL, '2023-02-08 20:20:54', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (203, 'REMPAH STEAM', 'REMPAH STEAM', NULL, NULL, 20, 1, 16, '2023-02-08 20:21:28', NULL, '2023-02-08 20:21:28', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (204, 'LASER / GAGANG LASER', 'LASER', NULL, NULL, 22, 1, 16, '2023-02-08 20:21:54', NULL, '2023-02-08 20:21:54', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (205, 'SARUNG STEAM BADAN', 'SARUNG STEAM BADAN', NULL, NULL, 22, 1, 16, '2023-02-08 20:22:19', NULL, '2023-02-08 20:22:19', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (207, 'LEMPENGAN', 'LEMPENGAN', NULL, NULL, 22, 1, 16, '2023-02-08 20:22:44', NULL, '2023-02-08 20:22:44', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (208, 'STICKER RUANGAN', 'STICKER RUANGAN', NULL, NULL, 22, 1, 16, '2023-02-08 20:23:28', NULL, '2023-02-08 20:23:28', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (209, 'TATAKAN SPK', 'TATAKAN SPK', NULL, NULL, 22, 1, 16, '2023-02-08 20:24:08', NULL, '2023-02-08 20:24:08', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (272, 'BAIGON PAKAI', 'BAIGON PAKAI', NULL, NULL, 22, 1, 19, '2023-02-09 19:11:45', NULL, '2023-02-09 19:11:44', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (237, 'MASKER LUMPUR', 'MASKER LUMPUR', NULL, NULL, 21, 1, 16, '2023-02-08 20:34:45', NULL, '2023-02-08 20:34:45', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (211, 'SARUNG BANTAL TAMU / DAKRON BESAR', 'SARUNG BANTAL TAMU / DAKRON BESAR', NULL, NULL, 22, 1, 16, '2023-02-08 20:25:39', NULL, '2023-02-08 20:25:38', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (210, 'SARUNG BANTAL TAMU / DAKRON KECIL', 'SARUNG BANTAL TAMU / DAKRON KECIL', NULL, NULL, 22, 1, 16, '2023-02-08 20:26:05', NULL, '2023-02-08 20:24:55', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (212, 'LILIN AROMATHERAPY 6 JAM', 'LILIN', NULL, NULL, 22, 1, 16, '2023-02-08 20:26:33', NULL, '2023-02-08 20:26:32', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (213, 'SARUNG TANGAN KARET', 'SARUNG TANGAN KARET', NULL, NULL, 22, 1, 16, '2023-02-08 20:27:06', NULL, '2023-02-08 20:27:06', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (214, 'SEPATU TERAPIS CEWEK', 'SEPATU TERAPIS CEWEK', NULL, NULL, 22, 1, 16, '2023-02-08 20:27:58', NULL, '2023-02-08 20:27:58', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (215, 'LILIN AROMATHERAPY 4 JAM', 'LILIN ARO', NULL, NULL, 22, 1, 16, '2023-02-08 20:28:07', NULL, '2023-02-08 20:28:07', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (216, 'SEPATU TERAPIS COWOK', 'SEPATU TERAPIS COWOK', NULL, NULL, 22, 1, 16, '2023-02-08 20:28:43', NULL, '2023-02-08 20:28:43', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (217, 'LILIN EAR CANDLING', 'LILIN EC', NULL, NULL, 22, 1, 16, '2023-02-08 20:28:47', NULL, '2023-02-08 20:28:46', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (199, 'BUNGAN JEPUN - MASSAGE CREAM', 'MC. JEPUN', NULL, NULL, 16, 1, 12, '2023-02-09 14:59:08', NULL, '2023-02-08 20:20:39', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (253, 'BALI ALUS - MASKER ARMPIT', 'MASKER ARMPIT', NULL, NULL, 21, 1, 10, '2023-02-09 18:08:41', NULL, '2023-02-09 18:08:41', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (220, 'SERAGAM KASIR BATIK', 'SERAGAM KASIR BATIK', NULL, NULL, 22, 1, 16, '2023-02-08 20:29:18', NULL, '2023-02-08 20:29:18', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (221, 'TATAKAN WAJAH JELLY', 'TATAKAN WAJAH JELLY', NULL, NULL, 22, 1, 16, '2023-02-08 20:29:27', NULL, '2023-02-08 20:29:27', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (281, 'FACIAL BIOKOS ACCU AURA W / VIT', 'FAC', NULL, NULL, 48, 2, 19, '2023-02-10 10:33:29', NULL, '2023-02-10 10:33:29', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (223, 'SERAGAM KASIR HITAM', 'SERAGAM KASIR HITAM', NULL, NULL, 22, 1, 16, '2023-02-08 20:29:52', NULL, '2023-02-08 20:29:52', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (225, 'SERAGAM KASIR MERAH', 'SERAGAM KASIR MERAH', NULL, NULL, 22, 1, 16, '2023-02-08 20:30:50', NULL, '2023-02-08 20:30:50', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (226, 'TIMBANGAN DIGITAL', 'TIMBANGAN DIGITAL', NULL, NULL, 28, 1, 16, '2023-02-08 20:30:51', NULL, '2023-02-08 20:30:51', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (227, 'SERAGAM KASIR PUTIH', 'SERAGAM KASIR PUTIH', NULL, NULL, 22, 1, 16, '2023-02-08 20:31:09', NULL, '2023-02-08 20:31:09', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (228, 'SERAGAM TERAPIS BIRU', 'SERAGAM TERAPIS BIRU', NULL, NULL, 22, 1, 16, '2023-02-08 20:31:49', NULL, '2023-02-08 20:31:49', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (263, 'MINYAK AROMATERAPI', 'M. AROMATERAPI PAKAI', NULL, NULL, 22, 1, 20, '2023-02-09 19:05:42', NULL, '2023-02-09 19:05:42', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (229, 'MANGKOK MASKER PLASTIK', 'MANGKOK MASKER PLASTIK', NULL, NULL, 22, 1, 16, '2023-02-08 20:31:53', NULL, '2023-02-08 20:31:52', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (231, 'SERAGAM TERAPIS COKLAT', 'SERAGAM TERAPIS COKLAT', NULL, NULL, 22, 1, 16, '2023-02-08 20:32:30', NULL, '2023-02-08 20:32:30', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (232, 'TUNGKU AROMATERAPY + LEMPENGAN', 'TUNGKU AROMATERAPY + LEMPENGAN', NULL, NULL, 22, 1, 16, '2023-02-08 20:32:58', NULL, '2023-02-08 20:32:58', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (233, 'SERAGAM TERAPIS ORANGE', 'SERAGAM TERAPIS ORANGE', NULL, NULL, 22, 1, 16, '2023-02-08 20:33:13', NULL, '2023-02-08 20:33:13', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (234, 'TUTUP BADAN TAMU', 'TUTUP BADAN TAMU', NULL, NULL, 22, 1, 16, '2023-02-08 20:33:49', NULL, '2023-02-08 20:33:49', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (235, 'MANGKOK MIHA', 'MANGKOK MIHA', NULL, NULL, 22, 1, 16, '2023-02-08 20:34:00', NULL, '2023-02-08 20:34:00', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (236, 'SHOWER CAP', 'SC. CAP', NULL, NULL, 22, 1, 16, '2023-02-08 20:34:21', NULL, '2023-02-08 20:34:21', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (238, 'SPONGE MANDI', 'SPONGE MANDI', NULL, NULL, 22, 1, 16, '2023-02-08 20:34:52', NULL, '2023-02-08 20:34:52', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (239, 'MESIN PEMANAS HANDUK', 'MESIN PEMANAS', NULL, NULL, 22, 1, 16, '2023-02-08 20:35:24', NULL, '2023-02-08 20:35:24', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (241, 'SPONGE WAJAH', 'SPONGE WAJAH', NULL, NULL, 22, 1, 16, '2023-02-08 20:35:26', NULL, '2023-02-08 20:35:26', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (242, 'SPREI SEKALI PAKAI', 'SPREI SEKALI PAKAI', NULL, NULL, 22, 1, 16, '2023-02-08 20:35:56', NULL, '2023-02-08 20:35:56', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (243, 'MINYAK AROMATERAPHY LEMON', 'MINYAK ARO L', NULL, NULL, 27, 1, 16, '2023-02-08 20:36:49', NULL, '2023-02-08 20:36:49', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (244, 'MINYAK AROMATERAPHY ORANGE', 'MINYAK ARO ORANGE', NULL, NULL, 27, 1, 16, '2023-02-08 20:37:49', NULL, '2023-02-08 20:37:49', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (268, 'BEDAK THAI PAKAI', 'BEDAK THAI PAKAI', NULL, NULL, 22, 1, 19, '2023-02-09 19:09:10', NULL, '2023-02-09 19:09:10', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (246, 'SPREI MATRAS BALE-BALE', 'SPREI MATRAS BALE-BALE', NULL, NULL, 22, 1, 16, '2023-02-08 20:37:57', NULL, '2023-02-08 20:37:57', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (247, 'SPREI MATRAS REFLEKSI + KURSI', 'SPREI MATRAS REFLEKSI + KURSI', NULL, NULL, 22, 1, 16, '2023-02-08 20:38:34', NULL, '2023-02-08 20:38:34', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (248, 'PENCETAN KOMEDO', 'PENCETAN KOMEDO', NULL, NULL, 22, 1, 16, '2023-02-08 20:38:53', NULL, '2023-02-08 20:38:52', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (249, 'SPREI MATRAS TERAPIS', 'SPREI MATRAS TERAPIS', NULL, NULL, 22, 1, 16, '2023-02-08 20:39:36', NULL, '2023-02-08 20:39:36', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (250, 'PENJEPIT RATUS DAN HOT STONE', 'PENJEPIT RATUS DAN HS', NULL, NULL, 22, 1, 16, '2023-02-08 20:40:08', NULL, '2023-02-08 20:40:08', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (286, 'HOT STONE', 'HS', NULL, NULL, 44, 2, 19, '2023-02-10 10:34:43', NULL, '2023-02-10 10:34:43', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (290, 'TOTOK WAJAH', 'AA', NULL, NULL, 48, 2, 19, '2023-02-10 10:35:38', NULL, '2023-02-10 10:35:38', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (294, 'BACK MASSAGE', 'BACK', NULL, NULL, 44, 2, 19, '2023-02-10 10:37:28', NULL, '2023-02-10 10:37:28', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (298, 'BREAST', 'BREAST', NULL, NULL, 49, 2, 19, '2023-02-10 14:33:31', NULL, '2023-02-10 14:33:31', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (276, 'GOLDA', 'GOLDA', NULL, NULL, 26, 1, 19, '2023-02-09 19:15:41', NULL, '2023-02-09 19:15:41', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (302, 'BODY BLEACHING', 'BODY BLEACHING', NULL, NULL, 50, 2, 19, '2023-02-10 14:37:35', NULL, '2023-02-10 14:37:35', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (306, 'JELLY FOOT SPA', 'JFS', NULL, NULL, 51, 2, 19, '2023-02-10 14:40:42', NULL, '2023-02-10 14:40:41', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (318, 'EXTRA CHARGE MIDNIGHT 21:00', 'CASMID21', NULL, NULL, 52, 8, 19, '2023-02-10 15:01:22', NULL, '2023-02-10 14:57:28', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (310, 'EXTRA TIME BODY COP', 'BCP', NULL, NULL, 6, 2, 19, '2023-02-10 14:49:52', NULL, '2023-02-10 14:49:52', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (322, 'FLORIDINA', 'FLORIDINA', NULL, NULL, 26, 1, 16, '2023-02-14 16:56:00', NULL, '2023-02-14 16:56:00', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (282, 'FULL BODY HERBAL COMPRESS', 'BHC', NULL, NULL, 44, 2, 19, '2023-02-10 10:33:36', NULL, '2023-02-10 10:33:36', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (287, 'EAR CANDLING', 'EC', NULL, NULL, 48, 2, 19, '2023-02-10 10:35:05', NULL, '2023-02-10 10:35:05', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (277, 'MILK KU', 'MILK KU', NULL, NULL, 26, 1, 19, '2023-02-09 19:16:23', NULL, '2023-02-09 19:16:23', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (291, 'FULL BODY REFLEXOLOGY', 'FBR', NULL, NULL, 44, 2, 19, '2023-02-10 10:36:24', NULL, '2023-02-10 10:36:24', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (295, 'BODY COP W/ MASSAGE', 'BCM', NULL, NULL, 44, 2, 19, '2023-02-10 10:40:46', NULL, '2023-02-10 10:40:46', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (299, 'RATUS W / HM', 'RATUS', NULL, NULL, 49, 2, 19, '2023-02-10 14:34:19', NULL, '2023-02-10 14:34:19', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (307, 'FOOT REFLEXOLOGY', 'FOOT', NULL, NULL, 51, 2, 19, '2023-02-10 14:41:55', NULL, '2023-02-10 14:41:55', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (315, 'MASKER BADAN', 'MB', NULL, NULL, 6, 2, 19, '2023-02-10 14:54:26', NULL, '2023-02-10 14:54:26', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (254, 'BUNGAN JEPUN - MILK BATH SACHET', 'MILK BATH SACHET', NULL, NULL, 22, 1, 20, '2023-02-09 18:54:26', NULL, '2023-02-09 18:54:26', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (323, 'BALI ALUS - BATH SALT SACHET', 'BATH SALT SACHET', NULL, NULL, 19, 1, 20, '2023-02-14 17:14:50', NULL, '2023-02-14 17:14:50', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (319, 'EXTRA CHARGE MIDNIGHT 22:00', 'CASMID22', NULL, NULL, 52, 8, 19, '2023-02-10 15:01:39', NULL, '2023-02-10 14:59:04', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (264, 'SPONGE WAJAH PAKAI', 'SPONGE WAJAH PAKAI', NULL, NULL, 22, 1, 20, '2023-02-09 19:06:15', NULL, '2023-02-09 19:06:15', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (269, 'STELLA SPRAY PAKAI', 'STELLA SPRAY PAKAI', NULL, NULL, 22, 1, 19, '2023-02-09 19:10:19', NULL, '2023-02-09 19:09:54', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (273, 'GREAT CUP PAKAI', 'GREAT CUP PAKAI', NULL, NULL, 26, 1, 19, '2023-02-09 19:12:57', NULL, '2023-02-09 19:12:28', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (283, 'SHIATSU', 'ST', NULL, NULL, 44, 2, 19, '2023-02-10 10:34:12', NULL, '2023-02-10 10:34:12', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (288, 'DRY MASSAGE', 'DRY', NULL, NULL, 44, 2, 19, '2023-02-10 10:35:08', NULL, '2023-02-10 10:35:06', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (292, 'PERAWATAN SAYANG SUAMI', 'V SPA', NULL, NULL, 49, 2, 19, '2023-02-10 10:36:33', NULL, '2023-02-10 10:36:33', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (296, 'SLIMMING & BREAST', 'SLIMMING & BREAST', NULL, NULL, 49, 2, 19, '2023-02-10 14:31:42', NULL, '2023-02-10 14:31:42', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (304, 'BALI ALUS BODY SCRUB LIGHTENING', 'BABSL', NULL, NULL, 50, 2, 19, '2023-02-10 14:39:00', NULL, '2023-02-10 14:39:00', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (308, 'FOOT REFLEXOLOGY EXSPRESS', 'FOOT EXSPRESS', NULL, NULL, 51, 2, 19, '2023-02-10 14:43:12', NULL, '2023-02-10 14:43:12', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (312, 'LULURAN AROMATHERAPY', 'LA', NULL, NULL, 50, 2, 19, '2023-02-10 14:51:53', NULL, '2023-02-10 14:51:53', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (255, 'BUNGAN JEPUN - MASKER BADAN SACHET', 'MASKER BADAN SACHET', NULL, NULL, 22, 1, 20, '2023-02-09 18:56:31', NULL, '2023-02-09 18:56:31', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (260, 'TISU TOILET', 'TISU TOILET', NULL, NULL, 22, 1, 19, '2023-02-09 19:02:10', NULL, '2023-02-09 19:02:10', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (265, 'SPONGE MANDI PAKAI', 'SPONGE MANDI PAKAI', NULL, NULL, 22, 1, 19, '2023-02-09 19:07:24', NULL, '2023-02-09 19:07:24', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (270, 'MOLTO PAKAI', 'MOLTO PAKAI', NULL, NULL, 22, 1, 19, '2023-02-09 19:10:50', NULL, '2023-02-09 19:10:50', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (274, 'TEH BANDULAN BOTOL', 'BDL BTL', NULL, NULL, 26, 1, 19, '2023-02-09 19:13:43', NULL, '2023-02-09 19:13:43', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (300, 'EXECUTIVE BALI BODY SCRUB LIGHTENING', 'EBBSL', NULL, NULL, 50, 2, 19, '2023-02-10 15:06:57', NULL, '2023-02-10 14:35:43', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (320, 'SPREI LULURAN / GANTI-GANTI', 'SPREI LULURAN', NULL, NULL, 22, 1, 20, '2023-02-10 16:02:59', NULL, '2023-02-10 16:02:58', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (278, 'BALI ALUS - GARAM JELLY SACHET', 'GARAM JELLY SACHET', NULL, NULL, 19, 1, 10, '2023-02-14 17:12:44', NULL, '2023-02-09 19:17:52', 1, 0, 1, 'goods.png', NULL);
INSERT INTO public.product_sku VALUES (316, 'EXTRA TIME', 'ET', NULL, NULL, 6, 8, 19, '2023-02-10 15:00:58', NULL, '2023-02-10 14:55:05', 1, 0, 1, 'goods.png', NULL);


--
-- TOC entry 3748 (class 0 OID 18178)
-- Dependencies: 252
-- Data for Name: product_stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_stock VALUES (194, 14, 14, '2023-02-14 16:34:49', '2023-02-14 16:34:49', 1);
INSERT INTO public.product_stock VALUES (95, 14, 27, '2023-02-14 16:36:53', '2023-02-14 16:36:53', 1);
INSERT INTO public.product_stock VALUES (105, 14, 10, '2023-02-14 16:37:26', '2023-02-14 16:37:26', 1);
INSERT INTO public.product_stock VALUES (253, 14, 20, '2023-02-14 16:37:56', '2023-02-14 16:37:56', 1);
INSERT INTO public.product_stock VALUES (96, 14, 1, '2023-02-14 16:38:27', '2023-02-14 16:38:27', 1);
INSERT INTO public.product_stock VALUES (206, 14, 5, '2023-02-14 16:39:05', '2023-02-14 16:39:05', 1);
INSERT INTO public.product_stock VALUES (101, 14, 7, '2023-02-14 16:39:18', '2023-02-14 16:39:18', 1);
INSERT INTO public.product_stock VALUES (111, 14, 9, '2023-02-14 16:39:45', '2023-02-14 16:39:45', 1);
INSERT INTO public.product_stock VALUES (112, 14, 3, '2023-02-14 16:40:13', '2023-02-14 16:40:13', 1);
INSERT INTO public.product_stock VALUES (122, 14, 1, '2023-02-14 16:40:25', '2023-02-14 16:40:25', 1);
INSERT INTO public.product_stock VALUES (125, 14, 6, '2023-02-14 16:40:51', '2023-02-14 16:40:51', 1);
INSERT INTO public.product_stock VALUES (180, 14, 60, '2023-02-14 16:42:01', '2023-02-14 16:42:01', 1);
INSERT INTO public.product_stock VALUES (182, 14, 72, '2023-02-14 16:43:10', '2023-02-14 16:43:10', 1);
INSERT INTO public.product_stock VALUES (142, 14, 4, '2023-02-14 16:43:31', '2023-02-14 16:43:31', 1);
INSERT INTO public.product_stock VALUES (244, 14, 6, '2023-02-14 16:44:06', '2023-02-14 16:44:06', 1);
INSERT INTO public.product_stock VALUES (139, 14, 53, '2023-02-14 16:45:09', '2023-02-14 16:45:09', 1);
INSERT INTO public.product_stock VALUES (188, 14, 5, '2023-02-14 16:45:27', '2023-02-14 16:45:27', 1);
INSERT INTO public.product_stock VALUES (164, 14, 12, '2023-02-14 16:45:50', '2023-02-14 16:45:50', 1);
INSERT INTO public.product_stock VALUES (225, 14, 0, '2023-02-14 16:46:19', '2023-02-14 16:46:19', 1);
INSERT INTO public.product_stock VALUES (227, 14, 0, '2023-02-14 16:46:39', '2023-02-14 16:46:39', 1);
INSERT INTO public.product_stock VALUES (223, 14, 0, '2023-02-14 16:46:56', '2023-02-14 16:46:56', 1);
INSERT INTO public.product_stock VALUES (220, 14, 0, '2023-02-14 16:47:13', '2023-02-14 16:47:13', 1);
INSERT INTO public.product_stock VALUES (235, 14, 23, '2023-02-14 16:47:45', '2023-02-14 16:47:45', 1);
INSERT INTO public.product_stock VALUES (231, 14, 0, '2023-02-14 16:48:10', '2023-02-14 16:48:10', 1);
INSERT INTO public.product_stock VALUES (233, 14, 2, '2023-02-14 16:48:27', '2023-02-14 16:48:27', 1);
INSERT INTO public.product_stock VALUES (175, 14, 1, '2023-02-14 16:48:50', '2023-02-14 16:48:50', 1);
INSERT INTO public.product_stock VALUES (267, 14, 23, '2023-02-14 16:49:38', '2023-02-14 16:49:38', 1);
INSERT INTO public.product_stock VALUES (269, 14, 0, '2023-02-14 16:50:21', '2023-02-14 16:50:21', 1);
INSERT INTO public.product_stock VALUES (268, 14, 0, '2023-02-14 16:50:49', '2023-02-14 16:50:49', 1);
INSERT INTO public.product_stock VALUES (270, 14, 3, '2023-02-14 16:51:06', '2023-02-14 16:51:06', 1);
INSERT INTO public.product_stock VALUES (273, 14, 257, '2023-02-14 16:52:27', '2023-02-14 16:52:27', 1);
INSERT INTO public.product_stock VALUES (271, 14, 1, '2023-02-14 16:55:04', '2023-02-14 16:55:04', 1);
INSERT INTO public.product_stock VALUES (129, 14, 0, '2023-02-14 16:55:58', '2023-02-14 16:55:58', 1);
INSERT INTO public.product_stock VALUES (103, 14, 6, '2023-02-14 16:57:18', '2023-02-14 16:39:53', 1);
INSERT INTO public.product_stock VALUES (279, 14, 366, '2023-02-14 16:57:23', '2023-02-14 16:57:23', 1);
INSERT INTO public.product_stock VALUES (104, 14, 4, '2023-02-14 16:58:43', '2023-02-14 16:58:43', 1);
INSERT INTO public.product_stock VALUES (128, 14, 0, '2023-02-14 17:02:38', '2023-02-14 16:40:42', 1);
INSERT INTO public.product_stock VALUES (236, 14, 0, '2023-02-14 17:03:45', '2023-02-14 16:41:40', 1);
INSERT INTO public.product_stock VALUES (260, 14, 26, '2023-02-14 17:04:19', '2023-02-14 16:42:39', 1);
INSERT INTO public.product_stock VALUES (261, 14, 467, '2023-02-14 17:04:55', '2023-02-14 16:43:55', 1);
INSERT INTO public.product_stock VALUES (146, 14, 630, '2023-02-14 17:05:35', '2023-02-14 16:44:45', 1);
INSERT INTO public.product_stock VALUES (262, 14, 7, '2023-02-14 17:07:03', '2023-02-14 17:07:03', 1);
INSERT INTO public.product_stock VALUES (94, 14, 18, '2023-02-14 17:15:12', '2023-02-14 17:15:12', 1);
INSERT INTO public.product_stock VALUES (297, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (305, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (313, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (317, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (309, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (321, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (113, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (115, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (118, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (280, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (117, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (131, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (120, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (138, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (137, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (102, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (100, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (136, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (109, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (110, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (134, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (133, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (116, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (130, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (127, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (114, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (119, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (123, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (126, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (132, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (97, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (140, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (143, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (147, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (149, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (150, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (151, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (152, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (153, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (154, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (155, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (156, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (158, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (159, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (160, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (174, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (166, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (167, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (168, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (169, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (170, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (171, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (172, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (173, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (176, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (177, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (178, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (179, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (187, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (181, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (184, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (301, 14, -1, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (284, 14, -10, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (289, 14, -14, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (293, 14, -3, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (92, 14, 43, '2023-02-14 16:33:56', '2023-02-14 16:33:56', 1);
INSERT INTO public.product_stock VALUES (285, 14, -1, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (251, 14, -6, '2023-02-14 16:35:44', '2023-02-14 16:35:44', 1);
INSERT INTO public.product_stock VALUES (91, 14, 32, '2023-02-14 16:34:25', '2023-02-14 16:34:25', 1);
INSERT INTO public.product_stock VALUES (108, 14, 3, '2023-02-14 16:36:20', '2023-02-14 16:36:20', 1);
INSERT INTO public.product_stock VALUES (106, 14, 17, '2023-02-14 16:37:35', '2023-02-14 16:37:35', 1);
INSERT INTO public.product_stock VALUES (107, 14, 6, '2023-02-14 16:38:06', '2023-02-14 16:38:06', 1);
INSERT INTO public.product_stock VALUES (255, 14, 0, '2023-02-14 16:38:27', '2023-02-14 16:38:27', 1);
INSERT INTO public.product_stock VALUES (202, 14, 8, '2023-02-14 16:38:49', '2023-02-14 16:37:25', 1);
INSERT INTO public.product_stock VALUES (254, 14, 1, '2023-02-14 16:39:17', '2023-02-14 16:39:17', 1);
INSERT INTO public.product_stock VALUES (193, 14, 2, '2023-02-14 16:39:35', '2023-02-14 16:39:35', 1);
INSERT INTO public.product_stock VALUES (99, 14, 17, '2023-02-14 16:39:47', '2023-02-14 16:39:47', 1);
INSERT INTO public.product_stock VALUES (124, 14, 7, '2023-02-14 16:39:57', '2023-02-14 16:39:57', 1);
INSERT INTO public.product_stock VALUES (257, 14, 4, '2023-02-14 16:40:19', '2023-02-14 16:40:19', 1);
INSERT INTO public.product_stock VALUES (121, 14, 1, '2023-02-14 16:40:41', '2023-02-14 16:40:41', 1);
INSERT INTO public.product_stock VALUES (98, 14, 14, '2023-02-14 16:40:45', '2023-02-14 16:40:45', 1);
INSERT INTO public.product_stock VALUES (256, 14, 3, '2023-02-14 16:41:08', '2023-02-14 16:41:08', 1);
INSERT INTO public.product_stock VALUES (199, 14, 13, '2023-02-14 16:41:49', '2023-02-14 16:41:49', 1);
INSERT INTO public.product_stock VALUES (183, 14, 84, '2023-02-14 16:42:25', '2023-02-14 16:42:25', 1);
INSERT INTO public.product_stock VALUES (217, 14, 23, '2023-02-14 16:42:58', '2023-02-14 16:42:58', 1);
INSERT INTO public.product_stock VALUES (234, 14, 0, '2023-02-14 16:43:30', '2023-02-14 16:43:30', 1);
INSERT INTO public.product_stock VALUES (252, 14, 10, '2023-02-14 16:43:51', '2023-02-14 16:43:51', 1);
INSERT INTO public.product_stock VALUES (264, 14, 30, '2023-02-14 16:44:01', '2023-02-14 16:44:01', 1);
INSERT INTO public.product_stock VALUES (135, 14, 2, '2023-02-14 16:44:22', '2023-02-14 16:44:22', 1);
INSERT INTO public.product_stock VALUES (241, 14, 6, '2023-02-14 16:44:47', '2023-02-14 16:44:47', 1);
INSERT INTO public.product_stock VALUES (163, 14, 19, '2023-02-14 16:45:11', '2023-02-14 16:45:11', 1);
INSERT INTO public.product_stock VALUES (162, 14, 14, '2023-02-14 16:45:31', '2023-02-14 16:45:31', 1);
INSERT INTO public.product_stock VALUES (165, 14, 17, '2023-02-14 16:46:09', '2023-02-14 16:46:09', 1);
INSERT INTO public.product_stock VALUES (157, 14, 0, '2023-02-14 16:46:37', '2023-02-14 16:46:37', 1);
INSERT INTO public.product_stock VALUES (191, 14, 30, '2023-02-14 16:46:51', '2023-02-14 16:46:51', 1);
INSERT INTO public.product_stock VALUES (192, 14, 20, '2023-02-14 16:47:07', '2023-02-14 16:47:07', 1);
INSERT INTO public.product_stock VALUES (229, 14, 19, '2023-02-14 16:47:27', '2023-02-14 16:47:27', 1);
INSERT INTO public.product_stock VALUES (228, 14, 2, '2023-02-14 16:47:51', '2023-02-14 16:47:51', 1);
INSERT INTO public.product_stock VALUES (161, 14, 0, '2023-02-14 16:48:17', '2023-02-14 16:48:17', 1);
INSERT INTO public.product_stock VALUES (265, 14, 4, '2023-02-14 16:48:47', '2023-02-14 16:48:47', 1);
INSERT INTO public.product_stock VALUES (266, 14, 0, '2023-02-14 16:49:05', '2023-02-14 16:49:05', 1);
INSERT INTO public.product_stock VALUES (277, 14, 0, '2023-02-14 16:52:00', '2023-02-14 16:52:00', 1);
INSERT INTO public.product_stock VALUES (272, 14, 1, '2023-02-14 16:55:40', '2023-02-14 16:55:40', 1);
INSERT INTO public.product_stock VALUES (141, 14, 0, '2023-02-14 16:56:54', '2023-02-14 16:56:54', 1);
INSERT INTO public.product_stock VALUES (278, 14, 76, '2023-02-14 16:59:03', '2023-02-14 16:59:03', 1);
INSERT INTO public.product_stock VALUES (186, 14, 64, '2023-02-14 17:06:15', '2023-02-14 16:52:32', 1);
INSERT INTO public.product_stock VALUES (203, 14, 34, '2023-02-14 17:07:35', '2023-02-14 17:07:35', 1);
INSERT INTO public.product_stock VALUES (323, 14, 154, '2023-02-14 17:15:54', '2023-02-14 17:15:54', 1);
INSERT INTO public.product_stock VALUES (185, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (189, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (190, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (195, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (198, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (200, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (201, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (204, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (205, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (207, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (208, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (209, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (237, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (211, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (210, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (212, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (213, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (214, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (215, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (216, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (221, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (281, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (226, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (263, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (232, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (238, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (239, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (242, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (243, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (246, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (247, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (248, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (249, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (250, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (286, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (288, 14, -1, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (298, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (302, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (306, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (287, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (295, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (299, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (315, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (319, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (283, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (292, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (296, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (282, 14, -2, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (304, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (274, 14, 60, '2023-02-14 16:50:10', '2023-02-14 16:50:10', 1);
INSERT INTO public.product_stock VALUES (308, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (93, 14, -1, '2023-02-14 16:35:07', '2023-02-14 16:35:07', 1);
INSERT INTO public.product_stock VALUES (312, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (316, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (300, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (320, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (290, 14, 0, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (318, 14, -1, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (307, 14, -1, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (310, 14, -1, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (275, 14, 58, '2023-02-14 16:50:32', '2023-02-14 16:50:32', 1);
INSERT INTO public.product_stock VALUES (322, 14, 0, '2023-02-14 16:57:32', '2023-02-14 16:57:32', 1);
INSERT INTO public.product_stock VALUES (276, 14, 10, '2023-02-14 16:50:56', '2023-02-14 16:50:56', 1);
INSERT INTO public.product_stock VALUES (294, 14, -1, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);
INSERT INTO public.product_stock VALUES (291, 14, -3, '2023-02-15 11:38:04.346426', '2023-02-15 11:38:04.346426', 1);


--
-- TOC entry 3749 (class 0 OID 18183)
-- Dependencies: 253
-- Data for Name: product_stock_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3751 (class 0 OID 18191)
-- Dependencies: 255
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_type VALUES (3, 'Goods & Services', '2022-06-01 21:02:38.43164', NULL, 'Mix');
INSERT INTO public.product_type VALUES (2, 'Services', '2022-06-01 21:02:38.43164', NULL, 'Perawatan');
INSERT INTO public.product_type VALUES (7, 'Misc', '2022-07-25 14:53:50', '2022-07-25 14:53:50', 'Misc');
INSERT INTO public.product_type VALUES (8, 'Extra', '2022-10-09 03:05:18', '2022-10-09 03:05:18', 'Extra');
INSERT INTO public.product_type VALUES (1, 'Goods', '2022-06-01 21:02:38.43164', '2023-02-06 18:36:10', 'Produk');


--
-- TOC entry 3753 (class 0 OID 18200)
-- Dependencies: 257
-- Data for Name: product_uom; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_uom VALUES (91, 25, '2023-02-08 18:53:04', NULL, '2023-02-08 18:53:04');
INSERT INTO public.product_uom VALUES (92, 25, '2023-02-08 18:53:26', NULL, '2023-02-08 18:53:26');
INSERT INTO public.product_uom VALUES (93, 25, '2023-02-08 19:01:44', NULL, '2023-02-08 19:01:44');
INSERT INTO public.product_uom VALUES (94, 30, '2023-02-08 19:02:06', NULL, '2023-02-08 19:02:06');
INSERT INTO public.product_uom VALUES (95, 28, '2023-02-08 19:04:49', NULL, '2023-02-08 19:04:49');
INSERT INTO public.product_uom VALUES (96, 30, '2023-02-08 19:06:52', NULL, '2023-02-08 19:06:52');
INSERT INTO public.product_uom VALUES (97, 42, '2023-02-08 19:10:36', NULL, '2023-02-08 19:10:36');
INSERT INTO public.product_uom VALUES (98, 30, '2023-02-08 19:12:29', NULL, '2023-02-08 19:12:29');
INSERT INTO public.product_uom VALUES (99, 30, '2023-02-08 19:14:35', NULL, '2023-02-08 19:14:35');
INSERT INTO public.product_uom VALUES (100, 31, '2023-02-08 19:16:11', NULL, '2023-02-08 19:16:11');
INSERT INTO public.product_uom VALUES (101, 27, '2023-02-08 19:19:28', NULL, '2023-02-08 19:19:28');
INSERT INTO public.product_uom VALUES (102, 28, '2023-02-08 19:19:47', NULL, '2023-02-08 19:19:47');
INSERT INTO public.product_uom VALUES (103, 25, '2023-02-08 19:21:08', NULL, '2023-02-08 19:21:08');
INSERT INTO public.product_uom VALUES (104, 28, '2023-02-08 19:21:19', NULL, '2023-02-08 19:21:19');
INSERT INTO public.product_uom VALUES (105, 25, '2023-02-08 19:22:20', NULL, '2023-02-08 19:22:20');
INSERT INTO public.product_uom VALUES (106, 27, '2023-02-08 19:24:27', NULL, '2023-02-08 19:24:27');
INSERT INTO public.product_uom VALUES (107, 27, '2023-02-08 19:26:03', NULL, '2023-02-08 19:26:03');
INSERT INTO public.product_uom VALUES (108, 25, '2023-02-08 19:29:18', NULL, '2023-02-08 19:29:18');
INSERT INTO public.product_uom VALUES (109, 27, '2023-02-08 19:29:49', NULL, '2023-02-08 19:29:49');
INSERT INTO public.product_uom VALUES (110, 29, '2023-02-08 19:32:00', NULL, '2023-02-08 19:32:00');
INSERT INTO public.product_uom VALUES (111, 27, '2023-02-08 19:33:14', NULL, '2023-02-08 19:33:14');
INSERT INTO public.product_uom VALUES (112, 27, '2023-02-08 19:35:21', NULL, '2023-02-08 19:35:21');
INSERT INTO public.product_uom VALUES (113, 36, '2023-02-08 19:35:45', NULL, '2023-02-08 19:35:45');
INSERT INTO public.product_uom VALUES (114, 30, '2023-02-08 19:36:47', NULL, '2023-02-08 19:36:47');
INSERT INTO public.product_uom VALUES (115, 30, '2023-02-08 19:38:04', NULL, '2023-02-08 19:38:04');
INSERT INTO public.product_uom VALUES (116, 34, '2023-02-08 19:38:17', NULL, '2023-02-08 19:38:17');
INSERT INTO public.product_uom VALUES (117, 30, '2023-02-08 19:39:06', NULL, '2023-02-08 19:39:06');
INSERT INTO public.product_uom VALUES (118, 30, '2023-02-08 19:40:04', NULL, '2023-02-08 19:40:04');
INSERT INTO public.product_uom VALUES (119, 27, '2023-02-08 19:40:22', NULL, '2023-02-08 19:40:22');
INSERT INTO public.product_uom VALUES (120, 30, '2023-02-08 19:41:04', NULL, '2023-02-08 19:41:04');
INSERT INTO public.product_uom VALUES (121, 32, '2023-02-08 19:41:10', NULL, '2023-02-08 19:41:10');
INSERT INTO public.product_uom VALUES (122, 32, '2023-02-08 19:41:40', NULL, '2023-02-08 19:41:40');
INSERT INTO public.product_uom VALUES (123, 34, '2023-02-08 19:42:25', NULL, '2023-02-08 19:42:25');
INSERT INTO public.product_uom VALUES (124, 32, '2023-02-08 19:43:50', NULL, '2023-02-08 19:43:50');
INSERT INTO public.product_uom VALUES (125, 27, '2023-02-08 19:44:03', NULL, '2023-02-08 19:44:03');
INSERT INTO public.product_uom VALUES (126, 41, '2023-02-08 19:44:11', NULL, '2023-02-08 19:44:11');
INSERT INTO public.product_uom VALUES (127, 36, '2023-02-08 19:44:32', NULL, '2023-02-08 19:44:32');
INSERT INTO public.product_uom VALUES (128, 30, '2023-02-08 19:44:40', NULL, '2023-02-08 19:44:40');
INSERT INTO public.product_uom VALUES (129, 29, '2023-02-08 19:45:14', NULL, '2023-02-08 19:45:14');
INSERT INTO public.product_uom VALUES (130, 36, '2023-02-08 19:45:17', NULL, '2023-02-08 19:45:17');
INSERT INTO public.product_uom VALUES (131, 27, '2023-02-08 19:45:27', NULL, '2023-02-08 19:45:27');
INSERT INTO public.product_uom VALUES (132, 29, '2023-02-08 19:45:52', NULL, '2023-02-08 19:45:52');
INSERT INTO public.product_uom VALUES (133, 36, '2023-02-08 19:45:54', NULL, '2023-02-08 19:45:54');
INSERT INTO public.product_uom VALUES (134, 36, '2023-02-08 19:46:36', NULL, '2023-02-08 19:46:36');
INSERT INTO public.product_uom VALUES (135, 30, '2023-02-08 19:46:56', NULL, '2023-02-08 19:46:56');
INSERT INTO public.product_uom VALUES (136, 36, '2023-02-08 19:47:10', NULL, '2023-02-08 19:47:10');
INSERT INTO public.product_uom VALUES (137, 36, '2023-02-08 19:47:34', NULL, '2023-02-08 19:47:34');
INSERT INTO public.product_uom VALUES (138, 27, '2023-02-08 19:48:06', NULL, '2023-02-08 19:48:06');
INSERT INTO public.product_uom VALUES (139, 34, '2023-02-08 19:49:07', NULL, '2023-02-08 19:49:07');
INSERT INTO public.product_uom VALUES (140, 29, '2023-02-08 19:49:55', NULL, '2023-02-08 19:49:55');
INSERT INTO public.product_uom VALUES (141, 35, '2023-02-08 19:50:36', NULL, '2023-02-08 19:50:36');
INSERT INTO public.product_uom VALUES (142, 27, '2023-02-08 19:52:07', NULL, '2023-02-08 19:52:07');
INSERT INTO public.product_uom VALUES (143, 29, '2023-02-08 19:52:13', NULL, '2023-02-08 19:52:13');
INSERT INTO public.product_uom VALUES (146, 28, '2023-02-08 19:53:28', NULL, '2023-02-08 19:53:28');
INSERT INTO public.product_uom VALUES (147, 29, '2023-02-08 19:54:06', NULL, '2023-02-08 19:54:06');
INSERT INTO public.product_uom VALUES (149, 29, '2023-02-08 19:54:46', NULL, '2023-02-08 19:54:46');
INSERT INTO public.product_uom VALUES (150, 29, '2023-02-08 19:54:56', NULL, '2023-02-08 19:54:56');
INSERT INTO public.product_uom VALUES (151, 29, '2023-02-08 19:55:12', NULL, '2023-02-08 19:55:12');
INSERT INTO public.product_uom VALUES (152, 29, '2023-02-08 19:55:32', NULL, '2023-02-08 19:55:32');
INSERT INTO public.product_uom VALUES (153, 29, '2023-02-08 19:55:40', NULL, '2023-02-08 19:55:40');
INSERT INTO public.product_uom VALUES (154, 29, '2023-02-08 19:56:02', NULL, '2023-02-08 19:56:02');
INSERT INTO public.product_uom VALUES (155, 29, '2023-02-08 19:56:15', NULL, '2023-02-08 19:56:15');
INSERT INTO public.product_uom VALUES (156, 29, '2023-02-08 19:56:59', NULL, '2023-02-08 19:56:59');
INSERT INTO public.product_uom VALUES (157, 27, '2023-02-08 19:57:41', NULL, '2023-02-08 19:57:41');
INSERT INTO public.product_uom VALUES (158, 29, '2023-02-08 19:58:59', NULL, '2023-02-08 19:58:59');
INSERT INTO public.product_uom VALUES (159, 29, '2023-02-08 19:59:36', NULL, '2023-02-08 19:59:36');
INSERT INTO public.product_uom VALUES (160, 29, '2023-02-08 19:59:47', NULL, '2023-02-08 19:59:47');
INSERT INTO public.product_uom VALUES (161, 30, '2023-02-08 20:00:14', NULL, '2023-02-08 20:00:14');
INSERT INTO public.product_uom VALUES (162, 29, '2023-02-08 20:00:54', NULL, '2023-02-08 20:00:54');
INSERT INTO public.product_uom VALUES (163, 27, '2023-02-08 20:00:55', NULL, '2023-02-08 20:00:55');
INSERT INTO public.product_uom VALUES (164, 29, '2023-02-08 20:01:23', NULL, '2023-02-08 20:01:23');
INSERT INTO public.product_uom VALUES (165, 25, '2023-02-08 20:01:31', NULL, '2023-02-08 20:01:31');
INSERT INTO public.product_uom VALUES (166, 29, '2023-02-08 20:02:26', NULL, '2023-02-08 20:02:26');
INSERT INTO public.product_uom VALUES (167, 38, '2023-02-08 20:02:55', NULL, '2023-02-08 20:02:55');
INSERT INTO public.product_uom VALUES (168, 38, '2023-02-08 20:03:20', NULL, '2023-02-08 20:03:20');
INSERT INTO public.product_uom VALUES (169, 38, '2023-02-08 20:03:51', NULL, '2023-02-08 20:03:51');
INSERT INTO public.product_uom VALUES (170, 29, '2023-02-08 20:04:09', NULL, '2023-02-08 20:04:09');
INSERT INTO public.product_uom VALUES (171, 29, '2023-02-08 20:04:47', NULL, '2023-02-08 20:04:47');
INSERT INTO public.product_uom VALUES (172, 29, '2023-02-08 20:05:18', NULL, '2023-02-08 20:05:18');
INSERT INTO public.product_uom VALUES (173, 37, '2023-02-08 20:06:50', NULL, '2023-02-08 20:06:50');
INSERT INTO public.product_uom VALUES (174, 38, '2023-02-08 20:07:29', NULL, '2023-02-08 20:07:29');
INSERT INTO public.product_uom VALUES (175, 36, '2023-02-08 20:08:06', NULL, '2023-02-08 20:08:06');
INSERT INTO public.product_uom VALUES (176, 29, '2023-02-08 20:08:28', NULL, '2023-02-08 20:08:28');
INSERT INTO public.product_uom VALUES (177, 34, '2023-02-08 20:09:08', NULL, '2023-02-08 20:09:08');
INSERT INTO public.product_uom VALUES (178, 34, '2023-02-08 20:09:36', NULL, '2023-02-08 20:09:36');
INSERT INTO public.product_uom VALUES (179, 34, '2023-02-08 20:10:16', NULL, '2023-02-08 20:10:16');
INSERT INTO public.product_uom VALUES (180, 34, '2023-02-08 20:10:46', NULL, '2023-02-08 20:10:46');
INSERT INTO public.product_uom VALUES (181, 29, '2023-02-08 20:11:30', NULL, '2023-02-08 20:11:30');
INSERT INTO public.product_uom VALUES (182, 34, '2023-02-08 20:11:30', NULL, '2023-02-08 20:11:30');
INSERT INTO public.product_uom VALUES (183, 34, '2023-02-08 20:12:07', NULL, '2023-02-08 20:12:07');
INSERT INTO public.product_uom VALUES (184, 29, '2023-02-08 20:12:30', NULL, '2023-02-08 20:12:30');
INSERT INTO public.product_uom VALUES (185, 34, '2023-02-08 20:12:48', NULL, '2023-02-08 20:12:48');
INSERT INTO public.product_uom VALUES (186, 40, '2023-02-08 20:12:55', NULL, '2023-02-08 20:12:55');
INSERT INTO public.product_uom VALUES (187, 34, '2023-02-08 20:13:58', NULL, '2023-02-08 20:13:58');
INSERT INTO public.product_uom VALUES (188, 29, '2023-02-08 20:14:16', NULL, '2023-02-08 20:14:16');
INSERT INTO public.product_uom VALUES (189, 34, '2023-02-08 20:14:23', NULL, '2023-02-08 20:14:23');
INSERT INTO public.product_uom VALUES (190, 34, '2023-02-08 20:14:58', NULL, '2023-02-08 20:14:58');
INSERT INTO public.product_uom VALUES (191, 29, '2023-02-08 20:15:03', NULL, '2023-02-08 20:15:03');
INSERT INTO public.product_uom VALUES (192, 29, '2023-02-08 20:15:58', NULL, '2023-02-08 20:15:58');
INSERT INTO public.product_uom VALUES (193, 32, '2023-02-08 20:18:16', NULL, '2023-02-08 20:18:16');
INSERT INTO public.product_uom VALUES (194, 31, '2023-02-08 20:18:55', NULL, '2023-02-08 20:18:55');
INSERT INTO public.product_uom VALUES (195, 29, '2023-02-08 20:19:28', NULL, '2023-02-08 20:19:28');
INSERT INTO public.product_uom VALUES (198, 29, '2023-02-08 20:20:18', NULL, '2023-02-08 20:20:18');
INSERT INTO public.product_uom VALUES (199, 31, '2023-02-08 20:20:39', NULL, '2023-02-08 20:20:39');
INSERT INTO public.product_uom VALUES (200, 38, '2023-02-08 20:20:50', NULL, '2023-02-08 20:20:50');
INSERT INTO public.product_uom VALUES (201, 29, '2023-02-08 20:20:54', NULL, '2023-02-08 20:20:54');
INSERT INTO public.product_uom VALUES (202, 31, '2023-02-08 20:21:13', NULL, '2023-02-08 20:21:13');
INSERT INTO public.product_uom VALUES (203, 28, '2023-02-08 20:21:28', NULL, '2023-02-08 20:21:28');
INSERT INTO public.product_uom VALUES (204, 29, '2023-02-08 20:21:54', NULL, '2023-02-08 20:21:54');
INSERT INTO public.product_uom VALUES (205, 29, '2023-02-08 20:22:19', NULL, '2023-02-08 20:22:19');
INSERT INTO public.product_uom VALUES (206, 31, '2023-02-08 20:22:23', NULL, '2023-02-08 20:22:23');
INSERT INTO public.product_uom VALUES (207, 29, '2023-02-08 20:22:44', NULL, '2023-02-08 20:22:44');
INSERT INTO public.product_uom VALUES (208, 29, '2023-02-08 20:23:28', NULL, '2023-02-08 20:23:28');
INSERT INTO public.product_uom VALUES (209, 29, '2023-02-08 20:24:08', NULL, '2023-02-08 20:24:08');
INSERT INTO public.product_uom VALUES (210, 29, '2023-02-08 20:24:55', NULL, '2023-02-08 20:24:55');
INSERT INTO public.product_uom VALUES (211, 29, '2023-02-08 20:25:39', NULL, '2023-02-08 20:25:39');
INSERT INTO public.product_uom VALUES (212, 39, '2023-02-08 20:26:33', NULL, '2023-02-08 20:26:33');
INSERT INTO public.product_uom VALUES (213, 39, '2023-02-08 20:27:06', NULL, '2023-02-08 20:27:06');
INSERT INTO public.product_uom VALUES (214, 33, '2023-02-08 20:27:58', NULL, '2023-02-08 20:27:58');
INSERT INTO public.product_uom VALUES (215, 39, '2023-02-08 20:28:07', NULL, '2023-02-08 20:28:07');
INSERT INTO public.product_uom VALUES (216, 33, '2023-02-08 20:28:43', NULL, '2023-02-08 20:28:43');
INSERT INTO public.product_uom VALUES (217, 33, '2023-02-08 20:28:47', NULL, '2023-02-08 20:28:47');
INSERT INTO public.product_uom VALUES (220, 29, '2023-02-08 20:29:18', NULL, '2023-02-08 20:29:18');
INSERT INTO public.product_uom VALUES (221, 29, '2023-02-08 20:29:27', NULL, '2023-02-08 20:29:27');
INSERT INTO public.product_uom VALUES (223, 29, '2023-02-08 20:29:52', NULL, '2023-02-08 20:29:52');
INSERT INTO public.product_uom VALUES (225, 29, '2023-02-08 20:30:50', NULL, '2023-02-08 20:30:50');
INSERT INTO public.product_uom VALUES (226, 29, '2023-02-08 20:30:51', NULL, '2023-02-08 20:30:51');
INSERT INTO public.product_uom VALUES (227, 29, '2023-02-08 20:31:09', NULL, '2023-02-08 20:31:09');
INSERT INTO public.product_uom VALUES (228, 29, '2023-02-08 20:31:49', NULL, '2023-02-08 20:31:49');
INSERT INTO public.product_uom VALUES (229, 29, '2023-02-08 20:31:52', NULL, '2023-02-08 20:31:52');
INSERT INTO public.product_uom VALUES (231, 29, '2023-02-08 20:32:30', NULL, '2023-02-08 20:32:30');
INSERT INTO public.product_uom VALUES (232, 35, '2023-02-08 20:32:58', NULL, '2023-02-08 20:32:58');
INSERT INTO public.product_uom VALUES (233, 29, '2023-02-08 20:33:13', NULL, '2023-02-08 20:33:13');
INSERT INTO public.product_uom VALUES (234, 29, '2023-02-08 20:33:49', NULL, '2023-02-08 20:33:49');
INSERT INTO public.product_uom VALUES (235, 29, '2023-02-08 20:34:00', NULL, '2023-02-08 20:34:00');
INSERT INTO public.product_uom VALUES (236, 29, '2023-02-08 20:34:21', NULL, '2023-02-08 20:34:21');
INSERT INTO public.product_uom VALUES (237, 28, '2023-02-08 20:34:45', NULL, '2023-02-08 20:34:45');
INSERT INTO public.product_uom VALUES (238, 29, '2023-02-08 20:34:52', NULL, '2023-02-08 20:34:52');
INSERT INTO public.product_uom VALUES (239, 29, '2023-02-08 20:35:24', NULL, '2023-02-08 20:35:24');
INSERT INTO public.product_uom VALUES (241, 29, '2023-02-08 20:35:26', NULL, '2023-02-08 20:35:26');
INSERT INTO public.product_uom VALUES (242, 29, '2023-02-08 20:35:56', NULL, '2023-02-08 20:35:56');
INSERT INTO public.product_uom VALUES (243, 27, '2023-02-08 20:36:49', NULL, '2023-02-08 20:36:49');
INSERT INTO public.product_uom VALUES (244, 27, '2023-02-08 20:37:49', NULL, '2023-02-08 20:37:49');
INSERT INTO public.product_uom VALUES (246, 29, '2023-02-08 20:37:57', NULL, '2023-02-08 20:37:57');
INSERT INTO public.product_uom VALUES (247, 35, '2023-02-08 20:38:34', NULL, '2023-02-08 20:38:34');
INSERT INTO public.product_uom VALUES (248, 29, '2023-02-08 20:38:53', NULL, '2023-02-08 20:38:53');
INSERT INTO public.product_uom VALUES (249, 29, '2023-02-08 20:39:36', NULL, '2023-02-08 20:39:36');
INSERT INTO public.product_uom VALUES (250, 29, '2023-02-08 20:40:08', NULL, '2023-02-08 20:40:08');
INSERT INTO public.product_uom VALUES (251, 28, '2023-02-09 13:52:58', NULL, '2023-02-09 13:52:58');
INSERT INTO public.product_uom VALUES (252, 28, '2023-02-09 14:53:35', NULL, '2023-02-09 14:53:35');
INSERT INTO public.product_uom VALUES (253, 28, '2023-02-09 18:08:41', NULL, '2023-02-09 18:08:41');
INSERT INTO public.product_uom VALUES (254, 28, '2023-02-09 18:54:26', NULL, '2023-02-09 18:54:26');
INSERT INTO public.product_uom VALUES (255, 28, '2023-02-09 18:56:31', NULL, '2023-02-09 18:56:31');
INSERT INTO public.product_uom VALUES (256, 28, '2023-02-09 18:58:17', NULL, '2023-02-09 18:58:17');
INSERT INTO public.product_uom VALUES (257, 28, '2023-02-09 18:59:06', NULL, '2023-02-09 18:59:06');
INSERT INTO public.product_uom VALUES (260, 29, '2023-02-09 19:02:10', NULL, '2023-02-09 19:02:10');
INSERT INTO public.product_uom VALUES (261, 29, '2023-02-09 19:03:39', NULL, '2023-02-09 19:03:39');
INSERT INTO public.product_uom VALUES (262, 28, '2023-02-09 19:04:40', NULL, '2023-02-09 19:04:40');
INSERT INTO public.product_uom VALUES (263, 27, '2023-02-09 19:05:42', NULL, '2023-02-09 19:05:42');
INSERT INTO public.product_uom VALUES (264, 29, '2023-02-09 19:06:15', NULL, '2023-02-09 19:06:15');
INSERT INTO public.product_uom VALUES (265, 29, '2023-02-09 19:07:24', NULL, '2023-02-09 19:07:24');
INSERT INTO public.product_uom VALUES (266, 30, '2023-02-09 19:07:57', NULL, '2023-02-09 19:07:57');
INSERT INTO public.product_uom VALUES (267, 29, '2023-02-09 19:08:29', NULL, '2023-02-09 19:08:29');
INSERT INTO public.product_uom VALUES (268, 27, '2023-02-09 19:09:10', NULL, '2023-02-09 19:09:10');
INSERT INTO public.product_uom VALUES (269, 29, '2023-02-09 19:09:54', NULL, '2023-02-09 19:09:54');
INSERT INTO public.product_uom VALUES (270, 30, '2023-02-09 19:10:50', NULL, '2023-02-09 19:10:50');
INSERT INTO public.product_uom VALUES (271, 30, '2023-02-09 19:11:17', NULL, '2023-02-09 19:11:17');
INSERT INTO public.product_uom VALUES (272, 27, '2023-02-09 19:11:44', NULL, '2023-02-09 19:11:44');
INSERT INTO public.product_uom VALUES (273, 29, '2023-02-09 19:12:28', NULL, '2023-02-09 19:12:28');
INSERT INTO public.product_uom VALUES (274, 27, '2023-02-09 19:13:43', NULL, '2023-02-09 19:13:43');
INSERT INTO public.product_uom VALUES (275, 27, '2023-02-09 19:14:23', NULL, '2023-02-09 19:14:23');
INSERT INTO public.product_uom VALUES (276, 27, '2023-02-09 19:15:41', NULL, '2023-02-09 19:15:41');
INSERT INTO public.product_uom VALUES (277, 27, '2023-02-09 19:16:23', NULL, '2023-02-09 19:16:23');
INSERT INTO public.product_uom VALUES (278, 28, '2023-02-09 19:17:52', NULL, '2023-02-09 19:17:52');
INSERT INTO public.product_uom VALUES (279, 28, '2023-02-09 19:19:50', NULL, '2023-02-09 19:19:50');
INSERT INTO public.product_uom VALUES (280, 50, '2023-02-10 10:31:40', NULL, '2023-02-10 14:24:05');
INSERT INTO public.product_uom VALUES (281, 50, '2023-02-10 10:33:29', NULL, '2023-02-10 14:24:30');
INSERT INTO public.product_uom VALUES (282, 52, '2023-02-10 10:33:36', NULL, '2023-02-10 14:24:46');
INSERT INTO public.product_uom VALUES (283, 50, '2023-02-10 10:34:12', NULL, '2023-02-10 14:25:08');
INSERT INTO public.product_uom VALUES (284, 50, '2023-02-10 10:34:26', NULL, '2023-02-10 14:27:28');
INSERT INTO public.product_uom VALUES (285, 48, '2023-02-10 10:34:38', NULL, '2023-02-10 14:27:42');
INSERT INTO public.product_uom VALUES (286, 50, '2023-02-10 10:34:43', NULL, '2023-02-10 14:27:54');
INSERT INTO public.product_uom VALUES (287, 47, '2023-02-10 10:35:05', NULL, '2023-02-10 14:28:02');
INSERT INTO public.product_uom VALUES (288, 50, '2023-02-10 10:35:07', NULL, '2023-02-10 14:28:12');
INSERT INTO public.product_uom VALUES (289, 50, '2023-02-10 10:35:35', NULL, '2023-02-10 14:28:20');
INSERT INTO public.product_uom VALUES (290, 46, '2023-02-10 10:35:38', NULL, '2023-02-10 14:28:31');
INSERT INTO public.product_uom VALUES (291, 50, '2023-02-10 10:36:24', NULL, '2023-02-10 14:28:52');
INSERT INTO public.product_uom VALUES (292, 50, '2023-02-10 10:36:33', NULL, '2023-02-10 14:29:14');
INSERT INTO public.product_uom VALUES (293, 48, '2023-02-10 10:37:02', NULL, '2023-02-10 14:29:27');
INSERT INTO public.product_uom VALUES (294, 48, '2023-02-10 10:37:28', NULL, '2023-02-10 14:29:29');
INSERT INTO public.product_uom VALUES (295, 48, '2023-02-10 10:40:46', NULL, '2023-02-10 14:29:40');
INSERT INTO public.product_uom VALUES (296, 48, '2023-02-10 14:31:42', NULL, '2023-02-10 14:31:42');
INSERT INTO public.product_uom VALUES (297, 46, '2023-02-10 14:32:26', NULL, '2023-02-10 14:32:26');
INSERT INTO public.product_uom VALUES (298, 46, '2023-02-10 14:33:31', NULL, '2023-02-10 14:33:31');
INSERT INTO public.product_uom VALUES (299, 45, '2023-02-10 14:34:19', NULL, '2023-02-10 14:34:19');
INSERT INTO public.product_uom VALUES (302, 51, '2023-02-10 14:37:35', NULL, '2023-02-10 14:37:35');
INSERT INTO public.product_uom VALUES (304, 48, '2023-02-10 14:39:00', NULL, '2023-02-10 14:39:00');
INSERT INTO public.product_uom VALUES (305, 48, '2023-02-10 14:39:56', NULL, '2023-02-10 14:39:56');
INSERT INTO public.product_uom VALUES (306, 49, '2023-02-10 14:40:42', NULL, '2023-02-10 14:40:42');
INSERT INTO public.product_uom VALUES (307, 48, '2023-02-10 14:41:55', NULL, '2023-02-10 14:41:55');
INSERT INTO public.product_uom VALUES (308, 47, '2023-02-10 14:43:12', NULL, '2023-02-10 14:43:12');
INSERT INTO public.product_uom VALUES (310, 46, '2023-02-10 14:49:52', NULL, '2023-02-10 14:49:52');
INSERT INTO public.product_uom VALUES (312, 52, '2023-02-10 14:51:53', NULL, '2023-02-10 14:51:53');
INSERT INTO public.product_uom VALUES (313, 45, '2023-02-10 14:53:39', NULL, '2023-02-10 14:53:39');
INSERT INTO public.product_uom VALUES (315, 45, '2023-02-10 14:54:26', NULL, '2023-02-10 14:54:26');
INSERT INTO public.product_uom VALUES (317, 45, '2023-02-10 14:55:43', NULL, '2023-02-10 14:55:43');
INSERT INTO public.product_uom VALUES (316, 46, '2023-02-10 14:55:05', NULL, '2023-02-10 15:00:58');
INSERT INTO public.product_uom VALUES (318, 44, '2023-02-10 14:57:28', NULL, '2023-02-10 15:01:22');
INSERT INTO public.product_uom VALUES (319, 44, '2023-02-10 14:59:04', NULL, '2023-02-10 15:01:41');
INSERT INTO public.product_uom VALUES (309, 46, '2023-02-10 14:48:27', NULL, '2023-02-10 15:06:21');
INSERT INTO public.product_uom VALUES (300, 53, '2023-02-10 14:35:43', NULL, '2023-02-10 15:06:57');
INSERT INTO public.product_uom VALUES (301, 53, '2023-02-10 14:36:46', NULL, '2023-02-10 15:07:14');
INSERT INTO public.product_uom VALUES (320, 29, '2023-02-10 16:02:59', NULL, '2023-02-10 16:02:59');
INSERT INTO public.product_uom VALUES (321, 46, '2023-02-11 14:07:20', NULL, '2023-02-11 14:07:20');
INSERT INTO public.product_uom VALUES (322, 27, '2023-02-14 16:56:00', NULL, '2023-02-14 16:56:00');
INSERT INTO public.product_uom VALUES (323, 28, '2023-02-14 17:14:50', NULL, '2023-02-14 17:14:50');


--
-- TOC entry 3756 (class 0 OID 18215)
-- Dependencies: 260
-- Data for Name: purchase_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3757 (class 0 OID 18230)
-- Dependencies: 261
-- Data for Name: purchase_master; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3759 (class 0 OID 18248)
-- Dependencies: 263
-- Data for Name: receive_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3760 (class 0 OID 18262)
-- Dependencies: 264
-- Data for Name: receive_master; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3762 (class 0 OID 18280)
-- Dependencies: 266
-- Data for Name: return_sell_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3763 (class 0 OID 18292)
-- Dependencies: 267
-- Data for Name: return_sell_master; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3765 (class 0 OID 18311)
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
INSERT INTO public.role_has_permissions VALUES (2, 12);
INSERT INTO public.role_has_permissions VALUES (26, 12);
INSERT INTO public.role_has_permissions VALUES (55, 12);
INSERT INTO public.role_has_permissions VALUES (56, 12);
INSERT INTO public.role_has_permissions VALUES (57, 12);
INSERT INTO public.role_has_permissions VALUES (58, 12);
INSERT INTO public.role_has_permissions VALUES (60, 12);
INSERT INTO public.role_has_permissions VALUES (61, 12);
INSERT INTO public.role_has_permissions VALUES (62, 12);
INSERT INTO public.role_has_permissions VALUES (63, 12);
INSERT INTO public.role_has_permissions VALUES (64, 12);
INSERT INTO public.role_has_permissions VALUES (83, 12);
INSERT INTO public.role_has_permissions VALUES (84, 12);
INSERT INTO public.role_has_permissions VALUES (86, 12);
INSERT INTO public.role_has_permissions VALUES (87, 12);
INSERT INTO public.role_has_permissions VALUES (90, 12);
INSERT INTO public.role_has_permissions VALUES (91, 12);
INSERT INTO public.role_has_permissions VALUES (92, 12);
INSERT INTO public.role_has_permissions VALUES (93, 12);
INSERT INTO public.role_has_permissions VALUES (94, 12);
INSERT INTO public.role_has_permissions VALUES (95, 12);
INSERT INTO public.role_has_permissions VALUES (96, 12);
INSERT INTO public.role_has_permissions VALUES (97, 12);
INSERT INTO public.role_has_permissions VALUES (98, 12);
INSERT INTO public.role_has_permissions VALUES (99, 12);
INSERT INTO public.role_has_permissions VALUES (100, 12);
INSERT INTO public.role_has_permissions VALUES (101, 12);
INSERT INTO public.role_has_permissions VALUES (102, 12);
INSERT INTO public.role_has_permissions VALUES (103, 12);
INSERT INTO public.role_has_permissions VALUES (104, 12);
INSERT INTO public.role_has_permissions VALUES (105, 12);
INSERT INTO public.role_has_permissions VALUES (106, 12);
INSERT INTO public.role_has_permissions VALUES (107, 12);
INSERT INTO public.role_has_permissions VALUES (108, 12);
INSERT INTO public.role_has_permissions VALUES (109, 12);
INSERT INTO public.role_has_permissions VALUES (110, 12);
INSERT INTO public.role_has_permissions VALUES (111, 12);
INSERT INTO public.role_has_permissions VALUES (112, 12);
INSERT INTO public.role_has_permissions VALUES (113, 12);
INSERT INTO public.role_has_permissions VALUES (115, 12);
INSERT INTO public.role_has_permissions VALUES (116, 12);
INSERT INTO public.role_has_permissions VALUES (117, 12);
INSERT INTO public.role_has_permissions VALUES (118, 12);
INSERT INTO public.role_has_permissions VALUES (119, 12);
INSERT INTO public.role_has_permissions VALUES (120, 12);
INSERT INTO public.role_has_permissions VALUES (121, 12);
INSERT INTO public.role_has_permissions VALUES (122, 12);
INSERT INTO public.role_has_permissions VALUES (124, 12);
INSERT INTO public.role_has_permissions VALUES (125, 12);
INSERT INTO public.role_has_permissions VALUES (127, 12);
INSERT INTO public.role_has_permissions VALUES (126, 12);
INSERT INTO public.role_has_permissions VALUES (128, 12);
INSERT INTO public.role_has_permissions VALUES (129, 12);
INSERT INTO public.role_has_permissions VALUES (130, 12);
INSERT INTO public.role_has_permissions VALUES (131, 12);
INSERT INTO public.role_has_permissions VALUES (132, 12);
INSERT INTO public.role_has_permissions VALUES (133, 12);
INSERT INTO public.role_has_permissions VALUES (134, 12);
INSERT INTO public.role_has_permissions VALUES (136, 12);
INSERT INTO public.role_has_permissions VALUES (137, 12);
INSERT INTO public.role_has_permissions VALUES (138, 12);
INSERT INTO public.role_has_permissions VALUES (139, 12);
INSERT INTO public.role_has_permissions VALUES (140, 12);
INSERT INTO public.role_has_permissions VALUES (141, 12);
INSERT INTO public.role_has_permissions VALUES (142, 12);
INSERT INTO public.role_has_permissions VALUES (144, 12);
INSERT INTO public.role_has_permissions VALUES (145, 12);
INSERT INTO public.role_has_permissions VALUES (146, 12);
INSERT INTO public.role_has_permissions VALUES (147, 12);
INSERT INTO public.role_has_permissions VALUES (148, 12);
INSERT INTO public.role_has_permissions VALUES (149, 12);
INSERT INTO public.role_has_permissions VALUES (150, 12);
INSERT INTO public.role_has_permissions VALUES (152, 12);
INSERT INTO public.role_has_permissions VALUES (153, 12);
INSERT INTO public.role_has_permissions VALUES (154, 12);
INSERT INTO public.role_has_permissions VALUES (155, 12);
INSERT INTO public.role_has_permissions VALUES (156, 12);
INSERT INTO public.role_has_permissions VALUES (157, 12);
INSERT INTO public.role_has_permissions VALUES (158, 12);
INSERT INTO public.role_has_permissions VALUES (159, 12);
INSERT INTO public.role_has_permissions VALUES (160, 12);
INSERT INTO public.role_has_permissions VALUES (162, 12);
INSERT INTO public.role_has_permissions VALUES (163, 12);
INSERT INTO public.role_has_permissions VALUES (164, 12);
INSERT INTO public.role_has_permissions VALUES (165, 12);
INSERT INTO public.role_has_permissions VALUES (166, 12);
INSERT INTO public.role_has_permissions VALUES (167, 12);
INSERT INTO public.role_has_permissions VALUES (168, 12);
INSERT INTO public.role_has_permissions VALUES (169, 12);
INSERT INTO public.role_has_permissions VALUES (170, 12);
INSERT INTO public.role_has_permissions VALUES (172, 12);
INSERT INTO public.role_has_permissions VALUES (173, 12);
INSERT INTO public.role_has_permissions VALUES (174, 12);
INSERT INTO public.role_has_permissions VALUES (175, 12);
INSERT INTO public.role_has_permissions VALUES (176, 12);
INSERT INTO public.role_has_permissions VALUES (177, 12);
INSERT INTO public.role_has_permissions VALUES (178, 12);
INSERT INTO public.role_has_permissions VALUES (179, 12);
INSERT INTO public.role_has_permissions VALUES (180, 12);
INSERT INTO public.role_has_permissions VALUES (182, 12);
INSERT INTO public.role_has_permissions VALUES (183, 12);
INSERT INTO public.role_has_permissions VALUES (184, 12);
INSERT INTO public.role_has_permissions VALUES (185, 12);
INSERT INTO public.role_has_permissions VALUES (186, 12);
INSERT INTO public.role_has_permissions VALUES (187, 12);
INSERT INTO public.role_has_permissions VALUES (188, 12);
INSERT INTO public.role_has_permissions VALUES (189, 12);
INSERT INTO public.role_has_permissions VALUES (190, 12);
INSERT INTO public.role_has_permissions VALUES (196, 12);
INSERT INTO public.role_has_permissions VALUES (197, 12);
INSERT INTO public.role_has_permissions VALUES (198, 12);
INSERT INTO public.role_has_permissions VALUES (199, 12);
INSERT INTO public.role_has_permissions VALUES (200, 12);
INSERT INTO public.role_has_permissions VALUES (201, 12);
INSERT INTO public.role_has_permissions VALUES (135, 12);
INSERT INTO public.role_has_permissions VALUES (143, 12);
INSERT INTO public.role_has_permissions VALUES (151, 12);
INSERT INTO public.role_has_permissions VALUES (191, 12);
INSERT INTO public.role_has_permissions VALUES (123, 12);
INSERT INTO public.role_has_permissions VALUES (171, 12);
INSERT INTO public.role_has_permissions VALUES (202, 12);
INSERT INTO public.role_has_permissions VALUES (203, 12);
INSERT INTO public.role_has_permissions VALUES (204, 12);
INSERT INTO public.role_has_permissions VALUES (206, 12);
INSERT INTO public.role_has_permissions VALUES (207, 12);
INSERT INTO public.role_has_permissions VALUES (208, 12);
INSERT INTO public.role_has_permissions VALUES (209, 12);
INSERT INTO public.role_has_permissions VALUES (210, 12);
INSERT INTO public.role_has_permissions VALUES (211, 12);
INSERT INTO public.role_has_permissions VALUES (212, 12);
INSERT INTO public.role_has_permissions VALUES (213, 12);
INSERT INTO public.role_has_permissions VALUES (214, 12);
INSERT INTO public.role_has_permissions VALUES (215, 12);
INSERT INTO public.role_has_permissions VALUES (216, 12);
INSERT INTO public.role_has_permissions VALUES (217, 12);
INSERT INTO public.role_has_permissions VALUES (218, 12);
INSERT INTO public.role_has_permissions VALUES (219, 12);
INSERT INTO public.role_has_permissions VALUES (220, 12);
INSERT INTO public.role_has_permissions VALUES (222, 12);
INSERT INTO public.role_has_permissions VALUES (227, 12);
INSERT INTO public.role_has_permissions VALUES (233, 12);
INSERT INTO public.role_has_permissions VALUES (234, 12);
INSERT INTO public.role_has_permissions VALUES (235, 12);
INSERT INTO public.role_has_permissions VALUES (236, 12);
INSERT INTO public.role_has_permissions VALUES (237, 12);
INSERT INTO public.role_has_permissions VALUES (238, 12);
INSERT INTO public.role_has_permissions VALUES (239, 12);
INSERT INTO public.role_has_permissions VALUES (240, 12);
INSERT INTO public.role_has_permissions VALUES (241, 12);
INSERT INTO public.role_has_permissions VALUES (243, 12);
INSERT INTO public.role_has_permissions VALUES (244, 12);
INSERT INTO public.role_has_permissions VALUES (245, 12);
INSERT INTO public.role_has_permissions VALUES (268, 12);
INSERT INTO public.role_has_permissions VALUES (269, 12);
INSERT INTO public.role_has_permissions VALUES (270, 12);
INSERT INTO public.role_has_permissions VALUES (271, 12);
INSERT INTO public.role_has_permissions VALUES (272, 12);
INSERT INTO public.role_has_permissions VALUES (273, 12);
INSERT INTO public.role_has_permissions VALUES (274, 12);
INSERT INTO public.role_has_permissions VALUES (275, 12);
INSERT INTO public.role_has_permissions VALUES (276, 12);
INSERT INTO public.role_has_permissions VALUES (288, 12);
INSERT INTO public.role_has_permissions VALUES (2, 1);
INSERT INTO public.role_has_permissions VALUES (4, 1);
INSERT INTO public.role_has_permissions VALUES (5, 1);
INSERT INTO public.role_has_permissions VALUES (6, 1);
INSERT INTO public.role_has_permissions VALUES (7, 1);
INSERT INTO public.role_has_permissions VALUES (9, 1);
INSERT INTO public.role_has_permissions VALUES (11, 1);
INSERT INTO public.role_has_permissions VALUES (12, 1);
INSERT INTO public.role_has_permissions VALUES (291, 12);
INSERT INTO public.role_has_permissions VALUES (14, 1);
INSERT INTO public.role_has_permissions VALUES (296, 12);
INSERT INTO public.role_has_permissions VALUES (15, 1);
INSERT INTO public.role_has_permissions VALUES (297, 12);
INSERT INTO public.role_has_permissions VALUES (16, 1);
INSERT INTO public.role_has_permissions VALUES (18, 1);
INSERT INTO public.role_has_permissions VALUES (221, 12);
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
INSERT INTO public.role_has_permissions VALUES (242, 12);
INSERT INTO public.role_has_permissions VALUES (69, 1);
INSERT INTO public.role_has_permissions VALUES (277, 12);
INSERT INTO public.role_has_permissions VALUES (303, 12);
INSERT INTO public.role_has_permissions VALUES (305, 12);
INSERT INTO public.role_has_permissions VALUES (307, 12);
INSERT INTO public.role_has_permissions VALUES (316, 12);
INSERT INTO public.role_has_permissions VALUES (317, 12);
INSERT INTO public.role_has_permissions VALUES (318, 12);
INSERT INTO public.role_has_permissions VALUES (319, 12);
INSERT INTO public.role_has_permissions VALUES (320, 12);
INSERT INTO public.role_has_permissions VALUES (321, 12);
INSERT INTO public.role_has_permissions VALUES (322, 12);
INSERT INTO public.role_has_permissions VALUES (323, 12);
INSERT INTO public.role_has_permissions VALUES (324, 12);
INSERT INTO public.role_has_permissions VALUES (325, 12);
INSERT INTO public.role_has_permissions VALUES (326, 12);
INSERT INTO public.role_has_permissions VALUES (328, 12);
INSERT INTO public.role_has_permissions VALUES (329, 12);
INSERT INTO public.role_has_permissions VALUES (330, 12);
INSERT INTO public.role_has_permissions VALUES (331, 12);
INSERT INTO public.role_has_permissions VALUES (332, 12);
INSERT INTO public.role_has_permissions VALUES (333, 12);
INSERT INTO public.role_has_permissions VALUES (334, 12);
INSERT INTO public.role_has_permissions VALUES (59, 12);
INSERT INTO public.role_has_permissions VALUES (114, 12);
INSERT INTO public.role_has_permissions VALUES (161, 12);
INSERT INTO public.role_has_permissions VALUES (205, 12);
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
INSERT INTO public.role_has_permissions VALUES (300, 12);
INSERT INTO public.role_has_permissions VALUES (81, 1);
INSERT INTO public.role_has_permissions VALUES (304, 12);
INSERT INTO public.role_has_permissions VALUES (27, 1);
INSERT INTO public.role_has_permissions VALUES (306, 12);
INSERT INTO public.role_has_permissions VALUES (308, 12);
INSERT INTO public.role_has_permissions VALUES (327, 12);
INSERT INTO public.role_has_permissions VALUES (89, 12);
INSERT INTO public.role_has_permissions VALUES (315, 12);
INSERT INTO public.role_has_permissions VALUES (335, 12);
INSERT INTO public.role_has_permissions VALUES (439, 12);
INSERT INTO public.role_has_permissions VALUES (298, 12);
INSERT INTO public.role_has_permissions VALUES (440, 12);
INSERT INTO public.role_has_permissions VALUES (336, 12);
INSERT INTO public.role_has_permissions VALUES (455, 12);
INSERT INTO public.role_has_permissions VALUES (456, 12);
INSERT INTO public.role_has_permissions VALUES (457, 12);
INSERT INTO public.role_has_permissions VALUES (458, 12);
INSERT INTO public.role_has_permissions VALUES (461, 12);
INSERT INTO public.role_has_permissions VALUES (462, 12);
INSERT INTO public.role_has_permissions VALUES (463, 12);
INSERT INTO public.role_has_permissions VALUES (464, 12);
INSERT INTO public.role_has_permissions VALUES (465, 12);
INSERT INTO public.role_has_permissions VALUES (466, 12);
INSERT INTO public.role_has_permissions VALUES (467, 12);
INSERT INTO public.role_has_permissions VALUES (469, 12);
INSERT INTO public.role_has_permissions VALUES (470, 12);
INSERT INTO public.role_has_permissions VALUES (471, 12);
INSERT INTO public.role_has_permissions VALUES (472, 12);
INSERT INTO public.role_has_permissions VALUES (473, 12);
INSERT INTO public.role_has_permissions VALUES (474, 12);
INSERT INTO public.role_has_permissions VALUES (475, 12);
INSERT INTO public.role_has_permissions VALUES (476, 12);
INSERT INTO public.role_has_permissions VALUES (477, 12);
INSERT INTO public.role_has_permissions VALUES (478, 12);
INSERT INTO public.role_has_permissions VALUES (479, 12);
INSERT INTO public.role_has_permissions VALUES (480, 12);
INSERT INTO public.role_has_permissions VALUES (481, 12);
INSERT INTO public.role_has_permissions VALUES (482, 12);
INSERT INTO public.role_has_permissions VALUES (483, 12);
INSERT INTO public.role_has_permissions VALUES (485, 12);
INSERT INTO public.role_has_permissions VALUES (486, 12);
INSERT INTO public.role_has_permissions VALUES (487, 12);
INSERT INTO public.role_has_permissions VALUES (488, 12);
INSERT INTO public.role_has_permissions VALUES (489, 12);
INSERT INTO public.role_has_permissions VALUES (484, 12);
INSERT INTO public.role_has_permissions VALUES (2, 13);
INSERT INTO public.role_has_permissions VALUES (26, 13);
INSERT INTO public.role_has_permissions VALUES (117, 13);
INSERT INTO public.role_has_permissions VALUES (118, 13);
INSERT INTO public.role_has_permissions VALUES (119, 13);
INSERT INTO public.role_has_permissions VALUES (123, 13);
INSERT INTO public.role_has_permissions VALUES (346, 13);
INSERT INTO public.role_has_permissions VALUES (350, 13);
INSERT INTO public.role_has_permissions VALUES (347, 13);
INSERT INTO public.role_has_permissions VALUES (351, 13);
INSERT INTO public.role_has_permissions VALUES (343, 13);
INSERT INTO public.role_has_permissions VALUES (344, 13);
INSERT INTO public.role_has_permissions VALUES (348, 13);
INSERT INTO public.role_has_permissions VALUES (345, 13);
INSERT INTO public.role_has_permissions VALUES (349, 13);
INSERT INTO public.role_has_permissions VALUES (354, 13);
INSERT INTO public.role_has_permissions VALUES (355, 13);
INSERT INTO public.role_has_permissions VALUES (356, 13);
INSERT INTO public.role_has_permissions VALUES (357, 13);
INSERT INTO public.role_has_permissions VALUES (60, 13);
INSERT INTO public.role_has_permissions VALUES (359, 13);
INSERT INTO public.role_has_permissions VALUES (360, 13);
INSERT INTO public.role_has_permissions VALUES (361, 13);
INSERT INTO public.role_has_permissions VALUES (362, 13);
INSERT INTO public.role_has_permissions VALUES (363, 13);
INSERT INTO public.role_has_permissions VALUES (364, 13);
INSERT INTO public.role_has_permissions VALUES (366, 13);
INSERT INTO public.role_has_permissions VALUES (367, 13);
INSERT INTO public.role_has_permissions VALUES (368, 13);
INSERT INTO public.role_has_permissions VALUES (369, 13);
INSERT INTO public.role_has_permissions VALUES (370, 13);
INSERT INTO public.role_has_permissions VALUES (371, 13);
INSERT INTO public.role_has_permissions VALUES (372, 13);
INSERT INTO public.role_has_permissions VALUES (373, 13);
INSERT INTO public.role_has_permissions VALUES (365, 13);
INSERT INTO public.role_has_permissions VALUES (374, 13);
INSERT INTO public.role_has_permissions VALUES (375, 13);
INSERT INTO public.role_has_permissions VALUES (376, 13);
INSERT INTO public.role_has_permissions VALUES (377, 13);
INSERT INTO public.role_has_permissions VALUES (378, 13);
INSERT INTO public.role_has_permissions VALUES (379, 13);
INSERT INTO public.role_has_permissions VALUES (380, 13);
INSERT INTO public.role_has_permissions VALUES (381, 13);
INSERT INTO public.role_has_permissions VALUES (382, 13);
INSERT INTO public.role_has_permissions VALUES (383, 13);
INSERT INTO public.role_has_permissions VALUES (384, 13);
INSERT INTO public.role_has_permissions VALUES (385, 13);
INSERT INTO public.role_has_permissions VALUES (386, 13);
INSERT INTO public.role_has_permissions VALUES (387, 13);
INSERT INTO public.role_has_permissions VALUES (388, 13);
INSERT INTO public.role_has_permissions VALUES (389, 13);
INSERT INTO public.role_has_permissions VALUES (315, 13);
INSERT INTO public.role_has_permissions VALUES (335, 13);
INSERT INTO public.role_has_permissions VALUES (390, 13);
INSERT INTO public.role_has_permissions VALUES (391, 13);
INSERT INTO public.role_has_permissions VALUES (392, 13);
INSERT INTO public.role_has_permissions VALUES (393, 13);
INSERT INTO public.role_has_permissions VALUES (353, 13);
INSERT INTO public.role_has_permissions VALUES (394, 13);
INSERT INTO public.role_has_permissions VALUES (395, 13);
INSERT INTO public.role_has_permissions VALUES (396, 13);
INSERT INTO public.role_has_permissions VALUES (397, 13);
INSERT INTO public.role_has_permissions VALUES (398, 13);
INSERT INTO public.role_has_permissions VALUES (399, 13);
INSERT INTO public.role_has_permissions VALUES (400, 13);
INSERT INTO public.role_has_permissions VALUES (401, 13);
INSERT INTO public.role_has_permissions VALUES (402, 13);
INSERT INTO public.role_has_permissions VALUES (403, 13);
INSERT INTO public.role_has_permissions VALUES (404, 13);
INSERT INTO public.role_has_permissions VALUES (405, 13);
INSERT INTO public.role_has_permissions VALUES (406, 13);
INSERT INTO public.role_has_permissions VALUES (407, 13);
INSERT INTO public.role_has_permissions VALUES (408, 13);
INSERT INTO public.role_has_permissions VALUES (409, 13);
INSERT INTO public.role_has_permissions VALUES (410, 13);
INSERT INTO public.role_has_permissions VALUES (411, 13);
INSERT INTO public.role_has_permissions VALUES (412, 13);
INSERT INTO public.role_has_permissions VALUES (413, 13);
INSERT INTO public.role_has_permissions VALUES (414, 13);
INSERT INTO public.role_has_permissions VALUES (415, 13);
INSERT INTO public.role_has_permissions VALUES (416, 13);
INSERT INTO public.role_has_permissions VALUES (417, 13);
INSERT INTO public.role_has_permissions VALUES (418, 13);
INSERT INTO public.role_has_permissions VALUES (419, 13);
INSERT INTO public.role_has_permissions VALUES (420, 13);
INSERT INTO public.role_has_permissions VALUES (421, 13);
INSERT INTO public.role_has_permissions VALUES (422, 13);
INSERT INTO public.role_has_permissions VALUES (423, 13);
INSERT INTO public.role_has_permissions VALUES (424, 13);
INSERT INTO public.role_has_permissions VALUES (425, 13);
INSERT INTO public.role_has_permissions VALUES (426, 13);
INSERT INTO public.role_has_permissions VALUES (427, 13);
INSERT INTO public.role_has_permissions VALUES (428, 13);
INSERT INTO public.role_has_permissions VALUES (429, 13);
INSERT INTO public.role_has_permissions VALUES (430, 13);
INSERT INTO public.role_has_permissions VALUES (431, 13);
INSERT INTO public.role_has_permissions VALUES (432, 13);
INSERT INTO public.role_has_permissions VALUES (433, 13);
INSERT INTO public.role_has_permissions VALUES (434, 13);
INSERT INTO public.role_has_permissions VALUES (435, 13);
INSERT INTO public.role_has_permissions VALUES (436, 13);
INSERT INTO public.role_has_permissions VALUES (437, 13);
INSERT INTO public.role_has_permissions VALUES (438, 13);
INSERT INTO public.role_has_permissions VALUES (298, 13);
INSERT INTO public.role_has_permissions VALUES (193, 13);
INSERT INTO public.role_has_permissions VALUES (441, 13);
INSERT INTO public.role_has_permissions VALUES (442, 13);
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
INSERT INTO public.role_has_permissions VALUES (2, 5);


--
-- TOC entry 3766 (class 0 OID 18314)
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
INSERT INTO public.roles VALUES (12, 'admin_barang', 'web', '2023-01-30 21:22:24', '2023-01-30 21:22:24');
INSERT INTO public.roles VALUES (13, 'admin_perawatan', 'web', '2023-01-30 21:26:51', '2023-01-30 21:26:51');


--
-- TOC entry 3793 (class 0 OID 18736)
-- Dependencies: 297
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3795 (class 0 OID 18750)
-- Dependencies: 299
-- Data for Name: sales_trip; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3797 (class 0 OID 18762)
-- Dependencies: 301
-- Data for Name: sales_trip_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3803 (class 0 OID 27180)
-- Dependencies: 307
-- Data for Name: sales_visit; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3768 (class 0 OID 18322)
-- Dependencies: 272
-- Data for Name: setting_document_counter; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.setting_document_counter VALUES (10, 'Receive', 'RCV', 'Yearly', 0, NULL, NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (12, 'Purchase', 'PO', 'Yearly', 0, NULL, NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (17, 'Purchase', 'PO', 'Yearly', 0, NULL, NULL, NULL, '2022-11-25 20:43:40.854575', 3);
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
INSERT INTO public.setting_document_counter VALUES (31, 'Order_Queue', 'SPK', 'Daily', 0, '2023-01-02 12:33:32', NULL, NULL, '2022-11-25 20:43:40.854575', 4);
INSERT INTO public.setting_document_counter VALUES (32, 'Order_Queue', 'SPK', 'Daily', 0, '2023-01-02 12:33:32', NULL, NULL, '2022-11-25 20:43:40.854575', 5);
INSERT INTO public.setting_document_counter VALUES (33, 'Purchase', 'PO', 'Yearly', 0, '2023-01-02 12:36:55', NULL, NULL, '2022-11-25 20:43:40.854575', 4);
INSERT INTO public.setting_document_counter VALUES (34, 'Purchase', 'PO', 'Yearly', 0, '2023-01-02 12:36:55', NULL, NULL, '2022-11-25 20:43:40.854575', 5);
INSERT INTO public.setting_document_counter VALUES (46, 'Invoice', 'INV', 'Yearly', 41, '2023-02-15 22:44:11', NULL, NULL, '2022-11-25 20:43:40.854575', 14);
INSERT INTO public.setting_document_counter VALUES (15, 'Receive', 'RCV', 'Yearly', 0, '2023-01-20 18:04:53', NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (35, 'Receive', 'RCV', 'Yearly', 0, '2023-01-20 18:04:53', NULL, NULL, '2022-11-25 20:43:40.854575', 4);
INSERT INTO public.setting_document_counter VALUES (36, 'Receive', 'RCV', 'Yearly', 0, '2023-01-20 18:04:53', NULL, NULL, '2022-11-25 20:43:40.854575', 5);
INSERT INTO public.setting_document_counter VALUES (5, 'Receive', 'RCV', 'Yearly', 0, '2023-01-20 18:04:53', NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (19, 'Return Invoice', 'REI', 'Yearly', 0, '2023-01-20 18:05:42', NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (20, 'Return Invoice', 'REI', 'Yearly', 0, '2023-01-20 18:05:42', NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (21, 'Return Invoice', 'REI', 'Yearly', 0, '2023-01-20 18:05:42', NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (38, 'Return Invoice', 'REI', 'Yearly', 0, '2023-01-20 18:05:42', NULL, NULL, '2022-11-25 20:43:40.854575', 5);
INSERT INTO public.setting_document_counter VALUES (39, 'Return Invoice', 'REI', 'Yearly', 0, '2023-01-20 18:05:42', NULL, NULL, '2022-11-25 20:43:40.854575', 4);
INSERT INTO public.setting_document_counter VALUES (16, 'Invoice', 'INV', 'Yearly', 0, '2023-01-02 08:23:30', NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (11, 'Invoice', 'INV', 'Yearly', 0, '2023-01-02 08:23:30', NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (9, 'Order_Queue', 'SPK', 'Daily', 0, '2023-01-02 12:33:32', NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (14, 'Order_Queue', 'SPK', 'Daily', 0, '2023-01-02 12:33:32', NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (2, 'Order_Queue', 'SPK', 'Daily', 0, '2023-01-02 12:33:32', NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (13, 'Order', 'SPK', 'Yearly', 0, '2023-01-02 12:33:33', NULL, NULL, '2022-11-25 20:43:40.854575', 2);
INSERT INTO public.setting_document_counter VALUES (18, 'Order', 'SPK', 'Yearly', 0, '2023-01-02 12:33:33', NULL, NULL, '2022-11-25 20:43:40.854575', 3);
INSERT INTO public.setting_document_counter VALUES (1, 'Order', 'SPK', 'Yearly', 0, '2023-01-02 12:33:33', NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (3, 'Invoice', 'INV', 'Yearly', 18, '2023-01-30 18:50:12', NULL, NULL, '2022-11-25 20:43:40.854575', 1);
INSERT INTO public.setting_document_counter VALUES (40, 'Purchase', 'PO', 'Yearly', 0, '2023-01-02 12:36:55', NULL, NULL, '2022-11-25 20:43:40.854575', 14);
INSERT INTO public.setting_document_counter VALUES (41, 'Invoice Internal', 'INVI', 'Yearly', 0, '2023-01-02 08:23:30', NULL, NULL, '2022-11-25 20:43:40.854575', 14);
INSERT INTO public.setting_document_counter VALUES (42, 'Receive', 'RCV', 'Yearly', 0, '2023-01-20 18:04:53', NULL, NULL, '2022-11-25 20:43:40.854575', 14);
INSERT INTO public.setting_document_counter VALUES (43, 'Return Invoice', 'REI', 'Yearly', 0, '2023-01-20 18:05:42', NULL, NULL, '2022-11-25 20:43:40.854575', 14);
INSERT INTO public.setting_document_counter VALUES (44, 'Order_Queue', 'SPK', 'Daily', 0, '2023-01-02 12:33:32', NULL, NULL, '2022-11-25 20:43:40.854575', 14);
INSERT INTO public.setting_document_counter VALUES (45, 'Order', 'SPK', 'Yearly', 0, '2023-01-02 12:33:33', NULL, NULL, '2022-11-25 20:43:40.854575', 14);


--
-- TOC entry 3770 (class 0 OID 18332)
-- Dependencies: 274
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.settings VALUES ('2022-07-16', 202207, 'Kakiku', 'Lapak ERP', 'v0.0.1', 'logo_kakiku.png');


--
-- TOC entry 3771 (class 0 OID 18339)
-- Dependencies: 275
-- Data for Name: shift; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.shift VALUES (11, 'SHIFT 1 PAGI', '09:00:00', '18:00:00', 1, '2023-02-11 09:17:17', '2023-02-11 09:17:17');
INSERT INTO public.shift VALUES (12, 'SHIFT 2 SORE', '18:01:00', '23:59:00', 1, '2023-02-17 08:48:13', '2023-02-11 09:19:13');


--
-- TOC entry 3772 (class 0 OID 18348)
-- Dependencies: 276
-- Data for Name: shift_counter; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.shift_counter VALUES (64, 1, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (67, 2, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (70, 3, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (73, 4, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (76, 5, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (79, 6, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (65, 7, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (68, 8, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (71, 9, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (74, 10, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (78, 11, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (81, 12, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (77, 13, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (80, 14, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (69, 15, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (72, 16, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (75, 17, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);
INSERT INTO public.shift_counter VALUES (66, 18, 1, '2023-02-15 15:50:03.57956', 1, '2023-02-15 15:50:03.57956', 14);


--
-- TOC entry 3774 (class 0 OID 18354)
-- Dependencies: 278
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3754 (class 0 OID 18204)
-- Dependencies: 258
-- Data for Name: uom; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.uom VALUES (25, 'TUBE', 1, '2023-02-04 12:45:11', '2023-02-04 12:45:11', 1);
INSERT INTO public.uom VALUES (27, 'BOTOL', 1, '2023-02-06 18:01:01', '2023-02-06 18:01:01', 1);
INSERT INTO public.uom VALUES (28, 'SACHET', 1, '2023-02-06 18:01:13', '2023-02-06 18:01:13', 1);
INSERT INTO public.uom VALUES (29, 'BUAH', 1, '2023-02-06 18:02:33', '2023-02-06 18:02:33', 1);
INSERT INTO public.uom VALUES (30, 'BUNGKUS', 1, '2023-02-06 18:02:57', '2023-02-06 18:02:57', 1);
INSERT INTO public.uom VALUES (31, 'KG', 1, '2023-02-06 18:03:06', '2023-02-06 18:03:06', 1);
INSERT INTO public.uom VALUES (32, 'LITER', 1, '2023-02-06 18:03:35', '2023-02-06 18:03:35', 1);
INSERT INTO public.uom VALUES (33, 'PASANG', 1, '2023-02-06 18:03:56', '2023-02-06 18:03:56', 1);
INSERT INTO public.uom VALUES (34, 'LUSIN', 1, '2023-02-06 18:04:03', '2023-02-06 18:04:03', 1);
INSERT INTO public.uom VALUES (35, 'SET', 1, '2023-02-06 18:04:08', '2023-02-06 18:04:08', 1);
INSERT INTO public.uom VALUES (36, 'JERIGEN', 1, '2023-02-06 18:04:15', '2023-02-06 18:04:15', 1);
INSERT INTO public.uom VALUES (37, 'RIM', 1, '2023-02-06 18:04:24', '2023-02-06 18:04:24', 1);
INSERT INTO public.uom VALUES (38, 'BOX', 1, '2023-02-06 18:04:29', '2023-02-06 18:04:29', 1);
INSERT INTO public.uom VALUES (39, 'KOTAK', 1, '2023-02-06 18:04:45', '2023-02-06 18:04:45', 1);
INSERT INTO public.uom VALUES (40, 'STRIP', 1, '2023-02-06 18:04:51', '2023-02-06 18:04:51', 1);
INSERT INTO public.uom VALUES (41, 'BUKU', 1, '2023-02-06 18:04:57', '2023-02-06 18:04:57', 1);
INSERT INTO public.uom VALUES (42, 'EMBER', 1, '2023-02-08 19:07:40', '2023-02-08 19:07:40', 1);
INSERT INTO public.uom VALUES (44, 'LAIN-LAIN', 1, '2023-02-10 10:30:34', '2023-02-10 10:30:34', 2);
INSERT INTO public.uom VALUES (45, '20 MENIT', 1, '2023-02-10 10:37:46', '2023-02-10 10:37:46', 2);
INSERT INTO public.uom VALUES (46, '30 MENIT', 1, '2023-02-10 10:37:53', '2023-02-10 10:37:53', 2);
INSERT INTO public.uom VALUES (47, '45 MENIT', 1, '2023-02-10 10:38:03', '2023-02-10 10:38:03', 2);
INSERT INTO public.uom VALUES (49, '75 MENIT', 1, '2023-02-10 10:38:23', '2023-02-10 10:38:23', 2);
INSERT INTO public.uom VALUES (50, '90 MENIT', 1, '2023-02-10 10:38:30', '2023-02-10 10:38:30', 2);
INSERT INTO public.uom VALUES (51, '100 MENIT', 1, '2023-02-10 10:38:36', '2023-02-10 10:38:55', 2);
INSERT INTO public.uom VALUES (52, '120 MENIT', 1, '2023-02-10 10:39:03', '2023-02-10 10:39:10', 2);
INSERT INTO public.uom VALUES (53, '150 MENIT', 1, '2023-02-10 10:39:23', '2023-02-10 10:39:23', 2);
INSERT INTO public.uom VALUES (48, '60 MENIT', 1, '2023-02-10 10:38:15', '2023-02-10 14:29:55', 2);


--
-- TOC entry 3776 (class 0 OID 18363)
-- Dependencies: 280
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES (1, 'Admin', 'admin@gmail.com', 'admin', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-05-28 12:40:11', '6285746879090', 'JALAN JAKARTA', '2020-01-01', 3, 'Male', '3524111233144330001', 'JAKARTA', '20210101ADM', 'user-13.jpg', 'user-13.jpg', 6, 1, 5, NULL, 'JAKARTA', '2022-01-01', 'On Job Training', 1);
INSERT INTO public.users VALUES (64, 'TONO', '2720235223@gmail.com', 'TONO', NULL, '$2y$10$pi4eTbYI2/nEIhaREVSX4.JuMvbnplOBFgSiy6RumcqwJPAbNq8jC', NULL, '2023-02-07 20:24:01', '2023-02-07 20:24:01', NULL, NULL, '2013-08-13', 9, 'Male', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (67, 'JUPANDI', '27202353327@gmail.com', 'JUPANDI', NULL, '$2y$10$PzV7DD9UNeHUh4Q2lf.kdemie6X1AgdfHuypFgYLanSZIk7RV62Gm', NULL, '2023-02-07 20:35:45', '2023-02-07 20:35:45', NULL, NULL, '2013-08-25', 9, 'Male', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (70, 'NISA', '27202354122@gmail.com', 'NISA', NULL, '$2y$10$dryyhbtDXu.iDKTEiYz4le1c6OqUcx/0YUeKHhJ0XHiin0DQ0j.Py', NULL, '2023-02-07 20:43:02', '2023-02-07 20:43:02', NULL, NULL, '2016-08-22', 6, 'Female', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (73, 'DEMI', '2720235475@gmail.com', 'DEMI', NULL, '$2y$10$WBj0extqxHZVMc8ny1bZ/enu1VSYZkX.HbBBu3y/QeL.VgEAX3FXC', NULL, '2023-02-07 20:48:07', '2023-02-07 20:48:07', NULL, NULL, '2019-10-20', 3, 'Male', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (76, 'AYU', '27202355113@gmail.com', 'AYU', NULL, '$2y$10$gT5UXTuCKbNp3abIXsgnBO8HbaKaPna5JloBWoU0vqwZmN3tGer0e', NULL, '2023-02-07 20:52:14', '2023-02-07 20:52:14', NULL, NULL, '2017-07-16', 5, 'Female', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (79, 'RULI', '27202355550@gmail.com', 'RULI', NULL, '$2y$10$uLangvF4Rz5aeBz2xaqQjeq.fNzBFeoNrcqWaa17zUY6gCaLBYUu2', NULL, '2023-02-07 20:56:52', '2023-02-07 20:56:52', NULL, NULL, '2017-07-05', 5, 'Male', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (82, 'MELATI', '27202355947@gmail.com', 'MELATI', NULL, '$2y$10$use7IQ3bUYJgytk67dZATeuuFfxnI.27WFXv9yaxEZvBWu1lit15G', NULL, '2023-02-07 21:02:12', '2023-02-07 21:02:12', NULL, NULL, '2021-05-31', 1, 'Female', NULL, NULL, NULL, NULL, NULL, 1, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (65, 'MARSELI', '27202352412@gmail.com', 'MARSELI', NULL, '$2y$10$a8wtxSYlimKWP9a.Vqekge/CYhr38YnDdBflzmEQ3WvENpx6Mrhby', NULL, '2023-02-07 20:25:50', '2023-02-07 20:25:50', NULL, NULL, '2020-06-12', 2, 'Female', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (68, 'NOVI', '27202353552@gmail.com', 'NOVI', NULL, '$2y$10$bWAuO856h.jZuCtNBSWSreBY8cbE0ImstEuhxvcxmbvpAPkVaLgnS', NULL, '2023-02-07 20:37:53', '2023-02-07 20:37:53', NULL, NULL, '2018-07-01', 4, 'Female', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (71, 'ERNI', '27202354337@gmail.com', 'ERNI', NULL, '$2y$10$dJAt37DiIoHX03ujroD2uuonOwAvsXTp4nA0rnuDZvNFnltIymw6m', NULL, '2023-02-07 20:44:57', '2023-02-07 20:44:57', NULL, NULL, '2018-06-05', 4, 'Female', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (74, 'POVI', '27202354815@gmail.com', 'POVI', NULL, '$2y$10$TbNNebWFth4YLGuSDhksdu1.X0D7yoOYc3ZXbTt6qHuTrokA4oVp2', NULL, '2023-02-07 20:49:28', '2023-02-07 20:49:28', NULL, NULL, '2018-06-05', 4, 'Female', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (78, 'JUNI', '27202355437@gmail.com', 'JUNI', NULL, '$2y$10$ZCGnZjsjdA2TLBFzwKSS7eiVsLQSiOVdN85VBMep9tHStIM6agqVC', NULL, '2023-02-07 20:55:37', '2023-02-07 20:55:37', NULL, NULL, '2011-09-09', 11, 'Male', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (81, 'RINA', '27202355822@gmail.com', 'RINA', NULL, '$2y$10$ElD86mfXzm0.YXwzuCV0MOKlPteV/V0scZzFekjOqfmA15bSqljgO', NULL, '2023-02-07 20:59:30', '2023-02-07 20:59:30', NULL, NULL, '2017-09-23', 5, 'Female', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (84, 'SRI', '2720236426@gmail.com', 'SRI', NULL, '$2y$10$j8RM09fraJN/15onKqr1huwiNL6FFUT0511rkIhgTxQYdEL0/RWDy', NULL, '2023-02-07 21:07:46', '2023-02-07 21:07:46', NULL, NULL, '2022-12-12', 1, 'Female', NULL, NULL, NULL, NULL, NULL, 1, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (77, 'DANI', '27202355239@gmail.com', 'DANI', NULL, '$2y$10$LGEQDJg5PkD5t4EvIAkHi.kGSLgIvHvy6jhTYWptCASCrQVlZE3Du', NULL, '2023-02-07 20:54:28', '2023-02-07 20:54:28', NULL, NULL, '2012-06-20', 10, 'Male', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (80, 'DESI', '2720235575@gmail.com', 'DESI', NULL, '$2y$10$OFgXuYjsWQoS8AsQP5/9r.tNFPTN8o.yrgcy4NAGvHXEMV2SbzUye', NULL, '2023-02-07 20:58:19', '2023-02-07 20:58:19', NULL, NULL, '2018-06-14', 4, 'Female', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (83, 'NABILA', '2720236224@gmail.com', 'NABILA', NULL, '$2y$10$B0Y88gWQQtx5H1PfnkRZRukjdRFUI6vc/17D6rhSeA5ABQBsLAPKu', NULL, '2023-02-07 21:04:14', '2023-02-07 21:04:14', NULL, NULL, '2022-11-12', 1, 'Female', NULL, NULL, NULL, NULL, NULL, 1, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (63, 'ANITA', '262023155545@gmail.com', 'ANITA', NULL, '$2y$10$RjNFX/4ePQORa1rI9e/6Y.kBZBmvqkLUNp.4fow928ZFCudUCb1rW', NULL, '2023-02-06 15:57:12', '2023-02-06 15:57:12', NULL, NULL, '2021-12-26', 1, 'Female', NULL, NULL, NULL, NULL, NULL, 1, 14, 2, NULL, NULL, '2023-02-06', NULL, 1);
INSERT INTO public.users VALUES (69, 'YANTI', '27202353937@gmail.com', 'YANTI', NULL, '$2y$10$UTpiRistMQnQzuqOssiKIewV3WYPg3vcgtj78Y239RimwAp6ODgw2', NULL, '2023-02-07 20:41:15', '2023-02-07 20:41:15', NULL, NULL, '2014-08-15', 8, 'Female', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (72, 'SELA', '27202354517@gmail.com', 'SELA', NULL, '$2y$10$r7DGXudWZDAKnk6FtUONVOVnPmLQV6ugdG6Ho9nFLkeXztw9O3GsS', NULL, '2023-02-07 20:46:51', '2023-02-07 20:46:51', NULL, NULL, '2019-10-20', 3, 'Female', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (75, 'AHMAD', '27202354934@gmail.com', 'AHMAD', NULL, '$2y$10$XLJQV/siCHgEyHbMam9fYOTxhah1LQ.GWf5tI8RjM9eFLyj/PF3wO', NULL, '2023-02-07 20:50:58', '2023-02-07 20:50:58', NULL, NULL, '2022-07-10', 1, 'Male', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-07', NULL, 1);
INSERT INTO public.users VALUES (66, 'TINI', '27202352553@gmail.com', 'TINI', NULL, '$2y$10$OFhQcyhz9xdXQuYvdMhcZew0CMduvfg6yxg6rwK9zrFgTeGnYpgpG', NULL, '2023-02-07 20:27:19', '2023-02-10 17:18:36', NULL, NULL, '2013-08-25', 9, 'Female', NULL, NULL, NULL, NULL, NULL, 2, 14, 2, NULL, NULL, '2023-02-10', NULL, 1);


--
-- TOC entry 3777 (class 0 OID 18371)
-- Dependencies: 281
-- Data for Name: users_branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users_branch VALUES (1, 1, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (61, 14, '2023-02-06 15:48:15', '2023-02-06 15:48:15');
INSERT INTO public.users_branch VALUES (62, 14, '2023-02-06 15:49:27', '2023-02-06 15:49:27');
INSERT INTO public.users_branch VALUES (63, 14, '2023-02-06 15:57:12', '2023-02-06 15:57:12');
INSERT INTO public.users_branch VALUES (64, 14, '2023-02-07 20:24:01', '2023-02-07 20:24:01');
INSERT INTO public.users_branch VALUES (65, 14, '2023-02-07 20:25:50', '2023-02-07 20:25:50');
INSERT INTO public.users_branch VALUES (67, 14, '2023-02-07 20:35:45', '2023-02-07 20:35:45');
INSERT INTO public.users_branch VALUES (68, 14, '2023-02-07 20:37:53', '2023-02-07 20:37:53');
INSERT INTO public.users_branch VALUES (69, 14, '2023-02-07 20:41:15', '2023-02-07 20:41:15');
INSERT INTO public.users_branch VALUES (70, 14, '2023-02-07 20:43:02', '2023-02-07 20:43:02');
INSERT INTO public.users_branch VALUES (71, 14, '2023-02-07 20:44:57', '2023-02-07 20:44:57');
INSERT INTO public.users_branch VALUES (72, 14, '2023-02-07 20:46:51', '2023-02-07 20:46:51');
INSERT INTO public.users_branch VALUES (73, 14, '2023-02-07 20:48:07', '2023-02-07 20:48:07');
INSERT INTO public.users_branch VALUES (74, 14, '2023-02-07 20:49:28', '2023-02-07 20:49:28');
INSERT INTO public.users_branch VALUES (75, 14, '2023-02-07 20:50:58', '2023-02-07 20:50:58');
INSERT INTO public.users_branch VALUES (76, 14, '2023-02-07 20:52:14', '2023-02-07 20:52:14');
INSERT INTO public.users_branch VALUES (77, 14, '2023-02-07 20:54:28', '2023-02-07 20:54:28');
INSERT INTO public.users_branch VALUES (78, 14, '2023-02-07 20:55:37', '2023-02-07 20:55:37');
INSERT INTO public.users_branch VALUES (79, 14, '2023-02-07 20:56:52', '2023-02-07 20:56:52');
INSERT INTO public.users_branch VALUES (80, 14, '2023-02-07 20:58:19', '2023-02-07 20:58:19');
INSERT INTO public.users_branch VALUES (81, 14, '2023-02-07 20:59:30', '2023-02-07 20:59:30');
INSERT INTO public.users_branch VALUES (82, 14, '2023-02-07 21:02:12', '2023-02-07 21:02:12');
INSERT INTO public.users_branch VALUES (83, 14, '2023-02-07 21:04:14', '2023-02-07 21:04:14');
INSERT INTO public.users_branch VALUES (84, 14, '2023-02-07 21:07:46', '2023-02-07 21:07:46');
INSERT INTO public.users_branch VALUES (1, 14, '2022-07-06 12:09:12', '2022-07-06 12:09:12');
INSERT INTO public.users_branch VALUES (66, 14, '2023-02-10 17:18:36', '2023-02-10 17:18:36');
INSERT INTO public.users_branch VALUES (85, 14, '2023-02-15 11:26:05', '2023-02-15 11:26:05');


--
-- TOC entry 3778 (class 0 OID 18375)
-- Dependencies: 282
-- Data for Name: users_experience; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3781 (class 0 OID 18386)
-- Dependencies: 285
-- Data for Name: users_mutation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users_mutation VALUES (44, 61, 14, 9, 1, NULL, '2023-02-06 15:48:15', '2023-02-06 15:48:15');
INSERT INTO public.users_mutation VALUES (45, 62, 14, 9, 1, NULL, '2023-02-06 15:49:27', '2023-02-06 15:49:27');
INSERT INTO public.users_mutation VALUES (46, 63, 14, 2, 1, NULL, '2023-02-06 15:57:12', '2023-02-06 15:57:12');
INSERT INTO public.users_mutation VALUES (47, 64, 14, 2, 2, NULL, '2023-02-07 20:24:01', '2023-02-07 20:24:01');
INSERT INTO public.users_mutation VALUES (48, 65, 14, 2, 2, NULL, '2023-02-07 20:25:50', '2023-02-07 20:25:50');
INSERT INTO public.users_mutation VALUES (49, 66, 14, 2, 2, NULL, '2023-02-07 20:27:19', '2023-02-07 20:27:19');
INSERT INTO public.users_mutation VALUES (50, 67, 14, 2, 2, NULL, '2023-02-07 20:35:45', '2023-02-07 20:35:45');
INSERT INTO public.users_mutation VALUES (51, 68, 14, 2, 2, NULL, '2023-02-07 20:37:53', '2023-02-07 20:37:53');
INSERT INTO public.users_mutation VALUES (52, 69, 14, 2, 2, NULL, '2023-02-07 20:41:15', '2023-02-07 20:41:15');
INSERT INTO public.users_mutation VALUES (53, 70, 14, 2, 2, NULL, '2023-02-07 20:43:02', '2023-02-07 20:43:02');
INSERT INTO public.users_mutation VALUES (54, 71, 14, 2, 2, NULL, '2023-02-07 20:44:57', '2023-02-07 20:44:57');
INSERT INTO public.users_mutation VALUES (55, 72, 14, 2, 2, NULL, '2023-02-07 20:46:51', '2023-02-07 20:46:51');
INSERT INTO public.users_mutation VALUES (56, 73, 14, 2, 2, NULL, '2023-02-07 20:48:07', '2023-02-07 20:48:07');
INSERT INTO public.users_mutation VALUES (57, 74, 14, 2, 2, NULL, '2023-02-07 20:49:28', '2023-02-07 20:49:28');
INSERT INTO public.users_mutation VALUES (58, 75, 14, 2, 2, NULL, '2023-02-07 20:50:58', '2023-02-07 20:50:58');
INSERT INTO public.users_mutation VALUES (59, 76, 14, 2, 2, NULL, '2023-02-07 20:52:14', '2023-02-07 20:52:14');
INSERT INTO public.users_mutation VALUES (60, 77, 14, 2, 2, NULL, '2023-02-07 20:54:28', '2023-02-07 20:54:28');
INSERT INTO public.users_mutation VALUES (61, 78, 14, 2, 2, NULL, '2023-02-07 20:55:37', '2023-02-07 20:55:37');
INSERT INTO public.users_mutation VALUES (62, 79, 14, 2, 2, NULL, '2023-02-07 20:56:52', '2023-02-07 20:56:52');
INSERT INTO public.users_mutation VALUES (63, 80, 14, 2, 2, NULL, '2023-02-07 20:58:19', '2023-02-07 20:58:19');
INSERT INTO public.users_mutation VALUES (64, 81, 14, 2, 2, NULL, '2023-02-07 20:59:30', '2023-02-07 20:59:30');
INSERT INTO public.users_mutation VALUES (65, 82, 14, 2, 1, NULL, '2023-02-07 21:02:12', '2023-02-07 21:02:12');
INSERT INTO public.users_mutation VALUES (66, 83, 14, 2, 1, NULL, '2023-02-07 21:04:14', '2023-02-07 21:04:14');
INSERT INTO public.users_mutation VALUES (67, 84, 14, 2, 1, NULL, '2023-02-07 21:07:46', '2023-02-07 21:07:46');
INSERT INTO public.users_mutation VALUES (68, 85, 14, 2, 1, NULL, '2023-02-15 11:26:05', '2023-02-15 11:26:05');


--
-- TOC entry 3783 (class 0 OID 18395)
-- Dependencies: 287
-- Data for Name: users_shift; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3785 (class 0 OID 18404)
-- Dependencies: 289
-- Data for Name: users_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3786 (class 0 OID 18412)
-- Dependencies: 290
-- Data for Name: voucher; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.voucher VALUES (0, '0000', 1, '2020-01-01', '2020-01-01', 1, NULL, 1, '2023-02-16 21:30:12.053007', NULL, 0, 'test');


--
-- TOC entry 3857 (class 0 OID 0)
-- Dependencies: 203
-- Name: branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_id_seq', 14, true);


--
-- TOC entry 3858 (class 0 OID 0)
-- Dependencies: 205
-- Name: branch_room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);


--
-- TOC entry 3859 (class 0 OID 0)
-- Dependencies: 292
-- Name: branch_shift_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);


--
-- TOC entry 3860 (class 0 OID 0)
-- Dependencies: 304
-- Name: calendar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);


--
-- TOC entry 3861 (class 0 OID 0)
-- Dependencies: 207
-- Name: company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.company_id_seq', 1, true);


--
-- TOC entry 3862 (class 0 OID 0)
-- Dependencies: 209
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_id_seq', 73, true);


--
-- TOC entry 3863 (class 0 OID 0)
-- Dependencies: 302
-- Name: customers_registration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);


--
-- TOC entry 3864 (class 0 OID 0)
-- Dependencies: 308
-- Name: customers_segment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);


--
-- TOC entry 3865 (class 0 OID 0)
-- Dependencies: 211
-- Name: department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.department_id_seq', 10, true);


--
-- TOC entry 3866 (class 0 OID 0)
-- Dependencies: 213
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- TOC entry 3867 (class 0 OID 0)
-- Dependencies: 216
-- Name: invoice_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invoice_master_id_seq', 168, true);


--
-- TOC entry 3868 (class 0 OID 0)
-- Dependencies: 218
-- Name: job_title_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);


--
-- TOC entry 3869 (class 0 OID 0)
-- Dependencies: 220
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);


--
-- TOC entry 3870 (class 0 OID 0)
-- Dependencies: 225
-- Name: order_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);


--
-- TOC entry 3871 (class 0 OID 0)
-- Dependencies: 229
-- Name: period_price_sell_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.period_price_sell_id_seq', 1323, true);


--
-- TOC entry 3872 (class 0 OID 0)
-- Dependencies: 232
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 489, true);


--
-- TOC entry 3873 (class 0 OID 0)
-- Dependencies: 234
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);


--
-- TOC entry 3874 (class 0 OID 0)
-- Dependencies: 237
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 2, true);


--
-- TOC entry 3875 (class 0 OID 0)
-- Dependencies: 239
-- Name: price_adjustment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);


--
-- TOC entry 3876 (class 0 OID 0)
-- Dependencies: 241
-- Name: product_brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_brand_id_seq', 22, true);


--
-- TOC entry 3877 (class 0 OID 0)
-- Dependencies: 243
-- Name: product_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_category_id_seq', 52, true);


--
-- TOC entry 3878 (class 0 OID 0)
-- Dependencies: 251
-- Name: product_sku_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_sku_id_seq', 323, true);


--
-- TOC entry 3879 (class 0 OID 0)
-- Dependencies: 254
-- Name: product_stock_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 24, true);


--
-- TOC entry 3880 (class 0 OID 0)
-- Dependencies: 256
-- Name: product_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);


--
-- TOC entry 3881 (class 0 OID 0)
-- Dependencies: 259
-- Name: product_uom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_uom_id_seq', 54, true);


--
-- TOC entry 3882 (class 0 OID 0)
-- Dependencies: 262
-- Name: purchase_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchase_master_id_seq', 18, true);


--
-- TOC entry 3883 (class 0 OID 0)
-- Dependencies: 265
-- Name: receive_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.receive_master_id_seq', 31, true);


--
-- TOC entry 3884 (class 0 OID 0)
-- Dependencies: 268
-- Name: return_sell_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);


--
-- TOC entry 3885 (class 0 OID 0)
-- Dependencies: 271
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 13, true);


--
-- TOC entry 3886 (class 0 OID 0)
-- Dependencies: 296
-- Name: sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_id_seq', 1, true);


--
-- TOC entry 3887 (class 0 OID 0)
-- Dependencies: 300
-- Name: sales_trip_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 21, true);


--
-- TOC entry 3888 (class 0 OID 0)
-- Dependencies: 298
-- Name: sales_trip_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_trip_id_seq', 4, true);


--
-- TOC entry 3889 (class 0 OID 0)
-- Dependencies: 306
-- Name: sales_visit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_visit_id_seq', 1, false);


--
-- TOC entry 3890 (class 0 OID 0)
-- Dependencies: 273
-- Name: setting_document_counter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 46, true);


--
-- TOC entry 3891 (class 0 OID 0)
-- Dependencies: 277
-- Name: shift_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shift_id_seq', 12, true);


--
-- TOC entry 3892 (class 0 OID 0)
-- Dependencies: 279
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 4, true);


--
-- TOC entry 3893 (class 0 OID 0)
-- Dependencies: 294
-- Name: sv_login_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sv_login_session_id_seq', 71, true);


--
-- TOC entry 3894 (class 0 OID 0)
-- Dependencies: 283
-- Name: users_experience_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);


--
-- TOC entry 3895 (class 0 OID 0)
-- Dependencies: 284
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 85, true);


--
-- TOC entry 3896 (class 0 OID 0)
-- Dependencies: 286
-- Name: users_mutation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_mutation_id_seq', 68, true);


--
-- TOC entry 3897 (class 0 OID 0)
-- Dependencies: 288
-- Name: users_shift_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);


--
-- TOC entry 3898 (class 0 OID 0)
-- Dependencies: 291
-- Name: voucher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.voucher_id_seq', 1, false);


--
-- TOC entry 3397 (class 2606 OID 18459)
-- Name: branch branch_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);


--
-- TOC entry 3401 (class 2606 OID 18461)
-- Name: branch_room branch_room_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);


--
-- TOC entry 3399 (class 2606 OID 18463)
-- Name: branch branch_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);


--
-- TOC entry 3541 (class 2606 OID 26927)
-- Name: calendar calendar_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);


--
-- TOC entry 3403 (class 2606 OID 18465)
-- Name: company company_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);


--
-- TOC entry 3405 (class 2606 OID 18467)
-- Name: customers customers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);


--
-- TOC entry 3539 (class 2606 OID 18784)
-- Name: customers_registration customers_registration_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_registration
    ADD CONSTRAINT customers_registration_pk PRIMARY KEY (id);


--
-- TOC entry 3545 (class 2606 OID 28182)
-- Name: customers_segment customers_segment_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers_segment
    ADD CONSTRAINT customers_segment_pk PRIMARY KEY (id);


--
-- TOC entry 3407 (class 2606 OID 18469)
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- TOC entry 3409 (class 2606 OID 18471)
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- TOC entry 3411 (class 2606 OID 18473)
-- Name: invoice_detail invoice_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);


--
-- TOC entry 3413 (class 2606 OID 18475)
-- Name: invoice_master invoice_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);


--
-- TOC entry 3415 (class 2606 OID 18477)
-- Name: invoice_master invoice_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);


--
-- TOC entry 3417 (class 2606 OID 18479)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3420 (class 2606 OID 18481)
-- Name: model_has_permissions model_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);


--
-- TOC entry 3423 (class 2606 OID 18483)
-- Name: model_has_roles model_has_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);


--
-- TOC entry 3425 (class 2606 OID 18485)
-- Name: order_detail order_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);


--
-- TOC entry 3427 (class 2606 OID 18487)
-- Name: order_master order_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);


--
-- TOC entry 3429 (class 2606 OID 18489)
-- Name: order_master order_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);


--
-- TOC entry 3432 (class 2606 OID 18491)
-- Name: period_stock period_stock_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);


--
-- TOC entry 3434 (class 2606 OID 18493)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3436 (class 2606 OID 18495)
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3438 (class 2606 OID 18497)
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- TOC entry 3441 (class 2606 OID 18499)
-- Name: point_conversion point_conversion_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);


--
-- TOC entry 3443 (class 2606 OID 18501)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- TOC entry 3445 (class 2606 OID 18503)
-- Name: price_adjustment price_adjustment_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);


--
-- TOC entry 3447 (class 2606 OID 18505)
-- Name: price_adjustment price_adjustment_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);


--
-- TOC entry 3449 (class 2606 OID 18507)
-- Name: product_commision_by_year product_commision_by_year_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);


--
-- TOC entry 3451 (class 2606 OID 18509)
-- Name: product_commisions product_commisions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3453 (class 2606 OID 18511)
-- Name: product_distribution product_distribution_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3455 (class 2606 OID 18513)
-- Name: product_ingredients product_ingredients_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pk PRIMARY KEY (product_id, product_id_material);


--
-- TOC entry 3457 (class 2606 OID 18515)
-- Name: product_point product_point_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3459 (class 2606 OID 18517)
-- Name: product_price product_price_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3461 (class 2606 OID 18519)
-- Name: product_sku product_sku_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);


--
-- TOC entry 3463 (class 2606 OID 18521)
-- Name: product_sku product_sku_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_un UNIQUE (abbr);


--
-- TOC entry 3467 (class 2606 OID 18523)
-- Name: product_stock_detail product_stock_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock_detail
    ADD CONSTRAINT product_stock_detail_pk PRIMARY KEY (id);


--
-- TOC entry 3465 (class 2606 OID 18525)
-- Name: product_stock product_stock_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3469 (class 2606 OID 29118)
-- Name: product_type product_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pk PRIMARY KEY (id);


--
-- TOC entry 3471 (class 2606 OID 18527)
-- Name: product_uom product_uom_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_pk PRIMARY KEY (product_id, uom_id);


--
-- TOC entry 3477 (class 2606 OID 18529)
-- Name: purchase_detail purchase_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_pk PRIMARY KEY (purchase_no, product_id);


--
-- TOC entry 3479 (class 2606 OID 18531)
-- Name: purchase_master purchase_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_pk PRIMARY KEY (id);


--
-- TOC entry 3481 (class 2606 OID 18533)
-- Name: purchase_master purchase_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_un UNIQUE (purchase_no);


--
-- TOC entry 3483 (class 2606 OID 18535)
-- Name: receive_detail receive_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_pk PRIMARY KEY (receive_no, product_id, expired_at);


--
-- TOC entry 3485 (class 2606 OID 18537)
-- Name: receive_master receive_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_pk PRIMARY KEY (id);


--
-- TOC entry 3487 (class 2606 OID 18539)
-- Name: receive_master receive_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_un UNIQUE (receive_no);


--
-- TOC entry 3489 (class 2606 OID 18541)
-- Name: return_sell_detail return_sell_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_pk PRIMARY KEY (return_sell_no, product_id);


--
-- TOC entry 3491 (class 2606 OID 18543)
-- Name: return_sell_master return_sell_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_pk PRIMARY KEY (id);


--
-- TOC entry 3493 (class 2606 OID 18545)
-- Name: return_sell_master return_sell_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_un UNIQUE (return_sell_no);


--
-- TOC entry 3495 (class 2606 OID 18547)
-- Name: role_has_permissions role_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);


--
-- TOC entry 3497 (class 2606 OID 18549)
-- Name: roles roles_name_guard_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);


--
-- TOC entry 3499 (class 2606 OID 18551)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3531 (class 2606 OID 18745)
-- Name: sales sales_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pk PRIMARY KEY (id);


--
-- TOC entry 3537 (class 2606 OID 18771)
-- Name: sales_trip_detail sales_trip_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_trip_detail
    ADD CONSTRAINT sales_trip_detail_pk PRIMARY KEY (id);


--
-- TOC entry 3535 (class 2606 OID 18759)
-- Name: sales_trip sales_trip_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_trip
    ADD CONSTRAINT sales_trip_pk PRIMARY KEY (id);


--
-- TOC entry 3533 (class 2606 OID 18747)
-- Name: sales sales_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_un UNIQUE (username);


--
-- TOC entry 3543 (class 2606 OID 27189)
-- Name: sales_visit sales_visit_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales_visit
    ADD CONSTRAINT sales_visit_pk PRIMARY KEY (id);


--
-- TOC entry 3501 (class 2606 OID 18553)
-- Name: setting_document_counter setting_document_counter_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_pk PRIMARY KEY (id);


--
-- TOC entry 3503 (class 2606 OID 18555)
-- Name: setting_document_counter setting_document_counter_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_un UNIQUE (doc_type, branch_id);


--
-- TOC entry 3505 (class 2606 OID 18557)
-- Name: settings settings_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (company_name, app_name);


--
-- TOC entry 3507 (class 2606 OID 18559)
-- Name: shift shift_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pk PRIMARY KEY (time_start, time_end);


--
-- TOC entry 3509 (class 2606 OID 18561)
-- Name: suppliers suppliers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pk PRIMARY KEY (id);


--
-- TOC entry 3529 (class 2606 OID 18733)
-- Name: login_session sv_login_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_session
    ADD CONSTRAINT sv_login_session_pkey PRIMARY KEY (id);


--
-- TOC entry 3473 (class 2606 OID 18563)
-- Name: uom uom_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);


--
-- TOC entry 3475 (class 2606 OID 18565)
-- Name: uom uom_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_un UNIQUE (remark);


--
-- TOC entry 3517 (class 2606 OID 18567)
-- Name: users_branch users_branch_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_branch
    ADD CONSTRAINT users_branch_pk PRIMARY KEY (user_id, branch_id);


--
-- TOC entry 3511 (class 2606 OID 18569)
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- TOC entry 3519 (class 2606 OID 18571)
-- Name: users_experience users_experience_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_experience
    ADD CONSTRAINT users_experience_pk PRIMARY KEY (id);


--
-- TOC entry 3521 (class 2606 OID 18573)
-- Name: users_mutation users_mutation_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_mutation
    ADD CONSTRAINT users_mutation_pk PRIMARY KEY (id);


--
-- TOC entry 3513 (class 2606 OID 18575)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3523 (class 2606 OID 18577)
-- Name: users_shift users_shift_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_shift
    ADD CONSTRAINT users_shift_pk PRIMARY KEY (branch_id, users_id, dated, shift_id);


--
-- TOC entry 3525 (class 2606 OID 18579)
-- Name: users_skills users_skills_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_pk PRIMARY KEY (users_id, modul, dated, status);


--
-- TOC entry 3515 (class 2606 OID 18581)
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- TOC entry 3527 (class 2606 OID 18583)
-- Name: voucher voucher_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voucher
    ADD CONSTRAINT voucher_pk PRIMARY KEY (voucher_code, branch_id);


--
-- TOC entry 3418 (class 1259 OID 18584)
-- Name: model_has_permissions_model_id_model_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);


--
-- TOC entry 3421 (class 1259 OID 18585)
-- Name: model_has_roles_model_id_model_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);


--
-- TOC entry 3430 (class 1259 OID 18586)
-- Name: password_resets_email_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);


--
-- TOC entry 3439 (class 1259 OID 18587)
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- TOC entry 3546 (class 2606 OID 18588)
-- Name: branch_room branch_room_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3547 (class 2606 OID 18593)
-- Name: invoice_detail invoice_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);


--
-- TOC entry 3548 (class 2606 OID 18598)
-- Name: invoice_master invoice_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3549 (class 2606 OID 18603)
-- Name: invoice_master invoice_master_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);


--
-- TOC entry 3550 (class 2606 OID 18608)
-- Name: model_has_permissions model_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 3551 (class 2606 OID 18613)
-- Name: model_has_roles model_has_roles_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 3552 (class 2606 OID 18618)
-- Name: order_detail order_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);


--
-- TOC entry 3553 (class 2606 OID 18623)
-- Name: order_master order_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3554 (class 2606 OID 18628)
-- Name: order_master order_master_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);


--
-- TOC entry 3555 (class 2606 OID 18633)
-- Name: posts posts_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3556 (class 2606 OID 18638)
-- Name: product_commision_by_year product_commision_by_year_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3557 (class 2606 OID 18643)
-- Name: product_commision_by_year product_commision_by_year_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3558 (class 2606 OID 18648)
-- Name: product_commision_by_year product_commision_by_year_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3559 (class 2606 OID 18653)
-- Name: product_distribution product_distribution_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3560 (class 2606 OID 18658)
-- Name: product_distribution product_distribution_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3561 (class 2606 OID 18663)
-- Name: product_uom product_uom_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3562 (class 2606 OID 18668)
-- Name: purchase_detail purchase_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);


--
-- TOC entry 3563 (class 2606 OID 18673)
-- Name: purchase_master purchase_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3564 (class 2606 OID 18678)
-- Name: receive_detail receive_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);


--
-- TOC entry 3565 (class 2606 OID 18683)
-- Name: receive_master receive_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3566 (class 2606 OID 18688)
-- Name: return_sell_detail return_sell_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);


--
-- TOC entry 3567 (class 2606 OID 18693)
-- Name: return_sell_master return_sell_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3568 (class 2606 OID 18698)
-- Name: return_sell_master return_sell_master_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);


--
-- TOC entry 3569 (class 2606 OID 18703)
-- Name: role_has_permissions role_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 3570 (class 2606 OID 18708)
-- Name: role_has_permissions role_has_permissions_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 3571 (class 2606 OID 18713)
-- Name: users_skills users_skills_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);


--
-- TOC entry 3812 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2023-02-18 08:19:08

--
-- PostgreSQL database dump complete
--

