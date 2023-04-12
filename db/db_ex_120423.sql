PGDMP     $    7                {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �              0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
    price_purchase numeric(18,0) DEFAULT 0
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
    public          postgres    false    202   o[      �          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    204   .\                0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   �]                0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   �]      �          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    206   �s      �          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    208   Wt                0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    303   ��                0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    309   ��      �          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    210   ћ      �          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    212   [�      �          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase) FROM stdin;
    public          postgres    false    214   x�                0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    315   �      �          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    215   �      �          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    217   �8                0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    295   G9      �          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    219   d9      �          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    221   K>      �          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    222   h>      �          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    223   ?      �          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    224   3?      �          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    226   P?      �          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    227   m?      �          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    228   �@      �          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    230   �i      �          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    231   �      �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    233   ��                0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    312   ٤                0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    314   0�      �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    235   ~�      �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    236   Ѭ      �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    238   �      �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    240   *�      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    242   ��      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    244   u�      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    245   پ      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    246   ��      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    247   +�      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   k�      �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    249   ��                0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    310   ��      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    250   �      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    252   ?�      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    253   ��      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    255   :�      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    257   ��      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    260   �      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    261   ��      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    263   ��      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    264   %�      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    266   ��      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    267   ��      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    269   ��      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    270   ;�                0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    297   ��      
          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    299   �                0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    301   !�                0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    307   >�      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    272   [�      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    274   F       �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    275   �       �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276                   0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    317   �      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    278   s.      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    258   �.      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    280   Q0      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    281   �8      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   �9      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    285   �9      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    287   `;                 0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    289   };                0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    290   �;      S           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    203            T           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    205            U           0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    292            V           0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    304            W           0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    207            X           0    0    customers_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.customers_id_seq', 680, true);
          public          postgres    false    209            Y           0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    302            Z           0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    308            [           0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    211            \           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    213            ]           0    0    invoice_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.invoice_master_id_seq', 879, true);
          public          postgres    false    216            ^           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    218            _           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    220            `           0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    225            a           0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2209, true);
          public          postgres    false    229            b           0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 514, true);
          public          postgres    false    232            c           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    234            d           0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 277, true);
          public          postgres    false    313            e           0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 24, true);
          public          postgres    false    311            f           0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    237            g           0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    239            h           0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 22, true);
          public          postgres    false    241            i           0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 52, true);
          public          postgres    false    243            j           0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 328, true);
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
          public          postgres    false    277            x           0    0    stock_log_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.stock_log_id_seq', 868, true);
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
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      �      x���˒㸒��q�"^�z�AĎ���P�.y�PeGZo�Lw��YY����ټ�p�(���*sQ�o�K
t���?��O��ͦ����������B�i����h�[c~S���OM��4��������X�o����f����ߔ{T��OV�b�{x�����<UB{�X7�ǳ���xa	�A�7������1�'���0�&1l�/���jVCTB8���=��4OF�B��v%"�t`5�����`���7�B�� ��^����|�b�%�/��>���m�� � >|�_� �S�� $�xX���w�ZVC�C�[��oxp7vn�4��k>V�������bXn�!�?V����vs74j�N���rw�'c�t�j �������߂QCl"x?m���'{�3����j�r����sw�� �?��w�bx�z��j@������h��>]�����$�`x�-�! !�����l�6�F/~��-���̿��� ������W9$�3 �!�ig��:
ܰoX!0��=�yO�&��������x���'۰B�~`�憝�a5���[�@;l�XH��y��7?l�Y!H��}��n��հ�g�IC��m��{:���7�4��g_(DhgAҤ!j�C�G)����n�m��y�j�yخ6���u8�2�wq���=\�}�oxD�q����XAHq�>�7\�hn�Gk�jBK�����y������~?�^c*-h��N] _�&�
�!@�����|�ۿ���y����}a�4�t���n������v�����U3����7�Gi�{�ZP�&gt����jE�o��*�<�Ĥ�v�)��ToG�!����rQ�)��\�Ob�ގq��̓jX�n�n���^�����B�!��p�s��?�!>2�!i��s���s4��Ƶ�ځ�b\x��u�����a���BVCh�R���2���ƅ��abbe�hH`B�Ӿ�U��:���Kϕ�Q�Q�����ݗ�mlk���u��w��k���w9Ͱ�r��J���"��9�ZC`,��W��>���x�6�C�nw:������>�α��`؝7絆�$׷�?��}�׃-����q`5���?�o��F�j��.v��0ty�����hX+�i���$�e3�4��Є|ȸ��ߟ̵�˕4 A5���D��l��H���Zc��k˸U\Ή�Z�`Rd���u 9Z�1�g5����b���ßλஸ�!zp�A0��Ce/�5h^��"b�8v��H� Z6=|l|�4��
L��拔4�|j��/�	�nxex�̷n��t�S�ɞ9������W��*%APW�o�a��\��Ai�����&.\�&�A��F��
��a5�Б���ǳD@E<�����ߦB��� r�b�p�#�5���ǭr��Z	��A�#кVj��(mʾ8V�X�qY��;���D������U��XG�j�&790H����At|s�o���<_�A��S���g&G"�-�Z�����؇����.�#i�y�������?<~_N����������)R�Ö.[�9����hx�c5�}8����{����������?<���j>��i�qڽ>ׇ��xS0C�0�D{��tHg;]��JB��ߦ��c]w��&���s�V�A$yz�Q7H�\,�-�R�b\/%(�wk!0)��C&�퍱�	I�l>�d�AH1��U��J͑H��4y�o����ꄬ� ��כ���� 	mk���h����4)�\��a�.|4�:�-5�#�^�qT�X�q�L갅~aV���LK���Ú=~?k�-d�A 1������2�w�lI�8�2���2yYj�M.��$_ ���]H�8Ҧ��[��'"�6&��A(��RBh0}�z<�U�YO^��m��>���Ԭq؇?����?��?���$։Ν�A$.�������� �<�)5�]2�m�A >����-���*�Z�8������������������ �I������?� �.�! �vs1����'Q���?��GF�c�8�-5�$���A �����,�(5�P��G,`���J�����x#�>k�� ��O��d��d�5��	���T�c�C��㡺�a�}�6�)r�*�)4��#����=5I�8RN V�I1<��Q�6�R_���(�yN�jHڦ�ǣ\1���"��$���oW�'b�S�R�@��_V�m;�eub�A tj%�a�+��a����Jבɶ��
�H����� ~uMU�YjH��A�a��C��Qj�����]	�Ȕ9_�5�|���zQ�M6۲��O��~0,�p�#u�#�)����c8:�#�ѯ������������Й��S�a�#�R�0��}���q�e!F�Aig��c�V�8R�x:|����f�Ð�$?k.�nϐ93s�!$*EpUx]hB����������tIIJ�f�ҤA��������Zw�$H���\n�aDk*~*L�j�I�`�MD�"��f�%���q�kX"H.�3�a��L��F�kQŧ�� �s�#)�;��Z�8��\�ў#�Z�8R��C��m�ͬq��]�M6�9B�5��.G���WO6��Z�8��ܞv�O1I�\��+������FMq�� ��F��a��IAԹ �� K���WF�ה� ��R�W�=LF/8V�H�|`�\��9l8g�j���E!�+��qt�8i	�t,ZkG>��~tM,C��� M��ob��_�Q�8�b5_�q����A�~������I���pL�j�.~H?1&�\,T� ��R��LZ[պ�m����Z���k����2��o��٨A���q8�j�W�q�����A��É)'����̨!��R>�Gb�ܻ�������XBI{��!�nmj�v�L���F���9��5#%J�_�/7�!��7�6���ƈ��]��^�ݱ�����Vg�����/�1x����F.f�f��NN�Aɇ
	��"H�3rƎ^
w�HC(t�+�+��W�4��H�0<�S��Z��^45k��$���y$;j���݆�����+Wk�e��0�$R�����0zH�9�%���.y
�|��� ���Ow=t*�9_)�5� �G�vA��e�� ��K�,3<i�o:�v�:�F�đ��9ʭ\�A����� G���c5�#�'��:�I��Y�M
�?�I��d�T�B�P��\���R��\�^kG
�c�V�oӞ���|�7�"E	�AF�A(ə.G�\&�MdMט�S��n%�h6�k�5%� ���������%QT���V�0�~��_�>��-�Z�@�~���C��P����H�us:�;���/C�|����)Yu���4����3{��M�Ĉ����H�O�4��e}�������b�4jI��Z��Y�s�O�A�
���5[���5��e������i��U�F�w��q�����e�u�`�A$Fz�y��V�A��~���Q�Nv�f5��&��^E�/�h�$������Y��A ɵ��/�/X�F����4$7�z��g2��EƵ���u��T&%�q74 �!i>���mu��-�.���'!"�����9�e,����M�[�d3����ȨAɳ.���=��Av*;����1q[N�5� ����wr�ɚ�橀Q��J��V��њsOW4��N�o�������d� ��;7�o�0��D@M���nqJ�r�����o��њ�e�&"�|�#P�*�(4�Θ$ ���A fڅ�'0��E���q� ���b��:$"H�K��[�'k�*�,4�����7��j�
B�����G�� ��E�!(Aw>Z�K��K� ���}��r��y�@�M:V� �u���wɤ
$[��B���ެdͥ�@�An��V��lpݼ��h7~ybi������4�$�[�9ZuFim��W`��i�A04E���0�h�y    @�A4����@���{;�r��1M��*4&4y�	W�l�r���u}������!�֛+,�*�)4�%�5W�xOh�z��Ō�"/0�a��M����do�7/
iC�t���h��
"�y͗Ս���9]�����?2�@�� ��WW��&�ښs{�Z�0��A�9ʐ�� �@�d�=F��a5 �Э$� ĳ��%��%�����37j�����d�^,��A��e	D��3aiy�Kj�Mړ�+����H�C*2j�����Ф���h�l����jGJl.���A�d��U��ԗL
	Գr+�<��XA��H?V��ɨ��V
Q���6/+i��ɸ�j�K��a�in����:Wh����I���%"q����Ѹ�?� ��XWϢ�3�ig��I�8rvt}nDb����s��t/kA�ɢ�N�H~���,*J4���RG��J� :����L����
I��(���kKI�:�B�H(�Zg�����O��1%հ�b/+�M�LU���Φ՜s?���5W��SA����=o����*�)4��&�Qg�jy���hmPM��`:V�h�1�|��L7��$_m�
Bʉ��v�6U�S�q�w{�*T�
���Ol�S��`M���m��cS��jP���y�WI;e���$W}�B�K�2�c�A �i�w������D`���Y��9��0m��7�����B�h�����g���B��|���]�QZ��xo.&l:�UՉV�AH]��,��CVm��,4�$�/$��	p�!$4�i�e]�����A*_�`���m���'(�vUń��{ޜ�$:%�v���4�$�o�׹��C>�����A�S�@�~2ٞǟ����o!��@�� 겷:H��f�8�UH�8�o����F6g^�@R)զ?V�wD�+Neڳ� ��)8����k�M�]{�?\��i������&�|2mؘđܱ�O�&��=���-�,�r��E�j�Կ}g�u���]��)���D�_ej+O\h�\i���5���/�r\�y)!�D�[�I�˥.���B�@(�Ћ�S.Km�A��]D_*�]���"�D�2��:�(4��.M����B�4 �1���н�4$�VP��$Wݩ+4���^emG]���>]� ���AT���� �+�_$�9�h,��5$e�[�I�t�	�q�N����W�A-�D�~
_�Ԡ�̨�\���#0 ThqE�@:�U'{T����A#MV�'�L6C���i���̶ٓq��_����E�b5%�d��8��;i��N��l�Y�1i��%":Ev1t���-4��|����`���,��4���'SȤ�.)��7��
�d4�Mc5���q+U��U�	�2�j���!6�1���w؅�+�s�����V�!Di����E(��m�j�ʧ�"_GF�*{Ph�N qJ��ː����P�*����sn�j�B�0h�ԫd?�L�O�f5�:�n{��B�������}[�.�٦�6]��đ�f���_EY�6�I���4�����&&��Y �a�C0��6'�]�j��e!(�tU]f�At	a%����.�Bف% ���i��P�����m�q+4�����'ያSB�c5��M��;2����� ����^������Ax��z�?mu4j��Ss�A )7p؋z�%�6T�j
�4i���:�W�+�4 �6);�[�B��z�đ|��ٴ��i�&�.ʦ��z.Z�AԺz��:|�IBU%Uh	��[@�Bp۱D�(�6l�$	�Z�V*4��=�J�h[���E�2ˀ`ḥ^�"s��Uy�B�H¢r�ѪҬ����[��w�.lfޤATM�#���6�_��^rc&���Q*4$O8J7�Y���3�����*��Zu�uη���>���g�����Ȇ��<���1�<��i��ե�<���.�� ��0R��G�Ē���C�c$�]��,4$�U���5��I�!$���lO��	��v��,�� ���RZh%Y��R5d�Wp�A yLՀ :�Jfu]�YhJ�	|��B��fo^���w�'��^�� �v��o�i�x�A�^�S�+ -�@Z���",Yy���3���|�짨�'Y�M��,4��4K΍|�E���m�t�%�OJFmU�Vh�������Tt[J(4�$_����n�HF�K�J}����7G��$׺��!��
�
�h�]*I��lvUZ�� �V&�a���;je[�/o��d�գ�
!����~ �u��BC@�צ���Y~�� r��H|u�Uh	e\eCN|.�Pk��bmnC(�1��V�@,��<�rzd�T�i���W��>�<9V�8ȫn���5��t�iV�@rA7V��P��	�A4,`%�]rk��� ��i]���}�V�*�^>��>�����e5�C���Ç���n���4$U|�Ub���e`5�#9��ա߼�ILU�RhI��!��\L�c_��� �Tk���%�&�s��n,�.�4���V�;р�dt؄�Y�I�@�S]s�Ѥ�mT'�h�K����oհġ�<!G�w�=�Q�8����j��L���N�Lb���2�:Ɯ4�.1U�f�A �ր�+��E y�r��Ea5c��*�c:5!�q��%�:v.4���	HSTTe���4���A.?��#vu�/S� �p\	�T?�4�AЈՍ�:�Ӧ�� 
����*�.4����$uC�B�H��BS�昰��Կ(#��Ɗ*�j��m�v�˭]�$Q�.4%�S�E1�U;�B�8(��$r���4�d]i_v����B�@R��}�}-)�$��*+*4�������O�A$&{�Ī���� ��ěl���p��[Tz�����a�A )���c��߅4�熔�Ҧ�z�j��^v�HFM������^vd����QC@¹ @��M-9��� :���f��-�|���h�-�vv�Ab��f5���1u��7"�ݮVGQ���ڪں� �{��R�d��w$���tuc'@F}�)4���"��C�Q�H���ǒWة�.k�A$ɿOߥ����m(4 �5͒��.���ޛQ�@Ƚ��'1��2��q�+Q�*�U��� �tlu\�>D���xE�e5������ӥ�j��_����d51V�H(%���:~���0w%���L����K�!u}s�A)Ѻ�0Xb��d��m�K�X'��! C�]�
��ũ��&�Hɀ�4΋� ��ݤAy�@/)H��yL�A&��8���@;9E�U�D@<RUIS�A���"=��M��.��B�A�ř":�P�� ��M���QĤA !W�,��!4P�u��D�D�Ֆ� �e�F���4�d�D�._o4�A$fQ����d�EV���%�G��9|�A �Y]}��4��lCThG{�7���(�� �le�uդ�B�@ƩZ�% ��� �0�!��GB:WU���BC@�5��$e�h�A$�k��?���
hV�X(��5$%����󬲂��h�y.4$yו(�����14����=����]v����7Ǡ=Z]���E;V�X��u�]Kz�|�l�Ay̶h�:�,˜�H���AV���ں=N�! t�j��*��y*�� ��|��Yw�L<�i��}�Yj"�tuW�B�8��ϓ���]F��i�����5�4��C;��<=K��Ħ���J�A���&M��t�\w�-4�%'�G�\����*�jI��\�h�jJ�_���JL�G[VCHhv�K����h4���4����ᯘ�̷���䔫$[2�T�� 3�.��8�� v��$�Uo�B�8�,Yo����΂�Q�@Ƚ�Nh�*���5U�jKN,x(�� ���w�uem���h�IGS�N_���f���A����S���3�jFr���g)�eV��Wݾ���2�gx�ʆ�7�K@��`��Xz"��W!_���ǤA4=�Y�!�J�đα��D7�G��� wfm���s�U�<Ȧg5����ۃ�� &  �_���p��_���qK�g_�IC8h�B=cH�8҅Vi\EW����ph��s)�;��
I���j	�[-%��� ���%���U�qP��OQ����ّ��AtI@�(�&��q��A=���1t�+6���	�ͩ��I���-\jAO{%�|[KA���*���m��-5�`L�JjV�Ѫ�Z�A :G�;��PU_�R� (�Y����Ў��] W��3�l˃�R�8h<@��})&q�� �6��KR��h� ���ҦQ�e�Y�A��A>����ۓQ�Y	�=�$��I#`VC@h��BeX��e���dxT��bd�k��?�Q�7�VuYMUjI��� ��F]y/�� r�'I3�l����I�8r��wI�{2���6b�A ��j!��5�$y�o��QR%��װ��t�.�B�YB����vٌ���� ��ir]ׇ�u2kV�P�Xٵ��c5�����hrb4j�>���$�;������YŠ`�Cm���^�0�L��� �Kev��8��ƺ�9
iJ�g�Ȯ|Of�f5���g��\��j�g�A].A�ߍ��N�D���G'��:�(4�@%���?m]yw�� �;~�O���k�4��6����mY�Tj���Z�OyB�Ӫbu�]�z`H�At����R����b$"h�R��E�14r�� :�_�;�G:��oܭ%�ڄD������i�b׫2�Th]��A�������JYj�T�/9H�Ҍ�2I\hI.�z��|����B�@�~�Y�c!�l˒�R�8�w.Qv����Q��W�/�c͟ȨA �li!�b8��[��E�I�U[Ů���T�lxL6꟮h�J��ԛ�ICHLs�ڙ����_s�����A@���eud��iCcB|KgbΉH��4@��v]���W;�B����[��p��	 ��(�A9*{�>�J��Uc�+��Vw�K"j�NQp��3@*�X��4���yFaXh�4��~�����×��oX�R[� �DwYO�W�M�N�X�2ٶ:H)4�ɦb���Qʇ&�-�'^�iX�2�C/hm��h[��1m���^�U׆��Qj�1{�F"��+�i�}�]�r�X�j�f?ըA@�ׁ��{6iPr�;.�r�S]38F��yܼ�Z��������:���.αD������n��ej��B��:��u�Rf)�ѝ�eĮ!��Z�DCͱ[����6��mY/��6E�� �ArUThR�]���k��V�q�k�-�ed�AP�e|r�����a]�!J�ŭa5�(��_'�X"J>�s�U�i�x�Z��~z�y"�{	��g������*{�)��nXbjiyo��JǿM���M]�=�AT���i�.Gb��7�&]�sE�0��^�]�bH��]<R(XA�c��������f�vj
n<�AH���,��n�>b�j)�aYB��b�WIJO��N��a������:�t���h�XΦ�AH6-�*�iYbrS�W�Gc���1jM{��n�5���]F]�`�Y"�����L�C�� ":|a�&HvاiϺ��Z����|�*Q�j�o�a,�9;#~m&��?d����Jy�Xoٽc:�4��͠m�Z���y�_�o�	C�Ա�ؐ��4�AD4a��}sW�
��dcC��u��ud�&�F�
�B�@�PءO�K��n���M�ٷc� �6�|�{������b���`�1��_G��� �c��k�;.��7<�A<t�ؿ^����(���d��BC��Ib��4L�H����_�����            x������ � �            x������ � �      �   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      �      x������ � �      �      x��}ێ�8����+���.�[ڮ���\nT�g����w��T������g`o,�/q]����?&e�Г6L���'3�Oj�3�������?���S���?�P�q��B1妇O�����������>_^�>�������ۯ��ޞ�^?�.響�������gD'�I��S�7�2׿��	�I=j�S�J��_�ԯO�όX�B'q�*TE���-������ǧϿ^�]^�z�����_ޞ.?�_V����?��I�:�u)t)�C�B?*�b�R����%���Oo�~�������\�@�̪���^d+sS��7��B�ό���(��>�?�M-�R�
� *�G�,a;*|}���ܪB���_G&��Ϗ�/�^�~<��R_v�jz�*؁C�����ׯ.�_I-���B�G�j��-�~��ÚOK<6I���Ux�m���L)��>~}~��.��˯��\��z��V_����uX��N2J��������A�G�F1����몼~��_�Bh0c��n��2��AM�zhQ�g.�\��Bwo�������;��O:���h-ޞ�|y��ϗ��~�.�K�y|�u�׿(=�����yٛ���zY�tB/+Nj<!4R�ڤ�@=N��N(���x~����_���z$M<�����&��>t�v�v���H������j��T|����/�W���u(��������~�������������~��٤��yt����%���6#��Ռb��H���oc5'�׿����o��v�o�ҷ���u�/o?\:{P�AC5֫�-(֡�j�]h5p�Q���x��$Y��\�E:�J坩&li�Q�z~T��me>_�������Ï������ު��)�GI�t��]����NK�S�B�z�u�S?_�/6b�(�s�g�0�fn)pU�u+�wh���Rϯ�
�tx=X��fX?��b���]��Zσ.=�<p�n{��,̵'����M�͝g\�Q!<*�b�
���/��{��Dx�J�X���}(�����ѨGgP�~�m��ͧ����Ȟɽ�D��,�C ���H#A�F�֬Az��w˿�ϗ�o�_�.z�/���$���^j�)D��+�Q�eOo�1�bq�C$Tf~p��X��߽�ob``�e�������w�:L����_m}�lظG��`TZ�$:�?�HswC?�.�?��_~�ӡ����U �8�t0XXQ���;c{�m]Eg[&�ݜP�ew��գ�(��9��9p�Ey�:$�!З�C�����0i�և62����2ܰ.#���h�:1����b���mC�.DredG��^p<V����0d1�<N�L�qr��8�J���ҏvz��!��\Q�1F����XπG1D,Vx<Y~kl�X�]�%o������߯6�b;73c�(|��K�rsS2��\�����]wC���)e�<8��C4]�{��.�|���Fʏޞ�ߋ�+�Ij��#m֗�G�J�{:Y:'��r*|I��a&�?�X<'���+T�I�����:D�d\8�<DQʩ	Ȳ
85�\'ڧX���� �fwY^����B�o!�Ы�lY�>���[�.5c�LΖXj.�Lܹ��g��_������̗/O��[/��ϯ�>?���g���a�$&<�H,���V�'�:.� V�4?* >a��&��4����56�ӭ%+�pel��v+�B��op	x���d=�djU�(2�F��_����� w��k��V�QFA�b w�k����&b=��wǢ��_���*f���ГE�mO~{��������C��V]3��IT��4��Dh��(֑�e�����|����v+�H��OtB��.�|�h��l��&C%X��T�j�#T����%�J�m�b�ZY�Q`�y�=��~�Z1����� x�V����Q�A��Ui�Gp
e*q�:x�c�!4�:N4	L�����F�X��وq j9<���{<��z
�Hk2Pfl��:��Iho^�&zXV��x*5���h-��A�͔�����Ǯ�@o�|�XC��ul&�^�TGB�D.my��p0���uTJ��݌b� wl��ClR½�����12�W��-�yY`�J�U*m�O��2C�!r�=�Xc�$��a��դ���gl�J��gb��9X�����d�u|�s��9%��5���U�&6���̘p38����V�=�Qc|�#m������FUnf��@���h�)�MgN�gN���t��⚣(�L��P`;��1�V?�.B�tX���z\\҆�j�V���0^e���'.��z(��RK��m�Qﺱ�0[�����zzy���N��?{ƀZ7 %��,�,�|��q�iS)Ƒq���i�?a�c�\��c����8c�BK��R� �Z���5P\���T�c�ED+ņ����+P`������NH%�L#aG�J�x�y�o���I(��Kұ�?���;�X�����u��#Z�}-HEqÖ ���$�S\>K��(�q����RL��Y_�����@E�
i�jl���/����%g\@d˹P�`�p�>}��R��o>XjE�>�?�x�����	Ő-@;�J��������P��V枘�1��������Ҏθ��p몐f�u���K���V��)y�/���?���ߗo�|}�vi,޼�6F�U׳	�zA1Q]OkԂ����� ���n^�9���a-�qC%����QA�Lr�[
�#;RO5�V�W�U�s�v�jV(�K�����!�u�:-��+PPj�k�f�P;��6����H���hd�i����q�o_o�Iǂ����'��kU����=D��A,�x�������l2���L)�ʤ0%�8Y�a�_F�f�3V����i�ɞ �4���ӦM2ݣ6(&b�RƐb�ȴ�����+�k��H/D{��/���s�5(&2�t`Z��V���'.�؁d|�1f�XwO���.�� Xc]�<)B-��lz�`�Bs�1�5woP���ke��P���_wqߖ�x9�Z=;��n}�x�l��5���ߌk=�%�6Y��9I����/�V j��|�_������O�.o�
����,[E�"����y}�r����˗_��={����}���G�B Ta�֣	U�|�	��ܐ��o_�����ۮ|G?I�C�]l-��%&�΋5�=���w�>�+(�c����e7P���.�Hy�ү�[��(��H�>I�-���E�:��9k�ҩ�F��D��v{�	�Δ� �N�� �HP�*�ɓ�3Q���.���xQ8��RT4��4t�2MTb���v>]��X�s�cjn�;Tq�Lo�<����/�uJ쀍��k�+p�<\m��jab���^O빊v���Ui9�ҭ�����}�����ֳ�ʊ �$�+����IX�\՜��V���j�lq8:���u���8M(�Ӥ����
~�t1ϸ@��)"��<�&6���� ������f�֢��jqJ�8�QE'���[��'��{R��΃�[��Q���U���E~Iwo7���x*�ױLəA�P�Rb�j�$v����P�,�K	�j���c�Ŏ��G-����c{�m�����ס����1��3\�՚��P'��������1alR��1�º�5��Jl��[�챾E��B�fUb��s��W.�ꄑa&&���Z�6˸'��W#F���(���f*��J�62�Ї���/��(��cJ��:�pX ����Ć�$�tQ�CT�˶��B���������]T�LgLx5e��}9wVg�v*��JLZ�Qȝ�T��Tb�Ur�>�6d�Po��ᩱ�� �HM[C!1��	�jL�T����~��蚥@.�g2w`O������+'������tʢ�x���G.�$�"*خ>"�x3���f��B1��`n�@E�)������v��{Ob֘(���iX��e�x�w�EbX�z1L��`2{O���F�~��������~y����~WTl�e��G�<c    6!�t�ng���RL�"ٻL��
})�,0��mPL�2�$�)!Ԣ��\����>I����x#I��$/�	�-�5F���{o���-�a|w%��8�Q���(F�q�[����@�4�-��Jl��F:��8R*}~SV͕XO�1�L����DJ�^L�
���o��89b.��Jl����#f���8��x%7ǥ$�#����	y��#�o�q�Cu6g�Ɨ�%6������F�E`^���x'��7%&��I�w9���r`���:[ïJT]Z%v�5<0������%&�K�m�5�e���ʖ.0)AJ��F�er�H0/}f<��o+���1s(��e_=��S��p[�/֬��1���4�Fǀ)����yF���5	��Vy�������P�)ri��S��f�Ş1��~�ۋy��×�)8���3Io-R@�`���^�s��7��¼N3�\+*$@��6ϴ�߸�I;�=���yj�ٻ�3U�A���[hfohX�dD�'c�)ą �]��oI��Z�t�)j�0&RM_��օ�gn����Ʊ¼a�Y�|�X�9���[}���{ cT􅗌g�e�O}=Ɛ@�����,�a��G��nˀ���|2����:9�{���D1�x���#�U1���փ�rN���D�O��.�L�Y�̌�6P�ZZ��u��L�hQ��y�
D-��mM���UaY��ą&�CP���ءrӅ2Se:�Ȧ�I'Bv������*��&�%R�6m�7�w�魢'������ǻa�a�]�}�_o"S�`�,ζ0��}�Eh�b]MF��@�!�m�&��_�U}�d�a�K �تĮ�:����s��tA�ݺ+֩�x���45/���F�c�56��ME��Ǜ�l�)����q\⭀�K�;��\��Ɖo��4X:�����p;�?�"�1�5&#ǈ���}�Z����GՊ�}3��t��K&����Ӆa���8��h�1�����;BGL�lID�r���R��Yc�
`���G]ۥ�ZdL����-רؒ���v�a:��}�4�,Y�����b&���#��(&�{�B��bA'P)T�a�,EN�	=�9D+��������iT5ƛ괹�C��d�W�Ԙd&�V�5�-���lf��Q,>#�.(�>�U �g"�һP�)j�>��r�V��\�GR3�!`+��6jA�]S�3�#�^e(ҁ
i�7��^�Q���=�7��T�}(M��)=�Q˰3=�����s�D�˩jlg'�Z���2��T��Pl�?��[8���H��L��&�`��z�a{�����Z
B�b#yj\���/�t_uQ�p5�VL�	��I�ko���=OZ�F��p�-��ff����r\v�L��W=i��n���r��Zc�e�Z��K��h,�6܁�5��ƷM�g�b2�_3�>����1aQLƀj�J���:���`F;h�1-]��XE�;m����iC��Bg8ɳ�x-fg1��=���%F��-y�N�נ���}>�Ql��N'vȴQ�N��p���a"�N��0}#6�˽��d�*�ubSv�)n�!���#vv�oPl�a�ޥ���Us�e_cu��)1ң�.6�M�K5�-H�&��S�5v�6 i�Tc�4@ڴL�]c���֠�x~�NEa�0�$�@Q��X���
t��~Æ	һ�����J�\�%;��WK�`i��l��6`�mK��a+��Ï�11˲e*��o�Sb�N6l����>[��X�=�ةϖc*R0�t`�0G�&9��sMg/(&ܘ�cd��j4�@j@���As&j��l=�X��ژ�ӍE�,cm�G4�3�&8�a���	����v_N�%]�㑉8�/���������9���X�y�˞�Et�(�b��"�Ed
�E]4��Qm����wNS�!R�98]�
���ַxn@1Q��Q9��3+~ԅ���c*�C��#�D
� IzY\�w���$��g���ٔ R�J]r�=� `�I�y3�u, wNi����8UNn�ԁ�AS�B�>h��M_����3���4���q�U,� ��D~�I���C�i�B���S�)3ƫ������g�L$͛<�u�d31]��6G�Y�w��`'n��"}%��3�.�p}s�7�s���$�w�҂���k�@���i ��e������N�eR�DV۹R�7D�pU�I�u=[�u�К��%J]��]5v��LLD�=є��6��'��\U��Ņ��ްag,�@�R"(S����t�\�2�3��F։A�D6��$���e"�U�
 ��ɯ���pZ�����7!˝ϫ���3}���Hɛ�p�FIj4�ZL�$� �&}o`����x/���Q�33�E�S������J}|�X%�G8�J�-[zƆ����l�/_�l�=�H.�Ⱦ��85&�$M[�0��S�Ԅb����&� B����֘��Xsd���-��jL֙���7n���g"&S��gbq�}�;�<���B4����ذ
���1�[ۚ��'�e��V�����!6�E���H��e�\Å>���Mkqe�@���G����I56��,��%-b�gl� ?J�*jّ}��e�Y,����b#�0�t|d������豹�90ix�R�
��g�B�Y��*�4�&b<�ǗAĆ���0QՆ���qk��Ԇ���PY��v� �ޠIrG:�{s»�6��P�Fء$�!�*dJ�p�0y5p��l5mء�R��֝��"뮼�z����F�����l���LKmB����2�
LH�_�NN�,�V�6��dqk��|��E*0QL��\�B�q@���M�qN	��9��6�S���2�%B"�t�2��w��%�I�hS���B�XO�#㻐L2-NM)��Bf���J��J"S�G�I�\IjO%ю�+��bH�Ÿ�J���H��祻�>�U%f�i�7d�L��[�fZ��g0V~@��܏(��@wG�]���͠J����y@��o��eȓE���֍bB�����\F�
l<���Q�w8k�}����1�F��j����8C��K�2(v�� k�N��hZ2�K/;�dL:�� �3{��L�>��*�q���ܲ�2+����6L��&k�*d
L�pЬ+"����1��L0��㒺�Z�2�;�̓�{�)��h����J���(ŵ[0c'��0�|�j���F�6gc��Q��:a���\:�X"s&z�: �t��Z�{%��i~WZ�Ǡ=�љ
&2�c��ǥ�=�Y+�nս=���~H���݉(��� �q��N͙ܰ�\�1A'6��Q�0���4\47��z�eiX�-�4�IѴ���c}UFP`"BGC�B5��ɦ�tD�fOLw��\��֖��<6�̘�N�Ҹ&*^Ib{h�w��I�l���R�.Y,��%̆�LU���M{&368ט�sG\?�6^UC2��8��7������i�o�?_~�=ݧB3��Bk-�,õOd�d�&�W����2t�P,��vhN�q�Vp��SMlqÎ�����:�ph;D�d�)k�w��,�����f��� &���v������<cq;vn��CH�HX�TB�T�A&�h-��SXq����~}�]�L	Ѯ��&��vF�3YY�eƂ#��T�f)����6��L�3F�ֿ	�:�`l�Hβ���u�fk:a�7�1W#��t��m�EƎ��$���P�]���W��tf�Y]N�9:�o��U�;V� F	����N����CpC�_`�ы�2'_�:��a����D�R��n��W�8("�b7D���&���;�e�X�H�>�3W*�s��Le�@+A��j��X4��E���p&>Ǵ�V��HӬ��~�)��ʾ/�c5%$�C���[��G�N�����UY���P
L�)�M�E�SM^o�p$⠹����D������g�_��yI3=�V���w�{:���V�*���V�4I�9ޝ���tψ� �����#|7W    P7W�i�
G�n�q��q�r�
L��j<���:��B��t4��,��4����I)���a�2%F�I�
L̮�HQWu�{*Pey2�-oL浽��
s�y-0�D�(�p{����u����J�lcam�p�	�!Y\͟Z`�!&4/x�x=���J���������KCD��n�u�ऽHB+��ڛ�*T�=hg�T�z��K�{(����iwM`�^�m{�M�T&<:Zl���ؙ-L���=x�S��7l�?��E���� ����x�ƀ�&{�ff�L}:\�o3?�b�ʫ�=#�6y�Fh�۱��ʥn�:�\`�TTff��f�A�"�(v,G2w���"]�6+0q��L����]�:3���X]��*���vIlOiˎ�SK[f&���VFWt�v��a�����2|��`��.��&��rDX>Q��z*0�����3"_�B�n��}����&�X��j�ɺhf� ��oG��7�a���)�Pl��aa�F���H��g&(7M��ؼ.�OK{Iܰ��cxG�dd��F1��ʔ��3����b����k����P���D��U��+��ƣ(K���,.rj����M�0���*��F���c.�%� "���Yȸ�H�3n�����n�K����$�\1V����帹�,74h�b�,@I�>�U�L3鄑D�4��_2!�&��
ņ�	��TW(��U������Ĵݴo�*�Ձ�Y�6�e�4@"�Tx���Us�#������JdjN�7��=9�N͑٩�%)����}Î�$�)�fk�T�x�6���i�U@n� ���vb"�`���&�a�i��J� S��s�E�W�L��yB�D�^�6�JO�XO
���D�9��F1�4JF�Ȃ���h���=�Y��A)`P�9x]�]+���L�e�AD<��ت�����x���:t�SឮZ�LđoU���D4ɩ��Y��H�CJ����fj�Pl���Ϗ�/����
�o���1�v48���ȘL�UHg��ء���#j���֡S��)#�(<����x��2L~Y�Cl�HƆ�-��5�� �nW!c���˗��ޞ޿?�~���|2�(�q��LU����2l����D��~P,0D,o\k��䉛�b���#�������6�<�!����e53���gi�qy(�qC^���1����F*�qC^S! �䄶��ݦO�����[���#>A�/�M�!�tC
6(��Cc��ᅹ�O���G(�q�X�E��`�Y��=��ǖI&?6/��2����2\��έM�D�o��U����o�#��"��f%�_Z$`�2��r�(�X+6���-�Ӎɶa�&�^Ș0٢������#�-�[�0`��P��j�x��!�e0L;���X�0G!T��c�F��,d���6LYH�i�'��J�zp?7�q���U����Wt(v/��u�}^?ŗ�?z�U�.j��������U��Q�G���_L�x��{�#q+&%��������,(6\�c{�����	<;���������
L2�#���x�vh$RV�y)A�x�X$XE�1�ɦ�G�i��B��;�$�%�}(3vn��0$�ȋ������Ua��,�IVC_��#Zk��1C0U�36\ؕT��E�aU�P�>��&�h�=�3��v�e��LkQ�0M�%�h@	�& �n#���)!�L�-8&�6�v��=jA�z�t�繣�{&�(vrIR�g��BO��rt��rBĻa�
��]mv�D�bmv�2,D��Z�����jtUr�(1Pɕ$�w�ըbҊ�dA���� 4BU9��t�r����f����.��xqf�p閥⑔`uF����&�	�ߤ;�0����4���u|&�d�������$Y�����a8]���乪�,��}�rE�D��W�Q���AΌ��ر��Q��M�E��p�8��D�VѺɒo�hL�uTY%���2ֿ�.t?L��ĲmQ����3G�OȔ8����2��Y�$�e��R��B	����A�G&~wc���ft�n$	��|GV+���z��M������S_�÷���׏�=:6똲��Q���0LR�'л��H��1�� ��:PP`��&��+�4w�;?N@�����]�L��At�9�l<��P�6nz�te�؁�FGs�Il�n.��
��k�N�'-v>D:l*��!���_��/:�\Q�ߞ(�\xA�[�iw��_��o��8_�I�k�Y+�j�2 ����Q�w��fyKU/Q`��Rϴd����p�nzƆ�pΈ�/V`��2�����l��-�8��4�8�mo�n���J0�*�d���\%��P���k-�G�Ql<��i:����f�+0Q����t�3bMU'Z`�$cO{�F�8ѩ� �P�1g�D�`M�Xç��'�1)i�Z��3�m���.1p��ղ�*�)H\��lY�
������h�4����\'�Җ��VVl]jo�v;�L���}�8��ƅ�@��AO��j+��͘h�m��B�w-�h�?c�q�Y�YW��ktjmI���"�(�C�m`ʧ��{�,��.3��(��wh:4��b�<���P�Ĺ��΅NR��X���#-5��A�r�ʧ=j���-!X?!uM(�:����|:K��}����3=�z�C��b�M,��^	1e�:�&K��䰄P�b��'fخv�pB_�R7L�N0w��m��ճ;��p�y9{�HQW��
�+R�m	����2)��Pl��,���]�	S(v*wY���jO��;�4�@S2-��'����]`=K�x@3E$ӂ\F4��|�(�Wm'&�u����#�.(F�6�&|��s��9�b��A��[���O�Ź&�a���%+�������ѭS��>e��Ѵ7�P�(����ؙ#dl$j���֏�,U�N�qk��QҮI?�R%'�]d�Z��X��O������G��z,]r��&-�a2���H>]�Q3�j�`h�AT?ϧw�ƫdH�d�g2���1�(�h�&�#s���=�:̲a�Xƹr�݄��S��0Qj�3qG��n���ɞ��U�3&�������lㄒF2�D&�8��'�9��M�(]`=�T"6��p������i��u@�a��M̛���mP��6L�5�b�N ��݈�Bg��U��$���>䜮6��>;V��������T'�M�'��'�������ԄKoX�p�|����������4�R�5�s�I��b,�H�����Ω��ID�\�PL4�ϩ�ٰI���J�O5q�{6l�+b���K*��\o�f �v�~39��q�6l�G�7A�������D��
oj��v�ba�U5b��P�c:#��Թ�êB)/<I��>���2�P`'f�]��
���m�=y����g�/8E��y��,U�j�u��d"I���;z�L}���Kݜ��
>����nNj�d�w�83{������g4�O2�-�׷�U	��s������;4c�TL����]Ų�#��g������t]��v�\��3v��i���T�i�F1���07%Ԡة�f���x��`GO(v���1\�Њ�rǣ�xd�a)��|���L���9��<�>�߂m�;*ʘ�]/tq00i}�o!c|q0�I̩ J��D$�:B����{H"�"D�E�ș%�epe}{����f�HG�3t�:>u�[;��q�&�xLf�XS%r����YfLr���'�$�K�DLL�Z�����	+�/omzi	޿������1�8Cg
-);e?�WE:�:��b\;�R6�nh���i��m����\aü�.���Uh����s�n��F}*{��:�Ƴ���{`DN�u��ٕV	��<gF�cƔe"���H�vF��s44I�H�S�|#����bT|�������I�3���Fw��		�bHB�zd�ػ9�;{��    �0U5?�i�1��N>���İ7l<�o;S�;
I-����
������n�ӬAmRl�p���Gp}Mm���M>8)y����|b�3������XmPl�N4^D`��4��E7��1^h��i#i�� �b=e����y���Z޴�X��=�=O�M]-.��ɣ����9:Z^�8�4VՆu�zƔpԫI)�Pl�r�S��� �dta��[3"J�UoI�e+u��� �F��C�v(�(V_J�bT_��pf���Ljw�(��a�e;��7*� p?��ӂb�����H�3X�Ӓ������2�X��W��5p�֢��J�D���	���@'P�R�������G��'PF�G�����bwi�|ء�.���C��=�$��C$�����c��C�˩�����?'{��;D�� 6�H	r��&�M
8����t�c����$��PY_v�+��պ��ę�[�c�3�VsUy[`��'�"���s�i�PP��
YPL�I<~ə�l��޿�Fĺ�h���LU��ˤM�:�$�mb�
�{@��$�7P��o�$Y�\U�ر,�i5D��S`�o<�/4�K�	����X �-|we������UPz�<?���Ұ*�bX����]��D�����[`���4��+ǥ�$�b㙨�ҬO}��I��v���+���X
zN:�6!��Z�o;T5�g�-��xp�2v(\��{J���.�tT/��9U���B�	B(��ԅ�H@�~��z$ӌ�͑�=2;��Le�]�n-�&����:�|���咻���k�K���I4>�L��O���E�JĸXU[`�ɽH)�^	;՗����媩�6\�;3�䊊�\{cg���<.s7�P�j��ϑsL��J�Z7��&�����MR�E�,Zv��>*�oN�*�mN0���9�|�3&#� �!)��p�F;Y���R¨���j=���w��\���x$�H��LTа�m�v3^fr?�����ҟ�َ�
jn7������(��S5��9D3�� �*Q���9䖦�����>z�Pס�FzH)w �t]e�D}��oر��B�S@C�'�ʠXW�im.��sN�S�ͅ���֦Olt�,#K_�`�aA/�#����'�Ax�Gu���h"r�
s<�n���1z8�>ಆ���d�Ӯ���ck�6L?�T�iD
�J��P�`kdFl�6q^f��Z$-�2�80�B��Q�H��Ot"4�B�i\�6ޓ�t�419N51=�b^���0��DƤ�
|?�a������\A����b��;�C��w
�6������@�%J�er����DՇ3���H&i�S�v���O�n�n7^�97���$�]�#o��E����x� ��Ҡ�R�ܩu�
��$�[� w,�I�~b^��D�"L�Nl��L{�^1�3�s�(v���+&8�zQ�oB/6<�Kp��P�h��+�A�q.�b���(��a�d�E��`�KB{�����v���WL��z�|ҵ�0c��yR��<�
ko���i�{�6<��X���6LTt��Mr�H���΄[�4��S�zT`RBNϐā4z��z#�If�ⳣ	��c����ќL�xL��PLf󪥯eG�(^3�8�f�2*���F�� 0(vF��'��@���.�2�yj�-��z�'JX�K�����+d*;��fJ�*�HM)�cʩm%v$��u/�U�-��Kl�?��ܥ]�(l��UE�X��$��7`{4�뫚��������aqQ���.1n��h�i^�|U=�%&.�5ӊ������v�3֓�%Me�4|a�~u��ퟱCE��!5�-իH_��%6n**f(S�TS�aY����d�(��H�_/v��ȵ*�ҍV���B��,ǲ.�+��d~�!�u���Iw�3�(�iϠ؁�!��"΍�G��!��n�=�PC�Z�Z1!�A�b��I�Zٻ@�Ivf٪7��^GޮT�8Jll�^��SEp�>L�ά"��	'��3��C��5������&tz{��1o���Ƙ�v]ҌG�b�Ơ�����D�YZ��9]�*c.�{Jll�b���f�l�73Bmo�a� �2�Pb��KP����܌b�v%���|�四bÆ�O}"$�᭗'i��}ذ�s�xz��O+�v�f;F��m���,�Y�G�ƭjK�������p��D妞`�k�/�8;s���L�U{=夠R(&3�-~M�N��y��Ľ���LΖء���S����]�1����S�Ǣ�,l���`E���,�*1Y��1ӷ�&L4]uh�8��s��S�}`Y4P��͸+����DrԼ�7l�Yf��q��tjKp�ƍ���|�������t7�������Z�p�����e}�����\�P
��J�b�l��,��[LAL�6��h���	�DB�O�.D�J�˩�kjk���UW�ظ5{%p��H�� ��貐���Q�o|��đ|G&�E�tv�*�!A5�)����J1S2�,cbVZ�����5���e�'0��	�_N�Ը~D�_Tb2k��j\�$BU�hJL���L��B���,0l���c�Ym�A��ˁS��@��Y��\�׶{*�M�(v���l�~���̈́b��f�h�r���o���丑�S��ر��߆z	$Gvt@ß���!�W!�zLa����"�tAɮt�l����N��Dn*�'��?C^&]�ė���dS�H�HqO�
�(�
ńb�+(�B����,H����C/M�URR�b"�I�ظrID��Q�P[���2#V��f�����#ӈ�H��b���>0|b���Ex2v����gZ,i�YP�P�����041�[Z(�l�-�r�F�j$�,�L�4 ���n�8�Fԁ����'��;��� -�W��0#�"F��,�.I/�Y�fT{Uݰᆱ@e�d���:�'��jp����s(6jcx�f`�����)�Zp<k����]��t��>��;	*KqS��߰C����9M)�Q�4�wDw��}�<Kϑ��v�`ZPLn�I�p��&�a���δ�	��%���~�a]d�܃>����L�bg�733��l���<�	�d�*6}�L�o�Šd*�����f��`���~��~�#�&�6S�8�P�����}K9W:��+�y�j��cg��d�%�(vj'^ˁW,� �T�Ɣ�x�L��8s��_�� f�����%�Q����O�2q@Uܰc�3U�5��H��FO� S_�֭���F1:�Ƅ/��}ݮ�ņ'%�ā�f�E
�1�+-�o"�D�XX��%l�M�sÆ=���l�ڛ�
�`1�Dc���X]i,8	[��<ą���^�7��[_Ȫ)����`�a�eסf�0-�h���	���t�*���N����<�U*�qV�a��O�tT�x�E*���O�4��r�q@�C�����3޼h���T�'F���0uw'A:���%6�	����fD����)�={z��
j��v26^շ,��	�Ԉ`��p6Qq��0G��p�/ʀ�+a���01�Q`G��ņgJ'�[\��H��2t�x�b��24&�$��L�H.�O/�o�nSQ@���J1U�K�B��o.�&���i�Pn,~6(&�RLb���U^��"��$��hf!s��oظ�8�XpF&���-0QmcK�B�R��d,� ����sab�W���"&�����*6�>��P%@� ���c�S�����2Lt| ����ZP��'��Q�b��a~�$��P�"y?�T_����h
 h��4PУ��S���L`�����PLT���Dxw��Dxq�OS���1ǃ�<27lw*�zpԴH�`5��W憉:�؞��c%�A7�L��7��u�΢�(�"3}:;�I�N��U���黦��|��1}7��T��#��3��ґ��c$Fte�0���Sڒ�-���֛v�ݰq_Rw7�\4�*�`� o  ���Dm�ì�p6�4��K[��:���3����4�fF���Y5L�A��S�Ec�n���8��MZJh@1ʤ�$w�d9�J	��^7�`�P�3���U�D9s�n�h�b��;�öJ3s���0�%��ޒ��|nx����.ڑ;X]��ĸq�S� �<c�7��M��������a!/\�[���b�-����٩s�U���<
��<ܠ��[m�.
�M�xÆ9��j��(�5ɶ;��VK�h�x��*,M�pò����Ϸ��J�IDgcJ�T�6�M�˯Rɢ�h�BҠcB�]�C��	��:t�pr�$ժ�����ץlE�G�A)}0s����C�+7���?��׿��� V         �  x�řMs�F��ү����oJ�����G;��%�d�������X�+{I�l��6�A%�Ͼ ^�W��/�-���x���?� �V ���>��|X�y��\l.����W�K���m'a������u�Y�خ�S�������r��^^�~������ꭡc�1��5%��8��g,��p��G��o��%��F-m�� �����a�lZER����i��1`�����:�q]�dI��3��t��_��]� ���р=��N��J�'�㇛���ZE�|TD��,b֑��jI1[X��*, ��VTY�}�^��G��ow�C�1��\"�ū��ΐ�q�L��;���L�Jn[��YŎР��X@����A�@�BRn2�G���M�k�T�9��ܲ}����:�� '?�8���z���Ɛ���-��{䑣�8r���.w;��(���!k�H���HZ�+�g[4	SM�^�г�144ɹ���s����m�`�B�&	
�Z#P�Inqф����	��JZ.���jr�W��]V������1�76%NI8��ֹ��G�/
����P�M=�8�����#��pu�o��H�F�*`6PA\"͸�(S���2d�P$M#qRդ�����'AzGL��u�0.�� ?�W�"��ur��A�>mou�~AqFn�0W�f���vH��)D>e�r]���UH	i�HNN8Y7$V9�S���7O�|bڒ�r+<����cb]���$��R����J���'���\�8�|VD��`k?ٖz�=�1�dN?��cx�8�[B�'��B�^*]mYP�,YtK��	��Wrs8�5�%�n>l[�o�[���!��!�S<�S</}3�I�[�b
Iyw�a��ke��:7����.̮���U����+k1t����Eqv&����e�>��E}��|���<�A�H�
y�e�ڡ�v��9��V�C�fS|	s����U�>�M�>Z��:la=l����󇆵ˑzE���(� ��ƥ^I����K��2���Q��%./4y��j�c]��E�鱕d����d��G�O���z������XD��AO�"$�dx�� ����6�sU�-����:5��d�Q�G��V�ˤ��>������$,n_�aE�3�sA�pyx�����I�йd�l%���̒�2���YB�����>( �1bm��3@NJ_����.��&AY�M`�L^[����s$N���Z�\~���K���4�IT٧�%��� �#zHҶ��ca�c�xF��ӣm��<�¼o���J�7����X�6�_��]X�]>�M��H��cn=�!����8�K���� 5�
��r8�H��̕�}��V	��>6V,����e_=���~��z�[+�|Pj��Kb]�[F"$.��"��ٗ�߉��}$�K��_���!��[�� �R�HS��|b�{��hn#�b�D����l���?QP��      �      x��}ے���3�+�Z�#���J�I֥U��a��CώfVfZiM����n����B�V�f�<��C����p?Pvyw���w���ӓ6����~�����r�}�\4���_�����?���������U��u����`�S�]��/�|�`�j~7[h��s�������������?������?�?��/��C��i] o�h��D�"r�1��V�o�Ws���?��r��yl�[���h	p�������o���ogZ>���f�p��B[���Џ�ob�\f˖�cIx�g�*�o讯��,X�d.�{�=}����_���f�pq5[\���Y���Q n2���O����x=�;c���<u��w��]7�x�������{��ﲢr�k��A�.�=�F}X�J�������'���U�z�U�j__%Zf�A��։!���Ͷ������b�\����\����� :�+b��k@�X���Z��\�]׍���.��Ͽ9�]ڥ��R�N�
5�X;:Ê�|0�쪹.���I �!`� �we�5l���~��[v����}�oaZH�Q��Ĳ���I��N�y�ܷ�����M+Ul���r��|ջǿ���˟���?祅��a��_���,�Y�b����x�K�w3�O�_��x]A3WX�(_���N�]��꧋d�\}��H�<L�KӼ&�m�Uw���l���Nl��N�s��K��~����w6s%���s��0�1,������8�F`���&su����3�2?%����rM��p5�_ϟ۰�a
aX
���숄:�����֫���B����c|�;ݬ����?��׿�gqe�B�B���p���f�2	����A]y*]���;tr%���p�ajaYj��s���i�t�x���U=ޭ��/�Z߆tb����B�$���ʌm3�w�==�����<���z�P��1���ٴ����'�-��hv���|����M���Sl�ŃG��?�E	3���)mS�c������i��4H�4����������n��T�?q���Dw������������"��(���{fG [�{������A�wD;��A�c2R������������`��)����R
]᥇y��7�'� �
�|�>�zbL�ƶ��]e�]e��znYvj�wO��Z�\��1�a��;�kDU�FBW;3ߝ^H��e�9|�B�osf��i {;�Eط��b )+Fʶs���È�����fus�E���4Qk�z]�� ��3�- ��!9��"9��6mi������2�v'K>�eE
��^��������O��`e`@�X@�����O�w_�$b�A��7m�m�$��G�߭� �y��!w����}6|��u��N�f�5s�q��ֺ�\����ӻ�W�K)db�A3��/�C�)H+��Kl��|��t��ˮ�C3/�5��ǳ�-0m׶hW4�Dj+
|l������v9m0�0'�{N��]6VW2H��߆=G7,'p6ʟ�a+����?��Q��^�R��~�b�(��YҊ&6�>��Ԧ��i�b�[fzeK�ϓ�����V�������n�S-5,��2.^D ��V�:�<�Bps�\`
a��+lUYM�����_������_����E��o"ք%�l��2��(�����Q��K���Ak*^��0�G���y1��l�[�u+��2Iy$Uh�����֔AAk���}���p=�Bz#�߾���Qvc\�R0�P���F냛�|p��t�9�����B&a>�y��|b��}�Ž��y쩈�����KO0���?f
�f6���t�y�C�w��ᄱ�{�����ٛq&/�87��qz������ӥv��r�����~f0�@^�����?ש�Z��\��/�>��ax����s���,P�h���p>[�5�=���マ��!L��a�u>ƋR��yJf$�l�x��}z�d����5%��B� �:���t�)��;�գ��
f�AS����2��6MUh&"%�l�3��sY`D�t.\�g�^كkF���%�d.�8}�9�j�
�Z`��t�Z� f���}����\���\`���[�s7d8�.�[�ټ��O��2���nY���&˜�Ep��#|�I�^����B.)����-n�d]��ÎO��~9�����y|�m7$���o�B����ؐ
	D��<����i��s��_`췌t,V�%?5���۪yw��S{�
2�̘oY�����Wla% 9��J�}[M�2�̘OM���WC�\����f��B��_��!��������xm�h���S��媹�9�G{�!QϚ�\�H4��>����M]?����ʲ�%�iH|��;�0��K3�lQ�P�ԃ+�R�|�E�!�͎#���3!n���QΗ('��6hKj6�ҕ�����ɕ5d������'�K9�}al7��y˕�	z�g�<w2�>��\y�$/�O�O�x�"]>_η���x/��D�/�6ܑ�RY�����9��N�B1�����RM���W���^CUEh&������(�!�&|]��#�I�;H5=��I;#\�� O�M䬌�C>J)�<,��+{���
�U�_�ƻ�������w�j8-��f+����؜�9�Į.q��e+e8���_�ta�����!��4)���sp`F)�񎇍��lI�N�M�-lH����r� ]�ov}�� .�D:�O��n��>�<��u�����E�7�*��^�`<� �ɼ1���N�(8���7ו�'|F���B�`6o�"g�l8���,�_�-u>0_��`������5��E��Bs��G�p-�KE�M���/�ᬇҜ�`VG��q�oE�l����6.i8;���Gz�坺ysF6���f�[���tC#]@��T�&��Dz�p5���ݮ��Js��#sv�;L��38��\}b�,CԜ W��mn�ؖ��(!ZR/�p�y#�+�>͹O�4���U�K�M�u.���9�Ņܧ9��N���z@H���_���d��N�� {h�s�{�z����N{ݯ�-��J	tNŃtT�zT�#J/�J���;C6��b�&L_Т�᭧E#A'k��ڢ� C1S����R���Th��u�&D:0���-ް��q�b.qP�O�lh@�5�t[���ئ�N#������/����pz�y��r�?�k^hX�Bw����e�4
X�F���aw�2;ĆA;Ւ�v���籸I�V�>��G����a,�k�69�Dd'���W׮W�69֏�ط��kRDRcY��]y�����Rh������������j�jJ�w7�;��;m�ts���Ě��ļ���'>�@�u�S���)d3S��ƴ�D02��I��N�pQ�V�E7��l�\W�m�װ�Q��.rmi{}y�xC<)���ta�2�OӰ333�hɌ�k�|�����VZ:{yP�2�3;Q���s��dإ��)��i�RAku�|�P6��E�����2���{�,��Fm�4YR)��g�fV3�ux������_1A�.N�	�N̫�兔f�[�>L(�T$0P�-a���p��ws��Lf	��q���	�Q���N��*��7�m&��ִ�%�����r�'Ȏ\�D�炙��<�N�o��O�xD�)�i�{"��aR#s�q,~�R��:>�9�t�����8C.&��	oG�S��_���<�^�.�9��fV����]����IC|B;V�a����Mcsru�j
X]���<�5.��6B�Wt�g`k����7��ڭK /�-��W�u�G���G�ё� �gW �gwu_�3��wH9?g��͖�/�X�lފID��|�,�k���<XU�x�R^n��{��g
�9�6���/�|���}��X=���� -�9\�x}�vo;��� 
��_�9U�ޙT�փ���.0;    ���y΢�r2&��_@4����兾�]V���x���ENhaU����@��^n[���y(�c��������.����uT��K��W)�+��b׹��CY^I���kr��Y���]b�؛߾Ċ,�L|*������X/0p<0W5�P�EK ��I�Sl<�寤���j0��<�4W�{1�� �E���<����v8*R�O=�ِ]�� ��M����������u���&a[޹��������X��'z!���.q��;�8�4�X��`��1E���0m�)���T��AQ}d����κ6:-�XHٳ�o_Nqc�|��|�{B$������ahO!�'��|D�w,����é4��E���穜=��{�p�\�Uw�h�~y�opÔ��.�`���"2Й=�[�];)]�)O��n�_��{��?�������I`N����v���O�{"9�kFl*:�6 �R��V�����_�5���93�D��� �A���� 0wS�I��9�!��_�ў���
�p�j�_�o������_���0L�O�܄K�0���MAb,��C�0��T�'=M�C���J�%�e��K$���kj7��S�������������<G��sʎ����z5�������6b��#��#
4��e��r��6���=�v���W��˟���|B��҉�Ä�	�5O���ڋJw�>�ih.<��IL
8����[Bl��z3��4��� ����9��2̐J��[�<�ک�J 0ܒ&X�N��I���QSE�6W��+�+R�Gg+U�4Ͽ+�!�M�6i�C�#Czi��0dͮ��1%M=�cJ6�>�,��+TdF/!k�d��-C�fۃ 1�w�a�2�o��K�r����YpO��[	Ύ��yr�v\s�V���U�"mJ��\�Ƨ�͹=��25�����{C��3�����Q��)��3�0,�<,G��a������&�w�nZ�ޞZ�0$�<$�t�|پ�C��"��۱u��_��QS�a��y����b܍q���6,�[�v>�h�ߢ��H_��^����4�$�z2��t�q��։�|�Zx}��xueȃsB�4�ۂ��z��c�-DxYx�9&�u55YV6��Y�޻4����H���C���
f��
��^�!�ד�9� &1<��j�a�DN"�Guj:�H_�L����(���Mm#א���Q���~t��L���#"H2�Ld��?���i�'(p�����r����1v�"�Jԏb��@Mc�p�����q�-��Ď(Z<���x!�,�G�U�W��i;QsVM�k�ԁ7�T�Vg���SCP�<J�1��|��S��}��9�+��<�#	�V�0�O,�V�?��1Xh2�=��>n�W��Y��X���lw���Q7�G5��_q��h�>�r	���-"=q"��}%�Z�G5�m���� �l����Om����鉇�5�_��l�P8���ͻXjpWs�}~�i|�I�'�g�a��9���1�򋄍r<=59ޘ~Oƛ��N8d�u �ajSI�"n�2;=��n�z��.��&�����T�Ef=��<[|4�\��g��eTg����e{���k�H����7!��)Ō���;Spw�<�n�#7���t��"z��H�g��ɱ
�v497Ti�[��&�AgTћ�FY�NzqD���)Y�|�~�^aO�3*�ē�\�V�þ���-N&�v ��cl�`� �ip�#�q����ᵬ7c3�]
��Ϲ\K����M�� ����\_���/�$�P�����!TћG�L�~p��oCB �����F�0���!z�(�G���o�D�e���������Ɖar��o�#�o���.��� �N��`@��8��z̛��7��F�\���\�ŉ�A�
�yL^F��>���E�i�f����5P�Bk�ce Չ�#�k1$ऻ��j�ՖV��@�
�y��:&�ɼtq��N:�[����ZR�xa�<
/�Q��K�H��������$eQ�a��fAM�CnLy��MK7�~�w|4B��x�)|�D��czN���~���ϊ���-4��:��ќjZ�7�3����*N�/�'Å�3�;����>�D�a�ۙX��[)���]{� 5����k\Q6�����ncl0b���ͣ?��|��Z!Z/|�G�_*��
��G򱏯�\��K+�n�l�6�9�4�#+a��g�|��|Eڈ��d�"��g���|�;��5����	�q6Wȏ/q"�_�@Y!��<R���e��yz�T�M�,/���h&x��r����
�6��N&Og�}�7��kEt�������>QN��H(!��ƟO���H���6�������z����pn�z�S��(�#��[����qa�|s�@��~�%��)`<6<G���-g�\�Bgg�]�p�,�	�2=��|�6=��y�k��.֒I�(]E5J���hc9�+d�9r9|�!_ғ(y �p�fv�gvj���a�L���i�87�S����-e@Amy��uԋ��dۋ��;t��+6����e����M��P��1���xC*�^��:nX�l��{�ʡh˓�!�Ŋ����G�\sЗ���}B�@�m������ub Ў��psq�o��Q���Z�\���WНk����&�8�ͼ�ӫ>T��@�my��[�zJ��ݩ���`�Ş� �YD(��-r������G�^9�W�/Lo+m�SUݕ���婝>�;`�M�RI����Wu��/ŷQ�o�)��)���%�"��?D��%��iX�;=>��>�юKzy����F?�L��kQ�E$LP�F[~��#M����Ű�}��ǋl8v��א'�T�);��7@�������c�C�4��k�t�jP�E;΋���w"�����z6�@�qۑ�c��؅�~�4պ��kő_s=��۬J�hg9�N>���D�Ke��^#�Zo�xa�v���c7� !_�E̬I��yK��}<����s�� ��I5y$�K�����U�V��j�h8�NE��a�K����sY���`�JRh?q�_g�¬�w9>Wv]6�E������+��%���(^t���l[5'����`L���,��zz��C(h�Q��*�̓w�#hσEO���z������yy���¸9݉�J�	���Wُ7��=�:��s���U`.����η͍��s�:��~�lT��mZ
]��c+F���㏗��±w8;ۑ)���T��kl�NlS3�v�.�tY!yNN���)^���}��Ҿ.��=���Ԗ�-T�О��g;S+]�M��8Z�9�]n���z?s��dg�#�aS�^O��n_��^�1��bḤ�ݪ~�\IB�[�rÊ�����ޒ:1d��3���#Q�/LTl֩f�&���ֽ�����qn|�5�'b��u)�i��I�r����Е�yJߓn;`j_��{%�ӳU-�X�ݯ׾�o�7�aX�yX� ߾�L�I���������%�x��.1L�f�͏�o.7��`�zIኌ=�M�x4�A_ܗ�u��я�|F���i�|HǦ��Ax��ɽ,�e�&��@dc^D�n�Mj ��}��� t�T��mإ1n/�����g��8a;3<�'��r���;�EL��do緣�ݥ=0A�v���|=)�J��G'��;��B��y.����C���|��t}���yڴ�s�-2k����v��`�y��-P;Iu-B�I!o�_���*c號���ɴ���|� A[G�i�x�h<:r������s9ΕC|�Չ�Nz�n�b�����]>�Vjt`	h���*��:�߉w!B���~���С������p񡧔'�L�C�YO�K�֠���7����lz��,�J1��m+n���DP�D�ܹ{25oY�N�0=���WTs=��%����>��otZÐaTO6�ˣKXh�x�m��8p'v'	��g�I�������pw�}t��{��\7    T䶳��y����_E㻅b5z��mo�Ət�ə���%�	�kab.��K����'�Q��Z�����ب�#7����!T$�'�0~X]�K�Y]�i&�z���m�!腇��w���|���m+E�~����p6���P'C/܅|��-x�@A�0Un>�~f�g�!������W�+4;�%�l�1�r��(�`&~�Z�Dy�ſlw� cΝ[Z��I	x��L�l_$b�㛉�����z�}zo��t�gP�)��pǧV��¹|3�CT�<d��RC�~���7��
�P�H/܅{�l��Ms�̦]$�����±�hK�|h�6(���=I�������:f�/��{s��+���#�^���z'�3ˀ��E"m<�paζ�-�A]	W��� ��N]������xᡢV�������؛�/� 7�j��Ծ;���B�xCږ8]���|�����->�|$fn��25,R̦�#IO�iu�1Y��WADEi�Ľz�I�zg��6{�̷��rM3�\sH�%�f��r�u<7��.�@D���ZEf�An�M߂��^r�5*�ӫ /J4w1c")f�נ��<Ggs��� ʹ*�����S�I��~�+	&I��x�|��BUCU]"`� V��y�!r#h�%����H��\�b��BYCe]"n�E>sjl0��F_S� �e�[�01�z.�����7����[]�r�?7/Z(�b��K��џy^��g`K�&x��M F�gC�c�m�%����_(�򛎢�F�t<�Ǚ���adSGm��H>H��_G�+u�~����n��D^�P�Ԏ�X�9b4�K'b�L�L$o;�9ޓ	ȖL��}�ܕ��#F�X�t��>pW]# ����\ ��4���Dq��J�~SV.p `�����.��8o&Ì�j�%̀��P��p
cw�8����bFs�^:C���r��]�I����k�'���'pCA�9�,a�m�m!�Cr&����1�2l���(Ic4c��:�}����A�cAP"�I�����W�p�i��b5���e�>�4�PfsJ3O"@@�������ԠE3��n����f�,���<�iv!�#k`Ю��a�؆�Q�-c�x�-F�z�$�à��3w5�VQ����͵��\Ou�_N�-b�M�#�<}�����ͷ-,�\r����a6,
+5؍��Y;ʻO�o�~�e��ɏQ|��P�ނӑk�':Y�ې*����6τ��0ڈ-d#z9/v��9��7b�\�Fv�A=c,_��J�!�w�����kdF������9
��PG�כw�x�)[b�Ļ��
�R���`�y�~4ӢӔ��4���v�A�cG�y��7�e�۰NtӪ��(+r����N>�l�P�13pvt����#og�C���6���j��păZ`1�֭��ټU�d�"��H����>���M��
l=H���,.������E�`�� �]��s����&*�b��3ߜ�k�nV��򴱙�_�	Q�������CB��أ6��+J� �����eu��Bj��YN�	QĨm�"nfW�9T���/
�(ly��T����3T�v2 ;�Ȁ���C?�y,~ �R��|^u���;4�Sw���\��N�����噽���@�;�NHNC��Į֯n.�V�B�p���u�$��o"�J}�>�Y��P�8V)��Y#�!�<�����s���3�MT�0�G<=xSJÙ�����3�b�-c,�;{��k]�	��7lV�D>g�J�+g�����#�c��1&���?cK�Vt�奭@��x��Sz:�ú�^�Z�bS�Y�+��~c�P"���=�7 �����y\����\�%�"'��6Եz2�C�|��%Ɯ��8��L����w����[b�^i�Ӷ-�w�
!�Y�+@�CEN"ޘU.qM�	$0��H$k[��l�x����d� Q��y� � ۾[�2��gs]b������o�kY x�:Kn�L$N��_Z�0�R�u/���0�k��Lr�u��zP���2�03�j2��$���Àlm�<P��B��I8�*&/b2.*��:[�%�l�po.w����@Ě!��J�M�Q��M*C��Ӳq��"�"퐊x��#���͑�W6'�)�w&O���߷�!���ވxp؍"��$������~��A��9��b����%���56�Q����/���y�s��Ie.��sFR&$ 's�Z0Đ�<g=3��ٶ�"�S2$�$�Z��pg&�/4_�q���+�,.�<6 ��Id�NO2^@�����=CZ���7��4u;�I���V,�A)�y�a:�^˂ݟ���!6M��sS���b�/��_ۣ���&p�6��o6ο���e^MתZsY�8@��N�Z����tZ�z��1N-"����$�rvB����	�����4!�D@"N�]#AE̵�x{i�B����`ў�ŉEfR���kH���48M��x�j����s7Xs{�@�5Lܮ�[�k:(�fgi�yZ� �-G�M�LX٪�ފ4�p%�L�m;do��I*tzٰ��s�	t��P�0Õ�B�?v�y�"�w�h�B��4l�g�xu�b��hO[�����9�"S����e;���%���h����1W�xxlUzT!33�QY!KF�:��:$�·��ǳ�����{/E�h��R�APs)+�� ���d�������� ǹ�FC�KY�j�҉�n�ǖ3�^��zi� �Q�ȋ����ě����[��}l0C�c?�]�¹��ב~=�"ctG.$?]D@��B��E�׽$��z��+��Wdcv��C�R��{3�<�ͮ��OJ"��<~�>���<�u��n��Ѵ]�ļ��D����7���D�~�~Ͻ"4�V�Ek�H�ޗ�(�AYCeM"�늳)�Ԉ\�1 w ��O��6߀�&�ʛD��M&����
���7h�n�!'.�GE���무O�f�b������������@U �pZu��i/�$���V��K����'���x�V<�b�)'`6kQ�x��E���,�!W7'E����^s�Wd�&~WM�5}���2��Ά��?2��ȋ�7^R�t���!ꋏ1�hC\8�
�9��]�)b[o{�#�-ḿ��jE�����5���K��# ����]����Y8����Դ}�;�4!d޹�$�������A=$�p��gV
���.i8^(�^~a�^|��!�Jv�J���HC,��\/���b2�	�vv�l��>0�Y�����%�̵h�4�:(�d���Sɨ�<$B�Om4������6�;;�c`O;���;���C�%&؈���I/�đ&@�y��^) &`NTh�y�����J�؉�^��ti����C̶!�z��*#ڳ��0�A����N���ʛ�^4\n[��b2vb��K�yc�y�~"q��'b�N���ཤ�fw�nuC+�O�eu\�yv�/PS$����	����.��b"1o�BܰC��8�'�����ܺW�t�+���5�S>J�X�90��t)�}z��MT�2"dT3�x�x�T�U�à��.^%�d�y�܋�-k�T�ſ�wC��߻�
����Sb.+�D��z-���"���z�����������$��Erb.�}{~h�C�bq�;9R�=�^N���om���krti�%P��R���x��s�%�p�j��   U����>i�����������ӗg�͐��O�|]sNB����ҪssهgQ&�j>���Ĩ����}����Ɓ�ψ����=�!R��΃}f�\��r�9Q ��O2|~x�8^H}T{(�uc��~��rro6W�w'!4�����C>�+:.%|��l�\�yˌ���
�X͹odk�/q�XlΪ�\�~<����� �ԧ-G<Gu���)������n�!b.��G�)ef���L�E�_c�rsA|�Zk C�Ӝ���j�p�=c���*1�M9(8c5����|     ���[�MI�����S�g�欷\*t����@K̵ C�Ӝ�TG��U=Q�@�_��ni����������'��Z������5 �J-�:énIM���_4)P��BN)�_�=<s͎O/m[�Fs܃U{��PI9#3�`81o����S;��:�5���V�O���hu�������|�%�ı�3�2�d拴��Q�O�l�O 	��\ko��be!��tK���w%B�z}��,��fs���X���8�4<w]���dX��eU#ܚ��ݳP��v�fg�����]��c������!ۙ��>�@� �ùÌ̵���\#[+��0�5ǫ���lnn��yK'~i�B���k�Y��G!n���	qi�Z�̭��-����� ��gG~�;vy��d��B��5ȡD���#wc�9�N��24غ�����0�����-�=k8Z_}.!ö9���W�:m�Ϳ<�Vs-̖���B�����%����[/Nz�\��g��x�S��t۾�e�^|�"��>V8��
y�9��|��1]u��w�7��D6�%��!�YN|j��*?<<e�b���� �HAT����U�Po'K5���3ЫT��� s�2�]���;G����G5���8%��Z����_�(h�D�x6WY��<"�r��3b���>>��sr7�և���D�Q͕�/O"��JJ�*)�w�z
6 f&��!���4����b��ϲJ)Y*�wt�{�	�AcC��Zqb��O�/w-bH�T}&"�c�Paf	��m�/1���r{�o�5�����3r�2��������=��fH�T�&bTJM�ڊ2��}>���2?_�/ͅT��T�&�Q%�a|K�\���y�"�TH5hV�:�z���{��]����&�'�"�������4�j�D�jL�<���dd>Ub`�Wb `H}Tz&�-��t��-�1W�?\�0���Tz&"�D�	�N��'�8�˶���h�<]�����N����$c����\ {x��5�!�y�y��/K�dz��_��>��|1׃`yg�>��������@�w�rP�ܓ�(�r��=g�+ի��Pj��mL�'|��^ޗ#���<�S�@�w�%��'�/�q�4"uk	�sB\7�5y?A��I��j�81W䏗_��E���93�	���>A¤��G���i ��b��
�Xϩ1
Z]���7��l&����!7΍�Ec�5�@F�Q�?�q���sE|YsR>�ڋ�����+ghbL��7�?4=h������t�E�i�������ʧ�`4�y�zb��C�85��^Fo�6�*g=N�͇ �Us�n�3<�{��������>ʄ,��D�������)�P��΄+�Za4m���Rcا�{��0m�\��r
����/�B]�kMaw"���$Z$yռ�bn�<��!�N�;�|�;��$u&Y�\���V��C8��i�:%�#���>�= ā�ܞ>�0�/p��iD��p7̹�l�K�C�9��ΓQ�7��J=5�񵁶���7��oNZP	�Μ �V�o���5B���F5�]�
�ؙ���%�{'�[�d���z�:l�7<���3�A;���@���ȓVT����vP�ΜG���7ۣ���o�d��������*�ؙa��B����X���6x���x�!E̻s߀�8sF�R��¹u1��k��7b�a����AH�3�Þ��+�;5v�<3�&�z�_8�!Μ�46�E�vR�ؐoZ�b.p�ԉ�B0v�T���ŋ�5~G���S ��N���j�*�"�����S����j"���s�/��Gy�h�!������"���/v����TM��k +ߖ�b]��o�y��,���������o����F��i��6`h�����r�u=~�g�(u%��[D��w��\���p�s׽�^vH -�~�n��|]�~�
���i�J���w:��P���Ib.���E�͐��|�ZQ	q��}�K�}��������i�P�.��z:Q��r�b�БNQ�5�{��6�9o�U�S�o'"���b.��"�s缞"P�6�R8����d�j.���|���(�M����(+�I�RK�r5��� ��8�������36�L�%8���]������.���<qE��r�4���gsu`���8���YŰ�d���Pڦ�H�y;05������s��$�[Ȼ�aM&��&�y��^Dtn�Dov���B�̖t�o�fs%eY��Z/n����8O��ta-�k��K��P��M��z��Q%���~�F����9���s+/�̋�2/�x�3�s�l8�:��͒ok��\<���I�.�6���Q�h���*lB�*R�Cn��.�`ip&�uG='gsE\߳"������.���/1J���,?�8��nC�!�Q]�؏�L��p���V����߈��<�uqT�%"W >h����?�s���)��]t���;e��X<��}6b.����uHvT�%¾���r	�Q�@�\W���G�]�t�:t��(H�sՂ�lh�^^�BmG�]V�� GϤ���sрV3��N>`䡬�S���α�����\E�A����.?^�π�9��)�ܰ�,�
F=�h�C�!jN�=��b�^�E��MC���=�NU^��T8�S���,���F6ĥ��T�9��)����.�@���-M�y���4gĹs���S���x�>�����ka�k���Ӝ�몜	���2<�>�H�u������/NsR���?�;�/(��ܧj��Vs%�Sn�b��P��i΋�!��z��ɯ}��Cy�C��E���~+�U�����ܓ��^s��)5gʅ���956�9a��ssy�Q�%��=�>�D��8ù�'ԫ,ί<j��E6;3��DT�B�3�%{rA����I:i�Oc��V��I�k,$�@�gW��c�������F�%�\W��i8g.���9=�J��]"v�G��O�fp�C�g8[.�����{&��+c��\!c�*�8Ùr鴱����v;)�O�����k%����ܥ@�g8S.��uܽ�*u�j@��\�<i8O.�b�t�������^b�� �A�g��J���_��S�i����F��A�tUd�ao�L�Z�\��Гys�\�j�C�������!w��;s��4'��E"�LiG��^ �U�~��\�y��Ws����?z($�戯{.���!*� �T���r���z(*���-���^r��Ǖ!��Вg��%�������#��H\{�M	�Y@�Z�{&xӪ�y(3����]_�vp�7M��J��݀P��������r�"�li=G�m�_��S�n%:��D��^%(5�lਯ�l/�+��5Z��\v�D��2��7c�~&#�/��ٶ�<$��d�?��|�w����;6(ͯH�����yb���/w��AJ�8�I1^�!�'��0�^���Yl�iL!��N�Ѡ��s��`'���0�\{|�_Ts]��y�PO�9N�ʌ	�P�?�->�u���i�q��x#��	���hԕ2��\��S�n衖�s��;Zr_�o�#�5�S o2��B�s��TG
.���9��v]��`#wI�[�CTR���s����� wR��L�NsM� `Hv��]T�i���gfzܜ�iՈ���G�楇"2�q��Ә&Ke��qP���[���B���Y��{($�g<w=f4%����᎘�Mn��9�3�3�3*��$�{�OԲ����+�@C£r2˻|��j�O��N�-I��#K���������x�w=�A���<���Q�Gޝέx1� pC��2�`wвw`AL�b�k��������������2�_#mM1Z9T%�P)`D�K)|4�	ļ�J��Z��8*&!�M��^ �C2��mH �
�.�5��_�B���1j�]�ס��vi/)�y�wݝ��G%c���+C'ܦO�K�,M�3ļ�    �7���% R���΃G�e�q�=��n���2��y�%@�G�bV��3������8�p�j���C��z1��]�Bt�:�-
ʶ�R��N��OϢ��h��� mذ�p)�ލ�%1WطgY�P7�N~fpƑ�dx9���L#H���+�[�_��g�%�㾼��hN":Wsو�"�~�����:⩣�;�ҟiV�>޵�7
ɸ�Y�JPȨ����LV:������;�jɸ��pT�gy�'/c�p/fs��3[gȉ!p�!>����s�t<��-o)�w��e�b�][���B��뵚.��꠼��Yȅټ��؃�CÅ�䭏�f��/h4 ��}L��Lw��1n�\h��[�3����!�����ZP:�͌m/A:8�v�,��J���M솾� R�P5�͜������TƦ�k@b.�|#���Ƹ�S�ԧ#�aXF��`*��2����6X@�7����v��~����,�dGG����%�Ƹ�ўR��,	�A�nF��i�>H�e��Cқ9���a�eoF��ܷ(V��k8�
Ÿ�������bM�<�G)�
U�|~���ĸ����u}H{�?:��o���>~������q3�>{��*�	��Cz W�q "��4����\�>0����K��:�rW�;?<<ޟo�y�ȸ���8�Wн�#IZʒh5Wv9���C8f(%�Έ�3�sJ�B��y�[�mbު?����j_PE�-���e+E�I�|R_�]�[*�%��q'Cwm�|{��W2�J� x6������PM�-�(�$��J�]�l��z\��5؇n!���̸pft�'����4���~5�9�Ȣ���[87��1�:� 7��g�.�(�!x��+���N�+���[8GF͡�i���>�����2�歀�����ƅscOq��?L��2#�� 1ow)?���1>���v$�³;�;��,8�Ts�/?<|k=q��8�*�������d������*?ԕ��??^���v\�s)20Ws����c�1��8�;MԮ����çڗ�v�t�s��X8o7T���A���?�IJ��W�EG��yV�F<�'~6�3�S�=��1a����jF6��]�\ _�o�ٚ �f��9�p=`��YӼA��3`D�~�����G]�,�FYԫ�&#�͕���j��������w�85#*���� >}G(;�'�{~��C�<���ˋ��_>�[6(<���QM*
���re ��>�����'ya�g�j�o8�Я\rGl>�&! ���D�?9�=6��<���^a�-��kZ�'b�u}
��j�okV$x�^_kѸ��G�nB��8�ΐR�	�g:��+���\|��l���/W��ʮG�P&����5:(5�?�%5-p�(1��v5��+t8�y+�=?^��l�8ۍ�iQ�]#Z"���1d;��.�n�Z�P��@|��Gh�՟&歜�(�r��\Gu��U�NJ�'���eb�G��l}��2^s���I�e���
GeȬ���VL�C�MAq�9��Ls�eZrt�T���e��81W�tn�	Ԗ�D[fM.�uzZj��wPЈ������4�u�tn��T���p�W�2� r|6)
ؖ>`pC2!R-��)��[t,�srk�{�/V	�J-�(�$�ꚓ*����,+)`/��x�.7d"Ӓp����7�"���Q��q��X-��˽,~B}O�Y汮�����Rg���l��Z�7��
�x"̢�-�XcI�j{��S������f��>���x(�� ˊ8i�w���T� ��-�{r�����x"ʒ\�*q�=�k/���u��P���1���΄|�bw��y�<Di���+�<�O�j�x�٥'��I�3`�=fdk6�Eب�n
�x"Ē������]��uD���#�R�����]2��7��Zʯo�8HKB���p[�֠�r�B,�0"4k�:�F��n� ��0Հ���"8C���7tT*���	�(���;�m��H*?��4T���u���U��X-�����Z7��%6�N�9���k4٭�c�i�;�@�z~�7Ҕ1ﯤ����^��x�p���x;QcI���sՄN����f4j�x�X;v�\I��'��~�~�F���k���P �ۆ��>�lO��d#�s3��n��eb����x��KP��	j����|�*1�r�^���ZƷ;+�V�k�-�y�7�/OM��a���t4�ނ���镪I�F5��Ԟ�*��� ���R���~��,D�� w�s��z�n�ϰK�� �[�	%B�M3	5�5~�k�
�x�p�R��;Yh���c�\���k:VQ��h9����w;_
�V���j@)�r
�5wڲs����mn����\E�a�k�s���u��_����l�w!*��ynI����7( �w"��<'Ⱥ��O �P�;�{K'c.y��oo��'�-���Zh�X��w���tm^�= �9LE�8G5�_bI{w	�a��y�����{)FRѐ)F5W'��!:ǡ������(����7s�f���<�n	�y��#��'����Q�.KhȭX�����Ǉ��� ub�sG�$F̇�~����R������ eb��9^�n�a�>�"��J�Z�o"���tu����uiȆn���?|7��vf�!�yˠ��6��3j4�F�p�P".:�&M&����a5��a�2p��1�3~4�f�j��&���i9�VQs�{�T7!I�.6��?cl?��2WeyM��k�����*�xo8��.:U����������.���A^	�P<���z�3uC�N	��M�b	o�N��&�o��T�Q�m�PA����<�ˮ�^s��H�u v����K�H�PF����:�G�U�Vڗ���æ[r$Q�I�}]���F�����`����I�f�%㉖L��&�r�!O�qt�1�L*���XJ?�ܶ��h�$�j��J
f|�NZ2�&/ҭ���Y`ȈDI���aX�ox=�J��
��L«��c�?�2Ϩ����$���S6�����u�R���ѧ��sz�����J^�b2>0N�!�	��A٬�Wu�3��ꜗx����/���j�"2>�48�r�xm��C��QR��w�j���c�����hhQ�  N���Ԕ>f���Ǘ���3� C�a�O�-^H}�Q���b�%a��⌨���>�a����p�j..,(J���(����k�v2�$P/)��kD��������Y�i��U(�NJR(Po6�k���7�xs�x�脷��\�i�ߪy����! ����s��N����Є�ssO5C�?7L7��xICp+I��o����m3��b<�1k��y
� :z�"#[?�G�j�"�9n�|�ǆ[�7�H�t�۶b���V��թ��X���9o�Tz�b����$ ��e��b�̉nuا�R6Ѯ]t��Ŭ����{ܝ��@ʛ�iOw�}ٯ���]{eE̕C�oZ������R�vق�aYQ�
e����\67��\��ܷ����O|���7#ǁ:���b���C*\8F�䑞KE.����n��y��>	7�\���s��5.�J�b6�8C��p>�	����s'���D1�K 2���:��n��4u�l)�\�(/5�.^d��^�_'�4�W��gp9�<d����XF�Z����t������|Um?���ae|s�5ר'�~(㗆�d�뽴�]�/w���ybЊh]�[��!7��ߙA�g�㥄�7%�ϋڳ��ʍm;����_��.�k
Gz���Y�l�ϓT\3|�~�E��� t�[�nE��D�ow(3�;7�v�d���_^�έ(�Ey��W����ʣ����.u�N�&��D�������S��P�&L>X�I�L+2�IP�l�G��l�p(v��M��F>L�9x����T���m� �A�I{pL�&�qG1c�������Ow�ä��5��c���ܼv��g��GĿ��%bo,`���0Ř�ȝq��Q������ }  ҊE�=6ۣv��v,v��Aq/�	]x�9�3ɟOxE5���N����A��"�VT�x]v�!�,qn�Aِ��Wğ�7����l����6�/�?jW�ΩI�ś͕DΟ.m��b��#�*�IwFҵlI�4F���B��]|�^��sSd��Xa2�|�<V�Ld�;��람{{X"n(��|�)��
�H�&�.Z��\�����rp(=h�б��B������N��#�p5�Uȋ"��Aq.qW=���Z�Ɋ"�Ȭ����%__��%T�
s�������m�6�z�m�j��'tf(�D����[�7ܻ^�۰�k��;݊�#�
��^��+Ú�ն�ǔ9��k�ad�
#ŷ����yގ�b����Z��&��9ɷFf(z4�p��z~Y�x#�w%�'Ɣ���"�n��N��YҠg������Z�b.x/�>�]?���Q����s�V� ��L�Y���]�<��gœ��6:M���^t^�؈g#�����y�v��A�5�y�^-h�D��j��Vs%��g�� ��p�	��myM��&����ʆ��i��i��5�����k1��sL�dv��;�E7J:��#�|�3_O	��d�?��[�q�"��z�������ͩQݘ��F0<ʅ�
���.#�k���y;��0uo���NdY,B�h�M��4���0�~�� ��P`(h�	�UϚ $x �k"�~��P�z=�_�>x�}4ύ�u��ԩUש],�J�v���4�4�4B�R~� �\�I�*���F�l,O��AM�`x6E�J�������~�$�T��ů����Y��d:պ~±�E�?X�6%^��ޟ�m�f	����%gĺ��R�|J�<G����ǋ�G��,����Q���1d�oK�	V���\����W���I0<B���o���a36G�$dW'�b��C�6��{J�}��v�m��)�x&w�?K��Z{AsG����7q
9v8E��UFG&� �@]�`8��I��x$8[�d��L,t6Wo>}�g(�,g�y�1���Tl����<F�aJgYJgW�)����(ow��P5�5����T2��rZ0,�?�5���bɶ]�H�T����������      �   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh            x������ � �      �   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
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
-Pl�#�x���Bԩ�E��&r��Z�NM�d:ܖK�/<8T(Fo�&��NMd·��A�Wx���B�m�$�9�C�(�D���~!M��6�����κ\n;8k����ξ����y�^��BM��m'���m'+f�m'k�m'++^xp�P���m�$Q�vpҖ�n;8�j���;Y������S����؅�=\]_r�[���,P�"���p�(���߿�?Qg%a      �      x���a��(��׬�n  �`/�`���gpV�3�H�7t�ȉ��A�'��W�Z��v�u������ߗ���_?\y����=m����m��?��0r�Ȍ��"�����7�����)!�|�gW�W\�]�CY��K)�M�z���m�ܶǲǼ�5����B7�}�@ߟ-�G�#���Bb�z,[��,[��'�%$XBK(`	�C���qW����U<Ⱦ�Ċ?��-k��d=�u���ϊ��
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
�9|��   ��};���ĳly�g�1}�^l0d��}�ݴ�&��z�!���n�P�)Ǫ�����j�p����GN�UJ�[ᆒ()���`��jlX��7L5j��N�/	{��(1�4L�k�G>�N��H4J,q��LR�ރ[��ijL ��e�<ZдwW�<ِ_�J�_�O��tq�+˺����]�w)��-�r�sZ�M��zP^�7�X����$������.�3����:?b�>��
�>�-�vǧ ��1����8V�z�q�^�S��U�Zyl=E)nT�ZqC*JJ���V+n`�D����Elew����}���(ȋS/��G&�K��`D��` ��� �95f�By���k��T�M�V�A�����D��tL�V��ќ^�ğ��{Lۨ�hO�����Gn�խqۙR��.�c���.WjD�]�q�~<��k�5y����׻�A��T{`ƚ��ҷF���#�%��ʨ�֞��G���0��lk��H<[�S.s��Ά�Mx�V�l�@(�Ά��lN��a �8�>�:�1�Ά���'�Ά�Ě@�Cj����J]-j�C:|U�a2WK4�l��H�6�8k�F�c�ؒPr���0�Xo�:�f�Ά1+��i:�:�(�i�yH�A�s���~F�Ά�Ķ��-�Άa��՛Zg�8�S�Vg���Tq�hu6�)��S{'�@�ũ��j ��Y��a ���Z��a�\��Qr(�V�l_��	8&`Z0-��L��:��Ά��㤴\��a �&PZ���0>I���к�u6t$6z�ϫu6�5�K;�:�lr=�����Ά��;.����l�[L�~��lHn��.Pb���0�X����u6$��:��\��a ��G�Ά��:D��^g�@b��Q��a �Q����0�����Go��0,.t*�u6$��Zu6��Rg�p�)��o*u6)u6�o*u6�q�8'�Άq�S�l�H����l~Ԋ!�P�Ά�Fm�$�wZ��J��A�^g��-��ku6�Ҡ�ث�a���Pyk�>���{U3T�&�����@�wxo�eM�g��'{L�m������C���T���E��S,e��ꋸ�pfY}�C� ��)2a��,߿�f��B����R������&��=d�Ō��}�S�Fݿ`f���@2���5Q��������׭,s�&�ϋ��������l��x�)���kb8�|��༴,g�)u)��C����s
b��c}F�o�;�v�޳�k��{s�6w�	i�u�.����y�@�-O!�g�cN���5�gf|����LR��[|��R�:�Wj_�ADi�K5�+lGkq|zkK�� �ۙ��s�p{[���hKr}�oOe�%H��Qԇ5�k/���.և�BM���:�.g)����L5Gk����vR�_W�8Z�P�s������|�~ŭ:���|���p����S�`c��� ����8�6��.]���8,���L5D�gk]�..�K�[-e��-���#�z���p,ܼJn��~���w�R���N�SFh����c�<:Jw��_#{��^�3������Ҟ�B���6��B���&
q&�r�Ԧ0Q�_��B�?�e��,�?�f���E��B��,����&
����d&
�����MZ���L����&
��}�u_��D�q��p0Qh��k8�(d�k8�(�Q�5Lҍ�&
I��aH�$�"��-"�N�.P��NE,@����"�۩�`���S��D!ݸ��`��@�N���y�S��D�YF��N5�d���j&cf�@ ��u�1�(4.tKө�`��|!/L����B�gޔ��
��"��U0QhU��U0Qh����SW�B�G෯G[0>���/�V��ݶ�|0�8~��٭V��r��H���7;g���L����;���p1�=����@��œ�o�Fh{�ڛV%��^�k�����c-1����`���=����;���z�������Z7x�Ӿ>��Ov�����Zx��uS���i-̀��7�F0o�~��R�r���r_v������}	K��!�0��I��d�V�ǝ��M
#D��Z�VAx�����F]=�j!}��)Ǚh||�x�۫���Z7�7�m����ďv���cg�� ��r��_�J���5ح]�Tw�eصhD�%��]Ǉ���(c�Y}� �����?��W�[i�J�5��|�6�%��������*���^�#�곌o��ѕ�X7Qi�.�������ﯱ�8q��2�|��.��˭�����"Q!]	�M��n�,/J�K�Ѣ�5���Q�)�����|��8<7g��� �_��s���N�[����-`�h/�Z�)�����gke.�m}�_��JKHk��nϷ�g�3���q}�9�^r��a{L��Mc4�u����9Yt��rnz���r���W�m-aX�K�ǡ�F�H5h/m��˴fw;Lڸro���:s�������A�q�������>���cg�ϳ�Zyk|kh��ߝ��u��liKy|=K8��}�P�Y�/e���g?K)㦧>L�}a��j��Ӵ�m�cS��~��Ͷp��u-~`��f�Z�Dp�=�o��񍫾üV%:=��)�5����ǻYpuE�?JTG������-6��{X)����9d��V��[�����Ƀv����mch���|����W�3�G^��%�R�x �� x�W#yiQRI�0�'|��R��n�ΰ}pH9��՝�ޟ�����ޔ�}(hb>7�s���k��P|Y?�k���*���.f�[4l�����?�v�      �   �  x���]��6��5�b�@~��b�ݠ��Nv�
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
.>�pl��?��kp�6���6N��%q�VUx���u��hk�@�9[[�ݲuK搭�W��9aǗ@�������ꔫ�z�N���ǫ\E��y\�*R��(W�;�P��wl��*>ȷ?�%Y���7)���5 A��xE����@��e�@}�W�y�0:�P g��DA����3�:�w�\H6�s�L!��=\�|l��զвf��Q��|%EB��^D��	��4�:�]d���F6b�����fvC�Q3W��[��92O���F�R�E��U�BgT��Z�f�~߾��y!D܎}�HtO��.̄�O������]?�      �      x������ � �         G  x���=o1�����́HQ��@�"uRxp� Y�S
H��_Jg�}IUÃ���s$_�h"Knc����c��[k�C�6{��M�~����{9������}|~�����qc�7�ߗ�S4��*:*gOE��U��{x�s|��/�Sť�Fy�|z�Ua07�`~����_c-�X^�����z�C�!{�:5Ѫ2�X�x�΢�x���3C��8$t�AX�t�^@�Ө�䔙4�Qi	��uw���J̐I��u,�.0_&c6ZE�A�]�n^��q�h��\�"��;g���q�X���)� ��{xC.��^앱�dE�$��q�H�2��*b7cr��Jc�]����M��u+#�ji�׹5�Xn��}REL�T�<�5�hj��S�V��\��UĹz#������N�VI��,�
H�����_ Χ�[��G2ZA�"�,1cY���x1��`R�p�U��&��8#f�QZrM�Z*��2-��2h�ܯ���*��nT���5� ������������v��:l~����vg�������1�>}��d>�������n �/�<�         >  x���I��8F��)�T��f"Ȣ7d���DK�2IK)$t�gQ4�_�̟_)k< �����+��b}���,�����}����2�`��駮~���/��-w��_&�lh��
'����	�B���]����ǳ��>`�Ζ p���� �ޮ��8w��Z�W�	G~(V�#�y#"�:���<��T0���9�1H��τ���3��@�UN��-��\T8b�!Yn���6��*� ]��PH�+຿Ri,�-���qƱd7�]��A\�W�E��P�\��0��	=�U,���:��d�a�E13Pk�@a���g�Z?D�-A{�ݢA�B�A��9C�0WS��ҋ��D�siu�A�E��� �$:Vy0���kC�i�J��%��	�׿Mߧ�"��X�6mE���9�N�N��ңN����jy��1Pd ,)��̡$A��e�Ie�a�RlS �c��|�֚���6���y��q����!B�������� u�S������eH>��hr��y7��
��Lyb���$[p����;�֢ g���ui�m���X �CE)"g����HŰ�����ǔ�`��!}+��I]O�B��M����W����^�x�����<��u�Ha���Htop��^B<�[���M'�����r_����J�p<!������I۴��1����$�z2T�dai,�.>�q�3�!���p4�9��|w�#N�oD�D,Y�ty��t�2�� V{�Ƣ���&�y}�u����[�c��qi��!�ݕ�H������e��mD�qyqx="���˻ZQ�RXe�u��Ê����KFJ�0i@P��?�e���:׹X�߆���J�ߵ��l���I��V'h�<�[��V]�d��7_l	2�߮n�L?Q����Ԑ>��/����c3͠W�z�����o,�>���Ky���!ǔM�� ��}jc$~W+6c���V6�1}~U�m�&���걙�W�>N՗W�8U�g��-��b���UVշ�/>K�"y|�Z��㋾�2~��k��;��NKO_�g����>��JT����m~�M2���딉�">�!�D}�q��z��D�Q;f�W[��m~C��{[��D&?ܯ]z|��Zz$�}P�R�<k��_	9zl��I"�ϋ�Y ���{�b�8��j9�/ҽ����b"��e�k}��^�Ԍ�O ն�������� �Fb�	��'�å�!�V�j�h�T@<͟.��@r��\�^bD��_g*���,=}��TWT��E��Ѝ�Ej+Z%t_���,�{6      �   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      �   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      �      x������ � �      �   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      �   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      �   T  x��\m��(���{��2_��Y���X����dvfޚ�.��B-���+��+m�������-�;�m������^)S���(֨yRc���*�@�_�P����@��5m�D�F���{Pjx��0P�+%J��3���4��Z2�QϹ��NSjkH1P�+�i*�$�x%>M�{+{x{e>O�;$�����S��0��������������sh;�a�2���`X�5~߰9��1�x/�N��ׅ5�Q�wsʻ�:���㕣����K�9�)�u[\,��͂�+������{,N3�r���>�c�&Ҝ�@�Nټ�ֺM�;%:ŭY�zm�+��0Pw�[3�b�����Z�a��buZ3g���Z�'n͜c33��zI�9MTi%��am�����yֺ-�&�9�d�w��IMlۍfα���9H��X��cu�sS�1P�s����9��9ba�툡X��رg[���W�kǚgCP�M�{��92��W�c[��E,�S4�M�1�m�����N�I�fi������E���������k��`Xo��O�zo�����ޛUB���Uh��?7`��R�#�⍿/��W�0�Z_�G���Ħk�������F��ڬ�NS��p2ԝ�����a�$c�7+���1Pw���zә��L�Yr�ڱ���0���tz|tZY>�E��a'ΤvW��-�v5>Ā�%��Xc��bfg�3q*鳎>o���V���p���@�M�~�a��a�Om͜�0��|5���fb�z��u�1�^�����[�f����k3��N�f�b���J7�v@޷A�c���0P˫ЏM��L�5�}lp��|b��{Yo����p5�"vkZ�ugɅ��mt�0Mmuv>Oq�K'�nO���ʺ:�5�}���'�j1��L�8�9�c5~ҵfɍ�c�fqҥvH���0���"�6��ܱF��0���f�����4�2��5�0Tu��ͯ�a���5s�h��|�a	�'�:%[3Hw�Q�;��w��,.y������i�\@`�U��z	�.�_�as�W�8k��~�rx&��Æ���b���3?�{S��i�d�K�ib�T�7J��C��8%K�ڱ��65���X�:����:����5�~�����s{["�����a`�����1�C2��Ҏ5㯷E��)>\3�S�0e��Ű6�;����r�a�yk2�y,i����7\�u�]�|���2�×���8����/����f�bH���g,^1B�Rs⺪U%�[�ל�a�*q�ǠN��#���G6��7"�G�8ob�*���e��f�RkKDDJ"���ڥ���1P�ֶ{]�0P��v,���A�Q�H�\��0P��VɺV[��k�V��0P�%�(g5	ð�31t[���#:q�c�)V�K\�:bD�Sw��}m���Q��;��c�U
���d� �vl^3?U�A���Th���L�!qM��T�)M��=W�0P��v=�r�����Trm�d�u]�4)�֢+��Q��v^���&nŌ��-�rN�0Pۈ���b��AX�2E&b[b[��:���M���N���C	���d'!�P��&�a�^X�]�˵yb�G����?���}��L�	�R�1P����ib�vs���ǧ��*����!C���@߫a`&�]��aX�Iө\bڰ�8H5�`J��6[�'��\�Z7�Ġ�v�S�\B|���qnv�b�)U.Ef����^m-�+l�<s��9�;3�k<B�)2�@m��*��A�PZŪ�OڊJ�u��P�C&��+�f��k�$Uv�
�S��1�-R����LoӔ�o��kʯ�����a�J��e=��s��3Rҕ��:��ҟ\]�a�ja%��j\��!�A�Qb[\��U~�\{�Bʏ�WG5��r����C0r9�md�n��W�+�K�o#�{A�""ݷ!5�6����4%r*�i:�I���u��o=�����^y��Hw��R�^�0P�8oZ3��7TU�v2��c��R]��&ꩌ���� S4��
��]�a�Ң����j��hm4s:�a�N����"9�G0���D�*�����Hw�6���Y��ֻ��O4챰��L1r _�G�Pk�U�<����\��ot�����51710E��Z�	>m�g@�_�ҟ��ڭlR�k���E��#�n��i"��%��y�0PU�]	� À��[�gj�Wi�;.�b�[�Qx|�Z_]�}Hk��6d�,�fLRc������00E ޕ1gS�.�31�e����Ie�U8���u7�uCVMr]�f�+Q��S4�y~0O����1�W�]rj�6��;k�u�m5�{H"ׅ�5/f2���H\�fb�Ue�[��2���*�5�01HO�[[������c�Od�|��W8�ǀ���Ɉ��]�'�=���Z��N&Խ�4ub�Juo-9�$��D<?��}ވ�5�1�GHa)��*}��9�ZS(�o7��2���H~����0�j�3Ɂ�+��<.��]�1B��d���~�r׹��:�.��rD�4�D��cq�Ï||<�"��Mʓ�E6_z`�%F���A�>� )G\�k���ʛ�r"'2�a��+/�cRPF@��'�,']0]�>��ۚ�ĳUJ�y9&'�r��u��UN7Ԭz���L�@�Մ��W�vK?�H��O��\��m����0چ��Jd�:bD|+�f�>05f�׮��MM�����ٶ��a�RE1�R�Ƕk���;g&_Ln�E>|ry��T���<�ٮ2��0�u,a��  e懃�D���0X���2I��^Q�5|R���g����F��[X{e�\Bb��:ܐ|�ְ��a������!�~��F3W�n��Ai���0|���B��LN�4T�d�5󽖏^e��?�rߺ���>\�/�*r��c�s�@UosZ���:�@Uos�I|�o_��uŠ)���I�a�z�u1����%�\�!s�>T�]S��`��~q奧`�>�Gb8F�~)�x$4�Ζ݈㨉Bb�SIn��Q[&o���1��m'S�)�vM���Dz5�!������ρ���6�|4Ԩ���6�l�v�]�׶=	At��P���:���MݕDG�${^���(�l�չ�Q�|��aP7�G�$�2�$\L^bb0��
&���a��o������z��)�>p2�,4�\��P�9����Z�┱88�U���1�t���31���զN��*\�:�o2:��C���M�^���C>�]E=B�Bν����~�P����*V+�5��n���~r�K�1N�+�Cٓ�����Ck�z��6���^%oJ����u�f5`�@�R�5�/��H���p���~�a��@���짢n���_g�B�u?�210�PV})�arԒ~���̻�q�ta�Kl�6*PT�����N��gR�:z�c�y/l~j��7�\��{���t�����F��r��00�d.����̂�V�a`���U����%�g���C0Webb`��܊���ɬ��;��V�I��X������V�S{�������[�}H����fy.T���a����"�B!�p+�z�0P�[qA҅���Jp?�ra�UU��n�W�9�������u(X�j��pU"��3�>�]�&3	�<���Y2�h����l����a`�	3>��d:_6�`7��ӟN��Y%����1C=L�uM�\ؤ��Hk��Gچ�5�8c��IP��W\�YS�^��^C�NQݩGAg@�NQ�jq�(H@�ʩ���@=5�mT�@����j��$6��Sl�
�������'u|�      �   �  x����q� E��*��f$�0��T���ȅu6�Z�?�#	�,�I�23oR���<5=X�>�y*.m����,{N.LM��4l�8�͆$��fW�@-��ѯ�]�ڨ��-S�}K���9���l�6�|���l��H��q5�ܻ{d,_� �V�7��!�N�����O�8���F�5��@����g	}'��\I��|EC&��!�$��s�{$���ƥ�5��!���K[�{Gm&�R����te��C �W���u�7�R�u�4�}���m3ڔZ]e<�W�@�����!P�U�X9��Хk�V�!���,*.Md@�ϰ>4�����|:qɰ�C��/Y���wHZ^F^f�����Nqź�u��?���!�N�鬎��u���&���a��ګUr�k����	�`��n��_���N�?D]��ҙ~
�	����ID?Vw      �   p  x�}�ݑ�8E�狢�-�ڲb���X�h����V���[� Iv��Wn�J*�w*�s��}�1ˁ,reAK�LP��;2	:
ʉL���&AAA�Crf�~���R���9��d�~��{h1{��֙��9�Tg���O9
xh�pђ��2{�V�ي#��|���m�O=�f[��T�>sHx1s@�g-&��1S(�b�����8�Z�c6fj��s��u�����|��z1y`Ae&-Ҙ)xXL*Ø9��bjl
i�h�\���{�j�z$}y����CH�)i���L��9� �ی�p�$�ƌu�g@�CH}�D[d�R��J��3���C�MՌ��y�nm%N�3�D9kdв��K�̃���LIC������Bh��gbf�L�d�_ ���)����&�Vi�ypf��*}��^L� �W��}�('{h hkY�ݦk?�I �jƺWڙ��	�L���s��3u+�פ~_��>@�$�:�o��K�͘��)i�5�6gP5^&�I ��K�a1�(�d��3	(�Eg�V�t�=\%���� S:ԡ{�I�r8����c{�ޥQ�x!s��hD횰_�)$�V۴@Pם��]36�%(A���C����˸���$uXƭ5n&A����73A�@\�
��J:�q7� ���mћ��i���7� ���<�,j	���5x��9S�pN�� ���Ə�el h�	P��2	�ù_n�(�s�wp3l7�����R*2���u�y0	
*3	:
��3L��n}0	
���}0��0�_�졆��_ʠ:����`�@I�W/=�<4��-&��[����@A�[LXPB�]��lW��{����C��uׁ=ti������滼�j
�d����Q�`J:xp�L�P�eܖ�f
)t�;2y#��rX~5qHB�^��fԃL
����ί����!L�2	B/-c�����u��@��_��L���,c���ݚ���x��L�T^?�LJ��F����*]�M�fP�x"����M'f�&����:b����|����%2�E����f����_y�o����I0P�A�]pDAM~���'
~��o�?����|��k�      �   0  x�u�ۑ#!E��(��l!	�G,�{�ٙqsU��:FhI[Oړ$�j_پ$�$�|�Z8�tH��)ʩk�F�1�h�^�s���E���4�֍ipzi������_���m�SR����f�9u�����8�f�&T��Z�$dp
�����)��k}�6�q�M��3�M���Ғ����fN��p4l�ʩk��ƹܛB�VQ���`s�J5�r���[��)4@�$��&y-0��[�f�N�Ca�pj��ߩk�6
�g�=���{j���s��7 ��&I��[+T��C�Z曤OSN�IZm�< u�=��[Q��rѭ�`��e[����������y������ZV����֛�
�p���xS�hA@�E8�����<�ҦЂ�3�}��M/㋍�F�߼�R�b{���,
�E�����>��{��GG0\�:��E��_R��gD�e��Z�rs�ڱ���q�ڱn;���R%DI�i��>���+��JFs�hۜ����WmQ�I#�}�_ԟ���v(��1��&˜b+ϴ��KP0�38E����;���%���纮6��      �   S  x�}���!�K����$v� ������6�+f�î�W�>�KE�%���S}�1E3Vt4�X���p�Ռ���Q�u�w�Ǳ'c�3�S���a�r���t�k�)=cp�;�8
g����N_���%��bU���1�̹��{VL�M5q��y��~��tT�=�Mq�{v�a�u�gv�a��v�g��R�MA��a�l��џ`�[�'=��S��~ɾ�`phd�18,��y��w�1g1����I��������ނ!;�>��{�f����-�>8�=�u]s�w��u08�}�aIr-ȵ���܏�-�.��H�g|���Ot�����o)�q�JY      �     x���ݑ�(��M��^!�!��`��Z����N��W� ����2~�ǟ�\~g���_�;ݝ�<���uL=[ݠ	�K��3Y��D��C��	�q�<]�P��w�)g/�HMt�M��ݛР�Yx(�ԛѠ����t�^��TizJ��ҹ�Ϣ4=|���,�ܬPhz����
�&�z���w�t�D��I�1c�B�������7���?�ݩ���((�E�^�L�t:�7Q�_�ș��/��p���L���*��V*4�}w��k�OJ��K��W(���u��+[��T$5k(��:V:(��G��T�l�J�Bz��A͙U(�Zw{�H�j�B��;�6M*s�~U���s;i���5߭*��t���A8�;U
��sh|e�ѲJ��0B@Ri���y�LE�?�UU�%��W�Є�U�=,G;G�2g�BQ��\?_�I��T�\��s�*�h`�ꔆA_��~����~����r�6N���v�A��V���Ui�]�F
�#���Y�Y*M�^8v?�z�&�����[�&���b;��*7Q:�F�Xd+��P�	r�׳?��褑�pZ��ȃs���i�J�j���5#���[�d
���G��n|),@�Q)�-Σ�)�7HJ�Gu�)�=eJ!��f�$�R4��3�uhR�W�R�X����َ�R�s��ՙU(�,�|>��
���<P����"��_���-
幝T>��
E��.J����J����(��KL��W�xn���/���0�U
G�^�S�����(��w��~�jP��](������js�^�c��ڻh�%���Bq}|S���l/&���÷x�IɭV��6�\m�jk-�kZ�<�D��ʳM4l�髆�)߹���[øzƵ��9y���Y�;�m�T
�zl�y�b���#G(4=[��W�w#�IjX�E�e��NB�Ex���Aӵ	P%�ܕ"��D���+U
����0I&�����E)k6DJ.������\׏犭�pW�u�J���}��Uvq��p��*7%�)�z��.fN�X���9��Ja���6�S��MBY�$��v�M}o}$��N�g�|/���Ɏ�7� ��'����*�z�הA��s���9,Ŭek`�5J��ڐᏼ'�X��5e��꺦*�i�p��ۛ�*����;�r��(�m�l�TR
�>$F�˼*��9wfu���Fu�O����BqF��׫����P�����X3���b�;�=��=�O:r}I�k��Y*�B�m4�e-���U���矔��ֺ            x������ � �      �      x��\ˎ㸒]��B��\T�D���e���ly����r���;��?0AR�)��TeJ�	G(>��;Oϫx��kz?����#�	�`խYu[�~?�(c�B�C�����䔤'^ȏM8>�����!������������g�4cg�6�h���b��}���E�"8׃�����7᜞ʷߤ �S����o�E�m����{���ū�/r����Q�yvy
�S\�)5���2Vѓ�3�y���O�%�#�<b���D;?ۼ��DP�C���u�h���ּ�Y2Ȓ�xXYʍ���7I�Y���,���&[�&[�xt�C�_���	��)ظX`�0n
�A�b� 3l���%���68w��`�I�f����#�2&�U�����6�k�~��r��`Ȕ��mdWu�<�����b�����q�f�T6T�t�}]?�ZЧ�a��7�(�#J#�(f�4�0{���==�{�7�AL�j��=��x.�^���ĀB�Pg����il~Ձ�R\}�*.��&J��S�G���|�A%�K���h뿺��~�_�D>�>�=���G�a)�7Ժ��)t�II2�K��QDArU�x��0�z�UH������SDM��>0
��w�R{̾HF��40�y='�o<T1;.���;��h�{7GT9�uLg�;3�ǻH��N#@J��E�V�r���uk��)����6lVސ�B�FR�P��-b���9�=[/|�%V�)f�x��Q�����?6�SR�st�_4�l�$���='�=GQ���Wt�-��J\:V���ڔ��L�8�9�S�Y�9�;�Zč�{��s�\.-���ťܧ~ë�L]/<)�\�.�R<I��QTXjm���� �B�ּ��7;E���E��e!��_��7��	C�rK�kC�O�Mʳ\�"�,�4"��9?�n�_�q�{g�3��-uD�r[�S;�:H/ԏ3���F�74����YH;���aF
~u)�U-#����ϵ�ak�*�_\���8��������h8�2��*d��D�,�#�^?+*�Ԙ_�F}�j�)vrB��KY��V]�l�a9�_nit����?g��r����+\�Ł���wM�>����F3V��K	l��[��2��x���-����0Ԓ�"�Ӎ�.Ӆ~Wu;���^�B��G�>���fO�2ю��ɗ5QF�*�7dSs�k[Bčr��?t
�v2�3	�{�a��t#�f'cn8S%��2zXذ��MAbC� �q��l#�ThJ������eƥ�S.'���SiF��w*�]C�jDG���O��2�PZ!��l�M��H��ӝ��^Nl?E�s���Z�w�V����2V�M��R���(�c�d �U���S�����be��`Qu�Ʈ��3+	=���(�`�e+> ����}�Ж9��G���H�P��^��b��VR���:���(�G}�M������$����(q�xW|����%l��i?���OJ�Rlɴ���}QRA���B���[)������W�|���x�M�֢RR��k9ք�C��{����]K��W}�
�!�NQY���y���^|Q�K����O�
z�t�0%����k'F
Q��(Sn�Z��=v�QA'�������E^���k��Ė</<U�-P��+�f\7��"C��8�<=F�X��ss�3��LÐ��5�N�%:�bc��ʣj��8�W*�(O���L�?'�J�f�/S"�0�ZG��d1ӏb0�8��K���b��(�?��_���K�B߮a�.o������	��]\1��(Tň���Ěݼ�Z.U��I�<ē����!�cj�sz���7�9x����7ɰV{�`�X����>i�w�qst
��A�T��m�?eU7R�J�^�K�ڳ�R�	åO�J�� �S��`/t��X΁</���+]	mX�08���9R��l�"�=9����+U0$���ϫ�z�a>�T٨�����./e�r�usc2Yk��fgC	)�}�ZA&Q����_�*#y�T�v/��T���O��,��j���>ժ���[�z��E@�yy��涵HRU�A]��S΢�Dd\y5��݈�di��"l��56w�01u��ˬy.SO;�A0��@U�dRqS+F8f��c=3J����bS@���;�5Ŭ�gFdY�X�/�Z�^����||����R�ۻ.�5�bS��x~�Ig ���MÐ5Yd�5�b��x���^�L)�g3.�(�nq��q���`; �@t�0$�lr=*l�8E��!��l��A״!�9��A����E��/�� �p�pl]�R�@|N��yt�N]�	J\K�DQ�lr㙲I�q���dХ�.��I����
u�f��B��U��0d����i��񭜤�\�Vk9f�!k�e�k36W�]/od�Xa�2F�P��# }֤��a�r�Qk�>�;�B,�U"�<a�z +��WY�m�f�ʔ�s0��$?"Y���)-W)����[�L��%�<�j�B��+���!S��M?|s�e����L弳k���Q��ah!�F�^�O*��V��4�W�ޟn��K������)�n����Y��z��X�y��nė ���;��/]a�%8� ?}�4�=xLCs��|���d�!_�>��A�ҫ�e.*��dB��[B��^�_aț�J4�鋻���6�+-�®(V�e����������oD7`��\-�Nr�Nn�/�1�e�,`-]�xy�����=��X��b�!k�P��x����AsD� ��sZ$:������m��ܡ�-�?�e����?�>O�s[oj��.�S9���C�����-�����R�
Cfn��'5O쀽�ֆy��E#��0�eaW2Gl�$wm����'��A���N�g=�cp�&�k��;yRK�2�=�\g�a]�<Y�zfn{w���ș�T�u/=)6�/��ϕ`g�8ǫ�&�|��
�1��\]�pk�8L��6�!��()o�İ�}�ȁV�����wJ�a��M�<��˖:eK������Bmuۮg��W��ݲ��;��L�@9n�^hs����W��5��w��gs}�:tY��7Cl��T-�˝۫;s��[nq�+e� �Ui�f�0�K��d�_qE�P
�a�)�MO.`������4wMcpL}�x��e{��X���"h1�L	�3�Wq�U��ՠ_�9�J�ސ�����5g-i����qu�� ɸ�x
�t�J��~���{/_�_�k�S�=R{r'�}s��I`��aē�e��*7l�%�͍�Β����0�`��9���5�����z�^���Ya���D�j��R�d����48�2�XӔf��uմ�/��	��o�uN�<"�� >����b�)H���E�Qʡ{ʛ����D��!o�E><Ч�����3�T4�S���`�����%��!efɥ�9 x����[8�rJ3�L�胊r[��h��C.,���/�2�y.���?��)�ޑ���4F;{D�x5#�ޙm��',��b�x)�`M��A�chd>?6w�y�\�̵՘��_B�����;�vF�0<�1=u=��
DUM��z|�G�E���gNǁ�x�b�P�x�O� a�Z�V�;]�#���L7vf�<cc�8k�{i�$Y_v-�.49�\�il��j�+k�,4y��cq�j.��h.E�pCU���[�x�!�ۀ�$��.=%[�2`(q����u�!%��A8����H3����R�<�‽�x�,v͝qJ?F���P�w���]||�mP;;�ı%�\���.����V���&�̨ɔ����.��ӷ�57���2%�Q��L�����x��B��}@���JgO8%�ë���o�7L(h2���ƫ���M!zny�)SJ���%%�<z�nss�2��u򛓓����̟���+���0d���=�zx�0��gx d�@0��G����<��3��\S��KQ�|�}X�WD���/�D��^I��?��}�V+,����f���   G���>�~��`��w)��e�=�Kg���([�\��F�9�`�ˌ�cׂ3��R�Й���Xr�m#�x���+�n �j�{�wv��*-0zx��)hi_(���(5R��9�N�W�M�.� �n�Є!�*��q�5?��w��L�ʝ�E�?�߬y����������EuS�������,���e�����D�Ϗ�WV�(�"�k���@TZ�~U�M�2wh.Oy�+���CV�#���HR�
Р+ڵ����L��h��4Xu/v���7��;�7��]c.7Fu}s����W�A�z�Q��To��0�ȍ^c�ng�Y�����{�B{Y��ɦƗY�����h��=v^[�9Fq�s�&�r��K��<�˙&�q��q�������wv�\�aʈ��p��p�W�v��	C��-F|��v���˓���0�)��r��`�ʠù&��,�.)��6�"�ݾ�"eۃI�Ƅ����!q��Z�=���Ga��.���ˏ�.��X:�<vt��%��n�mwKS\���6�N2W�=N21���f�x�����h�n0��+w[�)����6�2��������m�c| �gɦj]Kr�j����u���=�m+�^��Ն|�V�׹�B˱����ܲ �O����{���˰l��Ȱc�lM�	�t�:�&��h�(�ٮ��Sm�+ް�Ms�n�����VO�Ѱ_*�s;ldbT,(�ek[\�eJ��6�L*5���WgA�].�~�Ƹ�ՠp�!ka�&r ��~�'�7X��\:s��A~�]He��ʗMF��wxw\ �Ʈl�yՀ�{���`욖�m^{gn���y��|��y���5��:0tc!{t����6��e��z;׷��ML�@��x�P::t0��+��E�i�lIwA����I�C��Z���e��]^ϱ��~n?sX����Y*+�Ѱc�ж��y��l #�1V����ڔ�՞;��v�^�û�ATl�W8u8��j�wq�V�@I�˃~vXծ�d�����|�o      �   �  x��Z[��:��"p� �1+����J`�ڂNOBU�� ���j������-��	�G��1x`�,�~�=�c��Z�HZ?���"�W�ߓ�-���a�2�s��̱)R~!C�D�~IJ�"�)�"ĺ��=*;�ؔs���f.���u5�\w+�f��B�u�"���ZY����^e���cS�<E�2q��G��@��L�e�i���	Щ��)��էi��V�eK�$fvX���h���#��ih:���&D
Z���Qb���v�\M���-0t?2ǆH[���5)�Q����Ļ΅5�ߞ`=�ޞ`M��'pzԹ����{{^����B���� n�ww2y�H^���m�Fo���	�^@��{�7�׆ѭ�7���{-$g@�z!y�1yo��ͥ��7��7����k���F��=����o:o:o:oooT��׍ՙ�(l���s4A?�nU:��/�"����xY:f>��P;�]1EA0H/��	��]d�h���x�sg��:ܑ��!u@.��
��"���if��q���lí}	�	��q��ӂ�V �A�
�U��xT��oEQp�x�|���[���E���Ř��i��g���f�pt� �[�<%8T�bؔ48C������Wo�VtD@b�Oj2h�i䎊ࣀx�牠Y8�AF�D��S��J߽&��uf��9�+�,��_R�)�*�U�h�!TN=�A$�1�"Q�]q�.J�k"�����DPM�	Kȃ�O�o�Fkuuj�w8'"�#]�s:h�$ܵ�W��*�E�X��3�!�F�,D)v1�Q4���w�@:�����`K#�#�� !�I2�U��(� ��zٟ���f���2ɰ{�C��fQ��ؼ��fz�ȼ,g4�e��}B����f����|׆.G��Y|�̨Dxl�7ZD�<��C�	����:
��?�޾�y���U�9kr�b��59oM�F���K0����D�r ^7zxg��^:��5z�0�r ���Ws��>�W�3x�vi��y��̽k��P��M���/- �����y9	��E�&��Atz���8+ɣ�9ܳ'���3S(D��^���)��̍^�s�0z��������y��/߄^�	����c#G�׼R��_��s�dsӿ�Gg��9AW�!2� p�
D�+W�	�B�_��ey�Py�s�9[{0Vi{_��7�@���}���E����=�4^���~�F�z{�׾f�����v|��[���Z��ʾѺw��C�.H�#R֭��+�TX5m|��b ���������¢��|\����?Y�k�ͮ���$_�)�G�N�(��~�IG��{�� �h�#;oC!�)Q/�5N���4�Ȯ�U�0Q\e�$ ����9Cr�mա-πk �g�*)��x��2�ұ�G�C~�+:t��:)���#���	Ĵ���:��T{F����؃y4����B���������@�N��f>�˂e�Kh�0��a���~��t�/'��iG&ɉ/���w����R���Wg_�$p�v=|��=�����(�B�(FtXG8�f�Go�a����� �4(��vV1HYH�a7�=�0ߣd�����S�3p�S���P�3����c��?���������2      �   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
c      �   �   x���1�@��7�i��ݍ��ĕ��D���/�#1��}/iN}�fg�mzvu;�#�,��8Vr*!˅����	�g�6�W���n��zo�7�����-�1�0Y:%�6��F^��q�܈��4T
e�2���U��o�/>;      �   ,  x�}�]��8��˧��%�?bO0�?�&�*ې����7XB �k�O�������}��q�r����/���)�r�f��<�tH�p�۔Oٽ%{�p���?�E�Py��xhG�Py��#�Y�~�H&osD)�<��ۜ��T���}���M�H�*��?��4�]$T����O:%�� ���؉�AH�S"[e2�J|`wB��ŕg92Y�� :!ځ�EBe�<���\e����ܚ���#2�� ��MAb^
�!T�	Q���PD� �I��5I���2D%� u�A �%��2�N|LZxLA�\v�T&� 1�)��c�p����}$�P_�`J䔘"SB8!J����d#17��̇� *�+�9h2��_ab5�d=�]�
��� X̅{5c�J�9h�� >U�g�d$�ab�d�>�MA�\M|U�!�h��4�s�*'������w;�ż��Ce���d������[R�a�,�T�<�7N�]�� Hm��>�� J|*��A�A�x�k'H�A�At�C���dL�	Q����Ε� !�l$?LA2
&VKL�v��Zb2!�Ce���+�A4JTҗ��tK�� �� �1��q�`1���O;�Ŝw���^[r�'���c�^2��j�A�W���c� |�Ք��sp� |�|���ǒA���)�׺%�@�Dב�uB�ط/ĤDe�PyK��\M(�\-����NɒA�����/n��{�%���_ ���[MM�Z2�+��Atw��iƷ�%��Y�d��	/Չ&oi����A��'$��� 2������D��%� y��O���A�C�.�Mg��dc>T�k���GP����p&oi��*���,�5�M,�s���z�(�GM��|��uؕ���cX<����D�8KA�a�_$L1�Sᯐ�c�u���X�3�G�7�� 2y�{�%�(�=Ml�LAr&�T�|*����j� YG���d�C>Ma��d,�_2�_�Ihm7y�au���5�y��ڹB�]�WE�W*�(���4r�D�s�AT�c��n2�F|�C�:T�9�}�/əŃL ���cƩ��A�7���KA���P�ʐI_�&�����GI��3����u� H~��Vn�����s�Ad�F��I4��rɹ2�p0ѕ[ya�8u^2A�3�%��R�f�K�"(<rƃE��6B�-�`�oE&� =Laΰd�}P��,�⁲�Ή~,(e$�M��IqF�d,��'1Lq����&o9Lq`��:��A�׹�?ڣ���e���*�%�AO}arӏ[!�����-���h����A4B����"|���-�	˼�ɺ��-�H�(��e!�g\�����MXNS=$BeB�*��nD%D���A�?:/S�d��~p� Y���g<&�1}�{�[�{\G
��-�H�H�$^2�ב�onD���/�!�/��wd��"���2�F�J*�%��h�G;}����{�ALBLA���G��-���謦�j�E�, %����*ZЬ�=�J�X�^��梕Z˻l�:�^�Kd��
��@T��WOt��ZKf�awy���?B�uo�2<��I��iY�7�@��_}	{��Q���!��(��x�ث����Ur��C�Ml�����$�t߶�����?u����R]~ˮ1��p��UED�)y�G)�l�=�S]2�W�J�&���ʨ���3��۠*��u�x�:���cF�ry}��U��y%2����y����|4��Yw�D?}�wO���Z� >����Ah/:&%
�a�/ɓ���� D��63%
[��D��dg�;�h�ˏ���Y��-{��h�]�'��yz��v���suM�O��>��۠��_�6� '�����W΄��D#>ګ{}VwQ}�_��&wkw�!����վD�g�j8�D������=�S�<��ڋH�����"����l2Q�)2}wwJ.��:���׬�K�U4��������U�nG�W	�-d$�M���?۶�M.��      �   �   x����� ���)����8�.̈́,K���1����k��问�����(Y�������c�t恣I0�f��8C@Ղ�7�(
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
      x������ � �            x������ � �            x������ � �      �   �  x����j�@��w�B/���gI{����-�@ w����j���Vo���:ݞ��sffcX�m޽��t��z1<�\>�D5bMZQL�I�U�����:�۟�_9�n?�n��d\l�#֑*�ċ��>�4,�/ϻm˛�Q\lq��>N��8j\��r��<�������6�4؂�Y�$������܇o�/o����$0�I/�����c>�3��f����/�<�㜛Aϵ� �����V��?�����%�n��A�T���T��*���/����
��D�@��()�y��`�g��p�)x�C��p�c���Wj}=��.TK�`Tm�E�-|��� �>Ѝ�(5�I�]�M���i�o��lt<�DG�eCc�>$�5�*v	پ�d:�7�W�%���m���N��ۺ��Y�X<�w�v��y,4&,*��<G����Ѱ΍xB�_>v/п���w,VV�H��� �7��Q�      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   l   x�]̻�0E�Z��(�#e�b�"�T�����]�A� �e�~���5Is�(a<����Ų	�� /z�4<#��r߾��|h�e�,�Uͭޭ��� �mz�      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���            x���M�l9��׷~E��N$ŧޭ���Y�7�3CO��wD��ތԕ"�i�[UO)�B��V�������������ѿu|t ���_�����c�:�����������/�?���/���૏�p�0��������������G��mxdh[}~�>fC�_���7�_��.���� ���Ǐ������۟�����?���?��������@�%�����@����ͽ����O��@z v�=�?�S�ce��h����%��_��������g�_�!s��������/K�Ö���$^����>ޗĳ���`�x��(&6iS�<�x�������[|嫡��ڎ� c��0�0D�vh���A���`^~p�/R��|*�>�Wނȣ�h
� ��*W_~X��ֿH\]J�^�X �}�:����_�Q+]\!�� @nO�?��&{����a��O+d~���Hi%T�d����7�����Ϻ��L�=!R�djI؆�r"+�J�h���$V���
�/��ٝ�6h���"_�9��/H/!�������=�	���|=��Ef)����i%PC^��W5�b�B�����5��&dL?��rg���qqu9i��?!&MBw!}v�KO��b?i�t�j�@e�� j?�݅��������@�y�	=$k�ֱSV�U� ��J��]!���&`�I)���+d��!����Z� 
c&͆��b{9��+��5�@����Ա'wn�V��J�
ѯaƑ啔:�a�zLV��s�4��sJ��6����/�6�*%��
_��s̕{2J���k";�OM`Vk�͝ ����R`��n�m�>1�XZ!�ߕ�JB��2� ?ńJ� ����>WL7I�sd��_�8y�?�R�t�H��&'��7��NL�(��ސ��7S���]�������!f�wyʉ]c���W�d���a�<���&�A��Cl;�[̵ľzUa3��iO�T�d�kG�zL߄�{��Ŗ�X���г+�6�t}�c@EÍ���i��R����U�j3��i��G���㈴�E�b��s�~���1r^o ����qw��3�N7.��ܖn.l�@������Nį�~��d�]B�Oe7�=@h�F'�Su
�\ ��>%)qS;�M���E�d#���aVk�zX��z��8�p��{\���
w�h
��@K;�,����|��M����]W��pO��n�/�{vgs��b��; ��3����V�[t��09��y0���i�'o�k��'o�@�]v<�8>����<�;�-O?�O&���x�~�N�!����Ri7�C�!49�Ƌ���ᑙb���l���{�r�� ��w<�'/�T�h��}N<4o�����s��6>>k�>~�G`$C���7�����О׌����1݁�!*��n�Y����y��!ݮӧF��yI��2�E�I�(����,%�{�r�2Ռ*H�7hG�d���m�]h���`�}��B�g�A���Rp���X~�=��-��<)o�vO!9�≝��J1��LT��ov����7�x���&���}U~�=��|�t \�T�eOᦚ���זɐ��{&����:�Е���h�G>����ΕBn�S���v�
��"��bSQ#�s  �B�lW4��� R�'N2e�5]�u.��nO��Yf).�j�!4��.�t "�w��#�:
ͤ��H�a����M
?:��d��ª����0����'���N�q�;�v�S|�a��	�i�`�P��z=�gkAs6�/�2vu���o#;�U��@aj/��N>��U1}����z�EefzO���CN��N~��U��c���H�+�A�Ŭ���T��C|UR6�|�R�R��p�(J˗Z��C�+�{�f`㼔:��c���:��ÓR����h�<���Աh���ucf�"I
c�:߷�ȣ5/�Zt;�)��}#�}�C���`YU��+E��5=�)�3([��#m��k�z-�P����$
�k�Sl�G6S�
I�{�Ҋt�<����{�-�y-u�oK1��9gޣ��W
�0������"Bۤd�P������2���
!�.sv7`��Q��e>�M� A���4���I�����ݘcb:FTgS2oO�w��8
��nf�9��b��`8P�,�| �6vi��pDۼ�|�,ײ���$�l�q?��bD�24�t���&x��=��y�����n#�PR7)搋&�eW�g�=P��曑��ǜ�d��C�*{F�����\���L �?>2%�yt��"l�Ĭ������;�f�P���&��x�!^����q4��B^#ߤ�|�y��9�&I�zίp.	^vˋQ�y��B+���v�\�R�g�)MjM�*u,�d��[�����JD�*�C�
z����Ǒ�nO�r�b�t�)8o/=��?ˬ�\)�Q�n�k+���̮��B�"n+%�����t����/3����S�]�(��2�^�F^�i�v�.2��P�Y�٤��_Bp���I4�K�K�V�zle�|	�j��1��i��a?�e��sxE,�e��yb����Ւ˫���9v�1em9[MYE�.P3��$�lY� V{$��K ��`�|RFi�(*v����P������ye���p�Z��Y��Zv�����t�=J;9�b-�R�:���וR�.���B�,�t�ɺ	-��1�x�_TV��)np�����{���BF*��w;� �W��f�u���"+ŵ�ì`L��ֺ�+D���tw�Dy#�;���0�%Jm/�\)�Bg�[���Y\��H{Z(�^��yR����b>�))�#��R�����~ �=F�(u�Xa��d�C������@}9��{���^S�������R�l:/�H�Q旔Jon0Ojɼʀ�b�Ȏb*����s���TFוW�w�<X`����^8!���RѶ3^��ƯȺ�n�������,��Eu&clDҭX�\!���Swc�.ځBd�G^K�U���WRf��H�7���2��gH�<j�=P��y�:w��=\V��D�R��X)t�Ϟ�cԵ��E���M�m�J?�Ӯ�����\l)^��--�M�m���lw�G7��sf�r��(�Ѷ��1W=�!�~� ����9�ʇ�9X:���UE�� �}��\�Ft_�KTRu}��w���+�GW��k��J�@z5��4���r�`R��ˮ���BnF����񁥹@m,�ѢJfN��~��D!�|a�u��
�!�\H�1�n��DA�i��̥�=Q�sŬ/�]j�R��&@y-��R���_C��{�"��I���ԋY��<sC3���E���k)��b�Y.��t���5Y(��y#sb�\�:ʵ�)��u��a�~ɯ?�|4�$	���}��Gx��M���ꙉ�t���3�}�#���=�4�)�s�k�c���	�#T�ɞI�y�ŉ�;E��9E���i{�c�՞i��@��x��=�|[����n�s��S6N�Q�vLo��=2!
��9�=�7��쉉W�q%t��4��}���Pq=1e5ېe��|��?��1>�����Im��̮�Z���3���l)�8(G�fלN\[A��S����)���VP�e�����h�Ȥ좢�(s>�Y�}��!e��r��a�UV�1S����
�R̯A�T�8�� u\)��>�	^U��f8P Ds\���������0��m?Ҡ��J
/�6�vnYZj��'JNd����ϟ�6�v7�{���r-�R$�*���$.ZA
�T$z>����z�}<���	/���,U>QtΗH�(���U-`T�w������Nl��� ���th��GX�"��@ZK�X��ף���}����2N��ػ���4V���o(����S��^��3���G��z
_G�G;��.��D)�&4h��(���x�,�,4x�`TeH�^?)���R�cR�h�l����R|Ԓ;�����U���\(^{gka��ŀ�F�	Q��y�ʖ�=�.��*se���-�F��
���    #�+dx2-n�'�,�$+��܌��C�C& +���J��L�vAY�������(Aj���a��J������	��5&�fR�Զ�'�L�wGa˟�,� x=A�I�4�]R=�~�Y`�7�f���V�d���`bO�K�eIa_)�^� n!V��B��:%.���8(>� C�J��
����2��:��b�N�O�˾&B\(0CU���?.��i�`�, O��Zj�ŗc���ɋD}��u��@�IH����y��y�y�`=r�P~��z�#�����N�'����{����I�]4�+����ZN2�[I�YH/G����}��4E�Ҧ{��S�C�<��R0����qe;)�X)�h')�Q9ǐJ�NP�ȍ��Zv�����c�R�؟( �%��(P�	W
z�^�n��R�]z�W�5��>_�Pv6�)��ǋ��M"^)��`�;���Z�(��KU|.@�ue�`��L��|�F�!�51�<B�<Q����+ ��&"])���,z���M'�Ė�Ʀ=����q?OJ��(`�;_�X�h���!�[� ˪��tJ`A���e��P^8P��-oQ��D�V���f3��͈R~�e�ŐZo ҃�ﲥx�gC�����}�^��2\�c���|iRl����|ߪL�i������c�+�G�p��Ȅ�L�=�nj9�
y���hǴϞi��׃���,!��f<�I�]ncyȁ��������|H}@���=��1���'�=��1�%Lu(�@�^��z(�N���Wf�yk�e����=GJ�֬�s?FP�o���Գ�o�2� )�R����o�����-ez���<�:���:��CͶ�/�s\'���Lo$7�?��x^����c<n(I�s�� 綎���t�o��������� �Eީ�(u�.7d\�Y:�c7i-u[I_(�z/�~j�k��|P���:Pج�<�>fy[�O�'ˋԆ����ёg�W�q���V��N�9)��R�'[��E8�@�Ԣ+�Bb<���By�j�Ph�x��x%�wd?)�a-�R���Sȑ[y#��a�qhQͪN[io((:�զ������$.���MQە�dowʜ�e%�oDwUR)�i��#4ow[���yjԝ}$��C�����ֲ����V͝�ܒ�|k�U�P4_��Rˮ�����M'�=�J
��T_G��I�(��L	�x��E�~�(ׁ/�ewKQ;��R�(��ꪥ�7n��t�u�ĖA�xMV.�V����ܟx�|�ьYG3��(�:R���#�b6����)����P�����|������\)=N���I[Ƌe��B�s0{!I\<)Q�����/*'��b~���2�6u�X)V��F�.��=P�ML:7b��+eF/Q�GȞ��M��P�FEv�>���M;P�i~�+^@(rT�Vʕ�2��ߠ���h�F�n����NzS�M�n�B�s�!4�.���7���P�a��i��o���� Nǲ��@1�N���4M�s�D*�o��.ú��[[)��n&��-ot�uO���(����
�h�����^A�
��1s�5/�3w�Z��r������FK]Ln>�N��H��抂+ŧ���5ճxala�p���b�}�q	�2#��]:E�����r��$�>Lѥ�e�7])#<`��E�Q朹�1ד�?��>��R���6%g�b�n���W�wͳr�sP���J�h�A�^�_��ŧix(c��b��;Q�97$� ��^�+�<��:Gޣz�&wZ)|50���9[��-�ۗ�E�@-��WJtv�-ePb��y`؉bD~�
�>��Q�xC̳�Y��]}�ףHq�i�������A{�i2�%m���A��z��T�[�g���>���龁���OH�L̩���f��zb�g��t`����h�j�-M���q`�݂�����UKӉ9}Pɑy��;��L���NL-��80���S������Cc��g��5�3��-���=�{��� 抌�v3�F��b��<�Q
K��u���mz�\OΓ}D]��-�ai�R_ 
�������>�m��>��<�'�ӝ]��v��F�c	�-=ap�1�c��Ov�P�ex5��u�w�?�?����}/��������G�}��2�$���������@��>=e�OUc���H7�&d�M���-�o��u �?���]����=�>k����M A�#�[`�|��j�}�(��ݒ� �O���dO�ݒ� ���)1��ǹF� 3��~�}u$w���W��'��#K�	���=��0k�֞�D�~�d��|p"}��	=��21��?b[�7��/ꖨ�D>����>���+N�_�����������b�ZE��o/�u��?OX��VNm[ߔ�~�����z$)���o�UF��d��j��Nm[ߔ�gxB�a7���.H�� y�.ƣ��v��o����s�Y��Pg�l�h����'���л��@�r>k��{6q���DN�o�@�Y�<r��s3@糷��ԧ.*��UO
Ĝ�{HoT<u�Ǭ,/�����ӧ\�P+�=}&.��e~�S��/$��
*Y���m�pt:���||�D������uB_)ru��q�Y��U�H����_�I�k����d�d��=J>���4O =��?@������n�.�`�@�n;��ǧ�g2�Q�k>���9)Hf�>�Kbd�}�}4.}6q&�䠂cj�g3�2P���53E>�_���x��;�E>4���S��r�	�"��tX���J��y���	�[�Ǐ|V�ynn��ç�8mG���?.,mKh�}�"f�|VP��&�[S%ƃ|V������[��^��c�Ǥ����w��KS�UMo� ��J�zPc:Fu��)��ij@���M�+%ދ�&���\�j-{
ϑ���X�"Px��Ȕ���1�R�b��K�b E��vytc��i��2�:�}�^���RW,l)v*:��Hq.�YB��ׂf�����m��N��:��V�T�S εY'�y�-u������J��QB��FC�$҉b^H�� ʵ̕����ocD��=d�T�se|1��rhz
��eV:��\���[��M���c�������j��/���B��K���j�E\)���]��*9bD��h��r�#M�A���R8��VHhb�C��s䧾c�B����x��xɗ��1}���J��j�/o�Ft�
�xsV��gktK�Wg0��S=Ε����eb��-T��Pz��71)����Xhz=F��=�1���t���pd��Ѱ��k%�M��@�R���_}�Ҩ�+��xETD��p~���WJ<t�ɝ|տI�n)�]��R��,�~=����y��6�Eԏ@��Á2G���.;"�t���so�ޘ�GO�-�棯�Z�\!�+Ǩ�'��K�S&�<���Fs[)��̨��C��-HsfC�k��}�|����Uo�,ײ��#+����ɻ�z�9E۟��W�D�e���!}�N���'���zk�j���)F'挐�qV�
��[�E3[��D�c5S�H�9Dq@�Qg�5O��)�s�z4>�9��e������IIWhN볥���F�AVX(=ӑ������ʩ��q�`�#�E���@�����Z�Z�ԅ�M�$�6NKT�Z�S�[���E�^ṧ^�o
�[Q��V�f��,~��q��:�z=k�S/�E�Z0��J7�^�C���I��*�7����M��o��g��u�t�5�
��)���=;9�A[�Z�ԝ�M�Rvsxr�t���@��F_��Zv���� �ʊ�����ԝ�M��(�S��d�wY�Ԉ�ݦ�[��g-��j)�����iNvt�UkY��(7(��x���U3�f�T�-\dU��xM�fҐW����g~-Ǜ��>��~΋¬g��(���y�f0�QП��4���M]!��-�	s<�X|���l�/���h(`kIMѫT�(f�S*Z�z�*�\(��@ S��M�'�Hd���Zt������Y�i�:��VY�J���u!Sj�A�J �  �t�G23��!QX(ԮfˍbѭT� [J�{z��O�I_F�R�]^��w������zR�F�e���Rk]���-�#k�^��b_��`�.���/�ۣ��Jj����H�W���A�y"�i�TY)������z��b��������UV])�z�ţ���Ftw_�g�$J��%u� �Nӻɐ���j-{
t��Y�y�*L?�B��f��!��*)}�@��v1�*�(L,��+�
�3�7M�2�0'��x��G��FU]�\)�2�;��s=o�D���"DWaw(0�t5�ǭ�rD�#�y)u�ΖB�AHY�E��^)3�ʑ�Yt�$(c��7ڋ"�������kA���"�"�gv%���W	ұb�S汍ͳ�e�k�D�
N�#mj���$a�r`���}��/"Ō�����$���E�+A}����������>��⹫g������hW���^�w�O*��� Ϸ�����R<˵���]<��5����\@SN$��w��"�I([���9�������;�'�!������\^�mݯo���k���:�J���L�������2�`�-��������&�����Te2m˓�;쯣o���S���I0`@��>����6@n�?[L$s��K����bz�O�卛[��|`�^����[��j�Ղ^�|Kd�~�R܊������E��~?n��%������}KD@CbKT�`1���=��^��ɋ�o�l��D��#������="�#����2�!zG��~|N�V�n��ś�^Վ�wE0�b7��ʴ�m����S�*�?���ۖ"�$�{�?�����zky��L���yO�/��1c{~��;�|��ν�y7�����劣u�F����];���gm�mh]DsE�y�������&8)�; ߔ蘚�Dڷ:U�D�h�mU�~�>�x���Ep������d��g�)��S�۞`@��� N[ȶ_����Hd�������g$�������3D��U�?���ğ �D���M)�4��w�uȽ��wҮ0���/�Vu���x}��{w�f�N�I�{yO�ĭm ����/�.��I�[q�0�w����V�&c�TK�Ⱥp���>�{r�g���m�|��l�mOo����fx��^��3��L�3M"�[��z�+:wW��v�G~�M���-5p��$��@�o��ǫy��n����^��n�ţ6i�y����셒��w��E/u��rO\<��<u���MEpg�«-p�UN�rSĭe/�*L�[��[,��~�����)��7��:�����b7�3|��hx�nh�[�x7����-�o����DvsǓ�'8�$���	��'8�쥹��7Op��~��^lp�xP��c��J�4mG{อ�b)kG���qb�v����C��t�SZ��z���	WQI�6�*�E�.��8���A��g����O��9���n��)���d�^��v�_Dn�o�W��[�Q8g�kl2�t�/yph{��[Z������ǻ�݋'����x;�{Mo�^��w�p�EN���W��81���W���A��厥"�1�o��Ҹ�,i��D��i/���g3�	l�����^��(@W���"I���DA�J>����=AHURצP�A �I�oJ|@�����S�0�P��(eA�\(��1?�;���WH�>�*���ܣP�91�3Y����1�ՙ �JI�l|C��p�?�󬒔����>R�������|V��.��5�+ e!�r�2����{~p@��G��ܣ}�����$Ԁ���^� 6[S�,�|Kjc��.{+�s)�oi/�j}�t@�g*�vC�y`��*����髼��=����~B��i�@��\�I5u���Ѷs���5�����٧�?hG�y8ӫQ"e��W��f*�;Ԙ�)�'�(�>?Q�fC�}�H8����e_�+Kx (�s������ ��`&H-�}��AN��YZ�΁�B�y�Q��>/���y�j� �P|N9D˖�dt����3\�Ԁ~B��0k�b�"���8���F�+��������l)�᝭�)e��G7�F�4r�,Z��H�q�XުB�c����CV:��x�kؽ����~�T����W��R�����Q�f��wX�!�������w4?z��ek����9�\���{�/��ֵH�/Ҟ�d���ρ��;vj�R�=��l �Az$�̄KS�d�B��c��z|���R��9A3R�Ԛ��>����y#��
��ٶ�	�i8i�U�2����V��-�{4��' h��W��������l�x�I�?�����i+�V-�6��6��g�B@���ڀ��zY�Nj	R�"8A��P�'䖢�-'0�?��sF\�IPވ�b��=O��v%�rO����7";VH<�m��NA���2�0ҐS�_1�����0�(X<׶�h�u1C���\(Q4aF->E�~�T.��M4���m-�˷U��d�D"��R��]uKr����7Ȉ9�L�<Ȧo��!>�	�v��7BK��;z"����cl���e�gҳ��i/��>�|�nBX�eO�/��Q����/�D[!��mk�� !�O�odv�P��-i����:����[;M�J�Ȭ��@�����j�x��W�+z.\KN���P��c��I��'���a/h+D��l�#Qj���P�����1����R��P0�C�w����3l�-��@��%S�I���%#��s\)���{�Ԟ�o��}����Y�v�r��	�/=#�恔�Mx9B��C�;��z�� /����&)�!�-E|��L�;��`+ +�<��>J$I�y��gL��&Z��Е����i���͟k�q�<�{��s��(\�`�J"������x��yI��(�u�=k7�!���.�� ��o���J�B7?�ǽ>Dp&���X	ߐ�hM1��;F��D�X�/��Î�ԧ�xf��s�\��������&5�m��.���D7�:X;������hs��)_8_���(��vd<MR[;�Z�
�{V���$�S�ht�P���	ßK�:�p���_��.����C�=P���ث����>|����I���a��q��n�;\[�Ș�ߛ4�l�&�iH�:�u��9��jY�m�a�	�?!�����?N7Ҍ      �   @   x�3�v�twt��sWv
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
νg[��;���ދ=n�;�5��ˑŨj��y��]���.�>/������x���=O�YZ���fi�ϋ�7���d���>/�>�����Eמ������՞�g(���'>��Q��3r��?�,mH�yƱb��-<��f�C+�Yڰ�7�4<�B{��a�6�y���k����,m��"�ǎ͝G^1|� �GR      �      x������ � �             x������ � �            x�ŝK�#��EǕ��d��ÙZmj{�7��5ҴW�ڿ��C"�̬����g@�*�F���?�����Co���;�:������-�7+��),��B��??�������_������������Ʒp�����a�}a�VN_��?�-��������_�����r
�2�S�Թ����t8}.��t� [:���t��CP'��4��u��?�
�F�Bl�,|�.�]�a�5���`k����2�5�����t�Ń�����P�'�P��&�P��'�P��A(C,�@���P�X'�P���6�� &l&l~;-��o9߁���{���Ạ�&��G)O1��O1�R�b�:�<Jm2�6���̄�a.���`z�T����!?1T?��^VX[l���Qb/_s${�~�z����)����nK�������rF'�]��W�������G�孲�����Ϟ�I ?��w���?���?�<�;��$�{5���%x{5?�v|��~�	�9ŏu��#��"�� �T���A�U��B�O?aX�4�a��:�=}�#��'�0,r�°��K��j����RX°�m�9�넿�_��<�Ă�d��#���t�J�Ͻ��e�;a	�8��s$��d�y2	r�B��L!A^'�� o�ALX_3a�*h]Y�uߒ���]o���
������㇜~�l����0���.����vyA΃;_wV�:���Nq��Gۭ�d��E�r����o�n������!?1��r�����-��?=o#k~��W���F�y8�X��W��:g�	����o���<�v��C�a���}x^v�W�_�umo��xU��w�k�*[M5��*��Fp�R6ƥ�]��L�#Vec�J��1Ưdp.��(���Q�1�%��pc<LG�����C]�K��}[A��$n�n��۠;�5f�&�@�1"�A㸵��w��>e4akr4a�1]E�&,3&��ЄeL�p�˭���p�����m჎���q8�ǳ����6�}޼�c�[���.G_��ރ��M�.��]A'9���r4��]�ƃ�{��Q�^��0����Ec�aש@c?�9h��� �1���
4��۴��;�2�����*4�p�r4f��Bc�*4j6d��Шِ��A�6f�݇$@A��Y�����p|��;��Z���������;|pnh�DG�8:���P��d��y`�;��O诖�G9�����B{)���������֡v�xKK�%ܗ�'��F/[Eݪ���n�ئ�;wއ;�ۛ~N�G�]��~I��k�Y����%b�������7���)K���Z���g�B��g%NC`��4��U�4�����K��H��J] ���ivq��B~���Jc����tɡ�J�y�{wG��n�n�`��٤�#�ݍ�"��wD��������¦!D��( �4S/�i�^�i�^,���6l>D���j�f#;�;M3�-���ܶ�gSFв�Me�XV�)6��*6�cT[Ŧ$ak��T)�qm��k=�������wt�G=]�I�F��ඊ��u׳ѵ^�ltm�ְѵ��lt�w9�xѭ� ��׬���.��=��}�EZ�8�$F�����Iϛ�L�;�����٨�C
���8,����-�t��!� ���p�;����;��&����a�'N�!�1��mپ��x��N1`����!HR�����7�G%iOJ*>ӛ�4��lC�a:w�]'m)�r�w��b�H�R���e��p�m�;�Y��w��l[�βmu8˶����u=����pn(�xk�rN��pCf�����:8
7d���(ܐ߯��pC���9�28
7f���(ܘ篂�:���28"���(W.�.:���Iy8"�|8"��pD&���Lj;����pZW�v�#2y)2�������9� Gdr���d������u8"��pD&w=���a8{5_d��~��i�m����p��p��p�}8
�e8
�u8
�m8
�]��D,ax!1b�|�dT�.GG�A���ǔ�to둞�����]W�]'���w]�:jQ�&�hL����c��ͼn.G7�E�fr�*F)fvO1K�c�5�&M�&����ԏ���<fo��\��<���
�����:��t��+h���"Gw�U�N�l���\t�t��hS��d��ع���������c�������hx�r4������Dh4<����"G�ᱪ���xlr4j6D���2|�,���v�E�H�����u"�Ǔ��i�r4B�����,G#���h�49!MU�&��S������d�m�h�x����5��۠Q����z4j�ה]o�F��sqEh�,�)��M֌�5��۠�\�I��-�{E�_|���H�9�y=�+B3�=���kOr4�z<lV�f^��ё�@��0��y8	Mt��0����a
4ѵ��0h�k�a(�D��P���=��@]�U��P�M�N�����roCT��!��zmA�f�6��Y�-�Ѭז�h�k�r4뵹�W���W��M���5]���������B�ګM��{�����s�T��'}؋��hx�r4^����,G����h$�9I)U�&a�K���H���>-l4jVל�5�kNr����5G�m�f^�5��m�f^�5��m�f^�5'4o�&�����A3��r^�;��1۠��-����fr4�E9+�%9+�e95k.G�f��ѨY�j4��}��mᚔ���Ih$�9I\�*4�ң���$G#)cGcI�.G#)���HJ�j4�x�M�F��B�����jVB��h��3�(G;�$G�Y���]�n���AW1:S�RB���R�>?�s4jfA�F���h�̢��Y��Q3�r4jfkN��m�kkr4�z�U5\�{��$4�z�SU�f^G����1�����h���KU�N�+�� -|��v����x�qA1߷�/�����|��l���;-9�<V5�������e��pCϊdj�J29QMQ�FTS��Ք�h$%����"G#)����v���hLĴ0��~4j�״�����5Ǌl�F��CE�A�fy͑"۠Q���h�,�9Nd4j��&�5�k��MYY���VzE����H�9Iq����r4��I�FR��2Iq���/r4��U���r��m��HJ	r4�RL�FRJ������h$�d9I).G#)���HJ�j4Yӥ495�eM�S[�����$4jV���U��Q��hԬ&95�Y�Fͪ�ѨY-r4jV�M�x�M�F��f�z�z�'�Q��hԬ����(G�f-�ѨY�j4��Kkr4ox_ws?�&�veR�K79�7�G9�7�'9�7�g5�j����7�F���~��z=����U�'G���j�����E�k�/�R�<�*hZ|dr�Kw���ԋ����8�$��x�Y��T~��S�ާx�����;w��Һ���u7��	�m��p��#�_C>X:X�Y����⓻s�+{j��ɮ�c�F��|��hmrt��
:��t��;hW��)�C`Q�F���cLz�1f4j������2Eh�̃����2Eh�̣��y��Q3�r4j�FӨ�����t��pI�1��H��T����������Dh$e�%B#)c'(I;A��H��	J�&�����DhԬ,լ�ѳl32*{ir4jV���� G�f��hԬF95�I�F�j��Q��j4~�^���Յ��|C�'��m�HJ�r4�҂��4�����h$�%1:�0��"9w�@C�_B�W�C�ߎw�*&QP]G���dq���4�4�2��½�&<��I���\Bz�����Wx^�����mq����t�SMC�:]�;_���	���tV���T�"i���5����~�����K�KE��w�U�>�|E75���^�ǫ��ﯖ��J���l��^�%�2���X^F9��Mn�E�=��]�F��x�~��oV�:�1Z�����u�LU�� p  q���v��~v8����G2nO�ֳ\��R�=Ў�N��r�uvD�i��OC$^�0A@?�4�����ٓ�!*�<�@�,�5�k!/ڔݲ�¥��w�`���t�7E�\��GD���N��a"��i�!
�4QA�i�§!�z^f!�m^��eu�"���[f��if�X8�1��]�$D��j�]lZ�	c��ޚ�\�����l�)�
c��=�m@�T��"�Q3ee! v�iO:ang�n�|�:O�G�5іs�����<��y0_�>˞w���&��8c�2��{f������9���UQR�)�XIQ��A��'�%E����p�h^��]��ҽ����ax�0_E�<� ���pֲ�;�Y�R��TK]'bn9� 'ؔF#��/�ip��X �3�s��<�y8�|,����cLW'�9��x��E*8���e28
�;(��wP8z2��pte2�A���d���љ�|��7��
Gw&���L�;(���p8��,
�+q8
W�p����L);��Rw�#2�� GdJ��i�d5� Gd�2j���[��������L]s
�VpD����L-;���朒���L]s�VpD�v9<��<b��|rJ����S�����VE(�}�&��]�.���]aW=��nzv���l��P��M�@]8Fn!�:1�ÂjԳ���Tl������Ԣg�-���hKmz6�R����q�K��2�]�������r�_�����$�azkc�+:��%��W�'�q{�^6[&'��ir�FStc9y-LB���5�nd�ӵφ"���{�$�0-I���j-� g���p6�-� '��|8��Vv��kou8���v��ko]g��v��p}�p�4T�p�z����$�gl�҆r:MV$�}WM�0z����a%S��y������%�2�l���8A�QN����=n���(�$��E6{��t�Q�r4�.$9�g�MIYp5���E�.	ͬ˂�|_l�o�ӄfV��`��8�|�i�yW�4��4�Y��5��7v��F�8���4oԸ_��Ds#�77�xA�s\��5�C���CJz��/a\������v�]H��y�e�P��1VΧ�$G%�� 9)�����*D�+�4�EIE��R�ڝ��Sˑ��z��KT�)�u�����FE�rRm򠤢MnJ*��QIE�<)�h�g%mrWR�&/J*���]�"�|>Rs;��{G�|�%*��MIE���m*AIE��)�hS�J*�T���6����MŕT���	a쑐��Z�a��;�qL�p����C�v���)�����(�2	a�nؽt��5vH��!�b}��.?�-^��4/]��7j5�Hx5�Q�D�kZ�|�)�|�&�V��Yn�TX��A��C[��é-���4�}�\��x,[cK�_^�Q��v��OO����'0\Gy=n��O��'��2r<_�i��Q����2R8>B/ˎ�=��f�e���<�R�Ka�"��������-�Ck���[�� ^��4хn�Dz�� ���4х�y��#0�OC` �2��0,��"����!sc��4�AH�����#0̓OC`��2q3���w��慱��e5*So�.�7S>�Iw�9��Խ���T�ppj����[���;�9���J�^�����4�fqM�4	A�_X��\n_����1��wל?��]C;��r(%s�fp�3�Cc�|��6뼳�Ց\�6�g�^<s}�n;��d^�<�y�?����!-��GK:&��uLD������"cVL�Z?f;y����~b�Z�At;]�]m_��ӹ}��[v�t����2��S�ȳ�.#�zz0[Xq'���2�˿~����/��+     