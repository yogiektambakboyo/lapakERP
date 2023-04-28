PGDMP     :    1    	            {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �   &           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
    public          postgres    false    303   f�                0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    309   ��      �          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    210   ��      �          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    212   *�      �          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at) FROM stdin;
    public          postgres    false    214   G�      #          0    34018    invoice_detail_log 
   TABLE DATA             COPY public.invoice_detail_log (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, created_at_insert) FROM stdin;
    public          postgres    false    318   <�                 0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    315   ��      �          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    215   �=      �          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    217   ��                0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    295   ��      �          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    219   ��      �          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    221   �      �          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    222   �      �          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    223   g      �          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    224   �      �          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    226   �      �          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    227   �      �          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    228   �      �          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    230   )0      �          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    231   �[      �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    233   �k                0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    312   �k                0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    314   �o      �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    235   )y      �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    236   |y      �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    238   �y      �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    240   �y      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    242   �z      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    244    |      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    245   <�      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    246   �      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    247   ��      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   ܔ      �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    249   ?�                0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    310   |�      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    250   ��      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    252   �      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    253   ��      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    255   �      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    257   ��      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    260   �      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    261   ��      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    263   k�      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    264   ��      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    266   q�      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    267   ��      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    269   ��      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    270   �                0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    297   ��                0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    299   ��                0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    301   ��                0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    307   �      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    272   1�      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    274   #�      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    275   u�      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   ��      "          0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    317   ��      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    278   ҧ      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    258   "�      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    280   ��      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    281   �      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   2�                0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    285   O�                0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    287   ��                0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    289   ܴ                0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    290   ��      Z           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    203            [           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    205            \           0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    292            ]           0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    304            ^           0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    207            _           0    0    customers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.customers_id_seq', 1311, true);
          public          postgres    false    209            `           0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    302            a           0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    308            b           0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    211            c           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    213            d           0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 1744, true);
          public          postgres    false    216            e           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    218            f           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    220            g           0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    225            h           0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2209, true);
          public          postgres    false    229            i           0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 515, true);
          public          postgres    false    232            j           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    234            k           0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 374, true);
          public          postgres    false    313            l           0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 49, true);
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
          public          postgres    false    277                       0    0    stock_log_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stock_log_id_seq', 4466, true);
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
��f��※ �� TYp�M��^�t�4���Y=O���<摖H���E�ׅ}��0w7�C߽�~8���ߏﾎ/�����]ӻ���CӾs����7>��	p�{篚�*yU�_����-$b�o��w��'�ڸ��Kj�U�����}����x�r���|��Β���k�@��~�Ӷ�Y4�%ì�!�����!4��Z�GO�~{� ^5�U�x"xؘ�+?�B��p�G�Wӫ7}B�� ��]�����{8k��D���S7� UC�dg��2�����7 �>9UC �3��_ǝ!\�V���ݸ�>�eA7<���4�`85�7������X/:����@��@�|�<?�\B�|Z��YC<����/aw�oU`?�x�l H�r-�5� �����2CO~�YC��nv����U~�I������Wq��~��j �����eo4Yk��h9�o��LϻU5`��`?^ޚM֦��ɏ@@���Ј�r]�5����<\\��=��b�w�כ'A��㍪!�����u�\M��vG�N������2A�b�jA����Z�v�A���lM� ��S5�\���xo �͸�!�
?o>]< y7��QC��>�ח|��ko|� ���B#B�8$5��y�S�QCh����=^��oޫ�=l�����d+,��YC���p{����Gp1����mzUC�#>����.q67��}R5��o�z���tf���Ǉ/��M���A��N����PAP5�{��o����O���y����}b�5�t�.?���;�f��f8�bw����~r$�k��f�(��^�� ��)ݕ,��dP5��Oѷ������A%��h)��T_����eܽ墎�����<i��K;�ْW�Q5�z|G��/ӻp��z8o^j1ϗ/������G�W5����ߦ_�Qq���|H�;w��^��}y&���_u�3!��!4�|��Ugʡ�16i�&V���5 fhJ�w��W���M��s���T��!,���8�.�����w����z�5���i�VT���~|ޭ�I�5&PkL�a\��n4������4k���a���k�i�MI��'��us^k���8�{��t~�����3T��+���q�F�j��Nv��0��U�>-���]�C���&�-��Q5�f(������Gs��������C�u ar�������ۚ�L���[ŕ0�k��� :Y_o޺����3K�jA��2��M��]��6�R�jL��P��;���Ai�	�9v��X� Z5=-6]�4��L��/)k���S}��ah�!M�����m� ��rKv�^��kb��g�ӷ�5��9|�����`b������3I��g�DP.j�0���A��L7��@0mp:U�8�g��x��)��W5����bx�#�5����[�T��|$X�t������We��KR5���_��H�7h�����vz��\�#Q5����,�U\~��A|}��%�l�Oy���/[L��q��5����[Ë�iK�j@|��5���S��d>����w�����/�������e���0n��-�0m��X�˩E����AX���m�63�~�<���M�����q�~?�=������=v7��/�.�`�´m�O�����M��<�ׇ�"�ǃ[�&�ԟ�TBCa��5W�� ��ݿ�7��RN�7�A�\o%ɻ��:����B�C3���A �!����"�Oj�������)g8�2�A䅷����s2�mp��G3�hO�X��h����v��G��\�Ay�����Œ�A��i}���g@Z������;����Db�[H�A 9���fk�er��ٲq��<�?������H.��������wa�M�����7&�6���A(�/�( 4�>g=��:U���W�|���>�����q�w�����|���?�Hr��ҙ5�$e�������t�FjH�d��8U�@������s��,�Z�8�w�?���/����6�CCѫD2d�_~��|���]UC@���j���K5�e���o��c#�9t(ns���?�� .��eb�� ��Y��9�Ŋ�*(-��/����+ƴ�u�a�>�n���Cd55��	���P����˗�S5���TSn��AFhG��v�t՜p�qPL g�Y1:�C1Zڥ^o�'+H�s:U�@h��9_�AB�BN�����?�(o����_o,�v6���D�A |ke�ad	p�A�V�����d[���a�?�rxޛ?�P�iJ!�J�F��N?� ��CC_��w�XǦ�k9p�A��;���l���RC8:>�?N��Iq�	v��UWq�
Gs�����|�tU�_h�im^�A^yK� /���'��he"�� ڙ��v�A� ��>�/6������aX�@ȏ���7�g�\X��!��"��x-4a���� 8y�*5�����iqT:jA�������b�?u�A�47���0�5���ЫD��l#X�ЎD@'���VKl���ԨD@.�%�a\�L����(��������ʑ^��Z�8�C��h_O �q����!�1ۤ�fU�8��n9�m��b�!\����}�ѦHO�5�����a�<~3��o���
���^>��F����5���Ӹ�V3+�{M��5$���������A.�Æ���Hr�@R5��-�Ji�����[�Aݱ��ȑD<�� ��$'��8^���Q����n�i�ѫ�� j��3s�f�����Vs���1kGN��l�m������oȣ����
�c+�Z�8"��KL��$'/*k��O���ѵi���9���k���|�2ַۜ��l� ����Vq�N� ޯ����JTk�W�%��ǰ<����c���H�_z�Y�P(J�(��A(�g��ιƭb��m'��yB9�X1R�z��5��_�׏�o�!��!o�jC�O�o�"��r��^� ��l��w�79�� ��+R�����E�Z�Sk�P#A�:�A�=s"g��e�H�ok�'߹�|yk��$X� 8�t�l�3$��S[k�E�Y�A�=�<���Jw�ia`�r�1D�+���S"�k��Z�fiB�y	�!�k�Bz���5�����EM	2�%ŵ����Z��!��݊0,"�GA����m���A0xU�8h[��Cn�qx^5/�A�6s�ˤjG�'5��}i�O8<XY��_�-��G��Zȅ�������V��5ս� :��^��ߦ}�GXk�Џ�\bE���A(�Lף��&h%��2�g���3��um�����i��>��I�n[���A �sw�`��j���s�g�QT���w�[�=�/u�]hy��Ó�����Z�2�A �[?��n��jjO� ���jqs;4M�OT���GJh~���E�۽�n�S���MҬA$�e7�[�
����>�q�pdݬ�j�O�!��כ�5 q�@X�@\�b�~�{�5��v�w��)��K���T"	֢�Ͷ:�� ��~�o���0ٍ^� ���1���ѼIlUi�w�
�U�@ȵ��/X�F����5�4��|���hԿ&�»��Β�D6�nh�@XC8h>�������b���ꖞ�5���7Y���e"�˔�&C<��_�r;2ky�U�r=kG<�����9p+'��D@�t�Ӆ"Y��20k�4=�զs����"������u��d� ���;����D�M��woq"s%��k1���l-.�AG"�|�#p�J��wL *:P5 w�	����Z��
���x� :��r��{�D@�K��oM6<ZUB�� ���oM�����S�.t�}j"(>�D0(Jп^-]$H�)k���e���=`"�e�z	��MzU� �u�Ӆu)PR�|�� �x�7+[K4�W5� g��#��8�~�����D]�XZ.v�p�a���A �w�:!ǻ    >8�C��Lz� �5����4�M�:�� �y~��z ��ͻ8�r^�	M��34e����:�b?,����ψ5������Q;Cۅ3,�J��B{��.�	�n��b	s��� �2�i�t!���M�͓�5��mz��s���B�A%�y�ycp�ќ�r�!��EfqD@~uc�(�k^۫�����CɅq<0�V�1��� ���x��
�N� �R��m�ĺg��en� _�G�ȴ	<yEH�8»�5CU� 4"���ْ�hO��hG��#Y.��h��o��𤻃�j�mv��_� 
l�����A�f������E&B�@�Y�`�<��,1����H_7��d4�i+B�@܊���������y2��]u�� �p�f~ ��	"�\��$,�_� �dn�8����#a!Ǻ�`�9c�q��5��DG�OƍH�3�UxNhI��zk��w��[D�A�Wǻ���P2�o�! \��b��j:��Q���2~�H������-�$���p��%�M���D��l�CR��A(Qx��N�d/ԧ*�Ai�lZ�9�o:����u(Hh�\��ƌ����:�"��x�ٴz=���h��4��zU�h�9�,x.LH����RWmӄ!����a�6u�S�y�w{�j�
���Pq�����~��m��f�)��j�ݧ�����O.�ԧ3H�Z��!�5�6:T1F�A i�t�I�&��t"����E�;�.w�a��T*4&{�\~]uD��Hw�<�2�P��b��ћ�V��k��u��b"�宫n��!����V��Vc��DBI�+I��Xh	tڨWYg8��:}� W�'Ծ?�i��ym	ʮ�UgB�AD�^�/gk9��ո�E5����yunN���frk~�j�i���M����j�H�0c��AChw���-i��{..� ��{S�Q,�F� J�������I�=��P�`��_�զ�O���H�G�V��BC�RSr>�6mL�H��vC'�&B��h�}�#��T��[��QqK�3���B�))��Trnd7<�AH���Q����B��8��L�U�c��iRN*9/��� &N���n
SIu���B�@8�0�֩T��6��A���M+U*�.n�Q��p�aI_�{"ᢩq{;�шB�j
�Mѐ��E�&٤��Nh'��ڎ&��i��h�/�� ��}%4$�L�kKnͩ���P���t�6���Z�8x��qG݌KhG�7Q�oƏ�ʈ�� r�O/jA�D�3�s�:�����F� i��<��hs��BC8:l���7�m�Q�8��/�֏)��"ѩ�B;���a��5�#X�Am��y�A�_�-r����UY�B�8ا�:�L6��m,�G�h��6�"e�Ae�j�"��6M� �~����T��ֵap�Ǭ�&�O��j�<1J����v�wA�
#�.�BD������mT�r������h[E��x�S�-^���Wg4���V��ö̹���B�0x�ԍe?M&��U��N���f���p��$x�ַ+�F���櫻�A�4�a���)jۖ=�_���p�����@q=Dh]�g�%`�UC8x��h;���T�e
��"���R[z̦A� ��qMN½��7����V7�A\&;����D�jG:f|�r�ج��]B�P�w_�k]6X7�q�ק��Vg���:5������c�lơ�U#4�c�I�_MW�d4�.�T� ��Pt`��I��&4��|국�m��υ5�óo7E��f=Mh��~���?�I�*KJh	��[ABG�ثD�8�6m�,�Z�VDҾ�J2��Xݧ	�E�:���`���^�$s��WqW�A$êt�٪󪆐8�֓w.��Q�08�`ƠjmV?��GK����QR�<Y7�,;-�YD{ADǙ�pC��&�Ե������g�
B*]^l�ں2�@�����}9�owu��c�K�5	3���z��� r���gӎ���U�Sh�P��$���O���x���p0�NtԶ�Uw�B�@�z�zJ�� �~��j�hW����1U��r���:Sh
����F�F�7Oޒ��%鵣��W{5�A 튂o���� v�����Vy -�@J�-=���U��A C);�f��!���b�BCHB��ި+�H��%�;F�p����'e��JJ¾u;�,	.%�փ���2.[�헏d� ��&���z�f�9�5�\��6[�m��%4��-�T��3�쫰�� ��lU�����;kG[�׷�2��QEB�@د�<���hݿJhWqݏ7�7u_�nuIW]b	"ራm�IWR5��;��}���!4�t9��U�@"��|0���h�nӄ��W5��<%U�8ث�1Mk�J���U)	Y�X-��QC]�8xX������j��Ai]���{�V�*'՞>�}\����U5����������i��5��>�2����rP5����f?�_�IB��"4��<��t���vs_�^� ʵZ�/EG)s��ݜ�O]*kGϭVw��dtڄ�Q����S�c��d�ب5���b-�5l3Wը���<#�-�ǬAt{�y��Y&yu%��5$p��u ��A q=H��5�����*㗭E�a�<@;�(�a̕�F?�	�joYÑ�kg�A\'`Qq��_:���r�f~����5e�p�6ƀ;�5��A<b�ޖ��a�A� >��#�ö� �(��YI�PB�H��B�BsLTiK���!�9�ʫҕ6];[qk_:Iȑ�B�Ph��uk:S�͡jG%4��#�k@�An�ݰ�����3��΀���_h��l�l-i�l��Ҋ���E�:����#4�$�����DW%��+n��f��[hG*7ަ�32��ևB�@(���َѝ�.�A]iHi}AZ������[m7�l4T��A �]�1��c�q���2�& W_j�ٴ���U�56��m1�o	k��޲jg'$��zU�@�[=�Β��� ���j�d�а�Xe["I��)��F�rG2kH˥;�h 6�U��A �]W��fy��5���������jY���}:|�n���� �i�\7��&u�����u|9�9Ra�QlL��l��"$B�@���i�{6^��\"٪D��ռwT�T�He�6�o�՜�4�D�!�����Δ��v��+�5��"������nC��f�Ah]�,0�x��x�0Z�X�F{UC@�c��Ɣ�ߗ.N���Ax����=�r�;jG=0Z�rS{��qp��u��y������*k  _�*�Ihu]Y��k�Q�8���\�A�<�)�[7�B�t-H}�8j�P�x�p�F��u�w�t���V� �u�f�'o+kɺ�Z})o��A$aU���d�$+�A$qMG�٨����G�OC6"�A�[��ϐ�W�B�H8�`;Y��TM�2O�zX"�_�A �܆ܲ�^�U㳄���2��$2kThI�a�/���^� �����Xm����8�-ab6*#�B�@ȻnLǉ��4�%�G�8&��z>�>ۮ[�y|���	h��TFg�g�I� ڽn��C�n��Ae̶i�:۔i�B�8Ƚ~��2��h����r���'�ʗ��x�A ��|����l:y&�i+q�յ-4A6S�URh��"���`�nr���w��9�ƺu%�a��%�SO*ӳ�_MnZ�|YY�0ص>�ZC�]9�]r�����Ói.�P����jI_�\W�x�j
�׏����L��G[UCHxv����)�h6���	kƯ�3IXn�g")!WK�d6钪A�ػ�
����Ĺ���#V�5�q�X��8C��]*fa�J��LY>C��t��A,%4��,��a�j��>ی������`>>ޙ9���7k�_=�n��r��$U�0ȭ~x�`ň��᷃��ƽ�5�wx���)��5 �`0�A �����j(%p��q� ����a�Ϋ�A�X_���٦W8��YK�X�m>    _�٩���Ǉ�q�)��OH�l���W�U7oI�b�;j��Z��_k�Z�U\�NGB�x]Ie}V�ޞ!ɓU"�t��$1�DR� �K=���š�A�%����d���~q%p� .0���a�8f����ˀ|t�36�q���ͩ����G#GK"��^B�_����/���L��%Vj�J���U�5�A ���w��᪾R� ���1!��ġ	R_� n�g��ʋ�A<`�?\|t&II� ��ܴ[B��(M�mt����t9�y�R�8�g�ǝ�z�h4xU�@��X�Q���F�b���U�8J��nk����9�D��O�dٛ�^fSI")������h�u�R�@إ,�D��v�ώ�QZV�t�g���ՈR�@J2�J��k	yֻ��ɒ%����׈����b%J������R��6�-�S5��m����l�D=����A(n��Z�ҫ���irb6�>��T!�;��-ME�f������GK��h24�a��*������l��_����e�����h�yU�P�2���s���\5�SjA_R/���|��5����s>N\$p�ABh�#��e<�zY;,5���N��.�����D����O��G��$5�����w1���P�U�������A|��t!��J߉���5��-���E�.��W5���7O߄.w�W:R��7��Tm�K��g�f�7�v���J�����p�T>4Z�o29�Rj�1��r�2Y��2H,4���@][*_�F��Wh�7?�z,��L�����s%�S@���G==~2�2�k�Df����N�@Hi��5u&)VcuvDB����1�hwuF�@8T���ބ5�$4g�Sh��M�4'@�}3�e[R5�.�7O
��Єa�|�J�gb.�X��<@�d�.�AD ��� ���ۅ��R���62EjT�m�t��kBs�1Ū_jQ{v���4���)@.�.X�u�4��FyF������V��&�/5�TX�R[� B�Z���FK��a�K9?^e�mu�"4�)R�ս��q���T�\DӨ��i����2(�t�h۫�q�+y��s};�mԈ�����5����4/�]���[m�u����f�?��Q���Q�3U
���1&(���5�r]o6��;伟����*Q�vqI� "r�w��V�{���.��1��-���ZF)\�}��H}��Z���ͱ�Z{�i��6��mU������� �AJ�	Hh��?�j�����U����I�R���e?�h����Nm�{=y��&�Ǡj��'�U""����2�|h��ڮS|z�u"⺄��W���&�}t�S��ݨ����}��OT>�i�n "u��T��ޢ20-��AL����d�cs�hy����)��aZ�)TA*c���G�m:�굩)x�TBro�f�����GnX�"�V� $.��XBz��8NN� ����/e�M��a�����s:�TB�%i�G�B�jSLb�v�&���1kM{��n�5����T`ةD�1��"
���� "��V�&MHqڧ�NuCC�ox�jR����D��!D]3�P����3���A�����Z�fE�:��.�{G����-�m�Z.D{9h�/����ԫk�@�P^� "���U_��U�A=��ҧ�Q�ߣ�b4i1Zg�I|C�W�>MY��阯�>>W/֎�1�%1�Ew��6��i/PN����AL����HqP5鍱a��w�v�.���A<|�8ޜ�uC�N��Xg�
a�'��0��1�!��ޏ�F6���u�"��9�{�*�����e�5Cۄ�5-�]G��DD��#e�k�,�f��(G&�#�� ��e>ZH$�.��O�7Y�Kؒ�5�(���C[���
Q^��D�Q@�����S���|+쒪AD�j�e����ϣ8��j��˥����>-�e&4�S�����>��Ӌ�@q�^����D�����.L~}z��i����:]Wh���O5��>_���Y�S��ADyV�.�&�Ҩ@�Z�%U���m�w���D9�T"���F����L1?F��)5��sD�����kQ�S	,���f�Ț� r�O�����T3���'oM�c��3���M�\��X]���<��M���M;!���i�N� ��Ɯ���4'?���W8�a��5��sA�T��֧3�hڇ���  N
��uu9�\J*D4�n�g"
<.�V�ɴ]lb�h��W����q����6���K*ׇ�~kâu�� ��y����E"yU-4���+}S�)�LU�� ����`ץiw��Y���a"*�'T�3 ���2��fm��B7mT�j��|�YC�9�k=�=g6m۩1��E�j�{kZhjS��z����*�Sh�/C!�Z㻤������W5�'p;;K7�b�?}.	�عy쏾�N�!��T��y���h5��G���5��]Ӥ;[��ɪR�H�V��-O�Ӂ��퍥f"�D��)��3���O��]![���B���������M�7}ן�@2=�+��!8���G5yɷM��1h�Xލ�'�A@��Q�@䓪AD���-\o@�׫B��}�,g�H	ܱ*j�K	�*�UIdG�jE�_Ɲ�Q�ކ�T鸡ҵ)l)��TQ�A ����zp)L{?�~>!�F�F� ��96UiD���� 4���w��m��<�i[R�8�󅩇_���P]���б�v�l�j"�� �w��El3G�U�8"�D���[���������#?M�ߗ�A ���o��U2��Z+�T���\��'4��/K�:��ԩ�ѯ����� �a%ƴ�],ó�`pY��Ғ���x� �ˎ/3F\.��ape��e(:��u^� .(Y�n�B�@�1EA���Ai��� �ē������%%P)=���D��ݎ)��6��$x� �ʾ�"�>'�Ǿ�I�#�yR��ٰ1��~qZs����O#�1Gz�jZ�� ��l{Aj���;�e"�nS$4����w�%���ԧ��a�v�ln���|1R�j��y��W��@\�jG�F8�[Ì%6�	zR�@��z4��f���yđ8�αH��A�����=Q �������ӒHFCWU�)!�O�ok@ZU�@�y�i'�r���0d|Kh	��=�/���D-	������(��A(�Zo6���ʅ/>�^��$�����eoji�F�*k@hyٵ g4��/�XֿDy�a�	���������d�Q5���j�V� ��|���\ՄYh��5#,+1�����£�ւ��� �ҊX;�h�[a�����9�vc��Jʥ����[:(ٜ~�Ʃ����֕/�>w�W5��k,ngjQt�Ea�� ��X�i|*4�<����gw���J�C�� ���#M7;�L򍽪A\�l>[�y׼X|g����o�;�+��La]�@�5���Ϧ�K�A� �ۯv�T���A�u���Y��u��j�W?�zŸN��*�(4��r	�$'���Q�08��㣖v�����A _C�>��g���9�ƩC�u=LZ��G�8��{ZA�U�iBCH�0���2ƽ����A��S�!?�۷J�*Y?���Eg(#�L���h�ثJ��+I�P�4	"��<��ͽ1���U�� �������'$-5����"�3��6����Ԝƒ�z~���ݘ2���t���B�0��ÐQa�ATr6�2�<2�n��yGh Hϳ��U#'$U�0(�#�a5�A�\`� ����A�[���;�YZ��s�����Ѝ�L�����8��A���zw��[x�Y�0J���G�u5�� ��t,_��.�B�@�>e��g�ua�����m[��4����A �w�mv7�&���7����U��%	�M�� ��>~�e���D3�DK��j)1��.���c]ZU�@�B�ڭQ�Hy�A]��v��IB�ꒅ��܎Ք�    N6c�&FhG��m����h�U�����Z�VW�B�@h��+L���2[�����o����Ԝ�>�eȅ�*��P5�3�V8Y�,iT"�k�=[�T"�����ǪQo�}���LC��{�u�5�k��[�<�����A���v��WQO�A=7��mM�,���^�A$�qL�:m�鏍�!��n�wJ>t]��)�@ڒ;�����\㭩���N�M�T������������wK��Ш�2�|���VW�D��h�<e�u��� ���O���o�c~ 9��U5�� ���/�X9���T��x�dt���_4G���j���L�`�Q�HJ�����Te 	ᒮu ]��.4���ݮ ��L�|$�A$��~ؖ�l�[͏�AA�5�i���dt_��n�I�4B��\U� �41���X�����G�W�ʄTy�/4��]�����_������˧�w�ϩ�9���U��:��r�}2�l�׷���|���\���9�|�թā��Pf�7l���I<g��N���XE%��p߮O9�L�*�'4��s�7۵SGWn�yYhH�.�6�ɺ�5Z�������8zU�8x�ϸ�Z��hrUS,�A �Y�*��_�5�c@��?�Z�2,��~���EhQ�7PO�u��5y����p�� ���\���:=Gh�zm�{�����&(��.'�  v�����i�(��D{ߝ-�ӕ���BBhG(��Tч�q��JI��*�AD�=���O��0�r�6o�U�����*�#'���q����8`����Atav�����vNu}}^e�AhR_ʝ������N��yKB����m�f�J�^�T��M�u��Hw�At����U�8���8����}O���U�5&s�aP0ך�ەHvT���㵺���ݓW���u�WU5�����?O�9��.�TG�F�ۏ��Zy]�o�>�Ai~O �K�U��z�^�#�h�8�5�g��<���=š���9�p��T�c���ze�VO���jY%4ɝ�77-�.��!�tG�3@P5�ȗF���h@r
�$p	��㣾��D$˄����ϴE��u�4Z&��n*.�kW��FM�M�v�2b���C��v�Ɩ���(Ģ��� ��T��.D���+���������ހ:O��.�Ӑ}O��n�C�D��YOʹ��ͨ����~Tk�-L��AL�xR��t��T����p�[��>�C�n��5��c�j�N�2���(�x�<�jP5�������ds�f5N� n�x����²>������0�{T�?�~xT��w�	=��Q�>�hY��"�8��a�nHI� �>�^��O����4R����e��� ����-G��dӆ���14�G[EO���)�� vöh�ls��5�c��n��d3yU�8�ߏ�� Ӂ�-AX�@���n|1��\G�^� ��ˍ���ogP��t�A(������S߭^� J�x�5j�)��/O��q�ܽ��Ѡ������P�w-H
���p}�n4���K�Q�8�`SF���j�՟67�7�G\�N� �:[�Q�3G�=�ˣzu⺡w�k�@äB�ē�\��x:U�x�|⏏{�\�����U5��(��'S��l���P�ڸ�~#��S�dv�� Ff[u��_�p�n�w��ޙ
�����d5�� 7�o�q�eF�� �e�7m��fL����A� �6�j6*k��D��g �H��`�H�������	⠍��n{g���.��A��l%#�ؒ�A�I�#U)dB�0ȡ��
H��t���p���?�B�C{�`H�jGq�v�Eֻ� _�`n�?L����5$p������˖̦���� ��b~�@!�Pl�q�G�ik��6O��Y�8�A��t6�˾S5���.�Ϧ�MWg4�������� 
��y�BC8b3>[9�{���QFۜ��=��:�����1kO�5���MRSE��a��QM�p�k��\\����.�5���0�(�����ג�4��?׫B����h6�u���b��c֬A��%7���#o�c���6�W�5�%5���)ߑ,B�a8�X��Dԭ�Aekݟ�t�*!ZhG���+8\���m�u��#�U��� ��RWp��mҬAs����C��O�2p�7F9osP5����$�N@e8��A�/�n��5`ྨ�������5���Ȗy�z]�u��/��:�����~Z�.?���*4���d'ϡG�4�P�0�6�B��/4���ݣ�p;���8tJZ�@U
a�8jR���%kJ-��)P�N�T�}ի���C�Ng:��������F�TB�ٗ��tqڳx����NE
��������jb�E��/>jR7ggi�R��N�e�|���|�Y��ܜ��b=����P�	b�o:��(up�A(a.�_l���򢳜� ��M\-�q�?Ν|�ɷ�9s-��ʷ�#DU�� ��l�ϔ�NW8MR���t/�R���!�>\�y�c��6`�S�!�R'�ԥ!���q&q����cʮ7��6���&�Ӏ�����/k��g�
����)$���w�q�m�%�Z���C%��L[�D�^��h����F�r�!5�$rǯ5 ��/5$�/+H��K������X���$��H�~�T�
D콤���~c�x��T%^I)N��,6�����RO��eM՜�A ������X�K��A$\�k�WM#��R�@B�����}�V�<YO� ��9���~��$ww��P�����߿�fhh|����A$���o?���6��ˆ}P5��{��O��������H�h48U�@z����Ab�ύ��A �z/ۓH qM�����?�j|])�f�K�5��˟��_����\9~WjKi�HA+ޫ������JN�kT#!'������_m()7DozU�P��~��o�����%4��a,-���/����]E�jHGo�_~���{��A����̃ ���hK�zU�@�q��ԓ��Z�j�+u;���j��a$�#���T�A�,�/Oĳ���2�iK5�Gj�]�z3���C�5$�D`��ؗO.�|S�����]��1qmÏ3u��1�<m�R��F�\�a \=�d�vg�ԆѼm���š}�0J�5��Z]�8�A$<��y���Y9����g)ЯM% ��|W=,6�GC!����`*�f��
-��~���9jJ�!�ت�c�H���5����'�w�i�A}@<jH�k�Հ&�a\��3�F+V{�ZOj�<K�R��VӰ�5�$��1k��gܸA�0�R ��h������ꌆ�x�����?~W��6l2�IgQ���w]�"5�*����S	^d�����1Qd��~����L�J�b�	cI�|~��7ˁ�Q^@��/5�B�kI��a$�c�j�t�T5��F��c+P�sU�P���6��P)�>�ԝ6kg �sW5��>�{K��l��|���>j�<�g��R����ݣi v6r������2ȶh�f��a(q��a���a$�s�~<X�$ت𢡄��0��td[�R/DGC)���CfEɆ�0��}��1��H�RU�H�Bb(��F��%ȬA ��엉��v�D�^�07�H6H�l�.6������v�GF�X�����QШ�ԫh��qo)�,v;�Ejyُ�ӎ�9�����]�ɝ���O:ٕYj{�C
Յ��0$�{�e�fh�0�mN#�d9�I,iX�hJ��ݛUIl.��]��0��/��ϣ1���St���Ж9;���,,����a�KJ�r|��'5���}:�𺁽�c��6�In�˭����o/A�<��U� Ji��z{��42'�Q2ho7{��9$.�k������2P��A���e����rw`�j��>��o��f{4���1�z��FܿY��c�\�f�p���m{4A�0��~m@�e4��a�,����ۄ�i�o�?��c���Q�0���7k`BuVC��Ƀ������:�
ch�e��H��C f  ����Ŵ��̅����?w���D�*� 4���xs���/PtE�T���	�-����y�Ua��T�)�Ǟ�����M�j�?Nۍ�\��,5��sC>St,P�O]�&4$p	�^�U����6���
C������>���wv�0���l��d��C�Q�HZιy6eD��! C�B�H85��yc	]�R����a$��k{oifY��Uю�0�����_ME�ٮ�o�W5��Tw=�}WR�N[���SWi�d՗GjmZ?n�>�D�T��h�/���O��d��;�a�]��ﶗb.l���*5�����K/����0>�:|60L�[2��1����]f��JI���Ǳ��1�T��,fc�K�i!�K�e�5��iu� �30[UC �<�������PU�c w�e?~y��1=��t��A�)��p����a�kB(�AMu��0:��6�O��!�)�0��4���=�"�e��am���\^@'�u7�a|�d�A�s����`㠛��iDG6�#�U^��0��od�� i�8gqMI ;�]�L/۔J�q�Dmڦ��8S�j	o<�oJ��{�jI(�[� �?j�j�>o6��%r�V�0��RM�����zU�H�9�m|U9�#�FҕS���~.#�T��y�O��#0=�.��Ŷx�0:����GO�Bu��e
���)(Gfc�Z"4���7�gɰ�UFB!S[r�q����Q�u}��t��5$��Z�*\x�Y�H��j|0%X��藻�Y�@��\���6��E�qw;Hp��Q�@ȹ~�>�Ar7�A�0ڸ�&2���ɣq��.[��d�h�a|����٬_L3���G�{Kn��:gPhG��{���n�F�a,���b���&MhG�QO�OV�<�eI�F�rݨi&��U�l�a <�{|0���f�ףt&B�P�.j�5�� ���n�����|��DB[e�YW7����N�0n�2�n�����A�0��p��y�=XnPٰ�j.���Pd�ٶ�h�W�B�@h�
�.�������r�"�ٓ-QX�P����T搨%Y[�<�������??�����j	�aG;GpU��0ܵ}ޘjf�l���	BᲩ��)LFS���B�@hr�Ɣ���J�V�0�\�7�� ����&��l:a�C'?ͬa$��b���rǭ�3k	waYI⽪a$-o�L��l�[�Nf�DS8:�4]T��Q�r���B�h�ue~)~�[��gbi)Pp���؎�]�@��~��ӹxc��f�I��e�hʍd�]uK.4�$���:�^�0�������!4�$�[ɨ󪆁��|�YCr���e<�+�֒x]�Hʬo��l4��ewLmf�ѩDRj��n��$w�X>�Y�H�,@����qO�0��cź}d���a ����MM��j�tI#��V+A�Y�@�]������?�ji�@vs�x�jK[�����+P������2�௶���uI�0�>�BkI��j	O'���4��d5zU�H��ڟ�����w�+�Y�8x2�Ͽ��說d7*,�_��陬C闱�Y�Px���n�N����Q�8x�������n��5��[�C��\�a(�e�����=��֋�Q�H�������²�ŋ2k	�c?��j�2KK�-}�ۄ��P����i7�.���jSV���������ɊB�tUC�����550g��*�F�i[��J�V\�:�a ���<��-�߷URh	�r_	�A��FW�f���P~��m��R�<B�����ZK}>�#��0��Pbu� 4�sc�_�>M��a �h������ʯӣ�����u_ON����B�X(�`�0>XABS�
a/�$T�	B�@���w�@u[J6��a �dW��U�/�a �SsLIm����a %&�����QWgP��X[g����{�����kA��*<kEds�#G���B�8x��f�����������i�d��$����"4�ė���c~*4�Q�0�P�������2���Q5����)P}4۪�B�^6��Id5�*AHhI�9��3� �]�C�k���ֺ�MT��U#!'�2�������0E����\A�$a"�YZ�YtkI$#����#4��q��O����J�����F�95gI)8jIXш��N��šk�0v�ϛ�6���&U�P���~�v�t�}�5�D
��Gn���a(�e����Q2��U�@�� �Yz�Y�@� 9�i<���(�uo�?	���B�ٯ��ol�]��B�[6�Hy��*�a ��=|4r��~�T����@[�Y�@���?�����j�U#)-��(t9�zU�P�A����xPoa�R��^o���|���a,e���$o�V�B�~<\���T"9��_'�嫞�>�/����3�=y}��R��j�r
�����W�eP5��w���i��TC)����;�����/㱮M���h�<�$�����aGMU�8�î�\6�a ���9��?}"�A �ScW�,���Wl��`,c���jPH��Z�+��FcP5�����ǻ$I�0���C�����{�<��hj{2ۭ��Gc��lY��T��F�q0igJq�r�K��hIiV`���T݈
�\���!���W:6�A\�5~�om�`�n]�"4��q����S ;U�@<O�|�|����*�F�^go|&���ΦF�����GV���݄��p%������6'���#����i)&��M�j��5�ڛ� �:LՈdԷ�z�0����4m�$��kT"�(@�xcjCF�/�䑰���K�����VW��D�j���E����2�\�a \>�5��ɨ��R
�s��$�U�<�a �Ֆ$���:kH�w��TK6�U�߄���o=�ʚ;�qIա\h��S���\7����o}0�v��t�kHO�u�Ia��f���.��j[]\#��d���]hU�.4$pJ�W�[󨨰$a#����ں�P���xs�0�TN�7�����h�|\~=��Ѵ?J���a4%U�Ԥ���:HhH��;}"xk�U]�@��L�A �Y��RW2�;�Y�8��Y�&�*�[U�@���o�޾ͩ��6k9ٵ ��a <��`]v:�֨B.v��d�!�T��������o�u��#��a(���oM�1d�Ǫ���0�~E���r(�r�4kH�5>|-]�ٮ�ꅄ����)g�u(^ASs=?~1]�V��Y�H�;�o?��RtNF�؄��p��V���l�C'4���r��a %�|��{z��'l7U�X��>���(�M��&円s�n�ƨ�YpN�0��O[S���j�j���닒��U2�� �2�k-I�j	9�O��1N�V���QH��������u���            x������ � �            x������ � �      �   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      �      x������ � �      �      x�̽Y�9�,��w���v >�_���.)dU����:�~܏0UN�y��d�
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
DYB}��v.�;�.yN��Q	��=%p4�>��XK�X@0��A�%��P�Q�ra����΢�"C�j�@v[�\�T�춋J�T7N��m�	a瞮�C?�*�X������>��ύ�X�I����+n{�<��p����"bJ�d�C�2��lE�ۅ��Xn��j4�XR6�y!<��o棊u�4�fo�ø��k�UŬ�&ȃT=�F�Q>��nT1ҷ|�!x���'3�8p&5���;�bn���\�"F�����v��y�}c_�k�*�15�-#�<���!K�X�i�65Xll�k�c��sU[5+�U���L�p����o1�f��u$_k��LN�#�65V&4�7�?��z�-�fq���'��7�D�2�>"ͤ���ڷ��qcI>W}��`:�I�Eo��viZ��k������$w�f�+��-��CL^�%֋�#�v��)���n¬^-���| ��������>�~���(R$�:��ۑ�p�q�%'獲�Q�"x��7I=�z�=�`T#�PT2_�&&K�����Н
e��x,1�н��4�/%twF�B����3�Nb�[t!;����1�&���=鏆z_����r������d)1"d����>�[�@w��	�yL�<����v��L�����*�l�F��2��-��JDҚ
��ûׅu��U��B�5�Q���,�is7�s��z��(����8+FLT��QUa<��/k>Q�b�;�]��ZH4�P�"�L�oH"�qC�Ġ��Z:��f:��a��.N�t�5xb�9Ǽ��u51�#<&�jn�6��֜���̇�W�eX��2,��8Aq��_v�:s+��:4: �y<�O5_��c�ڛ�H���I�:錮�����q�sKX���:M�e���'1��(�W'�ƛ��&���Xu�#%I�}S�1�'E�&�e�E�BE-Ƀ���0�ūB#O�s��\]@�q�2w8\(CL4�/᱓�����E0o&��Ɏe�N+o�LQ���&6 42Oxnpq��01��z4y)(�c���MKq�I���5t�hi��{2-Z�Ӑ%��m<7�    EWXԄت7ل+2P�%f���]��*��:4�$���1GK�qD?Hl�1�jb�UP����ߟ�>��_��t��X<���ڜl���y��_�@P6�Jt$y�y�*��=0�=nb��ĴOBG�JF��3_�]*�|]�Pu �겙��Y��砄_����4�l����Xa�����蛉i���R9���^�}�$�x�H�"Wi�]��1��i�w��� ��@CT��T������UP��:j�����:���>�t`�z�cǷ����όtw���pX�A}���@f�<1�0I���}lp1%�Ѱ���� ��/�R�B���Y,z*�m%��B�݄��CD~4p�{�tܽ�ϸ�� .0E��r�.XM�Ëi�����<�B�R��{Ҳ	�-S��*ǩڎ�p��MLK�<�]ͧ}F	��~��F�iq~o�#n$�F�H�GZ/J���-���W�G>�c��g�}Z֏K��)c��+S'q o�f"&�b"4|�+_�v��
L
��5Ci���������ih���ά�R������B��w��x�賉�R{���-3Y4w���xˌ�<�=@f�?FF<C4b=*�mnI��0��Hmx�iPN��v��1PN<����ߪsK�g^�$V�k�-�}[���%	P�?��&Clc9�2ڛ�����ʉ�]�YP,���ޓ�ƴ���=�3G0�2e���T�E�A�0�����!G�nt3���Z�A��r� Wl�"�ܡL�G
������N:������3���]D-&��ə�lj2J���@�Hj�!�}2!G�jQb�vQ���2DV����X���~[?�ߏ�a51����P1J�%�#4��EgG�dzT޶d@pg7c���[�0+k?� �'G_�r�bu�T`r�kX*��(�������jUG������[3��ա��t{Bd�1�g�H��؈_���D����	��z�G=�SW��i鲦�0�j��bp3�+���IQê͉��pbu>&-���X�{q�]�#P������d>Hb���7��ˉ�iU��lb��ƈ䍳<)<N��.F��.*͘�G���%� �Suu61���{�ش""��IK�X�!7�p���L�5����p{�\#�&��rRO���z�0b1-TVyru[�#I�I���ű��e�i�*O���*O��≴_����t�)0Q�ؑnD@�'jK������g��m$�Q���a�����"�c��x�SS����S�ql'ZLW�#y<t�8h�����:��w5�/�0<��[r���.L��gh�G:R�CFv�*ʇ�vb�/�H�X.��].�Y6�Z:p������e��C����xOK�G�h����nWZ?��>���{�����[��SYh
:���hUa845�s��y\}�RkV�������Pc�����f�i*�k���-J���_�>���������Ie31Ͷ:�:���bb<��ƥĂ���C���K�"Sy�~[mp*e����̎��{���r]����v@���؀�Ģ�"#�I,�1�%�W0!L&6R2��Єb��@���s��Nv4n�pT��;GLo����*s�Ģ�c��dƃ�,M>�zK)0Q�c�K��""�r`����ʸ>=��K����&�/���0YLL{n�3y�%y��݄0
��N��uu�������b9�sj�y�F���V�#6��:c�������;n��K��s�k�����&��K>�b,�?�D�`�G���V3C��MY>d��R˴��S:;��|H)_��������q"�zK����Bxx"U*&.�����IƘ�;�t,��R�i�9���H0�����{ŅTǳtg���4�G��ը�Y��)|��M��X�4`Ͳ���.��t�wx�4�Ė���u�'�>�U������;�����=&Z1$���z�w1�q�u�2&wg��X:DD2��@fd���$X�����N��-0q�������˳3��:o���ƏtF]6�Y�~<[lgb��]��靁򨋉i���X�r���{��J����\H�c�5tCL�2��%�C&/}�s�����-��$��a�9�H��L�C�yXJ��S�8ġ��P��hfJ��� :ģ��qrqX�{r��]��t���ĸ"_RB쌮*!b�Z/G]�Z��Ll�^���a���"!4�⭑c����f��27,<Ԇ��a@⊝H��T��sԊs�ĺa�W5T�Ъ�zL�4���v�Xe K�1��2�қ���U���	.��t��`JY�����ޚ���l>��c��Q�N�U���.s�n/�+<�?�GcD����8X����+�p%6p1?:̌d6���4+�n��
���'�T#��y�30�4�Ė}515y	�ITȃ�%7y0\�{�� ��k�=Z����6'���D�/\9�%5�q�W�MF��4� ���NRƤg�A����/ޥ�ٞ1Տ��*h�"&u���i~�CA~�y��;"����#鲭�Nr�{gb��8������CD����[���f*0��󜡪��l��Ҳe<��x�t�
F�w�5i5Z���7/0*�"bI�5T01��I�l�9a�����d�t��^r�#ܣ"�
!B��m�#�u����n4�����cD�|ƃD�~4G�?1�I��2�2��� u]d�ԇ�������J1�lb,�$�������=��G?�2W����
(�M����5�lb�*TU����**9H�Եӳ?qC+6�1Q�?�Rf��R)�g33q4�GL�,	+�b�y|[���M��pJ�`�~㠮܆��"�������0�ʊ�S��i�� ���� �8�{<�qF_θ�	wokeR�/%D��`Lӎ'a��!Br����ռ�����uqbƤ�X�n��vd��fGb)�n�T֘�Q��81V*N��zlt-P�yx��V��6��ZFEKL�$�$BG�g鐑�Y0�iHkpY�~61���6}_Lk��K'~��t�wx�~$��NZ���J����-^Q`ʲ�v���8�,�qFeC�N����QBG���)e3���w���O���.Zߒ92�����Ծ%�Ќ��1��$��tl����rM{,����Ќ���u�\�䥌�8G:���Kx�U�1�e���ַ�5�71�m�B��m�2٣�>�&��~����:'����ylĻ�4�pI��t�؈&2!#�%װ��ĳ���������J��uO���mZ򰡗�-ǉ�t���*�12�IǨ��������nb�������F�O:6�G�����n��2���b���fbjYS���w�d71����H�j`,V��

L�9x�'*b`����*g��gT�
��P:T]Ō�k����t�H�Gr�X��oBe��<+����d�����Pn�c�3�>��<6z�V�Ʌ��Q[�1.�0�Ob�u;������ĸF4�]�񕄶�Hu`�	� ��.���>�I����fb�nv�~��[���5u:	m:���
i�\��jb�V�w���R�f�t�h[�� ɽ)6sI	u71���pV�4�l���op����7����,���#�NK�fv��p�_�k���!6��bZD��iA{���
l@ЃE��T�YЃP�A3I�)���Z�-�%I���sn��z�3@�{��hmm���g$��i�n���/��5������L�
b�4u�����Ĩ�)q��4CËF�H�0fz�,�Ġ3⮗�ևm��ѐ�T���-����%j��`b<��G���w�S��8���ۺØ�|;@
L,�da,�T�&�M	�b9��9j&�*�j'�7W���:���&Q���V��yH�:��Pbn&i[vT�����b��K2�<cl~�4$͋6�1��b��l
��Z�$fLM#&A7UD��DKe<���|.����%�(�<�	-����tti�vx��5��1�]���MtP���M�"�'��NL{�:�W6۬��a�xt��B	���>� ��E�$9��    ������\��"9�4<ItG:hr�E�2�u�����r���@׮N�L��r ϑƲ3j��l�ހa��K��kc��h9(0U�V7'.Rq��jhc�8�.���ۢ��_LLN|������r[��2&&�`"~Uu�rֲ�@��͍���EP�0�,��Db�U���6��r݉�*��n����h�<G�nr�%�VX�Ok�]SX!<Vb���I�f��XX��B~���c!����ցȸ��-S�����b�b�~{Ɯ���d��w���g��~��S�J2��h�&&K��1j5�A&J��D(�gR���ML+�&<ia��=v�Z��J��\{|�(	>4���	���0�����#[b�Dt��u� ��Q�w�Ce�w^�+�D}��PJ��|Oo���|<`�O��>��������Y�}:����L5�8�(�0ь"��l�O]7Ȉ]3��Sȉa?�k�̸���"���{��I�C���T���	��+v��l�!6����pC�CxǊm��J���SO�[ �b�m�Z�Хl7��k{����e;DB2��n��&�|�vƝCH�1WSْ,M������ޡ��H;��F�`Z�ϗk519�N���Ŷ=�}��2�]`=Ջg	6�W/ШDDf�*�	��,ڦU}�Z/Z�����FI۹CG�ΈȶbI���r|L��Ę����X�r�3�T�r&&�Ԟ�����*�v�4���4Ao�&��v���l"g�
��3�є�>1�P�TZf�P;
�#�����0�O�EZRa�8�&�d)�G���qhxM3�C�T��A3���!Q����+Ev���T`<���.v��iߵ΅=.r�3���^yVE�Rҽ�D{Vz%*b�%"�+�ƌ+w�ڑ�\���HJdLR�NQ�8���Ĥ�$�1/�祝�["�aɌ�"���x��������<D���$=<g�ߺ�L�l욉_���~����9I%�W'<�N�QPMS��	F�HG�)�P�c�-�N�I�1:T	������ò@{�a�8�qS`,��:Ԛ/Q1�=#F���a�a�᪭V�7ݒ�KLӓǧ[�"���Q���!�%�4�6ӄ)���c���Ո�x01���p��EyW��H����+t9����/����������Jj�q�޾��b��8#����V�.�RLV�G���#@�r�8S"@+�ԛa��96ˈTZ��xZ��UJ7XDnC$4���&)�=|��W�h����^���8#��I���*���4�#w�z�lDxz*�b�4��(J]&���X�1aE����&��Is��a+7���j�ϸ`3q�S�8������qѕ�r�[��FH��b�:D�1�^�]�4������db�?R�.0(k8��cL}�Eel@É&E�IÉѐ]9�鬸�e\s�p��%W�5R]v�1͕�y�H���PʋlS���-𠱚�P<�7�/x��DC7&*�鲚��۪Z���$���np��4�db�*�����5�;��x��&�EK:�\ڣ�
��ޣW�x�wu��R�����5�bbZ���n�?�E�Kl�M�{�FJ���|11�MK�̤��,��*��ZoFv�Gz�2^�B_O�Ju�ؘ�4݂-&w,-p�j5+�9�Pf�>�<�0V�8oF�<�*ٰ䟎ƣ31�ʗ��ڠ];�D{np�r��fI6~�ANd���9�
L���c&�����L��Ę��"s���]��D�Y�|��Ĵ�	�1_������l����UQ���-�r&�v��p��c���a�����x5�3�܉$�{�k��}������fkw��}���⨷0�+{vm7zQЎ>�/9��MG)%�p�F����̢*1��"r, ���nbZd��`�ru��!5�XWn��ӠLH��� gbZ>1�A� �p��L��hY
�z�Fע��Kyh��{Җ�ML��a��i�Tsq��ܓ2}��Լ����Q����~���H���S����&�M{�ϴ�S?F�' ;;�i��^���q�V�]r~�������O�L�&ǫC@�TQya��r�dkYDQb�jrR�������R�=h\ ݐ��I�[����[Bg�O�����D;�	�m�GR���a61�#�K0plt�M�yآc<�4�M�ۓ�ӞM�,a�rv�D.��L�/�yH��o��bL;���|����+0Ub�uXX:0q&�=�8���m2E�0ѱ��}Ǐ����2!�{��D��C��DE*���ML�``�J\�F6��X4�*1u���Y�"�0�7��iXb����i�	���̓�e����)x�{�=o�T��
	ތ�iOw�Z��fBCi
3Y�ޠp��/1���g�ݿ�?y�L�2�^}j��^ n����rk�Xb�I��b�� Lv�7�dp��}6X�e��z����2��\@ӯ!&]�f��q[6��01�O��>i�uOX�c-sY�_b��W�,��J܌�o-J7�q�u ����qT�*���^��57c�.[�.1�K�2J�Ҵ3������&�&�é\���2jPbB�EY*ءd�����zr�O�ê6��df���J�p=eg���Ǟ�!6c�	��]p~=���\��5Y�|��]���X�u��\,��O�Q�O=�@�ǿ�m���˃�"���-����Z��ۗ�E̮�#��e����*FH�iO)�/�=t&�^a���c����;���a�bjtd�{Z,��:o��5��N&6_"�I��A�ӷ?~�d
�����lj̫5F��*�ӣ��U�pĬ�6�h�����������r�:�^�ļ��`\p���㱫D)VXb<	�*)�q�'�x�'�����"� ����|���߿�0.�!F���b�r��4r:�O�f��@��?��k-�5^ϋ7��ְd]�T}ԏ��c~)��JL�dM�l�}[��3,hb�#�Q��c���(��Ӱ���y��X�ϳ�t=^~�4)�����>|�q��_����n�	Oֱ�$�dѼ�OLt�b��S���lk�����z4̥�CJ9q��\W�bQ%Sb�%@s(�
��H��i֘�<�L�{-�f~�uA*0���O�a��1&]���>J2�xS>��<]Ѫ12��.�;m��n�䐸�,y�5�-�7�+
��M&��wE���v'scKp6����,3 �l���XM\S˘ֶ�(,n���������~+1Yi��a6�3���ַ����&p!޵��n��6�*"|R%W�!�����7�~��ۗ_��.3s��@���M��a^��� �����̱���&&�Md^��F��4�����Z��P���w�%1i���8�L4?M��{��1�(�	[w���"(|��	]B��[`�+$�TA*z���m&x�Nw�l8�Óy�e)s�J��u$�|䕯>L��_�����ޏ�9lTy򭎚�}��l�	ߪ��|��1�|�z�UbrS=F���ɉ��db\�.\ϻ����4g�bbR}�kj>fO��%&�
_E�И9�*^�U�*˪U|b�*.]g[��V�m�ab<�>
��Ϧoho>��q������}��˧�G������ç��ׇO�)���������O�5����#g2����S`��*:zcK�TF/-��dc��|���Xă������H���3X�xc�����1���L�~�< ��zz���< �š��|�ܚ�����0@���/c=݋KL�_W�����$ݸ��r��t%���|���7獏wfQ�]bDʟ���G�⸋��؀D.��|D���y_y����_�����Iۊ���5��j[��'F�n�{.#[�qR,�^Wp&��o�(�l0���Zt�i�J��47�������6����=��d��6S{����&.�h�5ybrJ��M�&bߌ!W���B Q���k�Gi�`{��{O����<fϠ҇������zmdc=-ci��>WOlФ�M��T�8��R�cPt�6RM�<�    TX���dR����<nN�C>â��L�`�@]�B�]֧�ĺ!��^]���p*�j�	se�^�X�����6�1��^�&VVP.D`���b�~�5))0a�^mpa]e�cC��х!$RHbl/����w؎m��N�ss��\���N�<�'���<����M�������;jǏ�A��F�"{"i���7�����&$a>�X���+h��nD]����j��u��]a����t]�,@	���E�r��S�*����v����.4&���H���d�k��>�=f����1Xy�pQ�=W�]
`6l#z8���p�d��Ha��f�t���h6�q�'rK���9�[v`n��!������k#��ӗۺ��aN��LLOzf�Ёse*�Ɵ�Xob�g��WP	r�qa�RsI��!�X/��^�v�\�z��߳��rb�]���g��o��U�̩*0>5��#f����1s�\:�
L	�����D4?����l���Ԣ���������*���f�q������AB�������db�p ��I������7C��~8=?q�����d;�r!�S���
�([(�����r��%�O$����>�c����F����P~q3+!e�&�)'���������x��IEy���4w� g�p�wI��Z�`�@������y�OU�8nڛ:��{gb,������ֲ�b���>�X�	��t���y׵u{a��xN)j�5�'ɼ\��-LK;)ua��1z������H�f�ʁǷ���c�
1����O�0�(*�����]N�����#%�n&���8%1�/H_�FG��C�� M�`b�%q�/F��F�7-����j��eܡ���.3I�i��8�8O&6�����,��FN%?n5�!�F�譱�ng��,�Ym^���n�˨���}�����Zs��W�nbr��'�� r�X��P��\}e�l�[y[���sX'/Sh���@c\�_ ��F	=a?��h��!�v�g.	�?�!�͙۫-way}�)߉�_���z[��gLo|�$}�}�'FD�ګ;�FjS<���nŀBcl24R��m�ԛ����]����u|a#�%���_r�����%�I�|+��{�Flp�TX=/NL�0��}�!&��I)m�z��{}1bQ�I�uu�p��b�M��Ȟ9ð�߃Y?��)�@�q� L}v��b�"i�w���Gt��b��f�b��t�.v/�Ҡ=M����y8k�7�*a#�m ����ш�����8��)0^��7�c�7�ֿ�����CKT�hDVi���
S�Q�[>K����jW�hH��;$�&>��VmN1#t�g����6��c����\�:��v#��F*]9��YL���Rx�jy�Q�-���p<碴{��|����1\n�77��V_�Ĉ�=V���K�r:�K�r��wL"�������W�F�9H��h�F���X'q'���HA=L�0%T��M�����/�ce�X�aǍ��F�$R8�L��Nn:��^屛,�"�*�F�ML�U�x0��`O�F�I�hq[���B�01�@�,�oSs��$��B;1c&ʲql����t&$"LYɢ���S������22���<$��9fѫ��ތ�w����� �n���&�z��}C;s�����*��`�qQ����HM��]��u�N,ShL���;��kTob�;��8\
F������~�|�!����L�e�)��u��l��1�N6�����s7S1Ϻ1"҂��05*�x����)�	;��F��,�P�l���Y]�Mp�7a�y��ؒ���AS`�q�U��8�F&����>-
�Y�I*0޴7������k�� ��1��$f6��Fj^��3r�z45+��zrb�-Z`j��
�#�m��t��}Qx ��뎵1�//0|�Uz*�����=�J��`�e���{{w7x����j?H�e|��s�
�}����}�Ǽ�����!~�)�d&c������ �R��F=6�mDx������~XL�
&&KY��`Tz����$4VU1ߥ�Mw�9-1Ya
j�.�pk�Pb�r�qv&�j�8���4�1�"=F��{�G/�E${��I��u�I)u=�2aV�[�����m�����J"����«�:Li�Tl�n���JD�2���O�6�H��T���h�e(%����H�3qQ�;^�zӲ;0�e&��b��<������5���2�F-�JKL{�q�ˬ��M�����kQ\�>�7��㱎g���\�����k�"�PbZ�z�����#"e�Q���t�ZZo�ON�АL�k���4����tXK�&[bx:��d��$}�LG¤ )�AB���5TD)K�T�b)�4�>xtm:<l��M=�U!5cy�{)ғ�/��J�+�u(��3D�?�u*�'z�J�����x7�z�~�6�IZ�᥷ygp�mޣa~�wi�j�Q��Xm����N���x${T�d��Q�X�]��m�P�F� %^��;{��L�cy:�c"������t(����T�V��.1�H���VRƤW ��lU����B�������\� T���b<V�-���5Ƭ}(%֋�:{03&ёl�k`gb������m��<��n&�N����Ay��+>r�"�/)�f��
�M���̐�I���o�?����Ƹ������*dj��O��a�1>�!�Ɨ�Sgt-��x�z*�2	��_b�3���'��]�L�yD/��З	���.2�M4>=��S�P�Xw��"צ�֧R��^)���U'̅]+�o�6[ c%��Br-u8H�%�cÅ^C_I��jG��LC�Ի�Qq��@��❱|��%G*��CD��2��x�̃ޚ�2�p���&Z�$�K>G��*�,��P�Y�$�Y;��,BEn��4$�[`���Px���{(ژ�k7T)�p�f������+0����نFWs)����(z�k�EN�M3��Z�3�ɯ~�:��V�Ex̸����#�:��)gbb��t� �T���H7�y��LfobjS����ҡ�e�P"��S?���P����T�B]�X)CL�Y�� �f�U7��ڊv�H�%��hAk�F_Q�`3&� -��"ft1"�)���s�A��N�Ġ���B�X)���AK�"<rצ}t!�R(��ԼL�i����DKz�<�D��R�Ձ~31V ̼9D!Ǻ|W��.g]\5��q�l�Hh%���Rr�����9�Jo�s*�]Ll ����FF�.*�چ�9�V�D�؀L�D�ֳ���c#��&~Z{�����&&�������
��W�<�Ik,��������� ���D5������\�����x3�&�5�ܐA������a51=������F5Ĥ��JqW��X���l�����y�z�!��^���⬽�1�Ֆ�u�Ю8��7R�����b��x��ԋ{51�U.=JLD�1�!��	�̳58���W݈'�����I��N8�D3�	��Zi���p�/1��)�D~�5A]e�JM��$]��^�t��������
1�M'B�n�)�զ�0)�.��Ԟ�ĩ��n��HI��!�?`V�MLsHv��IFDqH�f�~������0�������h61�+�H:y�4��O���1U��x�<��ϒZg�&���������`ٙ�vr��}��1�|O��_R�׸����bbry2��Z���ա�e��4�A-��<��y�'5�e21ٙ�pT��":38p�<�3��+�î)kO�ս^%�/k���O_�~���#�C7�t��)&�/j��].��f��X�W[�=?B<LL�+��N�ڕ��fWb��}�|�9�V���D�b�B��{˚B恃�.�F=��.1����o�I�\b��ݵsaV��+���XN�^?�3�%jr�k����^"������RbJ�qP������<d�sT�ML�QaG�Q�0�tTb�5�%5�i���լ
�52ǘh?��'݄�w���[��
b���&Ij`=l�3�FK�d<�ϫɫ��r�a�}    Gs�sQ3�-Ә���Q3^9��F�4�h
�(e�r�e����@�����KCe1��&T)��i��b�U�ڪ���J"�[��Ȑ���� B"�ۺ����M���Ը�Jj�a�"`�MLs��kIs�>�7%�#m�6�pϒ��%�:�F�\|�=�c��X���;5@����Ц�8��-�p�q���\(J��T�<=\d�<>B�����Qy�.l Y�aJt�d�<�nbr�"�ޫCT�.��p3�,�$��(!������w���Ʀ�;��Ǭ9O�q��!ޫ�É�m��q�xӞH�q�6k&�|u0��T��c�6@���h�<�]��\M���9be6Gan�V/�Ɂ+�M^عi����D��#�#��;)pŸ�X������T3ju����D�P;`t0�ˈ2�y	����Y�~�r�.l���\OaG�U��g�Eg���J�6xM�D���hWz\'6�����
�&��31و�Tl٫!&��'
��iqZ���m�O�&���������3�%;2�]���3�w�Z�qG�h���񮦇����9lr6��ђ��VO%�����4:Wƈ(�=���5d}e��o�f	'�����\gbLE�8�T3}11ME���P�ˣ�I�N,J�}'M�/7dUi�Oؓd�Za��8u��7�����S�I�������7��-Kx\��V�$�Z���Di,va��r��T�Dhx"�٤��]cr�,SV$��%7p��<e<ù���3��C��X�/'�=F<*/慱�1�"���1!Yx�� b$��x>YLl���cѴ �H��ȯBB�x3?�0���{3�n�0у�I�������B�(�C��h�B����#�e�����Yd�̢x�^M��R	��qy�Is21�:��{�k/yu���QCD�9-/2+�7r�6n�#�ͪ�����m�"#G�95���M��h0�6��C8�?�b�k�٥�������I���?}�q9B��U,�ַ0Ǟ(S-��1�͇��eS�9�71ɔ�4�ڼ�:Uk9��I�9gC�[��o::�dm�L2�=�gy
u���x��T&Cy$̹\���1&AR����I���0��yOݕ*��;Nk2rr�=y��H��5��7P@�}�����8;�2DC	�HlpS�V�еz����c�F���Ǌ�9�>٫���9/���`��l����##B�$���?�XB�䴌� ;t� *�G:����A��^��_W����7�!�)���N7��#͠����b��ߘXϲ5���0�8Ą��ۦ�1h�~e]Qr0x:��[��TF�g
3v��1��z\������'1��&>�8ZR�ޣ^E�b�,>\1�$J��dPR��`c��1]��}
L2H�����-�1b:L�	���8Zw}Y�C�����4cu�Ø$��~1�����4S������x����OA�l��&7@��^&^�Ds+�D��8+w�
T`4�;�0�Q�jF$���|5�'�"�&��RD���Q$�mk����W,01`��ђ��gb�C��Ei��Pˣέ��-<���~�����R��ϧ��FDq�uhH.5�c��&UBG5��^��"=lX�F��JƤt���V��_�O+8�]�+'��n5?���(�1	&��h1��Z&�k�����r-�5l�`�1rT�QAά1�Dz�S�����|�FV�ML��"��煈&��GT�"Qi�&�����(�;�9مQ��6y���:��Ԛ�;!�}��>CL��A��*�ot-;<��UX�"09��%��t�.���et�1Q���]�x��p�IU���#�z�fL�;����?G]���%q�<@��1�$fh��[`N����˘�xEOfl��^Qct�0#B�:7��c��[ ����H�.�#�C;ldE6/��b��{"��"&�g��ⳳ�Y'�:���S�Ƙh�,�a�c<�pq���I�)7n�8�R�'&����)��D���Y�I��_o�ʌQ29[$0��q&&�׌
	�Y�h�u�)0q�,�ԇ���Ĥ�Bh,��}�X1��E�1��8���W���_��Bj�Zq}��N��d�H�"�7:4�V+Fx0��ƪϺM���w�B�����Z%����p/���s)L�.�.�Xw���]d<H�Zs|-Q��:�NlL��Q�^���[�y̏5W�H�x]e��Z�W~��ߟ�~H1��&Ӂ.��y�Wq�������X�}���IH�0=�f���Sϛ���=^)X�c����9������v��1����YChbj�̀��cL�8$�c��T��T���o����0�6�G����.wX�H�r`�!7�c���<��@��_�8��m��\����쉩�D}��q�����Ĵ���5�Ѭ؄�{%�� 0���J�ab�����V�&�>W3�}�Ó���N���71�\��\1%��O�c��f�d��b�!������L��g�R't^X'}�Ci�5���)�"k�灏*���;^uU做�"a���Ѩ5�<�n�S6����Tq���XPw���a<v8'�>���I�Ԡ�&�0&ZP��������q�Q`�:������!&�:a<���zZӨ��~b����|Q
�%�;����B�}/��Q���6�J�|TWc����b4Γ(P/���D�bB�U)��P#��_?�;bρڋtbC�����1����{}�c�I�i\��[�rhV�RrGKg%�7��G3?1��
8�d��7{�*��Ĵ[��#tx�@cF���2���U/��1�>�~��ѵ��3�ыy�s�
	+)Z�;�UY�z#^g]���
9CË�.#"�lOK�L�	���u*�͟1͂b<��8U�q��]`T{��Ej�/U?3&�"Z�RI�n519�-T��"+�A"+��mc916P;vNL���n���UbL���E���*�!��Y�x��Cu��a%����(n2�Cv�2*$��������X��S�q�ϡ�%(�At�w��1�[��cYj9��
������"<6�/�;�M�M����碆�-|ž��&_n���U����̽��)W8'CL��=�#� }�kL�gb�ӓSQ�������̈q����כ@b��K��ѓScl��]����<LQ�1�(�Ć�Kk�¶��Tk�6ȕ���~#5G.����#�xħu���8�bs1��`ʧ�?G��������_?��������`����X��F[G�������PB{��t�2D����h�z+g��6l"nz"4]�=08�:˶��S���̑�m�����1CL4�!硺��2r���摗>w%~pb�4��-7���ȯLFe�Oo��=X3���2�iî�a�xșX�J�����8y\Q�7��ܻl"qe���h�Ar��d��V�k'����c�J��+m�x{�YU�2'�z9գȘhE�#��gN��qbc���;4��ب�� �����k�≱&l�.0���LL��9Q��xG��Td�H��&Zq�-S��O���w�*�/�ѫ������&�qJW�r��΂�ԕ"������j511hԙ�؇�� ����I��S�������2H 
N�H�]1��NyH���P��Nl��2DG�s"�0"�f�e�_cf�;�;{ׅKB��db��>a�2����߄� �g����x��T�>�����?1)누����x��dJGc��4'���,��9>ѷ��F�F�LXʃ�6�6�z�MBs���Y�$���$<։w,&u��i.a��#�hcD������w�7'v��o��
l��-�E��D��s���T�R�
p�Q;�/n�A?,��<О����n9���\�������l�͋�l}��|����l��ph�p�T�����ȳ�a��8�2�{vX��i3�V:��#�b�����/���&�g"e�#�\$��0r�a�����\� �  �i�Di��sf/����p*�����>���b<���S�DI�
��*�0�|�sS�[j	F���UK�����-�i�R.RL����8c<��e�v�����I�����Xgn`��-�1�E�Q����2eP&��p�!j��_Cl�k�Aw:ц�ֵ�\��8�r�-}�ʲ�����Ki`�e?]|4pJ��!^������͉#��{�'U�Xs�˖�p�����hh6�!�>�l��0�������Ճ�ZIV^�R���D��3���YᔴA�4�3�8>%W���1��s��T�D6��X�T<��3X�#�%PR� �NJ���yj��'&&�P���T�u71)��� :��-�?;Y����>��F$#�&*�iB��"��ɘ�=n>�-;\��k���x�x���������]��0      #      x�͝�$7��W?E�@��>�_��-Uw�JV���l��9� #�<H���v��6m�"�&�$n|��_�T���(c������?��?�������'����C�g�?u|2�Y�g�QYVO�~���ÿ~��=}���_O__�����_޾��W���>�P���;��wL�L���|BQ������Eз�O��	���/��|��������ח���	�Lﴚ�Y�M�����$��<A�񰚦������|��sݚ�ʾ������|����ӿ_�����O�|}}�����"��t�G���x�����b����7[�*+���%d��8˿���e�_���x�H}��L�><{���>��������9
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
�s�	!�G�0�1����2D    =�Ƙ�����&cf�`��uܶ�x.e��פ�g	��e"E�d>a����� ��`�85X]1��N� N�n�KYe<�\�8�24��������k���SL#a�J�L�\����/".j�AՃL�e ���:={Q��E�ˤZ�p6��g�U!����vt=��OȾ�E�n6=��@���UK%�������Ǉ���BE��}㒰O[�b*��:�\�%P�U+D�P��j��?ѿ8M�Xͻ�C�� C~z���%N�9&&d�%���<˃��Z�PD���4:�ea1���ʮ,�)����M�6��XTƮ?�6&h���!p�ҡ2fZ�����a�B���n�����7;4Ճ��Q[kQ3���CAT�҅���o�C�pw����n*���'^|�IF�#�"dD�^.�f�Zz�{N�?~z��f�]�%m�J����p��2�'`��.1"����B5���e�`�~��dd.�'˚�L�\��c�����j`���"������d����D�;�M��%,����>� y��Bĉ	�hl>>��:���SQ��iYy���6�$/�Y���M֍q�]�&��t�ʨ������7y�8g�G�T�ޢ2����A�>NVQ�rr�
֡�[�gF��OP��J5��}���?a5*��?�P��)e�E���,�5H^8B�8W�5��@����dW�5R������xY8N�_�.��P�=Ֆ(O{�]'u�t��U>�A�l�i��0�*��k�u|�Dh�1әv
�ʘe�BFv]a��Z��&u��$]Ԭ�l�W��fv��2h����Ɠ{w�]ve�Y%����Y[�P��c�\�L�j�d�k1%a5.Q��0:�U�9�d��V���+��L�!1Y'���:!"{vT���d��QǴ��� �;;����w�s2�s�3A![U+kP7�g��9AdՃ� ����0�� ��G%����c�S�ȁk`<�[�-l�nT�T6s��
I�4TH���ܠ50�U�8��1_[�T�`�8$��z�4Z���j'�l�FFi'Yk���b�75��Ƽ,mx$K��ʒYkK��WZ�i}g���:�M�2n���A<�.nJemPj$�e� �=�E����!'}��]ƍ�ƾ�����vn]�7�tN����2�`9#Q�E�l��w�`�V�sP�e�h6���X���q������M���܋g����GF8ɖ�D�S:��]�`r{�\WP6��> ʵ�g�l�[I����kՌʘ�Т�A�i©�ߨ������Ȳd�t�Q�i/�i���q؝����lpo_`�7�P��,!�!��6-�Z\d���q����>lA�P�<��� y�+e��~sFt����ʸ���3=� �Y���+q"i�-Q2��2F?i�<P¥���3�d�0�CNLe�~+g7'��Ck��P7�i��'g@�x�x�k���ϲ�?�`2�ڛ�������񯱆;MJ*�Z��]bd�F��������&[��׻�\����X
�r���"j*sr0���9�ﲵ�H��nQ���_������������d_w�B�ʵogK̳o��+zfU��AeW�L�Z�u�N��\=s*�3����!�%����k�ɸ�7�{(�X,4]�7�x�qǒof�������o�������$L:Y8>�|�����89RMʰ�S&(��Ɯvr�;>BDj���߈Щe@l�k����E����-z��d��_OM��C�r�H3N�IFY�"��à�fЕ�Fe�����`Z�S�f��	�$���:��!:m_G�*f��T'�v�'q���.CV��K�r��tڼ�ޢ���A�I�͢����<*LR|8�);T*\��`�!>^ǌ�a�1�x��h���ux�h"3�	�a��X⫈�7�>�:e��� In[v]G��1Mʙ	��V�v1*�l�-1�l"����ޏ���2�jǡ.�[[1p1�����F�zT����'��z#�|��g�q6���,M�Q+��k���3�d�÷W+[�EP��>�j%`fH_TE�D�z8zx�%��^Ƙ�U[���"�]�MV�U�
�f�k�ѣCO�  ��l2�])D���A6���cn�.[�,k��G�ڥ�'�qolf�H>�H"N��Z& A�	T�X̓�I�:H&�8EdA�+W#�Qz5I�8Mmk�Q3����B1m��֢s =wf�	$+�G����������*�vDe��f5�����)J��	�&�w�m�#B��Tt�F�9彨l��Rz��Zה��F3�<ٱt��I'�[a���A�8ȘI���]:��0Y��	$�"�I"Y� �%��C%�Av�R�{*����7� ~�*���I��������'�@�|��1�dQ/%olkk[C_���ɡ�5FNN����%D�s*[���OQ�-��~���>Vo"���M����D4��&b B����"��AƉ�Z��0������#�P�ek��>N�ɽ�-��-?Tad��g�iڭ���=ڕ�������$����7&|�~�������'M-�-d:e4Iԓ��ָX��B�ɸ�^��?��Ae�F�!��\%�ja]ye(4��;�9����a0�CQ(*�z�L�?R1�2oc���)��0�H��J�8�����z'�Q�Z�#�<�:C�����_��>!���.��� -*c'��>��8����O��oj����EĘ8�o���	
��S��-P�֢�B������4 ��}ݿ��nd��r>O�x9�B�Ic+�@Ƈ���B�A���rP5\-�Y�d�*	)�N���@�ǡ2n��ժa���l6+���&^ұy��r�DW���Vt�a��Ee+�'9_Ç�`ѱ�� �Os�#�G���8MD� �����gFI�8�7�A޵����R�"$ث�9��y4?͓y�(��EF7�~��v0��qs�nVf�o"4&׮i@	���!"]�8Z��z�a8�A�nnDPZ��ˢYt@ɵ�g���F"�Ii87��������U��;�n�7�^�&���v��Wb+Ddg-4 ��wيMH���Й���CH� \�لBĉ�=�Dmu&gT�⻵}2tE��)�R�R�<ٜ� 5�M·�\D̨Uբ6*�=`�M��S���]%L��T�%H�v_Ge墝�2s�D�KjZ�T�x�]vIM������"�XP�Q@eԴs�Y������ײɸ��=��� 4o�E<8CW�/1r�,���F��׀�Ae�+���x.n9�@��we���D�)�J䌑�D�'=���F���]vv^�/�P�X�\�*#[�~�d�5Hޣ-D��3ލ��UT֎�����>��{��Ą�qM�*�Y4!������n�E��}Sfd��	c�C��=3��A������jKCaDU��f	�gh���n���l�\����7�@�\��V��ge��qV?��y�\>VG�>��e0&��ʠ��~��A�8���{-��4ph���Ψ�&�Wpt�Qْy%f��W�Ef�WBFG|c�hMY|L�e���2�es~�Yǈf� 7���3��=�U���ϝ���s����
e����-�b�|��[���s�IlvZ��l��&&�Z73.�u#$�3Fá>��[�.���~@3m<�b�͢I�Sw	�e����;���d3v1�]&Iľ�E=:�M��\������i�]��-*��
):8�8`D��%��̀R�zD���=�UHJ >�؎N�A�&[�([����]���Ρ��Թ���rh�uB�x��Z9*��"��)(�q�00��%LV�[���X�i��$�l�M޼3F�o�ʇ:�~������@��C=�d~�3̋�1O��"�I�a2����1ʞ�*�����fU�u'e������&�T�H	'�v{�x�C�ԃl����5a��ی?�dP�`��l��_DIY���
�m�!���.����_�!�_ڞ��� �wȐ��K��K�?O��	M��K�����_O������A����ue��e��^���dZ]ݰ�U6[�ݿD#��%��%� �   f	���2r!�-�.eu��r����8d��}MĻeWH^4h���*K#�E�����l�&�-���f�I�Y�?�d��!�<B��$Q�/3��TƬn}p�݁�i����Lfu��U��A���������	B             x��}Y�\�q�3�+��N��
�PD���<��P�GK�%���OFd�\"oUV��i��1&n��~k�b�x����w���	&�����E����q�B8��sx����/w/^��]�����>�-���_^q�R����<��[>7/�~��'I2��������៏?���?�>j_j�R�E:e�W�K��z�o�z!�|�uƣx��a��	ŋ2u�Y" �\��%�/�"�������0��q��"�f�+'-����xa��a����?0��b���0,�|.�s[� 'on�޾'����z)�N�6�+��#f����#�2�ba�<[���a�%�$',�o�wC(Z W�Vҫ�C���P�l�z(&�\����l��(&AJG<	��{��"�rR ��	���3��D��� ��	���aD���-Rx�O��53}���qZN�s~��JNg���~#��h&����t��∄Myo�ˈz��E�΁�2�W<�`�(l���(�m3Ol�K�;G,�g��!����n7 "@
�Y| "RFx-#*�-�y�[�h�'\&S2�!��ɖ'+9�x{s}����?��� �C�0��#�!�e��OlX��q$Bv���~Π�;~Dr±�{�v?"K�N�`H8	D�@�2�.��-��I�'$
�А� Պ ��l�7��E�RK�hRBx-!Z�j_�9"<$hN�2���LN@�>�i��(r	/�H:e-�͡��R� �-s���:	��lE�F'pX�t��J�8l�C�i�ޯ�����*���V�z��n�H�]���5�Kq��#�%��Α�:�EG� G({hYm�fm�L6d�� N��Õ�p��G&D�NPjq�zg���*��*+:Bd�%��K�0�8�S6$���z���������s��&�x^{�z��$�V$��F�@��đ��?�wO�ӥQS�Eq���'OW�I)�m�;�CX�_J�{�D��Z�8L�c�`G��t)TP�Ar���.AgY�v5)���vm�q�|��8�!����ٺ�?�ހ����q,D��t�D�l�y�79�00��'5K2��Q($rp��"���_��������:�E���`�p�)����Y�w�{2��=x�$9�������	�&���m�!8�B8i/����Wyjؒ'LV'l��c����G&�8�G2<d�0��`��>
[3�N�/�Y	�'�=C"9'O�Go���})��BT��?�d���u=�d ���<ăiEmÇ� �iPPT!"��9��D�@�:D&�
{�g�Ò�����	.�9��B�l)XB	�d�%!lޣ0��e�K�1�qg�{��Ho���{���]��a7�!>Y���!�.Q�]Ɵ���L@����A�r�$�-d�:ȲAFd�![�6$|�����������A�%�C�����2�(넣eg�#&�G!V��-!뙜�����!	H$�����-���m,{oG<��A<ٲ!@�v1�s?q�|��[����u���7#K9��K�!#oI�%k�e�5�ȷ$�t�C\�c%'���.��Ch��g0�LB�:	a�u�ȡ�cޤgH�N���O���%��VK��%͡��a��d.��Z�i��[�������?���W����KPEBSH�W��C��!�� � 9��m#QAs-ZYGGʻ*��|a�d�K�u�F��3��X� '$���銟��^��	 � MО�C����gb]�!�u��+Us/�����J�.��"�Oj��uGN0��qā4���_�0�5�@8Rq)S��a���v����OA���#m�Ļ��!DTd�,м�_��������]�t �C�F+#+y�Ȼ��`H��S\�� ;R+[C���@)QcX�*�B����j���Dp��*�D�+$���Wey���{J�U��&c+|ĵ?]���nn)K��4��i���R�戙�["s�2��\�භ82y�����%����ё1��5{>*��؃���j=������sE�_]�_?mٹ�5h;�=�oAN0F����Z:�����2��
��#�U	�7��`�o�dr�aO;�2�t��Y8.�t ����c�u�j �A�B\2gr�I8Z��u�(�h�^��o@�qް x�&Z�v�_ �7�#�k�,�*ń�-��R�i�^�&~�Dh���9f��C0m��hzu�Q���8.�7_yF��rՕ�s�r(o)�8P�V���?���	��j���k����k`�	w�K��i��l����mEiA^+6�0�.�BN`����)�$��#�>(G��M7����s#�3���o�

������.�<'�a+~@Q���s|����{#�INv�z?H��G�G���"���x��,��r��n���=�d%�'���!��%\�T`	�r��������ͷ�>ߎo�7�[�w=�H^#�;ZF -�8�\�T�V�8��8�mxa��T��\��c@�^�QR���ɘܚZF��ۃ��@�ع�҄� 9�n�E(ਇ��p����.T�jy����S�s	��;�E�!�RyHHlk�'������v|�I$�0 �.��	$]��2���2YeV�.I$' 1G��r�)!CY�kjֲ�yG�&p�^�WrR[on����A���]���T�A^:V������p���dr��B-�k��W^���
QW/����T��`d�c+�n#���p��߇��������?�T}T�A��¸�:�,A�_gj$���DBIH|��Vr	���h�T�� ��Z��P&�V	��Z�<� 9A�}}s�v���)�w�,
Rq9Wb1l�._J��"VE2�H�~��+��R�)�/���. !5����jxuh|!MI|cӦ�rbʠ>�0��������>\r�[/~�8b��jM�#�׻�ǏgKB�g16�|�"I؋��5H	e��ܝ�"���O�y���gaBx�$�`/k,�|��D@��=�H>`9E�%8�V�(�$�W%�3�ju$��ٴ}�9A����{2�p�8���
HH���h��"s��@V�}zI�������8@"�JN8�wHr�8oK�y_A�!i2\�=�� �WS����x�Hv;V�p����qJ�'U��.7T�sO��߇�����gp�Kp����2R/L)��98NOš�燍eAk	&?�		��Ǽ11)�MV��+�{��p|��z��L�"��Ԁڲ<�R
%���>;X �l���;kI������e�"�D��Am)ʩw�v�a���ӵY�����0� g����������bN�/�)��йw.+_*�8m�	b�����:6Q������������~ �_��\����@X�J�9"�W%�c��$g!y��[P���%�K%@sQ!�c��d�`�[��(˚� �0%�(%T�嘯�L^��H��J|e��fQT�E"����bB�`^�`5���j8�1�{QBL"9!��'�C
�ug��`Dl�A�-^�-5��Vd)P|_m=���@`����=\�{M��`�H�ю������=[N#d��J�őɉ��ヅû�ET�3�4�n��݂�s��"��
kI�����o`	A��Bs�B*.^+.妱��j�J�Ew�p���2sC��%��Wj�2���l>te�~tS�.��P@t�~��,������V�1�U8�*@�N6#��	p��^}�D�	>g�M�䬵vO��0��\h��
���V7�b^�|�(�{E,����>���9��z�Dr�\�7��!4��hamP]dm�+kk3YŨ���>]�Z ��U����5}��j�~�-������:(�j�ѩT(������b���L�Mï�MD��mr)�q�X\��?H��1Y֯�]H�%5��;X�������L	!� ��/\z�������Z��"�ټ�dI�\�p
.~Ȇ$'k��&3��    ȴ3�j�%o�dr�>>1;$����;Bv#9Y�C�ΝƑ�D�..��&GW���8�����!0��G��R����o�"N�Ψ)��`}�������FȣXҰ�ڰ[v6��5�5�C"91d���ƃ���#�*�k ��MT,�"�H���<� �[ ��o���Η�*�C�n�oYg��#�V�ir�5<Ȇ5t�Y?�"�`�R�����V��m�2������C��+�
r���r�)�}&��)�!�%�/;]���2�-9����V:5~3C�p��k�D���`�!-���'͡��!��񌄷H�&��M-�A����:�D�EK\��2O8�v�x-4��̓��Ď'M"[�ԏ���@��*h�v$W�#���r�+�`W����ʤ�s��'�=�sN�;z*�N5{AL8�T7���K��s��VnV���6� ���{,"8��8Ė<x[�tR����r��N�B��O��΂b�
/)$��8�b��2~�Vh�k�"���gV�bՀ�Y��W\���8Zd�װ�hM�D�L����歬���r�����i����,TI-FZ�} C���v�ttu CGWsX�0���T�)`�]�<�X��#�w�0[+�� �t�M���`qeY��1V��c� �qw����bC�%Q�I�hj�����4�X�I�H�F��55u=�L���3�'�)l�ɗ�Xb��l�����%q�ɺ�����ݙ�P���
�6W��� Ͱ��x�iMa���I�7��b��s�:/_�?nn��$gu��Ia�Hȶ%W�-t���HT�DH�a(!�眷�����?)qv�L] B����' �����">����-�3Q�ac��/&�L���&~7���] ���Eqn&�d�����n/̌���)�g�{�%��,��g��k��8�AO�r������å���M�$�!��l��ꂜ��>��^G,�����"H���+RNޗ�����/�\�R� �7�o�.��Q[�Q�@�����-�2mO�H(Ҥ�SNɼ.rvc��#T�{�T^d^��T�L�1|�RL�ʋ�Zy��拲8�����̶��t=,���X~0���ָ�e����)红���� g �� āj|�(4�d��x��c(��I�y*����1?n�`1a/�[� �?X�"�5�<������Sp�b�A�E�J�E1��`GH?����>Xbk�>W�]U�?nSw5�Da����_�}���'(a�1�B/S�P���6�*�j��Y�8�R"J9Y�pZ��-��^d�Kh�Cb����]�R�{��C�e�{<���.�IAv���3�-�|X��?9�X�
�E:�,�Z�j���l��)-�H�_�L!OH����9~�x�kT��z���x�D�&0�vA�%�-�m �p�� ��r�����Ӕԋ����]gAN,9D�Ehi%��Ȧ~�tdrB�)V���; ���$�#S�p%�XB��P�=�Ι�>��TBiV��29q��p�����w��⧥]nE������5���,.�H���3g�l$u�>[|^�s#)��ʤFR�E���X��c��
	������W�QA#c�ims����Ը�פ�o�
��,&�Z��I���xyV/>/':�r����.e&'�<��cn���d8�E�w��Zs�]&�̡rp����w�$�O�n������C/���r�ŎWo�߯m�:^:���b���G!����H��?����1$���3Q��|���^k��^{er����F=�4��wW��x���@ ��Va�j���>7_��-���!39[��$QD�Fv1�X���ܳF�M��5Gz��+�vLLAN\y��������`=ާ�]�Ֆ^�����7�u�+��Q9�D��)J
5zVG�b������G|��Z-�L^o���}�&M�r���7((T��Y6�nI.�����E�	� '���@�i�狲*��ʼ'�����-�@�s�29A�����?1i<j�$���PV����,\���N;���uuQANH>��-��0�zQ���ҤU�U�V��rx e�%�s��[7FX #k���a�H�n1��b1ل�l�b�+�9���CA����-2i�����\!�
���V󲒷��[�L���	��5�?��q���;4��*E/j�"���aOs����J^�^��%�˒�r2�����7��Yb��sB�*[�"�}���	=�R��=`Q�V�K�%�
�J�ڕ�w�YO_��e�9���ns��F���9IC��}0ۀI�NR�ڵO;ob��n��Ke�o��	m̧��Yw�Va�� �l�=,�-�zLQ��=<o��y2��.��d�� �p��F@��\��e� GrW�h�kD�^c��v�7`���N�Wr����'0�/n�� ��#�y����H��r��{�4��|&' ��GEF/+4l�5�R �u�	x:Q���m��4�Ey�� "�J��JJ9mYD.e�1���X$�3��y4�6��0!N*��1i&Em&�
;��}�8˝Q`ֹ�����_����O�<�K�ឈ1�͐
@�
@N���9���4�^dr��o���iGC��;/rއ�U��N��u%����\��_��\���f8i580�	��>9LƋ:.�ӎ���EV���S������6��s�� wt{�h3;[ƺ��ܯ�9>���%���P���(i�Z8,��dօ�Y�q9W��6=���p�m'�+9i��v�p2��d4to@���E+�)>� �;N[1Yɑ'��z� ��������N8]�����/8]0�J�$9,×�2����U�P������1�,�z
rs�:$�`J:�ri�Q%7��rSl����E ���������׻��7���5���}��)G��bs,u�,�%a�Km%�������/ #�7`A��d��$�UN�_��1��B��\����U�A%X}r��/�� �I�b5��}���U]Q59ۗ_~�맀b�n`@��� ��� �dם=��%L�ʦ�'�/��޽�'�Y,B�k
ŹG�����I ��]��#-E���P"9A�yO��6U��x�G
���W��}��&}1[L��=����	��,��l�!�^�YTf��1�/v��ԬF2/+r��¦*>�)�L����ג�8��
d�-g��W|�/ �7x�Rr�!��r�5 	2��_�@	$w��Q�B{er>[�m�6Ւ�����=)ﺒw9���R��"��0�L�<y�j�0���j~"�/�<��<��H���2��o��H^%����%Y��ww΁u$�F{U[G=9`�D2�'�+��z$H�L��21��r��׵a��Ij��=6����8F��ə%��56����5�?�1'�,���@wqw�9�=���o?K�"ja�g($�ia���΃&7�{]����`���!Q.vf1�WO垆��~�-��:ir��M������TQT�"b�bï��RCMܐj	q��a�L}qǐ�`�s��e�A7E,һ�h!Gy]k_39 ��1��b��Q�>_}�E�\դ���a`B��rT��{ҙ�[�����Ι��đ�=]�@�z���Z@�'��xS3��c����� ��m�m~b%'$��T��?��O?��'���hi�����-���[���S-Q�J&�2
����\Y(���oo*ե�@P6�b�
&�E����S"y���LqX��v�)S)Ɏ)��2�E�}�әbq�[���i���qS6���e������,fr�
�{�4AP��H@B�aS�a3{3d�jF�ˡ��qr��y�����aM�\�>��ʒ7v���c/�utXա���b�=���M���
r:bonȅ�6mՖ�g@Z�Ɏ[_v�Y��!����ϙm��ė���r�|���AX�!u(�jK����B(w����di�u�ki���.Ζ�x�����x���F�ƍ�,�/��2� ���&���X@<    Ñ�����/"��5���X�$9���m�kf��z�B+b�,��r�o����8԰2㢼�,��k?�8h���ؤ�ʄ�ܻ '����(
V�jv�c!��ZJ&��pm�y��}{�29!�KK�i �aظ�'�kok����d- �[����� '$�n�"D��ax��hI/��^��Nw��k��9�������a����� ��8��-d�h����?9,�հ�3�X�������G��X��/C3��	�];���?V��(�U��^ǟ��2s�D4�����6)��	#��^X�Nf����t>�!3���D��*�����Ɛ������Ә/
�FA��`���F��o̘��vx�>Nt�t/mu�u}��'�4./1+Lt[�%�\�^(��IH�������7����W��?�?�a}�����S�X�`�\���p��2`d�!U�c��̖Ԩ6��S�µ�0ڗ����k�L�].3X||���Œ�˻�����I$����tNN����2y��9��54P29Cy��kr�bS�E��0�J.��\��_�[�6�Z�O�q��p�G�_�0��;L"�q]b�e&����]l��@#�b���_�f����4Y��"��948B!�F�lFDC�_�7ySt�2����L��竀�U@G�8B;ì�_B7S��Y��pN�͈E�%(2�܌�4�i���6������fB ����(��89\Ǘ�u_��޸b����+�{R-�L�.�`ІK�\<�8盓#C|92�����;\�y�n��D�q}E�v��~�W*�i��l�W�e�O��pa��^�y��d��ΞL��0T�LX�ݿi$x%ɭ��]�d���R��&�?f������;p�����4ԳZH���!��Ԑ&/��0�/��9�L: �����D$�!.�;���H�:� ��&^�u>� ���M;#A;S�7p�~�.*Eމ,���U�a�#�.�G�?^t
!����6K�>L�]���L�Q��� ?�K1|Ԓ��LN�u�qj�"�Lǌ�q�Ld>X�P}���� �䜔y��0dG����/3��]�YW���`'�^T@{��S��6��
Ѧ�V�*,���3����oٟ�E�K�D�į��:E�/��|�$����0Z�S�+8��Qn��a_���{PB���/����g�=�Z-�2L�S�jpHŔy5�򔪁{�po�dr]�@�1}f��p�	�L%�;�����0v6G�z*��Q!S�Dp�y�İy��o����6I�H"9!y�!�jF *�T�,$S3+p:xD�Bn���j>�]�aF���EϺ�	�}a��}3�[� ��Q	�"�l�spo!�2�p��������|{�v����Bz��`����T�[w�:!����򗙣Ł#��xg���\�_���Z�,���v�%#���C(	�u<�@$p�J�4�� �2�?�)��g��W�9�����}nĠ  .]��k$M����H��֊d�Dim&��ĒcHp��u��ũ�(�	����Y�_96�wH���xNU�G b^���j�
�dih	d��{)+9y�!�6f �C��U`�	�L�p�B�vz�b��C^��������=�}舔BBk'�JCq@�SMa~+C���dI����'K�|ޛg'�X�Ԉ0�P��)��
8��n����8r4@?$D%�8�P ���J�m>�i�Ac�r�oi/ŧ^q��ȴSbHi�f���x��Wy�9������}�U��GKq<^J�=�RX�jfc@�k4��I~��9��L��U9����ď�`_o8e0F��)#�|9(ȿ��u�oȻ���'�thl���1U�m��.x�N@C�f�n��5�e<�A�qm�kAN`v�G�h�tX|Lt��3ۜSb��4RX����J�!�aJ���7d�"Y�?7Z���C���B y��GVR�l��n�)�� ��?;��L�Ɋ*��ij	ou�JNL��%�d "D��Jĩ.H-)�3�K T�[|�I ���~w���Ml�mͥg++N9[M丞ʸ�|��~�{텟p%��D�+�a/1�9ە���"f��tfnI���#��Q�)񲻿G�/�[����=���8��~�~��4j�X�Ω���%�&Ib�����eعH&��s�s�;�����w7䅄O#i�Y��+^,�������$��zgװY�[�3�����l7�i)`0������A<��?9�tx*0���������Q�N�6r���}~1�It�-��*N����iO�8����Ѭa-�	Ǩ!�cu�`:Nr��\�Q � Z3�U��� ��;�drB��, Ò�/��L����ލ��a0�ż��C�	�F�r�2X -- �&	�ړ��N4����2�;!��w��#�*���c(&�to�y2y�_xd��O[
Edr�s!gr ��C�M���ឣ
�|�)��K��qY&�d�&��7F��H~���<W�kx�9��-�L^�M��?~�@V\
�c¿��II;L�����M��S��7�c�504 �M���Ҕ�2Al�+�9����n��0b�9,qd�LUi2%��$c�Ԯ�����L^�����]TXx�~��x����ys�������щJ$���(2S���A���bL�I�7�̫y��@F�X�+�b���G�h��o0��S��poK���9��v5�)Ң�`Q�G><�~��/��i����b����S'�aLp��e�K2�_��l����>��ɕE��(�=��YX�������"?�3s�(�(J\�R��;��6��
�u�I&' ���I\U�%���K����𐌁����z�Z�x�i�)J蜖���gy�ӢSQ�0V�;Lͣ�e:��[$u��X�$�X$����A��m�-B	��9550 Q5�y�em��
J@�*� ��]��S��4��K����E�mlb��H�w��w1o b�B�E����d�K�c�����|��C�"6��Ssq�D�C�����s��8�C`y��h��s��@Px�e�.�`��,�u��#q�jǑL�@6�J�╎-��DJ\�Qy���;��ވP�9�L|&碄�!ؑ�Յ�2ij��g�p�3d�G9T�J>W&��M�-�I��m�z���F�GOYv�z'�ȉ}��D�;��D�u.�Q����Rv'�X&��k��<��L�����
T�}:8��g�p~#z�VqHȳe��1G��JZ�U��Ez����Pw�7��,*Y��T�&����O��Ou�v��la�]vg����F5�0�%T�j�.�(Y���Y2P[p��Nl-ȑ%�WvO�\��.0��{�O�bΨ<��m��c_D�]7���oG�<���a\�	�b
f�*̂�X�Yz�U+���Ӭ������xf���bz!5�*@��ٙ�>����u��xE�s��m7;r4�OS�`$��L!2,�uX��u�u#�Č�xL6�۱��8t9e�d8�F!�����
���e^3��=�2��pON�@`��ؗ*�1n�~�2�̯;��#n����dr��i�dA`�ʆE���x�H#ok#?;���2J�y8�`J$������~X��H�d�����ک7����	���vfHA^5����6-/����?ЬhE��T�PpΖ�+@�f�p�;]�u��[(��_�U��I��B���XJ���}��FA���x%KΒ|�Y����$��#9���]��v�aR	B�,�<h��r�8������1��-6=�0&�-�$�-�'����l ��"�"��K�l�j��������|ő��	mQB�&��K�l."�L��t��|2a�W,b�(H���~����;�4����
�w2��逽��@6�E$��t��I��i�]m�ʹ')��b������I$g�|7X^��S}���FFf�\�-2�9nH�m9�qG1om�J���$���B4Wt�t\\�L��ᕶn�a���ɕ���18.#$����ÿe�u    ZAX���KP��peY��N��,Q�����L.�����$p:��<�]��c���������30�Ǜ!AM��5S&�&7�4�xC+��:���k��-=�9B��&��(����
�\g�a��S�C�}��eI^�B�X?*��H���KH2n�̙�8~����96�=�H>$(GH�0��"5Q�UH�~��C�'��щl�����ОJ�& G�8(���`�i����E�?�@x��djb#.g��̙�
�S���l{ ����)�=�h()}k�*��Y�q�U��!yݲd%�w�o�82"���n!6D��(y笒w0?���Rqd|(t-�LNHr�*�$��	�,�QL����$�;!4��J8v{)H�I���<^�>^~�x��Q*���)���<�PeB��"���PW���8�L�KSTH�1.q�+�����/��  ����
Ȝ���h�o��X5��������Q�����s��C�HF^��2�� ��a?� ��ے\�.jd^��R!��Pr ��@����"�F������8Ò_��\}����5"`L�b���|9/�����uW��w�^ɂ��I�a+zw����ﾣr�������/ě^c3c/13���NfQ�kf&���#e;�Pv�{kO9`��E<g�q$���xV`���ɋ���d.(.�Pw,�M��ۄ�k�0�ZLQ^1le�����Y�����"��KInl$u�d� �Vy�
�sV�œ;&J�ʵ�w�zn
�W(c'L�*�h�bP�k��| *���lw���n#qC�ɞ�Lz��\($�֝�<�s�x}a��v<1Rz}N9љ�],�p)��X�h�y���Ɋ�d�k���w�-J$���&�E�H&'y@�p��K9�����ë79�qN]sT�3O�����,%/r6u�����d�v\���e����:�9����d���?�r����4��X�!���Ee$y1�4@Q�.�̡�)�SC8�������:�^4(?`!�tjXOv�f���Η�͚�9�ի�|7R"SH�%�5wO��p(vң�p�39������|�T�-��m��>�E��>�E	"�9�u�W&g,����������ߏCߐ �qYH�����	�#�NB�#9밻� �gp�J�$C<����(=.�xX��2��H�n��NX&�r��{b���$�\"z,4�2���z�F�M��.6�X�
���&.y#+jj�o����^��ng"39i�?~�ӟ?�4 cqw��X+��'��p�
������]P3A���̘��/�@"1�86G\e|�@��X|��MB~��H��'��pYI��ss@����J'�z$����F
��k8^"��	r�������ʊ�*jK�l��$%9���~����� #۰ ��q�4�y7��ʣ��o�]+%9g[vwT�w�����c��q����L��QO�c����ٲ<��f#-!f��c(9�+VC�,�o����97��8I�ӽ�����둼�}���`{� ��p���[���g���� �ۯKr�ˇ���	���GK�[�k�̻�[m�G��y�/�p^���F1��{-�[	#A�%�0�,�Q�ߘ	�^Z54Krf���`��If`7�`�KvzL�5��.ń�qPf^%@�<Ho�>�I%�*��Ө��Y:\��ܲ��6�l[��W����K0��	�&����\7�g��"�uw��_~����*p���gD��4ܐ�;hq�k%T{�Vr��ۓ��G�p1R[�Z�?"4�.��7��T:�g��m̍k��C!q#9ay��H�
�?$zC� zpdk(W���*�
�����,�H���ݞ���1�(]`W�E%A�W՘W1�<�G7I ݙ�LNLy�7��b�,Lt�"B!�p]Aq�� 3���A��|Q��k;C��Sv�ߎ.��T,*��G�VU�V5!��-`T��=�����d�y��旈F��E��iB\7�(�plb�����Y�/,5$jG�v_��JN'����q���T>n`�^��%��p�$&R&m��J����ɉ3#�Z`z:�'��F����|��
cp��é6�Yɉ'�0$_lpA�����5�lW�}bX�L.�c9$��G-���B�q��\F�i+#�
�u&���{�U�	\���u`,�$[�y�JlNם:b�.���s��˦���|}��F�n?f�,�r[��	���XL��a���Xh<�Y��G��PV�z�k�P����0�B���x1n/�e2�)�P���a]���D�B�������&	Þ��-A����1��6�
%3񽃝#x�Χ����M0�7q��Ë)0�dE?���:2X�ErJs���?}��o�4 O+���>�!��b|U���N^	p�';�U��W�K'��f��b3�%`!2�Θ�Z?#�	h��;5�9_7�闟?&����Z+�-�S1�'@ѳ�t|%9l�K��*	��[��5��Tl��Zr6����� e�漄B�0xg�֒���|�JI}0�� ne͔��`D���c�RS�S�3Sv�(��2��
������Ic�����,>�B�K�>�0��C'��.��.�~r	f�w2�;a���rM��>���B�~ۚ���~�����J>M8h2��0R_�=��UM�s�S�����X=FidyD#K�)��9��t�n>�"�_ �
2�l����x͗ɹ���9|�=�H^U��=�{��.��.�����d
ݱ��Y.�h5 ���x�=n

r��f�ps;:k8 ����qJ0=�������%ԑ�������ct�29��#�v�r�8�'���n��ӘQ��Q�OƤ�1)@IN����j��ۑ<�m�FA^+v�d&�٘
�7��:�/���������SoP�z�s���ge���]c�Լ�rqCN�{frΞm"��zJτ@���Z�s} %��Ά�VBl"y�؞�܌�p���P,����˹lK���F�'�)���N&I��
	�󑡘�����T�����L�)��=�
%"Q�_q�4r|w���ә�uF:Y&�ϡ۩sp29A��'g��'^��Ek)�=������w<�V79O%��;`���|��{���!)�k&5���ֽ�����)j�ۉ���2�$(F�k���B�0ߨ0=9v�Imʊ�i����LNP����`4Y?�/~\
�	�48i��;�e�?��!��v�Y�Ķ�O&XC�YK?v�
%bD ���7A��,z*��w��y�T��ovwף���A���5���SD9�@��=SX�����Z+F��l]^�'�iOv�Jl8��Ɯ�[����;XN���`��専�0f4lI�qV���k�7+�PN@|q��iQ�q�'XOȧ��.\��u�r	��4��R�l�GX��5YtjS:;��O$g�}��u�A�s�-�AKr��(N XV?SE#[iI�K�c�b�������� ��B�&8�)�̑�&�A+i��1��L�� �Vg�47��C���+j:0�p�w�1.؀��t�A����6/p��� �O2#%�x��Fuh"9��=�c��Iq�kn��do3oRs�,߈o��e�z!���aO��K�ml��ɥ&[��,�p�e���r62wzv|�����.A�i=�6�eRAݽ�T�&e׌Qs���%�2�7���ɇ3v��%��Z!�`4 d /�Qi����,������2����,x%�����]� �h��J\����������D�C�Ɯ��è�S�3d�?������s��U:aaE�.ܒiѫ�`/-�Αd���#c'#yإD�y������dr��n����Y�^3�ׄ����<;0���7	��E`4�h	����
n���Gl5.}��v{���k6��l�?�[��!�1�gc0���Ŝ2�gV�%8�N�V&�_4�?9�9ٱ����\�E�-�H^����?G,�
���_��2o��ɜs�eh)a�<a)#9'j�&6�    �@�������@��q������ Up,���2%�^/D5�ɝ'*eX�F`�y�d`ʫ��WHp���F T�Y���ȕ�H���������)�j���9}&~�`_�vN��"�^VB��d�I	��7˔ǃ&��(�`�W�u,�#�хl22�������*�:�%�gr�E�P� '�)8^d?��M�lv�o�e`#M�'� ��QnB	"���+Yr4�����'��
�p/U��29��[��*�}$�4xZ�Na!c?;��Io�l��@��
f��d�����
�V~�
�a��|Z`��46��
���a�+m!�ȓ�Nz3��M}��!��L}͓
����`����B^�#.-�D5H`L��-&~��<]��mLy�$w�Ì��s�ƫLG�U��7�Ǔ�.�)X��Ce�*�#��7q���0S�t�,]:e�?2�aS5��W��.��٧��\y,ռ�U�9��5�Z�yq�����)H5���:u)  P�a~ѩ���[�5C G�3��gܼC�9%\�������=�y�Pb�6�b��� T���=�Dm&�=�/�N�erB�@/U$�X�<�),��y�������ł/:
��a�9WCY����>�����#��b8G%�A�IN|!�J�9��^���H��^���t�s@Cߖ	l;a���w��z��6 �D5@���r;�L�k[�b���C���v{���1��>��S�E;�\���;,�9�F�˰@Ka��VF�!�i]'a���;}X[8�l�c=�H�N=~Zb�4ǪS�L<��t
t����e�Y���iv.ȉ)O����f�1��i�����2��̝���Y߉�p+w&�`��er�s��n�428Xq|Oˬ��O2��	�{󦎙��~����R� gW�6`y��f�k�P E�<���������C�y��9j��k*؛!"�c��8��tH됓K 51B~�&F8�6p�a9�r~�(� $67�Ya��@�ߦ:r�U�RM*�s��'-���I�R�/\Ӯ�)�a�/�zO��3�c��a�ғ�ư\����Tj�9ooi��q�P�{ƌv�#P�����dr
�:,�#3����$'�|�|�~��^���:�.��E'�"ʺ]��ΆC^���'Ѵp"y����d00��s%@��� �)*�,�<fy��Duea�g�Ő��zN ��,V+��Yj��a�Z&U�)j�˪ϩeiuna&�� 7�֬� �.�Y�����:]�ɉ9�# ���4�QbH �6���s�,���Q	��*廧A�F�@��J	t Hki*k�&Ƕ�b�������er>`��� tF0�n�t��n&��i���.�����^њ��|0�O�p`���y�Wi5-kDf����3��q�� ਲ�{�f�u�$^Eii�S�aE�F�Ü�J�ｏ�������P(�\��`�"�l+$�KC�aS��f
��q�"yU��P�cơ�9�AX�@�g@�M�l��
r�rws�HE�*���H��gd'����2o��*��g&�.��L>`�{;�5�@�9(�9t+rf���G�X��$34�\�9�OD�Sl�: �P9�A�V�M6թ��j#��8������������7Ӱ�,�fZ0�|!S�Ii̮,��_�Gթ�L�n��A,B/A!s�d��ɮ�ɳS�K0���w`"9����q0�9��rцYh�S��ˮ�ˆOV�o5rf$��t�,�3����� ���H�B�1���k2�5 �+����ap°�v�/�O�nZ�[��YM*5�oxf\���g�!̼&6����R�M��3::X}�fS�Űp��3��TE�r��� h�in��4.���F�U�y�l^��M�"����\ 9�@�*0n���G�͸��K�fr28���c$PN�BTc4Zr��Vn^��5��9L�&��3O��H�X+b@�;�q�`����Z������"9cy{���2�I�u���,Gc6�br�y ��*YB�#y�6��Ha�
��`o�=)rN�(���'��(#������erN�Ab ���rC�dUrF��|���k ��J�I��kz��J�)
r)2#�%o\31�����r ���J$��@�d��Q��gl!�Jޘ� �SS��a=�(̄������BG�?�ᆜ��?)��l�px�(Y���C�27x�N�e->82��I&g$t�ob��I\��>fɚ�_����HH�����I$g�{wK�<W�(E��1;�IYrN�d�?6Y��Ru��:�B@%}ǖ��>�������ѥҨ����UB�ͼMYQl��;JE����Îj �(x8[>.j���0:�Nj�O������(o��Vd���M�B���Gn����`+v%�W5�ۀb��Q+؆P��R�&��7�+�����X�X:(��3��6!h0��׷����N��	�X�FZ�\�HN�C?$�B=�.�#N�w�%���<��?P�8GX�Ero,�y�[�2�o^��Pn~�� |.�27E��i�y3P�t2
���x^���!��r��Yf�I ��}��߂��||~|~C1'~f�,*D,�'7��r#-b����8Pe\������ '�y����� a�<�h}�P���GU����L:�V	d���&@�U~B0����h���QK�G�E^��F����
{��!;�d�Ѥ_��2%]�]������rL�f����C�D��~a�"[�d�*w!;(/R�A`A��@��1�)K�[�e���1i�Ng$u���䜛�3�:UZ(�c�`T�"��J�j$�����6�4�:��h����������Ð58��f�Pq�JX6JX͟��,��o��E�9ڭ�6 ����Dj1Ui1��w61��������GWP�3��XB@�ƣ'v�i;���^��������)���cZ�lƒe3�~a��9u�\�i2��y0^��391��l�8��@�����E��H���d!�>�k o��M��Ò�9�t���L&�\{��@3�#W�Jը�ّ�%_6G��R����5-���3�L�`$T���e8�d�,;�̠�rTS2���#$N �#� ���q�/qV�5��/w�z���:dC0g3[ia��"�������Ƭ���P9����L$�n��5.b1ظ�e�XHs�y�G7�$04g���QwQ`Df����Y,ss�d�ԭ��{i2����{u�^�Uɫ�y�y���t��3 0�L]j[C��������J�;w�Yr���S��v�/Nz���!a�nԘ���T��8�:Nl�dr��oG��HE$E�샑�Qb��N͙Їd>)�� �W&'$׃���I�~���%��W�*	c��\��Z�"�e�2_�X���+��:��e R,�y~��'M����Z�x��J�=$����5�D���J�&-�J,P"[���L��]�Y8.�LTǐLN�~��M�N���dψ4��ɢ1}�!/��M�#�(w�E
H�����p��ޤ&���m��y�e�F.��(K�ʙ����=����n�ppb�L�4�^�*�"�k�r1�@��D�ɰ �'�.���n��夅�0M.^���� ��Ў��i�_p�P�)� G�<_=�l#�V�Hn�$dŋ�M.����}^�7��ǐvH2�������?���W�T�9(n�'U�mIX�����v����������:û�NZXq�����%�<8_0�^+��5��"m����dnȖ-r �	��e��J��ę�s0�7����8h0�|��|5yk\(���[\Iԙ�Lξ����H{�����1?���Œ�Z���˗(c�n���B#gHml�>���lu��Ǔ0����YZ���Q�@�5TUa��&[D������H��6��Wlq�*%���e=��z�����B���᳾	a�"\�����IMv!I�D]�5<�PB=�PZ�2�z���<u<��Я��dNq<`d�e��kv�w�e�� }�e�    3�x��a����t2G��t����3��kGf�e������nL�u�O� m ��?
��""M�k]��D��EV���UM�����}����N�a�'�h�dy���.����aa?�E�����!R�]%��,�l���T�Qξ/[C��0����^������g�൷OrE�K0'�}TȸOE(t����Uv��ɦ��t��8\��vGΈ�i�T$aJ���EzǾ��cl>��snr���\�@�YN�VRG�dpݍ?��Α��,v>풑����2hBN"����\���>o@Q~	.��d���M�5;�;zl0�Yw+�r
%��/���OC0.�k˭4�k$}c&g��`FUB�HGr��~���_7�p�4x�d�����:GZ66�D��n傜�|���>t1�ˋg^c���`��_q�f%���jG<���Dr:c�~��4X��[(6 $�
S�Ran^��[�0��j��J^-=�[U�<XR�(#1�ɎUv�U���k���V�%pM\��Wr6*1�O�	n�F�+�-�lhQ��#a��Hh���$H�g�?� "��ƛ;M6(V9���25k��1��sx�G$g�6�d$�t`s)�#=��������Y@Z,��br�b�49�DBg(�9L!��\Z�R�DA~Ro��[K�������d�5����T�nyANH���a�%�q��V�l5R���͖R �-C�8$���z3��H�d3�h�d'�b���2\���6=A��k0���������~�_h�M�P�e�aHWeڙ<@���8+���X��g9�%XH)��A�b9Z��@���Ѕ�`�;N�ߢ������c��!��%>�؋/IrN��n�pCA���/��΄���hrG�*w�!��Dλ�N"��2>���p"9_���@�JB��0�$���r�y�'5�9�&K)�9'�5@V�j*wO������8������Ve�40�M^ML!]d|�C�z�Dr21�vy�8y�b� 4L�VtjMr���dV���'e&��!{��x���GC@| ��͖��j�ʭ�(5��	�)�޷�h���8(݋h$N�w��}ů�Ҩ��S.��4����c4Cv���3�L�6��q�8Z#.ZM��	���݇�"@��kخ�#gH(��2;a⍢ʨ\-6跜��ӠQ
4��vK/a��&W��r�(B�tk
(�]�������r
䒽4�_e�)�A���ĵ�n�P�uY��$g��R��V�Ms�����դ���� �*������?��0c+C�'�"��O���1(nJ�r#��F8��P��
���Tu�H�!�'�AfISV�Ż�Y$z˿L#aU�$��m�%��q�\��
�Q�JT`���ԗ��o��R���$e���+������7&�d#j�q�̤=��HNH���o6��,1Ô1���"u�d��_�PI��ʶ]�V����D���^Y\�q!O��kz�ǟVu�2��%D�A� 2KVvR"�����1�>TgX29��=9���v� .L�$NM�Q*�$��a%��;��ew�29!�����I�`��q��&�u��=wn��Vڛ�1�L��H��d\�MH	�D��	P��T��2;����[�+(�ɇ�xZOaQx��&y�qR��3�/��[��gr:_�<?�K+�BL�pd��/�&��ɢWsh5$k_�K{��,+;h�ya*MR�i&��VC�+ɟ��4�F2я/�l[�[��/*tk@"�-Ny��Id��ҍ2�� ����T�r%g�%�g%J��8R�xG����|]I���2^B�|k�(��+���2p�5*	�8]��R�J�٭���rf6�|��J��Q>���H5��B��	K]%,�Ǎ�L��[�HNHҸ�\Qa���']Jݸ��s����ʸ���ƙ���7����h�8�-(X�-��#��͈�;9�`8�?a�������3��3�0ͼ��ސ]!�6^�8oE�Ig�`$*>��N'gr���ooƉq�����~k�oi�e�_̟6��`��ĥE&'���|�ݿ@7�WX����!��)S�6觚�N�c-7���zɉ�Ě��59B��OD$09�0�-�f���l5���#�RC	b�'gr�;�D��zg9���L���
@��[�L�J�齡gi27K��$�Hʼǿ��_Y����:��۽=�	%c�n	�L�ԓ��i�d1������m��;�ɫc�������+m	e")�y?�/p\+ۗ;���]n,���3<g�%38��J�49g@��'sl�����Vs�I�L8q�"9!��92D�6P��ӮLe/��~��ͤE&�Pa��}K�ac$\2﹁|�a��o�X_�v.���O�q���E.އ��ݻ�qq� �=YX��ɑ	ʴ��|6\��P������cP�+�Iq�B>.��^�3��U�/�����[S��rw�2M~�#�1���1���F��hf�͌��#&\k����n�^De[sF�i�W6TͰ5���dr����X��6�3�B�2��e����[[w��눓���]wi�����`5ɾ=����抮�v����Au5��9�/���jwK��j	�m��'�*�k���O*������B�}	9��G�p�+<4Sr��r�v���I+�![롰������� Ao9�<f��kO�&Z��s�K$;���m�drb�6�� �oO��ʌ��K-�?��E��Z�3Kn^�>�� �ơ�7d��r��2#���w�P��C��R�����i��e�Npdi)]c)gG��#���L��f�ŒɫK���'�Y��0d���[?H��c|�ch�K�5�(��W��\�o��I���|c�g�י�)ņ��Krtk]V�z9vO�B�P8��C54�IʌodFL��ʐ+���Dr��#�W�Ë��(d��f�ͷ�A���~�z�Ih�drB��������c0�pj-��'wo�r���#6������W|�\^g0
r���d\��0���3DB�0]ֿ3),�My%|ӑE�$���7����ec2�/0��hJ�5w�Ig�3d��ur=�H^��1[Ny�0��b(__� �t�l1��20
�l/���n��?�p�x�M&��uY��%1yci��GY2=���s�w�tv,�XO/R�����+��D��i�z&X��r/�ƢC^���j�L�c����K�V��,��>�i(�]�Ex�v�K�J�8�- �����v!8ǒ,��e/�ӝ�+��-Y�ϥ���z�曧������X�$z��N]�DAƜ�F��}�-n�����6���3���p��psE��@3d������H��w�۴�u�8��+���v��F��<��)��R����e%�=c*rf`��|�x&�s����lSa��K��ΐ��Z6��l5��2�	iǖLNH�|��i��s��bI�"��V3���NrG���J.�ʞ^lSeG��Ht��:K]�Y�?��R"���m�R����E�r��`o�`V���΋T[�\z�YY�q��?���߿ŵ���^bzz�..j6��m�+z^JTޣKMz��R�ד9g+��'a�cJ�YɧucR�9P�����v�KANg�qO׌Y�8�f��[�]�䉪x�f�l���Tߪ�Xe%�*I�@���p�j�J�ʕtgXy�u�ߘ��my����ܵ�N�HHeM������s�m���ݕL΁ʇ��Qd��G�Y�֖�;�+��Y�Ğ��|��c$�4V^)a
Y��i��s��V��d����H ����H��|��&���b?��*��ԭ ��k	�Z����}L^ygڇ���`�-�b�I
$��Ѧ��|�~�q�aY�A������tb��FH.�I�~
Y��uu�������Qc6��]��N� �/����%KB�U��|a?�x�"�I&?]�1�w4^B:Ғ���mD�Onj�8�t3��*V�r���~� �  n�`6Xy������*Qq��K,?إE3=�r;��n�n����X��t���mJ�k�D�v�����͸�9��Q��ZUkR�F��TFr�PK�DF��т���d�?laQA{���,Y�]#��m���o���4Β�L&g�<�>��=���$��ޖ��׮�]$�Nl,���	4���t��Hb`����w`l��Hg�\eZ)��������;e�_��\�������|ؘk�c�2�� a�k�ς A�e�����o�o�`�������n��y>��u�[�r� �U��m;>� ��z�ָ��nd�*�صdu�v�~Ú�-�o^=��8+g������tQB��]��{8�*��rx��w�WU/������yko�Q�.x6�"�k/���YD03����`"9ɻ9�+B�MC�[�~Ya�=o�L_ЬP�'xg(%��b��$�.�J��-�3I{� �s�S�av/9_��H"9!���������*���i+8�'��|h��k/��P���E������B������{^���9#GDk�\s��Ev�=$4{8�І�|���}�%�p`�g阆:&K�ho8�|8t$$��Q�.�J�p�=?}8G�EB����.�6h�l%ST��N,|��2ق��ګ��g��4|�dn����e�ꫯ�?5��'      �      x�̽ےIr%���
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
Z=o��!��!{�Y|��S�!w����'�?H�E!^��z��}͏���!C&��b�AхZ<P{	�n��>C�h�=�~6��S��>�΢i\��Ҿl��$����I[.�vY �[����$=��[�Toc�S�I_��'�,���j�o�\���~2�,c������T=;'y>��`����Խ苬���k+��3m�͇! 3/I9�^Or�%s,�e�7���k k�2��k>I/{��ٓ�U���G�+jOn �2V��p����^,�@
=,̅�I�
1T�i�w.O1�����7�fk+�ЅO7*6;Ne�ܠV
C�\R�cQ��u����Z��:O�:Oc�N]b{�$�@K��r����Ϫnm %�2�迻���l6�b����"]�k���[������5����9兌��z��Tk ��2�~{�E��XC+���֊8�Mdf�2�~S��Z���ʡچ]NL: �q����Z�y$�Y�:ǚmж�(Np�q���Pz�#�{<ǆ��i��Nu�������d�nXڳŇm����3�י��-N��Z���L�AF���E�
��ׇ;g,��_ ��c$׎�f���2���Q����rR4d�Z�DC���9d�y'ȋ�1&Ȏe�n�	
���qҌ��38�Y�2f��2YTd��᳆�瀉�;M4����-�lv��"f�T m��i3"��%/��;w�3b7i�q}�TF�kc 5�©�"����\�*8�%��6��DC�>F�f3�7��`��a"3e��y��s]6UfJ@&ٚ��"�e����Ve�J��f�G90�n-kj�Xh�Ca�ش������<ת�Y٘%�R�@+�3�4m����Ǵ.\vH��p��	��:x z��j����R����e(si��3�m�I���,��n��K)4��֍��Ѕ=~ʄx��V�ڇq���˧[͹j �ƲԺ�"z|%~&�Bi/r�-awl����A�ܐ>j��QQ�;��΅��5��Sr�N{[�hEᴝ(_"E�:��J��򹊚��+�VS�_��O4�����A�"����7�	��e�A_���/�Àz�jo�tM�̠�.��.�f5���t�b�!���[��/t�y�:��s�,��x��(�EdAZ�:�����^Nz�z�{f7i�&�.��0K�y���Y�:�Y>X��"��B����s���[� �f?i6u��q���
�&<�^ե����J�(/����e��>Y����d2��T��$!�=O++ z��#��y��$"�f^K�y-����uVf��Q?�(��~�tD3�ĄDw*��q�/�W�d�[��X�B� Fg�L��ǁT���!x��ky��A��*B5�*ĬX!��V{��S�Z������
tEd�f�5�� '�0��PAtHt���|X�s�V�3r���,-ѻ;}����	<6�m>�n�������x3������1J9�P�q	�M��Xm�'�)��8D:b�e	��G�=tT��ܟM�UmR����fg�j�u�v���o�vC�ZK;�n�*!�<'�F;� HE⪠Qq܆�9�B-�?�2lS^�;���ye)�7 0�1��1vn�R���l3#��A^���E��-���T�=WcӨ��j궆�M�i�o���}�vj�Yd����@���5ǍU2n�@5��#�qI>��a�������5�+#�,P�Tp9Pu@�#���@Q
�y����8'XW��S��'A{�H�m�����of��Ǩw��6Đ�1#�*msh}Q��[���U�Y'���-��
ʥ�7��i��o>*��Śp�J� 7�vl`;��*��=�����Y�M�}ۥ�΁#*˺�*�P��bg���uDET�%1�3Б����Ty����t\
����5l��_�ll��P�� TD$ wd![4n_�h��X2�ڼ�t'�S8���'��HJ����=��#�й�
u�!G���)�\��K��t����m���ނ�%/�#�#�X�K%fh�9!I���G8����0FJ�����8��_�lD\H�*��)J�˖̊a���2�E�����|��chN>QwR�2s#�l��s2w���;�.@���姺|��ɛ�N��#1�];�cd�}6i�z��^>�?I;���8�B��5b����B`j**�Ƴӯje� ^����zZf�H���k+�H�/����p�^" ^�J��&پ�I�ڑЍ�b޴��6��Wx�e��߆�L_���Wz���%�����IM>��Cb���ҵ�#�7��
�e��,KY�������0�sUT�8��X9چ4$��m���l��D�B�*�}gt�r�b��b�BGn�r��$�0�`�N�T��q�h�m�T���%�����3��9g=��=��lC5fj�(k��mE�G�0�wU��"����$W�����˗������>׼����葾�����:	�j�"�.:�S%2����o�/ �u�x��14^��&��$�AD^t�z�av:�h�� G+�Bb�2���Ý~�0�qu.�{"�nF&nйn��a��N����C;����vVճO̊�z)(+���6���y�Z&�_��7��Wv�v����+���;g��*he|me��ȧ_��Ǧ�w{E�e=�d@���f?��O J��XG��؀g2oH�:���Y� 2�9��������Y��M����|�e��|}����C&U@ب>��i9��!G�x{;:޴��no$��A�;t�ܹ�0�4˞ ��oQ��5`X�:��������	P]pr4��hI�o�̓�C�;X�0���n�t���8������Qhq�$�(���Sz�������CX{����}}���"����C�zlg���Lwn���ME=����q�q���U�S2_����G�J!3��b�����:�6Z�Nz�����6yA������� ���z�!�'�bJ�W�����%�cl��^n�� �I'w������F�Ft����O;p�5e�G��_�F�q[��Oە��I�F��g#��<:<V�w`Dq��Hi�l73	�C�	���t$��fU����`�l�+g��1c�\\99�"��z�1M`�%Vu�� �<�����!�N�O>ܨ*�'�-$U>�"�:*U����bF�I��);���7+�Э��[�[��;�D��J�C����ϧǯ�<\�����+�q��!{��R=��KE�=J��3���%��ů]����z%mh���B���?suA�e��1i���� r�ʇ[�kD�G*�1��u1I��`�`���p�S?u�"co��oT}�"���!R®��E�7Ei�?UU��L	k�0$��4Fy����G�'�2�mq�.����&�7�͸�!m"����c��zl+*���%�Xz}|*V?>��E��x�{��Cv�A�A�ѥ��j`:���
�hk�X���p��\Hԑ��I������]򭴤sm��5��+���,S�4/�!Rk�S��6ѱQ����K$�j�����W    P�`輄Ekgę̐�������^����K*�]�/�z$���7p�QQ�YĝAl�FwO~lݒr<*����`[����᳜ش����+���L�CuEQ#�9 �13��7�E�8[DnD�S�'8b��aR�Pm��C+�r��"�#�GR��ϯ��G����F6�|~�;��(�E�bt��R�N�J�.�ê�7a�N��rw�X���
un٣3M�GI��4ʔ��x+�� =�\{���u`a'oq� ���KL�V㪧kSU����L��\X��f����͔g�"�ERt��!�O�\nP5&�˗υ���?k���,���n�H)��T��$2ѱgo����/o��˝�I���B>d�x��<�`Y	�{F�|^���B��m�����
ml��߀�/,��Q<n��й�J9�+E9�LSRe��rl��Q9�����|��/i��3�F�4l�\��R���T�AW��S����$�$,"��/"=<
R�e�FE��H�C;/D�*tݠsC�wBQSpB��v'����������_j]��d�+�-�7@n���X�s���$
E�*��|��[��ՠ��J����1a�7�w�QF�p�vK�#�!m;���	/o��՜��c��2]�U&���W���>v���\m�O�W�mN�#��']����1_������A�J��y*	G濉�f%b�|E�*�#N�b�SED9E9Պ�h���\D�hS,�1�~��b�g���Su8!h_mI��%�T�X,�m�����J����P�:ڗ^Qo'����Z���ff�"Gh����Xo�c"����=mXK�ˢsn���߯��?���1��fp�r�w>�j/}�W>;	��_h�5DVZ�ٹ�ؙ�$Qf�����
o�s��n�V#۪�|\�� ?(��k3�9�}����ٮZ˼u55Kx���;ECc!ْadK���ݔ��'�I8���49	�b���lm;�������IĐ�5��p�_�]p���:y�v}l�����鋪0B�"�X����[hTI�,���b��3D&���c94r�e޲{���-�zl��=I3�Or�k�oFb�,Kɒ�ET�H�����ͽʿ!��X��ڔ�C�Z���[˥��!d�1�=�{��&�8ҏ��%�e�'=8��5׸+d�<��"^�5��w���ɇuڮB������W�4�%�X �-/�A��j��j��e^7.����R�z��&����/j��B�03�^$��(q���<������A���BW�!���u�w�_\�*v��SS�I�|_#'*6������d��ᷫ�}��7�@�gj��I2\E�`D�D����Țj]B������l���*e	K��� ă� G)��#��m����Gu��U|c+�aZ;R����%�=ͨ r���볺&b!-�1���v^#��6!�(4u9�k�nBl��&f�P�����C�X���v���D�b�l4�`��t||������Y��KI-���Ƿv����
9>4 ��,������?��
�UBNw:�3WH�)ͺZ�Nx�-���������h��X/@�T湁=�X�J�h�}�ݎ�?}�矿+�Џ� ����5:kPP+�{��7�������ِ�X�Ïcn�;?�A[	��H�R�V ����t_�:Bh��󡸋j����?�I�����Ft�V�Zh�x���4�ثg���v�����Im��n�$!�G��� �Um?��d�Q������Q�A�m��rh�ww�1��ۋ����� L���T�`�(��2Ɂ�jc\ �4D�o� '-v^)Ӑ�8���������,�!1�J��ؖmP���d�O��	�ۭ,M�-c�:+d����A��Nj�jBv,�����~����I�Я�Q�>�׎yf��#Nt�CeZc}_��t��H!!�qҽ���\� ��	rp@AF��-�C�[�ne|�MS�A���������a�IL�ǏљyW��.XH�c�\�oB�&YM��܉F>0K}{��UH~f� �.�.;�	zl� �Xm��=\kS��[�����k�v�����9<�3/"�����J�y��A_���W�w����6�CO�@�c�L��ᒘ�\t�~;����h_i܌��1%��H"͈Wu��<L��jڿאa�Eb#�;e�e��b��5 �pl0��P6A��H�grN^��������o�ӯ�5]�5q��z�e�ƹ�8�ؓ�$����H<p���[�@b��q!j'�Zv��V�V������c��~���_���8��Ȁib�l��O��3�'��B��Ӵ���
���]����������!ф	FA��շ�FA�R�e�9�]��G��G�Á��:�d7Td���0f�4��SL���.A�9\����(��[�MD��59��t�&�c���L������-���Vչh�����=|�v������&@���`\hקJG ��	U�Z��vv�b����f��EC �/d�0A�����v���i�W���EKnb1G��$A�$�t�\ȭ��Ԣ>�
���f d�YB�Y�K�Ck�Ck�#֥���_��dO���g=���L �̊T&�k	ص�i��"y�	L��Q�g7������NM5����(���㉺W�7@�<V�9ޏȝ����4�e$%n�Zswk�1����W�1?(!��D�f�B�88��~�{�`����oЈH⎰ bZ�A`���8ȧbF�ebo������<��\Q� �k��|������SdI0�%���VS�h��X^��kh G��K����]���\�7lq?�QČ�A���l�=!��Ơ�ll>=+����ۯߤ�@��(���0fX)�0/ �S�8�� �p�1�$�Ǫi��Dv���aȉ;��Dη���د�N�9�doP���������l3���'}�0*��|���_F��c���2v; �o7�HͿ��;�	�M���/lpɧ���		���L��j�a������~U#�D�y�7LSg��^�Έ��T �ߨrF��7\s5se�}k��(1�j�GA�e&��.419��.W�FT�G�_aF	C�\�]1�\�b	���$�ⱚCzk�02�Q�rCG���ُ�[�!a��*y7ǹ����b1��hJ�6ϛl��r=00d�S�bB��7l	�`&�s*t��kYt���L�i�~}i���/���Q�w�}�����,�����H�o(�/����L����ϧ���Pޙ@�rL۬GL+F<}=]+��YD��s^��\X4k�z�.>��R&h;�mbf|�F`ժt'c�^#l� �'���o�v@�2��h,+��x�Ə�:.o��Ãڧq��̳�>aIJ ܮ
k���Ӣ�.�K|e�~OB�}�ǰX����P��ebG���=Iy��{��zd�_4d�1�䨂�]�CJ����Uo6Έ��ÙE�̷��R���	YBƳm
�᫧��x��As�A�83W3\�%���l���|�mNv��@K� ����|�|>�-
��,��wC���JQ>>ߨL�#����.�����"��t�o����	������q�R{������4C�s��~?9�q t��%�-F9=���E�"�;S����"�Kj�U���)�=7� ]�Yd�r�Up�Z(ɦv\F)[Z��h�>|��JK��\�������A�톚!��A0֮�d��WN�"��4�ϝ�v�|	��*�f�^�H6�l�?���C%Q���ℒ,]7䓂��8#E&�t
����A�-���,��%�Zڃ�c7@�;�?��U�r�ء����Ѝ�� �p�POc��$�w�餃�9f`h���8c5;�%�p��=n�������#q�K�0\dxltה�t�g�
�(��A��ц	�"��u����Tc��8f]�(�nd�����ۿ{����&�Ă됌��a��#Z�y�_�iG�<,���ñ:�+�/��n-�y;+>;�����<�糤�pp;    �����K�w��X�-�h�>�dJ��������n�ؑﱜˈ���n��;�7-��MWUi
ł��F���CQ,��:Q�%n�t�T����>Eq#�i9���Q�lYs��Ɩ�15(q{��hњ?$2��B�<�	�\S��r��H�p����/�9�c�5�� ��n���oM�;vO���Z3�3�V|�96Wu����@Ȯc9�i�=������FӀ��/�������!��s���9�J�K���k
��<����y{�z�Az�Ʈ�[��:�Wf�0)���pr�d9O�{�:V��G	s��(�r�r��Di��P��XsfŹ��V�2XȜ9V�F�B�=`)�a�g]솜���9���=O�x��N���H5�z�~|�Nz#�����In�=v��8 <�L��rjR1YS�}q?��yg��9"OT��+`��7j�A�+k��i��Y��Fņ,l��F��\9�5��Vx�s��+�i*4ѡi���9��ϪZ	Wޭ�0��3mwD@��44�8���HZ��^��Q%eh�me���3����	��z�S��������$`轍�އnTUYc#�@��}�{�r�t{���v���Z�7vR�sq�^�&nsx�%RPyC6넙����H��\�I�c!Aټ1n�آ��Ф��h�V϶0��;�6=׃'J���l
���^�EHd��p��번��ac��w_%v6�*l
�َzg̭�t����%d-��Nz gX'*
���b�����W)�W�L�)�2ِ+��*�ߕ�<G�p�Y>%��ǹ���H�T��]��ȾZ��HBL�Z-����"�̓x]�׵"��S^Jh�1�������F֝F�$Ȃ`���~��֊t1��+ n=�ɪ�O/���Re�̭p��;���M�2��z~�a�{�`���Ygd�/�&��]�b�Fٔb<�����/�t��T��#��n2e���!�\࣏Y���?���_��0fr"f�=!�Mt#�"�C�1������Z���  ��𘩑��d�t`"sY���Ǘ'y��A� ���u�Br�װ���)�2�k������#Nڑ΅Z��U�$�Xlo��9�*$ݱ�J���,6��g�-6'�{2#dԎ��l��L*��O��,��LEM�m�!�I��H�rn��\c}�Ms�����C���� ������&^$��U�v�ctXhO�`{����P�V�>+�y��%�t���1ߴ��Y|�h8�%��!q.�\���� �O�����7�v^�R��k�&.3h!G.��{%e� e}�jbt���㤈a"C�J����m�k��Qt�1l�������^��p�yA#UK+-���F�*CFD�-�A�?� [�ɔl�zԪ ��Ǚ.ZG^�v~݂\�^s	�7�>�%�?�e�I��ݭyw��=�����u������Jg?#�ٌ���y�u�oC��v2z� �#�%G@)$$	�^���^{��V�[�[}H��v�;�k#�VZ��;�#dD����XC���Fk��� �����|�@C���`�{-�j_IPA���ٜ�I[FH�eC�Z�c�+܍��p����_(�QƱ���M5j�mG�H^����eC<��C�[4u��|�� Ǒ"����);v:��5�B�
�#�)��Y�����C��1�]J�����/��s�i^�wld5�A�ĵC�Mb�)t�,�v����*�T�Bk�~#��y<}I�zk�C_�/]ޭ��2G��rM�Ϻu�L��?ޖ��=$q�����#�=��/-ꡒ��	�T?�Y���p-g��9�����i��A{X$Y�"H����+2�X�PB��X?B���&*!��,���@�/E�e)�0}��M��/gZav���������_^�>�?�[M�Y>;M�;�l8�`/�bJ�������26a,g�!Нm=_����ڂ��:>����G���L����DXn%oG��NB��i��M�d�!E��+5M��].R5,J�e��k�=IG�!�+87H\;�݀M��o�>���8�����w,g�!U��(���p
;;֏��ݼ,������zHQb����Geޮ|�X�W�iR��S�O����hp�c�6\Y���%(KH1c8} N�����V�����(s������d�C�?=�~z��o����	���:[��N� ܮsv��׺yU����{�2���<O%C+b�ʥ����o�N2��  ���V�N�@lFF� ;�!�HZ�2f�,�E`�x�Z;4�~~�e�K������Y)L�Q ���%x��럷�݈iV
;��I��U��C�;�6�F�U�zP�j~8}��||9��k�,�vc����4���r%(i���nO�T$l�,*��os��Gȃ
Nh��� l�?�������<)ñ7�X����0�]&�z�'!<$���$T�����ۋb�~�abӀ:��v��ug�ߣl�4�;���S�SB`!{��+���)_�~a1Я� .�����,w/q�g�2�rIO-6�u�CV#;�B�ǽ�Hf*Ɩ��FGO�f��k��Eī��}a!�K6~�r^�����̷~�Q6L�ED�qp���,)�~�x"j1�(c��=����K�Lg�*���iYx%-��\�B�NՖ#
gE��!ӎ]*_��c+��7����6��0���=<�y��x�q�QDW2���F�����c �[N5���I	R��E�U�����φ���Ky�@�1��=��Fv�,8G�C�u�uh4�:-ֲ�]�r�{�����r�qE�kD�n�żr�j�c��^��$:��.U���F �ȭ(;AF2yT79I�"K���?��F��:�KļSb���V@;�Tv:�����|�;�Tl"6�b�Nj��Cf 7�.�w�̯:;�z$��)�]^R]U��l\<�Q۸����b����秇��2�(�h��T��,��m�hBd�b����Y������	�����ʡC��:!�h��X�lK�u�x~���.�3��[y��xݰ1����k��<��t��v�*�P9Q�PY�%�+�y3���@s7W��׿��ң��y�n�i#�P�g�:����b萙��t3^���[3e@�Zs��"om��8�z�A��1-co�����NO��U��Xc�|(��9:�Yc��F۝��'���!��d��y�Ɗ� { �m�5�/�3�t9n����KV��_d�"���9vFݦA�	�.������<_� 6ZF���K��G�����Z�Qp�:8j��hE>��f�J+�:��
:��7�/?<|R�aTdD��6�Bv����=%d7�(�2�xR��8#���d�3��Ec��m�/�&|�fFsFDs�Q�x�Y&���-D02�@��� O���h����5�P�f@�"���/:̀t-��lCA�/gq]CʖX�P�VN������H}t�,��f���#�4'c:;�����R ;�3�$)��!r�M5f�Q� ��#�0�3�������<i�틑I����sL�?�?k_ʹf::���R��	b�}E�{��	�F�����d΋gbd(�ƆKX���j�p�����!�em�C9�9��y�>��-������A*	dnq��%�[Z����)�yZ�:*6QMԉ��S��V<�mq�����<䨑�ȨB�Y]�|�0C���ZB��9����y�C������3�qΈ��:;Z����?�y�sH�NaI�uN�Z�k!��bb�a�.#�	��=8�?�*��#r�B�٤rU!�d��*�}�����9N�ލ���V��� Z�%Kc��A�t�2�)NH�8!X���NՈ/���z�́HK_j���3\Vs���24V�[ f�kj�N@9|�;�v=$q�
���yb��m� p��L�\m���%N5�;me�X�`XJ�1CB-�t��OrmV��r`{�
]9+��������9�;��]{1c s��%���    M�`ƹ�q�N>]�k8Z$�f#]�+>�|w{�,��q���lO�=d6Oy��NC^�8�Փ�C�$`�I'�๟$d=��7"g:�g≕b��Fܺb���I���v�D����n�`��V�7A�7obw��W����m���3�q0�r"�j�ݽ�;e�n���n�����|���?���dn��9���|�/�}Y2��[/ ͂�I�B��8�x�*��k���G���|��|�}y��!���?�,a4�G��J�a�����#����y:��d`C�t6���Ll#b�V^b��}�����7�䝵���k�Mˮۙ�����A�*�h��툸&3ֈ����~�$q���J�![���A��^w�S[�/���؀*�
����_T2	f����^�� �BI{�̞�-��z�#ސ���*֛l�><�r#8%Ă�,�S�WB�\�B�)8J������{Nev*mI��5e�������n�%�I.�O�����ak� 1��1�u,oy:��er��P�FhM6�*��2b��W��z�0�L
O^O�w*��iMOMzfLv��3�.?��<�a�͉��!�{C�'��و���� ��\o"M��0�J���a=�i���~�5��A~*>�x��R����t��g57)���k��ĸ ]a�����,	S�څu���>��o���.��qA��{�b��^�B��+|���E^�h�a�[�����nK��cP�A����F yHN��*�[5�]IN2 ;l5b�y(�%I��!c��,˶��o܈�`�]�4,V8� I��X=�3�
e���"�~��z�k��� ���#�/=���4\�D��pLqU�?pu��x{�����q�Hc�w+�&��xм?�6�����ظQTy[7;�"�F�� ����eBA�o����:�{�p�#�� Ua�?�[q��ӭucpt�������U�A�թ�2�� �h��YBu�[�=�n��rP»G�� ����t:Щs4�vX@4=Q��iȺ�W�4�(�ƾ@f����Z����aݥ��^J��P��x���1��\�&�/�&��5��5D�"o��\��Dݙ��c���8� w��+��@[`Z���^(� 2xFkM�R���I����֍*i$-�D��-gj��,,�EͻH Ca�O!�(�"��F����(h)�r�3�M|7W!�+N)ɂu���o v# <sN�{����[������*,i����B�PܟD���]}��|W�St����7L��9���':�Vv �o$t�=�fQ򈋾��d���ڒ��a�D,��WM�Ln��ZF�z�@����r��n=<>ܝ����]��tB���!cJ���K&����>�?Ir� W<�Py�y��Ŋ�~�4J��K����*F��4nyW<>�Ƅf�cfNik�S�1,n��������Mu�)N0E�(�-y'\)��b�s�f�qM�؋��rwKiG�(���i�� _����	���$2��E� O7Ai[��V�aY�����$���Iz���wk3�cn:kA;`�~ܲS�����"�6�B�V�hYK`2_&B�)$:pKe9F�=�]s�S�>:�8>csZ���B�+�n�II�����S�qnP=���7#��rH5�QVo�N�F|���P�g�T{[��ÿ_}���J��n̕�[o�\��aP�b:�e�p��O�� �F�"��K�h�XrX���كD �3r��"�����|S�a����p��X���~�C�{�t9.��K*gM�"L]��P6�S���f���1���������M��.e.�ؽ�������/�ݤ��1�u����Q��Y�Ed/��}��M��9:!�4$�^��?�����)��4KE�a8v��I;e\��io'>��~Q��Kq���"�fߌJ:U84�)�7tM[	;2�������W�!P��Z���鴶'��T�mxr����%P�<���Ar�>�a��y��^�����������g�C���I�(��CzD��#��l���v�aR�	��ShZG*퇹~�nv�++?f�,�L7�~�<�24n��EA^� ���C9���NT����Cm���m:vO1��)]K�1��}#@.?Ԯ|h�;�Ŝ��c{\��@ռ-��w�����a�3!��=��j���*�Hs6l-�obC��`�����w�`+��Va��v�ɛs��b������UFM���2m9F�ɑ7��t]Gf/��
�"�yf�;oa0E�nYQ��l)G(a����?�kMA��"J���F���z��r�����4$�{4�|$'/��o3r]8��Re����G�.B���2.7/�����.����d�9��oO��`�R1yN����"lU��Q�	��bȺ-�ݾ<ݟ�ҟ��;��!���3�����{9���;�5����|�;�{+u���vd���mWb�wZ�.����/Jݡ�6�X�kj%e�'���Ә���F��`�~��Y��
�F�=�Å�c����O�}�'�!�_�d��������N�L���h����!@F
ogyƤ�I�ڊ$�^8וP+�I��ĺ�2������45���Zc9c����� �y=6Uf��-L ��<����&�LXg�^n�䉱A��=�G�9��QgS���)���KOi(�-�%��[ud1�Q�7Dǘ�5�L[���-i�~ ��1[�]]���x�V�5����;�$N��Y��m�� 9���.�����v(
Y��o+�Y?I����[S��dv`x�\wx�ʭ�i�����99�[�p|\��ye�:�V^�gU��$R�V�i�8hkܗn��x���C�敖.������^.��I��Tlʑ@b4o�#9x�[�F��.U(J9}����r��l+#��f�(�`�>[�ݐ�i��q����m���;��xď�	+f��޳՗ۛ�$U�44̮2�����Ͽ�v�8b�R��f��ĮR��f'�����2č�^B�eB�l
�7@y���̤D��*錁�0�°���(Ր��Z+Z��v�� ����R
�f6�)�|ܶ��?q^H�X�6����z�ҋ$�IƝHfW��?�������/����.�(���#݋[�F��[D##Wi�+��A��3[}��W#��5�{{\{>�i�E�|�S������z:���;GĊ��AZiȤ���\�b�[6� ����i�-#��������X�'כa@´](�����E�~�՘U+0f�
���zn�.L�g}�"@f��:ck�p�T���.	�*sywXl��˳�у�>Ԑ�*>;p4�0�KG���(����ŧZ�0�"�h�r�s>/
9�\Aɳ�(�O�O��$>TN<z�Ð�$b�S�
2���N�Pfz_y��B�l��?3���v��-�Y��i5�;�Rݓ�eh�Ce�������M���d�*��I7�+}eFAD�k�;���HP�k�+S��zx�lS��ݓ��v���qt�g�E�Q���"��A�Z-��>L5��s�=��Y5Sℊ�.2�r��p���Wr���W�zM׈$fg�O���[��0�"�����Nb:"��lX�1{IP8���=��7ww�u�'����l�է������C�����.�Cs��@t�:yzY�b5�D���L\�nk�_?�	&�	�C�S�8�t,I�{<;#m�L O7޷�č��K�Ǫj0��CA7 {��\�s*#�Iٲ}� w��q��P
����xŅ��j���T�uD�v����RV�T�Ù�+����-Y�;�<��	����αb%�f�b�g�H��L�=@ٝ+�OZ��z�����h��
��S��T��L�m������|Ql�5B>?��ej��^��6ʝƓ�h@u7#c����+c[��-��SnU�hï,r�q�l0~!����;R����gP�J^��zXQ�    ����(S�Ɯ��͖��-�T�V=u�1ԩ����דT�(���:�ء%��+-�"���A|�9d��S���Rg�lO�Qe���v�T2��b�E!}�G��G����w��Q�:%5�x>�*��J�T��� 'Y���㕥�&���Ŕ`N`8�Jul�7G��pb,��r1��]� $�#d��� �nl�6����e$
��u>=����H>�'Q�%!����y�h���̠LG�-��r��7G�e�'�NHۧ���x�[��1]c����yB�2I��?�2U��F3�J����7d������w���,PC�����=�9B�?	k�:���Lժ6��")�Ǖ��ۼ�QI�ib�TŁ���Y��������Ӡ\�D�^�+�֗�G���;���?��㍺Y�QO�=�N|�h7
��1�C��"�r���sflEk�	855p�D}���Ow2����,"�ώ>o���N�<��y(,o/W/?�%b�g�[G�v�Ɔ-JeĂk\Ϭ>_R���z���_�wդ�^J8�L%)x���A9���!�^&����Ǝ;B^b�% �FWq�?�K~#$y�p���J�P)�U�B��s����m��f�����c9R�ȡ, �D��'y�`�D	~��.��-�h��
4m)�	�����$�!#�_�<�1��q�&�v�6��f#-7�r�R������/N<��]nt���o��#���������?�&���?\����qgԀ�k�����1fͥ}�r���P�O���t�;T�F��k��;('i���T��+�|`�o�-�֐/�4 k�B��l$�0���5m�v��z��9�]�2�d6!�_�jek�-��������n�!"F^2�Kv���o�ʍm���p�����f����/"�j�Cx��|/2>d�(u0�_Cc�)a���"�=�Z�;�������#�@aAv�14�)89_5E=G�](��O���'�)��/�����gݜ�ƳZ	u@*�#��*h�ސ$�g�:%"4I
䳦*�C�����â����#�$���4�Aȍ�M���:ݫ+�S����Y�ߨ����X^���SW��ċyE��_t�}�,}���u��޼��HԽ�!���}���N�;�S����7��?�ڦn{����W�/�ٜ�P	}j���9�5U�l7��~�y�=�k}����Ie��!$���QM�I��H�t\'<���J}�Í��)��t���gc�'�bm�Ә9Ӑ��lc��&a�\M��NY��Zz�[ԊD�B�0��$fy�.�T��1m�(ĉG0�2�����Qv���o�[)B�c?��J�����ᓔ4J� ���;�%��6V�3��YF� C��ILV��3��,u{�d��1��R;v�ZjH�8Y��ܘch���o��L�j�h��ǒ�ɍi�x9B¯�	�q�`�-�Q� !6rY4!�Y���M�r�^@��W����d�
W�k�!���1�*�O
0�r��$�x�xg\�Gg=k�va󵧟�wr�`�+��z�3;Oϫ��O+Ǉ��R�M�l���ͣd!�M�46�����|~�J����$/W���A����J�wK�Jy[�E���Ϫi����W'��<Bn�`��hQ��m72e�`.<�V�t#$����pn���ܐ�)V��A��L�B��y��wq��J�B_�J��v7��(��u�ӏ2��,o�����X�F�P,�T`>��C��`�0�/�U���K	�g�Y#&�����Y�<�U:��\������]$ �Ք@����ZJ��j1v��'ɚ����_rݎ=���;u|u���V^ڷn�2L�r<s&-E�X��;}|�%�2461o���n���o�d�#���	,���*�*���Q=)Trl�eK;��n�����������Nx���۵ǔ�u[=C8W�=�l������!T�Vn�!w+�	��Sr�47�*��*/Xɍ�7�Oϼ`�5,8Q'���m�o�����d�=+]��*���ZkW[�x/���0H�t+?q�@����1��a���'2��~�[�mv�}(���g��� ���G's�
9��72�?��!�M��:���]�r�x�z�
J���-��J��ܹ�܍-�����k�p:E�����md��;��5t�w;�wOáQȩ�kÅ�)�#��0��8����ݻՄF���K��9���N� ����)��l�EA!�T�U���~��q�4�x� �^�N��9��+�&�W&���Jv�e�ZÇ2uD�එ�xY���W�n>+��e��^Vq��1��JKQyr�ySkFg��iF+ v�i_E�ݷ�V��wǥ�5o���r�+��2sr"RQ'����|`����n͆N�Ҭ���S%���	�2t���o�IV���A�l��#
�B��U!!]W�?�ל�3l�,�����(�,E�Z�B�\8�?�"�<q"Ǣ�G Ͼs�~�LX�K����sC�|���Jj�bR`�!YB�T�yD�u	{��Y�j2"~��\&���*�Z�s'H�c�o>����P|�2|�
+Q@�;���B�ʴ��@���$h�1�اI�y)B��m���YF�M�H�6U: b
��?������w� ���@�~�ci!��%� ���m�Jʐ�'��J�~�R�!�0`()~O�*��v���By�����Lp C�f��Q)���E�9''�E�B�E����Td�E�b�@A��
7��s�M![E��o�6Q!��/�wIfv�>��
�r����J4�+"W�jKw����)�?�5`��lk����o�HGz�*|
�Ҽ}��7*)��a���?)�4��X�U��Ȭ�0ڒ�ӣ�|Fi"��j�������k�h�޳b�Bm�(l`��ώ7խ�8΍�tf,?OyCq�T<a����;	��Vу�Z�w�s(
/ܼSe�"I`���rs��ôޮ�Ҵ�n6�~8�x��r$�
c]��Q�{�d�#Zg׺<�H�f/�n��U�X{G����}ͩ����L\��^�Ĝ���Υ�8A�0��?�k�qQ�M�zn����O���K�������d�*/W��nU���ia&y�$�_�θ��r����D".��F��O	���{نbH$�[�ODJ��
!�P1�J1�8��Tvz���p���H�O[��fU� iW��)J��4�{o�.�F�vh�Q�,�
��׶1Z�Z��
/F�-D�uIi�����9�BX���Y�pk���$�>��؆�j��_O�D4}!Q�wiUv	�����U�r�yt�$���C.���nc��$�3��p� C�=�f�0#�:�Ģ��%�Ǉ'�����*{1��.�>���3���(l,s7�je��#a���܊>_�͛�n46	�XR�2��VOz<�o����i�\�:���s^aǶ.�z��5�T���4a��Fc��=	��<9@
^��f�K8����s�io26I�hFTF�9'HM���@^��uUs��i��\�|>}~z���S��Si6�Q�z��F̪T�L3�ێ�K]��+�($�=ڿ1w�\P�6��*�zf���?�m�<���~;T�s���`:��?���~�뷿}S�a�<��s\�s����|=���`��U��j8��%�2;�.4yWkXM�"�nc1Rh EP�뙉��R�i�,-Wx���
oV���j�g��Qa�s�a6������Kl�${�/A�K�}���P#�#���)e�--M�g+�vd#��j�e��;a����h�A��	8�c���r��"��tq��G_��AnTsd+U?B^2a>50A���x!�O֊��;v(�!lT�9�������Ӄ&=� �NX�H`����_A߶�#T������=�?�����"�k�A�-��1k�w�_
9�����&r$zh�Qr���"�G��|+����3B��E	��f6/o4���>n����"q� �8T=�h�!���|\%���	�D�SfS|����5K��s �   �D�Fӊ�	�U�K�-I獺3Av�q��� Y���*� �����<45A
�q���3�u�W�m6�5+A6J-1������̓L� ��8��MFn���� ��&H�l����B���QWU ��8� �؝j&mH��AWf$v�6�#g��߅�9۹�j�'9�+��������7�*��K���#���z0��y]�3 쏇wy|������˿�&�B)      �   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh            x������ � �      �   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
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
-Pl�#�x���Bԩ�E��&r��Z�NM�d:ܖK�/<8T(Fo�&��NMd·��A�Wx���B�m�$�9�C�(�D���~!M��6�����κ\n;8k����ξ����y�^��BM��m'���m'+f�m'k�m'++^xp�P���m�$Q�vpҖ�n;8�j���;Y������S����؅�=\]_r�[���,P�"���p�(���߿�?Qg%a      �      x���k��(��g��L �@���A����G���������lB<��C��+_�k_����㎿��_�K���p�!�_����R�5���/2bd��#3F��s�߄:�̷�����]�_qywqe	�/�4z4u���w��s����P����n ��3��?[��F�׭�Ģ�X��e+X��ߟ,$��`	,��%�.[�I
�]�RVW� ���%V����h�X�K�sq]�z�{����z�ۀ�ˈ�ˈ�ˈY�^ekBĚ�&D|�F�C	�P�:��%�C��X�֡�u(aJX�V�C+֡��/�)l�BbRؾ��:��}�"�5k���U�|A�J̅s��\01L�s��\01L�s��\~MT �eK)�`J/����)�PJ/����B)�`J/����B)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����R�@)}��>`J0���L���S��)}��>`J0���L���S��)}��>PJ(���J���R��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0�W}�-$�!J�U�|�u�Rz�'��&�>J���O����C����"K�$.=�½H�8��;ȁU�A��h���#GX}�e;��;H,�n~���$��7� �l�')wu�L�tr`��r���X�#ܼ����� �v��wƉ{;��;��{;��;��#ܼ�ċl��w�x��p�k�7� �;��;<֡n�Ab��$?��p���7� ��p���7� ��p���7� ��p��E�k־n~��B�y�w�
;��A2��Ab	Qz=��A�a���Ĳ��|���Ĳ��|��#!�I
�]��zȝ�#���aR�<��-G�U��I)똇xg�x'��u�C���zK��oy�:��_�O��=�e+��e���iQ���'�%��0:�O��/�
z�qK�Q�H�}�'n�aq�Η2��^�߃�v'�*k�~��ܓb��]�9�5G���@����{����c��$^�z�y�w��fF����{�u�R�1O����c��$�!J��<�;���G�����=�g�ӽ�U(�1O�.�1O�����1O�˖��1O�˖��1O�˖��1O����')wEc���H�CS�?����G�`��`�ӽ# ��\po�ib�ӽ����[j��t� �~IMc��$�-��c�$�-��c�$?�*�Tw�����Ju�<�;H�C��y�w�X�(�� � �Q�;���&�>Ju��xg�}~��F[�(��lc�k P�=�������ְ�4�d�J����4��g&w��K���]>{7�Ǘ$(�h.�[�}(i�������}��_ą||z������ĿJ�c�/QmU��~�󺭣&���Z]�}��6h�郿�k����OH{L�*>]�!|�Yp��1���t4Z�M*��T�$��+FWq_5��T�&��وt�f#2��Ij �85{����5�f�1�\������ܧ���A*�C�����X�X����@rq]�z�{��k�q��j���x�Ӭ.�z���@�=��	�@���lD���u�ئ�i�%�uH�.H~�aҬK�f]2�X�4뒁�:�Y�$�!ͺd �i�%�uH�.�!�	X�4뒆Tct ���`t
V�a0�p��1KHsj0�pY�K��d=�@b�R��G"�@�U�u�HC:|?�ä�U�D0Dˑ|U�qR��G"��;	%�z$���zKI�M$�8�=�`|>�#����)i�������G	���o ��Qª{�Hn �}n�<'�]�RJX��vol����%��z0�����������z0��'rM��G9�L��|�`��P�z0���KL&0�X��=��˖�n=��@b�RޭH,[ʻ�`CB����
�"=�@G��v5���G�`)�׃	q]�z�{K�z0���Ż��!/�8��H,[ʁ�� �eK9�` �Z��U	0��VB	�` �Qª�H�C���!�%�zH��M�}��z+$��r�CƑ\�ǡмz��?n`}���x��������}�ǿ��S?>N�6�_������9����%N¸�j�ӣIY����@��Ī,jy8�ϕ��{�KJq�O��0U�f)с��iW5��TNHgC���)�:z�S�y�G�KY����#c=����ݕ���C�-[Ԭ:���f�Ёx��)P��*P�>�FE�~�� t������>��s��O�}ցtYi^�:��n1ԁ��-ԁT4R��a��3H7�b�@:�ҁt:4z���t!k�J�"����ht�V�4UwiՁx�luV�V��ͪ���QwHՁT��Q�F�?q���z������Uu/T]���"#�������ƺ��������������0B��ZΟO�����h�f:���h������5������ߩ�q=s��|�㺧���%�����i��jLsiO�f�ٜi��@1�Bk/t;���Z�Ak�S�֯3	��=�]���B��:�;����1=�O�t=�Iv�K(�]j��)����v�ܖ�X���aMX��wq5ߕ�y���k0�sRK�t`���r�\?Vu�K�5���}��}}pY���\خ5����"[.qpR.g�]��I(/��?�����k��ke���ˠ^�����GK
cK�%����j"+w��}p�^�x4�n�C�9�ѕ���W��_�c��t/|H�yhr�]���%>�iMn����c��}�u �)����:�M��ɮ�����u #���N�:�* �թ��!�������
�������"��A�o]�Vo<��������@|��'w��]_�tk��H��]⭊� ���N�:�JZ�tw�O ����N�nׁ��mC�k���	��׮��@�;��@�9� �����A�+��d�����?�|�����ۗ� {�i���T�qdO��G���:�����������[/������kW����A#l�ϋw�]|���\��`5�ݿ���Lm/q�^\�լ�a]ֲ�8�`�A㥽m�a�����o0����Jk��� �7���a��F�%-��&�c�N��&5����~�f՗ e����֝���j3?Z4q_�Ww80k���i	n}T�=\�%�9��U:���M��A���'�w������F�ov�+ld�nb#�h�v-[B�sN��ĳ�5��H���U�F����l�bd�i+f�xd#{�F[@|:ӹUo�76r�H<+]K�-۾)��vM:6/�n ��ě_�ra#qo�����k�0�]�����rt�%�%�����J�5�~��	��T�l$<ʔp��	�%b�F��,�H<NzyS�l$�zy�G.؟�@�Uz��G/�����3�[���&'�-*a�8�NBo�J$���zۍe���`ًf�g�g�6��h�G�5��Hj#�u�Im$>(�P�l$�K(OQB����������d[�'����g��K���l#��'�HL�χ�&���pm��֥�cm�u��T�BJ�IeI�ʳmz�������\k2�m	i�F�w�N��ӢwA�h�����#_�orT�<��R1-��[|.��_Z<@ku��QB��-���[���͗���˞��+u��s��չN��b�aT{֛�K%�..q2��ypş���e[�[G���U�M�����T��cO�O1J-߾�,exb����񟉩e���(�6��]���bjS�o�c����1&�G�B�����
�"�H.!�J,���+E�F��x�    �
�$�H�	�
׏I�?I���pwW�L$������`�i,Xj�S�lq]�z�{Km�J����'.~�V��u�wLjmTl$߿�.P;��`#�l�N�W���p���ᔘ�o4�Ф�-�H�C�ФD.�H�C�?*�6��J���M�}�?z-���q�Y	b����Gc��xzq�e��`��`˨�`��`��Q	�V��_�~����'����~_-��;�����A?�\�d�]�̈́_-�n	e[���&��3��v٪�}L2nz����I�.i�}\��S5�Π������蠽"Ƽ�����U����X�k����Ѩۖ�]~e8dm�����~ڲג�p�5��u�|e(nK�����8��p��s�XGך��	T�E�$��ya ����Ģ�Lx���'k�xV4�����T�����W{��~�� �}U���W�T���a�j�8�ܰq�ө�zH<+�{���YQmq:V��H�����[��T��$^-����R�	��h<>C�ߋL�����ݸH|&��H�+hV<�w?�g ��D��ȧ�ćWͺe �l5��Ĳ�lT�77�i6*���@(=^�@��/d �8�Χ�H���x!��I)�/d �&Pʡ���@�U�U�x!C:|U�aR�����H�6�8)o�ㅌq❄�=^�@b���$d*z��1+ʫ���@%^�%� �O�@b��$>(���$�K(7�ㅌ�_�x!��O�Z����+���m��>4\�F��/NJt�H#�'��z ��ċ��k=��8�&`���Z ЁP>z ��ĝ��\ 0�\BP� 	W�@` �8)-�$�J�� ���
ww=�@G�M��y5��X�X������ ��� �O\�h������H�a]��\ 0�X�����x�Qb�H|���Q 0�X�(�$�!�� �u��G=���&�>��@`�Ш�Hh���@`���o�J �!#%����@`�����N	 БЦ�vԊ!�P%��0��Q_,�?��d�Z���t��	[��O'���9�U���TE����m��TIw����꧶6�oyj��6���y��Zpifk>L�[��㚯�!j�H�)1�|�Hf5�����.�>�7��).�����o�����j�����}�ܩ��vAf.	����f*�6�kS�6u}y?Ulef�d�$��}���m��a��mS��2U�f�m^�Ψ�)6/3�����Ԯ��H����Lmm��M=�T�z�~����s~���=�j���!a���U�jH�;s���&SG*So!in��^z�Ω�{��)��&Is:�R#�TuS$N�z�\s��9�S�RS��2�j��S�q����ڛ��t�!���i�&M��S��s!M=��Ե�N]Sf��p�{%��oyjߦ>h����:u-�S�B����oS�}�����S&ϕ��u:u-�ka�Sq�xT�{�=n��ŕ��V��Q�� )���!�Q�|�e�5��o��ZШb��6�Mf���T}+SW}�;ҩ�[�z�N}~�e�T��!e�y��]YS5d���>��}[��өo�2�9K�:L���1��"S�Vd��W�>g��g@�z�2�b&S<e�3��u����&S�dꃧ�����#S-�2իF�z��ԛ�L}>��?2��t��L}>��w$��+S��d�c�Lu6��n52�5v�s�LuX��o�2�5v���}��S�m�e[��/�Է]�sG:�2��0�V#S�s��K0��(S��2�"S�a._����:���7թ��2�P��g�T;�L�[��0�0���ڑ�\F�l�<��=�=���E?��侹mO~�~�T���}sy�R��E�C�UlO���\{��㡏�w��5�1�$�2��X��os�?�v�kŵBN����w��c�a]��x����ԠѰǴ�U�ֵ���g�ڜ��?q)[Iï�2��J���T�	���������0�n6�?!��g�QC��尥�����݂e�ć8�g����gm��R6o����?�E��Ғ��?�>?�Z���L�����.nM2|�H�6{�C"��놞׵�#IM�d�غ9�}��n��*)�t����@�oj���v�@b�j�M	)���o�Y�R�H�M%�������-����vF_�4kF_1R�[f�����@*��q�өW4�xV���V�S�c�l�o&ZqE��T2�x�h��R\�@*��R\�@�CP+�h �e85�x���H|5�r�H����Ĳ�2H,[-�q��O+�h|��Ո�P>��0��:$j��	w>�����kL/�h �8)�Ћ+H�	�r���OR �*�*jqEC:|U�aR�"����$_�x��7�Z\�'�I(�Ћ+H��ZqE	��^\ј%c���@���1J�AZ�5H��` ��@�^\�@⽄r#�����A�Z\Ѹ�S�V\QG*�ҩ��6�/N�8��ċS+�a ��Y/�h ���Z/�h�\��Qr�WԁP>zqE�;Ki�^\�@r	A=Ћ+H�R�����r����Ě@i�Z\��$���]/��#�G��Z\�X�X���W4�u���-5>��$?q�^\�X�xǤ��������J���˖s�����^g����$��P��W4�X�(ԋ+H�C�?��$�!����7��Q���Ǝ�JzqE	-�VqE�WԑZqE�JqECFJqE�JqEc�ЕF���N)��#�MS/����R\��ۯnqE�W4>	�zqE�W4�JqE���*�W4dK=_�+~��������ѷ.���Qײ��.9�>A�n%D��jy��4�E��Q���>%lX�[עm�|��Ƶ�"$kr#Jx-w���z����k�OPh�!Z�	�O�[��-d���j�PH��P�z$�Ȥ�64_�z(l�B�
���2t-p�I�&z-X�ɷ�/�>�!�FDjٷ�4�����y�_��>�"���$q��n󚴵
ُ��/*��C�{�Ts�зֽ>?{Xj�yq�sK(k�1��(�5d<<���]M���֭�����i6^����ܟ����R��ʙd㥾��\�SQ#��ŕ�����M��ڻ|to�ᙕ�x�vH��]�K1ɸ��oj�'"�Z����P5�Wws�Z�B^:D����fx4�|�\��c�⓸�n����� �G玥�cjK_������NF:z�㮐.�̝��N^7�˲�չ���=U���R���اܺKYb��]wx�DT:��-��#��YB���<�Y$tqO�T\ɩ�Y̳��ʮ�h�2�2�yv�Z�n�H72������Z���m2�C��FF���}�|A�(H7
�!�ނv���� =,H�
ҨK!�OPH��f6]�F!�� ��$�'(������W>A1�t	2�_��|�B�����ƮEJ>A!�b�g�$��zE�$Ȉ|-��	
=�#��� �'P&��-S�q\�ӎ��'a�q�'�aR�M�Z���/dS�l�D��d��T��vl���;v�7�����m�]�Ѷy������	�K�B��ӳX£.ܧ��ڇSM:]�ŦTmn��17?�a��V��ps7/	�KL���3}6����쯧�߭{H�s%����s���K{Gc�hr)���x�����{����y��0|=][��f2U9��ט��d4Żm�l.��>�8�����)>-�k5Ջ[�[7�ƅ�{ԕ�b
��:��tl���|����;���Hj�|�͡�y{Fi�	]��T�I60*Q�n�ϼ�*Ѽ-f�k���?/��,��;T8������k��-���J��ڠ��-��@����˺���]�;Y<���H.�(j���J�K|8�ϕ���ܲm9:�*�*}��������3s	�]�Zb}Z��1�3����V����U�kbz}Z�q}Z� �&�{��vs�_�/箾��mI[HC��g��i�qq}�������{��bJ�c~�Zk�$��Sh �  ���թ���߷��?n<˖�z��'-c�!�n�vs?�7~V��xя_w�g�r�O9V-n��W�+��<rۭRRr�J�����J�q8`-�r>�j�XS��'	�&�k-�Qbi�� �|(f���h�X�ҙ�޽�Z%�Ԙ@�?��hN��]��͆��V"�rr����]Y�5��ל�*�K�nɕ�����bmZ�׃���@b��2�H4��?����S�j��!�8��j}Z.�N�o|���W�X��qƕ��7L�rW�k��X��Q�j��(!��Zqs&��]M/b+�k7�T�p����{A^�z��<2�mXJ�C J��T^0��̩1�!��i��]�V/Lex�J9���H��߆��
}=��+������`�i�-E�y��v��Z���)�Z�Ҽv�~��q�z��57��}�k!����&��>���7(1|�j	f��O�)}k䠽��aD��T\ݶ��1�(�:o�Z�gKK�b0|Q��l߄l�Ά����lH���:���sѨ�a ���lH<Njp��lH�	�<���0>I����Ԣ��0��W5&3�D�Ά!Z��k����h��0ƉwJ��:�Vg�@BҬ��0fEI��#1P��a�k����@b��yH|20��:�%�m�u6��>��u6��?ju6+L��VgØ�8�<�/N-O��ċ�Rd�Ά�ċ��k�Άq2pM��G�u��Z��a|�'`w��iy��<`Z0-��lH�R�:���r�Ά�Ě@i�Zg��$���]���#�G��Zg�X�X���!@��a�&��[j|��lH~��~�Ά���I�z���/����u6$�-%�z����(1��lH|���Q��a �Q����0�X�(��lH�C�?�u6�ob����u6���:Z|�:��W��a�����7�:���:�7�:�8���^gø�)u6t$�i�u6;j�k�Rg�0��Q�;�Ά�M�Άa��E��a�[ŵ:�l�Sj��ٰP�	-T�Z������b�j���Ԥ�P�)YT��{/k�<�ݧ�1Q�Q��>���)�"ݩ0a�hG�X�9�d�Ռ��pFY}�C� ��)2a��,�gK3Qh��g�1��T�>ӗ����w��l��f�dx_.�Ty�Q��L�8��#~M��w���G�}v+k�a�'c����^���/��kEˊ�kX��vW3�,Erv�ͅ������ǚA�o��\������\�����Ⱥn��<���(����s�-v'��W�>��Xi��������Vo�mK����>�������_L�0ʻ��E/^�{YWxj!#��Z;�ܡ1i+�s�S*N~㟚kN�R�K��)����F�>�帘��l�)��:���b\�g-����j���+�քHB�	�kV��	����e	��<��V�&��F�s\���c\rI�} �?���!ǚ�����2�L���*>i���JXS�Yt�n �gk]�..�K^qga��%�[��!�rl/a	k�n������Mj?}K��2��:�rL����P��"��ҽ�_C��}�;u���D!�{_0�D���}�����t
F�(t	�/a��]�(4����,�}�[h��8�(4_�9�Li���/�`��,�g�3QhUޗc0Qh���1�(4���L�}a�f�����B;�}a�4꾰��B�q_X�D!��gk4QH��i��o�w
+�(����v
+�(�t
+�(����

�;�Lҍ��
&
qd��V0Q����;%L�edn�H0QH��d�)�`�s&��ǸN��ƅ�N:%L�/d�;0QH�̚r_���^$��b&
���b&
�2��t��w�S����jq����8=�:lZ�9�[���	3_<�����;MR���l�bJ^����g�;�r�\,�?�__��Ju���4S�҇� ����V�?3պ�?/9)��@B-�|\!��R����Zo�j%���Ϊ0����˳�˫�VR7|�� �w�?�׉ne]�!׳qxK9�����社�m�2l���\<:%�t�!CV��9.tݗ07�����%{��Lw��_�L�܊�;:��Mr�cW���u����R+�$_\W���⛩�z��m륬.���3G䣙C��^���$�q��u��퀬S�HT
/�<�c�LKq[N�Ϸ�����=�T�ym�պqqї�F[?k��o:u{N���rM�n���)��4��!�LB��bnvt�J�i�8��rxx�E5��D��E+�2=^�hm�Q��Α}�-��o^J��Z����PJNa\�~j����o]-��Kk��VN�9�<!�=�v𘘸D|[?����W\������/��b{�8Ε:�j&�k2��ձf��y��G�u�5��Yd+H��ۣ�����>�8�qt3z��~uY�V_/g���A����Yf�)�qg��E׷|,�"�l��Z���R_+-7z�_g{u�;Y]/����<~l#��/�nh��Nk�dq%��Fk����4_���.��>���}07�%�i����V*��k��ǻ��br��-��io�Y�O~"�}��*k,ɏ���s��/�Y-���Ytˡk� 5��Z���)��+�z��%��m�Tp���\=�\͛;>���O���������N��6��xP�?��N.��i�G�&n���L�|�N��ZV'D��j>κ�s�����?v�Z�g|��5�$Ju��9eܽT��N�ϳ���������mn����~�$�׺EB^f�d;���׷��|喔�^�?�0_�ޟ���`�u�s��?�����0�ݣ%�.Y���"[���֬9����ْL���2~��3^'�Ј�Ci<��w��j>��#-~��H۲��O䘚��t���2�O�4Զ��0|V��픬�^_�C��A=�JZ��#�w������J�      �   �  x���]��6��5�b�@~��]�Ţ�Aw���^XhleƝې����Kٔ�!�؞�@��N�P�sH�G�y�=�N�w�~��ޚ���F0!�c�;��� �������w�9���n5�ݱ�1t`����0�y��`�_�+�ƺ?��7��@�כ#!�y����v�=�L����i���wT�zUDb��1!B�@�"��Yft������5���(�7�3�,X�fF��g"��(����@T�e3�l=�OHnVD�7Z9Q��YqO�q?�֧��fu�{C�kml]�!�X���3�m���w�㶓��f�>�۰m�@ �t,!F�x
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
-k6i��:�WR$d��%,H�LXd�Y�y�� ��L0�kfrb����X�f��� g92O�yN�[��@ƪy�3��NC��E3���^�Ma��"n�m�HtO��.̄�Oi���}Z: ��������1�      �      x������ � �         �  x���Mo7���_1��6?�1s3��H�>�� �hO)P ��%�d���ڬ�=�JϐzIj�B��������ˌ1��N�ȋ�%�_������?_�O���_����\���\�u���C���9v��*K���y]��>����=��KǕ#�L���/��gl�� ��8b��/�鶚��FG�i�u׹����3�y[.Uk����g���!�pbG�	�P����G�=�,B��'���/�ݏ�C����zb�<�O7Xl��̀�Ў Y8/<AX��s�=�����.t�*��� ���?
��S���$&.��H#��Î#Ɖx�8>����bCC��ڍV��H��K �$�P��aj��L���<�a!������|�>�mlJ�ŖU�+��SU���R|�Hm܏��a��!�`C2I��7�?�T+l� oPh�R�z�*3�8ˬ6���`
:��ޚ��P��j;�v���ɲ�Pp��JNƄ�h��gn�m�X=(���	��|�F��TEC[��/� ���z��Bk�2T�Nd ����q\"vwS`��'M@�����sM���]qD��/2��x36�)�Bz4��;uŗ;!�^I�Ϩ&ɜ�V��z�U�Ө;�)�6Q�J+N\5E4�)�%E�Y���|��O��L�_߯=?|�cz����qzzx|�8�ErJ��~����Lݖ_mbվ�4#���h�׊��j����x�����~C@40ަ�6�d�8��@��N��g��H��ҩ��}f��?F���*�Ԋ3�8؀OQ)�כ��qpy�~!mw�S\Jq�D�IƼxr�R|��r��������ɂ����Ő8��u�4�R|�	�j�D��8�:"�~GS�3��� 	�#��/������c�a8�(��u�0����3n��8un�s�U\6�i4�n�o�e����C1q�'�R�q���p�0��Vbg�J���f�� �c�;         ?	  x���[�7��gV�����,"�C_
����D57�>���T��AC�|օ)��n!Gᇋ?�[���x�KX�sn�ǿ_����Fe�\��Y����������������-�~�ס>�~X��p�b�2��B���������K���E�����~���}������^�xx������y�(G�w�v�Gi�P�A���7"B�#� ����s�׼I� ���{�A��{@@-�rn�2o��y!��$+n�t�a�X=�ׇ�ǭP�l�o�W�f� q� �&��!�@ᘹWd�e��RR�E���6[�5]&1y�y�����k�0���>o�+6 q��+�Nb�ǫ�[D[��}4�RV� �D�h��yʎα�v���].�-��EՕ� u'��<7�R��a�L�a��񿷾����ٹO׺��D��,ZF�;%!%.�^�"�fQ2R����h��66P��.���C���[f�	L��2�X ������{�:C��̢�嶆�����D�H腅�	( �3?u��	j�|�����G'���o��~7S�@��OZ�������Ex�Ơ|�K�Q(���c��5��я@*��w�C��+U�I?����L}��ÛR��#o?��#�+��T�Q�ϛ/<��^0RG��q�H��.� �BG�����^�V��RO��Ӣz�^���Hh�?�}���e�oE0��kb�uzn^�ܼ���KǤ��$nѢ�)#�9Wo�т(�VRi���&�/�h������&��c���9�ى�V4��$R�<�����GN�2����)���D��, v�f��bR���K�!�_3�Bne)�����>��_�$�%1C̢��,;�䇗#F	�"���+��E>��xC��7&SN����3�e���:l|B�h��6/@�3{XJWD
P�@�뼮'[~J=<�ʴ�[4B[=�5x��WS�����!�[��;vL�� 	��E��v�4Q��4��A�>���צ�� 	,a�����i��S��[!�آ_���p!���,#��$�B����TjM���G�M��\����
;�N�[4@适 �RZ��g����K�OcM�u���=��EIYMr��C��#� ���OI����#ʊ���yD�M6}�9����;��n���Ie����S�ѣ��K%�շ��O��ۣ��g�^�2
|0J�d�o��6M��}�57����-Z�������;���8��mt[F������DU?��*n��w� B7>�
'�7�g'���������8��Ģ�-	^ӿ-���/d?j����'�x�a}�-#����5�ן�0��3��\�{�pr%=6�������׉#�����'�9S�[L����}������M_�n��ҩ"�!f���~�|�2��?��\��`����n��������%F�zwA�U�氌�Eb�fT���[�L��}%�����@�*�ʙ嵢)'g������8�V�,�~���o�6J�R���3��~���}f�}:x���+YH�2�n�^�|�o��\�_�����1�<�$c��M�p$2�6���{-wAԧ*	�fEŢ+�O���,#s�|��CQ��Aib̢Bd��'�З�6���}�����G�V��w���|�L!;p�S2+��̢�b�1�.���x��'fەY4@� B���&� ��n2�Gԗ?�g�O����jүB_	H�N�#�i���?ԁ?�Ǳ�|�Y4����Qy�I��"{�MRFp��ߜ�d�Eӯk�O��1������� /'����Ӥ���h���g�W�L� @��M���� �~���K7n��É��6}��"��	��֜K�m~@8,
!�Nb�e��^�LaH8��X7�-�'��уF��L�-�ܢz�^=h��R�W!n��x|��W���L��7���,�ѡ���l�̍�h%�'�7p��I6{��M��/;��*OLn�G��x6}���*��ù�IY�6q��{ѠA�i�/�ܾ�D@E�(3m��?�Pr�2V��=�G�`/�>rn���a��Z+��w�xtT۽T���,����=�6}��#��	����FB���Nm#i.�k ��w�9I?��k�ѵ�w�h���h��	̵���%7�COi���kP�5I�|&��ʉm�O���ed |:��r�z`���5��I���(S���6��$�ڤ�� ��gv.�(ﺹE#����ZN���j�z���'��±�ץ�Y�4������u]�k|      �   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      �   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      �      x������ � �      �   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      �   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      �      x��\k�,���]g��;���Qk���c�$(K��t���P�	��T<�Oȟ�	�����������k��1�ɰqP�'eJݿ�*5j�(����a��T(���a�^�5m�D�J�;��{Pj���0P�'%J�ߴ3���4�T[2�Rϱ��NS�kH1P�'�i*�$��$>M�w+{x�d>O�7$���W�mN��`��'S���7�Sl��'S�ϡ��a�ʈs���a���{��L����\؝R�7�kX�^��)�~��^�O��Zܷ6�_��1M��k���ba��o�|1ߪ�?�H���T#>)��n�cVm"�)t��ۿa��4�S�S\�e��������u>�6s.�0P�aK�n�%�)V�6s�h���ĵ�sl�a��^/i1���*m��z@1��8��:�z^��n˰	aN;��ݦxP�v��sl�a�ru���6��:u��)n�u��?����}y��0�z�P�v[�رg]���_�׆Uφ���b�b{udC�t��f[�XV�hX��c��pk�11�R�h��bMC�����-/100�)@��V7���:�8��l��l0ja;�5��zQ�O����܀���7����_U����)>"h=�%6X��3���Kj�R:M!��0Pw�[{3g��U�?��֬|�p�@�Ŗ�Mg`��3�f�}k��nc�|������baxo]���8��\�궬��0�>��v`�9�K���f�."\�ϫ�9�K��z�wuq�t���j6���̹��էQ�a9nV��<n�;���{��|lٛ�^��"f8�%,���<˕n`����A���=�a��O��6���ylp��|`��{YkV���p5�"vkZ�ugɅ��mt�0Muuv>Oq�K�nO����ʺ:�U�p�|��B���OT&s���X��t�Yr#n�Y�t��3#��ȩ���7�RG8�.�Yu�nu*ͤ�fe�%U��y�c��|�͜)�:_sX遁�N������cF0��Қ�%�50Pw�8���R3�^B�KC��n�\��-N�jx��[Ϥ�x�0P��C����9<�syoj:-��גo:���<6���)N�R}��6�1��E��%>֣ΰG�}�u��a�{�_�:-�Ɯ��NK���~5�S0��8��yHfp_ڰj�״�8Ňk��z���޽V�;c.�k+w�V�S���cISL��jȰ���@�d͖�����d����c�ϯ5+C�]%=c��a����U�*9\cм�|U�#-u����Hp	qd�{� "Iqd����)Z\�jm��*��DD�����V/�׆�*���늆�*��c�5j�GjX沴��*�����e�z�����U�2Te�-�YM�0�:�p����^b�k��8Ұ���$�U1��ҩ�b侶�t:e���Nlkz����5� @������@�Fq�i:�4]h����!qM��T�)M��-W�0P��v-�r����N*�6�2պ��a��c�ѕS{��ʈk;���nS1�*j��S4�:b*���k`V�L��ؖ�ؖ�Xr���iR���%h)ARXܗL�� �׃���m�̅�չ\�y$+���ǳaиO�w��>�]��w�����w��a����r�E~�G��}E(P��j�IjW��m�j��t*��6�!RM2�R����$1W��00(:�;��*���$|����`J�K���)�W[��
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
N��[���ģa�T��v�*�ĨXP0$�ֶ��˔ηm�$8L*5���WgA�].�~�Ƹ�ՠp�!ka�&r ��~�'�7X��\:󈩃�b���Z�/�O[�0�Z����� �]پ�C�B�g3L��5-=ۼ���X{Y��̭�4!/k��u4`��B��ڱ��m^����v�o�	��Kq��^��|�tt<�`�W����ӆ���dM9��������\V�=� ����c�C��~�RI���TV��a�֡m�+�	�&��@F�c���ٍ�)K�=wV�)�B�x�w����+�p�p�1մ�⚭R��:���&��]��b�tF��m}�Q��^�t5����U��P+�ʸ��j������cX��      �   �  x��Z�u�:���H�!n*�U0���@B�H���s�E���>�?J����%܀?��{w�<i�ϼ'�� ���cuׄ�L.��{6��kr2̃�|.;twm��oH�!!%�oH���\$�%�;��&$4��w6r�k�\6mM�\'���H�R.��ӎ�6�6H�7$�JY��`�sU7wM��1o��O��ڞ���0��>iܘ��x����3%�)z.O{���'�ˈ=I��y��j��8�J;�L����K��qp�1�ʏ�5!髗�ȓҪ�W7�մ_U-�^��kpyy��	^� �0���L{�QPT)|�=A� �W��ag�
��20���+D�Q;0��������y8j�!��5��A���4�Q-�3�hv�Q_��Ԙ��T��T�Z(Q!��7�N���Z�a-DݹFݹFݹF��F��F��EOТjlQo�)�ζ=5�>�ѲJBW���Y�`ٙv\;}��}4�}Z���3��G�Q<%M� �&�u��҃��L>�^�!���$IpE�Ζ�,l!\F{'$|;ٓ
���綏�CZ��-�v�S� _���ZV��ϕ-��J(�d V��T����^��"��,W���+���39�GE� ��<oǮ��1��v��L����a�0}f����l�>�G)� 
���b���<A<-�N�����䨪�BBEq{>���e��/��<c��GF�uW�?�Z�@c| �m��W>��&������Vrp㼧�kӼZ�+ɡg���M8IV�N�p����70�N
i�����Q��^�<%$��,B��4{X=��;�v�yqc
HH��U�;�}��Nk]gH�� :6�\=y��M��3z�0�g35Hϩ�Z'����F��>��=��!;i1��kÛ�=�c�3�F)�r�b��v��x��"��t=���kԾx.��6, �Y��Θ�uֲ�O�JF��:�E;��`z����+�`��Q�S�z���1��)��`
k!h�� D�����8F_�1:9�� ��C�N&.���h�g	=jt��*��ʷ�|'ǀ��s�o�{�۰�N����*T��_�v�`J�f[i�tZ>�z�v���e\�7H����lt��љ*R4�r�
ڂEZ��9c�� B�KL骍�߼"G�?at��-*y?=E�y$��)���2z�=J8������������v��<�Tt��N�Gq%�������P���x��P�9����ҏ�,;X�<�i��g�������y���Hm��Wb�?�B�&<8� ̫ Ѕ�Tf|o�OL��&X���TRYSL1�LG�_����V����Ә��������UKr�![�G�f�"&i��6Wa��C�Pg��k�	����$ه���4a&���~Hޕf�;$���D���GB���_�("�"���dBXVH������6���G��wɰ� "Uz$�
L�Q5����[��4��g�EY�&MH0�|A;4^oG��4���j�����d��g��_�O1����T�����TCK'xdA'HO6���NZ�t�}�M�.�;�0իN����� �Q��?#�"ʚ�)q��%-["��E�e�c�!b�:;Өq��e�Ԧ�������,��*��c)�W�[�;c:���9��bAǇ�h����|�	EP�j�R���������l���?_������      �   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
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
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po            x������ � �            x������ � �            x������ � �            x������ � �      �   �  x����j�@��w�B/�0��ao�^�B⸥�.�\P�@�>cW6�(DQG����h���*o��1�է�.���������K��c��T��U5�10����^��ay�au=]-��b�H�T"�I���4��b��g��aq}�UX�D-�)�M�&�D�C�b�X���<�F8��3�X���ۭ���������y0�,`�Y�܆��W�·��7[�`2�`�J/X�����|�'����"�
�}��8Z���D�\1��Oa���c�h.�L�2h;U+q�V!�T��
�R/}�亠&a4�(˦8�ϥd<�4��  �8k���38j�?t�⼥V_���ZEF���S��ɟ� �?��j��Z�{D�8�"jM�qR/1{F�u�A�rU_�5�/��Qܶ�}o��fqc����\pr���F%Mi�SAe#3�s#�ѯ>����v�K��OU�C�d�9w �}R.      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      "      x���ˮ-�������j@�Z]�ðQ��7��0l�@]�ߤb���Ę�6re~#B�(^~���o�������߿Z���O�O�����o����?M��}��_����?�����G�? }�?���.�?��������������1�cI��e�=ZF�@?���_�S��?���sA�ZПZ?P��������_�������������뿾��O���#b���b�h���*T�Q�i���h��>����h)�b��G�{�f[������]r����?�7�������U�ı��?��������G�7{��~����՞bǃ_����Tmc�x��xX�t����_9�A-{��_@�SЖ�����;��Y�&�O-o��=@w@�(����+�!�U�QB跑�}��W�TnE�/�������*�)����FR���?�ގT��/��FW��  ���7���­�_l{0��B���?�)<	�O��`W(�p�by���g՞����ɟdi*a�5�׉��#��mƿ[��<����v�;��%�:}���Oo��_HM!������J��	��J�7 �!������$�C�(�V͸��P:�/0��As��Ä���yN����/W_'����b�I�-��jv�H��;-�
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
A�T��V�n�8w�̆`�8����4v�&�^�����uV��reJ8��� J�|���{�]�Gh<���~KA���F�僊��Δ��,}9������poR�%�N���4;v��4{q!����\:�N�x��o�-���9����f!q{��w.2���Z%{�`��?5G���vJ���C騇4�;b�Nv�����7C�Q�� ����t�&K��!�kϵ)�?j]~�%$q���1�l�R���1T�>ˣ�Z�9\}���'�/Y�#e |o6]��T�~'�C�t�U6�|ѩt(�w�$+�G�����fs{�P.�b�m|JV	3���e�rE��?�)_��)���l:-_�rc_]�ʦ��r��%;�Bb����L���k����X��L�db^t�_�vg��@E_rMHg5�΃TqLL�qgӜ�����ͦQ��_ٙ$9��Pt]u��C����(E``�6��ܝ�\o�C*�-��p��]?���: ���4��$?3�Ns��]���!���<�!U��
��d�3�g�6AV{�t�3�Om���6G���e�SG5��P͵2��+�:7��JIkM���j��0��i�
��`d���ͳ�l��1MM�KF�kr�1�4��3����Fc2��wL�����hHF.�o��Ђ��)�]R͡	�B[���34i����n���c��K�X��e	ӎiZX׀�:l5�ɋ0r)��\(��b|��)bհ�b�5�a����=�Ƶg����=SZ��V��MY5��
q�b��3����p��?��	�C��#�Y:o�|k�LML�e�1}b�~~��l�-֕�c��/�yb0�;��Gik[��7f����K��T"L�P�{7�7Vt��y7�[�n�<1a46Z&�n3�w�5��N;\�j��0X���F��x3�~��;�D�6x��(��S����8�{A!��a47]�<S�
f��Œ ���%��?w���BX̕���E�Q������i�*_���pu�QQ�Y5{ ���3�_ڗfW.��/�F�K~�t٨v�y���Ֆ����p���mp��yg��lB����w�0sM�@;V(��Pf'�d�<wپ���� ��@׼-/°�XS:o��l4��꟔��M�)o�;S�N�nl���~�FQ��)o����|p]��M`K2j>��a�5]Eާ��y� �`�0�:�#L���l�\'�anX�1Zgb���2mF��#�=Uy�0�"��U�,����[����w��MyG��Z�f��ơ#J�vs]���NY����e��ȃy�@E�-&M�0���o�����u�5�����6
��W#�+��yW^�auw��<�X4#1׶�YL�8bګh��=T^���LK4�0#��f�2�{��Q��'9b�g0�a��3��bO�\)3�4���q5Ӳ8F�^�����p6�̭� ���E�fnG`�1��M��������{L̴,�ql�(ZFc��&?�� �Σ�#�>cdO�:\$"�]�8wL���ARW��/�`��9�r�`R���� m���*���T�<'QX����/���� �f(���Q>��Fl8>��љ`,�IEV"̬�vr���G���W���8.��$.�L�Q��Ku����g)�0�KZ���W�gB���:	v��XFABk�A>�.8r�<��Yo7�@�gH�F��=���Zq�t��I�Cީ�G���0~6�^�3�G���Bɗ/�F�KT�'�;�j�~���&�O����&���ٹR��]�:�b.�7/�}mD��,�3�Q�2�ڈ��6�V^��2�;\2rE�{[Qp1��F!��^�i��rY�g�N�qO����q4L��.��~��b�A�����+�>P��������k�ɶ�.ٸf���.<�v81�ϤMbv�o[gs#��aM�Qq��7�i����u�<A>�.��a�w![�4w̻l{�n.�mz����C�Fp��*X�^q~���֠d.gp����a�9%�Ծ���0�Kq�%�u��U�,��V6�%`���B��`���ފ�L��v�$�
�X�ȑ[j��_�g�%PFd:���q?���T��D�N���;_�he�r~�ý)�e�fL1A>�n�h�֊�����G
k���D��ş)M��'��]�(X�<j`�!9ț�"t�m��͛��gBz��rQ'�d�-��/ٸ5�cɿ�7� �0�s���"�̼SV��N�r7�%`H�����cn;fj"YL"���\��f����7����"����=�n�\�qfL�n�K:�ǎ�kx8��沂��%��r+x��4J�z�yT��㎔&G��C})�t����jQ)��@��g
q+�Q@�m8ɋ�[[�6̕�kdF�%ڤ��\���(ui[֊��m�KdF��m�_��K.�"�/:J�he���M�h��zzve�`d#��t��Ѿ���D!���/ٸ#E0�Y7w��C����Te|��r�?�!Zj��䩸͛d'�W.}k]qd��9F^�QzW��/���YK���-���C���>�#�퇢���P[D���/%U�m?�i�Ht#���pI��0�)��͹�̋���@�b�y����U��j6u3_���ޝ��O�1��J����~��j������%P4    �k����m�gy��q������˻��3,�5�;F�C�B�%�0�Xw��W��ݯy{XS-@��i�0�ʌ(�V��Kɭ��6�f'�Ց#ؚ�����04Jq�7�
�N7ZLO52Z�0��TU�@U��b>�1�[�Kn>��cƒr*D���K.�PGy9�W�a�y�1l�	^rpG���Uc�M�S�[h}���Wk�U�k�c8�h�Uq�������a\�zxI��5����&�fH/
��q1�G	/Y���}BW��_�?��d	��ri��u���ֺ$b�K[\��c�M�JeFM�[1R�\�ÎAu0��:�,������Zz�˗c�R�XY2Æ��0M>�Ma.�ɝ6�`z�Nms��CrW�1<���ٯ���14.�J0�ˌ0Z�fs��!�ێ�wD*xoq��aF%�c�|Xݟ�XC�b���MA�r��WT��/%��#��4�����}�Ч�]R/i� #^����Y��;־�@�}��0]گM�)��a����t��1������#�S����ɑuƈcY�{�ܛe�,1\q��S��K8�t�Ŋ[iF8$��a`T�F}w�Q~�0UUF���=9�h���Z&�04V�I%�0���� 3zw�/��e��3��D�E6􏗶� Ã�Wb����Z�#�v�jI6A��Zf��yZE)���~ƴ���W|Yżc��H4;�/uY�gL�uT��{��ێY)��Y�6�ܚ0�~�s8�1]+������d��o�9���Z5�B�����l�H,�G'��kӲ�/�
ڀ"3�60l�@��EG��u�;��;R@����Gj��0}v[I����ˆ�������sY�|f�����16��i�����|l]��bS��~��ݒQ=����:Ĳ�>S�+"���s�����=������B��/E�Y1�P؟o�J�B5�Px�� ��~�q�O,�_J��m("�V�]K*�?�;70��hc��G1+���/�_��i���-��o]m���h��xI��5	=�cF1@�����e�@cn�Oc�Z"8�f� #7<�x�%`�m�+^�1L�O��ʅ1y�ӗ��`p�ʥ+.��^��!>�W|Đ���ŝ�u!f�w�/]q�n�0�`�����+���L^<aǌ5�U6��R���#�d��2K#3Y7�c���"�.�w����<���&�6����pI�1��,��J~,�$�I�r�C�Y��Zj
����6�uK�f�_��rYE�j�+��eFy�枉��7
-q�ˆ�)Wˌ0�/�`rx�S�����kr#8����t�&�O1���M�-6AM������D��5���cV��'hW_���0����r���.�U�ݻIq�!^Ŕ��­���K�u� �w�����m��jjPD.���jOC�P�c�F�ձ�U��D�A��I��g�� �%H-�Vh�t-++�F�dj�F��l��o�9cXg����hZ�����=A���eŬ�)*~���掔���7C����!�R'����J�<0e(��-.�O��_Z�?���k���Œ(�ݩP��G(���6�[�HD@�6۴���2�4k)�P�ɴi�4案��x@�*��)Ä#�L��(����$,�:Pbܻ'��'��]B5���	����a��t��U��ri�(s"�/}�;R���m)�l�'�4�̕ʤL39���P�@}�/��ҋ����d�ѥ'.�`�`JWh�����($�e�nti�(�^�>�q���K�E�t�A�_��p8C����a��ܞ���F!\���	u�IW1�Sh�5n+���9e��Py�*"B�\��L�8eυP���+�x�B�{�hK:��A�l�ch["����5J!����C��3A�b�E:������� 5Y ��;��X���*g�xZ���g{��a�Zo"�'���{���B��藎W�E��#���4W���P���-����g�Eկ�E���z�f������`���F�(��a���D�������ߑ6      �   @   x�3�v�twt��sWv
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
νg[��;���ދ=n�;�5��ˑŨj��y��]���.�>/������x���=O�YZ���fi�ϋ�7���d���>/�>�����Eמ������՞�g(���'>��Q��3r��?�,mH�yƱb��-<��f�C+�Yڰ�7�4<�B{��a�6�y���k����,m��"�ǎ͝G^1|� �GR            x������ � �            x������ � �            x�ŝ˒�6���UOQ/P'��L\��鉞����7�Y�L�)�A]�D���������!���7yӠ�3���t)������g�OI*C���1�<�yx����߿���~����s�N���~����;N���>$M_j�i?�bo2��~�ǟ���9s8�/'���r
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
d6��G��q ((e�@|X?��$���I]�'+C3�4�X4�m���@��IԐ�����5���`�h���B܆���f�l�$껁�2�=2=,`Kہ�d@�m䙘���v �����X\�l�޻���⾤�׷J�:�4L*^0&�+����#��%͝IŒ�I������^J|0�J|K����I7r�>��g6_^߾�鄀���?~��!W^�TȕW"5A�R`R!WI�T�UR&r�"��)��I�H&gR!�)Ѩh�ږ�q���|	�t>�txD�aZ=�~z���'�\Lm�xg�\LmTxg���K������#�����$��H����V/�<2�*�	�Ҏ����g�11�s�Ƽ��?�3]�;4�V>��esH��6�>��6Wn-!�e伭2�v�����Q�_ ����hƑ���8/���0=�L��ȃ?x��#��GA�i}~գE��Sa�^?J�Ӧ>î�����<������T��O�y�J�����`[�q�L��;�Un����!�l�R�!��Qj7"�5tC �T�q����+����R�n��ջ!`F����cX�ү%��L�Z�!�|�ջ;#`*���;#`ѷu�;#`��E�;#`����".�yX;�Ì�a^��4غE��G�\�P:݅�� [�|�r���]�&�;TtA���j���b�I膀��vC@�$vB�P�#��)�|y��	C��N�ӧ��:8��M��A�6����g$\�a��+�DG����T��R�2�t�-��qH�)���9}���`^����.�cb��Dcf�49?f6~��
����$OL��WP����0{ry~S����c��e�F�>5?5`y�6�����W@��R���0�9��0�4�?E��T9<�>�=��Ø�e�0`-�0�<��W�a��_�������qa     