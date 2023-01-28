PGDMP         8                 {            smd %   12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    26933    smd    DATABASE     k   CREATE DATABASE smd WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE smd;
                postgres    false                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            �           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
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
       public          postgres    false    6    202            �           0    0    branch_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.branch_id_seq OWNED BY public.branch.id;
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
       public          postgres    false    204    6            �           0    0    branch_room_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.branch_room_id_seq OWNED BY public.branch_room.id;
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
       public          postgres    false    6    293            �           0    0    branch_shift_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.branch_shift_id_seq OWNED BY public.branch_shift.id;
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
       public          postgres    false    6    305            �           0    0    calendar_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.calendar_id_seq OWNED BY public.calendar.id;
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
       public          postgres    false    6    206            �           0    0    company_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.company_id_seq OWNED BY public.company.id;
          public          postgres    false    207            �            1259    17942 	   customers    TABLE       CREATE TABLE public.customers (
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
    visit_day character varying,
    visit_week character varying,
    ref_id character varying,
    external_code character varying
);
    DROP TABLE public.customers;
       public         heap    postgres    false    6            �            1259    17950    customers_id_seq    SEQUENCE     y   CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.customers_id_seq;
       public          postgres    false    208    6            �           0    0    customers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;
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
       public          postgres    false    303    6            �           0    0    customers_registration_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.customers_registration_id_seq OWNED BY public.customers_registration.id;
          public          postgres    false    302            �            1259    17952    departments    TABLE     �   CREATE TABLE public.departments (
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
       public          postgres    false    210    6            �           0    0    department_id_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.department_id_seq OWNED BY public.departments.id;
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
       public          postgres    false    212    6            �           0    0    failed_jobs_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;
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
       public          postgres    false    215    6            �           0    0    invoice_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.invoice_master_id_seq OWNED BY public.invoice_master.id;
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
       public          postgres    false    6    217            �           0    0    job_title_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.job_title_id_seq OWNED BY public.job_title.id;
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
       public          postgres    false    6    219            �           0    0    migrations_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;
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
    discount numeric(18,0) DEFAULT 0,
    seq character varying DEFAULT 0 NOT NULL,
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
       public         heap    postgres    false    6            �            1259    18036    order_master    TABLE       CREATE TABLE public.order_master (
    id bigint NOT NULL,
    order_no character varying NOT NULL,
    dated date DEFAULT (now())::date NOT NULL,
    customers_id integer NOT NULL,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    total numeric(18,0) DEFAULT 0 NOT NULL,
    tax numeric(18,0) DEFAULT 0,
    total_payment numeric(18,0) DEFAULT 0,
    total_discount numeric(18,0) DEFAULT 0,
    remark character varying,
    payment_type character varying,
    payment_nominal numeric(18,0) DEFAULT 0,
    voucher_code character varying,
    printed_at timestamp without time zone,
    updated_at timestamp without time zone,
    updated_by integer,
    scheduled_at timestamp without time zone DEFAULT now(),
    branch_room_id integer,
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
       public          postgres    false    6    224            �           0    0    order_master_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.order_master_id_seq OWNED BY public.order_master.id;
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
       public          postgres    false    228    6            �           0    0    period_price_sell_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.period_price_sell_id_seq OWNED BY public.period_price_sell.id;
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
       public          postgres    false    6    231            �           0    0    permissions_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;
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
       public          postgres    false    233    6            �           0    0    personal_access_tokens_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;
          public          postgres    false    234            �            1259    18099    point_conversion    TABLE        CREATE TABLE public.point_conversion (
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
       public          postgres    false    236    6            �           0    0    posts_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;
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
       public          postgres    false    238    6            �           0    0    price_adjustment_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.price_adjustment_id_seq OWNED BY public.price_adjustment.id;
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
       public          postgres    false    6    240            �           0    0    product_brand_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.product_brand_id_seq OWNED BY public.product_brand.id;
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
       public          postgres    false    242    6            �           0    0    product_category_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;
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
       public         heap    postgres    false    6            �           0    0    COLUMN product_sku.type_id    COMMENT     G   COMMENT ON COLUMN public.product_sku.type_id IS '''Product/Service''';
          public          postgres    false    250            �            1259    18176    product_sku_id_seq    SEQUENCE     {   CREATE SEQUENCE public.product_sku_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.product_sku_id_seq;
       public          postgres    false    6    250            �           0    0    product_sku_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.product_sku_id_seq OWNED BY public.product_sku.id;
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
       public          postgres    false    253    6            �           0    0    product_stock_detail_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.product_stock_detail_id_seq OWNED BY public.product_stock_detail.id;
          public          postgres    false    254            �            1259    18191    product_type    TABLE     �   CREATE TABLE public.product_type (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
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
       public          postgres    false    6    255            �           0    0    product_type_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.product_type_id_seq OWNED BY public.product_type.id;
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
       public          postgres    false    6    258            �           0    0    product_uom_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.product_uom_id_seq OWNED BY public.uom.id;
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
       public          postgres    false    261    6            �           0    0    purchase_master_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.purchase_master_id_seq OWNED BY public.purchase_master.id;
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
       public          postgres    false    264    6            �           0    0    receive_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;
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
       public          postgres    false    6    267            �           0    0    return_sell_master_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;
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
       public          postgres    false    270    6            �           0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
          public          postgres    false    271            )           1259    18736    sales    TABLE     �  CREATE TABLE public.sales (
    id bigint NOT NULL,
    name character varying,
    username character varying,
    password character varying,
    address character varying,
    branch_id integer,
    active smallint DEFAULT 1 NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
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
       public          postgres    false    297    6            �           0    0    sales_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;
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
       public          postgres    false    301    6            �           0    0    sales_trip_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;
          public          postgres    false    300            *           1259    18748    sales_trip_id_seq    SEQUENCE     z   CREATE SEQUENCE public.sales_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.sales_trip_id_seq;
       public          postgres    false    6    299            �           0    0    sales_trip_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;
          public          postgres    false    298            3           1259    27167    sales_visit    TABLE       CREATE TABLE public.sales_visit (
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
       public         heap    postgres    false    6            2           1259    27165    sales_visit_id_seq    SEQUENCE     {   CREATE SEQUENCE public.sales_visit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.sales_visit_id_seq;
       public          postgres    false    307    6            �           0    0    sales_visit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;
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
       public         heap    postgres    false    6            �           0    0 &   COLUMN setting_document_counter.period    COMMENT     U   COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';
          public          postgres    false    272                       1259    18330    setting_document_counter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.setting_document_counter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.setting_document_counter_id_seq;
       public          postgres    false    272    6            �           0    0    setting_document_counter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;
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
       public          postgres    false    275    6            �           0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
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
       public          postgres    false    6    278            �           0    0    suppliers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;
          public          postgres    false    279            &           1259    18725    sv_login_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sv_login_session_id_seq;
       public          postgres    false    295    6            �           0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
          public          postgres    false    294                       1259    18363    users    TABLE     �  CREATE TABLE public.users (
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
       public          postgres    false    282    6            �           0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
          public          postgres    false    283                       1259    18384    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    280    6            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
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
       public          postgres    false    6    285            �           0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
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
       public          postgres    false    6    287            �           0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
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
    remark character varying NOT NULL
);
    DROP TABLE public.voucher;
       public         heap    postgres    false    6            #           1259    18421    voucher_id_seq    SEQUENCE     w   CREATE SEQUENCE public.voucher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.voucher_id_seq;
       public          postgres    false    290    6                        0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
          public          postgres    false    291            i           2604    18423 	   branch id    DEFAULT     f   ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);
 8   ALTER TABLE public.branch ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    202            l           2604    18424    branch_room id    DEFAULT     p   ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);
 =   ALTER TABLE public.branch_room ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    205    204            %           2604    18723    branch_shift id    DEFAULT     r   ALTER TABLE ONLY public.branch_shift ALTER COLUMN id SET DEFAULT nextval('public.branch_shift_id_seq'::regclass);
 >   ALTER TABLE public.branch_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    293    292    293            8           2604    26922    calendar id    DEFAULT     j   ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);
 :   ALTER TABLE public.calendar ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    305    304    305            n           2604    18425 
   company id    DEFAULT     h   ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);
 9   ALTER TABLE public.company ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    207    206            p           2604    18426    customers id    DEFAULT     l   ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);
 ;   ALTER TABLE public.customers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    208            4           2604    18777    customers_registration id    DEFAULT     �   ALTER TABLE ONLY public.customers_registration ALTER COLUMN id SET DEFAULT nextval('public.customers_registration_id_seq'::regclass);
 H   ALTER TABLE public.customers_registration ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    303    302    303            s           2604    18427    departments id    DEFAULT     o   ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);
 =   ALTER TABLE public.departments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    210            v           2604    18428    failed_jobs id    DEFAULT     p   ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);
 =   ALTER TABLE public.failed_jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    212                       2604    18429    invoice_master id    DEFAULT     v   ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);
 @   ALTER TABLE public.invoice_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215            �           2604    18430    job_title id    DEFAULT     l   ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);
 ;   ALTER TABLE public.job_title ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217            '           2604    18730    login_session id    DEFAULT     w   ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);
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
       public          postgres    false    234    233            �           2604    18436    posts id    DEFAULT     d   ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);
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
       public          postgres    false    262    261            �           2604    18444    receive_master id    DEFAULT     v   ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);
 @   ALTER TABLE public.receive_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    265    264            �           2604    18445    return_sell_master id    DEFAULT     ~   ALTER TABLE ONLY public.return_sell_master ALTER COLUMN id SET DEFAULT nextval('public.return_sell_master_id_seq'::regclass);
 D   ALTER TABLE public.return_sell_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    268    267            	           2604    18446    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    271    270            )           2604    18739    sales id    DEFAULT     d   ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);
 7   ALTER TABLE public.sales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    297    296    297            ,           2604    18753    sales_trip id    DEFAULT     n   ALTER TABLE ONLY public.sales_trip ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_id_seq'::regclass);
 <   ALTER TABLE public.sales_trip ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    299    298    299            2           2604    18765    sales_trip_detail id    DEFAULT     |   ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);
 C   ALTER TABLE public.sales_trip_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    300    301    301            9           2604    27170    sales_visit id    DEFAULT     p   ALTER TABLE ONLY public.sales_visit ALTER COLUMN id SET DEFAULT nextval('public.sales_visit_id_seq'::regclass);
 =   ALTER TABLE public.sales_visit ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    307    306    307            
           2604    18447    setting_document_counter id    DEFAULT     �   ALTER TABLE ONLY public.setting_document_counter ALTER COLUMN id SET DEFAULT nextval('public.setting_document_counter_id_seq'::regclass);
 J   ALTER TABLE public.setting_document_counter ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    273    272                       2604    18448    shift id    DEFAULT     d   ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);
 7   ALTER TABLE public.shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    277    275                       2604    18449    suppliers id    DEFAULT     l   ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);
 ;   ALTER TABLE public.suppliers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    279    278            �           2604    18450    uom id    DEFAULT     h   ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);
 5   ALTER TABLE public.uom ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    259    258                       2604    18451    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    284    280                       2604    18452    users_experience id    DEFAULT     z   ALTER TABLE ONLY public.users_experience ALTER COLUMN id SET DEFAULT nextval('public.users_experience_id_seq'::regclass);
 B   ALTER TABLE public.users_experience ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    283    282                       2604    18453    users_mutation id    DEFAULT     v   ALTER TABLE ONLY public.users_mutation ALTER COLUMN id SET DEFAULT nextval('public.users_mutation_id_seq'::regclass);
 @   ALTER TABLE public.users_mutation ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    286    285                       2604    18454    users_shift id    DEFAULT     p   ALTER TABLE ONLY public.users_shift ALTER COLUMN id SET DEFAULT nextval('public.users_shift_id_seq'::regclass);
 =   ALTER TABLE public.users_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    288    287            !           2604    18455 
   voucher id    DEFAULT     h   ALTER TABLE ONLY public.voucher ALTER COLUMN id SET DEFAULT nextval('public.voucher_id_seq'::regclass);
 9   ALTER TABLE public.voucher ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    291    290            e          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    202   �*      g          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    204   �+      �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   +,      �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   r,      i          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    206   IB      k          0    17942 	   customers 
   TABLE DATA           k  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_day, visit_week, ref_id, external_code) FROM stdin;
    public          postgres    false    208   �B      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    303    t      m          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    210   ��      o          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    212   ?�      q          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase) FROM stdin;
    public          postgres    false    214   \�      r          0    17984    invoice_master 
   TABLE DATA           W  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type) FROM stdin;
    public          postgres    false    215   y�      t          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    217   ��      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    295   1�      v          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    219   ��      x          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    221   ��      y          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    222   ��      z          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    223   O�      {          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    224   ��      }          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    226   ��      ~          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    227   ��                0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    228   ��      �          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    230   ��      �          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    231   �      �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    233   �      �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    235          �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    236   U       �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    238   �       �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    240   !      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    242   �!      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    244   �"      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    245   �"      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    246   #      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    247   �(      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   f)      �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    249   �+      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    250   70      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    252   6      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    253   U6      �          0    18191    product_type 
   TABLE DATA           J   COPY public.product_type (id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    255   r6      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    257   �6      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    260   79      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    261   q:      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    263   �;      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    264   <      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    266   �<      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    267   �<      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    269   �<      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    270   �B      �          0    18736    sales 
   TABLE DATA           �   COPY public.sales (id, name, username, password, address, branch_id, active, updated_by, updated_at, created_by, created_at, external_code) FROM stdin;
    public          postgres    false    297   zC      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    299   !F      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    301   ��      �          0    27167    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    307   ��      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    272   v�      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    274   ��      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    275   K�      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   ��      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    278   X�      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    258   ��      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    280   �      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    281   ��      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   �      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    285   n�      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    287   u      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    289   �      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark) FROM stdin;
    public          postgres    false    290   �                 0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 22, true);
          public          postgres    false    203                       0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 13, true);
          public          postgres    false    205                       0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 2, true);
          public          postgres    false    292                       0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    304                       0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    207                       0    0    customers_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.customers_id_seq', 208, true);
          public          postgres    false    209                       0    0    customers_registration_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.customers_registration_id_seq', 188, true);
          public          postgres    false    302                       0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    211            	           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    213            
           0    0    invoice_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.invoice_master_id_seq', 106, true);
          public          postgres    false    216                       0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    218                       0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    220                       0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 261, true);
          public          postgres    false    225                       0    0    period_price_sell_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 884, true);
          public          postgres    false    229                       0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 509, true);
          public          postgres    false    232                       0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    234                       0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    237                       0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    239                       0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 13, true);
          public          postgres    false    241                       0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 22, true);
          public          postgres    false    243                       0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 153, true);
          public          postgres    false    251                       0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 24, true);
          public          postgres    false    254                       0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    256                       0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 26, true);
          public          postgres    false    259                       0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 18, true);
          public          postgres    false    262                       0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 31, true);
          public          postgres    false    265                       0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    268                       0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 12, true);
          public          postgres    false    271                       0    0    sales_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.sales_id_seq', 28, true);
          public          postgres    false    296                       0    0    sales_trip_detail_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 2269, true);
          public          postgres    false    300                       0    0    sales_trip_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.sales_trip_id_seq', 2187, true);
          public          postgres    false    298                        0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 15, true);
          public          postgres    false    306            !           0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 39, true);
          public          postgres    false    273            "           0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 10, true);
          public          postgres    false    277            #           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 4, true);
          public          postgres    false    279            $           0    0    sv_login_session_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 1006, true);
          public          postgres    false    294            %           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    283            &           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 56, true);
          public          postgres    false    284            '           0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 42, true);
          public          postgres    false    286            (           0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    288            )           0    0    voucher_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.voucher_id_seq', 5, true);
          public          postgres    false    291            <           2606    18459    branch branch_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_pk;
       public            postgres    false    202            @           2606    18461    branch_room branch_room_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_pk;
       public            postgres    false    204            >           2606    18463    branch branch_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_un;
       public            postgres    false    202            �           2606    26927    calendar calendar_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.calendar DROP CONSTRAINT calendar_pk;
       public            postgres    false    305            B           2606    18465    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    206            D           2606    18467    customers customers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pk;
       public            postgres    false    208            �           2606    18784 0   customers_registration customers_registration_pk 
   CONSTRAINT     n   ALTER TABLE ONLY public.customers_registration
    ADD CONSTRAINT customers_registration_pk PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.customers_registration DROP CONSTRAINT customers_registration_pk;
       public            postgres    false    303            F           2606    18469    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    212            H           2606    18471 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    212            J           2606    18473     invoice_detail invoice_detail_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_pk;
       public            postgres    false    214    214            L           2606    18475     invoice_master invoice_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_pk;
       public            postgres    false    215            N           2606    18477     invoice_master invoice_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_un;
       public            postgres    false    215            P           2606    18479    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    219            S           2606    18481 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public            postgres    false    221    221    221            V           2606    18483 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public            postgres    false    222    222    222            X           2606    18485    order_detail order_detail_pk 
   CONSTRAINT     l   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_pk;
       public            postgres    false    223    223            Z           2606    18487    order_master order_master_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_pk;
       public            postgres    false    224            \           2606    18489    order_master order_master_un 
   CONSTRAINT     [   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_un;
       public            postgres    false    224            _           2606    18491    period_stock period_stock_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);
 F   ALTER TABLE ONLY public.period_stock DROP CONSTRAINT period_stock_pk;
       public            postgres    false    230    230    230            a           2606    18493    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    231            c           2606    18495 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public            postgres    false    233            e           2606    18497 :   personal_access_tokens personal_access_tokens_token_unique 
   CONSTRAINT     v   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);
 d   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_token_unique;
       public            postgres    false    233            h           2606    18499 $   point_conversion point_conversion_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);
 N   ALTER TABLE ONLY public.point_conversion DROP CONSTRAINT point_conversion_pk;
       public            postgres    false    235            j           2606    18501    posts posts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    236            l           2606    18503 $   price_adjustment price_adjustment_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_pk;
       public            postgres    false    238    238    238            n           2606    18505 $   price_adjustment price_adjustment_un 
   CONSTRAINT     ]   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_un;
       public            postgres    false    238            p           2606    18507 6   product_commision_by_year product_commision_by_year_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_pk;
       public            postgres    false    244    244    244    244            r           2606    18509 (   product_commisions product_commisions_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);
 R   ALTER TABLE ONLY public.product_commisions DROP CONSTRAINT product_commisions_pk;
       public            postgres    false    245    245            t           2606    18511 ,   product_distribution product_distribution_pk 
   CONSTRAINT     }   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_pk;
       public            postgres    false    246    246            v           2606    18513 *   product_ingredients product_ingredients_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pk PRIMARY KEY (product_id, product_id_material);
 T   ALTER TABLE ONLY public.product_ingredients DROP CONSTRAINT product_ingredients_pk;
       public            postgres    false    247    247            x           2606    18515    product_point product_point_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_point DROP CONSTRAINT product_point_pk;
       public            postgres    false    248    248            z           2606    18517    product_price product_price_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_price DROP CONSTRAINT product_price_pk;
       public            postgres    false    249    249            |           2606    18519    product_sku product_sku_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_pk;
       public            postgres    false    250            ~           2606    18521    product_sku product_sku_un 
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
       public            postgres    false    252    252            �           2606    18527    product_uom product_uom_pk 
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
       public            postgres    false    297            �           2606    27177    sales_visit sales_visit_pk 
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
       public            postgres    false    290    290            Q           1259    18584 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public            postgres    false    221    221            T           1259    18585 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public            postgres    false    222    222            ]           1259    18586    password_resets_email_index    INDEX     X   CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);
 /   DROP INDEX public.password_resets_email_index;
       public            postgres    false    226            f           1259    18587 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    233    233            �           2606    18588    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    3388    204    202            �           2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    215    214    3406            �           2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    3502    280    215            �           2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    208    215    3396            �           2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    231    221    3425            �           2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    270    3488    222            �           2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    224    223    3420            �           2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    280    224    3502            �           2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    3396    224    208            �           2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    236    3502    280            �           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    250    3452    244            �           2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    202    244    3388            �           2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    280    3502    244            �           2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    3388    246    202            �           2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    246    250    3452            �           2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    257    250    3452            �           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    261    3470    260            �           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    280    3502    261            �           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    264    3476    263            �           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    264    3502    280            �           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    267    3482    266            �           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    267    3502    280            �           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    267    208    3396            �           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    231    269    3425            �           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    3488    269    270            �           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    280    3502    289            e   -  x�m��n!�ϳO�hf`�]n�5Z�6�zh�fM�j��з��6� ����&�J�w��v���=�N������
�&0[#�D){8�!	*M>0�����԰_e�`��/�SŢ�IP���T#U����H��ä�Aƶkn�g��4�JCQ���!�7o?�M����E��jwv���[���P��z̗0��K{
e��	�I�2��tGw:��KW��PčMz'aqhZ߆R�<�\�4ȐJz�B�u��󁮪xk�t;-ph�6�y�G���Yt���o�?%��H2��}?˲o,@��      g   M   x�3�4��T�Up*�K�N�S00�4202�50�50T0��21�21�3032�4���2��p��/J-V00"�!F��� �J�      �   7   x�3�4�?N###]C#]cK+CC+C�\F@FX%���1������� >��      �      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      i   �   x�U�A�  ��
? Ywa9�^��
cE���iMO=�d2N��[w��^�n����.�?�e_��y��o�ӱ+�z�A@@q��gY�G#C	R%Pu>��g[z�8��%���jh �m���$�^?�����,�      k      x��}YWɖ�s֯����{�щy���Ȑh�54׵��6*,�$Z��q���wDf*3#q�|\$�2v���C�`R&��ǌ���Co�o6���~En�_yB���	�\�Pv�a���S&z�kCY�#�	�L�§3������)�%gˇyZ��	�H���)�f����ʸ�D�S�q�|��w����;����7&h���~��	��!��g�#D��|�u��>oI4�2DXB�)���g��J��ԩ0�ӄqxޏ��r���§=��>n�߾#%w�yZ��!���?O�If�c291=�(�'IB��J;kW�\q�ln�;�� ��JO�����y:�>�L��� W��b@��������b|��ɠ�1�s��h�^dI�s5�9#��J}��.��.�n�MF��ɠ?�O�X���g�p�^����YI�p�4H�pZ[�;8W��������d���6��^�2�?&gϏ���o�y^����U!�ʞ2��Z'[��iSH?���+�q��@>��M��u�eT( �YƄ�j �1�k*�8^�y`�4�x1�e�e2�߮���5԰�:v��)�=˩���HuJU���~���=�����jV裴ʩ7ȩ�@K���*'���k?@+�+ �{�i��8��)=��""�1۠-<�M�����ﬥ`��:�Y���+��%�l>MIz��/�3P����sb@�Ow�M�.
oR�j�S���T?2�Z���M�q�*��z��)��<9�='���%�*�,���5��E^L�0,����K��,$7����jCP�v������l�6�*�����������/�B�$uR�-'3��"G��&Bs���h"��X��ƃ�]o�{��>�v�o,���,o7A�Xb=g@"���-9߯׿��lr�}K�N@�r�~��J	0�uR��@Ԓ��9/>���`�AW,$	�9{�w���/;Y��b���~�hn��u���O('�����z��O?5f��T������o�^�@wɇ�l~��w����|�?�*��u��5�[�P.��1���Oͩ`��M�-����`�$R�$�z���z�?�������~��w--詐=!����r�`�����+��y\m�l�_�o��_�7�_6��n��w���)��ړa�Vu���������l���>"54���ee���<u%�3����i��"*�F��#|�zX>,����0r��8Aň@�`B[V#�tX���d0!��0�%W�X�]��?��;yzF���l{���m���ж�" _�t)��ky�n�n���r�@��5�q����Rk���+؋x�'�&���a�Kg�,Y����c�Ţ�L�����6�D�ِ5��O{A�XxQ[M��ҥ�-���v��~Պ'�t���>�+R���b0-��'oB̈A.%�m р`��lq�i\��
>�´M�	�⼩�4���F�=2�,d�@�]�x �_���] �!���M"l�n��]�ϲN��@�	��:�F�M�D@Y��5.�]�?�n�"�!ѥ�X��� �"�
*� 4�ϜJA[@Ġ��w�m����%�h�W��C�ʋS�P�@�ۚޢf�m�	?(���K�lw�KJ�{]r`%�֥�q�L���M�{´N>0� _��\�� �1��* "�\oΜ�|h�!`C�l6��s2J/��Y6G<��0��%�u���8mc�k���(ӊE��C��M�g�Y	z���+z!�2���:0oPw��5@�����$�����&��������hCB�`�q�0Fq�E�G!� 8��� I��a��.�;B&�B�+��-���d�]�Mz�����'=<�/� ���m��n��	�H���$�^M�k��1:�E)$F[X��	zd�OøBT�A�ߗ� ��=��Z�4�V��x<���R�������� ɽ?WQE�����
�n8�1"|�M~eĩ�=
�ZD)�)o�Cc!�[�M�� �p�[;!߽ua��f����r�؈���z2��w������M:%g�t|>��3�
�"�կ�!�b�+�Eַ�/V�#���xxC�]���:�AA��N���l����A��x1�{���= �`W;v�5w�/ R�fA��
�c��̈` D
�y6�;i�p 8sjm' ��h���o6�1��6�/f:�O=[��4�z ��W���G��P`�Y�Lj��� H�(+c|>۞J�y;�:X��2����AA҆\C�m�D�D*�a��DB���'���Ƌ����d�M�/!YsU'��詹�-�'�-�M6>OП3PRy����ȗ{�����!=� �1�R2A�]�o!�P�C|K_�iC��1d !TJ��,������� �~V�	|�:1��j�"��G��P̍�E����@��!N2=��b�
8�
��s:���n�5��<'��(#Du��)̜8����^�Wp��&���u��'������(�@)-�_p�z"#§�'��%��������
���v	2��%]k�P��;ձn��7�:B~�|.���W�0�����9 ������q
�05��Q����&a$<I)2��v�(��{�/���d6N?���<�VAq� �nʔ��7'�L�e�\��ȿҾ����#<`s��{sZ��@8Ij=A�K�� u^E0�:۠�(�j.�v�YC���{� ��m���N����QJ���ir=#B.&)�f)x�k��'dq}���
��`��q'�kƄ>�K}l���T
6���YF��ħ�()S^�Z�Y^գ`��L�dq�(��1Ӳ��O�e�a�fP2KG�|=��t��E�� ")�PS��N�Y��������Zt$y���-�Lw��n�d�����)︘��i���}`�W�Ϩ�m'�U������p�ja@R�H҇�|ġ���}p_>KILS!��y��o�b�}՞�xQ���\�H�����읶-b�tF��%DT�c��|[��K�ݡ�j�}��΂u�-��EA{�X�e�p!����f���ȏ�vh��%�3.��R�|x�z��O eC�Ԕ
���Ip��?��<�vsG�YWf��x�UZ�	���,:��2k.��)���!<��k���A�F�t����sG�$�tSŭ��/�]'�m�(LnY!�"t�k���lXE��Xȳ=!%���z�ۍ~	o�g��,�TvU�߱p,��e|&�<X�iX<络\���lN��\�0��8�ֈט�j��)-@���o%-� &�LX;��{������4��AM2?�|�n���v�[%/8�[����{su�侖U���+&W!?�<����ѹ�肫f(�_a`�h1��g#��%�BS�d�S��bi!�mx��1�9{���Q��oG�^�SĒ��W�,6ww�������y���߿ y����ݑ���4J6�Sޒ�Є$^nBz����q���]@`��ݏ��B@uE5E:jLU3��+%���wx�C�	�+ޘ�%�[C�X��D��Z�+z)Q/��XB�H/-�]�
���0Ah�Se)Ip���w�B<6��?���H@8�6,&�e�E	��_lz-}��(X'0����K�M��4=/ ��� �q:�p�x��6��̓	ݰ\̗I�(G�b����4=�a�!�]#y�PBAh�L��%@6م"\p��� ӎ�a��>^��v�|1�V��a����f�C��h��W�����P`7�q�	{XȚ��^��$�����n�&�V���|'gg��5�}�;*��f{@��ɇ�f�F�K�y[���LѝG)�,��b6���7{��$�N1�pOD���, +6�*�A%6�0��WW�l����@�X��~G���r꿃�}�>oʷ{���n�[Y��U_����``��R��
�?6�������6o� o��O�� �W��@�E2�m׏���د� C�[�1)���������" ˉ����F��    ��ȋ�򟫧g���3R��<Ae,�����{�J�~Jϳ!�-���a�Y>���n��l۵���3���4��Z���s�C��w�{�J��w{�H���+p�>�)�F���we��mB��%���QR��Nvv�]�tq���_�:���Y�jC�:�$��n=,���˸l���5Ue�+h��Ol��]O����t���ٸ�t����8�=�F���0�71GS���b*�Bΐ�Rq-��$"�+>h��]�@�&�*t=��"B�=g���f>��H����@��f1�BR�@�`1'��_�Q��]�C
b��T`W�h�(o��V#$ְQ
���V���|( a#�ϢT�̻���Y��&x<@/^U�����Q�0��{�8ގߙ.2/E�p� �t�#B�҅����Y-M%� ��ڲ��j���]�6�y��~m���;@�Q�"d��u +�}��r�`�f��4k�hf=�.k:hn$��\~�<��`�u�W%&��E�ׅRhs��/N�V9�l� `5[���dڿ��������Y6��C�M�dr��m#�O��k����C\Ӧ��ćц�x��p�NZ���\ě��=��x���R<Ϯ'���d:�H�6Dً-=')�Q����oE�����\����_6�[���[��=pY8�Q��w�����V�3���m[aKB��³�G�);���	n*�[D�) ;�fm�U�K���}"����J�� �l{�_R̥p�t���s���Z\��:�f�����i�%�ƒY6�x�V�='`��ݔ@+��3
YY+�!��Y9P�!��`�<>!��۪?�$��]oU���#�����n��n�i(w�e	�� �3��BV����F�ܯK:��܋�r耊hmW-w�/j��U4^�[V{녖�Cv9�� r��D;B?��'h����%��� ��Ȝ�W��wԁ��R��� 5,��Z�z��`��u��`���4�#�I��ଂ�zØ	_��-�h���qH� �[_J{�e����jF�R�
>����+�"����.��m���>���Ϟ�CJ	 �x�vS[�<`Vr��!]d�+�XWO����~�}2�x��a�ґc�4�HkQ|�E[��9�'��7�y���� ���{xl�֪W�G,�z#�cmN��O��j�W��5L��n���8"S��A�.�<Z1���V��s�T�Z�Ő���l�x������G:_�p�Tc��_?7���9&&|k��4�����[Φ�Eq<	=������#��6��!Lf�d�J�"�1���<���c$���K�@�����s+:;��!P�.�I���ww�l�^zM
=�x������%jEs����l�@�?���Ez��h���!cJ@�#����6���a� �H{��޲�X3�X��*2�x8�f�U@p�!�
��ݝԈټ��T��Gk��Ev�iB�r�gZ~m�=�ի����s�~ю����q'��NF���ٛ�b
�k��� ���_+udZ�'Uw-��a��}�>5��5�\.p��@)q�/��(4,�HoVb���}x�KZ��Y�#���מ_{Q��k�g^�nƆ���g��x�]CXz��.l����Z�
�ѱ��G��H%CkMp�V����_ �������Br��y.eL�΍Ub��&�$�����]��]nj�B�Mf�gRF���/���w�f�Fo�|�����;�S��ѣM;챁j6�@@�q�z�]����*�����&��X��-!����z<O��?V��^;������-l�h-^���:躞d�N�X��	�H���������ӱd���aż��a�n�����)�a"�f���~�e�F=E`ht�;+i �if���~�+����z�J{,�Paȍ)��Ҥãۂ�RgG���z�ߒt�?�^�l,��iu>�4��
"t���y� ���
 �uWoV�*<1B5���:x��¬\@+�����f5,��J0�`:h��/ߺL�3{�Km�0bo$��d0�Ta�82bL��0TU�iԗ���x�� NDՍ�2ҁ1��5w��f��T���2�XY��ʎC�,�F)~�ס�w[�c�)C��6�����8}0�tv�w�� �����S��
�S�S��Ui<��7g�Y�Z'�8���V{�0J��YJw�ɦ~��'iJ��J�&g�{R�{����oC�o���$c2�~�'�
E}YO�QZ���G����9�݄'���6���&���3���M�?�ߞ��T*���� �A��+��竧g�������q��@Dػ�>7� �s0"���y(�̛���?$5��eL�d�@-�u-RLVw5��O����FL0/�V����9��d�Ӄ�LJ`�����h��R&�l����m�1���y�Q$-T�P��P�t�5es�Ip���`Dջ;��H �G�š�n B(P DAGW� ���&�8Z�l�&��gl)�D1r�)���61ҷ(�4��XǾ�oO�J��ف9{L���{���}x�h|��t6���B��;��͝{��1��5�Z�qo��1 T�6��� ��>�R�D�e:gI۸~��2��-J��l���n X���ipZ�a�O���ӳl��c2K���%7���|���i�k��=%�NV�ovŁ{��q���X�=�j#�E�O� "�F�)��<G�r�q��N��� M����Kk��x�#����<j���U�6\�2��ݚ]��"x�f0������"�"VP�����o�fi}xkyh6�� �*�N٣�j�%?�7������5����t:O?��DW��v�	Ej�'�aC�߭�9��3Ř�
�G�5�s:�N`������t�"���01eCҍo~�׏�y����]4HԑR����Q�Cr���=�nV�b�H��a@�q��ӧ�Rqt4�S��DNB}	Pc:��A8ā����w��n�j�ꇃ���Wx�E�'ޞ^!{��% Ŋv7N�~vt�:t�N��Û���<�cS��� n��(�����l�����h�d1%�2~t�G8	���e:��7�|�c�?��5d0z�4l�>3QO��;&4H��bi�+�����4.Im�u�y>S�$O��36�ݓ��[Tp�d�8�J�,�BҘ�i�Q�P�`���ء_�p@m^�ZN�/�����>�����"�7�Y4�Q�u%�m%l�'�����Ka���0*y�]���}�P,�w��-e�L�B��8x5n˦|���e�0=�O6M2M�����H��b��z��������c�
0v8�'�Ntȟ�U��V��p�
�Uq��E��s8t�N;�А��>�c�x�gs�?O��q��nk�$���G����Y� ,��٘87��X&6�����s�&o�_��C�2#ک)l���{�\��aԟϟ+"8�c|��|M�H��ɋV%��<�9�'�l���/ �^]̭�X�(�$��;�g�h�߾��������	^�4�����<�D,�(�2��;/ҷh� �H�m.}CaN5̚�y�P�����,���yco�{�&+yCƋY�fd%�q@��1����1Qh�kD��	V%�sN��2mc��TS�d�p��=���.�tv��t?��sO�?Lm�RN��7ew=>�������(��-�Pc�')����[�XDG���rs��T�,Q10FFm���1���.V
�dd�v���:���V���k�y񁀑�r�G)s���8����(����P�-۱��>��1�����8�����z��*�����bo&�t��삐�D�y����Q��x�q=�Υ�DH��G�V���b8T�O��?��&�@�� �Mhk��h��u�i�9ȩ��Ho�J��@ O��]�    ���5�a�S3?��q�_��0�:�t�!���M���OC��K@��2_�c�����SG�E�ϛѿ�Y�O>�Cn�*��T~+Ț/۾&j��+�|u2:���T�G�/e6чy�ù��yB���#�lx����$C<�S<qr>����z�I��1��D��_AFZ��ҕ8��� _&�I��j~�/��`��p�ǫJ�tR<�p�0��G�{��x �DJ�0��VA�r�Vz4���,OR<��|�8O�ݑ���1:�Ք&�g��xa��eŰ�r��;p��8O��N��q�� iL?�����a�u���-x(�MCƃ5�δ+��m��*)oºR�0���k��9ւ%aP�9���>�����^���@����js��Ɩ0֣��<�}Xz,<��3�]�����ձN������
z4_�@#K�?�$�b������b-��aEn���h�B}�� �b��N�Ω~�+�KB�����;���d����ȁ�@�� �BQPZIVY����<�"��1��o���>�
�����a)�s�F7�Ő	�l�����]lt�~��h*A�'J��2�m�@����(/Lz)��ei{����nYO�KQ*�ձ�}�"��
�}��Ł���N.^`���0���Dq�,��2�}P�m�B{P<�q\T;���[�O?V�d���X�6ݤ��`���,��/*�u!���PR�X��t3<�:�S�p�Fi������i�}@�*^�gI���ʓ�鼣K�j^��,�sq�2�P�[���ۃ����c��mA�O�������kNn����}�ܒ�����<a�5��J�}[�l�N6!_��`�P.\���oHq H;��j;):��W����j�J��!GX�%JE�����؝����^�Zj\�K��s/���t�@,M>/������ |�A���C��;Yq*Y����{TEd?A�ʈ�x�R��a�9^��k�=�����[竇޷��P�d�1�I����rP�&��8��E8�Т,_{�����{��j�u�ڴ�
Ʒ�to�W���!�mOe-,�� ?��V`g����Z9��8h�j};#��8Î��Zթ�� [>U�4B��j�����]e�c�Ce@]F�(ฏ��[d<�?��x/�� 
��YU��Q���
+�u&J8��/78��; 	U��Ҏ>���T�z,m!�~��H��� ���C?�b�]U�`��ip�o�9*����i�q��K���A�dcv���#r}��Y�%ra�"���ҷ�9�u|x��x�N��4�
���p�GMv��+�>��ۗ��u�V&��SV�omPz��L ؟�L_�T��S�B ΍�Bj�TbGf'Y�c�"S�=��#����Il[�E4^d?��ʿwrX$��oN$���XK�7�������r���U��
s��M�!˾��4��q���[�X%�aޮ8A�}�DQ.�ݯ����2,re�R�=��@���>C���t�3���|��4'��}���H��<�p�B��;I��c�~N��/N]��!��A>�O���1�4������;�Y�/��=+IyMN�.6����W'Z��ߢ ���
��}=�I���ZT{�i�S�K�#o��9Er�гT�d�2��:����~`k�3�@(1�~�������{�k���\�V�ck�
�"���쑟Ԧ��hU���arE�l�pZ�;�hϗ?W�/7��Ix�f�x��mS~���m�\
na&�{���Cg�8
$X�B̤�u��ޮ[A�s,B$g��]�eՉ ��3���0�𹎆�۶�$9�:-�$ �HU��vNC�#����깛ZH�J��� +f��� � �Cr6����O�8�xYD#.�����A��rQ� (�e��`�ױ����90�q2��'6ϳҀ��I��y,�wL;M�w��r»?�R�|&�s�d�n��q�=�
9����^�YXk�,�~�J��sND�1�z҂mo��8��l�Ѣ��P�x#A�P�f[ٽ�!��mnsN;��'�f	9��I������-�y��v��a����p^�)��ą�g������"3�g$���c-�-�c/a.����C���_Ka1�Ll���.�����M1�!(���^&Zxц%���<:r^-Ls?���?A�\8����u�����P�<���p�&���(������������uZ�)hg\q-�{�4 ��h�􇸐)����=��	LP�3\�Z�����A�r���"Q������p�C�Ӿ�qMh(�2�p���^�Q�k�M�Zg���3�+����br�&��/�������%@?����3��O���*��;��КS���бTfki�z渼}�h�o^�Y-؂ބ��S��|o��f8�W�ū�� l�W�x��6�����Y8�̅c�	;�`�u.{�t��l��5�t7���rj**M�6"��8��'Cr�]�rZ�7�i��J�L�0�#�Ó�o�5��:���F�3p�J���-L.�_�5�@���)��C�!��e��A�������=W6
��Y�n�WY��`X\�l��j	��`1!�liA�hq&�����ܽ �x�Y!�����ן��j\�Y�c	&�sX�9ϙ� (P�]? ��a��� �É<^z����n �.���Ye�w�?�_���4<�h`����E��}�G�1�X@�L8����*�֭������#/����w��>+Z�e��v�կ���HWx^H��L��8?����B^/4����:��L�I8�W��L������o2�*���,fiQ̒��<�����ö.��R`Lo{���_���9���ʰ���	�ͪdv�g8��_ ����E��]�'X�����U�	U�^�H�m�Bc5�:�c�2I~�5p���GH�-��S_�V�[W!T%��*���N�P\��)	�|*�����˷m��+A��:l�lk[��7���.��^��&}��������N���'��!pl�Q1��M`��׈��!���1�HD\�KA#�v��J�i��-��'C&�#ut���C�mK�ݺ%��ז`�Y�;���pb���O4���$�|u�X��=L��B�B�[��Xl�N ��,؇J-��u��p�K�#<�?��}�⤿�ZX.m�Z����oYK�o��Y<�����x�Gk��M\����?N>OJ��oE��	m����7���x�[L�;��p�pw��0 �3X��2��ix#N�S�;�AZ�^�XC�6.�W�[�y��*��=ַ N  A�<��c�/X��8����V�E�hK;��V�@�[l�Y�D�ŕ���9;���(��&9Ń߶���
о=�O�8�"�?��%��:qʜ*��+	M�����+�%-d�J��۴��ax��c~O���OR�	�c�[ADI�B�����K��(פ�ц��ܦ&��Hև\��j�����3�����K ��c�q�B����o�Q�a�M�AW����3�k�%�������g��"=��a�`�o��
��Q��r< S��G��,�0��;qE���pw-�}�`AŌ�̄85�l���8ү�E_��l��
[�s��o��9_fa)��$>�r�ar��nH'�~�!x7����䨠���~f�?�P��a4��\�:�?����Ir�tD��В����iz�S����p�-��/ ��ϛ�<W�h�-���$�UjO�>�"�sa�K��b8��)=���r1/�į�h ��Ō�Xj�E���Աv������#��ڍ��*8R*�K��uc*>0c-�QL|5r�}���?�)3��b&Y���ü��"����x2�٠�IINq��sN�=�1��#�
F�x%X`����-��p�r2�+���bG��W*�q�Q����/�ԅ�7��qò5l��;F�ٴK4�/�Rk�F��߼�#LVEn��L�    U�j���0��s͝�T��z��&#U��a�ȁs8��1�Zٹt���{�)�I��M��%��V2��D���K��_��c7����|Q���&����U3IU0 \q�^Zu!&��^N�x���#���K�ȏ���v�=3|�#J�
4�b���3	��cwJ��7Eh!��Hcq D��V K:�L����:߬>����n�НJ��k@�XՈ�aM�_�y��=Z�?U����p���e؏߽�>��������?wK4      �      x��}msɒ��>��"��ݍcs�ޫ��,,!hA_OL�F�bd,Z$v����'��y���x,�e:�*+��ײYQ0-rή���;v���g�GV�{;Y>����C9g��	볛��G�e�~�\��9�{��3��q�rR��g��3�����r�}��M^^g�6�|�|}�7��.�3�E�jť��{�R�k�U]L_^��/��Œ^��v�u8y��X>���/" ���B��??��eϠ�a1g��Y��D���6������t���zY�/�|���r-�r�+��e��%}&AQ������r�2}�ja�t�8�F
��O��^?,/�e�e��|��c����R���5��/���#�t����g�'-k�46�Qg@{��Ӂͭ�E܁�թ�n���e��
����՗r�x�V_&��j��X�X0!�>������3nZ�.�&�/�w�5�ÒI��y}#��čP�e�˅q�Sq�ה�e��3�MdL��/ӗ�7�ٜ@P����b�`���ӗKd�1�Wg
;"[^���]&��������q�n`�vB���5���Hrg���2{�<Mٷ��o��ߦ�'�����k����m�{�_,�=�J��,���-6˕֫i�<���+p�6B�? �k.�'��>Ja.���q)�JF��8�-毋�CM%�얔\G�U��x\��UɞW��e��5p��=�������C䤝~���r��װs�D�,8�<0� �R�q$�����Ҹ�ohA�]�
>Þ��P֑�{���u�=G'�&��L�3�Z&ύ��{�p�4X��N	G�$*
k��J��mqq�����r��H�>[���y2_�S5�S�UɝR8��ɛ�g�ԙ���]�^H����3a��%�K�s�x�d^4�a��G����]�rd��QUr��B��LD���e:�_}_���
O�3�O�ܷV�P~��l�z��=�ŚW0���!	z�U& ���Cw^Tz�����b{a�#�zsz�S�R���|�-�%���WQ3<cȫhaͼ��U��/u�$,r<yJKi�8E��r��IW���	ǌ-������c����X�&�:�Ѕڐ"���}�uڈ5[��q�$QRĀN�:p��ɥ��\�Ϡ���h�t���� ���W��R>=���.4(~w&)~αI&0k�^�X�����|2��`��	��}a�g&�Vݔ����@3d�5'EU�����-�/��X	G���lX\��+�+�w[�4�/a�9T�:B~ *����T,m����οN^^V���Y��z{x�@0o^  c@�ֈ�@⛸ 6�΋.�v�t��]���
h�|-��)�������q�Qb�;��,(0Y��ǫ�n<$Y�>������a�<�u�º�f ��rے��	Hf$�C�t�|Z{�!'iu��y�y|ӡ5'үg- ���N�m��d�Τ����F�����l|j:5�iy�B�Q���sGd�V��8y�,�'�%\A��ę��x�/�<:f��d*.O��s�r
3@~�ڌq���U>��As����;����~u��o��R��$�y�?�䫬�>Cq�� \q���>1�M�*,i`���U����tzy�j|V,���������oO�{v1���lt'_˧��ݮ�S�/���u2g��������./���	^G��+��y 5�]�Z"[�k� �3,���%J�*���y��X}��~��Y�+3���^t�W�2�`�
��h^���~:��<���fX|.����_v��@Y�}1�_�b�t�e4t�7�t�ûA�
�3�aZ��s6�x����{y?eO�W2��-N�Xs
�A�%q*4'��8���X&��[}+���{V<��i��.;�|�V	v�]^��W/��@@���
�H�~��<��a�_��'n���}j�_�Z
�ԋ����(�����j%4��+!@D��k��7�j5W"��a�V|����c������#���i��ι��X-��7�z�?V���/���� o:k}]<��!�+��s���X�*W�f��7g���g��QaͿ�b�q������ � aM�
��k���!����9v����n������BZ���}.���ҡ^��v::�J7x��Z
΁������Ae������K��qX��r�`_ʇ������5�xTwu���}��JUZ�Aj(��M���nz\91�>���6�up�&36Z=L�t42.��!�p`��VYw��<�JM٧r�b/������]��k��;����Z������!Pq�^�-f��#`�.2��u�s@N��n:���}W��(ܑ_
k_,1ͬ`��㜒�����Zvj�H�0m	�Hb<߰��s�F �c��ḋ���p�9�4�K�v���p9�����9�P�~��߱��M�s15D\ɇJ�������<�`���^~L+3���{x|(ɺh`$�g��5p�)� %E�-��:8��)bu ��`ޢ�V=�6���"�"����q����}f%���r�����;�a,�AN �<�����s��Ĕd���ٯs�L�S<B�z _�������k�q�^Z��-z#"�s]90��5��CH1�ih��ɼ�!uF(+�k���н^���u��۠�e�K ���*����E�-�ٜ�%)��͠� �ŝ3y6*>���?/.Y���d��u������.�F��K�PRi�MZ�+���8�lt7���F�+�a��ְ��B��@�'�m_d�/��;��N�Ⱦ�ߧdf5?�)<�^��	tBޣ���j� Pd=�3��ɷ[�	�"��.�΂������������E�Y;*���η������J(v�a�F�����zMVODO\pcOZݼ�0�a�C�4�#v9(ذS���-ǟ6������89:��|�]V܁�Q�u(��!�ob���	�`9~�'&��Q���vF�Hțܗ�������^�z
aj� pʺK%;�4,���>�rst3n��Q�$�DG���k��BZ��_v�
(�W��i#�J�u���V&Y�(��k�H: �Ϋ��W/���S(+%<��aY�[�C�$����/:��@z��#J�[�Aiix:>�y�4�|0K�|s,Ds���O�� C'�*$�du�m�U1�w`g0��t�)Y���m�x[�@�jJ;���&�E��E$�g��sS�X���~�ʬ�s�H3%U`r`���iBy��Z��4,�1�iϝ��Յ���̓�,>Befw�|���������o��3��8��ŉ�����ߦ�e�����1\1��	�\(]�����}*n:Y�m�;������5)���h<� F��&� 7�᬴:	�vG�[v�+/�O�\VIX��U��F�&P睇�-/t4��s�O��wj���u1k�o���p�NI��t��т��֒tC�|���r�T����u�P�M`����Y���	ۜ�P�ӂؼ#�95^ �|R��皟��8K<��\�h�_V3
���ƀ
�����^��^ʯ�&�I�P4�**뵖�myQ�J%9٧b�w�HKw 6�PO� ��Zo�
���m&��Ŝ[�7�m=��E
o��t������IPbLFA�#x�7)�|L�E��X���c�.��5�w�G� &'e� �uT�g;pt�~���V����RY,|+�9�����N����#�ڳ�[��@�~��\����&�� X�$�7��0�&*�^�Ղ���Pl���¿�wߋ �&�8�R����	�`?�R�6ϊ�O�@y<*�-�
")��8���~/��U��J����>3u�[D��s�N�ֶ��+�����d��kՠ`b��T�U)��?ۊ&����v���}�3x����9��I;��R�ϊ�'��훛�����ְ(Ni-���X�Kߓ%���PZB=��Ⱦ��<O�_f��cj׆!���A��Ҿ�8饆��O�ZpTI�E�J8("y%/��o��_�i���.��Y���|_��]��H[
f    G� ���JTH.`�#�ҹ ��F0���TR��#ل��
7b|�'\�"�)w�w2��⻏
;�&�?��h	'�
N��Ƥ�S�ؼ�������e��k{�C�xy*�o�
���
��lT���;k�x��侄��/`A�������e!dC�%m�N�|!G�^ըI���]#V���{KR����Al�B��N"�č&s�'�/TȄ7z���؜0�2��.��G�%u��{J�(�m�ҿ���*D7�э�K�x��!$��Ô���%9��(5)��V�ZQɍ������q��}�
��Tkc��vة�@s��:Ј�c�w��95��s?l��T�VJkqR�j2�F��x$��rQ��D4D�]X���׺�TP��E1�Ii�@Bq7nN��p�bZ@�#���R�B��@��mѥ��\��(��ee������f�a�e�a��}ǆwК�O�:�RGu�ܵ|�ޠ��j�Bdq4,.��l��Ǟ�ɭ��rh+��&6"��!~�+�2����5�$�Kxx��S�!�����]:q�m�E�))��G�w�{.��qP<ċ�Kù�v�ܼAr��p�dǶ�TBݛ<��;���W/�y�q0JrP�A��e��W&TKj�9�l�j?��3����W6���c��>:��x���p��Nq^y,뱓fh�pi��ar��eQ���v�
v�[�/�u.��:�E�mS����@x,i�b�t>�3 ����ZW��2s`5$@c�Ҷr?� er��?xq=���-�Ղ���O1"�e7�Dk�pC�#U��JyJ��ڸD9�uq9Ȟ����<�!�[�_d��	�?,~/3�vD�\��jP�È���HJ�;�UC�J�ʻVO����^Xhiθ�g���T��M��pFJ@BNZF�S��ŤM��H��i#]*$4�Q�T�;�Nݐ遘�b����R7G]1.9��g�}f��_�}�q0�6���!��Y�
�`�܉��{ŕyo��u�Ȅ����rT���{����MA���%sBi]ST��&E�r�c��u:�Ｑ���f�xGI��碗}_� ��)18x8p�E�� ����V���]��~8��������Ǘ'C�DVt)X�+^��7v�Z���3ʰ�b=h�c:	x���LyU����R�����!�F�x\�r2?!���Ɉt��Nd_.J��6�E�4xG�%,�(�go��j�P�@�7ڝtHr�SK�˳���V>���������y��}[a�G#����n��r�#!U��9�� %c��X��	��?�G,�0�F�:D7��Z(���	�f2㲊S�(?��52D��:-D���t�McG�2z��O�Ԁv�D;d��"F��n��1:(m(��>W�.��3�0��*U�zh����@��<�rƁȏ�Xy�	[y��;
t���N!�lέv�WISA�Y2a��X���j�*WS][S� �\E��B)��w^dY1�mJF�ƣ؊�S�P<$:-f��rN�|�>�gw�/d�Y5�O	�ry8z�YT�ME�"��r��cN�e�M͵On�Q�sN{�(%g���ΉI�
.%��A�v�/�X|zy	�� s�%p1�~�î��ś<)�J���Iܥ�<,�
c�z���Q?�Qڧ ���y1t6>t��������\ c�	�㘻���m��OQ�G��yB��`��r�U�Q�[�ro�.Bꄏ�Yp�r�6�	^^���NeA�'���q2�� �|l�bV������V��2σ;�w"r��q��ჷl_��h�<ʏ�~��)�@�Sp��1R1jS�Ҁ]t��O�~��PO�����7@������S�[T�b���X,u��r2ꛒG"�js��nb� c��d��g�C�n:�[Jv)�p"���t�Tύ���s�A��(E~���Xί7�(:A�l��`��Zs|5�5�����F�a�n����R��!���b���iQ�y�[47FV$�S�Qk͖�~�Z�yTyV\�'F����݆(|h�G�-(T�O�e�QO��ʅZ��^aL�,�m��M�{�w ��"O����oU��9n�Z.k�B
��
�/VOO8�%5�����v,�g�Qu�6�y�謻x-�?6�R��! �8RV�rM�����GF�ēj�|�����&IF6�e��p���R5�:Xj�SQz�ۣn�s*��`!</�a7���A Tu�Ogo�N�ݠ����0UW��'��-�	��X�:��iy�d�$�d����`8����YlZyb�F�u&�ރ@I3p�I�����з���0�_�Y�5�������耥I-�9�@$by|����(���>Rn��G�D��U�7Yg~�r�f�� A��O���:�ی�����rr�h�ƜD{�u���ho<��<�||3u.�p��,�ٙ˳=�'�<Q�X����xۢ��8�ak\� �q��u�J�c�P���k���˳����-;�����{�Q��+��Kz� ��TP_\1��V!$@c;������j��z�ݶG ���q��$$ v�a{��r��&5�QA�.h��n�������f��4**�-ZZ�s�[Pf���aJx�/�kTP��N�0����ccRݛ���OI��u�ji�A*�Kq#%v�Q�(�ڂ)��ts�а1�i��s� Q�_�o���v����IA��m�����$�"��$��w�������N�OF�:�a&5	��I(�&-��󖴡�/��W�k;(r���4��S9�Z��}h��:��AVz��N�`��Q���6�u
�^�>��`'�M�X��i���TT�cZ	�K������(<&��4�.��*���^��C�4�c�Vϵ�QA�/EVխ#>kU�S�3Y����V1k�נ9�X��r�4G�l�XꎭpY���iѢ)⼁|A�Б𷴩UVTL=�Sp0��*w<���a���>�����a��Qhk�H�g�y	<�j�����9H��Z�K4�$����ڋD����1���\���"�{~���.�FI�f.z*�9e��[\�t0�P�p1�}��V�Ey./q�拖�����l��!�S[}Z�EK(�7���VT��$L�q<��qF]���6�^:���i�Zo�ʊ8L�fΞ�ʒX4[�������j9����(v8��
i8�≚ڄRK��t��>4�W�����L؀g��G��)�򭜿c��g��UmH�	15!�M%;E��y��b���Ô�i�~�:Y~����j/���֪�l���(�v`��aLᲷc��tj=�p��AL�B"n[\����@\Zi��`�6T��\g�7*�^�Ђ5�U��rob�����4���f�XRkp�`ݛ�JV��:�bi ���B���΋>!و/�>f/ȃ���L��X�M����B_��H\E��=]R���>W�N� =}"�6YA�	uҡ�5�$��������Ӕ}��f��oe�c��D/Z�A_��<4�M��$�	���X=w�}j���ib�Had���TX-�&�[�ҧ�v��^����p���"�� ��)��K����h�Q�R�o岤4�3�fYsY#��|Rl,W����������w l��H�(uB����l�h��lZ�s��3��P�P�|,�P��LH���Y�uo��hLI�ͳ���VT(�g��͠_�yS����Ҁ<9jP�P�uا~�1�.�جڀ��9ss
�4��WHARkW̙ B¼��뷲�\��] ]��Z�FǐF�bz+�A�6Xr@�pzL�q ?�(��q�"�
���j�V���	 �5�'�[BSmt��y�9)�.���pM�N��'k�'^B��"�&Cm��0v� �J���{%�׻��i�݉�zT9�bfXy%NQ��`}�D uz��-�b�}ӎ� �C���rR��V$��T���1v��^��e:��&�d�����T�^ײ@`��S�p�S����t2}n��#JW�����3-�l�������X�k���X��I9�O�L�SHɃj$�h��H P4Α�8��x�@NX��"w�,t�;�0'� �  \�٫����棆�-յ;�M4�c%�r�D�N�NC���������]�G�>�l�n7�.ڰ��{�E/�[_P��O��za��C<���ZƑH�X�˶�i���q-F�61�K�5u-�|��hE������	��w��aܐN�GJ(E��y�i��g����c�)J��zL�ݻ).;��	�cUP*���'=��YۋCEVL�˷�B�Qz�vӰ8�&V��JW�3��W�P*�]���Ŝ��x�뀏F��/!)�@V��y��{=�Tγ���(x�W��=h:"����jy�o��l-�f��^�B��� =�ݴ{��3��p+U��Y���O2�RT�������䦮sX�}Ը<P%hhx�����|�5�4f�r<b��O*�ʺ���s�4���F���Բ�9�^�ڰ���TH�׹MY�^@���ɡ�ޢ�>$��O*?!���IHb!�J?Q�n�tNZ袀�l_�lNd�0��ݵ{���1�8��S�Bh_����˩�9�@д��,Z���[I���)r�9�<��t�B���,Y����)����zx��6u�Vh�g=X��j8�.itc�V���\Pǟ�$��!������+�>� WYS0�P�*,pZ?�=��a��4��@D 4溂��J���:�"�g���!��ݯ^�����ޱ\�#W6���	2��plĵ�����J���&�w�N]U�
h�(+��
� �ƴ��
P$����k�k���#�Z���X)�麚��@B7EM6w������f*5X��4��q�?'�[k���Sr=��TsKz�*����mh��U��������qx����c{�b�++�e���s:�4)6�,���*��]�`����kBd�I@��#k|7��o����\g��|s��7~�M}���G�`��v9>*`�S8�22�WH�:��U��U��<Aؿ�UAw- ���k�"^&/��3`�8f{��z���{H#e��Y�郣���<hk��``d|Ծ^:��0ڱ��Ygl�=�en*��+���h�D�,��4�7<j��9��]�`��6wK���@���!�p��װ��'P���@��:z����Y�����Os�Wsa��� �ԙ&~ .�9O:ي�Nc*��������*�����$���S�(�V���V�	^��7�О�A��4s�ˀ��7����:��8浆��7':�4��&1i���(��ĥ��5���5��ņ���E��Ȫ�*�)b_玞p�
O��Xx����B�Q&���酇����<�`�概=��9<�7(mm��႔]~�������U��Os$��̑��/=�'6��\%攭�m�*�q�bR4�������4����J�4��jV�����Z�vT�� _�7)�7�VՕ�4�~��r�y�����Kӛdj��cu�9]`��:�]I��?���&�c�Uq��KQ��a;�y���	�U�}�H�7h���N�^n��X����5%����I�pAN !?�kӎ�TzNl,_?�4F�g$��h%U}O�qF�_���T�Nɛ�����q�Q��lRᶁcI�؛�hxҞKɎ�����TQ<��y�*����h����[�:�[��A��O��:�[��!� ��ګ����|ǁ~�j��i%�:��<�~����3��N(װ��Y��$*�����փ�;�m�:��F�ѧv��n����f�yP���I,��2%��ے�w�fR�1�H�_fVwX�^��".;�*��&��g٤I�T����ͭG��)T3�u�	�Iot��|�|���.���7������
'��ç�Cw���֣:�ѥ+��ܸ�$i�W��f�Go���5KcLB]MC| =�g�+5�&޸p`�6�CG�)����Qmϴl������9?��ި<�i���'��S۪,��U�/.:a�r�*������ӗŒ&�������"b�n���Ŗ�k�b�g��j�i�J����÷���J��~��cҦ��&�s,#���-־�Ư�R�O�!R5�$�.�d��L�����r&�-M2�rP������4ҽ����*
ld�����t�I����e�8~���4�{ꓮq`)���V����T�J��Fu�����P{��ɰ�'�E��*M��Ӳw��5�vR/�N�B\���{mr��ҽ��I�*���i]1��s�?�^���w���Q.}�����,A�)�
ŹM9�.����q����4
Ⱦ�B��F�+�l�Ti�ýt���c[Wc��<��lbZ8�8�~�[�l���R�^��N�\=.�S9��.����'���kB-��t��{q��ߩ4.�\ͦ����W�9���k9c����RhW]�MB�j��H��Gzҭ͂�c����ɬ���`�~�!ԋ��r�il4�헽F&��:��Yx�݆l�G.���N�s(�F7�5�T-��ԁ�x�v�xR����Ȅ�Ѽ���5n��8R����\ҝ|%5�Y���'T�d��Ź�����J�x�M��Z��^>Y�r�_���K!��TT3؎�@XחBH���&��v��r�܋�=	�l�'{B���ղ�h���*�MW�V�6�<���5GJ7�S-O�.��.)�������ѣ�h����Y����5 ��F"!�,��	w ��[	�@�]��P��U��S(��Z�Щ��W*o�16����npî:�Ř�5{�i�
��t�c����FVs�zK�V&ѫ)V�V����P5D��}*�A�\�/?�O�6�I�JM��*ϫR|�����q��|5�^�����oX�ܨdˡ�q��4�\��n������y���q��9]��p@��6;M�1����|���i�0�i��z�7)�C���\�9�ǝ��ar�OW���ؠ��*��P/�%��Q?IU�-r�MC07>���p~����	��$=��Y�x)���4���e��FZ�]��}��^:�r��
�pVu5{�4�ߙO��ZC��(�eVnc��~M��b�o������GCI�
�9�A�>�ߩ�y�OZ�8v�}���yY~_-���q5�Uj�>Ab9=���`��!�����{����'db�sU7K�GuSY���?Z��V�V.��yd�r�Km�%rip.?L������y�2C-����G�����߷og9xc����X�L���VcŴ�;��rC����ZWWhZ����xԧ� խ_��y��X� �J�����Ȅ+h|�lڛ��^O{�P��R%	�Y��IX'￠�����|5;�%M��U��Ie���o�,.;C�i�t��^������
��fT%�ϋՊ�4�mʈ�=�k�\�  p$�W��;CO�Z������5O/�4^�T"Ӎ���#5�TS�O�T^�S�b�֦(�0��w۩$�j{&�ޥ@�O�q�	l�\�E��+����B��a����R +8�W,�/ٿ8�`k&E�~~�a�rc� vI�o�OG����rw[�8�J��oDyk�<����{ O��[r�#�5n���?6��U1�aql�����j®���ϰ�w���x�)�4Ƥ�`�!���.�T0ʥIs�84U�=~�Ϟ}��w��c����b�@A7���v籽.�e0����BWL&��L�]�L�@M57��8i���g��nt��:|�7<�0Ri}wT5b)�����ܔ_�fp������C��jYdg�b���LW\���p��m0���H<�V(�PH��h����`/k\�%�g'\C�U�{��;vp��������k0��LĀ��E�t��E�*��k;T�߁�u�v�a����A�W7e[�˽�������%�yd@����vw��zOE�4	��v\^#\2��a?z<�i�Y��!�R�@��(�7��;��p�i���%v�ڽ��`�I;C�!b-.��W�J5�(�xTռ�_[����?+&
7      m   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      o      x������ � �      q      x������ � �      r      x������ � �      t   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x��}�$;rݺ�+��@2|�N�i�x ���F�/lـ���	f#=]���A����,�a0���?J*�r��Y���_���?�ß�����������.�K�������gns��(7��#T���LՇ8��T�Ϛ�����QoP�������Vz��t�L�%�2�Cg:=����G�БR�t��?syf�s�,g�<s���c�;�=OM���+g,(�Z����[f�]��;�=K��x�z�����h<w3
�>�4د�Y�Q��S���ڔ�5�<"l����<�C4����cG���Y@Ǒ�a���bۖ�m+��J�nZ��k��R��|�,|�G��9�J2�2g��H��>`;�ϙG��(�c�X|������G);s?`'��1Fi�Q޼����;~�*~o�$߷�V>��+xn���Q�a5i�� ���g2'������]����r������瀪*�C�F�L��Y���h�Q��6���T�27��Q�Ɩ
ua�+���񐴱"�B�`�c�V���䍭X���b(�o)%�|H�aK�{[�/��w�m5���g�������8���Sҳ��ky�:���yV�Ϥ�^{����X���,�}�!�;��\����C���ǫ���߷r+Te*k5=����3e��]�<�����u���<�#[n��oX	�kX)Om�P�Q� +��l?�<�zM���3^�FU�,%�Y���Ho�Yp���i��|Tǫ��
y�l�p�W�V�^ǫ�=a��<R4lTG�Np5�3��h��PKvۂ�	�N�\G+���ͣi����V]%�F����ڤ���V����6s��5A->�x�U��;�L	� ��h5��µ��r��㡎U�����`�QFVhX�6~�a+v��en��]K%ʕ�:S��'W*5��$��1n�2ðU��'xTu��׎_�� �xbUp��M�Bk?Z咠�H��`Z�e���Ob�:���h���/�|�D����a3��K]՞IR�x����UXu�YzN�nR����EW�O!ԫ*��汱z%�^�C��G�ZS�u��S
O|�A��i�;�*N϶I�fJ��2�1A�=z��jfb�2��<z����\�>�����s�#��R��%���	��rÆ�ua�];����T��)��T�?~n��;�����
�2��,��c����|�`X��@}��"�����˿�����?��R����O7	�/d������Ii�dz	5�)?���2*I��?ƛj����5����1-����o�������]6(ޔ�8	R�|!#	0p��_��/F�W:�-����$��ͯ;`�`s>�:	����;�����0yG�Z�_Ih<�k҉#{�-!�S?K0�pΔ�N���� �w�I`/~��J����-�GBOz��Ϝ;����h��o_H�:Sm��t��#r�T��cXŅ��c:J�":��O��~��+t������c�G�4���̴e�lG�w|��?��_�-���8aG�������|RJK�X����Ԛ����"�/@�VM�S�1�&�W�ќ��#��8v����&kX���c�X�,�����T��r� { ��g~��	���=�l�g�8�MEp$@�n8L��b�RT�]Rz�"d��>���������~��_���������/ ���T��%�X�2�ۘ�WP�+��?�����ׯT��̓�����4��\����%B�]fh3���F-���~����*��v���k�G�NA��'���9c#h��d2I�I
y1�J��o���e���8�r�N��$�zn�Qz���Dh�R�*,w� |��D�NʑN[Dh��_o�8r�N �ѯ~]R�ZF�N����wP��8��
�4�=a�j��LG����B�p4��p��Kx�%v��)�ׇ �6���J��Gu�g:ju� Cn�L�ё��7z��F^����H��!yclZ߰M
p\�^�'������1�f+��T�7�f�j��U�R(��)!��q�c2�T�4�� v�U����&����7�pB��&��~P�W@�"�N��Ƞ]:3��)�4'��rqd��T�w��z���%����63��,�.�' �[��HRn����3�	��.���h�N�
�j��j�
J�p���|
��،0��;��|c����ߠm?'�	�$�3���}�%�7xn)|���c9��i�Ey�W�]�. �	o$�[�w����- �Df���U,���p�:*���

 7%�&&�7T8j�<��A
 ��xފ7(D��8ߑJ����x���}�H��W�h�	�ϩ0h�k�	��� �'�A�u3<eր4d2�=O~��(�1���X�ԍ��A�\�R9�@P}Ο���CY�� _��+VFD��Z�!us�u>�`,	�𫰸'~�/B�0��������:/K��5��PL*7!�}/��8�ؙZoB�|-Dhu�N�S���ŗ��O�^h���&N���aQ/�R�(����Gx��+��a��͢������$���$'�h���������{k��#7��F�����g������<=a ��=�׬E������oށw#��~�S��.���O�??�����;���B`���� ��FSst��4�-��&��rsT�S���/��1@8�6oU4~�4儃*%�6<��vwj�: ��0
��`-�7/�Pa�o�砩� >�h��/S�������`
�E�^��4��OUz��x
�b:�k�{i��.�;�bpH<MFfVP~GUx�3a��q�8�2�XYp�-�D(���<���пx���w��xwpXK�n7��R�<����h��X|�xy�領����&��3|��x����EǷ+�0ZcFH�xS��Np���j(K76�x�%��~����� \n�r����B�Bc�O<�e��6����2��y�{~)�_?���Xl훇�Ӯ�Tv4��b���o�4�W�%~�2�<��nǑy��e;�q*�ݧC���P_��6���>��K��O_q,���´������4m�u9���[9�_9�4�ϯ>���M�W�k�,&A[VV�7pV����� @Ƴ@�)�AoN�K �>�e���Wjɇo����d є��~�rz~12g��
8J��?�[��lBÂ��1Pxkt�3W��an�GI��R��{�X�Z=+�6	w�9xػ�/��`�."9Jm��W�LJ�I�9��[!�Ny?q�Lx����Y�NQ��V�1�ScS���YDs����ǧ�eg1�I��񮒸'8WO��ט�c]-'c%ۍX�][��{�Iϱ�a��p^����*Nϯ`���O���ӥ��[B��O��e�<��}X�JS��AP��Y��y��=�ڮx}U��%WW�M-��e�6p�<�19�:��	��]�g�69��ʃC�s����Ń�v�fr�^�j���L=�<�����dɒ�x��<�+��ReR)�}�"���W*Oi|��=�rp��V�Tƀ���^K]4~z��gt��`u��o��m\:�F1�KJ�p���xd۟kk&�����w�	������<��Y w�묹���_U
m�����,���?�#���_��6`h33NR)��[ʇ�d�\��X@��������i���Sr,�q̛�I�m9��ܙ��7�?q�8��������;�M M8Û�bI����w���M@�_	�Ō��v4�H�J �?;�N��;b4F��lQxjм���h��WBn��g�C۷�H�
/9�jK#I��!���)�Bg���S�P׀�e�����v9�:�Gف�<���Z��B���^4��b~��������� �����1��(f��pq�
]v��X/Lۃ���^=|���Ϋ5lޤ��;���^Gm!q^h��1:t�����    ���֞%|}�;x?{�b��2υ�ă?�1ob#I��2a�c�0o>X���|F㠣L�8�v�p�.��$�`uL����~�yܹ%2��|��+Y�<��k<�r:48y^plxYR�iw��pl��ѱD�j��1i3�8%h����V��=����CgG��]h����
xsO��&��UC�sN)����Q���rUՀ�ȧW��ڬzBX��#��D1�.i����戇/_/_x�Xy��2���W��~�C_gy�h�Ȕ�W�(ѝ���5�B��y|yG<���l9�/>:O��X'v5yj&�����Y��9�1V�r�*Y��y3�y`����*�Vn<ɍp�<��;�1��wmx��(wCh��Z����x��w����l�
xwă�zH]1��ۥ&�x�1d���W*�'o��M/���8�,�]l�	[��mw܃�8�g�աظ����}t��e|+�&uvw�W+V�E�L������R9��b�W�՞8ڕ��;�!�W/��XR(3��;��_�T�����p�S;;�Qi~|.��������ɺ���`����ҩ��J�Yxvp��ȿ������R+����Z�I�1�h<lv@��D��D������� �hT�I��Z�H�s
<������FR��Cc��F��v8�]�!W��:%=�Ա�v@k��/��-� ���Tfb���x�Ri&��pH�����*c�G�t�c�G�#�^�NVV������v��Z�%{�ˠ�2��.K�h���%�����
Sn"^:g4�[��c���K�j�����R6{P' D��hp;��%G�gܑ�˙������x.�f"��kT"�[�/����c��bi�-����`Ad�ԫ���',�	gMvd�^�!��(��`�gȻ�/��ړZ������o̆��S!@n��� eJ\��?`;D���n�ʬ�JVЛ��	��sh�q`��8]:�Jx���(�3��D��fp��۹$a��@$3�@V g�l���޵eft���dG@�C�_h��g�֋dG?)9/�������_�#����܂�����_~ƥm`5�0�>�;�Q��^�����d�?T8?��UM��۸z�w��Յ\��)OZ;�;��I��X�g����$�7��NS��jY��!�6����YS���ӫׇZLw<}G7 M���i`6��L��ܰ;�a�Rɭ/��X�M�����+��;sZ B���>�l���C�U�T?vX`f(�ө��;�ђ2���ht�5�H�˹ewp��?Kxb53��[� �7�3�30�ڕ@O_ZTv;��X��%�����:������jN���.������	;f6ӊV��߮{ahj8䙿}6�U,����F�����vX�/��~��{`�U�ſ|>��&��V0{�7L���L��Qn/���>��w��PKl3����'�%�Q���TV�䙤�(|�����b�%��K��S�f�J�jWtF��������~9]u䌃Y���%w��J����b{���::.�U���������5��,���bImb�vL�1�(��h��e����M�CL���r���y��Vy�/;��WǾ=��j�'\*v/��h���/��#Z�o��w@�"aƭ��jc�y.���H��$���o���5,=74+�Y�ȋ؇��s`N[�ʁ�'��I���tԃQ��uX�\����'Ί��J� �:�)���ko&��y�٨N�T�i�[�Da�A��o�hO�?]��{�f���z�����0R����~p��� ������BnW�kfL)W�я����ko�,e+В�=|?5��1Lp�9�5ia,��b@>�{s�k�Y��o������2i�}�:���30_�Z�<}�V�O�f8?�X�56�÷o�}��t�7��}e��|s�y��V�:���^��m�y���P|�2	F쨭˾m�y�7����/���hG;8V��F;,��mWa*a��t��i��9�����ygة̪]I,:�8��LAD�"���aIl�%!^�8�߹D����zQM��"�}�tt���E|�l[��R"'��aEOx����r�?����A��b
�ꎒ����Yd��t:gS���$3���H�ؾ����٬��xPD}�b9��8o��= "{�X,�D�u�?ف�f��gf����������髷�v�(���k� ���ZP֢�K��l��DT��F�`v �1˳|%�v�2|�h^�PH�?�Nh���a�:�h�;5�O(J�3�:lpءb���B����d���'ذ!�0Æ=������.�Q��P��_&�B�[�Ps�R9�8Hg7�0�n�����
����?|��(��LS�ߎ��|M#�o�U�F����cnG?x��K4@��<�.�v�?:�`g� XH���7�% VNk���e/@�� �:�P� �H��e��UYp�g1 �ģ��%,�׭
�{Z��S�#[�j����A�Tg��T�"Ʒ"��RƪIn"N��"���_���M�~�:y/�"'��7"�R��s��"N��[�>�(jk�o"���/�9&tI�Z��������r�w�i�D�oע�DZ�}�=3a�G��+��c p�L6,?kV`%�Le��Lf|W�Ϊ�g�c6l��Y�[~3�ˏ�_	�j� ������sR�Ɖ��
/�e��� �H=7X"��@��4�h�+��ʇ��5q��.���	�lz��

~}��#%V�P�x�l	p�a�@�Ӑ8uz�����p��}��xh-BNp�
v�l���Z%>�� /�������S�8�z�T���.ߎ�t�g�62����H^��+��*�-�G, �;`bQ� a��n�����C��K�vf�2O����C_�%`Z���)��8Ȥ�v�
6:�9�l�Q˼	(']p��Vx���x��ʓ�ʗ����P؀0�%��d�)�= ���W5�=7�XW��t�8B�#��ͯp�(�Xh�&���z�a�q��82T~T"�r,/�)8j'-`m`W?l1Wqd����[A;
�dS0�1��ְ��˛Z�b���c�J�&�.mZ�^+�Rk�O?5 �v�g `�&�V�>x��Ev�fbdV�f[���ׄe���,9�-�3UPu�c�/ޟi�G1�*���c=��V6ˁ����=;�8}��1R����6�s�;���`)_����KamIݱ��p�Q�.T�]°���E�a�J��|�e�&�!��J��KX��sh�4�vX�"��z���bg�j�`V(��,�j6�����E�v�x?���e���}�����+V[�w�Ԡ��\?����=�ζx��E�9,���<�����jl�|2e���~d�3~��l��A��L�q��o��'0#?~�aW4�
��ƽ�
�,���\�r�o2�
�y����q�V�k[��;~2;l�O�eWc�'�&@_���`���Vg\}�`3�az뎞�52���5��vV����NX?8�[M����w�d�wl%��XJ~��v»����6u��J������KD�Dԏ"���:*��4�"�۷hO���x��n"j��-��S8)���KǷ��[9v�ŋ��`�A7��v�	l잍��N1�6z�R��뎑8$
��?v��HÑ�c�d���W#�]�̯C��}H�������^�{x_^�c��K�ꘖ�ݲ�؉���#�`�j�W��������&(�FCX`VG��D�۸r�9�s}@�5a�l.Q4t\� �\��yV���r��f\E�����c��=���T��#C���l�J���Йv\I��ٰ���v��z4�XQ0�{C�g�Y���V��
�?�+��gMQ�q6T����c�_Ë(U��L�ǟ��n2�w>��������@r�6�nJ(@���q]b�����<���ּ/� mr�0	��P*��}��� �����K�]�)���    �f��!Q\w�cX98hϱ�_0���`Q���
d�S���C�縮 R�F�8�!��t���g�T�ӳ��CW����7�� � G��̂� K�W~�IJS����`M�6f�����0�B��'k�Pn�;�0�2����\���>;/�)�z��/˼ǳ�z#LX�aE�	�;���8�*���|}�BV+G�=6�v�ل�����)�X7�C��`-l�{x~��2c�����1z,LI\Sz-%�y4��=���p�+!�Ðpr��}L�?���KP��Qۚ�j���ǫ�0�P�_>W?�.��0w��|��1��D+vWΎ�Ǿʾ`GcvM�e�5��y��3�EP�Ed� �$X�;��v� i��ek7S��	����$����-�%��@���a)�Rk���n���q��&;�6!��*P¥x<��<��3��8r��Q�7k����=���'8)�f%��2��'>��@�K���\CG�N���I!~��i�H���Ҫ1�^M�YpGBv�=>Z~(F  `Ӑ@À�M�������xy�0���5��[��I �����B���L����v4Og�jp9SV�$l����o�M���`�L+"2z���|��tv�;	�����dztGC&��=���m��U�h��pG��b�D����O.`wo�U��ǧ]Q�<����w4��Qfpô������aJe9���U�Đrn&�;291L�W�>���� Y����&S�*�p҉�h��*wz}�ewFv��ޫ���������e�A:s������Pz9_���@�[��~�~F��HZe-`��?�	�ؤV���ߡ׬]��W�;��;rt�A8a:� �VW�vr�	�{>';��?�1�u�'�1��tT"ْHպ"s����1 �bm�u4�)��`
��?��X]�-��������\��I�;2a��:���R�Yskx��(�dU�jn�q.��]y1�;
2ٟ�`>,�R6��ε������TQc׺؁:nՈoP!��O�~����ͼ�K�{�
m�R�>V��N�7�>l�CR�����i,~��o�}��p�9�=��98g�`�*D�մ�MX�3;K�c l�0"�����%�c`�Y_��k<�Z�#�_���Cӎ_�Z��d�A�u/ ���e����&j�����z��k�<�ĠW`z�8嗀a�`a�C{�	8̝{	Ȝ�͗L߾�F?�GL�-hĘ��r�0���FsV.CwD�[����-ϮS�wx*­��M}�%�ֲ�����c�>=��U����F��-��~8�M��g�;;���-������_����b?�q�˫��_`CU��}z4��/?�Q}����#���� �1�v(�|�˧,?��>�|Y6��B��l7��R�tc��cb�|���
rD/#�i�A�Xuu`5WPIJ}8�L���|7���1L@��װ��EJ�82��`Vt+;,O�Q>�q��)���	8.�r��GC���X�V�s����8�en���i���	�����v��-`)|tk'���ӣ��G��L24��A&�Sw��#%YiE��PlD65�B���P�5�8Xp�!ݩ��[�wh���,㧯�e�>�J�;0/8�>+�>�d��Χ�7��X��%]$��-'Zb���'��Ǳ�J�=�;$�ߎ-["�.b��ʲZ��C"|���c���섊�+�Rvϯ9�u]�efv�+�/_��NI�j8��`H�%�h�	�l'(n
�7%T[o,����Z��㐟�g�Ŏ�	�[��=�1E�K�j-�~R!�3��EB�a�8��%� �|I��*k�ue\�f.7�w�;0�����&��|��g֖�N �� ��+��Vˎ�t(��JIװ�<q�Ў�X��E��8���Y'-;R'��!K@��$
]]��z��/v�Ҡ�:@��U�x��F|r{ˎ���s��Ƭ�Z�L#��Ƿ����&�d�?	�(����-X� <Y۫G�ʱK�]�>V�	�8�V�*�Z�m�����Њ#_���5܂z����G>��ZN��k�ýc�J�j�H^�9�0�Wo���>� [���*�������l���*�݃��l�l�{��ҕ��C>f�^`��a�4V�|#���dXb��!C�2`�4I7l��<���٘����|�˵�-�<.��*R���0-�'���A������;�����k��V�i�]�2��ᵯ���';~1��c0��A�ɪ?֤{,�~�Z�����ѫ`��o�����W�~�\?�����c�I{�� ����'g�-�5r��L��wp��:����C��1���wx8w�M�g�Q� �Ν�nn]1#uf��'����� 3�	K������!@� ��k?��X{aZ+l�wh��A�l� f�Rk���Mxz��k��$
U�;�aת��i=��M��]f?԰�Uɯ��+�j��i���K���hæW5�N��8�l	��z~Ձ���a`�X��`��Ǝ�����C����{��N�Z-j�Ӵ�h�z#��H����8�9hj�8m�K ��ޢ4�7�5w�r9ؓ�@:nx9�x᭿��G���f?耕,	�p��/Pbͱ�|��G0�N�Ldq��%�)�\�?Y\*�ͱ�c�r`Pf�0�Q�l���w�z�e"�B5�Kf�X6Ó��W���>�\#Y��+�Xȑ0ax`	ȦIf��ؚca�G2�J�&0r�n�����KX�C�S�Y�9V�Oh���Wٴ���'�`cob��Ow�8�����#��̓}/7�%@
�Ί����n".���8rZcm��%`G���1��s�������6D�؅İt���ؓ䳑l��W�6s��&o5:�-�d�x�D�*�fZB�i�kL5�Ӂ�F?ۚfJg�N3rǦ�M�~p�W��Ơ!���V8(6�g\p��;��/~��Ū;����x�&�L�;�ؐQ|�4��������c	]~f��Ʉ�6ԁᓄ�m���Y�7h%���]?�3�k��S*��8&ujd"ڬ":�jm� vc���j�Ie%h�wx���M�\yZ���ʶ����������l��9�S��#����_`�q0m�
�Ł%�K��0J�;2�� Q1�,���� �:=��D9��J����U�gz�e[0��X�����(ӝp��V��v\�u�p��g/3�w0C�k>�M5c0{�`_�^|�,3?��F(W�c���}�w<�����-Ǽ�2�|�TY`�29���H��h�r������w�,�����ڋ�?��\����̞��t�����|ւ��
�	�-��� ~�q��6g���`����.W!+�9"Y����Z8�����-���� �kU6,�9�������ɵ`G0���W�E]����\,,�5�`��R v�毟O���fp�\=�zp��M{`��v�;��eM��k	p�`J��Y�^#H���o0SbxW�CE��0����_Ϟa5�8�V�0q,r��gX́�����L"���e�0��A�;��;����N![/�`�,��lc ����\<��h!����s������Z���[��;6�`kc�8Ǥ�/��df�0a)����v�40]mB��U������[��F5"�^��˵�=�a�z���9��4Gx7�V	v�R|�pK)��<3U�`��YC5�W��(� v������ܬ�ɦ{ `ǯƄ�Lch���vtqc7�}�Kyuӆ��Â�8�����. \�"�aEdܰ������ �!?]���`X�:����;��ּ��JMl��=�� .Ԝ��e�Ɏ`��	w�Cn�����lDK^9�{�QS�����O��.�'C�ko��M�k3kkXm�(c��́��<���@����f���0R{Gl����8xXs�nc���,p�#/    ���'���,�a����P�Aa�94ZW������]��O�+V�Y*����Ij�yc�o�^m����-m�h%LrK6�VT���b���¨�cBt��g�u�ˊ��=��(�b�/�9^����y>.��e)����� a�B4j��k����P�;`��JY`��P^<�����īV���i6c�� ?x����>Jb�;���͑m��k~��69�W��wt�PSQR�XZ���
V�9�qbp�ML���V��o��&�j�qd�JT+[f`�����eF��/8{k��=~�Ճ?2/ ��p���kAG�q_8��&��ɣ%K@���q��%lu�{��$�����(���mF/7���K OY��`�k�{^�f>��۶{�U�/��TΗL��W����/��2���K�М ��aK������2~�@9ht��8�رE*���p9���j�����M�|' J�M�� r"Ѻ�cj4g��vh�!��zu|Ԁ���pkX�^���S��5о2�R�==.�� +�̴Q�� ��H;-����2���r`����`����(�����.��V��ܾ>�0�� ��8��?��8���]Rkg�p�l��"��f�5QG��1���C>�\G��ͦ�=+�k��Ʒ��x|��.^x�l���A�}�M��Α%���<��8��PmM��	�ּ��� ǿ��`ó]G_r�W����~5�9v!��;�Š�c`g"A���$��h��q��؄Zp�Yw�%�s��Q�7�j�<�c$G�.5�Q��Z�0xt�h�������q�%���g	j�.�M��Vw��4�`2΂��q�N�Ow��x�g�N�ʺ_�۴�87+|��ϱ9�
�!x�m��;�'k�
'�sջ���ۍf4��7S�!`x"a��K���4c��3.��z�G;� �N7wY��W�:�?���?.���֝�g$\6x�p,8��*��
��3�%�1L8�z�e�wm7v��&��|��a2��8��Cx:ǸǍ��FQ�ln5
����{`ƧZ�K���˺v�9@g������9�^m���f`�(�k����w��:x��*�j6/;2ÛS�=ԕ>�p;�$�&<G�|�[���	�V YU���f�����^C~펄c~��Sc�%�c�|naQ��q�% .Dy	�1��;����֭�:$��	<t�73)�����
�p.�����4�ۚ,x���d6���ho^�2b2˸z㷟����fYb@w�c�Mf\,�4�I�u�1OX��L�I+���Y∧P��i[�~�r-��������>�|��?�v�X�d�����b=!+k(��t�V�M<����9pt���O�����:g~��W/
w�ט[& �l_~�����/��8νs��hގ�^�d�����:�5��A+�Λ��d?I(��x�<i�na�b��k�C��
%���8/�`*��Y`q�Y���B��ӶR[��<V �p31��)s��[(+%V��W��Z����94S�KA�`8��S����4s8^z��W��~���#�_�a�٧f��O�����N�#��f�/�rw�|��J��S@vϯ`���Y�ٟ��r��(��3�}���;���*��5�,xe��N�ئ`�{F��pL����|�zOF��\N��|;�����^�զ�@��PZ	aͽ^���+�W	��a�Z�D�h���|��{4��3��1�qʷ����K��.Ta�ڍ{z�S��f��_�" �������P��M�g�%p6�L��ZO_%B��"̯;���㈺|\pk��3u�6��y��*W�����i�<��SK_)���ޥ�~�ؼp|/� �s�[`Ы�?�S�5�ͳ��$���j� *$�`������X;F'2�C�o~�o����%|yi��뎁,Q8>��%�/��nwd?��^2b�WF�dg��� �JeV1��8�)��ͷ_�校��x�w� v-ͪi�����M�N,� ����W
��k�?���a���j���۲�i2Ȟ�n�W��j@����#�,���^���̏��[���������K|��(Ȗ'-��F�Ʈ��� G��T�X	�k<+�����l,�̛ v"o��b��1+��(4bp�nff�d^T���J诩�l�d�o��c`��jh���_��ʁ��;�r�Bm�~����c:b=W`���m ^�ԞX*�������i� ��g�t��`���=�	�Wf@�N�	�����X:t:��@	�������	D�c,�Y��y����2;�am�rܳF�VkZ۾֘8v\�16��(��<y��q~��0-%��k���b�a:�;��vu�F�!�J���j>�ܑ��{V�L�vݳZ�H\�������u�L�p(7���K ǆwfW�� ������q(R�� �z=}#�[�o����`l��Ig�n�ܑ�`��gj�-�ʢ��f gR��=�r��Z:9����TX����;��!`zC�?K�X����s4� c?�]6$s���b�;�AOc�X�L�.�o�Y�:�t0%ܪīa�� /��v���$��V�:Ԝ���8�x�0w�����`	��М MY�g��d������ق۵'�����qv�Dm��+=����d����5
϶�sJ��f�1��_�����aP���vp���
+.d��68��|@Vc�Wt��������ॱ���M�gq��V�k�`�
ڑo�
-�κB�,�I� �u43�X�1Λ�C���y�'�?å�WN)�_J�=w��3#5j_�F��m����{�R����,ߘ;���$N�~��I��Sw�`_�K8�p	(6�C����;�A�F��~9��X��}��ݚ6��*.��nO����{���b�4�� \=O`;�k���t�U�;��mdtu�_� 9<������CR�Pm��������p��j�aח���"��46����S9P8��gwo��13��9`�U�?p�s,��44��"Y����,��W��]~DS���W�J���d�}@ �?�Wx�:f��K̹�=�AE��ӯi�T�!	�pG?�|����Xp����e�~wO��s`@�y�¢��=����'-<N~8�g@z���������A���(8L��Q�N^+��0w�pe!\|Z�֞���`�:�Y���_�7@>z��_*�����o'V��؜'�l���3�F{	�~v���_�~����2bi"�Ou�x����W�L��s$|}u����=�	Ʃ����������l��,�Q�>���5~*����\���͖n$� ����&䛀C��� O���$/`H�e�_��d�6�@�/X+�M���!m�p��@럃�x���N�K������˂fk7�� V��䦀��x��% [!Y�,R��>a�!����!Z�/���&��8ǳX�칃 ��+6]^m�*�F��pV���_3�����z��C �=kd�����x����!NiOa�ʴ��i9�s@���� ^�j-�ʗW���p�O���/ xspV��<�ks*�����:�ªb��>�O�0jʍ�xN�	f����Ëƭ喀�������G����o�����R`C@�	�߼���,K�
O����F�[�4�F�;��y�� �2^ua���䁹kwd�.���b��iܨ����/���ēc��������;�>�?F�C��5Q�e5lX���ǰf_��������Af? g�84�M@���n�� �0���[�s�u��kG?���
^|8���;�A=ŵ�K�]��� OA�5�-8^ݑ8x��o��)���0��aC'`.r� �I8������vx89w dXs�j!ޜ�����я��9 �   ��{�9��L86�' G���~5���B�w_0@mu�~�����B�$0��X]�cz�������G9��%/�J��A��2Sd,����%��
���b#�������h}J�2��V��^BOq�����t�ʴwh�K����u	�m�j����|<����      v   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      x      x������ � �      y   D   x�3�t,(����OI�)��	-N-�4�2�"jl�e�M����VCLL��6�.l�eh�E�Ԍ+F��� ix;      z   8  x���퍃0��a
 ��W�qt�9.@{���( a��o0���:^�K����Q��D����s-�&��6"�f3�E�mW�Z�X�?Q����L���S�X~���Xs�@V�z����EV��	#y#iD��k�],�𚥸�4�
����E��0L�ks�[cq<�^�@��e#�)ˌLnjԣD]�m?h�=ɸ֘k�M��u]^����$�5苗�\oy���[���QJ�Q�kL$��3&��x��-�vǎC�Vq��쿔��Y6���}����|�	����T�ո(yN�k�߰���`�g�=�a~_��4      {   �   x�}�Kn�0 е}
���ۇ���M��h�j	���B(�'fFO&���p���@���� 6�>,nHҘJ@V�043�[��\nL�q��N���h���XK��b�(+�n��0&�I}IJ���pǵ�{���U=\<��WWظ���@I2�3k���m�KW}��q� pP,���UQ�$��K�*�&,��3���On?�����c��{i�ޝ��K��]�]��e��Z�$�~�      }      x������ � �      ~   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��         �  x���Q��C��N1�	��D��������TBvT2���:�H�P"�LU��շ�[����~o��k۾�������~����?�����m�j�������0��j����<<2�=�d�T�i��z%��]R�M����h�:%��L4T�Ka�!ݦ>L4
N/���v���F�t�!Z��M��^&�J7�/��:6m�A7]*�M4
���Y�`��~�/�]�i���~�M}���[տj���Ə6�����_�v��ŉ��Q��o�j�\6jNO�SC��{7�PMO�GDw���C\>v:*�I����eC7�Q]}Z췉��AC]�C�h&���k�p�(9�g���;���QOG�j��F��XD[�&�^g:*�M�l&�����F�LC�:$}���Q.�t���Q-�4E��Ȩ�>�]�����˶�L'Ŋ��v�����d��eC7�KuӶ�3k�ʦ�b�V�tU��*����Zd��U,�m���E_ɞ��W�誺�Xu����b�=54]�EW[|�tU,��JWŪ+ʦ�b���T,��	�NKŚ;��ŝ��E�]��:Ճӝ�:UG��Xu�S❎�UW3㝆��SD�O�b���b�U�O�fkh�hG�l3�,7���d��Ҏ>`��i�X>�t���6�@���&����ᦩ��8ؖ��2`�����e ��`�Hi�*X&RZ6
�M8��gX㑘k,tݐ��r�͵�,}%������V?�L�',�s5��hJ���2��1�̦�H,�#��"]�Sb&0#t1���S`�
0WB-*�HA�{ 3U�R����,�-|{�,�L��%d�k1
P�TR�)�x|�lA�% ��`;] |�0����l���(�	��l�T]�ѩg� �"���l:LLU���0��01�|�0ʦ�.]�ra(�.��:L�0gW�(��c,�ÅQ6�,-� {�,�f��%h`�ɢffYb��va��0�ûPf���P�����0YMoi�!��dQ3����`�ɢfzKL,!|�p(3~W��Pf���Pv�R��dQ4�R���^�Z��&��e���`/�Eͷy�B�)��Mc��2���B���Bb����������īf�ū�m����#��r������h�̚��M��髩��i�Ȣ��dۋI��DrO���wl������&�Ǿx�/ŭ�=4
f�k�ҷ���,f��ɢf���rͻɢ��dQs�*�e��顨��PLO�b����e��I����z�}�8S�Q����ǒ�o��>���;c�Y��o��\V�;a�Y�ƶ7[�.K��ѺuY��dq�錺�Y�&ݴU����PT�������m��{���Nm�{6��n�����d����;�%{�,jNW��咝&��髲�\��U�]�ع�l\勞�`�v�E��UyP)��dQ3}Uw�K�Ӆ��Ϊ���e��Mg-Z�|�����꫹0��\u�&]n����=L5����R�֪g J�˅�Lsɏ�{3�нi�r����&]:�\(�݅Quz��z(��dQtzk11Q���V=nQ�f�-��V=�Q�v��nz��(u�Z�F����jʣD���`��)��C�6U7u+��\���`J�<\���TK�|�0��Y���f�P��0�z����_��
��ńG	��C%L�������A	��깁�M�ս��M-��%��Zt�K8�Uw�K��V�	���D��f�l�kѐ.�4ע�\�i��/\�魺�Y�魺�[�魺?[�i���Y�鬺_Y�鬺�S�{:��ߕ,��l:��&�_B��!˭�v\�5Q��򑥳����zy(nr�JL�C���*�MSi�0PzJ�w�2��"Z��������u�R��J��3�q�Q)tݨ4�G�e`���bG������J[�2sП��� 0--��@K��2�҂�X��l�2�Ws4�̳d_N7�k�Y��j�X�b2�����e�%4`�<h	��d�C3���&d��k9PfYRX�Q�x���A�, ۩`;u <]8�C��jd�v�(�)��w n.��@b� �%���l:LLZ�|�0��01�<]���S�v���,�,��,�hQ�0Y�����J�{����u�x>N�jc�|��Ն��8��'��q�ג��W3?#�v�f���{��=�[�|�,j>M5O�3B��rl���=4��q���(���zh���qҒw���0�e�(L�ev��0�>��C��I�_�R��$ۋ�%�/��x��#2�6�������rp�p|�ͅ�����s��O(��>�]e��$o��8Y����{�,jf�Il���
�gK�~�mP�.e�Kkց�ME�[Z��i����Қ�`/�E����`a��U8��7W��P�[�Pv[�`w�E�<�����Ŷ(�i��^n��*��d��X�K�&�=,��(_��������O�E�����Q�%_��o���*ߤ*�	�
ղ�I��-�_����ofl?�����Y���)ɿ�WUǁ������sk?���o�����k�s����~>�T(���F��ϊ�o�8ìJ�L���-�1�ww�`����%��OA+����,�b���r�UE��{�,t�V���:=�������m��{��������L��b�a�;L�|V}��X��ɢ�tU1e�b�ɢf���Ŋ��>OY,�{3ٸޛ���	_��dQ3}�9?_��ɢf���Y	�.�tV1V��L��*d�ṥ������5�r���gY	��n����Y��ɢ��V1�ҥ��Y�����P���G�l�Ɇn��>�t��B��*xV��¨:�UL����dQtz��Z�����V1v��ɆnOo#K+�n��Mo#K+ݴ�瑥zx(*��>N;���(���8(�BoşB�����Bw4�rz��Z)�r����Z).�tV5ݵ�8Z+��C1c���_՘���aդ�
N�U�J+�����ê��
N����+�k+6�U5�Vp���q���WѧZ�L�>����D�s�hŦ����
NsU]���*:/+6�Ut^Vlz�螬��V�Y�i�boŦ��1���*F���*��V,��l:��&���}��C�[-���k����#Kgi+ig	��P��4��H�,x1U��Ңa����e�դSXFZZ�
֍J��Q)XF�Z�֘nT
]7*��k�X>���,}%&�����A���',Cx5��@K��2�҂4�̳� ��6��e
��h��gɾ��<��g�J��J`�:��`�Z�����Ѐe�%4`o�ş�e� E4#P&R��Y�� e�%(3u#�v� �N O�3u#��G�L�ռps�(�9�� .���01i����P��Ę�ta��}�v�0O���2X&��6jf/��Mw��R��z�2uPw��x���i��S�<�'��i�������B�y�Xs�2�Y��z�h�'ċa�Ȣ��dQ�a~F�9}��հ���P\��(8MU/*f��� s1,^�YT���E8�#xF�\��3xF�L������(�!��>Bx���!�ֲ �L6j~d�b��paT���+����P���F�i�(��Қ4`�O�|���d�f��js�Å�Lo��%(.en��D�zd��,�u��x��li-�`�Ƌl\/�x���,jNk�� ��ɢf��~�g�3�Y�<M5s���Uɷ�F��54
f��͞E���?�L��vx����2�7����~�^��#��      �      x���m��E���70*�>�V�����vw��1.���\��.EA��x��������_��v������d���۶��>�r��amڶ}Y�?�-ܨp��ް�e7�t�ġ�8��ck8�6�G�p�G�q�{�yl�%�Ou�S�7���K�x7���8���{�� ���S1<[ó�x���ˁ�ˁ�ˁ��^e;a`'섁�܁=4c��C3�Ќ=4�#{h����f�{h�Z���~�=�`-�C�Ђ=�`��	�}+��}@�s�`n���a07���0�s�`n�O%\ֆ��0�Fz�Ho�#�Q�7��F��(�Fz�Ho�"�a�7���0�Fz�Ho�#�a�7���0�Fz�Ho�#�a�7���0�Fz�Ho�#�a�7���0�Fz�Ho�#�a�7���0�Fz�Ho�#�a�7���)�;Ez�H��#�c�w���1�;Fz�H��#�c�w���1�;Fz�H��"�S�w���)�;Fz�H��#�c�w���1�;Fz�H��#�c�w���1�;Fz�H��#�c�w���1�;Fz�H��#�c�w���1�;Fz�H��#�c�w���1�;Fz�H��#�c��?t�[��{��u������{߶�0�9������m?�v�u��|��'�8r�P�	2%�K�'Ȕ�͔8�"O�(E� S�؊<A����(�gJ!A����_�
�T�S*�*��x��/���n�+h?S� q�s��
����V�~�T�l�g��3%^d��3%^e��3%v���L��\A���=$h?Sb	�ϔ����)���gJ�!A��{H�~����)���gJ�!A�ًwv��}�T5���G��gS���5��.1Y��)qh)�˚�L�cK�\��gJ[���&?S��R��5�Y��%�OE�&?Q��"�����X���&?�:��-EzY��)���-EzY��)�~I�^��gJ��(�˚�L��@�^��g<�EzY��)��(�˚�L�=D�^��gJ�!���&?S���!���&?SbQ��5�ًwvEzU��a|TM~6UXY��)��5����"���ϔ8��eM~�ı�H/k�3%�-EzY��E_�
�T�Q$k�%ޡ)ҫ��l���H/k� q�s��R��5������R��5����eM~�ī�"���ϔ�	�eM~��cQ��5��{�"���ϔ�C�eM~���H/k�3%���H/k�3%�EzY���Hq'`�Q��/k�+⓯K��s;̦�fk�]X�ka!B�����U(�,P� U����B��ǶB��G��毕6�8B6�<���T��Z8S���,l�AX�%�X���V�<P� q�s��V�<�O<�
�O϶������e��%^d6�x�U�<Pb'T�<P�3�����=Ta�@�=Ta�@ɏ@�
�J�
�J�
�J�
�J�
�J�
�J�
�/R�	�}6�,Uп���*胩�����%\(�:�@�#D�V(�P���8��ku��ǖ�y�>��$�R�.����;	�M�ɵ�� �\�W5�O���
��>�NB��V!(�o)>>Ֆ����G����c��o�l�G0���_�YO�4��ֽ����>ڳ�>�}��W}1#�������1�ַ�:�h���ޏf�b��8�E�?�~X������^|.x-P��U�J�(z�*�%^�k����Q��U�J�!�޵J�@�=DѻV�(��(z�*݃kb�Q�.U�����*݃����*�%\b�J�@�CK��V�(ql)��*�%�-��Z�{�ı��^�t"�/I�x��(�U��V���~��=�Gp`i��V��{�� ϖ�&j������D��=P����&j��ǖ�n�<P��RԭU�J~4�UFQ�V(��E�Zx����[� ��Cuk��{��n�<�&vE�^� ���e_�h�c�d����c�v�Io�R�Ï�Mm�}��CFYڧIn�̵I�ɽ���ߟ&�棯�r�����~e>��3�ݷ�:���߫d���>Y���tq����-ſ��/���.A�^?�uٗj���F��
��s{ۭ0������m����c��b}~��_�̂�[��Ә�A���b��B�%i��W��⹪Q�gS��R9"�T9�D)N�D��S�k�R�k%����$J[|I*�S�S�T�M�׌$����.Y�8�*_�(y��׹�lU�&�O<[��If�w=�uI�x�SY�D�� �VTJ���S�%>9Uv)٦��Tv)Qb��R�����.%J�!�]J��C*��(��Tv)Qb��R��R٥D�=��K��wv��.)��a�B�ÐLV�0$J�PtC��RE�.k݉�(q�($�N�D�cK!Yw"$�B<Uʺ�!���mRd՝Ih���j|�u'Br�x'��;%�-���u�����YP���J*+��wG@=>�{Xu���ޣ��+�%O�|�|���Ӷ�ҭ:��Q���ے2�n&H���ے2�n&H��C��u3A�'r'`�Q��Z�#�	�����f�D	��n&H�8���u3A�ı�ܭ�	%�-�n�L�(ql)w�f�$B��T��
�"�L��x���.�	�}���n&HĽ�}�gK��� Q���]��tK@��K�~9�[%�-e`��(ql)떀D��
V��(�[	V��(��(�ꖀD�=D�U�$J�!
��% �&v֞�$[�������W_�����k��_E��ͯ_�w~=D�k����]S_����>D�g�ǩk}����$�WX�>=���}jc����XŢ��������4�cw�X�R�2%Z(6h-�SU)-'�ҧ�r:8�K���l����M��r�Hm&�˝_Sy�t��F����(���ZH��rZ�<� *�B����FC��_���~�48
��=��g�����g-��JUYk!��j!���B-�PP����Qx��t�Q����q(��B�8^��.dW��,8�V�XhtQ�2��V-��Ȟ��g�B�u5��{� U�໣�F��::O��*+Qu`�"���Uu�*�H����T}�tۀ�ƺ�T�WU��^��z�xK8���e�v�xGHu+�C����Rߨ/ʹ�n��tըҍ�����{\�Nk�ٷc,�<OK�I9����%���c�.����^��D�ϻ������\������k����}<;�z�% �W�	�[��A�2���?�t�u?f;lL����g�PFf���ُ֦��>o�-�����1�a��{Wm]�3�h�����G��Ԭf��ң_���b�u�����x�;R�1�/\��� ^����ۀ�1�}�}�F�<�9��|%�N����[�?���z��M�����Ç"�g���m�ڒ~���凬�8�O��ފ>��p~1��!\�WW�Z�[_��]������)7]������)7]��_,��@O#�r���R�B�k赐���t���ǯ+ٵ��]Ǯ��a�N�k!5 ���
v}A���d{��^�B����,]�K���uݺ��7~�t�0�Kֵ��+w]뮗1�a>R�k!ު�`�N�k!�*���
w-�' ]X0[��۵����ܐ.m�B����]�s  �v-�΁ �+����  �|W�_>��Y��|����Z�m���eCȾ���S���}�}���w4��2����]��oo]�:�v�x���=^�z��߾�����ԛ��v�en��{�ɼy-���W��7.�.�j�˴l�<�F_h<��/��r�O����A/&|�ۮ�=O0_���n��4H��9��2%}��Ym��5����~�kV�ܶ�޷^���������)�9���f�tf�y�T�T��$xLHocYG:�7�'�)����q�:��AlvF�K*�o�2z�ȕx�agF���jr%~(aF,���0�5���p��_{(������%�+�d��J�ћqn=�0ѕ+�w�<@�@��X�	��+�S1l�0ߕ?�8�j��U�ě�-uEb4��\�W˘� X  ���ʫ����=%>��,]��6��¬Y���3̛�J�B��Y��/5~*a,W�c0Lf�J�<�tV���3Lh�/
x�SZ�5a��F�T�#Z�r%t�h&ʕ�>���D��N�Q�+�}R@ME�;�R�W�_�
�T)YŽEyt��ƷI�J���J�6�}R�MF�}❄ґ�3ʕطa�Q��Z�re�k�?H�q�Q*�ڍ��
Kr%vPXĐ+��@yLt�J��P�G�����ň =�?8������=н�����h ��-�⤈,r%^��E�@�ċ�µh�O��>
�q�@*��M�O�b��ȕ<B��u W"�r%�O�� Wb'P,�[�KR!�*��EA�ě���� _�8�4 �	� q�s�����(ȕ���_����|]���D_A����s�[�+ql)����\���(���\��h(?�.�\�=D�Q4�J�!ʏ�� WbQ~��5��(?v�q��0�$zr%.�]y�7j;�S}�LI4�1�:�kF��}6�[V��T�w;��i~7�<*��[��}|��#�~�x/�wu=���蝿gk?��>��>&�ѽ����������      �   �  x���]��6���_1�	�?r�m��n�m�d{U�P�ʌ;3�W����/%S"E�Es^�Ԟ�J�{�C�H4�����������K�G��L����J�;��J�����~���W�9�������SGc��8��=a&����F���!?���Mw<���4��m�'"B�7��Q����?wH����(�9�'L`�E�(>"�"XD <B �	�!ح�2�[��t����f�oP`�DA���!d�73���$R�D��<�{��-�)d�|b@r�"a��ʉ�(�Ί{�N�~�9�S+�4�� �T��f @������i��v���$:n;�~��L�p��X�c1J�s�W�͇���?b� ܌AS��	�f�j��!t�2A�
�j� �A�f�������1�4���(��݂Eo|� � _��"PbAB��������R�4��3hve"hp@S�	Aod�"i^'���X=�f��JO�Y���ɑB��<)t7��#>���ID56Ð��]FAf,q��2<�ۈD�l��DwyF%��\X9����@��lF4~"rl�9m_�S���Kb<���R��%�ll^�(��{Y��(�*`�"�.`�N�Y� s����]�w%
�z�ϰ���@��+hP ��E��Xѐ�;�[3U� ��,A��?A.�3S��V�_y3^��|nw��y7�����C=q�����=<�wm����+��6���v�܅/�y>�hHw̾��P�߽/l�>���
�+�C�����뻧���WNg�5>_*�9��Ѐ�������e{<n�;;����}�����(U6��z�rs���A�����J�W4h�R8�UrY��Ώ�/�ݧ}�D���&��q�q���e��s�@PM����j�0�(��I���<� ��5.�Nk�0\�L��挆���v�MDJ�_(����  ��2" �#Յ�Bi��p�þߢ&!m��-QP���4�b9h|� @J�$HJ5��TJG
�?������A�E��~b M�Y�@����n�u��p>�96���
�^�� ��u&V����(��/��Qe!��ؘ�u*�/�]A"C�,��ow'L�Y�?��R�b��h���ۘ���؂�ٸѱ��e%Q�Mʽ߿�l�����F�+تP�� �dk*DH��V�����U[_A�v��C��*����s�7�qW��ĥ+�U�>Q����#R���>r�M��G.d�b3�W����W�a�"6�U�w��a2����Dƛ�xM(@����=�QT�ɋ0�v����r;n{�n���K�Kb�ÚlA�o��d�Ű&��A���p�,�+���ӹݥ�*�d��,W�W7�Ǐ^�8e&�����C��=��y��~?|��}�{�>��:2w	�N�6�l�N�������y߷�c{?̲B	��W��F@�S��W�X�7�*�ҽM��}{���ϗ���d7i�e3���օ�考e��aG���%ؓ?l8X⠓l��ѥ�V��&����f:����,��}��t��Mp^А�w\�0z��e�B���낆tm��F�Yn
f�ܮp��rW� �徠��*J[ �U���UL�����Է��v�@E��in��Ӎc�°hG]��,n�\���D�|"q!b:��ɚ0(8��ψӐ|�`'�es<�[��*#!}H�6d z�!M�A^ڌ�5��I@�����g�W(���~B�RK�h�P���邿�Cŏ{8����Υ�n�Z}�~��_������r�nz�O��4���¬>R��Ed`����L�H�LL�H!Ln��w���~\�M�>��ꘀ��]����	�c� �>�Q���@�-�����QK`3F�(�p�]i��uS�i7���� ]��Up�Y��An�5��k $=�j@�.�^����C��uͧ������q|��%�X� �u|�@�ub�`YR�́��T�AT����L� tv�8�����4�qe<	K�9�V(��i*��sj-�|v�ȴf�?v��r�}i$�iM�h�2����J&ْ��N����e(��̕�#�]�}i���?ھ�=,��$�SX���6ߴr2c�!��f6˸{wj?~�JP"Pf0���/�n���Ea��/D�3#ch�����nCC|��m� (�ʣ,i_.x��w?u���>��)R����)�J��d<YbܯAF%EK&��)����nSyv�#s|����oɮ!_OY�)A(}�x�~tw�Y��.ǵ���R'F(`�0���p0�S��?�B�rP�l$y�9m��ԮIr�f��SΓ~��u����0�/���0W�@�`�s�;v��X��q�oF!���N7����ƥ�f>rH��P�@XYu3��P� ,��0K��oX�K((�X�]���8𜮔� B'u�\��K��+6��RU`иZ�ԟ�_����i<\,�+���HWi�J+zſ�����8|N����I�BSv�
�6�.6�S��2d�#�yw��d����rrN�m�Rݢ����R�0#x��=o�M�[فq��H�&�1��#���2¤��j�&GDe��
4Wf@�P�C�43�5�	Z�h���>dJ�9ӳ�y�悅]�hBq��c�� �v���U��4?�;�����w�W���� ��}�G�=��a1>~�v� �N�u��X��c�%Z�r�rXU�j�Z��Ăj5)��Y���++���z^�r�tj!���� ��V�������	�QW�t�"+�/�A����J-3f��Km��Yj�q��Jm32�̓�BsJ�Z�Q���b�I�s0�4"�����g�dי4�|�0M���[� �1��A�l
g���e{aAُb�`E���ʒ���K} �̪bH 	�ꂆ	�4L vE��
"_��w,�A�x��j߉%
z���Y@���h��N/@H뙜���q*�W!b��U"���0� *0��"×S�Y8Qgl?�`���D�*U���
�/j<��� �7��b�xx���S��FQk�E�2���^<4��
���Dta�L�YzW�B���:z9cנ�˚�S��u�+H`��X6����)�J=o?�%x�+���c��A�c��ar�+�c�
 `�K�\���6���5"�V<U�*����M����V E�J�U�� eV�!�|M�A:9%*V��S�b9x:9%*t�trJT���䔨X���)Q��[��S��
b�A:9%� 'z&MI^ҭ@�
���k6_Sk $x��@H��Ԁ�ĥ]mKW�!灼+�+�m[� Kܸ�};~�;t}�]Cdi�����X��������RٻY�SF�39�d�6=���bLK��/�cfO�W�n�@u� �7��Bq�h���e<�w������Yy�̂8he�$��Pn��:6�,�{�lA�\��y�X��^'�&�'ݕ^J�~�,;V<SJ�o���)��������E�t5rO�@�/��,v����;�t��q�"C>}�$���4	�2e���!�g�4�	K���L7:C1�hʴ������=c!Giʬ�3=C��U���*S�s
%:T�4��^��%ʖ�5S�=�)ۋ�����kY�GV��i^|��Ԟ�_�kp�6���6N��5q�VUx���u��Lk�@�YZ[�ݤuk� �����9E��@�����딫�z�N���G�*"���*W�:��@��ܱЃr�cSgW�i@~��/���ϽIэx��gp���<R�����s/'�Ç�!#r��^���#s��~�����c�@�x�����L�7>^ؼ^��h�r�c:K&2�~;����!aR��p̊A��͔K�ܽ>NSu�%6I�}z])7��TQ�M�5²G.C�:K�2���9(^S/�'WNx������}y�s��=����� �ӗ�i�I'��h�O��{S����W��3b�n~?Of���$���4x�����իW��*c      �      x������ � �      �   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      �   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      �   o   x�����0E�e�.P�E����s�S�~�8��@$�%��x�Fp�ֵf��`\�"V�H���!������}��n�ɢpWu���jO���uY�/�m!��:F�      �   �   x�uα� �����ܝ(��V�,Ĉ�ť�[ӡ�?���M�����2�������$�PX�-����I�l��8Kn:/�"����KC����l$i�hc�rD6N!^\Jbtk}�-UA�C�[�nv�wq�j)��P�������&Sܐo��	�H?6      �     x�uбn�0��~
� ���؛!4BQ�(u�B[��J���-hc�_�ww6��ַ㥿�"�OF@��N �M��t��Ԋ��3�4��_ fm�	�9�/�k�h@-'����|{Y RNB�wø T��	h�N<]���ڨ����㭝�	҂�d�ǌ]�xQ4E%�ա�[Q���ݗaSB�@��Z�h��lS��a[�z���f�	~�?:���:\J�,h��sW;���*͂���y�7��Em����,<۰}��s;W9����nBfA�	�����      �      x������ � �      �      x������ � �      �   �  x�����[��L?"y��v�����5/��/����AO�W�z~��W��U��������~=�����J������^/�DB�Dz��z��h��(_/1_/�Zd��j��"�E&�L�h2�d��D�����rh�d��j��!�CV��Y��!�C���rrrrrrrrrrr��~����������� ��
Qo�n�.�����\��!�?�C�5���!��-�[��Lo��2!eBʄ�	i�&�MH�Cj���E3�mz����;�w��*�U�0Va�B�B�B�B�B�B�B�B�B�B��Z��
k֦��c��T��D�D]D=B��"�83E0�f�`k%83E0�[��Lo��2�eBʄ�	i�&�MH�����tg�fz����;�wL��9�U�0Va��X�X�X�X�X�X�X�X�X�X�X��
k�*�M��ǖf
PET�zuu�uf�`�������)��a����Lo��2�ez���	)R&�MH��6!mB�R����"��m�;�wL��1�c�<Va��X��
cbbbbbbbbbb�*�UX��6->{�L��
Qo�n�.���L�\��"�?3E�5���"��-�[��Lo��2!eBʄ�	i�&�MH�Cj��3S3�mz����;�w��*�U�0Va�B�B�B�B�B�B�B�B�B�B��Z��
k֦��c7�����&�&�"�����ř)���3S[�(��)���2�ez����-R&�LH��6!mBڄ�=���;3E0�ۦwL��1�cz��y��X��
c�*�*�*�*�*�*�*�*�*�*�*�UX��VamZ|>��L��
Qo�n�.���L�\��"�?3E�5���"��-�[��Lo��2!eBʄ�	i�&�MH�Cj��3S3�mz����;�w��*�U�0Va�B�B�B�B�B�B�B�B�B�B��Z��
k֦E�)BQ!�M�M�E�#��L!�\������L!l�?3�0�[��Lo��2�eBʄ�	i�&�MH�����t?3�0�ۦwL��1�cz��y��X��
c�*�*�*�*�*�*�*�*�*�*�*�UX��VamZ|>�4S�*�Bԛ�����G�3S#g�F��Ll�g�fz����-�[��LH��2!mBڄ�	i��������Lo��1�cz���;�
c�*�U������������Va��Z��i�A�oڄ*�Bԛ�����G�3S���#�g��?���Q�3S�_�+�[��Lo��2!eBʄ�	i�&�MH�Cj��3S�O�3�cz����;v�c�*�U�0V!V!V!V!V!V!V!V!V!V!Va��Z��
kӢ�꒙"T��D�D]D=B�ߦF.�oS#��)��a���6E0�[��Lo��2�eBʄ�	i�&�MH�����t�)���6�cz����;v�c�*�U�0V!V!V!V!V!V!V!V!V!V!Va��Z��
K��������~$      �   g   x�m���0D�PEHČ�?�
��rXe7��c>N�"�Yg��ܭo�`	��>ٚB���jP�#��T3���d�'��<lͦ!�����Qs�M7��P�8�#�      �     x����q�0D�o��4��� $��T��눜rƟ���.�����3��<���x�׫���8b����]���da�4Y��4������f��0����������0[�T���66i�����$��c�fZ�,f�ffZ�zm���zm稱]� ���o[�m��
˪�,��s��6���28���}$�NR]���$�������4�4�4��~~��0����������0[�T���66i�����$��c�fZ�,f�ffZ�zm���zm稱]� ���o[�m��
˪��
��]8�aaap���(z���"��J!���~���Lf�a�i�i��+�d�Ɍ4�������X���b�2�e�O��˖�Bd�22=TF��{#E d,ޱ@���mN��i�jM����X��b6�4�K	pd�i�i�7�4�0Ӳ����h�8��Q㰷��o[�m�]�mUXV�eUX���������ߏ+���$�&�K��e����=/��4Y�,���}�|����+���޶��yx�      �   �  x������F�\+΁[tu�3�!�;đ�̾_$��=2ZVmPU��cl��������9f��{���~����}��s\_U�Vs$�u3 杜� uG�8o�U���A|���N�G8��p
=�)t�S�=�BGS�󎿃����x~w�
��;�������_�,�~���
�c�㳥x��d�?�����FZv#-�JˮҲ���*,�����?d�:��v����cnGeGoG��c�ScB�KĀŘ�A�K/dL��Na1&cB��),Ƅ@�SX�	���lL��1Y�Ƅy�eL��1��6&lLؘp�2&̧e7Ҳi�UZv��]�eWa�ɘ�y�eL��1a^Ƅ��Kt�Ƅ����1!�%���^"Ș��3��bL,Ƅ@�SX�	���N��)ؘ0/c���	�2&�˘(/c��mLؘ�1�|eL�O�n�e7Ҳ���*-�Jˮ²�1��6&�˘0/c¼�	?���J�	/cB�K/�D�1��g8�ŘX�	�
��Na1&�BGS�1a^�dy�eL��1Q^Ƅ�ۘ�1!`c��ʘ0���H�n�eWi�UZv��]�e'c��mL��1a^Ƅy~-�-�̘�A�Ƥ���Z"
h� ����S�1!`cR��)ؘ�p
6&�BGS�1i�1&�˘4���c��cL���I�2&��cL�O�n�e7Ҳ���*-�Jˮ²{�	��1i�1&�?Ƥ�ǘ��x�fjLx��^"x� �%b��	�?�),�d�bLT8�Ř�p
�1�:���	�2&�ۘ0/c¼���2&|�Ƅ��	�WƄ���FZv#-�JˮҲ���*,;�=oc¼�	�2&�˘���P��Ƥ�X���>T@��
�*�?�),WY,WYT8��*���\e�:����0��,��*��¼��(��,|�WY�*_e�|u�����+��}�>_]eP�������[ Vvt�e��*��¼��0��,�<^��^"x��^"x� �%b��	�?�),�d�bLT8�Ř�p
�1�:���	�2&�ۘ0/c¼���2&|�Ƅ��	�WƄ���FZv#-�JˮҲ���*,;�=oc¼�	�2&�˘��^��O�4� �����O��O��O�?j���A��#�I���m@������3x�y      �   �  x���Mo�6��֯�=솟��C�d�f��^7N��z	��b���=��wH�%ΐ��^;��rh�f��۷���߷�1�?9��h7b�o$���`�8c����\�7��p���oo������W�]c����39\�8w���'f���3��I�vr2���Nk'L>���Ec��{zxyya������������췌�;��I��_��+C�|�蘐N(���M��=��U0T{'x����2�oll��]& �XD��"2�P.�m�e&a�>VX�DX��-�`�!�I�����ӁE���'�y���^�@�%�I�*A�����y��� �(R��{�?�N̰��A;����-Bd��|�����?}�].��|zܳ������08�M"9~�f��!q�����HQΈ��x% ��@�!�RF�QR�	$�5=uM�v��{��<�q:�O��FԣD]�QΉ�$�(���&�}�ˠ�L@�0�,��GL0��/L��U��ě��I���Θ9�M&�I Xʹ0	`�0��W�����d�NA!E�L�I��Y�@���g�tƦ�l����`S�5�4��9��l��f������&l&�ͣeQ3e2�~Y�,��2�����-��������	��Z
��t��6���\���d���n��M�#��B����glU�7�	o��� �m$ǔeL�x�`��/?_�9��R� � �`*��]97�R�!��6$�	Hp�+ ��#�2b�#vD�)� �V�1¶L��΍�L��H��0���+Z��`�	@0�f#u5��αl;J���e�����;PW�N���J9�MG����$$��\e��f|"˞�)�"�A����K�D}�c��o�#	�oh�]`<c�D��|��2B�"�n��e��bH��������(��g%#��eD�eDܷ5��J�Zz�&��hʀ=�Q& ����gp���|m�Ϣe%����5e��x�;�L�(xPT�Yi5��c�h�p�#tA&�|IQ�*�A�I�X�#�'�D���t�|&�&	a�e�r
b�)Bo3K���j�v:��nt��5	�
2������XC�GbF�8"���L�k}�LM�\
F68"^.�L��!���D�t�t)�܈ �~� \P#t��0p����F����$2��A��i����y
u�L{��F���H�-M�f�u9�햱�_Z��;.!>3��L�҄U	���t�d	`aqz��hr@E]��w��Y�H2���� �U�����tec�̻ʥi�`ۋ%�ǮU�v��ʹ�E�JN�|2���骮��Ϲ�VIg�υ9Z��h�NS.�%���>��\�����,z�}�����wtT^�rr�Y�Q�!��\&�
�����c�:�1���q�PL5�)	`��z(��ڍ2��/�}�{�      �   C   x��4�4�N##c]C]C#+S+�b�f\�@M�8ta��2ǡ��]�`�b���� ��l      �      x������ � �      �   w   x��̫�@�a=��pK����5�	�4}|H�����1��u*T�k�>�8PV�RqV�\G�&B�D�����Q����i�&���<�U���{�M8��؜�K�j�׈��q02      �   .  x�m�ё� D�Mi 7$q��:nE��O쌿�x��b̐�%�����(y�N����p�6��#۴1����p5�o3�k��i�Q쪜)S��O�p���]����w��I�S����{�>{ �i���O_ޅ���|H��T�aa�=R���w^B!τ�(�p��-�i��!��ʠ�0�Z��҅!l��e�E�atbT,eb8�����_��+�dbI�a1�b8���J�s����0��ndĤ1���İ��v�1�Ac=')�-���b��8�F!��J�0*1�1ðݨ�`7�ш�1� 	bY�F�0H�X�j�p�$��f�p�JD�e�0�����`%	j�y,�$��f�0��S�{,�dn�*1� �[��Յa��?F��1��)�G�0H�fܰe(����\I�vbo"�c$s��pa$s�R�\�5W3R�k�O��0b�^��<ra1s/���a�̽D��/�3�ҹ��/�3�RǑ��� �+#�$o�l�_d��_
b8���O�C�8�~RJ�
      �   *  x����n�0���S���s�rW�%(���n�#��ɢ�bo����Eo�A��|!�?�u#R��l�C,�T��Ǯ�N{X���v�	B�ew:\
�i�� �B��k��Y��LcJ1�$�,Ģu�G��Yt��������].���CÛ���ѡTf^Gg��z�Б��ލ�c7�{���	cf �k�k
���)
S=����C����o�rՔF����Q��E��펪��CmBH9��!a!��U�`�)�f57uSW��kt�G��C=��݂c��_OB,z�DQ�HE��      �     x����n�0Eg�+�2H�eis� ��H�-k��6����Į�V(���8 D�O�,#�\tÔeK$1��_g��}:}�?2<l�{��6�����#��7wpx����B�P�s�D��e�B�ET<�V�a75�vZ�n�Zh��1��p��X���P(��@�Oه0Kd74�U��/^�R�Ҽ�%\{�e�5��Ui*,��=��c^�.4@�j�Z�� ����A����:!y
�1�5l��S�W�eUa}�u?@��      �   g   x�r�500�52022���Ә���GAW�9���W�����1D��?�߇Ӑ���F� P�������g�'�(0O����������S~I~��!W� a\�      �   �   x�36�r�500�52022����34�56�4�4T�UI-.Q.-(��L-R004�42)��?2@ҧ``ie`heb�gllaba	4����E!0�1(�5�3��Z#�1H��A��&
��+F��� D~'�      �      x������ � �      �      x������ � �      �      x�=�I��:�qj19ER������Xu� ,?G�����S�u�8��/����_L��\\\\\\\\�_���ao����7v��?{5o��[|vܫyc�V��F�ꂺ�.��g?�{�[�����~�������#�,�9�9���ü�y��V��,'�	{&��;ϰ7��@=P������㟌7�c������������ɔ���Օ�;?�X�X�X�X����c���_��*Xs�'M��
|�?~?ɒC��w��+'^9�:�,G_�o� �,}�9�vr`S��o������`W�+EZ��J�V*�2�J�V���������^�JG�t�JG*s�2G*CE��[/￭���]�Ϯ�go�=����#�7�;����q�q�����O��H��H�YrVL�$I�I��H��h�O�?�_́7��-�l=;�4���E�I��]�Ϧ�g�3�����e�L�������7x�'kqX�}oe����3n�Ƹ�f	!�1S1�0	S0G��o��F��n�����ܞrg��%�b�!y��dd(�(M�J�F!GuX���d���7��bq�A| 6�	�bq�7�x�ze��>�/��ߒ�Xb�#.�a���=aO���=aO�ꂺ�nonϏ�����1����pv<D�=�ԈK4�.q�8�y��%י4�_C�ՌS{{{б�I��������X�5�l���#���c�c��+��L�_k�/g�V�O�oQ�Zv��uY�:��9��������t�4�􎴎t�4�􍴍7B�vw�1Q(&X\��`��{��ʕ��_]q<(X\��^q���>*���P�]7O).RlD�{�����x:S��L��s�扞�ڼ�J�0�i�Ӭ�c�<��i$�A�k������K}�sW���];�9��w��=�ȇzPn���S�DS��V�_��ؚ�����[��N'L�K�K�K�K�co�ؚ�u�{k���[3�v��ޚ�5{k����[�4Y(����f<��5*7*����ʍʍʍʍʭU5B7B7B7B7*�����/ԕf�ЍЍЍНn�ʍ�� t#t#t#t���fDh��\�Xf��b��2�e�3����>sHYZ��K��x;��`�&>�2�g#��ݏ���Q���Cf44444�\Wr_���][�rq�}55b?���f��KC�C�C����(ɰg0fp����ʝI��8�����Ɋh���-[�H�_#��~m(nn$/�`��p�!�!��7p�A�YYg.t�يm9�A�q0�̃̃̃�̃̃̃̃̃�se��+ϹDʀ؃؃؃؃؃؃؃؃�s�
��g;�;*��OX��k�����|2^N��>���aa�B���5ʬ\�~}s%��܌a�a�B�e��,X4�h`u�հ4�h`�������%,JX��&w����,���b�0�D��[aN,W����{yr�G��>^-�XT�X�r��*5�Ž�{���y���|���.�v��ˇ]���Y�o��?��?b��      �   �   x���K
�0D��)|I�|�Bp�x�؁\�-]���1f�!�{.p��hrZ&�,�C��YRr,�my�rp�߹C������Ĳ�!��6�����I�Wbq��ǐھΗ��&�LJ�r�cx�!��-_�      �   �  x���ݎ�0ǯ�S����ѻ*EL�l6���=�$��}�3 &��HT�)���t:��l{(Ϙ0t�������A��B��I�c��B_(��I*$u'�K!�e_I�%�gI�J�[��,ɹ�DKϒ�����M(�-��%aR��x!$���(L�ЊP���	Z;�?�����x�|����XІ":��l�5Ǡ�\g�7נ�\{�����䚒�9�i��b��i
WA
�5�܃�W)�No(_�Dw�ق^Z���v��wS"�O"F䜋�E�����������Z�I��0I�-��v�k �M#p��l��k��x��g�xӞ1��2�<�C��.�b��4X �V����d#�.R�e��b��VQ�[�)��.��}�TI�,P�n�q��3r=IFlO(�˹���S����50y3]���VJ�(
B��*c&��a=GlS���
B�:�=��K��	�G�U�
�B�~c�l������
Ov?���iٞ>����q]4<i;����^̖x�L�6��j/ʏ�o�����p�ƿx�p\}V���Q�u�~웆ƽ��ð�$��.�f�aU$*p��yk+�h���8OB���]�r��آ��'��1�����֓��b��ھ.����=���*<�_��λ��>�,�a�      �      x���ksܸ�&�Y��8���J��FYe����.��Gl���ZRɡ�����7$��@bc㝙��ݙG�@ y{�I-�%��w!�]����?�|���2���&'�����������-��F-!��*�˿~����?�/�O�w��wRV��.�?��`�ҖR��ʜ(YV�r\V5.K	g*���6���*^���������x�q_�~�`M�l�yՅ����|�U�6�ɉ�E�*�"ݸ�J4�үq�������*>u�Uw����(/`O�TH�?[��1�h�%+KU�ۧƥ��X��K�:��=�����a_<��|���������P�w�������P�J�I�N�U�u]�O��D�A��he�b"�Ϩ��W�*)����o��vQ��La�h�?M\�:�'�^Z}PM�*]�$K����	�ha�_�|�Zt���u�v�������{��yx{��|�����������p3E���
�񷇨?�a���;l�02|#��e-DmlNļ0��q1���4�ڦ?�wp�?��u����wZ�/�EM0�A�J���ȉ��/RW�֦U-*����ӟ�p;^��
m�o/�sB��u폲��quN�|�X�{�ؙ~u������d�ͺiѭ7ݪ�i7�
6&Xfs�S�_�8|-Lc�IE�*S�q�f\d#S���κEo�t�n`����ۡ]l�Uqٮ��u!Eq�\_�w�:7�d��'¢�(k]I��$w9�8^f;^f#��d7O�O�tw�sWL���E�w���������y����NV��rk�EFs��F�q'!RI���ߠ�B�wJQ��\���p��i����cN��7��՗n�N6|h���RK��4�!�h�]��c?	�^��E� jJ�*FG��:��9kx�D��>�}��/~�^v�ů��_O�m|�h���Y�m�,~����霈�3�
ci�0N�[�������5eo\�����c�k04��`���qM��*x����ږu���>�"�<U�_UI�1��8�U|���k[|]^�_o'��> p��7|�:����~����	���Eh�K�PMp2a���'C�R�F����������/��7א�O�{�AV��wMx�Sw�#Π+0a�� �n7[o�ǌ{�7����r"� *�3 �|Y�3��� �;�6(�L)���MNę�H��;��ld��wY~m<N����㴘��~S��~���|X�O3��
�H�X�Pt�ć*܇��05�mW���d>�
�x2k�D�Y�'���~i|D�ۏ���S�$Ȧ
O=1��wp�u���PgEɳ���6��dd<a��ד�5:+eq{w���{���x���;X���k�$9��{qo�PU媜��"�� Kp�p�A^uL��3�a��{���vS̺����ng�E���痍&�,�J9�s"fٱ
��|2.��[�s8�U���_����+�M.�;[\o�p�է?ͅ>���Ȩ��(���D��S���vB�Z�������X�={{�g��s�P���#B
p���D�PN�qo\��8��Y=<!O����Ï����y���i��w*�?hW�#�ɉÛ�0w���O�fm���`񵅠a��ڂ��.f����_��&�}���(��������x{FT��n���;�l�b��G��r2�`����d]\�Zx������v�ia0�QUh�b�"?H�/�2��>p,�K��)k;�y��̽u�� ��v��崫n����X�Uҁ�DQ�1��xS�#����q�-8-fp�/�_�ߊ���=<��T���{���P�[&�?�8Z}�Ǿ���Ȝ(��T%^��\j��׻��,�x'������
�
°(1�U����}�����-�������F/����H��^��&��4�$��솨�������1���=�rgH�L��p�����sDD�'��J��C�?�:k0K�w�ُ�|0�T��t�qCљ����2����a��_�_4yZ�BF��h�TN�g�
�/S�n���v�Wp�]�o��Gw���ӏ�?_�u�0��9Q+�U��?�D�=��1�baa?�$b��u�֟�!�N?-h<W: �G�!�1q����}%*l�C#�9��OO�����Ȣ�.'�Q�܃!�w��/ڗ�=��!`��Z���u�0��q�ˉ�L�Jj�������v��Fp}}��q;�ޢ��Zd���`�}e��t�y\"⓵D����X��/h��g��7h'�	�M	ަj2�d)�Fz���!�]`���������x��S��i�G�W�1����nr"n��J�W��fV�;8����};�w�}o��w�̟^��??��{�ä�~wZ:8.:�������E��+gTƕ듇�X��-,Ĝ�̷+�k/4A��ϐ�Y�����D�	�U���< `��s�|�d}Z�<�IT�ux����56'J��T%9������s⍼�$	�<Fk�X1�v6'br�Jb�U�}5��h��qoݷ�e�ٶ>i%�7KG�.������#�ET�{������]��_������g��6IF��6�s��V��3��
Ճl�L����������%��v��0���=��3����P/T6|2Q���J��-����brr_��lQ�ۏ���]��m檡��Ù�����Dt����P;d���ԙ�@4 7�.!p������D*�b,</�f}��d�Sp�ٲ�]��k���_����0̂��zMIeE���
��F��m�����肃L䐜�5��� [W�Qojj��_�|�с?���0�C�d�le�1�����>*��qX��@�*R^IE<ց��X�<}<���M�P�Ɔ%Z�>�(�u����Z�� V�����	�?4������_ꏧ�g�)v�w�⯧��^
|͆xd��X���	�T��c��)k|bQ���xҒ�5ֵ>k4Õ�lP��.����a�'��������糷�u�i(�17	��aUۜ��#�t}�;BDZ�>Y\=�/Cos�L,>�����	<���J�D���Tb���J�ᵜO�ɢ�4��'�\~\�.�;D��G�'FL���G��D����.E-pC���j������~�����7�QaVq��	�<G2��z�T���2����vW�Y���¤�_w�{�iK�N:js'�/X|+j��ʉΔ;C��	R��&��<kpxV݀1P����0�T�Ъ�tN�_����˵�7�8A��M���8�y��Xb ��Ϡ�
��79�E*\�����_��?�c���R�?��A�
?V]
S���NE�2c�t�C�r,k��E�n�zh�κ���	�A9��d���|88yMN�Û�Jz���&<���fY�_��P��
UM҅���5f��8��%�KU�ta�)}n��h��t��'��z�(>H�Φ��ِ�d�/���D�J��H5��3B[9�Æ���.���1m�|Y.�S�w�:d\�Rr�^
t �G�����	QI*��3��_���+�_޾�����(B���Ǯ0�����:�^"H�@p�8dMN���
�^6B�*��v��^�7}���o�tr�������E�{�%��&��
�, U]�Dg�ܡ
�(m�HqL�6�;�{�g�{7��|O"�\Z���ɉ��(QaA$`��E^��~z-./7k1UMj+t-
Au���ޫ̉�eF*	S���м۬ڢ������v՘��k�ڣ0�к����dU�/��0�Ж��݃�@x?�*e��+�H�W,�H.^�o�ś���p`w����V��k��+V�Ճ�X�j@�꺴��_����#�ԢV`j����������!J��|�Gh�PhV�A��KSWNǕ6"�+mD��fA̮H�j��[<��j��DR�i��-��	���������l�̉xTQI�1��>�ş���MvQ� JB�oM`��_Qa����_��=����hI�>��|�~9f��ˉx7��0%� Ž�    �x_LV���0�v�½Ʋ!�m�����+hj؂�(��dNħ4�
�{����\��[6 ����qUMEg�ߡJ�e
\cku�/ݔ��Mw�-z<�%2Ɠ(�v�[6���$D��I�
�'QnH\������v�Arc���1.�F�a�ԕq��D�a#*\a���ʴ�r�����ѡs��
�b`t�Q:�lD"n��
�L.{�p^n�	��S�i�̭R��ZW6':�T�*l�U��]�V_`�R�s�J�k��,a1�����5IEg:�B���`N�`e>Xt��N�I4�m��[��{�J�0��8���V�mm}�j��Z~�BÛ�-��[�RU��:'�q��������x����{�/��EU`G�O��(���	����V���~��+� �#��69��+/y�+�&=Ə8�bGJ��~F�<�
�[.L��#�Z��P�����èJ�}�eS�q�.R��0
��!�����X�����z�|l���L����MeM\5&"�JTت�Qjl)�����bT�
��&%(�T�_��v�����(McB�*��؍���)gstV�0�l.�?��-U�Z�j�����hD*��;�X�s�-�|7X�����IM˘I���I���t�љ�C��g�$�;cۢ[\�7�S������^w_�eYT��!|�ZHҾ����O&���5NE�&G*L����ǣ�&���N����)-�"�lDTR�B�;T[/����YaaXt'�V�߻�,��bS�k�J��m�B�	�i;�fc���]�۾z��L�1|�>��\TMN���D�����7��U�qfC��>�`��Dqm�vY���t?���F��]Ϗ��[,) >wS[��v�����F��&-'����G*�n/�>v�޴�Vy~?i���}��J��6.�C�ټ�I%������3vkH1����8&��6���+�"n#n�����Y�.6K�ܿ|W��G� -U��}�e%�6�D�8�BZ�D>�NN�z�[�b��V�xk[�꞊8�l���b4�.D�6�4��>�0`phJ	�Ɋ�&�H%�9k��� l���)밮kI�����.\�0�KE�*RI����jl�Eۻ(��O�n2�ۀ��e7+�^�l�1��� &8��LU�D\e7R�$�~����� x�ޓ�ʟo�o��Ϊ ��Bs|����KfEg�9�
��Cl�vݍ���ܱ�`<^���59W��T�1�ۇ����&ʱ<�������bϗ�_=(�?�#���A�w�H[���'Qy�@�HA��� �����'`L�{��^������c�}R��:'�#��>F`RN�sՐR��E
Y�J7.N���N��!v� �}��j�)�d�����ᇦΉ���T��������uhY/H��5j��cLD��%*I9���K=�����&$���3�hl���<����z �S�����:��	��3��r6h�`D�ňTR�	+�y��n`0V���wU��%�J߆*�w�+��S��⤁��U��L��� 6k8Tj ;=����o�.�y��n���<U�̉V��\3��^ȶU�K�5l�U��#a�����$L&e��ᒂ&h����dW���3qo���bl�RCh�$=��' CdU�"#��=aR�J�D�}�T�E��������ǲ�e$ˣn�C*e��q>������
Yj��a����ļ���z:Yu��ס��an��DR>�'���������J����$툪r3�v�y��^�G�����`��_{�&H�Dq^�����zl¸�\MRԗ5��
=�zp��ה��8Qa�q�����>�36W�19�����
�*��D�[\��Z\Y��N�{QEO+�yR�&�"�"����5�|�!q�~��v��L���%�ki<</��]N��R����`B�Pc#vI���~�y~}+�7�/��>�=�;�����v�C�ɴ�-z� v���F��"�5�`����t0H����{���C��؁���|��}o����d\A�`HU6�TdDg�IB�
���_��,ГV��;�����c�ˑ#���(�l*:���c!��yu�w1 �?���Ά��Šg�ax|˪ʉx�3QaA��w5�s�wf�mF"�+'({��T>|�Yct��>��8�D���>
�l/'��7����r�.��d��o;���H�aO��+��b�b��Bz a/m3 v��Sxv[�DPp���r_�3���H�3�@�euN��D�Ej�f��v�~+�%�U4�X_~��͚`eyM�Oh��*�s"���T��Hl �Ձ����m�����;nx�����t��IE�'*�%� �Ǜ��|�-�-�R�ʨ:|@So��
k��h$}q1L���?���nA�]F���C������]�3� '��	lm�4憢3���
ۘw��7�4��t���w/������o�`���l�������^v��{�o��UHD��HYC��tX"ME�5RI]���"~���j苽�|���6�Lᒕ�1�$���?D�)�I��ܛ�Xw�V9���!&C��'���9�b�P%MZ@�x�)_oמ��s^�0E�ɪz �g�Z�YW*�T�Uy���8f��H�@B$��o���4�jD�q�����^l���������lh[�I��81�8�uc��ELE\�J��>�p;�9ގ�����|;\����(��#��x�������qMM_O��GJ!�D@U*�D�C`Oy�������ɦo�4���}��x!�ntFc�c��A,�=�\u�'%;�kcB�ܻ:��/�s��;JW��9w"�d�5D4�P���K_}E�v2�D���-��������	-2�z,�׏,�R7UN�#�
�)�C�*���S*�� ��Yrx#l�D|�0��6CŦ�w=v��y='�g���&������r�3�P����!3z?���vu���W����t��OE����7ځ-���vl=���ֆ ��t��'�6*'�3�D��@�ژ��y����U�vW�I춥@ME�B���em]��R0F*��4B�j�N�lW���'�GiÂCD�uP����5Ӟ/��we�J$#���$�Ra��)~�=�=�~A��X~����TE���d�������>��x*���L�%�����u�K~}_��zzؽ��������Q5��=�ժ�H�X�jp����2��%��;�(|��;x�K�?��οM�H�>��	�3���	U�fQv�e@����[����@����_����A��*����9�u!�.+���a-�D3�3ЈP��F�C	q�-#k��AK��ӛ��j��ΐ�*�D����oZx�^2�!lH���`jd۲�Y�r">b *��aM=�~|�κ�����ٚ@�WK`U�������m�0f(��f���p�	f���������/�7����#�}��Ò�	�4wYj�Mcy���W�qF<RI�4��������f��_��ty듒& 䎀Fb�Rk'�8h$"���7<t�l��K���c�e���x�x$0�M���"޿%*���ȿ����ª���G��f��w�"�-�C�hN������V~
�b��|�N����������!���?ch]b��69�X���8�w���n�^��Jq��UbAY�î[�Zy?К�v&'��\��.����n{�{�IP�[:2[����Q{,���u�:=�ȅ��*	jr�|�:0
�)')��OR���a
o�����qY��1˺+X;�J�#�:'���º+�1����G̋>���}�.f�S
�c�H��ʉx�=��Ig�\n�κOE\ޗ��;��o�h���tN�?�D�}��ܼ�"�~�>¤:΀r�JVa�ĩ�����ׯ붝�۾|N[���`\���6':cB�,���].�Ͼ]�\�ˀ��	��^ў�T    �W��
��k h?l�ӡ5��9T�=Z�[~�7sxE��p/+2󐐞�~�!��:D�"ƣ�URz.�a�i��C�~~8v,K�h�7�w�����rI�|(:�5��]���5��h��G�q�����f$��O5�wix��z�u����~��=����U�����$���
4����5����f���7����_�+������Ak���06"Ȃ��e;]YLy����Gx7�H�r"T��c���<d䟟������x�T��ُKA���L���y�M8D����gI�Ot��2����v%S	��5�O4QI/��TAώ3Sq�E�(�9¶��x�5Qa��%�'�ӨՉ�r���RdΘ�{fq$��I�����V��v�c�ѧ$�(xk�m�����
(�+=�������uN�y&�J��j�@/-Ɔ�A������|�z�G�9B�Տ[1�p�
/#�X""��l	��͐��,oۛ�8�6�~���'o��0�Nh�}�$���K*�(:�F��?mN��M�n��%�׷��@�L�>��~ϘQcˡ����Pt�30Ta�������NVۃ��pK�����di�/#�<��!|�q\�b��w�f�����p���7� 2\����!�̉x.I�E�qn���qO���λ�T�QuA3S$��׊&+�{��Jғ�����#�����?��?�����P��O.�s�kw@ZA�BJj���n��X[QG����/��F/�J��~j;l/���ll�KJ��(����/���₞gօkY9W�:'�s�D�+�����V�V�����(�_79љ��P����qt��w:��mg�����z*L
5!P��q^#,Ϙ:�bDgXBf�iU�?�7��?~�k�3�Íh�h��J�([��3IT�3i*y��
��j�y2��!&AaG��0�1O<�����.'�x��>�(��M��N�AЊbb?�oWT�VQ> �~8Qa�p����'΅����=hՐ"x*⑝D�����9T�/���������ñv�;&�c"�cJ�R`�r���V'�4��x�ɚOVW�i;��q')TV��Ӕu�W*�64Ra�����O��Gp���{xڰ��5*����)}̈�Z#Q�k���F�C�х�r�z�`!��O,�A���$�%�-c)b���4\ߏZЗ����^�_��t���t��X\��]��	&��$*l������V�m���c�SZ��1�Z"�ڪZ%#����.�m 6<�/Ir+${��	�cg-؜(!�JU��R�?r����]ד4��D�!^5�ULD|ن��K
�SQh=�\;��p�e��k<
~S$pUm\N�%^#.��$��1��{�I�!n	�N�i P����	�1D���c�g>�^w
c���4�p�h�i�8E��`��W!�T��H�+�� �':���g�8re�������l3���b*�hS���������r2]���v5	�2��J�k$gA��4
�Mi�>\N�A�#�$t$:�(����^��zR�[偤G��	%���{�#.� ��E��c&Y4��]�
��ʖ�ӵ�C"����.
YA�0a>�n��^O�z�Ű�(v^zP�Ue%tU���1Ʊ
�4rD}L��X;&��I�LaȆ&�F>�����D�cS���Wf�|���f���<엓ռ[��~�a�:�'��yU)j]�uNt&�U�uc�?��DV:�̺Y�����oW�.�5�;������;�t�D���+u��WC7��GY�l��'���������-6����;��(2�(*��)�
��MF�9�T���;�h���*氬���Ay��~?�޽���at�lB�(&_
����fE|Ɣ��)S�����嬻阤i���%@��<�sZU�ۍE|�'Q᪀8�����o����ۿ�R�
�ባaZ����Nʓ��L}2T�td�����d�=������	����3�6�@��>�x"fׂ�e�̘�,M]7	����Q��+�$��nގ���������������,L�q�H�k�vG��a�_&W���ب����Nnc,�K�"����b q��t��}(�����Ʃ���)���6�����Ng������w��*�XLz2��i�TMNt�]3TI}�z;b׫�`I�Ax�g(x�]����3-=��v��m�<|�`��v��=�^���_���u�
��U��S(H�G���0���21"5�0�y�{��֓�ș�dC<a��ti���*'b��J�6c}"�ӠHi�0#�T��,v��DT8N��xd2>dx���7=#9�2��	Qa�.,�I��.��?��B#��v���Y���_]�I���=�����r;�2UY���.'�9QI��-R��#�'��M���a'�Ȱ��������4!}#:��U�|�r+�n�e���}�E�IQy�<ӹ��ۀ��q�l��n(��F�xo���?�q����G_�9&T��(���d���dkV+��D|I��p�EmmC�HҰ�@9��y���������J�^#zM�:����,������ЁM��
�J
Y"Mm]N�EW�
]=�|Y�[�.�v�6���o�pS9�AQp-�j ��*Q9��������G���	�ҟ�ފ��l��������rẊ�0R��Y+&��j�%����H1�$��!��3L'�n����v�,Bs��v��a}3���P��r�[.��c7��J����H��E�S�r"��$�I������m�]wW=�q�_g��IO���=^�GV����oh�+]�q�^��E������J��z��q�����#7w/��xiJ��k�ZA���=���n�¤t=m�*�u1��,��&u�7�O��?��r��	g*:sJC��3Z����M�%���pJ���-�ȧN@K�b��j�Ϭ�
g�1"��T8�X��siX���G���J�D�1}lZ�xۨ��{�"����)׷�u�+��a��q��zxJ��,�8U�nw�U����&':��
UX���Nt;7��lh� ����g������D	�HĹs�J��k��R5$y+��KX%ܩ9��eҭ0���n7�����B6�
G�κh�l$�cx��ݯF�M���=���VQJ&�t*�=S
Y��7��[e��e��ך\}ŗ�Ϝ	G΄�^��R ���1�KD�gE�>�|�����=ڴ#5���<�'�|������,v/ψa����?����� �a���*[�A����1�Tƥ��R�C�����k��y_�<��=���R�w���N��+�3�5F�6':�Uxȝ9A�z�VjU���)��[I����Y
58H�����8Y,lm����w�m�WW� i�ya��U�cU%j�q/W�½\H�K^.x��r;���&ם���1��ޱkp�V���B��������d��RXD�@�τ�[	��d	�r".@�T�F;0>��Zd�?U!�a2٣����JR�".1���\��={j�z{�~����#��1�% $��!�V#w�܍A:�%'8UI3����C�k�
�J3�����D�J���Tt��pf$0�֛�~jW�$nײ�3��a����KD�KT� ��f���Zx�p����rւ��AN7?*����}�.��u@�ˈ8v�H%M�"^TC޴�l[?��� �2R���Q�S+��j����'��z�(|ZEV!F� ���dazN�Mmm��È��$RI�;��8mWn��D�w�?�S���"_uA8bS׆�˩0�C~6C�+<����
6�a3��!���ã�	F�MC�FL�	s?3�S���������jQ�^��{���~�����Q/Ph�kr |=��НҢ/��DL�?VI@��O%��Z�gpW�{R�nF*i)����]�@�8�9+pyL��<9��"*i����S�/������    tD-�o6����5~/�nl�������x1��s*YB�X���$�3m��
�6����)�!���J��i��yDI]�w�+�qE�H%��X�����MV�a���{s��'dq�gy�k�?���h���éڅ�T��C�J�Z|�*5��������P�ipn<�6���D�#��
z������m[�!JkW<�U6��"�y܀ʷ��j
�q���Xp�N��n1Y�M�����f�򱑒u����8X����g"�<�H%�~��%<W��v�����#L�����'6m����XE��B�CXb*⢣H����h~��j4pd�:�]����)3d���X�!�`!"�UN��#��r����������0\��b񕑞CNԦ29��*�F���z��Ww����ݏ��޳�Ta�'���O��djU?��|!���(#����gB�S7t�?��]�}�p��g�F#���� �G���<�i&U�n�ZG@ݴ�Eצ�Hgh������8���~��&��?+N��7���O,�����������Y�@��.�Ǒ��e����tTV���D<���0�m�/N4���k;�³y��|5�We��U#�K�\��O�0k�96�U1�Ͽ�[���=���o�'�;e-�x�U�J}*�SD�M�"cz��c�bR��C5��hӅЍT���C���O�,<M����ZD�c�^Hxք�݅�DxkXVLE�1�T��!��t�a��^u��(qX����X �S���aD<�������D5�	���~.mt����ᒔc�P�a]Gyl�0��4��N��TV �Ur�d�����z�{�y����q_�ؿ�=�F�����u�|�v���=�~�.�Gtf^��*�T6&x'"�="*��FZ���@f�˱���}��xX����$��s">5LT8�B�1�\l�ź-����$�V9��'���BWW�Dg��N*�^E�D{��b:��_��n@����(�%�j� BV�HE\"!RIo����p՛�S׳2�3F� GD��)���E:����C F*i�Hb����������xS�{]i�qY�H��
(=���H�]ܿ�!�c;�$oAs����*�+�E|�$QIP8�c������?���g�fO��C��t���y<�r8�&�S`D��T�3�٠�_�� ~N�"3�.��}(��!�:'�nh����"iv	��|���'ԚwZ�󫪆!v�c1uNė�J�*���o]���o���q�����������a2xP\�͉�c�p��>D���g���aN�x��awx݃y{������W��򕈕|�y^�j�޾{#��"׹m<���*�^D�k���߄ܳ��x{x��=7� �	�8�ެ|��U9�AT88'����O�[r�]��v��������c��x̺vZ�U="��q���鲄 5ƫ�l�z�~���b�fyjGCE�D��=
�1�2���x�,Q����{K}�#��"�����/p��m���?����OiHM��)���m�C��hF�s���lw���_]'��&W�~\��b�o<�u���Z��~m����LKT�·D��X�Gi7���0�%��h�#s�!;!#:�ywRa�hj����vikC(�.L�ƪgijg+��pY��B"�N��zD��ǔ���ʆ��ϡ
G�z��$�Y8�q��H%�A���w#��n̠~(�����4��7��E��%W8;��:�j��?�k�0֪q�	v��V-j۔,5��Dg�HB���h}\�T&׃c<k�(�N˨����#�<��4yֱ#k�B�N'��:�(I�W�b���F�*+���
r�D�}D�ˠ��kl���&��Pt����<��cZ��=o$�)��W/�--8�1* �𴑡���y��c����ށ��c�B�3���#�1��AQI�b����I���}���e��_Fn[���ԈCn]�TC��c{�@j"�{�u�kİt�XzG:sI�C��� Y
��fN���D��o�@u�ߟ�I�tM���ea�]��EDg걡
[�c�su3T��R�5�����ۛ�vNR�J,:c�B��,:����4�'���G��4UX�N$��H?c�c�Չt�Z�p�ĠD_Ǒ�&7	�pP�t%��aT�)d�M�#E1�R+dNĳf_��I�V�	|��� ��Ήr��A�ǽ�!q��[^���?w>0>�`|ti*��Q��$��l������
��r�'�vH`��O��Ni/V8�=)�bb�!�Y���ɩ�x,T�
�ºwV�`���[�3)�|�m뺩mN�]�H�)�atsj^���љX}�l����X\���\�+5ٕb�L��7��_)QaW
���a9]��E�Y*A���{온�˧��<|��#~��Gʠ�}�y���ۡO����c�DFaN���P�ōX�}j�����ᔠ�PhD����(U�!�.!Q���֦�3��k���N��P��9�(�L,�B�H�+N;t���ǧ�U�w��H����}]�X�:�S�4�쵃��D�+RI]��O�<�됚0ݶ�̍c� �v9�� *ܶ5`@�E�v����綸��х]|�f�c]�c	E�*쀾	��a9-�8��V.�U0"��@T�Ԃ��ih
�℠����>Q�����4�)10��霈�&/mm�����n��Ŭ���ȯۙ'��0��6���'���m���zUƅ�W=�U���u#!��Η��R�ј≈b:\F%YN;��-緳�t= � ��Ź��1i���a��ra�#��D%=�~b� ˂7�z;��"�=Yܿ� AeI-��6ma߹q��r�3�P%��a�K�����퀵����ϻ�E�����C�i�l�`9�r"��D*\�k�m���=���~_D�9�m��uF��M�j��4=@��D���pIYę�'�'yy{3���(X2x!�Cr���b4��L5C�b�,ns�3���
Gi��C�k�K~��z�t��������i5:N���>Փ
�����mA򞞄��B���z*��P�J��B��{�܈�O�b���B};��~��^��/�7�<��÷���u�P�R�
C��Cԋ) [��(8D��s�3-i�
��
�U���q��v��0��_z�uqL��<�? c��u�|��y_�������������!�&��D���S���`�ʉ�@�C&�$�1��y��aſ��Kק��0+����BF7|���,BD|�����#�t�>
�Z���}!�K!�&�D\�0Ra�pǆL�ԓ׌��!ncYBxV�|����n����L_ L�D��Է��CNF����Ei���D\/x�����ʌ&��\`�U�,����z�aNU�oIE<�Q�+�������j��y9��L�
��$ix���b��ꃟ]����6E*i�R8�w$ ���b����a�]BQ���p��S1W^$���D��(@�LM�����LM;~����Q�4u��%|�.���*m��(Ԉ���(M���u�S��Qn�J8o�j�kEX��|��`u<���IQJY���N|��-ȸ�T�yI�J�U���cM����Ԓ9��^�)�19'*�}O^�9���$=�ԑr�U�	OH�������qJ���\����!dl@�x��О����-��$CO./�}̄�MU59���*)^l�TC^k=YO��i��9�Ey�u_��������e�X�V�C�G�	���������� �9M�t�-��'5���w4��j��i�L�Ѯ�?ڛ�ÎV�d��cel�1��r�3(�P�{e4D��C=�k0|���e@�Ջ6�K��a�M!�c �-�6�T��H�3��r!v����˾����YM��K��(��gp9:*q��J�B��orFOmr�ġ' h�H��Q}�*!� '֏��A�����DL\�����+�A	����q��UM��zx|9p�j��i	U�c+�r� <WKx6�+���N����.    ���
CM�>(&��H���Z�NU9�D*\���S60m���*~���-�iR����mQ�D<t���L��q��x��_bw�]|m���l�cf1cG�Az�	hp�l-	�S"��D��C>c\�_1d_L�u9k���Y�𞬋�n1��u���yq��;�	&5B�₄��ɉ�tp�*BU O������hqC<��m�5U]'�":��U�fo;6s\yxow���y�r��Hꐍ6��T���n���HćD�邓Bc1\���d�Ӣ���8N>J�Hz�z�J4���Q�SP��Q�'T�S�dC���N��5���S�&6�}�����ʊ�Ѓ�pUM7�H�>Gy�gkH�#њ J�B��������"��5�b�qL��=J���u;���9�">͈����I�;��q�*��pB�d(1�֎���m��O�2��Q���AT����#"�h���=�,3���ot�uq�V<�~<������-ŏ�/#���3)���Eq�������"`�5�cA�K����?��F��'X�a �F�(e�$ܫD5ҕc�Y�V>o�Ū���ƙE�>a���O�>�f�jE��+,�W� ]Q��DE݄�0�S�_D4��j���~{ٽ?��^��x�����c���KL�C�k_O�%Y�Fq��Z�e�0�C��򃪇���n(��v?���~><!�E��r�n~�+�!6�6`D<�Qa����8%�]��@0�k]79W��T����ט%=������X�IK����LE6Tax đ$g��R�F��t ����������3�?֧: �4�Ή��E���mx�C7)fo����}�鵏�qNFUڦ1M�2�δ�*��բ1�i�+�i��z�M�AȰy:H&�e�%��2�lɉ�O�pΥE����]��ߣ~$�S��҇ �&�*J2c����nl#��A;�*	~������vS�<�+?z�w���Mx��Q��\-�{"���8�o���b�$��4>nh�Is�52|Yv��D���p�xk�&)���rS���!=r��?O�)o��z	�Z���20XB�S85>� K+Ad�"��)R�H��|�Ý"��G����"�?Q�;i<�.'ⷖ�p��VT���E���|�S{Jcq�hN���H�k�RҪ`�����d>���fı�D<[Q�z2����(s;�w�4"�/�=6>�%2�R�t�AEN��q9��
G{$p���}�Kt���ho�j�Y�o�t3�HHۃ/)Z�,C�<��n�*iT[!$^]�u���#��pi<&��ɴ:��+J�2��vMaB��Z�1P�X%���"�ϯ����J�~�O5��=�t�l̢�!rZ�D|�@T́���!C8���n�n�cƄ�}#�^(o��j$�ɉ8S�����߽�n���C'�dE��4�������HV�q�a��E�y��v/��_w� h//�?pqQ������(d�L�#�/�.+e�Ȋ��(R��#�:8����Y��u�׫�[�s�L�*q�N��g��9��H���8���ۏ�V�p�;�@��d�d}^�As�s�����88���Ï�F(��#|랡�aw�V�X��߀,(]��42����D���po���િ�=�<,��FZ�ȁ�g��R֟.J\�@��p��+^�����4�/鈤�:�h�����aK�,DRQ�2�MvD���;q$��6�$�i��p��+�TU�� �����
�+�N,M೟~Ä����!o��u8o(q�H�a}�d�86��_n�\�l�ZBx�.����B#�"���ܫ]���G��'��]���� ��!;	[-���LR8J":�<�pa�6R7CK�l�$M���l��Q�:4,�?�� ����APH6-�I�@t 	!S��P�)���>�9,07p�}���&���(��g�#�*障��+�Jj��!��m�?�k�-��w���Eo}�b� ��
	��Q9љ�P��8�����{>�?�)7�Eo�U7�9����<TIzqT>�Z��\H��G�O�M��o�1�B��*����u!�#љK��7��vvbv9me��@��bzdtut�u-]��- �T���_ހ���%�/�cΊ��]a�R,��҇��O���Uޤ`oy�`N͈��*�#I����=��x�0�*�y�]�#���u
np݈��s���W'���~j$lPG���Xp���Va�K�D���T��2�f�$��z$擄i�C@�D��:d�`DgP�
���6�P����i\*jf(�p���'�5*'���"����'b�մ�v�-�pV}���=U.$}3�-�
v��D��HT8$��B����x��}��v��]�;I�?hFܡ�jl	_��p���v�U��ߌ0�C��5Qkr;z2���-6��{԰�����_rѼ-:����׌�'�����ʉ�B����NTC����ӳ¿@<���"��=�}�������/���2���Y{j��T�u/D*\+=���]�� c�v�ל��(]f%��%T��<k�*��9�CB��4���>�taGU:�
`K+cr����Q�Z��i�>m�m�������OOo�{�.L�0�Y�����kr">5KT��,2��ؾn���v��f8���GP���#>� ã�!F GZ2dD\}*RI�S`?� �4���E���R����4����?˷%�����T�ש�J���ĉ�GOª!�n���3҇S���a��)mm��4��#*���;ᶺ�7m�>�s�� �쀉&E�"�����N��:L�'_�Z�6`�9,:�"��$*LǗ�ɚ��S�ͻ!��LÞ������� �j��D\�#RI�;0�`��fچz�#�m�PX�ÞF�s39�KOT8H���8�/����R���{�/��	�hY7��4�YUBW.'�a�D��=*Snɧ=��<��L �"��8�V���OECF�rt���)�6����S{���eq���a�5���̹>�����^\���79D���1&쌵!�<a���+�Wj��.�i��@�8&��M7����|5�	u{J?E�����ޮ���vt�h,�Z"._-����n>f�
��3(=��]��19�"*i駂�Ru�o{O��q�92��iV�2!�['':Ӭ���jc��|�Zw�]Md��
�<q�N�ˉ� 3RaH&E����O���@z��&(�=ջ��^�y�=�<��0��HxHV��f\�M�bx/�u��L����*��� ��{��Sg�#n�Z�!f�,7�#=q0ۄLLxȕ�t�}fr"�xAT��'f�1��^.|��j�^z"���&��s|�F瘕	�~շʁq�������)h��N�:�[%߅SC��.Nޅ�vR�%"��KTت���W8��7�����r�^#XL�b}��wӅ�;H�Kz7�ù�b���D\>0RIW�,�N�Աl��ɗvp,e�H��&	k�Q`iI?������J��W�� �G�������]�������k��nx�{'C��#e����H�� �?>?�w��=�>~¿��{�	���w�w������C���PER|jl��}u5�R�Dܯ����՞�����o��r��k2R��Nz��v%x�F���ǟ��w�H�=$n�G9싿q#�H��~��C~�ݾx�{��)����q&G��Bc�͂�T	��u'f�Oc�����wJ��OO�=�I��쭝RMN�|�X�sVC��xق��Z���2�Ibp5�� �MHږ�x\Qaq5��^j������l.������8��{X$Ƥб,%z �U:S���qZE&n���Mr�a!C{�)Wz�p����la c^��,"������H:?��K�D*IYD6�(7��A7��޿��#���Sh���)��<6'�#�
êɐ���{R��ϷÎ��:o���?�z��l�4x"�7_o"*|��9R��o����uXω�
pO|�QA �x�DĻ�D��*Ъ��QG���4C�TE�!�˨M%tN��Kb�*���    ���2Y\}�v�l?O2V[�Ow��w������D< Qa����JL�<>�_��V�/��V�Ë�oş����@�V�����ml�C��Tħ��J��#�a�{ �g}�, �w�y����ښ����<Qaxl���һ���~�ր�&��~����������W��O�x�Qb��Q���.��hB�D�*R�Z�m��=��cYkh������ �l�'M��J�X�Tt&[����J�(�(G�6Ʒ�C,f�U&':��pYC�_���E	N��p�v�B�\
�IjtZ���&s"��#*\�Q�P����D?j�e:��|;�C ��^��MG��bFds��n�"�l�����$|�V���vKBm��Xk��*�%�Y���L��`F��1Qa����ɠ�F��L�WZUѤ�H�6D�lD5��4��k@�J0��WHd�8gHCF"�"�H�Cf��m���?�`@�>W�&�l?/���MC&��I�D#M��� Cv�m5$wo8���#���/�ǰOT)B����2RI�2�H��[��}lg��;����ߋ�7ˏؓ(mE�ƘI����x:�&��θA�
ˉtl3,����+~㓍G©���=������*�&'��_�J��X Y�c��f��b/��)���@RG[ZWk��Qa���ᇶ�T�1� і���p��".w��_���Gu����Ɵ�i�?�7�Y��̴@t�=��B
���8-�� ��k�䔉0�/�	d�Q�uuNĝ�H%=_u���S�(9)�����w���!�O1"�w����Vkw4{��d��'n3�?����3nN��Fx�fwj6�Y��̺��8u�
C!K����F�]�Z�*+�J̑J�_V"3�8�W8Y#� n�Ɗ���GѦ�3��P���N���t>F��ۏ�W��E҃��y�.<�=h�9��=|D������>��b�k�u;��I:�#rh�+'\4J4�!
Ux¡�	�>͖��z����v��w.�'�A3�h�Q*t�,QLD<����/�������8�h$�lW�)��=�u��̗�j��o�Dر���əm4�]�G(U9�fݸ��b�����"�� [(�MeE���Dg�C��΄���d$s;+�[��C�)L�
�>1��5%,����d}�J�>��T+R�������F�	��޲�[���R59��*Lo��ZA��������M�u��~�_�p��Jm���kD��)ԅ*iA+un�h�v�͗��Js��-dv1��{��,�T��#Qa��Xu��c����p.Z��+?�|GiT�5D"n##ƛ�G�V�T{�����|���Α�t�Dr�:�ƕot�=�|�h�g$�R��
W�Fw����g��s�R.ހ�j�s".��p\
�X�ks�r��G?���2aoE*����
ۯ,�n�S��/���ohS6a.�q�,�m�J8񖆨p=�p4�c�2�����͏"�p�������A#=#+�ˌ���o!���(Z"�j��n5����ܧQ~�=�s)>w����~ƹ�Sڐ:M*��H�	����"��z�Y���$��l��s����I�2��V�*l��>�z��IX�t�T	���
��I�N��g��$ۖh��/�t7�|�p��#��"T_PZ_C�k��+���>��PFb]b�>��O�AX�O,R�V�ȉKh�����	9�R�u�JZ������"{dgD�Jz~��JČ�"ٸw��ΠuC�緁�ٌ=���v���8�	��c�o�W�� �<�"���2BR�����Ŋ�5(&Cz�����ռHăшJ�c�t.�<�b���G=D�E$�3�h��ǣf(8��~��V�(��n�ND$��[�+���/�ptcV�t�-N���|����y��7!�3޳s����q�G��u΁��J<��#j�[�!k�Bx�	�M���q�2':��8�ĝ���7Oy�U7�Z\�&���Z/M��H���~b�5ULD���T�=m൫O �?� �
�9r�r3 ��^8ՂC>{3U"v��.ND<�������������O�v�Y��"��¥P�!%�Tt�0�p������i�������%�OGGb�Ɨ��֍Ή�r}����6uC]���nW�k�#���8aβ�ǻ�HӊRKc�ʉ�4z��et����#{���H��ۮ����*
�2wǠs�=.� Sww"�� �x\��du��,}�a����!��� �M��TI� ���*�����?&d'JN�C&7�KY��x�H��H5����� vYz�W��p�z��V����D����5ҭ����R��wM�q���nB*n��i�U#z�bF���1����?������%0�zC�P�����C���b�TumS�Pt��5Ta�O1�:vI�	d���WJ}V 8�L�_��,�r�y*�+�D����f(`ю�cן%�_�/?P�ߨ��M;�D���$h�
9x�y4��#D�o�H7:n!��0�=�z���T�6y�TH��s?3Y:v��!_Α&a�!�57�@�����d�Hē�6��c���b8�3�YM�Y;�g����*�'Lw�F��BDį��p�T`M��ayj1�֖��n����G`�qÝ�Tt�lj2#�pH��t�!�ݰ�/��]������E%�����E\�	%g2i��`�sd%���=��6�Q-�&Gx�-��#��D%]�rDUz������؆���3�vN�dD\,Raz7wnV��f�l�l���Dv���zbx���.+�!8D�i����(\�n}��As�uF�$d��Վ�9+l�[��L���Xg�Ǟ*pϞv?��}_�z��?{Jfw&�)q+\S��/#:��U��'ν%X&L�#=�ty��p�l�4�l����,���K�D*\Y;$��U��yI��8��C\A�P	���E ��z��~y�_��?�?���e�i��Nhr��Œ6'�8#���X�X3���j�P�LC��B��9f�ԴS�e!*LC�ch���/��P��B���p����̥4�;!��\����{&��C�F%su#љ��P���
f֏5��|�m<	D_���z~c����q��,���Ɋ�o�0|*p�]�0'K+_�U������aт|s�Ӟ+{M���D\#RI?;���g1���e�r	�{�a��X"�a����UR<�?�=��E��i8�M<�訿�JxN�P#uY�=iF�j��\�����ho���3�L�C	�L!��Zۜ���
W��0�D�z��������	N�� ;���s�}�6t�m����e
Bt��$ED<����H�S��h�⪛nC~�O�Ia{ζ11�C�+��UfpTEH@R�A%*,<�)��q���Gp�':��jlN�׭�
[��8��ƽ�v_����1�s�\
�|�P�dX�l������x�ۧ��jH�b��t���XO��������JD\�,RI=�j5r�W���4�:������gE|֛��hq����"^i\���p�+au�� ����b��z�/V������}�sw�q�ϙ�I�K��+_5q�:ِR�g��LSW!�L���de�P	7�������8�����!2��>�1>�b�����ĦD���NjeN�JuCSq�Z��H���FD|���H6-��� �D!��>*����� ;kk2T:�������w���O��,׫=Z
A0��%e�x.���h��FU9���P%��~��q�1�=�����`��$SE4��$�2������[��D$��6r1�ih��G�a߶?�|��ނ��q2kq6P�j?�aX\!��{'��{�m��kE�9"�n�ݶv�#���D�c�$L�~ �E�PQY��NQ�P�D�ͧ���k7]ߌ])��E��M���6q�S�O�T��y�m����\O���&�
\Jsk<Q�.��q�.����DR���;��%rO����C�	C�K8*8�Cz�1!��pF    ��X%^����j>� �]���� \v�n`�a�@��Ḫ�T��:�$D�[�½:�ʓc������v��1d�Z����҄�#��ԞZ�g �#	Egp;�
�۩E���l;Q;RkR����x.����)���{���
g��a��}�mih%$(��Ogm�k"�JG*LNXY��)���iN2�������R�v�P�q�� �|R~��z2B���v���E��t�<F^f����1"��*);����@���_�(�)�5������W59��$*,����Yi���*������}�òI��`W�2��U�
�e��8�<-x�&�306�ĹR��0VW*8N6#�����[yߺ�ב�7�"�`؁<� i������B�Ȍ������qEM�+��"����M��LE��BTXE���O��طҏ	��i3�=�_�7V+�p��j��?$��uU�p٧��4Ҁ ˟
s��L22TI��Ah6� }g���\�G���%��&}��9�QIT��U�n$�
��p&�ѕ�9��F�½J�Y�v��K��9�@4!{�]k4�/*�n����%*lw��"␪�'#� �5��$)����
�1.'��
��Wr$�;���]wp�'Cn�ɡ���8�O�\Vę�H�C�i����9�3��>����9��<D�Y�QA߶�Y�nX/�K��h�_$��%�H�>�-�R��v�nV��[�ؾŁ��sc/�����~�=����E79g�"��!ӤYv����� �uw��o���&��/�e!��sJY;��+mʺ�[0q��H%�`�R�Xҷ�-��C�~X�m{=Y�>�:�pc��n�d�Z;��ʹ���f�J��RT����˪h?�GD0��!�"5VU'�;�ME\c�����M����3�۾ |$x����r9]�ma!5%�j5��ZS���P��6�Z%�e����`�?�7,�L��%�co�V��_�Xv�G�i׊
�X{èBת�Z."��G*L�XTҚ:*�8R���$�R?a�S 	e�"����G����#-�|��]�����e�}~{A���a��S ��#0�G7�qV���l��N�Qq��U�Ѐ���@HT�`��J��N�^=]�P��OX���?#�!"��HT�N��(�ސ��/x���1/s{����&nxC�_IG�We�^"�^�H%�r!�1x�~��ߊ/�Ï]��������bo�����[o�V�������_���o&�s�*��,���]]��˥�i��������8/0�s9�0O4�0 �D A��noo;�UPf��kI�{�٠H߬�pN{OL'�S6g6&�V����[ݧ��a�UI�U����bI�̘�c��0�spg�)����`a�rf�H*:��y��WmC�^�l����=�P_u�N�^��=�IN ;M��}j��:�w|�I�oW��z�dX�)�b,j���
�0��.̘xJo�X��R><<�D�D����ϕ5��g.�e��珃�qY��+Z(��o���qh��0��׻��WTǑ)56W�EAj�����5_�%.l���uB�ի���(��"��_XԘm]Z�)M'�ԅϿ����\��a��p��٤G��u���'r,1����Hz��#5k��o蓄At)���Ʒ �*����e����f:сH]�9��&&J����f��8df��պ�	����Ƞ������1M�ʅ6q�t��S$`(M��q)�2d}��d���k���L&�l�E����d&n�g.�P�)sˁ�i�n�5�����_Q�p֜m��r>\CD���G���q�/�xj:�XS����D�(�yt�ƀ#*h;����z���rY����(�҂|i�)��K�\D��ߏw��WU�_!m�c���V��{k^�/x�v�I�A!D���EJD[�Np�.�ȤB:1��>������ow�<'�t�43� &��2�#���N@LRb�G�ϮG	Q����p������(_�o2Xef�N�̅�iH�TU��7X9�������?ז����{�	��Ei��ą㇫��Vl�Ȍ�����qB��1��	oe�%�^@Z@���L'�$��%1�B��ib�đJy���/,6����j&~ċ���>U8���ay�:5����s;a�[�#zfP��L'�S����G��q1��b)��*�!� 	R�Zn�zC��˘�3Wg�\��5Ǡ���'y�0��$-2�~����뺔��4�x��;�'���?�.�J��:�^�"ę=Qi/M�a�R�Q�jb^��QE!��ݞ_5��'눠���#&�ڴ}�S���d]�R���d]�1������`�8ME�O�Q����b�A�7P��8$����7�-;�tl<4�J6�U�L�c6���V��(2cbN�ܥ�M�r}�����q���ٰ\�eI���!.[`�ܥ�;���e.\?͙^q��ñD�t�����	�1slgZ��TM|M\��L����_�!��^��p�����La���'�"�dҠaL�q��0Ǎ�q�pl[�h�SZ���B�N�~&��8�rӉ�i�R��Od�8��$���R�PN� ��v�KZ���ĥd�0^d7l�X���'D:1-%�Z>���c�,Rz/M\e!s)�:�|��8ҤT���W��ҥh(��\ �w���F}�����G�h�K'"�D�)�)�mi��7/7H�z��m �݌��}�&I��%��%��!�O�Js�e�7��f:{���Fs=ˡE�!�Fj&.��\��9�	l`o+`���w Z٦z��gB!.,ʁ���Q�n��G��W�2���LoZ�+�Js����r�ٕx�%?��6#jex�z���� �2��5m��v2&��".�~���RF5����~��o	���{��8}�NZ'k&�茸pA v�Tc9�!X7a�0[77��<N���l^� ���3g]o���f�� ���kT��C�-M�hgU���g�3	#k&�;�\��X����b;ƃٓ��`��WN�h���BA��zC�����������E=ʃa�}��߮P�sh>p�|��qs�z����xټ�^mo<|5e7,@�������3�f��ią�	�!J� �l8�O1��޻��p��ٔ�1�,ĥ���-ci�n�4���C)�%Cσ��vf\k���N�tS��GN�,�����Ra�߬ޏ��@vյ�W��.�3^��yQ����q�X�T8�������4H�HrL:�����L���t�M�.&]�]��!�\b�a���k�����z{�c�|�����m�c���G.�Hqi:�=N]��J��X�FE}I: �Q��Ej:��H]�al��QE�W���3��|	�&�#W�B���t*�;-��Z̝������{ߒ�7�/o���o����,��A�����v�yr\JL�H��5���֝�u[3q9h�R�|�h7�Ɉ;��Pץ��_w��?�ga2��r����J�7�1UӉ)�ԅ���[1���^ R��&�:����t`G�*������֧���RVH6g���'�ˉ�!����X
�!��靧��˵#aOi��̥$pbGD@�Č�&���w�\�B=v,�wm��h"3�3ą���'����lҭ�)��H/p.gFv�s5�� .�bP�M�*�p�������a��-pL6��Ӊ�*ua����Ft�8w��vh��xT���(�%���q�P����>c���P.�=��<�j��i�Ř��>w�>�^����
/x
�d،�in�rX��E�ԅe3R�$�q�X�1Y)?��8r9�:�\��㟸�C��7��sX�"���z{�
�d���\���}LpH���B[a�)OR�2�D�o�g����W ����;o��ݡ_,�K���Q+S�D�r(�" }��A�*���k�f.�P5�N�c��
��us�]��
6��܏}w���]�ޠ�k&.V�\�*�6|�(*�(]�O�I���Ś��.u�!uӥ    >.�ˋin�v�ݩ|�+���nb������JU���)�M�X��rL���@z�2����m�̅�͠Z0�o���_)Z"Rg��*��
=��쪉�~�\�SEy�ø���/���f8�.����cs�<sS���9
FȻZ�3Fwp�]3�]-��w��Xr�p=,�V����L-�5�"x�ܕ�/Lk�L���̥d!C�9��
���������2݋���w� �R�eWt2����rca@��a���
Zؼ>߮Ǧ ����x�������m����wlBp@{�a3 ��̀��I 1%�#N��p>���ښ�3�2�A
�l�"��|�؀�~��������������A�S�6�P���?,��*q�L<ւ����ÿ�G+�� ��{��f��`^:H�CB�yh��Q���f��gą�����'$#OOJ�Q�b4�<�j����Ii�ڡ�K�h�����wͧ�ru�^-Vaf��rP�ƔVw���8PW�±m�)nr�'�����c[��� ���f-���_���@�R��{Q	���i4��hB�se�9��ȾX3����.���i����Cs�ŷ?#����fCny�ȌDƀ #w�Aݤ���8L��0 ��P��:R�����^�_����׽�z�}��96�y�^�������L�t1q�8��3<c���ݙZM.����q�n�ĉ;$.&���(	f. ��;�yۮӺf�;�ąI	%B��b.�Kd��<4�����j��G�G�P3���L|��p�Gط1n |8�\h]cv�x����4�+,��RvM�F���|�1Y�H��B���K���w]3qś̥\o�)���x M���_��Q���x����+L]�W�N,x���B���h/!���oۙ�خf�#��F�^��j�����k@,���%���2r�Rb��]R�sI	��5��W�Q���~�n_�j����8 .�᠔�'Ձ}�ݻ�^D����b��t>�1���.<.�����@^�|YN�YQ�+��f�ȋ2� ���T$X�=�b��y���iNT���;s�[֎�>$�8�	Ґ�*��[�#v�����F�RL����_ԯw�o/�ͷ�����8�~�/�q��U���hBa�S���ʚ�ш�	o����|�{���x�yw�ϒq���4<��>m�򱨚�4��0�6�<
uzj��B�J�̉y�߄�CK[��X�vC�B_5�bą����[~��R��on�y���^/���Ј� &�;HZ3�Df�G�KY����Is�n�U�e�4��i�|^�KGJ��C���MH���f�S$�R�y�<�ݮ�gH��}5Q)t����=7��N��K8�K�+U( 0�Qu��L�/A\vLE&(��SZ�rL_y�7�I�t�4�	qa���A�6#d��������R�n��!B���[W�­w`�p���&�K�mXHlxF$�K�ʥ�%��c��\ʷ�<������<L�`׶]��L|�F\�퀄�؈���rl���1�:!+�z���+����v�^�����}��!s�F? ߄0ѡ,M\�2s)�(�I�PP��@札�M�Ys��!H/M'j��G'Q��)^ ��H����2��,m�1&n�;s)�~B���P�{�{����z��{h�~�4mǟ�0\�*�5�P��&�ኸ�W����Fy�{���L���!�Mu��f:	 >��@U�حL�Gż��E��.���x��Si�k�ą��
-2���Gx�ERG�yGyIj����-�� ��Ǳ�P��4 ���vr�BF��Ɏ��>�U7pJ=�g��}�C2�%{9�b��οP�������/RZ��ĝؙ��aeK[�E��_��g�C�����fu�+�:��rيH���jɧQ�8�j�RB��p����86��������HFO 2O�e�\6�>�Id&>�'.��)\��,5\]Ư�f����&Lq��['��[H�1�(�8RӉ)�ԅ�:xP&$������J�i��%�w�f��u&l��N��.B	��#��f1�=�iw�k k����`b��ąkh�����e�Z��F�}�T[wz�#*�!���Zg����Aą��(,��7���\m���"S��*jpx�K�'�VXn��̅���M����A����m�!����?4d�yk|3g6�[�����KU��#�|R����qap��(G07ۛ�x��2�7Ih�TJgS����\�ҵ"��&�򖹔GU�������/���H|�^�z��^�ў����-m��rק�s����a˔|�kd�8K}0"]�m{5ă��V,ܻ�ܫVFǖ��lD�V>F�[�W?H�Ֆ�VtN�L'��G����/~��ޜ�ֆ6��Re�ϒ�%p���7c�;W
!)9�X苴)�/Iv�64���r5w�g.e �Fu�d��3�l/j��yL������L\��t�P�� ��-��>�ȯ�T:�_X���`�%�$3������V_A-j���|�zS�p���*oJ){��9,�˷����RS�6X�j�l���;�G�����ɜT�I��~"����1~��.�qR/� �"ʀ���C�	-�Mє7���z8;��9�>d%eo���9:r��p$��7�J�!��Bb�L���x�g���v9" �c��ӫƦ���Jw� Z��;�2f�Zu��3c��l:H�(��{��41qG]��aSDja����%D��lo������~r��;|����¯_5q�&s�v\��f�������_	SV�{��{���oN��ӧ?�F\X�,+�t�1�J�vz]2@�s�e:X�N��S�2����"�ç�Y��V��
��r�hkW3qc�¥׈l9����5b���4�Ǽt��]k�v�SF�L|	���]k#0�lu;,�&�S���S���N�2��X���xv;�²�jR� �����p��ܫH4a]*��gԘX���VQ�����.�>N��"�ϗ�È�툚��mh(�����Kc��f:�EM]���k�<�a����Xf�Lz���e��M��qa��`e$U�%�[���ϕR�S}� ����6-B�&��D\���`������D�I��艖m����}g	J�4q��̅��Jc�R���X�ٛ唂�i8`I�d�% e���&>�&.e�;�(�k|6�WW5�]ζg[F�Z4"h��5(.��l���&����6���R�u_ȢeJFY>U�i���ucj&�f.�SU�R&�sx�(��>�͸X��}Y�m��\�<�������Oą�OZ)����I����.��嬕Z[]3�(8�.|�YG"P돑搮�s5fe�Y0�J�%���OvB ���*ayS��5(����?ݥ����ߋą�yI;����7��oϻ�]3��5TPG\~Gq����'�j��7}��:2�r�����l{�\�c׿=b������������L�X(�]��GK� <"A���� �򅉻I3��`��:T�Uj�4��n�6g�fm�G0 @�]�B鑎 /�_�#., P�i����Ǐ� ���{��B(x,��j&.��\~Hغ�<=����C�F�p�ʣo!q��O�Y���g".(B�VN�藋�� �NkD���萷�B�Zxf�X�;�*�b��\���6��w�o����k���SC��EZ�S���j][3q_d��}�Z���G�����Ɓ!�-"Z��Rr}R���GM���11H�ܥ|�N8�⼕��G�4X�2�k]V��s�6c�֖�0k�m������DB�e����r=C��L�$3�hj�.�!��|ǡ��������,�_r���a��ۗ>m(�$b�#����Eo���@v�Z|���y���ln���=��h�T�4
IcE��^�L\�:s)����CI<z'�8�s�!"]�>��+O����ڔ�H��P���qY3q	T��$Px�+�@��9��4���bDڻIPN�t�(�/
عvf{k��f����K���Gޑ��B��)�3\2/۫�����L��    s�hZ���j�'U9���l!�^�K��%bb�K�ĥ|~ر�n%*,	����(�����D�I?���"����� �
�2�\4�D*q�gL~���Eh���

%�X��?�Ѫ��o/�r��5���^�r�wG��9Vƚa3_4��*`��V�{u�rj&ZN\Xh�q�`�]�G\��,Jy]�^�K���+'.,��C�eX/�
j&�x���o0��{��u�����Q��-���������G�d~e�B�qUx'.��F���~����vu�|�VK__��x:@Mknf�'�V��t�p��~����v��j��G2Uz�S\���6j�?�t5w�g.\���d�ҝ���2��|��G),��y�~�($���x����h{\���?v��}Dŧm���Z��C��p�
�n�
p���������f����%��C�|��	��Wꚛoo��Ys��AcO_���5_ޚ���� h}kB'�f�x%Ȁ2�b�|G)ܱP�l=`��θ�f�+��p�٤2�MԺn�����g����� ��{w���|ٿ /n�5���"-.ȥ� � �$6}J�YeL)H8�lO�� zK�(ݺ�*n�l�/3��ĥ�L���Hrx�42B}ޮ�ݺ��*v�����[KTF�۲PF��j+Z��&n[f.噌���$Ƥ��9�RjἊ�>/i����
q᪨���0^NT��a�]o�<�`����O����	8��rgµ5�s�i����E�/�^��	�WY+C8IڙmQޮf�R�̅+C`*4�6�D��z �32����Q��!c�Q	ąE%�X`��;�����6�'�@�Z:�F+�3CDKkD�L��qa*�87�������+%DGƴ~�[A�`,2����t�?%u).���� �<Ȼ�j���͗��2��r��#V�$//&��yTzM`������^����;����Ą���W1�o��ÿ\��z\��op���c���|`3�*�K�j��ZHi�x�RL=�$l"���%��d��P��5�RK�2�赞i-�t��41�l��D��#��b\�xY�i�ĲT-p�j�;�~#��d�e �𮌼�!D%��y_IOxgz�k&�.�\�`�8-p�s�xR�b�F��~�m26U<��wU��M�f.��y����Y������9�Ci��3�-l&��Fr��.j6�^�)��4V�!�$5�({����*Zi�	�q�I�d��L�ђ���>���8��w�zr@�i�vHw2?9��?9�{rXu�C��.��$(��u��H��'h�t�����TZ|/@�H��m��V1Vh���mcL��w��+]�#�����92�;ە\���@�R��0�������n�+N:6�9U�.����4�M/���i�K�.<D�X�6+�!E��J5ڊ��xՀ~�{�\[3�p���i����۟�4NQJ�aHۻ����2���#�q����ӳ��@���=fʯ!����7f3:���o!���� &�� .��T���y�Gi�U͗�קo��z?��Z��Q���3cAN�ogj&nWd.q!�dN�����m_�&����4a�,,��$ԃ�#�e� �l�<���x5�Z�)�+3t",���r��ML��%.�܉0�xe���Yt�u� �c,5ǐ�����G�qT��������KXE�dw���]���v�4��1��K"�v4i�M<&����`k���a�~S�q9l��M��y��<��7\��kE:b[�x�	�R����D	T
������vk��o�v��L\D���ﷇ�jM:ne�A,F 8����	z��|���XD>!���AXqA��u�^mb�^�F�r�+�3	ɷ5�	]�D0�'c��r&�T��W�������8�>�n}:l����l�*�����i����-޴/ij&�᝹�5�NƉ�w�Nj�J]�!'���2kK�C"�nf���4Pd��ʡ�z3}Bgx@�r��5�	����0�&%E%[
��ɘT���*5ߛ".,���q�Q�1�f�Ǧ[�Spc:1�����8�8Q��_����]���	g������������=Κ�������礴�|ݿ�=|߽�.�H�y�A�:go��5�e�\�.r���y�@�1,v/{�zhBˇ*�� ��NN�'�Ԡ�E/+��/�`)���Ǿ�v=~P�&@y��d|��f� �QE�~;u�'<����f.
^�ˎll�ñ��e�sˑ�9L���W,'2�ăg�3�C^��C�^�h�<v���UM'�<��(D>Ǳ����p�\#���b��+�N��tH�&�3�,v�f��zĥ,B!���5���r��c��Ea�W@5mq�:F�݂��<n���=�W�@�S?�ȸ��?��E�K!��+��p���F�L[3qS��KY���,ձ�te�V�߯R9ׄ��'�]%�����.ƶbṼR��~�Lg3G�W�/���0�F��PW_��єVt]:�S�N,5u��:��Z=I�{?���LV����6��!�ehgA,שt��1qܘ�KޛCvi��a���O؛Iy2]�?�q[�V��I�Y
ۇaӊ��C�*H��vcu�e��[A�w�)�L�60�I��L��)q)�䙞�[��p:�9�E�@ BCݩ����0"s�@/ă�����u���;*QD?�����'���J �Զ��NL��.�)���{�P�_��s9 �>*oխt2� *�8�۩�)S3q�N�� P2>N��Ⱌ_m����Ԭ�+H"���I���L66m�1&^����'�Bt�Z��9�����B�>�?�'l9%�`[Fyöf���px`D>�2��hО�n��$d��EH�[BxP�x�C�%ITc	�#D>��s/7�|=^̗���Ȣ�%J�ڃ_�uN�q���gą["fvZb�		��֘�Ǜ�y�넵��9��t�Y�� �R}���?b���K���V�a�a=���d��2Kaj�&/�
�aߪT�1�{��p�&�9�_�$`)ώp5�|}z9T��8�%�h՜��?Z�Y)v��L�媍�B�#S2��Z���p�
�UT5��̅��J�f2.DN���O�U�#铸�C�k���ھ�e�tI���Hze�l줧�!��&�7Z/��+Z��!TJ��f�-ĥ|�̪u��#�k��~?Z�wS2�	|\����t�2�%�7<߶�~��=���uW3q�7s�ޯ0�ο/���j�\�o���z��L�k���zF�D�0�ht��m\$�n`Y||zxzn^��}zl�������[�7���q�ކ����f.�R��6ٗ�oo~Y�x�Vf��9 �L{m����3.�E֟C���z���;L��ކ�h�\�U{U`e�軚��k�WMS�3vjH7��UQ��K�(�cJ��N�����S{�G�#\
'��>xy}���������.j
\,����V�L'��R���ļb� ���3W����m[5�3qaog8�R��2��3�� )�H��4� H]�9�����F��=��~��5/a&3lA7G.4�=>و��ה&����/��J��6��Ɨ��ԥö��fx��÷Kn�rMH���0��c��=��x{���+���_�E"NU3�=e��}�B�q�b1|�&�g�����g�򔶌A3�ܲ��m�1�tmi:���.%�{_.F2ǱZd�o����Б�g���G�9hC�X2����{�"��jbvm�R>U8�U8���A!N��j���&Ocm0�����L��*qaH^��J��U_Ot���b�b��hI	��ؔ��9�R/L|����%P��B�pO]����v�K9ڻ���r�뻁��(�����²�؉����H� kl+Ė���z;�C�D�=TK,���JU,'J%�_)������i')��	�;Cd q,L��K\ʴ��ʱS��-a������On �R�L<qa�㰒'e��'Ќ�dk7�'����m��L��,qa�d���"$�;�/I�w��{��he���1���.|���$2�O�{m�&�    �^���0���ND���Y���$(�����2��)ǣ�-�3H��&�劸p�3ΊX?LU4V���+$�mζȒ;4ˋ�r{����/�Y,#S�ZF���x�v��]��5�WFF����6ۛ@~��D&� E���}��L���޴5��3�2�ſ�#��f�;�8���?�<%�t�YH���4�+�!��qg[++��fL,$z���%�'t�&R�G==|�{ݿ"�w��Rl��R�NEҠb�GJ��d1��¤�ҷ�c2æ�.7DH2��~�Iʖd<٘k�{!Sv���f�F`3/��#���bퟴ��%m���J�t�	���S� ��Y~CgCrc��r�����v=�Ll����u,jt��Ki���O3]�E˘�&$qa��ڈ����{8�l�U`�H�y`��x�4� N]�o����3�p�Zϗ�'�h%#'J4Ǉe+{�wQ���B�K�h�>P0�\��ۣ��Y�ܪF����C���f:�O]�(_��f���"�7�lɢ��LA.�M��gKą͖���*�����zZ�O�·���Y�w�w�ce�yڶ��L|O\Xd�nS��i�i���F�u�t�H���Cg}�8���S���G\ʨ@#�q���|�k�or��(8(��@{�{mRN���Y2�rm���Ԭ��o������/�3g3L�)��u�|\IM����]kI�SX�I��a�,vP��Â�9]~�M�GhHk��f�{P�eZ�;~�N�p���W���5����t?;]���V�z��l�tr����m�-!�,�W�:���E��C���������j$.�P�q�p�â�#��
P)2���|H��u��|d.e�dSa.t�>���Z��=%.$�4��u;SpS��"�����\��!g/H��z���g���vI(;�2piç�𴁩�![`�v7<���u$lJ��y#TGZga(n�4�Mąi��?�y��*�؞/V�+\v��f�jt���V4���y"5C<�,�ߩ�D�;u�J8�t������|�����\i:��N]xfI��o����[�w"��P`U^��	8P<>V_-$.���@n�X~��9�p8�u����wck�\$�������3�c�U3�F�R�Η�#��fZ��H��=|��`^�L��+qa�]u/�N�&y4AEI�$S�Ѳf��ۙK�hP�IE�W��"p�B�զB9z��L�1����i�o}�
mS eE@GQ����S	���3��ă�^8`}�����r<9�y�CE�j�G�i�E��-M�E�R�w~ ��al FX`�z��}+�������tH��#�a��O7�5+̄[ؽ[�c'J�Y�.��ցwA�H��3�['�������2�N��.)�B���HY*���N�ԥ��l$0q�����<ݸ�,)i��z�l��%�K�$o��Iz�79�����ꅟD�=׹���O .ܓ�i8�����0'K���KT~�u�b�^!����|d<�f1@�4?����?��\!$��
��NG�.�*zNe�uNį�wd�#�����3
�&��񌉻�3�2Z�<i��9�F�sx���1(��Y��wyϤ�iY�1�؟�7���<2�|ίG�.�bVs5_����!���"o�`e�w��rbۚ�o"�I#z{��;���P������W���������7	�Ll�lW���Yx8p�Q���҄E6��=�x���]s��G����S���\@��g�43�y;"�R��iL��A����m!�_|��7���j�󭄎���y�=�`�0�\��0?s�>��w�N�b��Y�Hg����%1�Q�3��-M�&s�>�^M����������s�|��w���?���k[���T���j:�Ǒ���-�B�8�J�Q�MZ��������W$�J�#�T�@JHe���3�G�b�8�=��ѕ�5�⌮-Ί�%�92>^���nqf�
��j��qZ��cֵ��ob�o�R�R*� p^�2�6",D����Y�Ul�ML���%A�mzu����,�O(єܺ4T.
���f�r��ܤ�WX=V���[���K��L�$�x7α����_��vMD�5y~����
�AVj����9������Y+���N��S�T��=��/���w�x>��͞��8�t�k���C��Fg�����2��U�E_�����Ro�[�}��]
�e�	֫�8���XxpB��b�����כ�2y���L�˿Ļ<��	UO�zn1����9�B+W��\��3�o<ٗ�D��ܧ��|8!(�(x*Xޕ5Ӊ=u��6?�L���փ~{�}��5�+Ot������_��Ev�"c��}۟^|<���5�K[B��D�%ua��t-9����5z»(��#��T�Z����z��u�t̝�0_p5tX|5�"�򜗥4�1X+��Pf�N�̅)��n�y����y�����q���ƪb�{X��f�"�̅�.��&��v9^0�=-�Q&ZĶ��}g���+�e.壃UY+-�х9*��w�{OY�=�{�OX�lB+�ށ
��l�򚉫{g.\�)�u�4g���c�OE{��G\X�?��6���w,j�&���&9q8>"����
�VM<qa���T�?H	_mV�p\5��$w,em&���H�ZA�%J�Si.u�HK�j~>�ͧ�|���Ip�<y1� ,\zF\c�Bą)&�#�:���S��-���5DU�������)�2��7A':�V��x?u���}��Ais9_/|G��mK�)2愗���S�����p*w�Ɯp`-��!�;T�L39��)<�/d6��m_�$.lmSt}�j>���/+}X!Ϋ�ʏ�Ӟ��'#$.,!��7�vR��y��_��jCh�K?�I\ʖ�<IK��o��pҬ��+H�W��UJ��*ߩ�5�j:�ȣ;W�d,cA���*�IN�%�p%���ܠt�VV�1cf�թ&c⊮�K�
�$x:kSCB�tc�����(XW��X�GG=��Cɿ>@�K=�N?��hBIgs��2�;8l��%��3�(��V�q�X���+���.�y��gmQ]W3��C��61�;�z�0\)tK�>[`���A��Yۧ�8��kLd.�Hh{�������dc��l2�t�!7���R�����6��Us>\�Lӧ�,R~�(!��|�mo��k&.��\8J%'t�t	�K��z�%��j=�,"������+3n��N	Y3��ą��Ж�f�@��pu�'�T��0U�Z\>}�j�u�ԅ/��G2���a9�4�G��zͮ����z����Y5ӉzV���d)5Q�/�Xj�"fQB'_���fm�� ����6�2�"d.�Z`5N�qť�]�ϳ �kCN%�.ŋ�O�ZA�|��N=�^)���&���b܌�=��ܚB~
E��~����S5�lg.�ǉ�0.�L��"�+Z);��Yej���ԅ��D��6./�e2{Z�T�����o�!Ӡ����i��Ϟ�b|GZWY��]?�挩�N�oR�~�G���9ܴ�^�/*/��yٷ�M�+J_�!.l�ƘHU��7X�	�~GN���WH�� B7�]*M|����|~~�/o_w6���?�Ѿ5���ݻ�����*	!��gd�,1���kl�ğ&ą=N��`��b{��&m�.ƈDP'�(���")NM'��ԅ#¤x���V͸�4�
(TF:,ݐ(,�P��f	�u�����q�V�̕b>)�?���e�|��x�?Rm�?�y;����`�S^�k��f����ú��=ñ���,&�>�3�U�<�d�]��]͙7s�����9 7�͸�µ�;.��=���DR���A�9��}���ĥ\��C!�=��A}�v��ⴗ8)�.Y=.:���`C�g,�+�s9n��x�qa�C�F(lP�]�=�}k.�����{z>�TK"iK��Hb�:�ˊ�o���rz��C0|����"So��8+�?�hA�~��K�a�ئ%�tb�/u)�],`��F�b{;����佾��f$k�    =����"뤖��? )�sT���M�)�|�_6������7���).U�g�U۶�ML�WK\8�9�J��=��?p�iw���������tnLoGzؚR���&��C\��vw��7�d��'(�u�<L�!&�C\X(��W~��Y��s/�����\� uDD���Bm��}Mr&�x�\ʢ����!�DG��p>p�i�̍eX��+�����p�ă��0��g�tΐT��S�|뷟�(:�j&�C�\�:4��ڰ��p����Eౚ5g����G�ANɦ����v��?\w�b�N=�u���#�d��.����m�@���F&W4?��Q SŌ{mk&�S�]��&�~N9� W�C�~\�!H�� `����|Y38���j:XN]X�H����y��E9��;!��?)��NI�p��g�W,��WЕ��mƿ���z5q���A��G��u��n������6�p�r}��w�Y0(
���J�.gP$&�A����b�/?x��0���q�����%�Ah[��L\�����%��Xr�>���spz�[�@bym��kU��Y�&�E\x$V�R?m���a=F0VJaQLh;_��fZ[���e&.��\�	�V[EN ��nVơIƵ}�89Tʃ����LY�cۚ�;*3�7V[S������R�(�0NǦ0N���p(~�vm�홉�����P����ɘ|!��]O�mM�QsP�QH�`�5ˉ�ģ\2���d.������g���27�g�NQ������]�Y��ҕ���ru��g����l/=�Y��V�V�
�)+T�R+M' �(q��I�Td��#�Sc��Rxvi�;�ą�k!^ ��
�۴�R��z
`hp�/��&��C\8x��S�;`q�y�}yK%�r2mᅀZՕ����.s���i~.�֫%ɾ���w��U����X�\��g?��s�ۚ�/~�
�9"�n�%D�����G�Pm� �->i!�%��Y��$�27JNB!C5�'�ޞ�L{��2���D�X���oyTr�5�Xe�=߅������#��_����O��^4=%�$�F��@]{�2*�l�'^��'©���C���9��~��o��=�+_�^P���-q߾�af���Ι��������d�s\�(, ��x��ާ��%
T������w*u�Y��9�(�,* X���/������|Y��h1����Ff�����`��!B��2p�u�s�'�ś/O�_��"7�!cW����55�\S6pE��p�l1Կ��w�au2E�2��³9[+L[�p�<���T�N�<�t��� 8O��D�"���dO�����y����v-qa'A��3dW���.����=��w/�қ8I�l�4p��"��ϾM���t��%u��^d䱞��^߼r��������}���f�%�+�J���òa'Z"�Y�xJ"��T)��T��_��nn�5)U������Bװ%z�M����ĥĉ���H;��e�h<�r�o��1T��SL���$4��)ٹ�ޓXN�{��@�����3Ս����t"���]/�D�t���{���h�f�{k�Q�s��|ae���lG��7K���.e<�&�����g.eO�SyT꼚/������u/C��4��8�<�t�޶)
c:1њ�0HH�W��vR`&YL ���K�k&.��\�~��J��b4]LN����k��L�b2�+/�1����RK��S�L�<2��ՙ�(���8�x�R>2�c��z�}k~��C?:2�K	E��<�P�)�`�*s��D�=uaJ����y�06�;o�������-�:�,5]�V,��F=��>�i����k���}�k5��$\�)%D	��!��j�aT����"l�ˏی��""�t*DSL'_χ�JK�&���\8p8�X7�H��9_6V�s�j�����k�w��ֶf:�=K]x�Y;m����L�.e+a���K� V�L<� qa0�e��X���������7ME-
��K=X�|��i��^��7��B:[�����뚉��vxVV5�4k�g���xZ���f�9ą�>@_l=\Fq0��%S���N����L�W/u��a�I�22�7�z��>��
�:��j�j��Yc����©�=�<�z�[f���#Ït9���xt=qa�����鷁z����۽`:r>uI�	�(U��4ݬ��|JG�����xHҷ�+q�7���b֕�z(1!uV�ۚ��Xr�k1�iv$���'`*+��؜�F����f.�
�iT���Ä�p)|$�x453NP{i��̅�X�`�f.�eT�E���\���ǈs6A6r�.�u��s��'�4���e�A����)*��,v`���c[�����}G���
�L�Ct�E����fS��?�[[���ao��+[k�!C�3���[-=drs��.�"������0�����`7�7�ޥ�f$��"UT/� �f��̅ツc<Ri�#!�9o{��+���UH��N��Sc�wl���CnB���T	�AЀ�p1ʚ�CWe.e��+��C�i��u����~����_~{����P��ݽƖ��o�c�c��ǿ(�<￼y�M�Q$��l��.�p��L'X�R�2��Q��XP�ǅO��Y�v���a�-���eb�K#��E}=W3�虥.�2�|�^,�vU* �oz�Ў�B��!5\ *�r���v���8����C�6���)���c�3~�iA��vݑ�]a*�iD�Q�`�czx�ä�q�,��ϻ����+Jh��_^��pP@���L+3z1S}�2:���7��M0Z%2Tp!��$�9H%�'*g��"�mCp�Y�syb:1ܒ�0G�tS���d������� �߽4g�.�msR&�'¿x���w"c��A�gE��'&�L\X>��q��E#H��'
a�,#�.H�[zx�qeg�Fޅ���C���炶�w�?h��w��4���OZ��zO��	�6�}c��R31�T����{-=���?��[M�)��m�� n����L<X���r�18ۮ7Cs��Y]MZ�lD�E{�֫I�;��]�����רSs�CI����mi��y��Vw)c:�K]���[5[ 8��3L�*ǌYɈl�?@ȴ�A�dR���y�7돧�߁���
���s#����HZ�ul�e��UӉ��ԥ�ƙ���W�6�����G�o����|���_����a���4�XD�"��i�
+L'��S�s����2��b3��Ϡ�fĥ�i�>i�Ngs$��;2ߩ�l��?�X2��\��1���m�����E�l��5_e#.l��v�L����cǈ���j� �g��~\��bvK�D�o@b��sX�d^�m�F�����k&&��]��bMh4p�c��و=��A9J�$Z��5^zi�.k0d�Гԥ�� �D�c*�S#���JO��Ow}~�g&�d�\����(�@Z{���8yí��Ͷ��8�o�3����N\�jK{sX�R%��lM���=�5d����b��)ą������bu>\���p1$5ҫ���T�@��צ���ĕP2��[�Q�KLJ�c����웮nb���X���4񛘸��XI���z~��<}E4�v�Q�	d������됸p��U����a�\t�z:7��PM la���iI�4q�K�R�2��$#*�+l��wߛo�ǿ�^#ς�<d"�lA?�!	f�t��%u�{��TԯF��!�(�Ш~&\'�3:3�@ڥ.,1���!��8�!Gb���4���	!l��'&�9M\��Q��3��7�����e��'�<�Bw�ʁ�&~x�����$g�S^�����6'�� d���e�!&�C\�� ��mC���|}T��4�C'�f˺M�,K�e.� ~�Ɔ�8������^�=��}y{�%�&�`�7��)$�����2*�)	R�ĕ[2��2�X�;G*?O���_�	�Z<Ae    �]_�����x�!q���I��E�2�ȴz=�́��&�\r��'�M���.(�ź,�KG�?d�;����o��KX�I�7�ƈ��l��L<ڐ�0� 8I���#7@2����>A{�X����JO��g
�`L��s�+@���s��I�18o	��k[����A�M��mD��
/GE*�l�Yɭ��xT$qaQ��7G���;2�C���Wt3y����Vw�� FQ��V)�m�?��%�P��Xx�c�QF��ei���?�g�T�Z�t�f�Άσ�5L�^���#Z��o�Һhi�^f�R.�3�����툷�̷���V����[��Bw�Pcb�a��dgR��R�y���[�z_&h��!��L����-+��F�')��y�����{�Os�֐Q�"����f:�z�.E��`).��������>�h��=~��h}s���-)�f������e�m������a��̺耽1�� ՎPB��L�κ��D�(u)��OE�C�cw?�aT�o��N+��m��X��uv�V�,��^}��*f��t;8�W�u=�U+M' ����:��{n�c�ݦ�SfOI?�j;cU�����Uą�VfǊ����[�l�	2B�9d�:���t�JK!.,dĺH鰘_��6���$=��J�`�ňt�4�lp]x��&������(B���q��L�V�*nP&��'6i��ex�һO�*�UV��ڞ��NȚ�g�#.���w�跽EPqX��C�DM[�� r�,ci���;����u-�u��/	�� #X����R������ '���*��[�$C��P���-R_,A��1W1�Cmą4�Z�C�tb���]���'�H�rD��؞��P�%�u�0d�-��L\�����G��>v�=����	��o��^��7�?sÖ�����F��bk&.��\8�r���fJ ���3~����4_���vq�F��� ڟY�<�������D#oD>x�u��!Ũ��]~�K�H谖���f�MF�x�!�㠝��Ӳb9�L<x\������ק��|xO<�	�Fcr1�>����^Ma§�<��']��t����)X�b��'�uz�&K@\�6�@Θ�v�7�j+��WH�
�e�?����ēf��/o=�8�¾<R�?��F�\������� ��)�D���I xs5��$.�j�Yu�Gf�]�A���e`�O�?��$�y(J��8�l���gm���?���d��ϻ�1K�u9��r���^(�YR�	�i��-!�WQ�����̓�E:W��|�ګ��|x��x\qaq��-�L-�wS�O��
���5�L�J���{�ԣ�	A�k��d�g+:�5���U�y��������&�锦��ԅ�5J�]XdPL��������BqE�_���ٔX�4�ąCa)%-U3�Sc~�7��Qjٜ�Sy)
߿�A��ă���JQ������,a��4 ^h�C'��^I>V.P�Ǹ�A�Y3�Wą+�o���پO�ޑ�i=�<e[+�"�_��?�hl�fS���(w��"�b1^�x�]+lw��ѴשtJٌ�'3�%6�R������-.�>�4����E��H�(2�R�
)|WH�U3qYn�R�׊8��E&UK��Q����*�&�J\��A/4���+3nli<A!�/k����,c��̅C;��c��9������Bv5?�K\��|C�#�.��&�W����-?�i�V�8�w��}l�i���1��Te\c�T�YߵDн4�H~�R��Ɨ�w5�ܡp�-�JW 0n����Z��}FH����C��jiI�堎��_�����	Dw��]3�ĥ�\(�
)ۋq3a��R�@�s���Y��Y'RM@�ă��1���..�@��iL����NҼ9G�Y/��P�'vi�QrąA���(�C\�q�O����tȋ,Vϟ�'����񪜷����C��Q,i��Ó�Z K�b�|�Z^\��^�J���Qz�j7��l���U�̧�����|�����jX�G^��9
fp_
gj&~܅���.i|ɟ�/~*2.�_�A����qR�G_/!.���K.	4譏|%��*O"&. �\�A��#n�5����̘Te�%cnAi9��0�����HD�J�dx�%�ݷ�p����S�/�GC����mg+��k���+�=��L��p�F�)M'��K�P�k�R�q��j����b���F���R��'D���h���n�r&[۟6p'ܷ�̄x��F����4�����YD���|b:1ə�0�$N���ڥ�v6�#��uyP+��DԷ4q7Q�R�"�z/˅�.�lo��?�^�_iKK=��#�e�3�T*�Ęxf�� %���Q1>~}�7� ���@��������d_"�<a>���p��P��&~���0�1�Ԥi9����=:]c}�I�1�j���g� .�j��4im�<�>};�p"��"L��
����l�53�"qaS������J�s	T��)�U�k&�H\�\ɻ,GFs;Gv������:��qNG;����\�뺶�H��0q��̥L)|�D�B�Ű������7�+X�piBdz1���eU3xEmW5�=�R�cpTE���A灲������a���k���v�#X�6g�E�� ��U��P�ԃ�B���[��<~��>�+e
�F`����VZ��s��������nm9��S���ck3��K����U�3�(��3�g��6���Gu��!�V8�� Xf��̅��BƦH��OK^��L�{'=3-���9����u ��lJɘ�C<s��g������ru���&*$>�������&#C�C�3թ�'�1qif�Rn#��6�6�Uq.�e�H�M�ʹƷ��b��R���0q��̥LG ,�'{H0�w��ݏ݁^ÃF6O����ظ���o�)¤u܌]>��v3�l���c�_CF�0����-�X ���N�_�op�^a�S�^��៑)�����t��F-�OYZ�S"�(��	{3�Ǩ���������4N)U��3G�G٥�^�8/��DN�9f��}Ǩ~�44䘺BD�t�	��2S�����Nd�KӉ_(uajX49�g���I}���Z�N��In:��.�"�Q��a�9��6���8+��E�M�P�8%q"|�!t���
 ��׫O! L����sKℙĖv��!d.��v\��L����U�~{���n:�ʈ�`�2m��5�q$.���E��<R�s��ʊ����~M������#.�L��q�z9�����U�yQ���q�)�l��E����E4��on���D#^�\p�a��u��j���8u�ǭ	�r،�������m�|/$���+�::��r��j��#Z��M�b��l�څ�ʗ	��v�����@bm!��� �KϏC\X~�$aD��q|n}@< ,��v���0ߊlH�)8?��x .�̮Bj���%j���wL߷�"/l�)[3q�B��1�Ƀ��/����+��m-�Jd�7�Qe�h%��f��ą�qll|.V<M�M�M�O�D���5�+e.� ��t�����B&W�j�U䤩�C�2!�Y:Ea�&B\Xp��#��r�E�s���m�-�Fk�Ͱ}6g���І����L���8����D��ե�w.f���MX�N�ۧ.�R�<R|��=-���\�ɟ<�,��0&��K\�~��GJ��V������|�{���4�d��P���u����L|w��p�-u8бu�3����S��>`��15#���S��Q��S���cj���g�jӠ�LG�FL���^�'@a�(�3����0�/>���o�!o~�������J�_�r��5kb�k�ĥl�	Bx�S��j�\l�cO�zѴ	�P���e1
��N�;�.Lfk���v{�ݰ=�����?w���?�3U���s����P��l�t�⚺p���w    �f\�(��y��׻ǻ�wܼ	��!�l$��M;E )�����aC�$[4ө�޿��=Dy�*��z��������>߿w��o�D8�^��-?xZΘ�j⾑̅�~��Axy�ԭ��q,v�!*��)]:W�=��/�vJ�U�� .l��M�G�SǎG_˗��'2�Q9��t� (u�	�l,|n����8�V��H��A4Sl��t��qta'���*��j�aY)Aw93����eL|g��03�^U�XTi4�$�J���99�41��.qa�]�1�6���eW"�gr^���P�����Ee.�g/E���w��n��~�W��.w)y9�k�_�7�u_5�f�����7��`4\:Eά�r�e�n.,�*Sv��&(�t�s�X�p�
�ҽ�&~�����xH��g��	�d������~� ��pH�?k�V8W3��=�.<����}�S,D2���53�:�RP�&f�%wa�[��y�7H��|?�c{wPi�)�}�u�Q\xpbd�k&��&wa�kp�	`Z+�Hq�3,Ywi:A����D:l%�WUԵ�!e��ԉN������,�]O���1D���������H��{q����j�t�G��=l��z���z�����V�¢S����S�C��x=~��J6�E����-vʭ�R�x�ď����q���j�+\R����#,agV�ńnG���������4��<EkO?4l9����S�j:�K]��؁�)���c�s|�^o�V8����;���:��RdJ�+� �ă��ѱ$��5��_����Au�8�8\����a���=ъʲCI��D������0q�V.P�1]���o�ק��H]�$�j�]+S`Oi:Q�K]�b�4NL�)���C\nS�[��z�t3��MgGKw�g.L���Q��s�1>*	3�)'7���G�;�GX��f���+�®�+��-�B8�C���ӳ��hv�w;L�w��E�}��{���H77��٩���L� 7�@9��㛉b3��0�y�q����׷�_}K)z��a|e�LJ�ɞ�����H������t�g�a�__���rt���D��U��f��řICٔc�r����-��]s6��Q�������>��)�bޟF
�bc�SDqi���ą�O#�8�^��q=�6RAq���"��^��f:An��pm+x���i\BZr��2A~O?I���������T��1q�Z�R6����8�����xx��� 5RaJ����Y��7V��=@��P���0�ϑ��-%Ȕ��!Ia�j&��N\���_��MOzN��v�š���O._��<�L@�VgJ��3�{)�pW�:�/V�vidFz�����<¬�6�P3&������jq
5J|��뛦�Ġ���yC��I�IS�N�%S��Ծ)��Ro�~��p��'�<0����Hj�4U��%.l+Q~a���xܫ:�/�����@8#��fb��ܥ<��k3>�î��n�e�*D��m��X��6��
0Lj:�xI]�E�6�6f���x �K��J�@� ��ol�l��ǋąxTZXV&�޼B���7/w��o�}��iP�ͅh~߽���f3�cڌ(�R:Oq�P:�2hd��+��.�O�P {}��x����5�Dۧ=��r�xI<��eR��T�����s�.m�&Ĕ-Rϐ�2��+M|)���������}���[���
HD�Nf�����̅�C���^�}���1�ͷ����Ț=�?�1��8
�"���K�s�brN&9���Q���|u��6|򣘽�s(��H�1u�4��]��}��KY>���ھ�~�W�g������t~��p��"��>��ۏs_��q<�.?!!i����aH�z�_��&�=v,:��E�)5�(>�.���D7�!�E"�r������pN��!��`���-6s�R��wi�Qg9I���ի4��M|������٤^̊�D^f�mB,bz��ֵm�ʤ�"�Yx�qt,�Ϟ�5������L,�6�^��_����0eJEB�#U~6�ĝ�ڶj��̥|�
� "F��7|ݿ��-}����]�}w��?������ݟ(�pGgPpP)��"�VA_�J�I8������� s)��z����eh��|��$d-.�&l��"��x����dR���;�3�r�-��l��X���q�TX��t"&OSM,\�A���4���i�q�N�v=�i�|���l��5b��Y���,��\��j[3��#qa�%r������p/�l�8�펐��$0AôGB��Y�8TP���#>�p1`=?�l$Z��PQ)I]/XV��KL'�ȩEN�Ƈ���z54�.EH [A�GU�KW�\�
�}keJ6u��g���Eόq2IJO�H\X2E5��S������](�b�BR�R�VG�h<Œ�0c�ڬ�;Cj{KF�!$j�x{$��)6?Ԟ����v�B�TE�C���P{���;Mz��,�ԭI5z�)l�ъx�������d��0�ؾPO@S,������+��U�+5������W�Z��M�X-��q�lP6N��b*�_�G�M���{f*d�M����DT��G93�ezj�'�Rfnq���݆kg��|���(��9��:rͷ����i��ӊ�r���x��������J��O�O{��x<^��D���lq�t괁�I�C�D�`D�����O?v����G������뿜�B��s�+�.�L�l��_���t򀴽��8P�)�k�YwI#*'�G���B��bU3qe�̥\��'?5�wK!^��8�=CZ�T��4q�̥\\�H�{D�J����6�ǵ���P��0��O�,��_Pc��ev\�����9���Ԅ~rJ�L;�x(Z�ȭ"��r���x��ol%�:�/�����}ݿ�h�)_���]�����kA��~�|p�D��k^�b�C���e&FD\ʮ��q�Y�>��QÔ �/B/e�p5�	�ԅE�`���"Bx��PGD9/��e��#^��x��P����*P��%����p��׮:xm��C��e��>y~���lw���]���{l�5� H�p���+�5�V*Pc�� ���
 ��	iԮ����u�^��X��8��w��Q2�;J\�eB}�6�sa��a�׆"����;?�
I��XN��f�K4��dG�!3E�3�La���C&�����O�]8��Ȩ;�� ���m�� ��t�nK2)Y���8w� ��ǙRdy@�[2HJߪ�d��Ԭm:������/���z�%
��Q��f��ǫ��V���(�"�9������g��o��Ud��D�/oK�zx�-y��?y�1Xȳ����(s)���!�8�i,|�G�d�7��M�ҒF���kmv�&,*����ą�
}�,/�O�vo e;_�2\:|P��AW��+m_3qGx����$lT��Q�x#�P��h�r�f��rąoZ��3{��{�57oA�*86/O��<�QX3"�s�n�i*ۙB͡�f�P�����˾������[����o�x�38!,�4��7ą忁� �����忑m��W�h9���t�H�[��S'w)���YTd���pu@�i��H��!<��Wi{���}b:\�.e��k��AoیD�7�AC0O�w[�u�b��ԣ��vX������9|�\s�2�8��V�c��7���>W�
>����!nQ�������3��#�zI��]*ْ�.����? �� ���5��툖!� ��}_�5.��	�����@4`��sO�!.y�jQ�����հ�﮺ڬ7����YnI%R��la!��,�x�q�nh��G�؛��A#1 ���i����d1�T�b����Q女����ņ�):ҋ4��h�%�L3
R�K��D�H��C����g������r0���O�z,+�)LW2qGO��<V��}�[ N�p"Ni$����ύ�.�1�"v��nT�;�wtۖvŉfi     ��.E �(���x⒧�=�D��ѹ'��]�_$X�(
� T.�cӌ�R�!pO��F��_��c�ܿBXqx���Z������o�R�.i�#"I`��뺒�'�=���N�F<�o��	��I8Y���ڨ�F�,��FI�µu�n�8�OR\AcWSr=���v�*�����K{����y=�V��N�/~B���#3�"FI9���-3"��1��L��2L�BqJ��wB�j�k R��M�Ub��U��Ѭ�N�Π}0��+�Jx�7JR��O�_��_�ą%��׃�,ê4͝�F��MJ��#�r��&.l�[q��p.+�.�ص�+��fNkae�ML��%.ku"�tbc&�!�1~x�~�u�\R�HL\�!q�W�R�&�4C�6�-J��W�Gm�9�"!��f*q'�S��sT�v���G�.�4���?��4:�Pߢ&.l�ZL����8�%3)E3fJ����ٯ�)��K�LP)�����~=^NP�L"\��Ƹߊ&ޑ���9	�:?�$��QI��]o��0F�P�A>04���.���:qa{z�Ņ�����}������9(:�D0;��
�n4�p1v+7qe��%���1����5WZ��MCU[۵q�����&.�B�1c{��i4�Q��WG!#ilW4��o���u��hN�-oN"2$�I�\��2���*$.�'ע��X�y}��������O/�>�M:c����C����]̰`L|4E\X]4����E�ϡ�tS% �I���%!7?����r/�G\X�>���P��X�
K&9=d4Q�ODHNʠ�n;Gڹ�'��|+����AZ���G��/�6�I��Qb���ą폪����^r�lq���J��h�f�v>f2(lR2񏋸�ܽ#��ߗGֆ��O�Q��g��pb��&vaO=��=U�m�i�?.qx���^b���ą�*�`��t��xnC�}��T78e���h�`"�K��Cp�&1��n��h�<��>��Q��n\��E��G:�z:�c�J�?�A��|禙�U��+�L���%
_��V)�y�v�.�x
q�>}��&������`�����[𹉋�.y���8D�	:�e�>"����1NӂC��Z(�k'x�Юd���.<(EĲ����n�{����$�`;߷�;猔%�S��8��kXbX�(�L�w� ���į���+�^Έ�ȶ+�a�Z��5��Ӭ���eFAQ�7��v��bD��gVz����ت��AL|	����G���`�P��1��A"�?�VN,3�[��.�n���5�y��4Q�j�9߿�
0��R�A�8l��^2�cb����b�����X�Z\/V�r�R�e(nT�2��<����V|��c����"M#������%!m��&^s��p/�4惘��b�"�vXX�{����B��H8�;��͘b�i�)��H�bsB_�����������_��'$R#�ч;�&A�1��+���ǽ��a�h�$7q�Y�¨Aa��&������@{�*�����[�E�KC!�xVen�Z�K:���4D��m�G2����bq��﫳��f�!����^�T
�i�vR��i����'��m��]��y��w���qL��Uw�������&08���(�$���<��1��cn�q���o����f7�R-��!�x*M���	!mK�sߣ�
m�z�Ƽ��3w�t���������Q���f�|W�x;�V�`��o��}�z�� o��e�J�M1�(QW�p�J��q��6��E�ђu*%��q7�ϠMI�+�x�&qa��ʪ�����G������/�d���~��|�^m<D5�?����[u~G$��a��j�����ΊT�31�qa���
X��Q��5wR��\~�[�ն��s_~#.l�M5�H�3n�!y޴Xت.�i�h���)�+5�0���T����i�ن�������d�2K&��N\��������U�>�~����]���@�tb��5|W�S�d�:ԃA��JOФψ!f��Md�R��F)�(aJ&^���:�F W���䫳8�o�}�wR�'�B��I�%V�\�QlG8^���C9)5cƊ����opq�Ipgŵ��Cٍ:��ƃ�סL\�e��tP�C��o�K[�?��p��!�Vc��������
i����6qɳ������[6�D����V�Z�/�m�����$�Z7qɰV��#V��
E=LҺB���̍��2����;c��ą�BC��La������&�p��G�`85�����i�*��{��3F�N��x~�������=�L&�A���!���cf�~�K�&�0�x_��z_q�y�p(��{7)4�T_��`=��Ѫx�g1����e�؅���c��������O��hxﵵk��+ҹ���6 �xe�z�����U�����;<B�7d"Ln₏ą��ù9�m��s/�;Jvj
�N+=2hw�[2���b&�D�y���QX�8S}!ǈN���^�ƺ�3��k.�i����T-#8�hKm��j��+c4En����.\��46��b�L�J㼎����h�i��.9[#�$.��FatkJ�������v%��4v�r�_8f���-9ğP,��9)�������O������ENDOj7^yg���aU�}	2�:p�U#�^�3%/`A\	?�0�&�W�̗�jw�����ϧjy�񄊔�Q��%����Ś��o�q���[%&�I\8A��:�kۡ��gU�0N�>c/��dJk�oԴ8�6� &��D\8��y*��������C��|w{����w?~>���,�˧Cx4
����[�������̲�SN��Ψ+�
��c_�Ʉ����{<qa�@P�b�~_�*�~��s�r^;lh
�T��IL|���x=͋��pJ���ohj�:gS�91��tb����B)�b��uNF�6��SQ?.P�'�����4c��4��Z�~�$���זL\4���:F�f�,��zxK�e���:�+E��LP�ʚ��ߕ�%_��
�b�p QX����~��#��A�5t<�ueO_��LuK�ٹ����)�Ԓ�MM�@� �-�ݰ��Hg�9찊W�k�YԹi氋]��N�"��$��e���k!��|�h�[�.,w���з�.��X�-��Rw *��2G˘��>q��{��Xz�����ݏ����������k�]l�͂��n;�%���g���"�p�N�3�0�Mq���S�L�4�����R��V��j�=�[<n	RD�H�X��2�IL3P�؅�"�d�-"Up�t[��4��QuW, �1�1qkL\�5BƐj� ��
G��G
%h�1��Ժ5�%וN\8�v��J����O>���Zw�SHA���5&�����;%.�T%hj�Ƒo�Ἷ�S"��2�P<�ֶ�qV�Yx`h���B�!q:�M����!�h��cRVFb�Z��饪���M�a������n��r����z��O1̡�&@���aT���j�h��4�c��؜Tl���E��3I�c5�P,��0L����hK&0C\��r�1Qz��|�z8ML�qx�.�o��22��؄
�c)ÃN��w��9R4��C�Z��F�G��뺂�q���<�0�8%aJH�ֳ����D{0�p�zp0�p�J�i��
�a� 9�n�n���;6�W�Q�MF���z�%�}���1G�#T|x��A$Kkr4��/�މ���(g�`������ù�G'K�������]�j5�?>�qM8����~𼰐�ڒ���.�����j[�����^>'b�s�gRa�o;�R�3b��ψ�&���^�z�}7�b���F�Ш��&fH\��b�g,�]8'�G֊�G&��"t���lJ&��N\��L��L3Fv���Ԏ�ǩ��X��J�^m�<Q]������S����P]�!	 �{m��$Z퉊
�N��ƪ�rǘ��$q    aTT e��8�Op�Q4, *�?V��u��{z��+��J ���d�_���������~6|�a���s��^b!����TǙ"�Sv&�!&^��p0��9R��b�����I�Q�)ȥ&^Ґ������U<<	^2�ӛ��ן�����L�@cq�z��4o$&>o$.�h�iOc�˳���_���+�����~!0���Z�Z*� ���ߑѷ���3�J׸�kz���oc,���Z��[��,�=S�p��0�э�T���[������E~
�?0���|�����T�������{u����C���_���q��nG�qm�x�c���K��!ꦑD�����Z-��n� ,M��̦�#�ݏYS�h�&^���056��M�T�%:���,�L��jM*�NL|G��0�
+D�x���Ӯ"8�Xx,��!]��?6t�Wf�1��Q��Q'�������ѵq�{�A�
vcW��<�ȃ�N��j��_|grp���֮���!&n��wrBd�0?�	+�"�\�;���i���b�$�ơ���:W2q���%�{4H�_�e�;�}[��x��n�^������wHo��}�qx��t��|_=���<��=V��?���	r������s�whEG~Z�48$�V?U2�\[�[�4��J���a"a��ΉK&c���|Rc�i:K���ĝO��H�	�x2m����E��a�NM3�؅Q��J�M&B��1^�"��\�ĭ&q�4�|z�Ј�t�g ��n�LL�%u�7M�Ա<�v���0�����Y������[_4B��ݏ�G�$^o���D�Z�6�T��1͂�N.�X;>��~;���:�(r��9��4�-��3qa
���D}�S�y�iȗ���Ic�;f���6D*ڊ��ۤ�K��i�ؚ������4y;��g�g���T�ZW2q�x���ke��.7�~���%����
q"k�j�ܼ�Ü��i��IE�w�B��l� ߞ��P����a,|����?���hc�J&N>*qaJS���H�=��3��_i�����i8�\FǏM3=�؅&~��_Z|��>�b��6fZB����<����"K&�֜����lRg�������� l���(������5�����Ÿ-�	�^�N��EKL|���0eX�k�|{������?(��B$�t5#W2͜8���Ch�Q��5��x�C�I��WG�0��cp�$�A��d�9�ą=��(i1=j�o �W�"�$�@�if�.��T�vP�U��u����u�(�uq�Ø�Fqa6�=(/��r�x��5�9C��~�;x� f��Sn�K�ղ9�6�\���w�_�~ac>b��¼oIH��*�fV��@��1^��_/�>�x��#���n�^P;� ��yj�L<Ո1��@⒯V#X|\����f?5!��[;��H�&��
%K��j���Tp��DSy���plu�b�)d�����i�&��B\8� �Y`H����r�����&�H�L��ۺu��*���I��4H�2���tҁI:�ҖN�A(���Qe��2S��<�~l�i��Y}áe�[�;9���m�'���c�t�4C��]ؓHu:B\Y�'�x�և��6 ��	 ���P�J�L<����l�)Gĉ��ƬK��.n�fʩX��Z���".��&.�M\�廲T�n�Հ�T�E�v�I�e����tG�K���!.�g
��C���w��{��#1"|F��˦)F6�~ ��1�-���-q�0��
��l����D�S�
k���©Bcr/TB\��i��i��rرl�W�ݕ����¦Qg[ٙ�i�:�䇧�t��c@���()%��X[W��SeǖK\8�G�'q"�D�d�����T\�5MNk��KH�u��K���ģɉ'��$��Թ���T^�ǻ�z�^�G�ߠ�PF������K�d�t)蜘xt4q�Dܘ5kJ0���8�*�߄����6Ѩ�\�a|7I��i��L\��p1ܧ���A\:�&Kq����V�b���F������� ���>����4[����M�J������ąY �-��d����Z���'�@\\o��c�R�iӸ%1ͤǱ�[���j�_��} 
U��X���B%��D��s������r�a�������?�$�hʬԴ^��tlnf�WJ\ؕ�I�nP�=.�Z����o>,�~�v��ےD������Ԧ�M�K&������Ս��t$�������%��Tz1���r�O�4#�pm]L��g�<��x�ZL�#$��d4�����*������}	5��\-��H>�	-J��Nc�C'�-7���.���IF����||��)���1���kh�5��HR/�E\x�.a��<��A�W�w�/�ڦ������0�K�����_����~w~���w��j��Z�nc��$�،��gw�9/�Z0h.yםoė����H�������DC:Ǵ��8ܔ8�&��^x���/:7�~f�f��#菇?Tg��7�B&s�/O��-je][��P�p���g��:Fr@6��[�w��x�
�o���|�/�c�S�!�Ij���Ǚ,�fOѓS;Ȥ�U�K�7|�_�au����`7Ťq*Is7�1��3�[gI���f Q�X#$jOV�e���tΫ��s��Ά�������[�-�L޷
.���C<�_����W�� *��&���b����7��SC4��(��8;qa�lk��F ]�q�YG9=
��Ǡd�3��e&���pze.�c��.9�2�~Y_ރ���C��/���P&q�GV������K/y�Bɥ��ɑ�=:��嵝*xe��4C�]X�qTC�^�JPF`��E۪���bc�,:}��כO�bZ�:n�d�N�Eh�!0��+�8Tg�¡:���n4\�[��=��O�t��UukM��S���%_%�ER��@p�����Ar�p��nu����>(\M��tn�@����$�'�&��C\�O);nX�AX�r:>���S�a(ޅ���P0�L!���c��J�����Ո˨*i�����&��M��qaU���t�l[�wj�u@P/:CĠr/C\8x'��Ǡ��ߢq
�	;�d{�����4�m�ĵ��<�nq��I�w=L c/T}��Z�a�Lb��x(6������,��{��"��:ay�Q�O�-Eb��k�";�z�+���@\���nߤ�x�;�����]���h-��D'�E�J��<T%G�I\��b֐��f�X��X�#�2����
�'�x,2c�N�ą9��I�
o���wU�"PJ"�8T;F&��f��S�!Mo�����4��b�$�G� (�@_�՗�v��݄ٝ�'�0��8�X�XUU]������El`�:���/��p���s����p7DB(�� �؃�i��wM:�1ڈJUg���ߟ�1ڮ.����'�7 �:�s�:S�d⡃ą��v��Կ�uxE)�$u�еڵ�d�E�+� 㰤忆u@^�7�1������*H�f��_��D>j,�-u�24�L�Ҙ�y�������*|�����Q�Mڠ꠵mc3:il���.,�TO��1�����v����'B)�"u�T��������E�	�q�n���K&.3A80*q�Z�Wl���������!�氨�O�ǆR��?u~Di����8q��uLosB�b�QV�%j1m���h���.<���X��������8̎A�*5ҁD�yc�L�7v�����\���a� /ַ�.�p�L��䰩K�&��L3-w���瞜��3PƔ�L��#�pڧ�SȕL�A�`�c\d�V<a�Q�������@I��D�N�R(��+���f��8{�S'�u_�+)��QR��^�[Zw*1�Edk��&Nm����B-t����������zxx�.�wXWɀ���e��P�=�Ŧ��W��<��X}�c�x��    *v�m����p \�lc7�ģ��f7F!�~�CITϹ��B�2P�mS �֥�"߭u1J*7qqf�´`�u��T� ����I��L�JR"^&���4�&��Z/�����=7�~&�]��§~�5hi�P�c��g�j��@;ib���ĕ��|��e�ӗ\_|�����Pz�����M5t�������L(+u�4Sz�]���t�"��#��g�"���znMCi:P[2����5k�NCC�x��Q9�bru�@�������oG��m�E�4��M�4S�]8�F#T��)l��!ʤ�(|�.d �@�ٖL\(���O�' ӏ
�-4R�k�'�@�`\�fJ-|�4����ZOD�>D/�?��B��Cux<<�����O��	��{����$.\M��G�iܧ~���/99*�D�V£jE�Z�2�Cd��2D
5��0�Od�,�P��]��o�Ȇ��'.��ƀf�R�����J5��y�>�x�8bM)����c�mג^n�yą�@�t��jᦤ��?ij+����{�K���V�
���v2y��`�W��R�<�����&.�A�ñ�y��C?�t�h���[�Hq���Y#*6�4�b�|$���k8����D�����q&�)]���C~U�%���G�ą{�[�	 k]�9/a�Ǳ4?��3̦��u��~)ˈ0v����"F!dn�P�<��ʧ;qW����� d���G���HU�̰�"�|q��1'�p������\C�T�����l��,���qa �ʼ#����:Q��|b�R�G��E-)��qIp��fX���ҍ�hֽ;w��vC��}\�-�Q������%/0B\�5"☴���}�Bt�`Z�7>X�bbe��}�K��5��|w<���P��%xj���d��UI\X�J#G���b�Y�dv��o1��;�im�BA���{�#ߙ��܏���$��Qg�?��Y��!����Nӕ���\�>��W۟�v7�1�4k]J������xYn�U�Ӻ�#~b׌���p�u#F����7W����7u( w�ưAP�25J<����#�,��5�6���qv_����1����I���@n��1ą���N���v��o�0DT����w�����o��A���P)�!V_�Zk�����k����/��T��z3�F�LWx�t�u�b2�I&v�I2-%�]���y���{�Qơy�A��xΫ�M�/lK\���/S�$d��.���I=��⿚��� 4�����d�u����$��l_�V�GU��!��+�b��R"��[�I��������Y�ҚH_\��z�=ҤD[�D"�=I��S^��c{���b�4��~<[�7�}�ۑ�5'�fhj8�.7�]#���D�i��O�1;WqȦ~�J���qڕL3U��eZ a��1j�\�w�� ))����Pe�v8�.-��*v��P�q;|��92�(i��t�_h�j'p%k%����l���Xy/G��������C�b/�	�k;���'�bV��`/-�Q:(�:�D��_8j�.�ڒ��j.�u����^��UVR��	�;@-����a�i����AfC;�B9Ō�)�k)��7/�`巶m��x6p�����ĕYHi��:��%�s�����C��0���JGc>��9��t(�غ�dc�4����U�Ho�]��⽟�QW��m��qu&�=����KAe�d%&�%.�B�<ԨIY�|=<W?��C{�y���#�$����y��R��������U�L��J�]�ٶK�D���ą��J��c�h����'�����!Y���R<o'��X� ��r���T
v#��퀂aa��ڿ#s#�&U�)?��զ!S,3��=8^���X#�<|.�6�h�O��1A�'�ưOңv�=��pM�ubL\���������ly�?{��Γ k��Z����w��Fn���%_3����S�ZM �,��â�/ ���b��|��]�8�h;|؟�A���j�`X�	�޸6e"�L$y0,��j�����_���b�C��i�Er�k]R�NL|W���j���)�7�1���yҩ���|��0�ٱs%�mҭOL��'.V��#|�����ix��I�\
ݢ�M�JӢd�I�c>�62"BS����9ӯ�yR/<���ڢiv�\XH�0t��w�����b����X_��`$�f*>�^�;۴2U�!&>�".l�_C�����N�$��/1�l\�3&�L'.̑$|�"A獪�����6(fR[WuW2�+�ª���_�9�.�1�k��7��t�s����5�f��,�|9(� Eb_M��s�vb���Ϭ�k$Nӑ���R�&.�����8
G�T��fG[�S/t�+�뀲HS�	��T�YK�͹�� .9f qK��f�}گ�j̀(#��k7��vz�g��v�,<g���p�a];yΉ�o7��,��&�n=�j�+"*��m��j�WRQIL�3M\8�T��#��F��'	SXnܲ��!��iF�$v�%H���Wx�lO$Z6Ņ��DWwҒ�=7�#.���Ԓ��Q����B�e)�!6A&����/����Rr���uuR�Q��,��5��2]Ul�ٶ��&=qV����wh�(���x|����h₰ą��d���̏�Nj����N��9(���bY2�zą�sP�!�������p�m|kٟ�S�H�>(�fA��F�4qёFLn��ą�!�K��X|��W��S_�_�p���ywޔ��lT�RW-��T�L3��؅�
A��Z���}]��(ni����,i���!U����ħią�ӄ��1O���c��VS zJwDed]C�%�Sn�Iwb��u�x���j�;�e�^���ѧ��b]y�Y���Nf�Yj����6TZa�����"��sEz���&�Fn����.<�L�l�Ark�j:�^�-��0�6������?qad��V�����o����՟O��<��~�Gd2H���#�?<�hCL���02�lu$p\����������|�X.#2��)���ڎ�&�e��<��	�M%MLk�dBv���O�C�R^.�� 3��Nd��VFd(F�G9�\��B��Q->�.-k_�&.,�A*ud\|�v5�18��Q4AH�-���r�C��'bą#��X~0�E�� h��7#����(��a��D����d�Pą��aǺ9�o�ٟ���˘	��ܑ�9E�4�?��8�q�±*:݌���~�������q=<�ޣ����c$��>^��v�{g6�%H��$��e��+�x1��ua���.l+H5"���+�!k�d��P�\�־�P�}��~5|�/&�P'p�<%���VĐ�̒�*���������VsH{G8��
M�Ju����f��K^�BҪ�O�Y?��	�.��~���Za�Y�LL1u᪈X�����_�Q�$$������{�-���=���x�mN9U�mS*�
/D��ZC�_4q��ą{P���L��s��||P���G�C�Q<���&��N\�|�p��HR�ݜ�\Cij;e��}W+G����J\�T��L��E�אO@��m����&����ȁ�4˺=�0)&4{�w�U��/o�I�J1��^45l,�07���^D�����lH�}\�3��PY���=,�1�$ʶ ����հ�.6א��ȃ��CIPH!�8��<K&nY�K~���
B;P�S�NRc)��R��gǠ�|��d⎰ąa5J71�K��<&�{���/�A���A���6�0B!�l	X0i���b��B��DK-|�{0ݵF7V,�Y��T�����6W�.�Z���q[�1�=���dKEb���=��7�B��N'u0�t���U|�����쑞�آ��+���W�����A|{�r�x_�Dz������ĶG�v��Z(�Y��Ƣ�J�	�91qwF��P�_�ݖ�~�Y�8/����eRKL��B\����&Rt���� ܁��I|��� 7qa"�����"��N    �!&h\�n�����KV�P:�j��Y\�k���/v^�P���c!���s���G����X�L	lVW�$Ϟ��zp�:k�)�z�b���d��+�|�e�(وI���q=�|��� 5+?&%���Z#9��n�|R[�.׮d���%�X*����_p�Vw�o8&���}�><?�߻Ǻ:{���	Z�����)p{�����G���5�s����T�P�>�3&�-$.�[0�6�Y0���=!�
�l;|��Xc9�_�e@�Z!Y ৱ{ՅN��37q�@����e��T���b{��� ;=���tw�3��\�J&����p�!g� �wH��&�� �l)ȅ
�#j�ʥl;U2q���%�XĒ�{�}x�G�q�i�.��dL�He���Oƈ���)q̓�X΄W�Q�N$������8�%����z;V���g!��]o����	��AF�iI���v#�Ǚ�i��0 ��_q�+���ړIȘy��)YwƶV�L��n�RX��=�G8P�:)Ok���%kC�8E�G���u�3"\�ĝ��K����D�\_�����秇҆�~T���~D�?���������ol��ߨ���NIk~�l��K�z<���h �W�����H#��mW2q�N��D:Υb$���r��@��}��̙���n�vqO+7�g>qa�|�)�|�l�}X��1�~��t�{L/HD��sn�M����B:
g=_\m���Z�_�׫�n��wׁ�7(X+b�jxI�)�f��O`mU�}�ۯ��z�4N�դ��h�\%�%�%���4�ɏ]��̣>�.��r�z	�����QP�P&�PR��#.l�Ot'��{X�����kD!�vCT!J&~�ą]�iԱ?y���GI{�����y�s�0{�,�[���zp�)c�i����A�Vg��]�EuA��5N�L3]�؅�F#�w����x����|8�[���6�1Ǩ�)؄m�4n�]���\"�9�0�u�?^�a���6���TXiE?��&��$.�g	+=Ѿ>\⨇��lmi^�(�s�Q�M�D�����BdV4Ƶ���Q�g�A����>,�j]>0=���8�:�fQZ'���Mt`^Br\v����XZ����AF�2�uK\�}.0\?�M�Ā9��]<ߒ[�Öj��J����:c~�����?yN�Rmh����>���!�'&>�'.yPaqT�t�d�m�`�����k����x�&��
6Ӝ����?�����"�ED@�"�A,zz�>[��K&�d��䉏���z*���)��4I�Pi~)5f���	]��?�c6���[�u���������䖓X�Q^���ӴC�f�F"�H�hMڼ$&>{'.l�G��D�D��C�s�O
�47�1�4�D<�Lc�IW4q�H��|"HN�ꟷU�x�1}��>��K0�w���i����";q���o��?h�N����V�1�8l��6"R�11�Wqaa�py�$��qJ"w��4j��������m���i����m�.��@ˤq3N�=Pi��8xH!S%1��Cg�%�asc�f�^냚�9��?�3�3VMG�T�U��,B���ДL|>J\���FX�.��~#�?^J�S�Ѳhj��ы]�~�3�>��{i�)�_&���B�%W�M\����8�2\�Q�����>_���d���؃CDJ�� 9�ԧC3q�Y�RY�J&�����iP@���H�j��]�J�J�H��Hꤕ81�?�h(����}C�1ڷ��HT���%��%.L�o�A���b��L�'O0�Ƃy�/jħYn�*ą���Iu(����JS=��g�5�*���sD=�*�>Jn%S����h/�їOn3"�!�Zn�^~�s�4JB6��5���?�pe�6^��7�IMu��U����?p��}�;|}}�n�P�Q�*E<ߒ�y%�g�6-�����]�ONF	�!��|��8�Jǈ��a�΂�U?#�.X8<���tg�H�\�X��*�Nif�8z�v�I����纱�&�Ы��:�8��Ɵ{~�-�f
cV��I}ߏ	�x����u��@��;[�ڒ�;�.RU���l�e{=[�#!�� �V�V�Ӕ[M�������>�V���3���U�\X����EL<1����:�#�Àm�z��M��(sl lJe�&�;L]8�y�����.v�7~,X�Kǂ�8�0��*j�3&�����+B�==vl.>U��{57����k��Le<��غ�]���IL3@�؅�y0�eV�v=T�e�aQ8u�T�GZ�cE_n&.����4�q[����^Y�7��)<�[�z�S5�p�3���L�1�����B/F^q�<$2�NOk�z�T�Ў��X��E�I\r��z˱ҷv���":G�Դ�,�z���$|{��=��%_Wȡ~]��(�6Sʅ�D�wMFd&����0l_�G�����J��d��_�%D�\��m�\ &�C\XM;c�Zr`�VlnqÚ��Q댦�F�Q�Nd�6��r�s�So�Q�X�_�@���-���^`@-���w�9&�?�K	�8�;�������o���7uDt6�M'�!�Phے��M����n��gnL��ywH�w��Z�� ���%����..��{,q��I�5Ae	�aw@�-Q�ɘ8:O��)kJ= ��{� ��G��0/��6f�?>�HȪl�4߉]x��P���~����/��#鈶#"-4\n�2�t� ��4�@�]r��@��7ן�Ե�/����%k��Uz�Ɩ�C"�Ȗ����>�4������:�CM�L��\�R��M��4H|-�x�qaiB��?䢤Շ!7� �jLW2qōąT�L��s���|@�F�y��`�"e@�BA�	���&7ǦI�؅� J�F�����Ǟ��tN�K�i�}����	�:SH]�ȴW����td�qn�>�ą��$\������x�"��@r���ߠą��$X�aߟ�֏Om|���6F�d9D;���{�ff�)�W��j"�_o�:X s�� �������X�y�|��.$�R�e9jd:CI&Ԙ�xm ��ic�#����d>�U<_�kETe��%���T��u�|�(T9Q��B�W*�d?�����g�Z�vQY1o��� �C(�jڒ�k�$.\C��h�ȶt���D��8(��S��K�R&�p�R�ƏV��
���=�KJu���1!�!��0��X%O�!.,�F8�e9B"��-�����|3b�zi�3����GF��d��18��eN�����3�@���x:3�J8��Mے�ln���ą�á���G���3���ɀ����9�K#�<�9����J&>�'.l����B��,'1�~�
�v��(�d�jڴ]AL�mW�]a�����NŃ�i�pb`髅U�L�!��p�b��W��}�]|�����a9\V�������D/"�}����)�b�Kn�O��#/�tH.�>��|����������~:���&�L|񝸰�w�F�2>����T���H5�3Ww�c�L��R���,���cݮ���c��D2���zYm��.���Z�]��sϧ.�j���v��{�@a�Iv���M�ȺFAz��%w~'.\{ �y�������K�Ng��y�MgTTdfL3k�]�5M���~����}������:4L�oSk��T���{���9<�?|8j	b`�ݨ���J��Ik��&���;��^��܉j`hu=�`��X�I�L3T�؅��:3�AG��+��Hi?_e��������=�؅%D��U��D_��F��v�6�4투�%�+�\�2ܣHzx����|�����g����m
_�F~d��ڵ%���� N+�8�НlLnf	�2��J��iFs.va)Z},�+ߙ�X��{SL<~Y!�V�5���;��p�xg���@��D�lZ�
حV�db�Y����9X���,���b=�    �F�$��4Sd�]X�D,��a�6��(ckT��E��®�X���1d�^:e�7yaA��o�i�E|r�W1���T�w#��j|��48ݦ�k�i���0��-8�k��a;Vo�qv�8K��oh���NB]6�J&.3H\�9�={"ĝC�7���?o>W�r������w��r�xq]���;R�+����j%5IrW7H\Z�@
��"�#��Sy[�C�ɽ%��&.��'��ExTH�{H�v�C	���P=�_��֬)Cp�Cg��*=o����ą-��w-�a֡��4�~�����������i�qz��lL�eL3yZ쒿}���9����}|}z9T������O�OT���T���ߍ/
!F �ӖL�w��pߍ��#��f�!��ޝ�(���]�٫Q�P���
���d���뉫�}_�o߉�C��a����k$��3]2q�q⒯W�)�������1�#LT�K����� uV�(�f�]b^�%��������Q���@����R�#��F� �#T��l_�����O��a[}���r�Ym*e*/��l:c�]���]��q:c���|�
�I��_l��߼�+đy �DR��@@k[ED�r��#.���-x��G�q.�aw=�s��/�h:�(�Wt^�%��pE��c+:
�U� ;_�y���
��Z�_;�A��+����p��;:�!|�)-"��d�G�J�X[2���.��HG���8�u�m�ݟI:�A��yڮd�u�]xU���|��~���d�I:���V
�vS2��q�
A��=�[�n�}^����Ÿ�B�
@��R�h�(�f��؅_��ւ� y����>I����x�@�C��Zx�w��򽛉�d K�?�>�^�"����K�'h�LcK���.v���cW�ӻ����_� �M���y�����X��Bx������L�ضm���� &>- .L���p����.�棡��ǩ�����
�ĵ�{��9��gmǢ�X���T��=Sܼl�K�:Ӫ����7/�X��w(�X���o �eiȠƙ*B"Rw�d�K��|���	�q���O��6�qMJ��7B"H�kC��Sw�$.����v����0�_P;���H�O�m��J�t"��&�畺�� ��F���G��zk�PxPʓ�8���՘�M<���0�6a�N��v��y=�j
��P��먚�I<�47q��%/��ymO7�t^ÅW����P�Uv�Of0]�e�^l���b���Z�S6���������C��{޵��C�f��+��'}Xާ~5,{Z�N��ej���!����M3��؅��7�.�j�LDk��Q��DAnJ Z��L| A\�"^����Y^q!Shs])!�p�q%Ӭ��Ʌ[�:*7�T���6c�Hi���ɵp�+�fCē˴@i�CZ�1�������Χ�#�y�ܯp��b���#F2��M�p ���¹�y�
sz8��q��ܩ��k�4��!�z7�7��L�
;�)�xu�PG޴�NK�_aXC]��;����4�4.��	?��^�^�o��w������V�"Q����������￸_	�����w~��F!-k{�M������B�A8�L�F���/q���~��m���!�V��!m�?�NU�ķ?���.shei5�8�H��s%��ą[`��r�ޏ����_��(h5�.�x0���)���q����kH�i�D31�/���/O2�,~6L~;�EF	�u`�i6�?��X5M
��XO��)��y�ܮFHW�p�]��D�*C*B��k.�X�{y�RLJ�m`::�;7�qa��Ԍ�d%�_�XZB�!F"���"�3��'.\�	����T9�'�e<J�Q[��nr.�^c��}�p<J���c�0�e������$%�2�L��\�#���2á�<X�9���q�5�����p��!�đh���	�%��"/}�D&�T����	���m��ڒ��$.L�E@0C�����?�6����:G ��|�bC�%�J�;�Mܒ�I$u+�fǾ�
E������"Bȭ�쁪,Z'�����	���(���;Hj�k���Q.>�����Q(p,�� Ѥ(Cb��8�.�n�B}�U��z�:<�y�G�ãr .^��K�o�"B�pKL���xCT����:	MF���������+)q:7ͬ?v���j}*�\^���������;f�'t�׻��sx�Lc��o�+S�����u��׵�K��@\��I>u�ܜl&�:/��	:�T/9�7�b�:#�z1���2-?���v���>Տ���C��������w��uUE��
.�۷8u��}C%���GL�ު��[���~@�t��}� �\2�7����h"d�Y�" ��Z�(*�F����9p�����M�KM�yM��[A��%'z��p�P�ƪ�p��/��Ty����_~�~�@^cZ�%���9va��J���ay��%b�!;A�a�5���3��*v�RO�>\�uxTFߡ��Ú�K�`d��_���=ݍHT�������-Bgr�:�|⪍S*�*".[ǰ��-�g�"�E<�K��a}��g���e��T����T+p-޲�qVu%:�.��
��8`y�C��No#=��(�giB �"�ϕL &qa����_���<�=�>�=>=:�!��մ����iFu$v�DuPZ~���WBAΔ�z��*j<���}j�I�bX��+��H�la#W�I1�!.�j�V<	��ci���8UC�آi�_��5k�E�cY}�O��Ў�
�T�1*f)�+ɸ6��\�L���ɅYi��t/��JO���*`��rX.0�z���N��8��P��Iw-��m�������Y�C�zpR�m��ps�j���a�A��F��zsH�,�f ̱��A(xd�����-"%�K�f��������2�`����0s|��cw�Y��{�b��!��ar��`�§���a���ET�ة���G���
��!��ZC�_�����A�;Jt������3:zY�K�c�)�r��&.,�V��"��8x�ɻ ������\�V������횸p1N��Ƙc����n�ŀs괰�R�h�/�n��b7�d��ąy��	�C/N<�V�����FO)��mҸ���Ș��������ځCc��j�93f�	P%ӒQ���o���Q��>[�����z�R؅�*so�U�m#J&.�K\8�=�w��rI5j�%s!hԮ�=���>n�to�~����+�m���۩[�{��Rk��t���ą{rN������3�c�/<G]hH��w�#�ƙ�o�V�	"����/���q2���;�U�9�K����{l��l��#҈���� ��^�7Gz��	�H�!%� 
 {��Q�tn����.�n��I�B!Ll5}-��9^I�/t���.����뺢iF�,v�T4��n��ƭ~u+�%�F�����5�1զ1�qa�QCÃ��ʏ��c�n�F]Ϩ(>pC!�iL����;��t��4�H�.ld
��N����m
��Ʃv�A>�cլ��ˉs.�?���xVG1@����YKZ�HM<ŀ��ә#:~X�۞%[8��K�g{��e��4�JO.lC��#�N"J���.kR��DC��,$���)K&,D\X��<2��,2|����>@��ứ.��4D�J�BvH�SZw�h��ą�WHk"VYu�����؀xx�Z�1���!��6:D��G���?��F� ��l��V��{�=]��������]ߓ�%�n�iFJ&v����҄����}9a? ���7�%�i#�iU��HF�#D�@�����~~���� '?ǥ����	b�ą�N4-�}�X�,P�i\�L������fx�Rf�_l���b��DK?�u���	jh�"j4s�T4�56I͘x 0qa:l��zO�X�a�ݵ&Fs�¦$\�F�)X��_S��-	    /�W_&銴Ǳ��ogE�i��0��B�'|[�ˀ�+���xg�~���_��y�x�$�nj�����'uc������4$��B^�I�-�5{l�_�hcѳT�Z��<�Aе%�'%.��#�j��/|��G�t��_^�Z�j����J��.����0J)�v&RJ��v~5A2_8��;�����Wu .�n���������?	���R��E���x�.9�EC|o�1`�w���F�x���~>�à޸w�����9��6E���.9���Tp��Y�o=�:�j���ƃ����$�*��x@qa�� [;��~~���/���z؍�ӂ8ҐZ�����P&��i�N͉t�J�"�še��֍�Mm&j��8U�ą�n�ꔒ�,N�jZ��JBƺ���,��4S�]ؒ�yǂ�N�ZO�>�t��jMy�la�׌F|A�X��_2�w��f���
Z��ٞ/���|����>!)S�s��j��/��M_�!.l�G�S+�
'��{��\��?=~���߾���%� �*?��B�^���O�
���_��X�1�H��.9*es�9hg��߮pR��>�S:i��u^�⍌}j�tc��i�>�]8t�@8���0���0����@x�R7����Xz�#��Ӏ�]��S|U��w�l�2�d�I�c>1o�����=W_���n��9a*.�!��ƍ4�5$�D���`A8ܴQ��΍��ѥ��+Fџ������=��8<V���-�V���WC��Ҧ�����l�4���.G:]|"'���%�ܟA {��_�q����t"��[��(}jK&����p�L�^n?��q��)�k�6N�8:�'f��W��u�-Xx^R���V�>�16[����hǉ�)��Z�J�>�u� D�����u��"��sbn|�̍�.4�ؙ�%��7�Zx.�d����5�Z*2'�n<s�rW�5�X����8^I>�г2묐Ub�9Va�M<����˅�3��+:_��� z�~�R4G��
�Ei1��h\�b@Nn�֛�0�m��dr��y1�x�_�,O`�P��{Ȅ�F�c��B�����W��W��o��l����zW}E"��|�0���g�j>��Ř�Θx�E��	q��E9�[�/|)�HQ���<�!H �Ct��ZZ��L3x�؅�C�q$�j��m "�Xm���+�ɋW�T&���>f�=�eA�c�0�a;B�b�)�?�pQ�^n���OVJ	�zZ�?p']���q�ģ\IMV��j��	���ܔ-0w���T����fs�:��B�p�5���]�6�M3��؅o�M�d�r�ú@�t�2��e�ɻ��!ɯ�Z��@����sb	m�=]a�Kt���T�g�Z߭��SEӵH]�2�C�(���V�v'b��V^����e��4K�=��{Xɩ�����	A����t��Xk��`��WI".�J�ܓ�O�B��2�Xt,�pH���Ƨ+��U��p8�8baw�bb���0��L�� ��)DW�p�.����4�I3�^��*M�8`F�	D�zX\�����K^����6�
�.�V!;�nZ?4.�N�L|�����1�ms*k�p32X+ę�"��:�M���l-~��4�2h<�#裓0O���6��%|�ɛ��aK&�}�����Rr">�{{��
���O?�UA֦�.��%&�K\�6
�x��g��&F�J(lUDicW����#Xm@��-x�H��G����J[]��*-�Vg��q1� `�k���Z��OL|/��0���'}����.a�;��m{���x9UB�$[�+`��Y����b�|�`�͌�d8����׷G8��}_����V��28߱�H�_�����9;JPJȅ���w&.�q�לh;���Ȥ���%�XT��nJn���%_��r꓊�v�ǖ2� $R���hQ��dbi��H��ͤ��خ���I�S�賢��3N����K\8��l&��]��|)�Y�Ui�}�xU^��d�V��0����X��?	���������9%=IH̄J�~�cq;5�p�1��H�͑]�)�aD��bAXc	�h�i����v��n�^��`ki����!D�n;�*�fT�b^5OE�a�/q�B>�'F*07��s':��tQ���^ą���>ҷ�K,S_�6p~�T[X�ח�3��1C�G��|��,S �$�g�3���O�I|P��3�$l��m�b�?'�,����v��=�!��ݚ
����>Rr-f��O�|������w+����~�?�G��H��Rp��p6GS�n��BL��%.,%�ON4?��=���M��1ql&�Ʊ%�������7P(ÔL<�����8&�"��W	���>��h6�J�㠄>A/��%�q$.�0"5�>�5v������0�YQ��H6�2X�q��s����$��t���u@ �����|x{���}U��-�O��U�u-�F'�����{��y��謌L�,L��+?>X����N�h�5$Ad$dn�j��K^�D�S�;1N�>o���U�y��W���A(2�S8�M�z
UH�5s��q-*7q��ąQ@Ҳ�|� ~IL�̆�H?j@Ո��
Ny�z�k��-m�x���	�#l��jGҒ��D�9j<6��vc�kez���6��ICL�Vd�3��<r횺uM̍�,��Y�g��/�Lw@����0�i�����
�kG�y7��,���٤��f����ͷc���{����0��eC	�6�����dIf��,���T�ډ�t������*��w3L�N��&���O����NL��O\ؠ��S����g�FA]���I(�cj8�e'J&��D\X~���mf�5b���O���W�cc��I�bd�U�e���W���z��E�������C���㷗��ܪ�lXw�U1,37�U���V���Q�#o��M�˱#&�՝ֶI���4��]��Mw
� ���S����j��s6�ӈ�s�p�N\��	oe�K0Q���S�H�ò�Q������|`c���������^����R�ƈi����NL�� .܋�F�^Ķ�왼ٵ4���G�X삓�57��E��5NF=�?l[�zb�@{�z���.��Zqak�:����OQF����H�^�Q��:۴�d�Qb�]��dc&U`�y@�[���W	��x	'\��1:�,|g+�`�WRѰx�8���N���".c�(�W�[%Q٦K�r$&�nI\�@�B:j(T⤬+)R>��i�'��Ԧ�,�����0����S��k���q�y����S�����pѯCV�\O���&��w2!�S���y}D��i�^�E��A\����=�_e<T6�g#]kg����M\���p�,�����r���:�U��1�̀�J(G:`��{�K� ���>A�q;Mсo�)�I{�sQwmKn��4�-�.̚�]F=����$F��YiV�oP�^�(�%�y�X-��B���U��Y)SxV>D�p�jӦ�b�+,ą{VR�	N2|�6�(�8
2��b�Y#%"���e9�S;'3�5W�ğ�ą=�Ӥp՟#`l�CK���86a���Esݒ�C�i&��]X�-ӎ{⢿AF�Xn�HSv�)?�6�qd�an�n�ą�ބn��oAZ�@O?����ǕL<�KC	?����s[w�yM<$�6k46F%6#�����$.\��1J�J���=�_���*��҉�FrR����[AL3;:v�w�4�o��2�n��������Y��b�%�if�6FO#���Q�����
�XfR��x�u(OݖL\����<0e4Yp>�_�c����#��4-�}�&�F\��5Z�};��p֓�B�%��p?5a�j뺮h�o7�U�˗��!���U}��=�׾H�$M�i��_�ˠ*��%��H\�v�L�2�j=�.ش�����/T�[���4�%��3v�׈�S�X�ũJ���I�	�Ą�J�k�6E�uO����IL��I\��j?�*<�����c�<�=�o��}�����W�[J$�ӡ�8Z�J��L�5��䫅TYv��x�n/�j�    ���H��%vd�:�F����QסTZ��U��|������Si�5v1Q���qK�YU���i�Xs&w@L|i��0��׶>~�����b㿀��_8�������۝�!���l_Qy!]�?;S��\��#_)b���N].=�^�vOk��y�����ƕL2/q�Qo�����	S6��Lֆ�^
��|;�+�f�*c�k���^�~�Uw�G�e�:�T�����w>UH�?�N_��G���FZ���z������Z���m�����4-�]�ȏM3��؅�� �s�����;X:<}X��?�7��\�G��-�bLܧ���j�q�����J�!?+�i��v.�qbˌ�H���o�m�t�u����� A�l�������Ib�MąE6IyZ�py���E�bG��P�����0ˌ�\���R���:�=�,�ʘ������X2�2-ą{�(�)e��,<����q��R����.�Vj�M�4�.L	)d��p$2�����oZ�H�x�v�P������i�j�X��8��Ğ��4��0N�!��-Yxg���8M7��}x|�8�2ͅi�� n�j���Y����� �缬!�>�ӚhY����]m�Q7m����ą��! �o���n�����n����_p�x����F���j8}�d�D�%o���aN�p�9�	�[���ZUnlF\X�	%�`������[�۵¶) ���[����X�5H�����$��Z��ԙ�x�&q�V#T�O�qMD�> �(�X�#���%"���(1Mb�y�ɘ�iL
++]+ZU2q�3q�W�'�Ӥ[�뗋-�"^�o����QG��sV��w�W�Z�q����6��r�z�ܑ[H�	�0L���5θ��I~�[��i����P�����˅���h�P!-v��-� d&����p�B� �ċ���JB�K����nQ�� ʧ#_n�^l�֍���=�?џC\�a����-c�LJ$��Hr��H��{�ԃ�@�.�*k/��%חu �n�Ta�?u�X"�3lqQ��ͤ�,��)�x�q�x�
�o��{�bC�d4�د�Y���Z䌉9)S�|�#��e���[�[@Lkg3��Ơ
v�T��7�c�w�Sxn���ߐ���1�"�X�"M�芦���х�	�^�g�q Q���L�x�A����˸���8o��`�4{���~�t\xB���v	p�oq��vM�D�)k�!'�'ڊ�i����M�N�e��a��I0ul�Ă7����q��EO���f&>E\�Jc������Pb�������+(28�!5���0�NO��sz�Ir��S����3^O�J8��kk��YOL3��؅��@��S<��l��u՟��Ǻ����c1&�243/Ђ�EZ� ��Y����"h"<M�$�-W�p�9 (H���k�W��w��-�6��Mvv���w�U���U�!��'!�t%����P�������[?�x�{\�Z���Ċ9L춆+���r����.&.���r��c�z�����C���~���=O��dF��,S��$�ȴ�"�oi[-�2e�X����`�!�'�����jux~yz|zW��|=T/�?��U��Q}�V\SΟ�lx'�n)�$5q�r��q��|�������Y��ꪒS�/�)�@֪k�m-��H�D������ ��V~ ��P&�@[j�+�UWc��M\�1qa��Λ$#�'�O��Bbρ�Rw��w'Q�d�I�c���ݐ����n�]���K�D����⫇����.F�妙�%v�CKs�հ/|��E�繎&� �JJ3��gJ�|}�N)���U�Z��ڇ*�����f\�*���h-5��3��Zc~�	�&M�je"����N�-�f���V�oč�g�E?��b�R�����p�T�蘒���f!3�0�����o ��˷�2�P1)�E6~��Xf�%CWJ]Z$��i��"�b�WLf�pS��P�W*k_߾$.l�R�Q�'H�}X��!�"V K�k�o.~�_LA�j
���y䙧l�#ԗ�P�r�e.d/ߝ�/�r�|��ﻗ�����C��_��=��x���������";�8�M3�i��K��Q�c�X.o���W! <�����0�Wk�e&Y2�@�bݸ�p�G���{J��
b�*R-�m���PR�$횶!���0�画D��?Izݓ������N�ΔL<���p�'���m� X*z7^!��m�{W2q��ą�z����w���DuZ۪���1ٴCP��S�ģ?��ʮm9n�>�����!n��DYe����J�^;�Rmk<Z�%�d�l��f`Hbvc"z&�9j����s���<1j뻡�K��U��@���!�o�ʮ|��Ns�aJ���4v��Q�g��o�+=�p���b�FFon��w�.l��0Ts����!]#��}��+����ո�����,q�{���ۮ�fhˊ6�[��!��c���ąi(#HV�$8�7���>�zzt��x	ҐMh�Ăwq�Θ8���%_.�F�������������w���������a�e�?��jKI�X�:�U]"����'q�׫!��]���J}&~�'[�G+ޚ��C��L?a�H��&Z2&� ��0O�	~�w�h5�M��p�O(�Ԧh/b���.l;܌�)���fժ�n+gB9����G�-j�YTO��̬%��Py�'�L5�؅�	vJ�\�*뗣�J���71�);Z|	��V9�'6M�zb�ҙ���4���
�*][ۦ(b�˩ą�=��;���Bs�~_rRz<́�<A*]B����++��i"��]8����<{�WS�-i+��[N-^�^oH@���S/q�0p���~��C��(�%��yi���P2M�{�.,Bh�ǖ��f����~No��o�Y݈�`��׷wP�<Y����u��7��j���L�	�GtT�RBi�F/J&��D\X��N����ڬ7�����j�V��r�/VhQz�i���i��l��oV��<�Sh�"Y'��꒮�v3`�e��<!mR���Vh�T�ğ�ą� �P��a�x�AQ��հY��)�<��?��GGN�ZՔL܁��0�?��T��������nĨ�;��l�+�&Ĩb^��̸���������I8�E�9�?�5 Ж�S���R/��w{Cj󆺣����QS��0I���Q��*C�R�����n���گ���7�t���$!�צ&��nB���(d����˿���J�:���>�q�9�i8��h�\e�H"i�p���p��p5����Y�b�:0���0j�J���L̜؅-a�:����������b�W���
��B�GR��¯/�`�'G ��a��W'-$jV��T�ʦ�%�I:v�I�V�3�]�ꗮ� h�"Ò9�0İ4i���&�d��%��x=�G<�	N��sӨ�1��jI�$3�#.��T7��?������*�����^6T)������a��1M���.�[55vg}����b��Z_���$f���.-�*X&H��KP��Q����f\u�3�ּ{��g��������X��aG��ڔeVj�f�d�8{b��!G�&��j���´�����f�:�RM|a���Z��i՜Uw����`���_L�LM��%�@"���flkے�+�%.�݈n}BuA�a��:S�$�� !��AEL�}�tFe��)��%���W�'�Qu��!�:�tRQ9��X��R�Ղ��O���g������ow?����ǧ�:,��r~&�fqCIk[JHNM%�؅�Dk����	��\�X�b"�۶h����%�����{������*��p�YܽN��[ ���1�%7q�����Ƙ���5��E�]�!k� ץ�-ǥ��\ઐV��rn��ząC����֗��z���f�p�/�R��,�P    ���I��b�(�D�L�(����jU��9b��������N��>ǎ?[�\+��R)K9㩉/�\��^���阮�,Q`�o�fӦ�lb�H\�%�� �/=;_c[x��o_wp��yߖL�q��Fq�'�q�K7Z��v]�n{'�_-玩�@�q��)�;�{�έ�t\��M�"qa� (�/�2�����h�r~5����(�"Ց��%�Q&^en�ą��Բ�P�Q2�T��/�[�����*��j�T����Z�L|����x�T�(Ԭ �p(�͇M��x�<�Jֺ-l\/g�̔��N3Zb��8�p� ���qo ���˄ cH�뤐$�Ej�ą
�Q���W�j�7���
I�K��H*����;��3�/	o�����!�ψ(u��Iת1��4A#&>C#.l�&[9*��.?�y�vNd�1��1r�c���e3��!���4�*�]xV�	�������ះ��$�����D	�߅�"Q�M��؅�
G�O����{��������ڥr�T3�R4.��x~
q�j{v��zU��z��|��+��g
P~_�q�Ζ��䦉�|��+IvaB�n��U�`0^���-o0I�����%&.[H\�J~0� W�
�3�-;J���
:rΡN�S3��m[2MbV�.����a�����LQ�E+�p/�8%Rm5�1��&^n�¿\��]1?�[��ׅ���*ZڢiB�%v���G�t����S�V�m��@9��1��m�떘8Dk�c
F�����:��x=�NSā:��(.�1�0�!]�:��)��[�����1Gkߢ��g�
�+�D�u�ԾS��%v���f��*��!k����󺓱<	c�Ы��ϓ���cK�QX���xRc���p�'@��t���K�hmL��t:u��������4+najW�橣�-������߫ww����H@31N5�ᵪ1��#�1M(2�.y��8s��?� >��~�锢k
Q<nc�2ۮ%�~f��b����$��b��η�U�c�q��G�𢒃[m]����P����c�$c��Ią��I���u��� H��-g�ҔL\���0F%�|�Đ��馑�X˵q�1q�p�>5T�@��o�󔽟��%�-z� T��?�*짖LD�_]^��\2�@�r%�<���qɬ�.Q�W�^o��V�e�;�<��]a�@>H� λ�\����uhU��c�\7yV�p
��e��o��1XB6g����o�;���?abh���l�F�#/����ϫb��Jb��FE�/lj����!��(\2E��x���ZS2��#�¢�����)�~����l���J�E��ą[%Γ%��֛'�ՅM�)΍C���i����;��(ը�z.�-67�F{�Qu;���sYo�~��?$(��8��@^
���d�gn� y�.<�K���o�C$ӍEu#1G1����c�DC>vန5�;��>����:.�gl�oHT���D��e:�Æ�*��_B�"Fo�7����kG�r�&<\ 
��]���Z�+�$;��%��^���뫘���T;�\�o6�Y��HQ2�N��B:u#&�`�%�!��@(��"jn�t�Nw�<��x�(���|{ݯ{�3-�PСr�;��I4m�āt��~���J�	�� ~��*��7B5�|@	��w'"QT[ǑBn�>�ą#�B.���v�o��Re�.���+��M�zg��+lX���!����"Y����L�� |�]:�����S�w��I|��t:B��$J�*��W&����=�ąy~��cima��'�ǻ�Pc+p#<���R/�J��[����DB>�˳�YL��a~m�gVw���Ư��z>pA3��&jň,i1�n�l��].�K��E�<�?<~T_��Be��.X^#���jr���V$.�ƇP�B��l��Ʃq��m�t�l��-J)�w6M���.\qO��Q��'O�,jBfLk��c��Y��]U2�07�¡�;���p���X�*n4��P��!�on�7qa7��\��r8�t�Ռ�*�4�"�~�)SK�]�V���w�H�+xVi�9��d�\��W��_���Dn����'4)!����"\��Ru�}�q��˯��?���'��� ��@ƃ�+���!q��$��/��r��y^�����q^�&J���/Y�,GܰY��Jt���A���2��R.6�O��{Xا,���j��)������pD��4$�	�11M��c>��1s�J�3�28��z�.��UvUF�ɣ![��>2���H�.��������ʧ{p�8��t2����K����2�	�>7M Zb�2��z=�N/�!_^��.�p7w��s�s�R�yu�[ -a�`čT�+ŁtxN��1?'7q_i�r-d0ᔻ�^��m�
�f]�=��*����"LL|���-p݄�w�/?��*�J�Ƙ�Yc��E�4&.,�X7��3�%ܽ���(�kD�f�i��hW�2&�L|����5"8��y�p�S�E�� �Mj7���ٶmڦd��ąQ�+������~��b��镮�����1~$�JK�U邝(��qa��I��ʄ��]}9^�כ��S���jq��n�u*{���q�����Z��?o�eب��K'w�\9H�� 1tNj�N�ą9��N�q��~��o��RV:NL"�.�Ur��)+뚶*����:����_Û^�+_�ne�{�"��ߡ�J6�$6�G$qa����a��|}z���u�8�_,j��s_�!.l�r��$ꇡ����\��!��.no*������I�1,�KSXo�cQܮh�Aą+s��ߌ//=|�->L��w��J��Z��W�F�+8/=���\��ԕn���R��M�ѝ�p�|�AF��I5}}x���r^��ڶ���]^b�#g��FΪ	 ���y1D�b[�b+��n�pu�D6�`a�XX�j���DWX��F�1��m�ĭ*q�%��L�[��&�0 �2��[4q��ą%��Fkݼ�z�����|@��U�tH�t+�x�Un�ژ��C�r�1�Q���<׮��K���	�h��#F�Q����uZ����S���\�h�S��C�8G��guLo���1�1��tG�%�����.�����!��q�G�,�����kl�钉�����s(i�y��z���A��Q��B�'�|���0��ϻ�ÿ���v�������^�E�����T3W�W������o�E)c fkK&&TM]8�B����˜��{���pu��%@�
A6��T,r2V$$2�X���}!��,\.H=����m�@�������Y��K�V���c�̂�{�ɻ�45�M�!ua�,��7at��|�=�~�%�d�F|�)���	�����K[E=m*��?_��1:D�����7u���W�����/�f�Ak��5U��A^w�d�^{�½w%T���(B�dǃO��IR�A 5���Y&d"����0(�8�O{��e:&4�G=#�d�C3�fZ�p���v]ɒ�E���$,����d���4�^�.|ze�dH�>�kQ=b�l�Hd\�fL�6v�_���IT�]2%�oO/!�By��乘{��紛&�z�R���CS%.�y�jri__w`�mh�Q`m�	ǡhgp�IՕL<l��0-=�v5_nֽo�hr��j�Xy�<h��AjbN�ԅ).BH�d��麷��׃��4���W��M����Ř��:q�j���~�tE_*��G�O!�$-,�X"����-��O�M��QL�4����&'b	����[iے�����/��b�W>�B�����vU2q���%ߌ�p������a�Y�V�W��68���ژ��_!qaW�k���,Q�!�yE��_nM�ă��S�G��H׆��w���?�����{�n�&0ƖL\��p�Қ�a�Z)������ʟy@���g�Ge�w�i��ad���>&.�.��s�\���	3.�   �YK�`�y�����ģ���f�t"����ӷ��U�O?� ��׈�;|]�mK�	�u��#�G]��z}x�����n<⃁�
��T���&.J\X���r���l֟P�v�� ��;H���g��G��ߢ��JV�Z��R�&Wh���m%I�s'ה�prM���H�M�^�ڿ�ϊ읬��&:����թ.4�=#,��I�)��)��nLF�'�	��؅g���w�t���ˢ��A�hK4{RÄ��ف�2��w�9r�QCG�ޝ��̬�t������q�zw��������m�Z���i杌���M��4I��Z&�o"^���.�e�~���pR�>)�TJ֧Nno�WK��ayZ�4\T�+��X����o#��\��/�w��w�\|��z���.�������}#��~�nj9�
hm�6M��<�ԅk�w�?� �4h(lK*��li�2jX�.Y&z~�Gδ���&"�"���6�2����vZ�T���x�2���CQ)�DֱTLv&�W 
N&S4qgb���h*�4�b�m���L?�>�>�D����Yȏ,Ï<�&��g�r���ęc�|L��>=3�! !>�,|�{pU8�u�X���_�O���|D�����Jz�.���]�Q۴%����i���t�"51�)m��F���N�u��|���X��:��������W�
/�)
�ˍ��*J&.%I\�w������c�p�1���Q��N��!�.�&�����=)S�p���L�_��l?�2ƻ�K!��4�%��I\�;��!��q8���v�r��~^��w��/�����x��X���
'��r�F�L|���]Ta�ߓ�|��w7�	b|*��I�vX�h���K&.�O\���%Yq�N����0o4��M�4��]x��8g����tZ�o�ӌ���qӔL|e���V%��N�5~���rt����du���,$R:��]8l��ڈΈ���S��B&	-km{��=�T�!�>��,-��M�^q&E*m��S�<Fh�Ll�J�8��U��%D�������
F�yT�8.C�Ǧ	�x��bQ���5#�狰�au�-�|�`Z�Q۶�q�Ϙ�`����4*0�����wz��Y�LEt�~W�����g��ј�d�u	��K -��a�o�\�l�O�6F�3������!�]��ߴą-��:.=�!1�j4�mg��>!b�WC\��hk6E���M�c�$HM�����NY ��h�u���S��<���f�Yx�������kѐ!�䧙���$.\��z��:_���[ɳ���g��ڈ^�0p�%ӄ�H�«�h���F�<�a��W�`G��r��'.,�_4��vݾ�����Jk4A�W48ͺd�֘�pk�܅�q�_˾�mߝt��*K�q���� XF�L\���p����V�����N�ŰE;L�0_���+jU2�_>qa�|��o�_�k���-�� ��>��U2�����֠���H'״4N$�R�-��Z,g{��FGZ�d�����8����Gk�mJ� �,+t[2qm�ąiS�7dU*)�������|���
Z�I�6T5�g�'�d��6���m�Ч���p�'Aa�rm��Kl��m��4�f�]&�,рR����jl Å���M<L���v���ʇ:�xը����ԍ�g&>;%.lv�����:�2�M�3�t'LS2��M���7S���4�S%�/��ñsW�ҟ϶t>+������#̺�ĝωs>�$].n$|���j~����Dw����$���Ԧd�*�]x��$�ٮ ��0�XAr�5�L<��?��h��Vq���x�qaZ��mH[8K	�����}��ub;
�0��N�L,q��8��A�}�Ĥ��t���V���Z�L5�؅)]��I�:��$�Fc��Io�,fD�0jv���sE��Ō�3j%iDv���G�[��oC���bZ�,'�9k[��M����TC@X��d@�P�I�,qc����%��#�	dI��#K��6n��=V�w�w�hL�����(��)Q2q-�ą�u�ِ�a1��_C�=�ѻ��4�%J�����Z[2�g;qa�v��毡9��f�q��-b��=&FN�������-�&01���i$���Ob`D<`�a���I#���ă0�C�����;���.u	�,�)���Y�BJY�p��`�X�b!(�����(��.���Ҁ���3���@����r�%��#2A��z����?���������_xo�71Ϡ��s�.��� �ѹ){���i��t��N{+� X�����Z��.`�갱��,�;���Fc��rk��������7�� �����ۦd��J�K�lܠnب��_�Q�<�rtS�����ˡ:
�y�^�A�&��I\�ǧ�&
5�Q����,����J����_��P�:!�S�<WӁp\ �ŔL\�/q�p�x��%ݡ�8�vv�m֛/Ǘ���;�=W/O���Q�y�٦��2�t
����ശEw�'.�_"�ƭ���o7�T��"Em�g���s���u�4�*�8�C�  T�A+���G��wd��\��H����%ꨟ~��������~�"��B#hU?��ޢA��(���"qa.�D.#Y���e& �r����))v+%�"��j)�&��K\X�.�����6R�%�I�4t���s�%���3ԉ�P�6�aD�8HHԪ$<�",�$m�<26M$���(Q#40�nn��nXΗ�Є��\:[�&�,J��m&�ĭ-q�M�Y��*L��e}��y��Y�-P      �      x�̽�V[˶-X��B��l�Z�~�f�0^�#�7p�eeb��H4���o���7�J�e1�"{��$@,�2����� �I�#�+��C�d��I��Q-)U�('�hm�~�x��:m.����l6>����\M��͸s8<�?���Gss��k�[�����eK	�_	�J��p��_�sք`ں�����������^s�g�nnF7��Q�IǮz�T��|-e�9��l�x�}�EOkgml�x^|-EODmLl���Q���a�d�m��sX�^J	�/�<�ڈ��:(ߎ�q�"�)���Y�N��V���������0���|]�o���us;��n����_��M;N� �:��g���f�R �y��kkz�['�R,�a0�:�Y�-N��mn���s���R�gXi�C[�;k(�/D�Sbz:h�P/#�z�0�R�:���A�i�=x�������A��h	9t?�@#��#���?�@+_+�s��ҵ��zi��|�կR6D��z�v9�̒:�����-b/z�j+��0�_��3B{�jؼ64�B��˿�,ax-m/8�oC��_hl�~B(C TXC��i�@��]φH?N��-=ڌ��� ��o`�A�Ax��(`���bcOh����� ��U��ʷ\�1$!46Z}�p��f�lu���E��at6�,�>��&���d��eX�CXj���3�L=/���ذ�UT�o����+׋�*��*�|Ee���8�	�=\,}���)p����E+$X6*ed��V�n�]�:�����'0�=�ǧ�is9)�����f���?ů���	O[!WwA��¥G�ok��
5�	�(��Z�7cU�Z%��=]dh���������q���7hN�c�R���9���f��Ln�:g��7�����eso	bb�S2�%����!�֏����e�z/˴��YZ��Z��t����hv�'�?�*j9Ŀ�B�2��Q�d�OcC!	6���Rgg#|���)��v4�,��G���x���P>~�5'Z�������jk.}��`ԔpBф��
B{1�"���z�����<y|mMA	�4B>8�^�0��*�\��7�M�˄nz���*R^n�׳/�*!�1.��|�(t_:V*�B4� �h �Dp\���W��0���
������\��A��k3ڨ(�ZA�K�Ȫ�s'M���^�����Z�}��=α��3ď>5V��e�Q�0��v�� �M~s�|�[�gC��8��Q�Dg��|�HTM��nU�[�T��,������1r��6��8�:�;���ݿ��ax:�jn^
[|-t/bh3���6V΄O#��i?4�#��ۼ����OƓ����&7�o#� ��&*C��OOp��K(c�R��)�`g��vwNL92� Qu^���5�|;�_x1��o��l\��`6�1����������^�����:� �
�q~bYe�qe�](n��fڜ6���`ђ���nb��-E��������i�*����Ŷa�{2 �#�y�?�ցJz�"�Ȭ�k)YP�j�"����P���дB®$�B-z�)�˾�T	=��'�u4�U������'W�i�%Mƺ`��`K�(q�CK崓��C�U�::���𦹝���#��j�͸����⡿�N�&E�|�_w�����܃f���%bJ[��b��e�$"
�:ڳ������c����ߣ������V�B��QҶ�h�bf���:R��VK�(��`g�@�JU�A�_�Ve�v�|}� $ָ��5��¾"D�U��T%��YWp��
�!��XkD#{RY�]N�*FD��و(�x?��l���v�*�_gs����y�:�\L�g0Vm��>=Xx\0��w��=�6"-~c�޴i[���wF�M��`}K�
3D�2�୛G��=!:�/����7~Q@ᕰ�-m~�E-�V$��-]r�x��	�1��v?v��̯yO�Z"�����dK���0�XPFlw҂ǌ�F�L�:I�A1�	�AE��T�W����v����2 u��pD�ն�2�m�x�9n���@�kZ�V�mR�8X�����Uok�u^J�W���=��^�z���ex/���7h=�q��������@k�1 d<���N�(X>�_�M�!L�S���/���?���鵴�m|�5PJ�2b�R��[��C�ή�{-�8�N�6֨�r^��k�p6��˸�e�^4;׆������y��o�c"Q{m���Z�R�v%h�N���׷�;.�P}��k3��]�s�_������tlY�I86I���q`Rc�TI)̪*e���U�]a,�2�G�h}ۋV)��B���bUx%�t�����+Jې1SB6m�3gEl=b&�s[й��E5��+���5f���cH�s�V��2L��'�)8l��"��Y
�T��e�N�Ml$�Z�/�cQ��)���0��e�2��E<b�O.�4���G0Z)U6��Jѫ1��dmoZ�U�,�x���>��X��ȡ}f��r�xS������![�E�2J����=��o�fS.��$�/���V8)�_A��P�T��3P؏m��[�\�f��w���ejZ^�Y�T1k�ͺ�\�.�ϡ�E�a��5�9�lqX��ʊ288:螄r[�O[6��Ji��BCaƖ�!|��k@��p��R�L0��� Z��� X�Z�bp�f�ycd����uR2�� �y� ��t�k�)��m��2,޻�7x��vt�r"�z���e��h\ҿ{��v-�	GVɞg�շ!���h��l�-�v�Z%��¨�����7K㸶�*#L^v�;薭��e�n��e~����	+Іץ��!��`Z�͡C�*to�o]������ܶ��mr+�^D~��n��s��9����4o6�2��5N�!6Te��ss��#�6�kC�v�K����=�+�\;����e�h���4�|%�^N.��MVh���j8�w{���.��։��Ax-X������=(y�,�}d�&V�W�,�A�6T���Jwƈ`/�G0�݉f��X�w©v-W���x;:�b����(����7�-�{��y�����o�6���l8�@�� ����t����\P !,�2mkZ���D��s���Jo߃V��؎���b���J7�f�d=���G׆3�l���Ge�Y3�ݮq���)�����Z��|�=�>V`���oG�r���D�X�����;�������d~D93y8I��jv;���Iϭ���{rsM*0�I#^v��D� J|b���-+�.'�k�*Н��5õ��=���D�r�DY�h)��.��Uϛ��~�w8D+	�.����O�\���e�t��e����·��P�+`"��L�h��WC&c�$�}�,��S��X����r*J��d�꘠<!2���^��k[�0x�	xט�'% ��0���Tڛ=kt�	տ�P��MNm)D��~H�M-Xa�[� �w�녩�� :��ly=_Q��|E-kx��е�#$kȘ� �����Lr:�����V碮�yZ��k���^����^ZB���-_
"��r���9�u<����$�dx���i5O��G��
OZ�V@�L ,��n�|0�u������X
�=Q�m�b�Q�r�X��D�S��6�nI���]�U
���e�}��) .��E�Gh��!a[�ݙ�mŖ.v֬ac�`��!U�[�� �M�X�#���C���=T,��ykMH��F�ީr���.�����tt\7HM�����2�B	�����7�����7�!2��W2������x��;"�BJ�
�&r�-��U��Κ/9ϝ��(K�H�~T���h��#��A��J�E�*��7�l0	R�B	��_r
��Չ�\�fc)6 �V0�F�>B�J���oy���ɸ���w����bk��/��:���w	�	��	E�Cgƒ8wF�=Ma��2:�-a��ҧ)$$�^����?#0J@�Ca�� jZ�0XGUU|
��r    �i0T��I���V(jF^��+za�r��f��w$&o�lvQ�����X��hF�j(C��M�)=�-�pNM B�83{bO:�͗��h��&_f7�3(���[s�{0�����,W�_L���p�򟫳*O�p'�ƘO��}�t�Xg���z3�
�(~�Ʋ�%F"OalŚ�7�]��5��w�JU�rYƢLcSu	���(��[�n�hŢ&a�LIɊ��(;{�+8\-�X��š�������D�T.���F��,A?f\Oig5��V45��'	��>���n���^�O�����ɔ˔�d<�7/y�-�P�����JJ��]Z�EI�������Џm&%�d�F�J�>OUN���[�T�@ǿ��X��6�D���ѱ�X4�B�]z[L0���a����&͙�=�F�^2l.6t��l׊5�Bw��x�d�4��
�{ܵ�=��/��#rm}+.�������lw���|Xeɨ��bu䚁���T�Z�I�\����1��Z���_�|��׭��P�{�Kc˚i� U>��� #�-Y�	�XEQs��t~Bph�O�K�u�{�fY�,�)0^W�h٨�7��R)�B�7/�j.�^BF\�����&0��Η?��K6�o��k������S�i1O��(撬�^��@��
��Q:,'���K��5���o*J6�=��r�Ki"����&H,�(���3U5
VN?z�d\g�y��4��$�,�%����\J�����M�Q��5�J��rr)k�IU9�&a^kp��p?{x���;ʝ��l���K��1һn.F7��x�nʧ$�NV�lZ\�ܼn�ؐ�ו���C9��t����d|��촙{J����wT�Ye��:���'�὾I%��x�\y=�����N���Y�vH�cL��%�AUW-h�������4F���C1�I����#B�yդS�Cx�J1>eX"��|���{gY�����"�@�GQ:���ä�y{;��6W�=U&��?\)ח�n�O�o��Æ/�|)��x�Y���ݯ�.Fr=�����pcx�=�證���V��������jw�Y�����i2����WF%T�>K��u������һ=�1��߇�C�����;8�t���d���=)m�n2'M�1�6�lȔғ�/$,KS�us�`���{�j�yWzwL��+Z�%A����g�/V7�>~��u�m��V�JG�2�K��8-��3L�� �� �D}T��ϐ�a�=�C���������^�,�&�F�u2�����f�J�^q���\��2"��[�3R�X��H��*U�Ui���HY8�>���cuO*a��pr�3�1M˶����&�P#.-���U�	+6^\8�G;f�;(�Y�Z��"��6�hU��	Q�Z/�y�[�MW��L�����F�٪_
I�t^����t�� ~���,e� �z���yǏ]�������j(z�9� ���t%��f���������Hz��R�E$[,�vks8�0U����k�aw�cMo�ӵ@]�5,t��iq`�"�l��5|q; ��v�`���N���_Gs��u(����\P>pIpT<V�:�Pq�k��6��Z��Έ`ͰҶt�s�C���V�Y��789������6��r���f]mi�&x�\fLx����v3P�Vt.��e�li�V���D�Q=�����z�����zt<<�{�װdV�N���լp��&06B�O��^^Y:�=���d-}압z����|8���ف�%8f�X�Z��=S�*2�
C�*QR��s ���,�^A��Gʬ2���UFd�U�:�ˉ�ԕ��VC��=��~C˙�B��)`g�d�k핷֋�g���{'���a�c��w'x������0[&E[5�xK=��DQʴf��mwgg�Cx��r;�^�,��␑ԛ��4C؈p�*��ՂJlo��Sꉕ���M��(z�7�h��w�q(��a��6z�g�R�$�nK���m�c��5���y��!�g�z�\�Lj�X&��Mp��ܙ�5
�b��6nX�)�ڲ0!'�	V���mk���
.i�=:,��Wvck�X���V�带dւ���`U,=9+��R*f]���ֹ�G�J�u��^���$�X5o���N��1��lZJ��6Q3���tON����,�-��N^M�R(&V>#wߩDH�X��J[S�h�C�JbG8O�A���B���%�K
��}�����ҙ�pd-S" �Z*?ģ/H�p�\��V���Z��'�{ :S�*��uuu�z����x{�KRC�M�\���* ��o?3�� k5W0��չ��޼+W�FP|[����z)�N�i3�$3����t��T����E��uy�۽���$����:<�|8��ʙ`]�2䯐,ݵ�&XK&��D���ɝC�L�I��.�׸��VTS�~kx�R�O�65�����t���Z�.��>��e���p#d���ѢԊ�����j���0r4V�	-Sa���� I��A*��C�騸�³,���h/����{^�5�Q�k�3���IG��o�5��J�p|~>���?��F9<�2�*�z�2թ��,/.���H�RL����8J�n�V���2�� XZ��r\2~AB�(2�n�ȯ(�����T�=��"� �mR^HWsvڨR����)0�3�� %|�6��LPRXJ	fpxu�Q�(,��7��l��"!)��a�r�6FW�m\D&��,4Nm�Wl$� �Y��
���ZB�f7��b�]7��ᒼ�퓂^�\�I�G[�	�)�����Om�	�.�1�Ɲ�}��eC��)%�]*Y�\��S�d�,����hW/�җ��=r��]\%S�g����Zv��/��Q�2kM�$�����?'$<��oj�gL2�����X�\Z�Y��( ��y�J��*�5-�:��b�iG�����&ِ�Ig�V��������ò��u|���<QS���)c$����U�He�@�I׺�������,|.��(����ך/p��S8[l{�%ER�)Q�V,.��6���2��ħu��?��v�c�~�ۗL����L1V�����Д��CZHU��@��?��u��w�TM�k�n3�K��2<�%���a�0=��]� ������˃|���J�	�꦳�Lo��|��A����C��@�-`�LG�`�/s���A���Kq��/��=��))�9 Z�*b�J��>Q�T��iե�|g��x����gDo�3��������I�&KN�cѱ/5Z��(�u I�Q��n/��� �45 h�ah�6���W+Yʔ��"$<�׋�C7Vr�%�}���<�M�I�V�2��%p���bT���5l���Z˹����k�C��d�ƸGn~��4�	v.�0�uC��k6��\h�L��ꤔ���-%�U�{��𶹼\�7~G
���`@_�r��`pN�N;��G�X���Վ��ywә�t�dϑ�XS������isq�Ӓ�!�:���E���������?,�@]Y��j����$<V��iml�j�B;�Y}z��zd�����5��C,���RO�tF�����<���IOp��4��U�Ji�g�eŎ���z޾p���-+x�M�NS�T�R<��R�縻v�_ͧ�9�W�F��\V솒��du��뢲 ��� �_�/��)Q�fT�LC��1@��6�t[��������\On��w#��N3�j��>c���b��tڊ���(q��[��c����3��1�S����<��̊�ڡW7T�80a���l�����g�kt��s���;�a�����2ӷ$�6V��ٜ�3U=��'Za2��22�j��j?6���&p.���� ��Dk���<]� ��%ñ���ۊ�7J���3��dpvY+\[�5�Q(��6��)!?���1r�6�}�����0y�b�tk�<�T����m������*޿޲{��B7��W��Zz�,)�;��OƳ+��\]}�|l8J/Gw���l<M���:    �������x�,�+;��kW�.��'(���X�0�F�Yɋ�,���Ϛ2��٣�����4�*?��०��9"h�C��lS�Ti���I���A`=�q��u�5d$��j���Y3�"����Y�,��4j�JI����Y�����}d�%	�>��t��~?�񝱦� ���k�]Z�C̽~ªĚp�sr�ջj9t4�X������4��G�d��)�O[]FAR8�䌦��k���.@�/76acR�Tl>T�	� ,CsT����呥�'ES)�a'u����5K�!v�l��ֈ�9�i������~Jٌ7e�lb� ^NѬV�3}U��]\��������R����`aªtm/{B1a��%bp���0��x�N<�6Ek�:��G��uo���n���n<����Q�_�v��Ҩ(%�$��08�u;�w+M��ڏ<�ų��>�*m��CA�%,B,����8z|چ���U���:�UE�3oQ�I��B�t���Dz��F6�)�"WɄ�����j���i;��I{�ƽ�d�#&t�:"Oi���,A-{a��Nk�����K�z�kg=�/���e�A�夵>SUįZ�4�z�kg��.L'�M1�q2ջ(�!����<B�b��F��T��s�;�����hZUG
*�o����FR�N�࣓�`I��Ý(�l��5K}5^��ӽ(�ڶJӓ}y9)eD��P�t�7r�laa���S	���r���)L�ֲrfA�c��V��$7����u�?3��t���?>���
��нh�-	�T��`Yt�Lw�J�c�0k#�PiH\dI:�&-!��>nIP�!�B���3;N�m쪃2cy�\/;Nx���43�Y�G����?M��f~xo1���g��!�xt�o��8i95n��甂k�/R�d�R�v�U"��T�R����^��awy9뿨P�-��Q\����@�Y�����x���� �%U�˄�a[G����a���?�e�g�#8�֝O��������V��;�=Ʉ�m��
���pA6�̲4㽅[!�=��]���x�6�����7n&�7�6|�S��ND�.Dz����꽭s�TVp)3�~mF�6\C�_���lf��[5t���c�ԕ��ͷ]��+�_��X�J�SZ��ǵ_fє�L�L�#��mS���M�P!��I�[wF¦6�'�Q�LY��@c�b�����ꕭ@�a��n������'2�	�gqؐp��*��I`�4��u�j�3#�Y"	�D���j�b~�9�8%񥗭��w�~�.�Wz	~&��sMw�#��*8X�ڰ{[���i����|��L���*H�u���L*~��T��9�[˯j߶�4��6����?�������Y�"k���l@\A7�Cn�C\�Y�@F^�+x��)B\�v%��I ]�'R��H�h�o��4����c�\>���N���ze�6���/Z;±Ԧ4؊ ���;��e�������g-��8��`�
��4�u-���b"���W���X ��{%�����G�\y��a�9�D)@�R��Y��}����P�+��˼@v:�z��ӌG�f�u���#�u��*��-5p!�dT�nUތ�F�^>g[bg0���8u޿��m���qb�*)���:���Y�>xFsq1+�O��J����'��f��`K�X:����X��G���tTR�l{(xS�ļz���I�z׽;��6i�7�͍�oj	��x���Lej��u��pG�[�a�ݓ�2^�� '
����`�<t~mHfm�15@��y#����d2I�f]�27L3��V@�{��2Bq�S���J ����������w?6�ށ5Se�:���q:w���l��0�Z���
0.� �C��B@��R��{U�ǻ݁��z5��LQ�.��D�x��cS��v��a��2��6{��M6�\2&:"��	�ό��^:� ��"�s��% c�`�TiJ�>{F�y�e,�޻����&[�@۩�R�2(Z�d�2�k����x�1�m�,R0���c��ʌU	-x2�]g �o���k��t ��Y3~���.�,����0<1��#F�U'��<.;���SV�J)N�,�Ҟ�t�?��pb�MNe��������A�2s#��,[��}�X�����X.f�J��!V�n�>�gU�ߒ��/��2�'6B�=B�!6x�N�l��ck+6��Z�-�kv�}o_K���1��IK�O���Ե���]e���yi���ˈ^��
��!~����쑦�ҋ��@�L���ک�Ix/�4�oi���}n���8����Iם씎�	�Î'��料�Oë�}~�z�E�w�p~���<������h�9y`!El�lΒ�Q�Y��8e�a���oW���tr;���y?�k;�I��W@2���/��o�ʲԫ��C�V��< ͫj'��|�r���J��Yü��h1B�J� YZ����ƚ��MLʺ������rLr�G�cU�����r9)��F�'j�tj95iT������V���u�#��f�[�Uk�Js����d���A"���~x�y��bƭd�T��fy���bs�ۊ,p�G�4�J�kڔ�'��_{`��`��xn�z[4��U��>��� ��԰�_�J�tp�s
�[�;�nsy�|)�ܴ�;���N�V�̳q��a����W�Va����e2��\���.���w��]?*ͪ��ĥJ7�߲���})�	�T#�WsA�[�&��+��[�:��D�'e��Ú�isNtK��G���'w��V6F�{�mj65�􂒅�R��vi�Y89��?^����s8ʗ�ͦ\^v6jVOq@���E��\qΡ5M��(��%�1n*��Da`M��	�r{Qa�d�iHd���T�8�1Q��B�|!�j)_�ɢ�Ȇ�R�pؙS����K$�?�y�O�U��[ڜ��M�>U�֜�J�a���q���f�\5�����ĺ�dG�:�Zj�.��w��&��[_�ʯ���m�A�y�0�B�P�߇�����,�f�C�ZX��7���_U�-�1���fۯ���-�E��ɢ �b�c��YA&R�-BH�r+å�����t�Tm�Ǡ��ǐ�Y��"�lP�G��ת�kU��	�=p��-�������R3��;��%�e6je0�Ґ#Ӌ:"��#��k������U=�Y��g2_��>��	�[fK/����2��϶j;G�ߊkr���O�I���LK�}�9�2��,�}�;LPM`�0x��q������2%��~w��Q�uĬ"�}4VG���9�"Y!�[k�S����	��"2���o��e�)-R������G]7ct���.�m�'v�+D�4�Jo8T'��8eB�N��]kyd��3��BM�H��ؔ����a=�\�p�&`��./=\����Ĥ��� @��ڵ+�gi�U��q�����c��rd���U��t>�CL� /������=�٣K(/�L.�B����u��KP�kfi���ܑ����V�x���@��^�V�d�8�#p��VKK0GțXI"8��u_����^�=z�8W{�$e�;�{T��4Z���p�?����6�9�J��#�~�����L����Ӯ��xOv��e�k�s�0ulq^@d~���d�!`ߥ�K��/�cȦ���fFhӤ��f�L%�Gd��o�O�&��Fx
�`T4?��0@#����K���X�\»k��#�A�ZL�(@`��P�K]����j��$��m����=��Nok*�]�U ^��<��&Q-;��h�Sə�)��V�J�d�c��h�=y��>���}��-�u3m�/#\}ՠW� ���8��y��)���|!M&>���\'/������8�1P��Y�!M9�ZWy{xuݫ��K��O�K X�S>�:>��M}C�uPcKQK<E����"�j��E4�ഹ�֢�˄`&CJM��ֳ�vg���������lV/��N�+iͱ���9�{��gs5�}y��S���w4�e��N˖.���GU���@�p��Q�x��    ��Rg�����f���ś82>��s.�H�TK���3�k�1�U)n.G���ٗ\ l:�g�5�U�"��N.��V�<�?��Z,���io�j�R,o���--�o���&I�i����dh���g�g�ݮ�������sԕ�Z��²)-Yl����ۖ.=���m���0;η�����9)���3Z���vx��(�>��*�V�KǪL�u�9�4�Z��'�c��:(q-��,w��b��CI%�az�ڷt�L��MM@=FC�;��nT����^������jNN��{�\����6�CK�Z}D�1��qv��c���:��.j(�Ҏ��K�t�h�Hm({�s=��R��s�=�0hj.�ֿ1��E^t���]��������WK�ڐ�[D�}����@�>T�$�l�a�l|$�N}޼�e_Z�wzz�4J&ޘ_��6�=��鯭�L��e��A$to�%Cp�8�M8'��v�N6�zmج�g!"�AۖNP��*\�bm�~Ù��ii壛6+Ĥ��ro��E�Tmi
�X̘��!�!�����`�0j�/F!���R֜��k��ӿ�Z��	�U/��a`��i!�zkש�$|M��2��f;2�_�/���W�b���iM����rr1Y��c�}��1Pȥ�'�Ǫ�Ro_:)�{�k�M�$�`T�3Pò��
֫\1��S!�>��T	r�tnP09馇Ec��6�����Q��H�4���G\t���R�Vы�PŪ�b�+^n�!�_`�>-z@���B!+���۠L�ڞݞ�vaܬ��OA�E%�����Ď���ZUMf%U�h���q� ��Z��2$Tv�W�Q����-�����R�J�-�A�:�}^��Z�͟�?]KcI�wS:�W�Y��b�p4��A����)I�G
�~��S��xz��G�/	Y-�x�U�0�����Y� ap���u�M6?�<d������T�#�O+v��nJ��Z:2-�k�N��t�Ad�9����kT'��t���8}knGk��z�}`^�M��L���ْJc���O=M��o�ۭ��j�nt����tw�ה1j,��)�4�Y�s�ueFg��Z�����cHM~�&Txm��]i��9V>*�Փ��915m�m��I���g��ʋC�]�4��A�F}�L'����5U������kF�)3�X��k�6��/׾�L�&o����[�kcN��0K6������,e�x��ڸz2J�&ʑĺ�Y�t\J��e3�x��3��].�̩ԏ�����4����nz��h6#�����FN����\�s,j��t�O��,R�p:��/�May��/<Y���M�$͗�ł,o�/�fu�{�p�aB\��h�ϡ!��,6��a����A��t�)���v�wO�Aj�<m.N�0���tt�̘�it1�;����je�̝��C�{���q�4a	�]�ty#����s%������V��E�5����Rdr��gBπ�S�M��Bz�����Ǻ����謳��|]�$�&��2��gM�.���J����>f�R3/< ��獸�*fa�o���͡��;�u ��`] GUY6VB�&�-�D�h����Q������7X�}QD�`���<�ܺ�:�6GݣyR�=�0���E��i:]C:֒K �����0�	F̫2%rz�Q�࠻{RȎ��.�|��Ku=y˞!��yw��GL;_��ܕE���r�$�W<���8��je�dz�R����-`jI&��F	x~{y���o��wF�&Υ� `j=f�]k�y�?<��BԻ�|����"�6pqY���]��[́�w�ґ%���m�N�d�����ֶ�|A|\���HF�ݾ^2La�Gb��i�7�*.ላ-�a��d:�(}F�ŗ����&��W /|����ԥ�W蘒V)k���,��g>��8��n0Lz����6]9����ҥ8�	�����K�w;�2"��c[dR�p�CX_����m檶�#��'x�Ao�Tj��I�����P���i�	�倬J.}8���%O���C���9�|����I���D� �O�$?�\K[[�:*`�|�n��zs����F����=[���1��(�.�� 	m�Hxn%H��t\?N+��b��ZPX��Wl�Z�2�bɕ0�P� 1p�PFؐ:�t��:T;f�B��;?�!���bfs�ɰD�%"�2��.c���a�0�B�4��Nfg5�XM?10\�V#S�::���0�D)�Aep���&�q�U��r���w��6|��9���<F��(Æ9�G�l����=���#�XºA�����&�M)]�6�[3�"�"hվu�{t��1{k|i
�<g�~�Scu�S&Lv�r1�ѽsd��v�t���J����!KIaM��̢u{�E�'���ݜ�_E��eqie4ك`�Z�t.cS�U�(�!y����m��Dѧ2�	��)��X ��C��5����JR���4OW�I��������-��I�*�p_*u*��
*5�X�nf�5Nzr$�#H�
|�#����lN���ꉶ�D�>��4���F��*S��6�s����.|L�B����I�)�R2-'V'�u�?Nr=�3.*Wm���H�Zq\flÍn�2Y�Ss@n:ذ�A~�8vw�%�7�-��N� .k��fD{=�>wkӇ7�Ϟϕ��œ�}c�Y6$2Uid6��c��OЭϰ1�4>�5d�NX�2��J2������Cw�hgii�N��)��²��A�պMH�󥉉�ӷxi��yz���q-W(�g����`	l�?������pa��`-�|w��+���u�Y.D��C76��)��ԚC筷e�<�,��^@W{Nw���u��3,�0���&xȵ��yܒ:�o����Y��"��������L�i.�f3������ї�a��G�bo�� ,պ�`#�^������eNc�_�w���?�����mg-�V�t$3����|N�+����l8�R���N����s;�ì�qp�&=�wGe�F7��S��|����b%��%��pD/��Z.<��ѐ�}h	��C}EU�r�����W���^.��(�>�p�2���й�^g��Mw;݄�Ud�GNTXy�ԡ�y�ֹdXq�t�]�`�`Q�������r���29����=�d��"7lC^<c'����f�de��
���G<5��-��o��ez�Yʜf�ƈ0>�R�6�NU���*C��ػ2��of�����dD|���!x�8SK�R�c�����-���;���6���w�놃>�g����t��On
���	��t�t(�qp�.����d+�?�
�sr:��n�}��uz�Ě&kb���a�%���A3O��¸bP��'[sf�\"��)�x��G���
P�\Y��2�Y8m�L&�Sds���k��_�P���o�/�c@�!�����&u8���Ò�:�O�d #�a�$�@����3���[�m廻u~�1oFu
ښE�&|"�;�1T���LeiU8{������}�,r/8��ɦ�:�.D�~Gl�`�B�������"�?���w��n�
�N�r�I�a{�|z�R=o�f�/��/6�k{��\ɑ,/������i� [UG;c�l�3�B�������!��X��8G� +L�r;��kp��z�6��0NP0a���g��.N�!�������m�|7�&���-F]B�^�|�Dv�~�/�,DcU>S�m���e�T�����krԭ�q�e��7^�O�ӫc��c�	����"E��N7�=`]��'���Dҽ0�P0��a+�J��p���D��>�_����r@)D������w�2^WX���!��}��k�7�����[:V�E�y�inŨ")7�?���4�����v�k�b,�@@
?��#���P"Z4�Z���K�{�g�GX��=vY��R����+hʄfH������B)z~1������o�u�L��څ�kZF,Q5�RHa�OC�����
�:�t:�3�{�~n�S���    ns>��B��S�@��w']�41�%�jQ�f�N����5�gxG�4��NgtB6�����%��-#*E��.WG�H��{;��<(�
.�%�����d6]�0���wk�WWD�'h�@+�t��n�-��j};��(]ɵ����t*Ĉ�	b�-��RC�|n�b�{iO������i.��sx9�T�)���\�⌇�R��x��䙊%��r:·/���M����b�/I8?����oby��O�A�u-S��YL�����-b���bޔ�K�77d�~��P)��𙙅fOC�L
x�1�s�s���Aԡ�<9�3��Mʱ��Ns&�A�iJ�=k�U�H�S�.-1�"-FXaŒG#SE����ed��A�ⲱ�®.����,�<�G����xD��ZC؍3�[���;'Gz;��6�SF������)��|f���TOg5�����dft󬁠����EJޣ'<�Y/0����q�.��漹�znkf-�Lj �'��0���{�eM�9ҵ�=�=�S���Ǿ͚3o�w>�i@*�I+K�2#�	���Cm�ʥ_<C����Ԡ�?�I���Vh1!�9f�`HɀRE�p�m���F��H������:�[|;���'da��������P¥�"�T)G�����xr���mȧx<�����6�>�+>M'�f�w/-�Uh��,��-@J�cj�;cfY�?Ń�6�˥ν��ȿ�Ȑ��Oc��lT���6����w��&���>wg��ZF�5��ľ��R�~^vh�e�L���g�Z���t)+};��t��\�{ެ7�r|�}q��҇]�i=��U�$b�X��T�v#8�������Ju��&\�6y;��#*$ z�H=��I�0��L�-\�)��];em���jL71�{�~��w�[�E�݈��V�I�#����0A�+_����U�R�P��ɫ���sRK}��NJ�A���5ɳ~-D���A�׉�Q����x�k�F���\6�x�ð:Ψ9o+��3�3���0��F��;��܌n���J/_]%ʠ��6�*��L����n���,�w�
x�)��t���vĸj0�^5�҅Q{��75#���|�t��s^I���ٱr�X`~GU�z�lC�q��.�a�l��9����p0��%�V��"����	�q��C6c%8$Qι$�VB�'�)���ǚ���5�h��i�cJ��M��
*�P�n�;�x��ON��؅C�)��Z��iJ�Ncz�����8���L|9/
q�
�ԕ?�{��Ý����ti\҆%4��b�aa�,]0�Z$����My�dfo�&7����6�S�WwFي�+�_��y6R'����%N���!<��.��^�lM-)(tQRe򼉂�'K8՝A�	����(dx��TVrFZ�6��8��� Y�"��`{��k��)o�e2��PnXz+�-LU�s�>�w�Z?bR!�fA�ĆgAD�2����u�+%�&2�.�8������Lg9kr0�9��rP6U^J2�fAN�0\�0fJ�*ĠJ�*j��Y���.��&�k�)`�����dc6 �tb��!�[I����a5�%<,�|�s$�ty�|J�=c��z4��")�=����2����9���]N�aR��u��w}R�V�M������1C�
��#	wW.�U���	��z�Y+�tA;�xX�2�VG��7��u�\���YW:�����b��ϳ��O���:�E�o�;�S��/���I#��Zi���i�B!b��&����Tq��!p��df����t��%���|�E���*DE�����A�H-���?]4tb����)�v:�I_,�">�7��u}K}W��ڳ� ��yj26�X��S,}�/�`CH�B�����m���1l:����X��C��33���0�;���Y��������:_UCQc�/.�|ė.Gө>��� q,}�Я��*���Ԣ�����0������:�M�����2�z�B��g�QZRN�[��KL,����L����O�m���ZӦ�Z�R� [Uz���Vdy��Ƀ������t�����1�6te��gl��i-tn~�L�����9�����4��䜽��J_W����,iGt��
�r��aV2�D�O�HH���&�(�f��.a�p��n+G�GD�`l���ݮ9�T̉�������|oV�o�W�<�v�ˬ���3���>QV0	�~	�[L�E�[��-JS�C��Z��r����>j�zԔy�i�`VyGE��s�К_�Qg�`��5�
��x�a�tq]�d��j�bx�*$64(zo��|��=C��A��Нe�5���*N�%�P'j�+Ye)Ě�g��G��T�ȱ�����1��&B;�c���p�x?�̖�RK�Ǉ���	�˥;��-�h���r������wR_֮8��>\�ρT���,C��i���ln\΁]�n�4{;�
�G(����B��is�b���/�?�È�dD��0Bq�9܆쨙��
�2�B��)Yi�ʣ����j2�N�_�^��b�UYr5'cIm\�Z��pH�`]�g��+�:����LH�ױ~6M���yDjms3��������������譀�,-�AB��
�|�Y��5_.�Sc�k���tї9��\\>`dXm_��̗,�ba�s�xD��ҽ7���5c�"������o�Rtf=[a9�ڊ��u_�ǹR��3诒J�#ʄ��섧�E0	��=g��rYa��?�<�v#�cb������łի������>��X�'��3Pf�{A0Tj����ʨL�C[�jSJ��:GD����*�� �'�w2�L��!$ �`ܲ92�L����~�y��9��W3�c�o^YID��zߛ�N�����D�Z�U/�d���K.`��6��Z9�6l;�=qu>����N.'f����ۤK�pὯ?�����"��c4�!&+a���\�f��B�L+�rX��Ymh}S�y�q���Քs��y�+����.���<{�B<f��:[k?9<�Tm\��M��{WÚ3"��^���V��8o֖�k��Fd»E���u���)����Rk3�S&j�c���/��EN�L��y���%�	s{�J����V[����&E����� ��v�&u�8���U[�r��{��w3����@�T|��J��� a�$�G(�"�b�*Ș�����Vv��yڌ��C]���hH����B�����=��j5X�}6�Mj���Fxas���MS$2^_*��wR�^ަ��A���[kCɅ�)���r��ϬdXd�}sz6�D��eY�������ڳ<��i��p�5�FP(ٶ
6&T�u�,w\�v�d�w{��T������Bi��pL2'l�I�'(�����J�GbRG�Gqʋ��1�=�
�\N����V��]����S8t�5�ϨH a�&KmN�jN��#��廙������
gM�0��F����цR��i:b�~K������~V���y)�`�|�MG������)���·��S9`�M剃`bɦa)u����)�'ד�I�~J�[��x�\�����]��
ź5�`a,b5l�f��Րa�UF��������J�lY���ʡ�8�rA�r�a1��m�Xe�b� X����N�k�k﵍������p����-�1�r�abM�i�R��$��2��tt�u8>�o�m�nr��[�/�X_t	�Z{>���I�4,&��N0cf	㠄62�c ��g[a�I��ۇǇ]?�Q2�	�ّ<7��d���i��I��l�o��9^�=t�H�*�*$|0Du�<����!6��񙷂ԭ���`��܋ ;�H+��a8	��J�v F����]i�weu4�搇=wc_�n��Qjs���9��=)�+����*�z���qp/�3&�ڼ�1�� B�K���6�ه!#����`)���{�6����f��ǒ�c1��Q�]u��=�    &�W��S���BG��f�.�±-l1�liLa*G<;B�z�����lx�`���%����ڇT)j8��;^ŷ�(<Ѭ���J!�X̓\.zK�Ж�xD�R��-|��XcU������(]S��+���������A���Z�)��܃��i-��+�\I�I��>�ᰅ� �\Ty�p�R{I�=|׈�َ
�Z<8s����J~��!����&a�-}�p{\�|7��
v��������Yyyu�͠N��v�g K��(=B"DQ��S�M�lwgW�漫��ф�O���	7s
�v9��	rsS�8~9��ψ=�� �[V"��h��2P-[�ݍ'��X{��5cZVT嬵�_D�����e&c*�=�q�݃6�b��a1��Poƶ�Ş�%�w`�%�V9�k�2�ް�4��*���<�{bB����M'w����v������g�_����M<Izy��AKS>���d�b�^�4N/Gؑ���s��f�z��t�oHr�lA�2�y�$�2�j�UGN�q�Wt��$�0_.s (^��LI�g��qD�*+˽R�Lj��*Z��;{�xt�̣Ќ�6Ӝ�I_'�������c8K�J���]a�ց49�m-T�Ե'���0_d�i����>�^'�_F��4��n F�i�]�d�-�)?	ݸ��,�`�Iz�H������DS��`���E�+�Ӝ>e�pV-��,Tbqo��K��}7��=ox�6�9t*2�%S�#Ŭ3u��HZ7�Z��J�b|:�Զ�����;X�Ԫ(�N��`�� l�Ļ�m���x��B���ȷ��Q�xڿ��	]��T�W��z�� �yr��$^�R�!y�̖��<c��#�,�RO�&QL��U[G�C�jUX/���������c3�%�Zk	�K����]�*�%��3a!A~�{28܌�b����G�-^��f8��YFhe<LK��f0��J��t��:q��-��P_C��RNЬ2s�&��@�h�˹�=������o��,EN����� ��b��.(����=9bs ��/���8�
* ����r����B?QQ�=�Cat�n�Шz�	�߲R1��݃�� �Lң��`mT�IX�Y5�"�������dv9;��q��eZ��E#+Q����Y��]�	�Js����ϥ3��++v$?�S��v̀pЪJ�M�stact���dU�s��Ĕ\���ٌ~���Y�-BtF Lt0=*>�����~7�B%ڟ�g�Ez=��Ц��5���`n
� [@�`��8�E<�9��{I����y4;��ڬ	���#d�ŵP�<��N�Q'�!�uJF�JF��pZ��,�r%V�(t����H�X�M,�%�����z2�k���2�A��
�tm,�l�
:W�a]7�l��HSf�����p0��X5ƀu�k�ʙ���|�WųF���l0��N�SQh�e`���Іl���A���� x���\�@>�|�s��cgW�^P"�8�C�j_�0֌�M]q㌕B�irv��Y��Į�kugڜ�c��v�K)�Z���P�(m�RTF�.�t�.^+�d�D�zh��w���L�²�׌Dk�vګ[���B,�;�&��f;!��= �9��H^fy���N�81"&�Q
汇+��v|K�n�u���!�6�>f������R@%���X �a�����]�A�c��<q �ڼv�ۀ8^��J=wJ���{�99J�����K�۟��\6+3<G0���È� ��/�6�ۨM)�v0����J��uXѽѷ*��A;]�n|̓!��4�ƚ�c P(�:�r*��p0���#8�c���5���=�Z1+c��3ͳU�ī�[�G�OUq�D���	�*ST��й��w�nE��Ư<3	�I�@��%/[��=;�E��2w[���:����&���3�A��@,LrP�ZJR��� 5�%��yd�D�v��wۼ�Nnʝ4���(�������3�ow.��Z��n�{�B��7���)�h/�5eV�j^>��ҟ&��w���	�y	��bZ�:Q���i82m�
��I�B�C5x���vm�8��]� ���f�d��=g����0V.���M����Kԋ
a!j׼
�d̵We^����V`���c�`lD�f�*A��W�����~���)���c`�\�]�)e�y�����ֱFx&���[3"Mi�'ue�(Z!2Z�Ƚ��L��L�""[�l\,��2�b��_O��2S6�������P�ul<�#�e�»��A8�u��cn&,`�׷�(�4��.~�]|���pS�ǉ%�)� �|s-�n$@$�>�Tts����i�[M#T�-��B������y�Mwg[�獟� ���z��5��:v��^\:���[�D�j���얿bvs��at6�ܚ^��j���1�O��g���=@��\��֡�b^Z�U!����I���U%�a��e`N˖*���G�>���U���H��3�RK�:�0��鍰e.��:��Α�0��\5�6:�gy�S�����M�-!� �Yh]�7���*�^��1o���=���U��L���
 %Z��#v�
GG����o��c�856Q�# ��B]�:�
��]t�����9}̫M�$JX�d�#�:<5��$z�+�R��O�Z�:�ei?R+�Ɵ'�SL�o6��]�ֿ�	w^���ɴ���ZC�%E��RM��e�cdli�'ü�ٛ��TЏ$��	��9:�π6��ϡ2SqN�c�~T�ȟ��'�]�!2����B����']�.����< �����L%�1�
�� ������	L�:;'�jNS�f�bں��O��LPs�=]Bi�6�$�Vg*	:>�>:�wOK��_����Ur�K7kGa���	����ݑ��e��+\�}�U�~�i,���h�(?i��4�ijN�� �Ɩ��_'�W+���襽���:쥷e���ۨ4^��b�[�hBpb�Ơt�&��*X�|��Xko���M��в�m�{S8��d���X�770�3�$!?����Ӡ�m����q��k���%g�%_9���{e8�19�ÖVy,���%	Z�=�=z_G���M����z:(DWm6���(�[��i?��t�%�i���P�᥯v@���K7�0����Զ4��=���h�.��8��M��������J�y;m�S���d��
/{���S��fz�:�$^f����w��ٸ��b�.�;_4Nд�P`>��NS�e~�G�6��z�/?�]�w���`�y��L?z�*�g�"�i�
|%Dc����U*�b�5P.����P��0i�7�v��S}C��D@�p{�����o��:�~�Y�i�9������fP���Q��JF�VmU�0�*��wֶ��[r�vq	�����{]��s
���u�d��IH""on0����< ��5!�>��Ǽ<[Qi-tt���ؔ���~��uw
s�'�Z��^oKz����:V�R�AI�o>+2{�8[�*��a�{�����D��GOCg�F�D��Ak:��@�h�77ëT�R:��5���l�M�NC[�'�� �T�!�L��1�S�cp�7;]w����g]Z����l��d�}��BO�hr��.֛-oD�$7`/��7�hc�Bn�N6����c��ICf"�m����d�(F=z��',N�5�n��%p�E������<�?��~�N�!W�sϰQ�����q7��oT�+��EN:|��	+��ͺ%�}-&)��l�������\)�龭L�]�N�C�Ŵ�8���`+��b��O��O1���{[}���~%q�뜅g�{Ŭ��Y�����Ś���Uo�2	��&�L���$~+��x�`arK��W��ڇ0�
_��4� ��v�v�c�9��kPV
��]��V���(:-����NTjx�����a����~��PA�-,��Cύ�)����P�#_�7:<�s����i�~��=����xy    �O�U�˅��b.;�K�ޫ�T/(��`��R����녓qT���r0���uB�Ǿ��ʰjhF�35`�Y�ɯtZ�w��L�aa��uO�7���UMvY�@/�P�@T��ޚ�W!��ko��fY�H/����~��l��T�?�_p��|c�lG�?�BD������5�1r"r:[��CY�Y��Gb�����\/(�P�HL�ս���b�Iu�B^ps0��|/T���JH�=���	����j5�zo�ha���sDףɩp\��fu���ю���%X�����{�$��r�%�b/�I���c�!��3.�����3���)��X;�<aLF��(U��8�BZ��Y5s�(NƼ4Ca\�J�HT����j��ӎ�C�7�,�1$�(�Ms=�C΢��m~�9��������4�m�/�*��4Gx�*C�#x��-��r
��X�����{���4����r~�m�����3��e�1[.����\>J�\���WC��"�%���V�]�����$��];+$��E�|1Tu^XZ���2i�-�g2�U��uy�C�5�|��N�qD�w�̵�I�L�_i�H�Ku4�֩+��j؜���aS���tz�$��\�+�0��^�_>�+���yob���K��?�fb�q�-fS;��a-�_�zrV�'w�뿺NI_�P��rtl�L�"��`[<�b�/Q�斺��s����'L���Նi³h�a��ƺwr|�'n�����'��]������s	/��쒓	g��#-�m̪��l,]L,���3ۦB�N�)jSǜ��GC0��vW��r�Qq�>�t֩t���.	?�qA{���x���ׇ_�?�����n*��ڲ~��9g�� �Y��=N��h)�jk.п�H�:�9�J���E�z��	��('�<��X���E�+��[*�uAryG�9��y�s}5�}Z֧Q] �!�q�����>kņ�²�}t�c�7�.� )��
e&DM	��n�iR�'�w�ˮm�l|���8�yY^bQnqtW-�N�9��B������|�}r<8$�6��$6�gz��O�p��7�ۿez�F Q3`X` �p&^6=G�Rf��y����o��@>����(��Jj�xzI<���� ����2]��2~��i��ק%(2��`�&Γu�:ă���p�b=���b��hǟ�h4?f6�ւ�DÎk���xLM9m��$	��m�_������׻��zF�.���.ձ}�i־�P:E����{;i�k�`B��i�j�3#�/�!���{�����n��&7��&�� �8���#�N.��0��Խy$��gp,8	OO���uZU�Tv��	t֫�,�ӻ��Ap�����R����nˏ7.n�1������/�������/��%$n�#�s�P���RSi8�a�X�2��?�����/+�P`�4s����v@`2l9 W�s@Lfg��O�F���x5�s{7�y$���`�`��Wk/�"���Aj?�zE4��F�CvJ�Ҋwa�9-�:a�������e�4�Uh��GUn#�E�����j�E�/ch�?�ʭds�r���(�B�l%��3�(]d2l��gƉ6.��3���	��o�dn����'��:X��!s)$���3'G�t�/���-��䖾�s��VB�,���f���'(�6A���l�ùx�x\������m&�pu�[P
�g$Aۺ�m��,�EC��U�?�?\���aɄ�O�+(�g1y�j�Jg5�pf�rv~�ߛ�\������:2Хs�/t��u���+D���H:y��>��Q8S9͊��`k��/�[����V�`|�m|WV��\)|����lV!��e$�_܄��J�� %)OT����

1���(���ph�]h	/Ȑ P睖��M/˔�/�G�3+c�� X�R����8�5(_�T�ֆ��D?�Z0)��r4��yZ�u�P�͡���W�^�U^�M�,_fNL@�6x�SaY�v�-��D���U���DG�.c�&���uZ�S&�ؕ%y�u�7���N�2v�����8����N���#|�f�
=C�Z�����N"�Yc1����0���$��AL�90wو���z�Vi��c�e�(p�(Õ�P�u"�ѩ!Bv"�G�,s��}�I�$u/�:Rb���^ذ��\��X�/�4SC𘂯�&�Z!�9&mEIf�a�
�f��
��ZЧ%���Y@�ԛ�O.o"M���8��,�W*�5���!��0��V>=fje�aS��,\xhTo����Y�N��憅���!Hu&�ԣK9F�T���B��k�$7��2ѥ��%��3t��=����%�d!j�/�������L���"A'��'@�G�+޿��@%9O�(���_|���8�ZW/{�u�/�o�Z��R��u�<z��.eLR��F�v�����A�/������.�*�,�%��Y�zw��o�֧^6_Zv@ǝ�h�]�΢������j��
��Nr/��:�M�I��h����8�o/ǟ��'#�_"w��S��v+�˖���3.��^q)�9�H��Xݐ�C����mF�����Bf�`L��0[��-�Bw�	�`ZoYg
ڃ}�����D�J�;a�"|��&�c,[/���V�Z�FV����9p�Y�\f�P��Y�M�3�ٯ��K/:l�F�?�%����~e�0]����S5/I�;�h;����ϹB�U�3���a/����l~�.�.]~c��y�Z��L=+�&��Uv
\�ʱ��ŦĄ�\`ij�1��Èq���If�~a�֟�i���q|�N����|x3�H+���g������U�LiY6ᄃ�G� B7��h?�eA��\�w�_Kk�.�0#.�s���Q��]�Є'��'�f�GD��[���?��Mx�����f���.�"�L�<��j���T5k0&��B�>�;��"^d�+4���:�`�̾�N���E�	�J��즦�����QiLr�-K<gظF\�2��L��p%�ڤj�3�_��G��O���~�U��eJ�B�c=�&��c��qm����`g;̉Y�&QvD�G��m��-ijD��]6J���*�����cEITP��6`j��]i�ן֟�#������>����+Jj;I����l'�u���M�h��%h��N�=����DGSNq`죺�ћҶ��#�Qf(�y�h`}
 -}AT��vu�����u\rkpv࿄��m\���-�gB���8Ģ��q-���*V��z�J8��L�`�x2��j���T�EM*5�0'2�%�N̙�ol���p*,�__��)$���(4��`>"jxG!u�3Eʹb`�[i^��,�������|=���8�H��W�m@^��4t��#�k�}���x�e�	Zq|u~-�S�Z�ծ��P�@��q�=�ti��G��h� 2�{G���`tԠ���1.�#���i�J�d���>M�ᩄY��#\�����7�g��=�\���K�Sk>�d�B�AR>�VܞLr�ᯑS�,F[��5\'eڦ���m�;$<أz��� Q�t��.M�tⵏ��l�Yy'�z��;I��P�@L��T�\L`YA��61st4��s�E��L���Z>�F(G=.��*�4��*�[ld�7)&��h�;�A�nT1�Ɩg���w\+r@�vc�~ q.JH�zɢ�=,�E�m#��VЊM������-d{���e�Ã�a��r�,��!�j�+�q���x*�q�c�
	�!Ⴟ"�A����[�tv�+^T����z��}_]�OK��m�7cD�D��� N��+F�v�X�1\���I�o�r�=DLKd��ʱ$�����wX��<-�s�m�����Í�q�mu[/*W�do/�����#��W�9k+=hp#�p��g5Ĵ�M��_<����|�\p<�v¦�/�OLR�������l R �����M���T�">�h��V@<���8{,�,�L����"��Ue    M6�B�U�Y��su}]z�P�5�d��&A,t�Xg�am�VM8�Ώ�� ���3|/*�#�yME巨1,�_��6�m�u����%|ѥG8��Z#͗�����
��kj��v�w�����B�����yr3����O��d����o��Z�a���9���C��F��kZB�n�e��&eB�dpθ_���5ɟm�u�2	 (�� _Ƨ��_�LL!ȯ���6/\�ǲB��������`΃W��MY��ڦ�����o�w_d��E�J[��nï����A(�:���"�+l�Q+��̩��l�"�_Rs�ECH�Ov8���Aop�*l�#�7��:߯b�*��ɑ��5�De�M����N���ړ�����ZF��=�y������v*7�?=����.����љ�� nfI`���F���غ�7�jV�S%O�\W�^~Fa�%m0_�\7�
�ժHp�{������Wya+/l^�}�Bp*�
;��T0��;$��#{��E�}8��
�����pyׂ���Һm��%$ =�u/��sh�����?bJ~�������goz�yz}v9�4�| �?y����;a���b�=6Bp���֑j	���tp�u���
g�/X�0!m���X��<�$�z��9*k�Q��e�r�FKf������o�Zk�_�Dh #i�_��'�Xߎ���|���Kd.�	�������@��ݮ��݌�q��ݤ'�x='������_������ЭHLu����Z	�"v]��<}d� ��o�q�dK��]>��`ק��I�^N�, ��=���T��΃��.Y`9�H�`i��F$r�]&�e*	ę�@��~��f,'ڳH^�i;���,n7��ΫYVq,Y"#��$��w���Tv �MA���rZ�tn[�V�?���(x_�5숐. d��(V��we(GIKV�톐�le�p������������<x��7���2H��"�o����V��zG��G�G�+1�,!y�����!&�i!�����O'������G/������-]��1{�3
u�����B��l`����"�\�P��uB��-Ta@'s5�8��@����f����M��ttl�\��A��^�PY��;�de\T�RGx�рS�
�E���$!�!Bh�X���rSǜ"�]j&�����L:_�T`���C���Wҫ����	���Wv�N� &&�y C��?n����Ћ��V]��T�X@��w�A[�P�[�o��r�o^��w��O��}�v��o���:	ڻ l�*��2c�@ߴ0�˪w�N���s����tXcj?,���%�r��R��.�6�Хt�т�ir��m�C������EJR	|�ݍ�
S����{�� T*�y���o�|���R:�R��'����_o�U׭�m�V��g�Į���d�n�笡�M?�)�t7�#'m�	&�V@z[_L��u�u���+x{^�W�U��9\�X>�^�'ODiF�M]���� �Ċ�Ã�	����e�0�8:�4>q-U��������^�u�f��íU���4���]X���iI�sZgv9�A��R��Z�@xe��	v�҇s�$�j�LVuX����Y�78|\�ߦ�w�R~_}BH|3���;�t���VL�%5
���~���9����;2̊k�B��.�-�����=�r����xF>[�t�:-����Ia�_
u��\�t����Pڥ�����q�*'lKR�=����şL�[6-*�
��3Sg�=�PK��"j$x�~��p1?z��W��
���l��F_KL��2��l�֎u��0[���D"������=���n|9�u�nJ������|�⋅�$��f�$B�XY�#�1�� �k��������A�頷�2{�'%.(}s_YCQ�2fR����a�*�w�L��]��7JNi�|?�̢ 4	BS���R��k>�O�J��9*�d�gHY��?��X��q�s6E�q[���~6)����fׅ
����FI��m*3�V�"�Mӊ��9�bx��,]�1���{����|��ek=�C0-�aa8�v}��%(�HI;m^AS�be��*�X�i����6��D
25��n|:�z1���wal�E��3$]�{�%u��Аf;)�_�<�B���p���?q�k^=
ne��-��g,k+��%���S𝟘����9se=$���!{����s�����K������?:����viM�Ҧ?g)=�"��ɩc�^�\��ȥ���`�c��|g���e�_�{��u���`_|n{���Z79������~�o,����^'�!5��Wl%����˥c[.�1_/j[�>+��C����\��mw�b6=�~}�fį1�i�$�@�Ɇ��#��n���K�{k�����N��+��9��N��	�Sb�Jr����p��At��x�����-݃�{��&��E/o��NU�	��`bd�V�"@���&x,c�����8)��R
z��sV^�5V�y��"���*iX��PR�ʹ�j�Ј��,̊�`3E@/.Q�yS �s�a�F�'��\�z''�`���+�d�c�N��?����?��]�����._e�fK�Cƭ���&�DA�z>^��`_K����Z��첀��Y��Xn6�G����dc=��Ƅ�����9w�|ePP�.��υ3��>�(Ri{I�+����,R/��-K5a+s���!s�e����.�*D�Es"���������}� pQ�EM.�L��� -�m���$1g9s�a�#�t�#/�.+��.l�N{!�[YQ�Cv��Xk�)TT3x���G@���ҿ!Q)w&#VFY�^��T��4��;�'Y��${e۰ً�=�E0�du�|5�X��`M�r9�c"��~X�\A�09��t�O�'C81I��s�p���v�=�}|+ɮ��z?�X��rLݱ���H˪=(�Ц�IW*,����~�X3�S{��2Fz<�=�E:���l�9�T ��[Е�~|s���_z	�y
i>`A�[��k�!�F9����Ǟ�bKl��ܬ�B$Wl����e��sF��fz�(n�t�)J�3�� B�@P�u:i��@�i�ޛ��E�l�WٮE��"�s$��]��g���3�θ�����KD�r� �kZ-g���t��
�Q[�[B��.���]v�|²�P������x�d<��h�mֆ��!�����Z�
��o=��+����rP�ڢLP�u�Ĕ>@J	m<<�Iڼ@����Q+��/�S��"�/�ޞ�=׆�B�������v4N���B}1��<�C���v�0�U�!,ȕV�,���8j-�b����ҍ	$�(be״ڽh�Y^oB`l�7laa��Z/ֹiB��D��	���8ڝ6>���	T�%�`+|L�>����u�uM��('9ؿ��9ɥA�u��8��c��MP�E�{�J�^oLJċ�n�~�c���#��T4�3�������u�'_�@v;,���=�'"�������NIGO�<���jS ("�7�t�� 62V"s��9W�s#�r+lhy��^��A�Y+ޞ!G��i��Ҫ��;���L���0������D�)	���	LeQpfs�w������&��������	���G+k�a�������ꁦ�\��-+�7�:��W��Kʴ����{��/�b]�&*�Et�E�:���L�B5�f5@y���;��ӛ��}��.�*?|yI��8+�;��\� ��
�'��6az}��8+�%�������DZ�H'S�FYf���:��8�r�oH������9R��nz���4�e(K a����~��+U�����pﯷj�M$c������̛aT�DHL�q����7�E���}��m��K��A��?B�b���ʬ�|Z��j�xhH�s����9ס�`#������o� ��;�\�� �������j�^�
S�    8��-I�n��4~�c8𥥽���v��ƙ�)���[�{d�v0u������q.�R��f��LM{�-������;kW���`��U��E�Tm��ʥ� N��
��t/Bx���3o���L)$ao9��"M&�¥��]�6c�N�Np1
h�5>���T�Ku6���1R�a��%��LZ	���q\��N@���Kʶ4e^�/��y| B��Ӝ�����9v�����p�����f�.ӓ�\���H9.���B����J�[y���~!�����`5L�S�|�S��e��k%�f����0�`��o�n�?Mf����>On�_[�J/�b�=���R����C��{���ů9������%Aa�a��C/ՙoh%�+�BH[���k����k�Y؄�QX焌T��.w����`j�Ţ2g���ש���;!_\��.H�1�@��MV3<)���EWNf���cCvN�J>���P��{��{�kj4������*8�'&@��{��;M�:?�y�hiƲ'O�+Nեʫ���H3Î����k�'ƫA�ݽvL�"���b@�(Ts���<�v�p-U4J����ܹ��3��O��5�<�nt@�ʯs�2+Y��΅"\d����N@�7BXヽnN^����b��2��F�� �!�V*Q\(}����.�2��VS����w�_���o�+���B>g���$�o����!\C��g���l�7CH�F![2�&�`L3
0��7�<0,���/U�!l�?��^~I�� A+Vj]6�4�_G_�.]�������U\Ŷ�p#�5��?ռ7�P�Uw�{|��g��s�W�QyIBCp��W��08�3����Y8�u^���SATH��6d�	̨9Ve�&3���-�W���%$	,�s|E��Ԩ��0�n��{N���#?�٩������ä}p"����D���XP=X!"�P�膈J�b��r�a"
�{�6���D��u��558ޏbe�L���0A(���ɍ�>uܛ:Qi_ubr�%)��
�׻�뚤�O���2Wa�:��/���d���N��)44Il���"i�%��jb�y�	�G��,&ܙX���q����-�^{LG�i��f��f�ձ]���;O�ߖé[ZJ�t�����zi��!&�y��zN`s/��9v�aჇߔ`�l3Ix_cI����/X��d̝C��MEGl�N9�U�h��5�6��]2����LR{6�8�	��6�$�8^�Z�.)�7�����)���V���|Q,��cyr|y�8�v�[Z?<����� ��v�������n������^ܱ�0�0�԰i�L��E�E�s2�P{�E=��.�<х��P�6�fHA���%T��s
-�8W׭GE>�ު(��]�FM�&v.���i��t�߳nzs?s�AmI�9��B��o#�8���#�*���R����
�)V��-Cû���کToI`R�[B�Z���P�m^ۑ�:��r�Ƞ�}8H�{�ہC��M�� #2!�#��&��m;M|�j���M[iҜԎ?���54�'5��.�9u�8�D%�q�K� �B4��+iN+�t�g�L昰�^��^J��'aR)UNz=�֜�j]S�&I&�k��Q��~�)�C��.��ΥJ;�G��>B�:>�!�q����׹�������$�Q�#��n�\k/U���f(�d+g��Ք���5� 㑪���w^?��s��nINv��1.GV�3��Ku}m��t[��}�����'/܆��Z`H�_ǰ�����d&���Es�Y�":��L`NBA���[�<ͥ`?�c/�Ѣ|T	n	�^��U Be���,�1>ó�%k���X���tLf�d}n���S���%+|8�$�Ж�w���d����o�ٗ�����i�`��6�e�@|KMX�Da�p}�p���)_n�����W`Q��Ϟ�%o3�$����b����@�T����sE�^84��˛���k�(�����{����ӤÂXq$Ӫ\��hE�H��EV�^n����29�5���[�2 �aMzEZ�䫗k�3��]@�3��`\��%�lyd�1O����m�dЮu�8
>�h�Ifz�O�XĖ�hrw~�*�8�������B�VF�m�5fB	Ϝ긱�Yf�('{~��a�P���@NhU_�*�$�)rF��͖<�����u�gHY��M}jl�8��2�c������������G��eDU��	z)�	0,S#r�đ��$7��K�����I���4��C\-�M�/�gt5�{�~{bҨ����*[�S�F!P�q�4�Ӂ=�ye�0�Wqea$54���y��X6.��7l�I'��,m �(�W��O�Zk�O5]W;(w'¹L �.Մ��8�y���ʪ���]�2��9g�p�RX�D-��u�������`���t�-͔�"���SN�$Ah7����)Kb#Y	Z:[��w����	k"k��������O*Xv��ư����������b4�'�����q8��Rcg~(���%j�^�����6���mᑵ�y�l����寡\+Y�<#����?��]�������1�g7����2'^�����}} jbAEHj�gi�(W]W�=A�e7��ϛ��N���=5�(M�4�\�Pܳ����GBmVt��ㆪ`$���X50"���C`Î�%_��Dի0]�y�?|��7h�3�F��ݗ��x��V	��s� ?Ts��uFy�j���Ș���qi���>�Ehc�O9t�mũ�뒇\���[�ѳb
��8ɡ�c��\u�G���c$����nҼ�0"1��)����6�/��}N��a+����������7!,
j�N�����Հ��e^�og���O^��&7�[�7����q�6�%0�h:v)��^����'RVNs����Ձ9��B9x6��drsS�q����3-|�aez������,mvO��ެ�a��<���LY��ԙG�*��Ŏ�\�w7�nVtG�<Ebh�1��R� .vmH��I��c~���8��S%sv��~��g�T�p�K��=	�B���U=D��ٜY�Om*1�Q���mh6�<��\\�_��-�l=G�� ��1���re���¢V��ͮ��a�@�U�-�(5j 2��v���A�8��T`R������3q��Dd~��1l\� �Uƕ|EW$Ձf�rY+�kC�GH�֖���7�N��Ꙧ��
�����Un���m8���\R��!߇JlѪ/M�l�-6�EF�W��^A��R㙆�C�l�zإ����� �o�������N�[��#��%i�*�ā9��	�0����uA�����`o��ZH�h��K�d>�����`�w^ÌpQaf*}5|C�ъ����\�.Y��ߦթ]O��3��C{8��Ӫ�iSr�"����pWk�iu2���y	a@r�����x�6��������s�޽���Zu�R�����r��z�J����s��|�t�E��6�����E��������f�	b��M�\O
	F8�?����TӐ���82[�F�R�D�٬��ypg<݇-�\�Ն��ͲY����E�e�%Ŋ�XnLEN�#�EX�xH`�f<��s�;�i�=���B`����$I�}p�����^��j=��Ia���q8���{~Ŗ�e�<�;��h����6o��������v���S��p�j��J��~Z�]*���Q����6�T�k�y4o���`6�H�#Dx.��rj�1�d)���	- ��;�"�{��V��rJC~^���A���������6�-Ɏ�6*�&-L�9��6�[zE>������C��k�͵"�l"Āa�o���&��5u_��p�4����jA1aD�ȹlZ���r\A���XX�������/hz�q+Z�⠐h=�UPm�������X�Ϊ�Gధ�����^��v�=(ƐC���^Uv���vᅟ."y�'Lؗ���@)�JW�a�z�״��O��Y����� d�e    �:!]����a��B���t��H�b�=<����"�Nl���+�5΢@̕�3q5�[yF`�3΅f9@_W����Y�����������L��R,σ�|��V��^pߠ%3TK����/�h�a/��A<�e��2�*r���k�� ���a��s�N/*�T>#���)���]�X�2��y$c��c&�#�	s���s�*��&g���js6���Ah^s��6��问D��z��@Ή��8.æ���X!���������	%�8�!���9N�K�����o�O��:-a�������~6�*����߃���{;�/|�ńݷ�=R|��|�E�a������i��}�#�w��n؁aMy�2�a~��'�Y�8����J�^�51��j�U*���kΐ�Я���%9�����P�2^��/� E����m�48�u s��H�n_����nV�wq����>��]�-���e�<���f}9B���h��,`&$�;�����Q������7�sU��%#F�r*'J��ƘS"�J-�,��vvu.G�f,��4��p���=<��Im3��ަK�8�y'�u"x�!Z D�=:ؐhN@>�I��)�s�C��[v�U�l�Jҡ���k��}�:.�<W�+M�4��8�̿u��z4w�Kebs���DD���QNC����r� dZ"U"�������WBt��O���v)=15��3p�'9E
�� ��F�b�=/�Z#/�[*2{�m�H��M7��B"�at��#��L�^�{U+Uyfb+�����=#4�i	�e,/�B�H {�ۻZ����������?Jf�;/V�iI0vb;l���H'���#M�B��
�?���}-������#NL~�~�J��?��ąB�n�$7Ni���W��w�G�+~�	>ą�����l�=���Q��#J)ў�C'vL$��6���7ݰ)����X��J�OJkX��ٶR|X( �1w����m�|C�]O.�g�Bp�m�~v3��'lYr�������	WO5:�h�b��8�R"Z�H��_��<�%{t}6W�y�Tϐ���XA��E𚠩l��DC��J��zG�����4���7SJ,�¿wl
�4pɲ�F�B���C*n���-/I�~/Ym�M{i8��@�I�58sٶҬ)SҲ���?,�z�Ʌ<�	X���Y�2���X3� eഛ��pppx����?�c����&jo1�`�z���r2��b�M�Z��v�;���F�y�ae(Dg~"� ��ƀ���k9�[�[�ܶ[ۖ"~d�M�yƭI�� ��	�����`�3N�İ�b�$+��n�u]���.�ɆU��vP�.��=_Q���0��z�r7��5�6r�ڼ��}��������}C����&�Y����>k�����%�����l���>|��[�
l!���茍/(�Z!�¿;�>l���<�f�d����[�/Իk��+�q����Q��_xFp�H���`S�QP�����J+_�k���f�#<Nv��WdG2O�SSp�'��ܚ����y"]�r�R/���;�N�2B����ژB]JJDw8��Af� #j���/��ѯk�S�fSCSF�wJ	�^	�ɱh�E'��#���y�E����`�e�PY�q�7���{��������y���7���{���������7��=���_��o��ys���>������Z<�[^��02R�3_����2{P��']-��;���<�_�/���\�uy��F	�.{%��O,�Q�8I��N���������&7�6��N)�2�e%��~1�=�*Ơ��B�����\jh'�j��ka^�)�����o�\�2]Xq����oKK�}T+Y��]h�;����w��%�����iY`�����I��5��s7����D��v�7��̢�~���~��U�]}r��Y7��d!d0A5��!�����%�X���E�*��W���QAj~M^*E�n�u����9�v�SYY���=��l�7V���ŸMo�H�+���������+��)�C��W�+i��:�e��b}V�M���\�L �+`51�;����;WA��9��-o�Kj�D����� #ac�km!:p�)qh���kT���Vb��gH�W_�3�!+5��,Ԉ�����r�|HdN!!���X��&^u��ڶں��~Q�,��t�i�
hM��<-��H��0봭�ї��6���y�O�/LnMj�z"���[$�RD�"�/�ߌ��@MF՝�\ڽyد΂�!2CD�� ��j3��LT�.쑇��Cҷ�;Z�E>O+B���7��ۆ��Eq�)f:�	[B���+�Q�Ҡ�(B�'�*���s6� m.�I�5��ч����7�D�I�.*[DvH����+�N�ku�p������Zm��ؐ�CMƦ&YQ�����V7mdu�&ދ�i����,�K�cT����ѧu�獰�(�W��r�MC���l�^���+z�	[�s��8�FX�Q������ƪ<�g��\F����r-�E</xt��$���r��K]э^h������Q^�:����!�m�(k�5,���{�-#3�t�\��I[�9B���r�5�o��"�K��疍�k?��$
��`R>؂������m��P���a��mj�tI�7�f�h1�$�`�B�����RDh�ʕ+�aJ�w�7��x�uDD�xP�ɵNv���h×�Z�^k[<I#ly�e2��=5��W�'`���� �`LI�K�<���|�g��s"�20�A
�N��TT��N�����W<�lz3-C�P���i���������\j�r�:q)w��͝j��:��W��OWe��BN���S�\��iU�,N@]8����B7��~�]�I�r.��5#r���#n�4&!�, }d@<���w�2Ty���Ŭ��L�_���C����l�fN�:RE%���`�*w�7A5�n�[�����nP[q�&���$����p
iVvY]��(Hun�'��@��b5lRn9v8C��e���$ju���[u+��)u�S�E(!s�?ڠ*Ԟ�IQ��-�F{���p{c!���,,C�� �T�ä��ȥm�׍�#��vc�ApV|���R�>O�����ɮ�4Y��`~����rnYt�A�m49��6�-hc�8�t���9v҅��H�|.�����脑�+Y���&%�Ж���rr`7r��6=�t��2����"mk)�>[Ŷ������$Nɬ�9O�cU ���X�Q&e�M�x�%`?ӕZ�Dd��֚m��%�|�'5YQ����3F0�*k�9͘��%��U�����=��(�E���V#qzӺ�J)
��K�Y�&B��I���ֽ�H�������ޤ'����* �tA�/��,��ǹ��$@��L���a>x��Z���M�}|�C�hje5g7��{�h���&��<ѰE9k�J�r���_�ml����P�%N�ޝ7�=aq
��F~�<�;q�պ��
r���B��́�}�����f�8��ER�7�X�_j����;�mw*��~rՙ�QjYP�B73�{��E��y6�Q�0[�$��2�R]/O�����(�y��K[��~��� eM%H�	�J�c��{I'Lb	VlU�Lf��'ڳ�]�7��0U��T��F�է�Dx���d�V�V�eT�+�w4���ɉ��?�;����ie+6'����T(�j�R�b���j�ey9�q��������S:�Ƙ�������ǽ��
�H��Ī-˷�vx�:��9۱�dadp�I\h9�Iӡ�����5.������ۏ����x���H������~�J��4�/,�ip�S�N4�Ūrʺ�G�L>R�CJ'��h<��X�Zyƪq��Y��<�Sl&�c�t�Y�U:7d	�
��1q�t߸��1��$H�'<SC(=S����NO'��Z c�uV��,�*�
&��H

z�W�?�����b�')�����.��qY��v�QXjIS)�<��D���q.�x����4�^0��ʼ�sHZ�r|�H;���j    Z���J�W�`�,\bx�k*V�U���B5܀�G�p� _�����[�~����7C��U��>���r9�$�%{�n�Ѡ�*�OJC��}2��HF9!,5o�t:p�FF6�G�\G? k\�`���:�2�Xt�(���p����5�.շu��S>D�
�d�Y*VuL��.���e���o>��׌����N�[:����1!ω>�+!��^9�胕je��;�������2Kc�q���:f�S���_UH=x�������=���obA���*�o�o�ēL�i�*�-�w�������'��&u�SȲ�jS���ށmese��	��p�0���i�t�1id����IXWu��'O�\;]'��W��,#.�V��]m]��B{F�0t1I����6S�I3$���L�wu�\a��Xz'+�p;��^/�O���x��X.��ڕ��_ğ
R <�<L��/����d��`A\5[�2���)������X��󲛆x����`_���
�_ܒ�w�?ڳ�g�Q���?�E7� ���� ���Awv���J\��6�e�h�y..��W,��k���ao���xzZL���6q˭�'2O�릸4d��]�\�������^�j�k2�zi�oa��
X/CS�"���L��Ჶ:j0|o|�߫�C���3,�ck�l>�����jiՓ�A���3?Ăc�K;�9��Cp�3g9\����lL�-Q˞�;��U�t�fgy*,�\�XNJ�;��H��҅GJ�������A*�x2�<��;�.�'���0�S\���:\�Eqq�"�eI=Un�K�Z�d$Z$%�M��d�?XR�0F$�D{�B�\˵�:�KkbٗO�p@��#�e������D=�b���Snd�)Ize����e��;#��L�ɒ���!ꐽ�u�	�� ��,�fx�!Ͻ(
].��br4�<К��i:J�1ûb��px2رc���br�����O�~w~=���z+y&~�Yz��V��{�D)°l���mg�v�a�0$�8�ً���7��T3w��N�� <��
o�2)���й֩f��5�m5c�G��J�H�I�B�(�-�h(�ޚd���va��>\�s��־	����a�3�����|���J�RnK�M��[�#��;
|z�s���:'}�49u .C�Ɛl3!Y�{_�O��q�-i!��k�H#T����Tn�A�fqΕ���-DL�F|
�C��V1B%����ȫ�G����k��)T�9���f���B�QY�J��~(���ĥ�^��������{���N��H:��B�\�ꌳ%2Ca1��5��qr�����#��b������2r�g��`i˄r�\ԕ>T�t41W�8 '��?D��0��~�ii}����J �䤆��IcPw<�H�=w��h������[�Uq�Gf㮋��/E;=Nqo`b�A�\����r�����,�6~�B���*�ߓ��� ����.�'�����j�KKa\6H'�.v��R������mp{���񢼎�)K5\�ǩ��u��L����ǝ������(�@����yb�Z�1fVuQx
�O+#��"~��E�w7%�̐�%S�r�����K\1����X���A,�e�d, n5YaY��*�,f�3j[�mo8~C8B�a�Ln�� ����ٚt�giW����(�6#4���S[�u�)9N��A��2��E�\N>�/��w&�1s�m�u��'띳�ӂ�\����O	/Ɍp��{�,�B�R)f��B�<ߨ�?C�U��eII.e�=hY�W���9jY�4��B����ʼ�B��j*�j��	�����"`]���A>迹��~�xq|*`B_/�����ϳ�g��*���j��r�e�_52gm�1���Y������Mb�&�Sʺ�������i,.��#���c���u�}������ݿY�&�V��_ތ6/��]p�Xg�\ԏ�'oF9Gm�vT��|t�OV6x�H�$G3�̹�oȆW�T�����Q�HÖ�V���6��zo�-��Si�+��'`S
I��_t�m�&t�����9�	��t��V'�-��ы�[Ǌ��l�O��ap||��N�/#��E*J���#�*)�������5"��9���L3�>�i��<�k��ɧ�I�v�(4�����n ���FK�s�F�Яꔾ��8�]�neq�����r0^� H�r�'�C�"��xp�W���9�/���p/�o�%&�NV�j�1qI8+ !)M�*m&55���*�v��x��JYИ�����je����f�ʦ�2�����cKP�䃢�di[�	�;�dR}g&-=�l�y�R�V�U�V��҇"�����H(B�6���a1�(�k���`�P+l�+�wa�`�`�>�6!YIvC8ϻ.�����E*K\�g����c^��'	"^c%�������X�fy�v��gB1M�X_�vhe./����^�a/��\�99ԝ�v9h��y�t���p�A��r��mDA��V�ZX��r�p8I�
�A�+���㱪L;2�_�N��tP�M쎁C�˽�:m3�`�X�EZ���<�Ƈ-ҽ�E�T,%�J�8��v��8�-���pw�{��%��	�R����gR��g"�M0���G��3�A|}�ޞc�������%V��;ٓ9 ��_��zxx�l�4�*���R/H�k���� �8$|��/�}�?���3�m��ϥ�>�Y,�?�K�}�]��������Dfj�6���{��!�P�J�r�\�%�a|}Sf�J�u��Er#P=l�1���O]��)�W��v��a�A�3�$y�>/K�(��0���� �b��ƒ��*��;����~`È+y*�~r$�υ(���^@Ƥ�|�'��
?�TQٝ����L]Ȋ�j��l.e���)+L<|51"����ޭ�P0b����	���R�/��cu���,j����lڢ��n��%�Du�lɡ�����.˥��~ec]y���Q��Ĭ"�R4ރL�qǌ���{;����?��j0i�������y�C���)T�����o��rïW0DJ�l5k��rG����n�ت�{VB��sαW?�N��.��u�ޏ�ї�#����ۛ�-\>GJ�'�R�ۂ'I�V��-/��� c���;+��߉G�ǖ9)͹�4��⩍,4����pqć�R�mC�&��z�u@���7�}z�\����N̅�{n$��E%xpfD=�K�R\���Xu�
"����̈́�VM��<̧P���,Z���I_^�I��?q���weRi6.Wu�iz6�v�	�?M���ߏ~��l�3��U�z��\��5�ɥ.�9���h�w��(����6��\��'���o��!�y�Y�\|�B$�����p�N?�e��&�A�'��?T(Oo��\��R3V������	����38���I[A���1ߕ�;+DP���Djx�T�,��p����DP�ra�j�+��%X���Ԣ+�s��PW2�{���/�آ�m����F\)�5g5��W��ǎ��l����J�N��{�T����v��`p�\S���Mn��zG6��[�M��B{eBiŶ�5;�_��Rw��v";U��%?C��)��Z�c(�������e����`,�lF���\�;���D\1�0)��Y�s[%ek2U��gh�:�ߏ��ݣ�� /�MΦ�]��>����r5�!���Ls@�%jBF���b�6��p���Msơz$��|���Ѝ������P������qՄ1�b��F�z�<�y�-����H����F�=	\\z���GG�m�鯃ׁ�:���r���ga_�ߖ\���7�����Qt�9���_��WJג�[�kp3y�Eps�k��o�3�u��bb�]tw��2c��GFnF��py��W�r�*�-���g{?����1���;��=�ϵ�~/ٸ���Y��qE�s^�`9�JE]
yuԝ6������>������dn�yX�n[i,�VG)�H�NӋ�:6A폕3p6
����Zd    ��|���R�OI�9Z�v��!�	�f׳u��h<�4Q�h9K���\l�"tXSUR�'|�lBץjU�u��PB!ݫ�eQ�<�	�J�_�V�>� �M�))��0q|�i��:4q�sPQ��7�[|��J�W=c�詄���fF,�n�:�B��x!� �Y)&c���\��h@Sy����
�_�x��o%�"�xt��U�❜/:��W�������Y���17�ߦ�x��1H�!��u%v�JT�+I�F�9.���b(�,x�����kW�"yٽC3�퍽_�h�����Ln�)߽_s���Uo%��tDK˪Ǟ�bCS��s�)6@b	i��9E��P��X�U�88���F�1ɺ���z���m�r6$����sJ�;�K�z�X��
nB%�^�q��g�H�Y����$���)�U�cJ�"
����D D|K�ԖbY����m����)�7��3A
d��q�޷n��o,l�
��$s�/�o�ʳFld�i#�Utgo� ���&2�%&Y�VD�&�KJbR�.�`��k�`�~3}�E:#H�I�@�-U�:R�Jkv���*���b�F��h�#���2���A��X�ۍ��Y��ۛ�Zf�� V
[��}������9�����9�dDJf�ϖf�>��d�>�O�WO]���|a�`��Q�|�����`��Mw��swwpp2�3LCq/o6����v+'+ʋ]�Ja��Bp�"ձ6c��	hBJYY^�:sp�me��{Y�ݓ���_�G�S�9u�G^�5)�V�����Ic��h��o���K*��j�C�۵���[� ��F�bR�f&�@�%�g�ױ���t \�%	��#�C��V�g�fz6���ܑ����-)�b	؜0!���/X�����f�_�x��ť��ҕ",���E������y
֭��4���y�"�Ӓ�H�r��H��r6*Ū�u�q�W|�~��ː�r`�7d��\��@>%�����QF��gק�	��ʹ��}PR|<�W�=�^�v�/OU�M6�m�lV����0���Y�ZL�":�B�),�DGQͱ�:���^�]�7wF=�pC�T��6Z�nR۰�^ŵ!��@\ǌ(�8�`�F�F�U0<�u$���at��!���D��K�������Z�/&��9�ӂ��t1k%G���n�]������A�����)(�;���ݝ��nl�	d�H(JKꃾ�j�l�B*g�C%.�6�<R*��vcU*���'��W`�!���a�T�t����6l�ס�?���p�v�u�yR����N0���F��;�ʰǊ}^�6�)�� ��['�)e��(ޙC�Ɵc}g�m���4kz;�����U��Rժ~�������r�Ħ�F(�dࢍ-���9�l��?��g��?��M?����/!������W[}�g�Хw01q�j-#(sѪ��p�g��Y|#P��~�)��c8���S,[<�X����U�yd}�,#�k,O��2���+C��hnt����� #6�3&3R�k<�J���}g"z�,��R������5�{��^�,�oY0��:���Ă�r ��:���1���G�7OJiuԚ�Jg�Us8yŻƵ�*��B��Z��<�rE6e˾N̙���ֶ�lE"�-WL�iu�٫�Y1�8?�Z�-s�D������oV��(�L��K�_X�G��V��-o��l�J�B�T����e��O9�6a���6$��{#M��ƗW��ҙDQ�v;�r�^D��c��協�^c�VѪ��EO��l9�_V�1��qU�4w�~g�=����g�)�. ��`�oO��c��cWՕ�x�royJ�Öv����5��dS=˸�_a��W��"?��~��׳��e;����\f��ae�u^�ԗ	E�`�����!s*�vh�D��U<��)�M�p�3kcF
u���>_���l�dt��l��� |�*�ݭ]0�/z�8HWQK^Dj��:��u"@;�?�$��ύ3<7�E*��:d�r�%�M��\l��D�-b��܌�K.��9��K�#U�:�-�=u=E�UC$fF���{�L��x���L0+t�Fj�u��]���^�c��?�z��	��B�6��t�V@���Ҥp(�?�~��������f�#/6��C(���(���;)@>E��+���Ωح�t`�Z�T��V7WP�V�����X�gb^<q�Vvo��U����\�Η��RI�^ǧ�}}�s7��>Y���4ADhr*z)V�ohP]��]���7x8��yc��ku�L9dU2˜jz�ǔ� f��x�~�/h��+L�0��ڙ����������^u��+
-��-��=��X9�3%N���*��^���*md��N�د��~q�/4�����K!1U�'NW�X����f{<�',��^�����uZ��"���?"��"J-��?G�)��g��L�Ѿs�][qd�fw����T��{ ����f|%������}��2n����؊#�tǘ�$A@�p5M��+?����j��}ȅvø���j�mJ�x�*8�>E�t�d�GC;���u���HZ9	�I��<�tr�:q��v{���1H@����� �Z�R<��I<r�S:��SkY`�+��z ��u_�D�����8�s��H&DP��4V΂i�G(A��&oP��C[�K�Z\)�e��(�
�mN�4+�@�S�\-Φ�[
{�k:֦²Mu�fyK�w���9��@����LsF�q���>y�}��ۃ�XY��Ʒ���7}���C*^Lo� ���m�̹*��������/66D>�g�{;w�?��6�s��u���'0?׍X�Fjp����+N{$w�l~:����;��Ҥ��d���.T������F���[A������'�2���
eFVq�&W����/B�$�7ƨ��\˩C�<O��aX����1��,�{丫�����&I�x����7�Jr*�h#����ʘiऄ�E����������f��2�����㑵G�u�C.~�����|x08:��4~_�qD����ί[MQ>����~\"�Y�"�� ���ڰşH!%)C��U�&ʚƒ��[$�q�k*�eNqV�L,	/�ZΏp|{���7H#�'O��:�)ѮD��ß���K��"�x9���Le�v�ZS*^\1G��a���VL҄[���a����a}b9��CHTlڱ3
�����$���,d8}�����9����H���;qw��2�J��U9�ƞل�J���՜��������Lh��g��g���"Q����M.��񒐼ɲ���.���pʯ�gs��>��C�D�·(������t���_�=;�M����n|6�F���9jX�3�e��1jg�@�h'�qK�9 
?;G9�ߺ�oȣ;����	f9tT���˕�gW�d򉗉�to{�9�q&�Q0�o��	��g�A���d��Q0*p�)p�:�Sgl�nb+]`#�ձ����6�o[i�֛����3椝�;S��	f�9]��h��ͫcky����N�XW3��S<��C�Lq���Y�xp��wE�6��
�����M^.�_we��W_�H��է�M���5�W�S��t�9�O��o/���{[��au�E?� ��LF��U���`g��.c��&˸���,��S\�u*;K�m�s�>5�@/�lW��$pn�Lw�nAʄ�5��Bd�:�h|[�!� �e� x�XK3�is����)����I�� �-d	͘�y����D8�~uG�){�mv� �E,S���qXGn3����s�x8����.�g����<|���%�G���C�W����I����ꕩ���T
�Į� s�`2�>���������Ubϗ���ן�p��$�h�|(�p�F�^97��u�ZNwt��6�s���6pT��v[�šc��ئ��6܌����
��_s���Q�ۖ{Q���p��lT��Nb�+Y�xߙSi���n�����	��hv5��;j'��ro}�ߦ�0_ˍ���|�E@Ψ8�C81nXx2�    �?���-�ʛ\9g��l�����v��K-Z#еȕ�߄\R�q���3�:�:�� +�`�/H�nV�S�=*�u*%ֆ�m�_�~�������`xr���+�Y���X�$d�4��U�����y�re�,g�h_X2u֚>fҩY)F�9l؟o��_��yQ�qTMY8�l���Z��I�5��x��~�9�5/���`�n�A�*��Ν�vNB��"��s��A�/�tF��HC%%�$MJ�ȡ���ݸ89�\���t9�|����\O	��~&#�*2�l!�����X!�����}2��H* �*�(�K��[[�XZ8����{Gvëɱ�-���&u�kE^�v;��G�y�3ɬhXf2u��"�T]��S."Y�ὁG��Ֆ�&Sg�=�ga�`��с����h��J���W��[��
����|�U|�IvT��$�S,���ܬ}�Ȅ���>�'w�3�H^�]3	v���*��T̆X�L��ƅKB���$�]�����~esݟ\������g�n���V��+~�ӡ�#�����|m�`׳�Y�r#96���h G��B3PH�䏳�����)��e(fY�2ݜ�}�	�hH�{� �2U������bnf�O�yT�,;y���j3��!���V2���� ��Ȓ߈��?IO��g�W��_ַ̄,
�5r8h�'4�k�)W��|;,�P7���@�+Aز�j�66�@���ZK�N9�0�oƧ�����h��ݿ�}��}ɀ�K	�I;+�}�u-ӆ�i�l������7�n+K�D�̯�콷�q�&g"��"@��d!'��؀$RK9�Y}CjV�U���g��E�;*kUFH�2�κm{#�]?n�B`�f�N��Hi�b�Zuj�㍋�5#�u3����a�x}��z?��l�b�z�|�X4�L�vP�'z-
l�`Dy�*E��H������x���f�Y<�	�Vǥ��+��q������Źd={ŒFa�=ớ�'��&�ͺ�,��ͦ����i�0_L�,�=j�q�az@�LE̥�t��*�rb�:���'�v7��{,:�e�+���o����g|�Q��LqtIǸj6󢾆�� #g�
�o�,��1���j�$@��i|5�����6�o�-�u�eY\,VY��@�uty_�bOp���|2�a�=P��Sa�t8���m�]N��8=���-❯���A��2�	8�P���ٕ��ȕB1t_��9��c�f��ӾsQ�;*�Ἐy���1yׯg�a}��C�d/3`�G<Q��c���Ǫ`�	��S�r �h�2�AP�K�������ah��!������Nr^G�'�A+m�ʹ�%�d�t�q��?4uP<�\	�CV`s}�S����L�x�2�An%��6�#���,��a��b��1[��PT1i=�E{ϔ�p������XL;�%��ϧ��(��X>&�&�,�|�́�:����V�xH��M(_X4�L�&�lQ	d��
紘Ě�a'v�з��Wb��3e�K�
�)D�7�	��]�i�cb3�z�j2�[U���N����~�ۯo;��2�;C}�ټ��qۅ��/��N��W�̑���PkR��&;�ۍ����l�V��(�X��͡��&96rf�Oq�<*�V�<�ѷ�+� y����]��0�G;�zS\�a#�|JB�Py�w�h\�*��ۙJqh�ɏ~�c�(��rl��wݳ�@�eT+������ٹ�;v�M���	O��ߖ��:��vrS\����X����ME���9:��p�įT+�f�C�Z^:��U>��LUX�Ò
�4�q�����/�W���m�AiǤd��_��9���d��v��o�TI����2�����=��$��L�]�\Z̰7���^P�wS�k��^�d[{��\�S,��#Z%��2���*����#����V�Wz�/k&H�p�9�E�̤�8S��|��{�Zi�n%���K=��׿N=��g@������N纴�e9�_R�/��'�f[�a6���n$�.�>-3�Rk�2�"Yh4>f$�a�/d|�)3�!���Ljcym��=����PaN�&����#z;StS@����fj�h�8.}��fr�YG���wyoplB�̉�������l�_��֌��2g
�]���ċ~�ɺ5]����}���t$|�Li��pd�ms1��Ȯ�8�>����}�I��o��b|��p�8�\<,�?�x�(<��Ҡ6c4�tԈ��={`�n���U�� 
�-t�LQ���bJ�AP����4@��e
��Qm;����P�\�WG���8����3����C�^�s��!��o�"�w�۾-2t���ʽ�����Y��'����*j�ב�A��&	��5�-��U{'�5GG%�n�ϯ/`��\�;�z���0����3��
l�1���5�xm�P�ұ�)�~�����۟}o��wl�lc�NE�xT�#Q���#ƹ �	bE��jz#��*���Ĝ`)j�Gxș��a�QQN/�\^�?������@���<�M��)/C,>�e�׿+�����/�--ˠ�A�J�����@��O�w���h�����S��`��%��qtLB��_\O;�c���u�06�b�{vu��]�B�$�K�a�ސK���� ����I��q���́m��Z��*.(ʩ��h �2��L�6	��ʠI��5�aEg�%=Csǖ��H�[A�QƆ~��k��]��:��+���ޛΊ�+�#lP�="���tk6���v1�HL@	��P$Yn_Dw �{؜��wrJ�8��'5�E�ƶ��!kYB:%>Y�
�D�LE �#����+zP<�ţ��Ƚ�~���a!w;_�'�K�.�g׷@����\�j��W���7�\�M,S߭�a���Q��n�	�#��̣᫁����6	�~i���%�o�+�c��gyf�i7���1��O?������SD��곭��㛯�y�x�;[M��3 ��@g�!+2m��XF�C֛��V��:�0km0v���(����-�tt�º�����eڂ��P��7�2��ΗH��#sc-��k���X���`�q�PD�`�IMpG�7����
Ћ�e4��I�A�F
��&B��)��q��*b�<�����:��]Ǹ�|w�ȱe�:�/r0�Znq�~dwT]�rQm�IS0�"�0���aszz:ܨNx���ַ�x�J�g�q؊V��V[[A�ʉ�B��uީ�`q� �<�e��u�r�1�9��G�p0�=��|��tN'� m��P�#+醁]V��G�.�v����O?����^��t1pD���(Ј�uV[{���G��,��V,BY�-?�	�"��^<�e��.5��d߃�o��ɒ�[N���Osv�4�Z��bć�)��$�����t�>�}�C���ƿ�9�� (�0����n��b���b#e5���Gл��
;yn�7����#��b'�����_�������	f�o��n�+3@,�C�߰l�p�	T��fW�J�M?��,���·^v�@�֢Kjѻb���JË��9��a����;�L���1-���y��%e��n��&,�c2�1i�E��4`Ki�?j�=F����t�v�k|.���K%N��Ų|N9�����.��e]�
�'[W06v��ʡ򅖖������������*��x�M�݊��b�OH�y\�� ��E'�Q ����\i?��%��l�N_ͪ��hFԡ�e���F� :=�_��'G�(}��wm&H�������6YHѓ��m�S*��QG�M��;
���_M/����U�㟿�����а��b�*��uP���S.�V@J l���:�R��l焊��R��W<N�@���<�g�zV�Վ���%<���{�b{�J_�'�G���<:�zB���c��j�CV��ҙ�.�O��dm� Aj� �Kq}e�R�;��d��o^Q�/'���i��]r偢�eE�j|�(�����o��n���)��
\}$[5���I� d�Vt������@    ��V�߀݇ރ�ՂǪb��j%U�^�U�S��qi�V��q��PJ�E��l���'#��Ӛ���;P;ِ$�F�ʺ:��&�	�yK[�Lu1�s&:Zd�B���M���wL굕��0Ǯ��2�-�>�-S촼Ѧ��!?v�0�������"��:��lg�@E�"�GG+́�/�n��`L��^%XV��Q��Z6�sobx08h�#��׷B�69�.�W��.��fd�K�A�L 8\��+��i����~7���� OAy�;�o:��;\���== ��z�B��)�!f�j��2��JE�,�h|?�'o�i^�}��TD���_m!DW�btv�b8)�]�M�h��c�ƍB|H��J�A�P��jg5�ʧ�[RZ����y���V�m�$@a�X�ʬ�ʽV;�9��!�]d��x⅖��Ϣ��<�<��fc��S� 3�b��ʒ��0��x���wP�A�"B��ݶwt�ms���橝|�}/}����yN3l���N�qI�$@�94�l��&�r,�exO���틸ވ�%9������g]6<�2p��.�W`4F/
�P������-�8��~�6�W�LlߕՆ����i��}��1 �����x橔)^�c�W�Lo�}@-�����wUA��o��1���.WR�6�źaI���_f��lU� ��,f��2�y��Z��γE��F��1�W76��kY�ǡ���d���l�	���alN���Y\->�Z��(�>Y.�� �X��:'��\G���f�*�$N�,(2��9���nGw�����Ʃjf���u�W��
����$X<
����&�U�"��w�K��ꍝ�i�(�ˎ�<�&�{֎���cvv<(&)|�@]�~^0=L=��υ��Q�|
��fg���l^���م���4�հ?s(�
@�~�~���;qf���21/�[�~��%�~����_�9B)�Ә�����?�W�!�n��>p��p��$�Te}=��6ǣ�-$Krt)����_c$��I9A��� ��Rs0�A�iz5����
�.��`({�\w<���H��x+�ݝu �$��|���X4Ԫeg)��ޯ��pc��-X[�����w��L��"�a:\BlKif��L���/&�:�UM�L�终�C;��M��TLс%

�U�]e�W���[�X<D�lq}�]�pD��Xki)�/Ji���������|rw	z�����F�:S\k2g�h�1��W;`�DV;��
�Z�q�s�h!���{ ��L���㊕f+�B��R5��fx���±�����қ�U!��fU���`�,��n]Z���j��(3��_m��nd>�pcUL��]%�w
�(x������XEt&Ni	�*��Ь�U��	����Y��'D��\P�C.L$�zo6�F=E��;��~�����=�(���י�m	��N&�3��.bx[�A��}9<8>lβ{$0�8;?���Y�ȳ|0��� �sh��ԲER�P����Ku������ow)y��)p��6x�T=�R�4�qvl�g�rQ<���ac�U	WK�p5{���*�
�M6}���$��[���A!�As �̭?�<V��
�4�i��jMsK��Mc�zf���Wd�LN ��&ΰG�ƞvbZ	
�`�]�S�VN�שK�~�H/�p�M��e��!x�SMa�y!�R���#�n��.�@��@=�'[�u����&h7�gOc3<�\���l���[��k�F&xB�<)��sb�����	s����&WN���������#��̆&���Üe��tיp\�P��a��W�Y�6�g��X���S�%X����";,?+�}�����	[3]���8���$�u�$L,�X���?��Oz����PĘ@D��Gch�pz�mI�)e
�գ^s:����)�s ����^ �}1�+��vP(�0����NFMߖ���9���F]0K�9)L8N�p��||^o�KvqM���
^G��������T�xr�eY�N�n��Kv!�8�:�mȡt���Ta�$�L�s�����n	�;�� ]@�IC�bqݩ
��^��|�y�1���A��䮾��í/��І��3�˼��V՜Ni��
��܆�4=;֬���~Q]����㰱ŵ˓U$΁ݲG�mQe�	WDk����Zh��σ��ƚ�"��Dn\�V�c��'�"'�袹"���ޗ%���	@��nA!� n:d zg�>��5�ff�5�ـ�I������}�-Q��S��fȏ��E7��ֽ(H�xut�1�H�K���>��ؾ��Z�/_�S�=���$����B��D��R��V��V:$��:U���Vܨd/'W�47c��"����=� �w���L�{��O(�&V!S>񻰽��\U�,ɉ��h��"� �-#h90�zy�L^�r�e��yL�r�l���Oi����|���Xā�,�H&a�g�M����M��i�a�3�r��c�[�g;,o�Pj��s�:,gc�Q$��o04����)�*�7�#������-�R�1�
�^_��¥(E�}����sW껙S>��N����*Q��h�f�|HFU=Z�%���\�Qx5��輊F�}K�$���7��qB>I'z[��FÇ��Z�ġ��D;�6� ���x)&�Q�r�e���L�eh�V��c��h��2z��k�F�g��:|���?����`SA����-��-��n%N7�T���#Ew��<5�]����2:V�D������k�r��´z"�*��,�lz�z�9K���F+宸�*��{�|t֤3z��~��]��&&U_k@/nWm|���Y�%���DF��&��AӠ�,ZV������Y@(,��(܂���� �x�cC�F\�@!M�kW�I�cW��2���%0>��Ӥ«O �I޳8�C���L%8�E��~�I�P6����r�C�U�w�L*|,�:�N����j��H/��aUע��Lr�-t�\х'G�.��31O
]O����J�xyg�����.���eW�1�=#W⣊_����P�9컦wza(�-�xPc0��x�-�H"��(���Rx�V$>���\YZ��7��p�@�}�G�H�c1�mS�he�Z�Ѡ�`_eIY�٪hހn�+b�6��%��f�B�<
M��=8��׷��_�%*�7J�Ɵ�:�O�Y`�FX�X���S��Ѩ�Zk��n0�˕��@|��<K+R�}�^�����fp2�鹅L��V������� �ly�@�����͡�mz��.)�� |q�^m�<���b7J����}�ZI{
�*b �pV�w����!��/q���+�<#01u!����)+�#�RA1$]-�*�#֋���=�Q�8(�¬�B��'S!↨h�B�0��,�������o��Ɠ��Х��p*�Ʒ��ߧ7�����tn�?�1?��I����J�GpiHm Ust���L�pr5��	�
>:@�5t�\��-�
������S䗫���|9�yT�/��}�1��y]y��sb�E)�C��O,�I�G�Z��%ᘢ��vz�<+�PB��X�F�k��yV�i��a����-����M.����D�/p�.�*;�_d,x
��l��#����re����u�Ԑ���.#5 i@��)nh��喲�!�*�&�\���I�;5�^H�3t=��,ګUT 
-_U��v;��p�ز$�P�������}��6$y�4�dz:3HR=ZT����f9�>��Q>8%o4����F�dX��pH�o V"+VR|�jV�&%��6Q�U�ǮB���7�C��O�~U��s��}\Fը���4SJgO�'�9�����5J�/ܞ�k&H��:���)��ޤ�不���~�90G��C����Ie�k�㪿�o�KaGi�!�z��:��9�<�Gk�q_R�	N�p�    �~�tۈ������f�7�C��<�.������_�_
��I������ێM���v@"*vCDe��+�R�VZ(�)��'�^lF!�Q/M�-%<�c�LJ����d������/��DW���@$G`d�󃖑���ZE��
8�,���F�PN��yv����5�.��BKS Ze�^n~�k����7t���GC�U�zJ͖��� j�0{��3�e�E�~<�~E���k�М0H|WG�"^�D> �x4��o�h-���y�6ʓsz��������Gab@�ۣe�Z����*��:W���G#eY>�rDWKL�<A�j�ߝ��4��8�@�Uyx��Q��J��*o�π��W�|3񸷢��/({T��`���v`����& H��4%��/\�o]�V�t[�<1]�Xܞmg�&:�#���11�J%�hEn5�nf�z�̤��l��C)ȣ�
c 
���r�����0�q��j��uXnެ�����/�&��x�jz�gu���1���[�XK䘡䊀;Y
���$)}y<Z�!R�˯*�@�Ȩ��#o���܁�Z^���-�o�o���o���?]K��IZ	.n#Dv�*>�L��S�
�!E�i��MLO��ka`C��]W���B�/�"b~�佟O�3�9u�5���h�2����V��r�£��BEni�����+t�_�bmޅ�	�l-ۊ�hÇhY'�m�P�\����9L�Ճ9�r	~�ݬ6N��?�,c�&V�uc1@�9���n��qE�vQ�'%uvue��x��N���hz9��"�[���0�1ݚ�\K����C�V������B����Ӄ��f4r"�}s��F����|q���I?����@\3��-9wf��L�de����E�򿴋V��b��c�7�>hW���� ���}���|�8+x4}\ջ׹�o'�f�TCn�1!���R�#�f㛻��m��,�����:��
���	Gt������'���p����A"q!A����3�-�5�0;�]M8֊��6gN�? ����7�%�op�.�^���Ɠ��s�׻������?gߤ�֡c�6|ͼ�-O�@���!�ra(�,-M��O�A���N�!���S���:��5�(:�*s3���a�:���`q�{!?������&zhQy� ��Ҩby3%c:�[J/�:t��wӛ7��m�TǴ�t�xM��b���:"!=$q�vʇ<|"#s[��@M��re�_{�G��͉bV��thDG���235�G��QP��r���8f�uD�n�L�9=> ��d.��=c���dj��R��'���n6r��5�@!�z=�bQD6))FkAX�f��T��p��<����ԗ�eC�FE/�i���+���T�ȉj�ٙ�<�<be��W���#�q��f�S
�Κ�#�PJ�V#VFbV���)�	�f9
)�Lei��10��Wݘ"��|j�֊�ߙؚ��1�W�`�]W��![P�)�JzE�(M..&��to��~9��Z�wո����we�Xw8 ����3]��=���E�g�����5K��kOL�f�}H�P������{�c��q��҃��Ns3�(@��%H��S���S�q����S�B�ө*�Aؾ*Ă��(Ďv �+�Y�y�$�J��KU������ڡ|��İ1RP �����Á,O�3����Ν6i��[�M��qOz�K�na�"���5� �����o�Ժ��]��1=mt��f�u� �������7�� � U��U��&��(�9)�<�&�k��O)O�� �6]J!3.2�$��g3#� %~{tz��b�lq���%hFڧ��dq���{S��M4.FZ3�i���
dS��M���V��э~��.�g"��)-��m�`(�6��?N��ӛ�9��=%����s*�Ɨ���K���3�k��h�/�O����+������\?��Li�D�5��Ll�������Av@|�X��@rX	����rK!���(|@s���
3�U�G�������'3�XG�]��W1��C�`����0h
��-�Ԋ��^��ȀX�)Ƈ��/���Cc��\��%�~:l�0s���7v�9��I�7�_lgڂM�`�)&>�b)�$���d#�l��I,f"F�\�S�y2X���h�����Sv�)>[p#U�>yS=/��t�ȍ�asN�*��O�?}��y3�v����&4@|�j�!#�6Ͱ����ix�g�K��&����Y�e_a;�$T��w������=�UU�7�ә�Ul�H��.=��z�G���W���Ɩ����ޣ�3"a;����кT^^� {��|� ����ɧ�C���l�7�{J�W����y$]6�ʌ����`4j��7��Y'=^��(��	�Z�.�:���v�����ׅLn#r����vVzo�?����6o�[}[�X��.R��3.�Rfăx�����\,zz����o�/l��'8<C�ė�wE�t^�?:o�MT����=�7����7��ˠ���no�.�k�=�Ǭ0��%�UT��J�aS�s�؟�;�)q�?6g��S��N5ss��(Pb
�S�/�+�Z���9<�jC�a]�uJE��}LWg�{����d��9��q5�gP �ϵ��X?���Q���1���U��=JA���z���G5��Ӻ���?���h^NT��jښ��DR.(&9��	�zPA���11���1it�{!
����{�?6栀Fq�G�]jc��UO��z���$ۋ2�q��%?����w��+�q�C�)�����z���}˙����}.N��V��].j��8���(��:SO�[S�p����q��	�/荮���T�����n��l�	�c]]����R|,�����.�1��F#0� ]_���9�l�!�I��A3:>y����d:[ge�u`xObwP�9�?�N��S�����������Bm��Ch#�2:��fƶ �8�7��5�@��?�?s��0�-���_�/&W�I��;�L�|v]�������H=í���C���0Z
���l⣟�4���w�P��u^~U=�^d�V�W�7��vƤ�%3�eR����!���B/��Fƀ�)b�D(�3�I8����������?������O�'i��:����ˎ��x_��Ƣ>E�%ڛ؟���t�<e��J혦E_��?p ��������&��3�\����g����e�0Ϸ���!9��1!) �;��܍@��C�Ɩ�r0n��( �n��U�F��N=}�_���8�7�C�;����p R������'����d,�2<*��oGruY��V9�zħ����n��Z��w{�Z�܏��w�G���ڒ͞^��
[[�z=��dW ����~3@ڿ]I1-��`��(�3^�'0�/����
ݾh��N�[]�a����}nw|[ 0�����C[���@�ܗ�o�lC�	��=RyǧX�3�IF�P�f�{B.�9���������2�����M2��Wϣ�uvz�E���Ơ5`�������3$��˫Y?֣>��YA�K�"ә!��+x��V��ˬA�`Ќ�Q�2~���M�[�Q_�
�˿C�]d)�6t�=�û�*��UI�RQ܌g�9���V�q2����tx؁�Qh����3x��ԖO��C(�I]<a�?/�+t���� ��PL��H����i��`zY�ٟ>.O��*o��
�3�d�P67[�f�R V��杚�s�޲�5dO��P�g3�~#1�|J�$"��O�cZ��q�%�Aq+����$�-��r&�b�����:[��`�Q@��a`,�L�`1���˨�*&����g�L����$
w!�P�f_�b!S��0��w�?�͉1/t�D0���9c��@<�^�W�iVzU�\���~�k�QT'{SC�'a��d�7�3���ZC��������L�~݃�_�&�<H�t\B��u1jپ� ��>��#�ng��    �e�̷rV(�༾e���ю7~�o���7�=R�Ҍ.� ������@\ػdٻD ���g�F��Re|
�l_�l��eƝ�����xd��.0�����M�׫e��gW?X"��*���&@!���+���\#ʞQ��Ϡ��bӿ��3U F�7��9�Y�ɟD<>1�����t)�%|��p��p��t)�$�찒b��u����ɯX��[W��)��j����.%��p\`+�asP���PE���@b��UZZ؊Q��IƁ���Oq@�Pm1�P�e�	�t���=�Lq�Ĵ����O�����R��\�>�^�@� �\|�~~S�xW~��}c�U�Y���R��Z@}֗I^��(�Ez?�J�{��h��e���BAr9���u�/�];?�9��.p�Q2���/��1Z�c��Z��Z�t,A�>]�K�����������,U�?0�F6�+�����|��q��P.Z�}�c��z2(���{��n1���u~���?:�s:�����>鼽��'7�+#���m~�<�����e�8�d�����C"Q��5��"�
i��P���b����^\ή�?xa6_�fZ�,E/��  @�ؗc2 �b�Qf�����l�H�c�M�/(G3@�A_��(y��pD�!���\ ���1�(bȫ7���o�pܫŃq��t�Qɇ�j��A���TR]����+)ő�Ek� �|?��.�+������4u���^T͜Ҵ��p_�ucd�����P��ri_1ULe�����6�r��xP
g��&P������f�3]��tH/���
���~�������]��7����}�Z(C��?/�w�_?�w��pT�XAc�ar!���Q��\.:�q_$�� +ok㈣��/����7���h��a�Y�8�H[#q�~`$���t�RX�#q�P%�u���V�K�K/��<�i��	Jf��؉���u0�"s���\R��N��q9�!z��'��4\�>k��i�8�|�s���#��b��HL�+���S�-!S�Ӆ�:S��&�����AQ�
 2E�tD��G >*��e��)s��xo�)�`5|��Db�t+�!G�L�=<0�T�gJ�}���tJ`�(��2+LϸaF(�=e�����?Zm�6�e@
� b,��tǔ��������zZ����j1�s�
6� �{K)o	>f�Т��X��E�XPfPV6�`T��&2O�I3�P�p�\���bg���fQ���3��m��H2��T�V����ّ�g����)&��x�
!�J͝Xp�|
��k�a�QY.N����ov�Õ�TT�PE���wz�;iNл����& w�I��1�PQ�u�7{��4i�VOoЮ���"��l'�բ�����D
��[����P�m��3 �6Y��	w�窑an:Ƅg��0���p{��D p��,�!E'�*��$(-�*>�=���RI�����}S�@�x
t՗n�H�Һy���3�ˇ*;���	�5��;r�@d7lѢ�n~0X~��0{0��
�M�k.ڱdH�fLi!�Cݗa_��(�
��r����Y���>�5�R_&�Rܙݙ9=Ix�PPgp��P��b9�����=�RVb��1��
;#��E�+ȧP��	=���O�@��U�`DcW�����*�E�R7!򺍞��	l�ɵ�mɱ储��HY��b8KO*�vbspPX:����ʊ��NpѨ�3&�7Pc�s�B�7��"z����X;#�������3��A���wR���&a��.���|1n��_f[_<�I��S~���0]�dDZ#�+���`�Nh�NKe������<y1�Ҋ�����u'����*q� mN1W�����QP�'R7��K"�%)N���q=�������EV�<|�@��d2�rȋ��#��X���؄���o"+���^ ����Md =3����]p�$�G��~�H��?�#�Tܕ��"�M1���S��a��=��xP|ɂ�#��Y����~�o7�㫻��Ŗ6	,��o�	��)'��bp����[h,0�
��}��ю	���ٓ�A�G^����vPɺ\|fj���*7����63QU�WJ�%�H���&n�o���` �*� =�b�����ᬆ�����r�3�ry� D�;r���c����UkU*��W�֣%�R,D��� Ҥ
?5����v���ܤP�4��,��}����c�U?�����+���%+�.
��a�6��k�����7\��ݪ��1�pu@O!����x婍���>Q���C6�.w��t���o.9EϥcM�~BP��3���N�:��� ���W�l&+�D�������L
pc��,:��v�*aG�b�~�UL�tZDLǠ�"�2aRͱ�BE�Xѵ	`�!��M
�!�&Z-?ĺ�!���A:kzg-q�ݗ����g�m�0&"�/��bc��.��֬��ۺ�F*%N�C��y�U߇b�Fԉ�*�w ��ã���?w;�\�,�}�Qu�l��C��y(���r�.��[Ϛ���,�e�3���˗\����󚶙����;X���:��ޠHq[
�s*fYЫˮ���wt�t�Df`%<����xW^a�?F׸|�Joݸ��/��\�^�/߬�p+{n�W�J����rcm�i֏~��T���T�]�ߝ��N�����2�-���s�w�~Q�gP�.з��-��.St�9Faj�>�Iv��y(C� �Vε+G7���istfv~,-�l�*��Ee>��fWS��G�X98<۾Y�r-��a�jS�j:�Aڰ�U���6�xT����ӂ����?���w, �m��4XQ`8�*�M�_���ʧ?i�(��<���ha�eP��ᆞ�r�)�������d�9,�_(����}9��w��/.Z��G��\=���~���<8�k����5x��7jfJFp�a���4�v<���B䧔�r�ꅬ�vѶ�z #����? ��)�0<:)+X�'��+Ϭ��q���̧_&7��E��C������l��+Y�zV�!�ӈH�9�8z�_<<�U>;��N"�<G����^�@<�G4@ ¦g�/j�&�W��ja-�W<��@2PI'�E���6/�Wh�tK��?Xg����
E�/ݵ�<<J�8g�C�X%w�b�T��T*����)ԯ�@�40�U<O��<c���TV�`7&8�U�b1��kT��vq�m���nᜓO��GE��d��t)B���\$��ny���ʞO�<�+s�RQʝ�C���Y)%Ue�5�#G�O�0�^�����������w�m�PL];3EyƋ	g*�	a��Ɣ�f�����o��Ms$��sk@>�m�Y�2ٛ�e�@HyԸt�Z��br ٬IF��P���9|r��	�.��
C�d~E���E}�~[���1�#<��y�x(��:�mEX�W5b��ðq�����y���nm�僷����
 ԥ���$�lTIQ���Ts`wd*t�@-jQ���������m�� ������6��v��GD�>��n�ң=̧��G���M:����S�6���>����L�|�1�ʡ���5X�<;�g�c֤Dm�>��,$KH�����,��N693{���V�m�wq-��r2hrmz=7�~�)���t�YM9A�	T�Vqa��N�'�fx�w�O �9T�5�����ڏȶHZ����Y��E䩠��?)��Y�k)ǽa^j��tk��M��
�-���	�v�%.#XK ���Ǿ6r�)}r}�P<�E��e�x+��/��5O��+x\79�Ç,
�O���̌��4eE����J�h�i�c��o������	|o��{�[F���ke� U)X�^��|l���ZW��ofu��<n0��yK�ޛ�CC~q�y���]q�B׍����P���X�t��&�c��Q���Rx��ږ�o��Z�x+���|q}3�k�Fz��F��Lg�i'~    PK�hVխ�����X8.W�KD�� ��>��5"��Վ�U��)I}�	͇�2��>������)G��E��
�⨜����&��ӧ	��3\Iw:�z��N�{f��|�R�*z'��2��JB7��}:��x�R��\)��!��M�G!.0Y{��
<���zɠ�!\�Y��}8��e��J�2|=ϼ��:�P�⥅���sńF��4d.�]������'&�F���SU�Z�d_�v6�z��_�
W�3�uF��~�r�d'�rJ)uz�)��>����>.�'Kd�?��h����0i��9-����G̾��Sj	�$��@<�w�skG���rt�sE4Bձ����K9��W8 L����!`A�!jb��5��;yeKY��^��CDC��pRNDNA��̩wDS'�Jm���)���a� ��8�ɦ �ݶ5;Ɵ�lF�R
� ��8�2o��9	�E?]���R��Գ-��x��V��^2�����5��.��mrۯ$$T�gL�Jõ�J�E��Vy�B���� �9_<\lv|�7ޏ`�v���B��4�+~��
C�'>A��y���r�ES��=J��*Q��Y�d�·����|��PN�a>:��C͠p��ס���s0�O������FCm ��ܨ8���Պ_Oj�c�G��n<����G4>�'��zf�]Kl�;v�9K[a���7�4�_<����M��ǽX_4>(�t t��x0"�����VZτ8���4�ђ��V�'�0T�ADܟ���ŗ:��O��S��F�iW$X���2)�����l��1e�>�N�R
�b�
ڮ�l+2s0،YшVKhG�SQգKZ��~�P��K#��t<%��d�J��ئ�V�rL�8�Vr�w�Iދ�y�n_��5���/�x�I
g=�1͡�0p��=cU���cYX0����w��aE��~���u|�eu�{KG�+4蹄���9�j�C�Jo.��v��݀NtG�$q�*i�C[.��y��|qu�x��8T���U�?�_��4M�睦�̈́��m=V��v�ytb�(`~D,�\�F� I��E
���`�Mtn��&�8^G/&$��E3�~�%���<�y��&vE4gB!�PT��!G���)������ʏ����Y��GF"����n�E��E�wӈ�=(f� M!���^pz��>��5��c�-��iX�&�^�~1�B�����k$��f���;�P&ٲb��'���nGf�V�G���h脥Vx45��J�;������&��K&Q�R.����d�xvsN���d	bc����X#�I����ޢE'ǀz8���xG�"9��VQ���r����v��_-C���V�6]t #_+��$Y�}�¹a)����ť�3:�t�n·�(�f��9�Y�HG6�`/3z�5�Q�[��%@)�6����HFyP����[(���z�Z����F���o;����h�0�����1I�׸�"�����z>��: t�7�Ѭe�\��#/i��sx��jf��,|:9�Ȍ�I�~i��Ҧ�%_�(.��>�:,5,Q�	��^}'4K�R0��-��(C���E����8��jn�Xk��AH*��B�d��N��@"���]�ew��ϳ B��^�=�7�����cE���l���[D�q�"�� &oC�W�%��H�NN���0����u/n$��o���˲���h�V�(_���1����2x֡aq\:_=����o�xEYd(A���(�E.��c�aM`&����`4pz?|��j���
��6tUB�����b]��������p�7����Z	��%-�ы�0���K`*p��>�730�J�����[�q)A��Z\��~�D�k�q�}���z���ˊ�}�!�Zz"�h�����|�cЮ�[>5hkĢ1)Z�<q�@�y��_ j4X\�w��^�Jy��oA��ŀ!/��� N����� �7EI���{&<�^! 8ߌ)֤'��z�u�nd8��b��X"��������{������R���������o��%��#f&�|�c�}�"�CX����3���1�&�D�:I�n<elv���6�Ͻ��mk)}��)������]Q�����%.���paW!;��i�2y8~CҞ M�D�x^^~@�tY ���ok)�IP�f�e� Zy����mp�۬(�æ78�s㿏o0���':61l?|�G���L��)��P���8XLQ}�������7<�ע�~��j>�.6�.�Y�������$RʘP�Ы������9x��!3���x9��/�1�m��E�ztg������m� ��^�p}[�1E��o�����l
V��[��F+��ca���б�H�fo��v��a�y��C�x��~}`7�6���[�J	",�"@�YQ�g,$X�����n;;�s�={fz��1]~z'sɳ�ǫw�C��<��1�Ϻ{4��Қ}�W�eF
��u�D�;*K2CNz���]���!�h2;F0�GT�ca IsoI��N��4�_���CR=ڪ�LȐ}�`iA�'HF1Q�����L��'���4�t!�h"��W��Хʡ}�5��'[��v��a:�K�{D# V*dR5�� ��M*@�) ���K��룮��� q�T�8���:��M)ܘ^�J���m�]�ήfz���4֔�"˹��Z=c	YB5H���"6D@��3\^^w�1��3o:<a�V~�-�LܱA?V�pz�})�і����l���I_u���<�u#a#���j�ɄB����}��；�r��L�-��2��l���yT1�%����lD�>V-�-#2�Z���������C�='�(Z��̘�#M����Jn=s����?sv�P��U/&�R9�v�c�D����k��#��e����-�t8���-
���hQYL�ӥ+�T�R��l��U�����:��Q扃�����l����`SÕ��s� �G�|�q&�Cp�?�MF�|'gJ'<_�D_(��"�N	�5����ؽ�#�o�]oej���TUL���ng�R��O�6�+�J"d���L�?3�Fm�p��8�~�����O�ko��Z��$��X���h����R|�`y�S�/�Eć��T� ����rm���2FBD#����*���Fc��;=�?aAڨ���y��Ţ�u(ʠ9�A-�p%P���l�އy�~�4i��^'�g�у!v�շ��OQq��j]�+G�*��V����ɧ
Z�ia�mv��t����6ǣ�F	P�F�e�>.��>~o�6����jvͩ�|֮�n�3{�q�K^��q;��v�ٷK;�Pʑ�.��d�Td�x�Q��������,�#�Tx �O�z��A�W�S+Zg�!�e4&=Q+̉&��MW�ƺ ���M6�X2Ȱ*vBş�u��l[��z����1��?�u��	���*?�R�ޝ"����������wNK��<��w4
������P�g@�Ps(�2��q�?6#s,���������P���?L?�l��\_@��Z�R�a���Z]�F�)��[Uiٝ��� ̀ӭa(<�[N�P��7���(�W<� cfp��,��EW�ޙ����{����K�4X��j&ce�B_s���~B��Y��H��5X����#z����aYfa:��&\���	�X�ĳ�D��\� ~H��)�*���F	Uz��1� �|+&(�6��OqH/F����՗uF�:}o���d���񒻚\�j�� ������k2�'�(�{���ד�#b��2]�`0�F��W&p��_=r�����.�g�δ��wE�䴟msfOߔ3թ�jWg�#T�ɧ���+_m�l(���� �0��i�g۫����˃1��oK�C��*�*�k�R)��7q�3dT99�qOn;o���q7Pͱ�����<zQ��M����Ͱ9���p8����    �����Z3Y�S���Zhy��*L1�#��F�YJ&��@�.�9~�0Q^6�'h^��ĳ�}�C��oD0�����o�T��̊�S�O*�/i�f�]��2�
����ww'@3�MP����2~���B�W�5�9x)J�E[�K��
�EE]k+���~�O6$�c!/�D���9-�q�܄ft4�~a_Z�f}E�, ��cF��tl�F�T��JQ?�� %�;M�BU���a�_b,�$B���Xx��Z@G8rI���ŻB;[�_!z��jv1����o����|���ͅ��:������ ���t2\P!�0�,�c���RGץ�ɚ�	��Lk�����O`-��"�� ���q^�A�La�?���
T{��/2O��e�fS�Fd���˦f��������E[A�|��Q��K�[Y����E��i�B_dd���0�ʈ�=)��5hP>vY1}�AY��M��3�Fd'�\��qH���o]F���(Δ&�1�V�;��o��)���� ��#&v�����jr��Sngw\�c�3�˔�w��2P�,�*%������.���D���9��hP���<���R&O�����;o�`Ժ�6�����ÜQB[ �Z+��v��P��{����N-D�'�=G����2��A.���C�_{�`�&:��E�?���Y��,2J�b"=�ِ�����wibd�.�#,�[�����2%��q91p路�s��֒c�M��W���e��,�{1}1 ��8�&�k�N<V�RN������-\�HH�c\yE1��u<?�F��������~z�}{�g�?H۲�pu�ަ��{mN�����vG�Y��PrC' ��z��ё�UQ���q5��w�@x���_�N���(���~k�C˿��a���]{�q���z�ZS�YK��3�s�s�ȟ@A�����ǚ;)_��Θ9JJT� t@q[?e�� z]�L�����#�QJt�K�|��Il�bˠq=�]���.8�o>�X��1�F����a�Y�#b�+��a���h��;/��L� $7��g�@���r4��֡s����Z����<a����t4 )VY��M.<�F�T&������~s�����U=s6�.��t�M-S����D����W��/��~)����YD����f3���ϱ���;�g\�F��t�nB̵��tC����o$dL��(�*�OP	�0��XF�q�˭ǖ��z�a�`Ow޾Y���unL3.���t,#�s��q�N�������Y�pG���e�1��yx��x��>8����C�[���2��c��_����mI�DD�t��/y~�XY(�-�0��ɡ��Qh��#��kL��a��Y����~yi�̢��pz�<,��`:���^�M�������;hF�{7���[\1}���u`P%�TP��e�^+�o��+=����JO
�)q7�c��״8��EU�A%ᔜ�ź��\� ia��4������W�-��䚿�ڗ��$� �Wq�	@.m|����N�c*t��5f����vvIQ��J�#��Φ���b�%���"����O�%_@�"�<X��r�����M8��z;L�j��ɧOsv��x��S�����qs�oxZ߮Mi��x��ye��\aߙ��K}N2�Z��I�&e/�Z�]!]�k�b�L �~8_(��~Jh?D;I1��)T�Ną��<@�4h5D���x*9�f�U!H��P`�L��G�aȬ�������<����u7��T(���c�1�\�Z&��-�w�M^%�6;�[�6����m�#��3�ɕ%�4@�G/�aT(�G��g�s���I�8Yو�P�gןfE�O���o�n�E��,ܠ�vH0tB����%�Xv������p��BށaQX�@'+KA��,�Y���0���1*�+e4~vf�˼���Y�;.ok՝���-�s��WW�tt� Nō:*��t)��͙f:"�2���,Ֆ�`z���oV����Ӗ\Bs.��P����"�$ZP%i�{����z�g�m�0ޯ;�a��9��mXݫ]�b�/ � ,��2r���W� #=�v��d�q�l'������^�G�<˘A6M�?샩
;�]�_wc�AX�(c;͞@)\s.`�o�Bf�Y��QP:�OX����F��h��6I~���-����N	�T���uc�v�=�.8]��������Y�"9�t4	��T&��w��SN2x~�,�b�;�<������5E	5��{
EK+����ytE3&o�g�S�[ʄ<Z0���Ap̬�qA}YEu��ۊ�ra��g3/܆�����[E��My:k0��s����v�ci"8���_��?9�'�&3R8y.M��2�P%��F�K�d�mTȓ�}�ފ3+`xq��t2�\� &� ��������7_8|����vZ5o)����>HkK'æ��[���I#�}NjP�Me6��2�F9�ʥ�4Y̧���sU��9jwo����c�?��X5�lJ7ͺᬅ�RG@(3T����C[E���~�5g-����d~��d�.��JG쏟��.�U��o.권���M���;_��2c�1ޅr<<޻~��k�i؛ޜO^�x<�`��W!��AmB]�a��D�G2����3�h���4����ˀ@F^z]&�0럋��`��%�S����4��{�>f7my�Yz�x�6Q�}����&�$�04�P�Me��8�v�������<�����~u�u�$�G�<
��`�+*��L�c���U*r8����L]���~AWЊ$�����.tf8�e��&�GS�Ƨ�B�Wր�?���&�_�H�Q�aӌ�8�C�5�
<�Qi�Ë6��nzK�x�Ԃxp��/�HyQ�ɸ]T`S��e��"Xv���`!y�d�4aȌt��V��܍)á��׶��qq�X��)��\?�'��e^];���L�[�8�L7G,�O1I��x&�2h��^q��M����C~G��Zo��d�5��-�d�C6����7�]�'n7���Z�)f�j��?�<�D[/X�GG���zG����� �h<�(�2��=eI���H̋��pA���
n������(�&[��@�_e�r(Tg+�-[�VE�;��5d�e 9jũ�8�x�.�dC�`}��c'��BG� �x�OU�d[_|������'�hE�I�48#�L�t�����^�b>;���Y�~����1������p�s���f������zǣ��v��Nq`n@����l�����v�`�!}���}r9�_.�$����9�z��}�I�����9��� �v�y��8*����!0��x����]9+VQE�臻���Q�ԣ��R�]�g*���1/w��x��@lԬ~�9A�]ס�u�e7�:�k���~
d������Sex߁JF�գ���Qv���sX��>����S�����S��کb�r��_q�!W+r�)�X4Fp�z'r����P��/�5�;o�
/��v0�e�/2*�ɹv�)ߠ���L�ؔ/�5�.�N�]�w��:M1�`���� [T�\3��c������������U�o�I�(�	�����x��
�8���'p�r3�aK����#��I��8(��N �(�2�Q�5
�]y�<=ϻ}� ��6��	��+���� 0Y��=����p�i��NYz��R$�@�n����C3�Q%�����n�|�]{���$���9`�]�>3����� �[R�)�H��<���y�	�nfR�(�"d���a~���]|��tK	��0��p7����^#���bs4l��$�����[�J:Y����!��r�p8�j=@ʁ�SC�<!�dR�3�$f��I�-��~�� ��R9�v�G�ӣێ.�4ه�Ņh���ԟw^W�`�bhcΌ:G�H�rZ�>*�U)zk��O�{\!/ �����M^J�U�;V�ȦL?-0���y;�&_�E��]�����nc��HaaP��ͨ3N�m��J��0�-zR    �Mvg/bަ%]7�D�k T���������*i�����K)�;2�jƀ���	./vf@%3,h�݋��.�oܖ���A|�B��r9�]?.��y|ۭ�䴣��[T�S�ǖ�b����`�	���������s�3����G2�bzݎ:�@%_셢�W�.m;�T0 /�U\������N�7�MPt���� ����j}�*c��*�k��է7�q痊V�����銼$� �LXOdp�<0#+��h��^/�A�#�7�O�D �� ���|y��WG���9z�~�g#�'���L���@VyD�l,�1i̤�6��k$�����|��#b��(Y�=����*pU$tV)Tΐ�Q��2fg���bE9@q�����#r���.Ӄ�_1(����r��9b�A:@�Ĵl-���h�&�XZWʨ�� drWƱl"b�7�'����??�kn��f(s^p�}���*�7�nz�_�:L�=�)l(�rZ����&���SB���~�|]�&���h������Qpe4g9Ɨ�R�{w�����kf4� E!A�����.�vYk
�\�ni�lk7Nq3(f�V�I]0XU��������0�2�ɬ�=��Ϳ*M�7��PD��-��,>_ήfT�(�/��M��;N���/��k�G�!֓QoMe��̶���|��t���l�>�8�����(�M<���]$ʭ��ړ�1
�-�آ]V��z[��iGY�d�7xw��Ȩ��2f:�\#&�{�5X��Pd�/��L��蜷��X��w��ϯ�����EK���R.a���<["n�������/�Ѕ���6̄�(S�0��T̈́
��ɣd&7i3J� �FQ`�S��L�y�~�C_�R��_y*y�6�2��T���\k<ȅdE�7��q������m�V����"�J˷�+(���X�3����f�L�8�C⋁�p�B��.�s���u�E��*z��Stb)�@0��,�fJ�����P�,��ˈFx^[��/q����H�d3e�T�a!���S���ٹ���B����N��� -Pʼ0�9��<�F`�4�D�a�Dc�xG����*�q)ʞ�m��_����yc�������pИA.�h���r�����?���Y�`�~1���!mi������;�S�B
M��Ŕ>XW�܌^��7� p|3-!DX�lUf['�� �hJAB_���\S;�qQ��p��g��oǟ��2��bg������N"`Y� O�����d�zK��X���{������~㑼���#y����Uv��+ɐ[�?���;ȥ���j���?^�.s�A��vx�y�5e�S��O��
!8�ci�{���A��N�9;*�ԏ�����|�����r�߂��s��o��##@�)R
�] ϡ���rJ��uG{l��R(�����#����Ub�߮&k��'��ʳ;���O�'t��9��Fߋ^���P��
�aT��I��F�#;KYj)���Xdg��b����S��p=�����I'Oۨ��ͼ�*�/4���L2tA��b!s�g�	S���nX]L��^�Ԅ�	�a�`bIP��%FkLB ��)H�G��C�_��C{)@��T��(G�\��Q��W����V�1N�����P+�\���RcAۓ��HӶV�����6��2[J;ϨM�o(/%դ��f#�J(�j�4b��b����Z��̈́I.Xh0�����d��El6�RЪ�e�{��	�]�3P&�Mt��h?,Z����8�3J�Y�Q������8���2չ� %�\g�Y`OWsKq�+���������ET s}��G�lD/{�}�k��@�����ʢ����Md���,Ek��sX�&& ��q?댦Pݸ��ܳ4�E�PA`2G�g����<���`�P$�]JM�/��Ԃ)t�+����,���D����	�C_�w���/a9+�����g��e.*�0=ڂc�,�ޯ���QcN���ֿĮ̇�C�<��2
���/d>�N$G�A���:����@�_9M�ȩoFg�<���xB1���r�v樜2S�е�E�45����������5��~�ο!=Z\����n� E��~�х2���WXԟ�U����F�VFpr�ͤ%�V�����e����"�W	�oܣA7W: �G� �:�7���	��9��׳�='ePLE����s׶�F�e���лlu�/�f�a\���*p�5/¨l�� �ǟ4�1?6g�8�"epJ�=m�INFF�[�OY�t���LQ�j{���6������CO�����,�;J�)���t����,頥eQ��v�(�DT���_�
ñ���m{S�ZO��Zh�g�<�0�z$7�2�[�����3.�mI�a�S��8�<%��H�UTJ#(��_�BTG�+:���Z���߻���A��߱d���>z�Yכx�+�D��Ŝ;���Ь��_ϗ���@	q���G��/��KJ��\��gaO�D��o��s<U�vv̆�'��Jmǔ�,� ��=�2n�2��?�@� ��A�|8�fd}4�D�(��m0S�Ɩ���x"q�~� 3ePZ�����
�>�b�W{W� �a�|`'�`�2cR��d�d�*+N�̌��!��v�!�	b�捋�e��ph���&��!-?.ђaB&:��_,X�+�6f������n`�����]�#�i��hK�D��O�7C��#`6����(+_^�4X(
�r��� lt���0Tq�*ƒ� Wc��L�CFXP�T凊��]i������(�{�u�{��.n*�=����o�����"H��.g��T�θ��C�9��1��h��>^H�9Z��{(2�>����{;���/�M���ճ�Ɍl����by~3߁C�?3��h��'dc��`�`�N����A����OF�y�����U��!����d������<����i\r��;Js��Dl���M3=mt��4�r(�I�%�V�H�!�BK|�D%Za����4��S�E*���*��N�˲o����ã��mh�+���)���\V�&k�q0aƊ�}$7���Z�޶�8��J�\�Sf�N�sj�BN��c�_�-�C��+'���{��~���0��Մ��:�!����L��l�D��2�
��"�����7W����Q'}��g���,m�ie����!�\���M)Er��Q��|��]
B	O��w�T����������~��`�[�V��5 FK��� ; � ���G��;��R�^$M)�Tf������Qr����"�B�nyJ�Y�Gx~x�Kr#���g^�����/��˛����ӖW��쀺��ب���h�1q��h}�u�5y��u3p ڂ'K�1Ѩ�=&&�k�,uk�ObbV�2ʲ��eiݽ|�C��`ֈ6��H��x�p��ˮN	�ꠔ-�F��2���<޾u���Ϟ��<����pc���m�"��,�"���-����q*T7�<���*W�,�)�7<>�}�Ew8�Zay�{���)-�����i�f�WqG״�зA�	��,�@�`��eWJ�S��A���ܔᛟ� ��﹡dݴx5'">i���<�mr�Z�12͉̍�f�@*8̪Pb1�%pWVCC��}�<�h��]�{vu�V_vB��9����
���<�! A�*BS�8�V$�<�&#��׳O�3a�����y�|��zxܺڶl�0�*��Y���6���]�zׄ �!���T���$�~�j2H�����;�Rl�q��B���,����\r�D���-����xf�ho�f]�a��}
x�O�ݽ\^�y
�^�.=Y~���&�`�8�(�T%��4�r�����[AX��b��2Ρ��1C���\I�@hT0-U��S,�)�5�?��������:V�7oEz`S�m�	�K�XX�,����K�A�&�W��^�Њ���?�͐0,�    i�S�첯�$�����y�L�����39��F�o2td�n�Hj���(�+x}��Ά�X�)�a ���0�*�M�gj�Ja6e1T�{��o��՜>�d~}���┼y�\�ً�?��g��f���&P\��{�`$���AOY��7#�hi�w���k
�p��V`�d��_-�><�����&�̡ݿ�*-Bt�0��xw���(��(}t\f�ŗC�
V���/
%C@U4'��1��-e�jE��R>3��)N:�`�g<E��$���6B�u0J�8�cL���||��谇�Q�MI+��!T:�eri�ͣ\���(*�J(�Aڂ�W�i���fBW�y�?�/z�'/~�^�>y�+#���w��Ub�Mr����˅�Mp�ȗX�����S���PƼS���+�i��.�wO�S�D`^]�V��k)��E������gl����z�?�|'����7ϣ局�u��p���rg�I���dFu�Ͱ�*(	l2��,�j2�C�H�Ω={���`V���:�5�ն�,M����Ocv >�|r���h��:��6۳0Q��b��9��Q³�%���d(�D�Q�ȅ�ׄ�-��xܷ�@�aLḁ�CO0�Z8PdsU�P{G��U�3t��ܘI�����v[#���jk�ݶ5�X$f�Sjζ!�D�o(�b��DFRYl�8+����j�E�]+�U�8�I�;�XW��m��
UQvvgC��}Χ���Ӑ��K��Z�]+`2�ݍOh���j�Mvc�f2����-C;���=��ؾ��Z�K�(�	|'�]���?��t�����j?���B�Jk�Ŏ���� y��'J`Ur�p���V:��&*�<F���veQ�X��0���Y�(ҕ�(R��%Z��?�:�8�����f8.����2'�c�n���",I��)�n��Y*~�).�C��2ό���q�So�Eq��+c���}�ۄ��٢0Vo��V������M�[����0d�pP�t�"�&��J�2N��!Fu>Ua�'I�-��^3�]�ї�:0�|8�]���������������������/����Bs��%�0�Q��G���*���3�ӝ�F��6����vI��y�j�mPî�\���d�?v��`�c�|�ȉ�
�q=$'���o���/�� W=�N$��~�y`��]h�m �K[�6 k	tx��<(���kd�s+�X�<���"x�.�h�鯞��zZԞ�F��_�>�/������ys|���L�yڡ4�)�A��!��Znf��&cA�98��x:�}p>�s�6`��0Ѫ��xLK�CB�1˴� �/��ߣ�]��y�G��zP2ɦY��r��K[����U�N��*z��W���[-KX$���R���<���:��]���H]c���+�����}����<_�5����o7�`��V��T~�x�4��8��$Q*Vȋ����?���6E���e1Y���ӝtHT;�|h:s�6�aK9zfH��sn1���4�q' \�S�^���)�4���:!ebIj�#ܸ�T�/>���z~�{������˙P+��	C��鮉�Q��=���C����G�&�y ��
?/�ݨ쬈z�:Ol�
�#�������5e��K�;�ێ���]���R�������E�ӨN�Q��+Q�N�LEĩ$� �F���h�6؛��ܷ�^�@��j�y^F��/�@�]���[��p
s�󔯹�o�G|�s{�?�W�LYĮ��G�A�ʋH~T�@��
�ٱ�8'���>�'Ќ���a�Fl-W�XK$�k�j�g ��d�n�G���7ݚAW,���{� z�+I!Ԝ"h����3������7������471b����#6��m��[��(��ъ�G�p��5�:��Y�-�ۑ��gI�[d05BZ�����k�;��X�[�� d��l�K������i�  �TV�6�D��	�-�N�/N{ ��U2BNn]tz~J�%���F�<�m��u��Z�b��@^��o$l�Je�R8�XAZ��S��{UE����h(u��ŗo �s�ǦU�ް�jI����z�&�Y$����::���ȟ�����x�C�V���Ԕ��F<���L�>h�ʩ 7�n��b���|
�{�@#(�~��ȅ��iC��������	�Ѿ1��h&4ߓ�>���MG�'vn��E���_��F�Bccz*�}Jd�t<�[�٧f:�O��y�̐��	5�^�3�6�%+!}^Qj6�U(��T����Mr�&ōkø���o��E�2�tQT�سW: �S>S*���QM?~�Υ<��Q���e�F�-��ܠA�fN&���1�%`�C��^�,(��A����ݨPE�m4~�3��3H�X�!��(�,�f� �@��7ذ;pՓ�m�~��j1z�_�.�7V�?�hL��LZ�e殉i�F!����M�����>���S�N���l��۴���g���}=m*�.����K98��13�#�s
�Fqy&�q���`e��?��L
�j�����*���;|���7!wm��P��B�9	 �4�of�T�̿&#������Bv��b @Cy�C5Ty��PM1d�`h�we���K�[+QupװAl��+uk�e�$$٬C���^�t�qT�1h���/�]��R���C��ߵ⚦�xCK����^<v���m Up��})�,��@9��j���U���u�J��KB7rPk~+A2��-g����A?ĵ\�/�v�� �
�6bn`+ 
Wk��r~�-ŢE�*��T�.&�g������݌~�7[�:�\���L�UT�d��M$(�"Bq&���ε�5�[0O�����1gG�2gGw3����Ơ��Ҙ|L�BX�'�B�(���(��a+1Y��l�a@�8�bS�*���ʂB>�ǣ�����F�6��xV�-�]�/C�����Vb��L~��� ���h��*�=󜭛e5�t~?=��V=�M��"�`��gԼ�Y�A�H�T*k�s�m�ߺ]�	�`jc3&;�U��6�/�TMmX�ۺ�	Q���a�- `*���wN��~�~<���k_b�߀�O��� ��� eJuRw�ITe���W���^*j����p�N���%�ѐÇ��!�4�CF(�Kr��K��=�"e�B�!��֢�u���괩몂L��0������Cm!!^�ἦ�5�����2�x~.~:-c����4l�Xp�??���l N$����wr��\�'�ؔݡC������kU��"����i�\��{��������(@z{g�}q���ʲ���']��\�Y9Z��Y�.g��/��Y_*nc���B��G������T���e�й�!�m���3���bh��U�0���k$�7�H�6ķ��6��X�S�ս��,��JO�>u0[�?��N)�rH3�D�<��� ���n7���R5����AV ����F�5��vkQ�Y!�.NL�n\&��X^|��6���v�a7_-a�*��\
l_g �(C�)s���7������ď��)�[y���x���\g�Z�G���V5����M����0�گ��J'��-7���S�H5��E���y"�-��o��<�x5[Aw�60���h,��S���Z�f@�K$4�����m	�yW����j�L������f�68*��	����Q4����[Ct�Y�!��-��̮ځnUn��cُ����rW�����iil�X_49lm���;*�e��D�I��6��|΍�2r᱆��_���7��kD.��S��i$Pk(KP�~��C��6���0f��V��̳:+m6��h"�lR�e;��C+X����7�����ՙ�6��>)C�bhȶ��\���8����[2'�p���s�m�u�c�B�C�M�Y+bme	��v�pt@%ӯX-nr6�kt
&%�����    ��#T�|��h�Q 1{����w2���p	]��廯k��+��J�^�D[���2���q�X`�x�c�.V��D��wZ��i�|�i~9��}���e�.��`? ˌ��F��G7��*|t@��mBSod����MڵS��f���a#�T�?�q��Z��G��6�d�q
ݢ(7Z@Χp4ҋ�*��}���*Y��SJ����⬏~��?�>����Ӣ�F��J��x��E;"�
 ��Q���q������ֈ����m��C�r�dlf5�LYj;�����=���,RL+��/=�L���N�O�mk����O����>�D\�v����zy�{uJN|�Q��x��7�sڠ��;���MD#B�	]�9�:��)��4uI����Q�L�g�+6�K� �S�2�ޑ��˫�=���jm��n�_\4�x����]=�LR����znDxĭD�ǂ��<!��a�� �5B���=����,�g��3k���T,t��c�\3+r���$�#���"��C�p~��.Hh%�L.���m�*Ҹ�Nl�e�g�sv�?>"tj�-�R�a�m�ӡ�m�J�c�E� �	�8��טV������|��-��� H.8�/�yH(l݈h���!�w��MU�'�pH�����a��4c0�U�%�1��Q�[�h��O�Њ�WlH� ��9��:&�OVE�φU��2�>(*���6&��猯x�r�����
�����}��q��)�L����\X����e��{�5�9��{�%V�&����R���tZad�c	 �CNA���RĖ���eP���d�(�1���zUÃa0Vd*��V����,�9�(��
�l�תr4=�^��j���ly��5|�Q�U�i�N\�|rl'r{�-f;)SY�t�P0���`������/.��.����s}�����7�ojr��4�_����<:"������#�@���+ep�K��� I9�Ρ͉Y�{L����?��G���/loBv�&_z��f����s�2��|��=5�(������E�a��2-𘯫��
'��v����R*4��p�Yf���c��-��G7Zל,#�<q6۞����������弡��_���r+z��m:�9X޳Ɖ��L�'���'5�̃ /�e�k�o#��'7M�
Cy��y�2۴`%��6M�:�"�����!�����txQJ	� :Z�zo���]\���
������ݝ7��=OW~>�L���Av���s�l����� ��}V�q�'���r(�r��7o�G2������fb��/�K �a� &�:S���Y&LB���E�
V�[���C�C0��/IT+U_ҹ����I��u�F����6�aH+�c�ݫ�T|�����]Y��p�)J���uv��I:"'r����8�_Rjq5]My��-M�M=s?#�8>�i�!��@螋�TS7p�ʫ���ﴫ���]��<\���8]0i�0�C���E�t?����Z�RE�M	�,`ޚ�VC���)Y�vr�C6'wx��Ҭ*KVT�Y��i�~Y��ܚZ�><���{�Q΄{�Q��j�t" %����J�^�Z��)�$0R�L�x�Y�;��0AİR��8MQWWmE�[F����I�n=�K����X�m�X�U�ZD�"M����o�Ѥ�N��,��zyv��F?�jqq�X�w����o�צ�T��W�e�=�~��)E단�%O���6L��4/��c�w���Eq�j��K2�C�R��j1W���b�*X��T�m7ı��g{�\�.�_�1{ܕ��B:,���
s=�8&]/�Q���J�Bt*�+����=�%��ʽ�d���@��:	�#Eƚ�����GkVrhp5�6�+�r�l�cpO��'�bEW�^_���v��t=ى�v���d\�Y��5�_�Ow�b���g|�kn�NQ���73���}�Ɣ ���Vӻ�p��$���>�V6�(V�[1ឭ�ex����vf<X���/S��SȘ\>��րV��6ɔ��ӛ���|�Oq/!���))͙!(���&w��}Ta89���:O���l�~�߅gp(�!b!�g��h����&��G˪}�;VE�� ed>s�2�
F��ݔ�=��,��~��sS���O����3�1����=yC�H���%�l�I�[��:�pS2�����av�QNq�2��Q8?� Z(�G'����>YU.��Wa�0[�'c@�Ԧ	����i�lű�C�Ӥ$��`<�e�/��:�S��b�o5��t��lKm���(gD���edcL�.�v�sy�c@+���W6Ml�~gy�qUqs3�����!��`��Qb���"[d�7>n<M�f \׺�������Lz��Ϩ�n�D�uqU;�<�����ig�s9Rmu������������^$�i�C�r�I�tw�r1y i' �șZ(��/��X-��Qx�%�=ǣ��K̲�@j�U9؋ !4n��ѡ��훗�?�u�y-K1S#�Ha�շ�Xe'w�.D��G��q��c7^,������ec�pvu1{��jY�C
�r".��xIs���@��Մ�sw_���B��]ȟڪf���c{�px��?M���Lv�E��04$\<����s�)C~��q�����qUt��:_K�+3������$���Z� �d3�Z[��fR�%��u�:�J���9-J�NR�)�Ǵ�y\q��u��SV���qL��a\A��n�P��ڲ� ��� �7r��5$���?���;�$�Z�kYG�@1��z�JQ�VHP9Y�$mo�)`Sa��N�B@lx�J s	�����~�. �IT�	�#4l-�h{gpz0%Hl�Q����븲S�~�}��^/�������ʽ(L~�(�2���F��Ip�c�`�3PώO�'��583#�����z����G;H�!KnPg�%����LU��߲\ܒ�
]�������<�2Ό}S�n-�FQ�Nr|x��ݝ�	~�%
�H��Uծ�؊��e�)����\��!�#f@X�N�l���
Z��8)���e��k���k{9�H�ll<}?[�[�l�B�f�R����d�`�jgS)ˬ�����ZT�T��[��2����]��u�p{�M�:��a>-,E�q2V���]�
�lDQ��곂�7�q��M��β:0�(0ز�k.��L�f�3G��Q�כ�?>��}�����J
�:���k�Vo�R�)���c%�;���z����	f������01�hxxҟM�9�_\�N��+;���7��}>_��ˮ����}E]�*�M��$0Q��<�]nV��ʎ꺧^�̓	l�N�q���o�m�����mF�4b�7�8pi��GF�q��N�0 ���t���t։3Opg�_���U�.-N�t襝��?Cg��Zݰ�2�~��T��-ĳ��@�GTJx�~r��[,.��bD|mWB�Ԥ�ςd��U���1����,a�#P��sN �g4��AR���xt��߷�'Qcs�F-�q6qǯ�� C�WI����2X�R�@�G�	�-0�r�W��U"�<�֠���.W��7ӑs�0��ʼ�4Qb�N�8�-)Q�D���D���?�uM�J����hJ�񮯾,n��~�¶��;��t*���4%��w����*W���d�I�����N�y4���k�isP�jK8���*����>�&`�(�:�`l�0E�F�3%:����_t7L� G7�h�#��Z��@ `��ʵo�ݓd��҃�S��Z*�O�#�"��/�3<�@��ˌPC m~_B�
�C-e%Y�>Ը4�����}�ڇ�\����#2Ӎ�����f�A�p�5�8����s� E:��l�,#��C���T�3bPH����b.�Ş$ߥ��f�q�]"t������Ol�рZ{�f&�Y-l��!�&h�����~:>��8[�Oo
�����v8=]<hvik� �  �m�Y�6�vH�:*1SU��ih��UbEc���o�Б������؀���n>xH�#Ȩ���8����: �\-�~��>X���{��/����eL/N�`~w�M  i}�)�G���;%r�����`-�����ʭ�ZD:!�S�G�J��/��6�g�n�A���߼���I�	v�32��,�	�3�b��"�!E�O��8�$��]�	x`��l)9e�u��$�]^(T��+%��{8��po��i'��rW�U��7���)'[�����T��͜~��������b�����!�̮�eS��K3vbG<���?�(��ה�
7�e��5�M�(<82P�ez͠E��t���[䮍3E��NZ�ʝUI6��&A��T}?S�7��(��5CvpF��T�p� ?�d�,K�idu��Arq��4D�d�}ѭK�w��Rǁ��SC�5��(���Ń��C��-�"vy�x��:�Q �,7
^!ߑ��E]�dr�J)ћ�M\xE{��pL?9v����U�����ك�U[�b3\��:�+G�_D"�M>�R���ޟ��Ӌ�YorF5CY��f-9������q:3�i]��+#���m��ԙm`�����য়~�	+��      �   �  x���]o�J��ͯ�{�jfv�˷9*:�I�zQ�2	��GT����F�7"��"?�3�`F@��]F���"����ڳ	�/I�>\\X�_n�x�5NG�S�:+V��߲y�Y.���z1Rw�G�>-W�7�l�Vl�k�O�Z��z���
���n�Q���{�T��?�E�H�Ɂ1��91�,�,.���{u��� �<���Bnm�P����� <:8`D9�܀�P˅3��5.�9<Dfo���C��%.����rK�YB�J1֎�ضL�/�J���x8�<R��c�8�m���\�X/fŏ��S�x�� ��N�����I�c�&3>�� VyF���������7WxOCs��E��n6߬���nSeaR>�+��K�(���k[�\��4WR?PȺ~8F�Xg�c�ȉ��#JI8���GIn;�
\m�Bd�$%��Q��5�⹚hR!qq�h�@
 �t�-���rR��lH+�eWw��с��X@H�?
�T�d2 I�Q����MԆX�v�X�?����:���ۯq�nz;R/�>o�MQq�Ux5�ǲ\�)�}U#�Ͷ��q}~��淀&Ĵ��X=�<[�# R�2�&��$��7db���]=���$�<��=x�p�w��
m.��@{��خ�9ZM�y�Z.�^k88���h����|C����[�r�#C��R���#'�/@l����k� �oB`�YDӌHL�d�Iҭ�
9���@#{wIJ}�X'��3�{���������O���,��b��j�k�>@���޲��z��ֶF7����,���uOH$�[��q
�����^=N1�gb�J<�3��4E�:���喵�5�%�mDW����H��1r�ퟌĶ�!�#�M�[����G1�rGb�{>��O�^x��|�����b7�6-����L��      �   s  x���QKA��O�_�dfv�<��z85!Ⰵ1�<�o�TZ'm5>:?�w�3+�Y�u��Y\,�]j��A��?��Q��2F��Q|�@l�]�~l����~]=�{�
}�髨�H��\7nߵ;[�O���W�9�BD�Q�U&}���wCj\�T [���}��������e/�Ud��y�R���'�p��]�}s����%1K�� 0�A`�����5����T���� ?���o�͐d�II׻1ݱ���JY��+9IW�/5QX���}ˈ?�Bh��މ���	t�q�o�ԥ��x�l�u�+�!�%J>�LtA����(kA$�Ҽ���
)r�����0yP5�`5�WELyV      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   p   x�}�=
�@��z�s��y/�Y�6��I?�@�����N��W��e�6����Wќ`A����c�d[!�ǧmI����Y���#�;�������p'�U�q7%}      �   }   x��б1�Z���!��-{�L��ϑO�A�/��A���/��Q���eX6kkȫ��6m��S��bOh�	4�_�mE��6�*��q'���gY�z��L�R�����#(�'�UU߁�a�      �   s   x��=�0@��9�/@d���Ε�Ҏ,VA(R�QJ��C��oz��s���9MI�YW|�O��:���ߐ�k�͋�l���6��6D�C�OH��X�C����8�f�Ƙq��      �   ,  x����n�0�g�)xN�c��I�P��vk�.�������P	C���o��T6{~}���%ʭ�-fd�HpՉ���> ���K�#���Y��H�����}�;��	���c���������|_\�_�����GY'� 5��h V���?b�ya���w���������}NE�H������s?��>X�8��;H�u4�e��A2jnu{馃���0�q���(G����XFE�vp톶�+]�$Q��~�X\4C}}����R`k2�T)���߶�G��2��1��(�      �   Z  x�u�Ks�0���W�p��M������;�t���(����ձ�c�,�ܜ����~��}�_T&�H���b.gT"��҇�t(��\U:s�r����\�P6\���:����O�ㄬ�_��j`0 ��0�1z��m��,�R�U�z"ڨ@���P_�%�&a @(�(���C��ٱ���OF[��=��n/R@��EBI� � �|���Y8��vg?I����ة��z��+�+`r�6w2��ӳ�?\�'���M��:�õ��j)�px�t�?��s?����GP�8ۼ�G���@��m�K�B��b�tg3׽�U��Ҭ�i����a      �   |   x��ѻ�0��:���l����� m��Z�'7�%K��YG�~�O����&��d�lz�ʬewKV��W7w_�	��`� ^%4�%4�%4&4^&4�&4ަu&Nh��o���8~Ny&~�      �   Q   x�3�4�t,.)J�t��/J��K,�/RN�I-�420��5202����4r��t,t��L��L�L�L��b���� �v�      �   �  x���K��0DתS�	ğm���eo���ǔ4��c��eRT����?��|~�����Eo"ݷ.��U�������`��v_�Bd�z�e��_�к��n�1�P�$vTm�j�5c ]g.ݫ4�ZW�Z�V���z�k�Ƃ2�od<�h���X��6Z��>�$���eb�eq�6��ɣ��A��^fc�"c��<uR��gg�Nw��j+N����Zi��AZ1�:�Îm����,Z��1(�y���Z��c����I�d/��"k^$���=f��%�.e�����;Yti��][�=��&����w���ګ�|2pxn��p�f�4���#���=繹"cg��K���M����u�<h_�d*s=x/�{r�;�1�����!&g�d�����d�ؒ1�Ǒ/�b�m�d���{�1�26G�@��VֽL�=�����6f�JDg=~���+m�e����K���W�[��� �>8x@      �   0  x����jA��u�U��������ҍ��Y	���L�w�d,8.Bj��	ڇ��L:iR}H�!�$�ӏ�oN��O_��L��)m&ɗ/>?��N���'�5��������i5_�t�>ɬ���W��"۲������緂��˫�A�i������&������U�)ݧ�/`٪e�\k����B�U7��V�~T�%iK��E%-Kg�,݇eТ������2�h�2o�*�}XZ4���avV����GF�KZ4V������ҳzy��;2h�nK�qK��-���ʪТ��qK��-��qK�,h�Xz�*ˠEc�qK��-���ʪТ�Zx_'c��4Kͯ�X���㐧��0I.P"�t�!T�A�D��~PIJ$R�o�T�D"��nPIJRN��`��@�D��^PI%��Z��g�R������6oK��LV����j0YZ,VIa9��"Т�4��eТ�<,���Ec��"LV���0YZ,V�o>���3h�~'���deh�X%<t��
-���.�ա�b��DVh�X�L�A�����e�2�h��,���"��]9iJ�[B-��ԡ�!�6�F�%I�~�H%��v�HJ$R	��#U(�H-l�ԡ�!IJa0h&I)J�`�1�/%��+'�R#�[J&��ʐb�J"�B��ja6��)JRJR,��� �R,��� �2�X�ƃ���b�❃2�򴨔���qoG"��Aa���������Pa�
o!Pa�"�"Pa�:o$Pa�Rf�^f�jo'Pa���e��W�>      �      x������ � �      �   �   x�e̱�0����)�8B�=mA�aC"q0dr3$n&��oM�������,M?��`Hd\e����9�����K��x���5���ݧ�r���%��<oy���R�>4Qo[%TB�.S83)�B<�ˊ-��:�W�Ai�0�x��c��w�+�>1p8v     