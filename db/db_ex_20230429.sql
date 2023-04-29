PGDMP     9                    {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    17913    ex_template    DATABASE     s   CREATE DATABASE ex_template WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE ex_template;
                postgres    false            	            2615    34376    pgagent    SCHEMA        CREATE SCHEMA pgagent;
    DROP SCHEMA pgagent;
                postgres    false            �           0    0    SCHEMA pgagent    COMMENT     6   COMMENT ON SCHEMA pgagent IS 'pgAgent system tables';
                   postgres    false    9                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            �           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    7                        3079    34377    pgagent 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgagent WITH SCHEMA pgagent;
    DROP EXTENSION pgagent;
                   false    9            �           0    0    EXTENSION pgagent    COMMENT     >   COMMENT ON EXTENSION pgagent IS 'A PostgreSQL job scheduler';
                        false    2            �            1259    17914    branch    TABLE     i  CREATE TABLE public.branch (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    address character varying NOT NULL,
    city character varying NOT NULL,
    abbr character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    active smallint DEFAULT 1 NOT NULL
);
    DROP TABLE public.branch;
       public         heap    postgres    false    7            �            1259    17922    branch_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branch_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.branch_id_seq;
       public          postgres    false    206    7            �           0    0    branch_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.branch_id_seq OWNED BY public.branch.id;
          public          postgres    false    207            �            1259    17924    branch_room    TABLE     �   CREATE TABLE public.branch_room (
    id integer NOT NULL,
    branch_id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);
    DROP TABLE public.branch_room;
       public         heap    postgres    false    7            �            1259    17931    branch_room_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branch_room_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.branch_room_id_seq;
       public          postgres    false    7    208            �           0    0    branch_room_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.branch_room_id_seq OWNED BY public.branch_room.id;
          public          postgres    false    209            )           1259    18720    branch_shift    TABLE       CREATE TABLE public.branch_shift (
    id smallint NOT NULL,
    branch_id integer NOT NULL,
    shift_id integer NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
     DROP TABLE public.branch_shift;
       public         heap    postgres    false    7            (           1259    18718    branch_shift_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branch_shift_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.branch_shift_id_seq;
       public          postgres    false    7    297            �           0    0    branch_shift_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.branch_shift_id_seq OWNED BY public.branch_shift.id;
          public          postgres    false    296            5           1259    26919    calendar    TABLE       CREATE TABLE public.calendar (
    id bigint NOT NULL,
    dated date NOT NULL,
    week character varying,
    period character varying NOT NULL,
    updated_at timestamp without time zone,
    updated_by integer,
    created_by integer,
    created_at timestamp without time zone
);
    DROP TABLE public.calendar;
       public         heap    postgres    false    7            4           1259    26917    calendar_id_seq    SEQUENCE     x   CREATE SEQUENCE public.calendar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.calendar_id_seq;
       public          postgres    false    309    7            �           0    0    calendar_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.calendar_id_seq OWNED BY public.calendar.id;
          public          postgres    false    308            �            1259    17933    company    TABLE     r  CREATE TABLE public.company (
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
    DROP TABLE public.company;
       public         heap    postgres    false    7            �            1259    17940    company_id_seq    SEQUENCE     �   CREATE SEQUENCE public.company_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.company_id_seq;
       public          postgres    false    210    7            �           0    0    company_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.company_id_seq OWNED BY public.company.id;
          public          postgres    false    211            �            1259    17942 	   customers    TABLE     !  CREATE TABLE public.customers (
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
    DROP TABLE public.customers;
       public         heap    postgres    false    7            �            1259    17950    customers_id_seq    SEQUENCE     y   CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.customers_id_seq;
       public          postgres    false    7    212            �           0    0    customers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;
          public          postgres    false    213            3           1259    18774    customers_registration    TABLE     �  CREATE TABLE public.customers_registration (
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
 *   DROP TABLE public.customers_registration;
       public         heap    postgres    false    7            2           1259    18772    customers_registration_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customers_registration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.customers_registration_id_seq;
       public          postgres    false    307    7            �           0    0    customers_registration_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.customers_registration_id_seq OWNED BY public.customers_registration.id;
          public          postgres    false    306            9           1259    28173    customers_segment    TABLE     �   CREATE TABLE public.customers_segment (
    id integer NOT NULL,
    remark character varying,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
 %   DROP TABLE public.customers_segment;
       public         heap    postgres    false    7            8           1259    28171    customers_segment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customers_segment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.customers_segment_id_seq;
       public          postgres    false    7    313            �           0    0    customers_segment_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.customers_segment_id_seq OWNED BY public.customers_segment.id;
          public          postgres    false    312            �            1259    17952    departments    TABLE     �   CREATE TABLE public.departments (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    active smallint DEFAULT 1 NOT NULL
);
    DROP TABLE public.departments;
       public         heap    postgres    false    7            �            1259    17960    department_id_seq    SEQUENCE     �   CREATE SEQUENCE public.department_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.department_id_seq;
       public          postgres    false    214    7            �           0    0    department_id_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.department_id_seq OWNED BY public.departments.id;
          public          postgres    false    215            �            1259    17962    failed_jobs    TABLE     &  CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
    DROP TABLE public.failed_jobs;
       public         heap    postgres    false    7            �            1259    17969    failed_jobs_id_seq    SEQUENCE     {   CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.failed_jobs_id_seq;
       public          postgres    false    7    216            �           0    0    failed_jobs_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;
          public          postgres    false    217            �            1259    17971    invoice_detail    TABLE     �  CREATE TABLE public.invoice_detail (
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
    price_purchase numeric(18,0) DEFAULT 0,
    executed_at time without time zone
);
 "   DROP TABLE public.invoice_detail;
       public         heap    postgres    false    7            B           1259    34018    invoice_detail_log    TABLE     �  CREATE TABLE public.invoice_detail_log (
    invoice_no character varying,
    product_id character varying,
    qty character varying,
    price character varying,
    total character varying,
    discount character varying,
    seq character varying,
    assigned_to character varying,
    referral_by character varying,
    updated_at character varying,
    created_at character varying,
    uom character varying,
    product_name character varying,
    vat character varying,
    vat_total character varying,
    assigned_to_name character varying,
    referral_by_name character varying,
    price_purchase character varying,
    executed_at time without time zone,
    created_at_insert timestamp without time zone DEFAULT now() NOT NULL
);
 &   DROP TABLE public.invoice_detail_log;
       public         heap    postgres    false    7            ?           1259    33377    invoice_log    TABLE     �  CREATE TABLE public.invoice_log (
    id character varying,
    invoice_no character varying,
    dated character varying,
    customers_id character varying,
    total character varying,
    tax character varying,
    total_payment character varying,
    total_discount character varying,
    remark character varying,
    payment_type character varying,
    payment_nominal character varying,
    voucher_code character varying,
    scheduled_at character varying,
    branch_room_id character varying,
    ref_no character varying,
    updated_by character varying,
    printed_at character varying,
    updated_at character varying,
    created_by character varying,
    created_at character varying,
    is_checkout character varying,
    is_canceled character varying,
    customers_name character varying,
    printed_count character varying,
    customer_type character varying,
    created_at_insert timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.invoice_log;
       public         heap    postgres    false    7            �            1259    17984    invoice_master    TABLE     _  CREATE TABLE public.invoice_master (
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
    customer_type character varying,
    voucher_no character varying
);
 "   DROP TABLE public.invoice_master;
       public         heap    postgres    false    7            �            1259    18001    invoice_master_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.invoice_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.invoice_master_id_seq;
       public          postgres    false    7    219            �           0    0    invoice_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.invoice_master_id_seq OWNED BY public.invoice_master.id;
          public          postgres    false    220            �            1259    18003 	   job_title    TABLE     �   CREATE TABLE public.job_title (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    active smallint DEFAULT 1 NOT NULL
);
    DROP TABLE public.job_title;
       public         heap    postgres    false    7            �            1259    18011    job_title_id_seq    SEQUENCE     �   CREATE SEQUENCE public.job_title_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.job_title_id_seq;
       public          postgres    false    7    221            �           0    0    job_title_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.job_title_id_seq OWNED BY public.job_title.id;
          public          postgres    false    222            +           1259    18727    login_session    TABLE       CREATE TABLE public.login_session (
    id bigint NOT NULL,
    session character varying(50) NOT NULL,
    sellercode character varying(20) NOT NULL,
    description character varying(100) NOT NULL,
    created_date timestamp without time zone DEFAULT now() NOT NULL
);
 !   DROP TABLE public.login_session;
       public         heap    postgres    false    7            �            1259    18013 
   migrations    TABLE     �   CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);
    DROP TABLE public.migrations;
       public         heap    postgres    false    7            �            1259    18016    migrations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.migrations_id_seq;
       public          postgres    false    7    223            �           0    0    migrations_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;
          public          postgres    false    224            �            1259    18018    model_has_permissions    TABLE     �   CREATE TABLE public.model_has_permissions (
    permission_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);
 )   DROP TABLE public.model_has_permissions;
       public         heap    postgres    false    7            �            1259    18021    model_has_roles    TABLE     �   CREATE TABLE public.model_has_roles (
    role_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);
 #   DROP TABLE public.model_has_roles;
       public         heap    postgres    false    7            �            1259    18024    order_detail    TABLE     �  CREATE TABLE public.order_detail (
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
     DROP TABLE public.order_detail;
       public         heap    postgres    false    7            �            1259    18036    order_master    TABLE     Q  CREATE TABLE public.order_master (
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
     DROP TABLE public.order_master;
       public         heap    postgres    false    7            �            1259    18053    order_master_id_seq    SEQUENCE     |   CREATE SEQUENCE public.order_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.order_master_id_seq;
       public          postgres    false    228    7            �           0    0    order_master_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.order_master_id_seq OWNED BY public.order_master.id;
          public          postgres    false    229            �            1259    18055    password_resets    TABLE     �   CREATE TABLE public.password_resets (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);
 #   DROP TABLE public.password_resets;
       public         heap    postgres    false    7            �            1259    18061    period    TABLE     �   CREATE TABLE public.period (
    period_no integer NOT NULL,
    remark character varying NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL
);
    DROP TABLE public.period;
       public         heap    postgres    false    7            �            1259    18067    period_price_sell    TABLE     X  CREATE TABLE public.period_price_sell (
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
 %   DROP TABLE public.period_price_sell;
       public         heap    postgres    false    7            �            1259    18071    period_price_sell_id_seq    SEQUENCE     �   CREATE SEQUENCE public.period_price_sell_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.period_price_sell_id_seq;
       public          postgres    false    232    7            �           0    0    period_price_sell_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.period_price_sell_id_seq OWNED BY public.period_price_sell.id;
          public          postgres    false    233            �            1259    18073    period_stock    TABLE     �  CREATE TABLE public.period_stock (
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
     DROP TABLE public.period_stock;
       public         heap    postgres    false    7            �            1259    18083    permissions    TABLE     K  CREATE TABLE public.permissions (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    url character varying,
    remark character varying,
    parent character varying
);
    DROP TABLE public.permissions;
       public         heap    postgres    false    7            �            1259    18089    permissions_id_seq    SEQUENCE     {   CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.permissions_id_seq;
       public          postgres    false    7    235            �           0    0    permissions_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;
          public          postgres    false    236            �            1259    18091    personal_access_tokens    TABLE     �  CREATE TABLE public.personal_access_tokens (
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
 *   DROP TABLE public.personal_access_tokens;
       public         heap    postgres    false    7            �            1259    18097    personal_access_tokens_id_seq    SEQUENCE     �   CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.personal_access_tokens_id_seq;
       public          postgres    false    237    7            �           0    0    personal_access_tokens_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;
          public          postgres    false    238            <           1259    30744 
   petty_cash    TABLE     �  CREATE TABLE public.petty_cash (
    id bigint NOT NULL,
    dated date DEFAULT (now())::date NOT NULL,
    remark character varying,
    total numeric,
    updated_at timestamp without time zone,
    updated_by integer,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    type character varying,
    branch_id integer NOT NULL,
    doc_no character varying
);
    DROP TABLE public.petty_cash;
       public         heap    postgres    false    7            >           1259    30759    petty_cash_detail    TABLE     �  CREATE TABLE public.petty_cash_detail (
    id bigint NOT NULL,
    dated date DEFAULT (now())::date NOT NULL,
    remark character varying,
    product_id integer DEFAULT 0 NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    price numeric,
    line_total numeric,
    updated_at timestamp without time zone,
    updated_by integer,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    doc_no character varying NOT NULL
);
 %   DROP TABLE public.petty_cash_detail;
       public         heap    postgres    false    7            =           1259    30757    petty_cash_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.petty_cash_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.petty_cash_detail_id_seq;
       public          postgres    false    7    318            �           0    0    petty_cash_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.petty_cash_detail_id_seq OWNED BY public.petty_cash_detail.id;
          public          postgres    false    317            ;           1259    30742    petty_cash_id_seq    SEQUENCE     z   CREATE SEQUENCE public.petty_cash_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.petty_cash_id_seq;
       public          postgres    false    7    316            �           0    0    petty_cash_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.petty_cash_id_seq OWNED BY public.petty_cash.id;
          public          postgres    false    315            �            1259    18099    point_conversion    TABLE        CREATE TABLE public.point_conversion (
    point_qty integer DEFAULT 0 NOT NULL,
    point_value integer DEFAULT 0 NOT NULL
);
 $   DROP TABLE public.point_conversion;
       public         heap    postgres    false    7            �            1259    18104    posts    TABLE     $  CREATE TABLE public.posts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    title character varying(70) NOT NULL,
    description character varying(320) NOT NULL,
    body text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.posts;
       public         heap    postgres    false    7            �            1259    18110    posts_id_seq    SEQUENCE     u   CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.posts_id_seq;
       public          postgres    false    240    7            �           0    0    posts_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;
          public          postgres    false    241            �            1259    18112    price_adjustment    TABLE     k  CREATE TABLE public.price_adjustment (
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
 $   DROP TABLE public.price_adjustment;
       public         heap    postgres    false    7            �            1259    18117    price_adjustment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.price_adjustment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.price_adjustment_id_seq;
       public          postgres    false    7    242            �           0    0    price_adjustment_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.price_adjustment_id_seq OWNED BY public.price_adjustment.id;
          public          postgres    false    243            �            1259    18119    product_brand    TABLE     �   CREATE TABLE public.product_brand (
    id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);
 !   DROP TABLE public.product_brand;
       public         heap    postgres    false    7            �            1259    18127    product_brand_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_brand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.product_brand_id_seq;
       public          postgres    false    7    244            �           0    0    product_brand_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.product_brand_id_seq OWNED BY public.product_brand.id;
          public          postgres    false    245            �            1259    18129    product_category    TABLE        CREATE TABLE public.product_category (
    id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);
 $   DROP TABLE public.product_category;
       public         heap    postgres    false    7            �            1259    18137    product_category_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.product_category_id_seq;
       public          postgres    false    246    7            �           0    0    product_category_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;
          public          postgres    false    247            �            1259    18139    product_commision_by_year    TABLE     O  CREATE TABLE public.product_commision_by_year (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    jobs_id integer NOT NULL,
    years integer DEFAULT 1 NOT NULL,
    "values" integer NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
 -   DROP TABLE public.product_commision_by_year;
       public         heap    postgres    false    7            �            1259    18143    product_commisions    TABLE     _  CREATE TABLE public.product_commisions (
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
 &   DROP TABLE public.product_commisions;
       public         heap    postgres    false    7            �            1259    18149    product_distribution    TABLE       CREATE TABLE public.product_distribution (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    active smallint DEFAULT 1 NOT NULL
);
 (   DROP TABLE public.product_distribution;
       public         heap    postgres    false    7            �            1259    18154    product_ingredients    TABLE     H  CREATE TABLE public.product_ingredients (
    product_id integer NOT NULL,
    product_id_material integer NOT NULL,
    uom_id integer NOT NULL,
    qty integer DEFAULT 1 NOT NULL,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
 '   DROP TABLE public.product_ingredients;
       public         heap    postgres    false    7            �            1259    18159    product_point    TABLE     �   CREATE TABLE public.product_point (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    point integer DEFAULT 0 NOT NULL,
    created_by integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
 !   DROP TABLE public.product_point;
       public         heap    postgres    false    7            �            1259    18163    product_price    TABLE     -  CREATE TABLE public.product_price (
    product_id integer NOT NULL,
    price numeric(18,0) DEFAULT 0 NOT NULL,
    branch_id integer NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);
 !   DROP TABLE public.product_price;
       public         heap    postgres    false    7            :           1259    30122    product_price_level    TABLE     �  CREATE TABLE public.product_price_level (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    qty_min integer DEFAULT 0 NOT NULL,
    qty_max integer DEFAULT 9999999 NOT NULL,
    value double precision DEFAULT 0 NOT NULL,
    updated_at timestamp without time zone,
    update_by integer,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
 '   DROP TABLE public.product_price_level;
       public         heap    postgres    false    7            �            1259    18167    product_sku    TABLE     f  CREATE TABLE public.product_sku (
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
    DROP TABLE public.product_sku;
       public         heap    postgres    false    7            �           0    0    COLUMN product_sku.type_id    COMMENT     G   COMMENT ON COLUMN public.product_sku.type_id IS '''Product/Service''';
          public          postgres    false    254            �            1259    18176    product_sku_id_seq    SEQUENCE     {   CREATE SEQUENCE public.product_sku_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.product_sku_id_seq;
       public          postgres    false    7    254            �           0    0    product_sku_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.product_sku_id_seq OWNED BY public.product_sku.id;
          public          postgres    false    255                        1259    18178    product_stock    TABLE       CREATE TABLE public.product_stock (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer
);
 !   DROP TABLE public.product_stock;
       public         heap    postgres    false    7                       1259    18183    product_stock_detail    TABLE     u  CREATE TABLE public.product_stock_detail (
    id bigint NOT NULL,
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    expired_at date DEFAULT (now() + '2 years'::interval) NOT NULL,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer
);
 (   DROP TABLE public.product_stock_detail;
       public         heap    postgres    false    7                       1259    18189    product_stock_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_stock_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.product_stock_detail_id_seq;
       public          postgres    false    7    257            �           0    0    product_stock_detail_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.product_stock_detail_id_seq OWNED BY public.product_stock_detail.id;
          public          postgres    false    258                       1259    18191    product_type    TABLE     �   CREATE TABLE public.product_type (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    abbr character varying
);
     DROP TABLE public.product_type;
       public         heap    postgres    false    7                       1259    18198    product_type_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_type_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.product_type_id_seq;
       public          postgres    false    7    259            �           0    0    product_type_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.product_type_id_seq OWNED BY public.product_type.id;
          public          postgres    false    260                       1259    18200    product_uom    TABLE     �   CREATE TABLE public.product_uom (
    product_id integer NOT NULL,
    uom_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    create_by integer,
    updated_at timestamp without time zone
);
    DROP TABLE public.product_uom;
       public         heap    postgres    false    7                       1259    18204    uom    TABLE       CREATE TABLE public.uom (
    id integer NOT NULL,
    remark character varying NOT NULL,
    conversion integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);
    DROP TABLE public.uom;
       public         heap    postgres    false    7                       1259    18213    product_uom_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_uom_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.product_uom_id_seq;
       public          postgres    false    7    262            �           0    0    product_uom_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.product_uom_id_seq OWNED BY public.uom.id;
          public          postgres    false    263                       1259    18215    purchase_detail    TABLE     |  CREATE TABLE public.purchase_detail (
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
 #   DROP TABLE public.purchase_detail;
       public         heap    postgres    false    7            	           1259    18230    purchase_master    TABLE     �  CREATE TABLE public.purchase_master (
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
 #   DROP TABLE public.purchase_master;
       public         heap    postgres    false    7            
           1259    18246    purchase_master_id_seq    SEQUENCE        CREATE SEQUENCE public.purchase_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.purchase_master_id_seq;
       public          postgres    false    265    7            �           0    0    purchase_master_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.purchase_master_id_seq OWNED BY public.purchase_master.id;
          public          postgres    false    266                       1259    18248    receive_detail    TABLE     |  CREATE TABLE public.receive_detail (
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
 "   DROP TABLE public.receive_detail;
       public         heap    postgres    false    7                       1259    18262    receive_master    TABLE     �  CREATE TABLE public.receive_master (
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
 "   DROP TABLE public.receive_master;
       public         heap    postgres    false    7                       1259    18278    receive_master_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.receive_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.receive_master_id_seq;
       public          postgres    false    7    268            �           0    0    receive_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;
          public          postgres    false    269                       1259    18280    return_sell_detail    TABLE     �  CREATE TABLE public.return_sell_detail (
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
 &   DROP TABLE public.return_sell_detail;
       public         heap    postgres    false    7                       1259    18292    return_sell_master    TABLE       CREATE TABLE public.return_sell_master (
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
 &   DROP TABLE public.return_sell_master;
       public         heap    postgres    false    7                       1259    18309    return_sell_master_id_seq    SEQUENCE     �   CREATE SEQUENCE public.return_sell_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.return_sell_master_id_seq;
       public          postgres    false    271    7            �           0    0    return_sell_master_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;
          public          postgres    false    272                       1259    18311    role_has_permissions    TABLE     m   CREATE TABLE public.role_has_permissions (
    permission_id bigint NOT NULL,
    role_id bigint NOT NULL
);
 (   DROP TABLE public.role_has_permissions;
       public         heap    postgres    false    7                       1259    18314    roles    TABLE     �   CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.roles;
       public         heap    postgres    false    7                       1259    18320    roles_id_seq    SEQUENCE     u   CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.roles_id_seq;
       public          postgres    false    274    7            �           0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
          public          postgres    false    275            -           1259    18736    sales    TABLE       CREATE TABLE public.sales (
    id bigint NOT NULL,
    name character varying,
    username character varying,
    password character varying,
    address character varying,
    branch_id integer,
    active smallint DEFAULT 1 NOT NULL,
    external_code character varying
);
    DROP TABLE public.sales;
       public         heap    postgres    false    7            ,           1259    18734    sales_id_seq    SEQUENCE     u   CREATE SEQUENCE public.sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.sales_id_seq;
       public          postgres    false    7    301            �           0    0    sales_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;
          public          postgres    false    300            /           1259    18750 
   sales_trip    TABLE       CREATE TABLE public.sales_trip (
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
    DROP TABLE public.sales_trip;
       public         heap    postgres    false    7            1           1259    18762    sales_trip_detail    TABLE     b  CREATE TABLE public.sales_trip_detail (
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
 %   DROP TABLE public.sales_trip_detail;
       public         heap    postgres    false    7            0           1259    18760    sales_trip_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sales_trip_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.sales_trip_detail_id_seq;
       public          postgres    false    7    305            �           0    0    sales_trip_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;
          public          postgres    false    304            .           1259    18748    sales_trip_id_seq    SEQUENCE     z   CREATE SEQUENCE public.sales_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.sales_trip_id_seq;
       public          postgres    false    7    303            �           0    0    sales_trip_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;
          public          postgres    false    302            7           1259    27180    sales_visit    TABLE       CREATE TABLE public.sales_visit (
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
    DROP TABLE public.sales_visit;
       public         heap    postgres    false    7            6           1259    27178    sales_visit_id_seq    SEQUENCE     {   CREATE SEQUENCE public.sales_visit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.sales_visit_id_seq;
       public          postgres    false    311    7            �           0    0    sales_visit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;
          public          postgres    false    310                       1259    18322    setting_document_counter    TABLE     �  CREATE TABLE public.setting_document_counter (
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
 ,   DROP TABLE public.setting_document_counter;
       public         heap    postgres    false    7            �           0    0 &   COLUMN setting_document_counter.period    COMMENT     U   COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';
          public          postgres    false    276                       1259    18330    setting_document_counter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.setting_document_counter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.setting_document_counter_id_seq;
       public          postgres    false    7    276            �           0    0    setting_document_counter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;
          public          postgres    false    277                       1259    18332    settings    TABLE     	  CREATE TABLE public.settings (
    transaction_date date DEFAULT now() NOT NULL,
    period_no integer NOT NULL,
    company_name character varying NOT NULL,
    app_name character varying NOT NULL,
    version character varying,
    icon_file character varying
);
    DROP TABLE public.settings;
       public         heap    postgres    false    7                       1259    18339    shift    TABLE     �  CREATE TABLE public.shift (
    id integer NOT NULL,
    remark character varying,
    time_start time without time zone DEFAULT '08:00:00'::time without time zone NOT NULL,
    time_end time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    created_by integer,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.shift;
       public         heap    postgres    false    7                       1259    18348    shift_counter    TABLE     $  CREATE TABLE public.shift_counter (
    users_id integer NOT NULL,
    queue_no smallint NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    branch_id integer NOT NULL
);
 !   DROP TABLE public.shift_counter;
       public         heap    postgres    false    7                       1259    18352    shift_id_seq    SEQUENCE     �   CREATE SEQUENCE public.shift_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.shift_id_seq;
       public          postgres    false    7    279            �           0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
          public          postgres    false    281            A           1259    33393 	   stock_log    TABLE     �   CREATE TABLE public.stock_log (
    id bigint NOT NULL,
    product_id integer,
    qty integer,
    branch_id integer,
    doc_no character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    remarks character varying
);
    DROP TABLE public.stock_log;
       public         heap    postgres    false    7            @           1259    33391    stock_log_id_seq    SEQUENCE     y   CREATE SEQUENCE public.stock_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.stock_log_id_seq;
       public          postgres    false    7    321            �           0    0    stock_log_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.stock_log_id_seq OWNED BY public.stock_log.id;
          public          postgres    false    320                       1259    18354 	   suppliers    TABLE     Z  CREATE TABLE public.suppliers (
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
    DROP TABLE public.suppliers;
       public         heap    postgres    false    7                       1259    18361    suppliers_id_seq    SEQUENCE     y   CREATE SEQUENCE public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.suppliers_id_seq;
       public          postgres    false    282    7            �           0    0    suppliers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;
          public          postgres    false    283            *           1259    18725    sv_login_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sv_login_session_id_seq;
       public          postgres    false    299    7            �           0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
          public          postgres    false    298                       1259    18363    users    TABLE     �  CREATE TABLE public.users (
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
    DROP TABLE public.users;
       public         heap    postgres    false    7                       1259    18371    users_branch    TABLE     �   CREATE TABLE public.users_branch (
    user_id integer NOT NULL,
    branch_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);
     DROP TABLE public.users_branch;
       public         heap    postgres    false    7                       1259    18375    users_experience    TABLE     P  CREATE TABLE public.users_experience (
    id bigint NOT NULL,
    users_id integer NOT NULL,
    company character varying,
    job_position character varying,
    years character varying,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
 $   DROP TABLE public.users_experience;
       public         heap    postgres    false    7                       1259    18382    users_experience_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_experience_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.users_experience_id_seq;
       public          postgres    false    286    7            �           0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
          public          postgres    false    287                        1259    18384    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    7    284            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    288            !           1259    18386    users_mutation    TABLE     K  CREATE TABLE public.users_mutation (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    branch_id integer NOT NULL,
    department_id integer NOT NULL,
    job_id integer NOT NULL,
    remark character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);
 "   DROP TABLE public.users_mutation;
       public         heap    postgres    false    7            "           1259    18393    users_mutation_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.users_mutation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.users_mutation_id_seq;
       public          postgres    false    7    289            �           0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
          public          postgres    false    290            #           1259    18395    users_shift    TABLE     �  CREATE TABLE public.users_shift (
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
    DROP TABLE public.users_shift;
       public         heap    postgres    false    7            $           1259    18402    users_shift_id_seq    SEQUENCE     {   CREATE SEQUENCE public.users_shift_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.users_shift_id_seq;
       public          postgres    false    291    7            �           0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
          public          postgres    false    292            %           1259    18404    users_skills    TABLE     [  CREATE TABLE public.users_skills (
    users_id integer NOT NULL,
    modul integer NOT NULL,
    trainer integer NOT NULL,
    status character varying NOT NULL,
    dated date DEFAULT (now())::date NOT NULL,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
     DROP TABLE public.users_skills;
       public         heap    postgres    false    7            &           1259    18412    voucher    TABLE     	  CREATE TABLE public.voucher (
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
    remark character varying NOT NULL,
    price real,
    invoice_no character varying
);
    DROP TABLE public.voucher;
       public         heap    postgres    false    7            '           1259    18421    voucher_id_seq    SEQUENCE     w   CREATE SEQUENCE public.voucher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.voucher_id_seq;
       public          postgres    false    294    7            �           0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
          public          postgres    false    295            �           2604    18423 	   branch id    DEFAULT     f   ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);
 8   ALTER TABLE public.branch ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    207    206            �           2604    18424    branch_room id    DEFAULT     p   ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);
 =   ALTER TABLE public.branch_room ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    208            �           2604    18723    branch_shift id    DEFAULT     r   ALTER TABLE ONLY public.branch_shift ALTER COLUMN id SET DEFAULT nextval('public.branch_shift_id_seq'::regclass);
 >   ALTER TABLE public.branch_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    297    296    297            �           2604    26922    calendar id    DEFAULT     j   ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);
 :   ALTER TABLE public.calendar ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    309    308    309            �           2604    18425 
   company id    DEFAULT     h   ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);
 9   ALTER TABLE public.company ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    210            �           2604    18426    customers id    DEFAULT     l   ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);
 ;   ALTER TABLE public.customers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    212            �           2604    18777    customers_registration id    DEFAULT     �   ALTER TABLE ONLY public.customers_registration ALTER COLUMN id SET DEFAULT nextval('public.customers_registration_id_seq'::regclass);
 H   ALTER TABLE public.customers_registration ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    307    306    307            �           2604    28176    customers_segment id    DEFAULT     |   ALTER TABLE ONLY public.customers_segment ALTER COLUMN id SET DEFAULT nextval('public.customers_segment_id_seq'::regclass);
 C   ALTER TABLE public.customers_segment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    312    313    313            �           2604    18427    departments id    DEFAULT     o   ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);
 =   ALTER TABLE public.departments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    214            �           2604    18428    failed_jobs id    DEFAULT     p   ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);
 =   ALTER TABLE public.failed_jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    216            �           2604    18429    invoice_master id    DEFAULT     v   ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);
 @   ALTER TABLE public.invoice_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219            �           2604    18430    job_title id    DEFAULT     l   ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);
 ;   ALTER TABLE public.job_title ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221            �           2604    18730    login_session id    DEFAULT     w   ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);
 ?   ALTER TABLE public.login_session ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    299    298    299            �           2604    18431    migrations id    DEFAULT     n   ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);
 <   ALTER TABLE public.migrations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    223                       2604    18432    order_master id    DEFAULT     r   ALTER TABLE ONLY public.order_master ALTER COLUMN id SET DEFAULT nextval('public.order_master_id_seq'::regclass);
 >   ALTER TABLE public.order_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    228                       2604    18433    period_price_sell id    DEFAULT     |   ALTER TABLE ONLY public.period_price_sell ALTER COLUMN id SET DEFAULT nextval('public.period_price_sell_id_seq'::regclass);
 C   ALTER TABLE public.period_price_sell ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    232                       2604    18434    permissions id    DEFAULT     p   ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);
 =   ALTER TABLE public.permissions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    235                       2604    18435    personal_access_tokens id    DEFAULT     �   ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);
 H   ALTER TABLE public.personal_access_tokens ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    238    237            �           2604    30747    petty_cash id    DEFAULT     n   ALTER TABLE ONLY public.petty_cash ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_id_seq'::regclass);
 <   ALTER TABLE public.petty_cash ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    316    315    316            �           2604    30762    petty_cash_detail id    DEFAULT     |   ALTER TABLE ONLY public.petty_cash_detail ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_detail_id_seq'::regclass);
 C   ALTER TABLE public.petty_cash_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    317    318    318                       2604    18436    posts id    DEFAULT     d   ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);
 7   ALTER TABLE public.posts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    241    240                        2604    18437    price_adjustment id    DEFAULT     z   ALTER TABLE ONLY public.price_adjustment ALTER COLUMN id SET DEFAULT nextval('public.price_adjustment_id_seq'::regclass);
 B   ALTER TABLE public.price_adjustment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    243    242            #           2604    18438    product_brand id    DEFAULT     t   ALTER TABLE ONLY public.product_brand ALTER COLUMN id SET DEFAULT nextval('public.product_brand_id_seq'::regclass);
 ?   ALTER TABLE public.product_brand ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    245    244            &           2604    18439    product_category id    DEFAULT     z   ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);
 B   ALTER TABLE public.product_category ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    247    246            0           2604    18440    product_sku id    DEFAULT     p   ALTER TABLE ONLY public.product_sku ALTER COLUMN id SET DEFAULT nextval('public.product_sku_id_seq'::regclass);
 =   ALTER TABLE public.product_sku ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    255    254            6           2604    18441    product_stock_detail id    DEFAULT     �   ALTER TABLE ONLY public.product_stock_detail ALTER COLUMN id SET DEFAULT nextval('public.product_stock_detail_id_seq'::regclass);
 F   ALTER TABLE public.product_stock_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    258    257            :           2604    18442    product_type id    DEFAULT     r   ALTER TABLE ONLY public.product_type ALTER COLUMN id SET DEFAULT nextval('public.product_type_id_seq'::regclass);
 >   ALTER TABLE public.product_type ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    260    259            J           2604    18443    purchase_master id    DEFAULT     x   ALTER TABLE ONLY public.purchase_master ALTER COLUMN id SET DEFAULT nextval('public.purchase_master_id_seq'::regclass);
 A   ALTER TABLE public.purchase_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    266    265            ]           2604    18444    receive_master id    DEFAULT     v   ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);
 @   ALTER TABLE public.receive_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    269    268            n           2604    18445    return_sell_master id    DEFAULT     ~   ALTER TABLE ONLY public.return_sell_master ALTER COLUMN id SET DEFAULT nextval('public.return_sell_master_id_seq'::regclass);
 D   ALTER TABLE public.return_sell_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    272    271            z           2604    18446    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    275    274            �           2604    18739    sales id    DEFAULT     d   ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);
 7   ALTER TABLE public.sales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    300    301    301            �           2604    18753    sales_trip id    DEFAULT     n   ALTER TABLE ONLY public.sales_trip ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_id_seq'::regclass);
 <   ALTER TABLE public.sales_trip ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    302    303    303            �           2604    18765    sales_trip_detail id    DEFAULT     |   ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);
 C   ALTER TABLE public.sales_trip_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    304    305    305            �           2604    27183    sales_visit id    DEFAULT     p   ALTER TABLE ONLY public.sales_visit ALTER COLUMN id SET DEFAULT nextval('public.sales_visit_id_seq'::regclass);
 =   ALTER TABLE public.sales_visit ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    310    311    311            {           2604    18447    setting_document_counter id    DEFAULT     �   ALTER TABLE ONLY public.setting_document_counter ALTER COLUMN id SET DEFAULT nextval('public.setting_document_counter_id_seq'::regclass);
 J   ALTER TABLE public.setting_document_counter ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    277    276                       2604    18448    shift id    DEFAULT     d   ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);
 7   ALTER TABLE public.shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    281    279            �           2604    33396    stock_log id    DEFAULT     l   ALTER TABLE ONLY public.stock_log ALTER COLUMN id SET DEFAULT nextval('public.stock_log_id_seq'::regclass);
 ;   ALTER TABLE public.stock_log ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    321    320    321            �           2604    18449    suppliers id    DEFAULT     l   ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);
 ;   ALTER TABLE public.suppliers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    283    282            =           2604    18450    uom id    DEFAULT     h   ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);
 5   ALTER TABLE public.uom ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    263    262            �           2604    18451    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    288    284            �           2604    18452    users_experience id    DEFAULT     z   ALTER TABLE ONLY public.users_experience ALTER COLUMN id SET DEFAULT nextval('public.users_experience_id_seq'::regclass);
 B   ALTER TABLE public.users_experience ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    287    286            �           2604    18453    users_mutation id    DEFAULT     v   ALTER TABLE ONLY public.users_mutation ALTER COLUMN id SET DEFAULT nextval('public.users_mutation_id_seq'::regclass);
 @   ALTER TABLE public.users_mutation ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    290    289            �           2604    18454    users_shift id    DEFAULT     p   ALTER TABLE ONLY public.users_shift ALTER COLUMN id SET DEFAULT nextval('public.users_shift_id_seq'::regclass);
 =   ALTER TABLE public.users_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    292    291            �           2604    18455 
   voucher id    DEFAULT     h   ALTER TABLE ONLY public.voucher ALTER COLUMN id SET DEFAULT nextval('public.voucher_id_seq'::regclass);
 9   ALTER TABLE public.voucher ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    295    294            �          0    34378    pga_jobagent 
   TABLE DATA           I   COPY pgagent.pga_jobagent (jagpid, jaglogintime, jagstation) FROM stdin;
    pgagent          postgres    false    323   �k      �          0    34389    pga_jobclass 
   TABLE DATA           7   COPY pgagent.pga_jobclass (jclid, jclname) FROM stdin;
    pgagent          postgres    false    325   "l      �          0    34401    pga_job 
   TABLE DATA           �   COPY pgagent.pga_job (jobid, jobjclid, jobname, jobdesc, jobhostagent, jobenabled, jobcreated, jobchanged, jobagentid, jobnextrun, joblastrun) FROM stdin;
    pgagent          postgres    false    327   ?l      �          0    34453    pga_schedule 
   TABLE DATA           �   COPY pgagent.pga_schedule (jscid, jscjobid, jscname, jscdesc, jscenabled, jscstart, jscend, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths) FROM stdin;
    pgagent          postgres    false    331   �l      �          0    34483    pga_exception 
   TABLE DATA           J   COPY pgagent.pga_exception (jexid, jexscid, jexdate, jextime) FROM stdin;
    pgagent          postgres    false    333   (m      �          0    34498 
   pga_joblog 
   TABLE DATA           X   COPY pgagent.pga_joblog (jlgid, jlgjobid, jlgstatus, jlgstart, jlgduration) FROM stdin;
    pgagent          postgres    false    335   Em      �          0    34427    pga_jobstep 
   TABLE DATA           �   COPY pgagent.pga_jobstep (jstid, jstjobid, jstname, jstdesc, jstenabled, jstkind, jstcode, jstconnstr, jstdbname, jstonerror, jscnextrun) FROM stdin;
    pgagent          postgres    false    329   �m      �          0    34515    pga_jobsteplog 
   TABLE DATA           |   COPY pgagent.pga_jobsteplog (jslid, jsljlgid, jsljstid, jslstatus, jslresult, jslstart, jslduration, jsloutput) FROM stdin;
    pgagent          postgres    false    337   �n      5          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    206   �o      7          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    208   Up      �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    297   �q      �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    309   r      9          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    210   �      ;          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    212   ~�      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    307   ��      �          0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    313   ��      =          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    214   ��      ?          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    216   \�      A          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at) FROM stdin;
    public          postgres    false    218   y�      �          0    34018    invoice_detail_log 
   TABLE DATA             COPY public.invoice_detail_log (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, created_at_insert) FROM stdin;
    public          postgres    false    322   ��      �          0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    319   4      B          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    219   �l      D          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    221   �7      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    299   %8      F          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    223   B8      H          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    225   )=      I          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    226   F=      J          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    227   �=      K          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    228   >      M          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    230   .>      N          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    231   K>      O          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    232   �?      Q          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    234   �h      R          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    235   ��      T          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    237   `�      �          0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    316   }�      �          0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    318   ��      V          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    239   $�      W          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    240   w�      Y          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    242   ��      [          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    244   в      ]          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    246   ��      _          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   �      `          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    249   7�      a          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    250   	�      b          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    251   ��      c          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    252   ��      d          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    253   :�      �          0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    314   w�      e          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    254   ��      g          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    256   ��      h          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    257   ��      j          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    259   ��      l          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    261   ��      o          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    264   ��      p          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    265   ��      r          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    267   `�      s          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    268   ��      u          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    270   f�      v          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    271   ��      x          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    273   ��      y          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    274         �          0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    301   �      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    303   �      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   �      �          0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    311   	      {          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   &      }          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    278         ~          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    279   a                0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    280   �      �          0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    321   m      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   ��      m          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    262   �      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    284   ��      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    285   ��      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    286   �      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    289   3�      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    291   ��      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   ��      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    294   ��      �           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    207            �           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    209            �           0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    296            �           0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    308            �           0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    211            �           0    0    customers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.customers_id_seq', 1357, true);
          public          postgres    false    213            �           0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    306            �           0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    312            �           0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    215            �           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    217            �           0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 1821, true);
          public          postgres    false    220            �           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    222            �           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    224            �           0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    229            �           0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2209, true);
          public          postgres    false    233            �           0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 515, true);
          public          postgres    false    236            �           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    238            �           0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 380, true);
          public          postgres    false    317            �           0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 51, true);
          public          postgres    false    315            �           0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    241            �           0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    243            �           0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 22, true);
          public          postgres    false    245            �           0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 52, true);
          public          postgres    false    247            �           0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 329, true);
          public          postgres    false    255            �           0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 25, true);
          public          postgres    false    258            �           0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    260            �           0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 54, true);
          public          postgres    false    263            �           0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 21, true);
          public          postgres    false    266            �           0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 32, true);
          public          postgres    false    269            �           0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    272                        0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 13, true);
          public          postgres    false    275                       0    0    sales_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sales_id_seq', 1, true);
          public          postgres    false    300                       0    0    sales_trip_detail_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 21, true);
          public          postgres    false    304                       0    0    sales_trip_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sales_trip_id_seq', 4, true);
          public          postgres    false    302                       0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 1, false);
          public          postgres    false    310                       0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 52, true);
          public          postgres    false    277                       0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 12, true);
          public          postgres    false    281                       0    0    stock_log_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stock_log_id_seq', 4804, true);
          public          postgres    false    320                       0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 5, true);
          public          postgres    false    283            	           0    0    sv_login_session_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 71, true);
          public          postgres    false    298            
           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    287                       0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 88, true);
          public          postgres    false    288                       0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 71, true);
          public          postgres    false    290                       0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    292                       0    0    voucher_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.voucher_id_seq', 1226, true);
          public          postgres    false    295            �           2606    18459    branch branch_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_pk;
       public            postgres    false    206            �           2606    18461    branch_room branch_room_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_pk;
       public            postgres    false    208            �           2606    18463    branch branch_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_un;
       public            postgres    false    206            w           2606    26927    calendar calendar_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.calendar DROP CONSTRAINT calendar_pk;
       public            postgres    false    309            �           2606    18465    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    210            �           2606    18467    customers customers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pk;
       public            postgres    false    212            u           2606    18784 0   customers_registration customers_registration_pk 
   CONSTRAINT     n   ALTER TABLE ONLY public.customers_registration
    ADD CONSTRAINT customers_registration_pk PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.customers_registration DROP CONSTRAINT customers_registration_pk;
       public            postgres    false    307            {           2606    28182 &   customers_segment customers_segment_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.customers_segment
    ADD CONSTRAINT customers_segment_pk PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.customers_segment DROP CONSTRAINT customers_segment_pk;
       public            postgres    false    313            �           2606    18469    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    216            �           2606    18471 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    216            �           2606    18473     invoice_detail invoice_detail_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_pk;
       public            postgres    false    218    218            �           2606    18475     invoice_master invoice_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_pk;
       public            postgres    false    219            �           2606    18477     invoice_master invoice_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_un;
       public            postgres    false    219            �           2606    18479    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    223            �           2606    18481 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public            postgres    false    225    225    225                       2606    18483 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public            postgres    false    226    226    226                       2606    18485    order_detail order_detail_pk 
   CONSTRAINT     l   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_pk;
       public            postgres    false    227    227                       2606    18487    order_master order_master_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_pk;
       public            postgres    false    228                       2606    18489    order_master order_master_un 
   CONSTRAINT     [   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_un;
       public            postgres    false    228            
           2606    18491    period_stock period_stock_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);
 F   ALTER TABLE ONLY public.period_stock DROP CONSTRAINT period_stock_pk;
       public            postgres    false    234    234    234                       2606    18493    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    235                       2606    18495 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public            postgres    false    237                       2606    18497 :   personal_access_tokens personal_access_tokens_token_unique 
   CONSTRAINT     v   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);
 d   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_token_unique;
       public            postgres    false    237            �           2606    30771 &   petty_cash_detail petty_cash_detail_pk 
   CONSTRAINT     t   ALTER TABLE ONLY public.petty_cash_detail
    ADD CONSTRAINT petty_cash_detail_pk PRIMARY KEY (doc_no, product_id);
 P   ALTER TABLE ONLY public.petty_cash_detail DROP CONSTRAINT petty_cash_detail_pk;
       public            postgres    false    318    318                       2606    30754    petty_cash petty_cash_pk 
   CONSTRAINT     V   ALTER TABLE ONLY public.petty_cash
    ADD CONSTRAINT petty_cash_pk PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.petty_cash DROP CONSTRAINT petty_cash_pk;
       public            postgres    false    316            �           2606    30756    petty_cash petty_cash_un 
   CONSTRAINT     U   ALTER TABLE ONLY public.petty_cash
    ADD CONSTRAINT petty_cash_un UNIQUE (doc_no);
 B   ALTER TABLE ONLY public.petty_cash DROP CONSTRAINT petty_cash_un;
       public            postgres    false    316                       2606    18499 $   point_conversion point_conversion_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);
 N   ALTER TABLE ONLY public.point_conversion DROP CONSTRAINT point_conversion_pk;
       public            postgres    false    239                       2606    18501    posts posts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    240                       2606    18503 $   price_adjustment price_adjustment_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_pk;
       public            postgres    false    242    242    242                       2606    18505 $   price_adjustment price_adjustment_un 
   CONSTRAINT     ]   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_un;
       public            postgres    false    242                       2606    18507 6   product_commision_by_year product_commision_by_year_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_pk;
       public            postgres    false    248    248    248    248                       2606    18509 (   product_commisions product_commisions_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);
 R   ALTER TABLE ONLY public.product_commisions DROP CONSTRAINT product_commisions_pk;
       public            postgres    false    249    249                       2606    18511 ,   product_distribution product_distribution_pk 
   CONSTRAINT     }   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_pk;
       public            postgres    false    250    250            !           2606    18513 *   product_ingredients product_ingredients_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pk PRIMARY KEY (product_id, product_id_material);
 T   ALTER TABLE ONLY public.product_ingredients DROP CONSTRAINT product_ingredients_pk;
       public            postgres    false    251    251            #           2606    18515    product_point product_point_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_point DROP CONSTRAINT product_point_pk;
       public            postgres    false    252    252            }           2606    30130 *   product_price_level product_price_level_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_price_level
    ADD CONSTRAINT product_price_level_pk PRIMARY KEY (product_id, branch_id, qty_min);
 T   ALTER TABLE ONLY public.product_price_level DROP CONSTRAINT product_price_level_pk;
       public            postgres    false    314    314    314            %           2606    18517    product_price product_price_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_price DROP CONSTRAINT product_price_pk;
       public            postgres    false    253    253            '           2606    18519    product_sku product_sku_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_pk;
       public            postgres    false    254            )           2606    18521    product_sku product_sku_un 
   CONSTRAINT     U   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_un UNIQUE (abbr);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_un;
       public            postgres    false    254            -           2606    18523 ,   product_stock_detail product_stock_detail_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.product_stock_detail
    ADD CONSTRAINT product_stock_detail_pk PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.product_stock_detail DROP CONSTRAINT product_stock_detail_pk;
       public            postgres    false    257            +           2606    18525    product_stock product_stock_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_stock DROP CONSTRAINT product_stock_pk;
       public            postgres    false    256    256            /           2606    29118    product_type product_type_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.product_type DROP CONSTRAINT product_type_pk;
       public            postgres    false    259            1           2606    18527    product_uom product_uom_pk 
   CONSTRAINT     h   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_pk PRIMARY KEY (product_id, uom_id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_pk;
       public            postgres    false    261    261            7           2606    18529 "   purchase_detail purchase_detail_pk 
   CONSTRAINT     u   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_pk PRIMARY KEY (purchase_no, product_id);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_pk;
       public            postgres    false    264    264            9           2606    18531 "   purchase_master purchase_master_pk 
   CONSTRAINT     `   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_pk PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_pk;
       public            postgres    false    265            ;           2606    18533 "   purchase_master purchase_master_un 
   CONSTRAINT     d   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_un UNIQUE (purchase_no);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_un;
       public            postgres    false    265            =           2606    18535     receive_detail receive_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_pk PRIMARY KEY (receive_no, product_id, expired_at);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_pk;
       public            postgres    false    267    267    267            ?           2606    18537     receive_master receive_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_pk;
       public            postgres    false    268            A           2606    18539     receive_master receive_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_un UNIQUE (receive_no);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_un;
       public            postgres    false    268            C           2606    18541 (   return_sell_detail return_sell_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_pk PRIMARY KEY (return_sell_no, product_id);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_pk;
       public            postgres    false    270    270            E           2606    18543 (   return_sell_master return_sell_master_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_pk PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_pk;
       public            postgres    false    271            G           2606    18545 (   return_sell_master return_sell_master_un 
   CONSTRAINT     m   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_un UNIQUE (return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_un;
       public            postgres    false    271            I           2606    18547 .   role_has_permissions role_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);
 X   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_pkey;
       public            postgres    false    273    273            K           2606    18549 "   roles roles_name_guard_name_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);
 L   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_name_guard_name_unique;
       public            postgres    false    274    274            M           2606    18551    roles roles_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_pkey;
       public            postgres    false    274            m           2606    18745    sales sales_pk 
   CONSTRAINT     L   ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pk PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.sales DROP CONSTRAINT sales_pk;
       public            postgres    false    301            s           2606    18771 &   sales_trip_detail sales_trip_detail_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.sales_trip_detail
    ADD CONSTRAINT sales_trip_detail_pk PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.sales_trip_detail DROP CONSTRAINT sales_trip_detail_pk;
       public            postgres    false    305            q           2606    18759    sales_trip sales_trip_pk 
   CONSTRAINT     V   ALTER TABLE ONLY public.sales_trip
    ADD CONSTRAINT sales_trip_pk PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.sales_trip DROP CONSTRAINT sales_trip_pk;
       public            postgres    false    303            o           2606    18747    sales sales_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_un UNIQUE (username);
 8   ALTER TABLE ONLY public.sales DROP CONSTRAINT sales_un;
       public            postgres    false    301            y           2606    27189    sales_visit sales_visit_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.sales_visit
    ADD CONSTRAINT sales_visit_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.sales_visit DROP CONSTRAINT sales_visit_pk;
       public            postgres    false    311            O           2606    18553 4   setting_document_counter setting_document_counter_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_pk PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_pk;
       public            postgres    false    276            Q           2606    18555 4   setting_document_counter setting_document_counter_un 
   CONSTRAINT     ~   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_un UNIQUE (doc_type, branch_id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_un;
       public            postgres    false    276    276            S           2606    18557    settings settings_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (company_name, app_name);
 >   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pk;
       public            postgres    false    278    278            U           2606    18559    shift shift_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pk PRIMARY KEY (time_start, time_end);
 8   ALTER TABLE ONLY public.shift DROP CONSTRAINT shift_pk;
       public            postgres    false    279    279            �           2606    33402    stock_log stock_log_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.stock_log
    ADD CONSTRAINT stock_log_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.stock_log DROP CONSTRAINT stock_log_pk;
       public            postgres    false    321            W           2606    18561    suppliers suppliers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.suppliers DROP CONSTRAINT suppliers_pk;
       public            postgres    false    282            k           2606    18733 #   login_session sv_login_session_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.login_session
    ADD CONSTRAINT sv_login_session_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY public.login_session DROP CONSTRAINT sv_login_session_pkey;
       public            postgres    false    299            3           2606    18563 
   uom uom_pk 
   CONSTRAINT     H   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_pk;
       public            postgres    false    262            5           2606    18565 
   uom uom_un 
   CONSTRAINT     G   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_un UNIQUE (remark);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_un;
       public            postgres    false    262            _           2606    18567    users_branch users_branch_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.users_branch
    ADD CONSTRAINT users_branch_pk PRIMARY KEY (user_id, branch_id);
 F   ALTER TABLE ONLY public.users_branch DROP CONSTRAINT users_branch_pk;
       public            postgres    false    285    285            Y           2606    18569    users users_email_unique 
   CONSTRAINT     T   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_unique;
       public            postgres    false    284            a           2606    18571 $   users_experience users_experience_pk 
   CONSTRAINT     b   ALTER TABLE ONLY public.users_experience
    ADD CONSTRAINT users_experience_pk PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.users_experience DROP CONSTRAINT users_experience_pk;
       public            postgres    false    286            c           2606    18573     users_mutation users_mutation_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.users_mutation
    ADD CONSTRAINT users_mutation_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.users_mutation DROP CONSTRAINT users_mutation_pk;
       public            postgres    false    289            [           2606    18575    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    284            e           2606    18577    users_shift users_shift_pk 
   CONSTRAINT     z   ALTER TABLE ONLY public.users_shift
    ADD CONSTRAINT users_shift_pk PRIMARY KEY (branch_id, users_id, dated, shift_id);
 D   ALTER TABLE ONLY public.users_shift DROP CONSTRAINT users_shift_pk;
       public            postgres    false    291    291    291    291            g           2606    18579    users_skills users_skills_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_pk PRIMARY KEY (users_id, modul, dated, status);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_pk;
       public            postgres    false    293    293    293    293            ]           2606    18581    users users_username_unique 
   CONSTRAINT     Z   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);
 E   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_unique;
       public            postgres    false    284            i           2606    18583    voucher voucher_pk 
   CONSTRAINT     e   ALTER TABLE ONLY public.voucher
    ADD CONSTRAINT voucher_pk PRIMARY KEY (voucher_code, branch_id);
 <   ALTER TABLE ONLY public.voucher DROP CONSTRAINT voucher_pk;
       public            postgres    false    294    294            �           1259    18584 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public            postgres    false    225    225            �           1259    18585 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public            postgres    false    226    226                       1259    18586    password_resets_email_index    INDEX     X   CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);
 /   DROP INDEX public.password_resets_email_index;
       public            postgres    false    230                       1259    18587 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    237    237            �           2606    18588    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    3559    206    208            �           2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    3577    218    219            �           2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    219    3675    284            �           2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    3567    219    212            �           2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    3596    225    235            �           2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    274    3661    226            �           2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    3591    227    228            �           2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    284    228    3675            �           2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    212    228    3567            �           2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    284    3675    240            �           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    254    3623    248            �           2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    248    3559    206            �           2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    284    248    3675            �           2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    250    206    3559            �           2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    3623    250    254            �           2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    254    261    3623            �           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    3643    265    264            �           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    265    284    3675            �           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    3649    267    268            �           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    284    3675    268            �           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    270    271    3655            �           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    284    271    3675            �           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    212    271    3567            �           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    3596    273    235            �           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    274    273    3661            �           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    284    3675    293            �   :   x�3�0767��4202�50�5�P02�2"S=3#3ccms�0_�����R�=... �
�      �      x������ � �      �   l   x�3�4�tJL�.-PpI�̩Tp��I�-�I,IU00�20���,�4202�50�5�T00�24�26�342327�60' ㇢ d&a�36�26�35�����r��qqq �,!�      �   ]   x�3�4�t-K-�TpI�T00�20��,�4202�50�5�T00�#ms������!A�B��Kt��rV��dw-ȭHl�n�.����� � `&      �      x������ � �      �   p   x�m�1
�0D��:E�!�d��YR�{X��&���mڮ��j���+�`T�m��x8�+�� ��x����(�A���irJ�G!�?ѣb���i���?��Ҥ�����'b      �   �   x�����0���)\:������MHj�)TZx{��]cn�sߟ�}	p����&϶ J0�P�6�ko]ʓu�����NjJ�oꁬg�|��_.-��gմ�F�^S4�u#U�f�U��r�;�_�YIG�%;!���=�Y~���
�C�?�ܫ���U��#m���ߕi�θ� x ��ld      �   �   x�u�Ok�0������Y��Ƿ����(^�t�����3�)�C��I?=�d��T�����:@�����$�e��+ҭE�h�b}�ҼdxM)&}XΧq�.�]b~�s�#�.�o�z���)��rq�W0���Goǯ���>���y܍���lkYWK\�9���C81z����Rb�����q�TAV��Xc�FwJ�gL�d�L?���u[���F!��qS@�l�<`Űe���?e�c�      5   �   x�m��
�0D�7_q?@%�jv�(>�Q���d�b���i�v���p�#����ő�j���{�ϗ��)|�� ��1/b.P�*+ϓ,���a7 ��@���]����\ݰ�Aj�i�LI�#�NO�b�-�8�v��d*�8�8
��?�A$�yp�Pp��T^������6      7   _  x�m�Qj�0����"�$�I����Z:];���1�-C�y��gɖ�;��t>���8���C�(ZJH%���TB�(+Ml��7�k{;l�S's���@ˣiJ�L��@�iΗ"�c�p3_��-UJr��f�%,��L��s4��(-ڐh��>.��d�1�'��w�P�Xxg�>.<��.�����Xeg�Y{N�8{�hϩ)���x����Bv�:��91�2iϼA������p�q:�����654�wo�lN��؛�j��g�W��x�A��L�����z�����A��Rǚ��r��AV�����C��x��P7�HJs�%������Z�#�      �   9   x�3�44�44���4202�50�54U04�24�2��!�e�e�U���0W� ���      �      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      9   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      ;      x����vɑ�{�~
��f����� �� TYp�M��^�t�4���Y=O���<摖H���E�ׅ}���p7�C߽�^�o���w_Ǘ��~���]�~�i߹�o|��Є?������C���v?���[HĲ�ލﮮ�'�ڸ��K����ѫb�w�������P=��&���%��!,=����O��g���-f`�1�o�_���֪� 8Bx��K�C�|^�OA������3\��i�M���! 1��g�pi�g������~�&�j�����L �0� ]xy���R^�ɩ@�q���:��kUAލ��s�,�'w��Y����f?~�>���1-����ϛ��K���nh�O��p}qvB��[UC �>�=R���B����~{���O~�YC��nv���Ç�ܓ�!��ǋKq���dO� ������h��~8�!���w�G0=�V���~��xyk6Y�v�'?i A˻C#B���!������Wy ߳| �!�ygx�y2�i?ިB�}>�.Y�͇���n�!�i[x5��.��ClT!HV?0YK�N4�BЖ����6b�� �+��ޏ��nڌ�B@�������w�z_l�B����a��D��k_{�t���!�!n�CX�R�B@�����2@�~�^����as?>_\����|g��������1��ż�'����� �G|���7\�ln�K��jB�������tf���Ǉ/��M���A��N��/bC���jP����~��ݟ��E�t�����4k���]~��w�ͮ��pR5�����}�
r$�k����Q�׽z�(}S"�+Y��ɠj��o7�by��J���R<����!��˸{�EMu��!�/�gK.|p��!��;�-��������y@�5�<_.�L���`:�^��.~�~�G�9���!��܅�S.\x������~���t�����jW�)���ؤ�ot�XY>� ��)a���v\}�6�S�Ev�Smp�������x�8l{�O�%�̃	���_k|��L;�4�B�a����[��kL����ø�9�w�0h0!�ǋ�i��w���PS��Ӈ7%�՞���y�!0��v����b��ɖOg`��xP5���_o����ٞ;�	��З��}Z�E�Z�C���&�-��Q5�f(������Gs��re@pMá�:�09�nZ$�;�Z�I� �y��fx��C'���[���|f�T"t�X���߾KC:�֦�CjT��|j{y�S��5�!�� a:�.�kD�F���M�6ʹE9�H�E��>u�T/|�nH�+���f�u�5��ܒ��;�Z��C���t��� �3�o�a�����A�u�~��&i8}MX��E���RP5!����N�j'��/�#%���1��4C�y$�A��|~+�j���K� �N#�V�{�QF��$U�X�yY�Fz�A�5���䧷ӫ��r��!����`A>�������7o\�Ͷ�䑗�5�~�bZ������A�����-��A ������N�#k���n�6>l�}���l�����Ǘ1��ø��r��tô�^b�.�MO ��a����X����~�7U��_mw���~�{N�����=v7��/�.�`�´m�O����r%IB�����@���-tCb�ON*��0T���UkIن���dk)�銃�� �|�����ZC����C�yw!ġN�t�� �R�����G��+�DbB����3��� �������9�6�����N�'H�AH�s}�L�w�	�]�� ��{]�Q�bI�H괅�VV��V�����}�f�>��Hr)5$�R��l��LN�]:[� ���g�K;�����^�$5��kmj�n�m��0��9�tB�|�F���9���שd�����ǝ�)�-�W5�#��������}��D��D����A$)��㿿�����0R�@�� ӟƩ�e�?���ÿf���ѿ���y��_~�������^� �!����?����2m7W���^��A .�����~�ϡCq�+5���闌` q�}�(#���B�}�	,V�VAia�|��>_�X1��Z�j�S�ƽm?DVS�Z�PkI���1�|��:U�0h��@5�F�Pd�q��qo�H�� �	�,8+F�`t(FK������d�qN�jmS?�\3H��"B�@ȩ~6�'孀� ��1��e��F;��(5�o��?�,�5����7�s�l��� �_�{��4M�A �Q)��������sh����ߝ9ֱ��Z\k�y:�ߎ�s6�le��������a#GRi�iGq�U�����G?�7�&$]��wZ�3F�W�R�0ȋ�����8Z��!5��v��8��pP5��"�O������>,� �9�����6���A�B��:^Bx#h!N޽J!�"%+AZ��DP��z���X�O�k9����4�l��OE�U"t~�,OhG"���f�%���uAjT" ���0.x����QY���������ʑ^We�A�!Wq��'�Z�8����˘mRE��Atv�̎6��	��.���x���hS����A~��{��I�ӕ����s������� ��k!7�4�Ľ&@��~���xzMu� �z���a6�\ �T"i˅�R�s��5�VkGw,�1r$Ϩ5��/�Ik8�ע�q�{{�G7�4��U��\ ��ޙ9\�|qg�p�9�r}�đ��?�G�i��<`���������J�� ����g�'&�d����B.��z��}tm�8hDuN}�AD�Z?n.߭�6���b6kG�Ib�8R�j�W��Xu%�5�������Nx�cX�gf�p�1�c$�/��A(%��A� ڳ�L�\�V1RӶ�g��<�k��{=���A�ү����7��ސ7�qP5�!�'޷jf{��v�jC[6�ou�;ڛ�	iC�)_߈��֢{�ɩ5��|�� ~8�A�=s"g��e�H���5���X^���X��A �G�_����{ͩ�5����Ԭ� �ў_�dgb��۴�00�Z�Z���GA�)����^�A��4!�׼�Z��5O!��v��@���ᢇ��ג�Z��?ru�O��U���nE�ᣆ p}�޶��� ��A��\�!�rB�8<5/�A�6s�ˤjG�'5��}i�O8<XY��_�-��G����B!ǹ��I��k�{�AtXϽZ��M�ڏ�� �o�,Ċ2TB�Pș�G9]&h%��2�+�3]����6]CPh����>��I�n[.Y� ǹ�k0BP5���Ǉ˹��(�Dj�����җ�:��.4�����������-� �_m�Ld5��� ��?�Wjqs;4M�OT���GJh~���E�۽�n�S���MҬA$�e7�[�0G1^�}j�8�ȺY��L�ZC8R�77k@����2P���r�:k�^�FSߗ	��D�E�G�mu��A�����>Y��d7zU�Xx��Ɣ�BF�&�U5�-��*T!�:^]_.����˥%kHi$��r5�ѨM2�5�w���%3�l���򁰆p�|��O������oa�-=	kI�o�~l����/SʛU�l3����ȬA�YWqt�=��A�v�V������,Zk���Ob�d-��P��A\���V���ZJ�h�ؿ��h�[~MfB �y���}�A܄o{��'2W"��� p�x�g���"t� ���<����A |�d��U� �q~� ��/�5� � X��G"���� �p^�C� �\��}k���Z�"�t\�{kBHU�� ���bv��{��PkA�&�A!P���j�"AjO	X�^/�.���5�����% �6�U���O�K�2�b���˽Y�Z��@��A�8ӭ��!�������M�5���b��#�=hT ���	9�    ��yb�g`�ki�A0<ED��0�h�� �����	&o����:Lh�ݔ���)#M�$�й�a9��hݟ�F�AD�؎�~��a�.�aIU�� �knv�Nhw�vK��E�`�a��M���mdo:o�,� �2�魪��Z���������Gs�ʱ���?2���� �SEa�\���^�� ��� ��H.4�c��Y�b��hlT 	\���W�t�����o�%�=]|�f����L���%B��]���r�A���gK�~�=��pF�8���rI�FCU+4�'�LWCl�����qP`s%�oT�(7C77��.22p��Kg���t`�I�.G����5 ��N[�V���6O+k��ɸ��"~�A�87��@b�D�6z%IX���A$��q6����G�B�use�9c�q��?jG��n����g��� �����Ѕ�h1V��B�(ȯ�wW���P2�+u�.TZ���5���`�(p�R?h$q�o��߆˖V��yDB�H8�ZG��K�r��d6�!�F� �(��[�]��S�� �4w6��w�;Ss�q�:$4e��|cF��ZWd��D<�lZ-�vZm�FCB�jM?ǃ��R��8��U�4�AH%��}ت�_���|�ݞ��0�!T\���?u�bh�弭�xn�?�D~�i���QC��E��t)U�h�AH~�重U�QhGZ/]g��ɽ%]���>a�N��݀t��:�
�I�7�GWG�� ��!ǹ�0T�5B�8}���8��!t]8���t��-�AH})r�����Xm'��P��J���B��6�U��a�>j�+�j�ߴm��	ʮ�UgB�AD�^�7gk9��ո�E5������ܜ�!�����N� �+0t�?�l_ǟ����oa�諃�� �[�d3�\\�*�A�[��b�X"��A �Ju?��;�s��{
"�H�^�N_�.�>���#QM[�
!JM��T<ڴ1�#�s��h��|"�=���p�R%jnѫD�-�Ϝ>B
)����Sɹ����!��G���b�T�3�W��aHn�I9���FB��8yko�)L%�E/�8�h�N�2,�T����fo�R����/k֑�ս�� .�����(4 �	���p��x�P�h�M�j�pҫ��h�J�����]��ս�����	}m��!�9_� � <>�n��fz�0_k�t?�ਛq	�h�&�����R�BQB.��E�#( �hqF�@z�Ug{������#M6�'�mաThGǃMVp�f��>j������1�2Q$:U�Ph'����#,>�G��i�G�qq�8jG�%b�EN���*Wh�T[g��f�ލű�A�=��&cU�,4�lRmBd�ڦ����p�J��o]wz�jir�t�1���w8m�|��0���R-�!D4A���A���m�j�+��&_�F�*z 4�H��l�2l��pF�H�o��{ؖ9�2�^h�����d�{U�0����h�Y �)��.	޷�튮�-%����_h%�^��4Em۲'�K� ���(�g� K0�윶�S�j�mGP����L�A\����BjK��4��с5 ���iB�@�w����9�j�&4���dǃ�����U�HǌS���ձKhJ��ˣ�[����At�������h�N�B�@(6�4��#�q�f��x��Wӕ5�%�˕� ��V����aB�8ȧ^ۊ�f<}]X�8<�vS4�m�sфqp��ǫ���L2TYRB�Hx��
:��^� ���iCd	��z��� ���W����>MhH�-RցD;�G��2'��վ��
"V���V�W5�đo���s�pX�������0U�0h��q�?Z*f�htU��� �2�ɺ	�f�i��"�":�Їz�71��=͞�h�e=�WhR��b�֕�r�(4�<���~��S�u��]�� �I�)�$�#l����}�>�v�l��B�@��jW����>B⹻����:�Q�nW�q�A�)�B�@8����a�]u R�TM��-2��L�A(�{|�]��<Y%_%鵣��W{5�A 튂o���� v�����Vy -�@J�-=���U��A C);�f��!���b�BCHB��ި+�H�r���c8^`Y擲�X%�	aߺ������n�A	B�HJ�-�����G2kH\�V�Q�R���B�uk�-�6}u��іZ*K��m�UX@hGw�*Sǈ���;kG[�׷�2��QEB�@د�<���hݿJhWqݏ7����/
a�����.���p��6�+��d��}_b,m� ]$�F� ��i?W���m�� ��混����j{��/�i]i:���A %!K��q8jh�k��~��Z�Q5�"��0���/<�ʼS����1������r��qx�~�6�0>-�1G���O�L�n��T� �z�ُ��f�Pe�"!��8!,����W�W5�r�ց�@�Q�@�\@�y7'x�S����s�՝i@/�6au��A �T���j6�-6�G�h�X�e��U5�q�2��A�n��1k�^}��v�I^]Ix�3G	�kuH}�<jH\�|M�A �j�����֢B�0x���(�a̕�F?�	�joYÑ�kg�A\'`Qq��_:���r�f~���r��q�wOc���F� �zoˎ���j�בt�a[hI��$uC(�A$in�i�9&���%�o�ȐќQ�U�J������/�$�H`�A(�O��5����P�����5 � �|oXC@x@֙�eg@���/4���_�_��4I6�UiEB�@��j�P��Dʷ׾H��y���7�l���-4�#�oS�Mu�C�A R}�l��N� ��4��.���뽪A �VG�"��_hmWo����h\������	 Ư/��lZU�H�����綘�U�D⹷���I��^� ��V���$�)4��t��<�"4l5V��B�HR�f
%�Ѵܑ��r���4��vU`Dh{�U$�Y)f"���k^��ZV�A$�_�_���n9�Ah Hj�5��}�I]�7���{_f�TEX�q�S�*���� ��z��M��d5�H����s5�;*Z	�q���6�o�՜�4�D�!�����Δ��v��+�5��"������nC��f�Ah]�,0�x��x�0Z�X�F{UC@�c��Ɣ�ߗ.N���Ax����=��sw� �2z`�$$��>�� G���8���@;%ǹU�@@�rUJ�� 꺲��/�uG�hWs�s!�qp�@s��o!ܠjyӵ �)�A C��Y�UC8x���vܙ҉�V[U�H�MԚ���V� �u��R��xU�Hª��C�ɐIVB�H⚎ʳQy/4�7������l.6DB�8ڷz��!����p��v�b����!4d����D~~��sr�~d�{UW��Rʬ֒ȬQ�A$��uܿ����S��A,
��5$e���	)qV[��lTF����wݘ�C�iNK�6qL\g�|�}�]����������Z�⓪A,�{�<l-=�r�U�8ʘm��u�)Ӝ�q�{���e~��X����V�O�/_Z������3V��f��3��N[�뭮m�	��ꮒB�8�O/�{���.�� ��I5֭+���^B;��2=���������������ʹ�+4���Ls�2��U�H�r��{U�Pȿ~|��6f��<ڪB³��ǟL�F�Ѵ\'�A �N�$a���5���\-ђ٤K�a�c�"+HR@�NNf�X���Qf`�z���wq��5��+uB3e��^�����������"4����+�l3.�G{L&��u��xg��߬!\�h���}f�T� �z�xeň�����꫇qo\���W�p�A eӺ�&4$���^��^G���W�}�t^� ���r0U��6����Z���m�ɸ    <�f�jw��/Li�B�f�%��2u��/�tG��1X+9��a⠂V빊K����H��+������3$y���A$�n��$U�HJ�t�G6S�8T5�����ڝt��/����E�@Q69,ǬA���z��NuƦ� ���p�9��5�h�ha�A�|�kA�m����Uv��	Z���D0�R-9+�h�dMj�/'��i��/�� >�_oL��qhG�ԗ.���Yl���_j���IRR5�-7�n6J`]�@(l�7]�6E�� ���qg��>^� ���'� �d�74�Q5��X��pA� �����Z�Ge�.�@������<Y��Ū��TR�H�d�ow�cu1�d]�� v�K3�b�]���q��՟-���hje5�� ��L��$�DB��n�}�d�d�>�5��A$}��X����A(|῱Tw��|K�T�h���u=�.Q�fc�j��3�ֲ����ak������Oo:U�@���7�GKSѣY��`�CmC���0<���A����n,�l6����(�A(m��b+�>�u^� ��L?{���� W���DЗ�ǋ�;7'u� ����	\}�B�ȣ~��^�K"p�����o�X�x��{�ɰ|�JR���oZ���T� �2�*g_D��HB�+���/W�N�,F� ��,���]>%�j_�o�.��.w�W:R��7��Tm�K��g�f�7�v���J�����p�T>4Z��d44r(�� �c��"e��3�e�XhII���T��ʍ�� �o^�z,��L�����s%�S@���G==~2�2�k�Df����N�@Hi��5u&)VcuvDB��+��b��pF�@8T���ބ5�$4g�Sh��M�4'@�}3�e[R5�.�7O
��Єa�|�J�gb.�X��<@�d�.�AD ��� ���ۅ��R��k���"5*qڃ��t��kBs�1Ū_jQ{v���4���)@.�.X�u�4��FyFô�bh|��j��P����T*�~��n��!q-��i��z�0tɥ��2Ŷ�H�)��^��8�M�[*O.�iT��4��hh�m:j��U�8n����Թ��6jD�dc��D��W��������u����f�?߳����ig�z�7�cL:P�ǭk��l��5伟����*Q�vqI� "r�w��V�{���.��1��-���ZF)\�}�e���@_��b���X�������6��mU������� �AJ�	Hh��?�j�����U����I�R���e?�h����NmӺ�<�BD��cP5��\������~�hy>4]Hmש|z�u"⺄��W�����>�x�)��nTbjyy߫9����Ʃ�H]�;U�����Lw9k�}�a6��؜3�A^{�wy�G�a��k���
�� ��\��#���w^���<t�!�7j�R����#7�V�h�j��mn,!=_Z'�jG��ח��M��a�����s:�TB�%i�G�B�jSLb�v�&��c� ��|�ݼ/jZ�yu�T`ةD�1��"
���� "��V�&MHqڧ�NuCC�ox�jR����D��!D]3�P����3����DԆAD�{���s�obս#�P����6y-��������ԫ�؁����AD<aQ��ʱ���z���O�Q��Q\1���3@��$��ګC������t�ז�ϕƋo�Q��ڒ�;��\������;je��8RTBzcl��]���K�A�j�1�7g"Fݐ�S@s�)��BC��Ib?��|L�AH�������>C�.��>�tUE�� ��{���u��6���讣��
""w����X�w]3�l�#�VhU�2-$��O�O֧ޛ��Oؒ�5�(���C�6M��[�DD�3��r��O�{�B��K�Q0d�}h/��M�� �~�yfW�_.��F���j�,3�AH�z�=(-���i�؜^����ߤ�&�U��^va��Ӻ���>2��t]�A@��?ՐZ��|��N#d=O�QH�Y��䚜J�Ej��T"�=�]i]�rh/�D�%ƍv7�'�b~�:Q5.Rj爨݇DA� ���X�۱��W�5�A䨟n7�{K�f(��OVM�c��3��i%k.�L���B�`
|���M���M;!���i�N� ��Ɯ���4'?���%��a��5��sA�T��֧3�hڇ���  N
��uu9�\J*D4�n�g"
<.�V�ɴ]lb�h��b_e�	"�j��gm �˗T�A}׆E�~�AH������D�ZhQ�W��rS�����A\�7����K���)���7��'�DTO�Hg@buw/4d(���مnڨ�9�Fq��YC�9�k=�=g6m۩1��E�j�{kZhjS��z����*�Sh�/C!�Z㻤������W5�'p;;K7�b�?}.	�عy쏾�N�!��T��y���h5��G���5��]Ӥ;[��ɪR�H�V��-O�Ӂ�t��R3u"�����\s��鮐���Q�AD�Ȋ���Ku	�&盾�O] ���J�k�'��QM^�m�4}�/�w���Bh�;5��jy���F������ ��A�'˙4Rw��ڄq�R��
�{U�@RY�Ѫ�A��qgj�CF����A 7T�6�-"���j#*4���÷�V.�i����'��(ר�T6Ǧ*�H�P���pp����Ԣ-��G1mKjw�0������+v�A:��.��PMD��A���4��m��ޠjG�(��{� �b6�>� �9#�t�'�)��R5�6���7�J�����5U�l4We�	�����%�*u�a�k1�*l/4cX�1�`��YC0�,pkiI_L��<k�eǗ�#.?��ape��e(:��u^� .(Y�n�B�@�1EA���Ai��� �ē������%%P)=���D��ݎ)��6��$x� �ʾ�"�>'�Ǿ�I�#�yR��ٰ1��~qZs����O#�1Gz�jZ�� ��l{Aj���;�e"�nS$4����w�O 7��O�G��=���2� ��b���5��d����^� ���pn��Kl�U���p��hj�6S��$4�#q��c�v-4�������{� R�!4�����+�'������RB���ր����.�N2�l��a����.�{:�_l7��Z��k#4���QzU�Pȵ�l�{%ȕ_|t�R7I�S��.4)p����Ҋ��Uր� �kA�hHI_��|��i��+4kokwۏV�ɧ�F� �AZU�@��:GpUf�A׌<\Y��d4�K?k�n["O�B�@J+b��qPo��/3k��hۍiB*)�.��3l�ds��jW[<Z�|)��s��A\cqs8S���,
+����ZO�S���W5��=븛v'V�X����|i��Ie�o�U��be�٢ϻ���w�.y����.��f
���[sm}mz�T"!ߺ�j�Hu��A�Z7���u�oG
�a�~��W��$i��B�H(���@rҟ[`5��l?>ji':H��0���5���}6�Vω7N� r��a�b�5f���iIW�	!�´���bs��N�q�34N1���o�*��d�$���1���$2Mg�y<c�jH(�^n�$�?@U�$4��[�|�7���V�;TdB�Xh#{�S������n�#4��+�������kRsK"��Q�DD�wcʼ&��Q\�
� ��CF��aP��t����4�]��� =�~STu��H�T 8�
�P�Մapr��>�l����qpn����gIhe�d�[��B7j2FhgĮ��q�6����bo�=f�(�r�J$��|B�@�ұ|H���
���颞mօ=BC8�.l��mE��H�w����u���X�0!M|�j�?^UIXnZ��p���-�-=$�A� �X"��PVK��}u�(4��Z�ЪBZ��n�G��u�T����W�{�NBU�,4���v��Dv    ��61B�8�Ըo��GFS�
���pu�:���jB��\�`�ޖ٪�W5��|���n����/C.dT��/��AH������eI�jI\���j�j	�>�>V�z��3�fJ��܋��A(\��h���A�U��� ʇ��f��;�z
���nk
d��PW�
"��c*�iKNlT��vK�S�낏NҖl���`� $��oM�dt��4I� ��������|���~7�����A,!�����l�p�H�A�π��S�Y�
�H�����6�0��S9ZU�@������c:ڸA� ���KFW�	��Ks� �����:���v5������IHU��.�Z�U��B�@J���
�ie��#a"�����6�����A$Xñ���K�A�����A��M#�\�UE
�IS�AH�ϰs]��(��]��*o��������럕�q������s��EN3-��jUǳ]n�O�"����V� ��o��6����;�/�:U��8P;�,�����! ��L|��)������ ���)g��IR����x��f�v��ʭ>/)�צ3YW�F�Ӳ� ��@qG�j���[K�M�j�%4�4K\ű�k�q����']�}T��v�Ϸ޿"���I�nq!�&ϵ�y|N�S¶�16Y����Z��v/�{�v}�ä��������A��40->��1��wg�t������i@)U��o�k��@���:�JhQ,DO/����m������F� �t>�J��	罪A<�gg*�m&�j]��<���<���S]_���2� 4�/��tn��܌Y'J��%�ADOö]�v�}�K���t��&�:�b��� �B[�ႪAt��hz�F뾧B�@ª�5&s�aP0ך�ەHvT���㵺���ݓW���u�WU5�����?O�9��.�TG�F�ۏ��ZY.޷Cܠ4�'�i��F� ����wƈG6�-N(G�i/��s}Oq��z"BC@z0ܪ-��ؿ.�^��Sbo�ZV	Br���M�j��r��#� �D�K#l��h@r
�I����G}?s�H�		"����i�4��^i�L֧�T\>#� "���k�����v�2b���C��v�Ɩ���(Ģ��� ��T��.D���+���������Jo@��|y��iȾ��O���f�b��'�\D��fTh�PF?�5��A� &S<��g:Hh�QDB�@�k��I@��!M���5��c�j�N�2���(�x�<�jP5����+KSj�9m��j7]<���kaY|���SR��=*ןm��g��tB�~hԽO>ZV�2B��8Nq{�+�R�5�Ϸ�����;����liY�$4�h(�}��/ٴa�c�p{��VF�S$�n�%4�ݰ-�7�\l�f���0�L^� ����'3�t�uK� .��_��<�Q��W5����rc=m���:1]hJ{���q��w�W5�� �m�Zz�l����A=wo�u4���㭪A �]���! \��M�zd3�ŧ�Ae0�)#�hsP5����O��J�W�S5����Vr�ߙ�qО��Q�:q�лx�5`�aR��X	�I\��c<��A<T>��ǽm�YM݇�U5��(��'S��l���P�ڸ�~#��S�dv�� Ff��%��/9�p������3���ɓ�jd�A$n��j�pˌx�A|�voڪ�͘o�Q�8J�m��lT�*�����@�|��đ8SuG[5��A��������]xU�8���J:F�%U�0J�;F�RȄa�C�����a�Pg�w6� �����^� ��N���w�A�����@��%kH����ˣ��-�Mu�A�A(q��ځBҡ:�� �����+�m�|rg����u�P,�N� ���P?�bl4}8�A =GЬ/o\���qP(`%��c�����ʑ�K� �2���$�!M��iT~(��ǈY��xB��|�o��*�,4�g/�jb��]�F����\�t)�AD<��G��W5�(����$�����^� �G�I�kF��_�f��W�,�иQ5dy�g7(4`�Y.��Ԭ�ӧ|G�	���x_`�'��nU�({X��$��U	�B�8��_��@�� ��ms���q��=�q����_n�f��d���|��C�1�y���A(�\|'Yt*�Q5��j|1 t�xլA �E=<]&�η��!\G�$�כ�r�s,~�sx4�y(%d������諎�B��J�p�z4K���ns!�I�B��m�=���K��C���T����!�Z�\��Ԃ���K��W��ѻ.�>��t����ALO/�a�N� $N�}9hM�=�w���T��Zx�AH�/{�&6_DZ�⣆ usv�6�+e����4]���|������$���=ߗ���Oh���E��+GB	s����b�G���єn�jA���Ap��u�M��ΙkI� �Tޭ!�JW��e�}�tuz��i��d=ߠ{y��D�q���{������"5�G�:Y�.5���3�#��&Sv�����m�51���|�_�\L�AH���+L�7�gwM!�\O����;m;}R����?T��ʴE�AD쵿��qj�jn�/7R�H"w�Z�/��Q�@������j��� �H?�J���x�H"ڋt��N�@��Kjo��7��MU�� ��-��b�:�H�(�dkk��H)��l�����d�D�u�v��id�YjH�57?�����ʑ'���3���������A� j���������V�S5���9������rٰ�qt��������	��jHO ��7#H����S5dX�e{� �i"�Ͽ|��_�˕�i��Y�X���/���?��e��w����֍t��PὪa,�q�������F�0r�����~�Ն�rC��W5����?�6y��YYr@3��������<��C����t�R���Ͽh�{ϰ2h'5�eaȕ�F[�ЫM��l4�
8U�@\�c�Y}.Pkt#�������JgI~y"�5�ŗ�L�X��?R�X(G��ԛ�m�/�a �$k�$Ǿ|r���4��VvE��ĵ?�ԩ���UKY;��r���p��:��۝5�SF����Y�H(1�XP�ju������W�k=��ⵞ5�@�6��Lf�]���T5�����������+��jJ�!��n�a(�Pb�j
'��"���0��wr�lﱧ���a eL��#V���qp�����X�ek=�a$�,IK�2[M�"x~� �P.Ǭ�s�q�U�HJ�ӣ16�{Çg4�s���_��r`ηa�ɘN:�z����B�aT��~���J`�"S}%4��"����?�f
W�����0��������T��R�P(����^4G#�x�V�Ǡ���1��0�[���#��R���V�J���!��Y;P���AP\��i�[ZNg�>��/�Q�H�I<�P䕪�0���M��ِ�D}P5%��@���l6���lf�ѫFB=�ǃ�N����
)#iKG�u(���a(�P�`~Ȭ(ِ��վ�7�a<F��U�j�PH�_�h���5$���21X"�n�(ӫF��ɦ	���Ŧ�0���.����K�0�7�}5՞zU�@��p;�-%��n'۠Hc!/��vڱ<�T=<�k�!��}��I'�2K#bo�cH�����y`���B�m�!��i��,�<�%kMi:�{�*�ͥ���@����y4���N1R��2g����E��^��#4��qI��a�_��z�I��į���GB_����!�n`/�'�M�_���rkr~/���K!��pA�0�R����^|5��I��A������%B���g��Ans�|q]*�Z>�0��L�}�C��T���������l��A�^� �RO�W���%�l1��/׬a�x�~��a�&���3�����Q5��%���{��7����'U}l9_6�F�:�fL��
B�`h7:y����T�Z�a���!Rh� �  ���t�z1��;s�a8|��g.?��
:C`/:���EQ;U�(xp�b��o��@��0�I����cO�\{q��tGӫ������v���_�A�F�!�):(ϧ.}�b��*PPrs_�Q���P����T��Fۅ;;jH�t�[X��š�a$-��<�2�B����a$�������.C)�N^�0�㵽�4�,V۪hGh����ǯ�"�l��;۫�R����+�o�-ILݩ��4O���#5�6��o�b"]��h�/���O��d��;�a�]��ﶗb.l���*5�����K^68TA�a|��t�l`�^
�d`c(��kw�!�*%MhC�/����0R�c�d�5��/�����K,��A�0�rȧ����٪��^��nXU셪
Gh��/����E��)�S5�N�ۧ��o��k]�Bjb�����1��~��2��\�p�ЃӐ&��F���I��A�bws�:Y��	��k$Sb�K��ok��L#:��	�򒄆�|#{gIK�9k�kJٙ�2g`z٦Tj�� j�6�$ǙzU�Hx�i_)�2a$��n5������a ����\�f�ȑZU��K}4�j���U#i�P�q�r"GP5��+��`/�6\Fک�����G`z"]v�m�a$t�?h��5��Z�������{SP���:�Dh
_�oo��6�aY�.4��B���,���[3kG���ҝ>�0��dk}o�p�]g#�*����`IF�_�fiKs9�L���]hH��� �-"PG!��y�`���U�@h�j���6S\�&���c�l�ols�-���q��>X�/d�~1�Tj
��-��ʃ�A�a�����MsL'�9X\o���P������M��0������$yb˒�5���Q���&WE��������4"��^�ҙC������ꂌ����2p�Y�	m�1.4d]�T��_:U�H�=�x���~#L�U�`J�����`�Aeþ��C��g۷8�@���B;�U uq��0���nn��͞l���½���2�D-��*�)4���x������|�U�Hh;�9��
?��q�����T3Kfc�Lh
�M�La`2�BB��6�\�4Wj���qPt�ڼqL4 iP5�7��g�	#�Z8�if#���uǖ;n-�Y�H��J�U#iy�f*�e��rw2k'���ѩ�麠j�`W��(�CF3�+�K9���ro?kKK������v���B.�����3L5�Mj�/{GSn$[��[r�a$�lב�����6�0�H�$u��a$i�W��:�j���5$'?\�㸢j-��5����6�Q�F��a \pwejC0[�N� �Rc�uk}&�3���F�e�5��{����+��#T�W��nj�LVc5�Kj	��Z	��W�B�����|��WKk��k�;U�X�������X��4nߕ��5�He �K�����ZK�U�Hx:�����qՒ��U"�j��/V�-�Tf���?������z�ݨ����g��_�gC��/�����:�.��G���/��i��V�ūs�0n�e�Ss�������w����{[�F�N�����Ve�0��^��j�2KK�-}�ۄ��P����i7�.���jSV���������ɊB�tUC�����550g��*�F�i[��K%W+.�0���o�M�����*)4��������Nv��B�B�X(�`���f�{�	������~��>��LhJ�(��M�¹�ַ�{��V�0r������Hz����_�S�ֺ�'��U�j�a,�c�}� ��������]���a �ew�;K��-%�N�0r��@ڪї�0�ĩ9�$��T�F�0���[��Ȩ�3����pr���|[
���Q�@�� ��+<kEds�#G���B�8x��f�����������i�d��$����"4�ė���c~*4�Q�0�P�������2���Q5����)P}4۪�B�^W�{ӈ$�C� $4��������.����е��xk��&*�������}o�G��a���f��w��zI��Z����,��,��$���TO�F�y�'SFLK%i��g#񜚳���5�$�hDEF�����5k;���O���s���a(�ds?;J:�>��R"���#7�N�0��GS�(�w��a �Z�,=۬a ����4�ix�ֺU�O�8����f��m�m꣆�P����)Ͻ�cU%"4�6���F���o��aܚ`�bk2kwq���h)����^�0��"ˎB�îW5�l����Q���a �����z�W8��p�R6�O[K��l�+$��å^�M%��Ͱ�u"\����j|�ŵ�hT�1����֖��Vc�S 4�$����(��a(���wOkP\�jJi��l��U���]�}�um���F[呴�#�����;j�8���vHW�	Y�͉��aI���d��ݿb�Tc�|�V�B��ג_1�~6��a �����V�$]�Hx�eXp��B�u��ף���l��:5�e�e}{hRq�kI����)Ž��.��pF�HJ�SD����FTh���-?ٜ��ұ	��
���~kk�v�2�a,�+w�?N�٩�y2��拕$�U���0���:{�3�U�u6��0��ݜl�?�}u�&4��+i7����9�վ^h	�umM�b�I���q�]�����0���T�HF}��Ga�z��M��I�X�F� ���7�V0dtzCN	kH��z�j�iu��Jt���xn^dJ9�(��%��[ө���z(��0�8g[ZAB[��RZm�Ab\.�Y�@Z��7�Z�Ѯ��&4�|��T��Q�K��B�8ط>�B����Q5�}냩p�+-�]�@zr�k�H
K6k����tY�V���Bh��&#OF��B��w�a �S�ZWỊ��5�$r[�k�׆�}�Ǜ����r
��ý�_mG����5���Q�T�)�Z�&ud4ֹ@B�@�� ���[{x��ZR�f
�͚n������I���8�κ5ITaުBN�~c��mN�_��Y�@�ɮ�Tᩅ�g��k��a �b��O�RN��Z.�a(}�6�Z?<}v��U5��;����4���X��үh1�Q�[�f)��Ƈ���՟���^HhKh�r�Y��0�1p1������luK�5�������,E�dtяMh��l����9tB�Hx.�:ߩBQ�Ϸ���G�:a�1���~�i�7Fq�lR~0)74��u{x6F-x΂s�����}ښ�-�V{U�HޤXJ��WɰB�@ʰ��$��a$�d?m��89[�O;G#��[^RO�Z�Ph	�b�L�66�U�B�@f'{���/���vmB�Ph7{7�oMU]=��j)4��J�{��/�8�FTh	�c�O$�5�B�8��.�m
Mus�a (8�����_S������$���B�H�pv4:5�Xݙ��K����l�kJ(�KL�$�Zw~F�]�����	4(�U5�����Ó�;LV����B�H�����)F_g���.��l�;�V�0��Ƚ�8���PU�	#�d���T��S<<T�?�A$<�kok�MF}}�$4�����d4�*F 4��뵭�}O��u�&�a ܔ`c��IYB�8J���cڨ�j�\?���Y���D,4��-�[l��}i�U�Pȳ~�\ٟI[���y�ZZ��sElR5�cൺ��qĦ�+GH˵:ky�o��LOz��a�|�e$���B�@8����S�fË�w�0�ȟ["�l5)$`s�
���:�^�04�h}s��g�cGG)L9Zl�_��Y�@z��}2u:��[�V�0��������lPP���q��4�=�?Y]��f#q�/��I����j�_1Y��ֵ9B�@����Ɯ��T����DQ<�ll�
�a$�����okZ���ʹ�ƨ+-�E��a eT�O��٪SH�6����ۿ���:8�      �      x������ � �      �      x������ � �      =   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      ?      x������ � �      A      x�̽Y�9�,��w���v >�_���.)dU����:�~܏0UN�y��d�
�Ѐc0ؠ�����1��~��C��q�ͯ�o�77��y��Y�����ߎ?;���O��<�aP�mx�����������קO?~���矯o/�����?������_\������TdVFf��LOn~���*� ����/��L���H�����@&Nž�|�����o��|y�����맗���fӆ�d(�x�<�簩XcN�y�\��}&�̉�dT�Ή��0����"�����Ҝ�w&>.�}n��yt*�O�mR^����_�������cz�?������������/�2��W�`��0�lT?���4k$2��dR�������1�[�/��#X0iGOqr|��G����/��|��ۧ_��x���߯�����o�/ߞ�|���O�?b��SX��,^��<�*��������La5�uq��y��b�n��	��{��HfM���[�g�2ӳ�U�����__������ǷI���93>Oh�����>��5�����/��	9HhBK�ZN�@������'��x�T�zy�K�z��z^߾�\��\�=�Ťo����'��o~K���]5+��o��;����O/������������|{y�7|{��{��Sd�\���#�/��o/O?�|{=>��u��7����a�	��ٗ�LYAo�����??����XE�N>�|��G��Ǿ�"����6�������d���OI�����z{}?.��>y��f�����W�m0�*f5 7�E_<}L����E�ﾓK�~?���;#��ߟ�o�䦬��c7�6���珯�}}}��������x�V�H�0�/͠b�5����e��uչT��������wv�����6�r �zg�F*v��|��w���������O_~��G��!���*����#1��w]�|?Lq��8n9L��:q��L�U�n����0m���Gu��c�P�Zf��˜ذa<�{��T�yԙ��-tL�����rcdn/�o_~���?�]�q)|sW�D����N�,7�0&�	{su)�����5����������8gpI����I4����8S�Pl?ԷQ��\n�\XcR�{��E�T}L�Ƨ�˂����63�߷_����6��dc��FR���"�gd�n#2r+���	�JG3|��q�F������o�O�m�/8L*f_FVV�:J�h��u$�"�<�K|�'kg�'��<����>}�O�__wnduF��	�D�+�����=ٻyl;��xL~�Y�:ĝzCE>���ņz�-<Fl�珩[�c{v���,�o�����o3",�.6<
c䡬Y���Y�y�q�2$�M/�GS����q���(��о��hӘb8-P��\v�[�,�晡�����.6paX)��`�-h$�_�}��X1rq+�ET�#v*k��>1�"�♜XD]l�"2SP�P-k߳�D
��
G���q�޸3��N?�@<�;=��ǦoQ�nc1r$>z�4"$f􃶸��.&��?3LT�����T��v��NM����(��?=�U�D|�뗧����a��o��x8ȩ��������o_~�b�l�� ������nQ1Ñ|���Hf�gS�l�!�����g�aNn����_�9�f�v��)8Ӽ�\��0��/kXTL�DW�c���y��W�e�yCP1e�3ɇ�c|P�_��QŔ����eq�d�4־��S1k2����Ѻ����u�������/_�s���.6����d���D��E��u�B^ky�E���K�F���z��=Z��?:��)@fU�>���vi3~8޳T����b����Ç�2[3G��a�����d�8�]H&��G_�P'�/�-�^ݍ�[��&�:�S���)������j.A��L\~�Gݿ�����/�\��������@�
#G2?�I�K<��t`��bM\�o�c�� >���F�N�Ѭ�q?W���슛��q��J�4ʙ_��|`�3�8=vF���RL�i��fL�w_竇�o튘R�t��g�����J�	0�}]�}T����iS�Y��j.Y��sbt�q$1k� vZŹ1I4f�T$AC9����� �_T���~�D0* ��E�N������mсhڷW�d*F�-�8�6�裊���1ĳ�p���#�sh���r�z��8���b���E����h���F>�{�d�]������_F���^F�߈-�e4-ϡb�0�yz��6P����F/m�{<I���9y�gy�BWz����//s���Q���&�������ą��3d�uDŲ>���x�2B���Ы�=T#w[F�~]׾��Y����Ĕ=&J��kiů���o�ݪU��Y4�Ճ�$�+>�ݎ�tX���J�d���t�WI�t��L2׋��3F.ʳ�).h�>�/G4�@����2(zb���7&0��޷JP��&����gl>��g�pB�ڏ��,�/����3�pә�M^�90C��n�C�M�.2��D�u}9�m�5��!4ǻ���S����HM�k�k�c*."�'�*�����_��1��4�N��׻�᭹���>&�;�]��br�ZكK�/������
=��<�.j��itbMT��>Z^�'����3�%��KOމ�5	&�Nd�f1�����#Γ�J��Cy���rp7Eg����w���%��):0��e������|�)sT�NN�.����U��Y2Ī3�xN@iiKi���)��tr�K�Y�n�y��;�2���k��0�NU��П�S�>֖��S��l�
~�V��C'(�y�0�sߜp|��T*G�s@�0b���c�¤&�O�Ԥppb�H��T2Y��U�>$��M�+N�%���� �u��(됢��?�^���s	�iC�}L��B�$o ���%�3�Ɂ5���@�>Q�礋�������H�A�|�e��Ġ��UN�
����äb���C��������,�-��|�z��Q!�!�RN[���7]�E�z����H�B郊��E(��/D�ov8&]9�⸋\@���P*�
����s}7�	č�A[���X4s\H~M(��aK�+���xJx�̎x�q߀��8f������H0�����㍣bF��oH\l��ۨ��z`���(9���`;��x�_)h�_���αi·�	ڕ���޼W1e�/�R���*K8W:�.L�pz'��,n�9}���h��w`?}zͪ �F�`���;�̩.���ʳ�Ĉ�&��Y���M�?�o�Hy[��I!��{�*	c9��L`T�rSF
�t��,�LĚ0�'r���
I��z	3\�R<��Ѽ�}\������/�!�k�z�g�^HO^ �Bg�R�Xkk�H�%�� 姉�n��I#��� �y�Q�m���v�ٳ�8�5���<��G/�{�g�˖��l9uNSA�S�l��U��0"�B�j".��%�\J��)��̞hH)33�ʯr`�4�[|=`O�'R�|��r�XO�Ո�ߏ��}{�>j�Y��8Q8q1�-&&3r����%�q�5�̸x,1�\b�g���,�b���x�#8�$��b�4��IJ!��7�8��Fk�����u��w�hIה%���SLg�Ub���
)D/������������n� Yu3� �"$f*��wB����V�A����ᷱX��@q�,1(��u�Hq�D:�\��U�~���l�e�["Ȧb��q����ᗓXcϴy�8�t��!�|PK�T�x�e>��.BtjlT�Io�C�8�?�L��Ȯz���I7��ڸt�@�'����}ìb=�>�wl*s!a(�f��㭸 *y�Q`��vݏ3~;X1hT�,a��&��3d��A�Ą�j��d�e>����E��=����"�p���Nr���[<g^�J֎����AOx5�a���QV��@bl.�'��B	u,��V��>ZL�޲�Q`֊�ߌ#~?W��c�iU1�-Ÿu-=u�5Bq�_�a�^޺ǰF��dq�){�	��#D\���zd�V��    ���}C�GZ+Wfw�Ec������98��b}��A�jC��M��9�l�S1�va���k�:rj�E�x 8R���6��Mn���
��'��u��1� �Zv�o�"~�:���%Ƣ�$3k����fC���׳�=6�������c���en	0O�eZ����pVL�W!�s�'앬o�Ԡ!�]�5ׇq!��e),��7�E��s꧓ުG���/.��vh@O�5/�z����뭨�����_O/�������z���x���x�ꉨ�=y�T�#��B�\A�3�'y�qQ1U��5>�\��N��ٹ6R �����/gJn�����,�+ҁ;���|�fS�>&ICR��*f)�����l*R*`uw�����do�q0XeҐ�HS�Ɔ� ��O1��5��Q�o��p���#b��i���m�գ�h�Z��ϻ
����Z����
�H��D���@�)jN̸RV,�7�;���T̴R���_�����b��Y�O�%�8tд 6���Pm>z�����@���'}���s;�EQ|��(C�����:��6�ۙ��iwP�D�����e������>'&R�&>��ݩ��U��]�w!�<
�a�y�>Gb4����H�9�@�#�l��+����=�JM���G���9��`1eC�5�kHLjF�MD`Q���)2~DO[�s�Q`}��1������+��O٠� ��ʗ��t$�c�a5��g����De�5Ȩ�+��eV>K<��=~`�r���W�G ��i��D��	����kCC~�3�r/7��nk|K�c�v������b�����>���~�WS�0|�	ynL�*�~r�T�%��ų��p̥��ۇS���_,,</؊Z+&�R�Gb�+[�f�BҲ�2~TZV1�|\��{�Hˊڬ�9��E|bfQ�	�-��7����V�r ��C���JT��"��ɍ!�&�ڿ�6�`�bF7O��^��E��{%^�����g���|?3�F��Cڊ��u�(��R�{M	Kht��"�uU�˫��V�L���Տ��
ޕ_��,��o��X7�֕���̣�3���NS�Yvhbf��]{:z0��C�~�%���I��<l*�2��`ƻ>z�yN��W�\Z� ѵ�M>x%-�o�3���p�v=�f�jl���3����ϟO�_�~��6�C�g����f!9v�e�ܴ�gs'z��5 %`x�b�C�쯢��PJ�����b��҂�"� �����:d><�u����l��E�ZaC#X���=Ňv{*'sa��v��u����y�͸�W�����ä�e�1��aY���h����U��Ԏ!%�S�|V��9�?|W�#�8*�|h$�z?}��1�xMܩX-d���&6$��|^�*���	xE�*6k��=�����!'[.Qr8����zƮ��a�lI�L��Ξ��W��1r8���71�qR1�DM��~�t1霨D�=QQ�U����x����C`�
��s�7,�T9&]�<�qa:��+Y:	�أ2?��S�x�`�ۨs��9.i�Uۨ�OR 6�jQ^�75�YŌ�GYrꢣ�Iv1y@����ʭ�(��)���k�d-RD.̞�J���X�Aˣ��Jb���S�Ts�n��c����4�.�S����~�����7g�����E�>=6V��p+�Q�eY�[`F	����epX�}-�DWɖ�[	�ծ�����%f
��]��M<����%IĎ}Э]J��T�8������1�zj���*���aD���"f\��"�b-a���r�'.z`���#�����j�6�Y�N�n�)�!ZfTy���J�1k��HcL	i��ٕ���H�VrI�pšsbEdL,�T���@�^
*�z�5�Wt��o[W�I�7F7[��hk�N̬��ZHj� �i�b��y�E��T���5M�z�����DCV�pJl<ݰ�/oO�_�������:zf�&�ʄ�.��Z`	,�3�ď�o�E�+��Џc䡅M}'6�88xh��P����\��Z)&қ�(s�Y3Ϟ�����N�X�O�#��2�_`-S�L�f���Ǆ�x�X�h.��pElL�b,�s��P
:g��4���!�%�T候��MV��]m��o.��.=�#���D����'Z1nDX������������S��8F"f�(k�鍊����'�W.��i������4�&>>�F�Te�) ��1
0ߊq �m�[#�(�<�5*�,�<�NU�@i��F��Ь���*?�a`����R�:��as��Y�9�2-�=�q5L�����,��[}Ϋ�ᰒ��?A,�jqĖ�|��L-F��H�V�����S1^ԁ]k��jc�G����ǹ��Z[�Q8NL9D�U���_�en뙸0�bS�;��j;1"6=^l|K!]ctS!��?�̜���)�dM���^��W,���)�!,Y�����L��㕖�^�&����:9��H�y����קt�'j�_����������g�����^�G+�UŚܲR �u&M�*,�n�`���	:ᘉ�� �HET0(7ȉYc&V��H.�V,�x�/�\�(<�[�@sԛ�9˰'Gw�gF�}Nj�Ӧb�}9����`�]3>���7D>�]�'��Y�pL`�:/\ȺD�We�V[$<%!�,�C`�\���4�*Wd<��"4a����-��P���x���7����:tÂ<�]LL���	N�ImO�b��NbM+�����d6{ߗt�M�J`V]i\���̏���x,��_
&GV��U�����8�I��)��I���l�.����w��c��Cy��I�S��܈�V�Q����ɫ���᱑%:�&��eF����K�Crǩ�Ǽ��q�e��k�a"�qF��R�������1KC�kr�:Di��#��e�'F(���9��$���~���˿��/�����ۯO��N�p����#�K��cu�T���/
i����6*v����=���m�|k�wC,��9���@�b��̱�i�����"?���%��/�J�!��?s�R1�Z����6��)Z���2���m0�fͣ��׏?���昞�}�l&p�f1s�����('f�_��C��b+�8�vB�#�zڢ�GV�R���Y�������V�����~����r,wN���w核�	��F*zv�{���m�2�ϱ��=Q1������\p�!ߞ|�o���Rnȱ�o�z��xsyr�U�Al|_�9�8����<�Gk�&f��nS1�N�����R_E��Ы��IHSP�L�91c��u)/mm:�q����c��$b�攁�kDq#�Xw�6r���U[Q��3���/0ʚ��V����T	,�&M�k���e)��}h1��.�Ԛ>ǜ\�H�������ۗ߫b����M����E ��Na�êb,F�����u��k�G��vJ�\��� ;z��YŎo�Ǐ���!��<[&�9P�*�T̞I� ��]L��V�E�@�b��oL�l���ѐ�Z����e6�h�8�x�3a�X��`�GUs�\@��;�V�u��;�����Ŝ�F��e���bĈ,yu�%A�bbN�d�4�+���Jk,���5�x$sv����$�hN������d-���-
��txP��r�N{��r�s�;��~s��e���uC�5�;�F.���8�b����q�Ua2f��35W����>W,���p��%9_�=�&�J����CivO�r�6�xW1ɱG"~�z��j����IŴ�77��(�#ydT曏�W~V1.��#1uF�(�8O��O-y�a/y�؎�X�t�E�Ĭ�N�\��^�����_z���G�V�<�F�C�mM���p�/2�L5�I��cw��}������u||�����]��ǯmj�ɗ/���y�.'�l�)�'���0�S��i|T��:���g�4)9�u��3M*f�zX!qAN�E�(���G��A;�A�(q��Q���	�-����|�N.��:-]T�{�q�Y:-5x����e�r̠b������hz��cT    ��K�.!�!-"&E'��̦y����S�j?�\��xs���&,bO�:j�6�rѯ7](�X+jw�xH|��:�5��
�1�:���:G���i��u�c���4z�U%�4#���1��Kèb�Qw2/��.����Ŧ\y�����bI��$uDQ�UŚ���[텆���(��e�e�M�x��}���a&/^%�f1�3�^z�$� ����P�N���K�*gӶ�>��؃�.�Z���-*F���*3�T�\Áp��X喻DZ����E��i�xT�]�Jo�����8�����8ߛl䘁��*Ä���\��=ړc��ܛ-Ӡc^H���	#B�Ձ�`�*f׷Ë:F^.��,�q	*vEM?�3���N`1u`���9�Ӂ���N�����2�uM'fni�SR�B��YŨ����H���h$���a-B =j,��/*f����6����6���n��:}���#�s��eB���v
���I�H����E��j 2���ZF���ݴ�si�b�9ڬ�)��~<[D�*v	C���O���~wB_�)�Bb'�!���W�pq����$��*��T�d�ND�2*��y���
�U����=Ͷ��c�-{����	�aGt2���%f#O�=d�c<GON]Z��IH)�790co�,sX�˹.I�SS�q�"<$dm�z]�O#Ʀעm�"m�B�s��҂<0�`�HðNP��~͆�E�T��`��?��V�@�9jp��P`V�A���f��6�B�)ǘl�S�܀;��4V������x/:�=��F&�uP�95�c0�i�ƴɘkc8�V9�T�
�V�X8,�6*L�l�
�ݳE��_\�H�<��o�0F��2"��4)D�xD�u�8��9r��
!�n,�H1�d�.��r���q�������9���+��9s������Ew�v1���}�'o5�)y�}�x]/}�A��>F�#���n�y��hJ!B	(�g��I��J��HԚ6�{c;�ybGW�YR_��Yr.�]d5:GR���/6������6	�p��S)�/,�c��~c�.�z{a���c1�EY�Ӓ�h̚[Df��Mߺx0��ޝ�#�Ց�EW�TL���������G�Z������ѣs�Zy|�E�HC�k�)��	����t�8�h����[]X8�~���b ��q��o<���ot{�)[S��Z��QaT�u�}<蕸؂^.�Uq�o��p���:��Z�S�4U�ӱ�H���ȢT1�b���&�W��O٫K`�K�����>]�.��t�@���x<�[(�m���K��#4+{�	��|�16ӊ��(P*��~��b�m)l:l!���S��K�~-#5$طk�!���qq�D��A��֗Y����]^1�L��g�v&�_C�aW����E-0-�mޓpA�'�KQc��)Σu�P��݇��]�*Ɣ%�����ǔ��2/�=J�cLA�uͤ��P���j7���Md��-�xr�i��:b��=�0V��SXU�ޙ��G��^��HR�������[�E/����;�ζ_��<(�c�=�$f�E"N��\h����.�L8�bo�����|�
��cL����ٟy�z�H*^t�vŹ���co:#��.�.}'��<��u_��~������~&���s�p'����`^>�/��P�����_O/�������z����]�*{h|h�
{���͈�bp���N��������Nd�WO^�=���<�Bb\Ղ(�Ɗ[7�릟�n픯�4��G�3jY��:����t�V-V��c�̤,b�W�0=lU����]64h��՝\�@��k��S�L��X`lfU�X�jXd Rb�#�%�0�<��b]���X%�W������q��1~T1sjG ���6��L�8Bgt���ѽ���f�ɒ����7Mм��x�����A���ezD�n�Y�[�E]6��S1˲1��{%��E������H��0[;fR�L�,��s&�"��(���>���^��N��v��oҢ���iЉP�}��S:ǭt�#�\�4�Z�,��oѣ���T�%�+��������U�m��Iv�jsA�,����6�ď$I3(t���$�Rgٖ��`�I��$�bB����F#&c�XG%!�N�CGl�Su����yc�LG�FF�$���Ġ¢b�))�H�B^psDZ|�owbs����cRPX��T��E���Oc�>����#�z����rv�(����������R4�L��ћ�T̘�R�22R��A����jJ�1%�h=΋Ȝr,�O����	u��Gڪ�:�YJ�ΗK��&�i�xx���h��pҹ	7kȭ�ۨ�T��5���N����A���lp0d��8| S��0�wV̹h�W���<�H�F��24̽Fu2�Sb������S�W�e��>����% j)&��*�)$�j),�Z�	>�J�6�Y���y�Ԯt+�n5t�:x��T_�Ϙ'��E�f崝��_��5M�D?��>g�{�c��Z�KN��Q��|~$��l�u�	N1��L����?�0A3�0P�����/*f_7��������\�U�.�	����:W�^wT������RZ�-Y2q�.σS1|7�'Y����$��ٷ��Vl��q�{�{�E��~�x�xe��kt�R\�V���h���f8��sZ\ޓ���ϗ�������S_q6v#�^Օc*��YlR�a��s���Ę�i�6#jm�E�������?F^Қ*�b�ÊQ��=�p�)"�'�Ktf�TLƨb�����4�:ѹr�&�sa}�DDLu�,�񀍊4�r�0�� ���*qQ]1�ɢb�c�PڽbIW�;�z���\bF�ROʻ!)^�.-� �%f�<9_�$�a����Ŧ���e&� K;�H��1��	������x�/*f/H�߈�v=�l�6j��y��=I7���4�)gT�9(�Y
�H̤PCZ�$&�j���jI�)œTc_���hHP����{.�9�Β)�	���P�O�>�0o
�.�D'~�"�;��(��:Q�v��M�'����z~�\�i���&�(d���Z��t�YE�B���V���8��2c�Z�1�d#1��j����W���!ٖ��_b��g솁�x��]I;��bɺ��d!$�!�E���$�8��&u�$�z���?sO�ag�B`qH����[G�  i�ħ�*D�̧)�Db��̵ZK�~�E���x��о+| i��RVŸ}w��k��mX�lf.�bd�fXu��+����I�
x���W���,9�䬼X�J�$1��8	��E����T��8��E�f]LzoI��9���"�h�L��������}�w���*'���^�pLTơ^���9��ZExsYKTn�,�U`�BfÝ�j�oIf^��̖�2����f�}<>d�R~�6_��&!�c���D>��R�(�LU��X�ox����:0�6Rh�c�>���E���"�x$�r����0\ct{�1�������+yoW�*�^r��i=�� ��������U�0�Y'݅u$�\~`�����iuC�I�ë�Н�銲��G�����.�Ps����\B:G�5��������F'J,���l>Kt�&�L�!k�/��x8T���wz<�&�nU·~����%�|щ�TM�g;��x����°]y�=ՈF]������R?���ӿ�^g������:���|��r��O|�>�.����x {�����~�X��)�BgD�A`b"a��$�S3��{,ǌ�ڳ0p�CL�ɢbt!yh^i��z��c�"�+�f���/�6�*ы�},-o���2?�8�r+��H�9���~U���0T�'�����@���)Ů����냐rX~�X0.�w�n��ǉ���KhWn���7)� 1�|�=��x�$��R�a-�
?_Le�Я_T���1k.c�k����Y�~U1&���_�yW���!�_������3��=~��4t1�>v1q)Ҹo�w��#�h���-ϓ��<O���ҫ�x]��h>�c��l�����    Ey���|T�s`L�G��#و^_jh
�q�_�Xƅ��o
�1{�
�vi�*~U���jcFt����*n	c�ո�o��E�=�
�9�ӰЁ=���Z*ƽ�댘��4�X�i��`瘖�s�M[��~�N]raU1��s����F�T���7r/�..��7��'�<Nʩ/E��SI��n����򤰹Z�����T�i���Dh:�T�u&]d����"��G�l�������/�Zx�{�D�Ccd��䅜��]����k�Ig�&\�5A>�`NY�NŬe�3��Ȅ�c�H@��$���nR����<1k���`�`�U�̜1[O�Ɯ��Z��UC"��Ɲ����:Tݰ�q���.2}��������b�T��$R��R�قY�����u�bFY���1�Tf{H��M��öз��)���'Ę�~^��'#zO| �GsLż��1���N�¸}آxl��5�.+~;UeQ=S�k��^.J�E*FiBwԮ��M��K$��כ|�T�jN�=H/�j�������N �C��MT����{?�3g�2��6i�Q!�7ʼU-�Y�a���-���Po�[B�>Y$�S9IR���U�*2.�}�_S��;���'�5�[��`kFz���j9�ܱl|"[��D���tb=-I�� s���YT�4�ےfˈXȕ�S������~>Mm�6�G�Ml�Uu��ԨH�i�l��רYb��:�hfZ[q�IEo��|$��*�tKy AŬA�{tv.�Tm9ju{%̞�͸���L%�����*PǸ`Q۾{�Q�J.�*&�W��e;x_Xߩr��ILj�1��M����t`�l� k$�x���)'%�]����h�N��nuWƿ%�Ʌ=~Wƿ�Ԅ��*=_.�4O`���	�������X�*�'G@��H�0ǒڐ��5���p�H@�x�#��|�Ĵ��.�0K���KL�葼�ӕ|�[�0�d~�G.��L��٥:�
�:���5v
O���:uz�Bm�ݠw���F�[���l�壗э*f�X����Ǥ#=�B��	R>�+S�.�CP�p���>A&R��j�KJ߭�P��z7��8��fX!K���fI���ꚣ-�AŬ���B����K|��*�0�¾�$��iYj*�\��>��4�Ǣ��L�ߢ ��T����YK�f̥����P���\��`�+?�R��Z1!jV����e���c�X�}If���)Re�Yb�N�j�_��!�;�)�ִk���T�*S�kc4�*tȢA���`�X��_�Ǣ���aw���|!��� �	����aCzcԵ�!�L�b���6I ܔ��o��U���2�&,�6Wӳ�f�
�5����q6��ҷ�ςM�̡;���e���t��f��dG���:*�ݨb$��x��aA��*}ʋ�����=�h����aJ���o����lԁ)�����#yc8�Yϛ�0���4(�Ka�\���9�L���V���׊�B���bM�m5F��_U�ƚD��FI�T�2��4����e��ݺ)-�*����TL;����5�vW�1�s�x<W�q���h�U��3��MDD�dWO�4lP��Ol5��������6�}����ߋ0�i/��3�PW(�P�V��$w �&�5�R��C�NŌY��J[��M�%T�V
z��(x����9�r+���ش^��3~cI;�3���<��}��3�k�3�C���RրT�1&�Ʒ��ƚ�5x`��\�4�\(��q����l�ܤ��D�]������v����+��@��̑r|�G2 ��E�y�[��g�1��:�فY�HY�u�5�����9flè�VјcX�%q`mј\�4L�I��$�k�U�93��d4�)�#������Ê�Rb���*fp�-3�>�Ei��p1w�p���e�Lt5(�/��za<���)�!��+��b��Ioͩ�Tj7@UޠA� &��c�%KbXG��ǥ�����'l�I�ȏ^{���Sԇ�i��v1@3��+�f(ض���"`m�D�L��	X������������r۳�KUױߟE_��HC���c��=���/�X�˸8���ʛ0��K����i��E��$j����jw�|`MQ#8�R��a�
�f�}�L$}%�	\��[�e֒����"m��#��VQ\|]���i����/?w�����������GMӊ��q|���+~�(�%��> �ȑ��I��d��u]��P+���G"��*��{�<���fW���Q�s�
=-������ $�������K�n��+W.��ܗt3�Q�_7)�c��9�^�To�uH�`� U8��|�ʘ��X�p���/WA�Z����V%��\%@��+5�l�cQ`�p�j`|ؿ����X1�*�X��G�g�O� ��뒠'V�H���'zP�|���)ky�v�k�`�gy�UFjz���b]
D�S9�߳�̐5P *6}���"�v�>]�N�e�`]�.�գҭ��1��WZM�U������t�t�2��R��-!ۣ���MJ�fl�.��v`�[��05����g�4��K8�v{A9n�^�c��������P�=��zDm1���^c�U����P�<B_7��F����d4��>*�h���*��c-���Y�p ��+�ǣ�U�Q�C�L��o�~�_�~��)m������"UY>���-}a�<�?�C���'M��6�0����)t���(n�U�cOC�p�BԺ�OuU����⺙5e	M����$��iV�Yx�_�M�����������H��#�.64�d��ju���\��̊��-��:ސ��
̸N<�&�*n���4����� ��o(�L�H��d;�1�w|�,pF�*�Y�9mwQ3eP��cԵx�^s��w{��KUp)����c����-�^�?�Õ��է�̯*�]Ʉ)-�]R�]}:fC�����s<^YiH0g�����3V�B9���r����#r�uX4}ԎS�_�}�]�c�'I2�+�l*��c���@Ҝiw&>��@&w	��3�a�>X5��@�yrE\��쪂>�]�E{��'4�b"���]h0��(�W��fx�b���U~�������>uM�JGwHi�h\�ᅩ)���17cN���-������J~�mC��[-ɑ�`Ӧb������	W�!a1�>K�4	�<�*�!�<x�$�1p�)�ː����	Ɛϊ�*�*��r��\o$�gK6w;���
�M�0S�/KD�ȡ[r>������R��Q�/`S�ˁ��|���)N����J�8��qj��6�)%h�^���?��Ո%�k�g��L`ڝq+��H��>-ynՅ�hTr> 㣋M3L`��W���1bL>.�6ޒ��6��:>i���h�!]\�abAԓ���nDN�w��̊8��G���Xn�Yo7��0*��y.����b^N�0����`M<�Z���zR qF��y\i��i-���y'}���k�Q�>Ѓ���$�Z���w��H�I����fD������)��G�$d��gྸ��>+�K�90:+v* 8�E��d�m�d@�qCұZ�ìb֦+�g�����fz<5n�����db�ͫb����iwD��LF=2�&��$�����(���U!����Y��Y�f�c�5s��C���.�Ncr�/��B`L féT3q�T��<jN�:�('�p#�j3�!���y������M@�<�t�R� 9��R="�)�����b�kAi�}T>Rx�ؑ,��(�\�,J`Z������ 0��bMw������x8�2B�Yu�V��͢Ǹy��Y���l��*��f!x�Yo�ͬľ|^
cP1�!q�nP>��e��#�R��n��C:]�r������e�E�=V�M�a҇���BާT`��~i�5�Xz^��st`�Q�ȑԿ�Ha�܄��).�g_��b��'��z��>;�����۔h����#��ԔZ�fOc�uT�x�G:�&�����    =�D��v7����-���l�u%ZkM%�/F�k���cOY]`�F�D�b�z ]>Vl����Aa�'OJ���1�7}�+2;�F<َ�#�+W�>kc#���ȁ����c�hF��䠒w����:�<�$�
L�I��
��$�r�-G�\�Bn�|ӜB��Rhr6s-�1֖ec����jo�q�}���N��OtO�jS-�9����?���F�ʕ��D�W����P	�f�<nڲf��O�D�x:H�%?r�AM��F`:��Da����`U�d>�������k�|�R`�=��7/\��9+ü�z��n��\�B�[b��I�q�7ԼX]�q�%��7�r���(���.2X����~l������W�!�Nvj�m�f��)V�[iԜ�!Bq�)Hx"��VR9)�q���b���U����v�5�y����A���!���5+�2?���n����
�ؓDŚK��\H�6/k��(0�`���F�*�rKbw�D�T{��E�����$��8���S�zS1�~ �D$*6�%�s�q#o��<?�W}P1��-�YH\l�o��CȘ\�;�VI�T��������ʫ��Y�A`��#�)�.��(#����884��#��l���5R0%�7(| Á�37=��js�h�<��%áA�������2������2�qX��c���]���gS�Ê�(�δ!�����\���㸱r��0{�Cd5'.�t_,�g�?��8<�z�+H�i�r��s�v�E|b�L�{�%rF>����*f��2�Xm_���&T�fmx�k�#}���b�	2�җx��ST(9\IR�!cU�U��%�#�s%�E��U�X�B\s5:�!x�e�c� �h��G���Lq~��.cp������?�>����Tpy���l��Dcy�����XG�rzm����"�e���(=X���r`B�,�Wda�����@��kt���<�@2�����K�I�:��f���7�7ݺFO��zZk�%��O�ņ~*��#E���Y��T��*��z�/aT�6��RZ��"%�K��Whs/�Q\5�jpyP��s�$\�K-�EB��:Z?��sr/�R-E��ǂ�(�>��j9Ë鏡���S��/Y����N������K�Qi���0CÜX>�^4;G�I,�yA��Ʃoc�e��S3>$N]}��9�GŬ����$"C2��ɉ��c�10bO\j��K�^�4l�	��r`i��u;a�-�yPx܏�]V�*0&8:a�i)S���XӘ��h	���DA�F��gS��VD�`,H�dnV1e�:�mȫ�\�K�(�/��5��q�eȅ��g.�Y+�8���������~;'���5(\i�?������kk�h�+�AP1u�F'9r�G��눹.��@L��q���0rоF�k�F'-Y�����̘����|�ȒE��v�������`����.�j�N�s��!>Q��`U��w�xq\_�xfn��l0FV�xq�\/B`��<tȖ4�ʾ��.����:^����v�IC'%ac]gȊ�_�S,-���������E(���u�����M��,Y���Գ䜀� ��G�ϫK�z�DO�"���ޗ�R?�_��o����u��!�L,��?|t����?�9O�!�c� �_bL{�y�h:\�gH����U[R��H��"'S�8�����\���|���q�>h#%c��<Z4���rTF�XbT,^3���m\S`�4�ڀ����`�9��y&�&^���ϕa�IrZfA�1�T��Qx���P�b����%��M.Y�����Lh<S-p(��tS(�6`�� 1ʧ�OX15���U9�*�PL=c�8�,N�%���Co*�J/%��#7xea��/��#�A�����(�{���n�}��aQ�hx�Vц�W6HS@b��K;����z���Ar�fS�;�ϊM�`bt�Ħ�m����_XG�H�|�4�>60M��AKl��m&R����Aa��Ef��<�3!����>���ّޤ�3yZ�>c�t�jr"`��ht�u/��!�Z��飵��T��l%�L��zv�ЛB[F'�M�_#�V.g���랟���t�.I�oU1�;<�:l|K��5R5�_&k�ȑt�jG�X�Y�@O��s�Jr��4�v:�
��Ћ�}�½ůY��bתp�p�b�X��ޫXWw��a��	*�֗cH���"���z��`���T��`�|G�(����#Ie�BGU����c+tr25Li�P��(��=�pGə��*�>���.�S[��+ah9���Vt����"O�*
���v����jA,37�F���)��3KG7���P�73�ZQ��r��5������kՓk���+�{tY3^�YJeGM��gNy�xJ��ĕ����nCO����my����ԺtH�C�u&�a9̻�P�y�F�MZhܣ���i���*]k��h��c��A�."9q���V&�C����RQbf�>9M0��E�V�y,��WQ��~p�Xb�]����>,5=�U$0��2��B�0��r�5�4��P�-G�E{f�,d�h-�>�>RTh|���i�w7(���r�Ԥn�~T1V>�K�I0(��p�b�F3˜b��h� M�.[�nAYL�q�u�,�v(_N�|"�A:�'���F/(f�),}_絇Ԕ~T1����{�{7���>6��h���{Z	�F ����d�����9bdܦ8G�x4W���lRf=��)��,j(0cm�@4��p�\Ʌ4�X�Ml���BS��C`Ʀ,;X�:���&͠7�@�k��ŘG4fͮ=��h�4AR��pX�]%1+)Q�I�Ӡ����;H�ia]�Ҹ��<E�V�R2���R}�1J��JM�D���b���t�����\\��0�����_6�ܽq�����'^�vJ��0���)
N�q�,u^`�/s�a�X�UOL�m�A�51&����x�Jqƞ'l|"�U�ct��r2�X.G2gҮpU��gT�Z�ŸXi����8��i���5S�ꔍ����M`�͕�Ǩ���I��f��(���H#k:<*t6�]��1{�r� �\�6{�*ݺ�3��W�Yc�*�f8~���B�͕�dr�f꽾_�b�K�Hj9}Bq|�w�1����pΓ�씹�3��$Tb�7F
6��~�����T��J�8^h y��F����$/u�x��͉A�J�h��	�TW�5�{�'�НQ���b����Y��c���#��LW($*6N�:|z�����l`�`�T����xԾ(_a�XP_�Y~�X�mw�R��F����z�e%�\���RɰT1��.V^Vl��9�����H�q�>�o㮙؜��rX��JXj2�G_����Ù��JZ�()��3�6�����C�}�jR�@��k���^yÎS�<90�yyI����e�ϥʡ9�L7�.][���TL��D>�s��[=+S(��������-0��Ťo�n̮���<^Q�3sN�U����L\����1�X�xO�6��X��r��1�T�f�I�?g���*ǒ����n7{��k�Ծ�c������Rrz������`�܌=�UH#)}��b&���d�(e�E��QŌ�~���b����k*�����)��zDdR��e�7l��N��5Z-����^����L��_���bD������x�j��\�����M�	rW����qS1�rF��C{z��Suq�h��0��Zp�v�R�`�Y�>�J��MVٳDe����c�g�<]�F����u4�d�;���GlQ�n�敕q���|5��siT�dِ{�<�·Ӡb־�.���רN�>З�����/ݧ)�?�O*֫��~'kr�d죧�c�O*6>h��5���MJE�(A��ݢ�ҏ!1�j�xN&�v��q˭��U��7g�K��11iN5xhije!a�LS���%;����_9��%�T̢�����DH�>���)����11    S|��ξV��>4x�N�/�����~��������_Vy����b�*�n7���X��`�.C��MK�LF_]d��^��#Ǚ�r`eH����]�-��TA܇U�*��T�`�Y#�.f}�7m�i��*�ߴ� �1�I߾Nr���k�E��I�mR)��~��8���N�X=��]˰�MZ}T1C��^�h)�g�$���T4�b]�d�ai�}t��`���T��8�ɗ	�2)W<�AH���'��a#I�ʓ�ϙZ��襽b'�6 �0��bH(���r��8|����L��{��wρY;���y���1�T@\�Eb/��"DT�.�r�e􀧡��і�t`t�h	����_���5d�y��K������}�T���T`l�,m�6�����x%%7�e5��	|`� ��o�FTi�ٚ��ߗ��!k4���\�[?mE�ׅ5c��8�W�n��fnU1�� �~�Hp�r���G9�w��\� d���r�@�2��huUܒ'F��ǼK�o���*�b�"?��^�2�]Џ ��
��G�b�i������k�(�1r�7U�@R�W.�#~�����_Ǎ���i��!Ң�x,����kk&�繌f&F>�i ���a���~Q1c<�r!7�r#��Jɿ0.�R������5zӭjಕ��k~�����7�������s�ʲ��c��=9���j�0��4���E�f?^��'�
Mf�Ϸ{K_X��aP�k	�Bd'"���D�7���F��V������6��S�\���L���j�vsPF�1Z[�X�'��Je_)$�ؕ��>��l]b�l����ʽ��B��w�JZ���t�2,#0�9�y��0������a��m����ʢCF6z����*,�d)��6e�}!1k�NF�/�m^2��%�XrJ����z"`�k?�� G��&erDg��P3�鲉��"���d:Eo�����+�����aȱV�y	�8�
��^5�c�ާ.�&2m��K�H�m���h�ô�}Ζ�}�QK:fM^#\b�H���N��}����`P1��[��u�C��u��˄�^S��r�N�XKw�nAyh�㪫�I�;��OQ=�ߋJr�2/�觃ϑ����%acjҬb�%�UR�[>]+��uy[�9�սƖk��C��wK扒�1{�G"��d�Q*4>�	L0}����^f�5E�H(��q?kK���u� ���4#��|,������V5qW�#�VV���qS��돷/�W���\wj/�>g��7Iv�+�NC;�5�P<.�ݘ
[�nXn�X��/0c�#>�#S�c�Hc%a��|�*��i���M82`��:>��ɱ
i8���kyh1�4���R$0H�����i�$7���g�n7<��C`�um@�s�Ԋ�1��,��7��JsJ�T�{=�v��PKdQ1JŲ6\L��\���^��(�t%�e���|����7�!1��9����k������.}��A���q5�D�4��jn�!�u���bx:RSE=���zF0y2�1m�� D�d��E8;=x�ȶ�̼Ȏ+jJ��Lb�vP�8��tCjQ1>�0�p�UjB�\"1��C��mj2�1�_L㐹1����V����y�⊿HƴT��q�e�^��_��%2�*��p�M������a6:���]v�N)�7R��%��)���^�Y&���Щ����n>ȣ���J�~��RZ���� _�.�#M(���]����Lb��βf��F|u���C�s�QO��q��wI�x	�D�* "^�L���$c��wȪV�P�a���T���ת*3a�↑�V/�K3eҊ{PbL^���Mn�k�M�lny�cd�e3��Z�SbF��l����m�E�L2Lc��^k�����6����W�1�ye�;���N�Kx���㒑2|����;���HBD��j���Ƈ��(0��4A�9��m	B�P�^�5��ÿ��+<�|��x���4�{Eb��,v:\����+�Q�p�,��dz�5&���DS���A��E�!E2�,�wz���h���]���2���`��
0R��Ķ�	��j(�Q��ZE�b�3�&h���Mz��m���gV��p��#0��Vs&�פzb]��^+���"�H�4���l^���Q�+1kU�գ"�j�MŸ���cC�܀�ǌ�(�PJ�d@�\1�R8E�9,�iT1���9P^ �o�tt�� <6k�?�(�1)1k����{��	��q ���I,��lH�ivt^�I(��V0������4p���X�u<�=���ֆ^1��G�Qc��C.�4��E���.�c�z�1��}@l��@�7�r(��)U9�ܜ��v/�mE�0����*���.�\�N�.Snli%&'&7�F�&��ϐ�~�Ȟ;�a;Xa�{�F-f2b[<���z��hEsڤ����%���S1�㏤�9�����$�ȣd��^�Ƭ���x�Ў��f��x�G���뵋K�ţ��S����<9cɁ,n-E0�W1�j�A���;�K�
%�E�,��o�O �
1�Ƹe	�Ħb��8}a ��E ��	L��Y�ذ3x�`�fS� 㱒�k(�Ds|͂�#N�ȥ�-���'�������@m�!^�q�x46��޲�э�.�4V�Ć(�ζ��dbe�	K̒�sz*�FN�c�4��<&�G 5�E��k5<���9`�U�6r���gA�I�]�3��8�ə��vs`u�xD��~�j��4��.����>��b܇D�X>JP��۞�A�XR")���n�]nW��$0�ue�a���v�0��\%�o��S��6���D`t�bݸ�ǐ���Xm�a�����N�?���T:J.f+��<���T̜���葢_��t+8�x���W�)�_�!���$D�O�8���N�5���iFDL3Bh̤|�����w��Ub���QrX��5����<��ZF/��)O ��Bpi|]��ot��ݦ0l��{QØ��Ӑ�R
�C��g82�E��'+�⎞�	У�$jO���7��t+�W�q�CXŬ\H�� s滘X�ƌ���_�H.�ES�ΛO�N�~����)iq&6���HB�\��MJ>��Q��F*`�\�\a��1y�G+bb$�P��z�,	�����qbg�mW���8��'��1���Z��16_���ڲ'��z|M|���B����z���(Q�
@�%2�õEW���XS 2�U KiGx�t�1�@*����Eg������9��;JD.��&�0v���yVܣl->���N����Ա"[���-g�� �Հ�W��'t��p�dqem���� 1���
��պh���!#	0��I
T�I�T]�om�`�ݖ\��g��n?�T�*��cJ�$d���F�h�l0F��c�*��h�DJ�qR�P�~�J>N�#���
T!U���4�BAW>*f��i1��4�<X�ØXD�(OH�Q({P�����	,Yl��َ7e������YDF`<������ݚ�ylD�5�L����Uky����im4�X������4�#��*�罴afع�J�~}�^�e�%�i����$y�j�����Ɩ�y���e1��5��R�Zq�H
��Y�4�хXzlE:|Q1����*��5����A�ľ�j;�Y�����'aV1k�NQ�\���c�E�l�,��KB�y&��quāYK�Y
�h������@d�JM���Rz[b�9(���"c��q*�����sܔF����������4�(u��'3����մ�ň�Z��E�2/K6%f��CC?F���!��W=ȣYId 5�J�|�.����3���q��4��Ų�C��X�m�r��D��%f�"ݷBC���qV 父oQ�:��T�(�ŢMpO"e���L\��^��ŢU�i B����[ZL�Ȱ�썈p��D��L)�}`�` �2���U{�Sr�p�H�����Pk�nv����E��P���¡Mj~H�XƖ	�j�cb*k���l    ����L};ǟ3��3~�O/�+�v�J4�.Ui�t�0u�B���$җ����^Ę$�u?:�T30j<^�*f�b�W�a�l+$1�d��:��Q���/F��< <���M���;!�o#!p�u�1�'��A�P�9��&1�����G"��@���yO�+���E���)� �Cc@��#�+�*�.��7fX�B%z\Jج*f�d@<Blj0�j�Z%2铋0��_�2��%ž��N��_E';����լ�����k����:��]Ll��p�u��3	��t?Z1x�]p�_I~�/Y� E::1�fcĢ1�-b�y�k%87�L��M o��Z�h	����������lih���;�:��W�&�RJ��p̾BV�i���:�y�Tɯ)r�ƺ<vsb%�.&�X��#�wU��۲y�b���o�u�#��c2806���\0��5���y��!ט��=�a�H�x������`;0[�jԃ��
(��EĒ9Т��M��:gm��j�>N�I���m@�-.U��P
���m"1V�KZ��G��֣��P\X�ZX3�+�I�����L;�9<�(�����EDэR�q�E!����M&'I�.$s`?�>&�G+n
�������qP1�0�鬱ʯ�;�ܨZ�U�c����$�`��>ޗ�X�~{����[jޝؙ��T��?_��L>����݉�_��V^�b?�J��)S��Ql��y��w��)��Ec��?������E��w�4���ϟO�_�~���h�;�<��e�e�êb�,ͳ��n11�{0R�X;�o)Mh�N`��;��킜]DL�}NC���р~���B�6�C�kq<"`vS�f+�XJ;�0�j8�Y�db����@eV1[�#2c</����.0��}����%l�FW��ZG��)îC��s�J�Č�	.�t����T�Z��*fq�*V�s�������9A/s�2���l��		�؏�(31�wo�1-&��cy �d1��CLY� ��N�q������."�Xx�.	���3�����h��Cfs8:�1�N" q�T:{k�;��P.G:V��L7[cxc(!�fέ��
��X8W6�a�4)�IP1kIB��.x� �����+���x�9q$�L��)x�֥����K�y��Dt�nsIr�����p78;b-��j���fT̡�u�������=�� �v�)x ������޿�#.��o�7*��#0҅�ղ,8�\��-���!�����8�Xv��Īoeb<��s'm{�T�#3mB������W1����p�,@��.k� 0f���
�������
LdX�LT:KԞw��1!���ob�[������YU�|�L┭�.�s��<�� �{�Zv�,��a[0��XI�H��>F��B���)�{���B�3��j1"��*�̢]`T�V�Gp�`;��?����h�*�N:�Q7΃� �>/ v�0�BHx\�0c�6Y(0�IP1�d���(�_�p4-�êb�T��;�=a�b�s`Y� 0��g/��#�N��#j����ˋ:�ߠ�N o��n�3���%}��5��\JJ�ಬu��+p����%@ƫ���R�v8�;Ĳ�E�:�Lp,(���{�UŚ�=t��>:fiNh�wQy\Z�sCy>��I���iȚ�0�.����)��)��aS�HC�P�!� �H6�� �䴓�JYk���xC�����K��L�A`�*��X#S�U�ǃUV��C'OW[�5��R�h���i��<����cO sX����`�sxT1�@�l��4#�>�âbġ렓n���ฝ+=�1������@pvB�a҆h���$��@4�˺��ib�&��,=�o��3��A	�.2�SB����	kM�T%��Ujl����=�bb�tp�x�*�i �M��_/M��P��l�X��M<������QG�i+���Λs���OQ3���EoL	k�z�_*V�깷Z�������W�3�4x��
M�ɐ��Dcg6?P��Q���Uo�%��_��J�ՐbOˀ���^��a�I3�kT1�֛,�\T
�O��Y�>O����bb��8��U��K9蟥E㣟%�M+�S�T����������J�)T�Cv�
�V�4��FQ�yQ�ꤨ%6gv�����@��3 $f���(�.��GGX�PL�b��d��U���;�YP��f�$�JY};/��#�/�IŬ�b$��Z}Ll�b�ǀ=ky�����g"0�� �������MO��l@+�bDx���Ap���͍�h	��/*f[����Ll�<�Ü;3��o���sg��1��4�X�V��GKM�4�P�Ji]*��u���z�Mx��T��2�.&6�-�#0V�<�sf�K̸Pi/tau11-��*z�G;��Mj$'J#cM�0�X�Z>L���E�X���X�\q�<fqaּk'�5pi1��]��Z-��&�8�k�c�Y���p��+��,���T�]�/��K�灺Kz~��m�`�`msxEL&�bLe��plm[�ۖ�A�ߵ�֑k4��Q�l�Q6��FD3ɞ#.�):./�,_3����h�o���m����MR�̸ԺP�E��
�B9����F]T�&<6�h��=��!+/v�	iX��<]$l�i��������/q�V\b��+�8[�e��9��P���)[���E'0�W [!����uT1�W��X��C�d�7��B.*��	����ئ�� ��.Xo�䰒��ϴ�d}޻��U��V����P7��������R}l�a�>fA�㍹k�c-����	�gَ��������1���`�Pk��^d>h�M��f��{(A�J���=ZAO�"�su�$��f�v�ӗ�?%>��cc�v8��1V����*YD˖Ex�T�:0S(��|�:�(����$f\3"�_?�b����Wv��[����.:�4`B�5s�K2s|��^3&��,�s�������+4u�1ީ*�єG1`zrc2!2�0FP��������>O\t��I����6�<@&n��L\K'��Ln�D1�dD��b,���=�7�- Jx8���νqU1kJ�2�,5��l�]��A�Ǉ�T���L����8����B�����uQ1��Mx����V2I?�����R쑌�jP1�C�e�FI�ᙫҔ���q����P��x��U��dѦwͬ�^��8��wN�R�p.�U�%>&z��m��I�I<�\�������'���"b1p4��h�*֩���5b�����)[iU1�maQ1X��5�m�r������	1�۝�g� !�!1C�<MkD���٬K���g�����),fF�����c�p��'0s&)���>*�L&N�"1�"��H�<��R��4����;�b0�^����#�#A��}$B$x$ԷV2Z�=�q'1����3q��rz��E�>������ר��}0����5���NӬb��39�bS:��W�����eđ�[�<��Wk4��ӫ�ǃjԄ�B
L˳&F:��څ���n^���|1"���A����0s�q`�Hq�i�T�f�����9Pɣ�b�^���HQkp2"0���� ���Y�*$WT�Zg�`���ow��"a�x�<I �J&)@4)A�v���۰����I���GF���[��B҆u*��9�A���b�2"&��G5tI��Fퟖ�k��a�x������B0N%��8ʷ��>����λ�,u��߸,E�	T���돷/���SC� L�����@N��J°�e���]LL��m�����Q�{L�j.�(UVH���Ԟ��;2;1��'�~
����a!������pa��w�]fy�P;�3�bb*@�<��ix�B�}T�d�x��屏Ŧ&[���@���mpa���_Z��c�����>��4�1�>�a���^3���B����=�c)��A���s��[l{-&��=�c ��\ʵDW�R��9��Z���=�G�\nQi�-"��    zǆ����>�T��ِ���3��r����0��[U�^?�s�I�J%�r�!*ֱyX^���E�#3Rq��"i3�E��S�aI!���j���g�S��.*}���v�S��Oy4�V)gx8�挡����4����(�u����)s��p��8�D�����	��4߃����G�Ua<,=>[<��@b��y�֒��<m�2���˒Z(�E�`c�������u�3U1_�U�����`*l 4H͚Hrw�IŌ����v1�s�:k	���3���:J�bI�c*!k�1���x��L�heaXH��K^;�b��l�,1�Ǻ��������ܐ��D�ŕ�,щVve90����D�֙H}q�YS��Pp��Gߍ&��n4Yp��Hغ�Sj�R��90��!KY�c����G����b`.wlpQr���\�JW���9�D"2��h]�����)tzX�kwU�u�
�E���5�j]�P-fb�4��i�0�4e�Kt�oR�Zbʦ�G���K"��(�6��fk��~�<�n�4��E�yߊ�,\�����A�;��s�O�Uڣ������_�^����/O/_��ｯ�ڧ��F&�歞�#���T�{�X4��<I-VO�/�c���
�&�7¡6�1�`b2)�g}�ė2#�����=F_T̔��xe��Ws���b��0�eT��Fu*f�^��Vt��:�mI�$k�(1C�5솈4LeVVQ�#��ݤh�N��W`����f�S�}���g����o�����1�]`��~O��ӹ*�U���R��E�Z���a�E6h<�����eT㐣S1�����!� �� �R[��藲��V��m��e�����M��X��"��
h�8\��uԘ��y҅�v�H$���bc{_��̈́祊+-EE��z����B�ͤb6{��lWu��d����5e��Yd�%�AsK��T��l��k�4�q�2>f�W��=�k��Ɂ�����]<�nE��|d��aH��~V1V�6�K(`�����e����֭E�Z��`�l����يjY$��Zj�ZƔN�#�
wi�tLIC2IC��L��*U�:��&�M�9<�̲.&��+��Q��U�l�G����շ�ŖUF
�\-:�I1�W���E9�G�<Zݻ�����uc�_C����vfzˮ��:�J����.�kQK���<X����Z��J� ���� K�3��ĿBFM%f�Ā�&�ݻ��� !�H�Q�=Ak�VX��B�qG<=��)���	]�����������җɥ��\�~2�bL�t��A��^�lY0��I������[�5$���I��s�I!p�8�2�*��!������Y[� �� �E�L��#�vQ��S���L���E+�>���1�b�l!�-1��=l�5��P�{��T��9y���u\<85��4uj��>2�ܠbI�jP�J�
����Ѭ7�Y��x�����n�B+qmT:>S��T�c����.��%'ʂsz��L��ݲUL3V��w0��5]�[���rXU*dc��+�CűΕ�b�c�U��50[A-�.*F'brq4�|��ˢj����2Ƽ�aU1�[�>]#��qq�����"��8�%�m*F%������5�q&�X���]�a�e�O�5#�2���e�E��#D�'����)V�D�3fV��	=�k�bb���c��fbev?	�!5I�Pw���1mFJi�^u���s{��E	�ƥ�XE�b�K7�ؼ���f�x�cru�c�?��YQfy¤b�zO��."�zON����E����O:�+%/���;��6�%�#k�7VE�B[`�He%�I�����+��u�8�Ǌ����j�|S1Xus�ό�GwQ�lFv�FWP1�ۀh$���B��"�sa<��t��j�� �19�<����,xek���X��qbk�-~�tB��/0[�m�u*���"6_y��^.� �fK5�����>?G�g��*k��?�|��_���w1���Cww�h:�/.3:b�m�Y��x�Y�V`#���D+������H�i��*f�ֽ�:��rKb]:bPb&C�����TH��V�	�ȫ,.�V%c���m��^Ō);D?���o��<�a��b���nd�=[_���eY����`n"b�e��~�L.����)��IE);�1�qP1R�J���5�-����>9N��Y�k���.ܾ0�	�]�y�����uMQ�XT��u%����,��|�T;��"�;�YR�4��c��}��\M�(���#��gE�"�`�G�b�1fz}�C,�P��h���L@p���c-!�4�z�$���n"}p٪I�^6��g؍���X^|�YK����
��2��P-N��bb�s��ţ3#�FL�LD�-;?���Ӊ�dQ��b�+�Gr*f�L�AYb�U��I;)/q�0����b��*f�Ӄ<F,�P��1��e��:��g���"cz[p�^'���ɒ֭Ƽ�?f��a�dv�;�|~��������2~���ǿ~����{cq�����.:6��#�"�JuqHњ\����4XW��$^�0�aFy��4U8	�ŋ'fGcٝ �n����ќ��L����2iHlX�Μ���u�ә`�Ċ��]�[?l��ࢯ"1j��]^�#��������v�1�iA"����N�l��dʡě*y�uF��i�
���=������d<�֨��N���נ��qG�]���dB��=f�I����|�ɦb���xX
�Z</ c�X[��^��Uâb��Id�����3�Q4�>1c���w �����'4��BEd������,)�2T
��C5\�dQ1x�\�4̰\���-�ݘ�Z�\i|�%vLE�b��,��c���c����hԎU����HJw��z��g낛�V{'��O�a�y�
DYB}��v.�;�.yN��Q	��=%p4�>��XK�X@0��A�%��P�Q�ra����΢�"C�j�@v[�\�T�춋J�T7N��m�	a瞮�C?�*�X������>��ύ�X�I����+n{�<��p����"bJ�d�C�2��lE�ۅ��Xn��j4�XR6�y!<��o棊u�4�fo�ø��k�UŬ�&ȃT=�F�Q>��nT1ҷ|�!x���'3�8p&5���;�bn���\�"F�����v��y�}c_�k�*�15�-#�<���!K�X�i�65Xll�k�c��sU[5+�U���L�p����o1�f��u$_k��LN�#�65V&4�7�?��z�-�fq���'��7�D�2�>"ͤ���ڹ-Mn�����{H��~I=���%G��=����] �,ȵ�P��Z��h|b�`"+_0�h����<�'�|	�z]�`'��p$?}���������g	^�2�"q����Ñ�u���7�j<�G)�ౚ�$���-/���Y���d��M�,	 ��?Ԃ��(n�cic�:L��RAwgu-�9@Je�c�i;���Bޔf��wĴ�6�g��|44�jlu�Y�s���C��R0"d%����M���z��!�
�9&O��u�F;ܓƅM�����*�l�V����M=[ �JDҚ��û�e�<�W7�
���6{1�-�������ѹ�d��h���ϸ*F,T�Ш��0�@�5?Q�b�'�]6y��l�0�"��7$݄!sa�RW-���a:x�a��.��t�5x��s�E�� ʵ�jڴs�pL����m,�m8ca#2'�¢��TaA0vm�9S�~�M�5�[���QС�y����7�}]��ijoڸD*FO��Igu�}����--a��oP�p4Ŗ�6�F?���?�0^]��$�1�M�U�9�P2�T�7s�RoڴJ���AP�֐�h0m�V�X�*4�8�ZA��T��/�Í2D��~	�NCRc����6���X���e���~7mB#�� hӦ�F�#�R���!%bpl1m��R\u�P����V�@8v8�ah�j?ٲ;|���    &��
˚_�&�pe�c��Y��o�.Ź
��.�6t8��5���6k����
�v�o�����A��5�0ɏ�[J���yx����eH���Q	G����;��,����H��iӟL,�$8ⓡ0�願�����uu.�� �궙l�/�碄/��B�wf6ʷ����<�k	��B�o�M+n�J�d���I�\I1�VA�&Wi�]��c��'�e���� GY�!�7_*�&���Dz�T.l�_6Bos�� ��%l^�8v~{G�8��H�q������{U,x&2���i#�$�	[��KB��j?0�~!��R���b�Syo+m�)��M8�;�e�S|'�H�=��̛��¦�t\A���z�a�т���-$-uO�'-�p�*5�@�8U�� ���i�� 0Ǵ����,�^�/���zZ\�y���h/�H�E�ܾ~�`����#?��	�C������z�S��C�,�ĉ��IX�D,(� |�;_�v�06)u�L�-j����Z&�6P�OSk�aw�FK8��JHa��¿��b~<��>��wRj�1�2�Ms��g���h)lC�gpȌ���`D�3��Q�Hm3�pK���i�Ԗ�G\��hG΁rp�ByT#fK�g^�cIT��U�>����9�$���!C��r8d�7i�)6Ui��&NQf)@��"�'!ƴd����3g0��d���5��E�A��`}��#Ϥt3�T�Z�A��v� wldG�P�B8�:>��I'Cq�6u>���>�Q�d�<9�&���C�y#s̼�PN��9JU�������!3 ������qLǊ���3��8V�&xw�*��x2=��j.�tO���'�;��kO����X��dA1NO��Po�8��6��ɓ�a�d�Q��=��A)Y��#ns
K���qX3��ա��r{�Ɋ��sT�[M�H\���D����ބ��R�׃�����i����eCaA���p��͕nfФ�a5�洉�pbw>L&-h��	l����� ��c@�؋e%σV�p|�^;mr;�B2}��
�̦M<�H~q�'���=���'��J�M��#�u���M���:�6���g�ص�n�d$A�ÐV����y
����p�pg�\+��M���L��{3UX,�U�\=V����2$pC�����6����x_�	�-�H�5�>�A���&�;2M���ڒ��7m��g��m�ȆP��O�X;�u^0;־���15mz9��p5��v�A�骣�a&o����V�A8���։`��V���B�CM�x%�J-���B�����#%�:0r���x(:tډ���E
�s���rsϲ�6��7/nZ]ֻ ��N��=-��1��Ӯ:X?��>���{���ɟ۴�Ҧ6��6�h]a855�s��y|���֬>mzj
�"�Cm�DMM1�f��Q��0V�֎(���|���/_~��ˇJ31Ͷ��:���b�x};�K�Y ����b���E��T.<o�MN��7��6s���^���\�V�Rc�Ó3�N(4���6�'��<f�`d?��7f�e�J&�ɴ����tt!�h�/簦`�QP�र�q���
ͻs��ֹ�o�b2�z�X��c4ڛ�8�Ȓ1�ï�R��&�rLx��q�C �(Ƙ=��W���-oʅM-m"�b�8�bڴ��8Ȝ���/�-�&�Q؈�T�zKPWwlq��1܌�+`�x���gۈ�	��zDS���M�s=��9�	�?C:Α��󟃻L(l�,���������(;;�f�v%��|�b#��ia�N��T�)�|}�{~�/Ք��(�-M��px"U*�Z�|=�$ۘ�;��8�l�/�Ҧ���őd������6��ʝa��i�|7��ħ"&MS�����OacIӀ5�vX�3��|x��p��4�`�DN�:�U��*ax����;�����=��p,����]�~�j]�l����d���8���j�K�&V���p�E#�*�;�r�<'�^��6j�0~d2겑���ǳ��Vp�M}yW����@y�Ŵi//��طj������+m�&���B;�"���p5�������iS�;��%�H�-�F�lfRj��R�w�6��CJ�	u�DsS:v��G���dqX�{rd~�]����Ŵq%D�����Y]UB��q�_:��F��ٙ��~i��=�C0�GB0��Qc��r�fiPdaXx���i@��H��T��sԊsδu�֯n0�ޡu��H�48���Xm K�b,�M{�q���D�6 F�6$tX�+��`IYl	D�{o]|�H6���e��Q�A�U���!s�n7��&vx�x>���h���dm#/��LÕ������� �����KO�~��0�Pa��ēj䝼!�t����L�'V_M�Z�9b��7A)L��y��+3�"���BC�Pr�����9��G0�_��rT[j��b��.�����:I�&]�qf��g��.���lS�8�,"�g�g�����k�ô�#��<Q	)�mUwR��;�&F��m/F�; b��0Ϥ�܊��_��F��c�3T��-]]ڶ�^��\W�a�D�ِVcT�_ny��F%X�Bl���
�M�}��\'���R��,mS.q�\��PħB@H��sľ.��6qq��(��V��8HߚGs�Y��&��oCX&�@)H�� ��"S�+P>ҟ=2���J1��l�X�I!��`�{>g�q�e���M���b(��6I�k�ٴɪ,PUy&���Pr�`�{�M���)�٬G�V2�SfC���L�LB ���K?K���Z �d^�V?�{�{yO܇���c���cx�(�{ji��XW��H)ljx"C�`} �M���bJ0���N0�jp�Lx"x�+��~�h!
��4�Xr���w0���W�bS�>���͉�&��u�E�#;��9&�n�����ƣ�q�X���8�v�յD��D��R-Hcꗵ̊�6]�,^����ҁ��Y0ƴ�5��H?�6R��6}\_,k��K'~�C:�;�	���蔹�)�v��+
��m�]598O+�k�Y�P��e�X�(���5:0#m���(����u�	[��-�#I�w�M�[���x����'�@2E�A	1��$�"x��oD�Cs�^�r�&oe����w/q��ֽ_ڬ�!/��h��U���i���,E��F-���a7mj�p�X�g�HT�'ȱ��J3 �%5�Z�-�F4�	�t�\�z�&�%�C ���*��}O���Z��z,�i8�<�ف]�c0�I�Ppο�T���b7m�������V�O:��������i��2�������v3mj[S���w@��6���p$�B51;�o
�ML�9x�'11�@���X势��*T���6T�UDW���Z�0mb:Lz��G
�\��oBe���yV�����X���ס|yK[����d����"O�Gc��XTa�L<�Q����C<�W��5�A�"����V�NxG�ގ	7$!*B/�i{M�����oc�.�k$�q0�q`�'ҫr
�i�_�y����n5k^������ܛf3��Pwӆպ�
�fXM?���`�
�}�!xn�@_��:-q���Uڄ/��|��,��ќ@��"R}��8+�V�U�=XfJ��Ȃ%&�$I����f�km��$	t| ׹1���8�@��� m�ߞeLw�&<�d#3_��k��%\�m *2�O����.w
�g�N3��(`�A�c�砟ř6��륳�a�&cr���8<r��]]��X��'�a�ȡ#�\�.�R��$>�c�:��0�&���&6@�4*@�i�	�b9|�9j��)�j�_n��u4p�Q��6�Q�sH�:�wu(��Iٖ�ժ28�Mqn�-n̱�mI��N�q��`
�."��k��[�M-#&I7UD�C��2�4?�KS|���H��	m����tui�v8�ښ#��.s(3jjY��}�IS���zB�i�n��+�����{]��PB�#���2�2x�hI�o=1�    ��8���S&g����m�C���YƵ�5>mj�ņs��x�\�69е�8���W��9�XNF-l�![�7`��qģ��F�7Zf
������T@�!Qm�G�6~[T���i�_p�d��
_�e�\���/į�n]�Z�w�¦ks#�$�H
-��9&���e䰹���N��_m�0�?����,�M��1�����C�V�V�J<�P�$mF����7�k�ЅB��X����:w��U
��:�Y���ߞ9��/'L�Uׁq'��?�����/�N�*�v�`��M���O���\I�^M	(�g� ���M���M8a�4�=ހ��w�6�s����$����;L@v�1��Η���]D��[G�������y�]�.����4@�{������������Ƿ�%�oW�,���߇�6�)�,�S�!ќ"r�l(N]ȈS3�zR�i�q�׫3��(�(v�&��d&�MT/�S}v�Mc_q V;�h1F�1������7�*�(�~�;�M)<-�0�s蕪�]�Fq�i#umO7�C�l� $w��։w�ί#���2d��([����Z�6�f��o�<қݡQ��C���
a��MN�����c��{@��.l=Ջg6�W/ЩD �i�:�	�J6m3�>U�#XK���F��׹����d[���R���>5mLR�g��\9�'�T�r�M|"P{j^vBh������0
�>�	F�7Qη��h�&��lPA p8�6Zr�����J�� ?Ԏ��Û��*3��g�*���ݴ1Y��@* ��8�����1���0h巀1���K�G�Rf'�cM���w����4��6���":C��cP��gWD(%�K���N��"�*P�_!3��mzGbr-��FJ"c�*��́V�MJK�y!sO�z�8�NKfk�Zq|i����յ���x<��=����'�oS�R%y�Y��z���_~����/�^�$��^��H�:�FA7M�n'�#��@4B�uhԷ�8M&�B�P% y�6����k����M�������|	���i0
��͆����Z9�t+n.m��<>��4߫�tW�C�CO ipm�M���[��"^�rV#�����/��D�^�#��=����+t�\|����o���ۯ�3�)'j�q�޾��ŔcqFޥ�d�[!�EX��HV�Ə\��3@�\r�8Ӧd�V(�7�:�1
�ˈTZ�ƙxZ��U�&�n��<܆ � �p򐈔��Z�+�萈�H�����m��"qR'�r��*0?m	��'D=W62<=�N��8&M*#�R�Š�Mlɘ��zd���d3m�3�p��Mc]-�7l&��~�a,��<�7]Y%�~�e
ۈ� ���X,��S�٦�k@�i���H���x��әL���	�5�R�1�>փ��m@É%&E�����0�P�+�m���r����PεR�v�mZ(�s�L��`*������<0V�F=�ߛU�<�jr����@b��&�涪�b�M��gi7�gm�0�6M��s�=;�1�g��ޛ�7�[؄��I��K{T�@)��}�J�����C]���q~Gk�z-��6��%w�0mΟ�2��m0L�g�F$)L{-��69LKPf�s\O��i׈U��#;I�3=p�-/'i���'A�zDl,~�nɖ�&&w,-p�j�TRp:��̦mh����\-�q�M�2��9�PɆ��tt�iS�|ɜ���C$�u�s���Ǜ-��~8��iJQ���*lj<�3A��s,V*��y�,3�y���eyJ����L��W �� �+u8���6�\5e�ܒ>�����Ag,\��H��0,��CG�0~��V� I���Z��{������fkZw��������Q��P��9�ݘm8��%�Q���Ǜ��J2�΍*)�NKYEU�p���ȱJx �ݴi�A�������Ej6m]����?��t�_�8Ӧ�3"i���f�H����glu-+H8X�C4ߓ��l�TN���Iug��=)˗
�Z�~@5�=J2>޽g�/�Ҕa��{ܯ�i�=�g�é3��	��1Nы\���t)�iڌ��1 N��`U�45^ �RE��K��k�DQ�:��;���MϠq�LC>j���l'9m���>�pOO��v�mdFR���a6mlFq�`���Z��sآc�f�@��d�g�F�&K6U9�Q"��Q��R�x����qƴÚ.χO}��¦
B̸K�gڴ����&s(�	�.���_>���'ʄܾ˅M��;�_N(Rk͵�lڤ�8V�6����b�UiSw늇�,��<qc-�����0b�B�Þ�����eOA��%x��j3zo�T�&�&�9�Ӟ��k�����j&t��0����[/i3�T?[���M��)�g�,G�5���ƹ��Zn-K��tX��d7m�������g�b/�襭w��?RfA	���~�t�%��4��0m\��}2��^���Z�Y���_�l}2+q3ֿ�l(mx�،��Pܯ��k��T�����l���/1��fFi^N)ܚv%�<��س�`���p��k�~����6��l� ��kh�y=����aU�{v2����$y4S�~dg���c?�!��������]~=Q\{.e���~��/�	+�2�h3��&]���FU>��'�����N�a���M�_cX��Ǘ�k���o����*���"ۆ����ӞR�_�{�L��uַ�e��b�޹u<_Pc c��fy��>�۽&y�ɴ͗�q��} ~|��o�`>�=}�`S�^�1#UtI�6=�
oeg�Zo#�V/�i�u�0
ik>�Yg��ëP�w��Ao�?�J�b���A_-�0��D��~R�}�3�ZC > �O_���߿}��}������o��N�uh�t�'��=��F.�ʿ�P]끭��x�60���X����_ʪ�ҦT���l�'}ۈ�3-h�XDģ����q�QZ?�a���籞�j�<�M���N������ӧ�1������/�؄'�XU�xR4w�Ӧ&:q3Q�)n����k���S���hXH�r:����ŢK���� ���:�_+m�M���D*�Sz��m
RaS��a��Ω#醬.x)�,�K��e���V��h�p�9{�YSC�Ұ��6����y�XS��H\m2�������;y6�g���Y��6�`wo7�b7q��m��Z����I���b^�6����JS����Π�e�oiS�8���B�k��n���m$TDx�%W�!�s9nx�-����~���!�ecn�Qdy�ݴu~�W��<`p����2s���i��&�\�
�F��Z4���#F�Z��P�Z?���V�P��(�g���d��4=����0�)�I[w�zM�u{�bH�tt�
�"U�È�=�\�>���	�3Bv��ɼ����u�ͪu&$��(*_�0�������~F�a�ʓ����(�f��[ՠ��\C��8�5��&�c0�~o<���M��������y7��{��,v Շ�F�z���,mR����	�����5����ŧM��e��a�ۊ���M{�6^Y/��g36�7?��y������O���o��?����>~���>���??����[�<e�n���� 77��	?V1�{¤3ziy��Ջ�x��&՜���^�Y�	��~oLֹٹ>V25/�C�߬���]�ǀ~���<T#�Ϛ���&�g<L�m~���M��Mx���9	)�q-�r��t���C��p��ޜ7>~3����F���}dl��X{i�H��әG�*����"4q��{4'�VL�m��R�m�ǟ62v;~��6�UN� ��)�ug�ފE���7Q��>�(��������6�%�C"��FiO�8Y��Ҟ�|guy�˹Z��<m���̦Hbߌ%W��3n�B���D�k�Gi�`G��{O��i{E̞I�O���[��m�� zZ���G}���A�y{ �q�#�0-��	@�i�    H7Ese<Rc�n�h pHH�v�b|�����g�3��b��>������k�6|a6\ʵ4a����&vw8(8�`!����y���e;+(ج�i1Q�݆�6�ս��¾��cC����R�{�ީ��o؎}�曜��=
sل_�̳�빚�PнI1�n�������Ѡ�f#W�#��4^i��;���PK�0�M[���+h��݈�H��ʻ9,���}Ⱦv���l� �ϕNZ��(�6��&ק$��x�e#�)��W/wAи�.#y�&V ;��X�����ɫ���l���W-
g�z8�K�� ���0���0Μ�9]%�t�L����)�M۸��J�1��-07����x�L��E���o�}3ǜ(6�OS0mz�3��V��n������w���J*A�7,5KR����*������R^o���l�c9m�_��ϳ�ʷZ�*�]�T6�h��GL����1s�\�
���gC��h~4gKլ�iS��>^��n����i6.�6{�??Hʱټ>��Lo���A
#k�6���͑*l?\��XD?���7m��MYH�T�5|�,�J[�|����h����m�`�1�`��Ae��y���y*!UΦ��Nv5���*O�x���r���tw�g�p�OI��Zb�c C�`qd��ݧ*qV7�:��{g�X�5��;[�&v���M���fN���=���ù����6��HQ+�i?I��j�n����C�5\������[�FJ6�T��}��>�#W��"F�}ʍE�Pi{{x~ˉW����H��ic�q\����/z��#}�Cz8H�9����8�/F��F�7m��6�Ԗ�eܡ������4��8�<O�m`>.���,��GN-?n5mCz�[g#6
��
��8�d�y��o�]F��Y��g�	[��5_�#�*�M��j��Xw���{yRP�9W2S�ꭽ�����sX'/��4�&�������(�'�%�:Z�@C~H�]��K�����۫W�u��q�|'�~�5&.w��m��\cz��.�����>Ak?�)5Ҡe����R,xJi��T(hP��m���EFfe���q�_����#՗\+o�����C�b+��
��.�V׋ӦO�Ԏ~�!����1{=��n_,�4%�����Rl�i�%�g�0��� ��~0��H<ndaS�]8�Y$���A9b`5�O5�����a�p�{і�i�mW]���#���C'l��@�M�m4R6�?��eh
o��/��c�_\m~����C[T�hDvi�/K��ʫ�z��F^�׸�!�Z�@�C|0�VmN13ted����",h��}4*���&��q#δ�t�r0�,����R8T����V�U��t<gQƂ�Vm~�dS3b�n�77��V��i#*�X�2./���,.��!� ����דw�F������0� A��c ��S�`�RDPS ����TY��F����w�X[5�q�񠯡�5�B�A�V�d���f�-�U��iV���nڤY匃��4{72�$�F��P�y�ô�����M�-�T��f<��m{���0�<}SV�P���}�T'���`Np��F�9�C��k�jJۛ����>��uۇ�@�!��UL���%��T�_�E*�#���3�]��u�N,Kh�:}�v�1ת޴i��q��,� �����?}�ՐU��}��˲���>�c�V�˘�N5�Y���s7��g���a{�F�l�;v��&,�qϟ��BѳQڄ��
}���/o�,�$�w��6�8�*�E:ήU�i�vVC������_�$6>�������m�s �`�c�#8���񭑆�w�yx=z4+�����2�[�����+̏,�"���Qx ��뉵1�o/l�D��T���pȑ	���<��28��wO7x����j?���
>~���o_����<�1�@0]0����3��d3�����6 ��x��Q�F�����]���]���RV�w0+="�>	ƪ*�Լ�n5��MV���ڳx�Zo�8����iS�z~��4��H���Q�����U��P���~8)U��2��דp���l����`d�n+n��5Jj�,*\K�^��aIkF�ݺ!�LDT��e
^��w�7H��T����m(�Mm_��gbQ�;^�zӦUw`�e&��"��X��a���5�E��]�}��M��q�f��xӫ�`~B��{/�K�����_�x��9�e�7W?y�w�Z�H5�6�w��"T��@�J>ʱ��Iת��V���I�E�\M��0�?k��bK~gr���$I_6�#٤$)� �A���Y��F:V�TZ_xu�9t8l��M���@�X��ފ�D�e�Vi�w���˰�b�Do��~"�G�w�w��i3m�H���t7�,���{��.���Ƙ�Z�E��_�l�4�q%"�P#�=���n�|-��B�6"(qM$�b���\VB�6V��1& �N���V�CAHu�Ң��e]��[ u`	, ���l�n���٪�Ϲj�
��;�l��(g��P)	�8V-���k�Y�P&:J[/w[���ʘ�#���δ�>C�a��\�<��n�����X(��8���ȖEX_R��c�*�7����V�DM�O�~����?�4��%,f�Q!S���t�6��5$�����Y]K�2�O�Z�����M��p���TC�k��9G��� }�p�u�1h4a|<�G�(i,�o��"�f�֧V���)����];�o�2G c%�D!��:Rh�rl��k�WR2�ڑ6�0���-b(������X>O�i�L%G�������y��P��&�L;,R<�C�5K2�Y��Vv����f�	u�%$�����h�<���H���Ba�k @�UBQߡ�h�r��T����V{i8�-?W�x�"��gZ]�QdR&���o�Q�o�*�� �f2mj��O,R\�Zu6mZ���{G\uN�Sδ�7����E���H7��\�m�ٛ6���#U�tP��
B=��}N���}���T�밀�2D��z����x��Y�6m�hEJ�w@�?� �0ֆ���z�f�\H�PfE��b �)���s�E��O��A����
��$���à�r��|�k�>��|)[�ԺL\iY�K%ъ0G�H"�ު�;�o��5 �hQȱ>���b}�W]\=�$p�l� ��[Ρ���8~`�8�#��&�?��Ŵd8��]`0rv�������[)Y�d"'��5����cL����?V��G��6Ṝ����W�4R^�r��ؼ����6�^�o�+� (�i�(: ���1��\����[�2�.�.j.�B=��>��մ�׏,`�I�*�]��mk���V��9@?��;귗b9�#U�ut2�!���<m�B'�V\�	 �)�
����⨮x��4�{5mڨ.�z�HĘ1�b���l�#V�U_�Ӧ����J��A8F����c��V�4��9���K�>���D��5I]e�JM��fI�vǽ��a{�a�M���G!f�郐�����n�6�u�`�ԙ�$���n�H��$�	EM0��MHvPԀ$Q��'b_�0���'������ܜ�>5ͦM�J:RND�?�w=ǿ�)��6U��D�<N���%�ΞM���{~~�,�ģ~��δi�A�ao�� ���=]Z�I_J�R��i�ۓ���h��H?�e,��/@Cj�4� ����|�ɴ���� �b���� ��<�3�3�ۡk���}u�w	f�m�������1:`&u� �s4B����K�.L�渰\�WG�=�x6�6կ��;�E�+��Wb��[p�~�}��VX��dbb�R�����=�,] F�<�Mn��(>IK��RS*���{h�YM�|.�c9i�z}M�6�P�s���Cc'��������Rڔ�?cP���AM�cYG�\�{ӦꨰG�Q�h:*��8nM>lIC`��{ }5���âf����C8<�&��ۗ�ߚ�W���2I����!�\�q��WSW[    ���>����gQ+��ViL8bh��W��F��0-<�-J��hk�f	 а5���S}qk�,�iBU2~�:�SX�Á�*���l�I�}˓'2*�c!H����a�(~wS=+lj^j%=հ|�xӦ��Z�|�웒Fa#c�v��̒�ť�:�#].>�=U`�.��� C�C��b�S[�1h߿γP��;�t�<#\�!y|�������0]��bE8�)�Ŋy�ݴ�Ŋ�W�P�n��JV`��)J��䪍F������v��1/AN���i7߃�U�ᴩm��qH�iӮH���o�=O�:�T��c�6�����p�-�k������2��0]�7q�ɉ+�]^8�iEL\q5q�@~$qա�W���W$a�T|���P��d�I$�fG I�F�mZ$�p��ߨ��kU3w����)Lx�H��s����ᮢR�~&W���ĈB�+=��6�����
�& ș6ى�(������@�9-��nz>m�W��7�4��Ŏ�U�/x�iŎ�c�˫6��lS��W-���$�q�9��"~���"�B�s��M!y���r�Si�TPhb�+c JE{CQ�����C���7j����5�:n�"י6�"G�P����6ME��a&(���%(D(1�E��b���冼*��c�	�!ٽV����s[���yjr7ɦ�%w�u��{�D���۴��XDW���6Q�}�чrDjs"��x6�!�e�ô19SV�;�V׊8G�</O�p����c���96��Ec��*�y�X�ۑP��޸��,�A9�I�n<�,�m���cѴ �H�`�[!A9�̏C3�u|崍ݙ�4sX�A�$�����iSP
���h�B�q�q�#�m���	���`fQ"r��Jp��p݄��$�9�6Z:��}�k-/6yu@��!�nM�f�~�F��&�}ĽY�<���l��SE<n�`�l0GQ��y�ٴ���l��"����S�{:]�����_O���|��vc9��q��(��Dmla�3Q�Z=��4�]��B޴I�4����T��$�M���s6�g�"��D����$�p��lO�8�5���d(�@��˽|Mc$ů������s�U�{��ݩ��q�XS��#��ӗ�L�{|�p�
�ګ�u�8۴��a�Y�0�4�D��:�ڇ��˾l��"F��~hu��8V|ͱޓ���l�5��"��,�8�˒l���@����_�G�K�6�,��.�C7 ����{>��e�c�S���Aɶ��v'>�9��tc�?2z���[��1�Ia�y����+�'.�p�^�}�1�A��˫�����d����iaS5Q�)�8L>F"v��X����`�̼���6�*�{Ի(۸�F)�w�(���J�a+6�KZӅ�ݧ�I������B5NL���P���y���uחG9��ٹ{O3V�q3�	�}��i�<��f*Zݛ6y+0���?�S-��s� �O��&~���V��v�qV,�6��Ѐ�`(�<��9�$���|5P�t��אJ�4�u8�&2�Ajڶ�O��baQ
mY8��8�&�(GlJ[��Z^un��l�����/_���S�*����s~�@��ZC
�1�˛Ty�p{Y�H�����B�z��d�TN���iu8���#�إ�����[�OaSkR�~���H�i�J��v��dv-�|�>zm�2]3�<N���Z��\�&N�����=;Ya7mZ-��</r�6%��0Q�2@��\�m����LC r�C��6y��6:���=�3B<�4s �H��A�a��7����l�Lθ���0��M�F��Ut����H��.C�wQf��__!�~y�M�;���?W]���+�9@�ǘ�v��Z���~���S����e���xeOf���YQc8b����΍k�ة���,l�D�B��H���,�Ȟ�"���xOD���D��"]�vVo�iS[D�)y�~�H4�s�߀1��<�y�i�M)���߀�&���S�D����֥M^��_�ڌQ19�$���8�&���$���h�M�)l�^Y���/ �ʹI{�`,�����1��M�m��q��?8�,�$���
�Bj�Zq��I���Ɉ��E<othu�W�p0��ƫϺMδ��������D�¿�<p/���k)�]$S�,��]d�Z�9����Y_�mL��w/F��Vr����j�����q��Ey�?����Sʡ$��/\��󼪯�H�M�~N�ba�!����0=����i��7m���N�zC$ڛ�9�V����*)q�����Ch��	�{��H�<$�9p��$U@��Y۷�c�=���8G����.w(~�w9�ɐM���y�M�@{ ���8�&���܁����iSd��b���U�i�d;�4k����d��J��;An`N+G��ô��V]����\�6��!��w4~J,���i3��+͵�Q�n�$>N�nvH�u�XL1�����(���>[����u�<�Xa@>O����>����F����j�*/��&��Fu�)�C&	�d��ޞ6U�'��#�"�6�c�Ϥ���Cߐ$����,j�#ђ�����u�۴�¦�,`<�"��	��_�6ҚV���&�@15��@D(�!Jbw��Zy��{��/�z��/l#�4Σ���Jc$�h�'Q��(�6�_�C�C4�R�P3��ߚ?�;�́:�tچ�;�)`��!����XA��^��)2�����ҖCO�-%w�uV�x3�a�9���n]י�0�f�^0�6�+�9��������/�ЉJ^���6����׏^��v�v��|�b�w�^�G�J����ͺ#^g]���
9Cˋ�.��^����s��	���u*�ϟm��8H�8U�q��]ب�VY� j�//U_�ML�"Zߢ$�J��69�-T�C�� Ȋ;u�\N�ԁ�Ӧf��4�Ȣf���U�ZV�Q�PV)������c��k_OV2+��+��� Cr ����gs�>�o*b��@W\R�g~-.@ѭn�I���nS7�R��y�U`�ݴi�,±�sY�8yo�n��MM_q5}�H���m�3i��X/X�\O�Z�p5�
���V�G8Nз�ƴjp�Mzr5��@��g���1�y �����]�=9mj΂���D%�r��e�PD%2/�)ے�R}�e�A��4��1����jڴ9����~Ɖs��i{	�|��%�6�}����~���O����|�lH?`1�v�2\m)n��ҧM<`7��c ��0�U�+n�/���m,��aq����Z�q�l,�RO��d[�9�v�<l03D��9�>d����F��K^��+���)��p�r�o�@�e2�_��SĻ�`�6��+˟6��`v�C��"(Q6$���񡈪���	ɽ�7!wPF{�F���Moܓ=�Z���6��`'���(1�Qb������1gU�ʜ65��YԈ"#�"��#��Ϝ+�����?зߡ�4D��?����6^l��㋧�a;�����δi>4��~)�;Z�Ϥ"�#�J�l�_�*$~�Xz~ǡ<��^�*?mZz�pl���Y�����1u�>��8]K��MLu�D��SE��0r��k����T�:��!8�@��{+f��)/�7�6T�_V�ሩw�!�7K�(�|����h�w�H1hB.	N�i�s��	����&�<Cc?��u�R��4�;����I�XG$,��4ġޓ)
�ƶoӜxW�fE�����52����R�
�l���M�>h�����`ڤ<$�X'�ܱH���˦���(���@���b`�&�'�ͷ�E�mp�-�E�Hbx��n���RE�P�����(��}��9����­悴!<����Ji�kk�h�����l�_[)� m.�e��X.��:,4�_��/�	9}��JW�H����S���_~��׿��ܞi��9F����0rІ0��~�; 9  �;vm�,M�{���FJ�c:��0�V�M���bG�)�D�I�
��*�l$��X֦>ַ��<&]���p����-�i�R)���_�1���}�n��6�#D�}ٺ?�Y�c��>�X����o�^ cP%�����P;l��yol}Ӊ6���}b�lJ0-��һ�,�Ia�R_��C��c�XtYL�ु#闆�x���6���P<Nd8����ReNt�2.�9`{���Sq�}�f�i�(	,�_��[=0�J��_�
 �H�9��b�d���Mb�e����#����8��-�DA6}�X^�(�?�3Y�ъ(�T4@8�i@���a��{�i�KhDOV�|���6���r���4G�>h���M|�k�0ҫ�A����e���6u::=a�3�Z�0m�KApkcu���n7���&��vX�+���fڤ+=㘉�A��&�M̊��+�<F�!�	�$W���j,���l��RQxb_d���:$Zw�*<���Y��i}]'y�SZ�o�Y�M��D��(�t�Z�T6���p���^<�*��V}xsM�m��*����x"�z����_L��\��T�Y?���\�9���h�0��c6Ű�մ��,gQ�ټ�fڴc�qȺoiU��b��ml��r���:4ځ�8�z�?��L�V�6�z�#}|�!������k�X�e+����e����h�B��ܰ�P�z�l��g��1-�	6���pAgu�ǀs����`��72�q��~-�� �}&wa����'��1G
�_�&)x7L���&޴Iv�.�B �i�Ǡ1����[�'9WrQ_&�z��S��tH���s�G��?Z-ۛ[�?Uh���rh����	�h�ʹI����h�1��+w촩7a,ſ�&l�>�a�6E�Iڿ��y�Zi�X��@��׿��{W,����_�L�朒g1�²�� �>�����5\U�_���i�u�Ή�ՍJ�;9"f{�JS��A���ȣpDt�xW�Ro��&8��T1�:� �C�GG.[so�#;��/Wל�n�"kR�e'wS�*l�&��R%+4:F�m[�ሬy�Q��\}bN�Xa�歨� ��M蠘C��P��d%N �N��1 �Tu&�6��}� Pj� ��p�a��Ek�%ǋ#ǋAGkֿN�u~�b��;�Q�C�=�a:kc=gM"��m���tɲ�6E���ۍ�B��#WeS[�Oz6��YRU)'`w
�Ňp�b"7vn��0z[pߊͅ�յ�4� S���d	u2����2xvd׎!t��n�q��1��I��G�ƫ�A
3^�<2����%E�ř66��]���յl'�P�����(��.$��d�t�XL���d���H�'ဣ�Zw$�J���6�+Z����b{��2�޴��͆_[=f�z0m��qu���YcDbn��r�d|}��`��J���t�5�5&f�ٴq�N��3֮��i��c��v��fu�=m���è�[�"�o	H��Wm����<m$�Eu��j
"/��6)�1$E���,�z"¶�0�.E3m��;���9��b#���s������$R�G�O2\g�&WӲUU�i�̕b�<j���h�^�ȼ0����8���jg�����=���l(c�.s�
g[�,��]G�Q19F�P�&����k%O���,RR�D��w��]i5�1�U<��g�8�gA5����~Š��vD��G����q�O�lS6�����������a��b�M��8aW�E��b���Ș�6��X�ו��M�bOA5�hAgΡ�1����ZZ^1�����8��$�k�����г��A4��	lq�h��N�)�Y��E�� ���d�T��1�M��2R��H�q�'�$7���y�����?ɯ��Em��xc d�T�[Ҳn7mXJ��*�B�����Mڱ��A�����U,���Q�8�wA啂i�2�c%�E�7�0�G}%��K�����c0R4�a��y�IqΪ�L��;.������lu͏gDܠ٧i2E�Dr�Ԝ�W��aֈ$�6�!d�i{��j���~���K���c0򵆣��	�_��Xt7m�U�x|����P�c���ėʹ�n�%���	0�6 ;�w�6W���^�>/�z�x"�x�z���6��9�Q�7G00���$�3��x��zm�"�̟��MK�3��^�J⪏��d��X	g�)��ΦM+� lִu��~�eS5)8��v�\u1mZ�� ����0��w��-�	�ŀ �����=���{^S��X6L��M������,R���jʌ�V,���mZ��5��������U���eќ`>�jNs2�`�+�{6��4�Bi�b�v�K���a�jq:�Ҕ�&q�v 0FS��~�����z?Ѥ� 슫	�b����?��&�r��K?���<��}�K�J���1C0Z�!���y������g<����kC RX�ao�.+��.�}���=��E,p�$Z���H͸�#��7?N�u.��e�D���|!�(V���6����	r��ٍ�[�Viv]6�fA4�#�~��$�͢�!�Xw8~`6�;�cۄ�Ө�*yٰc+����@�^�1ԋs�=0�Ԩ}�L�$�a�G�W��1���8gh��ڿ~����Y�g� w�\�������}��ӧ��=wɠ�}G��=eC0h��#MeCڝ�b��wAz{Y��w��[�\��<��,q@h刟6��<�0�Où�c �_�C1F��	"Jo����V���]����Z��D��w�V׮����G���p����.qf��8ml�y@��y.��6�*���7Az?�D���E뵮�/�U�qŤ�eI|��K�u�Az�t�cս��^611�fKn��y�DJLQ�9�t:���i3������)��Y�p�q��`����d����7m��R�Q��񯏯����'���I��z,�ʹl���3	��UG����HI�AZ�����/�?:٦k���0���r}�g�T��{.Zk	�x�����0�UaEo���v����_�c1P�Q��W�A���8���������"�
      �      x�͝�$7��W?E�@��>�_��-Uw�JV���l��9� #<=H���v��6m�"�&�$n|��_�T���(c������?��?�������'����C�g�?u|2�Y�g�QYVO�~���ÿ~~�����=}{���������o����˧�?˿�����Ę���'՚\P-0��w!^�����?�}����o��>}~������;!.�fB �;�fz�iS�kg��&	zi5OC�`<����hnki>�!�\�&���/������ǟ_~{�����?~y���/�^_�x���<����?^�}�\��ep�ٛ-E�	Lm�2c���_���2h�/`�u��e�>��S�g��Gek������ׂ���n���t�y
=e�sX�G>���~{��G�+�ħ��9�ށ2}�ʔ�o|�C=�3��?��ϟ�^>��^��o_�z�\��ϟۊ��-v	�g���%��bQ�í� ��Z7<l�Y��>8�e�Z��zk�P���.��K��/u8O巼)���~�����~���緧߾��~����+�h�Zd�Y��k�ʾ�nd	��o)1�ձ�6�;&rIM1���8K_~/(9`�4��	y���νE�����h~�=[��N��察7���HWěRI'��P��bt�l��	5q���
.W���6���k�˧�/����[�g6o�͸����_"?���z�� � ��UDK��ь�.=ۈ��fy�^n�v�Mx6z3V;�Tb5	�^�o��j^E,������u��7پ�?~~����r��u���2EF,��t�.r�B�-�!k��˗�������r�!h��F�iT6]���p�����l�����j��}���?O����/�?]����T+:n.;���kf
x��a�Z� ���j���f����o/O�-��ӯ_>�����:�wZZLaC�E&���@̔�1\>'w7�.[S3�Q�<��m�P�t�ol��^�,4�->����Iѫg��&���a����-�=kt��YȈ�#�ӫ��w��Vk�㇜�T.g��d'j����+�t����Gw¦}�!��B�A�,�%��M�
o������s�qv
�A�+����<������o�[]��..���\���j�E��w���X_��ЋhFH�]�'��^���BZ���F;�z)�,������	�X�P��E#���M_��+�蟵�ly���_;z��ڹ�I;}:�i�����{� ;�<:NJ�U�%�`�Q�[%1ݻ'�l���2ӯMB8�/�Uv��'����[�*hTyL�γ9_�k�Yq�QșgoQ�U���Q���n:��:M3��,1�QRB�:�_��_��D�::��Uؔ�O�XX��|!��|��pl,���� ���/_��V.*�-ʅII�{M)�_��4�|/"��?�s�	��J��拹�_�K��'��k�8x�*j��X�1�@^��i>�&�B$(K�������U�Z�@�ޔ��3;Ȣ�tʻ���U��돣�������������[��keu����w��M���L呭�Ε�k����#�>uV�.C�*Ǥ�B���o�ecl� �j���!��sdT�{����ǧ?^�����?ߑ��>!e'	�)��>�^�P^������О���{+uz�]���߂�: �r�ٜ���^AY��LNt^�wYI�A'둫�o������7�2*����2m9�����r�ye)O�.+�!�V���`��b)���t�b/zW���7c-��2��	�Nm�)J�c��OHy1p9#=ó�)�;��-�)�YX�F�Q٥��3�T�%�pu��C��h,*�m�^����}�}t��D�jsE���S�����bB`k+[�u�5BD;�W��I�{�V{xh]@e�a���/����ф�������S�3�&�"*�_�WuUΩ�pP�P��zݧ�7�=0O��}VV{�ԠTTV��	(+w@��7�-�LyiR�Y�-�4����ԃ�}6�!�z��Y�z�r�6�փGx��N��1�+X�{T&X�:�w:{$�fig`�W�SS�e�m��Ru�˻�,M��3r�d8?ޖ��GwZ��������������E{��-��>!��z���LT�Ğ*)�og2���bR�}�`}[VeW�M(�u�1%�_�4iH���B$�bƛl�Y�3?����}�>![����eg9vwUI`ʢW�-������f�<mM��I�pKe0b�g�.�[�{J�{�n�f����8���Th�b����)F4��j?���,~�����?^�XnƟ��j�w 4tN�p�C�k~([<����1�����i3�f�e4���ƑQ�BŢ�)+@OLʳ����+W%�����Av媄�
��;c�A���,�X��_�<DD_
 NO��c���>$��'��e'����i����?<���Ҁ���xY/bD�t~��:!��_����x)�l�]��-�a,�NP��v��ǌ�����Ҩ���!'����"�o�nW�A�e�M�EzU{�m@eȮ����Es�>*��i�K6,�9������3�> U��%L߉��V��J����5.V卐�'��VU�h�i/�f�m
�COS��̢2f��n	����v���P�Q�~�S1t2�����OF�d+�%*ޛ+�3��A�U�I
�1B�~~�צuZV�t
�b��r���R.�N��*�\; ����p��14��[��G��3��d����::ڏ����AF'@�ΰ��z��|�l��%YN�@��Qʘ���QI���A!�zP���+oAȪh8��U4=W��@�,� �h6��H�f@��)AE�������Rm�������P|V�����V4�6k|D�e+Q\��Le��۟�񤇞w�b>󔊄Ó4R�X��BJ��a�M~��2ƚ��h*�۔74*�d��W2'C�����ҵ��<�d���fknm�|P��-3ug�H����#�Z�� JZ����ܱhh�}����8�%Icϝ8_^>~���a��t�X��w�b��f�t��F���s+P��e毞�1�We������#d�����>lZ[P�֒���ե�3�܎����Lp;�,z2�\j�r4��hX��UB��8#����#����Z<�[󑵐(&[��A�=T�9����&���n2"�5.!�}�w�q�Oh��6�6���<<��ۛƠʣ��!m�+�G��	6�|˅y����o����巧�������wb�K`�HyƢ�v��þ����u� ^T�ٮ�j�u;m��\b�����6�3*cU�	i�x�����2*[�ݠ0T0�6�Ѹ�Fy��@YqA)��⫄�w�Y�L�������A�_G��Ơ�K�M�ҖSN�2��8c���,��������.�B9hj4��
���_?�~y�������v�l��A맨c|�M���!�-�~A�?^�`P�e��9㵁�!B��?V�9xy*���:��߀�v�B���L�:e	�4�m�t�+�D6|~�#YT��I�W���xa>��{�o՜�Cb���dXhgm��C�W�V3�ΖsD�o5D������e��&d~vyK9'��~ⵢ3*c�@��?�eX��B�n�*�et��|kn�La��J�H����p2re�H�1�G�d�z)�t��nP.s�[9��SJf�����=��5m�Lm��N��S[�F��R������d�l%�P��6s]s/��3�!���"���r;b3�**�̝���\��͸��Ã��́��+2�PSb��Fc.��,b��X�.7�ҨL�rc N����k{S���힍��<�6����VE��$�Ӗ�X	�RD:�j4�s�3��fv-��a�娍��*U4�];�7e!�Ipq�t5�=����y$�6J�ys>)��]�o����p�p�8Hbw������`�/w
z,��-���=��_�08�,T��^�n���
q?{�nf�M��r�u�'��
2J�aL���x(l�����䄾������aLd^��� �yi��6�Kx<5Q��X���    4E�=�t�yN���_�}��/���rG���������r3�`�Ѡ�G�4*;?"q����G�ƻrD8+�="4�#�ZD�9\:"g\`����J�g�˦d�>�2�"��bG-%O�D���ϧ��w`�_����k2��i�9�}����~3���7g\�(=�dW=J���*��j<�y��CwуL�Qb!b��k��k�~�h��P�jƋ��ZNb�X����)(��]�8�d�[���i,�ч�٬�l��o��]ܬ���L�X�U�	'.����j;��נ�+�-`�]+�Kظ-EK��I�3�"C���F ���!�l����-{]�x&�'��kBe찊���"2f���z��4�,�G�-�� ��=|^�%��=�r�tBkƅʘ�|��;�	��
fJo��-Ev���x7���+9F �N�6��c X>Qm����x��'k	���n2^�B�H����tp��,��j��b��e]v�����3H^6�q��^����&[u���,׶�E���t��ɝ�,D�e	q-���<�j����ܗ��e�ᩊ���w�N�\����5���P6���)�J�]՟��ջ��x7t��0%��x�I�_=�Ļ��P�l� �0j�3�+��{��;�ɵy#�1��c�i�T��%F^��s�c)�3D�o1���ʮ䣧:�Hm^%��䌕|t�Z>:OZ磳��耓Q�$]̜hW�h�䲂�X2Έ���34c���T9R���e�k�(͍���g���=jc��N�˸=���Eg]D/%r��x�e�H��8R�$�?�&�ۘs8�hܘڴ��^�s��HFh�ٙ&B�I-��F�����]6u�"M��uz-=P&(�o3�_"czLŌ��'�����"!8ݦ|t��:�q�8��OtsF;|�Q���p�Pi�͵�?�(�Z��~sɥ�^���/1N�ԫ���{Å�k�Z��5��M�զa9���&#�xo	�;{@�8��?2>�oq�ͺ��h��$P�J$-Y������_�H��׹�*�tR�Ѽݜ��8��y���!.j�ލ�^��;p!�e���xp3E�]^��������"c̖�#�_6������9ƇX���:;M2/�K@e���":�G�x6��"oZhk���M�l��9fV�BM�RF����ּA����2^�K�H'��M=@	u�&c��}��0q�Nj¦C����D�5NN�!a�԰�u�Fe�$f��-w�X>�|��V��P�"&:|���f����xQ���k�0]!�H�UH;a��u�N���vWc��]Ư�Hӳ�eǳE5�D%�Q��q�+Bȅf��³��l�6m�#Y��WE��9Rh� ����#2�SDI���e�����+dj�5�P�̧6N����y���-h��F��I'��J:�.C����e��5��3������������v(��[h�hl[딦0�w5�B�\��a��A6q��h����\����ٍr�`,׏��z��*�^���So���z"����7G�h��As�|﮸˘I��MYNI�t�b��eR�]�dY�u�t	!"�0w��5^�&c�>O����tLo?ʸSd��`�o�r9�hPs0���%�Ӭ�w�ĳB̌�x>r1"���(�(~�#��UNd�.��\٣��(���x���h��O��,o!f����L�_b�+m'y`��T5K�&T��5���aB�Φ��ăγ߀2*cٍrD�J����]^I]�����_�)�ŕ�#N���q�a�cDe�{4�5E��q�yV�Sv��k��(����G�t�t +Ϣ2zP����FV�57�R$�2kn��ը[HH?4��c�^n���ͱ-�0۸$��P0�˧b2,g��֙"�E�2?��=l�+�e[b�w�cQ�$!�ʥ�4>&_�$1��%qA�$e�j��z���%�g�Q�ZW�8A����k��̷�1���k����J��	׉|�U໌�>AԵ�2ۤ#���r\'�!��
0] ��c~Czq�q���f�7L��w6hܢ�\�k��Dx�ʙ9|��B&+������t豴y�5޺;���%P^a�Q�I�Y�C���?;��f%��;���%h���h�H@#��%�ӧ�0�|	�W
*C�BD��5��q:6f=a���� ��6k��`�Dw�Hyɕ2��3��k�.[?3�h'~�.�m�L>��2��q�Π���ʉ9!\��kʖ�-M�hs���y+J^v�����5.���#Dm�>nr�8����D-����Cܻ6t^�]���^�B,���5�(��	�D�54�	��>
����Ceo)ѷ��������hz���������v!@�I0?�d&�'�"ȣ��-*�rn�0���/E�M���8�:�q�:	W<|���1�eW<|ӪM'��dz�f�<|��~�w]Berc����y<~�,�3�+�>������v�ɺ�H�W\g�O�K�K{攲� �#��Η]g3�K�3%��Q�}�=q���!���h-���J��`��ް��)����ɩx:��
�l�1��@rϡ��(;;P��&��6��7�l�1�D�f�E�i�YlP���l��Iէ�%c��L�i�$�1�:���$�x��9�ۇ�W�Q�%N�"c�t��h��:͢w`4s��E�9Wk��lxn���+�Y�!����u�d�n4V��|�W�h4�5?��H$���4"E^B��!2������s	�Ee�n���ڱ�nA[��w�LE_bd��B�I]���*���;H�"�+=k����\��1%T��\B	=L�>KW˺-*��,���6[K�q]�3.��RJH�cK���*�-UZ�m����ޙ~�M$�6���D�ii�L�ˡ2�~!&ķ��-�m�}��?��]3s��1�ˮ�9�Q���N�m��f�А�f�G�n��a���9}�^>&�̡9�f�9��hA���k�n@e�K{�����Qc#��x�ĒjQ���&,���n�����������OO/�~/W�矟~{������CSs�Da�J�*1ny�q�#z$������M�+-?E���d�1"%��eTvy%Mڂ���-����J�!%����F�7��砲�o+���ϟ�z�a���s���L��Չ��y��h<vbIo�!���qR�?(luذ ��H��i�$�7�q.&�-dy=p�8�=p���z��fl3�*;��A݀TF�s1a�6���d��%3�,d䎻jD5?��ڌ�E���r���o���Ce�8��Q1q�0^�c���[����b��0�AƐA_DGNL! =*�!:�i�npL�Uw�iV�c��̀7	vݺ�����ʽ%g���%�v2@lP~S�,*��}C���2&h��lN��c���3H�!D�ԏ;�y_Lp�1�N�	j��Y��CS�,�)�x2*c9�Ą�u��\Be�ֱ�����k�8e���'���N>Nl:�.�:�Vk3f��U[|u2r���ɾ��cRڕ�kFekcRUP��01�m'P��a���E���Ĉ��wq5����a�����-:0hƫ��n���>�q����o����闗o�>���Ռ�����g��k�����)�����+�7�E+9\�ǾP��ӟ�&��w{y�q@C��2J��/Sv#�)";�(�t��k�k�>�2z)w�5A�a�oP:)����Qf|<��1ѷ������q�e�����
d������AyT�K#���b�me�o{	�d��`����{�.[���U���!n�8P?�m��Xo���n�,��P�������������_~E	K�G�Ā���rb@ 9����͢�QX����j2�;ƌ!�h}���	���%����O\����]gu�2�,�ֆ3c�7��V̷r�̜�)$+gG��MU��-��T/���n�����;A���Ce��")7�~�y`�IDetjQk�=��lڦ�N�2��zۢɘ38D��١�����.�u(&Ѭ�F�~hL�    �£2^�b!��Y���㮲kd�@M,o�wx˞���>K�W.H"�^� ��rF)� /�=�G���'W�1hx2̱C�'15*�w���?~F&�}����ڣ2f$����J���Qx��@fr,A�"A��Bĳ=��ˬ ��J*@nQ�=v��um;�J�2n%�`��{;����#�8���DA:T��P�!Z��ph�t��mi�Q�>�lo������G�T��"g$j��N���Ǆ�59��F?�jdtc��|��h"�xC�θ8�SRBzX�j<��q?�����'ߣ�[�FET�����&c���t��ߋ�OWN����jpWJxy��r�c*���1t��t�""���Iq���cP���7Ԛ(��ƃ����Y✮�EB��UC/h�P;eT�����7���s�C&��5Jfʨ�+C2}��	#Y��g[�Xx����"S�?x2n��M	�ߨM����crxs$���q'��i_Q�_ z��w���������n6XPM'�3�� ��~E��[=\��AT6�x8����2�q��)�{����PB�f��ͨ�-X[r}ۘ�<��+�`��P��d!�і�7��0h'U�C��V�xTv���XT(�I�f4�ɼ2�2^��q2�� ��Svw|�Y�yH!Y��fFON �s9$�i�6g8C����f�2�T�����Z<� �kk��)�i�8��@�!^���û�,��nG1"�+]B�܎�|&!7�cN�9=�J�2v�3h@�A)��˼c�����22;�����X�Tv��o�m���83����,��d��%HfSe)"�g:E��3�qǉ� #�9�sz/A���I�I�-�yXK�<o��α�k �Xrx������l>����H&�.12��I���!d������xY�H�uD]ڲ�����^�g�5;�^L�_��s���.{��ta��!\�����z�)'A&�hM�!�� ���$�<8���D�DZX���WW*D���f[n��M6��HJ��lB��kN:��y�5!"��`���?a�k�>\�o��''��|;�?���mýh���k��еE�F�j5]@etmѮN8$V���k;F��Xv&=�K|<�G�H��Ĉ��t�����P���&����լ�^�i�I6-�L��К�o�E��&I������3{V�����	��[D�Z��8��`qS&3�C��q;D
 wv������qgǸ��P��No�:��C&kؗ ��X!c���p��o:=d�G�ߊ��pY�=k����P;0��`��[��N���i܋���G�3�0�&l��335���hQh��~�s�	<ݿRM��돯�?�x����˗_~./`]Ǜ����l��ؾ=����!D�ߊ��)%ӹ'b4P�E�%=>��i�09�iI��<صuL���oh&�N�2�<6K�<B��_��s��kٻ�f�)���c���j�@/���=Y�m�y0�y��V�M�e�1E�p'K��q-D����Q�9���[t��$���%�ߢG�E�[<CdǊ���ǘ�A6�#D+t���BS+9�y��#�rUv��.Dc�ܙv���\CD�*TF;S�����צWYY���Y�ȴiČ�e�?���d���X�%�;�]���e�3&�k�ml|�Od�Ih�朳h5����.��,D!"�$. �J=92Ƴxg�V�Qã��7�b%ꦗH����_c$�����T,>=����Z�h-*[Q��ܟ�;�A[0c�C'�*W���� !⤱/rQ��t��촱�� ���u�SQ�Tƛr �);�*���S�C�W@e��~�Ǎ'�կFm�x����B�'|ܐ���/�#T�%!7{���yTve�ˁ�Z܊\�����?C�n�Q��rfOL�`ٚUnP�<`r�W�!���1�Ws��ӿGM�ͨ�]����ٱ�c+Z'�M�+�Ө�m���>���RA�-� ��\hP��bD�sa�x�� �6��a�с"a*�������{	��	��k�)�k`�<1���=�:��WԼ�%�3����z$ؕ�c b����8���Ub,,i�|X;��΃p�1.�ݽ�YB��@_��<+@�F f����5�u�ɨ�¤V!���^��Q������Fڄz�d7�}'2���B�4��i�������8jvM6�s�-�l{�/����s�,�9!c��H�$���٨l�DD�9���C�и.���E���ZT�3*[U-�#pn�J�[��Z �AerՂ�H�)��E%�ݸ����#7�Ppw�������	�u0d|	��g�!�󁇷.�z2�[QD��3������H�8% -*��8�ʨ�cX�-��fT��J2��B��B�tA�ø����t����q	#!��U�����`0tm͌?"v�����,�RNH�q��i*c�R���nYy�6�5�([��?2M�T�d�fE��h!�l)s�ֹ���[1���>��5fn����=d����D�2��?�퇍�0���M���,O��P^�����N5�Nm�����>G\|�c�t��_����-���I@�K}N���uK�GeW���Dc�5:v��/��sDª��8��*�`m��9M_!d�<�����3L���j�7tP�	_��cBe��"D�U�Q́���2�2������5�u*��YGv$(*c*c2�%e,p��*c��ι��ÿ+cHW�%0�2�CTu�Z�1}o@6T@�@�R�CQ�����o??��Qv�ԷWaA/�C���?�M&���S��"cU�\�xm����q��źBeW����f�E[|-^C$��b :ڨ� �6�q��a�����

�9!��hG֐����)2@:m{��f����2Nd��'����F�JK6;�o:٫� M����"�-V�z���l�'q�h6�-(��9�y�W�!F�^�����.���s[Y�=MW�oFvu�挓}ʖ��S�w٤��BK�9��!H��Q+�M�Hk�CD�bW'��&U�4�-�]��bT9Sv��#G䯞n~6T&X=�R;�	m�7㺴x��Z���z!Bb�3Ic�}����Su�4_D��sB�@����YX���s� ����n��:���|���;��|�RD�O��?��[��үhԲ����?T��n
�r�I'M*��]gO<_vwD����6��f�<�ғ*� y��Q��}��~��D6&"1���{ޠ���Ѫrun�}Ps�I��ͤR}����2[�J��|�����e�		�YݦW%T�<<c����C!�W'$T� g�Q��q��YY�'�r����/����y�]���LY�8�N'\�@^���_�Q�,gF�ˇ��'�dq��g��������������u�1G��l���S�ڬ�O��
8,A��$9"1�n	��hzR�&��9����Nc��Ɗ��=��F��o�bL�;�s��9��V�K>*23;鄑ō�4�Pw��#"$����^Kfm�NQ3$"d��!�%�����g*�tQ߳r��	d��%JfG 1#Q��ĸv/ݠw�NN7��A>�&c��=:HZ�6H��kMi\bewS
AٛJM��1��g����2�$>��vm2^�����h���L6�"d��0����H-��l߃��d ��<e�;XL$��bb!.XL$�;ZL<f��D2�,�s�HO�����H�ʸ�_�IM����N�S�u�HFQ	Ȁ�x��1LV�"[].�ʸ��5�=��kА��dq'(��K��\y!"���nl���/�wp%WD�Cj6�Q��5D��y��� �QjTƝU+Ĥ���p2u2mFel���$��A�*�5�!b���iN�;ށ�5.��ʸHx�m�1҆���ʘ{$��[NF{����1�b6B}�|uX*���L_�W1d�lɺ�5�\����t#��P� ^�B%��Q��R~t�E6�5CԠZUA7io�'��8��_�&[))&%짥E^�n*��    �_��c�to;��>%�GJ��]�n�h؇Z����l�g3��M��a��|
�٢�f
�7����\,GD�|�t�-8����,a^�+\^:{v��m�aP�l*�ж�նM	�׻��%G0��	{���H���c��A�,����UZ��h��H�C�yEBbD� u8(�a��A6/H�sLe���z���х����d��E\��pͦ�5��$J{_�bv�Rݛ"�o�� ���)=�s�%���l6۔\4��,>�*1�Pw�a)���P�8��5X؟��N:�l�lٺ��,��l�rB��'b�L�,o[���g��*��b_�-��~N���N8Ya���u�y�?�l?��7�ቫM~Lܼ*��$��Q2�K!#?4�����2�3L4���#*�a�(ol�	��ؐ����|Fe����U]x�g���3ҫ�N�ML�Q
�Arl:x1^ p����l�7ژ�X9�ڜ�^��N
Ҡ2vk4!"�ZB<����t�S�4�2��NyH�l6��#.��eʷ�cr
W��I,�2^@Z���p�xa��;O����kkˈʘq��'+�[./�3��
���2�����yΟ:"����d<��0�!B6��U~��,�5��䘀^?<�g��T6���V.�x�XS:�2�w[���oZ�3Cf��8��yǅ�d��!!&�E��
�2^B�X�w�έ�[H-�ArS�D����?׹&�xT6{�3r\j�g�跜Y��\��xϵ��\�/<�� <�������qv[+�Jo2���lޥ�V�Zz��%S-3rsuf�Wru��+޸�sE��l�����?c�f�2�"%�K���ZRBZ[��C��%B�8{8"H��X����)��
5D�������-t��+�C��� �-)� (�q�3<��.D�(�������q�Ȇ�~���Ɂ+;�L�K��$2�d��'H>0	�qw��bji�R[TV��`r�$Oq"N"h��6�u=d�aS��J�N����U��:�ghlG�rQaw�:�E���`�ga�MB���
;	&V�y�
�{�y�Iv\Yg0k:�z|jrb��d�Z4D�� �E����	K�� ��m2�{(F�֢�/�orӱ�19"C�F瓹˸ $��[2
����#/�CJȭ �^� �a/Z��a��Av�Zo��.��/�%k���[�<�k�dY�bhE�ƌ7�+���2V�[3(@��E��l(z����_co�4��'z�R{z�J��]�*��Qyk�G�~!Ck� ս���NN�"��x9�IXv��>�|��}���F�^�����oO?}������j��{|��̢��߽�>b�߀�E[���-v��m�#dUQ� ^���P�IF�ܺ:d"*����Եǥ޲�Qc�s�d��'�<�]��z������)ju�e��N��	)?G,ą�D"JN��y2�s!WBo�d�쎡eK�t5�̅���Zr��#+J $���z�Q?X �Ba$I
>.e�Z��0�5N�+LHIר�4��ע�i>>�f!N;|t�%g
��1m!"�T��'�q��A�m#�{���;��2:�0Y^�Ƞ2n[+	�#7A����l����|��h*Q)��݊v����M܈K�'�}Բm��*�2�-IB���g�~�0m��,��e��{A�q�f��*[A@���)�,�b���ܖ@�݃x�+ǧ�������5�����͕�h�y�6:��t��Hϡv�l�]��v�_St�bB�5k�DFQzT�n$f4h��e���}���ӯw%�×������<��-�Ɵ�^����o+���F j��;� ֒�� ��Eĉ�6X6igP���Zh S&����TӖ�=�D��R������a��A�`}a;jK�X�q���K}0�kƹ��EJ�8����R��(�d�Rډ*��KI��v��]�/q�]�F�m|yP���k�6gAe�k���
�hI:�u*�]��:���s%ݲ�ڠ�Vz��$�k��joaـ��������JXdh8�|�� ���M+eт9K][��U��a�M����$�}��MF�!'&���[�-�cC��F���dz��S�8����r�
y�t�6�2n�����3Cт69�rœ9�K����l�5hµ^�YT6E����QcG;��7��V���̥5ȓ;���}���1����g��M��O���7�U9;%���	#�Ϙ�q�>�3R�+ߟ�&��}r�4k6�s����%0n�'!"+m��Bڠ�{��,�~�����.L����&��-T�9�e��@�E�2�|��#iT�rl� ���}���2�JHTg6�>&�����H�󠄌��/��\z�t�q��V�	X�rm��P{�;/uꗲɸ�"$��v���0ۧ9�eL�e@)ad��rJx����%F����<��c*���a�V��	a^U�����[�'B�#0���A6�I��]dE	��r6���O�"M32��u��3��]�cF�dk]7��pp�dм;��]ƙ0vw�dD'��i�m^;����&'�<�1j���dc��ʨ���:����c�Җ����/ҽl����|�8*K`<�q�;7�b�M�Ae'��$��t�;t5����ZMH�(7�BSF)&g2�	�R���x���"�{Nr�DnQTƞh��b�I���"E��MP���ɘ���5�����Dۈ��������P)Mܬ#�/��``������	b�F�*o���Y��m�YUޟo]=��������1=�r����#{������ۅ܁��A._f~(&<�f��G0��:Z�ңD�������/!.v���g�?�^9���,*�v�����*N�q����?C�����˙'�M�w$ByV�}y�q�3����7�`���-�l@���3��t���k�eFe����!؁-���*�H�[�����xnj1"�-�	ⅶ02n�B���"�X�i�V]�����*����0�ͷ���\Cd��	i�st׀W����e�d���q3����A[�&7�d��)	�����]�S��YKO��QQ�~����)x��*���J��phW2�k�<�Q�Bf��<����TNe�%s�pN�P����r-Je]o��e�Q*`KAK:������T4�,J���G�h>y����x=���	�p�Oq�=��=���Ǧɐ����¯I8mE�\d�ud�Ǹ�E~�7:�et���F��
	3]Ő.Rl:T������(��`�\���(?U�Q�O`�1�2�ٰ��8L�_s��5fw�MBͥ-*o��2+^�&�Y�2�<F:��}a�]��ʶ�%��F[�"ȩ�XDe�V�<�I+��n͠�)��f6?��C�L�=�䜥50n+X�$�4d���>�_���'�-U�6ˮ�`��� jZ���T!2�f4�s�췻�)7wCS�u�ۤ6Up��)/�'�!"tj!)��^^�7�.�'e�?6��j��SR�� �x�qDT�5����.��.���4�l��+^z,F-��4�n�[KC�B�7��X�����s�KmX�0�� c��4��[��#~X��K��Y�@vhxkx�/��ѻ�m��/�y��{	i@�����FSް5>�c-G�/b���wp�]YDo6�C��El,�]\�9b��t �`Q��w�1E� %1��_@��p�X���d,�qb� ��s]�}��f���+l�n�ـ��i/O�x��qb�����]��M6�k�ّ��)�l(6f��)�o(g�/�N�.N̪>ލ���v��q�]�ۀ���x��GN-A��y����O���v���Ac��B"6�̌Z��v�"�W����:7�ŕL��UEU@������J� jvznxR5k�8"� ���!�~꒷sB�ݝf��0rl+)a$]&�)]�=�1\&�ZS3�O9��mA�,����k��)뒺��N��䏟_�^������ߟ������ߞ~��������H�v;� ��Uz��d�v������:��2~���	��(C    ԓi�y�l0.��n2f�	v�[�m[��RF-M�x� YY&R�I����2nV�S���O��	�d��;Ѱ�U��ͥ�-C#�(�;�κV�2Ŵ0֪dМA�$��%ȹ�"⢖�T=��ZP�<>�ӳ���]��L�e0g3[zF]BmP{jG������K[��f�[D��X�T"@�l��(oO|�O|�-T���7.	���-��H���ɵ\eY�BD�P��FH����d�ռ;4�0�!ᧇL?Y�d�cbB�Z¯=γ<Ȯ�%Et�J��Z�A�a)���b�"N��ބh�Y�Ee���!�nc!`��I	���'(*c�E��\�.�k ��:Ș�z�CS=h/��5��=d@e,]H����;�w��J���RJ�|��G�d?�,BVA�	��h��G�w���s�w�l�٥�[�V���L���-3�y���#���N/Ts	��\��1���AF�2�y��	ʴ˅�I<V�	�V�8i!�k��'���?;M�m�=L��cڴ�\��^=�s	�WL.D�����������?8Ŭ���7A�8i�/A�r���+�d��P��o�I�����-��M� /}�'��qfax�M5�-*c�;{���d.'��`Z���qfh�5�TS�8Q�O�V�2n�3�	5�R&[4
N�2[��#d��q�]��
_z��Mve0\#��[0*่����d�5��b�%�Sm���uR�Ng�\�Ct�&��iîB�f[��L�v3�i��Y)dd��퀭5�lRWhM��A�j�&y�Z`�af'\,�VH�.�n<�wW�eW��UR�*˛��
u�:f���ԫM�.�SV��;�c��[՟S��A�l5�o�b���UPp�+�"�gGU��?�AƟ�qL�!�oำ�N yʺ�pg87 ��1g8��U��uS{fk�DV=�бˋ����Yy1qT"���9F<�����3�e���Fu�'\@e37*���D�AC�����Z�Q���)��𵕸Aef�C��*��[PA���@ʚ�v��6kd�v��6pjh)f�pS�q_i��҆�A��!J�,����{�e���wF�J��4*���
H4���T���F�Zv	��^�8qN!Prҧ{�e�8m�J�o��i��|�I�$�Q/N+C�3�^��[}�	FmU8��[։fc�<����gz�~�}��IɽxfkȻxd��l��H��?�sM�e&�G�u�a����\�{�ɶ�e��~1�߾�Pͨ�i!-jd�&����z��[k�,AH7�q���Н� [����Imܼ���f}�P�b"NnӲ1����A��_�Om�����U�ِx	�׿R��7gt@��}O��[Yp�9ӳ
�u��'���%�M.c����%\�Ϻ?�M638��T6�rvs��<d�� �u��k�8�����C_K��}��e��q����t���d�\?��5�iRR	ׂH7�#+4"$4��}x(�h�7��8��޵�2D�t�x�R�<�k�<O�QS����U���|��F�5v��x��'�
�U��`6_� ��|����%���BT�};[b�}+D\�3���*��g��
ͨ�u�D��3P���@�duy-�Η�];M�M���C	��b��r�q�#��;�|3�<}�w̄�^x�x��%L^��l%a����1�#��l��D�ɑjR�ݜ2A��6洓P��"R��F�F�N-b�]��G�.�54oѻ��E'�(��zj�����D�q��H2�b�]e4��d4*�t}8��n ���7uLh�'�-(�a-�i�:7P1[D^�B�8ɴ<q����w�z��^��F���}���`��NRl�-e,�Q�`����H١R�zN;��:f������{T�@��֐�ëD��M��N�_ET�A�����)�]Hr۲�:��iR�L�GT�b��Q�f�l�yf��6���~4]h�1V�8ep1�ڊ��!e��6
ԣ2�oN�8l� �n>��k���fi*�Z�\�%F�!$#���Zٺ,����E�yT+3C��*Z%:����3�(�E�2Ƽ�����=��2n�*�r�W6S^s�z��/e���J!"m�*���s�w�BeY�?��.>��{c3�E�	(�E�q�ܰ�2ZL�2�jtM��A2�O�)"ڗX���ҫI���ij[{�ʘ)<��i+����3N Y9<BDM'�w�M|TQ�#*cV6�a<��7LQ�N��0Y^�Hn�"ݥ��7��(�Ee�&�j���׺��4���Ɏ�k`,EH�8��
#��:�A�Lb�0=���)؀]��zoN Y��L�RY,)g*��3���S9��o��V��,L"���t�l�O��8i��Ս�� ��x)yc[�X���H��'N�Ȭ1rr�d-!rh���Pٚ�~��o������zѼn"&�&�!�7J<(�w8�1|��2N���*g@�1-E�Q��,�Xe�q N���o9\n��
� c�>�L�n�-%�Ѯ$�����l}&!���p=m�1�#�d��v�]��=ij�m!�)�I��쿷��ʮN����$���l*�5j���*�T��+C�1u�)��'Dd��@�BQ�Ce����Y�y˵]L��0���@�<TBĉ7�g�;9���za��a�B���nHo�(������w!�x�hQ;9��1��	��xJ� }SK��."��)|�4�d�LP��Zn����M�p����%�������w#���y���"N[y2>��>�r�� |��
��j�p�';WIH�v��W�?�q�0��V3��f�Yi��0�5��l�&��L��c�W/*[I?��>L���E�|�s�=ҕ��i"ڏ �gf��>32H:�9���MDe�zh�!�^Uϙ�Σ�i��ȳF�./�0���3���������0t�j�0�~���0�vMJ��g�����r���!2vs#�Ҫ��^͢J�u=cdv7N"Hù�]l�Ee���ׯZ���pu��A�*4��X%�;�Ge�[!";k���>��VlB5Մά�EB��(�&"N,��%j�39��߭퓡+*��M�"������l�p>L�"bF��8��Q���lj�eOپf#t�0<h�&S�� �}���v��E!.�iUS��	w�%5-��nʃcr���bAMkD�]P��gU�����_�&����g<ւмe��]���-�z�
�_��M����C⹸�a2�ޕ5F�)��*�3F�)#��0�C��+�w��y���C�b��s���l-�9�=�� y��N�N�x7�zWePY;�_�����,���NL��t���E2Z�P�xPN�P�l�7eFƮ^�0&:<�30��� �Z8���4�FTu�Ki��x���}.�Fx������0�x�Q����Ōn�\0ِqVv��g��7�{��:����-�1��W�?�3��ũu��k�����C;L�uF��4i�����ʖ�+1+׾�-2Ӿ2:�C�Gk��c:�.[�xplw�Qn(���:F4���`����ɯbTn~����+D�W0(�'����l�h��G0�b���tX�SLb��d@e�41׺�q��!!��0�!�ܒw٤\��i�a��hM"��K`,�F�X������%����2I"��/��m�x7�%����N[?�:�mQ٤UHY��9�#�\,a�f���#Z\,�9�BR��Q�vprg4��G�"�����}���}tu���e��C��r�[~��Q�	tOAٍ˨���,a�B�rD��ZLkT&�Xg�o��13W>���|�g��u��)&�C�a^�P��y����Mz�{�q,�V�Q�|T�L��6�r��;)���g�@5�bDJ8���+��Z�d���	[4�f��'�zkDe�"Jʂ��P�n��]�v�6������Z��lP�C�<� _�n_�~;Uw�%4Y��/�߯�?�����_蟏d1!�<]W��X��%�L���KXe�%��K4�[��)�P"K   `�y>0)c rp�Q�RVw�l!w�mm��@����D�[v��E���<���1�_d_|`ꈮ�Fj��B�khF���5�sN��-��#d�AM5��1Skq�Ae��6���aQ����>��dV�M!Y�mBD=��|���6?� =�fe:�/B�������X���@c}�;�Ae�2��TY����?�9ȸ=������*h6����|cN(yo��1p�IҭM�q��A�L&�0�S��d��₀�r��@�\�RDv��
�G�d�j�_=�ަ m:��N@LV��	$��@����Q�(�ͨ�;��t�:5�'����}��K�Bܖ�!h�y�Id|�V�/#ݪ�ތ��6
�,�	'�����]{P�5*[�G�*4�U�r&���o�eP�]�h�Ba5U[M�����WoxHF9�¾����C5����&H��X��5�]��0�5�BJ�Ģ�v5\EM&�X��O
:�m�[��x_U~i�U嗅�W~i0���@\��۽P��K��C:���cٵ+����¥~Fh&�1�����3*�N��}̤���q��D�yPr?�#N3{]~�E�2f�*Ҧb6或h%�{l<�:��u�Hh8�E���~���o-��m�M���$��a!/�s̅�BB^:-g�t�S������{T�uIx�Kl���֑�n�wh���0^N�Q�=&��YWc�jT�%�����lCK���qh�Ь?s�HA��fP�~��?;>5n��W�&[@;�0#W�ʹ2n)�P��jo
�;��g�O�l��[I��Tw�Қq�,w$�q��P=�h=8*�qx� �%�*/�.͓�}�%�/�X"��ޅ�9��88L�� z��f�b�:�U����s�]��xe�bĥ�K�Uy��W��_튣⦍�Ծ.,��]<!��3�?R_�]���y�:?�.�~���e)��V�DF���3��mVhY@�����3s���q�m�"B�4�<d���K�2Ǽ�d���nu9���"��`u���͓QZ:$��G��bƣ2i�|��2*
��*;Ԉ!��R�����Y���3`�}ju�-v<�֌Gm���a�#H#*c�<1&�jGMCۻ���n���De�*�e��$\��YhV5	&���/��V��.]:����>\1[�s ����sk2��>�n)�$��A����{;m���H�[v�[�C;i���7L�q�[Dyda�w�6�@����e���6]�����W�W��ɸ�������M{�5zN3E����2DK�TQS+?��dk1ջ�5��Ϧ�;���ɚ�0KLVڂ�J.��fe NB}VT�،ʸ�[f �����44k��%H^���x<�z���ڠi���-���WP���~���O?}������6��b���Z�-:��Ѫ��yP�s��jT�0���A�JT�k���"���\Ts���������U����1���8ܑwS�جUE��-٬���9Sx2��۬�6��Oz�1mV!#��7ƃ=$\�~ϛ���{T�D5a�1{tRx���8��ň�Ռm�*{�Մ,��Ƥ����3�K�y��&=d����H��la���>�F����:R�[�d�M���ʂD�
h�bQٚ�~�2�o
�|fK>h<�a�R�y�Xj,L��FC�-5"]?eabM��r�-��1�1�a��:��dF�+;�,��>���P���q#d	�TL����: �� y2!�d��` �j2*�k&0��d��S�!$k�<�q�׍��n��9��S	�<�y�2���9?�\���u쪽^t���r,x�bb�#W'`9T���}f��P���Tl���\ � g��b����8o��Р;A#QȨ���1�yL��
2�2��)d�k�1�P��>nX�*ۗ���/�y�������^����b:[<%�3��౾F�l,����u�Q�l�pDb>��F@�;G�5L�EZ��\e��� G{�#�P��������Y���B����iz��9�x#�%L^�B���β�^�-q2���4&ǚZol�V*�B<Y�O���dl�GHy��Q������h�6n7�Q�������Qe���bL�%1[^�%!D�������ޡ2n��	ɸ[Q�}�?T҇��+3"�3}F<՞��7�d\?��=ԛt~e ���ArgnHgS�����<*��J&03��2ֺ�����`-A���'��ِ���G�~9�5 ؜�9��7(��{�qM�,*���&��piAo�rV�E{į�4[�����OҘb}��Й5X��\0��3k�ׇ�J�U�[�����0�b[\麒GO�Յ}�2��ׅ]��trA���䂻����aE��X�i�f��xp��G#M�%u���ck�!)�ɉo�'����q��"'D4<*c�gȣK�Q�)D	
�\7Ռ��N��!���y�.�v@ 0���[RY�����.A�Rd�q����mʣ�`���1�X��<�M�����ƸqdT�vc)=������%T���]7H�"hoZ��٘3=�d��%0�� E�D��5 A?~T�t�?�a�8ǭh�N��9r��$� E�S�O��Q�]�tKQ^L	������H�
P����RRĉ��A>6�>���n�ht�5��lU�[KFv?�TFe,�F�H�y��%�gۯe�I���QX(�-���pN�� /�s��om�����)(�Ӷt��-�ָҠ�}5��׃/�0�t�A5�!R�*D��Kx� #��������5      �      x�ܽ�\9r&���|���_T1IF�L�2�Uƞ��R�4W}�Uw����/����q2��.MI��p�De�/~�_�U/η�������P�O��*�"���?I�B��BJ|�B\��߾�����z������B����R�WJ��di�I����}%�+#^x`����o^�����y�����ן�6u��2z������c��F����4������}!T/*�K)2� ���
�Dx�5K�/��/O<����S`���Ǳ%���^X�<�o��R��N0�z�k�Q�3�7w7�o߳P�TZ�Rr���X���#�n��#&
�c)#:[�ł��%��3�w�7��)��+�h:�Ųl�-�����	=W���#[9�I���O�o�_i�)�=�ĳ<-� &13 :��@9�?�́(�J�T2�,���gKЁ���$>���q��|�>�|�ÈzAmF(� ��d�;�D8�������W�?K�%���-�
��S�N���߶���<q��K��	O��1���l}8ߞ&@J��[�@T��ʈleDǳe
OL���DB6%3��z���������~�ן�>���n"B�!X~��l�h�3��0��$�S~ğ3*����q�n߾=π����S���HT��EQ�2:)�$!��R� D.��Y� LbX	�����}e��
<��9�U�; ���|�r��qĿ��_\+�t�:њC��DA4G�0>�ZKR�ŊL��Nq8-L��ڰ8\�C�e�ޯ9����*���v�~�^��̑D�e�xg�/őю�_�Ar=G��6���E�p�Љ�F����6d� N;�Ý�qܞg&D�N�z��o���*K�*+:J��:�0J�4I8�s6$��ɺ�x��������K��a�x�z�f��E$�V$���F�AB�̑�>�O�g�ː�����\�OW�Y)�>�]ѿ1,��@o�
-��,���W���.M
��#D�<y�v[�Y�]�J�l���e���)�x�����~�>�?�ޢ�����"F��u�T�l�u��%�01��'�K
��Q8$rt���9-����]h���:�EY��h�#t�,+�����U���{�2O�=z�,9����ᖗ�	c6��R�$��pD�p�=H��^�aǞ0hNغL��ȝ�  �B�q���|�T�!�g������\�����#�J�=���%y�i��_
�+��Q����'+>���SOV�%��>`<���Q��1~�	@
��bD$�G����o������OaI�E�ӵ����R@x&K��T,a��x��6D�QY�ڲl�����'�{��Lo��+G����]���4b0>لU��e�.պ]6<�����f�9��GpD�+���vl�m�墌@�=��<���Ǩ�
9����$�Rt�a�欏�b��p�6��������+�����B.����̐D$��{d���z˾�~;�>ڑ@A�`���G��mVHV(8B�#<~�F�%1>����Ҟ2� f�����XnYc�rK���t�;;9����z��+�?��[4xV C�$�I����0��Ny��!u:��t;=Y
���:]-ǚCh�a��b.��^�i��{�����89�Nԯ�A�+m����A���/��sO���C|g�@!r��;F���ڌ�����w]�}xa�b��:� [G���u�[�3���[�t�OFG�lZ)�� ]�^�ÄgA�4ƺBb��Y�׺��.���Ad'eb�'�ߢ�"�~
G�0��qģ4<�#2y�r�,���Ҷ�x� �v���P��OE.��em	�]����"j�2��ޯ-@l�r@��.[:@ϱn�����s�����	dH����R�� {Vk�BY�� )�sJ��ru5c
�X*���*��"1%\�����^�'�:�U��=��:��B.�W78KB��4�-��J	�qi�r�.�-U8wz�|t�{���?����-���G�ѳ1�-�t \n+�q@x.a����9?j��G0�+V��V��e�.u�A�����ox+r�1�_ ��"~�BG�X�e[�?�hG���o��Ѳ�)���w�!�tF�eD<.�z J���c�w�Z �ALJ=f�`S�-�ƺZ�@�/��w �8X�gS��E;���/�Ǜ3��"�*-��5��֨iA��~�??Z"��V��+y��C4mч�zw壎!Qf�d��	�u�m�kpk�r$o9�8Q�V����*�ℼ�j��%�k���;a�	wkj��e�����5}EiE�+6�0�.�aNa���m)�d���1('��C7���9r����>L�4cM��]2�	��k��E�����U=�����,9ۉ��Iʇ>
�,�.����9ٲd��(�~��N�O��# s�[4�A��V�:��G���U�oWc����:�}!�G ��GN���`Z�px����z�8��qL|��|���� ��fV��'K�1����,{�����!r��,/JP�Q�Q��A���]����D?.�^��{�!���$���صX.�7�/v����H#�D.!`D29]��L&�!E l,�|d�ʬ2=]� D�@�R�Ǒ����.�8��e�8R��&q�Q�wrV[on����A���mJaz*�`�	�hq������p���r��#8��L0Z��Ŋ��D]�pj�S���eO�|�� +r��-�����Ͽ��_��i>�^�(Kb��'K����ɢ���p�^9���AB�6ku �'�.
�b��w-�E�UC�Vzg��G(D�PN��ܾ=��=�͢b��5+�����,a�X$3`I��|��u�tnD��Kjg��@X��Cd�^__XS�����ꊜ�2��O8,%�z�����l�u��G��U��q�~wp���l&~6��G(���A�P�Aj(���|�B.~���1�<�P*ب�����X���2���]ڍX���(*lѡwm#�I��k(tW�����{zg��MW�����Q(H�������1t��-3J��DV��|z`��[9���e��JNy}�HJ���K��XA> �2\�=�~���v���Ƒ�6���_�t-�Ӕ �'U��!7T�K�������-D�hVp���9B���p�ل�B���"X��~:?\*��ZK	��`'$x�[����L6[AC/�1�q$r����w��D�Ֆ�1��P8a�����堄��� �?r���,˕�P&"�D��9�ދ֩���N�a1���f�Rl¬�\�Ǜ�ͼ�T����`	 �I����ν�����7��(&��M�lc��ϫ��O�`���N.�ɇ/ ��ߢ�����h��U�2G`~U�8�)9�Yr��O3+S5�D�
5by��ÐL��yk;"QuY�#HNI�lI	cyZ$��5.��^YQ�ـDU�f�"l��Q����*X�*X/��=���DL�^��D�H>�����|��5&a�jK�jK/��[
���b�Ö�*8���ć���p�:�D��`$Rp��7�8~#}ϑӈ�u���qrf����`��h���+ú[�u����Hx��iM5��%w��3�`�A�e$ba�l���X��m��%�j8]4��rG�!����k�Dі�͇�n>4/��n)�5�P���O��劜�|w��ĵU
x5�������H�nFBa���\��bB��ɺ�\����3?%��)�9a�_��j�����P���W����#�mS�bdI"g���w��Ơh��Q�E�������&��U��2_�M�sԵ�R�E�=˟-M~��$���	��\Z�@օd��5��\*M����pq�o�����D���r)����|��#?X��X,�7��.��H�c=�B��x{swǦ�G�A�����ړ�4\k8Y,C|4��9Y�}�(���mH��*    -��95�L;3��d��Kp��a���1���>���Ck�;wG����;�]E�8>�!5?����2�`��gq�'H�AN(���������p�/A#(وy�vh�O2���ƚaH"g�1؛ dT����l\�M����eSe9���G C�����'��%}�Ŋ��[�k�Yx눡���\k�
��zެ_i	H��Nk-��l��H��E��Zg��DF�u9s��;Ɣ��PX�&�1�ӗ�iDDF�H(8��fzier㷰_]�~��H��S�-զ�IL����b��,Hd�D"�]���:$;9�G�������y"ɴ�-e��j��\$<��&�~�yO	�>	����mG�u;"�z�ĸ�v솣L
=��~F���~��\��D�Lu��^�i���>7�m�(�B��������D�BGh��ā� ��X'ń�0\Δ����^Hv�8P�E�O�ob��
�m�$ͬX�L_tZ��&�H
�����T5 A	��@��k3N�G���Z���܃*�ْ��ܲ����_��~w:�$�05�UR�gL�`X�Ѷ��_��.`��JQ�0f1��
��M9%c��k>btG����{�@XGض��_w�������cl�%Ɗ@�O��<�(-.FY@bϚFۚư.^��Q��L��'r1�7�rS���9��P��l>E�=���U0v,Ζ�.�y]@�N���ԗ���\����bP��})�2���m@~���V�1��^�xK�+��;=Gam��9�����~�$Ь�	P֚��m[�uے%�K�D�H4���z.e��^�q��'�fI��E �ڪ�}"��hQ�e�?-�s�p	#�D.�"?%}7�l2�jȒ< ��w[
��3���_ش���fAHV.�!���¬I��etVdп���Ś�wu�KB"�Gz��^"֐��}x��Z?��}"��3$�m�X]�3��'��	�4\��QP��p`������$z���*y�y�w�����:������mqȖe{r�F�y�6_�JN�M����|�B�KV��b�*u���0�-%���i�SQ��iG,�S�p��^}]��Uޢ��f[�|��L��\W:��\WX�CT���D8H�oJYM����laȧØ�;vR�J!��dΏ�CZ<XB��I�-� 2,z�њ���
�A�s��58&V1���Y�
¦��Tp�#���C��/,u����kۯ��șrw5�DS�h�*!��}���W(a�1�B����J;�+:���U�;�'��K�(�j]��i�fEp�,zU�.ex����wt�CZ?��� 4�.���Qv�Tw�M���.;ۢ������s����h]�k��/�����ʮ/�X��D���x����ߏH��Ϸ�&<�W�ș'���6�.�ܢ��v�^ ׹(���j���=0�I�:��Io<TqV�̒G�h�)0]�6�{oZ ��m�JmDQ�8 )�R$q��JM+��#.A����޶@�ӁLM%�fz��3G�x�p�]��.��]²��Q!Q����Bޓ���₄��q��x��FRڳ%ץ�4���ln$�!
.��*��3�VHऴ�5��1�KO�����@_��ݽ6O}Up!1���O�����p�+��x�u91��s"'��nt)93��sS�@�- +�,���>�:Xb�P�e/����0Џ?�B�<���}{z7�
��jX'�/v�F��~}����2�q}km���z��x]������B�HC�kx�P��Z�����6O��W!�;���dԣ�C���~W�wկK�iJX�b�n��!�1hM�K��,�BXG���U�L%$�m�6+�s�ma�ȃ���H]�H�uzeӏ��ș+w�ߝ�&rB�q*��@�)ly��W��Hfy
C���U�Ũ<�ĨMXP�$���h�F�X�IH`>���S�V������7|��E6]{K��A�a���

[Y��Y�� +rfʣP��z��|qV%�BY�$ː�Y�e����3��nno���ǣFORZ	��˰�fX�b�}�q��c���E9#���4i�L��Yԛv��-�a��l��Z�*���!OF,�\RE�Ժ1ÂY��M��E�u�e���&��P{Z�.�@��Q�;����7Xck/r��*��*F��J�J�n����'������Ŀ�-t����г��j�
,�˞">����=������'.Kޗ���Rſ��w��Eb��kB�+[��>J�	=�S��zĢq���D�u%e�J���킅�'L/-���\D�t{��p�,M[���eѨ����+>���d� 9��ZK�]�1*r�`7o��2�7`���6��Uت;٪���d��=�-�JQ��=����u2��.U���< �i�3Va��]��U�#��F��5jl��TB;��yr� �;9s����|0�/i�7��#d���r�rYu9��^��v��3�ߝ_ϊ�]V�k�s�4�uW�D�����x<�	���X+�+	�lYT)e��1A��X"�3��a6�6�	8!4DaAe̚I՚IXVa0�o�f��>����_������ǿ���O*m�{"!7�* �* X���s6��iD�(��|���GX$ʠ�y��>�j��`9���xS,��d������ȘymF�V�c�����d�j�bXv,/H�.���T��������e����r��:m�V�X��>���4�G�Ѿ$�@�j1���%m�(Oe�ͺ�6�3.�j��������'g-���Mf�y�q����L�����jBb�7�OE2I����^Lvr�	���x/�D�Mi<�t�r�+N�h$�p���g�.�q���@���a�efͪ8,@?�R��H�m=�;\��8%{�ݨ��bC�)6B1h��������7�_~{�{���7��{B�~�m�+���ͱ�isT�DE.-��\N۷�>}1\��
�e����`\�40��B���\�'3	�� �J���P�P5A(���]j�Y�Bυo��Zr�/?���#�)����8:rl�\�nC4�]w�
�u0].��9b������X���)���\v�F�'i �v��i)��8������{6�w��F�-�<R4���P�+E5�苹j��D�i��NX!�?�Q+#��gQ��t_�YsiD�d]Vਰ��*>9(�B.���@ג�z��]d�-O2��"F>��HOa��z�5�2S�_�@�t��I�ZF{r9[w�m�.ג(��4��+撚wXͅ�K)�L�Z�J!����t7�b�j~S*�/�<��<��H��r�2���o:�D�%���Kr4.�V�X�G��.����fq�T�dbO�W���H�\�r$�e�b�%�x�`Zø:����{br)I�i�D��K&k\��=}g��bNVYҚ�������x�ŋ��$-��d��џ�\��	H�����J��L+�vq>���FO�DS�8��B�=�O<C��b�.�I���������D���J�`��p[~��-5$ �č��w����=���䦨�O�v�Q0����0+3�^*V;m!��ˏ��W��4V

L�AY�4�
�t/:���~z�18�9r{�+�	HTo4�(����0�`[Cb'�|J��<�% ����O���4������?�Ϟ'���p
Kr�	S���du�+Kg����x� ��/L��X�[�`R��Iv�w���2b"(LqG��"pa���D�m�!S<�|i�[`�RJr`ʨ�,fQG��z�8|�7$u�J�:�V]Ŕ��eK�$F~0���2�C�_QM�(*�HX=l=lWo��e]��xy2m=nE.w�7�\���>�i�M�裫�8����7v�q�� k:T�B0Q͵�#ȾA�۩"�#��](��Vm�=�p�d;nC�qe�-���p|=��wP�3_N�ooؕ��*Da����C�-ݕ[�gB�S>�4�WK˪[�J� %�v�diIW{&J�M��R�n�����2�
�,#�B3@l�    ���@�+Y��z�#�ET��8io��8IR����qv��A�7(�"����"�������6~��Va}�w�%�u�W]�x��Z�З{W�̒�qpE�
]���.z,,�J�b�c3h�b�W!g$�y�<�#܆�=�u�]�ڻu�� �p+`4�uT���������zm�m%YF֋t���]��D)x�\?>�"gA�;���$�B0�{�^hb:�6���O.��x5�Ҍ;1b���@<`�׳�]�����ǡz�Ѯ�_�����jOب��O�CY9a*�M(�Mw�	[�P�(,k'���F�z�����H�f"�b�t����[Gcȁ!r�����/�FQ�h���F��o͘[��t�>Ot�|���*r���|�'�<./1�lr[�%�^�_h��ZIH�������7����3W��?d���ـ�/��5���p��=���>˄-���TɈ%�[r��nOQ�4Z�h_Ɏ��ò�����db��9��K!,�n�fG��6����t�N�	���x��rB�j�r����y2���M6e����*���L0�����$kE����
�e��!���`=��V��<���&����mj�:@�`s�8��f���tY��"0���ycp6#�amLhm�_�)�N�F)�2�K���2b�&�c�Y�a��λ_B7s��E��p��̈́Ÿ-*2+��ʹ�����m&��i����+i6���Iv�N���D�D6--���.����T��{,�\\�ɠ��lA��-ّ!��H�Z��_.�ؼ��7��G$��g\�a{��R?a�+5ݴpc6⫵���K�0<r/�AV
�rg�&`��d�����_5����I��ݾ�E���X��sR� =e��K@2X��0-NV�Mc�BZ�DJ�<�̧�X3��D.Vf2v��(����M��E�Ƞ��hj�E��Ӭ ��l�[@�̍ޠ���Te'���#7}��d�D����x5(�Bn�+�,y��8�w@��Q@h�����K1zՒ��B�s��ӗ�=�x�ǌ�i�Ld=؁p}����B䒔y�p7e�$���,�g4�O�fi\��t<d8s��h{Q�F��﮵��ڌJ+T�f�ɻ�| (�������w>z��)XT��O�K�,~Pd�"f�g,b��+��5%7�B
�5��=��J@%�ڻ����YN}f�h����T97��v�4LYWc�L���g�&!�H!�E
<�g7�^��R�|��x�sO�H^Oec�%)dn��=��X��1�����&�I"g$�oر�	���$-���
�^\ȭ��ҝ�gB���5�,���ٌ@9��/,}�o�{����B�Z!�[�mq�-�(C��������7o'I�q��F��h-U�Gk<�/Y9Z9mI�NQ|��u�A��ڊ��*ҮziWG22�*ց�@BU�s�# $�ɏ@ldq���"�q�_UV��F����y�� �tu@�H�u�k�,����UI��M��ș%�!�	n�c�����&�Fܗ/^�a�^z��x? ���M8W��Xr�U|u�[L�B�Y ���5�9K���������X�(��N�I�L&\
�2��^��
�?=Ǽj+�9yË{���	
��Sr��������p����y2��,�_>�%b��ͳ�W�v�InD� h�,V�T@X����NJE�y6`?$F%�8�PQN��J�>	y�Ag�+r�?�^JȽ�&D�Q@SbYiW�e���t��Wy�9������}�����ϖ���N{�A9��nfcDcZ4��Iy��9��B��U9���O1������x�p�V�Sƚ�zPPx�V�+ްw��M@иj��}��; >z�^aC��f�n��5�e<�A���}�kE�`Nw��`1**d�T|�t���ڜSc���4rX����J�)��aJ��л�l���KX�W[�)_h�� ����3+�H��M��n�r�HKX�LJ&�d͕U�<�D�:y'g�|��p)@T���$�.H+)�3�k \�[z.Y �\��t���%������-����lu��~68�r�٢��LPa��\���D��H�ɮ$����p��3K�rD�Q8�0�P]�������H9.�"~��vr��������F��Mykq��F�F�4. �̈�8����s�M����N�/����n���G�H�9,U�8�ۇ��W��$����zװ[�[������m7
y)`4��ᬍ�B<¬?9W�tx-0��2������+�q�N�>r^���}a���ю�Ӡ��V{-B�S=�7%�|tkX+r�1kT�E+�I��%7���lT@$��JsU�*�&H�����B�HP�v�`Tr��x7S��p�w�ݠ��0��w�1c��� *7�p���$DkOj$���J��e�w�."g$�&�G!WZk��'HL��h��d�6��
�����!(�r���� 8/�l���ƍ��=G��S��g�B.ɌCZn�oL�׳�0-?V�m*�����s�{{����|��Ŭ8(Mc�!��v�&;8�����f�F�ou�1n`hDҚ��f�)��e��,W�K,s:�O�2�#qĞ�T ��4�n�d��`nWCRQ��J!�f����]�Tx�~�B�P{�l{���91G}��E,��D%�woy�i�\(0�p1����V���� �D����q�J�G���oW8�Nr��hoK���9��v5�)2��`Q�3G>>|���vv���1��ފ��K	VRl�P�1�%އ>�6�߷�Ml����1�\ȍE�h�=rA8\��1�'E~�g�bQ�Q����9^�wH�m��+5 ��B�@�??����TnZ��	��H�e�xi�`t�W������i�h�~��;-&�)��an%-�i���"�G.�5�A�%���<����B�Miep��F ����M:SY�BI�^���p����G��;"O���2��z�ˢ�665�I"�;��ۉ��7�1��Z��b�x���X�R㘲���8�\��и�͓A��GZ?Q����@�}_�%sq\ș!��lz�dJ�yZj��<�26�y8�xȾru�[u�H! Ҏ��zڤcn"%��h<���sD(��&��KQ��������R�47e��358��ϣ��_m����M�!�7#@Sm۵��Q��s���3r�G�f�EQ��J�c=�,���B)��c,�G���%o��Yv��-��qA)�1\ȏg�h~#y�NK�Hس�ڳ�ֱG��JZ�U��Ef�ُ��Pڷ��,*[�GԒ�&�������/u���lQ���u}��S��܄7����BK?j����$�L�޸�[+rb��ˏ����&\��.8�<��b�O�<*�m��1O/�������g�<���a��FQq��\f�B��,}8�����i�C)�|���p��YR�����P��q��L���r��+�"�"붛;4�P8��Є�K\��S"E��<3�4���vjc
S�B9 �&�(�1�W�`PZ�� �k��k s�P{Rg��>��
B��*n��_j��;��Ψ��Hoa�B�@>�p�?[ІX��a36� �.�Ȼ�ȯf���Rv��b����t}���<-�Kh /�y�#�:��u��z6�p�c:���R�wM|~s��@)���'��Y�\kV
��rw`E(�,) ��)PL�0P����t�4I�[ȝ��.@&�G�jTܼ0ڎW��I�oKrh[0�8�3����Yڎ�7J@j��A)�%������P.'>17�<&r���' �Ƴ�l�<	mfx��� H�9) U������a��/�w��Fgۢ�bM�7��r��81���u*��X��^�J�b���-v���2Ҝ�[�*h9�|!����G�Y-!�ݥ���+������eOR����	����D.\�a��$`���pu�K
���6[d�sܘ�;r�ӎb�۔�\��G�`糎�^�)�q�㲜��W:��}
v�&wraʗ�̐�b�{X    v���U�a��*/��ӣ�e5��N^�LD�n� *�\��_f)I�
v.mV*�{�G�;L��ߧOU<ST �K�R�$:Z3Ua��	 �A�ZY��6h�B���o���	���,8�=�y0R\� �U�庒SⲄ�����Cc,k��~���Q�b�`��6n	��̕�8}�����96�#�D�$(gH�0�����7Q��5H֬~��K�'�A�	�L���~�̥Z3O#B<�N<�d������Eڝ?�@d4�dnb#-gj�����S����F �\��$�6/�4d(9}�k��_Y�q��UM�1yݳd'�w�o�82!���~S16$��9y���w4?��^��rqdz,tR=�B�HJ�*�$��)�,HL~%<�Iw�h���p��Ҙ
��R�=^�=^a�x��Q	*���)�\���peF���6��pW���8ELYKS4H&�1-q�R�;���Ŀ�.��� ����Ț���h�o��Xw���\�|��引����AKO����Beq�A>��4~v�e�5�>]�ȼ���b)��@���d5��F�����r�8Ú�_���������@���,���oa��I�"��_w5�p�-�4m����Ǭ�P���.W��*@L[����x3�cjf%f�78��nZ#삵�2��Y�0�2�=�A��x���Hz��xNQ���)����d-(��pw,�������;�Bk�(݅ZLs^1nek�����Y��ೇ]֥&w6�;_��*ʾӁ����R�~�⎉��r�������B���	B�6c|
����Jiw|�;IHpq�ڐu�粒�=	��`%��\��/ܦ���-8�O�ޟ�@�t&iK<\��0VaJ�x��X�M�tMt>\�.�EI�|���h��䤌.v~����zx�&'�#��ik�jr��1����x����jî�_@��	��L�e�郙:�p��/d������埿��ǉ�Zp�(Ў������E���PB�)S���q&9�����{�P��@��;�a���Z�w� tk>֜/T����H ���Ku�k�(��P�G��r9_����ΗɅ�Jy�V���sR5L�a�X�#A$5���*������o�:E�����7��!Ai�Z�~?ad�I�~"v{�$�,�_��d���W��'U��V&]�ɽ����	+�]�����#�!����
]<J=u���~A�T��yIMI
vr��Ɋ^����0�7t�;��B��_����2�hw����h��g��H���7��]X3��I�?��3���xĤ���L(�ۈ�x�қgl�
T��Nˑ�H�
ks@������'�F$����f
�ѵk<^*��)v���d�beG���W��z���e�����_�| G�Q.�a�z��u7̖ʣ��o�]+5�d[N�\�w���������q=��z�Ֆ����H�)_2BI�bY�q�	�L��(�T���Z�PK@���nu|�u9Xr��x���뙼�}���p{�b��H�ɋ\[����g���� �ۯkr��Ǉ��Ӣ	�����G(��[�wP�]ʣ6�����<�Q9/�N����tX��6'�H�X?B�e=*3A�K�n�fM.l98c	�1w?�q�Έ���2��s1Q|�Y0���f�]ޢ��~��h�,�Mfm�zV����@�@"g0��GbiB�ͅ.lk�4����Y��ȗ�~z��_��?�᧗�s��?����ᆜ}����SZ+�����3���]��?�}���pk�M��ػ)a5ݔ�S����17�ykhz�M��yL����7*0�X��1(����P�;fɵU����C�YڑH5��=��/s$xQ��\GJ�5��3�j=y	�&�`^93������jgq�[P	
;e@�����������`~�*_;����r������A�����mՍm���*�f5KԣjI1�Nv��:i~IXp�l`ejg�	I�����q��?��8��ܐ4���}=:p;9�����S���I���R�.;�F�.9�8�2kˣT�D����DΜ��Պ����x ��Z#M��z��cr�����>��ə'�0@n.����s��ZLv�k�>�lt����)��Q�`�5M��"�v_��7esA���r�`���f~�V��p����ZV�����tݥ#&i��/=��l���w����h1��̟�]n[P4��6X<�*,�HI���%z.i�Ye'�̩f|�Ol�J�c-��'�q{�/�!N�}z����&�������9�8�)8��uŬ�ଵ!7p8�I��ÛD.p~��o=cpy��X��YM�I`+���<�Q�r-�s��������_9 ��#����EhX�_��s�W�:&��zkݷ���ډa�Y��P5���K@,�CfC��V�G`�<-�~��ע"���?��ӏ��$(iE�u����w��D(f5�N��f����f�y��<�f��K���q΀4hcX�_MP�P�o�k(�	�w�}-iE�n�gH��4DQA��P�Z�,&�#������\�rbG�d$��tt<�ݿ��/���w�g�9Z?��SA�8�<91�uq�uY��k0�H��Q�	+���D["�$.��w��ޏ��V�y��ף�b��#���y��9h&�3��N�����N#�#��X笐�9��x���}�+@�����e˗Ź����9z��S#�D�U�O|�,�g�y��R�)t/:0g���� ]��\{�T��������рH���)��|Nr:�'�P��uT�&.MZcuP���=�IS��4Z�x`��H���1�e��5�jL��iL;=B�N_�u��#5|.�ڍ��W<��LI�15oX;⟉%���O��՘F�Jo4������>,� v�����g�2�	�9��Y�%{v�Ġ�	A(E�a������� j(S������$��=$��a�v3�u�*��һ�S�2����P�06`'�>dhBm�|(��b9(�8�FUdq?{��K
��̭BIH�A��R�8�#}gs�rfc��Ζ	�s�v�B�P^bg��'-]��� Er�:8�wp�O}�M.sɬX!g(_>�=����4굊��uoB�ެMV�����x3�j�|��T����GQaUX�T�Y�@ߤe��4H=�J!g(��Nw�q4�8�/}�FG�4v�б&,�yH�y�q6��-��S��ps��F��J� ۄ.�6�EO�.3=�*r������YB�Ҡ\\���ة��Z /h���tc��.��jd`M.���w�$>�]�@G�n�e��y�G���W�sz!\a�|XQz�p��m�Uu�,�Z��j<��^\QmڀGUu\W����i��.�º�r	���4���S�n�'X��5�:�9����uň'��������Jӹ�u�8����կT��e+-���s�9�=�B�X>����?W�֔�9����x�wް�t�
˘p��B!&�APu�3aZ�P^�ajzkG5W�m������ <s4}��
���d?ٌ��:э�$rQg>��I��gm�2F��Y7�%�ɖo�7��p�
y��~wsw������6�͛�R���J6�G�Ų�]F'9(��_
��y}×�A^�j��h����lpRv��~B��0)q��ތ�{`L"_��k/��ך���0�l�6�Ψ�����Ѱik�I�m�J6���ϕ��5��6�/�ڴTk�
FV��1��
H�q᧪g6@�?[�����sA�UaU�/܂��$�K��s��V�sd�b��]J��I�Y$��k���JM��X�ptMx=���s ��I|���=���h^PX�l����}�|�v�2�Ǵlw����go_����±a���C�d,��s5��K����
�E��ieV�U'��s���N/N�!-���$�̜?��s���A�:����e�//�k,SK�+�K��%Q    ��}�-D���O�}���=]�i���et{qV&���J5Q�Zܹp�R��nS&LF�|ss;�
��������8������� 	��>��?fgl5To5o��3郖�R����+���q��&5.�9��M\U��x�_Q֩��mFW�edV�����	V��K!W�����
QN��x��~t]�lu�o�eb#m�g���QB�"o��+Yv4�R�v��'P]LE�WzP_�\�����~*�} [-l����د���o2��$�w�uP
y�BY>>Y��gpv|p�⦕_���4�Q���N�������EC8f�jF�@GH�$���.��S_�q�#9S��d�B��f4��<�y�������c��	��\�Ťo҇���@����"��)w����S}3t��Yۢ����&��d�/{J&���PQ%rB�8��MZ��%�Թ^5�ϧl�GaR&���Ѫ��E�^5��Z\�@���;n�8u]��~^��N]�����R~�:u9 `P�a��S�@�yg-� ��gt��u��pJ:4�
��S���g�󔠤�m,��d; A�&��{�>L,�_2��+��_��H$6x�hy��8
��y����_��j�`�0͜k���by�w���w���-�y6�G%�C5HNz!�%�)��ٌS��C�m�W��?���\��e��ND/8;�������@D4I��Gw�g�ܮA�;��ڎ��4�9{����0�T�}5U���~��ǛX�sF���Â-�Q?;H�úӦM�(�5w���p�܄'F,�\�~�4Pô��S,N<�:�q
�����)���5;W�̔ϓ���g�	<�i��e��2��,��2L��؉���(w��`��r�ssw���yfp��6��N8Ȝ�2�V̉��{󖎙.�~ۙ�C)[����!byC�f]k�P!��<����L��Iї����s��*��T�7SD����h\����!'ρ��兺�	����'���[T=�� ���Κ:��\�>�Y���8(4�"�k��ن�Z:(��M�_1��ݟs�#*_��3�G/@@l�i�a�XkcE�ן��Uj��oi+򞼙�q/P�{&��#Ђ��Z��dq
��,�c3��ʓ"g�������~����t�ߤ��hvX���v	�~2��6=�4����Ȼ�>�������Az,��UOq�ig��1+S���&�+�k?G-F����s�?�9���OR˵��2�ʮQ�CV}M-+L�K�3�A��l��\	w��2go�0GQ�6�B�̹�) ȎZtӜ!�a�X��f�,��\���+D�X�o?O�4:� b%��Z��ZK�XK�8�MWkh&�������;ߝ'�3���q��$���K����]45����� �7�;�b�?�����1^!8��t�����D7�������ӛ��I��2`����T�F=�9�{5���G���e��ǩ�7�D��:@�N�P:$�KC�eS��f*��s�yW��P�c&��;�A9�A1O���6�s��*r�r{�ឋ�unY�l+4�gl'�r�òn��*��gt8�K!_�ܾ�ƚX����;�5;3D9;�Ѣ��g2aƙ	zn՜�W��)6x@]���|����t�}u� �k�!g�wz?���;���Q"_ؔ��R��k$��5V���#2�E�-*dI�L�:�w:yu*zfb0��L"0�}���w.h 6c�Ö:�X���l�b5M�V3g�lf�e�\�L]L����8Lb{Ƃ�ز����T z�e_0_��b��	��#��,�<a�iU�l�tOjhҹI��3�肍ƿ�/a��4�I�pl���XO�l`���]�φES��j��[�.w�A�JsS��y9m:7��B�Ȼg��,�$( �x�r���X��uo�<�m��GC�����y}~?G��"F5֐�agQ��(i��՚9ZC���dlF����yj;	
��9�b v܉򝋆����ސ>1��D�Ŗ��ۛ������%X�94�3���Ŗ4���U���'�nmNwl;���I���i�{�� U�	�',,^9WPfΙ�!��	+䒚yI���"S�� ���z>#��5�z���u�%��k~����)s92c�Av��ZO̖kv9�.��%��E f2���hIc��3C��iAv�2
�Ҕ=}Y03q�&nn����O|�a��OBt��Q�N'+ Y	8d�pC�l�,[�ⳉ#�iNI�rA�w�& �ڀЪ��1��B����GB2�g �H�X�ӻ��s��R������e�4����Ţm�����N�c+�����-�𮿢�]jC�����zc�mʎbbS<�QjE"gO\PA!��
iQ�?^�C�5��i��S�pZ<=��Yښ��%.Ժ��m2��Yj��$�OP,�1��p
U��J�~s�C����%�e��/K4��cQ��H�A��x똼/�i�P��������4;�D���v��?��{�X9K�÷��O�0�����Ƃ��۔�|󦜄s����s���i�\L�͛�:���Q)�İ��P�ǸK�b���W� ��}��ߊ��|y�x�1'}g�l:F,�g7�B����,���2�[J�U_�\���ܝ����I�&@=�=Z� [�R��j����N:7N+b���&@T~F0��g.�h���QKzD`TY�Cf����0
��a;���h2/�j����.&�����`��ayN�J���C�D��~q�f[�n�{&;8/Ҕ��`!�� �⥵�)K�[���rL�X4�I��3�&O���+r�M�p�+-��1X8�@�KAA���xvs��gͼɫ;�f9#�x~�����n��rLk3�Ҥ�X%���� baқ�~cE.�N���@x媌"�ZL7Zg�=����t}4�ї룗X�3�)Xb@�&�'����Ho�p�F�F/4�/뇎��o&�@i}��f,��Es����lc�`�AOrfҗ�-�bh���%a��q?��'���b!���k`o��M�t�R�%����=�L2��Bn�f)+Ʈ2ݩ�Ց�5_&6G�҃�)�=-����LJ` +��ٲ�~��,3����Ԍ�b���	 c�L �@�<gl��f�;�r�lT �pX�C6ch6���4۵��j!���%��r�	��1�=�D���Yk\�b�q)˚����Ȏ3�o��`x�d0{�)����
��/xG�9����%0���{iPVNrŽ&O/Ҍ*K���|��箐Ln`�[���.�k���̦w�i�靇լ�D��E���7Ai�g�F0�3���.��Ӥ��=�B΢���R�XD�HT�>0��gwi΄��0`�I�Ms�
9#y=��J�T4�����^���4I�>��o՛51-��&��2v<]�\�1��� �Y�alg�F{�յ���+��{ ��I�=�Ď¦f��h�
���$��IQ��?k ��❉R�Y��qS�Wx��3�tB�X4f.u"�����,�/�H	_�b���ji��JC�&[���b�5�=�@o�*r�����Ӈ���Mڢi4��݋��( 뮱/�|��(�&Ê��0�|ǔ�e������x	|��:-��c_Ү���nSfEN|yx��ab��:Z���H؊].ܭ��CY�7��ƐH
������_����~�p��@�ل��v|V�Α�U�e�����q�IK���y�����ETwߟOO�$Y@���-q�a[^�u�8�K��l���g(��Q+��r��|�t D9��'Q����5����[�J��d��J��<r��o_�ʹ��aq�+���X�U�A�2b�9�8�[0i�2�V�ο��4[����$Lzo,g�$r��O�苤Z�����Eİ-"�ڨ+��,�tgq�d�;ڡ��}�nYC�Y��Xa��L�\�᳿	c𗘢|�ëI�v!�뢮�s)��e(^�Y�B�P�:��{���P�גw�.�Z��]c��1L��    B~<�
��G��Rz�̑a;]�w�zv�p��q��$*�sm��2H� �G��'D��������jr�<��i=:c�\���Xb�)%.��M^�"����E���{*,�Ov�Q!�������߈�}S���T�'8g?ԭ��Q��MY�l>��خx��i���g���%��>)dڧ�49��
\����f���>]SAA�_7�ݲ3�L�%I��a�p��qh/��XO�����h/�>�b�$r������ԑC+]w���9�;����.��Jz*�f�$������?���_��� ��z�YB~��.�����w6Ê�C����?}��/?N��T�o<.�2l���L�NW���,>��"�!.N���_��� �t������gt ���)�r��$av+W��ǿ���D�T���+X���nVJ��v$Pj�aK"�3�����+�����SaZ4*̯�=r�(�DZ���ɻ�gw����K�6m����8�u�^E.���_L_����x'��2����F�hT����b؆-:?��>	oT�qy����l����(�;���ΰMZ4N$v�,��pLrG��yđȅ#�=	6؈�>�#=����J�3�U@Fm��bv���8�F�g(�9Na��RZER Dc~R���� g�q�ZねN�+n�q*����"g$�N�0u���d�t+��i�Zz%VK)ȑ�O�����p���}KH ;٬�A�ɦEg�W�W�kr-AMO��̗�>j�����?M�/E���b�	3�3�8�����L^��~q�>�K���<�%ZH �p��3�<Z��A����3!y
�pw�4��E��-�3�r��KCB�aKz.�XrI���>��)�)_b���a1N�1�>]��#8Q'��wQ�L��a=dz�~�$r�ny�7��'5`IZ�)�d���z�}5���fK)鹈'Dt@v�n*O�YCōqf��E!�+��^id�_����º������LI�lb�9�E��!KM�0�2\�i��;<�aX-3s<���D·�����)�MI���7[v����ڒ�,V'\�L�Z�3����I�^B4��;K��x��]��ry�JC8䠁2���3Lםag��Ѡ���&�I�k�B�p�N�>N9���v%�8�B���	#�U&��A��L"gEp���P�I�[���]9�땣eѭ���w�sF$r��cP0��:�l(�N�� /�&�ov[����G$y��߲�L��l�+rO�pͭ6w�u/�T)���;���V�cl�{�+ ��Ğ?`���d�"wb�aQ4aD������U��mؠ¸���TA1f�*tTa�u0�q0ݍ�"1G�e	�{$�\lK*Af� �e�	�49�l��FTp���ԗ
��Ko,�R���%��ǚ�$ q��Ơ�ƔXL`$�2ϒټ�A0���������%f�(&�u\�tH�}�	�TJ����i9�C$T���%���#����Q��Ճ���&�a�QrTb�͒՝�h9�����pL�5�B.r����iK�Iah�a�(������ĝ��0�B�H>��4B5���p�'f�n]�Cb�n�m���{�2e�]��śLK�9	��@� �㠝ų�K�(�Ckmի?���2��*�|ɋ���M�/b �����Z�>�}��2G�1��bl}!���ۇ���
���3�-���&��I<ar���^Z�ڗ�ҁq'���	�)f^���t�	��P�F�/*��Q�M�Ӌ�W�V��J���H��A�e�g�M���S����ze.g����yB��%FXbip�#���J�i$߬n��LL�N�QU��?Ei��Ɔ��ۼ�.Vd��u����V��|M��3�,s��)z��3�'$�����6ai���򸑚)��4s�A��I72AB+*�5) �Ki:�ru�vR�G�4��ڸ����-j��#0Fo�KG
�e�yd���r'g�f<�'�����/�l���*̈0��lW�v����"�恳b2��c�����o�qK����~�oi��:�_��6W�`'���̥E!g�����<��n���Y �VƲ{ĴmO�S�\'ӱ���f���Qr9��|��!LH�ӧ��b�۲�-v������wi�q���܉=���w�ĆUg�Qg�	
�<b-���ʝ\�{S��!di�(&��I����u����5�����}��{gvJ�~��H�م[�v^�Z�-�����6��+�ݱ|�~��P�q`��D�ʼkd>��<��ݫ�b��!7V������3�JX����D+��Ц�ɼ8jo�Cd}Ԝo�&��D�Hn>�b�(����i׶���	�yu���E&�Qa�\|K�as$]���|���o�X_�v����O6i���U)�ǆ�ӻ/q� �=9\�jؑ	����z6ܔ��T����i�ǠW� �l����zy�X�VՌ�|�^ƶcjAB��o�݁�v�1����ѵ��99o�6RF���hf��0�Z[*���p��"j�ٚ'��xeSՌ[s��L!g0?���� -��p� (�/�_ƹ�;1w�u79��9i��_��u��*�)�/�D����i߹�x��Vt��#�̀�����%}y��oNX=�R�ToQ�y�lW���v����?Z�J/�tߗP����6�T�fj��uӾ�ΰ~��C��E�����xx��-g�H�[�"O�~���Ӿ��aq�{�dbgh��I!g������}{�wVf6dh^j�o���1XU��׊\Xr��D�SᨊBo=�~�6�j�:(�7b�hJzg��{#S/�?�>����S٨W���ZJ�Y�Ց��ȋ��:�명���ݟ��|��bNM!ۼ�C#�.LR0��1��1��O%̆A���7��\��6���I���Cg�W����)%���JrLo]v�~9��]���Hl��jlp���L�dF-��ʔ+���$r���	W�Û�9D(l����w�A���~�z[�I�rF�������/s0@C8�Q����7L�{��[䋣��y�+=�a�l3�x�g� �|P�@AH�f��wDb���� �D�q:��$rFr��]t��`R���gpZ�I�������`�l\'7�I�=ꟳEӔ׀#k�-����2�EW�U�9� QC�\�/wc����QODЃ�l2[�n����/��K�H1�%;B��%{��ώ�����Z��%�r8`]���۾�gဥ��(��*���՘���ɢ>�o:p,�9ؾZ�"������B�э�T�k�~)Y��'=�$k�B���7>'�X�E��.��}��v�$+�9��+�\��n~�yr!F`���mN	 ϒ݉b�(Ę���y�/���m�w�F����g,޻�\c�;�,[ii�;c�I���N�|�W �A�~eq�É���ʒ�y�.��J^SW�'LE��Ll>>�WZ�`
�$����.v(�"�ep�-�6�y/��0�J���g�[
9#�<��KP4NKAǚ�LV[�\�;�<<NPM_�\��3���ʎ(,1dr��:KS�YF����R#���]�R���<%�r��Ro�H�Y�t����s���!	�8]����Y�?������_Qzz�5[v�1
�.%����&��s���dE.ي�ķ�I�a'�ǒ1�V�ә�(��@b�]�̥"�u�k�]� ���u�gy�����U$���.׷�>V����KR$ �?�I�^�ZϺ��q%��<��7�}c[E��%��<w��S� ��XX�b�t�|��U~��R�%P�x���!�b���a˖!�ےu�~G21���٪�<GBIc�V����F��S%Z�elI!�H>q��		��pU���4ku�4��W��XEzޕ�U��t ��@�w�bY�?^�W�E�����:�F`+�9l�B�g�D�m�-����m^XD(����?��NU����	�䧰u;�4�����h	eS�U��t=D�;�0�rlI�q�٧�\��${�sRȏ�.Gɘ�;� ��t��`�:�����4=���
B�9�\."~w �  z7�O(���Z�`XQ���M�5����K���t~7ML���G�x=_T�6���Sj\;5��
�~�n��_Ш�t�j���}����h)#�O�eo"�a�hE�|�����討���@��1���նo����\g)]��c>�>~s�<E���<�S�{;�����w��,�,ؘX����2h|5�����$'�)L|G��� ǎt6�wP��2:���/� �SV������?��gvU��{>j̵�L9v��	��Q���2A)��oo�o>㶅�/??�oO���B�����j:�'�m�CK׏O����}{�k\y�T7�)p;v[�`|�ߨf��o�F|R�3~��G�G|�*!��]�7z4�+���t����^����+��ޮ��]�l�Ď!6Au"�سH`fF�[+,=�$r9��'v�W�B��|p�� ����AY��١L�O��X<�@�Ղ�G�(�Y];vg�	�Cb�6����^v�2-h�$rF�ݻO���&�W	��P�8%q>�c�C��\k%ֆ��px���m�V�����n5���%�;"ڄ���'�9Xd��;`Bs�.m/�O�'c��C:a��ɱ�?&��{:>R���˽��w�?>��>�h8����Zɔ����C��L�"������V?��3�Z)�^,�9}��@��_��-�>��u�}����"������>�$r��8vj�����f�"�_�ؤ=W�o���%%�o�4�	P�)��
;g��sV�b�b���>W+u�0*�Α �'Qh�y�ر׶{��y�SΖ���+����"g�||��}���[P ���m=�,z06�C�Ű:�"g�|z�w���iA&N��K���z��]�I�U?�"g �	%>�}�y��A��`��c�j��L[���sm�U�u\�j��洰x7��"L[a��2kS���X�uƒ��x�J=����g�]1��?��Y;X�)K����t9�b8Y�ҦP9�ƂRepL��deְ0��$�t�,Y��6�Ew2�r�b����ڧ��r>R���_>U䒊>�OD�<���(T`�=]�9]nu�j����"ؚ� ��I���y�%m�%+)��%��Jo"���J�M�vJ��*b�(b�z��/#c&.K��2�˲����3�6�>	4�ZnDvly���{I/��MVx��W,J!3?��i�ܤT���bU��p��F}T՟xf������F��s��f�]{v��U��2���-���9�sIχ�����|>3a�q�����@vX�eE���#�	�=�B�X�N�t�2��l>�yk��P��Qi�0Vς�Ɍ(-^Q��N����*�3候����&>�T�L�1���%x����_`6cHb
W�d4HV��*�2s����,���z�� 
�:o޸vE(li��^�+|U0{����T�����{��s9��w�ֳ���b��ȫC�d�¥����}7OE�XL$�1I�#����uY��=�h`���=!�,`~^���B>� �K�MDeL����:���A�X����u��+N��~/��|�ޝ�2JKo�I�Yu�;�eu�}���z��у�,�9�aW��2�$l.8�Պ�\������Y6��u�.+�$�(�@�(��3��w�@�nY&E��J�0G�|%�ܳE��.�a^T5 Ys��(P2a�{qlX���9^�\��ݙM��|�i�s,��*Sa�	XT�42b���������H%��eb"I[��r��% &�dYlql���./	OG2s�^:�A�9��#H�۔��2��Cr�k��ǋ�d�$Կ'�+JQ�3�n����C�E��(�6a|�D�@�E��$��Zcp����qդ�Ƒy,T\������6#S��c�[�Xm�o����v�d,�6*�����̠8���mF{K��lۈ���d�zȖj���[�d�/��f��# &l��=/����΍\�T���hn�������:Xڹ���u��ڳ�).*4�ť�eJ��_�Y�ǀ�k������,謰��t�0��s�\M�{׵W�O�-T�>�����'��y��#�p��c��[�%�qr�JQKd"��̨�__�wa9�L<b��l���]v�3ye�+;�����Ej!߾�e�sE
�E[����E��E(S'|��~�sENp^��af�i��Bco�?�ֿ7��ڪ�~�y������$r���ͼ{�	���@R?�G�4G,MPZsZ����¡�O]�Kҥ0{��7=It����)����m?��8�J�X�`�xs����x0}��
�*'�~+kBh����v��怫NG@P6�����|����F(J��}p�v��^l}��L�G�c�0hL5����1��a��:U��C���L�^��;�I��33+r�iv3��h�y3��V��#CJU�'k�4)N�#f���➝�lm��u��V�#��RZzN�`����ۇ��o�`d���2�^���6�9��)�	�a=E�U�[
��/��u�a(��c��Dy�P�AZhѭ��ե�dʅҕSNd�!��f�u�\����˂�>�5��5����M˲W���=��ٜ����?�X�\���E�ʮ��W?��
J'ʈ��1�sIc�يf1FE@Q�7^쉞��L�ݧ��CBV�����u1^B:�1�*W;���х1�B��MU����.��%�K����/h��FP�&T� Qk}�j};��}�9�����&5��ۂI0��	n�.�p\ݾ@��Y�NnI"{C�K_���qr$�:��r"j\�*�㮝��d�c�Ň���9=Zo������@��"%�g5�pSR�.���c���ܪV�����~S%�"�M�F�*�����q,z�L
�tD��s��qE��0-!>�\�i�����      B      x�̽ےIr%���
�@�����@� �R�KQ;�P�lΖHos��^���q�����L��%)ҠF'�AMUM/G���.�?�iR�Oz��OS��ߕ�O�I�wξS.��M�������N�����/����|�n?�^�v�0��J��������A��f��{._�{��<�����/�����������!rÐ�wZW��:�U.���\{�<~���=�&N����_��7�=p��-n�;_����������?�3�&��1\��.Ж��@q;���wq�
�e�챂d�X3�U�7��}P�o��=ݞ~�?�������
\x�������k��( 7�+�����}��@���1�y�<��7�.���Y\��z���W��7.�\����u�+x��Q��x������ǉ���xǫ�iլ��ΗY	���}�ž�DH繨kw횸]����8hz���t�"׃X��D�)������b�� �w�|U��۵��S��q��o�w��hBj&�T�S�A=ր�N�ʰ�2�pvM܎���$ ��b�ͻzӺ�[V��|���{ﶊ�_��徇i��P�U؁-�QY[�����{��C�}��^n��m��*V��x��e1�������������V��?��?~��kQDw�U ���.��*��?���<u���f��ģ���pG��b6=�Ґq�݇�"L�0L3,L���XX�A.�C�P�Sb?�wv8&m	����xg7wsy��<�<>`cV�Bc�-o6�o7�ܞn{�0�1,��ǭD�
1(��<�� ������ެyBB��O�=��A'�ZYc�zQ�%\�q7qS��w�����������YU���a���&#!�e$���H"���a�DPW�J�%8��UI�&�=rZXZ}T���5j��Uz�IĪ=������nCwb�;	G"Ղ��VX+#�U������鹿��剙�E��9�b���M���0-�����Nb��/��?^�`^>�._zxT������)ҩ^:�mJ~lr�A�6�5�}m)ك��|�%-�s����@�6��O�i�7Ix�f��*���`\A��J$Rl�{fC [���O�Gm�m�b��O�H���Ϗ��.O�OR�a�X�f�R�	����� �X�Dh'����I����ԋm;����쇧���[�-��N����Ckh#&f#���(��v����ɡ��3ߝ^�'�����[~�2�N��;/����O��bN��x<S�k1��a?X �,j�W��M��!j�P/��b3pqC]<^pWR��C�!�dߦ5L��r#�C&��Dɻ��Hbpࠗ�pІ������K��2� O� �Ax��ۧǷ/����Q�>����M#̟�[����C�~��T���I�����7���d�K�l�]S�t1t%������w5�^���������]��t�
Ja@X�m:bc���ʏ�-횫�iq���!}z��
�vpm�vA�J$���Ǧ�w�wH�nKm��cb���K�eSv����}�y�sR��� o���b�R�JY�Su @�`E��U(x�W<!�\�2K�#m8�3���SN��v����Ϝ[7kJ�7*����q�����O�>�F
;E	��������_�ބ&?�7p&%Y%�"��;�]��(�E��if�L\)���^�+0�^\��`��p��r)�^O����jt�a����3��`��N��L^4zyBBA~޾�L�^��~0[��|�N��&�V������ts^~r��B&�`>�ޒ�0�U�{�E"~�<5)$'�ĸ��':xKa���
3�<	���_��t�gM�D���'��޳����ތ3k�Ĺ*�,p�	�Z�q�.L��cL��#�\�'h^��`��m��QKL�\��H��6q5��.������Gx	l�f]��l����!�!2T�t��[�x����`<&{ư�9��E�B�<��d5q��c9��#G��G�!N��^�>�*�ܠ �"��B	�����V0���G�j�Ͱ�A3)�'��<�{�Б��⠂ˈ�{�.!�򰕀���t�ZbZ��
:���Z�.� F�E�}J��Eܴb�:��\4���p:W�{�E�>0O��2�u����z;]M����1�o�d��☛��\CH=^`/�9��V�:aR��In�����嶿x������)���O94Ć� ���&n���_z�����������S�ؾ�"l[o
qy��CZA�73��5��!��-,�@��-uvߧ'���of�OM�~�WC�V�v�I>n��%�HҪ_����Ѝ��e�}�������>K�4�5q�{s��ZCG=kxP��k:�v��f�V�6���K��e��AW#���-�<�k���ݡ��gErS� H��Q&}��nov�-Eõ�(ʉ �t���b��đ�9�x�z��be��̽ޑb"<
9S.���"^ce�x���&σn�8u+��1�FJ�i�^Q�m����|ϓ'*@���YO)�M����� �/
���ͿPHQ�Y���^cda)`}KM�Q�܅{ć����!5���S,-E��" #?��H�i�ï��|�O���u4rq~�,�p�G��_��Hh�+��}N�G��(�3�Y��>9*�ጏR�"W���e�@:���.�x�7�|y���Q�e����t=`�I
2��ص#./�J���C5l��0 *�Bj���C�H�Co�ἌR��=n6^h���Ͳ��ūِ��QV�q�����n\�_�;�����_�;�<�R�^b���Z[�*�p5�'[W���pg�ry~��be8��T������Nz�0��
\4�-��E��熜%�H�R��~�oiづ�;[������װC���_�oN�g��i�WLM*n����"� �P��Au0%�;�8\H5\�����>�}K�N(�8�#����N�(� ���1��=`��t���4�o�S{H�sL��
�M\��h�'���O�k��n0s��gqӉ�@��pёf��/�m�K���[��ū3�Bߧ���Gz���*֤���:	���ݜ��Bߧ��Ӄ|�+ً�gƯ�05k�Y�Ɲ��A��S�V���&���9A˚��J�vΩ��jUP����JG�}q���;C.�ڿb�%�_��PQ�-�E#Agi���P� C7b����;�H1��9_�#ݲ)�t`ja�[�a�C��U.Tb�����е�dir�}��7���6e67���P����/����?�o�?�\�O��4�MuuH�ϩ�\�]^kp԰�M���~A{�%}���S*�Bmҍ|�L�vG���o�a�־�tg���]J_ݚ^M�#j/�oqJ��	�e�����<�rBJ��GK�2~�����{�a�oj o��n�r�� #�Հ�3������ٟP�E:ѡ�ڵ��z3S�֦��Z02�T�r7��� �"Kj@�T�N��װ/S��Fy�Ԃ�~�� �!���\�]�*�L�p�k��!H���6FpS��J��JgK�WF���N�t�<vm~i��y�TP�%��߭�>�,�2e��V�Gg�<�i�YZ�J�=Cof5�_��;_x�xA�vi0M�vb\�/ti��U���J�5�f�|1g���[��<�v�z2K<ٜf�LKN��92#�Sz��j+�+N���횉!�%��x��XbF�G=�Ld���������yu��Wq�O��D�!�i�Nw"����Ѹ�-}�r���S���t�䦹E���/&}��a��H_�޴2�^�K�on�kA���?]�I�~F{,��N(CE�����R�p��[�N���L8�Z�^�3kP�-a�r[�"�x[o1��p�^�Ym;���FO��,�c8��E}`�/��5�!��L�1�7[��p2���xM>d��g9^s=^����īH��r�u�s0|S8�kj+�Ǐ����ʆ �[ecш�s_A��s����t�*�~\F�q�    w|�s΢	�3ɢ-!�U��;f���'Ϭ�r
&��W�5+���˂��=a����u�E^�`Uٙz�@�U^n{���)�ǒ�Ej���t]�X��(	�Ǘ^lS��%���nP��MY9I�۶�k�Y��S��7��9b<����7���0~p<~0W5�PܕJ ����S\<���/N��so�`T�yTi�Nc��n�p��x���Kg���T$_�5�eCQM���d�>&��Nw�^A`�滀-�s�|��ݮӫ/�9�<�H�ÞD-1���s����^�ҏ`��1Ex=�aZS��6prQy%���v�m���kɧD�}�z����ӌ���������9�-���B�ὓa�0���O�� F�r��rv�^�6�a�F������C:�C���m�ϊ�@�����:�RGf�̡m�������������z%�1���j;��G�|"�Y9x^3aSI���c��[ ��������zF�=���-��`$�T�V;��p�
]x�R���"}�z�}�2�B)�8}�����������0��܄S�0�m�A��"�K���hΙ�����ծJ�~%��2��U%2MIU���K�w��;Q��'-�L�3$��.�<����	��/����[N�)2ޖUg2�[B�)�/T.7��Q�����Nb4���<Ef�2bsh�� ޏ�r��X�8ʏ����e��a�֘L�e��#�=�a���ydE`�mde���SΖ*2�����XY��7z���Sohݹ�T�%[�~-e��� Sy���aȚU�Q���e�_���O��;��ˈ��72�(Q_���-E��]Y-�A��mV���7�<L(�����VB��bjf���<\�+YZU�<��'W���ts�|83�fn��=�t]���-ysa2��� 37�����rb?���X!�2 $�B���C��䙛�s��.�WLrHIN�v}�-����s7[j4�p3�p���X�Ej�w �i5�T����-r���Ï��U�y�����i �דi���O�����S�~�ek'@��h37��d��h�s�!�(>�$m���ijr�l:lp���.+��������C��RN�hrT�c�e�� �4�+�L''�S�9�:�ȝH�b-M�)�˰h΍�y�2[�0r=v�;����ҍ!�dZ2���A��	��W1fj '����(�wj�%l�S�"�^�'7G�(F�dV�;�0Hj�8��31V���@�����G�����H�jv�|?���ު�s���*��¢�?_~��d�Q�'l�\XDzx?|�����OJ�O���f+u��y���ֹ�����ߗ�v��#&�?v��C�uY	~��#���q�/��U�U�AR�b��]�
�8e7����C ��>tSNy�Y�ڔm��l7b�����+G�ۗ?q��h�:��!��FI-�z�0-���Z�a�Q���61�B
�E��'�?�v����,�����3X;�p��⻔��p7q�}~��t.��w/��ðq���پA�-�$a�0UO]�z�s��-zm'l2t��: �0��$��F�EO<8��>lx�o^$���A�E�YO�2����/A�֭$5�~i�C*�wx���DC���!z�����8޸�~27p��U(}rq��C�H#�W6��{�o�k`�GtE��%�u��GA���o��{κ};u�4�o�k�Oؓ�Fu��h2$�Js�W��t������^b��m����L��G�̑�x-��X�f#�y�K�8S���!z�⨀�L{�on�d��,���Z5-�̀B��Rq�q:��� ���Vd�' �[gx���۹��+G|��j��AHDU�K�E\߽�?�~�+GE|���C<<b�X-��+��]'$�Њ{��Rzs{x�f=�h��^v���*��z��Bkn�㑮���w�]�E�Bz�E��}�p$�К[��@��r���u�p�
Up��Qϸh �����k��dj�*��x� �_�Ep皸e�%^h�5�������md�P���޶����0��FM3��QZ�Lyt�]c�~.eJj!``�R�����}��{����~��O��r@��b�Aa��Z��W�3+Hqq3��N��A��=��P���V���s�ۙ�Z�k6��8��t�����j\��l�)Ân�m0⠳뱫F<�)eC�������4H#.��W򩛯�����KO o���6\9Ab%�f��1�h�<�w�"�P\L�ya��.)m4?�A�b��퀋e�|�g\���K����H.��㐏$-8d�%�~�7�J��	����p&���>R�n�i  ��Mj�9��3h ���3NT:on�,��Z�A���_	DM\������;H¡�؇(;Ģ�B��/����^�0F6�+�F��VL{�8�0��*E �P���P��n�kZg�=	�rnP�Y͙g.ނ�;�!Y�6�#���<k�Dg��"�K�d�$ʥ��/�@�m,G~U9G.G�V�1�q�I�c�0�3<�SGZ��3��r�;����ʾ�<���H��-7�)O��)���)�w�!�z�fs�^@�,}����!+��܆��wlH�;
�rӰG\�-}/�BRmy�q�z��5�ɸ��U����[�rs9=�k��і�@}<�Y3	�8�W���(�נ-7��H�=w*A�f��)��qȫxK��MD���@m��q\��JYg	��i��`�Þ��YXH��-7r)����G�v?�W�k�ד6m���ahgyh�w�v<�J{)G�����GF���>�>ěa�gy����jn�h��+V\�|"=�w��'�ԇ�4�qǒ�^�LH�B�ˑ��5#����і�d�����ͭ0,{_�穐- �&)�: �R�hG�"��?�������5<c�r_�4E��Yx��#HI���x����d��9ޮ�C�-�%�B��ǫ���5��A�[Wr�.%�5��aH�����bi�b9n]�uU"^���A�<�-�0�t͕v�"�'���̥A��'�9�re�<!̺i����tp늸�`�h�8d�y�KKL�� �}����#�v�Q������,���--�@G���ǜs���Y8��=7�i����[!����u1C��-f�9݉aE�Q�]��w��;����s��*pc�Ӱ����C�3��0�'*����C�|�:��6[�<�5t�����[��ҷ�X8u�S�7�0�3[g�P��|����n���Kob��<��Gf
��R<��;M�B��2ַk���c��/p��Ա.�+�I��u�%�5��~=�Yr�&����wצ%�7/o`2h2�|w���2�����ֆme�x�!_�z�
u��ԷeXH6�=7q��1ڿ���u�H����ب��^~)%@��и��U�����`Ҡ���y%����[��6�x�s�p�Y�<*r��\	n�o�5��JgZǭ����Qz�o��N��ku{�!��:����V��z~���!�fy�f��<���d�N"��F�eWO��Ǜ���a47�h��4y��Z�v K��)�����L7G����u�EMg5�v�O���<~~�}��#сی��[.C�Dp6v������g!��\'�q�X�A�!{�J�"��(����Y�#�=�v0St��!I�x\dB�֩н��.���j�]u*n���Оi��Slzx�+���m��/?����t���C���ӦoB+j����>��Wc�����j�:3�Zha*L6y������'C����?�����$��9࠭#{?��:����"�u�������!�Cu�3��[�?ݞ��'�Ub!]�, �|�S�?��O���.�G��N�����:$��3��6�jJ�YeF��.{2����,$ԾK~,�����T�q/�Wq]�2�sH����R&#^�ɠe��T1���h.3E\�d2 �������EG�ۼ�]	�n���:� ��XN���!��(Ud�5M:m    ���-���@	���o���#�ol@l?�S�!�b��N���Bn#=�+��������C�s?;U��b�M4�[Ƚ�g�/���(���?�8�s�0/q,v�ZȽ�#�$2�k���1�Q�G.�x�?w�[	Vt��G8�ڎ�I�B�ѵq{
�ވ@9��W���Jc#�7l&u�J�E�t�r��0�0Z%�j$��`UK�����!�<�'�����D��h3� z��hԄ��杁)\j����u�-�3�f⯔0X������}��â�[��^H�#W��82Ҝ��km(��T`V"5����O}��s��5xĀ���"x�\�S⥳^ObF�B2#�����
D��}��'� �Wn��If���c��c�Ľt%\ɷK��j:!,��7v���_����V�F��[�2�@ͶX߾|��3b�\<� t�+�зo��2�Y���G Ei�	ӑY����y�*`6���S��d�VZ/:R�i��B3q��pdD#F�q��x6{��b!3�X�I�b�ʫ�uz���.����B^3q#7�No�;�����b��IK�����c�f������|�q��A�R�J=�����W��㎢+��H��h���n!��$	���.�8�jt�2�ԙj$�"n�i1�d!��$	�ǜ�%46�NS�i��4 l%��/�)�H�{dgb���n�Ʃlj�@�K��nG���#�R�$�����E�|3����N�s/����C�)t�i�l�Ͱ!�$~�B��[��i~���Pch�T�&�(�I�a�z_�Y���)}.P�i��xYL�S?Rb!?���bā�=�L��]o� r*D	ȖL9,}���B�������;��j�ĩYY �[ ��2�pԑ�bC1�"����e/	d���)����v0F.�
Em���P�d2���V@�up̮,Z7Po݇/i�K�2��(�OR��q�u�� U6vcd+�-�C0��q0�����!%��IO:/�
�V�oVC���/Fs�Á �A���LRvIdE�-��i���	�������?�^�ͩ@"�	Ep������iv�R�]�����<MPq�O¬A^���l3�Т)�K��ND�b�S��� >E5+3���f�� kh!�qq�,�,>`K�G��?�*�x1z�ʠ,4*_=f�^��~4���[����Gc 9��:�]ģUm+4�w�q��~ =�V�0+���&���j�T�C�z����}����ka��1���fO ��8D�y��;�$�0Fq����z5�{
�3��d�i���v���������R?����ά�]��F��A�c,?�UCjy�qZ�u�#D��K��	^����1=�>�x��4��D⍤?����x��`?�y�V��i�6K���˗�b@�cG<X�=��3[�q`���;%bE��?���f	����Y�G/^)-O�;S�8
_���S�5�IcL�r�Q��&7h8�"^�n2�}�����<����:j�m�+p�L �◳(�A�c�Qs�0lYo�kpƆ�6y����Xfۖ��ͱ|-!c�t�o�U���%i �ya���zp��v{�SXp%j ג=�_E苏��X�����'��05�� N�F��yGbh�-��j���m�F��Z.v��iD�����1��g�`0��B��� �����j/LrW�O�������5*7m���I�#��Į�
o.��,�Bn�:s��9�T��g��������2?f�1k�ʦ)�#�"�,�ɀ����M��ڏ��rt�-�>X�&�!�A�<���DL�G�r����Q|�Z�i�`�͛���Y���+�,$�2Vs��i8E�&�b�������~}�sp��8e��v|�a�z�S=w����[92���TR��xDO���	� �0��#�M�`zĐr�8ۛ���~Ul��������8�Q��Ό�FGl����۶�V:�7̢)g��IxS|�|���O@�i���Y�Z*�A�-�>�c�a�DIg��َ���Y'�����g���Kx����>��<�'�΄p����c!J,� _��Ŧn�i��u,U�s��j[�ː�Ȉr�$��R��'zk[����!"&52�ЇPj��8���pQ
ζ9/�q�{s���3^�"��Qֲ����l�|�m�Mׯ�98�ihf:�U��/6{,k؜Y�ޙ>�>^��G��UN�N�Q�����5�xE<�:H�d<�z)~�i͒.����DU"v�t��{�{�డ��퍈�v�x�� 9���-b��<�z�`�f�~�x���@<�`Hr�[���L�7k���2�r�W:�\����R����������s�g���4����9T"n�����e���3��-충v��<eV�M�jX�����y�NRt���9�ih�0�s~��t=E�C�K����� I�	�Q�A�ӈ7�"ơE�6�I"�o'�rt���=�<͈-�6��s|��iq� �^z��Q����=ŋ���H�אT-��^�N�6�����d�@����[���+;H�fwyv�F�����.�I��x%\���w��%�
\�x�����Քpž�C����p���A���鎙Pm�x��q=��sf�x����ك��,������RAD���c��� C����8J9d�T��e���D\O����x��!C�A��ܻTc8��\z��vo��mn6��;"n1���;H�e�o� v]�۞�Ф�������ۥ{�M0�R3�K-�=�2(^��X�/�q�{y����;��u���w�"rM;�#{t��s�:� ���>_�A��C�2%��-�s������'8S���C�GY,��k]\��82ͮ��OJ".��t���P��:6F�-��&�@4}�:��,�%� ����2	�?V.s��(�J�b�Y;���$�Y�1�PƐ��\g6�;)�&��ȣ�����7 s���!	�uC���6&�pǶ�%�F ���}�Q3G(�'�sJ��&�'��t�z��^I ����-%u+�Ȃd��HB�5���� �bd~�L ����U��l���ڕ�:i��Y\C8io"w�^#t[
�\e�x闈[�\��2��F�SR��ܓ#�3js'r���!̌�)��C7�<����*��R�.���G�k�qé��0�;A�u��N� pW�w9��|&r���%��Qn���1!���m�:ϟ�ړ�&r���Y)�A�\/��;��*��zi�C|p�ڥ�΀�k��C��[-�G��R�@��N����sn�q����▃��f䞲S��#<)�	u$B��O�5^�����6rwv���-��a�^§�W�`#�g'��R��"+��b�D��:ߍ�W;�zb'����I�gHg5�l�)"n/�o0r{v�n/l�q[�� vәbYX�U������OC�;q��(�Q#��p���I�{�D���We%UH*b7u�h�Ho��z�G��$~'#4��Y~��d"Vq[��Q�<ī#'�O�{���t"�҉�w)�|(��[�<a_�(�!�z�i�O(3d��Q$���H�� �?���~ ��̅q=���C�:Jl�{�
G�ᷬ�o�zk{�M�|ॏ>!����ޣ�N�H9B")�B9���� `�[�� |��̂2��dd��$�"n�?��>mF��t3	�u-��m��gb �V�� �7c)�L���ج�ϋ����-e']�[����#vb/)]
�!�v]�"W9M�A��8��/v!�zȒK�A0���$81A�ˇ��W½�A�8>ۏq;u�O�A�KyF�v��*�kA��j��.�/���I��c��~#/�D>�$�"nx�N���AR"KI�|�Hz�H��:�׵d��=u:)\���|0F�x����!H������\�:�0�Ж#��v���)E�Db���(��+�lb�A"�y��
�"���D\ߗgdkh    k��j�p�`��P%oEP�8H�b5�6F�v5y�P��]���+���S߽)]��F��T���� �}���[� ���pss�j������|��8�H��t��"�7�^��8e���m�f��bAf�A["^��˗S?� ۈ5�.G�ցqO��Ѩj��Zq��z�'���[�x���W��i��aِ���Eܒ/��d�56��Ac�('NÄm��H��q�}���4#�t������r�0/��h�F�5a9?�r�s�m�f�sj�H�ӓ�C��R�@lI�y�Zd3s��A�b(`�;�U��~ܓ��e�I%$�&r��z�C���~ؚ�W��k��?����w����MM1&.O�j]4�z?��;���Yő_�� ��&�3 �Y�|6@G����;����dg8�@3�[7�Z�Y��w��,h�۳���i%p5��;-v~��0�h�J�����-e[����B�g-|��m,�obrs�x�4qU�?�ܟJ��ֶ���--��2��q��l�܂.�z��A�k=?�x�� =QMj�C:Q���!b��,w|j���S�����\�"��/��A~k�T��,Ԁ:���@�
¹/q+"�����>x��e�JDM��D�]�������PU��s�D\U�������q��+WMǧx	�&|�z��b2��=����˓��!3���4�]*\���	eZHs�;�!������[9�Y��AjK�i�'�h"-#ީlh�v'����r�#�y$��X7L��z�h#C����$�?^n/�}�>���#AWC�V�`���*	y�vY�0C�H9=�̓�N_I{�{"���|y�t�@��a)�G|��J C�����3�;���"���rz,�u"I�@M��{�� �͔9�G����K�v9=,��H��1N�x\N+�|���~��@���Q*��`�� ����,��D� ���0���#!>�`�z�dh��q�kw�F�ny(�2wz�`ɏBFM����B���t�� C���Ӄ��, ��E�s_������D��uG&%�����z��T��@>V�cP�ܓ�2�R��[�b�4Z0���-���h�q�P�����I�8kߟn��ک	�ڞ{�+��a�Ť�xæ'Ʉ{�&�_��~)�&�w{�GF��<��wyl���\�I艇%�s'��k�*�(�NE�~7䏗_��C���son&L�Qj� O�i�ᥴ��Z#��F��zHRb=w���Z�CÝ��f1A��G�H��<�>�ȼ+*P�<C�I5"n�/K��3"П�ύ����hb���Wğ��:	?l�������öo� �y�U�&^��������̀�a4.6���O����5q�Ȉ�	^A/���&^�
��һOX�&��O_�궇$%6pO�xӲ��O�����-�V����p���!K���%b�+��)�E�iB��������ׇ8t��?s]��Iw�_����&nw��COR�!s�����X	(l�GOY�;*�@�nO_����/p�7�	ڹ�+࡙s34E܎!��o���1ݐՠ���	3�|ߢMīRw{�=�/�3w������!�ΉX������YL����=88J �^�!��I#���ux��Ϣx�cbg����PY=v�JH~Ҋ�]7?(�$1�3��G��7�=�\��w�=D����O��n�K��a*¡�EV���a[<�@��Nw�GD�)���g���u�pn�h��K���?F��L��;���������+vtu@=o�j�g��tl���������3�D\��K��]a�?�/*��K���R ��F�S��H�W ��Cuо�#�7��C}`�>�O��{�n��!�(���"��\%6r�؎T��� +d��~���t=HD\�����t{�C��/r�؎�4��2<4m&@�V����垓�y�Vb#�~���J���`B�z<W�@�������6�W�2@�����璉��/��ۋ��]Ip��l���W7�B��}*���=_��(�QF\m�q�c�8n�����C�����D�q�z'�a%���[(�x��t���}^�
:z�x9o��XK���"$^����}ވ�f�+�&�	u�Gz�&����|���\�����s)�A�ۨ�����0 YK��]�?�Ě�^S3Ҕ��E�4����E��M�ݥ�ϑ5G�(&Γ%
(p7p��swv��`���a;v��^J��M�>���JJ��}�?�������LjM4��	��ѹ�;�T�9�{�ľ�ۿ�[��)ˤ�E.��S��p�pA��.L��qKc��=2'w�pA�uZ�9���~fK��7q���=Y���/�2���R9��Ωc�t:�ʒ�s�D\5���I�.tmt�=>ȭC��6�R؄ Gʬ�C�FIj⃩���"N�N".↸�4"�!M��45	���1
�2��-?����mC��{�,5	�?ƌH ��QA�{�	"nG|#��xHR�(IMB�@��~X��9~��?���b燇�4���$��=�
��-�+�r�����v�r��:;�R�`_W%#�as_�gT���ۉ���Qf�9�Q=:�m:��s64A/˨���Q���|�GϤ���s%.V3��N.���)�������
-�ܘ���(�f�.?]�;̀>Ps8_G�Np�V��*h���V��PsW8"3�q,�U�.-�4T�"��N�Ԑ=�i�
烻*��`�\7<jnqE\{'`�
5w��u4��8�K�*`�x���.YT��q��^Wj���iN%�I�ED���:#�T��>q�.˙Q�q������?"n�-��<�Sq�;�yח�Ǉ�m��ș�\��i7g~*�P�sҪ8������}�}^�.�M�����"�C������(����)�'=h%�������SF2RGg����q����u�G^�[�-�{�J���#�Qfq~eGƖ�!��E�� �Ym��^rD��	_�d��<j)^aM\���!6��8�|e^zr5����\w �4q;q�L�}f<�.��F�W�`����:�t~�tî��8ýe<��lޖp����MP�q��Y��z�r���q����vؖ���>/�!`�L������@�g�����uܣ�*w�j�(��8���~2��'=�|N��[�x}���n��O�+��
�q��=h�$�f�^~����{�|��we h����>�=��ū��LT�H;q������Ϝ}8�v�x�ȡ���#�ǶЖ��SfnL�Bś�A�x�6=$�qVs��m4+�݄eHl,H�5%){��?�<��8k8r������!�ʐ�|�ȋx��ߐ�Yˑ_�$n�`�D�h"^�x�ozf8�q�u�r�+޾����5;<�ž`J�x}�?���_�z��[Z����f�W�/��y�{�K"���S׫�q��ՙ���^�1J��VJ��[Z�-Kel��dD;`!�Ͷ�u��BX�8��w��>��p�����%�������IC�-7����7B�SLE<�J���q?�]H|��"���d��8�]�:�I3�B&9��M�N���ɓ=��q�;De���P�=.->�u�ݠ�n0��g����4.�[����瞑�C��l��h�=�W��%�S o��B���S��r�r�`&|{}�ąE'�Y�I��7�1����J�
x�%d�(��[( Cg縳K�7G��mi��7�m 	��(5zH|��sz:�#Ӽ��9�sVҊ+��k��t�,ȿ=$�q�{<w=f4%Q���ᎈ+�"��}�g>����Ĉא��?�ض&��<����J�˵0�^��b���l�GbΆ��C�kBLl�]�o���;�_y
R�H�¹'� �f�n�)N�}�;(nX�fd)�%�"n'}�Խ���q�'���m!FO�$�+�\`����1���\�X ����&�!��%K3r36�1�?�~������m5�5Ig}0Џ['�</�t�]G���    ����8�j� 6�Q�� \?�i� l��/1�Ҕ�$!>Xъ��fp�Uk�
�����ӳH�Hm����s!�a�[���u$7طg�9
���n���I<b9`
=�B#L]o��[����ͳ�֭�w���I�5q����� ˉ�Hku��S{�1b�"4�V7�7=���,ҝ8Jw��� =��^ܱvp�E\!?���W�x�(�I�|�R&��9V�yx�������3�!p�!m�-XM�_h��<k���aٺ���c���|�u4�"cj
�I�d��"޼������w�z��5֮6�`ר�S(�(&�d9q3������{O�m�D���>�� 	N��ܠH;��n?J��B:7�:r媣�!�����gD�+�H��UD\�F�@�6q3w�� �۔
�BQ  S��Ń<�x�d7q3�؁�u{ǭkf�E\�^�с�_.}J?@r73������x�ô �yՋ ۪�B�,�:��;={pd3n-3#s\���	7q3�¶A:7sgNz��5J�Q��a���x>��*q�l&n��?{]�L�>��� ӲU�M�fq�^x�L��&n��^W����ț1pE��9�(�?��q��|F^;3��W7�|�9O�G
dq��7��ؽ��7	�G8ߓ@�&�e��w5\�B�?qkj� ��dC8�&^9�}�-�E�MܵI�uk���]� �"n���g`�4�E���L2���N<����3�yX�BIX`C��kqǟ��}H��H�noA�C!c��ܹ��i�։/�k��!��� u7�y�KO }����$j�#C9����<_�zh�ɛx̀��);����h��#�3�"�X��#�Iy�0yM���]g�ؽ�⻦�?!{�0���"P+��c�W��ёK�����|+!t둻�����4�Ƣ��� �X�soIС��	��n�1���lf�[���!�|z���E}��GG�|J���8��h2����ç�@�[��#<{�����?�Kl�����/�=��c�T4D�̓C���c<־��������o� ���x�#r�ێ�A<]H��65"^��7�@�ğ�i�}j��^?&،7�ds�?E�����^	���O�����|u�D\5F���x�1"�[����Ց��?��d.~��?\���8w�)q���">}~����=8y�A�~$a3}W�?�|�B���w}GI�(���+-�@�����_ϟe�R�x�9��х~�>�����A@�m]C*����%bR�x���(����3=������_<�H��1�,�Cָ�+�G�CZ����)�ю�G:ω+��E\u���N��v8��ٚ�
�h8��(�W�!��W�!���˯�t�kU{�;� �$�5���x�Oz;Ž�Q�*�x�;RaGK�E\O"��Nqo�
��Tw�U �F�	��	��x�D<
���Nq_���mU� �O���_�L��	�����k�邿j�*n����v�^,T=nŨ.DY��xͽ]�4���%O�AA"SE��ŉ����s?� y�'�-Kp�#�R��y��F�ܧ�'��(����ܱ�H��ᰯ��e����l���-�pCgB�P�y�
x��ItU�sVk�{�+���T(�P�d�ꚗ*�=֒��(`G�ý�z�q�J�o6�� ��
2U�tX�,菗{�v�(��d���
��
�亠�lZ]0���� �O<a>Q�~s�'&}��!ȩЖ���E�"��O}'d<��dA��h�7 V��P�"���-�{������x�z�U�*�{h=�:�`�ms���6$=������`=}��و�>��F�m↷L�S��d'�p�2�2���>�%���l4�0
�N<a:�z���`m����X��x)����7�����dů_�8K+B��p�� gq�L'�0Gh�(�Ȋ��ʆ�ϊ��,��d9Ѿ
�uC3�Љ
�j�M����] �3���MN�>���,�t�{9��z��3V�gl��1�L�<������S�Z������ś�q�C+^�Wϯ�F�孡TܔYT�!�7�㝯�;�1�_�΍t9���H��-�ک�z��kەP�u�<U�cGH��ډz%d`���W�U֝[8�(��a;B'pCo��Mv��x�R��c��nI� ���}�c[�������I���u}�T�����.B��+�r$=oA<8�j��ěn<�/BH��-��㯔���/М����N-�?z�����7lt�uqߡ$h�k��v�/w�?��+�r���(�AZ�:|���}>}��*��Z� G�u���=GYO1O�k6 �.�r8�wt�#5��	����Rq{��2�x�y�A�o|���������B��ɘ���@�{'����� �C<�l:e�p�M�tA�t+�q�s��0�q{C�<�Rhq�M��B{J� �V�c��O��E놝�c*4@9������H��%d^��r�N��#���B�MܔC��9�pjQ��@e��2�_ŭ�v��y��:@�9�����u�{i��Q!�bW��/_����x8��^��wc�<*f�Ki�f����҃x��Iu	Tgc
-�m���n�P�����_  A���J��߿���]񡗕!/��]�p/��71��]j�:t	U"�c�Vu0���"�(��׏�xo8���m*O��c�0��[����Aߞdab�!�p�,ؗ��i��IFzG�I�p�b4ي�:�G��<O�R{Gq��&�Q�����XG�) ;Ҁ��w�3�����NE�^Z�"��|$�,��U���бd;.�Ha��Z�"�`����ܹ���xBƒ`�	[�bA��Sd�M���)p�᎔�=�����,��%V��R�0�(�t&c�5Y<vz�|�zDB��G���
�tY
��>�$^�
	Kƫ��c7IU�P��^33�>�ܛH�����t��V"�]��yk� ��ִ[�W ���_9���v\�WuSnV�ցC�l&>8~��v!���;pZ�����!~>u/�r���9��Gl�R�Y�w�0ⷧ�/�%���l�i�����f�Uy�����F�DW�!|$1���j�����L�-}^7����]H`.��A���!H�|t�����[��|�����s!��O���5�f��z��>d�|ȱ6�
xܠQ�!�:�v��3d/�s�:��f��׮	N���*�Zk��{�g�^��_�����NP��� [>�1}�X�>n�����,�o�I4�\N�}5���rɢ¿���3�/�38�A�h��^y]Ǥ�]����5����;�Ey`�-��DnE��SM'E�U�����(���?����:V��1���J7r#�7!{�w�v�f��8��'�}.��gi�����ω| $q��z:����A@�ѡXz�Ϝ�)�+�	�l� H�m4"6Rm�r��������Xs't5}{箷sw����q��S�]����/���:����{�č{�P��
v�iE��c"^�ч��ġ;�Ᶎxp�y���Rq����͐=�G��G���<�I8Q�'�V����m�<7�ñ�[��i���bs�>V*ޢ��k�2>2��#i�4�o��)B<Ґ����{�=�*FԐC�G����U��b
lT])��n�7�!_.�D��ο/aTl���n�wōmv�e���5q� �G2�����sMrFo\�%0�M�y�3��l�m�2M��>~��0$؉�� K`��N1c��F�7g�$l���t�ofH|�b�y��<��`�x(��.�Lba�K��Ή��S֐�$L~0I���&i`2�eخ���PHk�I�1�ByLH9x��JP��T�\3���A�@X �<FkR�q�Z��i���=����6!��l�ujR��Ka�F�������|�ED�����C4��ތ��0����r+�tS���n/� ��	��Z<bc��
�C\Q>�Њ&���?ܝ:    f��@�E&(hj�:�C<8��� ��!K��_�7|���S�x���/��x�܎��-��DΟ/}� ��#N���D���l>)n�tl���%��u9��:̻�ŗ.����d8��"�z�ȁpwOڂ{�~�s	7$ �  �m��ѐF�hM���n�z�?�������A�N�3h��<���&{'F�c
�M\7�&� �}��jw@B��|� **ƅ����I�AƷP�\Habʡ��+rz�0���M�F�S�?�(a5��2C���x$�/��g5Y�=���@\�&n���t+���)L\KF�Я��鞀>S�̤֟u�GV#��'(~݄y��u�����K�X�P��wۈq�1f�4�:rD�5�sz�"��/u�C���?��!�rƻ�0���w9�0[|{����7��QŃѣ�_�JǑ�[���a���N��G�8s��=A���K�W�fh�'�X�RC�����$?�w,ހ�Ϸ�����oH�]X���o0�M��yDJ��7��|<�xg�Po�Kj��nN�	 ��f#���:���#���P�H�4��R���"������0o��� �\'A�K�ZU�H	�^"����,�R��x隡!G��y���L�R��R����J�HG��iH��#Ssp�\IW�qZ�T�a�ٶ]��`���m��;��*�%� y�*s38��&�d�����G�_��Z�;�x��3I�����o=��M��w�f"��\��^����i��Dա�E�f�E�r��5�AJ���o�fE�z���?R���^"�a�F�=����[-�������u�%�)�&n�����0�3<�K�vSS�iS��o�m=\gT>��ӄ��*^+Y��~�s�T`As�~�]�&?C�.?3	s2g�ZG������p7�F��f�/S�⨋�]���0����{8O�#F�)�JB"Vd0�a�ea�]�z��wx�5p�jP0Ŕ[�PcK9J��;����ϫnz9��g��59P��������$;�[o�DH��zR�S�j5�HS����&9
A�)����w� ��9�O�?�%�c�ԇ~UBz;�AȔj��A%ܶ�2��C��A��`��%u��A�bz�K뜐��Ԗ�7 Y#e�X�!�A�7�j9~���������5�4��n�ΐ� Pn��`W��߬�"�r���L�����%
X��XJ�l��v�<�����M�8Lmh�j��;�G�g���\0!]�Tf�Eu�.d2!���0�-��<Ru⛘u�D��vjz�4�u7Ν����H0��s �3Իs��q��C�%���aF��65��T�6��ַ�}<�p��7� ��v4wbA� ���
aH��
�F>a!�P�tC	�A�!
xlr�& /VЬ��SfI~�8(�P}l�G�{�lM�Iйӵ��,kB���	��M���0m���mnAZ�����iyI���c��2��I�<�\��b|�)�ʜ��u�n��;Rq�5�(�!+4�s^Jx����
����k�4�1ϡ��a��$���g'���y��2�A�i2"��?VH�A��*�}KK�ӎ����Ք�*�F�X�N�^_�a���� ��!{wQ*�ԁ2-��L���
\9 ���:^�3����n�S���Ix�����S��d(8�����Q;1̍�s��-�-b�������s��(�v���8��=�i�]]��s�K��{���;J�f���0���Z��6�lX������8Bv����0���Y��Ψ�O9���4���E������܉�l�0<w��`Ã��`�b��L_#�?��*�v�w�>u'������A#�.�����	��'���I��Z(x�����P ۼ��rk���n��N(x�C�l��6y��J7z��yw��Ʌ
i{�v���	�,��1eQԨ��v"R.�a�ԩ#T���"�:w�y�B�-�)��C���9���Z1�)󍜬���&�ȵ�`K����q�\�"�C�y�R
tU���N1��)����%�0�~�_� ���r}���i���`�\�a���୧s&P��*���{��k� Aq��u�f ��H�򔇼�b���o^�����'�Α,O��)@����ɕ��w�p���.���[{S��}o+�	�����Fx������~A�aD<7n�7N�h�5v�)M�LP� �"�"��?�3��XL{q}*;�~:7{�EU�D����0�thۖ��#���ѐ�Yx�*e�H�ZH�Ld�f,�u��X�̶��._�ȧ���v�������!�P\3�d�:���eo�Jج�r�Ģ����]���¢JH�*"v����^��v����6T�y�k���2� �t��iKؐ�'P��.���}?�m"bfKZ���v�vi?��n�T��5-���/�D���_�.MFzL�o���,����C[�*f�w>?^z�0:��N	p<6Q`��K	8�W5 �B��i��ˎ�&�F�@)��!�ݺ�ac����]9Ҷ)�5)w��$J0����R�b�l���l-���U��z}j������3��_�O��Q���a׎�� ����x�*�8�_K2��4�8�4�*���9�Bq̐$Dn=���������tF-6I�}�6�X"~X��7��7�\=v�O���u�iP�j���)/�Z[��:Bʛ@)oґ�?|�(�ю\�#O�|�S��H�v��ۨO#ձ�{����V��Z�D=!r_��c�'=��yVm��I�Ĕ,'��߄Ȝ�2G��+U��Y��'(2�{i)��}?!�B�L9R+��NP�1_¶[G�&�i�4�>�?t+�"��	�s��0�@�ȶvp]��Ϟ���7o���t��s�g�m?�)�U(;j��~=}�!��@�0@ �������uC!݈�&���d�牛hs�X��sR)�L-n��Q�!o H���U�pH��C�Bj�sB%l�5��d��'n�����Z��P��cNQ��{�ZO�@ς�$B�y����D��V���`�R�'�Wc����c�3O�ƙ���W�YX jx�����Ŵ���n��.dŚ'�8L��h5i�dY�"'lP7LC��	�d@Z��������D�E0+~�R�������u:ՁlM�M��,�G�š�5�#���HҮ��U�\����j��
X,��Aa��cP�~e�ǒ��(��O4��]������ �9H�1O�ah-^�4���8	<M$�]��o������Q�
�o;jk�T$�=.]��M͊���,d.3
\��=���w�S��pL�?[-�P-ĢD[�u[�3R�	2+��y���{��b�x�n1����f�&�-���p�Q*DH�1+�[R���(i+ˢu)�B����@��6D�7͊�{�;�n��`��`�����c)����Go�!/Ȭx�anV�[Űp> O�!�y�Ձ�]�|?����v��9�m�y��+�"�����B'��L�A(ڨ�f���������2&��U�E��k3o-H&�`&3'l�,5�v*��`dᰤq�H��������� �ެ�{wB��Ń}��u}(ŀb��Ń|
3�Sp����-�d�,�Ѵ�}�{'��vm��r�iNT�y�!: �LiXS�:��}x���f+�cK���?��`��!�>�r��mԑ�G�9�iu⋝�P<��6�`TjIT�މ:��R�=�}���y�AU6Wز�� �%D,��J���&�D>LC�|�L�ˍ��׳>�+�`_�#}�˕p�K`��H��Xj�H:}^X ����]]�q������[���ޱe�~rW����e����*�<u���#�z�Y.u���i�rqӵ�r��2�w7鍫���ͤ������i���\p�����</�w~�U�3��)�f͝d���������+,AĽ|�E:��5и�X|2�������<�v͈<=|�|�+H(3k��q�j���    � ��	HO�r��<uK�"�g�5$$������ �l��u����l��LNi��Z� l�`��vK8�����+���U�L�Lyg���>_~� ��#%�K����Wf�]��k����-`�v��wNC�>S��8�X ��6�sXxqu�'�y���V"��è9�f�i� �ĳV�����H%v�t����a̵F���ݞE�N��t�?=
�U܎�4��kFSO��jK�Z�N��/��n�����/�À�s���f-P���(#�٦�i�.�o��!C�l�f�A�����_(�����4��t$��t�1`.��KwmJ�yb�	��y��z�_Ώ�})��͔}/!>�fo0ĵ��#I6}=?v�j"d��a?`z`�3u��C�#Ώ�� COM�������	��g�M{��a�:~�|�/��-W���h����]�\V�䑜�J|�c�L���6�I��Qź�y`�]��J��ʴ�Ɋ��)�f˓J�`k����;I�\t�f�fk����Q��!5�lxؖ�[���rۄ:,-���!5�$���������.܄l����Pp ��(�p�,���U? nH�5[��F7r��gP�K�2%6��˻�6�,	�"d���*r�V�� &��rfL�k/=��`�ay���綾��]��}�QEb���Mr�D� 2[~�Wm���wz+�ӻ�����2�S�I�������Ko�!G�l�\�=ӊY�d#�Z�4�����R1\�+�֗�̓�X��'��l�q��*��vC8�
�ro�Vݛ��=`H�1;v�*�*H)xJ �.�~�nty��y��	�ȿ��IW��Sea�W�C׹Áw�9�yo�Y���΄���卭I���!��층���-���� �bl�z�|��!!����d>ǔ�k�Y!�k�`�޷7'���N��]"�l+��?���.#���PiI��^���Yo��s<C��qw�Xծ艦�Qּ\Bӏ)��_��KI�fǣ�T�i�"��4�Žt��3��G�
K��/�Y�f��Ɉ"��^�fj;h�a�:��D��}��>�(�W�khd$�^��.�_3�w���C��!����?0�Ci��z���J�j���3O��1�H[|N�������Rb���?�*?k��kO$!����ѫ��J�m��b���.�f,���t��v�<��fȜ4������Dx�.:avߪ�����}�΅���wy�H��'+Q��ׅ��*B_��[���:0<�΅_�_O�����@��L����_5DNyF|v/�K���P�|ɞ8y�y��ؽ,g��qğ|�~1�<vT?�x*2}����ܝ4았=hŃ칮n�ى�3�ՠ�j+	^>�o�Qàɳ����i�cYnLw�/mп� k9�N����� ���g��>��[������U����(E$E6�{-��at�j���{|�v\'v�N�EOi�=�F9�����o{=����x)��^���J��ֿ�,1����қ9H6Sb�E�S��HP�7*	�i,f��C���R!y���^3��<��)Z��A��d�����lr����4з�|��h�)T����(o�C	�|�F���ţ�t5��b��0ң4l���ms��n҂9�0�W���mK�	��1��(����5�w��2�46�)O�Q�P����Y_TZgz��J/q1�?t
�aȡ���>WT�ҟ#��n����B�!�`�b\�g���<�BS�T��Z�q���ܽ ��.D�8��-���U�ri��S��.���V��YL�W��������fO��`�u^" '޻�j��r��;]�w`�^�5��!I���b�#�;_�VPRs+�w�ɭxR��n�͔�4����{��@��Fq��\+W�1�r�d7Sn��`��B���Y�GUj2���8�W�1ǽ�n�����Ŷ��t�"�═�Ϟ+�>8ʂy��}�#���U(����V�<���]�	���J�l\l�oR��y��$�#?hu��o4"fi�ܭ!�9�������s?H�54��G=(ӿE7���I9�nZ���H�H<l��h��`d�VDsy4ȹ����A\?�p�G�q�Qw��#O�T��%ɱ��e����ȯ�8�Qi޿ҟ��zX�<����Ϗ�}���Bqb����(n�����-�-͗[[�K��h��"C������'J>�.ln���^X7��"�ƃ�2�f��E��([SݚjfxὋ���EEL�\2d[iא���Ƈ3�7�N(�>�Ҩ��G�k,��1������?/w�ȈӤD�v�r�8d�{�,�bS��H��'�Hz�һ_B΋�6���{$��������k4T0������C�J��n�qA�\^ڟ��+���.j���ю�C�0y�"Sr\��6{�����Z߾?���jHJ'͡�c�~��a�AQ	+��mZ�r/�.��qǩ;�s�DO��MB�].n{�.���9���7xz���GE�´&��ˬ�k�G�~�x��
�s%�+!R�t!��)���W]�	NvD�5;up��#M��J{��C�� /�F�<���f��c&6ʤ4�r�UT\!7N�xb_�S;����x�Ϙk�8���en�{
�Sŉ{�Q�� �>��0>�R��' 䳋S��K4�Z���Az������L2gCi�0�vA��Qlx��q3t���N��N�s�|��pϙC�(���&�g4�V�Q>�,����+��|�C�5|Y)�eփ����g�l�G�"8rO��ǃ�T�k��<}]S��{
t��_�K7y=��ӳ�s]��;������$谫�Aw@W����t�5�<쎚{us8��v�P�!��z6%�����I�F��s�:��BG�IטS�REb�������`hO�'�OW���E��0C���d�*��<�|U��.~@=����X�\k���gO]pCmV]�zup��F���5 �k��r]��<Q��)��e^"�2_�H���t�?�BE��K���!b�!��5�2��6n�xYfy������F"��'QsOc��m=�������T�i��������������_�o}���Ss�����f.}��ǧ��m�I������CO���Ls�b�Ѐ��~^(�X:�Z�����8 E����g��9\��Ox3x��`�@�\����'�XeѠ���~��yj�6�h�-�i�&�7�f𵡰�����������:Q̓rsmh��D�,�[������_��{$��T�����̹�m2��4�>�_6\�)��׎�vAl�=�l*:^��4�
!��Y�ə��<c���,Ҵ��Ӏ�W��29�%S��뽧����Ǘ�w<�y�f���L4�!O=�i�T �>BI�g����1�q����k�2�즤alNIM(%�j^Y SR�l$�0Kt.G��)bD����B��ф?��t�*��7�-)�F���X��?]�d�Ѭa6s��,>^��*����܉��J���Ml�Ty��ʦ� ChxӢպ��=^��y?W��^Z�7�|�zw�:}�I�nGa�,��/C���<�oH
K�P��@��ᐡI�L	r�A�(���Rh�B��Jj9���KS��������MCiGh�^��Ż�u����'AMa�������5t%��%���G28�_�����K����&��jv�#��i����+
��X; ؓm�e�%�	�"%(Jj18�Q� �#&�E��sn]��N�e�d���1.A^��K�#]Kz��wj [p�����w�Tq�R�-����ކ�qHi����S��D����p��ɇ-�����x��#�Ҏ��d�ZV�O�;��o��o��x�7P�7�[����=5��@�H	jҿĢIM�u��j{�-xy���|�Xe�m�n[f������K��nu6�O��<:�6πn/��pA��9��`\ �8�S�6�f�G�M ��0�<qץ<Be�\��mu_Q�;����_g#�� uQ�ܧg���>
    |`�3p#�a��K�HW')pC"�����A_�+�:!w���_9Ä��Ǹ�y�+!�Dt���`R�u=i�GF�gV�x���;0������4n��(�u�!EI3"p͔�n3���S�n��-���<�&��llG������z>Xy,�d܍X��(&iV��!�Qt,�2Gk�ak��\�w"�xw����g�\ Co�7O��@���=4�|,x��|H�]��*aė��<������\޷���	Q������)������Ț��xJA۞(6d���/;��@��D��001�0xrl�<��n�\��DE�5��s�w�C8+�4�ȈR���-Tz<eNw��:�8���3���ӴY*�v�}�6��ӏ���ӯ��~It���3�禃��%%�=�i�]�������S�
2�Dϟ~�ɋу�г�Oqj��#��Q皿��������
Z=o��!��!{�Y|��S�!w����'�?H�E!^��z��}͏���!C&��b�AхZ<P{	�n��>C�h�=�~6��S��>�΢i\����mI��|f`ww�~sf�F�D�g
swX]5R���du���ׯCa0 �K��.YNG(��s c��ۢ�.>D);����~s��H��(���g���z��i�>t��̼t�q�:0�ї̱��!�>�����5�g5�|4�^�X�s$g��)���V��\A��7�����^4�m ���*��I�14�0����*��;a��'#fk�0��;����4aP�"^.nα�`�u��Uw���МCk����ԥC쯘����U���j�t���[+HI����el$���XzLFv����}1y��6�G��B%0�^?C^�X@,�VC���(b�XB��p.Z�:V��ǯ�U�9�m� 3s��a�m��q���T*B����t re*m�Ӎ��*HX����
�gо�(Ap�	�Lj(]�P��=�ッ�iXІ����l}C��U��74m�Ňm����sͯ3��{��=�3=��� f�R��|^��M!���x/ C⌥��Wȣ����s���c3/c�c�zWv[9�2]-�DC�<�kȨ�N��cL�MUy�}� �0CW�fD̃��\Ȣ`r�1t�.�EE&��H����0򠋦{�|^�@�K%�q=fT m�R�fDăK^�O��,g�&H�q}�tF��ȵR�h���"�	���\�"9�9��tt�؃}�\��0�n���@��DfZA��棇���Qe�$�ym�T3Q}����B����l�(fڭ��a,4�!0�jڊ�IO_�c��o�[��l̜����~��F��T���SZn�$@[j��	�c�Y z��ꃆ��Һ�ŎU(sy&��g2����u��~���7,��X��6�qG���)�[��;�)r���w�sUA�eim�G��J�L �HO{��m	����y�飖�>*����\H�L�<,�Nڴ�EG+���D~a*�����y�jNz>�P�v�[`�j
�+��F�uؐ8hYX\\~7��;!��I�LR��o���:L��&������@�D�t�J�AOJ���??>�eƇXc�~���ǖ�����P�F�9�*��twyb�"
� -K�]G�w��������+M��ai��rK�����M
��,K[�,
�C�(昦�'=8����nV:�l�ϒM]�m\b�l���G֛���\��$��g�X����E��s�r˙�"z#���I��B�ӫ
��G�H�<>�SӉp〕��V^˱1�y����~������x��7�L�
1!�n@�?N����u��-_�7BV�X����iz�q ��El,D�X��V�zeмCC��J�Xā���h������4��;"����g:�AM�*a���AtH$�@>l���v�3rY��,m5�w���	�e!	�
x|$�Y�]W�����5�n�>�;g1J>���y	�4�Y�'�u{����!�U+K��}D�C�:��jrnz�2�L�4;�P3�۷;(D}C�b�[�ع����8��d����� ��B\�U#���6'"���������'!�9�l"�� �1F51FϝQ��c�̟��QX�0�c�$d�}���B$�m_���t�^uuۃ�M�i����	�>e;=�Yd���IC��}l��ƍU2n�@5��Gz�|��+�
1!�}��Oj�WF
�DR��D� ˎ<�[Q UD)D�~���qM��6����R��rF�tЪ"�8�f
q
�>F�x��kCY3bh�:��WӀ�aH�mH���#�ㄸ����!BJ�K5����'a0�h��p'l'� �S�"��ۃ���fyF�m���GT�u}��P����~q�
�!Jb��@G�A����)tR	�t\r����G1l��_H����t�AF "�;��-�m�kd�F,Dmޜ� �Tep�cY%��H�ʋ��kJ�4G�}!����a�zϨ2�$��:��4L;j6�k�ٛn{f䜗���0/��:_�1C�\��s^�g�"�	s��9��	��q�s��E�Fą��� ,Q�]�"`6�yk�^��=>��1��&��)g+w3����srw5mpw�]���k���d�;�5k����cT�~��Hs������]>�?s?���8�A<�jT!���5��QQ V��~+�
�ꐮG���2�@YU߼�!{b|7ϖ�kt�� �7<��+!�X�H)�M0��&���*������J�Xa��a[¹;�?���#�8$v��A�6�d�ΙX�-O6�+�R֮��t�Ix�ՙ&��*�#o,mC��o����j'X;T�����c2:�8�fK�b:J�8��l��/'N4��I�4��q�h�m,LBEe�����W�X�+��q�z4�7r�c�^g;�1�ӊ�vI�hk"=!Ӏ	�i~I�_�&y������S�~��^�*�皗����[>껬#p�"�O�����x�BƌS�����u�X�Q4^��&��8�BD^$r�\��4;Z4\M���	�e�m���^�YX˘���H�w33�Z7~LU��O/"�C?n��\v�sL�:̊˪�䄗I�h�Q���
-�o��v��Wv��J�������XD����%�ˤ
z�z�;���?����^�}YŘ�^�_������d)0��m��ʁ���{:s�xG�J �9��֌'����M�&���b��<����N#��CB&MB��>��i>�%!G�x�{o�z|w��NJ!�i n9,��eO��O[ �Z��E	&V�M�F5c�2��4*N��V*Z��[�� d�B��K���c�ę������;q�B��kH�9�N��G��ʓ�B��������Y�����j��At�5h7n��Q��I�Vs�I�(�x���k�s쨠Z�1X��f���8�E	�*���; &R�h���q���~�k��}LmÐW�?�_�"�#Q��A�\�^�� �WT��
Att�[��>�`���r[�qٜL�iS5�$|5b7"i�w'=�ݷ��E���F� qk��Oۍ�I��Z�ND&y$<V�w�Dq�י�|n�N
�'d�ӑ�z�U��k�z��3�v�� cƒ��rq(�8�z�8b��.K�B�U!�<��o���)�N�O1\�.�%�-%1\#��j`���ǌ��1��92�JB/qo6�aX�mX[V͝�4m�0e��"������Z���#�y�1�_��(���á(�4�ڞ�G�Y��\�(!},~���fכӆڷڍ�����/�~��Ic��E(���ɏ4�c��b���������	�!����r���dѷ�?�kib��ph�t��(#��'�J$o:�ES�Ц�1����O>j9���Io�w��	�4�ql��3q)4��Ql.�>��T���rb�t��Xy��.1,ְ��ףM\�"م�&�F�>�����>wǠ��}b!~�~��Թ�QGJg�1O44�cF�F���X���~m�8��6"���i^JCd��>BcQ���(SL���	��    �"�r��6���h�8�+�f�0u���� �sǒI[�f�/��<|nqg�zc�Ó�E�N9��r&�el+�ȟ���M�h(�P�A��z��=5*�1�h�X�����ϒ�Y#r#�Oi��|�5�N����I�u=������5b8"=��x}�4�c@��X���w��Q&���H��1�A��
3\�˘So��H�x�?�,�ȍHC�A=���љ&Ԟ�h$�Re�>j|��ad���2�,��-�$�Zо��j\sa�#4=7JJX4�˘�0�<���,��ЈC��_*����t��M#�]��x.\nW�x�Ixgv�wKF��C^:A�ޙD.:��+��ٗ;��r�sRĻC�/�!�tu�y�ɲ8dk+*��{�2���l�><?Vhc;ᐨ�&�|���[����4�1��(Ɓg��q�c�͏�qs7���}��Zv�<c����Bæ)dl!!�WMd��85��w��'>%��i����(lH1�a+��*"uv��񪐺As���IEU3�	�.2��ZKNN�_O����2�&s�1� �r���@`Y�b��$JEI5�|��[��נ�[󠒶�*b��o������-=���i�Zn����.\���>fj^����dᾲ���#�y��7�;�-�ω�����{D����,[30pW�Wt�c���A�0�y��������i14�=.�bQSED�~E5ՊXI���\�ѦhH?�*�2�	�7�B8!諶$۱�E*},6��ޛU`��ft�jj�:��ѣ�$�:���NҚ�R���E�1\�U�uKg5�ӏI�T7�?��a�Fl���Q����|���?�3F1[M�5���Pmy̶"f�ê�/��5EVa+��|��$Qjj���m�w����6�V'��j�����~�aԮ���g�%�+��sՊ�׭��Y����-��ɖTE�D�lޅ<�8'a�;�r&�p ��lm;������sĐTM-��p;��]p����^�^�j������Ϣ�Y�T�ZD��H��F���C� �7��h�hT�O�ˡ����{~O��"�<�[l�G�����+9�=�oNb�,Kɓۅu�L������QC�5��� �i�[�<���\�Q<�l4J���R���|�9���|tɻf����j���5���&���Ʒ�lL5x�q��kC�Z籌��K�fI.6@b]�� d�5T�5z�2�;���:��R����&*�뛟�Z���ajj�H�=��X-�+��&����AS7W�n Cf	���Z��<Ul|�FL�Ӭ��%r�b��*Z�L��{����&R��T��I��l�(�lZ8<�YK�k
�׿�3"e�KՔ,n�h��� @<x	r<�C6�ްMU}<�(�15\�W���G �s�y���?��	@v�Vz}j"�B)����N��5#�~��RS�3�N�&�Z�hb�u�JZJ9t�fqp�m�V�HsCl����5����?����|���m+�G��{��W ��B�@��ʺ^����
C��l�CN:̙+�ݒ�f]��L�n�����o��-�2Ї^U����h,B�[�ھ�nG�럿��/�xǵc��K�����-q���������UX6�R���㘻����{�V�)=ҤB��
d�Q:��{En@���Am�P�մ���_�8d	u	�C��V����|���$��V_q�$������P�!�G��� �U�?��d�����o����0�&��Т�z�݇���-{_Y�����_>��am�C*�5�^o���d☮Q�]�<�p�=^��W�4d&F�-�^�����Ґ(Ӕ z�l�v(�V���'��+�-M�y�0'5����І�m�eQWr`�^�����_�����q�x�p]���n�F��!*-��ܜ�)$dP������]0� ;��Dl��5XCv+e�d/�1A��O/;D5�?�ú�M�Ǐ�̼)�,4��Qfn�oB�'YM��܉D>U���� ���LىA?��]v���,;��b�����G�0쇛�{j�v��ۜ��9<�3(�2����C%�u�+A_��a�W�wu����l� ������P�-¥cv|�i�防�{��Ҹ)�b�:�Jt�"�,#��:	y
YO5��K�0�,Q����6Ӳ�ޢ�1kBva��`pCY9#Y��5y�����������Ͽ[T��5q����
U�ƹs9���$��Mh$
\	�tH�e1Su�v��eg{kŬ_a����ș�ט�!X�CPI��@Ld�$�(-RdxO����)ʲ���_��&��x��Cv=eS��޿�qM(���Z}�p�4T5�!h`�4��H��H{8qe����&��L����y���!y�r,5��-��!�[P:�%�k��Vn���IΥ!��r,�hs�M&�z]R����*v�uu���������X��ñ��C�	ŭ��*.���Ga#��C�&�2���~u�r�	���f��E] �/d�P�����9�M��i�W��EUU��f�<c��8���ׇ�˯�,Z���m�b�#�k"�|��`jMxaj���1b]�n���������t��ɂ�VʁRfEʋ��lz���$�H�����ݳg��L�m`R����c&��:�>U<Q��`&�}㝣~D~���		A�FBP�6l-w��+�(mſ���AIA��$"T�IA��l���{����@�o��H�0#bZ���H��70�OEye��޸���<�Z�����פ��v���Q̧Ȓ�*��k6�z�b�dS����o��p�$^�-,���Mn�⾪�cE̸�]�#�Nr����҃����o����
��T��c����0O��s�2LG*f��X7MњȮ�P56�����^9M�|�ۿ~��Ս$���A���4U��3�lS�GS�|���>�**�M>�A��oE���c�=9e�z�i䑙��?%v�V�6	{����%��u��MH�52ݾ�ކ���������0�%RU,�׿!���2�e;#~*/P�v�N��p�p�U͍������|�d��-x,SY7������(p��I7�q�1��3*2�VtŬs/�*jȐ�A~���]�/����f/�++�g?>����e��1*4���zS���a���R"�y�4�����Êq�R�CLH��/!�lLe=�2@�p��@MT�A���K'�${�DD��ӱ3�e����Y������_Q]_&�;�a�	<���ϧ}mR��3��|L[�"&�jF<=��e�jp^J�\�T����C|L+�L�<l ���Y�m;�U�ӝ�qI��Y��N\5�z����ʬ꣹,�cG��?R븼��x�>���j��p�%)�0�!ȭe���E+]�K:��B�̾m�a'�2�kv�X42�P�&wl�w���;@�Y�(x"h_QaАYF�A�Q7�q��DzA���8#2H�2�B:J�]O���ڑ���������<�H��&`�k�${j��_d��oHw�[�;ZJ9x�'n���˙oQHԨfv�v7��
�4�҉��Fya�/�{���PD� S��v���M�{5=A5}���ma�Ԟji2q룑f�s;=���1�:a㖔X���t�Z1R���z\4,���O�P�����Ã�t�ܼ�t9j��!V���\)6�a�edP��u������'�qj��˅�K�Y�>$�PSD4?1����L���	(BHs��k��/�0����Y�����m���Pq԰{�f$ː�|2���Sf"\���|����ȶ�V����5K{r|���?�nD�r��ɻ�ﰍ�� �0�QOc������ 餁�9ja�����8���'�p��=n�THϗ��q�s�0	\xxltW��t���^0������i�m��ᾉ�c�I���:�Z�,�s7r�p�W�ۿW��Ǜ&��됌��0ipW���Nɼn����|����ݱ>�)�/����㼝f�/�ۡ    �pw�P/gN�a�v�����e�qo5�jiD��y&��{��n<��i�;�=��2�c|n�����չ��N�t5�\P׬Qd��P[��:Q�O\	�I�t���Ǎ⦮�v�;]͞77����!�q�V�w���a�!A��	�LS�2�ֈ�p:cCC_s��'bL�@�	=1�p�PߛN7��.z�2k�8�j�1c������'�Bv]��E�C\Lxӱhp������r�{�:�k�9�~H�9���]������|�r�h��è9����{���R'ö�m��D�f�?ރZ��'ȼ�վ�R�Z8_J'B��Zxg?�@�+=5!2�ߌZqn���S
r�+m#v�H��4�g�솜Z�98�i����\EGҨ�*RO��ާyP��E����pRX�ݙ�) O�f&���|jR1i��}q?���yg���"O��-��o����WZ5���Y�5�ak�5�x���Y�H�Y$��SݵA��A�4�P���p~�J��M�م���I5�!!�)�8�� G�в�w��┡c֍c��2����I�H=ˈ
�Rp�/_O�0�ފG�CUM��)�: �F[t/��g����bҚՍ�T��q÷���E�aIK�����an:{#��s�'ӎ���|���Ŵ�Ф��hZ7O�^ǝŢU�N�*x"N<:���?�>�	���>2~3p��$���ʱôI7i�뽑�w���M=-���)k�#:�U H���(�0&���:
d�V��>��)W���eC� ��
���P��I'��|�c�}ȍ�@B����E��BuwDbb��f�T5yRi|�k���y��y)�c�$G���#���u=&AmX�?�����U$�@ݮ��U4��>_���0e�5�=�ԛ@t7�LD�"�_��Eo�qA:m�l�Bm���-��M)Ǔe������L� ���qd�>�\Y?Y��|�1m���N��/�l�3�3�JH�.�Sm���)���'=W}jy�0� {��s�N�;S�!ʁ@�ԉ�O�g.Md U�6��}����������Dt	�zP=�]~A������Bm��ׇ$�xl��s�=TH��mS,�=��7xl���=6ۜL�qʌ��:>	�*�T�m���YP����N['!� �_M�L9��d�ѶI�����y;x�7����W�}�?��â�������2ړ$ؖ(<�6���΂��@�B�YFr-/M&�5�oZ��,�����%��!q.��H��j �h��}];��4+�Ұ��DM�#I�#�8e� �mjbv27qR�0�!ka�K,�6���OR�@n�'2��1�W�%�*/�x��i��⨹��ʐC;V$FO}r'�'Ț�Er%��������L��z��x;�n�N�\����6�o�
�μ�Kڲ׭yw��?�j*��u��p����J2O_PH�lF�6y�<�ȷ�GD;�Z z_��F@%$$	Җ���^{��Z舭���O;��5��qk���?�FȈ�kF2�c�6��u�fl޹v��M�rߟ^�iȢ��0t�[G�����Ĩ����8x��9œ�
K���tǴܝ��p;`�Q�����X�e�Ϧ:=�~�O$/�fv�!X���M�>�܊��q��)�ctʦ���T��"��=d�~"+��IF|h�5G�}��~g,���HrN^MU7�������ڱ᜸vh�K̿��n�G܄
;N�bF�,�fk7��ۧ��I��=vK��˻���#[1�'��gͺD�`�ooK{��8���&��J��B��P�L����yVdn���h�B�4�4e�͠?,��,����~��+2�蚡� wȱ~:�|������μ1oW�F[��1��a�P�7�c|��ȴ��2{��7�~��>ZM��zv���W��s��P��aG�_�>�瓨�,d��5#�|ֳ����d�$U��s�/?J�0��� �t_7��y�D4:����n�%)J�ܘ�W�nr���Q͸Hj{��3���h����C�:p��t��N�Ƕ0'���aC�]3�1
;�85�����i^�~���Ev-�(ѡ��Ib���;�>6�x��/���a*0~lצ6��'$cq�RNU1
�>�'�UtP|�ġ��`+}@T9����t2���Nx��o���`hs4�g��^�!)@���u�n���V ���!�ۮ Î���T<�"v�܊������C��Up���֊��f���M`��	�B���)a��2,���C�ک��g�]f'��i�]//�0`�<C;&�J�ؤ���v'�Yx�.+H��~�$�=��Y�w"��Ճ�-���ꕏ�Or��B�=s��Y�}e*����L<_	J��+����g�	B=���A��y��r'���v�����!Y�?()Sc�d��݂S_��w��YJBXH,�C`&3�e����b���.TӀ2��zf�������Q6X�Ν@Jb��))	����F�����)[�~a3Ю� .�Ig:�9�Q�
2��ː��%-=�U[W1d5�aff���E2S1�|o52{24ۯ_5��-,_����.��u��X��$M�o�x+|$���V��؁eY2��vq j1a(>V��{��K�L��&����̽R��k�TmQ8��v���;[iO?����;ᴉ��r)��2�C�7=�7�Ets�07�h>:>;:s]S�~�}�)w���*5��]�ώ��%"��⸪�?��Fzi<8G�C�u�u�<*�u
��e%�r�{�n���	�qEhD��1�y�Ε�}��^�$':���F/M�`�N"�Ƚ,;AFg��n
�1LD�&q~���{�Svu��?b�)�އ��*��^?��c��ZwS>��D)�M����X����LmH]!�+��N��t@*ļ�r���4���"���.l�;)!� �]�r������C�eaOz��t�yr�t!	�f1�ZC�,ĭ-d50��:Y��$�h�	��Ec��bf[�����w9�☗�λ���׈e���b��seˏ���ЅZȉb��3/���Mu�;���L�V�0�I{~�s��n�^�F��������U1t��Vp���
1�:��L��bR0��U㽭�� ؎�#ȴ8&���}��tw/��,$�2S�D;?�k̙��0��=K�q�hӹ�rb�2*��[���5`l�	��Ͷ\s|���	��1S�}�Q�r�U~���<���2j6����OHtaT�̍n��"�y2JN0����\q�>](��f��#3��Qo~�*���Z�
� ui$�b7ȗ?�0+R�ѡ;c!������-59d3�,��2�x��ź�z|di+��Eb���m�/�&|�nfs�es���x�[&���-D0�hp��n ��qq4����e�H3 e����2̀t-F1���A�-���sʚX�0[���"JY�����LY���@EBi��tz�;_�yH��|F��t��:��X��4˜�z9�9s:�X�6u>h�#u�]_126p��c�:��_d,�nZ37��]�R:�������⽹|��C���GE.+�ųQ<Mc�%�K�e-d�}g��;!�e�]�����i�ƥ�Ťt+��^�/��@�S3��wKoS��0�2Os<G�b�z��}�H1����`��B�SӶЁ>֨��ȨBm�����0C�]ӵ���s3���0��������3�Ԝ��5�h��F ������Ғ�N˚򵘚��,cp��B;v1��H�M~����@#b��B�i_�@�1�IĪ)c��%���k�&_s�|o�W��jq �������� �f�h������F��iě��n�53��җX�o�.�ל�2uV�{ �3��ڎn0?V�C\�n��$"�hfу<O�q�@k�  a0���l0Y��f~�A�����O�TU�b̐P��zp�'��>��[9�����T��.���<����3����
    ��M1cv s��%�3�M��`Ƙ6p�A>�
p/�0�H��FR�+1�|w�½�1����|������<!�9F;	y)���
$3�����C�?5�N�L�x
!U�!����[�=�7�q/�D�~zN�c`�RP$_a��q�a�qi�F�y�&z'�Xaʖ��MN?!k+�j����+oǮl0�-��fp�NU��_N$���3�͙�O�5���'�"$^�۲d�>n��2�&;��?�AT�����4j}���/�/��˓�Y��e���\e	�SJDD1@��|_9���OƲ�Ɏ�n���7����M���xn�x>�A�o��w֞�:G/7-�n2w���R�טEo�n�[2c���QJm7O��^P!ْ�e���������B�AK���3U������E�`�ض%Ou\W���l)��
��'9���mr�����S�$�����,5�qU Đ��8͌������i��a���1f#ʖ�@o^3f�;Y�;�w!��_������i{pAǜtc8jm����d�,�1�1כl�5�e�|�VDp�M�T*qx�0y�<yԩ�ѐ&�t��A�����R�뿇P{r��usbsy�ĭ���~��l���p=@*0�؁��HӁ�p���!�[E0�p ��n���<��c\�C�WѻVzb���f#����Y��O_�Z��<1��P880Q�DDW�S�ڹu�����_n���.��1���GU1���^�B�Q(t�����+�XH�b��=��\B���E�1	�݊B�y+�,$'3�)��^Ol��]M2 �5��T�K���B�&�*K���o���`Q]y+����A�70�LGv�\٦�m���*}m���2�0�_��֣˵J'����#�U�M�������Un99�cc<+c�w/�&��yм=m��ɋd�1�uy{��o9�N�� ����eBA��s�7Hk�-�py;Ht����+r��m���7	ǰ�T��/�h-��m+��Z�0���t�y����In���`�C������=ɭ=i`Lh�p���l�{�n�t�<u��u[��ik��w���+Z�fYO�C�u�z�Խ�Q/$L!\5�̗�c�N� s�	,*^M>b�1�9�y'� �b<%�Μ�<�M�>2	'����v��Z �|�By���V���+�ax	,��qțYw����dL���[��r��y���� ���R&ϭ"��F�j��(i)�|���M|37)��:+N�Ȃ}���� 6 �kN������Y��YK�X�����@�Pޟ���{��_��]�g�t�&����7L���������D������-��G��Zq���lL��;�-y�6b�0��$�j�`2�Jou��{괯��HȏD����x~��_�w���	��z��)����˸���''vp��NM���p��V\�ͤQzǝ_��wU�(rT�Mc����,*bX)�̜ҷj�1,n��ˣ��v��ʄ��'��"��.�y���b�sefVq�c�E9�M�uKXG�(��i��4 /�>+��*��E>ǥ��ik�����.�嚟�"������3���̩1w����9 �{ܲ��u���̬U��R��[Ѳ��$�z������,���zx̻,��9��5l"	1���iU#k
�<7���*@���N�:N:N�ƹAqS|ߜ�,�!ՈYX[��:���٪��2>Ed�򰷕�?���o��M5�s�7|��� ��'q�T�X��3^j��Ϡ� �F�½�K�hXrZ���قB �g���!��_�����S��Շa|�ci޴�-��ka�q1 w�R�	���-�Ս������pt�f�Q0���|���}���o4)3)��������n�x�n��n}6�xܿ��'~ܐ��,�z���[u��!	Qa!Q{Qo����|�?mاY�,ZM�1���S�Ձ�,8�M�#:�H� ]�YX�)6�fT�T��!���_���8���R]��럿
�����=�����\g� ݉�zEK$�.u���#�"t�}�N�WGy���|���U�4��N1�q�/��ŀ�������NM��>�U�m'��u�I�&�[X|J�i�����19���.�H��γL�3I�(2ک������}��t�v<0�cvE��N4����S��4�:v��p���%�ը"A�Q�a8��e�6�O�a��vǶ��=��<.�y�n�V��I�{�1�j!�{8��L�t�̿�H���CbiΦ�	�ǻ����l0;��c'��;(�ZYt��Nc���͹�xuy����ʳ&�Qc'^��Ҭ�w����ë��|[��QB��<51�Z����l(V`�T#�����_ߥ��Hn'��F�������Z��D�_ҏ��N�u��X��=K>R��{��o3r�8%E�2h���(![���2�W�E=���d��x�+﷧��W0�	��lM����2�<�%��	��bʺ-��]�Ni��ѽ��!�Ǆ�+��9)�|N!�7������,�8�Wn5��A�[_	I�[���-]ҩ�/�_���(T���c=��b�SR�&�>�*������^`[,^�Oz�
��Pi$؁��������Q�X1Ԥ6t�W?�nmd-S���N�L���h�񊏂��AF
�gyƤ�锥'H��p�וP��I�X�^wd��kMs�!t�D{O�����^��漊M���4C['&����<~g�pגw&�����dɡb�D�{����|dG�M��N�$^
�#���l�<��Ȣ������(�ę�i+���A���iǏ�"b��FvF Ǜ��{ӝo���O�i�6����AC��`��q�����/E���B^�
��cE��3����V-�Af�
/�K��. o�r+�B)�Y���F�������g���H�<x�^D��HY��=q�޸o�s�� ��n�"�,	�4)]��}��\�W�$Ť�?H 1��,���r'�Nk�"���h#g�� �1[��h��s>i�l7�o�2�~��<���������0S���~�������mf�jl:f�8�k�|��?�~Db���f�/Į�3t͆�k5��[!���b���`S�b��`��W&%��ܿ�PI2"Ø
���/�'ި�<ֶVѓb�lwK��(H�l*SLYܶ��`<1�������#��K/�|'9w"�]���������1�ǚ�5p�%�W�;�0P��7}G��0���+ZD�"W�+d�N ��s��|� F"!k��,���,��+E͔|H)��{�)b-�$��ΐ�Xqz?p/�T�5���*�=�G�e�lH�{�`�m��(V����ԫf8aZ�.X�r��"X;3̝n�js
��sx=��&ȳ�p���ڶ�؛*�u�n��K�����;Un��ˋ�у�ֵ��*6p4��ץ#y�\<�r���S{�0�p,��I9�s��L�y�D�UO���'.�� 5�uM�Q�0�N<�B$�. �y���j�m��b���)��~9���9�7m��)ϲ�OC��߱�ꞥ-C�����|=vog�q.N��F�*N�_�+[�0�p,��e�#A��M��M}�Ux�lS�!z�g��Am�����(d�i�N[�S�de���Z�'�-d?��Oa�,Sℊ�7\ dxʎ�0Ƶ�Wr���WT�&5"�٨S�����3�����?+���D$:�UUcA̖���a�3~����^�nx-����9���=g�9�U�=w�~��r��L��Na���*Rt���T�1���o�����)sh:V��=�O8��I�}{����yI�o��@������Uh��2��D�-ۺ��j\�;�AI��U\��A��ႾMZG�h��JY5evPyg��DB���1[�r�<��	�T�ok����9�hY4:m��;R�	��#�s�=�Y7���q��?6���-��4�@�V x�O-O�W�f�Q�X�F��yz=��(w:W2��x݌th�C�oB��� �/�y�����%JD�`�g)������7    �3�%����+��Q<�A�+�y�ؙ3x����ǖN)@������R�����	,={�	#XI��JK�ȼu~� �P�2��� ף����t�h"B�]�Z��`�s|r�#�wY�i�����I���Ԏ(��Q��3�xHUbC㿗��t�-�>�W>u90�>VSn�;�9�g���\~,	�}��\���=�Je��z��c�İ~ذw|8%)J؋'
��v>�����H>`k���O}�G�^�Xf�&�q])�ܣ�M�Ll`�䁲=�U���$�2���ZE]��n�'�,�{����t�]��k(���`ސ}��M'���F�s�����rl�C��7�ɟ��9�YՆ�p
s����a�����&Ɔ&�o���z~Ⱦs�z7�^H�A��@�^�-��J�2����ygF��}Q���b�:����"�o
c ���Ye��Ι��-&��(��������gQ0s�Y��c�ٱ�2Z�I�=�0O����vy���Ø8����qb�(�3z,�ʬ>_	R�ٹ���bܚw�d͖�p��(����A89��mvģLz���Ɓ;B^b�� �FW	�?
%?I�����(��8dhѫ�C���޹�A���<;�=��c9R�Ȯ, \"C�3�<�(��<�r��{���V��-�2a���|�]2R؅���<���x?p�$$��FZntE�R��{��aî��.?t����?�?�D޵��/���鿯���?�p�U3�^Q�W��%4���0k.����o�2���va�ц#ߡ�6�~�w����Z�"��U~X,�m�e��K$�ҷ�s�u{�
م�ÞdM����ރ,b�������=d��Kۭ�½��!���Iӭ0dA�(J��G��45y⭣ !k��M�=�:��|~���r�؅�\=9�Wݡ�zِ�!�W�����54�
��a�\X��G�B�i�� �zU_���E 7�${T��\���"�#�.�~����3���cy1�n^�ƳZ	�C&b#��z�ؼ!/��X̌}JDh�4ȧUӂ��󉹧ʶ��܏@f7�!r��8!wZ7	��WW�Nb��fg�Cl�C��s���Y��Q&*敳��Y&�0��<�{�pھ��ܻ~����E��}���N��w�C����^Y�낶j�=�c�׫倗�C6'75�zOL��A������~Ҿ}n�r�O��>��2�8Ţ�;j)4���I��˂��]M�|�qR:������Ӻl��WB,�v3�,� ����MM��	��y�{�D怚n喵��F)��XJ�����p���b��#�k����飼��:p��w�7Խ�������oJ������3?iT����93�;P�4^�X1� ��*�����du�#��S�MB���5���T���SC�W���xʝ9���W���l7a]�d2��t�ôX�����Մ_��C0��� !V|Y4!����Y7��5v#K����� s(\%�c��_�ǌi?����T%��t��w�qֳD��j����=_'�p��i�@V��z���r|�(��t]m�}���ظ�Ɔ0���ݽ~Zs��d�/�o���t%��+	Jy���-wo���	p�G�?�g��f�G=����H���]�z�Z,�yH��n8��0ᕵa��X��Vm��H��G*����H�*y
�v�~��.�������yY�\��F�c9�B0�SI��		�}8m���qjj��;�-?a�LvkĤ�|��� π3���;� ��9�r1Ȋ~4%��r���B3������Y3P�0�k���m�k�|{/�W=��p��Ҷ�!�Ȱ�#�Q�{���w�t�%�2tڱc>6�*��Þ���V�D"���	,{Hz�L�đh�H	��nF�N(��c%��^�0$�3�aѯ��-�m�c�a��NO��)��ENA6��<��zF���2��
�B�~JΗ�E�R�9�39p'�4Q����ay��!�3�*��Y�^�i����&o������L��6�@omZo���*Ϻ�;���'&6�DR?f�6�����VQ����r�j7�7�2o����{�p	���QT���!�`>�0c|��9$�q�55z;���S�8ZI���!���(�*N�;Ӹ;�#�{�y�>;!')r	<on#�Wܩ�n�ú۰�;L�F!CY׆%!�#��0��<������ՅF���r�78���N� ����YC��x"h�J9�����J'A�*��"mZUk��#��B��l��̨,P�Ue(�!1|WG�
f)�2�0�t��t��\��-�e˰��}��VZ�&��$Ϫ�2�*����.0!˨WC�e��mY��#��	)f��{!ŭ\�∭o��#��Tΰ�..;Xf��s�6�fC�\i�`��/��[�� wB�o�e��#Yur�q����sDaR���J麜m�ITs��װW��5�GMTG�W%"�jH=�\�I�����W��@�E�G�}G��C&,g�m��׎�{�tԦ�I���d	η�xWD�uq{�����dD�>�(�ã�&b����A�tfk}����>����TXα�<��
qP��"^Y�FIиc��O�&y)����m��oW�ty���D뀈)Ԗ���t��=$�r�,~�@��mS����\��}jNR�8�xi7VZ� d
%��i�/�N����9V���σ��	�d���Y�9*��_~�~�I��I=��]�n�	扽MdvQ.�H�md�n�&��wYr��x{]�F �0�9����ξ��/`[!���Z�E#��#r���t~����ǿ��\Sm�i:�-4��r��铣���[|�Ed�p�G�����hb�W<|Ff���-y9=���x�1���xg����e�26:���U3O �>�3���ى������(@L2c�zr� �x�o�L��d�^Ӄ�j�w��P^�y�B��"I���q�cô�.�Ҵޮ���x��ė�$�r��LǬ��(�����٥-{i�������Z��6:�6��z�������L\��_xbΨ��Υ� ��,��Zy\T/̒��%4����	S�q�32�4cX9J��ry���N��$Ls���e�t�~�;��a�~�oC�����[�HH����Gن+ĐH #�"�DJ��
!��0|cq�`)^y�O�EG�����t� Y�$�r�ɛ�ɏ�f߰�v�6i�k����d� �,^��hUo�&^�޳A�-�@��{{dr0�&���U��`��@1��I�m��؆�Z�0^�D4c)Q�w�uv	���nĪD� @X�5*�B���}XA<:	�\)1�_ d�{L>�f��`�Xt�_�S�$����n����������O=�H��`c�3�}3(����&s/�|�7o���I�ْJ�<�[?��t��?�Ӹ��uʍ�o�y�����I�?t���iq�Ҹ������$t\���L��Y	X�4K?ǁ�/┡{n,��2�O�m��]G:d,#LE�!9��qs��m@^��uUs�i���M���|8�p�0��,���vL��:E��*�;ӌ�r)�[ۀqe�줇G�7�TJ�jU����j2����k@=��p�_OM�\b&L�#�O$�������߿	�0���9.��\�_4�����:��?�����D���M޵�E���~=��b3�7h E��ۙ��R��4�4-WX`�I�7����'1� w�[ښk����`�|��&�<��� ܍&ኾ��Ch��E�b��蔲���.xʳx������ ��[4~L����uNzL�\Dn/9���i�(�c�����I�57�yɄXj @� �Xv�K�����J(�s���1��w�Ϗ��4@��4�����}�����=4������;�?��/��k�A�-�]5c�Ao@�r�����=M�0�p���;ts���}���"���fz]U\�h^�S������	�º�S�w2p��F#8r�v���./_��C
$��fxDN�}�N#3�^��?� Y
  �[�|��R��	B��<Y�=%���5�LBe���˽t�0[�Tl���6V�^iA��H���p��o��M��^~jR�_�n:I
)A�	 w��ӧ��
���Om�4����
!�vx��N�]�JT%y��+P��'6�>���3��7d��n� +�iƽ��|�}�� H��'�W�֮N�6mЅ��!�:l'}M��{�$u.��Pi�������u��4��7�0�J|��1�s��`8=� 3�7F_��X��F�!�j=��b��!v�B��� g�!釯I?�Ä�%!�\v��}J4��a:�Z���BV�$G�&9"ЃzS�AçBI�E�4Q�ekz?~�-oHr�'��������&�N���^���a7�"��]��x��;�s·O�3M)��Gk6����0h�+�$�'c�i���iXb[�%�8Z�aN�`%@����<��z���Q���b�ǮuK�����R��ڈLyp�nλ��D#�%psi��L�<\���CB7_���b�tZ��A0�����x�:�(tĒ$��ʱc�%��c|u�yΛ#�����*>����^E��b77�Eh�?wh0�L�M̴��n7�p�(��`�{�}>3�� y}ͳH�0%H�,)AR��+�%l�5��W���G!?�WM���rv.kH�O�~�o|%cZ*֠��0�C�gG<�ٮC���xw�!���E8�?�5������A��8�x&��bJQ�ty�e
d��H=��]����Q�ˠsR�P{}%�v�5KE��q4twRQ���Э�U@�!���MT�mg�ߚR�����~K�Fu�Mؚ�{i�H��&�wi�w�a>�^8�4�$������y=|�$!C�����)�����\�^̫J��aj����|<��<^�����{ζ��@�����9;g"��2�y�`���� '���������WTS�㞀�ӵQ?�nη�Q��h����l��DoG���&�iN�����i�^Wm畾�\m}un$��KwM�je��� ։!k�7,A��Z=.���#�9�S"���ٺw�N�B��!̾�1D^>��.M���s֙�η�ӘNy%���Rx�ʭ�2�NX�9��F �,a���+	7�aAk��c�I#b�y�$���%�����|ƅ�%�4�ov�ǎ�G>R'z6������ǳ�1���f�ڏs���) Ғ�h�Y�@��!�����K�s��mz�Y},>�����ͭ�*A"oYX4�m��v"KԽ�I�Zo�Y^BH2�M�z�i<��θ�y�XMM����s�5��>|��ް����Ľ��˞��]�M�!��R�6����jw ���
�D�7�_�����Y�ސ�[���co�3ߤC��)�Y�*�/��e��βĮ��zHiw;ȵ�θv���\遛�޵�y�=+�I�o�$	�I��@�d����S�y���o���3���������7�1��G�A`��4m���kxX=��{�}�uV�S�F�_8`#�F�L��)?pܲ�ROc��{��:�@��������-�|���{@Xئ��y�"�I�"nj���&ڼlOy˲s�f��?t��������@��ݲ������]��$_�ݬ�=��	�so�j���Fc�8B�r�=ɽc�1ȵ;с�R��M�XZy��l~ �BN� ��w����z�/��U/_bς+�+��Rƻ&ߎ����,���k���(R�@�/�u����:��B�����'�VD�Z>�����ge�/��7�U1Q4B�s���(X/���y�;x)�W�`���V�p�S�6y��,!�w��N�hc/�s#!�ј%����>�3/�p�c�XO�t'q�@��������tEhr���+C1�)ǒ������]�|�3�	x��.eY�~�ap���i��5��Ϩ����QK�}��a��Y�`ǧ*6�h)&�v�&�z��Q<|͐D�{�Ǳ�K����Jl�~6 ﷕e�a��r~43�����cj�e���Ϋ<�$�$D�1�[p�Ь3k7޻ޕ�J�W�3�H�I���d�o�f�6w��L祠V�/:V �Q��
�� E5f���}j����IWj��j���8 :�[��r�i��!޳P�����V!�����ZX�?������Z�o��������j/�qP�,��|�-d���&#��T?oJ1-���x~��iZ|hʗ�_�j�m#.�̴�A���ϼ�BPKΐ�ć�p��q�pח)��7i��.�6������^Ƈ� ��߱�
ݎ�"đ՟�����_�??~�a8m8T�h��5Z�Ig8'GBn*"��[	F��Dݛ�}�&|�I���-����M��}�"��gH7�k=Q�;T�Н�/6�dv;¡Z{9}>�!�����+��,�@��D���
��W�(K�q>4х*�j�ځfQ��_'�K�y����s��ɞ�m�Ⰷ���"���^�^�*+��	�3LO�&=������n-����l�J3���3���do_}[W��;:�kF��I��L����33�"�3kG���!yײ��-��;ב���
����������[�      D   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x������ � �      F   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      H      x������ � �      I   �   x�u�1�@��1(>;^S� �tW����_�C;Z9����q�s>?��}͹_�wq+��m@G1�#g�2���Á�hN����_d�d���/̝xb<���q���b��K�����Ë��c��u�[�-Ŗb�f�v\��`�g4�i��y3�O�H�      J      x������ � �      K      x������ � �      M      x������ � �      N   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      O      x���a�与�W��6�K�%�,bV0�_�ٝ>��d
����%��le���z�v�_�W9��8�ǯ���W�?�s���������x��?zF�U~�����&�:�����˄����2N*��H�3�S>�ų5�J����_��B��A}u�+���5U�|ܑd%����u��C����6�2�s�$+qMTe�)%��hIV⚪��$�J�sU#G�s�$+9��������I�3�]]�6
t�i�&��}t5~q��)g������f{�������ٟrga�lʪǯ����H�3n5eU�A`�V����j����5?����$+qM\3�IVr6mI��oiu��lnG���EO�&Y�i��t��$+q��g�L�=K֦-�`�@lw���M[�Z��G�Y����RgM�״5U��=���5mM���<�Ik*����ȡ�1t�Y�ɡ3��,Zr�L���潟�6���%�ij':�%��j�E:���ٔu�
��T0w8'���`�aS��4l
��ܯݡ0^��6&�6�� Y���dM_24�S7}͡��\��5�&x���4Gk��a�㲑��5�e�I����E�0muZ[ô5G%�J��9(I]��V${���x&s�MYsT�qMYs4�,�nm�&{&�ys��OY��Z�rIX�9�@XLY<YQO��ϡ�G�O:��DE���8kXPh��w����Y�����lVa�V��Y�TXX���Y���z�M�Y�0�R�vP�g=*q���Ҙ��[�°�v��H#Oi8[��0�-�R�<��K���HSMi�[�DK��R8�o)�[#�3)�􊔆�>
Ì�\��͓���%	�Ba�s΍�#A�/���\ear�KM�aH�n��iGB�%�����n	��u4�.YZ2�M�"J�,��Ø ���,��Ck���G������(�di��=�l�����5��XHr�_M�%a�l:#���J~g�aR����IX#�IXn=��;��*|�l��aᓗJ#�d��%a��`�va9�+	k�=	k�#y�4mS�=���O��o�c%g8��I9C�4|v��4n�7?�;���'���f�[e�>>Kk�����O��̝���*������s�ڇ�-	kڰ��ʉ�W���Q-"/{di��qu��$,y��'�>
gKF����)ܒ����'}e��������w��O)�����?��9��r^��T&[���m�v�-�=���|%Yɹ{��iW)�*�9T~}Ȅ��y�C�lkɅl����U�&:U����S������[7?��\I�]��?��W�<Ǉj\[&{'Y��|ؠ>�`�#�Μ��a�d+�~Р@�b[���k�
�k��W���&���
9T26Q5�U�'�θ�D�q{I��T�Wq[�������b�$+9����IVr���K�+�z�`.�q$��}t�^YZ�5�J��ջٴb�$+9CWA�u�ga�l�
ʵ��w�����ȃX��I+*�.��K��&��H�
ܒ���#�{}y�^IVr6m��U\H+(.��YX"C\��Iv�} ����*nM��
��+���i+(��؞d%i�VT�_�w��M[A?|G�-�5m��Uܚd%�i+(��⚴�+�+�ʡ�1t��g`��*	CT��V�Cg��
L�E�R��D6ME{V�[�Ȧ�h�*�%�)+���a8�V0�`�
6}Ep5�E;V�),*�`(��g5�E�l
j+�T-V��+*;�`�WT7X�����_�p�޽���h���+����+����+����bM[���k�
^�X����u�k�
6��XSV��dŚ�����=MY����[����$;oN'��)#]��Q�[.	�{"��)�g!+��R�;�ʏl�"�<�*k��aA�)���g�
K��Y��Z��f�Raa�rv�ƕ�J%n�*����9�AX�U��(,tE:�c��n���s�gX��'0-΄�g�	?�3���.<�θp�YM`�Y�.G��6�g	�;!g+	ׁt�����;��x�a�<p��O�����Y43,<x�g^e�
+�\P
ׁ�,N��]�G��C��e!�g�p�Y�C���g���Y�D���%m(�tZ$�%2F�4�,\w����p��]fre)�]erE+9�$+q���V��J~_a��g��[�����V�lA���?�b�n��93g���k$qk2g�ے�����ޞX�|%Yɹ'Y�y$���l�zwb�ɡ�ۺ�?�΄�����F���Z*��[nT���C�^T���6��NT@��؇
��I�������w�,�mwoh^`�ͽ�w�%������nV�O�#�8���J�li�#]}����'��,,i��D?P�pN��4�O\�K�;�J�(>�%�	�z��3kT��z�D�YX"C]\�N�3�J��W��'Y��⊄��IVr������9�Ȩ���I��.mJ�liS�3�J�X��s��dYTؑd��bqÕT�}��<��&�%�mIV�a�>F�
Vt/v�cp��ܓ��l�7|	+L�Ρ��Cg¨��a���P"[�������_�:�c?L;��>���g�w��b!�Q�r��y��i�埣����u���������aæ��������MCv|ظ�b��d%��aㆍ�y��fgΟˣU�
�4���-���5U��øW���&���G��*���&�a�'�θ��*nPŽK�����`��*nK�sU�3d�$+9��⦚!;���]�=5C�
[jF�s$��}�*lu�5�J��U��(d�$+9CWq�0p��ٔ��IV⚲Mqx&�E�� �q�,,�M\q��0pK���7<�+�JΦ�`/�*.�w;�YX"C\�0ʑdg�i�MVø5�J\(+���g��M[qoא�IV�6m-��%k�V�R6
\�$;�V�V܍6�[���5mŽhø&��m�^9T2���&�!:r�$QE�oC�ɡ3�E�]Ң��da�l�Z4�#�,,�MU���a�+KdS֢]o�p���0��an��o#�4�-Zֆ�)l�s6��0^��)l��/�Maq��5��m�B����¦�E#�6}ŭ�B�V�L.b/8Za;��5q-�����k�+�M\��C!kڊ)��i+>(dM[��C!kҊ�(��)+������l�vSV�8da?pk�6ٚd�ͩ�9���%,��咰�'r�����x���,�s���&*ґ�aa�����&*����]aaij�%,,-�f6k�
��J��U�ٝS#k�JܬU:Yg�s�����8�QX�t�d������ϰ0�YO`Z�	',-�H~g���\x��q�³>���h]>Y?Kش�%0�$,\�����sh����94�>I�����sM�(��g^e�
+�\P
ׁ�,N��]�G���@Z?Yx���;.Yx��5KnYX҆�H�E"_YX"Ca�M#��6��հ��[YNN<���9É'Y�k�"W��%���pا�V<�Jܞd��f||�N�3t�9��F3.�x2�v<���
n||�O�sK���d%�+y�$g�Ux�Ov�P��w��MT�	BQư��Ւ���g�DY;�����%m��g5x�,,i��"+�,,iÄ�o�΄�ؙ�3Ṓ��%�Μ�O�;nYX�F����H�+Kd��+�;��$mqEa���s�x�-Iv��-I���%2�EV�$�%2�XG�v^<����هxa�ŕ�&7�d���O�Ä�IVr6i��IVr�~���z�b��$+9�$+9�q����U�O�Ì�Й0���7{	Êy�h�m˅�l}��� �2]��ɖ���P�!p8�6��b�I�rx��K��@V�NV1\��|珛�����$�iۉ{䱩
�$�i���i�}>wִ�$<�.�),�{���Qrl��X����@qΧc���\PM؄�{q�&�x�a�F�O�J~�r�)��?��-ל-�_�}��>�'L�sҖO,��M9���)ǆO��|�O|�|�)���k�'v|�!�y���7>q��D3��s����V�|�Z��{�u    ���{�um��=��ژiu�'ژ�;ÖO���M�1�lJц̦1X|�=ץو)�FL+��=ץو��o[>��(}�'��қrt7�c�'b�l�ʚ��[>#f�J�sٽG����g�w>m�<{�g���H�Ā9�\��n�.��l�g�6`�M)��g�8o|�1}�[L��n1�9^��{nZ�L�#���=��r��M�#�L�s��C��_n�l��3e��1f��t����Zw���g��3e�z:�̹��t7f����n3{��1f�o�1S7���kS�3u�L10f�k=l�<{����9�!�6�hCf��3���6}"FL��d6`��M?�{2ۤF��s�=�ƈ9�<2���k}cȜ{������y�3�̹�wt��M�w�s��Q��EÖOĘ��|kT�˦;!�ǲh��3מ'3�eѰ��d��`��t�t�A�Z[>c��3fPіEÖOĘ�Sx��}�=w׊��<�o�Dw�٢Ǌ�<Sm�D��=܊b{�s��(�ˢa�'b��-c�3c˘��3[�Ǌ��SZ�(��:d�'b̌-w�Zܘ��;b̌=c�`̌=c�Y6l�D��=�*��eO=���_��G+���p��1f�=c�Y�l�D��{�L��ٳ������2\u��{ϸF�_"[>э�=��m x��B�`O=�� {l�� e�Ό�v ��U�����P��{��P�T�*v �=R*v �=��� ��zT����zT���1�+6�=��z:�l�lv���{f
l�{��� �߬b@�Sǭ�P�T4+v�=��*v�=�] �H��1f��q+v�={����g�P�\}fӵƘٳ�b@ݳ��b@��Ԍ] uOe�b@ݳI�b@�S��P��+��P�T�+v�M�f�P�Ԛ+v�={)+v�=���v�ًS���فT���W��{��Ul�{�Vl�{��� ��pu� ����P�Ԇ��pn�#��&?� �J��=�����{�5��=�����6W�`�'�} u�߃} u��r�W�6]k��M���^5�3�`@۳��b@۴.�>��答�} m�^���1��ݛ3{f3���*>�3{{=s�s��=+�v�1��wl�3[�u�>��g�L�>��gr;��[�{��=�)��=U�����Smn�� 6}�{�lˌ�\�=Ք�� �yɮa@�㰷�^i��;b���He±�b���� ����\�=�R�k�g�L�>��g�T�m �(ܵ�S9k����U�:cϘ��h��AsR��?�����u����|X(_8<�敭��y���g��Y�IX#?���O!��%�OͽŇ��l���91ܒ�~e�W|�N�J���c�ّc5i�W|�O�I��4yŇ��ϒ�5��+>j(�ܒ�F��T�WִM_�1G1<������0�t�ב��;_PXxM�$�iCaa�>�����g4š{��ئ����8���5�il��<���lqBT�x/YZc������-	kd�Y|<U_IX�6��Tő!����8���56d��	�H�y@d��Xq䚄524��g���Me��\1ܓ��m*[���w���Me��`a��H��6��Ǌők�Ȧ��`�8��,<Y,f��ICaѱd1;r��yEg���c%�ڊ��#?%KklS��<�8v�����8�-�}ei�m[�Ӱ-�C�b�E|0ZL����E�y���Ŵimq�XLCk�R�ô�8�%�Mk��,1lR�OW�aS�℔�6�-N9�iSZ|TI�!�	��,<4$�Mf��?b�d��k�&��5}�����1l*���ǰ�,n�&��(�6����Űi,>|,��i,>!.�abp+�&pM�U`<�Sf��#��RwL΄P�X����Pe��?�ɋt�%0L~ҴV�����B]�w�0,2��U��*�5aΚ�
Ä�|T�H˚�9k�
�l~ιP��f*��~�Ҙ��[��p./�~�T��)�����?�Ysr���O�N?��)�����N�cJ�>əT
û m&��^pN�°/8�Ga��٣�E�p�9�G���e�Q������ը��.H�C�w�tڻPzdi�[��g���,-���g}�K���������-Kk����h�+Kklh�t|�YZ3Ǔ?����XYr�R����bIn?	kd�����-���w�?P��'a�ܓ��z`��ǵ�iCa���i?�K%����iKdX�$,?����8햄5�3	k�W�Riڦ����8�ȱ����9�����/���*Ki�*�#��/g�t�ei��J�����Қ92�@���Қ9�~�Vy9���%og�s��K����OV�nYZG9�,�h�+Kkl�+�(<����q!���$I�f�I
�$,i��gkQ�ei����,�}ei���2�仜�Oo:�j��_a<�qE4�����|g�����)\���m"#�>����}��)���?	k�#	k�x,��Y��~r�$ßc%g���Q�aΰ���w�n����/UG4���xN��]�7�)���ZH.}'�:�~�Q�A�(���,�Ea���~���C��_��4!�E��sR��(,�����~U6a��Lؙ��;/� ���ʢ(Y��`�����ؠx!��������L�j	�����-
���.�kҤd��~��:]بnb:HRbG�p;��
�!o����ܯQ��ækRzȩ��t�5
)�t���	fza'4X��)��>\t;^�k�MK�D�K��eu�Ȓ3�s;�kԉ�����%��7��[�F�-��������PS!%��NX����CM��?������p��ԯQ�&N��pSw]��v��	CM����po&�Q���ɿ��CF�Fq�#�nǆ~�BL��jb"�7>����5�^���s����5��s�U-�e}nz鰾��ͯQg��0lo;P�k� ���ayW�q��ﶳ0�F��7����-�F����Du��لݞc��}�"%{ێ����t�C��f'ݸ����s���~�����"��v�wRMn;�<v����L��uRn��I^W�w}�Q�&�e��=;��4�T�kM�I5��4�T�kK����Ґftw-i)Dאf�ӚoGC~Wߌ�T�kE3H5�F4�T�kCCz����!�����g�n��}�BM7�&X�vp��(�t��^ȪHw8i�ug�ߤ�a��)z_�NM��	��Bt&8�\vg��K:���,t炓V`w.x'5���}w�eH?���dq�����F]s,���X�����]������a�Wһ�+���^Ic���e?Rp�+i�v8��.;��JV�:��ʺ�p�+Y����K��p�+Y���	'�@�q~��	�d	�?�QR�p�+�@ '��>-��J�:��J��Nx%M�'��>�^�;݀^I�w�	�d�v�	��Q;�N�d��J֐��J:�Nx%KmVx%��Vx%M�+��N�p^8Y���+��煟�u�^I_b�:;{]�&���?Ʉ�W���'M��pru5\�r�3��Wr�1\+w�����2��$G�x�,T��6ɑ�0��F�1��YBͩ�E��&r����U5�S9�6�咼���ӌ�F������D&/����/��� ��\������k�B����&M��Z����p��I�k���i4�vprg߸�^���o��0��7r�<�vp�:8�vp�b6�vp��1�vp��2\3v�v5�vpV��H[n����y��d����T���������x~J��~}q������q�}37u�W�����׵�9�Ϥ��w>����+1��:Dѓ(Z^��kH���O���-���9�����E���}_�*��a[ش*�?~���sf�q�iX#�7I�ᖄ5���]c���q���IX���+n�G���F6��4B�>r�$}���ގq���5��+nG>��F6}�]%��=	kd�_aK�����m���Y��s$aI����~�1���,c�%a��PX�i0��$�iCaa��IXӆ�~��,=c߇i,n������5�ilћ&�Md��q�g���&��h�'a�l2�����5mSY�|4�\ �� 	  �h��,��!3zN�KK�"��Ƒ�$�����ijL�,����▫1�$aɻ���Zc�diI����n�q薄5��,nG���F6�ŭb��&��Ul��9V��¢6�!ێ+97�+jQ�5�j������#�YZc���q��=Kkl�ע�n����4�h��'l��9nL÷���ƴ)mѠ6�Mk��1mZ[4��ih-��Ӵ��Ӧ��q^����w1lJ[t��˔��?Ӧ���\�!���0���[����b�d�h��&��Z���~h1l*�[�Ű�,�J��D�A�a�X��8�Mcq��6��]}c&��m_IXn\O��ٮ��H�-���3!�4�ð�9�[ْc姆�O:���E��
��8�YY����E�ٿ
�"�\��&��YV`����*q6?k�	�0LXιP��f*��~�Ҙ��[��p./�~�T��	�����?�Ysr���O����)�����N�cJ�>əT
û m&��^pNфX��٣0���Q�&�"0�����/(�FYxc��,�1r5�4���P:�](��.�����Uhx��t�Қ9��7Q��Қ9��uQ�gi�Z#=�}gi�����а�YZ2��O��54V�ܲTa�,���}&a�l:#״�'����.��v?	k�'	˭�|�N�6�~��a���J#�d��L���a��|`����=���}'/��m
�	���X��p�9Vr��w����S?��q6|�O�����'�YZ3ǭ2�P���5s8dd�Bhg���d�~�V�~ּa�s���$�i��'+J�,����D�e4���56t�u��O7�~�"�p���ig�I
�IXӆ��Z���YZcCed%Kc�YZc㡌6���ӛg������pK����P�U�����m"#�IX�ƾ��h��^˟�%mX�$,i���	���ϱ�t˱���+<�'��r,�p�Մ}�28(�ؽ���n��k_���[�^C�[{.PX���.����Fu�__�[����^����}'o���'��/�6���X�@�������w�~ay����U^�{ǧ
'��������n���o۴@]��R�DQ��/���oǂ41q2�$�����>8Th������CɂDq������`c�������6N�#��w���
-Q7�I�.�އ4Fa˿w
Y�&��n;%��m_���{ۙ
)��P�@ݫ��dRzo�� ��H�W����ou��k?���*�@1-�w]��{����DJ��y����{C��nq�$�S�CM�-F(���;#F��
-P��a����ہ.P���uj"�x������׃C����^W<~���@���n1
K=8Th��>G�{��I�JZ��n�����ZzoU�@��{?c���{U�&Srz��=�i �yp�����[U.P�C���>�����&�{�fa�L��&(���or�BM�
��p��_�xp�����[�-PLM�m�(�s�W�����6��C�(��~�����[�-P��s�ᶿ�������\p������~�;j�\։BM�<�:ۼ7�]�P�{�
5���[�NM�xum83z�P���jz�7�@�����:ِj�}lH5�.6��(��y���Xk̷��.N�*�@����jzoA�@���3�{%��֊��I3�8����u�8!�é�bq&�{��u&8�\g��K�<8Th�BM�X��~��u�w��յ�!���zҐō<8Th��'�G6xp��Ś�\����Bԭ��A#<8Th��VZ�w���5]��=AR�pC�(�DV�
���P�
5��'<8Th��=��uuN8Y*��M�/5�%�'<8Th�BM����P��*�@�&ҧ-pC��k�GNkpC�(�DZ�Nxp����H��8'�,ɔӽ�LN0pC�(�D��
���P�
5�&o�*�@�&��S���
-P�0���P�Kx���B1�ݛ��,���C�(�D���y��[�ή����
-P��;)��6ɱ�0�D�!�5�'K^xp��55�
-Pl�#�x���Bԩ�E��&r��Z�NM�d:ܖK�/<8T(Fo�&��NMd·��A�Wx���B�m�$�9�C�(�D���~!M��6�����κ\n;8k����ξ����y�^��BM��m'���m'+f�m'k�m'++^xp�P���m�$Q�vpҖ�n;8�j���;Y������S����؅�=\]_r�[���,P�"���p�(���߿�?Qg%a      Q      x���k��(��g��L �@���A����G�����:+zUWmB<��C��+_�k_����㎿��_�K��p�!�_����R�5���/2bd��#3F��s�߄:��o	y��?�
������6_Jh�h�����n��=�=�%����	�� �%g }�,$���[�E�l�V�l��?YH,!�
XBK(`
\������?����A�7oK����s���`=������ �6�Y�[��������/��w/��"ք�5!bM��̍X�֡�u(aJX�?�%�C	�P�:���X�V�C+�_`Rؾ��:��}�uHa��E�k�>���H���'��%悉�`b.��&悉�`b.��&悉���� ˖Rz��^0�L�Sz��^(�J�Rz��^(�L�Rz��^0�L�Sz��^0�L�Sz��^0�L�Sz��^0�L�Sz��^0�L�Sz��^0�L�Sz��^0�L�Sz��^0�L�Sz��^0�L�Sz��^0�L�Sz��^0�L���R�@)}��>`J0���L���S��)}��>`J0���L���S��)}��>PJ(���L���S�@)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J���[H�C�ҫ>�����O��M�}���[������|��E�,I\z�{��=p��w����Xe$���G����v��w�XB#��9��;H,�n�Ar��OR ������*��V�+���)���`G�y��u����7��v��wf�v��wV5�/G�y��7� �*��$քn�A�3w��w6x�C#ܼ��:4��;H~b��$֡n�Ab��$֡n�Ab��$֡n�Ab�杋��}#��9�A����t
v����e������z����|�eK���|�eK���|GB����J���;{G:|'�ä4y�+�#Z����R�1��8�NB)똇x��������uO� �v�{�VRY�h��Ӣl-�O>pK�k�at��-_�����o�z�:-��O�����/e������N�U���`��'���o��s�k8���y�k�R�1O��J��<�;H��(��t� �͌R�1O����c��$�!J��<�;H�C�z�y�w����R�!O�{ �ϐ�{��P�c��$\bc��$-%�c��$�-%�c��$�-%�c��$�-%�c��	�OR �*<��<��x��l�ӽ��`�R3���{G@\׹��R�Ę�{ɯ���41���A����&�<�;H,[Ju�<�;H,[Ju�<�;H~4�UF��x��3��y�w�X�(�� � �Q�;��Ab�Tw���M�}���Q�Ζ��쭍��Q�[���� �R{�ݛ	4�ݕŭa�i�ɞ����%�i���L�����I�v���|�n��/IP��\��$�P�h���ߝ��������`W�������^�ڪ��\�u[GM���
��>��m2�b�?��!kU�����U|��C�V��Эcy��h�<�T�{�lI:P�W���j6"��MH��H�Fd ���@�qj���k$�!�^c �l�')wU�O]ŃT��X�'�����`5{������ �V���Ľ��5Fo�Y]$��4����{^+�����و$>95뒱McҬK�f]2�� �:�Y�$�!ͺd �i�%�uH�.H�C�u�@bҬK�f]2�C\��i�%��0�@(5���*��` �B�c$����` ��#$�%�z$��Ĳ�$Y�D0$�?I����몑�t�~��I)��`��#�����Q�D0ƉwJ<�H������H�q�{���|�G����S�0�#��u�V���@bݣ�U��7��@����yN
�����z���(փ	$VKʁ�`�oX-)փ	$�!ʁ�`cO䚀��r`5�@B���FW�`�`	��L` �h){փ	$�-��z0��Ĳ��[&0�X��w�����')wEz0���;4%�j0���`�R����� ��Z�`�{�w=j#�C$^*�qZ	0�X���!˖r`=$�@�B	�` �V=$�@b��U	0�X�(a�C$�!JX�� �X�(a�VH��徇�#����C�y�Ε����?���?��w�q��ڏ�ݧ~|��m��������s~)y�K��q��̧G���),.����&��UY��p��+G/������8ea�8�R��ZҮj&��:�Άf;ЅSnu��S�y�G�KY����#c=����ݕ���C�-[Ԭ:���f�Ёx��)P��*P�>�FE�~�� t������>��s��O�}ցtYi^�:��n1ԁ��-ԁT4R��a��3H7�b�@:�ҁt:4z���t!k�J�"����ht�V�4UwiՁx�luV�V��ͪ���QwHՁT��Q�F�?q���z������Uu/T]���"#�������ƺ��������������0B��ZΟO�����h�f:���h������5������ߩ�q=s��|�㺧���%�����i��jLsiO�f�ٜi��@1�Bk/t;���Z�Ak�S�֯3	��=�]���B��:�;����1=�O�t=�Iv�K(�]j��)����v�ܖ�X���aMX��wq5ߕ�y���k0�sRK�t`���r�\?Vu�K�5���}��}}pY���\خ5����"[.qpR.g�]��I(/��?�����k��ke���ˠ^�����GK
cK�%����j"+w��}p�^�x4�n�C�9�ѕ���W��_�c��t/|H�yhr�]���%>�iMn����c��}�u �)����:�M��ɮ�����u #���N�:�* �թ��!�������
�������"��A�o]�Vo<��������@|��'w��]_�tk��H��]⭊� ���N�:�JZ�tw�O ����N�nׁ��mC�k���	��׮��@�;��@�9� �����A�+��d�����?�|�����ۗ� {�i���T�qdO��G���:�����������[/������kW����A#l�ϋw�]|���\��`5�ݿ���Lm/q�^\�լ�a]ֲ�8�`�A㥽m�a�����o0����Jk��� �7���a��F�%-��&�c�N��&5����~�f՗ e����֝���j3?Z4q_�Ww80k���i	n}T�=\�%�9��U:���M��A���'�w������F�ov�+ld�nb#�h�v-[B�sN��ĳ�5��H���U�F����l�bd�i+f�xd#{�F[@|:ӹUo�76r�H<+]K�-۾)��vM:6/�n ��ě_�ra#qo�����k�0�]�����rt�%�%�����J�5�~��	��T�l$<ʔp��	�%b�F��,�H<NzyS�l$�zy�G.؟�@�Uz��G/�����3�[���&'�-*a�8�NBo�J$���zۍe���`ًf�g�g�6��h�G�5��Hj#�u�Im$>(�P�l$�K(OQB����������d[�'����g��K���l#��'�HL�χ�&���pm��֥�cm�u��T�BJ�IeI�ʳmz�������\k2�m	i�F�w�N��ӢwA�h�����#_�orT�<��R1-��[|.��_Z<@ku��QB��-���[���͗���˞��+u��s��չN��b�aT{֛�K%�..q2��ypş���e[�[G���U�M�����T��cO�O1J-߾�,exb����񟉩e���(�6��]���bjS�o�c����1&�G�B�����
�"�H.!�J,���+E�F��x�    �
�$�H�	�
׏I�?I���pwW�L$������`�i,Xj�S�lq]�z�{Km�J����'.~�V��u�wLjmTl$߿�.P;��`#�l�N�W���p���ᔘ�o4�Ф�-�H�C�ФD.�H�C�?*�6��J���M�}�?z-���q�Y	b����Gc��xzq�e��`��`˨�`��`��Q	�V��_�~����'����~_-��;�����A?�\�d�]�̈́_-�n	e[���&��3��v٪�}L2nz����I�.i�}\��S5�Π������蠽"Ƽ�����U����X�k����Ѩۖ�]~e8dm�����~ڲג�p�5��u�|e(nK�����8��p��s�XGך��	T�E�$��ya ����Ģ�Lx���'k�xV4�����T�����W{��~�� �}U���W�T���a�j�8�ܰq�ө�zH<+�{���YQmq:V��H�����[��T��$^-����R�	��h<>C�ߋL�����ݸH|&��H�+hV<�w?�g ��D��ȧ�ćWͺe �l5��Ĳ�lT�77�i6*���@(=^�@��/d �8�Χ�H���x!��I)�/d �&Pʡ���@�U�U�x!C:|U�aR�����H�6�8)o�ㅌq❄�=^�@b���$d*z��1+ʫ���@%^�%� �O�@b��$>(���$�K(7�ㅌ�_�x!��O�Z����+���m��>4\�F��/NJt�H#�'��z ��ċ��k=��8�&`���Z ЁP>z ��ĝ��\ 0�\BP� 	W�@` �8)-�$�J�� ���
ww=�@G�M��y5��X�X������ ��� �O\�h������H�a]��\ 0�X�����x�Qb�H|���Q 0�X�(�$�!�� �u��G=���&�>��@`�Ш�Hh���@`���o�J �!#%����@`�����N	 БЦ�vԊ!�P%��0��Q_,�?��d�Z���t��	[��O'���9�U���TE����m��TIw����꧶6�oyj��6���y��Zpifk>L�[��㚯�!j�H�)1�|�Hf5�����.�>�7��).�����o�����j�����}�ܩ��vAf.	����f*�6�kS�6u}y?Ulef�d�$��}���m��a��mS��2U�f�m^�Ψ�)6/3�����Ԯ��H����Lmm��M=�T�z�~����s~���=�j���!a���U�jH�;s���&SG*So!in��^z�Ω�{��)��&Is:�R#�TuS$N�z�\s��9�S�RS��2�j��S�q����ڛ��t�!���i�&M��S��s!M=��Ե�N]Sf��p�{%��oyjߦ>h����:u-�S�B����oS�}�����S&ϕ��u:u-�ka�Sq�xT�{�=n��ŕ��V��Q�� )���!�Q�|�e�5��o��ZШb��6�Mf���T}+SW}�;ҩ�[�z�N}~�e�T��!e�y��]YS5d���>��}[��өo�2�9K�:L���1��"S�Vd��W�>g��g@�z�2�b&S<e�3��u����&S�dꃧ�����#S-�2իF�z��ԛ�L}>��?2��t��L}>��w$��+S��d�c�Lu6��n52�5v�s�LuX��o�2�5v���}��S�m�e[��/�Է]�sG:�2��0�V#S�s��K0��(S��2�"S�a._����:���7թ��2�P��g�T;�L�[��0�0���ڑ�\F�l�<��=�=���E?��侹mO~�~�T���}sy�R��E�C�UlO���\{��㡏�w��5�1�$�2��X��os�?�v�kŵBN����w��c�a]��x����ԠѰǴ�U�ֵ���g�ڜ�럸����WT��%S��d��L��Smza�H�k7���ͳ���!�q�r��xHv{r�n��l�C�3�tx���~�L)����^����ע�ewiIk�D��C���_�Bd���_�&>n�y�=�!��[�uC��Z֑��&qU�Ul݈��>�D�Iz��A:PK�j �7��RI;e �h���������7�h)U$���F�@����WԁJ};��J�5����-3TV�Sj ��c�����T�+H<+ZqE�e��)ձZ�Q�7����TR*H�Z��R)�h ��R)�h �!�W4�xW�2�H��iyJ$��h9C�R\�@b�j�?$�����8z�ާW4�	w�jD�@(Q�?Hx������;�^\�@�5�W4�x��r��$�J9���')w�r���!���0)W�U����M<N�D-�h��$�o��$�[�����LE/�h̊�1[Gb�R\�%� �������p0��d�G/�h �^B��^\�����U-�h\�)P+��#���Tr{S��V�@�ũ�0�xqR��W4�xqRr�W4N�	X�(�V�+�@(����ĝ��\/�h �����$\)zqE��Ii�^\�@bM��\-�h|�qW��Wԑxӣ|^-�h�i,XjЋ+��� ���������R/�h�k�cR�^\�@���%�zqE�eK��^\�@���3J����h(ԋ+H�C�?��$�!�����zqE�X�(�FqEcǅF%�����_����Ջ+�H����M���!#����M���1N�J#jqE��WԑЦ�W��O)�h��W���Ԋ+��X����Ԋ+H����[l׊+������?@]r�~�B���[�\��kY�P��D��X7�"�k��PHעp�KP��6,�kѶO�ET�Z���5�%��;�D	I=R���ീ�'(4Ŏ��Ȁ���k��Oz��c��v5A($��d(H=�|d�`��/A=�E�q�Ct�8���d�,��[H��D��I#"5��[H�H�`�<�/B�?v���R��K|�yM�Z��G���|�{���=K�9
�{�[�^��=,�μ�ݹ%��ޘ�O�V�2����p~	�V�p���4����?j�O|�ks)��P�L��R_�h�ԩ�����z�oxv���x�]>�����JU�G;$Ӌ��.�п%��d\x�75�\�	P��� �BM����\�ֻP��ѭ��k��:?ׅ�����$n�Ǉ��|�d+��ѹc����Ǘn+:�8��������+�K}s'h��׍�leu�|�lO�kw�T��;�)��R��z��/�N�|K��H�r��A�#�n	]�:Wr*zd��+8������}�ݳV�+ҍ�t�/d���h��v������FF���n0{߆$_�4
ҍ�z����ݦ =,HҨ�4�R����t��MW�Q��/�lz-	�	�h����k�OPL�D{�D����"(���n î���k��OPH����	b7�^��	2"_i|�B���|-���I�z�d��#��I�u=�	z�dS�~����ԯ>�y$CĲY��>A����]�>�iG��k[{�x�mG�6�j�s�qB�������,���in���T�N�l�)U�۰8n��O�iX��U�;���K���:���L_���g��7��i�w�Ҳ�\�����*����ј?�\ʶ:7޽v���޺�3x^ñ?_O��=���CU���5&?>�@�n[?��5��>��t��y�O��ZM����M�q��ue����NE-.[��!_4v1E�NA>A�0A&�� �ms��D�^�QZdBd&d��J���3/�J4o��嚁�&��K>6K?��g��y�e���`�꿤�c�6�s}G��>������.��{��N���,�K5����G����s���&�l[��?�J�J�}t�)����\B.CGW퇖X@��o����6����C�n^��w\��3�@���^ ������˹�/�a[���E��7��4�����z\�@u��=TS1%ُ1?X���
�S�)4 �  ����������]�7�e�k�Ì铖����W7w���?��u<��ǯ��3@�ܧ�7w�����s��V))��%QBV���H%�8�i9L5j��N���}��(1�4L�k�G>�N��H4J,q��LR�ރG�ijL �B�y4�i�R�fC~Y+�?�V����,����kNv�ߥ\���MS�ih�6���A��o �Zk��$��o���]�g
�)
[5~Đ}�C5�>-���D�� ��c�+�q���8�J}��z��ĵ��z,�RܨD���T��F�wX���9�{Ԯ���ݵ\�z8����޽ /F��r��6,��!��T*/��� �Ԙy���4��.]��2�k��Ah�T$��o�Dl�����I���z�Ǵ�j����<^O;r��f��Δr�ti^;N����R=z���е\�@[��f�}}��>A�3��'ߔ�5r��׃��0�[b*��n�Z�}Z���m-	��ĳ��r1��(hu6�o��ZgCB��u6$dsz��ǉιh��0�p��u6$'58�u6$�jR�l��@�UjjQ�l����Z�Qg�-G���X{4�l��;	%�z���V��a !i��l��$Oӑ���0F�5HK�i �i�<$>��F���ʶ�:�����:�ş�:��b��F��aL	^�Z�T���'�@��I)�^g�@��Iɵ^g�8�&`���:Pr���0���;L��<`Z0-���u6$\)z���Ii�^g�@bM��\��a|�qW����Бxӣ|^��a�i,Xj����0f���-5>�u6$?q��^g�X�xǤ��Ά����J��:˖s�Ά��^g���u6$��P����0�X�(��lH�C�?�u6$�!��:�7��Q��:Ǝ�Jz�	-�V�����0L}J� �J�CFJ��J�c���I��a��::�4�:��b�5T��a�Q�(��Vg���Rg�0PÅ���0z���Z�C��)5��lX����*o-a�c�l|�W5�@ujRX���,��Ὅ�5q���S����(Vu����C���T���E��S,e��jF�G8��>�!q���0Qh�ﳥ�(�P�3ۘ�B*u�����m��C6_l�A2�/a�<Ҩ�f&�mH���&
��;����>���ݰ	����@�����e����ֵ�eE}���5��m���Q�"9�����\�b��c͠��W.�{Vs�o.��?!-���%!�%�3��jF�EHiYR#c�|8�c�9�7s\�c�JPZ��-eKk؆��*#<Z*s����-�QjH��x�e]ᩅ�\F��F�whL����������X�kN�R�K��)����F�>�帘��l�)��:���b\�g-����j���+�քHB��?jV����SMnt(bI��sR{�j#��9�sr�1.���>��LS�cM`��`I_&g��|���m�HXS�Yt�n �gk]�..�K^qga���/����c&�֒�ps?����~����exR;�rL����P��"��ҽ�_C��}�;u���D!�{_0�D���}�����t
F�(t	�/a��]�(4����,�}�[h��8�(4_�9�Li���/�`��,�g�3QhUޗc0Qh���1�(4���L�}a�f�����B;�}a�4꾰��B�q_X�D!��gk4QH��i��o�w
+�(����v
+�(�t
+�(����

�;�Lҍ��
&
qd��V0Q����;%L�edn�H0QH��d�)�`�s&��ǸN��ƅ�N:%L�/d�;0QH�̚r_���^$��b&
���b&
�2��t��w�S����jq����8=�:lZ�9�[���	3_<�����;MR���l�bJ^����g�;�r�\,�?�__��Ju���E���~��P�)��x�Z�&ʯ����n�,��h��<�<�l%�q��KRv5gt���c}k
{p�w\�����ޏ�5�6��|%[��pGϲ�v��w��ym��V��.�����ǣS��|B@g�du���B��}� s'Ml��kX�w�t���5��ʭ轣���D!�>t���Z޿�o�IZi�x}en�����?Ρ����w酪�	iy1c��d�/.���3Y��C���^���o9Ρ�7��3��O�����l��Y��_˵��)����q���b�m3Ř�u7�Ο��r���npi�����7���v�v�\󤛛Di�t�p�ƙ�6�%}t!U�4kSu��;��r{��TSe��ckKѽ��.��ȵ(�p��V�ܖ��Y;������C�ǵ�>�D,�ՠ���o��0>�UXh�8O�q5�M�R\n����q�d�I��=Eܵɚ0��h�.��O{�z�V~u�X�V�@}Z�j~�KkW��ؠ�W�Yh�V��o��NIX���Mn�K��dq��D��V���%X���ͦ���l1��/�-��o9��g��	���l?�Re�y�����}�F�l�����m�x��L��eǤ�Z��?-��lǭyܧ���;N�G#����㠨G�1��5M��W�W����UOH�feݶ������f׽������*�5��T�).G��$5��՜4��ﲾ��P��V�8NZWsԎ�xi�����s|��PO�C���?��N��i���v��8����;'�����՚6�cvgᅶC������1�XR�Q�7�j%>R{��?<�8d=��a]����*G&U���)\����Vl�Q��c�)�i�t_M�F�V��.��L/�LmŴd�%Kr(x���:��2;5��}^�V����S$֋M��������J^���v~�Ѧ�~�:��M2W���!��__��W���6~�����j׊�=�������N�x�5ʣ�2�כJu��ږ����.���ke���m����C\��з��� `����L��j�-W��.����>K      R   �  x���]��6��5�b�@~��]�Ţ�Aw���^XhleƝې����Kٔ�!�؞�@��N�P�sH�G�y�=�N�w�~��ޚ���F0!�c�;��� �������w�9���n5�ݱ�1t`����0�y��`�_�+�ƺ?��7��@�כ#!�y����v�=�L����i���wT�zUDb��1!B�@�"��Yft������5���(�7�3�,X�fF��g"��(����@T�e3�l=�OHnVD�7Z9Q��YqO�q?�֧��fu�{C�kml]�!�X���3�m���w�㶓��f�>�۰m�@ �t,!F�x
��j�y�����fb��M0���l���3�nRF]�R��=Hݬ�}7��-8&�&C!�.m�B�e,z�+���P<�E�DFB��Ʊ����R�4��3hvehp@S���ȚҼN$}�`�<��*=�g��SGG
�K����X5�������������泿�C�:nv�Ý�MFbͯM� R�	�l�%d*�"��	��-�����LAt?jT� N���u�oȩݑI�Y�OD�M8��[�_���(���Y���[^���֊E7�V,(��
��V0D��Y� snmA���֕(�����5Ԙ���Ew/hP؛���3Y��X8S�N΢x��rA���F�0�%���6�:uۧn�<�~z�t��a�H �/l>�ۧ�Ӷk�=~��m6�"`�˛ϟ{�%�1�m<���}��������Ӑ>�
�n:4?�C��|
��9����|�د����<m�M��6��8�%�x����{�����Q|�̖�E�0�U�r��4�Ur��A�����˒t~��l��|'�M�87�h�ۄC_��.� =i�� �#�)	0�gd�"#�pą�`ആ���g*�5'4��E{�@m'�A�$���Z��y)p?R]�/��Y���v�5	iS��.GAަ,��KA@�+�� 	(�� !(���Q((ئ'3S���s�itH{�hj�jeGw��������Z^�{��$�u��=PS�BV���3(dTI��"6��:�lȮ �!m���6�#��$�ht�'1��4nt��mLA�TmlA��l܂��ش�e%Q���]���6�_[Y#�lU����
R�5"�fk+DH��U���m[A�v��C��*�~����Ӹ�h|�ҕ�*J����]E���UT��N���� W����؁��A ��V�a�"6Ѫf����d�;<oz�-�����>0_��8�C���,��	�a�=��_P�����s�C��|\��q��k����z\�-`��l��t)�%�DY�W�����*�d��,W�W7���l�(�Xw+P������\�������VQ��%:]���{9�������|���mu;�O���1��;�,
��hzl��fh�u�K�+Mv��ʛ)�N�;
������<`_��? �A���/�+!��(מ���+�ϛ}�����c�[8|\�V�G�Hμ�����[�o���㢄�{7.Kҹ�Gc3ҷ	�K�pS�0'��� �
�x[�P Di���R����i#S�^�n��l��(��Gi:ޘ7�ޏ���u_!Lvk8o�Y�q�A���<"���됬�Ì}���8�g
v\6��~�����҇�yC��Ҥ��MHX㻔4�p���,C}��		�'�,�D�������?��&N"09�sy^7`z�>o�`0B�@A�O�	B7=�N��4���!P��E``����L�@�LL�@!̜�6�?��B�T}t��!��B�e+i3��e �>OQ�����bd
��Ũ�،�)
2c��k��}����&�
��V�*8��,_� �b	����%��U5 bV/�H2S�!�ĺ���z�-D%�6r�v,R �:>c �:1s��+r�@�t*� �tzbt&R:;s�pi���8�qe<	K�9S�/e�2�J��s�.���đq�uw�/��L������4U���ffX�*�dKҺ?v�W*O��x��Y�@������n���J>'� .m~�Gr4c�!� g2˸8v_�$%X�쳐����׷�p�6����O]�4$�r��=_.y_6�����t螻���h�YOS�(%�x���������E&ō$�~o�cG�O~�ٜG�I���БM8]���
Y �)^(C�|��l������.�H"f�)�tq�>MǦϫ����31���.u�<>���n���k���~#ɋ�i�}�vN��%�(DӞ�5���f��R���L��b< �FK;����}��ڝW�f�g���F=��y�0�����F2�c���F�)K�'L�2	��{�7�<��i)Y���J� tXW�L��p_�L�ذZJU�A#k)�Ha�v���N��by��R�U�JsUZ�+����J0�?�ϱW�W4I\jJN`!#���y�s]c �h����$�[v�('�4?�/�m�܎@)5#����c���65cl9 �]#%��r��Y#I
�R��4�<#*��X��2� ��@������Y��XWLM���ְ���!3PZʙ�6�R�6�ф⦫ω��(��(s#�����8�$�V� ����;9�1�/��a�~󳇄튥8@�\B�$�%Ԓ2@
ZVJ�[3�rN�rR%%\U\�SO\���$p7��6�_Aͻǧ���'����@U�x�!)���A���J�,�+�
�^�#��i�p�S<m2�KS�B�;[�ܙ�bS;�S0�3"�����g�d�4�����p�J�-Y��W� {6�3�Zֲ������G1C����ie�B|�ѥ>WfU1$�buA�b
&��AqH[��w,�A�x����9
ze�LY�sw�h��Ng ��LJ�����8Ӄ�1Y�U"�*�X&0�����C�q��r.B:ɸ�,& ��\�$��� L}&?׳e�L��`y��� le����-����|!�$�0j���Q+�kU�xh��+P@�
х�3!ݺ:��m[�Bo}b�y�u*�0q	��KF�pJ9�TI���g�d�+ce��{�4��e�4L�킆蘳��(���8R/�5"�=U�*����M���׆���y%8���� eV�!�|I�AJ9%*V��S�b9xJ9%*t��rJT��)唨X�R�)Q��[��S���b�AJ9%��*z,MI^ҭ@�
���K6_SK $x��@H��Ԁ�ĥ]mKW�!G�ZWu������s+d]����~��~��W�����N䴏q���ĘBG�/�Ce��E�k�Hg"ʲϠ�~�4����r���J�2��+Q�j~�,|r])�� _�lNBܸr�cT���B���y1��k��� �
��ΕΥJ?����*��)���L�GIS	Z��de�?��D'z ���"��Yޯ�ö��\(]fG����K�0'�27͉�L�w�1��L�F4b�~Д�Dg(�M�V4��є{�g,�(M��tƢ�9��jUX�AejYG���ʔF5�+t�;����z��3���i,{�����������[�i�ʲ���^u�z8v�ӟ��5�j_Vx'm���g�*<�M���C\�5K 䜭� �nٺ%sȶ�W��9aǗ@�������ꔫ�z�N���ǫ\E��y\�*R��(W�;�P��wl��*>ȷ?�%I���7)���5 ^��xE�������[11�ޡ��Y�
����Ʌ9����I��!9c��c|�ȅ��g�;G��[������p��_m
-k6i��:�WR$d��%,H�LXd�Y�y�� ��L0�kfrb����X�f��� g92O�yN�[��@ƪy�3��NC��E3���^�Ma��"n�m�HtO��.̄�Oi���}Z: ��������1�      T      x������ � �      �     x���Mo�6��;�B��6�|�C�HQ�N
�C�\��(����$��F#�=5|�����K�3�5](__1\��~�1�ԋ�%�"|I��(��<���ϗ��uz���o?.(���/׀r]�|�"`C��bW�%R�ϼ��x�������A��KǕ#�L���_�73�����q�q�Z����4c[��,�	��sS��y{\���ck�MDׄ�É',C��	 <Ҩ�)e�4�8i��q��(�5��TO춏��,����f�`hG�,��� ���K�}�$���\�/<T|�� �7*}�(�+Na^�֒_ҳ�A|��Î� Ɖx�8>�����!��YR�FkDO�U��@4�x���bj��L�=��yxm!������|�9��7���e@U`&����*���R|�H-܏������V�!�M�{6��V�n� oPh�R�z�*3�8ˬ6���`
:��ޚ��P��j;�v���ɲ�Pp��JN&����fn�m�X3(�#�	���|�F�խ���1/$^ZR=u͆�� ��V�2T�Id �|���D��6�M)N����S��]��w�	 {�ȌJ�-�$�A�-�\[����	���Ő���&�SҊ�To���4�Ni
��Cs�ҊWCn@�wI�{V�;�A9_~��ӧ/ӻ����O�����?~xx��>Nx��ұ��_G���;S@��W�E��`��~�K4�⬽�>܀s�R�oȃ��t�f���T�D�V��4�+�j_�g�����^hu��-A�8]�����xr��+�75�����B��'_Jq�D�IƼxJ�R|�X%��G��c��dAJqc`1$N���l�^)>g��G6���^G���hJq:�����=Ҫ�,e�tT�~�k�!����ց�d�[ϸ���Թ)��Vq����|�)���A�V�^���}M�m�8}���p�0��Vbg�J�Uw3D���(H���aA�O���� �&q�Gbg�#��� �$f�      �   �	  x���[��8���U�HC��^D0�2@���7���:�
��	V�c�"EJ���r~��˻��ߋ���%9����(l�7*���O��������i;~PX}� C!/qq�ƯC~�	�}`a"?�4���f�@D����Ob���'�3�K��������!����l�g��>;�����?�m)l1��[G�wB(�Bt:�iB^�]ȝ#r�FD(D���!���!S��1_�&-�H�ӟYI�?#�A��]��˭̛���<�oR+n�t�âi�XP�׏K����9����E�E��o �i�:�@'P8f�l7��-%U�hi%�͖{�K��C�<�y�@����O]
�B�����Nl �-�P^�ى�����C���h�G�n�D�JD(�=����<���s,�U�b�źEB!fф�JYu'��<7M��ʇY3��J�?o}��%
����}�q��6'RVf�2�U��%�/EWy��T2�������؄
��i�9�*�Ȍ5!S{��LU	, ď����{�:C_�̢�嶆:{]��BF�^X�����OB�!x��ńo8����4|t'>}�b��L<��OZqeXyq�"������,G��0��e�+���G��}�� Re Y|��de���*���ߖ:���$p�ԫ�k��7%}��J
wp*�������~/�K��v���ؽ]�A���s�@��9<�:�������+
/���3�����
��G���X��~��F�E�kb�uz-^�Z����KǤ��JܢE-ZSF��\�F�D�a%��y�4}�E	k�8q0k�7Õ���g'������x1I"E��I���T18q� �WL��'ƻ͉��Y4��ݚE�W�IG<y{�~�,�Bp+K\~�����$�-�bm ~e�����H�-�	 �d�|D��C��Ô��}���\��O(�,�PY�Br�3	
�a)])@yj��O��>�zxp�i�h
m����u��MyD"��n�6��e����	Z����k��|��$�M|���צ�w�����wZ���h���x*�\ [���BNL���D%)_���%�rQk�Rl�6>+��]�H�vę<�h�)���=�7� �j��x�h|���=��EIYM2�P�ً�� ��|J�lJ�<��q�Gd�d�c�ȑO�c��M|�;��T���S���js�E	C�z���T?���h���b�Q�k ��H~s���4M�����x�\�#�h�j�|͍��}���8��2�-#�p㬹��|t�]Q�Gy\�-���;�Ѝ��|�����D>n�z��Ŏ�&eoI���h�7w�ؐ��IΪ$<�C_�����[FJ�����xΓݝ�>�2�+	'W�c�����ft^t�:q$���p�=_�{�>�3E��Ą۫�����n/�m|Ѻ�nK'E�C�2�������2)����O\��`��&T����f����?��/e��w]�e�bˈ/s5���/\�/�2�/\�J��������+g�Ǌ�����[w�r��D[=�h�����;F�J�r1�3�e�)�v�YF|�N����%	[f�-����|����=^���Ƥ�q$��l|�����{-wAԧ*	�fM��T/]�xqD������;��/E�#�-�!0�&�@F����D~����+��j-��G�V�;��<�9S�\�Df�\�Y4��Řk�Q�r�X�3���,�@��2ʚ���j2�#��W�L�$�_�V�
��N�#�Ӣ)��������K^ɇ�E��5�;�:�L|/�E��HA��wp~s"�a�_���:��c4����f�Y�����t~�T�����:?_�3m���+N�8���?�77n�%��m|�|�l|�֚sq��
�EQ��+�e��)<�La�p���n��[4��p�K�\�&[��E�I0������C�[!n�@\����_�i6~��n`�G�|����̍�h%�'�?p�&Гlv�A�#�����]/J��[F��|q�g�3U���ۛ��m�h��`74�2m����&
Te��߀�iK�%�oB�
���2kI��s���kv�q�keC3)�0�v/���1�&�Kv�A�r��H�g
�pOmSB��tOmS�\��0��ߥ�$~�W�m�k��h���h
�+0׾��Ƈ�T����-�R�A�j.%����ʎm�'|~%D�2|ڐ^8Q=0�H��w.R��7Q����X��	�$����b i�����Y7�hJ��b��&tk5D�8x��-#������,�cL�7R��_�PU_�	N��s��O��3��$PP@�6��'H|��`�%����_z��_�x~e�����ES�������m9      V   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      W   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      Y      x������ � �      [   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      ]   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      _      x��\k�,���]g��;���Qk���c�$(K��t���P�	��T<�Oȟ�	�����������k��1�ɰqP�'eJݿ�*5j�(����a��T(���a�^�5m�D�J�;��{Pj���0P�'%J�ߴ3���4�T[2�Rϱ��NS�kH1P�'�i*�$��$>M�w+{x�d>O�7$���W�mN��`��'S���7�Sl��'S�ϡ��a�ʈs���a���{��L����\؝R�7�kX�^��)�~��^�O��Zܷ6�_��1M��k���ba��o�|1ߪ�?�H���T#>)��n�cVm"�)t��ۿa��4�S�S\�e��������u>�6s.�0P�aK�n�%�)V�6s�h���ĵ�sl�a��^/i1���*m��z@1��8��:�z^��n˰	aN;��ݦxP�v��sl�a�ru���6��:u��)n�u��?����}y��0�z�P�v[�رg]���_�׆Uφ���b�b{udC�t��f[�XV�hX��c��pk�11�R�h��bMC�����-/100�)@��V7���:�8��l��l0ja;�5��zQ�O����܀���7����_U����)>"h=�%6X��3���Kj�R:M!��0Pw�[{3g��U�?��֬|�p�@�Ŗ�Mg`��3�f�}k��nc�|������baxo]���8��\�궬��0�>��v`�9�K���f�."\�ϫ�9�K��z�wuq�t���j6���̹��էQ�a9nV��<n�;���{��|lٛ�^��"f8�%,���<˕n`����A���=�a��O��6���ylp��|`��{YkV���p5�"vkZ�ugɅ��mt�0Muuv>Oq�K�nO����ʺ:�U�p�|��B���OT&s���X��t�Yr#n�Y�t��3#��ȩ���7�RG8�.�Yu�nu*ͤ�fe�%U��y�c��|�͜)�:_sX遁�N������cF0��Қ�%�50Pw�8���R3�^B�KC��n�\��-N�jx��[Ϥ�x�0P��C����9<�syoj:-��גo:���<6���)N�R}��6�1��E��%>֣ΰG�}�u��a�{�_�:-�Ɯ��NK���~5�S0��8��yHfp_ڰj�״�8Ňk��z���޽V�;c.�k+w�V�S���cISL��jȰ���@�d͖�����d����c�ϯ5+C�]%=c��a����U�*9\cм�|U�#-u����Hp	qd�{� "Iqd����)Z\�jm��*��DD�����V/�׆�*���늆�*��c�5j�GjX沴��*�����e�z�����U�2Te�-�YM�0�:�p����^b�k��8Ұ���$�U1��ҩ�b侶�t:e���Nlkz����5� @������@�Fq�i:�4]h����!qM��T�)M��-W�0P��v-�r����N*�6�2պ��a��c�ѕS{��ʈk;���nS1�*j��S4�:b*���k`V�L��ؖ�ؖ�Xr���iR���%h)ARXܗL�� �׃���m�̅�չ\�y$+���ǳaиO�w��>�]��w�����w��a����r�E~�G��}E(P��j�IjW��m�j��t*��6�!RM2�R����$1W��00(:�;��*���$|����`J�K���)�W[��
[=�$Gp�xbf&x�G�>Ef����RE30�J�X���A[Qɵ&Tj~hA���z�w���0I�aө�����]yq���aJ�o��kʯ�����a������z��}#��Ԭ3Rҕ�ޫ[/�m�?��(�@��J�[�0��R�K�=G�mq�T���p�S)?�^1�,<Z������p��D肑ˡo=S5�f^Ю�.�������CD��!5�6���iJ�T6�t����E��1�z(�)y6��<��f��R�^�0P�8oj3��7TU�v2��5�C�Z��ꩌ��!�A�����ͻD�@�Ek����0Pi�Zo�tj� �B��Er`�`X)���=T:��f�6���Y��ֻ��O4챰��L1r ���r��̫2�W�Q.�r5��0:"������Wm�'��	m��J�W��ne�Z>;���׌�w���FD���H�Kh�:�a��2��A�WN�z��j��3.�b�[�^x<{�>]�}Hk��:d�,�fLRc������00E ޔ1gS�.�30�e����Ie��phe'��n�놬��P�0(W�b��h�|1O���ic$��5��Բ�K�3k�u�m5�{H"ׄ�5/f2���H\�f`�Ue�k��2���*�5�00HO�[k������c�Od�|��W8�ǀ���Ɉs�,��Y�t/켓	uo-M�R�[K�IE�{'�׃C���Qc�����x��������-�s�U0���u�*�py�G�[woN�AfP3�I<�9p�q�� �Ҏ�ϓ�g���]���\�D��9 S�=��C~����K��k�70(OR�|�ac�Y6�i{�AR������[�7m�DNd����+/�cRPz���O�YN"�`��<��ۚ�ĳUJ�y9&�r��u��UN7Ԭz���L�@�Մ��W�vK?�H��O�����m����0چ��ȂW��<�q���0\��_���65=D6*F�f��o���J�`J�+��3�w�L���00�|���6���.sy ��d�a�R�X�A ��Ӊ\��a���e�.5��\?jxS���g����z��WX{g�\Bb��u�!�,�a��9�)G�]:�s�f���0�"�R[��a�ԃ����i���`m�{-�^e��=�rߺ���>\�/�.�<�ǒ�*������fy�u����愓���~�_��*�ARq�'�a��=P�Ŝ�y�w(��r���R�vMu:�a��ŕ�����\$�c$�b7�GBC�lٍ8��($�9�Dᆁ*�e�F,�ވ�Gm;��K9�5�#�հ��#LZ��{<�^�|��0P�~"��Գ��,��m[��l��eMu*~���IݕDG�${^���	(�l�ՙ��(N
���0��#frj.&��10��A\�0�Z���fnu{TD}��d8j�b.Dh(ݜP��{-dqJ_�r�x�R:�z��Qt�jS����w��7�A�!�M���0�F>B�Bf�Oü��GHRș��;�?�_:T��oH��JwMa��v��?��p)5�){%��=y�qY��=��Ǹmc��5P�d��]�mV6T.5X3��ˎ�I=�#-���{<����d?5�J�:|}�a`
�������TB��K������43�J�Y\ҍ�O.��ۨ@1P��Z3�;�*�A��\h��E潱��>�s��o��
nӽ&�kz�e�˕���L����3fZ=���Y3�W�s�L������`�����<%3�-�	�yI�7���~X�&��qb��o�[�N�5p���C+�nY�.��_.��zښ�1P�:|�?���G-�7D>z�B�í��}��@�n�I7�r+���ʍ=VU9��3\��4GnGxoF�C��W�퇻�I1���%l0�`��ß���%ӏv��f��uMs��H���<$������S0O:�%�~�����1�^k���U�GZ��>�6Ԩ��C�@M�ݽ��@͚��Z���v��N��:�v�ZV���GA�WN~�ꩩn�ꥨџ��=Lb�\?���0�iN�|�O(wz�PԨ��z�j��y�xa�fE-8_�ES����@]S�ى⅁�*��sza���:=������އ�$6�M�_��q�U�0�����9��3	����00�d��/�"�i�$���%�R��䎸�����/�S2���^���h��%��∛�*���?����    ���RGA      `   �  x����q� E��*��f$�0��T���ȅu6�Z�?�#	�,�I�23oR���<5=X�>�y*.m����,{N.LM��4l�8�͆$��fW�@-��ѯ�]�ڨ��-S�}K���9���l�6�|���l��H��q5�ܻ{d,_� �V�7��!�N�����O�8���F�5��@����g	}'��\I��|EC&��!�$��s�{$���ƥ�5��!���K[�{Gm&�R����te��C �W���u�7�R�u�4�}���m3ڔZ]e<�W�@�����!P�U�X9��Хk�V�!���,*.Md@�ϰ>4�����|:qɰ�C��/Y���wHZ^F^f�����Nqź�u��?���!�N�鬎��u���&���a��ګUr�k����	�`��n��_���N�?D]��ҙ~
�	����ID?Vw      a   ~  x�}�Qr�0D�3���%�e�e����8�Dg����.@��XD>�>�h�*�%�S��>��L^R��
e.P#�kH��FzR	����A�T�{H�\�N"С�2y]$g��R��W�|KM�ϓ#�u��j�<���C.��g�#.v�6�S�ϳ5?q����>o�y�ϳ���R�&�+A����j���&���1J*�d��ϧ1�H�a��)
������=�����֓�T� `��GI&����I�4����h�M�������e��.��I��r�FK!M���+�����nL��`�X�ii>76R�!�+҄�$�6������T��8s�[M�CH,�֡v�5�R0�D�����I�n5���B�|�F���N��q_ ���Y=�C0L;���!�V�k���d�XHdŰ���'�`D`�X;�[�O��z9V7ֽ��  !�1����ȱ6ɕ�ne!�5��k�qA�(�M���D�7��a2$Mn7�K ,����`�K���r�#�B���(,$�/�`�VVi#,<(=%_t���\ ��ԡE�d���p�_��Kn��}D{��:�y!��؈�������V����Ν��v�hD`S�I���C���Ӹ��� Hu�ƭ5nA����7sA��8��jX��w3R�h�����N��ָ��ܘ��f�zik�����=�ƃx8�ǚ��N���%�r8|^(��y8���fȁ%}��n�m#�O)�J������6�`*��AШ��9�� 8��٭�A_^��Sb9����{�)���vV����,��҃��qA*�d�Љ�Z��><T �p��hj�+���J���K����s�u��:p��4?R����"�wE�Ւzɗ��|(z0$�<���T�i܎�f)uke�Ft+�a�񫅇�HH�cM��F�(����?���e���ą�SA�i�$�9�n�F#�X/��}�� H��4�Tiyw��:(�V�n��NI��vK�w��ޓA�*��%p3X�xR��am���������u�b��w��_ut}�޽WA{
��������vWA��F-G���!de�T�{��G�K�E��]ce�����z��9t�      b   0  x�u�ۑ#!E��(��l!	�G,�{�ٙqsU��:FhI[Oړ$�j_پ$�$�|�Z8�tH��)ʩk�F�1�h�^�s���E���4�֍ipzi������_���m�SR����f�9u�����8�f�&T��Z�$dp
�����)��k}�6�q�M��3�M���Ғ����fN��p4l�ʩk��ƹܛB�VQ���`s�J5�r���[��)4@�$��&y-0��[�f�N�Ca�pj��ߩk�6
�g�=���{j���s��7 ��&I��[+T��C�Z曤OSN�IZm�< u�=��[Q��rѭ�`��e[����������y������ZV����֛�
�p���xS�hA@�E8�����<�ҦЂ�3�}��M/㋍�F�߼�R�b{���,
�E�����>��{��GG0\�:��E��_R��gD�e��Z�rs�ڱ���q�ڱn;���R%DI�i��>���+��JFs�hۜ����WmQ�I#�}�_ԟ���v(��1��&˜b+ϴ��KP0�38E����;���%���纮6��      c   S  x�}���!�K����$v� ������6�+f�î�W�>�KE�%���S}�1E3Vt4�X���p�Ռ���Q�u�w�Ǳ'c�3�S���a�r���t�k�)=cp�;�8
g����N_���%��bU���1�̹��{VL�M5q��y��~��tT�=�Mq�{v�a�u�gv�a��v�g��R�MA��a�l��џ`�[�'=��S��~ɾ�`phd�18,��y��w�1g1����I��������ނ!;�>��{�f����-�>8�=�u]s�w��u08�}�aIr-ȵ���܏�-�.��H�g|���Ot�����o)�q�JY      d   -  x���ё)D��(���@��E�����`$��zE/�R��j�ϕ���ߋ"埑~��#őڠv%��~ݮ�҈Z7i��\]!����iH��C�c	��M%S��N����YI'鮇 �6�Ф���+-iT�IC��_o)��?R��gw�yP֟Eh�t�����X��i�~aH��B�!E�PF��W:iH��$���J��jv��G�f���o�s���ߍ�bZ$�s_Δ}�[���5S2�L�G*#Ӡ��,�fW�Qo-e�=W�eO��B��X� �p���2��ۧ[=���2�S��҂����"Jte?Jɖ��)��)�T�Y�b��ׂT*Z�{m\����
9a9�HC���nU(��y�e��ݩP(��Cc+��V2���Ep��9��δQT���U�Rr|U��QUZ��Fq����k�n�K���+W��j��+y�4�hS40[us�H_�P��ec�8 �����$�o�O����Qu���lb�[���tj�H�d���N&�h�B7&�}ӳ������ǅb��XǈĽ>.G)]� E,��2)'?�8�Uc��ˤ�1���ȃ�`�h�B�t���:��1��Q$����2N��R(&=8Z���ͥPH��GӍ�o��"����d}ʄB�m�J@�h��/6���4��ݓ-((�IlF�q֪{�PH���ױcV�h���(p5HIK�BZN�|��B�n���u�a(�By'���L�x�}��Pl�_e߻�B�(��������Q(����Z�h�d%>w=�	N}=1���q�+�\*ʖ���]�;�;��!z�o�ŗ�:�A0K�(.�ݱ3�>��d��n��e�*�ܢUun#��v����ܽv'�s-4P>�,Õ��m�4I�;�P��j�M�q��Ƿ�y�l�r��߲LS���u�
�|<L��Ȥ��H��*B��m%�i1ީ��|����p1����ӏa�&��C�JҖ@("{HȦ��P\*1��J���Ы�\��C$4�vz�yL���vj�������R(��{�y��ƣS�r�Y�f��#4xW���G�)�m�g�Ti+f��?}h���%�����4BaΆ��h=e~��W�b�Z�h�y�r2�}�S��ɠn��L�ߧ���aY(f�Gۓ���F׼LWe=1�z�7�U�k�Z�����^mU(,���i����B��ge���P(��ҳi��Q(|�}�=��(��R��OJ��o����^����F����qh){�\�wK�tK��[/���$�-%n|��=[��(���F"^K|��l4��'��7��-      �      x������ � �      e      x��\ˎ㸒]��B��\T�����e���ly����r���;��?0AR�)��TeJ�	G(>"J9;Oϫx��kz?����#�	�`խYu[�~?�?�1�xȢ0��я�xrJ�STȏM8>��)-��C�����������?����Ҍ�E���b~��^��K|Oы�\�_�����$������w����,0�&gm�6�@��C�u/^}��hܤ�����)�Oq���0>�XEO��4浗'?��h�xr�~5�v~�y����p�!O��:x4OR^k^�,dINQXYʍ���7I�Y���,���&[�&[�"~�C�_���	��)ظX`�����O1I��6a���}Lm���w0ޤ~���KJ� ��K���{p��pĵ^?S~
#��`Ȕ��mdWu�<������hk����05�@�l���\��~���O��LIoQ�+F�
F�<f�4�0{���==�{�7�AL�j��=��x.�^���ĀB�Pg����46��@i)�>{�JO����`��+�6cP���m��?��������W7�Os�0��� ,�ۉ��pv
vR��#Œ�y�Q��A�=^}=�oRq�#�e��SDM�S} ��w�R{̾HF��40�y=TD�x�bv\���w���t�n��r��ζwf$�w�<%�r@J��E�V�r���uk��)����6lVސ�B�r�}("�X��xu���`�o���;�(=AT���h�M��T������fKR���s�3���&_�Y��@��*q�X՟�kSB�3����,N!TfY�`��k���H�U�Fr�"qIkZ\�}�g0�z����"���R-œĎ��ya��m.�FP|�Z�ޫ����:�!o���7|%c�$"&e�-���?�7)�r} K�̳txSN>As~t�8�.�����g�	�[���4h�v�u�^"�gz�O�oh7�ͳ�vqÌ*��R�!�ZF*
7��k��>�0U8��� /3qD���������h8�2��*d��D�,�#�^?+*�Ԙ_�F}�j�)vrB��KY��V]�l�a�㏇[C�`h����ϙ��e�\'<��j��.�Ł���wM�>����F3V��K	l��[��2��x���-����`�%�q�Ӎ�.Ӆ~Wu;���^�B��S�}�A�͞�e�w��/k��0U>,�oȦ���m	7����)L�� �$$ｆ��ҍؚ-����L�����!`a�:.��5����%���xR�)-��G�����N��d~l�#L�Q�Szߩ vy�U;�?�f��<���BJ���-�e�8��;3����~8E�9�wJz�ۻr��}ez+�&m�wG)~��3�X��x�-��Կg�bh�X�d'�p����ص�ZBcf%�������l��p���wQ	m�3��}d1o�4���)9o%u�\�ى�Rxԇ�t{���jp9A2���G@�w���N�0�x/a[?�O�9_H� }RҖ�`K��Ĥ
��V�E�J-��T�B�CT��!��l-*%5���cM0�k���y޵D����r�����?����؋/ʁ�oɽ�}�iUA����Ĝ'�_;1R�"WG�r���-ﱃ��
:9���O��5G/�����^�f %��	xᩚm���^�5�"���:��a��c�1��]<7�>�N"��i�DkM��Ss	�N��ؼ��<E<����>
���)���I�R��˔�(���â�U���G1W��%NyJFy�x�`����K�/�r�L�o�0J��IU�\o�[ۮ�?�S`�b��8�1�f7���KUl�m�{+��e�*j��Z���nA�́a�:*�2�M2�U�8�d@����O���j�\�A�B�uP5�c~��OYՍT����ҫ�l��b�p�3r%�P r˩KJ��:Gk,�@��n�镮�6�a�d����Q6|����w�Е*���󪽞�E��7U6j�D��f9���K��\h�ܘL�v�Y���PB�b�V�I�4��|�'�e���<r�h�B�v�����m���j���~�Uad�����9$�mk���΃��٧�E��ȸ�j2ٻ���27E&��kl�2ab�v��Y��L=�T0vAN偪���V�6p ��z&O����bS@���;�5Ŭ�gr�,C��h�{/_
�~C�h����R�ۻ.�5�bS��x~�Ig ���MÐ5Yd�5�b��x���^�L)�g3.�(�nq��q���`; � :h�g6�6r@��"MÐXf6��k���̐C�����`�Pآ]�\��W�W8���T&�SpoݳS�~���5Q��$��x�lRm\`��ti�˥eҹ���z�B]�(�Pbo�*+"z��4���VNRr�����5ٲ����xӮ���ۻV���8���H�5��ym��\x�B��厠�}��'Oأ�J>��Ucۻ���2��̀�.ɏ�E�g0=GJ�U��@�ƫ��/�|9k�%O�����м�J��HÐ�X�����2����
C�r��5��B`�(��0�r#u��'��}+�gޫ|�O���%RƇ�F�P��m7]�oجIY=�b�ޜ����%��l�`����KW~��}���_��<���[�^���`�/f]��L���2}C2!l�-!of/�0�MY%�����n˕[aW+�2v��K�\~yuX�7�0|z�y'�X'�xV�՘ ��
���e���Q�_��UA�Vb��\(TT���~ ���?��a�\��N�1z�m�r[a�-w(nK�n�a����;�����֛Z?���T���l9�>�Ĥ�cˮ@�豽T�9�H'v�^vküC�آ��b�2���+�9D?�][`&l�	�o��=�)���z���Zb��@GN��R����@���vXW6O�>�����p�D�;����'���e�����x���<���Q�<����U�F�ô�=`�"qy���I��G�hU�H L�k}��6Ls�i"���b�R�l�v��|�^��n�����jc��[V{|���)(�m��m�w�>��^´F�0��Y�l�Y�.�v�f�흙��{�s{ug.�r�-.r�l#�|�*�ڬ�s��\��6�+��J�59���̵�q} �ƈ\���~��M����m�HXLZ��!S����U\e��n5��c��S�������(��>�0d�YKګe*h\p$H��q<%�t�J��~���{/_�_�k(��{�:�.�N����˓�zEÈ'�˶�Un�PK|��	�%ݝ�Ya��8gs<h��k�ww�����T18s����D�j��R�d����48�2�XӔf��uմ�/��	��o����yDZ�KA|�R�� S�0>|��E�Qʡ{ʛ����D��!o�E><Ч�����3�T4�S���`�����%��!efɥ�9 x����[8�F�fh�j��j/�U�\XJW�_�ev�\d�S���R<�#}5i�v����jF��3�~OX�W��R*@���������|~l����k�qD_	=*��7�#������gz�z>����1�"�"����K�Ϝ�[�n1Ą���N�z �d�6��0�Mw��G��7ƙn��t����㬽�d-@|ٵ|8X��0��wr����˪1���Yh�+�� �\(��\��ᆪ�=���	�nC"��]I^{7\zJ�Ve�P���5��CJ���p�R['�f���R�<�‽�x�,v͝E�~�j_�������68���۠ vvĉcKh��s�]��=�7��0d��M�i�Q�)�0B��]�oknb{�eJ�>+�(��;�+�b�|���"B+q�=�(�^��x��9`Ba@Ð���6^5=]n
�s��O�R�(�()٘�ѓv��#&��Ǯ��9�yz����I;< ��Y+CV�{o��!��'�g�|~�@� T #�yt����sL�;�M��5U���P��{�W؇�~EĀ����"I�^�m�C�p��wl��2`Ȟoi�)� B  j���S�w�V~��Q ��Q��ݣ�t������e�	l�����x�9v-8G�R�>5:�VKn�m�<?��m�U�!co�����]v_�F/C6v#-����F�{C8�ԩ��i�� ���0d 7@��0.���V]�5�	�YC�s�����oc��5O��Rw���c��^�?���n����V�9:��y�C�L�V_ڟ�����∂,2���iD���WU�D/s����y<d�<�|�Y�$�Xt�]��1����䫍&YJ�U�b�jɏps�h��f�\�kɍQ]�\d����i�Γ�gjK��+�C���5��vf��[Z�ɾg-���˘lz`|�����^�"2Z��{����c�Q�ܬ	C��m���)��r�	�q�3u�>���c9Ý3�a��3���n���.�5aȔ��ȃ�?ߎ�zxy���#�<�BNC��\t8�d��e��%��F_�����0a� R�=��oL�Z_.0L繫���p��0a(_���u�#�;>���Dq;����f7۶��)���f��K'���'�NRw3]�`�hkj4`�Cŕ;���r��C^�]��x�{���f�6�1>�eɦj]Kr�j��Zf�:�=�m+�^��Ն|����K��X]�cynY��������{G�˰l��Ȱc�lM�	�4G�d�I��(�ٮ��Sm�+ް�MGl�
N��[���ģa�T��v�*�ĨXP0$�ֶ��˔ηm�$8L*5���WgA�].�~�Ƹ�ՠp�!ka�&r ��~�'�7X��\:󈩃�b���Z�/�O[�0�Z����� �]پ�C�B�g3L��5-=ۼ���X{Y��̭�4!/k��u4`��B��ڱ��m^����v�o�	��Kq��^��|�tt<�`�W����ӆ���dM9��������\V�=� ����c�C��~�RI���TV��a�֡m�+�	�&��@F�c���ٍ�)K�=wV�)�B�x�w����+�p�p�1մ�⚭R��:���&��]��b�tF��m}�Q��^�t5����U��P+�ʸ��j������cX��      g   �  x��Z�u�:���H�!n*b*���x$ �I���s�E$�� ���Q�&�-��	eg��k�@f�Y?��5x@k�$����]$EN�߳�����a�4�s١�k��~CB	)	}C���6I�KRw wm�����w6r��I�1mm���1F�͑r;�\�wJN;����$iߐ�*e]C����殍SԘ��x�'�NmO�E\�O��=e���%�*ٓ�#bP/7}��������i��	�φ��h0*J.����p�h������d7H������#wm��յn�Ii5����77 X]��kD����9�7jLP���	~�o�Ee��,���� f����)*D���d�Y�
�v`���������
p�8*C�5��A�>9h��Z�Qg���=G})G��5�5��B�
�D�є7�7�j���u�u�u��������A���E�E�myj�N�d�B��Z��i��Q��ⲋ��N�L}�(��>��lmO}����+3�`�$�{��d��q�,�Fy^����/��A��0��A[�Km�H��O����N�D����
�Jd���C�ʍ3�/">��BNNh�a�Y!5HtF._$�ڌ�&+p+�h�LS���x�܍��l����!��t@�Ҳ�����Ӕ�eS'O5����^7U^�u)cs�T%Q-���q�1n> �&N��9�M�?%y�3�4� �yO k!����"c���!)��~8���䶳�o�*	���Ũq�ˌ���$�\�n�
��Q ���<%3�-a����V?��Ċ��l+�~4A�W"�l��;	<�9�!�T�7�\=y���M�64�<����m�g�`}�_���f�1�{V�C���b�����b���Ȣ1
45���D�ݵٟ闸v�n]�%��s�>y,Y��^�e�y����lY�ڧM%��g�ҢUi�V#=Z��(=��c����13qLA!b
V#��ZZ"F�����;B���h��5F�`E�1�	���eԧ6�gI�g��U]mo�
�ۆ��ƀ�jo[y�TTbÀ�4;2{�u�ѽǠ�Ie;+�vVu�c�x�|�%`�Ҭ;g��zx�A���eAk���F�)�2Ѯ��&w�
կZ��ʏ��0�K������"zV�4*���e��pI�QkQ��Q���V�ez��*ND�D	v�)���xHq%�X�bpb�u!!�!�������g~�M�V�s��\��]vp*�̀O�1�����=�����&��h]�y)��j�����,��k��:R�� e`�0��X���H�揦u N�����f���(�w�E�u���e�Gh,R�Ӻ��^GoOȝ���i'�cQd��_��N���1�2��3�
i]�i-��M*�������nk�<�[N�(X��d}�L���s���#
'��dؓ��=���5r���h�����G�S���Z -��d}��L
֎Qv�"�P���^����[.��JOH�'r�( �r��<���F�N���v��LZ��}�ՊmNN ���1�b��a��z$k��`G����Ŕ8XĒf*�2�:�pꕚ�����(��,��<�kH���|ؑ�'mA�������������3	A���JYN{�������ۿ��������� 1      h   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
c      j   �   x���1�@��7�i��ݍ��ĕ��D���/�#1��}/iN}�fg�mzvu;�#�,��8Vr*!˅����	�g�6�W���n��zo�7�����-�1�0Y:%�6��F^��q�܈��4T
e�2���U��o�/>;      l   <  x�}�]��8��˧��%�?bO0�?�&�*ې����7XB �k�O�������}��q�r����/���)�r�f��<�tH�p�۔Oٽ%{�p���?�E�Py��xhG�Py��#�Y�~�H&osD)�<��ۜ��T���}���M�H�*��?��4�]$T����O:%�� ���؉�AH�S"[e2�J|`wB��ŕg92Y�� :!ځ�EBe�<���\e����ܚ���#2�� ��MAb^
�!T�	Q���PD� �I��5I���2D%� u�A �%��2�N|LZxLA�\v�T&� 1�)��c�p����}$�P_�`J䔘"SB8!J����d#17��̇� *�+�9h2��_ab5�d=�]�
��� X̅{5c�J�9h�� >U�g�d$�ab�d�>�MA�\M|U�!�h��4�s�*'������w;�ż��Ce���d������[R�a�,�T�<�7N�]�� Hm��>�� J|*��A�A�x�k'H�A�At�C���dL�	Q����Ε� !�l$?LA2
&VKL�v��Zb2!�Ce���+�A4JTҗ��tK�� �� �1��q�`1���O;�Ŝw���^[r�'���c�^2��j�A�W���c� |�Ք��sp� |�|���ǒA���)�׺%�@�Dב�uB�ط/ĤDe�PyK��\M(�\-����NɒA�����/n��{�%���_ ���[MM�Z2�+��Atw��iƷ�%��Y�d��	/Չ&oi����A��'$��� 2������D��%� y��O���A�C�.�Mg��dc>T�k���GP����p&oi��*���,�5�M,�s���z�(�GM��|��uؕ���cX<����D�8KA�a�_$L1�Sᯐ�c�u���X�3�G�7�� 2y�{�%�(�=Ml�LAr&�T�|*����j� YG���d�C>Ma��d,�_2�_�Ihm7y�au���5�y��ڹB�]�WE�W*�(���4r�D�s�AT�c��n2�F|�C�:T�9�}�/əŃL ���cƩ��A�7���KA���P�ʐI_�&�����GI��3����u� H~��Vn�����s�Ad�F��I4��rɹ2�p0ѕ[ya�8u^2A�3�%��R�f�K�"(<rƃE��6B�-�`�oE&� =Laΰd�}P��,�⁲�Ή~,(e$�M��IqF�d,��'1Lq����&o9Lq`��:��A�׹�?ڣ���e���*�%�AO}arӏ[!�����-���h����A4B����"|���-�	˼�ɺ��-�H�(��e!�g\�����MXNS=$BeB�*��nD%D���A�?:/S�d��~p� Y���g<&�1}�{�[�{\G
��-�H�H�$^2�ב�onD���/�!�/��wd��"���2�F�J*�%��h�G;}����{�ALBLA���G��-���謦�j�E�, %����*ZЬ�=�J�X�^��梕Z˻l�:�^�Kd��
��@T��WOt��ZKf�awy���?B�uo�2<��I��iY�7�@��_}	{��Q���!��(��x�ث����Ur��C�Ml�����$�t߶�����?u����R]~ˮ1��p��UED�)y�G)�l�=�S]2�W�J�&���ʨ���3��۠*��u�x�:���cF�ry}��U��y%2����y����|4��Yw�D?}�wO���Z� >����Ah/:&%
�a�/ɓ���� D��63%
[��D��dg�;�h�ˏ���Y��-{��h�]�'��yz��v���suM�O��>��۠��_�6� '�����W΄��D#>ګ{}VwQ}�_��&wkw�!����վD�g�j8�D������=�S�<��ڋH�����"����l2Q�)2}wwJ.��:���׬�K�U4��������U�nG�W	�-d$��j]F~�8b��a?���R�?�l��}���      o   �   x����� ���)����8�.̈́,K���1����k��问�����(Y�������c�t恣I0�f��8C@Ղ�7�(
q6������qEr��jM��&��z��Е`�<��㖄�r{�k��� D��y��"r��D�E�U�c9����i0�@TZe���/�sU�      p   �   x����
� E��W�ʌ�sא>M(�nK骋����@,���l��p���$��P�*�i��J��~<�HC���%L|�����C���<�]�d=՞��љ�S`��i|�),i�oM������כO��c��x����1�]di�h[J�$]*�V+��i��X�Q��v�)��2�f�ΚW�� M^c�      r   p   x�m�K
�0D��)t���;ǘ�BMȧ�����,+	�y�7ǟ(z�j��5 �A�Vޡ�'M[a�8���*\y	1����l{ `8�m5��N������>_p������3�N'      s   v   x�m�;�@D��S�F�@H�Vi@KB�?Aۤ��4c[���Y�fs�,EN�*h�Ӵ����yG��yZ��In�z�V�&~uh�ӐZ�F}��W��
M����{B8 U$�      u      x������ � �      v      x������ � �      x   V  x�=�[��(�;3ǒx�e����"��Q���N��x���g�n�C{���6h��hmk�o�fu[݌�W�+��J|%�_���W��6�&�D[hm�-�����B[�͋��ڸ�<<���@;�U�;w���&����-����������=0u�Sƌ1A�ü0-�
�0%���}���������6ތ����f���o=�F/Mw��������a��.��{6�ݴ�Z�l����l;M��>W��z)_ꖺ�@K�V��o���;��������������������������������K|S������iw�~G�z��pa<�]إ]��i��ݱ�K�%�z	�L��$�q���E�/�K����	�A$Bq�c��ڠ%(���`�?�,�GK<\�/�{���)�������9{۠MڢeB�	�&��l����m���/�Jԕl+�Vҭ�[ɷp%�Jĕ�+!WR��\ɹt%�Jԕ�+aWҮ�]ɻx%�J䕴+qW��r&˩,粜�r6��|���&O5[��R͖j�T�����ۼ��6�6���~��nt�v�����m�x&m?�����բ�G-Oc��bBL�5��A�eb�[�LZ�Ll&6ӧX��1������by�L<����$d��X�����χ6hQ��;$C��;$C.��B��.����R$k�,FT�j�
�2����H�#/���C�L�3�ϔ>S�L�3��;S�L	3%�tq����k� ��O��>R��<�<�<g<G-'|���CI8�9����!���ܣ�˻�۝��
(8A�l+`"H\�q%߷d*/S��'h'-�"E�VZ,	�"p��\���:� }t�!QĢ�TN8e���d�������$�'�A�/J~R��vt{�|������.���by���u���3V�P������+�a7�ݶ;vz	��^B/��P�B]�KGHGHM��H-S�r�r�r�r��K�+���R>��C�P7}(ʇ�|*���N�.f���r��٤��u�4\�pQc)_ʗ�|)�ʷ�|+�ʷ�|+�ʏ��(
�(�r�)��8ʏr�+��0��
�(������t ���_)�t3gi���_�����9�q��Ygi�e�%��Ό�4�Ҩ��K*7��X*vy��r������K���N8�7��w�c	��s��Q��T�������Ա�
��0��yL�:�{M�a��u�錧a��uJi(����2QiD��FTQi,���A���+��E���N+W�\�r5��(W�tV.J���{P��<�� �w���:P���sRN��8��ɱ���l/d��d�rA|�D�ܻ��I-�Nz��l���+��%�P �?�'����}�O��=�'����yO��;q'턝�u�N��91'��{�M9'検��q"N�	8�&ޤ�p�m�M�	6�&֤�P�i"M�	4y&Τ�0�e�A�bM�	5�&�$�@�g�L�	32��O�D`�5�&�d�H�hM��3i&�d�(�d�L��1)&���E	")��4o3q#��K݆�̽�[��[��[��A�/�xo"f�,�%�䕸�V�JV�*IE~��Afd�Afd�Afd�Afd�Afd�Afd�Afd�Afd�Afd�! �x���Q6�F�(��|>��|>��EED&�Dd�h��+:Z�*�X��V��ٟ��ܩe�kB�	����:� ��
?cO��h	-�����`�KV�C�c�!��]��|Q�M!�3�<��wv�B����a25��߶����Y�0�fQ�,j�E���7<�g����y�3ox�ϼ�6̢�Y�0��,��E��HZIK#im�;��3�4E�_�͕��E���su΢�Y�9�:gQ�,�E���su΢�c��%+�ՆQHH	� !�$$��d��LnJ�+N��4zg,*0�����&����S�ϻz�R���`�rI,I%�$�D�DH�HqU�j��]#��5n[�pa��F���F啔��_{�EęY���6ރ�f�w�E(�Z]��jm�Ҫ�U��U-�ZU��jMՒ�U��S-�ZM��j-�R��T��Q-�ZE��j��T7��Sw��S���N-�����Z>�zj��ک�S+�N��Z6�jjє����������Я�      y   �   x���A
� ���x�\�23	��P&�m\�#x��.
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      {   �  x����j�@��w�B/�0����)$�[�@0�B����;q��V!u{���!�����6n�]�������12�D5kŘ���W�Fm50��i�����a}�nu;_-�Ŧ��F���4I�mkX�~�w9��o'q�%�$�6.7�8nG\�:�p�>�pW�g��"�E�V(Y��q� ��f����u���>5���>�S�{�rʧ|F~��_!rQx�K��q�-@O�P�fa�x|�ow�30����2�~�V@q�6��\��
�R/��s�mE]B5QA�"�N�����g^LZ0≳Fkq
��Po��i8T��|�0��*R0�ft�O5�'*�t�T3��j��yL9�̊x�5邓���>��+��w�ؙ}���@�Gq�����̚ōE S}gю89��b���EZ�Če#3�s#� կ>F�4j�qIǚ���m¦������N0���� �7��R"      }   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      ~   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���         }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      �      x���ˮ-�������j@�Z]�ðQ��7��0l�@]�ߤb���Ę�6re~#B�(^~���o�������߿Z���O�O�����o����?M��}��_����?�����G�? }�?���.�?��������������1�cI��e�=ZF�@?���_�S��?���sA�ZПZ?P��������_�������������뿾��O���#b���b�h���*T�Q�i���h��>����h)�b��G�{�f[������]r����?�7�������U�ı��?��������G�7{��~����՞bǃ_����Tmc�x��xX�t����_9�A-{��_@�SЖ�����;��Y�&�O-o��=@w@�(����+�!�U�QB跑�}��W�TnE�/�������*�)����FR���?�ގT��/��FW��  ���7���­�_l{0��B���?�)<	�O��`W(�p�by���g՞����ɟdi*a�5�׉��#��mƿ[��<����v�;��%�:}���Oo��_HM!������J��	��J�7 �!������$�C�(�V͸��P:�/0��As��Ä���yN����/W_'����b�I�-��jv�H��;-�
�|P�_�_���)o!"����/��pA>b��7���.+��+����$Xs�����0�`��a���}����cnc�փe�t�b�6����j�6��A�����+O������9GB�$��'۪��b5�;'�@Q
?']�X����^��t�چ_!�����݌��b��A��ʇ�6�m	�kMns'�r�`b)]�{H5��E�ML�V�{e;�o�Â�Cz�{�P�`�⧱���� �����;w��BR� ��n������Â�̉-4��Z���7W���[��r�����C�)�r�;Ʋ�Sg�d+�Ū݌��N؃�b��l�?1�+v�U9������5�X��Iv;vļ��N8}��yl��5��6=�aae��1[_ �P�q����n��R�>n�/�RT��1Q��_��H��g;"�s��#{o���*���
�/�Xl����ͿN;_�qa��$p�Ŷ�Hz����D�Sԏ�|B;�SH���n���h�M�p���]�7�c��jyC�O��~��s�0�5L=��Y=� 2v�\(^�=��Ax��_����@S?�,��V�3�'��~2V]!��=�_+�B�fwv�j_ ��Ĭ{��+����G�0�w�}0����)vO��ה����w�����ɿ<5�a�c��������m�uO��G��IG�?nx��C�Bh�|/�M�G投O�����[/�5�|ǃw���ike�|��?�������s��6>�s��~�У
Ђ#�a��6����K��ǌ��'ib��CT"%�2=w��t�yF�n��#Վ�ۢz�<��Ji�"Q'�����,��*�-��9U(���#2�Z߷�{��2�f�{|-����نm%����ײ����1���n���)��I_�sL�Eei!�f'i�^~P��f�5�%������)��[��H�^�.�!
Xk�4Y(��|p>kM���t��g��-n���t�J!���P��V�
��"��b3Q-~#7��  ԅ�/؎h�[R�H��8AȌe�t5���V
�/�	�k��r���6�q�v��0�{ǘ>�j��\j;�����ܿxI�O%���-_��*v������훒�~R���c��)>�u3R�@��`�Pza�u3z8Ϟ������Z�x���5
S�L��|(g�	�a �Cv-5�P�/J3�{��qd7�`^l�ϲ���V���)��
yP�@1/�F#���g#��R�q�A�1(�R⡖'��J��iX8>J���B�M�p���䁽-�J#�:ߔ<��P�n̜T$	a�������Bm��K�@�="��?d������nx-�VU �J��뚝����-�Αҥ�g��Yh�@' �u$P0�=�>s�n*^!���"^Zv���<��b�4>K���Rl�I�=~���W
�`V�/ʝ�-E>�����B%�{
�/����++�ܺ�^݁�)-��;J�@� ���)h�{��!���R�3w���aQ�M9P�n{�K� ľP����v�E:z̔;
�g7 ��.�G�Ƕ�H<��ϲ���$��q?��`D�24�t��!x�@o5��y09�N#�a�^R�B.�.��=��E�h<��|�)H��:ԫ���~*��y�l�"��G��`�c����y4���#���Cs�A(V�T[����C�H+n8��h+��F�H����`r�8P@���9��rI�@���X&���|�V�}/��A4Ē�g�2R�T��#T�X�B�k���b�+XᬐI'
z�����.ݞܳ+�K�!�Il�`�(聤�Zz���Ja�"pu�UK�({H�����WqY)#�,/;�!��u�����O��­�GѸ��6��U��g1�\��E����0� 4�T��)W{�D���Q�R8���[�ܧЭ��9��m}�'�x��^�cY(枘np�������G�s��c�ֲ���.];@�U2���gm0�F2/]� p�c�X�Mi�{r���9�t��Y�J��;Pt,<�=˞B�=Z���]��ק�}��G�-yX)x�:���ەԼ.?��B�<�p <d݄
Ց�1���_�V��)�pIo�����hO�i������y���d5�]w�2� �R��}����Pr�+�Bd����.(KwG�3���@���+E}�ك �O����r�yK{ZhԽ��sS$�ԕbw(3Rb[ >K�t��� �1�@�S�
+��!��m"�]Ei��[���v����W�g_zKa��|#PZ�_RZ(���ܩ��UH[��"ۊ�$��|�(@��[�4���R����=~��aPY!�")ymK1�Jl�Y��[u��H�-���mO�E�j�XI��Q�
AO`���k-��(Dv��ϒv�a/+ō�y��B|���,����O-��wn��=P4����6�ׅu\iXm�
�˿��BW9q�!1�Z^�p��yt!a��nV��V�v������Ŗ�EoZ£<���j,�w�T�wql��Mv�k�}���諝ñt}A|�7�j��k(?�r�`i�<_�WE݃�Vbr���ҝ�˨���!����F���RGW��k��F�@� H�*e�\�����e�P�J!w�TZ�񆩻@�-�VF������X�a��ե+d�PT4w!lƑt;� '
ڗ��̜Z��n��%�K�
��q�"@�YҥK�V
�i�1�]c1��4*�P̼�wI�=64c�/>Q+��,���R�2υC��Q���"�L]��H�2���)�m��a�zɯ?��hI3��Kx��K���ꙉ��X��g6"{gG&�u�{&�Y�S:��<��.�=��G��y�=�j�v��{w�"����)������V{�}v/:0=ě5/����l��=���9{m��qb�<�cz;}5�	������3kQʞ�x��q��v�x͇�}�g�<T�+�������6��+�3y�G��Au�1����u���L6����K鈃�h׬�	�s/(6}�W4��f!��������0���]T��.�ż��B_�4�G�Q�*�������P�m)v�A�P���� U\)�]�	&GU(� ���{�(f��K���vڷ ��>^J�ަ���%��|���ߊ,�3���kɝ�ŝ ��<��>��}�`GeX.�;A
O�������nh���0a�VҴT�D�ާH�(�gi�Y�Q�_������'
`�"@�r�u:�V�mx�"�@��ܶ�G1si߹�_��e�(�j��wMW������P�b	�ۧ��v��2]�ǥYB=�?G��v�.��@I�&�h��QnO��=ͲP㕂�*CF��Mɭn��B�����F��MW�K-�Ş�}�s�f�����ٳ0    E�b@O#��(J���Җ�=��2��4�BP�F�
!��#�+�y2m�.7#-�$h+F�9��
%� �MVB�F��ʺ��
�i=?�$_��� 糒��k(i�=����z�	�y�(�� �"����QX�kIK2��D�I�^%�����,�����Ǽ���PҒ²R�T t�!|	5-� �+E�{�)�b�^�-�6ڣX��ş#����Dd�[BX!��fQ��b�(��D�5�k"ą}��R�����V"-,��n���,���iy�}��D}|�y��@�I�!W�<Q�n�Qz0��$��3/��50@��I�Dѕ�p�v5�ݔ���}�Ш����^R�Ҵ��Nh�ߗV9�)b�6�S���Q1�{��J��%5v�CK�I��J}p����7Ju�`���	���%_�[
ٗv��@IK�O ����Մ+=U�v6�H��.M���`sQ;���igӞR?�M�h��7�x��;�y�E��=PH%���.@�ve��(?��\�/��{��M%���Ot��p@��D�+Ůi�1�[�EicӉұ�A���iO!?`]���w��x�����"ޔ�b�`Z�q�؆	,=y�k�C�,�����?Q��D\V��fs��Ɉ������Zo`���eK�"~φܐ���}�^�;d�p���z�c��;��b����[��[�I�#�u�S��|�z��Hl~�92�L�h���Z��B7�4�1��gڹ�� '�%$��6)���},�9P��Uude�2R0���7���GQ�+�}��1�!Ly(�@���\�J���蕆iQo8-u�S���H�ךe7�؏1(~owUH���o�2� )�R���݅7���:�IzjK�8��s�#ȱ��
�h�}�:ǹs�:.J�Fr������(�qGIF:'P�rl�(.���F��t���m��y�J��i�ؐqQԵt��n³�m}$u��k^��������P���:Pؼ��H?�<���'����Er�Z�J�ёgW���<��V����S<�%wO��p� ɗ��
��꓅�'��B��W�+	�#��䎵�J�^h7������nFl#-���iI��E[�ڴ�7���o7,���{MQ�*��wJ�D#�Kw5R8R(ݾk��<$���Q5	��>��ԡ�����|��j���U��qlIc>�g�ռ�h���#%_����{7��y>�#K
�j�T_[��<$����������վ�(׆���kwKQ���R(����J�ao��^cҡ��[��h\zntu6tW�O�i��hFϣ[��	��w���1��H����U](׬$�2��]������R�N�+n��c�DB�e���9��V�)����Q�/J��ׅC��N�������V��Z|/��=P�t6wbȞVJ�Du!�)�5��B�������kځ�Eㄮ1!�QuZ)W��Ln�A���Q�7�|5�U�f�<��,�GB3��n|H�(�7c��I]WȘ�f{X�@��i=ˁb���s5M�}��T��D!]�y_��R���\�^K�Щ�=QD\9PR�˥.,��[8φ�zi+d4��X�x�C�\�}���.i������s��D��/�C�9��Jq�z;���z/�M�.�R�/i�FW:N!�B����avQK�%�L[�jHr��f�.|��Kpѕ��k��Ҝ3��B`�z��'���Ƶ�t�t�Y����<K�+��Y9�9H��m��h�F�\̧�q���j��2����N`�I.����\q���P{��(���J+���P�2$g3�ex��L��[y���*��ʐy=��(v��S�0���nE3�<�mn���u݊44-�.�zV�C�*�y.�3����y+^�ꧢk���.n���_ ;���		#s�o80�y�Ƕ�!��4��x�����TO�&�)XN���Z�N��B%G�%wJC����NLMgm��~�)g�_M�|�֟�!F��N�靡��v�l�v������ �+rT���B4���ٍ:PXb�А�K,���PG�u稌�uٓl!��I�DJ~ (8���B]v���Z^�c�{T��t�+ĉa_��A���^�H��ۜQn�a(���K�y�մ��*8�z���D"z�v^�_�y>D����<#�~��1�<[�E�~�
��x�t��-k#P�'��@z�j��+��m�����f��v�\��E϶c�\>�ݲ@P�����< Q��n9�W�f �z�?ٓ��� ��a��˻�v��9 �ܻ����t$o�>����'��W������xv\����E�z���k����5��h��q���b��K"�dA��� �{���־������<���������5��2
��1{	ȼ�p��U?
�rh�����Ǯ��K�rh���\e�q �+�%�=ڶ�(������I�n8tm]�z�3��.�����v��4o����}�Y��	PG`/>4|��R��~;���-�V9�-�X=����yw"�η/ -rn1j����[��=u�E>�Q����I��F�S'�����wH�
�w�	���#�5q��L�K:��"�n���N���PV
�Ng��U���WN���(y��J���a�#���Pg�#cjڭx��n����Mv�.ۭ�RT�Ԡ���)L�`�� MV&���}��J�%ͺy�d�~+=������2O��I�@2'���=�]�t;t.�Nq&��`��j��4�"P���164E~�_�����uxȋ�Nh����ݔ���3�E�XE�����W���SO>�+o]|��]|乻������n_?�ׅ�7�>	��PM���G�-A���2�A~W�����[�����e�ۤ����'��%�.�����/�B��sM�B�P��N�=�'���������RƼX,�A�`�Zdϲ�poA�w�Z$��DmC�t��H�!��2&k�X�7)���ȧ#�OS��ʰڬK���bG%�X�RlWT�5�C��\&�^}��?�p�}/H�&�0_º�	ϵ�����q��:Q�VYB��@�/WWʨ%�#!|hHG"�(v��I.�>K_):��@�;t �G�Cz�X�@��+��{�P�Ѥ�N��+c�I!��X�7�3�Bi:$w��F'C�½0�G�J��򥋸R��7;41Tr!���B!3�[P�B���Rx�7��h��Cb��<4�����B�,�f�
B���=�2�����f��!K��3g���1��n)>uc;�r�Le�t/+s#�<�(u���obR\�>C1�.4o���������(�pd���a��k�M��@�R��ç�NG�qE��2���hT�� �Y$L�RƠO�ģ�!ݺ��w1�����,�z���z����6�EԷ@��Á�[��K�L�R�덹�XoL��E{	���ל=J_!<�WRi7�揲�t��.����CsY):��̩��C�,[
~�z���V��J�:�K��j�>˞���h��2���e[�˷�����W����,'�C��Nu��Sǝ��c�9��U�N�>BZG����sl���1l�Y��L�G��!�Ҝ8#/=ᗟH����G㣜�
[�]29a>�p��[������2��B�C���x<��*���/
�Km�Y$=�;�8�Ps�U]�_�D�ơb�r��=�o��L���Kn���>+�GhEk6��/��"~s1�����k�r��(W���p���8�,�(���2z�|���/��~�A�+ǷK��@Q3Q� x4�e_zGA�N����Z��ӿ(���.<��t�%��@�>�/��|�n)�SA0��~�dՅ��/ʘDA�����'���j�ڐ�6�^⭻�kWV+���t�G'X�,�}�!�%^:R��Za�.	���+���ƴo������4d6CѻJ��i9�|��	(�s&��k��(�����4`������ ��y�&�����%�	�Ř����l��%�h(`��0F�R�np��{N�h�s�U��P`�� �n3Λ6O��    1�)��ղR����.��:�z��u���fu!Rr�A�J�t���GJ^C��P�\	��F�Rrl)#'Xìc�g1�(Є���J�{��es����QEuS�F������[]��2�-�-Z����-��.W��^roW'��QJp#�����$S���A�Q��6UV
����p��\ouO1�P{���\o�UWJ���x�3P����]['P�h�NF� �N������ٳ�)P	Bg�硲0}/���B�P,�[*�ԕ�M��1T!������R�`?c�i:*װ�J#����騪˞W�^��{�9�[=Q��U�Qĕ�
���ƹ�*wZ!� �mi���w�l)�i�-�H�%˅WJ�r�j\�����J�ڋ"����˽D[�YЃ����HC��3���O̫��	�g�.������4�g�{'9ő65ﰿc����Y� �Pۿ|"��hk�qܽ'Q[~~Q���5�~���W>�W�h'�]=�Ȭ���>����K���Ov���	�|�WX�X�4�r�x���.�G�
ny��\@3N$��o?�E4�P��>JP��x���CA78*/��️t���;^}�x��]�u�|�������v�����r�[���pU���%��ez�]�y�	v<~��]U��E������(��Z-�}���%h�� ��>���6@.�>1}��
�}D����>�~'����O<��\�p��}B���Tpk�R�Ւ�3���vI{��%3x�ga�=^��`�����}D@�!�%�+X�c�n�C,����_����K��&�����a���sD�n��#WI�Z��!�f	^�~\�m��^.���Ǽ��.�;��vM�^��������
��.����Ȼ��^��4U�oP_=ޅ�,]����[�����ݿ>��z�p`�^���~��C�寧u�Z���շ~�������Ѻ�v��,;�us�_h�D`�F�����H�ukSUޭ�3Z)[��o�<����%�_.����R������<�^��� ���;��d�/��w{dd�h��z��� ������� �m]e��/�&�� P$b��t�+��/��2T!�x���N�*^��{��g��!��w��g��`�l������I����=<o�w��Gy���۩��0�W��e7Z����Z��@օ���磷;w��W���_��A{��'��K����x��~	>�3�2�t����"��[���'�wG����G~ẋ�oq���p��l} �/����Q�㽼�_<�*{3P_^�/�N�;��ޙ��^(�����\D�y��/,����3�S�;��4�/���[C�D/7E�z�Ү�d}��S��r˫/�0{�Xﲏ�z3�=�^����.v"����{����/���5�;������sc��;x�PFvsǓ�;x Ix����<�쥹�/�_����i}{����1��u��oM� v�v���&�*&`�IY;"����X�^�vڛxep��궮��:�+�p�*mo��]����ā�9�n_<�Lu�vx��.�xh�v���/w��"�z���]|���_���_�@�sf���'�˫��#m�aQ~e.��]m�>��^<1�����݋hv�����-���?����N��b�[T���B$���]���g	��2�s���LOU�w3�-�H��s%L��(@W���"	���DA�J.֐�՞ �*�kS(� �0R�2^���0�A{�9�q �OFI�BA��'~ű���+d�>�)����А91����������=@R�J	s6� �:�s�*I���(^���e8�mϵ���D���׀����v6H�����~����G��\G�����ꀤ���\>[QԸ��ժ
�_�[�GI5��L�j��:����
��P8mX�r&�u���VV�B�s�oH�: E�U�k'���k���Z3���]� �A;���TS�D����4�/��I�Nb�����Pj])2.��q��䍲?�ō%|�������]�}�$_���u!'���Z�΁�@t��Q���?Js4_�1��
��i��	Ҫp0����g�4�Bʽ�5����ȧ`%?'��
��)5�8�Q<����-���"%m3���B�Q%��E�~���C���VR�I�)i��T^)cW�s'twK>�T����)�2QR������KI�ף_a]���K8@Џ��Q�X~�&[e+�z�������{���J�����)�;�����9P�y�CG��3=kI��#e.\PA��/���!=V�K��QRٙ�1#Hni�
��ñ-%���%;�me�&��qҒ���k��Hnj[Y ��ьJT В;��k��@�`bty��$�>�OP�BZ���J���b��|-ȃ0[�W�eکH�Ep�����7䕡���RoF(��=c�a�<,��Jit����������>,ٶB��8o�퀶�A�{J��"��O1����f	LƵ�!:Һ!k�/�Q4aN-�K%�a*������m�h�w���daG"��Q��� �d�����6tR����f_=�C\�	o�X�â���򎞈��r�=ĵ���v��>mㅂ����-tj��Y�{�H��=�?��$ڳR�6��p����fW��ڒZ��[�[���S4<�Ú��#�ݤ�V͇�J���s�V���x�ܥm}��P}7${AY!2�.��J�l�.�C|�U"{��.h�<�#�װ=�L���֗�H���p�(ak�妣�p��j3ϻFJ~��Z�nY>.�NwH�N�tG����7a�B��A�:,v��\�V�J�U��"�0у~��
��Rȓ��R"a�`�g8P\c2�h.a+�+EGj���7��B�+���X�����$�q��ycp� ��l�������=k�|�a�o�Jy � �Y��~�|T�����G{�2�/��?�(Ɵ��I� ��h��x�"�e��z/όe��/��\�C�YRcXVJ���9(�)��ڶ���>C��>O:�|9R��G�,�"�vI]����>��=��.��$��p�	Ԫ�P}�C	��G�<�p���_p�.����!�(�!�el�3�1ҏ�
�;�!16�a�����.��:�{�H��7i��8�.L�� y�� !����ղ��8���oH��]N��W�R?���Hy��\2�m4�6�����<1�1�R��r�!�L�^���3�X�H��m��'y�\�۝,Q�|�(-���B��A�*�K�^��>��Ĕl(�Y�P�� �ʃ�˞�H�������	>W�$e�^���
�3�mk���?U��k]�4�iv����~�o���Ŧ��g4����w�W����\�V��.�~^�'�Ji�I�����z��\���AM|���4�O�5������}�-D��$��t|���%0ʠ|�G*ǱF�s����c������*wI��2 X< �����uH��2*@;R���\�vy��r����@=�����"�a��eCC5����?�N��mV��u<Ŧz��#P.J�j��b���1�8eP`"6��)~�<h��ؑ�q��f�K^����6֜'�Z�����K�N5fŬ�'�#��b��(�r��@����r�o:�N��s+�����z?J�p	�] ͫ/����[͖��X�}��4R$��JC��1jk��� �W��R4���p���*��W)�9�A�P�n{���у4~�%jO��rH)�\�VHWJ#�z�-.�b�ҵ�P��ג�>pY)�U<T��w�jO��,wyh��˥��^�-��<tq���xs�|��j�q��� y
���'����k�+�Ҟ��
�&��w*~��8B���{��Oл#%_��V�P��z���8�2u�Ey��a�xIn��\�Vᦼ2�>?kLa�"�'���rGz�Ue���f�n!�M$/�a\ ~ěi�<x%���	���a��    �cZ#ykGj�`R<�u��S��1����S%O�f�i�Ey��y���'�@�=�qr���W������:�S%O;$��q!y+������'�u��d�Z�n�!�h'�T�������y�5�!��+����(�m�=4��wA����Nz<����Ҽh��<~����ё�k��~�
�$��`����A���Gr>NRx>���x8̵��������RpīA8<蘗�H])�\�W��|�J[(>|��E����G��,�큢\C�OhWX!^��붅���Юv�0�7�ܔ<#w�x^|�)9��r%LU5��;�2��+���lnO8)wl��0�%�e����Wʥق^g(���ǳح���mߑ��Я���� �z����N� j%8��,�e;�-�����}��C`"�|B�OM�x2?����/�q��@�-�L��.�u8�n�B���G�x��bޱ��7%o�вR��VQ��SPOD��;����UsA>;ΘڽnRs�Oǻ=d~cn�2l�q���fwAF!��ސ7��/�
2�'ycl�B�B$�2s�i���wy��6��NnCB��s]ҹx{�����<�.�d�i�߉���������R�f���Q�ȯL�7����_��o��w�Y�S+�� �a��S�+�������8�պ��F/�dm���tf����G��/$��vM�.�^�� I'��!���T�K�YDY(�{_��k����
O��wL���t��O�1�Sz�ə'f�'��>��N�K����];ʮ���S>�{�-���gbq��#�kf����BǁD�-���qy�Ċ�3G���H�؍&������B�F)q�i����J�<�Il��}��EJ���L\�^v��-�&��L\�Ć��lc��8�y�"Q�(�oS[��{�%)q�مQ�]}!�R���8�l``ZK����܇�S�.���A�����[�7@J�	�/�8�����iv�
���k2��2�2Dm�NO���z[1:�Oja��&,�`|�?������F�î��k̯�aӊ�1�N������'�CC��v��e��[=��PS�<,a](�*��|S�`񲂛��᝴~�5�0ś}�Mi䵕��r�^�u�[L���\�0�6W�W���׻^�c;���%��\�0Zl� ���r��>�]�n9�~�3�����'f46�o�������D�)yz��B�|��a��2�獄���¨�!=�u� ��T�����#�g�c�N��xN��$��C� M�Z��.^��RVL	]������5C^����~�����PƁ�5n�<S��.�62uvK�O��;w�N'�
�E���s?10��Aj|1��{�,��7�`e�Tݑҋ��oJ���R��u�rw��_�"��B���ǟ(�v�	i�YK[(f7х�E&�R�(-�b��0m�7�3vW��c��M�L�B�e�K��29��j���!0т�W����u�7��������I��A����i�W���%?	�(��)�fy�n�H⾙��LL��!�]]%R�6:-�Q��`\�T�K\�y#�	#f��[A�J���PKr1�����݉��DI݇�2R��g�c��MyX�{�9�҃���+�e���J����='��W���w�i�Ӯ�>����<}�ǘ���G�Lzw��W�%}I�DL�8y ��:a��{�e� 0;9��Ɩ��C���S�x8q��k[0v8��^>�%b��	��bF��١V4b�U\q�\��a�Fbd�����?�+0��[�:�ϯ>�6��&W�s7��3�ܲɱ��y{�,5�#���{�UL�c��[�%�A����ҝ�:��yR�D!0C���� �������59P����I�)vXWʗ�s���'������PC��.B����� [�Y剽Eݘ�Fr\�_tEǱS�"�d)���F;�i��t�9͝຾QڕU������#�3�F�/��� ��\�R[Y0����d 4��8a�����������Ӵ7C�tZz�1��:h�O��?j�1�Kl��\B��� ϤFL�I��bdT��N�17�)���p�{��4i.�q���T�=��#a#��ـ�Q�ӫ�t[�!�b�O1jm��D�3r`�-8��]��Ǩ`�hor��կ	��-�t5�[���g�>dn�-X^}����"�DJ�/V��8��V�M���( ���(��>W˃^MD'Tg	͡Fy0�;��+s�$�����z��v�l�z�Q���׍	��(><���Rs|��J��^��u��ж�#��R����됬Lv�cV<��0�50��~��nwn/�ٗlG�K����=B)/��C;߬G�Jq�f�@�7�z?�*�d��X	�O�g�l��kV��� �<�"|�j<�|�c�7����i��g�ڱ���;�B�j�-�Ɗ!�*Ap�<�<E_��J�i^b<���ݴ�FK�.L� ���Kӻ��i�����"�6�h\�4����9!�0�(Οf���U������n��0�9_���`/ސ����7�������r��Y~P��S)^4ZC��5C_�݋R�(�D�������q8�GZ�L�V�蘐�}₁|�0v�@X�\S�B��(�ڴ� _�JG?�"&�����\��7��O���޵M?*O�E	��G�\C�aϊ%�=F�a����QF��Є˛�%d�٘��-<����bn���'}�:Q��0�x�����W#&�����3�v��cV����bp�b�Y0���N�2���U�� a)�������(�Y���|��G�)Zȓ7��qG�)�P���>N!}1�P�Y��(
s\�	��툋�#�cM1}�И\��Ytz���U��%n(JK�S��}��c����9`�b\¹l�b]1����j�^q�Hl1���G˗7�)���~u��%��]��^ ��<����ʤ^�Pb���ʽy��"\���i����ۆ���X�G�)��
3~Ϲ�(�u��(^��B��6�E}�5s�c4�5�E{
��5#��	]'
3G/8��[=���s��r��n�7�Km1��Y��aDX)��î���~ԥ+w���d6��r��`pD�VH��[�F�J�~T�߱:^��n�9��Ar�{� *�C4j��
���vʮp��T/�|�\�1FC5�ǼiO�Jm�bÓ��ӻ���)������O�>"����~&��<q���G�.��?���	��?芡QxRz����AsG������
��/3(�Փ]ڣ���wOQ[�%=�S�?>6\$,a<��Py�@�bNG�=O��(46�P�W{*�r���"1�����}��vA�&��w��LF��	����1��L��&�pv~�|S|>[(/�����.�_�j��7o�[�}�����oJ�|SJWj�ky����0�xL\�zP�]P�.^��,\�1_0{Lw�T����;�:;�k/AӴ��v�4��H��G�uA4_���^�	���#㞑=��?{�A�Vr����z�C�k�Q��=`���}zŹ��b�:�� �'��G��cп�s�f�����
D�?*Dw�(i����B����ӏJ{��p��*��hAg�0�q��G�zĤ=JJ�bthEث)ӻɽ�F�j�~��(�S�4�W�WT��k0�������k=Nfkt�%O#+��_�[�;���������'�~�8F�R��t�a�(C���ZN㊙�=�B�{xMu��W_�;��J�j{��(U����pD������#])�����Kr{H�m1�'��eo-v�L�k,�9��irq"`��4H�D�ˊ�Q������ɞ�Q�ez7y��a�����&7��f�@I����J�k �K^GLn�������A`����-8r�/�F�$)^�C��v\W��q�Zц�">`��-��hǴ`| ���N[
�#>=�c.�y6��'�N�k�C�P"�����S��mc~c�Ļ���~�����A�"E���o
!C����<���9����8ᰥt�퉢�c�\{��(�i�    f4w����x~-m�2����C����:�1�VYV9x��_�'[��h���c^TbvFy���!czS�q�'=LY�k�<���/O�~�w9%��ڵ	u
!p~�;P̥�{���b�9j��2̅r"��8Ė����J7��<G���U�<
�����v'_�S��.�~��)�|�K&�}��m�W��7��������mh	ޔW��E����_�O�+��B�0��<d��6�2���c�R��~����c:��}x.�M��ri�1S?������0�Ѓ�XR�Z���ch.��}�Jϕh~���N��>돛|�
���=VJ�qk�\��\�ݼ��[(��-G(p��QL�Gu����1Vʶ�ax�gs��%~����Ӵ�P�4� �T�����>a���iȺ�T	��'Ǖ�G������ O;�c9W�6��K{��«��kZ�q�H�����9Q�����h�/u��=$�7R��![�#���C���?gO�Y�-x=�r�p����Sq^���xN�=K_LϽ�ƛ�$^�s1N�B��5�e��*4��_1�1D��x���I�"�S� c[20�[z��l1f����<��ᛧ����5^V{��(�u�7J��Q����Ѳ�ǰj��Q�Fƨ�@��5�5���^#�b�64j5N���ߴ��Ԛф0y�r���2>MO�_5�x���(���!�EH$��!ex����M~�Y1#&ko�o�C����}Y~)�?
}腋�zB�-�(���(����
���꟔�QG� �5/��R�S]�%Ws9P�+
���Iy�YyM[�QX. y���?��h:G���(�o���r�*��}�t��������=��.7R{0�{
�>�qC.ȩ�����D�1�	}{���0��T�{�i抴8������Ԯc��yi�Ӈ�0h�\�o�x�}�-T(��c��?ǋ��[`F��;�f7�7G�7��j�w�W�(�EM�O��e���}@ZE��L�`Ow�I�+�4f�0��(�|�xK,\��=u]1W�Ǧ�����{������{�`��������s����m���K�<٭��#�JZf��!Ox�t�7x�*���9m�[�|ׇ<�c�Y�ETvR�ӏ��G��4�H�k>uv]۸���b�&���ӊ�tL�*�3ְ���rx�!�P8N�B�����-�F��q��n(��[��(,%���b��G�������\I$ J�G�uO�C�醼������Zʫ+�7�U�HЫ\��"v�����]�-e�uJ�ϒz:Q̋�������m̽(�x�ܔ���Z��v����?)�V�jH�'z��;P��L���1(.x�DXu�ʁ����ZPD����o�^�H!���<�Mӣ<��$C���@V]_1<�+S���^�F�LMn�<��=����W��kw�0�\�@��]_?���f�8���C��C>r�N����jҐo��!T��C�݁"d;������pl~ى_)��8P�p�w�(
%f0@b^��HC.U���ɓ�H��m�xwR�w,v���Z��C_�]ӏ�A׃�.���\��N�y�~o+F��A{������W������>�Q�cM�G�e�er	��i�������@�めх���Q�
zn���Q�ʔ4�y�뀁�|��n�N���O��f��~Q��L^��y��1�i*]�����듶xP�|�rl�ooOu�0����_�ߔ�
���O��-|�Xzh���p��Q��"!�3���[8Z���x���&xK�t%L�6J�z�����U�C�lKA{��k�E�"��q�Ɨ��-1E���ѧzC��=�.��b�Kܖx�������(��J����:9���8f�n�-��V���SN�Y����?�-xp^� "%O8�(���_�i�\���G �lJ��|H�0��#&�t���������0�\��/�MR�8�M�7�{�[��P Ư�ڻ���E�8��b>��D1G1�����L$��J��<�5�w%l��m�a�,�X.�-����`\�N�w�������1l�2=Mzs�e��%d��a0=Mj~Od֘����~b<8��F\b�aw�x��0!���'
��Ҽ)�P`/u�\���Y��b 5�{�y��.�-bR���>F?�7��[�С���j��!kv�0��ޔ\6�@q��?vZ��K[(0�K�iӋI=�����t���X0^˩>�LbC;�Z�'Lg���`j���n�"*M�4������F�#u���g�Noڞ,M>�n���Ic
s��^hŌv����1��턱WC���q¸BZ,���� ?Z<\
c���-����oJ7�<�b��,�-\l�ě�D?dCL�Y/�c�>><��{��y��a�����av'��a� �������ݣΪ�n9�b?���9~�W~�_J�#!8����(܆��MI��{Y)>�خ��$��b�e����O�0�d׋.��&���ޜ0n��.�6��`>ɮ��b.���Z�1¼����0��4���2~�'�(f���yqtS�r	�po����[J'	S@�S���ĕ1^�N\Y����|�aؓ���)�/�x��� �(dˎⳤ��'
��5ܔ�Ջ�kB]մ�P��y�ݞb[���5YҺ�#��L|��8�I��J��y���!ХJ|-�����т˃�͔��~|LF����S\?<��`�|[�ԠP5��c�y��D��F^����$�@��%c��r�����	5���,�6Z[�N�/���z�+��+�y��kw��.9Qp 5��?12F���q���-E>��<�<��k[(04��tJ�c�y;a�K�GuOK{�Sǉd�|����q�iL8}���6?
F�β���y�ډ��C4������}�:��!��`{�D̻�(y��·ɘ�L����$ʛ����3�%6P>��WZ1c�j�1�@y�������Dy��	��g��?�͐�W��D���۞boخ\5Rr��D�-�Trߡ�B�ѫk��� %���8x[��Su��gJKO���1i�n��b��/ݙ�q8�i��	�̓T�T�g�Q/�a�06X�Y���;PL���P㮬y��@a�SAմ�׾`�/��ڣ�4�p�0��i��cW��;�f���C��N|�~Tںvo�p;�|��	�b�\���й�&��!q� L��(:��Tog�m¤5������Dw����GJO�&��J�~Sn�,�:��n�d�=�ج�'9D��Z��8`��:az�n�5�3��S.v��C��c쀧\��AWk�&rC�h��P�.2�yۉ��iGAZK���2�!�x�,)�ŝ(�[�	���.1QThW�����mOQ��A:�r��Żw
zĴ��Q/����)��(b����-מ������Oy��	�����9�҇xEE!�@I;�OTh�F������=��Eƃ��3�������Nh��#;W�<a�N�x� V�4�`��+��Dӑ���=`�s��Wz���F���B@�-�D�wO!{��b�����]r8R.q�R��zo���a����_
tiaf��%nOA-%dI}�iR-؛.WB����iT'��NU���}kg���_L<e)/�h}��QKQ@i��������,1P�-R���b��X���8���c�uO����	��NO��Ѡ�	m�P�w�S�0��4��ƴ��+>`����N=�cN��������`@�(Uk��&7�L�:��n�.�R�d4I~���R�hVd�ɩ��.O�6���K���s2e��H�8`<�<�$�g ,l�*2�"!����L��ɓqٻ�c��˓(;�a=/}�W�Oo�a�)@�Ķ҇5�ǘ�-.b���/ݎÆH�K�/��n�Vc�7��f���$����f��X(N�u-����0ջx��OY�� ��:�Ľ���N�SRnG��`t�4O(�(:��Myp&f�����ݏ�KI�(�K�o�C(����QA��u����oJ7��]���[��
    ������:��j���;Pļ�0ݒ���\�앝��{��,�nr�tM�Hyu���v�ո�^��.�O�&]I��H�Ny���`�87��q��rbQ����� |S����b��;d���O����� 4�F���~�9�K���)K�����W��?d��.T4R�Dܖ�>��j�F�مu��V����Źv�	cN����I��O����(b�;�S?>�%�|�����y����Z�>��o��1�� ���r�u|m.|��P\�wP �u:2yh��;&V�=yP�E��Pj��x��?���OT\�<zK�(*��s}����K8_�F��<7�=�=��x-��n���T\�� ���1��a����u��ܔ�;�Bh�+��b�D���˻)�U�S�e�c�5�/������?�j�yo���q���x�O|�Z�o�p%�a�S��h���cw���6��y�%{�XL#�#؏������n�1�Y�O���rY|a�����(��7��i��j���P����၁1���H�Y2�%�TO�EL��>aT9�Q�K��]'#:��	!,z"�Rc
����s�aT��^��b�0��~xz��U�à��9rM��ah�tO�>�8���wr}Fe�cs�OR��ܪ!��Mv[��v�����jyGqa��/�)>䅂��K�i��fx�V�C��"u�TO�c�Ѽ���̈���3���~Lo����a�T��-�~�07��b7��2��!F੎�t	A0~H�m)����,~3<�8(��9h�g��V��{��(Ŝ��;	dތ�����*�b^
�HIU&�3���`_�kRJ�tD�H(�����7$��<�|�p���U���EY(�~y�(�¹.�	c��I�`x�u�a�g��!�w��x~�U�Cs�Cv�b���,�o_0C PY&�����b��N���TV
�>�K���jr����0y�����O�ҏx�~8��z[��" ��E��=�@�阡$�s}���
y��;�%_��]t0F	5_�'�y��zh��Aq��0�c;?��m)�����<!r��Y��(O�P](�mR�z66]q�o���OiB�X��� ��=��~��(�����������%V뱽��{���U�F1���LjŇ����Z�V?��m1�Sժ8a1 �y��>�0K�(�'FJ*P������xHݔ|�(ve����-�Q��n
��C6�@!�)��A�=����������c'�ě�亖'L�[ZfW|J�V��Cߵ�,�|w�ũ�J��w8�#��'塽n�q��>��C�c+��ƈɋ)~|)P/�1��C*Y��-O���L%�I��Y��^p�����.Y=⅂ck�#���;`܃�I�';k��(�g��CR�'��N�	������ h��/��p_���&(�����^���i��6��~����	�ӻD^8gE�BUD���@�${��\]�֓髱���P�<$����i��ͧʷr"c��{�Cc�ӽ�iz�<�K}�x���3إO��� �j-�������Pa4ϵ�a��y�U�(\4X/���II���~�y!�"mu
Ao��%-7�\
�`C���_o>�-1�(]u����߻^�6���M�\��u2�,���B9ŏ�PƯ��z;PƠ�� �Zp](>�܋����@{8`TTc�<(\r[0vk���ji�ED.(�qZz+VL�J�)�'�����շ�yc\0^�cfl�� ��-Ɩ�i��<�ޘV�9a��J4����#��������We���.��w/<����c3�_dK����_�B�>�;Hu�2W�/ׯ���������Ns��?��;Q���p�y[�lv��:W�k���\�)|g?���s ��S�<�؍柹(/۽)�p��y�y���w�A�V>9����[����(�;c|���āB2�Z����?���Q�nJ�:(��O�gɗ.�JQ���Ւ�����1���d- ��~Y���0�t/�G0�4�b
���'�|��iҁ�.ƶ`t�s뱩�s��O�C:2F�Kz�,>YqXMW��@l�b+���~#L_�b;I�M]p_)}��kx/�`��܆I�U$_�RL�q����W>Y��c`\$��I]00�_���+y�<`솄Sd�A��Q����ɽiGO�����A�r��+�CɚG V���t�������b������ޯ���1���h�8&"���*�T��D�����"��f���{�`רa��z�FG[�đ*���B|�_��	獼o�\q�E@��Ow��;z�g���H�z���g��b�^�G�c����@pэ��U��m	M>[�D1#á��Cr�?��R�C�)[霍|<Qxh
ݐ����P�xq�ʓ|�܉��=פ:PJ�0В˳�|+0��Ph�ԇv������m��.�R���=O�OK�q���=�/�������	���&����[�ڄɫַ��)�5���m����)���^����Q�vpB��4/��x1��i�K'���V���"&_���%���RiY1�m�	��>�[n1޵(�&̫E\}l^�M�4��Wk��b�C�(���E�OW*(oV�7���\�����Nq���yf���W����s=㳴<�0{�1$>M�p�&�=,�=�����&��K�_ʨ|���q���/ٚ�q	��r[��|�4���í���������r��}���%�yc��22f�q�
 }Ȼm)���"}Sr��D��Hh�Vx���P�HUWE�Z}Ⱥm)ޅ\cV�+�^�:?d�4���k�ϒG}�F���B�=PA��ެ�o���`|o����cv=��`@���ܐO��
2���;h�R۱�[�U"k��CA�m�j_��퓚���'�7PJy%Q��#��-߼@]�P��k���6�ӏ]�{hU;����p�带�'�~�x̱���b��$5o��:�
�|�u;
|<ڮ�8{a�).PZ����_|�Aq/���H�����t���%�i8���3�cZ�L�}��0`k;��ꃆ�����d�U=Q�J2}���N�f�f>0uH��ZgL��b��1��Ay�GE~a�kY�L��u[�W��֦W���iŐ�E�t�n����wOl5��G�Y�W˪�<��P�����6�H�K-�p�҇��U���>��b\G�uz���U�Yd�4�X?���)ȱU٩N/�S����a����D#&�i_10� 
MW釜߁>�cz������cv�*p=*W�C���[�T��>o�e�OP���>��m)�%���|�}�0m��4��q�~S�����I�)��ӧ�S�`z/Tb�C��ԩ|�v^=�˃�v2��X���E��J~u<P̥�A�@5�zt\(p5�h�=���q�t��Oc�b|4�6������ٝ ���C��@��[�'ׇ�;�A�f�Z<)�3�1S��jZ�v�4;�[|�<d���%��[gc���/�"�!w�I`�:~��8\O�����oJ�/���@���^|�����z�}B=�s���Nz���q3�'g�C���l7ʄ�7G�>�q�^u�u^nq�@iq*�Wн�8����jH2�|�u@�������Y2(cl����!߷��y�Jp>P؍d�<��y��Px4C'qlQh�;`�i����ܘ�,�#�<��i���*im����v�'�ʄ�˅�Yl�?d��l~Go4�oc�d���R�z4����C���`�qd�O�I��v�Q�]So�?��RV�Wݛ	�i^�9?�3�����)�z{w�[�1���ﻧ c(�C���K�Q���vu���⺫5��|���"-�*����7�7E�c�RO��U���@O'�Rb����vG�x.4R�ױ�2��Z���9��)��D�u�:�.�_��O�-7����|ki�$f%����B$�K8�h�T�$�lt�������]�3��Uf�    ����ʽ)�`�y�xs��]�����-���ƍ��Gb��S �YJ�ѲB6)�� 8a����J�Ӛ���0�p�Si���R�xN����6�iG�Qh�Јq�X�ӎ�#�N�I�rh�f�`]5(~�
S+]O;򎘶��tu�s7�ad�Pã�!����#�lv��,_S�1�t�تi�s�y��Q2v�!5�1��t�x�wh�w��?�/ŌK��/���z+�LW��T��v���C������ތA���=��)ʌ��a(3/���͔/�ym��������ԏ�2���Q��Ђ���`y���4QwĘ�����)�g�SI&C����8o�������`�N�\�o���q�d�l?NJG���P��}w/Δo
�����
bn(fv�/;"%� ���ꑒ��D-+�yT�O�*=m�;`�ǵqc2��my����륍wAږwĠ����̈́���+��*%?m�4p����GL��OO�E�7W(���T�@�W��a����k/���@ɯy��Z �X��yO3tG��Gٻ�ʲ�`z�E� �)Qw
F�p������o�ʵvRJ�Z\���g'R����)E�m�5g��Ўp����4�|�@���i���P���%~�#Q�i.��wb!!�bw^ؗ�b
4�Ǎ�a7�bj��
.��/o?jЏ��D�ҭ����\J���t��z�?�hǘ��Û��6�s`��b:�:��t�E1���L1x�0�zY���u(�ԓ�E��PX��nW7234+W�;4 6c���%��@9:��)j��Ne9�FlA�c
jYZ��6&6!�����m�ΌHh���Af��*���u.�C-�R��!�"�b~��� ��ߠP�Q��'�1�ۙ3j=��1}���-=I#l�s0�gZ����7�`��E��n+%�ژf�0�\*A\���Ũ[B�<Ml��a�T�<�X&��ߘ<ŅԿ���D�F]LM3@d0�.�Z��uOPu��JJ�&v(h��hT��O;}�Β�漯aNN��\��>YR�2.E`�
�1�~9�R �H��A�Lin���ŀ8S:F�Կۜ� R�}C9�t�����^@��,rq�ΐ���'N_������"�ʰK{9{�N!���3�t9yO��I+������&e���y�U	1c
��/����4)E�g��))钟s(<R�fqѓ��g/���"5���U��D��{Bcy-�@�5���h�noəZI�y]@��(��<з�hj�M�lC�}<����M��'�J�1<]z)�L�8b��쏪Q=PNvX���lPGF��f1t+~�3f�^L��+l1PڙU�ŏ�b.6�3�[��A�Oj;<���1z'Y�T���#�NI�um.���A�P-J+�Z�q��Q׃Ӳo.�Xv̀{�n���\v��e,ۏ.�xl�hc�������!|�3����(�wqM;fVJbY�&��G��sI��D�\Lf������g:���[&R��8F6�n�ҭA�v M}�e���/J��k��O8�ΥTT����`�C!�sH���Oغ	&�%'cq\�uGJA�U��%��l�������J�őb�"����I�ѳ��1����ۭ�Թ(h-�G��M���l�.ol-� jr'��][�u]�)���<D��6Թ�+Y�]��d�v�f��
�R����\
C�Y߰�./���O#&9ul퐰����QN6I\R�O��~�7m7�p#{���t.��d���{��T�u��`��ğ�3�o�Q`���R%��t.�u��`�q�O��gk���vI�9B#��45~��S��6kY沇O��[���K�m�|sN�:����v��2l�s)$��z��7{|B���'���gF%�˶��>�1>)�S�[?�K�Ρ�$lO�P>��/H�A�L����.�:��/��=$QO���Y�ǯ��u}(��{� );�%Rt)������~�������K��~�:����n���������mDU��9rK��,��t(C��Y��������m�0+�J�(�r�)4��D��If�­w��I��}�LJ�u�]������I�M2$�\rtE0[ͮK45ԧ�������ZA��j/����5��ڬ�'C�%3*��,&Nqо4�<�j��L7|O�j�-&6~���b�-�Iɖ6�9�6[ߍIɗ�3�u_ꥳ���%EwĨ)�9-����Bo�+�W���=�|��)]�����8G�PPhrt9���j�,A_�
�j)q�̡��l�PJ�q�ys�0�s�̱-�Q�%lv��۷����?y��S:Ը�`.��N�� Rʍ-�r��)=q�.��O���a����2_5��m�>��.F0��bJ\��*b�ܬ��ٽ�|�)so1[�D2>E��!���%�(���E��F	׹�N(��x�R�1<3 h�\�R\��`�(#/�8�{�T̴�u3�]a�s��bB���{M���s1B��!+�bB�?
�V�I	���0��ɋzSF��"�2�E�Z|�g��E/���7岃e�43�&kZ���\L/������V�=��^ٌ��/�rG��4�iΫptݗ�5)�^��'�/}rG
�J�f�P.�wl�!g��Fs8���8����9�=��+��]�M�O���gȨ�E����!-0��SZ^�e�!�Gj撤��[�)�{0}�#$�s)�Qc�r�9q�(\��"*ɾ�K��C�Ȋ��f�./!���6�fQ�%��`��^�	sI�}cf�h=5s�^oG
M=A�0��C�*���2�)c.;eJ$��X�S{i�;R`�l��(Y��n�U�t�'�Ll�:��m7�K�ӎ�r�5�vm.mrF��&��oq��sX2т��7���c0���a洢�0S���O�A��b.���<�(���t��gJES��/mr[�9@���L%�G!�7�D�\N�Q헂b�a,�9���s)��~��{�i�j��W������u.E]�L�����ĲS��t^��px��A絞3������cào
�y�z@\���hS6�`.�����ի�u��>� ę��U%c�H|�}㡚�cP˰I�*Y��ʣ؆�,�n����C���)#�v(m��䔸z��7�Yw��"���!n�k�H�ݥp�����|���-<�g��>Jl ;�6Ug��t����>K�d�S+Sk�W5��~���1��#�{-&����c���ZYڔ�G��m�\��"�� N;���xB+�Y���{�tu��}Op���ͣ�6>��[d��)C}k��� n�Q��,>5�������蕡�t���S$������-.��9.&�q0�;��ŻQ�����V�����Bvd))�@|apM&H|�B��GH�-�U_J�e�B��P����PD�g&{)3��`qߔ�E�,���EB��Dw�]��p��������p�!�����+������1dwK~�sߔ�4���m;E�
��C��q���L�`M�r�������2%km�K��C�1�q�ʥI�DA'�;C�t�9�>��}W�&E���
� �t�9����4�[�p�?��Jv].q���@�ΌM�YY�\�3��j��K�h�*n���ȷ+�ⴝ!�J��T�C��9�I��f��K��Csr�1K8��+�4)�Q}�fa.-oe i�n8��+�4)��[nl����v��	�R���;�9/BQ��\v����6ٓR�C��2�Q�Ԯc[XU.�nG��}b�I����=`j5��!�.��L՚촱S��!e^
�ʥ���4I�L������:^���3�N7��Ɣ��.t���_Tg�F���_�	r.��B��}is���e�F�����\6�2z#�<���D���#��R2�^����em�K��nʺK8>Υ��d� .~���>�B�k%��éN�U� k�q�
�P��|^
G�n]J�3���[���R�=���Ҙ��os0����	{Xz�1j����1��V��t�6��h����c��Z�&�25Z�4�{��.�Ciu6�|(��OzS�T���\    D)�ZAO=��� ���W�R��a��w)e��Y�ju��!�i��M~�h�Z)�=ij��e�Ė���l�,fֆ���T���P=�E�䌂9;�Ӝ1̼=M| ;��;-�E��ӎ�9�/�M:��?I�)?mˀ�R.�6�D0[�`.gp�0e��V^��K�����ey�8����(�R9-��&>a�b����q�aj�E�D�,e0�M|�pn����ݷ>vͱ 4��2(�����M,��M{��c���ǰ�x;=%���"�`��#�Gt�-y�"�.>b��-YҲı����L~+�k:� �R�3y�pÕ);��k�r���uI�9�*���g\����1�"�n���{��t�da�%����L�ijb��l��gC`2~鈣��-%������>�p���i�,c�\v0��ӷ[�嬹��rǶ�����v���a�K�u3N)�c�Lѿ�����=H�(z�1RfR�&�b.;���˛l�XMqẃcΧ4���M���S�ݣt3��K��ï,5�F����Ȏ��@�a�A�:~�3��"�e��)�������k����\K[0q��H;f���{�q�HT:V{�J���(Z��}o�֪�7��L\�`z�ڗ���p�옂zd�u]�x)��*-a��c�QwL�Z6>)���2�ϖ�t�Fr�&#	g_S���A;F�XaȪ�����`��淘��3�ζ�^�������̯7��z�s(4�ٻ��������ؒ����4fڏ?���I}C�=4eK���R^	b�b(�	����d�s�Y�K�Ca]u���5VX=�7��!^Ĥ\���w��E����\���2����/�zٹgH#=d�+����~��)�U1����K�CizT�,���3�
g�C�n�3����P�^mþ�XtG�/�Na&uh�ֽ4�9)d����M���ڼe�_C��9~f�j��d?�H��@#�7t�zs ]P�j(�w=��EU��������7��	:���=J�Fˇ��6K�̞c���=s/Z��5���]�p�C0u#f���z��9��vY
����;��RZ~P�qo��c�&��R/=oE!��cS��rl.l�nE}7~�R����q�Bܺɫ��X���D1�\i���#}��M�zmqŤ	[d�뜮�{��ѿ4�1�e�u	�\ÙI�o�����ƻ4�9}Y��0�\t�@J��1uy�L9s0�e[�E����ƔY��^0�-|�HM<��	�ֳ����)�1t=˲6�&>cf�j���y�l�n�`5_�[�S�<��!��l�q��޲���#$��-�����7�d�q�[6��бhe�7=L%�1�Cն���=L�d!(�L���8-���S1��Ӽ��9��V���^�(vmz�5G�ãe�5�/_�C�LAR�vkAK8�ۣ�'X��#a�GQ��%�8xֽk�|�~{n6�OA�SY�_}�~�M'�<��[���5N�e3�����l}��}���웇i2��WhN�����MB>F�h�]�o� �f^���m5E�����Gpɽ9hE�zI��(��1��P.ę2�mO���V��MA�+ÿ6���p�t����-�����~�/�V�]��ͣ�T��½�R�S�L��-8�wDu�l!��Xp����/�0f����P\�u�X�b�Iè���
�ߵ��� ���0��a:\����46OB�N�Lq��è�l-NJ����N�j{"��I6���1��P[�Bq�-��S�9�p��x*�ݎ�[�ֶ��0
��j�����^[(N�y������r�;�N�}QiY�x;����a�b��޴~���HP�w�($l���C�ݸz+���]�z�?J	'z�8A�~�n���IɆ�Qz����Q`�j�y�$�9�J�m�R��0G!��YB£�u��I�L�.����Pbx;�
LN��j�\(n�(#q&����Ù��dO�$4���g[H�@�	J�mӠE��7�R!c�n<�*�+�t��$D��iWc���PK��*P��7�a����j��8`J�OZ7GL5S=JUW�tsP��=
���L
�P�z��LӶ��"��/�ۙ�>R�0����_TQ�����oOV���()��;#
[0<J6��D� !�!2��ss�
�,KUE߲�a)I�Q���'�����R�~FɮKXo��\C�m����f8SD7���b�ɜy�xל�Y	B��&=�db[ OV;��6���JK�Ќ�&Ϙ��M�������G]��V�r=�c�Be�XMf��S�����0���jjVt�s{!�ۖ%��g�R���N�24�-f<��1��%\S�@�7��Yo�z�	8W�ã�a"M�B�u�2�I��p�_ޱSh���ef��7�R���
��F}���C{$��\L¥�����<
����Z����m�R�j��b;�)�]�57{x(i��Ō��=^�nG
o[{L=�[��S��}�,��8��`��޼��K�a�M��/�3��%�p����rq��ɣI�q�,���(��(4�S�<%�f��os(�0�Y���K�)��h4�6OKq��S�c��2q�.i�-2Tg�vk�ֻ���<
�Ŭ_,����O������彘'Ȍ߉QE"�-������5��[__R���=�Hڒ&�B"/��@��ZC?Y7/L�P0 ���Xm2�1��Td�i7SF�劌�n��������حq���t�����+m�$��/O�a�QK���C�;�������G����i�&��8v���ʌ�qZ�~	�'_ԛ�Qe��8�q_���Yg�þd$�|�t9~�}�b��k;r����{�@
q�E�l^�)m�6dYJ'9]6�#2�- ��K�,h�w-l%���el�o#D�n��؀8b�SB��-&� L�m�؄�iǀ���h+���<J�����9�[8*ܖ���4���:�I�3�n��)���L�~(��L����A�|���v��w���CJ��M=?���������:����oF�b�wX]� H�P��&���ˎ)�ч��4;&֜�(��0�!.qָ��Ҧb;��س3nu�0�g�M�bt!��]L�13�H3�-&�;��Zn���\�Se�ҳu�9�w�0U�H�%�朱C�}�����ogf6TgL�/Ï�9�3Ȯp���Ҡ0�_��c��8��(���"j����vm(5��ts̶�I��`�.�-�����o��;��_�/!֟<c��﹭o;.@ۮ�6�d�GU&�Ǘ��CS3��o����*3��%NblM�������qߛGA-����G�l9��ܭ������2U�>�P�ϣu��]�8w|�4��Gʖҟ�)�h��_Y}~��������Ȁ��@�ڌ<d~b?���A�%���c�a�O��?4��g^�%��PJ+�ǨF���OWR��F���\��3ep6�ٙ���f��)���~�'��b:�)R�nK�xp�LQC�Ӱ��|p��)��/�\����7
Wd}!�b��us ��}�vٹ�k,�A�ړ�����uϘ�z]k̷��;v����ӂ§9a�!�b �=�ӦL��L���УE��MQ���n.K��x)�������xK��S�w�R��G7����z:`��,�M��W��"|�3�R^f�2�?=�����zl^oE�o�a_�nT7H��Pb�b�_6�	S0���eaz�8�L�z�v7�Sg�no�w�Nz� yY��^�I��p�E&�1��c=e �c0�|���$/_�Ć��)��-}�:��p�6J� �T���%�`jc\������@��S����ss0���.���d�T�s����u��'�����7.����;4�?ͱa�R8��t���u���0��'�K����f��`�k#�.�͈b�7.-oj�G1�S~���f�G�ӡi����cC�ˆ��^���bC��`���#�ʠ�l��M|��+���[L���n�Z�G=-Oo�#f`���ttK�Q�`��hE-]�h�cf5&:mLN�d    �J�fӜ-ť�a������lD�t���)P+5]�-]�;EO�_=)e�%q�t�}��v�~���!|���L�C��pGJ}UL�6����i�МH�Ұ5�-��#F�vݪܷ瑙w���)c]����{�0�[�/?*0ٌ#`�����B�QBЁ4(��� {��m�N˱�C�c}�9�M_R�m��L������o�8<�ȟ�.q�3�d�F��<:���Z���F�Mi�L���aZϜ�����cx��T��Z��K�>L[n8t�e����H���H{u(C��aFX��c��9�4�ye{(����������oʁ�H2{8�<S�+�e�������ƀN#2y�+Oz����QX�z�r����s<��r	G�)c$�h5�9R�z��VJ�x���-��3�An\[�% 
����'�R����}�o��`m�x����A��P�0���=R �,��y�ki�P�V+fqYK< �a���)8W	��Q��A��bb��~`��fzq��;pF_R�~`����0w�q��|��3㠳�~�.y�VvJ�=D����vI�14;�֧��o:cP�`�W�c��0S�B�4,6�������$���`w��AF&[�)���_��]d��P�ٮe;����Wt�d��5S��Z\C�9;�I��V���};R�"[�����o
��H�ɹ�X�L鰩l�M�G�!��Rh*��ԗ#&���0,p�-�ş��D��i���`$�bK�1���W�>SŽߖ�t1�RSӔY��}�oӰӜ[������ɴ�c�ף��M��d��|�U�)��55/���{�m�Imu�ʣ��Kv�-$)l�_��`RKy�s�t�$�4ѐ�C� ���?VHJ[��N���j#����������������_����?���|j
���g�.Cȧ������w���A�Bu���3耍�>���_?��L���$�L}E-?���!T�B�y��8���q��F�i��=c��e����U۔���������U��nV(�>��g�oߣ�= �\���Z�2��6(/���)�d��- ���n�6b��)�_{QM�N�l�.<#�/V���v�$����t�1��)��}��� �7~h~U*öd�K��i	���h3.���9F�RZ���.<#����v��3���gz�
��//<6bL+e��b�0]0��bb������s��2���/x�#F�_��L���T�ͪ��K�Lt��0�#�e^f�$��H�"��/Y@3���?����~I:��IқaNo��^sZ� ��t0�4���/����y�����6��K&�HA�.�-\�9�u�1S���6��/�@�%^�沉ێ���=�4���l�3F��%*��e�K<�E%�����LuF�J�t(T�L���*�}Q����M�@/qQ牢ϒ���2z��I��%7"��bJ�o
 ��Q���D���^�.���\B�����,�')�)H�"�y��j���s=�<�{�)�Qu��|LӅ�M���f�1�N!�L����E��n��*�D�"H�J\ҹ�W���~ þ�KСH��5�׸n3���3꣡�gv�EӡP�₡ĝL����\v�j�L�߄��Eľ���=S0˔���{w�A&Cd���r�N̐�lf���
�f�L�^=aR�df�u��gJ����Kp����!��N�R.�Ù��l�%��p(��l�';���0)S�Ɉ�x��GAᄑ���fPM
3d1��e�$ ��k)�b�~���)U��fw][��/B���:��F�$ ��1+�P�a-�K��@�z�=�B�%혹_�"�~��s0\�~����2K]�&>~%o�<=5���4���`�~ٶC�s,%(e�`�r����� v(��n3�Ń8���j��h�d\�Gbr[^�%(�a��Q��i�L��IO�EI�e�؂p0����e�1� v�\�0�1m�_1���	P�|�4�BjM����Ӓ����Ld��o�c���n����#E?n��f�&����~�,lo�+i;j��R�*z�Қ��=vބwȘ-;(ӵ��%xĠe4����m�@4%��т���'����ȕ�����S�4z�/��KOޑ2^p/��\N�݌��_�f��E���W��@.'�jF0�p�.����aly�X�x����K���}�ғ�`�g_��<2#K��+��d����%ϡT5˭w{E'_?	�4����闆<�ҸT{�\����M���P��4[�E��z��n<��7
��~i��L{B٣n_�l��K+��Q�kƿ�O��n!�e��߰��з��`zX�=ʎ�ѯ�m��.�xf�enq��p�t�f	�?��8}��)�2Ͷ��L���$]N�3�Dظ�r��<Q�
�6�}���{�� ���~@��]7)&�/����y�~H��Q��6)%�����_�{s(�TS�$���v�O&f�[5��xs(z��0�{ɻ��Q���[C5w�\of0e�#!9�bp�dHa�j%B�2nЎ����F�-��:c^�X�����o-S�Wʒ.���9#��b���M���1������{�`dP��8�6�=Lu6�
�4���#��*E��K�´�h������`��a:�܋!A)���P0�Ą��|�q�_�Jj%�=sɾ9�B%V�c���&���J�K���4�eԥ ��?MIi��Y$�V]_�&<��y��Ú!2�O�wO�/=��}�x��S;ݎ}��(�q��0N=�S��摢6QJ5��>����v�mCy��R��Ɔ�(a~}�c�I'2+�d�
�?4�Ħ�¡�����\�Qh�B���@���{��hd�&P����������Yt��m�v�����0��P.{�L��Ŵ�%<~��VgmT����a���èk�lM�PXDY�X�7�g8=�p�p�zVp}��.v��л�$�^��b�g��:���MF\��6&@�����|딖�����aLH]05*;�0�U_���VŎ�=i�EFP�f�$�G�a:��!phD;��Mi���b�M��;cВ��� 清O#;�Ϣ�sʲm.����Oj�K�v1"Ǝ(�!{s1"ΘN��F���)𞨾�^�6�7�y�6L���p�③׿�|6�c��)���/
���4/?�`�ޱ~{<�Σ�R����$���,����1h�tE��-�8��s�+�[�R.��D��J�kJ8�ãT�%�5U1}��6)4e���춨YbY�3�釔��E�VA���\V����G��u�,a�8	w�t5�[�Z�f��G^灖�M4�J�i��$��=��%�!��@T3v�pl��Xӣ4���J(�r��,�ޙ�S�-�P��� Y���m;)c�̸(�0��Q��"�HX�V�~�A�)�Ͳ��q?���n�P:�����Sq��d��e��)�.���v8�a/�wL�ei�:���ntkYLG�0L��t dm��v̜�����8���<LI�i�S�<�n����g".��3GV#�_[:N�y�Q�$�����3f`����.�Ȏ��I����cq.�Q���i�s1���U�1G���w�y�+���9`����$W�7�M-zFɕz���E�cE��lT�}��]FQ\S��\#�Kw�d�x�-�C�l�3%c��Y�x*]�c�T��늱My#N�y*v��1KI;����#�F��azJ�<=�������˶�e�=p"��%�Al���Y1�%�	T��Σ}�r�OL�������?�z'KqΣ�%d��p�g��` �����^iN��P��P��jO�X	ӣ�ʶo3r����R����!�R�#�GwƌWQ#��5�<��iʎS���Y7,&>z��+����fxR��cq�ذ���y5��-S5��U
혷U��f���r��=`ޓ%�����G��S=*G�BI*�g�h_�>������=R
dO��ȳ��_�!'�J�.�5YWw    ���,���L�2���ѕ���n�B*���<�3��J�]�sپ�W '��P_r]���=a IH�va��|� P�ɦKG��Q�%T�r)B�4�C�	���b�+���q��9�ν��qI�9����P.�7m��	ɔ�P.��L6⿃�ݻ��;<1����y�ƍL[Ɉ�ҕ����Z۰8�t��:�kp�'U��0��/XVV�b�s�<��ח�����q}�S��[mf@�'�y��ޚu�[X�Q��>J���2�
)aډ��qɾ9������Of,5mBB�%���qɾ�(�jLk+B3z��cxN���xy��|8b�&��^Bܣ���0���8��C�C���(=,.�l�2͝11���K��L�2�/��u<��[c��(�m=��F����iB�����qU�
_��"�u{��mp����bT�Y.�La���Jl>���R+�9��1�.8�� /��ıߺZ�}f0 ��K9ƈ����)����I#�+�m�wGS�t���.8�z��em�Z��7z�:�;�-q�#�"s[~T�E��c��z��Ç4��&>c��e�א�m�":�8Ŀ$%�{6$���((ɰ`d���g�g���}-�/�l��>RH����%w�0�S�ix����ږ%Uk�_�o��J��Zh��bbK�O�~��`�J�5���|s(���yHR��Vw|�����pq'���Jl�:b)�U)�a씩��jϏϡ����{�H��X����_RI��ΕmOMq#��a5�M�26al��.������u�)n�;c�eޯ
�|c�ݙzT�h�2b��a��|�K�N��_*�=F���|~�%��`z���?M�1y�)���⊉w�C��d_v���/�SR�F1��%��PZ���Jl;�j,��F3qf�5]�oG��(i�j�o~d;�NpF��.��7=��ht!�����K)z]sv��v �(��V#��]���A�����QR�04����~%��1zZ�Vyy~pZ����X	� ��ch�"b)q��F�R^�E��.98ӳ�6�钂#�)�Ē䒀;B �l�g+% ��)@s�/�7� �k7^<��p�0�<S?�C�b���`:8���	�w^�E����i��`�k�[�:�l�:}�D}{�x;� Ѳ6q0�S�y�GZ�撆s0=I6]�ZN��0�t�]�V��wF\�pY�O�Rjh�;��/��:K��~�`��bk��f��K3�Cn��q�И6����i%�-s�;bԆl��s���o�,��������`#�4k�^�pG���X�Kn�W0�Q�Rؼ�KΡ� ����N�P��\l�������8T���8�l$"�һd᎔��k���bA��2f�"�-�b@�)��_�^�9������O�;Rtul�/���PX-�a��<�E��4���G�C��X�<�}�G��/Q7o�=�&Ew��z����K)p&�w��n;�X�cw9����=cj�D��F�q�aH��bE_Rpf���Ԟ�E{��95�Oi����O���މ�l�^Ï��@�>���� �Q���I��,�˷�Xy�,8�@\=�ƪ���!nՅ�:�Xe=�Zq��U�dE��hNH]�P��e����t��x�Z3A(׃b�]0ṕ�z�ɛa��<�=�rʘK�B�@��Ms��@uCӃu9A$��p0���<�������Z�^����4�b�Z�Ŏ����T�P�����%��`���8f��e�c�ߘ������uZg��`Fܬo?�1?��s�?*>�a���m�cě؎l��	Wje�c�`�h����1��b��������\�s?'��7�IEK�;���0C�����^�Dd�KJ*>W선7fJ��1m�\v��ls@9��,vDФ�
Jfp�Z��lw�8Vlz�*�p�ϘMK��v�Л���^�'C�n��%َ�������$��^�\v�Ҹ6��)��팠Ia5s1�h��n���n�`�xY��h~{يi���D��TsN��PZ7�c�,9��1T�P�ɉe��9쳄җ�,�e;9F!����o}(��PD��̆�.�O��Y���R�,�Aq�4)-'k��X��QSW/�a�n�{E4ml�:���;vL���(K��f���'L~�6�Rb0����)�m�Ŵ���ӎ�#�*��4���`0p��c��Ѻ�7��䨣b]	{O^~�^�&6!��/d-��+���bY���F�H\����f��U�v�P����cfccH[L,�v �qU�¡}��S��@8����aéQ��U�[?:md�*��f������04˘��6�]|Ơ��f;r<��t�11�!9-�H�+/�}�b}���_��ϘJm,kC�)�`�I��?��cf�M����؛s(����0q��)��"ˉ��b�thrMy�O<2����-��CQ���-�?�����ί&+�)n�w(����PbC��{�2uˌ1��x�G�$�ψ�����	QwG����s(��|�t�r1��k��J%��E_R~����P.�𙢗+�Y⺷�_(����d_�E��H�P�ibW7޺%��ؾ�X���'CH]�QM�8_��Jo��C�����w�\�h�����e$�4�-�;��k6�]�hg
)C쳄�k=
SY;�3GWu��>\x��ø��1�Ž�	�u���L�3��DJ�G���)���^��_�)�=�i$�Q�K�ϡ���X�:����zH��g����Q�@���u���gJzz�o�"y�PD�y{\��6Ƕ�������\��3���!�\��3E%���s<)��|�b�;�K��Z��;���V6
A��+���6ÑR�|��Z�*9��dK�k�7�mRP��J�q��F�?:�������'~�?Jo͞�r����m����cDxy�Rhq�.�7�������h&uZ^�4�%�v�ȫ0:�,&n��S�6����kE�̴��9� ��Ҥ���8t&y�2 #�^Lt8b:��űq���6'�%��J/�v�$ђ���+��S�F7-��\��޴ň��9&��vL�����v�?�	��u-�b�3���4�6�!,��J3��J�nE�k���9N�j �9��ﱪ9;T�š��G�����?���za���"U�*ӌ�P��Cad&�/�s�a���c�P�Ryi;e@��vF���%��>c����q�X��y7���%�9��>b ��ԭ��Kc�.R�w?��o�G�y\�����>Sj���ԃ�&�IN���\��3��T��wȿ�=��K�i46���u�/�)zO�3���ĉ�#�カ659%}w�Ì:�s3<Wd���YA	��\��٪U�)6�)gU)fZa-����0b�IxS��7��bB�(ǝ�'�W�w#헢J.��q��f\MJ�(�ّ%6�JU7�IK<tn7�&E-�:��b�)M�S.0g�n�14�!(���9�sG&}cp��.56�׋�Jq^���F2�a�$݂����YL�����������S��j�`�V�9�m������pc�,V˥�9>Ԟ���Ǻk�(P�D���}ѻt(����tI��(��{1f�u���-EY^S\�3xǴ)��i)6,�f;#0=�I?�n�{j;�L/hUXg�\�n��Ȳk.�v�o�o��uj��l��_����<M��9�/��g�d��W[��y�v�c_Ǒ�#�
L�	�q(��`�a���=�ۗ�g��4h#![˥�Ρ4�	��ԍ^��ߓ��|쓷���"��[~Z������s<ևR���7���&�5��7^��@��,�L��%��Z��p(R�:��r1"�7�ʫ� �XE���CI�NK������2U֓�l=���8��Y]�(����RK6� ��.Zݯw4m���8�����0�$�����Ք6
z�;��[�p�xt�f0#8�����JW� �C�����mm�L��݂@"yAō�4��_
Q�b)��)6O��.    )�#��Ek<	m����[��w��<�B�-�n��.5�S�
m�s���\��#]V+O�ꇚ��s(���d�M%�9�aH�R~^�s5�;��5���p{��Qe1��DMm��;qY^x<v������Mg/z�����^M�1�s��gLm�����^zbF���a��0D�s%{`Ū�e����r�й3e�������j���IY�a�d��K���0R�J��+5���N�m�j�'���8wƼG�b���jNa��!��/ZL����Q�E��y8SR�����y���xۙx�ݭq�Ð6�c&я:c8q�����p.����J_��j�	�a�;��8�a�Ya3���X���P��Q~,��_znj�[J�K�Q�{FJ�ƽpgJ��V2u5N�y�֐2�Џ�(}�| ap�u��;uЛ��kc�F��f�����>M��LV�5��(]�z�P���a�/�"L,��0
�Q�e<\��=[�7e��n���|� hj�*��z��9P̃�:�'���bA�)C����ʿ��oyG�j���d��F!<�!ʆF!��o�)���ۑW�8Cj�Zߩ���]��2����'U��;S�"�uk�����7�`��Hv��y�3����l�����SVFK���8w��{��ٽ�����R
ۤ`��!픆y$���\,�3�J>���{�H�j�)������	����9���{Sf+s!�\`���ͻ���v�,Ŏ7�}Z��-5��y���i˪��l�G�F�,�r�.
N��bz��M_�3E�в.�ģ�y��)�OzdZ��Ja������b
A���⹘VmJ���~S��K��Tx<HA�R��� �i�h��y��Y(�a��+oѲ��R���Xr�5��<S*�G�b ��͗��0Y�+ӅZ��n����8��y�Q�ጁb����-�Qg���ڮ�O�[}���m3�q�[Ͳcd��>�-$���9�C��%��Cj��e�����S�ա�z\m�Q�]|���G]v��Vb����%��H���x;�,?���.v0�0v������ch��&n˧��<�NVi�b�\���迴�*F⒫Q_gA��W�����,���by]�|W\���U�x �-)��C��|�0��UGЅƇ�;�S�0M�SZ^�e��)�ڴo�P������G���Ή��x0�s�\6����%@zI���oM�Ȝr���%��`0�i��K������Fb]��J!���;b�O�r�#�=M�HY�y�ey��<b���g@�\�7eVj�b�����s0*��7�P������?����#�ߘٔ'IƊ��#��LV>��8RƆAj\^��J�����s0</�%��`�0�b�0�7f�3 ��K�d�J׻�M�h�q��yq��8Q
K��7)�샛�ls:KYz��Ȣx~]�S�ޘ<{�1P�YL��O��s��,4]rx���eP�^2]rx�qbY0q0�.WTγ��_L=٪P���y�K	�$j����4-����ؒp(�w�$�K�S��!#'�YB�ޑ��1#���𖫼S杫����.��L�e<*�x�[��Į`m;��G���Iwӝ1��y]���}ǌY�ގ��X����U6
�xz^e)���'LF �˜Jlױa�{eY]�'؝1Рbe:)V���vLŕ������v0ɐ�ibc��AS�u�uyS�&v0j��2�Gf�g���	)fR�uE�0@ydF�RFnbT.��yh*;�$�p>]2yE�7+�A56"��������a�Z�}�ň��Z>�ṃK*ϡ���Ly	�=u�%�@�Tq"ݾ�q��I��"6���t�t�7C�X'
�U,�'�~:����Y��.�1+�$�L�Qle�o����1���fKx)V�<cZ��6j������l��►Jm�ԩ ͭ��G]��3���?����+�-�Q�ڛ�㎺3��*\,eD� e�-mj��cx�%+��r�F�e�)���P.N��� 
V;b���>S�.�쳄��}=)_Hsh҇��D%>~�V��Z��DL��B���	b�~�8Z�_�#g>�x�K>��譔�6����)�*2�����x|�G�)���"���������:G�b�ʆ(u��}�xB3�痰9Q_r9�[��a�(��8j"3�ij?K�E����4v���V����u�=��o�6LMs��{���}s0jy/�m�X=
#(m��_̇}i�|@�T���m�b=�(���tN"i�o�)?�e��)����������H�����\�沅ێ�s����\oq7�G�]=&s���t��NipG3�,8��0�O`Ρ���f������r�놡��A���LJ��OFPE�f�Qq-&ӎ�����]{��e�1��sK�Oa�����i���;6"x�*i*s�R�>��<c ��`bi����fY����X���������%ǻe�Sh3��u��g���k$�������JP��>�t/�$����$��e�o�z���~�)�P��oĖ�����s1�e�L��j��UL�{`��)�'���S8�ˣ�nJ�qY=��~��lY&�{��񐢾_2͓�.���+bh�fl����y&=�-%Al�U����Y��r<SΣ4*���^�3E�~)�M_���M��Ԛ� �d�N��c�䜞W��ܤ�s���߆4�^L��@p�h�Q��dÇ����Z�v���9�{ס���훾����k��J��rٻgʨv  K����j�s6�y|I�)�XH��e�[�7;fR��Uی̳\�o�-$>uH��#�R�f�i�ߌK,���åd�6����z�K����A��6��xk��Pf�`tZ����x;b0f����FU񣧩s�h	��
ǻ�H���.����ֹ�,������u(j�*�5V�he��iWJ����=bpd�d�D\C!��ꆡ�r�[���r�l�3��"�,&��m�&i޲e���\6��>񂉣�w����%�ʗN�#F�=�۲�#��[�~��,�N]�D�W0ŵ��
/�<_pFR��|I�����p������b����	�ml�)�?4�0ЄA!����b��A�
-�I�8 �`t�0-K�hO�
���9�.	8�ҥ�ds���6vJ���Q(kW��
�j��j0�I�ӎ)�)�ӼOb/w���l�	0��<=J�l�x���qF7^�)�� �y�`L������<M���i�-+kI8�c,G�%�ˎ��V��w�<M����:���uI���c��<S�娹��L�[a�[.mu�v��$�Cx�x×��#F�X���
���yA���4�#��#��{
|[9˗�:#j���G���	��rlm�K*�a���R�*4�2FM�f���:o{�)�M�'����\9#cΆ6��-���~����~�nGp~�[�V�[�F�1�ƋG�y��ڄ?ǳ�j��Xj�����sr<\���S�`�Z��_ݨ*B�HcY��)|���-ͥ/Ρ�?��w��~��[��=��`b�����Ӗ��4��~]�TUh���ܥ1����4��d�.1P��b���a����CX���\����A�4�95�i1l.�q��s�$o)�R�{���`����}uK����6����E2.P�r0�w�Z�<���F���|Q���cd��&��`b�V��,&��a沋��)��!�:�/�q�w�3vQ��1}j����o��&�W�TK��_�	��EE?�O"�]�-�sj���9��1���?��ZhB�=��e�)��Ql�ϔ&�ͮK8�ӣ�N5�w26
5l;I���&6$N����&��v��c:� �Y_�]㎘#Khy�X_m���M����i�ָ#ɍev���Սz�������o��jF�ѵA���z�Q7L���4x��ưCi0j��k��1���n1�v0z�w;۵�8$1x��ԥ��(��r��gLI��M�t�}������yFe���\��Δ)<sb�8 �    P���t��E|S����VŮ�G�_H����(���������"p��'��-H�x>��@�ڴ�5���>���f!�I����{ds?�G���խW���ը8�KK�C��T��(��K�φ�(�6~�X�83[�]�re��o7]���#��Ԡ������[le*���`4����w����3��]2rE�K6��ȇ=�E���5Ed-0w��+��͌�F���P�ȵ��!�� ��V-�(�ޗ_�e����Ĺ�#��́�J��B�"�|���N��AIؾ�K�L)yv=��\zᶨ����{�BdϺK/ܑ2��lͨ67���-���2��X��K/ܑR^wI�r9w�RͤK?
�x��	_���(v�K)���C��y����6K���z�T9CB\L\�6��[���G�BKkq��ѣWwo���.Q����Y֜���]�g����������K��%/�[�li�G�y=�B8,�s �V�-�o�h�-�����jS禘�����(c��5�.�����	�s���m�����$�l�]����lj�����ۼ٦h~*��Q�#EW��ڭ%�G[�C����$4���#	�ͨ۠Y��9
���vq�~�=���Bzp���Fk��M�=)Y�����ϔ�Bі�"{,��P��^�g	Cf��FAf�J��1���d�+�2���)+K���w��_���%���@�����Pb�ס�\�i5�ֿGA�95B�����.;Q�N"J��8ܰF ߔY��d-�Kܑ��*���y�_�y�9��}���à��6��n^J�o����������M�[	�0��?cԚ�c�U����Ñ�0dG�y�#6~��m;ݠ�'�/�q�)�١Oh(Ol��Z��Z���w
(՝�H5���r���Θ�uI�u�QFOC;��[��E���7S ��-&4~)�o��+�خ���y��[L��)}���ۍ��.8��,�G�pJ}��EFuI��Z=(�a�I6х}�4�c�{4�:A���&>a`����9,|�-��6<\�
q=n��(-럑��'w�C'��㑌�%���/��a�ߞ����INH-jϋ�]���=SJ�I�����W ���}�w��*�z�s��A�c0������L�G��LW��q�A`G/ښ�mX�q�����/��Ge0����P�ٞS%�~)��Q�^ǋ:D,&4=�znyŴ�G9�Qa[L�Q�;���V���6�v0��r�"���3��X�����6p.;��sB��=�cJ����2��0���!e� �q;�n����7^MMg{���pe��L�n��n�Rf�6ale�Y.���/՛�&��m�	ї��1.i��<J����P�0%{�9��0WJ��	���G���;Y�S��J�tY͇�9����E�TF�U��e�+�Ϡ�=0ޅ���{����[�0�C���.q�8ث�,���7�B#&?���?�����B�J����ZGA�G�?;_�a����-��z���0�i/a�Na��T0_1S�[��uc��/�/[��aЙ2o�2g���Ö�v����-�;�vt�ó�}d=(-&>���iY�����Q��Ffac4�y�#�%�g|(a����3 ��\�
���<�&�!������0��H6�G*4�ײ��w��%��)�?	����9�)�=��(F��Z=Z�7DE6Z.��mKEԵ�Q�9�d�н)���֏,�F�=LOl[jz<ˎ���Ia������&={�sp��Ú�c���#�5Vu���;�<LOz���50��{cu�-�E��"�F��>I5����qrR�붉U0=�^Բ�#{�=�B;Ff%�0-7n�z�a�՗]�&̟|c �v�O̭w�yRwͺq�Ga8��Pb��F�Q�`�,Y�7ޝ1����"q���a8�`dB����6���y*9�ņX�p���/���+|�!���M��mw������&�:~qםG�l�)��q��f��9b:�q�)Z�qϝG�cn���e�� [7���E���}(���7
�H��і�`\v�C)���q��1}ʍ�w�L�}����Κ�q���`Pϊޓ^m�����3�m���wTӎ�3!T紖�$ �R��P#q���GֆscU�K�ϡ�&S<$qǝGAy����#+��׼QP�8��-UkϢ�0�$�$��������p-;f��p/b='������_�&�����dhP����u��9��J���{��A�� C�"��s(��N��PN�B�=�3�_.�?R��4�g�e0w3Z9S)�$L��PQ�R�k������vYB���)�st!JmӾ��v}#��7�Qݍn�s���z_7�y����ib'��&�9�.�=m��;q��`;��˿��/{6 c��%�` ��ܓ%v�j�1��7Ӻ6��`z�7������m0qQ���ݣ^m��Ċ�&��m��؆�c� 1��`���	�����&�"n�^���0m�o*�FG�6j3��f4�x��Q�Ul�RjO��c���u��MŻ���WI#��4��x�Q�q#)90��s���w���������S�IS�C�D�����q�����������W��$6�����<#8�iB�q��Kj�m��P(JL�^��Qh�S`�y�8�3��4-��zʙ��4��kj~����H�7��a}S6{%�2�0���k
��PM�}d��/)9�􊲻�c_Ρt�l�S8.Fv0"k@b=L��c
<�<�/����s0̣�/*v� ������9�!ol?)��$;f�k9!�g0q/�C(�_�����c[��������k%�9��:.���"(8�&�-��K��K����o=��齘���b����&�ka�^ˤ@��`X��\bg�:�ٔ�J<�n�Y꜈$zw6c0$���(�����"6���@�@��7�y����y�q<x�;+n�'սk�X	ӣ����ı��"���#]ݚ%�u�cG��X�b��#JVk���K.�V
!P�@�ar�$����&_Eb�ӎ�ar4�ګ�҉�P���;�v��f��=���ϣ���T���>���Q
������Pc���"a4��������{�}8�as��:n�#���9��뎷��Q�m}�\�6�jN DM�����/�x���̌�t�1m=158o{$����\������N=�
-b��i!��~�M2�-�Yg�x%�F�8�(ĉ���`��8��@Йb:՚�J�<�`63�G������s���@Mſ�Ť��S:c"��b�`0�3f��Rŀ���YN���n]0��o�#�&e�\��SFz��w\Rq���g\Rq,�~���K*��4��g1����ԖA��g&�Cz��13.�x<v&¦;�a�8|�蛂M���8�`J�ev+�#�oi�t��MX���7�C�/�D��-o��}��k��i�#��A�/�iF�a���}���VvLA!X�0{�]��C�ϮM��h��)��&�2c\����v�#ї�`����Q.��vL�9NK��$�$ �ı����=~
A{Y~�e�1j崼��>��f#=��7��G��e��p:���RS��:h�ysi�;b
�fV�D�C�ܯU�G#x?��)�ۦ&1�����)��U��<��,���-%�,q$͡��֍�̸4��~bqG@�f��Ŕ8SX�\�HCC̓�ϩ	G�̸t	�)]�.��<QY�u�a)On?:y��Rnf]��tg�~�zow�.Kx=��Lp��1nw]���Q8uZ(��W6�,��ӷw+=�r��1zK/U�(�zP�3G�⫞�V�7=�����)S��aR��0�c+�/�f`w:����c+��L��i⳷����J�����u0��.w�����מwL��U�X�p@����_��"�M�aJb*���[�{m~��Q����(E�{д8���N���e��/�qG�)��    ���~�}�W�3��pI�1xivX�h��i�Tt�a�./O��y�)�b~cf�����}^w|;Aǔ9�bYL����X�ꒋ�S�b�3s�Y�K2(]]"�����f=n��m� j��E����4�9�&$�wi��}Ǵ�2�%�>.rf�	}�Qq0�ˎ��W����wpi�s0�Od��{����a�l��z[.~�%)�`�Xn�KN��G12���0��q��9��y)O"�I�Z3����#��[*y*}(�q����ib�渶��P��?�,��P�ڒl)q�}�?lDD��Sc��p�hְ�4ǵ�C�)��w}6��w�Ыd�ec�ǯG�.�-�~�2y1�I�l�u�atE�q{�"��`�/�r�"�#V�ܣ��Ru���o�]v�<d��s�N��h0u��_tٹg
��M���p����|
M���$��K���S5����=S8���	�������'3���%�Ph�\�\����E�Ӏ�e��3P
?qk'��i�$�)�C���� %޻�� �>�k��{ס�aJ�SpG��F�2�7�㰯��4C�������E1��p��+���,&�dw0�K�+�e���CJ
���8��F�����β`�"`);�����l1-���+���y��C���vXLz��c�_�2��b����oZ1%>m*S���dB��?�	���L�L��p(��$�?��y5h�4V����=��cT)%.�9R��'���F��L�)���ͱW�܅,������夹�b1�]�d��6���D��y���#�1ĥ�-si���S�m��$�ۮq���2�Lܕ,��T��CщmzS1�S�����lu�oa�e�j<��Q`586FD���`Q��R��cƌʤf�%(]���:�������7nK~I[:U��GL{��j�t/9�Qv�lfS��*�.��i��&�L�N<ꆩS��V���/i8#cN�4��5yІA���Ro��ě���� ����Y�@��V�%�`�z��Z�T�h;��1�ZN�Gţ�<�T.������0�~���4�]|ƨ�Ҳ6qx�G(�Y�)��i.���z/$������3�i�=�lb�l�3��4Y02c��U�`��}�`�ZN�Q<�P�"�b�8����I���8��Q����d��x@��Qi,�Bg2s*fj��w���М�0�*;{�;��i�ᩜ�{[,��1�Ì$)//<��9юiPШ�R��_��aԼ�A��8�(p���z��p6��i�y��֏`��izD��^�=�LxQ�//OS#YNmǴ)a�g���\v�Sz�j�	������m��e�1C��rl��`mNy�)�h(�=�I6
A�T��V�n�8w�̆`�8����4v�&�^�����uV��reJ8��� J�|���{�]�Gh<���~KA���F�僊��Δ��,}9������poR�%�N���4;v��4{q!����\:�N�x��o�-���9����f!q{��w.2���Z%{�`��?5G���vJ���C騇4�;b�Nv�����7C�Q�� ����t�&K��!�kϵ)�?j]~�%$q���1�l�R���1T�>ˣ�Z�9\}���'�/Y�#e |o6]��T�~'�C�t�U6�|ѩt(�w�$+�G�����fs{�P.�b�m|JV	3���e�rE��?�)_��)���l:-_�rc_]�ʦ��r��%;�Bb����L���k����X��L�db^t�_�vg��@E_rMHg5�΃TqLL�qgӜ�����ͦQ��_ٹeG��P��{0�@�=�;�q\D�N	#�����+�$@ϣ�&�ԇT�� E�y&u��k_���(�N��N�1��4g�˴�8���SR��{C!un���3(��=��|:�*C�Gb��ё�X��zꨆ���V&�ye�s
�����[��I��Y@�ƨ���f~�.�_� فeok�Is��=M�?&�=���<a4&��?c�֐���!�y9~
�P��|�hwI5�&�
md���{hRA�Ln���c���L��cm�-�;������:l5�ɋ0�R*�+��P&Y�x�SD�a��k>,/�LGKĽ���3�� su�g�U�SV0�B\������%��F�w:c`6�R��Hv��3� Cs��g��V��_�� �yG��Jv��M��<1a��;�ɇikY��7f����K��T"�qk��qcE�ߘ�q3���'�'#��F�ä�m���²f��a��a��������Q���N7!�<�F�A�S�KCy�׷��yi���.O�)]��qT�bI�N���yw��	Wgt�V̕���E�^�R�ʌ��2L�S���u�;**3JG�p�<c�}iv�R~�n���g���~Gyc^��֬�V��_��m���lp��yg��l��P�;���&v4;vR��7�A�e�<wپ��̓z��y[^�!-���tޖ��h���?9�1���-�L:1�Ʉ��e����+���k>�.��G`K2j>����5]Eއ��y� ðId�F���l�\'�`lX�1Zgb�UR��3��#����FM���J.[x_xˢ��9�콼)�Ѡ3�9 $�CG���6準�����
!����F=����4�B���|�*��)ZQ��g���Nj�Qiur�75�ʋ0����{���vk̕װ#���G���.�K�m?�qIء&���_v�齌�^j�Ef�@gC��n�aHEc�\z��^��aX�5{\��,���rA�\���ѝM?r+"�Rq����Mv�K���|�<axZ{`�����Q�F+���X����p��H�<�ѳ�3f~S�v��g�Q;F��� ����yF0��V�~bR���� m���:����yN0�д>?��&%��(���P�-�e�|��5b���%��Y�Ò�1�Td%�jg!���}X�x�<@?�㓒���A�8J���w�(��pI1��N�b�N��5�Q6k�A>�.��t�yy��n��������&��X2�0�(e�w���Q��U?
��^�3���g|ä���F�KT��;�j���b�@��ЧO�;�=���b��\)��.Q�l1�L��n�>D��l�3����6"<����W/�B����\@�潭(��¼QP/������g���3E'ø7����!e:��D7��}	�Ÿ�pI����B�B&�R����l�!\�q'̚�9\xZ��D���6uL�s���uZn1�I=,�����t�jv�:O����0�rŻ���#;�]�؄��y�^��RٿTnQ�z���L��[�2t��<�����Rf���)ڰ���d�g�*�],�t�3Ve���le3\�q������&�(��/���.ɸ�B���<r�y����3뒋(]:��m�Gn�7e�
S�������t�K��QN�|�7��ٌ)F�g��am�Z�Z�U>�� �H!� ���R��3�������eﶍ��GD6$ys^����ݼys��N��\�	.ٸ#E�C�}՗l܉�4�c�?˛[d0�s���"�D�SV��N�r7�%`P��څɇ���H�&�4����s}��.�8�}�[�o��=sI��>��t�#kx8�ks��g̼%����]o%_��ԫ��\�qG
ϣSš>�K:n��h]�M)���\��3��iPe�N�觭z�J�52#�|m��P.�wl���-km��g�KdF��m�_��K.�2O��(y��NY��4��V��ٕ�R�����.�8ܿ�!m�����/ٸ#E0��n�잇�q���R��G?B.�3����~ y*n�&I����;/}k]q���!s2���'���h���w��%ȝ�R�n��(��yn��0�6xO��"�x��~(��:���Ʊ"ьdkCᒂ;aVSD�s����iًm��_�C��_�>l�F��g)���B�(��.)8��ZMp�|�d    ��f|�u2r��{��{ Iu��GL[ޅ͜�r�ôc�8T+D\����Θ���l�i��TУsؾ��KeF��+������F���tu�l�֖���0�Kq�[�T��Y��,F��������\̇3�ɚD����ӗ�SA�gD���J��c1y5�C����n�L�%w�� ɹk���<�!�B�5��^̃�{��0�oU&�*�_���R�叡�.i��2=m͹~(�	�ҋB*y\��Ql�,\@�Pi�K��F�7����f].mqR7�~�Zw�І�ۥ-.�H�L�2#��ŭi�\H`�4u0��:��vI�1�Zz�ۗbL�1���s�tBk�$\���C�4Q��2Ip�,�Wpj[-�ˌ08�J3�W�4{�1:Cギ���r�Fk�l����1]��P��&��2#L��r�-V�{�5�:>�b
�Z.�Q�6�^�PrK8�L���g�a���_u��%�%`��_��n�,EvJ����~��0�����),�0_z�^:z�>̥).����6��Ird�1ӱ�ýS����c��t��Ӊɷp�Ŋ[iF8$��a`T�F}w�a~�0UU�xLޞ`4��\-�:l�ۤ�kl��� �E\�K��2��3��D�E6��.mq�:U�l�Z&uh���*:�m���j�f^��*J酕��gw*����iǈ�H8��_겋��W�Ē�cV
���Y��F�5`��V�(PX;bD+������d��o�9�=a��S༿(�hɖ��6~tS���~(-��(�cn��q.��e����i���vI�)�~w�#q�[b+�_6p�0�����9�0��{���l62�< ��FѲ �մn+<[>�.�h���6���n˨�{hm�Ӳ����G
뜭j!��7�����������gŨB5ybD�)*�ՈB��>f !��3��<� ~(Cl("�V�]K*���wf0��v��]z1+M?�?_�?��3��]�������F��%��`����v���^�cF�i�=U�����(_UhԪ�i=o�0�'Ｄ�5���.F�O��ʅ1i�#K��8G��`�Tpy���u�1�)rq�|d]�����KWܨfzZ0H���ڥ+'^!�[3�� x���k�����/u�;bp�b�.��42�}�v̺�Tڅ�.9� 3���-q�l2pô�D��Y��pI�1��)��
p,�9`Z'I����^�v�j�ղP{P�-.��@�-���˞f?��eYT���`.�a�+�{'�F6
.q�ޗsc��aD��m0�	<���K\R��=Mn�~nm����ۨ1�b�xI�1گ�h?�[㸔�:�z�v��i��͏��<-ǥ�u1��5��&��iSLj
s�S����Atk�����m�kjPD*�j`��!}��c�F�%��]��D�A�މ��gL� �EH-b.�cD��
�Q<���j#[Ƣ�[�6g�,{�@M�021�G�;<����U�2���>�^RsGJ}Uu��P.��~H�j��I$&�R9L�oJ/d���A�7e�������bI�f��T���3)��{c�,y$"���WW�A��r	�)�L�ny(b�'�ʩ�f�0��q�t r�Tr{wE�iܻ7��'��]B5���	��[Ӱ�uDm{U���\�����/}�;R���m)����Ұ2W*�2��p�KO\@��|(�Đ^-�B�]z�J��t������E��.��	/�%.��uq�Q���M���Z�/]t�r1�mv5�H��vnO��}�`[���	u�Qw1�S��5n+���9e��й�*"B�?����:ژ�\��.)��g�!T��?ڒ��g�i6t��K��!Z��*o=�P:�Lm��1�"��cE�Qs��,���;�X�R��t<�z��?��0H�7��t�$"1�]�Ϗ���������\�K�z�TmY7�v>k/¨~�-rEN�A�;�_:�:�e�6�����m%6���=�S������@�0��a��J8�g��S֗`mS��&Ml
�$b�a����=;e)��V�8�%zr��uq�.(���v��4����E�4�&0cpwν��'��o�xu1�xE�J<c@P;����������δ)���/����JZ�Q{��{OK�����:��i����Hg�P��f4LUK'Qug;��M�w鮓�m��gJ�������d;���.�A3*��D���;Sta����iW5۱�K}T�[��4�����y2�+n�Y�9C�fdC�P�e�C:0O&F����3Xv���gU����4.'��Zh�ؑ�qD�y�[���5��I'�� c(�P.��@��*�h��l��tx����y1�P7h�F˞��kV��b�f�ܮ�=� �~��P�B�(£Z�ʅ5��vy׀�Q�3���t^���&p��2ָh&��g�j-�a��(�ǵo���H��d���gϘi=���I�G�5<�4zS�@�(0@7?�4��u씮Q�Z{�5��#LPl����zp�/�&���(��;]҇e^L`�(����5�Q�h���.�À��O�J�OQ��Z,%�E��e�;>ؾ�� >Qtvvg3�vI�'����z��f분�.�� ��{p�6B��2�Q��%7��H��RWWմ~�/I����64�mQ�\V�v�jB�[���7�E�.�j/(�dh;���1��8?����m�����5�����lἧ/��(�+u���R#��cƨaS>��i��y���K��時�Bæ_�܁�n(���������;����(�Qec�.��G�ћҵ��Pr�p��[�m�(�{�|�]��Z�m)�|��2:�j��������7��n>�1+d5�غ����1�cp��H��vvX�i�0��T���#���i��z�3��L�m����AvLW�|��B����m����h�7�%#�:p�b.G����-kI=z�5/�K���Υ5#��ִ�2S$`̯ۈZ-�ԿGf��H/�k�&���s`�2�I��>�t�RD�/$F���6>��Q4ȹtx�}�y_��:I��������z�����7�����&߽�߷�#�Wk]l�8߾F��(X�U_T�Q��Cu.�Fp@.�%���)���ĕ	���&�E���#��J0�������Z�u�r]Mn�Sd�*e�.�Ռ0�;�< �{��r�:>s�䲚E;L��y�,:SV���\V�LQQ�Av�J*�Q��`�.��;nm���Iy��z�|~�K���i;�
�<��p�@׳j�!Vi�.��#f�ؚqI�D�6L��
��etI���4��z�B�=��kRCQey[�D��fDa�3YJn?�>�����F�U��^.]p���&H��[��&-�K�%�ۡ�tI�1�� s9wL-ZG=��izk钀;R�UE�H%���L���2in}/�3������k�v뢨Fm���rq͈"Z6ev���7��!��������ҁ��+D�A.G�	�ំ��Fn����5�vڈ`��F4}�_~7�.�`��sm_]QS�^����gL�M�`F��mlj?]ltv8�<u|�L��3L�~0U}Q�4���R!�ꩵ% �tAk�˃(�7e�)���\L�3�ǚ��Г �7E�Ml4�V�D�.X6�[s����i�l��Q��VX��i�!���&?}L��v[I�'k�I�i�vו�i�GK�P�V���jn�F�^l�<_�o��¬r��S����[@�,���/ٷ�2�b�V��/�v�F��>�G��7Ga�-�Y˴l',_�oF;>l�+犚�m�UOA�a�\P3�g'�X~�0�a�<j��2}	����0zi�{|r���4.�jƳ�p܃��M��Uc��V�����7E%}�#λ�i���.��W����p���P���g�;e5>�	m0��f����Qr5MF�1�6kYq��a�JVYL~�b�1jϼ:��_*?���i�V�$��ĳ�r�{������>��{���U�VN� �  ��'z�-��"�0�&>b�UQ�����%�S���&Y��Cx�U�x�{�v�$�ʼ�J77�%���*����£������)�n�v��:����,�V4�5r�C�D�=L�4�.�8�Eu��ɗ�߶A޿w��m�A݆I�`�`Ǵ�j͵��/�hь�r�]�}�mǠ����/��� �4�a׆.Fľĭ���2RĜiF�>]k���vs\V�X�2��X�s�"��5x�@\���n_(���О��M��%�P ���� юy���Ŗ��%�`,���#�L+H��4��%�v�����	�c.=p�J:�]GD�1�|i�;RH�b�!� "ʴB��xɽ�eޝ�����z(4Z1���2�H
(,���v�=�/y���:���#e^��ݔ��j~���#:"G�/tF�}�T��L��B���^Z��f��>>���*�i�i{���'o@��[3�gZA��^�*99�"��DQ�jH�����7���RT��]b'�~�k��_��(�>�cd�l�_�ގ���3h���S}%�έ��ݎ�1�%#c0�dP���]q�[�]7��#ʰ�}�]� �c�l�Vu�O3vL��`^��b=�12�8��c.;F�/�lE�x��o@���������4��P�+si}(�a�3�e��y��I�Z-3H��䵓FsB�<� Z��ir�{������%��mN>m�{�NoJ��T��v S'�#�����#[K�j�dkJ�\6��U���rɿ1�|Ϛ�V4P.�o��_����e�1�	�e��)ʥ��!�(%v+�琙7����5�1Ù&x���1��[��w�hP+9L��`�1��%R��0��/�N듚'��<�L墠�}���S�K\���U����&��������\v�C�\Ϯ��XʎYM�R�T��M� 3؏��=M��#F���	�Jͭaq&���й0Cܾ���#f�,��-exb���n2w�k��K..�6w�\Rq� UJW�fh�b3�'��en�&lj�䢟P�5D&$-��~S��.eI�}(OL�/�J�f�����MX��U:3� �,O�/J��τ�gyb�)k<n��咇( �J��%��7�C�VE.I� ":�l���V��蜔(�
M�(�n/�P��mnQ�ܿ�_����b���9d�������=^�z�_͐/J�	P�]L�3��(�Y�?�8�(8�PD��d��x���
�¯E�Ս��`A(:ˎ�]�������n����"��r�]���������hL�Iwi|(�t1Ch���&��@�C&�� #����B�ݝ�y�qD�Z���Gر�:4��5cn�\oFEG�MFy�Y�\�s�(߽�ҷ������HU�gg �����Z{��
_��3fz�d�%�`�B;���q^lv,�\�oG�x�:Zs�<�!�c�j�.]�|0��[���?�%�&�a�Yס��\�of�Tl����4�3_�M�5�.ֱ��a�]��^�P�1vfL�K�!4��{�{���� �y/v/��G�f'�4�o4����3�lQ�H�"`�NͰk����������1M�6/KqO�-D�O�7��~�s�5�,q����f�~+[� ӱ���I;s�;����dջ����u���.�T`D�dl�@�`p�C�~��)tʥ.�̟	��Lє\���1;��g�;�{�1Z_�a\�4y∑U�o���3�+�͊HϵT��wap	�R?�$���5��Cɣ�UҴ�W�h8�h��%P�(�L�����}uky��W(�C�d���\Mz[�檙�'-ٮ��䅔�]�t��3�1l"�hQ�h�,n>�n�F�V��̶R\��"Cy���mb=����E�W��t�	�w�Hk����ҍ�ti�(K.��r���F�P�AĜ�{���+̓A��H�/�u�q�Q�/�EF!�.���U�-T���37��H��m��Z�B[��@a�&��{گۉU�e��p�������?F�      �   @   x�3�v�twt��sWv
��s�44��!##c]#]#C3++C�\1z\\\ �Ej      m   ~  x�m�Mn�0F��Sp�T���T(�$�
 u������ԟdY�Ï����47-1m�I��v��|b�X����t�����4ˀL�@c�yi'd��L�H�\_r�$�9+ce�8ù�G��
2ј�snؤK��0t����$�!��w=��A(��rt��n�%'{ �ӈ�-�d����>�s#qv���Vѣ�!�8�D	�D?P�����Ou�$RsKjN�8=�o$y�Dbi�~�N�?n�g��5��
�IWI�@L$�׺N�tY����0S�y�[;t�,�o����)��.Z z��r9��~n
�6|c�E�v�����Tc�jHy�S��ݔؖ�'$���
�ye#8gL�F�7�_�j~ҍ)������e[�Ö��R�A�t      �   2  x���M��J�ל_ы�����ՠ��"�`�(""�*����[�43s�Mm&b=���oʲ�ܟH�B� @���#'��C����`��/@����9��<��d+\�����3��|���n������q.��IPK��|��A���D@7ؘ���ݰ0� � &z����<ϫ�P�����'���/���(�1�|��|���\���l���8:�i�]A�ͼ��v!���ҝ
^t��;:)�u���TD-X,v(�@���,b(�e8�#�?ᕏ?�g_�O�P\��%"�  �$	(�$	�p��D��2����H|w�_����B��j�__�����a$N�_lMa���d��C�����Tu(�pm	�㾴uf}S�(|��7>�ծ��ANϲhu�������]��L��Hu�h��# ˸�[�^>�u��F�)��7IB������w�n�x�����~��k/
<������(��ĉ��23����'�:j��rA�C`����P���骈�I�o�T�2<�F?����+Z=�W�6aϽ�p;"�aĄ�;|��$��mO"�+C����X����U�za*]���3�E��-�^�t���x]�]�}B��i?��.�[�^��44���Qb:�l�=���\f�CbB_~2Q�!}z*�EwGx��t.My��9p�m/΀����n���y[�&���y������N��M�'�D�5揀h����<Ek�W��S���[F��ʑt\�:�qWe��3v���F�Cwq���u)d:���Ƀ`�\O���Ô!*�z'D,QB��"�"U���ޝ�Ag��6Em.�SE�
{���_��.C�/�Pw��	�� ��V?ut�X�{�`��R�:����OW�:���d�@:-��v�A�Yv��+9[Ƒ�y"�3ayQ�x�Jyt��EuЏc�i{e"ЛL&��$W���4�5a�i(���_$>x8�'�t^rz�5��1��z/����O
YC��dmO&X2��7r�-�O�"_;�Ҳ7����n�Cc��ױ�3^`�'���Za�ٕ�#��T�i�?�����5ڞH�6��+��#� �Iʳ/!��/}�*��^`�hc�#���=뙄�����3�&q^-����&�r��~�H\�$m��� �f��0}�%��t��tT@;v&�&qFJ�C<>%`�]eB��� �r����7n���O��l!�h��(��n�=[��������c+�����@!���a\�y�(�I�F��Ax9�z�j�Ŋ�QLW�H��P��� ��Ԙ�@�+t|%�^m�5�"���+��E˩�7�\�(�ud)�U!�I#ݹ=��4����7�,7�X�!���;����]d`� "U�!�h{����oF���+M�����k�����6��MKoh��8�-gY�[�ĹD_Vm�t��=�]�{����W P���o[� �� MbE�.��1a���u�
k�SD�MySM�9 �8�M�x�]v��)�̕#NmW�K����=$��/��q1/Ѫ�j�*�
��Eaq��+�!$�����UTs�̂s*k�v�N���%�j�{ꓗ����.��,����V�
/�����Y���
a�[�bzR�ԡ>]S�+[/�?�CZL�b�f<�&�Ig�z@\,NBϺ�WN%�YN���P��=�*�����O(�����WQY��f��Ao���+;��U�u�`����;�ɜ'N�]{*�צFU��F[-�J%�5��T4fH������*d��*�޹���2������w%z�:�l|:��trs�D�o�G�����:S���(J:`;dթjC��	_q��|RUu��������#���9^�o�I�y'|�ܻ�wP��i�8���m��9��=��	���1�a��	����Ga�ڐK��^���C��*��.�tKٓA���� n�T{E.-�H��03�C�S��T!��2�a{�_Ҝ.�����*P�u��������t{D�Ŕsp�䅾���ۄd�XXw7�{���ť�o��l݆�$`Q��~�s��� U����_�~���'N      �   0  x���An�0E��O��2��Yz�s�DSM�E����,��K^�T��{��h�#EÔ����M��)���Hu�0�j��+y2�q�}Ӗ:�	c�F캪1��ݫLc3��i�1�c���:�a�F�M��G5�1�{�=;x1x'vd[�>��s���I:V�Ӿ|[�38���Z���$K���18�Ҫ[�t.� YZ����diG���^�d)5���0Ēe��g��dY'^c�~���sr�R�&�ۑ}2�����&�:�c�?w�]����&[0��]�T��Y�C����8��z:�������-      �      x������ � �      �   `  x�u�ˍ�0�di ��O*b+H�u,�,�&��&Y0ߣ	, x�����a�-�I+��`�{k�W����q�o⊡8��=����c��AC	0��<~Te�Y��V�0�3o���A+�J`�{�uV��V�	}���0���{s���S�I��b�
νg[��;���ދ=n�;�5��ˑŨj��y��]���.�>/������x���=O�YZ���fi�ϋ�7���d���>/�>�����Eמ������՞�g(���'>��Q��3r��?�,mH�yƱb��-<��f�C+�Yڰ�7�4<�B{��a�6�y���k����,m��"�ǎ͝G^1|� �GR      �      x������ � �      �      x������ � �      �      x�ŝ˒�6���UOQ/P'��L\��鉞����7�Y�L�)�A]�D���������!���7yӠ�3���t)������g�OI*C���1�<�yx����߿���~����s�N���~����;N���>$M_j�i?�bo2��~�ǟ���9s8�/'���r
8�/��S�r$̠�/H ���-�[��Ӈ H;�"@�3� �m ��� ��lQ�W@��"����E^Ad�0��2�ex�Pݢ����R�h����v:}�eP��2h��2�uA�;������.����;��Z��"&l�A������9-��o9]ހ���t��!�(�� ̣h�A�G�;�0�b��<��3�(�� ����&��� �����=�ćȠi�;��6���
+��Q�%��5�ˆ$R����ǘ���U�܏���_9�#Е����HhZ��y~�$lA����U-M��޼c��o��p\�G�#�Y����C|e�Q_��#�樏uJn���� [��-@�e#�:KR\	b��C��A0,̶��.豏�`X�w�������S ��8X&��6+}�ȱ�{�N����-��]@X�]6�d�Yw?}��`*Y�{G�;2�;a����9$�cg$ȭ3��	��	��	���	�[&���K[��%	���|1OV�����������I,��j�7vџ�!(����..l�wV6_���"S\.�0�n��~���Q�|Î��ox1�b�P��c�?s���������WO��l����ʟ��t����W;����t��p����)�.��9����8�~ <��g���u�/�o����o��5�0�7yVv�#.%m\�.
W{*bU�ƪhp88���S; �k�\48��}��P�6F�C��	�9���ŗ���6�œ�� �Ő�]��bF�.���-ˋvg���)t4b#m�	��H�EBB#6r�~�	w�ޟ��K�7.�ZV�`]���e4܎���%�y���5�v�::]���T�5�����	h��3Б�.@I��FÍXk���f5�5��"���1MX�W[?��Ə��Ez��#�k :��0��-��O��ϗ��0��cX+����d�a79�,4ԬIa��fM)-�wY�>(Q����px% �O� 8x��Áw�������rnp�Q\�7(p��ȕ��wdղJ�Zo����~�^�Q_��P��4��qp���{|�UP+��4t�k�%,K�{m��-Cݲ�p-��n��;�͝��M?_v�+jN�b�ĩ�Y�[�.;���nK�՝�j�/��)�SvN�?�����Y�n�a)vC��J��]b�n�Sꅈ����B؂��"��K���T{!TS�ı��sK�O<'�ϒs����!�X��#�H^l���-��D�)B����_`1��G��@h7D"vC`�uC`�wC`�i�(Ȳ-�惔�Y��_�e�pa�n�pA�~Q>��%����/�g#��,����o��,6� ڨ6����6��b�T��k���V�]k#ۤ��
]��gC�j䳡kmp�ņ�U糡k5��еu|�Æ���gC�j��/��/$]�:g�ˍ���{x����=*�49Б��o�_:�:����| q�Z�/J��I����-k�mZ�ݼŊ��p��;�~ <��g���x���삐%�|��ф �C�m3y��q�4	S㨍��{)TR�I�7�*�
i�L*|���?U�^H�0�+��Gڒ�z���[ť"mIE�cٖx ˶�p,����lK: �e[�p,�R�Cd���șR��pMY��3���
�d���P�&����5��<8������pM�?�ks�ip(\��O�C��<�������!2���r�=�5���h�!2��Cdb: ��� 8D&���X�p�V�!2������h�[��p���p���p������!2V�pTy����.�*�^���R�m�� 8D��p���p���p������!2^�Ò�ʇ�̓�p <!7�I>"�Ed���V���n����Y#�u��s�w��wq�¾�ğ�t4�li�M�&�1�����DGcr�LF��d�����9@M
[MP�a��f$H[�@��o���t�	=������t���FGg���.@':���舴Io{}��Z�ttZ�	/�6���V�=�og4�:\��������p�t44�mnGBC���hh�&:���Fz�k���fM���-����a�J�H#�j�����w�S�Q�hiT:B#!�FGCH���Ҙ�hi�l4�h<:�b[N��oϟ&��f���y4�̶�>�ٖ��}�P��|Xjf[�wA#q�mK��>hL������v��oI�@Gc^�И׮t4�G:�=t��Ƽv'�my��<
���e'4�kW�Q0Ј�]�G�@#�vu����y4�kW�Q0Ј�]�G�@#�V3�v<VQ����i���v���Z��Z���z-JGc��HGc����^����*H���U��F#g�mK�}l3<pOt�w홍F��{����i��Z��G��'����I�hhx�t44<ONGCRR��!))��H�T�hX�M�����5�[S�5�[S�5�[N���y�����:o9n4�u�rH�.hdTz�rH�>h�뼞׶��4��:��y]����R"+�5+NGC�J���f%��h��Mm	sRz�/;�!)5�ѐ���BCR��ѐ��hHJ�T����T��!)5�ѐ���h��:jVWj�Z��g5K!��h��h���HG'����@;]�Ntt:�цj�
-@����4�AC�$��P3:j&JGC�$��P31:j&[��-��R�h��uc�0o�Η�И�붦4�
�y�JGc^k��1��v�tD��k��G�tܟj�ua�o�y�q?�:����9eS����4��x���hT�%-t4D5�{E��WD�Pە���ըt4D5F:����䊙�F�S�����W��7���Ac^ۖ���1�m���1�m�	��1�m����1���h�
��l�}�0l�����f��\�]�(�JM��L	�3�t�	I�@GCR\�hH�+I�HGCR�+��NGCR<�ѐ�l4Z'_I�,h醆��@GCR��ѐ��t4$%E:������$��!))�ѐ���h��T�h��%8N��<]vBC�r���fY�h�YV:j�#5�FGCͲ���N��ј׹��:xm�e'4�u	t4�u:�(�y]"�ƿ�:�Y]�C�t�NE7���T���kV���kV#���4�T��ޜ(n���e�.��||3f7��h���M�U?$���f�:���3OC�4���FJ㚎mBN��f�C�G!��<=	q|胗�ڧ���4��"��z�7��?�j�0P!�r~�i�c��~���4�]Q_`M}�/�!�;U�Kށ��hG�`���C�����,1��Saݗ8�ֿF����yY*���lh�����p���{���-�?��_��L��/�ΑYc!?XGJdm�-�гiQ-�����	h��3Б�.@]�v6��������j[����y�wۼ샆�Y���fmKj恎����-Ih��+5�HGC���h��;������d�S�ϗ�А���	Ii¯,4$�m�DBCR��M$4$�m�DBCR��M$4$�m�DBCR��M4�?k۾����������6C�gM�����JGC�r���fY�h�YV:j�#5�FGCͲ���ל�h�Y^����w<���!)��ѐ��hHJ:�R�����HF+B0�W��a�4��ZOa�׃PS�#�[��M/N���P�K
�2ik���
w�������G���x��#\�.��O	��erh�|�6_vBG���F�TWA�uD�	b���� �dPm�#��n�|�C�?�
t&��3vgta�Q&Ssy��5��Cl�2�+zf����=����N �	  ��	���or�4����n({f�j���
�7�Wy��I��vqG|�Q�U���F�mnf��:�Ňqҏ�xY�������?��摤�����i	�inb6�O�ӽ��Yو(�
D톈x)B7��Q�!톸̞����n���Ḇ`	��3v�j��П ���X7�Y�ȟ���9�:"j7�<���nB�!�H@�n��uC �S�S/�ܧeD��uF�99�G�n/���m�����:!�RS�dޚІ.�[��R��|�m<�B@�fwr!��+�D[P�%i% ����;�,w�c#5}�:w�+7*빔x�;W����U�Yv�y�>pG=e��s�aL�/���1�jӌ��6�|U;���cRi6���'G���iG��e�yn�����~���	��
��|%y�#�� �n���E? ��,���j��ሞ���<��hD+��e78�y[@�c�[< �ynv �-��1���.�Hg[@���p(\[ ���t��D����
�FR�(ZI��ph&%~�¡���
��R�(ZJ��ph*%~�¡���
��R�P88�$�
�!�� 8.��P�d�!2) �Ȥ| "��p�L�|8�\I�!2y���܇���������������l�!29 ���-�����-'����J�G�<��H�W�9ffj�3��R_L-�VEH�}'��`;���N|v;����gW�+��%=��g#_ �#�O��������hk�XlhKv>ڒ�məφ���gC[r��U�)�AA`�N׼0X��5���tku�R�&r��m�]lΗ��2����G��ݏ��׊�?H}?S��[�ZA�<��-�"U@&UA�mT�O���Ȥ�Ƥ:�Τ&P��A]kS]���֩��0~�R����P�ZA�D�@�$0��&&�$ʤB�$2��&1&�$ΤB�$1��&Yi�������۠�Ļ�T�ו�zŅ:I�r�OR�\Tn�.���B�T�\�F.J���B�Թ\�����e�9m�|�:Uw�ʽm�.u�3G�z]	�M��4��ګm��fɪ��.	��'�y�3�Frǝ�Rսx���/��zay�v:�7����;��=�/�3�~^�t���H��"��2D���g�e�*�\�!P%��vF�J��N�k e]fK�����4-���엲�ЭlJp��= �Pv���.v ���#�^�pD���Bhp��R�pL��>u�Q)��$5�ᆰC*���S0�,����@锗�q��c�x��U�О��W�@{"Ё¤(L�!Ё�b7:P4e:{#Ё¼�~� ��R���((��.D:�i0:�F����������y݋����~8O#43K7�i�n���!0�uC`~e��<ʩ��F��Нw�x������Q�rgިv㸯?=pe�{��u��ue׏P'��%̲����g��[!R�[
�)T�M4eR�J�"���fL*.�3���h�G�9�RV��~�ƻo�9aq�o
d6��G��q ((e�@|X?��$���I]�'+C3�4�X4�m���@��IԐ�����5���`�h���B܆���f�l�$껁�2�=2=,`Kہ�d@�m䙘���v �����X\�l�޻���⾤�׷J�:�4L*^0&�+����#��%͝IŒ�I������^J|0�J|K����I7r�>��g6_^߾�鄀���?~��!W^�TȕW"5A�R`R!WI�T�UR&r�"��)��I�H&gR!�)Ѩh�ږ�q���|	�t>�txD�aZ=�~z���'�\Lm�xg�\LmTxg���K������#�����$��H����V/�<2�*�	�Ҏ����g�11�s�Ƽ��?�3]�;4�V>��esH��6�>��6Wn-!�e伭2�v�����Q�_ ����hƑ���8/���0=�L��ȃ?x��#��GA�i}~գE��Sa�^?J�Ӧ>î�����<������T��O�y�J�����`[�q�L��;�Un����!�l�R�!��Qj7"�5tC �T�q����+����R�n��ջ!`F����cX�ү%��L�Z�!�|�ջ;#`*���;#`ѷu�;#`��E�;#`����".�yX;�Ì�a^��4غE��G�\�P:݅�� [�|�r���]�&�;TtA���j���b�I膀��vC@�$vB�P�#��)�|y��	C��N�ӧ��:8��M��A�6����g$\�a��+�DG����T��R�2�t�-��qH�)���9}���`^����.Ncf�9?f6{|��������NLߺ�W����0Ary~S����c��e�)�>5?5Cy�6ׯ�´�G�R-��0����0�4�"E��T�;�>�=7�ØW�0�r�0�<��W�aL�F��X�S�(Sw��<	u�a$���~����?:	u     