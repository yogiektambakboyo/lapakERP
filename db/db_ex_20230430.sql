PGDMP                          {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
    pgagent          postgres    false    333   5m      �          0    34498 
   pga_joblog 
   TABLE DATA           X   COPY pgagent.pga_joblog (jlgid, jlgjobid, jlgstatus, jlgstart, jlgduration) FROM stdin;
    pgagent          postgres    false    335   Rm      �          0    34427    pga_jobstep 
   TABLE DATA           �   COPY pgagent.pga_jobstep (jstid, jstjobid, jstname, jstdesc, jstenabled, jstkind, jstcode, jstconnstr, jstdbname, jstonerror, jscnextrun) FROM stdin;
    pgagent          postgres    false    329   �m      �          0    34515    pga_jobsteplog 
   TABLE DATA           |   COPY pgagent.pga_jobsteplog (jslid, jsljlgid, jsljstid, jslstatus, jslresult, jslstart, jslduration, jsloutput) FROM stdin;
    pgagent          postgres    false    337   �n      5          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    206   �o      7          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    208   bp      �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    297   �q      �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    309   r      9          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    210   �      ;          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    212   ��      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    307   b�      �          0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    313   �      =          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    214   ��      ?          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    216   &�      A          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at) FROM stdin;
    public          postgres    false    218   C�      �          0    34018    invoice_detail_log 
   TABLE DATA             COPY public.invoice_detail_log (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, created_at_insert) FROM stdin;
    public          postgres    false    322   ɷ      �          0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    319   Q      B          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    219   ��      D          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    221   Bk      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    299   �k      F          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    223   �k      H          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    225   �p      I          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    226   �p      J          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    227   �q      K          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    228   �q      M          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    230   �q      N          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    231   r      O          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    232   :s      Q          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    234   n�      R          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    235   +�      T          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    237   ��      �          0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    316   �      �          0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    318   Q�      V          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    239   V�      W          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    240   ��      Y          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    242   ��      [          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    244   �      ]          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    246   ��      _          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   M�      `          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    249   i�      a          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    250   ;�      b          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    251   ��      c          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    252   	      d          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    253   l      �          0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    314   �      e          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    254   �      g          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    256   �      h          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    257   y$      j          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    259   �$      l          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    261   m%      o          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    264   .      p          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    265   �.      r          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    267   �/      s          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    268   0      u          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    270   �0      v          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    271   �0      x          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    273   �0      y          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    274   49      �          0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    301   �9      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    303   �9      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   :      �          0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    311   7:      {          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   T:      }          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    278   @<      ~          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    279   �<                0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    280   =      �          0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    321   �=      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   L:      m          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    262   �:      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    284   *<      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    285   lD      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    286   �E      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    289   �E      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    291   9G      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   VG      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    294   sG      �           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    207            �           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    209            �           0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    296            �           0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    308            �           0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    211            �           0    0    customers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.customers_id_seq', 1423, true);
          public          postgres    false    213            �           0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    306            �           0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    312            �           0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    215            �           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    217            �           0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 1916, true);
          public          postgres    false    220            �           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    222            �           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    224            �           0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    229            �           0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2209, true);
          public          postgres    false    233            �           0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 515, true);
          public          postgres    false    236            �           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    238            �           0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 391, true);
          public          postgres    false    317            �           0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 53, true);
          public          postgres    false    315            �           0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    241            �           0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    243            �           0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 22, true);
          public          postgres    false    245            �           0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 52, true);
          public          postgres    false    247            �           0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 338, true);
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
          public          postgres    false    281                       0    0    stock_log_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stock_log_id_seq', 5241, true);
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
�      �      x������ � �      �   v   x���1�0����+n�����4�Qtur,H�b�-���}����z�>������r���։!�J
���ʀKv�(�u��?:�����]��E�TPwKn9�}-��a�!�7��#9      �   `   x�3�4�t-K-�TpI�T00�20��,�4202�50�5�T00�#ms������!A�B���tH�%$��kQm&�\��$��'�6��+F��� G7b�      �      x������ � �      �   p   x�m�1
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
��f����� �� TYp�M��^�t�4KR������f	�HK����E�ׅ}���p7�C߽�^�o���w_Ǘ��~���]�~�i߹�o|��Є?������C���v?���[HĲ�ލﮮ�'�ڸ��K����ѫb�w�������P=��&���%��!,=����O��g���-f`�1�o�_���֪� 8Bx��K�C�|^�OA������3\��i�M���! 1��g�pi�g������~�&�j�����L �0� ]xy���R^�ɩ@�q���:��kUAލ��s�,�'w��Y����f?~�>���1-����ϛ��K���nh�O��p}qvB��[UC �>�=R���B����~{���O~�YC��nv���Ç�ܓ�!��ǋKq���dO� ������h��~8�!���w�G0=�V���~��xyk6Y�v�'?i A˻C#B���!������Wy ߳| �!�ygx�y2�i?ިB�}>�.Y�͇���n�!�i[x5��.��ClT!HV?0YK�N4�BЖ����6b�� �+��ޏ��nڌ�B@�������w�z_l�B����a��D��k_{�t���!�!n�CX�R�B@�����2@�~�^����as?>_\����|g��������1��ż�'����� �G|���7\�ln�K��jB�������tf���Ǉ/��M���A��N��/bC���jP�����˻?����馧���i�����v���]O��j�݁���z�Hf��雡���{�ZP��DtW�L��A�>E�n�7���:�����xrS�BC���q���:��>4'�IC�_�1Ζ\��UC��w�[�2�������y�"�Pk�y�\x����t>
��!�]�6���sm�Cjݹ�\�8�¥��3�m�����T��#ծ:S���IC��09��|4�0CS¾�M���4�m򧞋�N���Ta�����vq�����Kܙ��ɿ�>����vXiP5��Â��y�
&�ט@�!0Q�q�s��a�`B~�oӬ!0��v���:����oJ�=N���ZC`�����ߛ�>��-���L��j_y�<ގ�7�W�=w��5��/Ke��x���ֹ҇�M2[�K�j�P.wo������������C�u ar�ݴHBwf��3��A,�Vq%��h�5�N�כ�. gk��ҩD�@�tuӿ}��tƭM��Ԩ�:���N��kCZ�A�t�]z1� �V�@O��m�i�r������5�}���>^�04ݐ�WF���r�6kLo�%;��w�1��3��*eApg�:ô�9�)X�h�z�hyM�p�����%��jB�+���4L�N� N��=?^>�GJ��Ub`�i�^�Hj�`���V:�l-	��A�F�}?��!����}I����0<��z�Vk��Oo�W��<UC<�ɉ��0|��ד5��o޸ěm��#/�k���Ŵ<���Y�x��5,D�M[ZU� ����?�:G� ����m|ؾ�|�?����?�/c�χqK'�8m�i˽��]N-��@�U�j�=m󻙱�����6o�޿����������V��{���{>�n�?m��_�%\�L�i'��������J��<�ׇ�"�ǃ[�&�ԟ�TBCa��5W�� ��ݿ�7��RN�7�A�\o%ɻ��:����B�C3���A �!����"�Wj�������)g8�2�A䅷����s2�mp��G3�hO�X��h����v��G��\�Ay�����Œ�A��i}���3 �KI���i�>}2?��RjH���������t��A�2��8v2x)5�#�˽:�HjN� ���ݎ�|aBisp?�����B��s��-�S5�:y�Ϸ�;�S�[J�jG|��O����������$�.��Q�HR&���;H'oa����A�?�S5�� ��/;���5�������׿��Ͽ�j#q94��A$C&����w+�U5d�n�����Q�@\����c�yl$>��m�� �_2��e��L��8��9'�XQZ��Q����|cŘ>k��A�O����YM�kyB�A$9��~�j���z�T }�Ք9Bu���3ǽ�#}hN8H�8(&�����ѡ-�R���$�9��A �M���r� �ڋ!��y|�؟H��R�@��7�m;�dv�� ����0��� J���X�ul���SB�0ȟ~9<�ͯn��4���G��#Gt�/kGϡ�/��w�XǦ�k9p�A��;���l���RC8:>�?N��Iq�	v��UWq�
Gs�����|�tU�_h�im^�A^yK� /���'��he"�� ڙ��v�A� ��>�/6������aX�@ȏ���7�g�\X��!��"��x-4a���� 8y�*5�����iqT:jA�������b�?u�A�47���0�5�?�W5� ���F�<�5��N�㛭�ؚ���Q5��\�K�ø���GeQ�S^k�k�#+Gz]��q��\�Ѿ� j⠳�WC,c�Iͪq���r0;�L�'�ZC8�8������M��Rk�͇��y�f&NW���
���^>��F����5���Ӹ��fV�� ]kH��a�+��5�5�\�Ն���Hr�@R5��-�Ji�����[�Aݱ��ȑD<�� ��$'��8^���Q���ݐӐ�W5��s�~{g�p��ŝ5�í�p��1kGN��l�m������oȣ����
�c+�Z�8"������IN*k��O���ѵi���9���k���|�2ۜ�o��٬A'���H��A�_5�#bՕ�� ޯ�J:��ay��5��5ǐ���D�����P��PU�Ph�z3�s�[�HM�N�	��r��b����_kJ�n���(C`{C��A� �4�xߪE���۽�Am� >��Y�hor�'�AW�|}#3[��&�� �F�����̉�����"���
O�scy%��b�J�p�~�FgH�5��� ڋR��7��G{~y��5�!��n���� j�jb�jW!�D��6{�!�҄^�jBh�<��Z�]k��χ��d^K�k" ���a<�.TB���aXD�����M{�Nۗ�`�qжr%���	���ռ�9�̍/��A���tV��MJ<��`e�thy����͆�C.4��6�'�r����q�a=�j��6�k?�Z�@ȇ~��+�P]dB!g��t���Ȟ˘�(�t1�g6���tA�D�wv�d~&9�m�dY�@���A� .�.��F���5�����{H_���� ���'�/'���eX�@ȷ~>|��2��Ԟ~pX�HZ� _�����4M>Q�#J�)�����]o���QO�^N6I������o�_��xM��5�c��#�f-V3}j�Hſ�ܬ�����@3G����A�{�{|M|_z$�jI�5m�Ձ_hy؏��~�d�
���Ub�Ip�S�͛�V� ���7�@|P5�\�xu}��z6�/�� �A ������<G��5ɸ� ޽nv��$��wC���A��?�n��ӿ�U��$�A$�����a��_&¿L)o2T�����.�#�q�g]��-�гq�c��[�+��r�h�A�O7?]�!���/C�pI��[m:gk)}8�A|c�v����n�5�5�|����B0,�ųp���[C��\�����EL��ş![��h�Q�8��\��6�����T�]�e��:��� ���`�25���6���y�Y��r����ɆGk�J�D�q��	!U�B��c��e�B�A�'��`@	�׫���=%`"x�T�LП�� _6�� �ڤW5�[7?]�.�@��OD/�fek�����L�zDP��/���v�7Q� �����.?�<��Q5���nS'�x    ��}�1��I������&Ü��^g �D3�o�Z$��y�_��0��vSBC`���4ђ�C�R��T��u���c;��=j�ah�p�%UI4B�Xh����:����Y,a�y�A�Q�7m�.䷑��y�PX��Ц��>gk�.tDP�כ7���*�NhBk��,�B�ȯnL��rm�k{�Z�0�ヰs�#�� ��fي=f��Q5 $pUx^ҩRʒ���X�lt�5ė���2mO�iGxw�b���AD^�-��������Hss$�%U��� �tw0]��n����A�͕�Q5���������Dh��=+,��g�Ӂ%&UCP�����׀��:mEh�[Q�:�<Y��A�'��j����a���0��uNhI���$a����$s{��hގ.	k9�͕)�m�����A%:�}2nDr����sB�H�w�[C���X�"
� �:�]��C��_��YC@�Pi���;�t҃!��Ke����)���.[ZIR�	"�8jJ��.�ˉ"��8��U�P���o�v�^�OUB���ٴ�s�M�tL͙��P�� ����AGk]u�D��i�<�i}�qpMD��A4�R>x.LH����RWmӄ!����a�6u�S�y�w{�j�
���Pq�����~��m��f�)��j�ݧ�j�G�']���T}��!�5�6:T1F�A i�t�I�&��t"����E�;�.w�a��T*4&{�\~]uD��Hw�<�2�P��b��ћ�V��k��u��b"�宫n��!����V��Vc��DBI�+I��Xh	tڨWYg8��w��A��O�}|Ӷ���'(�vW�	��{�ޜ��t�V�bu� ���ssڇ|6�[�;U�LS����h�}VkF*����B�0���fo	H���sq���q�o}xܛ��b�4��P*��x�o���%N2�)4��"{5�:}m���Ԟ��Dy4mU?(4�(5%�S�h��$���m7t��j�!4����ۧ;�YK���E�j��?s�)���r�O%�Fv����ej+O,4��S	�4_�>�!���&夒�"!b�䭽��0�TY�,4����;�ʰ�fP5��㷛��K�J��[�T�A hXG�W�B�H�hj�ގ4�Ѐ�&���uS4$�CQ�I6���D�I�����*q�g4�×v�vW��J&��%7���T|]�@(���`��b��u�|�A������n�%4��囨�7�KK
eD]h�ԧ5���p���W��yp~C�k�4�\�ts�9T�R�!6Y���6��An�f�ǔ�D��TB�����
����5�#X�Am��y�A����9�s`�,\�A�Sm�m&�az7Ǌ�q��`
��U��� ��I�e�Qj��jH?��i+ջ�um��1�����y8��4O�R��4���]P���z�K��������:Z���AP���|m��� O yJ��˰���"�U��a[���l{�A<h�Ʋ�&���U��N���f���p��$x�ַ+�F���櫻�A�4{5����m˞�/IX�H8jk�ar���"4�.���s��N��!<pj�A�f��2�qp����-=fӠjGր��
�	������i�h���� .���S@�W5�#3>L9wl�W�.�A(��/��o]6X7�q�ק��Vg���:5������c�lơ�U#4�c�I�_MW�d4�.W*k Hl(:�[�B��z�	� �zm+B`���ua����M�4�Y�E�����6�g3�PeI	"�~+H�{U�HGԦ�%@�V��JB�H��^IF��4�A �HY�8��˜d�V�*�*4�dX��>[u^�G��z����aq�;jg��T ���q�h��!��U9JB�@�T�'�&��e��?�h/��8S@n�]�Ĕ��4{�����L_�AH�ˋmX[Wf��� �/����N�!b�viB� �&a�0>�X���B�y�l�1�Ѿ
s
ʪ]A����Dh���.S�DGm�]u,4ĭ���
� �G[���v�XhHS5!�.�Ȭ�s0��PL���ikti4{�d�|��׎zV_�Մ��+
��f�"�B�8ؽ�Jg@Z側�)IX��86�W�g�����)߇�Ʀ�q
!	͚{���"u�Ew���x�e�O�Fc��&4�}�v�X\:J��%")e\��#6�/ɬA qMZiG�J�rs4k�֭m����QKhG[j�,�g��Wa�A�٪L#�O�Am�^�Znl�h�G	a�z�h�~`�u�*�! \�u?��W�"�(4���:����D�Wې���j��5��}���!4�t9��U�@"��\�bzl4T�iB�@ث��ގr���A�U￘�5t��p����,m���ᨡ��A<,`c�]Jk�F� �����
��� +�N��jOǀ>��Z�Ѫ��y����������5��>�2����rP5����f?�_�IB��"4��<��t���vs_�^� ʵZ�/EG)s��ݜ�O]*kGϭVw��dtڄ�Q����S�c��d�ب5���b-�5l3Wը���<#�-�ǬAt{�y��Y&yu%��5$p��u ��A q=H��5�����W�/[�
��y�v����1W����&ă�A<�eG����qp��5D�Yf~�@XC8�2���y�n�e����=m�w�jU� x��-;��æ��A |�_G�U�m�A$Q�������������昨Җп)"CFsF�W5�+m�v��־t��#����>���t�b�CՎJhGT׀���a�Ygڗ�i��� :��~�Z�$�hW�	ዪu$C��GhI(�^�"��J�W�x�ͺ��� �Tn�M�gd4խ��PH���;�]X�0�ҐҺ@Z������[m7�l4T��A �]�1��c�q���2�& ��Ԓ�iU"�*kl���b.W	k��޲jg'$��zU�@�[=�Β��� ���j�d�а�Xe["I��)��F�rG2kH˥;�h 6�U��A �]W��fy��5�����y���jY���}:|�n���� �i�\7��&u�����u|9�9Ra�QlL��l��"$B�@���i�{6^��\"٪D�����h%�đ���T�IVsӠj	�����;S>/���d� ��>Zn�z���aP�uFP0��D��Z���h�c=�U���S"~_�8�竣AP0��z��� ���Q�8��ђ�ؗ��ڃ5�����'��d��VY�b�U)MB�8���*���5��]�Qυ���͑"��p��A �Mׂԧ���%�gGlT���Z7�qgJ':ZmU"Y7Qk�z�ZY�H�M��K�{�U"	���&C&Y	"�k:*�F�=�� ެn>Z~���	�h��M~����D�q��Ɋ��jR�� �y�����2�m�-����U]5>KhH)�ZK"�F����q�2>,O��p(��֐���j{$4��Ym	�QyB�uc:N�9-1<��1q���a��v�:���oN@{��2:k=�O����u���usT�(c�M{�٦Ls�A���ޖ�MFc�Gh�[=l?Y�|i��ʗ�X�;�M'Ϥ;m%�����&�f��J
�[<���M�2�|oX�P"'�X��d3,�{	�ԓ��,�[��/+k�֧[k|�+�K�� �xx2ͅ�TST"�˝�J�UB!���q�ۘIr�h�j	�κ2��F�r���pp`�:�1���~� �r�DKf�.������ II8H�;9�9b�[ChG��e�3�Z�šb� v��	͔�3�{M׫�RB+�b:�� �����͸| �1�x
���㝙#,|��pp�գ�Vo(��MR5�����#*�#«���ƽq��;<_EÅ��M��z0�� ��O�R{5��z}5��\�!l�yU�8����T�?��
�3k���'�    �`���A�-p|��0�1�		��������[R���5���`����7�5��
Z��*.�
'�#�g����>�coϐ�Ɋ��p��Z�T")a ӥ�L��Pu� ��bjw2�Eb��8j	E��|�ap�k�e@>:��B�8�r���TR�P࣑����m�!ȷUjB�Vٍ^&h�'Vj�J���U�5�A ���w��᪾R� ���1!��ġ	R_� n�g��ʋ�A<`�?\|t&II� ��ܴ[B��(M�mt����t9�y�R�8�g�ǝ�z�h4xU�@��X�Q���F�b���U�8J��nk����9�D��O�dٛ�^fSI")������h�u�R�@إ,�D��v�ώ�QZV�t�g���ՈR�@J2�J��k	yֻ��ɒ%����׈����b%J������R��6�-�S5��m����l�D=����A(n��Z�ҫ���irb6�>��T!�;��-ME�f������GK��h24�a��*������l��_����e�����h�yU�P�2���s���\5�SjA_R/���|��5����s>N\$p�ABh�#��e<�zY;,5���N��.����Z`"����'�B�Qf(IB�c��i-��S]�ʴ��|�"5���.��\�;q�Y�ڲ."t�h���A|e�y���ܱV\�H"`߸�ZR�	DP.���ᛥ�4�r�+v��R��h�~���ȡ�R�@������*�(�Ab�A$%��R�r4*7�B�@h�ye�Pl�2�Gj�Ε N�n�R�������r���5��Vr8�} ����ԙ�X���Uh	�J�l�c�����P�Z�z~��М͇N��{7�Ӝ ���@�mI�  ����<)D.�C�a�9*Q���$b"� Q�������vLB���gl��K}?��md>�� ��i�'��n�	͙��|�AD�٩"�#��C� �<ȳ�`�qӈ���B�����M�C5^jR���1����ĵ���������%�r~����"EhS�d�{u��\74�o�<���Q5���X���eP��ѶW5��1V�zS��v�ۨQ���;6kg_i^Ȼ�b߷�'�Q.�⧚5(�8PX|ώD�z���R�]�L�1�@y��A@��z��V֐�~z�>�D���%U���Q�=>�Z%�E������s��O�k�p��������}���5��c������~����U]t.�_l����)U' �AH���|xت��C��V��g�N&AJ�"����u�Jn:�M�z�0
M�A� "r�?NԫDD>�e�e���t!�]�~�i��5�����^���Jj���9�<�Q5����}��OT>�i�n "u��T��ޢ20-��AL����d�cs�hy����)��a��:R(0��T�r����.t�y�kSS�Щ��ި�J]�O��ܰZE�=��AH\.�����|iq���A�K__�76�i�߫����l~P5)���e
��ALI0���%����Y�h��Mw�i}��e�S�a�jǨ�(�"R����Z��4!�i��;�y�ᝪAHe�׏���u�<�CE�N���H_ۃQ~��Z�fE�:��.�{G����-�m�Z.D{9h�/�76��W��]CyU��x¢V}�cW��$�J�������b4i1Zg�I|C�W�>M/Y��阯-�+�ߎ�1�%1�Ew��6��i(����v� &�^�q�8�����0z��^;U�J�N� �co�D��!M���S�3v��0͓�~i��X���_�Gm#��e}�:]H�}N��� �ADs�0�3뚡m��7-�]G��DD��#e�k�,�f��(G&�#�� ��e>ZH$�.��O�7Yϟ�%kQz#)�>lm�*D��$�5��"gF�`�r� ���[a�T"�`�V��^摛Z�A<�<��̮6L�\:ݍ���ՒYfB��8�.zPZ~y��0�9�(��e�I�!L4�L����קu�OC}d���B����!����zߝF�z�2T"��ȳXw�59�F��:/�Dn{���
�.��^P5�(rK��n�OO0��u�j\�� "�Q����AD-O%�t�c���"kB�8�Q?�n���R�PZ˟����g<<��J�\��X]���<��6���vB�v��D�9;s5DiN~ڝ�K8��b�1k�h� (��OgѴ��E�A@��Y�*�rd/��T�h��7�Dx\��i�����X!�?ľʖD��z��� 2�/�\������R���������U�� ����M�l3U�B�8�zoT��]��ݡS�d=oP�O�5���P�΀���^h�P2����ݴQ=s,���r��9r��z�{�lڶS7b��^� $�ִ�Ԧ4L�U����wU�� &_�B���wI��#۹�A�jO�vv�n��f�\:��s��}�1�NC�9J��U"��j*��n);jG��Iw���U���?��6�[����ꍥf"�D��)��3���O��]![���B���������M�7}ן�@2=��F�O^�����ۦi��_,�F듅�  w�(j �I� "�����7 ��U�AH���O�3i��X�	∥g��������U5��"�/���(��N�!&U�@:n�tm
[D��5�FTh�-Ƈo�\
��ϫ�OȩQ�Q5��l�MU�"&�:-���ݣ�E[,)�bږ� �|a��)�1TW�B�08tl�]&����*5����ip��ѽA� ��-Q>o��A0�l<}$�A(sF���OFS���jmv��oz�L?}��k�H�h����qŗ%NKrU�T���bU�^hưc��.>ó�`pY��Ғ���x� �ˎ/3F\~�g��ʒ��Pt6��뼪A \P�
$V�b���c��U=��V1(�A(�'�����KJ�.RzT}�+4���S\�m��I�A\�}�E�}N��}�R9F���ab������˟F�c��4մ8�AD������|wz�D�]ݦHh��m�l� n6S�ڏ��{�ݳe�A6���H��=j���F_��q��A���n3�ب�&�I������m�*�IhG�4;�"�Zh��{[+�D��ChGo�W�O"]U�/4��>m��iU�!\��d�ي�Ð�-�!$\��tؿ�n�$h��Fh
hף����k����J�+���z�n�̧:�]hR��������A �eׂ�� ���pc��%���Wh� ��>�� �O���A �gW������S5u��&�B�8�y��|��h��~�ݶD�؅��V���G��
�_f� �Ѷ�0�TR.]P5�f��A���#4N� ��x�~�R�s�zU�8����p�EgYV
bi���ƧB��S�j	{�q7�N�$�>"��>�t���$�ث�����E�w͋��!\��m{g]"=��5��������t	:�DB�u��Α���B�8ȵn>=�ߎT ���Q��I�P���P.����?��8j'�~|��Nt�<aP5��k���q�l\��o��A0�X�äŚ=j�����
��*LBi7�1���P���gh�b)��߾U�W��I��1���$2Mg�y<c�jH(�^n�$�?@U�$4��[�|�7���V�;TdB�Xh#{�S������n�#4��+�������kRsK"��Q�DD�wcʼ&��Q\�
� ��CF��aP��t����4�]��� =�~STu��H�T 8�
�P�Մapr��>�l����qpn����gIhe�d�[��B7j2FhgĮ��q�6����bo�=f�(�r�J$��|B�@�ұ|H���
���颞mօ=BC8�.l��mE��H�w����u���X�0!M|�j�?^UIXnZ��p���-�-=$�A� �X"��PVK��}u�(4��Z�ЪBZ��n�G��u�T����W�{�NBU�,4���v��Dv    ��61B�8�Ըo��GFS�
���pu�:���jB��\�`�ޖ٪�W5��|���n����/C.dT��/��AH������eI�jI\���j�j	�>�>V�z��3�fJ��܋��A(\��h���A�U��� ʇ��f��;�z
���nk
d��PW�
"��c*�iKNlT��vK�S�낏NҖl���`� $��oM�dt��4I� �������o�|���}7�����A,!�����l�p�H�A�π��S�Y�
�H�����c�a�$�r�����׿��+�t�q��A�����A�[��u��O�<jI)���?��� �! \ҵ���ׅ��V��$����G�D�K��3�mv���Q�8(H��c1��]�A�����A��M#�\�UE
�IS�AH�ϰs]��(��]��*o���������?+��|��S����勜fZ.A� ��g��l�LD2�����A(=ߺ�=l��}w(_ru�q�v:�Y��7�BC@ϙ�h�S �1VQI�A ܷ�S�1����	"����v��ѕ[}^R��Mg��t���e�A ���:�^� ��3�2�\�KhHi���c��f����O��������o�D��ԓr��BtM�k���*� 4���m-bl�N����^�^.�D��<�I�e��߉5���~gi`Z|gb������J�\Y!!4�#�ӀR��C�8�z��$Y�uF�� �X��^�ݧ��hv9n��፪AD�|f�Α�{U�8x���T0�L^� �0�yT�Oyq;���>e�AhR_ʝ������N��yKB����m�f�J�^�T��M�u��Hw�At����U�8���8����}O���U�kL�T `�5��+��4�����ku����'�t_%딯�jo}�2�\s�]l��·����\�o�>�Ai~O �"�AP=W���l�[�P��3�^M����Pm�D����`�U[*�]L�2^����X��������>�.��!�tG�3@P5�ȗF�ڇр�$��%dۏ��~��,D4w?�iz׽�h��O���|F�AD\���5y7-��e�N?��t"����-%��Q�Es�A ]���]��%W��	"��Ǖހ:O��.�Ӑ}O��n�C�D��YOʹ��ͨ����~Tk�-L��AL�xR��t��T����p�[��>�C�n�9=jǄ�ʝ<e0��Q���y^ՠjQq�W���ds�f5N� n�x����²>������0�{T�?�^=*�ƻ��Ш{�|���e�q����W7��kR�o/�����w)�I��Ҳ�Ih�P���#N_�i���b��ȣ����HVݔKh�a[�o���p��1�{7za����A���Of���� �A \�{7��y���Y�j	����z��3(ub�� ���AA���V�j%@<����엧�Y�8z��j�h����[U�@(��$UC@�>m7����f��O�Q�8�`SF���j�՟67���#�B�je��䨿3G�=�ˣzu⺡w�k�@äB�ē�\��x:U�x�|⏏{�\���M�j	P�O�l���"�B�q��F
����^�A<����J~�_r���7��w{g*T#��'���B�H�ܿ����B�8���޴U#�1-�ޣq�`�@�٨�U������#���5�#q��
��jd'4��6���흍Ó��qtg��t�bK�a�&5v�T��	� �zc+ a��ҡ����l
A9왃!��Aŝ�9Y�B�8|郹1�0�BCK� ������GS/[2���B�P�����Cu��A����W*�<������7�밡4X���Aw�~6�$�h�pF�@z��Y_޸<a	�P�J��(4�#6s᳕#���Ae�͙I�C�^�Ө�P:q/���\��.�$5U�Yh�^��绦�N��%��y�RX��xÏ9�jQ*�y-ILI��q��A �mm�f�^� �n-F�<f��ѯ�Yr�q�j�<�&�06nPh�h�\"�!,�Y��O��d�5����9NtAݪ�Q����INǫ��q�m���U�h�A���X��9�\�{�(.uG��&��1�Ɏ9>t���+3 �|c��6U�P���N��T��jA��b ��Y� �zx�L0�o]C��lI�'�7��>X�X����h��PJ�>�����WQ�1����9�h�FJ���2B���!�ۼ{Tn'�Z�NI�J!,"GB*���dM�5@9
�)�j��zգw]�}��L'��Q��:�^��H��AH�2�rК.N{��;ܩH!V��B��8_�ZMl�����GA���,m�W�@]�i�,��3���5��I8/֓{�/U��� ��8�RW���"����6�,/:�	�)��Ղ7�������|K�3ג�A@��[?BT��J"j���L���r��$��z�A��0/5�����5��>6Zk6�[�1EjR� u�N]j{�gG(�!L<��z�I`�ۮkb<ر�ܿx��X���M�8�W��o~��B"���}7w�v��R+���D��i�R���kM�Բ���_n>��D����_�ţ����e��\q�A ��~�������D���ϝ�W����� �4�o,/6���+�A �	[b��fu���Q���,�T�	�RZ��n_��a�ɞ5���|� �C�ȸ�� ��kn~�����#O��5�#f�������l����A �6�?�����044>ZMN� j������wG�e�>��ѽ���������nh$|4��A =����ߌ 1���N� �a=���I����i��?����5.WʦY��fcq��������?�A�ߕ�RZ7R���B�����n����槒��U�H�����/��WJ�ћ^�0r��������ʒ�A�0���_�����qv�W5����_�E��{�e�A;�a,� C�|6�R/�^�0n�h*�d��V���J��z��s�Z�k	�=l��vP:K���a,��eZ�RM���B9bצ��h�|�g�%X{$9���=��iu��+��0&�m�q�N�0����Z���h��+5���ց,��a ��0��-T�8��FB��Ƃ�W���5���=o�_�!ǵ���a e ���d2�慎Ŧ�a(�v�?L%�l6_�%U�P���w3GC�?�[U�P8ql�_8��������d{�=�5��G)cz���$5��tw��h�j/[�I#�gIZj��j����r9f���7�FR
 �����>|8�a(��<?���ߔs��L�t�YԻ|�]�H�
D����T����(�aLY������p%���	cI�|~�������*�_j
�pגԋ�a$�c�j�t�T5��F��c+P�sU�P���6��P)�>�ԝ6kg �sW5��>�{K��l��|���>j�<�g��R����ݣi v6r������2��ў�]�P���l5zU�H����x��I�U�W!�a$m�ȶ��5�J���%R�P����f4���V#�JT#
���+�S�� ��$�_&K���ezU�H��"�t a������;^��v�a	��F��B��S�j�nǽ�d���d�a,�e?�N;������wM;$w���>�dWf�aD�m)TBÐ8�1�Q����0��9�p��'��a�)M�woV%���Ww�B���^���?���r�O�)FjC[��|��h�ث{��18.)}8L���Uo8�a������h@�б�0�����$�)�.�M.�&���z���T�(�i����W#�Ȝ�jDɠ���^"�<��|�a�6���e�"��`#�����1���N�0Ι}~�,���h��Ub(�dyEܿY��c��r�F᎗���h��a<��ڀ��hU��YRi��	}�L�LR�ǖ�e��a4��o���� 4�v��� �KMu���Ο�"��    ��NǯӾ�3��'��q��骠��0����![�@�Q�S5��',��.�f:��
�ߐ�jL�<�t�Ű�jOw4��a|��8m7.���d�a��c��|��7�a �K �j�%7��UUh
��oM�)l�]�����$Hg��%�~X�F�r�ͳ)#*��F©YO�K�2����U#�>^�{K3�b���v�����|�j*b�v=����A,����vڒ�ԝ��H�$��<R�`h��q��)&ҥ��ጆ�r���t�hK&]��A�����n{)��&��R�0������e�C���O����pK�0��Q��v�b�R҄�1t�r�.l#�86K�Y��|�_��Rht�(�|��]�����!n�����U�^��p��1�����<_����P:U� 蔿}z��vzʰ�5!�Ѡ&��
Ih��w��'�z�e
'=8ib`Oi��{��jD[ v7�?��ź���0
�F2� ƹ�x�v��q����4�#͑�*/Ih��7�wv��t�����$���.s��mJ���8��6m�Ir��W5��7���)�ޫFJ�V3H�ڨ»ϛ�eoF��U5����GSp���;�^�0�ve�*'rU�H�r*����o�e���a<��qz�'�e����FB��6?^��U��A�LA��7��l�SK����u��f�l#���B�H(djK�"�!.�5��q�q]�� ��a��@����� �u�0��L	�d4���h�0��4�����M�nх��t����"u�0r���f�܍lP5�6���Ll3�El�A<��V��6�"Zj���e�B6��L������ޒ���<���x����4�t������Qh��_��ڤ	�H< ����J�'�,IX�HZ�5}��hrU4[h��L� �Y��(���0���oM�.Ȩ�[m�a 7��?��V�B�@��M����S5��۳����7���zP5�$�~zo�T6쫚�a0x�}�S	�˫\�a ��]R������`9p���ɖ(�a(�k{k*sHԒ��B�B�@�͎�۟�/O�w�qP5������#���Ch��>oL5�d6�}���p����&�)Ta`�a 4�kc��Hs�V�jE���D�U�@x{x6�0R�����f�0�XZ1[wl����Ǚ5�����$�^�0��7l�R]6�-w'���p��)�J����q�v�(�b9T�q�a4ú2����-�����(��Z]lGo��a �b?����\�1�T3ߤ����w4�F�ծ�%F��qI�j	mcӉ�NR��F��}ɨ󪆁��|�YCr���e<�+�֒x]�Hʬo��l4��ewW�6���T")5V_��g�;S,�ɬa$\��X�A踧jH�b�>��A�0np���LM��j�tI#��V+A�Y�@�]�����?�ji�@vs�x�jK[������+P������2�௶���uI�0�>�BkI��j	O'����2�Z���A$}C��~�����ʬa<���_��w�P���;�xz&�P�e�q�0���߿�8�S�b?}�0����_�.yl�[�:G#�ց�P95Wj
{�}7�{O���G�a$�d��_�i[�lu�Pf#�}��ȭf.�����W�Mhel��v���-�6e��� ��z�ﯟ�(�KW�0���[Ss��"9�a$���ɾTr����a	����t8n������B�H(^��J��d7�*4+4����o�of����0�����Z��Y����t?����a(�k}{��ijU!G�o쏤W~��u<Ul�{{r]��B9ۇ��
��>Ph{�5 ��OB^v�����2P��T!'�
��}	I��cJrhK5_hT)1ٽ%Ϗ��:�Zh'��:˷���ޛ5�_�O�³��PD67�1r�:
*4���km�ߌ a9XYh�_�6O�+I���N-B�H|IJ�;�B�Uc	e�hJ�o)h�1U�P8�`|ޛ�G���a(t�u��7�H"�1T	BB�HZ�鞞�� ���h
]{=���-l�r]�j	9ٗ��x=���>����kHrՒ�5��giMgѭ%����z
��0���?�2bZ*�KK�?k��Ԝu$u��a$aE#*2:���Y�@��>o~����TC!'����Q���q�0�)�����^p������?�*F�h.�kT�ׂ�f��f~ ����Oã�֭ę5�6�_m���h�P5����6�Hy��*�a ��=|4r��~�T����@[�Y�@����FK��l5�����Yv�v��a(ܠ`c�u<�
���G)�\����h��	U���0���}�Z��f�^!A_.��l*��m����Uυ^W�-��F��@��a�E^_�������a$��խDTC�8����{Z��:U�PJ��g㎀�z�����x�k�,e6�*���	m`�6�w�Q�A�0��k@�*�MhȺ�kN��O�kH��ؕ$?�~�MR�el�5[
	_K~Š��h������j�{�[A�t#��:�a�9j
����_���'��z�x�0��˖���Iō�a$�v��.'�4��#)�
La6��Q�a �K0~��4ds:�J�&4��+��/���ۭ�T���8�ܱ�8y
d�j��ɐO�/V��W%�B�H����$W��tB�H"ws����j�յ��0���ؚ�w���W�z�a$t׵5}��&eS��A�uG��&B�8Ȼ�S5"��»5����6M['�c�U�H:
<ޘZ����9y$�a ���)�Օ>+ѩ��y�)夣̟:�@h��nM�r2�ꡔB�@�mi	m�*OhHi�e�q�\gi��ޔj�F�j��0�SYsG9.�:��`��`
5vs��F�0����ٮ��nt�ɵ�y"),�٬a sC�e9[m���a$���<A��j߅��N��j]%1��
K�0��m���_��]o�F��)����~���˷g�0��GiRP5���j��ԑ�X�	�W�t�Oo�ṪkH]�)4d`7k�Y�JF�b'=k��:��$Q�y�j9����۷9���f!'��S5�������5������?>YcH9�c�j����p���xk���ّ�V�0���d﷦�2�c��EhJ���HG9n�S�5���FKW��z!�!,�i�Yg�WP����\Ϗ_L�ó�E,i�0�N����f):'��~lB�@8�`g+}���ΡF�s�ց�N�0�|�}�==��	ۍA�0��O�1��f����I���\��ó1j�s�S5����֔oy�ګF2�&źPrT�J�R�u�%�U#!'�i�7���j}�9j	��>��z�Ԫ�B�H(�xgڷ�Ѯ�2;�덥~��~�k�B�ٻ�~k����'U[H�a(-Wߛv�}�Ƒ7�B�H(�h"����Q&v�nS�h����@���ÜT4��OEs�z.*6��,�#�����ԨO`ug.4ĳ/��n��N����a(�L.1œ�j��Eh	tm���7'Р�V�0���O��0YM�:#�ۮ[l��}��"4�o�L�s���ZU�8z~ ���P�BUU&4���a�kS�_O��P����Ԯ��7��-��0�*c�;�ј���0�׶N�=U�֍����pS�����&e	�(IZf�i���a�s�4Znf��b��0���o�e����lTC!��ise&mu�#4��ji����I�0�����3���F�!-��a�U�Y?3=5����qp�m[���.Z�
����fgL�/^�Y�`"jl���դ��́+���@zU�@x�����󞽎5�t 0�h��~��f�yt�����鬟omZU�Xj�;��;f�AAA�GT����t�4�@du�O�5�����&i����a$~�d6Z��)�[�s�S�F9D�h_���*���pC�;c�"��i@:j7�����������Q]?�jf�N!��ຶM�� ��B�@����J�h �  �a�6�0]:��X�y�a ���{|���c����	C)�W[��:7嵣�0����O�:� ��0�Ү�z�`�� ����dac���,�U5��������J�g�&U�H(F�ec*�c�}��Ehmd?[G���'U�P(�:m-��d�wխ�� �����t�E6�E�ڎ�A{Xc�lT������ht�����]�Z�h�q�������/���0�mU�Px��:��V�a(\�ek�AFc}*4����[K������x�0��`Mai6z�)�5d�g_���62�*�EhJρ�U(��~!4��n�n-	�]����Jh	�+�7�����2
����L�Gӥͥ�I�0�c�+g�m�+4�/��wKd5�*+4���k�q3�$�H���p����7�����V�0�'�~s����B�n:�[�IC�c�G�;�χ5Ӽ�R�悪a <����j���ʻB[������c��Gb
ò�v������䍩?Y�@:U�H(;yz[/-6�U	B�P���21�nz�M�5��>ٲ^*��+e�0�h���m.�&��qp-��a6�5$6M����&�ͺF�0nXx3AX#'l�W5�ŗ��u(�d�h4)�b����c멆l�Xܲ7r5�Z�E����WD.�z~|��Y��:�Bh�r=�������e#�J�͍�/퓪a(=o�ב�L��\���h��8[]|g"�]�'�x�B7������k�
%)(`Lt��썇/O��%
k
��~���g��:~r�0����~��F�J:���l���8j�gF���hjU��_A�5��5;���>�Yrk�N�0���
S*m�e� ���m;�Yo!�����sk���V�����0_:<�o-�%g���a(��z�~l4* X������o���zv�L      �      x������ � �      �      x������ � �      =   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      ?      x������ � �      A      x�̽Y�9�,��w���v >�_���.)dU����:�~܏0UN�y��d�
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
DYB}��v.�;�.yN��Q	��=%p4�>��XK�X@0��A�%��P�Q�ra����΢�"C�j�@v[�\�T�춋J�T7N��m�	a瞮�C?�*�X������>��ύ�X�I����+n{�<��p����"bJ�d�C�2��lE�ۅ��Xn��j4�XR6�y!<��o棊u�4�fo�ø��k�UŬ�&ȃT=�F�Q>��nT1ҷ|�!x���'3�8p&5���;�bn���\�"F�����v��y�}c_�k�*�15�-#�<���!K�X�i�65Xll�k�c��sU[5+�U���L�p����o1�f��u$_k��LN�#�65V&4�7�?��z�-�fq���'��7�D�2�>"ͤ��������#Y������fڝ����R��i�2!eNO���q�d���sx,T@#U��Ot��~��`Ѵ�-N�ydO;�f�����m^�#���������?~�>K�
������u$�����f��f�(e<V��\��\0�� ��ׂ�i�%�Ә��;5�,7籴���	�i}������� ����9m'��ț�LxX�V����g2;�5�r0Y���^�,#�AV"�z��+��k�'.p�hW@�1��Z\�hİ�=i\���Kn�Rϖkպ�)�Գr�D$��Z�sx�l�g��FX��a�f/�"�E`�y#cc�nt�9Yo2��7�Wň���P�����'�Y��$��&��M�#|(�n� �$��0d.�ꪥ�������{��OWZ��M=�X�\�\���M;��@J͍�ƴކ36"��'p�*,z�Kc'A�F�3��ݴY��Lu���}���R��)�����M�H���A�:鬮���c�yj߹�%,���:���2ٜn�̼��ƫQ��>&�����8GJ�j��#c�W�e6mZ�X�� (jkH^t1m�VƘfUh�p^j�P7PuB�,7��D����0��7�q3m�3ٱ\�e�-�EY�ݴ9�F�?<A��M��ǂJ=�������ɴ�CKq�IBQ�: ZY���Lצ�~�ew�    ��&��
˚_�&�pe�c��Y����.Ź
謺V�D:c�Ԛ@�b�5W�vzE;��������A��5�0ɏ�[J���yx����es$���#�u`�JP&uz`N$ܴ�O&�}��P���P�z�wQz��:Pu \u�L��<���(�[pb�j�;3�[_�Xcɵ,��B�o�M+n�J�d���I�\I1�VA�&�Pi�]6�1�����w`�c���,��͗���j�9�^%�[G헍���\'@���ā����o�p�ß�twP��8l� ξWłg"�
Z�6R0I���ݷ�X�0�W������B0*5L��ɑŦ���V��R(�pV��e�C|'�H�=��̛��¦�t\A�	�������т��#L$-uO�'-��Uj6G�8U�� ��gӦ�`�aW�i�Y½�_(m�zZ\�y���h/�H�E�ܾ~�Ŵ���G~���1�iZ?N�اl�^Y:�y�IX�D,(� |�;_�v�06)u�L�Mj�������ڧ�5ذ���l�R�����/d�������흔�sE7�d��þ�3�[V�6���2"�x�(x�0b?*�mnI��0m]��2�ˠ�����9P���.��G5b��}�5>�D��^5��1��Ή�$! ��.����+���ޤU��T�UN�8E�� ���t���~�����Ϝ��ʒ�Ҧנ2��C���C�<�z�͸���:2��U�c#�8r��h�����q�N:������G\����Z$��!�6��d����1�BM8��F �(U-J[o\ԏ~D�� �j�:{��1+<ܿ�����hXM����K������\���L�mO$wv3מ�uqS�\�ɂb�39��z#�)V��@�M�|[%�r����}���U�;�6����I<3k.�fյ�XnO@6Y�x���i��5I�NT��Ѩ�M8��/�{=8�Y���6�<=]64T�`��`�l�t3�&e�4�M����a2iB�>]$���b�S�#hD�%c/��<RXe���i�ۉ&��eU e4m���@�3='��-F?Q�T�mZ�ٮ�l��O��Ѵ��w<`Į�D�����CX>N��a1ml`ŀ#��8S�Zi5mZ �f�t8ޛ���bY����R��-�!��}�K۔c�*O�}�'�6�Dگ����t��)l��q �4���Q?�-	�ϦM��l�0` �E��t@쁵.�����ٱ�U<h��i��A쇫���zLW�3y<t}Z=��v['���[M��i_j��+9Vji�M�G��G)qՁ��=e���N���/�B<�Z�.7�L�i�Z:p���A����P�tz�i����a���>������~�Y�w����Mk-mj!KM�`��D�
é���k�x���7L�f�i�SSPj>55�8R�iN�b~�A c5m�ҿ����ï�?����O*��4��"�
�i���4/%6du 䶣��"{��"S��69����f�̉�?z���r������L�X;��Tg��Ob�x̺`d?��7F�e�J&,�i󴌳tt!]4��sXS0}�/8)�l�>�B����ul���̽� ��@���F{�Y2�|��T�����"x��D��㌣��s}Fd˛raSK�H�x�m��d2m�u�pd�����䍦p�(lDvj�zKPW׷�t��a�g�0~<���g�GN��`=����٦��9�F��џ!�����p�P��Y�nv�R�.�#QvvX�
�J6e���FJ-�¶��٩.�C*���G~�/Ք��(�-M��p�D�d�HBj���'����G'�f;�|� �6�>��L�$���\M��l��xV�� L�x4w#�J|*b�4��|��)l,i�`Ͳ��V��!���7��l�I_�|���Z%/�:�|��6�G�5C�	_���}�ՏC��m�tV�̀��.ɉ#y"C2'��ɴ��d>�k}$REz�#^Χ�d��v�F���LF�6�4�x���Z�iS_�7}2P^u2m��9�=�����f�����J��/����ǎ{�\$rY���!S�>��a����n�,��_�D��.����e*�;K�z�!%܄�"�ܔ�] �����,�v�̏�k�A�y2m\	��/)!vVW�qp\헎��Q�t���/�bҰ��#y$�)�5��^�,m�A����FN�P�@*w����V\����~u�A��+�G"w����v��j��c2mڻ���F�&j�0�!��b_I]$Β�>ش��u��F����.����b�g���vs/lb�'���D{�X@'k!�xe��9�G,�+c �f�~��.=�mra��� D�'��;͆��i30�2ĞX}5mj��ET(���0�b����2�,���/�0�%��[�)x#a��E�)G��&^.�J�鲑�0M @A/�z���mҵ�qg�	}����l�65�3�.��"�zf{�iqΡ� ��<L�;"�����r�Vu'��`���Bfۋ����%�#�1���������X�U��mKW��-��c��5���4�j�j��[޼�Q� ��[j���&�>	�F�Vhz*GK�6ǔK%�"�=�&o����+�M�F�G\M0J�����[�h�:��� y�m�c2$���P��N2E���#����B�Cԝ]�#��<�6VnGC�v2����c�s���e.��
h�M@Rz�Zz4m�*TU��*��$��ރlӫ?q
Ck6둨՟���qa(�2}��I��;b�g	T�X �����'`�ٴ�^ޓ��${���A�xE~O-m���
�)�Md���$�iS�\�C	F�8�	F_θ�	Oo{eR�o1Z��c�v,9	���������պؔ����usb�Iu�D�h����Gb���[�}*k���c�6�*��ڷ��(�3�j�TҘ�i-���M�$�$�#�t`$}�1쎲���G�F�֦��etu���pH'~���#�w2:e�vJ셝n��¦l��WM����gVv��ɲ��6Jp$y���m�=E���.<a��]��%c$��ô�sK�0��q�h}� S�%ƺB�ĞϷ����phN�k�C.�䭌QB ����).<ܺ�K�51����6���lڴ�5K��QK�Ǡ���6���M,�3a$����Ht���L��mMd#�%ײ�i�����"�]%��	�մCK>�T��8m��n�5;�K�#�t��[M�-�.v��9���@kϵ�|ұ�`DĂ���n����@J���"�/<<�ʹ�m=L����nڴ����X쐿5(611���P����c�+��gV�J�6W:T]Ŋ�k�ô��0�^)̓r-�x*+l,̳��ψ]�j��^ʗ����YHMv����y���>��cQ�a�3�I�������6�bi}����R�X�s8b���pC�DE�i3m�iv���_�1v�5��8��8���
�U��մɯʸ���`��5�J�E{U�H�M�YHJ��i�j�W#��w-�D�;�w�d^�)��W �NK��v�6��~9_,�r]4��rZD��Ag��
�
�CЃe��T�F� (1i&I�=��6C^k�%�$I8ؠ3/�:�Q���t�8���d|{&'��x��Ff�4!ה�/K�
�#*2�O����!w
�g�N�Z^0� �1�s��LF������}��"(�\k{W��1�,��'�a�(�#�\�.�R��$>�c�:��0�&���&6@�4*@fӦ=��
�rs�$�SZ%�N��\23����6D�~VشF�!5�t8�iԡ`a$e[vV����6Ź��d�љc4?�����6wq�~0L�M����-�٦����*"�!ъE�Q��+�)�m��Z$�߄�H�IP���i;qFm͑~�u�9��	��n�Ѥ)R}R=!�i7Ԁߕ�v��y�=��[_(��c��gr�8�!���'�d�    ��g�6p��l��!�q�>�
��e\�^�ӦVXl8|��˵j�]�A8�c�|�:A�3��d��f��}�7A<��a�y�e栰��=��9�H����Jqd\`S�E�y2mr�n��0R�˵l��6���̫�[���� taӵ��wY$���`�ɅV�2r�|���N��_m�0�?3=Z�Y��hic
+,留�꭮)���x�KM���ɴ9�Xد�Bޅ"��d#e�u"2�p�(l�:�Y���ߞ9��o'L�Uׁ	'̏?����O�:u��$c��>���6Y2�?�Wsr�(��P:ϤD��5�6���p,d�I�h�x���U�h����J����a��/��s�-m�Ex�uD{�(��ߕ袾�ޥ����Hw�o>.0�+��?�����r����(��>�����Mu�8��uH4���8c�S�2��̡�r�p���ꌸ���"�ݴ��0I�C�[�>�&����8�\4Z��s8��ޱ�F[���o{��)���W �b��R��aH�(a4m����f�`�=[���S�:�N��u�3�B���eK�4uP+�<o����#��5{�9����j��:��_p,��a?�P��[O��ق���t*�hڤNp���Mی�OU�����=���:wp���l+���j��cڧ��IJ\��+��D��R���OjO�ӎC�|�x\�[Fa��4�h�&��v~-�D~�* �`ڼ%w}0xQ��TZe��v��G�i{�2��>�,�b@-��q7mL�2F4�
�"���4�: ����V~��!Ѹ�{�+ev�{��������8���}�&�X�Bg��x����XJI��&�+��+���
D�Wƈ;w�ޑ�\������X�
��hs���&�%	�8���F=~�T�%��5y�8�4�ϋku-�D8��<�C��W��瓘oS�R%y�Y��z�~�_~�ǧ�|x=�ԢzM�#���4ź�d��L��jG��F}��dRq,�UB�l�<���-�޹F,.{������K(�w�H�Q��Gh6,=\�����[qsi�����P��^����3���f�4aJ����(��+g5�/��6����Ȣ�+z$ҽ��1�{�Α��4�}��ۗ_��g�S*�8▽}���)���K?��[!�EX��HV�Ə\��3@�\r4Ӧd�V(�7�:?�\��e�*�u�L<M��lZ7XFn.-@@8�<$"�yb�����6:$b� �m���vg �8��q9R��6G�fx�	Qϕ�OO�S� �I�ʈ��e1hi[2��Y@�= �L��L:�r����e>���`�ܻ|�=�����*���[��yH��bM���6�_rۮ�G���=�����H�w��@Y�)�c�c=(*�N,1)j8u`$'�!�r�g��ޖq�X(瀯q\_
�\+�m٦�r8��8���S�:��x`���z(3~oV9_�\�ɉ.ݜ��e5��3�U�;m��>K��=kc,�i�T�8س.ߞU��{o&��ۀ��&��H:\ڣ�J���W
���6���R������dڴ�/�ܑô9r��6g��b�HR��Z|2mr�����縞,��*��ZoFv�gz�6q-/'i���L�J���X�4ܒ-�ML�XZp�ū�SI��(�2�6��1A��Z�L��ed�s< ��K���<Ӧv��9[�k]$�u�s�����͖l|?��iHQ���*lj<�3����<X�T>L��YfN��{���(<�9�/��6-�@�X���x�3�,d�sՔu|S��.�M�:b�2(��#Q�ð`�s�>�Ra
�4�#���A�Խ������)���1^�ִ�:��qouC��~��\�sj�1�Ѕ�%�Q������@i%p�F���	����*m8�se�X
%<�nڴ� �`�ru��"5�����o�O�*!�$��i�Č��A��y3m$D�rP���[]�
V�����-;�6՟�*�}P��q~֞��K�M�{?���%��3��� i�0�{ܯg��-{ϲ�S?f���u19��E�炌HX��4m��t� �~B�*U���^��ra��
�d��l�(m�nr����\�vS�3h�B�!5I�[����[B�p�gO��v��3#i����h�،$�,�@��Z��sآ>A3M��r{�rڳC�I�%�����(�E��(��q�u���f�8c�aM��ç>n\aS!F܇��� I0m��s@�m�9	c���/{��eBn���&F��/'���Zt4mRc+	a��K`1Ԫ���u��j&y�Q����W���g�g��aOBmoa�A�β��q���{�=�7C*��Z�&�9�Þ��k�����j&t��e${u6n����@�R�l}��7���i��ל����0����
kYX�T���bϐ $�i��dxT�>{�F/m��D��2J�F0��E�Uh�X���d�<��ôq}JT���a_��ռ�4�����X�*�e�Y����mdCi���F�d� ���˸*J�J��Qʆ��N[�.mf���­iW2���}�&�]��R����2kPڄ���U��d>/��y=���,`U�{v2��c�I��L����9����\4�������]~=QB{.e���~��/�	+�.d��f8r�M�>����|YO Q�ַ����Y^<7i�a�o�/��b�߿�&��*��l-E�������R�_�{L��uַ�e��d�޹u<_Pc c��fy��>�۽&y������q��} ~���o�L�|�{��!��ƽZcF��*mz6��Θ��F��v�&�a�<�|ܳ�@��W�0�r3.��<N�(�
K/��Z�a��������oz�\ �@>|��?�����1�������e'p�:4r8��˞m�����O8T�z`k�<O�is��%�:��y��;6Oe�\iS*�_�e6�	'}ۈ�3-h�XDdF����L��~.����c=���y֛��+Νʏ|����Ƽ�����׿�b3�Ǫ�ē����65щ��RLq{����uV2�O�~ףa!şR�9H���*�.��FB��R�~���6��s��ĺ�����)H�Mz���F8��G�Y],�R�Y���ˌÕ���h�p�{�YSCҰ��6����y�XS�H\m0�������;y6�g���Y��66awo7�b7q��m��Z����I���b^�6����JS��������^�Ҧ7p4���D�V�e��6O���)J�
C��r��
[��������=B����ܣ��V�i��0��Tx��f���e�8�#̦M�#�s�+=�k�Ŵ���k�RB�k�x�[Ca#� �q��3�	C��� ��w����&m��5EP|��D�!���-lZ($�TA�F���m�M�X���h��pOO浧���+mV��3!ɞǂ���������~]��ψ�T��:j�!�>J���&�VE5(�!ǥ�y�Ti���1r�7N����ul�Ɲ�y�Z�=Ms;���^�ͱz���,mR����	�����5����ŧM��e�,`�b&�㵏��0m��^
���flho~���xy+m����?�|z�H_~���|�������}������|ɛ������3d���)lUL�ƞ0錞Z��dcic�"#�)��E5G�e�f6EB嬟����unv�+���)��oV@��]�}@?W��P���g�m�Pi��33L�m��/c?ݛK��~]	r.��&�<�Q�ҕ6VE�ǂK7�漙�7�h�.mDʟ���G�渋��6�Dn��<�W�h�W`p@��t�#��Z1u��fK��������]���V9i�Ӈ�׵��Vl�(�l����Ztȴ�	E!u$͗|Oe�ic_r8$"�o��Ď�I^�,���wV�����U���&q�(�l�� ��Xr5m<�)���oAԿ��x��]�Y�~�7�0m���3�����8��Gy1����5�>WO�ӥ�C�H� A\�H%L�icP    t�6�M�\��X��6Z� R���<nA�b�ż�l���1OYV��M�����_��r��2V^�e�;�~��Xj��<��������l�ߴ���nCJ
���^cpa_eⱅ!|4�0���!|��;5]�۱��|��Ga.��띑y��p=WsJ�7)��֭���Q;~<�l�*r$���+m?u�jiB�i�4u��Q�?Vy7/�i�t�o���j$[; �s�S�|�oӨlr}J"Y�*^�H}
�����]4.g��H�i+���N,fd{��U��g���ȫ�3D=���%�� �������?�gN|N����n�A�y�>E�i��<���#-�a�r s���׀ʹ�^�~�r�7q̉b�4-�M/zfߡ��T��|fcg�ֻ�%� ˈ��%)S/�i�U������R^o���l�c9m�_���3�ʷZ�*�]�T6�h��GL����1s�\�
���gC��h~4gKլ�iS��|��;ݼ�Q��~�,l\�m�q�� )�f��i��`�x� <�RY{�1&>��������E����ΦM��)i�j��� �����9�>]�~�E��T�6o��1�Ŵ��,0���P}q�T�TE8��N;��d��?�<���F%�JǛ��V	���֟�����`�@\��8���C�8+���K�Z��`�X�u!?nw��M�[M���͜�{����s]{�����HQ+�i?I��j�n����C�5\�����ޛ�FJ6�T��}иVw��0���|�rcD�(T��^��r�U��3;R��f�Xz�$������H_t���t^L�{E��#N`�˛6N�L�\j�`�2�kg����e$;��<&>��is�ǥ<x����ȩ�'��ͥ�����u6b�Эᬰ�:�OV'����eTJ���}�����Z�?Ҭ�ݴɭ�;�u� �aں�'�s�'3U����
�{9��u��@�hb ���� �z��Tҫ��4�]J�z�\p���4��^�r��#��#�;��k�1q��To+m��[�vI]�{�w}0"��~�Sj�A�6%��J��Q(��qT(hP��m���EFfe���q�_6O}	��K��7��F}I�!i�
�^l����@nHm��������_�E��r"�2f���틁E=��D6Ե�ˇ��h�x��Y3�=(���LKJ$7����.�\�,�y�D� �10��݇�$����0m�ٽhK��4Ѷ�����#���C'l��@�M�m4R6<?�|��6ެ�_85�Z����6�][T�hDvi�/K��ʫ�z��F^�׸�!�Z�@�C|0�VmN�3ted��9��v&4��D��"w��	,q�H0m�NW�� �ɴ�X
����\u��a65�Y��`�U�_(����������M��կsڈ�=V���K�r:�K�rƌ�wL�{i{a���I�;X#��a@�a02H� ��1���)�Y`�RDPS ����TY�%�^	�Gﴱ�j,��A_��5�B�A�V�d���f�-�U��iV���nڤY匃��4{72�$�F��
���R�i�d"s��Z*b�>h��xe�8�х��<}SV�P���}�T'��͋9��r2��dp):t�Y̪)mo��;`f���D�+4釬�W1�3V����S%5,0e�|�D*�8vu��5:�,�-l��-6�Q��\�ΦM��p�#�daX����Ͽ���VCV��I/ˆKV��d��Z).c�:��g����݌b�u>i��8L�Jl�;v�,�q���BѳQڄ��
}���/o�,�$�w��6�8�*�E:ήUӦ���>L����_�$6>�������m�s �����N0sx@|k����wF^��J���~8��-lj��
�#xm\$�0|�#
��w=�6f��m��h��
!�"92�QҔ�����{��t���	˫��h/���?>G�����|�'Oq�;L�a$��L�$3ǌ���7�Ĕ��5��h_#�A����cH�a��k1m��z��J�@��'�XU����7í洴�
�PP{��%(�?����Z=�B�4�H��_�è~	os��_D���S?���^wJ��I8ȅYQ�ڷw� ٹۊ<�%�D�����q갤5��n��>�"�2/D���R�5q�=:nEJiS[�W��X��ת�iӪ;0�4�v�P��a,�0m��Ƣ�̮U���Ҧ��8�r3�q��Ub�y@��{/JH����_�x��9�e�7�y����k�"�Pڴ���P���*�(�&']���[a�'u0$�Zp5m���8v�8��z�-m�q�����$}-�<�d��������7Td)K�X�RPi}�9�յ���=�79z��5by�{+�a.��JW�� ����/�:�������T.5ލ�>��ʹ�"����ݼ��r7�a��λ��c"j���~u���0���d@�H�P��ƺ��l�%�G
P�H��x�����(m�NbL J�Noy�N���ꔩE��r�uio��1�%������M�Rf�R?��+4��af;�E9����HI(Ʊ�hA�-\c�z^�DGi��n�=X�p$�Z8�6�G`(;�t+����ʹ����EP��ٲ�K��yLQ��yZ��ʐ�I����?��s��P�b�2*dh��<ܮ���)�A����>uVג����S��d����M�p���T�յ���#FAC��\��:�4�0>=ѧPҘ�o��"�f�vN�ƻ�S6�+T'�e�v�/��e� �J�B
-u����p���WR2�ڑ6�0�H�1�@�ԿS�fL�ɴ�����#�tG�H�[����WQ���m(_iS�)�!њ%��,�\u+�XK��Yr@]g	I��v��*�"��z:��-�P���x�P�w(/ڸ�k7U)`���Br��6^��7��\��5��Cʄu8��5�s����"'���L�ڄ+��W�VM�քE8F<G���WS�T0mb��p�$dQ�z{$R�� �w�d�M�Z�ԁ��R:(ZU
!����>�����>�POu*�uX�Nq��^� ��=�i��M+�A��%��0� ��ac��ް�&� �x-��]d7�כz���V�ɕ6(�~�PA1�� �ru�R.�q��p����\
Ŗ6�.W�E�AI��̱$�\o��8o��5 �hQȱ>�S�b}�W]\=�$p�l\Z�-�PZn{?1}���[z�S��d����f��] (�:����V�D�6�L�@�֣��գ�rt����֑�Ǫ���Mx.g<��#�(��W�ĥ56���is����� �h�D5��9p�ҕ�~�~�_Fх��Eͅ#_�E�������j���?��G0��E���JqW�bl�Zu�Ǣ�!p����xG��R,�p����N�2�P{���[���r��E�6G�<`�]����fq��MՅ[��3fR̘`�a���y�J��x�T՛_�v=�H4�pLx�J��>.71�Ҧ8e?сohMR7DY�Rӥ�Y���q/�q��z�i�s>�Q��m� ��6}$�۴&E�i1m��Y��J�.) I�<dBQ�*ûi��5 �@��d��Wy��/xr�i�^��vNMF�i������O�]���i��M��'�����ϔFg��MQ�=??pp�Q?�y�`ڴ� 簷����۾�K�/��kB�Yjw2mr{2~:3i���ա�e~��Š�HcrAm.�I�wL���
*F�P�`ǿ�y�g�g(�C״����^����ڿ}�������耙T�@:�h�4����]a1m���r!�:���#ĳ���~%�މ,�_�H4�s,����H��,����&�#k�ҽl����)d8(�0��mr�%F���4�-5��Slq��v.��$���� :������l�
59�Z�����*'��j
JiS���AM�35��9d�s�y6m��
{qD�����8����æ4�ٺ�W�:�:,jf��h?�c&ӄ�{���[�ZĪ�L����pt��F+�d$��    ���V���_�}Gs����ƌD�4&14j�+}��n6L��D���-'Z|m�,�\\?;����b �f�J�/[gp
�}�WE �W�m��Dڷf�D\�B:���n��w7ճ¦�V�S��lڴ��`SK�oA��}S�(ld�{��Y�Z\������2ǿ�
L�6��2�7u��?��Ч��Ԗ� .���y��q��N�g��<�!m}`���"L��Q��0%�X1/��6�X�����������`&���ЋO��h�ޱ���i��y	r*�8,L��,1�^eN���6�=�5��lڴ+� ��f�ē�NƟ6�i��O���DsZ8���5W�����x��Q���՛8���Ռ]^8�ɇ"&�8���b ?����I�+��s�+�0j*>S��R��d�I$�fG I�F�mZ$�p��ߨ��תf�9���i���f���{��e�]E�n�L�D��-����N�S�aŉ�fM P0m��Ql�+���@	rZLk��|�z���ސ��";>W���٦;2�q�Wm��٦w�ZX�㎒h��ǋ��������9�r6��ѓ��QO�MSA��it��@�����6{-Y���o�f	Qknu�rEn0mLE��T3Z}2m��\��LP���KP�Pb�B�Ģ�	�˹�*��c�	�!ٽV����s[���qhr7ɦ�%w�u���E��e	ǂ۴��XDW���6Q�}�ч�"�9���x6�KL�N�icr��Rv$�V׊8G�<OO��|���3����sl��+U󲱢1�#��X�q!Yx�r1���x^YL���lƢi�#q�ȷB�r8�̏Cs���i�ݙ�4sX�A�$����Ӧ�Y��q�h�B�q�q�#�m���YR�g�L̤D�^C��VYH�u�ޓ �`�h��L��_ӵ�������\ ݚ�̊�č�MX��{��y8m�l��SE<n]0r6������h���s�q�"����S�{]t�4��۟���0�������'��WEQ�&jcc��2���ن���P��J?�M��Jc�E^w����D�I�r�.�٢3�!$o�&�6�?�Sh ~�]R��p̅����1AR��I��\0�\��ݝ*p�;.k*rqĽx���	v���@U{���g�V��9�4�CI�H4x�S�}Z����.�,b�]�k@Ʊ�k����U��e�9/���`�i^�dGB�$���|���l��2��0tP���hY9v�1%߮�ls4��;�!�)��H����a�������a����g����x⢋�������8�>��W�������[o��¦j0�8�2�0��D�~�������	f^w�����6�*�{Ի(۸�F)�w�(���J�a+6�KZ3,��Oa�\2?hI���81�Bu֟�5���]_�ku#�s��F��9�fb�8O����V@��h�ٴ�[�q�?�����h�6��< �~z]6�L4���h�g�nS�
�c��Cf��P3��z����@1N�I8�_C(��D��P��(�i�Z�y����0�R�h��	l�$�6)�F9bSڪ��c�d۶<�������>����g�����:RH�q�Xޤ*�ȫ.�����Tm��X�V�ߕl��I:�<�ǿq��H>v�?9��u��)ljM*я�3��bڴ-�A��KK2��d�w��k����N���Y-���Y>�D��S�����|�Nֲ�6��HZ�</r�6%��0Q�2@��\�m����L. �؅��y���t_�Ԟ�!�s��9.�g�sX-���e��/[�(&g\�d�`����¦K#��*:|$�4� ����.
�H���+D^1�/o��}��1#�窓�<zE"��pq���v��%�6���"M�g/ۄd�+{2bgΊ��iB�:7��c�ηdaS&"�x�GJ�vhdE�\��{"��&&�g�⵳z�N��"2�Oɳ��#��Y�a|�p1�8�I�)7a���TN�<j >8L�"�"�ǳZ�6y=s��̨���MK, L0m��PH�����ۤ��&�	��p��L��WƄ�ۋ`��s�i���1���畀ŗ� Y��_W!5a����ۤ���d�H�"�7�Z]�#L����nS0m�=g�,ba %Q���o#�K�N�Z�¦F�B,��"Ѣ���T�5��;����dq�z�b4Zm%�{��H/����Z�W~��_��~H9�D�q��K�~�W��<�e������X�݅"V��Ѽ?s��7�6�M��N�z.�M�R+w���q���ku���!4m�r̀��>)�8b�*6I=m����:����� Vמ�h��������./l2dFz��~G��h"c֗ �`��tC�;0��[��=mj�,�A�lu\����bڴ��=�p4;6����?�ߝEn`N+G��ô��V]\`> 	���m��C8fR���)����2�6�\��\N1%�6N2�)��ɶN"�).Lػ ]�մ�g�Tt^�N���������S�"k�煏����w����5�E�I�*�Q]j��ІI�X�Q}oO�*���#�u�hƱ�g҆���Cߐ$����,j�#ђ�c&އ���i�M�'X�|�a��D�'���HkZ�:�O�,�PԐ/E�0�(����k�-�?ˍ|yջ�|a��8�Jc4Z(�q��q�Dq�z�d�'3>��]4�R�P3��ߚ?�q�@E:m��	{
X`ͅ#�wp+H����c� EƸ"=[���T�RrG[g%�7���:g~�حk�u&+L�٫W�M�
pi0B��'#082��8t��W�u��i4��������� ��㝣W������~/wU��f���n���
9���C���B/�S�2�Ƅ^�����ϟm��8H�8U��6���Q�9����_^��f���# D��EI�a5mr:Z.P�އ"+�A�w궹���;�Mͮ�i��E�*1-��9������R�b+���Ǩ=T׾�6�dVFW�%��A\r ����gs�>�o*b��@W\R�g~�����V7���nS7�R��y�U`�ݴi�,±�sY�8yo�n��MM_q5}�H���m�3i��X/X�\O�Z���j�>�V�G8��oc�i�%�61��QԠ'����'b|�|��&@l����C�=9mj΂���D%�r��e�a(����֔�mIO�>ֲ� Wm���j�\^p5mZ��W��~Ɖs��i{	�|��������?�|���߿��_���lH?`1�v�2\m)a��ҧM<`7��>�eD�����.���m,��aq����Z�q�l,�RO��d[�9�v�<l0�"��C2�g�f#��%/�ܕ��i��l8n��L �2ʎ���)2��`�6��+˟6��`��!Wb�(��{�s��PD��Ŵ	ɽ�7!wPF�G�yl��Ԧ7��W�z�N��L���Hw���(1RW�������TeN�Q�,jD��hEƱ��Ϙ+���������QrѨ�� ��������icC�����z0m��9D�_����3���Ȩ�&[q�W�
��6���q� ��W���O���'�<�)}b����LhL])�� �1N�R�i�F�'��T$F}�CZ�=N�������	 '^��z��伙6W��N|X���S�f.�7K�(�|���w4�;~$�4��������9R���ʈ�ť�	� ?����\�+��Oc��9�O���D���L.��LQp6�}��$���6+jp�O�m���K9�*`�msk�l��A�Н>`n�,�M�C�u ���n��lZH8`q���mD9�(�k�9q�x�_T؜lq/jD�K��wӦ��:( (�B���sQƇ���s~_��-��҆�.vx�k+������][�k6�[��m�p���8F���b�l����H\��=',����k+]��#�f��O�ۗ_�}���&�gpA;�(1��F��\    �eǮM���O]3{�H�{L�B?���i�rU��?œh2�QA7TB嗍�1�������Z��Ǥ�w�.2����6A]�"�T;����xOؗ���ho�*1B��З��c���=[���"�(v8n~���2(��7\<��a�潱�M'��־���eS�i�Ɩ�meYN
���Rb��Ǣ�dڜ���_���w;��KC��p"Éx�=͕*��p�˗p����]�O�9����ͧa�ߢ$��RM�ꁱV�����RW �G"���#� +|$m#-��ɕ�x��<�!�x�phI%
����򲳁2�Gr&�{ Z� Ő��:8�*桹�6���F�d��窻i��K(�<�qOs��F��ć��#�:1�@�:�R���8�¦NG'�G"�t�^��M;c)nm�.�y����^�����t��V�L�t�g#� 2H½Ԥ��Y�7p�#�}$Z��Nru/J��R�z�f�*�'�E���C�u�q�£j��P����u��9����6����Ӝ�Se��U˒�¦���:ߋ�Re�Ҫ�b�I�M�R�ߚ�.�בqxN�um�ɴ��XJu�ӝ�h��Cj.�p��6	���)�=��M=f9�z��U7Ӧ��C�}K���-�_�|#��C_ס�<�q����9g��r�I�����3��g l_�:-[����l/�d�D�"uX��B��F�?ӧ�i��a(�/�:�k=���\���d����ZX?,��܅M�?�J�D)�-��6I��`�a�7�M��1a*�"-2�6}C�n�y�u��p�s�`�e���=q�H�D;H8� ԡ���5`Ѳ��eL��P��N)���+����L�TM0� ���c�v厝6�&����؄��="�צhC5I��:9O[+MK�h�~�[��w�$J�]��`�4�<�������
kZ�Uq�i����]��p�nTZ��1��T�¿��7GE ��ƻ�L��8m��Q�ASk�;4Zp�p��ರ5��<�c2m��pu���-�dM���n�X�Mդ��T�
��H�mK8�5o6J���O�i�v�oފz�n�d���9$ɇҭ$+q�.�I����`����'�@ ���MG0v�/ZS.9^9^�8Z��u����S`�>����p�Y�a��5�7N���9�K�մ)�E���n����b(��B|�У�W���J9� �S0,��[���\عq����m�}+6vV�Rӌ�L1�Z�i����M՗�#�#�v�Hе�BXpKO���&q�E���f�Jy
dN}��K��S0ml>��9��յl'�P�����(��N$��d�t��L���d��]$Z��p�Q_�;g%�z�����k;�b{��2ճica���3����i�.����S6/�#c��۠&�����[]Ub��˯	(�11;����tB�X��v�L��d���5�������[��o�x�% �j� �]��>�i#),��WSy�մI)�!)�t0�Pdy��	�Yti(�i���q0D���H����'���b�\�I��'�x�d �ΪM��e����&<�+��y�T/��R��c!���0��6V;�ՐW<�ݵ���LfC[u�W8�ze�E`�8j����1*�"7!�C]+y��g���:$����L�J+��x���e�	?���6��+%����a] گ�88��|�����6e`�]\�19^lH$���G�ٴ��v5���/ x�����oC���溒����P�)���-��9��/F�S�_����W\nsD�3?��GF$I��Z�~s�~�YD�� �Dӄ�8Ht��N�)�Y����T[4���6���c؛&�7�S��H�q�'�$7���q����?ɯ��Em��xc d�T�[Ҳa7mXJ��*�B�����Mڱ��A�����U,���Q�8�wA�Ӧe�J��4o�a���Jn��/,����}0R4�a��y�Iq��<�6cw\�3__�����8��A�O�d���䴩95<�b�ì�bڴ7�p���M"���'�is�+|���O}0򵆣��	������n�̫�	������C��[}���&>m��xwK/qǯ��l. �ae(���ą�*�y��K��Y�K�s�մi�,�!�"�p�9���a��&Q�1�7�˦�ks1e�\�0mZʜq��:VW}|�Ӧ�J8�XN�\u4mZ9�`�����[.��I�YĶ�窓i��.iE���yչyw�[ܢ�P_8a �=�./����5e�e��6����{�U�q��E@
�.�n+A���Xla�R��٦ս�Y3�J�O��o\��_\6���Ws��Q�\�޳��9J�Pk��_u��T���8���6�;���1�������?����&�aW\M���C���6a���`\�^fN�e.�*���nhǸ`�B%
B�5{�.�N�+"��G<W讹@��� �Z]V����eS{�9�X�@I�±��q�GZ�s��$[�Bz�^�M��� �R�be� k��!�p� ���H��u�l�f�eoD�8��7L"�,:��u��'f�0�:�Mx8�Z����;��8�8	����1�^�����Y�Fe�s�Ŵ)A��x4{ezىs�L����Lo�2�8�� ���8�O?8m���t�>����p�:��q���S�A����	h*s1hw�������e����>����
����Lq@h刟6��<�0�Où�> կ�#���7rL�
z�M֊�.Z����Z�D��w\�k����[a����KP8���e�8��E�66ּ ��<��L�x���?ϛ ��G��Hߢ�Zׂؗͪ�tŤ�eI|��K�u�Az�t�cս��^611�fKn���E"%�(�C�?$���t���*�}d9J"eV;c�m�$��~� ��".:���c)���ק����'���I��z,�ʹl���3	��UG����HI�AZ�����/�?:٦k���0���r}�g�T��{.Zk	�x�����0�UaE��x���I����.��@EF!�_Q���q�&����(Z+c-lZ�} ��~�m�����)Aw����޹���6��5��4��� �i�OC� ﱋ���QLb�pd���M���&&H���ak)A����;﨧_?�#3q�oZ�l��=;8R�gF-��=[ȅ�,�;����!V&i���/�M�V�D�O�(Y��j���ܟ�e��}��n2�N���h��C�5���l�=p/��l�Xt�m*l��7R�rتkM��$'n;(F��	pvPP���d�؃v''�o�\lפ%̷�?Xs��,��y3mZ�������f��q�����㢁��	]��I���B��Mᨰi��)���k����)���xolu��er���rY������{v�K�66��������1�մu�]�m�=��=���L�Tb6��nİc�Ƶ��X����םT��~o��:���1��z�pk ��Id��?' �@�~S�(l�S!Ce#��@��L�=�>��D��`���:�,!5���$8�J;`K�ku���s$�hN�����sa��}����_�����ώ����{s��/���.���K����ZK�0��4��t��ҁyGg��C�[��e�������$���5�\��6J��RFܵz����h��!�#u(�G:p��|:B=r��T��=DU�k��qd����1��{����)��d��s��X�!�.
�tV��0�6`1޵��=.㭦���%��C���jڴ%
�mp2o�M�`��x�K;MY�*�{��{28�eF�E�9�vX3����i֮�՜��b�W�6�I6���о��$�\���	�*�j�F��\�Uӽ�3Wp��Հ��]4��j���{�&f���@88|��4aH�Z横:.������L��3�٫.��@�j��5j���G�C_��T��	�p}5��W
�MK���T �%&�r 5
  �jP['���+��XĢJ"�P<���ȫN�G9���_�"ֵP��q�Z��D"�:Ϧ͡�q��
#+�1\T�F|���g5����!0F�����DB?ͻ<�lXa3N�?^#�`zg�����I�8���\}� �v�&�j�8@��ȣ^��vg��:%�:$~af�$��]��M�Na(D��y��l�q1m��J��!ʑd��jڴ�m������9w��o#��l���n:�u�'�Sa�Ej��h5:�#���Ƶ�cm�\���FCkx�tPoly�f�@&|�h|�9�܇�l�66O���`b�z}�e��1r{z��7=Z$�R`�`n�j�K�#�s�9��و�fB��	!p�k녬I�b2m��`/u�gV[}�ԊЅ�T��Y��Z\�Ab�|Y�"N�'����ȣ���ʓi�B�C-�f�u?Ks�7c���RKN�<��^'Q�"*C1��x�$aDfݠ��`���m]��u�`
̭ �Ŵ�W�2���o[S�{0m�m�C�68rӷ��6r�hr����칃	�h�۬���O��M�V1�{[M�L&���hni��P�d��s��fr� �
�4�U�i�?�!��w8���=�@�O�,�eP�Yse�#����lڴ%�P�$�{]���P�?A�h��8y<�+��R�J͛ܟ�#q�q�mj0o�MKL.��P�����$��2��Mo�ic5k�r;n���~�#Hd����s M�͛�E巪V촩�������E��98D]���o�����҄ޢ�Z}:m|7��3�ϕ�`ڴ�#��(��Jw^��W�Ɵ6G:�����p����%���orj��������g��7
����e�bo����x��:�g={.A��q�ߴl�\���/A�F�1]n|�-*JM�ic7�;Pp�0X}n��ܝ�(r�7��;�#���vi
�N�u���[G^i2mڭ�q=�0�iӇS�啑�-�DVLMˆ�;�������W�blu�*�8p�ͅlI���I�͓!�p}�k"]4Z��s�"��"Hk��}L���M����2�`�Ų����)�mZ�Q��."rq�Ǹ�,+��{�LN������q ?0��6�mJ��:�YD
��N}��6�{�@�����֡�Ӧx��m����~
 4�6��FP&�l�n�4\����������Ve���FӦ��r�����$J��/�G�b�?Vb��`�U ��y#_>}{��3������a����	�$�C�9��X:Q	�6E��5��v飁�"/<�;2�_#���5
X *��H-vn}���11.�w>���.���T�~�ë?N��yF��]��M�y�ɴiM���Ll~�(�?U����(}�������Ç�o�p) ,�i���fҫT�)��sT�M,c'0lUr�t3E,�(o��u��<[�����؇�gp�9���$ݟKaYF�j������i���W�֎��lr�t��p��"䥫��u�x�ʨ�V�L9��EA��{I^�.\w�ؽ���Bg�V�>
�����s�p��U��1wߔ��>]��,$ k�zi�BU�v�E�X%6�I����6I6��h8�~���սl�5q�8�sa�"���tT�3QW���67�"*Rc��^��u��^gO2�82 Cߡ�X@p���N�[IU���W�=O6���a8��²6��b��ff��JM�>���!�mL1���������V��M9f�0��.��ɦ�دb�O�l{�n��j'Αk�,�������>������?���w'�X=۬�.4�9���p���y��e�nZ���.��*��:��c�/ͧMU���"�XJ�\�vW�����, B�bq��E0�O���2�<d���!C�3uQA�h?����3gyg�,��6���.k",�h��F����M��TԞ2�65 �a1�}$H��5j���Wt�1�A1
�Kۚ"�8#y�*�/�q���/��m\ ��A��a�4.�~�Da!Ѩ&LC-��&و��5䉧υF�&�(
)�j��m)�lb�?6����\$r����(T��	I�m2mZ���������(d���u�:ry�:O�L�vX��s�ٴu�²*�G:���i3��W�4�q=T�rx��=�q?�}�Ёwq��	�ۗ_�E5���p�a���b,v�鲭����ڈQԜ$���m�}��b�f�(��FiM�����ic�����#7<�:L�����?ӛ0�Ϥ������wWz�=�dtDp�8�b}j��e�y~b�a$rT��b�7Y��$����j79��	�<Wdp�q��4e�#�d�v�/��uVQd; j��ax�=���&���T62���,��ީ����j�zƒ��c������걌��B$���)��z�$*�H�4U���T�����`��7�6�R��"�=P�w��`V��Ɋ1,3`�V?C�vI�J��ʦ�bkU�}���4�"�?W]M�\c�a�uo](=�[�d�a�M�8Zy��l��+�K�7y0�s���d���g�,ʙۀ�������?W:��      �      x�͝˒$��X�=_QKiqCx?jWM�%��f7������wdFE��G���l��Ff����������F��'G��d���_������������:>����,��?^�|���??~���׿�������}����������Ӈ�˿�����Ę���O(�5��Z`���B����ӗ������/�~{}������˗wB\Z̈́@�wZ���Ӧ���^_M��j� ���xXMSW����|�CԹnMBe�_~���Ǉ�?������_�����_�������K�x��#���|����b����7[�*+���%d��8˿���e�_���x�H}��L�><{���>�����˯��9
�<[����z����|?~����_��WH�Oa�s�)�e���)[���m5- ��z*?f*�
/�?=�|���|߾���|�?�ݿ[���*o1z(J�Ţ|�[�̽�nx�b�-�}pN˼���{��:���C]RW���_�p��oyS~�������;�����oO�}{}�����?VFО�������*�}K��*��RbP�cm�wL䒚b�;��p�>��:^Pr��i���TMw�{�
!�����{���l��_?o���)���7��N���N9��P�t)/j⚏�\�k�mFek���O�_J��#���.l�D�qE���D~���
&�,AN?����|7�!]z��1�����,)�̛�l�f�v���j����d�ռ�X609|5��3>��eo�}5��������49�va�)e��X�%���]$�څ<2j[�*C�/?v#9%>=+��dC&�u� Өl�xW�������m'��)�i��}����O�����.�XOg�7��s��53�zͰP�N��Hw�w�m�_��Ƿ��ۖ����/�~��G}��;--��!�"�w�Zd fJ�.�����{����ۨ��I�6U(R�|�7���V/q����o�sĤ�ճ�S��˂ʰ�{�c���5:E�,d��\��Ue�ŻFH����CNO*�3�pR������R:cz��#�;a�>�	L|!� O�b���~��[\S_a���8��� �����˿��x����ׇ�.�hh�z.��f���"d}�;KDe��Q�h�E4#��Ϯ�MF/��a!�}�G�j�B�Ip��z���	G,K�{Ģ�׎ʦ���ڕC���l�<ρBį�yr�\Ť�>�۴�\QJ̃=}��`�%��ؒ[��(ԭ����N�{WH���&!���*;[�����-[4�<&J�Y��/�5Ĭ��
�̳����*���(VLc7�}@�����y�()!�Y�/�V"{\�*l�y�'H,,�R��DM>�a86����|��O�����V.*�-ʅII�{M)�_��4�|/"��?�s�	��J��拹�_�K��'��k�8x�*j��X�1�@^��i>�&�B$(K�������U�Z�@�ޔ��3;Ȣ�tʻ���U��돣�������������[��keu����w��M���L呭�Ε�k����#�>uV�.C�*Ǥ�B���/ܲ16�
D�G����92*۽��e����������H�	o�����Ĕ�yR/N(��I���nhO��=��:=�.cx�o�o� 9�l�i�u�����	&':/����Р���U��X�sB�ZțP�]_KP���A\�KK9ü��������t�SJX0�o��S�r�:i1��+��ԛ���{|^�Մg�����1c�'���������������qޔ���,�g�Ҩ��z��	*ʒ��P���/�C��h,*�m�^����}�}t��D�jsE���S�����bB`k+[�u�5BD;�W��I�{�V{xh]@e�a���/����ф�������S�3�&�"*�_�WuUΩ�pP�P��zݧ�7�=0O��}VV{�ԠTTV��	(+w@��7�-�LyiR�Y�-�4����ԃ�}6�!�z��Y�z�r�6�փGx��N��1�+X�{T&X�:�w:{$�fig`�W�SS�e�m��Ru�˻�,M��3r�d8?ޖ��GwZ��������������E{��-��>!��z���LT�Ğ*)�og2���bR�}�`}[VeW�M(�u�1%�_�4iH���B$�bƛl�Y�3?����}�>![����eg9vwUI`ʢW�-������f�<mM��I�pKe0b�g�.�[�{J�{�n�f����8���Th�b����)F4��j?���,~�����?^�XnƟ��j�w 4tN�p�C�k~([<����1�����i3�f�e4���ƑQ�BŢ�)+@OLʳ����+W%�����Av媄�
��;c�A���,�X��_�<DD_
 NO��c���>$��'��e'����i����?<���Ҁ���xY/bD�t~��:!��_����x)�l�]��-�a,�NP��v��ǌ�����Ҩ���!'����"�o�nW�A�e�M�EzU{�m@eȮ����Es�>*��i�K6,�9������3�> U��%L߉��V��J����5.V卐�'��VU�h�i/�f�m
�COS��̢2f��n	����v���P�Q�~�S1t2�����OF�d+�%*ޛ+�3��A�U�I
�1B�~~�צuZV�t
�b��r���R.�N��*�\; ����p��14��[��G��3��d����::ڏ����AF'@�ΰ��z��|�l��%YN�@��Qʘ���QI���A!�zP���+oAȪh8��U4=W��@�,� �h6�?�C3��A딠�E��L�^c�6RD�V��n(>+��fAlc+�M�5>�鍆��(.��xE�2�����x�Cϻ�l�?	�yJE��I)K��N!%��0b�&?XycM�z4z�m��U2w�+��!Z���y��em��I�T�5�6m>(�_ۖ���C$T��p�Y-^N%-^n�
r�X4��yk�N������N�//?}~�0|�:vO���;H�Be3k��C�BVي����2�WO����2�ISP����N��L6���jk��f���R�Wn��a{T&�k�k.�t9Dq4,��*!�n���_ɑy��X|-�����ZH���Ƞ��ߜ�J_w��`r7���׾�;��'��N{m�Bt�]��McP��XȐ�6�^��#�	��a��¼��
Z���������O_����;��%�k�<cQ�h�@�a��pg�:~aP/��l�o5ٺ��6J_.���d�r�Q����ƅ��W<����S�-�r�nP*p��h\Y���k�����o�UB�۬u&�����W� 䯣��AcP٥u��Ni�)'�k�u�1^XGayt��W���.�B9hj4��
���?�~y�������v�l��A맨c|�M���!�-�~A�?^�`P�e��9㵁�!B��?V�9xy*���:��߀�v�B���L�:e	�4�m�t�+�D6|~�#YT��I�W���xa>��{�o՜�Cb���dXhgm��C�W�V3�ΖsD�o5D������e��&d~vyK9'��~ⵢ3*c�@��?�eX��B�n�*�et��|kn�La��J�H����p2re�H�1�G�d�z)�t��nP.s�[9��SJf�����=��5m�Lm��N��S[�F��R������d�l%�P��6s]s/��3�!���"���r;b3�**�̝���\��͸��Ã��́��+2�PSb��Fc.��,b��X�.7�ҨL�rc N����k{S���힍��<�6����VE��$�Ӗ�X	�RD:�j4�s�3��fv-��a�娍��*U4�];�7e!�Ipq�t5�=����y$�6J�ys>)��]�o����p�p�8Hbw������`�/w
z,��-���=��_�08�,T��^�n���
q?{�nf�M��r�u�'��
2J�aL���x(l�����䄾������aLd^��� �yi��6�Kx<5Q��X��    �4E�=�t�yN���_�}��/���rG���������r3�`�Ѡ�G�4*;?"q����G�ƻrD8+�="4�#�ZD�9\:"g\`����J�g�˦d�>�2�"��bG-%O�D���ϧ��w`�_����k2��i�9�}����~3���7g\�(=�dW=J���*��j<�y��CwуL�Qb!b��k��k�~�h��P�jƋ��ZNb�X����)(��]�8�d�[���i,�ч�٬�l��o��]ܬ���L�X�U�	'.����j;��נ�+�-`�]+�Kظ-EK��I�3�"C���F ���!�l����-{]�x&�'��kBe찊���"2f���z��4�,�G�-�� ��=|^�%��=�r�tBkƅʘ�|��;�	��
fJo��-Ev���x7���+9F �N�6��c X>Qm����x��'k	���n2^�B�H����tp��,��j��b��e]v�����3H^6�q��^����&[u���,׶�E���t��ɝ�,D�e	q-���<�j����ܗ��e�ᩊ���w�N�\����5���P6���)�J�]՟��ջ��x7t��0%��x�I�_=�Ļ��P�l� �0j�3�+��{��;�ɵy#�1��c�i�T��%F^��s�c)�3D�o1���ʮ䣧:�Hm^%��䌕|t�Z>:OZ磳��耓Q�$]̜hW�h�䲂�X2Έ���34c���T9R���e�k�(͍���g���=jc��N�˸=���Eg]D/%r��x�e�H��8R�$�?�&�ۘs8�hܘڴ��^�s��HFh�ٙ&B�I-��F�����]6u�"M��uz-=P&(�o3�_"czLŌ��'�����"!8ݦ|t��:�q�8��OtsF;|�Q���p�Pi�͵�?�(�Z��~sɥ�^���/1N�ԫ���{Å�k�Z��5��M�զa9���&#�xo	�;{@�8��?2>�oq�ͺ��h��$P�J$-Y������_�H��׹�*�tR�Ѽݜ��8��y���!.j�ލ�^��;p!�e���xp3E�]^��������"c̖�#�_6������9ƇX���:;M2/�K@e���":�G�x6��"oZhk���M�l��9fV�BM�RF����ּA����2^�K�H'��M=@	u�&c��}��0q�Nj¦C����D�5NN�!a�԰�u�Fe�$f��-w�X>�|��V��P�"&:|���f����xQ���k�0]!�H�UH;a��u�N���vWc��]Ư�Hӳ�eǳE5�D%�Q��q�+Bȅf��³��l�6m�#Y��WE��9Rh� ����#2�SDI���e�����+dj�5�P�̧6N����y���-h��F��I'��J:�.C����1��U�cps������ߏM�M;R�-4�Z4��uJS����q�Q.�	�0m� ��~P4�a�l�R
�A��F�S0��G��_��s��V�\�Ʃ���[X�Q��՛#N��� ��h�wW�e̤��Ϗ&a�,�$m�X1}�2��.A����:c����Y�����V�����Qu~V:��e�)�}w��7l�M4�� �DV��iV�;`�Y!fFe<���
YB�t��E�*'2@��H����r��t�M�y���'�C���W�EJ&�/1Ε����<0�A���b*cv�F��0!Mg�F{�A�ٍo@���F9"{%��i��.��.W|�	ψ����J�'�_���0�1�2~�=�Ԛ�gz��8�<�썩?;MƵ�d�Z���O�]:��gQ=(\��b#+����O)��5���j�-$����1�/7�Ae��ؖR�m\��R(���S1�3Hv�L�r��U�6�岍-��;ԇ��\��|��vF��\��r咅��\���q5Bf=I{@���Ȩl��+v���q�،�HR��Әt�5�JW	%^��D>�*�]�n�� �ZY�m��rEl9�ѐMS��. }�1�!=�8ʸE�}3����;4nQR��5H^"�Q����n!����G���U�m:�Xڼ�oݝ���(��D�������!MQ˟�Ce��ޝu��4���y�A$�O���S���S���+�!B!"Տ?��n��8���0���b�Bi��Xz�r�;g���J����5y���[��i��6�G&�wG��8�
gP�OIy�Ĝ.��5eK���&[���@ټ%/���c�������6w79c���{F��QN��!�]:/�.Cvx/_!�B�ӚP�E�ӄ�����ׄC�M�����s֡�����������!3���?c�m�� F�]�r��8�	�B�I���9ht�ʰܟ[?��c�K�zS!;�+��g\��B�_�ru�w�_Ŵj�I�@:"����9ケ_�]�P��ط5y:l���;K�����d$!����d�.;R��Y���*�Ҟ9�,<H�ȧ��e�ٌ��E�k�k��;`O����ij�{p*ZF˷��� &���7�f}
h�>`r*�� y�BD:�rL 0��s�y:��5��	.��p��M)�k��$��|��u�zTƽ�1��vR�is�X|�mڿIv���y�'��Gy��|���!��{�i�����5�`9�N��MƜ�mm���%�����5F��@H��F�yt�6٪́���� ���?v͏��d;� ɣ2�#��HD��em��f2qu�{�\BgQ��E��v�[��z�]$SїY���pR8(�u:���l������H�J��i��)פhL	�-��PB���ղn��f>K�l5t��0���Rd\�匋粔���b��|K�a�,p|ǁ�w��e�@	���5uZ2S��r���_�	�-/x�k[~���0h��3x�+fNmԫ}��cD����94乙㑧���7sx�fNߧ���7shN��s�h'ZР��Z�P�i����zt�Dp���G2<��D@FT���-D�	K�.��h�3�??�~��������������ߞ~���������\:Q���J�[�d����>�g��k�C�J�Oi@��6/ED��_��s�]^I���ţg+9����sDHG	h���Q��&��9�,��J����翞j��������6�b|ub+y޲2��X��D�k�(D���
[6���0R�|�2I��f��	uY^�3Nv\!�^l������|{P7 ��\Lج���8Y0�D�<��Q�OAe�6�}��<���6���w��P/�$CtTL+́��؟�(��d$��j8�m�1d�ёSH�ʸ-GE���j�S}U�]v���؃{<3�M�]�.z��>�ro��B�p	����T��ʸ6D�м���	Zf(�:�0�6��gC'�#Î�w��e̠r�e9A�e��"�w
5���XN!1!{o?�Pٵu�!F�.��:N���	�꫓�����έ�Z��Y�m�_����|z��"z昔v���Q�ژ�A� � 34L�e�	TnuX�r�{�d��01"��]C\�7~�t� ᮃi�Z�����vC7��}�۸����O�����˷_����jF~y���3��k�����)�����+�7�E+9\�ǾP��ӟ�&��w{y�q@C��2J��/Sv#�)";�(�t��k�k�>�2z)w�5A�a�oP:)����Qf|<��1ѷ������q�e�����
d������AyT�K#���b�me�o{	�d��`����{�.[���U���!n�8P?�m��Xo���n�,��P�������������_~E	K�G�Ā���rb@ 9����͢�QX����j2�;ƌ!�h}���	���%����O\����]gu�2�,�ֆ3c�7��V̷r�̜�)$+gG��MU��-��T/���n�����;A���Ce��")7�~�y`�IDetjQk�=��lڦ�N�2��zۢɘ38D��١�����.�u(&Ѭ�F�~h    L��£2^�b!��Y���㮲kd�@M,o�wx˞���>K�W.H"�^� ��rF)� /�=�G���'W�1hx2̱C�'15*�w���?~F&�}����ڣ2f$����J���Qx��@fr,A�"A��Bĳ=��ˬ ��J*@nQ�=v��um;�J�2n%�`��{;����#�8���DA:T��P�!Z��ph�t��mi�Q�>�lo������G�T��"g$j��N���Ǆ�59��F?�jdtc��|��h"�xC�θ8�SRBzX�j<��q?�����'ߣ�[�FET�����&c���t��ߋ�OWN����jpWJxy��r�c*���1t��t�""���Iq���cP���7Ԛ(��ƃ����Y✮�EB��UC/h�P;eT�����7���s�C&��5Jfʨ�+C2}��	#Y��g[�Xx����"S�?x2n��M	�ߨM����crxs$���q'��i_Q�_ z��w���������n6XPM'�3�� ��~E��[=\��AT6�x8����2�q��)�{����PB�f��ͨ�-X[r}ۘ�<��+�`��P��d!�і�7��0h'U�C��V�xTv���XT(�I�f4�ɼ2�2^��q2�� ��Svw|�Y�yH!Y��fFON �s9$�i�6g8C����f�2�T�����Z<� �kk��)�i�8��@�!^���û�,��nG1"�+]B�܎�|&!7�cN�9=�J�2v�3h@�A)��˼c�����22;�����X�Tv��o�m���83����,��d��%HfSe)"�g:E��3�qǉ� #�9�sz/A���I�I�-�yXK�<o��α�k �Xrx������l>����H&�.12��I���!d������xY�H�uD]ڲ�����^�g�5;�^L�_��s���.{��ta��!\�����z�)'A&�hM�!�� ���$�<8���D�DZX���WW*D���f[n��M6��HJ��lB��kN:��y�5!"��`���?a�k�>\�o��''��|;�?���mýh���k��еE�F�j5]@etmѮN8$V���k;F��Xv&=�K|<�G�H��Ĉ��t�����P���&����լ�^�i�I6-�L��К�o�E��&I������3{V�����	��[D�Z��8��`qS&3�C��q;D
 wv������qgǸ��P��No�:��C&kؗ ��X!c���p��o:=d�G�ߊ��pY�=k����P;0��`��[��N���i܋���G�3�0�&l��335���hQh��~�s�	<ݿRM��돯�?�x����˗_~./`]Ǜ����l��ؾ=����!D�ߊ��)%ӹ'b4P�E�%=>��i�09�iI��<صuL���oh&�N�2�<6K�<B��_��s��kٻ�f�)���c���j�@/���=Y�m�y0�y��V�M�e�1E�p'K��q-D����Q�9���[t��$���%�ߢG�E�[<CdǊ���ǘ�A6�#D+t���BS+9�y��#�rUv��.Dc�ܙv���\CD�*TF;S�����צWYY���Y�ȴiČ�e�?���d���X�%�;�]���e�3&�k�ml|�Od�Ih�朳h5����.��,D!"�$. �J=92Ƴxg�V�Qã��7�b%ꦗH����_c$�����T,>=����Z�h-*[Q��ܟ�;�A[0c�C'�*W���� !⤱/rQ��t��촱�� ���u�SQ�Tƛr �);�*���S�C�W@e��~�Ǎ'�կFm�x����B�'|ܐ���/�#T�%!7{���yTve�ˁ�Z܊\�����?C�n�Q��rfOL�`ٚUnP�<`r�W�!���1�Ws��ӿGM�ͨ�]����ٱ�c+Z'�M�+�Ө�m���>���RA�-� ��\hP��bD�sa�x�� �6��a�с"a*�������{	��	��k�)�k`�<1���=�:��WԼ�%�3����z$ؕ�c b����8���Ub,,i�|X;��΃p�1.�ݽ�YB��@_��<+@�F f����5�u�ɨ�¤V!���^��Q������Fڄz�d7�}'2���B�4��i�������8jvM6�s�-�l{�/����s�,�9!c��H�$���٨l�DD�9���C�и.���E���ZT�3*[U-�#pn�J�[��Z �AerՂ�H�)��E%�ݸ����#7�Ppw�������	�u0d|	��g�!�󁇷.�z2�[QD��3������H�8% -*��8�ʨ�cX�-��fT��J2��B��B�tA�ø����t����q	#!��U�����`0tm͌?"v�����,�RNH�q��i*c�R���nYy�6�5�([��?2M�T�d�fE��h!�l)s�ֹ���[1���>��5fn����=d����D�2��?�퇍�0���M���,O��P^�����N5�Nm�����>G\|�c�t��_����-���I@�K}N���uK�GeW���Dc�5:v��/��sDª��8��*�`m��9M_!d�<�����3L���j�7tP�	_��cBe��"D�U�Q́���2�2������5�u*��YGv$(*c*c2�%e,p��*c��ι��ÿ+cHW�%0�2�CTu�Z�1}o@6T@�@�R�CQ�����o??��Qv�ԷWaA/�C���?�M&���S��"cU�\�xm����q��źBeW����f�E[|-^C$��b :ڨ� �6�q��a�����

�9!��hG֐����)2@:m{��f����2Nd��'����F�JK6;�o:٫� M����"�-V�z���l�'q�h6�-(��9�y�W�!F�^�����.���s[Y�=MW�oFvu�挓}ʖ��S�w٤��BK�9��!H��Q+�M�Hk�CD�bW'��&U�4�-�]��bT9Sv��#G䯞n~6T&X=�R;�	m�7㺴x��Z���z!Bb�3Ic�}����Su�4_D��sB�@����YX���s� ����n��:���|���;��|�RD�O��?��[��үhԲ����?T��n
�r�I'M*��]gO<_vwD����6��f�<�ғ*� y��Q��}��~��D6&"1���{ޠ���Ѫrun�}Ps�I��ͤR}����2[�J��|�����e�		�YݦW%T�<<c����C!�W'$T� g�Q��q��YY�'�r����/����y�]���LY�8�N'\�@^���_�Q�,gF�ˇ��'�dq��g��������������u�1G��l���S�ڬ�O��
8,A��$9"1�n	��hzR�&��9����Nc��Ɗ��=��F��o�bL�;�s��9��V�K>*23;鄑ō�4�Pw��#"$����^Kfm�NQ3$"d��!�%�����g*�tQ߳r��	d��%JfG 1#Q��ĸv/ݠw�NN7��A>�&c��=:HZ�6H��kMi\bewS
AٛJM��1��g����2�$>��vm2^�����h���L6�"d��0����H-��l߃��d ��<e�;XL$��bb!.XL$�;ZL<f��D2�,�s�HO�����H�ʸ�_�IM����N�S�u�HFQ	Ȁ�x��1LV�"[].�ʸ��5�=��kА��dq'(��K��\y!"���nl���/�wp%WD�Cj6�Q��5D��y��� �QjTƝU+Ĥ���p2u2mFel���$��A�*�5�!b���iN�;ށ�5.��ʸHx�m�1҆���ʘ{$��[NF{����1�b6B}�|uX*���L_�W1d�lɺ�5�\����t#��P� ^�B%��Q��R~t�E6�5CԠZUA7io�'��8��_�&[))&%짥E^�n*    �Ԙ_��c�to;��>%�GJ��]�n�h؇Z����l�g3��M��a��|
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
��1m!"�T��'�q��A�m#�{���;��2:�0Y^�Ƞ2n[+	�#7A����l�����|��h*Q)��݊v����M܈K�'�}Բm��*�2�-IB���g�~�0m��,��e��{A�q�f��*[A@���)�,�b���ܖ@�݃x�+ǧ�������5�����͕�h�y�6:��t��Hϡv�l�]��v�_St�bB�5k�DFQzT�n$f4h��e���~���ӯw%�×������<��-�Ɵ�^����o+���F j��;� ֒�� ��Eĉ�6X6igP���Zh S&����TӖ�=�D��R������a��A�`}a;jK�X�q���K}0�kƹ��EJ�8����R��(�d�Rډ*��KI��v��]�/q�]�F�m|yP���k�6gAe�k���
�hI:�u*�]��:���s%ݲ�ڠ�Vz��$�k��joaـ��������JXdh8�|�� ���M+eт9K][��U��a�M����$�}��MF�!'&���[�-�cC��F���dz��S�8����r�
y�t�6�2n�����3Cт69�rœ9�K����l�5hµ^�YT6E����QcG;��7��V���̥5ȓ;���}���1����g��M��O���7�U9;%���	#�Ϙ�q�>�3R�+ߟ�&��}r�4k6�s����%0n�'!"+m��Bڠ�{��,�~�����.L����&俿����2ZH�آqM���ܑ4*c96d��^����LӇ�g%�YK$�3�O
`��Zk��yPBF���s.=�Y:ȸ��C��,x���q�=˝���K�d�V�Y;���D��Ӆ�2��2��02�l9%�c��d��#��ӊn��±
�����0x+X�ń0
�*O|�|�-�!�����Џ� �f�$��.���M9�X§a��Y��U���.�1#a�5���[88V2hޝG�.�L��W2����4�6����Dn�P�H�5ZՎY����GeTU�n�{��Pi�Q{���^�k|�Y��F�%0�@�8ɝt�ئ����J\�F[:����{[@�&	����l�)��3��r)Pw�t<�Xl��� '����(*cO��t�Z����l�"G��&(�S�dLF�Țh{�xe�mDB��e��Tv�`��&n����Ql0��`�P��e�1`#]�7xPc����6٬*�Ϸ��YPP��f��x�e�D����=_B\��?���B�@o��	�/3?d��?t�#u�|�l�Q"K��~�BDb��;[T��s����s�];�冊Qe�Z����8Tv���!rO�Qr��̓���;�<�˾�˸�C��	���s0h���g6 ��x�BD�����5�2��Y�ۈ����BVx�Q$ǭ�`�V�d<7�����B[7�|!��cJ��{������{JDUQ���l�wMUe�!��d����9�k���G��2n2DBϸ��\[�Ѡ����V2������kq�Zt��.�)@ݬ�'�娨p
?NAC��<Dn��QV%��8�+���M�ʨl!�~h�WIM�H*�2񅒹Y8�V�L��G����7���(�%��%LB��KQ*�L����T4�<J�\C�a�Q؄j8ާ���C�xj�c�d��x�s��$����B.2�:2�c\�"?�|�2:�S\���	�����bH)6*�vvwbg��F�].Hx|��*�(�'�ɘ�v�l��`�گ������&!����7D�����/]��Vb�#��rG�0�.[je���pG��E��B
,�2a+[⤕�`�f��Ae3��Dӡ�&�}r����qi�zs�v�/��ܓӖ���_�eWM0{��K�5-Ar{���r3�������d�������պ�mR��*8T�ɔ���:���aj/��q�͓2��L�y�)��Ej��i<�8"*�ORJK��zl��t�]6���/=�Hhd7뭥!y!��Fe,�PHH�9�6��b~��^@���X�?,���%��F_�,g ;4�5<�����]�6��?L����4��[��x|�)o�뱖#�����;�ˮ,�7�
ơ���"6���..�1ы�\:|���^Ļ��"t���
h�/ dz�o,�qn2��[�81Y�Gй.ξ�f�A���V��l@�ƴ��`<{Y�81Yz�Wk��{�&��5��H��s6��Ӕ��7�3b���}�	'fU���F��}���}�8Ʈ�m@��X���#�� Y�<R�Iק���V��]�L��1A�!NfF-Ar���+Ynx����J&�Ū�*��VVryi%O5;=7<���r�u���s���h?u�[�9���N3�sO9���0�.�Δ�?ў��.��A��������@���Z����5��uI]]J���q	��Ϗ�E���������O�x�����oO�}{}���up�Y�C�V�*=x��Y;��E�Wp��L?�َ���p    �!��4�<n6��f73�;�㶭�s)���&]<K��,)�$�	��E��+ũ���'t�p�t�hX�*���RƉ���w�?�dg]��}�bZ	kU2h� `_���~qQ�x�dr-(o� ��ًZF�.�]&�2���-=��
�6��=�����~�@��-Bt��-�Ee�Z* L��U���?>�'>�*�U���}��SY$����Z.���Z!"�Z��T#$����i2�jލ����C��,q��11!{-���Yd���"����A-�٠̰Uve1O'�woB��,Ƣ2v�����0Aۤ�������1Ӣd�u.S�5�ttdL]�١����Z����
2�2�.$D\}�򆻋ox��vS)%t>��#N2�q!� ���rA4��#޻pb�9��;T6����-i�W�l&G����<�ev�Y�\'�����x.�P��C�� #s��<Y�e��B�$���W+D���5`��H쟝&��&��1m�tH.ai�����+&"NLpDc��a�A���b�N�ʛ������ y9�Bĕo�n�s���7	դ[TFEԖX�&g������8�0<⦚��1̝���q��
���T���r�83
����W�)D��胧��	�Q7�����M)�-'g��A��2�ɸ®��/���&�2���-�\����q���t1߇勇Dy�S�:�c�3U��!�f�M�4�aW��_���{&B;��δSxT�,�2��
�v��T6�+4�&��f�e��B-0�0�.�A+$d�\7�ܻ��+��*)d����B��|��zg�U�&c�\�)	�q��G�������ϩ���� ���7_1�f
��*(8���	ٳ�*Pן� �ώ�8�ՐІ�p��Q'�<e]�h�3��y��?Ș3�	�٪ZY���=�5�	"�L�����؇qG٬��8*�o�#��F�[��2Dha�v�:�.�����WH"ܠ�BBmO����ܨB����x��Jܠ���!�`���-���Bh e�W;�d�52J;�Z85��}��ɸ�4�ei�� Y��V��Z[���2�H�;�%ԁo�q�u$�	tqS*k��P#Y-���/B�8'�(9��=�2n�6�E%�7�~��s���s��Ԩ���!��Z/
g������*��Z�-�D��o���_n�3=f?־o�Ĥ�^<�5�]<2�I��`$z�ҹ����#纂ڰ��w�P��=�d[�2HZ��o_{�fTƴ���NN��F=T䌭5D�� ��o��8L{y�N{�-䀍���6n^g�{���i�
��g1'��i����� ����ç6��a�Ā��lH���_)C���3:�c��'Tƭ,�����YϺl^�ICl���&�1�Is�.�gݟ�&��rb*��[9�9�~2XC�����N�5o����q⡯%N�>��2L�����ko���n2f��ǿ��4)��kA�w��~�><f4�le�G^��r"`:G<c)P�5P�'W���������n�l���#��EE<~�|�*�K0�/L��g���Mڒ}��
!*׾�-1Ͼ"��U�r�]�3�k�f��:M�r���\�d N�����P�����&�&�`�j`��t9޸���K��A�>�;fB|/<L���&/GH��0�d����ZT�r|"��H5)�nN��pgs��	(����f�#B���ɮ��#b����]�㢓w|=5قIL�u"�8�N$e����2�AW2�q�>Fc7�i�O囍:&4������}���-"/P!D�d��8H��?ǻY�ch/��Q��i�>{��G0�}')6�ʖ2�x0I��K��P�p='����x3��V�h�=*N�UwkH��U����&��T�c��"*� ���z蔍�.$�m�u�R�4)g&�#*[1�Ũ\�}��<�]�Hl��z?�.
���y�2�nm��Ő2��S�Q�7'C��� �]7�]�5�HJ�4�G�z��#��N�^�l]U@e�"�<����!}Q������K��"{c^HVm����w7YW9�+�)��F�=I��엲�xw���������ɻl���u�Qk�
�Lƽ���"���"Y�8in�k� -&Pc5�&M� ��'���K�\�XF��$Qk�4���Fe���߅bڊ��E� z�̀HV�QӉ靃+BU��ʘ��jOs�S�x��!L����0G�Hw����s�{Q٤��.��ﵮ)A+�fjy�c�K�"N��i���q�1�X)L#�t
6`�9`�ޛH�{#D4�D��AK�هJ���̥z�T���o@��U03��H%# *��S�!Nځv�nuc 5Ȣ2^J���0ֶ��&�g牓C=2k���<)!YK�p�8T�恹���[jC1����{}��D4��ɿ�hH�M�@�J�9D,����;��PaLK�?�GT�$�<�@�}���{=�[�[~��>�ح��;Ӵ[wKI{�+	}��12[�Ik3>\OnL���B���s�5rO�Zn[�t�h��'��q������q?�*	">[��f��C&B=�J0�º��PhLw
�s�	��`*���PT��P�>�be��rmS? �a0'�<�q����NN����Gjyu�P�!�қ���}$B���]�!��ZT�NN7}�qBAC9?��'H��%����1q
�*8<*�ŧV�[.�l�E�*u}�q	i@��������Bc�|���r>����V������\%�4�_�j�Z*\����UR����U���Ce�:̡�UÌ��lV-)L��c�4�倉�&��X��Ջ�V�Or�����cy�A6��\G|�t�_�q���# 8��ό��q�o���kQ���;DH�W�s��h~�';�Q�ˋ$�nr�&C�`�#*��0ݬ&̤�2Dh(L�]Ӏ*��5BD��q�\����p����܈��j+��E�耒k]��ݍD���pnjkQr?����w<\�.oн
M�4V���Q��V���Zh@�����@M5�3+kч�n�ʳ	��{p���LΨl�wk�d�
9vSƥ���y�9%j�.�S���Q�0�EmT�{�&�Z�o�S���]%L��T�%H�v_Ge墝�2s�D�KjZ�T�x�]vIM������"�XP�Q@eԴs�Y������ײɸ��=��� 4o�E<8CW�/1r�,���F��׀�Ae�+���x.n9�@��we���D�)�J䌑�D�'=���F���]vv^�/�P�X�\�*#[�~�d�5Hޣ-D��3ލ��UT֎��ק?>})������5ݪ(gф�3T2^��i1�M����$����̀(9�f���-9�U�R�%0��%Cd���ޢ��s:6L.�tTx��s1�[=L6d��]$#�Y����|��@'|�s�`Ld�A�O���lqj]��Z��)i��Si�Q%6M����*��%�J�ʵ�f�̴�������њ�����;�d����泎� n�;X#g|{����;���
��x�I���.[l������h/5�����P�$MLƵnf\,�FHHg0��C};��]6)����f�x�-���E�H��ˢ"�;0v�;C�f�bĻL��}��ztF�:�͹b�������Nq[T6iRtpNq��>KX��;�p��K{Ϋ�� &|�� ��M��Q����/�{_�.e�C-�s����h넜���rT�CE�SPv�2�;``�),K��P�������I>��yg���̕uF�.�*�C���Çz���Pg�?�)b�4}E.~���d���c�=U:S'Żͪ=�N�di/��?PMƩ�N&���1���֩�r?Ak����ɠ�Q�B�����?'��.Cl��]����C$��=[A��!�3���ۗ��N��	M��K�����=������YL��Oו�?�zz	{�iuu�V�l	w���Ölt
7�    ��%D�L�ȅ\�@����]6[��c[[� ��v�5�]!yѠ)"ϫ,e����:�k���l�����&q8g����wK���bP�D��p��ZgP�����iX�wƦ-�:g0��mSHVu�QO�,�;AŬ�-H�Y��ꋐ��!su3V'4� �X��aP�LG��&U����i��A2nO��:>A=�
��{��!2ߘJ�#e�d�tks��~�1�I(��_���l�X\0Y��H��U���X���ȕ��[m���'���Mg��	��ɪ68��U��9�u��q�]�.V����~3S�Oy)�"B���<��61郌�!Ъ�e�[��כ�:��F���!8�d���k��A¹Fek��A�F�jS�D��c���١*�֣�MQ�#��j���V����(Y�WT�!@~���a4�i���V��+�&�fPHɜXt׮����$��IA�-x����/ͻ������/&W~�+�z��*�|�zHG�Y{,�v�R�q^���ͤ5��RtFe�iж����p01��6� J�G9c�}�2�Ic�a�˯A�hT�l\EB�T���-��~��gXG}��	����S�ϟ��Eڿ�����3��[9,$���r��pZH�K���NqJ�9ۚ�x�ʰ.	�{�����:2�m:��.��x��	�!j��D>�jlZ�ʰ�{��mh���m.��� �j�3�����`�!��G:�����S��xl��3re���L� �������S[,p��6~k����!�Iuw!�7�rG���Ӎփ�"�7
Zb����<)�'X�I�"�%Rn�]���.���~�G�l6O�!���Y��o0pޠ:7��q�W(F\Z��_�w�|����ծ8*n��H����\��¼>S�#��u�.9��g����q<��~�Q���o���Hd�:#�m�f�� $��,q�<3�1Y�'�ܖ,"�I��Cf��{�d,s���O�i@��V��m-�(�=�	V����<��Crixd�+f<*��ɧ[+��`���C���)�P��N�Eh�<C ��ǡV�bǓQ�m�x��Qx֐Q9�4�2v�c¯v�4��;�.;������A!��LT�2X��I�U����`U�`r��q��)o�q��ҥ�k��c���;p�{��.�9'��&C����BJro4Z8�������eg��=��V�8�p�4�1�E�G&�@! {m�Q��H8P��xm�e��)z��`xe�'������zP<M޴w^���1S�N y+)C�TL5��C��A�S��^���lʽ�a�{��1��de�-ج�B�mV�$��gE5��ͨ����a�鹰�MC�&,�X��n	�?��3��(����+���;^~yu����ߋ���������l�}/֊
��ݢSx�����>w8�Fe�������D5��8(+r)\�E�1�A����>�n��\u_*�;��y�1�G��ZUT�Qْ�J�z(�3�'� ���ks���7�f2�i{c<�Cµ�����G�IT6�G'��|�P^�Z��_���m��wXM�B�lL�����9���'�n�C9A^?�D9���`�p��atk�kQ/�#U�%N��TH��,HĨ�V,��i�w+c�� �g����-5�������[j4��Rc ҅�cP&��Y+w�b�; ������WJf/���BJz��|
5(hP7B�PI���nΠ9�a�!"NFp�ި&�2�f�N�OF<��B��sQW�yݘ.��.{�s�!O[;�p�s�7.�ʮ���%{�n[瞹ˮ��EwM�.�B�G(&�:ru�Ce����`a�:�k��@���9!� 
pF�-�9Шl^��f��4��j����D�/� *c��BF���Eh�ㆥ��})?����?^����a�I@�(���Sr<���	�k���"��P]��͆G$�jm�s�]��X�%0��U��pt�'(0�	����_�(�����9�z!$�(.�w0�ϐ��7R\��E*d���,;������ CN�Q�Hcr����Vme�2� ēU�[��M��y����Z���.��Z:�vn��qs.��n0@��UV��.��Z���YBD����������*�������g�C%}�K��2!"=�g4�S�i��M�����C��A�Wr��$w�q6�=!9ɣ2�d3C+-c�KhO	z���xqR_>������q���X��ٚ��{�ߠ���G/���ɢ���
o2�>	���-g%Y�G��>I���ja�0��$�)�'9��Y��
�5 �Q9���}}�xP�����*�%���+y���PY]�w(��x]؅�I'��,@�O.���yV48{���o&��G+q�1��[Rw��?���♜��/q��_�'�.�qBDã2f{�<�$�ːB��1�@�uS�Yn*!�D��

�뚧�2n�>��%�5�>-���$/�A�'骽�&�<�
vى#����C�4�� �n�GFel7����j��ij�ZBe��5p��(����9���H6�\c	R�IADo]��GeL ��&�s܊���#���A�\ RD:U`���?���eL���ŔЛ��h�T� Q�-%E�h��c3탌�����F7]Cpo�VE��dd�c�AeT�2m����w�\� a|��Z6�$l��r[�ҝN��I
�9'����Z��L��r;m�A�M�Тi�+*�W��o=�2c\P@TS"��B�ڻ��
0
�Y���4?��2� �O�P�Y�Aoͭ�y���a�%��D>Or�;~/Pr|�'�,ߴ���!�����C�� {��l���?�iO��2Y���L�K���8k��lU!b�J�,���n?K�R.7���*���~{������]��0���CFoY)o(Pf=�ΥQ٬�^����N�x!F�ҝ��N|�I�L��C�T��G'��ޗ@�Q���dR"5�vqe��=�7̷c��K+(��y��O~�<�c;���ӄ�3�:Ja�S�k�&���iN��&���iN�.}�'�9ѡ�0Bzݝ�]F��0�2��Tr�|�ơ�Df6�?��5ח!����#��c���la<�G8�q��Vdo�^�������qW�m�R67+c�47�\#�Hq���q���"Z\���M�r-�2�޻�4a��sɫ��ƽp�r�������X��0^B������<*{�m���ͥ�O Y���`�Oɸ�<㺴�'�k&�CLX�&l��.�����E�q��c?�N��G��fW`�v5mɮ&��v5qEC���1:{�	5DS��y�.��e4��\C<E�u�wM�uXT�XD�n3d2��Y<�>���5>�"�C�r1�^���0�#�gb�oq���.&A�KZ��2] �z]��[(M�W�����\2V�.V�!!����T� ����h.n1Gp��Y��C�_[����D��*�q0@��`'B�z�&�}�Qe+F�U[��*�� 6֐�2^���1�i���5�A6�H���&&���,J���㩤BD���i�\U��6�B�|��WQ�QN[�I�S� ���M��M�&��d��'���󛟵Aek.��{����9:��5/�3��eBu�E��ΐ|ru�Z� [^?��|6p��m�=��m9
R6�5*��:�Õ>�e��펟%*��x	�4(0Lbe��=���x�q���{w#�7E ىvo҉ u![r^i�U�i�K�ӕ��Hw��r��������Nb����ra��H{� *�%��Z��G/ ȍf~�-��#I���3�Q��&�u��.P=O��D0���he;I�R��N�S�����s����],E�G���4�]��E�W%eh6]�E�6lBg�Er��(Ϥ"�	٣�����q���\C��F�ks�B��@�u��8Y�!�ʗY��?�����,��ߴ7�b~��/sz��<C��^x����]����uv�VE��a�S����d��"��z��zL��e'oп~� Z  ��-B	f�߲	�8F��&H��(kb�sH`�G��Y�;��kH�+����K���dg�_wU�"�Ѝޜ��8�䨺%H^� ���81�����M��ex��fUp�a&F�c���Q��+E$u�a�x�]Be�ɉw��!>��.�N�!V�{+���>��s��ӫ��}��Izz�+0��tWN�X�����F� {��?G]�{ra/��	��EK����W�����?��3'!�������eȝ���sC�BŐ#n��!�%0�M�8�+<�����M�&;�!ߔ]���ͬݬQM���h�5N�J.�\���X��V��P���-{�6�]�g\��p�EBxwٻ�������A�t��!Bv�]}9��!�����г�{����պv�	��3�51igB���'z@�()�@w�����ԑ�\���]5�l���h>��[�@�d���G*ud�g�
���C� �>z�M���������ަ?���)0��xu2DK�}��R����j�e���asC��?��
�p�%�b��x~\!�W)�*�]&X�!N�3� Ƕ�q]Z�9!dԢ+cV���r�iZe�zk����}�|��\91N�s�*7���	9���G�0��X)����S��DU�&/7Q��졞�Άg�-����j!ED%<�l�C=w*�ʘ����~���@ek�����h�%PSE���5E�w�X{����2J;Q�����~��L�a�_E�κ�b��݊�u�5��qfT��y�X��m�D��Ȗ��c`�)D�{�첵g�z%��á7��-��P=�Mr�����Ŕ\��N��]��=��}��L򱙤�k0�����~�'3��0c�mY*��$y�3�Ѽm��m1ĈVdGr��$3*d4t{�!C>Al�+���N����?c���R�Xj�����v�jO-�sx�i����<f�40�6S���.�� ���(
'���*@�YET�6��2E��:���ړ��%0^N���h�xR��=*[�{!�)��C���jL�-��Q�d������Bv��Ƚ���̲�/�&g}�a�m���DC9A�3 ,*[Txk}��/��O�������6���Bq�w���Y�%W��� '����~:G%���� VA�p5�č��%(�v�l:�*�.6�o=7�1wR�3��Ș>!�ǭZ��e��@��x�ɇ:����;X�a�Y��c�=v�p�,�"Q�^ʧ����YM��_�&�5�ɣ����^�k`��xl�/���=o@����q�s͈�u��3hn���Lp��>锰D>K ?�34|l��i��)_An����� DT���6��Ge��^޴�q,O�ķ-����F��9V���)5z�W��}~�����F�P������0���=�~	u�ȸӾsj�2�x��	�}��m)�����g�7!���g��mHĘ�N)SH^�!��;�(v��v�	L`�ּYE�&Z6�I��'J�8SO�x>j)#݂|�e+��,�l�Ӈ��#em�m�c�K�ނɷ�2R}��+��L�=�ceJ'����@�3wwf���'Q��f�-�h�,�@:���X!�$��������[l�1L�7�R�H�[�B�b�RD�<D�M��j�+��x�n����h�A���@����|�_��%�90����%!ﲓ�<Lg&0�����h��Hο� ��2���b^Č��{�+*T3*[�{[|j�40�ր=�����8q�.�O"|r4f�o
v��1�.�M��T����Gq�˫���dc��O����,��>�$|䠏{�,�������9���̐��t�W0�{������>��      �      x�ܽ�\9r&���|���_T1IF�L�2�Uƞ��R�4W}�Uw����/����q2��.MI��p�De�/~�_�U/η�������P�O��*�"���?I�B��BJ|�B\��߾�����z������B����R�WJ��di�I����}%�+#^x`����o^�����y�����ן�6u��2z������c��F����4������}!T/*�K)2� ���
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
B�9�\."~w    z7�O(���Z�`XQ���M�5����K���t~7ML���G�x=_T�6���Sj\;5��
�~�n��_Ш�t�j���}����h)#�O�eo"�a�hE�|�����討���@��1���նo����\g)]��c>�>~s�<E���<�S�{;�����w��,�,ؘX����2h|5�����$'�)L|G��� ǎt6�wP��2:���/� �SV������?��gvU��{>j̵�L9v��	��Q���2A)��oo�o>㶅�/??�oO���B�����j:�'�m�CK׏O����}{�k\y�T7�)p;v[�`|�ߨf��o�F|R�3~��G�G|�*!��]�7z4�+���t����^����+��ޮ��]�l�Ď!6Au"�سH`fF�[+,=�$r9��'v�W�B��|p�� ����AY��١L�O��X<�@�Ղ�G�(�Y];vg�	�Cb�6����^v�2-h�$rF�ݻO���&�W	��P�8%q>�c�C��\k%ֆ��px���m�V�����n5���%�;"ڄ���'�9Xd��;`Bs�.m/�O�'c��C:a��ɱ�?&��{:>R���˽��w�?>��>�h8����Zɔ����C��L�"������V?��3�Z)�^,�9}��@��_��-�>��u�}����"������>�$r��8vj�����f�"�_�ؤ=W�o���%%�o�4�	P�)��
;g��sV�b�b���>W+u�0*�Α �'Qh�y�ر׶{��y�SΖ���+����"g�||��}���[P ���m=�,z06�C�Ű:�"g�|z�w���iA&N��K���z��]�I�U?�"g �	%>�}�y��A��`��c�j��L[���sm�U�u\�j��洰x7��"L[a��2kS���X�uƒ��x�J=����g�]1��?��Y;X�)K����t9�b8Y�ҦP9�ƂRepL��deְ0��$�t�,Y��6�Ew2�r�b����ڧ��r>R���_>U䒊>�OD�<���(T`�=]�9]nu�j����"ؚ� ��I���y�%m�%+)��%��Jo"���J�M�vJ��*b�(b�z��/#c&.K��2�˲����3�6�>	4�ZnDvly���{I/��MVx��W,J!3?��i�ܤT���bU��p��F}T՟xf������F��s��f�]{v��U��2���-���9�sIχ�����|>3a�q�����@vX�eE���#�	�=�B�X�N�t�2��l>�yk��P��Qi�0Vς�Ɍ(-^Q��N����*�3候����&>�T�L�1���%x����_`6cHb
W�d4HV��*�2s����,���z�� 
�:o޸vE(li��^�+|U0{����T�����{��s9��w�ֳ���b��ȫC�d�¥����}7OE�XL$�1I�#����uY��=�h`���=!�,`~^���B>� �K�MDeL����:���A�X����u��+N��~/��|�ޝ�2JKo�I�Yu�;�eu�}���z��у�,�9�aW��2�$l.8�Պ�\������Y6��u�.+�$�(�@�(��3��w�@�nY&E��J�0G�|%�ܳE��.�a^T5 Ys��(P2a�{qlX���9^�\��ݙM��|�i�s,��*Sa�	XT�42b���������H%��eb"I[��r��% &�dYlql���./	OG2s�^:�A�9��#H�۔��2��Cr�k��ǋ�d�$Կ'�+JQ�3�n����C�E��(�6a|�D�@�E��$��Zcp����qդ�Ƒy,T\������6#S��c�[�Xm�o����v�d,�6*�����̠8���mF{K��lۈ���d�zȖj���[�d�/��f��# &l��=/����΍\�T���hn�������:Xڹ���u��ڳ�).*4�ť�eJ��_�Y�ǀ�k������,謰��t�0��s�\M�{׵W�O�-T�>�����'��y��#�p��c��[�%�qr�JQKd"��̨�__�wa9�L<b��l���]v�3ye�+;�����Ej!߾�e�sE
�E[����E��E(S'|��~�sENp^��af�i��Bco�?�ֿ7��ڪ�~�y������$r���ͼ{�	���@R?�G�4G,MPZsZ����¡�O]�Kҥ0{��7=It����)����m?��8�J�X�`�xs����x0}��
�*'�~+kBh����v��怫NG@P6�����|����F(J��}p�v��^l}��L�G�c�0hL5����1��a��:U��C���L�^��;�I��33+r�iv3��h�y3��V��#CJU�'k�4)N�#f���➝�lm��u��V�#��RZzN�`����ۇ��o�`d���2�^���6�9��)�	�a=E�U�[
����Zz�a�9�1�ѓRoNc7�q'���P��S�����4���Ykݢ�%� �o%>E~�`�Nb�b���%�`_@,�i��i�e�	g.K)#�]7�~�@���Az��X�\���#�*��U�aތmP/CLt�3PH\ϥ��
Ph+��1*�PX+���g'���2�5d�x{�:RC�%��H6X�j�>c�Ţkw�����<z,U�e/w|�[��T;��GD��������"��p(��;D��ƾJ[P3�I��G
��.�𰫾 e�@��R��~W �OGB�C�E'������}Ut�v:�O<�|4�r�>�~~�,	
����(Q��z�RJ��5�����гV7�Z��?�c�!N�1K��_q,��,�z��ŗc���b�AG��P�o��#Ւ��H\��H"Q�ʕ��s�?x7���X8#�Y� �����v/.��˩�Kl�8]�O��-�P�x{�X��7�+qة��0�㑾�$,fn� ��܇�Z⌕f=�X6q�ZN�U�7`�_j���J//�`S1�p��be�З�f.�d+LW����@v�C�����^]�0��3y��hʾX"q���H<L���B++�,�9�|�bY\�Ϛo)�U���>�Ӿ��&e�|\�,���+6,>n�ۋ��E��P��;����}B2��T#�]�15�	�������3�H�-&d�������lgd���F|نiԩ%���	=�ɨ���0�2����v;�Wꋑ��t4��z��tʯ�D+"�H�����⸪7�ӫ���q��k���#E�:�Gj�I$�zqi},�;r�F\�|�[B�C���_p���bӕvF=���G�R=����b3���`e��є,.��#�X����X��6�v:ݷ���M��[\�+�<�#���:�aÒ�\Gq${��ޡL6Tdk/'��@f׈��oٕ4$�.?��������s�\ȭ��J�����dq��ݾ�#��Gl���rlo9o�ΛX{Ց��w�Lcw㶍��H"If�K
Wl֙0\3t!����"���$e�pb�5���\/�1��;�����TԿT,E ���<��?4K7�r*� �X¢�:��@�{��kU��pH�ùTq9y�!�q�t`Y���m��>�u�Q�,3}�E"K���b��$��U(:.:%��p���B�/����T�B�?�,U\�|_�+�謉dŸ��]��g�Z,F�2��6���ҹظ���)ha'�Au�?ˌLX����&�퓍�`I)��'A�-���%�P��.�wX&K���Co���Wq-O|?}g��g,H��D E��u�"u��2��$C�e�\"N s �W��'a��"bؕ�x�*>����X��$Ò����v����f)�OW4���ڔ/x���P1�������xe�}�8F��b1ե�0��jKދ��+��/����U��%�qG,���
Wx�z&Rpl�e8�*.��Y�)����/!��R����9�M�i>���a��%('�V'��Bms2�b(S =  ^/�b�a�5P"�%�Ƶ�o�B���X"򇒮�a��°0].ް����R�~�a#�n�dlʒ�g30�e`�l��KY���!r��r,�Nb��"�I�R�=��S9p��S���S#���|*���lr,���T|.1��E��ZXT�4a��9лT��I����!�����e��]I���{�|�w�#���;ZG��!���z=��-����T��T�`g�A�/�$�jp�֕�S�u�*���G@���"��k�Lo���`��x$�����Z��9�x ������n��>̇,!�3�7qA�^��y
�q��}4���ݹ���U�`�/[LqU0Wg�d}?��Wq-����Lh���E�0˯�w(��}�vx8��gũ�F�^�b1� X�j,�h�a��m}�nXf`��U\�����+��H�U�`��I�� vx��<3���[QYp*�Q�,.P�V���^�ť��L1��
��+e&'X"��f�ȭ�O�4�}�+�"51⦄$��vy��m%�G��L�����e�v�#$��%�Ԉ�N��b�{f(3�//�ÁZ��#�ˁ��L��H�[�6~�Wav���W�*�Z,�.��39CO�)���{�S���lf�E"���T�v#�,�`��~"3����;ba�s�y[�a����0��7�M�Pd#)E`'	���|�;^�%��M�R�[��P��H����j����ʼ���{l�Ʊ�����4�w�(����W��ٲ�ە%��a6����~ќ�x�tC��p��r3�xZ֔� )~`����ݩ�����]�Ǵ�Uk��=?����K޾`=���Ŏx�xct=����`�Y��a�%���<z��c���by���{���H�2�67�C�y�o��1�.�ƘO���~��5�'* �#�'�] wMtf�M\{)N���v����������$��z|�y|z��'70��p��38�M\��|�e�2���x��yqe���7 5�h�F��~)N#��r�h"R��+t/qe���/�2y-�%��+�|~��BR�S¢袱��"uM㎲|����Š�gF�d��E��2u]!pp]Ld�n�w1���a��mB�ڎ�o���A.Zd8N/�$���.����j��,yהf�&��x���\55+���_Y";w��j��w>>�ď��0f�#�C(I��v�I_�0va�֓;(�yQ���kj)��q9��_� F#�Vr�);.��:~�C	��8�K2&����P�oO��de1�q��=�/�,o߾�<ge5      B      x�̽ےIr%���
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
Z=o��!��!{�Y|��S�!w����'�?H�E!^��z��}͏���!C&��b�AхZ<P{	�n��>C�h�=�~6��S��>�΢i\����mI��|fE����f���2<�ȉKR�;������t]Z�:gd��ס0 ����HK�,'�#z��9��f�mQ���������H?�9�G$zzї��^zn�t�ϴo:C@f^:�z��K��Lːo�E�WA֚ų�k>�I/{��9��U��}U+�H� ��Hn���	/��6�AOK��j�G�Ză�S��H��������b�ᝎ�NPY�0(�B/7��T0պ������@hΡ5���v��!�WL��D�*n`M�s��Y���$Y����26��N_,=&#�H�vݾ��<sKh���\��D��!/d, �T����N�
�N,���a8-�c�P����*��6y���Z�0��6��8�_m*�ڎ_NL: �2�����Z�y$�YB[c��3h�k� 8�A&5��`������A�4,hC���m��!r�*Y�����ö��b���י��=N�晞��O 3Q)�D>�O��}}��!q�R��Q~l�d�9�L������1z�+����D���z�!B�5dTy'��1&Ȧ��?�<Rd����I3"���h.dQ09ʘ:f�ɢ"��%d��j�y�Eӿ��@>�E 륒��*�6c�i3"��%/��wt�3b$⸾]:��\�Z)H���@�I�V.^�͜CL:�}�A�>F�fs�7��a��a"3� �M��C�}��2S��ļ6	tE���>ZSF[��K�`�c�3��V��0���C5mEä���1��7ϭiv6fN�L��
?�L#M[��r�1����
�-5��1�, �qs�AC֏ei��b�*��<��3�m�q���Yw?ܼ��
Rh,Kk˸�s{��	������˗O��sUA�eim�G��J�L �HO{��m	�����x�飖�>*����\H�L�<,�Nڴ�EG+���D~a*�����y�jNz>�P�v�[`�j
����F�uؐ8hYX\\�0��;!��I�LR��o���:L��&������@�D�t�J�AOJ���?=<�eƇXc�~���ǖ�����P�F�9�*��x��ȖEdAZ�6����H/']Q9�=W����&�.i�0K#y���Y���Y,^�|Q�1M#Ozp⹑�ݬt�ٲ�$��B۸���$Q��7}i9�>W-HT�������A�,�[����3)D�FB�Q��ͅ��W=�Ƒ�y|�����+�����ccn�:+����=W	!�Z;o6"�NbB"݀8������u��-_�7BV�X����iz�q ��El,D�X��V�zeмCC��J�Xā���h������4��;"����g:�AM�*a��/�!��H���|����-�\g�2�Y�jD�����B��H��\��t�7(��k��2X/|�w�b�| ����Mi���O����IǇCd#�V�@�����Du������&e���iv�f^�ow:P����*Ħ���s�G[q�+��";W�3 RQ��*H#�F��mND,3��7��)/)�OB�s^�D
9� c�jb��;�Խǌ�?3#���+`��"I�V���M�H*�۾6c�阽��ț<�n����}�vz8b��
-���@���u��d܌�j^_���%�t�W�bB"��
��:�<��V�*��ˉ��yF�� $��R���w7�`]mFWq��<����UE�q�$���"}���{׆�0f�ФuN�/�Ð�ې_G��	q#�%S�C��x�j�盏�(`DѪ�Q	{�N�N�5 ���QE��	.m��.���.E;��,��*ӡ��ŗ��.��-C�0�t_��N�����S$���8��*���b�
���lCX��P�� 4D$ wd![$n�����X2�ڼ9�A���<��ǲJ"2��>6���KJ�4G�}!����a�zϨ2�$ϗ:�	�4L;j6�K�ٛn{f䜗���0/��:_�1C�\��s^�g�"�	s��9��	��q�s��E�Fą��� ,Q�]�"`6�yk�^��><���1��&��)g+w3����srw5mpw�]���k���d�;�5k����cT�~��Hs�����˽|:�~�qn�x�ըB�j ӣ�@�l%�*V&��!]�
��e恲��y}C���"n�-���!r�5ox�%�WB6�$��Rܛ<`ĥM���cU ŷ�u��e�~��.�ö�s{::��G�qH�5�tmt���3�B[�l�W���]_�|�Yx�ՙ&��*�#o,mC��o����j'X;T�����c2:�8�fK�b:J�8��l���'N4��I�4��q�h�m,LBEe�����W�X�+��q�z4�7r�c�^g;�1�ӊ�vI�hk"="Ӏ	�i~I�_�&����դ�._��G�J��(&¦G�▏�.���H���-"�"!���1�T%��A��k]�V�d��m��/'N�����4W`<��C�W��DjBlYj۸}��w�2��eF%j����L�֍S�����Џ۶:׃]�����/9�e�0�f�%/�B����[#��l�����餭~% 3�|}	�2��^ƶ^F�N�|���?wC��k�/���k���p:?�,f��͸�W9�_�y��@g.�ȝU	 �3��6К�D6��A�	�ėwR,ҕ�{<_ߊ`�xxHȤI;ݧ�<���$��roC�M[�����I)ĿC� ��-��b�@��	0�i�Q�B��(��ʶ�ըf�R�za�&@e����JEKr}#}��Z���`�R�}tlÓ83�qa�'�Q�q	�4'�i���Sy�[����#SX�0T5K{���_@��>�η���c�9�b3��j:��b�┡sv�s�T�5�K2ی��RG�(!]�8>�u�C���>�6Z�/z-���m����Y! ":�h �����E��KqE����DGG�%�c
6�J/�e{w���ĝ6U�L�W#v#��hpw���}K	\k�1m��F�D��8����ډ����Dd�G�c�xN���}�)����ꄡ�zBfa:���Y�k��'�9�m��2f,��+���w�#�	��*�Y"�#.�ﱑ��r��Õ�"X��RR�5��!Q����o}�h�1s �#è$��f��߆��A�eU��IH��
Sv1K*"�O�_/u�H;1Q�7���]����<��KC���yę�H�Ռ����.[^iv�9m�}��x���� ���ʜ4f�Y4�B������H�8��/ƩY�l
���b�)+,{K}#���֐&+	��K.o�2����D�/	[�0%mJ��<��䣖��K��ָq�X@�@L���f���>G��A����mM%x�,'K�������r�b�}=���,�]h�i�kt�c����s�:��'�@�'L�u�t6�DcA�>fDjDJ������f�c�Jn#"K���4Df�#4�����2��//�p�    .�+�Ai�!y	��Έ3�Bn�SW�?{!
�>w,��51�`������GA�w��7=<��Yt(g�_V�������3��Ԉ������L�S��(�����n�~�$���~Js�C��u��w�Nz��롕��V���4��뫥��� ���Ƃ��/q��e҈^��_�䬬0�%���1�&̍���/wg9���i�4�����=:ӄ�s�dQ���G��O7 4�,sY�Aց������Zk ڗ��Z�k�"�q����FI	���ra��f�7S�śqH��K����n�ܠi�˗υ��b?ˠ������n�H~�K'��;��E�7{%]t<�r�������K}ȇ<]]~�C�c�,�ڊ
���޵���&�z�Ϗ��N8$��	!_���F�i�cCr�qw:�q���d�AG��v�q\��D���a_#��]*Ϙ*>l�аi
[HA��U�"N�����OIhD<A/�<<
R�e�Jd��H�]�.D�*�n�sǠwRQ�pB��'��R������忴����v�{�o��+�5�XV��">�RQDCRE�!m���5���<��-���0��=��hE�p�vK�#�s�z��[@$�����r��������,*Y����}�xc獀�jK�sb�j}s����p<������X�9a�<�'Lz��#�_�|�8b�|EZb�K��X�TQ�_QM�"V1�5�#F�)ҏ��~��b²��ĩPN��-�v,g�J�ͼm��zo�������e��7	�bC{���f�T33y��Fh�j��Y��c"Ս���-mXs�ۢs~T��\��o��g~�(f�ɴơ���-��V��tX5��<c����*l%��_& I��'�{[�|n���M��	:�߶r=�v��b�+�9�c�����\�"�u��j�2�zq�7w��FC�%U�-�)�w!���IĀ������0�}$[��N.����|�?1�US�82܎�qW��l$���׮��:|��r�":���HU�E��P�T{h�I�<���}��F�FU��ċ���ϼ��4��/��c��x��J�����؃��$&̲�<�]X�q͔l������7��QS�+R������0�C�O����C�F�T�z,U�G���H?�G��k���0�&��\��!�hҊxaj|���T�'�i�1t�u�X����n��b �u�B�^C5^�7,��0���<-U�+�i ҿ��"�*4$SS��E���j�]��5������Ѹt2K(�fx����b���6b�8�f��/��W���`rx�����߾��HA��S��$n�i0�T�i��hd-�.)ȿ��)�lX���dqKGs� ��K��)��!��m����G!���*�ҍ�P=��S����%�9ͨM �ӵ��PѐJ�&vGvJ=�����g�����ub7!��G��+�P�Rjȡ�4��cm����D�b+|4�`��t�|������U�n[I=���˷����r�h ��U�������C2<d�r�	`�\!�,4�d��t[�����۷�аhі�>��Ҹ�vGc�ܢ��uv;Zȿ�����.��8�?^�g�H֠�'n�K�o��������²!?��,����wvރ�L�&RV ��ҁ��+r�m�:h���.��۷����!�H��H�����@�W5��,&Ƿ��;Xh'i����0����?����J�aU&{����߿�����`��`�C���qw����}e�GL6J����0����L��{�1.��c�D�w� (�=�x�^iӐ�Q�8z�/N���%<�!Q�)��ٖ�P���e�O��V"�[[���aNj4;��w�1�ˢ6�&��r�����۷�|��������N�H�CTZ���>݋1RHȠ/�j��`4:Av�����=$k���V�6�^c�J�^v�j.�u���#�ySY
.hH�����1ބ�O������|�<���^v= ����~�ͻ�'��Yv�}��r�p-]	��fa�7��Ԍ7�a�9�sx;$fP�e$S�J��JW��xm�����*���٨A#�5�Ρ296Z�K�������1e��E�H�,�5�+�Պ$�����$�)d=մ/!�ĲDuF�w�L��{��Ǭ	م�S�]�e�Xl�dy*���W�W?����˯�[T��5q����
U�ƹs9���$��Mh$
\	�tH�e1Su�v��eg{kŬ_a����ș�ט�!X�CPI��@Ld�$�(-RdxO����)ʲ���_��&��x��Cv=eS�Ϯ��_D��D�)y�V�6\:UMo3��B�1�61�N\��8:�� 2�%&��0Cޠ�dH��KM�p�l���No������D���Z�siHg�9�|���^��9��&�J�]o]���\=�<�0�;��p�)�P���iDq+!:�����A���P�I�Lﭿ_ݤ�c@+b��~QW�A�Y&�c�Ew�8w�x��w���=FQU7��#��$��$�t��!��k2�V�e=d�|/��!����2_j6�Z^�Z�,|�X�⟛�'.pƮ�<��,G� ��r��Y��b�xm�����1	8R$/��i!C��{6�h���wz��I�D���OOԽh-�	zg�x��_��BB����[�����
,J[�c}PR4v��oR�88�u?��7��7P�t2��#̈��o�*R{��SQ�E���7���F�.O�VWT50���1�.8?=��TYTŒp�F\�Q�lJ�X^��W� ��K����]"��\�W��~L��w�Bc���|��	AN���Yz0v�����߾qC�>���J��a̰S�a^ �)��qNA��HŬ� �)Z�5�Ʀ���v�+���o���񽺑�3�7HU�A����{Ɵmj�h�6�ox��TEž��2���Hx���|l��'��]O��7�<2�������M���/�pɧ�uyhͅL�覆a������~#�D��%��7�0�TF�lg�O�* �n�	�������q߶�u�a���L��#���e*�f���}�.7�F4;F��`FC��j���u�EUC2=���ⱞC�k�0r���rE�ce��Ǉ�ӭ���0F�漻�\o���b1��XJ�6ϛ�TWz`bX1NQjr�	���%������T��O׼h ��
<h�q{�ĝd/"ܓ�hw:�cf�|84x����W<�+����s;<��������M*Tw&О�i�U��U͈���k��aV8��P�K�B���j}��x�O�i��	���6Q3K�m'��u��3�/�6��q������O�7w�:�C�C}4�e|���Gj�W��Ãا1�B�3���$%f7��أ�h�K����о�o�yc�I�L��1��%T��[���y��{.
��W�_4d�Qs�Fr���n�!#�^�Įw5Έ��é��̷��R�G�����v�+tD�/�f��)#���ĩ�	��/I�������ҝ�����A������|�[5����M���%��tb�#�Q^G�K�uw1Q=�T|f��ݥk�^MO�EM?�jG�!��Z�L��h����N���~qL�Nظ%%�-G9=��V���"ja�K6���2�KilE����*�97o ]�Zx�r�Up=5W�My�q�li�o�e���v�+��ra��uV�{�����O��v�&S��r���D>�ڴG�K*̽f,a��6z�e���L/T5�,��2�!�t�����(!_*���`�m��Ugn</q���_�z������h�CN=5y����qdF4�i�W�����3 �4�;G-,t~���7��nQ�Ǎ�j �����H��7L��Ue*�ĩ�W%�6��uڰ@[x�v�ob���ix����5��܍�6�������_'B��)��:$���G=L���cD�S2��k>�h ����<"tw��f
��@'��8o�����v�?    �^.��Sc�������K�w�[�|�Z��m����;��cd���ǎb���������v;�}qn��7]M�{�(�5kY�=��V'�N��W~��-�|���q���k�:�NW���M�(�{�m��A�U�-z�DFظCH��k�<�Ɣ�F��5b.�������ƉS2�pBO�6\'����M�������3�3��}̘j�����	d��]G��:d��S�t,�'~���?� ����u���h~�bפ�&��*b>�>�P���aԜx������^P��a[�UE"E3��@�y�t�d���j�p)a-�/�!^S-���h 핞��oF�8�_l�)��f����P��y�j��lvC������4E��v��#iTq�'TR�ӏ<(��Xt�O8)����L��'U3�Gm>����j�p�s輳�I��'
��T��7b�@�+���ɏ�,ԇ������i<o��a$�,�����ڠUנ�Mt��|~8?�n%\yצ���`�n���Ӑ��z�g�#ehY�{��┡c֍c��2����I�H=ˈ
�Rp��_OO0�ފG�CUM��)�: �F[t_��n/g����bҚՍ�T��q÷���E�aIK�����an:{#��s�'ӎ���|���Ŵ�Ф��hZ7O�^ǝŢU�N�*x"N<:�������	���>2~3p��$���ʱôI7i�뽑�w���M=-��/)k�#:�U H���(�0&���:
d�V��>��)W���eC� ��
���P��I'��|�c�}ȵ�@B����E��BuwDbb��f�T5yRi|�k���y��y)�c�$G���#���u=&AmX�?�����U$�@ݮ��U4��>�D�a�0�k�{�;�7��nT��JE\�x1��2�$t�(�b���1��[��i�R�'�_Q��7��A&m��>}�Y7���~����c���?���_n�0g2,g���]t��"-ST[Oz�����a4�A>�&S�L�
w�$C���e�O_��4��TAڄ���B־�㫓��%�A����~Џ�Gj+Խ>$���c[]E��B�m�bq��}��c������d��Sf����Q�VȤ�m{΂��T�u�:	1	�b"eʹ�G s��M������C���� �����������v���О$��D��`/������|��j�2�Kyi2y��X|��d�5�,@'P.1�X��sQEE�NV�?E�&��j���ȥYq��M\$j���HBi�)C)m�P���ฉ�"��Ys^b!�i�^=JQt�1�k��<��d^��0���≪������F�*CF�X�=�Aȝ8� knɕl�z�j ��W3	\x�����;u^p�����h�}l+�8���.i�^��������T�gl�I+��#Wk(�4<~F!�i��!� ߆�d�j�}u����$H[^BFz��Ok�#���RH�F?��7<�$Fƭ�zuwF��A׌d���m^a�<�ؼs���:�;=�?АE��a*�ڷ���y�]�Q��':4q��Ws�'�!�vMi�i?6�;9�v�ܣ��+��籐�F;�Muz��@�H^����eC<�"!�-��yz����H;VS���M%۩h!E$�zȴ�DVr����кk��.���X�)�䜼��nhY�c�9q��d���� ��	v�VŌ�Yh��n��7��/I��=vK��˻���#[1�'��gͺD�`�ooK{��8���&��J��B��P�L����yVdn���h�B�4�4e�͠?,��,����~��+2�蚡� wȱ~:�|������μ1oW�F[��1��a�P�7�c|��ȴ��2{��7�~y��t� ��,�=���4���`�a�{��Î��4}��'Q�Y��kF=��g�Tɠ5H����V?��(1�d����|�L���mh�p�$��뻉�l,�(�sc&^���M��Gq4�"| ��UO|O<PZ��}�����aw`�a�;I��d��zD��wtͼC��(�(��vv���V�yY����g����D��&�ѣg��|�ؘ�iR��S�O����l0L��]��X:����	OH9U�(p� �,�W�A1���C���Q吏[�o��,B�?=�~z��o���`hs4�g��^�!)@���u�n���V ���!�ۮ Î���T<�"v�܊�����ӉC��Up���֊��f���M`��	�B���)a��2,���C�ک��g�]f'��i�]_a�"!x�8vLr�`�I���;�NH�2�]V�L�}�Qt{,$?�3�j5�DL���[����+_Nr��B�=s��Y�}e*����L<_	J��+����'�	B=���A��y��r'���v�����!Y�?()Sc�d��݂S_��w��IJBXH,�C`&3�e����b���.TӀ2��zf�������Q6X�Ν@Jb��))	����F�����)[�~a3Ю� .�Ig:�9�Q�
2��ː��%-=�U[W1d5�aff���E2S1�|o52{24ۯ_5��-,_����.��u��X��$M�o�p#|$���V��؁eY2��vq j1a(>V�����K�L��&����̽R��k�TmQ8��v���;[iO?����;ᴉ��r)��2�C�7=�7�Ets�07�h>:>;:s]S�~�y�)w���*5��]�ώ��%"��⸪�?��Fzi<8G�C�u�u�<*�u
��e%�r�{�n���	�qEhD��1�y�Ε�}��^�$':���F/M�`�N"�Ƚ,;AFg��n
�1LD�&q~���{�Svu��?b�)������*��^?��c��ZwS>��D)�M����X����LmH]!�+��N��t@*ļ�r���4���"���.l�;)!� �]�r���p��C�eaOz��t�yr�t!	�f1�ZC�,ĭ-d50��:Y��$�h�	��Ec��bf[�����3�w9�☗�λ���׈e���b��se����ЅZȉb��3/���Mu�;���L�V�0�I{~�s��n�^�F��������U1t��Vp���
1�:��L��bR0��U㽭�� ؎�#ȴ8&���}��t{'��,$�2S�D;?�k̙��0��=K�q�hӹ�|b�2*��[���5`l�	��Ͷ\s��H�c�&�t�d喫�"/y����e�lF��䟐�¨6��̳E��d��`L1,7���9}|��ך1J���&G�A���*k�*����U���� ����I �Y�b���up5��l���!��d����Ǔ�p�M�(����� K[�t0/sl�m�|q4�t�0�S,�ӝ�[@w�2��.n!�_@�s��u9D���Y�?�,C\@�)�(���4ҵ���vcٶ���)kb�v�4l�rp�,�(-d4���3e1\�k�y	�i8����|�|�!���Zґ�� b�k&�,s:��d�r�8��{`�����5�ԝ�v}��d��MǏ��<���i��t��w�^H�@���.چ������0*�>>*rYy8/�=��h.i]�/k!��;So߹y�\5/sHw�\�p4O��6.},&�[������7��bj��n�mj�&W�ia��HT,PO԰�)z�V,�m15m���a�����!Զꋞ�^ f�k��6~�b�v�a^ f��{�>rF��3����-W���a^�ܠSZ��iYB�S�e1U�a�.#f�	��op�|�aD��Z��#���#&;�X5e��d@��|���k��<��W-�UX�t17rt�یMqBB0S�9ڨ4�x���Э�f\@Z����9�e5�s^��*zO ��`f_X���m �a��*y���h!��1�Y� �Se=К$ @�d�E�L�j��?h�h�(cv��9U��3$�2ư��I!��j�Vl+n�"���x�8>q )��{���    �q��_̘���e���y�,$�1��f�O���5-s����J<�ݞ>s�ye�i���'�=e6Oy��NB^�8�Փ�C�$`�� �๟t�r�F�ɜIO!ġj5"�032s���b�3�E���O�)q�[
��+,� 6N1�3.��h�0o�D�D+L���ۢ��g��`meXm��{��ؕ���V�,�۩J����~x�9s}�黆�9�_��|[�����(� i��;�cDx�*��K���G���|��|�}y��!��,>�ᒫ,at�C��(�������#����X�:��b`C�6Q�����V^b�m�g?(�M���ڳ[���e�M����|/߈ Ōq�Y�f�v��%3������v�$q���*�![��,@��^w�S�>_�;h�Sv�j���?~|�8$�1�-�G�S�U�'m�1[J�����I�xC�'c�\/��}���;�)!f�e.KMo\1dx2N3c��(%�<o�p}X�9u�و�%1Л׌�N��N�]�-�������ln�\�1'��Z��ny:�29A�kL��&w�yg1����~�4�J4L�,O�u*�F4�	4]5y�s�dw�>�����!Ԟ��&nݜ�\:q���°�."�1�� �q��{B���a8�R��խ"�J8RP�ہ_�N��1�	�!��]+=1w�b3��[�A��vʧ�\��B��x(��o"�+K�)H�ܺS�K���7O|b����ң���On�|!�(�z���+�XH�b��=��\B���E�1	�݊B�y#�,$'3�)��^Ol��]M2 �5��T�K���B�&�*K���o���`Q]y+����A�70�LGv�\٦�m���*}m���2�0�_��֣˵J'����#�U�M�������Un99�cc<+c�w/�&��yм=m|�ɋd�1�uy{��o9�N�� ����eBA��s�7Hk�-�py;Ht����+r��m���7	ǰ�T��/�h-��m+��Z�0���t�y����In���`�C������=ʭ=i`Lh�p���l�{�n�t�<u��u[��ik��w���+Z�fYO�C�u�z�Խ�Q/$L!\5�̗�c�N� s�	,*^M>b�1�9�y'� �b<%�Μ�<�M�>0	'����v��Z �|�By���V���+�ax	,��qțYw����dL���[��r��y���� ���R&ϭ"��F�j��(i)�|���M|37)��:+N�Ȃ}���� 6 �kN�{�����Y��YK�X�����@�Pޟ����~������.�3L:B�t��|���|Cz}�j�@�je����C��#ff-���{@6&{ܝҖ��L��x��d\5R0�����:p�u�W@^$�G"�zx|�;�˃�ί�����qw�CƔ܂W\r�e\������;��i�&��a�^d+.�f�(���/q���^9*�1��]Q|�	1�}fN�[�S���L��Apm;HyeB�c�LGw�xK�	ƼT��1�23���1�����%�#m�\܋�4�\�/W_�����+��kt��q�&xښ&��}�K�r�OEY�L`�^���m�Ԙ�AFk��=n�i�:��efV��MU�i�hY[`r�L�RSHt`��sx=<�]s�S�6���z�洪��B��f�KIS'|'�`�ܠ��)�oNZ��j�,���[����l��C�"2Py��JΟ�����G������x;���I&�&��򌗚b�� @��p/=���,��V�|b�������r�������M`�)����0>�4oZ�N�ϵ����U)�C����Fe]��OU8:f3�(EP}>����_���7�����^b�z_��S�V�`7Ab�>�u<��~�3?n�feV��
�Vǭ��ΐ�������7�������O�i�&�V�tL��:�Tqu�;N{�����E$z�.�,,[��c3*I�p��S��HM[vdx�������߄�@�^Z۞z�i�H��T��Dr����%P�:���s:�>b'櫣<��[�����c��r���g�b@��~�Q�a�&��LG��*ض��:�$`�-,>�Դ�L�Ns���T\� ^$~L�Y&ʙ$n��D�e�h���@:Q� ;�1�"���N4����S��4�:v��p���%�ը"A�A�a8��e�6�O�a��vǶ��=��<.�y�n�V��J�{�1�j!�{8��L�t��_M��|���4g�����C|�o6������l�,��X��]����������?�Y䨱/[�Qi��;YSR���KD��BŨ��F���A-��P��[6+0k�J��?��wi)(�ۉe�Q>�(h�����1Q���?�Sb݂��/V5~�ƒ����^��ی\6NIQ��|}�(�EȖak�����AeQO+�����>�����������qB*&[S1E����:e	��sB����n�/O��������^���c��~����[>���k������w�+���� ۭ���ƭWb�wZ�.����/��a�Ym�vm1�))[� NS��\Ǎ�'`/0��	/�'=X�W�4�����t��}� ��jR:����	����)wu�p'A�^��\x4�x�A�� #��3�<cR�t�ҋ$�_8��J���$~,T��2�Ƶ�9�:b���_d�z�lb/�qs^Ŧ�Lx���H�ck
�3p�k�;����[n��P�A��=�Gak>
2����XG'R/��RQ�[6KO�Bd��Q[o��X�u�L����[� �p���t1������f5;��t�����qZ�ͺ}ls��>`Xs\��28�KQm����װB�x�XQg���B�.�U�w�١��6��[��J��F�j�,-����h��ip���Y��&�A+^�gѽ�$RV7�iO�7�[�ܺx���C�k��.����>�_.�|��bR۟$��jH
��^��B��K��RM_���Wn�Ø�yf4�X�9��g��7u�c?n��ܟ��������0S���~�������Mf�jl:f�8�K�|��?�~Db���f��Į�3t͆�k5��[!���b���`S�b��`��W&%��ܿ�PI2"Ø
�����#oTCk[��I����	���a�f6�)�,n��q0��N���m
�����N���;�̮�q�t�����c��8��l�x蛾#ËY�N��-"_��t�2o'���Z}��#��5�Z�{\{�ԕ�fJ>��f����d�DzgH@�8����L*�v҃�Q���#�26$��U� 0�߶��z�+��{m�U3�0-D
�'��i���N7f�
����� ��Yw��Y�]8�Lbm�g�M�j��ޥ����Eޝ*����Y���r�Z�j�8F��ґ�}.�s�}Y�=e�t8�t��w�9ˋB&�<h"٪'J����q��ĺ&�Ǩyr'�D!�z��<��t��6`D�MD��e��Q��˛6s��g��!����ZuOҖ�gv�g��V�����'�D#w'݀���-p�u8�u��2w��摠NԦ[Ȧ��*<X�)���I�x�E��E�8:>2
Ye�Ӗ���F� �A�	�B�Gn��S�!�ǔ8������0�q���\d��U�I��c6*ǔ�~q��3:ǲ���
�$&�fU�X���~e�����������Wp>g�U���8g�
��.��/�Yݝi�)��VE������8f�"4�#����`��@�51e�MǊ�ǳ�i'�<i�o/7�: /��M� ��]�Aw [���
��TFr��e[�@^���w�8(I���K�6(W�<\з�I��ܵ_)���*��LՕHH}�:f+V�N/�7r��C>��+v�t�,�G�N����dBm����pO|����o�Gܾ@�M��b˧"�$� �S��Ű��|*ַ�%t��^��6ʝΕ� ^7#Z�.����{��-��K�E��hï,r��C6�Y
�5v}!E�M    ��qE����+�ÊqOp���z^"v�^lq���S
Ъ��?���z��z�FE�� zVҩ�Ғ*2o��/�/T"��064��(u����;]&���e����6���\�����]�{f�G����w�i�>�#J�jT��̻ R������ 'y����O]L��Ŕ�N`�Y�:>�K�@ߵpb,��rq��R� $�2��01쇟6�NI����p��O�7?�$�����$��S_9��W2�4�It\W
*whz�C.X9y�lyU�s;	�Lec�VQ�o���	=K��e|j%4���F3�J����7d��EzӉ�;�y��ꜴC�C�p�E�mzH>`�&=���:'4���Na�Wַ2l��F��������|>[��wY���4����k���RI�Cf��=��(�/�㝾Y�Q��a_$��B"c��3ˢ����93�����%p[����?��,
f�3�\{,<;��AF�;	���	�TX�^�^~8s�0&�,&�D�v�Ɔ-JeČ˯2��W��ivn�_����D5Y��'�?B)
^�n~N.hۅ�(���t�q����Xj1ȴ�U��B��C�7;��7J=,E�*򐭮�wn~�>fG3ώ�g��F�B��n �+ /�!��KxH�`g�����Ҍh+@Ӗb���zz:s�.)���y�q��UM��u��n#-7��N)��=d���a�p~����?��#�����������G�������q���A��G�H�5���O7_��@~
���hÑ��LU?ܻL�AI���L�*���6߲��%�`�[�ĺ=�	����aO��YOMT�A1GU��f}����^ڥ�V��ނx�ETפ�V� b%�ģ�p��<��Q��5�ئߞTؿ���`��&va5WO�Uw��^6d|��0j��{�y���9o00�ѥЂ|�A>)�|�^�W��uD�M,�C�-童��H������t�,�����X^���ר�VB퐉��d�46o��&3c����iմ�!h�|b��3�#��Mm���4�Aȝ�M�,�:�Օ�S���ٙ��鐽�ܱ�rֆ��@���y嬯�Ȥ���r�N�W_�{ׯy�B�r�h_���A�:��w�N�2����++�a]�V��}L�z��2z�����C_3h�t��öq�Oڷ���Q������'QQB��XtwG-�&��2)�qY�в�)��7"NBJ'75���vZw��ڟ�J���Nc故|d2���	54A��zϟ�PӭܲVt�(%qKIb�7"UC�V�@�xs-s{�>}��Unb�������ב"�2����Mi��?�?|�'��7�y9g�t��k+�`�UE� CW���{d`5y���I����u�S�J�zjH��j��O�3��{�J�x��&����A�>��N~���~����w�ނ�$Ċ/�&�6�2=�Q��.`d�W�c�d���t���k��1�'z���$�����θ!��z���R�מ~z<��uW̝��`u��W�:+Ǉ�R�M�����G1��!���il��{h}���5�O��J�ru-��+q5]Ix��T���\l�{���O��<���W�=�vp�����.`�#!�g wa�k�L�!y�Ӻ=��kÄWֆ^Xbe�8d[�i ^�#�j��.�Z"ѫ�)��U���3��2;h`���;�~�	dys5����8`�
e��N%�'$`H��a.b�Ʃ�yb� ����3٭����OܭA�gv�w.Aڹsf�.b��hJ"t��t�O��ff��灳f��a��K��T����N��zH��t�mOC��a�G�����c�+���[��Yhǎ��x[�?4{:N[a �l&�0�!�3MG�Q#%T
l�mM;��o�����r	�����p�E�규��)�u[8=E/p��s/r"��8����3B�Vn�)�V "�Sr�4�0(:��*�i����;٧�2������ �(�aW��@Ί���L�L\�7�x[5�.��5F����i�u�ˆ�<�6:��W��� I]����0P(�CZBgXE���~�i��|� ʼ��n��,g�%@gx�1�FQ�^������
���Y���Id�DF�O��<h=P$��F��v��8e��L��|���-�a�����%�8����_p�����n���0�e].��̎�+�D�W�ԇ�7w�VMz?˽���Gvk;͂�W�Cf�"�A�W��&�X�x@�8V:	jT9��iӪZ[�i�B�g�gFe��_�*Ci��C�:"W0�Ha�A怡�������Jfo-[��]��sT�(��R4�&yV��1��SYF� v�	YF��,�oˊ�I�NH1k�)n�RGl}���D��p�ewq���2k�;�A4��J�[,|N���m��|���(�_�ɪ�+���l��#
�B��U��xH��lO����������<j�:r�*�UC��N���LĽR'
,�}8��;��2a9�m{�v��ۘ(���6UN
5$Kp�-Ż"ꯛ�ۣ��G-&#��	E�54��G=r��3�X�{�O�w�15��(��r�5����P��z��Ȳ6J���}Z�4y�K��� n����h�����&ZDL��D���5W�����9V��A=��MUBȖsT?���9eH��\��xXiI��Y(0����:�@;�C�.�X;�?fn&��!K7g�稴K�"�̓˓zBQ���n�{���\D��
�0�pM�1,"\#���*	���R�@4�a�s,�]���}����B�a���S�F|G��[o��|������Xm���
�t�[h�-:墧,�'G+�۷�z#�Ȩ�<�4�E�{��(Ď�x���
KE[�|zd/��4b���Θ���ˈelt4Qo�f�@}�g>�����]�5ǹQ��d�����R�8�D�`	�*������\ϡ�p�څ��E��Q���rǆi�]��i�]m�����/�H,�|ۙ�Y�=P����K[�4Ҷ����� ���mt$m<Po��5C!������ĜQO۝K�1@X����^�%k97Jhj�'����gd�iưr�lQ���ӭh�H��s�� ���w�����"߆q	�7<��>�����W�!�@F�E���n[B��a��0�8��R6��p����ͧ���^��H��|�7œu;a�� �m���P	m=ʒ%@�(X�֝Ѫ��M(��g!�,[J������`rMb��g�6���bD�� �,ױW�xa��-�h2�R������bk݈U�vA�<:.�"kTȅ�m����xt�Rb�{�a��1�P��v�ub�~�N������}�_��_̪c˻�o?�L4: 5���e���^̠H<��&�̽��u߼����&!gK*!�n�����V��O����)7��9�v���'-���rJ�Q�AHK�f�kt�����qA��3�$g%`]�,}���)C��Xڻe�����t�
XF4���C,rHM��������'H���!��kQ�|>}~z�aP�YP�	��F�u�L#VU"w��mG奀nmƕٳ��ߘ;R-(Q�U�J�����營�׀>z���n���ֹ�L2�XG|�H�������߾	�0���9.��\�_4�����:��?�����D���M޵�E���~9�nc3�7h E��ۙ��R��4�4-WX`�I�7����g1� w�[ښk����`�|��&�<��� ܍&ኾ��Ch��E�b��蔲���.xʳx����{�� ��[4~L����uNzL�\Dn_ rI�Q�;�J�r��� kn��	3��@�,An���&l#7�Ph�-0qc��o�$�i��;ni2�EO�~}��{h*i1{E{:��_ׅ���[лjƬ��(�~)��/WO�;��a����w�����9����E���������ѼΧ�������u��N�d���F>p��T/�߾<)�����9��M:��{�w4�
    o��Y��H!�&Ŷ�8d����lt�21�q�_�C���Ҥb�<<İ���JB�E�K�|#n$��S�����Rp�IRH	RO ��H\ߟ>�pm� Y����K�:گ�l��m^�4��DU��/Ww7���0~ba3��\13YC@V{�6	�>�f��͇�G���M~�y�1i��!o�]���R���Fq���ѸIR�^u�f�>
|�l^��K�~}#k ���׬�;7J�Z�ӓ�� 0�|�Q`�5!L��Q�l�r��s�H!6�+;b�+ğ_��L0$��5�av��"��$���.#ԶO��0L�_ˀ_2��P�
����$GzPo�:h��@�"I�H�&j�lM�O��I����<5��� �{��i>�� ���2��FD���us/��`�p.���)r��"ŵ��c�F�m?s���a~�d��4Ͱ�4Kl���A�2̉�Hb�Ux��g�^o�~�;
��2Q,�إn)�Rx8@j#_S�)���y7��h��n.m�I�����yH��kB�y\,�N��7�U����Y���Xr�d^9v̻�x��n<�ys��Sӱ[���cqի��I����u�����i�����w����� bR,CqO7OgƳ Ϣ�y���I�%%H�}���m����j��� c!�g�I:�2X��e	���� ���dLK�t�I�y���;�bH�/�.#da]y~��x�{4�o�s�Eйy.�+�����R>�<�2�Iy�R���خ]���(�eP�9)~���d;򚥢��8�;��]U	e���* ݐ���&�ж3�oM)�qs�i�%�J#�:�&l͎ӝ�H$�u»4�;�0�t/Z�~N�P�\ּ�?~������m���zK�U.
G/�U%T�0�H���Y>AV�YA�Sp�=g[M^ �j��	�3�� ��f0^ʌTW��M���?G����T�'��tm�����t��>��;=���:�ۑ�����fڅ�k0C~,o��U�y��8W[_�Ij��]ӢZ�:݃ub��KP����A��2���HbN���e����ӝ���f�oc����K�����u��-�4�S^�$ky�T޲r��L�}��;�� K�����J�M�qX����A|m҈�k^7IdakI!c*�!�q!}�7��{m�]���鑏ԉށ�o�eA����,c���Ǩ��\�2v
��� x��7��m26y�#����\�i��A+AVG�O/e��t}#�J���[�x[i����uof��֛���LyӤz��3�d!VS�(�i��m͂G� ��7�`��žq/'%Ĳ��bWi�"D�!���M,������y��&���}�nD�|��7d��V������7��KʬD�D������p0��,��ižRڝ�r-�3��d�,Wzহw�w�z��;F��3I�j!%�8���:�Ty�c��t��L`z�A�e-1x����j��{ئ1M�fv�Vϼ���^_f������9��H��.���G�����Ә{�^�ů�(P:p%<���e�1n��V �� �Az����wҦ�[��%-��6/���S޲,��٫��]�*$�&3��C?}�al���`����;A��*	�W/G׫�G�m��۱0���9����hOr/��arm�ot {���q8�Vb�/��I���,�&���B���^��qr��˗�ĳ�J��}9���ɷ#E�hk!�+�Z�*?�%���f'1��N�c�;>ƹ�/�	�Q�V�Ow�<C��Y�h���e�McUL����\1�?>�� )p�c��^
�U#�pⶱ�-��ԾM^�"�G���]㯓"����H�B�s4f	���yY�����T8ޱr��o���n��to��d�c�"4y����+C1�)ǒ������]�|�3�	x��.eY�~�ap���i��5��Ϩ����QK��A�B��B��OUl��RL��M��6���x��!�����c���������l �o+�������I�,̐��{6�5H�5��G8r:�򼓸�4Y���o�qC�̬�x�zW�*Av\�q�d"e&��3��	36�����z 3���Z��X�F.���{)�1C�P���5�H�R�t@W�o��С�B�p��N3d�7������t�W=��*��t'�nfH��}e�<�7���U{����"e�d�m!Co��>0�դ�yS҈i1�=`�ƻ�4gH��CS���:Tsmip�e�m"�`�U|�-��Zr��'>���|�Ç���Lyn�I7w�y���yA �e|h
����*BY�ypIk�J��������ІC���A�Y���tցsr$�"�����a�	M�ѽ���qo�G���N�"Y*��ۛ��b�z�t3>��սC�L�I�bSLfױ#���ӧ3B�!ٌ���R�NL4�K��l}%>��T��C]H��6�h���u�����=W���)@�?+{Hy.R�p�+�u�͑ᥩ�Ry��9��tn�Ӹ��G������@h�p*�&��4C�?��MO���װuu?��#ܱf�-���t���gN93C*"?�v�;:R�w-���"Kq�si�i��w�}��[z>���T��mi�#�qY�i���^ɖ�
A�.;�z���S�;���~��HY�,����X֕Fژ��*A��,�'Ȕ�녅%)�"�X(,���.%d��!����1�n C��4���,rz��îe���l���9+�e@"%_)-�X:4G'6�w��:>M�>�"�j��t�tU���Z���P�c�$�Q�:A��ž���E~ �}��aD��c.�Ml�g&�*�Y�?�_��xz:s�?�yn1�����RI����C$f�����N�2t�s�è�P-�d��~4����t�ZU��������o�ׇY�Ɯ<iӰ	
m��хz�."��G�n�;�,4�����xc���Hq�L��'�ѫ�Uyk&��6B<9���T[?=|��3$�e��;Y�nd�E���7�S�/��"[���QjkT_����!�������o�8�3���$N�_A"�0�U�;p�3���5�TF�X���F��'r�����Jp
"��qqy�f�i�/|õc(��1�.l��P�\��P7�^͗Ji��2h;��TWݏ���ōD!=LmH�m�����|�	��T�˪r��q�I\�2�i�����k�9e�G��j�F��!��ںy<����}��������J>l�S�hs�2���3?kH�&f�=mߝ ��=��Ʀ��16#7�cM3��	�0����A�� Ȳ�9�J@A`��y� ��	�/3�ͤ'���{'�N���R�K�5��@��0f�IH�8����/J���6���hd�t+aj*=��RcF�٦'��+��W��2
�aj���	�u%��5�28��!˴�(�
W��
ǁ�aj���E'� ��8cSy�gtƐ:((vGU}�U5v+f+��LE-{?�$dK�ݿyp�d)k�pr!M
��}�c���$\�~9�r��3Śap��>��tμ�Ϲ6f|�(���a��d�f�%�T���8�g��J&�_U����@���X5�ӎ�5����V�D'$��L5%�,EBfH�T�g?���.�2`��8 ˦��y�U[�擘i�l AyvƃˀՅ���,d�^�I_x!�qO��g#kgݏ.p"4|SɄ���\��f�b��(%'�R��uI���Lc��_n/�����9o��5�fe@Oq��2 [u/ѣ�0#\���
jKQߟe�r���ƹ�w{�"kY5����qD<Ӆ�eF��<CJ�������*7O�_t|��牳�e]ʊ?��p������-]�� Vg��t-��t�_yb\��(�[��|�հdѤ��
$���*I���Ŝ��#�m�XyE��cэc��xF���ٗuc�	gH�텹��At�!+Y�M����K�C�u�i�Ή����V�l C7h��4^*�����Em�&��;��5�t=A���t������	����[:�!sZ��"��%)�� 0  �W��ypY�>�NA�	��{dPv�ײj�CA�rf<Cݤ};ecXۻҖ]-d5fHxL�K�;�1���m�e]}�Dĵ�9o���a�̰٨��R���dS��⬘��8������^�!/H0M<7jpt6�ۻG!�2q����.����y*h~��C딣s		�x�O�ef�ނ�	��|�r��`)!���6ϵ��X�{ת �"��а���c%�#ϛ�pw�� js�m-���7�0�
��+hz����ˆ��d��):����sv9v�;5CF�`��n;+�o��!Č]��_���2�#D=g� l"�?�>U�y�,H����Q6��b��Q��˚�K��w��,�/�
YDJ�"*���OO�2۸�a���oW�8����rS<oCn�_��k���1!v���*ᖎD��¤!�E�M�e{2;�H^����fᵉ������h�A�`y������m�	�@���S!%���p����"�&W�۰Y��r�+�>(��FǄ��\��L��W�_�)�k�nm�cs�N1���yΫI+��gi�0��6�+3�n^��?�<�J��ZPm�d�����iv�j�k̹��vJ�u�� ˈt8�v������s����Ɵ�6 h��	������ͽ�M��N�)Y?g�p�ϙ�2�sV�5<f�1{G�؊q�Cü�F���j"��D����j�YB��,;��ׁ�2�&]�m�e���!Ӏ��y�y�)wizb��+0�ʦZ�k���I5��ᕌ�i?v�[�\gvT�8	"�����u���ƚ��![�����إ�芬�R-�xY*���p��n�d�{J=�a빪W�>ȴ�73�����u�5>m�'aY֝a'�"}̔[�9ϛ[	+\�T��!��G/e�Y"�i pi|it|��xu�� w}-�|�D�-pM��1���Ѩ�_�������=*�#�,��C���I�'싴��q\&S?�o�8�r��.�\���
�"̃��@j�eEW@@��`y'gܭlk��4[���/
A�HY�z���s/.l- O��Sg����8�㸕$)ڍk�����|͠C���E������e�� �Ч8!g}]���	�Bhr+
���Si�[��/��V<d&������p+���8<Kc#��w�j�
y)�i�c����;���{f�=պ݀�W<��p���Z��K�Ln�=p��z�˪cĞ��[��T4���j'B�Mbx�6H�<Kk{���`C���r����J��|�z�&X�%X=u�7 ��C��"�Jt�B�ylh�X_QQ~��΂��)W�:$�F�@p��[�����.��'�&�Z���uA�V�b�y���L�� �r� è�f��q��r�z��J碊��ts~�*�d
���t��:�έ_Y����$[E�����s()��@��X\��q�v����F)�T5yn�y!�@~����rcG9f�
uxt���`�bA�#�Z-��x# C''�e�ع�z�m=A� �Qy���9D��@ʡXPԇ�Z��f�Nd!��}�����7�o��_��_��B�      D   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x������ � �      F   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
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
-Pl�#�x���Bԩ�E��&r��Z�NM�d:ܖK�/<8T(Fo�&��NMd·��A�Wx���B�m�$�9�C�(�D���~!M��6�����κ\n;8k����ξ����y�^��BM��m'���m'+f�m'k�m'++^xp�P���m�$Q�vpҖ�n;8�j���;Y������S����؅�=\]_r�[���,P�"���p�(���߿�?Qg%a      Q      x���a��(��׬�n  �`/�`���gpV�3�H�7t�ȉ��A�'��W�Z��v�u������ߗ���_?\y����=m����m��?��0r�Ȍ��"�����7�����)!�|�gW�W\�]�CY��K)�M�z���m�ܶǲǼ�5����B7�}�@ߟ-�G�#���Bb�z,[��,[��'�%$XBK(`	�C���qW����U<Ⱦ�Ċ?��-k��d=�u���ϊ��
�ǽ�^Fl/#��/�ȭ^ekBĚ�&D��F�C	�P�:��%�C�o�X�֡�u(aJX�V�C+֡��/�)l�BbRؾ��:��}� �5k���U�|A�J̅s��\01L�s��\01L�s��\~\T �eK)�`J/����)�PJ/����B)�`J/����B)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����R�@)}��>`J0���L���S��)}��>`J0���L���S��)}��>PJ(���J���R��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0�Wc�-$�!J�՘|�u�Rz5&��&�>J��mL����C����"K�$.��{��=p��w����Xe$���G����v��w�XB#��9��;H,�n�Ar��OR ������*䀩�r`�X,�n�Arq]�z�{;��;�Ľ��Y����U���7� �"��$^e#ܼ�Ě0��;H��p��:4��;H�C#ܼ��[ ֡n�Ab��$֡n�Ab��$֡n�Ab��$֡n�9HqM��7���C��@(���NW�`���;H�P���;H,!J����;Hh���;H,[J����;H,[J����;�@�Uʯ���;����䱨�h9��j<NJY�"�;�Ė�Rֱ��-��/����ܞ~@>��������c�E���>��-)�Ň����h�r���>nI�6��ӢO���>�!.��RF��k�9�mw���F��=)�~�şc^ñ��^�z�E�w�x-P�=��A��G��X�{�Of�z�E�w�X�(��t� �Q�=��Ab��{,ҽ�M�}�zE���|�"�;]���t� ��t� �h)i�t� �l)i�t� �l)i�t� �l)i�t�H�qW�V4�~������H�����n��H�����s=������H��po�kb,ҽ�����&�"�;H,[Ju�"�;H,[Ju�"�;H�5�UF��Xx��3��E�w�X�(�� � �Q�;�Ab�Tw,��M�}���������쭏��Q�[�����R{�ݛ4�ݕŭa�i�ɞ����%�i���/�{w�u��K']�}n��ٻ�>�<�����'ه�F[�����.�E\�ǧ���}<]��D?vi��V�X��:��:��Ĩ�U���1nn���>����Y����Ǵ����·��n#�KLG��I���@�$�@Ů]�}�|DRٛ$��#ґ���@*;������5:R��H�C���@r��OR �r�2���3��O*'8cMc�j���u����1Ɖ{��k��b��y]$�z���@r�׊�b �|j>"�wNͻd�i�C�w�@bҼK�odX�4�:�y�$�!ͻd �i�%�uH�.H�C�w�@bҼK�q�k�>ͻ�!���0]���s$\(z���҂$\�z&����$Y�D0�X��$����')w�r]5���x�����h9��j<NJ�Lc�ؒP�g"H����d"�#�3���=�`|>߯�����0.�{�����%�z俁����uR�%-����hg�a�XO&0�X-)֓	$?=`��XO&0�X�(֓	��5k��j2���Q�	��B���.1=��@b�R��'H,[ʻ�d�eKy��L` �l)�֓		�OR �*܊�d�-4%�j2�aG�`)�ד	q]�z�{K�z2����V���� ��
���S$�-��zJ��Ĳ�XO	0�x�Pª�H|*��UO	0�X�(a�S$�!JX�� �u�V=%��&�>JX��`�����q���q(t�ޅ�;X�c�ǯ"�c�ǿ��?.��X��o��ԏ�ӽ����s~?p�/%�rɓ0�����hR�=��Ÿy?�du�*�Z��s����R��/NY�*N��@�@�@�U�e��A���|�pʭ��?���v)��|d�'���Ϯ��xh���l)�8آ��ЁT�4߆�O?H��W���AW4*���@���O?�F��1�｠�~����J��ցԺi�PҮj�PR�H����F�t 5:�ҁt:4���th�J��t!k�J�"���h��V�4UiՁx�l�xV�V�ͪ���QHՁT��Q�F�?q���F������U�(T]���"#<�����ـgc=�TR]�bOu`[����!�-��'@��t�To�k3H�F�4Ӂ��Cj�G��@j8 5��;u�s���ϗ=�{J��_�tQ�:�y_�i.��ԗv6�Gڻ�`����!���|ip-۠��W�֯����dw��R�8�A=�V?uе����CM��Þd���"ۥ��.ʞ2Ji�mwn��m��5(�����.��w�r�����Ԓ1�,2�\|�E���:�%ʚG������}�pY���خ5����"[.qpR.{�]��J(/��?���;�ׇ��=�e[�/�zx	����o=,)�-�l�����Y���_��l�ƣ�tӠ"�1���<Р�ʐ���:�n���G��@��C����,��@w#�rS��U�C�iO��N�ׁX8l��Hv�ֆǮ���NbׁT��N�`�?q��̆���*��7��SC��%LE
}�zܺ.��x�iW�7RYׁxC�W�z�����i��H=�]bSEU z�� wH�
�uz���; ]X�[�G��@zT��!=�]ŔP�kׁTs ԃ�u �H ��v��T� ��|G��ߏ,k���/�X��}=c�? �����v��@�t�|�����a��;�ݟ?}��ҝ?�����v��^h�m�y�.�K�~���λ��T��%��ύ����}X���)6ػ�xio[s�q����̇à������{�'H�Nh;zX����@	G��K����X��G��Eg��O߼��v�r޺sq�S}�G��.������f��>-����j�K��C��5G���J� =�4���:�Bt���.&��}������
�;��H,ڮ_˖P���7�t�i6��wԴ�x>�'[��;mڊ���u��޹���t���=��F��g��	�e�w�خK�F��M�����u=6��뻰�X��N��	�H,�.G��XB]�m\�V���@�SL ���`#�V��+�H>NhK��	W���`#�8��MI[��X�᭟�`�qW�9���`K��j<Lz�T2l�r$_�x�����1��Ė��2�L�����`#{�6���`�J�Wm"1���`�kP���Fb�^��H�3P���5�HlK(OQRl��X�$����?�� �ɦ���`���&�H�ĺ��6��	��3\@[���u)�ŘF[�U�:[��W!�f����$�]��v�������b�5�Ӷ��f	���c�ӟ>~��]7����9<~��y'�@�����TLK(���Z�W�/-�����(!��CG���=�e�e����g�[�J�j�;���\�C�d	1�0�=�M�ɥ�w��n�ܸ����m���ŭ�}��*���X��a�M�ʱ����o_\�2<1�y������Բ�qLy�����n����{1��)	�7�6E}i��d!�H�Y�Sl$��%�F�d#�H<N�S    l$����$؟�@�Uhݕ���u��S�5�K�~Jv�- ��\po��QIQ��|��7�J�����Ť�F%Q�Fr��u���d�eK�pJ����^g���,�H|���&%m�Fb��&%s�Fb��QI^��X�(T��ob����k)�Ņ>d%��F�5������1؞�^"���^&�-�^*���^.�=NG%tz>�y��O ��0�3��}���gj�'5P��si�m~�7~���%�m����7������V�c�q��Ŷ�<Ju��H�����8t��`Z�1�͏�+b�{�{H�[%�a1n?���ּ߭��m)٥�[��Aֆ._���/{-���_3M�z��[�ⶴ�@�Z9�(k:G�u�q�����mQjG���e^H�he �h5�!!����&��mh �7�������ծ��q �� ��
�0������P=,X�g ��! �@|:�\�gEpo5_�1+�/N�j5����Q�?%H%
�@���q�C�'�6�����2�C�3Ve�	/2�xL
�1��*h^<����3��h����o�ćGͻe �l5��Ĳ�|T�77j�4��T�t ���/d �qH�2�|�����B�1=_�@�qRʡ�H�	�r��B�')w�r5_Ȑ_�x�����B�h9��M<N��|!c�ؒP���H��Z����LE�2fE�ґ������)H�AZ����;e8z���Ķ�r#=_Ȱ|����
��^^1�Ч��b��q�gg�8)��3�$^��"�	/NJ��cg������k5�@B��	w��r=��@r	A=�$\)z���㤴\O 0�X(-W�OR �*��z���F��y5��X�X���'��� ��:��w\|i�'�[L�~�$�_X(1�$�-%�z���^g���	�h(�$�!���u��G=��@b��QO 0�����Go$:��	=�V���UW��m|SI 0d�$�T�q�P=��8�)	:�4�ÏZ1��dn�6J���;؞S˓0��~3a����餑��`;���� ���F��),i��婤�ymm�S[�ڷ<�oy���s��\�ٚS�V������5E$Ռ��J��Hf5�����!�>�7��).�����o������#g����8.��S;S��\�ũ��T�mnצ�m���~���̮��I�3�&�M���5��Luۦ�e��ʹm^�Ψ�)6/3��Z�mj��T�.+'S[��nS��0Uy�A��*�0w����s�����jH�:�2u�������p���ԑ��SH�۷��ީs��,g�m�C�܁�<��:U��T�SMo��Λ:�q�[j��^�-��p��"N��4U{�ԑ��d���9M=Ԥ�p����/��[}��֩ka�Ō���s��S�-O���-?w?]���u�Z�s��T�6�Z��++O�e�\��]�S�B���^���GչW@��KZ\�!�pkU���������e�·X�[��&��* qa\ns�d��k�Lշ2u՗�#�j����t���/S-R�jC���t����j�6u-̽��{9�N]�S��e�u�L����c25jE�F��Tw�L�Β�׀2��+S/�e��L�^x��k@��7��M�6��O��35F�zejT�L�\��'U�z}*S#~d����v�z}*S�H2�2V������X�l"S�jd�m���&��&S�ve�m����{���T϶L�_��w��t�9d��a��F�r�07�`��Q���e�?D��{�\�0��=L�sO�Soce�=�L�ϒ�~r�귔�ia��+L�#����پ��{H{��y�~|i�}s۞����K��a�����.�V5�·0��خn{'��.D�S��4�k�c�%H
e�j��������׊k1��>X��m����xú���{5�I�a�i)~��a�k��ר�9��?q)[I÷�25�J�����	��������0�o65>!��k�QS��尥��v��5��l�C��r<�Y[?6S�&㭵�����hc�]ZҚ����P�<�������ŭI��i�f��I���b5�y]�:bH�#��kC[q�c�Ǟ�6I�@�� �=�j �7��Ryv�@b�jϛR��6��gE{R�@�o*ψH>�_��:P�og�Uyf��+F*�����Sj ���q�өW4�xV���V�T�j��HlL��RyR�@�բW4�JqE�W4�JqE�7A�����VA{��@b맽Sj ��D{3�@*�$����Ĳ���4�^l����7���N��������!Q�8H>Nh����1�����㤔C/�h �&PʡW4>I���������U��I��`��W4�|m�qR� jqEc�ؒP��W4�Xo��2���1+ʋ�:���(�i5$� �����;e8zqE�m	�FzqE��A�Z\�8�S�V\QG*�ҩ��mL	^�Zq��V�@��I)�^\�@��Iɵ^\���&`���Z-���|��w��r������z�W4�p���$'��zqE�5��r����I
�]��]/��#�ѣ|^-�h�i,X�Ћ+��� ��:������R/�h�kl1��A/�h ��º@��^\�@b�Rb�W4�|s��s�����'�����zqE�u��G�����:D��^\��&�>��Q\Ѱ�Щ�W4���kW԰zqE�W4��W4d�W4��W4�	CiD-�h���:�4�⊺�)����WԁZqE���WԑZqE�W4z���ZqEC�4����[���з2����qԵ,��˛D��X7�"�k��PHעp�KR��6,�kѶO�ET�Z���5�%��;�D	I=R���ീ�'(4Ŏ��Ȁ��ӵ��'=Dٱ�bVM
I> 
�C�$�4��A�%���LW =D��k��O:H��`�'�B"� ���H�ad�B�HD�{�3�Y~������^���]��c��*d?Z�~?��k�s5�YR}�`����������R�̋۝[BY�ix�hE��)����?��3�/a�J�����ks1�������\
2>T9�x�/~4W�TԌ�uqe=�7<���x�]>�����JU�G�$Ӌ��.�п%��d\x��i�_Dp�&@���P5�Wws�Z�B^:D����fx4�|�\��c�⓸�n{��嵂�J �;��[��-q|鶢S��<�:��]\��B��g0-A라�˲�չ���=U���R���Snݥ,1l��;l/�NhKh�H�p��A�#�N	��W�+z���쳲#8������}���V�+ҍ�t�/����h���Mf�bz�t##��H7��oC�/H�Fa=D�[��)H�Â4� �����$�!�`n�i��r�^K�|�"�+���Z|��!�^A;� ����'(�ȱ+�j�Z���(�zF�A�؍�[$A�A����B����8r�_`|�e�@���29�]��|�GWq�.&�ԯ�>A��B>�k��Ot��lA^�kA�OP�b#ۋ����ч?��}mk��fv�ׇX=~�^N�_�rv���u�����8�G��k�)U�۰8n�ͿӰle�Dw������&�up	Ǟ�;��ʅo������=�e���Q��9�Ux񥽣14��mun�{��ӽu���y�}>���{r3����kL~|2���ݷ~6���>�8~����S|z����D�n���5��+��^�u*jq�0���b����;9�9��H���̡�E{Fi�]��T�K60*Q���gQ�ߕh�������^�a,��=T8����۵�{�����J��ڠ��-�zA����˺��ڮ�,��,�Ku����[�����s���&�l[����|�>�u�)��z�\B.C[W����>-U�������V����U������w��!hoH4����-~�ߜ�zs�%m!���?LC������T���C5S�1���������Tr
�9|�� �  ��};���ĳly�g�1}�^l0d��}�ݴ�&��z�!���n�P�)Ǫ�����j�p����GN�UJ�[ᆒ()���`��jlX��7L5j��N�/	{��(1�4L�k�G>�N��H4J,q��LR�ރ[��ijL ��e�<ZдwW�<ِ_�J�_�O��tq�+˺����]�w)��-�r�sZ�M��zP^�7�X����$������.�3����:?b�>��
�>�-�vǧ ��1����8V�z�q�^�S��U�Zyl=E)nT�ZqC*JJ���V+n`�D����Elew����}���(ȋS/��G&�K��`D��` ��� �95f�By���k��T�M�V�A�����D��tL�V��ќ^�ğ��{Lۨ�hO�����Gn�խqۙR��.�c���.WjD�]�q�~<��k�5y����׻�A��T{`ƚ��ҷF���#�%��ʨ�֞��G���0��lk��H<[�S.s��Ά�Mx�V�l�@(�Ά��lN��a �8�>�:�1�Ά���'�Ά�Ě@�Cj����J]-j�C:|U�a2WK4�l��H�6�8k�F�c�ؒPr���0�Xo�:�f�Ά1+��i:�:�(�i�yH�A�s���~F�Ά�Ķ��-�Άa��՛Zg�8�S�Vg���Tq�hu6�)��S{'�@�ũ��j ��Y��a ���Z��a�\��Qr(�V�l_��	8&`Z0-��L��:��Ά��㤴\��a �&PZ���0>I���к�u6t$6z�ϫu6�5�K;�:�lr=�����Ά��;.����l�[L�~��lHn��.Pb���0�X����u6$��:��\��a ��G�Ά��:D��^g�@b��Q��a �Q����0�����Go��0,.t*�u6$��Zu6��Rg�p�)��o*u6)u6�o*u6�q�8'�Άq�S�l�H����l~Ԋ!�P�Ά�Fm�$�wZ��J��A�^g��-��ku6�Ҡ�ث�a���Pyk�>���{U3T�&�����@�wxo�eM�g��'{L�m������C���T���E��S,e��ꋸ�pfY}�C� ��)2a��,߿�f��B����R������&��=d�Ō��}�S�Fݿ`f���@2���5Q��������׭,s�&�ϋ��������l��x�u�h���d�Ě���՗Q�"9����߷���������\�$�Y͵-���\�;���Ⱥn�y,��Y�U3�BJ�Ȓ�9����a�k'�����l�ZJ|{�E��a����k�@�D��;��H��ඥli��[��G;����K�3�ٜ+%k���*?�O�&��7yJ�/M��4<õb@}Y�>��ī�6ך��a�{x�yIъ��P���x�R���RtǱ�8;�K�	�Ǫ��Df�t�\\��\41�I��
�%���p{g=��uRG�&�,)���,ߐ�ғ��A[$���w��k���l�+��E|��+�,���e�����0/a	k�n������Mj�}K��"��l�B9���#���|ָzϽ�_C����w���;�x�}��?�#L"2��)a��!��`�����D�Y��B�q0���뾈��B�u�ƛ)4_��L���W�LZ���L���r&
��}9��u_X�D�Y�/�`���/�`��F�V0QH7�+�($���M���3�淈�;�L��pD{;�L� ��
&�ho����B�Na�t㾰��B��%;�L��C��N��f�[;%L�!rYwJ$��IY t�)�`�и��I�D��B��"�b&
I�yS��ڋdx_��D�Uy_��D�YFޞN���vj���]=�a�R��>v���V������3_<������LR��Žq%�[������oo�\<���__��J������R3��.n��%ת�[,[�bSkI�^j�a,���ۗph��]�Y����z;�T���_����,|�m�r����ǝ��&駺��C����ǻ����{���S/ضq_��p�����(ʣS���D@��eu*��B��}Ӗ&6g�� ,�;�f�S���gz�Vt��y��D��>v
~VH�s�kA\{�2�Z�%��oZ�3�����\�!_���=�=U3|X������uCk��ǖ+~q�f1~�_��<䵪O�1	�;��/!����a�!�5�14�����]��6n:�Ӹo���#��^�{pK)9�߂�7����9N��c�q9�޶��F�7��=/��d}�,�^<�p>�[G��~�c(!����>�}��?�ŭ��l���'�/�]�V�b���|�����W�i�������Ǐ-�v�UA�C���[|H�<uRV��x�M����m���!Kj�Lg�#��ƧG?�X]��F}I�s�,5q���EB>��/R�N3�N���c����y>>Z7��'_�y��냦���7���ۺ�Z�|`(S��k���_�gQ��}]��;_��%��g;�{�z^��V~�U�������ҌZ��l7��o�8�-�S�������ͨ]b{��'�tQ�Ìo��±����hsMk�z�?���NLR	����jG{k�f�ֽf��a�9��֋@���^�u1�����������jљqCތXi���w]\?2f�=���߶������j9�l�����a����ػ�5Rnf۟)Wr{�FW>�dl&�y��\7����}u�;FZ5º��M͞��K��Wv}�=r}����f��{�}��k�]��q�Q��oc��o>�l�'�m7����~�#�ȵ��a��l<�����׷�������O�z�p�dܚ���3O���j��l���]İ} ��mj��T���a��0k�H�x���ſVԶ��0���Lsj\����s���-��:g�w������CL�      R   �  x���]��6��5�b�@~��]�Ţ�Aw���^XhleƝې����Kٔ�!�؞�@��N�P�sH�G�y�=�N�w�~��ޚ���F0!�c�;��� �������w�9���n5�ݱ�1t`����0�y��`�_�+�ƺ?��7��@�כ#!�y����v�=�L����i���wT�zUDb��1!B�@�"��Yft������5���(�7�3�,X�fF��g"��(����@T�e3�l=�OHnVD�7Z9Q��YqO�q?�֧��fu�{C�kml]�!�X���3�m���w�㶓��f�>�۰m�@ �t,!F�x
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
-k6i��:�WR$d��%,H�LXd�Y�y�� ��L0�kfrb����X�f��� g92O�yN�[��@ƪy�3��NC��E3���^�Ma��"n�m�HtO��.̄�Oi���}Z: ��������1�      T      x������ � �      �   &  x���Mo�6��;�B��6�|�C�HQ�N
�C�\��(����$��F#�=5|�����K�3�5](__1\��~�1�ԋ�%�"|I��(��<���ϗ��uz���o?.(���/׀r]�|�"`C��bW�%R�ϼ��x�������A��KǕ#�L���_�73�����q�q�Z����4c[��,�	��sS��y{\���ck�MDׄ�É',C��	 <Ҩ�)e�4�8i��q��(�5��TO춏��,����f�`hG�,��� ���K�}�$���\�/<T|�� �7*}�(�+Na^�֒_ҳ�A|��Î� Ɖx�8>�����!��YR�FkDO�U��@4�x���bj��L�=��yxm!������|�9��7���e@U`&����*���R|�H-܏������V�!�M�{6��V�n� oPh�R�z�*3�8ˬ6���`
:��ޚ��P��j;�v���ɲ�Pp��JN&����fn�m�X3(�#�	���|�F�խ���1/$^ZR=u͆�� ��V�2T�Id �|���D��6�M)N����S��]��w�	 {�ȌJ�-�$�A�-�\[����	���Ő���&�SҊ�To���4�Ni
��Cs�ҊWCn@�wI�{V�;�A9_~��ӧ/ӻ����O�����?~xx��>Nx��ұ��_G���;S@��W�E��`��~�K4�⬽�>܀s�R�oȃ��t�f���T�D�V��4�+�j_�g�����^hu��-A�8]�����xr��+�75�����B��'_Jq�D�IƼxJ�R|�X%��G��c��dAJqc`1$N���l�^)>g��G6���^G���hJq:�����=Ҫ�,e�tT�~�k�!����ց�d�[ϸ���Թ)��Vq����|�)���A�V�^���}M�m�8}���p�0��Vbg�J�Uw3D���(H���aA�O���� �&q�Gbg�#BT��5�ḃ�Z�s]���4F��,I�B'cJ�c�� �{0��      �   �	  x���[��6���U��@���a^�%���H�]��Iy����A���Y�H���d6g��e�/k���ج+�ߢ1f������å������d���26�:m��M0Χ-lf���T�L�귁����)��_j��B��&(mv�~B�엾����t~�T�N���YϾ�mv�����?���p>-Ǹ���N�sq�2P� s�Ȭ�C��#J��a<Ô��n�@ڿ��e(�PP������\8o���������bAy�<.��c�a�q>��	�� y�8��x��̽#�-c��8- ��J�e��%a��f�w��ܿ�����	��Ǧ#6�
 j�@iw�����������h>-$�. �Ew�fs�0�Mٸs,�U�?��B9�C�H����@͉�,�,�d�<̚j0$W�{m�/li��������&t�����F�H	[�_�Lay��(	)}#pw��x7:P�m.��C)��[f�2Li�ƶ��I �������PA�2�Hk��>����kQZaaW2 z�o������E%_q m5�e��0����e�oV�;��I����� k����Ǹ��B�3`4KW�*(e���}ػ 1�,~Zf���&��W�{�_�2����y�ت�k�뛒��}����2*�u󅻷��k?ߎ����d�B���2A|1�Ӌ��j�Yl)�@xY$B�܋�>*��E�||?��p�"��v_�׼�g�f��]�D-R�r{LHz��G`� 2 ��T����x�%	��Xp�`V%_qWv�F>����c�$�A#��Z�[��'j��{�;p�Sƚð��X$@hnM��+�tG��-B0�&���NR�^��s ��D{D6C�"��$;�䧇#J�c �EP�{�2e�|@yv����D&����3�%����llD�H��W�@|�SzX�WD�P�*@�꼏'k�J\x�A-����ģ)kG$r��B-����_@B&�ѧE��]#.Է8M�~P�������e�� �uXÿ�;){}Y$����TH� ��,"��rl��eb�$�*},!��Z�>+!�V��'%���y����;��	� #���}k�'���~���i�"雦_Q�Ը	)�
�bڐ-�P �e�)iґ�yDx�*}l�i�N{GFz�P{G�ح�g�#1/��#v�>z���t����x���]!���h�G�~؅��_��"i��A��L�2}����ͅ_;R���Ʀ/�1w���%7�}iݖ�>s�$�����Ɲ(�~\E-���@�ƣ�p�>s�~9�P7f9}�؎,&��$XI��H�75}�!�Y����<��/⭇�-��H�����p�ð���s��I�Ʌ�X`^�bی΋.[����ο�g�]ș"�\b�����k��n��u��u[ܖNV�L��n����͖��N�T��r�0��	T����G��s���|�� 몿T&/fXf�,13���������3׾a�~Ep�(�ʙ���*''���$ܫ�VO,�~m��'w�:J�P�����~���}b��u:�Ŵ��Gl���H�[��W��������jT$�#I����w8�C��=>o p��@䩊̵�EB��
��/��D,3q�t����4bP<<�H � 	m%�����ŸN��~[�y�~���U�o�p���'�}J&�\�X$Xh0��yV��˶c�\�E�p�QV��A_XM*����+|*�Ȟ��V�~a�B@:���E"�F �P&�P~ƒ�ab�����G��*}��3��W�0�#�wp�0,�!I��^u����B���7�����M�H��o�
��"�צ�@_�3u�� �t�'���+�?�o9�ܨe�'����-�`��w�/��\:��°�`��W����vg秄QƆr8x�"Z�M.=ܬ]�����Z$@K�ɭ���j�U�V�Zf��._u����i:�����@�곬N�O�8��(��y�Z$@K��e�{�����yg�K��I-3����O�O<xVe��cLoRf�M�"Z�An4ܤ���g��/n!� ���:�
�O[��	+T���-s��X9�H�V�ˌ�]���w�x4��V*q#	�Jr��&=�:}��¯0~��֑г��u$��-s }�.=���
}t��:��,!7q���h~������E"��|��"�O�@_رU��_Q*@�ӆ��c���@��s���{y�~E�k�:@68AܭU�� N��s�~�M-��to��VЭ�����Oj��c�ۥ�,�1��L�7(�㯃D�*Ɨ��m��"�G���KY�
��zt�'�}�⭂ݖ�2ӯ����4�Ű�V�×�H�ķ�����Ы�gg4�"�ZO��r���4�#)حl�Tz�ނl�� �=J?���v �vq(�H�.��/�&����+>?wu�~5�/n}C'��;�E"�F@W������}�<      V   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      W   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      Y      x������ � �      [   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      ]   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      _      x��\k�,���]g��;���Qk���c�$(K��t���P�	��T<�Oȟ�	�����������k��1�ɰqP�'eJݿ�*5j�(����a��T(���a�^�5m�D�J�;��{Pj���0P�'%J�ߴ3���4�T[2�Rϱ��NS�kH1P�'�i*�$��$>M�w+{x�d>O�7$���W�mN��`��'S���7�Sl��'S�ϡ��a�ʈs���a���{��L����\؝R�7�kX�^��)�~��^�O��Zܷ6�_��1M��k���ba��o�|1ߪ�?�H���T#>)��n�cVm"�)t��ۿa��4�S�S\�e��������u>�6s.�0P�aK�n�%�)V�6s�h���ĵ�sl�a��^/i1���*m��z@1��8��:�z^��n˰	aN;��ݦxP�v��sl�a�ru���6��:u��)n�u��?����}y��0�z�P�v[�رg]���_�׆Uφ���b�b{udC�t��f[�XV�hX��c��pk�11�R�h��bMC�����-/100�)@��V7���:�8��l��l0ja;�5��zQ�O����܀���7����_U����)>"h=�%6X��3���Kj�R:M!��0Pw�[{3g��U�?��֬|�p�@�Ŗ�Mg`��3�f�}k��nc�|������baxo]���8��\�궬��0�>��v`�9�K���f�."\�ϫ�9�K��z�wuq�t���j6���̹��էQ�a9nV��<n�;���{��|lٛ�^��"f8�%,���<˕n`����A���=�a��O��6���ylp��|`��{YkV���p5�"vkZ�ugɅ��mt�0Muuv>Oq�K�nO����ʺ:�U�p�|��B���OT&s���X��t�Yr#n�Y�t��3#��ȩ���7�RG8�.�Yu�nu*ͤ�fe�%U��y�c��|�͜)�:_sX遁�N������cF0��Қ�%�50Pw�8���R3�^B�KC��n�\��-N�jx��[Ϥ�x�0P��C����9<�syoj:-��גo:���<6���)N�R}��6�1��E��%>֣ΰG�}�u��a�{�_�:-�Ɯ��NK���~5�S0��8��yHfp_ڰj�״�8Ňk��z���޽V�;c.�k+w�V�S���cISL��jȰ���@�d͖�����d����c�ϯ5+C�]%=c��a����U�*9\cм�|U�#-u����Hp	qd�{� "Iqd����)Z\�jm��*��DD�����V/�׆�*���늆�*��c�5j�GjX沴��*�����e�z�����U�2Te�-�YM�0�:�p����^b�k��8Ұ���$�U1��ҩ�b侶�t:e���Nlkz����5� @������@�Fq�i:�4]h����!qM��T�)M��-W�0P��v-�r����N*�6�2պ��a��c�ѕS{��ʈk;���nS1�*j��S4�:b*���k`V�L��ؖ�ؖ�Xr���iR���%h)ARXܗL�� �׃���m�̅�չ\�y$+���ǳaиO�w��>�]��w�����w��a����r�E~�G��}E(P��j�IjW��m�j��t*��6�!RM2�R����$1W��00(:�;��*���$|����`J�K���)�W[��
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
�|<L��Ȥ��H��*B��m%�i1ީ��|����p1����ӏa�&��C�JҖ@("{HȦ��P\*1��J���Ы�\��C$4�vz�yL���vj�������R(��{�y��ƣS�r�Y�f��#4xW���G�)�m�g�Ti+f��?}h���%�����4BaΆ��h=e~��W�b�Z�h�y�r2�}�S��ɠn��L�ߧ���aY(f�Gۓ���F׼LWe=1�z�7�U�k�Z�����^mU(,���i����B��ge���P(��ҳi��Q(|�}�=��(��R��OJ��o����^����F����qh){�\�wK�tK��[/���$�-%n|��=[��(���F"^K|��l4��'��7��-      �      x������ � �      e      x��]]��:�}��<�z�:�b��$TB��4�n���H�6=��i�m /��R�
^)��f{�c�$��4>��}V�����]%�M8D�<ߪ��o�՟O���3�$Nď8��O�ivL
���c����>���׿���~�������$;��l�H6cO��߫.z���";��^v3��uY�I���� �#ϷO2��I�5uS?#ٵ9T�|�� wY[�M��ս�c,���R8�3��:���A���9��0��9�U�!����u��sЅ3y2�Tѣ~R�5���r�,�1�EÐ�\�L�~�4�U�|O2�Ȥ�����1�G��Ő�H�0�OɆYӔ%�`<�x|$�������cl���^���4�}�vX2�,F,���;ߣK���[/�����c� &C���M� %����{��(�[3�.��R�e��Oѵ���PI���O��&%�bD�aD�{�祎��ك����ݳ�5x��T���I^�s�Rd�T 
�>���:�C���t�N��˔��)��1�G��Z�Yv���]��T�M{�f�ڑlz}�:���ϣ�To'��u��أ'%�<�/�G���ǫ���U�팺X�H��\I|L��iqL�"���7�]�	�<��m����q���?�Y��&\7�~NX�&O$eD�I�z�k��C1�Mu"�����h�U;HIo7��<NW��J,������>�aA�����,r1j��������"e�L��-;r��%#—�tڌ�����u����ݩ9�؜8)=ƀ-�J۠��-⹩䳯:�\�K�ZL�k0�;�s�xZ�uC�>�u=ys����li沑;J���lfS��$�[$�gyiٹ;-׶�g���Ycؙe�s���Y\��#��I:7QF
�K�fĥX�zF����L_�<�L�&��<��)�N�6�E�h �o���n��p���=ݛ1nu�p<Aʾ
�lʔ;2]k�oJ��zG��g���l���h�az]�e蝑�)��є�T���3N�ɨz�h�5?��I��U�B� ������؇<W�3�{��|Ę�����������'��@�����C�\�F�B�V1t�e���y�dW���zg�g�ۭ*�F�\�Vs)*�������3�x�V�^�Ӎ���o����
W6r��1Z��>w���U=�+��ї��76ؾ�\I�
�z�"O������նl��{$(�����cǞ�z�2^��\5���,�~=�P	8���r=i��e3lb�P�Dp�mX�ސK�xM��"n��D�aB��UN�)H�����ʌ�=[xs˘jY��1C���e\x�kz�%z�Z>)�VTu�#ʢGìKC�MN�D�q�Ԉܝ��Mߐ���3K��o�e*�(�P�a�x�&������� '�NޟcN�I�Us�f���l+�D�ԛ�ݩ	�N��[Y�$)�|U��4��`�)�L�l 8e��vh�M.a0;�0�f����l��pzs�<K��`�Cd��7pE��n;�S���J��|�ӝHO��£>^���WUߑ��F�Đ�!��d�ҝܣ*b+aS=�M�9]�H�����-�ΖTk�I����I�!ʮQ2:��	��B�CT��!�Ĥ-:$�����L�[0��xۯ��y7��U]To����PZ����|�������V�s�;L�zts��|m�@.�LE�uS鷼�v�2J���>��������~���������gz�J^%7���6�Wdh8Ԅ~�bR桺���:��ic0C�d���1֗�o��+(���3���_)�#'<RW=U��9�F�5Aa�R兑�z|XR��Jf�A���4}�W��Q\,�2�c��G�Rv367����F��:�j�Ī�pk�%��c�Bg�8�4&���UUji�͟6��jy�'/���̎݋����Έi�� ��3O�_�I�%��;�(�R�?^��򿒍۫���w�WO��Oc���3vn�VI؋}���f�Ȇ�Ro��g� �Ӥ�`�2��V��@��v����:l`�T��(��:|����M�BhJ5	�|�i����EX�7�:�D��rv���VW���j�LΚ}�Z�Z�PB�b�F�JT4���˓����H5U���a\;�����|�Ic⮚d۱oV�<��*-���o=5����9$�]mQ�:σ}��O5�R�u��tkF,K���`�W��������*.s�1z����8AN��ITǍ�\`G8	���[�ŋ2�$����ʃ7�k�Y���Y�X�/�8� _�~C�d����U�[;\�r	[��|~�Ig �������5�e�՟r\7�L����L�f3.���ny��q�˨`�!��;�\r3*\d�8I��!��lN�Q[7!�9��AÐ�pE�V/����p��l��
 >��^?�g���%v��o���lj���I�Q���;dФ�>�vP��E77����@�{'WY`Ȑ�]��i�˷6�f�pvX����隵���P_�vA����5���)�C�������n}^k�.g���m}��)����){T=i�G{��dlݚ�
(S���,�%�������@a��g�4�}���fÐ/g��1���Z���A�2s����A&�N�-0d*��l�|��ÈBLC!3Ru�}R��5*~�����vM�_"E|Hi4��z�ٶ���Lʚa'p���',5�$���	�yǖ.0|��}���_��=ƾ�;� _�n0Y`�'�G�=(Rz�jS�Mv5Ʉ�����w�!o�βVw��ͦ���\�nF������mw���G����{�w��"��Ԗ�s�E9&���*���o//6�W�e���X,0d-g
��}M��1b�������!1�6Fw��]n����u����;���i��i<��j��7�V@�)x�j�#|�I��ʮ����]*Z`Ȝ8$�Q�{� �s@��!�phԺ��`#�Cf�zٍj��	�Bx�	��';��U_�]���Hl�=�ǉ�'s��A�|�;�΂�{��0M�>���[�v�P�ƽ�ZA�^�2�b����a���;^]39M}x�v�@x���r1����C?n�;l�B�>QR�4�~=�h��^U; S�[�)�Ӕn���~fX��+[j?>�gjϷ������zc��[�X|����)ƭ��
�γ���^°��0��z�ׇ�C�u�i3ĺe�j�V��]ݙ�n��j��Z)[	����g]Vù�x��l	%W�B`CN5n:2S.l]�Ȇ�1�4FB���/y3��Z+�c`Ȕ23��{t�W�%��Bq,�
�140��!�$�����9k��*
ZW;)�,�OI(�����Y7J}�m;�'�K��%�{��ޥ�	_]yR����jٶ��z�oհ�����9��=(r6��f|��n���Z�J%���F\|&�U�ߧ��9Z���`O�+�{����:��_���3����c���C����|):D�d��{tD

Ƈ/��������aA�N4򦬯^d�#s꽟rp�0�H���9C��;X}�,`�d`Hyp����aN��-<�3
3�L��3Ŷz/��w����ܿ������O�M0����-��d����Ulݲ�vO\lW�,�R(@Κ����G_�x~��vs�#0�V�v=:��6�#l������gf�z:���y�����,�/�_�~��������M� ۑ�ٰ���7�p��a!^�#]�t����X�K}%����kus�ta`șo�z�C���`AY9\�00�-�� �P�0���U�=���	�.����UX,^w7\vL�Ze�P�M�5��C
�����;R;'�&��t�4�⁃�x�L���
?���������;7��z�iP ���p�V8��م�n�!�*�2��
)]`�j��i���*V��dJݣ>�(�1;����zr��s�"A+��=I(��_�SչP�7��r�L�4����jS��[^�aʌB}@�aDI��$���[5��@.|'�2R��XuW�1x �aE�V����޾�CR�o�� �  &u� � ��N���]�wL�c���o
v�(c�T��9����>.�+"�=L/�D��^I�T?�/|�N�/����f���{���v�>�o���Y
F�\*�mեu�;|��>�A*��n�#2�g�[pN(�T|*Jt���ʗ�T�u,~~Um�U����|�ͽ���:R3�n^�lhrZ���qyR�׆���S����<YX�|3hÐ�� %��0Lwǥ�Ħ4��YC�s��������7g�0���{��^�?5�<�t��uӰy*��X�C��9�>�?���c��id�T�30�R�`�,n��;ի�d͝��@�ɶj��<�/v:�a�	�l�$�/����v�EU|_�z��<��A�^Ǳ`ȑ[%��Eެ#ss�5Uj3WS���Yj�yՆbz�;M�;M�w��W$�޶aO��)�&6E�D�R��H5Zs��M��
s�����v��s�aȖ��b�3ѳ]ĵah�r����3h��~��w��� ���[��	�m2el����owr~y��N+�<�DM���^���t��g����Ԫ��b��mb��fl}+\~8�a���f�i�-���)��ah$����Df�����6�Ulg�w(���&�Z�ٔ���o�#kU���/c͕{��rv�,նlG���z;��<>#D�����<_%�k�svC�vC{��0	�F�KO.A>+�-l�D��Q�q��[�n\�^��|��a�X����e
Á�Z��`�<���J�邦�fW���B�����sJ��ǑuB^�_������L`�nU4�_6o�뱭�R6�j4��3�IQ0��n�l���a�kL�r��>�?�G�~�t��$�c(-=x"��<,�U=3�ٹH�1s��:f���U!j`[%�c��C��	���&���,�`� ���0��	�%#�zɞ52(_�] �a)d�c�K� �`�p����`h^b6��m�н��A��]�y�����x�P�5��o[04c1{���N���w�e�
�{WR��M�ڹ����xz�P
0��� b��Ḉέ!��y�燍�������ڃ�'���>������Σ���O�9���=�����r۫�vYѭ��b
c����s�G����]�}'�-V�g�T����Hfmru��-7��<X]���Ep�ck�g��1��ǽXn�l�a�:K'|��q/ZN�>�UY��8_�?������p�      g   �  x��Z[��:�7�.zz����:�N�-��qNU�� �Sp��E�+�/,[���7�=�h�F�Qi��q�5zP��$͟��e��I�r!�ߓ;����q4�sީ-�IyC"1yC����6H��$˵N"*/�G�G]4�dSwZ�u5e�l]Z���s[qIa�y[$�I��lk�`���M]�k��9�vRO�&ڥ�!�H̑�>u�1�6��|e��M���.�����娱S}Sܩ�!��g5X��ٱӿtI��z���qљ��8l&�>��Ǫ�~��� K��\�$m���<%�>pw��C��7�S���й�hrY��.��>�Au`2z0�`"�L�Ձ+n��*�P?p���`+0�z�PD� �:���$T	���P+$4z�'4�z5&ԑ2�H�BF���ht���P+�
h84������AA���'��+��:hѷ��a���B7���ٺླ�<���}m.��lg��nK�nf.���m�'W���ynA҅c%	t��^-�x�s�ޣ���B�����u��X���t��Z�g� ����-�ϭ@A�M审�Hu��CL������d�4��&��hx�C��fg�25��e�3��"�K3��,HUf��]f���6u�8I���
��BB!2�5�*�e$$��`#�v��k
lAi���GH�ŷ�Շ�Se�g$fg��W芛�Q�UV=c���_r)O�U4t^�����ȳ5�4�D�xؙ��i����^ҝ4� Q�.-���a������~-A���L@X�����Hޕ�P����婟��
��L{tl�.
N[��HVi�lj©���bjl�����?��Ax�����ڨVy�&-ԞL��Z�0�6BQ��#/�*[����\�Z��kc:�.i���+�q��9��.:]��Q��ҋ)G�Q�\�>}*8s>����mEڊ4T���½�2�X�s ��lE8�V =�Q؟	5#
�3�]5�,FkFG`������,n�ܛS��ֿ���s��,Z{�$�Ґ���o���;���7��
.�A����������^�٬"��v6��*� ���Fg�,h����>!=
:�ሦt�#l��*Wk2׍'G�����1WT���p�?xt��
�ѳ��E_���Z��v��^ގ=o��.���М4�)�$�1�T}�L$"޺�ǫ�nٕV?�(��{�_������lR�(�D�Ȝ?.��~��b��& �{HG3����'�5bv�xCfÉ����82� ﶊs��=ۍP��p�c�"Ïg�������X �f{E+���G�=�6�J{}y{��I�աt�R��R�&���t��s���k��O
�F�1G4����l�G�@�i���!m�]�"y̳��bĆ�.<F\�Ke���r�_���U�[d�GR��H���:ʑ����g�w�qJR��/��S��$-�c?��+���X=Z���������L�E����eYvQD���i��?���q�⨽�Ҥ"��ͱH.λ�������������X��<.�E�nE��+T�����4�s#��6벀�:^}�K+�,!����<����	e#�=!������o����_��r��MH���HRn�N��,����o���x<�o�      h   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
c      j   �   x���1�@��7�i��ݍ��ĕ��D���/�#1��}/iN}�fg�mzvu;�#�,��8Vr*!˅����	�g�6�W���n��zo�7�����-�1�0Y:%�6��F^��q�܈��4T
e�2���U��o�/>;      l   �  x�}�]��(��˧��a�����ϱ)ٔ������od�2��>�~�������Y˹��ϿL�F�@>(��m�sO������[������[�A ��q�Y3T�F�Hv����<�����C�g&�d�6�,� *oi�?%y�q�D�A��7o'�.*��qg�'��@�h�t�ć� $��)��2D%>��;!Tqĕg93Y�� !�ˋ�� :y*�[�� �1hޚ����TPd�&� 1/9D�AdBT�=!TQ>��`��&� %^�W&����O�2�DSb>Tш�A�� H��N��d$�0e�zL��:�H�G2U��
�D��d��	Q������ ��(ge>TQ�^	�A�A�=&�M�b��TX<T�b.|��ګ�V*�A���*�]�A�:��u8�Ad�T�4�s5�uT]���� H��T9Q�8��Ƴ�Y��v��At���v�ARh,*oIHo����R�ܟ8�O%&� ��f�T&�(�`J�Mq��\'Ar��Bw�d��`N�Jv&�W&�H�@���0�(�X/1��J{�� �@��ATJ$�W&�8(Q�\b22-Ն��*���G�>���|�l���9�^�5��u��S{��z� |�/S�SQ�^�&�)��1WS:���)���e*>S�c��_�]�G]G���	Q��>e���C�-5s5�i���2_�)dɔA���8�ON��#�>S!d�-�@NDu����5e,�=v�)�h�TSӈowS�)�v� ��	^�!L�R�)N�)� 1O(�Ad���	?!����SA�&�#_>*�!$&����;\�U����$�	��|���v5	��\d1��L��`1�TbO5X�k|��2R�0Q��Q�;��:_y���eW�&�n��<W�ř2��"a2��
�t����Q�_�u8�A�xd~r�"��Jq�2��f�����d�a�O���"��9�_M�A֑i���Oȗ)ܡN�9�§��Wj��M�r���L,wM�b^y^U�+��%xUd{�2�B�F�A�A�K4�:7D%>:��&�8��~
[�� '��%9�x��)�`���`� ��e
�SA���P�ΐ�\�&2����GIt�3�����A�������-�����&����2�L4��^䒼2�p0ѕ[ya�x�<e,���NS�C�2A��+,���*oYX+}+2�`
�SA��қ��x��G�q�]�Z�s�A4��=ޑM��~�DE&�[�%軁�[�80��:��A�%�ƏΨ��D���E���� �'��0�ۏG!�����ATB����A��?D#D����[v7,��&��^D"D��#��>�2vߞ��e��dB�B�S�;�GQ	�|/yd�G�i�!����<2�NV>x<��A|?�>��ב�y�� !��[��:R���#�(q�e=��-�����ATB���Gq���p� !��|�X��s�ABA���G�s-����]M[z�E/Y@tJ��w_�h��&��Uڵ�J_f��vjm��u$�Y�Kd=�
��@T��WO4���KF�awY����0�k���tO4��71�j�F��W_��u[��AtBw~�d�U����*���%o����_��o�5�}��=�,�E$Dp}�Q�����A,�$����Ȓ�/�r����%R n�{e�xO2�uQ��e���%�ޅ�.���ǡ�ȝ��w��qP��%����b}��%�_�N|����EX^J��~��˫c9�_D��32%
[��PD�u����@����H���0��=DPt��'�sک1
�xh�\^�ġ��������N]��oY�K�L,��ђ3!tl q�2Y��8�_�,�jsw�^b��s�|�Js��+�D�c�/���,I����M$�}I��i`�IOLvkP�)2|w�%7quj�N�!i���WM%�n]��/Q��
F�H��"!K0�E�/�6$�xb=9�7���U	��_�ez��"�H�X;�� 2%��Xd�c�u��[_�ش�b�>�R��B(�>D%�ZQ���oB��u�ϞJl"Á}���"��h��� %vB}���?۶���Nk      o   �   x����� ���)����8�.̈́,K���1����k��问�����(Y�������c�t恣I0�f��8C@Ղ�7�(
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
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      {   �  x����j�@��w�B/��s���msa
��@ ��PCp@�y��]�T!u{����Y�a��y�����]�ϛ��5��ps9�jĚ�����īVEHau�?7�rX�~X�LW3ȸ�4\G�#UH�I�}iX�_�w��7w���&���}� -q
��j�?�~�y:q��g;�"�Y�V(�L@2���p���}����f��K
f��)0��=~=�c>#?ovo�(<�%Z��8���m(�YX>^�����AکZ�j4N�
(N�Z��X���z����MQMT�>��k(%�3O�{���8���3�����Z_�݅j)U3��O5�G*��T3��j��L0 :�̊h�5��c��l�h�;���L�%Z��m��V��m�`�,n,�;�v��y,4&,J��<+���FfX�F<!կ>F5l��FRSW%��%�*[�߅A�/�I��!R�{��߹5R*      }   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      ~   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���         }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      �      x���ˮ-�������j@�Z]�ðQ��7��0l�@]�ߤb���Ę�6re~#B�(^~���o�������߿Z���O�O�����o����?M��}��_����?�����G�? }�?���.�?��������������1�cI��e�=ZF�@?���_�S��?���sA�ZПZ?P��������_�������������뿾��O���#b���b�h���*T�Q�i���h��>����h)�b��G�{�f[������]r����?�7�������U�ı��?��������G�7{��~����՞bǃ_����Tmc�x��xX�t����_9�A-{��_@�SЖ�����;��Y�&�O-o��=@w@�(����+�!�U�QB跑�}��W�TnE�/�������*�)����FR���?�ގT��/��FW��  ���7���­�_l{0��B���?�)<	�O��`W(�p�by���g՞����ɟdi*a�5�׉��#��mƿ[��<����v�;��%�:}���Oo��_HM!������J��	��J�7 �!������$�C�(�V͸��P:�/0��As��Ä���yN����/W_'����b�I�-��jv�H��;-�
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
A�T��V�n�8w�̆`�8����4v�&�^�����uV��reJ8��� J�|���{�]�Gh<���~KA���F�僊��Δ��,}9������poR�%�N���4;v��4{q!����\:�N�x��o�-���9����f!q{��w.2���Z%{�`��?5G���vJ���C騇4�;b�Nv�����7C�Q�� ����t�&K��!�kϵ)�?j]~�%$q���1�l�R���1T�>ˣ�Z�9\}���'�/Y�#e |o6]��T�~'�C�t�U6�|ѩt(�w�$+�G�����fs{�P.�b�m|JV	3���e�rE��?�)_��)���l:-_�rc_]�ʦ��r��%;�Bb����L���k����X��L�db^t�_�vg��@E_rMHg5�΃TqLL�qgӜ�����ͦQ��_ٙeǒ�j�y���SWc��ǕH�)0��r�og����ě�����h8�R���_���P��tStҟ�L�9C�.�B��s6O}H��o5�B�nY����n���O�9CI�y$��m����P��F5�茚ke��WF67������~g��<)a,�����c��O}	��<+~`��h�\r_~M�?�=��<a,&3�?c�搕�?�B2z9~
��-H�L���͖*��W���I�j��M�{�F/����/[x���:l �a�yO^��K�x���B����kL��m+>/X�ayF-�塬0�a����LiqxE�7e� S�c�I��Θ1Ŷx�P�LgL}y��}?K獑��Xb�a.���!����5O��w41��dgevm_������,'�H[C���1�T�]Z0iJ%��B�ڌ����o����������b�u���mh�5ʜ�[�W5OF�^�׵��8��~��w�i����E@=u�4���~}���A�������&���Q��%@���yw��i���2zqWnޛA �����I\�S���].\vTL8F
�p�<c�e}i~�B~���Qꔟ)�����Ƽ3z�k�b~�6�0��۟��kޘw���fC��yg�#sbG�#a����Eh�-���A[.��0=���5oˋ0`3ޔ���6�00�'��!h�������.����K��oEWf���|p]�����d�|p4�1s����˂���$�0-� �0���bK�:��dô�cu&>�[)�i�0j�,9�J��k���?�貅��ioY�au�?{/o�;B,h����ơ#J�vw]S^���N�����������2��R{L�D�^w�l��-WS>�.�`�=NK;�������{�����]y���^2��h�}Ǡ�\q;�<q��X�by����G�v����/;�0)�CIZD`�d,6��gp�&�gp��O�\)3 �k����,�z�6�r����^r+"����D�$�#:���j���py20 Z{����A�cE�h,����p���x��Y���T��D"��u�e��U�:��0-�F�!����m�E�k�z�|L���#
�������#��CGɷ�(�+��ֈ�/����
0ܦ��ä"+F�R;�r���Gh�a���iWJ^P�,�|���S�M�R�?��%-xĴW�g���u��c�b���ͽ�Ϯ�0C9o��Yo7�����{sa{�&��X�N�M�r	��w���Q��Y/�ˮ;�L&��oPJ�}G�(u�J���y5߿F���a"��;�=��^�_v��y�X��M����ӊ��4?D��l�3z|kDxbY+�]�x8Ͻ]2rE�{_Q���ƍ2�{���e�)6fy"�g�/)�h�:�����U$X��K:.���"��r�L����^"��]�q'̜�)Kx����	��L�ԡf���u���>b��z�,��7�n�ײ��yj�غ���R���u0dǼ�;�ws[ަa�T\*7��`�����7e� s=�����Rf�Q�t�����d�g�!(e�X.�8�;Ffe�~T���]�q��/�����Q�[�/���v�$�
43�<�#71�?��~άK..�0�p��m<r�)B�U��D�N��oJw������ȇ{S��5�1ţ�3����5k��
��*J^q��e �+�T.�LAkp���w�F�uΣn >$����H}[�y��<����x��Z�N풍;R�<�-_�%w�t��X����D ��r.?�\$ vʬ6�)P�Mp���aSa����� pǈ%��$�����{�o]}�K:VC��-��˞���4��%�ch�}m.;���[r� 0����͢䳷��(�%w���&��\�q���FW��b�)��FS�y�$O�}ڦ�ᮔ\#3��/�&��e�ԩmYk��?�\"3��Lm��T\ra=}�B�cXvʼ�Ԍ�R�ή��~H�t�ƍ��VX�Z�ξd�k�Tg��ٜ����]ש2��G?_!���қ��~ y*n�&������KߛC�D\ a}p'�<��D?�G��ugMy@d$Oy�}SH�#�'z�}SL�����
�Ey��~(��:���2#�8�׆�K
M���k��-�@S�_l��m�e����S�M��`�-�b>�.�HY*M�%��}�	�ֲ    .��b_�Hn��~��������ӧw�3g�\�0�+�
�%A��ugL}U=+��k��T�fG�����KeF3������F�줺:z{���#�"��R��ͭ�����=�R��c�I�D
LU�a.��3��D�����)�T��gD���̠���1y5ʆ����0�>�~��16HRw�_���0h��h����`]~M~�*&�*�_��������4\@QO�r�Jno����I7yt�K.�КP�K��F�7�Q��[�K[Սb����C���`�e�(S��biq/F�[.Dm�ts0tm��~I�1��zƶ/Ę�c����aB�$\�A}Q>M�s�L��a� ӫR[Զz.�a�ޕnϘ��������\Jz.�a����0z�a�æw4L��o�\/3�pK�����~/��^��J� ��r��j7��%��#��4����&�(㫎�/I�~I�����향�N	�1m~��.o;7�ـC��Gn
�z�O=��^6z���KS\@���)얅���:cԱ��<S��q�1SW]w?�T1�04�xq+�g���́*֨�\t#?�O�j*
L+&oO0X�\-�m���ۤ��a�_��-�/=W��;F��ĲE>��/mq�W�\-x=�fGp%�j9|���j�F/d�Rva�/��A���_v1�2i��M]v�CR�.KL��;f�@��5�:��D������ y`�!�ط��撕�N���lc��:O����b%[.���I�M��Vv�����6����]X�\��i���p����~I�)��n��%a��	�J�\6̘�Jk��,�e� �k68J�`�(Vd��ξ³�c�"����n��-�l��������(��8R��lU���H{+�(��7�C�}V�*T�'FěbR��:Q�~�� `�~�q�'���E���k�����36���m̀���U�t�L�|A�P�7��_���;��o���%��`����u���^�cF5@�����e�@,�
z�Z"��f� �7<,��K:.����]�E3�����O�\���j�mqT.]qF��%�5�.Z�#fX���S>�.��X��KW����B[����+�����9L^,m������.]qG��]�u�hL��d��3o7�^B{��\�+�Y�8W6��az����C�1\�rG��;�_>J~�^�"I=,)�=��>ke������ �2�n�aY����G�^��DQ[�񕑋eF}$\�	�CeLq��ޗs�\-3�M�arXx��).ik����0&�&���aY/�6gl�������c��c��o�qXʎ�v�<A���\�����yZK�1�bh�khY�tG����aRSK�0uJ�N�em�]al ��Ҍ�
.5��Ӑ>T�1V���^�]��ļA��9Zz�1l5 K0w��"�2vYYYs�ôL�?�X��/c1�-]�3l�?mZM�0���ޏ�wx�βaf����?�ϸ�掔��渣�\����h��&����I�<0e�)\�����?Z����5�g�%P�uWtgB����
���ߒG"
��xJ^]P��z�%|�X2Mܛ�y(B���Y�S�pS�G�g
7���Jn�N¤�����D�D1��V]�簄�߭�6�u�l{S���\���H��/]qG
[(ٗ����Ĕn3se2)�&��q�(�ݞ�CO�I�r��G�����Q�+]S���v��]fr��qi�(�.�w�'�v�O�}��Q~ ���fW'80@�o�����e���ii�P�{�.n�)���B��9e��P]y��_�s�J��B���tIᥞ5�P�^_ڔ�Ϡj6p��S��!��n5J!��z��t��ڛ�#�ԋt�j3�G(�?,hɂ�~ٱc��@+U9KǏ9@O�_�T�� ��D�OP=3��b��R~U*&5A/���:�K�z�TkYw�v>k/~�/r�փ�v�_:�6�E�u���cm%>�6�Y{觔M�� ��Im�#D�+�F>k��2�����s:u�)�'#b����.��)SٽYuʂ�DO�]�E�ePj����51�Y�������8�� /�=��'��o�����-�<�x�4@���J}��xou�]����"
 ٿ���Uo�sZ���5o]V=�4l%�D:S����05-�D��(�7ߥ��L�:���)���(㴳d;���.�A#���D#�w������洫�X�R��V��4���qI|��D�c��ͪ� /Ɇ6�1�4���y21�4(c9 �rӎ�9�����yOr9�ϐa�΍���#��9�?F.��_M6�؎�9��C���ʫ̢��}���-�S���#p[��h�oY?�9�W��n٠e��h�1��Q O!FB�^|ra����A�9`}D�bDaP�E%7�+���F@�M�'��Z��� ���7�{R�M}�YQ�3�g�Z���1i��u�p�ސ'#J�f��J��*;�-�U+����<a���{l�׃�b,�El��?�tI������\Xs���G�o`U��k�$�>��(i?ID�Z<%�E��e�;.��?�� >Qlv6��i;%�����&�fc_B��a��X�?8��Pi1��?j���C[_R����U�֯�%!��<c̆nͷ(@.����ل�[	�/2o�0Lc���\X[�1}������|�X��ؖ8�A�~�1�P�\��-���E��R�p��+5��3N�Iw�M3��Y�q7�ri�3e�
�O�̹��P�sC?����R�P�n�IQG��:�c��7����Qr󷍍��rlz�x��!w����S��E�j�����fvw�e�#��|�`�̐��w�!o�;c����H��vvX���0���T�HG�G��i�C���gL��2�$y;6�1l� -�$���1�$����o�Q��԰�cs9����mYSB�ѯ����\Z3�P`����"C�n'j55R���f x�^�7Ѧ��3��&�C�P�KE��R�m|�d�X�s�������"�p]$U�
br���c���km�5��062�,�&߽}�o����zg�/�|��мD������3m|����P�i	(y
c;:�̄��vU��w�¯�[s�������Z�;_��&��Sh�*E�.�Ռ0���< �{���Z�;frY͈b
�i��<�-6S����A.�y��(��߼���E���%q��o0)/�h���%]�oG�Mہ�X!�'���0����.����;b�e[d�P'�a�x��:�.	� ��f������e�9�����/C�\Y3���<%�KuS#�~�߽�a�~ӅEN/.	���U�%���	���f��~�2\pG��Ak�r��Z��Z��t��pI�)�de�����o���?}W��e}/�3��c'!W����I1�Zf��\\3���M�ݫ���&�7����u���ސL�^!�?�r�� M~5��= ������LZ��{��������w
;L�����625S�]1�����2�4F2�0�al����c�ñ��#E=l�V��0y�-�T�E�_��j�!���V[��.h�vy%���R
:���=SP�$����)�6��Ԛ5ɺ��Qޚ;����6�v^���l����~M�0`âM�s��&?}�4�ͤ˓����ڭ�t%X��Ҽ)PԪs���oD�����}�f�s�c(��/ٷ��H��/ٷ�"z�8u������ӥ�w4������s��)�!��0~A��ߢ����K�-�XǇ/s�\QG�1b�i���0a.�Q �b'�X~�cƆ��(=7I}��1��`����׌'�ZK�Z��<�=��ޔ1�j��ҌP��z������b�y��(��;^�u]��|8Rtc+���gw�l|�a&���j����F��4qЎy��ڽe���f�ᙬ����c̞yq+}}�� >b��^�$��ĳ�r�{���W�}̛�"L    g^�U�VN����ܛz��h�����W���^r;��n��:G~o���}�''Î�\@�˩��)/���U��+� v3m1��;S,�Z�h�yR��ߙ�h�9r�C�D�;\�4�.�8�u��ɗ���A޿w�足��ˆI�`ڎ�3;���&��� cE3>�9wy�I�3̟Ի���|��na�6p1"�%�u~L]�Ic.�QX]o���vs�f���2��X�s�"��;5x�@\�� ��c�0v�h��fxɽh���� ��y�����\�{0Ҧ�����L�� }Ӄӹ^��ۑ�^��N�s���d��mD�2�/-pG
X��|0� DDQ+�����ط̻S�w �]Ro�7��J)�����$� ����~�pȋ��wl/�oG�^�4ؕ��l~���C6"��/lF��-�lř��
�ս���
��-��uͳ��Ծ��tG�Oހ��[w�gVA�ඞ��&9)� ���p��I%�~u����,)&����K���Oz������l��b�s6F��ם����W�9�����l����{�(�������#�L��%��weq�8w݀7L{�(���9w����Vՙ��1ݾ��e,���pƐ��x��'����K�ZE/�����eHG�#���p?h� u]�K�[@�S�δ�uf��'�5<X�� -K��N�&}*E�hf��9����_(vQ6{����'���t�Nu���7�n��P� �v�ud[�X�����e�1X�yW�.�7;f�gM��K�[@a����;�=!���"]�ߎ0�R�e��2�1W����`0��0����)�|'�G��g1�v��8X��Ǥb���E��>�y9��y�|��.
��f�;.�ti�0"exE
�(h��a���j�5�]|� ��g���vHe��&z�T��M� #���$�=M��#ƴ��"�J5��i�0[��ՅZ�Mn1���������>�N����I���
4AwG�%��Fa�k�:��<���(��;��)��~f@Qk\H��[�MQ��ʔ��P���_� ��U5ӥn5a�"�tF�4�[��_����B�oyb�)s<n���钇(���0�Kn5`ߔa�Z�$��h\�]�#��bsR�rUh�F�w{�"4|s�I���`��Tk}'WVG=�!�~0|�m��x��5C�(lZ�Ot1�ϔ>�,�E��q����� ���%�4�75tq[��kD1yu'*J#���e��.��~F)Ť��2ʃ�Iv�T9ȯK~��~FY~�,&8�Iwi|(�0�!4t�{��`�aC&?@�.mo
.w��;�#
[��$a���\��Ռ-3��x0&:��d�מ�����K�C�V÷b�c���H!S���@���;vL����۽����=c��� N�;$�1}^�z���8tI�1�*Uz_0y�p��l�.l�U>�K�-�4��/��~#�0���n^��.�� �&�d a:M)���.�yiN��u�7�xb�*JH��#����Ɇ~����!ż�>�X����M�#Ʋ�L}�7�H�挱i�(�(W�
0ݦf���s_b��W3z*~�I�����״t��"��&o�0�~��[..Y� Ce�����l�_;C�vF�;����I�ջ����u���.�T`Țd|��`0��~Ǣ�I�6� ������d)�셟12�-O�;�����0n����A�#�^P�z��e�1X���q���]�3���+��KB.����J�ج�nͿDNC�.鸀ҥ0���%G����ǯ6P�r��a�.�mNs�L���l�2�o�)7���$pkg�">�O��(V��7�g�[#�*Cmf[)K��"Cy�̑m�=���"
�U�6�u���0��o{����.�pe�%8W�qjĊQ"��K��[҃���H��к��gT���(�֩�ߟA����*�l=s�MD*�Gh�c�ZyK���~ m���,긨��~�*֔�m�@p�焼���ςSC���8�&?�����VL�;���ҕ�~_Z����7��Bo�&_Z�N�n��xK���.�<�pډi��S�D�f1_z쎘��+Ʒg��.�t}(�K~�O��>��@�;_�̗�^�ѣ�hy��u`d�g��h�ǋM̘�X�2�C]��3�-5��^�Pg�uH�ɍ?덙ʇm��&�.�����w�E��O*{c�K�u}���e�����N�AS"��.9ny�󑂯����m����ϔ:[D>�}�3�Zz�%j���#�ǃM�E��%�F\����`�,A-���󏱡�=!��J�%�w�X����)锱�B�]��&d^��7)�=!O�Gpϭ� �޶�@��ĺ>B��a���ߒ;�'���s��[�܊(Sh¿$z�D&���x������&���G6���7eL]ud_�������Ç�M'[�3C�ۜKG��Bf��lD�һ��� C�>��S�2>�
C�S[M�+�������H�?�n���8?��r��1������|�Ҝ1z?�b]�-7LOo�嚽�[1vAz!6ǢC�0�<#�P�������ռ����[>#P���ɐ��
��o�W�E_-����C�7�O�xh�����Ū���7�P���|:L@a��emB;�-BZ��s��A3��Dl�2�#)�a���j�,g8^�3�2}��9����3E�&���������T�h�2��*e��T��Q�C��[�A�����9*��h�R���\#cz�F=m� �<�����m�����7�"pP*�p�:�_�\oT�F�������=R�Qa�3^j��R�-¨��_�Z��Z	�ä%nT���)���b�s��L-��*-�]bh�al���9?��/�vGJ{ټ7��#樌��,C��2y�]�1�`9�.�vk�a��XCY��r
�)��I[����óN͡%��K\FQ��.�4|Fw����"K��gZ9�b}�tS�3��&y�1��0��%��r����	��^}~^��\�2°��˕ ��zFX)¼-�Np�o|I�D��m����o��@���)&���o�\�2� ��	�,y���g�)(ֺ�x~��=;SH��zrV����N�q�d�\��Sp�P�����}���P+�zDoӿGw�!܈]�UJ> 1��=ۖ�aE�l����髯��o�icfD&/p�4kj�������E�2� 2��R.ѳ3E��.�����3APw�k��|�\D!��N�i��L�웾]O����Q�"�<::mU��s�D���T��PƓh�7��ꇄJ�~�7���B���=S`8�O;l2�֍ҧ�R�Ih���`�v����Sݏ�γ���J�v�0PEVL�v����-�ź:&M�E5��IK%w/ی�)��Ki�u����=�Έ���t��R67����M$�;S�S���K������"��\�K�[D1CW���"
�t������~jv�ʲB���G�EӀv�J��e��Wܝ�=���=�I�Ɨ��ϩ��-"
�t��-i_]DQ�~��=�h�(3�P&�d]�e���ދWP�\�2�XA����<�F6�@���O���i��+,�<6� �pǈ9�m�n)���g@Y�i�ȏ�JF�Y��jci����.�S���d�`G�w̌���g�I��������k��C��N����K�a�70Ř�:�����-#��v���7����I�����ϼ��L�b���ȵ-�Hʤ�w��oI�߈2�pq��k[�q�IQC��Vk.mA:B��䙋��c�q�f?�v\6�cE�iK ߼�l���Wm&߽��Y����u��is������`ڙaԣ]4^���f��Z�ج<�I�鷈b�=ݦ��(�1-�>k�?�K��L�Ҽ�yڢ�ZܩX��a�6�\oG��1�my�|�n'��y!ղ�2���5W.����a���i��[�M��v� ��q�+�ӻ��c���M�"���vh�vŊJ����'U>W.°:(��L(w���LcZ�z?�/֕|��#So� S  %��"�ڊ������`L���,���C;�l2�~���yC�3-ײ�����N_0ᙗ�v��vX<�
��D�=�^�%w�~S�}��^�)_v��b�^��Y�6s�JG�3¹��`��vER[s��/I�#�|&^�lVh�LgL-s
�ä5��p��,�k>#��E��52-(��;���4�(]�3��Z���w���o@�|�ܙ�oi4�/�t�N���:��|h�=����Y)�[���=alP��I5ը��Y2L��c.��	c��C��nS�jň���>d&w��z)슚s1q�X�4�K��EJ���gJnȳBƓ(ƄXgV��)7W���=SdN��@��2,{gs����`H�־`�����՗$^^u�u��aj�{�0o)�VY�?T��a,����|���Qz�5y�^Q1��=b��f/~�kZ�a����E��ǆs�MmS��ar#8��~ڲ,qھa�-Ös�İc�J��ݸ�1�`�I�5���M`ƨ�Y�%���4������Q@�$���E��PJ����Ʃz0gk����00J]�S��a��n����v��������g��R.9�3�w�-��»e4纕���)#�D��n�pﺧ�>Ŕ ?�\"h���R>�>���g�x���'T6�䁏�Mi���s�-��&��������q��n�W�P..����s�U�X�'�u8�&�r9{�N�e����u��~8Q�!ro�����k�%/
�vo:�,Q:`n]F����@V��p�r���"ٴ&��p�Xg@���Ch�w�}���J.py�4��,8���Xg������%��e��,�P��e�0��7�{7aj}$W�(;F�J~.�K.��ra�"���ȯ�1�Q7��O���=�1��p�Tr$��=<ڎv�I��{�5�>a�n>��X��� �'V[(�!<�N��؈���;b�E�J�KcI��5���1s��a3P�&��6'���0-���ͦ(K	��k�8�pg�O&���1�=�Kx]�܎0�cP��7��<����Si�=V9'k�ڠ ��;��<S���>F�錍�b5	�d�.#J����rId췮I0�	ב��/��#�t��-K>gnO͘�Ǭ�г���āOK�w$g�^q}��L:��ty(��ϟ)U_X!���y�@K�A��(��H�%7�7���
`��Z�[�XA`����'1
��K��+hFZ�3�ݷ ���$$�W��1cVY3/���{��m%uY���{�0ֺh��%�1�j.�)/�(z4�����e���o&����e-�뒑��w,�X!P7̨�ѻm���C�"
�"�]Iu�ڎ���U����� cz~����3������]��z�S�]�m"��P��c��勒<�`L��,����1c�6��1\�Asg�[���a4��_ðk]0�]|�H^�j>i�`��d��;h��s��'��������S@;�ͮI��ֵ�� c*<�ڤ=��aX�
�G�o�:'�%��#&ZJ��2�|Ui읞Zs38��R�{+��:<f`ůM�G ;f��z�Pzj��]�,M.`p�-y&#�!/˛�����J���TL0B4\-�b�p.7f�BhS4aT��|�\�ы���:�O�|ĀzO˴�Դ�.�T�
������ƹ��<`�Nԧ�k>i��WA˾i�"0a�1dA� ��Q1yOF�1�G	�R>�.�Qx�7�?��0�z��X�cRM�3�-�����ʴ ��C�arka�̉�eq:�%+`!,?&7&w�x��l{��1`Fg�e�sci�̂����[rS"�t�'_�}:䝂L0m��;uG���z]�^^Y��a`�|�'�k.�qF�#Y���,G��X�xy��Tv��M|�g�;���0������N(/��x1@/�9گ�w����~�1�Kn�!�5V��1y^#~��krcb���uw��k���(j��r�.SnJD)�P��kOM��?cH����&	wO�D%֗4%�L`�j�T�ŝ;S���+�V��xSfq���ř;S,?��j>yns���e���o����v7O��#`�TT`��|������H?@��0߻��>� Xi٤O�5�C��u�	�]b���-�+/{�D�z���V���xڴͬa��w�4���~(�|E���D�~(�t��O�i?��ȵ$+%߻�Gi4��f&�;1�b:�)z�VW�V�I�d���s����g~(buo:�4RXd�u��#�⦥����2���P����!�5��t�s����z���P�2rG������y��PȔ�>��%�w�)�͆���zѡ<R�&��M�y-O iX���+�Bh�c�˒��p��͔Ro���%wd���n2lJ���(� ܡk�p�L��5�;�����Y9��y�7���hW�Q%���"Sf���[��R��?�)@$�^�tLxA��t���oA�)�؋)�v�咀;R�
��%؀�)`��4��\�g�(Ժ_�K��vʘծ��$Ƈr	6�)�;��/��)`����GS�%�v�k)E秵K��N�i/��È�x($�k+������#�ٗ	����7L3��^�W��vi�;bf���.�o�C�1�ɍ�UJ��~:X0�_�_��ln%��G��� �3�U�>�Ӱ�i��[��2�C��_����r�b�q��P����6��c.����M<����p�	S_e�b��l�&�~z��w��?�ڥ.�4��w�_�����Lm���i?�{�����C�����]>p���g�}�\�S��*�Q\С]�������Fi-/E(z|���e�6tD�/���]��)8��B͹��w���Xy�eI�L"�H�� yƍ�k��HYzAۥ	��Wű��~ٻgL��,��+�~m������(�1��<�U���-�{�
X�U�"����@-]�pB��Ϡ��+�/�OG�9�ڞ��s$��?y��֘�b$�����3��C�	���>C��⊙��>3��?~��$|�}��bzKz5b����J����gjg0��#��^��������      �   @   x�3�v�twt��sWv
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
νg[��;���ދ=n�;�5��ˑŨj��y��]���.�>/������x���=O�YZ���fi�ϋ�7���d���>/�>�����Eמ������՞�g(���'>��Q��3r��?�,mH�yƱb��-<��f�C+�Yڰ�7�4<�B{��a�6�y���k����,m��"�ǎ͝G^1|� �GR      �      x������ � �      �      x������ � �      �      x�ŝ˒�6�Eו_�?�ep�;���X�i��Lӛ�,���߆d��xd&��K�T�*Ƞ_8��a���Р�#���t)˥�����Ə���U�џ�cy������������������w���/�G�nZ�c��/��.i��PL���!����������'���r28�/��S�r*8�/G�/�� ��b�͟>)@���A���C�>Ad�*��,�Yx]�=��
� {���A�(� �2�exeЍ2�^A��H�{���S�A�3ʠ�3ʠ�eP��2h�� �2h��2h��0�:�`��1X��&��[��;P<܃�O��`G1v���u���w��b����;��33l�}A���{�p�'�x4��Q����|�ae�<*��^�f�lH�.u�<��x��~��Ze�}���1����t�-�vEB;�BF���[%a:����ji�O���{����o�+�z<�pς�<^�ŇP���:�o��\���ȱ�\�h\R4^6���$ō 6�>������lH����� 8�:��XX���%�iKa����w�ｙ'�C|����&|� �����>}tp����#���5X���}t	��	r���wA�<uA�<wA��t�`}��� Jк�G�^�����WWp�Bd�r[.�\,�,&�������E.����2_\ٶ��l���E��\�a�݊=����'���7������:�����Ν���?�[���_�����2�+7��?N�|����7+���k��G8F�pL��͗���`',|p?� O'�3��[u/���U9
^߳�r����w��G\JڸT]��T8Ī��U����h�W48N�8��s��P�6�E�C��x�kcd$��=�={��l�f���$�.@�q$�AW�����vOe����E{�X8�؈:��6g��Fl��"!����	脻ޮOd}å��-�Z6��.7��>hl;ֲ�.�ڵ��kl��R��t��W��@G;�BG'����@G:� mt4$�:�m�Z5�������1i�#�Y�1��Ho~4<қe]Љ��3�,�$|`O�r�	g�Y��p����p�M�p���BC͚�j�$�rЂz���%@��� ������?�<I'���w����c�fs�G��f{�G���lp0����Z6�X�ž\�#�w���0��K�v
���_� ��?v����
j�Q��.q비uJy���e�[���
��^q絹s����NpE͉^��8�>~���<)��$���\c}����NI�j�s���܅��ϒvC�K��V�n��wC`5�R/DĪ/��V��*��T�!��K�"�A5uL>!8����K"�"9����p��z<���'=�����]qE�_E(�b�X���tC8�����0=�n��z7LOS'DA�mi�$̂��"-;�+;vs�����H|-��F.1>��m`��F���e�Q�F�Yl��am�m\�Įе�l�Z�&�W�ZU>�V#�]k��,6t�:�]��φ�m��6t�>�V+�-xѥ~�A��KVZ�ܨ�^w/�w�D��&:������Q��A��O�#.R+�eC��6)�<8v��v�6��n�Ŋ��	p�N�;�~<�N�g��	�x��Ӳ!k���&G��w�S���]���I�b�Gm�ﺇ �B%U�T�VeR�AZ#��=ӫ�ԟ�h/�AO0�
x�Ñ����9�
�Vq�H[R����%� Ǵ-vӶ�	pLےN�cږ|Ӷ���|8r�T�	p(\S&z�Lr����5��<8������pMv?�k��yp(\��σC��
�f���P�6ϟG/fm3�ip�Ll��\9E�f��8D&�	p�L����N�Cdb>���8D&V>����	p��mE&��n!ZE�V�x"cv"c~"c�8D��	p��>U��8�K�I��z�k�3E[u=��x"�v"�~"��8D��	p�����d���)!=���!e&d���V���n����">܁;�+�:��:⮅}��7E�h�޴	�$4��W&�a����t��a\%�тD+Y�b�H-i
ϧ�5�@�
h��:����]�d����5T�X)�����&S��[�/�/;�E�� ځ�tt�������DGW�3�B�m�o�]+Ё��@��#���F"y=�*�����@Gに���pU:��������Hhh�:�DGC�5��Huq-t4Ԭ	����|a�e��\�iD��ߜ����#�k<
!�JGCHc��!���hit:B!���FF��BGCRl�iSǠ���Y�$4����A���ٞ2�c�P3�S}j֞KBC�lO�!h$���)>�jO/�am�����ѐt4�=���]��Ѱk�t4�=����]��ъ=vs6�z��F���l
a���)h��nΦ`��9���F���l
a���)h��jf�њ�j!�#���=�2�]��î@Ǡ1_K��1_��ј�E�h���h��bt4�kq:�
��h�*Hf���ﶧ	�1��'�[����F#�ٽ����]s���vۊG*�'����I�hhx�t44<ONGCRR��!))��H�T�hx�M���:5�{V=5�{V=5�{N�;��{Έ;��{Έ;��{L>��J�{L>��[����ԁcа��h�u:v]����R"/�5+NGC�J���f%��h��M;m	Kv|\.;�!)5�ѐ�f+����T��!)5�ѐ���0	I�NGCRj��!)5��؊�Z�h�Yݨ��h�^�,�@GG���6���v�#��6::�tt:���LF�]R(t� �U�Ϗ�<5�@GC�D�h��(5�HGC���h���98������Ѱ�m�Ӱ,�.��а�m�S
v�BGîU�hصF:vݶ6��#�x�� m�H�����^��b@Ϙ���S����m�L�q(�:�w��������F��-i��!�q�7:\ѽ"�ڮ����F��!�1���ht4�+f6UN):�R�8K_4e?��=���Aîm�yǠa׶紋cаk�s��1hصW���sq���9��4����qqV�)��)�rAϗ�Аt4$Ņ�����ѐ�t4$�)�b�!)�t4$�I��F�q�Ȋ�nhHJ
t4$%	IIJGCRR��!)��hHJr:��II��F�pJ����]��Բ2�����j�5�BGCͲ��P��h�Y6:j���F�pʅ��]�Ʈu9�ږ�Nh�u	t4��.JGîKd���7�BG�5��3I־�ҩ�ƐS����xͪ��x�j��1}Tc�����?Û��mn^��~-���^�}rTkf�wI�����Y���@�@*���!qF�G#�qN�2!��k3��.㣐��xK�=	q|胗�vOu+i���E����/*���4���@�T���OcC�@Ξ��o��k�8}9�ߩ:]���DF;�kܜcֆ��6���O�8�}��Sk�[��k�����:-���l|<W	���~o�l�8��d�����)�5�u�Dֶ�"	����@��V::�����hg��Z�(��M��k������1h��:j���$��f�h�Y�ߒ������P3�t4�̍�������_�Jv=��r�	Ii{(�А�&��BCR��M$4$�m�DBCR��M$4$�m�DBCR��M$4$�m��A#����Hh�YڪYYѽ|3$�T�h�Y�t4�,:j�����e���f9��P�lt4�,;�=�5�5S������1hHJ�t4$�:�R������!)%�ъ���^
��rR�Z���A���
����M/N�]�P�K
�2ik���
���S�?���G��x��#�
]6'�:B����$6��m�섎@�.F�n��ۈR���A�Ƞ�QG�����$�D��LFOg�.��F�L���|
k� �	  +��ӽ�J��3w������l'���H��7yX����fh7��}g�j���
�w�WyY�I�E;���#��� �H�����<̖�mJ��я�xY�������?�V�L�Etz�崄��41����^�ҬlD�n�vCD����(��vC\�'vCd �� �K,X�m��]��¥2�WK�uDl���^䯦��%�:"j7�bz�C7�!��vC$ b7Dº!
������iۺo]rI�%��K7����<�N���.5�J��[��e�v�\����G�Wh���N[(�
m���zI����,�A+˃�X�HM���]�����-������j��*��=n�s�QOY��c8S��>�а��4c��y%���2:��T�,������G�EFڑ =a]h^���яR����'����J������� �\�8沘N���b��='�x��ӈVܗ�np�y[@���-� ���� ����48켍����t��4x�� �µ,8\GiKhp(���ph$%~�¡���	
�fR�'(�I���ph(%~�¡���	
��R�'(�J���ph,%���Ɵ�M@����Iz
��	p(\����N�CdR>�I�8D&U>]�$�����Z~~��Qp�L�s��Qp�L�s��Qp�L����N�Cd�F��Cd򞓌��Cdr��#Z��g$�+33��D�/����G�ƙ�n?�m���w������޽�����o�nBڬ�8qM���v�3ؙ�.`>�|�t6\������,�m�����F�B[+�bC[���Ж��lhK�|6�%:�P���@�t����QY۫��M�`���)�l"�L޶�Ŗ�	[.��Ƞiz)>��mx��4�ɽ�0��ʣ�R�2_��0�
���c��A�L��jL���Lj51�ԭ6ՕZ[j���,�-���[�jaR+��Hh�&�$¤B�D�Th�D&�$ƤB�ęTh�$&�$m��^���ap4�(���pU�u��p�NR�\�T*U��˅F�p�P)U.:��˅R�q��*u.j��9��Õ��8�T��*�~W�Ts����9拖i��W[�7/(ӒMk]���=Z@�Ts>�����K�⥾)R����i��i��a��_��O5�g�xi6D��uL�e�̀d�)��XC��Η�Vkf��˥sm��`*�J��R�%��X��K��j:�~-�
�J�'�H��k�xa�b'��X�8b�%� Gd�99��,,5� ����	�RIA�'��7��Si�o��9d�����k^¦p��,�^`8����{St$�(L�!Ѝ´�(,vC�ES�s4�(�;!<�ҮA(���������B������y$8���
��N���}	l�l��4B3�tC�N�vC�s솀�e놀}e��ax��e��+y�Q�b�`ިvIy0oT�p<v?�pe�;{̺z̺q��{����5̲���~��\!R���S��hʤ���E&�͘T4_4gRя���3I�l��m���}��	���_]V����q ((e�@|�>�_H|� ���O6��@�b������'QCZ��_�&֐�j�q$����qj��ӛ�ưmè�����D0��-�i��b�^�����01�X�G}t����}Jůo�HuLi�T�`.L*&RW&�G&S�;��)��
���9u;��`2�����`&	�n:��7=�/��l���}+�iw�|��ۇ\yaR!W^���J�I�\%aR!WI�T�U�L*L8�
�LΤB$S�Q�1����������� ���4{<��9�"�{�bj��ok`���
���M�k��5��Hr�#��<��?���Ǳ�͋!O�Ǆ��Jcb�{m�@`B³�0���1,�/�LW�ͣ�r�l��y1��k�r�	i-�0 �m�ї��,7�:�G��@3�4e�M�ax����<�3�w#����?��a��YV�~�Y���~���E}�_��;OC�䮇9��S|�O�yL%���Cx2��?�8��R��e�[y=�@��,�C)���(����!W����R�nĕj�@\�Z7����p#k���1ls鷒���^������݃p��R݃��ۺ܃p��"܃��ۊ�cW�<l7�Â8�.P_lۮ
�w�1?W�?�Nwa'-Ȟ�_��88G7���]��꾅�����f�!�i���4��������ʸ\�m�!��M���g�:8��M��A��6����g$ܜaW˕^����H�NF�Xd�bY^��GlH�)���?�z�`	^�Ǆq�13܋��3�5�Lk�����NL߻�W����pAr��0���ҭ?�	�pSr��0|n�8�-�_��i��"ҵZ�;Ø��a�i�E�|gS��n�����^��������a�����/cz7
�Œ�5�2u�ݓPF�������^ny�     