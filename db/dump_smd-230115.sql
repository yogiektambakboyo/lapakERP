PGDMP     !         
             {            smd %   12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
       public          postgres    false    202    6            �           0    0    branch_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.branch_id_seq OWNED BY public.branch.id;
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
       public          postgres    false    6    204            �           0    0    branch_room_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.branch_room_id_seq OWNED BY public.branch_room.id;
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
       public          postgres    false    293    6            �           0    0    branch_shift_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.branch_shift_id_seq OWNED BY public.branch_shift.id;
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
          public          postgres    false    207            �            1259    17942 	   customers    TABLE     �  CREATE TABLE public.customers (
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
    contact_person_level character varying
);
    DROP TABLE public.customers;
       public         heap    postgres    false    6            �            1259    17950    customers_id_seq    SEQUENCE     y   CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.customers_id_seq;
       public          postgres    false    6    208            �           0    0    customers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;
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
       public          postgres    false    6    303            �           0    0    customers_registration_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.customers_registration_id_seq OWNED BY public.customers_registration.id;
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
       public          postgres    false    6    210            �           0    0    department_id_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.department_id_seq OWNED BY public.departments.id;
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
       public          postgres    false    6    215            �           0    0    invoice_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.invoice_master_id_seq OWNED BY public.invoice_master.id;
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
       public          postgres    false    217    6            �           0    0    job_title_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.job_title_id_seq OWNED BY public.job_title.id;
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
       public         heap    postgres    false    6            �            1259    18036    order_master    TABLE       CREATE TABLE public.order_master (
    id bigint NOT NULL,
    order_no character varying NOT NULL,
    dated date DEFAULT (now())::date NOT NULL,
    customers_id integer NOT NULL,
    created_by integer NOT NULL,
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
    queue_no character varying
);
     DROP TABLE public.order_master;
       public         heap    postgres    false    6            �            1259    18053    order_master_id_seq    SEQUENCE     |   CREATE SEQUENCE public.order_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.order_master_id_seq;
       public          postgres    false    224    6            �           0    0    order_master_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.order_master_id_seq OWNED BY public.order_master.id;
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
       public          postgres    false    240    6            �           0    0    product_brand_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.product_brand_id_seq OWNED BY public.product_brand.id;
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
       public         heap    postgres    false    6            �            1259    18167    product_sku    TABLE     A  CREATE TABLE public.product_sku (
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
    photo character varying
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
       public          postgres    false    6    253            �           0    0    product_stock_detail_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.product_stock_detail_id_seq OWNED BY public.product_stock_detail.id;
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
       public          postgres    false    6    261            �           0    0    purchase_master_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.purchase_master_id_seq OWNED BY public.purchase_master.id;
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
       public          postgres    false    6    264            �           0    0    receive_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;
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
       public          postgres    false    267    6            �           0    0    return_sell_master_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;
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
    created_at timestamp without time zone DEFAULT now() NOT NULL
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
          public          postgres    false    298                       1259    18322    setting_document_counter    TABLE     �  CREATE TABLE public.setting_document_counter (
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
       public          postgres    false    6    275            �           0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
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
       public          postgres    false    6    282            �           0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
          public          postgres    false    283                       1259    18384    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    6    280            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
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
       public          postgres    false    285    6            �           0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
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
       public          postgres    false    287    6            �           0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
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
       public          postgres    false    6    290            �           0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
          public          postgres    false    291            b           2604    18423 	   branch id    DEFAULT     f   ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);
 8   ALTER TABLE public.branch ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    202            e           2604    18424    branch_room id    DEFAULT     p   ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);
 =   ALTER TABLE public.branch_room ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    205    204                       2604    18723    branch_shift id    DEFAULT     r   ALTER TABLE ONLY public.branch_shift ALTER COLUMN id SET DEFAULT nextval('public.branch_shift_id_seq'::regclass);
 >   ALTER TABLE public.branch_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    293    292    293            1           2604    26922    calendar id    DEFAULT     j   ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);
 :   ALTER TABLE public.calendar ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    304    305    305            g           2604    18425 
   company id    DEFAULT     h   ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);
 9   ALTER TABLE public.company ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    207    206            i           2604    18426    customers id    DEFAULT     l   ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);
 ;   ALTER TABLE public.customers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    208            -           2604    18777    customers_registration id    DEFAULT     �   ALTER TABLE ONLY public.customers_registration ALTER COLUMN id SET DEFAULT nextval('public.customers_registration_id_seq'::regclass);
 H   ALTER TABLE public.customers_registration ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    303    302    303            l           2604    18427    departments id    DEFAULT     o   ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);
 =   ALTER TABLE public.departments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    210            o           2604    18428    failed_jobs id    DEFAULT     p   ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);
 =   ALTER TABLE public.failed_jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    212            x           2604    18429    invoice_master id    DEFAULT     v   ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);
 @   ALTER TABLE public.invoice_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215            �           2604    18430    job_title id    DEFAULT     l   ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);
 ;   ALTER TABLE public.job_title ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217                        2604    18730    login_session id    DEFAULT     w   ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);
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
       public          postgres    false    268    267                       2604    18446    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    271    270            "           2604    18739    sales id    DEFAULT     d   ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);
 7   ALTER TABLE public.sales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    296    297    297            %           2604    18753    sales_trip id    DEFAULT     n   ALTER TABLE ONLY public.sales_trip ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_id_seq'::regclass);
 <   ALTER TABLE public.sales_trip ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    299    298    299            +           2604    18765    sales_trip_detail id    DEFAULT     |   ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);
 C   ALTER TABLE public.sales_trip_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    300    301    301                       2604    18447    setting_document_counter id    DEFAULT     �   ALTER TABLE ONLY public.setting_document_counter ALTER COLUMN id SET DEFAULT nextval('public.setting_document_counter_id_seq'::regclass);
 J   ALTER TABLE public.setting_document_counter ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    273    272                       2604    18448    shift id    DEFAULT     d   ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);
 7   ALTER TABLE public.shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    277    275                       2604    18449    suppliers id    DEFAULT     l   ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);
 ;   ALTER TABLE public.suppliers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    279    278            �           2604    18450    uom id    DEFAULT     h   ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);
 5   ALTER TABLE public.uom ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    259    258                       2604    18451    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    284    280                       2604    18452    users_experience id    DEFAULT     z   ALTER TABLE ONLY public.users_experience ALTER COLUMN id SET DEFAULT nextval('public.users_experience_id_seq'::regclass);
 B   ALTER TABLE public.users_experience ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    283    282                       2604    18453    users_mutation id    DEFAULT     v   ALTER TABLE ONLY public.users_mutation ALTER COLUMN id SET DEFAULT nextval('public.users_mutation_id_seq'::regclass);
 @   ALTER TABLE public.users_mutation ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    286    285                       2604    18454    users_shift id    DEFAULT     p   ALTER TABLE ONLY public.users_shift ALTER COLUMN id SET DEFAULT nextval('public.users_shift_id_seq'::regclass);
 =   ALTER TABLE public.users_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    288    287                       2604    18455 
   voucher id    DEFAULT     h   ALTER TABLE ONLY public.voucher ALTER COLUMN id SET DEFAULT nextval('public.voucher_id_seq'::regclass);
 9   ALTER TABLE public.voucher ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    291    290            Z          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    202   �      \          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    204   �       �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   Y!      �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   �!      ^          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    206   w7      `          0    17942 	   customers 
   TABLE DATA           =  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level) FROM stdin;
    public          postgres    false    208   8      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    303   y8      b          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    210   �L      d          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    212   OM      f          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase) FROM stdin;
    public          postgres    false    214   lM      g          0    17984    invoice_master 
   TABLE DATA           W  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type) FROM stdin;
    public          postgres    false    215   �M      i          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    217   �M      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    295   AN      k          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    219   �b      m          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    221   �g      n          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    222   �g      o          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    223   h      p          0    18036    order_master 
   TABLE DATA           F  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no) FROM stdin;
    public          postgres    false    224   )h      r          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    226   Fh      s          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    227   ch      t          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    228   �i      v          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    230   Ax      w          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    231   ��      y          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    233   k�      {          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    235   ��      |          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    236   ۚ      ~          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    238   �      �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    240   ��      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    242   W�      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    244   <�      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    245   I�      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    246   |�      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    247   ��      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   �      �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    249   E�      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo) FROM stdin;
    public          postgres    false    250   �      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    252   F�      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    253   ��      �          0    18191    product_type 
   TABLE DATA           J   COPY public.product_type (id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    255   �      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    257   ��      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    260   Ӹ      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    261   �      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    263   )�      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    264   ��      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    266   2�      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    267   O�      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    269   l�      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    270   ��      �          0    18736    sales 
   TABLE DATA           �   COPY public.sales (id, name, username, password, address, branch_id, active, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    297   }�      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    299   ��      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    301   R      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    272   �_      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    274   Xa      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    275   �a      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   *b      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    278   �b      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    258   :c      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    280   Dd      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    281   �e      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   3f      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    285   �f      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    287   �h      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    289   �k      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark) FROM stdin;
    public          postgres    false    290   �k      �           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 22, true);
          public          postgres    false    203            �           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 13, true);
          public          postgres    false    205            �           0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 2, true);
          public          postgres    false    292            �           0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    304            �           0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    207            �           0    0    customers_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.customers_id_seq', 30, true);
          public          postgres    false    209            �           0    0    customers_registration_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.customers_registration_id_seq', 77, true);
          public          postgres    false    302            �           0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    211            �           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    213            �           0    0    invoice_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.invoice_master_id_seq', 106, true);
          public          postgres    false    216            �           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    218            �           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    220            �           0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    225                        0    0    period_price_sell_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 884, true);
          public          postgres    false    229                       0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 506, true);
          public          postgres    false    232                       0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    234                       0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    237                       0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    239                       0    0    product_brand_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_brand_id_seq', 9, true);
          public          postgres    false    241                       0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 15, true);
          public          postgres    false    243                       0    0    product_sku_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_sku_id_seq', 90, true);
          public          postgres    false    251                       0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 24, true);
          public          postgres    false    254            	           0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    256            
           0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 24, true);
          public          postgres    false    259                       0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 18, true);
          public          postgres    false    262                       0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 31, true);
          public          postgres    false    265                       0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    268                       0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 12, true);
          public          postgres    false    271                       0    0    sales_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.sales_id_seq', 24, true);
          public          postgres    false    296                       0    0    sales_trip_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 531, true);
          public          postgres    false    300                       0    0    sales_trip_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_trip_id_seq', 495, true);
          public          postgres    false    298                       0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 39, true);
          public          postgres    false    273                       0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 10, true);
          public          postgres    false    277                       0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 4, true);
          public          postgres    false    279                       0    0    sv_login_session_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 317, true);
          public          postgres    false    294                       0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    283                       0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 56, true);
          public          postgres    false    284                       0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 42, true);
          public          postgres    false    286                       0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    288                       0    0    voucher_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.voucher_id_seq', 5, true);
          public          postgres    false    291            3           2606    18459    branch branch_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_pk;
       public            postgres    false    202            7           2606    18461    branch_room branch_room_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_pk;
       public            postgres    false    204            5           2606    18463    branch branch_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_un;
       public            postgres    false    202            �           2606    26927    calendar calendar_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.calendar DROP CONSTRAINT calendar_pk;
       public            postgres    false    305            9           2606    18465    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    206            ;           2606    18467    customers customers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pk;
       public            postgres    false    208            �           2606    18784 0   customers_registration customers_registration_pk 
   CONSTRAINT     n   ALTER TABLE ONLY public.customers_registration
    ADD CONSTRAINT customers_registration_pk PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.customers_registration DROP CONSTRAINT customers_registration_pk;
       public            postgres    false    303            =           2606    18469    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    212            ?           2606    18471 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    212            A           2606    18473     invoice_detail invoice_detail_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_pk;
       public            postgres    false    214    214            C           2606    18475     invoice_master invoice_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_pk;
       public            postgres    false    215            E           2606    18477     invoice_master invoice_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_un;
       public            postgres    false    215            G           2606    18479    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    219            J           2606    18481 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public            postgres    false    221    221    221            M           2606    18483 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public            postgres    false    222    222    222            O           2606    18485    order_detail order_detail_pk 
   CONSTRAINT     l   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_pk;
       public            postgres    false    223    223            Q           2606    18487    order_master order_master_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_pk;
       public            postgres    false    224            S           2606    18489    order_master order_master_un 
   CONSTRAINT     [   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_un;
       public            postgres    false    224            V           2606    18491    period_stock period_stock_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);
 F   ALTER TABLE ONLY public.period_stock DROP CONSTRAINT period_stock_pk;
       public            postgres    false    230    230    230            X           2606    18493    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    231            Z           2606    18495 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public            postgres    false    233            \           2606    18497 :   personal_access_tokens personal_access_tokens_token_unique 
   CONSTRAINT     v   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);
 d   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_token_unique;
       public            postgres    false    233            _           2606    18499 $   point_conversion point_conversion_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);
 N   ALTER TABLE ONLY public.point_conversion DROP CONSTRAINT point_conversion_pk;
       public            postgres    false    235            a           2606    18501    posts posts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    236            c           2606    18503 $   price_adjustment price_adjustment_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_pk;
       public            postgres    false    238    238    238            e           2606    18505 $   price_adjustment price_adjustment_un 
   CONSTRAINT     ]   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_un;
       public            postgres    false    238            g           2606    18507 6   product_commision_by_year product_commision_by_year_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_pk;
       public            postgres    false    244    244    244    244            i           2606    18509 (   product_commisions product_commisions_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);
 R   ALTER TABLE ONLY public.product_commisions DROP CONSTRAINT product_commisions_pk;
       public            postgres    false    245    245            k           2606    18511 ,   product_distribution product_distribution_pk 
   CONSTRAINT     }   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_pk;
       public            postgres    false    246    246            m           2606    18513 *   product_ingredients product_ingredients_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pk PRIMARY KEY (product_id, product_id_material);
 T   ALTER TABLE ONLY public.product_ingredients DROP CONSTRAINT product_ingredients_pk;
       public            postgres    false    247    247            o           2606    18515    product_point product_point_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_point DROP CONSTRAINT product_point_pk;
       public            postgres    false    248    248            q           2606    18517    product_price product_price_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_price DROP CONSTRAINT product_price_pk;
       public            postgres    false    249    249            s           2606    18519    product_sku product_sku_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_pk;
       public            postgres    false    250            u           2606    18521    product_sku product_sku_un 
   CONSTRAINT     U   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_un UNIQUE (abbr);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_un;
       public            postgres    false    250            y           2606    18523 ,   product_stock_detail product_stock_detail_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.product_stock_detail
    ADD CONSTRAINT product_stock_detail_pk PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.product_stock_detail DROP CONSTRAINT product_stock_detail_pk;
       public            postgres    false    253            w           2606    18525    product_stock product_stock_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_stock DROP CONSTRAINT product_stock_pk;
       public            postgres    false    252    252            {           2606    18527    product_uom product_uom_pk 
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
       public            postgres    false    297            �           2606    18553 4   setting_document_counter setting_document_counter_pk 
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
       public            postgres    false    295            }           2606    18563 
   uom uom_pk 
   CONSTRAINT     H   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_pk;
       public            postgres    false    258                       2606    18565 
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
       public            postgres    false    290    290            H           1259    18584 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public            postgres    false    221    221            K           1259    18585 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public            postgres    false    222    222            T           1259    18586    password_resets_email_index    INDEX     X   CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);
 /   DROP INDEX public.password_resets_email_index;
       public            postgres    false    226            ]           1259    18587 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    233    233            �           2606    18588    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    3379    204    202            �           2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    214    3397    215            �           2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    3493    280    215            �           2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    3387    215    208            �           2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    231    221    3416            �           2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    3479    222    270            �           2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    224    3411    223            �           2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    3493    224    280            �           2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    3387    208    224            �           2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    3493    236    280            �           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    3443    250    244            �           2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    244    202    3379            �           2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    3493    244    280            �           2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    202    3379    246            �           2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    246    250    3443            �           2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    257    250    3443            �           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    261    3461    260            �           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    3493    280    261            �           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    3467    264    263            �           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    264    3493    280            �           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    3473    266    267            �           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    267    280    3493            �           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    267    3387    208            �           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    269    3416    231            �           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    270    269    3479            �           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    280    3493    289            Z   '  x�m�An�0EדS��;�(
�
B�ظJT��X2���;�U�lo�'_~ϱ��|Z���t��ae϶+�Y��wB��,w� Q��H�
���a�e!5�@)������԰���������H��ؕ����Cz��X�af����Y.B�0���FP��u��RC9��<:ݽc������Ӧ��[��I�c�*wv���`-�����/`�Kۅ��	�Ɏ2��q'�5����*�(�KJv���n�ַa�O�D.HdH%;�s}m�|��2�Z=�N�����Y�}\���      \   M   x�3�4��T�Up*�K�N�S00�4202�50�50T0��21�21�3032�4���2��p��/J-V00"�!F��� �J�      �   7   x�3�4�?N###]C#]cK+CC+C�\F@FX%���1������� >��      �      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      ^   �   x�U�A�  ��
? Ywa9�^��
cE���iMO=�d2N��[w��^�n����.�?�e_��y��o�ӱ+�z�A@@q��gY�G#C	R%Pu>��g[z�8��%���jh �m���$�^?�����,�      `   Z   x��ɻ�0E�ڙ"$�_�)t�Ҥ:�G�	�=�}t�ֱ.;�����J̵4nL�gǰ`U^����l��@c���b�7�<�#      �      x��[�R˒}����m��W5O�m	���x|�'$�Ѝ������YY�-��0����ʪ��ke.�2f$�[�#����|������h���b��ů���qD�Oɥ���g�2��?�啴<M~v����E�|Y$��j�D�!d�-��g��&5&�I�q1^����z���<�?�FO_�ٿ��ø��2������O^��i1g�ʹ�0�|/���1�n����y�Zl�`�'�H��?����3D<��|����h5�$%n+�U^na�t>������r�/�?�G˃��*�L�J�l��]$�:�����ϳ͐]�Vk������=�b���m�c�.6��z4g7���d�\/>�o���g���Q��g2m	g�&d���,�f�)l�X��h���l�L�i��ோ����)"`O����Ji�����R�k-����Jh�R�,7�`5�n5$���!x��n�-G$e罬{��:�{�R��//�W�"�����-���v۾�n���gF�)ے���ǽ����l�^�()��	e���I#���s��qxu�y.f�bȲY1�A�v:d.�R"�,�x��<���!&��!&s�=�r�(�J�V�5�DJ��[#����sL����4G��^�Q&Z��E�aߓ�i����|4E�=���!L��7��4��kk#�t��,G�U/��������h1Y��؉)���快�V�:Ka)c5BKv?�C�U(JqCPɏl�3��ȵ���yN�Ҵ�1h{&|�jc�>�O�Ƴ�"!aZl8~\<l��nجX�I1]���i�bH�͚=���lI�1�xj#ǔ�Uy�*�
[F{�TVd-^m����d��=�����h2N��o�{3)f���ɴ1^�x��#M�_gT���f>���O,�PVK��0*�N!a��X'���seU��'��l���d��D��#4�d���e.�d</��-f�Hq#��-I�v�66�`�V��;i�M#m��v�~L�`Tz��,�	��b�${ݬG��E�7/�߱i��ro<Z����1pq��t-��\�}�,#��A��\ܫ*�P|URJ����{��Mz+8���cp.���E�b�a^G˗M�����Z�Ǉ]�g�"4��dSe��P�>�!Ș>��TV�K��i�+�.s�TN���X��� ���Mv����/����A�m��P!�P�jp�,t�9�d�*ǭ�^��#�;aL���,a�L�4A>�
H�e�5f�%�/Fk�:8��`Mu�rn���LW����*5.����ιTheA�Y|:edR��'WW���j2ZQal�� x͡��j ��zf�}&���6�)+�����~��G��|�%�U��ρ��xd��UF�L��)mUA-��#�$��������޲�˗��'!j
��0�� �83}��T��~��"|+�ߛ�s��7��� j<m=.f!�+�s�� �ޗ5_x���I1}C�	4�����i�\0�f4C+�$wC�)�Z��'���)͖�$m�R�]�L�`��G	�S~[מm�b���K~�Z�K#�j O3ZBHEY!U,���}�u����ȮI`�o���6��^?�zyC��-��,Բ�e�����sh���=�~b痝b�⾿MSWeb!ACR�#�D�c!�:��>p����-g��p4)P��%����t˜Mn�I��N��O�)I��b�W4��B���� �M2h�h��ig+�&�V�2��,�gp��9�"�W���0-����F�ҞAo�y:�C�]�cO�:"`WTQO��:v�h��M���z�55���7��Z!��Cҿ:�N��O1�c�o��b�G��:M��>L���q��������������Knoγ6k����Ȅ��^܆���雾˳O�n/:_�/o"א]$�>����6�<��$yڠ��ъ��%�TG�R�x&)`[p���E+ �0T��[�T�
m7Mm5��[��^�)\Z/Bש�X�T[<+�s�RQ��6�p���u6��Q�L�fd�oRi��o��J�8*�`�����ޥ��`�V���a��螝��B���q��P��v�n*��S�z��oڐ5�x�2��7�Kj.�j,L�C���ɒ�!É0=h�n���?N��+���:���(	�d�Z>�)�;~�kĮ��r���kdG������-�ѧ���R��=TR�8�������J�QHCm	E庘�����?<�X���SS�ڸ-*�#6�-��#�,h�e��"���Pt4a��<9�����IN���|���.�] ���a#� �{�#�Bc������;ʞ�oMT��l�^2C�/�����;ANBnzc��MB�������m$;�fh�[����j�:��~�b���{q����F��!0Hy/cy��j��xI˽\̊`f���2�a'a�AD���I��٠�	l��Ի�/Y����,)7�CՊ<L�[.�ֻ^~��À�X�����!��e'��m"#B���q�X�IU�=�^)g�"�W��.B�@a7'l�{��H���{�<4|5�f4D� Qq���N�l����S��K���X��aLR��ڋ0��B¼Q���"άT�d��X�/��Nrwۻ��k�����Z��?3�����c��b�����}H�O�߉8H��,�����;�?���_x�͓nև�锆�������$�ͥv��ZXx�4�h-�(l&�lY`�9Mw�A�m��) ,W�|�7`VgRf҉~7���C3ս��VX��to� ]Ç��K�߳^<��N{�<C-9GAi��5�������u�w���X��N���տ`��4R6-d*��|d)ъˡ�VI����Q�(�C.�.�M\UgVX-r�>U��S�n��\�;�9�����A�l�/P�x���Q6�eR�R�S���*�u���S�����p�:�R�c�Q�ܩ���c�j��E9H�/�qJ��;^�(5]�+|f�ܟ��H
ZG�g5�xp��ԧb>5u}F�\�&7N��m��6Pg~�w_vQ�_��a�����iFݵ4'0��se���-�B�X5HL�?�������|xpsz�`ߑޥT��o7�4��6(ue����7��Gh�!U)�a��E1M�("a'"�h�mxS"�!��%��`�)�t��V$k-��̒{��x�&����ocWR�H~�ҹ�nb\m�t�\L��u�\��;���r�زU��<Z��Ě��*%C��C����#x������H뒼K:��1:5�a*V ���hI�ajCǟ���t�{l9밲�We+� c3[͊�8yw�IwTIe�E���ǉ��^޽ʻl0z���8�8�F���T/B�-d�h8�&��f�tL]�B���H��6K�}���7�5�:�:�:ߊ�Gd���{_�隡ҟ�TIQ�ShS���U7��b{X��m�6�q\#���)�R�����u�g4"5�ԫA�)g.�U�$�,C���}j�h����ʛ��m�@�jhu*c�7U�=�}��Y2(h�V�J2�����	;��84�<�ot��Q&Em�w.F���Ю������> �-5Rα���,��AF4��_��\䊐���pv�n}`���n<�)��5n8�+���[!lS��2,�u���4S�&|d$VW�#bāp�<e[ ��-Y z���x����{M��q-�z��~�7e����)z>����qX�R��]�+�P ��î`G��=?9�Y�M�똷��Y�"gY��g��d߲@���;��W��y��<* O�?�����$eg����
g��͕ƫ�L�d�Hv�2�5���GR& ���IMuH�J _���y�,�T}�R2,q◦Z�v�u�A��	��I/��%������;�\��Єe���Jp'��}�e��n?k�sv�7��g��s��m�����Ş��]���5j�ت�n3�æG��[vw��8�U�LiZpȟ���:G�la�R�8m���j�eD�C���]���dh��?�G�5`�,��� 7  \
�r��j&p���#�rje찰�p��=YvX:l'�f�s�2�kMӣ�P�t��h�J�O�P�	M9Q�of�:)�t�w�'����&�~qźWY~L�0�3�F�tWʹ�GI���|����H�-w��䮅]��NQ��9�"����n$�]���׈V;R��N�C�w��x:�0�_[<�-X%i ��0�X�D�,��E�.i�:]�ĭn�64�n�X��>��s����3�tei�pZɼP�� �3XL�纠���l5~[��*XMt>�R�Х6ǳ �4�/���ObO�ͦVڔ�M��ɲ���k)(�R�4�$�6�fd��U'�����y��r
�v���r�z@�}?>]B �n��Jđ�#�PW���겛,�C��8�."r�*�3�k��_��`�Co��Ї.F��j�)>��h�uu�M����TcOq�M'q��\W��]��qh�UuAY�il��[�>�"50U��(�K��po����
@��Y�?6z��qբ���%ҭT�[��-&�����k&b~[��^s8j��մ�n����T�V���5�u���.U�	}$S�.���9����lRm�d�7Ua՟�o��,�����&���C_'���(E�G�?���6�?t+5Z;����
��tZ�uF�T�W7A��.\D�ݼ}�iī\ꉔ�
���7f2k�i��==��CSN�i$)j� � ��I��<�FϿ���u���U�����X���?�C�Ʋ�-4��3�r�Ze5��ZrRG�5��[	W'_G��o�OZ����i3�ƛ��ҵ�T}�viZѩ��y��:��,�TƖ��z���x��Ӱ���^��yֻmc����<�a��l���V���������SM�F�ei�<9o$�S��:��e��۸�^9S�2��w������$DeLUu,�����y�K��n�;Y��T��&�
��+3MW��k�-��g��j�Kc�Hb��A��D�!�H#�����_I��yu������h�W�=t���Oټ�V��}�;/|9�E���kG/��ٸ�o,�6U?[��������      b   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      d      x������ � �      f      x������ � �      g      x������ � �      i   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x��\ˎ%�q]w~E��d�Hޝ�iz4���y#�Zٲ���aVU��t����O$'"N0Ȫ_���ZZi6�����ϗ����_����?�e���+�w�}-�a�!v���C��[��3\���	�}���r���aOPo���z?[�r�3tl��Q��RE�:�v@�ՎvC{)����|T9��GF��go�㟀�:����g�D�bv��O`eHkzT�'��j��f�P�`�E?� ߽�e�6&��ت�Q�lņc�nJU+V�
k�b�:ή^K?jdl����:��un	��5�n�����M+�j��`���!�QG�z����E������� ?G�R����,�h�>>}�d�m����w�~���*��b�W��0�v���+�������U|W���	��˧rb�<���u|��W�"v��{Կ����]�6:B��U[�P��hң�36�7�x�c�C-7V�j�$�+Ś�~h���^�X���I���zc+��/���"Rt*OXY�wb%� >Ƭ����F:k�C-c��6���r�Y39�Vk��'V��٬B�F�b6XyHE�o��Ж�]?w���
Hځ���W�Ŗ�ktC*3����Xq�`�Q*2hS���@��\g�nc�G����'�.�;�*�"��x[e��x�|�q�1f�ر^�`��$+|���)y9�xR
$N�F�ī�Z-ys���ފ�&^5��
�EfJ	D�vX�U#x��tU��L��l%�t�z����M��h^���h��e�����ڍ)��[bPmx�U�Xd}`���.ج ,.;֡�s�Ȃ� ⻉V{�\�>]!C�'V�E�I�(��HC�u®?;�/�>�X��X��Z*u�T��Q��yp�J`��8*����%3&���VPQ�X��^'_�|��X�޸I%T��U�� GBZ@Z�5c���Xg�l�֎�'l]��;�QX��	[Y>.��Uq-�0fKXTJ��:T]9���M*K[*:�!�՝E`d�:�;��L툖�V��(�3�C�EƮ"�v�tdϸI����b���֎V26���ؠ*�-r�����yi}��1ݖH�e�	���
��`�M����za]�X=Z"�rYN�a�Q0݂(�1{ƶ��*EkU�	-�J!~??[�X�ߎ�`Gk�Z~�����R����o�~�TpEU�H���'�.�|y���=Z������7�~��/ߵa$�:���j��ҧk0�����V���R����Q�n�`|��;��2xK=�$*6ޑ+���[ �v� �_�иT%�nO��2�9 r�ytOLL^�	3PHwH��B����`ʶ�)���Be���0+PxaW䔣�d���d��9	��$�mA
��/s!?%�`E��~��X5��, �ȯ/X@8���1%�bT7N5X}PC��c$J���?��o����{h1�V�¿{��^�ݹ��Z�NT����:�����_G���y 1���J��~�{A���aMt�,��jbf�c$"�-�^���B��n�Aba�w����,�����ZР�>�~-3���n�Dv t�9�����<Gx�p��>�����(z�!�,���	��yH�Y�V����о����o����_�����n?w e�p��P�ށ˂\r:�p��,P���~���@���=6�-�y0� ���H���Z�Lx�Ǉ�La��i��/����X*�����f�}�5��(�m ~��V8҆�0�xN&#�2)Lԛ��*������w���J��d��%T�qviѱU�L��h��< ��&�Iu�.�x�끊�VKP��4����Lx2���~���Y��J���H_�u�+=�A���2��_~�#����g���	��*��À2��2�RMtD�6��Qձl�12I�#n��'zTz=�dU)=w��U��1h qq�vQ�����0`d��D��n������
b�@+�m��}'I<4�)�<����h�%��6e��A�ړ����mfITdӮ��│����*����j7�6�; Bk�U�3�_�Og�L�Z��� ��u���d`�� �a�v��n���	�Ve[�5��Z�{���i`���3B�׏nD����Q����sq���*$�BU��ߏ�ąG��
��@���l �nc��D�]����>���j��]�7k~@4����ˀ�6$g�n�-�ѯ�pS��d�	҂����Ѵ�����T<Qz#-~t.h��ӛ0���=�����5�AW�x2���ȓ���L�����ƝL����.�d�����2uἺavs�*�9��	֜�:4L�^��"�Y\7"
��p#��"�uݝ`\���gP��p�&���ٿ��._[�\F��`��"0�>��v�Qp�3ݞ���lD�:�Qu�g#Vb}��f���ToB�≛���|�E,� �h��Q�"�ԃ���۠z�f�DOhg�	�Yq�.jԎ��i�\/���@�p�H����|�g���M�����hOs7M����D����W���aү,jC�M��~$����w4�vܞ�*�/��O���jkM����X�)���+���HTdQ���_}�"�vp n
OU|��1�U)���$����f����F�	�b1r�
�]��ztJ��N
ཨ�&.<Lo�x�~4S�/}1�̪'��?�)���e7���j�%�GKe�aqwn���[A�����X䄱�����V�����}�2�	g���̌��^����x�7(}�[�C-�H7��$�V�yO�'�X]9܄���:
OZ���XR~��I��:����;��-Vp읠�����#��΄~"4H`��M<��V]ç���k�4 �'�lx{�;����𚞉GY���� O,�)���Z����f?��@ֹ���c絃��R�=,^Ҽy��?_�+������w�'8R�z�yfWg�GV��GB#��2^݇mȵ������l=����\?�;7j�{l"��u8��`Y9$�j���s���jp:�qռv��F1MԲz]����7��4�H?q�92�)�������F�����TF�:�(��#�o^�}_&ygAĹ��ZP���O��1�RXp����S��-8AԆ܌CJb�J��˫V��h���@����~In���]DIT���ɔI�,�+���
e�t��1H��+��k�s�%�ˀ������Z���u6�!�(�D�o��o:��x��$����s���<�T��Lvb��)�Λ�p�u��ʘ����a
ĩ�w����pZ3n]�O[W�^��o���:��W��{��F��� �N�-��<��n�k��:���+�2�u-�w���c8��yc��Y��R&�.¶��<��\c�P�܎��浼x�o;>%�R�=��<�����yYRj�϶֒�p'��/!�$�aG,�	��\1fi���V^�_���IzG�x�^����z���
PW�xʿ�np�0D1��e8�|+L���o�m^W�ZD��7�Op�_�͓�o���	79bo��{�o.�K��^]8�m���P,������=8��6o&�H��nz��V��b>ސ�<^a���c��N���Lb���6a{�f/rg`��7xb�8��Ǹ�l�a�w/N�H8�'�2/�#���G���d�3���!Ӏ�����Aw"��ݐi��͈w���J"hu����B���s�C��d��:ߖ(#I|7C�? &��M8�[8*eC�|��.�V���S�>�JCa{�������'܅]YJ�k�����u��G��ͻ� �ׇˊg�� [�̄k�b��.���:�s���C�Σ58oq������[�X�� eK��{���%��=6�=�lp��w�~|]��ԝ�\���s�y������	�7�`���������vڐ���/Z�~�yP����<z��D��Z[x$�� ^  3��;��<�p��,58��� ��I�	�v��A�|�9h�K_��=_D��9}��o�bG�n�"j����G�:*5]�=��irE)��y�W����*�Ќ�zOpg�]�7Uc��P>W<?�u��y�xP��x�y�^x�h<�.�j1�w�wp�몧�`GF"Ϥ��L[g���:�8�D<�`_ǌ:����1[Db�Σ�U�6�p�O�:�H�c�r-9��W�gk�'�0����:_]����5O�sl�.�.�� z����n(���V����x"^��L�B7n}��6�["J��Օi��:]
���<�ɶ�7͓'[�t��i��n3�]<�1Z��%�!���78_��q�Pp��>��|�g|��b$L�언���:lt>Z��%Ĭ���W*�:W��+j������ni(��.�ʼʛ��}75` ���^k\`�m��d����a��?����8����_:�nh�7&�f\�ʫS(i���k�#���k{Ә�vJw���� |,s����`��F��+�jo��+̳ ���0ʤ�ɚ�N�l�*,�����H��d3�|�P�p�����k�ܕ��:���W�p��������}�g�m�i�62�fG�G<X5��>�v���M8=��;�����&�/S��]t��J�t?j6��Z�����Pe�H��~��X�&�,���b�C�L�?�ٛ�\c�{���CJ������R��O@�P�>����m�;�˞Ԍ�A;�a<��f"DߛD�O|yAP�	�og�+��k�Qy��Hp�`%|�큕�
a�Xӻ��ٻm.�N�KR���P��l��壁8�����n\���� oC@�蓁Mo�݀�J\�������0�O6�� ��@����QK���+-�(���d�*�B�M��p�v����'��H$c�@�ܔ?L؀'
���.<k��ѡ��D@�ò-���zv8�^�&���e{i��Z�'�:fx"�B����܂�����W̓�m40�W��A�>1��o3z��Ԉ���>Z=OT�^�QM���^��V��&\狦:�v O��)���f�2e���~��k��      k   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      m      x������ � �      n   D   x�3�t,(����OI�)��	-N-�4�2�"jl�e�M����VCLL��6�.l�eh�E�Ԍ+F��� ix;      o      x������ � �      p      x������ � �      r      x������ � �      s   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      t   �  x���Q��C��N1�	��D��������TBvT2���:�H�P"�LU��շ�[����~o��k۾�������~����?�����m�j�������0��j����<<2�=�d�T�i��z%��]R�M����h�:%��L4T�Ka�!ݦ>L4
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
f��͞E���?�L��vx����2�7����~�^��#��      v      x���m��E���70*�>�V�����vw��1.���\��.EA��x��������_��v������d���۶��>�r��amڶ}Y�?�-ܨp��ް�e7�t�ġ�8��ck8�6�G�p�G�q�{�yl�%�Ou�S�7���K�x7���8���{�� ���S1<[ó�x���ˁ�ˁ�ˁ��^e;a`'섁�܁=4c��C3�Ќ=4�#{h����f�{h�Z���~�=�`-�C�Ђ=�`��	�}+��}@�s�`n���a07���0�s�`n�O%\ֆ��0�Fz�Ho�#�Q�7��F��(�Fz�Ho�"�a�7���0�Fz�Ho�#�a�7���0�Fz�Ho�#�a�7���0�Fz�Ho�#�a�7���0�Fz�Ho�#�a�7���0�Fz�Ho�#�a�7���)�;Ez�H��#�c�w���1�;Fz�H��#�c�w���1�;Fz�H��"�S�w���)�;Fz�H��#�c�w���1�;Fz�H��#�c�w���1�;Fz�H��#�c�w���1�;Fz�H��#�c�w���1�;Fz�H��#�c�w���1�;Fz�H��#�c��?t�[��{��u������{߶�0�9������m?�v�u��|��'�8r�P�	2%�K�'Ȕ�͔8�"O�(E� S�؊<A����(�gJ!A����_�
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
�q�@*��M�O�b��ȕ<B��u W"�r%�O�� Wb'P,�[�KR!�*��EA�ě���� _�8�4 �	� q�s�����(ȕ���_����|]���D_A����s�[�+ql)����\���(���\��h(?�.�\�=D�Q4�J�!ʏ�� WbQ~��5��(?v�q��0�$zr%.�]y�7j;�S}�LI4�1�:�kF��}6�[V��T�w;��i~7�<*��[��}|��#�~�x/�wu=���蝿gk?��>��>&�ѽ����������      w   �  x����n�6Ư���t��I�]�Ţ�����^([��Il�lO7o��L�E�����~�����䑨^�����ݡ��������L�o��F�W���u�w����ߝ��Ƕ;�[wmsji�Ӿ#"̈x��N#�@86��c�O����<P���DD��F^Z��pUu���S��� �T���	�� �����HcB���nEv+����/F�!"1��w�3Rof'Y��M����ODJ=R���Q��M��X>2 �Y1t�h�HAg'�=��C�ߜ���1��������(غ�C�0Փg���6����ێ���4c�܆��
,ұ���)�ޫ��kv�'���0�a�:� nB��C�)&�������(�{��ڴ��;��;pL&��4��
ix7c�_��. �� ����!�~��$�T� ����]�@������7�f��4�I� U��f�@W���,�q��H�{����Ʊ�_T��\Y��X}��rl֧�~w�Ӻ
�H����D�6���B���LeX� 0<ᐽ����)��G��ĩ;9s�r*Awd�i���ȱ	�}mO��5R�x��Rv�s��j����_ˌ�VUCQ���6`ε�htS�x���`}����3�Ѡ�.�
{3��!�|&3g*c��Y4�Y?C.�3���`F����pa�ӹ�=6���ӻ���Gq�����ϻ��O��Nֳ��\^}?|n��x�<D�s���4� T�w��oO�.��2�nz�~l����~w�t�_��ž�_|��x�m�M��^��c?�%�x����y^}�|�U+��\��a����:�A�����J�4h�Sd8�Ur���Ώ�/��׽�D���&��q�p苚�%���:���,�<b0Q
�� c�yA6,1�G\���paf��
s��1rQ_ P�I6B)I~� ��� l^ʀ ܏T�������}�EMB��5�����S�슥 ���� 	(�� !(U����lӓ�(H��9��4����4�f������������G��q��W���5u�Ԡ.3�
5e(dEI�~��*	�gP��t]�"��$2�MB���vw�����.�$�X�ƍ�`����h����h���[��:��,g!ʵQ�������k+KD���*� [] BJ��@��lm�)ں"Q��H@َ�x��]A�oo^ޘ�]A�#��tWP�H��
zXH������v������L\�\����`#��ZU]�_�'c��iےl�}`����Q��T��횃eA%�����a�A�/���6���x�$;�!�ۯ�f4�N�~I6�NP�k�s�K�/'�^�"xߜ��..Vq%��e�j���>&x�Ô�@.�>omL�x�,�e������}^}n��i�	���B�k��7ϧs���y��_�g�W��@���L�Q,�e�y���j���]�����/4�Mk�L��D�u!3:ച�a�9�~�B�6���8��[8ztiE������	����ٯ}����y{X�ۯ����9��E�wn\�,�o�O��hH�&��it��&ca&��X,w2X^g4�^En���\����qS�ٜ�f����(5;"��t�1o���˾B�٭ἅk?t�ЀH��y .D�'= �!Y��f��8�'
v\V������҇�iC��Ҥ��MHX㻔4�p���l��
��O(�k�*9#�=������a'�ع���^�O�/���P6P�Sn��MO�#1;�29?���i��i9a 3�*P �:P�������s܏+�I�G7X���� �KQP��zF�#���Sd$F�PtK12a�bԜ،�)
2c��k�d�}��o�&���V�
8��,_� �b	����%��U% bV/�H.S�!�ĺ����~��C%�:r�v,R �:>a �:1q��+r�@�t*� �tzbt&R:;q�pi�s��<��%ܔ�˗�~K���)_rKur�ȸf�?��޲���HZUy�*��e��	�L�9iӞ���'�P<i�+�G �n��4��ߚ��=���$��b�
�V�5=9�1��z~3�e��O͗/I	J$�f�����m�]8�(�]���rf`�������7�M��$�RL�<ʒ��Ҟ�e����v�c�Ԥ�HE]O:��D�Jƣ%��dTtA�dRܟ2�|=��6��g�<2�N��K�u�5�k��"����k�V�G������p9�5f� �:2|Ӈ��������f���m4JAq���Y�iި]��j�"ʅǜ'�vC�x%��a��(^}5a.���N�nwl_^��vú߄B���n$�s�K��|d��7�����S�&( /�NAX�>a�, �`��QPrC1�'�4-%�p�9])y�N�J9�+0ؗr&WlP-�*��q���?߿��/Ӹ�X�x�A�����\����6uS	��w�9���&�M��+d\[��8�Q�ː	�����OH2��Ny夜���EO�(��~F��оl�M�[فq�Ȉ�F�1��#��H2�Ģ�b�&Da�4Wf@�3P����53�5�	Z�`���<dJK9�My������hBq��C�&/�f���U���?�;�g������;ٯ0�/�?C���g)�_�_���ȴ�xY��V��Eu�V,\��W�ǚ��4T��RMʩ,r� d�JJ��Ƹ|��W�\=�ZH�n)�)�+��(�A��6trxx�$�H
��� ��rF!����ƌ�K���,�I8�y��	�U�Iy�9�����(M�}����)	�MAX���n��L�?��&s�J��Y���� {6�3�Zֲ���!�G1C�"��ie�B|�ѹ>WfU6$�buF�b2&��AqH���w,�A�x��j߉9
zI�LY@���h��N�@H뙔���q*�W b���DD<�a�T`?F�/�v�p�N0�~���'�S�5+T ��x�Ԣ�L�� �ڞ:[�;��#�ا�Q�gE-��kU.��
���Dta�L�Y֮��e]�����E� �x���L\A�_Œ�4�NN1���y���Y���X����zos�s��!:�,��<g!���n�NNqY"��S%�b�@H�����yiuR4/��QU�$�l�J<D݂/�7H'�D�j�trJ,O'�D��n�NN��� ��k�A:9%
6u�trJ\_B��`]7H'�d�DϤ)�@�HQ��r���kj	�/�)]����K"�m�
8�<P���Jy�!�6n�i��V��˷k�$��U������?4]Q*y7�p�h&癌ۦ�4�����q����{���	��؍���f��U(�� m;�R2���F45��>+���� �위���XPǦ�9��4��0שyCޫ-f,�׉�^��Iw��R�7KN��ϔ��[&��)D��>#g͢��y(]��=�����"�]ޯ�ݮ��y(��c��ȐO�0	�27M«L��wzb���<�h�����ӍNP�%�<�h�����qOX�Q�<��Eϐ(sժ�<�ʔ�B��ɍj�W�l���uMTx�HJ���#�j�Zf����j�w<5��_یջN�Vx�i���K�
<�U���C\�5K �,�- �nҺ%s��.���9EǗ@������+�z�N���G�
"���*W�:��@��ܱЃr�cSgW�i@~��/I��O�I֍Ԭ:6/�.uU�@A<{-Fݝ�rd >��2P ����P�޺��100����/�<
��M���B�Å����%E3�J��I2��������=��cRr$o�\�e���8N�u��$����u��@KR�A�7y� K9��$�x�׮�rx���yM���\�9���{����.�r�S�1������?���      y      x������ � �      {   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      |   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      ~   o   x�����0E�e�.P�E����s�S�~�8��@$�%��x�Fp�ֵf��`\�"V�H���!������}��n�ɢpWu���jO���uY�/�m!��:F�      �   �   x�uν�0���)����?���������M 0��/\]����!(' $��d(8�W֓�u�Jhh� ��*�/��+a	�]��z�q��gHXiVCՍ�1U��۠�c�mL@k�[a�0�C�A����x�<���B��qp����+0C�Qz�z�&��:q
���Z�kr��($I�      �   �   x��б��0��z�� ��B��ZqWp�M�7'��ѷW'L���_��j��S�)R�Xf��l�1/����(��n����;��껷�xHP����C�귛Z��TBe�?��%���[׍ɮo��UFj���g�h�n��d�9p��-��e�L�W?]V�TLA��}?� ��: ۦI��!�A,H��1zB�M��DU�Y>�����[      �   �  x���]n#9���S�ư~���!�s�s�wҥ�WP��B����%Z㸵[��������둿㟶����c�������&��,�}>�{����O/<����Ǚj�R��/<���o��{�(�R͠"���ܥ�nE�N���7���M��^�fe�O��M�e�>i+ӜN�VtZ�֞�᥉O$��x�� ��[k�K���q��o�շ�_W���L�=Z߶|	J����J��b?�U�3\�iL�6��ٛ��O�Na
{?��{�+{?�;�)����S�}x��c���Vo��R&=��`҃�N�vH0`��f0�|̵�w�}��w�����Qa�:e/0��g�T�����v@�fa?������d�/�v�Z|eA7����=���[$�"��K�4 �Sj��Rϋ�����+5�XR��@��g�0��F����_a҃I&=��*G(�vF!������V0P��*�3�����uB5YOH�&빌�$�	i��15���4�5�\�W��@j5!�M+�t���YJ��G~e	�%<��X�bI�%=K�(5��1��ڹ�8JF ��oˡ�Msj_����f��G�c̗��L����6��z����x:$�$>W��>g��HC�9�M��������\�y��co{����N�����fLe�';�֕���tzSه�><���Lfz0���鱇�{x�ᱧǞ{z��o';q�W�0L�+�6E�0���I��u#w�}������l�AUe?�"8��6�����aP�fؓ|�VR4J�U_S4J�UK��q;uV}�VL!G�����M��w����#a6/��h�,�&��J�K�h�TaJ�訒�L-M�_��5O�_2v�&:�DC�=��|p^�Ѯ�|��%���Y�u���T+;�5��h���\�횆�TѮ�Vb饚^�饚^�饊����o`g%V�ahxe����ʾ��)���Z���)�CjJ ��(���cYM8֭Y�b�֬}UXz�,�&��f��A�I	�٤�%[�I	���MJx��lR�l�d�f#%��0��%U��&܆�vCs�	��9��Y��	ȋ�+<+Wx�M��'��u#q�罩��B���{x�᱇Ǟ{z�鱧ǎ�-�{�����j��%%х���&,�:=X��'Z�&h�|]��R��)�h��\
:Z*w>of�M||v�&��HU���%+s�����~���:E���=���W<۝�n �e���z(��ܚ��aƧit��n�.m�{�˯R�����r��ŊU�t�X�_�L5�ƯR���8���s}��&苌wc�'��U�inΪdj�j|��xW�J.7�U�T���xXHM��_����(K�yv��_~W�����7g�&��]��IT>qgן�1r$�P�V�4�+�:(��U�1����:W4�.��a.���i.�S+�6�k>E�q��>�'�8}�Q�$�v��^Y`�Q\.�hRQ��||�SQ��      �   #  x���ۉ�0@�o��4�0���
�A^D����L�W0�X2��&�OE��<�m���S$��d�޻9h�	��W�um��X8�p`����� n��p��-�[ � n��%pK���-�[�n	��ub���H!�r:�&�SK��aH)w6S�|a��0�;H����0���M_��V�b���p����u���7�+���:���.���@}���}��ς�2�߲�Ǿ�Vu����GX�L6rF^�������G~�Cǣ�y��z�}�ϰ�z�����(      �     x����m�0��)������ ��Q��{%΢��Ixz��]R��i��W�C�"���:t�H	dr�� 2��H:=	D�I�$��tN�őr`H�$��	F"��$��l��]-RI�9��H;%�S�a
2LA��@C@>� 2��"3��
b<��$ƓOb<��!ƓOb<��$Ƌ/b��Z%Ƌ/b���"Ƌ�ө\2�&4W���x}�l_k<vxo�]���ğKr[k|��5O��s����:~����z.����r9u�s�_���c��f��      �   g   x�m���0D�PEHČ�?�
��rXe7��c>N�"�Yg��ܭo�`	��>ٚB���jP�#��T3���d�'��<lͦ!�����Qs�M7��P�8�#�      �     x����q�0D�o��4��� $��T��눜rƟ���.�����3��<���x�׫���8b����]���da�4Y��4������f��0����������0[�T���66i�����$��c�fZ�,f�ffZ�zm���zm稱]� ���o[�m��
˪�,��s��6���28���}$�NR]���$�������4�4�4��~~��0����������0[�T���66i�����$��c�fZ�,f�ffZ�zm���zm稱]� ���o[�m��
˪��
��]8�aaap���(z���"��J!���~���Lf�a�i�i��+�d�Ɍ4�������X���b�2�e�O��˖�Bd�22=TF��{#E d,ޱ@���mN��i�jM����X��b6�4�K	pd�i�i�7�4�0Ӳ����h�8��Q㰷��o[�m�]�mUXV�eUX���������ߏ+���$�&�K��e����=/��4Y�,���}�|����+���޶��yx�      �   �  x���ar� ��S�逄�!�	z�s<��"�2����E�/��`vI���Ke�K�g�g�I9r?Ŀ\��~|s������Ip!A��T��J�(1*�����K:CIg(ٓ����	B))��0��@J$9��@J���d�&���@v��l΄@}�>��ә��θtM
�E���/��i)�KϤ@��|��ȑR�H)cT�ȑ.����@Z�0f\�H@ %���m�2a�hWY[S2$���DJ����j	O�'2�<�������'�I��1��eR -���P�	�f�*�R)�P�Bi�|�(� �-VR�!�Ѥ�E�*�o��N7�P��d=)������=S���H\���QB��1 �a�1�8�ϟ�#�F=���8�B q�@��N�dh#I:r��@ٚ���iC���(!K�x���o��q�*vA�΀��d�!
�1��E)�*�b��]@ %θ

#��JA��
-2�kgQ��k��A*������%BB��hF��eh�P
�/��)�9�\
�ȸȑS�8EK�9�Q�h�\-�:+�r�1��
���Jg��*S ���>s(�����I��㾗I�9�9j��I���>$%(��8 ���┒¤ ��1Y�au�f܀P:RR}b;��Xg(��dc�q�3n�vF�?�� ;����*�xZ�1N=㑗�x�%���X��}�{~��%ߊR�#��u뚮��W�=﷬G�zŽ��8Y��2N^�t��8q5����z�:��:Ǌjgmƭt�#/��lݺ��:�3n����ӗ���sc�jݺ}w;���;[g�J�-��~��>��-��~�e_�,v�|h�����+�]f|���Z���"n?r�w�n�_۶��i��      �   H  x����n�6���O1/��>�Q-)�d���5�5Q#��Pd߾Cl+I��X �N���!g��;"��������b�i8���X��ǞY���|�{2�Y����=��m����$-��k��ÉHq�2H� �\6z������x�ǟ��� /^���B����!`��?��{���b{5|�  3T�y,��kq�Dj�<���8�($4��v�z���9��IO�N	{?�P��+s�
T���=qm���?������c��A�M괺��0��m�ƚ���l{f�g��O�Q���r_a��_)�l�|A��?RlB}7@3K��8��񪓆W�pzث�Nc�둪�jw<�Cuڨ�,[��
���4��7_�ؾ5�����\������K7c�'ܰ���k�/�lŨ�?1�D��#$�c�B�\Y�"l��f�x�L����?��x��@�R�O����XE,��?��l?�d��2��=�9h��7�w:�<#u;�Ff��v��|) �e�ъ�u;S��I#�Z��q�j���Z�!cJ2��+�A��.��ծ��+�� ��$�䆝u�ұHe+�9mlw�&	ee<�2p�ŋd���sF3�����0�\�s�x����g���A��Y@E�C�
�'$b-�"��hl��W�����$���B򘬆]�`��fڮEx�f�(�Ճ��MU4���i�q�B��[|֏f�.I�j�;g�Y"c�,�URm�?� ]C��Ëq��
�B(ӕ��d_0�B��T����7��ȏ�M��~Y���P~(3 !��G�U�1o�m��6��0�P�
sSa�!MXiTC-�j������m�F��!k��=�;��ˬ��$�}$�53=�S� \�Zp���J^1zLi|�R�D��I��Rk0���A'7*�<V:k�n]c�$��W��wP����q�q�a��%Xbs���HR��C�,M��!����KL�����v}/ܱ.O��}
e(�I�E��e
w��)�2��rcHU��I�D9�	�̶�O8�3��n�J1���EU����{�cJ���z��X�gҳc��V}���?���׷}y8@��E�!�&�y]��'dt�z��`���p8�:y���؆�.Q���hEUF$�Aw��H#���g���C2?m6P�O�n���f����̗�c��
Ȑ3���r_�}b����?��K�Q�п�%�'��_'����������|���)S2/ָ����ew�b������/j���X����9x:'�ek@�xhip��n�g%�t0bIC�MX��AH�Ψ ?���Xf��j���k�PCe��aT~ke9�ᑻ�q{jbE�/�ñ�ܬ__��|�A�	���D�{$7$I�9�keC�Q3�ΐ5�D�ӡ^�6Pg�!D(	Q\m���	a�������ج�@%��?�[}�z!}���u�6%nrtv�G���m���js��ݠ	?�F_:vgӗb~ڜ�@�����	�����|��Kq�|���S��+}dO���[˳��l�J˅�>f�nety�R_]n�z"�	�BƔ���q�ԩ��j�ƙ�=�9��3>�>t$���۷o>�z      �   O  x����u1D��*Ԁ��Mr�H�J�l'�y�=3�@��.��]>~]L����7���.�u�v�k&E��2�@U�t�ħ�`d`$&��w:�N�|:��y�8$FF6���&FN�ᘁU�{`w&vR��3�����'����6ra�
�T8��{Ma�4��
���0߄�1rP�)FF6����y�9fޱ��u�|*~}�fđ\M���OW|�c/vH`5#��E��hߢ�'��Mn�v�����Yi?���Y9�䒄�Rz�<��@��;�y6�$<�p�i�d�䨭���G�&�qFg����č����nq@7����1�!�M�^���3��	�F.B�ci(0kiXǮTy��{*w��~t�h[������LP0��wF�U����P6ZU�D�u��3� ;����w������Qy���ዲ�93 ?�,
�3к��\��� �9�u`�)j"t��\&&+�s�]�l�O��0�tL�R��酑�������.7���E]����ے�Q^2�"�4�r)�~��8�QdQ`�R�t��3����ħ;f����Oǆl������(qF�3J���K�X�ĮK�<3_���]	3_����f�0�o�O�Q�=�	\?�u�	��Yp�Y6�D�Z�}Yѝ���}��~��t�҉�sG�\S�?vV�W��oB�.����W�d[�#m&��C�mW�Rc�b��R������K���q6��J6+�vfIS�g��`����w��\�ኾt����H����0Vn=�\�2�i5�T���������3�ᨴy˥����t�43�w��Y�T���oB|l���7~��n      �   h  x���˭�@E��(:��C�D��c���~�i{������A2x�  9!N���#��Z�'�TtBxР���J=xP�a}�<A�cr,�(J�V�[i�%�f:z�&�T���܊�'b�LZVE��0Z��dC�J>��c"�l&�k���Xɢ;��u�))��h�}Cx$�IkF��4�C`�l�@K�!=*/Ru2x�]_Jߡ�ʴe�=W�'JH)1I#t{�V�EJu��nO���_���I�a6�&��!��B�����T��0��c�_�@8��Ў�Yx��T��^=�|�\:�I��:zA��r{�ρ�oj2'iu]���xi�֖/��t=����(;z�k����z�?�8��O*�      �   w   x��̫�@�a=��pK����5�	�4}|H�����1��u*T�k�>�8PV�RqV�\G�&B�D�����Q����i�&���<�U���{�M8��؜�K�j�׈��q02      �     x���͍� F�5T��ml~�x��:��Di$�-9���`"E�6ջ��쒱m��>:��~>ߺ�Q!�d� `H1'�
�iI�T45� f# m$�ˑ4R��F�I�u���|O �� �'� ���Q �� /#G����4�l����3�ЅD)AFP'�	
�Θj"E��D����ݢ�̩T��{G�rT0�:��ύ�~�:[����!�T��,#�1:�W8�WRU�(k��i`j�N�����n�K۶��8��-���8��:/�[c����?����Z �DC      �   *  x����n�0���S���s�rW�%(���n�#��ɢ�bo����Eo�A��|!�?�u#R��l�C,�T��Ǯ�N{X���v�	B�ew:\
�i�� �B��k��Y��LcJ1�$�,Ģu�G��Yt��������].���CÛ���ѡTf^Gg��z�Б��ލ�c7�{���	cf �k�k
���)
S=����C����o�rՔF����Q��E��펪��CmBH9��!a!��U�`�)�f57uSW��kt�G��C=��݂c��_OB,z�DQ�HE��      �     x����n�0Eg�+�2H�eis� ��H�-k��6����Į�V(���8 D�O�,#�\tÔeK$1��_g��}:}�?2<l�{��6�����#��7wpx����B�P�s�D��e�B�ET<�V�a75�vZ�n�Zh��1��p��X���P(��@�Oه0Kd74�U��/^�R�Ҽ�%\{�e�5��Ui*,��=��c^�.4@�j�Z�� ����A����:!y
�1�5l��S�W�eUa}�u?@��      �   g   x�r�500�52022���Ә���GAW�9���W�����1D��?�߇Ӑ���F� P�������g�'�(0O����������S~I~��!W� a\�      �   �   x�36�r�500�52022����34�56�4�4T�UI-.Q.-(��L-R004�42)��?2@ҧ``ie`heb�gllaba	4����E!0�1(�5�3��Z#�1H��A��&
��+F��� D~'�      �      x������ � �      �      x������ � �      �   g  x�=�[��8���brLR~�e����.��#��(� ���O}���K<�K��G|w����ao����ao���}`���}`�gcϣ��}��v������=Cm@�_k�\���j�����g�ڐ�k��뽠���\�TB!��<F\�ϝ��(��(��(��(���u����@�<}g�mm	mmm���֦k�	یm�6g����&j3�g|F���Ǘ3����ݗ'�fy�y�[�O����$�L����[�g�����7��6{�h}���=p����T�1�ï��v�)���yr���:6�DG���C8tC6�����{�w~��wy��wg�E�����/��ǈ_�V�V*SG���?���Y����G�:$�H����N"�,z))
������0�Bf�U���W�c+�V�Z9�rl�m8�r|��c�^9����>�7��#�;~�t�[q��{�'�{�^��{�^P7����x~exexa_�׌���~�:��}��S#.�Ⱥ�=���ϖ\WҀ�(�Ռ*�=�=�=���$�ݎݎ�NVio�H,�d6������5�5�8�������R���x������ֲ��\�5�3����(�H�(�H��\	�D�E�E�uB�w�v�vw]�I���*(wA��b����mXl��=�/f_ܾ�Oq�b	?���(�(�R\����F#9I����l���~R_��9�͗����z��4���1O�#��|����p���>���{pr���=���=�ȇzPG[��x��`l]��-��5ck]@��fo��:�@��4 ��s���go��:�q.#����[3�fl���ޚ�5{k����[�tP��[�؛�H��Q�Q��4(P�ܨܨܨܨܮ�F�F�F�F�F�Ҏ@�r��A������Ġr�r�:����O�s3"�� ��,�Y,�Xf��]��k�}�HYZ
��M�` ގ�r0vBd�ʳ�h�%��mw���yȌ&�&�&�&�&� �v%��5�O���%�
jj�~ҵ��~�/9!!ΑfQ�a�`������J�$}�8�����Ɋh���-[n�:�T\?�P��H�^��/�Y�|�|�w����u�����VlKa�Ga���'��������,(=w��Dʀ؃؃؃؃؃؃؃؃���M��ΤGE�A�	Q}M��>N�7��D�����/�X��Pc��J{���HK[�a�a�B�e��,X4�h`u�jXX4�h`��B�E	�%,JX��<{�U��0U����t��XZ���?ͽ<����ǫE�
]��ΠrF���po9�弖�Z�=�y3�\o���_�/��;������������?���|>� �qBX      �   �   x���K
�0D��)|I�|�Bp�x�؁\�-]���1f�!�{.p��hrZ&�,�C��YRr,�my�rp�߹C������Ĳ�!��6�����I�Wbq��ǐھΗ��&�LJ�r�cx�!��-_�      �   O  x����j�0��}�I��ķ���v]��n������37�5b!ᯐ�E2A��~~����2�䗀K�QBNX��#sA�y�h�@w�=����1~dh`hF�����Ȅ�	��82<0<��������:P����S�9y,J�۟󲦉A�0$�F��{\o�0Md���0k�<�0M�3�a����!�ʂ�ۜ��l�k���N����v�`T`�����Q==�(�`�����o�2OIF��=��Qki��B��'���B�h���cK!U4X�bO��:jv
�TQ�_���~�(����B�_oAJ�;4,��ho��*���KQ      �      x����nɒ6x-=E\Π�_�#xSd��pr9�H��H&.���1��~�na��#2�<,�FO���*�5e��Ŗ�>SJ�SB��ߥ~�D�R��iK�j!tN$�}[��fT�n���G�?PIH�Ee�t�_��{z����{�=�ߎ?����������y�����wRE�VHya�����uN40p��(Uo!����7@/o��c���r8����/^ގ���^��c1�=��ӱ K�;�5]�єU%U�������JA�>��c�~Q˃�'��n��xO��P���ʲQ�6'��=���L?�Z	-�����z'�ko�w.���^�V��VT��D�6MUz���$����I�ק?�a�^�
m�o/��{�+�\d�Ds!��NglNĝ�D�^т5��&|�����p�	t����>�|��#֑���\�
��k�g]�r��D���V{�&�/�Ň�v��.6���܂5`_���1e��.r"�>������}Y�}RHr�9��yn����r"�'*C�$�=#�ؾ���i����~(֓�vȘW�Mq��-~p�[F�w��
�.�ûYʺ�2'�=T9�]�v+X�J(o�f����}�����y_���/v?v`�{%ĸ��\�#��R8kj�1V�*��ZXNv�������n2�Φ��t���ڛv�f:M�@z��gT8e�푈����������{���q|^wo�J������,��0�B��k�Q�s"nAnAa���ٿ��-�y� +{9�M���t�q�..g��ۢ�?���n��-���ަ��K�/몴���:'��De�h��	�m�]�~�#�Y�����;4���� �k�qd�*U+�1{!U���4V����tv���]-o��Z����
�������o����N��xW
	���D��&*'����UVu/���܏ק�=�^V��XM����U��a0u^���Deh��%��SBc���5� ��ẻ�5"*�	c�ɘ����G��;Y�P�wCG�7���v��J�Y�7cF������M$x�������u��V\�~�߸��z�=�?�C�Qd����%��6:u䈈�ֈ
�����"*���V�o
�tes"�>!*�}��/�t��]�7��Q��]c���+i���{]�F���w��Q>��������%���v���Mb��4�=4�����M)�SMF2�w�1|��a[��(�������������C|M���+`�+�K-L�3�<�1\M�Nw��p��;�\�/���v��/���Ѕ������+,�Ή8[���4ݚm'�v�du���������/�Y��L�u���U�ɉF��X�	r�	o�L�e��]�R~;�c4o�ӛ��XG7Mf9�tڕ��I�;q˙�p˩�Sᅻ�nVmXM\<�����T	���6'��JT����G�]wfuvG�{L_h���r�kr"ήDexQ�]��p�=~�?���};�.퇐�8<�o�����Ӈ�v{l���"=dR`�����B�'s���C�����hp�EQ��W��b�����R$�{R��=p�;�������C{d֞_ըJ�E#��*�=�����[�>C���d����֥2UM3���B�
�E��2�.&s���,~��ڮ�
1Vg�����R��nr"�H$*ܑPp�����?�b�o�G<�iֹ��YU�]��{n(�.Qᾮ�}�|�q(ڗ���|_��W�p�ت���T��C�1�p�-�{�~x(t�����_�#б1��g�^�����=���w�
��S�̈́�w5�[n�u��	�o�����z���߃qdk���A/�X6�ʉx���FV��|;m�ԫi�����&���K�[-��7����+�)����D�q!*�q�U��=�������!:,FYb���m�Or�bd$#�o�����ݺ��?������B�K�[��}�aZ�:'��sD�d���s���1�{o��l�
��%`���MD��MT�����h��ޞ���{L���R���π?k�4�ED|J��pK�$,b�d����lq��6@h���=�����q�ɉR��� }���	����>%�g��
��� ����9����4���D#�X�[--�i�Ղ�c�����_a�&3�:��]�C��C����c�'�~
.��WM~	_��'J���i�����
Q�m�w�%��z�=n&G!:4�6�rY��$*�QB�Y0jr��v�i?O��v6k�<m�-G�2pj�ARM�H�@*'b�Teh�����i��ۛv>o��vz5�};^]�&�ڹ���l�kWcF<aK�'"�IT�<;*��^���<��o!�(�".��~�
#��W��k�2�[�B��D;p�+�	��2N�1����1��>��_���5�e���,;�Cn�ˉ��%Qa� .S.������5�.���*~��R��!0�w�3HL��������BH<�uU���D�5��p��ws�%{5��S��>�������ooi�)�a��~�H�ױ��^����t�����ݰ�&]�H����Kx�J�D���
W��v�¢]���\�M�e����χ������>�U�fXL��whEcr"�%#*lmP��`V�~yxy}��ڽz#Z���F�Eo[+gs"�Q *à���~\�x_������� Ɍ���'G@D煮h$ �U83��*T�^^�|�6��;��������m����ʧ��mj���;�¦��\����ު�w_|��f�����T� T2'�k~De�ϧ�>!<�_��?}�J��7�wP���2MN�S��Ӧ�Cs�4N*���J̴A��Ή��F��U��������,�vǟh�����c������T�V!Ur](�7q�q�P����5�Vb�Ѩ�����Wx���U�-:q뗨0�'���7�?�g�x����Fj�+qL����$I?�.Q�]�h���l]ݥ]l�W�����_z���mo�-_M���#CS�|G��C`\/'����U+Rz�ڶE����������?�-i�H9#�r�Bd�0p~�62'�N�қ~�\�r��)�^�{|ng�׶�p��L[�>x��b�������mߙ��n�A�>:��>c�H�3V���>ד�e{�,����(��ҷ@�sX�>,=����
�h�e#�D��=�������0~xi�0�JE�b�.)0]qF.d֨C���4F��8����;��C���S(�����4�Ήx(Qa�,>��d)U4�UN:�UN�E�
�,m�g\��K�}�]�~	�r"��&*�}�t����m�p��
�r�/q��W�J�1�h�@~Va�L
k�� �gD�~�=�z�+x�l��$">'IT�Փ�p8�ڭn[c��Kx��p�`e�H+������1�69� &Va+�p������Z\^n�s����q�T&��ayP�
WP�tZ$"�<HT�򠪻yY���};7�����p��ʌ�s6j�6���x�9��������m}��n�hU�s`�
O'|��(����33Q��ī&\���E��!<E�<.�����>E[�����h3������c�oIs��E�� Ѥ�i")��*|y��SyFJ�1��l|Uג"$SgL��c!��3���*�&붸m��3��V�ݵ��^.�>Snt��*w�oY���%��:V��jI��<w��������<a��uN��ˉ
W��K�aM6��z��&l7����_��?��Ҝ�Èx4��H��/�`LD�K�g��r�º�)3�s��nN-�C�2Ҩ��ߜD�ۜBu�Y,լ��tsFu���*94���5U)�"�Сh��sR�/Ur4���J��UW�+�m�q;3Q�*9�T�T�l�麅wƟ�y;�.���*Wm�5�}U�T%s"ޗ%*���ߨ�6�v5��%)����-�}ݤ( "��D�[:��|	�u;�o��5���v�!d�~	�9��Ep�j�    }
S$">�IT�c����X��+������$�/���d��}��P9̝�D| ET�$��}f���9�d$݈*�f�C!��I�����D�A!����a��gw�Y< %M������P������d6B��YxD�cqh'�8���=AX�w窅�=��,��n�ح�?��V�ƹf �"���X�{�}I&~�g%�:�B��L���{�cph�l�87�:�� "�^���+k�H�6+�[ߥӹ q�C��VxH����t��8_�2n1YRG�&:>w�7�"�͹�C�7_åH�j2۴k�֋�kn�.&�9�	�,5��z���MNěJTXSm-H������7|��ܮ�c�WQ���X0p�&n��U���1�5�A��%}�}r��kՇ��Gf	���^O�?.˲�M�er�}���7�3x�\kl���i�s">�ATخB�Nq���MaI�uQf�q{7]�[j��]U����V49�l��k��@�.�]ޡK�~]�
�aV6߯�E`p����*'��*��J��z�nګ�V�rП�t>��c����=��F��X�ֵ �>n�v�Y~��1�]N;�_S]Q�{�|��CTN"��P��J�?<cA�{<�~��px���bub ��."@�� Qa��f9�dl�	*�t0`\N�ْ�0�	Wk� �I1�}q�Y�ȦΉ8[��_'�o��� i������oϯo���������c9�~��{�]�Х�ZL�׀��dE#���
W�m��PK���,�%���>�����p_�q
�Mk�B B�����C�
\�[ڦ;���7��H��78χ���5�b�c\�XI�qf&*��τ���N��a��}q���]��� �S�耍F��g�꺢&Ɵ��|���)4�)K�m��.��v�
5ZG�����o�y;�M׷��+��x$B�˪1M�^<D�_<D��xde��a��E)�?VF�xU�"���ڢzR(�|�t��]C�'k�fY�h�b�����w����wXI"��5� ��U��
9�h!�2$��"��g$����߉s$L��58릖���)��fi:V��b`Ʌ5�zJ<�uU�v �E#8�X�e1 G�k��\�*#R�o,�+��c	v��㿁���q��^IW�)F������5�o�1k�oL[����g�}H�ڰk.!l�dF2�5i�]�J��>C`���� 	T���ꃭu��'����
�j���1�T�sZ���������P��xxi:Wg,��?҃�3�2 �`)���k���2���	 �hE������ݡ+��R�j'*O��u���i�YM}�"�*�
���PX�UN�_�D��������r>��<,�]\M�����X_~�^t�p����*����*�B6'ȍG����� �*!(���N�L�ZKF�"�>[u�I$���q�'�S�
L5�m鋡B�BW�dE��Գ
G_���qӮڻ�àG����ܸ��������:I�$�8b�­�4U��Φ�X�U�}��K��5Q59�/!*,�D�s9Y����_mi�/uɱ�^=���P4�ތU��4i����o>]�ی�U��ޠSg�u=(Ƣ�*`�
AZ�������ܿ;^�\�Eb�,2�I�ʉ��Qan������w�>jp5�fͳ��=]Kkr"�<�ge��5ģ��x�?��=`f!�Hz8�¿�\��p�������;�e`�46�+��X��W"M�_�"*l%��^�ۉ�}_�~�����W�;���d��NN�^5䲢�O��pY�J7u
�"����X�7��[v\�t�j�e���H�8H��+�MY��U��S$� =b��MFbQ8H��m�ƵZ}n�`��v�h�^v=~���c�3��Z�\F�;H��)sVwM�/�GܓH\�|(�w�ק���O�W��2�W#�D��R�:�&��*l�Z�]����秇�O�0��x���+E]`�P�ߘD�s�l�[ՠ��*r6ҧ��n��~59>��x�Ѹ,�#�tx9m�e5/��yݯ���=�^1�.(�2m��]��5��MNĳ��a��wוz_�/�Gf)~#WS��Fp(C�$*,dO֝㾹-�G4��A�#�G^[����cdz�bxon>���
���|z��"s��z-�"	9���H� V�u�r�?�#��9<%��"O�'p���G�y��j��m��{~+��v��sL+3��x2���NeE|��p5h�^/������.���"�o�h$����ʓ;@������6۴�v{5]|[�|4��ծ�Ht��D�=MTX|��}24�c�(���Fe�XqӾN�(���$"����pY+�IB������������J�1�Gwi�ˊF Z�
c�Tp����?5y����/.���iǔ���L�!��4�<��Qa颬�gh������(BȠe��}��w4ۜh��X��������b�٧�z�L��mB�s�U�JȬ��ì����a����B�8{0{>/���$�j{_���2��s�5\��D��"*��=iB�o'WӞ4�ʴO`�B�^w	�րJ/�P��*\^�g�����\��@oec3Vj<��d�l��$��u���F�����>M��g� h�xZ.'�j}���B!�����_"Jx�gG{�Y5Oz(���Z,ɪ�*|V�u��O�t��z�Uwa^�K9]63�(�>m�D�ƕ��u����F:Tb�Ԉ��R�ߞ_��I�W*��<U"��fE��D��n��j2](��ܤ��cUlY[!�h(��f)#��#��d��g�w,��x�JWMN����~Ǻ�+~��+�����%�W��|��|b�ŏ���wSg�[�.ka�ʊx����ݘ~�@{��pŏ��n��ct�P�{�b�-�_�C'5=*IFL�Gھi:�|�񔨧\]�A����8�PD��kiH�F�Pb�Et1r�{.�`3	�߬t�'�&�X�m~UW}9q��b�^d�²AU"�!!�HD�UD��
B��	��=��w� o��	�T��u[�����H��0���XP�}?������(�\�����o*��R�H��p]�JU]�&P4c,Rc�G�]�2��e@��S4��E26C�N�󮚂�} Q�E�JT8� �Ǻ��Kþ~��a�������!�F�հ׌_K��HLrX�ԀǑ���%Q�ֲ��aQ��Z�e=��2J����D�
�%�ld��3%h$����V�Ήxώ����ҍ�i��vT��裾P��f9+5~Q�NN������
g�:%�|�Z1��yu]��<~':�\�b���?0�iV��=�6����Z��{�������#x��߇����y�ޮ�z��9���xʑ�(�>g�}~3���)��1�`+�c"t�C!#*��7r��z����ݥ���e�y8�Q��(����x���>�p]���f�����d6㇜I����+v�UC�X4B����)+ݜW��@�n��Qp@�0�
TU:W5��F҈�
û'���B.ޞ�?w�v���|���Q���C�����<��1D�E��yv ����N� Ur��t��~c7p�bшo����Q�XV>of�/1�X�jnE�Ɗ����X��0��	!�U�$�;���[ *��-�'"��7p\����.�m�i�p�*G��R	)��"y��"�K�o�o�mDj
�D��
k�U]�{p�(�V ��1$A���E��ET���*s�i�A��dN�����9%����]ET����l�����[�G��t2�q8#�%��H2��E�ׅ(�sv��:5奴ȷZZѸ/%�D�kt����j�=Q��C��y`ݟ����G������H�YySK�$����U�{D��b��-� ���)�m��F�"�1 *<��i���j��o��lblpe�<mqJJ���̋�[*?�D<�����G�B�c    o�0��,�����p�1���p�'�gT�2\\�JH��>;�����٧���k�����U�o=�ǖר�����
�!�ά(-�z;���}����*�>��R9ԗ��gFA�'=k�Wx�|;�Q�}>]�����|�dmK�5���"V��&z�UE�t��]�(wUUI�M%#ջH�/�YC&J�"3VđzvZ��Z��/mR"�Nk �9Ѹ�qRaw�U��ם��X��*����L=w�`_�k:�������ԙ��^xtK)rc�D#p�X����	�b�˾��^\~�����_ͯu�|���jc�ʉ8��|��v��'W��M�h��]U)��
�A֕6I�i"�qfD�Ǚ��Gs�h��V�-���֍ЉĢ�}����F;�x;�k��#�ֱ��EY���:'�#�*<ɚi���]mXS	l+����K�W���?Q�L��i����4�o�	���_M�Lv=��8A�'��?:V�G�ۓ+8�]����������%1�G��*���H2�f=i�C0k�9���������h�n�����$Tcc��P�M �����On�p�`M��1d��P��-D�M��B����)�MI����V�#�A�]ܠ�߸���g���ӈ�R�'��W����Fw���QC���|v�M���j2m!"��AT�
�����/�֓բ-�7�
}�Аhƭ<�r�+��Ɉh�a'Va��p��9C|�&�E����htZ��%|�"�`���+��׈G��������
�X;L�˩*�G���dG�	1�콀#½px�N��'�dA�(Dɲ�N�hL���A{�O#�~$R��i��oJ�*դ�UD4r�b�ȩnE�� �����&7�;
�ʭ(+[b�v�ц����Wm�p�����l����b�8(W5��	���U=x���
W���$=�y�uy	�ׁ)��4*���E�ʚFȜh�pQI	?u�fV>ь��T1u��B�S�D|^���y!��0x���j`�<��`h�����p�>�,����0�^8O{��� }��B]u���o/��~�27�=�?��ٛ2K�S�j=��ID#d��
�c&��&m���:q (s"/a��UX@����T�O(��A"2�JZIb�H��p�F�:��$��Sc�����E�ԖX2�}i������KM���|+�YWɌd�Q2����pN�)F�8��aa���L#R�����ʦ@>"��zD����%e�]͗�v���\��P��Gx~�|r%!fL�<���G�`�;'�y��u�e:���v�5���4}�r�n�s">�BTXN�t��Y[|i�7ߎw����d]\�Z�.��f��������"��(�sq|.<	�o�0�`F�����*��L��� ����?o�_e�{yF�ݯ�_�E�q���b1C��A��a����釢��[��f�lun���\,`_p97�1���4��Ӄ�@D#9�X�Ϲ���#��F��h?��r�j��I 3T2�Ǌ4�4VeNT�'�E��BJ�b�޵�+���]g*C�y#M�eJ+@D#��X����{K��FC/q�A�"/�1�#�q�-x�U�FKD#-��
���ߧ/�O��j��X���v�����C�VDd�T���J-�%���ۢh�"���r=ٴ����^B����ͼT���Ǳ*��M��D�;�D�u���]KH��0./P�Sd�I$�ǹQ�R�ˉx><��Չ��E����P׃\g�#|�+|Q��U&=MD4��UخDUuX�/�b�]m�ȧ5YM�'��7x�9�����pQJw�̉��#*���ZQ���nўJ����r��c*-h�j��/p@t��n��h�ߎU�N?�!��6����ز��,�珃XcRx!�&Q�`�U$��ɺ]lNۑ�ˑ��a�����'�*l9�G�h�BR����ϒK
�e��4L��5�ٔ���'������p=��@6���=���B�Sw	G�3�-����:�O%ټd~���.8���$���xj=�2��`LOI�|������=��ٽC�ތ[���
�EE��E�GOT�V	_3������}q��O�?�|��p���	�����.#iF�4��IBM�B���]=��D�"�}M�׵���D#��X�om��C�[e�w�Co���Y�u"<C���8�z�g��D���5uh�=o�BEb�h7�p�{��:�D�2q�n�Ɨ@�N}V��%8[H&�a�g��p_�U���P���?�[�ʁ�$~x}�)�L���)�/Ȱl��Mg,� �#�R9_�!*��V�Jє�t}��0��즈�WB�p��T�m����U4�KE#���Jog�XӍ9j�?��)�(����5F�Mc*3HMĢ��D�½`5\tx2�&��U�aO7a�[��#�`�-'�6a��}j��t�(�T���~P���ԡ1��nr".���p�	ϗ|��p�������9��s��-+WR:���F�c��`�r�����GU�*����b��w�wQa��x�8�
�+���|�
S���[U�y��O��p��O$<7 ɐ"�s~(�(ES7U
�%���N��t�hh8��dY���U��AYa<'��{������W̢����b���h2+m���_4�i���Qa
Z�z�ć�J�w�PpY�ɣj���W3��!"�W����<�t���Ӊ���!���L�lEL�F�ec./O�s�}�W=���?u����,��a6&��1�g��!}��e�¯eCQ���������|�ޮ��&8d�S0BI���z�%HD|OTؚ���I�zUL���v�&Re,	U��'&���E�<��2��$"~u�
��Z���o?c��v�]��P�F:���Z���ȃ��G.kӠ�c0�t���6P�s����!3)z��F�vb�Q�21ע�+:�k��O�5�z�����
�"�@��heW�~����?�9*ik� u�����:�49�HZ;V�y
���O+7"���a˳�zda�b���Z�ڤ�"�/D�E�g�u�"^�˜q��W����LE#e�X�g6�,�oB���dn��3���˺��񧝨��>�tu��H�`��)|S0$U5�">�DTX0�꣜�]6k&�Ti4x�*'O}�Tx6խRt���cs����Se��h��RK�mN�}�D����X:�闞�������DmB�FI:(����*�N�@��`-�]�z?�C���0�	�?���3B%���E��G
엗���7�����%;�k��R讪3��qU~� ~m�"�-%*,S�~�N=��|�3�c��F�T{�a'didE�&E|
��p��=6��o��o��!G����sD$Yw���$���q�2-6����7
~\��""~��
���@���v��x�N��Q�6�20��49�+Q�A�5�TXc� ��	��\�!ך�|������๎$#�u��c�ɢrwbAX���#t�-��T��Kp���9ш���&Zmz�Ny���~l{���#�i�x�)�NJp��H��S��T�3/.�E�x~��w�v�³�}߽�ѵ�a�~��%5zA{�.�=mj'��h���*
X�S�������@� ?��S�/ϻ��#VT
�H�?�44xHE#��X�[�F�ET8+W�gyM?����2l����)�ŷ�O����G��2p��(׭ԩ��J�3|Е�z�(I$�?w/�acB^E�=�H��dN�w0��	�E���c8�����3�d�)n������͵Cd��5�����}w��с��MM�s"�듨�]���}��qG�9m�����$?�B5%���Y�f�¹lL�];����j��dQ|Z.��;is!�G>Ⱥ�l�0�S�(j��y�R���z��L����H&+%�5��j��:�""��%*jBZwn8��2��|���gNA o�̃hAQ嚣�� K�4�6'�6�U�v3�yn�t5����C| ��a9H[�@��f����r\M���    7A�$�K����H��D|5��0�8b8�f�Y{��1�C���K'���2���d�J�4�>k�A��Ժ)��H�/Ɔ�B�=K�jg��h{���=�c���:=q��YQ������KD�@k�20}��z����&�$VE�J�k�q���Si�����LT�Ϭ�(�������?���y����UC9�R�.cq[5�#������"*,M�1]+�O�b�<�x��;���:�#�mi��Й���/�.�Q��L���d]��g���-?N8T�kUB�J}�O*8�'�ٜ�s#�a�O!t����
^��O�*C�'*��֔$q˖�0�}��t�e2M��T�������F�Q���{����	�cv��1��i�i�=�Nث���tZ�#����p=p�Sݑ8f�섞Y/ïnT�J׈*�"E���Y�[,$ �X�E���|E7uMGS����[�³����ԩh�I#�P��*Q�90"*L����F^&k��"��0P�D�-D�����oK��� V��*�Z9���`�6!��?��O]�v�s���A�S�4M�+�9�!t�I�J&�����t���|1�&���7l5�������v	����%2��&��'$>>A��E�[0���4�Xd���&I�'".�HT�b�6�VJ?�,g�O�k�,pH�yoT��hjW����D#��X�o��-�/����}A2����U��kyy���*M 1������&����=�ŉ�/�od�p�
���D4B�𴑚�C���״c�>��#��<4'%M0����^�� D�
��R�N�Z�d�y*�#J��F�pU�������|�n�zh�0��YC����L���H���/|��}��=^�u$�>��B�1vW�.HD#\[�
ϵe�d���)�n�����v~V�g�
�4����a�����!�#@!�鍭sik_��i��rtnD*�%*��H��tu{3:0D62c�����K`P�h��U8+��:�q���,��r2�9�uK`�u)���F0&�
�1і�����L\�A��r<FW�H�D4B�����۟7��r�}�<���R:(��fI�H�5y()��*|�U�S���Ԋ~�^���\�d��W,}۞Z�=��'Qa�Ot��34[��4��׹0�w�S�����h$>�U�L���0N�i�5�l�p�T�+OqX���5
aݠ��F* �
����`�r������݀���kr��Ћ$b�*��h�*lOhDtC:r���k��Ү����b&���&�R��G'3�j�U	��R�*�n�
�*���}��9���H!���Y�ࢂ=a�r�Ģ�X�5�Ԭ�ە�DA�|":�ڜ�����vY�� �"�R���3{�Ց�h �˜U���ꞃ����&ź�����uϧ3Yw��m�a`����؛f�����0�����b�U"�p*����^��������w��2�:��"�ډ:��%"��D�3֞@��{_������{
<�s�s�-=�i:�HY�I�D|wQ� �郆�$�;�VlM�(ZI`����k�5�Z�"���ǈʠ9�	��M�_���k����2��?�vǲ�|+��ϻ�h�s�<�|�޻g�ĝhE駕����"�3L�F���?p�=�������e��k��LǇ�]5���[��F:>b��C7���]��8��������Q4��q��<�oy����H2�݊4��n�HZ��8z�8~⚰�H�k��@ ��&�<�H��pYW6�K�.��u'���8�T%�#E�Ia��΍�+���\��q�̈́t��,�|:v� ����92�\�<�B@<�5��5���*lۢ���1��
�Bq3	�縇�6�K#t�y��L�ID�,g�l�W��W۶X��+0u�������>#��E�"��"��GTؚ��s$i�>-SY��VU;C��@4�|��e*�W�_���?�������쏞v�ɜ�@�kKQ�Z�*��U��V�e������?z|lx�{���P����&���AyJ!p�k['�����o%*�޵�cl����s�Q�w��~?�/���p|�? �o�'���OwoϘ?���{��o󧿞��ϯO���K*6�Ƿ \�"w�*O�ܔV�d�R	�%�w��S58yɹrg�������2QaofU��Y3��fjPā'�P��A��F�<�*\C��=�s���rv
�; :�A'��x�t���4�BD#Mα
��HT�u@�#I�����U��
��+�u�� ��F0�
��觱&��b�j�,>`��۞�D#�E�¾���������b۞}�h�;H��.��	J���F2j�
���;?���P/o��{��ڝ�84=�A�{�R19�(����cupR�c�H�x���zo������i��Tp���������%]�P�-�ʩ:'�,MT�&wm�����r�����uYMׁ5�53+��:M��)E��"*��F)����eX��:n(����kQ��W^i]�D܋��p��)�N!��s�	�Y��!i��.�ю�T���l�il�I���P�Hl�W��J\G�B"�v��{���M�4?ScA�@�'\E�fȇT���UX�3��6��ĥ�Cg,�Q������� �%�
�����w��*� �>���I��P4��U�$�@6P�젳�ڲ���
6�GP��oZ̷��IU�$w��"V>_8���E���{����,h7�{��1��1���TRkKD��D�5[T],^ݦ�д��<��M˲�kC�|���#Dd��� 1	��H0��-���p~:�hH�d(��
�ж����-��c���3.J6uҍ�����D��\��'��vu�~;�>��r����A�I�a��.�p��c !r�U�$�������y��d3]l|*,��j���|IW�R#���D��%*�奌��׺���b�W��É�#��j�$��LP���z�
��j�XԶ���BTfΎ�TjM�m#���ς���*w(*������??]�U�����L�P#E��&*�M���u�f7T?�d��9��C"+�|@���UV��݁����~��G������YePC���
�:���9��fr^)l[�ඁ���w5xz�6]���jkr"�J$*\D��:�j���Ղ����UV�3�֥#�|M��M�e^[6��*+�^�*,�Ȫ.������t�d��k`R@a���uN4������dE@�r��M�o6�j��!y8�پ��:k�j���<[�����*<H?��]���C���" 0��e�`��;U^FV4��Ux &DC=$+�1��� 8F�K���GsÏ���CQ�Q,�Y��Xkxs����l�޴���l׬u׽}���+�..a��9�qnxR����X4�j�U�����E��$ϧ8�e��ϖ|�k���p,�)��V9�*�J��X��E㩈m��Ίxc�
k��e<ǧ��5�d	{=����1�
�b����C�GpT�����>k�L��ˁ C�d[��D�J%*�q�t�H�_��?ч:���QV�x|z�6�)�7m}�����6�!D��N��F�$o�d��d�w2�+������uՐQ��xǆ�����eѩ/�>#Pp
�չ����x�� IF|�H��Pڈ2�w��t}�b@�*rh|;�!��0�E|�����+�(
b�]�վh?��<֦�Q28xƷ(?���X�[^~�<|� zy��i]T����n��	��H0�6x[��m��Ί�o��6x����T_{�76� ���MYHC�)WUY_'*C�5�Q�w��{��ǟ�k	�7�W�rC�L�~Q	�5[�1��7:'�~�D����Qd S��;%S���R�ߌ����\�S�~g?>��i�8�WC�i26��OSb�J3�c��u���O���	g��q���?���ؙ(KOگf��F׮�r".MT�V6�����G;?]n9�l��=������W[���l�� R  �iF����ɰ܋滾%��Z��P�W�
[��&�ȣֵ(6�%t��b�&q�P4���ݵ�N]�[�v��o��*S��� |![:g��9�:>Va�,�	����z�.z!b�~ig��v��g���h _P�7 9���dC�����Nu������?��v��]�#�S`�҈J&�H�-V�p=�%��X)M#h�ga/a�8JD|�������}���bޮ6lC!e�ZS�\a�m�)�����*|kj�M�^Mַ��f��_�М��?<.:t)���|�6��N�fФIF��ߢ����K�y�����ߡ��Z���4U"k�1X{���T�δa���{����ȡ:&�U�V9]o�X��Z�1�m��ж��}w,���*,3��p���#]��dEt*W2~b(�MT��(��V]�nH��w֙�45R/�沔|��+���r�$$Ca��r_�1}n����ɛq'��/�����L�,��\�A첬��&+�6m��9I8⍼��증_mg���gKÃ� �}��]�	������6tP�������r5fk/N��@��3Y`���dpW&��D4B���4
��{	w�[NG{��2*�h� ��4`E# �X�-��_� �|c�)�W�=0ט��+Ff<��G���k�u�o��!�I���~;��E�M|����v�-����f�^���F��`�z�]Te]�Z�e9"�*��6/��Լ�¢�^�諾=k�:���m0K��<��X6��b�LMG�-�?VX�{���:�ђ8k4'�<��geC�۫i�A�ߎ���nyՍà���-���NZME�3ET8lʗ��A������LL�w7�q9��%*l�WiK������y�y��g��'�֢ʉ8�θ/z������f��
��n{s��at5nl�g��DnH-s"�Q"*��<��T���y�/&��5ƊAv:��kb��:L��
&��?f�-ze
��:���F���
k���� ԋ�緇���c���W��%���nUS:�2HDǢ�Dt��E�
�3B��p|�ǧǧ��u�����m;�{{��8�r)����Uec��:Qa��u�4E3��Q��?k%DVY�6f�*�ٍ�ť�|?�IxW8���X�O� *,3�G��
|�����t��^yvis�$�W��W�*���x��N��Rw����x�Fgҙ�}ʳ8 �[4s">D'*l�_��<jg3��֓Ш<L|$WN��1� ��eE|��������~<O3J�5�4ٯ��â�ę&'!��U�.\������t��U��BTǑ������r4]8�
#�J�Z���ga *,���c,���S{���~�����~�)�0��9+��$���!V�a�v���@9���C��X�}�N���� �g��Ւ ��"�d��tX�����S�9ԏ�3��v��<_	D'���fDSш��
k��G:\ႆ��/�i)s__�$VU6������F؛b��Ɉ��cz�n��¹�����W�(����D#Y�X��zT��40��|jW�ɩû�3��	��6x�8A{�SߺGT��=XN��'bc��Ep<5����9O�DT8a�Ҍ�Q[x��鬽���ϓ��6ea5d��;��f]��6�Ҥi\Ր~��0�C�F���]ei�p�����g8z�?"履?�I|!�9�J�h����X��D�01`"�%��fsj�L��U_��H�q�T��~�6Mw��W�GSߵ��ɵO3��rUDOE��%K*J���xr�;�����-��C���&��Ю0S?ĸZ:��h$��U���ၴk� �&g���li��M@މh$����$�p��W�7�}�}ߦ����<�8Q'T�C�H)V��HV�<hi�,�;��\l�W�Rڦ2Hd,Gg�T�BgQ^[�B���џUN4�c�U�� ٢$Aa���hoCP|c��a|���n҅&".TMT�������rB�C�x/�[i��[X�|���W��v���Y����!7)�o�+W#�iN4�[�*,J<�S�:*��w���`�J�����p���4	���P|ڽ~���� ��]K����_!'E�mN4�k�Ux\SMkK�7�	�1A|<t���?�k�p*�M�p���o���f�qcο�*��D<<��p�r8>/z���]�S��3aX��������v9_"'*lc��Y�/�v�t��!7����Ԧ�*�����F�d�
��4N4L�q�'��9V��*�-e���6!�u�`E��}m�@�+_%t�%a @G<��R�=p��jlBe��6W|8p�"�ޘ��LD#W@��_V'&f��-�:A˾�5�q9oQaM��:wX���yR�K`֏�����D|�BT�vŐ��n�y	~q=Y����}mUԥEF��ۓ�����t"d��j�崎u>?��U�D��F�N�
����������KgfY ���|��UZ�$��F�X�otqF2�����ՙo�|�c���s"�ATX �6��d�Y3X�3է����#���9!s����'F�a}�i���r���?5U	ױ�]Nģ��
�b�5�:�W���#��r�^�d�N f�ۛ�#g�-���Zw��׺A�{��]����a����4YR!�"��ڸ��S�,IT8'�WNhf�N��ka�z�2�J�b�Tu̲����KC��X��3�	A���܃��L!�Fg�B*L)�#��"~v(My'W�	0@;��!��O�,medS�D<�����v�h.��g����܀�_"RA�F�ܭ��O���zq��:����r ��Q�u%��9�xO�I�s��?�������T�	1��qw|=`�������]�ä������q�zR�������:�(k�����[86��S.4"�{��������/�Z:E�'؁̚���R����JFH��>��g7�%M�������`�	�6-� "V��lu�68�t��j�VP�IY��0��6�I�D�eE�\�<�!=�U�.�w��^�,�[x��%f'��\x�|+߿���0ژ      �      x�ͽ�V[ٶ-X��B��l�~P3� ���l��t��C4!]7�z������n1�"{�I�p��[�m���9�����%[�|Oje�jI�zF9E�d7���{����ys5]6��˭��������/��~���[s?�4��i���?�RB�wB��#�6��=gM����K�kI�z��k4�x����~t?�u�5��Uϓj[�m){�I-dۼ���=����m��yq[���ژ�v��yFm+����(���簄�����y~ۈ��:(ߎ�q�"�)���Y����V���������8����<���4系f:����$�[��p3�t�RAnu~����G+P�m嶭�Yo�lK�P���� f��8!*���J�J�Sj�a��m� \��t?!N��頽B������S�ЋV	������I��5JtFKȡ��4��?�qP��_�Oh�=�/]���v9�wY�,eC�Ю�'(`�c�,�C�@��N
�m{�[U[�e�A�|����V�浡���]�Yg�ö���d��^ �~����Y��Pa�֦��k"t="�8eZ� �@h3BW44�I��#��_��YV���=���B�KԮgT�k+�r	��FĐ���h]���ѱ�C��9nn/��/�����u�it1n&_�˰�-Ò�P��R˰$윁e�ya��ƆeX����E�\�^V�V��+*��/����M���`��pL5O��U�m-Z!��Q)#�=��t���9����~ރx|�7��밹��L�Q�'��W�0�i+��!(�X����m-� Y�� a��53V��U���3�E��lOXa���v��y��|x�_��u94��ϖ���V��������4�n�� &V�$S.YR�X�bo�*�yX���R`�L+.`���z��@GZ�^�& `�Pz"�s��V�C�{),�m������46��G3�J/�iv1�8>ߛ�;�Ɉg�64�6xǫ������	�8�2lӃ2�����g��QS�	EZK�(�ոc���ߎO{�M�+��q� ��&�h"�|p�2aj�]�S1��`x{1i���~p�Hy��;�vd������O�y��}�X��{
�<����qud^]X?�´��+�˓�i��?qY
�ׯ�h�r�̶�&��U�N�!����&B��N���{68�c[',Dg�=|j���!���|a�����J��������φ8
��i8�Q�D��r�HTM��nU�[�T��,������1r��6��8�:>8�������qx>�i��
[���1��C�v+gB�����Ŵ���N�4��48%����dH�������a�}[��jק��8��%�1�)Wg�r��k��{g��k ���:�p|.���L�^��;��i:�#����a�&�&c�u|5�L;!���ʪ�����T����*+g�+��BqCv�Isތ��EK�+���*�[���"-�ce��U��׋m�f�d DG�1�0�9Z*�i��o"�殥dA�i��z�@%cDH4BB�
	�>��
��)o��.��R$�dΞ ��8V��^���;�\�m�4���i,��-��N�f�V���|>���f:}/G���|�qA�Gs�C5ߌ�6��������<�f���%bJ[��b��e�$"
�:9���w����c����F�����ַz6"����mEK3#���]ב���XZD�.x;���E�`�P�����*[��I�m��'�tX㾚mhk�}E����J4��������Sdi�ֈF$���ֻ6�tU��pٳQ�~�ٍݓ��w%U2N����#E��u<���`��V�&|.z��,`�%�3�{PmD,Z��0�iӶ��富қ '���Vf��e��[7�,�{Bt�_�g��/����+a[����Zz�*Hj='Z���@�4c��~����n["�����dK���0�XPFlw҂���Fd&|'w���ۄ��"�h*ƛ��d<�0<l�@]l#�s���Ljv�a����[�K�5-�^��6)Y�@L܆d誷��:/���+�������X����2�7^@����8�X@��Ym{ ��K�2���`'2
���w;)W"�I~��Z��v��g�R���v��m��.Pږ�Jg��
��tv]�ܶt��;�X��g�y5;O����T�/㢗�{�x�\��.�g�	?�i\��D�T��Ӌgj��J�JЀ������;.�P}���f�ӻ.��o�mpF��
j:��,��$�$h���80�q�TI!fU�2��۪����ҦL��0Z���U�c8ZȔ=��B̃�
�d��.���32�����3%d�>sV��#f�9��;^U�1i�B�jZc��,!<���nŮ�a.Ôy2���&:,�j���M��\��_�FүE�>�BTO�/׆�0�.��Y�,�[�x|��1|9��J�°��T�^��'k{�2��%u��Ż�'���c��"���]�ȵ�M�C�3�Յ��C88��E�2JO���=l.f.��8�o���V8)�_A��P�T��3P��m��[��K����h{�25-��d#U��d���7���s��_Qm�1�h�}-[��\YQ�'GݳPn�i�F[I# �=�Bh(�ز5ă/u4b��[~Bʒ	��D���}�!+`�B�Y.qV�7F���[=_'%���P �G2�I���`[wR>7��x���4���*�D<���3���趤���Z����=�t�oCmѼ��r[�팵J'�Q����=y�4�k�2��aw����n٪�a ]V���P>XQ�ק�TOXi�6��.E��_hӲn�V�{c1�Rl8��r۲~~H�-ȭ�{���1���V���:гҼ�8tˬC��8݆X�P���^�͕��(ۘ���5.��m!{�WR�v�-��l�${�Wi��J�\�������*y?~?���_�Eކ��+J'^�a[�������=(y�,�}f�&V�W��}� M���z%
�;cD��3Ն�D3VM��;�T;���VK]���cq8p�#u�e���i�E�>�n���s|�i�U�'� v9-�0�l9]���/�E��Lۚ�1�>�by��\�~���{�
��Q��Y�a��XC���笡����}tm83���;|T�����vݦ�O��l ��Z|V����1�`��H�׾M�VN�v������;�O�ۋ����� rf�p�N��l:���I��^�����&�>D҈���("Ȃ���(��!��z|9����9���U�F��B]�e���k]P1���W����p�V]����r��Rn�t���]�6N����e�y��W�DD=���ѺM_���q���(�Q��)�
������T��z���1AyBd�+��b�ײ!`���1�3ΎJ@�a��M�#����z���߶P��ENm)D��zH�M-Xa�[� �w�녩�� :��ly=_Q��|E-9<�]�����2氀EH��k�,���������չ�kw�֮��}�@��e~����f)t�"B��Z�4�#g�NGT�MrH���*�V�T�y�
��H�`T0��2-����Z����\���R�
8m�C �:�;E���9L��i�ݒ귝]�U
�<�e�}��) .��E�Gh��!a[�ݙ�mŖ.v֬ac�`R��*�-_)>FS6����2���{��=oa�	)�B���;U���%wrqۛ��������5;@�V(�7�ts�&��Pq�B�>9D���J漙�mᛈ�1��#R�(��P8i�{8n��dE�1�h��<w��,]d�.�������=NGJ�=�p��~�01�X7�l0	R�B	X�_r
��Չ�Lp�����U+���sM�S}|�ط����������w����jk��o��:���w	�	��	E�Cgƒ8wF�=Ma��2:���H�����?�o
�t�����WF	�u�!L�@M+T�uTUŧ��.W�C�kq�    �ʟm��va�Ͼ�+��o�@;�QqGb�/fW��_���xЫ�����V��6�P�����95������=�6_F��\50�2�_@ah��ݚ�($��l
���Yf�_�'��p�򟫳*/r�vc�'�>�V�?�O��Yv} ��B+�}��d��(C�)��Xs��y��v���`���Ia�,�24�M�6v+yQh�Z݆ЊEM�����)��Qv��*28\%p�O����X^W`�q~�^�K,����%����)��&0Պ��Ϝ��$��g=>�ݾ?(���|9�pc�2����[v��.T/(+=��ҭh��nA�P_;��V��ͤD�S�l����yb9�n%S��5��	G��O��'�$��mŢ���R�b���ǽG����4g�{��Խd�\l�L3خk���v=�/ȆixG��k+�{���1 G���V\.5t9]w$�i<D���a-�eG���� ��?�"ԢN҈����0����ֺ�����K-�n�͂:�&X[r��Z�TU�l��'���d$A ���8�q�����>s#������@͒�,�)0^W�h٨�y0����������K���%a᭄�	Lx����ϟ?���D�[��5{t�b,��"-�	v�\�uЫS���!�\3JG���Y8}���&�q�MEɢ��R�y)Md��!���eE�;z��F���gϛ���=/֙�T�M$�עd�=��+B����<���Ĕ�
.'���Mb-�x��Z��ߍǇ��돯��#��Y��R��-��9%�#���jt�i���|J��d�M�����R�R^{x(G{{��:�o���Λ����;�~��@��ߚU�	�#��}R��D���@e�����Bs8�f����"���%�AUW-h���ݣ���4F���C1�I\�B���Pm^5���{�R�O��<_�x��Yr��1�!2y�_>�{���mg�������'s��/+�䟛� O�_��R�c��֫�ؿv�һ��0^8^$�m��C�`��&��.�[aF,^ڷN�\����f�z3�V^��D����J��}�O�h�0v����v{x=b���>��uL��o>���ۈ�ƣ�e�Ei�v�9iꍡ�qeCny  =����e)��k����]�_M:J-��G�$(p�>���+��?k�:�6�O+]�#D��K��8-��3L�� �� �D}T��ϐ�Ök��x��������^�,�&�F�u2�����f�J�Zq�����pXW����-���]$�JUi�B�,�"R�v�b��T=���0d]8~�3�9M˶���&�P#.-���tՄ/.�ד=����Y�Z��"��6Y���iB��5�3���q�f4RvK�g�~!�Z鼌����|�����Ë������2�-13~t=�;�[tRsU��P�2���+Gӕ,�������{���F�C�<��n�d���p�0UaZK2�Z�����"���t-PW|�zMʹ8�b�U6F���WC�u���sg��_G�.]�Ppo�빠|���QU�4�Y���@	���==��&k�uF�h�L�R�M�m��`g�����{�.f׿���>����V���R�M�N�̘��q7qg3PS���\��K�l)�V���D�Y=��k���������$xx���1�!eV�N������g}!����f-�,��O��tHv-}z������v��WfB�����#��T�{�>lUdΕi�DIml`��nt�&��?x=�)����T�	��5t�K�kcKh4[�G@��r�-gB=�������Z+o���h����L���l�~��ߝ��g�iF��l�q,� f�-E�
�E)Ӛib�ݽ���
������zA��K��!cSoZ�Ra#�ɪ��{V*�Q�)�BL�'2cM��B)Q� n�ɞ?��Pn���o��IO�R�lLݖ���
m�ci�Fk�M��]B|/�u��܏k�X��>j�����3�k�D(�IZ۸a�Զ%1!'�	2pk�5V΅U�����Z��+��5e,az�I+F:�)����6�.XKM��8�PŬk6��:�^p�����5�"��&�j`ռط?;Nn�8�f�B���g>�5鞜~'{���[ʻ����T(&V>#WߩԐڑ�D��)i4�!`%�#��'�$g��P?+eI�D��/pɾ-���AV*�a����b����zx�6
XF�Rj%B�8��L����2��Ց��������.aH6��撥�T��|��Q�) ��\�H
ٹ��޼+W�FP|[����z)���n1�MfTi�Φ�^'�?���Bo����{!tm��N��N�i�W��L���{`_T��r5�a�
I�-m��Q�d��Ot��)��9ơ�-9ك�í�9�5n=�U����C�]J��R���u8�G]���֥����g�|�Zn��18Z����Ϳ��,և���BOh��
#�V�$�V��WOA����
ϒ�k�0^ ���{^�5�Q�k�3�쑓�r��fk�y�������.���k��ʸ���e��ͤ��n|$e!��)�>>�Ү�ռ|�L~$ ��nD���_�P:$EF�������^�#�5�� Il��t5g��*l��X�#?�ћR�wls_�%���`�Wg������r�ʦ�-���kݴ1�v�����Dd���B���z�F� {`�$�d-��б��p���x����pI^��IA�O�W�$�G[�	�)�@Rr��6�[�֘�J���~X�ڲ������]*IR.�Վ�)g2H���q��w����Qs��]\%S�g��`���+�K+o���ZS�I�]�����ǘ�s�7��3&Xf���4�K�5�߈r�7�U)sY�bM����i���#�[T�b�,H�3`+��������ò��uz��м��Jh���1����Ev�u��e Фk��V����z>�gA�`�HC���EG)?������gX�H�1%jۊt�RNmlN,s,)>����A�`���\���}�-6���)ƪ��ã}��r9yH�@�!-���OrFa]s91U�����R�&Ä�g�8�f�$LO��� }� ��uy�\!TI1AS�w��ɴ���X��	{0T�qM�������e�u�?�wu!7>��6��k���Bpќb���"v���$�z��âU����"����ϟ���*�>�ܷf�6��Xr�IǾp�.	Q��&I'�A���4�f��Ԁ����m�+�W+Yʔ����Eޡ+9��>�IQ�&�$H�u��B
�l2�~ٺ�-=yWk9w>=B��"8�QQ��Mj�{�族H�`炀��Jf_���f��70$t�Y���䒒e����v8m���̀߱�k8З����I�i�=�Q+rxCս��20�N`:3�̚�92kj3�A���Isu��%�B"u�o�; s|�B+;�����ou%}�)���[�O��������ҫM�8�f��Icl��㿇~ �7�t��t��͖z��3�?�N��.��Nz�֤� _�ZWJS8�/+vD�d�ۈ�����P��`hi���I;L]Syfi����p�^��/�s̯��w8�s��%}���9��E�П���
|m��ʧDE�Q2YVZ� �Nnn��NWA%-п�O�W�#��^3�i���b���b��tڊ\�X�8��[I��1�i���Cܘ�)��tl��q&��Vh������J���l�����g�kt��c�s���;�a�����:�oI=�����9�g�&z9��/��dl�42�j��j=6���&p.���� ��Dk�Ib��.D���K�p��������O���/(�]r�k��Fx J� �M�ꔐ�o�M�9~�>�Z_��0y�b�tk�<�D���ʶX�����y[�?>oٽ�~
�Ѝ��jX��CK�ez�:�������nn�w>5���ѝ�t�>���R�G_���������U�WVv?�    �6]��OP��ر����gm^�Xf�����)�ؘ=�4;OeM��j�j*�J=G���=�B+U����g�9�4䓝��\7ZÎ�77�]s1k�U�߲�;#KÜ��F-Z)	��8K���TUַ�l�dC�ϣ��?��/T|g���<\9bMC�K)z���OX��&�u��Z]�+6\�|�&���"�A}hJD逧�.� )�QrFSе�tS� �/76acR�Tl>��AX��07M+�#��'ES)�a'u����5K�!v�b��ֈ�9�i������~���o����x9E�Z	��Uu�Stq��nc뷥����"�U��^��b�.)K��8��a\q������y�<�%�׽���9p�Z'��w�W�F�~-ۑJ��4�lj�P�������ޭ4	Blj?��O�;�|2U��-���KX�Xv/��q���iO5���g�u���μE&�W�]�u��YĦ̋,���L8�L�Y�\�6m��۞�q/,;�:b��4OZGRP�^X��c��_�o�V�s���{㥷�1H���v�g�j���Uk��^�{�lr X�i�$��/�4Nn�.J�I~�4ϴQ��~#�����9�]rSƉs4��#�����U�a#)S�w��� `�$���N��l��5Ku5O^���^�@m[��ɾ����"DX�W:�9m�ta���S	���rށ�ES:�ZK�̢Y<��ZB�
�\�o��Y���%&��1�����5U�o#t/�����T��`Yt��0�xԭì�Y�JC�")��5i	� �qKv ub�.��+8����Ʈ:*3�����ǘG,��J3�=����o�y2Lm懏�i���|�4�����M>'-��m����B�6�"���M�nwޥ�"W��ʽT#�}����򰻼��_T����(��<py�ڬI����x���Z �%U�e�ݰ����I�8*s��Us�ڳ�r���sF������1�J�{ س�P�-s^As s.�#wY���­���An��e=ެM�.eiꍛ���M�_��T��S�Q"�PNLV��ֹJ���cʌ��_�Q���7�1{!�����V����X(u��`�m��J�c5�$U�uJ�[���k�,�R�)"`�)l�7mJ���&� �4��I�[F¦2��Q�LY��@c�b�����ꕭ@�!�x�k�҈���`����8lH� L�	ެ$��6��u�j�gFX��$5��M��1�,�|ė^�N����e�[jp1�RK�O��9�tw9� ���U�۰��-��^!~�����E��d�KfA���X_3��5rh�s\��_պm�i��ۘ��?BL��+6>�V̢�1��v�e<8p	W��Oq�fMy����jh<x�q�^ؕ�z'�ty�H���"������N��v�oc��9��u�@&�+����x��fpx�Z��6��V�����d���������g-q|�N)�&�D�<b]K�}����p�+i�x@��^Ik��p��OW�xXx�`� l�Z�D����e(�X�eN���k�ހs��HrF�Ӎн٬c�UqTl��1&��t����b���K�%v�)}��Q��߷:'���{�:y��Rv��}�,B<������ڗ�w�H���T�vA3fs�%F,]Y�A,��G���tTR�l{(xS�Ĝ=d���qB��ރ�����4����F�7�i��p�tl�2�*j](}�#ԭ0��Yx��u��U��u�E:�$�hLPeq��tiapr3I�~]�2L3��V@�{��2Bq�S� ��J ����������w?6�ށ��2d���}��n;�Om��km���`H���榆о�p�b�j�t�;е�^&6C��e�����h�8~l��P��)z��|��^�o�Mj.S;"��	�ό��^*�`��E�!�5�K]�l��;��R�(����}���{Ɗv��l5El�6HaʠhA[��ˀ��?�_�ưo�'I1��b�1��`Pfd%����w��X�gm�'�����'��;�_u�f٘�O���ňɠ�12�:y0�q��``Q9eUeJq�f�J{J�I��wÙ}r�6A��hǡ;���уFe�FB�Y�@���#�1[�'�\5���:,�SAC�� ��9������>�|���y>�ү�2O���w��V�?��bc�\��2�f��������X�Ϟm#`)��u�]����L�W�U�K9 �����-^����U)�0�z����I̞)�(����$�X��J���2]AC��^iX�| �p��u��^��s:�����L���<��K���-�����c_8���i=>���D��ɫ )b!�`q�����j���);��n���M������#ﱶ����{$�o\��Y���,K���蟂���)h^U+y5�#���W����]�?hF����V�Ԫ�^4�%obR�=���W��$g�9V5�=�l����Om�{���SɩI�
,���� ���7��J�Z�w��&ׇP&�`���®��Q�ފ��|P�����o���n+v�#68��`W�_Ӧ�?g��#��G�l����ۡ���ਭ* ��q��̦��rU�s����S��l������K�rӒS�Lj�t���`XZȼ����8Y�h6�9��Q&!s^�͔�4�t�~��k��Qi�^�z�C�F(�T~Kb�%�B�	�T#��n�4M��MW��S�:��D�g���9_��薆5䏖��O^��,�����Tlj��J�J�Rۥg���x�k쏛��(_2���ryY٨ɞ�4E�PK��Ck��QRK8c�T ׉���*�����¤�0Ӑ�"w��<�1�Ѓ���B��R�֓EǑ9�b�3���=;�ϗH`�)��m>�W��ouhs���	�T�[s�+a��������IsӤ��s뚓%�Fh�\X��
�����n}u�_%`����e���V��3��՛Y\M�C�ZX�Z7��񹿪`�P�D�>�]�Zhׯ��N-�L�Ü�N�HQ�!u�[.�G ��զ��j�0<�e?�4���f���8��\�Vm^��Z%L�E��F�sqf_G��j�.5C��#*�QXf�V�*92��#"?<J��k�y[_��չx&�e�����P�ev���[�=.\��l�vsD�뭸&ӭNx�N?�~�m)�o7'��~)c_�T�4^+~\*����`�_W�Ļ:���UG�*v����tP�!g]$B��v=Ŋ!?�񏟐x��`�0�k�.I�Z�"��v��G]7ct���.�m�'v�+D��Jo8T'��8eB�N��]kyd��3��BM�H��ؔ����a=�\���&`��.o=\�����I'��ǵjW*�R�����S�w6�O�8͔#;�on�����bRy��7E����={t)�ś�����]W�մ��P�%�f�kO����\3ߊ��2�C�k�*��G{n�j)	�yk��n=���=�w��~��Wk�$e�;�{T��i�p���I�d����ۜ�+ͫ'�0C�E�
f"V3��v.�v��d�{��5��%���Ա�Qx�U�q�^��O�Ն�}�>/�A�?�"�I �f#�73B�&U�6�Xf*�<"{�}s~�5�Im�� FE��Op4B<ʺT�z��<�]{���TbBG�U��^��-]٭v�O����ݽ�.�dZ3XP����VT�Κ�jّ���L!$g
�HdpB[M��������.k��CV��+�.�[��f�|_F���A��A
��q~�AS�?��-�B�L|8I{��=��{jK� �HX@]�fe��4�XkY\����]��/�"?Ϯ`)O��þ��<>�6���Ay@�--D�x��F�G�}�V�./�I������Z��.��)� |��g���AW�����{Z�Y�`X�:���5�bԋ���������8���PP[/�����T��:H�;-[�L6�U�#��^�ع���!k]��κ�S��v�    ɛqd|��s.�H�TK���3�����򪐅����l:��	¦��[����N�||�������_p���/��M�%,o���--�/�-5M�X�ҵ����<��O�ݾ���Z����+}�4P��eSZv5�v�{o[�Լ�{�����8�Nbwo�pG����tx��(�>��w+#+�u],g�l-j��1W[q-��,W��b��CI%�az�ڷt�Ld�&�&�#��ӽ�a7�}��������̛��*�2�!�ݦuhiQ�'A�PS�
gW�<�܏ �3�.�i�dH7�ֈT�r;w��,%
:�؋����b�;S�ȋ��6��T^>���jIY2V�h�O�y�6P��U:	6f�/���S�7�sY��杞���o�/�@��Þv�����F&�r��r	�[�C�!�� �&��n�\'���_6+�řC�lж���J�o��6s��s��hRJ���Jc��yB�6�a�"����z,f�S�y�sj�S�`�0j�/F!�'�BkN��+a��_X�UɄǪ���a`��i!�zkթ�l��T�eP�vb�{�~^��w�b��nӚn-ʃ���j��G��t�c��K*O��U[�ھtRNv׮�1H��t#f��eu��W�bf�N����;P%�-ҹA�䤛�|3m��Uuѣ���Zi���ϸ�6��K�[E/�B���m�x�Q����N����S���ԯ�O2l�2>h{V{�ۅq�B$Ο��&���tꎭ��ZU��J��PA���Q����z˰�����P����|���B��aZ)��N)z�a����%��u���\��p7�S:p塘��� �1Gt�.園-��H�aϩ�g<=�£�Η��,���A��*R�p����,1@��P�:�>��LY|0��G����ˊ���R���DC���L��5y\'�v�PI��c�m�5*��}m���l��5��Z��~��h�.�t�<s���c�b�SM����x�����Xmҍ.ujmk�]�5�C��|ńaJ#� iVyn�W�qt1���<Η�Cj�'a]0aB��"Mޕfo�c��"X=;�3S���Fߛt��x&`��Ь�8tPݥHSZT.����t�/_�0�����Z֮9eD��DT�6�%W�6���k?^&�W�o����[�kaN��0K��ҙ�.e���ɵ���(m�(�&�mΒץ�R�M,���{��	G�x�2�3�R?57�v�Ԫ�w��G���f r
e>�j�cQ���{z�\e�B���t�d��+�K��"�/PO�4�SI.�/�ł,o�O�fuj�"�hÄ��pѤ�CC��Yl���"&v�S�[\�"�R��8'���=�G�D�:O�t�ד��rǜϣ������EW+kg�&��G���qK ��� �G�	�E�N0W�i�HkE��蝷f��a���,�P�3���`x���!��|�v�|]t���DA�ir�E�	�?krt���5]�W61~�ٸT��B�{(�y!.1��Y��`f�Fs�(y'V�6��j�����I�S"ut�h����WY�'�=o���E1L�)��� r�Td�xלtO�I�K���hB��7Y����� �\��&=,��<$1��@���-'�����Yiv�3���ID�oUQ��-{��R�+��ԅ8b���"'�,2��_e�Cn��y��aY�p`��C9?�!C���L�P*541�B���J�d���Q��w��p�M���Ψ<�Ĺt�` L�c�Z��!�'���+�z����ᦥHE&�\\r5��Zy�9������vd	��|@�v��h���ha���%_���jdG��~^3La�G�Ƒ����X\*�[�C��x2�*uF�ŗ����&��W`_,�$����ԥ�W蘒V)k���,���|T�q�q��0u�֐l5�t����gKr����Z�˞�v�2bO��Ȥ�ဇ�_����e檖�#��'x�A����$���b|7@���5���d%�:������`�ʡr
�9��x��t���Bm"X��'J�?�\K[[�:*`�|�n��z��..F���o�{�r7lN���P��$��. �A�� u��q�8�dE�	j@aAJ]�jU`�PȒ+a��Lb�)���!u�/����P������s�{.3�;@L���Z"B+��2�W� |�
��+�ϣ�t<�������3��5h5v*�PG��FÕ(:�����d3o�ʒY��%���҆�W"�4bu������0e�0��4�{O<��vܑV,a� |�ӆ�d�p����e୙�"�"hվu�r��3k|iJ/x����6���T�L����b>�G�މ=���R��&�_͎����$��]��KD+9)%��<���K�Z�{�VF�{LRK��e�`*��E=6$O���7�(�R&0AU:e�R@��r�P)cM�r�e����~}�NR�����o������oI�*��X*u�fh� �a�J5��'=9���`��_��_7���
m�Bُ~!o��V�H�~���D���,ҙ{n%[�~L�B������-�R2-'V�ӺןƙO����U���4�]�8.3��F�t�,۩9 7l�W� ��{sJ�}o�h'�/�K���h���nm��~��⹲{�c��x��s�I�CU
�G��X��t+�3lL:�O�y;E',VCl%;�������Cw�doiiw&M�nlaI'aPn�n�$����D��[�4��<�����q-W(�'K�sx�6�_��J��pa�w���;p	�]��:�,�-y�F��2eڝ�9t�z[�S�r��p���@I�U��Nΐa,O�M6�ka��2�%u~���5�ڛ�-w����w\�W�Ls�4��x\`u|eG_��2x�����v�QX��`#�ޜ��ד�eNco�&ݟi���g������sX�R�̐��/�91���OË��Ki,�t�*���t�q�Y���|Mz����*�n�K#�82��6����(J�KF�^L?�\x�!��6V������r�����W���^.<�(�>�p�2���й�^g��OMw7݄�Ud�Ǟ���©CQ���3eXq�t�}�� 1��|�9���%��l-�erPC�.{��*�E.؆�x�NZv������P���єG<��-�G曧�2��,�f�ƈ0>�R�6�NU���*C��ػ2��of���'�����"��!x�8SK��J�1���-	�?x[�� w�s8�6Sl��]�Aw�I�p^j���go
���	��t�t(�8��V��� �U��՟|�9>M�[o߱�w��(��ɚ�e�x�`B	=$|�ܧDza\1�I
~g����r���?��WxxD�� Uʕ��)s���&�d��9E�j}仰��`����z�m��s
H��t=��ۤ����cX��B��I3����0P�a BKL�����[�]��u~�)oFu
ښE�&|"�;�1T뻡Le)U8{�6(?N�R1���Ƚ�����3�T�9����}
e��GZBS�(�h������*`:����Y��9s���K��X���|�~���X��]�J�dy97����G/HN�`ت:��g˜q�����*x��Ɩ��g�`��Z.�6�`N������	
&�W��LQ��I�!$�ܳ�ý��Ř��$��\��Ũ�k�ػ�O}�Ȯ�O�E�D4��Zls�.C���<����^�G�j��,��k��pzu�v{B�;��آ�x��t]��'�%v"۽0�P0���VN��p����`�ut?��BF�1l!b5�0�E ��[���½�O�:۷i��uM�{.� 㬖��bDEv`ڃ[1�H����PM��Cb;�]�F�Z�H��|��JA��U˔2v�/��B��s��D5�x�~��)�!5"���=ޖ���Wû�O�k�_W�T��]���e�R�&_���4�U�U�� ��I'��[�q��� �Tæ4{T�9�]� _  �Pϩ�[�U����.l��G�g�A�a���S�(=k����I�f5�ɌN�ư"b20�B�$�eDm��ˌ������^�0ʸ��t����Bnr9�MFw(����ګ���	��,:�x�N��z����Gm��������t"b����sy�������w/#�٤��5~�p�i=����q��r4��8��K@��K~<>h�LŒn��9���������j�/I8?����oby��O��`�Z�Ի�L�����-b_$2o���ۛ�2P?^G�����	���B���bfx�1�s�s�=�Cԡ�<9�3��Mʱ��Ns&�A�iJ�=9�*�H�S�.-1�"-���"����(vp�a��,��"(Y\62-�j�un�J��3|,K��G�`ʨ5��8��Տ긻wv����nC8e��Yo1HM)/��0ۏ��z>�9��w��~_D0������ʗ��)y�8T��`:d���:j�]������*빭�� 3������P��{5��خ%���i�О��P� �8�mrv̼������'��厤& B���*�~���3pXCk0P���`/U��B�	��0�B��(1҅�nc�-4�ET�������=���Yf�� ��=����&�,��.u�Q�
E�Z&����qw�/Jx�a?���d�Z��Ûa����93��d�mv����y�X���x0��Y����>���3f�ek�P<��]/U����F�eD��~��4�8�F�,Sk}���$9���pPk�h9�&���A��������m�$�d����V�BT�.e��cz�K����\���z�+��=G�.}X��:]�h@"�%��XOU�nd���y+k�/��;d4�2�ٷӨ:��Br�'E�lOz��=�e�eh�:N/���)k��?�Uc��1�;����̼���-(2n�F<.��bM"Y\�xu�	:^��`�gV�J��B�^E\���J��:)m���$�z[�h]2����9��+'�xRk�F���\�x�ÐgԼo+{y����\�㸗g}�2��{s?�'��ߔ^��J-�����UIV��eJ&��w���de��3�����"!�OFP��#�U����*�Z����������k0��` ����9J �+����Q/�mY w��4�!��S�~`Oh�`.̅.�B	����t����8��!����Zι$�VB�'�)RQ�c��z�U4R���1	%L�Φ@K�](l7܃�xz��ggKq�¡���Q-1��ځ��i�B�r� \Q'Sk��/�E!��^A����`��{�7r9�,�Kڰ����|X�6�FW�$H�IoX��Kfvz3���7��L�����aVJ�~���YHA��R���8]�[��3b�R�(�z�5�lA���*C��El}��S=���.�
"ëԀ���3�ڴYFǹ0���e-�lvO����vY&S�>冥7��hha������Y_p�������ܛ�R7<8"B�!����+�\���Ș��qȹ�]��Lg9kr0�gJ��*�l �(��d(MBN�0\�0fJ�*ĠJ�*j��Y���.��&�k�)`�����dc6 �tb��!�[�,<?#E#�j�%<,�|�sd?�����'zƈ��h��"[ {����2����s6����8�IeCwIȟ��I=K5�7!z�B��,�+���l��ra�z�� ���Yg����v$�xX�2�VG�қ��:W�V*Er�Ǖo*�cv],�`����/��$�4W@'�Yd�6��R=�KJ�
^�4�y�����]3)W(D��X�Բ�xx�*�=<N&�9��v�c�na^�d1��/]��2�Z��聰r�U\""��D��K����n�8�L'#��Ţ,��prAX^���֚-9ݧ&c��Ktp�ԇ@�6��.l,����æ3_֐�`EJ=��έ�9l��5�;�w�Ͳ��,���g7w����~u]�#�5M'~,6"q�X��_U�#TpG�����ߵ�qv[�F:r�8�6Bx�{� �aK���<�FiI9Ao��/ub��vOs�L��~�n���ֲ�6��"QlU�ѷB[��p���&�����{����7��1�6te��gl��i-t.~�L����Ṩ-G?�i¥�9{g/Q_W����,ێ��=���b_ì��>!#!m���0	Eij���jf��J�q}D��fkiY�cKŜ�m����9���&�|w8��y�K_fM��_��/։��$x�%�n1%avl%�[��8����g3���b���|6�QS
��!¬�l�f�К_�Qg�0K�aJa�װq��.J���Z�ް
����?3�r�C��=VCP("tg�rͥ��J�8mI*ԙZ��D�,��Xs����n9�>r��F����FL��_���Ў�Xg�0�:��0�����R����ks���ҝa��}4����!�$�*{�A���G><�k�9P�
�Зe�6<Mva)��Ǔs`׼�&��N�Bx�ʳT����q�ܑ,�ây�%wŏ�0��;�ˈ��8�n����4��d�s�Ҝ�G������:�|�G�j���A�j�%Ws2��Ƶ�e\��֕|\��_g2����u��M��~�Z���̼d=z�����?���3�5v�З���!Hȼ���?����ucjLr�/�ќ,������'V��+�%i]$68G� RW��)��-��W��hο]Jљ�l���nh+^\#�})�VH]�g�_%��@�	���	/��$`d�{��#����~Jy�ۍ��B>�VOV�>����
���~`m_h\��2����R��c�kGe�;��6����KDD����V�� ��~'���i�6���l��p S=���A��_����r�\t����c�o^�$�E�@���B'̉k�D�5ѥmՋA{a f Ւ�!��M�?�RN��Nu�\��:���������6难A\��W��Wx����"�c4�!&+a���\��b��.�V���=2#&�����2���1+ԫ)5�Ri�2����.���=x�8�x̄��u�r?9<��6������{WCΙ
�Ye���j+��$Λ�e�ڇ�;�M#fx���M��NJ`l�"�TZ����������t����bO��r��v��Kr��ĕH><1�������M�+%=(@���(E�Fq�g�Wma��MC�=����v�=�'��[V�mM� vN�|��*b+V�������ӳ���t�<on��C]���hH��=�%�(%S3I!z��j��}6�M*���Fxas���MS$2^_�R�;.x���Cl�����PralJ}=���3kYrߟ_̮j~YVg;�F���|���"��xY�0�1C��� 
%�V�Ƅ�x�0˝W�'Y��^�?�+��G��Bi��pL2'l�I��'(�����J�gb������/cRk�����5�z�Z	x��t�o?N�Ѝר3<�"�1�L,�	�v�Ts�,Ag�~W�7�,]�W�8k���\�3�ώ��6N��Ɉt?��Ĩ���6��pGs*�`�|�MF�������%���·ǈ0�M剃`bɦa)u����)��w�q�~J�[��t�\�����]On�"oM��X�X�Y&�v�t���d|w�[Sg%u�,����x�Ѝ'ky���M� ذQ��k�r�b� X��R�Ύ�6s﵍�����p��_�-�c6,���<Ě6Ӝ���IvV�-M&�˯����iss��=ܲ|i����M������4L�b���3�.a��&!�:�l|�֚Ԟx�����5J�0�2;�'�������|��n�/0���G΀��F=tRsB��* �����È�=      �   s  x���Qk�@��˧��$����붇2P�@���q�Ya�~qӍAe�-���KNB3���9D3�Z��ش�W�f99}�s��}��G�w~���u��y�f6�u������%���"C
\o��J�}��zwxެD��/��R�ʨ�0���Rcs�9#VާO���9\=Y�rX���Ϝ.9<>s�
���5ۣ[�?g9,�yXe���PUfڮck�g�ϩ`	s�@~R� �қ!ɦ9���wc�S�3*dY���P�$]���D`�ˣ�-#��a�$�N�&L���#�x��.���f��G�V��5�*]P.�+�Z�	4ǅ�4o0��B���ê�A�J5LT�"X� ��y      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   p   x�}�=
�@��z�s��y/�Y�6��I?�@�����N��W��e�6����Wќ`A����c�d[!�ǧmI����Y���#�;�������p'�U�q7%}      �   }   x��б1�Z���!��-{�L��ϑO�A�/��A���/��Q���eX6kkȫ��6m��S��bOh�	4�_�mE��6�*��q'���gY�z��L�R�����#(�'�UU߁�a�      �   s   x��=�0@��9�/@d���Ε�Ҏ,VA(R�QJ��C��oz��s���9MI�YW|�O��:���ߐ�k�͋�l���6��6D�C�OH��X�C����8�f�Ƙq��      �   �   x����j�0��??E^ Œ���m�����؋L[�%�&�?�lc�|�ӧ?����
[��6���mB��������0v�p��w��6�g�E�N
0�5���'�`?N� #>nW�J[<��L�45'ux�C����P��(���c/e-Z[=��<I�҄Y��;N���ag�D�E��˺�\��"'���2�f�*�u�ES�ͺ[�SX6���|�FQ����'��^�vN>��3��1�� ��      �   Z  x�u�Ks�0���W�p��M������;�t���(����ձ�c�,�ܜ����~��}�_T&�H���b.gT"��҇�t(��\U:s�r����\�P6\���:����O�ㄬ�_��j`0 ��0�1z��m��,�R�U�z"ڨ@���P_�%�&a @(�(���C��ٱ���OF[��=��n/R@��EBI� � �|���Y8��vg?I����ة��z��+�+`r�6w2��ӳ�?\�'���M��:�õ��j)�px�t�?��s?����GP�8ۼ�G���@��m�K�B��b�tg3׽�U��Ҭ�i����a      �   u   x��ѹ�0D�XT��tY����a1N���oɒ�{֑�_�K�2?m���KV˦��CY��6�d��qepcpg�`���I`Ws�*��,��.��0��2��4��6�3qB�u�[D>�椝      �   Q   x�3�4�t,.)J�t��/J��K,�/RN�I-�420��5202����4r��t,t��L��L�L�L��b���� �v�      �   �  x���K��0DתS�	ğm���eo���ǔ4��c��eRT����?��|~�����Eo"ݷ.��U�������`��v_�Bd�z�e��_�к��n�1�P�$vTm�j�5c ]g.ݫ4�ZW�Z�V���z�k�Ƃ2�od<�h���X��6Z��>�$���eb�eq�6��ɣ��A��^fc�"c��<uR��gg�Nw��j+N����Zi��AZ1�:�Îm����,Z��1(�y���Z��c����I�d/��"k^$���=f��%�.e�����;Yti��][�=��&����w���ګ�|2pxn��p�f�4���#���=繹"cg��K���M����u�<h_�d*s=x/�{r�;�1�����!&g�d�����d�ؒ1�Ǒ/�b�m�d���{�1�26G�@��VֽL�=�����6f�JDg=~���+m�e����K���W�[��� �>8x@      �   0  x����jA��u�U��������ҍ��Y	���L�w�d,8.Bj��	ڇ��L:iR}H�!�$�ӏ�oN��O_��L��)m&ɗ/>?��N���'�5��������i5_�t�>ɬ���W��"۲������緂��˫�A�i������&������U�)ݧ�/`٪e�\k����B�U7��V�~T�%iK��E%-Kg�,݇eТ������2�h�2o�*�}XZ4���avV����GF�KZ4V������ҳzy��;2h�nK�qK��-���ʪТ��qK��-��qK�,h�Xz�*ˠEc�qK��-���ʪТ�Zx_'c��4Kͯ�X���㐧��0I.P"�t�!T�A�D��~PIJ$R�o�T�D"��nPIJRN��`��@�D��^PI%��Z��g�R������6oK��LV����j0YZ,VIa9��"Т�4��eТ�<,���Ec��"LV���0YZ,V�o>���3h�~'���deh�X%<t��
-���.�ա�b��DVh�X�L�A�����e�2�h��,���"��]9iJ�[B-��ԡ�!�6�F�%I�~�H%��v�HJ$R	��#U(�H-l�ԡ�!IJa0h&I)J�`�1�/%��+'�R#�[J&��ʐb�J"�B��ja6��)JRJR,��� �R,��� �2�X�ƃ���b�❃2�򴨔���qoG"��Aa���������Pa�
o!Pa�"�"Pa�:o$Pa�Rf�^f�jo'Pa���e��W�>      �      x������ � �      �   �   x�e̱�0����)�8B�=mA�aC"q0dr3$n&��oM�������,M?��`Hd\e����9�����K��x���5���ݧ�r���%��<oy���R�>4Qo[%TB�.S83)�B<�ˊ-��:�W�Ai�0�x��c��w�+�>1p8v     