PGDMP     !                    {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �   &           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
    public          postgres    false    303   S�                0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    309   p�      �          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    210   ��      �          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    212   �      �          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at) FROM stdin;
    public          postgres    false    214   4�      #          0    34018    invoice_detail_log 
   TABLE DATA             COPY public.invoice_detail_log (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, created_at_insert) FROM stdin;
    public          postgres    false    318   �z                 0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    315   k�      �          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    215   �      �          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    217   )�                0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    295   ��      �          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    219   ��      �          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    221   ��      �          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    222   ��      �          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    223   ��      �          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    224   ��      �          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    226   ��      �          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    227   ��      �          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    228   !�      �          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    230   U      �          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    231   (2      �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    233   �A                0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    312   B                0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    314   �E      �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    235   �N      �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    236   O      �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    238   DO      �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    240   aO      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    242   4P      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    244   �Q      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    245   �a      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    246   �c      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    247   (h      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   hj      �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    249   �k                0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    310   q      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    250   %q      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    252   |�      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    253   8�      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    255   ��      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    257   ,�      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    260   x�      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    261   3�      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    263   ��      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    264   �      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    266   �      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    267   "�      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    269   ?�      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    270   ��                0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    297   Q�                0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    299   n�                0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    301   ��                0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    307   ��      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    272   š      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    274   ��      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    275   ��      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   |�      "          0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    317   	�      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    278   �l      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    258   Nm      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    280   �n      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    281   w      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   ^x                0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    285   {x                0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    287   �y                0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    289   z                0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    290   %z      Z           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    203            [           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    205            \           0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    292            ]           0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    304            ^           0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    207            _           0    0    customers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.customers_id_seq', 1256, true);
          public          postgres    false    209            `           0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    302            a           0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    308            b           0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    211            c           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    213            d           0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 1648, true);
          public          postgres    false    216            e           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    218            f           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    220            g           0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    225            h           0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2209, true);
          public          postgres    false    229            i           0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 515, true);
          public          postgres    false    232            j           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    234            k           0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 361, true);
          public          postgres    false    313            l           0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 47, true);
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
          public          postgres    false    277                       0    0    stock_log_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stock_log_id_seq', 4119, true);
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
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      �      x����vɑ�{�~
��f��※ �� TYp�M��^�t�4K��Y=O���<摖H���E�ׅ}��p77�C߽�~8���ߏﾎ/�����]ӻ���CӾs����7>��	p�{篚�*yU�_����-$b�o��w��'�ڸ��Kj�U�����}����x�r���|��Β���k�@��~�Ӷ�Y4�%ì�!�����!4��Z�GO�~{� ^5�U�x"xؘ�+?�B��p�G�Wӫ7}B�� ��]�����{8k��D���S7�A���o���0( 
�e��Ǜ�o@�/|r�� �ʸ�^w�p�ZUC�w�n�\����ĥa� éy��ُ_�O��zc�!����5��������%��ʧ�24k����p}�%�B��! �>�=R��f!�D��p����_œ�a�Zo7���E��*?��j�����Wq��~��j �����˫�d��:�!� ~�,�`zޭ�! ���k6Y��ѓ�4��e�Ј�r_�5����<\ܕZ{��5�:{�כ'A���F�����awɺo����^�b�������2A�b�jA����4y�A�������vr�T�����~�7t�3�j-��7�.������cp�^o��K>��j|� ����F�vqH:j�[�����������=^��oޫ�=l�����d+,��YC�{��}y|cEp1�������� Њ�0o,����/퓪!-כw�3�?>|9�nr(m�]*&w4��
��!@ݻ����/����_(������'�YCL���s�=�s>hv=9�I������[�#�]�=CGi_}�ZP��DtW�L�ɠj��o7�by��J���R<����!��˸{k�:�ꮚ�!�/y��%�\�j������/ӻp��z8o^j1ϗ/������G�W5����o�/�,���|H�;w��^��}y&���_u�3!��!4�|��Ugʡ�16i�&V���5 fhJ�w���>m����Ev�Smp����w�q�]����%�̃	���_k|��LVT���~|ޭ�I�5&PkL�a\��n4������4k�w���PS���ƛ��iO�ӫs^k-}�q��f�t~�����3T��+���q�F�j��N<�YC��l�_�����u��If�a�hT��%�����\{��� ����vH��nzIBw�m�g&]�XfWq%��h�5�N�כ�. gk��ҩD�@�tuӿ}��tfY�N�Q5&�u���N^� ��j	�9v���A�jz�l��i&�L��/)k����x���tC�>&6K�m� ��rKv�^��kb��g�ӷ�5��9|���s�S�1��z�h�L�p�����%��jB�+���4LN�j'��/�#%���1�i�^�Hj��E���t��Z>,	X�:���~zS�ثe��KR5���_��H�7h��2��������G�j��erb� Wq�y�!����x�-?�����5�~q1-O��edr� v1���w�K�j@|��5����ő5�|z7~��>����_6������˘��a��I9N.�0��K,��Ԣ�	�^� ����6�k?~�o�S�����nܿ�O����<����������v��%_���t@�<�&��i~���^�IR�����a|������	1�''��P�}�ժ5�����7��Z�i���&5� ��"y���@�z��Pb�]qh�� ]1?��� �|��Q��I-�X��<�~w�����Lj�������9�6�����N�'H�AH�>m&���hBu�+5�#{��8�[,�AI�\�k��=�ʰ�� ���N���'��A��R�@r(�������4��b��1�/�l��c'��RC8"-��$5��k9�w��6�@�P����x�@���d���|��T�N����ǝ�)d�ҫ��}����������l"�y�����A$)���������[�A �j��O�T�2ȟ�����_��j���������/����_m$.���W5�d�$������n!����L��j����2ȿ����c#�9t(ns���z�%#@\^�b��R�@g��>�+J���0J���/c�Ӷ֩�A~�ݸ��Cd55��	���P����˗�S5����)7r�� #4��g�{;G�jN8H�8(&�����ѡ-y��ۇ��
��N� rS?�\3H�|�A ��~6�'孀� ��1���mg���N�·V�F� ��Ai��˹�M��yJh��_�{��4M�A ��Rꃑ#���5����Зi�ߝ9ֱ��Z\k�y:�ߎ�s6�le��������a#GR�/��UWq�
Gs�:�i�1�0� ���� ��ڼ�1����A��O۟쏣��R�8�3]�1y�A� ��>�/�����a�ð��:�s.o߼�asa��5��P+B���B�v-�ɻW�!T�d%H���Q����Oo�?k��"�D@��f�vF���VzU���m��Q��?��j���|]�U�h�|�yV����QY���k�x�yd�H�oe�A�B��h_O �q����!�1ۤ�fU�8��n9�m��b�!\����}�ѦHO�5���͇��y�f&N�T���~�|X��Q_k-�O�~�ͬ �5�� �����O��g�k-�6�=�F���A$m�0WJ�u�8�F�j�莅6F�$��q�%9i��Z�� �roo�tCNC�^� �P�흙�5�w� ���-ߏY�8r���gC��h3-����}C+�~|>��8�R�5�#�q�ٺń�Lr��В�I�`�>�6]4�:��� "ZZ?n.߭�6��m����q��*�ԩ�������D�q���?(�g8��yf��C>�G�ru�5���?�2��B>��t�5������<��	�Xc�H����� 
�~�^?^�Q������A� �4�xߪE���۽�Amq��w�7-�'�AW�|}#3[��&�� ZC�����9sG/E:}XC(<���'�]��'��y��e[�!�ל�Z���fo�����$;kC(��&��� j�jb�jW!�D��6{�!�+�	!��%��Юy
鵶�� Z?.�Д �ZR\k��\v�S�A� :�[�Ed��!\ߴ�yھ�W5���ʕҕ��y׼�9�̍/��A���tV��MJ<��`e�thy����͆j#�B�6�'�r����q�a=�j��6�k?�Z�@h�x�e!V�����B��z����D�\���L3yf���M�A4���'�3��m�W�5�q���T��2���r��l4�*�Z�@���ak������<������d�e�~-� Z[?��n��jjO7� ��7�jqs;4M�OT���GJh~���E�۽�n�S��'i� Ze7�[�����>�q�pdu�b5ӧ��T�כ�5 q�@X�@\�b�~���A�����h����#!8U�H����h���B�8h��x?�O�]��F�jO��ݘ�_�hv[U�@��ݬ�A� ZZ�ח�g��ri	�RI}�\�s4�_��ka�u��d&���-k�Gz�t���_L�V�r%a")�M�͆m.��2���P�6�W�tGf⠕uG���g�Ǵ��bW>n�d�Z�h=��t!�H�b��D�%M�o�霭�tuF������sGs�r7�5����Ý�`X�ųp���[C��\�����EL��ş![��h�Q�8��\��6�����TG/�2Ax�_TkA\A���D@yAn�|Y��r����ɆGk�J�D�q��	!U�B��c��e�B�AeM4
����WK	R{J�D�z�t��?}X�|q^/p�I�j �n~��/�@�՚(4� ^�����U"HǙn���>�_v����=Q� ����?\~y�A�j -��M��    �]��!�x&�V���SDt�s��{�Pk�<��k=�`Zͻ8�r^�	M�M	��2�DKR�K��S	����g�D����������T%�b!_s��uB����X��/��4�Lo�<]�o#{�y��Eab(C�ު������AhA�k^o�z4�;�A�}�Yąк�1Uʵ��Uk����!��B�8�e+����F� ��UI<�yH�jH)K�6Zbݳ��67k�/���drO^� ���z�P�3���z|��������Hss$�%U��� �tw0]��n����A�͕�Q5���������Dh��=+,��g�Ӂ%&UCP�����׀��:mEh�[Q�:�<yYY�8<O�5���.���s��$�!8�A$�k�W�����D���g��]>� ZX7L9gl3.���q�������<s_����﮷�.|G���EDA��x����J���M�5��V� >ߡ��.X*��$N�m��p��J�:�Hh	�Q��P���t�]N���9$ը��*��i���T%4�!͝M�9���M�Ԝy�	B��=ߘt��U�A<�;�V�G;�m�FCB�jM?ǃ�υ	)���A�*7MhR	�n�j�W7=%��z�g��� Lh�>��O���f9ok6����Ѻ�4~��QC��E��t)U[�� $����F�*�(4�#���3�ڴ�%]�⫟����n@:L[�J���c��ˏ����B�x��\f���A�>zs�
}�w��.�^LD��uՍ�� ��9�j~�j��I�A$������n�����@��z�u�cX��G�p�|B��㛶�׶�����L(4�������ZN�l5.������w���l&��w���X��+��d�:��� �T~3F_4�ap�����&�����Wa⠵��qo*6�%"��B�T��a�1~#>�8ɰ�� ������t���=]?�ѴU����Ԕ�OeE��<�;��Љ��ɇ� "�a�Ow���*Qs�^� *n���RH1%��J΍�'4��ej��Xh��i��}Cr�?M�I%�E6B���[{�Ma*�.�xYh�F�>�ʰ�fP5��㷛�i�J%��-?*� 4�#�{�A$\45no�?Qh@XTA�)�֡(�$�T��	"�W[��D�8����]��ս�����	}m��!�9_� � <>�n��fz�0_k{�Wp�͸�q�|u�f�h�A����%��E�#( �hqF�@z�Ug{������#M6�'�mաThGǃMVp�f�f5�����l��R�(��A(��n?���-��A�:�h3.�G����n�S>������k����d3L���Xq� ��La��*R�Q�T[���i���s=���z׷��;=f�4�}:U���Q�7���s��UYOu���"� ��� TG�m�j�+�������U�@h�'�<�ٲʰ����p�*�~ؖ9�2�^h�����d2o�^� ��0�n�j
��K����]�5���6_��⠤���MQ۶�$~I�D�Q[����,�At	f��Ӗ�ujT���S���6S��)4���6�^Hm�1�U�@8:��5U8Mh����O3G[9nB�8�Lv<?\O�^� �t��0�ܱY_�����<��l�n,4��n�O����FC_ujB������ٌC5�Fh���6�����h.1\��� ����n��|�;Lh��׶"�O?� �k�)��6�hB�8�u�����L2TYRB�Hx��
:��^� ����!��j=ZIhI��+��cu�&4��)�@���#Wx����j_�]�����g�ΫB�hm���s�pX�������0U�0�Y�8�-3d4�*GIhH�
�du�YvZ�g�g
���뛘RמfOw4��+4�ty�k��L�1
���p��թ�:D���&4�kf
���[�A,��>o�M#��0�� ����+HRS]�!�����`J��m����� ��R�A d�hհѮ: )c�&����u�� �	�=>m�K��<yK���׎zV_�jB�@��l3Vp�A���Jg@Z側�)IX��86�W�g�����)߇�Ʀ�q
!	͚{���"u˗����2����*)Mh�����$�t�t[JDRʸl�Gl�_>�Y�@⚴Ҏꕚ�s4k-�[�l�髣�� ���RY��l���B�8��U�:F�[�Am�^�Znl�h�G	�u���T��F��UBC@���~�������� ^Vבt�%�� ��چ�t%UÝ�#hߗKB3H���Q5$r��SL����6Mh��毷����j���_L���t8yU�@JB�6VK�p��D� ���.��Z�jEZ�ax�^x���S����1������r��qx�~�6�0>-����PV�'[&v7W\�qЂz�ُ��f�Pe�"��q:BX
S���Z�j�Z�����������nN���K*kGϭVw��dtr��(�Q�@hQ�c��d�pT����E������jT�pe������c� ������,�����Vf����:���y� ��$T��B�@JՀq���֢B�0x��vU�0��V�:�	�joYÑ�kg�A\'`Qq��_. �!]����<rW��k����=m�w�jU� x��-;��æ��A |�_G�U�m�A$Q�������������昨Җп)"CFsF�W5�+m�v��־t��#������uk:S�͡jG%4��#�k@�An�ݰ�����3��΀���_h��l�l-i�l��Ҋ���E�:����#4�$�����DW%��+n��f��[hG*7ަ�32��ևB�@(���َѝ�.�A]iHi}AZ������:�n�h���B�@�]�1��c�q���2�& w_j�ٴ���U�56��m1�o	k��޲jg'$��zU�@�[=�Β��� ���j�d�а�Xe["I��)��F��#�5��ҍ�i4 ����� ^]W��fy��5���������jY�����t�b=�t˹B@RӬ�n��M�⻙5�����`�HU�UhGi�1宲Ѯ���k�����TxMVs�d�j	/�������jG*;�~���$�A� 	��7Ow�|^�;,��Y�X(�z�h�A��6��o�A��uA���'k�����h�W5d:�?lL��}��T���A���9/߃,���q���%!�/�1�
r� n��ß<��Qr�[e�!W�4	⠮+�8�b�;jG����!4����#E|�U�@h5]R�"�2�,�5�Q5��j�lǝ)��h�U5�d�D������D�n�V_���jIX�>x(52�JhI\�Qy6*�������h�i���!�Ѿ՛�I}/4��� ��Mդ�A �T��5 r�2�m�-��@����%4��Y�%�Y�B�HJ���/,O��p(��֐����=R⬶��٨�<��uc:N�9-1<��1q���a��v�:���_N@{��2:k=�O�����y�Zz�9�q�1�&�u�)Ӝ�q���io��&��n�#4�˭���;_Z������+{g���t`����V׶��LuWI�As��������]F��kJ���J6�r�Kh��T�gٿ�ܴx���a���tk�t�\w��RO���C�jꂪA$}�s]�⽪A(��~|��6f��<ڪB³��ǟL�F�Ѵ|OX�@880~���I�ҥ�5���\-ђ٤K�a�c�"+HR@�NNf�X���Qf`�z���wq��5��W�f��ʽ��Ub)��e1Dh�����͸| �1�x
���㝙#,|��pp�գ�Vo(��MR5�����Qy;"�vp��ø7����W�p�A �i]R��Xj��RW�G����~�t^� ���r0U��6��zf-�c��    �d|=�f�jw���4�?!A���_�w����Nw�����/�� *h�����+�<���������=C�'+�D��VkIbP5���L�zd35�C�Q�8�K�����@���J�A\$`e���q���=�����Tgl
����SI]C��F��D0̷�� �V�!=_X�e�2A+�X�As(Ւ�R�VM֤��r�ޙ����H��c��Ƅ�O�v$H}��1|��f+/��q�x�q�p�QЙ$%U��r�n	�f�4��5�¦{S��hS�AJ��5s?���G���2���`����F�6������.��Q��w[��l���Q� _~�'�o^�z�M%5��L�vg8V�I�EJ�%�`i&Rl����A�e�gK�{6�ZY�(5�$S�$I����z��>Y�d�U�}��kI_j!V�$�j
_�o,�]l3�R:U8ڦ)y]ϦKԣ�ب���̮�,��A,|�ߚ&'f�!��M�j-�������T�h�)(X�P��a��&C�jF*�2��9����%
kJ[f��J��f�W5�+���>�::�U3>��%�������I]�(h]}�ǉ��>H!p��~��^�K"p�����o�.����{���"�(3��!�1���.��S]�ʴ��|�"5���.��\�;q�2���Ux����Q�!������厵�JGj����� UN�� �r�4��,���^ɰ��.�ʇF��MFC#�RJ9f�[.R&�<�\�����kK��Ѩt|�������c��leʏ� ^;W�8�AhKq���'�/�˱�Od� �[Z����~[Sg�b5VgW�A$*�`S�vWg4�C�kIj'��!$�9��B��n��9�.ے�A@ty�yR�\h�&ô�Dy&撈5��DI��D ����7��.t]��~8}�`��(R���=h[����]�3�)V5�R��ڳSE�G4���Nry�gu�*4��77�3�-�Ʒگ6��xx�AH���ǐ��Xhײ�6Z��C�\���*Sl���!L����Uwǹnh���"�F� Ncݏ��A٦�F�^� ��c�������зQ#�&�ol� "ξ�V!�n�}�j[��\��O5kP�q���ώD�N;S�л��Ƥ�yܺQ����Zy����?�Q%
�..�DD���èU�^dj��AL=w����Q
|���5Rߡ@�����ps����^v��'gַ��D�b��St��� H�:	B"����a�v ���[��� �L��EK��ֹ*���6���
��d�T"�%�ǉzU��h�~�hy>4]Hmש>=��q]����+���&�}t�S��ݨ����}��OT>�i�: ��~w�QuoQ���AL����d�cs�h��[��S>ô�:R(0��T�r����.t�yuզ��S5ɽQ�����N�a��D>��AH\.�����|iq���A�K__����������s:�TB�%i�G�B�jSL�W�D�r�5��=�t7�EM�;��F=v�q��񇈂�!"5��o �թIR��4ߩ�А��TB*s�~��W5��k�a*�tr�<#������/��uo�Pt��M��;�eX�nm��r!��A�~���0L��^�c����E��*ǮZ7�I67�>}����I��:DhH���:�i��z�O�|����x�w5��-�1/��=�`����4z�����D�k?�U���F�}�k��RiЩ��w��͙�Q7��Мa�uƮ��y��#-k���Qsd��P�/Rx�S���"@h��=L�f]3�M8���u��� "Z�?R���k&��ra��:�
��\棅DR�����t�&�y[��7�rhcks�T!�;ؒh� "
�����}�݃"�o�]R5���![m���#�Z�A<�<��W�_.�z#d~��d��� $N�˃��_��4ClN/���{�oRj�*�G/�0���{�OC}d���B����!����zߝF�z�2T"��ȳXw�59�F��:/�D��x�A+�@�C{A� ��-1n��Y?=��cԉ�q�R��8GD�>l 
��<���ݎm����	⠅��v����j��Z�䭉p�q�{���8��ڒx&VGW�A0>�l`��:��҈h���T �h�ٙ�!Js�w���)o�c� "��RA2P�[��<����E�A@��Y�*�rd/��T�h�bm�5�(��[5&�v�����B�_žʖD��z��� 2�/�\������R���������U�� ����M�l3U�B�8�zoT��]�&��)�����a"*�'T�3 ���2��f�wv���3��(._c�"G�����3���TG��wѫ��ޚ�ڔ�鼪1���J����PH5���.)y{d;7?�U�	����M���O�KB2vn��{��4��
��4�^� "��������q�k�tg�~1YUj	�ǟ�f@��	~:������LD]���=�~{&���� x����8*4�hY���{�.���|�w��H��w��5�Ӫ�QM^�m�4}�/����d!4ȝ?��|R5��V���F������ ��A�'˙4Rw��ڄq�R��
�{U�@RY�Ѫ�A��qgj�CF��!&U�@:n�tm
[D��5�#*4���÷�V.������rj�kTb*α�J#R�$T��!\v�{4�h�%�QLے���/L=�"�<��]h��m��d3TQ�q��zg\�6stoP5�#rK��۽eL1O	kʜ�a:�є�}�B��~�M����Z������,>�A@W|Y�Ա$W�N� �~-�P��a+1&v����e�[KK�b2,?�Y�0ȗ_f��܂g��ʒ��Pt6��뼪A \P�
$V�b���c��U=��V1(�A(�'�����KJ�.RzT}�+4���S\�m��I�A\�}�E�}N��}�R9F���ab������˟F�c��4մ8�AD������|wz�D�]ݦHh��m�l[ 7��O�G�`�v�ln���|1R{�G�<���p �W5�#p#�ۭa�u�=�A \x=��A��T�<	�H��a�X�]������=Q �������ӖHFCWU�)!�O�ok@ZU�@�y�ɓL9[qZ0d|Kh	��=�/���D-	������(��A(���l�{%ȕ_|t�R7I�S��.4)p����Ҋ��Uր� Zeׂ�� ���pc���i��'4k�����G+ȴ��F� ZgW������S5u��&�B�8�y�`ى�h����! <�m-�<�)������A��̬A��m7�a��\��j̰�����Gh��A\m�h��R�s�zU�8����p�EgYV
bi���ƧB��S�j	���n�N�$�>"��>�t���$�ث�����E�����;k��}��Y_��f
��x����~6=]����ں�j�Hu��A��n>W�!)��A���Q��I�P���P.����?��8j'�~|��Nt�<aP5��k���q�l|[='�8U�`ha]���Q�`� �V�tUa��.L����q/6�*�Dh�<C�cH�O�����J�Ob8�_��H"��p6��3��������J��T5MB�H�5���ysole�C�A&4����Ý�������u;�A$\q���&?��]���XYϏB� "Zx7��k29��}�� Zr�aȨ�� *9�NZ�B�k�#4 ���oj����	��A�]�갚� N.����ܿS� �-X�ѝ�,	��﹀�zk�]�FM������uA� vc��;]�-V�Y�0J���G�u5�� ��t,_��.�B�@�>e��g�ua�����m�H[I�N� �]w�ݍu�	y7�A$�xUa|I��iD�]��O�l����hU�Hb� �BY-%F�ե�� ZXׂ�V� ����vk�8Rv�}R5��+C_��Q:IU]�� ��۱�    ��f����(S㾍��M�*t��]�@��Qh9����4z�-�U]�j	���7���3����QE���!qf֊E�/KU�H��垭v��P\���cը7�>Cnj����ȽpgBᚮG���Vu�B�8(vc���6�*�)4������)�EVC]�+4�d�3��P�-9��Q5�#��-�Nɇ�>:eH[�����AH|�5ޚ����4I� ��������|���~7�����A,!�����l�p�H�A�π��S�Y�
�H�����c�a�$�r�����׿��+�t�q��A�Kƥ����A�[��u��O�<jI)���?��� �! \ҵ���ׅ��V��$ӛ闏�5�ė��6�mv���Q�8(H��c1���L��KU��6��F�������&�B���۰s]��(��]��*o��R��?~���?+�q������s��EN3�.A� ��g��l�LD2�����A(=ߺ�=l��}w(_ru�q�v:�Y�6Z;�BC@ϙ�h�S �1VQI�A ܷ�S�1��j�D�ߛ�ک�+���,4�d\��d]�-O�B�@J�u��A<�g�o-�d4��)�� ��,q�b]�5�c@��?�Z�2,��~���"4����'�Ņ�<�J��U8AhO	�Z.��d��#4�k�6ڽ\���y���f��k/�����i�)��D�����J�\Y!!4�#�ӀR��C�8�z��$Y�uF�� �X��^�ݧ��hv9n���F� �t>�J��	罪A<�gg*�m&�j]��<���<���S��>�2� 4�/��tn��܌Y'J��%�ADOö]�v�}�K���t��&�:�b��� �B[�ႪAt��hz�F뾧B�@ª��9U�0(�kM��J$;������Z��r���d��UU"b���'��5�pۅKu� n��8���v����0�$�Q5�����1⑍v��Q�@xF�ˣ�\�S��������jK�<����W�k�����UB����~s�V�b;RN�;����AD�4��6F�S��-�Kȶu��,D4w?�i�ֽ�h��O�T\>#� "���k����^��e�N?��t"bw�Ɩ���(Ģ��� ��T��.D���+���������ހ:O��.�Ӑ}O��n�C�D�볞�s�WΨ����~Tk�-L��AL�xR��t��T����p�[��>�C�n��5��c�j�N�2���(�x�<�jP5��,�,M����f5N� n�x����²>������0�>*ןm?<*�ƻ��Ш�O>ZV�2B��8Nq{�+�R�5�Ϸ�����F�}����D4���ӗlڰ��X8��W��VF�S$�n�%4��a[�o��p�f��Wa����A�
ߏ�� Ӂ�-AX�@���n|1��\G�^� ��ˍ���ogP��t�A(������S߭^� J�x�5j�)��/O��q�ܽ��Ѡ������P�w-H
���p}�n4���[�Q�8�`SF���j��?mnlo*��
��A�u����g��A>�ˣzu⺡w�k�@äB�ē�\��x:U�x�|⏏{�\�����U5��(��'S��l���P�ڸ�~#��S�dv�� Ff�u��_�p�n�w��ޙ
��괒�jd�A$n��j�pˌx�A|�vor��fL����A� �6�j6*k��D��g �H��`�H�������	� ��p���qxZ.��A��l%#�ؒ�A�I�#U)dB�0hA�����a������l
A9왃!��Ae9�s,�ޅq��sc�a��� �A �#��/��^�d6�����k
I��`#4��Vԟ��^�l�d˝5���oL�aCi��;U�8:�B�l�I��tuF�@z��Y?޸<a	�P�J��(4�#6s᳕#���Ae�͙I�C�>�Ө�P:q/���\��.�$5U�Yh�^��绦�N��%��y�����%r^� �T�y-ILI��q��A ����&��A�Z�~y̚5�_���B�F� �y�M�altPh�h�|EXCXR�ʧO��d�5ñ_`ݎ]P��q���t�*!ZhG���+8\���m����*�ChGYRWp�K7i� ���Lv��KΧ^�8����9�����w�E'�2U�ʠ�@��W�0p_���e��|��B�udK�<q��.��:��?�Gs��RB��p?mp��G_uD��W2���УYm(E�w���N��@��ݣ�p;���8tJZ�@U
a�8jR���%kJ-��)P��\�ž�U��u��!D�3�|FGb�xz�#u�!q���Ak�8�,�5>w�S�B�j�!q�쵚�|i�5������^)u}��d>��[�߬AHnN�y����}y������7��(up�A(a.�_l���򢳜� ��M\-�q�z�;��}�o�s�ZR5(�o�G���U�ADmq�ϔ�NW8MR���t/�R���!�>\�y�c��6`�S�!�R'�ԥ!�*��L�%5��ǔ]o>�l|�uM��;6��/_&� $^���+L����rM!�\O����;m;m��Jd�*Qleڢ� "^����qj�jn�/��A$�;~����Q�@������j��� v��l���j<}$�E:�s��U ����N����x��T%^I)��%�YlV�!��l�˚�9!R�@Jk1��k�:,��Y�H���⯚FƝ���\s�������y���A1s�����g+H��T�����׿������jr��P3ǿ��Ͽ�8B.�A� ����?�����wC#���T�	�o��f��>7v���A�lO"5 �5MC$��������R6��K�5��˟��_����\9~WjKi�HA+ޫ������O%��5����"������_m()7DozU�Ph����L+�߬,9�Tci�����<��*zU�@:zS���Ͽh�{ϰ2h'5�eaȕ�F[�ЫM��l4�
8U�@\�c�Y}.Pkt#�������JgI~y"�5�ŗ�L�X��?R�X(G��ԛ�m��a �$k�$Ǿ|r���4��� 5��k~��S5���i���v6Zg�J��u �ew�0Nm�n�/����Pb��������a"�Ag�ۯ��z�q��g=kH�~m*����a�T5����OS	5��WhI�0��C(���Q�P���V�0N[E��Q�HZ��>پcOc��Q�@ʘ^3G�4I��ݝ�7Z����zR�H�Y���e���E���A$�\�Y��<��������Gcl4��Wg4�s���_~�]90�۰�dL'�E����u���0�@T?�O%0x�����D�����ן�a
W����HhK���������T��R�P(����~i�F��8��6�A'IUcJ�a$|=���=GP5�,�����r��CJ�i�v�<wU����Ӹ����V}��?꣆�̓x֡�+U�a(��=�bg�!g���jJ(S�l��l6��׸���U#������R'�V}_������#�:�z#:jJ)�8��2+J6���p����h���Fj�:�F2C�W6��x-AfI��~�,n7O��U#qs�dӁ����bSh
{��<2:y�a	��F��B��S�j�nǽ�d���d�a,��~��<������wM;$w��J�t�+��0"^m)TBÐ8�1�Q����0��9�p��'��a�)M�woV%���Ww�B�hŽ~��������S�� �����t�f�`�W'�cp\R�p����Uo8�a������h@�б�0�W��q���%�M.�&���z���T�(�i����O#�Ȝ�jDɠ����D�y q�,X�0h�?_|/q-kA_&�>��!wv��Ap�����fio�G� ]�jC�'�o���%�l1�˝k�0
w�L����GTC�����\FӨ���%����M�f�f���>��/u�y�|�&Tg�a0�N+�ۍ �^j�s��0�v�Fj�� S
  >��;�^L���\h��sǙ�O���B�xoy��������a<8a�r����<��]&!I� �2y�鐋a/��=�����a�1���n\����d�a��c��|��7�a �K �j�%7��UUh
��oM�)l�],gGI<��vKV��845��圛gSFT(2�/4��S���7��e(��ɫF�}����f��j[�#�����TĞ�z�f{U�XJu�s�w%����ԝ.���IV}y������q��)&ҥ�puF�|�x�~�p�%���D��a����p��sa�U�W�a|̿�^�x��PE��A�1��᳁a�(ܒ�5��8��nw�!�*%MhC���c�ƱY2��З���B�%�BˠkD9���v�g`���@�y�ק�V{����@��������)�S5�N�ۧ��_��k]�Bjb�����1��~��2��Lᄡ�!M�R!�/�T�h����:Y��	��k$Sb�K��_k��L#:��	�򒄆�|#{gI˅s� ה�3�e����M��0�AԦm:I�3������iS"e�{U�HB��j��QU�@����\^�(�#���1�%��\ ����W5���C��W�9��a$]9�� {��2�N�0����8=���p�g#��A��q��*T� _� �ޛ�rd6֩%B�P��~{�}���Zu�a$2�%g���{ͬae\�g;Hw�@X�@"?�����2���:k	UY��K2��;�5�-��l_0���-��0����A�[D��B����$w#T!��4��m���M5���v����� [DK��C�x}�_�f�b���0>��[2p��9�B�8���ߛ�Nvs��v���P��㋙�WN��0������$yb˒�5���Q�LF����B�@x���`��R�G��C������ꂌ����2p�Y�	m�1.4d]�T��_:U�H�=�x���~#L�U�`J�����`�Aeþ��C��g�^�J�]^�
!vH]�/4������r�"�y%[����p�����!QK��
y
�ev���d�xb�S���a$�Îv����a<�k��1�̒�X���eS�S���P������䮍)#͕Z��a�6;�� ����{x6�0R�����f�0�XZ1[=��qk���F�]XV�x�jI���T��vK�d�0N�7��SI�uA�0�`W��(�CF3�+�K9���ҷ�5���@��ֺ�v���BK��q�8��7f�j��0_|GSn$[��[r�a$�8��HzU�Hȍ=L'R;I�+BhIZ��Q�U�A�������ǁ�xWT�%񺆑�Yߦ;��h�5���>���V�S5���X}�Z�I�L�|&���pY�:bM�㞪a �Ǌ�}d���a ������ ��X�FBm�V�,����P�����/���Қ�����N�0���y���o+P������2�௶���uI�0�>�BkI��j	O'����Z���A$}C��~�����ʬa<���_��i�ٍ
K��xz&�P�e�q�0���߿�8�S�>j�~��OS�<��->����p��u(���+5�W�~7���ro�M�a$�����f{a���E�5����#�����RwK_�mB�X(c���m�pmi�)�ԅ�P���|�dE�^����P�`|ޚ���P�	#ᴭO�W%W+.�0���o�M�����*)4��������Nv��B�B�X(�`���f�{�	������~��>��LhJ�(��M�¹�֯�{��V�0Zh������ʯӣ�����u_ON����B�X(�`�0>XABS�
�UvH������*���Y�m(�t����"�
��}	I��cJrhK5_hT)1ٽ%Ϗ��:�Zh'��:˷����M�ү�'��a ��k����
���Z��7#HXVB�����t%IV]ݩEh�/I��a��Th���a,�L�M)�-eM?F�j
'��{S��h�U5�.�>l�M#��jU���0��s��gb; r��3�B�^��ՅMT��U#�E�e�5EO�)���a��q��5$��jI�D³����֒HFVS=�Gh�����L1-����?k��Ԝu$u��a$aE#*2:���Y�@x�}���1��87)��B�l��oGI'��a(%Rpo?r3��TC�Uv�h�%���Q5�_���6k�� '?�����-�'A�Y�Pș�j��F�E���a ���ac���^���B��ᣑ�����j�&X�pMf�.��0Z�ff��W5���Ȳ����UC���iT@��5�ts��Zϣ�
'TB�X����$o�V�B�~<\���T"9��_'�嫞�>�/����3�=y}��R��j�r
�����W�eP5��w���i��TC)����[�
	��ݗ�XצY�l�UI�?r`�6�o�Q�A�0^a׀tU.��0�u�kN��O�kH��ؕ$�u��+��2���k�4����A���T!���v�x��$�F��:�a�9j
-��J=�ڞ�vk��a,s�-��C��]H�����������9            x������ � �            x������ � �      �   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      �      x������ � �      �      x�̽Y�9�,��w���v >�_���.)dU����:�~܏0UN�y��d�
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
DYB}��v.�;�.yN��Q	��=%p4�>��XK�X@0��A�%��P�Q�ra����΢�"C�j�@v[�\�T�춋J�T7N��m�	a瞮�C?�*�X������>��ύ�X�I����+n{�<��p����"bJ�d�C�2��lE�ۅ��Xn��j4�XR6�y!<��o棊u�4�fo�ø��k�UŬ�&ȃT=�F�Q>��nT1ҷ|�!x���'3�8p&5���;�bn���\�"F�����v��y�}c_�k�*�15�-#�<���!K�X�i�65Xll�k�c��sU[5+�U���L�p����o1�f��u$_k��LN�#�65V&4�7�?��z�-�fq���'��7�D�2�>"ͤ���ڷ�Xnc�>wE~���n���k܅)ۍL{f�����IJ��"��@�Y��a���u��$㈦](q
�#[����0��v01?C����~�������Z�O�DH�8j�nGBÑ�u���7�j<�Gɋౚ� ��j/���Q�HBQ�|���,	 g��jBw,��o�c����	�q|)��1��<@H��G��v�ݢ�)U��%��a11Vg�I4���ot�X�� ��x��$K�� +W6��0�	����	���hO@�c��Y\�h��=h�aj��	V�g�5jYה0�l�<"�VUX��8��q]XcN���^�؋Q�"0���1w3:�,7������b�D�5Q�H����(ƽ�څɫ�D`�>*�j�D��$�+7dJ�ʬ��k���������OZ�'��s�{.:Q�Q��9�c ��FlcZn�3��|8|Z�Ekp)Â�؈��n�i31�3���	��]�� `���o��:�5���ĸD*tF��Ict�|�<<�S��[Z���oP��-#�iF���ߡ0^��n�{��Scա�8�$��UE���71-S,h~*jiHt61I+Ә�*4r8��RAʕT�/s�Å��Ds�iaH�=^�jb�lX����DY�fbB#��wlvӾ�1�T�*�!�sl21�i)�:�T���-����`O��E�}�d7����&�    �
��[�&�pE�c6ǬP�ǵJq��]�K�c��*G��:c.&vZY9���z��0�O&�A�c�Ė�jc�EV��/aA5�<*ґ�d�J�Lj�������3�>	qf(ufZT�|�W���uu^@��*�f�gi_܎A	��Ҹ3����c�y$�2�ͅF_MLKn�<�����*'�cp!��kA*�B���:�AX�H��AF>9�����d��H/���P�e-�V�ש�@3�!���;��EG^8|f�ӸA������{�,x2�剑�I��%�}��)!����:h�}!�&�^��B�S�n�1������"�i�C�@���M=�w�8���˩:a5Q/�.:�s�p	K��Q�f�o���Q9N�v�4�kdobZ �1lj>�%�����ɧ�������(m#aq�(��׷�M�j>��3�=��Ӵ|�ʶO	�^�:�y=��01�q��]����ŔaR�&�1J�Ԭ�3p5&֑�OCk�`���pf���]���b�n�FM앐�1"&7�d��ݾ�p��-�%x{��H+���(x�h�zT(R[5$\���nbM��<��Ӡ�mБc��
xbwQy�U#��ϸ�i����V�Z>��6_9aK����KM���r�e�Ua�!a��(��X�� "�'!�a�I��{�g�`�y�p��9������`���C��I��f�c�k����Ug�b��e�=R���-v�ɐ�x9���q�'�"j1���dS��Pz��<:z�@R�o���sU�k���l{d��YL��v[<�}����m}8�G�bb�uwO�b�K�E�#��Ύ`ɴ��lɀ��f��㡷�ݬX���|��}s��C�[_��;_�R�HFy﷨��}Hd&)�VuĭOa��N<�5g���5��nO���"�~��t����5��NT�h�Q˛�?���qԑ����0/��˚�>2��Mh���tՃ&F�4'&v�	��0�4�f�]L`y��wM@!�kP0�Ⲑ� �UF#_��NL.'�H��U*����#�6�tPx���]�>QYT�0-��,�	�KVA�Cuu41���{�ش�""��IK�P�!7�p_���0�kX1`� �T�FZLL��<��*��Ta�BZ����ʶRF�H��Y�}�K˔�PU���U�0��i�*��5�<B�a��#�4���^N�ݽ����
�@4 �"^?"v��."M�If��W�1,��L/9��F�؎���<�F�&x��q��9'j�5<د�j�]�Ha�\�{lɱPK�0]hv���H����C�x(�uډ��p#��r)��Rqϴ��ҁ�v�.�]��N��kZ:-bF3���w�j����a�I/߻lu
�ܺ��Z@�BS����D�
á���k�x����R�����E��Z54�xD7��S�;�XL�nQ����>�~�����?���l��V&Q���L��Ӹ�X��  �5��!�W��Bd*/�o�NŬ7������Ux;@-׾ѵ����k����u�I,���.2�����X2~���zJ�Y���]l���`���v���m�*T{g�c�X�`X��}l���x�%�ɇ_n�"&�rx��v�]D$QLc�؛_קG6)g���D���q&��i��c'}&��(o4��F�٩�-A]ݾ���'��F|�X���ϥ�<a=rz��+���}�0͍�y�nt��7���!�9�*z���n2L�%?�b,���D�`�G��3C��M�ޒ�H�e�a�)��b�b���?Ӿ�TSVNDQoi���[O�J悉�%��y�0&�N.���𙁔cZ~!29L�����^qa��,�&�2��oz@5*aVĠi8���04��f��s�F��C:�<^�bb�@N�2�T��"`xaj��WZc�����C�vܻ��8��n	����`��""q��Lfd(��(X:����N��M0�����������z��^{F�G:�N+�,U?�5�fgb��]��ꝁҨ��i���P�r���{��r�����\H�c�5t]L�2��%�CF/}�������-��$��`�9�H��H�C��<��9��q�C	�v1�̔;A��G3����j��H��������q%D6����]UB��q�^:����љXG�4�I��.2�EBh0�[#��oy���PdnXx�u��À�;��ݡ<aǠ眉5���j0�ޡU����Ui����2�� �xcL&��e\�7B5Q��1Q\�'i�Δ�6�i&�[m��J���Z��LG	:���3�̽���3L��d�|t���s��`m%�.��X�}���03�YM�s��ػ���*�7�XR���7�N�L���t�[R`�����%�#$Q!~%���:����2�&�Т�E(9+��Aau2���4����ZR[��ta�;LP��^�$%Lzv1Ę�\�����	S�8����,bR�lO����<�瘻��"�|���I��Uw���;=�3�m/z�D�0?LaI��彿o�#��!����˖�.-[�>��LW�`�x�Y�V�U��nq���,r!��^C�&&�>	��<',�����̱�.��K�y�[T�Y!D���n���.���؍�����������x�(�Տf/��'&:�÷!\::�@&����d�.�̢������|oQ!�!�ʮX�ŏ&��MBa(�N[��9[�sNc��0�ᛋ��r�HH
/]C�&&��@U�د����SY{�0=��0�b�5���+e�h(�2m6�>@%����ϜP��@(�Ʒ�O����`-��סDv�>���mxH+�{hi�XS(�H�0�	<�&N0?
0�LLr1�3���g�U���pG�V&��f��h6?Ӵc�I�g���\���<,}5/6F�C~}Y��0)/��M�٠�ّ��@ʭ�:�%�x�1N�ջᮊ,��]`�h���M���Q��5���Б�Yd$}Lc�:�\R�M��58�M����҉��!����	1���)c�RB-�t�Wd��l?�����5Ψ�\��%��l�Б�5dz�F��(��*���n���ַdL��k71�o	n4�&3]L�:	Fd']+*s�u�*�=	�o�����kF�s�B.a�R�T�#����)<ܪ�s���Yp�V�[�ɛ��f!Z�6��l�i?o&��~����:'����y�ĻR5�pQ��tKX�&2!#�%װ��ĳ��C�΄���J��uO���nZ򰡧�-ǉu�t���*�>2�IǨ��������fb�������F�O:6�G�u�h���n��4���`���jbjYS���w�d31������j`,T��
2L�9x�G*b`����"g��GT��XW:T]Č�k����t�Gr��X�oBe��<����d,�O��9߼9��g.}�ٹo�v������Q[�>.�0�Ob�e;������ĸF4�]�񕄶�He`�	� �.���>�����Ğ�����[���5"u:	m:���
i�\��bb�V7��R�j�4�h[�� ɭ*6sQ	u31���pV�0�l���op����V���,���#�NK�fv�p�_�k���.6��bZD��jAz���2�CЃE��T_YЃP	A3I��Zy��ܒ$�`����s���z�3@���Gomm���g�$��i�n���/��5��������
b�4eݥ���Ĩ�)q��4]ËF�H�0fz�,�Ġ3⮗�ևm��ѐ�T���-����)h�ͳ�� >�9t䛣߅_2L��8���Cn�� �0� ���`S1@ě�6%,����f/�ī���~�\2�h���D�~�aZ��!�4x�R�C����m�Q�"�sb�q�.�pcg����Ґ8/vؼ�G�S��"�1�6hY��05���T�-Y���6J��\��[�H�D��&�DR��ѥE��zԖ<��X6��ң6�A%�+zoTa���TvH:1���^Ym������4�3%4�r�~�L�\:m����    Ac215�ŹX8Fr֡{��t����e\�Z�S3,V�������.M'��cH�2@�"�yg�3���Î�� n�W�0b��<r�a�j�n�\�����Jq�]`��?�����&)�����%LL|�D���֥�e��0]�Y'��$��`�X0���B�f�m�K�36�U&	����q�Ѣx����@s�)������5���Bx,Ă�K&Q��O&ֱca��M�.*�DV��Z"�*s�L��Ъ#�u����9;�TZu2�$��g��~z��Щ�Y%����4�%�����S'�VS"�3��ur�&��3iaR�=v����r��\{|��P�kxq"�ag��G6Ǹ��p�@A���T�x��W���ܽs.�"��2���x�O���~�ܸ\� �u5�b��s�ޜ=�T��s����("/�P����e���5s(;���S?�Έk�(b�����	��d;T^�9��31�!��}ŎX����F�1ra����ް�F����ok'Ô����!��@[��2t1ō&F��3�9Cgh�v���}�['��_G��q��d̕T�(KS:�ֳ�7h7>��n�Q��������ZLL�����b��>L@�ΰ���Q����4*��ĤJpBc!��jU�ֳ�9�{�B�vn�ѷ3"�.XRb*��_�:51&)q�3|����R�����S�aB�_%��az�&�-_E9�ƷќM��PA �p&֛r�&j}�J�� jC�~�Û�k�f�ɳH�Aj^����1Y���@* �F�^�Lk1���h��o�ư�rH�.��������k�0�ߕg;XӴmZ��9�RyL�j�Us.�c��+�"�V���Bcĕ�U�HpA.���c$%2$�B�(Zh��Ĥ�$�1N�祝�Z"�aɄ�"���&x�t�����9��y���Iz�8f�ߺ��L�l욉_���o?������X�zu�#���4ٸ�`�t�f�j{��J}��dRq̅UB!ob=���,�^�F,��3�����T�{��Q2��GجXz�h���M���������H��D��jr�zh	 ���4aJ���X(��+E5�->����r��Kࢼ+ZL�wE�Ǹ7�:��|x����/���F?堒G\��m�c,Έ����e�_��T �����+������R�&gbJh��z#���c!gb�f��J+�8OSٻ*aB����í���  <��$"�y�����Jm1Q�k�1��gDf"qR�R��H0?�� �������OK�S�A�*�D��d�K2�����{�d51iN<l�>M-�lFv�}�>מ29.��R��p�"dX�� ��b_,`S�(��k@ú���F����`�&F�#��#���S�?��ǲQT�:4�X`R�pj��4�ٕ�gŽ,�+g��8�/�r��ʲ��i��D
�xt�R��`���#^l���Ĩ���Y�x�1T��1Q�HH��d���V�Z��$�}v�k֦1&���q`�v��[�
��ޛ�7k��a�Q���CΥ-�L���=z�P��W�qW��O%A��
���N&�|����M�[d?�:ݴ�k�$�i��'�ݴ��Hj���R)��*���Vadiq�.���� -���ĩT���O�-ؒabp�҂3N^-f%:���hb]�ǘ�jgb��Ȝ�AB!���xt&�V��>[+�k��h��\�]<^,����q�����oίS��䘙U�?��B��nb��g�9��o�.�S"�,���jbZ\��g1_������l����EQ���x��&�v�p���c���a�����x5�#�܉D�{�k��}������fKw�}����(�0�+;����(hG	�
�����#����r�ʥ�ӔgQ���\9�BDb31-2Hx�z����xH�&֔����4(��z9�ę��O�x9H;�W#.Z�����ѵ� ��R*���eGS�iءb��\��{��/e����C5�-H2>���G��y�Ti�>���kobʹ��L{8��a�?r��]�:��^ǀ�n�����Č�t� �~�`e�T9^z���[,��'�X�"�kT���`�LԵǵ�*�A�f�y/�ĸe��i�� 4v���=�x7�h'0���H�C"�<��D�%��7���<lѿ>�f��&����iG�F&������(����(�qR�x�ǋ�����<6�~;�2L�q�L��i�3�jh���C� �t�$�a���c��|�L��^�0ѫ�P|9R�Jk�AG�<�ƾ����xfM�rL]�nV3�=�RǍ%��a��Bm��fB-oa�zg�,h<p
^�BnF�ǋ.��恄	oF�Żx�wO�5T3��4�#Y�ޠp���1���g�ݿ�?z�L�2Ԟ}j���L�8�8��<0�T�����!�l&�nh�8�V��h���0z���#%.(`���_]L�
���6lf�nb\��}̤��=a5�5�y�~��_�l|�+q5ƿ�l�1�ll�E�3P�/��k�,U)�^��Pn���wZs�t��^��Q
����<v��77��59�N�Z�O��Q��.�R�%s�������=e��ܣ����+ɣ��唝1�{�����W"&LV�6��uPq����k�~���]���Xg��h5�P&]��	�*�z�#����ێ�a��OE�߃[���M�=���[��$fW��f����*FH�i1�/�=t&�^a���c�>��+��c�0r� 582�-.��G��+�{�򼃉���q��}P|���wS0֞>�gSe^-!"�UI�M��2�#f��E����d�5L��U�{����"$�]fん���]%r���I�WI9�3T¡Us��ƭ�E�π�����������F���Ũ�>��6;!7�M#��=�Pn��u4���®��[��<y�hK�uH�G�X�=�<k.ǔL������<�o�9&�<"�?�=���)k\��ǚ���<�M���玓����_?�}q��?����n�	Oֱ�$q����'�:q1Q�)����dk�����z4̥�CJ9;q��\W�bV%�c�%@s(�
��H��i֘�8�L�{-�g~�uA�0���Oa��>&M���>J�pS_f�hUMCv�Vgw7�rH\l�<ݚ�f؋�������]޻"��i����%8�r���/�b6�6�Z�&.�%Lk[K��IRSXL��Z�嘬4��0��l|^�c�q[�?���bp�o����*"|b%W�!����K7�~����/�}�����{I �[m&��0O�Tx���k�e����y��2/v�c�Gv:�X��𚰔P���w�%1dip�i�@F���E��p��UQ���ZE�>붊�.����0�D� =VwW�1�E[�	��B���d{��ܺ�rݏ�$��y���'+�ΰ�#bU�|��d7�G�4�a·ʲA1�p�k>�C=S��1��#C�����n01�c���]��i�3b!��>l%5��3���B�ϢNh��p/ժ��e�*>1a�3��
O^+ƶ�v71�Y��F�7�U�h�2�D�r��������H����?>�����������������xr�\<9��l��9&|���7��Ie�T�K6���J	E<ȫ9�鞘�a��ʙ?���W&�\�\2����P�7� �{FO�>B?����8T%�Κ[���3�V���e��{�a�	��
���p&I7��3��.]��|(23N�ܪ�Ƈ;3+��1"����X�#cq���s�C"	�O'>�U�ؼ�<��Y��/��G}�m��ٖ�[L�-��#m�ý���rR9)����5;{�7@iV��_y-�4�	�B�H��|�i���M�D��ԞPq2�c��=i���r�s��<1���R�����Ɛ���[`!�(��{�D�5���4�l{�*�{����==fGP�����8��G+�DO�X~/���4�`��%U� ����Ę T֕TSTO�=�o    &F� ��TJ#-����9Ð�0�� -�u6C��~!�.��bb��o�.�pì8�k1��ca�^�X�����V�1�+^�&VVP.D`���B�~�5)�0a�^mpa]e�cC��х!$RH�o/����w؆m��NNss��\���N�<�'��U=����M�!Ú������� �f%W�<��4^��Л~`�PI�0M�]��4|7�.R^Vi5ϓ�5��]a��*��t]�,@	~��E�r��S"�y.��F�S���;cP��.%#y3���\�����I���g�`}䕋�9=w����l�z�p����I��Ց�J͠�<]W�hb�:O�ڂ�%p���\A�C:g�3`5��F����ۺ�aN��4��������֍?����Z���gP	rqa�Tr����lb�L��Zu\�Nr��E~�ZNˉIv�g�τ3�J��4v�S�a|j��G����c�9w�e�mGC��h~Tg�٬���EC3>^v|OW�;���_�ƥ�F���;	9V����_����x��$1��n�O��������E���Q���v6�B
����CdV��c����r��%�$����>�c�����,0�5����jV�E8�X���*���JO���B&��7��-��í�%k����:`;�#���6��츩o�X����L>.w��M�[LL���bNH�{���ø.�����sJA+�*?���b�na�X�I��k�l�ѻ��7�&FR6SW<�}�t��#W�!E��~J�Y�P��ܼ�rbU-��1�w51�)�q|A��5�+�bHi:�&�Z'�b��ty��q��ɩ��Q��Z٪( �2����>��/�`b�q)��r�l�X�����`���^�P�Vp�a,�bǝ��	�o����J�Y��#̈́O�ת|���6�K-�=�u� ��Ě�'�
<��+3f����2���:y���@��D��`�h�WJ����WC�h�w)��>sI����=h��Vl�k��cO�Fd��gLn���r�<cZ��&i���61"�V_�14RQK��}�B,�
i����P�HI¶R/�.2b�Wvy�'�����p>R~�5�jb/�4&I�PR��V��Ñ�b`�81�� >�6�庘�_N$���k�z��ň=�*E֕����!�6�O�=s�a���~����͂�0�م�����A�`�j�C�1��݇�����nb��=+K��4Ѷ+���Y#��ؿ�6��P�L�~�I����o���zx���9��p�j��,�ߵD��Fd��|�Y�0Uu��d�,�v5���k�ABm�yi��s!B�{&2�ӹ?aaB]?�ѩQ�ȕ��Kh7�L��ҕ�Q ���x,����w�:�Ұ2L�s.J[�����ژ���v[�pcin�uN���c��0��+�1��+���Xx�$rOm�0|��,pk`�1��4�i$h�wH�5wfX�(��)# ��
Q�)�sl���K��XY5�q�p����5�Bƃ-�����N��Wy�&K�H�ʯQ7�z�3L|�2�c���d�0Z�6S�{!����^ D&ҷ���bKq���1y�8�у�ox:��dQY����FI	����22���<$��9f֫&�^��7����S'�f���f&����*�v��qa-U�g��4�o1���3��}�j����f��}�5v�1ר�Ĵw类,�˩�G�Ͽ~�z�!+���L�e�)��u��l��1�F6�����s7Q1Ϻ>"҂m�05*�x����)�;��F��[W�j6rL�.�&�˛0ۼ�\�QD����0�8�*䑋t�]��&����>L
�I?I�0޴7������k�� A�>��$f6�Fj^��3r�z45��rrB�-�aj����m��4��mAx ��ˎ�!�/�0|�z*���h�=�J��`졩���k{w78�OXV����
��������x�'�8��n$�{O�(3ڌm&�����"�6j��n#���.G��Bj�lb����F���H�OBcQ�],�t����&����f�n)JhP��T���Ќ<M}L��_�����^���~I�rrb�z�dRJ]O��L�E��֮�#+w]p��/�Ē�,�5����j�SZ۬�"B�D���̂'"����;R�9a�-nYJ�������\����Ĵ��cI��+��f,{v71�q㢼̮Q����^f���2k�xѪ�������Z���M�?�x����2��X�~��rL�]oQ2�ZD�L>�c���Qs�-���I��r���f�0�k��bsO��l�P����鈘$�<Hh�`򰆲(e���U,������C��m��ȣe�*�F,�z/E:(��h+Ǹ�]��>]�cX�b���>��{�7�w˗a51���^z�7W��-��y�����8�z��Z�:	k�q
�G�E@�H��e�e��s��E�G
P�5������1τ�1���1FJ�Nkx-O�!�)SMůy+�_��0�)��Ii%%LzR��V�~�Q�-��{��NqQ�E
B5�HA(�c�ނ�.\B���y�#�Z��Lgf�D:��p�LL��V����{�jb���m]��� ~\�[a}J�V�T�o��9Vg�M·_?�~��ϯ�q7@	���U�PϗnO�c
|PC"�/����ZP�� �T�f2��7|����v�찞�kt�3=���.9@�&܃�2�4�4�xL�{�PҘ:w��"צ���R��^)���'̅]+嗏�-��zd!��$���B����Dn�#m�n�.B�]Ĩ8�g��N�Θ���������� "�o�d���AoM�rL�6�H���X��P�%�Q׼�5�:�%Tu)Io�!9��P��y��r,d��
�"u�A+�{i�*��l������s�s��6[��j�"�!E�<��9����Zx�#�p�&�a����E�_��&�a#�#p����1uʙ�Xp3�0��(U�-&R��A��6�ћ���� #e�4�hY)�q����1>����LB>թP��VJ~�+<�C���c��2Ǵ��*R��AD	�3D�Z��WT.؄�)��_a���]��fJ�W�\i�5���1(�~�PA1��AJ�jp�R����¥i\H>��15/g�.�#�2ђ0�y ��r���@��+ f���c]��+|}��.�N�8�6]$��[�C)�m�����y�W�1��N&�]�t��##G�QmCz��2�9�!9����p��H1:ƃ�����Ǩ�1ś�	�r��|ĸe#�(b��wv���:����pAr��hb�E���p��HS��I�A�[�E�ދ�	Gn�Y��/G��y11=������F�Ť��rqW��X���l�����y�z�.���^����,��!����5�Ю�q"' Pn��u$:�f��V]�8q��bbZ�.\z��>c�C���gmp�!��OLU���hӝp��f��R�9�/�ML?�������Vu]���5]r̒tm�{��a[h2v�c>|*��6�)�M�W��n���;�&���%N�t��DrHR'�PT����fb�C�AEuH2"�C�5#�S��F�]p��P>����"���D��#�D��SY�c�=U:^�T]~��8�^_<Sl�=����{^?�p�^�idgb�5�y���A��G��=MZ�~I_�JNR������xv<ji�E��W�2�i:�P�D� ����|���dg��YP1������D���E���O�Wn�]U�߫[�J07^����O߾���h��Ԯ@:�h������.7��f��X�W[�!�&�ڕX{'pQ�J�D�+1���t}�|�9���[E�b)B��{�B恃�.�F9	��.1���o�J��B��ݵsaV��3���XN�^>��%jr�ka���^"�����肒cJ�qP������<d�sT�ML�QaG�Qi0�tTb�U�)6�����լ
�52ǘh?��'݄�w��[��Ŭ�+M���zغ������x�W�WJ���~���   �E�4fL�Lc�#�F�xe�k��ܣ1Т�qˁ��2n []�~��/.�� ��H��F��p ���V]ºV)��dF�\��-q1����n�g�ƥRS�ob�C��`]K�� ���)idi���{�t.y�	����Ň�S8&O�U�x�Sg�����ص%r ��.��טEɸ��J���E&��#������:�a�HGMVLo&&'+r*��E���7C	�rL2j�B�?�h��[��k�olJ����J�C��`a��}0��{}81����5�5�ob��� ��j̈́��Ɵ�j�xl���}��D3Z8u�1��|vF�X��Q�����8ar��c�vn�"�85pň�H��N
\1n?�"�*�3�̥:M�TO"y��0:��eD	�<���F���,X�9s�Q�@��y��G�U��g�Eg���r�6xM.D����.��N�S�a���FM !gb���زW]LcO$4'��i)��O����[MJ#1������%;2�]����w�Z���2ю;�#/�]MY�s��Ƀ%�孞rLSA��it��Q2�[4��k��JX�	^��ND���qK��Ę�q�C�f4�db��\���x�G+@!��X���N,��_�˪�<��'ɮ��<^�qj#on���_�*v15,���i�o�.&�[��q�v]]��J����؅�.�>"R��ቌg�^0��촛�3e���"�kt-��������]l��1�z=�"|9i�1�^x1/�%��	%���	����#����d1��*3�E�f�G�EF~*{Ǜ�qh�c�_9��7s�f=H��1?A�y61�]��`}H�]Hx��~$���y �}�� 3)�gS%�TfRp]���(�9�M����5����D��."͜�'�ۉ+9n+���fQ�pb����Vx�v������NÎ&�z4�s��!����2��b���|�~������Ǎ�������lվ�1�DJi��n>��/���@��$SӘ��uשZ�I$L�~�9;��E������F�$a����P���HHe2�GGK�|�c$ů������	sǨ�;xh�T���p�X���#���F:�=�)켁���c�%N����y�a�.J�Eb��:�ڇ��˾0� d#�P�5�� d<�̱��V�]���y�H�}�h �j�DL4"%a�W�^�&�e��٠�P�>�~�'дBd������$��0���w�Oi��t�]<������������      #      x�͝�$7��W?E�@��>�_��-Uw�JV���l��9� #�<H���v��6m�"�&�$n|��_�T���(c������?��?�������'����C�g�?u|2�Y�g�QYVO�~���ÿ~��=}���_O__�����_޾��W���>�P���;��wL�L���|BQ������Eз�O��	���/��|��������ח���	�Lﴚ�Y�M�����$��<A�񰚦������|��sݚ�ʾ������|����ӿ_�����O�|}}�����"��t�G���x�����b����7[�*+���%d��8˿���e�_���x�H}��L�><{���>��������9
�<[����z����|�����_��WH�Oa�s�)�e���)[���m5- ��z*?f*�
/o��^�~|+���/�����������b��}Vy���@Q2o-�;�Z`�u����h1�sZ�5]ޫ��	e�꒺��n�R��T~˛�[��������ۏ�_�~�������K��.�=k��gm7�U4*����%Tƿ�ĠV�� ��%5�4w�o��,}|�u�������'䩚�:�B&r�#��y�l-*;�~� ��S ]oJ%���C�r�ѡ��R^$��5�+�\!�>ی�֮�ϟ����Gn�]ؼ�6�&�����d��L�X��~ W-�nF3B��l#*c���9z�YRؙ7����X��#P��$@{U�ɦ�y�l`r�jb�g|����d�j~���s{#��ir��¦S��xK\�ŻHȵydԶ�T���_/���F<rJ|zVf�ɆL���Q�t�"�9nW��=��N`�S���k�����<�ߗ���x0t��z:S�踹�W��)��k��ju�F���k�?7����}y�m��~���߿��Y���b
r-2yW�Eb�Ԍ��)8���wٚ�q���?`���nS�"�˗xc��l�g�qo���?GL�^=�<5��,�[��?�h�Y�SD��BF,�5�^U6_�k��Z�?���r9s'� ;Qk}�V)ՠ3�']>�6����r�d!/!fxo�Wx��5���+��{Px�p_ɏ/���鏗o�^~{}���vq����b}mV{�(B�׸�DT�����^D3B*���?�d�"���з}4ڡ�K!d�'|��O��pĲ��G,|��l����]�p00D���f��(D��ы�'��UL��ӹM����<���	��qjPR��-�k�B�*���=�d�w���~m�Y~qଲ��<�,_�߲UA��c�t�5��b^C̊뎪@�<{�ʸ���b�4v���i�I�g��獒�ױ��E�n%������¦�wx���B� ��@����cc����t��_�rQ	mQ.LJ
�kJ���z����xqM�����L��TB6_��
_�h>���@\����eP�P�0Ē�I�&N��5q"�@YB\t�\d��J�*��S��=��,�N��˜�_�_�|?���^��۟__�}k���TV�;O�O�^Yp7��{�T��\I�Fi�8��Sgu�2ĭrLj)$����[6�F\����}��;GFe����L���=޿|��I9��Rv���;�C��	�|1	z����=���R�g�eO�-��B ����9�����?��D�ŀ��� t����KyN�_� y*���k	*ӖC0�xi)g�W���ﲒ�nuJ	��-�rJX��@'-��w����z�1�r�/�뀰���Ԗ���9f����3��3<[��Bp���z�"Λ��ᱞ��lT�]Z�9c9AEYR�
W���=��Ƣ��v��޷�G��O�Za�6W���� ��7��P�?(&�����]�\#D���p�;�D�o����T�/�����MM��i^m1Z<U>��n,���~QW�zU� ���}��q���i�ge��HJEe����r���"�ϔ�&���RMc:�\A=��gQr��@^@���+�nS�h=��q��`��[p�����Ge�̠�{��G�l�VpvyO05X�ޖ/U縼�����K<#�N���m9+�xt�5y�	J�ʘ������N!X�g�Q�B^�+��X�DUH쩒���v&���.6!�ڷ	�ǰeUv�ۄ",xX7SB��O����,D"8A �g��֜�;��_`�Zz߇��%���]v�cwW��6�,zeܲI^Q�\mm��ք���ǰT#�{�u��T���VnV�͜�Í/M�v(ƀ�xY�bDݭ&��ߏ���/߿�}������r3�x+g�����9�Ý����l� �������*��(��ѰߛGFe�RJ�� 	<1)��
�#�\�p_��ٕ�:+����j� b	R~U�}}(�8A<�׏��LGo��PR��t��l��RB����R;,��8v�K�o�&�e������널S:���r���vf䶌���;A-Զ�MG3n<Rr�K�2NN��{�\�l��]�A6��T����!���C"ͅ���ǧ�.-ذ��4��*b��bp��hTU��0}#
�Z-�*Y�E��׸X�7BB:�0�ZU�9�˦U�$�Q[�)�=M�(2�ʘe�2F�%(���ۑ���C�Ge���O��ɬ�{�#X�
<Œ���xo���LB�#T�&9(T�|��v�M봬��TĔ-��^Q��\�.�U�I�v@ ���� �bhR��d���KgH?�''#%tt��cϟ��N�ޝa��b�����J ���'�<'��1s+�u��t2FE�B6r��x%EW�>��U�p�ǫh"z�fS��cY�A6�l��̀"�S����2{	���Hi[���5���*����h6m����7�V��,*���#�?_�I=����|$,$�)	�'i�,��8��t�È��`�d�5���T�5�)ohTV��	(�dN�hi'w�k��y�7:�&m?P���ڴ��~m[f���P��)Fd�x9A��x��+ȹc�К��g�p���$�=w�|~�������3��=���� �
�ͬ���
Ye+�V�.��_=c��'MAH�G�&;qg30}ش�:���%_�%ʫK9g\�ۇ�Q��v�Y�.d�����h�Ѱǫ�ܻqF(k%G�]�3b�x��#k!QL��#��{�~s.+}�MF���d,D�k\B\����V��::�m�m��yxv�7�A�Gc!C"�z=VL�x'0l��3��W�¿�~����ߞ>~��/�މ/�]#��2D�����;S���zQeg�~���}�Q�r�m&&Chg�یb̨�U5.$�����6�ʨla�t��P���l�F���_e��������f�3	���׿J!��.�#4uJ[N9y\�����:�ˣ?`���G��堩єz(�ۧ}����O��Қ�)��v����=�]6���l�\�E��xm�A=������F��w��X����5���k��RB�iAG��[0��%��l��A���a���dQ�')^I����2�%�Us>`�y/wԓa����)_�[��.8[�i���n��c@v��P����-地b��׊b̨�U)#�<j�a!ce(~����c�ѽ�򭹩3���*�#]�K��nx,��ȕ!(f ���e���0�
�A��9�Kl�d�2L)�SBF��l0(ִ�3�ɖ:��Nm!�WK9�*#8{G`�-t��PB�#��uͽ��V�\��"W��æ���T��\3w�3se��.7���+.7>"W��|BM�E����r����b�܀J�2�ˍ�8�vG4#(��M�&CT�{6"����;n:Z��LO[c%LJ�Ī�|�ϵ�4*�ٵ84�)��6��TѸv�L�ޔ�&����$���f�瑜��(����\�w�f`��"N�a��� ��T6KK#�2�	��)��2�ƻ�d��~����P}�{ݻ��*8��졻��[61z\�aֹ�p��*�(a�1����㡰QGTv�������oL�3h�	0�yi�6�$�]�#��.���D�
b)k��    ��XD���9�޾|��k_wa��H}=Qٵ#YC�ft�`�A� iTv~D"�g���w�pV�{Dh�+G����#r�tDθ��e;���Z�v�MȘ}e(E�%hŎZJ��d�	�OE���_��s���d���~s��H�-w�fdW�oθ�Qz,=Ȯz����U�!+�xZ�(Ň��ܣ�B�
�� Y� ����*��ՌM�-����v�WqS:P�?��q�Ɋ�	i�X�	�=F�Yu�0>#�����Y���3�̱ƫ."N\H����v@��ASW�π�Ct� .a�-�_']HK`̘�q����ϻ�l���2��ut!�d�B�	���*BJ��Ș����d��M���wo�d�y	���/C�����	�*c�~�&��*�)e�qB`�ف*�݌2DO��p�;�Kڸ�NVr�`�D��
[
N�Ɡq$ ���xa
!"=�sL4p����i���{��G���i�u�q�2�W�� y�2�%�{��7��l��j �\������}&w����%ĵ��;�p���.��r_&z����*J8��!:ErɣSB���B��Bl���+�wU�RW�2f����?Ô�-&m~����Ce��,¨���î���yT6��'�F�1�P�P�[���QS}C�y��bD���(�I�E��|t��*�����#�y�l3V��i�k��<L<Ih	S���B��NFe�|t1s�]�����
>tc=�8#z��Ќ���S�Hm2�Q�}�47
4�2�-&F��T����;�.��T~�[h4�u���E\����"=S|L�H5������ncv��ȣqcjӒbp{U�zd"�YBdg�)'�d�-?k�[�w��a�4�����@���ͤ�~���13��v�0��vܪ���t���A�&�dT��b��>�����Gq2�!�C��]6ׂ��I98����K.�B��o�q��^E���.�\3��g��f~h�6�Q%�5��{K`��"ĉ�����~��l�-�D���%�:V"i�`�S�d�F�"D�����mhP٤�:����|�ı���k`���qQ[�n����݁i.�ƃ�)����D���d̔c�t����G4<�8�h��0>�b�����i��y�X*c]��)<Rĳ)<y�B[s0]\or�em�1˰�jʔ2
�_H����g���_BD:�gl�J��6c5�E��[wR6�ŧ�&�(�qr��	󤆵̭35*c&1�?�l����b�O���B7 ��X��1����G6�w��]Ƌ:�m\���
!D­B�	K�����pb��[T�2~%E���.;�-��'*�����^B.4;���}De� �i�(�Z�*Z�ϑBc��`� ����"J���(���^!S{�i��f>�q:ݝ��oA����52�OM�8��P���Sv�~��>�/�쮱P��17��m�o���dܴC!��B��E�`�Z�4����Y0�P�����E����*����n�;c�~���k?P�h��5m��x���k�]\�9�D��B���{w�]�L�,��h�rJҦ�c�/�j�$�j���3�K	����,��j5��yU�g�cz�QƝ"�w�Ö��D���Id�,A�f��&�B`fT�����%DIG�[Qĭr"t)����,G�<@���)?�v�D{��b�
�H��%ƹ�vq��;HU�TlBe̎Q��&��l�hO<�<��'PFe,�Q��^��sڢ��+��r�3��+9����s���?n7Lq����c�&���^�#2�*��ԟ�&�Ze2J�hm��'�.�ʳ���{{�����ͧ	}�̚[�b5��M��z���Ơ��CslK��6.Io)L���$�u��qQ��Ϫ��r�Ɩ؂���XT.IH�ri;#���W.IL�r�B\P.IDٸ!���= G	�YdT���;NP��gl�Z$)��iL����l����/s�u"{�.c��Du���6�o�"�׉hȅ��LE�>�ߐFeܢ��Ӄe��()W�$/^��rf_m������lm���6z,m�h����d�d	�WX"B�z�}�������Ρ�Y�e�κ�{	D��<� Ј�|	��)L�)_�䕂������s�Ge��͇YO�fdu1@���Z,�X9ѝ3R^r�q��������ό-ډߴKh���#��񻣌dz�3(�'���rbN�l�zGK�-��j�lފ����m�vv�Kls�Q�����1�m�=#Q�('}�����j�!;���h!�iM(�"��i������ׄC�M�����s֡��)ѷ��������hz���������v!@�I0?�d&�'�"ȣ��-*�rn�0���/E�M���8�:�q�:	W<|���1�eW<|ӪM'��dz�f�<|��~�w]Berc����y<~�,�3�+�>�������&�uّ2�����V1���)e�A*G>E�/��f��\g,J�X�\��{��4LSC܃S�2Z����1�l�a7�S@S��S�t�+�"�ٔc���C��Qvv��^7Lp!m0��oJ�\c�%9�����ֳؠ2ٴ���O�K����h��5H�c�u<�3�=I,<�3���s��f�ܣNK�<%Dƨ���7u�E��h2�m�hs���-���0M�W�1�B�57�ͣ��V�h�4�7),����h�k~4&ۑH��i,D"���(kC(d6�����[�:�ʘ�-�5�c�݂����"����Ȳͅ����A	��9TDe&v�<�E*Wz�N;,gH�&EcJ�l�-��z��}���u[T6�Y:d��<�m��"�,g\<����0ǖ�U�[����e��;��3�.�"H0m6����Ґ��Ce,�BL�oy�[ \���vw�A�f��cp�]1sj�^�˝#�e�̡!���<�,<����;5s�>�|L��Cs�͜sF;т���݀�N3��6ף�%���F?����%� 2�2n'n!bMXru�DK�~�����Ǘ�OO/o?��+���ۏ�O�}}}���uhj.�(l�R	]%�-o2�|D�D�3�յɡz�姈4�~A���""F�d����.��I[���ѳ���A^\�9"��4���(�f�@�T�m%������S�}����?Τ_��J�����c'��F/�Z9
'����V��2<�:��L�z��bB�B������WH9�l�6�,��3��H�`�<6ks0�+N�-Q2�BFFT�SP٬�h@_Do!,��~���]��p��g�!:*&����|��r�qs2XL5�6�2��ȉ)�Geܖ�"DCg5����*�.;�jz��=��&��[=�\X���t�S���N��o���Ee\�oh^~^�-3��	z�\bɳ!�����a��;�	�2f�	9A��� �wh
��;�OFe,��������K���:���P�qm��W��p���ǉMGمW��j�`Ƭжj��NFNv>=�W=sLJ�r�|ͨlmLʠj j�&��*�:�B���h2^u�w��!���}:�V�p���E��xu����M��A��6��;��ӿ�?����ק��p5#?�|���wm�<�z[#e2�;��b��\�h%���ؗ�jSx���dt��c`/�>hhX~�@F�3�e�nD1Ed�����>x�s�TF/��&5L�J'��/�;ʌ��U"&��"�BPޡ2θ��~C���A������5(��x��bD�_B\L����m/�V�7��|���e����7�:�-����V���8�-���@�:��;X�4�������˯(�`	���c�S@N ��<�s�Y4:
�5߿AM�ug1d��q�"���">�d�"�1��������묎]Ɯ���pf�ft؊�V�!���3�d�����j����%���@�Ͳ��{'H<Ñ�t�L�Y$��o1/L3���N-j��2�M۔��@��~ Co[4s���3;�x|�e��$����Р�� ���    AxT��P,D\� k�"=|�Uv�,���M�o�s� �g	���@d^�3$�{A�(%䥽G���"����;�O�9v��$�Fe��w����H�$�����_{TƌҰ�R��ټ5
o��L�%HV$�"ޕ\�x���y� S^I��/ʸ'�n�࿮m��C	�Aƭ�L_}og7�u�ǑR�(H��x
2�@k�]]u���Q�-��7jۧ���m^;cP\ 3�2��x�A�D����	�A���|�&���T̓�nlB��O2M�o���xJJH��BY��?<�Z���{�z�ڨ���r�S`���d�0��nB��{�����i2^�_n�J	/O؜W.�{L�}�9����WD��qa<)�qcj?�Z���xP2�9<K�ӵ�H���j����*c���>]1}�}⦴2x�zȄݻF�L3beH�ϸ>a$ː�l롣/ҵ3]d�����A�����)���iTQqsLOb�dң2�"�+��k@��3_��6�����TӉ��%Hn�_��VW�:C��;��uuE�#Cz1F��^��6<��ق�s3*�b֖E�6&*�o�-X?#T&�Y�Dk�%�Eo�����I����h��0�����!�{R��8F2��W$D�L%4���]�B`�sRH��ѓH�\	b���ΐ���:��Y��0դ�{�5���"���j�BE
?5G�����{���r��x����.!Jn�[>����1���|�w�c�4 Ӡ���e^�1A�t�L�sD�����flk,�*;Yǟ�m���83����,��d��%HfSe)"�g:E��3�qǉ� #�9�sz/A���I�I�-�yXK�<o��α�k �Xrx������l>����H&�.12��I���!d������xY�H�uD]ڲ�����^�g�5;�^L�_��s���.{��ta��!\�����z�)'A&�hM�!�� ���$�<8���D�DZX���WW*D���f[n��M6��HJ��lB��kN:��y�5!"��`���?a�k�>\�??�?NN���v|��� �{ўߋ���k����j����ڢ]�pH$�6)�v�N��Lzx��x������鼍�g�Cw���nW�z%��&ٴ�2m�.Ck��eޚ$�z��$C��YU����'T6o9�k�V����M���#dT��) T��1����TƝ��VC�2<;�)�T@���a_�d�c���>���S���P|�!�~+�~�e�����R�C���N���.n!";9�ާup/*�Z=ϰ����	/�����Dn�E���V�aυ'�t�J5��/߿�}�����ǗϿ�x+/`]Ǜ����l��ؾ=����!D�ߊ��)%ӹ'b4P�E�%=>��i�09�iI��<صuL���oh&�N�2�<6K�<B��_��s��kٻ�f�)���c���j�@/���=Y�m�y0�y��V�M�e�1E�p'K��q-D����Q�9���[t��$���%�ߢG�E�[<CdǊ���ǘ�A6�#D+t���BS+9�y��#�rUv��.Dc�ܙv���\CD�*TF;S~���*��M���J�&����iӈ��XN�'��.-��K�w���3���8gL\�^�����8��=����9g�jnCg]��Y�BD�I\@ �zrd�g�8�X�ࣆGG{o�J�M/�21#�?��H���FP�����b�.j-���lEr��m��U�
�\5h�S����ƾ�E�����ƾ�X����!OEeSoBlȁ�k�젫�r�N��5_�ї�!7�pW��i��"J@�
��qC�BDB�\B\l�P��(	�ٛ�~Σ�+�_|�*�V�����.n�"w�g��͗3{2`���֬r����C��54'�����Ow��=j2nF����Z�D�8�ώ�[�:� nj^�Ge�F�?go��|��.+4ڂP�΅PϹ F�:f��2n3i6x(6��Y����kۿ� ����^������s#.����l}�@͋[R>�Y��G�]Y="����+��__%��ґ6·��h�<w�b���%䡙�E�ϳTn`ʋ �Y�Zw���.Ljr����O�ʮ���	l4A�M��Lv��w� ���,D�W@#ʚ�	�a?y}�*���f�d�>G�"϶�����x17̒�2vɎ�QO� 1J����fID$�ӛK:d
��"��q�]$���E�8��U�"@;�6�t��EK�@T&W-X��j�p�ZT�A�`�э0_|;=r�a	w� �j�o�[��\C����x~"=xx�Bߨ� �uEt�>c�����ԈSҢ�وӫ��;����lFe�1�$c1M-�)DN�;�~ߜN'�HH�0B�!��Xȱo(�~ C����#b'��K��Bn!夁���ڛ6�2v*%��얕7h�[C��%(�#�dL�K�hV�.P���ʖ2�m�[�q���j���+]30a�6�N�>�C�I��O�.co���~�����t�����<��o����T3�Ԧ]@A���s�ŗ:�YAw���N^��Nђ��������+�\��yTve�}M4�Y�#aWNˌ��i9G$��h؀s����9��t���B�γ��l��?Ä�/�xCe���ő{L0&T�;)BDZe�x��+�.c+c	IYIp�Z�Y�2�ud�A�ҡ2�2&c\R�"�	P٪2�������Kh;��2�t�]�+c<DUW�u��dC�	�!/�>�~��~���c?e�N}{��=�?�3�d�{:Uy(2VE�E����!�Q|q�!_�+Tv�j�>m&Y����5DBʯ!�����	�k���F��0�ή�П"�
ϊvd	��Q˟"�ӶGi�>]��.�D��~Ҍhl��t�d�3����jЄ�x�\!"�be�w�ٍ�͆ʰq���a��ڂr�����x�bD���_{��2��9���5��te�fdW�o�8iqЧl����15{�Mj�(�T��Hq�t�`���ݤ��f;D�(vu�lRK�����-�@Ő3e��X91rD����gCe�Ճq-���ж�x3�K�wJ���"$6�=��0&�뗿^ޞ�c��"*h�\�B*���������O��pÖ��`�إ`��L���;�"j~���<ނM��~E���v.ht�)�2wSP��N�8iR9�:{�1��˸#Z��_4��5[06�����P�ɻ}�:������$�1�q����;�M_F�V��sK샚s�M��o&����}��ْW/��.�'x,�OHH�:�6��@@(�2���TL
)�:!�J9��̨��D���=A��,�f�玞ȃ����f���p:����p���f��<`93R\>�>a&��w<ӿ�,<O7F�W�5�T���9�f��h���f�5x2�OT�a	��%��)tK��Fӓb�x�4�)T�vv�>6V����6�o|�cz�a���QŴ�\�P���I'�����0(nD��臊���!1��<�Z2kv��ʘ!!�d�G(�^����8S������C�N �T/Q2;����%Ƶ{���u"p�9]@��6��p��A�z�AZ^k�H�+�����P���Tj���a�>���d���X'�Y��k���uo�WDF�f��!�d��q�d_F�h1=f�dW,&��0�!(���b"!�q�b"��b�1�-&�Yf1��Ez��x�LF:T��:Ljr��Guچ�"��D2�J@Tƻ�d�a����riXT��t��ﱶ_���>'�;Aɕ\�����5�uc˅|�88�xٿ�+�"BR���z�@�p�!����\ɍR�2�Z!&m&�����i3*c�w'$9n�Wq���vXLs�����q�'�W�E��#m��6$~8eU�,�#)u�r2�S�ܘ͌��N�{��ÒP��d�j��� �dK֕����:�f�<���5����*!7n�Z�5��{-�ɮ�ժ
�I[(�xC�8I}��U�4��HI1)a?--�BwS)��    ��k���{�؁��)�<R�l��v�G�>��dgf�=s���q�m�.�S��e6S����d��b9"��k��{~h��e�DLg	�B�X���ٳ��ok���fSQ��M��mJ0����p�.9�yL����EBm��F2f����Ҳ�F��׍D����+#R��A��e�yA�c(&���8��.<4�?�&s-�j��6�k6E��G&Q����������|�m@dWO��霣/�VOd@e�٦�Wte�AU����CKYe�.�"��,������]v�Q�`�f��%�f�%fs�2vG=�d��`y��n�?M�P�G���m���s�l�t�����]���C���e�A�0��O\m�c��UyFP� 9vw���]
��� ���Gp�������`�A��`QQEycCN8�Ɔ�`�?�3*{V��j���>˅ݟ�^��sJnbR��c�����+��e�e������i��l���JewR���[�	q/��G�X�?�K�b�IϐA?�u�CBe��q�Fh.S���S��F�H`���bD���cd�y�4&_[[FTƌ�x�=Y)m�ryy��W����d,�NF��{hp���_�&�9�a��7���Ne��!�'�����={&���gO�ry�;����q���
&�PT~�:�2���	$�;.D$;�	1,��Wp��bH���Bj���Z$�7.���5�ģ��s���R��8E���h��z�{�ň��z�x��H�9�fw,�?�TW����Z9Vz���Wf�.E�����'�(�j�����3c���#_�ƕ�+*`DeK}�F_W��6��q)�]�d6֒jh��z�:�-"����A�%��@޿O	6T�!�&��%���l���\��5� �nI�A�����Tu!�D�.�֍֨��E6��s�vN\ٙ�gR�\b�%��'c�8A�I����#�SK��ڢ�
�/ ���� y��qA���ٯ�!��
tpV�t����'��<Cc;�e��
�{�y�-*��<��m��_T�I0���C\P��C�˃L����:�Y�9��S�k�_�&�֢!�$`�-�M�gOXr�-�/m���C1"�m�x��������*5:��]ƭ !1�ޒQ�(^��&p�y	RBnЌ�B�{�Z�s��+�z��uy'-~Q-Y�$��Z�1.X�$��ZC+*p5f�A]I_�u��2��AJ�-��fC��p��.��{c��N>�k���cTz��Zp�P�l���ƾz4��2��P݋[����)"K��#��ew ��Sȟ��/��������?}����/����=X�{���<҃Yt����G��оh�70���N��{D��*��UTj;����[W�LDe\�]#�����[�>j,x�,���g��WO���~�]9E���lw�I��9"!�爅�p�HD�I3O\v.�J��ô�����1�l�������YK��\cdE	����]�0�� [(�$I��ǥ�Q�����v�	)����&��ZT6��'�,��i��β�L�50�-$C��jwް�D<ι8ȸmdt���{g�B�CF�� &˫�T�mk%At�f#����}�M���ϗϿM%*%�a�[��3z���q	�d�/�Z�-٠�C��Aƴ%I�r��lR���M����e��lr�c� h<��^e#hT6e�E[�Zz����{q��ԟ3�]>>��t�`Z��r�8/�F���{�i�9��-�r��� �k��QLH�f͒��(J����Č�7�l�V\���/_?�zW�>|~��ih�c���i�9�u�Pٙ���c�>��@m6y��Zr`��\ѽ�8�����#�*c�T¾A�`ʄ3�~�j�#����pR�4X5�<̜?��/l�Cm)��#�rx�f}�8�HIg�P�vBʶŔ�^J;Q@e�z)	�׮Q�K�%n�+�h��/��v���,�L~��#zZ�-I~�Ne���]SG_[x��[VQ��J�6[��vM"R�-,p�ނ�;p�\	���A g��u�Z�i�,Z0g�kK��
1"l�i;�3ć�3Ixa��t��p�I�I���d���#���ƨ6��^��T�%N�=&���B,�����q}�i��P��M�\�d��$/�#D$x�p��u�M��|G����������r2si�d��bfn���sCL�.c�s}���l��dU�E��3v���3&DtܶO��������m���͚My���d�{	���I��J<A��6(��4���4���>���p��	��_e�g}-$PlѸ�&�q|�H��2@E��`�B��C�����%ՙ�'��	��l�5R�<(!#{�K�9��,d�|��U��n�\[��8Ԟ��K݁��l2n�	��px"���B�w�sPJd��ޱ�F��l��u�e�iE7Op�X���u|c�,�bB�W�'�n>����B���y�Gw�M3FboYQ�����xD,�S��Hӌ��w����L�G�z����0�B��-+4��#}�q&���+��ky�w����f"���	(�$C��j�,��zã2��}��=f�X���=��t/�5>�,_G#��� D����Xl�P�I%.I�-�]M�-�V���?�M�ДQ�ə�pB���@:e,�H�^��\}с[��'�b�X-CR~s6��F�#ym���i2�#fdM�=a�2�6"!z���`*�`0TJ7눁���(6X���D(��2x�����<��v��q�lV���Ϯ�YPP��f��x�e�D����=_B\��?���B�@o��	�/3?d��?t�#u�|�l�Q"K��~�BDb��;[T��s����s�];�冊Qe�Z����8Tv���!rO�Qr��̓���;�<�˾�˸�C��	���s0h���g6 ��x�BD�����5�2��Y�ۈ����BVx�Q$ǭ�`�V�d<7�����B[7�|!��cJ��{������{JDUQ���l�wMUe�!��d����9�k���G��2n2DBϸ��\[�Ѡ����V2������kq�Zt��.�)@ݬ�'�娨p
?NAC��<Dn��QV%��8�+���M�ʨl!�~h�WIM�H*�2񅒹Y8�V�L��G����7���(�%��%LB��KQ*�L����T4�<J�\C�a�Q؄j8ާ���C�xj�c�d��x�s��$����B.2�:2�c\�"?�|�2:�S\���	�����bH)6*�vvwbg��F�].Hx|��*�(�'�ɘ�v�l��`�گ������&!����7D�����/]��Vb�#��rG�0�.[je���pG��E��B
,�2a+[⤕�`�f��Ae3��Dӡ�&�}r����qi�zs�v�/��ܓӖ���_�eWM0{��K�5-Ar{���r3�������d�������պ�mR��*8T�ɔ���:���aj/��q�͓2��L�y�)��Ej��i<�8"*�ORJK��zl��t�]6���/=�Hhd7뭥!y!��Fe,�PHH�9�6��b~��^@���X�?,���%��F_�,g ;4�5<�����]�s��/�y��{	i@�����FSް5>�c-G�/b���wp�]YDo6�C��El,�]\�9b��t �`Q��w�1E� %1��_@��p�X���d,�qb� ��s]�}��f���+l�n�ـ��i/O�x��qb�����]��M6�k�ّ��)�l(6f��)�o(g�/�N�.N̪>ލ���v��q�]�ۀ���x��GN-A��y����O���v���Ac��B"6�̌Z��v�"�W����:7�ŕL��UEU@������J� jvznxR5k�8"� ���!�~꒷sB�ݝf��0rl+)a$]&�)]�=�1\&�ZS3�O9��mA�,����k��)뒺��N����_�^������Ƿ�>��x���鷯������!�a�c�
Z���A6kǠz�h��
�s�	!�G�0�1����2D �  =�Ƙ�����&cf�`��uܶ�x.e��פ�g	��e"E�d>a����� ��`�85X]1��N� N�n�KYe<�\�8�24��������k���SL#a�J�L�\����/".j�AՃL�e ���:={Q��E�ˤZ�p6��g�U!����vt=��OȾ�E�n6=��@���UK%�������Ǉ���BE��}㒰O[�b*��:�\�%P�U+D�P��j��?ѿ8M�Xͻ�C�� C~z���%N�9&&d�%���<˃��Z�PD���4:�ea1���ʮ,�)����M�6��XTƮ?�6&h���!p�ҡ2fZ�����a�B���n�����7;4Ճ��Q[kQ3���CAT�҅���o�C�pw����n*���'^|�IF�#�"dD�^.�f�Zz�{N�?~z��f�]�%m�J����p��2�'`��.1"����B5���e�`�~��dd.�'˚�L�\��c�����j`���"������d����D�;�M��%,����>� y��Bĉ	�hl>>��:���SQ��iYy���6�$/�Y���M֍q�]�&��t�ʨ������7y�8g�G�T�ޢ2����A�>NVQ�rr�
֡�[�gF��OP��J5��}���?a5*��?�P��)e�E���,�5H^8B�8W�5��@����dW�5R������xY8N�_�.��P�=Ֆ(O{�]'u�t��U>�A�l�i��0�*��k�u|�Dh�1әv
�ʘe�BFv]a��Z��&u��$]Ԭ�l�W��fv��2h����Ɠ{w�]ve�Y%����Y[�P��c�\�L�j�d�k1%a5.Q��0:�U�9�d��V���+��L�!1Y'���:!"{vT���d��QǴ��� �;;����w�s2�s�3A![U+kP7�g��9AdՃ� ����0�� ��G%����c�S�ȁk`<�[�-l�nT�T6s��
I�4TH���ܠ50�U�8��1_[�T�`�8$��z�4Z���j'�l�FFi'Yk���b�75��Ƽ,mx$K��ʒYkK��WZ�i}g���:�M�2n���A<�.nJemPj$�e� �=�E����!'}��]ƍ�ƾ�����vn]�7�tN����2�`9#Q�E�l��w�`�V�sP�e�h6���X���q������M���܋g����GF8ɖ�D�S:��]�`r{�\WP6��> ʵ�g�l�[I����kՌʘ�Т�A�i©�ߨ������Ȳd�t�Q�i/�i���q؝����lpo_`�7�P��,!�!��6-�Z\d���q����>lA�P�<��� y�+e��~sFt����ʸ���3=� �Y���+q"i�-Q2��2F?i�<P¥���3�d�0�CNLe�~+g7'��Ck��P7�i��'g@�x�x�k���ϲ�?�`2�ڛ�������񯱆;MJ*�Z��]bd�F��������&[��׻�\����X
�r���"j*sr0���9�ﲵ�H��nQ���_������������d_w�B�ʵogK̳o��+zfU��AeW�L�Z�u�N��\=s*�3����!�%����k�ɸ�7�{(�X,4]�7�x�qǒof�������o�������$L:Y8>�|�����89RMʰ�S&(��Ɯvr�;>BDj���߈Щe@l�k����E����-z��d��_OM��C�r�H3N�IFY�"��à�fЕ�Fe�����`Z�S�f��	�$���:��!:m_G�*f��T'�v�'q���.CV��K�r��tڼ�ޢ���A�I�͢����<*LR|8�);T*\��`�!>^ǌ�a�1�x��h���ux�h"3�	�a��X⫈�7�>�:e��� In[v]G��1Mʙ	��V�v1*�l�-1�l"����ޏ���2�jǡ.�[[1p1�����F�zT����'��z#�|��g�q6���,M�Q+��k���3�d�÷W+[�EP��>�j%`fH_TE�D�z8zx�%��^Ƙ�U[���"�]�MV�U�
�f�k�ѣCO�  ��l2�])D���A6���cn�.[�,k��G�ڥ�'�qolf�H>�H"N��Z& A�	T�X̓�I�:H&�8EdA�+W#�Qz5I�8Mmk�Q3����B1m��֢s =wf�	$+����?�?���jp�u             x�ݽ�\�q&���|� p��f��&Y��X݋:s~�l͈ǲ��R�Y3O`'.�]�*�=m[k�����_⊸8�^�o�!�?(����U�E���?H�B��BJ|�B\���n_|����?�|����[�G���R�WJ��di�I�O�ܾ�/<�d���/_��x����ß����_���W^�����0x����#�P�B���\����������b��s�J�W"��%�|��/O<����S`��ƃ���忣^X�<��~��R��N0�z�k�Q�3�7w7�o߳P�TZ�Rr���X����sB�X������-�b��p�`�˻������Q�k4�bY���|[�Lń�+�Jؑ-���$J���'��ڔ�L�Y���y���EF ���ܟ��@�~%�*q�lq��%��Ǐ�r�����8vr>[n>�aD��6#�X�wo2��G"�{|�QF�+�%�yQH��Q{ͩ`'L�E�o[x�z�8^�%a�?Ä'x�yO�|�>�oO 
�P�-D *�`eD�2���2�'��ax"!��@�=Ovr�����r�?��/?u�sh7�	!�,?T{�\4��?
�L�N��)?������D�8N�oߞg@Td���r
�d�@$*��(���tB��L	D��"�~�,b &1���VB�Zվ2~	qDHԜ�*���B�@>9��8�ߏP`�/�J:g�h͡^�R� �#s�G�%	)�bE�F�~'�8�&ZCmX�ơԲ�E��x[�y|�{[;y?X��n�H�]��n������hG�/� ��#�uPDG�"G8{�Dk#�Vmd2�O���N�8n�3�Q'h�����Q�Y�%[����R�L%y�$��9���d�}<�\_dwԋ[t⥍�а^�l�x���"�C+_�G#� !r���ϧϳ�eHS�MKHX�տ���տ��@�����W��h����h�mqL��+�LN�&��"g�<�C�-�,�Ѯa�]��n�2S��G<Dr��y?[Οgo���~��z#D�:[�u���ے�����Z�%���(�9��r�����DRg��4�Jz���,�^W��:]�z�
}�Ъ���=����=S���|y��p�K�Ǆ�1�PR)���l�e8�c8�$~��A�հcO4'l��cu��G
�G!�8^�d>z*�e�3��[�}T�e�[V_�g%����I�<�4x�/��MĨ���̓�G���'+��`0�@XèZ�?� ��DU1"�ȅ#�HT�7gbd�\aO�짰$����Z� `��J) <�%�@*��@b<� YaI����QmY6�Rm�e��={�b���땣�J����tw�1�l�*��ײn�j�.�DN�D�L3@����#8���ZXL;6Ȃ6�rQF�����D�\�cT[��q|�ib)��0ns��x1�M8B�pt�	�HI�Y�x��z!�����~fH"��=�CI}�e_S��e�H��p0�W[��#h�6+�+��?X�Β�fd�`iOy�3��X�j,���T�%^�U�����q�x~=q����-<+�!l�$�[N�]SI���Ȑ:�r{���,�qK�}����c�!��0�m1�}a	/�4F�����E�?���n'�WŠ�6[TE� SX�Z�׹�C��!���`����#�QsmFY�YG�ʻ��>��~1�x�v������:֭����-{��'�#o6���v�{�.h/�a³��gc]!1����k�Qk�ځ	Gd�������2����o�EV?�#W���8�Q����_�	o�@xVqi�Y�a�rM;���{��Χ"��ܲ��.B�mb�CaK�l�D�� �b9 �z�-��X����N�9�����
2$��Mh�et�=���k�,Vs�����A�P
����1�~,]`i���{`���.�UE�C/w���؊�GqOW!�����%��p�T������o9b���*��;=W>��=�B�qܟ?L����]�����Q��{:.���8�<	��������Vˣ?��~M�~òe��ԠM�^��7�9Ø�/ ]]?x���
�ֲ�֊Z�#�U	�7��hم�r���;��K:��2"=%�y���{��;X-�� ���3g�)���gc]�j F���;�d�,ݳ�^����{���͇��u�U�J�__kԴ�UP�ɟ-�n+Wb�����!���C��;��Qǐ�(�y	2�o�`]u۸��Z��[�&NT,�կ`�
�8!���,xI������El�ݚ�rr�-�G�@�}M_QZ����9��u�SG�#eG
k ٺ�cʉ���Mw�s��(�����c��XAdt��7A��p?�(s���9�ʡ��=��%g;��<I��G!����Y�Z<'[�,V9 �����"�����pDcn~�7hYª\�Z �4����j̷��C�6�/$�$���閗L�o�42�`U���:��o_ؒ/5���1 �l�j0�dI6&w���e��"#<<v>�4##D.@~��E	
:�1*�2}��+]x�{�������9`��3ĝҢѐ��#V�V�����=u�CiD��%�H&�KQp��D#���e�o�,V��@���`A���]���8R���: C�Pօ�^��Gj��$"N7��N�j��{�?��M)LOE�5�-�t���6c�B��x�қ	F��MP���J����;un0�Y���g��"g�Q���_����������G�+eIlB�3�d)V�z�"YԿ5NB�+G�R2H��f��`����EaW��򮅲��j(��J����������۷GX<�' ��YT����b�b]����%��d,�\��O߲�΍H�|I����|h��V��K�kJ��>U]�3S&��	�Š$~�AX�p��Ⴕn��=󈝞���=�B����-���f]�X8���5He��ޝ�"_��O��?Ƃ�gJ1�~p��y:[&r���K�K"_�<E�-:��m6	tEb��J�Z?�wO�l��銜�|9��=
I<`RB��"�:��:�e�@)W��
v"�O,�x+���L� ^�)��~I��}I�+�$]������@����ns!:^�8���^��+����~� �J�"0�*r����c���=��h�
�#G�=�0��Zh�W����O�KeQk)��/t�cݘ؜�f+h�5�#�D�8�����/$(ѩA��d�"Nؽh�}u� A9(��w6������|;�r%$���$QmiΩ��u�q����uX�����0�"���w3�+��G�%<�_�gR*�=�s�@0�|���s6���b/��D/����7sGr��Kl���H�����7r�"Z xU���_�$�yJ�k�\��������T�,�B�ŅX^��0$/�r�ڎHT]���S0AR��X^����z��˪�WVTi6 QU�٣H ۪l��(&�
��
��*xO��#?�e�$�3��g6?�1_'iF��F�E�ڒ����jk������؆0°�;�
`,=�!�{0\��+��0���9��H�s�4bf��{���q~??X4�+ZD����ʰ�j�-l*^D�vZS�f��ݺ�L�XbP�A�XX�%[ť�2yt[�sɱNͶ�\�QnH�����Zo G�%l󡯛�,�[�xM5�b����f�"g ߟ�=qmU�^M#�"�(�l3����GX�0��A���s}��"�u���O	3yʅ�aNX�����nuC(���D�����{E�Hb۔��Y��Ys}��]`��1(��b�sQu��5����@�b���`C�u��rQ��n���gK��7I��7���K�Ⱥ����K������C �� 4�4��9b�����].e�#>z���z�:�e��2ޅuIRc졇�Ușoo��ؔ�2a�4��^{���k'�e��f�9'�/p�5^��IZ�    �3��ig&ײ��r	��<L�1;&�U0�G;�v#yh�!v�.��A"wWtg������4��ᇡ!0�V&��R��!��I?�	%���QS�������[��% hD%1��X��aw��@f�0�X3I�̐c {��j7zZ����i��_�P�l�l#����hd�r����w��/�X�#vk�:o1����k��S�XCϛ�+�!���i�ET��M � �߶(#{_�L��Ȉ���"g�ܼaǘ��
ф6c]v��7����	�8`��L/�Ln�������v
t���8�)���CӚCls����C$��[�U�d'��(�]��2O$�v���_͓��ā']"��ԏ2��	!��'�Vв�H�nGB$Q��W���b��p�I��X���{"��Џ�T@�k���H��n#�K1�����F�-VȒ�6�"���w��\��M�8d��뤘���˙�s8��N�J�����&����FH�̊���EG�UznB���K>��Y�>HU�p����6�TPx������Z�=�2~�-I19�-{Y����������I�S�X%�YpƄ�um�:��������c9��k��۔S2�X��#Fw�8[+���u�m���`qg[ڜ~O1��_b���t{����b�$��i��i���
oU��d�|"#�7u=�L��:��d�)b��\���cq�T�u���Zw�/&��<'w�2�%�§��K�pt��ol򃵌���Q\���[�]1��9
k���ș7��$�fu�M���D$lے�ۖ,9]R$�G�$��0���s)�V����ӕ>	4;Hb�.a�V����E�b/��h��c�K�$r���(郸�d�GP@���H��R����¦��7B�ry5� ���fEH��-��"��5��-�,g��k^��8�cO����������e���m�A$�!I�l��ꊜ�|xx?��NX��������X���+ ��%/>� ыh߯T�����[�K<}���`���-l~�n�C�,ۓ�6΃���Tr2o���\���^����W�;�����h)aX�%L���Z���M;�`񟪇�����z=����8�~0���ָ�eB���)�纒����" �� �Aj|S�j2�l��eC>�Tܱ�z�T
y7's~D����=Hnq��`ы��dH�T��{���1����:W6-4���a�Z~�`���o�\�~TE������Y$��DV	�\��쭼B	s�A�<%�U��_��}�n�-<I']�D)W�bN+6+�f�Ы�v)�sHM�0=��+�����t9���æ��nR��tٙ��>��ş���GE�^k'-��ͤWv}�Ē $2l`�����o�~D��x��5)�q�RE�<�̏&��v�ݖ�#���E!��m�T{���N��Q�Mz㡊�"g�<D�Mp��"���{�Y��l�Uj ���H!�"���TjZI��q	R�lO���b�dj*�4k�[��9��pţ���"�w	�����
��X�D��~�$$�u�{�E���6��О-�.����]wes#)Qp!g�P�ǜ)�B'�%(�q�q���XzT�ܠ���"=��y�ۨ���ɤ��|Ҙͦ�;^A��K�ˉ)��9��t�KYș)w7�����m� Y�f������c���.{��凁~���r������ӻ	Wh�eT��8���5Zx���Ǘ������Xk%����Ћ���z$�����F��]��j��z��m��y�쨽
��ѝo'�m�'u�����~�XMS�Z {v�p�I�Akb_��g��:���\��d�(!�n#�Yi��l�FD��G��Gz��+�~LLE�\�;���5��S�<�Oa�ȃh-�OF2�S��6�B.F�$Fm$)\�D5���NB���j�z$���̿��m�(
����[.l�W�$WP����Ϊ�Y�3S���@�M狳*A�ʺ'Y����-��@0�_���|s{����<5z��J $\�5�6ê��{�S�+o��.��ɗO�IKf�,΢޴s�n�kUdkUԺU�\y:�0bI�*��֍��:lo�-Ҭ[,[�X-6a',���ӊv���|(����E6o����[{�+�U��U1z]V�V2vK���f8a��G��'�=m�C�XO��]�TkT`Y]��1W.���=�u?qY�,ش��*�u��+�.�M]X�\��7��Q�_M�9,����#�k�%� $*�+)[WR��m,l=aziٗuW�"*���͇c4`i�
�$-�F5hltd\��\&q�	0n�Z:���Q���y�/�ٿ�'�1_��V��V��g,�`�'�0����oq.P���d��{�;�I.�t�������O��
�_�"� m��)]5�o�Qc{���y߀͓���ə#�o��8�Q}I��A �� [��#�˪ˉ��d�󅜁���zVd����6X������� *�6�/�]��(O��D�ZI�XI�eˢJ)��	
�Ĩ������Q�	L�	q�!
*c�L��L²
���}�4�]p`���_����?��o_�xRi;�	a�YV�V�r\���I.?M#@!g<����~:�"�Pm�΋��T{U�)p��ěb���%�������?G���k3��#�$_�&TòcyA2u����T����ß�(����`wt�i3�Zƺ���ܯ�9>*��%���T���,i3Fy*�0l�E�Y�q�V��7=ή�h�� �;9k�O�h2���dvo`��Tk�)~*�I�%u��b��Oh���{!$Zn�H�๧+��]q�F#I�&?�t�{t(5�찌P��/3kV�a�A����@�n������o�)���e�F���M��AC� ����=�������o����$T���ſb�(��˝6GuIT��B���}�_�������p�IP68A��	�UN��-��9�ex2���ё
�1�D��5	�P��h_ܥ&��/�\��+�%�����)����[ ���#����6D��u�.�pY��i�#&����Oo��e��P�BKȅa'i�z�B�k׬"z�C�(���ܼgC}��i���#E���+��RT����&KMĞFH��r����0bx���yA�Ş5�F�H�e�
+\�Ⓝ+��	t-��ߵ@v��$ ��J/b�3����1����ϯW_#�(3��UD�@J{?�Ԩe�W!��u7�F�r-�AS.<��ny��\���R�q���r���oOwS(��7�����bͣnͣY�$�++��9����J�]�_�p�$G�h����{�����[�hL�H&�{q�߈�ȅ)G@�X�(&Y7	�5��3I]�'&�����H�@
��d����}���w6��+�d�%�9��.�nNh�7�X���O�«H�Z��uZ��D-l��������n��jo�DH4���Y,��S���0T�+6�R�4;�+�.\�k	�JD�
�$�
G�U������RC�Mܘj�q�Za�J}����`�s)��Kn�� ��haG�j_�8 ��1��b����>��8i�p��Ic������L�`K��3o�*�����3_ș#�g�⛀D�F���)�	�5$v�ͧD�["�	K�@���N�H�MSI���O������y��n���$��0LkIVG޺�tf�jI�GP
�Y�E�&��aq�d}ۨ.#&�r�wT0I/�fLI��&2�Sɷ�V��,�$����bu��g���G~sAR���Co�UL98^��QL�^Kk��X�-S8$��DA�����ö��v�f�]��̎�'����V�r�}s�e����Vش�>��Ʊ7v���/��|Xӡ:��j�=�A���N9�77�By��j� ���$�q��(+n9dT��s�p������r�}{î�/U!
��4��
pm�ܚ>����Ѭ���ZZV��VZ(鴫'KK��3QZl�D��u#m�F.��W@f	Oe�b���    ]D* ^��J���I/��õ�H{k��I��m��刳��j�A�1^��D�~����$ְ
듼�,q�k��8����ܤ�ʄ�ܻ"g�썃(W��v�ca��VJ��p��@�C�
9#��K�y ��6ܸ�'�k�Z�ޭ�d/ ��[�����"g$�>��D���k��n+�2�^�k�H���ڏ�$J�s���99��/7'!�Aܛ�B[��ѵ9n�|rYƫa�f܉�ܗ�;����R�W��<��'�v��*������W{�FE�~���	SɸnB�n��Oآ�w'��FaY;a�}6�Ӆ��D�6���k0|�:C�3��7���|ј6���d@[��7
�|�h�������y���;xpM�U�K���?���qy�9e���.�p�Bcw�JB�_����=��	���������#֧��y���������-8��X&l��=�JF,�\ؒ�&Xp{�ڤ�G�Jv�_���|�/e&�O���X
�`yws7;b@�D�a�v�Kv�N�'� ��m�Ȑz.hPC�����ϓqM>_l�)����U���g�������'Y+�`$-VP({��	�������D ���!FF0��g�nSs��3Ɖ�\4�倦���A��������	kcBkc��M�u�0J�\����˷i ���D�p������,���s�n&,�mQ�Y�Wl�-Xl��>n39,�O���L@_I�Y4�H��uB=\'�%�ii፯v)M쿦�'�c)��bNm�� `�МoɎ	��D����r���-|�y?"I�=��-��M_��	c\�馅�_�����^��{���Rȗ;{6C_ H%��v���Е�tNz�,$����e.�X�$��B�՟���`�)��_��zV�iq�2l#���%R��e>=ǚiF$r�2����D�0�Mo�|.�G��FS�.��fh�d3�jgn�Я��E�*;�U���3w$��%��}��ǫA!r{_�g���ǉ�[ �΀�B��(�]����5r��󷟾�``����C>f��L{e ����cMo��"��̻��)C$1�e�<���6K�j��!����Dۋ*H4ro_|w��<�fTZ��4�Nޅ�Aa�L��Ĵ���[O���%~j\�7`�"�1C>c^x�\�)��R��)�x�쩯�P�*!���W���r�3Ӟ@�7��ʹi5��aʺ�eJ��=�4	A�@
�-R����>��x��G��G��h��x2G�z*�-I!s�Dh�y�Ċu�9����6I�H9#�|Î�L@V&�hY(H�fV�t�
�Bn]���>�ݯaf�e�E�f���a��}3�[�(���
	�"�l��xoGr���}xE�@~�y;�Hڌ�0=p0��Gk��m8Z����}���ђȑhK�w��cn��o�Vt-U�v�K�:��YT���:�C �q � �0N~b[ ����#������"7�=���� ५�F2�{/]�dYm�H&�J��n�lE�,y	Mps��$7�6�4�|���+�����x�n¹j�ĒC�⫓�bbZ�� Y,���Y�F/e'g �7���DI��wM�e2�R@�	/�j�W��q@�9�U[q���^���ǎHP����+� O�D��%=ϓi�%gq��-eo�ݼ�cMr#�h@d�Z��*��ƦwR*r��#@���!1*�����
�rb�V���`�I�c:�^�K����RB�7!��� ��J�
-K'���>��K�чe�D\�_FO�~�'Хtړ�I̯p3#ӢYL�k��	=�/����?}�A����S�c��2��׃���Z�X��O��hʀ�U��s���ы�
Z$7+�v�4�Y,�����\+rs���QQ!���cn�mΨ�������E���B�%W�M�`�hS���޽e�-_��h��JN�B~@�=��YIE�%7l�%�p�#�FZ��fR2I'k��2�%���;93��v�K�bl� �p�@ZIY�^�
��s�I�"����G,1����>�lQe�5g����������`�
��R�hp%G �E2Ov%�4����4�Y:�#���A�9`��:%]v��(�E��q����3Gޟ�O�4�Fo�[���%74��q� �dF\=��.^���l,=�4wzYm}w�^H�<�F���`��ű�>�޾Z$�ļջ����ފ\����Ol�Q�K�я�gm��f�iȹ���k�a얙���W_�SwZ���<����ȍvl�M���k��y�)��[�Z�3�YCx��,Z L��,�<�d�"Q�V��BUq5A��rFrw���. ���_ǻ��R=h�����e7���ռ�C��P��ȀC$�$!Z{R#��$@W��.��p9#y7�<
��ZӜ=Ab�X�F˖'����W��X���P1@!�;v&��y�f�8��4n,�9jp�ǘ�8���=�rIf��r�~cҿ��i��:n+Pq弆������(����k��'-f�Ai�+�����4��q����4;5�|���qC#����0�M��-S�f��\b���~�ѐ�#���Ϧ�t�&Ӱ.'p���RW
y7����좦«�Cz��f���͉9�O/bq�� *��{˳�L��B�ɾ��1e`e޶2��e� �%b5ޯh��V�>Ę-~�±t��F{[��}���N�Q����9���×O���eh5��t�V\<^J��bۄ2�	.�>�?�����ob��}�	�Bn,
DS���
�_	Ȩ�i?�(�@�?�����-��Z�C�m�,_�i ��r�������U�r�*�Ox.�G*u<,cp(���H���G�⴬%N�DS�3<�i1�(LY�s�(i�N�d�I?rq��2G,�����I�Em�oJ+���%750�-�u�eoҙ�
J2@�*����g�P/�>
��y�E`��i��\]���)^L�܁?�N���Q�ך�Ǜ6��ł�ǔ%47hđ��
���El����8���ڇ�O���Jo,���B���eӣ%S2��R��������Qǫ@�����ݪG
� 9�v,�[�&�s)i�F�A.��� B�4�p0�\�n�8pG6.VW�ʤ�){�����ΐ}�T�j��\�\n�q(��jۮ��W/�Z����x�Θ�+=�4�/���V���@fA<�zH�]c�<JD�`,y�βc�nYԏ*Hy���B~<cG��vZjD-מ-���8Z�U�j���/2��~��zо��gQ�"=���T6�'�,u�~��v�Џg��0���3����&���W�pZ�Q�D�&��d���ƭ��Z�K^~<�}~7�
�v�9�!���}B�Q�on�yz�w�0Xn?�0s�1E�6��C(l��0b�f��Q�4�LN�J!�6]�h��B�Zx�T܄���KVg����� �^���Y�ݜ�Ѡ!O����&lX�ڰ���)�N�����SS`p�z�4�F)�!������_�e^�3���#�:�}���P����/Uqc�h�Rdݙ�wFM\G�x��r������ق6Ă�����t�F޵F~u0{�e��x�ÔD.�����iy^Bx��#1֩w�So׳�����̐��k����c0� Ja��?ѬͲ�Z��PhΖ��+B�f�H],M�bz(���_tT���I��B���u1 �0�>�U����v��%O�|sX�C���ŉ�q�o_��v�QR��J�,i<l^�r�8�Ѹ��1��-6?� Q6�-�@g��Ih3ó5@ʾ�I�J����-�;8�9����4��8��k"�y.��Eĉi���S��Ƣ\�U
���o��Wt���ߒVA�A�9���>��j		�.� 0@�^��޷��.{�J-�OH-��$r�ʏ��%��(Շ�{]R`l�ȷ�"����$ܑS�v�ަ����?�;�u�F��N������7���0�S��7��S�D�e��K��b    �c�������h�Vy)n��,���ew�e"*4pQ)�*��2KI"W�si�:P����<z��a���>}��	��0^�͐�&�њ�
��M !">�ʊ<�A+��~��mNPme�I���h΃���Q��,וd��%���>dcY�w���5��Bp۽�qK��`�����44N�q���$�%A9CB��o&���Z���A�f��]z=y��N�g�N.�Cg.՚�x�t�@&sNG ���/���Y"����I%si9Sdͼ4@�2=�6`7I�"&� �y�!C��c\c��ZȒ��|�jz���%;y�{|�ő		n\����!�|�ɻ����Y���얋#Ӌ`���rFRzU$��N�f�@b��(�QLҸFs]��S���T`�������
��K�rHP��(�LI�����(3��7嵱�������)b�Z��A2��i����Bޑ��$��t�-}�@�p��4@֜��E�~��ƺ�������-���M�Zz2�l�Z(��򉟦��/������F�e,X,�H�%��$��@$(�4�(}�܇Lϕ���d�����˟����=�pL�fѷ�|;/O��������[�l��i��}8fu�z�O?r����Vb��b�ԯěQS3�(1+���Nv�*a�=����2�a��h�9�]�k֞F�n�s�����LY�$$kAq���cɯlGl'��!Z[F�.�b��q+[�,�g�:��=�.5������$TQ����/����wL�>�k����"�P�N�*��SP��v'�DTJ���IB���-І��=�����pH�+y��t}�6-�tn��|2f����r�3I�X���X��
;�P��ÇŊ�l�k����w-J"���&�E�H<%'e@�p��K�l�pX�û79�iN[sT�O������ǋ�&Uv�ʔL��e�0.�H��Iυc�|!�|��//����4��Tn"����2��a��uJ(<e
��0�d"��uw~�|/
��Az�5�W;_������n�ǚ�E��ut��	�V}�N}���<����a\�B.������2��[)O�
;}N��)4�}�~$��� 1�_�\�������_�hp�o��~��;$HBc �\���'� �L;	�O��nϓd���+ѓ��0�
����j�a�ʤk 3�״�~8a������3��w$1�R��S�ᯣ�G��n���/�b���1/�)I�Nn� ;Y�KC�T����wY�Y�������?O�8ڝ�66���ٱ3z�_���#q�L�`�0��s�Z �����#�	e~�A�Xz��-BQac�j��i9iQamH֔�UX�b�Ј$����L�9�v��K�;�N���:�,_��H����ʶ[OR���|���?������mT��`ظlf����h���q�JM.ٖ�-W����fv��"(l\����i�%`a�)�sʗ�P�X�v�l�b S`6�=U���@�-��P��p�[��pc]����?�|��z&/>G_!*1���q3Rw�"ז�&0� �y4���뚜���a*��hB`����ʱ���u��M"��x7��ET�˻��,f!��I8D9���aY����L��Һ�Y�[�X�g�����s\�3b��/�\LGe̯�����Cׇ��r��߂��4;KGjӁY[����a�Bm+F%��L��X��ls�ۚ.Mg1q|�,.��_��^��_�����e�t�Ϩ(�y�!�A_v4���J������t{f��b�f�8�Z�_"6�nJXM7��T:�;gA�m�Mk���c!s9cy�
L?&zc� �<8�5T�Yrm�q�d���b�v$RM.n����	^�n�+ב�`ͫ�̫ZO��G��I 3��B�L�|�q����Y��T��N����;�f)nc3��,��������h'g��>�0���oЩ��rz<k[uc[�z��ʶ�Y���FR̾���N�_�X���iB�t�(�p\f�����9�/"7$MjG�v_��N�'�����ԃ��|�⬽Գ�έ��K,����(��6Qc%� &�3gfn���t�7��c��H���^�Ø�i��p�vvr��1���.(5�\}�����O����eh,`J0z� �tM�H���2��MG�\Pnz0�\4����Y�����6\��c��m��U+u�q4]w�I�<��Kυ�/�*r����=6Z�1�gq��M@�b�O�
6RR��f��Ky�B���s��@���MXip����d5n/�e1ĩ�p�O�q]��$�B��O��χp �=�[�@������6�'3齣�cx���O_��/�`.o�+2��#�)0	�bE?����:
X�%rNs�_������d^yD�~���U��_vn�J@R��<�Ao��V��\;1�6KX���y	��u�l�8c�j���'�e����ZT�r���_~��1�%�h��9 ���NՀ�Ŭ���`�̗_9"�"﷚��l�"s	T�1��mk��	*���y�?a�ζ�%�����	���(*h��*�A˔��`Br��S�RW�S�SN�(��3���������Ec�����,=�B���}*Hg;�''��.��.�~rf��w2j8a�\��8�h+C�ą5��7��@��1��j4/;�z4�A��q�>�=��7��sFS���/��=�idxD#���r>g7�w��/�vH;�>"�l��8W0�<Cϑuj��ȻJ��ｐT���l7�"C�RJ6��Ef�,������4�k�����\0�9��|��5)�s�8%���INg���ꑻ�
�ĥI�c̠
9��G0i��FKO ����8�9�l7;�&_���1�)@`�GH��k��s�q���e_�Q�����ہ)i6�����`G�3�$�����r���hP�F�s�v�g�e��\��3@z��,Pf9��!g�=�d��t=!��;���^z�Z@e������D�=��$73,�n&�.V;�Cz7by*[�R��@}��j��dv��MH�-����P,EGШ�,�g�rI�ݝ�U(	�6(�Z����c��l�\�l�3��2!z��N��S���O�LX���벰�H�Y'�κ㩏��e.�5�+��˧��;�|Q��A�VQRC��M�ݛ�Ɋ���6���T o_����bq��u6:�(*�
�
3�c����X��Y)�������3�&g����@��H�����:ք�=I4�3�����x
��n�Z����Ti�"`c���f�詂��e��C#PE�P��t�z��4(�ƀ }2vj�����3��.�ج��Kj�X��u��]<ɟ�l�/P��s�ni����y��U��^WX<V�!�Ɔ-`gU�8K�}���WT�6�QU�Up���|��?�K���\Bk���'a�����	�bv�NmNg'�x]1�I䢳?��r�b��t.p���;h`N�z�b�e�+U4p�J�:8�p�q���3����&Ƈ����5%iN�3�<2�`�ĝ7l%��2&\?��C��sT��L��&��`X����QE� �Un�����p04 ��E��y���8�.�O6#y�Nt�4�\T��ϱeR<2�YA�����=c�Mj�}���M��9��B�/���ܝ�1y�;��m�&��l�����Q~�,p��I�J����B.`^��%h�ף�9���p9���2F���P�?LJ!�7���ȗ3���Kv�mM��� �|6�F�]g�f��s�hش���ضg%�����H�[D��hm� ���#+��ĘMx�ø�S�3 ՟����y@鹠�*���*�nA^�
����9�v
+�92n1�.%�΃�$�,�Rȵ
��u���z�F8�&��J�9���$�I����Pۀ4/(,\6PI�ɾY>b�q��cZ�;Z�B޳����Ɓ�s�ذ�Z�����|2�	c�\�%Cihf�ߢ�2+����9�َM���Y�hyfΟ��9a��S�� r���˲��s�5�����L䒨    ��و��ދ"�w�'ʾI�Ԟ.��PG�2��8+��z���Y-�\�R)�b7�)&#S����p��DGL��m�e�U�\O\Yl��|���@n��3�����7����AK}��{M�zh�޸�V��o����&����`<ï(�TB�6�+�22���	��ƌ�+�ץ�+gr���P�('�k<^l?��.Y�:��2��6Ռ3X�|�(�D�7�ҕ,;D�N����.����+=��B.z���M?�>�-���SXAg�W�~�7��|�˻�:(��C�,����38;>8eq��oW�yJYb��(JY^�����V���Ѣ!3b��B�#$�x��`�xb��/��đ��oy2B��T3�z��C\�K{���Ht��d��b�7����i�O��T�wO�;�xi�>wS�����mэmq~r��x�ߗ=%�iw(��9�zT�&-X�g�\����S���0)U�x�h���"_��C^-.u�R����?W���Yk?/�y�.mh�R�CM)?�+�� 0�p��|֩K��߼��B ��3��g��Cp8%Z���)��3�yJPR�6�R����t��C���D&��/�A�rFr�/UF$�D�<^hl��]N�/�A�����a�fεPvr�<经s�������<Σ�ӡ$'����T�l�)��!���+���~]p.h��2Em'���|�H_O�x� "��X�;�3Snנ�i|mGWLwɜ��p������޾�*S�U?�\���,�9�F��a��¨�$�a�i�&q���;}Y[8�n�#�D.N?~�aZRթ'��g��8fq}Y�w�mc蚝+rf���MF3Є�4vr�2�]�_��s&�l�DO_x�;Si0�p�
9㹹;�x�<38Tq}O'�dN`�c+�D�ǽyK�L�v���Lϡ�����U����[��.��x��f{�U��Lh&� ����K�{��9j~��{*ڛ)"Cc�e4��zH����@�b��B]��H�����hr��-���B���HgM���z�B���KR	K�5Ђ�lC`-�	�E�s߯�\���9��/�ݙˣ  6�4�0T�������O��*��\���yO�LƸ(�=�x�h��l��x�8Y_����]�I�3O~������RC�u:�oRI��N4;,D�u�G?{M��K�D��I�]C�O||S���� =� iv����8贳|�)glx�ԕõ��#rqj�9�؜�^�'��Z��j�Ueר�!�����եÙ�ʠ�H6Xs����\V��7N��(JtY!g��� dG-�iΐİ@��x�D��Y.@K��R,yWʷ�'y�k ��h��`��m��_ۦ�54C��V��ݝ�ΓЙ� ]�8�B�nf������.�����^՛��|1�������M���j:щ�bqSg���\	���uC�����]E�
��ivʆr�C�������Y�����Th��\��P�f�l(�ť!��)hf3F��9f����c(�1�Xӈ���堜領'@Q�M�9��j�@���p�E�:��E����3�]9�aY7�{���3�ĥ�/Xn�NcM,P�i���������hQB�3�0��=7�jN�+����.T͎sP�We�Mu:�:�d��5ֿ���;���f��E��(�/lJ�w)��Հ5���yT�+����¢��$M�X��;��:�31��� &���?�O�;4 ���aK�V�^��^�r���z��3T63�B.`�.��Hab&��=cAvlY�d�h* =ײ/���U���Q���^�C��ݴ*t�R�'54��$~��Yt�F�_ȗ0�v��$X86a��M��'t6�� ��.�gâ���
�sP5�˭B�;àm��)}Ӽ�6��W�V�ݳ�no�[<v@� v��M,`���i�6���!I[���>��#�r�k�ⰳ(Th����j���N�q26��\x��<����J1 ;�D��E��{��koH�Oj�W�bK�����[ht�Pڒ����fc�bK�y��*YF�y�6�;�HS������4�=ivN������+(3��Ґ��rI�<�$� �g�)�`Mr`=����H=m���:͒K�5?`W�������� ;�L�'f�5�@�}b����"3o�`��1G�![؅� ;sqiʞ������c77�`tY��'>ް�t�'!���(O'�����W�!{�H�-{��đ�4�$�H
� �Km@hU�f��At��Z���#!�G�3 z$�\,���~��E)�F��{Jʲs@���bѶ��qb~'�1���[�J�Ȗ�oy�_�uG�.�!E�N� ����6eG1�)�(5�"�3��'�����l����﯆�!��Qô|�j8-����,m�vʂ�jݏ|�6��,�b�PyWç(���m8��*AvQ�Z��ܡLd�ǒ�2@��%��(�B��㿿uL�w�4N(�uL`����Er���	U�j�\��qZ�G,�����O�'j����@�tc�vȃ�m�d�ySN¹����J��4K.����DKRx�ɨeb��y���c�%a���\f�+`��sԾm�oE�H�<�?�ᘓ>�3[6#ʏ�i��HKX�~T��-��/d��Yf���E�$` ����_�-\)f�Q�x[��'����Ueu aI*?#�M�3�	i4ۈ@Ѩ%="0��Ρ	�K��O��İMPw4�v�L�Tu��Ek�d`��ʰ<��h�%�V١h"VT�8�W��rP��=��iJU�b��Jv�E��Zܔ��-�Po9&v,ǤS�I��Du����&�L�ɕZ�,U�٥��E�du<����f��������|<��|z�p7eM9��JiR\��N	��sV ��0��e���"@�}�� �rUF�X-�-�3�GM�h�>�����K,�Ԏ,1 �R�{�i{�7f8t�^����CGS�7L��>یu3�yᢃ�t�\�i6�1e0ޠ�93��閿l14��b��0��������g���\�5�7��&X:`)�Jz}��M&�R{!�H��cW������H��/���@����{���M&%0�~�lY�N?ہu��T_Ίbj�p1� ���1P& `�|��36tqH��~�C6*�tD8,�!��14�ف�z��Z�h�]�U��p9�F��L"�n��5.a�Ը�eMXXscd��7�d0<g2����wq`T�t���ٜ��r�l��^�׽4(+'��^��iF�%�nf>��sWH&�7�	�-
L`S�ƵPVgf�;�������j֊\"���\�"���4�3l#�N��u�L����i���I!gѿ�af)		H,"q$*l�N�ų�4g�\v����&�9^������\�O*��}�~/�Ϳ`�$�C�s��M������|�g`;��D.�_�V��ڬ�0��l����Z�t��J�=�
�z�$�KbGa��I[4�@Jlk�Ƥ��ş5���b��D)�,� Ѹ)�+<Y��k:!Y,3�:���D{���Z����x1XZX���C�!z���J�A����\�7ю	�9C��t�����f
�&m�4D����X�u�ؗb���{��n�aE�O_�c�ݲ��I��a�]���� ������/i�	_h�P�)�"'�<�|�0��XZ���@$l��.��sᡬ��X�@cH$��_�������?M�Bw��l�cq;
>��]�H��2�G�~�8���%���<�t��}�"���ϧ��Y�,���8�ڰ-/�:m�pz��D�3���⨕h����`�|�? ��Ó������e��q��f2�h%�`������fڋn��8g��e�T,��u� ]��e�-��A���]��G�\��Np�|&�7��3p�H�'~�ER-�}�UU�"b�pm�@I��8F2��P��>T���!��^t�0�z&S����߄1�KLQ>����դa���uQ�j���P�2���Ƭ^!g(Q��=��a(�kI���\w���L��� �  !?w\��Lt)=`�Ȱ�.�k=;Y����b��ڍ�����I�D������"���ޅYOT�Rd59h[մ��D.�؏�,1�zJ�&�v�W�Y�"�A�=�'�Ȩ��~�@xB�o��>�)�yp*��������(LѦ,m6bllW���4x���\���o�2�SQ��}v.��Nz���R�����P����n�Q&ϒ��$N�0t�X�8��zB��YC�MN��G�K1H�����Jb�ȡ���������eq�i��df%=�A3r���_��˟���Pt�b�EK�۬��V�x�@OL��;�aEyEΡ���˟���矦`|*�7�[��Bg&W��W`fUb��'r�˿���_�z�E��B�\��:z��i9�@����+r���_��u��e*Xނ������_7+��uV;(5ǰ%����?M�`��؂�bD©0-�����S"�v����ҳ�U���%E��@	p�v�� �"G_�/���/Ek�U���QI�|FLh�d4*AKjh1lC���ST���7*�ʸ<�AB�r���/@�ŝ�tsgئ-'�^�fV8&�#|��<�H�Ɇ���l�b��䑞�������* �6��U1�R�ZY#�3��'�0HT)�"�? �1?�Tp��m�3�8D���V'��?7�8�zXA^�3�w'~�:AI�E2H��`[��h-�����Ч�� I�r��Lƾ%$��lV�� ��dӢ3��C���5����'��G�KP5�����'��"�SS1ք�z��BYv&/Px�8�
�%vr�Y�-$�S8���X-A� qj_虐<`�;O�ߢ����G�Xc��!��%=�ԋ,�$�Nw�xC���/1��İ��vG��w���Tɻ�N&L�2=�?�p�\���@�0�$��P���t�?;��^�����\�": ;y7��Ϭ�����8������u�42�/^MVLa]dzNC�F�$r61ߞʢq���&l��^��4�����0���9���L"�C������Z���$� �X��-��V�[mIj��S��o������ˤt/�������J���sJ�<G�!r�@I�����0��|�hP��i�d���5A!g8w�w'���Rip��I�a�������*�ruԠ�s&��"�σFY(�$��-��î���Q����TPػ��9�9s�1(�K`�|6�Y�� e�|�7�-B��e�#��E�oYE�zE���'c��V�;º���\�~w�o�S���1���=��qb�0IAqW�_�;��(�0"q� `���*l�6lPa�	S�Y*���y:�0�:��8����W��#�2���=�B.�%� 3@��2؄u��QC#*��oi�K����7�}�EEΒr�c͈S�8�zc�zcJ,&0�v�g�l�� AI������ 	��B�:.`:$�>���K*�Wv�´���!*����g��@y`�(����AZVXа�(9*1�f��NJ���]�Q8�ȇK!���Nⴥ�$��04�Ӱm�Z���}X�d�N�sY!g$�w\�?!�Lay8�3l����!1k��jo�I��Ɍ.N��M��ܜ�\F�b �q�N���ԥV�ա���՟�zZ�Y�D�����z����	�IT��I�[�>�|����B1������Ǉ���
���3�-���&��I<ar���^Z�ڗ�ҁq'���	�)f^���t�	��P�F�/*��Q�M�Ӌ�W�V��J���H��A�e�g�M���S����ze.g����yB��%FXbip�#���J�i$߬n��LL�N�QU��?Ei��Ɔ��ۼ�.Vd��u����V��|M��3�,s��)z��3�'$�����6ai���򸑚)��4s�A��I72AB+*�5) �Ki:�ru�vR�G�4��ڸ����G�`�G`�޼��
�h��bu3b�N�4�xOX!���_����U�!`toٮ�:/L=mE��g�d$*=��A'r��7?���V݅-z��E�Ҳ="�un�Z?m�\�N�'�K�B΂����yv���8_a� ��e��i۞6�Z�N�c��ͤ�A��$rf���5;B��D�O%$89�
�-�e�[�l����3��`	��'r�{	���$���l����y�Zj9�3�;������C��nQL�' ��lm')��akkzeMc�$�26o���&���U�Գ����d��[��'��m��;VȻc���ą��+�6�2�
��y��|��x\+�W;���Cn����3=g���4�݁ŉV��3�M�yq��ʇ���9��M&�9f����|�92��7P��Ӯmc/�d��`�͋L��������H�d!H��J+X�߶��Z�\+���l�T=F�R��;�w_&��S �{r�հ#����l�)y��ce�:ʏA!���
�q�o��$���j��m�Ԃ(�F�߲����c8�	�kksr�,m��f!���l�;a���Tڋ���EԮ�5O2]�ʦ����B�`~<���ZԽ��sAPX_�5��s�wb�h�nrt=s�
y����.-U�S0^�V���Ӿs��ji��joG�9�UWW9^�K���Oߞ>�z@��ޢd;��ٮJ�;��Ie�ԕ^Z�/�"��(2lʩ��Ԗ��}��a�:i�2e��!b#q=����;�����E�2��ݵ�}-��������p=�B�L9a�!
2a�����l�м�b�P1�c��Z�����滉Ч�Q��z���mp��uP�o��������F(�^Jz}��<狧�Q�$��������#yˑ��u6�U�c)��%�?���B�Ŝ�B�yO�F�]��`�cB�cx��J��(�3�o'c���m8�	˓,��M��䯎���SJLo���޺���r��
%A�ز�=���n����ɌZ���)WPa1\I�)'$���7�1r�P�+#��փ%��0���X��!)��������_�`��p����߶o����v�֜      �      x�̽ےIr%���
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
Z=o��!��!{�Y|��S�!w����'�?H�E!^��z��}͏���!C&��b�AхZ<P{	�n��>C�h�=�~6��S��>�΢i\����m��#�}f�`&㖗~�@b� P��d��<���V캵�J=6����##��}E�2;f]#�NO���Z��f�|�<���2v|�s��#���?"���ҋ��F鹎�->Ӷ�,�y����z�c,��0-C��W�_Yk�Q�\��Jz�c�ϙ\���L>�^QgrY`�����@B�,0��bIl9����7U+��9��F�y<�7�GB�?���[[!�)|)�1��I*K��S����
��{ݯ�k��y��y�n��'&��D���@N�s��Aͭ�$Y&Q�w�el$���XzLF~���s1y斩��2sML`�~N� c����^*;���;�Luޞ�kѲ8��
C�V{E��623Wf���~-��W�JE����@nӶ�?]�9���5�T�XS��5Jv���J��������A�4lh�z�׺l}C�nu�7,����v�Zc��������w�LO��'��(��|"��'rW�<�)Ȑ8c��r/?6Ar�n���,�X�1z�+��?�T����!w�mu�	�"g�	�c����GJ�3�w�4#b�,��B����!3�L�@�{��!�x�9`"��M����-�l&�q1�J*�6c�q���;:���4�x�]&��R��H�pj��x��m+�*�f�!�}}�A�~�B�0noU�@��Df� �K�^#�|T�����ļ	,#�LT�+��P�%�0�>ʁ�nkك�v��v=�m[�2���0��s����Y�!�t�/0�J�V�\}L���b��h'@����A���7n�6h���,u�X|_�2�gB8{&7��>	�^7������@
�e�}c�ta��2!^�ռ�ø"w���Vs�Ȣ�,�o��_��	τ�ڋ\oK�[#<��=7��Z8}T��N1Թ����{xj���io��VdN׉�K���R��s���6�|���m��*�8������b�!qв����f�pB�A��2IEЗ��^�谠^�����s]93��v�OJ���?=<�uŇXc�~��B�u�/t��Bu�8Y}����Q�Ȃ�,uu�ߑ^N�D����4i�&�.��0K�y���Y���Y,^�|Q�q� OGp���ݭt�ٳ�4��A׸��YQ^Y���zs}f#Hԗ�4��r�A?Y����d2�荄*Sw��ͅ���=�UΑ�yƼOM��;��ckn�+���=�(!�Z?o>��NbB"݀
8�����պY��_a���P�0���9���u 5�El,D^yy�^�feн��P�
�+V�'�j/o�QJ�V��?�?�@�OD�j7\��I�`=Y`�l_^�@�!��A�����[8���ugF��lE���A���Bx|$�Y��2��*j�v���En��Y�R.$T�A]B�)��'���d޷7-���,��i��T���ɹ�M�T3��,Sͼ^��L��i70Įu���!֏���+�ɢ��� ��A\���kx�/�b�چm�KJ���W6�B�{ �c�c��*u�1c����)|�
�c�$d�}�¦A$�m���4&f����A�&�t�7��	�}�vz8�����@���5ǍU2n�@5��Gv�|��'�1!�=�=j�WV
Y�
��r��gG�ѭ) �*�"y�*�͸'XO�ѧ��R��%#q2�ad�OJ�� N!�Ǩw�wm�!cF]�����1L)�N)�U��|�W�[
1>TJ���¶~����fkj���7 n����v(Uq{�����Y�M��K�΁+*�z�*t(����~	늊��!Jb�g�#�S'�a��:��t\\
L��˃Z�B�/$�� �i84 # 	�Y�����5:}#��6�,��1��.~,�$��ǆ��uu)鞀�A�/$�R��\#���: ��K�|�c��Oò��y]���v�[0����w�ya��~���3'$�v^�g�"�	k��9��)�q�s��U�Fą��P�lQ�_�2`v����y/F�����=23��9�XD�I9���4r���)�q�.�� os��?�e�;'5k���#3��8�cde|6i�z��^>�?�8���8�B��j��������Ϥ_�ɤA�:����z:f�h����v�_ԗ���5��� �W�����M։�4RJx�F\�D{_�=�R~B�}]V���"�?lG8����|D���ɡ�k��l?8+���F|eY�����TԀU��������Ʋ��6�!��G���h�N;�١A�/$�P����I�Ɇ1��O�ɔ
q\����O�h� ��֩ ���Z�X����������3��q�zT�7z�ca��ט�iEE�$s���k���U���گS�\���j0v�.����^�*�{�KQL�C��{�껬+p��Щ�[D�EB<U#���J����k]����1�^��&?�$�AD^$rS}�ev^:�h�� �(�Jb�2���Ý�fa/��^�W"�nV&nнn�1� ?��U��q��ݹ휪�84��U)�(���6���y�:&�_��7��Wn�&��([Ǖ�Xe�8�K��E�2��2fw��/?�����ސ}YŘ�^c\�����	T)���;�*.���[��.�#w@F6��Wл�B6��!yЄl��;)Y��׷*!2�
�����O�Ƚ,92ƃ�ۑx�6㻽�tR��(H���aa,h�=&>m8jQؒ5`XX����Ռ]�~P+��89ZZa�$�7:�Aȡ��	�,���#�3��/�"l��IjD\CB ����bjOv��st	���a��w_��h���rС�=6��F+6�έ�����T��YY�P�8QA�X��%��:*l!-q$�2����; &R�����q���v������ٖ!/�<?�%DDG��c�ּ]o~��>�)��2�U>���H���}L�fY��j��p2q�l�I�j�nD��Fyځ��)�����6B�ۢ�}"خ�H�M"��=]��Xi�AAlt�m�+���Y
�'d�ӑ�z�U��g�v�������Nƌ%sq��P�x"�.eb��.G�J�� �<���[��%�N�O9ܨ)�'$U9�"���`w��r3���d�	�w��I�%��
1L+c�VzŖUAs� ���W�r�URQ�|z�r��Uف��ʼ��_<�,���t����R�j��=��B$�V	���]����zem��:B���?suA�e��5i���h �B��-�5"��
q���\LR�:89��{���Bd�-U�OZ�ZC��%�Z/]��)�H����J$o:Ȗ�FKҩ.Ic����|�z�q)���HP�i�{�،2f �(R>� ��\V}�m��>/����Ƿb�Ǉn��a����m�bq�.��4�3��c�Z���s�:��'�@oB��:R:;�y���y3"5"%��K:���[�\��ۨ�2�K��"���1U�����2��-/�p�.�+�    ��2C���g2C�SW�?{!
�6w,��w��������GE�fw��Wݽ��yt��QT2�/�`[�G���YnlZDCA���F�k/&ءRQԈi��v�n��Q�8[DnD�)�'8b��eR;P�b��K+���"�#�#�p��WK��� ��9&���=�_�My��d�	�T���Y�0�#��Y0�&̕���/wg��e�i�T�����=:ӄz�$ɣL٩�Z�n h�Y�:��������Z z,5);��>E8㘪G�%%d��ra��f�7S�%�qH��C<؟��ܠkL�/!����5~�I~����wKF�H#/���o&Q��o�F��h��~y��5)��!�n�C������s,����gT��U��62���j�=�?Vhc鐨��|a����q��ǆ�*��t��;M�9T��α��G�>�/���=G|i�L�15r�ԠeӔ2����OMU��8T�·�/'�%a�i����(lH1�aU�"u��񪐺Ae�C�Z��x�N謅���ݗ���Q�2�&s=1o �r���@`Y�b��$*EIUF>:�-�w#jP�meRIWD��0��w�QF�p�vK�#�am;���	/���Ws��s�����:Yx�lؽr<���F@vG�%�{b��cs�="�A�xң���Y�o�QYϫ�I�SY82�M,6+#�+�b����J�UO���T+b�_s11�M��~�0�r��W�J8!h��$��E*�X�m��׫�x����f�L�K��7	�bGw���f����|���Zcꀱ4N���43`���.�e��c�9?���?���럾�Q��l3��9�;�S��9۫�����/���Z"+��L���L@�(3TAnl]�7���n�� ���|]��~P�a�f�s3���q�jE,��5�,e���o���dK��-�+�wS^O�$'���p��$L�@�#�ڼvrq�����%b�j�qd����9�H�T�]?vu�r���G5a��E���C5��h��Eh;��d�B44��?�����y+�Y"S_��c��hr�I���$��-H�e)Er��I�Z)y>����W�7��1C]+uR��t�ނ�t8A#ǧ����!d�1�.=�{��&�ҏ��%ߚ��'38̇�ʇ��׸kd�MZ/B�o��ql��úmW!�����c�?W�ܬ�B�Ė�� d5L5Z�2������Q��-m0����Y���af��H��1�X=�)�����|��W�� Cf	c�
�ҿ��U�lm����5�1�FNTl^}��vS����_�����_U	��^'�pUM��RM��G7 k�u)A����G�³a�b��%,͵74 �/A�V�%dG��VՇ��J��S|c��aZ;V����%�{�Q �`���R��ʘ*wGvJ;���?6#Ϩ4u��k�nBlU�&f�P>BMKi!���"���Vc5�47�^�h��X����������,[��Zdٻ��
N�V��C�}�.�_����ʑ��]e�����B�mYh��*�$����O���ׯS�a�b� }�U�
���"T�E����v��?�������<n� �ߊg�H֠�V�ĥ3n����}���l�e����17㝟A���Wf�I�T���c�$���\�/Bh���P�ŵ���_%d�	m�	�Ct�U�:h�z���4��Vϸ��v�����Io���P��+�)~骎�d��h����/�� L��J�a9t軚��0��ۋ���q�A������ 0�81�;�2Ɂ�fc\ �4_D��"�A0NF��><�2�!7q�o	��_�����"�!1�j�Ҹ�mP���d�O��V#��X���ư&uVظ�]hC��6ĺ���	9�\>�o���럾�U��yō��v�;��q"]�i������^��BB�dz�P�y�V�������[��f������؛�>A��G/;D5��u'���d�]1�\��ZǸ�6�1ބ�M������|`���t������A@?<�]v���,; �cu�r�p�C	̏n���Ԍ7�a���{x;$f0^T$W��J�y��A_���W������lT!���;�8t�P��%3y����r���s�q3^�s$�Xv"�<#��y���j��אa	�E	b+�;c�e����cր�±���B��#Y��=y�_�W?���?���_�-j��g�R_�mԹ��Ǚ֞�_A"�ބF���I����x�3MC!j��Zv��V�V���Cy���*��	^�%��$�[ ���1r�)2�'��B��EҴ�/HKUl7"`�!�Z������*�C�	���٫o.����7��� v!����Bu�:^2��d��a(̐7h)��� J�=�*rxe�[�����m#��x�ɹ,��4A�����R�I���%�J��nS���\=�<�0���mw�)�Px�ni�H/!:ƅv}��|�z�P�Q�����nR�1`B���^�P�A�Y&L��6�8wL�	^4�;m�����a�M�hÒ$����n��U_�[�2.��}^�`F��%T�e��l��&����Y��.���������<���W� ��	��Y��f�x�V���18R$/���!��<����10����T��I�D���O�'�^�� ��XE��_�������_FBP�6�=ww�;�(m%��R���HDhƪ���Y�s��F��4*�x#,���� 0R{�8ȧbF�e��^����<��\Q� �kҏ�����A��:Ȓ`K¥	�G�W�)Cky�7_C8R/�,��uM���a����"f�
���f�����4dc��`�l�˯�|��c"��J��Ø�xü �Cn��*��Ƭ� ��:�u�ƆI '��|WN9_��_�{u%�� o�a�A����{��m8x�e���<���b��ct��2�d�C��v�䔱�~��#7���k�&d�6	{����%�����MH��2�~W�-C��o���Z�p�%�0���a�:���+�Y�3��
��uB�(U��g�f�·o]�4�#&W�� ��c�ɺم&&W�<��c�܈���h�+̨aȘk-��ͳ(�0pȐ��L�[<6sH�Z� ��wt{�ܐ�X�>����t�>FHc����u�7exvX3�������R,��&���*��XB��)��zNe���t-�2��I&���/����E�{ey��/0gN^��&��o������������$O��|���!�;�Q�i�U�$�a�ӗӵ��*�EUh:��L!ͅSA��\2ŧŴ2���r��Y߾QX�&�)����7�9H�$�=���͝�Pf#P�e;����Y����yxP�4�B�yا#,I	��MAam��(-�t�_��h�{��o;���^��b��LL4��+�ޓ��o ���በGF��ACf3O�I�:���;�$:
�8�f��I 9�YD�|�(,ߐ%d��ѡ0��4�?2r�� I����.���i8��GF��Nv��@G����-|�|>�+
��,��wK��pI�(��oT6���ޣ�.���X�Ϣ��t�o����	������;��4KU��1:i�>6�������	��qOJ,[�rz<K��E�"�;[����*�Kk�U���)��7� ]�Yd�r�Up�Z(ͦ6v<F-[:��h�<|���K`�\D������A��5CD�`�]������"��4�ϝ�v�~	���f��Ƒb`�>?��D�'�N�ti�'��qF�LT�T�/�;$?��l[f�Y�KBu�!��@ �����t�F����U��~�o4���S�zZ�5���;� H'��1�� C�e����m�[u��"�- =�ܞ�s^�E�"��c���l�Û8��*��$�Q��A6h�l��M��Or�Q���̢<w���-�����DH�?4q�\�d���Q�w��1��)�����vt���r>�=�����b�Ik9��Y�c��v3�w����,�    1�η�:���Ҷ��Zc�ݰ���Li�8��x#�ܭ4;�=�s��;���Î�/�M�;����4�jA�Y�����*�Y|�(�7
~��-�lr�O��(oZηC�nL5[��1F��enGL����w��a!A��y.�)u�V9Ik$B8���җ����D�)9H8a����[�����(�Ό㎠?�۫��rwU dױ�]�<��bb�]ãi�q@������H��u�r�9�~H�2���nIwMa�X�|:}~�l/�ì9Ȭٸ�{���V'��*lF"E;��@�y�,�	r�Zb�o�(a/�?ʠR��^x�>�A�+;T)2�ߜYqn�c�Old��}#N�HXy8�Y�!g�5����tE��7>�@Ҩ�S��P)�O�?Ȥ���e�|�Ii��v��8 <�L����b�����}���a��B��sD������Nߨ i���J���f�����i=oK���0�[���έn�Ц��D��z�r>ߝ�մ��[WaSg���ih�q=.�ȑ2���D�Qee�m��N��-��K���T�i�%��/�'	fo#��!���kl�a]�]�/��/WO�[K�i���}c'U=77|��̭jOZ"5�7dC�N������v�K=�v$��7��[\[	M:H�fm�lK��u�Y,�4�d\O��c����ͽ̋�0�Zi�ሐ�뱈'���r�/;,�lU6��َ{g̭�t�����d-zD'}
 �3�������D��ګ�|�'q&�\�l�dm�xן�C�#i��"�2r��<�\��$d���][Xd�-L�F$!&�	��ɓ�H� ^W�u��cnLrTV}z���^��cdA�N��s���,��")��ĭ��l�����+�dnE2o�G����Ye *�����-�5.HBg��=V�M#����x��)�x�m�_|#�%dR�^ ����uS(k��'��������z�+=�LN�L�<D7�-
ѺD����lN�-Ӡ�7^35:ܙ��L.K�x���$���
�n�c_'-$�}�X�b��.��'���P�q��8�yP�P�搄ڃ��-�0'8C��;�W��ܢ�~CĆ��9b����=�2z�G%[� �����xp�e��fжI�a��/.R��[q2�X_�z����y;x�7����79|�߷�æ������W�u�ctX�N�`{����P�N�8+�y�ɥ�t���1�t��Y|�h$�%��!q/��H��n �X_�}M;�/r�Nܵc���#��3��2d���J5�:�M��8)b�Ȑ�r�%6b�v�գEw�Æ*�̽lL�z	��Y�Z:ia57�V2b� ���Bn���J�H�d��ۢV~|�I�b�%�J�����x����K����c[C��Yv^�t�z�5�^p�WUS���_'���Mn6�P�ix��R:d3���C�y7A�="����Џ�����$�z�BFz�5N[�#���ZH��v�;�k#�6Z��;�FȈ`9#9��i�O�O3>�\�����w���Z���8,C���
0��+	�#hx�CS��#�S<����l�Z�pL���ݨ�w ���B�����\66�j�1�n'�D��fG.�A�	�n�����?�G6��r>F��tl�k��U|G�S��'���tƇ��9b�����sh�\D�s��4|�tld5�A,�ĳC�Cb���E�M����t*�T�Bg�~#��y<���zk��\d.]ޭ��6G���L�QϺ��L����5`{H�`9��O"�=��/��������t?�]�Md��3L��h�R���4�͠�,��,1����+2�X�PB��X?B�-��GTB�g9���@�/C�Xe)�}��M��/2������[M�B�O/w���V���G��N��y.;'���v�e�sw>���CF�at糞/LGP$�������~x�^c���(��D�u7�[���&���I<��o�xHQb��MF�op��T��h�E�@R�cO|O2Qz�c�*��c7`���7I?��ɸ�����w,g�!W��(�(�p
;;Ώ��i^�y���YO=�(�S���Q��'�>�xڔ/���g�*���حw�F$$g	*RM�N�����*v2|�ġ����> ���u�&��"����������|uvr�;���Xg+���.���g�e{�+�W�N^ ���f��D��}*YZ�WE\�}s�t��ai59\��"urX��bmA�쀇#ia�@�a����s�!{��x���-sPY��ܮ/���1`�0�q���.�c�^�y�؍*�ve��CV�Lƾ���=��Yx��"��Ճ�V������Ǐ'}W�!{��e�n�����ơ�+�Q�%O���铪!����d��6Gވ~�<��v���������Y$���2{��%�X}-#�eR�'-	�!���&�2�S6��`�^k��&���XH�ag�[*8;��e�����$���R��8�k�\��w�O�r���~ݷ� pY�`$�`�g�{��d�[�!�KzzbcWW
1d5��,�x�{�L�8�!�����n�}-��෈z�W��xd���*�%j�<te��Í�y�`�.�Z��c�e����Q�)Gc�����=_Bf:;W��8n��+m�Dr�
}��-"
gE��!ӎ]�\��c'��o~��'�Am��a!��Ygx��fg���2D]��&�G#�OĎ�ln9��Ǜ'etH�cQV�NFn�}6"�D,]*�j�Y��p'�!$6�K�i9�g¯��C�Q��[��,+��)O����ڱaZ_��O��Vd8��[�+w�<�m�5IJ�k�Ru~i"o�ܪ�dd�WuS�Ԉa!�T�H�[�qouʯ��z�G�;��{��^y��K��pl0y�n�G��j�&bS)��}=drC��{O��J��ӫG"0��b��%�U�(�E�:��O6č��[��/��=?=���aFYē^le:�r��v�GH��[�k�������nI�W'��C����!�h���Xٖn����,1�[Ng$�w�n��5b[�㿯1Gy������Ut�r�����K�O��f坁�n�6g��2�K���s��a�Q�F�����u���U1t��V
p���
1�;��LY��VbR0�At㭫��$X��#�t8�m�-c��>��)�4���P�a�5�̇�[�c�5�o��\~>��M�� ��Nah;r�`��\ �����帡�>C/Y��*�(�Ej��s|u�S|x�'$�p�.�z/�|l<� K/�{f9��/��j7Fő�⨵��Y@e�^�W�:��
���>)İ*2b�ak!��S�@Ȟ����K�)��?��D��]ۿ�ԝI�1��ݶ�W>��9#�9�p�t#,h�"h`g�V���qq�����Ze��v@�!���u��Z�qن>�l_dq]�ʖX�p�NN�������|}t�,�~f��G�Pچ�5������L)���1��W�9����hv��ы�pX����������S��bdrl��9f��ϟu.�aڊ0j���R����}E�{��	|�0�>�+r�"����R4���.їՐ�����w!B�%W��:\�"�9����K?�ҭ������A:	dnq��%�[Z����)�}ZX��h&�ď)z���xH��8m���F�#��gs����C6�k	���(f���`Y[�u��!g����5t�h�rF ��:��ʒ\N��8��B�ѹ��É]F,�9b������Ì��Zq�#m��q &;��Tm��f@��|�q��nl�<�����),E�X:	�mΌ�8!!��`�.�;]#~I�tVY3>@:�R����ᱚ����q�� �����p;���ǘ<��m��D�9+<���9G�%	 �#�jQm���%N5�]e�D�`XK�1CB-�0t��OJmV��r`{�R9+���K����9��;(�w��Ō9 �q�[��ϒ    7�C�����:�t�V���X����Wr�����YF�+�\���<���!�yB�s�v�R�9���
$sN&���$#���Q9�$�A�'6jD�ae��qK��6ne���O�)qL�[	��+<� v��3n��l�0o���d�\�ӷ�e��(���ʉު�v���q(��?��Y�;&���D��?���ln>}s��'�*%^��rdt�^@�I����q1��T>��nC��r������t���C"�E~��-W9�h4�
���l3���G�!��t�������l���ll#b�N^b��}���S���䝳�����MǮ������^�A�*�h��호&3ֈ����~�$q���j�![��"A��^w�S[?_�o���\9860=�����qH0�|݌�����
-�3{*�����I�xC�'�Zo�����ʍ�²���7�
�2<�`�3Sq��SY7�?�zNgv�mI��5g�������n�#�I�Oz����a{pAfN�1�u�oy:�29A\�\#�6w�y�1[ګ��iJ'�'/��N�
nhDC�@ӧ�=3&����|�?�E<�a�ˉ-�!�{C�N��"�c/��R�� �"M��0K�C�װ�`@HA�o��<���B���X��w������t�؃w57+��H�Fyb\���sa����,S�څ����>��o���.��qA��{U1��^�B�Q*����E*�xH�₈�-��|�f�I��cP�A����F yHN�ƪ�[3�]KN2 ;5��P�K���C�&7V]�m����Q�%���iY�p4*����� c�t�f(�k�����k�W���rTzF��n�a��1�^���'ږP�c�����������鋾r
��ƍ��=Pzdܭ:�p��A��|��^��b�F1�miv��ԍ&+ANW�ˆ��(^'�u(z�p�#�� 5a�l��X�ӭ}cUptKMqЍy�D�֪ޠ��T�c�n<��YB%ɭ�V?�qrPʻG}� ����t:�R;�j�i찀jz�:u��Z��i�'1�����2Z��XO�C���z�Խ���P��x���1z'
���M"+^M6�k8�k�|E�(?�ZO��3g�ǹ�!� w��+������6 �X�P�>���5�J%b�^&�^�~ț[7����TLO���5�p�� 7�"��?�L��Dv#�?FEK��w�^⻹*���8qJM�+��ex���sJ�K�� �8�"M��d-�`I#N�
�Bu2���z������3,:���[�o��+�s3ЃO$�Vn �o$t�=�f1򈇾dcr��im)z�i"W�L��&@
&7	Gi�vX�5�N�
(�L���������0�U��wq;�?\�1%�{��K!����>�?Ir� O<�Pe�y��ŉ��2i�>���8��U�
�i�$��(>�Ƅv�cfNi{�[�1,n��������M��)n0E��-�&\9��b�s�f�qM�؋r����tQr	/*�s@�\�x!v^��z���n�ֶ���ò)�˥>UMdqs�􎍕��e��L2ւ瀉�㖝Ao��\n�@��+M[oE�:Ӑ�1*M!с[��1��5�r����b��1y�"���ӪFV'y� ��S�&%/�A:n�ƽA����iݖC����z�tr���l��*>Cd����I������Q��qc���؊x;���I�.�������&�k�-2J�8�$���%�թހ�=h�{F~������
3,��N�+K�����!�{�|9��k�dC�"B]��a(��Gfv3̂Qu�f��_����߾J�0��"��
��3������4v?f������?JsC6+���Wؗ��4��#	Q�!Q{�n����߾�CZ�i���6�pL��Y;u\��ko1P��Bҥ�ETK�b�oG%I�x���i+cG��9���Ey������%����6K�F&��*�jZ"u��$a��#~�:�c���ۼ]o�A�/ߔ�/��.^L���W	�~�J���qD؈���<n�&��oi�1��p��~�k���8p�\E��c6�2Qͤq���*3.CC��-��28����<�˺;QF��u��Cw�ؕb"��S���Wc���� ��T>���v��aN���y\��@Ӽ���:��cxSC��a�3!��;��j ��K�m�9�'��o�~u� ����`+���`��vaț�������?�U��l[�Qir䍪)����%"�N�bV��� �z�s����+̖z�R6������=er?�*5���^�7��{L������7*�kА�ś*��Z򑞼|���6#׃SR�*�6_>�v�exΖq�qsPYt����l��� �������X�TL�S1E��
��G��~�{B�c�d��n_��O��O�ٝ���c��?|NJ���SH��xzz>�� �ʽ����v;2!)�qە��ƝN�K9u����rw��8�A>6�������	��c�y�u����XN�xA?��.x|�J#���pa�1˞��Ot|�'�!�_�d.����.����N�L���h�����!@F
ogyƤ���:�$�>8דP+�I�����"��׻����m=�Eƨedg	A��*6Uv��-/L ��<����'�lXg�����c�D�{���s>
r��ɦxG#S/����P�[.KO�Jd1�Q�/D�ؔ5�L����i�`��c��]]���x�V������7�dN��Y��4�Xr��7�t��RV�P�^�o?V�Y?I����[S��dv`x�^wx�ɭ�i����ҹ9-p�>��^��d�ʃ��YMo ���U}�m��r���.����@Đ%���������/����U>ɂ@1���O%H��H$�AyTn����R����m��+�0g[Yu>���F����7�c?^��ܟu��峕�s�2���<a�\�{v�r{���*����U����:���_r{b1s)І�3�gbW��C�������2č�^B�eC�l
�7@y���ΤT��/2T����0�°���(Ր���+ZRl���n��i�C9��e�)���u�'�+{�M�������"�wRp'���=�ϟn�{��� ~l�ˁ�+�qU�����;B�0��E o�8^�"�J�]!�
x���A��ͽZ���ދ��س��e�����R�y����z�IR�#����Q2�x;���V�#��~v$��u� 0�߾�߶�+��{c�U3X��֓����sc�z��S!�zaQϭ�Å	��.d&�3��
wCu��
w�w��v�{y�;z��܇�^�������H}!ڹ|}Y�2,:�(:ZR�;f�򢐃����<���p��$�}�&�J�1k���'Q����d^'=�.����(��(#�z9.��Q��˛6s�ʳ���j�wl��'��02�*27y+_�ݛ��#��65�]�I7�+}eVAT-����y%����+[��*<X�)�ݓ��`�vU��qu�g�U�1�i�*�rA�:-��>L5�;s�=��Y=���/\ dh� ��ǵ?��";ӯ�zMjD�39����-pgX�Q�_���Mb�h`6�ǂ��$(W��M�����ݝN������l��S��vvv��{�2>����0ܹ��N�^֤��,�(3�������)s\h:֤�=���.p&Ѓ'���e�F{�%�c55��ࡪ���|�\��9���$�l�>T��O�x�n8IV�sTqao��4n��~��:"F; w=��UCf���Lݕ*H��븭Y�;�<��������$���bef�����HM&�������'mn=�:z����XK�S��T��L�m�G���|ql�5B>?��ej<�^�m�;�Or� �����S�X��
�o��
p��@~�K��#d��(Al���XHZ[?s�A1�y���aŹ?�' V  8H|�G�"6�^l	����
Щ��?���r��r�N�Q���;���}�#U��6�__�Fa�T!���#�nL�h#B�]#�L�ż���"GFH���Q���-�}��dm4�DI�V%��r
2B�?U�{9�IG�bh�xe�녉�cE1��X�bR�ˏ�[�oz81�k����T& ���x�4쇟6�NE�Q�2���u>=����H>�'1�%!������z%g�� �D�-SP�Cۛ#�2�h'��S>�h|�[���]c�����e���ke���Ff�5����=po�>�'��]#���M�,P������zms��~Ѥ%���Lթ6��")�Ǖ��,ۼ�QM�ib�TՁ��7�mGi�ad�[r/�ӠR�D�^�Wx���G����;���?����,Ψ��G'~�7
��1�C�Ϣ�r�_C��؊�pzD��=3���ޟ�d+�YT�-�� ��y��	�PX�^�^�;K�0'�"'�D�v�ƆJeĂk\e���)��\}���ߛw���^Z8�L�)x���N9x��a�^&���b��!/���颫$��I��,�_/��22t�U�����;7����YVG���s%}!GJ7 9�����$%FH��g��:���w���^��+Ųa���t��]#d�����=�y:�j���m����1uJͶ>B��8����CW�������s�]��z~9ߟ����A����.�ES��3j@�j�~	+3c$̚����է�/�a ?�_Df�ӑߡ�6bxv�~�$�YD2���`?���Ŗ�hȏH�ul���b$��-ɚ6d;TY�Y�Ôh��,��G�z�zZ�Z�{�=#��nIӭ0dA�(K�Af��25E�m� ![y�M�x0<��x~ւ�#�0��Zr��C���!�Co�S��kh�35���a�\D´G�B�a�` 򁽪����e�0�"�W�{
n�WOQ�#�.�yߧ��������c{�sn�Q�]��: ��b54vo��3���-�YS��!h�|b�a���Y���:Eq� ���&A�I�����)@���,b�oL�^�X^��#�+�e�b^�����膹|��|����/���k^�Q�2��f�1�S��Ha��O���v�mM5+�a��{9�%c^����7�?���l#rd8jo�gګG�St�@'��L>ܨl���P��k]��l���������	��GEY1B~�0T�������J]IY����C�F�="��^�3ј�z"���8�����t}��B	d�	����/�7ԭ������we���|��IZ�a[g����sK���0{�h����˿���"��      �   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh            x������ � �      �   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
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
-Pl�#�x���Bԩ�E��&r��Z�NM�d:ܖK�/<8T(Fo�&��NMd·��A�Wx���B�m�$�9�C�(�D���~!M��6�����κ\n;8k����ξ����y�^��BM��m'���m'+f�m'k�m'++^xp�P���m�$Q�vpҖ�n;8�j���;Y������S����؅�=\]_r�[���,P�"���p�(���߿�?Qg%a      �      x���k��(��g��L �@���A����G�����:+zUWmB<��C��+_�k_����㎿��_�K��p�!�_����R�5���/2bd��#3F��s�߄:��o	y��?�
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
��;����>���ݰ	����@�����e����ֵ�eE}���5��m���Q�"9�����\�b��c͠��W.�{Vs�o.��?!-���%!��Uv�L� ����O��=�")o~������<��-(��W�>�w��`�Ɖ��w���V��mK����F�O-b�ٞ�m�~�P����)��'��Om�5%O��I֔�[KR�_�~r��d}6�tFb���->p�\����CC��Z�s�R���ci1(5�{���_��o-�Z��|��]�Z��GK��חI�Z8��E��k�LS�cM`��`IW�|C��OZ������w���{��ZW������W�Y��eIz�V�jH�bKXKv����/�oR��[
>_���1�]���Y��{3��η��w�>���B<��`��B����&
d��0Q�~_0�B�g�2Qh��s�Y��"��|�q0Qh��s���@�u_��D�Y��Bg�Ъ�/�`��,ߗc0Qh���1�(4���
&
��}a�v���
&
i�}a�t㾰��B����h�����t��"��V0Q�U���V0Qd�V0QD{;�,2w
+�(���L��,�)�`�����wJ$�(4����)�`���ɺS"�d�Lh@�q�	&
�=�tJ$�(4_�.�)v`���5�؁��H���LZ���L�ed��;0�l�F]����v)55�qz�uشZs��<X��{f<�x����aK0�R�\�?�Z_k�J�qn/�IDk�ߚ淽��Ɯ�Ϳ����\ƻV��	���q؏�ג�7I~���M���p{g��G���_�[��򸉺e�%��&��y�S-��� 9�7�������]�}��1W����_�!�P�6C�oջ��q�w��p�}��e��ѩq`>!�3Y�:u�q���~���&6g�� ,�;�f�S���gz�V���IMn��_��G�s�|�t��:�Z�%����R:3:>��ௗ���r}Q?N��7�%k�Q��?$y٘d�k-��v�K��a_����pfbMG{1��g�Zu�᣽���A8�SM��C#�8~J��2RKv���9�!�x�l��T���/��e*m�{)9���;�mu~�bhI�]Z�|pR�����	9�B��Ǵ����:~���׾�g�|sx�d�k���b~����k&�G{�w�gͺ{��
���z9/)��
���*��xX�I�/�]2V�b���	�}D9��f���r�g���hw�ZI��x��k����c�r���>V�͢��������D��%��w͙\{�&�<����7�;͗M��3�j���-��l��̦�}c�����J����K:���u��q[��r�&���_���.��j�!���c:����*�\-=2>)�;?~����ێKu��qM㧠��ҟڍ�6�\z_2�f�v5���tr35�L~[��rlqe|olK��k�~��#�������X3�
.�*�hf��<�`��[���}� �y�h��B�BK�][=�u��X���j-������s�86��8���(�̟|�5&�2�j5������0�S�6����������(qxN5C�qhn��Ͻ��>��u���l��,.�lIk[L�e0��jѿc-�C��tV+���J�e�r��yno����V��o�<t�}`$�g�J|�G_ۋ�o\���J�M��q��*I>p���`���z���]C#mG�[�AZ��s6�ezW��vI��T��aeo'dn1���.��f��Z5�=���U_���-ů��)gV�G}����ݶ���qY]sH�	�����WI�      �   �  x���]��6��5�b�@~��]�Ţ�Aw���^XhleƝې����Kٔ�!�؞�@��N�P�sH�G�y�=�N�w�~��ޚ���F0!�c�;��� �������w�9���n5�ݱ�1t`����0�y��`�_�+�ƺ?��7��@�כ#!�y����v�=�L����i���wT�zUDb��1!B�@�"��Yft������5���(�7�3�,X�fF��g"��(����@T�e3�l=�OHnVD�7Z9Q��YqO�q?�֧��fu�{C�kml]�!�X���3�m���w�㶓��f�>�۰m�@ �t,!F�x
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
-k6i��:�WR$d��%,H�LXd�Y�y�� ��L0�kfrb����X�f��� g92O�yN�[��@ƪy�3��NC��E3���^�Ma��"n�m�HtO��.̄�Oi���}Z: ��������1�      �      x������ � �         �  x���Mo�8���_��ަ?�a���]�
�R`���"����iZӰA�ߑ�zIj�B��������ˌ1��N�ȋ�%�_��������_�N���_�|��\��?]�u���C���9v��*K���y]��>|����=��KǕ#�L���/��gl�� ��8b��/�鶚��FG�i�u׹����3�y[.Uk����g���!�pbG�	�P����G�=�,B��'���/�ݏ�C����zb�<�O7Xl��̀�Ў Y8/<AX��s�=�����.t�*��� ���?
��S���$&.��H#�4.T�F��Rq|t�Q�ņ(�fI��=�V�� �I⡚���D=��9��yx�B@U͹7|c��}P&�ؔ�-�3V�����7 ��@3�ڸ?�j�CZ��d�8wod�V��Aߠ�6���DUfZq�YmQ��th�5)ۡR�v��#��e+���:-����	���m��&ڶ�zP~��	��|�F��TEC[��/� ���z��Bk�2T�Nd ����q\"vwS`��'M@�����sM���]qD��/2��x36�)�Bz4��;uŗ;!�^I�Ϩ&ɜ�V��z�U�Ө;�)�6Q�J+N\5E4�)�%E�Y���|����?M�Mo߬=?|�8=����qzzx|x7�ErJ��~����Lݖ��(�}iF�1/��g����H�.):G)%����<h`�M�m��Pq������H�J?�fw�S����^}��Z�U�%�gT3p0�)��R�+*�75�����B���⼉ 0��y�����#`�d{����K�)��!q
&��i�{��"`�<����q�uD����gd8�B�GZ_H8�����v�p�Q�A��a��g���q���|��lp�h���|��� |,��         �  x���M��6���)�)D�ǒt�M�lz�K���cI��RRN�g�C���JX0`��˯�`]�C����ˎ��9�eY����ҏ�����B��X����үC�:�G�O�����T�L$	hm���YMPY`�~��[�������iC�6�o���k���t�o�'���8��p��@� ��p���@����y#B	�cD��<LT�J�>_�&-	���l��@�π� �tp�s�m�fn387��M�Ҟ�fu�ŢXP�׏[�>`���W�f� i�& �&��� 8c��;�]2 {�&�X��"X���0e�)#�"���1a�$��"<��� q�*+�'q�����iӾ���bA���`�k4��܇r�s,�]v|�KuO(A�b��E�ȉ�Y^�F��ì��r���m���N��;��	�A���be@�,)i�ע���0ˈR$�8���ok�m�y�9��dƚ�TJ4����@���< 1�|/3������uEbY\�"	TX�L�& G�S�P� E��or ���4��|�����3�Q����EH{��(+/n1 ���/�����A>V�ܡ����d��WdbD��naPbh%D�ҏJ�-u8S_!�ፙ���wJ���J���^�ϛ/yz�Q0"!��8�
�N�t�����s� Q��tO�A�eg�Rt��X�ܫ�	��G�΢T����c� f� u��ί�^��=_�O:EWI�+jᚋ$���-0z�@+�|�����,$���q��Y�|�cxf7s�KP�=�h<P��R�<���j�'��e �%F�֧�=���Y,@"�f��bb�#�K^�ʯ�� İ�!�Wx}@9�@2�Y��X��eO����
$_\�Q���G>Iy����oLf;����`WD�ޞ�d	b��H�s. J���3"EQ�:@�u���VއR�W�vp�Eh+�[��}�y5�#�Q�n��D�&0���=��Ȁ�5�D}�Ӥ�]�(�?�^��x�H`Q�����^_K?���2�=�U�.�n95Q�2�JR/�K_���C�K_���(�鳒+^�|�@|�u'�-`#�&*���0O�	
ǥF���1��H�I}
�y1RV��АAuD8 �e�S��#��c�]��yD�M>}�;�����wĈ�.}�;�����w��K�6���*q�o���>V�/��{�^�G=x1�(�5�1R$�~R��i������8\��#�X�j&}ˍ��}�o�q�[�貌����חn|M������ZߣH�q�*�����x���/f;}��ԉl&�ђ ��e�ַ��:�a�$�%)O��q����[F$��I�5]ן�0��3��\�{�rr#=v���L����u�H�����{}��i g�<s�)�7�����t{}y��W���t��z�YF��u��(_�\��j�S��a0U�b�*���j�q�tF�9l}�Q�N.���*��閑�J�͌�{}��u���ʵ����u�" �J~���Zѕ�3�x�2�U�j�gK��~���7F%�Q�����!�Rѯ��2�g�t��	��,f�2�n�^�����7.��������q�@���n'�>ʑ�ڥ��?p��=UY�6�X($TR�nt[�tT�����ʕk��*=�=�!0��(@;9M�߄�~��W�O�u��������ч �{8/W�K�}J�^�Y,X"s�mT��K:1�ڮ�b2Pt�u�G�o�&�~���G�\�Y}[]�U���$N�E؈�����>��7�af�����G�.}P����w�A�#8��`*�aK���?u���p�~���j6��� ?H��O���b�7�/B�83}�M�
���� u��oB�C�~��Í[��D��p�>H}�|�(��֜�N�a@����Zj�}�۝1	��MuG��"P��=p�.�i��[, %����Z��|░�&�_}�U~u�������<�)H}��������%>��?p��$�=v��
'�G��;�^*Q���2�OR_]������L,��&e���-�
����*ӧ�	�~��UT���oB�ӑ�� WB�
�>����%�G�-�j��q��q���p�z�M���7f� T"�G�����?�~&@��wjIz��wj�rqP�� H�J�I��\ۡ/]{�x���x/�E��_���?:oO      �   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      �   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      �      x������ � �      �   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      �   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      �      x��\k�,���]g��;���Qk���c�$(K��t���P�	��T<�Oȟ�	�����������k��1�ɰqP�'eJݿ�*5j�(����a��T(���a�^�5m�D�J�;��{Pj���0P�'%J�ߴ3���4�T[2�Rϱ��NS�kH1P�'�i*�$��$>M�w+{x�d>O�7$���W�mN��`��'S���7�Sl��'S�ϡ��a�ʈs���a���{��L����\؝R�7�kX�^��)�~��^�O��Zܷ6�_��1M��k���ba��o�|1ߪ�?�H���T#>)��n�cVm"�)t��ۿa��4�S�S\�e��������u>�6s.�0P�aK�n�%�)V�6s�h���ĵ�sl�a��^/i1���*m��z@1��8��:�z^��n˰	aN;��ݦxP�v��sl�a�ru���6��:u��)n�u��?����}y��0�z�P�v[�رg]���_�׆Uφ���b�b{udC�t��f[�XV�hX��c��pk�11�R�h��bMC�����-/100�)@��V7���:�8��l��l0ja;�5��zQ�O����܀���7����_U����)>"h=�%6X��3���Kj�R:M!��0Pw�[{3g��U�?��֬|�p�@�Ŗ�Mg`��3�f�}k��nc�|������baxo]���8��\�궬��0�>��v`�9�K���f�."\�ϫ�9�K��z�wuq�t���j6���̹��էQ�a9nV��<n�;���{��|lٛ�^��"f8�%,���<˕n`����A���=�a��O��6���ylp��|`��{YkV���p5�"vkZ�ugɅ��mt�0Muuv>Oq�K�nO����ʺ:�U�p�|��B���OT&s���X��t�Yr#n�Y�t��3#��ȩ���7�RG8�.�Yu�nu*ͤ�fe�%U��y�c��|�͜)�:_sX遁�N������cF0��Қ�%�50Pw�8���R3�^B�KC��n�\��-N�jx��[Ϥ�x�0P��C����9<�syoj:-��גo:���<6���)N�R}��6�1��E��%>֣ΰG�}�u��a�{�_�:-�Ɯ��NK���~5�S0��8��yHfp_ڰj�״�8Ňk��z���޽V�;c.�k+w�V�S���cISL��jȰ���@�d͖�����d����c�ϯ5+C�]%=c��a����U�*9\cм�|U�#-u����Hp	qd�{� "Iqd����)Z\�jm��*��DD�����V/�׆�*���늆�*��c�5j�GjX沴��*�����e�z�����U�2Te�-�YM�0�:�p����^b�k��8Ұ���$�U1��ҩ�b侶�t:e���Nlkz����5� @������@�Fq�i:�4]h����!qM��T�)M��-W�0P��v-�r����N*�6�2պ��a��c�ѕS{��ʈk;���nS1�*j��S4�:b*���k`V�L��ؖ�ؖ�Xr���iR���%h)ARXܗL�� �׃���m�̅�չ\�y$+���ǳaиO�w��>�]��w�����w��a����r�E~�G��}E(P��j�IjW��m�j��t*��6�!RM2�R����$1W��00(:�;��*���$|����`J�K���)�W[��
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
N��[���ģa�T��v�*�ĨXP0$�ֶ��˔ηm�$8L*5���WgA�].�~�Ƹ�ՠp�!ka�&r ��~�'�7X��\:󈩃�b���Z�/�O[�0�Z����� �]پ�C�B�g3L��5-=ۼ���X{Y��̭�4!/k��u4`��B��ڱ��m^����v�o�	��Kq��^��|�tt<�`�W����ӆ���dM9��������\V�=� ����c�C��~�RI���TV��a�֡m�+�	�&��@F�c���ٍ�)K�=wV�)�B�x�w����+�p�p�1մ�⚭R��:���&��]��b�tF��m}�Q��^�t5����U��P+�ʸ��j������cX��      �   �  x��Z�q�:���pr O�"���x ��Jm��U�Ex�"�A���[oX����{�=�r��9�!3�{X��;��E��9�\�c*��*��{r�c�3N]�}�;��X)_��BDLD�I��c����H�I�c*"�,����X���2u������e���B���rn�UR�y��ƺH�B$�Z�1��WQS�嘮bμ]ԓ>�v�{��s��ݧ>���F��SP��;nA>(�T�~X<���ry�$|�F���3�豇�s*n=�x�eh�݀Bb����t�}��zB��rLE�hה0;��	x�����9�O0���q�x�
�R��	\*|�T�� �G���X ���	�`B�(�\����	�W�<� �c��
E�"��u��� ��B݀j��cBo���RB�Ƅ:RF��VȨ3��<� �B����sAù��\P?(��*��������C-zx�Ȃ:d�݈��gC�:��<��࿃�6�M�\��#��\�Nc�L�An�p�&���Ӵ�I�iB�y�#Е-;1�x�C���c���I����ۛ�_&�� �hh�g�Ђ=Ie�������.�veP�OK�-�881�n��ӆ;�x�Xm3�2ս�x���g�F.���2A���i������]cg'�s!�đ:Ѹ�6��d��<[��0�		�����<{/��he��Q��v��U��VB.T� �ECNW��㼮���]rЩ2�M2�ȂON{|�!a�E�O*�0[�2{����.#�4A�C� ���٘{~�!����0�]�bnh �}�B�S�nѬ��#vnz1�,L&摖J�֚�]���S_�.GՎ~�)��U�Vv^&��	���@��I��F��M��k�W�`��O��z���e�B��M��V�;���F^�`�CVxƼs�˱ޟi��t��]^1����щ����j��$��sDk��e�+��3�J�(�(�h(�h�X{3��r ko`��T"p�� z"�\?jF�ig�4�m+FijF�^�r�����,n⬈�g�4�ߎȲ�#���_6�wYUo8����j���``�\�^}���κ�h'A,P��AcQ0T���z��+�F�8WS�2��;�=F{�,h���m!�7�>G4ˠ�a�S\�jl�j���m1�>�j��Gm:��@���h�{�V���64�ܽ�={]��D]����F�I#�Iy�l��h���$"2�����M�з��K���hO��m�K�j���2/��n��v~ lF�-�9Я�I�m�{� �wt~���#mW��)7�YWc�����] ����t�Z��Э�K��mf�z�=i�'r��S�x�W�aX6�P�lOo];E7ꈷ���X�;�~��|k�Y�JG&�2��.�epUƧ�s��	�{y1,�h�T9 �Y2MJ���t����4�v��;�;�'�%� hc�v��B�(ؿE�����-����;Z1/����- ���-p$d�{�9.HGz�ߊס��\�U���V�y��:_�\9Y?��԰��LD��GbO�C��M,Zd`�YC�b0e����ϑ6�H������rjq��~�����"X�*�����kxh�F��=�厚]��f����vm�-]�([�I,�n���O��i�����.�0����Ic������_�X��>�����E�      �   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
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
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po            x������ � �            x������ � �            x������ � �            x������ � �      �   �  x����J#A����b^`������EX�lVA��m0 f���2f@�۱�����ưʛ�}�a��&��u��b��<=�D5bMZQL�I�Y��sHay�6�9,�����W3Ȱ�4\G�#UH�gI�siX잟���7���$���s� �q
4�q�b���n���]|?�f�EL���P<	��d0������{���>5��>�S`|���:�C>"����T�-Fv�s��6�,,��/ay}�5C�f��@ڱZ�c��c���8�z>��j�Wؤ�&*H� ����KI�ȓ�����8k��#N�38l�?t���R���;Q�"�jF��f��O%�Ɵjf5A^��=�	DG�Y�&�p\c�b����u�A��_�5�/��ݶ��o��fqc!�P�Y�=��c�1aQ��91�'02�:7�+R��c�A�A�)5�*�$R����M�q���R��;���R      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      "      x���ˮ-�������j@�Z]�ðQ��7��0l�@]�ߤb���Ę�6re~#B�(^~���o�������߿Z���O�O�����o����?M��}��_����?�����G�? }�?���.�?��������������1�cI��e�=ZF�@?���_�S��?���sA�ZПZ?P��������_�������������뿾��O���#b���b�h���*T�Q�i���h��>����h)�b��G�{�f[������]r����?�7�������U�ı��?��������G�7{��~����՞bǃ_����Tmc�x��xX�t����_9�A-{��_@�SЖ�����;��Y�&�O-o��=@w@�(����+�!�U�QB跑�}��W�TnE�/�������*�)����FR���?�ގT��/��FW��  ���7���­�_l{0��B���?�)<	�O��`W(�p�by���g՞����ɟdi*a�5�׉��#��mƿ[��<����v�;��%�:}���Oo��_HM!������J��	��J�7 �!������$�C�(�V͸��P:�/0��As��Ä���yN����/W_'����b�I�-��jv�H��;-�
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
�fV�D�C�ܯU�G#x?��)�ۦ&1�����)��U��<��,���-%�,q$͡��֍�̸4��~bqG@�f��Ŕ8SX�\�HCC̓�ϩ	G�̸t	�)]�.��<QY�u�a)On?:y��Rnf]��tg�~�zow�.Kx=��Lp��1nw]���Q8uZ(��W6�,��ӷw+=�r��1zK/U�(�zP�3G�⫞�V�7=�����)S��aR��0�c+�/�f`w:����c+��L��i⳷����J�����u0��.w�����מwL��U�X�p@����_��"�M�aJb*���[�{m~��Q����(E�{д8���N���e��/�qG�)�� �  ���~�}�W�3��pI�1xivX�h��i�Tt�a�./O��y�)�b~cf�����}^w|;Aǔ9�bYL����X�ꒋ�S�b�3s�Y�K2(]]"�����f=n��m� j��E����4�9�&$�wi��}Ǵ�2�%�>.rf�	}�Qq0�ˎ��W����wpi�s0�Od��{����a�l��z[.~�%)�`�Xn�KN��G12���0��q��9��y)O"�I�Z3����#��[*y*}(�q����ib�渶��P��?�,��P�ڒl)q�}�?lDD��Sc��p�hְ�4ǵ�C�)��w}6��w�Ыd�ec�ǯG�.�-�~�2y1�I�l�u�atE�q{�"��`�/�r�"�#V�ܣ��Ru���o�]v�<d��s�N��h0u��_tٹg
��M���p����|
M���$��K���S5����=S8���	�������'3���%�Ph�\�\����E�Ӏ�e��3P
?qk'��i�$�)�C���� %޻�� �>�k��{ס�aJ�SpG��F�2�7�㰯��4C�������E1��p��+���,&�dw0�K�+�e���CJ
���8��F�����β`�"`);�����l1-���+���y��C���vXLz��c�_�2��b����oZ1%>m*S���dB��?�	���L�L��p(��$�?��y5h�4V����=��cT)%.�9R��'���F��L�)���ͱW�܅,������夹�b1�]�d��6���D��y���#�1ĥ�-si���S�m��$�ۮq���2�Lܕ,��T��CщmzS1�S�����lu�oa�e�j<��Q`586FD���`Q��R��cƌʤf�%(]���:�������7nK~I[:U��GL{��j�t/9�Qv�lfS��*�.��i��&�L�N<ꆩS��V���/i8#cN�4��5yІA���Ro��ě���� ����Y�@��V�%�`�z��Z�T�h;��1�ZN�Gţ�<�T.������0�~���4�]|ƨ�Ҳ6qx�G(�Y�)��i.���z/$������3�i�=�lb�l�3��4Y02c��U�`��}�`�ZN�Q<�P�"�b�8����I���8��Q����d��x@��Qi,�Bg2s*fj��w���М�0�*;{�;��i�ᩜ�{[,��1�Ì$)//<��9юiPШ�R��_��aԼ�A��8�(p���z��p6��i�y��֏`��izD��^�=�LxQ�//OS#YNmǴ)a�g���\v�Sz�j�	������m��e�1C��rl��`mNy�)�h(�=�I6
A�T��V�n�8w�̆`�8����4v�&�^�����uV��reJ8��� J�|���{�]�Gh<���~KA���F�僊��Δ��,}9������poR�%�N���4;v��4{q!����\:�N�x��o�-���9����f!q{��w.2���Z%{�`��?5G���vJ���C騇4�;b�Nv�����7C�Q�� ����t�&K��!�kϵ)�?j]~�%$q���1�l�R���1T�>ˣ�Z�9\}���'�/Y�#e |o6]��T�~'�C�t�U6�|ѩt(�w�$+�G�����fs{�P.�b�m|JV	3���e�rE��?�)_��)���l:-_�rc_]�ʦ��r��%;�Bb����L���k����X��L�db^t�_�vg��@E_rMHg5�΃TqLL�qgӜ�����ͦQ��_�� �@��cL���_��;�m�	U>0�a�B�}o�Hm�,��Z�\��R�f���?:�;M�[�A�ڧ�G�T��J��,:C�A�7�=��k;O���_���ځ֓��P�sm"r_m�      �   @   x�3�v�twt��sWv
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
νg[��;���ދ=n�;�5��ˑŨj��y��]���.�>/������x���=O�YZ���fi�ϋ�7���d���>/�>�����Eמ������՞�g(���'>��Q��3r��?�,mH�yƱb��-<��f�C+�Yڰ�7�4<�B{��a�6�y���k����,m��"�ǎ͝G^1|� �GR            x������ � �            x������ � �            x�ŝ˒�6���UOQ/P'��L\��鉞����7�Y�L�)�A]�D������?��[�y�7>���N�2_��_���0~����2�0��
C�ӟ������{����w���?���7��/�g�n���t._��C��6��S-�&����������3'���r28�/��S�r*8�/G�/�� � �b��>}R��3(;� �һ }�*�UxY�-��
� [t��A��+ (�lQ�@
e�-��
ʠ+eP�����n��ӧAP�� (��� (�Zg�A�3ʠi���1ʠ�3ʠ�/(�`c�����`�s��O�r�����-���C�(�� �Q�� �Q�� �QL�A���;�`G�ta���/�`���`��	�{R��A�`w�/}|��VVˣ�9J��kN�I>������1կ�P������?ƿrBG�+m3�]C�����#��VI؂����Z���?�y�>����~��
� ��G:ܳ�=�O�ˇ���P_~�~s��:%��{��ׂ��@�
��D�%)����!���� 8f�@r�x���X�w�������S ��8X�-�m 8V�ޑc��f��O��[N���0�l �0md����OW�j�;2ܑI_�uH�kߟ�!A;� An�A� �� H��� H��� H��� �o1�@	Z��h�K4����
��9}�͗7���X��?�Ro��?gGP��9]\�6��l���E��\�a�݊�����'����7�����:�v���N����-���������3�+7��?N�鲛���V\o���i�1�S��v��v�;`����x: �nյ/� �eWe/x|˾�^�;ߴ��q)i�RuQ��S���6VE�c���_��P8��P�6�E�C����k�a48�������P��%�}��޲��� �ő�]���F�.�-N�>hl�������Y��FXF
��L��BB#,�&����\�t�]��F������n`-�=h]V��e4v<kY��\����5vk)tt��ѳ�Vk��h���JGg�#]�6:�R���f���������g�j�ɘ4�_�:h8�WkN��Պ���p��֛4��f�)�����Nh8��Z���3����[�$���p��tQj�d���P�&w���ڈ�W� �oD� 86.% �ޡ�p�J: ��ë�{�W�8�#W�8*t�j��w$3ղ�[/����~�^�Q_��(��4=��<��a�ʣ"^��s	˔r�_��e�P��-\������ks�ry�ϗ���r��/q*�<��e'xR�mI���Sy���;%q*��i�ǿr��?K�?,�n�[ɺ!�JL���`J����W[�SVw�tC`�j/D�ՔPq<�����b�9���.vw��-���L��tw�j��wF��P j7ļ/�8r�#�p �"�!`zj�0=�n���N����,>H��� EZvv��峑s["��2�b|6*��2��b�v��b����j��(Ih��,6�ڸ6�]�k5��е6�MJk�е�|6t�F>���Yl�Zu>�V�][Ƿ9l�Z-|6t�V:[�K�r��\笴`�Q���/o��"-Mt$��-���N�A���#.R+�eCu�6)�<8v��z�6-�n�Ŋ��p��;�~ <��g���x�������M�&��h��k��!H�0ŀ1��l�uA"�J�0���ʤb��F&{���?U��H�`��ʇ#mIe=s�ޭ�S�����1mK< �i[� 8�m����% Ǵ-� 8�m)�!2R�p�L���P��,L���|��k2�yp(\��σC��~
�����P�&ß�µ9�48�����pm�?�6��f�����,H�r�v��p�L�����!21 ���| "�p�L�|8ZW���[�LX��B��ֱj� 8D�� 8D�� 8D��p����+�!2V�p�����X��*�_�����=%�� 8��p(��p(��p(���P8���p^�C����1�) OH�h2�H9h����Fg�۔鸴��w���늻�����ka�uF�QQ:YGm�6	�n3�Ih�uq:� ��hW�d� �L���?F�Ԥ��e'V
�1#;����4~�����N�Yȼ=v�#��6::�tt:���LFG�lz��t�
t��#�����m�m璼���wF��@G�W����t44\#o;���pu:�����kf��[�Z�h�Yq?}K󅽼����=҈��:��]G$�x:B�����HGCH�����t4�4&:B3������ؖ���AC��s�Ih��m)��5�-u����f���z4Ԭ=����ٖ��]�Țq�R{��՞�Z?��+2|����!)�h�u{.	�v��a��h�u{�,	�v'�=���0���ѵ��0hD׮�`�]�:��Ft��0ѵ��0hD׮�`�]���F/ ����h#����iiC��!���Z��Z���|-JGc��HGc���1_����U�DGcWA2���-]������{����k�l4��O�5�r�j��x�{:������HGCÓ�����t4$%%:��2��aO���G�t\����}�P���$�}�P���$�}�P���(�}а��P�}а��P�}а���]�Ȩ����}а뼶k[�w�9��.���]��a�E�hx)%���R���P��t4Ԭ$:jV2������0'�����RIi��YhHJU:�R#Ii;�А��t4$�&:�R3��x�����Օ���n�Y�RttZ�hZ�h:��	h��3�NG�]��d���%�BG�k5���}�P3	t4�L�������P3�t4�L����ɖ�jwA�Z
�^wU�r�|�	�^�T��a�*t4�Z���]k��a�m/U
:�_����j�ti�?մ��`����*u����6eS�?w�i��h����hT�%-t4D5�U��WD�Pە���ըt4D5F:����q��F��)�BG�Y�+g�.���a׶��>hصm9`c4�ڶ��vm[���6���*ؖ�5�A�U�-�j샆�ٖC5vA��*5V2%X���e'4$�Iq��!)�t4$�#Ii
�XhH�;I�DGCR<��hA�|%)�����IIBGCR��ѐ��hHJ2:�������DGCRRf��?�R���f���8588��t�	5ˁ���e���fY�h�Y�t4�,5��F#8�BGîsc�:��m�e'4�:v]���]��a�%��h��J�����9$K�~�Ttc�)MU�h�fU�h�f5�ј>���HSO����q�v��]����7c�q�C�/Άm¬�!ip|�0k�q�HŞ�5$NÈy�a�4��X&��xbm�Q?d�)d�oޒ��!!���ॸ�S]�J�a��a|=웊���j�0P!�r~����&�����wE}�5������T�.Mxj"�I�5��	K��{�`y��x�
��é��5��5��R�w�fGKDV>������~o�l�8��d�����)�5��H��m�Ezv-�:ځ::�tt:��h��+��F#�61PZm����6/�n��}�P3+t4Ԭ�oIBC�<��P���%	5s���f�h��5sg��]��=��r�������P"�!)M�������HhHJ۾������HhHJ۾������HhHJ۾��F�gm�7��P��V���{�fH�����P�T�h�Yt4�,5�JGC�r���f��h�Yv6{�5':j�Wj�vA��}А�\�hHJ	t4$�I)JGCRJ$�!˫��a�4��ZOa�׃PS�#�ۭ#N�^$�z��t�8e�֜�%��������5���L�Gl��N>%t�6��ɡIl��}�|�	�6]�R]1��&�>4�|�A����˻��I���W�3=��;��2����)�ɯ�b��� e	  ^��3s��s���f;9��_`=�4�x���yx�vC9�3Ð8U��0|W�!��ȻȼL:]���8�ۏ��"�6rns�0�/�)->�F?N�e�ߧ�2��0Z�#I���������l��r�{Ms��Q�!���R�n��tC8�q������n���Ḇ`	��3v�j��П ���X7�Y�ȟ���9�:"j7�lz�C7�!��vC$ b7Dº!
����1�i�o�rN�������{u��	ah��j%{�ح	m�2_���/����Yƣ�+��kv�-z�6�HbJ�$�D�V�r���Np,b���^�.p�ƍ�ږ��v�m��}����7���uu�1���e�}h�Ym�1sІ㼒�jg� p�@*��R��h�Vۣ�"#�H���,4�����{��{�	�	��
��}%�G��p��c.�~ sYL�aj��ሞ���<��iD+��e78�-	��a���������� v��wipD:�� � ^�C�����%48�P84�?@��JJ� �C3)����P84�?@��RJ� �CS)�m��P84��t��a�O�*��ك�f�$= �K� 8.�p�LJ�!2) �Ȥr "�*�.W��p�L^G-�>�a/8D&o9Dh/8D&o9Fh/8D&�p�LN�!2y�A#{�!2y�IF{�!2���-��3��w�����"���CKy�W�j�ĉ':��g'�����|v����JgcJ9���ȫ��K�'w�`BY�l��5z,6�%;�mɉφ���gC[r᳡-��ن��ׇ� �t�k^��J�^���E��:C)`�d��.6�K�|V?���� Ż�����~�"��&��ZyT�+ZND��*L���ۨ~���Q#��I5P�IuP�IM�&&5��֦�PkK�S!��a���6?E-�&��Z�T�6I`R�M"L*�I�I�6IdR�MbL*�I�I�6IbR�M��&�e��A�[�w?����+_��u���B��R���P\.4J�˅J�r��)�\.�J�˅V�s�P+M��˒sZ��u��~�{�$]�Tg�t��:�6i�;!�W����s;�4���2��e��o2T����}��<]����P�K7���`��T���	!x���J)�$����e�tv�R&��		N�����-� 8B���#��pčK: ��is:�YGj8 S��S�倂�FR#n�fO�Y�p
Đ�]+��p	��!�3�vl��pU�'��U�˞t\0�@��nt\����MY��t\0���g���>�((�g"�g��Fw��lt��*$2:Ehf^���2���4B3�tC�N�vC�s솀�e놀}e��ax��e��+y�QE�!�F���7�]8������|=y̺x̺r��G���t��%�������g��Y!R��XS��hʤ�u�E&�͘T44gR�s���s7��:|����l��	��}S�xY}��]Dǁ 1���a���t �]�gK��?Y�74ISHA��v���j�DyW�>~!��G�2�Ǒ�~�k/�m�êNo&���M��H,C�s �/�	l)��KƟ�f���izInr��)���be����6��%O�*���<0�x�\�TL��L*&R�L*�4w&S�'&N��c�z*��d�*�-��L&�tȕ��R�{|�|y}�V���79���C��0��+�Dj�\���B��0����L*�*E&&��I�H&gR!�)Ѩh��q���|	�t�tXB�a�=�~z��vN{�bj��;ok`���
Ｍ�M�3��kdyHr��|\��ۇt��~�o�b@�S�1!�Ҙ��^����,<&<+�	��q�Φ���'���H�t��B�
ɧy�l�Ӣ���4����Z�a`�j����(�a�a��	`�?�fi:�fr��KO�v��a`>;ay�/��a�0>����R=z("�Ym*��롤�V֡��&/���������tC o��n� k�@ĨJ7"FU�!1���j�p�wC�A��K°�
_��0��wg��C��-:�_��0�׼-'�O���qq��z;=̈�����͖`z;Rsq�C�tpN�l�W���c_t�u����.�P{��剄nh�h74Mb'�ڴ�q>h1Η7�5a�v�������Ӧ���SN��׃����=���J����6#D'��)�ԧ�/�e�w��i
�߮�N��/Xt�1a��yLX{I4f�K��cf���i%=~��=��[W��ӡ�nO.�c�]�/���aLq��(ק��V�#Ov��<�p�J�0�ɆwF�����3Øj`�w������0�0�4xE7#��}a��ׯ����Qez     