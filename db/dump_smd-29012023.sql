PGDMP             	             {            smd %   12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
       public          postgres    false    305    6            �           0    0    calendar_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.calendar_id_seq OWNED BY public.calendar.id;
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
          public          postgres    false    207            �            1259    17942 	   customers    TABLE     B  CREATE TABLE public.customers (
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
          public          postgres    false    302            5           1259    28161    customers_segment    TABLE     �   CREATE TABLE public.customers_segment (
    id integer NOT NULL,
    remark character varying,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
 %   DROP TABLE public.customers_segment;
       public         heap    postgres    false    6            4           1259    28159    customers_segment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customers_segment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.customers_segment_id_seq;
       public          postgres    false    6    309            �           0    0    customers_segment_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.customers_segment_id_seq OWNED BY public.customers_segment.id;
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
       public          postgres    false    219    6            �           0    0    migrations_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;
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
       public          postgres    false    6    228            �           0    0    period_price_sell_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.period_price_sell_id_seq OWNED BY public.period_price_sell.id;
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
       public          postgres    false    6    236            �           0    0    posts_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;
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
       public          postgres    false    6    242            �           0    0    product_category_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;
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
       public          postgres    false    250    6            �           0    0    product_sku_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.product_sku_id_seq OWNED BY public.product_sku.id;
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
       public          postgres    false    255    6            �           0    0    product_type_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.product_type_id_seq OWNED BY public.product_type.id;
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
       public          postgres    false    258    6            �           0    0    product_uom_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.product_uom_id_seq OWNED BY public.uom.id;
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
       public          postgres    false    267    6                        0    0    return_sell_master_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;
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
       public          postgres    false    6    270                       0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
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
       public          postgres    false    6    297                       0    0    sales_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;
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
       public          postgres    false    301    6                       0    0    sales_trip_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;
          public          postgres    false    300            *           1259    18748    sales_trip_id_seq    SEQUENCE     z   CREATE SEQUENCE public.sales_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.sales_trip_id_seq;
       public          postgres    false    299    6                       0    0    sales_trip_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;
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
       public          postgres    false    307    6                       0    0    sales_visit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;
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
       public         heap    postgres    false    6                       0    0 &   COLUMN setting_document_counter.period    COMMENT     U   COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';
          public          postgres    false    272                       1259    18330    setting_document_counter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.setting_document_counter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.setting_document_counter_id_seq;
       public          postgres    false    272    6                       0    0    setting_document_counter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;
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
       public          postgres    false    275    6                       0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
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
       public          postgres    false    6    278            	           0    0    suppliers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;
          public          postgres    false    279            &           1259    18725    sv_login_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sv_login_session_id_seq;
       public          postgres    false    295    6            
           0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
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
       public          postgres    false    282    6                       0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
          public          postgres    false    283                       1259    18384    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    6    280                       0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
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
       public          postgres    false    285    6                       0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
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
       public          postgres    false    287    6                       0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
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
       public          postgres    false    290    6                       0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
          public          postgres    false    291            p           2604    18423 	   branch id    DEFAULT     f   ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);
 8   ALTER TABLE public.branch ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    202            s           2604    18424    branch_room id    DEFAULT     p   ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);
 =   ALTER TABLE public.branch_room ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    205    204            -           2604    18723    branch_shift id    DEFAULT     r   ALTER TABLE ONLY public.branch_shift ALTER COLUMN id SET DEFAULT nextval('public.branch_shift_id_seq'::regclass);
 >   ALTER TABLE public.branch_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    292    293    293            @           2604    26922    calendar id    DEFAULT     j   ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);
 :   ALTER TABLE public.calendar ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    305    304    305            u           2604    18425 
   company id    DEFAULT     h   ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);
 9   ALTER TABLE public.company ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    207    206            w           2604    18426    customers id    DEFAULT     l   ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);
 ;   ALTER TABLE public.customers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    208            <           2604    18777    customers_registration id    DEFAULT     �   ALTER TABLE ONLY public.customers_registration ALTER COLUMN id SET DEFAULT nextval('public.customers_registration_id_seq'::regclass);
 H   ALTER TABLE public.customers_registration ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    303    302    303            C           2604    28164    customers_segment id    DEFAULT     |   ALTER TABLE ONLY public.customers_segment ALTER COLUMN id SET DEFAULT nextval('public.customers_segment_id_seq'::regclass);
 C   ALTER TABLE public.customers_segment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    309    308    309            {           2604    18427    departments id    DEFAULT     o   ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);
 =   ALTER TABLE public.departments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    210            ~           2604    18428    failed_jobs id    DEFAULT     p   ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);
 =   ALTER TABLE public.failed_jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    212            �           2604    18429    invoice_master id    DEFAULT     v   ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);
 @   ALTER TABLE public.invoice_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215            �           2604    18430    job_title id    DEFAULT     l   ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);
 ;   ALTER TABLE public.job_title ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217            /           2604    18730    login_session id    DEFAULT     w   ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);
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
       public          postgres    false    265    264                       2604    18445    return_sell_master id    DEFAULT     ~   ALTER TABLE ONLY public.return_sell_master ALTER COLUMN id SET DEFAULT nextval('public.return_sell_master_id_seq'::regclass);
 D   ALTER TABLE public.return_sell_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    268    267                       2604    18446    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    271    270            1           2604    18739    sales id    DEFAULT     d   ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);
 7   ALTER TABLE public.sales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    297    296    297            4           2604    18753    sales_trip id    DEFAULT     n   ALTER TABLE ONLY public.sales_trip ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_id_seq'::regclass);
 <   ALTER TABLE public.sales_trip ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    298    299    299            :           2604    18765    sales_trip_detail id    DEFAULT     |   ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);
 C   ALTER TABLE public.sales_trip_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    301    300    301            A           2604    27170    sales_visit id    DEFAULT     p   ALTER TABLE ONLY public.sales_visit ALTER COLUMN id SET DEFAULT nextval('public.sales_visit_id_seq'::regclass);
 =   ALTER TABLE public.sales_visit ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    306    307    307                       2604    18447    setting_document_counter id    DEFAULT     �   ALTER TABLE ONLY public.setting_document_counter ALTER COLUMN id SET DEFAULT nextval('public.setting_document_counter_id_seq'::regclass);
 J   ALTER TABLE public.setting_document_counter ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    273    272                       2604    18448    shift id    DEFAULT     d   ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);
 7   ALTER TABLE public.shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    277    275                       2604    18449    suppliers id    DEFAULT     l   ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);
 ;   ALTER TABLE public.suppliers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    279    278            �           2604    18450    uom id    DEFAULT     h   ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);
 5   ALTER TABLE public.uom ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    259    258                       2604    18451    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    284    280            !           2604    18452    users_experience id    DEFAULT     z   ALTER TABLE ONLY public.users_experience ALTER COLUMN id SET DEFAULT nextval('public.users_experience_id_seq'::regclass);
 B   ALTER TABLE public.users_experience ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    283    282            #           2604    18453    users_mutation id    DEFAULT     v   ALTER TABLE ONLY public.users_mutation ALTER COLUMN id SET DEFAULT nextval('public.users_mutation_id_seq'::regclass);
 @   ALTER TABLE public.users_mutation ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    286    285            &           2604    18454    users_shift id    DEFAULT     p   ALTER TABLE ONLY public.users_shift ALTER COLUMN id SET DEFAULT nextval('public.users_shift_id_seq'::regclass);
 =   ALTER TABLE public.users_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    288    287            )           2604    18455 
   voucher id    DEFAULT     h   ALTER TABLE ONLY public.voucher ALTER COLUMN id SET DEFAULT nextval('public.voucher_id_seq'::regclass);
 9   ALTER TABLE public.voucher ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    291    290            q          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    202    3      s          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    204   ]4      �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   �4      �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   5      u          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    206   �J      w          0    17942 	   customers 
   TABLE DATA           w  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_day, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    208   pK      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    303   �|      �          0    28161    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    309   ̬      y          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    210   �      {          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    212   ��      }          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase) FROM stdin;
    public          postgres    false    214   ��      ~          0    17984    invoice_master 
   TABLE DATA           W  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type) FROM stdin;
    public          postgres    false    215   ح      �          0    18003 	   job_title 
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
    public          postgres    false    223   ?�      �          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    224   ��      �          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    226   �      �          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    227    �      �          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    228   W�      �          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    230   �      �          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    231   k      �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    233   S+      �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    235   p+      �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    236   �+      �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    238   �+      �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    240   ~,      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    242   (-      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    244   O.      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    245   l.      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    246   �.      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    247   ]4      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   �4      �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    249   �6      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    250   �;      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    252   pA      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    253   �A      �          0    18191    product_type 
   TABLE DATA           J   COPY public.product_type (id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    255   �A      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    257   gB      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    260   �D      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    261   �E      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    263   �F      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    264   rG      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    266   H      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    267   !H      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    269   >H      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    270   NN      �          0    18736    sales 
   TABLE DATA           �   COPY public.sales (id, name, username, password, address, branch_id, active, updated_by, updated_at, created_by, created_at, external_code) FROM stdin;
    public          postgres    false    297   �N      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    299   �Q      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    301   &�      �          0    27167    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    307         �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    272         �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    274   �      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    275   �      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   V      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    278   �      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    258   f      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    280   �      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    281         �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   �      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    285   �      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    287          �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    289   @      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark) FROM stdin;
    public          postgres    false    290   ]                 0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 22, true);
          public          postgres    false    203                       0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 13, true);
          public          postgres    false    205                       0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 2, true);
          public          postgres    false    292                       0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    304                       0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    207                       0    0    customers_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.customers_id_seq', 208, true);
          public          postgres    false    209                       0    0    customers_registration_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.customers_registration_id_seq', 189, true);
          public          postgres    false    302                       0    0    customers_segment_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.customers_segment_id_seq', 2, true);
          public          postgres    false    308                       0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    211                       0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    213                       0    0    invoice_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.invoice_master_id_seq', 106, true);
          public          postgres    false    216                       0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    218                       0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    220                       0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 265, true);
          public          postgres    false    225                       0    0    period_price_sell_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 884, true);
          public          postgres    false    229                       0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 509, true);
          public          postgres    false    232                        0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    234            !           0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    237            "           0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    239            #           0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 13, true);
          public          postgres    false    241            $           0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 22, true);
          public          postgres    false    243            %           0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 153, true);
          public          postgres    false    251            &           0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 24, true);
          public          postgres    false    254            '           0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    256            (           0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 26, true);
          public          postgres    false    259            )           0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 18, true);
          public          postgres    false    262            *           0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 31, true);
          public          postgres    false    265            +           0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    268            ,           0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 12, true);
          public          postgres    false    271            -           0    0    sales_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.sales_id_seq', 28, true);
          public          postgres    false    296            .           0    0    sales_trip_detail_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 2313, true);
          public          postgres    false    300            /           0    0    sales_trip_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.sales_trip_id_seq', 2223, true);
          public          postgres    false    298            0           0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 16, true);
          public          postgres    false    306            1           0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 39, true);
          public          postgres    false    273            2           0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 10, true);
          public          postgres    false    277            3           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 4, true);
          public          postgres    false    279            4           0    0    sv_login_session_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 1031, true);
          public          postgres    false    294            5           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    283            6           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 56, true);
          public          postgres    false    284            7           0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 42, true);
          public          postgres    false    286            8           0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    288            9           0    0    voucher_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.voucher_id_seq', 5, true);
          public          postgres    false    291            F           2606    18459    branch branch_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_pk;
       public            postgres    false    202            J           2606    18461    branch_room branch_room_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_pk;
       public            postgres    false    204            H           2606    18463    branch branch_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_un;
       public            postgres    false    202            �           2606    26927    calendar calendar_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.calendar DROP CONSTRAINT calendar_pk;
       public            postgres    false    305            L           2606    18465    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    206            N           2606    18467    customers customers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pk;
       public            postgres    false    208            �           2606    18784 0   customers_registration customers_registration_pk 
   CONSTRAINT     n   ALTER TABLE ONLY public.customers_registration
    ADD CONSTRAINT customers_registration_pk PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.customers_registration DROP CONSTRAINT customers_registration_pk;
       public            postgres    false    303            �           2606    28170 &   customers_segment customers_segment_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.customers_segment
    ADD CONSTRAINT customers_segment_pk PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.customers_segment DROP CONSTRAINT customers_segment_pk;
       public            postgres    false    309            P           2606    18469    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    212            R           2606    18471 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    212            T           2606    18473     invoice_detail invoice_detail_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_pk;
       public            postgres    false    214    214            V           2606    18475     invoice_master invoice_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_pk;
       public            postgres    false    215            X           2606    18477     invoice_master invoice_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_un;
       public            postgres    false    215            Z           2606    18479    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    219            ]           2606    18481 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public            postgres    false    221    221    221            `           2606    18483 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public            postgres    false    222    222    222            b           2606    18485    order_detail order_detail_pk 
   CONSTRAINT     l   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_pk;
       public            postgres    false    223    223            d           2606    18487    order_master order_master_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_pk;
       public            postgres    false    224            f           2606    18489    order_master order_master_un 
   CONSTRAINT     [   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_un;
       public            postgres    false    224            i           2606    18491    period_stock period_stock_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);
 F   ALTER TABLE ONLY public.period_stock DROP CONSTRAINT period_stock_pk;
       public            postgres    false    230    230    230            k           2606    18493    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    231            m           2606    18495 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public            postgres    false    233            o           2606    18497 :   personal_access_tokens personal_access_tokens_token_unique 
   CONSTRAINT     v   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);
 d   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_token_unique;
       public            postgres    false    233            r           2606    18499 $   point_conversion point_conversion_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);
 N   ALTER TABLE ONLY public.point_conversion DROP CONSTRAINT point_conversion_pk;
       public            postgres    false    235            t           2606    18501    posts posts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    236            v           2606    18503 $   price_adjustment price_adjustment_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_pk;
       public            postgres    false    238    238    238            x           2606    18505 $   price_adjustment price_adjustment_un 
   CONSTRAINT     ]   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_un;
       public            postgres    false    238            z           2606    18507 6   product_commision_by_year product_commision_by_year_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_pk;
       public            postgres    false    244    244    244    244            |           2606    18509 (   product_commisions product_commisions_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);
 R   ALTER TABLE ONLY public.product_commisions DROP CONSTRAINT product_commisions_pk;
       public            postgres    false    245    245            ~           2606    18511 ,   product_distribution product_distribution_pk 
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
       public            postgres    false    248    248            �           2606    18517    product_price product_price_pk 
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
       public            postgres    false    290    290            [           1259    18584 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public            postgres    false    221    221            ^           1259    18585 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public            postgres    false    222    222            g           1259    18586    password_resets_email_index    INDEX     X   CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);
 /   DROP INDEX public.password_resets_email_index;
       public            postgres    false    226            p           1259    18587 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    233    233            �           2606    18588    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    202    3398    204            �           2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    214    215    3416            �           2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    3512    215    280            �           2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    215    208    3406            �           2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    3435    221    231            �           2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    222    270    3498            �           2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    223    224    3430            �           2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    224    3512    280            �           2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    3406    224    208            �           2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    280    236    3512            �           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    244    3462    250            �           2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    202    244    3398            �           2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    244    3512    280            �           2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    3398    246    202            �           2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    3462    250    246            �           2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    3462    257    250            �           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    3480    261    260            �           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    280    3512    261            �           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    263    3486    264            �           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    3512    280    264            �           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    3492    266    267            �           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    3512    280    267            �           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    208    3406    267            �           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    3435    269    231            �           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    269    3498    270            �           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    280    289    3512            q   -  x�m��n!�ϳO�hf`�]n�5Z�6�zh�fM�j��з��6� ����&�J�w��v���=�N������
�&0[#�D){8�!	*M>0�����԰_e�`��/�SŢ�IP���T#U����H��ä�Aƶkn�g��4�JCQ���!�7o?�M����E��jwv���[���P��z̗0��K{
e��	�I�2��tGw:��KW��PčMz'aqhZ߆R�<�\�4ȐJz�B�u��󁮪xk�t;-ph�6�y�G���Yt���o�?%��H2��}?˲o,@��      s   M   x�3�4��T�Up*�K�N�S00�4202�50�50T0��21�21�3032�4���2��p��/J-V00"�!F��� �J�      �   7   x�3�4�?N###]C#]cK+CC+C�\F@FX%���1������� >��      �      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      u   �   x�U�A�  ��
? Ywa9�^��
cE���iMO=�d2N��[w��^�n����.�?�e_��y��o�ӱ+�z�A@@q��gY�G#C	R%Pu>��g[z�8��%���jh �m���$�^?�����,�      w      x��}Yw9��s���9�2s�bc_t_nʢ���2��S/i�%ӒH%����o�H�F��*��$R��"`�&�t@.��ϓ�2/g��	�/�d��㫫��*��O��6ᔋ3��8#��+s.LOq�E�G�P{.�9�K~'	�6�=&��T$g�ǭ~~����~�r���s�A�oL�$]��̿���qC����\]M^�/���uK�M9 f	u��ʞe�*U�S�~
IF��ۇ�?#�O{��}��~#\��]����g�o��_�G�{�Y�DT�Q&O �UZig��
^�'���f��oF�M����4	,�<K����n�o��.��7�@��c眞Sݳ�jy�ׄ�s@FU�t2��|���;���,���z\������I���xPVTS�\r�z�I��:}����X���9y}H.^��wX�����7X��{NE�i� EC�ܹ�5p�aMh�Rr��/Ux�ZJ��'���t��� �D2[��NƋ	���|9&�t|�&���<���?��t�ӫ,���*�+q��9�=*�����S�p��&7�A������ȼ?�X.�����<J�p�Q�PZ��Ns���۵�[K-yܕ2YL2Z^��� ���mz��糌�'="Xqe9�&̜3؝�礡�c�>,�g��tv3I�0�c��y��h:�Ò��N[QPP�v�([�R��2�J.`v���5'֘3�>f�%~��
�>�9g=�(���#�c����d�g(^R�ST+xr�{N8K�t<+�9ȟ.�O�ޠ�' O�!�>���5�ϳAr�[߭7��n�m���ے͖����Æ�M�J��t���'����'a�$�]Z<��|͍���3-��z���r�k���/�]��U#�����&��-V�
��X���>��b$�����5bI��	#J�6�m H�D��`�R�Ƕ[��F9���֛��r�}(+�aGxycFK�H\���%���d��� ��
�T���/LC�-G�M&�,��O��V���PW�,��Ϩ>���q�B9@6F��0~���W��^�/*y��O��x�!�XL���_r�-���0����)_{����1�NW7^�@���{|���݀H�%A7I�${�ǭ���:]'�����
��2�s!A�X�d{�`�@T��y�!������ŗG�#|�x�������K|0H�0Vk�:�L��� ��N��|���>hox_�'���*���K ���EkӄF��J��F��3|�~\=����W���m��� ڲ
�hL8,Gr0�ޘ̗�l�M�|�˟��H�.@�^����o�=�?ۂ��i���Pk�0����)��}y�����W2>�0�3>i�`\�g���Z+��fc|�4a��ҀJ�zh�'�K��[KcQ� �=x��I\Q'�$��> Ͻ r,�(D�"dUS`�u�-��f��BFud><��L��CR��r0-��'���"!��� ��P��JAV���Exl����q� <Ҁ����X"�e�DN���%G�CJ-Y$L�n���p�W�r�JY������E&"7��r��!��\� q�Z�C"ih,>�h��XGx%:p�x�nN�=]t�`G�݃%��?��K�Q����u�Z@Źp��`4w�{�;�~�#O�a3�r�Ɋ&/�� �~O9��u禍|�d�-Qa����ϖ�m-�N�2`b���yk1��o���ϱ����Nю�h.E��M��"���(�Fx�l��5�a:K#�v��>=s0g-�mp��Q�klOlr1�_��^;éq��ki���~P����Sz=�(����`������~��Wfԙ�q-L�%Dw�P��|ʿ=�����c�+�5^C�2 �p'{zõ��u���nl�)@�ǖ^����":�%0\s���'Yw^�Ǔ��A
?�24�2$%0�_r\K�����@���x9�k�w�g���	�6�w	�\� ?����G]t!Bc~{�i1���g-���(@j�m������a�F�M���/}~�1��e:�����ү�q�
��
ݠ���/FP5�3 /`�
X[��f�t$<�c�j��7�7�=(�5����)9z΁}�� CYS�)�-�J��h�ժ�׀s9~b�]��4��r�$�Lgr�]L�W��j��Nf�ĵ����4��}�u�E�~*� ӊ1m!�P!��=��D�oXf���9,~2�/�c6@�W�)}��FS�Q���>p[�aa��"�c���&���΢&��t��t<��F����4���a��\NФ���0s�8�g�l��`(�+L�����'��`�Q\ '�@����h�`�ۇ-��?=�,b*�����x��� ��6�G"X��a��'�����x���4��)_?��|N6�d���~s�?$���U����K��o�y>n7��M50�hɰD���俲������z�&Ⱥ[m�������D�.S�:V@��L�C0vk��z-�������;�w2yȏDR��7�W�o� �1�}d�	#ᙸ(E��U��F�����^��8�8H�?�O���!F��tc�>����M�
6M����� ����<�6��A�_�	L3�i=$�%�а���G��o0RX���n�!14w��|G��c�U�%eI��x���������<<�_�G�F�%�H��Js�<�C
V�yG]��Q��ư'ϫ�|� ��}_mJ#�S���Q`�1�H���������t�F��G�7&1�{�G��2��|tq�z9[��F���q,��1�S�cO��b|P��7(8,��,��;��M@��xr�EJn��i2��&sr5I�,K�yL=��N�rz��#,<ߢ`�z�I��+FM�RW0�%���<#�)�A1J"2A���Q Y�T�TU���	xNرa�@[�y:�f���S�t���I`0�=��1�HT1]��/{�S���?��墰\��9w���*l6ФE8a#��?K�G-><	�cy3��:�������S��c��%R��]�9*kF&��GY8y>�JL]ςG�|�{���ڋ��
\�BW�o�Ȗ�$��tN�����9^G��vO+�ݡB�̟{h�, �P�!��PO+�l@܇
��,������#T�`���scPv�O�q�I2폲!�]E�li�4`����/`���n�[�/Ɵ��W=�Bw�б��,����/b`�@�*0���x�|��q1��y����O4�>~�]�# 7�L��h.���g ���	��ԇ�;����_�����Q��:��s�/)�u�p� s��hza��
�έ���5'l���_�jmOH�y��L7�P?��=q���!g*����)(}���^�Ǘ`8.��'Pw��|���8��z���4�$X��j�)Re<'�p��6�PU4�C�W�c�s��9 �W��]^��*J�܇ܳ_>0y�D�܁/Nh6(��*���Yb�/��x^"8�3K,��B3폯��R���H�*��]+�F�c-o��@�`�u�dfJ���Og�%�30e�Z ���s������9��u��0�O9�>���Ÿ�,����*S�����s�L�_H��KU����){>��C��~��u��O^�Q�gfµ��y�x��`d���J2W] ��8��p�l��Ӻ��O�
<r	ӁÞ�v�'�u�
��G�:��A��,R�#ͭScZ?�~>�pQ�N��&Jma��ډ�xQɻd�]���4f=�B~E��t�Q^��5�T�lA���x:"Anѓ]o�n�}�u>N=ᄍ��6T�t��.��w�/���c|�]GO�㈤�<H��T����ZE�Z����е��\����9:�oy����
��fy�_�J���3,͆\����
��1 ��f��;���_H�`5EO +�-��V�m�Eg����+~N�FV���6�Rݱ�x���)�̆    �vS�0ҳz$���z��6�*��!����i���cJ*��~�z�9E��nO`I�c�C��;XL��<��2k�����:=&[o���JQ����"��O�u���{R)
��j��8�V��� 1��{��cv�r�k���$hˢ՞XOJ�N�آ:���P:����l�Cdh��,/@���,�,�&����E�H���r��*ײ��2Ŕ�⃶����۝DQ����Q�s�R螳
���kgb�	�?��`�����r��� �`� ���ߐT��8�o����,j&�+�Zr�lQA��^���p��:�";���E�q �1^&��Uւ���P��1t��61]8�E�qܣ� ��~G��%�LR'��Z�R&��rmY��teL�￬v�����w?�������MU聈] �J�?�\)�k�Q�&j�O| 5끌YӁ�2�����Ȟ@�8r�Eɤ��"��6����&��/y m� tk��Y��?�k�Ex��.��d�6�n�-N�m�>d���f�7c�N?����lC=�?��r� �����]�ˑ�3=��̦�q�j2�t��j��K���=p�8o��*L=?@����=�	$��bP��M������c
+-�Swʂ�;K�����+�{�?�Fl�%1�G�d>�H>e�ד&���~v����3���ʢ�
���@hh���!�$�sn�X�,s)\%���z�������aAu]d��`T�ɬ����y6u�|�wQ��0�͔B@�c���Y�-��!�H�r��A=�jy��0~�Z�?��ǧ������3�����Ί� %�㸜���v������T�`�mԖwZU���^��S��y4�(0^$�WFQ{'��֑��C�2�M��!��K���D�_LP��QyO$���'�q-�V�s��N82�
]�òVh�U�����[�;zn0��b������¡I0]�r��ք?�2�h�VI�4x�O��\�����g|=/���(����4�o�WTv�TNG���\曂����?{���B �ʵv�:u�F�rr�["]K�td:�a�zH�}w��J��4�[f�c8��<��E��!?�'�� ��E�����A�:����R;PrJ<����8'���(��Z!�CS���۳)�Q�����A�'y�ÜaE��<8����U�lk������HH�XV��TcʨG��>@�b�Ng��t��s>K����I�G_�/f���A�0�r�4�H�7�A0�H���-���ϡ���Q|n�f�>��lSp||�[љ��M��$Z$G�d�a���Q!�S�!�EuWu	�F��Cuk֤��Ӟ�ӟ�f�"�U�e��F�_�
H��I�����j[�gEx٫����C����W-���`���+IT�\o��F&��!����H�SZV �]��y�b��[L�p�c�bQa�����#S2�Ɲ6M|�!g�Z@��.P(�R{�?un[@��ܖL�@��>:��Ō60
��٧�a��Ȏ���
�s���rѮu�1\`�a�(��
�Ml����A�^c��Z7EG̕�W^��_~���++ܤ��p�%�ٸE_��M�m��_��Z
ԧ�Ux����=
`[[3nYU|�VŌd��7�!X���V|��B�6�rű4�%�@q��?�����jSr�Dh2O?�3����}�b��M�U�*�v��$�7r�}V�U�K#�:ٳUϪ W�� wWvM@�/�e�����8ϩ��t���{�|˿��I?>�U�����-<�o_��/z>���.K2,�������O)(�c� ��6A�{���A:D�#�O6�*j�+5��8~�K�	��@��wV�&?@�S��'��}�����G�#~p��n�X{�h�+��!C�a5��*����[���ߑ�)\er,mҲ� �X��
�t�]�E�	H���
hӴ+��ev���ol�Lx���\�,������%*\ְ��+Aupw �O(�c���u���qR��=A���H��A�R�it-u���EU��F��9�ԫ1Q�D���:�A.@B�g=���VwO�[E$2��3�;����ݘ�"C�a�6��F�r�2eh���7����<�κ�N�U�ɁZ���_�$Ox���Y�ɑ�*��@h�94X2_ɡ�2Ѫ!kd��T̢Q����c<IS�8ee�7�x�>���t���߅S�y�Ǌ��p��!�6����N���/+�΁'<������6Y�^^a��m������oqs� ����)ϖ/�/�H0^�;|�ɧ�E3	e2��I���i�&׻�:NSD�(\ТT8�6��`�#0}e��(�jp���!��\�ApN>_� �ʢ��i�z�d�M�il)��pф#}BkEЪ�g�����ǋ�ɴ�Ѣ'
֓��},�=�S�/3�·YZ[����+��gs��m����J����^�61`U�t��D����Q��u:gIS��.�c��,
+�y��x[���L����*�� ���"��4�' 3�"�g�߃���`3x殍��znn=��O�>�"�����Zm�/!*b@�0Ο~�i��AO��'�VCo��{��J0]k#e���X?�D�v�׆��w�]U4D���.�c�=���}�
f�=0ͥ�,Z`tS��Rx��:���!Sdl�0��=eO9�Jɂ<k��3�7�>�{����&n��
c��:�[���Ŵ(r�	vO���X��1���S���92Ù�ȧ.�,\W�ǟ���ecCҍOX|ɟ�12��7w��o`���s'�j(��o�5t�r;��*f�D�:�Y�n���ヱ��R�,���@�g�
�� a�?�ii9'�ݐ��ۇ�֨�WX�¤��F-�=�!{�:)�G��1N���k�^�8�l�:�1Hǋl�Ӣ���cI3�D�?h:��`Nk�me���Ew��ɹ��Z`
?]�С>�oC������!Q���mp�j	�|^fZ� �˷�U������>f;�O;�Lj�|^��)�Z��k���Zd:x�@_�3�D�� ��qt�d|B��#��9�ڄR�E��V�a���ݭrPt�8|���s����  �Q�[݌�� ���X.�9:'����%���Fp/]�O����,�.,Jw��&e�L���
�q�r���.�������(Q6K�Hͼ�]�TC�ۢ����u}�W�v�c^0$|�ԥ�OtH�o�T�"��V�q�
��U�3ڣ�
�f~��:"<!ā	槄��s`��Df�so�Q�)43�|LK�Ԁ��	1L��ĆV&����FX��%i{.�(���r�2���X��i�f<]=�A%�+��_KZ"8�)�s�|���%���J��ep�a]�٠?$�c�C�E�+�@8d+���N2s� ����뮊�����4��.s�0Z�X��Q$5��+J����P���e�R��8�>7��n����y%��E�)����1q}0�6��C��y���%}A��be���Uy֏��Q��R%�D���Jh�l�㦆ɂ>a���S0MaˬK��-�$l���W| ���2W+�j�'�|�sGI�!��u#苸�@�"�{:��C|W��ۂ:�W�{P]oud�����ʸ�]EX�ta%ˍX_��۵��Ql���uWv+��I0�c��A�E}��/y�>���o��&%V2�f,WPY*��e�N6ض ���b���?ߞ����.��`��i4��IzI��T?��ک+P;�yҹӉ�-|Q+�%�l9����/"�ӲÀFu��:�u(���=Ŵ�l0��'���1ƨ*��i��Cr2�B�$N�3j0W��I��f�eJ�8<�!~�m�gş���c$���:2 ���wȺ��w������0����%�u���jRڱ q���-�Ӿ{h<��Z5#�e�=},�6�[#έ���ަ�/F$    ��:�J<�X��0�X�qkB�3�z�I�Z:)V!���KZ�˓q*��(e&�Mg��M`�HA7_`'�7��/��Xd�Z�ơoͲN{�l< W<�^�ͷ�������U��L�b/q˓k��o�	b��=y�>=����2��'���V������=�p���(v���p8��|�� q��>�����q�e�����]�ƃn��4�,6��M\�h���^4t��6�Z0eN�fI�J�����I_v`��u�4��l�g�9Umcn�Qɱz!�ny�����Y��������DO++��'�M�/di��A0Wۜ��o��r�;��۸�ୖg��v�:�:;�u�=�,	P�}B��y�۾���l��=@�9H�3@�[�������w��$/C�#�V�F|���~�>��:�tc��&`|6xL�nGW���_�8������D�u�>XAg�K���H7�2�[FM��L|s�j��H��j��i/�����$m7��{mi�wޝ�¥��z�s�-�l���`�RY���>4D�Vn1?P�'Cl��	=�����;�XAO����qPv��0�Y^E��ˤݶ
AB���
dN� gX`}S�P����t>ʢ��oQ��W��T �1ǅ��s��Hw*���+���R�7��\�i{0�*-��Y�]��-��`m�ܭ�n����6zǴ�-����_b
��+���4�H
Ia��CR��+'��SRv��@v����`v�L}��L�`ah�ge0HI[^2��;��ҬD�b���Uҝ`s�r�!�4�pi�y	Hҏ����/���C&�/'�� X���oT����_"�Sp���ƚ�������}˿� E��Ma�����&���rcbA���]lz���{r�K���24p�l�д?����Q�q1�v�#�b�'�o���!oMP�5,(�1�U?�Da�@�̀Ew�F�/���)x}v ��?�,�6^չt=l.��\��64B��M����q���7l��fj��}����`a�x���W�] �gi�T�э��ϧXD�L+,�[��`��n�$��d�v��~���}��B���8��|��6:�o|�����8���4�sjiż�p�����ǰ�ͩ$�;\�7*���o��E�{ǅ=	����O�sB�v�<��Z��T�
��õk�q�"���z��*}y��g1�W&��SV��ְ�b_�lL�L�J���Ppֹ�]�b�w)1��Z�۬��pQ����N��9��!Q�6�ڋ����[�*�D�'��ٴ�[�7�N@���ă=�	�`���Z�:��ެ��O0��W0nB�k��Jym~���3%J�r��~SS�8v�exD�}JI����x����#�t��3�}����*��7��[
<�ņ�-�Ee�}��n�R�Uy�e��G[tP� ҉ �ɧ����|�L.}���=P��?��=+I�[�*&����KgZ���Z.:��L�anx�e#��a���7� ��k�G�y�#���g�.�����ch��Λ3�)g66�� �M:��ǫh0/�+�[b)��V���uE�zŘ�>�t"��U�á�Dg۪X�ɝ7����d�}ٱ�^��ق���}�o��|�0���*HDh��a�+�1�5��&�SZ�=�ۍ����,"��o���ʪ
�ar'�����nu�������iZR #Uѡ�9�����n0��/����AV�� ����b1mɔo�&��D��h���30Վ�����
SV� ̕��������`�̗I^fQ���_�r�#^���v���<��C�y_�Q�|�s�d��n���3:�\�+\խ�+U�KV�?�v���5'�c�C6S=iA�6�Wz��}�ߑ[K��xm`H�Ō^�=��R�m�j�d;��M
C��w\>�L�kE�}ɡ����/w�q�(!�{%E{�<q�'��(w�e�� �����'�x�V7R-.	��$�N۸"��x��}8���.�9'�ZN2	�||�=��=����EY�6,�={Ƒ0r������r�8;#�����%��s����z+���c_���d��m0]�n��|�V?5���G����v��DP��Hg?�6,/��䢸&䯹�K`L���WB��mk�^R�!*>ދE�'����X��]�[�/3
�l�/j'�u�	�]`� �Cxj���Lr5�M��-��"2}��/T���7I��e'0��o�,y��-n��:T��4�gt��J�l��Cy���!�![�?aȂb/��!���?@�3�;���v�[�[�t{��&��I0�,�s���aŠ����8��ty2���Out*�:���1����7.&�ɐ\g7钜W�5t�a='��(������(MyQ�KxhG����U��_�K���'r��؞R�k�����n5���R�Y���+q1� _�[�.��f?���[����Z-A"ֆcԖ0F��У�/�?"�XZ��i�m��p3����
T*��ȧ�?gBfD�p}SOJ�J�_<0`�?v���Gd����@��K�W�8h���e���HĮu�}8k"�g\um��|�6,�ۤ8�E9���ʺX�q=���/ kViȬ��N��ݦ%2����B�8"A��ADt�c{��%%�a:�ww�i�Ja�]%�JS�/�,���"YCeI�ڋD���������4B���M<Ml#�M�[����*��UQƮ+��yj�sV%����V��@�c��(�'�%@�� ���7�O��z]��!E7�j�y��iP�K5����{<��P�o_�ǭ+٫���倘|���k�Ga����/�׋�C<�I�)��Ћ����g���3�p\�M��",���;�E�/"�Z@Q�Ё-�jCTM���߂���!n�����#-x�{����ZO�R4���W�:8t�t��ԭK�d�Mݸ/��/y�D�b�$z<' �N/x17��QT��2�:	#��F�+�s�c5���׆�h����U��;�}�	���}ߝ� ���&˥�X��$>�=�	��2��br�5�E��z��m\��iz՟'�'U����)	����L|�ņl�o������v�b��C�]���p����Sa'8Ź���j��������זi^�J�j�T��w�� m/=X����_�)��󱧼��-��"��q��(3+2�-="����_[�[�ٟ d0U�!�o9c>XT<�}	�KA�����U�'�����蟆�̹=��дl8���P��ﯗӒ�H���}t��ވ��?�t���W�}����s����zs��S�}+2��F�·�����|:��!�s�~Z����R�F�V�%�ʰj�q�B�����^�a�u|e
�+:�g`)��̓���~s��#\�����ca�`��{ۇ3���H�o�ɱ������V⌹n"�;qE
@��� X��Ռ�̄#0rؾ��[ϱy�yai�l������1�4�9J�R2�_@>�r���a��ݐNо%!X;����6�։TZ9�����uL���U�sQ�u��0��5Ir�8Z�YPNƿ�w��Ćy4N0�����5��G�)�p}�F}���i+�Uq�n8 }�M��U�YK���呜҃����rH�د��/�d0�s{��:F�}���i.;bU���A��'aUJ�Aeqs�&oL��X����?�|ۿl��Ml&b+:��X�:��Wٌ�NƓv��cr�o���c?a���Fa�b��ӰҲc1a�Z��.:���	c>��bکm�U��D�AD�H>���c-.YK��1�l�lSF�l�% ܟ"So��d�˰߽�#�DE�n���q��~�H��94�ug{N����¾֦d�4ip{��FѸ?;/��uq�]:�Ɔ>o�p?�FKf�ۖ<��"f�ᆺjg�r��E���'Ԑ��/��I��2�vlܥd��Sz=[^b�P�g,������ӗ��[k���{+`,P�H� &  '�l��>&��R^���4�St
p����g���b�|\=��r���o���0� 8z��j��0����[�C�_JmFAx8�{~x�2,�ŘH�t6�L���.�(�-/������	��t*��f�������i�ͣ0�I;s]���&S�C�P0���$ld�GJ����Ԓ��
�{�M'�~��+$��ְ~d|9)+p�©�5b1|O�%�R��Ϸ��]�����Sq���^��Ik늫�%fW�7�� �����������J�r      �      x��}msɒ��>��"��ݍcs�ޫ��,,!hA_OL�F�bd,Z$v����'��y���x,�e:�*+��ײYQ0-rή���;v���g�GV�{;Y>����C9g��	볛��G�e�~�\��9�{��3��q�rR��g��3�����r�}��M^^g�6�|�|}�7��.�3�E�jť��{�R�k�U]L_^��/��Œ^��v�u8y��X>���/" ���B��??��eϠ�a1g��Y��D���6������t���zY�/�|���r-�r�+��e��%}&AQ������r�2}�ja�t�8�F
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
��fT%�ϋՊ�4�mʈ�=�k�\�  p$�W��;CO�Z������5O/�4^�T"Ӎ���#5�TS�O�T^�S�b�֦(�0��w۩$�j{&�ޥ@�O�q�	l�\�E��+����B��a����R +8�W,�/ٿ8�`k&E�~~�a�rc� vI�o�OG����rw[�8�J��oDyk�<����{ O��[r�#�5n���?6��U1�aql�����j®���ϰ�w���x�)�4Ƥ�`�!���.�T0ʥIs�84U�=~�Ϟ}��w��c����b�@A7���v籽.�e0����BWL&��L�]�L�@M57��8i���g��nt��:|�7<�0Ri}wT5b)�����ܔ_�fp������C��jYdg�b���LW\���p��m0���H<�V(�PH��h����`/k\�%�g'\C�U�{��;vp��������k0��LĀ��E�t��E�*��k;T�߁�u�v�a����A�W7e[�˽�������%�yd@����vw��zOE�4	��v\^#\2��a?z<�i�Y��!�R�@��(�7��;��p�i���%v�ڽ��`�I;C�!b-.��W�J5�(�xTռ>�*;ޡ;�����r5�)� ��
�x��德풻����0d�� ��O�C�@�W��y�ez K�R�__*���+���cw^4q't�t�T<F~m��o��	>�      �   8   x�3�����4�4202�50�5�P04�2��22�377�0��2���ů&F��� .�B      y   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      {      x������ � �      }      x������ � �      ~      x������ � �      �   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x��}�$;rݺ�+��@2����a ��w����-����9��b��+X�4�]���<F0^�GIERN=u�%��_�����?��/?~����?����R���K��ΟE��͑�ܠҎP��Ve�����㧦��m������v�����V�����ҳ�\�|4���T@���>����r������3��wd9#�K�=?���?r�c�%RK�����2K����߁�Y:���c��.��@㹛QX���`��f1F�gO:+�jS*k�<"��L�3�琚�x��#��v�,��H�a���bۖ�m+��J�nZ��5|n)Xd>w��#O��9��dNe�u�<�}�v��3���Q��B��F�Ygǣ�x������?���Gy�
�Қ�G���R���I�o�V>��+xn���G�[SM�ak�Y���}�jd�����r���\˳�UU���F�L��Y���h�Q�ǶZ���V,sm�27�(�U�-8��k��C�Ɗ�b�����?$o�b��ߋ}P�}K)I�C�[��k�Ұ}A|��xlӈVĶ��Ig���Xll�)��T���T���>oA�J���koPu�<kp���%��2�!�c�|ނ;�ph7��x�5i�}�[Aq�)T�jzl�r��ϔq�v)�P�+-�댽�y�CG���oX	�kX)�ڠ����W��BN����K�V���3^�FU�,%�>���Ho�Yp���i��|��U�Z��j�V8�����sGX.2����h�	���~�!"0#�@4�d�-������u���n���<ZM3?��U�o�NJ��Mm�ڨ�VC[p���qvMP��Z<vƪn�q
��s�u��f�ZۂP9x��US58��!�4��H������kX�.�}����ca��k��r����*�ɕJ�,���7���0�֧���Q����g>�5�X��m���ڏV�$(9RL��h�c���J��[�r���v>g���hⰙ�c���j�$�t��:,<��s+���,='@7�`Xjhѕ�S@��Z+��汱z%�^�C��u�n]@a��� k㎍4��+N϶I�fJ��2�1A�=z��jfb�2��<z����\�>�Q�/��vG*I3&�ЗKx�
&ȣ�jׅ�v�8��;RA/���R-�L��	Z�\=�ǟWh�A�T�?�;V	���w���;�]q �w�I�����_�-���������`gxe�x��Iо������{$�9@��%hJR~���/e(I���M�	�_������Ø���ey�7�f�v�rX��[N��.oʏQ�):_�H����%:�K�Q�����@�"��Л���
�3 �6�cT'A��o�AO�VF��;���r�JB㑭�N٣o	���Y�y�؅Cp�<�pjI_	�~���G�-�$(��B~$��G���̹�k��I�V)����1u�F{LGI1"�M5�}�0�U\�\=����������ן�B�meO�wS<z�qD�`�-�g;*6����ɖ���o�O�	;t�b:"�2�I)-	c�{΂Sk:"6�E�_�.2��f��c:"�	M�@�9_F��8v����&kX*ݩ�|�0'(4Xd�����4��m���І7����'�[������={�7��*�#Zt�a�i��KPevI1��f��-��P����_����������!���_ nC�/P��%�X�2�ۘ��Pݯ���������_���mI���	�Sqi�׹��kKD�v}���"��Z�_��|����
��HO�=�W�-���U8��>�$��@c��>'��H')D�M�L+��~��5�/[�iũ�sv`6%��s{�������&��"j���OY��I9�iK�<��G�����g�%�ϠeՉ����*]S�eW���0��Nx����?���?�{8����?���%����i�����C��Hivj��舣Z�L�B��`ȍ��8:����F���h��\iz�6$o�M���I����z�*����
j�☨��8�5;Uk�:�BQ/�����n�A�q��x��d�����."GÚ���G���x�	%
��M��W@�"�N��Ƞ]:3��)�4'��rqd��T�w��z���%���;�mf��Y�]@�N �;�n������	�g���]6�M��:��*��Cӎ�����`+0�a��w4"g��<�;P�3��A�&~N�2H�g��1��K,<<�o��4R����r�����]@��H�����(�% ��[ ���F��X�7��\u(���

 7%�&&�7T8�OK���_�o�"\o���%�z��<W��>q$tĵ�����0h���T�J ̓ޠ��L�G�5 ���wϓ_a8��\K����m�@7A�T7A��g�:t��G��K�/r�+#"�p-��us�u>�`,	��SX�?�/B�0��������:/K��5��PLUnBr�^��p8�3�ބH�Z���l�Vg�^��_f\"hr<��B��:n�]���b)5��"�x�0���V��,���s=)	�T�[Ti;VON���B@���Z�����q��x<��j�3\���nj��0�Oڞ�kj�A��9r6�_��w��Hᡟ��6�������Op�h0����R�?֟��"��hj��C��N�ݒK41&���"����r�d�mӰ�V��O���pP���Ԇ�Ҏ�Nͦ���� ��"x���]��z�J�H
�#I�~x�e
xS�y���;�Bt�i�nh�Y���Vz��x
�b:��ؽ�h������ʏ&#3+(��*��ř0c��N�a���,x�-�DT�;8�y"��+&��v���K��ఖ"��nr�k�byz����h��X|�xy�領����&��3|��x����EǷ+�0ZcFH�x�B������4,����-h�n�X�Cp��ˁ�k��
�]3<�h�����Ƣ?�H���Q��K9���8��bk�<|�v����)��47�x�W#}UhP��WF��Pݍ��82�/�;�l'>N��th<�}ن����grp�����Y?����^�A�Ж^��O������Os�����XQl:渊_;��`1�ڲ�R���S���ol ��W��&���p��X�ޚ�~EK>|�L��'C ���t�������9�T��#�$����ux�&4,����F'8CpZ�f{��(��x��T���j�p�@�����2�6�"�c�h;m�bfRzN��p�?�
�t��c0�Ȅ��ǖ΂w���Ll5���>�:�`�@8�"�%5?>].;�	@L"N�wJ��\=y^c
��uZN�J�)����
_޳Nz�� Յ�Z��@��x�,8=_$��U������q׋�-���'q��c^��}X}���� �Ne��c�j�U�u�_+�ܒ�ëĦᕙ�e�6+��yPcr�u��1)Jj�dϼ��s��@�,5?^����$���{���0���?��~�Q�,Y���b���J���LB*ű_D[�1x������/��a+��neNe8ـ;�ԥ�Oo���5,�nq��-����K�s�(fqIQg���G�����n�j�ᡱf��\�_���������`����^g�E�t����ж���1�r���?���j�63�$�2<��|�M��5O�4+�(�yLak���v�?%��2Ǽ��tPۖ#�X
̝� �y����Ü?�=a��c!�Є3��/�ڨ��xW����J /f>��!&@�W���aw����P�`�K ��
O��sY�J�-v��p�`���_�%�Xm��b$�w0� :9[��,�������\]�[�a�C�ñ}������^����t <����1?}m��z���Aa�a��\X���L�8�B���0����󷫇��Rp�y��͛*������%�fK�C����K    ����a�Y���w���ScO]�S��sa)��p̛�H�i�LX����ہ�D�zX�	��q�Q�t�{;�x�.��$�`uL����~�yܹ%2��|��+Y�<��k<�r:jp���6�D�iw��pl��ѱD�j��1i3�8%�4�c��
�5�{���~��2w�5rb�*��=���۞W�c��R��}�+y�2���O^y�F�c�j��	a���x�3��|d�������4G<|y=�|�ݢ�J;eZ���0�����1"S�#��Q�;m1Wk؅:/���x8�k�3��[���<-�c���d䩙 ^N�'�:������+Vɲ�Λap��k|^��ʍ'��W���b�d�%�A.�nm�U�;�z>����N|�;?�����wG<������n����u�<�I��W*�'o��M/���8�,�]l�	[��mw܃�q �TV�b�B��;��y��k���b����qo\�Xm-3��t�h�J���^�V{�h��-�!a�z9��ŒB�	�Rx`���j�.�뽘��!���x2�o�2�'�e��;&�g�����f(Igi�����#�Z/�e�X�� |�gՂOj��F�a�JU"U/��+<gA��P�I�͚Z$ʂ9V�W����������,����t;���.��+eX����U��t;�k��/��-� ����3Q-"�+��(��1��`��;O;o<r���<5<r�Jt���u����C���,�^����7wY�Gc�D�,!=g�w�W�r�*�9���ޔ�ǎm(���j�����R6{�N �����v YK�gܑ�˙������x.�f"��kT"�[�/����c��bi�-����`Ad��U`U��&;��__��|k*��`�gȻ�/��ړZ������o̆�� 7���K@eJ\���kz��2밒+ԛ��	��sh�q`��8]:�Jx���(�3��D��f�J��sI'��8Hf���@��؀;��O/�k������aX~����X/����0�dp����:~=��|s0>Wp�O(�?����Q��g��@� �G�wx{�Kjh_(N�>�������ŮjL���s�l��.��bMy����6H�<F5��Zf(�I2�o�U|K8M��W�LѴ�V0��Κ���_�z}T��΁����RS�hu��~:l�v�6\�!��%����iw|�"p�~%�Y�qgND���g�y�-����~C��5����e|�*��o�T���m4��5�H�˹ewp��?Kxb53��[� �7�3�30�ڕ@O_�*��h,ԯ%��^-wuP�����՜"��]V3{�a�v�l4�����]����p�3�l4�X:,����;����_���[1��vS�ſ|>��&��V0{�7L���L��Qn/���>��w�T/@Kl3����'�Ԓ�(�qoVV�䙤�T���-�=���� K_,mj���>�Q�(�ծ<*�>S��O���y�r����^_�=J,:��Օ �g�A��f��::.�U���������k�Y���Œ����FcQ���,	�:w1��r�4��]��IC3�U��J_vH���}{����'\*v/��h���/��#Z�o��w@�"aƭ��jc�y.���H��$���o�������,p�E�C��s`N[�ʁ�O����:�QFq@���Y��^->O�k��,4A��hWٗ6^{3q�������]�v��V)QXe���:��S��SK�`��`��k^�ԓƦ ������n�7��- ��A���-�v%��f�T�
:�1@�t������`Z��Q߯�s��	�����0gh� aA޽9�5���7�zL��c�4�>l�l��/��*Oߦ�����k��Fz��ͱo�.��f_�W����7ǽ��Iku����K%u�c^/l$�L�;juٷ�1o����j��`~!�����Q��"b�)L%�۞n�r2�_"�6's����1o�;�Y�+���'Nf8SQ����DXv	E�1N�w.�b3��t��(�&@o̾Mut�E����-ض���$D82N�)|#�.���4���#�%~*7��.��H�%'3���
S�t�V����$��D���m4Fp��fMWw��"�Պ� ��}�����E�c��1�֥+~������d;6���5Se?��Wo�v�T�#����%⫵��E)l�&;B�2_�P��F�`v �1˳|%�vue�0Ѽܡ����Ъ�9�êu��<�w j��4P��g:u��C��s�+��c��>���MWg�`������&B��]�1��ݡ�ӿ
L>��F��B�5�r�q��n�a�����|o���Pn����
�o�?�k^���~U�ѧ/����ހ��%�	�KZ�U�O���q�� ��A ,�΃~������ +�����2�P�� �:�P� �H��e��UYp�g1 ��Cw������V��=-�����ǖ�Z��jz����쳜�]��V�\V��4�Mĩ��[4;����Io"�oQ'�q�C�c�2�FDYj�y�"�]��xz��O��Z������Kl�	]ҹ�.�}+�᠜��4͛�v-�%������	�<r��Kb4��=3ٰ��Ymp��|2�"<3��\.8�>�=�ٰ��g%o��|/?��~% �8#�Sf���k�Hݯ�r�L|�a�Y���k6�s�F�}Q��#��&V+^���؝�̆�G٪���З�)�R���d�H����ĩ&�\���;t�C�㡵9�I"(ة�����J|<_^6[cs%����|q ��֩'4�\�'���$nmd,�������+�����#����C��%@إ��>,�&����P;3[�'��{��Wg	���4�y
Z�4��_�F�0ǐm?�̛�r�Wz��-lx��YXj�_�<��|9�I�cZ�,N��R���x�}�����ź�TUӅ�X��,,�6_��;Pı�RM����\�:Z�tqd���Dh�X^�dRp�e�����]��YĬ�����ﷂ:vɦ`�c`K-�a�W��:h��~�?�+��Ļ�i�z��ۊj�O?5 �v�g `�&Sձhx�ݯ����ٖO��������%���z�
RG?������f�qè�@�M?�cJle�([���.سc(���9#%��_�F�y.��(����H��֖莥�������BwA�w	Ò"���+�����p�T8B*�W/a��QuҴ�a���ԋ�_��;c��X���V�\��8��"������k���b�,��s�Xl=�R�6X=X?��J�Ag[<G�"�����)O�����s56x>���p��~d�3~��l��A��L�q��o��'0#?~�aW4�
���]wP�H~|�A9扷_��Mz�8��`�䵭��ꎟ������k��X�ɶ	З;v2ا(��W�"،mX�^�ѓ�C�z�FCv�����<��	��u�S��)*�<��DI�/��_��Nx�����V�&B�h����Qw��DH^"��E��uT8�i�E�oߢ=�2��-z�����[X%�pR���KǷP�[{�"�1�DЍ|��|�g#��S�DT�K�S�u�H��m����R����1r�_[� �����n�׎�V�>��W{V|�f��=��/����%|uLKj�l;vb�z�g0l5���8qz�9��	�����H^@��zW�=Ǣp�(��&,��%������v4���8Y�\Ì�(��Y|L�����q��q�`da(�Q��X	W_�iǕ$�a���oGJL��G�K���7x�q�U��l��P���}��pgC%�?��?���^DQ���1	B���t�� ?o��������m���P������`C�JK�|�Z�P�����$��C�����8t��+/vWY\6�    ��D�q�a��aA��=�B~��Z�E�*
*�UO:�Pe�㺂H���8�!��t���g�T�ӳ��CW����7�� � G��̂� Kد�
�.TM��C��%��Bm�đ���a���j��er@@�	8�$�08��8&Z���r��v��y�M��2�P,��.�	�a*��+�W&��x�_���j�X4<��Y���ؘ�sd"��;��cSb	�n�<� �A-l�{x~��2c���Q�c �X�����ZJ"�hR<{x��WB"�!������:xy�P��Gm�츧��W�a�%�>�|V?�.��0w�����c|m�V�^9;
"��}���욤ˢkЅ�4�g ��N�ȢA+H�( wdK��AҚ���n�D�:�U��$����-�%@-��̥��R6�����\���`�Mv�mB U��K�x��x�g|p4���o��Z>����OpR�J��'e��7pDl��p~�.9�rp;��W$���P�#!��lJ��`{��΢�;�������C!�0 �� l�x}�6�v�C8�3���l�o��'|S�SOKT�{Z835׆Ϸ�!x:V�˙�*&aC���W�o���#dZ����g�����q�$��w��6�����R��^p���V�?����I��	QWo�}r�{�BT?>튈J�����!��2��_f ��@��hS*�!�<�Z$��s�0���!�cô�y���z.O��;Bx�dj�W�bN:�;8�ʝ^�2Bٝ�]����1p2�8S��3Hg{_������u�1�dڰZ��g�g�>M��5P�6/ �� K�Mje{K*�
�pM�х�|���踳 ��0'��B�`���J�N�>�t��dǓ �'y!ƾ���;���J$[i����Ww���x���u4�)�;������=��"[rMp����	/�0��IYwd��uí�2������� �UI�����<w��l�Q�����a����A}v�}����,@mD�]�b�qp�F|�
������o��\X:��Uhs���g�Xm裝�o�}�T������i,~��o�}R��Ns^#z8Usp�08��0?T�̫i������a���5�v��c.98�fE|3��<Lja�,~�BM;~����&8�6P�^ L�/� ǡ�M�Yw�ȝ�x҉A%����q�/����
�G��&�0w�% s"h6_�;2}���1L��c�������62�S��oU�7"8��<{�b��Sn�l��.�����-��)�?���ܞ6oѼ�Él�մ83�����oh�ܯD������@�'����M@]^�����  J�����x��F�i��ǏtP�W,�L�P�&�.������ ��eټ
i8.��8Х��@%��V��S�+���ܦ�����,�j���J}8�L���|7���1L@��װ��EJ�82��`Vt+;,O�|��`�)���	8.\9S�GC���X������7�q�ܮ��;����'|v����Q�8���ѭ�tkWO��Zc�;D290 ��0���N����d�A�B���Հ=2�uá5�8X�jC�So�����58�Y�O_�Y�*U߁�|�9�Y�]�a- ;�v>���l�5�(� I�n9�{E��8��>�}T
��!�vl�Qv	� W�����D�/��g'T\閲{���u	P���BW�_�+��^=�pn���LKrо��NP��7%T[o,����Z��㐟�g�Ŏ�	�[��=�1E�K�j-�~����"!��0n�\j�.�;_R��ʚf�������.�' �4;���9�\c�OX�����	�;}`=�a�uv�jٱ�eW)��'�U�QK����B���6�eG@��:d	P�NR��_0W/@���%��S�_�h^ ��o�k�'Ǳ����='-@o�:�%�4~x|��(]�5�$��I G�J*ނj��rh�^�8*�.}v�.�X�&���[q�S굘=6�4%���G���+k������G>�Ƶ���I3���{���4v$/j�$������r����֦�g��������l��������s6��y���N����!�a/������l����c2,���!d�v��6L�X}6��b�%���r�f�4��PPE�|~2�E�$X<8������;z�}��K��l������+c�^��Ƞxm>���3�	.t2N���cM�ǂ���90����
vj�֫��:ql!�o~e�'���-�$�5�O�#���t�??93o9����ʄ*7�YFh�� �����䭽�0�� �Sl�=��	t�wp�p��3�o>a6��N��^$,²jV8�o�����8\������Za�C��\`�0���Z{�5fo�ӫ�\�JK�P��&�p�z	��#��l�e�C[^��x�2�&>_M^�!6	�1m���V� )�2[$��_:�j�x؁-��1�����,���zH1[�|�!����C�%�Z�4-?Z�z#��H����8�9h�vp� � v�/�Ei��\��I ��`Ob�q�ˉ�o���<��Xha��Xɒ�	'��%��'8}����D����>e~�k�'�K��9r�Z�l�5j��|����[o�L_���caa��Y �fx�y�ͱPl ���5��:�r9&,�4��=[s,T|� S��k#'�f�h��鸄j�O�b̲h͑P>e��W{�ʦM��h=y0| {3���c����K �`�7z������ )0;+Zw��v��s��dƑ��k�,;
�/���[)��o�X�ن�����ݺ�{�|6�m����f�pߤ�m`��~�$Y/8����Á���m��SM�t`��϶���R�Y�ӌܱ�f£\�զ�1h�gl�������nu܀?��b��\GZ<c���Xl�(>sl�݆:p�~,���L�9���Fu`�$�z[9�t�Z	�yp��ݙ�5��U*��8&:kd"ڬ":��ڦ�8�:�Ó��&��J�J��Da����뵕mK;ߑ	bySc�ƣs,��'xG&����_`�q0m�
�Ł%�K��0J�;2�� Q1�,���� @� ���ny����B%����Z�3�̲-��R,ێKX�y��N��mW��v\�u�p��g/3�w0C�k>�M5c0{�`_�^|�,3?��F(W�c���}�w<�����-Ǽ�2�|�TY`�29���H��h�r������w�,�����ڋ�?���w�g��fOza:z�чbb>kA�j����Q�M ?�8�e�?�3��`G0�����.W!+�9"�<<8��/���pjYOӃ[Lm�j�V6,�9�����\�ɵ`G0���W�
����Ńkp����@���J��_?������?=��ݦ=�wV;�;��eM��k	p�`J��Y�
�$��L�7�)1��x���"Y`���ׯg�0M�5����&�E�v���la�$b=��Xv�
�(�۰#K�����p
�p�z��f9�df~��	�F1��jKQ:��;��^벓s���vǆlam�����#[�L&,%88�؎_���M��*�z��CÀ`+��ѨF�ы�p�V��r�����%{p�2����)��_�>�R�~S��*@�x��P��+�S*� v������ܬ�ɦ{ `ǯƄ�Lch���vtqc7�}�Kyuӆ��Â�8������]d�0̠���~�z��VK�琟.��g0,�:��]�|~k�|`�&��f�=�5'�l�|�#�a��<�0����dG0��W���qԨ#ج�s��Wk�ɓA�ڛ`4DS����V�>ʘ|rs�)���<P#���#����G8́�������9������#��\W    �^{G	��`b]P��v��0��+���yp���������,��y����$���1䷤W##��������In�����aa\L�[�[�rL�n]�m����wo9J�X���d΅�|���΁<���
�h`[�`��x!5{��5��}v��
�B�@�,�UzT^<�����ī�6y��l��1 ~p����>Jb�;���͑m��k~��69�W��wt�PSQR�XZ���
V�9�qbp�ML���V��o��&�j�qd�JT�-3����?��2���������?��������yW��8�Y� �#׸/�dl�����ђ% ���8[����={X��
_^M*���mF/7���K OY��`��E�=/x3}��m�=����3���%S��{~jq�Xi����%�hN M�0�%W�a�eqD��g��4�Xp�S��"�|���\@NF=>_-��3{�A��	��@鳠I��vX�DN$Z7yL��]��0�7W���0[X6n�C��T�n0��X�+�T�!���%R`e����6
���i��aP�����T90��ld0����p�TJX@b��p��dn_��K�Yi��w|������.���3l8
*[/��c��zM��4;f��~�G��㈮�l:��P�h�,�X�V6�����K<u��[eL6z�Sn�t�,����N�����`��a��8
r�K6<�Up�%y��8Xٯ&<Ǯ!d0y�4�t�L$�5@�4�d���9n��P�:�n�d}�<���_m��|����E��.���G@g����h�_G^^<|��������`
�#�!�q����t�tG������꠬�%�M��sS�3~����U�`���p�o��) g8yX�W8�������n4����Y�:�	�M_l�$^�k�p��p	�/��c=��aw������<��Z�o���Y���W�;k݉zfA�e�G
ǂޯ��Y�0{�0�3�	�Wo�,���4h����_p&3���;Ԁ�s�Kp��i�ds�Q o^�3>��^"�O_�k��Dp�Y�.���q�Ֆ�M>`aF��^3G�|̼������P٫ټ�4�oNL;��+�2|>�v�I�5��;�����"<�L@�H�Ra/��`vH
����kw$�����,�>�s��ǎC,q!�K��f��ء���ZW_uH��x�ofR0:-���
�p.*W�;8�i>�5Y�l_��l§;���:��e�d�q��o?��!!�t�*�Ā��<,|	��.�X�ip�`�c���=ԙ&��V����:��BiG��Z���Z���;��җ����JC~�v�X�d�����b=!�5�|wG:U���3k��΁�C<�x}rP�ϙ�s���~��p����2�d����u|�m�q�K�XG�v�%z���Y~[�cu�kp{�V0�7e��~�P�x�<i�na�b��k�C�j���U����]0+��Y`q�Y���	���R[��<V �p31��U�F�����X=�>�����Ղ��͡�X
�����2~
U�#5���^���dxe��mx���|Xs�Y��姃S]�?}\�Ā�Km��\9�;Y��H�_�) ��+�|z}|�'#���;�����zj_p+8Ďk�l�t���!��UG;�)�ឩ�l8��*68�_��OF�T+����|;�Qy7���M$�<;�Qi%�5���>�^!l�J�����Z'�F����ޣ�����'���S�%O]h��\�tq��
��nܫ�;�z�3�+sB�����l�l���e	�߁�j&j|�W_%B��"̯;�Q��u����$�g6�m��+��%�k�\��bڧy���O��J���.������-��{�G ��p�� C����<k�fܣy��D`���7�
I4�v��Z�pL�k����!c�7��w����%|yi��뎁,Q8>��%�/��nwd?��^2b�WF�dg��� �JeV1��8�)��ͷ_�校��x�w� v-ͪi������7�X8�
��!���0?�49~|a�����x9���+o�z�� {F���~�� �������S�r���T�f~G@�ŗL&��Lf_�GA��8i��4�5v�>8
*Sb%��xV���5�X>��7�D�X���qc8*��(4bp�nff�d^T���J�Us���B�r������~�տnG+���a�
0�I��'����\���Ϸ�x)S{b� w�k��`W��8?������ a{
0�	����rP����c�����%���vGl�?Mh ��`���Җ��W���,���ֶ/�=k��jMk��sǎk4�f�y�1�'���4�/0� ��D7}핖R,8L�yG6خN5JiWr��V��l4޳��m�=�����5���<@N�~\G�d
���rp�,�plxgv����ۡμ]��"X����ݲȠ;��:Uq�V���6�L�~�F��Vj6��b�,j�lr&UX��.����s ��A��+����Z�0j��g	k��`~��a�fd�G�ˆd���,��� �4�K�%ɔ�e�6Y'�AS­J\��%�8x9ݶ� �� a϶�0Ps������=���
�C��%@,` �W)�95Id����UP�p�F�gnמ��ff�Aء��k��ζ������Qx�]m�S��6��Y��@������-��C��Ȍ�8P�Xq!����!��O�a X�ye����g��Z�F�`/�e=�Tl>�����r�]�X��VЎ|�Wh1w���8'���;��X�Tb��8o�	|�o�������_9��)��ܱ�ΌԨ}�ͧwF���EH�uz33l�|c�`���jpz���MRk Nݽ�|�.�<�%������g�h��-�
rR�>�vG;�5m�!/�U\ �ݞ����{���b�j��x�p<��ܯ���3Myp�`G�a���m�����f �����%@m������ԗ����%®/kg���^D���կ����၃@;��qv�P����3#˜֛:�q�C�cѯ��	�����|�dqvp����#55��xx���՝�,ء`v��'�
/[��<x�9w�g6���{�U ͑�uH�'��>;:0=�k�������i��m���(�s�����Ġ���gUx�� H������ô5?h1�:
�(tԯ��
���� �2�.>�FkORF�`Ou��&���C�.o8�|�ܡ����>R���X�Ncs�D�����x�%����}��7ޗ	K)p�xxVG>�;�vg��er(v�#��WG?��Y O0Ne��Ϭ�~�a[Ά�e95�L�����`��5�Y���͖n$� ����&䛀C��� O���$/`H�e�_��d�6�@�/X+�M���!m�p��@럃�x��5�ܗ~�˂fk7�;����M����K@�B2�,R��>a�!����!Z�/���&��8ǳX�칃 ��+6]��U�F��pV����f��Ugi�`s�@8R{jd�����x����!NiOa�ʴ��i9�s@��Zz` /�ZKf���z[�§��Ň �98��Np���9
���D��|WaU1�v�O�+�ڀr�2�Sf�Y�|���R��rK@Y}�p���#yrh�7^��])0�! ��o�@�\��p����)����<����}p�v8 ��W]�%�2y`����پn���C��r7��x�ry����Q��1�M���	��J؝t���#���β6,�w�cX���~Y�y�M�����3x��& [��7�}�_x��9�:y뵣K�i/>\���;�A=ŵ�K�]��� OAQ�z�Ww$��[sz
�0>̡�D��	���; b�}/<���N� ���Z�7����9��v�cd�D� 3  ��^hN��5���	���_�d2��]��6��X?�i�~o!N�`� ,�.A�1��I`��Y�S9��%/A��� [q�)2�x��u��5���u�\��ʀ�B	�%��V�>�V��[+J�^BOq�����t�ʴwh�K����u	�m�j�/���G6�M0�߮_1�ؒ��Z�Z⿎L���S�t0ЭK�N���ԥ^��	�f;É�|��8)�J:����l�RwFv��?�`��¯;}e�"᎔��]I�tk��tu<���(�k�t�^���et�TN���7�&�4m�\Ȏ��7��Z�yA��E�S�DqK�L���	�8��Ύ�q�vC�����O����5F�\*�D���.����W�[޲�ÊUc�e�l�޵t��]�^_�j�oR8��:�.��lW�Mb�V��?�3�L����@��h����E��tV���Ոn��u6Bs�Z���*tC����G����|p�/�ڧ������R)s9[&�w$d�?���h�K�w �hͧg[
�f6,#:o�)��j�Q��Ih���x<�d�&�      �   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      �      x������ � �      �   D   x�3�t,(����OI�)��	-N-�4�2�"jl�e�M����VCLL��6�.l�eh�E�Ԍ+F��� ix;      �   s  x����m�0�oe�,����� ��Q�N'�]#�d �H�bb!�!4T@-�%DTt,��o���z=���vGt�nu�]��s�%��"6�F��3��sO!bq�9H��. +��W�=��R���4�����,��Fmh�������k�-���璚��m�ޓ@mN�x�����R*�RZ�c"���0FS[�c�!��vù��㞽¾�_�H��KMC� �_�V�SM�Zێ.F[�W���Cm�-��E��:��"Y�c1ȥ�8/+1
��Ƚ�_p:i���;y�T�F"g�"���k�QlLD:���Q��;��N�-�В��q��
�	����)��S�]`����ʳ��a�y�%�\n��7�Xb      �   1  x��ӽn�0 ��<��X�뿱s�f�%M3�DE"���4J������;}:c�j�)A䠡F��K5`M�����h�B�3x�}��	�0��;��x��{!�|�K4\އ؊$]u�	寎g:� YSfp��*F'8�v��n�8/q��魁�I�L�:#�Ŕ%e�����A�����wiE����Q�f�)�q�h�`&v�UM��ۦ����m��aӜ���owǣ�8l�͂z^w����5a}��\�B�I���n����o�}>ۗ�i����YFʀd���<Br��!���j4�(�k��K��������      �      x������ � �      �   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      �   �  x���Q��C��N1�	��D��������TBvT2���:�H�P"�LU��շ�[����~o��k۾�������~����?�����m�j�������0��j����<<2�=�d�T�i��z%��]R�M����h�:%��L4T�Ka�!ݦ>L4
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
Ov?���iٞ>����q]4<i;����^̖x�L�6��j/ʏ�o�����p�ƿx�p\}V���Q�u�~웆ƽ��ð�$��.�f�aU$*p��yk+�h���8OB���]�r��آ��'��1�����֓��b��ھ.����=���*<�_��λ��>�,�a�      �      x���Ys��&�L��x�Q�`�EoA1E�r��d�d6�*��,�I�[]��;�	<amc��O��ro
D _>��6gJ(��B���gR�TH�ɶ��*[c��9�8����˨\���y���?R����6Җ��y��}��w���~W<m���C�������V�m��|��-�������g2X�.��d�'eJ![+LN��=U9�]�k�BYe�[���V���r��P��*�I�eUIUe$�~��v*i���?[�û�/��~?����)e� uF���'S�o%eSY�%KOUk�Ƶ+јJ(�����o�������q�P��=ۻ-������WS����e�*!lN�|�X���'o��ҭ������L~�*<yg59H��j໕Ҋ*:���;��ʸ���$�jQ�%�ߞ�|�o���Uh[ܽ���j�=�F����VF���?�D�=��5�[��ۗ�p�f�m���n6��?���S�]���
	'��������D��Qת�a�J
�;�����͢�x3�5|���4��u�O�h?i�I���tuZ�,)V8,h��J�V�/�|�Z����mwW�����n�}��y|�K����������`�D���
��7���v�`ac����Ypk+���i��=�6�ɉ���*�ZƏ)+��V��:[N�u_|^^_��U��6�'�?���gŢ�*k]�"�$5�8|U;~U#��d�����s1��������c�?�����п�|-�x��x��}��p�6�c�O���i꜈���
g��$od���2��ɼ��Ӣ_���A�ܚ`��Y�a[�j�Aw���<ȩ(Ye�2�Ҍ�l��/�_t�ŧ��ֺ�.���M�*λU���}-.��3�A)�A�,�O�3����9c�c�ö��91��ALV����b:��a��D0>�|��&���Z0�xx�L�q�=RI=%%ڠ�B�*�p�Y�酟���(k!�h�"�Y��a1���
k��y��`�<�����;x/�CS�ǟ؄�p��ҨOB�J�*xWQ��T%y�!u����e�Z���.���ˏ��w8m���R|*��&þ'~R$� �恃Y5:'b��X�yX�0����K�u�wW��-�&�;��]A���xOѽ0M��
n��
�>����e]�:|S��W���7\�׫+����*>�ѹ���%��z����K-��xpo�ͮݻk?[*x�tV�lo��Z�~{gp�/'�K4�eq}�߂������WvM=l��G΢��q(�ߵm�qw>R�q��_=�uw���\�|����wm]�6'�\�H������һ���m��a;���7���b��UY�P�F�1�:�ZT9ỏ
o�������
�9ܼ̇5h��ZV�Uu򼇢ox��}X��?l��X�������i!�I,֓��f�L<�ן��)৸�P��I��d��P�j�#����p'A�ڎ'a�/&sw��->���Y�I��N˳(����`L%TU5UN�E=�Jz$�dF4�IX�L��+����G�����U1�̖��|�۶:m��h�I7�B7&'b,W��X.\��_t����v�]1p���}����f1�/�n��jkr������	A������p�)l��yx 6p�����z>����~�y�.�gX����o��Ŵ0.���ə6�,Uj��F�D|��p�����_�br����pG���������|������
���?�Ol>Y��ԁ�FQ��	�o|�「0�C�f�D��oY��_��ދ����^��޷��wg�C�0��� 3�Bax3[�U�D��*�%F�r���ע,�� ��������J�!1�U���ޯvn��5�G��^���q.(��05US=r*�%��f��v4�׊Z�7>�_�o��sr��'��w���/�O�%nvoŏ��?�Ŵ+��J��<U���y���6#����J�֡à�9�u�i�·+���'�Ӕ�U�N>y(:��C���Cv	"��{���N�Ѕ��σY�6?|�סc7�����-a����\V�����������u�R�ھ��|�}x���kA=�8�K@�-�1qx�IT�ܻ0F"��OO?,�ת߲Sǩ���D���p҆��nG����d��4Z&.'���UmS59�	�9TI_Ep�Tm��|��|��a���n�}"]d���d������r�m"���D����P��/hi��8l����X�5D�J�D���p[kZ+C���_��٬C�g�����6�����|�/���,�>�Sס��]L��؈F�&a����`,4۩0�C�]K	Q@�c�|޿=��E���n�1�g5���D��w�ܺ
3+�(��T%��S&Cv������K�<��cU࣯M����??�=|y�g�x����tp�t��F�*��M-ڜ(^9�2�\�x��p��*�๘oV�,��&��������m	��j3nS�FZn1h�t�u������:>`��,J�M�u~��*��B蜈{�#��i����!�~�{xW~����뿾l���s��@�뀇_c!b���q1P���
^ES��,t�������t.��A �kpmХ��HU��	*'J���$�F5��ی�;� x�,�1���WC��w�.-9��x5-�hڄOT*b��Jz[�Ճa7�ڰ�WX/q�~c�S203����D*Ip����b�_lf�j2c���_vx� ��Av^lI�.�%#�_��l*b�V�J�u���R�C������/̽�|q�Z4e��h�����bD�n�*��`�Fۇ��\���E9�>w��λ���qH���A���":Q�U�
������ԙ�@�&?AXC��I,��������KR�uWL!��g��z�Z��1?�[�f0�k��
��ʊ�n��j�M�ꢧ2�CrЯ9���V����C�׳A-�qU�H%�����x>Y�L�v�2����r��^��?:E`�DC�ђ�F*�D�E����z󹟎�c��m�s����<zé�w��JR�B㮝�����������ǻ��ʢ�$ۻma֮�3| ����y
�|SQZQ����`XS�J��&y
"���4O�m�P������ۄN��p٦b;�A,_�Zs#c&r��M| �є�����i���"��+�s�+��(���%n��4�����F]���{~~Q��b�r�-�z��V��-���O� P��AL��͉8W-RI}�Z��zw���-�W��C���	CY+)�*1e�T2�\�"��0���s0TЇ��K��-�'�ywӑ��k���1��C�&���=�����Yis�dũJ���]B����x�W�M��g~��/'��t����h~@c��V�Ъ�tNĥ"&���w�wj�莫�k�D��$K�}�t�1�) �hs"δF*\d���{ct�a?�n�����ɟNvѠ��OK]
S��OOE�2c�t� ����n������wJ�ݬ_,���P�$�lІ�ژ0�HE'�ѡJz}�_gx}fx[�pUV� �	�*\i�0��k��y6��a�~����ߊ��-�0ڒ�t�&�V`��ms"ETҝl���p'�˛e��v�:]��>���"XѨ��qa����.Qa��B��{�=��1�]�+<du�2��&܃Q��ҡg�H�i$�R�P3ގOw/;X~ޟ�6�x/���ۢgT��=m
�`݀�Y�D�F*	�M�Ti�y���b�J�_�|�1��K���߰>�����dU@X�93�0�_�Y@A]���a��q�o��Z�
Lj5`O��������GIA�tx�&wb����RW̚����
W�Ep�a�;�C8��|���ZC�8��O�)�J�D|j���[���ZPs�O�ƽ3mvQ� R@7p�UN�/�����f�ί�O�������e���nXE_E����!%�����D���@��_��b�Zt��v�.	V�tRU�wS�����W�D�OIT��߭
tn�ZZgR��l�#�֪�9�cD%MY����    \�Jϯ�� }�T����M���쀛��c�Ta�$�@]�*ɗU��Y��[{U�7W�E�����=8�?�Uu���~�*���q������ 	���c����9��"!�5�`�ڜ�_$Q�9��"ME�Y�����^ha"w�J8��j���+����\n���hu��-��j9_:���}NħE$��d!hn��js".��p>m+����v��媻��G����zsUL�U?��Ļ�u�0
��h	�~�+��psC���հ�~����k���V#�II���41:'�b�µ)\��k��;�gxTp�����xRe�{V��"ߗ��}i���)JE'�zB��a�Pv�Z��w� �	�p�|a�J��me�͉��QIv�J��P��*,|��V9�����Ty�TĹ��Jz�*��ߔi?���&�p*iVt_A�RU��:'�/1Qa@���7x����}�������*�uǽ�#��ca�鐴��`��E�E`�]	�&l�`D̋�0/"D���4�h�j�bj�����f�!*n�ґO�8c�p���h�_��͢;"|?�w�	f�סOV��5���HN�؎���5st�dآ�]\�	�JZ!���N\�P���fh�t�}Cs�18�������ߪF�l�Ŧ+�7�λ��
�e�5���lI��6L�g�s(TU��^5��UNĕ�#����-|V;@����`Yn+k>��h%1h�&p��F��D*��D%��CY���}���� |��or0Yik������a�;�"'��Ф���F��;V�Q�>`���'w���'��C��J�M�щ0&TI�E1�����Ϟ\l��FQ��Z��mG�v�m	L8qg2RIS����D�������>��٭ם�뚔�p�;�u%�F�D���${���"l��NV_�»��n����VZM�P�7h�	��
�dE�KATҝ�B}���4����h�����0�D�zed�c��ND�
I������_\tW��-�t	Yo.{0��bY���q�$���=,��I�l/�"��F*�%cϒ�C�dÍE��D�8C�h���8�J��l,�uX�&}�7��+���PF��v�ӣ�vaH���[��/t��W*�i36�%�u-E��3� 2���Z�$;+��Vd:��6@�K8[��zm+��"n���z`M��nMX�&N�+r��2%���dE\�g��:�5D�v 8r����B�!��R"Y��,#�]�Jz��!h>�;��f�q�O.�J/��d�ͯ��?X�.�H'8MU��Ή���p����@�b2+f�#A�������m�
R�,��!P�dVt���H=D&��n��<UL�k�
⪂{DE�:�--v�V!�$fh4�!bR����z�>�~���{d*�[]/Ҵ�׸�����6I�)���UR�C���^� X��K�Κ���Z��9of�
kf`Y603���Z���3uNĭ%Ra�Oyc�&:{$ϊE�3�5&�dNġ"��̈�y=�Q�o#������ϫ�*��ӂ=^G�ë�5��}�8���%XB�`]m�b�AW��n�gD*)�������l��<�!ڒ�^��+�^�F�01���UE*iW��v��	�I.���˪��|wo7?�g��� 2�~^!h$N�m0K�C3H���N���J�`ӗ ت�!�.+eó�e�O6�E��9w�#/�������[xM!z���6Y�x"����v��/Ҵ9�E*L�v�=��������#�������1x��ۿ�Ɛ��c��/�*#D��D<��������~>Y���YR!ő$�-�S���ʉ8b�H��$]��Ѐq1����)k��:�0ܤ�Csň�X����.�����fl��H�s�I��*+p���I#"�I#*�&+s|^��7�����(��mB>Rwo"������������n�Y�q���֪"�{ <-!;f=���6i @��H����c�h�Lڠ�}:t�-�I`�o%�_���2Qa����f��n�}�ˁ	.�[��X��b$f����T� ��&'�e���O�PcK" �m_���|y{/�`G?���_������g9�!��YҸ�j�$U�\�gv�|�s�Q�0�C��4j���p��@�}������?�|  �%|U�-z�����!"#:�z�0e[p(�����@��<����_���M���X��](�ʶ2�ӛH8r/�����7��/�Wd@W��byoeY�5�WNE�+BT���`g��٢�U������sIO]���3�WM�����
��VWÝ�c3��mZ�z���ޑ7I�� �����ݔ�Ǳ�1�Q!=�p�`/u�sg
����
���D�
O7ܚ�;��Ʊ��ˬTNĿRD��I�}5�E�����7���\��l*����KBT�[2m��W��4d=�\��Quh�R�a��P㣎F�"��
I��e�MF�c�C.��wH%�o��~g*Z4N��%�_�ڴ&i"E'��C�����9i"� ۏo_�
�׏��w�����j�������^����>'l�Е��ځ�6	���屈�qc���׺�|�����1��
��H#�t�Q�k�Eӄ՜T��#���10P��&�6C���eq��?��Vg�Xq��+h%�uME��$*L}Q"*�)\}��X��X�J+B�J��҅�l��9�	��P%ͬ�U<p��7kG��2+&Lk�*�u\���:+�"�J�*�k�>\��bdiƕY���!�e��a#�@$�C@��@���
7ݼ�$y����<S^1����˫���q(�8���U������H%��pQ�.�|�鮾�/��q�����0M���y���+|��7���h�p	�81M��c�{�L{`����(a?���'��E�,�,V���O0�?]%���xuk�6+�X�:#�5��A�jp�ň�Wg��^v��ߞ_J�?��A/�"|VA��[����O�����VQ ���w�GG�/����2I���ܧp���D�E�·Z�!.	wB�"�x�<��Hc;����w�eQZǓuZ���)�D
r���^�v/p"�>������'	ܴ���8�
KPm	OHmTN�G8D�M��ژ�M���������$���HJEk�M܂�6m��KE\�5RI�#4x?)i��W_�'�Ѻ��}N�F/�m�V�9�lF*i!X@�Z���t�'�'���O�b�#G��m��D�K�u"��nڭ�FTFv��g��a]ё
B�Z�D���$�����u�	}������r�v��i��Y:|Ss���.��%�	"5�h3Uؖ Q���I��/��e$���X_�&��^T㗓��6~#a��r/�nW�oX��g/Ϗ��sq����wx�G�����C ���4���&�C*��*�.��x|(Q�M�,�xd�969�C��
}_���k-aڜ�:!T��	�P~\#nz`���H���JI�KE'Z�C�!��d�W�o���	��ii�"L�9|Ү�����JE\�"RI�maP=x��w)hc��	F�|a=�jDl���Ĉ�����_{N��v3�?�	��e�����dBV(�M8Q�\H�����/��*�����/����iG��u#�8N#"~ۈ
�m`㇎����a�
ܺ���=\X�Ǌ�E�*'��]���~R\XB?��7����֭��k����VOa�a�^����@Ň*��S���t��L-�� )��&'�)C�
׈���YpU�~:r����Q��߄cW�9щ���7�>��r�umr'��+>�q��{v��B�ms"�ў�pElD����_t�.�S\w� ��$�s������q�L��.����|�u�������ۢ��+q+�">H&*\[x�Gڻ婛Le�4±�W-��x�=Q���H�����f:T�����:� H��]���]+���z�X4�J�:'�U��z�`n�9����	�ǝ�!K��    s*�u:0�M[�D<w Qa��dcƤx���/EB����1��CԪFW:'�1��>c�\Л%D�~�{���B�p��6,U�"�ETX�����u����T����/�,6u�R5X�̉x�FT҇�rCl����[l>�N.�=�[O���V��Y�ź&����Ս�q�����'QI�����eX������*D�!`1�@�4<<R+��	��P��@?��q�����.�6�P�{���`�t��I�B�	��P�gz�h�lh���5-����C�����4#�" ��Z;
���o�^v[Oӫ�̥U�2	����(���,4���%��mw��̜%A�=�_aK�=���ѥZ��(��	ac����L�v��m�/\���C�o[�,�q�Xj]��&"�&*���2�7^n7�X�y�c�!�
1����kD���D%=a�ZS�9:�7� T�{�D�
�T�>�
B�/('���Ց�x��ђ��LJQ	�d#���n�*,�	�>[^�s��,��9���J�=,�b_n�q�|���/����|a��a� #W��Z��O1��&�0�8o�(4ᡬ��uN�ǯD�˛ 7�	�C���v�P�VQ`��萨�ѡ��a�8ǃׄ/���H�jIM#����R��f�|���,~<�=?�Nn�!*�	���Y�6)�҈3Dt��*I����DM7�3�E������k��λ��n��z�m�m��I(��V��	�[�&H%LK^����8�B�ch{խ����j9�������M8r�▧p��gIU	\.��ą*Lq˱I��1K����6���t�{��,mۄ�ˈ�Ǎ�phy�Ͱ��f5ﻛ2�H>����$%f3ԥ�ҲA6E��ԥD��6�y-���ƞ�m����.X3Qt�ᰕ�h��49�G*�3�P��e����� ��/�'�:�?0"�D|���0�!!49�旮��y���=����Q ����]�)<��Me�dn�mVĳc��}G&��nD�O�_�l��xy���}Yl^�_#��ݯ��)�nZڶ���b�9�	�n���Ї��ݪ���� �*�Y�q�t��k�Z13v�FZc��� �
U�����o���F�A������;��r����QD��cKT�ck*yT��j�u2��iA@A�G�pm2 Dec+k��� �
� ��{x�曛��nwC�I>e��U���
c#F��H%����f� ��װ�ôU$cr ��~w��]Pjʺn�X*⼕H� �_?ԕ��^p<����C�x��LYV�T+D}�DeFėe�
_��.0a2Vf��j\>�Q�d���O$*l>��፺DxCq�!3�!���+��BZ"$ܪZ%3���#"*\T�B�x�ْ&l�M�
O1�G�؜(�<��p{�l5:���n��!�M��4���`���x�0�U�2.)���x
�n�0L���	Q����	�*���".
�T�R	�Հz>�Z�~����H� �"XL��;��-f����d��Q%ͻ��󐀣���d��(���v��b�W�u��Dģ�
����]���Xw���XM���c9Q� ����tPfY�)V�͉8K�pI��Фj�DцLb)�&&[����ػ!"ޅ!*颐gS����e��zz��E�Gq��s���O���2���6�f@ށ��X8޶
�O��aLĘ�����M�@J��J��r"�M�U�7��#@a�O�62̐%�F���Hi�+���5F*��I-b��\���}J&Z�4c2�����u����O3٨%᜚���0~�C�|Ӎg�1	ɱ�XV���I�"��R�*ܱ����ǟ�R={�]&�Hkܵ�J� a꜈��F*QVs`h����b�:Ԟt��k�vk�Eۨ��_Qa��0lp<���_��~��k,��`�c���n��eE|����)2���嬿�$Y�R�53��gZU-e؍E|W&Q��f8��f��o/�b�ݽn��`26;�.{
}U֦����@r��&�`J�pK*C�1�ȷڮ����K4@�~�.�U�����m5��nNF[V�lLFr�m+�`��5#��,ƃI�t)��mr"�Y$*�B�F_��u�������*9�����s�NV��Y��*E���ΉNd�B�tݘ1��8eV:���Y�����z�Z8V[���c��uc�Zc	1�_������c,�ȶA���K�4��2qz��n[k��������ӻ���=�?�w�o��`�{��N�aJ�4�@��js���J�� 0�и�^�P��˨B� }�ݴm��p����Ǎg|^^sت����r����e�����S��=�>Ac"(��	�S�46|�ňT(�<���\����@���	=�'ڲ��gF�/��p�n�9h6áu�!��G�.�6u[�D|+3QI1�sCh}��v,�W�BȂBfcS�&'�l��]Y�G�o����s�u	��
�,�g��PS�����ɉ�-#*i?�E>{�dr�c铯\����q���)y��貱�xEׇ���+�*d���t��mL��1���P�O6C:pݯ�M<L��)ÈY��r���e�l�\V��H%���}l�..��l�9��;��?�.��(��q�r�KV+��D<��p�KmZpGVa�L*��O�5�Q��6S��8k����8F��mȤ�p5~d,�` ��saDL������O0^��Q3PXpgu�taD̑�U�H�y�H����6r`X@�&b�i@3PS�
�*n��Aĥ#�?9���]����e�|\44��H'��a4mV����k�DN���q˟j��mv�_��?�}ֵ�$̴eqK-1��q�5R�6�2C�~X�,��A�P��-�,�����b"��OWB��Q��O���0�����?�]=�J�d�a����T�K��zX�P+��J���Wض���7�*äEIxR_o'*,Y�n�D¬+�u�+�;��8�u����Lo��ff
�'r�Z��Ħ�8Ta;%1��֟�|�dl�\w�E�ysݯ�!H�Ї��=� �YI�UdD���p��c#����#b�ab	/ ���Fb�Tt"��![�w��X[
���Gh�0?^��/���T�G,��pI��I����G�fǁ)�����'�;Jٞ>�HY!![��&^��'Q��h+�N�������䫨�gC����\���M������I�ZK��G���L��]�O�yj���X���wX5�_����C�搒��P
A�'��k�Mn��D	|��H��z���fn���<?<߶��y/�z,���b[~m�����n��y�y��70��\�������8�He\�9.ݿq���學{�W�o����~�`���ewf�i�3F���{��<Dt���P,s�yr\�W�Uzz�V�2��%|�_��A�$�����b1 2��E_̻�nyq1L
��i�T�������^%��_���&���]����OE����RU��6]�n����d�_N��m�a��r���p.\��f�¢�T gv�Ĉ����#�݊�F3UH�vplŵ�Ǧ���ZI�������������������1���wIxzȲ�HͅeB#DP�aD�_���	|,jup.�U�"t����ëq�mNħ��
Sp��4�d2�V�o87��>�����C�ެC���w�$&=���i��E'4F'�>"�{D�#B�bd>���Wװ9���g㰨�߱q|��^��q^��G'i&�n�Q�~���&�D".����n� @:�K��9���:��],}�r�ipp��77n��<�ȼb�I��V*6�Dt��=Ta0�p����a��O�����a5?��ʉ���$��F � �|/�v۲8�s�}�v?��?���x.	yq:^�\S
Y�d`����#��*�H������Ύ3a�09��8-�I�s"    �F*�q����������d6��=1XH��T����1���N�ʡ����\'`���q��Ƚ����������p��۽������R�7�{�¤@N�5sG*��q �2���|S�v���ς�J�SDV�W����A1~����hZ�6-��D��J����_꘴ř.��A��0SVڐ5�J]��'u	?��ASW��T�̈u}�ރ��d���87�+Q>W"���;�j=�Z�������8'RIW��N��vpxM��(�J��� �ֶm��MD<���0Hb"�P��)�k�ƺ$V�w)�6���l�tx:qe�H%u7:x(��>��l��Gϑ8�ſ��l�r�Y���nr�� ��*'� ��JZ�C��-۷K��/Ft�
�⑼�r��	k8����I��P�̔=t�v���Ӑb
��n�q]m��L]�D'�5C�x}ȫ)���㶃8�:��k|Z����5��6�ňN���*|�k-#������R\_ch4���q�>!LE����	�vϊc��ռ��	���[]t~�*�@e�LdE��
�@�r��/����|'�L��͉x "QaȻ$�X�q��m7���9_�>b2�)S!?�F��&��_� *l��Zshpԫb2�߮;$M�/^H�웉��)C5,�H��&�\*ⓀD�M"�g���a-)4#�S[�!���aD|����ݘZ�V5�a:�A��My� ���[2+ʗK؊0DP�.�{ME<^��$	��9����m�ݿl��zt���;p��~#�4�Ko[����_�8c�q�s�}�<9��	�pA*t�r��,�G�O�j��c���0i��.�9F�g��(;C���*��11��D�e�4B�x�����y �t�|E�-����eM�?�YS8�{�Z�a�g&5�y��Z���w������+qU��)���VЪf*��H%�l́ xWݗ��>��2�dCh�C��[��XEk���#*I�i��p�����?�3������F����e�F(J�#S�xq�ь�5nq�����z�G]l>��kq�#��1�(�q��F�o#� e�J
B���"��@
���7WW�	yaw�"�ab���~}3N�Ud8�5��K�{'j09g#�����(38iK����_�G�
FD�ӫ����!3uN�Cu�J�*�R��3[o�~��ﮖ�y�'�g�F���`�)2l�뜈[^��!��&����b��5� m���v���g���hL��#���T����$c�t��{�z��/�?���X`\W�3�k�A��V�U���"��%*̺�k0v�&}>R$6s��W*�{��h��c뜈/nn����M�Xw�r�>5��R7�c����F�ED��KTRO�r� 啋��s� �}UL7�~1Y�:�;N��\k����a2"������g���d�r�����ԙ��ן����������c�hkP�3�ۆ�$s�Sщ��P���V�B��8��hLF���ou��"����p����0�:(�
���CP4V�$$��d3�Q�E���K��1��\9KP�1ϥ�[������dm࿪��{BT�����aSC�M,��O��.�x(�uN�-2R�*cJ7C��uq�G����}@�3p��{>��5
ʚ�2Յ-xG�A�ܡH���2�X�F:y���h3�xޖ���ɉN��C�o�>,F*�kr0��L�H3hTN����
�� WH
���X�ٌF����a&���A��袩���9w#���e���8D�;�:ۗ�)����m��+xm�݃����eϞR�����K���"��`���JF�T�7!�)��	�#��{|�[6��20W��[$o���lm
E'�K�
������UX#�̮�LY
�v$'�w����f��y���v0I��^%#9[��B��;C	�jpH$x���5��=�,���7�8Nf ��#�b�"�c{����`����ǃ��G4�u�fu���[%LNt��p�8�L���
�!8�
���e�� `�E@8:��5�`4�y#i�Q,�j �
�`�$5�!�oZK�퓎eN�p�Z��R�k"*\�$^�K<�`��1�m��70�o[���w��b�}xs��a��_�(��&!�"���P�-��1Ծ�J�L�Ւd M�
�!`ÃijQ�D'R�J�<������c�/۟�{7\�tn�������H���H��_�v/�|�����aEN�����hÜ+�HF�&�
�T�4�D�'��
�H֣�!Sl:I*��`20�χ%Π�6'��7�J��=5M�{�����E��������>��lEn�J�6��x���pMGZ���9�!tف��"iٓm80!�cy�A�=r1��Sщ��P����`��ˌ&��*7�H!��[�mms"��T��'~�c��Œ�y�^��ⲃsp�Wj�+���a�̉��v� :
��e����R	�=F�c�B��8��U%s".S�p�rח~`z�_��l��}֪8v��� ���� ��{ǒ���P[5a���)s���`Xt{���X_-���#�g�$B#�gk���^'�n'Q��$,֏��G�t?Z��B�G��ٹ(CL,�r0�
W�oD3d����X���� r@{&���&���ѥi�yM$[#�Hc�V���E�F4	-1���6#�>)�HW��FV"نxS�xk�����"�Ē�0���"XM�F����j�]�}�!�l*⁄D%��n�� @��}���|wA�,���"HH'�^ ���qqmK��X�'!�
wZ���㢛 4����5<���ly��8ئ���CK<��o��*�ڐ"]*��Y�
��I�u̻��jp��'瓩v����h���`jި��9_#*L�N�����Ƶ��\��/��_v3Ǧu�S/�?���uye�ԶʊN��*�B	���;����${��3&���T8�5f$�8�`T���#m�r~=�Lׅ�c��˅�����D�:a��hA�S��TRWWa�V�9]�A���:���(נ3��:j��I#��n�����e;>���;K��bc,�.��Y�ﻉH�M�Esf�/bk�ʉ��/R�i`t̡gv��������5>ݒ�gc3��4�F+#� ����� ����"����N�8�������Wpy�%���������	�dr����&6':���p,�>�_�[���דc��co�k+�� ��qb��N6%U����90ɠ�	��p�Q��'�$ѡב�xB`���N��f䄽W���b-�P������۷b��Rm1�������y~�>���BOo��I�psTp<'r��D'��B��@�*h��c��w6����a��7������#r�]��������e�T�x��/�9��7�M3·���"޳��55V�2! qNb��fh+7��ʫ6�e��}0l�7[�D'0;�
���Pw��:�_}��{���(I7���4��
�K�r"�.���p��߈�����ݴ��=`#�)m����.!�Q�T�H�6"�67q�@��[llU��O� Z!"�4!�\*�� D��h��u I�U&=���EӨ�[/����4"��&���3�LeM����&��f(���Vi�E�ێ؋]VI��ڕ�q�59�DT��*��t�D�|e$����&ԓ�uZ�h�h`$:�����l�N>`���{�7���}t���|���ǁ'�l[UmN�<��J����A�����z�&ջ�N�3����j�B2B���/+��Wh�=A>o����db���Pv�_�,L��&���rҶ2�~CCv?���?�U�Gwu;r�V��1et�y��6lbD<�#Qa���T��V�S�Gn"�[��+8�mN�89�J�M��aX͗~����f�*�.Ik�M,z��G��?�Xh�C..F���	q��16䙟��}��+�z�����EK V    ��g�JK['��Pt���0���r���V�s�>I�$�}�|�*�w� �)x�mk��N�!C�d�5X�q"��d���u�<3����3�j�'оH��aU�`7dkr�p�P%i�D��H�:Á�7�j_�A�+�GYbW�&��6�Z��19щ�P�C�
ly^�ټ�/��.�ы�4�}��_�M*��H%�8,m����#7ݬ�>w+$7�[�0j�%׭��;�xO��0�rG�CVe���OV���-7���p\NBa�Y��{�4UFP�� ��G���W���S�'=�D�\�HU#.\�/ԔX
��".��p�+�ցS{��A����4ƻ��G�c���1�x�+Q�51���r֍մ����'�"L�2��$��N��Bny8�o,T�Dvc�os����4��L�������6+���H���b�P����/����/]�dȊ v�1z	��%!����T#]9�M�q��n]�zxSF����d�Y��M�$X�h�}���ʒ�� j=d����j�V]���۷����������'��MH���h��eU�9���T��t���k45E�8�9��ejU7�ʉ�K�pX���`�o���UU����V���.�ر�u#␔�����$m�8���p?~��N.���|�o���{�����;F(�$�0��0p���T�E�J��0�U������\,q��9���!�!�t�x�ں �ڨ:'�<�H%u��u�C���E�{ଣ�U�χ�Y�-r��&+:A���Y�=���1{�������6������\`�!��]LY��h��"���^T9��BT��� �*�8N!�w�����k�����gi� ơ��Y���!�����8I༼�l�bR��' �} �90�d]\��i����ɿ̈́*��0������:IQщ�x����ڱ�������ϟ/����mxP�ɩ���7�DH��8�I���떒chk[�ј�<2����X���q;�pm=JZ�_���:��q9υBT�7����N���ɼ� �_��x�n\�[��-<5����4�K�qw?R�Zx���q.��N�q��F�*���"�/9R�n���P�r�Q�X��Yί���&��B�:��W��*C:�(f�*i0W!�W��u��s3z}��!~��o�1-5�&�H�=,��6�����D�K�[x�	Y���zy�v=�{��/�N��t���X,x���'a��m��%��-�ruN� sb�����x�|3����7-W�^��j���էf�(0�3������|���!����y?��=nދ��'��ja�L���Q�d3-s">�"*L)��H'��\LVWݢG@	Ea��YQ�ͨK��('�^�H%���k��.U����9૳�Vgi̬�>����?'���H��>��n_�ٽm�(=�l����p�aQ��x��A�\�>OʙJ]V�X�q�S��=O8
o�.�_t3�<���).W�u��%:���K�a�t�`��:'���0��x��7}`��=�:l�H��5�`J���D���p��ŉCvv��V<ā��z�*��&�a�����ā�6�S�<!*LQ�X��?-!ӈ�IZ��ʆ41�"� *�F��!����)�R�f���)5�����O]�qf>R�^ %�!��z�t�w y��կ����)1V��ei ̍򸑈G��~$���6d���N��3J��ZUU0���J��V(�RG2&:��aB��C��D�:�����}�?b~Y�5�oWC�v�\-!�Q��\�t�U������j��HN�Cn�
���j>��.7�qcHJ��F	.y��ֵl���d������0�,�L$��	ŋ��%\`)\��rQ�ϝ��*��"�Q����&��ƈx�T��V�`���;�^�)?ZW�,�#�m�u:�¸I��l��M��AQI��]j1����Ay�!�c1?P�njzCQ�~7U!�xZ*':�	����Y��u?�/���eV�s��
�pUUMNt�z*T�̥#l�� �!3�9K �-b�붵�͉N�oC�����#��#�G:Jl�%uXր�ʒr��̶�u!�#�	s��`k19�4:��톑,q�mp)�V���d��Q%]+m�,��fR�v@:�h���tNĽ��JZ�ư��t2[ C_E�ZF1Q�"�ZS�F*i3�:�!������Aʓ���p�\�@\\�`l��9���	0�<�T�_Z��^Z�!��+]�6�'�"�G"��4�ʉ8��H��dA���g5���]�7<~+���aG�XtRl��h�Dt��(T�m�nR��'����"Y���e�>yx~ۖ�����o22��ޘA�v ��͉���u7��J1���p_<�C�������k��v`���vԣHH� ��ϡHw�~�l��1���'��_ۗ�����������==�?�b]�y��!�v��I*⚞#��M.#�M�'�Z~��̎��1��\��%H-A���e�`��9�ŃR���j�T�&s�S�1?��Ǌ��C�C4YKS�7�[JQW��$��.�����?4�աr���ϓ�~,��0^��>Sd"�	l��A#(��W$�LFX�%��19�?�pM%ҴJ���[p؎�������翋���S�ML�߹{e[ٶis">�'*l�[��ThW��b3�g3�yw�"��r��4�W*U���=���D�fD�����Z�M��zX���X����3�!ďa8K��ƅzz�_9'���H%}�.0��,�0O���ݰ��=��CFT�ldN��J��[��<KC�=�̻�#���s���cS�ڶa^*��GT������?_u��Y_��\]x�1�T9��X%1K�hD5��_��x�>�~���/��CS�ّ����2��j �^=RjNE<�Qa���#�Q��f�MMn�=�RWᩂ�Aɜ�s#�������u^n�v��-��������Zꐅ�q�H�����d	����H��jt$#�_�k7�`~�O�9�o$*�E��������P_a�^u�?h�!ْ妰j�M^��dr"����p(7%��i�[ǖZ��)���߻�C�h��U��S����\59�!*\�N���|0�uX�M��4��u�qU�IE��GTj.��VЙ��p���}v��3S��+�QY	8P���a�����ꪟz<=7�M9�i�ݬ�G�fZ׸֖��!�KD\�L��h�V�����MK��t~��m�8�5a���O���tX�I�������Q�r����t�
���/����U�N���b�Y��\2�x�Ч�dǱf��z~����D*ɦh���e�YH���	PB#��N��
��us/��%�X"��D�-��?���nV�1�<_.�K��iU��o�UG���R:�:T��b���D\�/RIW�\�6�5j��ɷn�F*�,E,�o �@�بFeE\"RI��Z�CO��K��}�me)�bܧ����-ꌄo�
5R/^-���\��U� ��2�D���3�k�HR��D*�B�_rn��ͪo�N8�A�dՈ�����8͉�g'RIqb>�=�wj�w����`֒�L�C�ģ�$[bt&�
�ބ��m��`&
��ë2�4jp����?Nd[ iJI��\0�]z$\��l49�2%*�vi�k2�w���~W��IC�����P���]�t��t�pg�WK�!qq�N֟�,�P�͉�s�p���
��.;pzV��0�U��2	aU	?�y�RF"*,	|�a����`Nf3x�4�v�Y��J��uH ;�c�UNt"�����?7CEvѭ�R;�$�T% 	����QY7���cr"�@TR��Ur�#��r�nR�h�h����ɪ�ĀL�sMM�T�`���ߛ��K�D*IL�¨f(M�.D������;��|�# ��q�͸��Ud|]*��    �$�� h�@8�]�$�E�c9��l�
�Q���`�j�Iڜ��D*J}�!��5<o�?��[2�8蜋2�҆���J�FD��Z���͉�%��Tz0[4"?1�}zƿ>�>�={F��p_�=/~���m��uVU��ƝU���-����>�Xu��vV:�FNm���z�<�r�S!+���U�_�����["�����D�ס�
_�n�����w�d�K0��m�VB�DL�&Va0�; ��o������y�u��sU�F�:�򓪱��O�jr"�Y�T^�dL���!0-���ě����ܘwՠ�lm�á����w���G�8ހ�qʄ�>��g_�5aW*#��}�¾��}�c�������ZeHڏĠ��b�;�D�D�xZ����2���x	l�ք{+j�v x"LS�Z�D0R�z���(���sc�u���a=������@j�xRK_�&*�e�pUG �8�i�Ǯ��n��bd��ē�	DH.�B#��2���!A>#:A��p�.7W_������n�nN�"ҹF�Wh��2'�-#Qခ����?�/���~�����~B]�ݱ6<�6"5�.k�hmV�w=�}O����~�h�i�$춰�u�(l��q��
�$�@D|f��06ZU#�.�ع�oz�;i��.Ϗ�7��RdF*��H%Y^��GC�긼��l9.rV.�/>_-?;"AEϨfZ8������!*�Z��:r��[y5Ym��°2^�ŴR���6uN�-/RI������i\���p	����P.3��n++t���N4��*i&/J���nV�7�^�y̐O��O��m)��	�GSQ��T%]r׊dZ�.o�����	�r���<��FE���sl#���g�t䮿uW������t���uC����ԝ��6��Y�i��0́�M��<�'��0R�e$' ����m�j�>O���WYM�c9�Rɉ/�`C�Vsl��Z������0Q#�M�"��p^� _(˛�N�1B,"Z�c����dV3�>c.����q��;��a��F�q�"�]�D%��M�z���v���H�J2��S�})h�ɫ���S��s;�����e�\M�̦�v7���O��%�'��6:#9��@�_�<���Y?���A(�����k-w��%�jg��ڜ�qb�}	.��2a��o'W��f����(�kĜ�k�'�YS�F�®�Xu�Gc��]��ݤ}�.g�E@�Ή�X9R����Ǳb١K�q�Џ���ܔ�����9�	p_��*�~њl��ҀekU��eD�a&*����F��1iu�9�*�0��w��
[�Ր��0��	���T9L�,ۦ1�� q%�H��
�2��b���z*��n#���Y�F��S����i��ʉN��Bv�m5����X�b*^��p����Wlid8ʒ���D��/�Z7�kR��5KVc]q�.����*+� �J�+qZ�8��ɝE�ﵵ�BL_*⻙�
��,���c7����#��ae� �`�L Y�$aR*��H�	h�,�ʪ!&�9�᷌�.�h�RZ݆t����-��V�jUF���	n�b44�4�
�mq���;f0���og�:D��g��s�8G��u�4LE|>��$|uX"�d��D ��'.n(�l���
�h	6�E[�ٶQ�HD��ET8l0�jcǺCN'�la��7����bz�I������P�3��:&��e�S'u�Pt����uL��|.���`�q�8��$��/��A�+eF���D#u��\6C;ߗ12]ʏjhs�
S;��5�BP*�*(�
���"���fYt��|��&��-6X
�2ۆ$ѩ�ٹX%-����#�p=C��I���vӁ��l�ĦDt��p��-<mf����o�ס��۩	��i�ASV�5�+��D\�<RI
�v|����gp�_�@^Q�	��HW���5q*��F��n%��K-�	Ęd�sǹ�6���щ�<T�s3���M��̎U:sM%�㦅V�D'�i��]S�LJ�!\q��S�Ƀ���kJ�cdN�;	D�k5�gC��8����p}�Ը
A�a3��h^���˜�d���7�c��G}�Oo����|�>Cç)�#�W! �A�5ULD�C��{ڂ嫏�޺?� ��9p.s���%���iUn�7��*#9qV��JzTP���c���A�H9��Q�%�U*:QDU�q���d��8#�k_ i�����6���m�±J��	x�´�3��7y3��Z�}�|:�	X�y��4�K��kLYQjiB�Ĉ�u��e� ⶇN㫯��%�|)��_.��M�BtV��0d*�.T��^(D������.��=ɽ~d��U���(��
�X�!jw+gd]bϝ
[]a�g&�;�U�!!���o5YQܒ�7�,U#M�q�B�´$A8�Г<�^����\�L8��bq0��j+�����	�+�~H#r��e�I�G�8�؃��c���/��d
���%]�b��8�=�D��E���[>�G���m���e�g�Mw���e[�{��D\���/���6�-|XQ��c�;Y;\e]%\��3��
Grg���5��,��ɷ��Ɏ�����b��߅S��>��4uN�w����M܃��$����ܝ��!\�\�x8@$�y��
[�ɡhO�b8�3L�O�Y7�u���dV�����(���Un�Ji9�-�+x�C1a�������iv9���)ۚ�`I$\5�j0�rH8��8y�p ���S+�+ѯ�0B��"�ŸPr"hp�q�\���C�]|t� Cۍ�VVDC��ZA��R��JT�e�n̴�P9����� �v͘�$ͨp�##��H�i�A���>V78g7�Ώ�w��6`u�:F��.U��h�´����p�j�>t��p�.�D�>����nuN��(#���i����r٬p�C��-��҄ܗ�d0�o#+��	�<���kY��t�3�����ދ�]������)�H3<����璕��O:ԪƜ��6'b��J��-D�f�ͯ.��In��i�-�Z��R	O�j�����T�U7�a�`�o7��oEw=���Jg2{�47�L�jx�mN�9�
�ك'�H�x����q����.�Q���R5�����\U��}MN���"�����5�gu�ͻ���C��c��*���p�O�䱢�9�	`o���<*0��Iԍ�Գ���3�ҖZW�J ��."T���-�:X�q�Z���n�*'��D��R��ݥ�A�	ER��A�nDn��5#�Z��4-�p���A��i��B�4_����9��wWB��C������/W�K��z���k���"Go�o]mG�:l{LE�M����`blNv%�л�ׂO�M��j�V��D���ԎdV�=�G,.��f1�H|���j���ƌ����$�}R!�HE<H���(I�D��>��
b���r��tW�͉��Qa�CXz����x�)�_���q)p�s�Z
Q\�M�d���p��!&�itH�c;ȗ��jH�b���g�L���b��E/�E���D��`�J�øV��}q���F7F�y��l��8+�3�D�	�Vil��q��y�WĩmN�?�D�)�!h�Sz{(V��z���}>�ݽ?g24I2��̍��1MN�%�".��Ȟ4����Z�7ż�9!C ���0�z�!�Z*:A��$@dw�`��I�n�hԯ�7��fs�)��ϓY�Å�U���c�c֝5ZI�4[`��^��Q�I�<�H���$F�l봟��b�]#��5���H�|�[��إR�Mn�FU1
��xo���(Tv���̀�Ej��fэ��2�
W͵�TB�9/G*\��I��ty��M�qM��b9�Lo�b69��X��t,p$eOv� ���lU�q�u��n��:q��aP���_w�l�e�\���G��K�Q��GD��OT�ۆ_1�Ya��b�D���b�9�܄r����c='�U�G"��    !*��c�N�p��l�k���yVEeUNĻiD��<�r슜of}�p�� ����4��Ap�ME��T�]�H�)�W�����z�(���+�&�D�3�pF�t4]B�mÌ����J|�\~I�[�	X�Uw3Zw�7�w7�a�����j����Dr48������O�����kT0d�Oa�5�x狂+�TmN�#�
��v�����*$y�{u4�6g�$��t[*klS_O}IT8���<.�~1Nu?��KZl�W�&� )ƨv$�m_fD'0F�
�1��we3��G��Ԛ�a��6�>R[7�dE|����҈H6�M�E�����T�����̜q�I��:4���aI�`��X�����.'��]�wO����5W_�Xt�t�4:z�#�
S_��0{�3X��͉�"	M��KXb�%|R�KE'��B��"�8P��o�u����6��j3���%E2�!5�\a�px)#b�f��R��a; ����8��tY���%��[+�M�cTFWF�D'���
���C���j�s}u�c+�K%SE�u 1r��F�D\�)RI��d��S�M�:����?A.P�h%�)0��p���Ӑ�g����������0d=~/p"H�E'���
K�c䐤�ַ��ql��IV.��Ou��᫩���
��1w����L	���Y�!r&a�n��A��j���{�"�4���C��[�����X�3��5�n$�Vd��$*�1��y�P%ݺ�#C�����	�E�����;76�r���f�H%ݹ
�тp�~����*�i7�ϗӥK�XK�g��C��sG��aD�?|D�)��6*slE�й��8�*k���8�:Raj�j�R�˴��x�a��3���䚄z���T#M�#9�T��W��1=�FcɨB��ɉ��y����lN��;�B�1�[�*AL�g��6���!�o*��ב
Ӵ���`���	 �Nx����i-�O�fݚ��Z2�&fh�4.�x�w��-~�<��^���'���-!�5|l�>�![��S�(��xמ�$,~`�_�ü����?��������b�����������i�s�="wD�&�L��q�~m�L��d��PAm���M�i�h��,4Vg#]Y����i�"����0��)d��M
k&e��A��k���#����7���o��fG��v���fV���}�	H ^q����bQa�|���D�&�3}��7�IY\,��T��	r9�f���-� �J##�5E*I��.G���n����>�0S��L�'+�?��-;�\��V��?O�ҍ�����C�+�x�Jg�O(�RFR"���,�0���?{=�B��`�۫��<�fE���{o�ʴq8��&z&��3� 8�R@�[]�~�p�M	�߹2,���}��4�ķ]�ǥ(	s���sZ����/B���B+Z\�F^6���ZIvFn���%/"���Ѥ�4�Ǘ#D=�ba�мG�\i�_f₀�%��Ҷo��k�G�T?><>?~~�;���6o�r��.@�Pӹd�(��.U�AF¨�����~��fN��W�tޯOկU�g�-��5�
�֦����)6}gZ6:*0&���.\��7��a(d���t���U��VM��;�
�@-���{���+[�J�٭����!�0�8�/�����d&~aą]��=��,{���bag�`����ì�J&�`J\؂�5���C��#.,�������kQR���뒉��'.�u�C!k�ʗ�yy93�K� B}�^}?>��H�	�������l,�P���DlP�G$���ĭ=q�9B�����x�(�{�o��������N��U�6���cmM��#4�ݝY��#'�iBH!va�Z���]�D��>��u$��^���u:�B�i7���B��&r��%_a'Z=
� �	�z�8*���$�[m�:C���ڂ�������;��=<��P�a�څ�O�B�Q������)�h]4��'qa�O=�k��^o`o���岿��kĈ��Qh0����4��ȒiB�2v��Ju��/{,����O�?����C?Pta��9����it���L'��jH�Vn���!=�8��Y�+�C6�u�b�D�y�q��f���6�����E��W��	�tOL�J\8l����-��nf��,�ܿ�̖	@ܽ��h�d}�e�A�I�-rO�'.,E�)V���M���s�FP�E��Q�I��v�FsC&���HL��؅��� \w�|B��%�*�H]�Wl�	mukK&��E\�G
[
�h��s�P�=V~n�.��P3���t�4�v�]x��>y�0J=��驣�
3�/~��hg��y�%�S��S��D$�h�;]�מ�5ѣjkZJ�{�U@ekm,N��&>�؅��	)���?-N�e�L�g.�*$d�]<��1q�p�K�"���Qڻ���=�0�nw	��eHsQq����͍ai�.���i.vɛ.�4�_��k7�c�α��.��H�	?#�k���Ǥ���,+��?>��0�s�V�x�|:��m��!X�c� ��o���5����c��~yѯ�~rM���`	.�����9���x����N�����B�v ۦ���<f4%v�%�}jՕLܖM\�-+��O��j��|Rv,�ݐ9U�111;6u�vl�L��ʐ߯VҤ�ro�8٥��ږL��qḷ�9��z���l;�Ӯ3��"����Aٱ�wn���+�p�?w1٪��:������_���t�g'�&��M�&0&>�!.̳é�A����j����5�B�9�NG1�.��|��c�;��%�5���X�S���6CN���\����=".�9��`�����&��v����e{ۯ/J��	E�k�
��Z�v�h��f�]��*`O雃��9�M��Ka�����4���.��|*qa`�5�@���~G�Su#�]�Տ?���@hf�z��pl��_6+�Ǧ�}��5��7�/��ث_~�����__�\�>^� �u��T����+����.�r]_&H�@���?p�~JR�r|�����"Td��V��铆~��U�088]U�l2�(1q�D�os'��1NX��R,��2y�ش2}�h�v���M\�+q�W)p�8�!u["�:5P��V�X�L�g��p�%j��	��mH	4U��舰l�l���l��dmUH��X��y�r�}���%&��3�:T�����+��,=qɺ����c�"^�d�Mu�_�z��Vhb��&.��O9S�ku[2�XM����Eq�)J��򢟆��XDO��_�p	q!��UZO=!.y��2}�ү�΋CiB�ѱ����SU�L����d�8�cVa�g�8���K�k�v�nX'I*�"=2$(Cjf��bn�`cV�LZ:�;��*�ږʠͯڢ�Ci���{�S	�(ө�oL�� ����R5%��ą[����²��H���݄۰J˥��q|S6I���u%��މ]�x�� <���
;sߏ/�������ׇ�������+C7�Y�7+�Y՚�{s�D�:v��2�Vc���EQ.lF�G�Hq%\C�#6M ;b�P/Zu�a�k��=�əU�뚒��H\�M�|�V�M[]�w��
ѰKG�BV�p�8���d�\\�JEQ���J��dVib�k]�%�9�Fw�lX�q@����@����$Q�%	3�6��=K�MuA�O���3L����!�[02�[�]W�X?��?�7�&T�����A|�އ���{��(E�ܔV�N��:�V���ą+�Ic�c��YC�
�0��^�g��9�G�x�tkT�L�[���z�C�Z��h	����~9�|��a�~����p]��/����m�Td�B�H��_�,���a��0���1�,�Ƈ���M�hl�rW)K\��@���z�4x[}\�֋�z�n�6�̦�k�LCq��Ϗ1qU��%8����F�w�[�0��{:~�{p:a&��q����T77�q��e�Oe<>!����/֡=,H��Y�y#��v�    ,�FI��XP	��y�T�S��� r��ҹ�)c6`I�%7q�j�o`d����_\����	�UƜ>��&BR�S>1M�8��G���'�ɮj�	:ZMd����щ�ٮ���<�ԅ{�������W��i�U�J�=5η�H+�& h�@�!B�����5��e�k��i.KL�{&.l.+��~s9�qfXǪ���6N�Bv��*��&&n�&.BgTQZv%�p���X����zt%d�E'����G�tsCc��DvUSo���
��wCu���W����Ҷ���v���|���jU2��,��w��P�~�//֟P�9�욚bF��ܵV���3�k�\K�ʹ:0����FtD:� �t^H{YN�ߠ�^m3�1��o,�A{nA����X$B|��~3T��hhtKBX���� U�,��.5q��88;��èLR�ҥ(0h��Ic;�`�D���86t1�;�6�m	�ҺA��zY+K&쒸p�.ƽ�����i3��ş%�q0"Cl�����͹�IR��E6��iΗ���������T�vq�g�j��\4v��n�����^�W��� o�T[rt���Qŝ�=�u�jS2�zMąc��v�_.ʤ�G�Y�����#���Z�J&�7M\�еF$�O���+Ԃ��W/�n������
��Ҙ>j]4M�D�.OW@���T<'2�W
��Ǳ|��d��ą�W�aB��{�TI�I�����Lg�.����=�5�&t��Շ�� �:}.��Y���&mF\8�!D��J{Rρ�#G��X5��9)d�V��e�sy���1`ƕ��-|�����6��ے����S�qDa����t�k[c�2e��-�x�q����0��W��wL�6	/�
�'n,ܤȃ�#$����ī{��r��|�^^�T�/w?���K{��G43�!�d⩸ą��qE��FgT6��ug;�V1�97qim����1
����$���.f�qi�j�6;cc����gl3J�[�	u���%�4u�՝6�d�S�¦.��au|����GD��y@f]�ng����c��ą	�D��8gX�P��0�T�
v�4u+ecK&^��p�������۷A��]96������N�%�6?v����z�_�ۀ�W1�*��$N5��!�ln�X�����߈��eb�
�U������/��$bՙ ���,���kn�:���Ic��@�ڢ�Y���~x�����8UV�L�흸p���^w(���?P�����<��z�&/��Z��`6�I�i�"$}UWb]2�qasQ��{w_]��N�����%��4--:����5���.�&��@\~N-�F0�g��v���|n�8r±u\?&Z�(�E�B��&X`L.q��1n�z(�ϟ�>>���_߫��?�bIS~����x��h��yą����ٌ	��e'Puz����J����|�6\V�5M�h���|k 3�J&�G\�*��_�֧�a7�+7�H�Q�5��Rj̋�d������XY2�e⒯�?��D��m�(��}�a����? ��{����#ܮT�^���Y��Ҥ�Yb����R��m@�o���^#���׸�����8b�[�R�-�
��@�U��/f� R���H5�+>�ڍ�����,�&+Ig�1B�N��2��$^o�ncͅ\A:i-�.l��M|D\X9���vX�֣<��K-(�ňɖR�iU��[W�­ϸ&|�x���&�ӌ�$ى���R4n!Hkm[2�
5�%���7b���^���o����Y'��_+#�0$��v_*�iP��:�!J����K\�5*��Pg���%l9>�<�q_U�޿��t�C<�)��D4;���M\*q�oT���ɺx��5q?��`��s7�������`�!�H_�~}�����H��Z��ɂ�#?Rnm8����z��ף��(������p�5��-�&	cN����w�/����է>Lx�mַ�K�`Q��^."�Z�h��iMW2�Yq�ۚV�Y�~��m5T��f���8�7�#d*���DKT�L�J`�©���Y1#$��ف�S��%�$���C��tyRT<�)�}'Za�ۜ��2�U�e�1�q�ۜF��;{��Fg�N	j����zx`��-��@��05l�E����U��.'+��m#ۘ����;$q�W�:Q�h`���N�/u�*`8�#������qax�����~q���|3�v��3���g��3Ә/e��4���]��/�H2'��5V��V�RdZ)��#w���t%_D&.l���B���M�'x(�LZQ,|�$�`�'�_���z�v�G���Dcc�u:��� �ڒI幉C�&.�눦���(�|#n��� Z��i;�̗ILv��għ{�&�.�I���a����ؼ�4<Eq��".,�Kiu��/Qkk�q��ŀӐ�����Q>��5�!l��F����ĕ*����8��L��zy�jG�5Uo�7k�@����rZ�b��G�-b�@C�.�>��Cg����i��l!�k�񋺆���-���N꒑��,B����9��~W�����f�yV�b����&"5ӫƢX�ee� Cw2W�J\�U+	�s�4�˫-m_fN�1p�er���˓�<�s<��X���<�a���J?���=W������ˍ�����L�Ν�$��
�ח��,q��t��������]�R^��ЭE��^k��%��Ў��C�}Q]����rx̮�u���畣���5JYٖL\`���a���j�0-F03c,��t���t�1q�I\8l2a�j6�k8�!��C^��#JJ�Q��Q���M���G�V�Ȍ��/GAJ�U�:偭�@5d2ۖL�K\���7'�޲�8a=����1���Ǽ�i�&4���Z�L|�M\��'D�a8�z�S�c��d�c���āV��RmCஹ�߬�%��a�����AI����Y�ᙢ䗟&1��I%�Sm��ݿ�`X2��dą�&;�o൯N�m���E�0m<�)��0��?�}IE�S�(".\�v���"��W��y7\�}<����yy���_5�d���.y�X�5�<�~�,4�7��8��"�1]���ą��4����7�	�o�}�%�n��_��v*�'k,z(	�!���?4�@��Y6�p�^A;ĳ|�R1~��	_�V��dbJũS*$���Ϫ���5Bd����>�tҙM���c��]2���^�s3�Q��+_���%"-��5�RF�L��؅/U����J��C�/���mIɵE�\�u���z��xD;qa������O�2L{L�f������"/7�M��61�Q�˼������w�,��陵],�Θ��vi��'5m�!���uD��M�k���d�3m⒇��SF(�]��|����Y�Yge�Pe��N=��z�pkm�O�5h����a�5����xL#qa�(p��"1�F��Z��K�Ya��c�}n� ��.��!/A��~�<�X�<�~��J���N,\��zpuu	��Y��n?;��J�$x�o��S[,�B��؂�ۦ�#������L��2]���t��e�vn�?��A�j3j��W�_^�χj$5VW��(;L���K�oPnG#`��ju��׿!.��fy~�Ӷm�Z�¤�[�mG�_gA�&�{��p��Z��>�qw8�n���Q<Ηh��J�i��Y���Z�ڑ�z������S��9��.�N����MEp���!.�eS��˯���4����F+,�ޑ\���g��a+l�\]����A^��Տ���o�������o��k��"��)��ל�p�Y	�6����>�7��F�����#+�uIZ7�!E���rӉL]�܊V��7����޲�UL����teۦ.���%.�ڰ�N�����6hT]ܹ�yW3��L5JLh�؅ݹ8���H>>?�<����2�$���I��i�aM�R�,y"&>3!.:Xtfd$xy���    ��ϐ������Cu{���������wz�;-N`l�E���"W�\c�j�JÎ�_�.�'D�h�QpJV��nl\��,�8W���D��	$�Q
�3�RJUp�bQ�B%x���SJ�K^��j!DH�o�֨K�i�q���WT"}9~9�C�1*��S�i����F���)���4"��7��pS�¢���kgp�Ų܌�SL��}��,�󤴤�I
�A久ă�[2��O\�U���$���-m�~����\ $((�6�F�$�E#�&rL\�u"��Шdv�#���֛���\�9C�~;_V�u鎱�"N����gH�\��d�n
�\���{���°��7��w���KT6�DJ�Wƍ�3�aږL\���p'�ڜ =�~��}��Oy .Ҍ���҇r.�iU[2�JąU�P������Y�(�����Ї���?$g�!�m�Ɇ�5I���V�M��wb���L8s��U����fpP�ܣ!,�1��p��}�y�>�QK�z��(%i~��� 8\W�u2�3w|P�)uCk!�a���mC�U�ᤐ��0�u�dN	5��R]�\3��9nD�N!ỳ�.��Ӎ���
1R��H�u�D ��fX��o�| ����T�.K jd۵�Ӫd⵩����z;���x�#�3�^�$���K�+�
���m�ķ �W���9Ko��z�_���f�p�r]�A8E'�#?�^Xm�����R�q��ڜ��e%����hL�J)]�.q�.�+���)q�R:��}�l�/��w���^�� ��L�n'&@\Xx �b���e���'�#���1=�&�m�v���0B��)��������Q�
x�����������eV�^��#�o�ϯ��ͽV>��Ʋ�����������%��7t���k�J>D�%7M��.��ӢzR�����q �ݗ���'?K���C����n�6�j���sz�sy!���&U	�4*�
���%�&.y�>%5N�G1�{�[�T�����"]�>�D�q2�M�P�$]r�_����p淉�m>��cxj�M�k���w��F��|,��J͔]L�ML@��0m��Yp9l�x*T�q��\��L���m|�f��{䱬�T5(Q�(5Q6��%n�*|?��@�h�n��%��j��IH�0u�PE�X&���`V��%�d��ԉK����u��=C�Y}}y|>>���Ӫj���!I�"���� 	��M��ȍ�z
�I%*|�\r����}g���4).�
�h���	e�V-�?4Ej`Y�4�@↗/��t�t�O�����uz���T1�G��/{�W��E��g�ۘ���ֳ<���ZcsZll���.9��y�z{��t@�:&*a^��u��;��l��1�=h⒯��q@U�]#F( �jݒji�"!�����d����%�̜�H`^y||��St�����_��*��N���NL����ҶM��7R�s��Q�C��M����X��)��.��y��K~�rQ�h8�1#��M�Yo] e���\aߨ� �*��%��	V�+��;��p��<W8�fw�_ӕv~AX:��(Lf�l���-�����~u�W�ݰ����)�ӸZ5��}��q�i��ׯ��C�7��m���t�xf�NxD�����p��%/[B\�M!���@^�R�gG�\�j��Fv:���,�«
�xGY)�?�C�c�>��F��#��ߠ���b�wQ��n�mQ����0����E���Y������y�d���K�>��#�M��~r�e�
miT�k��m�%]i�2Ӎm�8�`���5�;=�V89�eU88_�|�S��q����ϙ*xbRc���$.��!"��3��$JL�b$V��$�Li����v1R �W<�O\A�9���������D�r-?��L�j 6N�b���#d��B�#��S�47�-��5�L�'v$0��Ҡ���Ȉ���<���E�h'f(���MD��Lܑ�����@�p��?><�~�{��K�x���=�cXt��"��S�:��ν�ƨ�蒉��|��e��0KY74�Hi��O�v� J&�6B\XZ9�gЧH� �<�pu'��`�u�bV6K����=N��y Z�6���:֬�d{ZL�0�
���%��5{t��V����cV%!!��sl �l�4Q��]�E!J0 g7����AM����j��iݎ(��E�B�ė�����zO7��5��n��OI�NU6�$�D�La�)�8�l�׷���Y��#.��ޭ������J��q�A�@S���+��`x���9���/���m?�A*�[h[^h�l�FXϸ�MK�]���4^X�S�x�V��h�mL�k�r�f��defL��GⒶfP�6�_�z�ѵfd�&� �X��	mHY 7�6��僝��~3x���~��D1�U�����u+�L�N�$=��t�4Y0hV��N3D`�O\�:n�� ��f++mS2q��ą9������������C��Hr`���6�h��%�.�y�����T��/���F�����L�h� �i�W;f����͘&X�K&Æ,�1����||�����O���?=�7�a�O���@������aV]�V���<EX�����������l�Vˠ�{�$Ux�L�ב�0PT�)#� �X����^�V��r�)Z�M��Z:��R�d��؃av@z()`�c�q�O��mI'1�l�*�Lʮ�)E�������~¹n�����1}���0i�YKD]8(>��3�+�x�4q�Rԋ�hn��(�d���:P"UCG��&�^L\��d�Jj:�(s5���{z��\(��jeK�	�؅W�k�~�qĵ�Չ��'�D��a1~�6R�L35qᘩ-lo��u_��]{����K���B�8�b^96��n:*��X�{��[�:�F���s}�X/֎nb���rEڍ/�������W2".���V�����r]�s�!�#�r��7�|��+|�-q�iḍu�s��&.܇�#�~����j]9]�vc�o��A6�ʦ��d���ą�T�!�#n��|��覿��(��c�! �%Hv�)7��d���ą��P���o���FOoO4��C��t�rc�!��-��'M\�҂TV��!���oW�U�cnkV�Ɩ��?��dlvf��؃�`�#Sc���>�jl�E���٣j(O@��iB�%v�5\t�O�PN���t\�u[L����6��N\�Ka*�Fp ���|�D����GOT�i��Y���,ǒ�kn���]s-���	����6�?��gO��		$#ыBf��J�j�d��kvF/�ƙl�2���n��nX\ ��p5_U��*�O�(��Ԣ!"���;��[�j������ևߣ�	]�擂ڢ� lAꘙ�����kB�+d�nM� �xx����E^`�:} y�m�HM����:1�1��>�����b���f����{E�!m�"�k�	13ț�%��%.�a#T�����u��=���r�`���<�@�I�aVN,괎r{�4q�.y{��qPZ���?�@u������׈�{��yx�k��'��`��ö��MM|?uɟ*ܘ�x�~�O?��y�J)�ĉLj<6���&�5N\Y��4���x�7��懡���� ��T4]C��-�n[@�L|���M�"�HY������������Cr>Ҿ�vt;���4�$&>".\�Ib��-u����!�u�����n�}�g�JEi-�Ѱs#��^B=�Uka��8����@)�W�� �M[2�Hi�/���!���,�V�=)'(.��S����x*q��o�+ЏIzx���T��}����P}> ����W�4�Km��3�)�x�a��-U��~�����-k���� �{sZ�3]+�M�G\�O��:uW�h�$�jH�w�
D��%�5C\A5��e�O���Z�7J�V�,�:�P3&��J\XN����jt�� R5�e)��
3S��/�1    M�Ac�چ�4N�	Ϫ%�o�BwXvm�$K&�� .������x�w��z�ٽAM�,v%�y҉O
�pvg;ݔL܇�����;�{m7���<�����1����A��ԉ��,����㵦1u��]�saA<�7�x�/0[�d���������|�	gD]MW����2ĝ��i2�:�0u��5�N�~[��-���nߞ'�A�FgQ���I��3٪δ%�M��0xm�gz�W���{��Hi�>���u��4����h�H���=j$����=d8�;�^`�]�݄ʕ5�_J!��|���.���%qa;�J����{�Zvݐ���Dm��k%�87MH��.�7��6���߬7����4�2�+�A����d��^�.L�3����ܸ��l����TnQ$���b��و��[$.�ܢ��$D�����d"�6lKC�:�7�̬�RM��G�n!boO��q��z��rҟ��o��Z����U�Y��j6�5��nˊ�NI�l�:eK&.EO\�"����Ǟ���6����b#Ƙ��=$�O�N�L�؅M,E#�X�_LSJ��	��A�3	��%��6A7ʜ������q�.G����v���:��b�"�ǘ��qay��U�.GT�s�.\r�b�"�����Ŭ���1�i�%�$*�.��Q����w�%���C��PN^�X˂1q���%_[#:5���.�����_Gd�s1ê�8q(�����@	��d�">S2Mr��.ܫǂ�i!�=��/���]�,���<�gƎ��]�������m}:�aQ�2v��U���jTHZlH��Y8x0�`�g:�A�v���A���k�6n�
�M��I\�^: B"sz�/��I�ʍp�D�9�V,=q�qrbp�5u��]8�K�F��4�+���;�EqVD\�����LȮ������|��}���_�Wæ�������\L[�Rm�gm��d*nb�P�' ��n�U��]�Ë�b�]�5�i�MՖ��IM��H\�oB6��s{H���K�ט
�Z� �\9(��wc'.���RV9<b�����7��g�Q<��p�kWrͯ�ђ̫�M5=q���H	�d넼�rX ����) � �2}��ӹ�B8UT�ƔL\�)q���v�G�L[��X�P��J(Z�O�d�E�����	�`�µE�����Ύ&�㒞����h��4]f�*���s�{�o����}���0��y'N���,�8�V�!1Q�9��I�6��`^@��5w�D�]ۚ����|IpŘ.7�뭸��<��Ia��(�X��m�ă�����/��~s���Һ���cC�D���Z�WH=�u��Nd�;W�~7_�Ob�2f[�b�Rc#·��͘&������2�#�h�	���uI�o�O�F=�Z�8dL~��5��ϲ��˛�$>��e	�|����F�~�7�#�i�{3�r\%.9�M��a�DX�3� ����!Sɚ�R�U�l����� ��0�-��_#w��tUyntE#��!�:�vn��gs�&�<K\X��D�#�0y4~�B6v��ꒉcc%.�����c��,Kz�d'��8RT .�&�F쒯���u�Rhba8�}�2Jc��*��$ţ�-���*qa۪f,m�)��*s�scie�я�(H��:}61�h��Ρ�C��piu�_;�������>PE��k	�i:�<�p��z��w�Zb�ë~�{��������֍
�ǗG/3%�X%�N��gdTef�ɨą�fԘ�t��p_m�/G:"��v�N��n,'���Z�%W�I\�O�ũ��d�A��v�~?�z�J�M������\�q��~nn��Q��tr��Wϯ�?�=UOw�}wM�(�Jٸ\�|�)���'qa
ٰ�N���H����@��c����Pq���R��]!�����/�n�(�ў*�����B��idM��[&J�$�V%YF"������հC�a�F_��!�y�ە�mڦ+��8!q�C3\}w���M>
�Ĥ�tN!�p�����HML����EML:yby_�V�G��Ҧ[�H�\>���H�4'�]0���J�
��c=��.�{�y�I!R���|�.�=��Ȓ��L�co�=��Qn!�GfT�4���p�ul����X�c4�l��b�?�H�qb����������U�u]���s2�S��pC;���IWǔ��4���]��F�.��<?U�=}�p����r�
*w��-�v�O�����:��9�����Q�dw�W\����T��o�f�n�bg 7F��VI�,<�&�`�6FէV���6��:z��02}!S�S��NѠd�0m+c�c������E�U1܌J�]<
 eU� 'y�T�d�K�ącUA�th�7˽����{�U��S�z��a�O/��R[�Y�>�nz��&�f�ڸ3��&:o��x��6��r�p���a,��F�Luf����NI��`����� ��oחX�Z���P�9&7��n3�Q�����������J:T-��8y$;f�~78��v~�-y�$i�qq�+ӏv��5=����&h�G��Ч�k|��է9��m M��d~�"Z7�@�P�s��8��v�h��@�]r�)�Hy/��B*�3����w��ߴ���;�&��mDg�S&7q-��%�nj���9��(pH�G�@�Ï����xŽҼ6�g��X�4�L<1��p�1T��jc2�(e@g�lչ+�3%��'.�Y�� �հ8�㯋e3�1�t״E/�F\XQ6ݚx�fbkWm=���{���:I��x�j��(���h��:�d{��F������m�����G�ږH�e��;7v��G\;��ih@Eȍ��j�% ]Ķ%�D/v�ȍH��E��N�Y�)1�UNxޱɺ*��wU��U6`p���/uˊ�G
;"DS�s�GJ\6�p�/����r�X�!�#XG΄j�.�x�9qa��5��~�
~�#y��#�¹M�5-m��0��5F�ҹ��z%.���*PN���(ca���9�v�S�HY&T'"��b|��U�{H&�\n$��8�-��(gߍC����)��|-qah�p6�@���_n�~�F�(2*G8�묱X�-�xD qaxk��f���jK���wY��"�D���ʒi"��]��9�K���>$<��׋�vRt])�)���������",����AC*��,R㎄s,6X�(ƭ�����������g���k� i��
�����@MW
WI���O+��>^`�
U2qIX���iĢ92h��K��deD�Xs�&�4M��"&��E\�� ƫ]TFDJ�OD��w�o�hQ�qvLTf��������s`6���y���K,��A�1{#�L�~#��>���X(�h����g�0�d�AٱЀo�5nx���^�澌w���2
�2���V�L�ɓ��G%�i���%�|l�\S�F�i�3�pU����?�AkR�H�#
y�cT�ƔL\u$q���@�M�v7��{ԭ��ay�/F�m�i��Q�2FA���S��%��'.�\�и _�%�j���~`���,㈐�$���k�&$��4AI�]xJ�
� ?�������Q�Z9�i�u�4���.|��m�g��H��Q�&'����:8䦉�}���Ǵ,{��XU�?`�N��?�����u)H�Lg�r��8\u�°c����_�1�HD�d�|�[��B��H�찶�b�_f�h���,�0��2Ĉˑ���^~eh�H����)��K�����'"Բ�^�/�K��:��N��*�'Ħ�zB���ɰ�0��=��x���JE�	���*�8�-���$q�HFi�����\`�<��25��b3\����f�����.�?NJnT�:����u�s�� .��#���G�!��! |@��G��������)�X���h'�C�Ѷd�v��	H1j:�(6�    ]o���nɨ)����i�$�\?G8���d�v�K�n��M8Z?n���ݰ��� ��6Z=.:j��n��v Dۦx7b���"ތ	-?{z��������'dfg�Xh����$�����{,����{��Eu�N9�n��m��d���t�~�
�f�p�3DbVHĵ�`�N�� �etu�ESxh�Q���*%\I����B����Yݵq��1M4�b���G�FX.2�v���u[���tÃ��o�*'c����.�͆���܊^�wC?�9a7�D�����Pg�XDي�E[&�ȑ�E�τOX��6��~�_W����{���X6�2�-��:E��2#.,�̈�2�?�P�K7��ݻa�ZcC�������3Ǳq�S��a���36q�k��1t�{wz��E9�
�����QO�89�rgL��R�qegF�he��N�z�W��B�7(<��D&�9-��Fw�M��؅�ˁ��ǁ��O{���h��s�ox���ֈ5iI�+S�80g�ɺ���'1����ؐ��?����=�u����O��w�1��eeK&��I\���&$��m��WÉ�Ad��e�!7a�	i�T$7�!��c��0V���U6C�I�r:��4��s妉]��w�DX!=�X���!JJ��*c�cn��_ą��U����g:tύ��(c���:�_����'u��7 ��o����XA�^�}7�БN���p3\8�e[2M�J�.������f�"XĖ�|8�`A2,~�����w3f-|.]S2�|��!� O ��a�����f����<R-| ����M�Y�ad������f�I�0�	*r��S���K�"o�ݼ�59:8�� ?\t�V�hfa*��W�l��
cu3�pU�|[y$����_�պZ�g�����:W�C�o�߻�=�ަ�����ą�޵�g�W7��!���r��ӟ}�Z�k=H� ��͈��J&�^H\8��9X�u������(Kx�X� ��oۘv��3�C
�Y�B�y�&����0���\`\��|7_Bp�,1+S�B��թL�UML\�%qa�+��<�a���f_�.�r�9�g������ޏ9'�p�8Ab�\#7�b�D���q���cp�����~��c�F_8�dc�n
�H�������l����e��ә]�}6M ���>��5��ΐ2#�F���:�.�ahpj�!A=<��>������6_�?�O�՗�o�_0��?ߎ|&2vJR�Ƒ�N)�~�k�X����!^CZ���ׇ�^��ʗ�g��vK&"�9�QI|t�*��1�>��rU ���eu�����w/������T��>�R�7���BaD�5%��K\�;Q׭����H�W$ݵ�G��!ssw,$.L�
�D���
y��n��$6&�����W#`�tM�s��?v�y�u��z�/�N����������#8��e��s�f�d��ą�«��w��oO�]�4)��b��IBn�RY&
�G^�A��<��T��W�"�U��+7V���������P�����M��=�Wv3,/���US-
OC��S�QD��1q��%/��Z�g�.��=�`��
EF��\K�V:i�FQrN�i��&�zB\�.oW�[?�j�^b��V��Y���³�9FS�7!T�)�xMI��jJj}"Ζ��]q��X�/��$����HD�ْi��0�(���I�*�w���%�F��n�mZx[�6M���f���f�!/�R����l7=�ȫuO��p��i�LCԘ��R&w6�� �؃�h@H�w�����[<Z��-�aq��u;�L�X1�	~u��谠^V��xmؚ�
,���sO��d�&n7$.9K>R��ŨxFQa׮&��	N37q�ą�9#���a��T�߬�9_U���K��w$�����^�&���wb�,6ũ��������'Ƥ�.s\���;\ƔL(�؅G!5�A6|�q {-UWX��'��x�Df�1H�A�T��@r\!RO%���v�L��&�J\��+5��������i`�<r�5�)I�3�c�)��d�z̉#������mm�/�=�nەL<�����~|�V�u��g�QB�Ƃl�㋇q�J&��I\X�,K��u,G=�X犙_�
�6ȌnK&>@\�G��	Z�6�rO��nL\�JT����tH��ֺRS�J]�?��� ��tS����T���H@�q�n�L���W��a�t��F������%.���&�.Q����2�Ҿ�R�5Kl�M7B������ͯ�����ȟԐ"E�K�rf�id]2q(��%/R����(Y�h��χ?��{������?$w/����X&:>|�ȏ���_�D�
	u���8	w�#��i�)���z�cvι#�K���Ʈ���M��u1�Ll�(M4��d�h��.�21�hN�}�f��šU�wk��}`U"fL`>q���X�������~�V��2q�R����.���>{�=X��a�*���{���Ԉ1k3�um�KL|����eb�d4L��Jr���/�q�N�����	!M�R�TY��&�s$�N���+����~ح���N��pڂ�h�[o
��� ����4�v��)P��x� qa�������nm��c'P*ى�u%_= .����KzD��b3x�pl0����+w2����P���W��]k�:�L��e��`{Es4n�r�\���%}�x/Y��kGA�+Y���ˋ�G�}�Bխ!L�D��/�h���[�ƬqC0j�%Z�l�ĝR�טU8b�� ��-;�m�"�C"��Nȸ��@�#��3�%AW�>��
���ͨ�\�f05�t+���0qI���k2�d�Ɓ(ӂ��T��ˠ=�Y�)%��$.,�S��l�~��W�`O����D��Tac;��&�rJ\�z�=m�(������Ï�����߯��\}2��Z��a��Eb���.yW[�*$���cu+)��΄Ṡ�W��R2M�c���I����)�Z�2�:҉�b.=c�Ҍą+�J�|N�r�r�N��!�r�⎂Ð i�蒉C�'.y��x�N��(e.;Q7���*'�ٓ4i�KL|�K\�\n_p]�/����W�In?�;ec�$�!x�D�����ĥ��K�������{ט0��p=/{�$��UX�(��:k��d�[Pą��z\d���P������IS��ۼ�RIn�v�����.�x�7qa�����M�X"�<EK�ܢY�Q-�M<���佲FhӅ��b������v��r�6��G˓����ڦ!<7�N����$Ji�^�hm6�k�c�ZU2M,&v�j�
�j')��
u�B�6���Ȟ��&$J�Ŭ��4�#�hD4*�~B��k�b�kk� ���r��Ɓ!���	�X��\�06jy������������Ͱz7�:R������=3��T%�OI�ό��-���qa�Su���2��I̒�!��L�V$1Kb���.,�_�j�T�O}4#����Nꪙ����IL|+���� #�x�O�b}{���,I;��ⵛ�gRYI'.�&��@\�ea�4�뮇��:5`I�� �$�����S,�8[|�L���x3c�2�9��P���6��v�������B#��R���Zqa��qz"����|s�RS]	�S/�� ��{27qh��%_�;���������s���ϯ��\�R�9T�P��#��i��%�$.��Smdh-�//<�%d�t���ci�� �`��3a�|-��H�� Pl_��Y�MIE�r��L@�a�khI�A 1<e��\�X���.�B���ƣ4��~��������׿��vmqM�h�Vj,���@��T#�L��#����g^�­.�E.�/O�����N���_�ޠ�},/�dN؟Ш�jO�`LL ��0�S-p�C�����z�ϓ'"�H0z��*%e^0!�`��H��ޟ�����H
����̪0�O��ƚ�h�(��.y�@��9u��g.1!�Bx��u�ڍ�0M�!r    �N�®ӈ����\|B�>�HI��r�ڎ��MP�؅�J��b��M�����|y�#n��L?=b�=��~|p��X��x���>��!M3��!m�0R���W����4qaҦ������pn��� cx*��q��>�13 7Mg~��L�����jI��I��Ϩ�c��S�p;�z01 >�q��f����Ǎ_���U�Ȥc�6�u�ċ~na�N�n�C��_Ĳ�C�F�5x��e��S�rO]%.,uU6��Z�H]�&芬j�Q�ɐqι��2�
'�0�:��k��D82TE�P���laSr��ML|K��p��2�S��bX�$���~�o���ߦ}ܓ������a�8��&��m����|�8W��0'��zy�����߇�?���k*���;,�&��%Ic73qv���k��B��袄ũ��ۮM�üJ&~qą]�6����C�gҭ�ON�3���s.�Bf����CG���X�FB����vu�x\���CִE87Ҿ�{ҍ*���m���m�i *%m���5���� ��r���61�ɒҫu�l�z��d�dn₊�%/�ZL]�Gz9�]�t�E8Y7"s���HSն�.X&�x���A߹�6�]����Iҗ��#@���#��C��ï�å�Ë�A�ϕ	�h5[�.n�.Ġdh%�C�=���7�f���1rЌq�T�5��t�l:V�Ir�T�&^���uX!:HT�q����������]�i�(�cL|	���p1f��Ѿ���	�1�œ	5-mS&q��E('�I ���o���x��;�[y|��8|���ym��f�LO(�Q�\R5��ā3�i��>x������w����F�"�n�2J&^����$\"*��1w6����<����&��N\�z��[8�a����q�p��:�_wOǯw�?V�d��FYH7�CX:Z#3�� �7):���ܠ����M�"J3�� ~���ѢQQ7��_��D`3)��pے�׉ .�NDmíwB|]�����D[���h��O�g��ئ-�x�
qɿB�6�l�ˋ�&|�A����n���%��L#�.�x��a��Y�p�뙢�i�8��r h�X��v�qs�����G������a��~�am:��i��ۅ�&�6�KV=ֈ�����||q��/O?��ow_�fa\ĩtWi�/�U�'����χo��O��������9��
bŤ����x'qq�����i,&.\Un��Mn��%d��F�"J����q�uk��J&�aO\� �kI�ߩ�q��Mu���8'J�2�t�&��N\�����܆���:�[bq�R�#�)Q�Ys]L��M��&q�W���<*&��YA���l��h��"	3<sBS���ڔL9q��H#Ñ�$��R6Xԍ��Ʒ�V%w0%.�����֩F���#�ju/��O�[1��	�H�����ꒉGl�Wc�vf�\]�o�c\�5ښ��)�͸�GpB�8��M|�E\��gtf�,�m�����+�Q����M�O�у��u،O������'C� �<͌�KT�^�W�֫���۪��5�nT��ZXS���؃�]�T��o���E��(�")�p���E�!�&�B@\X
�i��O�׌����x���t@
�j�U%�R$.y��(��p�7;)�US}XZ_�}	@ќ�&���7���e�%'&.gH\82��L)�o.�ͧ1)$��o��O�BeBީ�� �zE��0q4�����[��q!��]ze�Q(;�MgI;$3qWV��\Y�Ћ���߸�j���n���Zk�N1������d�H�Mm��%)r]p�gh�b�� �òG1�����z��W���G�6���_(!4_&lm7�s�D�y𱋐4��Ò�"P\EH�P5�u*��>C�i�����]K4�rc�2:�L������,������{�gD�ؘ e��jb���j@ ��?���]u�K�YeFn㥃c��w����K'��/=nä�0��A��`L�qa�Y5b&�	�1@s��" ��NXh����g��!P՗G�A+)8�±�(q�ߺIfs%&��x����<�.z��GI�v�{A��QX�h��ie\�
� d#MS2q7x��0�`������^�/`�a�~�T_��vp�n�&�ݳ�9"����L�79p�s��5i�\o�������Jl���
t��V�B!�y�oR�51�$k��ILI�m����#��W�L�SO���
F�{�rf���E_�$.9�G���{�?����~�=}=Vߏ/��,u�����@%V�T G�1F˂��%H�����}?2��y8ܴ�:Z�7_��ob�উw���	��z�頚'n<x��7Er�LZ��0�	}��%l�o�CU�)�_���ଉ!��<Q��I�D-3q���%1��c�S�����E�A ���ߎ؇-p�}�)�X%/5qH���G�|��u=�`%*&�g3�jǄu7�L�책G��y�F�Q��m|F�D���9R���7O!��}��!�W�_��a���A]!�#C�r��/�0��g�lu�X�z��E:mE97�9S��S?���4�!����-�иeǍ�F|H=���%g��ӗJ\8ݲZ7c;�fx����E�n��ߺ�*fM1���/��QZiS2�}�)1�
';r��p�j
+�(mǮ�"F2�	�؅%7hH��-OJYb�8�L�_�4ҔL���pJ��Vr��W�i�5/�A<-VRZ������& ���lt�oH<��o��o�-~<���Vg�zb���ą#�H��:��qT.�(��YdF81L��\�����=�Z�g^EG�:�^q�8z�v&��e��{0+AYhk��X���A�����B#��d�֒�p�J���IW���QT��{��Jй7i��_��%_p$.l�Q�sE�C��5KjaJ���\��Ic�i���YI=Ҡ�wm��R�{z.|(��$PJ�	��؅���p˳���љZ��k���6%��'.�v@8��(^��Ű޺�<�.�HU�tE�bQn�{�ą푪.@.W��/+��k��(B���i�Aө��˘x����ׅ��xڞ|j�rX�t�8���-�x���t�q�j�����������<�ͪ�F5���)(��K&�C\X��i���Ĭ9.�u$��V]�>HL|hK\�ж����W�gb�'�p���'����Pq�-7M�xcv���e�N����>\�T!�t�!Fa1&�UJ\�V�Rg���V�����\���.qZ����م�%��.��[��p��=�Y���3n��>�5Vg��ț��k�v�bZIn��ćsą%���`�:��F�Z�u>�t8��	.����bV�Oʀl��c�_�����㓧��B	���e�ҧ��!&��!.y	Ν.�����ż��_�n���JG+�sSp�k��b�*va*�&���v��~�������<<�����DWx�������T���&*����;x��ê߄�=�q�1�B��%�s�V�
$3�)m�&�$L\XX��u��t���GX돧�/�������������)��0;r�m$.\�K����tx��Q>r�.��BB��3���1��(�z�]��$ąH�Q��E�J��L �*L�j�e�[&�'_�$����7�CG�׍���_�&FW*7��Qp��N�M�'��xbBm{��A�[(��1�y��H��I�X.��o7�`_�41T]����\�>cؒ��N��4�39���i�lz��~�Nu�X99�xD��uŕJ&��O\�����S�ēb����g�mD,5��&�؅�_�h���_'���(����T%�XK\��G'�1�5Q��T?7���h��	Տ؅W�s;�5ǿ2S^�_�SgI�5��//������
�0~�6΁��r�W��k37M�.b�G��mң����Ш�}�jlT��V8(�A�9u�L7m̜dL<s��p8    ���pu:��,T1"�����K9g��7�,;jn�	u�ȃ��%	}.��p����np0V�����4C&PA>VX:�>��T�؃e��~z�� ���uN5f�T���Bɒ��>�K��֢Q2�"���~�ENQ,q
��½)C�r� �o#LMy����~5{+�M��%R=f
g	ewzl���c>G��	��_,�����zq�>�9d?�h ��� ���5��B�����&�_��H��B:!�-Rn�ۦpH����K���� uB����/��O�R������Q�����4B�a���R5^���nJ���X쒭W��S�e��~�	9��]�852A�NB�_q�^O���A��t1���c�ns|�GL�n1�	�(}��N�/շ����p��
K�&J�v���ጱ�r���-�W���jw���0�D!�1���/m�*�����F��7�OZ,�J��B����f��^�>F�da�Fm�8Ѩ���M��q�5)��(��-i��ڊ~*�m�ܛ�&�����؊QW�#2|Fq�XhC�S�o@'�!�&IP������hr����9��n��f$ܢ��p�]������Rଛ� �O�MӨ���&.��!<���f�6`�_�o��u������p�A����(P��Bf�T��M<���� 
��f��C,����� ���J�	ͳ؅���3>��aq�u8v��\��ih�$�y~^�UgԬ횶S%�����ϯ,f��� e�*���q�R&�ҊM�Y�� %�N���u?�ϑo����I�G��N�L<$��0��ӛ��������n�uG#rv��~�p�1���i��uv�ߐ;��u>ُ�i�'�$���]OTu2D�s���j~6W��{k�[��佺�N.H�2xm
⒯�A���|�c�5�Ô5���1=yl�H��%�ssߓ'.lOr���9oQ��dr�n�8�u��J&&eN]�gZ��ջ���z�`�j�H��#���`����>6M �c�|��;�	����5�R���i(��"@��3���XiJ&�>��0����J��V/O������z�{8B$]mn+I��b!�?�V���}��P�\��ujА+K5�#{p�n������<�pk��my'�QM���^nf��Ǒ���)tN�r3�.>�`����h����ܴMS��#�G&��࣑T�Ey/^�?�<f���Z����S�+�}�K�:J��p�δn�Е�����!l��D�~4���z� Z���n`F�d�\�P���Cح�qO?71�>uɈipLգ.��"n������������0����"�(Hy�MF�&&������(�Q��e�Ł����)��@�5���d�GbL��؅�����3RO�K���n������	� 1q'{����y�Swߎߎ�B��v�~�2�K�+�X��;�����%v�V���[������|��0\�W�z���}�q�:���a�`3C-�Xf47�+��6�Nr�=�?��$9ݓAUx*T�Q��-���>q�#[<�c01l=2��v�!lPš�X��5q�8NL�]S0hV�ñ�:(�����矏��[�z�I��OU�+�H�3�#��롈����/>��<|9������B\���<Z=:m��<*8E�8J�3��(��(�'pk�`�_�#.yqTt����n뎴(C�` 8��>�D�iŦ�L+v�Բ��U�������k&�֨����q�X~A�,?����7m�3�d���%O�-B�~hX�o.{��W��)�8�.fb6o�F6�㒴F�dtkb�n��%_a�� �p�klɍ%��ay��Ԋ���J��p;@���ROb�+ą�T�6���Ѝ��̗�Oն�� ����k
���p���ʔL|tD\�g����Du@����/��_�Ʒmmq��̅v"��Nf�M\{!q�4t��V��0�l���(T��x*7q�t�,1M2b����ގm'��r��;jf]cM�J�I�ͳ#}��y�H_���dZ�o>�$��N��z���x�N,�j��ӡa�D��K9B����e�cm�ޟi��11��c�¶�����.�N�[�0�L��d��i�hK�	ɖ�%O5P�����{�0���؝�D�H�Yϴh��=��<�؃ad#�R��qp��/W�~"nu�-�`\1w�Y;�{��U�p-r��4va����M��������#�U궉/HC�p�=6�Ml��
��;W�C�Cp\wn���u�6�?��<>��G�=����˿LLoFQH�1�2Q�m�L	��M���DV&JC�=�����X�Ѕ��:+KEDpqiʍ�!g�%W M\�ukx�cg�}��gK��u�+Z�P�+v����N꒯��QK�#�5I��qͨ�6k��	�81qar��4$���l<ڗ�٨G]�e�@�M�YI\XB�����h�ٌ'ɑuJǕt�+m�M\s6q��)Q~!��� �/��ル�=|}�y�~@�v���0������OA{�f��Jp>�����Z�rwz&.��`�ژ:��Zr�9�n=27:��	�%1��e\�yT����X�3Q�SJ�w#��ڠ�:����6ҖY&���C;��,Ȁ�3��e$c]�T��W�����F�L�!u�4:��#��Ѐtе�C�d�p$T���Dh�ǀ��H�(E�Z��IH�jM\��¦��<O(!.y�eT�ڟ6�B����r���V�j�8�+��sS�-�u��*A'&~{.��Q����#��Q7�e��ԏ᷅M_U2q�x�?L��}�p��b|�灖(�h�۠���r�@�A��*�B����L\�"�P&q~���4w�p	�����1� ���j5��6]��E	�%`l+�(A�(���p<�ی��V�L<3��0�6?Oz|f�������[n����7��Doi�s��ڑ͛��$]�ā��3�(��ozx�հ跽��R��Ho���5�M�HqaEz 
��e�gEz�x0|>�ua/2fI2��Ĝ:�K�������?��	���X>R��ec�Mg�^JLE��%��b�Y�֝������P�1N����n�֚����G�J��J՝�%|�%\s�2\�H�v5��̳(-)�'���A.pI�*Y2�@M��]z�Kn���ơ�"W��8��T�6%�D"v��>��\mV�8N���X2�y!� ����ԒiB9*v�Ag�ɍ��o�'|�E�a��X��P6��::HF4�k:U2��j�'zX�A4��V:ɭ�F�M��r)-2�a8���L�$��+@&.L#�ԑ2F�L�#��h��E���C0q�B/���ͷ�#b���3l���Ή��W��]rw'��nW��c� �w@�r1Đ�i�4!1;Ӣ뒠61q�kⒿLH@�1E
�@��}A�����u�PLE;Q�YN�jD\��M��c��gq|�����!l���Kxž�P�&�"��D"��mK&��I\�ޠ�;7:�b�Ĉ�7�.y�2t<ܫ��x��x�q�X��	R:���]$������s��V�g+I�aK7��U]�M��-\�ȃ�J7'��b�񳀃p�&���M!�i (�w֤�)1�)q��pX��>O���J���VA	WM�� &>t .,��sB�݀�#�*Sܾ������㑀��߾ąݾ�*үr�������m����."0r(>� �Y�e̙cL<����(>mA�-Q�v���W�U%�8yc�f�聯�r�r�5#.,�L+�M�h���Mm��ݵ����6LT������l���Y� n�xA����@ 8��ӄ�d��I1�6!��x��u��Ӻ�_ K><�������_��Z&�D)'Xv������,�?�ޭ;���~n��|���*��>OI�D��FW�������ţfS"uHqy���/ȬB ���eOۊ0f"��콣�Kn����7����wJgb�#
{�8:���(7����vG��r����/?�_^B��*��7\�\N�_
/��5w�    e.�ge�K_B���')�O�p�����6:�wuD<F�ʘ'��Q���\�Ra��j��^�U���82��4���j&^������!�~(8�xlv����Ϡ>�'�bJ�������O*`	Zӥ�L�ćą� ͜��Z4/:j�OmM�J�^+hxQ�x�2���DI�=E��u\2U^w���m�^�_�zG�x&ng.������<B��ء�>d�9�5O".,9��mG���ՉcN�B�S��)����o�����L{���uE��~M�%�f�wD��4�������+��ˤM�.4-"zU�p5�.4�Jr?�Ǹ8>�>Ö�o���/�J�տ�bhi�1�"qa�G��*Ƚ������O�ݲ��nc�+n�!��r]��,M܂3.�`g�L���z����A>n����.��>�@�/|}���T,�'B=2 ��vP��o��k�춗����� }e��gv��|W7�:��-�<�fy��b���\�7Sk��T�(�'$X�zi��|� ��Ӵ��Ը���܏����0��[����v��|Ʊ�p�~�����k�����B,1��!{i[��|���3F,O/=���]B�"O�v�O������H�ou�ā�3�D���q*�E�ߢ�Ӻ9o��|~q8����v�S(&LS�;�h4�Zig�hJ7�]�	A�4V('�b���z|�����X��^���i�*�L��$#G��6���{8e���q/�x��
ծ 쥦	T^��^�f���s����P8@��83M����Bek�?I6���4o��A�ET�1�jb�#�R������xC	j��Jg�O�*@�� �'6�4��nL[PR�U u�t;�ǉ*p�#P�ק�_�>��9|�D#]��QdH4lJY"ў�{�[�D��&���\�hO��4ju�w���TӲ�d´U5�ZoDW3q=�̅#�)3�p���k�L�l�R\Zi�h�.�H���J�VV>�%�����x�$q�N%Z� 騖\�-���|W5M�wR���ɓ�ǡY���;�!�~�9�O����>���� ��i�6pl�6��H�c$pZ���tu��vM5�Ky��!ߴ�ѥME��#����2iPj�Mԃ�uƞ+q�I��T]MC,t������f�y?ą��h8m�%���X:�)�:@�p����U�&�̩�ô~}��o��=��f���;-�ߘEޮ���Yf�1��~cڛ��=���4
Z�����W����f����J_�".leKu" ��p��=oZ�SY�(?ū���k���C�d�o�-�y�GB^�Zs��p��w�U�fbvq���<��"���[�OuA�v��1M�1�.}�h�f���c�]W���I�<��Q�On�1#ąŌؑ��R���vis�A��8�2Ϛ�� էF����ߜ�K7���}��t�v>IEa?�H�l��U~�"Ǖ��U�Z�<�6��ɹ�q3i%��5ύ&.,7Z��`��������ŀ'�\���&ʙo;��(M|^F\8�P^$B"3Ը�QB����HGT)�]F;�V�2匉G�y��,�}y�u|��W�P;��w}�4^�abG7�Υ�y���݉�e%à�������p�#�S�C9j����n]�X�8RR��(F���w�n����a�zȶ࿽E^�߾�8X3hE��Њj1�U��EJӄZT���E�C}����,��>X:^�C��Y��P*MJ� '.,�\���/n��öiۂi��p(R��YA������'sa��R�q��u��ʛQ�KI���O�� �χQ�%.��2��9_�n[v�LE
���w*ʥ��fۚio��0/J5�SN���Y�I�+aA��H�=�N�O�X�o�Ed����Q�Bw4|yDf;7U`QE��C��L�%�l��B5��l��@�;
�hkm�4тN]JRv���X�';`Hdk��	:���+s�f��H�.\���S�p���pjab��ݏ�sCy���P�8��9'k&����z�D��������(����9�;�`H�W�ٚ����F�%�6�΀חf������˟������%�L4͙�1gkS%��1(����	k2e����6���W��Sl�[�cᩉ���8;O�`_��؛���R���x�q�H��I�c9�͛}{x�ql_�??����oߟ�U��	�0�-��iջ4M�R%`TB��V��e�c����*b�.*�\�r�Y�W��N�d�G_ӫ�Ne���ą#��d�f����٣�'$uÖ����@�)f�8�6JS'.�SjE�;���k5��܃�)�um��MMݺԅ��a�Z,a]�W="��Ȯ^�7�ԕF�B����?qa�f���EDmV9*�	���Z��"c�;�ą�,Z�ϵ��%�E'B�+�&��	܌�XK�R^t8�O�E���[4k�i�@�.��E�i�3_�sfK�tZmi��*R��0N����JK�ۅ�w;�s��Lܹ��0 oa��D�
)����r��6�P>g~��FY�R�fj�:86[S7M�*S��W�P�:�.�'D�yU(4���n��6��E��(p�z����~�b���������H�m�t�g���d&��A\X���õ�?�N�$M�~;����"Z�s5ӄHh�R&����a�����cԜڮ�!�<��d��٨��VM��J\ʥ�A�P��߭Q�� �=Q-2©�%����:�F�qW3�x ��=@ȧ�8��µ�������\�?}~A�t̲ϲ�.߶�M�j5
X��"���&�M\J ��@t x��4�>��/�Op]F�A�&m��^�\Kdgc���񱊱E����.�L/�9O��$R���m�Y+L��n�z�h$ �#�d 7�"MT�Վ��&���0�Hq��w��LZeVv�i�\�y=�"�A4�k�b��KSx��oIE�3���U9c��S������w���x<�^�BN$�ՙ�k��2-S)M�2q)W�S�"��
c��Y��"�n\��Âmu�8~S�:o��LJS��`H-	:y�\�K#Od��rI�k[$յ�Q[��&Zĩ�"6%ۜ8��QB2���FO�
M�$���)@�.嗎�'� �Z<��8�*M�	C�"�
dD�BF��L̇����
���6��+轤�$�.�q��x.�EL�`qa� �q�y���
���Ue��E�[]5�r��4����C�e���S:J�%[���&���ҢzPX��/�(�[#�m��_�P�{�ؼ���w#����1�#�x��VN�$h���Ƙ����0���&�G���Q��~y����}�b��%��L�ź�
:�j&^����2%�0�>���_�]\�����r��X���jq(����9���xB-q�p	p#���_-���E�m��̥�PjRΤ��2*s/mG\Xi;%��|g/����o�ͧ����e��K�8���Y���o<b�o<��Yw��//��~/|���7D��"p�6�J8n�}祮���qakFI� qw@r�&�K���N���ҐAya�BAi�kSFn �SK28����Z\�ף�s��3<ec�1Kr�T�x�2qay�JQ��k�7AIsV���E��QG~��i��.M|���0��Q��O�F%X�T���� �*�	:}����ԃ���Ԫ�^���r�@�\r�0*������L<����\/��^C�`�; >���{Y3q+�\��HIoOP��b�F8\��U��m�Ri㮜>�s�:�23K�a�\�Ȉ���(؎)d\��fqN���SW��|;�+�	�c��c��y�>�����h����O/�~Ș�i�R>�01[�,���_�Sv#����9��bj����j&�J\x\���/'}�\���B,�	��1�z,ą�c��Ri�\�,�$ȒJ�7"��B�h!��5w#f.� ފd��.�-�um�NQO���.f��    ``L��/���2���4�Z$)!7��c���V�L_3s)Q[!$����-|%������`")ڰ��#��i� �8��f
	ݍd��~��8`_�1���}(ݥ�<��sB#��b�V�L\�.sa2|���v`m_~��>�rq��E��rR�S6o��r!.L�"��N҂��]�A�*�\��
y��3lI��f��y�G��+�$j�Z��t��d������+.`��m��iy�����3�6����y���[���Ĥ_G^���-N=� DU,�_���&Dw����)�+bU��F6�?�N��K.��if�LW�J4��g��of�8��⠡��s�3�fH�*ӟEN��)xF���&����F0���\. X-�����l.��sMui\�Fk�zۥ_|i��q)Wk�4��S}w�z]ג���ӕřQ�Z�L�ԅ���q���������X������c5x8Z=�0�&^�����:�ڏ7ql_~���B���ˤ�(z��&��ڙўP&swHR����?�p�n��5��~l�a��߱���������y�~����k�����c�d��VTO�&�S-M�4�=M]��@{���F�e�� ���@��P q!��z��lj&�K\x n�N�M��M�y|J�E�:;�p/Kg�r5�S2:��׸ڋ1�� ]ea(9�%f�Q����+�naF�A�x����y�NӮe)� t� ����j�����fT�@�)�KW���Bks�f'(���{t`躙���� b�,ąf@^�;������t-����~4?�G���Qhф�S�N���b�/ĥ��og�`�1�|�_G�����2����p��CL�9�#�6L:�p?TM�~�\����q>'	��@�t�O����+f.%t�u�9����=|���oo���{�������W�
��g������C�x����4�i>?޿���������K�_�t��1�a�(��[�&)M�c�\8Pc6�Y�4�ʅ��'|���NWM�}�R�F�^L��R���ؠ?/g�z���[M�¬F�n�i5�T���ᑀ���<ך���.�tH��ѷc�L�}~��ޟa��) �0d�
�{~�!f�+�WDA�H�
� �H�R���(s�@�p��U�B-�?��|E}:�g��){�����qa�_��ڹBPƾ���I\a�U)��JĲk�	k+eѡf�$�Ab ���|Ǹ���b����?H+|����3�r�&�����!~�Up1mW[\vs1A�Da�6b�R���¿^��@�f�1Zą�hA��ǋ2�m���Z6����f:�)3|�\Nf�h��.B�1?���ց��_�;�v|}��ĉ �J�Jm�9w-:_���v�VĪ}�a����۬#C���Ϸ�*~=~y�u$�'�u&��βv�f�6n�R�������e�	�>ӱ*&���[�L�&�	��ԅ�Pb�'wѯd��&�ZY���B�3e�ou��_�ą-��Q��f��X��Y�h�pl�乕�	U�ԅY�.�~�a��4s��4H�՘L��:�i"7�zLąd��$�1)%��:,�D��b �.=W��\Jl�h�y��/��r��]�P�����p3 aH�;�n:��f֢�s��՞��bm�)�	ؗa�Ԋ���?�Sq�{�����?}�����-&�^S@�h��~k�f����.�"�R�0�]�Ls��7���~L��TM�c�Jn�}��9A�|����7�M�҇[�<]>�^�!�:\��a~r�%�c����Y��Ϙ.����C�Y�4�l�.L������^/N��c�&
2�^��⹹��������3��0�9,C-����Y��?�d_��"���c:Z�C�>��Q�0�fb��܅n;1��R��r~s�n���bCE��r]r�b m�DF�L]�ԅ�C�J6S���b�K��w��6�Lh���i,�nFj� g�.,;�$�Tkh���K���a	Z��ߥ����r5��ڠ��|~~=o�wab���9�4D�H7k��m^�'&�O\�J�����>)S�CK7��kEJq.M<-������|�XiH���Q���7�cY���S��)cuK�j�8�s�DJd�p��݅:��RA�4�D9��gl����|s7���,f ����w�8]-���I��L	CF��
�����FR�,�}�v��8b{��/)�D�iD���J��#.,L;���!r�_�I̟A�q�}�p3�l�4�:N]xֱ�E�xv����2��N�=d2�xsi|{�nE[pjäy�v] �U��Z��hѝ&ܽ�޿&���_������O�7;�7���f���P�6]ti���b�-\�v��qu���GsQ,��:�\
'�ÔIzK�@J/�B\8(��s�p��P7ǁ�T/���ҍ%x3��BW3q@�̥�j�]<k�n#9��_�ڧŘV���8�';���U�{Tᄗ3����j%�v<A��įU�L<�ԅ�	z:�dl8!��K���T�����m�����7s�B_��k�з�ґ��Rb���)��^[4�LT�ԅ��cm����T��p��"U��޹4�Z��9؃�x�q�<�FF�y�78����ኚ���ܦ�
_��w�|[3M֡�.|:����>,u���&�-��<q��m��c �����?.����e�"�/=�"İ��yg:gk&^����R���K�4,l�F�Y2޾�1�N�P
��W|�>q� f�/����~wX�9&඼��������E!-5M�R������4�^l8��@��r�m睫�8�j�� ��RC?�%ĕ��3J^��Us}N�q� x������h�R>3L�Ɖb���ŧ�l��fS)��`�����J��f�"qaؿX�����jd��ߟA��X��a
���)�?7MR��#�����;�{Jo���3D#R�����0�U�i���~s�`�'�L���,L�;��/Y3q$�̥ qZ��g"k�pS��~ӿD�R5�pηy�����%qa������l��7�]�>�:�(/�BeJ;��S��R�D�(uap��ݜ����q�f��]�Nش"�J~�ua�r��c�a�ą�[+O �}�ޣPd`1/Q�zI̭���PGN�d	kW3�_qa:"p.�����e	ʲ��~���@����B�/�����p9���~�Qo��<3�~&˼����~�9I�����4����`���F�L�!s)dj3������}���	�߼Gv�T�t�T�/䃡Pi�nSSi�H(S>�/+��^���ei,��(��v`�y�Ƹ��+.f.\F��Р~u�ľ�#ۜ��b����a�t��2GU!��55\��k�����g�@�.9���0��Nv�f���̅A�!��$]��͙iXW��Kq�Ț0���l��������C� �>�=O)*��쬕6)o�^A%�(��lM*��&�݉�bci%�j:�a?./��'.\%�� ���U��~�.�rUV�}_:=��[U5���RvW,:C�8N��(1�pB�Y
׊�AL<���p�'o�e?4�.�_�ޅo��08V������S����ï�|yi~<�8~mv��-�w"��d*�R�[�0 >wF�]��忙����Rq�q����_�Ov�\5-���v޸�i�ȕ��E.G���֡�5HY�����&��h:�d�j�Vd�Q����Pښ��_�].�AS恟�VR�"*��b��
��e&N	(s)W�b|J�N	�*g�	ß��zW�L�
�U�:*uv�����z�:C��AJ������z�L=:sa. �8�x_}X����
&,D�2>�I�u��槦�n~�±�nZ�.�����#c�7���c��.���r�i�3�gf�s:��=C�-�Ȭ��n⠗���\<S��ӄ�㺩\)��!�+���wQ��~�@��L�S
�o>&�	r�t/m�U�b�P�ԣ\��<n "}x�������:A/���    ����8��f��ą�bQ�r��a��0= !�\��xz��x���7]�Nd�	V|�³�S��Mf�-��~ф�?����16n�,���33���­�D���%��
e�8���m��hNc��L��m}ކ���d��+"��w|y{�����v||n�����?u��F�s��f�t:�Z0&^,���b�Va��|��0H�
lG��[�:,M�e!�P�1����rK��=H���wMPl���g��MDL$B|� P�g��\���T��t)W*�")î�sw@�<����l��Q���]�&4TS cT
�yw�������؍��ߛAΩ>
4#�usi� �.<�G�ĳ9�~y~	o7UZa�p<8`+���fb�p��F�2S��oo��;��;|�����갛��C�H��U�2�E�TＫ�8U�̅kb)�;-��kp�����ۢ��vx�wCJLQ2T.���V�Z�e�����SN+¤�g�Z�>�������t|���[J9�l�PFM�BĜzFL<Ì���t�ݲc��v��M�+��6��vsRm�����Ɓ�#�UX3M�R�q���b�t{�i�tCD9�P(�d@��Ƭ��eyዘ&P�π�P�n�����բ4-��q?��}�X�/������M\���|�Qb> b��B!-Y+m�M�q8:�k&�O\��v����?D�m����b��~��"�"$���g��5�D�-��;nZL�n~����~;V�X���C���q^&��1qWy��]�ȥ&�<J8&wp��.t��F~�"m�\ �i�V�&Z)��߉�������j�	KXq�]*a�T��|fp�X���R��#�d�Ys9���r�AE����_���ʲ����Y+����@]۹�i�KJ]&�$A��۱#�~D�PS]�Vq���5�P��.N(:�h�~�jn��9,O�����I�t�l�ņ�+��Z�:�7Ԉ�?؉�ņo^�j���0��_'�i]w)���
A�g줊-��۹ԃ�	�j"��b\�e0ٓ��f����Nu3K�o�	M�ă#�A�z���i�i�<=����=�u�z��̞<	=I7S��E��)�1qu�̥|�-w�<풋����;z]$k�A��bp�C/��wi⮋̥\3�� �z6)�T�����H�j���d�	Jv���9�8�K������n�ڳU�:3����g���z����k�p��\D�Jg)n��Ӑ=	g���BŶf�A�ąk�up�&�6W��[c؞N�L\�#sa�x�S����rq��ƀb���ڱ���V���BL��B\@+�%(O��BEǹ��]Qw��sm��ą�_2d��pPD��#��ŝ�J�|��C����(�j_⤓a��[*x��S�0U�f�* ����ר��/J\�<�o/�O�!~6M����K�*��Lܑ��pO;N�����,�=���A�WZ�*FZ��Q�.[pf�[QąmE)1�����]@�}2��d�� ?i}�ag&.�\8�	����V�>EeԳ���w���mɬ��4!B���"�,�X��"�W�41?��ڶf�F\؅��?�0��y�����(�@�ʐ���_qa��Gd����7g--��B�\9��V�J-��RvMfD٬{,A��!�J7�ö)2R-�z�&nY�C^4F�cK���}���������c�-�0�h!(�(�9�7~����2�qeIC��q�F�����|{F������������k�����ӟ�o(���G�S��+&��AE�Xo����IM�K?��x�FЗ@_#h�L�Ff��E�۬ut�xq�ā/u6�*!��uD^,�����yy���\�����p�%��S�xNʹ�Q�Z�𫦉zu��J�gI7c���v�e`��V�#�*p�;4��Ku�fbR�܅��!!��S�������|	!K��:e]��HNw;�p�t��@L�]�R�����f����A�	�Մ�el�������G�U�.�6�3할:�����~�{^2��FjhW������%d����2ɘ8��̅=�v���\���x7�/�2�:���UM\N��p�)� �! �S3���y<_:�� pG�U�-����_�~I\w(��H��~3hR�����] �*,%��G+�'�In���ԃ[��~,����Qa��
��G��J�t�Xn�^�����S	{�!/��zW�������JL|U���4��	��2�����
VӴ(O�L�\3�-��,M|G\8B�4^��"N]×��|�ہLᨨ/E5w�U"Y����51Yǎ'Ϳ�ٕ�<�eUNk�����;�[_3q̥̈<���=�}�u������49�}1�D�%z�U����IJ�م#$b�AV�íҬ�����>
[��cG��s�`�\8
�7bX���8�;��JҲ�&_{�Z�u�k&�EJ\��i�j9��8Ң��]��d�Y"L-|�z��$J�*(/����a}q�49"�ˈ�zJj����i�~v)!�>D��z�K=꒒a���E��Λ�(Ę&�l�es�g�ݻ�G����0�r���2ʡ��
�p�T��W�b^i���ĥ�"������E?j��[���mf�I�����o���J�����?�/����6W�(�'�Z��z�����
���<��3�,�ˠ��g�8]7�|��=(H��M�������T��� #�S�j�f���ơ�CӲ_���H'#Q@����Ϥ������`��a$~I$�nq��~�@� !z��@��f�j��YST�����f�i�����Ox�zr�+�:�Q��o
ᖲf▕���/��~P�/6�,6��ؐ��O�vj��A;Ӑ�z_3q7W�R�4~ C���?����o8k	'R�ul>�<����Ys��|�c�~<|>>��燗�o�?f?A�'���<�3AJDci�j�?��F�5s�X*!5k"�f����	�4QW~O"��-�+��5OQ&.NE����U�ոҫ��C\fڋ+*"�s�*k�����d.\ED[-�9����C�E�Wy�%�還_3��qa�/,����~��/��������3�Wi��4q��̅�A�(��o.+kv��┢H��ɕجp�V�k&^����JlpP�v�2*/�X =˰ax��R��B�K`��}6Q�%���9ua���@pT��c�i���q�q�XgB}��ڮf�u�W�StWB:��^�\��a\�P75)�*���Kߩ .%8
'��C��z#��v�_�������a$�$�1�8�F�l�4��L]���ɓ�b��~�)�+@��^H�����a��-o_���g.�ʕl���.��y���k&��%�т�����!�(p��L�1����-JaO�h����3N6|~<"���[s���[���d�&��!���M�/&����k�ZS3q�[�R�[$#�;Q����B�N�T��1M��R���J��j[Z~��o�M��TT�����=s�p]J��E� ��&�l�['S>Fa�Mԣ\J����"�S����2���� �Ғ]i�OH���r�X��I�����)�ʶJ�����ˠ3FND�T�¨�d��2��'�[���j&�5E\�� fJ��ϐ6<=4�1#�~|<>�s�1a��N*�cB\"g�6.��L\r��0�9"4�D���0�d�¨^��L��0�!b�l"�l�;�/$	�h�!f&�K�\�OQ &��}��!I}&
Qvr�R۪ij���-0z'�>�oJYhlޒx4o��1��r*���M|<J\�V��g��{Xڂ�v�ZW׈Jؼ4*QcL����t�����ã�-'��ɧUj-��C�Sw�RN�3���~�X����b}q�5�_sM�.
7t�N��MM�ԅo�%����4C��s�/��}s�����H2<M0<fAUa\�4��K]�^(\��f-|9�0�uo����b�؁����m���5�/���J�-��-a�g~ɇ%j��{2���3(hF�<P�9�j&��&.�KL���ף�{q���״;�    �a��)_jzϔ�	f{��3���Id���W[T������Q�e����X�T�����:��ו֋��Yln���k(a,���󩠰"5%�"tr3�Ib�مCa!����D�QwwX���	�K���j��ٔ6�y���c���a�6�ELwi��ߥF$w�MDd7�w�EEaDhX8�Q���c��\��y���
����)�[g؇δ:SK�L�L]�uv��|�����aVJ �E�$0��u��gL\f��pH+;��]��0D�v���^NC㹐�<��r�f�l�+dc�8_��]x��[�R�0l'���Z�ކ��Gei]�ĭ1s�ap�҆"������ܮ��!Fq�.�F�xx��a��G�yS3q�A�RV�y[&����GI�sUgPHNR̼-O�w��5
d.LUW`َ2�w{0�p�[���d@�c1�Z]Y�: jֺ��d��s[�W��v��u���Տ%_�(../��F��u^���Z�H0�`�J���?��ǹ{xz}~wҿ=)f���-��j�����qy����2qa�z�"�8,��~z߉(5-+�U>�p�l�v�����/sa>>�$�����m��Ƨ}.���ް�P6� *qV�R9����?q)���I��9D���y�N<טּX��A�"j�VM�o��&��I;���ɆS/1��,E���&�U�߯Ҋ��7��j�k��7��r8$|*�Q�| �%O� r ��W� .�ʇ1�/n�2#�%�T����Ȓ���j$�e�۵]K�����-��Bz�������03�*Lo�\t���־f�XąEb�(Lwpb���i�]�U�Az�C.sl91��r�R.*w@�T��*��.$�K��Ű�h���t�Qd]nb�ݹ��@v(������H���|�L�{)=��)��4q!t�R�y�f�6_l6�NԺk��^!�iҎ�O4L�@��+�����T�R"yQ�Z�n��h-}G	V4uS�Z���B�L\�����r�z�uX���K�T���y�A����H�&p��0�;�>3/�>4&���ٸHK��y��
�0��U��o&��T�:uB������Z�AU,�z�N[3�ĥ����m�M���4x0���uG��J���]�Og�M)�c�Լ�>�vD���m��5�2f}�Z�i�r���c�&c���TGU��1]������f��I3�a�-h[�k&͟���(��^��T���@b��zg�"Oj�9���3���A&��צ:�"�}�ѩ�Ni�`əK��C��Ճ���;L]v�v�G"�|�X-��r�:��@�LG�bHK�[�'���K�5�f.%����IA�}��?)<~��ϲy��E\k�+k�#oO�1�k&n���V�o^�|�"oz�k�X=�nú��$��þY>�<|ù����ۏ�����k�5LWy�8A>�U�T,��
��~o��l��_.��j)��kӶ3�z�M�L�ԅ��Za�/������emk�+��l�.:���g[ąۚ��:T쾊z.�>��?�aKzGAx2;8���=��-,��ģ\ :fG�/.���pԚ�ڞ��_�p|�Ĺ�iW�TR���8��(�6 .���m� $�R�96;�yJy=���t^?u�A�Ѧ���ą�IaǬ"�5�@�ψke�x�Iy�v{
)�C-�P�L�����>Gș��t�"֑i���M3�R��8�_��b�M����>G�����h~���ߠ���� �Rt3�+M����r�KY}�>�q�_.�?J~��a9��8�B!k&�h@\X�)���þd���e(3�4��4>�J�D��y�j&�p�\h<����Zҩ�0dO�����Y`�u/l�ċnVt�ONk,�/b(���{]_�����(�tV�&֚��ku ��7�!��h�j}Rv.���Ѱ2\�$M�ħą٫7iIč�Cs��P�e��u��Fж�������Z3M +R���%�v�ء��'dkyGy�se5�+^�wrj��-�b)x%wC���;�ww��e`V�V}q�ĥvd�QI"H_�y�:+�f&�DD\X�0��|݆Ź=f\W9�p.�$�P�j&��C\X~��TY�t]�o����cm$}��L�z*�V�����0����9dQ��6����rf4�ɚ��3�~�8;�3�5���j��rkh~�7A��cg�����7A���c0<B8�'.��I��<��~���m���ą�Q�a����pZ�C�6��!�v)R��W�6�㿃�*W�M-<??���:�GP��Ҕy@la2�t�������y����>&-�.,5~���s3ֵ٧��x.q�4~�	����H��3.S	I���X$�5��)M�b�K�Li���dҿo_q���
y�:U��d�~�V�DҹT'&7k��z�dPAh�����K������o��EJ�֤�Zr&�Ϭ�x�qa�V�t��p�rh0U�{������K�B\�ʡRc�,�&�"T�Y�|��:,M|�ԅ'��L��4x���3Aв�Y��5��2��)H��r��q)-����k�nl]��ť�W��s���c�m��o�[�<>hU3q�D�µ�$�1�[ϯ�f7�ey��eVԄp�-�
J�uB��O� .,QC�����ʆ��w�bᏂԃ=	 9+Hz"��gC����Pv)D���[)�(w)����\���鈢v����=�Aٚ�o���o���;��<T��!f:���S7����i;e.��S��>t����84*ՊΔ�E
Wd���(�cfvkJ)M�񞻔��Sn�Y\�>�D��P��n1HCL��m�̅�$ ����/����®�#A�vV'�f�4��ԅ_Ө����������_�$�a0&�Cj���HWM<Ƅ��9�d/�N�Hҥ�
��Kn�%�Wǘ�Bqa)J��}�UϜ"Kq��3�YY3Mp�R��ٱ�9��9�=ٵ���8���M��ԅe>YaO�QZ�X��4ࡄX
p��(�U3q_E�R,��6~|���_�~?�����5��Ҷ�i��J���e&>�".#��Wz���5��8>�Hȅ�����_�&���H�̩����(�2�H`����qj������\*s)c$��!p�zgE�=�֦�y����zqa��0�y�p���S�/?����k��My�J�12p�#åОMM�	M\8���HI.t�W�z~!q��#�N?.>m!Z�y8�L��dɮd�J��;�eF��L�<��[�Ý����z�X�����adg?�MW_l�$c��;H-KM<������E|�(��,�[,���a!E�0��)ސQI�i"�N]��bnmd�1�dOqԚN��X8�Cl�K�^����h��pX���$�w��znd�����]�ļ�܅���`1mz��pc��K�0%W��CLu�ԅE2An�J�;Q]��8�������v5Z�h��d�W>,`:ດF�j�ID�٥\d�j�;��F��jBV�-�/�]��4Q�M]����0�Ʋ��F��o�VhZ�5���z�&Ґ�����q���+�P5�:�a�p�/���m���O�o�1�C�A;�b���LQ!w�h��̎����p�cJ���bԧB}8�;�[�j&.
�\�%vR��H�ŉbf`f�k̳ !��~Zf�v`��1��	�:jR�/f<�.D *j��(�����Bi���8<~��QZ�m53��(�E���>�HN��%�Z�b�KG��\8BF�e�l?n��=�FIcD$9��&Rl%�/���N���j&(L\8�+\"���D��kİe����#�<��#�"t�5t�fk&�#��pQ'5K�����u���vӇ@d�9��t��L�<��s`t �wk��{h����[�^m��aغ��H?�&G@\����Y��_���Q��ӧ��f��˦�3d8oV������Y�C��i_��!��3�)�&�D�\�:�$�1�@���暏�@����ZY3q�g��    n�vz�B1�'�����,�>�	�"D���������)�M*�Z�Àq��T܈1M��S���bqJ�3����������������o�	4<M�Z����%���9�j&�d.�k	�$Q��n�d��d3�:k�U=����M<�����NT�<���f����h1f����[������[h��1�Qq)�Qdgv�;��=�1�z-�(��<�4N��&�C_!.l!Č�O�CV�盍���+,�ƈ2#E҈R��ʠ��KG��&��I\��e���p�> ���i�a_��]kݥ�c�`_�.��K�2�����~���z��>\u2-�\$����f�K�1&�L�����FR%�(p�B������D�q��,�:�*���������8�Rd�clP�K1Vw��'EI��Ȍi��I]�����-D�6�%�������v�m�m�0G-�f&�D���a�\�K�Xx�R.\m��~�]->�ħ�v/h	��k܌%���L2x�����]�~��9$�a��ڡ�ւ$��/~�����S����O�}q1Xi�a���K�ʚi�:�����`�w8Bb����>E�;��6� �]�S�u�z�RG�ky~zv����v>��UFvcL���i;+r�
b����.e'ބ!���]��|�o�8��̙����� ��Q`N����_�b1�m���|X1�8qa�!G�/�Q� ��p��ݥs�v>ʪ�왊�o�'l#ߴCM�,��el��4mfD��i}��NWM��qaE�:���~�jn���/�" ��78T�����&*Y��O�lGH�5�Cgi2�ޒu���D���-G����'s)�e��?�n�,�œI�D!���e
�.ML�����R��0yy��i�� MO��L�f����J�%&.�ih�:���E�)��I]W�6��6�d��U�2�W��u{����.�&G���P\zA�a_���K/ua/=cTw�q���y�u5<�87=�kM�2MMT�ԅ�(3*b��>��Ū�p�(�'�VV�&p`��D��4M�R� �p��8�3=]��z���
��f���F�/p�=�Mc%l/����um׉��LL�:bgn��4�ᬛ{�s��&C��������`Wg���X2��C�Vg`#5�㖘cͯ�x:=��O�ݎiq�^��R�;e<%&��FQ� ���jL�	 ����W��J��4u������:1�_J���^��q?�L|�����"�M_����~	����nx|5��Sh< GJ,��|ą}|k1\��(l)���Wu�[3Ռ䏹91s!�B��Y)r�cP�n�o���t���t�Ʋ�Hu�_�!.lM.R&	���(��Pٹ9�F(�b�X�"�hP���p6ؚ���2��bO}uɠ!��8��D���|��W�GB.I�s�-�m�3�Z��
W��*\ޅI:c��
{�<R�9���������v���q|�,�7d,}i>�^�����/_�;~���[� ��K<�k|��/qb�/q�2�95 ����8߰�����������V�����Ӭi2`���f�����~�~|�_�y~�|�?��n8�P:C�YLW���^n�,o�]�_O�$���P�n�ŻP�(���a�,
w@Z}�,.������ʢdgZ.����3�G�b���/�l�Xk���A�B����QO`�dZS��5>��H-\�B=
j����~{	�E�?����m�~��F���u�_�ܐh���W��p�,�OOq�a}1�!i�|�j��><V��x���:�j�	-�ԅ�X'����i�����~et����6<���U9xl$qa�����D_HR�7���J�Qy�{�%lq����fb
ܹW�� c���<��#�=�^�e�'8AJ�6[���,s��2����o?,��I�.���`��Z���������q�%�R�ނCt�>�8/��IzİX%���.�4!���0ǀ��Ŝr�fq;�c_��L'e��4�_�
1�A0C�g��x��.ޒ�N�[zv���q��8�����`��4Si�X�¯�s.Y-�{���������{f�gH�o��Ǘ�6�LO-O~�PًuP 5_$.�o��nϓ�ML	���J\�O�0e�4 q���m��X��fi��5K�H�ث�:".eZj���A��`9��L��ԅ�K�%�n��_��x�h�J�AtZH�v�J&.,*Yv�(�S�մ�y��h�\��L�j2n5X������	"M�f������5���%2���L	�^�	G+�|t�z;m��ā�!5K���2�RG�Me$b�[�|6/3񛊸��
ճ�Me襓6�C�	7�,�4ٳ>���m�L����.���0�Y�ZiTW5I�vA\8ښ��j����P�\H�1N�5WI�\�֐�2^X��b�_/�c�&7�0|�љul�1M�M�۳�z�-V��iY2�)�a� �Ȭ�����5m3�m�pFPl�^㨗�����C,�:l��o01��/q`ߞ�CJ�����zq	��I���ge���86������#/�'B ��v�E��R�  ��1��f�Y��bտ_Fu�&������c��0fV�kS���T��ҥ|���D���S���HԆ{Xn�E*TY��!�@�_��j��L.+sa��H+�1��k�W�:�=}~�kxzT�"5�om۶U�g%.�6pa�܀t�/f�vhk�� �
�����x�q�:�:�p�@�d^vT#�(p#5#�e�4Q�N]���47be�j��ٮB�/{[�^�PC�7\t�`n��K�.<�۳@�ԞvU
xO���Vx�VMȟԥ�>��A���~�|����8Ix��lW}nV��B�d^�#&����Y���	;�ܐ!'C�JY*-S�x�-qa�ޫ�Ɇ���y��΀�D�K��Z2L���\��U9m��Uġd#����Xb ��!hHlt�LUX��z0��D-2w��unpُϏ���1N��Q�.��ah���&�(��%��v��p�C\~x��4`g�R�C �Ĥc�0q|�x�?�f�+��xr]e�FC��;-�at��ar3��B�р �/7'y'%S�H&8F:+��m�&>8&.lp,ǩ]�>�Cb)7��~�0��^���L<c���bXZ���1 ߅� �[|�*� \0R��J���\3.z�g~��V�f���ai�8ѷVQmZUXC�n�������b�!��f��.N��;���x�bٲy�AL|�A\�,��a��~�C���X�u	�'*����x_3�%�:�=7�W}��%�ؤ��0��Tڳ`xِ�Kl�B�L\D��p/����=�e�fP����?:�D@��'�[���~R���UXĴ�|���!��5��a�R2U��u�K� �:Lt@O��Xo����Cw���!�J�b�z�R� �Wf�$^�4�8qe_������y=~���ܠ,z��5��sL�~Uw^�L*6��p���6=�ק���sd��24�X�DM�h�� �������x`6q�~طҜ?�uw��_�$����rv%�k�dl:��V�&�î� ċ�����������/Κ7�w�ib_L�W l�ζ����Ru�R�(�+Ì�V�I|�@���hQ��򄈘����0�adc�̧]�O~�'~�$�ո�-e�!4^�r�e�ڼ�ML�d�����>Y,��)�w��Y[,I@���`L�-��0����$KGrL;$ZhH���%���3�˴��\��o.����ٶrf����ݶ����Wzva?6��?�ؠ�����4i)hИ���p^!�E�L<ꑸ��Gu�݇�D�.Ѽ�^�����}�,w��~T2��sն���Rk��d�i�ږ��pR/W<͂H�B��N���f�	 ą��r�" ¯�{�G(���
q�p~X�U�¯)����M�t��)Y{�HDC)8t�g�L�K�\��
    7Ψ�{ރC��$��e��>�j/0k�޴p~i]3q�̅�0����o�c�o�#�(��VhӶ6I��B�®�U���
�o!=!�]g�8<�if&�&���4����|����Z�d�C#��U�,|7�@��p��Y�Zx(i��BI��by^�r>>���8���~>?���?i��)��xT��Ƥ[�1M�Ra��dg6�<����8������嚂�/��)�1q��̅<BT�����^��F!�cs9�Z��p#٣U)u0��
dE+g8.�0G$�\�*,+�]���;"6-�S�2��A2��|���KW\�\8u=_�t�����|��7Ӗj=�(�`��A؜�7+Mt4wᠣ��YrP^�W�}h���bDg�z��d3��M�@?�]�ĥ̙˸�d���GN"���a�Y:�7����j�h3F�T��4��R���t�m"�靛^M��.}ߙ�f�J`��LWd2$[	���c�A�L�VYW3�qac��5	���=�@7Q��b~��@�ڄG�|X�f���5�P9u�ʂJ�W�r{�dh��x��mK��i4���y�M���צ$y})#)���{��!SU������Aq�b��Ђ��x9�ߎ�o����
s_�><}9>����I�8/p��ʤp��������2�w��E��u�H�B��jL��(��2BI<m )�$bU������CF5�tU�#<�<&3�>g�U|D�8p�����������r�j&�
RRf�Ჳ�u2j�x,y���*�3&��#.��9�S1���+$Ǭ�2�W����Z8�R@Y���@^��D[51��܅�o�;�n����]�3�!\��/�R̼�AC5��'.\e��� ��������~���a�������31M��.�.�=�7\�3F����� ��rWL��M��rny���rY���<�4�G��6`ѝIE���̥쮠`�������z1؃/�<�A��6y��
R�g-)��LM�ԅm��N�:X��I�CA��Ǫ�6֩�L
vLGBA,:@Hө���H�#q��7���i������\�>?}in�O_���rj�Df�ؗ �R��ؽ�#��[�,!4�h}�4��.�G"_��Xl��!q����[F���}Za3����O���YA�����A����i� ���Y7L-��q�����[���^�`S�G8X荝�:a��gL\萹p������o��f���L�;̫��6(��C�G:����} ��%�۪ib�.'Vvz�  7�@+X����H�� sVxOk�æYAБ����f��̅�dI����KT���`�70))�X0�Pn��O�I=��*��ϰ�տCo��#���Q�� �B1��%� ES���1sa8t8�-Q�Y�+����r)8�+�Rq���fb�(�.|Wi�5���]Z��B!T��BH�idZ���< ö��Դ3'�O�#�ĕ�2��� ���z7�]󡿆}��xl�5��<	�U�=�� )�#��y��,m*Ř�-s��5��˲��2C#�GA����5H3R�*�f>�a]K[��ii���H������wj�m��ȧ#A,Dٵ5�ܲ �' �b7�-�A�EeTb��G�OG˕&vL\�ʨę��7��v;*}Z�)x�l{1 ���{���5Wi�\�J�pҚ�&=�
9
e��~:��1����L��q)CX��t�G�f��.>^���x��J�������3��Ч��6|��#+F���s�Nc��琰L7�L�0��R�_'��In���XT=��w�=]a�K��8dJ�hC��qP��Uù�]ʪF���I|�ݯ�(�T.<�^"pG��'��I�
���^�.\��3��rai����.����f#��SR�Z�R��ğ�ą=(��>��~9�u*Sˈ�"6F�Z���̘�0s�n@��~���ԛ�C"�b.ɜ*�A�L!���8X�9E?T����.�ő8ii��'�M"�EJ_��p�ǚ�V��وqD.��*�ؠ��
(7��DUn�� R��3��`����}���C�c�$���\����h�3kf����9�f ~ͱf�)d�aas�r�[���M��4�2 㦭x@Z���Ѵ ���^�����%�ۈH�R�U1fW�4��5O�$.����Y�}yg6��H���A��s��GIQ��琶δp䥗&������@̄�P��ؒ������Q\��@��p޸������W|�W��zĮ��<ݷ�ksy�I���ӟo�ujB��L��O;jX)�2uӤ�٥��F����eҲ�����뵃�˚�/D�r5-DN�{�&U��9��hƫ�2��2&�f��p�k������6�Q�����iXE�*�픬�� s�hXJ�#����i{J2,We���g���\�ĭ*saV�p����t:��a7�ñ�~�����3�n���š�m���J���bk��AF�*ϘAy&d�a�ˎ��4J0fֶմ5���\ʽ�X�8i�PyE���N�K�U8�?�Dki���p1>���1�I� �	T���(����M��a-15M�S����������$Ҷ��Q��#m�P ��L\`��0)[��{&E,V�
��r|�gb���y�Ϻ��L��Hs&\��K�m/q�J����UV�M�]�̰�2AK<�eJ$U&�l{��_��h���V�޵�?�9�I� �ϦI|�مm�����{aS&��D#W��*c�X��K�u屇/;�#!�xl^���=A���C������K���~Ŏ]��������р���\=�3�/�|A��!.����uW�9 �����2��u��nGL��$.,S{Zg�}�4�ߍݖ�	sj�F�VZ[(">�C�`�um�ήaL\ė�p��"��Pu�P
�M��J!��G!�����B���Q�E���P��
�%m���ωK@��0����~�tN��sg8�괴3L�20�2��Z[i�[XąS$C�D�Φ��J&,b->K�*�M<���0Ub�FS��X%��.�~�K묧Z�>�ot��]ٰ���i��;A���f���Nh�<���c�\��k���/M|ŝ��w��	�{��FZ��C���v��o�:��s��6��kô]�gg�Me�K�S�n����QI���	��e�^BĬ/�m��ȇ��*^��YA@JM�ԅ' eę}'�*�
b"]�/�A�9��I�os<+�k���)�4q�@�R>q��U��{��E��ܞ��;�W��!KU��)J��\8�����w��v]YB�5"E���o���E���1��"qa�E��H��\[�?w��� uY�/��@i:��l��͌���I;�SK���{���q�x��K��"��Ǔ%Υ���L�<D�DZ�����q�R���;��_ {	t�w��iZ�$a ��L���V��z��O���-���&�Ym�����o�xH���kRlCib��܅;�;�q��e��c==�p��ۏ�ǰģDJ
�dLx$wa�aa�J�O?,N���2N�HJ����s�|\�ɸ���̅�FZ�m�C���E�h"�lز9[�aAENďU3qgX���fR�,��sw�q�C4� VI�OT\ $�׉T6��p�'�Q�,|��y�l=�S���|���ob�#<�=�!m�յY�*3M�S=�*�q�'G}	�T)��P�$c�ͬ�iYX��zp��ܨ�q��a��:���)��zi�mDO��sE7b�o��փl{���
�PI=(Q��0P�C켬�x-��ja��Q����� ������$H=X4��g��1ٮ��5���l�X�i��<~{l�����u����E���:78I��FP�x
qay((E�+TIK>�r&R��7�9Ꟙ&�m�W앶;W o�U�\���\�@v*�Ғ�Z�"�C�Ui�r�;o[+����U�<���    ��~<_�l=+Sz�����ǰ�+J�Gk�ߴי|��"��" �8��d�\ɝ���ƀ���(�P3���6�>�A��-�[�:S�k���@w�G�gM��%�Xy
�b�=�X\N�
*�1ف�O�ql�W���pA�(��8R�����r��@�C�O�C�Ja{	�)�X�&�J�_TR�U"���Q�:���(
kf��N���eg.(�I�R��Y�f��_����j�3BP&uG�4����f.�+ne�G�\��a�J���&������g��׊��&'�0ha��>k{��Wt�N��W�^M��u�3�7
��������G�I��3���]�u]�4��H]8=&�z \�$���P��V�h~0k�u9�����q�ި2fa.�FD�0�`�g�oV�5�|�����]�zOPG���ծK�3&�u�u��p�p�u?H!�L�/?���& �:E#
�
;�'T}��"��˅3��ɡd�>�.����3�ӧ�#
m��8SƑq�i"�H]��c�&��x�����N�OT5Qa�G��4B�L��ԥ|tdB���cf����bD~n��1ZM;=�ƹ�wfK�b�;=ĥ\�	�e��oo�a�קL��������x~|�C�%�Ѷ�E�E���t���]ΙK�ZʔW�羾8��j����  KLO�r��Ė�	�:۶5��\ʐ�C�C�t���X>�6����'�&�8z���5W��\���՘!��Bq7=vƱ]
��s{:�Ȉ��s
�*���Z>�ėe��9���/�����^o�}:��7޿<|�𤵐G�n�>!���(u�/#9�o�X;�/�x�E�L�X��\b�zo+�r�z�y f��s�Y����K�"HàSlR�l?W3�"ąC�B��R%-}<��0��ڮN�L\���p�w8�@�b��{�u\f�����d�_�uN�]��ċ�V�Lz���h���U���$�����Ye�h�Be�B�	��"���d.�L���6Z��v\1SZ,�Z��4E�孡�h��E[3��!��v���w\ |���V С��f�����L\ s�
 R:ڴ�:���ſ�k��G�@�H��ޓN��m���"qa���5nzDZ�����Ƴ��!��[���p�f�HUS��M�����>P�p���V�Y�j�8��dc�zi��K��SBixϴ��N�c	u�(���q�U8P{X�&t�R^��Ү���C�H�t�AtE7�r@���sQ���j;_5q�d�R^�8Υ"�aP^�&���dZkH*��9��\6��xF)q�^�(��/ 
���X�G�� �JUЙ
�uQ	Ĩtjdi��Υ.l�:E>'�1/��5~�>;��Ɣ��'Z��cj��`L<خ�nŉ���I�ܕ�mWP�ܘ�U�����z�_︺�����B�ﯺP+����&uaᗙz��4�y�vsW,����2�%9�J�nI\��깉�W�9�ӻ��a�W��D�j5p�!?\nN��ؚif��0epT����N'[�v�(D��C�oMWΣMM|DL\��Pj7d���b��"�qi���Z��Q�ok�גz���s���ӏ������,�����9M���i�����\k$��o� ��N���������ϐb�KL��%.��5f�l��|�@�	�6��%��Lp}v�f�٢ą���v�d� �8[�ۏ�&�m�v��83��\�˄����H��&f�t��*z�}7�<ʾ�t�\�5 !���%M����2N8AZ�I��^�xˣ�=���|�t��A��Μ���j&�:���L�N(k8�ßC�cu�84����u��L�B��P���ۅ���?�>4ߎoMt�~���ӗ���i[�g����fZf����7��KYٰ8��&���i_�6�<'[��q�����K�m\2s�xO�+�ABEEN���-n5R{s^�O~�R,`K����9�k&�(����`v����}�GxߦQ�aJ��=��L�.'�d�	�}��#�[��|�/?AB�ʩ��1��Yl[?mP]�Q����&��ԅ?m��F�tr@R�΢a2d*۪�+Ed.L)�j4�v��b����ςd\��
��A�cDD!�#'-�Z$.S�?Z�����^��O�MM4,L��Cv]:5�1M0WR���踇ۻ~�7�M�~9��]���E]�����N�@L|+��pE]�6JJ%�^� �8,�X)9�SH�O�Gpk��sgQ3+MT2sa`�������(�֑�pȀ\�N�fL��Q��hA���|!r�T:2Š8�a�SW�0U�̃S�G�u���������`�����Ec'Ώ�o���	A�11N�R>8�y8�+���. �L��1�&aQ���b�qM�k#Ӭx�����Ho���ő�@#f�cR5M�oN.��Ć��O��#�)M�1����M��L<����b6���x����[����vu�m�����_1�q1���<�,Z�E�
)^�.�ж�W�L�$9���0d7ЃT�R�uwWݫ�f@�>��1I'4����r�|�����ϧ���O�S5����΀�Ӈ�_������Uœ��f���?�LW�b�Ā/v��0ͤb�?�n��Ƌ_�_���+�&OI�����ҟU�H�&��I\z�b�Z�踁��zxs� AN�0�f���:�ź�v�	�2��}��m�s��5dp�q3�D���ib
�p���|�g��D�x�[5���n�l�O�U*��q���C�����4�Ɂ]xN��Os;\-6\���lY�:�}��g9؃[$pŃ�h*�M�g�*���ep�A��W>S�k&.C\�1��O8k�!�rw�n��������w��~Y2��O���9�c������ď�v6G�T󳫕�uE���_͗��������#ŀR�Yh�#�"R����p-��k}�/���oe38�l���S��aƢ"!C���p'�1q�h����^$�]|�� �|&:8��\���&��S<���7��LK����v��R�� z	jj�:t�|�F����emkT����t\�IxIt K�����G
�/O��7���_����������[,$u-D���3���`!��	�³�8<M�w����#)-�V��&�������a~u�(5��������@�eh ]�w1#�L���@��i�IM������Օ �6��
��c6Q���-vNF$�1��@0�)��mU[�p�	���Z���p%�9Ϛ�){f��PF<(+��І�GؙVTM�AI\؃Rk�5���?Cs5_}�3Bq*g�y�3vY}:$4)-�&~.��p�O��ܵX���@���@��g�^�,��L\��p(0��Nyw�� Ϋ��6��br.H������p��ĭ3s�x�|��^���57�%�T �"n5"0N����c�L���_����f��y� ���������p{���NqU`���a���X�L�>qa��MG�O2x �J�W�S8��o�k�f�L�����`t�t>_�gg��=�̅y������7�e~�0p��  �gg�U�&0�>G�k���=��jU��%ԃ����+2���v�ήd~
�ł�S�rh�xR�*M|����L-����1���v�>���ʟ&i��gi�
3�� v�g�N��j��ą��\-�'�����9�RT�9@�@��GL<>����<=jjD^�w�E��b�zEʁ��FK8� �j+��{��@%z�o����6���T�ys��9����������yx(��q�5�8�ࣘ�#��G>�&cO�iʇ]��6�%%��r�1��i��b��.��i�i���PD�8�T2���:��NQ�>���%�Hy�v����8T�dL|�C\�J;���t/o��Q뙈 %惦Nj<>\��C?saz&�_c���n�{��T!�mf��m��Ad���SK�;
cL|ݗ��úr�8|7�C_,�0��
l4� �IT_?����k����
���H�����v͈k��    ��b�v�Մ��4M̸`�e�����6�j1¾zI˨ۥ����AL|���p�>
G��f�F����	o��-��ku=��{f���#��o��-�	�&�v��o����	ؔ7���4q<s�j��Fͩ�4g	>Ut��i����j��kŀp���?�����r@���dP��[KO�	 р$r�w�ʷ�Jng����5�!.l�T)�sVĢhʡ�8.�am�I�� -�1����3���³n����K#�<�>=F��Z�(A ��O�m�4`~���/���}�G��\�l�X��f�����?w)�h+z��˯o���o�_�����?�ͯ�믇�����q�t�J�b2�}D��L 13q�C�R���(Z��j_�2�q�����7���7�y|XL��/�����uo,�.M\��0O8h1�W�ay�h	��w�X	1M�`�hG
���mhM��Q�0ѮfR�Egj�J�ԣ\
�w
��w]m�"�,�P�Բ��x 7q��-�i�$c#a���(��/"W E�]`��v�`���i5�n�L�n���r}�$m��C��s�A�hZ�� 75��䠠yB��yЁ��������kbN��!�	�ԟ"ws��n�Z84k&~��C�	�}�?�����0���]�>$�.�rX�Wt�)���'�+��/=�v\l2�))x�{y�M��JZ��%���DA&N,w��0 �7h����[T��F�$����p"�1=z�]G5Y�V�t����pUm�Q����h�씢i��TD�[�f��[a6;���8Fs���k�������&��U���R;�-!��¯{��S:Q,�[\m��#�0ETV��W��God�4���]x��zio����8iKd�s���
` M@�h�i��]8�Y�U��>l�3@}>�H��q��N�,� m�Q@��y�IL�M�6���; q�X4�[�����O3=�&~aą]��S�v=��A��m�����l���(�c��
m��;Ƙ����&XV�K��Y��C�n~���\-ֱp$-Θ)P�x�w� �e��	y�#�֦�z9l��Q��T�-<5����B�͚���׳��T�N�' �9��t5����]��Q��IǓ���B]��xݓ&1J�X|`P5�uQ�RįP�Z�i��z����I�]���c|��� ޛֺ�u5�if.�A�t��|?\��]���[��@4�7	�1n��y�x+u��o�f���a�Į�����a��b�}���ow?�����'�X>��b-���8���� ąE���	-�E5����d�D	u�iU���1�K$.�%b�wA�Ʈ�c'E�~�
뺚i�L�pk�G���������y���4S�������<E�Y��.)�6���D��s�F$XT⢢�Ă���1���(WWn���c���M�ưa�ʫ�C-p	����4=Rpt�����*o���̗` ���M�o�o���&��B\ئ�A��H�ݽ{8%)�Y�f%d��&QXx�+��L��x:�����63{l�Ph�R�}mn6�P�i3�-�?�Ġ���ӭ��A���x��\��]1��M^؅��u�����k���G<�!ψ�J��}�ۚ|0��&�؅q�N갅���$���S��T�X3����:�%�L�4Ā]xb���8o5�X��!���
�ɬ� �h�'b�e���<��G�I�i�a���o�˓�[M/O�Y�V�k�&nWe.L �&���h����b�4�B|��[�e|ę�CGd.̤�_`Kg8���o���������
�\� �A�L�y����E�1�I=,��b�A����JwЖ��&Zh؅A�A�r���Y��v4�ɩTlm�~���&*�؅�R��,����� �FGRI�[s����o������â�/�sK}��������"K�KPHvUO�C\X�-,��'���r��Unj[��O��5?�M\ةm��^�7��	��o��g��(�����$�G��&8���ρnW��IX$
�rmJ��x�=B��ެ�m��G`��=X�����g����ѶHh���2#P�M�@"q�J�=t���t�y�Y����=[A���chtd��4MtM�۳��~�lw�aǦ#���C@�#=!PeL<�"qa����OU��#�0f.iכ�T"2��V�u5�$������%��?W�L`�K�_��rAqz�S%��5����.��5)i�0�g�!�?:3���ɵѷ.M�؅[W� �;vu����<Ңݨ�U}w�H(Ƙ��6s)!o�L�8�{����� ��h���}�#�}OJ�������ŃDѤ�h���z���K����DB愹���ǧ����{����������t�5/ _�[��l���[�6�iLZ�͵ҢdTF�V�U��#v)�* ���$Y>�.QZj�}�\���J�:Z6(Qt}Gʦ�i��]x>sbX��v~����!/ l�H�V5t�L¤�ӂ@.J���.垊z��m�����<B�f:�}�J����	�:mj���<ʕC�ў ����.������?	�K��YJ���L��F�n�ķ׈K��X�9퉺a���-y��O������maL���s�ī�.e�ޅ'tP�q�9�G���":ॉ�\8L����W[����ۄ���	ꈉ'�#.�b���E�
2�Jk0�c��¡X���O�7����XG`%��5W�\��b[u�j0:��w�A4Zi�(��+�f.�ӈ>ų����??���� ��?�?n;�����@�7T�?�T�|��,��,�u}
�](I�UM|	���Pҥ���\�b��R*�P���n�/*��'JW��\�(x�2͟�[<��U��k�We�nf�_��<?����v������	���"e	8a���H�����i"K�.|� S���by~��7����!I�\���b���['S�5##2(�]K�|�=�i�9�%]���?L���fH�1M�_�χ�X��5�0&��G��W��"N��Uq��8+C��|�|���I�M�%qS���mi�Tԃ�R�����O1��I�*��P�� �o[�#u��]��K�*��j� �?<�4_��&i+�D����x�����$��I�?�H�8��w��3���̷ioX�U+��n�O��)!k&>G!.�Za��Ȯ�n���,�>�ik�A}Ew>-w�w5wZg."�@�)ۿ׋��:@�a�)��j�� ,.��j&��\��NH�S��rv��\$�`%��
��*�qe�����d�D��\��Ao)e�Y�N*b����U�.Pf�Y�]]3�2������6ϻ�	K�����O-����XU3��qa�!FI����!�����Ϩ���8Y3���}5�#�i���*G����@�hH�du������K2`�/�>��]۳DG��s�����/������1��t������gUS3q�K��ł�ޖtE�7)�F�?-�ڎ̡��߯f�B�Y��Zqa��j��n�e?���"��5�W/I�U��y!���"���9���XdN~#]l��;&OXŁ�\C�kf��Y�43M@���V)ţT_�Y��!���X���UvUV&��4M�ԃ����+�� �NGf]�O�ܢ$�O�9"u��뢙p��d���K����;�p��j�؞������E}�)���J�r�y��O|�)ŀ��&���.u!��3�{�)M�.�\�S��:B���&�V���A1�T������X�\��!=c���.<��H�-��W�>zp ]�@-�@�I�����9M��Q=��5�5佻��z"{��b�
� �R}�Y�J�]v��
:I���R�P���r��.s���a��}��`u��H��� �u�4��.<��R(`��!;��XE�&���,,R�z0@E��h�q@�Q����    pQ@��rkN_�����>ǧ�O%.,���t��z�~Ꮲ�H���dM�E�k5���$��$��B�`ǧ��J�	D�����^b�ąE�6���É4G�n��AT̵��X���/san>��B��n�\o�NUfba|��C @�����6����Ku�a���o>]��rSZ���1��b)�ޔ&��L\��O�đ�2�����y�;��9��i@] Q����)��uzZPt�m( vr�SV5��-����Bf/엗�����U&t����e���<�B��0q�C�����T�t��#�RU���3s�RN�'��K 9�����ϔf��5�]�Ȼ����ą�u��T6�OW4���3���^��X�z�`�����1
�k�}eM
t���!�-Mܪ2nYR�4��l�q��e
��@��d�\���3���(�w����>�?K��$q3e\ia��gw�򅚉��3�t��x^�^7�/%���[�5�����O��:��J�9Q����f�|�I����������>����A=�������{�
�������0! h�/J��Ę&��؅���u=�Ѥ+Mծ4�����QU_h&.l�Y��34�86�y	HA��&�̩��V�R>/!:+������T�*��"T�����M�ģg�s�H FTc��4����t�U?1Q7qj}dGh㏾�=���Ço{&<=���X�j~��w3�1��k�)5�&�P�*ﮫ��, w��z8�b��t1�߳[-�����b��*�٬�XtN�79m-ԋ�p�)�ۊ����z�d����0�_G5�7'��H��䗼�
���"F@�of�%dI��i��.���GJ�o��q�ǲ�c4k	;3Ί��L܃�\�'��N;f�9oغ;V���#ς�b��]�ԃÑ�E%n��������"��=rcTи4�qa#6q�t����Q5ڋ�_� w(��u��}#�����Y�ؽ�W��KH��7�ERE�i
�Ļ�.��u��Y�*<Ðc����Kʴ�)4��Y����z`(�]Ҳf�������	
��wt��T�6 e�zw34(�3&PH\�$Ĕ	>|=_�W��Y�d�
�(���ڸAn�le.eeI��J�4G"���a�q���"��e��k����R��)j��5؃�����NB��O��뒡�7S��!���a~i�J�,A�I�+5�E϶Rp��� :�k&FK>w�Z-ҺQg4Z�R��E3�Tgt��шDS���m����Z|X��W1�1�GYhU�`)u�_k&K\���Q�V�c_����3)�>�����NW,|�{0��𞩦�p��̛�X�I#��owg�7K��CcFP2*�c!�1�O`}Z#k&�V���K�|��5;��Q��M�EX���$2��ku�ğ�ą�϶}6�=,���}��~Ÿp4���F ��3���rvib��܅����"�7��z;��"���u�I"`$ff�Qb���g�!.��:��aװ����Y��w�{�w����Oڮ�3H�߃�o������5'T<���u�����or�5Gg$���C��aB�~�>6M43��(���Ի��8R� � �4�妚e�&�<�a ���I\�.&B��Tے��4q�r��L&�A�Z�����|��?�7?���w�ͫ����'�㜂��E���d��KLS��RqaK}�%�\��%Y���Xle��D'��u�s��L�Q؅g��k�$-c&��X���s� ��49vras;h�f�
Tc�j�ꁖ��.���b.O�KL2?�^������� LBy��S�������t��Kv6����yM��̶��
�v���g�7����s$w�:R�gNj섾[��p����%����*k&����0�T�V�}�{l�c3Q:SCq頖ہ��.�e�4��.<v���5��(B�Ƨ���QT��>z�>oV�53qݠ̥���VѴ�f�v���jW������>��C�pT�����'
Z�Di�4��;ą�\�M��rw�X݆����B��.�A �#�gi⮸̅�;�|��~��3�Q�S��ic�f>�10j@��b��؃�>����*章S��5�ig��l�irT��ΗÈåk�;�.��#���� ���A���l8ZT*�X�f�㏴�滚��e.(�q*\�N.��r��;�����W�f;�n#��+y	�����8��(Mܑ��py�O;������)Y³>�L`��U���:G�cD��lOX�JO�C\X^#T.!��Nm/*�,�%�k������g��ф���
:�����6��ֳFF(��HN�%�sʚ�'#.,y�Q��l�QR���us�w��E<�:�1�*�m+{g`L\="sa��
�@��p��/4`0��v�\�e>���  X�gJ����$&B\�KW)�8I��j�!�k
1�oچA7s>�m��}��q���j��K�0Z����֨�|�.|��Pn�<�66!��j����������l%]��d<��C3:�S�`���1�#@lJVS {�3��vm�4\�.<pq��<6�G؂�c�l���`��^�L�l!qagE&��7أG&���fw�\�*X�ҦPLh�lR�}���ą�3TO	��z/����+!ӽ��6�`��X��4�y��B�M��y��Z(P�>��	��+M\(��p��u���v~>�\�!����t�6M�l����k	±4q��̥\j+@j��� s��!�o��&,�w���LA(h�
+{+k&��G\�N,�d���GW0�A`�<���m�0t�n��EqBB��Fx0�����|����6�'X�"d�c%�zfR�;+���D��� �u�Ӭ��[��?��������ۯ���p��ؓ�=}�*��j&��}�ĭ5sa0ʌ�rw�w?~5��w���_w?���4_����ʁ�}��E�v� z��'����T|��KA�+P��t_��qY���?P�vx^L�G�c1>�	$�c��rkT>�hOk�-#���n�V;Sȟ?�G\Jz-��@����"eJ�χ@ ش��B��⡡���cС���!.��3PA��0f\�����&�3r�5�O��"�W6VA�^B�_�����L\̛�����<}��~���з>��|xy������yyzx�?�\f#��1Sx�K�DaG8i|��&�o���	�B��@)7_ݮ�9��Edr��e8lm�y{c�V�L\�;sa�� ���`/�π�u���P9��MP/���J���|�?|�{y�?��dMgI��r@�::Y�l �4��]0�ӌ[����8/���U~�GTfc.�A�G��o;gk&>Q$.L� &�,�#$,�#o3��+V�BS߇ڝѺ���Uf.�*}�AI� 4^��hl�e�e�C隉;-3�t�� ڭ���R./T��G���� &.�\�Om3����?rz�>�R�w��t�{�uΚ���xf.L��rTk|X^����Y.�L�N�~>k \C3
�/�&�^O\�1{��-4&0]3IZ�0�����I"��N�Q�>1����R�[���~ ���q�f��̅��Q@)� �77�v�XΗ�T�M_Y[ ��Th��6"c�
ąC�z�{]\$E� $ơ-��!�ļ�kk&.��\�����<���q�i����ה����cKR5��ca�&�K�6M�~���	w�[;�(7�F��]_�����5�R�[ZЖT��L�6*�\�U���������x-�	bpO�i��k;�5J�%.lS�8!���٥^�fq�~��w��p�]��n&��%�CA���[K�ķ���Z�|/$�YU�'�&� ��p�P���Z��U�zk��%�0� �$T8���t 
��N�L\���0b(�0q8C�I%��&\�� \� �OmW5� W��\���.�2�s�ߕ��\`5�i!x5d.L�OX��V
o�>\�����b   ��/C4�V�Ix<[k��4��$qa�I5B��J��e�(�2�W��1��I'��N8Ӫ�i�B�]X�ڐ>���f}��y3�^���-���q�ჴ�2M6����-.��&���\�/S��j�Q�u�Q��P�
�p�XG�%�)�=XJ!m��
P
����wy5����r�~���N!>�����(�4�1q�;�򯆳�rLV��4�����Tjf�>�ܤ.��Lk�o��ÁH��nd������3�Q�)M�qa�hD+3�Xd�J��<������|x�      �      x�̽�V[˶-X��B��l�Z�~�f�0^�#�7p�eeb��H4���o���7�J�e1�"{��$@,�2����� �I�#�+��C�d��I��Q-)U�('�hm�~�x��:m.����l6>����\M��͸s8<�?���Gss��k�[�����eK	�_	�J��p��_�sք`ں�����������^s�g�nnF7��Q�IǮz�T��|-e�9��l�x�}�EOkgml�x^|-EODmLl���Q���a�d�m��sX�^J	�/�<�ڈ��:(ߎ�q�"�)���Y�N��V���������0���|]�o���us;��n����_��M;N� �:��g���f�R �y��kkz�['�R,�a0�:�Y�-N��mn���s���R�gXi�C[�;k(�/D�Sbz:h�P/#�z�0�R�:���A�i�=x�������A��h	9t?�@#��#���?�@+_+�s��ҵ��zi��|�կR6D��z�v9�̒:�����-b/z�j+��0�_��3B{�jؼ64�B��˿�,ax-m/8�oC��_hl�~B(C TXC��i�@��]φH?N��-=ڌ��� ��o`�A�Ax��(`���bcOh����� ��U��ʷ\�1$!46Z}�p��f�lu���E��at6�,�>��&���d��eX�CXj���3�L=/���ذ�UT�o����+׋�*��*�|Ee���8�	�=\,}���)p����E+$X6*ed��V�n�]�:�����'0�=�ǧ�is9)�����f���?ů���	O[!WwA��¥G�ok��
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
�8_C�=$�
��~&b�	m�N6@K���20C#��0��[�X?X=�w~��Ű4ڱjҌ�0#&�q��ޕ���#���⾡k��`|�/�/P!	�31v����������\7��
RZ���X(?�'�~v}ۭ��p��~@�(_ 9�&���g�Q�>x~^��|�
� +	h�ǿ�5I�ۭ�U�巈��v>�/����V�r)1�2
N���M���Cĸ:E��[<E0�1�7�oF������̠�J?�ܠ-�ZD(�r`{���/�H��T��/��>}������$@��ԟ�� ��Q��(�Ƕ��hO�D�wqD���#U�W' �� �3c�Qs��V`��qU��>�����W�@ͨd˨'3����~C�ԕ+�+�OM}d��λ��i�jWt0m    ��XGpHRp&�3*͌6e�c�09��E���a��ً��iI��3�E 8�m�kk�(�.�qd��E�u>�:�R�O���L���$(��E����@H	��ed>���7��~a(���P.�� �\�g׏ilw�2�9���,5�T� ��F�1�h�5Xy�:����r������a� i��̻�^��+��{�(^T��8���pL�8�����N�7�MQ�|J�KS�ۃ�p
��f����I�˵��S�ӛ�ݸ�K�<V��m�}E��~�#�Z��W���1>�́6)���4y0b����Nd��P��Ηh� �x�pPp0��l�'�� |6ٖ�j�$#�r
�]��"���d�o�p2�Ғ����'C"�H���c��zEZh�B�i!��+�z����VT�3 �hq�o9"W�`�;�2�x��F��Y.���#*�aM���a�(j���*<@�'we���Q$��#RAm����3�榽�k�2sK�ɨ�2獵�Ej�����)�,�Lm�qJ8%��\������Ek�'�����>�����!oIo�me[Ƅ�#`|9�>+��wGc;�ͼ�*#(�2,T���.kM����-��m�"��)Nbƌ
-#D)��*c����jޜ�fY�<�5�g��W��|��������w�o��������#��L���}�)�7���5s��)�=$2�������U��/���1�4����gg����Ȋ�߰�D�6��}21F��%[�̊!\�Wo�2�@�L5`x{�U�T��A
���a���co��+�J���񠗙�����������x~_���bI��b�@�%<Rx�gK��S_vS:��e�P�a���pe�f����Вy=3y ���VoF��a��(
�u*�I9o���O1�e,e_�e��GoC,��I�*=��R�\Hֵx��q�,���٦h���ɍV��|˸�����u;S.��il���9$�x��@�!����9[>Lbu�m����=E'! �B�a�?�2j�2�T�O!꠩R�̲l��h��e,�'�[\�����O@Y�QeDi��ފ� �t����D����x�F�R�J���>*e^��ڜ�h'@;1p��R"�9�C��R�����a-E��e��|F�/U�x�"z�C�gtt8h� a���
L9�?��������,;9���Nې�4s�z{V�Q�	�!�&8K�bJ��rpF��凿R 8���"��*���_�B4� D�/�oy����(�E8Z@�_Ʒ���{!
p��_C���v'�H5ZP�Hi�Az���%����a�=Y�^����?��`������M���*^��d��C- ,����A�Pm5PP��}�i�vj�	<H��2ꉩN�'��������V|� �{'qМ�����W �o���c|s��o���9��ҷ@ّq���)�p�.�-Q��j9�����=���-�[�\\Α@�����*=�oW�5����w�	�ٝ_���:���]|��E/B�S��d��0��8�T^�iʑ��,��Ɂ�y,�3@S1�{T�)���y)F	𼔧mԅ2�f�*���zr�j� A���3ꄩ�{t7�.�FU�J�fj�� 2Fw0�$�P �?�5�!0`��#��g����ۡ��B�*xϘ�#S���\�+��V�1N�����P+�	Ǖ+�1�=�����mk%��[��4K�'���������b�cM�+k6�"͆H#fP���4�����U�䂅�3�O�_@,9?Y�f�(�9�\Ƽ'PL��P�Rer�D��
��âu��Ŕ�;��Uh��'k�s�n,�k
��`Q��ub�e�t�B�w��z(:](���8[D2�zJt�Ap�&A�w�7�Ǝ�
 �]��,
�^�D6��	ZSۘ��elbrI����h
펋��=|\T!&s�!V��Y���̊� F� E�����rIM-�Bڻ������\I4,���p>�uz�J���@8�R

2�{�(Z2���mACS�H�����1'��w�_bW�CN��W�L�{�2�n'�#� TPs��JEy�H���w��7��X���?�x<�;Z�s�T;sTN�)����"�	������y��|q�y�� h?O�ߐ-�yhjv7C�"s����B���A�+\�O�܇*���e���z+�@9�fꁒb+Hw�{ttβ�Q�l�9�Ѡ��+� �#������J�.�����'�:���F�����Zs#
�-c����y�y�y�y�y��y$�Q��Ё��*('Of���;J ���鴱G�`��ƆJ���9)�f*��4-���u�)�Um����:h��uvw�<3_���Ey �K韲К�N����ZZ�
mWH��JDE]��U�0KI�Φ'������R{F�3��A�Gr� At��!hy���P��Жd&J����Oɥ/R|���gW��Q�Eg�|V�q�cv9{�Ao}�w,������h��&�U�8ч�/y1�l�gV�v���/��S���ۿ����ɗ)
(�Ǐ�k�|���'C���7��9�ML;;f���?s%�c�y���N�i���@� ��C��8�f�}4�D�(��M0Sؖ����&q�~f� 3ePZ������
A�b�W{W0�a��`'�`�2cR��d�d�*+N�L���!��t�!Fbv�捋�e
���p(���&��!E@.ђaZ':��_,X�+�6f������n`����]���i��hK�D��O��{��ɬ�9�9jQ
V�$��i�Pt�l����A�`4��U�%k=@��:��<(�
���H������(�ܝ3����Q2���y�T�9^~�T:{:8'�>�����GR�^N�N��r5Zo�s�Mc.�.І�'|�P�is&����Pd�}0>L�}�aXk^�������)� Zγ�����f���a4,T�13�O�(�j}���z��3���A����OF�y����U�I�!����d����^|�~����L�1�������d"�A������	��ht\9�$_��g+�&�U�%�~��p�D��p����RT�	rYO'�e�7]}����^�6&(��)���j.�M���8��0cE	?��bn-agӧ8��J�\ħ �)=����,���C��Pr�:N!WN�G��~���0��Մ��:�DFVz�QCL6�Z"�X��f}�S�;G���yI��ߨ�B���ُm�6�qǴ2� ��]�������r�R��|��]
B	������(��9/ӏ���#��@�^��R�+@L�(��@v 2; %����w��h��Rʩ̆�؅����(a�E�����)Mg�r���.�	)������Lo����;�\�.n^��o=����Jc����3�q��u��������K�}���h�,m�D�~)���<L���٭�>��Y�(˂���u����$�F�qKF�o��[��.Xvu�U�l�6��a��P�����V��b���c�e�7�-��6/2�̂)�|�yp�2��Y��qe��	�����V�Be	�M����#�wYv�fT+,�{�_W8�5��7:8=-��l�� #�隖�6h0a��4	�b��JIw�a<N�0���2|�3@ �#7�����d���"PZ��gL�͟_ɺ#fLxf��1Q̠�Tp�U��b�K���=&��
y�?��-�u5���M[},�	톟����#�3&#���H)v�!LYW�lZ�䛌P{�L�,΄m�����U�h*��q�fh۲y�4��gq��2*w��]�l�Ln�E���tT�u��"��o0�Boy�H���rP\wPfP��e*��o�s$�4�[;����y<9�uYF��)��>���rq1�YjWx�o��dgz�3�������B(Q�d���y�+O��.��
¢�^@�ܕq�E+��-���J
B��i��l����X������/�д�ֱj�y+��r�L�X�����f    �(X��]X��7Y�"����VLo�)l�`�N#��e�}�'�u.�E�/ȓ�f���_���6�}�#�|+DR�,&Oѷ��e�;�c5L�(���}�,.8� 6��2�y�=+�	��0dPi����zë������{o���y�\�ً�?��f��f���&P\��{�`$���AOY��7#�(r�w��l
�p��V`�d��_-�><�����&�̡ݿ�+-rv�0�'���t+��Q��Q���@�/�&>$�,���z���hN�icd�l��Պ���|f����Oqܹ�<)*B|'yԼ�1����Q��{`F�����F�=d�~pJZ�����xЙ,�Om�Z��F����sB��t���TT>�4�B�ȳ����F�'��{��Ư{e0����aq�
Ղ�I��|����	.�Kq��y}p
�w>�1�T�O���4VO�滧�)D"��.i+Q���袼���q����nrC����b	Z�~�<Z.h�X����Ш)�q��$̝nKfT�������V ��8�B�&�=�����s�'1�)@� fUȎѩcXc]m�����.?�4f��'ǈ͍�]�sӟ�ٞ��2$�k�%��9F	Ͼ��"&�����F�":�^���Qߺ���a�1��=�k�@��U}D�}������rc&)��Kf��m�d8lT�~��a���(���XN�9ۆ����|�e���Ie�7�`H,U��-�UVM���V���S&��c]�÷��*TE�ٝ��9�bGx;P�OCn�.]Njiv���lw7f<�ݖҪ�71X؍M����&�r���2w�{k�H�n@jQd/}��&�:t��|f��*<d"BX��4*#DQY(�;<u�����(1�qTɉ?�5��Z� xJ��42�)zs�=�E�������n��d9�HW7�HU��h�冯����,�6*Z�����2�>dȜX����2��$�?�Ȼ�VBd�<��Oq	Z�|��hl-���z�o��L���j���nRgg��X��JZ�s�C�6�o��_2|����A%ӑ�,��K+��8uow�h��T��nD�$��d+{͐wQG_��������/��ޯ���c��>~��o�T,F��~:�^�A����ðF1�K��~ϠΈ�Iȟ_����� δ3HB�%�KV;n�v�Jo�ǣ���-  ��sFN�V`n��!9��~���"Orճ�Dx��7��^�?��B�peX]�
�XK��k5��Aɠ�\#��[Ţ�F���pA��/��i���U@�Eox	^�U��Z�/>}��Ϛ���ԭ`����QO�*�01$�r3�X/X4:��A?�G���)��ɿ����̚�V����c�z���-�U�~�"w���������d�M���	�L�U[����U�L��*z��W���[-KX$���R���<���:�BsY��F�%.gW�w_3��|%?~�8��5����o7�`��V��T~�x�4��8��$Q*Vȋ����?���6E���e1Y���ӝtHT;�|h:s�6�aK9zfH��sn1���4�q' \�S�N���)�4���:!ebIj�#ܸ�T�/^���zv�{��~���˩P+��	C��鮉�Q��=���C����G�"�~ ��
?/�ݨ쬈z�:Ol�
�C������k¸�� <w���5B%��V�j33�!�m��Q�0(�(�[�,�2#���SI�H����Pm�3޷�o�Q����������]�W���XYϷFI����)_s�$�>��Q�����_2e�N |f] �*/"�Q��*Hg�BB���G���@3��69�0�Fl-W�XK$�k�j�g ��d�n���÷ݚAW,���{� z�+I!Ԝ"h�������:�������]771b����#6��m��[��(F�ъ���p��5�>����,��#�Β���`j���^	1E�.�wV����	����7åCBL���Ӵ�q*+[^����o'��=�k�*!'�*:=;�

�p��KS#]�M7g�:݃@-F�zU ���7�T��S)�
G	�� -X��	�ｮ�PT�]4�����۟ �s�ǺU�ް�jI���C=X�ˬ
Tm��J��__����A�������q�n��bjJ�i-DU��v4�U�T��~	�@7�x1�WTe>�y�=U���|�P��BBр�!Bt��at}�VhߘMR4���gs����Aۣ�;7���k�cc�W��1=���>%�B:����S�y�'x��<Pf�����j���eڒ���>/)5��U(��T��W?$���g�׮��g�	������EQb�^9� HkL�L���GG4��y2��(�G�r���Y��2s�
�#�9�PB����a�*{Qܲ� ��zK��w�BE���A�e����.�k-&�$�Y+�2�c�	��\��?�m�mv��������ͧ��6��1�VqA��kb�QHfo)G+F�c$ ����;���Էc�5ۮ���Da�m���,߯�M��%���_q)G�=f~~N��(.��:N{�w����U�1ZΤp,�9N�Q:�`�����w��{r��Me�.�� RK��f�KuT�2b�3���6dW��,6T1�<TC��I�C���v�qW�qJ
�t@��B�U�q�6*�R��Y�LB��:��ȏ�L7G�A�Ӂ��oy�ڥ�,��:�]+�i*�7t�T�zގ�ŧ ��t��
κ</�('��]���n�;<.Wi�tI�&@j�o%H���q��;�ǃ���E�v�WA�F�l%� @�*b�5Z�?���@K�h�
�<����E�5�qo�ǔ~Nul�"Kk֙�#����lܛH>P:�E
�2�LwC�k�kȷ`�8>oʊV�Ɯ�˜��$�j��?��JcV�!0a%� 
����B����X�ɒ�u��`�:Ǚ��V�Po��U��?��V�4�'����ǳ��`h���|i"\���c(�g�ǀ�X	��'�E�����s�n������0#[��݆�(.��Q�ffmB �S�P����1���&���͘�HV�w�T߸S5�`qg��'xD���n	 S����s-�������,��&��(�T�Q�q��]m R�T�}'�DU����N�E��쥢�
k�'��s\X.�>�q�q2b@\���0_��n�!)�*��͏�l]W�M]Wd*�����4��j	��5���p�W��1Ƴs)��i���~q�a���s����e �dp"�5$U��k���>�˦�Jm\�^�z�,�6����L�H�2���;h ,{��wv��#.<�PY6t�����K����ќ6�|y9���% �7��K�m`��}�WH>2�(㑑t�����5��:�>D���?q�s�Qy�*�"p�z�D��)B܆�6q��)��Mx0��)��^�KSE�'F�:�A�?��N)�rH3�D�<��� ��֮7���R5����AV ���� �
��D���ܬ��X'&�_�.�g,.��YƏ�Ij��돖��s.���3 \�!��9A�������d�q�Gx���q�-��o�r�k�m�3h-������V5�%���M����0�گ��J'��-7�{�a���j,K�5�D�[�q��qxL�j�"��m`X���X.�ҳ�p̀Z�Hh 9QC��
�B����
���y	�9|��mpTn\�f�hJ��7�肳VChM[�7�]�ݪ�^Yǲ�)�Gc��j�U�=���(D��hr����;*�e��D�I��6��|ƍ�2r᱆��_���7��kD.��S��i$Pk(KP����{6��=l_�a��#�5�guV�l�)�%�DP)ؤp�v<���`=^����P�b�Vg����|�!�*�sEz`��p�p��!ߒ9!������#nۭ�S�
l"�jXk�    (KHt����*�~�j�p�;��m�S0)ME�fޯ���p�Dˎ��/�罓�5E�K�ZM/���rk]�\��EN�ŋ;� #�Hg�v���8��bL����]Mz�/���U�X}�gVo�h��̨�hď���|Uᣋ� j�m�z#���OԆ�lҶ�l4pO�B~���2k5{S�ú�Z�0��E�)t���p9���H��5TXe�8Y'�U8�X���S��Y��� }*��1v�E�����&����E;"�
 ��Q���y���㌇ֈ����X��C�r�dlf5�LYj;�����=���,RL+��/=�L���N�O�mk����W����>�D\�v����zq�{}JN|�(�c<���9mPE˝�z��&�!x̄.�x��Fǔ�xV������V�(Z&�����%r�Xw�ȅ	������>���je��n��\4�x����]=�LR����znDxĭD�ǂ��sBn��&A|
�)fx&��o�a�{�ܛϬ�^�S�н73�mrͬ��/?���lt��2������:� ��\2� �n���H�.;���ў��	�~Ix��A�O��J��a�-O���	t*���\&@�_cZI�@vv���廷�
�0 ��@k�lD�!��q#���TX���.7U����!�=[��2_ ���x�����,ᎹԌRްhG���}*���Vt�dC���\�a��1��.x�*b~6�«�1�AQYX�L�1��=>g|�#�C����W`�/��p��L�d����P��*���-kG�+� �!/�.�R59��H��������g�8L���
#�H �r
���"6�g�.��4�d sF�p�Q���Q��X5���D�aX1�S�&C ���0���C?}*�����������|T�N����P����OU[�������'�v"g���b��2���N�3w��od��l~Y�wa������cV.Ϩ��<�����&���uCA����;0`�s�#R�@\�:��t���s	�
 )'�9�91�p�I�"���h~�{�i�k{c��7��C�4��8������~�j.{jrQD'n����Z��ڰTY�x����S�PT�N�Yg)��xD8�,3	VUб���ã�kN�V�8�M����������嬡'���r+z��M:�9X޳Ɖ��L�+���'5�̃ /�e�k�w#��'7M�
Cy��y�2۴`%��6M�:�"�����!�����txQJ	� :Z�zg���]\�^p�Tjm�e�����K����+?�[�<��uy��b��|�*�;%��3@�lu���`܀��I3y��A��ˡ� ������#���
�f��W3��_��܋�
�ְz�b�)���,&�S��L������C�C0��IT+Uҹ����I��u�F���l��(�V*pǴ�G�����-�a��Z	��S�����lΓtDN�hq�m~6����j���P[���z�~F�q|��C����=��nకW,~#ڑ?hW�U�m���y����q�`�6�a0������A�~0i�"�����Y��5O��Fg?R�(���lF���;�YU��4�X����㢢��55G-|x~SV�4��	�6�"O�
�D@JB�S������uS&I`�r�$���:/"a��a�(\Mq������V��AhE�,��@/�'�c��b�V�k�49fD�C��G�~:��xD�������̫���|u������w^�RYb<_�}�v�ͦ��/���<�r�0q�Ӽh~���e�F��A�U{{,ɤ�Kio@��\Ag�%�`	ȏS9��ǚ�ʇ�M��r9��b|���qW�S�|W��πc���Ej!Oب��z!DA��b� �)أm�����ˡW�}������1Q0Rd�YY�;����h�J��֦y�T�mp�{���P���G�}�k[|x_X�����;T�J2�Ĭ�ʚ�7ſ�;{1�q�3��5�v'�(���Л��}�F� ���ӻ~ p��$^��>�V6�(V�[1ឭ�ex����tf<X�a�t���u�)dL.��Dk@��}�dJٛ��LF@>«���df���������C�����>��7>���:O���l�~��gp(�!b!�g��h����&�����U-�w������|��aeX=0�Н-�)/z��Y����צ����!/�gch7�3{�J�|c�K�3�V���l}}��dR9e�1:v���+���e��p~�A,�P�N����}��\rw�ª)6`��OƀȩMDmс�,lيc�1<O��@�����9����_L�z�9��L��-fV�-�i������t�	��1Y������CZ����Pxe��6�w�O3�*n��6��=Db�̼:J��^d������r���J~4��[�I������(�ίj��us��>�{.G����r��_���ڋ�?�}�]�;)��.q�A.& �d�9Se��E;�b�%1�/��O����x8������,2�wU�"H��cht�@E�c����7�e)fʢcd�)L������nޅH{�hx2���}�Ƌ��`��qzq�h�ܛ^]Li�Z��²��B�)^�\*�0��u5�����硡P�`�򧶪٭(��^2��z���m�Dg&;Ƣal.H�
Tֹ�!���8�bp�ո�*:�F\��$�ѕ��_An~���C�e ���]��Yf3)���{p%`����%c'�Ô�c����?����R�)��R��8���?���f7t�NuLmY�iLT �9�����������[�$�Z�kYG�@1��z�JQ�VHP9Y�$mo�S����؅ ����3*��%���>z%
]@,���0F"h�Z
�����`J��������qi3����~���,��������^&?
_CY�r#��$8�1E	0��gG'����
����Ќ�?\�>�X~iI7d�����p�ib�ʢC�[��[r[���R�pיg�Aƙ��b*ڭ��h"��q���P��37��D��1���5[���c6��T��S�k57$2c���	��R]XA��>N�dƫ|�|�#���^N ҼM>NW�F8[���Y�Ԡ���+Y1X����T�2���0=���7�A&�Ep�Lw�C��5�]w����4�a�C�a���R�'c�l���%��P̆�>ѯ>+�|�gY�4�,�È�-ˊ��B��!A�n�<s�7:��z3���`��۷����=��0�3[���j��,���= �w�>V��������[��`�]PZ\�
3��O��=Sy�W������N(&�M<r��W�;Ʋ+�2��x_Q׶�v�r4�Lԃ� �j��U�������W9�d[��`�=���}[@8�oCz�}��>���"\Z��k\����.Ȼ{5�d��!'�u���Y��D)yԄ�K��6zi����Й���V7�|���"U�zm�,�:�����/��Kg@�_��U��/5i�`Y>a+2�gLc�m;K�A�T}����/O��i�G��8�����IT��\�Q�C~��E��˫$��UR��*�V�>P��h�o��5�7{��+�5��Φ��+�\���ȹxFqe^B���1p'o쿖��˗�ȀRu��V��:��V���]T4%Wx�W��7�bxa�|����hn:�F�B��� R��eai��+G�d��$JU�^��V'�<Pku�5ᴹ(Y�%���v�o��Le0�[j0��
�"G#̙^i��+���<��"��f���* XA%��r��f�$(�� ���}����ǧ��"��/V3<�@��ˌPC m~_B�
�C-e%Y�>Ը4�����}���ʋ�\����%2Ӎ�����f�A�p�5�8����s� E:��l�,#����͌g*�1(�f�`ju1?�#�wi%�Y�b\c���}r}C?�ߓ�f4�����lGV�?jȻ	Z�)p��� i  NB?�Px����'7�F�c����Q;���4���m���,~J�$\����^��4����*��1��w�[?ud��*heA<6`�ꨛR�2���#�r��\�����O��+���t����E?�U������﮽�	 ` �/;�(�g�S"'��.[������&�Pn](�"�	��2>�Vʮ ~�Ǖ!?�?��{������G�M����q�eAM��� ��A)2�m��	%i�,�M��dKɉ (���c�$���B���\)	xxl���/��{��o[�����J��y�XuN9�ʠ���+P��73��H:k�����V�W�0�d3�6��uL�N/�\؉�v����4��C^S*�t�����8<������0�h@��5�5��S�YT`n��6�182;\h�*wV%وΚ�_nSQ��Je���d��	��q�R�Á����Y�,5���ݚ��AP������F7.=�A�KڲNu֘�Bx�����o�÷���������dK̳�(x�|G
>�uL0��y*�DO�v8v���(��/�c�ȱ4X�ߛ���	��������z���tW�ܿ�,D`�|���1��//'ӳ���j�����Jr��eeuu�tfӺ*9�+WF,��c�F��3���18�c��7�v+��Mu��݁�� I�@� ��IA��e��T,EŢ\	L�'�7W�<��[���-b����~�Fjۏz�D�q�04��g���ɘS��:��m��!��L9H���p͍�%^eJ:�E���G��d�*��!�__4
J?�X��a{��Q�X	��|ё��[M,y@)�-���'�4[�	0�P��uq� Fk�s(�%c�aЇ��0�M[�p���֍�C��iy��� ��N����'艊q�/q �fz�u���u�<�	 �#�~�59U2ەw�V~��t���������S�
���y��U��T��C�c-�/���@�1�Q���̞�%@��*��]^?��a�s /�'����|x�j���z�̜�tyǝF.$�����f�$����Hy� �"f����/̎�(��^�k ����hL�n6փM�X�q������+�q�g֍3̀�)��I�kXtg�@Ăϻ�|4xTL�Wt�3|A��Z����b&��Wc��6��IJǅD�0~mٸ��1 �~`x��ˏ׳�&7��hr��Z�Ů:M�>w���6,mb�W/1:��@�6�] J}���3m;J}�::�s��>�5�:&��t3�����ڮE����.�k�ӏK�χڲ������� yL'CA�6�"���N�0�-�����^�����ߍ��[ￆ��{=���������ǽw�_｡�����������uw��w9��������Wew�P-2�qЩ1"�O1�bE��f�����m�2�k�	on1 ������4Ѧ� l�����/�ۅ1x�~���m��,�#Tif����pr�(�� '��~] /=�iF����Mn��6e)��gn����p��³�Z�ۈ>�s�0�b)��8�>nTzV&�ˀ�W����s����K����^��J٬��d�]����� P<���n�%^��P�m�I���A-O>]�Ǭ6�[%�^�/1l��7��M�����֧�Fm�~ӧ@YPѫ�:�7#"��En�8��̂�i�����<c��;�]O��qO�a����}%�G�na1,7S�ai?XP���Z�I7O�QY�L>\@��X���;��tĜX�w��$�;W� ����,�C0I�M��pS�r$�
;��ux�v&t\T��F@�1��?�P��.4���~b� �Z�_s��R�ZB��ɱ�a��lo�tZP����q��d7 ��'&�1�?�14_�c�E<��	3�0��l�0QƘ��ޢ���7�4��qte/����̵]lmp7d���������ѵ{�������ə�?���� [�o����Q 3�ւ<nL�T�5@?�Z�s�����-$�/N'�,�Y�|5�89[�������T~�\�KU�j&�0-f.��,V�Cz�v@G���ܲ2��L����E�3�<���L���Oj�u�dY,���jf(
��z��য়~��-���      �   �  x���[O�H��ï�wB����/~e5h�e���a���(1�$Z��߲'m;���
>t����%8" wx�~D#G�߆��P0��.>%}����Z�zo.�����\�=�����}������r66��'k>��?���{��.��[���˱�X�U�?�mV�E�ߗ��r�k^��2y1���EG�AM�O_������I@��X����Lo�"�=BQyl����
t�9���G��j]�c&H���p�[�#�7����XY/.�ؗRl=�tL�Z�O�7�᱙l���f=]��o�j�r�X���'x�û��&�Ё[��"Î>w���]0��<��"����U}�:����%y��f�8]-���fUgaR�T��k5�޷�[nV
��i��~����������(ș��#iIx�mI�C�ۍ�_G[�OI�!GT<wM�t�&�Th\<D�օ��.�(@;Z��|�Q���	����`�w �#��N��8�:��	�%�m
��#֫})5��%��`x�����[��p=6���
e���UYs��x���ZT9�]]#�պ���C~L��@S^	m_�$ �H�P�n�t�Ā}E�N68r)�����}��$<Nv ��&�A)4���9�KX�Xr>��0<x����b;��#� 
-}�\�O/5��M6�(�r���#��/B�����s� ⿄@�Y$׎H��t�i�Gr!���#J�}�ج�7���4���Os;޼�]`�\���N#8\��rܧ�:~�I��D:��[� $��:0�n��tёB|����'���=1�#1� ��LD���M1���z���]�!���F�����?�@#�9��w��muC�{~��;��.�c�*ܓ����!�w�>!��E��jv�e��X�~	�k�,I�Wt!B��a���>�
 )��cR`�3ỽ������^      �   s  x���QKA��O�_�dfv�<��z85!Ⰵ1�<�o�TZ'm5>:?�w�3+�Y�u��Y\,�]j��A��?��Q��2F��Q|�@l�]�~l����~]=�{�
}�髨�H��\7nߵ;[�O���W�9�BD�Q�U&}���wCj\�T [���}��������e/�Ud��y�R���'�p��]�}s����%1K�� 0�A`�����5����T���� ?���o�͐d�II׻1ݱ���JY��+9IW�/5QX���}ˈ?�Bh��މ���	t�q�o�ԥ��x�l�u�+�!�%J>�LtA����(kA$�Ҽ���
)r�����0yP5�`5�WELyV      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   p   x�}�=
�@��z�s��y/�Y�6��I?�@�����N��W��e�6����Wќ`A����c�d[!�ǧmI����Y���#�;�������p'�U�q7%}      �   }   x��б1�Z���!��-{�L��ϑO�A�/��A���/��Q���eX6kkȫ��6m��S��bOh�	4�_�mE��6�*��q'���gY�z��L�R�����#(�'�UU߁�a�      �   s   x��=�0@��9�/@d���Ε�Ҏ,VA(R�QJ��C��oz��s���9MI�YW|�O��:���ߐ�k�͋�l���6��6D�C�OH��X�C����8�f�Ƙq��      �   ,  x����n�0�g�)xN�c��I�P��vk�.�������P	C���o��T6{~}���%ʭ�-fd�HpՉ���> ���K�#���Y��H�����}�;��	���c���������|_\�_�����GY'� 5��h V���?b�ya���w���������}NE�H������s?��>X�8��;H�u4�e��A2jnu{馃���0�q���(G����XFE�vp톶�+]�$Q��~�X\4C}}����R`k2�T)���߶�G��2��1��(�      �   Z  x�u�Ks�0���W�p��M������;�t���(����ձ�c�,�ܜ����~��}�_T&�H���b.gT"��҇�t(��\U:s�r����\�P6\���:����O�ㄬ�_��j`0 ��0�1z��m��,�R�U�z"ڨ@���P_�%�&a @(�(���C��ٱ���OF[��=��n/R@��EBI� � �|���Y8��vg?I����ة��z��+�+`r�6w2��ӳ�?\�'���M��:�õ��j)�px�t�?��s?����GP�8ۼ�G���@��m�K�B��b�tg3׽�U��Ҭ�i����a      �   |   x��ѻ�0��:���l����� m��Z�'7�%K��YG�~�O����&��d�lz�ʬewKV��W7w_�	��`� ^%4�%4�%4&4^&4�&4ަu&Nh��o���8~Ny&~�      �   Q   x�3�4�t,.)J�t��/J��K,�/RN�I-�420��5202����4r��t,t��L��L�L�L��b���� �v�      �   �  x���K��0DתS�	ğm���eo���ǔ4��c��eRT����?��|~�����Eo"ݷ.��U�������`��v_�Bd�z�e��_�к��n�1�P�$vTm�j�5c ]g.ݫ4�ZW�Z�V���z�k�Ƃ2�od<�h���X��6Z��>�$���eb�eq�6��ɣ��A��^fc�"c��<uR��gg�Nw��j+N����Zi��AZ1�:�Îm����,Z��1(�y���Z��c����I�d/��"k^$���=f��%�.e�����;Yti��][�=��&����w���ګ�|2pxn��p�f�4���#���=繹"cg��K���M����u�<h_�d*s=x/�{r�;�1�����!&g�d�����d�ؒ1�Ǒ/�b�m�d���{�1�26G�@��VֽL�=�����6f�JDg=~���+m�e����K���W�[��� �>8x@      �   0  x����jA��u�U��������ҍ��Y	���L�w�d,8.Bj��	ڇ��L:iR}H�!�$�ӏ�oN��O_��L��)m&ɗ/>?��N���'�5��������i5_�t�>ɬ���W��"۲������緂��˫�A�i������&������U�)ݧ�/`٪e�\k����B�U7��V�~T�%iK��E%-Kg�,݇eТ������2�h�2o�*�}XZ4���avV����GF�KZ4V������ҳzy��;2h�nK�qK��-���ʪТ��qK��-��qK�,h�Xz�*ˠEc�qK��-���ʪТ�Zx_'c��4Kͯ�X���㐧��0I.P"�t�!T�A�D��~PIJ$R�o�T�D"��nPIJRN��`��@�D��^PI%��Z��g�R������6oK��LV����j0YZ,VIa9��"Т�4��eТ�<,���Ec��"LV���0YZ,V�o>���3h�~'���deh�X%<t��
-���.�ա�b��DVh�X�L�A�����e�2�h��,���"��]9iJ�[B-��ԡ�!�6�F�%I�~�H%��v�HJ$R	��#U(�H-l�ԡ�!IJa0h&I)J�`�1�/%��+'�R#�[J&��ʐb�J"�B��ja6��)JRJR,��� �R,��� �2�X�ƃ���b�❃2�򴨔���qoG"��Aa���������Pa�
o!Pa�"�"Pa�:o$Pa�Rf�^f�jo'Pa���e��W�>      �      x������ � �      �   �   x�e̱�0����)�8B�=mA�aC"q0dr3$n&��oM�������,M?��`Hd\e����9�����K��x���5���ݧ�r���%��<oy���R�>4Qo[%TB�.S83)�B<�ˊ-��:�W�Ai�0�x��c��w�+�>1p8v     