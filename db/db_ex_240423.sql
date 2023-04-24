PGDMP     8                    {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �   &           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            '           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            (           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            )           1262    17913    ex_template    DATABASE     s   CREATE DATABASE ex_template WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE ex_template;
                postgres    false                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            *           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    6            �            1259    17914    branch    TABLE     i  CREATE TABLE public.branch (
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
       public         heap    postgres    false    6            �            1259    17922    branch_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branch_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.branch_id_seq;
       public          postgres    false    202    6            +           0    0    branch_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.branch_id_seq OWNED BY public.branch.id;
          public          postgres    false    203            �            1259    17924    branch_room    TABLE     �   CREATE TABLE public.branch_room (
    id integer NOT NULL,
    branch_id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);
    DROP TABLE public.branch_room;
       public         heap    postgres    false    6            �            1259    17931    branch_room_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branch_room_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.branch_room_id_seq;
       public          postgres    false    204    6            ,           0    0    branch_room_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.branch_room_id_seq OWNED BY public.branch_room.id;
          public          postgres    false    205            %           1259    18720    branch_shift    TABLE       CREATE TABLE public.branch_shift (
    id smallint NOT NULL,
    branch_id integer NOT NULL,
    shift_id integer NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
     DROP TABLE public.branch_shift;
       public         heap    postgres    false    6            $           1259    18718    branch_shift_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branch_shift_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.branch_shift_id_seq;
       public          postgres    false    6    293            -           0    0    branch_shift_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.branch_shift_id_seq OWNED BY public.branch_shift.id;
          public          postgres    false    292            1           1259    26919    calendar    TABLE       CREATE TABLE public.calendar (
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
       public         heap    postgres    false    6            0           1259    26917    calendar_id_seq    SEQUENCE     x   CREATE SEQUENCE public.calendar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.calendar_id_seq;
       public          postgres    false    6    305            .           0    0    calendar_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.calendar_id_seq OWNED BY public.calendar.id;
          public          postgres    false    304            �            1259    17933    company    TABLE     r  CREATE TABLE public.company (
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
       public         heap    postgres    false    6            �            1259    17940    company_id_seq    SEQUENCE     �   CREATE SEQUENCE public.company_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.company_id_seq;
       public          postgres    false    6    206            /           0    0    company_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.company_id_seq OWNED BY public.company.id;
          public          postgres    false    207            �            1259    17942 	   customers    TABLE     !  CREATE TABLE public.customers (
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
       public         heap    postgres    false    6            �            1259    17950    customers_id_seq    SEQUENCE     y   CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.customers_id_seq;
       public          postgres    false    6    208            0           0    0    customers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;
          public          postgres    false    209            /           1259    18774    customers_registration    TABLE     �  CREATE TABLE public.customers_registration (
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
       public         heap    postgres    false    6            .           1259    18772    customers_registration_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customers_registration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.customers_registration_id_seq;
       public          postgres    false    6    303            1           0    0    customers_registration_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.customers_registration_id_seq OWNED BY public.customers_registration.id;
          public          postgres    false    302            5           1259    28173    customers_segment    TABLE     �   CREATE TABLE public.customers_segment (
    id integer NOT NULL,
    remark character varying,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
 %   DROP TABLE public.customers_segment;
       public         heap    postgres    false    6            4           1259    28171    customers_segment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customers_segment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.customers_segment_id_seq;
       public          postgres    false    6    309            2           0    0    customers_segment_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.customers_segment_id_seq OWNED BY public.customers_segment.id;
          public          postgres    false    308            �            1259    17952    departments    TABLE     �   CREATE TABLE public.departments (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    active smallint DEFAULT 1 NOT NULL
);
    DROP TABLE public.departments;
       public         heap    postgres    false    6            �            1259    17960    department_id_seq    SEQUENCE     �   CREATE SEQUENCE public.department_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.department_id_seq;
       public          postgres    false    6    210            3           0    0    department_id_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.department_id_seq OWNED BY public.departments.id;
          public          postgres    false    211            �            1259    17962    failed_jobs    TABLE     &  CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
    DROP TABLE public.failed_jobs;
       public         heap    postgres    false    6            �            1259    17969    failed_jobs_id_seq    SEQUENCE     {   CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.failed_jobs_id_seq;
       public          postgres    false    6    212            4           0    0    failed_jobs_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;
          public          postgres    false    213            �            1259    17971    invoice_detail    TABLE     �  CREATE TABLE public.invoice_detail (
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
       public         heap    postgres    false    6            >           1259    34018    invoice_detail_log    TABLE     �  CREATE TABLE public.invoice_detail_log (
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
       public         heap    postgres    false    6            ;           1259    33377    invoice_log    TABLE     �  CREATE TABLE public.invoice_log (
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
       public         heap    postgres    false    6            �            1259    17984    invoice_master    TABLE     _  CREATE TABLE public.invoice_master (
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
       public         heap    postgres    false    6            �            1259    18001    invoice_master_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.invoice_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.invoice_master_id_seq;
       public          postgres    false    215    6            5           0    0    invoice_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.invoice_master_id_seq OWNED BY public.invoice_master.id;
          public          postgres    false    216            �            1259    18003 	   job_title    TABLE     �   CREATE TABLE public.job_title (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    active smallint DEFAULT 1 NOT NULL
);
    DROP TABLE public.job_title;
       public         heap    postgres    false    6            �            1259    18011    job_title_id_seq    SEQUENCE     �   CREATE SEQUENCE public.job_title_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.job_title_id_seq;
       public          postgres    false    6    217            6           0    0    job_title_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.job_title_id_seq OWNED BY public.job_title.id;
          public          postgres    false    218            '           1259    18727    login_session    TABLE       CREATE TABLE public.login_session (
    id bigint NOT NULL,
    session character varying(50) NOT NULL,
    sellercode character varying(20) NOT NULL,
    description character varying(100) NOT NULL,
    created_date timestamp without time zone DEFAULT now() NOT NULL
);
 !   DROP TABLE public.login_session;
       public         heap    postgres    false    6            �            1259    18013 
   migrations    TABLE     �   CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);
    DROP TABLE public.migrations;
       public         heap    postgres    false    6            �            1259    18016    migrations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.migrations_id_seq;
       public          postgres    false    6    219            7           0    0    migrations_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;
          public          postgres    false    220            �            1259    18018    model_has_permissions    TABLE     �   CREATE TABLE public.model_has_permissions (
    permission_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);
 )   DROP TABLE public.model_has_permissions;
       public         heap    postgres    false    6            �            1259    18021    model_has_roles    TABLE     �   CREATE TABLE public.model_has_roles (
    role_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);
 #   DROP TABLE public.model_has_roles;
       public         heap    postgres    false    6            �            1259    18024    order_detail    TABLE     �  CREATE TABLE public.order_detail (
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
       public         heap    postgres    false    6            �            1259    18036    order_master    TABLE     Q  CREATE TABLE public.order_master (
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
       public         heap    postgres    false    6            �            1259    18053    order_master_id_seq    SEQUENCE     |   CREATE SEQUENCE public.order_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.order_master_id_seq;
       public          postgres    false    6    224            8           0    0    order_master_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.order_master_id_seq OWNED BY public.order_master.id;
          public          postgres    false    225            �            1259    18055    password_resets    TABLE     �   CREATE TABLE public.password_resets (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);
 #   DROP TABLE public.password_resets;
       public         heap    postgres    false    6            �            1259    18061    period    TABLE     �   CREATE TABLE public.period (
    period_no integer NOT NULL,
    remark character varying NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL
);
    DROP TABLE public.period;
       public         heap    postgres    false    6            �            1259    18067    period_price_sell    TABLE     X  CREATE TABLE public.period_price_sell (
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
       public         heap    postgres    false    6            �            1259    18071    period_price_sell_id_seq    SEQUENCE     �   CREATE SEQUENCE public.period_price_sell_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.period_price_sell_id_seq;
       public          postgres    false    6    228            9           0    0    period_price_sell_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.period_price_sell_id_seq OWNED BY public.period_price_sell.id;
          public          postgres    false    229            �            1259    18073    period_stock    TABLE     �  CREATE TABLE public.period_stock (
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
       public         heap    postgres    false    6            �            1259    18083    permissions    TABLE     K  CREATE TABLE public.permissions (
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
       public         heap    postgres    false    6            �            1259    18089    permissions_id_seq    SEQUENCE     {   CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.permissions_id_seq;
       public          postgres    false    6    231            :           0    0    permissions_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;
          public          postgres    false    232            �            1259    18091    personal_access_tokens    TABLE     �  CREATE TABLE public.personal_access_tokens (
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
       public         heap    postgres    false    6            �            1259    18097    personal_access_tokens_id_seq    SEQUENCE     �   CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.personal_access_tokens_id_seq;
       public          postgres    false    6    233            ;           0    0    personal_access_tokens_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;
          public          postgres    false    234            8           1259    30744 
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
       public         heap    postgres    false    6            :           1259    30759    petty_cash_detail    TABLE     �  CREATE TABLE public.petty_cash_detail (
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
       public         heap    postgres    false    6            9           1259    30757    petty_cash_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.petty_cash_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.petty_cash_detail_id_seq;
       public          postgres    false    6    314            <           0    0    petty_cash_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.petty_cash_detail_id_seq OWNED BY public.petty_cash_detail.id;
          public          postgres    false    313            7           1259    30742    petty_cash_id_seq    SEQUENCE     z   CREATE SEQUENCE public.petty_cash_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.petty_cash_id_seq;
       public          postgres    false    6    312            =           0    0    petty_cash_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.petty_cash_id_seq OWNED BY public.petty_cash.id;
          public          postgres    false    311            �            1259    18099    point_conversion    TABLE        CREATE TABLE public.point_conversion (
    point_qty integer DEFAULT 0 NOT NULL,
    point_value integer DEFAULT 0 NOT NULL
);
 $   DROP TABLE public.point_conversion;
       public         heap    postgres    false    6            �            1259    18104    posts    TABLE     $  CREATE TABLE public.posts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    title character varying(70) NOT NULL,
    description character varying(320) NOT NULL,
    body text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.posts;
       public         heap    postgres    false    6            �            1259    18110    posts_id_seq    SEQUENCE     u   CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.posts_id_seq;
       public          postgres    false    236    6            >           0    0    posts_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;
          public          postgres    false    237            �            1259    18112    price_adjustment    TABLE     k  CREATE TABLE public.price_adjustment (
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
       public         heap    postgres    false    6            �            1259    18117    price_adjustment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.price_adjustment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.price_adjustment_id_seq;
       public          postgres    false    6    238            ?           0    0    price_adjustment_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.price_adjustment_id_seq OWNED BY public.price_adjustment.id;
          public          postgres    false    239            �            1259    18119    product_brand    TABLE     �   CREATE TABLE public.product_brand (
    id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);
 !   DROP TABLE public.product_brand;
       public         heap    postgres    false    6            �            1259    18127    product_brand_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_brand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.product_brand_id_seq;
       public          postgres    false    6    240            @           0    0    product_brand_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.product_brand_id_seq OWNED BY public.product_brand.id;
          public          postgres    false    241            �            1259    18129    product_category    TABLE        CREATE TABLE public.product_category (
    id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);
 $   DROP TABLE public.product_category;
       public         heap    postgres    false    6            �            1259    18137    product_category_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.product_category_id_seq;
       public          postgres    false    242    6            A           0    0    product_category_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;
          public          postgres    false    243            �            1259    18139    product_commision_by_year    TABLE     O  CREATE TABLE public.product_commision_by_year (
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
       public         heap    postgres    false    6            �            1259    18143    product_commisions    TABLE     _  CREATE TABLE public.product_commisions (
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
       public         heap    postgres    false    6            �            1259    18149    product_distribution    TABLE       CREATE TABLE public.product_distribution (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    active smallint DEFAULT 1 NOT NULL
);
 (   DROP TABLE public.product_distribution;
       public         heap    postgres    false    6            �            1259    18154    product_ingredients    TABLE     H  CREATE TABLE public.product_ingredients (
    product_id integer NOT NULL,
    product_id_material integer NOT NULL,
    uom_id integer NOT NULL,
    qty integer DEFAULT 1 NOT NULL,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
 '   DROP TABLE public.product_ingredients;
       public         heap    postgres    false    6            �            1259    18159    product_point    TABLE     �   CREATE TABLE public.product_point (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    point integer DEFAULT 0 NOT NULL,
    created_by integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
 !   DROP TABLE public.product_point;
       public         heap    postgres    false    6            �            1259    18163    product_price    TABLE     -  CREATE TABLE public.product_price (
    product_id integer NOT NULL,
    price numeric(18,0) DEFAULT 0 NOT NULL,
    branch_id integer NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);
 !   DROP TABLE public.product_price;
       public         heap    postgres    false    6            6           1259    30122    product_price_level    TABLE     �  CREATE TABLE public.product_price_level (
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
       public         heap    postgres    false    6            �            1259    18167    product_sku    TABLE     f  CREATE TABLE public.product_sku (
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
       public         heap    postgres    false    6            B           0    0    COLUMN product_sku.type_id    COMMENT     G   COMMENT ON COLUMN public.product_sku.type_id IS '''Product/Service''';
          public          postgres    false    250            �            1259    18176    product_sku_id_seq    SEQUENCE     {   CREATE SEQUENCE public.product_sku_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.product_sku_id_seq;
       public          postgres    false    250    6            C           0    0    product_sku_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.product_sku_id_seq OWNED BY public.product_sku.id;
          public          postgres    false    251            �            1259    18178    product_stock    TABLE       CREATE TABLE public.product_stock (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer
);
 !   DROP TABLE public.product_stock;
       public         heap    postgres    false    6            �            1259    18183    product_stock_detail    TABLE     u  CREATE TABLE public.product_stock_detail (
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
       public         heap    postgres    false    6            �            1259    18189    product_stock_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_stock_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.product_stock_detail_id_seq;
       public          postgres    false    6    253            D           0    0    product_stock_detail_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.product_stock_detail_id_seq OWNED BY public.product_stock_detail.id;
          public          postgres    false    254            �            1259    18191    product_type    TABLE     �   CREATE TABLE public.product_type (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    abbr character varying
);
     DROP TABLE public.product_type;
       public         heap    postgres    false    6                        1259    18198    product_type_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_type_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.product_type_id_seq;
       public          postgres    false    6    255            E           0    0    product_type_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.product_type_id_seq OWNED BY public.product_type.id;
          public          postgres    false    256                       1259    18200    product_uom    TABLE     �   CREATE TABLE public.product_uom (
    product_id integer NOT NULL,
    uom_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    create_by integer,
    updated_at timestamp without time zone
);
    DROP TABLE public.product_uom;
       public         heap    postgres    false    6                       1259    18204    uom    TABLE       CREATE TABLE public.uom (
    id integer NOT NULL,
    remark character varying NOT NULL,
    conversion integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);
    DROP TABLE public.uom;
       public         heap    postgres    false    6                       1259    18213    product_uom_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_uom_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.product_uom_id_seq;
       public          postgres    false    6    258            F           0    0    product_uom_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.product_uom_id_seq OWNED BY public.uom.id;
          public          postgres    false    259                       1259    18215    purchase_detail    TABLE     |  CREATE TABLE public.purchase_detail (
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
       public         heap    postgres    false    6                       1259    18230    purchase_master    TABLE     �  CREATE TABLE public.purchase_master (
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
       public         heap    postgres    false    6                       1259    18246    purchase_master_id_seq    SEQUENCE        CREATE SEQUENCE public.purchase_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.purchase_master_id_seq;
       public          postgres    false    6    261            G           0    0    purchase_master_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.purchase_master_id_seq OWNED BY public.purchase_master.id;
          public          postgres    false    262                       1259    18248    receive_detail    TABLE     |  CREATE TABLE public.receive_detail (
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
       public         heap    postgres    false    6                       1259    18262    receive_master    TABLE     �  CREATE TABLE public.receive_master (
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
       public         heap    postgres    false    6            	           1259    18278    receive_master_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.receive_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.receive_master_id_seq;
       public          postgres    false    264    6            H           0    0    receive_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;
          public          postgres    false    265            
           1259    18280    return_sell_detail    TABLE     �  CREATE TABLE public.return_sell_detail (
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
       public         heap    postgres    false    6                       1259    18292    return_sell_master    TABLE       CREATE TABLE public.return_sell_master (
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
       public         heap    postgres    false    6                       1259    18309    return_sell_master_id_seq    SEQUENCE     �   CREATE SEQUENCE public.return_sell_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.return_sell_master_id_seq;
       public          postgres    false    267    6            I           0    0    return_sell_master_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;
          public          postgres    false    268                       1259    18311    role_has_permissions    TABLE     m   CREATE TABLE public.role_has_permissions (
    permission_id bigint NOT NULL,
    role_id bigint NOT NULL
);
 (   DROP TABLE public.role_has_permissions;
       public         heap    postgres    false    6                       1259    18314    roles    TABLE     �   CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.roles;
       public         heap    postgres    false    6                       1259    18320    roles_id_seq    SEQUENCE     u   CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.roles_id_seq;
       public          postgres    false    6    270            J           0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
          public          postgres    false    271            )           1259    18736    sales    TABLE       CREATE TABLE public.sales (
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
       public         heap    postgres    false    6            (           1259    18734    sales_id_seq    SEQUENCE     u   CREATE SEQUENCE public.sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.sales_id_seq;
       public          postgres    false    297    6            K           0    0    sales_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;
          public          postgres    false    296            +           1259    18750 
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
       public         heap    postgres    false    6            -           1259    18762    sales_trip_detail    TABLE     b  CREATE TABLE public.sales_trip_detail (
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
       public         heap    postgres    false    6            ,           1259    18760    sales_trip_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sales_trip_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.sales_trip_detail_id_seq;
       public          postgres    false    301    6            L           0    0    sales_trip_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;
          public          postgres    false    300            *           1259    18748    sales_trip_id_seq    SEQUENCE     z   CREATE SEQUENCE public.sales_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.sales_trip_id_seq;
       public          postgres    false    6    299            M           0    0    sales_trip_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;
          public          postgres    false    298            3           1259    27180    sales_visit    TABLE       CREATE TABLE public.sales_visit (
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
       public         heap    postgres    false    6            2           1259    27178    sales_visit_id_seq    SEQUENCE     {   CREATE SEQUENCE public.sales_visit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.sales_visit_id_seq;
       public          postgres    false    307    6            N           0    0    sales_visit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;
          public          postgres    false    306                       1259    18322    setting_document_counter    TABLE     �  CREATE TABLE public.setting_document_counter (
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
       public         heap    postgres    false    6            O           0    0 &   COLUMN setting_document_counter.period    COMMENT     U   COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';
          public          postgres    false    272                       1259    18330    setting_document_counter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.setting_document_counter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.setting_document_counter_id_seq;
       public          postgres    false    6    272            P           0    0    setting_document_counter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;
          public          postgres    false    273                       1259    18332    settings    TABLE     	  CREATE TABLE public.settings (
    transaction_date date DEFAULT now() NOT NULL,
    period_no integer NOT NULL,
    company_name character varying NOT NULL,
    app_name character varying NOT NULL,
    version character varying,
    icon_file character varying
);
    DROP TABLE public.settings;
       public         heap    postgres    false    6                       1259    18339    shift    TABLE     �  CREATE TABLE public.shift (
    id integer NOT NULL,
    remark character varying,
    time_start time without time zone DEFAULT '08:00:00'::time without time zone NOT NULL,
    time_end time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    created_by integer,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.shift;
       public         heap    postgres    false    6                       1259    18348    shift_counter    TABLE     $  CREATE TABLE public.shift_counter (
    users_id integer NOT NULL,
    queue_no smallint NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    branch_id integer NOT NULL
);
 !   DROP TABLE public.shift_counter;
       public         heap    postgres    false    6                       1259    18352    shift_id_seq    SEQUENCE     �   CREATE SEQUENCE public.shift_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.shift_id_seq;
       public          postgres    false    275    6            Q           0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
          public          postgres    false    277            =           1259    33393 	   stock_log    TABLE     �   CREATE TABLE public.stock_log (
    id bigint NOT NULL,
    product_id integer,
    qty integer,
    branch_id integer,
    doc_no character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    remarks character varying
);
    DROP TABLE public.stock_log;
       public         heap    postgres    false    6            <           1259    33391    stock_log_id_seq    SEQUENCE     y   CREATE SEQUENCE public.stock_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.stock_log_id_seq;
       public          postgres    false    317    6            R           0    0    stock_log_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.stock_log_id_seq OWNED BY public.stock_log.id;
          public          postgres    false    316                       1259    18354 	   suppliers    TABLE     Z  CREATE TABLE public.suppliers (
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
       public         heap    postgres    false    6                       1259    18361    suppliers_id_seq    SEQUENCE     y   CREATE SEQUENCE public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.suppliers_id_seq;
       public          postgres    false    6    278            S           0    0    suppliers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;
          public          postgres    false    279            &           1259    18725    sv_login_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sv_login_session_id_seq;
       public          postgres    false    6    295            T           0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
          public          postgres    false    294                       1259    18363    users    TABLE     �  CREATE TABLE public.users (
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
       public         heap    postgres    false    6                       1259    18371    users_branch    TABLE     �   CREATE TABLE public.users_branch (
    user_id integer NOT NULL,
    branch_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);
     DROP TABLE public.users_branch;
       public         heap    postgres    false    6                       1259    18375    users_experience    TABLE     P  CREATE TABLE public.users_experience (
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
       public         heap    postgres    false    6                       1259    18382    users_experience_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_experience_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.users_experience_id_seq;
       public          postgres    false    282    6            U           0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
          public          postgres    false    283                       1259    18384    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    280    6            V           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    284                       1259    18386    users_mutation    TABLE     K  CREATE TABLE public.users_mutation (
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
       public         heap    postgres    false    6                       1259    18393    users_mutation_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.users_mutation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.users_mutation_id_seq;
       public          postgres    false    285    6            W           0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
          public          postgres    false    286                       1259    18395    users_shift    TABLE     �  CREATE TABLE public.users_shift (
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
       public         heap    postgres    false    6                        1259    18402    users_shift_id_seq    SEQUENCE     {   CREATE SEQUENCE public.users_shift_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.users_shift_id_seq;
       public          postgres    false    287    6            X           0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
          public          postgres    false    288            !           1259    18404    users_skills    TABLE     [  CREATE TABLE public.users_skills (
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
       public         heap    postgres    false    6            "           1259    18412    voucher    TABLE     	  CREATE TABLE public.voucher (
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
       public         heap    postgres    false    6            #           1259    18421    voucher_id_seq    SEQUENCE     w   CREATE SEQUENCE public.voucher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.voucher_id_seq;
       public          postgres    false    290    6            Y           0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
          public          postgres    false    291            �           2604    18423 	   branch id    DEFAULT     f   ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);
 8   ALTER TABLE public.branch ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    202            �           2604    18424    branch_room id    DEFAULT     p   ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);
 =   ALTER TABLE public.branch_room ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    205    204            P           2604    18723    branch_shift id    DEFAULT     r   ALTER TABLE ONLY public.branch_shift ALTER COLUMN id SET DEFAULT nextval('public.branch_shift_id_seq'::regclass);
 >   ALTER TABLE public.branch_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    292    293    293            b           2604    26922    calendar id    DEFAULT     j   ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);
 :   ALTER TABLE public.calendar ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    305    304    305            �           2604    18425 
   company id    DEFAULT     h   ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);
 9   ALTER TABLE public.company ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    207    206            �           2604    18426    customers id    DEFAULT     l   ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);
 ;   ALTER TABLE public.customers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    208            ^           2604    18777    customers_registration id    DEFAULT     �   ALTER TABLE ONLY public.customers_registration ALTER COLUMN id SET DEFAULT nextval('public.customers_registration_id_seq'::regclass);
 H   ALTER TABLE public.customers_registration ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    302    303    303            e           2604    28176    customers_segment id    DEFAULT     |   ALTER TABLE ONLY public.customers_segment ALTER COLUMN id SET DEFAULT nextval('public.customers_segment_id_seq'::regclass);
 C   ALTER TABLE public.customers_segment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    309    308    309            �           2604    18427    departments id    DEFAULT     o   ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);
 =   ALTER TABLE public.departments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    210            �           2604    18428    failed_jobs id    DEFAULT     p   ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);
 =   ALTER TABLE public.failed_jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    212            �           2604    18429    invoice_master id    DEFAULT     v   ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);
 @   ALTER TABLE public.invoice_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215            �           2604    18430    job_title id    DEFAULT     l   ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);
 ;   ALTER TABLE public.job_title ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217            R           2604    18730    login_session id    DEFAULT     w   ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);
 ?   ALTER TABLE public.login_session ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    295    294    295            �           2604    18431    migrations id    DEFAULT     n   ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);
 <   ALTER TABLE public.migrations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219            �           2604    18432    order_master id    DEFAULT     r   ALTER TABLE ONLY public.order_master ALTER COLUMN id SET DEFAULT nextval('public.order_master_id_seq'::regclass);
 >   ALTER TABLE public.order_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    225    224            �           2604    18433    period_price_sell id    DEFAULT     |   ALTER TABLE ONLY public.period_price_sell ALTER COLUMN id SET DEFAULT nextval('public.period_price_sell_id_seq'::regclass);
 C   ALTER TABLE public.period_price_sell ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    228            �           2604    18434    permissions id    DEFAULT     p   ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);
 =   ALTER TABLE public.permissions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    232    231            �           2604    18435    personal_access_tokens id    DEFAULT     �   ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);
 H   ALTER TABLE public.personal_access_tokens ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    234    233            k           2604    30747    petty_cash id    DEFAULT     n   ALTER TABLE ONLY public.petty_cash ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_id_seq'::regclass);
 <   ALTER TABLE public.petty_cash ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    311    312    312            n           2604    30762    petty_cash_detail id    DEFAULT     |   ALTER TABLE ONLY public.petty_cash_detail ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_detail_id_seq'::regclass);
 C   ALTER TABLE public.petty_cash_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    313    314    314            �           2604    18436    posts id    DEFAULT     d   ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);
 7   ALTER TABLE public.posts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    237    236            �           2604    18437    price_adjustment id    DEFAULT     z   ALTER TABLE ONLY public.price_adjustment ALTER COLUMN id SET DEFAULT nextval('public.price_adjustment_id_seq'::regclass);
 B   ALTER TABLE public.price_adjustment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    239    238            �           2604    18438    product_brand id    DEFAULT     t   ALTER TABLE ONLY public.product_brand ALTER COLUMN id SET DEFAULT nextval('public.product_brand_id_seq'::regclass);
 ?   ALTER TABLE public.product_brand ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    241    240            �           2604    18439    product_category id    DEFAULT     z   ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);
 B   ALTER TABLE public.product_category ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    243    242            �           2604    18440    product_sku id    DEFAULT     p   ALTER TABLE ONLY public.product_sku ALTER COLUMN id SET DEFAULT nextval('public.product_sku_id_seq'::regclass);
 =   ALTER TABLE public.product_sku ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    251    250            �           2604    18441    product_stock_detail id    DEFAULT     �   ALTER TABLE ONLY public.product_stock_detail ALTER COLUMN id SET DEFAULT nextval('public.product_stock_detail_id_seq'::regclass);
 F   ALTER TABLE public.product_stock_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    254    253            �           2604    18442    product_type id    DEFAULT     r   ALTER TABLE ONLY public.product_type ALTER COLUMN id SET DEFAULT nextval('public.product_type_id_seq'::regclass);
 >   ALTER TABLE public.product_type ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    256    255                       2604    18443    purchase_master id    DEFAULT     x   ALTER TABLE ONLY public.purchase_master ALTER COLUMN id SET DEFAULT nextval('public.purchase_master_id_seq'::regclass);
 A   ALTER TABLE public.purchase_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    262    261                       2604    18444    receive_master id    DEFAULT     v   ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);
 @   ALTER TABLE public.receive_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    265    264            (           2604    18445    return_sell_master id    DEFAULT     ~   ALTER TABLE ONLY public.return_sell_master ALTER COLUMN id SET DEFAULT nextval('public.return_sell_master_id_seq'::regclass);
 D   ALTER TABLE public.return_sell_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    268    267            4           2604    18446    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    271    270            T           2604    18739    sales id    DEFAULT     d   ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);
 7   ALTER TABLE public.sales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    296    297    297            V           2604    18753    sales_trip id    DEFAULT     n   ALTER TABLE ONLY public.sales_trip ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_id_seq'::regclass);
 <   ALTER TABLE public.sales_trip ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    298    299    299            \           2604    18765    sales_trip_detail id    DEFAULT     |   ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);
 C   ALTER TABLE public.sales_trip_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    301    300    301            c           2604    27183    sales_visit id    DEFAULT     p   ALTER TABLE ONLY public.sales_visit ALTER COLUMN id SET DEFAULT nextval('public.sales_visit_id_seq'::regclass);
 =   ALTER TABLE public.sales_visit ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    307    306    307            5           2604    18447    setting_document_counter id    DEFAULT     �   ALTER TABLE ONLY public.setting_document_counter ALTER COLUMN id SET DEFAULT nextval('public.setting_document_counter_id_seq'::regclass);
 J   ALTER TABLE public.setting_document_counter ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    273    272            9           2604    18448    shift id    DEFAULT     d   ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);
 7   ALTER TABLE public.shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    277    275            t           2604    33396    stock_log id    DEFAULT     l   ALTER TABLE ONLY public.stock_log ALTER COLUMN id SET DEFAULT nextval('public.stock_log_id_seq'::regclass);
 ;   ALTER TABLE public.stock_log ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    317    316    317            >           2604    18449    suppliers id    DEFAULT     l   ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);
 ;   ALTER TABLE public.suppliers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    279    278            �           2604    18450    uom id    DEFAULT     h   ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);
 5   ALTER TABLE public.uom ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    259    258            @           2604    18451    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    284    280            D           2604    18452    users_experience id    DEFAULT     z   ALTER TABLE ONLY public.users_experience ALTER COLUMN id SET DEFAULT nextval('public.users_experience_id_seq'::regclass);
 B   ALTER TABLE public.users_experience ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    283    282            F           2604    18453    users_mutation id    DEFAULT     v   ALTER TABLE ONLY public.users_mutation ALTER COLUMN id SET DEFAULT nextval('public.users_mutation_id_seq'::regclass);
 @   ALTER TABLE public.users_mutation ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    286    285            I           2604    18454    users_shift id    DEFAULT     p   ALTER TABLE ONLY public.users_shift ALTER COLUMN id SET DEFAULT nextval('public.users_shift_id_seq'::regclass);
 =   ALTER TABLE public.users_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    288    287            L           2604    18455 
   voucher id    DEFAULT     h   ALTER TABLE ONLY public.voucher ALTER COLUMN id SET DEFAULT nextval('public.voucher_id_seq'::regclass);
 9   ALTER TABLE public.voucher ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    291    290            �          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    202   �`      �          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    204   �a      
          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   "c                0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   kc      �          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    206   By      �          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    208   �y                0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    303   a�                0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    309   ~�      �          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    210   ��      �          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    212   %�      �          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at) FROM stdin;
    public          postgres    false    214   B�      #          0    34018    invoice_detail_log 
   TABLE DATA             COPY public.invoice_detail_log (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, created_at_insert) FROM stdin;
    public          postgres    false    318   yY                 0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    315   ӎ      �          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    215   3�      �          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    217   �w                0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    295   ix      �          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    219   �x      �          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    221   m}      �          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    222   �}      �          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    223   8~      �          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    224   U~      �          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    226   r~      �          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    227   �~      �          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    228   �      �          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    230   ��      �          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    231   ��      �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    233   y�                0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    312   ��                0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    314   '�      �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    235   S�      �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    236   ��      �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    238   ��      �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    240   ��      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    242   ��      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    244   J�      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    245   f      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    246   8      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    247   �	      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248         �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    249   i                0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    310   �      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    250   �      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    252   '      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    253   �-      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    255   .      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    257   �.      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    260   7      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    261   �7      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    263   �8      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    264   9      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    266   �9      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    267   �9      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    269   �9      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    270   @B                0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    297   �B                0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    299   	C                0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    301   &C                0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    307   CC      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    272   `C      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    274   JE      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    275   �E      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   F      "          0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    317   �F      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    278   s�      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    258   ��      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    280   Q�      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    281   ��      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   ��                0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    285   ��                0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    287   `�                0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    289   }�                0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    290   ��      Z           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    203            [           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    205            \           0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    292            ]           0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    304            ^           0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    207            _           0    0    customers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.customers_id_seq', 1131, true);
          public          postgres    false    209            `           0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    302            a           0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    308            b           0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    211            c           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    213            d           0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 1459, true);
          public          postgres    false    216            e           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    218            f           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    220            g           0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    225            h           0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2209, true);
          public          postgres    false    229            i           0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 515, true);
          public          postgres    false    232            j           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    234            k           0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 344, true);
          public          postgres    false    313            l           0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 43, true);
          public          postgres    false    311            m           0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    237            n           0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    239            o           0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 22, true);
          public          postgres    false    241            p           0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 52, true);
          public          postgres    false    243            q           0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 329, true);
          public          postgres    false    251            r           0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 25, true);
          public          postgres    false    254            s           0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    256            t           0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 54, true);
          public          postgres    false    259            u           0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 21, true);
          public          postgres    false    262            v           0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 32, true);
          public          postgres    false    265            w           0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    268            x           0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 13, true);
          public          postgres    false    271            y           0    0    sales_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sales_id_seq', 1, true);
          public          postgres    false    296            z           0    0    sales_trip_detail_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 21, true);
          public          postgres    false    300            {           0    0    sales_trip_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sales_trip_id_seq', 4, true);
          public          postgres    false    298            |           0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 1, false);
          public          postgres    false    306            }           0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 52, true);
          public          postgres    false    273            ~           0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 12, true);
          public          postgres    false    277                       0    0    stock_log_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stock_log_id_seq', 3377, true);
          public          postgres    false    316            �           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 5, true);
          public          postgres    false    279            �           0    0    sv_login_session_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 71, true);
          public          postgres    false    294            �           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    283            �           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 88, true);
          public          postgres    false    284            �           0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 71, true);
          public          postgres    false    286            �           0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    288            �           0    0    voucher_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.voucher_id_seq', 1226, true);
          public          postgres    false    291            x           2606    18459    branch branch_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_pk;
       public            postgres    false    202            |           2606    18461    branch_room branch_room_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_pk;
       public            postgres    false    204            z           2606    18463    branch branch_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_un;
       public            postgres    false    202                       2606    26927    calendar calendar_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.calendar DROP CONSTRAINT calendar_pk;
       public            postgres    false    305            ~           2606    18465    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    206            �           2606    18467    customers customers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pk;
       public            postgres    false    208                       2606    18784 0   customers_registration customers_registration_pk 
   CONSTRAINT     n   ALTER TABLE ONLY public.customers_registration
    ADD CONSTRAINT customers_registration_pk PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.customers_registration DROP CONSTRAINT customers_registration_pk;
       public            postgres    false    303                       2606    28182 &   customers_segment customers_segment_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.customers_segment
    ADD CONSTRAINT customers_segment_pk PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.customers_segment DROP CONSTRAINT customers_segment_pk;
       public            postgres    false    309            �           2606    18469    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    212            �           2606    18471 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    212            �           2606    18473     invoice_detail invoice_detail_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_pk;
       public            postgres    false    214    214            �           2606    18475     invoice_master invoice_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_pk;
       public            postgres    false    215            �           2606    18477     invoice_master invoice_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_un;
       public            postgres    false    215            �           2606    18479    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    219            �           2606    18481 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public            postgres    false    221    221    221            �           2606    18483 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public            postgres    false    222    222    222            �           2606    18485    order_detail order_detail_pk 
   CONSTRAINT     l   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_pk;
       public            postgres    false    223    223            �           2606    18487    order_master order_master_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_pk;
       public            postgres    false    224            �           2606    18489    order_master order_master_un 
   CONSTRAINT     [   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_un;
       public            postgres    false    224            �           2606    18491    period_stock period_stock_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);
 F   ALTER TABLE ONLY public.period_stock DROP CONSTRAINT period_stock_pk;
       public            postgres    false    230    230    230            �           2606    18493    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    231            �           2606    18495 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public            postgres    false    233            �           2606    18497 :   personal_access_tokens personal_access_tokens_token_unique 
   CONSTRAINT     v   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);
 d   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_token_unique;
       public            postgres    false    233                       2606    30771 &   petty_cash_detail petty_cash_detail_pk 
   CONSTRAINT     t   ALTER TABLE ONLY public.petty_cash_detail
    ADD CONSTRAINT petty_cash_detail_pk PRIMARY KEY (doc_no, product_id);
 P   ALTER TABLE ONLY public.petty_cash_detail DROP CONSTRAINT petty_cash_detail_pk;
       public            postgres    false    314    314                       2606    30754    petty_cash petty_cash_pk 
   CONSTRAINT     V   ALTER TABLE ONLY public.petty_cash
    ADD CONSTRAINT petty_cash_pk PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.petty_cash DROP CONSTRAINT petty_cash_pk;
       public            postgres    false    312                       2606    30756    petty_cash petty_cash_un 
   CONSTRAINT     U   ALTER TABLE ONLY public.petty_cash
    ADD CONSTRAINT petty_cash_un UNIQUE (doc_no);
 B   ALTER TABLE ONLY public.petty_cash DROP CONSTRAINT petty_cash_un;
       public            postgres    false    312            �           2606    18499 $   point_conversion point_conversion_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);
 N   ALTER TABLE ONLY public.point_conversion DROP CONSTRAINT point_conversion_pk;
       public            postgres    false    235            �           2606    18501    posts posts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    236            �           2606    18503 $   price_adjustment price_adjustment_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_pk;
       public            postgres    false    238    238    238            �           2606    18505 $   price_adjustment price_adjustment_un 
   CONSTRAINT     ]   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_un;
       public            postgres    false    238            �           2606    18507 6   product_commision_by_year product_commision_by_year_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_pk;
       public            postgres    false    244    244    244    244            �           2606    18509 (   product_commisions product_commisions_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);
 R   ALTER TABLE ONLY public.product_commisions DROP CONSTRAINT product_commisions_pk;
       public            postgres    false    245    245            �           2606    18511 ,   product_distribution product_distribution_pk 
   CONSTRAINT     }   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_pk;
       public            postgres    false    246    246            �           2606    18513 *   product_ingredients product_ingredients_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pk PRIMARY KEY (product_id, product_id_material);
 T   ALTER TABLE ONLY public.product_ingredients DROP CONSTRAINT product_ingredients_pk;
       public            postgres    false    247    247            �           2606    18515    product_point product_point_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_point DROP CONSTRAINT product_point_pk;
       public            postgres    false    248    248                       2606    30130 *   product_price_level product_price_level_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_price_level
    ADD CONSTRAINT product_price_level_pk PRIMARY KEY (product_id, branch_id, qty_min);
 T   ALTER TABLE ONLY public.product_price_level DROP CONSTRAINT product_price_level_pk;
       public            postgres    false    310    310    310            �           2606    18517    product_price product_price_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_price DROP CONSTRAINT product_price_pk;
       public            postgres    false    249    249            �           2606    18519    product_sku product_sku_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_pk;
       public            postgres    false    250            �           2606    18521    product_sku product_sku_un 
   CONSTRAINT     U   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_un UNIQUE (abbr);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_un;
       public            postgres    false    250            �           2606    18523 ,   product_stock_detail product_stock_detail_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.product_stock_detail
    ADD CONSTRAINT product_stock_detail_pk PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.product_stock_detail DROP CONSTRAINT product_stock_detail_pk;
       public            postgres    false    253            �           2606    18525    product_stock product_stock_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_stock DROP CONSTRAINT product_stock_pk;
       public            postgres    false    252    252            �           2606    29118    product_type product_type_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.product_type DROP CONSTRAINT product_type_pk;
       public            postgres    false    255            �           2606    18527    product_uom product_uom_pk 
   CONSTRAINT     h   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_pk PRIMARY KEY (product_id, uom_id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_pk;
       public            postgres    false    257    257            �           2606    18529 "   purchase_detail purchase_detail_pk 
   CONSTRAINT     u   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_pk PRIMARY KEY (purchase_no, product_id);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_pk;
       public            postgres    false    260    260            �           2606    18531 "   purchase_master purchase_master_pk 
   CONSTRAINT     `   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_pk PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_pk;
       public            postgres    false    261            �           2606    18533 "   purchase_master purchase_master_un 
   CONSTRAINT     d   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_un UNIQUE (purchase_no);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_un;
       public            postgres    false    261            �           2606    18535     receive_detail receive_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_pk PRIMARY KEY (receive_no, product_id, expired_at);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_pk;
       public            postgres    false    263    263    263            �           2606    18537     receive_master receive_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_pk;
       public            postgres    false    264            �           2606    18539     receive_master receive_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_un UNIQUE (receive_no);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_un;
       public            postgres    false    264            �           2606    18541 (   return_sell_detail return_sell_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_pk PRIMARY KEY (return_sell_no, product_id);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_pk;
       public            postgres    false    266    266            �           2606    18543 (   return_sell_master return_sell_master_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_pk PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_pk;
       public            postgres    false    267            �           2606    18545 (   return_sell_master return_sell_master_un 
   CONSTRAINT     m   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_un UNIQUE (return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_un;
       public            postgres    false    267            �           2606    18547 .   role_has_permissions role_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);
 X   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_pkey;
       public            postgres    false    269    269            �           2606    18549 "   roles roles_name_guard_name_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);
 L   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_name_guard_name_unique;
       public            postgres    false    270    270            �           2606    18551    roles roles_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_pkey;
       public            postgres    false    270            �           2606    18745    sales sales_pk 
   CONSTRAINT     L   ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pk PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.sales DROP CONSTRAINT sales_pk;
       public            postgres    false    297                       2606    18771 &   sales_trip_detail sales_trip_detail_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.sales_trip_detail
    ADD CONSTRAINT sales_trip_detail_pk PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.sales_trip_detail DROP CONSTRAINT sales_trip_detail_pk;
       public            postgres    false    301                       2606    18759    sales_trip sales_trip_pk 
   CONSTRAINT     V   ALTER TABLE ONLY public.sales_trip
    ADD CONSTRAINT sales_trip_pk PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.sales_trip DROP CONSTRAINT sales_trip_pk;
       public            postgres    false    299                        2606    18747    sales sales_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_un UNIQUE (username);
 8   ALTER TABLE ONLY public.sales DROP CONSTRAINT sales_un;
       public            postgres    false    297            
           2606    27189    sales_visit sales_visit_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.sales_visit
    ADD CONSTRAINT sales_visit_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.sales_visit DROP CONSTRAINT sales_visit_pk;
       public            postgres    false    307            �           2606    18553 4   setting_document_counter setting_document_counter_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_pk PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_pk;
       public            postgres    false    272            �           2606    18555 4   setting_document_counter setting_document_counter_un 
   CONSTRAINT     ~   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_un UNIQUE (doc_type, branch_id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_un;
       public            postgres    false    272    272            �           2606    18557    settings settings_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (company_name, app_name);
 >   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pk;
       public            postgres    false    274    274            �           2606    18559    shift shift_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pk PRIMARY KEY (time_start, time_end);
 8   ALTER TABLE ONLY public.shift DROP CONSTRAINT shift_pk;
       public            postgres    false    275    275                       2606    33402    stock_log stock_log_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.stock_log
    ADD CONSTRAINT stock_log_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.stock_log DROP CONSTRAINT stock_log_pk;
       public            postgres    false    317            �           2606    18561    suppliers suppliers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.suppliers DROP CONSTRAINT suppliers_pk;
       public            postgres    false    278            �           2606    18733 #   login_session sv_login_session_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.login_session
    ADD CONSTRAINT sv_login_session_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY public.login_session DROP CONSTRAINT sv_login_session_pkey;
       public            postgres    false    295            �           2606    18563 
   uom uom_pk 
   CONSTRAINT     H   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_pk;
       public            postgres    false    258            �           2606    18565 
   uom uom_un 
   CONSTRAINT     G   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_un UNIQUE (remark);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_un;
       public            postgres    false    258            �           2606    18567    users_branch users_branch_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.users_branch
    ADD CONSTRAINT users_branch_pk PRIMARY KEY (user_id, branch_id);
 F   ALTER TABLE ONLY public.users_branch DROP CONSTRAINT users_branch_pk;
       public            postgres    false    281    281            �           2606    18569    users users_email_unique 
   CONSTRAINT     T   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_unique;
       public            postgres    false    280            �           2606    18571 $   users_experience users_experience_pk 
   CONSTRAINT     b   ALTER TABLE ONLY public.users_experience
    ADD CONSTRAINT users_experience_pk PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.users_experience DROP CONSTRAINT users_experience_pk;
       public            postgres    false    282            �           2606    18573     users_mutation users_mutation_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.users_mutation
    ADD CONSTRAINT users_mutation_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.users_mutation DROP CONSTRAINT users_mutation_pk;
       public            postgres    false    285            �           2606    18575    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    280            �           2606    18577    users_shift users_shift_pk 
   CONSTRAINT     z   ALTER TABLE ONLY public.users_shift
    ADD CONSTRAINT users_shift_pk PRIMARY KEY (branch_id, users_id, dated, shift_id);
 D   ALTER TABLE ONLY public.users_shift DROP CONSTRAINT users_shift_pk;
       public            postgres    false    287    287    287    287            �           2606    18579    users_skills users_skills_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_pk PRIMARY KEY (users_id, modul, dated, status);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_pk;
       public            postgres    false    289    289    289    289            �           2606    18581    users users_username_unique 
   CONSTRAINT     Z   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);
 E   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_unique;
       public            postgres    false    280            �           2606    18583    voucher voucher_pk 
   CONSTRAINT     e   ALTER TABLE ONLY public.voucher
    ADD CONSTRAINT voucher_pk PRIMARY KEY (voucher_code, branch_id);
 <   ALTER TABLE ONLY public.voucher DROP CONSTRAINT voucher_pk;
       public            postgres    false    290    290            �           1259    18584 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public            postgres    false    221    221            �           1259    18585 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public            postgres    false    222    222            �           1259    18586    password_resets_email_index    INDEX     X   CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);
 /   DROP INDEX public.password_resets_email_index;
       public            postgres    false    226            �           1259    18587 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    233    233                       2606    18588    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    3448    204    202                       2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    215    214    3466                       2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    280    215    3564                       2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    208    215    3456                       2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    231    221    3485                       2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    270    222    3550                       2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    224    223    3480                       2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    280    224    3564                       2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    208    224    3456                        2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    280    236    3564            !           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    250    244    3512            "           2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    3448    244    202            #           2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    244    280    3564            $           2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    3448    246    202            %           2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    250    246    3512            &           2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    250    257    3512            '           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    261    260    3532            (           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    280    261    3564            )           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    264    263    3538            *           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    280    264    3564            +           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    267    266    3544            ,           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    280    267    3564            -           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    208    267    3456            .           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    231    269    3485            /           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    270    269    3550            0           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    3564    289    280            �   �   x�m��
�0D�7_q?@%�jv�(>�Q���d�b���i�v���p�#����ő�j���{�ϗ��)|�� ��1/b.P�*+ϓ,���a7 ��@���]����\ݰ�Aj�i�LI�#�NO�b�-�8�v��d*�8�8
��?�A$�yp�Pp��T^������6      �   _  x�m�Qj�0����"�$�I����Z:];���1�-C�y��gɖ�;��t>���8���C�(ZJH%���TB�(+Ml��7�k{;l�S's���@ˣiJ�L��@�iΗ"�c�p3_��-UJr��f�%,��L��s4��(-ڐh��>.��d�1�'��w�P�Xxg�>.<��.�����Xeg�Y{N�8{�hϩ)���x����Bv�:��91�2iϼA������p�q:�����654�wo�lN��؛�j��g�W��x�A��L�����z�����A��Rǚ��r��AV�����C��x��P7�HJs�%������Z�#�      
   9   x�3�44�44���4202�50�54U04�24�2��!�e�e�U���0W� ���            x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      �   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      �      x����v�ȑ����x6�$x�%�x�����Pkn����ִ��|��f�~##`&*���n]�_�'���]m??l�������}�j�q���uM{eҿ��6���q�5�c���:XQ����1�q�Xۇ�����Q��5�1׍��V�����_���c� lg�d��_YCXzz���O��g����0���7�
׌kQC!<��%�4�ΊB`��i�"�׶5�������Wo��$������{8i��@�o�C7� QC�d������������! �ۛ��N��M+jB5�/yY����/�����0|�>�A�_����/����KݵK74i����xs�%쮝����! ��/
��k��!����ڟ���0�3���n���܃�!����bm�hO� ������h��^��r�߆�#�w+j@O��a��5���ѓ�4���ݡ���8i����<]\�{�=��b�w�7�gA�㍨!�����d�6ף����!�i[�q�=>_&���oD!Z?0Z�NԉB����7b�� �+��}ݸ5��\������5�����B����i��D`�g_{�Y�����4k�Y����YCh���>�/��7��� ������r�=m��8i�}�n�^��xD�[��k?��&��@�i8�l�q����/m��!-7����y8|x��w�)���.�9WĆBN�������׫_~�+E�d�����4k��x���ne���Z�QC��|^?�oA�dv���}۫����]�2�NzQCX�}�y�ˇ�T�����M�u�`�^��{.j6�]7'�IC�_�1N���6��!��햿���������"�Pk�y�\x���x>rQ��.~���]�YZs���.�p�1?��v8�����N��~:R��3e�Z���F�I���a���=lj�C߶��z.�;�j�5��vw����aۚ8�/�7g�o'�ZC`�ໞf�a�^����*�`�b���xƸΘ�u}/���/��IC`��펇cu8]ǅ7�����y�!0��v����b��іg`�ϸ5���_�w����dϜ�&a��U�>/���]��5�t�̖��шB��K��{���\{��� ����vH�m7�$�;�3��A,�Vq%L�h�5�N�7��. 'k��҉D��@�tu㿱}8����ChD��|��x�S��5�!�� n<�.�kD+F��Ŧk�fܢ����a�����O>����������0�Yn�&���[�ٞ{�3�5�A>��A�O�R�s��-3������5����7{�g��τ5� _�((a(8Q�_�n�]A0np:Q�8�g���|����Eb`������Hj�`���^:�d-	��A�D`m���G�Qz��Q�X��Z(�Fx�A�5������ӫfs)�D��nrd� ��~�y�!���;�x�-;z��{�d?o15O��edr� �bn/���-��A ��e�����Α5�|��O۫����es8>}�^���OÖN�~����{�e��Z4>E�j�����LX��~��M��>nw���a�{�o����{9�n?<o�/�.�`�¸m��O�=����M*5y��O�E�烛����ON*��0T���UkIކ��dk!���R�ҹ^KP$��B��TϗB̻s��M����� YjR:��(R���H�AH��߃p1p���!+5������n�~N@��u�;�h��	k�\�7��]�h\u�[jGڽ��n�J�H긅���3 m�*5$�c�w�����xWn!KI���[�/��p�Ζ5���_�E���^�����~<�_�М�.�A��}���B�Ҧྒྷ5���F�笧[^#j�u��w���)�-�5��_}���_����V��<ѥ3�5�$$�����?�A���� �v5���1��t	������oY|�qī_���׿��/:�BCފD�'�_���?~ׂ�]QC@���j��K�b���o�ϣ#�)tX��DB��KBP��侼/#Jq��~��X�(����(���C���b��Z'j�S��n?DVC�V�PkI
�~�*1�t�:Q�0h��D5�JWd
������	i�R��0:��]���ixւ�8�5�����*W⪽H�A �T�����V�� �1���f��F�2;�� ����0e	p�A�V��ќ��d[��
� ���rP��J�,5�<*�>(9�9�`X�8"�������̱�M��r�Z���y�nP���f[f@����y?Vr��ؑvW]��s��|�(�t�4U��� ��ڼ�1\y�]jyџ�?�G[&b��A;�U�n؉�A����U��|�?k�єsy����sW>k�P-B��ׅ!���8S޽�B@EJZ��8*�D���z��9[��N�5������~F�f�RᢨA���:��	m� :��Zbk6]�F� r��)�g�m�EKy�Ao=������5��<�*���Pk�ݿ*b�M�h5����l3��k���������f��Rk�ͧ��e��&�O�T����~�|X����
�� r���a\ʹ �-�� ����O��g*k�ԏ��#IA� �6_���2���"o�qts���#�Z�8bNNZ�1_��đ�����Ki�ފ�a� �}Ps�f��N�aVs���1iGJ�����6��{qx��6�Q��q��J�� �����R2�ɋ�B.��x�d�7m�;�KDuN}�AD�Z?m.߭L6��m�?�4���$�U�5�����s���������QH'<��/�3��p�f����K�:i
EI �5�����9W�U�Դ���?���-F�����aP����f�N��ӆ���1����^-�d/u؎�1�y���^g�����OH�:�H��N,f���[MN�A�C������L������"���!�|�F�I����`�<�ò-���[Nm�A��f��g{vy��4����n��B�P�����Ů8BJ��om�jB�<�
���%��Юy
᭶�� ��ǋ�d�J�k" ���a,�.�EB����_D�gA����n�m�A�YQ�8h[������ayռ�9�L�/��A��TuV��M�?�`e�uth�?jreg��Z�B!ǹM�I��[�{�AtXO�Z��M�֏�� ��,D��W���3]�r����Ȗ˘>R��b&�d6յ��B#��uv��~&)�m�ʲ���]�ᜨA\�?<]�u����J�� ���j�!mn�S��� ��x|��2~�_�_�5�|������t�a"iy�(7�}�4�Du�(,���'Z�_t�=��F-5z9�$MDB^v�U��)���SkG�	G�͚�f������]��5��*jg���I�8h���T|�{$8#j��5�6���_hy�O��a��]�ɮ����$�ݭ*����Mb+jH���U ։B�u�xs��z2�.�� �A �����j�٨}K2�5�w���&3�l���򁰆p�|��w������ªYz� �\ߤ]l�����/�˛U�l3}���ȤA�YWqt�=��A~N;y/veSග,Zk���Ob�d��e(`� .iڿצs���"��������j2i���テ�_�'"�&|ۇ��8����5����ǋ?C��ѠY�8_�L��6
�;& ���]�e�6��� ��`�1�D@yAj�|Y��r�~��d�ٚ�""���N��ܿB��bv��{�PkA��*�^ �Q��v�t� ���Ao�J�	��{�D`��� W�DQ� �u��u�Q��|b�A�roV�h P5� �3��A��!.��OvӚ(kK���/?�4��5���nS'�X���y�����
�Z    �`x��L�`��to3 j���7}��޼��/ge�T��BC`�&�4���]g���r*�lݞ~F�ADfn�_Gm��m�ΰ�*��� �knv�Nhw�~���E�`�a��M���mdo<o��(�Ayh�{U���P:D��7�w���l�cWhB�_d�B�ȯnT��rm�[{�Z�0�� �呼� ��f�=&��5 �qUx^҉�˒��X�dt��Mbs�h�7�'�i���Y�W��Ax~=�5��������q��9�撊������ �twT]��n����A�͕�5�#������Ȥ� ��{V>i:#Of�����p9�׍��uu�J�A fE��d��ee�<W������� 7�S?_��
"�\���-�_� ��n�8M���#a!Ǻ���9c�~���đ���g�F$��*<WhI���*���}u�Xh����*)����ś:i*���t�N@""r\���*I�����Ქ�$uQ�A$G�#C�v}Ӆv9Qd4말T#j�/��{�]���SU�Aa�lZ�9��oڇ����u(�� ����A���:�D��i�z������H44�EQ�h�<�F$��8��U۴B��r`u������)�4Ի=C�W`��Pq������{�6�y[��Ԕ�5�����q�;	��M��R���B������c�A i�t�I�F�d"�o��E�;�.u�a��TZhL�{�\~]u-4����i8�e����)4���Go�R�����]׹Ӌ	O�����*4)�"g]�[��v�� J�_I�U7�����@��x�u��_�ӳq�\>!���Mۺ�JKPr��:D��u�r���)[��]ԬA$��M�ssڇ|2�Z�Q�LS�@�~6پ�?�5#��B���F�A�eos���f깸�UX�8ȷ>��b#�#��A �J�8�7bS�S�,4��"1�:�6�kmhO�G�<���,4�(49�S�h��$��Nm7d��j�Qh�a�����*Ps�(j��?s�p��p�9��Whoh���<q�AL�Jp���������4)'䜗�B�AL��u�����R/�q�A�N�<,��E�����Z�BNt1ˏ�5��Hbu�Qh	Mۻ�wJ�8QCP�n��D�w(
4�&T5u�pҫ��h�J����q��.Xb��W����	}���!�)_� � �T7Ql3�M��5��w��Vp�͸
�h�&��M��R��2�^h���W1� �p���ܫN�<8���5�G�l.O��m�ա��������b�=k������1�<Q�Q�Ph'��_��K�AN;r���Y�8<�"�[�΁���p�`���l3�t㷱8V����)l�WEʅa�M�.C��R�4Q�@�T'����ִ�7�Ǭ�&���a'j�41J��C�v�vN�
#�.�*4��&H�����mD�2��P���h[E
���4k�[��g4���V���6Ϲ-����AS���4�LK�5�;�>�������}[lWt�l)��Vw��qP�����w��m��$vI�D�Q[����,�B�0�L9;���Ј�����m�*/�� .B��z!���l�E����T�B�@�w�����m�q+4���d���õ���q�9�C�s�fmu�*4����W�u�`��� ����>_��:u���\h�{U�9���jVM�A=O�����&���p��������oH�U�B�8ȧ��ئ?�\X�8,�vU4�m�s�
�������Ë�����
"�~+H�A$�#j�H `��h�B�Hڷ^IJ���B�@:n��� �q�s��:ɜ��*�ZhI�*�}�j��!$�|���ʅ��7kg���E ����T̐Qo��B�@�T�g�&��e��?�h/o8S@nhMl|]{�=����z�o�AH�ˋnX[�g�;�B�@�þ��:UX��ڥ�5	���z�m�A,�`_�/�#�U��� �>��+HBS]�Bb����Q�:�Q�nS�bփ�SJ� �']���v��� �<�jDP]n�Y[�`�B1����V��h���[��$�u�ӂ�j�VhH����m�*^h�W�V�H+<�~ 9	K��Fc�x�� �>��}S���U�T1�BCH\��ި˳H��%�;F{7_`i擲Q_%�¾u;�4	.%�փ
"�e\��#6��d� �&���z�f�9�4�\�V7[�m��UhG�k�4�g���@�A�٪L��˥w� ��no�476d4ԣ�
a�z�WU?�ѺU�! \��8����E|�� v��H���� ��ꆜt9UÜ�#h��sB5H���5�s��GUL����6�� ��꯷��� j{��/�i]n:��A 9!K�%qjh"k��~��Z�5�"��0��~/<�J�S����ѣ�����r��qX�~sxQ�06,֘Y�@(+�.��*.{Q�8ȡ�n�㍚�U,���GݏGMaj7�U���P��:�����*ϻ)�˟�T� �ȭVw��dt܄�Q�Y�@ȩn���d�[lTg�h��X�e�LU5�q�<E�A�n��1i�^�ov;�$�.'�Ձ�Y�@�Z]R�1g��A\��YhH�P�2v�Z�� ��ǠE� ���U��,5!�E���-k8Bu�\h�	hCT�ef��5��˃\���G��|MY�8���Fp����5�G�>�#�6�E�C�:��:lD��wZ��!T�A$aj���9&���9���ȐєQeE�r�����5�N�H�B�Ph��u�:S�;jGUhGT׀����a�Ygڗ�i���A t�����դI�ѮJ+*4�/�֑�U��B�H\^{�/�7U"O�A ~ō7۬;z��*������a�A R���1��߅5��)�/HK��(j��Aw��F]u�/4�����^vl�/��IC@�� ��K-9�V� ����f��s����X�-+vv�AR��5Ľ�c�,Iy�,4�$w��<�"4l�W�օ���LJd�a�#�4��ҍ�j4 ���H�A �]W��fy��4���������jY"!��|��=�t˹����Ys��M�⻙4����zTs�*�ZhGn�Q宲Ѯ��B�V��݋�𚬦�V� v�����'jG�+���~���$�^� 	<6��|^��/]ɤA,i=~�ܠE��� @�:'``��������As�:���������*?�.N��j� 
<i�y�d���đG��Ę�cj2k7X�aO���(έ��Ő�R�
⠮+�8�b��5��]�Qυ(4����#E|azQ�@ț��O���9�g�oD���Z��a�J'��������5Y=y[Y�H�MԊ�������U��\�Q&YD��tT��������fu�I�Ӑ�ņ�� �����gH��B�H8�;Y��PM�(4d�����\~�6��HO����UhH.�ZKRf�D�kX����|ay��5��C����l�WۣB�@r�U�01-#υ��wݨ�}�iK�6q\g�r���[�i|���qh�֐Gg�g�A� ڽn���}�nv��Ay̶j�:�,Ӝ� ������&��n�Sh�[=m?kW���b�ʧ��̆�gҁ���[��Bd3�]%�Z<���M�2��nX�P<'�h��d�-׽�v�	yz���IM��/+k���;m��+�Kn�A,90�����穦ƉD��JkEB!��i�m�$)y�5��gg�?�R�&�a����pp`�:�Q���~� �r�DK&�&�����EZ� ��O�����QhG������Z�šb� v��	M����{MEbɡ�e1�� �����M�| �1x
����A���IC8��j�����}fD� ��q�Q�ᅷ��oW_=�k���l/4$oZ׀ԃ�
��D4�W}.��ߏY�0xz�G�>�m+j�c}9�*�'�V� wf-�c����|=�f'j    w��&7�?!A���_�Wݴ%���n�����.�� *h՞���˝<������"��=C�&+�D��VkI�5�$�T�zd34�CլA�%�U��ĸ��5������d�_>�I�0�ǵ�2 ���B�8b��|w*�i(�є��K"��^�+��RC"_X%7z��-��R��P�&g%����b�	{�z��KPj�o6*{���#A���F�}f�my�_j�O�IB5��7�n2J`Y�@(lzP]f�Ed�A�3�Nq�=uV� �>'� �h�64�5��X��0N� �����j�G%�&�@������<k��٪-��J"ɓ�=(���h(�"Ka�z�4�6ۅ?�5�#����t�g��-�K��T+I��A$�Y�gM�L�j�^��Ds-�J�`EB������m�[J#j G�49��Eu�:����A(f��Z�Eb���V591ui��t�����o{MS�٬P��������	�&]#jFȩ2�[�9�ͦ��%
kJ�g��J�g�Ɗ����g�s���Ĝ���x�3�qR� 
�/�8q����BCy�/��QA���R�L�D��2A��[��A�A��R�֗J�!�1�Q�.��SY�򴪔|�Rj_�?_��w��ed"h��t�KG�`EB�+����7�Kk�+�R��7��Pm�"ȗJ���MSo�����Uv*4���ҡQ�~�QהC)K�3�5)�U�Q^�"�)P7�ʗ�h��-4���U=�ͶL�)5��}�J#�`7m.�z�V�2�k�D&����F�@Hn��Uu&�V}uv-4��B�u�c������p�t-I�	�5��5g�kc4�?�	����t�D����ͳ@d\�7��G�#���K"� "��]W�AD �S�AD��3�q]ׅ��w��2�� ��i�il�[Ӹ��c�U~�AD�٩"�#�C��}' �4ȳ�`-4�����3��ͻƶү6�w�x�R��r�Տ!��p�AH\�z|�H�^��]0!�ǋL��.R
a�l�(nw���&�-�'�4��p�aP�J65ڶ�q�c!�7t&�}l�DDM6�ؤAD�}%y!k���1��k(n�SM��-ֳY���Q�3Up��ft�AJ�e�\��͍�k�/��^$r�..�DD��a�4H�����¿� ���B>oo�(�q6�8�F�;�h�Z> � n�ux��ˎ�����m+��TL����)T'�B��hw}|ڊ��.t���	�+� K�"���*u�
f<�����a"�,AD��(�DD>�u#e�Y�t.�]'.�4���D�u	O�W/���Mj�7�S��݈�����(栏T6�i#n <u��D��ޣR0-��AL����dHcs�hy����)��~\�z)�EA�c���G�m�:k�赩)��DB2��f�����#5��h+j��mn5!=�[#j����ף��gl?n���hbJg���AH>'-�(�kEb
S�W�D��r�4��=�t7틚�vV|�"v�q�z�CD��!Rj� ވS�F$?��l'��>�7�5)���Q�(jQ�L�>D���8��w�"j�� �ֽ�Bј�6���ޑn(��wsh����^���˸ƺ~<<Eq���ʊD����jMߋ'��P��=
�{�W�&�F��B�@�PġO�Gm����cS��b�5��͉1�����D#�@)��.~�Y��({�Ǒ|/j�;c���t�Ε��A<|�8ܞ�u}O�&_g��4M�a��cbB"}��l:��u�"�)���*
"����ˬi��q�k����zG[h��O�/Ų���f#A������Qy.�B"!�t�d}��zZD�ADᝤZ��4��
�$�4��"gF�`�{�@dӭ�	�Q0d+-��y�Mm�A<q�yfW��_.��F���i�Yf�!q�]� ���ֆ��}szQ�(��~���0Ѭ2y��q�_�k{�#�N�-4����Rs]L����0B�ӔA'j�D^���	�I�4"���yA�  r���G���Q
�9Q��<�ĸ��f���O�Q&��E�D�9"b�a��5�����vl��*�Vh9����QS��rk����ñƞ��/��&K.���������<�����ތ;!���i�N� ��Ɯ���4';���W8��a��4��sA�T��ckÙG4����b�A@�r/u5)��L
J
D4�n�'"r<.�N�ɴ�o|�h,�k�l�B���Z��E@f�%��Ή�Z�h�_jR����"QyU]hQ�W��rS��ԋB�8�zo��M�ݡ�d=mP�O�5�(��΀���� �>g4K{g�q�z�X�S��k�Bd�A����)s�i�N܈q��[Q���{�BCB?�W�#F��U���1�<R��5�B��N���A<���i��g����t cg��?�c<��4>R 2��E"��j"��n)�5��]Ӥ;Y��ɪ���?���-��������f��D��)�3��֎��]![����M#+v���%t�mbO] �ߕF�K^����dۦi�w�/�v��ɢ�  s�(� �A� "����F
�+����B��}�5gRO	ܾ*j+4����U ֊2�*�V� �4�;U�2:�>��qC�U��S쯩6���p�bx�6���%7�������eQ����XU��)b��B�!\v�۫Z����XL�*5��;_�z�yJyt�{�A:��.�MWMD-5����jp�Lѽ^� �-Q�� �l֟>� �)#Cu�'�!��5�6���7�J&���pM�)�TY|�u\�S��\:Q�0�Z��
��ѯ�w��ex�.�jZ�g�n�O�A{�������%x� �,�?i����T^gE႒U ��[h��S������A�xr����Zۘ �<�G�7���|���k�Ͱ8	���UُR$ަ�[��1��&-�kS���I1�ގ��=�8��i�iq��g�R�����-7u��BC���o��[��L}j�5�����p�dԦ��zW;k���F_��qQ� ǍpKl�T�J���A��m�*�� ��iz�E�u�A�ou���j�B�88z���Zɨ���B�@r������V� �~¥�I���8:�2�Uh	��=����@-	��)4���Q��A(�Zo7���J�/֛(�M��P�����ji�Fc�5Phyٵ g4$�/�jֿ@y�n�	M�����n�I2�T߈B~v5H+jH<��)s8S5a.4��皑��������������趵 剽� �܊X:�H�[a��L�a9�v��rʥq����]:(��ƈ���{��R�;E�����Z�eQXYhK;�z*�
�&Q� ���nܝhI|}.4�$�}��f'�I�>������EL����;i��}�>h_�H3�e1��<�h?�H����A$�[�_��n�_h���g�g�����A�_�4��2I諸c�A$�K�} )��,0f��$�O{)�DI3zQ�@:�������j9�ƈC�u=LX�����A�=� �´BCH�0��F3�=�쫴�B�8��}pv�7�B�*Y?���E��#�T���h�Eq��˭�$��j�
"��<���ͣ2����UY�A,��}<>��OHZj�[��)4��+����`���kBsK"��Q�DD�w�ʼ&��Q��,4�\�:�2*\h����)�L�۵�Sh H��ob����	��A�]���Z�A�\�� ����A�[���;�YZ����f��]�F�L�)4��3b�q8Y�8x���t����a�V9b����j�B�@b�X�$T]B���ꢞmօ=��pp]��ۊ�����D���n��ծ0.�&�5���Wʗ�-7���p���.��=$�^� �#��PVK�ѱ�t,4��Z׊BZ��n�GH�uD����W�{�L�\U�\hI�v��Dv���6    1�q�q��I��_:��]�@�ꪱ� ڬ�J���6�V5Q� ����N���/C*d��/��AH������eI#j�_���j'j	����U���������ӑ{�u�4�k���-lD[���A���v���g�A��@Yuuuo�A$=�qT�:m�����!.�n�wJ�u����@ڜ;�L���\Ý������MD�W���?�������wK��Ј������g-��G������<e�u�h�A�����o��~ )��5�M ��~�r�GӋ���~I��9���hf��ϖI�?u�s� �\*{�$.T@���pI�:��J_/4$��ݮ �L�|$�A$6�~��d�[�g� ���4��_2:檮�'iR7�P3>U	H'MLB
�,��tn�#ԫvyBjy�_h�����?����z���lhlw���t�ӌ��5����.��g��̦x}+jJ�[7��Mob��9�t�Չā��P��7l���x��'ݝ���J�}�>�,5I�\_�A$���鮝:�r��˅���ՙ��]���r�A ���:�(j��[M��j�UhHn���c��&����O��Z/����o�)4�(�Գp�b�7M�k%��*�PhO�j.��d��Sh�zm�{����i���f��k��'��R��X'b���N��r�ܲB�� �OB��u�1��BI��댪B��|&z~v��o�.`إ�mچ7���U2GJ8��q����8`���Atav��OYq#���V�2�PhR���tn�bj�,�z�R�AD=O��]�v�}�	���t��&�2�b�{�At����8Q�8�m�z�F뾧���U�5&3�aP0W����Hv�E���Í��K�݃���u�W5�����?)O�)��.�T��p�����p#�.ֶ}t�������F� ����;e�#�'�Y�@xF��^u���j�'RhH� Ý�R9���|��x�H���jYUh�9�on\��o�C�����' 'j�͍���Q�d$pI��������DT�	D4u?�i�֭�h����)�|F�AD\�{�5Y3�ڍq�8��d"���.%'�(Ģ�I�A ]���]�Ɯ�[��D��F��r�4�˚`NC��R?��4������s�V��BC��<rx/�|k�zQ��8L�,V�� ��F�]tMb��4�b9�5��c�b�N�2�o�b�8ͫ�E"�n���)5��Y�5���.����u�m��)L���϶�³�f<�{�7��'-�t�B��8Nqw<�R�5)���?����N#��-,�
"�sx_sĉ9��-,� ��a�<��("E��\����E�&��פAӼw�&�����^�q���f	��e�ë�g:
�EQ�H�n.5֓&��A��Bi�$�H}���A� �k�)����I�8"wo�u4����V� ���	N��O��z=��b�5�#�Qe�6{Q�8ȯ���ս�<��u�qP��J�z��5�����{���t}4��k@Oä\�*4�'p��t��P�����\���5��(�gU��d���P��p�~#��S����B�8x�n��s~�]r���6��w��*T#��'+��"1S�V�Yf����l�����a���đ�u�&�e�B�A �{��H:�/9X�8g���h�Fv�q�����}�qXrV� ��l����BlA� �ܤF���B�0ȡ��
H�f�t���p���?�B�}
{�`H5�#�S=�"�� ��`n�?�����5�q���u��eKfC�`�� �b~mO!iWl
� ���V�+�m�,��qp����:���m'jG�]�_T1	6��hH������V�A
X�Q�1�ᛩ�Yˑ�K� �<���$�>���iT�ϝ�ǈI��xB��|�n��*�\h�^��c���F��%��y�RX��xÏ+jQ��y)IL	��1Q� �G�I+kF�#.�Y�a��?K*4nD�Fޤ��
m��kKhV��C�#Y�&�0�/�.ǁ.�[Q�8�V�?I�xUBt�A�{ۯ�0U �� �ms���q��=
��.uG\n�&�
�ʎ9�u����}�1Jy���A(�T|W��T�#jA��� ��I� z�z|�L0�oYC��lI�&�7ޤ>X�X���h�s�K��w�yĪ#j�Av%�;y��h].�|�\FpuR~�A�6�b��`Bk}�	ia=U)�E$b� �\��JքZP����r��*W=Z���Ff:��fb�xz�#u�!q���Qj�8�Y�il�p'"9_������7bb�E��/�5������^!uѻ�tY2�f�-�o� $3%�jO���U�~���w�Y�:�2k���D�W�h<���,WhM�&.Ę�8cN>wۤ[ꔹD
�����t�� �6o�ϔ���;MR��t[�K"↸�pc����ڀ�۶�RjRD���N�� $��?�T�Ja�1e7��� �v]��i��ͧ��˗�5���3Y�	\�#�k
��z��x�i�qI�V"���|[�-�D�^������F���� ��րą_�5$�ߗ�Ws�K�����?[���ģ�H�8u*_R�J�M��F��b��J�*5$;aMl3۬6��p�z�5/k�愔�[��n_��~�dOD�u�z{�4eܹ� �jn~������H��d����?���� ���5����ן���o��Ƴ�`D"�f����q�T6l��A���_���?�OE#�٨3��D���?+A|�����A �z[�')5 �4MC$�������u�l��.m�0C,����/�s��񻥆��֍tвPὨa,�q�������F�0r������%���M5����_�6z�?kYR@Ӊ��ҋ���V�>i�ݵ����t����/?�*u�=�җA�R�X�A�\�d��^Q�0nܨ*�d��V��br�N{���@��5��rĞ6�{�����D<i��c�V�T�Jc��Uo�l�]~ȓ����,=������o��v�eW�RØ���Ǚ:QØZ���)kg�uVn�a \=�d�v'�ԆA�m���š}�0J�U��Y]�8�A$<��e�U�Y�)����'��oT% ��tW�/6��������|T�P��t�DCq?�R�����ŷ���p��*�p�����������-�5������1�j_h*5��tw��h�j,[�F2͒��,���/����|9����ӋF� ����h���h��8�Ͽ���9݆�&}8�,jM���UJ�rD��������BØ(������翩d��j=*4�%��������T�����Pw-I���F��8��4�A&	Uc�R�H�zl��{'jJv��f[*e\]�i�v�<wQ�����pд�NVm��?�Y�H�I<�P�+�B�P8��۫b'�.e�Z'j��S�t��d�����l&�ފFB=���N���X�
#isG�u(�B4kJ.�8��2[�l���վ��A1#Y��*�5���$�¯d4M�Z�L��~4n3M�������E��@�f}u�Yh
�xuxdt��%k�;��jQ�0.D;�M�d�ەmPJc!/��nܱ��T=<�k�>��}���ISve.5����!��B��0$�ۧ2���o}���mN#�d9�I,iX�hr��ݻUIl.��.��0�7����#1�����SjC���|~|�h0۫{
c0\R�t���Uo�R� (��i�i�@�U��0�����$���Kr�LjM����pw	¥QƉ�K�v7ۋ����9A�0��A{�9(��Ky ~�,X�0�m��KGE\��F�ڗ��1���F�0Ι}y�-�M�h���1�z��F<�[��}�\�&�0�e��6�='j�@�Q �2�F�0v��C��۸�4�7O���r�l�5��m��W�
�������o��BS�kch�e�������� a  ��l�Vw慆���?u���D�*�Ph{������_��(�ډF��[N�l3�Һ+¤/$��'�=S1��w5�M5��������..� �Fa�!�*:�(ϧ.}+4�q	�A�U ���6����Bi�[U}
m�l�0���t��d���C�a$-�ܼ�2�\�(C����pj���F�t�4;XQ�H����Q��2[m���B�Hznv>|U�'����(jK��z����؎[�SW�i�d՗��0ڴ~ھ��t��_��0��^��/mɤ�w"��a�w�v||�^���ɪ�k�a|��^Zx�`_E��c��㽂a�(̒�5�!oT���2��UJZ�a�CO5�͒a�0���O�!�-��a��O����يa��^��oX����
��0r�_×���RJ'j���O�NKֲ�!�<T�PW!�@g����Y�>�2��NC�S*!�^&��f����t�Xw(4����T9�~*=^~�atsT��HFS$��K*4���=HX:�I�@L���t�9�6�����"6m�IR�)�F�O���)�ފF�r�V5H�ڈ»���eoF��5�!�Խ*�@V�_5���B��W�9��a$]>�� {��2�N�0������t�e,�œ��Ё�(͏�8"�
�5���)w�����ujI�a(|]��ݾ�H�e�z�a$2�%g�M�kͤay\׽�;} �a ��V��P�»NFBUVÓ*���z��M���r�/����-z�a 7p׃8��@�B��~��I��zQ�@h㪚��6�_�&g��]��7�ٗ-�K��C�ps�_Hf�b�i�(��o���o�?.�f�            x������ � �            x������ � �      �   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      �      x������ � �      �      x�̽ے�6������� I���*eK�]YfUw�l��;� yp	wNΚ�HS�v�
� .��x|���_'3�j'�~���������_����[��/���_ҿ;�j֧�?/ӳ�Dl����~��������������׷�����˟__~������i�>7d6F�d�'�>[�l'�������e�\�\\ q���O #b_^>�5��˧?_��x}�������75�e�s2UL�}�̳�E�3'�>��.��>��Df2O"F�D�c��/n2�G�_�oqN�;�1���<;&�6)��}������>����s���Oo?{�����ۏח����?��l �ŭ�����|��-Y�e�����~���-��!�?�w�&��q�t}��������������/ߞ�����oO�>}z{}������x��+���8g�[af�󼉘03�_z3��Myօ�����E��g�&�9����������׺
d�g����'�/?��<�������/9��o�����e{�K�g�G�,b
>�|��'d �m�z��������&�x�4��?[߮��uV��۷�\<���Ǉ����D��~xB��b���M�w�5Q�����~����D����_O__��_�x��ח�c����'L��M�w�$~��<����5}�O���sl���7��r���	%LXAo�������_���V�ד��l ���ю�q��c�&��q��� Jؼ�l���yz���_o����b���{lU����}u��&bZp�\��3Ƥ�x�\��n����D���c����Yrn<�i�߾����/�O_?;>ԗr�ت����ǥ�D��f^�v�,�Ͽm2�f6�Ob�#b����.N����c��iw�mD'b����O�ag������x����}��5#d��W_�a�9���໮���0�[��iᱭ�>��U���/�+ӆ���|4�1�q��ua���̉��'�EĺG��K�Bij�G���3���4�~����?��v�m�U���ݘ��a���ܙ1�(-��[�K���w�+ɱα�ϟ�|�=�	s�����N�Hc��8��1a	���C{�pʕ6ͅu&弗:\�M5Ƥo|j�x|�4������b�����̄���� �&W�F��1#+����m�6'�+a�EL�/�E2� !yÏ�A^�ᘘ�ʾఈ�~iYI�(ڢ���Q������a��E���_0��?^�|��8�~9�%H�4����tW����+{��Xw o��֫���
|�g}���kx��R/S���lVSY�_O' ����f$�L���(����f� �f5�	��T�7m�=�1�{���﷘�����
�~�>�%����,M�"�Y�7�=�wt��CKA��(�oA%)�#��Ǌ�[	-��qP�����)���|�"b������ ��h�ƞ�*R8T9��pξx�f�"t��&��<��a�16c�:���ȑ���m��cJ?h���b2��#1�D9m�>R	��]�X�~�a�5��螝����CYa���l"��Ǿ|~z����-\��/k�灁��9Y�n�|�����&6����T��4��l��)��+>�E�b>��gvN�|�>cF�pJ,��¡�a�q��N�Y��r4��|Y�1a]1�	�?��߬�%�mLNĄ��$2�'��$�=O��	�_���7�d�8ֱ��1m2�b&+�ц����u�������/ǹ������� ����P���q1H��E�+�z��,Z@�W�т4��nׄ����ِd6�.n��6��=�9���wÈ���>�����c��]�	�18��I&��g[�P'&/�4�^ݝ�{��.�6�Ӽ��)������[.N��T\~Gݿ����ϗ?K��A����|| E��#��͋$�%���xJ�6G�X#��(�Z�	{�mD��d�ʜ�sŊXϮ�Y�g�m�I#�y��X��	S�y��i�3b#&�`�-S�םa�D|��u�Yx����%fM7\l��z?��sܷ�GU)��Xvp��e�o���8'f�?�rL�7��VanTE��QI�P�/�+@a����ݯ�FDq���)QҐ�8C4`�� 8U��
��N�Ⱦ�A�&}1�6�<�p�+�Rw�q����Ĵg�#J[(&�g.�t���F����7r��ْUt�2�'k`�a.{1~3������]�0b���|	9l���e�	�^�	{<I���9y�gy	BS{��Y֗��a]�(��� ��@�X�}��B̅���:�jY��H�R�I!E��}�M����-#���[_����U~b��J��kiï��:n�ê�El�Y4�Ճ�$�+>����t$�C'�J�d����贯�X�ҒYd�	�g\�g�\Ќ	|�_�hƁ$	k��uP���1(�L`��}l'bc	L�����|����:�����E�?�bJ����mLg�7yM'a�p��X���Cd/����r��k,[Chwy���N��e����׺���X \E�O�Ut���=C�Emp�Xׯw��[sGu�cLFw�{^���hc�p_V؉鋗����<�!b��jtbM4��1ZY��a�9Lg��KX�3מ�Sk,�)�(�bF�#f1cG�'�m�����I��rp7EW��]'�wm�]}��%��~���¾�f
_Esʤ��ň�e��v|���,�B�r<G��t����TEh�Ox<9�ĥ�uE7�:-Н��a�
�_w'eU���_�S�>�^�d�r9���m�I'��y�0�sޜp|��T*����_1T��!@�R��'tjR88��$mj����d�\9&�MeW��JH�C
"�>��Q�!g�}�����q��p5Ҏj+Ƙ('��� 0)B�K�g�1��u����i��s2DDW�Cx�DP$� U��y�_�AI����b��E�T�G��\�� u�	&eYr[i�����ţ"���J58m��V�t-���$��ϐ���_�P��)s_�p�jpL�q8�q}��rL�^B��*�ƿcC��y�E'w�lC�wb�L�ѓ�W];�KWv�N��Y��	&�M�q�������H0�����Í#bJ��o�\t��ۨ���}K�q6O���^��/����o�����4�[ł�jio֊�0�/�R���&K8W;�.L�pz'��,l�5~���h�����?{-� �����=��i.�����Ĉ�&��Y���M:�?�o�HY]��I!��[�*	c9��L`�D�rSF
��,�ĺ0�%r���rQ��zS\��x$�#y�Ǹp�?6:)�)_"SL�8�"6T�����@6��|�.���:������OFݟ��e�rfd�5�v*�m���(�˱�|\1B����]e�*p�q���i,H{�������F�X{K��s�	���i��;�%R�L�L���$L��u��;�)�D�C���U\o���Y������X�ٷ���G�c�`2N�\���Ɍ����F�9��&3.KD,5���Ys91͵X�t�:"����1I�E��F�8�C)�c������ܬ�7��ؼ�>�������D��}
��./DͱNDy��F����`tnn�}�vY���R���I9�*��wB�!��V�C�������Z���4�!(�uH1�:�\�YE�~���lou�["�.b���c��b��I�˱Ξ��Xq��*�C|���1U��] ��X�b�ѩ�Q�'��M��X24>����&���k��Y��l��>T��U�F2�;|���4�B�>P�����[uA&*e�1�����W�vr�b�h�Y�>��Mȅg���܇��f�F���2K_�tQ�|c.*�p\<[���\��"�ϙ׾��#'��q�^����!}�-�u�cl.�'"��	q4��Z��1ZH�ދ�1ô��g�~n��i�e1�-Ÿ8u�=u�5�\u�_�b�^޺ǰfn�da�x�e�P2F��2�5e�6��uv�!    �#��+3���E9�
qω�!2p�E��.�D�jC��M���II6ƈs���q���D���ɋ 
p}�چ��	�mE���	B2:fY�y�t�|����[��_�l���cQb�������^
O��pvd�׳�-6������c���en	�.�eڬ�p6L�W!�s\�lo�ؠ�|�]�6ׇq!���W����t�5�ӉoՔ�f֋Kc�%�Ვ�R/�>�|�U<�|����帝����?O���+�p8^�r"�`O�88H А"WP�L�Q�i�"&��~�Ƈ���} ;WG
dU�z��L�m��ۼ�m�E1�BJ�R������n6��c2�4�!��	jbƁ�Z��.L�"աV���n?}N�����'�i�A���j��)D�fC9��뛰$�G�RcD4�A0��λ�����UK��yW���h�]�)wZHrC��1uA͉)Wʆ�u'�۠���V
���SI���)f��&��^��C7M`��o��a��IKd���L|һ�;�İ39+ꁏ�e��s�~$l�h��]�|�t5NDW;[�K�-�F����9Q�"5�-nN�,+b��2�i�Qy�X���sr�������I<#p�c$�$���+��K��ZSC=�摦b�ίI,��c�a���ZQt�"�1=EƏH�I�w-�!f�X#B�B�mF��|�
�çޠ� ��+�trlĎ�jԑ�1U[�ƌ��W��qA�*|�p^�{<a�r���W>F ��i��D�����kCC~�3�p���7tS�7�&��3z?���A�F����o��@�p�@�8��)�>�2ynLC+�~r-T2�K�Ë�;��r�ű�9����_,,�zlEm���\�'�XW6��HOҲ�0~PZ1�|\��{�Hˊ֬9��E|bjQ��y��Q�EU�k9����ءrcv%�QvM��F��u���ߑ�;؈���ӡ"���^�W�k1��U`g�O�){#,��!mE��:�¹��s�+a	�n�V�����{}5�X��\ɗ�^��1[����$L#I��ώ�|$s
�YE�SZrm���Nz�e貆 ���m3�"��n<�1�� ��Պ=�T;ar��c�%���L�o׃e��H�"�{>����������O���xV���*L<�(+�.S&��/Ø��ⶦ� (X ��^o���i�1,s�DL�,�8
���)�y�S�ʰ��v��c��h�Ih��k�c4�J2����5����١���[�OI	�>LJ�P
놟Q��u�KeY��XM�M�RR���ૈ}����3����<�����c���R���4��V�'�]�]�UlHU��J�����ϲ�LlO w4z3���%o0D��t��w��{MCoW�}�ra���X&V�>����ᴥƻ�"��"bJA���b28Q�X���,�٪_�ܷEyC�)�-���	�c����TK��ԣP>��b�$c���h�?Tiұ_�l����"]�֊�Q�;��w��P_�7��UĔ�6Y�m�#&1y@�������(�X!�$�K�d�".L��I��R6�A�/a�lBN���037yȹ�D;~�s������q��*��7g����3DD?=:V��n�A�drE�7Ô��A�\O~2X�|��W�^$eX�9�S!�>�ũ�;�a�&^DL�ܑ�}tk��5&���N�4Z���OR�<��m�f	����W�f&��H�6�Ɔ�ȼ�XO��.��ڑ�b�H,�389���!G��Jr���.5��F�.�CL�T,Иc��1�<t�8�k.��:tN����	oH��m	�Z'b��[g|A5��[�زNK�3���O�m�R81�Z�Ck!z�U��/_�1]cy�����$�P؛a��)����Cl�(yH�B;��
/�q.��=<=�RC�������-�©�aJ	�����5�/LatgXϊ;smYp�u�1�
+��Yk&!R:����ܟ,���8ģ��I�2�!"�x�d#5�^�G�ʒ2��}J�zֺ�͉�j�T���Wd��<��q#��e��]Ĵ��y����"1�Di�oTlѰ;�F�q��g-5��cP��4X/�U���A#0�.b(�QI�Q�9F���j<
q���˰N�΄�x'�	�M턡/�d��٬�ô,'�0�@K����̓o�-���ƕr�b|��KW���W�3:����g��)�<i����,��M_��d�����=n�j�Js�3"ƫ�WK���HL���8�5b[80����	�HZ5����K�1^��@�j]�����#�F�����TluFWUl�r!�I͑��ڟe1�4�X���l	���"�%È�LD�Õ�M��&����:9�J�a����/O�I'j�_������9����g��Nn֮��sd�n��"�;|I���a�"N�a�]p��b��6HJ��rb�p��2.;I�ݫ%�q_�E�)�{/h�Z��@� gY���v��h�Q�x�E����!��T��k�W���ȇ��Ƹ�*;[e���WL���jL�f����8WdUd�8"���"ݛ�N����_��vx��D��T�j��P@�)��\@�����>�D�8;<@a�aD�\��	V�$ֵB�LJ<V���Ǜl)�P�0&�0����0Q���'7������Ɋ�ű�0�J�ɉ���;�6��Gz?��t�:����)bbZ�{/�'��j.s�dEL�\����]Z`�#9è�kd]tǉ�ǲ�g�ڊL��aY
5�2���M���B��+��4������4��P���]!�5/��'��������}LOx�Dn��~�V�j��	J~�1r���>6z��jyj�����y�4���_��������w�M���5^��{kc u	��W(�Ě�e����s�!�;�S�|Y�2�z��QIĔ� dNVRU�T�`�w�*b���X�zZ%�ry�_?�rolYbrr�y�������L�᧞�����¿~��N^W�p�m2�鿁Y���b3f$b]�)d�Ž-8'l���q��u�J�tN���wᠸ�	�*rb�y������2�˹���=G�����߾�\p�!�^��I�R+(��o�z��xsYr�5�A�H{_�%�9����֘�Gkm&f�f1�ɉ�a���^Ev�ЫH�IH��,��91eq�uN1/m�:�q���-��K}�d�V���׈ٍTb���!>_WkE%O�1�0��oV���T	����*נ�O���b.�]`�5}���v�&,���������M��F��.�_C�<t#0q�n1����&ؐ}l�G4x:�J~m�F}���qn��-�����2DBҝ'�ˤ=
*���3i���`�����ʹ�şCL���jt�M��L��%�h:]�`����q��8��u����{T��Ե����t�V��۽�V��b+\G9�&�`�fYF��b+F��_7GX�ª&��T�O����H���ƂKq��]K��A2g'�j�A��t��^L��*�0�أ O���)��q�!�=h����/_)�Ǻ��V�i�~��l��9
�n"��17|�&s!-�a���J��|L�����Yz�����j�i6%V[n7�rH�{��.�!滀H�}��;&79���6⋈I�Un&Ùf��h�7ʯ�*b\{
:GB�-�y��ZF�Z�9���!t�;>BAH��rGsL{|�����k�5�6l�)��s�U�=���O���s[���'����~i�,�����3uL�o/_���׿�^�߳�?�ڧ&�|�r����rb�&��{����UĘ�;������ͨG�>�-Ѥ�̈�'gYDL����@䂜^�(���G��C;��$LTv���R��i��I��-��'�c-}.*�и�4-}:<�E�qL�,�p"v��|z��q:�[ê��3��!$ED���d��Y5/k�Q�j\�i������T�n�"4�n�vq#���v�I�d���E�O���c{i��ܚ�n��f�ܿЊ]����    4���(1���=j0Ϣ�x��KD<���{i�E�:���uVإ��Z�:��+%`���؈�K� �h!�#��n"�����c3���(G�\/�-[��"�s�+�N+y�
�6S�*1U���K��������f���q1i;_��=h�o��1�Ƌ�F3x���R�q�-lc�[��m�1n1����Q�vm,�q"6Ҥ��x�'?�y}vV�|r�0L��J�-��ޣ=%��Ͻ�2:ꅄ�<��01�!��.�
f+bzi9��C�咊*2�'bW���cf��	xU��k�LP��FZ���؅|��"�\�����Խ�`}�A�P�Q��u�+\�;	�T�����CF�H{� ��^Ĕ���f���ݧ�� �Ս�)Ǐ!��{�}�j�,�m��N�1��>	������=ZD&9��(W��-^ĘK����A��8�ø�x����g/�U��S��NF~z����	}��X�|
-#�p��t�����r��|��@NLS!St�r�aP� �K�.THo"��t�%\��i��4����Q�aC5Mx��Q������l��A��<!8u�7�R�o�0e[ҕq��˹-��SK�q��dm�z��O#�fԢ�"���B/r��ڂL[0X�a�(߾f]Ԣ2"�k0����ɦӆ?Gu�pf�V}s1��l��m&�TbL���T73����4�����a���ދ�`O��Ȅ�
"6"�����nmL���6�3镃d����+a,T�&s��3�
�ݳE��^\�H�L�.·�#r��kZ"�xD��8��rʯ���W��b6<ɜ���p���q"��m�����&����%�u�`�y�";o���f�ߓ�:䄼�1j�����a�����hs{�%��V��o��$"����{
�to�R�ֲ�������;�9͢��lEL�sY��"����,\~�gO�VW �u�I�&�	u�B|eɧ�����0YR���B���b^^X��/d42L�[Df���غx0����#�͑�W��DL����ׄ����G�Y���V��cJ��%je���#M���"
�a��S��D�#5O#�ou��DZ�6l�y�.b����rk���mT�t��\�R���|�g�ǃ^��.����`�+�Ɔ��	��	�S7ȭ�:�NS�:��t���,j��!���bh�xe���R��2��(8<�r�g(��%���h����Gzk ź��u-֚B�y��(��i=����2
�&��ω�h[f6�6������%_?��}���5ݐ`˘�]�������ϳ6���.�Xb*��3h��گ)ư�Dc�M��0)��ޒpA�'���9�b�8�ָJ�'cP���=�vY։S��
��98~S�s̼t�(m�1aRԵ��&S=�[��p"F^4!���C����=�a��p��,�PecNn�vg�7DN�=��Ǒ$�)|MQ]��n�^V'�asw
`�m����6ǒ�`�1�.q���B+��3a��}���k���+<�9v��"��)�}�p���g��g���$�#�V����y���˱z�z����/o�L����+�0'7��`^>}>.�T������ϧ���g����<���!f�=4?4C�=��B�d�/1���a�~y}�����'�૧��^B�g�Z�c\Ղ(���]#��_�n����4��g�3j]��;����tV+V��/jR�ګf����hS���E`gu'�)���X�Z��0��4�U�3�|�̱��k�q�e�na��r�96V���A�ڑ~�?��:��sz�p}&c�3O��tK'u/�ww�4;9��G3*����jF8�x�_;d���'��-1�q˹��1"�Y6*6�M�(O#��EW�����>������-Y��(̖��21M���	���7�g�&�,a��b��e#]E����xq:t���|�����q-��%:-�V���{�hD�6�G	����������v|�[�x��^mƉ�Ɵ~�҆���$i:����c��l�C�
0�"b�b!!FUIx��1Dl���|�С#��i:]�oּ�Of�y##C��vnBP��k�G�~&R�PܤH����NLc�ޓ�qL

�6����(1ǩ���G�?�^}�ZoV���gG��H,a�ި}��A�J��3j�o�1e�J���H����"ƫ)UT昴"�8�" ḵȔxJ�8פ(.��G8�6ἐ��R�x�\
���I���M�F����,�YCie�F��JD��PQg|9�j�ћy�t/_��E�J��2U9�}W��fa}&?o��$j�J+E��kT�gt昪a.�Ad����<;�>��f�% j)�˖�S����Hk&���M�0fm�'l�KԮt+�nSt�J<�)W_�1�1O���&��i��\~!Ǵi�$��V�Z\�)���9֋8^:hpZ�Eq���u��
�%6'H�BZ)��g547�b�V�a�Y7�=��"�_7������\�\��EL/�	����6�^w�̪���R���l��r��dD�M�IC�o�2�	+b�-�"��e����pQb��7�F�'�X0�]s)��V�������f:k�sz\ޣ��ۏ�/�����K�S_q6v#�^Սc*ꌈilR�a'�s���Ę���63jm3D���F�E�O#��&������߱bT��5O��i��؀���6U�1��#�2�<��Ntm\��Di�\���	"&��f�q�p�E�j9_Wlȥ��*r]1��1�Qq���lI7�;�z�y�y�)�K-)��8BR� M\".O�1�����$�~G��~�q��4���*��Ĵ�$Ķb�W�����EL_����z.��mԞ��D�{�n$����SF�P�(�5��1�Bi-�(�%{<ƫ%1�O=�c���!A���7[�k��)�p|���a�NW��|�螀eStYE:�T�P;HGF�T����ʵ��7�dPb����up����Bv����=�jiv�5f�rEJ:Z-
.�L�˂Mj�ƨ9��I���<�p��Z��m����X7��a�9>D���~W���"Y76�,D��d��@Ɠ�#��s]�c�~�]����'/ٙS�Ȱ�8$IW��ڽ��O  �46���"s��̰Db��̭Y�~?f�F���x�о�| q��RVĸ}w��m��mX[l3L]���Ͱ��;��-�� ����P����?`Y2r���x��B(ǔ:�$@@t+�����ˉ��qJ���͆��ޒ�7c�p[�����xY��!Q�,��7
d��>({��K>9���*�c�2O�NX����k�ͥ-Q�����S��2;�֚~>�y�wK�.Ke��wG� �x|���pm�t{-��G��F�TD�K���21vc-��;��F��(a����w��)|����B������}���p���a��\�j��nJL�n�ݤ��{�x�z8� ����/���a��N�H6x���0]q'���ܢ̇1�����e���]��'fS�2�xI�t����z��(��FJp��"�9Ø5�2ю�ɱ(��M�pP��g����`�,�U	���f���T�E'����j:<��qcp�m�����sF�F4����6/��1Uy���댶ն�r�RC�=Z�6\��	}����`/�x���16���(=��CL$�^�Da�B&�}����Q{�.r�	1�"F���䕶�<�W�:��.�n楺��AP��"����7�����tΕV���
!r��	5�j���5�Gl����@��O��`W���paJR�냐2X~�Z0&�;s�n���ǉ���	Kh7n����\�!�f��� *����_Kcv�����+�D|1�yC�֋1�C�\�����m���&bL����a�~�C������3�f-~�4d1�1z1q)Ҹomw���%F��Lg�k�'��y���7�Q7�Wm#�M���H�ъ�	7��T���&���N�+�V[C��8~���a���
�2.����C6�h��y���7[�:fDXX�����1V\�[    ���]��������=+�D%4�1�e�^g��4����鞂]bR�-6Ml%�Ozߜ&6���&b,�0������X���^�C\vo�ǟ��8)��m�/5��)�.���-dIas�ncy��X�࿿?��tȩ��L�� 绖��/���rs�7�)^�k��nQ��"�&F�䅒G�.�{j|�uVKNg�&��5ANS�Ƭ|#bڲ�W�;dB�1y$ ̉Y���X7�Sweh�����X0�0�"�HfN���'�Ec-t2L[��UC"��]��'a�nX�8ґ����o��eq}k��q��kiV��`N)�lN-ˑ�{p��R��my|L��lw��U�eRt���m��b��	1Ǩ�1���Ɉ�H�ќc1�,bL� ���Pn�(�>x�l~�o���,�g�h�u�N/�
%��4�I�+"��&�<�)/��&�69Ӛv9��Y8s�s��T6�N �C��M4���{?�Sg�2�i6q�Y �7�y�0*0kz��a��孎��Po�[B�<Y$��8Ib��]EL+�.�}"_K��;���'�5�[�Y�kFz���j%�ܱl|"یE���tb#-I�1s����"�H�mI�eD,���;��_�FL����I��#�&��j���AjT$T5E:I�k�"�&��hVsR[q3HEn��|&���t�y NĴAv�=:�~�v>js{EL��͸����%������c\���ؽ�)k%���2u�.�6v�\!w��qL�uӆ��;%�#�Mdͤ��<6椔!�Ӛ�� ����m����8������G��Z��[�g��Å��	l|�<�y}�2Qv\�������\S�b`��Xg	�7���;2h�MHk���Ӕj���T���ɛ���!]�V���J��Wy�n(�ĉ�^��q!��CY�Xc��2�ڝ�SgD(T��z����Իe|�̉�M��l�2�YĴ�s���Ƙ��iHY<A��2u
Ѕ�.`����'HE
��5M8cw��w�a(�z���I�t3l	W$vd��fȒr1|3�5G1Zb��i��	O����>�dm��wa_Q��ȴ��ʲ�=�Ol �bű�}�3����  4�3sw֒��si�ƅ/2�+8a�K>3X�ʮ�`kV����*bʬ��}���R;S�p��{|#bZ�x\O"1Z�A��@U;	�0���x[L�/_2��j�x��~m}����EL�Ta��"�^���쭟�����]�҂E��fz���y�a��^�b[���-�)���:\E2�����pbv),Av��~���T�lf#��ēS��f����\�ň���ɝK���wL��ba��^�]b��)0%7�h���3�l��a��f�{�M��/�0��.�Ӿ�&�]� }�	��bI_��9��&b4�����m�;��j�͊�ΥO6Æ"�����҄Z,�@������5�F�%�uH/߆7NsҦ�U�j91���B�#H�l��:����CPXM*��}S��[��8�
=��R��<1�u���%�xNJ��jrX�(���1�lDL��ȩ��y�Dz�<l�`q��@	"?���Wb,��aOÊM�MX�!�u1����ɱ�J��+Z���9�����e���5�����b��ZQ]c-�L��.� Jc~��S�ZX�[n�@Q1��{��.	�r��/7�Tl���M�0ut����_Q��2�Y�̜<�v�A�0m�$�2(�����ĔQ�U+���^	��Ā�����Pg�P.X7���id�DL��ѐ�d�D?�����̪v����{��0�c�n��9V)Ě�|��yrbD���ÙШ����za<���&稍!%�"b��AoݩTZ7@S�ܡA� *ꢨ4�/72l 3���b%s�����b�E�7���zU���&՚n!02�7Ǻ�3�H��S1D@ۦ�PYb�tKKi���w^�4e��۞�]B�����zI_�@�=�7���F��,��0e�*�bH���o
���2L���_�n�UB>��=�vS_�	�
��� w�`LsQ��aJ��	�D������8�"���2l�	��j �t`v�*��o�VӔ=�������A��z68�����VԗGS2���,�0>�b��U.T���}
�Eg�H:�"��/!Æ�lg;�5F�#\���=JR�곫{C⨇yG��T����
�,ds�Z�����wn���.���ϳ�2L���~ݤ��Z�%�����w��*O���Xe-�g���o��/SA	cmPf|LZ�ˌΌ�\ȕ�D6�c1È' �j`|س����P0�"�X�	�;C�g����;�3L�Ł�X�#i�z;��Ams��&�/&��e.Z�fX��(>��k�1R���8R݁�ʠ��cd�z��Qn�T��s�)�7p
4;k	qx��neݍ����jƬ�oTW�FSנ[�)�a�!����?�^1��"$>I��kQkj	��/��Y�i�i4[��2L�v���[�����5ak������������=��yD�!���^s�U������41I�0>�^?4�@�'#)F�Q�G��VvokQ�ۮ"����O�=\�"���!L�x#�Ϛ��~���S�N��m=�"{�X6���-}a�<�?�����F��6�0����1t"��(naE�cOCW	ϡE^4M������"�f���p��������7�l�&�H���qQ�f�=Y�$VVpUn�=֋���3Ô%�sq~uT7�|s��	�6X�@(9�SP�v�6^��cR�xk;,�F�"���9iQSE�)u�Eu���Ɯ-��p�P�	c��s��Xfg|M_������p�v㷴�
���WaJ�����Ǭ��t�:i2����1�:K4�Z����M�i����E���-:䂻�>hƨ�S�_��}�]藆'�)��[jC3a�|���&��i0���耛�c��3��>/��E\�^��:���8l{�(�eEl@,����ŵD��9aZ!,
ለ\�kH����\�C�*1P:�H�F�V��.Lt�	s31��h����zi_	�=��Zq�&!�l�E�"��������#,�O(�&.<L�M�>���(p;�p�ʞ��9첤^�g�z�}�B�[��|�7�G���ߕģ\sDLUa˒�r�6����5�gJ�X: ��,J�l�yI�>�VIJ�VDI=�pZQ{�6Pf����!�Pt����X�X
�u36�2L�3n�8�C���>����g��-D�dY���\����X�F�ɔ���[bN���a���|�j�!.��P� �EK��0"�ڻ�0�
�(�mÏ��[�C,Ô?RC��Tb�l5/'�OCn�uҦݥ��⹒a#iw8X�Vu�T�xZ�z��y'Z�ʴ�k�Y�>����9\��,��H���g�����m�)��)P�
���G�q���F��\�@J�h4GO↨<ا�֙��n3Eͦ�٭"�m�����LC�,��Ӑ��v��C`d�'b����Igs�k�,J��,%��Hv�*�PQ �V�@·�U´Z=�,c��iw+\)6�sJ�F��k��Ҿ�dC�q��J\%���'ˈؠ��B�n��lf;EEL'b#���m�U��lq��'˕��y⸮�_��b2�6�7l�x��>F�#EF�������e+2~2L�>^���F_D��WqQ7
�����0��F��Z�.�[6�0�|0�R��
�nE�;ô7Ն�fVN^?k�X��DLeH\9���E�|���ȡ�ܱ[t�����V5'*{�˰Ǫ��*i�^��[ǡ�>��奋���Aw�Z�Q�>Ѓ��#)w��G�	{a�Sп푆����$��ښ�>K��M��mJ���F�M�{j��-��q�T;Mx�:�&���^�h�|[���Z�u�Ze�G�)U[��r#u�[K%�/fk�������"r�a�FpD�a���C>VX��u�I`X&�.B������O7dv���x�%G�F���lѦ$�F��:r*#3h��R�9u��D���a�Bb����'0��K)��aC&Y    �|o9]�r��9d���y�-@����f�X{��a�n�Oj�����93���U�#�[��|tz����<��S��3|:���i{W�h7cq���X$vzJr���!�zRw����^<��Ha���rx�8S�d>�������k�|�*^�9�56/\��;+��IY�dn.�L�:��S&<��P�׺���>��wr���(���!2X�J�B~������פ��Avb��n�܎�CU��%T�N{mԜ�"Bq�)Hx"(�
��+bℨF'�v�i��U/bC�+���EW�ݡ3T��ɐ@c�
T�0ôn����u��Cĺ�B_�\Hђ4/[�_�aJ�ǆ�NԄ�r��n�D�D{��F|������<�k�S~y1e�<�DD*:�%�s�q#o��<OU�։�V�k
D.��7e��_Ln�s��4"�}��dm�wL��	��"�a�V�)E���P�_�3�=�qph��5D)աё���J��P�@�#�n�����j6�
y&"M�C��2(;u�v�T����n��y�ڀz~��l�-��ٔ�a.©��*dta������gr7���|���ꇬ��E��c�e��g��G�/�}ə*�>_8�����z��&�^߈܀�(�l��髮T��!��.tmq��i��q�r�"Ob�DL?AJR�#�x�
%�+8�8d�&��J��B��jH�w�\Yc:�-d�2���õN�Q�q�*� Ø!�3��A28S�]����fa4/b�?>���ӧ��ߟ*.�o�9�}V�h�����=/���h �׾�QMW9/°k�E3�{��`b��;ˁq��^��s��<��4цF�����L$c�R��o�t^DlP0h��y[q���01˭Cr�ͱ�6Rx	>�S���J��[䢨��=�H��=^Ń[:��F%jK�.��gWd�������<���R.
4rn�āv�]n�P�cmp��5��e��*�hC�\1_DJ����������S)�h}Q�aJ�҄�Eg�Ф�t��xT���N,_C/�����$�㼠�h�Է��r��S3>$N�|>��1m�ol��ȐmarB���X	S�f쉋� dI��k�>�z^����\�v�}���7EQj�1��;�H�����Z�"ܘa������h4~11�%@J��D�3��	s�יlC^��*���L[yX#ôI��.C��Xi\[�@2L[�Ĺ��!&(����oks�圌Ƨסp�m����o/��J;�DJ_����C5:ɑ��0Z�8̰���"Ĥ�7|%�k�1��jt�~��B�%ÔY�
(ʗ��"�ahwj��a�\:
�j" ���$=G8�ŋ�6�a�v�����ƻ0u[Le�1���Öz���C�l�-"���7a\_��f��+��1�+q��+b��
Y���5���_S�����:x�X��Aya��\�Q�^hU$M�/2�2L<K�	 M��(goť�<D�������ޗ�R;�ҧ�_�:�I����C��XƵ8u������?�K�c� os~�1��
�GIF��-t��1��kp��J�abo��{�}�u+i)���ߣ�Mٽ׃2*����Xd��ZQ�kl�"+���D�� ��]z䁎L��V��)6�����RNQ��(�1�����ċ����Ԍ���q.Wt�1�Qx�:�X��lU,�6`�N�c$�N�_�T��ǟ³n�D�#zGq�W�
M~����E���If#�'f���<����!"����HV!�����4���"�d�P�dvx�6����5�9�-b�p���Yo0�Gh�>և�#F���XlQ�af&;�ܽI�	c͕{��b�D�%�����<E%)��r�g��Hm����R|d����ź�3�H�x���},?�#�0�w�2��ӕ+ɉ�i�1hֽdM9����:v1廑�2��Tl9�C�@���5�{�4��`��{�4�B�l���EE�M�H��p��5�r�H�L�q��/#G�a��B]e�<���I���"�}`��hJ��C{�P�y�_�ļǮWbN	�d�ֳ�bM����*ğ8��-��D�/��8�,!����gÉ�t1�:T���N�æ���Q8N՛�G��(���)�����ң!23�Qo�=��Fɩ���	,�������Z�#,�=�B�����ӳ	C�������)>�U��u����N|z6���0�vs��x
q�3�U\	��ۊ��ӓ:��Zr�!yayϦ�B�a�м�$��
�2m;��MAcJ�X/K�����QHg�2Q{{2A��`�a��+����a>D�:̻4�g4�>
���<i}�ў!"yO��!5�'=)X�\0�Ԟt�Y`|e����	���TU��rnѐ6�>�4�9ɞE�}KϘbe�V�pYpEg���uE�A�ut$��P�~�G��YV,��T�
��"h>R�&|^��I��w�#��L2�����v1�8�#�n�1��:wS!\fS|bq�`&�j�!#Ao�hl�y��mlʅб��,	>Qֳz��1�F�_	�ϊ�}o3�]l�>���Yp:e-�:[P5���Vt�5n5)��Q��������R�}t��P�pf�c<���^o%)��
e���e��*`"�W�	�T�m�2:D4ʹ*6�x���hm�a�v$X�{m+��&�h3�@�J}�b.C	��+=��`��@R�ݐl�]�cZRY�/&E�?�@�l��aʠ�D�&H����]l��0m�(%����k�A�%�Q�0�|�O
^с��v������yz���s��n��5�^������A��j";�2U�Ew-��3L�e�r"I
�ډi�lt��&F�dU������%���O���cw^l[OF�b$uo%��6��}6NĴeJ�����mܹ�G�0}i�]�Z�oN�P�\<�2�����ѸT�"�0�
��,������=�.�2m�r���p��e��*Z�2�3��V�Y�+js3Lq�~�f
y77�)�����q�g;=ǈ����'�WyW;��J c,I/N�[��C��R!��]U�����3+�1�x�A ���~%�54��/7'������rLs��P�;%0��쌪M���F�϶��-�xl�f�B!n�y������
D��EB��1^�����lU��cA}Qg�c1�r�M�"����9�`t���Qي��Ų�~_�i��b�]�a�:x�qs���V�0.ڇ�mܭ�Y�0�#CD|K&t��?R´�=�"�7��C�H����0�`nn�(zS�m&%b����敼�7켴ϓ�)��K���s�	?���2	�"b��tmq��uPQ5z��@�gF��Gn󬌡���ޟ���7�C�axi���Dݘ]3��Y���g�;�Z�3��2a\�;m��4�\�xO���X��q��1nD��|1C��3ma��sM a�9����eՒ�7�ƪ?M�>�h���������â�V�oBQ��:S����'�(&	�,H�"����\���Y�T���頝�)��zDd���7l��N��m��p^�S�e3P�����(�7�Q`y��;�z'^�և�C�iu�XG��Q A��^��j�wSJV������3�@�υ1g��a��l��W�@*%#�h�"��
.s .�	~y\�)[k^#9h��� w���آ��
+�+#���j�*�s�b#ˆܓ�I�z�-��i;v�h:^��@GBLn���v�FA��8��ب����)
����=1�~*?��A��u^nR��� J/�|v��9�]���B�N�?��zO�U�>~s.�����S����VW��x�4����z`i�H�����ZF�4���Zq�p����c�bxͦ�Y�+.�r:;:�:���q;�>⟯���������qY��P�C:k��d�݄��\�u��p 	"�ߵd�d�1DF]��r�	!���U����l�]h���
�>�,b�TApV������	v!��i���M�k1���Jﱏq���m�{s]z�'��I�4�J���K?�c���u��f7Q�Y�Q�{    M2t��(���J4�c����Pa/����с���n,�Ds��a�I��	Br��8);I���v-d3�^�v��\��"�*�4����ʎ�	�Ǚv�$L�{f���j��ҸKU qam��Q�%ۆHȒm����:hF�#(at�h	���eѭF���޼	{D��R��f�.�s_��(.�06K�9;���x����[p
���g�N�" ��X�9Xa�_t��0� �Z,�81W��/{U�ua��X8>�5�����l"��c��;	�5�U� 'b��N���b�xkqBn��!S'��&O�-yb��wȻ�f�H��&v+��(�	�ߕ���/�B�"��z_���F��4#�}S�$��1��M���M�6n�F��O{4����c!��k�Z3���e�0�"0�,�U����^Ĕ�ʅ��t�*e$�¸�J	�����]����^7�h��97�s���{h�VN�*+:
��o��A����O������!�u����>�Vh�0��}�ޛ��zCKX 8�5$���w�߶Q�sU�o�ik3`|/rQ��u����8���`�:aD��E��q�x�T��Br�M=)۳-��s����&oa|U�Wgt]�7��H���XYn� �d�Ԗ�<E�U���X�������6~����!%9�9ƅ~�H�k&�?X��1m�NF�&������d̝K���������H@;��~��C�T�-��d-�Jl@� ��F:��p	k��8޸��w(b�7�cf�.C�i��.��$��e�W����g�K�{K���BG��)��0mi�ެ��ԥ}OF��}�Qk:	�&�.!g�U}�'��o;�>x��DL���9h]���[ݡH�2����X���ީ���-(��i�d5���v���)��{QI�i���4�92Y��Y�$lHMZEL�d�J�v˧��s�.om>�����LTh���n)<Q9������lCYm�
��cL���|��vM��cu>���韰!�}\��@3b���2�0����/M�r!>��u̉���_��}��	�`���0�9��I�K��6ed�MC���vg*l����ޱy:~�)K�9��z&t�({&@	�����$Tf�|Wnd���Au|1�c�0&6����bHi�B1e���c�L&	�i&>�2t�)��M52���u�z��z`wFוE�܃K�c�I�q�G��]�"T��"F�hֆ	�q��2�ٛˇL�zY���2H�^~�����!2h�9��������İ&~��3m���jF��qx�q�\B4,k�Y�E��RS�z�S����HF�-:T�ۂ	������`E�#��2�8��)��g9�n�e�#M7��1G�7����%9�yp���@M�1"��KhĮxr�Iy�]�弉�7��4�*�h���������R�����c#=A�{�Ʌ�uJk��-���<�m����\��G
=�.
�-���Cz.�L9�<V6�d
k�+b�c��`" �s�u���Da�9��Ǥ+���PQ1�L�e}�v���Y��c�Y���r�^#�"�s�ћl�rk���.b�x�n���1ѽ*�OD��_�T��w��e{D.;��D�GD���G�b`S���0�n�@�(�Nѡ�u	�P��%��#��X���p,޹W��qF,k~���u�5ғFQ��{E<*v��a�T���$��1h���R(*��<��ĘMۦ��ai4��Wq�=t��UW`g�^�i���N�> ����_�����q� �v'�ʶ�2����)�/��$A��5J.ro'Sh�t��R	"���
c�t�8����B%;ôe�D.���Q�W�t��;<��0�ޫ�O�М��^±�Ӛ�$�c��b�3uI����:*}sp�y�e���=fj[h��N�A��8�A���!,4�G?4��ܬ��_�c�<�.�-���V�t��ZW�z�ͻx�ʻ�)�c��s"t��|u.��i=�scZ`�s�����xl䠘*&!�`+�7&5y�	_X�h!�����|�<��T?���#k4Ԃ�̫�>�Bjt�A�1�?�&�E������ب���H�v�I�v\�T2ǔ~_�oǘ�l���5��ٔ9�N�NE_s��Fם�x_�x�0�b�&I���y�DL�{� 	�Z�.����9�#,�kA�����x��]�B�sп5"�خ��8�nE죻&��<T5�}�a��B�[7���Oo?������QE��mbDLfYHOa��cUC�[��T��{H��]�v�P�J����e*��2l������/b��C�L$�Tn���l�Wx�i]Z~N0g��ά�<L���G�E����P�w����/_���BdC��wG�BcҠ�DLY�N�Y0�0�DU���!:���s�)I�Uc�o�A<~&��%�u�Cx�졕m>Ͱn�v�&��f����  �� ��Ъ�@��X�f�[���Y(=�HT���a�ꂀy�g�*�[��%9F�4�M��,���bޜP�<���Y}b�ò����߬�L�,��	1P{�^6:��c&eW3��i���2��C�Cyht]�yV�������n��Vʂ�<+���5���<V{�Ap�J�Ҭ��R��-McV�����n�1�ȉ�	A��&S�*k��c�L�U�J�ȃ�*�ل������� e3��☿��	�	L�l���7�c#�2[��`���e����8�*z�]��<v���j&k���EL����N@��jmt����!�)���y�
6�ᣝ[��B�-N���ܗ�a�0|7�F�s�y�,R��,xi�� VknܓA�b�U�s�TJ�ξqx�o�6�1e���ry�%���9�6��ꇯ]��T���\��,�V1�=5�S���J��hs��pW��I�"ָ�;d
�M��G��XG�� ���)��<�I��b/�uQ����_Rq�qML�:�8��ټ-l�)��oVYc�a���z<�l�yt�A�����t��̵�2L]��p�n�~@Ŋ��ʇ�p٤ot�ٛ��rL=+��t����@"�E�R�'9��ψ�R�E��D�B�T�@����?Ģ��� B���JpD/��C�����W��@�DI�6�C�L+i��xa�(|6��3���I�]�&<��s��#-���s�"�MZoHF�%�L0f���1�
Нc��v�~Y��4�s�\�?���wa�@m�HC��+e��J3-���My��n�,n�c��d:R�o�ૈi�F��!Gg��9昺Еy��NzFEYNJj�F�&-�=���]��;!�o!p��Q�'"�A���9h�Ӛc�z'���H�x����yφ����E�F������ؕ�r&�]!K����Y�)�cVφ2~,.� l6���!.HI��uj��Q����Xk"E7cW��U��ɳ<oE�*ô�L�xƮ�b�+f�<�+m��#�H��d?�1x�]��؍�LؚEt�W�cAE攇����uAE���X���s�����U���@���h�h�g��$ɱZHZ?1�U�˕��|�?n1mn���X�g�����0���&Gaڳ֊{��;kRUK nݹ��'���b�7ܤjht���P9�1W{����9��j����0�kՊ���$Sw]HE���!�	�h�Q�Gi�5'9�~��-on3i�Zv1B�
/E���E�� ��C�k�Z�C����Oj�Qd�3r�����[�(��������A�d-w ������y�I��W`��c�}#b����7��~_�{-��23h8�Ew_��A���KN,H�߶�t�;�Dvjj1[�ۏ�/'��^�_��D�/�/�l?m�|�aS.�|h"w#�^�"�L����-�L�o��i����+�����x�������NG���To�B���&b��n�5��1Q�{00�;O��L�?[_���n��c��s�U4�Ӑ]�c4����I�|�-�GD:n"    �l�j�Χ�[�Sw���d��@e1]V
#��ȥc�����#�mi�ꚃх���ѯ�A*Yۈ����j=ǔ�	�73��
�����W���B@�s�d��� W�@���R���Ll���~=��㴌��"&l�k(pgC�(�,>W��C,ϋ1�,����� ���_D�#
˪��N���س��e��R4^�&��8T9�-z����V�X4��b�+�-	���i#�.T�R���f9�4ځ&1q"�� �Q�@���P�xM�D�J_����U}2�y��&,���r���1VVs��VM-�̻".�aJ��҆M��������� ��D����RF�F�_���3u��a���5F�����U�����ONĴ�rć�a��2��X �m�eS������-=�6V�T>&�ð�w�>O/b̖
�>Ε}{:�+�����L4�>�$/bL���(lt�
�?�\�>H��0ad��e�/���?��>Wg�1�r��~��1�ŀ��TG4�֡�{�^pb��o�G0��&~3*��!#�UgaD�#���@��@������Iwҹ_�	��`�L"�N���G�2W�<|���Xv�4Z�y2�S���d�X|� &N�t��ǆտ+wd�����c�)���S;��%���y�~�)}�8�55�v�(���j�z��҅�7\9����Ǎ�}^�p�+���w��}��.G��eӗl{��<$�c�Ez�W"� �(�Ȩ����!�J�����X9��W�pN�������=�Cٿ�6�*b�����ػN��[
e���r�d�<�$�
�Qg镂OZc��)���*b�%��ʸ\����AVJH� ����FeL���=<�L�Z��rTd��cz��zRtVA���
�p�-IS?Xh�hM�a,�����6`t+b�G)ၤ�7�:�d��I�)��n�e1��g�{CLtW��JӶ��,=�,��R�*�
#b�W�m^}l^�R؋��5�t	�kT�pO�:E4�'����aج���ȩ4aYN@b1�����ha�y8	p&z��-�qO�J\��{�X�%�n�@�,W����*$�Z�d�&����*���v	�	Wo�!r�m�m2�������I�c����b#ˈ�ܭ�O*.'Y�uIphQ��R�i+^'xvX(_>�D��c<ԑ����ELI��GI�0���2�|�[�4:2é\E�a��C/��G��w^ ��l!���NW �p̅U/�����<��i�ų���b�Z�=�~�z�~�8g�p�n���L�jnua����<`yS��I7�ѥ�`��m8p�|#bL�y�uz���0�A<xmev*�]ELY=�LF*���4�1U�<�1�䰪�������.�Xf=��ѕ;6��Ё��q��6���x��]!$(B��BYר^�t�,�c��P��@sE�\�a@&�#{07m��VX�����+&�1y�A��%k��=�f���Ӣ�����e�f������2L����:��*��u1ݻ���d�a���L"ƭ��
K�C�1"�)�<@�h�VI;9lĭ9�3m�Y��azX#n�3a��a��	]6}��&�^�C�M�ܚGLJ�Dr���csa��z�u��}�Y�T{��H�]��3�9�-	M�T��W84�����:����C�4�z���ۨ	��i]�!?���9�	QS�	������Є��.�6B1�L�i1��	�����օ�	S9�I
�!���|�(�;o��v��[�X�j4p_�іI2*��Z�Yó%W��0ez�)�8{a��*���ر�B*r���96 ����0�r��2��Y�#�q	u�B�"ô�i���hEo�۔� ��C<�r	�\H��	��75;��Cv濎���ǧ���ܛ7Ӷa^{�c���z<��y�}R�
���}mR���~6"����g��N�k\+bj'�!x����fF�Z��&�|	�H�&�QyI;lt/����Z1	��ә-4� �CD4fK��� �Y��.#��E�g}�Q�M����:�]46�n�r�6
=�Q �X�a�6|���ގƜs_��D���k@+b:���P��wx<(��"!�ȫ[<ڐ�V�d���$�R�/�1*j�#:+��"2x�f���]���˚�y�1��.�x�>�9b��?1�G"D�ErM�p�ܸ�1���U�7�J���T��El �
�����l"�ζB<f�ж�mAfpYELR$�]P�����t�/.3�_�����!.��<6'@�{�ǃ�Y��'�O�Ycc��I�ߋ����n�p����}�!��}D��U�t;�h�2����&,qzk+ DǇ�(�'�j��!�h�Ht'BV��~n,L�ELa�c]x�%-�Hh3�!G�΄�����~���۰��R�CE�'D��m�.*�S�
s}Co��p"*���G�~��NJM��٫פ`~_E���keI+�څ��R��/�'��	��e󁆘��1c�����:F���d.��ao]W��@��)��q.��*m��n{�M�@�}�oA$��'�a����ַ������PlHٟ6��xN�yh�����DWX�yL�:'8=�}��yb9�3�$,�pQ��:\ԣR7�����5/쏟��Fv����D���þ�ڪ�M���8o���n�pSk'b���@*�cd♐�!=%�����iL�p����5�/b���T��:De�x���Z	a~6F�A޶��k�0��߮�3Ⰹ�*���0�>�D�琽���ܻ���7��w����xh��{<�EBb����6�ɾM�3L�O������Dx�X2���l:`e�Jݲ+'�B���8��<	"���N���2�x0���Ռ0w�Ѧ�'o�\x�2l �>��>�t�U:}��\m� �^�RA�8�D��W�I���\�"�ͨ��`�.ؗ�nDLW��y�6����M�F�N:|�{��>�i�Z�6y�ba��qÖ9P�ΰ���ԥD��Ʃ��"bz�Y�]������ {��Ll]!�aD�~�g��^�TI�)��L��gd'�c�-e��5�1��L�k��X)fs+1�r��*
4T���zC�◘��Om.���؀�7�e&��5FF� �4�q6C���%�W�Q�a<I>+�cL�/r�C[�Gh�O�1cO�>���U��܎�1e�ҝ"�C�K�F���Ǿ)塒�1�e�"�����p��y�w�h��0��C�H\�J��Fꗙ3���������yi\K�*eȱz��5̼����V��Xpss��hk�^ĺU��`-lD�7 ���C̖�?�)O��1� -N��ؖLjQɄ����C<�n�>�io�|q{�{��Y�:�F�<`��!&#/�cI�Y�v{��܊#&�z!�L`��cI��]t$T�^O����Cw�G2"�s��^����@sF�X����{�nEL���y�
�:<)��E(!��wTJ���VҀ�Ƙ�4�idrB��J��´J���瀉1����g�Mj�a�\�"��Z4Ptց�Q�Y����eGMc�t�u�j�{H����6�̀�"��A*݂������!%-�������_��,�h]��fqM���j,1ڵ������'�Q�2�KN�C>Rg��,b��;���L���U��Â�'7�q�ݡb�~|c!Ğ��*b�'�a��8CT�EO���H�G�"�~��Dh�����6�����k�w6NE tvS~7Bđ������F�,=A8x���	B$��"I��.+x�l�םc]g�U�C�a�"�+�"D&#j�+���U���~��#֡�`�h�������z�f�p[�i�8�Q�m'�+�2L�Ima�u������=;<䜪yt5���2�"��I�:�����x�1�J�C~����..+v{j؄�`+���0N>�z�V�ب�󱸪�$��� ),��496Tl�<r�����x�A����5��8��	撦���    �0e�4������;�a�,b�v�Ԡ�I���7�>��0���L�[L�A#Ǵ���2yu�E��ӽ�a}a�Ys&�����:	"�(B$�����U���������g��3Ą���<L�Q=v��<�:�?v�ab�L���j�H[�z�X�!%L�vM��޷����%��u����šcL�+&�X�!�����+� �����6;�$�z$֗5�KA'.m[���e�m�q#�I��_�}����3ÔE��F_����o�� ��!���1�3mڼ�[�e�5�N��E��ίtɈ�./�Dr�ؚ�c�^�X���b��F�DL�D	�'�7�|p]��9�ao���g�s�Ȩ���:n��A-i�j,��Cn}v�9/bw��˧��I�^��<.��>�����'�u�l��؜���E�<��k�'���2�Ɗ'':�2����˃�<��A�UL��uR��"�o��QԄb�0�c�<�JB�k�bו!��ꚋ�Z���&bھ�8�d`p1�EL�]M"b��㉈���n�Py4y�7��nG�m�q:+�`W��rq��F
 �ELu+dj�,�]��5|�&$�c@��E<^���5j-;�0x�\<_���]|�3ቓ��@�u�0��ũ��H�C�$�}:/t�*>-"���<z^ %)�t>D�.�l���M�w�W<��&�׎a~z��fht��e~z|Ǵ���>�q�1H��zؗj��6-�y���do�Z���l�{ae-��o��,|���v�zR/51���8ō�#�[���'��z���Y�:��z�2��A�a�{�6C��Y��f{��xv��2�zD��vй7!��qR�I�6R����Y]�L�����D��������0�3�Th.�.�i�MĴ�`�cǎ�F[=���e7���Nm��Ja��@���
�8�G��b��r�m�X�F��}���Y�h�4s���9���ʼ�1�o�H7�x'cI!vHVi�[���m�J��u7�ؼ�[���������k�K���F�CH������[;ݍm��"Ky9.���bh�~S��$��Hl"�Ω��1��Ԭ��7M���,�{��]���yhڝ�x<��\��8�S5�5��i1V�9�I(�?4��H���4���x��,#F��$�}�q~aZ{q�YRNٕ��Dg/b�Ll��c0�S�i;O:�"�=[�Q��i��c%U�M��t��j�S7�Za�>�Ѧm3*�GBdÒ���+/L=+�Ŷ�*�1*�Y!6��9����$���OL��G)�z����n�IFl�#�$b��+n`����Ua>Bc#/�F5!���&b�,|Ո�����:iA⽚��,ra�X�,b\�zD&�3qht�v.�%�M6�	F�2��.�a��>--���f�`����F� dDrL�U�J��C��J*:<L�%��2�a�U�N�9KV���˗�v��%��Du+�5�o^�����m(��(%�)u���E(��ǳP��3⾄�^\���L����J/`��j. �:o.a�f��-�YPe^�ފ|�g��$�܈ ��EL���yhB{<����d��T�³U����0y;�Qm��1ȩhZ���<��87�Z�y�(ΰN3?����xF�:��N-�o�8�g=DG�p�̨N���S�����prNV�#S┄m.�W�yykh�}!�K��i�^!���8�Y �R4�{aO��MIx�=Jhڎ(�6�3LSBs=h�S�����Ih7n�Xi:8(��pJ��5r�1 a:�>�1mDgC�nyS��H��ح��4�{lt	��ES�q}���B�K�%�!|�	Z�n��r]?��t�D���L�I"�#%P�S߬/.��ʄa7�û���&:�$b��t9ٙ[f���9��[0���I�]�w���`t#b�������9CM�P5YUK�*GN�Hd~�Q�##!!J�4*�>���"֕�Ʌyqh3R%�w�h�;T�{����Ř[\>f�Y���6�|��m�r���^�Or%��A��ފ����[(s����I/9�Ϣ@���E�E�a���cK�9�EW�ǹ+��sL�m��'pQʿR&:���ڶA�5�l瘶-�!m>um9n���Ɋ�ڰb<4��j����C�J!3Xx��yW�������� DV���i_�3���n�^����1�-�_H�����mNEso��<|o�P�&F�㡷.ìXd��<z39��z!E�B�6���`�$�y����_���B�c���cn"FUag�ă�ǆW&�"^- �C���'6��#�*eAW��6A{���i�|dn1}�i&`����M���0�(�4z�1FV類�R���Z\��1&�@�Ⱀ�sH�A(�xqY�|�4"A�un�I'�Nv$��� #b��I��('�y�OT�Eh�+����M��&2dDL���l�Q�>�<^��T�'��6�j�|bL<q���I��y����N<��P�{vx<��Ɉ�$HuQ��%�3���`�G����e�ih���ǋ�	��V�M�g�%�"�>�Is�[ogA�z������;����w24\�݂��d�'?�q�7�ӈA3�
�o0X��I7�A�2 yL�N�-��E�#Z���V���k�l��V�_�Zm�F���jݢ��k�0���k{L��Z�#���8��B4Vk5�~���������/Z6+ů��_�:�)��Y����Pg�w��~�G����Z^Xѷ�����EL�$?�%�/�P7bht�����+{ٚ���5��.?x��Q�����%/�"�:���Q ,�b���8I�|���<Y�.�m®�f��!��4N�U�vs���v��n'3��Yz��"~�a��E�_�["��\�4̌]\U����-�����e��<��1]���؉�}�����-�@d��^p�3�K\�ۄiX��ɋr��R���9CN׉�ɮ����}:	���8�o	�xķt�^r�p��y��h^�i��,8��ocLt��jB�*&�U��.�چw�1*��`�S̃x�+��K�s"a�:!3�V���X�1׺�	c�}�ұ���H9�Z3"� k\�>T/b�_�`���f�FWo�Cu�ux<�/���Dγ������W|a��쪶�p��k0�c����<�-�����F�/�7��?9�3��X *��p��uP��&I+���߻�i��872pѼB{Lt�P��iHj��YZ\�R.Ǵ� yy��!&����CN/��d�\,V��,��5��8z�f'b\5���R�錮U��^$mmIu}���֮mW��H>�_q�`]ź��h$��bֻ̑���wl�쪓Ef�-�� 1�0�.�"3#G��XWm,��z�.2�����Ɏ�d(ͻu'�X�S�+��EF�ˉf1�����aǢכŚ񝏖�(�V����A�o/�lJ'F�99c�Z�9�#t^��5���ſ�v1�L3�Ŗ�RN~�s�p�pL��gb:��h�/S�p$��r�H���:� &���- �����h�/���Ub��Dn/U��씟�kX��\7|{��.�F�!�ԓ�KUs�pG�Y��t��L^���Z44��� =z� ����ԡwƽ�*�1^������C�-h8 F/�3&=u��El:���)>l��2S��	�=��#bR6�ɘj��x(&m�c.��I�sG%�H.W]�4�9���`t!�w��I1��F���n��d0�-�����ѥ����t�Y�n;z��nqa����8��?�6":����V�h$�\(�d�f*��2�ǯ����.&j����s��h(�~m6�1�{bU���%d0��;����&0��b0[��3�������e`/Y�#��moQ���:����8��`����>2�J���J�@r��_+U?��I�\����3�X�	�"$�b*�4���V�BezuƤ�>)Z��d�EC��cÂ�Ku���o��㉱�]�w�v�}�kj�wDVB6]�DV��㋑    :���5xH{[��k
(!6���c��8Ж��5c})Մ��皑�I�f3��f5��n�E�E�K��qL���-q�`��#�J�g����[�g�|��u��S&G�ڲ���͘�)c*!#�cMlR`+[,���0�X���iv1�F�)���]3٣f��.�����D� o�}LԺE�c#���0��7�E��1�!d���vv1�D�͊^w��dfW��#�����v6���'ֱ��8d+(���;��Cu=��5v:2>��]���<8ZK�0���]��E��@�ކ�E������΄�R����$gB�cHs"��8;���l��w!�����}��v-�7��i���I�����'��f&}\�Z88'3��T6�y	qe�.ƽb�s�������yxD��}�b�Dg�is�O��/���7_4��h���HhӁ���UHK��V��ʸcg𓆫���-�0�*m8�*nM��]{Rq>^r�k.9�q �c�d<�#�@5́4G�� n���)�:S��<��hg;��;A�x)v���-���I�Н����'̨D�]��VoNE�vSå*x��2/����F=�`��ţ�m�6A��3uӯii�N�+%-���:��h�J�2�r���b�f���RŮ�ŚM�~ �|���oL��`��H�$�!��J���u�˪���x�����ѧ��$5cj��'pad��>�ؖ�@&�ճ�4DfӦ�'~�%�t�q�Ï�+�r��8��'a���rR�g��k=z	�0�<?XQ�'�\nM'BXx�:l4A�� ��.�=�b�oN���Z&�gL�;$��7��D�.c<����B��Q'� ���Mh�ۢ�Km�G�UQ�H?ƺ�<�^�*���{�R�S�Gi�zb�5൲�����]�G�Zq�������&{�I��O���a����S.�6tO��#�r�<�ֲ�������C|���\�V���)�	<���Y)�9�d;$��d�{F�/�U����\vf;1����$.R�a��z�ƞxN�>�[�˜'��V|�`�!�Rjp�0����
/�,ϥ�Ɖ9�适%�ᘱ�~��&G�֛���X�*�q����k5���Jn�eW��(3O.��uO�DFR�T��H�^tK��nQq�u8l��u�A��_�;�T2�$��{�������p|zC�iDcu1��ψS�4u2Q
�$Bi?�����kt1�ى񀭪�t���}�N�����6&���cËk���	��a����u(��.��XC	�Jp��ϼ�V�u�s�.߭�L�#����qY>g~����ۍ��c���f#:��S�7$2�jAƹHu�&Z�y]E�"�ɖ���)�P���d?�Έӳ�ub�����	��D�+k���\L?M�g,:��~MO�<:�O��?/~��NT���o�`�Y�9�|uz��J7��2/��b$��y�f��o�]$��>u���_G>��e*��l2��������{S�#��U)�<��r��br�91u��n����/��AS��`���>�]\��!H�1X����r>�����]�O'*b %�$ 2#�r�2�[g�am��<���__��@�/.&i}��8�t'�-:ƖZ_�X��JzyA���ѵ�,��c�1�}�}�_ϙ�������e��5����߾����sNR����?|M�_�]L|r���RU�#�pf��^��)�]��J	f��ߍ�v�a����:R3�ox��:��E��a�ស��o��n�:���%Q�̇D�-����~b�jq1�;.`�����b��p5x�G3yH���E���8���}we���m��v7���π��b|�x��2����\LXVlrC�},�@t󋹸Z��L��nƄ,@&8������Hx���%��Jg��9�7۬�P��ZË�y���Xi]Y�(r�N��}N���9�#��|s$�BP)���A�`bv߀��"���l.&�I��_��ǣ�7���������Ч�*����]/{klWV���AƤ�R̘��yۮ����c~�Mgp1b�(�ɶ�Iދ���m�:l��'��7�(�{JC0�����waL�8�2��mϞ#�l��Cl{Fy����@�ϰ�b+$���җ�i����+��Y-��s��Ŵ�G&���NV<7�x,�)�`��HI�v��'��Be$���#sBCU���V��M�j��3�^��"�4k�K����6�(��F}ǂ��Ŭ$A+��.����T7]t����&�a�Ǣz>iZ��.�&����]L����./V&����4���>$r�=��j�d�YԛK��c��b����|���]viA��~���4M���x����z?*bg���_��Ẹ��4�U`.R�h���9���F�u8J�d�Kwd��;�T}O��[�8�)�?��9|M㮃��[�;%i��U�ϖ8NO�.
�V§h*]<^|�,�'u�,�Oes�ê�M`�9k��Ŵ���Ri��g�!5�X������q*-`\L�ka<�+�/�ϛ�y������7�� <X����d�4��z�����>���q~ƫmʃ�Զc4�ۣ3�c�=u����J��S���]��ϐ�i����p_�����y=dܰO��K:��9��^~v�D���Wy!z�]�o,�ܓY�6��b�BR8�!�ָ�R��a!]��6z)�R�To��ic�X�Y���Dہ	���z��K��b��\�`�P��ڰ�������!Xl&؍��U�����j �e�	t�v~!�D��8�����Ū,��;���U�w�R�����@�/о]Lz%c�JdR'K2���ZL��[�/�$�Egs��>?,����\���l&Ԥg6��fA�ST��!�.[<^|��jH(�vQ��߯v�X�aP�aɷ:;;;s(\m����vb��O*��y��OK`d�������je,�{.�]'`��X�%〛���b��Z��.��G�\PP0r��]L�fXb#09lW��Ÿ=
�-X�ְy�i�=\,�Zò�I[����i1��>��d��-�ȸQZ�e%�r���Y��fuO��J��g�.�UY@���9z��db��`r�{?�a�i�	�}[�Ҡ��W���zrkOY����Xf3���4��<唝q������W&&LV�?����})c�d����t}l�[�͹�=�u��1j2�z�D+�[ÉT=���๻��Q���qR�l������`3x��V��XW#��M��`[Lc������F�\�W�՟��ZQ{���<�J�yu�^�;��b�塕��߿��˻�Mk�|�'`u�J��M���|���o�3m�]LWR\Q�����W!��f0.8�v������zeX�'�^}�a,�I%n�ɴ��gZZ]D�y��>������FJ���W�G?;!7��9���P.��u���"���5��XG�]�tp���Yc�d3�,�dKN��-,֊�3��bL�Q~�c�h��ϩ>����x�:?�z�7�M�I�����~����?����n��L�c���ɢz���L�q����b�|�:�����>	LR�-�.���A���$peō��I���i��#m.�U b#�bz�u���7�i������[�1iJV�(�\�I��e��
0���,�`ӝa��|��R_����`/>�Vx���.;k�j0���dnV�J���TvBl�׽ݡ��Jj�:,�m�i�滕����[Lv@al؝<8lf[g1u��]�\���:\�[͙�z�"�'�x�B� �r܊��O����۷�?:���l�{���ڶ��X��T`5�N�ߪ_f�V�av1�'g ��g�U>9נ���m1
�I�&�X��-��`�n�G A�i�x-:� �%�Wa��V�=�����"�$d/�Ӥ�h���P��K!�a�&(V�B��4:k>�d�,��S?�l>��?L�!��[���^��|���ou�솨}X�A�	���8�|��q��<6u�b1� �
  �#C��������b��~�3��F��#����
�b�Xl����*l���b�4���W������Ą��Jg�*f�Zq�}�h�e�Q��}t�������Ǜ	��>��/_�?����������/��?����o}���㱪�x�r��r��L��L�4|&շS��nif1�/2�/%� Ust�=1�`�b��g�����F�/w��L�b
(��������w�?����8TeB����������tۼ���|O�B6�	��
���p!I7��3ַ�b,��ǂS7�j���iʃ-�I�[�J�❏#���2c��6]y�|��:�����vF��W�@c�����JZ�%��j[��O�t}����|'�J��b���1.��^������+բ�L�O(�GR��{JC�]����:<���<�&yl7�'�]��?G+�����)�m�&bߜ!W���B Q��%�!�_1���{�8\�S1{����כpv��6�0�g��i�G���X��������Ꮤ�4�+r�.yö�j���x�����h #�YGyI���q��4��fv��	la]�s��au�f���&op�����e,n�&Vwh���B����y��ꅉ���UgZ�o7�|�	K���4��v �>6���D
����Wr��
��ݿ:����U�~�S�g�󹪧P��[������tۑ�YY"d%�دY�O����4!�����%MM����F,��*���b��CvV�!���A W:P��Ţ�Q���)�ɲz����v����6�+�U��bbr�5މ�[Yo3y�������rQ8���_�|}+h6|=�+��p���Ց�J?�A����������)�G�%r�,`n��!������B�����w3��9ql@G��bz�3;��+S�n�3;�X�Y��3�����`*�$��eq�V��/�:�� ���G��������m>�|+����6��`|j��G����m�يrS��h�>Ϗ���R6��bj�Ђ�������N�������8���AB���;��8������$1���FM|�]�������uv1��M��©�Әc�)[�Xc{��~��ɤ�V��1����f	���P~q5+K�"]�QNv�������x!���Jۛ{�-��ͭ�Eok����tm��ɑ��v����n�:�����X�u!?.w�>�X!������bNH�{����r]�n/�S�產�]U~����?��	�v�#��W��-~{��b$e3w~���M��1r�rĨΧ\a
�,�rs��ɭj-��H	�����8NIL����_��hC~8�7xq�ג8�/F.���k�p��br�-#C�W��l��pI�Nu�������b�#)��m��ȩ�'�.�������l�B�[���X�Ł�w��Y�w�y��g�	��U'���a�.&�Z�s��"��5O
�ϕGf�V����\�>y��*�Qj��Ƹ� >���v��TЫ�|ʻ��u�\2	���>���^,�kX�c�|'�~�3&wX�6��gLk|�J�5z���M����Gw
�T�2�(��W�����F����dl� �b�"#Fzɖgy�q_XO~	�#�\#o.�B~Ic�4m��zM[a��!7�2��yqbz;�A���b��r")��[��k�/F,�T)���^ޞVl����3g6�{� ��}cZR �� �>�pp1r�<�LTr�#
���}(��X�=.���MY�Oo��y��5��*a#�� *�����6<9?�|�����;�x�Å��#<�a�'�u�!_i���S�Q�[>���b�l��hH��$�F1��V�v�#tV�0X��?�+�~��S�R�+]��<�sp��JW�4Dl&�m��[�s�喆e05Ϲ(��>G�~�����0\n�Wn*�-~�#.���2/��i.��!4fl�����o�'\�YtL� M�A��9D�b�F����"u3e�͔P!�6E�bI�WBy�+��6q|�S�1�fY�x�¡�a����[*�;�.R?�k��Ť~،3�.���X2�-n[(����:\L|/"��Th)��8�N̙	[6�o����7<�	�sV�����KI	��K�w�`L�K�!�C瘦W��^��7����S'�f���f!����*�v��qa-W�ς�Ei\�b"5.g<v����:Ѧ�L���;��k��Ŵw�q�,��K����?�t�!+���L�e�)���d��ZI�q�F6�����}7Sq��>"����zT��|'�R��f��[6W05���	��$4����-���4�3�B��H��5��b�ׁ�Ї�á>{�[�$��u���POG�^��t������q�H�kFn���f%������r�L-_�a~��M�������]v���{�����V��&�2��!+�J��ଡ����kkw7x���n�s'��[�������O�x�O��wB0\0�������f2��]���Д�4j��N#���cH�a1�kq1��
�� ��}D$��XU����7�-��b��$4�Â[�����ߏ��T����Ђ��>&R����~	/�he���baO99)T��2)��'�AW�E���]Q#_��Ϲ��J"M������j�SZ3�Z�E�Ή�%"�2���/�mXH��T���xq3e(SK�W��(����.�ew`�H��C�$6cy�g��0.����ԕZL{�q�ˬ���[�I����/���u<q      #      x�͝�r����O�����$�D�";Hj�����N� ���1�x�ΐ�|�53������!��C	������M�����������oʟ5H�ĝ�w¢�(n><?���������˷�o_�|z����������o�?�߁�&�器(�xDQ��	U��� ������_7_ܿ~�}z�r�z��I�C���I��dX�����I���Dn���Ty�e,Ս���yj*{�������˯���Ϸ�|������__����O��������}{x���0yg�������1�;���$2�Zb�vW�'Pzj��2�Ywg-*[������]~�BWw�.2:a,�"��������������iϐKa���>�2�H���>M��>��ǔCe�R�z�����������OiU<=���-v�;�t%��bQ~©� �Z<l�Y��<8�e�Z��={jPz����4�Jm�S��U�[���ח��u��������ׇ�����z[)�@k�$�wR/V
�T�)u!��JM�j�h\1�C���V̷w�K_�<`Z����\U�Y瞢����n�h~��i������_�v�$H�ċA|�P��b4��;�'	%q���NG��w:���c����~���rKg�b��7Q$=�C��_P�``�� �"j�����4�N{TƸ7�ut���=�ܝ����XC��I�֪~�uG�,b��`��ĎO'뛽ȶ�|���\��t�?v���YXd�"#o��;x'	9v.��R�Ae���}�����.��N�%�"�F�k�De��;���-��v�9.3��N�W������_��{����C�?VөlE��Dc�;{�t�3,T-��M��������^�������?���,>ih1�9����"1RjFs�$�X�ܛlL�XO��\��,"Q�p�/l���,4�)��?ŏ��GO#WMH7*�F��g́=�d���Ȉ�#��+���w��Vk��B�"�=w�Sv�����[���neZ$p&,�:�<�����@�B�p��Ux9�%�
����l���̭#����n޿������G�w���c��-�5!k5n,��V�,��Q���ޙ�'����b!�}�z%j�$B�Ip�Ǻ�&���PֈI#�Վʺ���Ȇ��!�;���gG!�ǎ�<8v�b�N��m�>��ueO�d�{ǩBI�H���Vu��{����ޝ���m��ņ3ˎ�� 3��D-�D��@�<c���<��������q�Q�7�b�Tz��:�iI�g��獚%�c��F~���h�Hn�<@b` {���@����m�a���;}u?���\dB�����R")�Z�)�� �D��s�M�?�к�&s?��o^�a �i���R�lR�gxKR*$�Ӛ8�7���	���$���"d�hÇr�kfQT�N�ʌ]���������o�>����_/������)�+�A�@}ϑ�#c�+��=�Gm���M��U�A-��S�o�D��� x�n��ͫ��Q��}..��ǟ������'�r��H�ABӔ�~oB/(�ŋ͠��]ў~W�[xV���U���_��CH�(�#��=��^�09��Ӏ��Hj u2h����P���A܄����X�ʴD���晡<�]F�BЭ!`���Pv	�1�����&�}�c,��e�V��X��:�|? 彁�3����iyB��}�x�$�����o=�Y�$*;5�}ƴ���$��.��BG�Q�f��J�͕��ׯ��>gX��$!b`H���B4����&��6��M�#D���piv^�o����8T��?~�����	�!8͊�{���G� ���A�Y9�n�FUO@� �u�"c�8��<E��Yhi%���QY���؁Y��D��t�g��-�4���u�3{�<*C�����k��Ҷ[�IZ�i�-;����`����lb#����h� ��쁝�LI=,cwK���r\���0���ȹa�X���W�iI�f�R�2�E3�H���N!�;+Q�@^�3�����*���L���ۘ*c��&)��&X͔eٙ�	IXp�.ڇ��CK���_�,D�q�@��x��9+7��_`�jzޛ�	ђ���*;��[U!$�(�^门�&W[�A�IDKZ���T#���VY�:�B*���pI7K�f���Ɨ��v(F��xQ�ӈʛKN��ݶ�����������_����)��"�@E��6g:D�ƫ�ŝ�����翚��%t�oFžo.�d,�R"i����(��<��Q	�E������9*����Fi�P?�$ � �J"��7	����>v�����+��d�����a]J���/Îz)@��Yd���iD$u���: �Ο�����)�h�M��%�M����z��������⒨��1O���	.x6_��΀��� �D���r�k�ʐY��!��f\�T��d��Ju�w1�{18�C4�,CS�ވ����������1.V��$!���<l���ksp�u�xI4%���z�zO��4*c���1�)A9��x��I@�!�]M%��� F0]x0�&KQ���	>�y:���9�A�2���믧57�Ҳ2��-�C�X�{F%�r�;�g;����W�����C�*���Go:E�I�891�����-�������Л3,�Y� &����6Y�"��x �s2�2FnFC9n�U��N��h�DC�$�o��G�2�x�����d q���u4��/R�)PĠt�^��xE�`��T�YD�V���
��
�����h:,ZY��7*�V��4*�%��zn}���j��d���HX��O�Hbe'pNR�5=�i╕��1�t�G#P���"��QY)s����9DM;�+/]9��U��N�)��j��R��:a�c[3Cw6���x�iDV��ę/�t�yn�4���(�N������N���/�O�7�Jgбkb���@�*�Y���
YfK斣͌_= cƯ�!v��"�V��Ev��f`Z�H��CU[M�6C�g���8r:��mQ��阣荋Xq���Q!��b)�g	�gc�p���<2�X�O�pc>��$��F}d�t�o�D!ϻ�h�y7�X�C�c�qen�����ao�m^��óɸ�i�<*^Gg��1cZ�;��`=̏X������>��x|�~����_/o�Ċ������9D]=D��=4g����"ˎf���-��Bi�!�(��Qn3�1�2V��$!�w����DDe�\��
ܢ�UW�(��(�]p�X��n��
���__�B�8*HT
��G(��b������qd�K>��X�Q�D�hj4��
|�������[zPi��Ys���(}��:�Ae�s� �+�S��R3�������!B��>V�ܼ
�q�c5�_�7�i;,�I��z&��2y��a����D&�i~�!iT��IN�$^d�D�9�!�Uq>`�~-wԓ������u!��[��N8[�i�U�]����M��nBA�;�c���;^+�1�2V
�!��Q�{2֐�b��(�8F]k.^���X5��8:Y�E�i��<�)�Q��,2v�f:BB7(�1:�U�͜�X�.%3aj���=k$k�ڙZdC�l	R#�ĳ�i���#��*��PB�#��5Ž��F�\��"����"���T˨\3��3s�]n�\%�dg\n|D&Y��ـ��.7s��K���w��De�.7b'�ь ��6%�Q��hD��1��_�����OcL�"ҁU����r�iTֳkq4(�G��W)�q���dyS��<.6�&�{T�=��|�B�6.��$%и����$b�9�9^���zaiZ�f0Φ3��TƆ�x����o;�8�4d��Z�.���
q?[�n�����r�y���
s��Ø�Fű��(=*;�M�qu�������3
}aL�_��� �~i��2�Cx<5q~��1�n��g�������O/�����#7    �E����m�J'�q
k:�E H���-�g8��Eh�3[�3��-B��"�A�m�#��-r�f/ہ��j�U�u c�1��$��;j)Y�'B�5&|<|(�F������_�͍���Q�zjn���#;;~}�A��u��Nv֣d/���uQ��ӘG�_U���=J,D,Q~�ub맏6��)��=h�l��$6�������R�ٙ�]N�{�$!�Bj�� @����N��.k�g�K�w�����~&�9��x�e��R�l7�P�k�ԑ��`a]ˁKX�%xM��I��Me�S����]C�`~	�����H2K>B����U&)�*"m�:8�[�M��b�q4YB�^�ђ��C`���9DG��lW�q�2f3_��`B���B�'8fI�(�2��8�h�l_ �N��6V��Hno X<Q.�/���x��%s	���.2�3�$"��40��%�SdGdk��E�����e�q�0�g�� y�s�CN���6��l����d:��N:�I�{l���B$rP����V��T;�|��u��*}��h�(a����)�k�u�C��\x@8׹��.�H�]֟���U��k*�G蒠@�� ���~�]�1�l�� ��K�2p3+>�{��+o���=�1$�V9��wS/���C����iD���(�I�I��xt��*;�r#�Xt��3F��i�s��<L<Hhs>��ȏG���f�ѧ���mM��F��N�iѳ:M1��#ҖZD,�^�@in�Ge<[l�_S!�ΤUƭ��|�j(4�6=��A��=/�y��x�r$q����.c��ርq�rђdp[���e<�B3�Ȏ4����5n�x'Umq����)���s�PN|�Ig��c:����q�8շ�]4	N�)o��NDe\/��a�.FI�w?���l2�WY_�냲q�JmLp��I��cw��E���k��#��k��z~h-�^�5���{C`��S�/~S�#��S�Y�Z
����K�u�xҒ%�꫺ȸ����Z���u�nC��:��i4�c�$��o�=��!j�ִk���������=�����,�@T/�"c���1FM���D�Us����w�C4F�/�������š2�ax��3�xԅ�$o(k���M�U6P���k!�L	%����.k^�Lczf��k��i�z���E�͵�H�qk%Un�.h�{k���'���$a������T�Fe� f��Ȕ�\?�;��@��.+t2��uIN":����d����x�
)W(���s�p��v�#��a��c6��hKTn2~&E�L35��*��t���^��(v���Ge�nU:Q\��|��J=��|�����]ę�����=�WH�kҠ��O��N���~���%h2F���2vo!��U��M���.��e��U��QJ�������>��v8I�[h9il[m��0���q�P.���궶�u\?(�0T6!8|�Dv��.��3����9�ʦF/�ʈ�����Q����#v��� ��h�vW�2f�f��I�0�.	�LV�B/�H��C�,�����.1�H�,��8�+E�m���T"��
������E���}C��Qy���ID�AF�|&B`FT��O#Q!C�3�/�S�"�.��\轛e/�?�����sm��'�E��AJ�1������80YA���*cV�jZ�]0!Lg�JZ�B�ٍ@����yD�H��I��N��LG�����d��H�;�_l;���ѣ2~�=�T��gZ��8�<�샩�;EƵ��(����k�t9t *O�2�Q����B������57��*�=IH_4��c��N���;,�h0K�$��0��'c2,G��ҙS���e��}Xdg��ҶD'LkPƠrIB�K]i|L�rIb�+�,��D�kW3�,;a�V�z���wŶ�=.�(��@ʼ{
����"��:C��9�:���
����3D�3+���S.�)�u"r�h���@�c�/HW#�2nRr]��i�2�F;�[����?�(bd6_-������l����&j,-VI������(/�d
Q�N�Y]C������z)��;������X�@$�W���U�	��U>��K�C�DD��k�5��q*6�z=a���� ��6���`����+�G�L���U6�gt�N�"M@�n������[ƠG8���cH�3;�p���![�v�٠ͭ J�%)x�js���c\�67����w�#ƾͽE$�9�N�>Ľ�]��d�o�+� jx���%e�@�������"��D��Oą��q��6��#$�r���������;��gt>�MnĈ�RN��'3�|���(�\z
ݢ2,��RO s�hX)R.�E#pŁW����U�`�p�×�\�*;��˘Z,2�HG$��׃<��;f0���k*�7�u�v�����ΐ�߃<c��0A�@�l�\��Y��Y��vhch��R.��僗���y�uƢ������쎛��0U~�n���Q�m˭T�	�s��h�����#H^��$"M�(���<�eG�j�u��]8�����1F^������8-5�*���M�+�ڰ��4>݀���$+���<ؕ�£<������,D轲�:q�9FIX�F���,jF�1�hkD�39�8.A{�ǆI*�r���(�$s��غN�lԍf�J3v1O��;�G�a�i�dQټ#��H�"!Ε!�dV����ݛ��ʘ�5�5��b�^�����"�>�Ȳ�'	;y����s��L
l#Y(����(�4X��rM��P�@Y�J�a��Y��֭QY�gi���
�������e���,g		sl�p��^F��JOa+:-��ǁ�v����C	&�b�VuZ*2R��2���_L�S��Ǧ|����cf�j<�쌙��J��t��b(cfyl�X��f���ޡ�S���c���s��9f�-���lN�u��0bi+sݺY<8j���#<ѤD@zTƭ�=���L@���{�￾<�|�z��������_O�^o��><<�?4Eͧ@;
[�TBU�vʋ���"����_Avm0�^��!"��"ㅈL#�G�|.���#���l�����H� O�d�Q��|](�b�@�T��e$������m~�{��웿>zR���/)�KJ�o'��F�J9N"vr��-76��j)t�m�$�jQ�����4��'��$e'_��K2�ʎ|ۣ�C2=Ĺ(�h��oq2al����<��mwU�r|
*�u�h5ā���O^����x�Ls��z�s�v��g�˸�9yX�9�,1��ѐSH�ʸ%G���L78�ꬌUv�t]���3�M�Y��[��>�rO��@��J�i �(�!��qm���y�܌Jf��0�6D�gCL"v�G��u^'�2���
e�A�Dk�"�w
���XN�iB�8^>Pٹq�O��B^ƹq�2����['�;6�e'n�K����@˪�:���pg�E��6)���5���6)���zh(Ӵ���e����x�aӈ��wq����q�Za�;7�M:0hʊ���t�A[�6n�m|��������}8����_���r�-���2*���+�c�F39��۾4P��S�"��w��b�。��
"J��Sv!�."��q���u��u����C���	B	���A��Kï����y�'}�7/����Ae�v����*cn�����?*P��B���~q0�63o��w��rc���gko�TL��^Hs7��t����[��7�d�L����R��n�`�R����S���J�X�<B�H�o�]@�@6�<�3�Y�:
s�5[�AE�ugB�1d���*6x���+E|D�,E<�h;���X��Ӧ�:6�KXk͞Q���nI�[:�Lf�N��3�UV����mW���n��}��I�x�#EiP�|d�,7~�y���GethQ)�ݐ)x^Y��nd|�0ԶE�1{pLZf����6Y�B1��%2Th�;@cz<.��*O"���H�l    w��; ��|���K�\HD��<s@2�d���ɀ��=ʙ���#qdf���s���@Û�l+T[S�2~�ꕷ����7֏,����1_� �P�TB-V+��td$�$�%�"^�|�h���23@��3 �_���4���e.;$�R�v2n&lc�ʵ��_T�w{JY� *�E(�!:ZӬ�pH��t��mi����>�lo��(���G�)Tƫ2�H�.1������&�;j�kѕ�
�����&4YZ�^I����qq��f	�6`�SV�W��N�fG��G+/����(7;V��"c=�"�E�C}.��h��"�=���)��q���D|��w�1F��;KH?Wx��1��)��j��������#cx�8�cy���c�P�
yT��StƴI��B��.v�%3dt�KCRu��#���E[7�Xx�Ν�^�
���
�d������E���}0x�'���q;�L!Ҿ"_�6 t�;o/;�}��%0�^��֡��'{0Ar+�N!jn�p�=QY��a{[gW���2Ġ����1.n���1[0WnFegl�\�#��Jya�)��2Be� �(�6�8��0W?���dy4��\	eQ����bP!�'8�GOƽ����&;]	�*ew��ۇ�i�����/n���$�/�b��i�����2��^�L�դ��R�_J�G@m	�z.#��S�d�5�,:�Z��t�F$|�C�3��%�i��]1'N6��UƮ���@7(a�t��mLP2�>]FfŜ)BA���fl),l*;Ǐ�źq)�B\��n���$���,"�g�E<�3���'F�bw2f�^���Ɠ�yP��'㰆 yޖID:Ʋq��u��N�.�GPZ��h�Cs_=d;��,�7Ch�5!��gT6P�K#F��-����x��@�z'8k����a�Ӕ��̟��W��3�ӸŇ��pM�?�=���٧�<2iDk�W�;Y��$�f�y�$
�Қ ���]d���I�N���`ֹ�fYd�����v��y���s���^�D������9&��1������4��4���@4�>>�!FE�5���t�ѹE�:a���\$����eG��;���x�	���Q٘�[�?jNp��a�v19�Vb��M%Ӛu�J��%���$��s��x��9���U%/u,m@e��ͼ�j%F/�iܔ����BDe�
����;F^�Y[�ʸ�cL]j�P�;#��p��C$s؇ �ﱓ�������t�J�ɐE�����p���V�_j�4�ف]0��=�����in܋���[�3�0�&t��#34� �[hq
PysI��b�	<Y�RE�������������o���XD��:%���~@����#(U�����Ȏ��R2�{S�
2�����Y߶&;#,i����:��ѐ���ѮZJ��f��AL#�G3n_m'���L'���[������#�;K��UW��N֏� �Ҷ	:M4�h+ng�0n����Zܫ;;�'�E��MP�_2�-��ɵx��~+��k�߼v��[q�B4�A��@s,4�B�}���x��ӈ�X�Ǡ����ܑv�ؚ\���v�|���2��E���B���� ȴi��Ø?'�^d��QixK�g�;�=����g\�^�X����=�P����lnE7g��Y���t�8�@
q�ȱ�1��};cٰ��.i�2+�7=D�4 ����1F2~���iA�ⓝ��F�ȹ�Z��5�����Qʂ)-�1P�jP��M"v
�"������^7`m/o��<%�MD��"r���]');��D;���P}�����n��TVK�E	YO�|�'�IDB�B,���?B�&�ٓ_>gQٙ�O>J�p+r`�{|''��;�=ęɟg��IhL"���*�?���pH+�8�����l|����Q�q#�����C�����h�����4�*ǕYT�)T��{�U�`ჺ,��h	6@�:
�Ce<��4"׹�C<�\��V��a�р"�*�Ź�:���� qZ9���Ud�10^��4���]7����G�<�a#�18z$ؙ�c b/|�y���Yb,,�i�;��a�1�ͽ�YB��@]+�8+@� �@y/ ӈ�N�NDe':�Nr����'�@egMv����h�1�]]ם���Mv"ЈsE�&�a>yu�2���fWd�:GR#׶���t�X��b��);d씝Fى�(�c6*��hF.&H)4�����w�AT-�������H!�-R- B��yՂ�H�!���E&l�]���ک��(X�Y��u@c�>���!������Յzw2�]�QD� ��o����H�8% 5*�8=�(�mX�%�KGT�j�J2&�T��7�ȩ�����;�IBr���jYT�J@�uA��h�K3㗈�D�12�');�����ڴ��C)IN��(�B��*��-AYo�"c*]s�jD�.i!�l(r[羰��K2���/>������f!�ѧk��	��2V��D�f�=t�Sr��<ʓ��� ��=��߾�C���4-�\�ǈ�7����V��M�y&:xM"�ojp��>&��<%Ƣ�3�ls���m	;�[z��v�1"aUy��[U���6�ь����U�:wң��[�r�����e��C�1�Po�L"�*c����\�����$d%���բ���֐U	J�ʘ���2��'�Ce��X�:"J�s.���We�
;6���E�RyL�Ț��]\��%/Ƿ������Q6�P�WaA�CP����E6A�*I�"i�h���9D3N�C��s�&�
��9�
��
-�5x������FM�����Ae�fu4��3(�焗W�GE2�������O��ö[i�:գ�*��~҈l(lt'd�d�Q����jЀ�x��ID��J�� �!��a�$vM�f��kq�x����<�KĘF�^�����&�=c�Dk��_�����;%�-�z_�fo�N.��s�$)�C��̢2V��,"��6/� �<�M�Ɋ��t��b�+��Ȟ�c`���yD����gCe��Zr�4�m`�z\��P
�f/�l�5�d�&���������)��Z_�ǄPA����}�0���NF��o=ܰ!T��Mv)�!�w��c��g%?�
~"��`��_Ѩi��q�
�L�]�帛E��l6v�=q���ɸ-ZU�_T��V�S�ᑗ��P9�;}�eX���uk#�lLD�]c�3�	�N҇ѵUer�}���d���I%�4���RK�B��|�Y�� �e�Mҽ�I�<� Ps�e2�u�nP���GAFTƭ2�Ȋ=@<<��^�s{O�NvzX��4���;\@�\G���C���gF�˛���dr���껝�g���br��xʵ�1[�@o���]�X��
��zp�diI�D�!Dr��N1l<���g*�;�yk;5����ʯ���{ޮ��l�Q��"�P���I���)B'�/"�G^e��d�����nKfn�F�Q�Id��Ӈ�"��/��F�wb�!��I}� {Ǒe��(������!Ʊs���uS�tq:��+d��ǰ��A�Z�@X�k�ȗ�!Vv%�iJB�#(kS���Æ}���d�	�X'�N֧k���em�gDF����!3e��q$e�t�b������XL
�}�˃*~��DB�[L,���D�D���̷�H�9�������m��c�Ae���M�&��~d�����:�'_Q	H��x���댤F�:�q+�Kd=��kP��Ơq'(9�C��X�IDfw��t �#v2^�o�JΈP�T-:"�Q9�c����	n���B)Q�W�$&m&���ʝi#*c�w'9.�Wq��|"�)u3��0��Y�"ϴ�����߾��&��.�2f�I)��������Yo6���Y�Y*���T���1D�,A��	L�ө�s:M#��P ��B5ɍ�1D���Z�,�s��B������:^��wB�qxQ�E6�Rr�����y���,����c�H�� ;  �plC��X)m6Wq�ţ��r�v�#�y��Uues�0%�"����E��dm>/�x��1��9ߕ�s�ě�扚���KG϶6�ε"*�uEi�6�\�)@�z����d�1�ɚh<D�M*s|�6��1���9�p��9V�<oē��!F^��4"���l{�Zf'�'�����Рc=��cYt�(�N���W���\��K�_2���Ǹ�u'	��M��ןV Df�������t�D:T��mJ�2IwoT�a�D3�Yƭ8����X�O����z�VK�&4�/0����+�M1v�i5����f�Qd�|i�/��3�'��H�,�a��u�Y�ߗl���7���E~�_�H��$��Q2��$#�iځk���2��3L4���!2���(�m��Pې���9Q�g��;��.,������?��&�('�A����E{ ��W��W�@m�681sj��$�^��N
R�2vi�ID�4�x��g�ᒇ��S3���m��PY�ǣE\��ˤ�}0W��I,�2ރ�4"���6sܱ�^�hL6�������c�d��n���!t&�`�Wf����9�@�C��'�W�(���4�.�͸X(U�op*�|�88ơ����+0��<{s#G���)Q�;��`�Ea)Q�!2Ko@�㓈d��& ƁEP�
V/ �D��w�൳�-�ArC��0��˿�c$���w]Gd��j7FA�oڳ�����iD�u�C<q]G$��[�+��Q%�l2�V���D��Z�	���t��!J�Z>�ȍ��1��ՙ�ƥ�%У���Z��+F�EI�EJ��q2k�J(�Zj��*�"������Cp�	.����l�PCML��_�B��X�l
�<�nAH�>������S�';
gs8�n�De�(������s2�ʎ�<���#/�l��ӆ�щ��ʸ�;�yQ9�H��-P�0��{���O"v^�?f.�kj�"ú휕$�L�%��� �u��؎�9�A��\����v�m�6u�*�$ش��CP��U�˝lFaǕu��c�۫&�G�z`��������頶hT�=��&�d=�Eƻ���h=��[&���68"B�F�Ye�S�%(���Jn G���1K�� ��� �����U��쌵^0�y��I�TC�:I9o���u�q�Z����U�y%u��*cE��6��:���E����Z	��E1��L�,�s���mTjOɜpPY���Ga_�m���=d���:;8������U��;���.�G����p�>��x|�~����_/oì�Y����Q��             x�ݽ�\Ir��x�97��� @���#��쫁iY�#���_w����x�ʨ�`�$ǌ����󥇯�w������	i~��ҿ�?N�g��3���
��������>������=����[����|.�%^ Y:|��S?w/�}aų�Y2����O�_��|������������/��t0.|g�f�hk���0ϴ�Ϥ-x���;�B���<�"Q|n_��B�g��d��������!��7��7����9��x��gN�_��������$��=���7���ƫ����oY(
*c^(��)��wļ0-8b�`=�`����
,|O,�,9cy����|;�br�Y���8�-��"�m�bB�Ux!�ȖDNbRr?�	�V�Q�r&h@���� b;b@$�$�3�����2/�ش�Q���-�|�x�8/'�\�/�����l���0�zAmV(�����q��8�P��mG1/Lx��K�!�F�
�S�^���߶���<�K�?Ä'x�yO�|�ޝoO 
�P�-8X���8[����<�O�Φd�C���=Ovr�����r�_��o_��9t����8�՞-f>�a�G��	��I�>�����~$r�q�}��<��%j�S���-P��EQ�2:)�$!�Rm D.��YĨ�� Ĳ"[	�jU�J�∊<М����B�@>~>��8�������ΙC/Zsh��D{d�9h-1HH!+25"�;i�፰`�eq��R���_{�m�sx�{[;y?X/�n�H��������V�H�E$�s\�ip�r���^��ضjCt�!�q������<3!u�1[�>�Ϊ,٪,t�**Ku82a��i8�p�s6$��ɺ{����nЋ8�ҁ5��/[/�.����Њ�+0"g�������qv�,i���k����j�/+%��vW�/���6�C���[��p-�I�{�ѓ�eHAqv�ș'�0~��1ڵ���Vڭ[�a�ٚ�C$/�������q&�l�\!:��R����ޕ��Ĵ�O��r�pH 2��r��{#����]h���:�EY^Xy@�N�c�^�BZ�����!ۣgʒ3�ϟ>��%`���M(����I6�11N�� �/���hQ{���愭{�t���y �0 �p���L��S!�(�#�X�Q��!~Y}���=���%y�a��/��7QI0�ȓ��u}�� F�"ƃ �5��5��G 94($���D.9F� �߼����ُaI�E����.'���,9R���d�%6�������c�6�r�➽G1�[���Qo%�~Wr�;̀X�O6�@��X�K�n���"�@�33"�� п��I`�Y��<Ȉ.8t�C�D�\�cT[��q��ab)���~�.@��`��M8z�~�$�,Ă�3�^��`�=��@�1|v(i���k귳���j�8 @�~sBʸp�b�{��5�,���hF�	����bF޳K��/k,UnI4/�*]���N�8~>����J�a��	d���m�/'�.�SI���Ȑ:�r{���,�q���j���g͡n�!�m1�}a	/���^g��"��ΟO��� �za��HYd
��������Px{��l�"�;�c$4�f��u������g.,�4^�d�� ���u+rFrwz͞��Ip��fL��- �O���=l|�L!�c��
�1-�&��R;0�L������L,b���(�p�
�xGJ�c9"��+7����*.�Z �7�\�N������ȅ#7��-�t!�6BD�QF��+[ �����@�\ﲥ��6z��;G޼?}�@A��݄�F�Xl|e������`]�L�����S��R�K��Eb$Jx𫊼�^�#'�&�U��=qOW!����w�%�B8��U����Lh9���*��;=W��G!�8���@��q>p#������Gt�G ��??���âւ��A8W������˖]�R�6�#x����V�cv�����au�Vd��k�|hю�W%��H����)����w�u.��e�p=%�y���{��;X-�� ���3gzS2h<Z��u���X)���@0�q>� tϦz��v著!��7�f*�##�*#��-��1�i�QQ�&~�Dd��\�9V�;�h����zw僎!QvR�辋�u�]�����H�r6q�b1�~�������ϩ^u��h=�`���0���n�;�J�k��Ҋ�Wl�aP]�ǜ:�`)�8RX���'cPN\��n�ǟs�F!?~z79VXЌ4Q��d����o��E�����U=�� #K�v��y���H/���x^�,Y�rДn?��#�d'�'������n4Xª\�Z p�J�]��v5����s��a��{�t���E	G�JZ	8X��u�#<�ķ�v�K8����c�茶p�$�{��Ȳw{�� /�����gyQ���:D�NFa�we
OL��3>�ػ�q��(��M�������r���~�COo��G�$r	��t)
N0� B l,�Cd�ʬ2=]� D�@�R�Ǒ��L0�>�8̪e�yG�&q�Q�wrV[�n��N�����oJaz
p�ׄA�8��q�v_l� "���� e6��XQ���g^-^w��`0�쩕��`E�8~�߻����������Y���[8Y�տ��H�o�������VJ	�۬�l�4Rxv�j��[(�Z���i�����P����~��}}�%`{��.0��U\!�X�X�ˢ�2���Ub�̀%�����{��2�	Η4�� @X�bd��\_XS�����ꊜ�2��O8%��=`�z�Q��K�u��G��U��q�~wp���liL�l΃����Q�P�Aj(���|�B.~���1�<�P*:PĚ���n��ǳe"'
����$��PT����l�f���P$6认��y��ή����-ߣP���R��HX�;�藙�K��DV��|z͒��rz�����+90\1, )��/��c����p����	H���o>��Ƒ�6��_p����iJ��'U��!7T�K�������-�I�+8�Sp���P�i8�݄1¨��"X��y<?|*� ���~��0-�uc�r&����6|�89���ӏ�O�}!A�Ֆ�JN؃h�}u� A9(��w���9C�~��JH($�AmΩ�u�q����uXd����0�"����3�+����A�o$0)��ع�X V�0q�{bb��$�661���*����ܑ������<����\v~�#,����e���UI�X��a�EH�>��-�L5��Q���+���d�P�۸��˚@bqJf#HJ�+��"Y�X��pY��ʊ*�$��4{�ƶ*Rbª`٪`����*����(#&����?��!��:I3j,0X�%[�e����-J��a��Jw��Xzb��h�t]P��a1)8��r�����i��:^I�8
9���v~�hxXD���ʲ�j�-l,^D�v�P�a��ݺ�H�X (	ZY�XX�%[�e�2yt[mrɱNͶ�\�QnH������lZ�%l�a���3,�[�xm5�b����f�"g ?��?qmU�^C#� �;ی�f$��z-�ej+&�\�>YW���:�}䧄�<���0',�(��[��{��u�����C�����Ķ-y_1�$���zwû�Cc�h��Uރ�bkkB][@�b���`C�um�rQ�n�?�gː`6I��wѳ���Ⱥ����K��Ԏ@�\�!��V�n���L�[~�.��ʑ ^��W~�0tc���^ƻ�n#I*�f8X�������M	�A7���[�kO��p��d�	`6�r�4�nZ�?lCRЭ�2��S���3�kٵ�    �r	�>�0cvLf�hE ;�v#��C��]Ƒ�D�.���.GW�3��iH�KC`�N&��R��!��I?�	%���QS�������{��% hD"%1��Yî[��ţ�̬a��f�ș!�@,�&	j<���Uƶ@Я[�X�U��s�9� { �\n�>�/�V,C���oYg�#�VRXr�5|,�kx�~�5$ `�1F��lؚ|ۢ��}�3a�X"#ڊ���9r�cJ_(,D�Z�u����6""�?R�ǡ'8������o�����;�xa�@,զ������9��9�67Y���<D»���]uHvr>Z"�b�Z���[�$��h��R�y�r�8�Kdۜ�Q�	<!$X�$��
Z�)��H��X�qU�*6؍G�z�����'r�	��O��f�D�Lu@X/Ŷ^�j����(�B������~�@�BGh��ā�Z��Y'���0\Δ����^Hv�8P��'�;xY!q�����鋎B����I!�|?�"}��tT�6��ڬWQ��b�N�Gk9����e�$��<��e}'�?��'I:L�b��洷6�ut�����>�R�ò�YL䬂������b������l-po���������9���b��-��X ��t{����!��$��it�i����
oU��d�|"#�7u=�L��&
��d�)b��׸Xc��l���R�ץi�ɾ�`���ܙ�P��\
�vυ��AVP�����2��2���E�w��b��s�6/_�3?nޝ�'H"�ꐛ��9Hض�P�-9r��)HL��0H.�a8!��R�����+}R�� ��: ª�����E��.��h��c�K�$r���(郸�d��#� Kn� ���])�O �C�f��7B�ry5� ���fEH��#�Y��|!a�5��ꚗ�Db5��g�D$�!����pٵ~d��D	gH�+����"g$�>���^',��������X���+Z/ޗ8��8�D/bB�R�"�7��.��Q[��Q�"�����-ٲlO.�H8���S�ɼ�rvs�O#T�{�)R^l^��T|�fc����e�����bj!
+7�i��?T�����z=��%@�G?�m�uk|�k��t�繮$��/���;=�p�ߔr�<e���1w�<�B��ɜ�C:<XB��I�-� 2,z�њ�O� �S��58&V1���I�J����`�#��b�#,,u����ׯ��ș�rw5��P�h�SB>U�6{+�P�cP�>M	c�6�+&j랪��}���I�2Q�պ�ӊ͉�]0���]��R7����
��y���Ah�.��� ;l���&E�񏗝�mQ��Ê\�ɹ��zT�.:���\�LzeߗH,iB"㦭�x�����$����^��+U�̓��h�k���m����u.
����R���f9�WG�7鍇*Ί�Y� 6e�ט.b��C�-��	ͮZ�6�(~�r)�8�L���Dj��K�:f{�Cp-�x SS��Y��*�̑�@�Gw��w�����]%����,�=���-.HH�����g�m$�=[r]�K#)����FR=D���YB�s��
	������16��`#c�iP}s���̼���o�
.�"&�Z��Ik7�� 	w��h��\�[J9'rB��F���3S�n�17���� 9�f�����c���.w���5���1)�̓ۛ�ק7���KP��z���-<�����K��b�5�*ιHI�z��x]�����l4Ő��(T{���E�h{��dG�U���|;����?i��W��D����@(��V�(Z���ľ4_ϒ-�u�!�X��$QB��F~s�y����<�N�-��u�^�W�������rw���k"'$�2�y�t��v�G�Zz%�d�����m�_�\��H�ڄ�J��pQcmԨ+;	��}��T��#)��f�����DQ�7��#A���(ڰquKr���O��M�93�A(��5t�8��o��{�e��,�rx	����3�ono���ǣ�')�Ԅ�˰F�fX�b�}�q�8`�n��*rF���iҒ�>���7㽣[.�Z�Z�nU�WC���$rI�S��fd=�7	��-��[����C]hE�d���|(����E.o����[{�+�U��U�f]V�V2vK���v8a��G�o'�=m�C���@��]�UkT�����)�c�\>���{��~��}Yz3A�T����Hl7uaM�sek�4�Gi���sX0U��G,׊K��&Qa]Iٺ�j�n�`a�	�K˾��"Q9ݞo��ю��PNұhT�Ɓ#��;0�0�CN�q���i��@��\4��+~���X>ᱍ�z��N�*l<cC>Z��dO~���R�h�(;�x��߁Lry�K� ,��'%��8�S��b�E݆*ȑ�U���5��8*����<9{����9r��]�S>�K:,a�HD���z9R������/MF;_����/gEF�.+,n�u�@��+���o����e<���� "�J��Jj�lYT)e��1A��X"�3���l�mqB�6��1k&Uk&��
���}�4�]p`���_�����۟�~�˿}��I��xO$����X�Z������Mr�iѨ 
9����ۗ#,�e4���yQ�WEz9���xS,:�s�*2~����_�1_xmF�V���BI���a2Q�q�^v,/H�.���T�����寿�� ��`(C�\��;�N���2�}���~%��Qq�/��'��Z�`I��*P�e�.�ͺ��˵ڼ��qv}G�m���Y��|zC�x�&c�{�� ������M�c�L�.�����xB�'�!1r�VZ��z�R9��k4�t8p`�NθG��` �ˈ���2�fU<�d)�y
$붞���I�����\�nT�M���P,�����������Nw/�����O��ß~����(��˝6OuIT��B�����_�������p�I�lp��*'=�r��m!O�i.ã��卞T@���>;�$�CMʢ}�|־�s����\���~��/�b�op@���� ׫��bם���eL�˦Ed�����<��'�y*B�k
#e$����I%�]��Z��9�c�$r�r��}��Qb�8�?��4��JQ,�b��,5{!e�V�E�OwԊÈ�Ƴhܦ}t_XsiE�d]V�Qa��U|rP`�\# ��%����n[d�_�E�|<��k-q������d����(H��a�'�u��*�r��&��}�%Q��!ʅGV�m#�z5�/�T3E�ja(�\x������Ū�M)x?:^�y4�y���$q�`e4=��t<^��K��.��i\��q2��֑]Mk� �Ğ`� ���0�H�b�%�x�h[ø:����{br)I�i�D��K&k|����w����U���d��dx�9�=�����?J�"�ja�g8$�iaZ��Q	��m��-����艐
�XȻ��a�~Wl��:iv�W�]�����TIV�"�b�?ܳ����1�q�Za�J}����`�s)�Gn��t)�2��վnq f�cf�K�j��-d�����-�&�՟�vPV����-݋μ=����gG�|!g�ܞ��o��[��S�]kH�ěO��'�DX$���������|������O�����y��n��^aI.;a*�֒����e��4Ւ���)��~+L*���<�.���Q]VL�)��`�^�h\�90%�w�xȔ@%�V:������2�.�Y��w��)���GI��R��SW1��x�RF1�{���b!�LᐄT@���	��]����͐�����@���ǭ��������5�z3|t��go�\}c'�Y�
��Cu,�\{�1���w;U�|�^ݰ�}ު�qπ�8H����Y��!�:�Cυ��T�̗���v�|��� ,�Ґw(�kK����P�����jiYu�[i��Ӯ--�jς��t�*�F�΍\,ï��2�� �U��!���T@�����    9�^D��k�#:���'IJ��;��#ޭ�;���W�xY<4<W�1��i���o�X�*\H�βķ��j��os�B+�rY�7N�\�k^؁��"���,���:6�6/��prFr����@�9�o�q= OX�޷��_��^ 2	�"F#]7AE�H>���;�	�����N�ed�H�z�~9ݵ�I������s*r��3^nNB.��7�!����os�~���<�W�*͸#�/�vz9�ݥ�/��0'�v��*������W{�FE�~���	SɸnB�n��Oآ�w'��GaY;a�}������D�6���k0|��!����ۏs�L��+�ֳ�b=�̘_�t�>Ot�|�}uU�u}��O8
y\1�\r[�%�^���ZIH�������7����3W�~�?�g���و��`�5���p��؂�p�e���c�dĒȅ-�Qm����MZ#q��dG���aY�w�Rf2����Na����77w�#���HoX�]钝��	:e�F;<0䄞��A)�����d\S��&n�ae'�aUr=D�`8�%���Z0�+��){����������D �7�!FV�`y�ݦ�4Jo�Z/�S����.�W^D⿆�F( o,�f$4�����	�7E�)3�Qʨ��%x���|�б�,M��`g��[�f��(V�պ��X��"s"��LW���{�frXПVO�����vsFӼ#�׉�p��ii�M�v)M쿡�'�c)��bNm�� N�-JKs�%;2$�#C�Y�[��E����Q�I"�����n���Oq���n��Z++qٽ��#�2�;d��/w�l��@�J�{l��M#�+I��IHN����\���I����?W!��2Pf�?$�����de�4Ft-��K�$���|z�5ӌH�be&c'	��a����F�T$: ��&]�>�
 m����Q;s�7h�~�/*Uى����M��#9\.�g�C?^
�����>K��>N�ݢ��L�Q@l���أK1zj�Qs!g�9�����M���3�^��z���X��>��%)���ݔ!����|����E��q5r3p�(p�;���
����]k=���V�>ʹ�wayGPX?o+1��x��1XT��O�K�,aPd�"v�g,b��+��5%7�B
�5���JD%�ڻ����YN}f�h�f��T97��v�4LYWc�L���g�&!�H!�E
<��6��,pd)Q>pd<]����Gs$��r�I
��%Bc�+$N�{��h�=ǵIfD����v�f�2ɀe� ��YA��+ r���L'�о�~3,#-z�#�D�@n�ː����VHT+$x���-.ཅ>ʐ�F���+r����	G�f����>ZKUo����F��_V��D��-��+����.4H�Q[�Z�"���vu$#��2b($Vu<�@4r�k�
�,���Y�(�Hg\�W����o��}oİ  /]��k$˺�ҷH��֎d�$i�&�V�̒���7��KrQhH#��/�p/�rj�����&��O@9�
^����j��bihd�?z);9��a�6 Jb��7h�	�BW���̬vz�j���c^�������Ž�}��Jck��JCi@�S-�(CI��d͒������Ų7�mA	ڱ&�a���X-Rapzc�;)9s� ������p�hh@Dy�v+Aot0�$�1�m��%V|�{)1���~��M�c�]Ŗ%��O�i�_����2B".�������-ŉt)���k�%�W����ƶh��Z3sBυ�K�*rF�_>@?GC}�p�p�V�Sƚ�zPP|�W�+ްw��=M@��j��}��; �x�AaC��f�n��5�e<�A��	}�kE�`Nw�`�
�T|�t���ڜSc�3p9,D�Xr��ֈB�^z��S�h��F��Vr�Z��( "���J*�-�a�-1�۠@i��C�I�$�l��ʘ���^'��̔��.���y��$7�����:�������E�O��Xb����=�lQe�5g����������h����R�hp%G �E2�v%�4���w4�Yz�#���A�9`��uJ���Q���/Fl'g�|z{~;q\����.~��HP`I�iD�q� ��x9^v.�	��\���A�e5���{!�H�6����z�����b Io$���5��V��t~{bۍb^
F����O�#��ӐsEM����-3i��<����#�5xX�7g�&7ڳq�n��^���T��MI=�֊�q��#Ugъ a�$gɍ�%����\���	M�p�H!g$wGH(a��0*��6��Ĕ�A+\��h�nPnӀ@�o�ݰ@�:/x7���`������$DkOj$z9	Е&��ˁw�."g$o&�G1WZ��'HL<����d�6��
�����!(�r���� 8/�n���ƍ��=G��S��y`�B.ɌCFn�oL�7���-?V�mE*�����s�{{����|��ì�V�Ƅ#��v�&;8�����f���w&R�70��&u�YmJ&n�b6�U�˜��S����H��6Mf�4���rR�hnWCRQ��J!�f�囙]4TxQ��G(�=`�=`fݜأ>��"go��Ȼ�<��m.�싸SFV�]+�f]��Y"������j��@���������0���(�u���]t���'XT�̑���}�p;;^�V��̀���x)�J�k�8&�����5����&6�����P.�Ƣ�@��(<�`�F@FEL�	G�_ ����Xn%�li����ng�JC��ऐ3���?M�$�*��Q�?�@�����O�#���x�iY)J�����g�x���0�&w��GI�t$�H恋cCv�9b����?Nb-j�aSFY.��� Ĵ@�}��Ig*+T(� ٫t���|�^�}X�#�$���/��G�,�lcSS(��$r��t;�0F1�R_lo�8^/��8�,��A#�D.W��8.bdP$7Ǒ�O�>�{<v�Wzc�\rf./�-��y��(n X��2G��W�N8�v�)��@ڱ�l���b�M��5��X�S|��И���r)J����ٸX]9*����z��:C�y�S�k,�sr�)>ġ�f�6T�v�G�zi�z��eǫwƌ\�ѧ~ �28�b����Z�!ewu���(�u�ͳ:ˍ�eQ?.� �9�����o$/�i	{�|{��:��h�WI��J����7��s�A��Ee���FR�$�O8Y���R�퐡�%��p����jT��Vc�↻�ҏ�%b=0��%��7n��֊�X�������7��j�c���bq��<*�m��c�^D�]7��?͜yL��aܴQ���|f�B��,}<�����i�C)�|���p"��Y҈�����PPڸdu&{�{9r]�]�\�u�͉�T(ɮ�0��K|��["E��<3�4���vjc�[�B9 �M�Q*`��������f��@��4���n�}`' 8�2z�KU�7Z�� Yw���Qב6��AH
9�x����ق6Ă��u��t�X#�[#�:���2K�E<�aJ"����w�iy^B���#1֩��S�ֳ�����̐��k��ۛc0VoQ+����Y��e͵f�М-/q@�f�H],m�b{(���_tT���I��B��u�ֈÂ}īF����x5K%���$���iF'r�q�}9Kۑ�F	H�"^<(Ų�q�x�e���'F�ƚ�D.�����D98[�h:[,Ob���18 R�EN
@U*����RͰ����ӛ��J#�wۢ�bMd�O�r��81���u*��X��X��Q�~Kh��|Ewi��-i�d���{��=۬�����M����+�އ�޻eOR����	����D.\�y��$b���pu�O
���6[�sܘ�;r�ӎb�۔�\���`糁h��븄�qYNq�+� �>7z�;�0�38.3$��X��ÿeFu�`Xo    ��Kq��heY��/��,Q���z�B���ϳ�$r;�6g"�=̃w�����ӧ*�	��n�7���LU��X�� ����S�r!�i�����E�V�t���<)._ zg��$Ô�,!�.�� ��˚����T��ho��Ki6n����Jh��HMC����J"_�3$tqQ�b���E�$kV�����3EPt�{���r?t�R�H�!K'�
d2�t�J��"�Οu ��GC*���H˙ k�����9��H"1y �V[�QZ2��>�5f����,�����瘼�Y�����W\�����)���Nޥh��Ϫ��e�\�^�T���3�ҫ� I�w
7�D�o��G1I�N�u�N�^Sa���a��l�W\?^�`�C���EqdJ"(�7�G��`켩`�#$���&NS����eLK���d&'���� �p�
�ii��9��������M�ϫ�Ȼ�[�[ٿL��F2�l�[(��򉟦��/������F�e,X,Q�Ē�N��d �4�(}�܇Lϕ���d��?���_���O�(S�9��1���˓�E4��x�íW�`ӴqVrԊ>��C���\�"!�U��4vX1��x3�cjf%f�78��mFE+܂��e���g�a��h�9L���׬=��׸�+�~�C3e54����5�%��=���{`�Phm��P��+ƭl�t?�5�t|�Pt�u�ɝ��ΗNB��M$�p~��_��c����\k~g��f�y�2w�4�R��!�owRND��;>ڝ$$���iڐu�粒�=	��`%��\4]_�͈ �_p&�)�?g�\�L�.8\��0VaJ�x�z��3����|��]F����p��e�<�@�I	.v~�����zx�&'�#��ik�jr��1�����������bx�˔Lݏ��øL�"s0S'=�1�_��{���2��Tn������2��a
P̺��K(<e
��0�d"��uw~�|/
�� ��֫���`�a�K�n�ǚ�E��8_�Fjb
��T�����A���z�2.~!����_�yv�l.�V*ж�N���a
c_�b"�9H�W!,����ǯS48�7�~?�}C�$uc �\���'� �L;	�O��nϓd���+�IB<L���(=��x�Ƶ2��L�m�NX!�r����t�	�\
=~]<J=u���~A�T��yICI
vr�Բ��4�7K�aho�zw0���5�����_�2�iwV ml]۳cg���÷�]X3��I�_���/�@����#�e~�A�Xz��-BQq��i��g��H�H��ks@������'�F$����f
�ӵ+/�z�;yJj��d�beG���Wv�z���e��~��ǯ> �#ۨ ��q�v�u7̕ʣ����]+5�d[N�\�w�����m���q����L�+SO��S�d���Ų|b��&(Vc
́�S(;D�BY,�o����9
7��͒����w^��%��+����7#M'/rm	n3�	���Al�_��̗����O�&�NZ�<�oѡ���R�I������yys���,����ڼ�G�(��a:vX֣�x0$���h���3������n�'�9.�1��\�z*&��A�E�M� 7� �u����@�p[��Fcg�Hc;0k�ֳ8�_�mE�Q	$r�/�x$�&4�\�¶�K�YL�%��|����?��o���_~}�������9������V��Go'g���3��=� 7��ǭ��9!bc濾3tS�N���s����t�歡�962�1�3����ܨ��ca�b�ȃc[C��%�V7H&n-fiG"������?ϑ�E醻r=)	ּ�μ���y| p����y-�̔��'\��ŉnQ%(�i(�	6#Hq�Te���U4�v0D;93���٥?~�IE%6��X�j�j�#U��j��G�2�b���4�u�����H7�i'SC8;MH����������0��E䆤I�(��с����=��t?��h*�t8k/��sk���)��<J��M4X�<�I�̙�[�(=�&hm�Ck�m|�^�Ø�i��p�vvr��1-7.(5�\}�����O����ei,�Ɣ x�Z��&�}�f��e�2�����`
�h����
?E+ۅ�p���l+��Z����tݥ#&i��/=��l��̏���h1��̟�]n[T4Q�k��UX���
��5K�\�ȳ�N�/�S��
�Gl�I�c-4;nOV��_C�'�����L"�)�/�׿����aO�� -XW̹�Zr�����`��$r�������!�˛����N����f������s,w�9�9��׿|�����i �W��>�a��j|�e��$uL̓�֦o�ɵ�j��ţj��,H�XX��Ŏ3n�֏��yZ��N]�EE.���ۯ_�IPҊF����ީ�P�j*�^IO���+R� !�~�yz�/2�@����ji�ưֿ��P�o�k(�	�wv}-iE�n�gH��4����g�H�[�,&�#������\�rbG�d$��8��_o��eg������b�� ED���91�u�uY��k0�H��Q�	+��р�� &�k�}o�����c��h^v��h�i��q��f{�eh��sFS���/��=�id��F��S,�sV���ݼ?�MD�� �t�٨��#2Ȗ/�s�7�s0�Y�F(������IuY8�v��R�)� :0g���Հ>�N����+��ӫ��ͻ�Y��R�='�S�����t��L.���@M\��>�ꠐ�{ ���Qi������#}��4g��fG��1Y��#f0���2t�ڬ���8R�粯ݨ�{���ہ)i6����Ŏ�'bI�y��/�r���hP�F�s���g�e��"Cg�̺�Y��riC��{rɞ"��z�(�"��z��k} 5�����VFly��>%��a�n��X���2��c�2��K��O�CX�ڄu;�4;�C�&$0�G��z(��b�#hTE��wP
������*���X�#U����12t6G.g6��l�=�n���)���v&,~��uYܬ�Z�ܳN��u��u��\2k�V����Ow���:$��z����bݛػ7k��;%m<q;� ��Z!_��(U�8�(*�
��
��c�̡�8�iY)���ӛ��GM6��K�
���F'�|'��X��<$�<�8����)�k�9k���ReT�4��.���EO�.3=�*r��O�ۗ����A�����ة��Z��ў�%,�ҍ�ZJ}I�U#kr�.?������v�jj8���\�[���y�o`�?��O��#�7ذ���YU7��E߬��9��զxTU�u���O���p	�=�Kh�7��	$L�bPu=�Z̮�S���	/^W�x���i�ܠti:�N���fN�z�b�e�+U4����up��9�=�B�Xޟ��?DkJҜ�'�y`����;o�J:h�eL�~D!�� ��ՙ0�M(���5�������ܶ���O���@-0�1\�*8Z/�kЗ�'���y��Q�D.�����4eR2�;AƵe#{Ƭ�Ԓ�d�7қ��9��B�/���ܝ�1y�;��m6��l�����Qa�,p��I�F�Nρ/�\����K�t^�j��6Xw�-���I�-c�Z�����I����M��c�r�^�x��m�8 3�O��h�+���,��}
�7�\�;)��Y�F�1�2���Ѧ�մ6m�����#+��B�&�Ҥø�S�3t�?[�����sA�UaU�/��yѫ�h/=���l��R�#�#}٥��yЛ���AR
�Va︮��ـ��
Oׄ׃Y�<0�������$0���F���e������#���>�e���/�=x��mH?�ۜ���Gc�0�����\2��fV����I+�¯:�_�Ü��tzqz��"�M"����#�?',���Lg�����,{y1�\c�ZJ\1�X�D.�����; <
  �^���(�6-S{���"@�%��8+S���J5Q�Zܹp�R��n[&LS����p���#fp�6�2Ϊn�'�,6@j�|������?fg\5To5o��3郎�Rm��+��z�[Mj \�Y�<6q@T�� ~��S	ی�t��Y�LH�7f�&X7�.�\9�s,�*���`�x���Jwɲ�A�5���t�f��B�GyD�*GW��h�:=�kOtu	0^�A}r����n�������)ha;������O�&{�O�y7\��w(���8xg�G�nZ��*�@)KL�YE)���zx�*��>:4�cF�V`Tt��O���n�'����Kə��'#�M����	�;ą��G\{����̕[L�&sx��iۘ*��I�r�/-!��n*zKW���-��->Ln2N����dba��#�DN�ܤkA�L��U�����(LʄC�<7Z�:��׫�W�K�T�iǭ����k���KxکK�@�p�)�ǿѩ� �
��'��ʆ-x�(l<c�x&�;�sPҡ�Ux�B�p~:�%UocA-%���4i?T��H�ab9b���\!g$w�ReD"��K��	��(`Ͷ�+��d�b-��|�Q 6�̹�N.��|�~��P�_8md�O���t��I/�{�y*c7���!�m�W��?ú�\��e��ND/8;������	�@ ��X�c:�3Snנ�i|mOWLɜ=w~� � �޾�*S�U?�\���,�9�Fͧa��B��^'�a�i�&q���;}Y[8�n�#�D.N?~ZSô��SN<сu
l����e�YS���kv�ș)'7	�@!t���-�vwexY:�e�(��=}�Q�L����!+����������P�-��^x��9�e�����{󖎙)�~ۙ���R�"W�`yE�fSk�P!��<����L��I1�����s��*��؛)"Kc�e�4��zH����@�b��B]��H�����hr��-���B���HgC���z�b���KR	K��6��l��Z;(����_1��ݟs�#*_��3�G/@�؜7����Z'j x��X�RK�eK[����d�{��p6`��6g�TǓ�)�����t�*O2X��y��O�ޞ_�+5L^���&�4��İ�BT]�Kp̣�״鹤I4=�D�5����7>�2`	�a�8�z��I;��Y�rƆ7I]y\�9j1"���@@4���&��(�\�Z-����<d��Բ´��8QY��k�7�p��*s��	sEi�.+�̜����Q7�[���oց�R;�h鹢AT�%�J���$Ocr VYc9 ��t���c�L��fb`��x�
�����y:MW7^!I7�����rqMgbgh/��M�N�����pp��&%�+���^t"�X�TÙ��4WB1pL��}zu>:i����v
��vʆ�C�Ü�����Y�����T��\@d�аS6���ť!�)hf3F��9f����c(��I�iDC��rP�vP�#������\��j�@��yw�E�&��[���3�]��aY7�{���3�t8�K!_�ܾ�ƚX�����;�;3Dy7�1���g2aƙ	zn՜�W��)6x@]���B����L�}u�h�4X�B�����v�Y�w��U"_ؔF�R��k$���Qj����'Fd��(dI�L�:9t:yu*zfb0��L"0?~���w.h�ެ[�b�rh�����4�[͜Me3�.+�f�bZ,��m[�3eǖuMf���s#����\;LN���<���U����?����&��̡6�B������&��XzV[�I[���Ά����E�dX4�18�p�a{�U�rg��47�o��Ӧsc�*Ԋ�{6?��M����NS.��{�B���m��ʹ�hH�r68/�o�H��@@T�,Yv����6a]�٣5��9N�f��Oޞ�����y�R��;Q�s�p������'Ɠ�����`y}s��"�q�i�u���gc��J�y��*YF�y�6�;��P�������=vN����	��W���s�h��p�
��f@1@��Yd
�!X�&9��z>#��5�z���u�%��K~����)s92c���\3���-��r S��J"�@�d���1���g�la�jٙKĥ){�`f�M��8�1e�#�x���)���2{��0NV�hd%␽�ٳE�lً�&�L�9%�GR�	����8j�V���Y�.�W�x $h@p@�$���<�y��<7�(�8�C��,;�A��[,�6�:N��df!��~`�^Il��=��+����XR���-��nݦ�(&6%��aP$rF���5 �VL����j��`5L�'�����XL�gi�SV�.q����n����Q+v%�w5|:�Ⰾ�܆�P��R�.�T�7�;�����X�X(�ⱀ�����[:��[��}q'����'X�F{�\�HΰC?�hB��.�~��z�K"gi��Ç�5Ls��ش�Ƃ�ײ�)���M9	�����s����\L�ͫ�:���Q)i��o�w�}���?�S      �      x�̽ےIr%���
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
Z=o��!��!{�Y|��S�!w����'�?H�E!^��z��}͏���!C&��b�AхZ<P{	�n��>C�h�=�~6��S��>�΢i\��ҾmɎ����
~��¥.��Mu7��f��/dPq^h[bز&������(�ՍR�#L��ŵщ�!s-�X��(�:��g9D�;��9��~K��H�~���/g��R{��i�>l��̼t�q�z��/Yb3-C��S�_Yk�$j��h&�X�s$��)�O�Vԑ�@�0U�����^,�m ��yR�B�cjĝ�Sq�y$ģ����Q��b�g�����0���/�4��Tpl��n�]�o 4�6�y�۩K��^1I7�����j�t�Y���$	�����26��F_,=&#�H�v;��<sa����\3�D��s^� ����Kf��Xy'�\���;-�c�0���*��6y���j�0��u�kq���T*B����t r㘶���J�y$�	s]c͍gж�(Ap�	�Bj(]����=�ッ�iX��u������ݪd�oXڳŇm����3��Y�,-N�慞��O Q�D��O��}��U�!qF�_���� �vN�Pl�e,}�^��n�O'�@C���'"�ΰ�!��;A�ǘ ;Vy�\?P����sgr��(�e��ɢ"���4d��8L������y _ֆ��m`r�cVA�fN�w.y�_�����Y#��ۥ3� E����@�SE�&m[�xUr�H1�0���!����a|�~Pm�)�7�{9�5��B�,�&��I`�f���Mm�/a���Q,�[��a��P�g6mEä���1���,�itv6I�Lc�~��F��T�����.\vH�8��0=z z��j���!�n#��
e)τ��Lf@�}4�n��ݛ�wr��@
�j���n��L���Z�wW�.�?~М��h�P�F�����@�HO;��ݱ1��{YsC���飢Mw��.���5��Sq=j����hEᴝ(o"LEC��.��괡�s5o�W�Q����@�hk���Bq1�a�wB�A����"��^7�t�P�*�����\A�D�:|�ݠ��'��l���:�C�1D�_��cK]�����Ө8������Ĳ��,H!��udGz9����i�6�H���{Z�,E��m2��&���	�C�(渪��=8�����V:�lُ�Mݠm\b㬒���W}i=���$���x����E��s�t-��"z#���;IȖB�Ӫ
���*�H�<S�����+�PW^�ؘ۲���x?z�5�FH��/��h�S���H7������{�N��+L��*5:�d�>�z�����++���^4�"TC�B��♴��h�����?�?�@�wD�j6\�^H�`5�Ȅپ>���C"��
�a�ﷰs���ʌfiو���F���Bx|$�Y��2���j�v�Y� �}�,F)*� /!ݔ��+���d^�7O:>"1\Y=�#�թ �W�K՛ԡf ��E��eݾ��@!��n`�]kIc�"֏��W����#�g ��qU�FG��}ND�0���3lS^R8��粲�r�k �S��4F�[��|fFF�G��A�$![�6"� n{nƦ�1{��m�7y�ݾINO��);���H�"�4N�cS�7Tɸղ�ٍK��Z�ĄDL��44�y^)d�*��ˉ��yF�� $��R���*w���`]mFWq��<�����#�8T�fq
�>F����kCY3bh�6��Ӏ�aH�uH���=�ㄸ�R���BJ��M#|�~��Fkj���W n����v(Uq{�����	o��w�P�s��JX�W�%},��w����n��!�{:8u�BU�h�I%x�������ޫa+D�B����C2P� ܑ�,hܾ����d�yuҝS�<��GX%��Hʋ��KJ�4G�}!��
u�!G�g�#2�$ϗ:��4L;8�ץ�lM��3r�!/�#́�{��3tϜ�$�s�#�E0�H	sb�S�a��񫘍�I���Y�d�lE�l������8ߡc�94'��;)g����Fvw��9�;N��b �m��,z�f�Ӳwt�f����Y�M���r�����!z"έw�1�p�8P�b���Z�4�W�t=^O��e�ymC���E�<_���C��k^p�K�/�l:`HH#��7}��K�h�+�Ǫ@�o��,_�*��]$��m	�����&��!�sr�����;gb��2و�,��]��|�����\��EǞ7� Gې����#�9[�k�Q���Ce#�OF''kƈd?!��T�����.�t�D쐴Nx<��m��I���Q�9 �Jk<��G�|�G>{�m��BO+��%�����L&��J�]$�~�����ooc���e.�}qt����5�����{9�����Щ�[D�EB<U!���J����.�~3��˶�䧓��3�ȋDn�+Пf�C���	p�B*5!�,�m����;kW�2�	p33q��u���x�{R��q_W綳��c��`V��Ҩ�LFی���%6h9�89b�Ȧ^��
L����N+�����;�`��*�e|�e������[3Ի�&{XŘ�^�_���������Nu��ʁxv���N�#w@Fg=��<�w��l>k��A�A.�Xd��{8_}P���I�6�O�y� �4��roG�M[��õ��2��DA*��[��|�Y�����EaKXԀab��ĪW36���V�	P�pr4��hI���σ���?&X�G�6&g�/�"l��$5
"�!!����b*Ov�1.����7�fio����h���r�c�yl2G�Rl!�[+A'����Ǔ:e���9ǎ
��*�%���Qa	i�#Y��#s7`�1���G�������^/�_�cf�� �r~�C���D)*���y�޼��6�)����U6���H���}L�&��r[�qϺ9���6̤|5b7"i�
w#=��ݶ�Y�bm����A�ha��+'ҹ�ƝZ�ND'y$<V�w�Dq��Li�|nf'��2��HL�ͪ\�5g;���Tw�|'cF�\\�8�G<�z�:b��.K�J�� �<�����)�N�O1ܨ.�'�-%U1�"���`w���cF��g�ލdLB/qoV�aX���;(V͝�t&�^e�c̒�������K��D�@T�Ǹ|�1G��i#�⡢՞�yę�H�U�����.[^iv�:m衧�C�����<�a��9ḭ�h �B�-�5"��
q��s_LR�:�9��{�駮����[��k՟����41DI�5^��)�H�TW��MYֈaJ:�)i�>������VO>�2�mq�.���
1Mzo�qC�DE��c�a�ۚJ��yI,�n��՗�r�"�=}=���<�4�4�5��1[LG��:��'��@o'B�u�tv�@cA�>fDjDJ���t��s�Ʊp%�Q�e���4Df�c��#je��{[^"�V;\�W.���C��    �g2C�SW�?;I�;�Lڻ�_�H|�o�p��;���+����,�u�QT2��U���#��$'6-�� B�
q���P�(j�4`b;e�x�hg�ȍH?����!�l�&���=^t�|h��^��[�pDz$���*T�ʞc@��X���9�ףLы��Ke���3\�˘So�\I��|{�X���J���.�љ&ԓ$�He�L}�
�x@�Ȳԑe�dL��hk��l5�����1W=�����4�˘�0�<���,�䰈C��_����t��Mc��|	�R��.�q�Yxq�7!#�C#��I�㛽�.:�}��_�oeN�xwH���!O��ox�KL��!{Ϩ�ϫ�]}�0����7���X��m�C������k��f��T����(Ɓg��q(�c�͏�quV7���=G|)�L�15r�Ԡa�2���ǫ�2RE*N���'9%a�i����(lH1�a��"u�u!�U!u������j��:��Z'�ۯ����mF���_�Uz[ V��">�RQDCRE�!m���5���2��-"FL�����t�� \�]hq�6N�l�D���]���=}�q^����dᾲa�������Ֆ�sb��}s����p<��܌��N���Q�0H��&=Ou�of�Y1b�"-�
�K��X�TQ�_QM�"61�5�#F�)ҏF?BF1`Y�j�T�'mՖd;^�H���f�6�{�
�W֌���QG��{ԛ[����A[�lf&/�q�p�֘�a��jx���f�?��a-Fl�.�Q�/����������3F1��6���P�e��*f��������"+��L���L@�(3TNnjm�7���n6�V'8
��Ր�����(�0j3�9�}�����\�"�u��jBx����[ECc!ْadKd��͜��g�I8���49	�a� ��lm;�������1�5C�82���qW��l$�N�׮�m>��r��:����0�"B~(G�u�6mg`�S��F�F�x���F������%2���<�[l�G����+��=�oNb�,Kɓ� :�k��y����N�ߐ��u��Im��!zZ��9>-�Go!�1u�X��G���H?�GC�5ˎOFpM]k�q��mS4iE����ql��f���C�aj���ϕ%7��16@b��u2����a������m�i�B]AKL���Z���4�u�	�;Z�e6�_�0���;�x�q5�
2d�0���.���S�.��vj�8�&_��ȉ�ͫ��if09�����_���M� ����u�W�4Q*ٴrx���Z�����
ˆ%��J�144�^Q  �9��"!;boئ�nN?*iLW���i�r?G�.��4�6 ȣ�J�OJM�BZ(c���)��f���C^Pj�r�׈݄�*M̶c�����BcE�kۭ��$��{�icM����뷿���,[��Zdٻ�o}+o+�x� d����������M2<dWr�	�`�\!�,4�jd�����������?hX�X/@zU��s�Hc�ܢ��uv;Z�����_�+�0��Q��/�3j$kPP��ĥ3m����}���l�e����17��_����Wz�I�T���c�,���^�6���Bq�����}��a$�u$��[Mk�ɫ��bӈ�[=�V�I.�'�y��BI���N��HW���&���C������7}a0�U0áE����C�q{��#.%�?}�*'�x�T&9�Vo���d��(�.B������4d&N�-#�����)�iH��J ۲ʳ�B���	1=�j�vkKS�C�1�I�g��.�!F�`b]��ՄX.W��_~����_%hW�$@�k�<�ۨg��P��T�\���)$d0N������`4:A0��&b��Ь��[_%{��'���CTs�y֝Ŵ��̻r�Zp�Bj������&�m�Մ<͝h���Nw���ό��mްC ���g�@��-���+�J`|tA`?�\�S3ް;���|$��A쐘�x��\L�G*�敮}��N^��udj��Q�F��;����h.�(��ߎ+;��:�@7�E�1G\�e+��2���!s�SM��2LA�HALc$}����[,=f�.Lv7��(bc$�3�&/���������'����C}��4�r/4΍˙ƞ� OoB#Q�J��[�@b�������T�����|��c~(�1��_e6���/�4$�^0Ml��ѐ��H��=��Ҧ/���A
U����5��zʮh��}:QqM��(ȝ�����h�ZzC���i`2������p�*T��Y�M�������%C�3���v��ʆnA���(��[�MD��49��t�f!Ǻ�o21�k�:ǟ[����չX����G�F�QDx�{�:�[� 1�J�N�q�]�n��@Z3Vi�k������s�hE,7��/:�pP�B�	3��bc�;G�	^4�;M�����a�Ml��3�)�(R�N�a~ȭ��̢�qY���fp�0��UdY.5L�	/L�m>F�K����8��T�n?�,�oeFPʬHe1� ���]�����)��.`j��=O�=���Lj�;=�x�$v�PG�'�u�Zn��y��sԏ�/���!!h�a$%n��rw{���V�+�X���@"B3U)H�ͺ���7��70�42��#,���o02R{��S1��2�m�_�q��M�xk�R� �k��|���x��SdI0�%ᒍ��G��)Ccy�7_C8R/}���v��&wpq߰���F3n���w�|D�	AN�
��Yz0v����߿��}"��J��Øa�x� �!��qNA��cVI��u����Uc�,��v�+���o��׿�{u%�� o�a�A����{��m8x4e���<�c�Q�o�:�	O:�C��v�䔱����Gf���i�0'd�6	{����%����ɛ�@[)d�}W�C��������p�%�0��˿a�;�������@@��:!W��}�5W�T�۷�N����|����d��B��o�Q�2q�nD��}��fT0d̵���^+8d��`fy���]k/����f��+�g?ޟ?��	c�\�ws��U�-�Dn�i�����C�8E��!&�
x×p�
f��S��;]�F���&f�A��K#�${Q�DDY�i������A��K�x##����L<7���3��ӷ>����I���z�c�f1Y3����J�p�."+4��R���®�Y_���`Zie��a�M�"�o�H�Z����Kb��`$p2�9�������P#P�e;����Y���⹿W�4�B�e��#,I	��A�Z+�QZ��R?����!��Yطo�1�$V�z�n�E�23�䆭���y��{�
�zb�_4d�1ˬ�䨁�ݸCF����]o6Έ��Ù B�kHG��c��,!�Վv�#�᫫��񐑃�UI��R��/I��������;�-�GZJ9x�'n����YnQ8H�hq�~7�j
�T�҈�#���8B�=��b(�z���"Rq�K��*譚����>~�pG�!��	U&�h��Ը����1����=)�l9���,�b�1Az\4�,������\Jc�2�1����s��� 3�C��멍��ԇ��Aɖ��6Z����iǩ�.��cc5�5�@�|�A��� k�o2p��P�v�� �s��/a�[�X�l�m���m���PI԰{�0�Х!�t�ƙ(3Q�{��<0��`�m� ���?/��=9��|��ϧ�+ժ��.v��n�l��<�6�j�Ә�)����3 �t�;���~��g�f�I'ܪz�!l �����8�%n���5e*�ę�W%�6��vڰ@�@;�7�{�?�4&��c�5��܍�6���|���!}�ĕ\p����Q�w�������JN;:��a9�G�>볹��b�Ik9��Y��b��.��,�1�η|;���R� ^  ��Zc��aK#��3���cgv�y�Ls䱣�c9�{�s?�q�/�M�w����4傖�F���CY,;�u���Q��m� �#'���M��v�]͖7w�Qlj�#�u���w����a�!A��y.�)u�V9Ik$\8����/�9
ƱƉSr�p��6�F�oM�;�������3�3�V|�96Wu����@Ȯc9�Y�=������EӀ���������u�r�9�~H�:���nIwMa�Y�|<}z�h/�è9Ȩ���{���R'���mF"E3�7��ց<A���7-��W\JX�K9�o���Ot���U���7gV�������̙c�m�.��C�@q��nșa������y��UIU]E�	������0�]��'���cw.o����̄�Q[N�A*&k��/��6�,4�>G�
y��p�Zm 8H{eM�:M�;��Q�!�U^#��m��5��VD�s���i4ѡi������'խ�+��U�ǹ�lwD@��44�8���HZ������:e�m嘧N�����K���T������G	Fo#��!���jl��:��F_t��>~����v���ZQ7vR���o5�q��Ó�HA��!X'��|�}�L�ͥ�L;6�ϛ�v�-���&�E���x�%��2�,mv2��'�ģ���������0�Zy��!�W�mO�aSe�_%v�6�*m[od;�1�rӉ�`ޗ�����* $ΰNtz���:
d�^��S\�3#/ɕˆ\A�V�w��|�s$�P>��S��8�!W��	���f��7��I��}B�E`5yR�|��*���y����RBÌI�ʪ�G���u=&A�D�������U$�@[���U4�uQ����2e̭�-�ԛ@t3�D���_��Eo�qA:대�Bm�#��[��h�R��˖�Q��7��A&���>}�Y7���~��I.��Ǭ��?���_i�0gr"gꕐ�.�Qm���)�[Ova}j}�0�Q@>�&�s�F��P��ʁ��e�O��4��TA�͵�뤅侯᫓�S�e&�����~Џ8�G:j�V�P{౽e�{��t���X\Zt߯����?{l�9���!�u�W�U2�X__Ń��.35��MB�~1�2���#����*՛������C���- ������^��W�v�ctXhO�`{���m(l+�ϊ��A�BkEFr)/]&�u��7-`k_�f�2�x�A3$�E�[]@�뫼��ٷs#C����H̠9r��<ҨS�R�W�&f'��q'E�U�b!�i׾}Т�rcرr"K/�{�^­�F&��VZG͵�U��vEb��!7�x�l�]$W�y�mP��/g���x���uvh���U�e������ ��,+/H�d�x�Zv78ۣ���H/خ�Vƨ��l��$���	�t�fd}��,�n�|zD��ћ �O��/5*!!I������ګ��JGlEo��G?�w2�$Fƭ�����!#��d���}^ak<���s=�w<�==�ohȢ��0뷎��y�]IP��':4u�vbs�'�!���r<��X�n�T�{�����e�l�(��FO���K���l�A 6$$�eS׏O�j� r�QԔ�1:eǤcU-���;B�3m?���~�Z7��o�P��E���bI��ixC��8�jhG1��]v�����Pa��iU̩���l�Fzy�p���z�c��t��4�Y�9��{��|֭Kd6��mi��C�I|�t|,����d-Ф��9ϊl"��9àω�(�}LS����"9�A����W�x�Pb9C	An�cU�t�6�Q	�_dcޯ��4�c�����7�c|��ȴ��2{o�7�?=�~<�(�&i�,��&���6vN���vt���s{>���CF�at糞/LGP$�� ���ϭ�<��1�dv�P�#���ϭ���$���I<�򻉖l<�(�Ke&��?p��T�2Ҍ�򁤶Ǟ�e����N�\$��݀M���$}l�q��6dޱ�y�Le���)���?V�mH��3�wO�#�!E��k?�$F��y��M�cc^��I��N9?~R���y����pcixB2�QyBʩ���,8yȯbg#�7HZ����!��ߤ�Y�P��p������N�vG�}�l���	�]��h�m����z�2���<O%S+b�ʭ��q�]�>�$d�Zͣ�<^NkE�d����&0�p��!F��0�`9��s�![��x���.󨢤��]�a�"a���1�U��&����a7�@����=f�t�w�U��C���6�N�U�z���p�_��r�{5���Ez����Siz;3��JP����|8}T� d�������ޏ��*9�Yn�����q3��ovA������b	�����o2)֣���X�γ0��.�gt0n/�5�r�3��I,����p�-��~����t� ROuNII���5v���w�O�����~��� p�`$�`��{��d8[�!������ƶ�b�jd�E���,�����{E��ٓ��~�R���/�|�W���d���*�%j�<te���Z�<H0a��V��؁eY2��v�L�b�P�X�{�3vۗ���.U.5-�˲�l&�F�>I���"���iǆ*����J{�����|TN�hk�K�x���E�иY�(��3���F�ш�3�c�3��j����:tH�c�H�L'#7��>K���#ǬZ�����Pyp����� ��xT���X�J~}���m8�6l�C��~׈�0�e��Հ�<ͽIIt�!c�U��C#y�V�� �3�n
�1LDB���SI3�N�u�U���y��z���)��~:T~z��&k�M���J���T��;�E_���P���2�R����Ht��wyIuU��qQ���q�݅q#�#� ���������2�(A<��R��-��m�x�$���ๆ�Y�[{�j�{u�|Q9tH�ѯ���Ƌ��̶T[���'��r:#1��λ���׈e��?�1Gy����=��Ut�r�����!�+�{3���@w�T��׿�hғ<�%F�q�^�F�����u���U1t��V
p���
1�:��L��RbR0�AT㭭�� X��#ȴ8���[�>su�p���<$�rC�D�S��d>����1�y�M���I,lzȨ�Ylu
Cs�ؐ` �m�����&�.�U�9���{��\�Vv�ėQ����?!х3u2׻��`��(9��bxi���9���W�1J��P'G�A���*k������U���� ?�p�Q!�Y����up�bB��l���R��K���Iy8�&�����a�PW&�Ac���m�/�&��nfsFds���x�[&���"�
hp��� ϑ��h����5�P�f@�"ʻ�/:̀t-��l�>�l_dq]�-�L��4<[98}RD��
:#��љ�.���BEBiN�tvᝯ�R ;�3�%)��!r�M3��Q� '��#G�aNg�Kܦ�m�`�m��V�L��t��cG�������M[�c@���|!�9J���+*ޫ��6�ph��x��%� p^<{#S�46\ҺD_�!����ӟ�����      �   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh            x������ � �      �   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      �      x������ � �      �   �   x�u�1�@��1(>;^S� �tW����_�C;Z9����q�s>?��}͹_�wq+��m@G1�#g�2���Á�hN����_d�d���/̝xb<���q���b��K�����Ë��c��u�[�-Ŗb�f�v\��`�g4�i��y3�O�H�      �      x������ � �      �      x������ � �      �      x������ � �      �   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      �      x���a�与�W��6�K�%�,bV0�_�ٝ>��d
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
-Pl�#�x���Bԩ�E��&r��Z�NM�d:ܖK�/<8T(Fo�&��NMd·��A�Wx���B�m�$�9�C�(�D���~!M��6�����κ\n;8k����ξ����y�^��BM��m'���m'+f�m'k�m'++^xp�P���m�$Q�vpҖ�n;8�j���;Y������S����؅�=\]_r�[���,P�"���p�(���߿�?Qg%a      �      x���av�*���Gq&P^ �`⍠�?�gp�rU�D}�=Y�u���A�'��W�Z��v�s�rǟ��ߗ���??\y����=m����m��?��0r�Ȍ��"�����7�����-!�|�wW�W\�]�CY��K)�Mz����n�c�c^�JX����`_r��g�B�Qz������X��V�l�V���Bb		�P�
XB�P�ş�@���.eu�o�-��O��E�`�z,Y��u���m��"���{�qo���ˈ�eċ,r�WYĚ�&D�	��P�:��%�C	�P�[ ֡�u(aJX�֡�Њuh���C
۷�X��o!�)l�:HqM�ڧ�})_P��s��\01L�s��\01L�s��\01�_@b�RJ/����)�`J/����B)�PJ/����)�PJ/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)}��>PJ(���L���S��)}��>`J0���L���S��)}��>`J0���J���R��)}��>`J(���L���S��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0���L�՘|�u�Rz5&�Bb��^�ɷ����Rz�?>��P�}r�Ȓ%�KO��p�����r`�u�����a���V�Abَ��Kh���#G�y�%4��;H.[�I
�]�S:]Ń0���O�bk�;��;H. ��\poG�yg���#ܼ3+��#ܼ������$^d#ܼ�īl��w�XF�y���n�1�X�F�y�uh��w�|�:4��;H�C#ܼ��:4��;H�C#ܼ��:4��;H�C#ܼ��:4��;)�	X�F��r(���3A��*�X|	�X|�%D��X|	�X|�eK��X|�eK��X|GB����J��P8{G:ܒ�aR�<��-G�U��I)�X�xg�ؒP�:!�Ab����%�<���/ȧ]�ò�T�2�b�([{�'�%��0:�O��/�
z�qK�Q�H�}�'n�aq�Η2��^�߃�v'�*k�~��ܓb��]�9�5[���@��X�{����c��$^�z�E�w��dF��X�{�u�R�H����c��$�!J��"�;���G��P��=�g(ҽ�U(رH�.��H������H�˖���H�˖���H�˖���H����')wnEc���Hl�)��t��,X�&�t���:��[��t� �� ���&�"�;Hl/�kb,ҽ�Ĳ�Tw,��Ĳ�Tw,���[^e��E�w��<C��Xx�u�Rݱ����c�$�!Ju�"�;���G��� ���go}�e��H��6� �& ����\�1�,n[N�M���/�,aMc�|��������/�ti����g�����J:����dJm�r��sv��q!�����t��إ�KV[b���n먋��VW�v�Ǹ�MZl�����?d���Ӳ�O�{�j�u� /1��g���ׁ�Iҁ�]1��������7H, �G�#5��TvR�ǩ�kt��1�X�4���ş�@�U�<etR9fbşTNpƚƂ��5���:��[�_c��V����VO�Hl�4����6�-�@���|Dw�0�X�4�:�y�$�Ȱi�%�uH�.H�C�w�@bҼK��]2�X�4�:�y�����}�wIC�9:�G�a0�
��0H�P��%�5H���L�%DI���` �l)I�3	�OR �*�j&�!n�0)e�3�r$_�x��>��8�%��S�D0�Xo)	��DG�g���{f��|�_%#1�=#`\>X�(a�#�$�=JX�����׭�뤰KZJ	����`�F9��L` �ZR�'H~z�jI9��L` �Q�'6�k�>ʁ�d�&]��Փ	$\bz2��Ģ��YO&0�X��w��˖�n=��@b�Rޭ'�@�U���:[hJ��dÎ`�R��'��� ��z�d�{����)/z9��H,[ʁ�� �eK9��` �Z��UO	0��TB	��` �Qª�H�C���)�%�zJ��M�}��z+%�0��)��?���P�^��w����_E����=\D����|���{�/h���~��_J^�'aa5��Ѥ�{
��q�~���bU�<������=�%���'NY�*N��@�@�@�U�e��A���|�pʭ�?�w{t��ŋ[>2�����]ym��z9q�R�q�Eͻ���i��'�~�5ί�ヮhT4�ׁ�	@��~*�>�c�?{A��	T��:�.+-�ZR�CH���BHU@#�:�n6=Ӂ��hK�����ӡ�+�"Ӆ��+��L8j<��c�уZu �T=�U�1�Y��Yu [�z4��c�gG= UR�gG5U� ��~³���/b:DxVգPu�b ^�t����c�f����SHuU�=Ձm����G���eh9}��LGH�F�6ӁTo�K3H�?�FzԨ��R#=�S�q=w��|�㺧����I���Ӟ�ՙ�ҞJ}igs~�����/��X{����ײz��ڵ~���>ۓ���PHY�P��[��A�2���5�C{�]��l��({�(�a�ݹ%��2֠�zX,�{����ޕ�y���k0�sRK�t`���r��~�ꘗ(ku>��w��2���e-��r`��88�{<�l���I��9w�+������s��]]{(˶f_�����?zXR[�/���W�rq�l�7��e�G��A9D�c]yy�A/~�!���u ���M��ׁt��.7=_?X⽁�F�妆߫8&=�^ҞB_�@��p����:��=�]�1B_�Į�@_����h?�ף�U 5o�ǧ���K�����u]6X���ӮBo����J���Xw}S���z��Ħ�� ���A�:�Jz��w�w ����N�nׁ��}Czh���	�׮��@���@�9� �����A�+��d��?���_�|ǲ���;�� ��i��lW�	dO篏��u�'���/�D����G_l�t篏��~�X���ǟa�}^��î_��������$�0�j{�+�s�"��j�e-k���.4^����|�/����!�0���m���^�	R�ڎ�8�4�8P���z�>lGt2���Q#љo�o^}	R;x9oݹ����>��A�e�uq���������K��%��!]⚣�`pZ��p�N���z�!:y{��	�z�l$�f7��F��&6���ײ%T:���M<+]g�����5m$�Ϯ�ɖ-F�N��"�av�G6�wn�ħ3��z{���+F�Y�z�l��]A&��ұ�x�v0l$6~]υ�Ľ��.l$֢��Dv}6K���m$�P�l���.k6��TG�$+�H��)�
6���%c�F��,�H<NzxS�l$�zx�g.؟�@�Uz��g/�����3�[���&'=-*i�8�%��L%��Fb���2��^2���e3س��U�H�%4أ�Խ$��X��פ6��m(y6��S����A7�w���lo �dS�����`���&�H�ĺ��6��	��3\@[���u)�ŘF[|�d�-�ի�R�ERYD����l;���9�����kM�-!�Y¨c������?-zč�1~�����N���;O�]���P���->Z�W�/-�����(!��CG��-n{�����s�e�̏ڕ:��9���\�C�d	1�0�=�M�ɥ�w��n�ܸ����m���ŭ�}|Z�|�b,��0�&G��S�S�R˷/.K����zE�gbjY�8�<J�{q7��F⽘zĔ��x����~�	��Q�l$�,��)�6�Kꁒ�`#�JQ�l$'��)	    	6k���s�OR �*��J^���F�����	��Ƃ�~?%;��u����ר�(�H���i%K�^��bRo���`#��º@�pJ���Ĳ�~8%_�F���3�Srl$>�PG���`#�QG���`#�Q��$/�H�C�?*��7��Q����B���`#����`����l�~/���f/���Q/���f/����:��߼��'��W?H��ZV�wj�'5P�~si�m~�7~���%�m����7�~����V�c�q��Ŷ�>Ju��H�����8t�l0-���G�1�=�=�ŭ������Rok��V�Fݶ����-�� kC�����ӗ��T��诙&���-Cq[�d�E�����5�#�:���{�@e[ԁ���@�oj�R9ZH,ZͅgHH��6��gEsH�M�l �|~�������Jr��W�J}�H�ln���3��	�W >�J���ĳ"���/Θ��c5��������ݟ���g �j��q߇�O�mF���3d�=Ȅ�߱*�Mx��ě`RX���VA��Hl�4_���G�/f �QM4Ĳ�|T�V�Q�ܨ�|TR�ҁP>z�����!=_�@�qB˧�H���|!��I)��/d �&Pʡ���@�U�U�|!C:|U�aR�����H�6�8)o��qbKB���/d ��j�B2=_Ș�VHGb��/d�k��` �iq
�����B�ʍ�|!��A竚/d�)P�2xy�B��}ۇ�=��8[��I���id ��YO 0�xqRr�';��}�\�	:�GO 0������	�Kꁞ@` �J�$'��z��Ě@i��@`|�qW�u�t$6z�ϫ	ƚƂ�� =���u������'H���KK=��X��bR���@` ��º@���@` �l)1�$��:��\O 0��DC���@` �Q��'H�C�?�	��z��M�}�?z#����Щ�'H�����@`����o�J�!#%�����@`����	�NI БЧ�'~Ԋ!�P%��p��Q�X,�?��d�Z���t��	{��O'���9�U�� |�E����m������㵵�Ommj��Ծ�mfk��6������|�*�ڷ������)"�f��T��E2����?|)���uOq���7�|k��̼�P�P9[|N��q�͝ڙjd��.Nmm�os�6UlSח�S�VfvM�N���7)nj�f�yf��6uO-S�m�m�2uF�L�y�)6?ՊoS���0uY9���\u��'���;���T�����\흻�O�^?UC��9����OՐ8w�n�S�M��T��B�ܾ�=�N�S7�`9SnS]��t�F֩��*H�jz�\w��9�S�RS��2�h�n�S�q����ڛ��t�&��n�i�&M��S/��}!M���Ե�N]S/f��p�{$��oyjߦ^h����:u-�S�B���ڷ�׊>O]Yy�.���m�:���Ե0����]<�ν��]��JA�[����M�_��^���(�w>�2ܚ��7��|-hT���r�{'�M]e��������T�V��S��|�j��TR���ܕ5UC��ka����˱u�:�zW/S��dj��L���Q+25jE��{e�u�L����^�zQ,S=f2��S�^��P��Wm25�I�^x��x��q02��(S�jdj�L=����S��#s�O�^����S�zF����25.O�^���`�V#soc�7�Ԁ5�z�+soc�������8Uߦz�e���L�ە8w�s�!SOS}52�;���S=�2�O.S�!2����7�aj�_�{R�z+S�e�}�L���T��LM�S}\a�)��`4����X�C�CX\�[��KK����w�_Ju K.�7�w)��Yt>��\�v�p�;ɵw!�8��|��\�,AR(�W���6��snw�V\�!����_o{'n?���8`���߫IM{LK�[upk]��|�F�����ĥl%ߢ���+�G$Sc'dj\G���So@�\������n��ODMɎ˖Ö�S�ە[�˲�q�f���gm��L)����n����ע�ewiIk�d��C���_�Bd���_�&�n�E�=�&��[�ՠ�u-�!���*�Ul5�A�a{��$=�ʓA:P{��@�oj���씁Ģ՞75$���m|ϊ������T�3�|>���u�R����̚�W�T�-3TV{��@*���
ħS)�h �h�$���N���^5�ؘh��򤒁īE+�h ��R)�h ��o�ZqE����©���O{��@⣉�f��T�+H,[��O�e���il���i��oB+_�(�#j�	�C�Vq0�|�����$\czqE��I)�^\�@bM��C-�h|�qW)WQ�+���r�\E/�h ���㤼A���8�%�|C/�h ��j�$d*zqEcV��u$*��Qb�j8H�AZ�w�p���ʍ�⊆��W���q�@����T�+�Sy�ۘ�8��/N�8��ċ�Rd����ċ��k����3pM��GɵZ\QB���$�,��zqE�%�@/�h �Jы+H<NJ���k��jqE���
��^\QGb�G��Z\�X�X���W4�u���-u>��$�q�^\�X��bR��^\�@r��u�s����Ĳ��\/�h ���%�zqE�O4�?��$�!�����zqE�u��G����M�}�?z���aq�SI/�h ���*��a��:R+�h|S)�h�H)�h|S)�h��҈Z\�8�)�u$�i��u�S�+z��-�����'�V/��#��R)�h�{ŵ⊆li$�kq�P��z?A�oe���[��kY�P�7�>A�n%D��jy��4�E��Q���>%lX�[עm�|��Ƶ�"$kr#Jx-w���z����k�OPh�!Z�	٧k��Oz��c�Ŭ� �|@2��I>2i0c��KP��(4�@z�C�G�t��k��O��Dx)@�I�4"R�Ⱦ����4���gʳ�"$��aٽ,%���w�Ǥ�U�~���~Q�׼�j޳��F�p}�a�����R�̋۝[BY�ix�hE��)����?��3�/a�J�����ks1�������\
2>T9�x�/~4W�TԌ�uqe=�7<���x�]>�����JU�G�$Ӌ��.�п%��d\x��i�'"�Z���� �BM����\�ֻP��ѭ��k��:����1U�I�ď�����ZAh%��K�-�Ԗ8�t[ѩ�yx��t�..�Y!]�3����N^�e���\�`ٞ���|�\�w�)��R��z����J'��%�{$t8K�� ��g'���	�+�=r�yv�Y��WF�B�>��Y+ҍ�Ff���r~^K4}�B�&�q1=D���nd��߷!�$��t��"�-�����aAU�F]
�|�B�ߐn0��4
y��M�%a>A�t�t-��	�ɐh���H�s�Z����t5v-R�	
is=�� A�F�-��� AN�k!�OP�r��0>�2i �@w���ギv]>	󎣫8A��|������|!���`�':�d�X� �����'(f���Eg����ß~ԏ���{�G3;��!V����◼����g��G]�Ows����t}-6��sǍ���0�V�Jt����I8obZ�p���s��\��=]�n�CZ֘+�����X�_�;�G�K�V�ƻ���7�[w> ��p؇���ں'7�q��1\����'�9(�}�gs�� �7��;ŧ���zqKt�&۸�Zc��2^\��^�����A{(�L��S��O�#L���>����:Q�W`����I�d�E��x|��S��m1�\_���%���C���q^�][�l��/����\��b�����8꽬����:���a�"�T��ݿ�*�.���?W��or˶�������[ן����%�2�u�~h�#�R��!�/��́o���jX��>L�A{w\��f��D��@B;�ů��sWo�ö�-���V�;��4�����z\�@u��=TS1�c~�Zk�+H�M%�И��S� �  ����β�8�,[^�fL���u�n7큿����c�~���"��}ʱj�ps7�/\�8=��n���V��$Jʪ11����"��S�k���$a߄x�E;J!�Z�Ŭ�!�K��A:�Գ��V�d���ChY �4��U*�l�/k%�/�'�j��ݕe]S�^y�ɮ�k�\�i�9-֦�|=(/�H���K�M�����.�3����:?b�>��
�>�-�v�o|���W�X��Ǖz�7L�rW�k��X��Q�j��()�[X���9�{Ԯ���ݵ\�z8���ޣ /N��r��6,��!��T*/��� �Ԙy3�m�q���S6�Z)}�{*i�c"�B_����$�v=�c�F5G{���^O?r��n��Δr�ti;θ�v�R#z���е\3���{��Ͼ��J��3��'ߔ�5r��׍�0�-1WFͶ�|�>
�Ά��f[{�@��Ҟr1�>(hu6�o��ZgCB��u6$dsz��ǉ��h��0�p��u6$'u8�u6$��R�l��@�U�jQ�l����Z�Qg�-G���X{4�l�Ė��s�Ά��z���0��4�u6�YQOӑ���0F�5H{��@bҞ�4�xg`�3u6$�%�m�u6����:����:��b��F��aL	^��;�/N�T�'��z��'%�z�cg�������@ɵZg��"�O��0��iy��<`Z���0�p��u6$'��z��5��r�Ά�I
�]��]���#�ѣ|^��a�i,X�����0f���-u>�u6$�q��^g�X��bR��^g�@r��u�s�Ά�Ĳ��\��a ���%�z��O4�?�u6$�!��:��z��u��G�Ά�M�}�?z�Άaq�SI��a ��ת�a8}�:��O)`|S��a�H��a|S��a��9�u6�3�RgCGB��^g��V�*u67j%����l�T�lj�P�:Fo�W\��aȖ��^�u�����[{0��~6�ث�a�:5),���,���{�/k�<��?�c�n�X���V��Lt�5,��b�,�UV_�}�3��3Q�N�	�f���4����6淐Jݿ�e��6���!�/fl���E�*�4��3���}Ư�B=�α�x+���27l����~ ~�����/��[Ǌ�*�KvL�i�n�]}e)��n.�}��@l�|�/��mq��K��\��ߛ˵��'�E�u�<�c*E���:�3�?>$����mO�Hʛn�;+�ړgs��_3��*���,�8�q���:#��7�m)[Z�6�h]�E]:)-�]j�d\�ۆ;�S)N~ӟڐ�<���&YS���D��&zl�BG�g�Mg$�����n/��$h����Ps���\�� ��XZJ}ｾ��_��o-�Z��|��]�Z��G|)�p4�jn��$,��tI#3��祩s̱>`����2��g��|��E_$�)��,:S�{��ZW��������,��^IJ�bk�n\�����oR��[
>_d��1�����{������P��ߙ(�s�F�(t��/a��A~�N����#,��kW&
���[h꾈��-4_�EL���7�Li���/�`��,߿Bg�Ъ�/�`��,ߗc0Qh���1�(4���
&
��}a�,�}a�4꾰��B�q_X�D!�߿�h�����6�E$�)�`�Э�#��)�`���V0QD{;�,rw
+�(���L��-�)�`���:�wJ$�(4����)�`���˺S"�d�L��˸N��ƅ�N:%L�/��;0QH�̛r_���^$��b&
���b&
�2��t��g�S�����q���4��{�uصZ��o�`�F�]�������yD�Ks��ϴ�\K3�iu2|s����Ŗ������k	Z�!S���?����pp}5�]�� ����������g��H��õշ�B؆o ��mj����Z�w���|꺮��g+)����G��yv��Z��]�-��]�V%��ZY��]ն�U�A�%��kW7~Q�5�=�n.Jv�Z�9���Na��m|���)V`�ma�EL��\��d���N	�k���L&nE��y�D� Bv��.Ɛ^,�k����2��U5����H�j�ߏ�T���(�m�Wj���y0~�ևQ=6�$˱����n�6�k�X# �W_�_B���vq;k&�׫���?�./��G�rjx��>���0�{pK)9��1{��)��+ww�{��dk�ZP���ط��$u[Ƿ�R�n��5n����=ٵȅ��y|Q��D���V�{��S/*H�\8鼼~�8�ʸ꜕W����.��O1���ՠ�Ƨ���y���hn��@���a����QD�[|�x�����nx=�������\�J���Vq�j���R��bpډ��9�-�q����U�����������s���^�����◸&�(�i��D���M�ڛ����uR�g���v_o���s�8�>�a�X���oWE�u�H��}�1����%��,�.���l^�xp��՚*�;�i������^2�|}�ߜ�.�GsK����㗴��YnO�p��_����cq�r�OA�C��s���-^�'�;�o r,�\�'��kRؒ�?k��˼��V�p�n�q�����yH�yZR,�m�Q�u�W��#J��N�2W�<�؏����R�<��C�H���u����狭R��&|�P�[����n�������/~`�b{����%���)��IW��ֲ?8�ė��_�~�:d|��rw��R�1�oj���aD��-���^n�m������3����%��-�q~�dq��#{$�z��a��P�R�Z°Z��(���Z�JZo�{[�Oy5t�����`�=�      �   �  x���]��6��5�b�@~��]�Ţ�Aw���^XhleƝې����Kٔ�!�؞�@��N�P�sH�G�y�=�N�w�~��ޚ���F0!�c�;��� �������w�9���n5�ݱ�1t`����0�y��`�_�+�ƺ?��7��@�כ#!�y����v�=�L����i���wT�zUDb��1!B�@�"��Yft������5���(�7�3�,X�fF��g"��(����@T�e3�l=�OHnVD�7Z9Q��YqO�q?�֧��fu�{C�kml]�!�X���3�m���w�㶓��f�>�۰m�@ �t,!F�x
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
-k6i��:�WR$d��%,H�LXd�Y�y�� ��L0�kfrb����X�f��� g92O�yN�[��@ƪy�3��NC��E3���^�Ma��"n�m�HtO��.̄�Oi���}Z: ��������1�      �      x������ � �         �  x����n�0�י�Ȋ�E�;Nv�@
���@b�+��@}l'm&_:T]�9�����84P ��`�|f�!�pİD^���~��K�����o?��x�������pw��P.���64�bS쮲D���ה'އ�~\�1Ⱦ:7\>��S����e��36�h`��B\b�V�W������FG�i�e׹����3�Ӷ\�V�c��F���C��Ď�6Aޗ7iT���Y�R���w?�eĲgZ�ʉ=�~��b�/l�v����s�%�>w` �s�:1����Bs|�⋈3�����G�x\q�"����%��`��E��cǈq$^
���?*�ؐ��,�t�բ'Ҫ��@4I<Tsy�j�('C7��4oX��yj�X~j>(mlJ��6�3V��*�oo@J�f �q;~:�U��Ԃ�$qnޘ�I�Ra{X:}�Bݔ��U�i�Yf�qDeSС6�ڤl�JT�a�C�@�H��л�봨Tr2&�G��=�:9ж�Ճ��O�٘��7
��*�j�i!��2�ꩫ7,� -�.]��DR�[�%bs7�fhJq�$ߟ,?�t�-��A$���"3*�7c�X�R| ��@si�}PS|�Q�Ő���J��)i�I*�Pe޽~����b|�r����ç�����������툃L)MJmlS�W��n_�,v�j�N�Dz�+h�tZqz���dpR�J�ΑC	h��ȝB�m�m3@��3�	(ډ4?Vĉ4�+�J��g��{�zԊ�8�ZU+Ψf�``R<E�WT\&�X�s��vq�w�S\JqNl&�C�>/�ܡ_t�Z9���v�X^.,H)��X�S0�\�M�+�� ��1���]��m��]F)��"��I�iU|!M��:(��<��H�C�|y	 ۶�#           x���I�7��U���@��:��E6���/��.I5��1���5p��HnA��ǅp�?����%:���}�_�7L����K�����?��a��A�B�A����E�/C�2�G���'�{>M!��28��'�G1Ai�����g?u���w���C�:Я�g�5�������O��m�o�?8O��q����Ax8�i ��A���7"� �#J; ��x�)��׼I���{�A��{@��j�|l�<o�¹�o���:k�h�����q+����v|%
!V��i�t����3wG�K`�QWm��=]&1i��À�#�	Ó�yxA�bS�D-(�xgb������ۦ}��i� y�� �͂�0wRvx�e���'�\([@"TVLԜ���4Jf��f����^��K�	��%y_�6�͉��X�� %rJX�(:E�5�2�$N� �h�X(34���̡A�-3V��Bc�J�$ �����Ǭ#TнL,�^������ޱe1'���d�?LB�C dg�|�h�)L�Nȇ��>��~7S��^�T/ a�y���E-
 ����y\� ���3`4K��PSP��-}�u R1�X|ZF䘶�o��B�.e8S_!x���N�g��IIOy_�x�\�����������W ��]�A��N-D��{zq|�Zu[�����*����DB%��\���e��(k$�:�7�{o�g���>�-�r�hQט8�=W��hAd���b���&�/�h����!.fM��n��''�{x��`@L�(,�(��_�.xp����W��[2�6'|ĢBsk��%&8�~��"��kbQޭ�Dp�^�H�
$���6 XIup�/G�  ��`��L^��-�ˋ7�|%2��=f�.�؝�d���E嵂 �<g ��ψ���� �s_O��J�=�Ȳ�Z4B]�����ԫ)�=��y�-q���� Y%hѧ��\#N�>M�}Ф���7߫������]�i��ۢ�Ǧ�o��`�~��B���(b��IR.�I�!��Z��8B�Tj�'G.��=+�vĝ<�h�� �DIi� �����F����~��-��E)YMtӆ�#� �-#��&�7�(+n���#�l���ޑ�<���{G��m��#1O՗�#0U�{���t���������}y�ޣ�?���XF��2�R"Y����m��i������"��E�Tc���X�����ǁ���.�H_�q���{}�Ɲ��y]E-��� ��{W�D}���qv�>O�z�Z?�����$��Y��MM_$d5�YI?�E�z�|K-#���l�5\ן�0��3��Z�{�pr�<6���ؒ���e�H�����{}���@�y�n�V_�G����ئ/Z�մt������E�vK$��l���?������T�T����fHV��֗���EW��2X��2���ZQ}�/\�m�<Q_��Y�+[�+���f�׊����ƣ;HyWq���X4�����1�(�Q���I?q}�/��O,#}�O�������[f��u�~e���A��u<����	�H�v��#���M����@���@���µ�ECaC��J��[G4=ˈ@�.]�&����Ǡ�y1b� ���&�g�/�m���ݚ'�W>?r�Z��1�=���f��1�>$�r/N,,4q�<:��/�-c�]�E�@�Q֤��L�����3�G��El5����]'��pX4Bn�e��oy�&M?���y�A`���e�����<A��͉J�X4��z��Q.É�����|�v� 1?M���Q��_�~b�Jδ2���>A�:��_�����-Ǔ�@����6}��"����k�9�N�`@�-
!�F�b�e��nwF?$���P6��Z4B+�ɣ��N�*[��E�"��z��U�V�B�2��| ��զ_��9ͦ_���n`��닪ΦO�8�6�~����j� ��&����������ή����ZF���K<��?������      �   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      �   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      �      x������ � �      �   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      �   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      �      x��\k�,���]g��;���Qk���c�$(K��t���P�	��T<�Oȟ�	�����������k��1�ɰqP�'eJݿ�*5j�(����a��T(���a�^�5m�D�J�;��{Pj���0P�'%J�ߴ3���4�T[2�Rϱ��NS�kH1P�'�i*�$��$>M�w+{x�d>O�7$���W�mN��`��'S���7�Sl��'S�ϡ��a�ʈs���a���{��L����\؝R�7�kX�^��)�~��^�O��Zܷ6�_��1M��k���ba��o�|1ߪ�?�H���T#>)��n�cVm"�)t��ۿa��4�S�S\�e��������u>�6s.�0P�aK�n�%�)V�6s�h���ĵ�sl�a��^/i1���*m��z@1��8��:�z^��n˰	aN;��ݦxP�v��sl�a�ru���6��:u��)n�u��?����}y��0�z�P�v[�رg]���_�׆Uφ���b�b{udC�t��f[�XV�hX��c��pk�11�R�h��bMC�����-/100�)@��V7���:�8��l��l0ja;�5��zQ�O����܀���7����_U����)>"h=�%6X��3���Kj�R:M!��0Pw�[{3g��U�?��֬|�p�@�Ŗ�Mg`��3�f�}k��nc�|������baxo]���8��\�궬��0�>��v`�9�K���f�."\�ϫ�9�K��z�wuq�t���j6���̹��էQ�a9nV��<n�;���{��|lٛ�^��"f8�%,���<˕n`����A���=�a��O��6���ylp��|`��{YkV���p5�"vkZ�ugɅ��mt�0Muuv>Oq�K�nO����ʺ:�U�p�|��B���OT&s���X��t�Yr#n�Y�t��3#��ȩ���7�RG8�.�Yu�nu*ͤ�fe�%U��y�c��|�͜)�:_sX遁�N������cF0��Қ�%�50Pw�8���R3�^B�KC��n�\��-N�jx��[Ϥ�x�0P��C����9<�syoj:-��גo:���<6���)N�R}��6�1��E��%>֣ΰG�}�u��a�{�_�:-�Ɯ��NK���~5�S0��8��yHfp_ڰj�״�8Ňk��z���޽V�;c.�k+w�V�S���cISL��jȰ���@�d͖�����d����c�ϯ5+C�]%=c��a����U�*9\cм�|U�#-u����Hp	qd�{� "Iqd����)Z\�jm��*��DD�����V/�׆�*���늆�*��c�5j�GjX沴��*�����e�z�����U�2Te�-�YM�0�:�p����^b�k��8Ұ���$�U1��ҩ�b侶�t:e���Nlkz����5� @������@�Fq�i:�4]h����!qM��T�)M��-W�0P��v-�r����N*�6�2պ��a��c�ѕS{��ʈk;���nS1�*j��S4�:b*���k`V�L��ؖ�ؖ�Xr���iR���%h)ARXܗL�� �׃���m�̅�չ\�y$+���ǳaиO�w��>�]��w�����w��a����r�E~�G��}E(P��j�IjW��m�j��t*��6�!RM2�R����$1W��00(:�;��*���$|����`J�K���)�W[��
[=�$Gp�xbf&x�G�>Ef����RE30�J�X���A[Qɵ&Tj~hA���z�w���0I�aө�����]yq���aJ�o��kʯ�����a������z��}#��Ԭ3Rҕ�ޫ[/�m�?��(�@��J�[�0��R�K�=G�mq�T���p�S)?�^1�,<Z������p��D肑ˡo=S5�f^Ю�.�������CD��!5�6���iJ�T6�t����E��1�z(�)y6��<��f��R�^�0P�8oj3��7TU�v2��5�C�Z��ꩌ��!�A�����ͻD�@�Ek����0Pi�Zo�tj� �B��Er`�`X)���=T:��f�6���Y��ֻ��O4챰��L1r ���r��̫2�W�Q.�r5��0:"������Wm�'��	m��J�W��ne�Z>;���׌�w���FD���H�Kh�:�a��2��A�WN�z��j��3.�b�[�^x<{�>]�}Hk��:d�,�fLRc������00E ޔ1gS�.�30�e����Ie��phe'��n�놬��P�0(W�b��h�|1O���ic$��5��Բ�K�3k�u�m5�{H"ׄ�5/f2���H\�f`�Ue�k��2���*�5�00HO�[k������c�Od�|��W8�ǀ���Ɉs�,��Y�t/켓	uo-M�R�[K�IE�{'�׃C���Qc�����x��������-�s�U0���u�*�py�G�[woN�AfP3�I<�9p�q�� �Ҏ�ϓ�g���]���\�D��9 S�=��C~����K��k�70(OR�|�ac�Y6�i{�AR������[�7m�DNd����+/�cRPz���O�YN"�`��<��ۚ�ĳUJ�y9&�r��u��UN7Ԭz���L�@�Մ��W�vK?�H��O�����m����0چ��ȂW��<�q���0\��_���65=D6*F�f��o���J�`J�+��3�w�L���00�|���6���.sy ��d�a�R�X�A ��Ӊ\��a���e�.5��\?jxS���g����z��WX{g�\Bb��u�!�,�a��9�)G�]:�s�f���0�"�R[��a�ԃ����i���`m�{-�^e��=�rߺ���>\�/�.�<�ǒ�*������fy�u����愓���~�_��*�ARq�'�a��=P�Ŝ�y�w(��r���R�vMu:�a��ŕ�����\$�c$�b7�GBC�lٍ8��($�9�Dᆁ*�e�F,�ވ�Gm;��K9�5�#�հ��#LZ��{<�^�|��0P�~"��Գ��,��m[��l��eMu*~���IݕDG�${^���	(�l�ՙ��(N
���0��#frj.&��10��A\�0�Z���fnu{TD}��d8j�b.Dh(ݜP��{-dqJ_�r�x�R:�z��Qt�jS����w��7�A�!�M���0�F>B�Bf�Oü��GHRș��;�?�_:T��oH��JwMa��v��?��p)5�){%��=y�qY��=��Ǹmc��5P�d��]�mV6T.5X3��ˎ�I=�#-���{<����d?5�J�:|}�a`
�������TB��K������43�J�Y\ҍ�O.��ۨ@1P��Z3�;�*�A��\h��E潱��>�s��o��
nӽ&�kz�e�˕���L����3fZ=���Y3�W�s�L������`�����<%3�-�	�yI�7���~X�&��qb��o�[�N�5p���C+�nY�.��_.��zښ�1P�:|�?���G-�7D>z�B�í��}��@�n�I7�r+���ʍ=VU9��3\��4GnGxoF�C��W�퇻�I1���%l0�`��ß���%ӏv��f��uMs��H���<$������S0O:�%�~�����1�^k���U�GZ��>�6Ԩ��C�@M�ݽ��@͚��Z���v��N��:�v�ZV���GA�WN~�ꩩn�ꥨџ��=Lb�\?���0�iN�|�O(wz�PԨ��z�j��y�xa�fE-8_�ES����@]S�ى⅁�*��sza���:=������އ�$6�M�_��q�U�0�����9��3	����00�d��/�"�i�$���%�R��䎸�����/�S2���^���h��%��∛�*���?����    ���RGA      �   �  x����q� E��*��f$�0��T���ȅu6�Z�?�#	�,�I�23oR���<5=X�>�y*.m����,{N.LM��4l�8�͆$��fW�@-��ѯ�]�ڨ��-S�}K���9���l�6�|���l��H��q5�ܻ{d,_� �V�7��!�N�����O�8���F�5��@����g	}'��\I��|EC&��!�$��s�{$���ƥ�5��!���K[�{Gm&�R����te��C �W���u�7�R�u�4�}���m3ڔZ]e<�W�@�����!P�U�X9��Хk�V�!���,*.Md@�ϰ>4�����|:qɰ�C��/Y���wHZ^F^f�����Nqź�u��?���!�N�鬎��u���&���a��ګUr�k����	�`��n��_���N�?D]��ҙ~
�	����ID?Vw      �   ~  x�}�Qr�0D�3���%�e�e����8�Dg����.@��XD>�>�h�*�%�S��>��L^R��
e.P#�kH��FzR	����A�T�{H�\�N"С�2y]$g��R��W�|KM�ϓ#�u��j�<���C.��g�#.v�6�S�ϳ5?q����>o�y�ϳ���R�&�+A����j���&���1J*�d��ϧ1�H�a��)
������=�����֓�T� `��GI&����I�4����h�M�������e��.��I��r�FK!M���+�����nL��`�X�ii>76R�!�+҄�$�6������T��8s�[M�CH,�֡v�5�R0�D�����I�n5���B�|�F���N��q_ ���Y=�C0L;���!�V�k���d�XHdŰ���'�`D`�X;�[�O��z9V7ֽ��  !�1����ȱ6ɕ�ne!�5��k�qA�(�M���D�7��a2$Mn7�K ,����`�K���r�#�B���(,$�/�`�VVi#,<(=%_t���\ ��ԡE�d���p�_��Kn��}D{��:�y!��؈�������V����Ν��v�hD`S�I���C���Ӹ��� Hu�ƭ5nA����7sA��8��jX��w3R�h�����N��ָ��ܘ��f�zik�����=�ƃx8�ǚ��N���%�r8|^(��y8���fȁ%}��n�m#�O)�J������6�`*��AШ��9�� 8��٭�A_^��Sb9����{�)���vV����,��҃��qA*�d�Љ�Z��><T �p��hj�+���J���K����s�u��:p��4?R����"�wE�Ւzɗ��|(z0$�<���T�i܎�f)uke�Ft+�a�񫅇�HH�cM��F�(����?���e���ą�SA�i�$�9�n�F#�X/��}�� H��4�Tiyw��:(�V�n��NI��vK�w��ޓA�*��%p3X�xR��am���������u�b��w��_ut}�޽WA{
��������vWA��F-G���!de�T�{��G�K�E��]ce�����z��9t�      �   0  x�u�ۑ#!E��(��l!	�G,�{�ٙqsU��:FhI[Oړ$�j_پ$�$�|�Z8�tH��)ʩk�F�1�h�^�s���E���4�֍ipzi������_���m�SR����f�9u�����8�f�&T��Z�$dp
�����)��k}�6�q�M��3�M���Ғ����fN��p4l�ʩk��ƹܛB�VQ���`s�J5�r���[��)4@�$��&y-0��[�f�N�Ca�pj��ߩk�6
�g�=���{j���s��7 ��&I��[+T��C�Z曤OSN�IZm�< u�=��[Q��rѭ�`��e[����������y������ZV����֛�
�p���xS�hA@�E8�����<�ҦЂ�3�}��M/㋍�F�߼�R�b{���,
�E�����>��{��GG0\�:��E��_R��gD�e��Z�rs�ڱ���q�ڱn;���R%DI�i��>���+��JFs�hۜ����WmQ�I#�}�_ԟ���v(��1��&˜b+ϴ��KP0�38E����;���%���纮6��      �   S  x�}���!�K����$v� ������6�+f�î�W�>�KE�%���S}�1E3Vt4�X���p�Ռ���Q�u�w�Ǳ'c�3�S���a�r���t�k�)=cp�;�8
g����N_���%��bU���1�̹��{VL�M5q��y��~��tT�=�Mq�{v�a�u�gv�a��v�g��R�MA��a�l��џ`�[�'=��S��~ɾ�`phd�18,��y��w�1g1����I��������ނ!;�>��{�f����-�>8�=�u]s�w��u08�}�aIr-ȵ���܏�-�.��H�g|���Ot�����o)�q�JY      �   -  x���ё)D��(���@��E�����`$��zE/�R��j�ϕ���ߋ"埑~��#őڠv%��~ݮ�҈Z7i��\]!����iH��C�c	��M%S��N����YI'鮇 �6�Ф���+-iT�IC��_o)��?R��gw�yP֟Eh�t�����X��i�~aH��B�!E�PF��W:iH��$���J��jv��G�f���o�s���ߍ�bZ$�s_Δ}�[���5S2�L�G*#Ӡ��,�fW�Qo-e�=W�eO��B��X� �p���2��ۧ[=���2�S��҂����"Jte?Jɖ��)��)�T�Y�b��ׂT*Z�{m\����
9a9�HC���nU(��y�e��ݩP(��Cc+��V2���Ep��9��δQT���U�Rr|U��QUZ��Fq����k�n�K���+W��j��+y�4�hS40[us�H_�P��ec�8 �����$�o�O����Qu���lb�[���tj�H�d���N&�h�B7&�}ӳ������ǅb��XǈĽ>.G)]� E,��2)'?�8�Uc��ˤ�1���ȃ�`�h�B�t���:��1��Q$����2N��R(&=8Z���ͥPH��GӍ�o��"����d}ʄB�m�J@�h��/6���4��ݓ-((�IlF�q֪{�PH���ױcV�h���(p5HIK�BZN�|��B�n���u�a(�By'���L�x�}��Pl�_e߻�B�(��������Q(����Z�h�d%>w=�	N}=1���q�+�\*ʖ���]�;�;��!z�o�ŗ�:�A0K�(.�ݱ3�>��d��n��e�*�ܢUun#��v����ܽv'�s-4P>�,Õ��m�4I�;�P��j�M�q��Ƿ�y�l�r��߲LS���u�
�|<L��Ȥ��H��*B��m%�i1ީ��|����p1����ӏa�&��C�JҖ@("{HȦ��P\*1��J���Ы�\��C$4�vz�yL���vj�������R(��{�y��ƣS�r�Y�f��#4xW���G�)�m�g�Ti+f��?}h���%�����4BaΆ��h=e~��W�b�Z�h�y�r2�}�S��ɠn��L�ߧ���aY(f�Gۓ���F׼LWe=1�z�7�U�k�Z�����^mU(,���i����B��ge���P(��ҳi��Q(|�}�=��(��R��OJ��o����^����F����qh){�\�wK�tK��[/���$�-%n|��=[��(���F"^K|��l4��'��7��-            x������ � �      �      x��\ˎ㸒]��B��\T�����e���ly����r���;��?0AR�)��TeJ�	G(>"J9;Oϫx��kz?����#�	�`խYu[�~?�?�1�xȢ0��я�xrJ�STȏM8>��)-��C�����������?����Ҍ�E���b~��^��K|Oы�\�_�����$������w����,0�&gm�6�@��C�u/^}��hܤ�����)�Oq���0>�XEO��4浗'?��h�xr�~5�v~�y����p�!O��:x4OR^k^�,dINQXYʍ���7I�Y���,���&[�&[�"~�C�_���	��)ظX`�����O1I��6a���}Lm���w0ޤ~���KJ� ��K���{p��pĵ^?S~
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
N��[���ģa�T��v�*�ĨXP0$�ֶ��˔ηm�$8L*5���WgA�].�~�Ƹ�ՠp�!ka�&r ��~�'�7X��\:󈩃�b���Z�/�O[�0�Z����� �]پ�C�B�g3L��5-=ۼ���X{Y��̭�4!/k��u4`��B��ڱ��m^����v�o�	��Kq��^��|�tt<�`�W����ӆ���dM9��������\V�=� ����c�C��~�RI���TV��a�֡m�+�	�&��@F�c���ٍ�)K�=wV�)�B�x�w����+�p�p�1մ�⚭R��:���&��]��b�tF��m}�Q��^�t5����U��P+�ʸ��j������cX��      �   �  x��Zّ�8�nG��E��F0�Ǳ  {d��U���čBK_�_%}aB�n�w(;�`�7dV��3�i�7hm���sޱ.ׄ�(@�=��ꚜ�q��}�6H�Z�������k�$-I��\һ��;;9�ڠ�%���zM�\���u[H�R.}�%��mlm��7$<K���`��"�n�5�bƼ�ē� ;�=�7qa,?};�46ho��ܼ%��P��~a^T{\&O�;�׉K8e�\[U^Qu�P�u����	�n���䌃����h�&$}v��<)�qu���jav�������]� �p!��.^>AT�A
_�DO���8�Aؙ�B��\�p�
Q!B�\-sy��0�A4� G̀�2���f��2�Ѵ��f 9��u���9�K9�sԐJԐjT%*��F��\� ���Bԝkԝkԝk�j�j�Z�-���FTt���8��U�����δ��4����jmDO.���wX`E��A2I���ҨM�|ܦ�8(O�Imǹ�&>p�g���ӓ�>���l6*����� �B�Y>� ӒaV �N�y��䲊Y��g������C�;;��h�.�bf�\(_.���Dg�H^ڋ�%$�"�A�,�˰���Z�O�D�����P!SJ9���e�.Œڳ��i'wu@U�=s#|��S�� g�:|x��R�ּ�ݏ.� �9������Ϊ��*㙏��3&:0T�|��� -@�'������}$�C�h)y��0yd<�:E1Q+�7([�z䢞�'kGb���){*��~-;��,rqȲ���8�I5�P��6U���s���C�)���U�XY6�|i�`��u%����d��^���]�� =�s�
l�6jT\���g<䷳w]W-��,ܱXD�<d>�������(v��]�*��O�ʎD׆�j�2��b��6m���G"KN��2�E�m@z���+�`�Q�S���,�1��)؀`
k!h���j�B��^�s+���|a�����"iI}��Z.�����h��ۉ�"ǀv��c%��4?O�u�b�"����c 2#��¼\�E�ܰG�y ?`�� Y���F�H���+X�i2�3�h��a��]�iH�jmp�*?:����[T�6�y���H+I���t�ѷ �ԢۣN�Ó��EQ t�5Q�5�C�q& ��fj�u"!��Es��'��㻙}�_����aq�~�fy0����p+��?��V�`�ś/׮K]��z�O(�
�V-`?@���Q�4�A�Lh�1>�,�u ��<� �Ǆ�M]�lߪ���!�t�D�z�%Ȝ*1g�RMX%fmk��,D�ˁh�y�a��omO����ne&�<Ӑx8jO�B��]}�� ��4�n�l>���,c�z��u8�̀��'%���P��سr�����I��c�oY��(�?>����F�ϓ��0����(��ŭ~~R���j-�u�U��@E�b�|?���g�vX�হ��������7| _Ar�<��Կ�8���h��f�7�4��E}�nZ�<�����_vԣ���\ �u\HcK�G5Hw�_� ��5n*�?[v��T���8��n�g b�n�Rl�D�[�<��
7ɹ�{�=)A���JY�=����X���������v��P{        �   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
c      �   �   x���1�@��7�i��ݍ��ĕ��D���/�#1��}/iN}�fg�mzvu;�#�,��8Vr*!˅����	�g�6�W���n��zo�7�����-�1�0Y:%�6��F^��q�܈��4T
e�2���U��o�/>;      �   <  x�}�]��8��˧��%�?bO0�?�&�*ې����7XB �k�O�������}��q�r����/���)�r�f��<�tH�p�۔Oٽ%{�p���?�E�Py��xhG�Py��#�Y�~�H&osD)�<��ۜ��T���}���M�H�*��?��4�]$T����O:%�� ���؉�AH�S"[e2�J|`wB��ŕg92Y�� :!ځ�EBe�<���\e����ܚ���#2�� ��MAb^
�!T�	Q���PD� �I��5I���2D%� u�A �%��2�N|LZxLA�\v�T&� 1�)��c�p����}$�P_�`J䔘"SB8!J����d#17��̇� *�+�9h2��_ab5�d=�]�
��� X̅{5c�J�9h�� >U�g�d$�ab�d�>�MA�\M|U�!�h��4�s�*'������w;�ż��Ce���d������[R�a�,�T�<�7N�]�� Hm��>�� J|*��A�A�x�k'H�A�At�C���dL�	Q����Ε� !�l$?LA2
&VKL�v��Zb2!�Ce���+�A4JTҗ��tK�� �� �1��q�`1���O;�Ŝw���^[r�'���c�^2��j�A�W���c� |�Ք��sp� |�|���ǒA���)�׺%�@�Dב�uB�ط/ĤDe�PyK��\M(�\-����NɒA�����/n��{�%���_ ���[MM�Z2�+��Atw��iƷ�%��Y�d��	/Չ&oi����A��'$��� 2������D��%� y��O���A�C�.�Mg��dc>T�k���GP����p&oi��*���,�5�M,�s���z�(�GM��|��uؕ���cX<����D�8KA�a�_$L1�Sᯐ�c�u���X�3�G�7�� 2y�{�%�(�=Ml�LAr&�T�|*����j� YG���d�C>Ma��d,�_2�_�Ihm7y�au���5�y��ڹB�]�WE�W*�(���4r�D�s�AT�c��n2�F|�C�:T�9�}�/əŃL ���cƩ��A�7���KA���P�ʐI_�&�����GI��3����u� H~��Vn�����s�Ad�F��I4��rɹ2�p0ѕ[ya�8u^2A�3�%��R�f�K�"(<rƃE��6B�-�`�oE&� =Laΰd�}P��,�⁲�Ή~,(e$�M��IqF�d,��'1Lq����&o9Lq`��:��A�׹�?ڣ���e���*�%�AO}arӏ[!�����-���h����A4B����"|���-�	˼�ɺ��-�H�(��e!�g\�����MXNS=$BeB�*��nD%D���A�?:/S�d��~p� Y���g<&�1}�{�[�{\G
��-�H�H�$^2�ב�onD���/�!�/��wd��"���2�F�J*�%��h�G;}����{�ALBLA���G��-���謦�j�E�, %����*ZЬ�=�J�X�^��梕Z˻l�:�^�Kd��
��@T��WOt��ZKf�awy���?B�uo�2<��I��iY�7�@��_}	{��Q���!��(��x�ث����Ur��C�Ml�����$�t߶�����?u����R]~ˮ1��p��UED�)y�G)�l�=�S]2�W�J�&���ʨ���3��۠*��u�x�:���cF�ry}��U��y%2����y����|4��Yw�D?}�wO���Z� >����Ah/:&%
�a�/ɓ���� D��63%
[��D��dg�;�h�ˏ���Y��-{��h�]�'��yz��v���suM�O��>��۠��_�6� '�����W΄��D#>ګ{}VwQ}�_��&wkw�!����վD�g�j8�D������=�S�<��ڋH�����"����l2Q�)2}wwJ.��:���׬�K�U4��������U�nG�W	�-d$��j]F~�8b��a?���R�?�l��}���      �   �   x����� ���)����8�.̈́,K���1����k��问�����(Y�������c�t恣I0�f��8C@Ղ�7�(
q6������qEr��jM��&��z��Е`�<��㖄�r{�k��� D��y��"r��D�E�U�c9����i0�@TZe���/�sU�      �   �   x����
� E��W�ʌ�sא>M(�nK骋����@,���l��p���$��P�*�i��J��~<�HC���%L|�����C���<�]�d=՞��љ�S`��i|�),i�oM������כO��c��x����1�]di�h[J�$]*�V+��i��X�Q��v�)��2�f�ΚW�� M^c�      �   p   x�m�K
�0D��)t���;ǘ�BMȧ�����,+	�y�7ǟ(z�j��5 �A�Vޡ�'M[a�8���*\y	1����l{ `8�m5��N������>_p������3�N'      �   v   x�m�;�@D��S�F�@H�Vi@KB�?Aۤ��4c[���Y�fs�,EN�*h�Ӵ����yG��yZ��In�z�V�&~uh�ӐZ�F}��W��
M����{B8 U$�      �      x������ � �      �      x������ � �      �   V  x�=�[��(�;3ǒx�e����"��Q���N��x���g�n�C{���6h��hmk�o�fu[݌�W�+��J|%�_���W��6�&�D[hm�-�����B[�͋��ڸ�<<���@;�U�;w���&����-����������=0u�Sƌ1A�ü0-�
�0%���}���������6ތ����f���o=�F/Mw��������a��.��{6�ݴ�Z�l����l;M��>W��z)_ꖺ�@K�V��o���;��������������������������������K|S������iw�~G�z��pa<�]إ]��i��ݱ�K�%�z	�L��$�q���E�/�K����	�A$Bq�c��ڠ%(���`�?�,�GK<\�/�{���)�������9{۠MڢeB�	�&��l����m���/�Jԕl+�Vҭ�[ɷp%�Jĕ�+!WR��\ɹt%�Jԕ�+aWҮ�]ɻx%�J䕴+qW��r&˩,粜�r6��|���&O5[��R͖j�T�����ۼ��6�6���~��nt�v�����m�x&m?�����բ�G-Oc��bBL�5��A�eb�[�LZ�Ll&6ӧX��1������by�L<����$d��X�����χ6hQ��;$C��;$C.��B��.����R$k�,FT�j�
�2����H�#/���C�L�3�ϔ>S�L�3��;S�L	3%�tq����k� ��O��>R��<�<�<g<G-'|���CI8�9����!���ܣ�˻�۝��
(8A�l+`"H\�q%߷d*/S��'h'-�"E�VZ,	�"p��\���:� }t�!QĢ�TN8e���d�������$�'�A�/J~R��vt{�|������.���by���u���3V�P������+�a7�ݶ;vz	��^B/��P�B]�KGHGHM��H-S�r�r�r�r��K�+���R>��C�P7}(ʇ�|*���N�.f���r��٤��u�4\�pQc)_ʗ�|)�ʷ�|+�ʷ�|+�ʏ��(
�(�r�)��8ʏr�+��0��
�(������t ���_)�t3gi���_�����9�q��Ygi�e�%��Ό�4�Ҩ��K*7��X*vy��r������K���N8�7��w�c	��s��Q��T�������Ա�
��0��yL�:�{M�a��u�錧a��uJi(����2QiD��FTQi,���A���+��E���N+W�\�r5��(W�tV.J���{P��<�� �w���:P���sRN��8��ɱ���l/d��d�rA|�D�ܻ��I-�Nz��l���+��%�P �?�'����}�O��=�'����yO��;q'턝�u�N��91'��{�M9'検��q"N�	8�&ޤ�p�m�M�	6�&֤�P�i"M�	4y&Τ�0�e�A�bM�	5�&�$�@�g�L�	32��O�D`�5�&�d�H�hM��3i&�d�(�d�L��1)&���E	")��4o3q#��K݆�̽�[��[��[��A�/�xo"f�,�%�䕸�V�JV�*IE~��Afd�Afd�Afd�Afd�Afd�Afd�Afd�Afd�Afd�! �x���Q6�F�(��|>��|>��EED&�Dd�h��+:Z�*�X��V��ٟ��ܩe�kB�	����:� ��
?cO��h	-�����`�KV�C�c�!��]��|Q�M!�3�<��wv�B����a25��߶����Y�0�fQ�,j�E���7<�g����y�3ox�ϼ�6̢�Y�0��,��E��HZIK#im�;��3�4E�_�͕��E���su΢�Y�9�:gQ�,�E���su΢�c��%+�ՆQHH	� !�$$��d��LnJ�+N��4zg,*0�����&����S�ϻz�R���`�rI,I%�$�D�DH�HqU�j��]#��5n[�pa��F���F啔��_{�EęY���6ރ�f�w�E(�Z]��jm�Ҫ�U��U-�ZU��jMՒ�U��S-�ZM��j-�R��T��Q-�ZE��j��T7��Sw��S���N-�����Z>�zj��ک�S+�N��Z6�jjє����������Я�      �   �   x���A
� ���x�\�23	��P&�m\�#x��.
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po            x������ � �            x������ � �            x������ � �            x������ � �      �   �  x����J#QƯO�b^`��_;snW/ʂ�*� ,�{`҅�V��7�� �x30���L��K0�E^��S�w�>/�������HT#֤�$�$�5*:�@��n�g�/��՗��ã�?�b��XG��O���4�0�<�]�r�]���b����q4q�)��f�m�6��=w��<�Q��1��F�(`�Q�Ԇ��w�����sj0.i�=�S`|�����]> ϗ��T��-GvԹ%�i
b����0�����!H34�@ڡ���
(��Zž���TӴ�&E����	����S+)x��@쉳A�8�<�C��p�]��N[jq�ctG�u�@�ftџj���TP�F��^�R�TD���ͣ�{m��qڛK���6;��&E�s��g��>��5�*�	�9%�h}w���K4)��1����m�`6,n,�5���Yh4mx�0_�Z�:��~�x8��7�R      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      "      x���ˮ-�������j@�Z]�ðQ��7��0l�@]�ߤb���Ę�6re~#B�(^~���o�������߿Z���O�O�����o����?M��}��_����?�����G�? }�?���.�?��������������1�cI��e�=ZF�@?���_�S��?���sA�ZПZ?P��������_�������������뿾��O���#b���b�h���*T�Q�i���h��>����h)�b��G�{�f[������]r����?�7�������U�ı��?��������G�7{��~����՞bǃ_����Tmc�x��xX�t����_9�A-{��_@�SЖ�����;��Y�&�O-o��=@w@�(����+�!�U�QB跑�}��W�TnE�/�������*�)����FR���?�ގT��/��FW��  ���7���­�_l{0��B���?�)<	�O��`W(�p�by���g՞����ɟdi*a�5�׉��#��mƿ[��<����v�;��%�:}���Oo��_HM!������J��	��J�7 �!������$�C�(�V͸��P:�/0��As��Ä���yN����/W_'����b�I�-��jv�H��;-�
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
bn(fv�/;"%� ���ꑒ��D-+�yT�O�*=m�;`�ǵqc2��my����륍wAږwĠ����̈́���+��*%?m�4p����GL��OO�E�7W(���T�@�W��a����k/���@ɯy��Z �X��yO3tG��W�٬�#�y���I��W0�xb���`h��o-��<KJE(75�{�W�hkK񻢥��s֜y�;�Å��3�����jK����AF^�7�U���y'B-��ܾ<����7���T���ʂ����ۏ�#�9�%U�6�n[�I�q�S�̬���7�v�)߀8<�}w�)Ϥ�>�~(�(�A�9��%��ܿ�4���g�������AѬ5�/�=8����Pyu=�7B�r��@b3�-�-y�ѡ/OQۦTM˙�}"��P�R✴I߄8b�k�nkt�{�@��2��"���Mԙ�
�D��C�Ҋ`~��� b�)�AR�܉�(������y�Č�zO�wL���\����6���.~v��q��^0�ӢA�k��J
�6���/̀�K%!�kW����h^��7�S�0i*
�<�X	���ߘ8Ņ�+��x�FM�� "����Mz����)�?2��kBƧ>fg
nsޯaNN��\��3|2��e:LJ��Jc��r��@�Q�ŋ��)��\�j%�ŀ8S*F�4���m�H�7�J�_�[����A.��R�q��ӧ���~�~SZ��yi/go�)��\k���.'�	���V}C�?x��$�b�����iU\AL�1�D��<��~#MJֳJ����p����CZ\�����}��h�T�&��s���	��4a�հ��o�	(��%g�h�bu��G�x:pG�BЩ�6�����xe�.�t�O�%�1y��-!|O?Jq�d�_t�%^=P<�xbt6�#�M�Y�����Z��'�Rf�vf�mA�cd���8cz�%�q �I�Óߘ
�Vm˛��>bdJ2�ks��u�4��E�b�	w�iΘ�z���.n;�ýn���\v�3�I_��^vq�0іa�siQBQ��4g�?�(�w��3�[�m}1���),O��211�2���i*X�AI���`<�cd�(�Vi�]���)÷_�����EI_��6~��u&EP�JvK���E��AO�j���uL��Sdq\�uGJB�Ue�2��l������,%���H�Ai=�NN¤V�Yd�E9����N��ԙ(h-�A��9��2��Y/�o-� ����»η�e]�)���<�A�Cr�L��'��]T�d�v�F���j�9݆:���J�����eRv�j��$��zf;���30s�'�Sp����o�Ơ�f8$�(�'n?������UT|wOʎAu�K�P��q�l?�!uà�su2��J���31����կ���c�l�X�o�t��Q4�-O#���B�n�n��\���R PÕ�s	���o���lJy�v���m�3)�:����7{|B�%�\N�3�����~��f�OJ���咨3(Z�ӕ��e�'���x6�.�L�D�A/(�=Լ��_�f�\~�R0��C�l�I��|(���I�����'��7�Ǽ�/�:����s�;��Gg�7e<~�j{t�& �ȭ�*g�t�A��Ȝ5��l���f)��Π\��3E;�L?�lPr����_I���I)U������WL
n��B�/���3(��x]���6������7�׺4D�2�^���3���6k���Yo��t��c���K��s����2]�=Q�>3�7~5�6��K̔�M�m�30e���I���ʆ���g���%Ew�S��<�_���}'}�~�\_�3G�`��t�g����9:��B@��E���Wg	�ҚT�)~�̠���PR�~�ys�0�s��e.��K��L��Ϗ�͛���T�qe�\<�����!�̔��{�Ԑc�u���vj ?l��(�U�.����U�41�.��*�-� ��cp�8eh���$�A���L�d$lJkB�CL��y�̣
�s��\gb����1��ղc�̀�msyK~����=��`���#�i�V���lc�
s�!��	QwL���"	���31M;�!�ń�T�0jS!���0��ɋzSz�\k]M�2�Z|��y�2.���7岃�N)0f�MlZ���LLMZ��y�ɼ'#�+�)��)w����6�rG���&%�W�V��K�ܑ��R�Y&�e����6�@�h`t���?*�sp݃/[���I,�~��>C�,�;��Ei�)=��.{�)��B��^L���2~�oV2B�9�"ES#�ȕ��!���rT�)�k����R[1~�,�˫�`@|���Y�xɻ�,�
�0���o̬`���Bg�%�v���d� g�"2(*M(���2�i�L���5&vj/-rG
l�9��5wye���N�{�*a|���hEo;a.]rYw̔�(���ksi�30È.���=�c���Uu�����)q�!��o�l�9���r��O�A��1�M\wL�Y���t��g��)�m�K��9PDP��x S��Q�MAŦj�˩>��}SPl��"���,�9���;�X����g e6_���?v�י��bG���^Cn;�`H@���t��t^�s�wx]�o�Ma0O_�K����e�f����<�z�g]#�g��8S�i%J�H�O�o<TsTj�d�������7�����_���|(�2�����͔O��WO��M}֝�̆�+diB4�\�kj���I�EJ���|���-<g���7��bS�n��)h��gq�,c(i�`j������˥E���=B��1~��Ȏ���*iiS���#fl;�����8�:�������L��������ٷ�E�r|�7�?S����\t��3�����pp�,MD����e��!4G�/��l112��`|���fQ�P��e~�0 Qw�����@���/�� 透\h���h���%?��Sr�,MH�,C!J{��_���g&{J3��`qߔ�Ez��p�"!S^m�^��p��2>��(���ý�������?(��eC�[�Ý��HE4�(��[vJC+ذ���{30u� 6}ӥG.�wd�Nm���f�4��ֻ���.Mr'

8a���%gPj���.=
�M��sJI�����%gPz�'�n�'�J���.���j�jg�&Ӭ,�P.�ÙR�P�|J����E��0z?��rq�ΐ"M��J~ȡԝ2�;��j����v��D&br���0M� 9:�3-̥�͠t$#i뺃�~ŗ&%#�K��4�)�/�v�E�ǖ�՝霗��� ��{��q|S�$�q(m��q��a�e.�J�f�#f�>eҤ���=`��
��(����=SZ�¦��;��)x�1/p���f`JA����7A����)�3�N7�2�)��Nz���_$�g#����'w��I�e@�����m���2E#�lm�@.���(9�I�j�#�礝�;C�MJ̱
}�Q����za��RYwr�ǙIY� ��1�o���_(~��v!U8ա�$te�.���%�L��S�޴[�Rd�"?�ְQ��'�X:.�6�!�8��inK�;�CMrx%�n��J�:vG���୰�ic�e�Q�o���45Z�9H�{��.�A)2B>y��ޔ:*�"MQ    ʭVE�SEo@�3@����G����QU�A�&�����ůV7(d�o�KD��Jъ�I�OY6�o9�>�-�2`f��i�NE���xk49#aΎ�4gL�y{� 605V],��(e���`��9����$�N�j+X��tɷ��fK�r���k!"y�.�6��њ����m�2��$�s��'L��X��4]2n�m��H\��s��gL��r�mj��V���9@{�*�tI����[^�Ə=��c
�R�c0���f�Kekj�`I�;���o�����#���%��,�����`df~+��5�N�3)��QE.\we�NQ��(��X�ě��օ��q��O��:�0��/O��aS[UV�I��ۯ�:O�2L,^��>Q�l�v?
і�%��6�^����N�30���/���;&��ۥ�嬹��r���%� ��&IoA���:����1|��������=��Q�E��2k�4�沃Ϙqy+7�I��L�s>%a�ƷV7�8�!��S�	OI.�oGL~�&�m$�	��vL{�<�r��Ӝ1:,"]6���h}�@�v���xm���00=K*Ư^�a��w�y�l�E����a���)���������i��y�Z��K�LM*uY?�ӎI�Gn"�
���H�Ot	H��w���l|R��2�ϖ�t�zr�&"	ǯ)��p�ӐXɐU����g`���gL��S{�܁,�&��kmfk
��SjE.=pE{.|�$_���@��o$��D�F��	h?�@�'�A�P/����#%�ĊQ�x�-A�8:��UZ�K�A�c�)'�?��团�O�R��g���C^n,�,���vJ������"��{����K�[�Op�RX�a~��/�o���C�Y��gvΆ����3ri|3(e\m�_�/���/Z�0A����ֽ4������������Q˼e3�D�9~4i5�����Qڠ��=��t���P�J���S�B�WP2��ȥ�͠� N���`�R����1���L���i��܋֤)e�CzE�$��L݈���$� ��)îS� H�P�A�%����獂�r�I������f`P��0C����}sa�w���I:K-?����R)�.��p�#0)�b
 ]i���#}¹Rź�b�F¦ �i���k-mq�/oGt�,!��`8����h����7ޥ�����i��V��EH)�Sg�
a�ș��X-nM���]�4�I�<0C<{�\���$侬�[�i�#S���L�ڸ����Ѫ5����"���(j���ֹ�G�<���aq��mo��G~a戁���}ogL�7�d��-Ҁ�7t,JZ�MuS�gF�p��T7�laR�A!�cBX�a���,n��H�}*�T:ͫ;��@�o��Y��CinצE�Z9�p-˄�j��{�)HjKe���-��{9ͭ�(��A2�Cq#%���n>S�=7��SP�T�ϯ:o�Ϧ�o�������'�"��~c�#+/�/w��}�0�u�b|����o��T�c�M��%�fPbi��/]o�)g�,
f#/�%�fP�I:�rI��(�1��(�L�-s�\Ro�Q����5ÿ&��|8S*�Zxu]x�h���[����֠Y�R��A��wMJm�J�uv�9����Tf�fo�)_�'-�b���qcf1�o	ťP[g�NZ����Ș���]��W���r��\0��N}��C��)����,�p�������1씩��Z�d�~���^(�j��n1�B�s{틧�~�툉�eD���(D�����һxm5P?�fa�ߴ�>?������E�e��Ml`z]dK4�y��S�z���K�I
@���E� a�rjt��v���;�m��a?��N6�(��}%����I�Dq�(-J�)�ir5�,JmԜ���޶o)�J����,�aQ�uȤG��[�R�GJ� �Ϊ�Sg B��E��7��C�ʫ�>�)㞬�SBS�/>�B*	jOPB.=Q��^���@���?�*�+%U��D����{30ZB�Z�}30���?*n���(yR*1�j�Z� us��M���)���
V�^`�i�2�T�/�⽝)�#%�I����E��G�2�h{��2g��и�L�m��(���U�i&�A��(n����Y�:<����Uw$�EiZX\�v����M��3
�.n��NLp-P5l�eu/6Ù�����ȗ��1��:�\X�P}�IӢf.���V;�X6L�[H%����M�1���k�Q����3fu�������y��5�1���Qg�@aySn�!���t���B��,K|��ԥ��G���Dh�3�?��1��%\*XP؛I��7�fΔ��(-�N�&-��E�ZZ�_�8�������u�٥~�͢Hh�U�Z�#��F](n��	���	�T*�n~�͢�4�iq;8w�mR��hA"o���p���"lnV?��FQ}���{��ݎ��\{���[��S2DW�Y�?�f`�ؽq�M�����2�@�hȕ�K��L��U/���v��؅$1�����/̠�F�BQh���Yh�&��o3(� ��o|�)��z�K���U��퀑����L\�K�m����n���k��͢�\���v�:��I����&^ދ�p���]#U$m�������4��K�^W���I.iB*��r����ʺYa*��x<7T}�ɘt�td�Cjk��O�Y�ԫ.W��w�)o�����Z��O�Y���^���o�옄dA�P��i�=l`0�b	�w�|Hu�(T��x�a�Q��``ʴ����~m�4�x9,E���ԓ/�M�����9�q_�2���	�}H�|��r�����q�m��)���L�b�E�l޶S��m�m)���yϘ�z���b��m`�][�0~�!���6B����G����g͌�-{��F��oBH�1 �c&s�5���,�h(|<���-��\�巻�4���j���3�n��)�a&H?���v�@ќdPr�ؿ�W��w���C����?G���t����*��K��73���;y�VN�Ƞ�C[9򕓟7N;&�FE�v��9iQJ��C9�YcI;�L�v7��ou�0m�U����B���13�����������4�'�a�ͽ�jdw=��nF��e�݆�9gl��|ߵ�1~���ٟ�Y�������A�0�x��b�K�����|*&ʾ��E)8�Ȋ߉��v-(5��ts�6�$ߊ00u,0��d�M`�f�p���%���g̸�k,���ж���>��$w���K�͠t��ѹ���߯�7e|�E�D��AS��\3��~ߛEA-�}ɗ�Ei��/?�[�S!œi�b}(���E��I�.~��H)���!2�>�S�)�FK�_Yu~�Sg{���Ȁ��@��F���~�_gø�o���}R����yh�}��/�7��JZ>�a<���t%��[T+/��z8Sz�4�=g?��� uJ�o?v�	��b:�)--ݖ��.��������|p��)����\���n�,��B����u3 :�O~�rٹ�kܾ��RO���uϘ�z]6�����;Fߎ�Z��iA�Ӝ0��B�F�yO�aǔ)������1�h�9�`�Wp�qǼ����g������G)����RK���S�w�"��G7�◭�z:`��,������p�L��,��G�P�,y=6/�7�2�o��/y7��8(��p[l���{�$)L�,L�|�5��ߥ�Mu��,ԭe��}�I3.ȼ,M�^S��%��qQ��h<�$qs���������n��k`R�ȥy�N�7���6"���$������0���at�v*]��{n�cR1���7k�1�z��s�ˏ���&�ˌ���/���wh�u?;a2��p��*4��?�CgaOH�zO����a�M��7�?�̸quyS�?�s�1�K-a=o�1��./�7�s�0p�*�1-?�7$�]-��޽���t�&.���G���K+c�M�eÈ �ܴװ<������ᇍ��%�G����#�J��ڎ�՘贡�r������    �%���a�����*�D�p���)P+���.A��2N�_5J'�%q�tt�}��r�~���Q|���.���'�y	&J�o�ȺCtN�	�sp�~ ��i�v�U�K���9���`%������oiu�Q���fS�-Օ	z	AR��ϯ�/ �(�r�N���A�}}�9�m��`-o�0y�2���;{�q�L�#F��F^̴Q=�^sfk���>aƹ�
��q�-L�1��i.6D�1y��*����|�3�,7:�]�k`Z�!c�{5(�����n�w�&�q�a�W�CQf�1E��,�����xcP�S��}��3�����H� J�g/,Mm�4jW��_yҢ��!��+������������%q��8�P��9R��NWJ���2�0rp-�K@4 ���'�"	�I��G����|`����p�|��"�>�⟾G
���bo^z�J�(�ՊY\l���,������3��Ϙa(33�w����yl�W.�Ñ0�g`�K
���|_�q���_�g�$�1y�E���J�)u��k �%w���<[�F��tƠ^��W%�\���b�ѩa�d�͠��W(�T�	�ww��S�l)��>�ֿ)��R�Cm�g���yt=sy�����+T�W�_C�9;�I<)�Vue��)Z)W-�r���o
���Eʹ_�L����ߦ�#��Y):�OǥT�#Ɨ��0��UgL�?�3��qP-O��^�bH\ڌan����3	�������p��05�̪���~C�v��\���gP�Y��c�}�o
�%*^@���W�����Լ�Nn�y�]�a;�y�<ڻߔ����B������t&eʣ�����&P�DA������+$�-�%S>��J���������?������������_?�0�~�3jm��Mm׿���C[��&t���������64�˷��W&��;jM�xE%>��Z!TjB�y��8�ƁcB񍌧���E.eJ�֗�)7��������u짱Y����:<+|���)tIG3ch!t���|��gLj�-�Ġ�x�*�7_J�0	�k/�Px�f�t��6���j�Sʎ�0�z���/]xG�X����׿�4@���_��sKv�t����0�@Ӹ�7F�1Ѱ/]x�g��7˥���L��QiTֺ�p߈10%�%X�;���Ԇ�E��]HR�����b��Ɗf<�i����b�Z?a�]#*�UG�%H��0��d��Y/I�#&C$w�E��, ��¼���udv���6��
����4��A�a��9,q�zI��ng��L`]��8�����M���	<RЭ��j�Cy5m�]���K.��@q)/Ks��e�Ȭ`�=�em.���G�����%���%k���S���D�E%+Ek����/�;[0�o���/�<QƳ�V2y5�ޤA�-
�t1%��7�_�Q"�^�K"�H)�(�<~M�P����*�I�4�^d0��>��Vh�\�'��ZwJ�z�t4��'p��40�i�Dk�a��d
�G�w���aU�Ъ��-JCb�(~I�j_�2cp����/9@�ҤrkJ�n3���3꣡�G;�"�iP�Bq�(~'�A��x�,�ݻZ!S�7`�qj���e�)�e�yu���� ��!2{�\l�3dZ��~����Y S�w�0��@3�^L�3EƅĿ��n��k��ER51�b8�)�h��.~�A�%E���`lfäL!ج$nT��s�$�Y/�͠���!����� <Rp��@�x�"�Y�SJ�fw].v�!L�e8�l#^���)��`��� 40Aa���S�b;f�0��\W/�x&�گP�?C�����,O��-n�8=�a��i��������C�f_J���}��A���ؠ�Z+g�k�q4�1:�\��ɸ$��Ĳ��K&��AĿ�z�]��A2��'=aP�j^6q�-����7U.�����o���oL��W̼�;j���fRtXS԰[�Z���2����l�?lP�TbP/c莔�q�H�7!��x]Ʒ�[���J�EK���ޠ��">���[�;�ϖ����tI1h�A �1��l����0]0�����*�\�Տ���cO3��%�w��;R���#j�x7#D�񏻩��b�b�q��r��	���;.�?\"��4�-O����a����5��ƭ}�ғg`4Ͼ�<2#K�+������%Ϡ�0�ٻ���k�~Ri�nJ�R/y��$|�\����P���<��u�*�jh�Q^��ʸQ����o3�e�c�6��\Z񎐈�]�R�?���Eu�����K#�ӡo�ꂩnuvO;�K����>�4��^��ŵ��ÑR�e0K�~0-���NA�i���f�������=C��L�v��a�(pK鉟�r��)3*Q�Ț��&E��%�v�`B���v�MJ��qH���vɽ������%�����Y��D�vI��qŷN�{ɻu�(�|��{��;�]o�g��#Ѣ?������a��v�?�u��Qm�F��	I�G�1/�1�r���W��miI���9�&�1�@��[g7u����.����A�)~��{Xe6��4����^	U�����´�h����S��
�"�iPbM��[��7���&n��[_�+��bψ+���%�f`�&](�E�%��0�XY+�]�o�䶌�lȾ�O�B�12��UW��qO�3�����fH��蜧�;&O��q�E~���v:�}m�Qt��Aa��(��.Z�Gʰ�B�@7�<��
���J�Dy�}S2��Ɇ�(a�����i'U�"V풁3(:�G�? 6�eؿ���r �F��8g�^��3����5�����7e8)�͢Kn��˔��D���3e,.�=~(��x��ڨ��!c��~���M����neⱦoL���L�����0y���ӸFp�	��{���<c���,|7e7�`b�������򂁿?;ߪ���n��dLH]0�X��/�/��V�G�M�8i���� g��?���Ԭ���]#"� �7��blu\*�m�,���԰�1��}��c�,~NZ��e�1�Z�[�}�t��!{��gLն�F���I�T^q\����,JΥS�a+�H�#e\�c�g*k~?ޙ"��ʿ�5"��<}��Az��v �E�I겺�$���,���74�@:�2�5?��s�+�K�)��{�`\%�5����(������6���M�N�qOV.jn�,�SƇ2�E�V����\��P����y��Ր�0���;c�0�K�Ƶ�-���G^u灦�M:�R��\N͵�-���%�q��� *��P8&��ƴ(�MI�ŕR9RpQ�������-lP�88� �!����vRcTi\Tkn͢���Yin)Z���ɦ8������;c [9Q
�c��\��97@^�-A���3e8��>gC;�����w�̲��Y�~@7�����,Lֶ�t d�m�Xv̜�8L+�¸��Y��C[|��NE�0c��%L>q�n�9������~"��t��l�q3qgLǤ�%0�g;��i;Fg'���������3f8�2���b����}�`���w�Y�qW���a����$W�=N񸎿6,}F����/*��E�m$�h�>z�)�(��.��ϥ;S��x�-�C�l�3%b�3��?�.žQ$����ᦼ��,�&k�}E̔���N눱�w�Y��.�O,4�����"��t�΢@�E��1�����<c\b�@e�[�,J/�!���t��?�A�7U�R,��Y8������v�Y�����#dR�z�9�C�Ai%	�޾�E钹o3r��.ō��ΆC�R�ݟGw��WF4�5�<"�iҎ�S����3�?z��<�$-<�L����cqc�k���Y�a%.S����JIw�[�*���7�L�}�����=`ޓ[P�����E)�ꣻd/�cQ44Q~?����焏�k^~��)	�����!��>��$\J��l�<Vw���,    ��iQe�Ki?���
�h6��ytgLy�4�8	sپ�W '�C��6��{�@�P#wat��x� P��K��gQ����jeR�Fj8����Ō������3(5W!��~I���k�\�o�(ȍ+�)u�\��Ҵe���߽�>)��CV*^�~�E)�(��t(]J�꾋x2\���ݟJgar_�q���I��7����Zt.����KQ~�����x�S�:)4 ����,J�;��-��(ȃ���7���LA�B�v�Hg�_�o��q��/Z��ɌI�FQ$T^-��/ٷ��P�ɶ"�0���;&�i��C^��7�}��q����hi� ������3(㐁p�����I�F�S��fLL��t��1�	���eW��'ɾ�0�1����͠��;���q���i\�&#ŉ�Jx�/[�Li�T���6����P�?�e�)�����7d?����"��"��ga�'��K���_Y-�:3���K9F���ΘqS��K�����l�wG�`:	o=����q��em�Z4�=M���K���w�4d�sY~��E��c��z���I��&>c��e�Wo~-�fET�q�����7W�Ϣ�$�#����/������Zx_+�(�|���3W���!�ک�wÃk�Ͱ (Aت����6M�)ŵ�JSfJ}r�7�
�:(U"���AiA�Cꐢ|����]p?���N��^�o��-}�A�X}�L5�<���94�r��1-�J����փ�/)�XG�\�#�o��0y��������}���ff�߁j]%��pgL{�6�W¸B&�1�ݙzT�h�`���h-�Oyɸ|�W�Fy���0��tɽ�*��k�P��Ȏ��O��'�������@U~��a���}ۗ��A)i�~(�����اj����%\�oG̸QB/��7>�P'8���.�M�l�7�)�ozd;|SҸ�;��ɷ4o��È����;cPb�c䝗�"J-F��`6^�� �1�#f�VR$/O��V8��lE/�g���A�A��дn�!饱����%g`jdmc	����R�zA,� ���d�=(~ X�N�� B�3�����L�`.o<]�aà�l�����������,k�'0���,�d#���7��)p�.���u�ad��A��4�60h�em�"�,;&M���<�%g`jh���ZN��0���]�V��9#.Y8������`Pĵ�J/��:K��~�`��b+��BVڥΠ�\�q��вn�a�϶��"o�K/�3l��YJj`.x�M��5>nl��i�3�´�
��4��z�З{咇���ĀaTrJ�^�%gPZ�,L��p'�v��ʔ�q���_c�o)�j���-b�][kd�]�pGJ�k�^�r� �N�fr�L�g
����fvE�A�u�����鎔��6�t��<,��ϒ�"Pr+��G�C��X��?�#����қ.���I���zyd<|S�I���߀��N�6���]�r9z��-(�����#N-����Xї܆��{1A�F�h/8�2��S�#�����):��N۷����:�~s�\7ʻY<��M����h����,8�@��Gc	&�a���дC��<N����`��,oޚ��K:~�w��ߡ	3Ý'�s2�>�JT�ZP̰s�P^i�f�h���Bs��KnB�@O��9p������u9A���a`Z�.|�5���������'�B	�����.��ׯ�TAQ����%�g`���8f��e�1�oL|�΂����#f8�3sN��7����7F�
<�Q��9�j/�����<�Y�'\+#V˄���eA�a��y�����G��
����4�&-�o_����Vy������G$"S\RR����ޘ)��ƴs��g�X`�E_�2�IAT��Y>�����p�2��	�w�ϘM��g5��T4��9ǉ(��mPr
�Q.(|pJ|OOR���>SJ�B�|��gMJf.��F��/�v/)/+��o/{`
�$D5}t�$��޺�T3 ~˒�Cu��NN�(}����ŕ�<PfAl��1��,� �+�Շ����(f�����U��HD�Rr�e1h N&���M�U/Ϙa�˿�ލ~������c���}Ǥ9,Nc+|l���{��W,-%����gL��-���~T;f:��(���篁�����x�u5n�q���*���{��30��i|���E����Tӎ�-��d]g�oB�6���i�7�q^�ʻX\��Te����� e�_z�A{;��¡}�S��@88/k��&����+�[?�nd���Y�i��'��2����e�1h��lG�GХ�w� &�[�9"~��3�Fkc_#"���3F��em�7%��V��۟k�1�Ц���&ߛ3(���a����0��-'�?�n�I S��5�i>����{��0�e�O%�Ȕ� ��C;_(+�o�7(I��G�����q�c��1��?�΢Tm�g�S���ȄwGg#���3(Ur����ޯ�� ��Ds�}I��g���r��ϔq�����׽��2@����)�/ʗGJ�
Li����5(e���}ݪ���p�P�8^��J-��C��J�F�r����7�X�(i�6(�[�H�\�hg�F�gqg�Z����v�g���1��pɽ.ƥ��)�\O0�9@��O3uΆ��ZJ�|�K�ݑ��q��pI�����zP�b\~��@cId�ۅ����k^��r"2^�<���r�)��ӛ���AiØ�;��o�9�2���z�\��3���!�\��3�)4J���s<))��%'��\�.J)U�;j�-m��9DW���6Ñ"�|�G�[�J��"S�Z��i�T&�T8���h�GG����ugJy��Pj)|~���v��fy�~�|�?Ft��WJI��~30�!^c �?x��!�ΤN�K�f��ߎ��JB��[E��)i����D��5��ƙ���9����Ҥy�M~��Ӑ�WY0~�ሩ�Z�Ǻ��nm��s��BK���ng`�]2U�7|��A�)G36���.weܴ�D�eN�q>��;Ffb2�N��w��9a��?\���60�견���lՙ�D�Ke{I��;�������U�١�X��[�H�I���c��M�6-��8~���h�f���0JFf�~�é3(5w��/�oe�tWHͨW���x��gLAw0o���[�0�F{��ʟS�-�#��e�Ռ�$0��2C*8�ݏ��M��9�ay���g��H�D�D61Nr:��ďr1"ΔB����{`�RC/�~Q���۾,���{�9���'.���N859%}w��t�˹��K����نj�\����*e��yw���M+�ti�����1o
����/&ĉRQq\�>I��iߔq��D�����q5)	��;dG>�6(2�l
�&��nZMʰ�e�Y�b�)eT.0g�n�ehCPtxBt<�3�L���Z�.��׋�J
q^�w�����i1���	�n��`a�)�@�}�hD@|��I������*:g���4����n���b�.�vGL��C�G��Ӆ��]SPF��$�_�E�Ҡ�w���Kʭ�F��+c�Ze�o>h)��5�5<=�2���.ņ��lg`L6�g��yOe�@���
v��%�f`����K�]�F��Z�NM��>a�+�a�.O��pf�����>����s:���u�%e?�v�@[!�r�f?�f`0�0�7�����ˬ���c4I�J�����8A4���k:C���Aә�}����\Dm�����/�M�2�c}(��;zSJ�R^3{�w�~	�`>{�g�8pg�X]�wT��Ai)�(#"��hz��Utɿ����?��w���zh!�W����ւL���߽�o
b�T2��������YKZ�r��0&�v��9	a��W�B��/�E?ga4��m3��=M�0�]�`>4�kAX�6�G�-�Iٿ[Hd�"O���M�Ȁ����ژr1��7��!q����;Bt^ �  ��a4�v��vH��:��x�~
��H�2����"A6�L��HA�\���j[���V?H�X�P��g��?s��h�K�y��I�w��W)-��G�����(Ƹrʆ��>������sF{��6�=�iV��Ϛ�a���%�e�1RJ����^Z����q�h�b�B͢|`�����ŝn9�ܙ2�z��?�y8	m�`R�b��r�w��p���ܼR�����:L�����y�3�=�������Ia��!��/2���GL���"�'~�¤ ������$���mG�K��y8���>�y�x?��!�,O��1m�f�pVꢼ&~'�����?ga���il��/y�D�	r��D|�K��˰˙��Y�2�=����LI��
�Q'~"΢��Q\?΢ԩs��e��;uP[��X��Fya�� x��OSj�ɪ"~/�E���gpr������\�2$�Q��(�p!N�laޔ��g��\�3ASʪHr� v˳��3u�O���bA�)}�!���ʿ��oy�,Ú}�ɍBX�ޚj$���G�Q��J�#O�8��te�I�?{Wo%Mm��j4�|R�y�3e*2�;(~n��ޔ���=����pgJ��ё���;(yNY�%tJ?w����qڽ�������9)(r1�N)�G�Cc��r8S��d����gHK*|L��l��)�h�R��8'�wo�leNJ��n�ݼ��$Զ�<1���)�{[���Y��AGj�}b6�P�h.L�����S%��^�;����{�4i���;�Hb�(iJ��82YiFԍ�Z�JZL!��Y<S�S�P\}�����(_ �-� 	ih�ȳ�� �I��W��{�,{��sA��[��S�T��KNR|��3E�>Z}o�������`�.Ԫ�vC�0y�g�5/?�b7�1PY���y?�i����}�g�^r�6s��$��曪�p!��C�,d9<�K�]�3F�e&��5�S��1Ϋ�q��G]v�Ӳ����.>c���ڂq�vI
;&��/��o����a�c���L�6o��K�;F�<o�e�4�4���^�����u���K�@V��\�z��þ�E��f��<��3h���7�%���W�P܂���6�Nq�'O
�p���<C��������X��      �   @   x�3�v�twt��sWv
��s�44��!##c]#]#C3++C�\1z\\\ �Ej      �   ~  x�m�Mn�0F��Sp�T���T(�$�
 u������ԟdY�Ï����47-1m�I��v��|b�X����t�����4ˀL�@c�yi'd��L�H�\_r�$�9+ce�8ù�G��
2ј�snؤK��0t����$�!��w=��A(��rt��n�%'{ �ӈ�-�d����>�s#qv���Vѣ�!�8�D	�D?P�����Ou�$RsKjN�8=�o$y�Dbi�~�N�?n�g��5��
�IWI�@L$�׺N�tY����0S�y�[;t�,�o����)��.Z z��r9��~n
�6|c�E�v�����Tc�jHy�S��ݔؖ�'$���
�ye#8gL�F�7�_�j~ҍ)������e[�Ö��R�A�t      �   2  x���M��J�ל_ы�����ՠ��"�`�(""�*����[�43s�Mm&b=���oʲ�ܟH�B� @���#'��C����`��/@����9��<��d+\�����3��|���n������q.��IPK��|��A���D@7ؘ���ݰ0� � &z����<ϫ�P�����'���/���(�1�|��|���\���l���8:�i�]A�ͼ��v!���ҝ
^t��;:)�u���TD-X,v(�@���,b(�e8�#�?ᕏ?�g_�O�P\��%"�  �$	(�$	�p��D��2����H|w�_����B��j�__�����a$N�_lMa���d��C�����Tu(�pm	�㾴uf}S�(|��7>�ծ��ANϲhu�������]��L��Hu�h��# ˸�[�^>�u��F�)��7IB������w�n�x�����~��k/
<������(��ĉ��23����'�:j��rA�C`����P���骈�I�o�T�2<�F?����+Z=�W�6aϽ�p;"�aĄ�;|��$��mO"�+C����X����U�za*]���3�E��-�^�t���x]�]�}B��i?��.�[�^��44���Qb:�l�=���\f�CbB_~2Q�!}z*�EwGx��t.My��9p�m/΀����n���y[�&���y������N��M�'�D�5揀h����<Ek�W��S���[F��ʑt\�:�qWe��3v���F�Cwq���u)d:���Ƀ`�\O���Ô!*�z'D,QB��"�"U���ޝ�Ag��6Em.�SE�
{���_��.C�/�Pw��	�� ��V?ut�X�{�`��R�:����OW�:���d�@:-��v�A�Yv��+9[Ƒ�y"�3ayQ�x�Jyt��EuЏc�i{e"ЛL&��$W���4�5a�i(���_$>x8�'�t^rz�5��1��z/����O
YC��dmO&X2��7r�-�O�"_;�Ҳ7����n�Cc��ױ�3^`�'���Za�ٕ�#��T�i�?�����5ڞH�6��+��#� �Iʳ/!��/}�*��^`�hc�#���=뙄�����3�&q^-����&�r��~�H\�$m��� �f��0}�%��t��tT@;v&�&qFJ�C<>%`�]eB��� �r����7n���O��l!�h��(��n�=[��������c+�����@!���a\�y�(�I�F��Ax9�z�j�Ŋ�QLW�H��P��� ��Ԙ�@�+t|%�^m�5�"���+��E˩�7�\�(�ud)�U!�I#ݹ=��4����7�,7�X�!���;����]d`� "U�!�h{����oF���+M�����k�����6��MKoh��8�-gY�[�ĹD_Vm�t��=�]�{����W P���o[� �� MbE�.��1a���u�
k�SD�MySM�9 �8�M�x�]v��)�̕#NmW�K����=$��/��q1/Ѫ�j�*�
��Eaq��+�!$�����UTs�̂s*k�v�N���%�j�{ꓗ����.��,����V�
/�����Y���
a�[�bzR�ԡ>]S�+[/�?�CZL�b�f<�&�Ig�z@\,NBϺ�WN%�YN���P��=�*�����O(�����WQY��f��Ao���+;��U�u�`����;�ɜ'N�]{*�צFU��F[-�J%�5��T4fH������*d��*�޹���2������w%z�:�l|:��trs�D�o�G�����:S���(J:`;dթjC��	_q��|RUu��������#���9^�o�I�y'|�ܻ�wP��i�8���m��9��=��	���1�a��	����Ga�ڐK��^���C��*��.�tKٓA���� n�T{E.-�H��03�C�S��T!��2�a{�_Ҝ.�����*P�u��������t{D�Ŕsp�䅾���ۄd�XXw7�{���ť�o��l݆�$`Q��~�s��� U����_�~���'N      �   0  x���An�0E��O��2��Yz�s�DSM�E����,��K^�T��{��h�#EÔ����M��)���Hu�0�j��+y2�q�}Ӗ:�	c�F캪1��ݫLc3��i�1�c���:�a�F�M��G5�1�{�=;x1x'vd[�>��s���I:V�Ӿ|[�38���Z���$K���18�Ҫ[�t.� YZ����diG���^�d)5���0Ēe��g��dY'^c�~���sr�R�&�ۑ}2�����&�:�c�?w�]����&[0��]�T��Y�C����8��z:�������-      �      x������ � �         `  x�u�ˍ�0�di ��O*b+H�u,�,�&��&Y0ߣ	, x�����a�-�I+��`�{k�W����q�o⊡8��=����c��AC	0��<~Te�Y��V�0�3o���A+�J`�{�uV��V�	}���0���{s���S�I��b�
νg[��;���ދ=n�;�5��ˑŨj��y��]���.�>/������x���=O�YZ���fi�ϋ�7���d���>/�>�����Eמ������՞�g(���'>��Q��3r��?�,mH�yƱb��-<��f�C+�Yڰ�7�4<�B{��a�6�y���k����,m��"�ǎ͝G^1|� �GR            x������ � �            x������ � �            x�ŝK��F�EǙ���p��`V]mզ�2uMJ=�t�� q� ?�q!� �������"���7yӠ�3���t(������g�OI*C���1�<�yx����߿���~����s�N���~����;N���>$M_j�i?�bo2�����??���?�s�$pR_N'��pJ_N���H�A�A_� $@�S,��ӧA
�vE�bg�d�@z��AP٢
�� �E^Ad�.��0�axe�-��H��E^At���xx���t��!ʠ�e��eP��2�wA4m�]�?A4wA��El�A0���}N/�ӷ�o@i�p:}�;��3v�3v�3vSg�(�� �Q,�Ax���d0X}A�����=�ćȠi�;��>���VVˣ�9J��kN�I>�����%c�_��VYs?���儎@W:�ft��"�h!�G��������W�4	��x�}��߿��7�p= �t�g�s�����!��|�#�樏uJn���� [��%@�a#�:KR\	b��C��Ap,̶��.�q���X�w�������S ��8X���6+}�����=���w��$�Ⱥ��ß��վWd�"��� ׾?�C�<vA��:� A�A� O�A� ϝA� /�A0X�b�/��.mѺ�$h~���<y!r�r�o\,�*&�������EΎ���r:��m^Y�|.��Ly�`�����#�OD=��;.8>�����Cu쎳�̕���?�K���_=-#��g�Wn�+
���a7<�_�����a/8�1Ҧc� �v:�v�;`����x: �nյ/� �%����%������7EVv�#/%m^�.
W{*rU��hp8���S; �k�\48��}��P�6F�C��	�9!��%��O�6�%��� �ő�]���F�.�-N�>hnem`ay��S�A#-#��FZ�-W!���iXHh�e�\:��K#Y�p���#X�*��Jw<�Fĳ�U��b��Ϯ1�����JG�^Z���v���N@+���tt��hHJu6�Z5������պ��҄3|��d��_�9h8�W+N���Zo2�p��զ�O��χ��p���&gX+��)e��7�,4Ԭ�\a��fM�*-h�Y�>(	
�߈�p.% G�P� 8b���#vx���;�
np�Ȏ\�7(pt��U��w3ղ�[/����~�^�Q_��,��4���<n잂a�ʣ�^��s	�+县��Ö�n�[��\K7xŕ�����;��.z�_��v-�ק�N��ے|u����?�gJ��������.$���~X���uC`������z!"V})�� ���R��*.�^���i��x�	y���(�k�g�9����[���xI^|��H�-��D�)B���s\`q��G��@h7D"vC��Ժ!`z��0=M���Y|��?����.���.h(�g��D>m��lt��e��:��F�A��f�ђЦ�Ylt)�ym�B�jೡkmf�T�^�kU�l�Z�|6t�Mn��е�|6t�&>���os�еZ�l�Z�t��A��e��\窴`�Q�Dχ7߿G��&:�����e����FR���ȋ�����M	$�hqXl��-VL����v ���	�t <����P̿���9��h��m&�E=nS�&a��<j�랂D	�TaR�ʤ"@Z#�����c�OUL6Ҡ�s���([RY�9����([R��xmK< �׶�p�����-� 8^ے��-� 8DF*��)�p 
״��^������pMe?�kj�yp(\S�σC��~
�T���P��Ɵ�µU�48���g�1Z�J"���VN1.Zc< ��v "� 8D&�����Cdb9 �����j�p "ck�	�[�V1:V- �Ș �Ș ��X: ��| "c� 8D�*��p k5_U�k���[}�b��� ��y< �s; �s? ��t 
�� 8��p(�W>3&4��	�M��&#�t���t[2���n�q�����L�ꈫ�UgT��QuԖj�а�R���]��Љ��q�LFJ�d)1��s�9@M
[M�vb��o3�����L��_x:섞����Hh:��	h��3�NG�]��dtDͦ�3�IW�@::-��6�N.�˦^��|pg4~pt4~p:�JGC�5����v�	W�����hh�f6�5�����5�ӷ4_����[�+�#�(����_uDA�G��!�Q�hi�t4�4!�NGCHc��!�1��(��X�hH�m�Yk44��w����ٖ��}�P3��w�jf[ڮ�AC��}qIh��mi�����-����a\�N��3,�"�7��:�⁎�]��аkW:v푎�]��͒аkw2Z1Ȯ6À]�;��]����Fv�j3ٵ��0hd׮6�`��]����Fv�j3ٵ��h��Z��1�n���1D���}�x_K���������HG�}-FG�}-NG#� ��FTA2���-S������{����j�l4��O�5ײ�j�P<ʇ=	OJGC�S������hhxr:��II��F���BG�#m&��[�>h�Y޲��>h�Y޲��>h�Y޲�>h�u޲)�>h�u޲)�>h�u޲C�.hTTz޲C�>h�u^۵-�;�샆]�@Gî��Ѱ�t4���hx)��h�Yq:jV5+���|~o�wK����|�	I�����4�x�R�����HGCRډ�$4$�:I�������F#���P��R3]��=�Y
���@m@+�@G::mtt���t��+Й�6t��P�hz�f_��j&�������P3Q:j&�������P3ٲS�.h�]K��a�멪a^�;�a�뙪4�Z���]��Ѱk�t4캝�JAG�+� �b�˸���]���1o���RGy�� �n�P6u�}���������FG[�BGCT�zPu��{e�])
Q�JGCTc��!���hW�l4��R,t4���r����vm[�]ۖ6�Aîm����a׶es�}аk3:��m�Xc4\۲��>h��m�Tc4�R�`%S��>vBCR<�ѐ:��JGCR<�ѐ���������ѐOt4$�3���W�"Z��!))�ѐ�$t4$%)II����$��!)��hHJJt4$%e6��):jv��Ӏ��:O���P��h�Y:j������HGCͲ��P��l4�S.t4�:7v��n�6vBîK��a�E�h�uQ:v]"����:�Y]�C�L�NM7���T���cV���cV#��G56e���'����N3���]����f�6.xah��ްM�U?$���f�:��R�g~��iļ�i�4�ӱL���9��!�O!��<}��k`^���*WҜF���þ��~�ר6�:�R����9�A�I�l�5�]�_`Mg.���;U�K����hG�`���C�2��^,1��Scݗ8�ֿF����{Y*����h�����p���s���-�?��_��L��/��QYc!�����ڎ[$�gעZ��h���JGg�#]�6:��l4
Ak�e��ն�[{��y�5�BGC����$4��5k�[��P3W:j摎�����P3w6��k;C�.[ʟ;�!)�%�Ҥ_YhHJ;�������HhHJ;�������HhHJ;�������8h�v|	5Kk5+��o��Ϛ
5K�����@GCͲ��P��t4�,G:j�����eg�3�9��P��R3�Z�D��ACRr��!)%�ѐ�"t4$�(I)��V�`,�b)��hH�)���.�'��6G(���#Θ^�z��L�8e����%��6������65���L�G�
]V;�&B����6���m>섎@�)F�����R���A�����G���0�$�D��+Й���؝х�F�L���+����b���^�� A	  3�������vr�ǿ��4Ҡ�E�V��5���`Ϝ�ĩ�>�Ệ��E�E�e��=���G|�Q�U���f�mf�ẤŇ����xY��i����?�V�H�Etz��մ��41����Z�<�lD�n�vCD<���(��vC\�'vCd �� �s.X���]��¹3�'�9�:"��/��"iN����1�^��a@H7���	�����n��wC��<�B�sZFĺ�[g������u{醀u���;#`�)tBƥ�Z�>�5�M]�˴��\�>�x�y�6�x��B@�Wh3�$���K�J@de)wFY��"Fj��q�WnTֶ�x�+W����U+�?<g������>�p�·}�а��c��y%_��2&`�T�,���1��[�EFّ�<aYh��-��{��{ńb�� ��r_I��x< n��p�ˢ ǻ,��0�X�pd���p$�l�4b���v޶��s��a�f�a�mc ;o�482�ms ^ /��pm� �Q�
�(I��p%%~��a���
�qR�(J��p)%~��a���
��R�(KI:@����J(pbP�H��P��C� �Ȥt "��p�L*�!2���r%9 ���u���}��Cd�M���Cd�m���Cd� ���t "��l4�"���d�"�+����#_yg��i�� rK}�<��wx!��M�|���|v;����g��]��t6^�!>�y��xr�^�!+��z��G�ņ�d糡-9��Ж��lhK.|6�%W:��՟�z$��L����^+۫S��]�H�Vg(l"��ݶ���z	���'�A���x�c�����J��T��¤VP+��sG��HP�IUPu��S�9j52��1��3�	�ĤfP��Tjm�ujĳ8�����㧨�¤VP+�*�&	L*�I�I�6�2��&�L*�I�I�6�3��&IL*�IVڤ�=l��C��6h|+���pU�u�^q�NR�\�T*���˅F�p�P)U.:��˅R�q��*u.j��1wYrN�9�N�ݯro��K���Q�^W[�|3� ~'��ꘃ��o��&�P?/gt:��M����޺=��ß�S��r�@WX�����:!���u[)%���Ҍl��n_ڄB�6!��1R� 8R�% G��pT�? ��qI��=mvǠ��֑����z�qF;�`���H���4�N���kc�2.!�jǡ�x��Ƙ=x�^������nL\0�������д�����NO��I8��sq���Ѹw!�Ѹ���hL��Fg��B"�S�f�u�-/[���Fhf�n�i�n�c����l��������z!OT��y%�'�h7���!�D��}���*��דǬ�Ǭ+��~�:�N�m^�
돿�	x�^&�&����-m�* ��Q�S1єIŘD�L*&'�1��hΤb��%{�JYM3[�P�ȽM�����i~yB�����D�Pʆ�a����D�`��Ե/���4'���滣{_=��qz �ڰ�k�,D�} ����>���z�ڰ���S�sT�6���׆&�&�W&��L*ܝI��{bR�t{L]�&�=P�o�wt3�t"�+_M�>O�����L��oN���S���¤B���	r��
�J¤B��2����T�p2&"��I�H�D�b�_h���ٳ��!��N��6Q���q���8E<j3�;,<j�;,�^f��F��$�7�Gg<�ޤ����z�B�
�	O��D${,@`B³��<&�;�m�;K���O0!h9����
�#$�
����EOKT\^ӄ[�OkO���/���e;�wu�8�l��@si�^fr��Kw��4LO���i�����o?�ƛ�D�zǩG7E��V�Zi��))����u(�z�� ~�� ~,�C)���(����!����\P�n�j�@.�Z7���pk���0���"�CL�m���n;LwF�9h�IwF�Wo{GwF�5oEwF�o�B�E\�����]�2�z�Lo��g.�|(���v �-��v�|@������S���e�j���<��M톀�I������/�[(���&\�Po�5�O�k��N[�׃�8m�^�cF����.�+�6��@���t���y2?t����Y��)�}��:}����`�Y�Ǆq�1a�%ј.MΏ��JZ������b�ӷ��է�b3ܞ\�?�i*��t��Ncʫe�F�>u~8�d�Ӱ���S	Nc���N�L����3�1u��φ~/���iLi��4�-�py�������z��T^     