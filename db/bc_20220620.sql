--
-- PostgreSQL database dump
--

-- Dumped from database version 12.11 (Ubuntu 12.11-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 12.11 (Ubuntu 12.11-0ubuntu0.20.04.1)

-- Started on 2022-06-20 20:41:47 WIB

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
-- TOC entry 3354 (class 0 OID 0)
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
-- TOC entry 3355 (class 0 OID 0)
-- Dependencies: 249
-- Name: branch_room_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.branch_room_id_seq OWNED BY public.branch_room.id;


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
    abbr character varying NOT NULL,
    branch_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
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
-- TOC entry 3356 (class 0 OID 0)
-- Dependencies: 231
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- TOC entry 224 (class 1259 OID 17963)
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    active bit(1) DEFAULT '1'::"bit" NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.department OWNER TO postgres;

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
-- TOC entry 3357 (class 0 OID 0)
-- Dependencies: 223
-- Name: department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.department_id_seq OWNED BY public.department.id;


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
-- TOC entry 3358 (class 0 OID 0)
-- Dependencies: 207
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


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
-- TOC entry 3359 (class 0 OID 0)
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
-- TOC entry 3360 (class 0 OID 0)
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
    assigned_to integer NOT NULL,
    referral_by integer
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
    payment_type integer DEFAULT 1 NOT NULL,
    payment_nominal numeric(18,0) DEFAULT 0 NOT NULL,
    is_checkout bit(1) DEFAULT '0'::"bit" NOT NULL,
    voucher_code character varying,
    printed_at timestamp without time zone
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
-- TOC entry 3361 (class 0 OID 0)
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
-- TOC entry 3362 (class 0 OID 0)
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
-- TOC entry 3363 (class 0 OID 0)
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
-- TOC entry 3364 (class 0 OID 0)
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
    created_at timestamp without time zone DEFAULT now() NOT NULL
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
-- TOC entry 3365 (class 0 OID 0)
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
    created_at timestamp without time zone DEFAULT now() NOT NULL
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
-- TOC entry 3366 (class 0 OID 0)
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
    created_at timestamp without time zone
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
    remark character varying
);


ALTER TABLE public.product_commisions OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 18094)
-- Name: product_distribution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_distribution (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    active bit(1) DEFAULT '1'::"bit" NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
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
    created_at timestamp without time zone
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
    created_by integer NOT NULL
);


ALTER TABLE public.product_sku OWNER TO postgres;

--
-- TOC entry 3367 (class 0 OID 0)
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
-- TOC entry 3368 (class 0 OID 0)
-- Dependencies: 234
-- Name: product_sku_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_sku_id_seq OWNED BY public.product_sku.id;


--
-- TOC entry 252 (class 1259 OID 18208)
-- Name: product_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_type (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
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
-- TOC entry 3369 (class 0 OID 0)
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
    created_at timestamp without time zone DEFAULT now() NOT NULL
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
-- TOC entry 3370 (class 0 OID 0)
-- Dependencies: 244
-- Name: product_uom_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_uom_id_seq OWNED BY public.uom.id;


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
-- TOC entry 3371 (class 0 OID 0)
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
    period_no integer NOT NULL
);


ALTER TABLE public.settings OWNER TO postgres;

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
    birth_date date
);


ALTER TABLE public.users OWNER TO postgres;

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
-- TOC entry 3372 (class 0 OID 0)
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
    users_id integer NOT NULL,
    branch_id integer NOT NULL,
    department_id integer NOT NULL,
    job_id integer NOT NULL,
    remark character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL
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
-- TOC entry 3373 (class 0 OID 0)
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
    remarks character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users_skills OWNER TO postgres;

--
-- TOC entry 3036 (class 2604 OID 17977)
-- Name: branch id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);


--
-- TOC entry 3076 (class 2604 OID 18189)
-- Name: branch_room id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);


--
-- TOC entry 3052 (class 2604 OID 18014)
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- TOC entry 3033 (class 2604 OID 17966)
-- Name: department id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);


--
-- TOC entry 3023 (class 2604 OID 17831)
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- TOC entry 3030 (class 2604 OID 17954)
-- Name: job_title id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);


--
-- TOC entry 3019 (class 2604 OID 17801)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 3041 (class 2604 OID 18004)
-- Name: order_master id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master ALTER COLUMN id SET DEFAULT nextval('public.order_master_id_seq'::regclass);


--
-- TOC entry 3026 (class 2604 OID 17859)
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- TOC entry 3025 (class 2604 OID 17845)
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- TOC entry 3028 (class 2604 OID 17922)
-- Name: posts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);


--
-- TOC entry 3063 (class 2604 OID 18079)
-- Name: product_brand id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_brand ALTER COLUMN id SET DEFAULT nextval('public.product_brand_id_seq'::regclass);


--
-- TOC entry 3065 (class 2604 OID 18089)
-- Name: product_category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);


--
-- TOC entry 3060 (class 2604 OID 18068)
-- Name: product_sku id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku ALTER COLUMN id SET DEFAULT nextval('public.product_sku_id_seq'::regclass);


--
-- TOC entry 3078 (class 2604 OID 18211)
-- Name: product_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_type ALTER COLUMN id SET DEFAULT nextval('public.product_type_id_seq'::regclass);


--
-- TOC entry 3027 (class 2604 OID 17872)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 3072 (class 2604 OID 18137)
-- Name: uom id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);


--
-- TOC entry 3020 (class 2604 OID 17809)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3039 (class 2604 OID 17992)
-- Name: users_mutation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_mutation ALTER COLUMN id SET DEFAULT nextval('public.users_mutation_id_seq'::regclass);


--
-- TOC entry 3321 (class 0 OID 17974)
-- Dependencies: 226
-- Data for Name: branch; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.branch (id, remark, address, city, abbr, active, created_at, updated_at) VALUES (1, 'HEAD QUARTER', 'Jakarta', 'Jakarta', 'HQ00', B'1', '2022-06-01 19:46:05.452925', NULL);
INSERT INTO public.branch (id, remark, address, city, abbr, active, created_at, updated_at) VALUES (2, 'OUTLET 01', 'Jakarta', 'Jakarta', 'OL01', B'1', '2022-06-01 19:46:05.452925', NULL);
INSERT INTO public.branch (id, remark, address, city, abbr, active, created_at, updated_at) VALUES (3, 'OUTLET 02', 'Sumatera', 'Sumatera', 'OL02', B'1', '2022-06-01 19:46:05.452925', NULL);


--
-- TOC entry 3345 (class 0 OID 18186)
-- Dependencies: 250
-- Data for Name: branch_room; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.branch_room (id, branch_id, remark, created_at, updated_at) VALUES (3, 2, 'RM-OT01-02', '2022-06-01 19:47:46.062696', NULL);
INSERT INTO public.branch_room (id, branch_id, remark, created_at, updated_at) VALUES (1, 2, 'RM-OT01-01', '2022-06-01 19:47:46.062696', NULL);
INSERT INTO public.branch_room (id, branch_id, remark, created_at, updated_at) VALUES (4, 2, 'RM-OT01-03', '2022-06-01 19:47:46.062696', NULL);
INSERT INTO public.branch_room (id, branch_id, remark, created_at, updated_at) VALUES (5, 3, 'RM-OT02-02', '2022-06-01 19:47:46.062696', NULL);
INSERT INTO public.branch_room (id, branch_id, remark, created_at, updated_at) VALUES (6, 3, 'RM-OT02-01', '2022-06-01 19:47:46.062696', NULL);
INSERT INTO public.branch_room (id, branch_id, remark, created_at, updated_at) VALUES (7, 3, 'RM-OT03-03', '2022-06-01 19:47:46.062696', NULL);


--
-- TOC entry 3327 (class 0 OID 18011)
-- Dependencies: 232
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at) VALUES (1, 'UMUM', 'UMUM', '6285746879090', 1, 'OT01-UM', 2, '2022-06-02 20:38:02.11776');
INSERT INTO public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at) VALUES (4, 'UMUM', 'UMUM', '6285746879090', 1, 'OT02-UM', 3, '2022-06-02 20:38:02.11776');


--
-- TOC entry 3319 (class 0 OID 17963)
-- Dependencies: 224
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.department (id, remark, active, created_at, updated_at) VALUES (2, 'OPERASIONAL', B'1', '2022-06-01 19:49:58.185846', NULL);
INSERT INTO public.department (id, remark, active, created_at, updated_at) VALUES (3, 'FINANCE', B'1', '2022-06-01 19:49:58.185846', NULL);
INSERT INTO public.department (id, remark, active, created_at, updated_at) VALUES (4, 'HR', B'1', '2022-06-01 19:49:58.185846', NULL);
INSERT INTO public.department (id, remark, active, created_at, updated_at) VALUES (5, 'IT', B'1', '2022-06-01 19:49:58.185846', NULL);
INSERT INTO public.department (id, remark, active, created_at, updated_at) VALUES (1, 'SALES', B'1', '2022-06-01 19:49:58.185846', NULL);
INSERT INTO public.department (id, remark, active, created_at, updated_at) VALUES (6, 'MANAGEMENT', B'1', '2022-06-01 19:49:58.185846', NULL);


--
-- TOC entry 3303 (class 0 OID 17828)
-- Dependencies: 208
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3317 (class 0 OID 17951)
-- Dependencies: 222
-- Data for Name: job_title; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.job_title (id, remark, active, created_at) VALUES (1, 'Kasir', B'1', '2022-06-01 19:52:32.509771');
INSERT INTO public.job_title (id, remark, active, created_at) VALUES (2, 'Terapist', B'1', '2022-06-01 19:52:32.509771');
INSERT INTO public.job_title (id, remark, active, created_at) VALUES (3, 'Owner', B'1', '2022-06-01 19:52:32.509771');
INSERT INTO public.job_title (id, remark, active, created_at) VALUES (6, 'Administrator', B'1', '2022-06-01 19:52:32.509771');
INSERT INTO public.job_title (id, remark, active, created_at) VALUES (4, 'Staff Finance & Accounting', B'1', '2022-06-01 19:52:32.509771');
INSERT INTO public.job_title (id, remark, active, created_at) VALUES (5, 'Staff Human Resource', B'1', '2022-06-01 19:52:32.509771');


--
-- TOC entry 3298 (class 0 OID 17798)
-- Dependencies: 203
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.migrations (id, migration, batch) VALUES (1, '2014_10_12_000000_create_users_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (2, '2014_10_12_100000_create_password_resets_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (3, '2019_08_19_000000_create_failed_jobs_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (4, '2019_12_14_000001_create_personal_access_tokens_table', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (5, '2022_05_28_121734_create_permission_tables', 1);
INSERT INTO public.migrations (id, migration, batch) VALUES (6, '2022_05_28_121901_create_posts_table', 2);


--
-- TOC entry 3310 (class 0 OID 17880)
-- Dependencies: 215
-- Data for Name: model_has_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3311 (class 0 OID 17891)
-- Dependencies: 216
-- Data for Name: model_has_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.model_has_roles (role_id, model_type, model_id) VALUES (1, 'App\Models\User', 1);
INSERT INTO public.model_has_roles (role_id, model_type, model_id) VALUES (4, 'App\Models\User', 4);
INSERT INTO public.model_has_roles (role_id, model_type, model_id) VALUES (6, 'App\Models\User', 5);
INSERT INTO public.model_has_roles (role_id, model_type, model_id) VALUES (2, 'App\Models\User', 3);
INSERT INTO public.model_has_roles (role_id, model_type, model_id) VALUES (3, 'App\Models\User', 2);
INSERT INTO public.model_has_roles (role_id, model_type, model_id) VALUES (5, 'App\Models\User', 14);


--
-- TOC entry 3328 (class 0 OID 18045)
-- Dependencies: 233
-- Data for Name: order_detail; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3325 (class 0 OID 18001)
-- Dependencies: 230
-- Data for Name: order_master; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3301 (class 0 OID 17819)
-- Dependencies: 206
-- Data for Name: password_resets; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3337 (class 0 OID 18121)
-- Dependencies: 242
-- Data for Name: period; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202201, 'January -2022', '2022-01-01', '2022-01-31');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202202, 'February-2022', '2022-02-01', '2022-02-28');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202203, 'March -2022', '2022-03-01', '2022-03-31');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202204, 'April -2022', '2022-04-01', '2022-04-30');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202205, 'May -2022', '2022-05-01', '2022-05-31');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202206, 'June-2022', '2022-06-01', '2022-06-30');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202207, 'July-2022', '2022-07-01', '2022-07-31');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202208, 'August-2022', '2022-08-01', '2022-08-31');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202209, 'September -2022', '2022-09-01', '2022-09-30');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202210, 'October -2022', '2022-10-01', '2022-10-31');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202211, 'November-2022', '2022-11-01', '2022-11-30');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202212, 'December-2022', '2022-12-01', '2022-12-31');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202301, 'January -2023', '2023-01-01', '2023-01-31');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202302, 'February-2023', '2023-02-01', '2023-02-28');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202303, 'March -2023', '2023-03-01', '2023-03-31');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202304, 'April -2023', '2023-04-01', '2023-04-30');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202305, 'May -2023', '2023-05-01', '2023-05-31');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202306, 'June-2023', '2023-06-01', '2023-06-30');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202307, 'July-2023', '2023-07-01', '2023-07-31');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202308, 'August-2023', '2023-08-01', '2023-08-31');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202309, 'September -2023', '2023-09-01', '2023-09-30');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202310, 'October -2023', '2023-10-01', '2023-10-31');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202311, 'November-2023', '2023-11-01', '2023-11-30');
INSERT INTO public.period (period_no, remark, start_date, end_date) VALUES (202312, 'December-2023', '2023-12-01', '2023-12-01');


--
-- TOC entry 3307 (class 0 OID 17856)
-- Dependencies: 212
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (2, 'logout.perform', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (4, 'users.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (5, 'users.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (6, 'users.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (7, 'users.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (9, 'users.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (11, 'users.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (12, 'users.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (14, 'roles.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (15, 'roles.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (16, 'posts.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (18, 'posts.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (19, 'posts.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (20, 'posts.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (21, 'posts.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (22, 'roles.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (23, 'roles.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (24, 'roles.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (25, 'roles.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (26, 'home.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (17, 'posts.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (8, 'posts.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (27, 'branchs.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (28, 'branchs.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (29, 'branchs.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (30, 'branchs.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (32, 'branchs.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (33, 'branchs.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (34, 'branchs.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (35, 'departments.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (36, 'departments.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (37, 'departments.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (38, 'departments.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (40, 'departments.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (41, 'departments.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (42, 'departments.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (43, 'rooms.create', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (44, 'rooms.delete', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (45, 'rooms.destroy', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (46, 'rooms.edit', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (48, 'rooms.show', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (49, 'rooms.store', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (50, 'rooms.update', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (47, 'rooms.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/rooms', 'Room', 'Settings');
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (51, 'users.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (52, 'users.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (53, 'branchs.export', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (54, 'branchs.search', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', NULL, NULL, NULL);
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (1, 'roles.index', 'web', '2022-06-05 07:50:24', '2022-06-05 07:50:24', '/roles', 'Roles', 'Users');
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (3, 'users.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/users', 'Users', 'Users');
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (13, 'permissions.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/permissions', 'Permissions', 'Users');
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (31, 'branchs.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/branchs', 'Branchs', 'Users');
INSERT INTO public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) VALUES (39, 'departments.index', 'web', '2022-05-28 14:34:15', '2022-05-28 14:34:15', '/departments', 'Departments', 'Users');


--
-- TOC entry 3305 (class 0 OID 17842)
-- Dependencies: 210
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3314 (class 0 OID 17919)
-- Dependencies: 219
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.posts (id, user_id, title, description, body, created_at, updated_at) VALUES (2, 1, '1', '12', '1', '2022-05-28 15:29:26', '2022-05-28 15:29:30');


--
-- TOC entry 3332 (class 0 OID 18076)
-- Dependencies: 237
-- Data for Name: product_brand; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_brand (id, remark, created_at) VALUES (1, 'General', '2022-06-01 20:47:29.575876');
INSERT INTO public.product_brand (id, remark, created_at) VALUES (2, 'ACL', '2022-06-01 20:47:29.580415');
INSERT INTO public.product_brand (id, remark, created_at) VALUES (3, 'Bali Alus', '2022-06-01 20:47:29.582037');
INSERT INTO public.product_brand (id, remark, created_at) VALUES (4, 'Green Spa', '2022-06-01 20:47:29.583737');
INSERT INTO public.product_brand (id, remark, created_at) VALUES (5, 'Biokos', '2022-06-01 20:47:29.585597');
INSERT INTO public.product_brand (id, remark, created_at) VALUES (6, 'Ianthe', '2022-06-01 20:47:29.587679');


--
-- TOC entry 3334 (class 0 OID 18086)
-- Dependencies: 239
-- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_category (id, remark, created_at) VALUES (1, 'Treatment Body', '2022-06-01 20:43:14.593652');
INSERT INTO public.product_category (id, remark, created_at) VALUES (2, 'Treatment Face', '2022-06-01 20:43:14.599894');
INSERT INTO public.product_category (id, remark, created_at) VALUES (3, 'Treatment Female', '2022-06-01 20:43:14.60163');
INSERT INTO public.product_category (id, remark, created_at) VALUES (4, 'Treatment Scrub', '2022-06-01 20:43:14.603521');
INSERT INTO public.product_category (id, remark, created_at) VALUES (5, 'Treatment Foot', '2022-06-01 20:43:14.605776');
INSERT INTO public.product_category (id, remark, created_at) VALUES (6, 'Add Ons', '2022-06-01 20:43:14.607895');
INSERT INTO public.product_category (id, remark, created_at) VALUES (7, 'Serum', '2022-06-01 20:43:14.607895');
INSERT INTO public.product_category (id, remark, created_at) VALUES (8, 'Gel', '2022-06-01 20:43:14.607895');
INSERT INTO public.product_category (id, remark, created_at) VALUES (9, 'Cream', '2022-06-01 20:43:14.607895');
INSERT INTO public.product_category (id, remark, created_at) VALUES (10, 'Spray', '2022-06-01 20:43:14.607895');
INSERT INTO public.product_category (id, remark, created_at) VALUES (11, 'Sabun', '2022-06-01 20:43:14.607895');
INSERT INTO public.product_category (id, remark, created_at) VALUES (12, 'Minuman', '2022-06-01 20:43:14.607895');
INSERT INTO public.product_category (id, remark, created_at) VALUES (13, 'Masker', '2022-06-01 20:43:14.607895');


--
-- TOC entry 3343 (class 0 OID 18163)
-- Dependencies: 248
-- Data for Name: product_commision_by_year; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (39, 2, 2, 1, 30000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (40, 2, 2, 1, 30000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (41, 2, 2, 1, 30000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (59, 2, 2, 1, 30000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (43, 2, 2, 5, 30000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (44, 2, 2, 5, 30000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (45, 2, 2, 5, 30000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (46, 2, 2, 5, 30000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (43, 2, 2, 1, 22000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (44, 2, 2, 1, 22000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (45, 2, 2, 1, 22000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (46, 2, 2, 1, 22000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (47, 2, 2, 1, 17000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (48, 2, 2, 1, 17000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (49, 2, 2, 1, 25000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (50, 2, 2, 1, 15000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (51, 2, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (52, 2, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (53, 2, 2, 1, 40000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (54, 2, 2, 1, 20000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (55, 2, 2, 1, 10000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (56, 2, 2, 1, 10000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (57, 2, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (58, 2, 2, 1, 50000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (61, 2, 2, 1, 55000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (62, 2, 2, 1, 15000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (63, 2, 2, 1, 10000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (64, 2, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (65, 2, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (66, 2, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (67, 2, 2, 1, 8000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (69, 2, 2, 1, 10000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (68, 2, 2, 1, 7000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (39, 2, 2, 2, 32000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (39, 2, 2, 3, 34000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (39, 2, 2, 4, 36000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (39, 2, 2, 5, 38000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (40, 2, 2, 2, 32000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (40, 2, 2, 4, 36000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (40, 2, 2, 5, 38000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (41, 2, 2, 2, 32000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (41, 2, 2, 3, 34000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (41, 2, 2, 4, 36000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (41, 2, 2, 5, 38000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (42, 2, 2, 2, 24000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (42, 2, 2, 3, 26000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (42, 2, 2, 4, 28000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (42, 2, 2, 5, 30000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (43, 2, 2, 2, 24000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (43, 2, 2, 3, 26000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (43, 2, 2, 4, 28000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (44, 2, 2, 2, 24000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (44, 2, 2, 4, 28000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (45, 2, 2, 2, 24000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (45, 2, 2, 3, 26000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (45, 2, 2, 4, 28000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (46, 2, 2, 2, 24000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (46, 2, 2, 3, 26000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (46, 2, 2, 4, 28000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (47, 2, 2, 2, 19000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (47, 2, 2, 3, 21000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (47, 2, 2, 4, 23000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (47, 2, 2, 5, 25000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (48, 2, 2, 2, 19000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (48, 2, 2, 3, 21000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (48, 2, 2, 4, 23000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (49, 2, 2, 2, 27000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (49, 2, 2, 3, 29000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (49, 2, 2, 4, 31000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (49, 2, 2, 5, 33000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (50, 2, 2, 2, 17000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (50, 2, 2, 3, 19000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (50, 2, 2, 4, 21000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (51, 2, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (51, 2, 2, 3, 8000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (51, 2, 2, 4, 9000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (52, 2, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (52, 2, 2, 3, 8000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (52, 2, 2, 4, 8000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (53, 2, 2, 2, 42000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (53, 2, 2, 4, 46000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (54, 2, 2, 2, 22000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (54, 2, 2, 3, 24000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (54, 2, 2, 4, 26000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (55, 2, 2, 2, 10000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (55, 2, 2, 3, 12000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (55, 2, 2, 4, 12000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (56, 2, 2, 2, 10000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (56, 2, 2, 3, 12000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (56, 2, 2, 4, 12000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (57, 2, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (57, 2, 2, 3, 9000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (57, 2, 2, 4, 9000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (58, 2, 2, 2, 52000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (58, 2, 2, 4, 56000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (59, 2, 2, 2, 32000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (59, 2, 2, 3, 34000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (59, 2, 2, 4, 36000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (60, 2, 2, 2, 27000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (60, 2, 2, 3, 29000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (60, 2, 2, 4, 31000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (61, 2, 2, 2, 57000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (61, 2, 2, 3, 59000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (61, 2, 2, 4, 61000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (62, 2, 2, 2, 17000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (62, 2, 2, 3, 19000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (62, 2, 2, 4, 21000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (63, 2, 2, 2, 10000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (63, 2, 2, 4, 16000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (64, 2, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (64, 2, 2, 3, 10000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (64, 2, 2, 4, 10000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (65, 2, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (65, 2, 2, 3, 10000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (65, 2, 2, 4, 10000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (66, 2, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (66, 2, 2, 3, 10000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (66, 2, 2, 4, 10000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (67, 2, 2, 2, 8000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (67, 2, 2, 3, 8000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (67, 2, 2, 4, 9000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (68, 2, 2, 2, 7000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (68, 2, 2, 4, 8000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (69, 2, 2, 2, 10000, 1, '2022-06-03 18:50:52.711437');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (69, 2, 2, 3, 10000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (69, 2, 2, 4, 11000, 1, '2022-06-03 18:51:04.512776');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (54, 2, 2, 7, 30000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (39, 2, 2, 7, 42000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (39, 2, 2, 8, 44000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (40, 2, 2, 6, 40000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (40, 2, 2, 7, 42000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (40, 2, 2, 8, 44000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (40, 2, 2, 9, 46000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (41, 2, 2, 6, 40000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (41, 2, 2, 7, 42000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (41, 2, 2, 8, 44000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (41, 2, 2, 9, 46000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (42, 2, 2, 6, 32000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (42, 2, 2, 7, 34000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (42, 2, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (42, 2, 2, 9, 38000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (43, 2, 2, 6, 32000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (43, 2, 2, 7, 34000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (43, 2, 2, 9, 38000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (44, 2, 2, 6, 32000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (44, 2, 2, 7, 34000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (44, 2, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (44, 2, 2, 9, 38000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (45, 2, 2, 6, 32000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (45, 2, 2, 7, 34000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (45, 2, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (45, 2, 2, 9, 38000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (46, 2, 2, 6, 32000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (46, 2, 2, 7, 34000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (46, 2, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (46, 2, 2, 9, 38000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (47, 2, 2, 6, 27000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (47, 2, 2, 8, 31000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (47, 2, 2, 9, 33000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (48, 2, 2, 6, 27000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (48, 2, 2, 7, 29000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (48, 2, 2, 8, 31000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (48, 2, 2, 9, 33000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (49, 2, 2, 6, 34000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (49, 2, 2, 7, 35000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (49, 2, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (49, 2, 2, 9, 37000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (50, 2, 2, 5, 23000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (50, 2, 2, 6, 25000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (50, 2, 2, 7, 27000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (50, 2, 2, 8, 29000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (51, 2, 2, 5, 9000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (51, 2, 2, 6, 9000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (51, 2, 2, 7, 10000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (51, 2, 2, 8, 10000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (51, 2, 2, 9, 10000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (52, 2, 2, 5, 8000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (52, 2, 2, 6, 8000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (52, 2, 2, 7, 8000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (52, 2, 2, 8, 8000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (52, 2, 2, 9, 8000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (53, 2, 2, 5, 48000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (53, 2, 2, 6, 50000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (53, 2, 2, 7, 52000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (53, 2, 2, 8, 54000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (54, 2, 2, 5, 28000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (54, 2, 2, 6, 29000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (54, 2, 2, 8, 31000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (54, 2, 2, 9, 32000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (55, 2, 2, 5, 14000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (55, 2, 2, 6, 14000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (55, 2, 2, 7, 16000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (55, 2, 2, 8, 16000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (55, 2, 2, 9, 18000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (56, 2, 2, 5, 14000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (56, 2, 2, 6, 14000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (56, 2, 2, 7, 16000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (56, 2, 2, 8, 16000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (56, 2, 2, 9, 18000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (57, 2, 2, 6, 10000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (57, 2, 2, 7, 11000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (57, 2, 2, 8, 11000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (57, 2, 2, 9, 12000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (58, 2, 2, 5, 58000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (58, 2, 2, 6, 60000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (58, 2, 2, 7, 62000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (58, 2, 2, 8, 64000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (58, 2, 2, 9, 66000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (59, 2, 2, 5, 38000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (59, 2, 2, 6, 39000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (59, 2, 2, 7, 40000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (59, 2, 2, 8, 41000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (59, 2, 2, 9, 42000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (60, 2, 2, 6, 34000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (60, 2, 2, 7, 35000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (60, 2, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (60, 2, 2, 9, 37000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (61, 2, 2, 5, 63000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (61, 2, 2, 6, 65000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (61, 2, 2, 7, 67000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (61, 2, 2, 8, 69000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (61, 2, 2, 9, 71000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (62, 2, 2, 5, 23000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (62, 2, 2, 6, 25000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (62, 2, 2, 7, 27000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (62, 2, 2, 8, 29000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (63, 2, 2, 5, 18000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (63, 2, 2, 7, 20000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (63, 2, 2, 8, 21000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (64, 2, 2, 5, 12000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (64, 2, 2, 6, 12000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (64, 2, 2, 7, 14000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (64, 2, 2, 8, 14000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (65, 2, 2, 5, 12000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (65, 2, 2, 6, 12000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (65, 2, 2, 7, 14000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (65, 2, 2, 8, 14000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (66, 2, 2, 5, 12000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (66, 2, 2, 6, 12000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (66, 2, 2, 7, 14000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (66, 2, 2, 8, 14000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (67, 2, 2, 6, 9000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (67, 2, 2, 7, 10000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (67, 2, 2, 8, 10000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (68, 2, 2, 5, 8000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (68, 2, 2, 6, 8000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (68, 2, 2, 7, 9000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (68, 2, 2, 8, 9000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (69, 2, 2, 5, 11000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (69, 2, 2, 6, 11000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (69, 2, 2, 7, 12000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (69, 2, 2, 8, 12000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (42, 2, 2, 1, 22000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (60, 2, 2, 1, 25000, 1, '2022-06-03 18:50:28.944639');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (39, 2, 2, 6, 40000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (39, 2, 2, 9, 46000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (39, 2, 2, 10, 48000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (40, 2, 2, 3, 34000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (40, 2, 2, 10, 48000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (41, 2, 2, 10, 48000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (42, 2, 2, 10, 40000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (43, 2, 2, 8, 36000, 1, '2022-06-03 18:51:23.555736');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (43, 2, 2, 10, 40000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (44, 2, 2, 3, 26000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (44, 2, 2, 10, 40000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (45, 2, 2, 10, 40000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (46, 2, 2, 10, 40000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (47, 2, 2, 7, 29000, 1, '2022-06-03 18:51:18.966034');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (47, 2, 2, 10, 35000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (48, 2, 2, 5, 25000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (48, 2, 2, 10, 35000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (49, 2, 2, 10, 38000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (50, 2, 2, 9, 31000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (50, 2, 2, 10, 33000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (51, 2, 2, 10, 11000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (52, 2, 2, 10, 8000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (53, 2, 2, 3, 44000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (53, 2, 2, 9, 56000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (53, 2, 2, 10, 58000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (54, 2, 2, 10, 33000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (55, 2, 2, 10, 18000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (56, 2, 2, 10, 18000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (57, 2, 2, 5, 10000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (57, 2, 2, 10, 12000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (58, 2, 2, 3, 54000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (58, 2, 2, 10, 68000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (59, 2, 2, 10, 43000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (60, 2, 2, 5, 33000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (60, 2, 2, 10, 38000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (61, 2, 2, 10, 73000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (62, 2, 2, 9, 31000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (62, 2, 2, 10, 33000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (63, 2, 2, 3, 14000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (63, 2, 2, 6, 19000, 1, '2022-06-03 18:51:14.244667');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (63, 2, 2, 9, 22000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (63, 2, 2, 10, 23000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (64, 2, 2, 9, 16000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (64, 2, 2, 10, 16000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (65, 2, 2, 9, 16000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (65, 2, 2, 10, 16000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (66, 2, 2, 9, 16000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (66, 2, 2, 10, 16000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (67, 2, 2, 5, 9000, 1, '2022-06-03 18:51:09.209737');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (67, 2, 2, 9, 10000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (67, 2, 2, 10, 11000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (68, 2, 2, 3, 7000, 1, '2022-06-03 18:50:57.947429');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (68, 2, 2, 9, 9000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (68, 2, 2, 10, 10000, 1, '2022-06-03 18:51:32.672537');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (69, 2, 2, 9, 12000, 1, '2022-06-03 18:51:27.832534');
INSERT INTO public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at) VALUES (69, 2, 2, 10, 13000, 1, '2022-06-03 18:51:32.672537');


--
-- TOC entry 3341 (class 0 OID 18143)
-- Dependencies: 246
-- Data for Name: product_commisions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (33, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (34, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (35, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (36, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (37, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (39, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (40, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (41, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (42, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (43, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (44, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (45, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (46, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (47, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (48, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (49, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (50, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (51, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (52, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (53, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (54, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (55, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (56, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (57, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (58, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (59, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (60, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (61, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (62, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (63, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (64, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (65, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (66, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (67, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (68, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (70, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (69, 2, 0, 0, 0, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (1, 2, 0, 0, 25000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (2, 2, 2000, 10000, 12000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (3, 2, 0, 0, 50000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (4, 2, 0, 0, 25000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (5, 2, 0, 0, 25000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (6, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (7, 2, 0, 0, 50000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (8, 2, 0, 0, 30000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (9, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (11, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (14, 2, 0, 0, 5000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (15, 2, 0, 0, 15000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (16, 2, 0, 0, 15000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (17, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (18, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (19, 2, 0, 0, 50000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (20, 2, 0, 0, 20000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (21, 2, 0, 0, 20000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (22, 2, 0, 0, 20000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (23, 2, 0, 0, 15000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (24, 2, 0, 0, 15000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (25, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (26, 2, 0, 0, 25000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (27, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (10, 2, 4000, 16000, 20000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (12, 2, 4000, 16000, 20000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (13, 2, 3000, 12000, 15000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (28, 2, 0, 0, 50000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (29, 2, 0, 0, 30000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (30, 2, 0, 0, 5000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (31, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '');
INSERT INTO public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark) VALUES (32, 2, 0, 0, 10000, '2022-06-03 18:34:36.005823', 1, '');


--
-- TOC entry 3335 (class 0 OID 18094)
-- Dependencies: 240
-- Data for Name: product_distribution; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (1, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (8, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (9, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (10, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (11, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (12, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (13, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (18, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (19, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (20, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (21, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (24, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (27, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (28, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (29, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (30, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (31, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (33, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (34, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (2, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (3, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (4, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (5, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (32, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (6, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (22, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (7, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (14, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (15, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (16, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (23, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (35, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (36, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (37, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (25, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (26, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (17, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (39, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (40, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (41, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (42, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (43, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (44, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (45, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (46, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (47, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (48, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (49, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (50, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (51, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (52, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (53, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (54, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (55, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (56, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (57, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (58, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (59, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (60, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (61, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (62, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (63, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (64, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (65, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (66, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (67, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (68, 1, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (1, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (8, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (9, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (10, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (11, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (12, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (13, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (18, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (19, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (20, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (21, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (24, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (27, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (28, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (29, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (30, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (31, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (33, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (34, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (2, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (3, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (4, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (5, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (32, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (6, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (22, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (7, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (14, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (15, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (16, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (23, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (35, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (36, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (37, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (25, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (26, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (17, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (39, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (40, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (41, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (42, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (43, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (44, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (45, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (46, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (47, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (48, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (49, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (50, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (51, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (52, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (53, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (54, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (55, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (56, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (57, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (58, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (59, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (60, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (61, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (62, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (63, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (64, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (65, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (66, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (67, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (68, 2, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (1, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (8, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (9, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (10, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (11, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (12, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (13, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (18, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (19, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (20, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (21, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (24, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (27, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (28, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (29, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (30, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (31, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (33, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (34, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (2, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (3, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (4, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (5, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (32, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (6, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (22, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (7, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (14, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (15, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (16, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (23, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (35, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (36, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (37, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (25, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (26, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (17, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (39, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (40, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (41, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (42, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (43, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (44, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (45, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (46, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (47, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (48, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (49, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (50, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (51, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (52, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (53, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (54, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (55, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (56, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (57, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (58, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (59, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (60, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (61, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (62, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (63, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (64, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (65, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (66, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (67, 3, B'1', '2022-06-02 21:03:50.006459');
INSERT INTO public.product_distribution (product_id, branch_id, active, created_at) VALUES (68, 3, B'1', '2022-06-02 21:03:50.006459');


--
-- TOC entry 3342 (class 0 OID 18157)
-- Dependencies: 247
-- Data for Name: product_point; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (1, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (8, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (9, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (10, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (11, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (12, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (13, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (18, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (19, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (20, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (21, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (24, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (27, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (28, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (29, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (30, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (31, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (33, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (34, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (2, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (3, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (4, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (5, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (32, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (6, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (22, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (7, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (14, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (15, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (16, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (23, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (35, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (36, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (37, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (25, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (26, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (17, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (39, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (40, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (41, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (42, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (43, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (44, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (45, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (46, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (47, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (48, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (49, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (50, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (53, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (54, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (59, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (60, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (61, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (62, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (63, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (1, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (8, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (9, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (10, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (11, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (12, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (13, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (18, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (19, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (20, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (21, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (24, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (27, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (28, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (29, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (30, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (31, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (33, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (34, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (2, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (3, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (4, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (5, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (32, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (6, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (22, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (7, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (14, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (15, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (16, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (23, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (35, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (36, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (37, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (25, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (26, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (17, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (39, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (40, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (41, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (42, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (43, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (44, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (45, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (46, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (47, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (48, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (49, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (50, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (51, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (53, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (54, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (59, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (60, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (61, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (62, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (63, 2, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (1, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (8, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (9, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (10, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (11, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (12, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (13, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (18, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (19, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (20, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (21, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (24, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (27, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (28, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (29, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (30, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (31, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (33, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (34, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (2, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (3, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (4, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (5, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (52, 2, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (55, 2, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (55, 1, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (56, 1, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (56, 2, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (57, 2, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (57, 1, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (58, 2, 2, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (58, 1, 2, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (65, 1, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (65, 2, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (66, 2, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (66, 1, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (67, 2, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (68, 2, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (68, 1, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (64, 2, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (64, 1, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (32, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (6, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (22, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (7, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (14, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (15, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (16, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (23, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (35, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (36, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (37, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (25, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (26, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (17, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (39, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (40, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (41, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (42, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (43, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (44, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (45, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (46, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (47, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (48, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (49, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (50, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (51, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (53, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (54, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (59, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (60, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (61, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (62, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (63, 3, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (51, 1, 1, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (52, 1, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (52, 3, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (55, 3, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (56, 3, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (57, 3, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (58, 3, 2, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (65, 3, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (66, 3, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (67, 1, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (67, 3, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (68, 3, 0, 1, '2022-06-02 21:09:40.977165');
INSERT INTO public.product_point (product_id, branch_id, point, created_by, created_at) VALUES (64, 3, 0, 1, '2022-06-02 21:09:40.977165');


--
-- TOC entry 3336 (class 0 OID 18115)
-- Dependencies: 241
-- Data for Name: product_price; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (1, 150000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (2, 20000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (2, 20000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (3, 250000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (3, 250000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (4, 175000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (4, 175000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (5, 175000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (5, 175000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (6, 40000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (7, 150000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (7, 150000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (8, 150000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (8, 150000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (9, 60000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (9, 60000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (10, 60000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (10, 60000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (11, 25000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (11, 25000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (12, 65000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (12, 65000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (13, 40000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (13, 40000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (14, 35000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (14, 35000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (15, 60000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (16, 60000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (16, 60000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (17, 50000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (17, 50000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (18, 50000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (18, 50000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (19, 175000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (19, 175000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (20, 100000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (20, 100000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (21, 150000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (21, 150000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (22, 125000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (22, 125000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (23, 100000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (23, 100000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (24, 100000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (24, 100000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (25, 25000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (26, 250000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (26, 250000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (27, 50000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (27, 50000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (28, 60000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (28, 60000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (29, 500000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (29, 500000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (30, 25000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (30, 25000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (31, 200000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (31, 200000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (32, 50000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (32, 50000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (33, 50000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (33, 50000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (34, 40000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (35, 5000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (35, 5000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (36, 5000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (36, 5000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (37, 5000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (37, 5000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (39, 160000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (39, 160000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (40, 160000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (40, 160000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (41, 160000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (41, 160000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (42, 135000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (43, 135000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (44, 135000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (45, 135000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (46, 135000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (47, 110000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (49, 160000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (50, 110000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (51, 80000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (52, 70000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (53, 300000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (54, 160000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (55, 100000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (56, 100000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (57, 65000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (58, 325000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (59, 185000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (60, 100000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (61, 80000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (62, 75000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (63, 70000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (65, 70000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (64, 75000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (67, 70000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (66, 70000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (1, 150000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (1, 150000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (2, 20000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (3, 250000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (4, 175000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (5, 175000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (6, 40000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (6, 40000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (7, 150000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (8, 150000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (9, 60000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (10, 60000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (11, 25000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (12, 65000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (13, 40000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (14, 35000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (15, 60000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (15, 60000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (16, 60000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (17, 50000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (18, 50000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (19, 175000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (20, 100000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (21, 150000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (22, 125000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (23, 100000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (24, 100000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (25, 25000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (25, 25000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (26, 250000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (27, 50000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (28, 60000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (29, 500000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (30, 25000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (31, 200000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (32, 50000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (33, 50000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (34, 40000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (34, 40000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (35, 5000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (36, 5000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (37, 5000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (39, 160000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (40, 160000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (41, 160000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (42, 135000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (42, 135000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (43, 135000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (43, 135000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (44, 135000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (44, 135000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (45, 135000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (45, 135000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (46, 135000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (46, 135000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (47, 110000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (47, 110000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (48, 110000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (48, 110000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (48, 110000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (49, 160000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (49, 160000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (50, 110000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (50, 110000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (51, 80000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (51, 80000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (52, 70000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (52, 70000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (53, 300000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (53, 300000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (54, 160000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (54, 160000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (55, 100000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (55, 100000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (56, 100000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (56, 100000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (57, 65000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (57, 65000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (58, 325000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (58, 325000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (59, 185000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (59, 185000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (60, 100000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (60, 100000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (61, 80000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (62, 75000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (62, 75000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (63, 70000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (63, 70000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (61, 80000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (64, 75000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (65, 70000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (65, 70000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (66, 70000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (64, 75000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (68, 50000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (68, 50000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (68, 50000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (69, 60000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (67, 70000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (66, 70000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (69, 60000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (69, 60000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (70, 60000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (70, 60000, 2, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (70, 60000, 1, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');
INSERT INTO public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) VALUES (67, 70000, 3, 1, '2022-06-02 21:08:26.621553', 1, '2022-06-02 21:08:26.621553');


--
-- TOC entry 3330 (class 0 OID 18065)
-- Dependencies: 235
-- Data for Name: product_sku; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (1, 'ACL - ANTISEPTIK GEL', 'ACL AG', NULL, NULL, B'1', 8, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (8, 'ACL - MILK BATH', 'ACL MB', NULL, NULL, B'1', 8, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (9, 'ACL - PENYEGAR WAJAH ', 'ACL PYGR WJ', NULL, NULL, B'1', 8, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (10, 'BALI ALUS - BODY WITHENING', 'BA BW', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (11, 'BALI ALUS - DUDUS CELUP ', 'BA DC', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (12, 'BALI ALUS - LIGHTENING', 'BA LGHTN', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (13, 'BALI ALUS - LULUR GREENTEA', 'BA LLR GRNT', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (18, 'BALI ALUS - SWETY SLIMM', 'BA SWTY SLM', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (19, 'NELAYAN NUSANTARA BATHSALT VCO RELAX', 'NN BTHSLT VCO', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (20, 'GREEN SPA LULUR BALI ALUS', 'GS LLR BA', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (21, 'BIOKOS - CLEANSER', 'BK CLNSR', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (24, 'BIOKOS - PEELING', 'BK  PLNG', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (27, 'CELANA KAIN STANDAR', 'G CLN STD', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (28, 'HERBAL COMPRESS', 'G HRBL COMPS', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (29, 'KOP BADAN BESAR', 'G KOP BDN L', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (30, 'LILIN EC', 'G LLN EC', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (31, 'TATAKAN WAJAH JELLY', 'G WJH JLLY', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (33, 'KAYU REFLEKSI SEGITIGA', 'G KYU RFL S3', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (34, 'KAYU REFLEKSI BINTANG', 'G KYU RFL STR', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (2, 'ACL - CREAM HANGAT BUNGKUS', 'ACL CH B', NULL, NULL, B'1', 9, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (3, 'ACL - CREAM HANGAT BOTOL', 'ACL CH BT', NULL, NULL, B'1', 9, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (4, 'ACL - FOOT SPRAY', 'ACL FS', NULL, NULL, B'1', 10, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (5, 'ACL - LINEN SPRAY', 'ACL LS', NULL, NULL, B'1', 10, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (32, 'PEELING SPRAY', 'G PLLG SPRY', NULL, NULL, B'1', 10, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (6, 'ACL - MASSAGE CREAM BUNGAN JEPUN', 'ACL MSG CRM BJ', NULL, NULL, B'1', 9, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (22, 'BIOKOS - CREAM MASSAGE ', 'BK CRM MSSG', NULL, NULL, B'1', 9, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (7, 'ACL - MASKER BADAN', 'ACL MSK BD', NULL, NULL, B'1', 13, 1, 2, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (14, 'BALI ALUS - MASKER ARMPIT', 'BA MSK ARMP', NULL, NULL, B'1', 13, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (15, 'BALI ALUS - MASKER PAYUDARA B', 'BA MSK PYDR B', NULL, NULL, B'1', 13, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (16, 'BALI ALUS - MASKER PAYUDARA K', 'BA MSK PYDR K', NULL, NULL, B'1', 13, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (23, 'BIOKOS - GELK MASK', 'BK GLK MSK', NULL, NULL, B'1', 13, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (35, 'THE BANDULAN ', 'BDLN', NULL, NULL, B'1', 12, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (36, 'GOLDA', 'GLDA', NULL, NULL, B'1', 12, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (37, 'GREAT', 'G GRT', NULL, NULL, B'1', 12, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (25, 'IANTHE SERUM VITAMIN C 5 ML', 'IT SRM VIT C 5ML', NULL, NULL, B'1', 7, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (26, 'IANTHE SERUM VITAMIN C 100 ML', 'IT SRM VIT C 100ML', NULL, NULL, B'1', 7, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (17, 'BALI ALUS - SABUN SIRIH', 'BA SBN SRH', NULL, NULL, B'1', 11, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (39, 'Mixing Thai', 'SRVC B MT', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (40, 'Body Herbal Compress ', 'SRVC B BHC', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (41, 'Shiatsu', 'SRVC B SHSU', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (42, 'Dry Massage', 'SRVC B DRY MSG', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (43, 'Tuina', 'SRVC B TNA', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (44, 'Hot Stone', 'SRVC B HOT STN', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (45, 'Full Body Reflexology', 'SRVC B FULL BD RF', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (46, 'Full Body Therapy', 'SRVC B FULL BD TR', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (47, 'Back Massage / Dry', 'SRVC B BCK MSG', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (48, 'Body Cop With Massage', 'SRVC B BCOP MSG', NULL, NULL, B'1', 1, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (49, 'Facial Biokos and Accu Aura With Vitamin', 'SRVC F BKOS AUR', NULL, NULL, B'1', 2, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (50, 'Face Refreshing Biokos', 'SRVC F BKOS RFHS', NULL, NULL, B'1', 2, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (51, 'Ear Candling', 'SRVC F EAR CDL', NULL, NULL, B'1', 2, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (52, 'Accu Aura', 'SRVC F ACC AURA', NULL, NULL, B'1', 2, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (53, 'V- Spa', 'SRVC FL VSPA', NULL, NULL, B'1', 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (54, 'Breast and Slimming Therapy', 'SRVC FL BRST SLMM TRP', NULL, NULL, B'1', 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (55, 'Slimming', 'SRVC FL SLMM', NULL, NULL, B'1', 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (56, 'Breast', 'SRVC FL BRST', NULL, NULL, B'1', 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (57, 'Ratus With Hand Massage', 'SRVC FL RTS HND MSG', NULL, NULL, B'1', 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (58, 'Executive Bali Body Scrub', 'SRVC SC BDY SCRB', NULL, NULL, B'1', 3, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (59, 'Body Bleacing Package', 'SRVC SC BDY  BLCH', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (60, 'Bali Alus Body Scrub', 'SRVC BA BDY SCRB', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (61, 'Lulur Aromatherapy', 'SRVC BA LLR ARMTRY', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (62, 'Foot Reflexology', 'SRVC FT REFKS', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (63, 'Foot Express', 'SRVC FT REFKS EPRS', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (64, 'Herbal Compress', 'SRVC ADN HRBL CMPS', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (65, 'Mandi Susu', 'SRVC ADN MND SSU', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (66, 'Body Cop Package', 'SRVC ADN BDY CP', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (67, 'Masker Badan', 'SRVC ADN MSK BDN', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (68, 'Steam Badan', 'SRVC STRM BDN', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (70, 'CELANA KAIN JUMBO', 'G CLN JMB', NULL, NULL, B'1', 8, 1, 3, NULL, NULL, '2022-06-01 21:06:02.021847', 1);
INSERT INTO public.product_sku (id, remark, abbr, alias_code, barcode, active, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by) VALUES (69, 'Extra Time', 'SRVC ADN EXT TME', NULL, NULL, B'1', 4, 2, 1, NULL, NULL, '2022-06-01 21:06:02.021847', 1);


--
-- TOC entry 3347 (class 0 OID 18208)
-- Dependencies: 252
-- Data for Name: product_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_type (id, remark, created_by, created_at) VALUES (2, 'Goods', 1, '2022-06-01 21:02:38.43164');
INSERT INTO public.product_type (id, remark, created_by, created_at) VALUES (1, 'Services', 1, '2022-06-01 21:02:38.43164');
INSERT INTO public.product_type (id, remark, created_by, created_at) VALUES (3, 'Goods & Services', 1, '2022-06-01 21:02:38.43164');


--
-- TOC entry 3348 (class 0 OID 18216)
-- Dependencies: 253
-- Data for Name: product_uom; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (1, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (9, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (21, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (24, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (30, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (3, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (4, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (5, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (35, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (36, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (37, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (26, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (17, 1, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (2, 2, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (6, 2, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (7, 2, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (8, 2, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (19, 2, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (20, 2, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (10, 3, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (12, 3, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (18, 3, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (22, 3, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (23, 3, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (11, 5, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (14, 5, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (13, 4, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (28, 4, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (31, 4, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (32, 4, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (33, 4, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (34, 4, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (15, 6, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (16, 6, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (29, 6, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (25, 7, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (27, 8, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (70, 8, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (39, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (40, 12, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (41, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (42, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (43, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (44, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (45, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (46, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (47, 19, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (48, 19, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (49, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (50, 19, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (51, 11, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (52, 10, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (53, 9, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (54, 19, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (55, 10, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (56, 10, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (57, 16, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (58, 20, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (59, 21, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (60, 19, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (61, 12, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (62, 19, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (63, 11, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (64, 10, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (65, 16, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (66, 16, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (67, 10, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (68, 16, '2022-06-03 17:38:00.278845', 1);
INSERT INTO public.product_uom (product_id, uom_id, created_at, create_by) VALUES (69, 10, '2022-06-03 17:38:00.278845', 1);


--
-- TOC entry 3312 (class 0 OID 17902)
-- Dependencies: 217
-- Data for Name: role_has_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (39, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (28, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (29, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (27, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (30, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (31, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (32, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (33, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (34, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (35, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (36, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (37, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (38, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (40, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (41, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (42, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (43, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (44, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (45, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (46, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (47, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (48, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (49, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (50, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (51, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (52, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (53, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (54, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (1, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (2, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (3, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (4, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (5, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (6, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (7, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (9, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (11, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (12, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (13, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (14, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (15, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (8, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (16, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (17, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (18, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (19, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (20, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (21, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (22, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (23, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (24, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (25, 1);
INSERT INTO public.role_has_permissions (permission_id, role_id) VALUES (26, 1);


--
-- TOC entry 3309 (class 0 OID 17869)
-- Dependencies: 214
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.roles (id, name, guard_name, created_at, updated_at) VALUES (1, 'admin', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles (id, name, guard_name, created_at, updated_at) VALUES (2, 'owner', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles (id, name, guard_name, created_at, updated_at) VALUES (3, 'cashier', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles (id, name, guard_name, created_at, updated_at) VALUES (5, 'terapist', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles (id, name, guard_name, created_at, updated_at) VALUES (4, 'admin_finance', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');
INSERT INTO public.roles (id, name, guard_name, created_at, updated_at) VALUES (6, 'hr', 'web', '2022-05-28 12:40:11', '2022-05-28 12:40:11');


--
-- TOC entry 3338 (class 0 OID 18128)
-- Dependencies: 243
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3340 (class 0 OID 18134)
-- Dependencies: 245
-- Data for Name: uom; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (1, 'Botol', 1, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (2, 'Bungkus', 1, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (3, 'Tube', 1, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (4, 'Buah', 1, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (5, 'Sacheet', 1, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (6, 'Kotak', 1, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (7, 'Amplus', 1, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (8, 'Pcs', 1, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (9, '90 Menit', 90, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (10, '30 Menit', 30, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (11, '45 Menit', 45, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (12, '120 Menit', 120, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (13, '5 Menit', 5, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (14, '10 Menit', 10, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (15, '15 Menit', 15, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (16, '20 Menit', 20, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (17, '1 Menit', 1, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (18, 'Pasang', 1, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (19, '60 Menit', 60, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (20, '150 Menit', 150, '2022-06-01 20:55:39.248472');
INSERT INTO public.uom (id, remark, conversion, created_at) VALUES (21, '100 Menit', 100, '2022-06-01 20:55:39.248472');


--
-- TOC entry 3300 (class 0 OID 17806)
-- Dependencies: 205
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, active, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date) VALUES (2, 'User-Kasir', 'kasir@gmail.com', 'user-kasir', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-06-11 03:28:24', '6285746879090', 'JALAN JAKARTA', '2022-01-05', 1, 'Female', '35241112331443300012', B'1', 'JAKARTA', '20210101KSR', 'user-13.jpg', 'contract.png', 1, 1, 2, 1, 'JAKARTA', '2022-01-01');
INSERT INTO public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, active, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date) VALUES (1, 'Admin', 'admin@gmail.com', 'admin', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-05-28 12:40:11', '6285746879090', 'JALAN JAKARTA', '2020-01-01', 2, 'Male', '3524111233144330001', B'1', 'JAKARTA', '20210101ADM', 'user-13.jpg', 'user-13.jpg', 6, 2, 5, NULL, 'JAKARTA', '2022-01-01');
INSERT INTO public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, active, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date) VALUES (3, 'User-Owner', 'owner@gmail.com', 'user-owner', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-06-08 15:30:01', '6285746879090', 'JALAN JAKARTA', '2022-01-01', 1, 'Male', '3524111233144330001', B'1', 'JAKARTA', '20210101OWN', 'user-13.jpg', 'user-13.jpg', 3, 1, 6, NULL, 'JAKARTA', '2022-01-01');
INSERT INTO public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, active, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date) VALUES (4, 'User-Admin Keuangan', 'finance@gmail.com', 'user-finance', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-05-28 12:40:11', '6285746879090', 'JALAN JAKARTA', '2022-01-01', 1, 'Male', '3524111233144330001', B'1', 'JAKARTA', '20210101ADU', 'user-13.jpg', 'user-13.jpg', 4, 2, 3, NULL, 'JAKARTA', '2022-01-01');
INSERT INTO public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, active, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date) VALUES (5, 'User-HR', 'hr@gmail.com', 'user-hr', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-05-28 12:40:11', '6285746879090', 'JALAN JAKARTA', '2022-01-01', 1, 'Male', '3524111233144330001', B'1', 'JAKARTA', '20210101HR', 'user-13.jpg', 'user-13.jpg', 5, 1, 4, NULL, 'JAKARTA', '2022-01-01');
INSERT INTO public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, active, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date) VALUES (14, 'User-Terapist', 'terapist@gmail.com', 'user-terapist', NULL, '$2y$10$wYGHsVtIPTpaFqJ9w1kQReUW1xjk14eUZbPDemq9Yz5qNuwdOj1Ta', NULL, '2022-05-28 12:40:11', '2022-06-11 12:06:30', '6285746879090', 'JALAN JAKARTA', '2022-01-01', 1, 'Male', '3524111233144330001', B'1', 'JAKARTA', '20210101TRP', 'user-13.jpg', 'user-13.jpg', 2, 1, 2, 5, 'JAKARTA', '2022-01-01');


--
-- TOC entry 3323 (class 0 OID 17989)
-- Dependencies: 228
-- Data for Name: users_mutation; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3315 (class 0 OID 17935)
-- Dependencies: 220
-- Data for Name: users_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3374 (class 0 OID 0)
-- Dependencies: 225
-- Name: branch_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_id_seq', 7, true);


--
-- TOC entry 3375 (class 0 OID 0)
-- Dependencies: 249
-- Name: branch_room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.branch_room_id_seq', 10, true);


--
-- TOC entry 3376 (class 0 OID 0)
-- Dependencies: 231
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_id_seq', 4, true);


--
-- TOC entry 3377 (class 0 OID 0)
-- Dependencies: 223
-- Name: department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.department_id_seq', 7, true);


--
-- TOC entry 3378 (class 0 OID 0)
-- Dependencies: 207
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- TOC entry 3379 (class 0 OID 0)
-- Dependencies: 221
-- Name: job_title_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.job_title_id_seq', 6, true);


--
-- TOC entry 3380 (class 0 OID 0)
-- Dependencies: 202
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 6, true);


--
-- TOC entry 3381 (class 0 OID 0)
-- Dependencies: 229
-- Name: order_master_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_master_id_seq', 1, false);


--
-- TOC entry 3382 (class 0 OID 0)
-- Dependencies: 211
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 54, true);


--
-- TOC entry 3383 (class 0 OID 0)
-- Dependencies: 209
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);


--
-- TOC entry 3384 (class 0 OID 0)
-- Dependencies: 218
-- Name: posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.posts_id_seq', 2, true);


--
-- TOC entry 3385 (class 0 OID 0)
-- Dependencies: 236
-- Name: product_brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_brand_id_seq', 6, true);


--
-- TOC entry 3386 (class 0 OID 0)
-- Dependencies: 238
-- Name: product_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_category_id_seq', 13, true);


--
-- TOC entry 3387 (class 0 OID 0)
-- Dependencies: 234
-- Name: product_sku_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_sku_id_seq', 71, true);


--
-- TOC entry 3388 (class 0 OID 0)
-- Dependencies: 251
-- Name: product_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_type_id_seq', 3, true);


--
-- TOC entry 3389 (class 0 OID 0)
-- Dependencies: 244
-- Name: product_uom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_uom_id_seq', 21, true);


--
-- TOC entry 3390 (class 0 OID 0)
-- Dependencies: 213
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 10, true);


--
-- TOC entry 3391 (class 0 OID 0)
-- Dependencies: 204
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 20, true);


--
-- TOC entry 3392 (class 0 OID 0)
-- Dependencies: 227
-- Name: users_mutation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_mutation_id_seq', 1, false);


--
-- TOC entry 3120 (class 2606 OID 17984)
-- Name: branch branch_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);


--
-- TOC entry 3152 (class 2606 OID 18195)
-- Name: branch_room branch_room_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);


--
-- TOC entry 3122 (class 2606 OID 17986)
-- Name: branch branch_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);


--
-- TOC entry 3130 (class 2606 OID 18021)
-- Name: customers customers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);


--
-- TOC entry 3091 (class 2606 OID 17837)
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- TOC entry 3093 (class 2606 OID 17839)
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- TOC entry 3082 (class 2606 OID 17803)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3109 (class 2606 OID 17890)
-- Name: model_has_permissions model_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);


--
-- TOC entry 3112 (class 2606 OID 17901)
-- Name: model_has_roles model_has_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);


--
-- TOC entry 3132 (class 2606 OID 18057)
-- Name: order_detail order_detail_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);


--
-- TOC entry 3126 (class 2606 OID 18029)
-- Name: order_master order_master_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);


--
-- TOC entry 3128 (class 2606 OID 18031)
-- Name: order_master order_master_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);


--
-- TOC entry 3100 (class 2606 OID 17866)
-- Name: permissions permissions_name_guard_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_name_guard_name_unique UNIQUE (name, guard_name);


--
-- TOC entry 3102 (class 2606 OID 17864)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3095 (class 2606 OID 17850)
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3097 (class 2606 OID 17853)
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- TOC entry 3116 (class 2606 OID 17927)
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- TOC entry 3150 (class 2606 OID 18168)
-- Name: product_commision_by_year product_commision_by_year_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);


--
-- TOC entry 3146 (class 2606 OID 18156)
-- Name: product_commisions product_commisions_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3138 (class 2606 OID 18100)
-- Name: product_distribution product_distribution_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3148 (class 2606 OID 18162)
-- Name: product_point product_point_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3140 (class 2606 OID 18120)
-- Name: product_price product_price_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);


--
-- TOC entry 3134 (class 2606 OID 18107)
-- Name: product_sku product_sku_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);


--
-- TOC entry 3136 (class 2606 OID 18109)
-- Name: product_sku product_sku_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_un UNIQUE (abbr);


--
-- TOC entry 3154 (class 2606 OID 18221)
-- Name: product_uom product_uom_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_pk PRIMARY KEY (product_id, uom_id);


--
-- TOC entry 3114 (class 2606 OID 17916)
-- Name: role_has_permissions role_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);


--
-- TOC entry 3104 (class 2606 OID 17879)
-- Name: roles roles_name_guard_name_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);


--
-- TOC entry 3106 (class 2606 OID 17877)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3142 (class 2606 OID 18228)
-- Name: uom uom_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);


--
-- TOC entry 3144 (class 2606 OID 18230)
-- Name: uom uom_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_un UNIQUE (remark);


--
-- TOC entry 3084 (class 2606 OID 17816)
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- TOC entry 3124 (class 2606 OID 17998)
-- Name: users_mutation users_mutation_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_mutation
    ADD CONSTRAINT users_mutation_pk PRIMARY KEY (id);


--
-- TOC entry 3086 (class 2606 OID 17814)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3118 (class 2606 OID 17943)
-- Name: users_skills users_skills_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_pk PRIMARY KEY (users_id, remarks);


--
-- TOC entry 3088 (class 2606 OID 17818)
-- Name: users users_username_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);


--
-- TOC entry 3107 (class 1259 OID 17883)
-- Name: model_has_permissions_model_id_model_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);


--
-- TOC entry 3110 (class 1259 OID 17894)
-- Name: model_has_roles_model_id_model_type_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);


--
-- TOC entry 3089 (class 1259 OID 17825)
-- Name: password_resets_email_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);


--
-- TOC entry 3098 (class 1259 OID 17851)
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- TOC entry 3169 (class 2606 OID 18201)
-- Name: branch_room branch_room_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3155 (class 2606 OID 17884)
-- Name: model_has_permissions model_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 3156 (class 2606 OID 17895)
-- Name: model_has_roles model_has_roles_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 3163 (class 2606 OID 18058)
-- Name: order_detail order_detail_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);


--
-- TOC entry 3161 (class 2606 OID 18032)
-- Name: order_master order_master_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3162 (class 2606 OID 18037)
-- Name: order_master order_master_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);


--
-- TOC entry 3159 (class 2606 OID 17928)
-- Name: posts posts_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3166 (class 2606 OID 18169)
-- Name: product_commision_by_year product_commision_by_year_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3167 (class 2606 OID 18174)
-- Name: product_commision_by_year product_commision_by_year_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3168 (class 2606 OID 18179)
-- Name: product_commision_by_year product_commision_by_year_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 3164 (class 2606 OID 18101)
-- Name: product_distribution product_distribution_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);


--
-- TOC entry 3165 (class 2606 OID 18110)
-- Name: product_distribution product_distribution_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3170 (class 2606 OID 18222)
-- Name: product_uom product_uom_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);


--
-- TOC entry 3157 (class 2606 OID 17905)
-- Name: role_has_permissions role_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- TOC entry 3158 (class 2606 OID 17910)
-- Name: role_has_permissions role_has_permissions_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- TOC entry 3160 (class 2606 OID 17944)
-- Name: users_skills users_skills_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);


-- Completed on 2022-06-20 20:41:47 WIB

--
-- PostgreSQL database dump complete
--

