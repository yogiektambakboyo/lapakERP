PGDMP     	    2                {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �              0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
    public          postgres    false    204   e\                0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   �]                0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   ^      �          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    206   �s      �          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    208   �t                0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    303   V�                0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    309   s�      �          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    210   ��      �          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    212   �      �          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at) FROM stdin;
    public          postgres    false    214   7�                0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    315   0�      �          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    215   �      �          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    217   ~s                0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    295   t      �          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    219   6t      �          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    221   y      �          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    222   :y      �          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    223   �y      �          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    224   z      �          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    226   "z      �          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    227   ?z      �          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    228   v{      �          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    230   ��      �          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    231   �      �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    233   ��                0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    312   ��                0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    314   ��      �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    235   [�      �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    236   ��      �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    238   ��      �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    240   �      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    242   ��      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    244   R�      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    245   n�      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    246   @�      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    247   �      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248         �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    249   q                0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    310   �      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    250   �      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    252          �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    253   �&      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    255   '      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    257   �'      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    260   0      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    261   �0      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    263   �1      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    264   
2      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    266   �2      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    267   �2      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    269   �2      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    270    ;                0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    297   �;      
          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    299   �;                0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    301   <                0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    307   #<      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    272   @<      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    274   +>      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    275   }>      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   �>                0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    317   �?      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    278   +�      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    258   {�      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    280   	�      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    281   K�      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   ��      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    285   ��      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    287   �                 0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    289   5�                0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    290   R�      S           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    203            T           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    205            U           0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    292            V           0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    304            W           0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    207            X           0    0    customers_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.customers_id_seq', 794, true);
          public          postgres    false    209            Y           0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    302            Z           0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    308            [           0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    211            \           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    213            ]           0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 1006, true);
          public          postgres    false    216            ^           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    218            _           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    220            `           0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    225            a           0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2209, true);
          public          postgres    false    229            b           0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 514, true);
          public          postgres    false    232            c           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    234            d           0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 304, true);
          public          postgres    false    313            e           0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 32, true);
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
          public          postgres    false    277            x           0    0    stock_log_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stock_log_id_seq', 1282, true);
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
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      �      x����r�J��ת��T� ��RL��He���VZo�2mVfe�c}�y�A���):�8�o�K0����K��l�O���������4�nw7Mo\�h]�ޘ����ƺ?7�Ϧ�5��i�����_�'��}n�^G�ڸ��	���5��[QC��7�?nO��A��6>���,!�YCX"=������g����0��^�
׌�jQC!�����k�;gE!�D�ۨ�;E!p�g��#��q鍯��! >�ó���\����d�Aa?t�5�~K��*�( D�K o�WW@H>QC �3�?���ݙV��x3���� ݍ_f0����a��=���A���k�������5��Ά��4��"<=\]�ݝ�w�5����˻� ��o��!��O�����?�&a g���?�"Ļ�܃�!�_��K1�Y;�5�������7��w4����E���݊�78׷f��q7z�#���;T"8��.N�`n6��_�H�g� XC����asT�q?ވB�n�O�k�ms7:���b�������x���;߈B�~`�Ɲ�5���[�w@;n�D Wx�}^ݸ5��\������5�z_lf!`_��������x� �.�B%B�8$��`�<��)e�� �/o������� ����ux��G[n�.Nb���ۧ��/<����iُ���EA ����/\�dn�G� jB������~<3���a��L��h�T�h�"6*p�� u7���������Q4O6=���L����o�sؿ��$��6�A�����z�Hf���!���{�ZP�&GtW����(j���6�b�}HA%��h)��ToG�!��c��fS�]sf�4����dɸ;ӈb���n�Ǹ������ B�!��r�c<�_ �������v����	�ѵ�u�5�.\�p�b�����d����#�5�&NG�}u�����	�od�XY>� ����aS;�>Ķ��s���T댨!,���6<-����zq�\x0.|��k���z�q���!4<��U0�|�j��2�q�1}��(���/ަIC`���O�Su8]ۏ��W{4>7絆�������>���-.���q5���?ޞ����ɞ9�	L��祲=.ޢq���5�|�̖��҈B�%�����l�=_���i8�]Fgۍ��uVk:3��2mW���@[�A0t�~�|u9YKg�N� G�e����]��[O�5��u���OV� ��ʃ����b�A��?6]�4��L���5�}��>^X�.��a|�ܺM�kn�f{��μ� �~!��R�s��-3������5����o��$��ׄ5� _�((a(8Q�_�n�^A0np:Q�8�g��v���)��5����"~���N���t��Z:,	X�:���~\������}	���ӲP<��y�Vk���_�W��R��!���ȠA�w~�z�!����x�-;z��:`�����'`�229io1���h�qK+j��yߪ����9��7ïa��y~�����iw�<|�wÖN�~���q˽Ĳ]J-���E�jo���n&���<�nӦ���~���q�9���[{{ڿ��������G��K!��0�D��l����\I�!��u7�(�?�\�CvRq����\�Z�H�6��E� [)M�8��D���Z�"y��G�z��bޝs>6�,H���� YjR:��.Rz��H�AH��ߋp1p���!+5������i|�@b�:�]~4���5�v��͸{W>W��đv��8�[�R�8(�:n���{�-�R���}�f���OĻrYjH
��>n��LJ�]:[� �ȿ̻�%�]�,5�Ó˽?�Hh�� �Ծ<�t�BiSp���b��B��K��-�5�:y�秷��)�-�5������n��o���GI�]:�Y�HB"�����Ճt�-L�A �j��ocD�ȿ�����3��� ��������������ĤА����D��������2n7W���^z� �@����c�yt$6����R�Hȟ�H
�ܗ�ebD�A ��П�S��PZ%]�ߦ�-��Y�D }��p���jh>�j"I�����K��5���;�)Wr�� ShG��z�pלq�qPL e�i1:�C1Zڥ>lw�Q��F� ڦ>��\5���"���S}v���@�A �c�Ͷ��vevb�A |k��a��Z�0(��u�9ױɶ:O�A������~u]��YjyTJ}Prxs�°q��1~���ul�}��d���O���6�2������o�a%Gi�iGq�U�����G�6�&$M�/4��6jW^y��A^����і��q��tǸv�qP�x:|������a!?�r.����asn��gB �E��� ��A�3��k�!T��%��ҬA����/���I�����N�H�L�T�^� G�g��6k���/[-�5��B#j�ȏ��q�3�?7�ʢ�Oy�A�=���sU��ArG�y�5����?���&U4��Agw��l�>O���ppq�������f��Rk���i�>�R���j��h�{����ɨ+��k!7z��Lb>�k�|?�|e,���a�K��p�0I*�����\(��9|������ͅ6J�P�3j��sr���Z�� �|o��躔�쭨���5�i�/�Af5�Y��I�8R����"p?�����sېG=�s+�Z�8<ߵ���I�*k������޴!v>JDuN}�AD�Z�m�߭L6���b6iG�Ib�8B'j�W��_u%�5�������Nx�#.�3��p�f����K�:i
EI%��B{����*zj�v�L���c�#t���Z�0(P�s����EۋiC裨Aa:�~U�0�K�{Q�ڼA�}�Yo�7:�3� ��+R~~���y�Y�Sk�P%����A�=S"g�襠竁5���h^���X��A �GzX�����̩�5����Ԭ� �l�.O��1���m�_(�Z�Z���G@H)����^�A��T!�ϼ�Z��5O!|�v��@���t�CS��gIq�A��:�
���eQ� :�k�"2<k�7t;m��Ί�A�ʕ�V�� �_��i�����2�đ�IUge�ۤ�3V�ZG����WM��l�U�B�P�qnS{R-G���^k�S�V�o�~�#�5�|�'.Ѣ��"�� r��QΗ	Z�l����LW3y&���M�A4~g�G�3I�m�%�b8ww�s�ap������>�E�H�A |W��j�!mn�S��� ��z:�?���/�B����Sw�DVC{��a"i�|/7��i�t��D�?R@�-�/z�tw����m�&"!/�y�*��)���SkG�#�f�W3}j�ٿ>>����b�@5�����A�{}y����=�5��i��g�mu�/4��<���=j��d�[Q�Xx��Q��BF�&�5����*�D!�:�?\/����˥%kHn$�|��g6j?��k���f��L"�i7�| �!4����9�^M�.���'a"��Mڏ�\�2�ery��
�m��t��4��<�*�n���4���i'_Ůl
ܖ�Ek" ���J���~
�4��K�޾j�9Y��������fs��k2i���Ӌ� .�œp���WC��\�����EL��՟!Y�hЬA���y&TI�����Dp�.�:���_Tk�_A�|g"���� �p^�C� �\z�~5�p�檄�B�:��}R!�*��� �~N1�N�}�Q�5� �DA"J�^-]%�9k���u��|�ؼy���&��A ܺ�x��(�W>�� �7+[4�5� �3��A���_v���o��A,-;�_i�A#j 9���Nȱ�w�Z罿 >+Hk��)"2    M��D�}� �5�f����H0z�Ώ���a\S��
��Mi"%)�����T�ٺ=�X���܎�~��c۹,�J�)4�����}��?~���~�g�Ayz��x%����ͳ��Đ�6}U�9Yu�C�A9����bp�l�V9v�!����� ^h�Ս���Q���l�ZkF??=Gy$/4�#��,]��d�7��8�J��+@:Q�@rYүA람.>s����?Z�@�M��!�p7k bU�Ph������w�'�w4�#L͑4�Tl�U����𤻓�j�mv�_� 
l�䰍�A�f��Q���E&��D�Y��tF�̎DA�r��]_2�괕B�@̊�����be�<W�V]]�_h��熩��Cp��x��^I��/kIP�G��������c�ܫr�ئ_|�g�����Q�Iy�
�D��<l]�f���E,4�����r�JJt9��R'�B�[ ��P�H��,��J#�6�m�li%I�GTh	�Q��P�]l��.'��f��jDB���K�\}�*4�!L�M�9���N��\x��2U{~1#h��U�B�x"w6��G;���G#��D׋D�O� �g܈���. u�6�� �X��b�W3>%��z��bU Vh�>��O���wm���5OM���A@�w����/�ƛЇH��D�dל~�h�b���p���u&Y�[�5�������H�i�Si�A0a�qs�qt�q�� D�?��8�bU_Sh��>��BcM]׹�	O�����*4��Eκ����d�A$������n�!�N�*�G\|�g�0�|B��c��u��>Aɵ��LXh�����jN�l�/vQ����6}���>䓙Ԛ߈d�b�����s�Y�A!�j��:h��]�6M@�l����_�5��|����*6�9"��B�T���Q�#6�8�a�B�H(Rpï�צs�����G�V�����&�|
mܘ��ܩ�L�&��v{|!��T��[��QqK��\�!���sn�nx�!��w����ĩ��Z�]&�󤜐s^�F�1q��AwSr�KY�\h��w*�a�M5��㷛��Kr��Y�T�A hXG�W���p�԰}��D�a�5��hH�W��@�lBUSWh'��ڎ��i�.h���� ��}Uh�˙���2�R�e���Nu�6���Z�8x��mG݌�� ��o�N��/-5(,#���K=~�q�-.hHϽ�tσ�Y�0x�������f����pt<�d�m��Y�8��/M׏)�"ވ�B;���
������� g�~qޘ5���Q�"�t]��[h�T]g�Ѧߍűb� �VLa��*R.4#oRuBd�ڦ��O�p�J��oM�9?f�4�}<;Q����Q�;b��9�*����T��"� ��~��eۈe��ױѶ�b	$Mi�x���]� �[���y�m�m_h�z���d�[Q�0���n��,����� ���vE�Ȗ�lu�_h%���QEmۼ'�K� ��*�(�g��A�`��9mX�F�85莠l3Ty��qp�F���=fC5��k@LS��
������Ws��ƭ� .�N��R@�5�#���;6k�cW�A(�͏7�.��q����i��Q�W������M�c�l�Xͪ)4�#�͟�+k2�J�+�5 �7دX!�V��
� ���+B`���ua���U�4�Y�E+4��[W��o�j�XeID�#�V���������"M���֣�
"i?{%)A����
�E�:/�`�q�^�$s��Wq�B�H�t�ɪ�����ړw*v�ެA�M�#��A��o��MS1CF��r�
�S��M 5�K��^�p��<�К��!t�y�tG#/뙾�!�./�am]�IP�!�qz���Ta��j�Vh�$L��������}߾�v�l����ļjW����>)4��rw��I�:�Q�nS�bփ�SJ� �7]���v��� �<�jDP]n�Y[�`�B1����V��h���*q�*	��� �ګҮ(�f�������U�U� �
��HN�ҥǱѾj<ShH�eg�T�>d�7U���׬�7��,R�\$p�h��,�|R6ꫤ�B�@طnǽ�&�����zPB�A$��K�{�F��#�4įI+��^�Yn�&!׺��a��:j���Z*M��m�UX�� ��bU������;iG[�O�2�QE���_}|SU?�ѺU�! \��:<�W�"�Xh��u$]u�Uh	G\uCN���a������܆Pҥ@�mD��s���QWݦ�^U��v��D�`���C5���M��5$'dIc�$CMd��a��[�5�aP�u�0���X�w��T{�8"�8�jk-G+j���7�w�c��3ke|�ebwS�e5�����0�>�I\��Rh	yԷ��)L���j��A �k��_�f�s��ݔ���]*kGϭV���dt܄�Q�Y�@ȩn���d�[lTg�h��X�e�LU5�q�<E�A�n��1i�^=o�{�$�.'�Ձ�Y�@�Z]R�1g��A\��YhH�P~e첵h�A<P�A_Q�0��V��Ԅ8����[�p��ڹ� �І�8��.kG���R?���m�LY�8��q��s�Pӈ�#V_uّ�6����IW�"�E�;-I��� �0��T��Q�@��WEd�hʨ���t�M�^W���N�H�B�Ph��s�:S��X��*4��#�k@�An�ް�������.����� :�����j�$�hW��U�Hb��� ����E�M��Sh�_q��6�ޅq�|�J=#��n}Xh�Tߞ�������冔��R|�5��꠻Ad��:�B��Ge/;6���! �3@�����M+j	_Uic3��s�JX�H,��;;� )]Պ��1u��<nD��]m��[�U�u�A$!�S��hX�H&i�tc��F�*0Rh{�U$�Y)&"���k^�`�Z�B�HȿO?���n9��� ��4k���|��xo&a�:|�����đlT��l��"$��е�q�W^��T"يD��U��hŉ���AU�IVSS5��C/���E���v�ҕL�B���7�ZO�!u~s�Ah]��,0x���4w���^����ۨ���ũ>_�A�������A���Y�8��A������ڃ����qس�v2
�s����t1d���B�8���*�����Ѯ��B���Ց"��0Q� �kA�SĬA 1g�����!<P�q;�U�D��V� �u�&�g��5�d�D�>��7V� ��}p�5e�U�A$~MG��hy_hoV7�4?�\l�
�h��M~����/4��� ;�Ɋ��jRG�A �T�����[hH�ڐk�#��UM5>���\f����-4�$װ���]�`y��5��C����l�WۣB�@r�U�01-#υ��wݨ�1�4�%�E�8��z?�u׭q_�|sڣ5��Y�Yl5��v���V�# ��fE��c�U{��f��\h���]�7�u{�BC@��j�����e(�� ��|����l8{&�i+p�Ճ.4A6C�U�� ��E���~oR���{���9�F�u%�n��h����g�ߚԴx�XY�0ص��!�HW�u��B�Xr``wTͅ�y��q�����u%�������v�o�$)y�5��gg=�R�&�a�NX�@880���I�rK?iI�j�%�ID�ps�"-H@�NNj_��(4�#����Ɖ��wq��4��+uBSe��|�izQ�Xrh`�CYL)4����+�d�/�E{L��u�����p�ߤ!\���Ջ�>�	�a�[���bxauxxup��n8(�i�óU4�� ��i]R+4����^�\W��Y�0xz��r�6�5���~�T���M+p�;������|W.�ى�����A��ɍ� �  �H�l���W�nڒ�ŗn�����.�� *h՞���˝=������.���@�&+�D��VkI�5�$�T�zd34�CլA�%�C��$�Eb���5������d2.ǤA��Z{��Nu�f�A}���r*�i(�є��K"��m���ok�!=_X%7z��-?��L�TM�J6Z5Y+5���^�4L՗�� >�?lT��1hG���.����m����A<`8�>
:�� jB�o�5!�d�&�6��P���
��6�<�R�8�g���z{6ꬨA 1�'� �h�64�5��X��0N� �����j�G%�&�@������5{�lՖ�T���� �^��l4�u����K=i��d���đ[V?k�߳�ЖՈ���d��$A� �/��Q�%��ڴ�����b%J������FS��6�-�5��m������D���F� 3ev�e�Eb���V591ui��t����ݟo����Y#�`�CmC��A0�M�F� ��Se���s6�My�K� �6�~ѕ|�f�5���Ͼ>�:�U3>K"�s
���ӝ����Q�_}Oǉ��>HB`ȣ�N�
���.5���N�߯����Z`"�����B���P*5�������
OeB�ӪRv�U�z`H�A|���2����bd"h�R�]E���(XQ���~s���Ա���)5��}�~�!�&�� �|�4��4���nL]�ʰS�!,\ ����7uM9��� �9�_s�2Z��e��� �����|����B�@h�y�걐m�e�O�A�;W��Ahsq�����I�X�'2i�-��0�@rk���3I�ꫳk�A$*����F��¡ҵ$�&|��\̇��{3�ל��&�e[5�.�6G�ȸ66.���Di&撈5��D�l�Uj���j�Th���m\�u�����f�X棔8�A�D�Ek�\xL���/5���8Ud|D1�6�N 2i�gu�ZhP�M#�gǅ�]c[�Wͻj<|�AH��������� $�e=7R��u�&��x�ɷ�EJ�!L���^��1]l��yRM#j��Eˠd�P�m+jǼ1�zCg�6���������4����$/dM�E����5����&��߳Y���Q�3Up���1(��5�r]7�2֎o|�H�]\5�����n�*q�2�Յ�AL=w��}(���>��2א������ps��Nj/;~��ͬm[�E�b�Ŧh��� H�:�D����n+v ��w��[q˟ �2	�� (r��R�`�S۸�G#�dq�D""���D��AD�?6RF�uM�B�u����[Y���.a7����WR�{�/1�Yߍ�AL-/�W1}���o�q��w'jU���i�.'b��7L&C�sA�0�ko�.O�H��]�2R(EA�c���G�m�:k�赩)��DB2_�f�����GjX-"�V� $.�<jBz6�8F� ǥ�'���q�����S:���!�����L�5�)L�^����OǤA4�妻i_Դ���2���5��c�o�E��"����85iD��>�v��i�a��AHy������u�4�CDO���H^�Q������Z�eEc:��΋{G��t��͡m�Z.D�8I�/�7����ԋ��H�PV� "��(U_��UkbO�����:
�:�+F�f�uH�A �o��Ч�%�m?��cS����1kS�c>d�=�`��FZ@)��.~�Y��({���|5鋱a��w�t�Ε��A<|�8<^�u1������3va�&��6��1�!��>�F6���u���mJ�UE@�ADS�0�3k��6����讣��DD��e�K�,k�f��G&���� *�e>RH$��.��Ͻ7YO��%kQ�")�>lm
�
D��$�4��"F�`R� �Ȧ[aD"�`�V��^�)7�����(��Z7�r�|7B��W��2+4�S�Ҡ�嗵6�}s~Q�(�ߗ�&Ka�Ye��e�F�>�k{�#�N�-4����Rs]�����a���)�N� "
����uL�RiD O��A@䶇�{���
Q
�9Q��<��x��f���O�Q&��E�D�9"b�a��5�����vl��Ud�� r�ǧ��US��rk��U��Xc�{���0�d�%^���ѵ� �H���q�͸��h���D �h�م�!Js���L\�!}��I��8DJI@�om����}Xy\,4��B����&E��IAI����-|�AD���>�1���O�����U�\�AD\���. 3���Ή�Z\��/5)p޿|~����.4���+}U�)�U�E�A\�7����������6��'�D�O�H@|uw_hH����ٸnܨ^8Fj��\Ƭ!D����2���č��5�|5-4�!��*1���J�,4��桐b��]���vj~Ћ�㸝���|�ٟ?��d��4�G�q��S��G
D��<zQ��x��Ht��[D�f�h�4�NV�b�j�A$䏟�f@i���x`?_�>�LxY���=�a{!���� x�+d��q�� �id���壺�n��M���.�L�k��5ǒW�&&/ٶi��;�K���dQh��|U� jy��y#��H��j�AH���G͙�S����
��g��������5��"��^�(�����Q�@:n���
[x��5�F�� [�_Ó\r��ϊ��K�Q�5�)o�UU�"&�:-��e��7U�6�S�i[�qp�U?O)���b/4�CǺ�e�骉��q�w}Q.b�)�E����y{���f��#aB�22TG~2R�/Q�@h�{����d��k-\Sy�F3U_�A@W|i��>'W�N� �~-F����aĕ�v��4������٤[���a�^v�8�1��<iW���4C��h*����pA�*_u�-4��)
RT�J[Š
B	<9PN�o�mLu�ң��B��Z��Q�5�fX�g���W)oS¿�[��1��&-�kS?���b�ю��=�8��i�iq�ŋ��	Bmw~�D�Mݦ�� ��۾�>�l�>����{���f�A2j��H���5��d����^� Ǎp���Kl�T�J���A��m�*�� ��iz�E�u�A�o_u���j�B�88z��W}ɨ���B�@r������V� �8�R�$C�VF�*4����Ç�f1PK��zm
B� �z�^� r����Ar���M/�M��P�����ji�F�*k�� �kA.hHN_x�|��i��+4iok���oZ�ѧ�F� �AZQ�@�˩�2�3U�B�8"׌��5_b2�����4�G��)O���V���G��
�_f� �ѶG�0��S.�5�f��A���#4F� ��x�~�B�sgzQ�8����t�EfYV��ε�ʧB��C/j	{�a?�N�$�>D��}��f'�I��5�����g�>��IC8�����E�Dz�),k��o������4�DB�u�S�����q�k�|Wz֘ގ�D ��A��IB�⎅�P.�����?���5��l��Ii'2H��E��r�<lߕ��r�5��z��X���D� �+H��0��.L��ьq�6c�vRh�4C�#g�?}+䯒��������<�H59���񌽨A .�{yԒ�� UMS�A$ܚ���yU���Xe�����?����ʎ            x������ � �            x������ � �      �   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      �      x������ � �      �      x��}�r������9��7�QGC��&H��D����4�սp�L��8�i;=&�h\
u�zy��o��~3�����V�|2��i�4N�?�-˧��}����m���ь�f�mx��������^_>������?�ߟ��+���Oo/���������5����_���@���>�������叧�o��ϟ�ޟ����Pp0�q�&b�yx{�x�,�<�� bt(�a���0z�?�y���o���}�(b�^&��?�_~�|�����ח8%_�}~��������)����~yZ�{��g��dj�d���=���	��������x����`���;�e.�h��Ń/�&��'���0�|a`:��W���������b�yhu�X�����<�U������[\���A�7H߰t�)g�91�ok��� I���E��B�������GǞG���U\Ί����~����,>4�1~:3�:�n)Nb�8.��&b�[j?�<����-�K�"����i�WA��ˏ?{��]�]�8���\]W���~?V�"`�'����������o�
�e_i:]F�D���3�c!\�����ip������˷?~>�&�e^)�y�G�-%4�p��i�������Ks�`�r-M�}g��Gm"�2��?�.Af%�0"��%��l��6K�dy��),������+'��.*t:�$&|�W�̸>ڵ<���2�53�ͩ�p���nN���u?�T�S��w�3&`* �Y��TPf����A:�s����7;��p���Q����ӗ�W�)�ȚF|~
���o.b����!���q�6���:�e.m�}V�X�8�e���?�__�z��ǟ����B�ם�������p�C���j���MG�,�f:�g�&�ۄ�1>:#b���땳 �W~`P��f��ϻ}4��1�6O3s�7)`P����� �s3����|�d��olZo��a�ȸ����O�p\�������
���������z{���������?�vp_"�9yš(7����fg��˚b��{�h[\�y�b�7O��b�&��4=���SLa}<����1ֻ���2�S���G�r�LrLp�DN_~��)u���(���⏽p�LǼ�4�,�շo�I�>�����ӷ�_��
��7p�U\-�iv����X�j���e�`r�;��5���?�^��Kم����S�M������?ߟ?>�^�����>2#7��L�72%��۬�Mh���o����}o��op����c��a�!�i1�||z߷�Pt�1"F��	�_�˶:��pѹ�\I1�=O\�Y��_���b�8߉�k�Y �y�{b�N<L%�Y�Zk���s���?�/}#b:�_A�vqޭ�^����xo�0."�_����v8��1:��]����0N�D��)ק�p�
.��o�MĴ��m .1F�l����;����y������v��{U�G�>�_w6���19�3t�r覛I@��~����"�5i��	��2c/k�8��o��pK0Ň:�f�P�^ąg^�%K�H0�+i_k���t�+����,$K�t��$Onc���2�l';�t�M�:;��'^���b(/Ȉu�}�g�!Oj*P�ߟ���h�!�\�qr�����#��wZ��a�3�ud��� pbَ#t[{6�L�q�)%7CB����?�k��)�_��
C��5���Z���c0d}\�C�����~���EĔ�ѝ����+�=���v�H�:��<�;�G�2�"b�{�;����G��4�X��OF�W�����4�w�{1�{z��t�I���Z���Vӥ�x����4����ў�uR�F���p�{�|&�/�(ܞ����r��K����I3���r���y��2�ۥp(*����w$���J���G�$Ƶ��ÉI��_��OU�^*G�l�Y�:�����^^>֪����`�L0abΨ�@&����rj�G�='bRP�ꒅ�bH�Ki� �!��5<C''b����0㬬iV�����"��/���\F�)8-fq��~|�ǒ�������������u�6
��@ �?ȡ��\.� Ni� ����u�u%f�)����֚D��h��2+}^��*bJ��B�:��%�]K0u�%#������N��"v��vYI����nt"���VFE�U�H5)��UM^+��*6�Z�����������CA쾁�q! e:i��Na$�T8tM^C�`��؛hE�d��q��7yYE���ǵ�d7m��n�ː��w���Yy�lv�e=%����Cwk*K����"b��+)�k�����KV��`
��5�	��ģt��nh���	j'&x�˃܏a�m�J�(j�]*������V���|��q�
�TRU��.��"��|4� ���z��&��9&�/�ORVƗ́�v���&O,�� Gl�I���5�c�s�#�0�<���f8�nP$��U���Րc�ԁ�?rq1A�;�uW;4ǚN��*.U`s��!6U��<�4���6U[�)�ti���!Ní���r%��)#���#��r��;�x�u��}��D���ϟ����믏}7��z���k�J�.E����=�9M/��u�5<��k�\��d�!���۷�}�<'_��Ҽ�v��9$�E\�"���4���,���ݕ��2��v��C�k}��*��\ݫ������->�A�to9���DdBx�R*�YM�ŪIk���$1Hh
�%�Ә�m��q���|=psL�dRl�+���.r�}�ޟf�R�ѧ�a�C@s�8����>��W~�O��s[�5+���*}�a��`�����":�|��Ip���w���Q��ՍI�d&e�kFe
�S{�@�1�Նݘ�,��发����UĀ��ў	��W𸆡/	31��zXˏr`�9�"\y�7yz���I�r/#�F��}l1�3`�����.6}O�H�,E��|NJ�ۂcʔ�{�a���c�c�L0:�	Ǣ=9wa��������SgWS�Y4��is��h]ֻ)'�c��2r��`ȱW�˾n��9Ǵa��p�1򹚘��Y��:9&�P�;`�箷��Hl�W�W�ꓐ2+0��}s`�7��_c��G�:��e�V�LU<C�W�,�)���K�)�4�j�l��b�"&���(�&���J;��+UC�T0��@\DL�AJ�x�C��c�i�i��o������W�e��d}n�׸ap�54,,LsY�Q}�����_j~|�.��3W^Cl��̻��kyP���ǹE����8����:1��f�w�5(��Ť|Wr���������4�hS�$"�2yC��E�A��gB5:�4&��|M
�1uR��ƃ�Q�� �����p�Ϣu6�||�ѫe��(���~�#lR�N�T�ϙJ�W6}*k̄<&�����HP
r����5|n�\L#����NL�7�I[��Xm7�bQn����3aN"&L�q�D��+���O�6����Tew��e�+l���b�!��ϐ��R�Y�B�k���/�2�P����S0?��G�O��Z�#8��{ܯ��\��qI�TS��;v�?^gj���O����������g�Z3u�M���m�l���Xp�,C��0i���,m��K�B��u��H��ù�<9S�1w���X�ʌ_m�0Q����KQ%Gr˥̬Dn*��z۔�<Q���I�Db�F:	Qp���\�8�b85�BS���8�������˳7S��񏗷o�_~��G<'��$@�KL�L�;�T�k|Ld�|����8V<�rرD�kh���ᚁ�c���E��s0�g�R|�4��b���jd��kR�`6-�Q�G厌�;��v��-'T3�����L׷C�iN���g�Hng�C2]����ΪуB��L���_猜	sq��g(N�������_�޿>�	Hg�܂��~�X}j������c�X�i���r�ʹ�X3��biYl���=(4���)�{��1�W�$�@�2    ��M��:9� �+�5��H��(R�TF���& %������ǎ�u�תχ^D���x��Ⱦ��v�#�mA��}���}�NbdO/��R�ݐ�l��i�'��àIt����S��(F�h�5!/5��&-�b7�&s�B�İK�>��K:#b�X:qOó 4K�B\������}f>~�	,x�TV�����$b�
«����6eL}���[��{`�T�0 I&��Ӆxԧ��o���8�]]+i)Q�234����'x��7�+��66�W�h��`"��&�������DL�	����O�acC����DL�q�|^rg��˜��=���>P��o��Gy�E�-�g��X諶�lh:�O�=��'D�~�YAf�
�b.�M�"�:lY�^�rL�*g��sFVʹ���!3L-���#~[/s�e�c���ak.�(�|�I�m2�$fΤ����V�$�.o��q; '0q�N0ڪ��/��@"�K6:	�&`����eD��h�,Wu��2p��8�S~�'jiD�d���I��R�����I-B�-8���ǲWI��>2��'pA�Ln=8^crB�b5^��F_`0����h�>�"F�e��B"�A��#q>���χ?���-��򒄔�C�i��=]��:�6*:#b��,O�BV�8�\3��ssV��`�bo�� G�T,,�8�V��"&n�ㅅn[Cd��9-Y�s�is(�,(O۵.n̷;���ͷ�HۂD� b�*�%u�`͹�8��Y-��wIz���R���e�h�q��&I˩�6����Q5�4	�>2z	6'��Um��Kv�M�HW��Ǘ���F��6Ӑ�	�q���5��	v��6pѹi\nt��D_��w�p���:���Z�S�4U�S�I�Q�dQ�ML7���&Ci������G��Ώ|$ö��5�@�6��b��i:'��<U��g��I$���iƥ)$q���u-ǎ}��y�����C�D���!�I��!�\9�M�}L0)
��Opݙv	r�����e��3ڢ
>a�oVcb32cE��nd|���ƅ4{���1�B��%���(:���Iys�c����~𗳤���)��l'�U�Tjh�gC�f�����C�Q��\Ӱ���|u������9��iP�i�	�{ܑ[����k�S'oZrh9т/X~��ڈ�ނW��{R��3�+nL$�X��NI¿o��Q��!��O_^������_�ߞ���x����HbL�X��\�ӗ����Y�O_��zx���~��ÿ^~v1��(�*�(�/4H��t��l�&�������Ȅ�����䋗�y���R�FfV⢯���~��<�D�8���g�4���G�b��t�
��`\�Q2�Ii�β7z؊�s���lh��Y@p(���x.�'�`-h��3��0�Y�̽��q�4��b��ScX���u�[4�DK��db<ڨ}��}N�1u��szkpm&}��Y���c��������t8T�&h�Ԍp�+�6��Ĳρ)������=��"�Y6*6�M�H�E�E��y�ݾ�����G{j�O�c�J�L������Gs��:�����G�0�K1
�7�HW�-�&-:=^��6W�1;��SK��9L�-^�Ne�:f�n��9v ]+��m������m��)���I�e^�k�h��{��X�bt$��
t���J1�ɶ<���O"v�&!�sTe>�.be�;y�l�����-by`	S����Oɐ�뵞��v������C/�8�����
#�Xg~q`v��Rru!��3#s�� �a���|�����n)Ɯ̍���(�^�C��c�|48(-w�/9s�f�"�J��"��S	>Ꜫ��9꘦��X���A4S��e�4-/���'�N�5��K1�`�ѕ�L�YW^�~��Z�X�Y��1x�nU��GnH��R��Q�{h&��v�*���a�q��(-f�@/Q���M1ecRLe\�0��KP�ʟ�X��1r�Fdz��n�ܨ:��'��s���생f1����iZݔ��z��镢 �ۼsu�q��ũ���CHi��du����<����8i���4@� aDL��T���a����q�Pm��8>I�%U�ʂ���*
����#��v.ޣv9`��:�����Go?�7��^����#\���݈��y����Q����7�İι��x`��T|����H4��U\tѿ8�ք1����.|/�?�Cl����X��g�y�3�D��D�N7|�H��\�_�܊91ID�ک��/'�w��71*b��N����i����xqZ��$-A1�}]G]D)��8�vw�T����]Z
�bJ�'Cj��-^�cX"6MmL1M��%a�eCo�����2�V"�����i�c�i��Ip`�6�d���g1}�$�FD��빦{7R{R�p�i���F�jO�JلH�Ω�D��d��w`�(�i��/�a��5Y���O�R��O�_h��"p�R�	����MVF�b�
D7{\H�m�l�I��&>l�`�x��+`�(	�"1� &�K}`l@Ic%�U �2wG����+�h,���XJ�.�4RsWiM�����x��C�S�wdT����aM�I0u&8#C4&�3oX�N&�N�ȃ�;xE��}�w���S�������d5�)��g��M�'?�9Z����"+bZi���u1�%�o�ȑV������T���0%�?���.v�蝭~������K�T�P/�i����Ū�{��k�|�S�2�HP�~K0���1] {��wCMR�x�e�R~��O����Z�c�(Q"��?���(8[D��Xv�l8�����r))ȹ }�49bQ�ô���)����*}ct���1���r�M�əU�>��k�)ǘ[]4U��W�'݉u�!�N�d�HL��!�P;lD�h���t����58�[�`0b��9���1��!��A�Q�9��d�(F'�ݥ��c &ˁL0fM���!Ħ��o�n����6�}�Ǎa%r��V%|�W���.4���S�Mx�aq����'�+�'���cFȩf]��c�D�!	c~:�-w܈�J���Xf1U���C�ok,B���8v~3�I(&�`�Ic��Џ䲄�SJ��.D�\��?DJ8kL��81%��9DH���U.�8�*;^=�9��{�P��X��z������e)��ϧQ��lA��-zJu֐�Yuef�E�X�ZC�1yT{��$?���d���/�~�,�c9~��8�����NC��#��S�"��z7��џc���n6��di�~��r-�G�,�JIjn��m���7�0#.�*���K=a5;cJR8�eF�<`��S��k��g��q�gX!e�u�q�`T��A@^�`�U��������-Y#n�wD�7��ۣ�Q�����T��^���y�/Wbb�Du��1�c�?��F|�/�ib�3ݮ"�^8���^@0�&bM/���vq��i��d	9����h��m*�EL�4;�#�B��AU�6t�7k���Q��zbrZh�Ӳ��呾�1�r3��呾-���A�E���(Y,$���'s�d˱�jI�L؄��FZq
�D7����d�E|�}Ln	qb�TV�M��V��ʞ�v���� &F�n��7���Z�4��0��)ƖX5�{W]aܩ<}"��_�Pf��Lg��6/C�@V볮�j5� �晑�f�U�q�o���9���e[�Ke����*?�4(��%���?e�/�~B�	0"�08A���<�.��8c��8(,��a�����+Ұ�b�{+b=�()�7���2q��3^��sL��I�X�d\{��N #�Ӣd)�vv�2q�ͻ��{`w5��dʓEb�+<���YĴe��'�	"�aU*��i3U/��R�=ϡ	7����)'��Z=�c����']x��hB����Qҷ0q��E�nQ�,i���	V�;oY�X�m��Ӭ�m����V7YR��.jT�J5E:q�s��sϱ����^���l�"�;"�_�<���uVĴQ��ܠ�LG�n����    �:Q���k,o��iS,��w�7j����`yU�V`�����N�3�K�=j?�����S�xi"��5����Ǆ��<&tbZst�@st���M}W��b����n�+��@35�d'��)<�'Fd@��P�z�]R6�\���;|y:"��JjC�\/"�XB�t�O?��D�-��7S��'���u�&�+ڑ7C��}>�)�7'����P9�n(�ĊX�Rq!��CY�a��o�+'�w�:=�U�ݮ�����J�5���H���x7��DL��89���IG�����$|���19���LP��H�����L蓒:E��w9����n����b���)n�$���7C����Ɗ��f�pYHf{�mn�/YS�;��KN7:	u�dZ���4����#N?�`�6�����W�F�3su֒��s����/2�+8b�K:3�ޛ嚯Պ�^Cq�EL�֝�iCF$ӯ����"b� ���ޠ�ʬ0�T����.�b¢*R�a�^z	�H>�ޚY���[U���Z���E�3\��
�)\˭��F'b$ˎ8ʺ��@uҘ��8�"��+S?<��S*��~�֬�X��.�d�e+7�W�k�O�iϛ�-;���<���Kq7���D`$�s�^d�)(�|��U/]M�{��*b�n�p�19HW8F¨.w�%XW��϶{X.������m�I�N[�m�
���mKF+�8�I����r`J-����,������"F3��7ڲ�mS�-[�����T=ȣܼ1�uF2�%����s���T��4�~�Ю�1e��hi����ř�ŋ���O���'�-��ش^���5��y���IUD�`�j��:�c���Le_X�J`�1�6�Ne�k��`��*�8u�\(�����0+.�� ��"(,p��d�]"��=)v i�����Ϟ`�@#��=
��<�5d��F��wmK�,b�$<��tZ������#ǔZˌʬj�p+�$"�n�b3��*��AB��A�`ݏjCǑ�1U�FC��>�Hb��q��b��Юn�|	�p\-3��m�Brq*F�.�'F��Xh�	�Ya��0TO��)���@\�1dBy��D��F�ޜ
O�vT����b�.���.Y@�u$Y\
i��G}�[Ej҇缊�+���XGx��o u��1v^xb�B)�e$9Zcyąt��1�`�t>�ԱæR���~f��Y����
r���ಂ�Sjpx&�����+=��k0���{I8�=��|7]��F�a������;�K�z� Z�l{��5"Ƅ;q&��'�Fǥ�*
m��6�;�:9�27	��쑘`�2�D;>ΠHI�{Bs��s�6o�Pi�3��,����&B&	F�3tD�᛺���oו$�F�VN���s?�,I0�X��y�B>j��8���@&X�� �_������}�w���:RK��|���Y�`L���cҌ�������Yʅ\�Vd�z��<�Ƈb��}6������m����iG��x��Գ�`��p�IS���D�3�7�D a-O��hD���}�W���2Z�~��jD͖���fK

D>�oS5���Α��k��)��,h���:-��m�#�ˣ�̗�j�#Ia\�: ���Y
T���Tc�f���w�b�I�h�L�-ԫ��"&�%�S3kSs�h��."�O��lڽ^�q����z�0~>\���K�P�59�zDm>I��^.�����>�V6�ǗM���;98����
=Zt4��p�Xj�f1YR4&��W"�2�����j�l9��������C�N���p�dK�Q*���ćbK��2�fÏz���1AL8�N�=}6�Q&l�'��88Ҍ��L��lI��t��_�2>�w�S�U���F����l���*����^��:i/ݢs����#��1,i�*m�x�KJj��o�~�(8%���*�	z�f��tzLiQu�>��`�i�X��U�M�Ko��Z>1e�T���\4��&��R7�y7Gy��Q����?�_�
�N��D�X�`SyAG��31�n���*f|�k�a�`-��U�����2��X�pOL�d,�EXx���L21"�!����ł���8�1m�6.��D��z�şcʵ��f&�*WJG~<K�ȭ�{����s���1�1'\Fn�d����$�el��Y5:�`�&b'���eo�3���d��t�XoлU��R���K��p�yä�vI����ʾ2��v1��=�����9luLUrƲ!'r�V��	���g�X_���5l�y��>�LIJ��AI��Ȥ�p:F}��&b=��B�X�'T�r�������	�����:���i��@N�Gg����.6M����^]\n�gĘLN�]R����h��N�#�'wq�W���(�j&�9�޽��e���k,Q~��j��g9-kt::���
)��K*�����#-��M>�t�8Ԛ=W�']	w^��:�$��?�S��c��ge:�9��;t�9��r�e�@f
W	��'G��B��B�}��p{�����X`���;���ֲS�vH��L@���:Z����@JV��R�6�jXy��`q�5{	'X�I�ZԂ�.���q�`��{���t��y	��Q�:��&�y��}��\K4�z�_�3�������v���w,���2e��	���V|Q-(s���=���	t�G��f��#=��W}��+JŅb��`���A	��4X�V��qs��S
�P.�!���n*?�E.L{S��h^Hki���GgELeH�!o�Gg#S6w�Ȍ�J�E;�p�*�-�b�He�2	v[1Qv#�(�؄������M��K���=�9j9G��=#�s�����܄=��\�&R��~����>�z%'�M�~�]I'�|OM���~�"֑�?�-��hԝ/"vC����7�V��B	s�O0�
�;��t������>�l�G�#%�=e��k�H!�+,��"p_>5�G�b�a��9	��B�I��Z���7��9J�q��5=k2���gɩ�̠>6wd�2r$ |K���'��~�*�A��d��%uK�.�,��[�6�ܒ�Lr
��V�����bq�-b'/��Ž���e��t1�D�l�6�����i�ZO�y���reg,^�ͬ"�m�0�ݼa��`�|�İ��́)<����2��+q1"&���F'UՖ�B��"b]Ba���'�*Cj��*C�dH ��r|bz�>O0��	�l����n�������.�Br��yY39�SZ��7R�^��[���l���]R.�Z��;jA197�K��C�m1e��*�G'%r���qSw	�.�8Ɗ�VV��.:��2���
��/.�1��i틍�ml_T�-?��܁	���e\H�Wy���NyX �����.����^]�#'���*׭A��##�n���B	�!��^��&�ؠrG䑲S��E.Sq͟X_=��pât�����{b�z��r�a�\�SgZ
W����`.��_͋o�[�(NL�=Ý�������(9�GP�[Ę�}ɍl�T=+|�+�i"�ײ�<�|@=`cD��׫�6�j��zuh[�
�Vk��y.�!&V���$%/�>R���)9��^XTޫ��X��;4PGR@�;W��i2Ռc�?p
�Ն`���%3q�я�Չ�3e4�p�u��F[D�d�����_�޿>\>�_�tTFa��F!#��Y��3��'b=9+8��Fby���"�|N�)�C�O�Ϸ<���6� ��#2$�C��$-?VĔ��AZq�S܇��7k�y�ص2��˳�D����}��e���_�D1�p���,�=��̄�s"HZ<�X��<�	&��F�pO�@Ap���g�Z�(�$b��8��0gCr��2�\���:��$�6^ɸ�
����̊K0m�$�ҏ����Z
�em��ɨ�%
g��㧿�>?�u�zX������R3:v����G��>	��6$\䯁�T_め��� }�>��P�Nz,�9+�K0e �S�>�%s&ڝZ�r�b ��������A38�0
���O[DLJ�:i    �t�x~\S�x'��T6��l<?l^��`��|S���	�ʾ��.��S�u��3:�V�4��D�i��kQ��Q��T�w��f�������k�?������41K�,�`�YrL ���С�F����:��5��T���y�J_~|�s'}䯓;^����I�@ƞ����R�~�Y�D����_;� ��D:6����#�+�DL����e�/�h����t!9"k"3�����Ɛ�U���c��Q}b��HQG�#X��� ����7����QR�V(9R����S	%���B%�Q^��/���Ai�v��L+��<�ANLS��$����,1m��)5�&bʌ�XH��HY�]<@�A��$)�2'lд�h�1�y��b.��yq\[�|F>�S���I�;G�f���ud:i�I��v��	������$4���EF�%ZK$ :���U���'y�؉�\;A��q��tPX��yE8�t���+FX�eW.������6�G���`�J�kR�OՋ�Gb��BG>��� 6j;9���Z4�C�A�6���qnJN�����H�XgF��8 T�W��r�a!��>���E����1v�.���)>ؙg�G�C]������Z��E<���这�ԊRń[ܮYFo��I��\�D�JX�.o�`=͌�@�a�$�XM�|���L�<pb�7
�x�P&�<�"��)�WQG�m�w"�9����^�	�����#��A�2��>�FC���K�\)���?J�gem���h�bs��R�b���+B��1�`ʬ���\r���^]D~����E B�÷��緟�Oz6$Y��� 	�TRڹ�䱠��k7�4�ڔ�[-5�;-L�:ܤ;)���{�R��	��CE*`ZR��@I��h+����L�H���u��0�d2c0������&]����<2�
W�'��=+��.2'��ޓ�����W�̈́�z>��>���/����75�~�"�#�;gA�S5��8R��ISI5ȴ&F�dV�ǁ�,�%�X�0�T�TǮ��eSNFĔ�h�nc&��@�d-L�ŸXm�8��"�	�o�L�ó�}�Sօ���"�gs���;1	T�,c!�:�p�#ǔ@g�=��)d�V�\�s��ژ	֕u&�3fD�[�Y�f��	�8~ߒ����\¡�ݕ�(b
>g6.�xU��=�I���:3)��Kbw�CԔ��X�C��'����tMA�@<���b�7Qf�Lav���\����1>SɱIA.(�Uv���+���MLw�p)Ԭ�9��Fc�Yu݂�*�7��S�\I b��9���i��e�*?M�����Q052��S�(�Y��6R��FO�ut��|H
���|��1eڼů`"�][�sP¨�,
*�E��)�E"�����q���+0AW�bĴ��KЦ�6Տ�%T�"F6oA���U�;�t�y|`��yF�xE�{}�W��DLۘi�Oc��\�i�)�'F�R^`���I?G�E��pFn�V�*��;�O�U�,8qU�U�#Y됫�d@~[�{lQ�n�IǕ��� g����ԨXɲ!�dy�E�i1��_��F��u�;T��U+p���
�8hcD}t`�H��>T�*?����L3)&�!9p�EN��߮^Q~�9�fJ0��"ʝۀ�"�𛈡D2-�X��p_'1̎���ǎ�Vbŷ�f�%(qܩ�����˽"beE	��B3���P> �hK})F�NõK�Al�M*�Qnވ��%�s�t(Ǟʖef%�%�z�m�.�gQrvg��	'p�����F�6�ٚ�L�&�H�����wӴI'��M$?���W��(�3�"�ѱ��F��*��3y���P.��w&�u�䦁2e�#*����@ҡl��V��鬹G�Ą�5-Ҧ�T�	|	eI b����w_Ӹ�1��V��_ A�a,o�H[�����nea�ѡ���0S��h�$��݊�#m�+k&d��q�����ƅ�n���"bJO�Bnd�F�m�ܫyb$�Dt����x�k���L�EV�\�<��HՏ��w�m(���ul�̄@H#gРs��c�~��|��n��z��
���'��?�_�V�u0����Yq$�!ܟ+�'XC�\�#�X�@!oi�`Lp����P�򂪓����\՝��X��"bZ�����9�*bM�{����G\���	�5�qW�E>���4�|�ga6[�K0�v�~|����k���U&W$���q� X�F���o'p�'Mt��0�1PrI�����۪uV��6�c�q#Ɯ8�-��Qi�~G�0F׏�ҧ۲��Su?�t�4݇��_u��ܕN�=�qc}%9��	�|4A��;�����V��!R1���s��������y�� n���e���1�2��7 1e�����8�G����6��!�{�d��n��Iͬ6��݂�1��_�Ov�dE��CF���+�{��Yf��j&���ͫ9�h�"��Pja*�D��kkÿM��V�)�"e\]�s�Ӯ����;��e����=>-�rZ"��������
T֐��)�׭�E�M����>uX�����Մ�+����a�u��#�Q��S�'�S	jl�N�:�[d]{2pq��s6�'�F��:=(�8Y�{J8�Ñ*b�#�S������-������$���/����������M8���?�21f_!^��L�Y밟��
�މPH`&�]�?�����?�_��<r"��l|r3Ug���2�L�
��dp1^�F	��f1�5s��v���j�,�|ҶW���a���_����{�Ɏ�IW�g�J��ꉘ6�v��v1���f�,,����Ż�1\V��ڜ	�V���t�j�`����^��Ɣ�"�sk�ب񲖂I*ݙ�?Umy ELi���%n%69�*�,��d�x��TO�|��)��&��m��*z��rǻ��[��E�9�X��c��q1�]�)��p�W����1�3�p	�z��W�F�-��}Oz��L@�B���r���i���4RL��UW�%�l1U��k[!�b�<ڠ��Z���Y�x<>�;V�oad[���􉁆��I�f��Q��"6����!(�!E��KS�SpY�R���SJD��B?��zb��{O�2���j-�߯:�l�ޝE��5�J3. ��I���p!	VՁ�����i�C��$wөR^lnTg�T���R2��Vm�\�2=:'b�)r�yd��g:��&Qp�D�]e�JZG��`շ��5��]l�^��C	�1Î�T�,�.6h	�)�+���~)I�������܌3=*W�������)�3>`u��]�����pՆ_�LV)�>-�[v[2�0�:���%��B�6��Rrķkzk�U�`zm_�ES��`r{e*%Gʁƚ�m"�BH$�:Hr�F��Ca�)�L0��dœTSʫJɯ���9��.09%�^tlJ>KJ���Yz`��$�aq�i�1�M�e}��+���ϟ";f���;�4����.��N��C�,=1�X�-ɗ�q	�R��)4�"&e����p��o��8Ԛ�:O0RRHdY���BTgX�G��8ߡ�\z3C�[���C����R�r�5�Ж*�6.�mۥ��n"֑�C��E�dr�pT�5b�?ė� �
Df�{S�1?�+]��?T�؊�R�t6<��nN[��]���D]I��B�`�/�LiB����^ݍ�[��&��5Z���)��j�slV��T\`s���b�|��e�H�T�"�>�,�9���U��h�ʦ�IyG��F�(�H�qʺ�&�2��L��8i�3Ͽ�38b�
��� :#V�W{��]$�V����2�Uan|�a�� }�3�5��U��"����%���g��&0���	ƏT��Ĕ�%ga��P�^����4(D��p퍙��z,_R�>[���ʰ�I���/|f\�ɷT�Xn��XO��e��r�V,;�^E��D�N���k���)�a��iU+���̐5QL���#����jz,/��6Wcd��    &�S��!��&3)Ȝ�8ɟ�\4Z�&m-Z�����rh�Q�#�I��J��&��KҊ�*������Bfl9��V[�s��D����8m��M蔐`�6ڡ�f��K��:��6�V	8m��9�Io xS1��깾���	�*����̶:}��4�L۽b·��E���.IG��Aez���;0}��BWYg�������X��n�F�:�٘�<���]�Pz��=0u����Y̨�c3vD����B1�P6k�e���w�K�����R80��e������|�)+9�Q�N����U>ҳd`�ʁ (e�#�Տ�r�B�=���y���:k+��<�8(W�|-�e'��II�:�g�w��Hk˒B�S9�|�
��*�����牜�S1���<�i��r�<�tb\T�?=���T�,"֓�A	p�2�υ������q|�z��q�L�3�t�zJ�'�V����T��T��� �58L�V0 o0a�����B��F������ju���i1��O�6���<B"v��4#�nw�l�utb$��5��j��kl���bA\��kB���j���j��?\��91��u|h#�K�o�9|���h����_�����BkEń�U����cB���_U�����&Dʐ_u���1��K0e�1y.`� +b7%�3R�쫋Tgbz �,��A���������zL%#ɗ�ǅ����Ib`f��C�ٴ�e�ue������p_�v�z�iu�	+�1��Ə�yU�x1�p�����GѺ2�|d��)֘��S��qfC�o��L'?�X�3�Ɉa������b���W҃_�T�
3��ʯ1M0��'{6�Q���Zn������&�3�����s�)H����h�X��cr�K��Ӧ�_�,��]�i]�����mS��'��\Ls-f�u���K�:��g�,"Ɗ:����]�ߡ��ȑE���R�V�:���0��E徨eWYX��oq-��L�Ԋ�H.��J��Ԋ��u�jE쎬hF��?�B%��b�F�3��-L-4�o�;>9oI�����3�f)b$m��4�l^����y������]��Y��t��1�x����92��A��+ߔMn/���W����r"�,��gA3���g��|�Ɩ�gRLߤ^��x�ǝV���Ł��1����?1Ş=��s��p��z��>��*b]������b|r5��i�q,h7;�^�~�9�FJ�F�a���%�F�D�v/�)�+ϘwG㍡��8@P=�b�uXD�ѱ����Fg��íi�n�u�����uSj�����H���1�Q�D�w$��҄3�*{�Ki�Z����`�Z�A(/wY�3�Z^���<�W}�Vl����X�%���p�N��au#��Mvb�p4�B.��RX�'��$��~szo�FÇ˸k�B��������%����˗_O����?��%�
�vg�B���uĸ4��T>M��t���N����X�k��5)��"u�˙�+��oV��M��˅1ei��/2����c��֐��UaOa.^n'�r)^r�8����t�P�9�DdG�����j+��9��p��yF�~4xykF�C�Y���sK�zi��]?R�28�]���DE�d���XwkK1�8�����0֘5�J1ɪ �@�f7v�I�����%K��PQ���dT�p���YLٳ:���q;� "���}��)4�V��h�	f㖔s�ez��g�x	���ikW̃�_.�NK��P�C	|�	(�ͪHR����U�g�����kx`���>8?HOC����K�oC����1mB�:46�%�|��פq5Fo�q58��qE��i?ЈO�A������pg���Њ]���?E����g�Pb�x����vL��,�3/؊Z+�fm�R��[lF.$w��{�"S�G�j>��hZmֆ>s�E|`j�	�.�U������r ��C������b�ɍ��&I� ��cy��RA�AENE�"��a��j����g���1���'�A*�y�:����k
B@��	�U֕�D+��kX����j�����u,�L�z��,��G2��YĠ9��h������W����*;f��f�D�Ŧ�c��z��Ŋ=�;�V9lT����o��90����!���F����"v�C��#-��/���ޤ1�~"�(���Ŷ�4�(bu1���ɻB�ؐ�[iZ\ڐV�1��d��I�ѫ��/�#�#\�K.*C��M!ß��a�m����;j 9�ޚ1��&S����(������Ň��p���K��>�)�H�KD@`�Ȇ�7�Gi�R��]'֑�H��.G����v��h2U�5�_�Q��Î�3�E�?�L)�ԋ��,bʎ�,K#��q�.&75�c��z�>J�sNG'9G�*Y��������*�Z}��˛������ǋ腫6Q�����E~j>�>��p�iP���]D�ӣc�?�y���Q���!�2�Xk-���&[jO�����
��@�$�5��'�
��L�m÷�Rs���R1�Pt|�����S3�ꏴ>9�:��ёUC��Uc�[�M"�liMD�)����'6�T�j����1�K1��H����7�-��bZ�ZOÅd�E������I��Vr	��šs`%dL,#I�75��iE��7�
����[.��7FW[�q��\
�����"ig�)��'��H��������@����
�))H���/�� }ӌɾ���0bFN�F�� -4O'�rQF}	%�f7Gx���`�%&9�\��TG��fฉ����1>褒Ǖ0��
�7F'�c¥�2����{�2�r��Z^�&+�I0��nX�$����\�LE�Ѻ�����5F���ǉ������v`��C��j&���d,<v˯����wt�F1Ϲ����L?B��V�ޯ����MNĘt9�_�a>�]�`P��X��<3������Y}�(����_/������Z_��5%:��$!*������'-���7��q0�R?c}iC�0L��^u�E��b�wrVY�I�7AA�6�̞�@�-Q_�w���\B1��x�de�Tk�>����ѝ`T��;�qId˕��*k�<1v���Q{��|\j��K`��(sn�mhp#��$�L�҉I���MPU��F�%@͉٩]9�Lx���Z��'�r���U/ÎY�~���26�t@*�M~dWxKOL+����knV�Xuo��%b�U"����5�:j�y�
G؉ţ����/_��8�������R�L��M�?K�r՗��É�2���qE��렓���~��'
T��w3K)K0�(�(q��kv��E��ILr�U!�1�@SQ�g]�֊�m�Q��U �O�������"��"�Ԑ���c�vg�491ވ��%��ymD��<~fq�o���}�f�'X�ד8����T��u;��:B��7�09.�L0�?ȃ���k�[rG9���z�o5���L��}�^���0W�&�����:���*��"l{�h7c.H�δ�0Y��zN����D�K��t�� 脅Ë�Td1efN�)>��|��V3���IoD�%.��0�wm��̣�����r`�k������\�\y�7�Am�X���Ԗ�"t_��R<�Իx���	�Ѯ�}{wU;�����u�sc'���ǶY��c)d>&��^����;3�J0q�97Њ�2P:��8֔������fd�����"���p�_���n�Q�ˈ�4"x[i�����-/�%��R��f��	v�o��rfT~[y-�ԕ��
���nr/n�{$��IXm���c�ѪǖS6����I�juM�ъk���q��1��a]�!g��������ţ�D�5�{(�Gu�BZ���m"v��]� ����q���⍁�yjj�e ����u�tX:}!zL�=�-a+b,7�T���Ѱ��0�"��b��G��[�tN�f�#�[�,���S���s �  Yߒk��z�p:p��,����j=1m�%nb���E��5����¯���V�iQ�yt"֡2t铀��d�ln�Ƥ�I����K��;��bۿ��/�܃�i�8.�y6Oj��[V��`�R�۳@��zӻ��L�9�7���cr���Aĸ�>�W��)�裈5g��䨗�e�M��f�
|W��.�ԳPi'6Xܨ���Ώ���E���v��:Li��dO��ĚFNIe�yG��X�D���#p�\���D��*q�ZA�!shޔ�)5CD���>Ņ�1�V�H�y�"�/RNn� ��9�Kt�.�Lġ>{�3d��F���%[7�Fy%-���8���Q�7��6t.�`'b�W$ ���m[r�Wj^3�`�L��WFI���H�"�?g)���Tv�G��řw��'��J0>5y��!ܫ�&u
&XO�G�X�8�Z8���bSj����4j+�����_�	�H�%�!	yV�ו��	�RiI1�F3K����]fH%X�}�@�v[�v�eT'bj;�r���K�4��˚�$X�|�v�EKdH&o��]ߚD�S9��1�ū����jV���8��r��-���B�2�(�p�����p���f��Z�i���p��#V�㦾���͜���q�:`AVi��ªY��> �zp�I}���ܺ=��X ����Do҈�,�.a�J��R�.�Y+�w	]�7cZ�X�w�*/]�w��5�P�qu?�����m)�D�s��o]����":0��O���mc�[��6�)H��qŋ��nK"�_���%.cEL����`������ d\F�0T��>p�I2'XO#�g�7Fe#��#3���OZ��	��66|�RV�`,�c�IJk)/��/��B73��R	�4��n�}�%K�K0u��'G�@D6k>�4T�9W^�![6+�K��b��g�J����)h��@��������MvqQ�~]pq/Y� �n�O�|�������R�M-�?��q����@��i(b��@OHC��� �Q��k&���Xr��l�,�`<~ڠ >]��S�"����[�����ǠV"<V9�p��]Qq�Ɨ{]��zN��1D�o�k0Kj�h!IO@,�cs�87'�^]�n,Jfİ�^YɑF�w:���1�G�9v�����c�I�y-)�ۼ����"1���x���R����r]L:���H�/�E�6�#�>��wSVL�潣����� �1�L�$?���߲�Y�i8l�X㹔Bl}L���r^�??�?��y����qi�k&��`�ƥ�Ty�M5_�������ݓ�PYE�~R`����g��2\�a64��p��E����p2��%JyhV��]~� pu�2��l���(�!OG	>8�7W������`�a3���SS�E�N�����}z��쌈�԰s>�� 6V��Ԩx9�M`2e	�	���q.�`L�/0>'��v�n(�/�΁UX�S�K�kp:
Kj�D�����צ{�9�&�� �1���} 	�H��`=���=L�aJ���"�7��є�ށ��#Ï����T�x���Y`2�v�5�3����{.`y &���9��`�B���o�r�-[�ݶ=�{!����@�X"�_]h!=������q�"D����L��0�4��\>�Lkd�d;�s��M�`�328�w�sD�Ƭ�1Q�vRk
h�L�ҹ|_���X<"NL)���7�X!]�I�����o��sԇ            x�՜Is�6���ү�h�L,u�n�{����H��Ћ�xb���<����A&�Bi�h�9YR�c"W$蝹9���Nixg���������wZݘo��7���O7�?�������_�^�$=��6;�v$֎������N��M����=���?|;ҏO����_��k�Q�C�Cl n!Z��"N����{��������ǧ"�ݨ�;�F#��uܙ�S�&�(�/x���^��w�ǁ��`,�p�����w̍� c|��o�'`hs��2����[��+}��#�����EÏ
`g�@��� -1��f�%�
�Z�(�EkIk+�,|>�Ċ��w�O�㩉����lR��j}�Z,6�$]7a��Z-Y�̈́�䩥zVaf0�E	�NT�W�`��I�5H� O��6���V�51j�"��9\��Ri���e;�뚞��c�k���A~��������凉#6��vm#���&{׬sKFA� �`��b~�E'~�/ۻN,�:�'�{�k��x�7@[�qC$C����F����R'(�D�1��8,?���$9>���_������ �C7�1F�P�>L��<��Q��c��N���>�q��_�#�G�����cĐJ�@��$Z�59㒢�Y')y�d#iKVH�ؾ	�"b�h�@P�][�^��K�FL�A�s�=�H� __�O2�}B��8�t)zU�C��R�q+�u�Zje!E\�H3���d�ÃB���"��s��}9�ōl��ӭ�2ۚ��º<�I(���c�N��4��#��
$�k�R3XJ�kD��^����C�C�	s�u<��#���
!�>`�����E��k�E��1�e��(X[r�ɜt�R�Ⲳ?�[�/����@I�vQ��u��cw��$�Q�n9PH�x�ȧ���������� �f�K�o����h%vY���_*����@�P��"��9��q�6V$%ő$u�
��|��jEk׵�����������*�/�im=���q�a�E��-S'[���]�?4B;=R'���9�DBȔ���F�A��d��hm+�vV���.��D�I����FO�5�0f��ERmϙ�(A^�_�O��nX �hc���c�4TN����h*z!"�a/�0[���,8-��t�  �"�8�[6O�JR�q�#y'����
���+������<`��,.��/������;EUI���ʢ딺^��4��!r=H b`4u`�]�P���D��hd��P�?x���ƞ��ר$?Q��k����rZ+ߨ�m��JD����P�@٣q:��rb�e�˅+�}�U�oq֫�~+�������\����׉i���.��M��@ I�qm��A�W�r��b�e�"˓���a�V$z3�|k�U�#ǧ/�ˤ�w��E҇�p�u�ѫ+�������l�������c+�����a4\����"���HLE�* ^ى�
4����+��䈯/����\��H��:�V#w��l��|��2e��ʆn�vHXpL�������@�)V�؄�u�w7��
�MKO}��B�����\Y���}=Zǩ�á��!魳�}V�l�LJ���gM�b�Ǘ���~U;��\�AV����:���z9�=#)@@I��M�4.p�1����oo\��qY�N��֥�*��Zw&I��Օ?I�< Qk����(��}`|g�T�*͵n�1}oϳ��\��$.)J#"�Ob(EQ���!�2���k5�s��y"��\ҹ�`�6m�j��a�{>3q���$���"�&R��mD@]�P��
�[�8	�l�:�m,mdO�����
+�b�@��8�|��9͑��	�-S�D)���UK)�aJ��3@�{I�"1�S^U�=.�=J��^�X[��d���U�e��� E��A*�����JČB����Lш��u(m_r���t|h����@)|�:�F�X���A��V���)�$�����}[�^��r�i]��k��#��2�ֈ#�ݳ�ᝉG����M[WIh��ZQ�Z��Z���82m��yc�N�]�%H� ��rlǑN�Y�h���A����Ô5*ia� ���7�yw��`t����X낙��V7��/ ��7"H�g3K��q���o����r=+B��e��x� �i-�h���ϑ(�n�{j�����!�6�!�=%����0���:�ۨ�T�U�:X�7.��m�&6\,��;�ʧ��$!��l��K󚜨�wG�!6��1���i�ۚ���ˉҙx��hc��X�=u�)W%R<(��g�uQ���7�tϏs��".��ˊ�y�&jJ��6jQ��ev<N;�[9�:�� �x���F�'}����ѐJĈ�u���)���YzI&��.\��p# �Dt��� ��J��,��f�oOw���m�\H�5HO��I�n�&��F�&��z[s��9�-ݰK�ԊÝS���@ ���"�,-����6ҝݞmD�e�I���M(��SU�tTp��(:��N�us��n����=�E)�D10��}�u�xCzb��:�q��&��RIcu�T�p31P�D b-�C�9e6i�.�$$�G��܃�9����������N����C"s���O��m�p�;�6�&~0��S�!nUs��r����2�"��
��#���ш�f�7�tnw�x����Q>\V�3���!��>����������ߪ���![R���#�,#���j�N�;'�,$�2��Z I�k����'A+O�nD�|����(������%�G������K��	ֺ(,�q�0gq�s.+���2��!�K�<��{1�� �/1��B�@z���|�E%��ݲU=�JiL�g�E	}5rl�8�zqپ�z�{�{�ή�-9�x�;xz�X[�?��d�b�8��sd��p^����&_�%O9<m�p��1ё#�bm͂׫�a'��w�_�d��J轥�h�&D�9���=�jx����-�M��#���$�Q($�����q��":�n��2�ܰ>��rz+�K���xi�Xޒ3���CI��ˑx�� _�,:\�>�@�j�|�ċ��x�8������Oo	���J~���74�
^�9�ϧG�H!{8�-k���0�m��\�qA�x)\���$�keI�����?����-NФ.��Y<r���t||��
%5춼�R�P$c�6��$���t�h����G���.W&I�yKn��>�:��Wt&]��@����bUf��%{<�O+�����T��?��J�>�w-��;�C@��	J�I�um���)�|#�ޑ^�L�R�<�4@�`(e��4"����J�5b�[%Yc!5�A#y��ʷx2X%*Z0칤+��/#id)��nMb�cM�� �%���J�+�X�tn��I��J�e�&�V$f6i�*��cU����Dt��v��킧*-����`&Y<�|>��!�~�N�A
"�0D��k��nk�G���:>���p�tB���<zb���R�.Uq W"�c���~�F�����;�%��(�Q��+���""x���B1�2u��G��%�M�g�!�0�(.���k��`��$X��YDǥk���Eo�V�8rlV�+����zCZ�%�;0XKK�Ça~�ox������KQ$�~��Y��G�O��{�X���+���]<�懑�#�����[�D3Iו]6�f����_巄����9�����k~ԍQ܍-ۉv���F:�z__ilc����J�x�\9F.��I�wA�=�.q�&�gk�uN1���bc(]g_� E\\��񃼶 �0�T�F/z.�5H��L/J���8*D�v��eqm�xη�����o�
oy��^J�FeC��N�1��s�ϯw��d�T{�ja񨏏��G�%�8�m����������k�V���@a�-+����� ��#H
�vZ��9�W�v��,��K�".���sC!\�s3�DT��x)�:���n��H����\��f��k~I��L/�! �  }8�9�e~f�9����ʜq����x\Xߎ��K�o� S���(^��^]Ҋ�y�ZPH�
�A>��4�]ʴ�XW� ��uL,��(���:� � E\v���'_�8�X��ݹ��g�#�VZa�4^���/��	��� E�7�`�
����F�s�-c�<"�ꉺ�x����5���+Ãh
��߾�2M�Ѷp�%�mp`s�
ǃ��	a����O"�ƞ
]�T��^sK>���p���t!�K�I"���w� ����z�Ī���{։N���(��:��H\�d��Ʊ�c�:I$<����	Z�8R�Gb�c��5�b׈�n�ꤤ�<�/�{���7���8�쑙h~��#1K�:K�=疞��*�X%�������>|I�B�Fқ4��jʶ���`��qH=�t�_8�4�I|![�����R�+���$����e����*_Ǹ$)����Y�?��l4ʇ�����&^Zb�שziu�Ly��8��c�[/m}O���O���F��[�<%58�#�����S��]]�a��ʤ
a1�G|	����FS��=/��G��֢��A�D�Չp�.'�������Tc��J�E O��ӆN[��*�&�C��Cc�.�(rh4y:S�Y\�������:u^CT�������?�y�N      �      x�ͽے�q-�~~�c�L�����l�eCأ�@��34�c�ј��O�-�=|EvGm>�H3A^j�ꀇ��_�+�������I�?�I�?N��~��/�G��9�N�(~7����w?�����͟��/���W�����`�S���I�/�|�`�j~7[(��s�����������O����Y��?�_��ܽӺ ��� /r��E��c���>(�"���=y��|���_��ƽ���a�������p��Imf�}�+��/5P\���]���l�1{� 	/֌�A����u����|O����O�����2\x�������k�Q n���ϧ���x=�;c���xy�����Ż^2�&q������V,��eE�*^מ��x]�k{x��������UO?O�|-ī8^�N�j%�~��J(t�����c%B<�U]�kW���=����A;x�3�+�t�"�'j?LtW��W#� /�zW�W�pڹ^��;�]ǿ��|wi�6 �fbH�;*��b�t�+*��gW��ho�O�+ؼ+7��p�%�=�n���_��n�8���^�[��
�\��ز���I���'�<D߷z��F�6��b������U��������?���|�0�1,���o�]�"��-����ta7q�����婱gP4S�� ��W�ձ���X�t��,���>|a��a�aa�w�c;`�=`58���C%6L�}'�98�%jc?������;��:���s{�0�1,��������F`���&qU����#�"?n%����r���*.���??�f��°�/���	t��Y�5ƭWu]ÅwW��zw�Y������?��U�!�a!D�~/��ɈgIl�-���a,aX,ԕ��y�{�C'Uƹ�����A�*����FM���8�X��݊������m�N,s'a$�P5�j��2b���;ߞ��Kh�Y��Y^5{���[�w�l����i��|��t��`���|i�!x��|��Q`�FdR��H�x��)��I��ڈ���a`�Xd_��xsZ��x�7��m���x��o�:���@�ULs�`\A��J$Rl�{fG [���O�#�6�6�v�1p���`�DA����/���'��0rS,r���z�K���o�N�F"�����$uz�y�ն=��)��)kp��w���S۽{:�ЂĚڈ��;��x�^#�6:t�{滳����ܲ�<>^q�oSf��i {{�Eط��	b�SV�)���g�-F_;�`�U��f1���4D���4�Rܲ��op7���C�!�hߦ-L��r#�C&���Dɇ��Hb����pІ������K��2� O� �Nx��ۧ��/����Q�6ö@'��F�?�� �ys!ć��)�S�W��'�߯��t�7�@����wM�����,�����}W�������Y���
��U�������#6f�|�����Ӯ�ڡ����Ƿ�-0m׶hW4�Dr+
|l��h���vym0�0&�{L��]6fW2H��ߚ=G5,/�6ʟ�f+&����?E4�Q��^�R��~���(��9Ҋ6�>��Ԧz	��E@���ʕJ�'������(�Ǉ���)ܘ�Z�1Xv]e�x�`�We�n7x<���~�*��.�Wتz5����?������?��
L�����%bNXb�b��`��'vż*�1Պ����3�C�+�x��㈋���FN�C^���)��G�
��;���!z�5dPP��t�����/^�����w��<�.��c+	�k�ѵ���&6\~*�n��oCz����?��5���OL�l��iQ7�>�=��!1.x�	F:�R�����L&Z������<ݷI=A����pB��=�g[���8�J��r�z����������t��G�t5�#��z���������:x��:erB���y�m=և04�~a��8|��u�ϖ���!C��@g�����[�|�|>����1�|��xQ��>O��ě�����O���!(�8{�&|�E.��N�~C���8�y�}�8`�`d4��<-�W�n�T�fb"R"��=�y<���#̑-���zV��;�F��;\N����k�qh�E+��sjK����0����c�F@�������3P�h0wM�ө�b���=|z�������-����������@6)�+���[�%�T����7���`K���&�_N��*�`�__nۋ�_`�o�8C����ؐ	D��8��k����K�z����2ұX���c*V۷���VŻB\����V�����-�5��!w��-��@N�=�w�fS���of�OM���WC����>n��%�d�����a�
{��]����>��4�Uq�{sn��ZCG=k�S2:�hv��&*7�6u��k��'*�A#���-��)��/ͬ�EiCR� H��Q&}��nov��5΄��r
Z9_��lRڠ-��@ ^HW�χ���&V�������>9�^�녱�@ ��-V�'�ɞi�܉���cs�a����H	?��+�t�|=ߞ��	,p������pG�rHi�~ b砞?8�=DL���X��K5-��:Z�QN�{U��XK#W��" �|��8���k��&��!��LT�/�p� <�7o"ge4�QJQ�a�%��ղ�H�6��R��j�.��=�ᴌR������lsF���zĹ�%#�����~aoЅ!F�bw�Dj�Dt����3JY�w�lT���e`K2toofCF�O)����ͮ��/�̅�H������C�O)���:�DQ�֢�\գ�^�`|� �I�%1���N�(8���7ד�'|F���B�`o��"g�l8���,�_�[�|`.��`�)����5��/*����	noaõ�.	7��_�|n�z(�ݠ�����#bUT���z��m㒆�J+x�W~;ީ7gd3<�,&W�ݟn��HP�f=էI�8/�=Z���ϲ���������9���sK�� �$�:�B�����:Rm���E�-}�Q@��^F�&��LZ���i���H[>]źt!��\'�Ҟ���<\��4�}���}%��C����nm�;���S�;�=4�s�{�Z�Ѥ�Ӗ����̯�@�<H�@�GP8���B�����{g��:B�����Z2���h$�$��Q[`�F�� ~c#w�)F�<e Z�{^ "��L-�;c�6lh��ȅJ��:��$�n����� llSfw#������|~~���x����r���`m�;�C�|�e���( m�j����m���#6�1��T��u+���&�Z�;�Dm�zc)ޘ�p�!���";���v���ɱ~�ھ�)q�&E@$4��ؕ���A�R
0<ZB��@�?�6}�J���@xWx��~��K7oL�i(M̛�*�q�'h�Nt���3������1�)�'e��L'q�(H+Ȣ�~6*�'�6�k�騌gpy�Ԃ�~�� �!���T�]�|��B���4���B�d��5u>���"��p#�Ξ��� ���(`��9y2������4U���*E�)��6�g��C�L>`�}t��S��@����L�3�fV3�u���󅷎�� j'�j'����B�f�Z�>LH�T(0P�Ma��Ws��wq6����O6�a$S�S&4�̈���w��گ��3!pq�fb
i�!^�"֘Q�^W.�ّ������n�<ϺS�8{��K|"�a���?�;���0����8?w)RL�H�O:�F��"I�������C��IB�/�nZ�� �JEs�7��� ��tמ.tƤ!>�����PЦ�9y��5�.���<�5N��6B�Wt�g`k����7��ڭK /�[8����0��`m� �'[ARϮ j�0��p�אr|&ޘ�-�_8�p�Y�%� ������/H�`iTQ�U$Ky����9�)�����2��#� �! �Z�X5���V��9\�x}�vo;��� 
��?�9e�    ޙd�և�Ȫ.�;f���yά�r2&��� k���}���;b�s�K1��,���43�����"�ܶx'��sSfǒ�YJ#[�t]Y��(�ǗVl�R�W$p�ŮS��MY>I���k�Y��S{��7���9b<����7���^`��x�`�jJ��� ��O��xv�_����֨�����\5��p����;���/����H�>i�gCVMS\�d�6&��Nw�VA`�曀my�����A�C�W(^�Agv>y��o}~�����;��o�҅��)����֘"�������0(���wPؙ��F�%){4����"J0�*Ϗ�GD���ǟ�����r
IG�����ô�V>�J�=t�y���z�ې����#���ׇ�7�<�b��?+B��Gx+�k'��3��^0��������������VI`L����v��/�H�DR�׌�TTlm �����������9c�=��=R�� v�m��c�Z ��n*4�݂�"[<��k;ܓ��JQ�����~����_���0��܄S�0��A�� �K���hNn�����աJ�~%��2��M%OIQ���K�w��;r����o�p��tV�p������������@�3n���GUǙt���PgZ��*��}��P\L�/'1lc���"Sc	���͈�c�T 7 �D����s��e��5&sc	�`t���6�adpK��:�����5�|\�.z,��H�=OT�7��*��5Y�k2��}�9�t�~�f�r��A�gq9��Ag�d�"cn	�X#C���m�RD\���dh�f�!f�)�n�@���%ȷ2�R3��0���^�Ҫ���d=���ϧ�s��),5s�����uC�3��ͅɨ�Z�LD�/4�37ˑ:|/}�B�y@H���V���/4�37�=��]������H#���[u����fZ�hh�fn����� w�El�w ��5�X�kG܌��m��-R����U�y���̧i �דi���/��n�2੅�����VO�<��&4nJ#�-�,�/�89�B�Q��1F���ɱ�����V�l���#���i��b�9�+���C.+|��	� &>9����a�Љ,܉�+���pL�Һ���((��)��� #��c/�cG:|�}SZ�1�LK�_Y Ȱ3a�*��$Vw{=N��Ķb	�嘠��W�	E��Q?��ti���_�$�_8�+�b� v����������H�jv)?��iު�s���&�*Y��̿^~m��Q�'l��XDzx?|�����O��J��\g+:u��y��Ƕ��������s�=y�#�;��c�V�_���'�)Y\=�ˣxUA
i�� )\�pp@W�*N鍥�@~�8s�`����S�F�6f[�)۝j�}d���B���O�|%ھN�pH��QB�|���/��}>���Gi�m�o��{!�,���_[;w��{��_]��lQ8p�q�]�l5����>?�4�7S艻���n�8���l[� �A��Q���&Lc��x�^�	�m�@=Lm-I�B��{�N��އ���M��$^�7�"��2�[����U�%(�׺��:�/nu�%�o�|�h�5�?Dot��S����'S#pw�<�o�W!�?Ō��4"zc�H�g����
�v�97Ti�[���A���F9�Nxq��SgMC���V��=�jT�z�&C��4�}EKL[<�l� �5���6����Q`��8�xe�|�kY��&6;!��9�L�R�荊� ����\�s�>�Y�e3	8�jZ<`���!z��Ȁ�i�߯���m�"O <���i�s��7*�x��i��NHDU�K�Y\ ߽�?�~k�GA<� � ��Q����qT�ohŽHL)��=<��c��U
/�U\��Qx=Hb�5���HW�v���..�H!-�,��>5Բ�XhͭqLn�TW>`��q	8�o*��k¨�04��Bkn�ヵKk25]�A���o�p窸f�%^h�5��˸�d��m$�M���޾����0��FM3���H"�&�<:঱���?�2%�00ިy�_�	Q���='|�b�����b)�gm���G����y���
R\\M�����dx�z�xGz���J�V`y;S�zˆ_VgזN ��W�+2�8eX��m�Ftr=v��g9�l c��?��
�ǅ��J>v�5���@�|i)���׆+G$�B�d��!�ܧ�̟/�H'�h^:�LJ�ϸ��8<c��b�>��gq����xu�i�8䑤�,�ķ���Ri24!�x�|��@3q�#5�
ȑ�`+ ۨ�3y:�H��?�H���6��ݮ�D:y��P@T�匿�n/�#�$�p�=Da� �����¹x�Jcd��R�p�o�b:��ф�n�M)i���SB�R@{l�=��h�-�$�ʹNAg3g�t�x���d=��|�6<��y�k��.�I�(���H�{������Aڐ/i1�@H"#���ᑝi��ΰ��J��S���+�r�pӦ2 -���P�<j�Lw�m�������Myzٲ���G�CVm��q/ؐ�� ��a�8�k�^���(��`c�z��5�ɸ%���Q����rzliH5�-��z<���f�q�..J��Q��1��A[n��H�=}w,Aw�f��)��qțxO���>���@m���q\��J�f	�੟�`�Þ��YXH��-7r1����G�v?�W�{���6uaU��ahgyh��<�F{)G�����+GF��↔6ěa�gy����j��h��+V��|"=�w��'�ԇ�4�q��^�LH�A>ʑ��5#����і�d�H_s��Z��/��X��c�a�z)I�#��ݟc�)�>q|u�X��/Mq}���R�hg9�Nd��0Y�K��)�q�|I��n8����&�<�y�B�Մ�D��2)T��p�\��#M�6"ǭ�F��jB�[�@\:ȡ�]��;��7 ��.��&C��>܂�4H����1\�̘'�YW-�r\�n]�C���cC���;�`i�)^�g`���q9c��N0j���L����yh��btĎ�Y}L9�f�����scћ����"�K*}^3���b��ӝV�%�-���x�{�����?�i5�wp��s�:߶�a�u���D�]�7���a�ϖ"�-C���}�n�)��-%N]��T�<L�̶�)Tc˟Ǯ����8��қX8G�/��LA�Zʁ�#v��[hS_��v-�}z��������R���d�\�Yr]��{��S�%��nB{��츻659нy�x�A���mc�a��g�w�[���5l�|��I+���Sۖa!ل����c�[�O9���msK�BX{��K�T��q���v�5��}e�Ay[��J��'I?�޽}p�~�F7����yT䮫��0߬K>L�N��{�;������$=.��P×�vOC"�u���	нR���x��A������<���d�N"N�F�eWN��Ǜ���a47�hnh��~s)N���K�Qd���[���v�r�<DQ�X��]���Ǧ-���}��Ht�6�ǟrp����������{��>�,$�с�׉m�r��$/B؉2n/_��<b�s;a;�0Y'�1����;�Eb ��i�[.��Ҿ���v�U��v}��홆o?Ŧ�;��B	�y�?����yp�O~�n�>���<m�&����]�Ǘ��Ac�y�^-PgFU-L�I&o�_����d�?S��Ӻ�;�JR���:���������ȁ+r�Q���u��q��:T':\��!���i��|]%�����ħ9U�S�t�c�Bz� ���+�B�ɡC�=��Io𡦔�U�١�'����B�A���`i���:G��R�{i����N��@t��_3��Z� ��NSH��2�����A&�������[t���MKѕP�*��+�#p��9��F'7�F�"S�i�i�o^�    J�~]��ؿ���TO6 �0�}�;ɞ:���̯��|r���JwA���Tv6t��7�o!���y��۱Q$]X�~nI-üDL��حk!��^�K%�1]���t^"��z����k����`E/<����8I��2�va"�O���h!ǀ���j�̡B.46boq�fb7����U�/w�C�3�U4 �D���m�Z��4W�7��A?	x��Kh_%bD��ѽ�F�&4�7�t�H�P@���^k�;�b8Cn&�J	��;o�+)���;l�x�����Ɂ��U�G�֏�4g�lZ��*؅���/[���C[���\z��c@{^A�}�c�)��Y�'1#l!��^�����
D��}��'*�Wn�؉f���c����{�J��o��5��tBX��o셛�N��Z���o��5�b}�����X��r�=�\�o�C۾�k��n�/�tY�U'LGbdQS�E����tt$q4O�l�U]i��H)��n(	T�ĵz�H�z�b��6&�l�^�Bf��I�b�ʫ�u|���.����B^3q#7w�No�۱�	���j��IK�����1B�sG��y�QPJ��8�����G�Y�y��aB��(�J�>�%� ��[�@b(I�p Ĳ�22�ݸ0v��;��kZL YHAb(I��1�f�|Дj�:< [FI���c�=��L�_�q�u�8�M-��s����ȳ�z�Pꑈ�Õ��(����ģ#�.�G'����Q���!�l�2�l3l�ɉ���P����}���"�Z6�p��c���$�0{��Ԭm�y\�?�ݴ�a�����)���hn1����=�L���n^r,D	ȖL9�}���B����X:�T�U��c��@<� e�����<�$�㶗='�Y��;�Ԏ^���9�h�A�C���|K���V�:��]^�*n�޻_�D�PeQ����q�u�� U6vgd+�-�C0��Kg,��CJ�ݓ�tZ�+:�r߭��)_���o	@��쏡���Ȋ�kr3�B�G$}1��?�4:��K�A�c7�D<��b3ҏ�X��������P)ʎ�[�4@��)8>	�yi�n��2�ͨA���3,ݶ;q��N�~���լ��&�aЮ�������Q~0c���-��v�,�L����+�Xh����ƽAs�h>׷���m��@z�;��V�m�|��B�%r�	�Zaì�R�MZ���c�,�j�xW��,�/������x�&�I<���r�0�s.>�' Ʉ1���L֛I=Rh�xF'Nې���6��|�0g��Fxt(^��:�v6-|D�]���y�����
�����4/�k�G��时���8��c�7}H���i��F�w!�! /t|�s���,�Zi�E�,oO�/_Z��/�	qgqwo2��ǎM֪�p��)��r����-$�2f�fَ^�\Z�:�w��q�zo�,k���Ƙ�#����M��p$Y�e�d��,�}1�9����:j���+p�L ���Y� ͈�܋��\7[�������M0d80�ٶ��|s,_J��X>��iǿ~��Dr^k��N<�n�z
3�H-�Z����m�r�˽��y��QSE��dq��O�w �V�r+9�����k���b;���FD@U\_��p6A
c�+Du��;nD�V{a��� �|�<� vh�-��y�ܴ��;&9�`��+���Z��9�k���Ϲ`�b;�E���}��&��1ÎY�XV6N�����'���7%bj?�^��a�xz�*MC������
1�b�9c,�;{��k�	��7oV�X>g�J�̳�l�X͑�1�p�M�U�ğ��iK����0� �q<��1@��:�^�Z�bS��rd\M٨�N5�p����ar�a�Fث2W��!�q�5um����,8�A��-">6p0���3���1>��ئ�}�mK�t�e'"��E5R�J9�����ׄ���������Tj�ě�mD� � ���Dȃ����Y'�8���g���x�X{���X�֓xgB8�������%�����bc����x�2�*Ϲ��C���e�adD�}"���T��ɀ�ږᦦo��I�L(�!��'"^�}(\���u��K�Y\��\�.���5C<�Z�@�ξ��M�O�������"G<�LG�j`�q�bsĲ��͉L��	������_Z����Y�xpr�"��DĬ����~��A�$�׋���5K� �gl�U�����/�ｃÆ�s��#.;<�F�,�HH N�&�`��������Ͷ�,�!�x&��䐷p�xo�|�ej�4�t�4�ٴ-�\'!9<=I{������҉4����9T"������e������-쾩v��4e��M�jX�����yl�NRt����4�q���9��i������!��ip�vr����M�ѩǛK��"B�ۊ$��B9:L���>ObK�$��5|ZD\3���/tԁ;j;���xq`���)���x�������C��7�2�`����Zdh��ҫ��]�����n�G�@�Irq9^	����]��B��W&��>��y5E\K[�!�j�o[��n�m����t�L��P<[pٲ����9�S��������8Kf ;�!e�TW���2�8�Pff�2F)�,�*��R���	ߞ^��-d�3(�{kC^�ŗo�v�ܦfc��#���j��T_���+`7�2���&ͥ T���D\/�ck�!���\j�ˠx�'`i_�ě����{�~l0�����Ŋ�5�����E�����;R��|2�<q_������FNp:����&e���׺����g�]�E��D��1�1� w���=�ul�n_B	M^�h�Vu"��Y�K�ABC	e"p?V.s��(�B�b�Y;���$�Y�1�PƐ��\g2�)W'��ȣ�����7 s���!�uC�w�6F�p/u�K�� 8����f�P�uNڧ�p1U\N������/��@B�p�8J2�vVԞI<8M���K����W�Ņ�E;�@L�uЫ����S��OuԊ����p��,�)z5F������3��/��9o�e��7\�7�I�'Ggv�xI��AV�03>�УE�����(ח#��:J�d��o���t���,�	���-
�{�:�3�I\ ?�5�H��>?X�L�G�#ߗƄ�;�q�<jkON���>?�f��;!��z��:���o�L ��M0ă�.���\e�Xě��r~��,�	���Ľ��p��H�s7�n�x�\�7� ���Gw�IFM�#��~j��&.�oο������h�����">��`���d 9=;q�3̈� �Y�t�$0'�D���nd��A�;q�G$]� ���m�0�����I���ى��0ؐ���N�Ų�ʛ���/�����'v�V9R*�.8F�!���͓.�j�to�,J��T�*n�"��Ho��{�{��D~'#4��Y~��d"Vq[Yʨi��U�����'߽��A:K�D���r
0�ޫOؗ�.�?C���p���E,e���5&�Ku�۟Z�\>��τR�B������E%6���q�=��{֨�7$��-�*�>��F����RZ��(���S�IʬP�*�o> ���r�F���T�XP���,�W��
�����f�[J7!_�Ґ��~�V���LD\�" �f,囉Vُ�Z��h�?���Rfp�Y��-`�:b'���%������2���i2u���A�v��C�\���Y��&��	8w�?̿ ������v$��멋}r�X�3�{�'ʗ�ȡ�L"
�����<�S/8('Q���Z��N^�7 �|�I�Y\�ޝ����D�����t�H��2�״d��=5:)\���<#Q����t]�$�����_.Obph�ϑU;��P��:�a"1C�mJ�q�61� ���<Ј�k��X�	".���2�54�5��j�p�:c��    P%�EP�8H�b5�6z�5��PM������S۽)]���r�����_F���'�3 ͱ��xIM����&8*�:�`#������k�|zi�J�P�5��L�R�@9Ō̴��D�)�/�v,�A�k�]^�[�=�"F��V�j�����AD��c�n���.#_��3|�eC܏#�fqM���~�����pk�tS{9q�&l�H��7���xh۬�����ץl��K�y9_F�4­	����ǥM�A�k�EN����'��9�'�ؒp�(3��f�;�$�P ��p�+#s��'W�֒J8H4b������v���ak"�\�o-^����kp<�.#7U�蘸4ŪEtQ���x~|n�C�gG~�3��ޛD΀�'q�� 9��Vs�n,�����pT�f����ҳ̏��Y�B�gG��J�b2lwZ��J��&�~��kʶ�����Zx���,�obRs�x�TqQ�?�ܟ���ڶ���--����q��l�܂��r��A�k=?�e�� �=QMl�C:���!b��,w|j��������\�,.�/��A~k�T��,Ԁ:���@�2¹-q-"������4I�^��8��8t���D�ayxM%���X��B���ʧ��C;��1��1U���O;��M����3�$.{Tq��'GCfK�i»X��h�����Bq�m�;�rĳlA��4�R�D�N��DZB|P���\;�N�����E�!e��X7L��z�h#A����$�?_n/�m�>���#BWC�V:c���*	y�wY�t0C�H9="�A�Ʉ���$�[Z�{".��|y�4�@��a)�G<Xk%��}K�\���Yh�CWH9=V�:�$���{ݽ�楃�&��"����m����rzD�j��:��22�21��310t}��#��0u��--� W��.�:�<,��l��A��-�3�#��r���(�-Eנ B�NO��(d�>��t������O��0�y��<�Y��"^�4���� m��N��!XvdRbkI=�g�O-r��}%�)�=�A3)� �5,��S��a1�NG��˸�괄UO��Y��t{��FM����k_�`��,&��6>I&t��>Q���Kq5���s��c0@�W�%n��ȗ�/�����xHPb=w�A��B����X�l��qE�x���<t��=��f�e�&�Ԗ��^Jkک5"��oD��$%�swI��E�5ܑ�hv�_[�Ќ��c����@�]Q�"���N�qE|Y��/���<pn��u�6C�uD�!��t�yH�a�榳������x��O��hT�v�ĸ���6pwn:$�qѰ3]��xl�f��kFF,M�
z��_�fp�xx�+4!��>a)�� >}i������=��L͊�6=jdz4�#Ľ�`\�L[W�m럇,%6p�����6��;��-�*��G7_Z������uu��&=t��J>����/-I���%6p�g��Pط���>uT"ā�?ܞ�3}_ྯ�tp7�]3�fh4��1B}��}��,;b�!�A��wfD���E��7�n��{H_bg� #���݉5B��F�]���ؙ�A;88J �^�!��I#]��ux��΢x�cbg��`R(�n%D?iEƮ������ؙ��Q������>�e�McW�r�K���C�;sG�p�g���A�b���"P(�����!tzę{��{t�-�k";�\jn��q5���Bw8swأ>z�-��Ɗ�]�P��Fa���B7�Ͱ���?6��vF��\1C�!{���+��G��E�؀w	qQ
�:;�Xs��
d~��ڷ�uD\���a�\�t�I����-7�Y\4��YА��.��E�#Uh��
ٷ�8����$".G���x��i!C�p�َF�i�6�i�����r���<d+��~���J���`D���x".J� C�p����^a#H -�~�^��\�N?�B�no�n�J���wgþ�P潚	".��cQ��f����F	��b����T1���b�����zH[b��z�F��rD��0�JQ�5�{��6�}��}^�
=7���6`5�%D\k/�yn�>�Gc�ׇ�i˄2�#=H���v���� F.�M�����\
��6*'"�*. C�7q���X���klF���8���]��ݹ���X�YsD��b�4Y��gqU`9;7qg�g ��F۱Ci�R"�����ԴWz�P�&���p����޵k0�E4Q�[�&�"G�&��beg\�2��}kIo�oW�,��9�H�O���>����5\��A���:��zd8N�&��z�TuR��Ėb�/����?�[��_e~���rΐ�α�t:�ʒos�D\4���I�.tmt�=�֡��U�K)lB�ʬ�C�FIj"����LvGuGv'gqE\wĐ��Q���xp�E�³m}�OF"��r�`��(KM�ǘ	`�8��|�6A���o�2Ij%������3�9��\ㇼ?�^����Qz�����Q�޷�s�]nvtqю��V9���,5�uU26�%|F�Ka���8�}e�Su��1�m[�Iϕ����	zYF�L5�2լx�A=�nυ�X� o��:���C����;ϺW��+��se.�#�����ryn4�@�}�|�;�[�@��ճ�Z=�B�]a�����l�Vѻ4C�P��x�;�RC���+�wUf���йlx� ��₸�N2��j�
��h�	�~\�U��e�&��]��8�=��)ｮ��hK�K�j���&f�5F2�8�}�|]�3���Q��ۅD\�[0GyH��4w��/�����3��@-��*����ۡX�$�Uq����П�z�?��*]��*�U���EB�.R3��7�^�W�kRrOz�rx́CO���\�H��c��}�;7��y�q�X\�a+�3�W�Hxz����M	[��ff�h�l>d�q�{���&|S�NX�Ө�x�UqQ��B���j��i��ո��ks�hDXR���p�3���`�|N-^1�ٺKĎ�������z�r����લy_���26AJ��g1:�!ˍ3�S.�6�׵���n'�iq���f��OM-��8�=�r�\���R���2��#��O�'�A�^z�]��t�����/�|�������X(C���ԃf��A"����� �ؼ��7�0+pW���ah.�s��I��I�D5С�������q�}x���i���D=�U��B����N��2��
�������Y�_��,���!�� ה���r���zH����-���Zr���+CL�#��MK�~CFg-G~���n(�M	�Y@�Z�{$x�2�yH�����[_�v�7���I��� S��������r�"���z�8\E43�B}9���R_q��/��^%H��lਯ�l/�'��5�D\n�D��e�2WƦ�MF���ٶ�l�Pkǿ��|�&w ���wlP�h�oɫ/��4D\s�_�Nm� ��q�;�X�C�TL�a��'�3�oӘB���L�A�KT��4�+d�s��zQ����O�<�C�CTf�����qn�� ��9p^�w���7�N���F����n%�r��[FF�o��-�є�r\}����O�I��]��.Ou����ʙ����u�!6�D�e=D&2�8�<��Õ�p'���Q�P ���qg�oF��}iN�7�m 	��(5zH|��sz㑩^���)+iŕ��-�{�����8�=��3����B�pG��F�`�>�3�gtgT��kH@��ȿ	l[U�R�,�r���0�^��b[3Yߏ,)�
o	1��v}�A����~�)H�#��疼�������|8�`wвw`A��Ŕ�"gq=��� ��48�_-m1Z
W%)\)`����h�xϕ�Ea�8Jl�}]�4!7}S����Ԯ!�-��y<������&��e�Ă���n�눸ڽ�c��#@VGYMV�    �3���������;��"�V���Dă����t�_�jmWAqE|wz�yz	� �M\�v�:v�-e���$�
��,3G����M���#��З�@h����0t0C��y6׺��t6�AD\.�}��r�3�Z]m���f��ta��x���Z~� �N�;�>8HO!��R:8�,.��_+�d<q��$B��Y^���<��Y\�z�����8���f���/4�>h[J���aٺ���c���|��u4�"��t���,�Y�{oq�/�/w����u)]mF��R��P�QL�r�f�����GO�mn�D���>�� 	N��ܠ�H��a?�R�+�tnbu��UG!Cn7s/hgD�W��26�����ȁHm�f�� �۔2�LQ  S��Ճ<�|i�d7q3�؎��u{/{�Lߋ� ����?.mJ?@r73�����E|�a��-iՋ ��U/�@Y�1tz3wzvpds�[fz�8w׉��j��m�t&n���v������B�8�G�
U�|~U� �L�����n����ś@�e�B9�x���=��n� iM��}���H�w̳��6c����!r�Q��r�>�����vb.���*����k������R\g���.��$���|KM�[�����w%\�B�p�kjm'���dC8�*�9�}�-�-ܛ�k�����ޛ;��Y\��g�� i�[�[*1�ԓ~;�Բ�����Oò����u 6t-w-n�	x؇��)�í�=�a(dqw.�pڢv�Ë�꣪�<r3C]�y���҇H��d"���P�RF���i=���U�e��qӔ�����\���O�X��=�Qy�0yU���]g��y[-�b��������ZA4ؾ�~%�����Ϸ�B��p�ޣ�9����ԘuB��D�+~m-	:��3���p�8FwT���,xkUq9�O�ۻ��?��c��'�����Ԏ&�U\ ?|j���O<�����oǵ�8�!]b�>�xQ��'{Ģ!�`�z���K��j�8�8�q���&R���G �:"�e�ۉ�3iVӦF��S\�F����6�O���Ǆ���Ռln���� ���4�+r���s��z��f���;���f �(��=z�T}����NP�Y��/"�T��p"���O<����qG�S�������G�� �������Ƀ2�#�iۨ��@���,Bf���%}��;7/�( ��sc�;��6H��U�����J}>b�i]���뺆X�9�=6K��v񊹿^N�-��gZ%"�%	
z?�x�e����cn	X\�"�q��"Ї�.^q�:S@�)/�.t�W@����0������0��ٛ�
i8����W�!��W�!���˯�t�[U��;� �$�-���xiOz;Ž�(_E�����%�,.'Co�����yUsG�9�"�#�M��D�U"�R@_������˾�����ĥ]�L��	�����k�邿j�j�q;�H���.Z܊Q]��do�{�i���%O�NA"QE��ŉ����s;� y�'�-kp�#�R��y��F��Ǡ'��(.���ܰ�H��ᰯ��e���(�l���-�pCgB�P"
x�>Ht�sRk�{�+���T(�P�$�ꚗ*��ג��(`/<�{�7�,�%��J�o6�� ��22��tX�,�ϗ{�v�(��$�cusUQgR]P`6�.�D��n��'�0��X�뉉_mr
���na׈���S�I O<a<Y'2����*�>=�pO�ق�6@�OXO�j\��`w�G\�� �a��\�ṁIO��>�7<�A�_�6���C侑x����S�T= ى7ܻ���;!l�O��l���0U�M�B�O�N�^8< Xc���f�ip^J�ssz�kMd:���.Y��p�҂Ц�0���0�Y Ӊ7��5JY1Q\Y7�Y�e�e��,G�Wa��nh�:R�]���WQ� w"��ѩ�h#iH��M�׃��W�>c�x�����ϗ�<��r*�
���2�x�8�0��%~���n�1^�J�U�EEұx�p���x;VcI���s%]N����f���x˼v,�^���v%Td]?�U���?��j�D�2�x�x���*��-ld|n��!��!���m�&;ނ��j)�sñA��$l���[�-�YC�|t�����>Q*����S!A�o�_:$=oA�9�j�QŻn<�/BH��-�.㯔� ���9;:![��Z]��oإ�=|�-�%B�M�3~�k�	d\�{�e��Fw��\��(T\���[zVQ���rأ�;��9*�Z�y*޲1 1t����^�s��<��(p���/����U��qŻ�v��[���:�,�ޅ��_�u"��9����e�1�焳��2�[����1��C�7��-��\�[.���o�;���tm\�m��<�"@������]B��,G��4z;�^��h*d�Q�UI0t� ��ЇS�zە *\���&�e����C�&�:�wx��0��<J�e�
y�� �����.4��Ż�1w�J`��|�Q1+\JW�n��{f�M�K�:ShQn+��u�8�"�(U\�(�� 	B�gV����հ�����yYU�j�{������V�b���%T���UZ��$�3�D\�ЇV?fH�ု+��4yޏE�H�o%�,�}{~���r�x��b_�zC�I$�UL$Mݑ���$+"�����<AK���:�@z1��3_}�{� �H�ϗ֝ϰޓN���:�G9hU��󑰓�æWZjBǒ4��<#��"jU�3��.��s��gH��	K��&l���&O�yn4�2n��M܇;bB��r�j|�2�X�%��aܑ��D�" k�x��x��0􈄊����aX�x}bI����W_�Ǯ��2���m�fb�}��5�����u�:��D����4�ӭi�ү@ZZ�2��W��_�WeSn6�֎C�l&>8~�c��W��-���I\?����L|���ۣnF�4�����}I`��Dmj���a�F�CU��x�Ƿ*Q��fIL|`>���p;�:{K�W���}yyj�B������{R��>?%�fq����}�.dn\�`^1����`ܷ*�m�]�Ї̍k�/��2i�1i��0C�?7�cl7s��Mp��H�V�7�Z�}��<C������v(����� �����x��0�q��'<6���� ѬR9E��l"��%�
���{ϐ�����tF/����z������_�!����[��߲Ht�G:�tb�� ��U=�N�RA�˛��Iw^�}�+}Ȯ�Dq�!�7���z�j'q�n���������4��Z0"t���s$ I�,������{��fFtȖ^@�3�jZӕJ��h6J��6���f=��Nm���c��_������s���;�{�
K��Q�)ƦLH���xi����{�ȍ;��Hy;�8����1o���gq�Н/Ᶎ�s�i���Rq����͐=�/ܥ��q�!����Fp�>Oĵ<!�۸�ܨcu���Sw]G��}�T�G!b�9d���z��}��k��HC��
v�e�����QC�������g�a��J�77묨���r�$2~i��F-��������]pc��g٬0yU\5 ��с�G+�.��\���;cLf�~��̚1��c����n���!CA vd�`	�_��)f�7�����$����__��-���oXL!����cW�%��%�H,L�c��w�9qs~j�Қ�i���4�i��!�^�����'MA
倴&�К$��*�������I@�K[	J?��[&Z=�D��c�&�뷬�ϋ�6P\����=`ab�t�v�+P��f��]�+5"��l��Ϗ��/":�� ��(r����f�-��Ĝv�[qȹ�b�v{i g�O���V�����VTq�����0Sϐ"(n(A    AU�ש�����a�Y�"�r��;�fȧ�B�;��������S;n�7��9���H�&�8�"�f�>ֲ�$�1ұ�Z������0�_��#$B
���k���e"���<i3�m�A�%ܐ  �����@C*�+�5ɟ�ZD���A�<߷V��:�Ϡ��������<�) Wq\)�(bH �%�����靨(o��F�&��^@yr!��)��;����i��q�6FMN=�����`��I"��hd�y�j����q����U\����Vd!!%R������_��-;|�̉I�=��lF� NP�:�	�l���)��%^y���6��$b̐'"hurfD�5�sZ�".�/e�C���?��o>�Cgc�v�;��L�-���]rٛa������h�&��K�ڭza�Ͱ�L����Y�9CꞠ�e�����Z�I�f���P��!A�8�w��7���5��9�9��}g��}����CӬ�i���B<��=މ2ԛ�ǢZ�y��SC 0C�`���O�Ñ ]�_Ws$ g�J�)8��� e]9,�K���h �i	�^�{B�u4�����P ���5RZ�M���)u�ϗ��p͝��nΔ*��*��9;�Ԏt4J��4�~a
b���t��eLa�Fo���������߆?�C�B[R��"07��l�I��A:�`xx�ծ�����q��&	<������ ��	?�N�DdP�K�߯:y�~:�=Qe�jEoYQ�fAsMq����e��x�Y�2���{鏘�m�����&��A�@�k�z?�Z˧ß:v~�~Er�n�E�������E�8����"��TU|�U���u[w��ϧ�4ẽ��J�㥝�!X���t׼�ϐ�K��L�I��Q!�f mD0������>��,�e��Bu�kx�"��7"X~��zĨ3%CS�BHĊF"�0̳,̳�U/���/��[2�%�%ԥ�%�����a���󪙞F%��s�TW�x�2����+���a:R"���<�X�ڌ�i* �S0�$�N!��a"�����c���4��I�G@��`x,�ЯJH��	�b9>����c�g~��0H?�Ď�߉��B��qi�#rW�ڢ��!kD���?��)#���&U-�or�Rx��_1�f�t�M�~�r�m�v���͚�&��~�$.ςPk͐( P���2���̾�1o���
ͦ�ߔ��؆��$x�^��^�L5b�&�����l��օL"��-f���A�G�N|�n��(Xv�NMo��&����sSR^	��cs
@}�zwn�<ΐp(P¡�����#Lh�Ϧ���jѦ_��z��'.C��@��"��Ё�N,�� 6-�X!1uP ��',�
�n(�����!�j�j�f>%�䇌C�2E�c[<
���fKZN�N����eY��M�2n�����3w�lSҦ�__�O�K���3��)�L<��Bo�����c�q�P��m����}��!Gp\3F��Y��Q��R�s�h(ί�O�/M���yy��Z�(�G���������˄A0ЧɈ�~����:1U�����ާ�m>�)U��*���a�5�������'8�?�A�C��T�)eZD��(:6�e�r 2$��r�P�~J�!O9�W'�E#��N�>@����e٣v����,<�-[k�V���AË����Q����qp�zl�X����������{7J�f���0�R�Z��6�l������O�x�� �3�a�ӳ4��P�r$�K+iL�c�z��qw{�mِa(x���7��ń͙�F�~,nUR���.m�b���ó�G�:�����B+`'\�K�PW��'m��B�x�6L �:Cl�.�p�la�Ƕ�y�tB�3bMgC-�����V��SdN�˄M�TH�����_ �P��"�pSE���*j'"�f{@�B�2V��P�b4/�ɴ弴!�|ȶ�<%Q�=S�#�Ve���U��	~��<�jJ9�!���m'�������Q�v
���{l�o��_�0 pl��^!-u�YWB����v�=y�y��	�����e���=�=HP�u�	 k6�<�!/��*���&���B�H֧T���ʀ|��� CֻZ8Z�d�[��+�龵Џ�Ə���u=��s���S� �0"
�����Y4��Ĕ&�["(��Ⱥ�Yǂ��_c,���>�L;���ʪ*{����km:�msg�`���`4dS^�J�2R�6R:٭���s��:=�/�3�˗6�i%u��#[|i�y.�K(�W�xQ���i�r�l�p�pbQ��]��?�UaQ!��	;MM�V��o�E�y�\��<q؝���;>%{ ;^�z�6��	��Ǿ��3p�Oy���ْ�94���]܏��8��hK|{i$��	�y'#�S�88�y�m�Ж����Ϗ��0���S��M�v�RN�U �Pzs�y��!�Y`#e����`�l��qؘcK�xS��u�jK�]���	�%ZOYwZ)_1v����r��x]{�*�}�=�?]�R���3�_�O��Q�֖a׆�3����x�*�8�_�K2��T�8�8�)���9�Bq̐$,�z�Ns;�	A�5�Zl"����m��H��eoo�O?�iCoN�zl���52[�S�DUO�	�SZf�=�$O�)o���Gn~���4G=r�<��-N�G#�5l�#l�Z<�T�
��RD�k$�	���:fz��fզ	��LL�z��!�MX��Tfp$̾ReK��
~�|!Ӿ��"=ݷadTS���?�	jw�K�Vb�H�$�#N��B}����f�yz��8Ȁ�W�r�hd_	۹�.�r�g�Cl���6�܊X:ȥq��3���Ȕ��5x_Ow������[ n ���;t���M���n,�&��d�牛h3H�m۹�iI��ϥ(qϐ�7 $�	��Ub8��ơ{!�O��6��dtE��@���V������W�F�1�(TܽX�'u�gAh�@�y���h"��+Jaq0�A�K�����~���1d��'n�L�a�߆�,, U��R���bjD�G7DF�b���l��4k�,Y�6��"v�]4 �S�������K�E0+~�b�����ଷu:ՁlI�M��~,�G�š�5�#���HԮA�XU�����j"��X,^ ��<5F����T�%�QF)�h4�w�l����� ��<��x �hH��qx�HZ�C��&�ڃ����z� ֶ�HL{\��䛚wۣ,d.32\��n=���v�S��pL�?[-BW-ĢD[�u{�3R�	2+��y���{��bV�n6����f�&�=���p�P*,�fcVܷ�F��(i/ˢu)�Bǋ��@��6D�7͊�;�j��}�Ȓ1/풶�c1����gk�!/Ȭx�a7�ڽb�9�;�����<����.m��̊{A�����>�<�J�zR}x�T�	�� m�� 3C���mZJ�|#g��"��5����b0��6sF��
lWJ0�p��8[������|��J�goV���;�������j�>�l@����A>���)�wqAٚE�mɊhڥ>����M���w)�4���¿<���e�4,�)�WB�>�Bnv�e�KM�Ƽ?��`��!�>�r��mԑkG�9�is⫝�P<m�6�`TjIT߉zyl�H9zr����L��l".�e�A"K�X⿕�� M��|
��&p�<�l��5og}�W�9��FG��+��?���W!LiW��RP�D������8O��ڌs�O?�� ;ͽc����X?A�˒��U�i�Rq�G���w�\�&������k嚏e
�n�W�G��I'��;���������~��#77xZP���>'JR�͚;����>�=/���WX��{���C:��5и�X|��v	�k��N<�vˈ<=|�|l�+H(3k��q�j���'��	H��r ~  ��<5K���2k�H�����Q�l�i˒���a���ܠ������N���p*6���+���V�L�Lig���>_~k ��#%���G��+�Ȯ�Ƶ��Rk��~�|l;��{�)�Z������v�sXxqe�'�x���V$�mèr�͔�.B��g-#5mO��J�^�I��mØ��*�ݻ=�;�����|���iiB6.Ռ��Bו�&�͝�=�_>q݀��3�_q�����s�Z�(ĕ�QF(��/�����AC���pͰ����;$�O�P2m��;i4��H�*�i��\p���ڔx�Ĥ��j�퀿��R8dߛ)�^D<��h0�����l�z~lv�,�mh6\�}�m��a�ԕ�%�8=���'=5%���s�F�
���vu!��u�x��^:�2[��?�h����]�\V¤���J|Ic�L���6�I��b[��1�.u|	%N~e��d���)�f˓Ja�5ɕI�R*:K3a���T��(RҐ�l6<l��WP|�}B��]i���a��p[t��r��	7!�lx0:Ho��06�y�~���d͖)���F���j�w1W����ci��n�%A�Yg���\����D�؉�d�����K�b"bXb�q�\�7÷�K�R�m��*�HLw�I�2�̖��U�U]�ڝ�J��Π�����էL�}T�}���t����hȑ4[��x��b���
�Ȫ�#a�?���T�����w� &�!��l�1�T�Q�ޕn'R!V��֪{s���8f�NX�P)O	 ܙ�oӍ&�2ϩ:�R��q3��t*,��
Bw�w��.'=�>K��Չ0�6?���5���@��4;n��cyd|� 8���]��.�%fH8;�8�ǣ��~u0+�y�L����$3���iv<����u������eD���*.�С�+9;�-<n�gȝ5;�N"��=�6ʚ�Kh�1eW�+��!p	!	��x��65]�ۼ��y��(]��̧k�������!����C0Q8�� �߬AmU3�P�%5n��f@����e�Jx���������k.�x����</�}hv�?0�C���z���"�Џx�Gz4e�F��.ƃ�	wL_���F�{D�������ܦm!���҉6����]t�f�V�V�����$�x�k��x8_���4�/�Ϥ��i�J%rh�<�z=������>�|C��t�tnq�X��hz�HueM�AȔ 7��I���s�xn�rW��3z��
yi!˵خ6u�4+d- ��t�X���3�ǳ4��ש���e�XH%El<^�X��X)��}�j���],j�8���J��UW��V��S��)F��k!�^�Y	��(�7��5Pz>�6=�������� ��Xd      �   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh            x������ � �      �   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
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
�9|�� C  ��};���ĳly�g�1}�^l0d��}�ݴ�&��z�!���n�P�)Ǫ�����j�p����GN�UJ�[ᆒ()���`��jlX��7L5j��N�/	{��(1�4L�k�G>�N��H4J,q��LR�ރ[��ijL ��e�<ZдwW�<ِ_�J�_�O��tq�+˺����]�w)��-�r�sZ�M��zP^�7�X����$������.�3����:?b�>��
�>�-�vǧ ��1����8V�z�q�^�S��U�Zyl=E)nT�ZqC*JJ���V+n`�D����Elew����}���(ȋS/��G&�K��`D��` ��� �95f�By���k��T�M�V�A�����D��tL�V��ќ^�ğ��{Lۨ�hO�����Gn�խqۙR��.�c���.WjD�]�q�~<��k�5y����׻�A��T{`ƚ��ҷF���#�%��ʨ�֞��G���0��lk��H<[�S.s��Ά�Mx�V�l�@(�Ά��lN��a �8�>�:�1�Ά���'�Ά�Ě@�Cj����J]-j�C:|U�a2WK4�l��H�6�8k�F�c�ؒPr���0�Xo�:�f�Ά1+��i:�:�(�i�yH�A�s���~F�Ά�Ķ��-�Άa��՛Zg�8�S�Vg���Tq�hu6�)��S{'�@�ũ��j ��Y��a ���Z��a�\��Qr(�V�l_��	8&`Z0-��L��:��Ά��㤴\��a �&PZ���0>I���к�u6t$6z�ϫu6�5�K;�:�lr=�����Ά��;.����l�[L�~��lHn��.Pb���0�X����u6$��:��\��a ��G�Ά��:D��^g�@b��Q��a �Q����0�����Go��0,.t*�u6$��Zu6��Rg�p�)��o*u6)u6�o*u6�q�8'�Άq�S�l�H����l~Ԋ!�P�Ά�Fm�$�wZ��J��A�^g��-��ku6�Ҡ�ث�a���Pyk�>���{U3T�&�����@�wxo�eM�g��'{L�m������C���T���E��S,e��ꋸ�pfY}�C� ��)2a��,߿�f��B����R������&��=d�Ō��}�S�Fݿ`f���@2���5Q��������׭,s�&�ϋ��������l��x�u�h���d�Ě���՗Q�"9����߷���������\�$�Y͵-���\�;���Ⱥn�y����s ֖����1�pyƚ�3)��X~ew�'l5�З/eL�--W�Q����uB��op�R���m�Ѻ�S�����.5[2��mq���~�M/��:��V��V�:*�V�����"D����K�ǧ�V �/udמL]�]�/���ⓓuX	��8/_�oj���+2<�Ԟ�����Z�ߖ&�cZ��|�7�5S��1����R��Tpy|ѝ�e�]o�3�Ւ2>!g-���-?�'aMq|��7��5r/=[�9pq_��x��a~7���e�t��B��}���Y�S^��������5�G$����L����)L:h��0Q�4!�K�8��B�����e-�f���5u_0���/f9��4Qh��_'3Qh-�?�m��Z�/�`��,ߗ~0Qh��K?X���&
�뾈��B�|_��D!p_��D!��/�`��n�q0QH��/C�($��'��o�w�8�(t���v�8�(b:EL��N��ϝ"&
��}�8r�v�8�(t׈��r&
�2r�v�1�($C��c03�� ��S��D�q�k�N9��ya:�L�<��V0��𾰂�B�򾰂�B���=��
�?�=�T��T��t�.n�P]��%�u�$�qǤ��V��r��H���2�V{��������o���u�R�1��c�桳=�מ����K�k�[�qZ���?����Zq}���B��$�ǽ����&������Z�w� ��aW%��*��K���<��>����R��d���p[养W�M�g���2�K��N��&"ہX}�~��b'������%{��Lw��_��>3����Is���y�4����ؾ��/�����uK2�U|Wxx����Ԣ5���;Ï���e{���Y^�U\�b�g.�Sy���(G{{�����:���r�i������G�>-!�-���T/=s�T뫧�wnR}�r��\���d���Oy�x3�G���9�׭�)�Ve�5��|G7�������*t��*����\Ur[}�"hN3�B����r_JNax������kā;u�����G�zdk^���N�T�a9`!+��S �@�rO��0_eǥ�.�^�A�y]�[�I�Z���iY_۫aRu���rx����/Z�á���4n�j��a����ɷ99:��Co����������Է]o;��X��᎞Q������ik��;��㒔f����2f���a�Rd�w��#br�S���jl��ex��C�e�1q�Z.�J�1�ǐcs�U���T;_��]��<ۈFqj�D��+�H�ŒE��?0��'���'���Z���r�A0��)�� 'n<>�����������O-.m�O�����Y�ڈg(�v؈퓍��q]w��.��c㱚�������aʚK&��II��<��J��D�h%�q��η��r���%��ɵ���ɱ*O͠,u[mǉ|�n8�g���n^�����c:������t�RH����b!c�9|4��d�@�Ɉ�D���^��L����;��P	�>��m��V���:C�g����q��"��i�۽�%���y���BF����s1������z�-+      �   �  x���]��6��5�b�@~��b�ݠ��Nv�
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
.>�pl��?��kp�6���6N��%q�VUx���u��hk�@�9[[�ݲuK搭�W��9aǗ@�������ꔫ�z�N���ǫ\E��y\�*R��(W�;�P��wl��*>ȷ?�%Y���7)���5 A��xE����@��e�@}�W�y�0:�P g��DA����3�:�w�\H6�s�L!��=\�|l��զвf��Q��|%EB��^D��	��4�:�]d���F6b�����fvC�Q3W��[��92O���F�R�E��U�BgT��Z�f�~߾��y!D܎}�HtO��.̄�O������]?�      �      x������ � �         �  x���MO1���_�So�b;߷�ZU�8�$z�R%*����$�,M�м?c�����&>h>�^�/�ֺy�P'�����G(�4.�/��^��A]�������Yn���a���G����VEF5�R������n��>��1��t���ÂB��?�^f(L�f�
����#�*��e���f,Ѩg1*t�樱����db���Z���<SD��C\ױ^��y��� F%�	ɐ�5�$-@܎�����Q�c�Ĕ;�^����e2faPZ2�}�8a.�;P6�M͊t_D�tL&;���s�=>�`�;��U�)��b�����$��gGZ��� �"v3��2��1Vkh�HϦ��͌����}�An���5�\n��}E�T��� 5�(5�k��O��tS�H;Q�X���H����N�V�QY=�P�zvk���L:M�P�*��r���`��˂E9ǫ)�x��
��feZ.���>��� n�RIX�I.њ�*��`��|5v� V�Q���(�4����}���W��׋�����uw��x�n�W�K������S�ДG��`�w�6B ���rHo+ŝ�*����p7 ٳ$;�]�mKy`!>-���I��F�L�Aۑb�!)v��aZy2����d��?;#JV�Lf���Hv�U�Le��Y�vp�b��˵�˫Q��b&�C2c�ݹ�Q�#x� ���H         �  x���K��6���*�n!RK^D�A':��7Qʏc����R� 	O��)J"$7�C�����_`���sl^��ӊK���,������۶_�gH 0��&7Y������(�i`~���n
��e  H@)ԏ�Ai���I�/~�/J�5�S����_������;[ ������5�5��n18gp
+���8
�T��G�ƍ%��H�0^a2a6�sZ���YQ���%*�r�}�-�<����Ь�F�Y��bQ.�ׇ��R�XV���8�Y,H��ȓ�:8�ǣ�<we�S`���g�[�r��IMLja�4�a߿��� �A>��H�E�������A{�����zZ����-d�1F<G3�8̵);���Ze�U.�5�1��3&� :�<7��ʃ׺�j���Z|aJ�׿l�Ǐ+$�:U�2�U Q���)��bST]�,-J�����-os�Z(d�4r(Y~�Ǌ�d*4���@xL���5g����ef��r�}�z��NLK!I,`$`�Z���!d9@qv�/r ���0���|��(����(���x�_V/O^�b ����_��vP�'����
�JJHmp�L�(�%�fB�����/Snz�Bn��xlyuS���W(��㒷��8���	����+�ڽ]�I����-D��Ezv�[T�E*���b�r��|$�܋B�|���b� f� y�l����뾋�^���9���$q���p�I����%��"͓T�~!5�}�ł�9f9u1�%_���f�|rj��'�('��G�Z�S��LN�Ґ����]��ԁ�Y,@��f��[bb�#l���!T\3�A�nf%�K��z@�W ֨<�,� `f��!߼���W�.y/�J�G>Hy���#_�̲ˇ���d�D�^���1�Z�
���. J@MK��H^O;@�u��ɒ�C�[g]vp�E(3�[��}�y5�e"\�L!�bm܁0E`���{��!�Ј�A�I�v���{e�~� Q��<��;�z�Z,�H��V�x �����p!t�)G1K�N�z�����x���WGH����#�?O�^��H;�N�[,�B�ETI٣�"�5��F�F�1���H�H}J�q2J�.:��!��� Ȗ�����$�G��җ�#�l�ӗ�#[y<P_����K_���e������2���C�7�ͷu������v��7��/fi%�"0F�ԣ_�ԧe���a\7���-V�I�
cf���0�}k����
�d��{}ƕh�}]�-��� �[W�@}��qv��ܘ�4�Z?��,,�ڒ ��i��7��ڐ��$�KR���q���-��H���Rk8�?�aTwg��Z�=I�QwT��H����y�HT������
��4��D��T؛��k�(�^_���ms[�U�y�YZ��u�6/_��2ȟ��\^]�U��e�0j����9m�ĨX�T]��Jcb6KK_�fE�^_�8-�e��
���7��+���f�׊]59�[w���T[=�X����o�1�Q��'�.�$�u
?U��>����:m�b��J�l��[��- �"��}�����W5]$�#I�۩O�Htݥ����8��vUT��,
	Ԥ�_���,6�?�y�ƾ$a      �   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      �   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      �      x������ � �      �   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      �   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      �      x��\k�,���]g��;���Qk���c�$(K��t���P�	��T<�Oȟ�	�����������k��1�ɰqP�'eJݿ�*5j�(����a��T(���a�^�5m�D�J�;��{Pj���0P�'%J�ߴ3���4�T[2�Rϱ��NS�kH1P�'�i*�$��$>M�w+{x�d>O�7$���W�mN��`��'S���7�Sl��'S�ϡ��a�ʈs���a���{��L����\؝R�7�kX�^��)�~��^�O��Zܷ6�_��1M��k���ba��o�|1ߪ�?�H���T#>)��n�cVm"�)t��ۿa��4�S�S\�e��������u>�6s.�0P�aK�n�%�)V�6s�h���ĵ�sl�a��^/i1���*m��z@1��8��:�z^��n˰	aN;��ݦxP�v��sl�a�ru���6��:u��)n�u��?����}y��0�z�P�v[�رg]���_�׆Uφ���b�b{udC�t��f[�XV�hX��c��pk�11�R�h��bMC�����-/100�)@��V7���:�8��l��l0ja;�5��zQ�O����܀���7����_U����)>"h=�%6X��3���Kj�R:M!��0Pw�[{3g��U�?��֬|�p�@�Ŗ�Mg`��3�f�}k��nc�|������baxo]���8��\�궬��0�>��v`�9�K���f�."\�ϫ�9�K��z�wuq�t���j6���̹��էQ�a9nV��<n�;���{��|lٛ�^��"f8�%,���<˕n`����A���=�a��O��6���ylp��|`��{YkV���p5�"vkZ�ugɅ��mt�0Muuv>Oq�K�nO����ʺ:�U�p�|��B���OT&s���X��t�Yr#n�Y�t��3#��ȩ���7�RG8�.�Yu�nu*ͤ�fe�%U��y�c��|�͜)�:_sX遁�N������cF0��Қ�%�50Pw�8���R3�^B�KC��n�\��-N�jx��[Ϥ�x�0P��C����9<�syoj:-��גo:���<6���)N�R}��6�1��E��%>֣ΰG�}�u��a�{�_�:-�Ɯ��NK���~5�S0��8��yHfp_ڰj�״�8Ňk��z���޽V�;c.�k+w�V�S���cISL��jȰ���@�d͖�����d����c�ϯ5+C�]%=c��a����U�*9\cм�|U�#-u����Hp	qd�{� "Iqd����)Z\�jm��*��DD�����V/�׆�*���늆�*��c�5j�GjX沴��*�����e�z�����U�2Te�-�YM�0�:�p����^b�k��8Ұ���$�U1��ҩ�b侶�t:e���Nlkz����5� @������@�Fq�i:�4]h����!qM��T�)M��-W�0P��v-�r����N*�6�2պ��a��c�ѕS{��ʈk;���nS1�*j��S4�:b*���k`V�L��ؖ�ؖ�Xr���iR���%h)ARXܗL�� �׃���m�̅�չ\�y$+���ǳaиO�w��>�]��w�����w��a����r�E~�G��}E(P��j�IjW��m�j��t*��6�!RM2�R����$1W��00(:�;��*���$|����`J�K���)�W[��
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
��0��ty����ׅKGc"sG��YB��f�v�4�5z�l�~�$s����$�I�n��mM���c��rǱuN!��8�ٕ�׾WNl�o��)q�l�ֵ�� �q�vaX�]�ob��m��k��ڐ�Њ��:�Rh9V�s.�-R�������z�v���6g�֤���HG��l�8�3��v�Mw��v�阭[�i�}��Փx4�J��[��C�lm�+�L�|�F�A"�I��a�0�j�,H���ُ�7�.0d-��D`�ُ�d��+�e��3��:�/���^�����	è��ﮁ`�ؕ�;�0t/T}6��]�ҳ�k�̍��Հ!O����:O���YG�n,d���������LQ[o��V����ɽ�I����JGǃ�|��m�p\��6�Ɛt$kʑ��<$���ʰ��Y��������3��J�L����;�m�^�M�7��2�cU|�n�MYZ����La��;�;P$@�f^y�S���TӾ�k�JJ�\�����v-�&��NY��,�[�\u�^�U�*QI�޶`��T�������      �   �  x��[Yv�:�N�"p�F/⭠���'���$i��K.4��E��>
|o@�O,{����$2�紃?�lm���sީ�cC��*H�{6����3�S�|.;vwl��oD�a�oD�9��MpE������==�ؔAw���?6�\ec��h�Z.�[%�N�4:6E�7"iղ������0us��*
�������s�!}q*��O����8�=������iǺ��z���<o�8�n����s����f=����������ǹ�e�q�����髧�\�aE��	hu������oO�����t{���Ę��Xx{QpT>B�� ���#��ag�*��:0���G�*�80�����@�	�yS)��>B9��M9�Q+�3�hv�Q_��Ԙ�@*Q ըJT�%ꍦڹ=A�
5l��;ר;ר;�(j5���A���E��D�YO��S�$�%�H��|<?k<f�V��G�/ť����e���O"K���Y��Q���tQ�eh;��6��� <f���-�1��ި�����xj�ŭ�o:�U;�i����c;
"$
E��y��v��bUhD; W���UV+f<8L��a��:�'��������3��@r���n]���>���O��l)�!(�+CRC�$lY�I.�Ѓzu{������zP��&̯`#�YmH���k���X爀
�Uf�e�� UYL��K�V9� �H�a\E��+��EWT��l��6yt=,F�U��W�*�VE{���$��r��Ef�I6ar�1�E/���hx塴$u��p�CώmX�֕�8UR� ��}^�N�� :���&�z:�V!)t~��B ��	h;�7]�ɬ�i Ϧ���_�������e����z��m��F�f�@�m����T�[�|������K�9}���O����zr�dDdl⛼Vˌ�N�� �5���[�(m�b�G��=B^�)J�/���8AP��b� l� )J�F���	�u5E{X�)��(�O�F U'3�Q�����;�˗����e^e���;k�sT�?n�ǝ�6���}���]���3m��8��@w�P����#j�6K(�<%��=�Vd�gц�h�v|X�v�/ߥ����.UH�+Emm3Q��D-�x�)6���1�ч(�آ �Q'������3�N��yE8yőB�c�F֥Ud�7�.ꝳ."�k�.T2I���~��Ϧ�@�E���~��a��l��yRu�u���n~�� t��`\df��-���>x�E�pT`X��wge����ag^U��n���ꁷ|	/l��A-�MceQ/���F��i݁�ƔH�AY�K9���:á-�#��>����c���W���3��o�%}Gei��k�ך'���*�q�2,fr�,Gc��*a�/�eo���o��$����2ca�	1�a�POK�Y�+�BMq�ԂR٬��(���Q�������W����BZ��Pn|4�%
��喩��tSR;��F���C
�I[{��2h�
��e3j偦	��)Oo��]d*�qb�X�ԋ�¸���D=!P$j����A=l����㘀t���
�7��&�t}��z�����]_#��U��9\O�.����L��}r�(��J���� L��h�� ٝ~���>`r4	���/9*� 0���z�,!�Y������?l���?_���RX      �   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
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
      x������ � �            x������ � �            x������ � �      �   �  x����j�@��w�B/�0�{��m/L!q��qj.�v o߉kA�
٨#�������Mٕ�S	���l������r�[���a�Qrī�Q������~l���y�z9]-�Ŧ��En��,���4ְ:<���JX]ߎ�0e�,�6./q
�p��p,�a���]��i�E̳��P2���,`��M�������}j0�)�}�� ����TN���ݿB��ؗh1��[�������������g`1M�2�n�V@q�6��T��
�R/��s�ˆRF5QE�"��?]C)ϼ��b�g��p�)xG@�Ꭷ�����ӈ�]�V��Q5�C�>�S$�Sͬfȫ5��2!@�3+�֤NZ��Lb�j�;�����K�F��<�۫n�Mn0k7����E;��<����i�3B��̰΍��T��m�h�b(Ql�tg"��Uپ���v��q�fMU��+ �e�Q�      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���            x���ͪe�������j")~�]�16�q1�)�j�k0ԭ�����V�J)�>u(��������Z�_�5ڀih�������� <����������N��:��_����_Z����ȼ����x	����������������1�e$]�0�ցG�����o��l��A���B����.���� ���:0�_��?��������?��_���D�5���gD��Pl��9��C'8�נ��Gso��h�x���1���v��/���X��{���]����ۿ�w����ǛM�l�7b�9�������?�y[�?l	?ݙ��4�V�����%��+u��;��(&6iS�<��.'�m��o����ب�����C�WoO���;�]������;�&�S�RB�o!�g��GyuM�d�R���u���o����?�h��}�h��Ȩ�.���@no�?��&{����a��O+d�n�5���J�^��S��o������u[	��{C�^�2^��aZ�Y!�O� F�� vb�X������4{߇Z�;s��o����H/!������Z{�Օy����LS�{��J���/��W5�b�B�����5��/&dL?�Lsg����q�s��GC�4	=���M.�!R�I���&/T�����s�S������0��$T��ء��M�2v�
a�J_ ��^	��+Ĥ���3	%�pb�
�~wȞ�$�����I�ayb��.��
�~�iP�!�)e�	��p���B��0�H��JJ{���zLV��s�4��s��m,��?�m�!T�X��+d�F��c�ܛQ�Xl�0��_{�%~K�Zk�Q��D,�v�&ئ��ӇK+��2�=�oȇ���!��cB�R��W�����+����9�B؟b�<��)�l�B$�X;'I��&N�Q۽!'ao�����S�}N�׻���R��}N��v��e��4��f��7awb�3�]b;���\�ػU�6��5��tb��� ��i��p�a�ؒk�yz�aae�昬o�tt�h���9��\*<�r�JQmfc�4�6��H5�s�����W�s��O^�Fn��$6;�|���э�7�%�����FJ��f��wSNz�	�.!駲��� 4Y��-:�k.�/@������&~���"�ng#��/�aZkv��[��zt�H�pw�P6�ݯZAx���B4��K����]H���j6��%�ROƮ+d���Cw���-��:��1M���R���V�kt/��0��sg�Q�&��N��ה�L��Mw������?<5�aֱly�c�d�ٵ��'�ϽЉ7d�ُ�k*��~��vη�b�4Oxd�X{�>�a}��y�xc�?�;<;/�D�h������xh<������ωGL [���������5P��Iw���n�B{?3��V22�d���DZzef����{�5�(�K�=�o���+e�6�D�8Qzi(�YJ�*�)e�)U�(PoЎ��j�����J	{���̟��ϲ����%�P7˱�,{��[��yS>��=�hd�v���+�SQYFr��KZ��(��ܚԒn�U�]�����p)R}�=��j��^k&CJ�TؑO�g����ߦW�>�e���\)�:?5ʦnwݰ�@[)�(65���=; �/���D�YI	"U|�!�Y��Z��X)��$`ȟe��V�;ĝ�}ڣ�.@���>}�UF����	7L�e�~�¯N��1�G}ta���x������R;���������!>��2�����4[0Q�4X`���γ���q�:Phtɯ����Qs�0������,0aD���R=��22���=Gf!'�b7�\�*^�0��BwS��j�ށbZT�B��!ޅ�4_���Zc8P��G��!����{3�q^J����B�E�����M�{[�|�Au~Sj_4�B�1SR�$�1z��S����>�������>�!Õ��Y�̪@ĕ"�뚜͊��-�ޑ6e�@�Z(��`7G��)��#��x���3�xjE�E�sw�3��м�:ء�9gޣ2�W
�0������"/Bۤ��P������2��ѕB.]����)���;�|A�� ���)h�=�-��C])ꑻ1��t����(d֞��R q.쿻�fHg��j��@a���Z٥�I�~l�F�@�\˖b���:Ƶ��և���\�IZˇ(��s����a��	8Pp�Bz�BH=��A.��.��=��E�h~��x��I��:�+�g�yJ���u�l�"��#SGϘ(���N��AIϑvp���b�<��ju<�O��Nj?�J!ϑo�g~�<X�
H�$Y=�W��/���{����J���=D��Xj�L�R"�I�i~B��E�,3]��^I�W�tHz��G�^~������ )� H/�����R�I����͕��E���6��r){�����7��*�R"�,�/M7�C|��B1�m��Z9�۵���X)#��Ui䵘tng�"�JAwE�F��M����+��N���м�:�i���V&ϛ�Vks�y�L�G/�	-[��+|q,����M���>���t=Ǟ>�,-g�)�ѵ�T%S	(k�v �=���%w wz1N��)�TO{G�NO���Wʕ�<��b�q�j-{
	�,]f}v�~��;?�m��NG̭X��N��~��J)^�?F��n�}z >D݄
���R<�/*���W�d�\���=�Sl!#�w����o��J�+IV��u���"+ť�˴`L�����+D"��dw�D�ptw{�a�=J�Z_��R��- o��s���+�a��{t��M���W��P&�Į@^K}tu�� �>�D�C�
+�L!{�]"�UEe���2��1@W;�yM��vzKa��<}#QF_RZ(���<�%�rt([��"��)%z���(@���G�һ��R����3�P�0����	Δډ����-~E��lp�.���ؑk�����.:PTgR�F݊�����9t7Fm�(Df~䵔Uu8�Jq!e�.��q5�r-n)�՛}��ϣ>�ʀ�>�Z�ξP��I�jg7Q�<�s��҉gO��1�\�EM�K��!�6a��_�iO{�{TG.�OzӖ��!�6Wai�;��Ź��
�[��h��R瘫��8�~� ����9�ʗ��Y:���UD�t'�}�\���ޥKdRu}����BwΕң����5Qj�{�� (�jm�\����¨�+(}���Q*�'s|`�.Pe�H�����_�w9Q�%?FXJ]j�B�	EGS�e����8Q�vZr1s)uO�\1�K,�.5\)ac�����R��¿��Lr�\E���F����.�y�f,��'�bǑ�RJ�-�4 �\8y���j�PL�5�F����u�k�S�1�(�����_��h�I{���
����L�]�3�蘳�g"�fG&�y�{&�I�S8��<��*�=��G��q�=�z�r��kw�$�s��(���~��V{�m�'��⭊��LwD�m�ۋ�z��هw�81G��1����ȄH�?�����ԝ�'&^1�q<��� g���}�묆���){��,��L��I�L���WPuLj�Ffz]䒴���ZPҥ4���]s8ap��O��6�,���cRkA��!(���âY#����r�\P��l�������>ʅr�=WYM�L~�*-hK1�RJ���q��o�MpST�J��@�~����r�Z�ZØl��H�6\�+)�P���_ع��R��|���#�|E~|�,������S� w��kѕ"QW	�T�㢵t��-#��ѕ>����a�4L��V�2U�D�9o�
wPk�X����@7����Nl��� ��=���X��мE8���>�c.��b���y�_Tv�8Q`��}�Z��X�����h�n�O�/��vc����fI���r�vo]��w�R�Mh�J�n+���YFYh�J��ʐ��~Sj�;d����� �٘��9t�x�%7�)�{��0#��P<�����=���(S��%�{�= �    ~��A[ �J#%$B]�G�W��`Z�.oF��I0VD�)���V�L V
E��P��q킲^!3�=��OQ�ԧ���>+IN��Vf��7���0�VH�R�
�� 2��^�-�2%��~����#i0��|\?��d��R\{�v:�sZ��A�VJ�
��=�/��)�}�H|�E\C����2�<�uJR\|�u>P�mA�@�%�2��c�;�u,����,���uM��P`��lM9\.e%�B��Q �f7��Go��=�Q����ukg߁���C�q�DA��s����&��M1�bWZS���O])��WqۛR�h8W
E^�dג
��nW���v�}�s7E�¦{��S�M�<��R0����
qe9)�X)Qh7)�Q�ǐJ�JP�ȍ����n)d;����L�?Q �S��P�vT��P���83��t�W�75��>?�PV6�)���͌���&��(`�םo����
��T�P~]Y)�Ƿ�yނ���=ľ&��G�Ã'
z���@Y�D�+��4|�F�#�����D��r� `Yش��?����M�m�Lx�k�͕"^�:r�`��q�؅N,�����!b������Yy��-*���J���lj\~Q��r�L�R�Dx��]�O��h�2�������aq��.��]�N~��Sl����|ߪH�i������cU+�G�p��Ȅ_UO�=�^j9�
����hǰϞi�烜�W/!y�f<�I�=�cyȁ�ޯ����|}@���-�\1#��;����1�#L�+�@�n�\��r%�E�+3r�5�2�yO�
�=��kVYܹ#(n�{WH�����{ �\)�n��7���}@��Ԗ2=p~SϹ� 粎�5(�����es�k�$�u\���f�����Q��㊒D8'Qjr.�(�N�e�F��t��e��/�J�D��v� 㢨���Ik���H�B׼����	�o�F-�G�@a��rG���y,�?Q|O>/R+�2V
GE��^Y���X)�;=��K��l)��TR]���'�-�mB����♄^���Ԋ��J�z/4K!{n���]/#��C�ju�J}�@Aё�6��u����������]IE��!pw���ZR���B
#�2m_���C�nK��&A]�G��:�1 np�<zZ�]]E�?�j����Q�EW�BQ|	s*fJ}vu/��j:��|�G�U0�W�������;P���:1��E�|�Hׁ7u�gwKQ��^R�(���UJ�co���9�0�d�-�|xM.��ztW�O�h�goƬ�[�I�PW���1��H˔Z�U](׬$�4�����v:WJ��h&n��1Q��̶R(b�/�#%
�{��1z�Ee�!�}�@�/�z@�Ԫ�+����~��ߥ��
��I�� �j-�Rf��B���f�ąr*�����fځ�M󄮘�PĨ&��+Fe"7Ϡ���h�/�|�u��f�|�MY(v�܅f�%���!tw�J��u7M��Bb���a�q:��,�it�W��iҜ+%B1��p�u}��J�wS�foy�K�{��x�D)�.��P�E����E��
2VH��	�y)��G�:�ۍ�bndFZ-itѹ��:Q�fC:Z7W\)ޥ�^�)��c���u#��蝎K��^~��-e���U�
��i�0A�6z���t������P��9s�+��'��*m4�m���smJ�rE�b-�����g�,�����"Q��XO��Żix(c��b�;Q�9$y��]�+�ܩ�:Gޣ��&wZ)|0���h9[��-�˗�&[�>��WJTv�-EP���a؉bD�R�uU��*R���w��uU��*R<h� "�)�k�bR�LsI�l��h0�W�
Ou����)��M�o��do�}BBDbN��0��X�>����c�����4�SmǁI�
�Sx�KV%M'��F%G��
��:0y��?81���q`�뵧�~����F3R�@�=�=�
�-�ޟ�=�{�~x 抌�vS�F��b��<�Q
K��u���kz�\OΝ�E]��-|0��L��ou;ޡ�z���-��1�=w��tg�İ�y�(������P�M����~(�2<�v;]c����O&�ׁm������!���y�
�̳�t;�'���L�g�}@�OEc���HOM��6��۶@~xl�1}`�(O��u=���v����{vl
�q��� ���v�Q��{tnHޡg��=�������ļ�[��PL���m�Ց<�쯶?�ؓizo ��/�gυi���$:���&��'�פO�Qܕ����#����>YP�D}O�9�������Vq*�r����Bh��f*���jVJ�^2�8����F��ʶ�(Q�8U1��uKRNe[_�+�@9d��jE�Ne[_��g��xC�f7���.H��� ��.����v��/����{�Q��5����|h���N�o��ۡW�m�v��,)�����ͮ�9U�}!z���^{�� ���zW|�w]T��U
D��gH/T<U�G�,Oz�t��ۦ\�P�=�'.��e|�S��$��
*Y���m�pT:�;���r�h�~j�R�:����Qf?�m�~�;S#Ь��K����gmh2p2M�^%oE��4o ���ڀ&;��������K�ts���~�z&�����m�~�'%ɔ��G��H��O��A����:�d��DptM�YO�T�}��EO������I<����"?k4�z�S�����#^E��E�B��?K����;oU|o?���su?~����v?�ǉ�o�m	;wPDO��%�g�A����A~�������[��V��m�פ����o��KS�VM� �7�J�jP�;F���)>�4 Ew��ŕ�b���6�עZ˞�s����֢p j2��!E����P��r
^4��~Ў"�n�T>Mu?W�Uf]���3v4Qꌅ-�nE���)�i2�A��L}-ȡ��]HY&�p7¦�	7�������q��:Q̪l���@�WWJd�ړ�6ʑH'�Y!�y�7�(�2W����o�D��=d�T�se�)��94=At�Nu;W��7�|c˝�����8��h�k�,\��xt޸"y�L�=DP]ĕ����Ĕ�� �_D�0f�	�Ա+A �J�(o4]!u���\�R�x�G}G��j-��x%�D{�[���PQt�DW5����pt�
ј9�m滈��������T�sej+ez�X��EÃ��Jo��&�!��3�B�ku�_L;O׈�G&X)�>^+�n���e>E���Q�W$Z)1ETDs�hp�E��+%]xp'?�­[
xc�Q�D1��үq�o���,�?QD�
$J�0(s4��tY��+�<ߘ{���TQ<Qt�����j)s�p<���ޔ^/eO�p���Fs[)��L���C��-_HsfE�k��}�|����
U/�,ײ��#���ɺ�x����%�(QwYŤvH�ӽg�a�>Z��b?��щ9åu�U{��Y?ǒz/ьaKϘ�z�f�I>�(HSj����	?�"�q.V��G9��L32�`~�)�	��n}���&kDdE��ң1y�xz*�N��꧿(�>�Z�|�{�8[�u�UNU�_
G�I㔱Du��=ŭ偩M^T��{�����ϊ�ZY�E��E�R�-S�8k�u�UN���*�`�^�<���Ń�)TF"��"���������Rit(j"*%GQZ��;
ztrd���ʩ:����f����J+~с2}F_>/���R���`J+�z��ԥ��/JL��N��gԓU�e�R#Zv�\o���ٕUJyf��uL}���Z�*_ Z��@�FǇФ����0{��\�(� �`����4�Z��KC�!"zU	�<-ǋ��:��~�M`ֽVO�z˼E�t�(�c>$5g�h�EWHxz�AKe���ϲ�؛�c��Zj�Ɓ��T��JE���b�9������̅��0U�q]�y��D��M�����2�}~3�2�U��*k_)q    �Ѥ.dJ�1�X)���Hf��9$
���l�P,���`K��`O�����x��N�2����r��3�.�w�E�����'�P%�ߥ��J+%�-�#K�^��-ž.w��]jmWo�۽��Bj����H�)�{�נ���?m��
����dts�ouO1��g����*���ywqog�|8�;����:�R{��&��	p��4���HL�ֲ�@'H�������-�n�
R��_���W
��jc�B����̱R.g?c�i���j8a��H &�cYu�Zp�����\+�u��e�J�I\��q����ոn�ʓV��Ѯ4��U;[
�!eI���J�1*G���#�@���ў9����ܫi���ٿ�~D�
�Ϟٕ<xb^)H�J�=sL��26���>�=]+8�S���i�����Aʁ�!
�4��O��=�hw�Aԟ��_����~���W<�G�	h/�]>{DV�q���DyZ��)H��'{��	�x�O�[B��\;?[��s�\�-On�4�D����tK.���B�%�HA=��=O���=��q/��Ïw��py��޴u���p����&�`{b���jx;�-o0\���o��L����u7����wػ*��h[�<�a��b����Jѧ;�*������Ag p��� ����bz!�	�]����Ӌ�m�-o<��h5����'D>Z_�&Pí�L�GG&�g� ���2�GG&xQ��ߏ�o	8 z8�Oj��gHl��,�1p��!6��U�y1���6a{I��;<��q����+<�.I[)�O��5����m����#x�f̫������K7�gZ������S�J�?����"�N�7�b������hy��L�����@_<�c�����'���{���Y9<l;�C=������էz�4�����XѺ�f��x�����M2pR�v@~x��k*i��T�g':pFkm+���Ӊ�>�t��#<���lE�l�t��k�7����7����w�;Q�&:p{^��;@�Y��_��	�Y�*��|ui�4 �D���M)��rjP���J�:�Z��<�i�Q��w�z�vQ܉��=};��3h'��=}<�'m�V7����^�w��Gyx�8�U��Ut���E)B��5��=td]��zX=���3]�˶w@~|s����'��K>�b�<�z?�3���枀v"��[��z�+:wO����G~�7M���#1p��$��@���o��y������^�f�ţ6ik�y����쉒��O��E����ay&.��{:���� ���y��8�
'z�)�V��q%&�o��%�[^x��S�攽ՋA�a��wgo�p����pӓv4|x�74�-v���݋b���op�P"�����@^� |��"{j�~G��<��6�<�T�{ߟ@*8M��8��+���'e�8�M���N���о�#��1Jkڹ޿�@�dTҨ��Ȃg�����0ȳK|�L3ս��a�'�����m�B`>������뾀؞���m���J<���b$Ι�۟�M�G��>��D��T����j+��{�����8>v�^D�[���'O��^���n*N4tz��Yq�e��ci�H�Ż&��Β��K��GH�����b>;��R��J�qQ���!�E�(e"����+��YC�W{�����M���@�H�/J|@�����)���T>�L�1�!f'~����>�
��gœ��g�6'&����)N;�:��W)i�������w���NOO�H��N���^��\��W@�D��:d|���p@��#�m�Q>�Ih��	5 e����#Cgk���>?:���}���ὔ����[�Z��G�L�Tn(\��<B$x�=}��v!��oHY: Mȕ�k/��
��v.��&�1={7���(��c�%R�H�۫���A�����}҉B�}��,6��W�����'�H](��Z\X�A��u]O~�1�3A�s��
Qo�$� �OKY9�>���4����ſ�2�<�$��W�C�,y9AFN�_�:��M���!��/��s�y5�����:B_!v�<����:��r����̗W�B��e���\(Y�ȹ}�hY�"�.��s��T���$�)e��t^)1�kػ����j*]V��N�h�Q�vu���Jڴ�r�:d�Z��������G/���lMP�'n�'�!������R�Բ� ��E�[��kc��9мx�CMO��3=����G �T��Mf}h�w��X��2�Rʶ3'�`FJ�Z���c�C�m-��G�.�Ƕ�HM�o�I[-j����k�ZԎ�@�ܣ	��@[� ��^�����Ĭ�x�I�?�OPOͅ��Z��tÛM�z����]�ZO+�I-A�^'�����<��]rS���a~Έ�4�Gv����o���|%nrO������X!1:���S9�݂j��2<1R�S���ʀ��z��k3�$
�����.fȇ3;
B$M�R��R�0����v�~��o[��۪wl��p"�{)�d�.��&9f�ԧ�/Ȉ>�L���&��!��	�z������w�@,��V���C�����IΎZ��P�;3x��	u`��=ž,R�Ee�߿�km-�4ҷ�����;�O��pfW�+ے�x�Q;�qm�iZɇ3++��=d�n�Z/�qW���¥�L��
�J;�J��uoH����B$�.�9�>��
�h�1:�&{Z�.c��N����=�L��+חLH���~p�(��㖣�p���:L��R[b}�-��[g����'�Oz{��)ݛp�B�Šs��Uj��V�J�J�]�k"�ab��Zw���B|Fo%�N�q��{L��&Z��Е�������?�P�y�����F?���D������Jg�&ґ� p�m����A��m]*���g���J�Q�����^_"8��@O��/�|����%������DE�ð+>�}L<2VɃ�@�wYL�N�g�öRz4�ɩ��R����q��34ڜi{�	�˓:"�lG�[%����,�����g�v�IJr�ny�Fw�=�~/����~�ۺ��vAvG�Rcw=�!�#}yS�����a�p�q��n�;\k�Ș��i>�ToL�	Ґ ��� !3r�ղ>ۜ���ߐ:���<�M��_��H{��\m�G�x�<�<0�1�R�<R�!�L�}`�fྐۘ5��J)��b����P=P����7k�a�� q�[��>��Ĕj(���Q�S�M]��A���'����sUN���s��Y�{&�]�3���W����sL�LC���0D]�;�!��FGh�ȣ:���H��_1�7nu�Zɣ: ���}��'�$J�i��rM�kS�}��N�'�j������r�d�w�o��:�"���~N9�D���4(�����y���Z��Mј����O�,;wI��l��F��yH����eOhݥv���R��=�A�֣���2�á�$҆�-
j�A��So��(�ˬ����曚��"�@�(3�j��r�g�>�<%(��M6O��\;-�{R����f��u��2��y�h�XόX\��~�@�5�Nԓ�lF0����(��b��A�C4V��N�Ӝ탸��2�w��K}/�>��@���@W@�K��ꢻd���+�mnC3Ej
�������l�H�Rb0H���p�wO�i	)jz���c$���똍�Z�ϺE�b-��¬[�
�J��cr���ĥ�@LXzo j��Թ�V
}%���{�jO��,%w�k��ǥ����0{��8@�@|'s�z��*�1Ri}�<�u|���!��Jo�t��i��"�\wjn|i�5��{��'�Ց�RZ+%�jz>{��Ϻ9����j��B��f��=W�My$p}~VLa�&�-���q#��]e=��ͨՄC��&H��ø@��7��q��I�N�'�N�ᇀ�ʈ�=��H�0׹y�����qϒ��*y    ��L�_T�ۘ�I}��9�7��n��e�����U�z��	b�$�xC\G(��]F��#a��Ikj�l9+^�z;U���~~�!��&q��m���Xo�����~�.��>���I�G���}C�'m���m��o�Fd��n��+��ˇ]N�5t~��q���Wl���ג��&ւV�J��W�px0�Nّ�RB\�Wɔ���X(>|�ע]�w�=�
OBMk��@Q��g~(WX!����v�����\�@aP/~yS�܁�	x��~�	.�+`��i�ΤZ���M����֜M�I�!Պ��=Lg�o�ad�r�lAϳL��&�k-f5x����'~~�W�B���� ��;@�FK�z=Kr��n�N�0�O�zCj��!��S�)����DW�'�8�]��Wn���ʺ���su�QѼ�D1����7�.�жR�7�����w)���(���O~"q=����9c�s�!4w��t����O����8N�Ӈz���� ���I�o�i�B�J��?�����E4}�ba�w�����M�B�7N�sSʹx{���6�<�)~d�i�߉��T������B�&�L�Q��G��[��G��"m�;�l�Q+��; x`ː�VWȈ�����8�U�EU��Y���dk9�w�y������E�]���k��#Aʉ�{H��?]�j��(�,��=���õxz~�{�3�m�)G�֓�wLy��|r�9�({��j�����%n&׎mW�Lp��)?=�VMY�3�y��#�kf����B�A"���}�xF����Èq��ĊY4I��$:,�h=a��'��Y+�[
�yrj���s����=,Ҳ�<"q�w�Q��,B�h8?D��$6� �RHس�d��<D���k�C�̿�Ko��H���.������+�0�\ϣ��8ho3U���j:O�014�ѝdS���/��7L}���2����k�ɕ�
������0Z6H4�U�~[M��c�h���p[Mݰd�3,��ۆ����+�����q��N1��au��~�z�1�Mq�P#~+F�p�e��K=�PS�|8ºP����7�M����	~�C;�]��)�܃o� ϭL�����X�@���_���Bi��
����z�+��&ѻx�(/D������n5�g�x���~L�3�����oL������(�D|S����r�������y�H���\�}�M](�n�
R�w1<��fo1v�g���S��\0	h28�2tW�
���bftU���蟟��<O�6]�Q�2`��J֑:m}���ԙ��%�Q;wܧ���̢��깿1�� =�=Y�a�#I�:Tw���~�7���m)&�&K{W���"�[�!�p(��O�a���܄2Ƭm,��荪En�+���������y�M�1��0�b(���̻)2u	���.\z4�M�G�W��ߢ��Hb��o
�x�ߔG���B��'�R:����ΣVy���~�Q�aR���ݺI⺙�F$&QJ�܉��]%S�2:m��V��x�S�)��օt'����Yu)���-ɛY�sWG�N�Co�R}X)��:+�ɻoʇӻ���(3�*� }e�x��j�2�.Ce~�	����*�u�t�����g��7���1���Q:	S�n�抹Z_�i.Sw�<a��o�a��{�m�D 09y���-k�+���s҄�8q}��X0�8�@/��1e�vX1�*��5͘�w\1��8س��H��Y�b�{��G�R����W����R7U�k5�󊉙�bj�M���y{�,5�#��Rk�]��1�ץy>�R� �ƸM��t���uP�D!0A�LJ)}���Ѱ�f�ɉ�A�(D�(��A�J�j��Sn|��b?|(4P��_7�\�E�Ii�#����މ�.̓F#���/���8�)kڪ�	Êҳ���	q��D:�Ϝ�Jp_?��(��A�v�Qe�o�����T#��c�!���G��-ҫ��M@h�Mq��ۏ�-��e��em���k��u0����Y���4>l���c	���c�<��1�&1Ɗ��&�n�\��,~������j�X�	��f�S��$,��Ed�=�	C��3���Z�� �b�O1ㆩ5��+&b`^-xS���?j�Q�Y��m*W�&4>G~�z]��#�wX/25�ݰ����Z�7E\ɔZ^���-p��ZK�Xo�>P ܩ�(�>P�=��)���/�dIšF� �w�W��I�Ed����o_��&�o�\~��xߘD�%����sg�.��
�tN��m�s+�=�������u�Ѳ���{�I�<j�0P��ܟ��M��=�g��aL���L���=B�N��C'5��G�Օ�ؚa�^d���g�D���S���������Y���)�$���CU�����=�m��Yk����F�mJU�����C������xʺ�7+��<ĸ����E�S�.�t���K�o��j��9�j��)B4�M�!#9'$n?����0������*N���>	S��e��{��d��1�l�Q�>����"���ᾧ�<i�����}�u/J�Q�ɉУ��Z���qz�#�w�d�sQ4&�]�|`�>��=8���n���C煙��K�v�>��D�2�֤s��\��&�֫�c�:n?���ZfF��@�nώ�^�#�0�������F��ф�71#�v����[xXsX�Z玟�=&�x�^���p�w�>��1�^0�>�s�a~���)�c��_v�t�=s ��`��]n?��)�c����jj{p�?�c��"��I�� ����o�6����ҟ�#ߔ�(���>N��0�P�X��(
s>�|��G��Zb悡�\<m-z[�?j��,���/�����W��=�qGϾ?��j����p�6S�������j�}�Z��b��yf�W�)���n��荖?ת�c� �⼮���I=!�e7�ϕ{���"ܲ��e��ߟwD/�X�&E����
3~Ϲ�(\U��(��IBԃ�6�E��Sɳ7���E{
��N9#��	]'
3g-���[5�t^W�9�py��j�7�[٧�Q�BaDX)Q�a&���?u���c�P���z��".#�	�Y�]j�{��t�U�w�
��p�l�f�d H-|@���ޥ6���\N�	'�i�L���J�E�1��>�E{��P��h+o6|���A�n0�����o��q�f��3aj��m��w����Z�b�k��q�|�t�P$���!]�z�ܑb�xJp�u��U�	�i�dF{4�A��SԎlKBO���_�W�4�^�ڏv�L1�#]�Y�Cv��=���Y�T9QLo��ޞ�����:�_������w�q��2���"˳�1��D��!IpN~��|S|>[J/�Q^�c�E�e�[�׭�>�˜�ߔ�D�� �4�����D�C�i�qL\�jP�(���Yޛ�>0{�􎩜1��]8��ٹXgK=M�w�.W����$���:/��撺c۳<a�4s$�j5[�|5�-;UF��_���{��\�U��f��:o���4V̕g?����k/�Csrv��z��]���I{M"�U�;a�����ѡ����D�ۏ*k��p�P��j��g�0�
q��{�fƔ5JJ�b4zEاi�oSk��j�~�Q^�t)�M��~E���z��k=���^�7�Uv�jd����s�|�G�o1^~k�񄟟�@�*�ͧ��0>�%Zr�w/�01���t��^ӽU���ǎ�\�i \bqJ��s�8�1pd�s|Ñ��yy�A��<>⶘��z���%v4̀k,�)�y5bq"`6x�E��m�Pd(��9:�3F��0jҡݾM��bؽ���P�VS���X8Q�"g�R��-�3�������jj'0Â��9[���A}�鷖�}|(��U΀��|�[����0Ȋ�+��Ўi�� 2O#�])�p�w��	�c�ãq?~�=qz\����Ԉ=�ޣm�Oy@�����'~�!v��4(S�,��2$�t|���u=����'=�T��=Q�sΐ�p����Un=o�?ˈQ�f;ɜ��:� ~  ���c@oiޫ��<PL��7Y���ny)cZtH���A�SH�������S�ݔ�'�+nO����WQ}x�WrD<��&ԛ�k�@1��C��+���6(^�a*|j'2��Cl)�A�_�M�gw���i7��������f���沁ۉbƣ��o�#��j4^��Y6�#��B�����iA!z�^�o�#��xP����O�kg�Bq7��<d���2���1�iBV?����c&�M��\��V9�!�� ���m,�ØB�rJ��/?�C��WU��=�M�p���t�?�*��#d��)�֊�x(2�9�{x%��P�����S�P6���뿊���M��P� ��|=>N�;P}4^;P���?����CW�      �   @   x�3�v�twt��sWv
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