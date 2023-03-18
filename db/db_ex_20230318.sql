PGDMP     ,                    {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �              0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    17913    ex_template    DATABASE     s   CREATE DATABASE ex_template WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE ex_template;
                postgres    false                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false                       0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
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
       public          postgres    false    6    202                       0    0    branch_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.branch_id_seq OWNED BY public.branch.id;
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
       public          postgres    false    204    6                       0    0    branch_room_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.branch_room_id_seq OWNED BY public.branch_room.id;
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
       public          postgres    false    6    293                       0    0    branch_shift_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.branch_shift_id_seq OWNED BY public.branch_shift.id;
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
       public          postgres    false    6    305                       0    0    calendar_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.calendar_id_seq OWNED BY public.calendar.id;
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
       public          postgres    false    206    6                       0    0    company_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.company_id_seq OWNED BY public.company.id;
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
       public          postgres    false    208    6                       0    0    customers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;
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
       public          postgres    false    6    303                       0    0    customers_registration_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.customers_registration_id_seq OWNED BY public.customers_registration.id;
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
       public          postgres    false    309    6                       0    0    customers_segment_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.customers_segment_id_seq OWNED BY public.customers_segment.id;
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
       public          postgres    false    210    6                       0    0    department_id_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.department_id_seq OWNED BY public.departments.id;
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
       public          postgres    false    6    212                       0    0    failed_jobs_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;
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
       public         heap    postgres    false    6            �            1259    17984    invoice_master    TABLE     =  CREATE TABLE public.invoice_master (
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
 "   DROP TABLE public.invoice_master;
       public         heap    postgres    false    6            �            1259    18001    invoice_master_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.invoice_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.invoice_master_id_seq;
       public          postgres    false    215    6                       0    0    invoice_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.invoice_master_id_seq OWNED BY public.invoice_master.id;
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
       public          postgres    false    217    6                       0    0    job_title_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.job_title_id_seq OWNED BY public.job_title.id;
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
       public          postgres    false    219    6                       0    0    migrations_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;
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
       public          postgres    false    224    6                       0    0    order_master_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.order_master_id_seq OWNED BY public.order_master.id;
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
       public          postgres    false    228    6                       0    0    period_price_sell_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.period_price_sell_id_seq OWNED BY public.period_price_sell.id;
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
       public          postgres    false    231    6                       0    0    permissions_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;
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
       public          postgres    false    233    6                        0    0    personal_access_tokens_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;
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
       public          postgres    false    6    314            !           0    0    petty_cash_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.petty_cash_detail_id_seq OWNED BY public.petty_cash_detail.id;
          public          postgres    false    313            7           1259    30742    petty_cash_id_seq    SEQUENCE     z   CREATE SEQUENCE public.petty_cash_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.petty_cash_id_seq;
       public          postgres    false    312    6            "           0    0    petty_cash_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.petty_cash_id_seq OWNED BY public.petty_cash.id;
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
       public          postgres    false    236    6            #           0    0    posts_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;
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
       public          postgres    false    238    6            $           0    0    price_adjustment_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.price_adjustment_id_seq OWNED BY public.price_adjustment.id;
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
       public          postgres    false    240    6            %           0    0    product_brand_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.product_brand_id_seq OWNED BY public.product_brand.id;
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
       public          postgres    false    6    242            &           0    0    product_category_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;
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
       public         heap    postgres    false    6            '           0    0    COLUMN product_sku.type_id    COMMENT     G   COMMENT ON COLUMN public.product_sku.type_id IS '''Product/Service''';
          public          postgres    false    250            �            1259    18176    product_sku_id_seq    SEQUENCE     {   CREATE SEQUENCE public.product_sku_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.product_sku_id_seq;
       public          postgres    false    6    250            (           0    0    product_sku_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.product_sku_id_seq OWNED BY public.product_sku.id;
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
       public          postgres    false    253    6            )           0    0    product_stock_detail_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.product_stock_detail_id_seq OWNED BY public.product_stock_detail.id;
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
       public          postgres    false    255    6            *           0    0    product_type_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.product_type_id_seq OWNED BY public.product_type.id;
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
       public          postgres    false    6    258            +           0    0    product_uom_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.product_uom_id_seq OWNED BY public.uom.id;
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
       public          postgres    false    6    261            ,           0    0    purchase_master_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.purchase_master_id_seq OWNED BY public.purchase_master.id;
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
       public          postgres    false    264    6            -           0    0    receive_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;
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
       public          postgres    false    6    267            .           0    0    return_sell_master_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;
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
       public          postgres    false    6    270            /           0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
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
       public          postgres    false    297    6            0           0    0    sales_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;
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
       public          postgres    false    6    301            1           0    0    sales_trip_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;
          public          postgres    false    300            *           1259    18748    sales_trip_id_seq    SEQUENCE     z   CREATE SEQUENCE public.sales_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.sales_trip_id_seq;
       public          postgres    false    6    299            2           0    0    sales_trip_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;
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
       public          postgres    false    307    6            3           0    0    sales_visit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;
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
       public         heap    postgres    false    6            4           0    0 &   COLUMN setting_document_counter.period    COMMENT     U   COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';
          public          postgres    false    272                       1259    18330    setting_document_counter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.setting_document_counter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.setting_document_counter_id_seq;
       public          postgres    false    272    6            5           0    0    setting_document_counter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;
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
       public          postgres    false    6    275            6           0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
          public          postgres    false    277                       1259    18354 	   suppliers    TABLE     Z  CREATE TABLE public.suppliers (
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
       public          postgres    false    278    6            7           0    0    suppliers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;
          public          postgres    false    279            &           1259    18725    sv_login_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sv_login_session_id_seq;
       public          postgres    false    6    295            8           0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
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
       public          postgres    false    6    282            9           0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
          public          postgres    false    283                       1259    18384    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    280    6            :           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
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
       public          postgres    false    285    6            ;           0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
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
       public          postgres    false    6    287            <           0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
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
       public         heap    postgres    false    6            "           1259    18412    voucher    TABLE     �  CREATE TABLE public.voucher (
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
    price real
);
    DROP TABLE public.voucher;
       public         heap    postgres    false    6            #           1259    18421    voucher_id_seq    SEQUENCE     w   CREATE SEQUENCE public.voucher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.voucher_id_seq;
       public          postgres    false    6    290            =           0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
          public          postgres    false    291            �           2604    18423 	   branch id    DEFAULT     f   ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);
 8   ALTER TABLE public.branch ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    202            �           2604    18424    branch_room id    DEFAULT     p   ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);
 =   ALTER TABLE public.branch_room ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    205    204            ?           2604    18723    branch_shift id    DEFAULT     r   ALTER TABLE ONLY public.branch_shift ALTER COLUMN id SET DEFAULT nextval('public.branch_shift_id_seq'::regclass);
 >   ALTER TABLE public.branch_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    293    292    293            Q           2604    26922    calendar id    DEFAULT     j   ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);
 :   ALTER TABLE public.calendar ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    305    304    305            �           2604    18425 
   company id    DEFAULT     h   ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);
 9   ALTER TABLE public.company ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    207    206            �           2604    18426    customers id    DEFAULT     l   ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);
 ;   ALTER TABLE public.customers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    208            M           2604    18777    customers_registration id    DEFAULT     �   ALTER TABLE ONLY public.customers_registration ALTER COLUMN id SET DEFAULT nextval('public.customers_registration_id_seq'::regclass);
 H   ALTER TABLE public.customers_registration ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    302    303    303            T           2604    28176    customers_segment id    DEFAULT     |   ALTER TABLE ONLY public.customers_segment ALTER COLUMN id SET DEFAULT nextval('public.customers_segment_id_seq'::regclass);
 C   ALTER TABLE public.customers_segment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    308    309    309            �           2604    18427    departments id    DEFAULT     o   ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);
 =   ALTER TABLE public.departments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    210            �           2604    18428    failed_jobs id    DEFAULT     p   ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);
 =   ALTER TABLE public.failed_jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    212            �           2604    18429    invoice_master id    DEFAULT     v   ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);
 @   ALTER TABLE public.invoice_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215            �           2604    18430    job_title id    DEFAULT     l   ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);
 ;   ALTER TABLE public.job_title ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217            A           2604    18730    login_session id    DEFAULT     w   ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);
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
       public          postgres    false    234    233            Z           2604    30747    petty_cash id    DEFAULT     n   ALTER TABLE ONLY public.petty_cash ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_id_seq'::regclass);
 <   ALTER TABLE public.petty_cash ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    312    311    312            ]           2604    30762    petty_cash_detail id    DEFAULT     |   ALTER TABLE ONLY public.petty_cash_detail ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_detail_id_seq'::regclass);
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
       public          postgres    false    262    261                       2604    18444    receive_master id    DEFAULT     v   ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);
 @   ALTER TABLE public.receive_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    265    264                       2604    18445    return_sell_master id    DEFAULT     ~   ALTER TABLE ONLY public.return_sell_master ALTER COLUMN id SET DEFAULT nextval('public.return_sell_master_id_seq'::regclass);
 D   ALTER TABLE public.return_sell_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    268    267            #           2604    18446    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    271    270            C           2604    18739    sales id    DEFAULT     d   ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);
 7   ALTER TABLE public.sales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    297    296    297            E           2604    18753    sales_trip id    DEFAULT     n   ALTER TABLE ONLY public.sales_trip ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_id_seq'::regclass);
 <   ALTER TABLE public.sales_trip ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    299    298    299            K           2604    18765    sales_trip_detail id    DEFAULT     |   ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);
 C   ALTER TABLE public.sales_trip_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    300    301    301            R           2604    27183    sales_visit id    DEFAULT     p   ALTER TABLE ONLY public.sales_visit ALTER COLUMN id SET DEFAULT nextval('public.sales_visit_id_seq'::regclass);
 =   ALTER TABLE public.sales_visit ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    306    307    307            $           2604    18447    setting_document_counter id    DEFAULT     �   ALTER TABLE ONLY public.setting_document_counter ALTER COLUMN id SET DEFAULT nextval('public.setting_document_counter_id_seq'::regclass);
 J   ALTER TABLE public.setting_document_counter ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    273    272            (           2604    18448    shift id    DEFAULT     d   ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);
 7   ALTER TABLE public.shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    277    275            -           2604    18449    suppliers id    DEFAULT     l   ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);
 ;   ALTER TABLE public.suppliers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    279    278            �           2604    18450    uom id    DEFAULT     h   ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);
 5   ALTER TABLE public.uom ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    259    258            /           2604    18451    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    284    280            3           2604    18452    users_experience id    DEFAULT     z   ALTER TABLE ONLY public.users_experience ALTER COLUMN id SET DEFAULT nextval('public.users_experience_id_seq'::regclass);
 B   ALTER TABLE public.users_experience ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    283    282            5           2604    18453    users_mutation id    DEFAULT     v   ALTER TABLE ONLY public.users_mutation ALTER COLUMN id SET DEFAULT nextval('public.users_mutation_id_seq'::regclass);
 @   ALTER TABLE public.users_mutation ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    286    285            8           2604    18454    users_shift id    DEFAULT     p   ALTER TABLE ONLY public.users_shift ALTER COLUMN id SET DEFAULT nextval('public.users_shift_id_seq'::regclass);
 =   ALTER TABLE public.users_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    288    287            ;           2604    18455 
   voucher id    DEFAULT     h   ALTER TABLE ONLY public.voucher ALTER COLUMN id SET DEFAULT nextval('public.voucher_id_seq'::regclass);
 9   ALTER TABLE public.voucher ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    291    290            �          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    202   �L      �          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    204   uM      �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   �N      �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   -O      �          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    206   e      �          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    208   �e      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    303   �k                0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    309   �k      �          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    210   �k      �          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    212   nl      �          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase) FROM stdin;
    public          postgres    false    214   �l      �          0    17984    invoice_master 
   TABLE DATA           W  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type) FROM stdin;
    public          postgres    false    215   �v      �          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    217   ��      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    295   ��      �          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    219   ��      �          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    221   ��      �          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    222   ��      �          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    223   ]�      �          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    224   z�      �          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    226   ��      �          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    227   ��      �          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    228   �      �          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    230   ��      �          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    231   �      �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    233   ��                0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    312   �                0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    314   ��      �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    235   :�      �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    236   ��      �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    238   ��      �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    240   ��      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    242   ��      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    244   1�      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    245   ��      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    246   L�      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    247   ��      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   ��      �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    249   0�                0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    310   �      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    250   ��      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    252   �      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    253   �      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    255   �      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    257   y      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    260   �      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    261   n      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    263   :       �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    264   �       �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    266   @!      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    267   ]!      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    269   z!      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    270   "*      �          0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    297   �*      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    299   �*      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    301   +                0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    307   %+      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    272   B+      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    274   --      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    275   -      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   �-      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    278   .      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    258   �.      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    280   ]0      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    281   J8      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   }9      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    285   �9      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    287   �:      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    289   ;      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price) FROM stdin;
    public          postgres    false    290   6;      >           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    203            ?           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    205            @           0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    292            A           0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    304            B           0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    207            C           0    0    customers_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.customers_id_seq', 124, true);
          public          postgres    false    209            D           0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    302            E           0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    308            F           0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    211            G           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    213            H           0    0    invoice_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.invoice_master_id_seq', 265, true);
          public          postgres    false    216            I           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    218            J           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    220            K           0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    225            L           0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 1762, true);
          public          postgres    false    229            M           0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 514, true);
          public          postgres    false    232            N           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    234            O           0    0    petty_cash_detail_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 17, true);
          public          postgres    false    313            P           0    0    petty_cash_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.petty_cash_id_seq', 3, true);
          public          postgres    false    311            Q           0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    237            R           0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    239            S           0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 22, true);
          public          postgres    false    241            T           0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 52, true);
          public          postgres    false    243            U           0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 328, true);
          public          postgres    false    251            V           0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 25, true);
          public          postgres    false    254            W           0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    256            X           0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 54, true);
          public          postgres    false    259            Y           0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 21, true);
          public          postgres    false    262            Z           0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 32, true);
          public          postgres    false    265            [           0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    268            \           0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 13, true);
          public          postgres    false    271            ]           0    0    sales_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sales_id_seq', 1, true);
          public          postgres    false    296            ^           0    0    sales_trip_detail_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 21, true);
          public          postgres    false    300            _           0    0    sales_trip_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sales_trip_id_seq', 4, true);
          public          postgres    false    298            `           0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 1, false);
          public          postgres    false    306            a           0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 52, true);
          public          postgres    false    273            b           0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 12, true);
          public          postgres    false    277            c           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 5, true);
          public          postgres    false    279            d           0    0    sv_login_session_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 71, true);
          public          postgres    false    294            e           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    283            f           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 87, true);
          public          postgres    false    284            g           0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 70, true);
          public          postgres    false    286            h           0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    288            i           0    0    voucher_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.voucher_id_seq', 60, true);
          public          postgres    false    291            c           2606    18459    branch branch_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_pk;
       public            postgres    false    202            g           2606    18461    branch_room branch_room_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_pk;
       public            postgres    false    204            e           2606    18463    branch branch_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_un;
       public            postgres    false    202            �           2606    26927    calendar calendar_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.calendar DROP CONSTRAINT calendar_pk;
       public            postgres    false    305            i           2606    18465    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    206            k           2606    18467    customers customers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pk;
       public            postgres    false    208            �           2606    18784 0   customers_registration customers_registration_pk 
   CONSTRAINT     n   ALTER TABLE ONLY public.customers_registration
    ADD CONSTRAINT customers_registration_pk PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.customers_registration DROP CONSTRAINT customers_registration_pk;
       public            postgres    false    303            �           2606    28182 &   customers_segment customers_segment_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.customers_segment
    ADD CONSTRAINT customers_segment_pk PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.customers_segment DROP CONSTRAINT customers_segment_pk;
       public            postgres    false    309            m           2606    18469    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    212            o           2606    18471 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    212            q           2606    18473     invoice_detail invoice_detail_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_pk;
       public            postgres    false    214    214            s           2606    18475     invoice_master invoice_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_pk;
       public            postgres    false    215            u           2606    18477     invoice_master invoice_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_un;
       public            postgres    false    215            w           2606    18479    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    219            z           2606    18481 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public            postgres    false    221    221    221            }           2606    18483 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public            postgres    false    222    222    222                       2606    18485    order_detail order_detail_pk 
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
       public            postgres    false    233            �           2606    30771 &   petty_cash_detail petty_cash_detail_pk 
   CONSTRAINT     t   ALTER TABLE ONLY public.petty_cash_detail
    ADD CONSTRAINT petty_cash_detail_pk PRIMARY KEY (doc_no, product_id);
 P   ALTER TABLE ONLY public.petty_cash_detail DROP CONSTRAINT petty_cash_detail_pk;
       public            postgres    false    314    314            �           2606    30754    petty_cash petty_cash_pk 
   CONSTRAINT     V   ALTER TABLE ONLY public.petty_cash
    ADD CONSTRAINT petty_cash_pk PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.petty_cash DROP CONSTRAINT petty_cash_pk;
       public            postgres    false    312            �           2606    30756    petty_cash petty_cash_un 
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
       public            postgres    false    248    248            �           2606    30130 *   product_price_level product_price_level_pk 
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
       public            postgres    false    297            �           2606    27189    sales_visit sales_visit_pk 
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
       public            postgres    false    275    275            �           2606    18561    suppliers suppliers_pk 
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
       public            postgres    false    290    290            x           1259    18584 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public            postgres    false    221    221            {           1259    18585 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public            postgres    false    222    222            �           1259    18586    password_resets_email_index    INDEX     X   CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);
 /   DROP INDEX public.password_resets_email_index;
       public            postgres    false    226            �           1259    18587 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    233    233                        2606    18588    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    3427    204    202                       2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    215    214    3445                       2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    280    215    3543                       2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    208    215    3435                       2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    231    221    3464                       2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    3529    222    270                       2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    224    223    3459                       2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    280    224    3543                       2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    3435    208    224            	           2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    280    236    3543            
           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    3491    250    244                       2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    202    3427    244                       2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    244    3543    280                       2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    3427    202    246                       2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    246    3491    250                       2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    3491    257    250                       2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    3511    261    260                       2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    280    3543    261                       2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    264    263    3517                       2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    3543    280    264                       2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    3523    267    266                       2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    3543    267    280                       2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    267    3435    208                       2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    231    3464    269                       2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    3529    270    269                       2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    3543    289    280            �   �   x�m��
�0D�7_q?@%�jv�(>�Q���d�b���i�v���p�#����ő�j���{�ϗ��)|�� ��1/b.P�*+ϓ,���a7 ��@���]����\ݰ�Aj�i�LI�#�NO�b�-�8�v��d*�8�8
��?�A$�yp�Pp��T^������6      �   _  x�m�Qj�0����"�$�I����Z:];���1�-C�y��gɖ�;��t>���8���C�(ZJH%���TB�(+Ml��7�k{;l�S's���@ˣiJ�L��@�iΗ"�c�p3_��-UJr��f�%,��L��s4��(-ڐh��>.��d�1�'��w�P�Xxg�>.<��.�����Xeg�Y{N�8{�hϩ)���x����Bv�:��91�2iϼA������p�q:�����654�wo�lN��؛�j��g�W��x�A��L�����z�����A��Rǚ��r��AV�����C��x��P7�HJs�%������Z�#�      �   9   x�3�44�44���4202�50�54U04�24�2��!�e�e�U���0W� ���      �      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      �   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      �   �  x����v�F���)����v�-l�|��9�IN���9y��B�$��xVws?5՗�n�ͪ�㦬�}��6��.c�K�����*L�g&���p�3�k�jߛ_�ϟ��,m�������x�z�y�D��Q�]���
��q��
�4��Y��5�QX|\�}]�Q�� ra��F`P,2�UqZ� �jT� ��pm�D�r�r)P�B "��\E�r�Q�B Ϗa�!�J��Q T�/����zZ��F��ѿX�-d�Q�M�oVx�Slpڿ-V��^sT� �dl��+4+d��Q|��;�pc�55N�X��+��Y6a�b�!��fI�@��ʮ;-!�\�iA�"<�Ehs�raP��rp�ѭ �n�.4
���ǺZfp��=�A�0�0ܖM�."��_w�j���uX,E�~�F�yX���in&��Qb ~k� �۠��gІ��ܠ�=��L�W"H9}/�gE�[|+��=�H�=u�EyXA��g�F!����Yr,����E��Ƕ�%���犡�@��p�ЉJT��skڭ 0Ј� F�KU�z��f�(1
����Ip��Icp�()��P,�~ۏ����9W"�ɐt�(��E�N)�BĦ��/(x��( 2ەu����t/�?��������򙫾�!�C5
BL�]h��N$v�F5
�I{�(���C�����ؼ�Gi^��PQ��Y<*��F��_���#����4���=�N��e�:4������kT���4���*�O2����Q̵Wk��'��@w�Q���mY��eS�J��0�<��v�OAd��܋������>j���qp�2��(�*���'��ۡ�:޶�� a�Q����	�����H:T��v�<�=��X!��.\8r�.Νפ�B������(4~���L�P�i���L�&i��Ǿm9.��1Z̓+��T+9�QXbw�{�N�m�ԋ����H}���&���@��=�Qhұ`��!ͯgc��p.-��Z�1����n4
Lʻ��Gá����Wktk���6�c���	��6�� /�o��6��F�IWާ�64w�?>����ΥR&�j�I���IN�6�Qh�����w��3�rM�3����	��D����L�FbZ�a���m��`�d]��. �~f��F"�q��tY�sV{}#�`z��H0*]��ۼ05\#1�D�;M��� z/k������H�F�I�^�ㅐ�Y�a��0�M[�A#��5�d?y�3k$|����U�4
�1|����E�H�u-�k����m�4���fB�`HKT#!�teZ��� �j$��O���?�s�FbH���_�#k$��ݽϩ�~$�$�D`1!T�WJO_4��X�P+VC_o��� ����ϫ.v�w$�FA)&�a���t{&����o�\�^yZI#��[�5+ ��dr�H�ŬV���Ң	@e]����y8&�`��������s�z      �      x������ � �            x������ � �      �   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      �      x������ � �      �   E
  x��[ێ�8}N��?0�n��I<�gg�8m�����&R��v[$��"瘢(�����[J�M){K�l�R�#�����2���iw���7""�4-81"��R�u��~W�GW���}����z�N��c��nU�vUi��~�v��$v4�;��F�����R@)���b�KR��[�z��u�VSPKG��Đf�j�{y8W�n�hOe�|T_�6yK���$�R�]��'��kR�9h
) SЂH�M��h�&ݹ��_���.��^5�eb�A�]�!�2/I�oXY��'�#(�-ا��ČC*A1@/�g2�-H8V��%�C�>�����ݵ�5Ur�[��,�R��
$�&���s<�����`��s_��p؂�����r�9�e�=�&W�F�<�iAؘ�u�}���lw�/�G�MC�����>�nH�.�H�d_�Z0Up
b���t�U�ӓ_�Dd����{#iB҂jBbk�P�/�Y��DBr�'�j���;d;j-H�� �V�7��ks=}/�B��ܜ�Ժ�����?�ؚ�}�(��`�	V!V����N#4���,x
b��R7���c1>�-�̖��/'�s?�n'@��������h&egŽ�����:pb�W�=>}v;���w�v�$~2�gf��B����Y�D��M���aEA2CNF4���e�Dc�Y�����<c��-��}=������z)W>�"�E}:��V��Z�ˀ��8qɣ�c������nNB�g�2�ۊ��YA8�ɗe���39޾�Ky���j�*ZKM<����kn���k�!=�$�0���8��k{�Ol s!���R�8�i Jy�ZiW<t�-D��nQ	��J�:2��A����ɖ��F�>x<����ޛ������d��,�%d�Ub��y�x��.��� ��)1�V���*���d%/)1����İz�G"����PߛU�/L	�}M�N(&�/*A|�s�{���z��C���6�N��rs�ż� ��81�˪��-�~D�ƥ!=�V#�u��S�^&A��tm��R�ax�Ƌ�����N�L�m�k	�X�[j5,A� 6\C�[�t��r2ׯ�{ p����)^��2,C"��v�Rf�gWFpَ��;D8�@�o���;t�gx�w�/+���b`rX#�<�b�=\�d�Ǵ/�fxa��<�����,hb�j�s��.�x�dAR���Z@6K>z0F��c��>N�>")Ǎ�)Z�H���(HF�3AS�= A�Ն	\����,�`�6��V=Ԥ1��{�����'�f)l�J�2�ש��@�Ɔ2���i�/�!\�n��>:6�'���kPO��B�Y��8�Ir}����Z�V�?8-��ג�����&���)���$H�j�[2x#�Q(�,��7
�k�/�
�С�۳E�����pQV�Zqf�z��4o��:/4>�ǝ�16��+<�}k�3�k�p����P�-�I�t0;��)���ϫk_����!&�5�K-!+H�N�h���� ��6Vz8Te�p'6F#���G�m�+�-/ƅ�1�ؖ� ��W\ŖM�W1���q
6�hH�bDz�Y)
�I,�#G�ҘC�;��D�!~	�ċ�t�bP	2��7	zC��6	ϯ���qG�L8� ���~�Cy;&�³����}&a��qR�w!͒�؊�h �R���,f��-�Q�	�L�n����|V������xE�P�>�؊:E�s���y		�<7 ffl<+1 �Z{��)��̨�1�*��]�%�+�qF��Fz �}J�z"va����W�<w�|��؊�X���  �˂Q[!#�7L 3��u:��ؚ�:4�TXyr\��$�m���ܰ8��}L#!��AL�>��k;ܻE^�;�w|33�'��p�@1@g���q����糅/,���@uS���E��.��
�yObE�gQ�$��^�0��u�.���#���o��+Z�@iNexD6��X\*L@{�+���w�RH(�=��ɜ?�������b+V 0���?�C"b�5����#��L�y�tX�3d���4E>��Xx�O���DiF&���4}�^�H�g��	T���s� ���$�fR�Ӳt�,���'$M��O C�9��ؚ+.�C�#����x��	�_9a�	1��o׳����aJ<��j�������R2@�`������X,ď�0		\d��/-��[�/�c�С���<vX̔#!�9�r �i~�&d���Q�,�6_��u�^�E�KV0�(�ub_6��P�3Бp?9oB�?���q���N?�g��(�K�4�z;?��S[���B#7�!���-�7`O��x�h��������a��a&ܿ��j��������8d�����Эo�E���s��z
b��QB��:��z�.H=��l�O1.��;�~߇і@B���"M+&���"D�NE_-���8MY�o���w;����l�ck�B3��|���j��'V�A,j���2��C5���/�����Ǐ��-:�      �     x�͛�r7����h��`��&mѦ�,E%�Tn��7몬S�l�q`�@��hs��/��D~j6�� A�����5y��,���&~ǯAm�܀��[���y�n����~���R�E�_�=J62�[����||�0°$���{����?O/�~�����{5[ l��|��_T�s��V�kێF�5v
��y�����=!j�)j�ZP��3�^��=���{���(B��@��Q:.�������p��L�D	�t]X� �1���Y5�$2�sf�������˟���L+GiU�����:(�#@���̺?���%� a5�hؿ��w]Xam֭*E�������U�$a��I%XUgV��*�����%����T��a*2+IX����z,�E=����V��	�gҕh��R8����|�)Vd���Z�W��N�u��#3D�C8��9vK����6)�P�R�CZg��U@���Ͽ�}ޣ�
S0��7`��AM�.րC�h�,�SR��;L;���h�f^Z�
#�W(����ot�_9����1JR �촭e*gRqd�������-�F��Ӄ�	N�����������ۯ��\RIc#��������΁ֱ�Tj�{������N����EV G��ZQP���N�uM�զm{V�z���͗&͗@�K�ժ�S��*�jc����,\�
Ww�̅�Z_�}s���j#��I¶�3�,�dr2��}+}�^j9©h���hI+#����{����������i?�ޟPӤ=�hK�M:T�}���ih�J�Y�:�S=�|����O_~����W_��=���Rw��Z����%�ؤO�'x�X鰣��u
*�i�)�O6i$���-h�;����~kq!�h���t����4ìq��M��l}X����;Lg���~j���Wu4�}C9��~\���9�V6��*������r�Zm~��y����	�[�Y����a6ڹ�w��� H��ȕzHl�N��X9*F2�vl��:n}vL��
�Z�J�P����~H�lb��i%�l��t�b�)P��"Q�i+T��loλ�����j����c���\��Q������.�Rp-���>�~��R ��!!vml�pV�Ww�ˉ��&7�A^hwS��>
�#0���I��U`E�� �^�"��w�T]�TWvƈgT�e�G�	�<�y����\@�+;s�ɽ��E!GI0W�<���x&�9Bvy �z�]���Y�5Et5�P��5���l{�8��D��s��^�_(v�:����F������}��$���P��������-�������E�a��`�
A\��7��f�(���cx��5W����+��EǓ�@蜰���iq�|��PL.��N0���	6S�/R�΁N-�2p�+�Ӷ:���eg4�@�rI+E��~^�3��Xe��P��Sl� �-���-���ܰ��W.י)�D"������|��31���]��[�d����HU"�d�
�9}�1��6�!Z%3@��@�����#I
D��@�F�3k(<�by�q�ry�I_ ���o+ٴ��R�Hjm��_�sn�ٰ=����!클(���n������?���)+ ��q��߳m�c�0)�����څHK,I�KP�5	�)�L�ь�����BK�8
Pz݊��[x�V8�h�L1��� 2�_k:Ƴt��ܼJ
X��rc:;x���E��yC�#^܋W����bTq♶;�����"y��I�㧗�y��]i��f;??��0xU����g��Ѳd�_�Zq������C��V��/H��j����p�2T^��:��ڠDʿ�Q�+3�J0��"gd�b�+Luz��-��8{/�&Mṍ��z�h�6�-�u�zH]tX��z�@�7�*�'E����Nfuw8� g� `bh��˰������p�}p)�N.�m� ��	OF��)���꜒g�p��R�SGW��R_9�6��ڮ����%�va�Ëu9�-)UI�휀�玉V=�蜽vStK�3���&��|����-�d�v�>^�K:�X���4�1���&%� 	�b��B�m��S�8��4;��/�f��u�Ny�E��tC&8O�^�c��p��]!��f��Y�b?9�Χv�R�T����p"=ޟ�h���f��YMok�z[#�b[�ĵ�5L�tj7��? \R��7��`�v�1�6�~�ic)������]R��m־�7���v�q�@���%wD����6 mֹP��L�烮j!��9w�b�b����sNjz
Ǽ��9���T����8��a�;4�sN���1m� �ҝ�J��#�vb���fM�鲝8���3NJ� 1p�\�Bz�|%����L��ڐ�b;�Tm�pN
۠0�����nh@64=7��P��|����}�ۛ�Xz_N�ڀum��#���Hh�O���޷�ed�jT�CǗ�q�Eŋ���??7inv�ݱ�� Ϛ��f�M�5�ׄ-��-3�.Fhk���#0[���3�7P��+%<��AN��{<Ó��`�ڥ<�I���4Uw��99�9+f	�ΒQ}�������X��)Vr{�d�KΔ�E.|�SW۟��5LN~���{=-Ճ#����Rr��S�K)2���+�7��q%�C�2�6B�k�%�ȷ���)�v}�H�dO�T6��6�s��h)yP�v���U}5N�$+�O��?�"��@cZ'�&m��7��
*�F{50�������p�=��������n�R�FST�3us�5�Ir��p��	{��n ��$}X.��� �ak� W�"8�|����x#8��.�g(��!����BG~&8:X�Պ��݄2�\�A���3��ɏ L��~yN,����5����b�!ZR�x%pknڄ��,�&l� ʆ6�g����*'?i _󹳄�.Z4n�17�S)8^�KJ��J#������Xx�KNǆ���`��T7�Ս���
�+�n����E���J+�n��l�>3ʛ�9����=g:���,�O{���s�G�      �   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x������ � �      �   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      �      x������ � �      �   �   x�u�1�@k���}�K����2t�@�)����avϗ�y��>>���s��kq+��:�V�������%��p`8���r�/�{�{���N<1x�ӂnt�B\|���b�co���g�Ƙu�:b�bK���r��p\g4����h�3d�af?��A�      �      x������ � �      �      x������ � �      �      x������ � �      �   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      �      x���a���Ϝb/���%{�N�����6K?�JA @d>�n�l�HK�ݾ�z�W�*�sǟ�����O����!���������x��?zz�*���_�	Tz���LXe�{~�~R)?G�q��b/�� �9�۾*w���v��>W���5U�|�d5�����H��{������%�j\UJ	�9j�ո��24Iƽ���Ž��#�9z�՜MU�����>Av�\����F���J��[���ōާ�AVs��n�mAVs������;
kdS�_w�r�WLYB�2(l��p?��(��M\�0��uY�k��l���iK�'+H�q�g#p=���\!.�P%�j\H�fo����zF�$ܢ�fm����zYMڴ5�u!��<����4m���8%�j\��P��״5J��&��P��=�j��Uc�'���/���h��#���~�q�(��MSc8ё�(��MUc,ґ{�Ȧ�Sg 䥂�Pi��q8y��53���h�aS����~����l��10�Ȧ�14;ɚ���l$k�ҡI>���kM��ꦯ14���V�Y8Z���w���|��&�1.�M�&�FO��i���ꦭ1*�Yb7m�AI겛�ư"�۔5�3��m����k���ea?ps�:�3Ȏ�Ӎ�x�
װx��K������ų��f9P8�:~d�#�aMT����������8{WYXZ�E�,,-�fU6j�*�J��U�ٝ�]�#�V��f��r�Äq���	C\�}8iܲ�G�a=�7�A��"��I���ܸ	���,5�aȓ�ZQ���i�M�/���&��&�G#�3M>�MVg�Lf��(o��m&\��*�<����p$(�e�0�(e�0�ȩ�aH�nƤÎĤÖĤ�(�OKx���1��5s���!2��g�0&H?e�W���Ck�3c�(=cCk��3�'Jk����i���gO�A'��$7��i� <#���)�|�y�0)�JX�$<#�AX=��;�*|�lдaᓗjF�`�3r��������r�W�i� <���K5�6���ş��X=cX��9���O�Ҥ�ೳ�I�Qy�7���'���]Qzf�Ge�>>K��a���I?QZ3_�|�Q����y/n>W��p�3m��d�d�W����ZD^f��gl茫�L�	7|}��3�h�HӾ�5�	� <ӆ�Ȋ�}E��-��>�/�	 �K�-�W9��s�?�N��V��ƭ�6�-�=���|Y͹{�{��R�1T3�c�&���	����E�l��B����{Y�*�@������s�?�q��G�W�eW��+�S��#�g�N��c�`� �q����6�uّ�U^������vl�z��+����{Y�k�z?�ڡ=�j�&*���������z�&n+AV㚪�Z�.n��T��!w�d5gS�S�ܱ=�j����掅��W07l?��8�]��,�X	��3t��lڱg�՜�+��ܢ�F6e9��]�;�j\S��Al�ۤ�z7Y�%
kd�S$��AV���}}y�^AVs6m9��]\H�).��QX#C\�-�9���@Z�kڻ�d5.���w��5kӖSJ߱-�jҦ-�
���(�Y���
��:� [k�r����d5�i�)��⚴�W�w�C5c��m���1T���v��'����қ��Da�l��zv�k�Ȧ*�?b���ٔ�uG�`N{�����'�`ӗ�`����u�`S�W���P/O1�y�l
sj;��T-v���+;�`ӗW7���/��߱p��{����z��X�g��`��;�`��ǎ5m9}+;ִ�|�cM[��;֤�4��XS��v�cMYNYÞ�,�c��~��u�d����{<e�kX�jq�%e�L��eq��YȊz�T��#��HGz��O��ʚ�8kXQh��w����Y�����lVe�V��Q�TYX���9�qE�R��J�X��,�U���,tE:�
�f�=�����aa³��0�8NYZ���,�,�H�#��$;�g}4��gѺ�Q?Kٰ��0�����,\�R���(�sh����94�>Av�.<gь���9�EQxY�Y�(�,rB�0\ҲP8�:(v�Qx<a³���OiÅg��KiÇg��kִ�0�i��W��Pi�(ܣ�|7����p�]frf��]erF�9� �q1��f��
������o�m��������قz[f�쌩-��99c�O^#�+��5n������zb��d5�d5��F��������Og�L�)t$�ٿ�r�e�̴��R���l�(���E�^��JjM�������PN�-Hʷ�����C�A�|[w�k^9`��^߻��D����g7���'
�wQxh%s��4��>i����gִQ~�_�P8'YM�'���d5g�ȒـQ=g�5��l�M#K��PW�S���4����mAVs���"��w�՜�-��8�n��#2��luR#�K�9Z�T���4&7��es�,�l�z���p%Ue� ���v��wIek��wX|��~��=���18VsnAVs���~��|�P����#aԂ���yBYP"[�������/���싩ǯ��3����CyӁ�g��>��C~��s?���{o�L�z�oQ�%��]t��b�Eݔ� �q��/�豯/�iv����ܛ�Py����.[������_�э{Y�k�rW�p�C5c��Ȥ�	�#�m������%�j\S�����[���Ž�]�e� �9���E5]�Y��r��tY��]R�c�#Ȏ�}�+w�C�� �9CW��G.{Y���� u�(��MY���n�;�j\S�fQ�Ik��u?J��&.�R7p����/x�W�՜M[N/�..��v����F���[@/G�q��.��ƕ �q�,}V>��fm���vu�d5i��fYX���fm����dG\1m��Ѻq%�j\Ӗ��פ�.E�WՌ�+o[�1T����o]�#�
E���yqk���4�Yt׍\��F6Um�u#_QX#��6���0�]���/��¦�͊�|��6Kֺ�)l��Ca�<OS�f	?6����	�_F�eM_�u�\���Y�΅M_�Rt.G�]L�c/8Z�rp.k�ڬ���&��BX.l���rYӖ���˚����\ִ��?�&-e�5e�� ��)�_g�c�)�_�ea?ps�:X	�����OY��Z�tIY<9�@Yܲx���,�c���&*ґaa�����&*�V���]eaij��,,-�fU6j�*�J��U�ٝC=j�jܨU:�ł�<eq��lGe�+�9T7+�!�,<��5���řp����4e�gqF�x��'�.<�)?�������Y
�I��J��u �!��;p08�FY8�C��d����h�@�<P>���(�DQXY�Ra��e�p�uP8�:(ܣ��iY(�D�6\x��P�D�6|x�,Q�FaM
#��|Ea���6��=
k�x��f��Cnf9X8��v�'�d5�����j�<_e�:�o�7�x�ո-Ȏ��xg7g�s4�'x�F\��d�#.�x���x;7�d5�3�j�W�iΦ+w37l��z�wՄMT�B^ư��ْ�x�{�xY/<	�_<k�x��j��YXӆ�EV�QXӆ	O?�cGҋ	ϕ,�-Av�x�d�C��5kx�Z�F���F���B��=�j��W�Q6Z�9�h�G�dGΰ����QX#C[deI#_QX#�e�u��ŋg{��}�W/[\Ik�p�Iv�/�x���Y�٤E�({Y����?��<�aǓ��܃��׭����R~b��f<����ſ��g�0��7�������Z2�/�>Lw�h�d�����M��&pءֽS���u󬗗N�<�b�{��a	�z�/7���q�Ax�m;�ۦN�ᙶI̿���U���g�Oi����{���Qb�(+1v�l�r�@~���R	_��3a���36a�7>6m�x���(ׯR~��#�O�����*����s��`dܓR�XpĤ��qOʱ�W�O��9�)T��+�GL�b��#�8b�9���z�\k�1SK�YK� �  s�Zg�s���9�Pl�TI:��}2���I�1�$�hC&iʃsι.�FLI1���9ץڈ�o)��JO9≓N�qy�9GĀI��U0z�S����R�^v�����i��y�y�H�Ā9r�ˉ#I�O��g�i�IJq/9w���s���<b$�1G�/<b���օ!Ss~-C&gX_�3&�wĐ�9��ky)�Q�����k�1S��1Sr��0fjεn3�s�h3%G=c�̹2m39��-��=6�I:k�I�#&�WR�3�s��3�s����'�;�̑3;�LM�цL���1�����Ss��:첖�3.ofIjĈ9s�	7F̙��|��9��Ɛ9s�7,����9���S�L���ҵ�S��Q8�:iH9"�̕s֨��'!��:iH9"�̕�f�B�NR��7���J�%�9�:�NR��1s�T�uҐrD���£��]r�������qyΤ�QP=�w��#b��p������uҐrD���2f����)cF�e̤����SZ��u�rD����䒲����c�猙�1�s���:mH9"�LNӃ��_r�Q���)�
���r�rD��;g̠����#b��9w
��KN��,���2�,��;g\�����#.c&g. O�(\ r꙲4 ��f���ә!K@NmO���3��Pr� �S�t HNC��@rj{�� �	Z $��H� 9ư�	@r*qr.�Y���\Z3s�h��z��	@r|3A���q] �S�tHN[��@r���. }%O9"�LNW� 9=W�t�ɵ�g��5�LN��@r�{] ��֌. ɩ� $�IJ� 9�aA���� $�2,���w3tHN�Y� 9���. �)���Ӌ#���$A��Ԇ] ��&h��>@A��T�m �S�� ��G� 9�aY� �$=b�$�����J� $��,K��s����j�,} 9�fY� �<)�H�߃> I�R��S��k�1����˧f9��Ԝ.A@M����|�"��9���,c&�˗39w3�HR��Y�L���Y>��y�A���4뱌��߱˘I9�> �革��9=��X>�Ly����~��> ɩ������js= ���f)wܺ,�SM��2 9�U��������c&�#���)r�=�2 9�\uY �/�.� ���T�HN�T]��Q��@N�.� �x�U��3r�̫��_;���~�O��������P�^����[V�m/���Ƈ����񳾃�������_�xִ_5��o���b�]s|��yʦ/�?��gd�����;�6y������ ��O���Y��,AxF6}�[��k��q�r7*��+ϴM_�6G>܃�L
s7:�a(���ȅ�#�9_P���K�iCa�:�>|�6����nQz�6��[<��� <#��6K��t3�mv�ro%J��&3�)?t�3���ߞʇ� <�6��T��!2�*?��glȌ�'�#k����c��%��И���O�Qz&n*������gަ���^>}G陸����}AX#ߦ2[1?���T�o,�G6��;���cg�P��-���;s���=�|�����m��d����glS�f?5?v��3��k�����3�il�!�Oö�7U�i���h>mJ�ln���aZ�lP�Ӧ��&c>��J=��fO�6�����I��]ŇMi�R|ڔ���ħMi�V%>���oą2w�6�m6��i��f]{�6��K�����_�އMe���>l*���a���������|�4�o>��b�w��a��̶*,AXƛ?e���x%�Y��3!&��X �������1v��&/����0�I�z�&/�x�,��y��E�ٿ�E�9��������	�����5ag�	��b�s�ńq����	Ca�9i���G��\n�0�YSp�0�8_o�0�8kn���8kNUp�IX#��g��I��%zE��	���I�9əT�wA�L��{�9E�}��=���=~��*N?��h`���c3Yxc��2YXc�lt��.H�c�a�b�a�b�=J��F?�|L��Қ9�~�7�t�Қ9�~�u�t��3sh��lf�+J�����L�G�9�������%7-Un?9!ִ�����l:#�3r���]�/���IxFnAX=0�������0�~�i?�K�����ikdX�$�?�x?��g�g�i_�K5�6��;���{��g|�ؙ����x�K����β&�G��e������$-J�(=3ǣ�������Y��t��3s����Z�~ּ����L�aM{����ʤk�����D�ef�+J���Wԙp�3o���M8ZNҴ%ZN�p	6�~�5C�(=cCed%kƾ�􌍗2����n:�$��?a��qE4����������U�&,Ax�m"#�&|�6���]��g5,�i� <��k��ϲ��c5i��9��w�Zvs���~g?�:^K���~��I<���\�'����ZH.}#�.}'���E�������9�Zt�c�B����k�QT~^;�|�?�_x�We�_Ȅ3� �ŋ?H!.V��(J��&����8��6(>H#�*��B��(S�Z��n��~��r-�1iR�}{?FQ�.l���t�(�Ď��t>����C>4��n�����Mפ���X����(�t�?ҽ|�H�H0�{C����A%�҇�n��~�.�%!��#Y��.�Ȓw4�����"&R��r_"������1�<�HI<���_j*�$`����PSea�I8��c�ܚ�8N���1���b;�[w]۱t��	CM�]�v,_&�Q�&���`��&��xΑ���mC?F!��F51�ӛ�v��]>��s����1�<�ȫZ�����K��m�o~�.� ����5?Fa�/M����~���1����0�n���cj�HI��u�&����0�s)	�۶���(nM9ԗnvҍkK/;{oZ:�/���_���.�F�i�a'�Ƕt��7ӵ���ҽ~��u�]�lT��tY۲<{^�i����i��ea�N�iY����uY��4�۲$M'��,H���ںy��b4����h:��e!�N�iY����۲i�5X��t<,p���cj�I5����>F����?,�BVE�b��f^[,��0,p�E�ctQ)��H!.&8�\��g�t0�Y*h�NZ�mq��a�����۲���5��B7\p�H�ctY��8��X����������k0�.۽{I���Xn��)	8�B��N���e�.d���	�E�.d��=K�/y��.d��-N8Yj��7��0�p!KH�Y�%�'\�8����p,\58�B��N��&z�.�O�����p�x;�p!��N��Fm_�p�$��YC�ptj;�p!KmV����+\H���
ҩ�NVs:�p!�ھx�'y]��K��|��^W��4y�⅟d��4y�⅓&o_�prv՗u^�yN�.䌣/K����^��nH��I�9��+Y��4ɑ�0��J�ux�,�����E��&r��Ҫ�uQy3�K�%�́n�}�.jb�uQ�0�p!++^x%� ���\�Ϝe	����.��ݗ�n�����-��חvp���K;8i���������K^x�4:��JΚ��NV��NV���N�8��NVV��;Y��k;8+	ܛH[�/��䬹/K�����l�55���V�_��S�����m�e����>;���I]��|���4�      �      x���k��(��W��6�2p@BZ�]��W(2+��q�3��b��� p���n�,�?�Ϛ���_��p����������~X�ף쇅��}ݶ��2cd��#7�����J��o>%Cl���ێ��T���Z�@�gS�߽�����a?r=�5մ~�Bw�}�9�؟-�G#���Cb�F,[ò5,[��OKȰ��P�JX��-�$��O)��x����+�d�\�v,؈%����s=��MxV��po#�m��e��e��eƋ,�����5!cM�X2>s3֡�u�`*X�
֡@�C�P�:T��C+֡����X����X����X���.R\��	�/��*�Qbn��&憉�abn��&憉�abn��&���D�X�����)�aJo����F)�QJo����F)�aJo����)�aJo����)�aJo����)�aJo����)�aJo����)�aJo����)�aJo����)�aJo����)�aJo����)�aJo����)�aJo����)�aJ�(�O��'J���	S��)}>aJ�0�O��'L���	S��)}>aJ�0�O��'L���R�D)}��>aJ�(�O��'J���	S��)}>aJ�0�O��'L���	S��)}>aJ�0�O��'L���	S��)}>aJ�0�O��'L���	S��)}>aJ�0�O��'L���	Sz��!�QJ/c�=$�!J�eL��M�}��Ǘ1�#��_�ޗp�-��8 ���	����r`�u�����a���#���Ĳa�$��7���$��7� �l�')wu�L�tr`��r���X�#ܼ����� �v��wƉ{;��;��{;��;��#ܼ�ċl��w�x��p�k�7� �;��;<֡n�Ab��$?��p���7� ��p���7� ��p���7� ��p��E�k־n�
9A��3A��*�X|	�X|�%D��X|	7��8�˖�8�˖�8����')w���p��t�N��Ii�XTzG��W5'��c�q❄Rֱ��-��O��۟����aۑӲ�R�:�b�h����v▲�5�����h��A�}܋�}T/J��X�Z8b:R^r���������#زښclp�I1���a�1�5�G���@��X�{����c��$^�z�E�w��fF��X�{�u�R�H����c��$�!J��"�;���G��P��k ��P�{��P�c��$\bc��$-%�c��$�-%�c��$�-%�c��$�-%�c��	�OR �*<��"�_#�M��P�{g���f��H�����s=������H��_po�ib,ҽ���%5M�E�w�X���E�w�X���E�w��h���Rݱ��g(�� � �Q�;�Ab�Tw,���:D��Xx�X�(Ս���-���/m��ȶض�}� zO ��'1�0��t���5�[m�g�}�dMk���K�1������P��]��[c}|z����ז�jm�v�{e�>q).�v~z������ĿZ�cN����&��z��u_GM����
��}�{�m��K�빎�6�I��eY-��"^5N�:G�-�����&�~��bK�@��8]�}U6")�&��lD�lDR���S�k4R�k$�!e�q�\�����*�SNW� �5�+����9kV�k$�u����^��V�k���]OY]$�����A�=��� �|*���'��.9�4�!e]r�X��u�A�됲.9H�Cʺ� �)뒃�:��K됲.9H�Cʺ� �)�s⚀�OY�R�0h ���ap�
�s$\(:��Ab	��	���Dp�XB�$�L�eKI��Dp$�?I������LG:|?�ä�Ug"8��H���8)}ԙ�8�NB���Dp�Xo)	|��0���q0>�?3���+i��?3��u�V�� ��Qª#�$7�s�v�I鰲Ԛ�h�����:��Ab��X'8H~{�jI9�N&p�X�(��Ξ�5k��2�@�|d2��U(X�L� ������g�L� �l)���˖�n�L� �l)������')wE:�@#�M	�L&p�,X��u2�# ��\po�uA'8H�[��Q�N	p�x�P�N	p�X��� �eK9�N	p�x�PªS$��PªS$�!JXuJ���:D	�N	p�X�(a�)�7��Q��� g���0���?���W���֟1�㮈�������?.�������S?>��c��@����R��ny�V�O�&m=JZB�{�M6�X����P�^i[J�{�Ɖ�)q�R��b��@�Ue��@q"h �e;�©/u�������᰺D��G�z?��+�-�Zo�".{I1���HUM�64O<� *�/������F~7 -<�T8�>�1n_g���T�g��JEYk ��1�@�UE5���"�HE�4�n:�bi �E�4�N��WzG�Y�+�E&+qL4:�U���V�cd���Y5��Fͪ�t���R5�* �;�hT�A����wU���1"���(T-T�k��^ru �#�6��XG�j �U{�����?o3>�������6:B�7�m��To��L������@�q@j��;��3���7�#�G)���t���blƴP�R�K;{�#��_0�S�c��n�\�>h��֮�������[{	(���Pu���uе���뇚COG�����Z�=e�za�#�eKa/u�A���=X������m�=�^��o�V� ���-��{�����ےm�F����;Rw��pY���]��5nG>L��[̓�r;s^5�\B���sx�߳|���C[�u�uPoAP�{������%����^
�!���˞c
���|6X^4h���FW�6�`��ڐ��@|��<4��(|��<4��|}��g=���M��K����@�Sh�����æ_G�k [:�]���N�k U h�����G���p�.�t{�6>���0)��u-��x�iW�5R��k >P��]Ǻ�eL�Fh�ԁ���*��Z���5�JZ�t����.,h����H�*�6�C�5�j$�:�]��@���5�j$�:�]��$��1��H�����z}�m��g,{��|Ʋ�d��+����_�����?��~����ů(���y�W/���1�cl]���?i?�Đ�-�];s�����4fj{�+��q��^�O�ֵ��{����uKC6���~��)�4h���^��{���'��=�y�h~3������I��;r���ś�|Z?�eշdu�����+w<1�f~�8h���&�tb֖�˒�:�T�9	���-���*���қ��A�b�o`�tq�]뛏����W�����Gb�v�Z��j��g�kL����������58�����m�W<̮��G���t��V����+F�Y�Z�|��MA.�k��x�v0|$�����{۵]�H�E]#����|$�P���H,�.��7\�V���A�S\ �HV��(�
>���%"c�G"r|$'�����5�^����')w��3���t���ä�L�����#���㤷E�����$��)2|$��n.���%3��^6�?+=[����^B�?J�A]'����u��H|2P�!�|$�K(O����X�I����?�� ��K���{��K��M��x�u��>����p�3�@{��(�RmϹ�����m����Bj�)u1+�ʳo�ޛ��>��V���K*�fi�0�m��W�Z�!Y�c���?���'w��;O׻R�,���[�^h-^=?�x���eK%���:r�lq?r\�X�/��?3_jW�T��Q��溜
dK�eK�ڳ��>������d�->��53��E����>~�*ۋsm��Қ�cO�b�V�}	���y���]Ŀ&���c�#r|$>���'>���"&�o�c����9.�Gd!�H�Yj��>�K��E�p��l��I�p"!�GbM�    V�~N��I
�]����Kp�xӣ�~j����`��Od'���� ���E����'.�L�,]��ZE������j��
>˖��D����^g�'r|$��PC�H[�X���Id.�H�C�?���u��G���k�Q�0�;.�!�$	<2������|�~/���f/���Q/���f/��g�zX���}�'��.����~����Ԃw5P��s�${�u��<,��k6��x������p�����o{��G�n���1/{�e5�Π�,K<���AG!��(ۑ�V�����yk~�V�Fþ�-�a/��@v�����?l�k-u���i��:��2԰��ZT�0N�}���9Rn#�k{��(�ETG���2/��Z9H,Ze�s$$\��7�(�����We�������ǽ�N_�p����n����9Hq�v��O���p�xV�V��Y��8�U5�7��E��-�A�(<�WK�����T���f4?~�Cn�.2�M�g���"��A�C��� 񮠬x�~�� ��D���w�ěWe�r�X��F� �l�����N�!e�RH�/��P>:_�A���r�|�p���B�1�/� �8)���Bk�2_��$�R�"���U��I���rDˑ|m�qRޠ�q❄��/� �ު|!	���rfEx�4E��3J�A*N�AbRq
����|!��ʍt����A��r.���^�0�ЗO�����Bg9w�8)�ՙF/NJ�u��ċ��k�@��\��Qr-4�G'8H�YJ�u����z�$\):��A�qRZ�$�J�e��I
�]���N �H��Q>/�5�K:���u������$?q��R'8�����$߿�.Pb�$�-%�:��A���3J�u���7�u���:D��N p�X�(�	��:���&�>���@��Ш�$��z	��W$8�>��|S$82	�7E�3NJ��;�H �Hh��	��a�5Td8f�k�$+B�W�=�ʓp��~�`����餑��d;�o��� ����r8JZʾ��SI�������6�o�Ծm���>�mNk)����4Un�o���.DK)-#%���^$�����BJc���z�����7X����2��C;R{�l�[�1��o���T�d3�Dyjk3�x�۵�b���b�*�:�k6u�̾YS�6s��4S���gj��m3��hSg4�[��b�Sw�}j���$M]V���6Wݦ�	i��N���8Uni�9?W{��S�7NՐ4uNmꪏS5$ϝ���T}��#����2�os/�S�4̽XΔ�T����y��u����
��n�y�9o��f���{�{��s��Ƌ<U{�T�-SG:��)S�2�RS�R���8�\(S��2u-�S��T�L�{�s��S�m�ڷ��8�<]���u�Z�殅���T�bܦ��m�)�͕��u:u-lS��TW�w��t�P��V�PsJ6�ZS���d���7ڑ�#�CL�������
5@�Ҹ���d��k�Nշ:u�׹#���թ��T�S�Sw�:u�S��}�ʚ�!�Ե0��?�9�N]�S}�6՝eS&l�șF��Ԩ�j�,�����^��(��3���n@��7��fS�l������L�����F�UcS#Wl�Mզ�Omjď�u�Nu��T��M�#�Tg�M�˳��X�lbS�jl�7vjp�MX���]�덝�bs��y��M�l�T��M��Z�;ҹ���7����ʝ��X���F�j'����z�Ms��T{����T�zcm�Ц��l��ܦ�-mj�F�j�JS�Hi��l�p��#�#�%l۞��Ҳ���G�G�K���%��nn;���f9Ĕ�s/�����z�r�㩏)v��Z�c�%YIuص���ws���[ŵ��V�X����Y8��u9/�}��դ%��#��ƽ8���r|>�Q[s�h���{Qmj��M�#���65�#M�饩�4�n65>!�n���d�e��^�S�/�[w�e����i���_k�ߞiu���.O����V���,e���珡�y�OSav�s�KX�7vE�}�Cb��Zn���u�H�#�ⵡ�mq�s��v+�@�d���X$��*�� ųS�V=o�HH���|ϊzR�A�o�g�$��?��(��9}Ϭ9}�H�n��zX��R)^s��O�(�� ���V�S���Q�7U\�A�'�$^-������(�� EqE�AU\�A�]A�p� ���)u��j��u�����ĲU/:H,[�~�s��OWt�	w�fD�@(��$����� �8�Χ�+:H��tqE��I)�.�� �&P�!�+:��@�U�UdqEG:|U�aR�b������M<N�LWtƉw�7tqE��VWt�����ά��5EqEg�X�T�5H�pp��d�GWt�x/��HWtv>h|����?��)�+:�S���L	^��8��ċS�p�xqR���+:H�8)������k�>J�eqE����$�,�庸����z��+:H�RtqE��Ii�.�� �&PZ.�+:��@�U�����7=��eqEgMc�RC�.����:��[j|��$?q��RWt�5�1��AWt�|�º@��.�� �l)1��$?�:��\Wt��FC��.�� �Q���+:H�C�?���叺���M�}�?F�����B��.�� ���+������F���7EqEGF����MQ\�'�1Y\ѹÉ�	m����V?Q\���?����+:��X]\Q#UqE)�+:��VqU\ё-�|.����V�;(��}����8�^����M�wP��;A��Z�8��>�#�歏!!�kɽ��J>eD�poh��]�w�E4�^�����ݽWI{GwI#Z';��{ݱwPh��!<Z�	M������!Z���2��,G$��dhH{#�|f�`[�/C=4t�*�[H�|���5��� ٰ�5����F�;(v+G2�H�3��a!2|M��MCΟ/L�ړa;l_�5�͆� �5?�ch��,�Z���ns%!.i�k*���z�㹹��[����n�$�g���d���^�2�[N���x����!��[�������~=乵������W���됌�I��Q���Aض�o���U��!����-[-5�����-�������������{���ل[�ֿ1ao���~j�ps���(��]�k����k��`���-h3-�^T[Af�Ȏ���+9$"2Ev�X���׆���z�];V�+ҍ��Z_��y/��
�6�C�ҍ�3��H�I�"ݨ��H{+�m*�Ê��"��H�no�A!��H7v4_�:�"=D�}Cv�{��wPD���R��,��:����%R�A!�@�XC�{	�wPH����}q"C�"CnCV�{��wP��������4�n ��!��!_�!o�1�4��?2g3L#�!�����;:�d���!�����;(�c�����S�$ʤ�bJp�8أ��O����Ck�p�m�oX�ïº�ӭ��[8Ũ~6w������ps�+���wv䴤�mܕ��5m�G���9�͟4ܽ�sm��������[ȱ���
0���?�ͭ��Ka�����n���^���q��99�Ӌ�]�]��ҐYΐ�ʐa�=_��D�U%F)��ېqӐ!5��|����x/���N̏�+l�}�����l��}[�r��}��>�J��%�p��]����������a���]e�g�_z.[��rn�)�����/��[�R�ͮ0|�u��p�ִ�:��'{�����9.C^b
��1����uYג���]�G��W͍-�a\~���������זZ��9zw	�k�W����3r1�-����y��eTD9�4��m�-^�0_�(N-,KXCsb��u5�����y�mē(��`cN�����r��t�s�{*exR��~��o��J�1���sT�M��`:�-'�;���s�uP�:G�D���G[]MPϊ��Ə'�Y��̭rDo�>.ͥ�����ʯ�?��swz��W�<�+��X���|���� E   �>.��y�qƱ��4m
��lo?�-�Zǃ�α\S��+���%w�ޘ��]U�"-��Y��,�[������R�      �   �  x���]��6��5�b�@~��b�ݠ��Nv�
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
.>�pl��?��kp�6���6N��%q�VUx���u��hk�@�9[[�ݲuK搭�W��9aǗ@�������ꔫ�z�N���ǫ\E��y\�*R��(W�;�P��wl��*>ȷ?�%Y���7)���5 A��xE����@��e�@}�W�y�0:�P g��DA����3�:�w�\H6�s�L!��=\�|l��զвf��Q��|%EB��^D��	��4�:�]d���F6b�4nĚ��� ���������`�f�l΃l\s>��M]sQ� �׼+���������߷/����P3�|�Htw�˻�������      �      x������ � �         y   x�3�4202�50�54����44500@T04�25�21�4#4C+C΀����l]�Ԝ��"NC΀�H]C]�r0�2F����,�n����H�>��>����l\�s��qqq 	�-�         �   x���K
�  е�b.���ѩ�(��M��?G�0�K�B�	�q ���z�����P�K�VZ�,��0��!�` iI�4,��@�A����h��u�:��1l�Oe���-H�=�b���h��ɺny���Ĺ	֊Ehn���b���-��?      �   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      �   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      �      x������ � �      �   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      �   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      �   T  x��\m��(���{��2_��Y���X����dvfޚ�.��B-���+��+m�������-�;�m������^)S���(֨yRc���*�@�_�P����@��5m�D�F���{Pjx��0P�+%J��3���4��Z2�QϹ��NSjkH1P�+�i*�$�x%>M�{+{x{e>O�;$�����S��0��������������sh;�a�2���`X�5~߰9��1�x/�N��ׅ5�Q�wsʻ�:���㕣����K�9�)�u[\,��͂�+������{,N3�r���>�c�&Ҝ�@�Nټ�ֺM�;%:ŭY�zm�+��0Pw�[3�b�����Z�a��buZ3g���Z�'n͜c33��zI�9MTi%��am�����yֺ-�&�9�d�w��IMlۍfα���9H��X��cu�sS�1P�s����9��9ba�툡X��رg[���W�kǚgCP�M�{��92��W�c[��E,�S4�M�1�m�����N�I�fi������E���������k��`Xo��O�zo�����ޛUB���Uh��?7`��R�#�⍿/��W�0�Z_�G���Ħk�������F��ڬ�NS��p2ԝ�����a�$c�7+���1Pw���zә��L�Yr�ڱ���0���tz|tZY>�E��a'ΤvW��-�v5>Ā�%��Xc��bfg�3q*鳎>o���V���p���@�M�~�a��a�Om͜�0��|5���fb�z��u�1�^�����[�f����k3��N�f�b���J7�v@޷A�c���0P˫ЏM��L�5�}lp��|b��{Yo����p5�"vkZ�ugɅ��mt�0Mmuv>Oq�K'�nO���ʺ:�5�}���'�j1��L�8�9�c5~ҵfɍ�c�fqҥvH���0���"�6��ܱF��0���f�����4�2��5�0Tu��ͯ�a���5s�h��|�a	�'�:%[3Hw�Q�;��w��,.y������i�\@`�U��z	�.�_�as�W�8k��~�rx&��Æ���b���3?�{S��i�d�K�ib�T�7J��C��8%K�ڱ��65���X�:����:����5�~�����s{["�����a`�����1�C2��Ҏ5㯷E��)>\3�S�0e��Ű6�;����r�a�yk2�y,i����7\�u�]�|���2�×���8����/����f�bH���g,^1B�Rs⺪U%�[�ל�a�*q�ǠN��#���G6��7"�G�8ob�*���e��f�RkKDDJ"���ڥ���1P�ֶ{]�0P��v,���A�Q�H�\��0P��VɺV[��k�V��0P�%�(g5	ð�31t[���#:q�c�)V�K\�:bD�Sw��}m���Q��;��c�U
���d� �vl^3?U�A���Th���L�!qM��T�)M��=W�0P��v=�r�����Trm�d�u]�4)�֢+��Q��v^���&nŌ��-�rN�0Pۈ���b��AX�2E&b[b[��:���M���N���C	���d'!�P��&�a�^X�]�˵yb�G����?���}��L�	�R�1P����ib�vs���ǧ��*����!C���@߫a`&�]��aX�Iө\bڰ�8H5�`J��6[�'��\�Z7�Ġ�v�S�\B|���qnv�b�)U.Ef����^m-�+l�<s��9�;3�k<B�)2�@m��*��A�PZŪ�OڊJ�u��P�C&��+�f��k�$Uv�
�S��1�-R����LoӔ�o��kʯ�����a�J��e=��s��3Rҕ��:��ҟ\]�a�ja%��j\��!�A�Qb[\��U~�\{�Bʏ�WG5��r����C0r9�md�n��W�+�K�o#�{A�""ݷ!5�6����4%r*�i:�I���u��o=�����^y��Hw��R�^�0P�8oZ3��7TU�v2��c��R]��&ꩌ���� S4��
��]�a�Ң����j��hm4s:�a�N����"9�G0���D�*�����Hw�6���Y��ֻ��O4챰��L1r _�G�Pk�U�<����\��ot�����51710E��Z�	>m�g@�_�ҟ��ڭlR�k���E��#�n��i"��%��y�0PU�]	� À��[�gj�Wi�;.�b�[�Qx|�Z_]�}Hk��6d�,�fLRc������00E ޕ1gS�.�31�e����Ie�U8���u7�uCVMr]�f�+Q��S4�y~0O����1�W�]rj�6��;k�u�m5�{H"ׅ�5/f2���H\�fb�Ue�[��2���*�5�01HO�[[������c�Od�|��W8�ǀ���Ɉ��]�'�=���Z��N&Խ�4ub�Juo-9�$��D<?��}ވ�5�1�GHa)��*}��9�ZS(�o7��2���H~����0�j�3Ɂ�+��<.��]�1B��d���~�r׹��:�.��rD�4�D��cq�Ï||<�"��Mʓ�E6_z`�%F���A�>� )G\�k���ʛ�r"'2�a��+/�cRPF@��'�,']0]�>��ۚ�ĳUJ�y9&'�r��u��UN7Ԭz���L�@�Մ��W�vK?�H��O��\��m����0چ��Jd�:bD|+�f�>05f�׮��MM�����ٶ��a�RE1�R�Ƕk���;g&_Ln�E>|ry��T���<�ٮ2��0�u,a��  e懃�D���0X���2I��^Q�5|R���g����F��[X{e�\Bb��:ܐ|�ְ��a������!�~��F3W�n��Ai���0|���B��LN�4T�d�5󽖏^e��?�rߺ���>\�/�*r��c�s�@UosZ���:�@Uos�I|�o_��uŠ)���I�a�z�u1����%�\�!s�>T�]S��`��~q奧`�>�Gb8F�~)�x$4�Ζ݈㨉Bb�SIn��Q[&o���1��m'S�)�vM���Dz5�!������ρ���6�|4Ԩ���6�l�v�]�׶=	At��P���:���MݕDG�${^���(�l�չ�Q�|��aP7�G�$�2�$\L^bb0��
&���a��o������z��)�>p2�,4�\��P�9����Z�┱88�U���1�t���31���զN��*\�:�o2:��C���M�^���C>�]E=B�Bν����~�P����*V+�5��n���~r�K�1N�+�Cٓ�����Ck�z��6���^%oJ����u�f5`�@�R�5�/��H���p���~�a��@���짢n���_g�B�u?�210�PV})�arԒ~���̻�q�ta�Kl�6*PT�����N��gR�:z�c�y/l~j��7�\��{���t�����F��r��00�d.����̂�V�a`���U����%�g���C0Webb`��܊���ɬ��;��V�I��X������V�S{�������[�}H����fy.T���a����"�B!�p+�z�0P�[qA҅���Jp?�ra�UU��n�W�9�������u(X�j��pU"��3�>�]�&3	�<���Y2�h����l����a`�	3>��d:_6�`7��ӟN��Y%����1C=L�uM�\ؤ��Hk��Gچ�5�8c��IP��W\�YS�^��^C�NQݩGAg@�NQ�jq�(H@�ʩ���@=5�mT�@����j��$6��Sl�
�������'u|�      �   �  x���ɍ�0E�f�@\e�E���_�P��xZ_>�HQ\�7�Mq����ǟ�����ͥ8�����*��!�CB|7S�=���y+n��C^�<Y��7�!�}�W'N�. )_���ɑR��X+�����KϿP�Hx�k�@�f���9y�S ���[����� �������I�O�/�'���/�~���E���|Y�v�C���+�T���%�{��<��?;��,=��l� e�������#U��] �>@V av~��y�Ƙ�d��Bį��3�D�|�i�ǘ��w��"�r��ڿ���`��u��w
�ˤ�����O�>�1�5��)@��f�9'�?X�>z��xu�ڿG�RB$@�-w��j��PLPt��Q���&_K�J_������ x��      �   D  x�}���*F��U��dS����+���F'�٧#��WD~�����_����S��c��|��@2T�5�#sAGA=�� Bj2��\PQP������ ��6d� g�iEf�7|�����D�Ͳw-�%P(�6�B&�z(xP�pQIu�@f�SE�*�̞?�y��u=O3����-f	wjA��^�P���)���ep̒Z��9����������̇����%M�b��&����^�=��1󱣤O�3�N
Uu̒BZ�Է1%�u1�r��#vY� ^�<�Y��J׷J�p͞BZ̓Zfٷ3�`̘:�p"�����V3v����LU��$B���I�!�)l���<�xk�+�C���2PY[��`�ӛ$�'Ӫ��!��<a�����BU�u�o�|�)���!�oUi�}f��:}͒�^�
	�$���ԓ=(t�u�a�m���I0@Y���Ns�d�t��*AY��N�i���^��{�����Ї^�5#��3fl��b�4�fL�@0P-�>�� 3֔�b�����@�\@!i~)�i�N+x��P�Jv3J3�P:��G�I�r8�/���x1�U�g���hE횰�)�yH4�vh���K(�vͨ �%�I���C��R��q[ћ� �a�Ѹ�R���Ѹ�	��26�P��w3�>�Q����7UI�Ѹ��,�1�����j��el�C��z����p|˚���QA�qP��2��s����s����φ��`���O)�Hi�L0��6�`.((h�\�Q�����\p��9��
��z�>�W�r�/�졥�F\�>����`�Yz0��,H�[�=\���s
$5n1������?}�v���y����9�>\w�C��ֿ��>\0|W_+i��rW^�,=�'�<��B���e��z3)Mk;2��Vt�>�Z�:��-k3��(�	����q�`�!m\2�YZ�!��!M�2*4r�Y��R�t�,cO���
��´֘�&T������\@I��(��b.�N�����f<����=�o��~�>����+��~ן�7���?���E�H�      �     x�u�ѭ� E�I��[a���{q�-\������D[O��ߒ$�j?�~$$�,C*���֨v�Z8���1�3�r�ֆmR�L�j}(�&�,��5�w�ލSX��Q���9E����_��W*��m�SR����ݜ��W�l���֓e�Tө�1��l�f��� ������`�)�r̦��N];��p��F6^I�HI&�v�lm�g��5�7�k%��F���̄/��$�'YN�ެfh��H<�$ۤ��E�a�f�\;U������A���s+�tȾt��V���/ҩk��ٱ ���Z�4�-��Ka���*;6����/�k�=��a�wk��GIP�Z+]$�AC+Tk�0��W˼I���$���8�N{dR�Nk촐���+�N'�6髱����Ƞ���*}�cԓ{M
�҂����uPX�� <Uku��6<���,hhdj!����m�B{���c{�B;L�>?���z��>?�ة=~j�G<�H%'���zd~[���2=��=�Tҩk�� �����F�[�7I����u]u���      �   S  x�}���!�K����$v� ������6�+f�î�W�>�KE�%���S}�1E3Vt4�X���p�Ռ���Q�u�w�Ǳ'c�3�S���a�r���t�k�)=cp�;�8
g����N_���%��bU���1�̹��{VL�M5q��y��~��tT�=�Mq�{v�a�u�gv�a��v�g��R�MA��a�l��џ`�[�'=��S��~ɾ�`phd�18,��y��w�1g1����I��������ނ!;�>��{�f����-�>8�=�u]s�w��u08�}�aIr-ȵ���܏�-�.��H�g|���Ot�����o)�q�JY      �   ?  x���ۑ�*��M�����F���qZ��e[��ǯ�d���zP��;J;��9(S���w��J^�ZtŢi������m���vWH+-d��8��bI���D����4�LqV��S�U��n��ك �ku�MsW���:D��2�޺JYu~�BӬ�q뢪?��4�8��Y9��k!�4�k�S���t/@�_�_馩�t�k2F+�&����k��7��y���Z����((�E��p������M��Y��gɿJ[�=�ʃBz���Eu�SK�&��q���N��7��A�E�e
�_�,���2M�S��҆����"JtT?J�V��)�#
0ucW��k��ڐJMK�⮗�m:W����BS-8�e��,B�|�*��|����T(�����ʆ���LS%��p|I�^4�3�h�p�΄Gپ�Lh"Γ�E���a6E-�m���Ah*�� ��2M�l�(�B�F�{���AQǂ-�/�AqV9�c���B�]�H���LS���N�w�>h���g���l�<8c"�^�B�ԓ���6�M�i�|e���S���M��
��u{#��������P�Q���W&��J@�(��Fj�m)r72���a�aa;��]Wk������g6cW���y��R��)�-���)G�O��}�Kc
�n�BK�"J9�,���"W�G��o�xPxZ=��i�XZ>Z�e���vLuZ�pC��tN�^��b�aM0��mm{e�Bz�[�{Q��?��m�i�{Q��2��)��v/n�7��׷���E����J���BR��2�M��P��^!�4���Ҍy�i����(Od��3��R<�)&���2&��l�hc.�Q	�l�h�J�iv��x�]�Hh°�����O��q�3�ow#��;�=�fcxf�v��kb�3�Wh�F�{�U{
�i/߹ы��
�����-�)"K��ԝ�PRl�Gkt�<��Z��:�+������k�6SؠS�dѴ��Mq�3�k�<�Ů54ߪ�P(�]��n��Lq�`����L�o������۫�
�q������A�+�7��B)?�x͂�F(�������h��_J�s�            x������ � �      �      x��\ˎ����|��\U0�92�"��Qy�UÖ�oK��Ro�@�lΕ�2�"�b����c�4b��y��~M��GP��x7A����#�n����e,bQ�x��!��A�����yۄ�S�OiA����_��?���I�O3vm�v��!�{�/�=]D/�s=�~!~�.[@�	��T�}���NQ��Fo�E�m����{���ū�����Mʨ�<�<��).����g���יƼ����m�O�_�_���m^�x�t�C���u�h��y�y9�d�%9��(����o��n��Y&�U��U�<�����<�!�/6N�S�q��$a�,
�(<�$Af>؄�K�1�mp�.��x���>�,)�,
F,eL�W݃K�-�� ��
���S���!SΆ�y�\�����~zr�9�O���P�eC�O�����s��=3%}IDI�Q*QF1{��	�i�؃���g�����ahbT�(�Y\�s��R��$
�}�������W��CW���JK%��S��V%�d���Q���T��������V�b�.�Aj�%ŉC;��\��1�D	�C��?��������W7�郏s�>��AXJe��W\��
qGa��NW�b��I/{��0�����ŬK�=xMw�f�*����l�2=y���)	R��,*��[u�׭���ڰYqCr
[�,b��jk�Ɬ>��������D�J�����tOIe\��M�h�lIj��yN�y��ta���,�[ ~u��t����)�ř�qhs�vfY�`��k7Bߑ�+�A�r9����kZ\�}�g0�z����"���B-œ��E�խms7��[��5����NQ�CG��"d㍢�������@Ą�L�%ӵ!���&�Y�d	�z�.�F6As~t�8.�����^�	�����mj�N��k'5�DP?�4�ڟ	��,nn�g!�0⒃IqS��CT�t�n2>�f�}�~�pq>f���e�Vz��:z��KW�����F����{��(�Sc~�>�ihw�	��#��\�G����@gc���1��p�H� �M�ܘ�9��l|��h-O\�/�U?�k�����76���\J`�8�bė�8����ul���H$����/=���e���n�S�Y�z~�h����m��4c����|Q�h��a��B65w���E�(��C�0m'�<��l{3��{�p2�1U�*+�����p��6�	bǸ�D���/���,B�^b�p�&F��M����k/'��9�s��(�Z�we�����V �"Нu�ЂGqf�ϗ�o&^u�n?��Y�j�L�txLF�P���kw����^��d{!J9�l�Jǰ��5������B��}d��;hvd���O1ȩ$ٗ��Aw"=��Ñ�m#�᫮GJ����30�.>"���kwFU����C����Łt	�O��R<�I�7�}��'�ounF>J������o�\RJj8�����(Ѽ�j�5�k��_�}����]K��W}��Cz:E�~�����{�Eai�-��ַ�V��(�a�E	���N��5��Q�ڴ���{��+�K��`���o5������L5�g��Ė<<U P��+�f\7��"C��8�yz�V汾���ڧ�	�a��!_�����K0t�����G��)�q���������2~��D+Ś!�L���Hk�㩡.ZAҷ�lVxr�+�>�3`([�*���������M��W2
��S�xL4���~����2��D�(b�qms��snm���8iL�������5�zյ\�b�o�(ޏ��_f���ً̜����-�n� �SG�_�y�5���(ǒ x�'��NBn.�� �C�P5��)�?eU7R�J�^�Ko�g�����ܕ,B�-��*�J^����y^���W�갆�3���s��J��E�{2�34���V0$�����z�a>�T�킝����./��r�u�0��e�b������5?^� ��iv��闇�4N�H9[���C	J����m&��^8I�c��j��A�-B=��:�⼼��涶HR�W¾�٧�H��ȸ��d�7#��ez�T�����e��TsZS\��v�;�`D��LId�M�m�@8y&�%�(WelH�MeO�w��#��b��fbu�Dk��|)�g�0��<Uw�}�mp�o�a������S�;�El���"ӭ�Ӷ�e�v�!L2�l�=�t���ŝF��.��!�<�AÐ<�������$���2�9]Ӿ/f�2䔟 C���Z������X�±{-Je �9���=;u�'(�s-]SYH�ɽgJ'վ	f^�A�V�LZ&�ˋ�,Ե����V����S��y'Ʒ2�z�kpX����ɖu����\śvE����q`��S��C�������n}^&/����}��)�rk%����Ғ��z��ض5sP�|�0�K�#r��Lϑ�r�/�nx�p��˄!_�Z2�S�!�Fn*4^�8��4������7/SlO׭0d*��]�x-p��BLC!3R��}R�޷2~���������">�4
��l��k�<`�&����q��KXj�/Af�3v��-]a��}���_��<���[m/_j�1Ya����P���z���!�6�7�W�W��|�bnv��Ɗ��V��
C��]��R?�_�>,�{�>=W뼓\��<��rL yYeXKײa^�(�zϪ�V+�Xa�Z.�+އ�|o?a���?��a�\���1z�mmt[a�-7)nS�n�d�v�ϛ�����֛\?���T��|l9�>�Ĥ��eW�W��^�Za��-��������3o��=�h�:��`/�
C�����-06����D���~�C=wqo-�F�x`s'Oju����@���vhW6O�>���۶�P�9����'���e��\	6V�s��fr��p��(�p�t���T�F�ôo�A��,DIq�$���FzU� L�k}���9�4���L�l�S�D~|�M/W��
uf[|����0�-�C[˔�6�l�6G<\7���0��0��cV?��C�˺ݼ�b�2C�|/wn���I�Cn��F��m�OVճ6���\z8�m&����+��B`CN9nz2s.l\Ȇ�1�k��`���Kܴ(��ocE�b���h2%Lϸ�\�UfI��A�P*r
�240��!����y�!k�Z�Z����G�$�*���al*i��I����^�4�,��{�<�.�f����˓�|EÈ'�˶�UnQK|�����&ֆ��s6��vz��~��m��������F\�>LT���+�K�x�ޞgVf�4��>�{]5����;����c���!���u�d�'� u�.������(^Ր����a^�N4h�&l�_d�}|�sp0�HEÐ9E��;X��S0E�0��,��4��y�yTNa���}PQl���Puȅ�t��%Xf7�FV?�o����i[��Ic��G�W3�m�4h�=<a�_3`�K� 9k��C#����C���%��\[�9���zT\?(@���s��I������V �j
�ԋ��,�/�_�?s:�lŻ���ƻ��; v ��am�!o���=�|�1�tcg��366������J�� �E���`�BÐ3�����f/�Ƽ�Fp�BÐ�X9��B!x���R47T���<��N�w%��.Lb�ڻ��S��*��l��Y�R�/�>��:�4Ø=�����T��ϝŮ�3N�Ǩ�u���#x���� ��(N[B��k킽챽n�!��o2Nˌ�)m��j|���8}�Xsۆ�)���0d�PG��ċ����
�V�8��)�^}�x�m0!7�a�T�S���.7����L)��
F�l���I�M�	D���7'#5O��w?i��V4k�a�
l��{>���x�0��gx d�@	0��G����<�����\S��"KR�|�}X�WD����D��^I��?����V5,����f���G����z��8   Xa�.#RգLc�G}������d�
l�����x�9v-8s
)偢��y���%7Y9B���7�� n ��a�"d�ͷ>�Y��.�����e��n$��m�X�#�Hqy�\�:_�7����C�d(����t\�+�U2a8k(wn�1��m���	S��.0xv,7�˳���M��65��X�-0d������`�k��Q�F&V�4c�(��岪��e��\��\W ����G�/:*��͊v�x��`����6jt���;WK|K�%��Մ������
z�+S!�=J�(S[���qr�F�/w�3��RL�>k��,���p��ւ`.}�7���K����g�Q�̬	C��m���)��r�	�q�3u�>���c9��3�a�2b�`��P����.�5aȔ�EɃ�?߆�zxy���#�<�BNC��\t�d��e��$�Ӧ��[�h����H��`��6!�~��0@H���s�{�=�Q�/`�P��eu�au��ՅEKGm��ǎ�7����Ͷ�ni�k��ن��H�j���H&���M+8*�E�mQ�Pq�c�1���c��zW�9^K_9���{���,�d�kbiAn�R�"�����p��m��k��ڐ/ђ�*щ�ҵ����ܲ���^���m���а��爰c�lM�
�t���&��h�(�Y���Xm�Kް�Ls�n�����VO�Ѱ_*�sl�db�,(�eke\YhJ��6�u*5��YZGA�b.�~�ڸ�U�p�!ka�&2 ��~ԝ��uV1P��Ɯ3u�_lRY+���ik�^+��]���+�_5`h^(�l�)���g��ޙk/�C�t3��5�&�e�����X�];v���s�������<ac}�{).�<Ы��/��E���ʷ�qz*1Cҝ�Ց�Fz��"�reXM�,D��z���s{ϡ��"Sg��`GÎ�C�2[f�M������X��kS���ܕ}Rn�Nr��t\v:�-۬յqn���^Lϻ��AtUl&�W8ux��?����݊pj      �   �  x��[[�$)��<�\�Z�`^g���c1�j�b�H�!��#~��i��?N�_�_T�P���2B��!���s�N�!F뿺�9ަ�[�Խ�s�O����"b97QҤ["��*k�%ĖHO*RO]
���٘��e��y��gcK�l��3k8�e6��\�+O��2S��U�P�"3�`�jӷ�v�1l�T�3g ������@s�u����T�}ɁH6��A�E�a*�B��Y�8�lI�gǍ���� f��g�3?�=�N�&a��1�vLm�2c�b��̈���T�҆�H� �J�aK����0LE�drH��0��h���Wô��X�~�̰%�r�βb���
-��F���P�ʚ1Z��3s����r̴
�v���S���wjֽ�R��PVL���[�nw2�*w�U�ϧ��bKd��F��Y��W.��T�ѕ�YޞN@g�z<���O'��=��P�^ :���	������n$w�<����w �2j����΢�x`6�*t8�Q#f����
�	��I�x�`6��34
j������6�\�(�A�Q��AsIгU�@�h 5�5bE��]fO�z��^@ӹ����tnh44������8�`:�M��I�>��ΦoV$�(�IcR^���r������5�ev�9�������OB����>Hܪm�[uc��ت���[��Z�Jӯ���˴�xzz0M��/N5����l�e$��Ӕ��Ww_��x�r�d��S�gלW���h�Z@�9��0%V��1��N߄٘�X�ŵW�'�[2#$��^d���*K�SWO��c���Ctx�1Y�8$u5Dcl�����#��{�q�4�K�����d��c������8�l�u��]߿�K1��X�,�Y�-�zA~�4���@��'~�cL�a!����녔;��6���U��6�2ǀ}:�>U	s�Ԡ�V鍊|lm��Π��5pN5琝n�He�CL�a#6[�N���!�ׂ��{k�c?,hn�^��gDb�[��*��X�$*�I�-l"�h�#��r�"��z7ӌ���yx��ΪSf��e��gG�6z��
%�Qf����	�`F{M��K'�`$2�"`B݈��L���v��4��6F~F{����\Q/��8��6�h6T�`為e蹠^@)~F)~��#π�a������Xh6؏2���v2 �tS=�ͩ���a��̠l�G^��L�{n�����TI�OS�����GS$��)Ŵs�QCݿ�3L��a�c<Q���a+��<�v�aj�R!�`�6L]�P��5(�_��ؾg{�X��d�ٸF�U��,��)x7�c׿�o&�c����=4J�]a�"�ַr�����S��S�\�lL��Αws!ǘj�`�t8]J�C���+�����Ӄ=cZ1�ӻ��=��(�������?���      �   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
c      �   �   x���1�@��7�i��ݍ��ĕ��D���/�#1��}/iN}�fg�mzvu;�#�,��8Vr*!˅����	�g�6�W���n��zo�7�����-�1�0Y:%�6��F^��q�܈��4T
e�2���U��o�/>;      �   *  x�}�]����˫����E����1)a�e)�F��T-@H\3}r��3��g�{�?i\�\�|�����)�r;f����tI�p�ǔO9�%_g�p���?�E.�P���xhW�P���#�Y�y2$��9����L�d�1'�*� *�<?%yS�R"�� �ϻ7�k	�A串��N	� H�s�N��d}���R��Xœ*�hq�Y�L�a2�N�vaz�P� �º���b��[����E�3� ��� H�K�"�� 2!*֞*�(dB0	ٻ&� )^�W&����N�2$�DSb>Tщ�I�� H��IGe2s�2)=&	�:�H�G2U��
�Dv�� 2%��D��+H6s�A�Q��|������&�h�5&VM��ޅ��x���\�Z�Z��V*�A��qT��]�A�<��U8�Ad:*v��乚�<��C��i2��0UNT%���n���y�
��� Y�A+�� &���$���TYF�y�O�ʻ�A��^3�� JL��� Z<ϵ$�� :�!tuMA2
&ᄀ�duab��d�H6�&� �%&�`�[i-1��2�J�D��� %*�KLA���qVBe����X>X�'���v{c1��k]�kK��d��g��[�c�L�&nDqku�|<���\M��>��w��T|<���\M9^�UtD�G^��(�o�2�I���򑺏��P4���2���vɖA�����oN��{�-�2�/�[Qݩ�&rFm����z� �;��4��n� %B�n�?9a¥:��#���4�2�D �0D&>�?�;d5��v� H��D}��RB�a2tȾ�%��ie� 1OH6�Ce���IxeE��\h�3�H��\���F5Y�k�Ml�s����|w�Q��36s}�J�D�1,ӟ�j"�8[A�a�_$L1��WH�1������X�3�G�'�� 2U���A׋.[+�A����*�Q�x�߯���yd��M�;�e
o�[�bN��-�������v��^����]�A��W����+��%�*��RD!D��� ��%�X�����v�A4�c\��2��	�}I�,�r� X<f|5�2cY��j�e$?
�eU�L�5���d$?J�]�� H~��^���Ll�&���-�<7Dv7�eb;�d$��K��� H���μ�����W�-�`����e=Vj���A�
���x�V�&B�|da��Vd2�3������ћţY<P�#�9���RF��d����ȶ��C?R�b'�W�%����#�W��a��� �k_�?ڣ��zd��U�K�#�(�zar��B"Q��GQ	�����A4B����"|�x�#��y�uo��"����A�x�ϸ̇��g�²L��L�AUx#{d��גG���M5��At�c�7�G1��'��\������#��q)��""��x� r�G
�xd%�C���<�eB|ߑ=2�J�pK}d��T�[�	Ѹ��|����s�ALBL�i�S���O���U����L����M�����Wݲ��A���B��<?���pmdT�j"��2<����M�~�sFd�cZ�~�Q_B����9S�o�?2�A��N��()���g$2s�A�O��T�;�d-��5��^��C<�V��˶�jb���_Up	�3�sM{��G���v����U���I?��2�G������*��<I���#?�v2y�#Dв�����Qz�B|��חHv�B�|�U����Y�C�{�h��o���n�=�މ_¾��1�����o��k5)Q��UVE۫g�!g�l~��>���D�^'v{���^��D[�$�Q��U7#2�|*��G���ow��g"D{��EL���ʀ�\�'���	�Q�J-�3����JVΰ��lTi�����z�
�G�^od_B�.��]��$�E.�!���S���kAc	��F���N�y�)�>��{�W������O-)�k˒3!�ш��������9��?]3�      �   �   x����� ���)����8�.̈́,K���1����k��问�����(Y�������c�t恣I0�f��8C@Ղ�7�(
q6������qEr��jM��&��z��Е`�<��㖄�r{�k��� D��y��"r��D�E�U�c9����i0�@TZe���/�sU�      �   �   x����
� E��W�ʌ�sא>M(�nK骋����@,���l��p���$��P�*�i��J��~<�HC���%L|�����C���<�]�d=՞��љ�S`��i|�),i�oM������כO��c��x����1�]di�h[J�$]*�V+��i��X�Q��v�)��2�f�ΚW�� M^c�      �   p   x�m�K
�0D��)t���;ǘ�BMȧ�����,+	�y�7ǟ(z�j��5 �A�Vޡ�'M[a�8���*\y	1����l{ `8�m5��N������>_p������3�N'      �   v   x�m�;�@D��S�F�@H�Vi@KB�?Aۤ��4c[���Y�fs�,EN�*h�Ӵ����yG��yZ��In�z�V�&~uh�ӐZ�F}��W��
M����{B8 U$�      �      x������ � �      �      x������ � �      �   �  x�E�I�6��a��nj�K��U��-��f����>��9~����~���Yk6������5�=���lf\f\:�����sr�vN�5aׄ]vM�5�/�?���6?��5���ޜq��a�G�N�N��Utrv�tw��'���{��g���q���l3�oq��&☈c���D�3����>g�=�n�M��S���~f�3C��L�g�=���s���ej��ͷl��/s��&���7��,7#��2�_'��λ�H�޹g:�@�����B�iZ�$�����|�Ŵ-�m1q�I[��bږ���-�om��x&o1{�;_L�bӸ�����CE�.�p1�� ��\L�b�NQ{�셴�^�z!�u��ץ��B�U/d�P�B)�,��v��,��(��P�B2�,D���딅�l~�pe!�y�>;��8�^7���H��t8�����������'AUAUAUAU�Y�mE_�XPU�S� = UUU==�{�
�
�
�
�
���ÈBUAUAUAOAO�~QUPU��(TTTTT"h+h+h+h+�*�H����_��b6uI�5Ye���l��=����������q��<�,�;�x���<��ԧ�q�q�':�����pO{��z��2�e��d��n��&�Mv��6�m��,�Yn����_����1�c��ԇ��3<o�gx��x��3����rwu���Nw��۝Y�Y�Y�YY~߃:By
�)�P��jB�
E*T�P�B�
�*T�P�B�
�*T�P�B�
+T�P�B�
E+V�X�b݊��w�Z�w{�pw�����̵̵̵�a�v�c����u�����F��x��F{�~�����7��A,��7Xf�����	�ќ�_���S?�z4!���/��\K/�Z�%��j����+-VZ��Xi#�C-�Z�j1�b���*.�/W%Y	T�h1Qk����q{�j��^�Z��:�ֱvTuTuT�6�c��E��1K���,5K�R��,.�]��,%K\�����Y�Yt����=�H-`����e)ܥp�p�p�"������w��K��"0Eb���)BS���M��"8Er���)�S���O��"@E��*BT���Q��"HE��(Y*�T���S��"PE��H�*BU���U��"XE��h�*�U���W��"`E�+BV���Y��"\E��x�*V$��T��bA�TQ*�T��HS�"OE��D�*2U�������aq9,.��尸V�êrXU�a9��/K�l��"�Ef���-b[�h��"�E�0i,�X�d��"�E&�P�(�Q����S�@�W7�q.���w�4	Fr�X$	E2�H$	D�8$	C��($		Br�$	A2�$	@��#�?���#�>r��#�=2��#�<�#�;���}v�d~Of��#�H:���#�H9B��#�H8�|#�H7��Rb%��XG,#V��5�b��X?,V�����a�pX7,V��5Ò��b�N ���d��O{��]md�Qট�<�}�s��ho����6J�(m��}�"�1������m�����:��?I���bS�?�x"�DΉ��rMĘ�1d"�DL��A%�JD��*?_c%l����z_mpW���ج��ج��ب߾�!�UA)��[ȭ��ߖ(�ME���ڬ.���Z����?Ce<j�juZ����Wd��`��`��`��`��`�z�w_�w_�w_���<-`��;��a��wH��7A��>���5�(��P
� )<Rp���R�K�/u���R�K�/5����r���(�ƴ�V(�{i�K�]���r|s���]l���5�k��!\C��p�l�f�4ۥ�.�vi�KOPz�B����OSu�������(�/p_�����p{��B�E�E�E���K��>:��e�+*O��w��r�%��qM��;.w\����2`�[��n�f�^�V�N�F�>�6�.�&�؟�\,�X^��by����+�W,�X^��byŰ�n�[��%�T�R�e�T%"QF�|�G�zjwۣ��)vH�E�=Rl�b�ۤ�'�F)���˺/�p%�JD��*S�@+xUr�/$I�{��@��������9ғo!|�[�B�·���-\��5����h�ѝ�=G�:Zt��h�ѥ�MG��F=;��7ܧ)a�����؟��|>����C      �   �   x���A
� ���x�\�23	��P&�m\�#x��.
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po      �      x������ � �      �      x������ � �      �      x������ � �            x������ � �      �   �  x����J�PƯ�<E^ 2�4ɹ]�(Z�"���R!�
��cmU�Hc�@n�_�3�7s�</��)����p���s�p{���K���`LQRēZ�V��l�.��r�]|[]W�n�i�D*��$��z�F�����2���u'�Ē��"�����WLכܮ�����G[�<
�%��8��&\�s�f���������'�`
Bo���m���t���Ƚ�c_��(�9�=׆B��9Y�߀RRUP��Jf����m)���9���|o%�z��!6C��C���j���5L���K���	�D�zO�}�`��b��O�Yw�S�,���m���8�a~ֱ:�T�H����D���2H�O��7B_���"G��"�&}�T,�I$���u�{���}�ft_��Q��	�k7��ōE �׷~��.��z5-�8�V��2�"3��_��7����u��A&Lj7�_m�' ��/Q�      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   c   x�34���tQ0Tpt��4��20 "NC�����X��H��P(mhD�ĸ��f)����0adlej�f����������1�Y@d����� mf�      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      �   @   x�3�v�twt��sWv
��s�44��!##c]#]#C3++C�\1z\\\ �Ej      �   ~  x�m�Mn�0F��Sp�T���T(�$�
 u������ԟdY�Ï����47-1m�I��v��|b�X����t�����4ˀL�@c�yi'd��L�H�\_r�$�9+ce�8ù�G��
2ј�snؤK��0t����$�!��w=��A(��rt��n�%'{ �ӈ�-�d����>�s#qv���Vѣ�!�8�D	�D?P�����Ou�$RsKjN�8=�o$y�Dbi�~�N�?n�g��5��
�IWI�@L$�׺N�tY����0S�y�[;t�,�o����)��.Z z��r9��~n
�6|c�E�v�����Tc�jHy�S��ݔؖ�'$���
�ye#8gL�F�7�_�j~ҍ)������e[�Ö��R�A�t      �   �  x���˒���Ǭ�����TqwtP@Q��`�	(""�ޞ���
v'vw�n��L����?� �H��n��	/�4�����G����_��=�����屹���;�X����1 k揅 �s�ګ�i����ݾq8Հ��moPk�!K1$�2��؀��ǀ�����7p���o`I  $@����U9���8Y��.|{Oc �n˫|	~^BK?[��̼(��h35U� �NC��D�N�=��Ed`��[�(���h���Ow�#�Ft�'E2ߟc�W���y����|@��6jm���� yXăq�[���<�~���b��5�UA~2d*POo�5�ڌ p�����Ͳ/�$
h��b�/.;)tG^j�䘙�4�%߹�MR��w.H����1U6�'	 �@�]%�"�\V~.8E3���Wr�9�������V0��ӏ�t|�_��D���}'�(� �1�	��
�P���D�v�xp�����V�lz����w;;��ĥ�����CHNM�l]���B� o@�Y�?�1޵�< �j�yJ�Ф,�,�C_��/;�0�hl����8���fۙn-��?���{A��y(ؾ�����a��h$
�	�M��+D�� �]%S�J$<J��JyA�
��^_��R�v�`�f���� s�\:�z��k���F��w&�BL?��`�P�@�<�H *H7_I�r�pw�6c4Ŋ���7.�.��s�:ɈM-Ld%�5����A����> �L)���G��/�n��I1E�f%��*ާ��C��:�[� ��1�,f���<�r2S�9r�,Ύ�i6Q���8�m km�u�[/$ ���=�?�E��b�~�3VU��-�<���w%����>�à�uW�����,7�Dԉ�QTwgZ�V~��A�Mᵶ�JQצ7��T�b�f�������*��)_h,E���Y��Վ15���s_��䐋��|�����Ǳ��ԨiOL�"jm��b�U0�WJ0q��bN���*j��#D���D�ζ,�m�����1wd��YZ��*��\�$'���d����w[���)��Hl\�ɂj�����U5�R�"�Q�0�U|X���s�j9����~afۘ'���F�H��Z����E#P'����-N�n/����QG������}�F�����츼o�B{�ޮ��R���bBJ���Z +�����f#�}���I�,�,�k�7]�t-�6�h��8얍泫�km�Lx@��~��$�M|����ڤ�$~�xY3&�(�$�+D7G	�f'
�-3o�� �M����S��hI�L�!Y,�B�q��&S��!�F��������4�Wj�0��W�\u����n�uaR�X�rR<�|܏�q�������Nwy�7��nof"!5A"�����
����P��y��hJ5J�/�Q%Ҥ�)��a�o�?�c��e�\�Ʀ�n��,�_H��������֥n�cۀ����Z��ԁ%0��ȣg1������X�e�p������2�'�I�ɒ����VF�S|G�F�x�-P(�ȯc��VM>���	%�m3Lߧ>4ǒ�`=�%�d�JN�ƺ6�@&sA�v�qg�I��xd��&�ܞ8�Τn���>Ȧo�? ��	�b{-��Ԁ���O,sy���M����2w�$:䊞��b��PN61u�!q����a]T��(9�;Z�S]�m�u����r��o�)��U���ʭ.�PwWɔ1B�)ә�Ә�rKSm�N��H��"\����K�Q8���iD�P3�h������b*���a�0�����#�u��T�h�ۭC����+^�-]�<�����tI�2;Y+\ �.��X"NuM�&��JY�v�?�wT���L�TtHQo�d�]�V����r煣�q�����w�Eq\�����i�]3)4�^���ݷ=����m� �&�.Uy��8���O�ϟ?���      �   #  x���An�0E��O��l��Yz�s�DSM�E�Y=��3ї�L�v�]Ʀ�r�c��~V�.vU<�Lu�0����`��i��$O��o��L�z�2��$]��1�Xӭ�t�0&IGzc�X�]o�0��tK1�Jҽ��Hz�?7x1D#陲�>��9-O�Ď�b��%g���:��ĥ{�cA\zm�i�b�ĥם�a�~d{�؋a..���v>sqY�����a..��,�������T�lZ�=��0o�D}SM)���m׶Y��2Ì[��Ԁ�9��������      �      x������ � �      �   R  x�u�ˍ�0�di ��Gb[A��cig� 6	�4�Ȃ��D�H`��x�|~{��� ���q��`�������S⊡8��=����#XbP�P��^.?*�����rO�b�˙���cЊ���=�Ce��zB_��0��|�ތ�Cp�=�qUU���,�:���������an���Y\C]�}^4��w2���E9�Ww�6������y2��z�ՌG�0K�}^4��:��a�v�y�u���0K����y���0K���'�� ~��Y�U�/�o�:��Y�%��Ǌa�vi�>��-�V���n�|�|�����,���e�k� ��/__?��;1R      �      x������ � �      �      x������ � �      �     x��ػ��P��Z~
���}=�taBB�!��6O�y"i���d�],�bs��g0�lI:Y^�v&&���ޏڽ��8�X��j:��j/�.2�ǥ{���}�.��y���3c=�zYNl��Q\���ɴ3��6F����������__WĀq NDH��D�iDd 2��HD& Q�)�@TмV�_."zT��s�k%����R}YA�Z�~��N{��{�t_V�V�/+(_+������
��J�U�оU�/+h��7�+�xPl�8*�깂�͘
�7g*h߂��}K����Ք<U��m`*h�F���m"*��]�
��]�ѯ�-��9�l��
�wc*hߝ��}���=�
���TоL���TоOD%�~SA���}}^���qw���!�A٭�+h?����p���#j��*O�,�G2������
����$�La*�2����tTt^ovOW�T��TPe:SA�LUf2T����9���sd*h?'���~��^b��&��sȼ>������r����t}     