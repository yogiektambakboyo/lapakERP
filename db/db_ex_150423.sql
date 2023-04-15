PGDMP     7    1                {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �              0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                        0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            !           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            "           1262    17913    ex_template    DATABASE     s   CREATE DATABASE ex_template WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE ex_template;
                postgres    false                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            #           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
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
       public          postgres    false    202    6            $           0    0    branch_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.branch_id_seq OWNED BY public.branch.id;
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
       public          postgres    false    6    204            %           0    0    branch_room_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.branch_room_id_seq OWNED BY public.branch_room.id;
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
       public          postgres    false    6    293            &           0    0    branch_shift_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.branch_shift_id_seq OWNED BY public.branch_shift.id;
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
       public          postgres    false    6    305            '           0    0    calendar_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.calendar_id_seq OWNED BY public.calendar.id;
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
       public          postgres    false    6    206            (           0    0    company_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.company_id_seq OWNED BY public.company.id;
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
       public          postgres    false    6    208            )           0    0    customers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;
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
       public          postgres    false    303    6            *           0    0    customers_registration_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.customers_registration_id_seq OWNED BY public.customers_registration.id;
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
       public          postgres    false    309    6            +           0    0    customers_segment_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.customers_segment_id_seq OWNED BY public.customers_segment.id;
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
       public          postgres    false    210    6            ,           0    0    department_id_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.department_id_seq OWNED BY public.departments.id;
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
       public          postgres    false    6    212            -           0    0    failed_jobs_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;
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
       public          postgres    false    6    215            .           0    0    invoice_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.invoice_master_id_seq OWNED BY public.invoice_master.id;
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
       public          postgres    false    6    217            /           0    0    job_title_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.job_title_id_seq OWNED BY public.job_title.id;
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
       public          postgres    false    6    219            0           0    0    migrations_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;
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
       public          postgres    false    224    6            1           0    0    order_master_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.order_master_id_seq OWNED BY public.order_master.id;
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
       public          postgres    false    6    228            2           0    0    period_price_sell_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.period_price_sell_id_seq OWNED BY public.period_price_sell.id;
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
       public          postgres    false    231    6            3           0    0    permissions_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;
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
       public          postgres    false    6    233            4           0    0    personal_access_tokens_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;
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
       public          postgres    false    6    314            5           0    0    petty_cash_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.petty_cash_detail_id_seq OWNED BY public.petty_cash_detail.id;
          public          postgres    false    313            7           1259    30742    petty_cash_id_seq    SEQUENCE     z   CREATE SEQUENCE public.petty_cash_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.petty_cash_id_seq;
       public          postgres    false    6    312            6           0    0    petty_cash_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.petty_cash_id_seq OWNED BY public.petty_cash.id;
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
       public          postgres    false    236    6            7           0    0    posts_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;
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
       public          postgres    false    6    238            8           0    0    price_adjustment_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.price_adjustment_id_seq OWNED BY public.price_adjustment.id;
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
       public          postgres    false    6    240            9           0    0    product_brand_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.product_brand_id_seq OWNED BY public.product_brand.id;
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
       public          postgres    false    242    6            :           0    0    product_category_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;
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
       public         heap    postgres    false    6            ;           0    0    COLUMN product_sku.type_id    COMMENT     G   COMMENT ON COLUMN public.product_sku.type_id IS '''Product/Service''';
          public          postgres    false    250            �            1259    18176    product_sku_id_seq    SEQUENCE     {   CREATE SEQUENCE public.product_sku_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.product_sku_id_seq;
       public          postgres    false    250    6            <           0    0    product_sku_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.product_sku_id_seq OWNED BY public.product_sku.id;
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
       public          postgres    false    253    6            =           0    0    product_stock_detail_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.product_stock_detail_id_seq OWNED BY public.product_stock_detail.id;
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
       public          postgres    false    255    6            >           0    0    product_type_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.product_type_id_seq OWNED BY public.product_type.id;
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
       public          postgres    false    6    258            ?           0    0    product_uom_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.product_uom_id_seq OWNED BY public.uom.id;
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
       public          postgres    false    261    6            @           0    0    purchase_master_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.purchase_master_id_seq OWNED BY public.purchase_master.id;
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
       public          postgres    false    6    264            A           0    0    receive_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;
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
       public          postgres    false    267    6            B           0    0    return_sell_master_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;
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
       public          postgres    false    6    270            C           0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
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
       public          postgres    false    6    297            D           0    0    sales_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;
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
       public          postgres    false    301    6            E           0    0    sales_trip_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;
          public          postgres    false    300            *           1259    18748    sales_trip_id_seq    SEQUENCE     z   CREATE SEQUENCE public.sales_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.sales_trip_id_seq;
       public          postgres    false    299    6            F           0    0    sales_trip_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;
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
       public          postgres    false    307    6            G           0    0    sales_visit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;
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
       public         heap    postgres    false    6            H           0    0 &   COLUMN setting_document_counter.period    COMMENT     U   COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';
          public          postgres    false    272                       1259    18330    setting_document_counter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.setting_document_counter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.setting_document_counter_id_seq;
       public          postgres    false    6    272            I           0    0    setting_document_counter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;
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
       public          postgres    false    275    6            J           0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
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
       public          postgres    false    317    6            K           0    0    stock_log_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.stock_log_id_seq OWNED BY public.stock_log.id;
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
       public          postgres    false    6    278            L           0    0    suppliers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;
          public          postgres    false    279            &           1259    18725    sv_login_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sv_login_session_id_seq;
       public          postgres    false    295    6            M           0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
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
       public          postgres    false    282    6            N           0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
          public          postgres    false    283                       1259    18384    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    6    280            O           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
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
       public          postgres    false    285    6            P           0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
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
       public          postgres    false    6    287            Q           0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
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
       public          postgres    false    6    290            R           0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
          public          postgres    false    291            �           2604    18423 	   branch id    DEFAULT     f   ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);
 8   ALTER TABLE public.branch ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    202            �           2604    18424    branch_room id    DEFAULT     p   ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);
 =   ALTER TABLE public.branch_room ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    205    204            K           2604    18723    branch_shift id    DEFAULT     r   ALTER TABLE ONLY public.branch_shift ALTER COLUMN id SET DEFAULT nextval('public.branch_shift_id_seq'::regclass);
 >   ALTER TABLE public.branch_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    292    293    293            ]           2604    26922    calendar id    DEFAULT     j   ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);
 :   ALTER TABLE public.calendar ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    305    304    305            �           2604    18425 
   company id    DEFAULT     h   ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);
 9   ALTER TABLE public.company ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    207    206            �           2604    18426    customers id    DEFAULT     l   ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);
 ;   ALTER TABLE public.customers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    208            Y           2604    18777    customers_registration id    DEFAULT     �   ALTER TABLE ONLY public.customers_registration ALTER COLUMN id SET DEFAULT nextval('public.customers_registration_id_seq'::regclass);
 H   ALTER TABLE public.customers_registration ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    302    303    303            `           2604    28176    customers_segment id    DEFAULT     |   ALTER TABLE ONLY public.customers_segment ALTER COLUMN id SET DEFAULT nextval('public.customers_segment_id_seq'::regclass);
 C   ALTER TABLE public.customers_segment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    309    308    309            �           2604    18427    departments id    DEFAULT     o   ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);
 =   ALTER TABLE public.departments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    210            �           2604    18428    failed_jobs id    DEFAULT     p   ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);
 =   ALTER TABLE public.failed_jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    212            �           2604    18429    invoice_master id    DEFAULT     v   ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);
 @   ALTER TABLE public.invoice_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215            �           2604    18430    job_title id    DEFAULT     l   ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);
 ;   ALTER TABLE public.job_title ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217            M           2604    18730    login_session id    DEFAULT     w   ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);
 ?   ALTER TABLE public.login_session ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    294    295    295            �           2604    18431    migrations id    DEFAULT     n   ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);
 <   ALTER TABLE public.migrations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219            �           2604    18432    order_master id    DEFAULT     r   ALTER TABLE ONLY public.order_master ALTER COLUMN id SET DEFAULT nextval('public.order_master_id_seq'::regclass);
 >   ALTER TABLE public.order_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    225    224            �           2604    18433    period_price_sell id    DEFAULT     |   ALTER TABLE ONLY public.period_price_sell ALTER COLUMN id SET DEFAULT nextval('public.period_price_sell_id_seq'::regclass);
 C   ALTER TABLE public.period_price_sell ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    228            �           2604    18434    permissions id    DEFAULT     p   ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);
 =   ALTER TABLE public.permissions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    232    231            �           2604    18435    personal_access_tokens id    DEFAULT     �   ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);
 H   ALTER TABLE public.personal_access_tokens ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    234    233            f           2604    30747    petty_cash id    DEFAULT     n   ALTER TABLE ONLY public.petty_cash ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_id_seq'::regclass);
 <   ALTER TABLE public.petty_cash ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    311    312    312            i           2604    30762    petty_cash_detail id    DEFAULT     |   ALTER TABLE ONLY public.petty_cash_detail ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_detail_id_seq'::regclass);
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
       public          postgres    false    256    255            �           2604    18443    purchase_master id    DEFAULT     x   ALTER TABLE ONLY public.purchase_master ALTER COLUMN id SET DEFAULT nextval('public.purchase_master_id_seq'::regclass);
 A   ALTER TABLE public.purchase_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    262    261                       2604    18444    receive_master id    DEFAULT     v   ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);
 @   ALTER TABLE public.receive_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    265    264            #           2604    18445    return_sell_master id    DEFAULT     ~   ALTER TABLE ONLY public.return_sell_master ALTER COLUMN id SET DEFAULT nextval('public.return_sell_master_id_seq'::regclass);
 D   ALTER TABLE public.return_sell_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    268    267            /           2604    18446    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    271    270            O           2604    18739    sales id    DEFAULT     d   ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);
 7   ALTER TABLE public.sales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    296    297    297            Q           2604    18753    sales_trip id    DEFAULT     n   ALTER TABLE ONLY public.sales_trip ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_id_seq'::regclass);
 <   ALTER TABLE public.sales_trip ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    299    298    299            W           2604    18765    sales_trip_detail id    DEFAULT     |   ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);
 C   ALTER TABLE public.sales_trip_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    301    300    301            ^           2604    27183    sales_visit id    DEFAULT     p   ALTER TABLE ONLY public.sales_visit ALTER COLUMN id SET DEFAULT nextval('public.sales_visit_id_seq'::regclass);
 =   ALTER TABLE public.sales_visit ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    307    306    307            0           2604    18447    setting_document_counter id    DEFAULT     �   ALTER TABLE ONLY public.setting_document_counter ALTER COLUMN id SET DEFAULT nextval('public.setting_document_counter_id_seq'::regclass);
 J   ALTER TABLE public.setting_document_counter ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    273    272            4           2604    18448    shift id    DEFAULT     d   ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);
 7   ALTER TABLE public.shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    277    275            o           2604    33396    stock_log id    DEFAULT     l   ALTER TABLE ONLY public.stock_log ALTER COLUMN id SET DEFAULT nextval('public.stock_log_id_seq'::regclass);
 ;   ALTER TABLE public.stock_log ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    316    317    317            9           2604    18449    suppliers id    DEFAULT     l   ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);
 ;   ALTER TABLE public.suppliers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    279    278            �           2604    18450    uom id    DEFAULT     h   ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);
 5   ALTER TABLE public.uom ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    259    258            ;           2604    18451    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    284    280            ?           2604    18452    users_experience id    DEFAULT     z   ALTER TABLE ONLY public.users_experience ALTER COLUMN id SET DEFAULT nextval('public.users_experience_id_seq'::regclass);
 B   ALTER TABLE public.users_experience ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    283    282            A           2604    18453    users_mutation id    DEFAULT     v   ALTER TABLE ONLY public.users_mutation ALTER COLUMN id SET DEFAULT nextval('public.users_mutation_id_seq'::regclass);
 @   ALTER TABLE public.users_mutation ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    286    285            D           2604    18454    users_shift id    DEFAULT     p   ALTER TABLE ONLY public.users_shift ALTER COLUMN id SET DEFAULT nextval('public.users_shift_id_seq'::regclass);
 =   ALTER TABLE public.users_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    288    287            G           2604    18455 
   voucher id    DEFAULT     h   ALTER TABLE ONLY public.voucher ALTER COLUMN id SET DEFAULT nextval('public.voucher_id_seq'::regclass);
 9   ALTER TABLE public.voucher ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    291    290            �          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    202   �[      �          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    204   d\                0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   �]                0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   ^      �          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    206   �s      �          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    208   �t                0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    303   7�                0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    309   T�      �          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    210   q�      �          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    212   ��      �          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at) FROM stdin;
    public          postgres    false    214   �                0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    315   ��      �          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    215   c�      �          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    217   &b                0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    295   �b      �          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    219   �b      �          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    221   �g      �          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    222   �g      �          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    223   �h      �          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    224   �h      �          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    226   �h      �          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    227   �h      �          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    228   j      �          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    230   R�      �          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    231   ��      �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    233   {�                0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    312   ��                0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    314   Q�      �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    235   ��      �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    236   ��      �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    238   �      �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    240   <�      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    242   �      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    244   ��      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    245   ��      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    246   u�      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    247   �      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   C�      �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    249   ��                0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    310   ��      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    250   ��      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    252   E      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    253   �      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    255   F      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    257   �      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    260   7      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    261   �      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    263   �      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    264   >       �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    266   �       �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    267   �       �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    269   �       �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    270   T)                0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    297    *      
          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    299   *                0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    301   :*                0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    307   W*      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    272   t*      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    274   c,      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    275   �,      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   4-                0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    317   �-      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    278   �j      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    258   Kk      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    280   �l      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    281   u      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   [v      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    285   xv      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    287   �w                 0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    289   x                0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    290   "x      S           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    203            T           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    205            U           0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    292            V           0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    304            W           0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    207            X           0    0    customers_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.customers_id_seq', 775, true);
          public          postgres    false    209            Y           0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    302            Z           0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    308            [           0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    211            \           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    213            ]           0    0    invoice_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.invoice_master_id_seq', 984, true);
          public          postgres    false    216            ^           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    218            _           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    220            `           0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    225            a           0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2209, true);
          public          postgres    false    229            b           0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 514, true);
          public          postgres    false    232            c           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    234            d           0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 297, true);
          public          postgres    false    313            e           0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 30, true);
          public          postgres    false    311            f           0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    237            g           0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    239            h           0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 22, true);
          public          postgres    false    241            i           0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 52, true);
          public          postgres    false    243            j           0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 329, true);
          public          postgres    false    251            k           0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 25, true);
          public          postgres    false    254            l           0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    256            m           0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 54, true);
          public          postgres    false    259            n           0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 21, true);
          public          postgres    false    262            o           0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 32, true);
          public          postgres    false    265            p           0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    268            q           0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 13, true);
          public          postgres    false    271            r           0    0    sales_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sales_id_seq', 1, true);
          public          postgres    false    296            s           0    0    sales_trip_detail_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 21, true);
          public          postgres    false    300            t           0    0    sales_trip_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sales_trip_id_seq', 4, true);
          public          postgres    false    298            u           0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 1, false);
          public          postgres    false    306            v           0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 52, true);
          public          postgres    false    273            w           0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 12, true);
          public          postgres    false    277            x           0    0    stock_log_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stock_log_id_seq', 1192, true);
          public          postgres    false    316            y           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 5, true);
          public          postgres    false    279            z           0    0    sv_login_session_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 71, true);
          public          postgres    false    294            {           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    283            |           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 88, true);
          public          postgres    false    284            }           0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 71, true);
          public          postgres    false    286            ~           0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    288                       0    0    voucher_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.voucher_id_seq', 1196, true);
          public          postgres    false    291            r           2606    18459    branch branch_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_pk;
       public            postgres    false    202            v           2606    18461    branch_room branch_room_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_pk;
       public            postgres    false    204            t           2606    18463    branch branch_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_un;
       public            postgres    false    202                       2606    26927    calendar calendar_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.calendar DROP CONSTRAINT calendar_pk;
       public            postgres    false    305            x           2606    18465    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    206            z           2606    18467    customers customers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pk;
       public            postgres    false    208                        2606    18784 0   customers_registration customers_registration_pk 
   CONSTRAINT     n   ALTER TABLE ONLY public.customers_registration
    ADD CONSTRAINT customers_registration_pk PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.customers_registration DROP CONSTRAINT customers_registration_pk;
       public            postgres    false    303                       2606    28182 &   customers_segment customers_segment_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.customers_segment
    ADD CONSTRAINT customers_segment_pk PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.customers_segment DROP CONSTRAINT customers_segment_pk;
       public            postgres    false    309            |           2606    18469    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    212            ~           2606    18471 #   failed_jobs failed_jobs_uuid_unique 
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
       public            postgres    false    233                       2606    30771 &   petty_cash_detail petty_cash_detail_pk 
   CONSTRAINT     t   ALTER TABLE ONLY public.petty_cash_detail
    ADD CONSTRAINT petty_cash_detail_pk PRIMARY KEY (doc_no, product_id);
 P   ALTER TABLE ONLY public.petty_cash_detail DROP CONSTRAINT petty_cash_detail_pk;
       public            postgres    false    314    314            
           2606    30754    petty_cash petty_cash_pk 
   CONSTRAINT     V   ALTER TABLE ONLY public.petty_cash
    ADD CONSTRAINT petty_cash_pk PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.petty_cash DROP CONSTRAINT petty_cash_pk;
       public            postgres    false    312                       2606    30756    petty_cash petty_cash_un 
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
       public            postgres    false    248    248                       2606    30130 *   product_price_level product_price_level_pk 
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
       public            postgres    false    297            �           2606    18771 &   sales_trip_detail sales_trip_detail_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.sales_trip_detail
    ADD CONSTRAINT sales_trip_detail_pk PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.sales_trip_detail DROP CONSTRAINT sales_trip_detail_pk;
       public            postgres    false    301            �           2606    18759    sales_trip sales_trip_pk 
   CONSTRAINT     V   ALTER TABLE ONLY public.sales_trip
    ADD CONSTRAINT sales_trip_pk PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.sales_trip DROP CONSTRAINT sales_trip_pk;
       public            postgres    false    299            �           2606    18747    sales sales_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_un UNIQUE (username);
 8   ALTER TABLE ONLY public.sales DROP CONSTRAINT sales_un;
       public            postgres    false    297                       2606    27189    sales_visit sales_visit_pk 
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
       public            postgres    false    275    275                       2606    33402    stock_log stock_log_pk 
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
       public            postgres    false    233    233                       2606    18588    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    204    3442    202                       2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    214    3460    215                       2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    280    215    3558                       2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    215    3450    208                       2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    231    221    3479                       2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    3544    222    270                       2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    223    3474    224                       2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    3558    224    280                       2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    224    3450    208                       2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    236    3558    280                       2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    244    250    3506                       2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    3442    244    202                       2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    280    244    3558                       2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    202    246    3442                       2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    250    246    3506                        2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    250    257    3506            !           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    3526    260    261            "           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    261    280    3558            #           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    3532    263    264            $           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    3558    264    280            %           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    266    3538    267            &           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    267    3558    280            '           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    3450    208    267            (           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    231    3479    269            )           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    3544    269    270            *           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    280    3558    289            �   �   x�m��
�0D�7_q?@%�jv�(>�Q���d�b���i�v���p�#����ő�j���{�ϗ��)|�� ��1/b.P�*+ϓ,���a7 ��@���]����\ݰ�Aj�i�LI�#�NO�b�-�8�v��d*�8�8
��?�A$�yp�Pp��T^������6      �   _  x�m�Qj�0����"�$�I����Z:];���1�-C�y��gɖ�;��t>���8���C�(ZJH%���TB�(+Ml��7�k{;l�S's���@ˣiJ�L��@�iΗ"�c�p3_��-UJr��f�%,��L��s4��(-ڐh��>.��d�1�'��w�P�Xxg�>.<��.�����Xeg�Y{N�8{�hϩ)���x����Bv�:��91�2iϼA������p�q:�����654�wo�lN��؛�j��g�W��x�A��L�����z�����A��Rǚ��r��AV�����C��x��P7�HJs�%������Z�#�         9   x�3�44�44���4202�50�54U04�24�2��!�e�e�U���0W� ���            x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      �   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      �      x����r�J��ת��T� ��RL��He���VZo����ʬ�{�/c6o?� :EG�s2���	~黛���v��:��>�������c�k�����X����ٴ���5�]���O���k����/�����Q�6�֘���y+j�����������T=��Ƈ�?�%Ļ kK�����c[�,���ݒa� �����C����_-j�!��p�^#�wMs笨!�vAg��!.�W7.���4���bxV< ��p����?(�n�A���o��^��t	�����
i�#j y�����W �;ӊ�o���=dã��Kì�Cs�9?��ۡ�0��r;�`�`?��y�����ٰtC�� XZ�������s�ζ�� �|{yW�~�-�4�����u{����g?ä!��6���U�x��{5����pu)�;kG{�� �?��_�F����C�5�h���[QC "�����l�6�F�~� ��w�J���IC���fw����, k�u�>l�
�0��QC���iͺm�F�S��YC�Ӷ�~x<��x�QC����¸u���yk�� hǍ��! �
﷯ë��7㢆�+|�|�z@�f\��!��v��5�^���@�e_�Dh��YC̚��<��B@�����:��^� w�ۼ�W��h�-��IC���p�����Gt6>-���6��!�w��}��K�̍�hDAh�]x��܏g��p�:�~���)�m������_ĆBN�������~���;E�d����4k���&=��ۍ�N�ki3D���~�WA�dv��2J��W�5 �orDw%˸;�����)�i�!�ۇTގ���M�v�`o>��W.j6��5g�IC�_�1N���3��!����k���y�l� �b�/>����0��\/jm�����]�YZs���.�p���L�����g<B:QCh�t��Wg��Z��F�I���a��M�6���Cl�`�=�O�Έ�B��o���mM?�ͅ���ɿ�>���wX!�B�a���_�gL��/���w]��K���m�4����t8U��е���A|�G��ss^k���0�y\�:;ڲ���GQC`�����i���왳���!}^*���-�J�Zc�7�lٍ/��!41_2��������`��C�u at�ݸH\wa��3��A,�Vq%L���C'��W���tf�D"pt�X���O߅.����Q�`<_��^���`eb�<�ϱK/�ъ��cӵM3nQ.��wa�HY�`ا���u��b_�7˭ۤA0��l��>��kb����*eA0�2ø�9�)X�h���yMB<MX��E����5������5���x��o׏���zQ��i�!�gI�A�4߿J����#���5�����Ǖ}/:JOї jK?-���7h�����uz�l.呈�`�M��x痯'k_�|q�7ٲ�G^�� �y��y�/#���s�X�����������ϝ#k��p3�vۛ�����9�v���ǐ�w7l���-]��K,ۥԢ�	�^� ���M�f�:���6m�no���p{���y������i�x{��~�K���N��g>�F���˕Tj��_wÎ"����u�q>�g'�P���ժ5�$oC_�����t��[�A�\�%(�wk!pt��K!��9�cςt�|,��!����"�Wj���d���8��R�8�o_����$��3��G3�hϐX��h�z܌�w�q�]n�Ai������*5��"���AX�@�2,UjH�ǎk��]�D�+�����P���V�ˤ4ܥ�e��˼�_bߕ��RC8<����~����wa�M��ӰM7*�6���A(�/�( 4��d=��Q���W}~z�k�B�RZQ�8����z�������?�HR��ҙ�D��߿���+oaJiW��#jH�@��o��簟Y|�q�7�߷��������o:�BCފD�������oZ�+jȸ�\�{�Y�@L�����ϣ#�)tX��DB��GBP��侼/#Jq�����X�(����(���6]�h1��Z'j�S_��n?DVC�Y�PkI
��?�]�T��A�O�QM���U�B�8z�x�s��挃4��b)N��	���.�a��Z��4���6�9]�A\�)4�����蟈/oJq��h��l�+�K�[+�S� ��Ai��͹�M��y�� �?N����4�R�@ȣRꃒÛ��5����Џ�㿿p�cS��� �t�T�l�ٖ���pt|�+9��H�H;������� ?���Q�0� i���A |���Pc��ʻ� �l��?��L�(5��v��8�ݰ5��"����C��|�?k�єs�����sW>k�P-B��ׅ!D�j�)�^K!�"%-AX�f"���|y�����N�5������uF�fҧ���8:?��'�Y��?|�j���t]Q��E~�<�+����1TU|�k���y������ �8��@�Atv���eL6��Y� :�kf���yB�5�����߮�W�6���Z�8�o�N��ᗚ$��T�F��^?�NF]Q_k���p�fZ� ]k���a�+c�5�5�\������HR�@5����Bi����g�� �n.�Qr�"�QkG����p�ע�q�{{�Gץ4doE�\ uؾ�9L�|q'�0�9�r}Lđ�o����fX�/�ۆ<�ax?���[)��������ĸ�Lr�PY�@ȥ~/������Q"�s�k""��ms�ne�9~���I�8:N[�:Q�8x��>G��+Q�A�_=��t�qy��4��4s�G�H�]z�I�P(J�(Q� ڳ>��\�V�SӶ�g��<.k���<���A�ҟۇ��/��^LBEbӉ��Z��^�݋������z��с�1�1t\���X�d͛Ϛ�Z�ȇ*	��" �9SG/E8_�!�|�F�J����`�<�ò-���gNm�A��f_�g{vy��4����n��B�P�����Ů8BJ���m�jB�<�
�}�%��Юy
ᳶ�� �ϧ��d>K�k" ���aW,�.��!��]���YC����i�|tV� �V��(�r�qX�j^O��l�ƗA� �\O�:+��&şqX���::���jreg�����B�s�ړj9��T�Z�8谞z�����a�A �C�=qY�%V���3]�r�L�Jd�eL�g���3�Mum������;�=��I�n[.Y� ù�k0�5�����\�ɨ/�Dj���VsisC���^hy���Q����-� �ϧ��[&���kI��{����MӤ�%������hy~���������l�4i	y���V�LQ��t�Z�8"'i7k���SkG����q�_>� ���9�]�^'�����nPE�m����A$N[�<�l��A�a����Q�&�ފ������2�6���A m~oV�X'j�����z��d4].-AX�@r#����<�Q��d\k�^7{Mf�L���a��H�ǧ���j�wa�,=	kI�o�~l�����/�˛U�l3����ȤA�YWqt�=��A~N;�*veSග,Zk���Wb�d���P��A\���U���Zw4��o��?7��_�I��w��^4q�/�4����m_��D�r_�.b^��ɚ_D�f"�|�#0�J�(4��4 Tt j��w��	����Z��
���8k�u���r�������Ɇ�5W%DD�q��
!T��!�s��u�B�A�'��@Q���j�*Ah�	X�>/�����5�����5 �6�E����+�%GH����Y�Z��@��Aa��V��}����d7}ebi������HsQ� �9�7uB�5�3�:����YAZkO�    i�%��s@�A4�����@�ћw~���j7UhLl�H)I�u&�>.�����k�Dd�v��{����]`	UM�A,����S�����,7��<� ��ӛ6�+�mdo<o�-� �<�髪��Z�
"�q͇��Cgs�ʱ+4��d�B�ȯnT��rm�g{�Z�0��A�9�#y�A�f�=&��5 �qUx^҉�˒~�X�dt�4�����2nϖi��yX�r�B� </�gM=����Aaj����b����-4�'ݝTWCl����qP`s%�mD��7C����.2)4$r�ʝ�3�dv<�� j
�#�����QW��bV��N6�+k��ɸ���"�B�0�<7L�@|�+4��sm�J�|Y�H��=�d4mG���5���^�s�6���?kG��n�ʍH�3�Ux�� ���a���7[��-b�A�W��{UR�˙���:i*���t��@z0D�`)�T��1�o�eK+I�<�B�H8�ZG���bӅv9Qd4말T#j�/��W�]���SU�Aa�lZ�9��wڇ����u(�� ����A���:�D��i�<�q}�>��&"�^� �~�	<�F$׏�s���i�!���v�����)�4Ի�@��BC���Iljl�k�弭�xj�E"�{���l0ބ>\@
�'�� $����Fcc,4�#�׮3���ނ�A�s���Хn@2L[�J�	s��돣����� ��)ǹ����B�8}��$�k��Ν_Lx��5ՍV�AH}.r����U_m'"�$��$]u\h	tڈWY8��;=k���b�۴���	J��Tg�B��ؽ�o�Vs:e�~���5������ܜ�!�̤��F� �+Pt��M����j���Pc��A�� 9h�d3�\\�*�A�[woU����F� J�zN�����ĩ{DB���~�6�kmh��G�<���,4�(49�S�h��$��Nm7d�X5�(4������ᬥ
�ܢ5��[�_8}���A8Ň�sSv�+4�7����V��� &N%��|�Z�b0ў'儜�R6B(4������S]���B�@8�0��S!Km��A��T_��]��b�@�:����(4��������%
k��!(\7EC"�:�d���B�8�U�v4P%N{wA�8ln�1u�B�@\΄~���є�/kE�v��(�>'����;�o+8�f\�q�|u��|i�AaQ/4�\��C�# �hqA�@z�U�{������#M6�'��6cu(-4����&+8l��f��a�~i�~L!O�F� ��n�Wp��'w� ��9���ƬA����9�s`�,�B�8ا�:ی6��n,��q��`
��U�r�Ay���"��6M� �~���V�5}kZ��1�����y؉�4M�������	Wad=ԥZ������P-�F� (�oU����U��� K iJ��˰����p�*����sn�l�B�0x�ԣf?M&�'؊���Tw��f��w��x�ַ+�F���f���B�8(i�~x��*j��=�]���p�V�ä@q=�� �S��is�:4��p���Awe����,4���6�^Hm�1��A Xb�*�Vh��������6n�qp��pR�����Aa��P�ܱY[�
Bio~�)�u�`��� �����O[������\h�o�sd��jVM�A�'m�T]Y��Tb�\�� ����~�
	��Vh��]���k�e߮����z.Z�Aܺ��~sxW��*K�� ᷂���5�$pDm�il��ThI��+I	b}u�VhH�-Rցx;�{��R'��վ��DW��OV�5�Đo՞�S��[��f��l�uQ� ڬ~o��2�M��ThH�
p�n�YvX�3�����3�����kϳ�;yY��-4)wy�k��L�r�Xhy؏��v_�
��W��B� �&a�P>_��-4�����]�cd�}�,4$�U��$4��I�!$����N�ԉ��v��.�� ���RZhY��B5l������1U#��r���:�� �	���J�F�7�V��WI�쨧��^�� �vE�7��U�� v����Vx -�@r�.=���U�B�@b.;����!���b�����fͽQ�g���"�;F{7_`i擲Q_%�¾u;�4	.%�փ
"�e\��#6�/ɤA ~MZiG�J�rs4i�֭n�۴�Q�� �6�Ri��l����qt�2e���I�08ں}x��ؐ�P�**4���㛪������
�*���Q�R��B�@ح�#�K�B�H8�r��Ts�Fо/��6�j�.m#j�紟{UL����6�� ��귷��� j{���i]n:��A 9!K�%qjh"k��~��Z�5�"��0���/<�J�S�������U[k9ZQ�8,O�9��ߘY�@(+�.��*.��A�P7���AM��B�Hȣ��GMaj7�U�E�\�u �"P4kH��<�/�RY�8zn��W�%��&���BNu���&��b�:kF;�j.k�f��5���y(J�w[<�I�8���y��k&yu9������:���9k�_�|�B�@rՀ�+c��E��y�z����1U�*���&�Q� ޲�#T�΅qp��6D�Yfv�@XC8�<���y��n�e��an�e���F� ���ˎ짰i5���H��]h�/��iI�P�������昈��п*"CFSF�5��m�����>w�(G�B�ԟ[ՙ�mƪU�AQ]�r���5�d]h_v������������V�&�F�*��� ��ZG�^?������/o�D�B�@��o�Yw�.4�#�oU�u��B�@(�������� �.7��.���뽨A �V�"u��� ڮ>*{ٱQ�|w'��	 ʯ/��lZQ�H��J�駶��U�Db�����II�V� �U���$�q�� ���jsTEhت���"	��*��F�rG2iH˥{�h 6�U��B�@ػ�"	��H1i	'X�\�
SղDB��x��=�t˹����Ys�����{3i�����U��� �� `��]e�]!)4��������𚬦�V� v��/pGE+N� ������M������A$x9l�/�|^���d� ����in�z��� @�:'``�������ݠ�c����������F����.N��j� 
��t����đG���>���d� n��Þ=��Q0�[���!S�4�A]WVq�ŷn� �v5G=�� n���-�����7]R�"f�9�g�oD���Z��a�J'��������5Y=[��A$�&j��������U�c��(��
"�k:*OF�{�B�@x�����i��bCThG�Uo�$�U|�A$��NVl4T�:
��j�ր���B�@�Ԇ\��t�j��Y����2��$e�h�A$��u8|���S��A,
x�5$e����㬺���hy.4���Fu����9,1,��1p���i���n��������!��Z�b��A,�{�춚1_7�(jG��ڻN6�4�B�8Ƚ~?�2�ɨ�����V��w�/,C�����SV�Nf��3��N[��t�	�ꮒ�qL-�'�{���.�� �I5ڭ+�t��^@;��<=K�֤������������G�r���Ē��j.|�SM�5���w�+Q�5��뷷�~�&Iɣ��!$<;�a�C�j4�u�������WM�[�I�Hr�U-�L� j��{iA� p?urRs���F�Ay��7N̵��CŤA �^��*�'�{MӋĒC+�b:H�A �]u]�'�~�@,�c2��ӷ�5�[�&����7խ^���M5����۽���ë���v�A�L�������M��z0X�A �����*��z}�������i��At��㤪̟lZ�ܙ�ԏ���ry��N� �8��/Ln� �  F�f���RuӖ�.�t��p���v�ưqPA��\�%_��q���T�wq���4YQ� N�ZK❨A$9���#��Y�f��.�v'�.�ŕ��A\$�%�q�8&����ˀtt�36����SIMC���-\jA�n{5�|[KA���*���m��-5�`
�jrV�Ѫ�Z�A 6�����a���A�1�a�B��?�A;�>w�(��l�-/�K��� �aw�QЙ$Q��|Ӯ	�&�4��5�¦U�e�Y�A���>�0��۳QgE��=�F������! <�j%�q�q���V3<*Y5���5����ٛg��̦*5�$O���8Vg����,5�]�I�L$�l�l� �ܲ�Y�������F,5$'S�$	���g}9l��,�dզ���5��ϵ+Q�5�/�7��.��n)��m�伮w�%�l�7���)�k-K/j���ɉɨK���5����xx�4���j:����l�5�a��*�Ԝ��l��_����y����{6k��A(]�~��9��A���YjA�S߮���t��5����{:N\%0�A��C��pzU�e�p�A&w"�~� ��-�koP�o(��e�R�A|�U��Tx*kB�V����"�CJB�+����}'�#kA����*B��F����W���ՕХ��ŕN�A��[A�6��K��g���7Mvc�zU��
a��th�|�ɨkʡ���������*�(/�ą���M��l���B��{U��l�-S~J�`߹� �B����oߕ�L*�Z>�I�@�ni%�8��[�mU�I�U_�]"�P�nxL6��]� ��%�7᳆���b>tpmߛ����6�.ۂ�A@ty��9
DƵ�q1�>G$J31�D�AD 
e��R��@�U;�B����gl㺮}��6�2�� ��i�'��.ZӸ��c�U~�AD�ũ"�#�!�1v�I�<��B��:n��(<�8.4��J��h�U��KB�V���V7��!q-�鸑R���]0!�ǋL��.R
a�l�*nw��b���ȓ�hQ�x8��0(Z%��m[Q�8捱��:ӷ�o�DDM6�ؤAD�}%y!k�.��o�O��\��O5i��} ����D�z/����Mߌ�1�@i��A@����y֐�v|�c�E"G�₨AD�_�v�T�{���.�b�[���C�0�������}���5��cvR{��k?nfmۊ.:�/6E�� �A
�	�� $�]?�v[��5�]ߊ[�ЕI��A��~��:W3���u=z��&�{'j���'�E""����2�k:ڮ?�4���D�u	���������)��nDbjyy��9�#�M�ƈ O]�;Q�����Lw9i�~�a2�؜�A^{+wyJG���Z���@�(jR�%�?�m;�YcE�MM�]'j���6+tm?�>R�j����!q���Qҳ��q0�q8.}�8	�����㖿M���l5����er��AL�`*�j�h�_~:&�i/7�M������QO���AD�~�-"W�)5��o ĩI#��i��PL�kDB�s�~��5��k�a"�xrwF�ڎBD-���u_�P4���Ｘw�J����&��B���t�2~c]O����teE"�	�R�U�]�&F�$�J�����#�b4i6Zg���� }_����1_Z>6U/��1�91�Cv��Mo�������5����~�GQ���F�}�K��\iЉ��w��ㅈQ�x
h.0�:c���i��o#-k��� mdӹ�OP��ݦ��XUD4u�?���m�οi��:�m�AD䮿Q�˲�kF��pa�Xa��\�#�DB������{���	[��/�r��֦��@��`K�I��( ratP
��!u�l�6A� "
�l��u�rS[hO?�⼰�u�/�w#d~|��,�B��8�.zZ~YkC��7�Ŏ��}�o��&�U&�^6n��㺶�>2n�t�B����!5���zߜF�z�2�D"��ȻX7�4)�F��:/�Dn{x��
���О5��sK�G�n֎O0��e�j\d�AD�#"vV9Y��Z�J��n�6]_E�
� G}|�^5��.��?[5�5F�g<��J�\�_]�����7�ь;!���i�N� ��Ɯ]��4';���%҇a��4��sA�T���ֆ�h܇���B��8)�Y�*jRdϙ��h��7OD�x\��i;����X ��|_e�D��z�� 2�.�L����E��R�������W�ʫ�B��Z��W����P�^���{�xl�0��� �i��|2�ADy���t�Ww���Ĝ�,흍�ƍ�ca�6��e�Bd�A?���)s�i�N܈q��[Q���W�BCBϫ�#����B��l
)F��!o�l����A<���i��g���s	�@��Lc��x:ui|�@d(ͣ5��G��D8�E�l� �vM��d�.&��DB��Yl��<Ύ����s̈́�5���S�rͭ��B�^G"�FV�_>�K�6��]����VYCp,y�ob�m��齓~���O���GQ���G�7R�^�T^���8�{ԜI=%p����� �KpV�X+jH� �8ZQ�8(��1�U�r��|5��J�����_SmD�Ű�5<��%7�������eQ����XU��)b��B�!\v�S�h�9屘�Ujw�P�����+�B�08t��]&����Zjy���"���{Q� �-Q��� �l֟?� �)#Cu�'�!��5�6���/�J����5��l4Se��qŗ&N�srU�D���b�*l_hF\�1�`��IC0�,p�iI�M��<i�e����/?��ape��N3����:+j���U��B�@��� EU/��U�� ���������!P�)=���-4���U\�m��Ip� ��~�"�6%����A�#�iR��ٰ1�s�8)���{��O����WjQ��^�� t�v�Ld��m�
�z�����f�S��A��ݿk�$�6]�Ի�Y�@,O6��| ��E�p��i����FM5A�� .�T���f�r�
�����X�]�A��U��=P ��(4�����{�'������/4$��o�iE��.�N2�l��a��BCH��x:|�n�$h�צ� ЮG�EB!���9� W*|���B�$�u�{�AH�_��Vl���
!/�����G��/P��[�B�q��m���}�oD!?��5����)s8S5a.4�#r���^�%&��_��IC@xt�Z���^hHnE,}$ꭰ�e&�m{TC9��8Q�@x`�.�l�?BcD��j�7�/�>w�5��k,OjQd�Eae�,���ӟ�#��1            x������ � �            x������ � �      �   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      �      x������ � �      �      x�Ž�ܸ�=�ٹ���}~�4����=�x�5���*��@v�I�dS[�l�N�J-NS	����ۿ�X��C/������fQ��'��������}H�_����?.ˣU$�����������>�������^_>~����ǧ�_��??��|~����߿>����/-�A��C����_�Ϻ�ԣF�"�]Y����~��"[v� :Z��
�K��O��>�����ۗ���>����ᏇO��O��>��χ����`i�}A6rA�#D?*Obǂ����5=��_�ߟ���eߞ�<�J����i����1�>WV׿Yr�J+�JN�Xc�޾�[X"�X�,�B�����,��Y���<�1������������n��Ǯ�A m;�YE�����믧���?�Q���D� ��K�^�����b�q{P��ۧ��^��)���_�?�����׏�Ky�����P�����&�R �]FÛ���A�G�&1L���ן�ڼ}�Pؗ�'�Rk����f�P˃Z�nӒX�Z<}����(���pj���b˰�Wc���z,�V�`��������~��gA\<����ո��Q1��іX�P�4mj�>6D������2\n�&��q�v!�d�������g�ܿS�i|����k���:C�H\��|}ɗ]��$�v��߾o֑X��?���o���_��A� �W�~z�)������$7�g�Gm�'���|?��W���Ov�j%1����}����Z����/��{���Z?�+�����MrO�߿=��@P,��1�}ct�u0�]�'�	�x��s<�d��`�W$~�J�U-���3<��QY�������_��?|{�����s���$�[U4�\��Wg�ğ߿�D�H��e�3o1	����:����߾��;�������ȇ�60����ͼ��%���~��I,4G{������qtc!z��GH���(,�s�7qŦ�08�וf�,£R$v��w��_ ������$%��Q6#2ط�7ۣQ�ΐ�6��F�4*�����}�lV2g!�B`�WQr*��Th-��WkN��0a��������-�&~��w�e�^�5��)��o�$F�t��ҷ�i�e���ҠI!�߁z+�����yK+����秎��� t�&��\�@6k�,��k��۳�`n�������/ߞ�O���c��	�L9��D�.��@��q��'�匈n� "�1�o�<G���ΒX��7�	���@�!�\5�1�NC��;�.z�"6z�!R�����J�W��/�'�)A����^I�x,M�Ȱ�)C�ǞL���/	�`vk��$�&0�]0��g��K��/�h��ő�$��e�������$FXn��$�����v`���Zvȿ�[w�D��j��^�Jb��[���J�O(.�,�w�vG�)��z��f��\H���'��$Av�n��������u�k������Gv��?%R�YS_S���֪q�.��&P�t���[�Q���2]M��kwl5"��D���>���C�ÊI��V�����8�;��K���U{��8D݃i.�������i�r[�H)��n������n���W�9V���V�c�#�Kci��n��O��4���ח�/_���{����=:��,MCN+5��G:��U��>*� b�'�,�W����r�1)����-k����)�k�5�XFZ���s��B�1w�����(���� /"�ҵ*�[0��淗X�n���L%���%F%`[Pֱ��롮��ױ
GP���|�$v��_^��������C��O�X�]�}r�w���I��>Yv͂��$���0­$֬S�| �����{��`�Fb��q��E����a�.(J�#Ө|���O<}K�^	�yy�I�Qi�=�S.k�o#Tg�n)�%�<�g��t�th��I��)|�c����Dog,�4��:�9/�B����F�X���InQ<���-�_b=%��'�7���4N}a� o��5�Il��Xl+Yı0$v8`�����t�_t�(�t��:^9Ӱ��\�K��=�nu9��r�s�A�*;�K��Jb�$ڡ��#�q
�ڠ��s@��:Y�
�4æ��U,�j_��fF����,���U�GGǰ����{���V�$}%+���ݢ�ݓ�Xǣ��N���_�1���t��1�7P���=4a�/�c
;)�p��ݮaJL.�=�U8ǈmܨ"tͰV����w����!��CT$F<��UIMe�l�¹Ȱ��]�=0�+�)����XO�,����Y^ۦ1U^���+M!�
ɰ��K�_q{�Q${��03,����������y����yP���Q���d�O"b1jUJ��Aa��*Dl��V��	*��X�	�-UJ(�	ذ%�[n�� ��Ju�
8�$6`D\�� �;���+�"J��H����B_�U�e�c��0��L>(#��q�������_�y���׶u���me�ǝL���m)-x�h_ڢ��&��}�g)%TSǕ�E�R��`(؈��ʋN&6�$�����J�t��jͰ�ڂ�4������*2ic����y�6�-�%,$F�b���ݿ�5��`q��E��n��J
J�:&�xx��[���?i���Ss��lj�ux�Rt�����b�1�O/o����O_�޿�'���Z�W��<���T:l�G���h�X6j�+��6�A_סA��T���5
5���aS���K�6X'O�ibCL���n�N���� �V��^��A
�����Z��e��
b
����p�f��	�JcFx��������6V`ߘ&�7�g񿷢�"���Ibׯ3#������C�ē�%�S(���jTF�2sF�Wˆ��]��l{Kl��2UOsf����Τ{Ԇ�F���1��2A�m,�0�J��\7)�ў�r�1��c��:�:�c[mك �$6�������B�[E��>��Z)K�KF)&]�� y��EyA�t{g���ݺ�Jl��]Y����S�}�!��T��ڣEʉ�#*�-Ԛ���x9Ђ�v��R��)]�a�Ȧyk�K=h=
O�^������_��G8@.h�'�WY���ۋ���e?S���ӧO���x��?�����P6�޵*U6��<�uswپ���ſ>?��x~������s����9��hr��۞���-ph�*�@z��l���6��}��O� V��k\7�u/�KKA�)�P&���s��j ��c�a������D
fK$�Bu�jvH�F�!�y(q�axi�HBrlx���F��
+�pP+||c�Ư����^96[s�L���{� �؜���h��m��������b��޹ֳK���wiqQ��ͅ�KKҟ,�>=��d��Zbs��b�S
��z^��u���r);n�w����@��?�������6��,$���#��|��HܹW�&��Ť�68�S%�ZD�Q6u;�ˡ{]�:5�K䬜5t�A<D�?�:z�$��d�K�v�tk��?f�sTA%w��������n�XO6W�p�BY�!����ɱ���h�)J��p$v�(��R��n���'��n _��|˷��2��6��/�WN(�^�z잨$FF��.�8�WX���Ac������8E�[kv5hV��Sc]x=�r���y�Z���2}�h��G�Mi�7.�.�oC[��>Y ��{yb7K�7�c���ʮ(�}�6����|rL(8K9� &B<��j���#Q.�հ�`��Mq9&U�6�;�k�/�;7k�����]+�_ӵC�<1�K���cw�Bza�c:�7���L1`ܰ��3;Տ�,v*���t��e"k�"���4�Jl )��%�cɡ���!-�������T�*u|��mZ�%���E����_Ѣ%Xخ�f�j��5�i��Eb��"��K�s�5��.:�zQ��������W���<��-�y�~��t�?]6�����o��Ñ��{r9�>>�xJ7X    r~N��$�a�(�J�y��"v,�]1�����t���7u�,�n�����!��=�J�2v-��3�����x�5�����(iPi�C�L��[�%nI}} ���7�����Ł�5�껔��@b��T�z�pf��J�F��y96�,��b��2_��XO7����۳�x4�,���0�nY���jc���I�6�[��k����⑩��.�"�2�#���ߋ�l�Oƍ�Ur��V�ȡ����f� l��ra��;�r쎢�h����6}�2��M	���£hp˱�F� \�(�ɖ�R���hx��V���x��!\����1�l*�I`b���`�X=�f�R�����7 ��V�����۪���rͣ�8S��&F�)IG�x7�{%��rdI/�^�I����J�����ݳ�V>x_)bE/r��Rl�q&����UCbSn�ʊ�q=ךOH͆� ��U'�#b+�[<dwP"�W�M{�Å*��$�_ل��oTkoi�Ţ)�$2l�4q�U߱;��U?��M�sn�`�1�;��U.)Xs�ЅUq;0![.���G{n��%��}#u��f@<�Q]Hl���������C¸O�8]�0f��sv�xq!�Nαႝ�3/ݰ;���h��4X�|��/C|4���������X�6��{4���С��fYMb�"]��6�!��Ѷ0B�`�j���+֑/�o�6E`c�ԁ�v���ڋ��.*�2lع�x	bx�9��o����n��;F�\�u�#c�҉H���y�c��,s�+p��<����qC�?l��
�����v����ˑTu(l8��	:#�>��hEb]mY���cWW%W��q~`���:���PJ0�[TfX�PVs�9:�ޡ����:�4�y�0﨔�S�8a�-�]b3y��b(�ٗ�ly#R�u��r��d���NVc�B2t�j�/Ӂ�FO[-�YDW�`%�g[b�*%��mص��BxT����\d�������˧5��<�FU����xı����������I�O��A&�Zb�5�Z�=4�N�����IبN�V�%�&-�
1�ا�+��ݨ��Im�dfذ�i4M������^�'A6�x���
�@�^�F��h���B�?��1J$�� ���}���J�����x����O�;h���Jb�~>Xfv�ݍĚ	�&&a7����K��ku|�iH���X�:� �8�Bz3�$��X��nx� GE�T��2hm�����찶՟��������8*�ĸ�h���d� ei��R��oE���\�~���i��f�"�f�C��=�1�"4�!�#N�ܾ+֪62͖�04��s��R�&t�E�Y�͔�j%d��-�z7I�d�$B?�!�S�%FZ�ڇ����5+S�0TͥMw�f���۬���R֚�jr�ܣ�s�-ӯ�������}�1�Il8l�B&e�l�(�$6�yk��k���ia��d��G�w�n8��V�M��Ħ
��Ehq�MZ�]~�_��mϰ�dp�D[��^��}h#��Qt�A�=��t-����J���=�ޯؐ�����I����BXb�y1#LE�c�{�L�ج�~|;�H�{H�	$��#��$@ҍ��= �;�qO�gk���C�D�Ʋ������v��&�"��d��T�ZA��$T�ZCbS7�v�(y���S'bs%oZ�D��n�՞��Q��'pG?P���H[�'�>�t�Ӗ1ԁ����n�4?ΗAg~*	�Go�
�����2���8�9�����n�A�R_H����	�51]�vlT�P���(��\�o$6���1��olMj�9�@b�WET��V#[�P�Q�����&f�����-�c�*�q`S�L��O��!����`!ĘC�T�F���C�ȈP��o����$�\u����hH�(Kbs�F15/cj^d:�_�Ѩ������B��E�п(:|�E��k69���Ͷ��d�̞\����2�Zfc� �M�>8�c���L�$.����eI�rͰ�߱�C<��Նq�/am��Jb���xyo�m������ T�/5� ��.�#&W�ț�*,�P@��P��lĶ𫁮�7��X�ɫш�<�/���_�w4a2��jx�R~Eo�	�œXgi��Q�fq�L��I+��ԕ{��S��R���u*�o��ax-26^|�o��ʃ�^�r	�KB�z�C$/'�:!������%�Q�����L��ZG\Q-�a]�[k3�x2���ۭ/��N�5��I�?p��ߨ�f���X����P��6����9`�����^��yJ�����u�=��K��X�g��m�]��)��Z���>����gW��O����݄�Jl*߱�'�`}�V\�	� -�K�� 4	:.�/�Ҧ��>iS��*܀bפ�nI�û�o��:���_�2G�XI<��ߍ�ZL?a35jn�P7hS�G�@{^8
m���o
E%6>�wnq�Ǿ��Ć+H�е��7}�.�Q�k-	��:W,�ι�'DXq�-K��͈ \�݃$:����8�dA��X��^?��Ͱ����%��ڏOX[VYvL�"]����ɰ�8h0WfC$���77�+A�R2jjW-as�[���aR�h��̩�	�h�j�("aw�J ]:�:�%�6�d��s�
��a�|�6Yܭ?��2L�׶y���[_G�f]��

��լӒ>�!,��m=����i��Yұ�];k��K>;���=�8m����֖d/�6{�eXɐ1�U:���+��?V#�l��F�u_�&�eg��\�%TЩz�� 昇�6STi��K�"��R�w6�Y�E�W�c������2Q8���U�N:Tqpe�PN���~x��!Bhn^|/�����N�2���/���Ws;�IlT�,3��!�|x�g7�=��O��4J(_t�P����L*�A�������+>2���%�"����Qn�+Y�����{ʣf�-�2J��$�*�����n��d5ŧ6�p`��1��-LgG/�-��c�rW}r��\}���!hHy�%Æ�)�Jѣs�C-�bI��B~��{����g�2l��Xs��c䞖։J`����1�&�;:q��*�2ƘA���HD�/v�;2I4.��}0�WD���7��l�k�ŭ���ؗ���w	)�:�1�CN��nO߀���Z�d�p��K��=;v�$���-��դF�����{H��h�����T��b�F&���.��W`�B�X­�-�~�c���O/y`"Xf.���N�6� ���H�[E� /��PDړs"��4T�{� ��c;�B�g�µ���ϯ����㯞;F�XAg7䅗�C=���<cB%|����C�'��!�%M�׾e�	��GuZ~�/j 2lT���
w�]Mb'�dFZ�����}�f.��K����C@#@�>˭
+l�'Z��n�=Y`��k
eJ@V�,�̰3J�?�y�:�\��CM������.2�y��z`SEB�����U��$�c�T�%�|����K��A̮�(�W�	�1���=*��P���g��(ㄙ���ЏNU9��T2��>AtD�$6+�e���; �9������n#H��h(Y���i����8K��'b�*Ip`dP��H��`���
a�di�b��Sr5�6;L~�]�r	�N��i����j9�
���b)��dX϶%Fv�+��c�BbLdDsv��]���>��#v��q�Ɖ�++�뇒��r��vA�11<�HXS�Ng��H��$���g��Ħk�
3�j�H�k���hH⫮F@d��DPc�o�^��&��f5��	s�:ģ��k�`>�!'J�I��$e/�yC�M?"`B��7��}A��a���,X��,�玫$�q��K��Ƭ9#(4_��Dl:��⊍�~�-�IF�"HȰ��Vu�
���ȓX��:��*�d�56�����Kbg{�����#�i��zQ��bT�;+��O�,���P"�<    ��W¦�<�@}��1D�������a\(o_	��d	�Jw�nI�dq-b��Mw�n)z3���2l���x!�E�z�	Eb'�ϫ��Ot?@\�;�a���f������� d	�$\�|�as^X��H�^��K�zSkqI�a���2A1v��;�eB�m�������l�Cބn��d�T�Ͱ���>�N����6u�������"��a]ǽ�V�l��پjય�ν��HM��_��V\�d؉�_����~�^�m�u��QG�-A��rث�%a'D1��>��Ȏy�ҡ<�)��ѥ�� q�6�Y���B�|3l��[��F����ܤ��x�-3"=#������&����a.����6�fV�Ip�$�ƒ�����=�$Yuŕ^�������C���z�UP�\ne��#*;G,F�=5:�g��B�]abFJ�6]��rn����M�@<9S
�g�T�U�b�%G�(��2l�YjfV!M��B�g�T�[w�Q����6�n$�?�(|=�)����ӊ>��h�Ħ446!E�@ �+��،x��x9��evP��l��q�:2l���?Ĭ<��&1���aW��G�����l����Ad��e����b�"�Ͱ�D��=6Y�T�k6�J�Z��5ɰ�x��ю�E-Dbc2��٢��:q8�x�.�@�*����DP$�؉�쬤�^t��C��i�,��S����i�E)���g���1�}\�>��xV�-GQX�E�.�f�/�"�'�G�nѕ��u�m�C%u���r����Z�������=�$�(� 2l�=�4z��$ξ��KwWb�*W��N��K�@J�}�،K`��gA�".T������"d��Z�h�*�p`3Wz���1Ɓ��hZ'��1��H�HߌZ�6(��&�"*�a��	`�T�3<4��I������D(bS^ ț���q0$ֿ(M:�K<F���V+�I��<4٢�+���Jh�*S#>'�Bc!�Fg)X��E+խY�;g�eУ�T��n��u8h�%�;ly���ç�����/��8jg;j�l�����UX��۰J��<��,�ϰ&b"�*�Z=���KbSW�V�eĂ@�~4	��FD�;G�X/����"a�>��O��@ޟ|}y�r����m�*�NfUQo�a�� V����he�,f����H�0�I�L.�M�2����'1�w�3ج�կ]��]d62l*�|%}�'���2l*�\~a�; �m<\޾��uP0�0~����	'�ǧݥ����}��6$F����鋵�j�NkdؔK����Z{Q ��8��ǌ��i�z�c��߰+�D�m_t�e���`�;E!9��{�6�؇l���e�|�C��<�hV�$v�*���`z����r�l�����C�,��2l*�_�e,��C��a���6�������F�p��
S&�T��"\�.�Ӄq��N^$�����EԿ#�[����}��{C�G���W Ep������nU-��q?�����o�=�@G-@�D�v&��A��'�k!������N%�fF�˃��P�)ah�!���#�+��/JZ��H��}�JĶ�tQ��a��.�=v+Y�U�|`�c��Ql�{�ѴNe������~�xӥn����,>��W���<!Ǡ>Rv�]���Sŭ��R�Ik#ߠ�i��`U�Sk�����,�X,E-P�͔�ET1�f2�hW�8B����g�v�|W����㿒ES�aWlTE�2*A�F~�oUh��Y��}-�&����� "L������m"�}9C$���}6��>�E~��E�A�L�:sxŦK��JW��aԐ�}���
l�}��.���z &]uj�թE���xqń�O��@y@��+i��/3	��e�g�ξ�݅i����j��(L�\����(b��g�zg�����mFBx��s�͐7����#_�Ynp
ǣ�N6��X�����'Ԡ��ᑌ�E�i���D�^�k�B���l�#�+�����
T���!"�����I��ڭ��r��F�ZX�0rv�-a�+Ѡ�k*��^��-���jb����1g��:��d�����n��J]���2NR�>L��N���{���]���n����<��aSU;����h�޶�!
h0zl�}�������CP�:�DGT�A6��Y����L3;�r(`���BdX�吜Ǆ	^�jgO���щX/�ƾ.4��N)8�aS�KAйJ D�N^b��Us:^2�gc��;�!̰��x�?1�3D�`�A?~���e{�1���8��L����ۗ
��
�d����5H�r�*!�H��A��2�]S�LnE�G���z�km���^����J^Б\	�j�aS�?���Mmq]�asb����<�)m��Y�	�yȉ1/8��Z\�g�l폤�l	"ۣ�$6u��y}�@���B̰�: 9�!I)_�5Eul�ul��G�͜ؾ`pX��$�������v�'�TQ9����劇(�,YiA3���о	9���^����~����\8����7�3>�i�WG�f��1�l�|3���7�+v��B� :	|�\�O���(�q��*2[�N���d�����_�R?���*1gQe�.M��
��{'}&�_ɰ�I�65��]Y��f���d�S����H��O��&s��;�
��8ފͶh�K�Ta;�3kp��Žo��k�P#�3��b�Bb��1�[�kȓ1[o�W��UHY"' ��H����d+��[\�ԡ��������]Obg�KG9�.�HB-U����,�N��Æ!�I�D˨�A����gKs�3,\qS�aRin�����=+����Ħ��E���aO����sQ���??��%$6ߟTȫ�1"�UL�:/T��(<o>�zB�VN�i���uA��M`��966mWa��H�+�j[gb�!�78HR�ėa�26�e���6�d�U�qv��eS�C��Nٮ�z%�������?]7nR$G��$v�P"���_�#@b+J�2LZ9���>���Kn�~6�Y&�WK�	��,���&�+�B���a�(Q5�?Nq[UMp`�q�����Ĥ��V��1Բ��U�Ru�MU��j�cNֲs��h��I��:׮ب��[=&1i���d΁��P�-B?aZ/U*��F[{��I��'w���~ P�뙰�Y>�2����=�.�f��H�֘��'r�0�y:�-$6Sv�$hb��}oHl&jw�pz'��K�����L�Đ�fj�ɢ��Fdq�[�>���=��>:6�����7��5�e�`����N��u���L�K�ҟ���_>w��,�j[]�x)�awH:%x�0^NʰQ�A��*G+0>ё��@I��GG+��663!ǩ�Q�ɢ/$�2lF�0���=?�$v��S��Y9���Z�ΰgX������`!@��Vd�2���$�A	'�Ɩ�*�2l8�P|��_�)o3���B�h����j"��Ȱso�]��J<��	���6�x��{�/vOV�p�oe�ԃڊ���++g&"���*�N8���xGV��rj�C:ޑI�uw�����.�I�=)�DB�}&a�}~�]�`ȉIՙp񠇮�a6|AMS7 ���o�%o ��� ���ThO,;$Mk�	�V$qZ�lD����ݢIl8*�\���kH��xP�v�~{(A���6�8A ;>>�"y�J����'����0ʰ�B>'	Ң��G�c�����9��_�<b��H�\-��"�5�2�����Q��������
���I�q9��՚�b��ǣ���6ٷ�ݎ}#�,�M^9�b���~�)��3�GKG^a�����,~6���(g7\0[���ZO<��e���VǸ?>���X�<�q� ]��/-�Ul{�f�@���#�X?��QIblo�8G�qL�����G�F8Q���E�k�MM�t��ÑA,�՞�:�9B����h�R�u0i��V�`i��Jb�.�2����·ޒ�M���C�>f!��    ��c6@=������W�b�LQ���"������5��M�� oH8��)��KQŔa��|�Y!�� ���U���nl��g��������l�8;޵BI{��&�r`3%����ܵ)�
��I���1z�����eU(�N���!�� ;�1y8�q�T����#�h��X'�.���T��[�����K��Fb]S ��?jlu���2.Ob��@���At�ÀS�bֱ������H��uv� G(�Б���ҵ��mс�a'(�:'����%�З����18Nә��H��h�楡=���QOb����88_c�C�!�YEMh�C����f���	�t:��$���0=��tή\����"�D�=ZKb�EhQ���q�A�Ʃd�TQf�;;K7>�}��� �����2��N�1�� �Mԯ#_�!ܫ�a�|S����)M:�2F�����8���0�'y�fUځ	��`G��w����g��9�:|��
���
�-�fUˀIW�[���-oNC4���:ΰ��ܳy�!'wJ:/��(L�f6�����1M�����=MXvE=\��Wh��|��Pi:�;,�up���Hi��&�d���If֢�-æ˼�l���)�a�D�:�J�-�Ǘ����ZH�"��\4�E�]���z�e!���űh�Ĩz6An��]�ʚ%#k1�9Æ[߂ )�v#۹�M]�g���Z6O���1��Ƀ�U✂��rSۥK�l$6[����m�V�&l6/8���JbCyr���ݱ�� nSZ7��	�d8���a%l>���_+�y��s�%l�"5�)īcu�g]���������@��B������@�l6�k��bh�F�N��Z���yAT�$��+*�3l*,bU59�V����"IV�zj��a3�ʫ�o!v/�-=a]�9��vK=E��j�aS����&�ṖXhF`R�l�ݓ��R�,��& �~��g�7���'�~����뇰⟜��qwHP�oaV�*'V�ͪ�6�u�
�r��ɮەwðG��+��{�+]8�n��+��.��v�REj���+6*J��nQ�hE/�8����V���٧ݨ���+65��mU�GF���lL�uАO\`�#:��p�����)��	U.��M_n|�	�}���uUpI��֟��x���n|y�T}Tt$6�(�žAp���a�����8Fcp�F�sr�B=���ҮQ�.�I��"
�C-��a��1����v3��]�+63� ���(�8��j&hB�</^־��Jyo+��>Ā��n��|䐅8�U��d��/|�'�HU���j�4:�S����)�)�>�z�H��-|�6e2��-���Ɩ>J1�E܏v��8��~�������4SE?fzZ �G�EZ��]�,oy7~`��~q|�|��ٵ��:09#��$9ԣي���I��0��N����r��-���p#^;����T9�QG�/�iQ�v`�TaɁ56i1`�J���KI ��*	���l��Y_%xl&���?���P�Mf�D��+A�x7`P�Fb��`��_2��8������`&h�*&�G�]r�ҝhO�⢮�46��G}>��^�1%�d�K�� 	��{:���h9X��Y+H���f�т#��Tv������?�����,�#���ɜ����|S&N�$6�5���M�a��6���mfwL
U����̢0��T5�AT�ޠ3X�)I;��:зcb+&zV�8���:
�����r����RK��2�������W:�b���96#��]�S?��A�X�c�c�0�a�J�X��6�k �=ZW�	�lz�Iӌ�G���)��(ͱ��$^�į�?<]?���\Kζz�5�c���H�l��4�JG�b���M9ۆ�U�q8��t�ʘ�B"�$96�P����ve����,�X�A�r�%�<���L�$6v>ܐݓ%��F�Ot��e�{S9D��l?�B�O<�X����B�8�{�}Ob�%�I����&zg#vr��7�P��.$��.9v��G��Sq3��P�N.��p�3W�+���E��I�p�.f�M�ZZn�t�bV�%Y�ۻ�ѣ�Ĥ�D���&y�:}�,��:'~^̬��R��=�(P�|�<��e��7��ہ�-�o��T~��n��E��ؔO*hl�� ���9���[�$��|6¤WS�!ֱȡ��/PܖF/+�M�z�;8/�uSIؔ_n�T<������rl���3���Ԏ�Gb'O��VhL�w�ts����Oϣ)]T.����Q���Ur�ͦ�l�����[:��֡�C��%���W!
�*,ǆ/n�0M��Q_�L6��F4�B'D��0Q9q0̺ˑ�&š3<�QU���:�B��D��ҋ<�)&* �x����������x����z�uzx������~�>�����������;$��!��;$��pt�!\�,�6���0=����j�a.ӆ����8{B��I��g!Ǧ��
~Vcn�e:�(�:��*R;�V�O�Jp���eB���^�G��mp���������\��xE6B�3�XPm�8�74�n�>d�t�z��Qx@V���Y�F+��q�c�׌^h`V�iS��F}bH-S�F��m���hp���VqI��p5����\�3H�o�j�4>$R�N����p�Gc���$��sލ0����s*;�rl��Ƨ�s����k4��k�p�P��]�vO��CŇL�1=H��#��=bc���J�L%;� �E�@��۶=d��r���q��>���P�^����-K���J��C�p��LJ$�Q���Yņ�
Lx�$6۾��߬��a��896�/$��i�2�ԐX�ȷ!�\�i'�!	�UZ��o��NN��f6�M?��pc4���q4=h�o�����5��H���(�$r3�عʹ�bSJ(@�y7h"ƽm�̛1d}�͸pߋ�h�1��Ė����j�%�Fջ��i�ܵ���1��Hz6�P
�6x�#xt��f�{�Xފܝ@���>i�E����k��u��M�ޙcɐ[�����9��P9�Ó됷�w�4oY?yت����?��'�l$6�����h��;y�ή^y��|�վqź�6��ڟ�Jf=��.�*������G���p\�[��'͈�ǒpf��J�e*GD4xW��p��V�1�9�r�E�]�n��m�\�Z=0p��.�^(Dl�P���Uf8h;���V4�� ��z>96�B��FCN��7~F<JH@+z1�8�:J���7��E�k(S�6]��	��j��ZbMzj$��M�^��IBBk�vrzd�s�C���IlfԷ����-������E!�r���q˱	�X�۰V��6Tm��b�0Wobvp��"���ju�Ѱ����;�_,����}��;4� [6D�IZ|���e�[?,[5�(�fĈ���U�	�{��Ṵsa�����yA�j�U�a�dX+0�/0���;;��	R�Wj�$6��8מ��(tl�L�D>���?�����m��Yȱ��QX�o�,���'�Z�ĥ&p+LN�z)6U��m�����آa��l	�� (}��p�Lf���Yo9,��z;4\�YGb3��#z��p�U7����)t�A��*.�2l�:��gcv�?f)�j>���M�dJ(��j�m��D��p=aPB��Ʀ�ܐبJf�L���&��Jw�Gì���5�Y�G~Ŧ�� ����a�:�F9�2����H��/m�.:�UC�񡋎���蜌��:���^�w�0f��.a��0I�y��� 9��G�����Yp��Fb=N���&ܞC[�0zω�Y�B*q̘�H�f��H��x�:�8�ғ��"]a�Q�Wd���"��2�h�'�ܰ{O���)53�
�0+l �YtŚ���(FR%&��VFWl��3Z�)nؽ�<8���o������Y�*�)��~�Fh��	ӂip�)�A�}t��� �  ��N!�g�\�JbM��� 	�"���:�rņ1m�{7B�R��]��Uw�Q5���*�`� {�Q{�m$F9$��*U�/��2��Ip`�/&�&L��|2U��6��a.E��%RZI�1�B��;�����k/��R��kb����Ͱ��� W�E�y����Y����I����Gm������=/�ݨ��=u��%��KwV*5L�Y�Ĳ±:&H�X����!� ����{O
�'l�Ƅ�p;����ژ�4�]:�'_�B�$���'-�Z�sr`�Vi���s��0����n�l�%컭�m��ZlU����v�������}	JA�ee����6�����D�A�$�%����H�cX�͜#�;�U������y�E�g���?r��k��GU�DyV���A����]��i��R;�	��0iy8Q�M�H56��y(�md�.nOi���j;��D�x��~����Zd�tXRxt��]�;��� �B΍X[vag�phٝk��=5��;+4��Q$������ :|)�Go4S���;A?2������Hl8/�)�"LUq̎YHlH�E_?���\�}W�!��h�pER#5�	�͚Ćk( ��QWć����+�#�"3B�:z7��(��829V�v����H�q&� 6���B��Ev��xla�&������eMVM1a>ǆ+N��_��a��E�2��j�̂�g��3�Ʈ��xKج Sd�y�K<N��
�4%����]]��R	�ɾf墈�&�Q��h�G���aH�d����g썸8Ik!��v� �{䙀�oq�a�I��Y�i�����,��r�#�`���$6� 
bE�@���V��2l���{���oQ
�Y���<����rѠ[ꅿb'��<���tN3�BI��Ơ�Zt)fذk�ƳT�`����]�0kW�4G�`�Sy�Wl&�$�	ʻ�5�<��r/Ѿh��5l�^{�,�K::	�΂5�]o$vK_����E.XN"�8 Y��W/A�Έ��G��mq�!��Ē h�w���[Il��#t57�����#����a�1h�5|A����T��LD�P�,�*Is`3Q!CP�S(bP��f�I����f D��G���#��QZ���������0Igh�V�2�
b+�K2l��cB�,��p+�I�oHeIzL����,�媤��Ěl�x"��xK_�3$v�Vg�G�Ls\��.���[�Cw�!��2l�����ˣP��_�����Ҩ�ީ8!g�듽��M[>�ت@�f?i/o�=�	nh�ͳM_�6y1�1G�� �]��sb�qx);gbH��`]����������}$_�^:��>����r$6)6ApSUD.���f�:�+��*�`]�e�]s��G$C�ze�%(j3l��p�U����b8fX���v_� ��3��Z}'6wUWk��9]K��n�9�[���e�ɢ�?�+6�Ld5�8
h!��m��!99��sS���t���l��[i��L�`�ժ5$6)�	�#+�#O}g��h�u�H��uh���ڄ��h1u.(���؄��z�z�P�;困u�܂�3$�J>�q��F�{��&�Սo����n0�u�ة�Sd]��
�]ڨo�HL&!�$7��mE+�@GtQ$&�}���;bpGQ��Qђ��)6t=�h�gi���Z@k�Ȓ��m�����$6Z�.�=�z@��'����Յ�؈C*���p�d�M�\�Ւ�jz�.����_ɰ\�����o���h5��+��,ؒ)�^y����լ$vb�˺�
���Hl�V+Z��jؽ�V��ԩ�����"�;��?�>�z.ɏ���������;Z�J�Eg/\��%2lv��
�s�~�|���iObL�Ǫ���P�Xt g�h��Z��䖉o��ϰA]�U�����ߍ��:�&
�V�]�q6k+2	vǪ�ؼPtg؉�ҫ�9Fj.e,�`6sKb3���m�ؽ��۽[J����"a��M>L3��|�pO�BA��^�Tn�I�o�����`��L�l�ҥ���p��X����[ǵ`��9ׂqY�1�Cl��^u�Dg� ٲ����\�q��3=r��f�5x���H��j�U��@(�<|Q-�awTÀq�A��PMF��6���ʙ;�{�[A����ж�"��ԕ���1��y<���+�I�"����11��\���&�ą���!:g�m4���/0�����:]`�U�{ج}���T��2�a���H�����\n�KWl.Y��4ġ�95�0�i�Ι�6�B�@1���A�(ኋ��[��~�U�/+7��"��aSI��������p{O.o���ǧ���peŅaK�!N�Z6��0�6|�B��a �Hl.l�z�I0$V�D���e�Ga���N.O�e?G�5�-�`�%��!T�rsW��V��f��!H @�^�1����^��#5y�9�θX�8z9�����&�-d��|���mϰY!`B/�Ð��B�FppE�x�MyV Mo�<"&���t��L��̰����2�H������M��e��N����P*���5ϊĦ�7�ZCf�7��\'5�m��x-�SJ�\'��p;�j���ںTk̰��*�(�ǄhU�!���l�[��j���� �E�N�yC�o�E�~C�G �6���JlF�zaHlpLf��!�⪋,/�LR(��3���[���>� �A�����'�o9�t����.��j|)]�NWlT�,3��]��7�`h�qp�T�O��LS�`^��Jb�:�$Z�Q��x��pCؗ�1��ؔ&L�CqQt�����f�̣2,��I+�"��<���L����!�����Q��j�!G<bg�����AR͐5��������4c�9            x�՜�r#����S�v
h4�x��5�Z�#����/vٕ���I�?����4�;e����F��1���p����(0o�� 7����Vq�5_ب��7o��n��������.r���V�Ԗ��������*��j�(�o�n��_���O����o?W�[k�Ѕ�F�1֞~G�ƀ�h[x��/��"�ܨ�[�F@���Bܪ�	(���~{��1�-�q��?��*��%��x��8�2ƻ���Cí�[�^�G�n躯�1�_=��Q���@��:PZb^a�BKL5gQ����VY�>|R��#��O��ñ�b���,���'�%�(�
��4�t�V��Z�8�	Y�cK'���a ��X	�NTb� �Ķ@�L�,A�xy�=�A �Zb��E]s�҂���vB�5=�9�I<�����6��oL��;r�NY�j�t�K�-�Wٻf�2���\p@�{e+�g[t��:���B���^{��g���]�
��@�8Dѵ� �-[tb�:��N�CI��p�3s���#���ݞ���o?����y�A�hc$%���)̏j8�P8F�r�d[o�'9��>�x��߿?�@�T�*H�bjr�%E=Y&)y�d#iCV�H�ؾ
�"b4�X�����B,�z_M_�4Q!�i��g E<�|~�=���	�t�l�R8���؝��!ڵpH��k���q�"� ���!��R4D+r�)@����׮d[t�n�γ�������m��d�6x��(�,�H~���5B��-���Wu<$���3ƐF~nO��xh�d��8��cpd��ҵˢB��,�q���%7ˑ�I7,Ő,.+��㮕����/��kG�ЊY���x۝�2�j�[�$5����a����l��q@m2�K�o����h%f^���_*����@�PEv�"��9���i�.LJ�#I<����|��j׊֮kk���Ö���E�Y|�����s��'��\PT!:1ق:�r��J����:A%E<�Q$B��_&z���$���K����ogQ��(�(O4�t9��6z�P�ч1{l-��j{�LE�����t��%p���A���?H�)N�R9�_B_����h�{q��j��g�iY���\��8���qײy�T�B�Eo)�;1}_+�w��x!Y���y�R!Y\���Z/=)�&�����ϕE�)u�vejN�C�z�@��u`�]�P���`"Y\4�NT��Re�Zc���kT�����k�0��rZ+_��u��JD����P�@�#8�m9�Ƃ��r�
s�G��[�������^��a��\�ʁb��Ĵ����At�23@�x\[8��jT���^,�L]dy�S8̜�ȁD��\��c鶊x���QbA���~�.P�H���n8zu�>r�Ubу���qYX��i"1\��:@��#{���E�e��(\�Gv����)�c��#�9�兵�Y��e�XXRG�h�y/z,S{,�������!o���I<r|9�5Rx ~V�b��MS7!|w��Ӵ��7Y*d�N9�͕\�P��q�jy1�:��:{�g�ȶΤT��}�I\l���;6�/PQ�E;�+�J�_S���_�"�C�gK
P������ y����u�����=.��i+ݺt]��wZ�N�#����')��b��u��׀̊�r6�
�3S�u��Z7��X�@�����@C#:WFfr���'m(EQ���B��4��Ո�ٯT��G ���� �;�l�6��|0�󙈋F�G1����x7�JD�l#���5e����9��@���8:������FN�F�����@a�PjԔ ���Q:�9��`;6e��(E<ٿj)%=,�X;@*ܣHb+P��b�qn�Q�w����*]'s]��".�W�{)��R9m�!�V"f\j��n�E#RxO�!P�>�(����	�{���1P��c��z[��#��K�x.�owm}X�ZT�S>H�Jt��v��;�k,3h�8��=�މx�h�/��u��aMPH^+�^��^�>�GN[%bޘ�SdWzR�#�ǃ� �q��|�U�\��A@�����)kT�ªA1o  ��;gf /� ֺS��f�������JI�l0w��y�z���-��Y�\*�?��#��5����#Q��N��=}�ˉ!�6�!�}J���0���6:����T�U�:�7.��m�&6\,��[�ȧ��$!w�l��M󚜨�wG�	Cl�;;� ���B�6����'J'���F#��z�3��H�*��@q�?c,��u���{~�Kmq���t�XV<��4QS�do���+}�Pfg�㴳�����}P	(��8qwh�|�GML/(�T"F<�k�tN9��n_�ңHr�V�܅K Ƚ��nD$��.�CBK���a�o�e�=ݑ]Mn#�B:,A��T9e�h����!�^oj�p=G#��v)�Zp�s
�t	�K+K�5�w��tg�g�Ax��i�F���|i�E
'�T�;����Np��l����]x����(�h0&=��=��oHOl5S��1Α�$Y\J@"i�.H�	7UH"ֲ>� �SfS���<�$�$��{p2G��À�"��>��ى#�1rHdN�4��xt[_���N��I�� �=E�6aP5���C�#|�3&Rģ>.p 6ZT�&�h�ab��й݉��Vd�G����G�wi�������/���꣰�%5(m������&���S�B�-SZ��$��V+(||��d� z��k�N�5E��V���ח(I<��>���XO0��@aD�ũι�tS�0ˬ��d,Y\�OońǃH��4zk���+�
�w�_�P����[���4|�p\��W[΀À����;����]����jݜ��O{��+k�p�gp�L�P��G�Q:�A�(��w�4�".y��q��#Ϡ �#Gl�<8���^���� ��B�d��3��%��Pl4b"�E�ݞv5^��{v�s���;�g
	-0�e\D"F�8���[)��+7l�O"��ވ⒭���$��� p�b� )��z>����Y��܇�W� ���)��(�6��_������[L����"��Mĥ��{������!RH�=���F�}@x���BT�p��X|)^���$�k�2��	Aa��L���'h�#�K�,9��}8<<I��	��v[^S)E(��U{���M�gk����G���.W&I�yCn��>�:��Wt&]��@����bUfM�%{����u���Z*�G���R�O�]�e�������J�I�um���<�|��s�H/AN�R��?7@��0P�N�/iDQ5o�tkĴ�J��BjΣ(.F��o�d*�JT4칤+��?#id)��nIӱ�$�ߒ�݈d%R�T�I:7֧$RW%�2�I�	L&�.�>V�Ȫ�LD�k��.��B�%�0��$�G���?�ܯ��5���'�m��ma��:a��@�~CXb�r:!�`D=	1�{�R�.��8,W"�c���|�F�����;�%=�(�Q�o�+���""z����b�u��G��%�M�g�1�0�(.���s�_a��$��YDǥkǅ��E��V�8r�Օ�msތK�!-ƒԝG�!�%���0=|h7<@�U���KQ$;��d6�<� owұ*�
^L��"2w�0R�Fb��w��$�I��̼Y7��{�,�%̎o���2'�#�sM��1�ۘ��h&��i��,��ƶ-}_�TI���~/���Kc��.�'�%�ք�l���)F{~���J��׆9H��xx'�-Ly :��7ы�u�o$�%H`�8*D�v	��eq��xη�´��k�
oy��^J�FeC��N�1��s�ߞ_�"���R�����*�Q��bK(q��8h�wy_���^��XY�B��׬,��y�G<�L����sj/��̎��F�A��W�O�p���l�V�#�i�`�xȧs�9�"Qڋ+�s֣��G���%5�>lz	��� }   �!&(�3{������P��w�L����r��V������G�b`7u`��j�V4�3ւB�xT�:��	J�ۥL+�u��󺎉e;�6J�o�N1@�9H�ݫO�ɗ��'��bwo�nnn��)�      �      x�ͽے�q6x=ż �2Ι�+L��0��f�_P+�_�i�5�ך��o�)�=���],I3��]�~�\������?M��IO��iJ���C�_�O�}p��rQ�a���?|���ӟ~��˿��U�*��'�?���*~��C?�?����?����\>�������rZ���_�����_�_��B�!w�.��h��D�"r�1��V�o�Wq��O�����xwm�[���h	p�>��������s8��Ѥ�63��>���K׃�^��cV�-;f�$�Ś>�|��{��|�������#��_�������f����p;��Z�/
�M��r�|zl���3�3�����s��x�.���9�7���O���`!���.+*W��|��2^��k�����,��p=�8����x����P��2+��1��:۷���<Wum�]�k�r~y��A���nP�r������8p�I\��^� �0��C=_��Eh�z��j��vY�����m@H�Đ�*T���0��PVT�ή���ޝ��V��PnZs��uKJ{������x��6q���^[��
�\��ز���I��N�y��o����mZ]�f����V�>\����������������ǰ�ǯ�j�o���`F�������O�/�ύ=����*�q�_��]�ƪ��4dY\u���<�Ӽv���;��Y�w�*�aJ�;���/Q�D�?�6������]^���a�ؘe�И-ǖ7�?j�7��_�O�-`���q+����kX�# Wq����ښ5C�B��fO$t�ѦfE��^�uZ�U\����n����������gQeBB���p���&�"	����A��*]���g;tR%a�����ahaYh��r���k�t�����U}ޭ�/ߟZ݆��2wF"U���VX+#�M������^B������Cf��؂��f�~�?N�ȷ~OG�������m0/�b�/><
L��LJ��/��6%?6)� _њ�6����+?oNK���&�M5�o��]T����i��+(�p�X�D��~��`���/�i�}D�����1n����(��|=�ry��$5Fn�Env0�BOx�a^��҉�H�z�?����N@O=1O�ڶ��=e�=e���nYvj�wϧZ�X�@11a��;�kDV�F��v��px�[��[����n�}ʬ?:`o����>Atʊ9e�y��L���k��hl����,�7񚆨5C���Z��[v���- ��Cr��}�<��۴��?^��!�w�ĳڝ(�P�Iv����0]~���ziV�d�	��q�t����A"�u j|�f��}����� o.����?����
6�$��O��7���$�k�l�]S�t5t9���׿(q�z�ЅL̅�F�L��U�������#6f�|�����Ӯ�ڡ�����[����k[�+��P"�>6����h���vym0�0&�{L��]6fW2H��ߚ=G5,/�6ʟ�f+&����?E4�Q��ބR��~���(��9Ҋ6�>��Ԧz	��E@���ƕJ�'������(�ˇ���)ܘ�Z�1Xv]e�x�`�We�n7x<���~�*��.�Wتz5��������������
L�����&bNXb�b��`��'vż*�1Պ����3�C�+�x��㈋���FN�C^���)��G�
��;���!z�5dPP��������/^�������<�.��c+	�k�ѵ���&6]~*���럆�����_��5���OL�l��iQ7�>�=��!1.x�	F:�R���o��L�������8=�I=A����pB��=�k_���8�J��r�z����������R;���j:GV7�ͫ�L?��o�u���u��l���z�O-`h^�� �q�\�뼟-3T3:�-C�*���Vqn������'�|�=c�����P!}���7�+��A����!(�8{�&|�E.��N�~C���8�y���8`�`d4��<-�W�n�T�fb"R"��=¹�[�Б�ȖN�V=+`��\#��.'q���k�qh�E+��sjK����0����c�F@�������3P�h0wM�ө�b���=|zy������-����������@6)�+���[�%�T����7���`K���&�_N��*�`_����Ń�/0�x�!I��IElH�"^@Yŵ`xZ���E�_`�o�X��K|�1��[�/¶U����=��|3�|�r�|�s�b�� ��x��=��T��盙�SS���ǐ/�Gb��[�q�|!Y�m�@k�F�oYa�Կ+^��'`�&b�*.x����^k�g�wJFG=��N��D�Ц��{�^�De9�b�4t|��;e��C���U�(m�B��`IT^e�Gk��f��\�L�[+�������&�ڒ��te�x�zzlbe��̽�H��^��,�be�x���&ϝ��86W�K�)�U|E�.�����c�<�.5�R�U)���B���G�X���IX��{���VSG+�0�	x���"4ki��
��Y$���R�|�ФY�=����
�ढ़�A��'��M䬌�C>J)�<,�䕵Zֹi�F�/C�]J\\M��z�ݣN�(��I��v��6gd��G�+^1r�J�x���]bdh!vGHġ6MD����980���x��F�]�$C'�&�f6$`���r�N����������>ݟ���s��)�9��[��(
�Zy��z�˸���;��$���c}�	��>��z�����7�SwCh����>W��gR����|K��e���>� v7���E���~w�9��#l��إ"�&q��/�ᬇ������n?�p!VE�,����6.i8;���Gz�㝺qsF6���br[�������t�o�S}�t��ݣ��� �,k��O(�ݟ�����a0����	 N�+d�:@��#ն�^d�җDK�et noΤ�
}��O�4���U�K�M�u.���;�Å�Osߧ;�7�!?��`����x�;Ž��C�1Ǽ��MJ;m�_�*��F
tNɃ�TPz��#J/��>M�w�\��#��K����E!�[_�F�N���E��n�L�w6r7H�b��S�E�� R����~0�h���2�P��~BgC� ���M�|���m��nd��!����/��/?�|�����zy<��|��6�t�!~>�2�zi�6�x��Q��6ev��TK*�ຕ�cr�B�ҝ}"��6G���o�a���tc����_]�^M��X?^m��8^�" ����Sf� �	)�-��P �ɟk�>o���PS ���if�i륛���7&�4�&�M_��8�
4K':uP� ؙBoaf
���F���Sn��8\�dQh?דm�5�tT�3��<[j��>^o �_�o��t�.l�Sf�p�kvff!Z2���:zpc�J��KgO�WF���N�����<v�~i��y��TPZ�"��e����ߐ8S�Xu���Ԩ-�&iA*)S����L�n�|��%&����4�ډy�z�ХY�V�+J�tS���՜�F�]��Cn��0�'�ē�q���	�#3"=���=������L\\���BZ�j����5fԾו�4Av��%��~��?ϳ��&�����<d��A#���N�x}@!Ljd�7���]�S�'瓎��8�HҀ3�Ť3>��P"t�񋷛��4��Rќ�Mmf5�y8=���1i�Oh�r<�t�2�ilN�.eM���-�ẍ́���������&��E��₷v���Ns�+�:̣mX�#���V��Գ+ �ڳ��/��3��5���7f�f�����poɇD"@�B�,�kn��<XU�x�R^w��o
�9�6����/�|�l��V6V�x>��z8^�]���(1����xN    Y4�w&Y��!$��4����ww�3k���ɮ�`Ͳ8�zY�7��J����P_�Q�e�V�!��5D\����;A���2;��ΊPٺ���Ȫ8]GY0>��z``{�"�"�{,v�b-=`h��I��-X�G��ꎟ�#�����G�������0��}������sSS
�]�n�x:�ų�P��4�?�FF��G��q/����ߙg�ril������F�p6d�4���M�o�a".����p~nl�	ؖ�����;tz��tf����֗'QK\���9��CM�/]�G0�ؘ"���8m�)�K8�<�"��x���y l�Z�1��GC߿�.�c�|����{D$�����_ah!�/��tDx�hX>N[j��Si��C9�C9{X�{�p�\�Sw��|������!��!]��V�gEh��c�o�w�tq�<���vq�����O�������VI`L����v��/�H�DR�׌�TTlm �����������9c�=��=R�� v�m��c�Z ��n*4�݂�"[<��k;ܓ��JQ������������_�0X
<XrNmf�(3�%��,D[,�j�1`8��:z�V�*A���J���7�H<%E%V3$.tށ;�ȩ;�O���hH��^�Yy~@���_��?��od8���XzTu�Ig�mu��(}�R�٧����r�6��)25����،�8�Krc�@H4>�����X�Zc27�0FGjh�F��!�y�C k�,��pZS�����rȊ����D��zC������&�aM��2�N�C֬R�"�48(#�,.'|�M��8��Ș[B<����D}�f۷�y�DڷYqȃ�o
�� P�9��A	�ǯ��49&ny��7����y6YO".F�����F�p
K��0{;�t����-zsa2��� 7�����r��K_�ox�������M��Mr�:�@��&9�$'����V]������4Z��[8?n/6�]{[� lj�?��7��}[�}���#ypUj^�p3�iH��d�����[%�xj�)f���Փ r�	���l2��K4N�a��$m���ijr�l:�s���.��������SD�rN��
䨴ǐ�
A.y�7��ON"�4s9t"w"ᆽ45S��.â95

�i�l#,��5���ؑuߔ�n� Ӓ��W2�L��
�<I����^������X�f9&(b�{Bqu�W1�n -�Z����ց�cZ,�Ď�B\�?Z�Џ,܏��f���ӎ�歚>ך�n⩒��������A�x��ɍE�����A����O�Q�?��lE��?Ob^��67����������nOy�H��N~<�ض���k>�	hJW��z�*H!�$��V@�)���ȏg������|������l�<e�S��C�r���}�'�v�m_'R8$��(	�E�PO�F�>�Z��4�6��7�f���x������������=��n�� ��(8��.f��U\p��w�.��z��e66��#>ۖ ��f�$l��	S�X|2ެ�v�&CG[�PS[KR/�Pk�^�ă�y��aǫ�x�f ����/��z�y��u�}	����%����[bɽ�[�5�%j����Ӕl�x�z������>���U���1ch ����8�پw~���f�U�`��n�yC�ƾQN�^9����YӐ�~�>aO���^�ɐ4D+�a�����+[; {�16�`C�1q�#;�8^�#��Z֡���N���o9�L�R�荊� ����\�s�>�Y�e3	8�jZ<`���!z��Ȁ�i�߯���m�"O <���i�s��7*�x��i��NHDU�K�Y\ ?�>��~o�GA<� � ��Q����qT�ohŽHL)��=<��c��U
/�U\��*�$�К��e��a;�Cw�Q$��oox�jYI,���8&7P�+0ry�8���7� \�5a�r�a�57���Z��5��.
� ^�	�7`�sU\��/�[�e�
s�a�6���iro_LY�b�B@���Q�C$���@p�����_r��Zo�<�o�����>�l�����r�г���X~�#�S�A����xf).������h2<h=s�#=���i%�+0�����e�e�/��kK'��H뉫���
�2,H�6�#:��i����R6�1D녟��L���B��H>v�5���@�|i)���׆+G$�B�d��!�ܧ�̟/�H'�h^:�LJ�ϸ��8<c��b�>��gq�|}�sQ��Ʌ�v�H҂C�]���iu�4�Z\/߅3�7�L�H�r����
�6���L�Ϡ�Rph��8R鼻�3��u�N��H( ��r�_N��֑@m���0l���ma}�\�?�Z��1�Q\)F8�7[1��h�X7���4B��SB�R@{l�=��h�-�$�ʹNAg3g�t�x���d=��|�5<��y�k��.�I�(���H�{������Aڐ/i1�@H"#���ᑝi��ΰ��J��S���+�r�tצ2 -���P�<j�Lw�m�������Myzٲ����&ꇬ(�r��^<�!o/@JM�
q����IQ�����b�k�qKTW�,�1����tmiH5�-��z<���f�q�..J��*W��נ-7�z�䞾;��;e������8�M�'��n��j ���B�8.�|�l�Z���M
0�aOd��,,$Lі���xwvƣX��ī�=��I����{�0��<�Ӈ�te����R�sl��##�KqCJ��0ĳ<��7t5Wd4���+ng>��ۇ��Y$�!=�vܱD��w�l��r��s͈���&�_E��i��/Y=�ל���e�K�<���$EX�^CJ��/ұ�s�4�J_�3�5��KSD\���6>��$�Y��ٽ/L��m
=D\3_/��q�z,G��4r޺�k5!(o���C
�<�1��H����q�ѧ���'�r�h8�Nn��a8�K����q9�O�`.R$h?q��+3�	a�U���ק�[����
�!ـ��C��g	���/
�30��o���1�k'5{����ta�<4lq1:bGج>��s����i}����M������%�>/�Z�l1���A+B��~�~�۽�A��vϟ��U�;���9{����0�:ӎ�S}��.�;��CX����s�PC�<�j߰��f
.mK��S�:0Uy'S>�mv
���籫�=�*��^z��u���)�_K9�b��4qm���ޮ%�O�z����Sc\�WP�l��6K�K�y�u�~j���MhϽ�wצ&�7/o`2h2��p�o�2����{kö2@��͐ox=i��}n�2,$�О��!v��w��)g]8R4�mn�T+�o��� Ubh�f��m�}z_�hP�V���m�Iҏ�wo\�߹�8�g��j�7�7��B�����pC�(=�7I�� ���Ӑ�a��@��ct�T}=_�4��Y��Y�'߾���I��������#�t��1��f�M��o.��� ��z�2�L<~Kts��A]\��(j�ѷ�|b��ش��ӻ�S�� ��f��Sزp�u ��1��|~��ڇ���::p���:�mX�C����E;Q����k��GL{n'lg&�D3C�p'�H�<�c�{�<\�tՎ��XܮO=ݡ=������p'�W(!0��G��xjn�Ӂ���n9�7O��	-��B&oW��z��&F�nWԙQ�BSa�ɛv���&��<z��T7������T瀃���=�t~|j4*r���c��ch'r+��Չ�N�nk�����]>���jt`h�Ӝ*��:�߱w!=B�x�~!���!ч��뤷	�PS��*Ӄ�PvٓAD�g!��M�s�4L_S�#^Q)ƽ�]�m�J'�e 	�v��L�rC&��-H&�S��S���ddq9r�ɀ�*z淳Ǻ���o�Rt%Ժ���J���0tb=���C��Q�Ȕku�Bqƛ    ������B׹�#��o@l;Փ�!�bߟN���Bn#=�+�;�������]�s;;���b�M4�[Ƚ�g�/�vlI֟���_R�0/q,v�ZȽ��R�dL���$��H,G����=�ڤn-$X��>��k{9N�g���]���S��N� Z�1`&��"s�����[\����*!gq���C�Ðf�L�i�*�����U-AH����߆�Ӡ����%
��1
��ă��n�^�ޛw:^$s	�	 ^�m���h1�!7����w���m����H�Y\OX���@z�*ܣ@�GF��R6��s��J�Ɨ-v��-�Av.�p�1�����>�1Ĕx�׳����H/�υ�xy"�۾I���+�s�D�vm�b�1E�^����%p�p5�p�{���߰���V�F���Je��m���|Lg,Mr���@.�7�m�ҵen�ȗ�W Eq�	ӑY����x�"�`6I��S$�dUWZ�:R�i��B3q��8��؆8���D����C���x,4�D��X��<a��dg�膲�W�L��͝��{�v�r��@�Z�}��E���D$f�������w�j���,���!����#�}|u�D���(ʰ��Dk�&�}�2��@; �첌���@7.���F�����HR�JAq{̩�Cc�4���O��QR~j����r�D�#;�o�w]5�eS��\z<7;�,�1�z$��p��/
�3�%���K��I{�%`��2t�<����>�rr�'o!� �������5��M-�����!�1�^�+5k�~W3��j7�}��)~nGJ,��0�[��c1zO&S�g��ׁQ�%SkD�.h�� �hn+����pU5��ج,�5 �Fr8��bC6�"�|����2�Rb�����T;#gq��6H�c(�O4�oi��J]�ˋV��{��k���� ��c0n3�΀����l`ű�tF��b�%�1�bHɽ{ғNx�B�U���!����-a`�v��14�]YqMn&Z(�h��/F3��z�F6�w)�7hs���gB\lF��+�x�]���{g*E�qzK�&(�8�'a� /���u[�5hє{���v'"�1�)ӏ4z �����b�d5�5�5�۸8�fl�%ԣ�ΟE�	r�=seP��W�ٸ7h��'����~�o�H/qg�!�ު��o;[��Dn?�C+l�Vj�I+}�:z,��P�o�j~_�����zᵰ`�O�d3�'WQ�y���$�0Fq����z3�G
���d�i���v���������b?��ŋ�Y'�Φ����x'[� O�1���`U��Z~��E~�W���v�B�c��yL��)^�8����"�.�?����x�w��żQ+M��h�%�����Kk1 ��1�#�,��Mƙ��ر�Z���"��_NrQ��V���,�ы�K�S��Δ5��Wo��e�r��păa1����$����}�e�/�;Uy�_Gͳ�s��	�T�v=H3b,�"j0�M Ö���gl�m��e�m����K	��G��|#m����H�� 煱����ē!����0��2 �%{ܿ���!���˩��'��0U�� N�J��xGbh�-������n�F��j.���iDT����)��g�`0��BT��?���Ftj�&���ϧ��	`�V�������M{��c���q ���»˩%˱��ø�/��;F,���ZD\]��Oib�3�5�ee����!ˀp2 ~��~S"����e��q����1d8ȟ/-� S�� ��3��_��q� �~�f�h��s�>���<ɶ���#���d\E�@�۟�T��m�ǣ�ԁo1�S�u��.6ep}/G�Ք�j@�Tc���i�6!g��qi��*sL�R�g[S�v�o
���3���"�c#9�9c?��S�m���w۶�J'^v"�YTC 匡�3o���/qM�	�1���:k[J�6H�Y�Ft2�(�L�<��J�m_-l�ur�����0kp���Y��׏����Y���i=�w&�3_���0��(�H|ۦ�-�~�Ӗ�Ty�U\�u�.C##������}O�ֶ75}CDLjdB9���>�2@�C���s6^���
���pg��D��Qֲ�t�o�l�|�m��ׯ�98�ihf:�U����#��lN,`�L�O�.��"�N��*Gă�{q�`$"f.^�3��'Ͻ^L��0�Y��=c���J�n��~�I��;8lh<w{=��#>`���B���$nB�z=Ͻ���l���)�gIy7ߙ��fͷq_�VN�F�K�M�B�u��ӳ���y���`�!��A��M���C%�
��kK]� ���<�0��Q���aG�MSf��Ԫ�5;I��O������ E�	�Q��NC�yM��+��k):���C��o'I:L���t�z��1-"���Hqy;!Đ������4!���@"N�]çE�5�xi�BG����I{��Im��!�Z�:�����l0:0�Q�-V�*�E�&�� ��	���N�;�v|�N�$'��p����E�/�x�pe���s��WSĵ�%"�f���mp�6�v�M�O�τjų�-���^ω}��^.p/g��Y2�1)ߤ����k��� C������d���2�JA".'|z��[��gP28�!�����/������M���}G�5f�t������ݠ�p���4��P���q�t��C.5C��"�A�A�"-N�Ҿx�7������?|m0���MbE�v^G��"o�
u�A���}����e��o[����?t#'8Op�`����XD��k]\���3ͮ��OJ"���t���P��66F�/��&/C4m�:o�,�%� ����2�+��7X�]�A����z�,�b(cH|[�3�܃���C�����|m��b(sH�}�P5�ݿ��c��K]��n# }��}�(��#q����%\L���t�|=�c�$���,�-������gANS$!�z�z�U �~qa~�&�a�*'`6�T�x��S���,�!��7w�^��=���0�L��K�5|��k`��cR|d�ɑř5^R'r���!̌�z���\���rd�\G)b�l��#�-�x��ԁ�\��;A?غEw�XGzF 8�ে���>�p�����(w��Ҙ�Ax�:N���ړ�f���Y)�N���^x�N����0���u��@��)��-WY-��&���97Kuy;;qo���>5�9��M��#��5���:�=e����Fx�Q�H�:��Zk����-l���ğ�=Z����O�9".6�FN�N���3�3�>DV&�	�̉�'ou�;Y�v���N���I�fHg5�l�)"�/�o0r{v�n/6丽ú��D�,��&�y��}�!�U��ʨ��s�f���`�K�Z"�Eě2��*$����H�7��������3���ͨb�_�x!��U�օA�2j��x�`�$����(�s�N�R:�!�����j��e����".'���2CFKEb.`���R��O�m.��gB)s�D\�����"������z�=k�����oWxi�OHk`)���w�މ��)G�$eV(G�7 ��{K�|#��G�O,(��IB��#gq����Eh3��-����okiH�]�m+C\Z&"��J��|3���D���f�}Z4ߟg�u)38�,��0l�{I�P���|�ut�V�\�4�:���C�؅��!K.mY���o���	����? ������v$��멋}r�X�3�{�'ʗ�ȡ�L"
�����<}P/8('Q���Z��N^�7 �|�I�Y\�>�����D�����t�H��2�״d��=7:)\���<#Q����t]�$�����/�bph�ϑU;���*Et�Db���(���lb�A"�y��"�D\?�gdkhk,�͐��u�    �ۡJ"����q���jm�6j���/;�|-���s۽)]���r�����_F���'�3 ͱ��xIM���MpT�=u��F����g׸�������(k4�=�����r��im�xS�/_N�X��l#�p�����{�E�FU3� �"����ID��c�n���.#_��3|�eC܏#�fqM��������pk�tS{9q�&l�H��7���xj۬����ŷ�l��K�y9_F�4­	����ۥM�A�k�EN����'��9�'�ؒp�(3��f�;�$�P ��p�+#s��'W�֒J8H4b������v���ak"�\��-^����kp<�.#7U�蘸4ŪEtQ���t��4ȡ볊#�q�A��M"g@ȓ��l��\[�9r7��O��`8*C3�[W�V�Y��bzV���Y�������Ɲ;�R|�h���_�|�⚲-D��x�����;Ǜ��\-^#U\���2��b"��m�K����`8![?������0�;p���ZϏx�'�{OT��Ndq9b�:>���n*�d��~�W/�����t���Z� UgA;5���j3�F��pnK�D\K�8�v���y��e�JDU|�D�]�갏���MWU�ns�D\T���������q��*WUǧx�&|���b��=����˳��!3���4�C,\���	eZ�s��!������k9�E��AjK�i"�'{o"-!>�lgh�v'��t}}hCwH�<"b?���0�HЬo{?��hŏ���cۭ�<,���͐����渴JB��]V���%RN��y�y2a>�+��������1�\^.M)2zX���Z	`h�2�sF-`GZ�B��RN���$I�i�Awo�y� ��2Ƕ���"~xmۮ!������΀�崌̧L� ��L]���0LedKK)@���Q�T�RyDă��P��I���gq�vq鞇�kP !s��K~2z�dl���@������C�<�}��,Le�/B���w_g��mp'��,;2)�����3ߧ��� ���
�Ġ���w�����т����O����e�@uZ�'a���t��FM����k��`��,&��6>I&t��>Q��S��j}�羻�`4����K�z'�/u^��9	=��z��W�p�[� ��ѱh�.C#��z���<t��=��f�e�&�Ԗ��^Jkک5"���D��$%�swI�nE�5ܑ�hv�_[�Ќ��c����@�]Q�"���N�qE|Y��/���<pn��u�6C�uD�!��������Mga��=���zB�&Z�Ѩ���qQ)?l���tHz�ag�����J	�\׌�X���ⁿ`��6��FWhB�}�RTq|��V�=$)��{����5mz���h�G�{o��r��*����?YJl��/��mLaw,��3Z�U���>����������Mz��ݕ|Vq��_�Z�
�Kl���Nc%��o#�=e}�D���?}f���}_�'��n��f���hdq=b�����>�Yv�tCV��K� ̈��m�6oJ��������F��?�k��;'b�*�#�7d1�3��vpp� �jCl��F��������E��������PX=�J�~Ҋ�]W?(�$1�3���tG��}��ܛ�"�n���v]���%v�0�P�"�у�Ű/�E�PH��#"ޕC��3�����[8�D4v����#�j��O���p��G}�[E�;��	����� 5�3��n�a#p;!lt7�<�b��C�;sW��nŋJ��"� /t�w���6����vW�o�눸���1��A�p�Ɠ���[(nH#��h���!W�]��lG���5��o�q�1�4=HD\����z��k!C�p�َF�i�6�i���������<d+��~���F���`D���x".J� C�p��n���`#H -�~�^��\�N?�B�no�n�F���wgþ�P潚	".�cQ��f����F	��b����T1���b�ӥ������.���ȍ���z'�a%���k(w��7�}��}^�
=7���6`5�%D\k/�yn�>�Gc�ׇ�i˄2�#=H���v~|�� F.�M�����\
��6*'"�*. C�7q���X���klF���8��?\��ݹ���X�YsD��b�4Y��gqU`9;7qg�g ��F۱Ci�R"�����ԴWz�P�&���p����޵k0�E4Q�[�&�"G�&��beg\�2��}kIo�oW�,��9�H�O���>����5\��A���:��zd8N�&��z�TuR��Ėb�/�����-Y���/�2��b9gHs�؍qP:�Seɷ�z".����$T�6:�r�P��ͥ6!�eVE��o�$5�`jp&����#������"�;�bHS�(MMD<���"F�Y����'#gq�m0to��&�c̈0|ed�e� �z�wb��$5���D����ڜ��x��Cޟ�(v~xHO�(=M�|��(C����.7;���h�o��V9���,5�mU26�%|F�Ka���8�}e�Su��1�m[�Iϕ����	zYF�L5�2լx�A=�nυ�X� o��:���C����;Ϻ7����se.�#�����ryi4�@�}�|�;�[�@��ճ�Z=�B�]a�����l�Vѻ4C�P��x�;�RC���+�wUf���йlx� ��₸�N2��j�
��h�	�~\�U��e�&��]��8�=��)ｭ��hK�K�j���&f�5F2�8�}�|[�3���Q��ۅD\�[0GyH��4w��/�����3��@-��*����ۡX�$�Uq����П�z�?��*]��*�U���EB�.R3��7�Q�W�kRrOz�rx́CO���\�H��c��}�;7��y�q�X\�a+�3�W�Hxz����M	[��ff�h�l>d�q�{���&|S�NX�Ө�x�UqQ��B���j��i��͸��ks�hDXR���p�3���`�|N-�0�ٺKĎ�������z�r����લy_���26AJ��g1:�!ˍ3�S.�6ַ����n'�iq���f�OM-��8�=�r�\���R���2��#��O�'�A�^z�]��t�����/�|�������X(C���ԃf��A"������ �ؼ��7�0+p7���ah.�s��I��I�D5С�������q�}x���i��ǫD=�U��B����N��2��
�ӹ�����Y�߶�,���!�� ה�������zH����-���Zr���+CL�#��MK�~CFg-G~�n(�M	�Y@�Z�{$x�2�yH�����[_�v�7���I��� S����z~�~yhCoi=Gn"��ߠ��S�n�/��X�ן�^%H��l�o�l/�'��5�D\n�D��e�2WƦ�MF���ٶ�l�Pk���p�o�;����;6(Q�ط���N"�����A��8ǝb,�!V*��0�^��ڙķiL!��A�� �s�%��N��2ɹ�����zҏ'N��!�s�!*3FvB�v�8��x���8/t����X�i'Nxk�q�\P�q9��-#���7���h�}9�>G`k� �$��.�q��:�u�|���L��:����N"޲"�
�o�cO��J���Ed�(��k( Cg縳��7#��4���6�����	�=$�q��9=���T/�ꔕ���U��==��o�o���ݎMIdp�m�#�y�l0C���3�3*��5$�{�O������*�@C�G)p����j�_�EN�-����G��	m������J��� ṕwvD�����vg�sK^A��@��R>��{�;h�;��L�b�k��������� ��48�_-m1Z
W%)\)`����h�xϕ�Ea�8Jl�}[�4!7}S����Ԯ!�-����[��VSZ�xփ���wb���M��uD\����,����QV�    ��"�p���D;l `��<x������&�`Ek!l7���Z�UPD\?��?N/"A ���N�A�B`Î���#7ԑD\aߟe�(@v��6��x�r��R�0uU���fh�7��V�r�=��N¦9���E<��� YN\`FZ��-�:ڌ��.B#luoq����g	���Q��x����2zq/��Ѐ�������[�"8@�GO"�AJ��α��û��U�w�육O��q�n�j��B���汥t�i����x�\[���U�����Ħ��$hFf�/���{�;}ah|���G$�K�j3 v�:>��W1y ˉ��/���[=3���F����$8q3s�� Dχ�(K��hҹ�ՑW��M�̽��Y� F��t[�"�r�w" ������,j0lS��2E� L)
V���5������b;n�����]3}/��"���viS������=�g.��ӌlI�^८z��B��ӛ�ӳ�#���2�3ǹ�N�pWs,l�3q3�w���]����>��P�����+��f�f����u�d��.�2.[�Q�[����w�Hk�f���m%@
�c��Ǵ W���C��������ϧ�s��|Uq5ϧ_� �@��p��:��w��&��h�[h"������P��-�'�'n��F�v��H6���-��� �B�½��5)�m�3� ��U����������L=��O-{_O��4,n�[HX`Cײp��Ɵ��}HK鑒9�*ރ:�B��p���-j':���>���#7�0�U\��=/-}H��!n�N&Rˌ�,e������CKO^�[,7M�A��\?z�ů��|ZXĲ/�鈍�k�ɫ�]GА8�-��j�P��7$c��?@���
�����+A��ȥ����x������������4��Ƭ��� �X�kkIСǝ	o����1���lf�[���!�������(���>F�|r�y�8L�h2�Q����m����G~<{�����?�K����ӧ/�=��c�X4D�̓C�x�c|)}]Mg=�9���A
?���F��;b;�t&�j�Ԉx{�K�(���!���Z��0`�߸���m���ǻfx%@.?y8�_�L��tGq��~�G���o1t�c�	J3kVC�Eě*�N�����~��#�(q��S��UqA|���u��{~8y�C�~$b3mȿ�~�B���w}��Or����  �}n��ϟe�R�x�8���B�Q���|Z�  ���!�~N�f�X��.^1���)�p��CˣDļ$A�B�﷌u�p�-��P�5���*}H���z�3�ۑB���B�9qt8�����)���y��y�������,.xezr�x�R��
����@�U����
�K"��/�K{���)��F��(�-gq9a�z;Ž],̫�;R��@|�Gh�%x&�qJ}��.��.���NH��v3�'ȏ�>@������Q�eo���#�b��hq+Fu!�j���k��b�9���<�:�D�n'�ʟ�����-���������JM{�2�s��H�o�����s�f ��׆þi
����೉�O��tC��	�B���N*�m�� �U �I��>R�xB��`�[^�v_K2o�����c{�г��{�*������T��-`Ų�?^e��xB��0�5�e��UE�IuA��Ժ`"�2�x�|�b�f�'&~�= �)�����Y\#��Nm'd<��dE��h� �n�T����=yfN� YO<a=I�q{�ݵq��`�}s���6$=�����|g=~�;؈?��F��7O�S��d'�p���2����>3�5���lTq7
�N<a:Iz���`i����X��x)����К�t��]��/����M�a���a��8@�o�#4k�:�b���n� �$�0%Y����8C��L7t���u��$n �D�=b�S����!5�7��^��^u�������O&?_bo���ʩx+`�FK���M��Њ�������xyk(WeyH�����η��X�%�_�Εt9�����H��-�ڱ�z���ەP�u�<Vݗ�������J���m�o~�l;�p����v�N��<,�r�ݛ�x����P��Wܒ�=@o��^ƶ0g-�ѝ�V��k�D�x�7/�M��W��|���q���I�F��ܾ!튷�!���R���~��,D��tl���jtݖ�a�N��AP�;��7m<T\�����'�q�[����܉BsU�O�Pq�ϧo�YEu:@�`���p�� k)�x�� ��Z�{�Ν��l����9B���P*�/Wb@��ة��o�V��<X#�\�x2��}=��։@���d�c�;�M��κ��N Ȑn�;���N�\�"���?O�Zro�Ж0@��ӭqѶa�� P�*.���>��v	�W��y�����{!F���!FW%�Сt�CN-�mW�LpAF�����.�wO��@�<G����;����(M�9*�U��������]h �w�c�0�����0�O�bV��*���
 =���@�X�@u6�Т�V��6q E>Q��>Q���xϬ�����awK�zY�����WqS�>Ķ��K�"1����*�I�g��F�O�~̐�{��VnSi��&����J�Y\���$3��#dž>4L����H2�;��H��#W�IVD@7ԡ_��<AK���:�@z1��3_}�{� �Hҏ�֝ϰޓN���6�G9hU��󑰓�æWZjBǒ4��<#��"jU�3��.ۗs��gH��	K��&l���&O�yn4�2n��M܇;bB��z�j|�2�X�%��aܑ��D�" k�x�t�|nzDB��G���,wY
��>�$^�
	K«o�c�IU�P��^31�>�ښH�����t��W"�]��ik� ��ִ{�W ���_��+`ۯѫ2���7Kkǡ@6?�]��\����$��_N͋v�\&>xx���Q
7#�F��|m�B_�/1�F�Z�����#ҡ*�u<tى�����b3��$&>0bc��V�W����ϫ�j⾼>7x�	̅X��~�=)ގ�i���x���]����A27.d0�����d0�[���U�C�Ƈ���������И�sS~�!{���1���D_�&8�g�Z��h����q�!{�g�f��
����h7@F�~.c�*�,�}�l�	��,�o>H4�TN�m5���rɪ¿���3�/�38-�����)��^��6b"��xf�_�g��V���,]�����5�u4�7qU���U*ty3>��+�� {%�ٵ�"�>��N�oB�^�X�$��mqr�o8��?L��~�#B��M?G�����z����y }`fD�l�t>s��%0]�DH�f�A*m�����hփ��Զ�ϐ>���Ś:���;:w���c�Ta�71�2�ؔ	���>]�C�3�~��<r�t*R^��1��rL�[0��Y�8t��oC�9�4J��O��A���f����{����܉I#8Q�'�Z����m\xnT���[�ȩ���`s�>V*ޣ��k�2~an=EҾj��5�S�x�![i��2�z�M܍�!��_�V�7���ȰQu%㛛uVT\M�|�@�4�}��z�K{�տ��.���γlV��*������@ƣ���}nI�蝋1&�i?O|f͘M���V�I���ϐ� ��;�]��/��3�k�mcq�@�֯����f��7,���K����+��ǀz�M$���H�휸;?�giM�4q��I���4I� �X/[�v���� �r@Z�@hM`�Y��`B���$ ७��E�--�d��"��1Z����[����H(���zzhF؄�'��
Ԥ��=`7�J��/[������ED�����C�4��ތ��0����r+9wSl���/� ��	��Z�cc<�
s@\�?�Њ*.��?=�f��@�E"    (�j�6�C�9��� ��!K�W�_�w|���SHx[������sj�m�fqu"�ϗ6�	����Q��l�;��Z6�d7F:��A�C��U|�]��K�w�DHa2�|R�L��;��'mƽm?H�� B q��bhH�qE�&��T�hWq9���������A��4���rtB������1�*.�+eE	 ���ݴ; "pu>������Hݤ� ��+(B.�01��q�9=M��;���h�ɩ�S���y�!IDP<���#�YM�aw�:n7װ���x8݋,$�D
ג^?�cy�%`�ϔ91��g����r ��	�_G7a��|�3Ųz���"/�4�&��7b��B��Dͣ�AÌ��F nBK\@��lc��SP���g|�cl�y�3�	�ŷׇK.{3�0U<m��dPz�Y�U/��6����_~4�3gH�������k��ym�/e0�x!yH�<N�{��x�|�~u�y��tߙ5~��/����4kn�{�do{C�Ϸ�c�w�������{��� ̐  n6���p$H����	�Y����n@
��yl7HYW��t�&��sZ¼��ăr��/��i9T@"%�{���o��DJ��i��4As��o�3�J��J�b�N*�#�R�!Ͷ_�����r9]��iS�c��[e�v�2�e�~�������{�ЖT�������|�h��j��"E~��"h��x\z��ƟI�Fp�t~k)�f�n�ϼ�5�R���B'O�OG�'�]XP���-�/*���,h�)R�������-s�^�����۶{���iRH4��F��㮵|:��c��7P$���`_�����o�_���H��H/��MUŧ]�;�Y�uw�Q�|JO�ۛx�d]/�,�����}���]~��]:~f�dNZ��
7i#��n&�8�f�/S�⨳�^���0����{8O�#F�)��B"Vd0�a�ea�]�z	��wxl5p�j�1-1�(�.5�(�fH���ǟW��4r(1�؞kt���œ5��%��Hv���Ӊ�)���!���f,~���;�Mr��8&R�́�.�868Ms<�d�K
��ұ����~���)֐�J��=Vy&�h��C��gK�H���;/����9"w��-:o �F���EΝ2�:nRղ�&7)����Sj�qN����'�!�A���`W�9ެ�!nr���L��,����%
X/�XJ����v�<��l��M�8�mhJ��9����T#V�`B:�k��f��`]�$B(߲a�[4�y���71���e���^?h�뮟;7%�Ր`�?6� �'��v��	�%�����9� �lJJ_�m�CZ_�z�2�
�o(��h�Ă�`���S�|�B��@�"�A�!
�oR�& �V�l����""���q(Pơzl�G}x�lI�IЩӵ��,kB���	^�M�=�0u�δ�mjA������i}I�^�c��2������\����1�ʜ����߾�2���k�(�!+4;�r^Jx��������i�4�1ϡ#��0^K��3ó�x��\=]y�� �4URRP@'ƠJ8`����cb��|�o �G5%�����Qŵ�:�c��7��v������2H~c��]��3e�L��2EǦ�W�B��ฃ^n�J�Oi7�)���$�Hb�v�)��H2w{�,{�Nts���e�c��
�6=hx��x=
�C���:.�c�B�m\k7�����R���9~�F	�̾��[*^�ƕ���z���`��<sƾ3=KS�	��)Gr����4?����w��і���Nzlx0{�lZL؜ik����V%U��Ҧ.�	�=<{{����z��/�v���	u,{�H-��k�0�3d�6�Bo�\�}j��H'<�!�t6�r��<_m��=E活L��L��?J�Y��	�,��1eQԨ��v"R��a�ԩ!TX cEu� F�ҙL[�KRɇl��S�!�3�<blU�;9Y�@����̓-�����r)��q�!�)�M-^~�ŀo���N�ǖ�����~ �����R�-�u%�xpi�ٓ����N�@تX����K�Ѓ����� �f#��S�B���r�ym�~��<!4�d}J�M���wO�0d��ŀ��Mv��ڻb�[[�Hh��|;^��?� ��=�+#��q�8�~�E���KLi¸%��
�7YY �X�3?�[��t�ǲ�i�s�WYUeO��<}má�@��m�Ll����l��V)[F
��@Jg"�u0cx�[�Ƣg�E}�s��F>��n��cd��/�6�r	��5�F/����:^�V.ׁ�.N,
����u��),*���""a��)��u��nQ~^#�j=Ovg-� �O��^�������z������S�&"f��e�m�k���6N98���^���z�5�d��c*}�g6/���RW1[���zyj���=E���D�mG/%�T^� p�7��G/�6R�H���v���9�t�7�H[�������-�,�`(P����u���cg��\/-gK�׵������S��Xj�@��@y�"���8���2��pqf�>:�o�C%�G��`�BFy�
� G��7%9};�^(����[�i�c�=!�&�QK�MD�s��M?��������<m��)W���S�EF`Krꔨ�;}Jˬ�ǖ�^ �M��7���>r��G���G�ũ��a$B��m��W���j_�=T�U\��hvm�D=a�\��BO�cӬ�4����)YO5d�	s�����7�lɳX�O�/d��RS���v l��
aa�[��:A��|	�JlI��r�	�X�/���Ԭ�Z OOX0�
S��+a;�Х\���q���p�&��{�@�4rp�߶��]q����������2z�����nt��I7ҍ���ᐺ�L�<qm��m;W �"-�����%�R���<a��J���8t/��)W T��?�#]Q��,��-���64�A�����t�1
w/V�I�E�,�b�x�4�����RXL�aP����f,�_�7zc��8�q����F>@o�T<�������х�X����;�&͚,KV�ꆩ�:aH�T=}�\_y��f�/_,��=:�����NG�:�-鰉ׁҏ��Ȳ8T�F~d����5�����s�44��PM�0� ��dP��&��Թߘ�d="�(�����������}�>�`�l��N�� ����Y'�ǉ��8��j�=8?j� ��G�bm��Ĵǥ��A��Yq�=�BF��0#õ��c�i:��4�w�E誅X�hK�n�pFj9Af�ݠ5��ޓbo�T��/��Ѵ[�l�d���^�J��l̊��ب=%�eY�.%Y�x��A�@��܆H�A��Yq�a�C���Y2�]Җ~,&޷C>��h�4��9��fU�W3�s��r�G��å��C^�Yq/h;^����'���B)"^O�o /t��;�������a�a�9�MKI�/c�LޔXd�྆0�ւ�`B�`2s�f��RS���b�J	Fsg��~~�>��X	��͊�Wpg �xZ<��Q-^Ӈ��!�X<ȧ0S>�!� ([�H��"YM�ԇtұi׶��.%��A�^����q iXfJò���qp#d��+�f7[��Դh�������*���F��vԜÞ6'��i�Ӗ1m�F��D�񝨗��V���'wLp?�4���&�[��$b���%�])z ��ȧ��k�ϣ�v��XC�v��b��kt��q���e	�|´�v�i)�N$?�,�̏S�����8������`��wlٸ���'�rY�~���;M]*n����N�K�$�|��\�t�\�L��M|�j�(w3�Ļ|�5���a��y�&�F O��c՗D)áCʲYs'��z�K&�����?=�&r�Κ?h�m,>	B�];��ܵ�]'L�eD���^>5�$��5Ҹ��pHߓ���$�G~ �  ��i���X�g�5$D�����L�l��e�x����LNn��[� l�`��vk8�G�r�IYW�o��M�4���S_O�/�s���e�<��UDW��㿈Y����zʫx=BF��2����soO�R��"`M��{����m����L��"�[�X��s��J�+;{�P�Dd��"[q�-��o�$|���p�i����u���v���Y�����	����G-^c�I0mZ�Ȕ�#�8Ԝ�?�ȓX���/vJ<�q!�14[��I���<'��t�kTa�6�N�vۆ���k1$��)D�o��*`� ��|�JD��7��:l;���N�����4�����Û3�L#���;��x�St�&�ڈWmܚ�����׶� �n̔w#^:=��o��4Vڰ�q����K�eg��w~��9�r�ڭ�/$���|m-�zj��Sp�z��aݕ%�"eH��7���.k�'�����Dގ���_/_�Vc��2[~�a\%\0�*!� �xS��0�ƚ��x��-��b����'�=m3�b��4,��v8�kD]�z�5+p�U\�/��;f�Tu��a|$�����ՠ�V`7Q9�������y~@v���X3Lw/~sؗd��MG$��������/�GA      �   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh            x������ � �      �   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
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
-Pl�#�x���Bԩ�E��&r��Z�NM�d:ܖK�/<8T(Fo�&��NMd·��A�Wx���B�m�$�9�C�(�D���~!M��6�����κ\n;8k����ξ����y�^��BM��m'���m'+f�m'k�m'++^xp�P���m�$Q�vpҖ�n;8�j���;Y������S����؅�=\]_r�[���,P�"���p�(���߿�?Qg%a      �      x���a��(��׬�n  �`/�`���gpU�3�H�7t�ȉ��A�'��W�Z��v�u������ߗ���_?\y����=m����m��?��0r�Ȍ��"�����7�����[B���Ϯ¯�������͗R=�:���ƻ����m�e�yIk(a}�B7�}�@ߟ-�G�#���Bb�z,[��,[��'�%$XBK(`	�C���qW����U<Ⱦ�Ċ?��-k��d=�u���ϊ��
�ǽ�^Fl/#��/�ȭ^ekBĚ�&D��F�C	�P�:��%�C�o�X�֡�u(aJX�V�C+֡��/�)l�BbRؾ��:��}� �5k���U�|A�J̅s��\01L�s��\01L�s��\~]T �eK)�`J/����)�PJ/����B)�`J/����B)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����R�@)}��>`J0���L���S��)}��>`J0���L���S��)}��>PJ(���J���R��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0�Wc�-$�!J�՘|�u�Rz5&��&�>J��mL����C����"K�$.=�½H�8��;ȁU�A��h���#GX}�e;��;H,�n~���$��7� �l�')wu`O�tr��vĊ?9��u��7� ����s=����q�ގp�ά�ގp�Ϊ��r��w�x��p���n�AbM��$�sG�y��c��$֡n�A�-��7� ��p���7� ��p���7� ��p���7���&`���wȡ�{ ��P}��P�cq�$\(cq�$���cq�$4cq�$�-%�cq�$�-%�cq�	�OR �*��C���pK��Ii�XTzG��W5'��c�qbKB)�X�x����Ǘ���unO� �v�{�VRY�h��Ӣl�e�|��������?%Z��+���-��F�"uZ�韸݇=�%:_�h{~z۝,�����sO���v���pl�����c��$^�z�E�w�x�Q�=��A���c��$�!J��"�;H�C�z�E�w�X�(��t�|k��C���@(��H�NW�`�"�;H���"�;H,ZJ��"�;H,[J��"�;H,[J��"�;H,[J��"�;�@�U��E��#���l(ҽcG�`��`,ҽ# ��\po�kb,ҽ����[��t� ������H�˖Rݱ�˖Rݱ��ox�Q�;�A����c�$�!Ju�"�;H�C��E�w�X�(�� �|k��~4�cr����і=�"y+ۘ�� TjO�{s�ư���5l9�6��Ҿt��5�u����w�_�?�tҥ��.�����#(�h.�{�}(i�������}��_ą||z������ſJ�c�/YmU��~�󺭣.�K�Z]�}��6h�郿�k����OH{L�*>]�!|�Yp��1���t4Z�M*�^*&I*v��*��#2���d ��4���|DR�I$��ё���@b��5���qW���U<H�a�R9�kV��H. ��\po5�1N�[�_c�[=��b ��Ӽ.�� �V� ��S�H�sj�%�LcҼK��]2�|#�:�y�$�!ͻd �i�%�uH�.H�C�w�@bҼK��]2�C\��i�%��0�@(5���*���` �B�s$���` ��3$�%�z&��Ĳ�$Y�D0$�?I����몙�t�=�ä�U�D0Dˑ|U�qR��g"�Ė�O=�@b��$�&a��q0>�����~�4������q�`ݣ�U��7�X�(a�#�$w�^�v���.i)%�^F;���z2���jI9��L` ���%��z2���:D9��L`�D�	X�(V�	t ���L`t
VO&0�p������g=��@b�Rޭ'H,[ʻ�d�eKy��L`H�qW�V�'�Hl�)aW�	;�K���L`��:��[�]Г	$�-�z�G��H�T�崞` �l)�S$�-��zJ���k�V=%�@�S	%�zJ���:D	��` �Qª�H�C���)�7��Q�ꭔ �侧�#����C�{�.�����?~��?����q��ڏ�=�~|��m��������s~)y�K��q��ܧG���),.����&��UY��p��+G/������8ea�8�S��iW5��TvHgC���)�:z�)��ۣۥ,^�z𑱞�o����k���ˡ�˖���-j�HUM�m�@<���q~�tE����TN �l��S�h�Yc����'P�>�@���(kH��Fu ��Fu U��@��h�LR��Q,H�C#X:�N�F�t�L�F��/2��*��FjՁLS��V���fQ�gՁl5�Ѭ:�����TH ��hT��G�	Ϫj$�.����YU�BՅ��x-�1�C������x6֣Ou �U-�T���ϟ�����r�|��LGH�F�6ӁTo�K3H�?�FzԨ��R#=�S�q=w��|�㺧����I���Ӟ�ՙ�ҞJ}igs~�����/��X{����ײz��ڵ~���>ۓ���PHY�P��[��A�2���5�C{�]��l��({�(�a�ݹ%��2֠�zX,�{����ޕ�y���k0�sRK�t`���r��~�ꘗ(ku>��w��2���e-��r`��88�{<�l���I��9w�+������s��]]{(˶f_�����?zXR[�/���W�rq�l�7��e�G��A9D�c]yy�A/~�!���u ���M��ׁt��.7=_?X⽁�F�妆߫8&=�^ҞB_�@��p����:��=�]�1B_�Į�@_����h?�ף�U 5o�ǧ���K�����u]6X���ӮBo����J���Xw}S���z��Ħ�� ���A�:�Jz��w�w ����N�nׁ��}Czh���	�׮��@���@�9� �����A�+��d��Y��͏/^�c�������]��@v�+�����#g@��	c���?Q����苭����h��w���O�y����Ż�.1��e��m�:��oHR	c�����?7.���a]ֲ�8�`�B㥽m�a������o0����Jk��� �;���a��N�%-��.��vD'c^5����~��՗ e����֝����3?Ztq_6�Ww80k���i	n�T�]\�%�9��U:���M��A���'��������F�ov�+ld�lb#�h�~-[B��O��ĳ�u��H���Q�F���:�l�bd�i+f�yd#{�F[@|:�i�����b$���'Ȗm�db�.�h7�Fb���\�H�ۮ��Fb-�:!Ld�'`#����Fb	uɶmp�Z�f�OU0�p�J����[���`#�8�-Q2l$\)J΂��㤇7%m�FbM���~��I
�]���~��-���0�9S�`�Eˑ|m�q�Ӣ��`�[z�T2l$��n.���%3��^6�=+=_����^B�=J�A�KR�5�{Mj#��@ن��`#�-�<EIm�-tc}'1�W�����O65Xϟ���X�6�F�%ֽO���ПmM�����*��=�K�-�4��S%�l�/�^���-��"��O�g���������\k2�m	i�F��h�?}�iѻ n����������;���<�w�bZB)���\h5^=��x��򟣄G[9~����/�/�ϭ�=3?jW�T�稃�s��%Ĕè��7�'�>J�]\�d��s�?3#�-ʶ����iU�M�����T��cO�O1J-߾�,exb����񟉩e���(�6������b�S�o�m����9&�G�B������$"�H.!�J.���+E�F��x���$$    �H�	���I�?I���к+y	&=��&�k�����[@\׹��R_���`#���o��,{]c�I��J��������)�
6˖��|�7�ΨN�Y���DCMJڂ��:DMJ悍�:D����`#�Q���/����G���Rl�}�J���<j�}���c�=��D���L[F�T���\{��J��
|~����@�^a�d ��jYߩ�\�@�y̥I��u�\��C�P�5;�o� ��f��.[��I�]����(���"����V|ʣ��������cЛ�WĘ�����J��b�~K��y�[9u�R�K÷���]����O_�ZRf�������mi���rP.�t����Z��y�mQjG���e^H�he �h5�!!����&��mh �7�������ծ���> *�F_*a�#����zX��/�@*'lC@\��t*�ϊ��j�8cVT_���<j�ӣvJ6�J��ī%~�A|*>A����g��{�	"�cU���"�7��������3���i�8��&�_�@>�&><�h�-�e���$���2��Q;���4��/��|�|!	�Cz����ㄖO�2�p���B��R=_�@bM��C�2>I�������B�t���ä\E�2Dˑ|m�qRޠ��Ė��=_�@b���$d*z��1+ʭ���@%_�%� -N�@b��$�(���$�%���B���W5_�8�S��/d��!�>}�,�z��q����]=��@��I)��@` ���ZO 0v�	X�(�Vt ���@` qg)-�$��=��@�'H<NJ���5��r5���$�B�'�Hl�(�W�5�Kz�! ��\po��AO 0�|�ŗ�z����Ť�=��@r��u�s=��@b�Rb�'H�9�uF���@` ��G=��@b��QO 0�X�(�$�!���X�(�F�aq�SIO 0���k%N_%��p�)���7�CFJ��M%��'���3��@�#�OSO 0��C��J��Fm�$�X:`���0�<	��7���+�N	�s~����>lݞ�-^�J�����V?���}�S�����}�ۜւK3[�a��j����������Sɗɬ��^��5�����=�e��6�`���2��C�C}�l�9y��7wjg�]��K»8���J����T�M]_�O[��5�:	~fߤ��}���}��n��=�Lն�����u3��e���T+�M�Z�j@��e�djks�m��*��#��S����s�w�>?U{�T	S�T��z?UC��Y��N�7�:R�z
Is�6��;uN�܃�L�MuaH�;Й�Y��[�� q��s�yS�4NuKM=��ܣe��Nu^ĩڛ�jo�:ҹ�L��9����4�N�`�s��4u�OS��:u-L���sw�u�|���}�z�����Ե�N]y�Z�jߦ^+�<ue婻L�+���t�Z�S��ԫ�w�:�
H{�vI�+1n��ۣ6~R�y�Cޣ,���pk�o�$��Q�".��m��6u-���V���2w�S�[���N�~�e�E*SmH���nsW�T٦����s/�֩�t�]�L�Β�2�rL�F��Ԩ���Y2�P��{e�E�L����O�z(sC��^����&�z�)s�}����TO�L�����+2��*S�Oejď̽>�z�.S�Oe�I�^��Ը<�z+S�MdjX�̽���$S�d�ݮ̽���"soc�T}��ٖ��2�nW�ܑ�=�L=9L���T���L�4�T?�L����so���ް���~a�Iu�m�L����Y2�O.S��25M#L�q��~�0׃�<�7�cqiaq9oя/-�onۓ߽_|)Ձ8,�|�\ޥԪf���s��m�$�ޅ��x�c��rM|��I�_-������Ϲ��Zq-���k�흸�oX��1�7�&5i4�1-�o��9�u�����6���'.e+i�U��_��8"�;!S�:�T�^�z��ͦ�'wsm"jJv\��4��ݮܺ&X�M|��6S΀�?k��fJ�d��v��7��m,�KKZ�� ��j��2"{<V���5��v#-��Q7���Z�=�kYGI}�Uym�b�!r���&�	T�ҁ�c�S+�h �g�$����!!�}o�xV�'U$��򌘁����-����vF_�g֌�b��n��zX��;�Ry}�W >�JqE�gE+�h �l�wJu��ڨ���D+�h �'�$^-ZqE�W4�JqE�W4�xԊ+Hl�N$�~�;�M�7C�R\�@b�j/H,[��Nc�ŶO+�h|Z��D�@(Q�?Hx�����ㄖO/�h �Ӌ+H<NJ9��k�jqE���J��Z\ѐ_�x����*zqE��&'��W4Ɖ-	�zqE��V+�h !Sы+�����#1P)�h�k�V��@b�j8H�3P��W4�ؖPn�W4,t�����?j�u�R\� ����Ɣ�ũ�0�xqj�1$^��"��$^��\�����k�>J���:�G/�h qg)-׋+H.!�zqE	W�^\�@�qRZ�W4�X(-W�+��@�Uh���:=����ƚƂ�� ���! ��\po��A/�h ���/-��ƺ�������/�����$�-%�zqE�7��(1׋+H|���Q/�h �Q��W4�X�(ԋ+H�C�?���ob�������JzqE	=�VqE�WԑZqE�JqECFJqE�JqEc�0�F���N)��#�OS/����R\��ۯnqE�W4>	�zqE�W4�JqE���+�W4dK#_�+~�����	
}+�o]��G]�~���I�	��p#(!2�V�� ��q-
7��$��)a�"ߺm��[D5�E�>!Y�Q�k��O��t�#�߈^�}�BS�ъH��>]Kl}�C���/f������ =�H�I�4_�z(�D�q�Ct�8���Ĉ^}�-$�K�Oz���F�-$�D�q���?S��!�����e)I�%��<&m�B������
��=�P�%�7
�{�[�����Zg^����ZOLûF+
~M��yW��p~	�V�p���g6^����ܟ����R������K}�R��fܯ�+�!�������k��ѽM�gV��=�&�^�Ov���-9�$��Oc<�՚ �O^@-�4�_��Ej�Ux��:.�V��Ѩ��s]~���O�&~|��ϗ�
B+�pt�Xjn9����ۊN=����d��wq9�
�R����w�jX.�VV����T�v�K�*��N�u��İճDT:��-��#��YB���<;Y$tpOhW\ɮ�[̳��ʎ�h�2�r�yv�Z�n�H72������Z���6����!ҍ�t##�`��I� i���ioA֦ =,HҨ�4�R����t��MW�Q��/�mz-	�	�h����k�OPL�D{�D����"(���n Ǯ���k��OPH����	b7�n��	r"_i|�B���}-���I����t�#��I�w]�	���S�~����ԯ>�y$CĲy��>A1��l/:c��F���~����K<�ّ��z�\����-�<�0=�%<��}���8�G��k�)U�۰8n��O�iX��U�;���M�y�:��cO_���g��7����w�Ҳ�\�����*����ј?�\ʶ:7޽v���޺����>O��=���CU���5&?>�A��[?���p}����)>=�kuՋ[�[7�ƅ�{ԕ��
��:��t���C�h�`�ܝ�|�a�\$��|f��։����ȅ.�M*�%�(R��(�J4o����}�?/�0�~�*��x�������`{�I%�xm��z�C��?N��Q�e]nm�yO�Pɥ:E��խPIu����R�~�[�-G�@%_��޺��_x�f.!�����C{X@���o�|��m|+O_�P�*��az}ڻ���7$�����-~�ߜ�zs�%m!���?LC������T���C5S�1���������Tr
�9�>:�� F  ���v��ǉg��Z�0c����`����v�i�M���8C������S�U������x�
��9��v�����%QRV���H%���io>�j�XS��'	�&�k-�Qbi�� �|(f���h�X�ҙ����Z%�Ԙ@nB�y��i�R�fC~Y+9?�V����,����kNv�ߥ\���MS�ih�6���Ay��@b��^�7�h�%~wɟ)<�(l��C�qX�W8�ahoiH�;~��<��8�J\�=���a���J\+��Ǣ(ōJT+n`HEIi4���j�̙hܣv5���쮝�R���ϖ �yq�E��Ȥ�a)��(��Ry�@�0��̛A(o����t�^�ʰ	�J9���S1�H{���z4�W|'�g����6�9�-��z��[|huk�v��k�K��qƥ�˕�{�dܼ������mM޻=|���oPbx���&>��������n����n���2j���c�Qhu6$6��#0ϖ�����AA��a|��::�G��a !���lH>N��E�Ά��kL��a �8��I��a �&P��Zg��$�RW�ZgÐ_�x����:�h9��M<N�ڣQg�'�$���u6$�[�Ά���Y��å�x���@�Ά1J�A�s�k������;��Ѩ�a �-�lK��aX>x����0����0�0C�7Z�cJ����I5�xqj�H�8)E��lH�8)���l;��}�\J��:��|�	��L����r�Ά��+E��a �8)-��lH�	���u6�OR �*��z�����j�cMc�RG@�� �Ά1�\po��A��a ���o��:ƺ����:��/����u6$�-%�z��7��(1��lH|���Q��a �Q����0�X�(��lH�C�?�u6�ob����u6��Jz�	=�V�����0\}J� �J�CFJ��J�c�0�I��a��::�4�:��b�7T��a�Q�(I�Vg���Rg�pPÅ���0z���Z�C�4(5��lX��-T�ڃ������^�թIa��d1P���|Y����u��j��߶2?�Pd�;&�a���0g����"�#�YV��8�jt�L�(4�����(�P�_�1��T���/�����f�|1c�dx_.�Ty�Q�/��(f8��3~M��w���[���V��a������Fx}O^�xy<�:V�WQ_�cbMkw����(K���ps��[�b��c}A�o��\������\��BZd]�˃<fsހ9kKQ���S��c�ߙ_G,Oٝ�	[�*�%�KYSeK�h��8}�x�i�ܶ�-�ao���Ԃ��c��إfK�չ-��W�� ��e�R�Z���JVGe�
A<�__����~	R���
����ړ�뵋�%�P3Q|r�+�Y�%�+~盆���D���,�翮jv�V緥���8<���G͔)�FL.k8��4��\_tgq��EW�댴G���O�Y"�j˯�IXS_"퍾j��K��j\\ė<.�����0K��2l:er��m�L����,�)�c~�l��{Z���#���S{&
q���&
��S�(D��ϥS��D��}q
u����B�|��/a~���{�(4_����(����6Qh-ߗ~0Qh��K?�(4���,�}���u_��D�Y�/�`���/�`��F�q0QH7�8�($���!M�����淈�;EL�AqD{;EL� �"&�ho����B��N�t㾈��B��@;EL�kD��N9�f�v;�L�!r�w�1���IY t��)�`�и�5M���B�0��
&
I�yS�+�ڋdx_X�D�Uy_X�D�YFޞNa�՞d*�q*�`:q7g�.�����l��c҅��V+���\n=R*���^}�~�z4=�۳���.Z��9f}��<t�G��31��x�}�{+5Nk�������;����K��>d���o�R��;~�װk�|�
���g+)�{����~=��{�ǻW+/ܽ�n�<�<���_E�tj�6���;�L;Y&6��� ,�;�f�S������ĭH�;O��(�γ��A-g�����u�ī���0s����l3l�~*<�mf���Xjњ�����G�P���������f��c�����G�T�|5�^���$˱��u���nұ�>Nr���m4�MMJ���B(4Z�$�Ŏb�8��M~	1��vtfNKR�k}o/�Џm=��A`ʹz[���\_�K�)����/��^�㬴3�'~�.6[�:�5��)-!�4<�5���|�s{�鴇u�ےݖ��y9��\kXF�5KN��]C�@�ݟH�|���:�q|��u��K���Y�V����z�(/���~t��S�Ʌq)n����կ���W�T��^k��p������L����ng�����v�^�`��n�l�k��bo�֠i��wy��*v�5�z{���iۭ���>�ztї-~|�(�v�~����q.��ȟ�&~�m���r:���5/��S�m��5M�N���+Ǧ��$c�\�ㆨ�/��;ᶋ��J�@5��wӮό׺'˖�����Ynʷ9>�͐
�].����nE�}J=al��&S\��ɏ��Pě�l��n��&�R<i�K�]m�W$.�g݇W��VL�.��2��ӒC�q#Ԉr5��͕,���"���ݕ?u�ޢ"�}�ΚC�y����j��������eB~��Æo��Q����עY��*���|��V�Ǳ�cTl��?B�s�n�mA���Xm���b��|4���o��]�a���mD���X�;W#�e�y�@���-)�e���fx(O�mb�vXm�����p�,�      �   �  x���]��6��5�b�@~��b�ݠ��Nv�
,4�2�Όm�v����lJ�(�؞�@��N�P�sH�G�y�=�N�w�����ߚߺ�F0!�c�;��� �������w�9���n�w���1td����0#�y��`#�_�+�#c�����y�t�͑�Ӎ�v��p����y���T�4���	����#�^�"���iL��0Э��ne���Ũ3D$F7�~�� cF
���!ָ�ѵ��H�#��}��ʷl������͊���F+G
�8;)�;������>ӬNApo�|��@����9d�<ƻ�v��Nt�v���ڌ�p���H�2b��� z�f�Ǿݮ�1[n� �)|�܄d��h�� t�2A�
�j� �A�f������m�1�43���(��݌Eo|�f � ���"PbFB��������R�4��hve"hp@S�Aod�"i^'��z�z��]��Hǩ�#��%yR�n��~~P��re���c�9�ˡ]7���N�&#���&q)�C6
�2
2�a�����C�F$
d`F� �5*q����u�oȩݑɦY�OD��8��[wl_���$�}�Yu��=/adc�D���˂�VUC�uCt�������b�+Q���~���jL�XA����4(��Ă�D�,p@,���X'g�f�� �LI���m�FF�����S�m?�}:��8~$�6�����i�6���I?�I���͏��]���ǈv�6�t���>U����������s�v7=4?w}��|���9����tqxد����<mL���6��0�%�x����}����Qz�̖�E�0�U���J�
�*9_Р�OQ� W�e�:?�l�_w��&V��B4�mơ/jr�a��}AOZ�,���D)DN�%��	ٰ�Ĉ.qag0pZÅ���g*�5'4�ȅ�@���l� R��Bt-�ؼ���.�JӬ��O�~����9
kj7GA�s��� ���� 	(�� !(���Q()ئ'3Q��s�itH{��4�f��N���&<���i�Zc�-�@�=k�
y������C!+�b�3(dTY��"6�}��l6dW�Ȑ6��w��S|�4�Գ�d7��A�6��A�6��Ar6nACtl|�lY�B�k�rW������Vֈt[U�*����lM����
R�uU"�j�+H@َ�x��]Eݏ߾ycw��\��]E�#л��=b!ջ��#��_�~�B�*0q;p;�`�|�F*b^5}7\&c��yӑl�}d�����ф�T����}eA%���S�a���<��N����Ò����&[��;��%�8A1���q�.���(xÊ�C{<�۴Xŕ�������c���-�}�n����ޟ�}���>��*
�b��B�k���/�S��S�:�n�-/F�@�΀�S�3�b�(��so4>���a�7���epԕ&�Ic͛)�N;
������<`_��?`��N��_�WB4�Q�=���W6�7�.o߅��6�	�p��ޭB����[u������9��E	��n\�,�s���hH�&�.it/�M� ���+h�ྠ�@��@s��ak�F�v�>��f��>QQjvF��tc��0.�R�}�0�[�y��b��"m:灸1��\�dMf���7�iH>Q���9����܏H���>$�2���&� /mF���$��}���
�+�HP?�d�%r8@��D�t�_����7q�ى���3h�y�[��F
b~ʍ��)?2��,R �s�H��������03�"21�#�0s:_�<\�7�
mr��VǴ>70�r����H@v6!�ax���Ĉ�n)F� �\��� �1:GA�c�BSt���O��Ԅ� �j������%�p+�@�y�\!�YU"va���$1�L�k��N�g�BT��C��c�(��		։���^���SQ���3��h�ىC��K�����A�+�aHX�M��B)���T�O	��[��!�#�*����]z�!��g#iMh�F#8�3�L�XU2ɖ�uwl7�T�(C񤅳0�����[�n������i�(���PT����}��H�ɇH���,����~���`���B2#cx^ߺé݄�S�?��ҐSȍ��|�t�}ټ���ӡ}n����IOc�(%�x������J��E&��$�~o�cK�O~��9���Y�t}ߒM8_�N�
Y �(A(}�|��l������.��"f�)�xq�?�Ǧϫ����32­O.u�<=���v��k���~#ɋ�i�~�vN��%�(D�Ҟ��5�����0�x��s�x ��v<��C�����;��M($�޹�M$zڿ��as9$�M(d(,�l�
H��s��O�9�$8,�%��P��.NK�
xTWJ^ �úR��
����VK�*0hd-e)�����i<\,�� ��P��4W���������s��zEyE�ĥ��2bnʝq��8�e0�π���Ȓ��z��������O��(��a���ؽn�M�[N�q��H�&�1��, C��Ȓ¤��b2&ψ�47h��9�bg����!h��T�+�&hqgkXԎ���(-�u�R)M;�ф�ƫω��(۳(�F0��w��a�Iޭ<\v+?ğ���� �P���-�2�+�b� Es	I,�����JRK��XвRrؚ��sR� 1'UV�%Q��;������Aw���`��Դ{||~q�v:;� TuI���\�`Yɨ�2�Rɮ���:��I�6�>��6� �<E.4�өu�ɝ�!6�3<';#K[�|�M��I��*ހi
'��ؒX�q�gS8#�e-+h�;	�~3+
`�V�,�g]�qeVCH V4L ��a�$W�������c�j �s������W�Ȝ<w7�>��i=�� ct�2N���*DL�JD���B��f�c��r(7͡�]�EH'��$�K�E`������zzVi ��<�� �����
{u�/����|!�$�0j�3�V��U�xh��( 
s���֙��������u(��'ƮA��@1^�"�W���[�l��SL�4z�~�K�2VFl!��lA��]�\A���4Dǜ8@���,D�\T�)�z������P1� �dn*DHͼ6|��+�qTվ��-X���[�%�)唨X�RN����)唨�R�)Q����S�bM7H)�DŦn�RN���N�5T��)�,ª�4%yH�)*8@�R.y�|M-���^!�KS"�vI�-]�	����mB;q�V̺���������Je�J9��ٝ�i��)+#P��1��>_���d5��b����D�e�A����y4I)q�h[��eh�W�b���Y��Rf�|��s�ƕ���>F�9��)4��0/�yC^s-f,�H�B���s��R����h������[&ƣ���q�]�f�?��D'z ���"��Y��u����\(]fG����K�0'�27͉�L�w�1��L�F4a�~Д�D'(�M�V4��є{�',�(M��t¢�9��jUX�AejYG���ʔF5�+t�;���z�10��i,{�����������[�i��f{����
.>�pl��?��kp�6���6N��%q�VUx���u��hk�@�9[[�ݲuK搭�W��9aǗ@�������ꔫ�z�N���ǫ\E��y\�*R��(W�;�P��wl��*>ȷ?�%Y���7)���5 A��xE����@��e�@}�W�y�0:�P g��DA����3�:�w�\H6�s�L!��=\�|l��զвf��Q��|%EB��^D��	��4�:�]d���F6b�����fvC�Q3W��[��92O���F�R�E��U�BgT��Z�f�~߾��y!D܎}�HtO��.̄�O������]?�      �      x������ � �         �  x���=o1�����́HQ���E�Ȑ�H�(�������I�����@���H���dv��P/�ߗ�Vk�*�ɚ�fq�#L�������S����O��rw���Ȼ����4��*2*'KE?�U�w����r	g��ۡ�B
}~�tz��0��0;`!&kG�U��˂{�m�D��eP�K6G�E4T&s�O�9k%�i`�L%�⺎��$�CخW�4*19$&Ik�IZ��]7��CV�c�d(w콎��f�d��"�����d����s�@�\�龈V�8;��k�\g�iش��a��q��b��� �$��猴*si1 �"v3�]����5�y�g�B�f�|]��� 7���e.7��>�"�Z�P�^�e�����ԧUv:�1�N1Vo��"R��m�ӧU@�DT�Cr�����h��_ N��
S�<ZN�"�,1}Y�(�x5��`�0�Y��Kemu�Oĳ� d���T�c�K�&�Ce���_�ݿU�ݨ�yAk�Iak�o_nn�'��j��~�C�_������V��w�O�ꆦ<�}�~h#�M��[�m��x���d�y:��H�"�Nnr@��D3��9-���I��F�L�A;#�2 CR�F�ô�dl���dsTퟝ%�Q&��`��H�,�F���hx���<�M         /  x���I�7��U���@��:��E6���/��.I5��l~����% ��~�-��Z ���[`��6��o�6��s�۲����?��a��_!���OKX�b问~��ԧ����^�)$���� �.8Q?*�&�'����	�J�u�S����_������;{ ������-�-��i18Wp
���8
��#r�F��mDi�y�0�0���9-���,��@���� ��8�Xny������
[D��[,�r�|\
�ys�_�C�ł���|r� ��x�����v� l1���b�`y���0��I=̝<��9O���i��X�[,PZ����߬/��Ӣ}��i� y�  �͂�0wQvx�����'�\([@	bTVL
DAtvyn%����J����v¯Y�Ǘ�$�9ղ2�� Q���%^�bST_�,=J��V�ʖ��e
ٸ�JQ��ⱪ0��e*ų>��������T��2�Xk��>
N�Wx'�e��$�60��u�0uEP�]�� ��0M>8%&~� ��n�<
��?�^�����΋[ �5x��˼4�7�τA1��\�CI)�dP��kdbD����0(14b?��~]J�S_!d��H�ų䵢d���P��c.��~��d���aDB�~9�
���:��B2й��(rb�H/Nz���H-�Ax[,u�Ş������_�(�'��� �	`P���u|/^�^��~����]%�[���kL����#1� �@twR����t�e��X�8���|�c8��9�ɩ���hF0���Z�yTk�/Ŗ29qKG�S�"�p�S>f� �e�w��A$���R�Pq�,����.���s ��Dآ��X��u�|�pd�
$o�佐7:�� ��|e2��-g�.�ܝ�bQ���嵂�:7@	hi)�ɋ�� ��}<Y�s(e���n�u~j�>�3�� �L���)�[��S�]@�NpD�o2�
�8Q������>��O�W��,�=�����׷�ҏ�/O����"7��n9�(f��NRO����B�C�j�J�>�r�k7�E+�ϴ����dd	P-�> ��q�k����,��#�*�)���hY�0�$���E� @>��4����cƇ����6��˷#{{<Q_�1r���z;�T}�v��ˈ67�*��oޭ�>�﯈��h�ӏ��b�^�c�H#��I}Z�q�>��ƭ��kGn�:�H�V�0�^�
��ѷ��e��0NV|�/øM�����Ś��H����p��
�v9;Q_f;}�TE6�ܞ$��Y��M��
2�ɍ�T$xq���-��H�]'��p�èם?�2ߓT���@Ey�T���.(G���L���p�H9Z�KL����}�e����1}�t�,K���1KO_=ݦB����A����!W6�q�n�@�@2�?=���s���b�BP��?U:�[z��17;���U�����Uh����t�" ;J>{f}�8ԓ��x�2�U�zV�,�~%� �;w�c�((��eH?I}��/}��,��?����x�c      �   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      �   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      �      x������ � �      �   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      �   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      �      x��\k�,���]g��;���Qk���c�$(K��t���P�	��T<�Oȟ�	�����������k��1�ɰqP�'eJݿ�*5j�(����a��T(���a�^�5m�D�J�;��{Pj���0P�'%J�ߴ3���4�T[2�Rϱ��NS�kH1P�'�i*�$��$>M�w+{x�d>O�7$���W�mN��`��'S���7�Sl��'S�ϡ��a�ʈs���a���{��L����\؝R�7�kX�^��)�~��^�O��Zܷ6�_��1M��k���ba��o�|1ߪ�?�H���T#>)��n�cVm"�)t��ۿa��4�S�S\�e��������u>�6s.�0P�aK�n�%�)V�6s�h���ĵ�sl�a��^/i1���*m��z@1��8��:�z^��n˰	aN;��ݦxP�v��sl�a�ru���6��:u��)n�u��?����}y��0�z�P�v[�رg]���_�׆Uφ���b�b{udC�t��f[�XV�hX��c��pk�11�R�h��bMC�����-/100�)@��V7���:�8��l��l0ja;�5��zQ�O����܀���7����_U����)>"h=�%6X��3���Kj�R:M!��0Pw�[{3g��U�?��֬|�p�@�Ŗ�Mg`��3�f�}k��nc�|������baxo]���8��\�궬��0�>��v`�9�K���f�."\�ϫ�9�K��z�wuq�t���j6���̹��էQ�a9nV��<n�;���{��|lٛ�^��"f8�%,���<˕n`����A���=�a��O��6���ylp��|`��{YkV���p5�"vkZ�ugɅ��mt�0Muuv>Oq�K�nO����ʺ:�U�p�|��B���OT&s���X��t�Yr#n�Y�t��3#��ȩ���7�RG8�.�Yu�nu*ͤ�fe�%U��y�c��|�͜)�:_sX遁�N������cF0��Қ�%�50Pw�8���R3�^B�KC��n�\��-N�jx��[Ϥ�x�0P��C����9<�syoj:-��גo:���<6���)N�R}��6�1��E��%>֣ΰG�}�u��a�{�_�:-�Ɯ��NK���~5�S0��8��yHfp_ڰj�״�8Ňk��z���޽V�;c.�k+w�V�S���cISL��jȰ���@�d͖�����d����c�ϯ5+C�]%=c��a����U�*9\cм�|U�#-u����Hp	qd�{� "Iqd����)Z\�jm��*��DD�����V/�׆�*���늆�*��c�5j�GjX沴��*�����e�z�����U�2Te�-�YM�0�:�p����^b�k��8Ұ���$�U1��ҩ�b侶�t:e���Nlkz����5� @������@�Fq�i:�4]h����!qM��T�)M��-W�0P��v-�r����N*�6�2պ��a��c�ѕS{��ʈk;���nS1�*j��S4�:b*���k`V�L��ؖ�ؖ�Xr���iR���%h)ARXܗL�� �׃���m�̅�չ\�y$+���ǳaиO�w��>�]��w�����w��a����r�E~�G��}E(P��j�IjW��m�j��t*��6�!RM2�R����$1W��00(:�;��*���$|����`J�K���)�W[��
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
g����N_���%��bU���1�̹��{VL�M5q��y��~��tT�=�Mq�{v�a�u�gv�a��v�g��R�MA��a�l��џ`�[�'=��S��~ɾ�`phd�18,��y��w�1g1����I��������ނ!;�>��{�f����-�>8�=�u]s�w��u08�}�aIr-ȵ���܏�-�.��H�g|���Ot�����o)�q�JY      �     x���ё 'D��(.�@��@����-V����zE/�R��j�ϕ�����"�"�ۯ{z;�W�hh���(��u����R�I���\�J1�<��<����T2�Z��|���tА�zP~{�41w�%��C4hH����=���&Zv��;e�Y��F��|��a�U���g����Z�4���{�~ޥ��D�M"�)��d�f7o�[�{&��?��S�q�((�E�>��L�z��7_3%c���3u���D!}��ʠ�뭥L����ʲ��D��N�d�A8Q�z�B���-��^HK��̩Y\iA���A%����d�Z���`�ƬL��r�kA*-e���\���U������HC��ٷ*��<�2��w*��shle���J�!B��.�<=��ܙ�j_���WJ@��j��9�Js{X(�v�Ty�؅�|�~�r��1�&����J��V1E�U77����"��(�S�P���Ӏ���� %��}Dh >��z��}Pt�����2��ܑ��2�=���
ܘ��M�z
'���r���Ze���k}�(�R��A�XD-eRN~&pqX��DC�I=+b4�A�����܅B�T��udmc��Hf��1(e�j�R(&=8Z���ͥPH��GÍ�=HB�G��F�>eB!|�6F%�P���c�vR���ˌ$6#�8kսR(�d���X�1+S4�tr����L!-'�T�r4QD����sd
�P��I�Ch)SD)���B{w����lk��(E��Q��>
�]@?��V+͐��箇5���'f�>�=v���KEY�w������s�>�c��R`Z�1fb*��ų9vѧ٘L4�� �㱬S�[���mĹ�.�V�����y����e��0\��&)�s	�W�q��,o��s���;
3�<v$�)��:��d��A�s%�<R6�LC;D�b�81\�|/�o
�ub
/B�G� (=� ����PD�����v�Bq=8�h�$�
BC��rQʪ�����+�cz���s�Vx�+��Pl�w��V���(�n��K�Gh�.��s��S(V���~N��Pئz�M���mSD�ܧ*���ES?[�������!^ي�gr��_�����Ʋ>La%�
&���3(|��Z��2Q̚�&k3!{����z�a���a�?*�k*�ON���ڪP��� -���BY�ʺ��P(�	�3\�Q(�}r0��\(��R���b�_��3��>��{�B���3�T���^��T���,>��`��{7��9��b-.PG#�%>�?Y~�B���x            x������ � �      �      x��\K����^��
V���} ��NƔM��S�����;��#&%�87��
>W�9�T>��8��yz^�3��_�3�T}-�M8��n�Ȫ�r��)�E�X�8���0��A�����c�4>��}H������������'��q���h�@��@�1��>x���"z��A���u����1=5�~���NQ��&��I��i�g ��!ƺ����]4nRF����)�'^�)5���2Vѓ�3�y���O�%�#�<b���D;?ۼ��DP�C���u�h���ּ�Y2Ȓ�bXYʍ���7I�Y���,���&[�&[����C�_���	��)ظX`���,
�(<q� 3l���%���68w��`�I�f����#�����{p��pĵ^?S~
c��`Ȕ��mdWu�<�����x�����<L3P*�~:׾��c-���0SқD����e��C</M0L���_?>COO���Co�iP�t�gq���K��(u�������W(�!��g��R�i�(.;%Xq�
���T��o�돶��k��7��M������C+�?�<K�vbC�+��B���$�H�dlu@$wPu�W_��[�T��\F�8<%@Ԥ8��Fa��NW�b���({��0���I�U̎K�=�44����Uq���Ό�|�S�iHi<B����[n�~�n�X?��?�Ն���S��Hj��E��Z<��g�O�Ċ7���o�� �V�t4�Ǧ{J*�z�n�F�͖�6����(J6���b��WW�KǪ��^�Z���6gq
�2��8{'_��z��^�1Pn,-���ťܧ~ë�L]/<)�\�.�R<	w�(*,���E�h �o�Tk�{՛��p���E��e!��_��7��	C�rK�kC�O�Mʳ\�"�,�4"��9?�n�_�q�{g�3y��:"|�-ک�z����Ǚ�^�S#����m�,�r n�Q��_]�>DU�HE��&�s�v���
G���2G�/#��2"���#�\���\��5B���w���gEş�����OC[�2%�N�B��r)K�٪��� &�c�E�֐AA7���1�sf+l�(�	O)��8q��xq���]S��ħ��ьx��R[����x��M<^]ǖ��D�0Ԓ�"�Ӎ�.Ӆ~Wu;���^�B��S�}�A�͞�e�w��/k��0U>,�oȦ���m	7����)L�� �$$ｆ��ҍؚ-����L�����!`a�:.��5����}�F<�ДT��#H�GˌKM�\N2?6��Ҍ(�)��T�]C�jDG���O��2�PZ!��l�M��H��ӝ��^Nl?E�s�wJz�ۻr��}ez+�&m�wG)~�E�3�X��x�-��Կg�84S�L�� "����ص�ZBcf%�������l��D�5����2g@_��8o�4���)9o%u�\�ى�Rxԇ�t{���jp9A2���G@��{Ug�0����ҧ��/�K�>)iKq�%�ZbR�EI��A
��o����*^!�
*��lb�����^˱&��5����<�Z���T�9�t�ʊ���{�a�������^�����GI�)q%�_;1R�"WG�r���-ﱃ��
:9���O��5G/�����^�f %��	xᩚm���^�5�"���:��c��c�1��]<7�>�Nb��i��kM��Ss	�N��ؼ��<E<����>
���)���I�R��˔�(�����U���G1W��%NyJFy�x�`����K�/�r�L�o�0J��IU�\o�[ۮ�?�S`�b��xDcb�n^u-�����$�{+��e�*j��Z���nA�́a�:*�2�M2�U�8�d@����O���j�\�A�B�uP5�c~��OYՍT����ҫ�l��b�p�3v%�P r˩KJ��:G+�s �K7��JWB�0N��x�T�(��{Om��B�J	���󪽞�E��7U6j�D��f9���K��\h�ܘL�v�Y���PB�b�V�I�4��|�'�e���<r�h�B�v�����m���j���~�Ual�����#H���"IU�u��O9�R�q��d�w#��en�L�����e����&/��1b�zک w���U)�5H�M�m�@8�	&���(WclH�MU3T��#��b��ebu�Dk�{�RX�k�ŋ<Uw�:��p�w�a��MY^��)'�t��26C�d���|�i{�e�v{!L2�l�͸t���ŝF��.��!�<�AÐ<�������i��2�9]Ӿ/f�2�T/ C���Z�����X�±u-Je�9���=;u�'(qp-]EYH�ɍg�&��f^�A�V�\Z&�ˋ�W+Ե���%�V��!��~O�o�$� ��
�Z�1+Y�-�P_����7�xy#{��
à�1����&�>����ZCH�����W�x�=ꁬ䣻^e1����
(S������\d}�s��\���o�:�o�2aȗ��\�|���;
��d1̈4��Eo��/���V2��ήI�8`D)������{>�t�[�?��^�{���/�2>d4
��l��j{�fM��aǱz��%,݈/Af�3v�%,_���K��������1�ݺ�����|�}t��2�W��\T�Ʉ���������7e�h��w���m,WZl�]Q�0d�ص�/�s���a�߈n���Z��b���Yu_Tc��*+X�Z����bGQ�{V�Z��
C�r�PQ�>4{�	�>��f#�"�Ht���nk��
#n�Cq[jt�;���q}�������.�S9���C�����-���s{�h�!sl��'5O쀽�ֆy��ܢ��b�2���+�#6�~����L���� ��d����1��{h�5r�u;yRK�2�=�\g�a]�<Y�zfn{w���ș�T�u/=)6�/��ϕ`g�8ǫ�&�|��
�1��\]�pk�8L��6�!��()o�İ�}�ȁV�����w�x�4��&�y`�)�-uʖhǏϷ���]1�l��6V[�e��wXk���r�&����|����%Lk4�o��gs}�:tY��7Cl��T-�˝۫;s��[nq�+e� �Ui�f�0�K��d�_qE�P
�a�)�MO.`������4F�ƈi0���%nZ���ocE�b���h2%Lϸ�\�UVI�V�~�",T�*eh`�{C"����+Ys֒�j�
W	�,vO�)�Ʀ��z������Ks��T{�T�ޅ�	�\{yX�h��rٶ��j�osc2����s0+�5�s6ǃvz��~w��X�K����F\�>MT���+�K�x�^M�+3�5Mi���^WM�7���������[�) �G�u�d�'� ������ወ/�j�P�Sތ0/o'4y6�/��>>�58�Q��aȜ"'o���,�4)3K.5������q5�4C�T�>�(�U{�f�:��R�j�,���"���o�����[p�I9��#�ǫ���th�=<a�_3`�K� k��C#����C̫�g`���1}�%���~����^kg�
�cZ�S���@T����y�_�_�|�t������>� ��jmX[aț�8tE�0/Ǚ.wf�q���q�^��\I� ��Z>,]hr�;�^���e՘W��Yh�+�� �\(��\���*���[�x�!�ۀ�$��.=%[�2`(q����u�!%��A8����H3��yd�v�Rq�^v<w�]sg1����i(�;�G�>>�6(�Ύ8�[B��k킽��� �]67�eFM��6p�-��,��oknb{�eJ�>+�(��;�+�b�|���"F+q�=�)�^��x��9`Ba@Ð���6^5=]n
�s��O�R�(�()٘�ѓv��#&��s���<=V�e���XѬ��!+����������I>?� s *��<���x��9&ϝ�`�*�@v(X��=�+��r�"b�P�l~�$j/�J���!�`�;�Za0dϷ4�� >  ?5ww�����+�K�(�T�(���Q_:���F���2�6��q�^f���]�1���OM�μ�_ƒ�l!����_Av� aUðD�؛o}��s��Wi���ː��HAK�B�.G����ι u*��o�u��w�&�P!<�˯��Uߵ2a8k(wn�1��m���	SP�.0x6���A�s[��zmo5��X��-0d��i����`�k��Q�E&V�4c���������e��\��\W ����G�/:+��1+@��h׆gn�z��|��$Ki��^�\-�n��<�,��v�����E��{_���QD��R��c��#7z����g��c��Y�e�2&�_fm>沗����~��c���c�5aȖ��\Z}0�_�4a8�s���ܧ��w,g��c�:SF7�s5�[�r�KeM2�l1���Ϸc�^�d��Ȅ!O9o���P�3W�5�-g�0tI�n���~���]�0t)�L�7&D�/&����z�q��?
��0��ty����ׅKGc"sG��YB��f�v�4�5z�l�~�$s����$�I�n��mM���c��rǱuN!��8�ٕ�׾WNl�o��)q�l�ֵ�� �q�vaX�]�ob��m��k��ڐ�Њ��:�Rh9V�s.�-R�������z�v���6g�֤���HG��l�8�3��v�Mw��v�阭[�i�}��Փx4�J��[��C�lm�+�L�|�F�A"�I��a�0�j�,H���ُ�7�.0d-��D`�ُ�d��+�e��3��:�/���^�����	è��ﮁ`�ؕ�;�0t/T}6��]�ҳ�k�̍��Հ!O����:O���YG�n,d���������LQ[o��V����ɽ�I����JGǃ�|��m�p\��6�Ɛt$kʑ��<$���ʰ��Y��������3��J�L����;�m�^�M�7��2�cU|�n�MYZ����La��;�;P$@�f^y�S���TӾ�k�JJ�\�����v-�&��NY��,�[�\u�^�U�*QI�޶`��T�������      �   �  x��Zّ�8�G�	h
O�l�q,	�Z�@O��*QA����/L�
�" ހ6L_X�D;���/JIh��i_��$���Su�I.H�{6���q2ʓ�|.;vwm��oH�!a%�oH����MpI������=9�ڤA�M��_b����9Rn��K��d�i�F�&I��$�Rֵq0�U7wmpQc�.��_�;��oN%Q�ӧ��0ݨ<����i�´c�~�^D}��m�7�/n7|�h�ǽE�eUÏ�î4���AF���j�qr�17?v�I_=�C��E|����jq���7X������A-��1�n`b��'�ʀ�2��J�A_@_!E7;ST���)>�BT��S�|�AX� �W0E� Ee��W��A�� G�B��r�s4��/�hj�QC*QC�Q-��K�M���Q-԰��\��\��\�vP�vP�vТ'hQ5��7�Ƞ'۞� �lYGBW���Y��3ﴢ<���\b�srY�@�i�9)�@ ���:u��	�4j���`�-D�(�
��]=[�c����E�?<5��֟�Ņi:h(h�$$FَD�D��Ny��t�bhD: W���VVsɨ&�+ld{޶�=-!���"R�O�"}A��"���T��x�6g!B�U���PAز�\�j�v������U!Uԃ6�T��*]kT\}w	6Ab�(I T�^��_6�L�%}g^i�����ƕ$���U��)�Z����>Q�W���bJ��S�
���L�jv4J��#��F�0�9Xۓ �����hp�!5�N���|�Q��u�>�c�TC��$t_��)�D�95�$Xo��^J���' gj:��M�8���=4XS�)/m֧�Ɏܳ��sY�I]��8�W4��Z���'����L���t};_��֋o&C"kӾ���h�L9��h�k��[�)m�f�G���B�|	��8A�'
� ،���D���Q5Faw�`_M�E1k��(
�StH���e��6�g�{���-g�ټ�R�^6@�Y�M�~��K��S�܏1�>���5�n��?��}�`AT2��lW�|z��֨Ct:B�i)q4�����ttBC)r�#�z޸P��Bt�D�1��z�I8{��-��?�����h��&p� ���H�B#c�J2�A�^�	��gL�d�7�����>F4�jڏ�.;P����0o���'�)���X�����y��:�o��2ZPpZ�}�.�@t$�⵭������d#���Ɇby�a�z2jG��<�a�[�tŶ�cM.�Z	��6�:��8���l�2�B����8�!g8ġk����̫�����3]�a�on/X����u�QR�Լ?䣮e:�"�9&g$r�kX{���3`�"9�P0W�j�8�[#�, :5����9���4h�@�y�piY��!y���8N͞f�w6`+f�jB>�,)D@uQ�+Ӟ�E�&���э�mGo!����YL�ϚQ�4#�Β�����ҩ�#�9�p�!�J������hk.NuP�@lMQ��Q�8�c"\RH��C�)��@���<������"\��f�9�η4��Cq��bZ�VQ1i4J����Ν�ݙ�ys��N�;����IG��ι�n�rɽ����X���������������      �   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
c      �   �   x���1�@��7�i��ݍ��ĕ��D���/�#1��}/iN}�fg�mzvu;�#�,��8Vr*!˅����	�g�6�W���n��zo�7�����-�1�0Y:%�6��F^��q�܈��4T
e�2���U��o�/>;      �   9  x�}�]��8��˧��%�?bO0�?�&�*ې����7XB �k�O�������}��q�r����/���)�r�f��<�tH�p�۔Oٽ%{�p���?�E�Py��xhG�Py��#�Y�~�H&osD)�<��ۜ��T���}���M�H�*��?��4�]$T����O:%�� ���؉�AH�S"[e2�J|`wB��ŕg92Y�� :!ځ�EBe�<���\e����ܚ���#2�� ��MAb^
�!T�	Q���PD� �I��5I���2D%� u�A �%��2�N|LZxLA�\v�T&� 1�)��c�p����}$�P_�`J䔘"SB8!J����d#17��̇� *�+�9h2��_ab5�d=�]�
��� X̅{5c�J�9h�� >U�g�d$�ab�d�>�MA�\M|U�!�h��4�s�*'������w;�ż��Ce���d������[R�a�,�T�<�7N�]�� Hm��>�� J|*��A�A�x�k'H�A�At�C���dL�	Q����Ε� !�l$?LA2
&VKL�v��Zb2!�Ce���+�A4JTҗ��tK�� �� �1��q�`1���O;�Ŝw���^[r�'���c�^2��j�A�W���c� |�Ք��sp� |�|���ǒA���)�׺%�@�Dב�uB�ط/ĤDe�PyK��\M(�\-����NɒA�����/n��{�%���_ ���[MM�Z2�+��Atw��iƷ�%��Y�d��	/Չ&oi����A��'$��� 2������D��%� y��O���A�C�.�Mg��dc>T�k���GP����p&oi��*���,�5�M,�s���z�(�GM��|��uؕ���cX<����D�8KA�a�_$L1�Sᯐ�c�u���X�3�G�7�� 2y�{�%�(�=Ml�LAr&�T�|*����j� YG���d�C>Ma��d,�_2�_�Ihm7y�au���5�y��ڹB�]�WE�W*�(���4r�D�s�AT�c��n2�F|�C�:T�9�}�/əŃL ���cƩ��A�7���KA���P�ʐI_�&�����GI��3����u� H~��Vn�����s�Ad�F��I4��rɹ2�p0ѕ[ya�8u^2A�3�%��R�f�K�"(<rƃE��6B�-�`�oE&� =Laΰd�}P��,�⁲�Ή~,(e$�M��IqF�d,��'1Lq����&o9Lq`��:��A�׹�?ڣ���e���*�%�AO}arӏ[!�����-���h����A4B����"|���-�	˼�ɺ��-�H�(��e!�g\�����MXNS=$BeB�*��nD%D���A�?:/S�d��~p� Y���g<&�1}�{�[�{\G
��-�H�H�$^2�ב�onD���/�!�/��wd��"���2�F�J*�%��h�G;}����{�ALBLA���G��-���謦�j�E�, %����*ZЬ�=�J�X�^��梕Z˻l�:�^�Kd��
��@T��WOt��ZKf�awy���?B�uo�2<��I��iY�7�@��_}	{��Q���!��(��x�ث����Ur��C�Ml�����$�t߶�����?u����R]~ˮ1��p��UED�)y�G)�l�=�S]2�W�J�&���ʨ���3��۠*��u�x�:���cF�ry}��U��y%2����y����|4��Yw�D?}�wO���Z� >����Ah/:&%
�a�/ɓ���� D��63%
[��D��dg�;�h�ˏ���Y��-{��h�]�'��yz��v���suM�O��>��۠��_�6� '�����W΄��D#>ګ{}VwQ}�_��&wkw�!����վD�g�j8�D������=�S�<��ڋH�����"����l2Q�)2}wwJ.��:���׬�K�U4��������U�nG�W	�-d$��j]F~�8b��a?�����g۶� }��      �   �   x����� ���)����8�.̈́,K���1����k��问�����(Y�������c�t恣I0�f��8C@Ղ�7�(
q6������qEr��jM��&��z��Е`�<��㖄�r{�k��� D��y��"r��D�E�U�c9����i0�@TZe���/�sU�      �   �   x����
� E��W�ʌ�sא>M(�nK骋����@,���l��p���$��P�*�i��J��~<�HC���%L|�����C���<�]�d=՞��љ�S`��i|�),i�oM������כO��c��x����1�]di�h[J�$]*�V+��i��X�Q��v�)��2�f�ΚW�� M^c�      �   p   x�m�K
�0D��)t���;ǘ�BMȧ�����,+	�y�7ǟ(z�j��5 �A�Vޡ�'M[a�8���*\y	1����l{ `8�m5��N������>_p������3�N'      �   v   x�m�;�@D��S�F�@H�Vi@KB�?Aۤ��4c[���Y�fs�,EN�*h�Ӵ����yG��yZ��In�z�V�&~uh�ӐZ�F}��W��
M����{B8 U$�      �      x������ � �      �      x������ � �      �   F  x�=�[��(�;3ǒx�e����"��Q���N��x���g�n�C{���6h��hmkߧo���nF�+��
|%�_���W�+y�D�hm�-�����B[hm������hm\��O�0��C�NƝ�&��j��q�q����'�{jL3ǔ1cL3��0/L�¤0'Lɢi�j��e�e�e�e�e�e��7��>�Y�>�[O��K�ݱ�t=l�j`X�~��c7���~7}8?/�NG��ϕv�^ʗ��n9�R��o�[��������t�u�u�uvtvtvtvtv�r�r�r�r�r���]�������������p?�#\�\G��0��.�Ү�ݴ[v����%�z	��^&{g��8_��"�qN��{���sq��P���h�6h	�q�?���˃������޽|�KwzO�o���m�&mѲ?!݄t�M��d�N�6C���t%�J��p+�V��[	��p%�Jƕ�+)Wb��\	��t%�J֕�+iW��]	��x%�Jڕ�+yWNd9��T�sYNf9��t���T���-�l�fK5[��V�O�m�E}�x�����v�lt�v������m�x&m?�����V�vQ�|�b2���Z,�2f��gb3��~�%�o�}\,/����mo�LB�}�E�iy>x>ڠE�;$C��;$C���.��B��.T.K��E�yP1��*$ːKV#Y��x���3�ϔ>S�L�3��;S�L�3%̔0���NRЛ�1�p�?=��H�/8�9�9�9�9j9��$�J���ϡπ���]������V@�	8f[A⪏+��%Sy�J�H=A;iyN��[1h�$p����s��/�t���1�D�V�R8E����'�YN~L�k������%�(�I�oz������3ڃ����.�����2���j�XB����.�Ү�ݴ[v����%�z	��^B]�u�.!!5q�"�L-����J/���R�K�P>��C�p��|(ʇ�|��;����j���g��;�5\�pM�E��|)_ʗ�|+�ʷ�|+�ʷ�|+?ʏr�(�8��0��(?��0��
c(�4�����Ӂ�K��~����`��q�X~6?�c�@�Ygi��q����v:3�ҨK�.S/�ܨKc����˽��\/��;�4��#��%�.ΥF��S��G�GsGS��*��xN�1��5�%�u�iX�3��u�i(����R~�`D��FTQiD����bid~^��\̒�*�;�\�r5��(W�\��Y�(��s�A=��@�x��A;`�@�trN�I9!'�D܏K&��������M����s�^&��:�}��5�Vr�.�0PJ@(�ğ�~�O�I>�'�Ğ�z2O�I<�'�ĝ�v�N�I:A'�Ĝ�r�6團�rBNƉ8	'��x�n�M��6�&��X�jBM��4�&��8�f�L��39c�5�&�d�H�hM��3i&��4�?i�֤�P�i"M�	4y&Τ�0�e�L�	29&Ƥ�{[T%��$�Ҽ�čH�/u�2��ny��ny��ny��ɿ�⽉D�%�$���W�JZ	+Y%�$�y���y���y���y���y���y���y���y���y���y�������Q:
G�(%�`$��� ��� ���Dd�ỵ���h��cItBZA+gN�rp����	9&�o� X��"�*��=��%���Ͽ/��/Y����wy|��E�7�(���@��e
1�g���Ԙ��NKfQ�,j�E��a5̢�g����y�3ox�ϼ�7<��0�fQ�,��HZI#ie$-����O�@�i~y6W��su΢�Y�9�:gQ�,�E���su΢�Y�9�j�Ek�� X@�VF!!$$��d��L�IB2�)M�8}k��蝱�����Ƿ����1"F��"^��p�-ܻ�{W���04
Bc��X�ơa��!Ky�d��cﮈ8 �z���K-O�x'^�Z��R+�J��Z&�Jj���%R+�H��Z�:jq�ڨ�Q+�F��Z�*jQԚ�%Q+�D��ZuZu+Z
�j!�:�;�b��PK�VB-�Z�j�"�5PK�V@��A<�߿��~�� ��M      �   �   x���A
� ���x�\�23	��P&�m\�#x��.
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po            x������ � �      
      x������ � �            x������ � �            x������ � �      �   �  x����j�@��w�B/���g����)$��@1�B����;qlz�l��Jp>�vΙ�aU6e�X���m�+���)�pyz(��-iC1g�IE�����o~�������z>^� �b�p��� e�e��i�a�{��ݔ����Ŕ�3��q4s�)���k�}�w�g���u�I�V1M�F�$`�I�ԅ��W������>5�4�>�S`|���q(�rD~]o� RUy�K��1�V���P���'{���A͌S��Ćb������c#A�X-�tc��j�j���P3�t��Ҽ�������Q�/ó9(y��"^�3��q
��!`g����5�<�����:R~�џjW�S	�^���9 ��DY�ʋ����i:A�,7���#�&9O8n16����Tu���l_���h�f����7���,n,�U{��13V��4;�-	<�\4�������� ��(Q�      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���            x�����e����YOq^�7�⪜���1<i�306������g�XJ)��|������^�Bq�����������߿��s�ώ��~������5~���u�����������2o����>^­��������o���t~ƀ���t��@[�F�?A_���o������,���� ���:0���/�������?�����?���~��������@�%��x���@����ͽ����O�鏖�@z v�=�?�S�ce���^�w��K���W�����ۛMk�'b�9���?������ݖ��-�;�x���*v<���$�}�ns��o���&m�G���ģ��y��-�����c��2�0D��h���E��,`n?��OR;�/%��R}Ư|�W��~CF+E��~X����$qq9(Az�s`���s�ב��O���Z��
���/ ����o�����v|��B��6_�)����!8Z�&\X^ `�Y���ɿ7D�� �@-���9��$b���b'V���
��h/N�7�}ؠջ3W��$x�1�0���2�
�?;� ���7�Z]���?�4~��79�j���}U.�(���XC`��)_�bB��s�4�q���W?'��}�7�N��SH����"屟�@:�l�Be��!j?�=���������@By�zH�d-c��6��"(�`�!�BLڛN�<�P�'v���w��YL�k{�(��$�'����`�טv��ߐRƞ ܹaZ	�+�+DS��(����'۩��a��;'�@SJ?�<����x����B創�B�Od�9fʽ��ņ�����]�$0����N�I�Ry`��n�m��/1}8��Bп+3ؓ��|8�{���>&T*�x��kl�bz1H�#+��)�����ߐR)��+DB��s�4P�p`o�����r���xy
�1U��{�;{�)�]��Ğ�jw�]&�IC��j�Qv'�>��%�;�[����[UaS�^�iO'��^�bώ����	�� 1�-i�����gV�m���HG�������ɥ�3,����f6��K�j�}�T3=�i��9���U�k�&�>@b����1���8ݸ0{s]��a�:j����n�;6��'�О��~*���B�5:�ߢS����� �)I���1k�GoO(��v6����r���f���U+�G7��w�e�����W��)DS(�Z���e��_�f3�_-�d�B��{:t7+~Cܲ;�s}.��� 1�!��m��F�R{���wF_�o"���M����ě<�t�O����Sf˖���O&�]�[�~��xC&���Ṧ�Ah�|�/�K�G���W��7����7�S�����r�L���_���ω���|~���x�����Z��?x�^I�t�@an!�v)��3�n�j%#CLv���J��Wf�
���wQ3�����s����;/)�R�k�H4�������Dq�R�R��R���(����-����L���Y��,;Ȱ;Zru��ϲ����>�7�ù�S�F��x`��,�RL11�e$Ǜ���w��"�>0��I-�_��eO�?=] �"�w�S��&/`�f2d��J���|�^:�q�J�mz5�#_����ΕB��S�l�v�
��"�bQ#ܳ �B�lO4��� R�'N2a�%]�e.���O��Yfy\`��C�iܧ=��Dx���GXe�Jm/�p�t\��)��D��}�GV�@�l��)�nn�)�3�OJ�+�1��{�CX/#�L��J�����<[�������F���ͯ5
S��:����V�@���,5���/*#�{��sdr/v�˵���ӎ/t7Ez_�v�(�E�,��P�]HA�@�EJ=�:�5�EQZ~��`b_)ݽ7��N+\�	Oޔڱ���W�Q�7��E#,�3%I����=E^�ѸQ�{��N��Y��2\�M�ˬ
D\)���٬HaA�R�iSF^�k��-^ vs$Q�^˞b�<����Kz<���V�[�a?w>��l�k��~[�:�s�=*Ӂy�@\ �
�Q��n)�"�MJ�����)l�(C>]Y!��e��
�2�����I� �О�f�cڢ�?ԕ��sLL׈�hʁBf�i�.u �B�����a�t֘�V6�0_ ��]Z�4��6k$� 4˵l)&0I(�c\��i}�<�%���|�(0GϹy,���(�׈!��C���첋���=P��旑�ǜ�d��C�2{F�����\���L �?>2%�y�"l�Ĭ����[7M-������V�s�$�|������&}���#���q��4I��c~�qI�@���XnJ���*
��/~�Ct{�����+%B�Ԛ�'Tj_�B1���Y��$�p�H��7
z����Ǒ�n�	�b���*8/ݑ�?ˬ�\)�^)o�k+���̮��C�"n+%�����t?���/S����C�]k/��2"^�F^�I�v�.2�tW�i�ؤ��.!�B��$��K�S�V��oe�n�6�Wʴ{���в��1��ǲPL=1���y�����G�s��c��r���]{@MU2���fm��#�]rp��t_��2J��@Q�w$��z-}�\��(+��ֲ�����e�gW�׈姳�Q�鈹k���ש3�/])ŋ�B���3�M�O�����B�1S�g�Ee����
�̑�;Z�G{�-d��q��^)p%�j>���U�Ad���{������RWt�H����n�(��bo4L�G�R�2W����� �-r{�|\�~�=,y/����)RS�J1ʄ���k������~��G�(u�Xa��)d/�K������@�]��=�j�=�)`����No)l:��o$�(�KJ�7W�'��^��Cc�[dW1�D�^��s���TzוW�WҼX`�����8!���R;ѶS^��¯���n��;rM9�Y�E��L�؈�[���B��8 ��ƨM���̏����g[).�L�ő�3��W��-e�z�ϐ�y��@0 ��Q���
�0iX��&
����BW:��)0:F��p��it)`<>�&��8�ioy���Ŗ�Io��R>���*,Mw~u��8a�"�@A{��m�^�s�sG�o�@}V9G�C�2�#;K��⹊(����K>ݻt�L��/��Z�ιRzqu��&J-t����@���˿ ��^Uv��r5Je�d�,�jc��IP2s`����.'
���K�KVH4��h�B��t;� '
�NK.f.��b�+fy��ѥ�+%L`l��R]j�R�琗I��4Ҩ�B1�b�%1�\Ќe��DQ�8�ZJ����d�'/ݠ2rAM���f�Ȝ�"��r-{
0f�yؽ�]��2�=Ib"c�>�V�q�鵫zfb�sv��Ad��Ȥ:�x�0It
Gxǚ�XŲ�"x ��:n�gRo^nqbz�N��`NQ>y��Ա�jϴm�D��]�U�Ҟ�>��q{��[�9��.'��P;���w�����ܞٛ�S���+�8�'t���4��}��pWq�1e5ݐe��|��?���>��
���Im��L��\�v���AJ�����\�k'���\��_��f����{Lj-(�2�øX4kdRVQQ.���ʹ�>Rߐ��G�P�*�阩���P�m)fנBJIu|�:���ޢ	n��P�3( �ٯU��Q�P�Wk�����ц�x%�
x��;�|Zꓛo����2_��?K��(�1��/��k�Zt�H�U�=��h�(|�H�xt����B{{1n���LU>QtΛ����Z�*02�;��k�e���&@~r�y:4V�#4o�~ �O�X��磘��}����2N�e߻���4V���/(9���S���r�ݘn��YR>���ܣ�[z�]��n�RF$��J��{�Q�R0�2$j�ߔZ�Y)�>)3H4G6fm{])�j�{����*�Hc.Ͻ��0e�b@#=�(�ԼEe���b@���2�B    �F!��H	�PW��2<��˛Q&{��Q@n�l2���.��BQd%�{�x\���W�L`��S� ����a��J��������9&̦R�Ժ�7�L�WGa˟�L� �� �$�H�.)�~%Y`�W�^�����V�d���`bO�K�eJa_)�nQ ���c��(�b��_Gu�o[�!P�o	a�L�A���tK�@1}'�'�e]!.�!*[S��KY��P�y���y-����5r�{��E�>���w���$$�Pw�<Q�,��z�n�I(RL�ؕ֔� �*'�EW��½�U����&ΕB��A-���B-�ە�*���F��M�����ԃrú&�����(�BFYNJ4VJ���M�{T�1$��ң�#r#��>�[
�N{�D)S�O ����Մ+=T��6�L��.�$�U��MM��O#��M{J�q3���I�+%
�u��/���B*9U���_WV
F��c���+7z���)������޾/=P6�J13_���ȿ�,l:Q&�� X6�)����ySj�@����ڿ@s����\�Xfe�(v�S �&��,{��$���j�bV�hy���&�R4�7��_F��(�4�Tz<�-œ�=���)�;�zX\!�|t׃=���!��a~*n߷*��G�� �8��X�
�8��92�GՓh���Z��B�7�0�1�gڻ�� '��KH�1��eR`χ�X�r����kDe�3B�g*�@�Hj�e/�z��S��8Pf��5W� �\IqQ�
Ì�o�Lu�S��gO��Uw�������z���_��#W
�zz��~z�"<��L���s�=ȹ�c~
po�=}ٜ�Z9�eez!�������%En��$�I�ڃ��:.���y���o;]?rY�E����R%Q�].ȸ(�t��n�Z�>��P�5/�~j�k�ۼQ���:Pش�ܑ>zyK�OÓϋԊ����Q�g�W�q>��V��N�9)��R�'[��E8�@��GWp�D{`��By�j�Ph�x��x&�Wd�)�b-�R���RȞ[�pt�ˈ#�Т�E��R�:PPtd�M{iA(�u��D��1EmWR�!|�(s����~8�����L������Rć�IPW����}�7���gWWQ���9ǹ$5�|k�U�P_��R�]]ŋ;ƽ�N�<�Q�t����#�y>��}��N���~�*_(��u��@����R�$J}vu�R�؛=7{:�:Yb� ^��ˬ�����/��ٛ1koƖ�ERE*�U}��@L��!�2�VuU�5+�=��.����Ε��&����eL�((���������H�B�(h��Q�a�f_(����)��;�Jᨰ��4�w�e�Bmb��1��Z���D=���)��6q�\���j}�E��v�h�<�+& 1�I+�Q���3h�>���(_y�Gꤙ:BwS��#w��tIj7~�(��/c�M������fwX�@��e>ˁb����n�4�J�P��D)\�u]��R���T��[��R�("�9QJ�˭/lQz�#�g�l���Ecfk^�G��ѵ��v������FK]tn>ǹN;�ِ���W�w���k�g���B��F+E�HC��0z���+d����t�F�/��v��$o�>LХ�e�7])#,`�y"�(c���
��������J�{[)��\���\�E�XK�+�+�Y9�9(��c�H�����.�S��B�n^ʘ"�X��N`�I� �x��J!wj�Α���ɝV
_�)�%Z�bn���e���n��]zK�h�znv����Ta]��}��3�<��en]��}���6ȁHo�z����T �\�6����U��S�_E�y�w�{s�_��r���>!!"1���s�V,��EMӁ	�Ǳ����K������${�)��%���sz��#�jw
C�<����Z��80���S�����B���w��މ��e�j�O��=@?< sEFF�)@#yc1�z�ը�%gE��Br��=R�'�Έޢ�Z�>�DZ��������PW�g���➻�D��	qb؎�<h��}�{�@O(ܦ���C��nߔj��M����1��{�'������l�����������7�Y��	o��]�'�3�>�wO��1uz@}���&�^���m[ ?<6ׅ�>0c������l;����=;6�8n������t;�(��=:7$�г���{tn�Qb�ޭ�s��(����6��H�}�W�D�ɷ4�7^�����´�G{��i�����k�'�(���x���Fl�;<$�O�-Q�D���6�}ny�U��������������ZE�����L;N����Q+���/JT?NU�v~ݒ�S���J#P���Zѿ�S��%�{D/ސ������/&@1t�[���(Ë�E����x��{�3p6�~�S���v�U{[��r>K��{4q���DN�o_@�^�<���c3@绷�z�]�0FՃ�'��O���+˓��!�+��)W$Ԃ{�D��'d_�T��	f��J�;uA#C[)���ΫD)���(ڽ�Z�ԾN�+E�j��ُ<k������4�8������^��LS�W�[Q}��H���z ��6������a�@?��j���&��w�ﶞ�DtCi��y��o�I�@2%��?<{ {���d�h����3($]���(�{�?c�S�{�k2pϾ5�����ͼ����,����ȄW�<vQ:��.��R��x����[�ۏ|/>�\݂���f�g����vb�h[B����{	�hGP`��D{�數g�@p��(�Us z���5�e�1���g����UӇ�/�B������Q��{�O4MH��ziq�ļXl���A���ֲ���oo��(��څL��hHQ(C@+%&뤜�)���ȫ#�OS�ϕa�YW�;��M�:caK�[�)�,GC�s��j�8S_r��~R��3܍��y��c�()�'�@�s�N�*[�@�6��Օ٣��$���r$҉bVHn�� ʵ̕�1E����Q-e�s���\o
�gMA�z�S�Ε��I!���r'n�g(2��24Z�>��.��7�H5�8e�Gq���7{41erD#���B!�r�#u�F���R8�MWHh��C!�3�Q��}�Z��2^	!�^���:�/T])�U���-C>ݹB4f�j��.bm�n)>us};��\��J��&��h���қ'��iH����B���E��� ���5�2Ñ	V
D����J��j}�p�x��O�=iT��VJL���"��g�0�J�A��O��p�^��n�:Q�d��k\���=*��OQ��R+��n;]VD0�J!�7��r�1�CO�-�森�Z�\!�+G��7��K�S&��.E�f���V�F?4S��;�P�eK�ҜY��Z�r_)_o}�B�K-˵�):����+2z�.�*^~u��������bR;�w���3��԰Y-SM�����Ĝ��:��=@���cI��hư�gLd=f3E�$�]�)5pF^��n��8�Gᣜ�
[��\0?ܔ��w�>[�H�5����B�ј�<y<=u�UN��_�[y-R>~��}�-Ժ�*�*�/
�#Ѥq�X���������&/*�
�=�rQ�gE��,�"�Y�"Y)▋)t�5���*�Z�r�`��J/�^�C���A�*���T�E��o{�g��u�4�5���(���=:9�B[�Z�T��E�Tv3xr�T���@�>�/����n)��A0�G=Yq�Ru�%&QP���3�ɪ�J�-�M��lu����*���{�:�>�Q	V�e�/��t�d��ChRV��M��
CR.C�pU�U0@L���l-�ڥ!w����g����WU���b?�&0�^�'�z�eޢY:�v�1��3r]�ɢ+$<=ڠ�2a�Q��g�Q���1y-�G�@[K*Z����@1��R�
��VY�B�h���͸.�<QD"b���GW�J�>��v�ڪs�o������hR2    ��t�qIg$3S���B�
`�\(�J���DL��Y�\�b<Q`'y�J�w���s����ȢzS�B�e���RK]���f��%C���b_��`�.���7��^Jp!5�\�{$Ŕ�=�kPz���6UV
��`z}2����`�3Wss�o�UWʼ����3Q>���{o�D��qzR�8�u��M�T$&Vk�S���r�CUn��
F7[�)YЯTI�+BM��1e!Ebb�]�X)���1�4���B5��Rb$ ��1���j-�R�ye�w�����2D%uE�$�B�8P`��j\�[�I+�j�hW��Rꪝ-�^������]q\x���#]�хڑ|���z�hO�z�~�?�մ�ׂ���{?"D��g��J<1��c%Ğ9��c�G[K�מ����)F�Դ���I�� ���L���OD�m4��� �w��/�~e�zO�?���+�������.�="��θOD{�<�xG�$x���S���x���'�-!�X������g��'���p"�@}�%�TB!�g����݇�np��߸�L���;^���Moں_�x��W{Eu�=1Ow�R5���7��x�ٷD�Z�G_��:��`���;�]��T�-O��OG1�Vjy���v�`������38��m�����^HfBo��k{���"v�d��8ZMy�����	����	�p+=S�ё���6Hq{��L�ё	^�,���A�[��;��ڷD�[�z�q��y��r��C^���M�^y��;tܾ#����K�V�D��#x���>m�#-��^��v<|z(����z|��:������)0���ȳ荽؇i�쿠>Zޅ�,S��v>;�������>��y�p`�^���z��Cێ�PϺxD��vw���u�����>V�.��">�eG�,w�Fo��n����蚊Dڷ2U�ى��Zۊ@�~�t�$����H�,�&[�?��#<�Z��v���അl��݁��D��ܞ�����d��|~G�hֺ��'_]��;�2��~S�ᯜT~ᮒ����=6�n��FT���ݪ��Cw��pOߎ�y���>iO��I����=}<�������Q޴ N{��|�>9vQ��dl�jiY���GOon�LW����� �-���咏���O����������'���g�"������$�=��_��Mӷ��H\�>I�:��f��3rv��f������Y~�M��lsz&. {����S1p���wX�Ɂ�g���Nw<}(.�l�x�Χ����n����e\����«{����a��9e�A�b�Gw�=����[%\�E~t�/��d�^���t��s��ػ����8��n�x�����6 �����=5w�#����O�ۇ_� ����O�?	�&�h�EL�⓲vD��&v{`'���sh_�L��5�\��u�G2�J*i��^d�3�Յ��w��%�x���^��0��[|��~�6`!0��HM��u_@lOo�E�6��}%Kt1�Lr��OƇ���#wm�ao��H*\@ow����Խ{��x{}�w/��-�V�����i���i7':=��ݬ8�}ܱ�B$���]��MgI��%�s����V�ۯb>;��R��J�qQ���!�E�(e"����+��YC�W{�����M���@�H�/J|@�����)���T>�L�1�!f'~����>�
��gœ��g�6'&�kR� vpu&HٯRҜ�/y��9�,I���(�𑪍%�~׏罪��D�w������u6���;�W�����G��ܣ|����W'Ԁ�����\��)j>����F��]�R��R���n�j}xw@�3R��pY<�����}���U>��=���z�!e�4] WV����*pD>H۹P�Ӛ@P�T������x?��ij�HY: �~l��
�5��C��I'
���O���Pz_)*j�`"u��kqa	/|o��u=�A�d���m+D���x�`>-e��� z���JG��^�|�4_�T_�SѲ��]8	~-��75 �_�����ZN��C�հ��S�}���b�(�->ʖ2_^�
�R��ws�hdI#��͢e�����C���RRo������y��8�a�N��z��tY)^;�S��F)�����x+i�z�˭�Yk	�S�f�'���֛�5A}��9�<���{�/��J	R����iou������@��{5=�>���H���(S�R4���]�1��c=>�LK)�Μ �)AjI�W���Ŷ��{>ٻ@ ��"5��'m��=@��_^��Ԣv���M�� �j�n��`m�h&f�ǓL��9P|�zj.��,�Z����l�ԃ_I��ܥ��������Ep�����o�#A˿JN`J3R"��񜦃���� vPڠ���ޞ��M�	�>��Ñ+$F�y�|*�[PZ�S�'f@jr��S�P\��qm��D�b\�����pf�BA��	Sj�}T��2p���n��/��m�C�|[��M�N$bz/E�l�Q�$�L�����'U���لࣕ8��<�[/�����������|��6�{�����3��Q봃
zgop>R5��ײ�ؗEʿ�����yM����F���vp��p�����
�ve[���6j�"��4M+�pfe�`8���ԭU��2�W�\�����:^�Vi�\)�@�N���^�V�D��"G����B��7F��dO�٥c�`�C�9�I����iX t���	�t���%#�rԹ ���P�i�=SjK���e{y���C�y���@oϱY �{nWh�t�!�S�J�;�
�B��APi�k�b�B�R�;L�ԿC���Rȃ��D�i�:�p�x����D���R4B�85p���j\1�������'� �#�����y"p� ^�l�D:r���>�p��K�ځp��,��^I=*t�s���Kg2艖������y�$\�@��3���vŧ���G�*y0��.�i����Bc�VJ���89utS���c�=.�}�F�3mO9�|yRGģ|���x��޶v��>�2����.?II.��-/��n�����_K�:�p���_�.����C��Q����]�p��H_�T�}?��o�1�k}��|��Z�2&��E�O6�y�4$H��:@Ȍ\yk���6�0x��7��./�pӿ��p�{%�(;W���޻#�tL�f���!�T�_A��>��H3p_H�m̚�i%��bz1�xKT�(J�{���а�i��
׭�wLO~GTybJ5���(���ʇ�.{� ���s�m��L�*�V��Yլ�=ٮ֙�����y_�9�p�!��z���+�!��FGh�ȣ:�o�H��_1�7nu�Zɣ: ���}��'�$J�i��rM�kS�}��N�'�j������r�d�w�o��:�"���~N9�D���4(�����y���Z��Iј����O�,;wI��l��F��yH����eOhݥv���R��=�A�֣���2�á�$҆�-
j�A��So��(�ˬ����曚��"�@�(3�j��r�g�>�<%(��M6O��\;-�{R����f��u��2��y�h�XόX\��~�@�5�Nԓ�lF0����(��b��A�C4V��N�Ӝ탸��2�w��K}/�>��@���@W@�K��ꢻd���+�mnC3Ej
�������l�H�Rb0H���p�wO�i	)jz���c$���똍�Z�ϺE�b-��¬[�
�J��cr���ĥ�@LXzo j��Թ�V
}%���{�jO��,%w�k��ǥ����0{��8@�@|'s�z��*�1Ri}�<�u|���!��Jo�t��i��"�\wjn|i�5��{��'�Ց�RZ+%�jz>{��Ϻ9����j��B��f��=W�My$p}~VLa�&�-���q#��]e=��ͨՄC��&H��ø@��7��q��I�N�'�N�ᇀ�ʈ�=��H�0׹y�����qϒ��*y��L   �_T�ۘ�I}��9�7��n��e�����U�z��	b�$�xC\G(��]F��#a��Ikj�l9+^�z;U��þ�~A�=M�j�۲����%~lw���]{}�5�����y�������=�A3���w��Ob,v] 8�����I��I
�_�C\KJ��XZi+�_�i���:eG�J	qmb\%S�S+c���_�v�ߥ�(<	5I�5�E������\M`�x��ۑO�r��A���M�#r�'���!$'�P������;�j�Vn7�
�{[s6�'��T+�[��0�-�eT���W�ճ=�2Qj�쏵�����v�ߞ���^ma�Anz���2O� -)��,��:��:}|Ü>	��]`"�|B�OM��2(W])�t�t�RK\��J3�{(�.�����GE��Ŵc�Wߔ��B�J�ވ��R�ߥ��z� bx>������7��i���������2?��v�8�N���"�D"�'��!O��o5dL+y"lC�C$??D���k��ȧ�֘�o�R>иqJ��R���SLԶ��M�#;O��Nw��B@��D�j4g��&?�� ܸ�M~$jA�x��M� je�Pw l�A��
�0��<���J��j�4K֑�l-g��!>o=�տ!�~�ȶk�u{��u$H9�w�>��k�\Ͱ�E���ں��u��Oϯ�`oƴM6����z���)�6�O�<1g=e��Q-t�^2����ڱ�ʞ	�8���ڪ)+{&6o�xd~���TWh<H�^��ψ�R4�q1��X1�&���D���'����9k�yK�W#ONM�ZyΓ؂�}��EZ��G$��.;��EH�H\�Ć�1B
	{v���]���]v�w����w�)y�مQ���Br����ytY` �m����Z�C�c&�3��,cj�����ᆩp�^�����fr����s2��2��Mm��VS���X1�'�1�VS7,��`���F���upc�a���k�?�SL+FbX� �߾���C�R�5Ԉ�
�Q>�aY)�R��)Ԕ(��.��+�6�~Sjg�r�����N�|�5{c�'��e��V&���{u�k ���_���Bi��
����z�+��&ѻx�(/D������n5�g�x���~L�3�����OL�_��/J�;P�#���������'��%s�~��=�=�0z����P�2&�,�bx����b��)Ϟ��Q��Ϲ`(�dp�e��mm���ܥ�+��?3�y��l�L�ve(���#u��B�3+�K~	�v�O'�	N�E���sb ��Az�0�{����F�2u��H����oJ��RL�M����1
?�E��C��P�ǟ(�n'�	e�Y�X(&7�U��4W(;Gi�W�(�~c<bWap�P$��wSd�:m�]"��h���������E����8>:��(��1S��_�4=I�҉�~ߘv�*�3�ȯ�������nV���M��<�0"1�R��N��*�R��i�?���[�*M�Ƿ.�;a�d��*�K�6�nI��*��:rw��z����J���YqL�}S>��=�E�IV��+���WS��u*�{N0�gU���Ӧf\�}>�'��u�n�1�u���I��v�6W����Lsɘ���	�v~�S��ko+&� ��ɛ���oY{_1���&�ǉ�3�ǂ��)z����)3'�Ê	WѰG�i�ԧ�㊹������DD����3_�30n?����&?���Gt����\��WL�<S�n�}��c|`�����Z�`F�A�.��)���'�mJW������z'
�	�dRJ�X�����4�LN�rxG� rGɔrXW�Wk�r�O����M������	�"�.�OJ�gU�Nua�4�ep_���ALY��V��NV��化N��'�I~�V���i�Ei&��ۏ*#|{F�i}�[AWu?Jm��^�oB�l��\\�~Tm�0<�(K=-k3t�^K�0ƨ��������G�0��a˥<K���Ԍ�5�1V�D6i�t{�5e���fW�VS�2NoT6󝚵&1`��',"+�M�̈���Eo����}��7L�I\1�j��Z=��Q{�
v��nS��5���8�K��ڸU?�Zx�����?<�j~Qĵ�L���EJ����;��d��V�����R���!�s�}�«��BM�Tj�BxG1yeJ��_�A�)�=��u�h���������I�Z(><w���k|��J��]��:��б�#
_O�!+_�-+�[�ǘϣ&u�����4���z�)��ȁy�T�Z�#��$�=tR��z�^])��6��E�^Oz�J��<%+A���*;������Ο�1H"��	>T5�p>�����c�F����Q�qL!<a�ަT�������1D_)�;ό���x�_�C��9�Q[�9���Lw ��t�6X�f��Ӭɘ� D�٤2�sB2����^���]o�����^�0�8_v�*�/�M���v_����X�P+"��{j͓F{
<y��_������=*�����{��?�zgJ�:EcB�����{�؃�a�붘�;t^�I�4n���{�L�*cjM:��
�5Q�{�`�h��=fΩ�����^n�uafd���������1b
cjya���m�(Mx{3rAn7k�ŀ�50��u�ep��I��D�ܫ�0��Ӈ�O3������gx�� ��~8�{���Α��gd��pl7���G}8�{�v[Mm��Gy̒_ē8�����>򋢍<x��'��/�l�Z�w�P~](^,�s�9����ˁ#�c-1s�PL.��������x��`����R����^����g_���j5�@�G�n���W��{�G5�>q�Hl1Q�<�䫋��Ja7�}�F˟�kUb��O wq^�����Τ��в����=Y�EnYO�|���;���Y,M���T���͹�(\U��(��IBԃ�6�E��Sɳ7���E{
��N9#��	]'
3g-���[5�t^W�9�py��j�/�>�Oϣz��R���Lf���ʓ�Ǹ�r��h9E\0F���<�����Q��o?���XO�r5���@�Z�(���!�Km�-���2NT� ��ɑ���c4T�}���i���V�l�&3����`F{5�W�����'��g�����=���q�Q�
���� ����?芡H<i�C�����#��������.��Ɍ�,h�����ٖ��֡�?6�$,i<��P��@�bJG����(zJ��l�r���"o���|���_�J�0      �   @   x�3�v�twt��sWv
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
a�[�bzR�ԡ>]S�+[/�?�CZL�b�f<�&�Ig�z@\,NBϺ�WN%�YN���P��=�*�����O(�����WQY��f��Ao���+;��U�u�`����;�ɜ'N�]{*�צFU��F[-�J%�5��T4fH������*d��*�޹���2������w%z�:�l|:��trs�D�o�G�����:S���(J:`;dթjC��	_q��|RUu��������#���9^�o�I�y'|�ܻ�wP��i�8���m��9��=��	���1�a��	����Ga�ڐK��^���C��*��.�tKٓA���� n�T{E.-�H��03�C�S��T!��2�a{�_Ҝ.�����*P�u��������t{D�Ŕsp�䅾���ۄd�XXw7�{���ť�o��l݆�$`Q��~�s��� U����_�~���'N      �   0  x���An�0E��O��2��Yz�s�DSM�E����,��K^�T��{��h�#EÔ����M��)���Hu�0�j��+y2�q�}Ӗ:�	c�F캪1��ݫLc3��i�1�c���:�a�F�M��G5�1�{�=;x1x'vd[�>��s���I:V�Ӿ|[�38���Z���$K���18�Ҫ[�t.� YZ����diG���^�d)5���0Ēe��g��dY'^c�~���sr�R�&�ۑ}2�����&�:�c�?w�]����&[0��]�T��Y�C����8��z:�������-      �      x������ � �      �   `  x�u�ˍ�0�di ��O*b+H�u,�,�&��&Y0ߣ	, x�����a�-�I+��`�{k�W����q�o⊡8��=����c��AC	0��<~Te�Y��V�0�3o���A+�J`�{�uV��V�	}���0���{s���S�I��b�
νg[��;���ދ=n�;�5��ˑŨj��y��]���.�>/������x���=O�YZ���fi�ϋ�7���d���>/�>�����Eמ������՞�g(���'>��Q��3r��?�,mH�yƱb��-<��f�C+�Yڰ�7�4<�B{��a�6�y���k����,m��"�ǎ͝G^1|� �GR      �      x������ � �             x������ � �            x�ŝ͒㺑F�]OQ/PH � ��x�ws�W����?,J:"(�~XE$ox��uH����?�_���/�CoAN���rʯ�y�����k�)�I��)�2�y������ϣ������׷�;����Ʒp��v���0ܾ0�W��C�0����_r�����o�x��_���W��������T8u,��ic9���`,H ���-�G���wAPJ��`P����SP|�*�U�Y�-��� [t�; �A��w@(�lQ�o�"��(�w@(C\)C�7�i� ���G���wA(C��A(CL�A(C̃A(C�� �!�6�>�� �!�� �!ֱ�ĄMa0�	��	������-���&���G)1�Rb%b%b�2�<Ju0�6���̄�a,���`z�*�*2E��C�C_�e�������$��5�aG�Wi�����M��������������@7wt���=�ZA�3����U������ݲ���>�c����?���< O��;\��/�����~�Q'����)yD>3,>D@y:m� ��� ƫ$�� v��°�i0�"�m y
z�G�1,�aXd°��K��*i�a�]
�@���#e��n��7�뷜���X�U6�d�YO?}���T�m�e�(��	�H�Ʊ?�"A��� ̓AH��`�6�iB��1au˄���:ۢuߒ���]n���
��������)��5K���?��=�E���R//�ypc���*_������y:�n5?��=�O$j�Vn8�Ë9��k���)?1��r�����-��?=o#K~)�W����	F�y8�X�W��:G�	�H�io���<v��C>`��� �����v]��+�-^������^S�y�ɳ�����q��(\�pĪ��U��qp��+78
�p��s��Q�>��G��x���cdNp-�u�/q�m�œ����bH�n�����k �ň���V�,,���}�>h�2R�фe�t'4a�>��	MX��tp@w����˨7o`�+t\v���4�VW��ۼ�q��a���@7w��Jk-�����ttG��]Agw4�����5sG�f�xkx���wz,��w�N4��ݞ��1|��t@7����c��mJxÝ}Bcw{M/4�pl�h��.9��1ܥ�z�Q�.s���u��>h��Fd��p	PP~#�㸔t ߡ�p|�b��޹6|���>p�#w�8:r����+�L����֛}����^%Oڦ�~K���j6?�J�ǟ���O���Qɀ���\²�<��vz�
�V���z��:޸��ݹ����p<R�o�K�ˮ�g}�[�n3������7����)Is�w�����`���0v��a�-���M�!���B$v}VV�� �O��C���6
���*ވ.)F�C����gwG�o�V�G�H�l�����H"�A�a��_`1��Gd2� �0��H�L���!�zQ�!�z�!*	���|8�V����n�4�����&�&6e5���,��^l��}����>��Ŧ$�k{��R���N솮���F��ȶSZ{C�Z�g�k-��ѵ>���Fך��ѵf�ltm��a�k���ѵ���.�C�x�f��\:u�7��e���{iES��-�oi:�=o�2� '.Қ��FuX�R ��x���ak|��8ҙ"�t <��� 7�v � /�+��7�����'G��ט�h[��y=C�Y��:Z��$�J�xR��I�Aڒ'���bO�t6�!0���'m)�z�,|X�g$m)J< β-� 8˶��,ۢ�Y����lK9 β-� 8"#�N�T�� 8
ו�I�5E���Q�.����u��~p������p]~���2���(\���G��,78
���{�i�L78"���S�\�]tL� 8"��pD&�pD&�pD&���L�����ᴮ�9 Gd�Zd������9 Gdr> ��d= ��d; ���r ��� 8"��?���� 8{5]e��v��a�m��Q�pN�pN�pN� 8
�v ��r ��z �����D�p �H��2��r2
huGG��]@�)�ii둞�����]��Nܵx�u!�Fw4YG}���y�gj;���U������\�8��3YR���u	�I�V�Nr�ޏ����go��[�_xB_�L�㎜�
:��tvG�ꎮ���@gt"gS��NwAwt-�?8�6�w.)ˡ^�?|pg4?x�h~�(�h4<Fw4�;�;�9����h4<�;��Mn���Fͺ���[�/e�c��l�&Rz�����w�H��$�h�4Ew4B��;!M���&uG#����i*�hRx4Uw4���������vB�fyK��>h�,o������-e���Q��\\'4j��]�&kF���}�L������^��o�>I���f^��:������kM�h�uج�y�ꌎ��w�a0���Ah�kw�ax������&�vw�����ah�kw�ax������&�֊7�^@�Ugt�����n�҆Ȟ�!��z-��z-�f���f���f���f�uG�UsG�U�⍦`@�K��f��j�f!w��M��juG���s-�sœ>�&�h4ܢ;��F�-���pSw4�b�FR�x�IV��h,Ү��秅�F�ʖ�\�A�fe�I���Q���(�}����P�}����P�}�����]�dTj�rB�>h�uY�뼠�s��y]�;�y]�ͼ����R�;+�fw4jV���UsG�f�x��ϯ]�n	פ�tB#)-������FRZtG#)-�������Ii�FR�����V�Ѹ�Uw4j�Vjt�������N���AGw��N�h������+hsG7����v�P��z�f��5���F�D�Ѩ�Dw4j&���IvG�f���]�¼��f^�����v�2�f^�{�����Q�����������뾗�:ѯD�ڃ��.����8�0�O.�=�c���$/�R��8����c�EsG��⍦��buG#�iݨ:�У"��.K�FTStG#�)��Ք��HJRw4������⍦��RuGc"����I��}ШY��v4j��+�5�[����-G��F�rvG�fy�q"��Q���0�}ШY�r��.h�ʬ++�9��>���h$E���htG#)���HJWV�FRT��H��;I�⍦��JRdA�04�b���������h$Œ;I��FRL��H��;I��&kڬ��Q�[�t��:�(=�Q��ѨYw4jV�;5+�����F͊��Q�b�hԬo4��V�;5+�������:�F�jpG�fU�ѨY��hԬ&o4M��Vw4�Y[�9��� �
�2�����k֢;�׬%w4�f��hJ���oxwt}>�g��g��ǲSɧm>-ppR��b��Iw��x�jC������He��0{��-�l���G&�ܚ����f�h%��թ$a9G����L�~���^��?�;�ߣ��]c���|�v]�EdeN�p{�c8����!O�&��O���9���L˖���dZ����������
Z��:���䎮��;��Vo4���2z���j�{���v������F����Nh�L�;5��f:�Q3��h�L�;5��F�T��4�o}k�|;��2�FR��LNh$��oz����+�I�B9����+�I�B9����+�I�B��ɮl}W('4jfk5�z�mFve��Fͬ��Q��ѨYw4jV�;5+�����F͊z�q϶b�hԬ��,�:>q��FRJsG#)5����*�h$�Fw4�R�3:�<��ʗ�r9�k_B�W�)~?�1WO��ڻ�|���ѩ��ǥi�`�I_��j���&M��n�Bz����Y�Wx^��	W���@U�Fә�5%t1�t��|B'�⍦9��UF�:��1�kL��$�$�l(O���i�R����tqF�G�^��MJ+��%��Wɓ��YM�W֮�箦/�>%�����2l����-�@[x�t1*!�2$�E�)L��Q �  o�Wy�n�΃�:�r�׏��"F9�מd�:\gO�t���e�.}�S ���N��=I��+�,}"�ص7��/�A�j�h'D�� �0D����C(�8q�=i������B\c��}�-�*\J/��^O�uO�Ŋ�i��]�'D��N��a"��a�!D�( �0D��L=�Q�k��b]X���!����:���*wF0�-Bd��Zk�>ޚЇ.˭	�e(�_��6�B���ك\TR�>���j��V"K�Ly�!s'8�i���<q�DY�%[���<����3_e�eϻ��W
[[��1u��C3�Z����9%�tU��Qj��V��K���Y��'�%��#!=a�h^�.��g��{��>�p <_��N��< ���pֲ��Y˒ g���'z.9 '�WF#�/�ap�y_�g��t �y��p�y_�g���]78�ξ8�^���(\_ ��t��D����
G�&��^M�(ݚDP8�5��ptl=@���$z��ѵI� ��o��
G�&�ǟ�*����"��p���p��#2f�+���k�p*I	����Z~|��^pD�l9�h/8"S��N��)� 8"S� 8"S��_��)[H��Ȕ�O����^�+��^#��I�����Z_�*���M>�D���l�m�����+���n��;�%=���&_��#�O�aA%����k���hKQ6�R̟�����F[J�g�-���#���Op�ʱ�1��V�_?)2�I?9NvK�I{I4��ZW�Wt�,��W�'�q{�,�-��W�09y�)�3���!��@�}w����']��| ߒ��%i	mb���l�k: �ƹ���� g�^� 8{����:��p�y[�s�dL��UZ< �<o�����vEe>���['1>M,����|�z�����'���.�iO�6Y�!(��q�b���!(��OC�A�M�A5�E�<N��<���<����<Ӑ��V�F6w��і�̲.���b�8O�Yd�yZ�0�a�]��̯��̣b��7����F���q�7��aި~׺�3�v?������9������|������B��WOj�������~*�/����T�a��I�CFN�T�f�ld*}4�zRi��͏��2RW��kN6ȳ�Ӕ?�{z߅�8�OB�G�.D��o��I�s@��Z�����s��J����/=}�:�m�����FE�ss�*j����Z�xRQk��T�Z�'�T����j�TV&��S�z�S�)���R��U�� W���u��������:w|����_�}�J�'���H5�ʂ'�2�"W=�ȕ%O*Sز'�4��"�fnT�)���B���:�9�mw>�1N������-?o�����ߝ��l���~��K���kdyH����d�Ǉt��y0m�b �V��ȸ57&d)�����c"�%�1�1��\/���sb�m�
��#��k�_c��|O-����2X��N֟^�I��~���'�u�����憾���/#��e���pe�w^�헑���Z��~�W5��E�?y(Vҋ��u�yk}��d�mt�u�D�چ!�0A��0!��!��4A�v���Ħ���F!��u��Zd~�`���4wF �!C`�4��޷���itK<�(���kwz�"v�ª�ׅ�L���L�P�E������s�w)�U���[C���=�9��Jh�^���D�0�&qM�4A�`X�l����zs̄)�Gw�����5t.i,���>QnG9N ���̷�+��IkXI��B��,u6ח��O��6ǎw^�?��W�F?&�Q���u�~LD��U���,�n����<2{N���>3u�� �|Q��+��1��ߺ�g�1�&`i_�=��8�d��ȡ�/fb.c֪�.�������� ���     