PGDMP                          {            smd %   12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
    public          postgres    false    309   R�      y          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    210   ��      {          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    212   $�      }          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase) FROM stdin;
    public          postgres    false    214   A�      ~          0    17984    invoice_master 
   TABLE DATA           W  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type) FROM stdin;
    public          postgres    false    215   ^�      �          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    217   {�      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    295   �      �          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    219   =�      �          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    221   $�      �          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    222   A�      �          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    223   ��      �          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    224   +�      �          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    226   l�      �          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    227   ��      �          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    228   ��      �          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    230   g      �          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    231   �      �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    233   �)      �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    235   �)      �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    236   ,*      �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    238   h*      �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    240   �*      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    242   �+      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    244   �,      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    245   �,      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    246   �,      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    247   �2      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   =3      �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    249   c5      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    250   :      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    252   �?      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    253   ,@      �          0    18191    product_type 
   TABLE DATA           J   COPY public.product_type (id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    255   I@      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    257   �@      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    260   C      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    261   HD      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    263   dE      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    264   �E      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    266   mF      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    267   �F      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    269   �F      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    270   �L      �          0    18736    sales 
   TABLE DATA           �   COPY public.sales (id, name, username, password, address, branch_id, active, updated_by, updated_at, created_by, created_at, external_code) FROM stdin;
    public          postgres    false    297   QM      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    299   �O      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    301   ~�      �          0    27167    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    307   �      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    272   M      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    274   �      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    275   "      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   �      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    278   /	      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    258   �	      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    280   �
      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    281   X      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   �      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    285   E      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    287   L      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    289   �      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark) FROM stdin;
    public          postgres    false    290   �                 0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 22, true);
          public          postgres    false    203                       0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 13, true);
          public          postgres    false    205                       0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 2, true);
          public          postgres    false    292                       0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    304                       0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    207                       0    0    customers_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.customers_id_seq', 208, true);
          public          postgres    false    209                       0    0    customers_registration_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.customers_registration_id_seq', 188, true);
          public          postgres    false    302                       0    0    customers_segment_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.customers_segment_id_seq', 2, true);
          public          postgres    false    308                       0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    211                       0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    213                       0    0    invoice_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.invoice_master_id_seq', 106, true);
          public          postgres    false    216                       0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    218                       0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    220                       0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 264, true);
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
          public          postgres    false    296            .           0    0    sales_trip_detail_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 2285, true);
          public          postgres    false    300            /           0    0    sales_trip_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.sales_trip_id_seq', 2200, true);
          public          postgres    false    298            0           0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 15, true);
          public          postgres    false    306            1           0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 39, true);
          public          postgres    false    273            2           0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 10, true);
          public          postgres    false    277            3           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 4, true);
          public          postgres    false    279            4           0    0    sv_login_session_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 1012, true);
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
cE���iMO=�d2N��[w��^�n����.�?�e_��y��o�ӱ+�z�A@@q��gY�G#C	R%Pu>��g[z�8��%���jh �m���$�^?�����,�      w      x��}YWɖ�s�_k�K�U�N���&F�D-��V���
ˀ������;�TN�|�|\$�2v���C�`Rf�姂\��ˇ���l�����ܖ�����Od�r񑲏�FO�:ab �6�U?�p~��	|:�٤�/���]v�zX�����pA�$Oߞ3�`��[���>�c�:βߦo��l7�F�����&h����,� fC�?�9?'�<��_׻�˖d@,�@�%ԝp�+�i�T�GL�?��'��ޯv�9|�|��v��;�r���u�D�͏��T�dV;&��f�e��,˨UZig��
^�g����j�D�`����il�������<;[�r9�/G�l���u>�\N��)?���7��EV�^�l�c'R���#��r��f���l4�_��
,�,����$����էE�Y8t�Y8���=ܫ�z�������91W��\�}�/&�4��ӗ'����7冼����MQ�'ʞ03�Z'[ĂЦ�~.�?�ɧ���@�6����Q��\gƋ/(���P��t�x1���d��|Q��b�.7wd�P�>��	�'T,�Z�63�	U�����w��.}M��T����*��!��;fE,��뒼�{�� ��_�����if^��'T�f
��p��u�am�@����4�g-Ӆ��J��bI9]6)��9����yv

_~ќXc>P���;���f#�7.`Aـ)�@c�B-�H��f��@��p��U�
�}�'���e=�J�D��B]�2�g`"��|D�ܩ��pQ������v�!(x������vK6[L	 )���G�{
�@��H�n[QfN$E���Dc����r4Ln,���j�������]��'�����&��l�����~K����f�%X��}K�.A�p`�p��:1�Q p�h�R�ϊ��>茥�(�5g������Mąg��r�|�?f�[e��A]m��#�)'��������O�
�@A��|Ou���j��q�-&���+����sI����	����=�k�c;�J�9&u]�9�����9�+�!
J2!%ϲ��<� ��=�˗u��݁m��o���%�==r �uu���V,�cZ�"O;М�����M|�����_y�y�m����9�4EJ�0VkO�uBX�KK�6q�_]�E1����д���(1�U	�繏,��B� �M�,��9Q�5)������aL�Ό���m�
�F"ڲ�5p`G�l`p�g�Y,��"�������z�S��p���v��g[�N��6] � �X�.e��p\��q�#���*���ei�`\g���Z+��vc癴�d�����ż�a������Ƣ�	L����6E+ڐ8�z@�A�XxE�&duSO��X�b{���nųi�(��P��s��&��ٻ��$��}9i@<�����ֵ;I}H{�&��q��
`������"��	��X��T�����h!�xH�%k	[�[D�gנ��S&)d��N��{�2��x~�����F�� ,�e�!�ͷ؇�� ��3T�A��#ߜJA]Bˠ��w�m����eOh�^���G���P�@��ޢ��m�(3~P&Y)��Y�J�� Q�:��^֯S�i�M��%�	�zy�&��vr5�� ��x򛼀��[p�!|s���͊�X͊�u��I~��-�kD�����y�0�sA��G�mduʴbH�a��N����"bg8���b��ht�A=x8)>��
`�Yq�e��_·�3��3`�p� G�`�6� P� �Q�pQ�Q����~�) �d�cn���Aw) ��uN���|6���&?C�GC����}�]L�V.�7��vL(�{$��l��/g�����2�����%E�>��S6�����C���%5@J�� �V]�D+�O:JAF9�|z�jH͢Z nr?�ը��"��|y	�7�M�1j�Y��N��$ ��wৼ���t�l:Z1���,���ݨ�����f�!�.�q+·�����߇�}m��|NN���lV)ig3(��WÁ�����0{Y��Xŀ�����Yw]Bk�T�	��O�ſ@d�$.3/����+@�D8 �۳g��g~Ej�2a� �1�/ɍH�PA��.F'����N���!���~]3�[0Nk��<Ё-������S�sO��4�.ȼ����i��A����h(�Lp{ �L'c|ܞH�y>�z���7����B�Q	!Ԇ\A��m�LN� )E2��bo,!:��ٯ���Ƌ����lQ�ӗ�ֹ��Cj���I�&�N�䦘����)��<��������o�0���&M\A0$��J�!x��Br��?�����p\e�B ���E��~!�����a���X*I�C��`xTTwP	���yb'3��,�����p>���=�)�8�B@�����O
2C�7���Gǹ���@�)�J��u�d��`�������PNj �" Vi"�����M���?��g����[�Xnn� d(�+�� ���[cP����K���]�����K���o��%�r0�N^�/�����_�)+*����D��'P����L$&�>���h�ɛ¯��gd1�?����K��A�� �~ڔ�$���C��5�4���}�[�'x����Mk"	�3�$p��z�8��AA���`�v�AC�j.�v�9F���{���m�&�N{����IN.�/yv5�B�g9�9��+��fdyu��*��  �p'�kƌ>L}�l����V�6]�EA�W�'�(I�1A��̰P0��&�a\d*zz��,��s~Q������,��U_O}�.�f��$0��8�8,�vi�Z��t8.��z_�}R-��<��y���z?U2S�$Jf��ٜ��\^�y�(�ӂ`ԗ��/��-)�U"���;� ����������C9�����|V���:B$
���:ł;�=��"�y��&QO��7�7:�q#�|A���[�S	�|[�W�a�C���{OM�;�[���T��R��B���~5/���ė�F��G���gf87e����ןA�8)�X�I4
���ep��|������ӾL(�+�E� ��h� ��w0�)�.������!U|��k���A�&�|R����LB(�t'��[�_@��n۠R��Y!�"�N�k�-��b\���X
�!%��R�����R+��T���b*@���pz���|x#�|)w%�����֛����@q��~c��Q�8�$������49 Q ����+��b��ݕ�Mh�I�J�l�;��ݼl��~��^qƗ� TP��Q�+�U��JX�Q��F�UP�B.Oy����|	)�5.P>G�F9�r
�y]L�s��HM"S&Nq�N�p�+�ǐ��@9@I*P�&	�~��e�ße����a��r������e���a�ObH�W��NjҞ����&�zk��ְ'O�?���(�\����Xm*m��0�Qc��3��_)�-���[?b��]|c���5֦����Po�D��"!�:�ia������1BӮ�Je(�y�";�b�oW����o�GB~��`=YW>\'�V�Uo�y�r�"�u�3i��.{s|5���' VX:ۜ�=H����&�yx�6��B+��h�Za|�{9�O} q�}׈~|H �Z8�	0N��
�+���So� ¹/_֏_�
V������0l�6!�f�D��h��Wh��!���P�7�q��Xʰ�
��%g����n�H��_��^���	-�pT�|y�O����'N�m͞��m�ˡ�?�Rk���rq��B�J�=h��!���� m~M��'��v "An0�]o�n�c��x@}D�� �.����<P}n���ۗ�Cz{�l�w���7�:$<�c+-x�Y+��x��'�۲٠���Lu���t_.o
γ�n���ِ��#�g�B`S8&� ������v�,��@x    b  ����m�Eg�������H3R������XJuc��'1�F�~�ϊ1�m���a�Y=���n��lە��!`*	�����v-C��;�h�[����M��XF6���7�S��[`&�@�ӿK2���	�^��:6�Gi�B8�׭w9&��iQ�����bx�r�7���	&s��%t� biЇ��MS��s��J1����xb�?�j֤-�s����b�<+����8��)�q1���1)������W˱��9C�Jŵl3S�$0~�vw��y��(�M3>��N�Eܦ�*0�G��$����0y	_����r؅�́����cX
CR����)�;�����᲼�oTk��X	GY;#�{E��a��Pc����!����S�  d��<7(���a�I �q��3341Ѹ��r�����j�E	�Z��K鬖��I�ЌrmY��5�����v���<�wn���=@���<��$v
�+�}b�r�`�f��Tkf�f�1kz�n���t��y�E�� t�'W�&��1Y�b1���^����W+����+ �Z,'�X2^GE��^��䴘ϮC^N��r�[n;�K�:���;���)�X�M?I�҆lzrR�
*-Dl�k,�]��H
��_I@�W���|6��$W��,�抁���N'��rE�����\ ������m���?Y3��}�pN"��,=�˛���LM��۶�*���)���O�sqv1k��T����T0�{��.g�B����@���!B[H�����d�K�j�����+��ߵ8�-��uZ,��SY\��Ö(�K����mj}���X��}o�j�`�{��8(fe��[��3xR�@/��̃����wo�~����~x�{�*���� �mwus��Dڏ��c�n�ns�&j�+�[���QW�iݐL�_�ʻR��}4�0�ǵU4^�M�����C>:�� �!_�K��t�D6���i��H`O����*:��t�ޣ&�bі������h�y_A{K�S���O�ů��M\���<�;fM�� �}9E;�J��9���	r���&���6�	_/���*����x:/a�q�� S9am�C�ઑ���t���{H\ �#�� ���~z�A����Nn�K��q��LO���Sg䡼���t )=�F �t�My^��*`��@h��ٸ�,���^�~~��<2Vk�0%�z��|4����9I���V��PÔ�� �l��9�u $�|T\�R-�gظ�y���}��rw`*��,�����|�	ɯ�5<��؋�)�FM@��b�7�^͋/��:x��<?"�'��cz><��?Z~�7���k���@Z����GLAb�+� ~�%Z���F�)�Iq���x!`��nEo�Q?,J2�)4I�.�q^����Q�_S�!��V�	�F��l���!ǔ\#��o�iLd�c-�Q2dX��pd� v1Z	��7�m�b�ٛ���Ǫk8N�W�G�j�_\W! �����I�H��C,t
zi����������)�?�����u��Tؽ�06{b�9'�bڋ����ws��������.u�@�����_+�dZ(U-�ܗ���SX|)>7��서��q�g�*ݖ8���i4��%���t����6���]��g���CP{~�EE��������6uO�쬘v��g���g���ZK���E��������f萭�o�mu��d�A)��?�<�!h��y�P��l���8����9@\/�O��rs��Ԅ\�6 �-�/�L�����=α��2/�m3޺����7NY��L�D�F4m�G��6�ƧjWqA��/���;7���[f4`�c���蘎���=�g��k@�o���c��r��/|1���?^OKWg],���b&��ц���DH�X6�'��м��b�o�����5��#�3�ǯ~�u G=M`r�;+i �if�3��~��k��Ӊ~��m�x�1d�W��Ci��Ar�U����{��Xޒ��|X���X*���,v�=��8#�@& ���*�MW}�^-,���
հ~c;`u��� f���֨K԰�a��U���� �AO(�2@z�"���uP���=��Ho���R���9c�䢪�R�~�~�͘�?�"�n�d���Y��Ǡ5�Ӧ��L���R��H��>�Y^�@�>���މQ�iV���\�>�f�b�x��������Z�D0+_�w����kϽG_9BZ��h	M���ԺJ��p���k�|	�Tj�R��|8�k<�s�8eU�7;}�ޓ���jw��U�E���L�x��>��;(�EA�z!~�/+_u瀃3�-ַ�r�c�]��_`��m������oI� ����)�j�g��/�����(����@��<櫛�@������,4 ��a���p|�a�37 ��`ֵ�H1���TR?�3 �0ک���ɴ�.w��`p%���`RBpce_�o���1e6/�Z����3Lt�=�%�BJ
E�
Nw��l�Z	 ������'?��i�<T��@�tt� O,�����,���i���j�N�&GJ��;D�雞j�WO�c�з�v}B�J�� ���|<��3�!�A<�4=+H�y�w���'8������]R%k���C��9(� 0P�u@�a62cH��)��|1-����]b�O�L��hQ~�Q����M$���~�A1�";�O�1ڑ�"�t7M!x��=R�W��ѮU���`�Z���m�7��Hkc�Q���)�br�*>���(ϮKp\R�YL~l���XN�l�}�i�E��w��}}_v�	��/\.x�M�{t�f!"Є�p����������C�nZ`���%[�ZZW@� L���){t9%�Q�����Ҿ�����vlС�+Lf;��Dr�'��ȡ%�=��'�;q���c��9�B0��e���< ��y�k��!��7?��O�*y(���]gv��#>�Mc!V�������X�E�N,��� ���!�i�&ea���i��p�|�����u���H��l��弇$,���}h?�F��轢K��Zx{~E���� @�mt��
��w�a�}�a{�7�����b�ۢ�/Q`�q;�F�����id^5��5f[%�����"�D2����5�P��!�����"����m����@Xf:�!@�.y ��.�:2�ۏ�kf�4lA���p 0'��$�/�6�ݓ��{tp�|8�J�0�C�.=2Y�>!�!`ģsߩ�_�p8�:6rnܯW���}	��S�h�Ô@�g�1E@�Ro+�n+c�@!$��Rشt�N�I$�/��4��tQ>���F3k�(mܵs���0q�*E�q�rܦ Tsut&;HT�sRs/~�����O�>����� �>������'z�Џ��A��y+�U8s�3GU�h�*}�:�n:��=�j��`��19?��>�ğl����&:�FѶ�)�:�cNa|��E�WRަ��J�e�s$�i`���F.�el��C��2#�i,l$�d|�z\?�I��@��|�`��������#Y��FZ��㳐�L��pL�ǾN������ᐝ���煪�+�}Oǥ�����^��4��y���bS,Ɉ]�������=*0D��ARv�8��Y�n5ך�y#�(C�IS���1�?؛yS$���r��yIQ��e�Xv�,4�5��(	�%4tN$h_��6�]tS�d�O8����T}�uY��M©�~&��x��J�:�+���s����G��")�@O'Pc�'*�3�������Nʇ���L�[I��2�7FvZ!:`�Czu���������J���Z�z���&	Fz�}�%e&�E<p��S����A�[���]�5��C@+*Ke<�����F�1-f���Ah�&�t��A�h:G�y�B�WR�����z�@9���ɐ�<l�E�����x��9�2�\���jTxo�^�$E�c�SL�ށS}��LFK    c���x>n�v��T(��n�6O539��7!Y�3��j�	c��}�'�F1�<�����{�#�A��롬�Au�s��#����x��L����/��Y�ǂ����[��8�x�W8;�>����dG�Z.}��F�[���'u�E}1"+���P;��b9Ƴ��8�S.ǡ&~�o����3
��̀��xI�uU���#2���d7�<��o���9��S�=���c�O��N�q����W��b:�P"�A�Fa���YO�=���r�g9ȾC$�'������s:�)S�����Uw/�C(ҰП�{���/�'\@�i��{"��yl0��O������(����w��Y;�Ʋ8�H��J�Vބ{I�0��֌k��9֚ei\P幃�?��ɓ�A���؟���zs���f36�����X�������������p)FZ��[i=�7i�ٯ@s�-�n��b�����$7~�g�B}�� �b�_�N��i��kOq�B��'�ߟ���3�V����GDR��N����|����8������C�Hc8��^��8���>��"B��~���2�`������@%���ӢYO��i����BBr��^^�ESu��d��˙��YO�ľ���N���}�g:��%���ǫ�H~���?\��'�H�q �o�D��R*+��؇����-5� Ջ�G[�SB�������\��b$P���Gq0vH� �aD���b��^�:��)p�
�O���'Ŕ;�QZb#e�U-�(Y�U{�Hcj��<��_��U�q�Y~��T��}K2��c��9kGE�Xz䶍��d�ܮ�m����^)�}�[��?�3_C�0�[��8,t�	
kM ΄r�:����TwP ��}�,�'l~����l��daƄ�2X���(��Y�=���RQ�b�bK����r�r�GR�J�ȥٗ%P���"�� �r1.��th����HOH+���\�����W�Bds^�2A�!��|�W<����^~����{,��o�Ǩ&8��rc�	�/��4���XMW�8����e8qѢl`{���ӳ��n՘��i�)q�ӿA^z����A�հ`D@c�+P���w�ř��k���c���������^M�ʹ��B��׬��3U�O�qZ�*O�U�4��f#N�8��E(�I�k�?K1��P�q�v�r��(Zc}�%���%~-W�������yO?�`�"]8؁K]H�b� 碣���sХ���$_�o�*�0�!�����J�s�p�~Z����)Qe����$}���v1����G��#f���к;N��h�N��5�
��pIM�! ~W�*~,o_o�։^����E<g۠��Sr�Ӊ�V��c
�:7�����z��d�~v�1J�ԃ)�;��h��Pb�|h�h,��"�������e��	q";�_u��.XH�G�v���/kU�����\=�+�M�+7�B�ۋU������?*Q���r��kf
(N�v�Ȋ�9	���wN ������'�q>�� �}r
_:gN��L�>`q�^G��P����s�OR�𘢟ab��� z�xJ �L�/��|��pJ>�fg�����W������J�.*�Y�q#�G������N����3p�,�RJ�q�Z�{�GP�s��; ���Hr���T�r4�r�%u�ysG��̦iX ����̧����cEؗ���.�l��Ỏw���sWc�ȟ�f�֨U�Ď�0Q�w�W:�ʝw�g�?���z�Ox��f�z��[~8����\
�9R#�ܠ��b���x@��&��xJ+����q�}7�V�g��N���2�����ar/1a+ w��"l۞����3:�#U�휆�H�����~bh%_*��"�Z�'�A�A�����#S~����@Ң3|k`��q=HSc�/J,:���{��.�1�B#�f�13n��H�<�~Mʝ�xq��cڱ�M.�{�&��0�ϧar=gN���;ݭѡ��\!7T�F��Ye�]���/�z)_J"zv8��15�lj{��G�� =m��.X��-�.Xl����ba@���1��w�x�KaN��{��i�O�	�?Rs��*jW�l��j��Q�]2�\��&8
�d|N!r�[�@�Y8N�8IS?n&8IPOۺ?5�Xa�N_
������]?`3��|z��)Aum�j�x�F�5�S��)x�0��p���r�<Ί��-\�K�G@k`RC�GH�q�E�&<L\�\-�7x��:�jP�gX��ј�v�ŋ'(�}����\A��R�i����N`R����r���~�_Ҹ�,=ދE5:�N�)�ጉ�}\���T�eF���F�t��p}�P�=��v�p�3�d糛<�\�m�^=O�ww�TD�c��r5[<�|��Ȟ ���۲g��;eM�=�e��z�g��M���yi�d��,(Nw�_rRg�����_��]o8s����Qw���as�k;	��C�\8�ޱwY)k(�b0��9�L�-P{���N�鯨>=[��~�tv=���2_����N;<�%��!��T}�Y���~q��v$?'�`etA����|�s�HΑ��-��$Vh�ݴn�.��˂��^�Km�b�a��+���h�WFA5�Z�D2X�����4�1Y���-��87w�0�V� ��ݫ^p�6������
<:�����Lh- ��p&�s��HX	�����]|��o �NV�颲y����φ�m�D���d�6E��մv��w��h�e'�S]�Ӻ{�@RuR�r�G1�O�	���V#e��q�X�݊2������	��E�\���`x}��8_����2K��a%�FSt�`��~�I�PI�F�.�H��d����΄��L!��a�&����m>��;k��*�W�ŋ��&5�9���Y��p��@���(��@��Ʈ�7�'T<O����$�8�j�y���e���n���O�<e[D���}���B�JCW:��'�͸ �H�,,���H����v�O͇0	0�v=vQ���z�;z�I'�q�WԽKae�?����$�}��`T�D�&�z�[���ΐ8PR�.�H����f���Wy%�x)�h��<qT�`�;��I<�ٶ)�ѭCI���d����Aa
z!��\N�E��M"ӫ�hĺ�`�8W42ޢ����r[�8�dd!*��S����o,�Np0��O"�ȓ��na��=,l��@��߳�@�:�x�ϛ�S������2+W��p>�}�%��oE��p��d�'P�d3>�=�Yjm$'&�@i����%�/�i��7����l<Ź�=ĵn.&�54��~��e�GP)�V��K�`�x���M?��M�>��S�]}0jEZ'3����b��"PF�f�~�%Hqm�����_ �`�>C��	�|2�IP|��6"�� ���*���d�k^�<�_'O�%x5���p�i�����ӒFI�Ri�>ui�^��Tޓ|����[�~�wk�9	^��i��]a�z��L�8�Q�����>=�����]?�����Y���Z�%���5�u!�`���(��&}U��w�)��,����~sw�G��&���ua�h�|���/{��D�x��Kg�׭�35�a���b���F_���U3�3j4��p�5D�2g�Wޢ�rr6{�
�����ܴ�s�L�r2��X�|ڕ���~��ݐ^���F�v/��]�;%��V����20�?�ya(�E��a��}p/�Ȳ����998�8U�3����x�M�,L���&>�AqO���e4ڃMطҝٕ��q��m�[�Ŗ>��GrJB8�X.��1�k� *ȗ�t� �1�}	?tT��^���n����U�v+i���Tf��x��$oL�f�ų���i���7��6m&�g��x�?̮�ϋ9��Mg#�qڛ���;���'g�;:-2�PZ���e��mZj���ctҜ�#�*|S�žS�]�4ǉ�AD��_Y�Kk�7$�����x6C4�=��b�' ܗ�)���	2����   ^f�ĢE����i��yK�M:�[�]uo�N�����͎R�Գc��9�ޛFg�~�.^���xe>�Q��q�p��VK泛�<�xE5�pC]}4H�Z����8�G�����n&�
Ƅ+n�k�$�d����=$y��xy!��}���yo����$��i�����	��c�K���Eh!cf��8��W�+�@f8�!�����ܬ?����n�П��MЀ�;@V#F�U�N��ݺ�b�\Y3
��!���S����]���o�����s�      �      x��}msɒ��>��"��ݍcs�ޫ��,,!hA_OL�F�bd,Z$v����'��y���x,�e:�*+��ײYQ0-rή���;v���g�GV�{;Y>����C9g��	볛��G�e�~�\��9�{��3��q�rR��g��3�����r�}��M^^g�6�|�|}�7��.�3�E�jť��{�R�k�U]L_^��/��Œ^��v�u8y��X>���/" ���B��??��eϠ�a1g��Y��D���6������t���zY�/�|���r-�r�+��e��%}&AQ������r�2}�ja�t�8�F
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
7      �   8   x�3�����4�4202�50�5�P04�2��22�377�0��2���ů&F��� .�B      y   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      {      x������ � �      }      x������ � �      ~      x������ � �      �   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x��}�$;rݺ�+��@2|�N�i�x ���F�/lـ���	f#=]���A����,�a0���?J*�r��Y���_���?�ß�����������.�K�������gns��(7��#T���LՇ8��T�Ϛ�����QoP�������Vz��t�L�%�2�Cg:=����G�БR�t��?syf�s�,g�<s���c�;�=OM���+g,(�Z����[f�]��;�=K��x�z�����h<w3
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
^|8���;�A=ŵ�K�]��� OA�5�-8^ݑ8x��o��)���0��aC'`.r� �I8������vx89w dXs�j!ޜ�����я��9   ��{�9��L86�' G���~5���B�w_0@mu�~�����B�$0��X]�cz�������G9��%/�J��A��2Sd,����%��
���b#�������h}J�2��V��^BOq�����t�ʴwh�K����u	�m�j�/���G6�M0�߮_1�ؒ��Z�Z��2'���`�[�,����=�K�,���v����qRj+��;��n�uJ�ٱ�P������++���x<��r3�      �   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      �      x������ � �      �   D   x�3�t,(����OI�)��	-N-�4�2�"jl�e�M����VCLL��6�.l�eh�E�Ԍ+F��� ix;      �   �  x���덃0 ��a�.P�w�qt�9�Z�]�*a�Վcb@R	�'���� ���]�W�������	�$}`4��6��.�}O4�8?QX;T�{�P��d�8�Hb�����[������� f���X.HK-����S�/`�V/���O�%9�51?�]F	���j��&؈g�`ěd)�vm]Z����Q��eץƴp�c�q�U�/^DP���#���[JU�q�1��_a�UtI��'�ѡ�����yh�Q˓@>+����g���Iv͌�Rc1���Eo��Pd�E���rr��1;s��\d��
�����E�M#� M�1����:�Q�u^���QW�)���u�x�^���F�.�a��6J�5O��%Y,�      �   1  x��ҽn�0 ��<��X�뿱s�f�%M3�DE"���((����N�̑$C@�>�	�D�ץ�$6��f5Z� YSfp��*F��L?������׾钠{���.���χ؂ToD�$I&D��bʒ�zGJ�� \p����u��+����g�h�g��(p$�zg���Y�5t�ڬ
�x� pT,���IQ�,��zFG��QW�]��u�b���b���g�?���q���Ӻ�S�Z5j� �TM��M���5h��]��׋};����I�e�H��)���Ʌ�U���6�zp��۸�(~/�^      �      x������ � �      �   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      �   �  x���Q��C��N1�	��D��������TBvT2���:�H�P"�LU��շ�[����~o��k۾�������~����?�����m�j�������0��j����<<2�=�d�T�i��z%��]R�M����h�:%��L4T�Ka�!ݦ>L4
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
Ov?���iٞ>����q]4<i;����^̖x�L�6��j/ʏ�o�����p�ƿx�p\}V���Q�u�~웆ƽ��ð�$��.�f�aU$*p��yk+�h���8OB���]�r��آ��'��1�����֓��b��ھ.����=���*<�_��λ��>�,�a�      �      x���Ys��.�L��x�k���5��)2�'���2�]K�Tɤ��TW��q"2�'���t��S�{Sp���絹PB���?���*�U!�'�~R�l�1Z�D����/�r��s������ߨ%$��m�-��}��|x}�;����a_<���C��~x���z+nw�b�{��wOχV�A�����,P�|���2���&'J֞�׮��k���ڭ��� +}{~��E|�EvG��$ڲ���2~?Cv;�4�l�������P��O����2X�� �*D��ԟ�[I�TV�D��S��ګa�J4�ʭ}�{������X��{�?���ۇbw��5}��G�.���h���l�6�ɉ�E�*�"�a��hm+�[�l9�֓��rT|�lV���V����y��T���VT�i�D�i�T��էèU-*������i_��
m���׋�C��g���R��H�񧒨��R��v��{�r/�������Ê�)T�:�	~UH� �'�H+CQ�VFeX�>��B���v��vQ|�La�h�?nx�
��V�T[�JW�ɒb�ゆ/��h���NϷ���S��o�&��{y�vo�/��OpW^�_�0�Ȓ\�:����(��Z�s"�"��׮��,Lo�����A#-Ã{��ᩅ��͉�k�#O��ֶ�"�=�-9܃ݛ��;� �'?����y���"jk�:'b�*V�l|Z�om�����o{3�Of�i1Yo&��۠�kM���"��-�i�5�%]*JV���4�"[wW�1�,:0y�Y���.���n��V�e��W��h��0�Yn����kh�A(k]�&�$�%�8^;\#�������b�;��+�χ���ߗ����c���
+~��|��}��&'��0r�:4e�L�q'!RI�	%%�����JQφ<x��;��.M$�.M�r\�9]��4�g3^}�,>��f>1XCi>4u{��M��5����$t����͈��*�S��k�[��k��,�w/?���჊����T��僝_l���d����U�Ή��0�[
�h��_���Iw��۟F�y�N�C�n���M��
���
�>����e]�:|tR��W����^���+������}���+���x�}��7�iɵ�VR��o%�^�69wm"�Q���ӹ�6[�䄧��=V�ggX�*'�oQ�o�+��|[��Q��?�p���G�m]�6'�<�H�y��i���.���bw��a�Y~�s�i��ҿ�'�60"��L����Eg^�P���^�v���b��^������ǳnQH|h��xu�ݺ;O����w��<	��N;�7?0���'�V
��%�?UI��l���x¢��Ƌ+|�����W\��;g�z=��M
����|s
BUUS�D����YBLaD�������`3��}�m��d�]��l�(���^����d�__����W,�x��p)k;��d1���^������l���ـ���'ݔFݘ�(1��
s6p{���Ew9�u�d����{��j9ڂ]�.f���;mM�eYL|<e�Z����oo�
��>H�`m�/x�����;Y|���YƤ��~�f��������F/	�,kx��Ή�#�pG�7W�G�r�{�ឯ ��v'{�M���KpxW���N�)�/��6��,�&�����Bw�%v�qBF����#��eD'�o#/�^��ދ����
����w��o�C����� �	�Ğ`�Zϙ̉��NU�J]ᠻ�ݽe	�)ή��p����S��X%]�lgs�n`=*�Q�8��F1uW.,�s��r�Q�=�a��m� .���w!�#���V��1�����z{��������a�V�|��OF�v�1�W������y���6ĉ����J�j�k��9��k�D���O�)U�*�|�Pt擇*�'o�t�yE�r��0�3Z�Ӏ�m,~��ۡ9������/a����\V���o����ϻ����u�R�ڽ��|�{x���kA}�8�K@q��s�D�缉
����c����E�B���ֺɉ�KT�'�O��vt��{�~�sM�M��ǟ�ུ�m�&':�\�*�	���M��oW��7ɹ֟���>�Z����,�UQVZ�������c���S���f0H4���4*'�Q�sJ��1�,7��/�w�����!�~y�}��I�lp��ڕ�z��h�mb�YK��%C[�
�?4�յ�Ą馻�����ᾘ�|(&���|KC>��ii|L���0����}NUҏn0e��_ߟ~޽�{��0��?�B���v~�����������&I��������/0��%)L��Z�9Q�rFeX�>�8����w��@]��v����`�SiH]à{��lK�۫6#�6�j�E������zy�����@�i""��E���J�1�+V9.0HC@-�<�����B��$� �5X��_�q�A��<qZTV���緿��������������$,\���X	3M�؜�	�c�ą����>�A�n1�q��6���d��+�dt�$�HR�u�ʉ��*�MV���6��.;����-��m��s��KK.E;X/�6�S���jA��ދ֥gu���6�{IC8�ɔMS�0Օ��F�{��>�އ{_ �.nƫy��H���[l&�� �
΃���j�p�h����s���^%���zU_�(~?���Z�/�>�Ye���hR�����qdD�LU��a�*3�+�_g�r�}���{���q�GpR�*�]c��>�*|������b��b \�����!iU'q��T��X���f}���h��)�9�ٲ�Y��k�x�_�Evs�̂���Mo�ʊ�n��jz���j4�ҫ}�խ�ڰ�z�X�s�X5x�e��0"���$^�2"R}RjU��h;+V�Y�D�u�����~*�,q ��h�ZR~IE<���� �A��o?O����໛���<<#0T�&4��!QI*j�Vқ��_�o��~}����Ĳ(BH��vW�ŵ���6��q�D9�Y�VT�0D�֔����I���?4͞��h�'ܥyv8�7��}�x��)��hk�F��L�*�Dę�	�?4�ЉTF=���G��rv6��o�����W$0�T��mB�0'fh�;��g����E�?���ݮ���ޯZ��^^�k�0�����tN�]�H%Ff�����-�|�،�\����ru�|@��-u�	=x !l��؜��-#��y�~s2�����zys��>>a�墭�C�IH^�Zc��<+mN���T%�k���>�z��u��,���&W�E�I:��G*0I�lk�,�ژ�MEg���J��)wqH]j�N�<�դ(��V�h&Ec2�V�Ъ�tN��5"&
[h���q2���	<����%�(J0?, js"��G*\:@�����<�~�GQ�?��Ag?V]
S�0�HE�2c�t�K����n�����3ͻ�d�t��1v\L�x�����D|�����t8��,��~?�����u;�0ے;�PX�?�����D<����w��bn�;�^n�E�����S�oM����Х&:�T�H��.�me�0�w�]`q�+��0J��\,��%/]!.4*u�*�C&��JY�УJ$�u�4?�vp�N�/���'~�{t�~�����#�I��9��+a�nB�,s"�8F*	TO�.�}R|>٬���]��k7�O=��}�Y;�n��b��W8�����P�T��F]���a��q!p��Z�
�V�cz�!�����?D�J���5�Z'o"D�������D\��poQ+��£�-�W���'>��;�l�!.YM�ݢp��fE�J�j>�"���/��t��\�#&��	�ո���.J4�.�ʉ�EvQ��_���i_ܿ<��_�V�iҊvi`|��b��D�[NT����p�C^�U|,ƫEW:�n����`��:Uu~��!15lAi<w2'�]D��=���x�v��50��    �����Z�6'�w���9,�� ���a�b��Z��M���,ۄ�����H��;�M�sR��p��|Yn��ڻ���|{=M�@'ef��W���-��*':SU�݃��gx�����Ǫ���}��EB�/jx)eڜ�_$Q���Y��"Ue�"c�j������1��xQaq`��s��e��(~<�n�p5�&�F�۶ԕi�ɉ��BT�
(���9��^��_�7n���A�P-���ues�3nn���ꟹ����+l����=F�K���x1:'�,`���)\��f���;8fx,{D�����p*e�xV��ߐ����j-C���δ�*���z���ֽ����������!L$�R��56'��JD%�=,+ؿS�F�Ur�*�Q��4�J�0	��80RI[��B��1��:���0�J��WP�T�1�Ήx���08H��iY�~=��|����㾨
l,q��Ѝ�0�o:l2�B�i���"����Ov�0"���U��"Wa|`pYk�'p͞P =�]|L]5:F��"#*��U�"U�Ѷ+n��̻�v�'�ĺS	�;[F�aƋ�;hEiZ����|����9a��4''L��$ܕ�� X��2�ҡ�̕U�+m��PE��TX�Pu��#�0q�G��=sF��o��vѝ�؟�9�>L�����"�>�*tԫ�ֺʉ��u�r\ᱵ���g{��z����fp�1i1	1-�M������	1C>�4�\�)��v�d1�]� ބ����^M�2�eYT��x9 P��໙�Wښ俅��+�v펵�	�?4�,`�TۧsO�x�w�[y���E�!�)�W)LR�Hεb��"	�T�W�Jz�+\j_�,�s�5â԰BNNrM΢�e`�ږ��Sw�#�4mں����n>�5���n��|�YU��\�0>d�8ITmN�{�D��ε�3���ޟ�P�量}m1�Y[����wG�J����h���٭��$���z���-͟�i\�X��	U]�ƆT���#�t7"��e���j��PIډ#��{[ࡓV�0�HE��T��Lƞ^��&�b
�`
^�������T����w6���&�b���������ɰf�nWy������bA��
i�yF �:a���Ŀ@�bz����ER��TR��&��&,#���50����dE\{]����5�q�/�;��{�uG���˺�ʸ�W)S���T��.�Ǵg�^Wݗ�d<�^��r2+�_��.l�2Խ�-]QFp<��2U�q��H�e�������l	�������ngU�a�3 �@l$��3ЙP����ދ�7l����*�Y	õ�	垢
.I,�����F\�ȎT���	����z:��W�{��N͟wH�S`�"^I�o��J�Vb�K�$I�Pt��yRIyc�0ֽۻ|A�C�|��3�e����s"������N]
�%ɯ8�o]7��t���;":��U��f�=����F�o���d\��I���:'��'Ra��ƞ�0lV����-f kL�טc�W"�_P���1��{������Ai&-h5�D�9/8�~vR�����~ڗ��M$���?XWZ��ꪱA?#��H%�����o��sV%viD���E`�&��B�,TIm>�w������s�����XhYjl���["�X��>Z�u������� Q�l����W��	AOIǇ�?j�/Ҵ9T�T��l���	S�?�"]GR������?���_�D�a�m�D�&��sF`�QA�#w#�$� g\rMh]6���vq�)�!š�-&��R�D�Z�Z�|�n�G��c�<�B�El�ux�6�`�hd&��*��<Y��
��*~���
�8�ʜO#�&H-|��k��mV�Rwc"�������b�0���-f�֑y��yX��6D�;�'�DB��zpjU		���m�����m��̤]��c��ۖ��(��[����M��D�X�Ť��I�:df���:
�4E~��MN��H%����J��6C$5z۽��#���^�J~,��>ܽ����w/�.CR'q�qw��i����O�z��#a��2�liT�=��^wh�����~��q�]y�KfT�2X�P��F�P��{������>>?x6������?�=n�u5�
4��`�U��	]�D�vQ��4���c��t_� "ɖ���b�pW<˪ʉx1Qa��o5��=�ln�+'8u��TfhC w��uP`D:%RI_kt5Z
��.ǳ�����h9��z<��7�ߔ�F��g\g�)bsc����Bz a/m��|ǚ).��*8����/�T�bⲢoSi!�:'��a�	��M�꾁c�%��X��X_~���5i�i�5.S�O�h�qV?RI"P#P��j�:��׮���t�����	�Y�����h��4�E�w��]X�5k��:�&�K�:u��H��dS���T�������8�|�y�E�1S�5�U�F=�Qa35�B蘵a�6�1PᎃC����ǃ�\ (D��W&o�v~g*Z�N�%r��ڴ&ilEg�C�����:il���ߏ�^��Ϗ?��O��[g�������^w��{���U�BFɥk���]C��RX�MET<RI#�#����B����]Aص�
�qB�3�B�JT�[���Ϧ"��R(yf��bq+Z��L�G+B�L�E����ces�3,��J�F��ȵ�ޮ�K��0�ɪ<���A��꬈��D*��3�}���z�g�̆���΃��k<>mS��Ή���TR�<q��ߺ�7���Y��Q5$g.��Lp���T�ۚ��6�H%5�p;��o�|;��]�8��uv$?�����������w�p��#
'|�<Qs`L�>���*"a���N�~��I���������pV��%� UO�P�\���Z�:#��P��&�PJށ�Ǻp����n�'�L��P�}]�i��Թ@�ҕ�uNĝ�H%Yh!X���\'�wW���/��k��*��j�D�G�dK� ��m�&"MT8�R���ZO���V#�21tE��h���FЕH�'��
]����[�t��D~���91���_���x6iN���v��iN	U���'`&%W�H�R�{�e���P�����Z�zv^���)��D�q��_��/p��>���wo�?9:>mh�:Χ�T1���ʉ�|:Qa��6�dd�����d���䉷��hPkѦ+[ֶiC�b*���H%}L�������j[\q���*:X#!P㗂m�VuF�E�T�.�V��WL��pr�˾x���|)��8�Rs�Ҡ������i$:�s���?��C���I�v/���$ȩ�=X��&��^T�œ��6~$#a��r��n{W�oX�ᾀ���{x.n���u�ۻ�8��w�R[�p������HkL*��D�-!���⁒������L*�}9x�s�j	��Dg��
���Z�A���&/A: ̄VJ�]*:Ӭ�0�o��݁���2A�7-���J��B����.|�S�'�T�o�@T��(%]
Z��/lB��&_X�Į!#"��1">� *��n��o����M>�'8�V�ͣ;�j�Q�� �r"n�"���i����y�ެ&7ŷn5]޸ܤ	���mӎ�E�F�q�FD��v����;n�sd���+p��5����b��E��HT���}����/aU?=g@O�ц�+��S�QX�#ec�GDgP�
k��6�� ִ��C��x�FJ��ɉx�R��5�L �θ"�?�������oX	�7���#�-U�xٜ�o\'*�M��0
±0��zU���t����%���?c|]b9Ҷ9�X���xD5��ɢ�t���s@"$Y����Ok��19��D*���Y�����W?ԃ�=:����#�JF�
��w�
����.��V�U��� �0��Q7J�I"�(D%=p�b��w�:���V�?fY�K�U� @S�D�cJTX�    ,���?ߟ0o��w�aI��b�@����i����$*,-�l̐k.���K�Ld8�{�����ӪFW:'�_,�¾X����� ?�=�aڎ�ae���E�S#*,p�w���n6�|�<�gH���h�9љ74T��Ц�c7����M>�C��L��7��T��+�U<��a7������������.{4�Ó!��o��o8!�w����j�/G]B��6�TĄ�JZ�ù���sR8����c�-�'TvE�p����!��rUx*���<��>V�����o���<i�T�	�P���!�2��� �}{��<7��3�W9N��Dr�1,�`�.�S����߻��v�l�k�!�5�%"��+�������l���1H$h����e7]��Զʙ?7u�Ӻ2�;LD�;LT8�����j��8�gCw�ʠ*�J�&�Ko�Jzؐ��
�t�)��x�%�cD���Tģ��
��K!z'���Չ���}ђ@��K��JQ	�d���n�*,u	z�>�F�Y[$�8�C�A�"���=���Z�D�����Lc.��d��n7[�g�4s��)|�$���M#%<�U�T�Ή�П�py�1Ath2���M��*�"6:ԕ5L�t�p�F�[C'�V-�Ƨ"�BT��B��>=�܌��/d������t�T%�˂e䐸�!�:l��B�Ȉ8��H%}�D=��/˛�8NQö}7����OS��c�~�=�bB��R	G�J5Gphs�e��u��qX-����f9뉵	/NR��-56J�*�@Eg�LC��$�L��v����0%��[)K�6��2"�A#*Do0,k�]�'ݦ��� $Z\|��S�H\͐�Z|?��eNē����'�����=�z;�\���D~<�V����j��D���pOBQ���s�	�,�_�O�u�~`D ���:Qa�B�Fw�K7�6�y����z�f��(�Q��Ow��������37���6+��Jҳ�3��;G��ݯv��<��ݡ,�/﯎��~�kw@�rJP�b�DJq���mNt�;?Ta�v�ł�Lag�3�s�n�m����&�̘�(jL��1�3�T�
��?u��&Ӊ������;��r͂��Q.,�ǖ����T�4������x:�9�P�:Y¥�< 8�]����mr"� *� 쉕c��L�9�7�;an8&�~ʖ��&':�xRI�c#��x5O�:N�IQ���������"Ώ�TT/:�}����!�y��ط��SU.E�]8����W���_���}	�	��M��~�E��BF��vGDg��P%�Q��>T%�[V�Y����@~yS|��h��n�
��z�E@y8��ˁ"����\##�s�D�́Z�?�W��*n:�y8fB�����e@KD�[U�d�%��D��[cOd_҄��^������>6'J�	�*�^)[�[����.���w���ZO�&"��CT�%8.��8ϐ��!~�'���v�S0��� v^ ]IE\��peث�}�i��3�:ʋ#م	`L��`��	�T�7��i��O����)��e��oWCbۧ�O�m��#q"�;�%��J����D�8R����BG2xs����t#?��բ��	^;ʭH���%�f%ڜ��(�
�[Q�R�7X����� {Ӂ⡲e�躉2"�.��.
�@U��?_u�Ѭ��}�%6��9ڱ����p�"�CTض.��p�[p�[��Na�l�?Ί�fu��{�hUY	]U*'b^�X��Z9@P���P�%I]J�ӎ�f�9oi�
Go��P�g�g�|���R��y���1Dދ���:�\'�_4��*E���Ή�D��J�n�(!���Nǳ�l���g�oWG�)?�����P��axCq�j�TXBљK�P|���q��,5ΖG���@!�^�F6:�NE"���T�m��U}�������������q��w��������(#��Z���z�m3Ή�\���a����b��bz���L��~���{�T(��i�`uL�OVX��ؿ��O�6��ⱍd��M�'L�/|M�J���|9�����"�?��p�@�T������}q��_}E��	7-�-�Z6&#9C�h0�rM���ZвL2>3���6)�_�!*|����d6�w�w��GP�|C���!�>���qoU�O�Ή8I�µ�7Ǳ�z��G����<�;q�g�Dk,o�"���ˢW~
Nt�پ/ԥ�w�Q9�SD��)m��s���&�k?���*U4���d��1�(�ڜ�L�f�����:vĮW����P��r(��M�t��3];��&��m�<|c��f��=�Z�[�/���j�
�U۸)h!͇"O����Qmp^Q��*�cҸ����|���s�H����p��'#�#� $�t�D Wʀ��ilx� �T �<���ZM����%i�x)!��`s�a͈�e�½�4����:n֨��M�F���r"�埨$��!�>�z���9=�+ďp �`s"�����V5�lՀ��3���WW�v3��%�oԿ&Ǚ-�����t��~(���ZTM��D�����"��=�`92ߡ3���d^IM�8	K� ���{x�.[k!s"��?RIOַU@�+C�6{��ӆL���L�0T᳇M�=\O������a��ZH�r4��%�l�\V�9ؑJ�y�c5���|S�v�솙��[_�8���1S`I�E~8�+��ls"WAT�D�6�>���*�4���o��a���,�"� F*�!Cl��!k2)7\�y���%�P���"&��U��Ԏ|)0�Z���$������C�C�#b�|��C9�':�?��#�{�knB'+���M���Tu��/��Wl�$>�tO}��t��,6���|�m��R8�4�j�Q�M�D�'A���x� 	1�O�/���#7P]7S�a��{/�џ���v���i��	�	&�8��Y�*��2���3}�J�4h��P�(d�����[aS�|�-�߸B_b���l7��#����W7ec갔�H��c��a�!����y2�=�u�qT��"گQ�r"��$� �����λ�m�[OF��;J�35}6�Q|�A'�H��~Q�nN��*]���N�w�I��Bl�
�?����>[au�74o�^�.��^��O7�HؔB�!S	#��H��[��a�����f���K���X�#�в&l�����U�6VL�����׾d4����t,����N�,���#�C�?��*pɈ��2R�"%��dF�'u�eB7�`�j���>�6':��
UX,��N�H�_��-Es�a�	�����n��PmKE.���r[׆ܞT���I�:x�v�UC�A��T���E��
�Qԍm�Y���O�bhs����ҍ%�
�6�0�Ith��$"��B0x�cN�H���)%��v�n��U(&�E�~x{�U���?�>�0ҁm��.(ǩ@�:|B��&�d��T����@·��0�C�/ő����c6t��~��^��X��!����U����p�L���D�r���Vd�d*�X�"�a��T�f��������e_\?��=��-"�׻�����m�1����h�Qۜ�f.T�1s�����V*,)'���p)�$U�D·t��K��A��ǋE���	x7�r4�-�qg�yUkC�]*��z��T�����e^%�l=�U��uN�9��
��"�6qd��B����f<_M\��92�D��8��͉�D
�
�HT��1\#�d�B:3J,"P"��T!!e2j݁��O�J�bkLD\�9RIW_�H{jS{�y�&��	����2�0 �e��E�'F� 1Έ�s���)|/ju���G"��p�i��¤�����MN�Ż�
W�5z`>����s����r<�h�E��z�V��G*�X�� ��q�=Rk�.Ɵ���q]P�Q�F+�OLY��ǸeM�W��є��Y��d_�p֪n밑&����*���
!����^�v��;��'��q,aa����#�0��h�    ��K�E*\�Q��ӻɗ��hC:�-n�pLtp���T�љ�P�i��p���{�<ȃ0�n7_έq�mUN���H%iHh�����m�+��~¸�c�=�[?>����}W�<��O�6񰈈���
w�����YO�������u�~������B�tU�FтL;JE�w'*l�<X3���v�������j�(�	�!j
k6t̏FS��i�@)'�ED%M�Z�/uJ��(�n�m=�۔�6d��$�8 I]�"6(qu�H%MX���?��ƫe?���[�u�����lZ����<or4�nBdO*���H%]-���ջ����o(H����8B"Imۦ�A�Dă��
����E%I�� �[��a%����i�@bYʦN�W��TR�q�����s1�ζA�p𖈓W���D��L��?S\D�a��+�� �r"Q���;|�M�F�<��h���6���3��#S�VF*�[)�4@s����0���rp�����1�}�����t�o�6�ɉ?VI[��ht�������!��Ƚ��iح]#�m�Ye��L�n������8��[/&]
�k�ئϺ;F`��] $���{�#�4�o�Zqjڽ�w#߯��j����=�UbA,+�HT��59��w��x�4nL�eyx�h�mN�c��
�2&����@ہ{9��5�\��g2��)9!�F��&���'*l��Zsl�ԫb<�_wH0�_�7A�C�+�H��&u�T�{lD�͉!i��c_���2���	kթ���I��Ʃ���)96�u�%ǖ��^���bזk'��{T"�x}H�/��0~�F��:3,JK�T����)��lhe_�'*iۭ�U=���n����z,��v���%c'�rXiSa+!�ME<>��$	�Z�J�I���_�_ow/;�߼��������7�`C��_?��z��?�����Å{DƸIaS�ʶ�1:����0�!���$ۼq�oxk�T����D&�l��i9��=��9�Ŷ[��b9[���+b�h��zk2o�@����*׺7<#��̤��6��9C���.��{�{q������x�Ŗ��i94qZ���2���X�����w��2��4h�*�ϭJa��!x,���J�8�Y�q��/��t�R&_�Y�>��b[�@֠$���$�B�xq.i�LDnq�ǻ�-&��'Zdd�9N�3q�#�$<��"�q��F��(#�u�J
ƒȯ#��J
���7W@WNw	�~w�"�a������z3�Ud�������;p�Ή��9RI*�3�;���9���{Ĺ�������~T��L���G���
⼶�a׻��w�ջ+B~��	��W�r�)�7X�Za�#'��D�kLgGV_�k]L����s�8���Ӆ>Cč)+�)aUN���\�_$�뭶kpu��=7�ig�+���Q�u�u��$"ޕ%*�j��.H���x��*{��u1��&���m�	z8�ds�n�u��ˈxN6��r����)���_�.N���9Mq�y]|�m��G>�\k��V�rOEgZ[B��e�Z��t�q��C8e:-�9:��k��IE<��p�1���:y6w�Q������)X��c��=���I4�8��!}#:��uRaq6j r��M��3����\$�:����ԍ�TN��JZ�5�_Uo۟o�
�w~\V��s��%�}���58�Ji�q��T����M���]�RR<�?�Ч���H�L�R����0".-��-K5��1�v>�{��cd�u�u_;�z.��[�)� �fF�k"�d���A�j`��~��uC��"��69љ~�P��0Z#��u[�D&Jdo4*'��H�� �'��C�o��p�	=��&G�����'�� Z�9w]"�OΝH�v�1����������;��!�~�i�����Kħ?{֮�گ��.��,�-aU�lJҿT�7D�s��	���}|w��\Oӂ���"t��Z]���� *(�ڌ���t��͢�"S/|��&�Pt���p3��c���a ���2����RX��9�-�
�-��!DO?��ܶ4�C�M��"li!$�����'58XxB��:���v����B\(�e����Y���1��!?QI�x��4�T�/�@�M�Y�k68�U��Dg��
�.i������ƾ���"����}��S#�;R�"�ꏏ������*�y�C��
�~�cȯt�2�aG�
��$�`Dt�8���a1���d�ԅ-	�i�*��}��E��I �*Ij �Pz�L;���������'�ALi71F֝p�n*:�U�p�Aa��֌~�����QH��u[ۜ��/�
S�¨�����s���v٭���X\u�l\����J���VȜ�_)QaW
�E��.��Qf�J�;1�!�56 T�V�̉�05Rᠴ������/�����8�dwqjz>8a`SQ�I�_��"]S�e���D��FT8$��y�t���e����x��'m8�%9�8책���D�?�D�;
lfX���f��~�7m���Q%�/Q�X�Eב
W�m �}Z`���ܽ�^��		�=Mjx`��h���Ҵ�&�$�j�~O+���y;�z;�v%1�����6#�>)�HW�j�FW"نxS�xh��kjpR�KT�}�C��+���.��4 ��U��'*i8o�e�]�8f}�����*���69��8�#�ږ�ѱ�O*�ط������c���kW��kt�_'�����z§����4?�0�iT�蜈�D&}/mm�V{���M1�&�t���W��1�]���#$u�7�Զʊ���*�B	!��yz?�Qn$���G�V*��s&Q\_cT���1�r~3Oׅo����kÚ-SN�(HZ��j��/'����8����8z���v�/�`�L���z�/@��'�������G�!9�	�4C��<��:DĂ�rk����C?V�\�G�jG�}�!#s*�1�D%��nts��W�j;��"v@Y<�� H�
�$*�RgKD(�q�c�������F�������w*��Pǻ���9�h�(�)q�a�F� �Cۜ�s*#.�� ?�۞s������+xD���	����Γ ��^2��e�Ut����U8�C¯�-�e����j�����uZ�f����8�ADg�4O*�VJ�$8ld�u���A������C����"���9i!��o���>S,���au��n�V,�-�`�?���c!Ki+t{�'��F��� ��H��a{
U8���U���g�l?=��Ճɋc������Doz�����χ�a��*~>�/���7��C���s�Z����uS��L��8���I��M0?y���t `n�A�Z$PV9� z��$��:f�!8���O�O\�IQ�G����J��-�(�T��H%���<�P��H����w<8ڨh�j$�
��
C��#S���7ԡ���U�+�4Fms"�g8RI=�Kb�xV�_�/�j2�<��nU�0M3�Z!9>|m\%">�JT�̪V��Ym����������-�"����p�(��3P�ͻ�v�����r<��bT�5��o]�16�#���]���+:F*i�:�4"X�ж>��f�-a�Z�X��pp�F��x������E5���+ĥ������������sl��ϣ�&H[Շh�wF�q�q�.IM�t�0	�W�1њ��G��K-5&Q+����@G*����\B��. N=�fF�3�k�J����=|���|��������0��@h�3�+e۪js"�#�UR�p��d�z����-�so�rd���ZP�m��ʦg�Yaۏ�s�X�����v	��Տ�-m�[j+ǌe+�h(�74�`������[ut�ߏ3�CT,����!U ƀm݆�OF�y��Jjxd��w�+x���~H�v�9:�&L$���WM��*��2"��D*    ̫�Ѯ xʾ=����L�moC�!�݅p=����9	�}�4�%�X��o�e�24o��@z�F�*'�iވ
K�!� �,F���	$���U�W4eu���6l[cD<�(QI�#�����KB�K��P�1-+��D̥�U��� ��j�LV�\l�CND�(�)?Q�v���D��MU���$i�0�C�7��O�?�����yw[��|��|т{A!Uԉp�F£��FU9�`D*\�Πq�.6�� �+�&�Y�ŭ<�m%���q��E�>�v���uK�\n߻!�>��DV�AY�<Ơ���֒�$"�@T�^���e���ŸX��n��_�tE�񺸙,�C���8"+�&����"'LӘ��L^���8�^�l�]7,��1羋���:Iљ�J��6��2;r������e�z��,�O(��tkeoG">� *L+�k����9<��v\b����1�pT���y��i���c��Q�O:���A��o�p27WR�H7.�c��'ٔ�WY���T�"���u���#I�k�6$���� �B"��MD<|��p�ǘ�R~x�{��Uw�M��t��a{Y���Cљ|y��-'p��3b� m��t��<D_�`d�N 4����͊��@��1���~�|��z4�����i��u�C"5X"�='�n6�HW�I`uZ��[���n6�%(<����v>������N�0�ZYC�E��P��[Sa��&�
��1���u�Vܿ<��_�[���OOn����$�7�	&�ns".��0�f��'��u�	$�[U�:�5q�p��Fl�q�
>'3��ǣ%�zA7G
d׿��3ppA��#2oʦэ��3Dć�D%��|�/��)��t(xq�^`C�ˮx�����T������%��S�qV!���$�p��3@�P�aRG����[q���	��E��4A:˼�n]�ڨ:'�đJ�3!�V��˘L*���3��7�VS�؉��mkڤ�-�iyU���!FDã��[�6��d:L9���!0��j��h4�8�%'�>q��yvِ{s�r
|��q��'��p 73I���(M�������lMNt|�$l��I��_����p�N�Y�[Ea���,���"7am��3�3�J�t K�K�!�����x$�v��zv�]��p�Ql�����p<�2�g�Ћ��?q�H�I� 8Dr��m�2�-Ri���ˁ�y�}�9�fE*\��@�,��7�M�����p��\}/���t���C��[�(�E���|rciJcqiN�ݼH��PSҪ`tw�Hq���"B9'���
�L���x�c;��x>Ac5Yo&�ظӨ?$���F�8�MN�w��u�YQ�Ӭ+2(f�r�Zm����8Z�H��8���"p�ts�����9���g�
'���  %��^���OEg��JqV��G�y�}��oj"��x5O;����)��/8k-�꜈H�*��!�n�����G�e8�U����<����r|�g|�����nfapgx=ҩ��o��\D?�==�>����{�'���1��<�#lÅG��i��AQa������x4^]�[2%���鳢ܛQ�V#SNĽ8�Jj�Z׋�_��	�!76�U����tk:Z05��D\��p�+����?��]��}ͻ��[�\Tz��e��
Y8S㮜��e�e���3�
g�q~cO�=u3o��o���r=Y�y�^*f�l��#K+ҟ��xSJT8��V�}J���ȶ�������q,6s�$*�#1#*L�-� �2l�J�%��#U3���Ή��0e,�Eԣ<����uUj!�c��l\�6'�d��p%�>�y�{�;�vo���׀���t6$2�+��/K`��D|�
Qa�WN�$�����fW�����PU2G�"�HT�R�R��*>��o��}:�D��Q�G�"�$MTR����86ou߮��l�ZBx�.;����+E�	��wt�s"uGTX�����Pw�]��;���p��_޶p�$E�$�3��
nk#u۷7�fH�U���a�}�=����ma��@�Փ
�DdD���2��U�
!X���c�9�+W���z�2��t:��Ŏ�0�d��D��KT�7�,����+�t�|��O�����a|�mC�R� -�-*':�&���Y��u?w/��}�V����N�
ntUUMNt��2TᬧJ�O�\BFXs� �[���-��6':��U��0����߁P<�>�9ݮ�1�h�:L�C����U��Δ�B��B�U�{��{�^�i��K�k�T9����I%Ig���9xLcK�����xlR8���X_�`ImU'@l<ʽ{�WZ"U3"������ CRa���y��������!�d�����f�nEU�9��f��J��q?�	r@6�cH��!W��
W���9�dD*i��n�_��l=pEJB����۾���)`{E*��V��$�]@D]\"u:�V�\G$ D��DCWRo��
k��5;%�tEf���"hIb��iZ�qt��
�̓����j��88 ��+�Xah�wK�-j˶��as"��&*\*\��q����C=��>c{����x�"7�5�Y�aP�qw!R��v
ӌ�G}���xڿA �������k�Ϯ�T����g���|����w��ܿ� �x{>��o�ڽ�����?���b��x���>���̐æw��U蔤"�$R�/�[V�$�ki*�s	8�J�x3Moh������nrE`ґ�(������0�CS�Q+�;�@=����f� �"f���1x���.Z��
��Q)V@�[
k+cr"��8R�:٤i�>m�M��0?���Ϗ����f����2�Jڶis">mCT�8�>������h;��f8x��Ń��ر���!�
dj�M)�	��1"�J��UB��C�42�8S�uC`bA6�{apM{!�<������#��=�6	ٛȳ9�~�XMs�!	���Z/�J62'⫃D%������
��>	0�λ�� �S;��!��)mm۰8��#*��ls��M>_w��Y_���c��������G*�yjE#�L}���������������M���:���?8U�u��_Pc��0L����TĿD��8��;;���� 8��l	F���+<UpO+xuC x*:���$�ol�{��k�����;dkH�!�R)�:b"�D���', *�J����W��W�ߥ���?<���m*Z^��z���V�MN�c��
Wf��ܒ��G�a>�Jf�a�Yb{"�uԤ"�R'R9�*����t�3�����1����n���
�B�B�Bn���+�Wj��Υ�i�@�9����d�����;�8�}���N	��h]w`[�V7B�D\�G���>�V�؁6���H�rV�wf@���O&'�bD%-gUp6�8���q�xe9�Æ̺b�]�OH�ωδ;�*|��Ђ>߮��2���h�$m�����J?�-'��H�������,���W� �1�xT*K[�c��v�଄Y�D£�B�4�fH��]���&3��2�D����k��S�@F*�B��}�}YnVG��`��P�+�4ڔn�^�eHD|݆�����*9�|,u�\8��r��,�g��4�M)�C\购��()t_�$*l��F(/#	{�־��y�\tW�IӪX_~wyv�������5��X3"��G*)�ƀŴ������0_.>�B!��!	5� ��nJ��l�q9�H%�S��h��qm1�z?ΒBG�S�D��($!��1N������095��&�}�m�33"��z�S�2>r5��Y��i֝�/)�&�`�v��)�4�ɉx$!QI�K#�|���ݿ���oL0!k��=�ȅ��Ow/��� ���_	*HD��/��J�iT��"nk#�4��%1 ���+H�ҫL�2|:j߈�(��D�U�U8�M`)���e�}���8X�TR�/U	?�YS    �!*,��{�w�����^nG����V	I-I��O�:�%c�UNt&���|m�Km�J�[��uc�<u��ۆ��[j��W6F��IE\� RIJ���uy������� Ґ4�T���!��q�ȸ�� Vd�]*���$}� Ʀoz=�N<�W�a�C_eâL���X��Vc��D\�&R�sx������1T���;2�9h؊�҆����F���,�'�3"�鈨05 ,�hD�����ϰ�pj�ш>�nϋ��ş�����t� �N�x���%����GD|���U���쿾�>n�)���T���]<ɉ�LD�kLT�F����5m��_`�8��%��s��m%tNĤhb-�%����6^���8\v_�=uX��Ы�Kkk�m�@"*�C�0�a���ӬM�2�zjk�^BF�?BD�}���݇�w�;��P��w����`	:�-&_�~���ʉx Qa��iH��jB	��jW���Ԫ�9N�T�NVpmzVͩ�\��{(�������<r�s1�)�����0Ft�<T�r.�$��e����Ν�&��B�o����p�eN��\���ZU�e�?&_�>�~������a"�\!�QX6�/�O�1��+�۬��V *,���{��/��i��%�`�TI���h7�{�R�(0qi�H%1��=�Y�����͖�	����?������k'iS���X��ȱfr"����$kŢ�@�?4����-�6k��Tϖ���Ίx#DTX#d�#��7�o�j���p�M*:�߄*lS���{��ޮ��	��k�#"c�=�CS�k���\�}·֕�*���H� \!ׂ}oN�'��*>kc{$
Q�m꜈;k�Jz��շ�'�6R�ܛ\�Z6�p,�[�S��h��N�9u{]���kf��e?a#$�M
�Xì�# �g���3�P�)Њ�ީyn>��̻Ϙf�D�@��k���!��F�q��m?D%E��&j�W<�w߷Ӂ��$q8����U#�h�f$:����'�9�|�-W�u_���f�y�E�'���*>�B��T�ev"&�#�?�1����rL��ky��7gM���͔�l*����V�N�#D��Mf�a#����-qg0De!MP���R��97FY����:'QIw��w�i��8@i`���V�)f�vn�ϗ��L}Jla�x����"�dE�3�͡J�bF���d�r7+�[�ءCI���`�_` ���͉�&Va:X�:jq[!U���������v���.Q8 ������i6:��d��J��8��V$M�u�}y	��/NX��v�K�y�bME�v�UG�)f�-��ܱ��Qn.xLҨ��*qN��x8p�jE�|W��o�����2G��5�[����@��S��U�,���9�G*\���X,2t���4��$57*��*amNt����Jӕ�Ɇx�O�kQ�V��UF��:D����v�M&Xb��Z�u*��*4A��7}D��ň��(p�5�F9i�T(˶ii�OD\�/R��ױh`������?�\��[w�O��n�I-�)z��� 窩r�3E�P��h[�����;ֺ��Ĵ�7mZ�J�Gq2"�i���M�V��tM�07h�j�+E�\�̾��"Γ�T��X�?�q5M�,:���]�6�"�E���-�bh`>��ڕ>����`IR�1A8��
�\KX�S��T8~DR�D��މ1a�-��t��ɶmT����i�A0�c�a1��&!}:M���t�������hg��G2�!�������K����Z�na��&(N��O���|�{�Y���I.��bR��8�g뺲9_� *	�V�D_����1B����5����6~U�����=R~E*laݶ��_��fYt߻y�<�pb2[nE/�l����Δ[C�ܪu��y�IXXnm\�|��_V��_��C�R�I�m�F��kz~�/�o}t90ϋ~τE���:��Oې�,1�U��8=`	��Hg��Aa��7}x��xA2�,��*\or�z�����yl����d��pAzP�Th�
��9W��T�2y����|�B�߻��,�W�A!���m	�Z\H�D<̍��[���R��և�i/Gg�6��љ�W�§�L��CH�ѐ���yE1Cĳ�Kx�I?X*�e��1�X5�9̷8�d4�6�����`�15�q3�q�cS�#s"T�f:x�属�S���z��g�u��v����84�̉�bN*q�<B�q�AJ{5�~/.W�����h��
#&�A8�5ULDܣ��{ڂ�O3�?����sd��(5�p�	�_v�C�H2|<�f��B�q$��M�W��xJuC�<h�S �0\
eZl��35�P�kF��#��NCٿN
?i\�	�1��co]�]i�꜈��G*)z;t����z7�+��ik�����Z�r]c*ˊRKc�q�H�K"C�m�m��_��K����z;�\-�!�M����C�`a*��N������Fp�~��'��ԡ5�p�s�Ь�)����
� Y���BF���ɳ�}V���s�s'�	����� ���܇&#��-�`�-f�z��e�@Nŏ������{q�/�����̀kL.�@7���k�c�0Y�fH倌�����%�
��S�\9a��2���C[<�gl���X�z���7��4|b�H���mJW���Ն*l�'>��!i���Ƹ2�����t �ҳ�œ_"O�BTؒH��;���~�3��N�Y7���f�ʍj���9j��_%Q�V������L٢�@/W��z2rsx���c]kʶ&�"	���Lw��+�n�8��P��i}R�WT�s����JΤd��
������i�G\SmhcRܞ�@[Z+�S*�;w�J���%��"G��]v#?�U�mIc����
�12".M�0����j3�s�YvŨ���!Xڨ-ӱZ���6Y��!*L ��3�N��q��2g�;p�V������wB.��C]	p�D�=1]�x�M��t�M�O-@vis"&����fEkM�]�&��f ���y��t���x��0 d%'ңt������R�)��)����g4��(53&ύ�sMX�L���G�I9�l!��ۜ�L�m��p����$�va������g�z</p�5qӁ�8fJ����͊�o�0p����s����d5��])ì"��nr��X�h+8MN�e#�����AW�$g}^6��%�;��-���VG=�T�s���#� �a\ު��G�o��׷������3�F����S����D�q�T�t#8n'>��������{�`�ˏ�˳� F�s]�ET&rS�UUVx���K�E*i��k���ꮷ���⫫[���U��LY�ܟ��bEms�3P�P�k�T�,��7�R���OK[j]�*A���30�P�C�p�`1�z�t� �Xx5UN�Љ
[@W�wG�y�����f݈��nfJw�"�ia��F���D$͑��H$Ԓ�ڈL�Jx�8�`�D$\��xz��p!��p�QrT�P��y�n��X���SG&���r��=�I������5�C�Um��"HD<���mHU����b4�n}�g>�����m�|ꐽ�Akc�|MU��T�㵉
�v  O� �-�X)�G�]�ڜ��X�b�� �:^�������q��r�#�R���R�R$s��oe *>Z�a���|~_���,6�O}ZфX�xZ)f�Z����wJD\�+RI}��4��W�����:�e![��!�ʊ��6Qa�,d�O����Ḷ�Fp���6�S�����8������X���a_������p{w�747��O� �&éə�
48	��.���zY�W{4 h��*�RZK�<�;���%��b�)�. Qa��8�8�L�=L�t `�|����c<+�e�4�i�UUN�yM�
G������R����n6�5^��AE��$d2�x���W��D�H�5���!i��Q8�t7Cq    ���Bt�y<�p&P���^/FȜ�|��7��i`����z$�Qa���}�"dn���$��LZ$��U9�B.��ʡEr��M�ͤ��H���6h���Ԧ"O*�rX�
Sӭ��M��z��hs5�����������R`���c�� "�Y��\�H�X.���{��^vn6bM�7&��B�(sx'��͉x�Qa	�`��Nϻ�|�
�n�_]�Ƅ	�p@'f��!�aS3#b�B��ʾ�b>�۹�6íF<�����C����A*klMF"�KG*�]TV����d1�����K���6铽J���R;6��ڤ�+����*<�~���v>�^�֤��1q\p�ںQ&+���D%]a�"�y�(krP���ɤ��c���JT(���i��0�AoΠp������-�t�j[*:Cx�0��cđ���]��^��v���y�Z�:1W�QN��0Z�AF�|�X%%��#�u�^�k���%T/À2�W�V"#�\`L�q��H��W*9P��|`�דX�񐶔�C��>�
u)E[�"	���F��m J7�d}���dV��$ռ���h^���jI�A�R�a�	�
S�J
���@i��>0z�@�m	]��K#EI�@�B��W���Řa|��>�r�P�4F�M	��A������
�M�!������{�<%*�_O��i��@j����LZ(TI��m컍��;|���w��/�湟q�D��6'�c�µ�!x��\N�#GB���]OF��v
>�l|	��bYҕ�,��ǣ״�5H� ��&���̩{���f��J7r��������"&W),�:ˤx]PU�=	�yѷ�$I$�sB5�d$�6JuJʷ!%ӹo4��+*�����'*l���d�h���E�?����D��CetetNt��p���C����֭��8'x���#Q!��?
�]�$�"�J�0YX%&ǘ��V��ʡc$�o	dԝ7.ҴuՒ!�0�C��F4�ux��箸y~ݿ�wO��1_�5RN�`���i�JE\�4RIx!����w�-{ Do�n���sA�d⬞��ɗ�>���q�BE��HĻ�D%��V���w���_^����Pۗ�W���w����{n�э1�����HWm2���{��֪ir"�2E*��#E� lT��*����ˀЅ�n�$�"HU��~76ߛ����H%]a���H�W0fqd��v�����a�ݶ��,�g�+��jU6���y��`Fx2HF����g酩���Ȍ��V�>�`��q>a�h>a� 8	���>G:�YE"��]�޶X�p����C$��;�UM|@K\����=�Ψ�bZ_�w3#���x�'��,gM�k�Lz"2'��_���RFL<o���0���t�e:E�ڴ8T��4�?�Yl�����t�����"�c����D�����E��l٧lў�0\����{�R�rәK;u)W��'22�b�3nFJ9��A�Y@H�p�R����K���^�9����"j�O<#�ؿ��G�tq���S�ķ3�G�(�t����b���
�@2��e�O�d3J�_V�G��`�T,�,�(���,b�7yŭ%�k��{�(�+�+L����qTІ�կ��[�	g�4==>�<}y����v?�I���^�r�t�<��l���ֆ�k��6�J�8m����/M�-�9�^���Tat�=ԙ��N?���<�܅�X��c��B6?���|�u���0��1�u��j&�g.��Z�b�as�^�7k��\W�0��3̶�oP���va�Pp�a�|��J�\�d���g~�z�n[3qwH�r\�9�!(��$j�����{���"q�|G����_�h�T~�+��To�E]k���/��x~�-�`���`�KՂ|ߤфܹ��g�9��x�qaM}��kGֆѿ��(�m�\��Z_���"+֬fpS��\W��YS��*5tr��j�[�5�(J��?ܡ⬳�^��g��2�B-l�Ix~9�`@@�Qj��[�:�AX-k�32��GmSB�c�	_���n\��������}29ѓ�R`�e�~-웾j:�eH]x,Cw��^܌-D�W+,b��IZ�����%��:��f&�2�\8|���T&��@[���f�����l��l�s�&GA�����D��4��~��ҭ��;�e��"�f3��|1N��ˠ4_ �"���%x���
�ۻ��L	>u�K�:j�����X�w��B��T�]:��v�f�	Vĥ|��U�V	���[�c�~O�����O�j�q����� �S^��oOҧ�r����nW����Ҕ:'�	_ ���T!�4�y���]RN��a��L��5��� q�z26�4qZZ�K�"���I�z�9�D	�8��r��!2��ז�bt\��}z1�3��ԥl�x�X�N���0��u��)��`�M93q�O��QO�p��wP��v��u�i3���8w�\��Aw{���w:�
�p�Z�lS.6c�3p�R��u������S�<,/��:�Jmi��6,�Y�?]�H��E��5���	���+ěFVj>��SeLL;8\�s��Xx�J����p��7p��~��FT�Z�1:%�g2-��P�Me���V�5we.�9$��N��j�{�RV�!�[��g�u)�11�P��C�2q�������C�J��S���7��:l���̈Ǧ�s(rB�g[�·�?�{S��!��\��JЗ&��N\X��Q.��n���u�Z��Ű�2�3�$�y�L�N몉?'�{N�i�@�<�7���r��?����_�E�����ǘ�5������.�l�o/_}�+��H�c��֟ff�]1&��A\ʆa�K�$��*;����X�-N®�x9���([eO��j��Ѽ	��q���p{;�/#@�K	&�k�\e�gθ^WMg4xR�
8w�N�>L���Tuiw/�2��x�ˬ�F�f�ڀ��en��m NX��x�y1L?ڗ [�������As���j�e�Aj:SH]8�Vs���PG6���c�8�������g��H�+�r}aDz�;i ��k�b��K�\_V�z%���?�7\a�HԼ�}��a��WޚGLb������U��>�T�l6(3q{"s)?s�l��2����m�d �kNQ��f�N�Fwi�*V�K�J��/ĉ�]�`�!�\��^3q�2s�%�I�s�eD;-�^�h:ȷs�nj9��O<ʺ�B����`܌�&g�v�8�Ã�5*�|)-��B=ʮ´�X�[��ȡ�0@��������=�ն�u�~���bCɤ�z�\���r�Lﴫ�x�qa@墅������pT�R�Er+�=��8�
�0&��B\���g��X���1MZ(7(�WdDp֦�i�i�j�3G{����l/��J�a�p�߮ߏ��(��R�b��F]�6Zݫ�f��̥le{��E"�L֦�?���?��8rNR�X��p�Yr×&��\�/Q�"����(ߊ��������@�S��#�3�P����`e�p�8wVI� +r��cq	��]^�%&��K\8�9V��=`��Wde�
<9f?�����Kk+���g��0��9�Q�w��~������}��������������C@�wAWl�*��o5]��3m�ԅo˴M�]���LĂ�:?r&%��I��� )R�.�J&���#Ų��۳}�����Hs�#�UO��a5~8/+�"ѕ�D #^��$�b�����gz��d��x��������:��EƱ�Q�F���V����X��n^��������և���������@A��(��~|{y{�
�i#��*�c<��Y2��p�ԣ܏Ȳ�:*�J�9�X!qkf-U�,M<����db��cj=������]�C�rY2,���b/��T,�.A�Q�Ѩ����7 ���H�3�d�l�����@�©��5�B�\
"$�.N�����cm���rl��_͑L��u*���c�R���t�l����T��a�� /�KU��    i2�E.Q�t����o�q5_]����)H߳�3�"�y�OL|�B\�P�4@>���)|N�6�1��uq�� (�	Sg&��\8����F�l�9�kN�����.@�`cWM�$E�R~��O����8�+N!����y���Ӯ�����9��ͻ��'Y�̴���nq�}��}����(O��{���Ai@��s�f⾚̥��A� �N��������%��3�����eګ�����Z[�≉/s������T�6��)����n36]P����I������Q��L\���0����|%�MRٖr�x,����V��f���p�P�v���v@��+�Ӵ�T���=���|��`;u5�d.�݃�v8��=��;�;�l����/�ḻY��x)�3��c�������e��#����wr|�Z��%���ڿA�ڠ2u��xHq)߿ſ���.P�o��#<��r�ژ���q~ιũH�ʚ�C�d.�O�g�?q�i�6oS=gIF��A|�&�u��Riib*��K�v;l,L����H��!)�0�l��;�G�r�Ib:��O]8T�n'�>����f/Dd�o�͖��&�4s/d��U۫��L<��pLs���Y���J�����ۢ�V���oN&gh_����j�c��?�H�蒒���{i�[k]5�QmJ]8�нJ�M*�X4��p�\3�����^qᚁ�	�8r�����,W���$~�Z�3��4*,��RvM��m��|��(�/hi^0�\��������B��҆�K�m�I�3��6���,��U�r�-�x�]�)��*[]����Ϊ,��L�V�\���Z�q��EJ`�?e���N��v��L<Ձ�����SF@��K��;&t��l�F9c�c�*�3̕ă!�#�"6�����ս�x�|94o��~,����GO�Եo"�33�k]7�TM��R5�4[�˧���|8�D��L�l�2'K���\ʐS����\�����^���2T>DZ;*��9�ڙ��sU��U3���ꯝ�7p3MJ#�LQ�<�D*׻�:HMg��ԅ��I�n�zP�?x-���ix�m�5��6�T"|�����_2*Ո,cG�O����C0&.v�\��Q8m�4
/Ũ����\�@��ݩ�����xq��E=RN�����E�"�|����m��)�t�o���|��*���m��v��F6"d��#WBi�B�Kُ�pv��0J��~@;$�w�������X�?��b!�z5 ���.P��t/s�rP�(��(�3�����<G�ꪃ��������9�hc�}��\���_�4�w�%!�t�V�rT|��^lQ����>���
$AL��f�]"l��8��{�N�v�����`.��U�6#.,�>�n�owH%D=���n�����^�����Ak�gа]G%kg ��k&`F\ʚ��_�����n\7~,�"�&����:#�>Y>��!.���f�kĥ\9�9��HJ���.P��5q&���? V�n�e����?�4��4`]3qIA��t�L�}��� ����o�(���0�D��[���,̍�T;��A�!�49ǁ��ㆸ0������2�k$\��$ѻ�ZWY�W+F��S���­�zp�Z��b6b�(�j�쫏���l'��5����Ʌ}���y��V?�����+e藌y����
�)v�4�	qa�r�z/����$�*�Z�R�I�n&�&�K��̅[�]܈x��n�W�$�H��Wu5�[!r��L<����N��b����Ƿ��������pR� ��ƈ(#������ȣ���c�0ҙK��	�Q�a>�ux|�,���7=�L*��N҉m&-0ND�Kש�\ʵI_�ݟ������?�IFTȸ�>eD�G[3qJ��'�S'�&DH��
Zy$.�j�N�k��8ޓK�7�����w�ˋ�)ր��6v?�q+�����: ��f�]��0~�)�:��Q�'�������蔸�Q#�%�OJ�lw4�G�q+H�����X8�.���!!�M���I�A��OC�x`����
�j&.��\8��v�o{��⻡�ǰ�<�!rw����2Ԁ\:�-�V!(	g����L|dI\n6��5٦��b��W&D���.e䖦b5�K��u��C�'ت6��=ʋ�p�l�@f��ą����N�׆�u�n�qu7n�K��`Èty5&P�+5�!w�.���E�\��:��|��Ӵz��ae�����f�K�ą-�a�A����D�G4B.ڊ��M�lo�"�?��ߎ	j�}���#2���l
F��y��gB[2��4q��̥\b�0�B^���M���hv���ꆶW���tF<,u�`��tOjp��x��b�;�C�-�!/�At�ă��SZ���O�(:�ĸq���<��;��s����k&�H\�K��%Qo��Ks56��f�B98�69n��5����>UcL|XJ\ذAd����2JJ��=ۜt&��o��&�w@\X��^�I��$�*2��}g��u"m-�&�������	']�pN_�./Q�i�Ʋ���f��l=��3�U�� �3��ԅ9�E�����`�mF~��4���M��B�15�QZL]J��'��N������������o�/�������kL��K��0!eE�S�JW3q�E�R�9X���$�n�a������ ,�D��0qQ�R�c���b��ö��� |MF�1X�3��BX����L����w쯊��o�5�!��wj���q�W���Ո�>?��;�j,�;<����6*Lܹ��0�VҚ.2��噔�����=�R�)��m�̅COA~�����5\���� ���[���B��x��Ü�F�L�)��0�GX������b�1�`��Q5���s�`{)8s]1b��9ą��2m�}᡺R����1�"�kE��������pyb�� ���2�m?�1A��"�reo�<ӬvR˚�ϵ�ۛ�!���a56a�X��ڞ*���j��ɴ��f�Ո��v,9�\�"���$F�Μʃ]�	���,IR�������(�������Hd�q^}@�kJ��`ॶ~�@'k�3�ԥ�[+��P��'7LT�>�b�)�@��T��!K��B�RF�="G%A2�˩�ԥ`&��)����k&>�'.l~/�9n����3ٽ�ՖS�������Ln�)^ą�x��%i�/F��4C�n����
[�`��I���!0��ĕ3�f��i��4	gl<�j5*���7$u1SX�c�Z��3�&������>ZR-��a�^x4x�q��ء�a$�4�����[��i3ý�s�1��qa�-�II3�E���D��O���t���r1O�b�ZIHO�x��X��M��a�E��0���?w]�������,]3�_:qa�t%O�
���/]�b��.e�Y�*eT�t�ؘ���F�;��=l>F%B�J�jR�Y�#���ҢKi�ąe|�-� UB^]p>����m'P�u뻇B�L|������	��.U�):y���|�i�\X�s'�`�x-�nD9�ʡ���A�7��0��N��b�zԃkNH��N�Pǥ}�����iI %Iy�)���rt�b�aԣ�����ɜ�f�sG��-��ʦ]���G�ąCŵf�U~}h�￾=�_��D�m"Z�����t(hq�1����p0R����̅��1T��<o�^��q���?�Z:���%�o��u���xqB�R.���&���ǹ'�%/����s�7;Y��*�����=r1���"'������=��E��)7��������ښ���d.���I"����D�S�e�^v��6� 1�8ą�Cdٵ�P���pw�NO���.,�'!S&+�g&��N\X�����tu���g�m�5?���ׯaʮ���64x�Ǡ�\W3q�0sᶡ�7,��j���!��l@Ü^J>�TX�t�8!4�UgLLK:w)_�N�H����P\�8��k��������K���̅Y�c�?�    �j�'jO���Fe�3 �ԅ=Yp6�I�����~���,si r�tY!<�b��|�\�����ąg��Ll� ?�^4�	̼}z�vxln���?�~�Ԓ�F"_�C1;kE��}���v������S�oD[ӷ�%�RԌ���2>(L\S>sa�-�u��]�f�w��n������)( ���=x�$�E'�&^K\�u"ʬWt�����z�w��;�U�cŭ��e㬿���A��	��bnZ3�HV��"Y�����n9�`���(�B[xq.UHgL<����0V��"�fy��� �t]���5�|O�شL]Xxٸԃ�%
����i�\o(���J?�ǢК�x�����ҷB�(�ua$��|�m�f;|yCm����}��}s�2�i)?�'�y���{M盛G���?�c�a���7���Ɂ��b�Ѻ*E3?�E���i[3q�̅;����Z�0$�����#���)�(�?Ә���W�!.��2�5��c�|���JF�t��Ƕw8���h!<Ħ��b�[�!5�ot�u5�j&.��4�"V-B�2�7��2���a)�"���������[�������+6�'YI�N/���aO����ih]X���zpH�;�/ٌ���X�  E�\����@�d�S5��I�R�J��i��4��ߛ��M�q�X�|Q>�e�bn��s:�)W5q�8s)W�s��N�4���Smμt��W�����F3q�J��1'���0^O���a���^��O��
�y$!x|����� w��xjU�^؈rz��'�qm-9r>�29␳��K@2.9¼8�����4�H�OL��c��Q�l�tf�[�ąm�#k'��]��C	��0-I�̈6h{_XCd����L\��������!'�
yCs����:k��<�����/o�o���5!���g�������'��#������b\�J��tFw!u)~���Q��2g�q�_�n��?��������M���@�\�8^6;{3�:
Z����2��T�ѩ�x�qap'HՍP��b�a�I�^J��'L('ɔ���G�ĥ<�z�i�A���~�4�]So�~��}�~и�����R3�D���J �.L��B&rҶ\��!���BZ0#�G�
$�̔u���£\S�26�lGMU_�u6���3�E�V��'�ą%t��v�C����˹݌���-~+��-<�����(���$�B8�D�Lp=s)���ۋ�����_�^ϡ�C�μ0�*i3��N�H�����n��K�����C��()��y�?!��j��pZl���M�s_���z���z+�����Xy4]������������{k���U_�m󃆘�������'���n9���O���	X2I��s4����N�Z�L\���p��i~����x��_�a�)�)S�'ZAdT�rƖl��t�R���@7NL,!]�7����ݥ���)��d]��k���e�� ��o�r]�Ħ![�v����k�#��b�'�hW3qwE�R|^%ڿ>==K��Z�?`H��o|R�,�1��,�g�8��L|3��0��@y u�4ڮ��K��1ٗ�HO��y�ԃ{��,c(p�Sޛ�ݸ�F�
��0J��?h�Y�_�&FI\X�1'4۰z���ո���֟i�S�����
'|̜����L<'����Q��x�k��Az�]�ڙ�}�!Ę�O2waz��ͤl�*c:�ȵ�f�ކ�ވ��,�7}��^��������³�E*��O�`�O�CEu�	�5�/�7(q����|����[���*N~���h�rH�����*]3q��̥L(��9M����pv<g�*-_�s�J�pΐ�/F	�p��κ6!c��r��^O[�'��<�?r����	�0e�M����=�\�s�k)m��L�>)qaD8՞��&��#�N+��K%&~1ą]���D�#!g���l�<�>};��<jJv��Fe;���fd�V�L\���0J�����p%q�KU��0X����b��¢τ����������7e�V3q��R�g�/������������0q���~���!�ý9�$Ҕ�Փ��=u.0F9�k&.�\���>�e�Q0B�݇XGu��5_}&.,w_N@(�ii� o4����ñ��ߚ�Z%.L�5$��rl3,�/�oBy��P��4y�����Ӻt/��b��RVXM��Ԋ�m��ν	�w��Z�Ĥ=Ri��Dn�3���x�	q)�+U1�6cп��������g��#��0��f@_��ɲ^�I�Oy5_��nU���J*��VMg��ԅY�2#�v��8,�8}jz�����y�R���"�j�;ąK�m�O�0���Ûa���"�KbJQ��)Dtt5���\�⡂�'Om�0t�b���:/���Q)Kd<UWCt�U,�(Q��j�o�����Qy �Y���s��78��/���9�	kS�Gi:��ԅ_��P��z������LV٥px�!5XM@t�!��Lg\S���AWW��Ҁ�K	��O{Y�X��������9�5���w�~Bi甫Q Ft�Z�9�k&�R�\�)�����V����0��Nl2�/���b��ߦ6i��1qP�̥|�XAV�v�!\,G��pi�'��=)+g�y�`��$�ݕ&^-��0��'d��N�ݥ���|3^�WMd{��Hڟ�4oP�� �2.���I����b��Т�f�jnLh^���d���e�ڪ�9���&>\#.ܣ�p�L�����'L�7���<��g�|[2�5��3�	��+�V���L<�����	f����9�C��P,,�7������K�OQ��ye��j&n��x�7�l78�3���w�aV��Bd��59�>����٪�c3u)�x�+��\������w�&JF�@v�'��y�����i*u�{ߞ45�	�qx9�6��]�������������C�����Ys��|����������Wl��d:T��ƌ�YדI ��c1d.�v��D��X��8ŉ �IM��!e�˜�GLyA�q):u�;�7�p�\�(Zp�u0Qz&�-	*#m�:��L��)q�*���٣���ӧQ ��E��?'k&���pX����KE��{8�>yQ ,�"Gd�A=B�cm��}[3��#ĥ|�(-�:h�
���#-�'Kؚ��ȴyI-3����.,lM���U�mWa-`�		�3凑�L�ў�pG;ʑ#���?�c�ݑ��m$��C��=���m��G�ą�{He�Q�R���v�AD>��� �B)���&s��ߚz0� xd*W�9�n����o�ooo?�ڠ�Y#��j�)Mg$hR^�Fǋs�}���V▅/�J-���3�\��[���&��o%���y�{���y	D��ݏ����ZtDj�4�* ĥ|n=܂]���N�k�z�)C�4�B`��/g'�ca��b�R�	�5 ��k������o�~Y}bD����ɓ5��%.���H���q�\�7�2���x݇��b�]Z��	.�,�k�sKәt2u)�����F������|�������q���� z]���z�o+�ɺ���$.�S�sR��0l��@������Mf���TU�tui��]�#��2��X����f����j��x<I`�_��Z�Y.�u�4����~e�����k$e�>�&	�T��"u��q����5�d.\�#���)�a{��4W���|1�m����Κ�a�8&�!.e숊WF�Ѓ)\����Xkg}'U����������2�K���I!'�t�|}z96;ᗙf"Z�Ӡ��_gD��E�ԣ\�������� �����~�I);W3��m�R.�E�)�Ƕ0��V<�0��Aғ1���'��a�RX���@�ǧ�O������O�͗="Ϳ�}{bҺ��.r�!v7u��̅[�6N��r����_�$#�ӹ�~�sf�U����G\�-�M2�A"��I�!Qߓ=x��L�Rqa�߰Z�5�u�    NT�ZsNbT⇏���5OE%.,U���Bݼ�@2<���)SҤ/�1���.|���B����v���Ͻ ���(�aϘ�$��W�����BU�Ӗϖh=�<��=�oK��&^��p�;�A��z�O��b��
���j���5w����l�!T���C<�CP�zek&.��\�~�TS]�b���-��l~G(�_���K��
�����������:s)�;�oR��n�c�龛���S2�,�����Ql(--)�"~t�5�i+��fL~ z-��sOh����?}�q�zxE����o8�!CH���g�z�����6�N.L�����#of�6��zK�f��w����#U��8�{m[7�N���L�>sa`�/ИݬvW����+i�叴�*'��]�b^b� H�Ք��?�{���:���f����U��X[���K)����m:ԓ1����6{�G�����~8��#cW`�'�%��4�� N]�=��6��>ܬ7�մE-�傂� �gW��1AL�B\XAA��Q=�rVï� 1�]���d����C���f:�L]��WtK�	��<絺^A08>s&!�V�f�+ą� eN�ދ���ʹJ_D�����ʻ�ڈee�y�����qa
�K�.'j�p�'��׭R��"Q����ʬű
�1�cĥ�
��ƮN��G�Uؓˀ��픎d�@yx�S�ā`2�rm��Մ:	�֯���< ϙ���(���>=�C���W	�1Ԁ�Lב���p�U��@�U�;��aɆZ��.?�y���T������LtIƮ�Q��4����gpJ����P{��@"����Lg��'���z��B-�(0�6A�b��Q��\Z�UO[$.,mQ��x�â���dnM9����CQ'N���Þg.e��}�bu�.~�l�Z������U7�|_�������2�ry�'�Ң��!B�y��+$��K���ΕK����W�L=ʒ*�q��Mxlu���߄&�M{�y�WE�c�)�4�Hą)���YD8�u"i:_�oָ�&�V�f�n�s�ފ:�<��&g�k�raj:S.L]�b0����%�J3]yO�,��GJә�|�ɴ�A��|�y~�xU���~W��6T�|�Yi%RSi���K��<���o�Yb�k��{�����\5F[T-�Qy�j�a�ąk{
=�����M���:a�"�U*X���e��t�Zن��<~�0�R�<9��՜����`*xQ��C's)ٍ��@(��������YR@�6o{�L��%�K�$�v�I2�7!���fA���d�j&M\�'�����v��aN��w��(=����YS�p��zp낰 R�|F�,8|�GuW�R�JuW��0�:�6;c:C�I]q%�e7�Xv�J���wU���6�� �V��پf*VV������=�]HLơ����c�l�Y:b�/��g�Rizʘ�|���iP�=iU|.oF�R���Y̗���|1DfLGȇ[	傌I������='P�0�+���_�χ��E-N)�2_1��K�k3s=��5�32��װH���6�IˠqW����Y�N�*M<q����]Ջ�FRu�h��9�L���ښ�#.e.���u2b��\z��@��4��[3��6R�r5���wW�*�:�I��4U���nU6D;3�MU��6U��P2w��$ô��Fޤ�ʴ��a��t5�D .L�F��ȅ����O�}�E����E�~���b�@k�Hy(��"�]�����C�S�� �}�&,������/��x�oN:ܨ�x}
2�"	�
�`��s�N2Kf~&��I\8�`k&�X��_����z��+rBlK䛊N��z�F	M̥�;�3n�z�;vꖣg�f�#�����f��ъs/Si��ġ�2n�r���>4/o߿�?7���u����S�\^ۊ��n&��U�tF&u)k[�	�w�b"lkX5i�k;�.7�O��^�t)i��� ���ΒdO.�J��=��J�qqZ�gD�c�&~qą[���8O�O��܄c��1�:��"1�"q)C/�zN�a�Hx7�pc�pI�y���@,ݬ�㋎��MLt���%A�Izy$<_lV�'��3�)�fP��a�4i{�7+���6ua�Z�Jq)T+�OUz˻Z�v!��&@e&�j�\���/q�����?N�c���zz��P.��i��ByG�0��&l��U�O�����(O��Ŵ��R�T�|����z�����xW��4���զ#���6�.�V��>/u�.)�ب�����v�����'��q4���WL_����CL�M��L��\�.�����=l�3\��~;�a����z�a4NVrJ
W���ԃx�ۤ>��l���ɦCHB@�%D�OT���}��=�(����w��������q5\�7��`�V�s�Q��"�`�����\��G4���^n�;������)�a�^q����~}z���BX��s?�]~��&�g��ٴ�V����Rf�>�����|p8�r���tx8GO��T�1$m5����L\�;s)�V K֝���s�x�J�?�@���I�^e� Hl���؈����A��UP�+���W @5B�T����L\:��p P	'Wl\�V��LMqF*�O-�}:Ԗ1�RYą���Τ�]�J|�8uH'�r����c����X$N����x�3qa��b*�G�.�kH8�r�2]G�B��s�E�\İ[W317A��Q���2pY+�� �yMZx�W�lMQ�&&�&M\ؚ��}�S���_V���F�*�3Ϝ�NK/�H\X�F<mBf�,+��M����-#���ė�GoU'I�z1����x��x��L�^��]Z�:��&��J\Xj�lc	r5�	Oq�_y�cz﹇p�Z_K�jߖֳ�(2ն4q�̥܁B�b��@�aj"�T;�xx^j���+��Qn�a|ql�4�҉�i"g���������+��:�65g.wS`O:���n����A�Q����[�:������/qa�x����f��w͖~�3�"8y�K�{��L+eL|g��0=/8a2 �v����bw3�������(�f�^ #M�c,b�5iXQ��HS�.�4E/,��VW��|��5+2GU��+r#��D?�4�=~N.%TU��T]�]s����x�Z/6��:b���3ڋ��� 5;�ɚ�Lv����Ywү�1�����j�'fbp�e���S3�18qacp��6���1�*�^�f
�}߰NJ��2�&R�+M|8I\�p�\�Η���?������bo�#�4�x�����X�M{?��
)Uzuy����f⒳̅a�"NEs4�Be���)Jt�5�*�뺼-DL|���p�4�h��D����}�2D߃*����S���ˤ`���HI��&>#.l
�I�`c�
%�S��")R�@i9�6M<خ�����nS��߀����u���.,<�:�`����I���}�>�C�0���`�� ����N�L�ɓ��G%N�qq�D�)�y���S���L��5ә�b�;q�[Y���a��Nk�N�M}���kB-LgH��O:U��z��j]eY��u=��i]3��9�.|͡����iY����^㕊 �S���L7u᨜RN#6����l �C�8�i�dglFB�kz�eE���U2��!���F��ʏC&A!b��T�ڷ�-�Qmj&�� .������������l�1$¸;�Ӌ�*���L�#uaCX���[�źW�<� �Y3¶R�He E�e+��ZW3�Y=q)d ��\�(D,p�>�e�|��|?<ҩv�?'��PR��R���87ʋ�@�nk&n�f.kW
�*�n��q�F嵤��h��a�$}��}"�
��?���x��R�[c���O�0��n\L��K��KV��N 9�lE���\��!&>�".,�Ƙ�mWo�oߚk8	��H��c��*����~v�P�EZݷ�+M=��"�S��S��2�1<=�w�#��o�hI��[�g~��٥�.�t������ �S�g��    �i.��ỹ03,���G�HW5l��Z�p�b؞�H���m�.�~�_7�w��?I�J��#Lj����AL<���� #N˼��s�/�������j���� ���Z��CE��gB���0qGB�R����G^�|.��񈒮s���6���J[w���L�3���c,i�ۻ�|@m��e�N����:��u(���J9Y3qIM�°����im:ִ�w�vܭ`�n�Ms+խv�&N�TA�L:�+S31o<w�V���t:A�������CX�e�{R�/%�:� ���j:�M]XM	H4BL�y��ñk1�Cm*�w�?��‽VтzQ%4(�>�#�35�ă/I���`���e8�c����\���xQF�2����a�S�	�F"f��:*�?���锭���&s)O$a���a�rX�G:���Q`0��4�i��Y�xq�1}/�iw���a]�p%�Ve�Gz���ߺ����d.�q�	�4+1��l�_U�Ys�� 	i�t���L��^,]b�Z�	��D��-�z0�g�GLNv8�Z�7X��Dg]�0�>%g�TM����t]�얙��qᨚxl��SFf�������>.�w�
%P�d׌�?�S�����L��)e�l*cf�j��ǀ� u&���}���qh:�o�'�J�:���Ϥ�(������p;Yet�Ҿ�G��L�8m�]!i*׶��"����Xi:ӶO]�����ᑥsz��3"�Ʋ2�o�&��C\؞�б~���ᄸ�.-9��^|>^dC�����7|�.&CVׇ�7tRS��-�p�Bc�j&�R�\8@�'1��݇�zE2����y�Ѣ�V���C����Z�.}W3��¡�d;���Wp ݭ7�_UPwq$p<|�B�k2�bIy��
�&tp�6G�e&�M�Mh!O��s�mQ( 3�y�:�g_H��,��~�j?�A׺j��+�R�T��T����k�l��� ��I�/�WjSZP��,<t�Ad�LF��L\���0�5^���ָ��a��S{ql]}yz�z��i��TL&��7Z�a��L���a갇�����.��݅յ)���d^������+�S�`�@�XD�?�c#�2���q0�<{1�H 3�Hۓ��^lMyܰ��z�v�X����rd���)���>������@�z�qx~j��!����������3�\�t��t`�$׋ SQ1Vh�|��Q�/����Ϸ��a�����%Eђ��$>:c�Qyӌ���qa�x������u�P�������e�,M� ��0̦�_6~���L���k��2�
g��G�$��n���@�)Y� y���n�t���3$�ԅ'y�q`�$]��楫�_�ϰY��Q�i[�`(�(�'[�:Kb9SfI<����;����։�k�����<T���~��yE���#��ƨ�`�
���݌ˋ]�ȴTÄ����UHџ`L\�?s)˼x/��y���r���Qs
n��U����J���,�� ����(3�>餡 �(�.�A�k|��X�@��j\���j=kL�|�_���ru&D�9#0ڑ�*��L�� qa�>2�fKl��8y�6U�.U�$�\�IuH��k&��\(������CP�ۄa�Kx�X�IICH(�ѹt���5��S������Ga�al�#��mw>2BTN�Ј�K\ۮ�X�S�z0�:'����;_,X��;��d/�������6��z�@���ip�B�q5_FPZҸ*�q�{o�T��1�!�.�`�?�s�O�n�WLQ�m���t�ժf��̥�}a�-�;.F�3u
R���Uۺ��#d.��!�V�����W͇��2�z2
�'zX�8S��tROi�{^�G5�p����/���7F�����٤�L:�����@�R��M��il���_��^ȁk0FF⦝A�L����ae.�k�%�K.T�{;��/׫ d�����#w��_5��PXx�U������XC$yy�����ѣ�|�l�`+�U�d.�� ����������;��<~xbu��&��b�`��L�,!qa��x���_�[g�i�4�Yؾf�k�ą�\ ;6���P6���џR����U��c��* �.l�!�IY�����W;������A }(-�M����:��RuӼ���q�{C1��f�Z��2��)vLjh	�Q]Y����"6�e�ĭ0saV�G��.��f�=�:���8aP���[���871�q�B��EP�f�k"P�v������m�ڔ�W�(�HLTj�[����k#s�d!N�
����xlƺ9�E)<$6���3�]�������s�ɟԑ*QǮ��U�O[3q̥ؑ��
�،X��1�VĿ������_}�2c�"�������~�:������y>|y�UqE�$�A�����c(��LgD~R�2��q�Ω�1܌K�I�&��p747�2$B����v�B$X���]�t����0���=��y���53��M53�:3�Wb&��e½���4�Ԭ�L��i���R��8T�0M+qZ���Am'ZH�s!{b:��N]�]�T���yAa6̯�w�w��Y�i.�\޿t�m�8n��xSUzC���A `D�7%&oJ\X�)�"�*�߷2�Dr|&Ă��Zc��f��3��+�L���"�̤�(H�.��?����ek&��\���B��#�5�H�~�9��h��(|{��Nٔ�˘��S����s�-��J�_�:�IU�H�f�3�N$b��Ѷ��x�q��g���$삫"G���A�=�D)�F{��GG��3��ԅ��ߜ"�8(lu��X���y8J�cF�(:n��Z���2G�\88�<n�IY~�0����I^~1��@u���8�_���c��\��8��5_|&.l��XJ���Ӡ�58H.@MU�CT�
��:V�ģʉ�*Wm2�g@��YPyJ3ȵ��k����i��k&�p�����d�Xr��#vv�A�PyO�ቹ,掶�9@i�B�̥�7"�ݶ��k�s�r��h���|{���#�_4�[?��f��t�g����|l��xT��HU�NR�gc*�Ϧ���LgH��GH�����JFWj�q�ve���L�=��p�x	��Q��VN]9�t-=-�����H���ğ�ĥ�,`����%J��t��$+/
i�4y�LL|�L\�$B�p0.ח�rp���8^ ����$"�h�ui��4qyq�R�`��Ry�,w���j���r�^`��Vi
�������[��5�z%.�"���"3�{���|w���d���j��W�Q�����k&��N\X���ĩ�)
~nɏ�,g��)ߥ4�m�Rb����+�b��pE߮��W)沉��*��.�\��K���)EoN�e��]��2:p|�S5әŤ.\�Wa-��qX��W,~�2pKM�~�D����\���ۈ�ok{}j�a�C�؜�I��g�Y�ݱ���(uaY�J�� ��B�rb����ҋ�u3'�0y떘��qa[[F�A��!��=��V�d��@�֏��3����r�A!.�0Q�p|���aw|ZF�A�XG㮐(i_5���.%9��`�oem�ϻͯ�X߽݌����A?�>6���i�oOL�-�8�LkS����P��u3��'�U���`�v��:����٦0����e}��-@.�ă\�Gb�����<���r��!,�$VgT�#����2�r]��(���/�AO/1��=�*oʼ�8K��EAX���S�QJ�L\���p�c������m^�.���6�X5-��V������0-�Ǯ�xq���NE�L}���1G�w�髓`/Ld�H��fGi�BT�Q����TTf#���<�Vx���-�
SLKP�v&,"U�i�]L��Ч �{�N�<E/݈�-8L;Z����H��MY1Vh~�`�^���z���{�p��{i�|��'ѡ�uL3^��`9����@B�Q�Z Aŏc�W���"����}�������^^����?�*k>1��n    	_�4����>�{&��n3_�V�<�0�ϳ��g��pڦCMD�.L��
���B����y}(O"���92G%�
/��zpD'T	�����������vJ�!��+�l����W5�)��.e�E�d/;V^�3��Q��u�֏�1]�"xJ�N�®�.�����g��0���ce@�~���頚�t����8��Æ|dwC�.��0;���4c����#&~�v�AX#������O�~
�V;r����3��WZ�x qaQ �E��r~548�X��)�������x0�|��t�|>���1��_�7�LIK"�$8�E�,��*��L>�Ol�ڹ�o!8}�iV�meU�X�e :�D[3�jGą[�T�$%��Ct]X�U�C��;vx��mM&�&��K\XN����Z��DK�%���iol�Q)͐�饉���i'�0���[�E�aTJ
נ-[��#���B>��x#q�H�-�ǖ�E��m��b�1	�r������ɩ��򓄰������[�R�g���3���~4�O�?~}�k��ǡ���:�:�_��X8�$�"&.u�\8��T�0�L*.NU���ڵ:�͘��vq�DT��� a�Y�>N�9�mu)RВ����
DNj2��4q�_�R�W-���a^�o�اE��g�a'���*�T[����%<TOD=�F�x��i"�����3H��Q��EL<,��0de��)L�4^]Ť�E }Q�?=�P1�C8�~+U3���R���$j��l�-���J���+�b��J������3���R�ӻ�������?�m@����_��5�?~��<��Ғն�0.�|!]�\��7b�K�Z|V6jFlwˋ�&.8*��~�F�
(%x�Hy/�(����������=t>��~}zi~���y�.M�
�f`�(�/�npn� ���4}\����rRaX����c���#H�A������E������2����Ã�,��M6���|����(,��X�xDq){$�PJKn _�2�c�~>ѡ,�13�LJ3`Lܗ��p�
-:�4sDK�8��f�?��~L!���ΠSS��&�RS�>	��W���M��6%�0�#����@R*Bi��Gą��i�qQ3zw��K)A�,�����������RN�i�ٸ��Ś2E�u{��Yt�@?�}S��N�t���(u��G��{��9��z|�a4�&z�蝔����ʚT�4�L|��������Dz��� 2E%�s�4饠��6o��v'.�\���u=l�0j�M}�7�͍�l�p2�"gb�Ƣ�L�,E[3�Iąab�^8	�nw�S�fTmn:�N�(���T��$pek&��E\8� \q�0P�&���
@U��?S,�2���*u)���q��8�^}�������÷�ǯ�ϳ8$�Xcl4*LϚ�3X������C��J���}��s���'��l��-/ ���@�bd_31�܅+�!���p���m����64���K�a[9�mG&Ŗ&=O\��N�R$9�s�<�ÞG�[�$���R>�NI�:����qf�"�̥<�`��֐��Q��Ȼ��%a[��$(p��4�/M�?sႸ^w���0���S��V�!{�U��}�Ky&�P�:��vW�v¬���!h?�N
����q"�!Ƙx�q᠓-&�'6�����F�j�h[Z���O�sO�|i��ąA���ўG�q�(��
�Wn����Iz�=��A9m��x�q�k�ǹ��b�������zuu��#~��+���C9����g-��V��c�r���o��2�T� �Hږ�B�$���x�qa�:ǡF��?_^s�?B��&^����S�e�'&.��\8����l�����ƒﷄ[�s��ap�Q|�/���Cb:�a=v���?܄��m*��=ͬ<��N�yi:S�N]r�+_��z�_.曏p�-�p]݌�q=��  �|B.�����l�P�(��^�`H�g$&>-$.�⠄#�F�A���b�4��X�i�!�و<;3��D������Ȏ趕��e8P04�0����vp������3�7lʢ3���o��!g"C2KwRg.�J�v�2Yz����n�����|饊q't4��|�0��	'�Q��'�3�b�_#D�H���������o/�8!���O/�>aF�Grf:�٪�/�V�R�NU��;Ą��Ͽ����}sR�������5��so��e��w�S�Âc�������a�N�ZEčs"���:iU�ģ��q�p��4���n������o���M�ey�8�~bVO�L\�(s�6�h��ں�UG�b�Z�SN�� jbuj�ޒ�sa⒪̥L|R�HU�j���b��ߛ�5<��"������--���\
K*-|q+�`�[Z���vwW{�� s��V$�Τ��J	c��̥�NP�U�Ћ�_���XCG�S	,�W�1�D�0q��̥�z�B� �:>웏���G�oto������h��l')�$WNG�i�x�]6�13qE�̅+j������I��c󩰩"a5SPo5�8���E�MB����G��%��D��IGd&}>����`��'s�j�Q��GٻQ~�kl����ws
{�w��5�c����̪N5[U61/��!<V>e2��4���R&����D)�[�%�{}�^/TARH���t��]�E��4$���͖_hO�"�lu�+���Y��!2&.��\8���F���^�/࣊_Q�����qFA&�r{^�	-�Nj&Nm,s���Z�M��C�߭�/������#dS23 �F�S��65_�&.N/�?!��TWY�D�+�)0�1���B��\���˓8Qֈ\��ÏRij&.��\8p"":	Y��V�I�-�ǡ'-V)�U}�E�LgГ����t���#dE��7'��.-���H>���f�
j��ā+�ý�D��z��8�v�f�)���ոg�K��N��b���ą�Ih;��q�>:����ꑹ�B�ӹ<DL<B��p�z�9=�>z����Zρ�3כ��WX�"M�����S�Wb)@�V�H�aU_���[K���Y�Z�G)���>���C1O	:K+/8"��eW3�G���8UD?W�s�@��>��n�������$ܶ�z�����c��%�Y �i��H1���J]H��<�A���[-�
v��צf�b�̅�����%�ߍ�b\oC���G�{�O�T��*M|瑸��G�G��
��e�!���M�r��ó��W-�&^���0�!�4>z [M�t9k�����A����5��I\��9Ne�;,Bۚ/O�Oߎ�B@YU�P~n���	�5�".,`������ݨ\�~gcg�� si.b⥹�+�edK��&i._��q'GX+��R����f�2}Ơ�L|�C\���M(�W�����dj��.�+1s���m��t����K����G	�ɹ�2���{Q�C�RX!c���ą��*u�ʹae�>^�Q_��e���H�N̈+���Ϭ��Y��_}ąk�������!�+n�!�|6G =�i��<��ON�k�4�1)qa	x�8� ��D��ՔT�hbJO����g/���N=nd2�^ ��4\�>��]��������]D�<�,� O�OOb�OO�Rv��죘��I\̛��e�iMϡ|n��8�gi��+5�ar�.L����H��#��mنo��}�?����?����+��O��_[Hk����4^R.�1�ݎ�a�mm����|��O�'%B`�)'	$�4��(q9~P&IG�t�o/����*�O�I��������_���7X"����0���Ӻ���=��pR!�~!�7]]�x�?N%qB�'�RE_&��9���0������]�S���h�������vt�qi:�ԓ��J=&vH��Vb]ǥ�`��!(-m�ٷ��?�ԃ}xҤ�)����R�&ڒ���l�������P�;Ĕ��W*m]R?9��z�"V5�w#.��rB婟�Q�l��bٳ�v"��*Mg��ԅOv\2z[    �_���k.���R5#��0�!-�09["��I� ^n$�K.Mg$LR^�dJ�nNe�^*%�x/ѓ˄_/%.l�����}����q
�VQ4VX�*��z��m5���|��V��+Iu��f�W��qn��!ą%��ֹ/׈i	�D��������W�rJ�+��:gz�6eV������è(��ǶƇ�
����#�2�H]"��!w��.��������W��Z���p�E��ק�g�i�P�M��W�c���PY�R���xFXT�#���t&�N]��*k����۷�!@�e�6alp��mjf,�iU!.,hNE��į�'�H:�����[T�>��i���ɉ��#!���*1�ιF1n��S�w��3��ԅo�&P�ns9ƴ���fw�F�����
89?���p�����>s)_x+:٧d������{|��m������=6A8luW3��'��r�0� �/�Io	���ܧF���M>�"��(�a:�7�~㥉�"2�ޖ��b�R��VJ��0��vm��*Mg�a�/��$��i�;��i�?�
"�X#CWw��ۚ��
�.W��Q"��U�O�gx��R�H%�������i-5�J$.,*Ѹ��׈���x3~��6�Fy�ӏ-��4�f8�S5���\8�E�NNM�����W�!K��ߌ��������� Tp6,�<���]���Q�x�qa��M��j�Lx�tV/��o��`/u_3���J]�$<�ӡ=��p���ˀ�(�����Jr���TEQ<E�\ߥc+w�d.e�
���n�������P	�ŹaJ�B*5�Q~J]�(�t$-��9lG��.H����$=.��zY3���´��b�oz��Ý;Ƈ�I=��i�WG�g�
Sv9���VN.\�UӴ������b�	��'fX�K3���m�̅�p~�bX�?���z�o.�Ho9hPd �zeR�c�,�K��Y�Q��##��'����ۜ���3TH���r��xp��|NªYs9��x9_58�:���+�0Y5c`lk\��}'*�ش��(���#D��r��]ӕC�7`]�v��d��W��u�o��	�I�ت4�}{�������W�a�ی��O%z/��0����[�Q31�B�R^jZ�T�8L����м˰��!�8�0�G8K�-8Y���*u)	'�1���a�^�G��trU�	c��HՐ?����3%⑟aYِ���y���x94/���o�C��mp�*�h~ۿ���f3�٧3;JK��J��(K�2/�zp1M��J(���>��k<%]���C�Dק���r�L<�#r��+7����jH7�V;?T�̺�u]�«Ԥ���&
R�xk~�㰟*��[c�o���/����O8^��R~"$�0��=�om�{.M�3�]
|��$�蔛����C���7ç@���H?��C+$C�ͺ�����3Nu����v�v�d�������s�Fa�ʊ5n,��Q�x��tO��p+F<���O������S�>��d����,�7�a��zR��J�-6�1ݔ}/�p,5�	�RNo����6���!���E9����?_p�]���4T��t3ԕM%3K�P!.lC�i?���P�c(X��B���ښ�;�2�2��s)E���IF{��6��J8
-�)O��2b�3�*��-
��롷�������'O�mS���Z��f$y���L?!�(K��M��/�����zx����m��z�`�y��/��o��º7�I��p����Um��L|閸�uo����:��&/S)I���b����4�f��̥L]-v��#4c\�o.��:4��y1x����'�Y ]��!��:�E���K(s)W��4�R�K�Sj}3.���Ԋ���
��q�A|��Jf�+ ą� h��L�m�7��2_.?7�a~�|?.��<K?�,(S3�:qa�%��#����p/�b�8�mK�Ts��0��Ge92>�4q��̅�X�G|\�r��Ax�(�p!��R�	<�d��Q��t������t���L\7���)����pY��Zx�V���etL�y�'x9��^*� Ț�<j�H�#�ڱi�Ϭ��\�ΐ�Rv��d�~٤+�?<=>}?�_�cƺ�2`b�c�U����n��Z����ԠV�#J�l�����f�7�i<?EYhZ�Ue��lR	8)M�ī�VUFC�0����#�e�Ȟ�kPO٤z�K^#�C���-�Ųf���K�nO~*j�}K{;D�1@����C:n�4q��̥\�NR��Zp�	ދ��(�4s���K�g.L-�N�D��%�&Ql����Gi⫃ą����L��u���Q�D'5�ڵi&W�x%O��t�D/'�������#�Jz��^+��8<��1�J�U��Ce.,���hJ@&� ����w�c�]uN�%�fp�bI��HG�t8Ez��6�TkMAS��U�)k�po������-f.�^�(2��~����������{���4��
q������8D���1NQ�Ŷr��1^��YR�.M������m[c�З�%-�N�l6b';k:U3��8��H��,����$_WX�n>��÷צ���r�����Z���hX-Aq��_eJ2,�U��
_%��&�8�&�EC\v�m�H�i�d@"��D�����Ii;'����h��.lk��t���������%q��E�!\���蟙x]G�2��4���DC<��Y~���T!�H(���_�jt�r���x0��ѣT�4VI<2E��Z����T*	��U��pZ��qԑG^�E>G܈
�,`�!e��&Zab>�܅#�	Ӟ8{(��z���G�jK!��K��Y��*���i��A��ؾ��Jԧ������x3.��KX5*b���=���2V+��L��A\���V$��ꮜx��#/�#'��ŋ*��Fj����s0s)��#}�l|��a�(fi�۠P��^(~�����`�&�s&.l��d����g�Ӽ�[8�/ס�2�4&�W3	�s��L\��0i&�"Mc$Mc(}'����d����CSW�g�����y�ܾ��F�@ּ<=|��_d6�i�m=!��I�V��L�.sa:���d|�7��f\���F�ŉ����p]�ċVl����n>��Pۥy��%��r$�v��\
s��.�'m|V���9,&�fߚ�SET;C�X�gKϒ!.e�eQՁ��A;�v\��kn׫�f}���&1D�10�OÖT[3qIL�R]7�&!��\z�_�K��E����J�P��Ucg.\F�ꎊ��s<�̽%}��n1�8۩wJ�L<|��pW��$į�s�Xy�E��抺�#��r���ΔuS���ڣ�3�5��y�C���1��X�3�1I����u�.%��������4�>���X�p��|�	L:�`t��zU3�<k�R�Ͱ����\(U�T��CV�ѬZf_A�6�[+3�Kf�!��t�qX�h}t養<P���¡k�u5wdg.\�hU���s���R�Q��*'J�n��>�42�HC�³w���x���Y��\y�Q��L먥��;���8�o�.�dS>�!����^8�w�E�g�Bf�2�̥�v��)%R�!��������p6��ZL� �읫�x)qa��^��ԤÜ�3'�O�0U&/��"d�Mi��Lą-4�i�+6�1a���;D�-f��34�ăgqwG��b�	#��H�Ҥ�1{�F��~�<{&&>{&.���	t��qU����#��L�7"&>` .,��8=��p7z*���#�ݶ�ȑl�笯����ZQ�:�<ON1$��Ɗ`����%�ģdR"5�LN����Q��tWWVɬ)��e��ij���8�$a��R�,"a*Εҥ<W�8*�}ꂢO�=GYH!�"�%L�r�tkj�xL�R"� #��E �1i������Xc��X�({�=l�?���]���sc���>Fi.cSe��
����1*�z�0S����Ё��?���m�c���W�Y���&����}    (�s$�$}�[4�Ww����q:4(Xpv��d ������B.*�|=�����F��������Ssz��j(�?��vX:�F��T�AGe�����1#��������}�o��>��?GƜq��ʯ@�	�&k�K�;��*�e.e\�������E�G!9�$
��5�\�'�}�P[x}h�������%?���D� ���:��A��(��[	}#�F��5j���o>�6Fcd�����dJ ���-]�h�/�B�}鄋���i��M\2�P�۩maЫ�/5�Ms��Dm�̅��R롵1�
��I)ڐ�i����9 �B�����b5Rw���!���Y ����VM4|���m�S�ٟ��!����R�h�CL%��~Hȥ|�0��T�@���
�?��VI�*z�,� �~%f`�^luO�U������MM඲J�3���G.��M�r�:��\/|�s��a��=,έ���]�3��>7�_M�f�p��3�Z�c]�_��E�H�eT���2A����kZ�C��k&p�V�� �eV���zz�Í}8������k�DK�������o�o ci����P��´��5M��\H�eD�I4>�8=�<�s�����ȝ�Grn�@'���WI����P�
��q�w�߳��G�� �Z�oF*��� x�-|��-8�W���-�{�h�4V(ŕ�����vz������@�Ĩ<c�����֥0��D=�̅�T�1���A�����0(�i��1*WIY/�Z�8�-3��ă��� ��?�p<SұTr��6UP>Cq 75͠nS��T#4&^T�lZ ��ɫ�h3��U��PM �f�� ^ ��M�p?�`�>#U�'#}�#�"a��]%�k<��0�tф�I�1d�����oT)SL[���i�ԅbt���ű�8�_?<}���gs���t��F��!x�� ��B��2}D���Uu�f.e���42I�'6�T�l���
�i�����"j�B��	5�Eq���0�<�� tİ��4�]H]h���Y�h��I� ��10٤�y��jWg.�JY�Z�Ew�5��Oa�a��8����f��K��	��w/Zi,S5=�\��P0��*Vn�ytA~�PZK��i������?�<S���b�C�2$����s�����3)��e-���z��/Uv�#��5�!�����q�t��U����U3��@N6�@�lk��p2u��I��{�e�"8�+�Hvг��"�'����=��H��T���,E�H`��bM�\^[H����DC.�$�4���U9��PZ��� d�(-��4�L~�.Ğl��M��8�勷���OL�a�*ɪǀl���03�� r!�iՙ�ޯ�Sg�~5w�^|���-L�K]|C.d�M2qI����C��q����)k�����㙺�Dc���#�=�,>8ܷ�ћ��7(�
[p�&�\�N��#��6�v°\/��O/ۦ�۹�����W>7�5U���V:�l> �x�&#gɧ��-�`�뚉��F.�T�0���fy�KL��b@����blP�em��B�L����c�
p
����+L{)^]�����kk&zeȅ^�e��W�X�4��	6U`�ȯxd��x�B^�1�A����,��f Qj�A����& �\H ����P7�]axC�נ#���D�j�Չ��8^�A��-dۦ��i�R-u!h�xЍ�ܾ=�ܟ~��T�������q��Ґca�p��K�&�Y�p���龂p�t�Cf��ۻ�&����嬨
��-��WX<R�f��R��%�n�����T`������]�4�)M4X��`q�����_w7�]cL1T�*|KcP����!	I����[:s!@ٜ�Q��/�i���
#u���l��8mj�8P�BDi�x!΁p*0�I���tp}��N;x?��<�'-w-��SH>`�;q���,���`g��g��_��P���3m����*Rk]5ʹvS�r.��v$�;����Z��e����+km�4�M]�h��1�է�p]1Ķ`�c�|}�t�9#|��
�Q8]3Ѽȅ`��X	O������ss���������f}���������l�jRJ�Z�6
X�Z�L���%3Q�M�B�`��9����X0i��V=�UE�4�"{�C����-n�$M�D�А5g��8g9j�r������yx��r���׻�?���%O�����q鴴ie�4�t�S���D���m��sE�Ղ�g2�g�g��9�
�jd�&��@�h�q�Ɖl�*3Q�h�B�� {��5�>4��	�a�`Dr�[���e!wZx/M4"��O�0'�H����C��-D�)�OS�LG,u!�{�ڊu��� -	t�"�r�:q%e�:�Lt��Et5
�����In؊�"=	ݽC.d�N3�Ԭ�%��C�V�t���L4@�Pd�B�!��X��;Rp'@"p����b��
KEJK�̧�����jy���qB�)�a��x��f��dL]ʧ	�t�6��"W�n}��D��5��:�֟�F�M3��ԅ���j�7o��螒^�ٳ�	'��1�P$LT���P�3(��;>a�n�w�}���ܿ�>�~?�����!��)���*���g&��\HH>���t8+w��;�)�%9>RO��gJ�Y�\ʲ�ϡ����xc8f�˩/`H��T/M��?r)W���S��@��W��eF������}����I��t�4C㑺��A¥3�n�9���9��1����b��
2���R���2�)����l�s7�����0�WO���Zc�B��gS9�
x�9�St+�O ٌva�J��B�R� ��()�J4>h:\�"��D�2� �&��n��ʈ<F*g:��TJ%�"ݏ?2u�Dߺȥ��L R�Ct���`��=���3��#\R�pt���$pڷ5�A.�m�#�!{����[�01{?�4Ww�_��㚇�޻��k�'0ϴ5`rlD�DO �C�B&9L�O�r	��kK,W���vw�L) -�t��C!4SE�D�<�.�5�}��@dԒ�'^C��a"�-Z�h���c
�듃1���(��܏���}�}w��va��D� �mx��C�R"�+,T�{��T<�q�3r=h�	`H�������jx����M�43Fs<�EP*��'��f"&�r���B��l>���W`�H�()!!F0��T9�2�4Rȅ��r�n�@�8��Ľ�B*�C�xxe�D����s��9��O�Hh���&P�j!���k&���\�}&�գr���0q��8s�?�>B5<�<L�Ԥ}�Z���(�Y�BѤ0������s����Gćʃ�232-&���\:
홄Y��?^�@�������Z�Њ6������P���Sm�DSg �:���aD�����q���K��b�P�g��S��,�@	��aJd��)����J��Z��7�h:{J���,_pi%T�M49r!���q6ƿdV�o���~����Mچ$��4Hz.iV�� �� �~M���\��_���[���(�dC��	2N�2��J�L��PdCBK� 	�-��u�]���v� �����V����D�Y�� � �/�;|$����=,��uò,��nM�&t�&����咀��i.J=��~�[[��<�ă~��Op�S�/=&)� �:ۅ��A���D�0s�>�ӗ3�h�6 }���z�@xn8|4:|�&R���FT,3GO�A��>�)�.�ҁ(�܄�����n�`�A;��+cS�q�D�Q2��{VLA��l/��f�_���JT����Aah!��e�4s4�.d�Gs���8��vGJ�=gVa��"(ڒ8���%L�8�Ʌ�-i�����q��1�].�
}�F��
�2�����~8�t���Υpn�ؘ	8+@(K7o��ȁ�^cV�L�����#4��\�?�2S"�"��z�    (��n���(Ƌ̅ȫ�I�0�{��^���ւ0 ���wB�eod���ȅ��U�X��oU@ҊT���
� �(1W3��ԅ�C��L���Û�h%׉�5p|g@�.�,�B�&��
����_4a���Q_���������,��
_,k���}�$ښ�z��Uცh|�=D�}��a��` m>���ȣ�J�
���IA.�T��q���9�~g!W�V�v���H�_�F�L38�ԅBNy�9m/{6��.9��Iě��a@fb�
ă3�0϶�ה~���.�K�Z��a������Y���s��@N���5���G�B�XŨ��}{~>��_o�/
�BA���z!�o��,M�xr��%�@Xx8���/�6n��SRjD�P�j]�P��Ŭ�����M�����<����C#2��%}>}�~j^~������������/����%zP3�R˶f�jX�K��^A�����.�~�v��V=�d� 8��ifx.u!*iU�^�e{Aw	�n@���|�F����/.&FU�D#��xt�|�_�繭M��| ��9�����m�bBi���2���=	ۡ��V��nsV��a倻�?o�y��4ӏM]�~�c��׹��=��V���pD�#'�L0Z˴GS���R�R>���tV���gh�m/w�O�w��h�`Beu��xy��Xz��5���6@v�O��YS5Q��̅�Z50��B?�j[����à \n�a�]X�ɺ/�L4(�P�� �o�zk��8тe���w��k��T�Z\�G�Q~Y�6�e6o�"��E.�o -==a�G����*���_e�M���c������R�h�����^��骉�	37���p��G��@Ǒ����BYm�����,s)��ơ@�?����/�^�����#�������"������O�o����鷷'��}������3| �|����{n"i@:�Q<�2D�֠2zi�s�B��2�b)� >&������kv�j����.�jd��'�Q�0z�8��^�����d.�jX�ƜW���	^�	Ce��Lf�D��K�[�O.��S&�2d_����GC>�-_�r���O��ag�r4�AS�[Q3ь3ȅdpme6
k�����lC�Df�if�.LZ�1��Z�7a$ ि�s�~z����F�&�Jux�Z�ը�R�B�T�a���}�A����6�8�����[(]|;}��mQr��J�оgP�mU�D��K�^ŔUt;��C6��)����>�T9.	�f{R���D��[�HY��,�����Э5�f��B�B���8�}�� 8 Z�յ%\g�x�zn�i�,%u!�~�A�m?,��;3r;�����C�j���Q�L4�r�I<�>���
��
�}3����G:{D��r�R��-�7�$��q��?��[��;t��mq��TZ�t�ӊ���b*�W>�?����<Ȍ����!������Cs}���������[��)��<𭉚i��\hR.5�"A��?��n����oӓ�g�0"v��=�Aدu ���fB�ԅ��!r�M��h���(v��.������˯���/���ho�qJ��'�>�W�_�ד����f�X�p
���?X�MM3�ԅ���inCܧn�b^`��@�,�R.M4������؀^`���L��]xh�k��á{d�j��=&/"]+D.T�. ՞��x
� ����s��#o�i��/u!��LV�U:LT�~,|�R,��n�&�8��P�(�_��Rh��)^�T����ȟ�Ă�R�bi�`4��	P�4��zw�k�i�[�pCA��߮<��f&�K�\�.��4"��Rݮ�����ܭ��(5��v�h�@���
��^�5%�$6������ݧ���Q���
 �$�O|�c���( F�B0�6A(�} ��0�X��~2��˂fIkt���b��K�J(�2ɨ��z�i����ss�C����6�{������N8P��`�f��I�B�S�ciU�	���B��N���/���8
R��8:�0�d�)ۂ�5������C~��ǆտ��ݽ$��/Oߞ~rC
������_��V�,MV5s)7��@��ɦ�n���Qޝ3T���P4�����, �>���������,������?��8��\��N\��i�`����&�Q�P�6�0�����c�iK���ͼ˙ja��ۚ�jMd.eӂ��ĕ��Gde`���l?v~)4"f+�L�@S�� r}����"��H�:|�#'e��h8r!�D��l��?O��F��?��m�ku�D�� ��psqI���T/v��D5֥ŭ��	�"Ø��ݲI(����M��I��H@?��~.�g�
J���}j���Sj�C	;.l�od��8�@\SP� %Ѕy���.r�k
�(�������ܡWz~�"�d(ƃ�_�Y]�D�e.�xT��E&Л	3V�0 ]�9!��P�� I��(V�̥<���J�T���Bf�E�P���zQ\LM3�ԅ$ʒr���bع�q}�w�$�Y}`C�A�O�)5a��Mȅ�КOҢ�� �Ba�d��:N�V�r��p��\�D]ԙE���ZpQ/a��1��F�#�y$�\0!��&�Fh� [8qRY��k?���x���o�Ώ>�Lzűi�/:'tʌX���(s)�5MJ5���է�}���Q��;�����'w��s����Q��_zӪf��:R:�2���ج�;�˝�i.*����1�ښ��C.TQ�	7���Pd�>^B���k΀��r��� a�TaU��
��$��O[3Qp�RvI�lb��饖�l��,0�ۦ*ń�� �e��T5x�P80$���V��X�4SI](�=<������	�C�k7~T�A��k�*z�6� ���2*�~jg���M�RY�*�?���hl8r)����/I�tt��YkX�C&�х\�¯�c����˧&��#����W���q��S�߃S�j�|}n^�^Oߚ���w,��9K�G��p�*�jD� +MT�)s!�L>�iS��O�������8ޖ< ���5����2oN<(���j8��Ry��# #�?kR�{�DO#��?�Kb]��0Q3�jo���g k܇2��:[��i(�J���Y�Ѓ�U��PAU�~��x�r$�k2x0���?��˸���n���TH�f��Z̜~}�0٧/���xz��-]�L�OO��D�@�!	��DSZ"�p9�Q'r���Χ�V���
e }�UE'-5�t�RjFAH3��l�����<�m~��e ֵ2���V�_�e9���|	�PϐC�+���Z��,:���m�?"�uX8��M	P�GQ#A�\򊅊1�G�7�>�s�]�|s��A�ˠ��Z-d�Bu����9�з�p�
������Lƀ��H�f�
I�AA�=VGn��v��.0���ٞ�]|�_�?(��I����r!pKLp%Ι�����Y��r���iŨ�V���˒��43ꗺУ~�������p����Me���U�7��h�+r����s���rD��uL�� ��RVf�ac��;�V��D�BC}$��O�o�:�}����ԬN_�~rKj�T�PX�]N�6=J�"D.d�PX��������w��po(Ծk6w���z�׻e�<�}@���Ʉ�0�LIȅdJ�b�n���:.#|��ļ:j�)ed~O!}!�2,�]c����f�t�������� �[�q��0���B��xz�7���k��k�>ĕ酇a$��aB�P���h�)�Rn�p�*"��a�jy�oo�^�Q:�jQ﷨Ƕ�b�|��\�4S�M]ƥ"�������fu��t��I�Hc��\8`���	�4�4N]h����A��3&á��	�z1�򗰒�UM��\���BN6������m.M    �rl
��,|l�ԄJ��.�ǪV���?\u��}��\4����}��@��h�l���y����%��g�x�qA%z��u��~@��1�|/e��Y�ڼ��L�D.TCH��%����C݌�1��y�R��b��
&`�N��J�̀C�A�B=ao��c?��2Ό�(I2�.kX_��Bcy��2C��xPX_�ELbl������`c;c�����!A�=�6Eӡz67��O�`m��JU��\ʇ��#(ό���z�?{��<�타G�4S NO��D�K�K�f���8o(+�6	���v��+3j��43����W��e���Q��U݅6^�5���ԥ˂�@�u�h��k�p���#�J��2*�)=�B�Lkj&"�\�j�S\L�`�q��wT�)��e���D7�9)����'��w ٸ����r|�!<�Y:A�f-��[`}�5�Ll��б�Ƅ�Dl�sq�� �+JX��sP�B���D��ȅ�����А����dTKEĊd+|��R�<a�==&�R�]<��	����-�4���-�Vǋ]b|!>c�>��f��^�B�8�?�gĚ)<eR������,2�SNȥ�Aת����q�5���I,��>T���g����K#���ą��0���d"L�%�\�S�|^��j0�<�a�c�}lck&ҁ\H��		��߀F	��$���-`t_E����S(w!PG��C�g��~lF��%�	�s��<���C��)�2S3��*ȅz�P����"4�2���XZHӸq� ��h��:@3����w �=/�<C3q!N��\��G�[!�zF�s�Lt����
�J�(z�`���"Mm�2�x�P>>�2��D��!jhK����E�֚�Bueu�!�'���g]�43���C����5���i(T	V]@���
��&zaȅ\{�#���ZH�,	�Vhm�����e!rYR��M�����^ɫ��5���W�Zf�ă\�ã����!������ĨC�J��̅��PJ�D�ߟ߾|�l�x����'z$��[ -�Ю�y���h�B�ui9r�v�������1�~�=�^�Oߚ/�?��8}���~Z.��bJ�Z��c�if&6u)���C�����f����5�aGӶ���&�I(p��)�K0����k���oL�����[�B����m_Ly1�� ׇ�����S� M�\�ɋP�8c���v���M���tr��	Z����Mr��bjy\۱��ȵ�@���@��,�������^�����Ps+~��M�]}\E�08���y	��:'r!��B�3"�꓏�7ʕ��j�c�<��E��L�i��/u�@�S�!���:(�\t�� pm1���6���;��L�1�\��.4������(̋W.F��A��0�_n�`;��ɴ� ���(&�f8���
���S�Zil�Dj3���`��)���Xws$>bu&(��CZ�2FĞ�i�?��U�!fB+��M�9�o�q���(_+�oB_[�Vɪi��:���7v(M_u����jd��i|GiZ�RՑ5ź���O�	GM��� K�
.�� MZHi�4��,S�21��5���n�B��B7���	������J�BW�\KB�ӷ?G^[�έR�J�X�K7ai�T�A>'Ň3n��X�L�Ȳ
��x�](�S����Be.ԃL��������D��jh��7]5�Y�B��@�l�su��v��E���Ĳ���m*:�I=�
(S�`ˋnu�5�|�.��J#�\fL�UiM�0�$ȅ$��bx��G�=��'��B�l8ۛ�Y�����F
���pG���ms�d����9��FUݑZa��]�t� P��y�<�[,���?�K��J�И���PW��8]`�X���U�o����r��[ݬ5�b�������f���������g �?�[������ex�v���v�U:^Z�&��P�>C��G -D ������{ș"��=��׷`��(���?�k&j�-s��>�4�eW�jw�ۡ�u�G��ط�\�GPP쌠��O�T2A/�,|������+s)jN�!!�����k�p������S������=.����[TMx��r
Z�͗������b� S6��ٚ��.� �L�!�]������寏���G��Tw��%"h$8]3͔US��|p��\�~������0񢃊�*��-�6H��4Q+�\��nq���?6@��&���kH�Ò�Ɵ�D�Е�<���	�if.%�G~Oĝ������O'���}oN�}OVV�h�������72�zJM!ӲR�t��4�/]��C?X�l|�٭[���g��&Ͻ�i�����E<咲7���B�nR�BD����&UA.^Cp��58
�8ZM@9�P��-O!���XK�Q.%t�i�X}�����(��z��fե�>!�Y&�c�g��S�:̩ ��)OJi�Ҝ̅eR��$ӌ�B�p8�0��������q�R.��|(�|�W��}�n�����4=0.[���xZ�3�0R��8tf��7�1�B�uz�mk+�a�<s�w�)�4��$r!�C@�"P��w�P�`~�fbf���̅�����S4
���!����J43P�f�G��	(��0�!�	�C�|�"WQ�c�BDƸ���0r!��N���~i=Aڡ������D�#A��5"r���������q�-'�L�p�k]T�����t�SlR�c�z�o.�ûF0����ؠcX4 7͔�S���(���1�����x�s���r���iC8�H���I��5�L�?u�:*�Z>��O�$�#E��K���b[JH���᥉ޖȅܖ~�n��
(��=���PZ�Ri�Z��L�э\�3�/1�Fַ��2�o��i������B[D�L3f�B��%�ulNeǥMUK�)N*K�4+di�/2�;�Y��S��O���m��O�3H	��H�j��u�.�:ݔ��7�}
0lb���9=1ϩ���b*�<�L�<'r!�9�f��y܇U���i����4yZQC����Pb�`N�LT̑��Yq`��	��6V�F�Dv,������PP� ���Z�3� +BN��_��W��>��_�ޝ����ax�V��%/��ɟv��������X��&��u9�٠y4t�H'��-p�
ʦN����"��E �=����M�x�~���T|@�]�>�'�B	!p������.�#�O�ߵ��쮍TR��~���v���7�a1ҿqY3Q�o�RbS�����広��}�{v�
�g��Xsy<4Q�����}s8��
"�0��a����!��"�2,-�{P����d<�V��/� ԯ�������47#B�L3u�ԅ���s �o���ov���+�)z�H�a�H������8q�!u� ���1�!��Ҿ����i�IJM��"���2s�&!Sf��>����c؁Ri��ǹۇ�oo���&R{��!"0�E0���K��£��J�r�g@��]춱�&p��| 9cru[3�� r! "A�D. Y�d�S�x�2�cѬt��o�E�i�Y�����Q�������PҤ-KK�#\9@A9}���L��g_yi��В�"$
����߁U� ��a���f��?���ABe��q�~��]l��{�	R�����Jª�k&	LkL�D�Q�K�b)n�IpX�7���S]8��F��W_�h�r!�C|�Aa�2�h���(��]@��JJ[3�@�Buθ�[���+M�K�&6�9Z���L48�LMУ�z`���R���D������8��MD�=w� E>�J���au��vN_�@ N*�LZ���j�e.�`�V,W���q�黛�&�M�TRNaFM7�RS5QU�̥s-���}�����`�z�c}n��1�P�0QE�R������f���'    , +;���+D!V�(<V�B����?ҋ�o��
4p�g-.R�6vޫ�L���"�Lt��M	1Q�j����OV�,`��󉻮��#$s)�9�EJ��1mR�/ZK�)~+�KgRK�oR�B���yq���6���>3X���Y�D��2b}@>7H�9��
�. ]� '!j:�K=�n��NL:�<�䣴� R4��4\�L�坹��a@:!�.�՘�@l`7��y�1�йN�A4���4����4(�cP�2EE��<��L(��z�_i��Ѡ���Mi&
���:�Y�t@�4�O�%/�@F~,�l�d-�/��Ԕ	��TQ�ٝ��� ���]�6�����/�R������5�-kۚ��>D.Tq���R{������P�q�DE3����,V����ݪ?4�����FfD2�(��4!�$#�̼e�B����Yh\����ߛT�� ���,�$�&
����O�ݹ,�������)��c�q��t���e�N�i[3Q�ņ�>�:�gy�Cg�������h@g�B��
�r�j���^�R�}��,`��π;�-*��}%����g�2/����,�(��/74H>!���=���u�@2D�+�T������(@��t~�0Q�s�B}Κ;,�wq����
7����2�1�Gjr��HB��?ˉ��4;)2��Ku��Al���fPlL�m��,/~BaP�LW�J@��~�ȅ���ñ��%����g(϶�Z�:q; �o�A+���\�UjWr�������9�곏�?Oϧ�揻���w��l�[a�����}��[�p^�h�#r�h7�K�����X@C#Ԑ�h�b����*��9Y3��X�.�2a�z����E}䚱��7 _~x� D�����9 ���UM4�� D͆Bb�STX�+f|Tf�;HQw����!*���&�I/
�&��u2�(M3��ԅƵ����l�3���<(3���-Rf+M���\��'����Ή�c��7ܘ@��ۚ��M3*w�#�%�����9#�������oE�L����Pu+�Ϻx�n��f��eu�\/7��_5�������^[�b0�W�c<et&L4^��xM��Ϗ��z��u�b���ԃ<	��G�E�ץ��?�}��]�w/-�VJ=�*���6fG¯�2�[D-VV�#z�,�W���;r!����Q�~��LZ�!ʝB"C��ԕ�h(�0Q���1k���lw{5� N�YeK�B��AO&'�BZ��Z&�x�]��2�D;hG��\�i�ЁTL3��0�o1��������P����N�}?L��hTrM@��NˤkJ�f֔��k�������}�>��1���A�\��HVMt�������e���y����!����v!��,O�������R����~����7Q
h1���A��4-N](��nRm����P�\e́-���s��|S�B�5�g����R,�I�๘�q���n��f���̥��q������./��]�_����it��Vّ
��>\1�R��Rf���B�uS��ҏ��x�I���E�4|ڠd�43C����]�q�2 	T��)@�R$@>���"�� �A.e�d��V��_�1�����22�� ��#2��s��j�g��g�|y{��Y�w��CԀ61�g��D�ȅ��9�T�C�����*��ת��-��Pc��/Ƥ/����ry��_2��aR�7��d�Ӷ��ɡ��p��&z5ȅ\͹�V�7zΔ`���እE7�4"�\����[��cq�VYMHmo�VoK�LE*u!V�?��?�h~�MȁEWxr��(���j�2�̅���g�y��n���K���ϻ�Ͱ��1������]��n��V�B�F�ڀ8 ?�*J
�2��D{3b@�`܃���ҙ��"�ǭ>`��\��f�C.@`�[�E*ggn��SO�!������g8�������c�oH��B�S�ʚt|�0�d��K�p!��z�a��x��}|}z95��ߑ���j�f��g-����k	�r ��`D�5�Z2굄}�����;$E�.w��<�è�j[��0r�RE.dK�_n���~9}ClM����à|���9$TKU�D�v�K�^�?B5�%��Ӿ'7F�I�.��z|F�$��L4r!��d�:J��[�Ę",'����d�m@��,���7������q�7��ͧ�c�o>�}���6�F�&0�ȴM�+H��l��em�5&j
?s).}v%�����ݺ�������^8h;��	���>z�A��-C���+N� �|���D���_�@C���Wa�>�̅�s5*�+���@+�n��](�6��D�_��(A.�*vj��F�x�DI��?����m�����R�Ĳ,��� ř�O�h��Bu�}���3�@�jxp��<�(70 y��5��Hy�Bϔ�S)��vj�	 ��u$�Vn!%Cr���N~�U����9��CU����]\,�V�f�_D���5�f���Rz�c��/���|��<��'PpOən0��e�7��ï�9�������|���I8en�È{E �_P=e�f�f�ɘR����&>��?��M���X:D�{��§"��\�OA�F4��A�A4�oF&:�F.D!�zF���1��D��Y#ę��]��aj��Cy�@�����P����r�<֝��c�-�g�N��j�a�ȅ��=����C�nn���cG�U;Q٧*H���*�j&:�D.�>��!W��r˷�D*�F5R�8�5&��M�铹���P�W�_V��""TnLgC�e!]a���S��rc�R�
�s퀘���/��T����I	P�X���K=?�\>�������eu�(�`�0E	�����I*<T�(c�R��6Ӎ<����k��|��?P��Ӥ�Z[\z�i��K]�KO)�l���O���uPm��3� s���v�B}�qV�/�S���������2U@r�R�E#��i�w��н6��6#Y~�9`��n8�v��f��BF�/`��K�1�`��t�B���9�j�Y��ɅZ�<SN4g~�!DD���Ut�R*��j��qr(trHK7İ��M��߅Tt��.���.7G��M��>���vg�������i��)�%�������?�N��L]{0xl�a����׻�Al�#(%E�j@�@V���H���e��Y+e:��˃ߞq�4�e+ܨ�=�6�ʅ�'[6����rZ�B����n�Կ\^�n���sVP�Y~��h� ���!��d��:�h��t�D�ٙ�y��<�2�)����q�w�����M|���R���-V+M���\ȉ}���F�}Hv�O���92^K`Gԭ1Jg+��f&mW+��-�ߡ"����������vz}׼��}�� ��6_�>������oO����yL�_Pi��<�������˸��=k펜������S����˽_�ow�N���I�؍`�������ׯ�������[����������w�lϩpC1�'k����sE��f��ԅ�rУ�����_�����BV�n-�_?�/���Z0�r42͌g�.���?T�9
k�����2M;�����[��MՅ`8�r�8d��\��k�^���}��"Ƈ����Ci�<�V�f֟���o�����U����=�ɣOm���^N��m$�b�or����Ж�������?���H�6>F�#ǂ_��>����^yE��y�[r�U_�h�r����P����pu9�e3��!��p��VXf��I�!Ɓ�BM����\�#�� W�wKX�D��g.em�_� ���q�;ęX^��-[d (��f�
��9�&�E��P-2�Z,]'5���khCNi���X�@
�#���E�h�r!1ܥCӭ��� 4
��D�:W3Q��\��@'�i�/���+ħZ�&��]���ZU3Ѵ	ȅ�M�ZN�!��1�G2���B������G�509*<�.�a����f�k~��yuO)-)�Z�1&g&zO!rO)��ҷ
��9��?tYj�y�>C    ����B����^����@�0�
R�\	W5qȘ�P@FL�ӳQF���q�����['7ѝ\�B�r��bg!����3�@3ay=6���Q��W-L�D�?3��͡��_컫~3�}���/�GP��0ܘ��i&�H]�B��C��__u�e�t��Ns�co5�c�if&6u�z%B��+��
(x�Ҫ�UP'b��o01��/q ߞ��$p/��U
�7��8>�s�����N��L4�	�P�3 Nʇ�9<�t���	��߮�q��ޯ�\M_zZQ�y���B:$�3��LD0���C>Lki�M�#4Rs�Mx��ɑ�������]�Dar2br ��n��լOo�_���&�/h6�1�6)Ia�a�H](2)��ڋ�ŜQi�fQ�-���-��Z,5��d.e�͂^�l�N�����A��9���7/�o��O��	r]�kA�/����i� ���Ho���A.ӇG�CH(}$a���fzکKYW[N�K���&:�dԉ�B���d��r!����%ύ����I�}n���aa��E'�Eѥ3�yy�L���jl1I�A�p`����T(��P"j�F�XFI�����%�,�	��������Y�q��z�M�~	�p����F��0�cZQ3�`�S�K�'�$j�=~��4J������e���M��0s|LtO�N��RȚ��	������[svd��f�qC L~�mw�������y�<>[K��DG�ȅ�@}h>Њ��I)7=�H�R�|�J�VfJ�zG.䬴�8⪎�O��.|FU>V����j�L'oK��f.T��)v���f��A��0��
���J��e�f��������;�A|v|�>���-JIe_��0��@�������a�(���úX�X#H�Yw��w�&���\�A��;1S�o��DR�N���Q���P�S
:d�H��5vf.Ԕ@(�w��9�2|3мᖍ�I�̾��	��Vj���ԣ�xԂ��.^++�p܇Z�򗒪����PO�I�N���3/�L���?��QUZw1aP'鬨��N0r!9a���ޏ��y�� F�ߘ�q�^̍�R��.��
 8S7�>�B�.~#p5��Mw{�������#7Ю�z�rxڽ4̀wSb������S� X�w�O��CgY7)�<MGY�(��Ng����ԥ���hl�q9j���"-G8�|��>S���m�a �a b���Cx�y����ϗ���3i���1H5�I�^�������,u!#S��i���U�וCY�
���|>�Rz��D˙q.�(�$D)25��\�Q%p!%7�Cȅ��V��	��e��ȱm*gVx) ��JS&�i��N.$tB��U�ӏ�/$� Kq����$8��>(�B�L4�	��P'q��l�0rܼ�]t�����M����B[�6aa0Q*eu�D�ڐ	lF'sx���O��?���G�!��l�3"��v�Xf`w���2Q� �����oV�{�ź�?uGX�K�
��p����q-Wf��J]�V���J�iƭ���#`�g68���.|�rNɊe��0�(!�:܄�86���\HBr��a���_0�. �]@.$x�����;\��Dv}�/������~�if��.���9tހ���q�nL"z�9��=���F1U3��i�B��!�j�a��j��,�!�ڪ ��S-3}n�הzPK�M�t�+J/�|E* I���Ya��o�.ĢW�	���^��#^ǆ���@�����*��Y��(�z�@7TK�խ�� ��k�y���a�<���҄��6%���9|�>Os>	�m�D�I�˸����5���b�x����,�s�$/]�fP��S5��"��Ň�V'�-�m�W���[�:Ep�O&�H��D2z,ڇ�8��QrJ3m0�U�>a��K]ʾ�^�0��Ŧ�o@u����&�$�5�ާ���K�&A �M;�uA�}S�si�����_|���~zy{�)ȷ��u�z�s���ǟ��dR��h�aCMw.D��E����ܥ�R>2���t��q�2k�ֺuw��Q�:m���j���Ǒ���U�^�.Ը��T����^�� �k�SL,@���Z�T�K�E.$q�φ�@�cP�������a�B�q-t`Z����C��)�ԅ��Ӹ�E�)`�.��@;Pt��un���̅�6TrJ�"�Eh��%7��?V�Rmi�)��.d������U��I�!�kr\5��94˖_�
���*�O�;\��;\�0bݞ��r	c��O������(�$jj�^cva��erv1d�kjȅ��I3����z��/������������՟�_�%��+k�t�ڭ�T9!� ɰ�q�[3�D"���瀄>�	��m7�Ԏ�7���-�|��>�����{�'���!+)` [QR���Բf�))�.tI�x���{n~����rz�/*Z4?��0���Y����j�y���y 1=�:����ǁ��dW�|�+���A��k��kM�Du�3��	��t��K ��ߠ)����R8e�� T�A�ʵ�b�1̩�Z
b��a��P��'t�q�k]h�A+01�+�&��g�Bv 	r2;�8}
3Ng���T���t}"�2�*�&��)s){����FX���o>tW��6�ͻ�7�<Q�<�(����1��&�7�No&���P� -�m��eD�D�#Й>��k��(	,��6@vZ�˺�i�����p3�m���>��#��d�/��[�C��Y��B���,��?w���hm�J<�SHe�S��z����v�Bw+F (|1K��@؝Ǵ~���2���-$�t�d�9�4<��?tx�,ѥ��9�4(���YY5E�ܥ̲�N%7���ɨ6#��7��;>�E��L�#œ��{S�?� @2%��m-�*�x`!L4-r!iq�#�K����?�\�2U"�E���������{�B �E5@��r���N�x.��C��C��s[�PW5����\��v7`���Q�,!8-�DWJPO��N,3��ă`Y�'���#n��%$)�a	a�-�++ר�Rz��	<�0Q��\�e���5�b�:��b�]��9pB��M7�v�hL�#L�t�� NG��և\�f��3b��gUB�����6И��>�����}N��A0)N�Z��ㅛ"%�/M4:������V1�\n�Ud��p� �8��z��B���6 �Z3Q�E�K�^"�o��Ô�zJ%���Ð��V�LTQ7s!H7�45$�7��͸I*0j�I��Ó���&v
#9J]�B.T��˱��	�
�O/��݃���x�ri%�jB�A`��JZ���2uKf.e�I�W0�>&�Z��R�&������lK��lm*:�8��	�le��6��TE`��b�.E��F�����{��D���A�81Z��|$����S��Fƃ�y9�$�un�����"��%�p$�(.cyB�Zhڠ��}�k&�H�\��M�lj�Dս�����dA\� !p�D\��5�e�?�Hp��o�qr�1��ذB?���5ug.n\��-�Э?���ҩ�rU
~_�le D���Ue.Ī��:\�ݧ�Q����~�������C.H�-ܙ��d�q��4�7.r)�V�un�ؼ��CUa�;b�����B9d.�އ�!���Py{����G��,6hf��"��*����,;O'�oH~����yq�!`�)�(R��E�B�Q��wz���x�/6W=
�?��/ZS�5��_�B��tگ�5(1��F)t��JyP��ø���N�y�r5!���ԍW@o\��l++y��]��.��eɞx��0��ѭ���r�OT���[�����u\H��4��\�֣6Ӏ�{�g܄	��+�Gr���P��K�u��=4�|F�м�~{{�i������_�������"��o�ǿNM���3Ő����2�T�    �qc�B����'n�� �*�6���7(T���ϑ-�DoH�B�V@�<���[�n�d�s�4���bX�i�������H&*��\�����l����25��D�`@+�k&�\ȡ$�䭋n�m2���<�3�����\{����K�5d�;0ȅ�,��D0�s
EԂ[�2�Ff�[ȅ�P�.�;RP(�JΡ�yz)�nO�����G>=Db���je.eq&�\
0~7*�7���Xv�}�o;@�A9c��rb-`�@�5������̅ ��Wר����K`7	�.�V�A�A. �c+���=�B�e�q �����w�q&���(��iЛ�Ѐ^��&��ò���]NpcV_� @d�ʝK���Rzu����by�\��&��}��3 ��2�D.��и��a�<m�֓09���Vi[3Q�/s���������g���ty�Č��	JpgX��Z]3���B�9AL�s����i9�a'� ���O�uK�
U��e�Ȇu�'�E$
��Cw��؍th�D�X�/�p&+f��I�B#L̐h�ᅣ��/�}?BL�C*x�����Z!ţ�B}؃��Ў�r7��Z�l"��03]iU��P� ���Oϩ���"���h3�3����$�I�Ԩ�9���a�g�93w���i�MT
��N��B�pS���D�2Lp6�us��W����9L������C��r^HQ�q'��A���BYK��E.$���9c�N9��KQ����Uʰ��L3`�ԅ*Zp��L��⫨ȼ�m�?�w�ݹl�SC�}��<Х�$Q� tVK/���JeeJ���7o������eS���R�1SU��eă�)��[�K�7UM�\��ԴX;\RW��5L4_��śm��([H`�ѭ�*� ���*ȅ�*���ʾ[uTq���$��9(S�pP���.�!���D�L;8Y�u:�w3na*�J��]R�LT�#s!Z����xӇ���'�l�1��g/L��T\1Q3�`hR�r�@�/������{�/
�?7�^�N)�^5��3�tw��2�k�R�W.��L���.*��A5�_N������V�Z�6Œ�z �VFama���̥\�ߧB�Pq]���?�_f�/�"�Rt"��
#�>0�iNY���4s)O$ ����X!pow[(�x����gs>�tv��Z^,
-X��V`��GY8T��gCS�jq����2�� �й�g�� ���)f�������b���$B.v7W��3O�BD�����׻(��>
�n�4����6V&�.��Pp]�VŢֶ��h?	(g�d�@G��p��4Q%�̥|ۆz���~?��	fXeM�L�Ǚm[��&���\�51kd����DMզ���Gˀ.ݿ�@W�j&:�@.T��+=&I���zk^"_����;��}vgu�BU��� �R5�� &^GW^^� s1J�9���vr�^���x0��p���r����<h�4�"��tT���J�L"����{�>������@־M9UY8��2�<�ԅ~��d����C��#��o�L\�5�*GM��D��"
g��D`�ļy�n��ʚi�0.u��>T&wp�.�/�F��W(�|���E�
!�t��4�P!�B�D��56���5�4 �2z��p�"n���j&j�e.��+fو���z�i���p5�	 %�h����&*��\��Lk�t�@@��<};=>�=�>��AM^�c�����Lt	��%\����ű9nU��t́V����c���*�����(�]�B��[O!L��F
�4F*�<�=�6�L4j�Zε��5�B�`
7�RS�t�-��yNہL3Đ��O�fH��^﾿5w߆1�fszi�N���>���xj`���i3�������Lp�ޚ��?�^�"7m�S����6e��rj�i.�.�/&��?���;��ߛ���}L�l���"��	a����(s)�H`�uù:���xB�pAA���X���e��#� ��Ұ��Ѷ�GSU���T
�ׯZh� U3ѐ%�BB���Vׯ�nz%0��!�.4f�[t�2��x��Tn"V�nΚ�Ti=��X(%. }�L4!
r�^4P�%�	�����������E-�gr	�S�f��8ȅ���c`�M� iQf���AHFk�+�VR�!��
6�����z��Ҝ��35�E,$��f�����v�L����z�p�+J�����. #��g�L��B.�R���o}�xu~�)3?1ίB��q�H�J!3��������P�o��זr�!͐ɶ��j&*z�\J��c>�&���׿cY](��ۅ�;��5�P�B.ԧ#�q�����}�o��� :����G�Zhn^��uX�Ь���� r)S.J&:�k���%K���Zn�K�L�u�\H�,Ѧ�W��9K��E|� >�0ѰK�B��K��ըD�����ل?�[��~&jF6s!fd��P�)L�"�H6i���&�*),D�>�&M��r���Ml��� �Z-�`���ٱ�r��&8u�D��s���AQ��a͛��>�D��M�u��2��c�1Y���ԃ�'��+����_>��Ѫ&��� �����3b��C�jx�gɒp�3܁�#�p�CY��~JՁ�\�W&�(FJe�tX���}*�|*�Z�ʚ������3���Э��k|�{�k��w!W����p	 fo+�ⱒ�D��5�
#�(�Z4"%M�n*D$��:��I#���f��̥\�bZ���g��0	���8D�a�9<H�#�$dQ08�"���,�c�T5C()�*�������<)~�h$(��k@�Ɲ�+;��ڜ1V5��ȅީ�S�1�n��?V�R��|H\�T
(@���J����̅g�qGu��q\GᎫ@�i�?����=h�����9�M.:��A�G�*ݕ&
5���蠣�Щ���}���mwa�}�]�Cu���a�-.ar>��U���5�@.� Pgɉ+rtl@�����n1��+�x�a��>��!L3#F�=b$'ʸ�O��x��ǌx�j���$k �d]�4�M](�``<?ŋ~Ԓ�9n������}�K�JH)���zjp�J���2�L��.��[�O�Э�=U�q5� �C��B�J�*:O=�E��Y�� V�6ӄ��YL�_�<L�8�9W3��=r)���&|U<AG�m$.�?�u�v7��KF?�e�Q�2gy��u��KF.$j��#�ˋ����C`�ټ�����Cs|��v���=r �[�P�]��0
��M�Ab��u�:[������7K��U�ӝ���0\ �_�6�RO����m���c����肙DB�'OO����������~��zj^N�|�k�|���������c��8�B��UMT�1s)�b�����ٙns���\pχ"E�Ȕ�U����:2j(��C]�_��B
:��{h�1����)v��\r��*���4v�.t��rtkv��P\4��Y�[	�T��(�8Y3�M�.���Xgκ��f���C�;%�BW�௒��2^3ѡ+r!CW�Y�ς�ϭ�}���PE�ǉ���3� �ȃ\�6�ϟ�^@f��p\����Oa�c�]>1��J. ��ʚ��A.�Ĥ�%�Z���q����\/o ���t����B��:������̥����a0F|�>�����	�A���<1��M��F ��4�����������ֽ�> hoJ��.٭w�on A�j��1�cB��{��������H[�P����1%5��7�I�9��G´�?F�~,��%�X2�X+E[5ͰP�.$ˇq�H�⢻��1ޢ�!��~V@�ѱ�9W3ѣ�ȥ�@^;���a�0��]ħ���$�$L��>|H7J��$u!�%�)t�]G`� /�4|�?�K&e"@&D�\H�	�"���E�)ed�&�L�Ϛ�����X�R@�Q�Q����Km@�{��0�y~�ML��?�~�����K�����    �߾��=��@<�%��I���¿?4<Q�f��ԅ�CP�]�׷�A���>��J���r�oh@,$T�D�43P����_����M2�B!����H�Lt��uD�Uc���{s��@Lz�m��:�"\
q�9Y
v���L���\��x=9�W���oa����Λ@00ȁQ_[e a�g��������})ok�<����X.S�\i��ۙ����G o�����|�m�Ē��H!J0LҙnA�h�r!�|�h��]��u�Mz}p��� 	W�E�E�C�&&�PE�4͜��}���\{������a��;bp�i���K��9u!�Zڷ���av,.��K3=���r�C2��2ѡr!C-�=l��[��� y�Kښi�N]�����%	���w?Š>��+��P�Ȑ��5U��\(~V/p����A���j�j��5��`P�B������^@�
ԋ�bY����P�f�u+���f.`]j!2����us�o�W>��j��#����"`��JY5�t�R�cf�]7����M�����)�c�-���@*P5��2�Bv�@c$]�>�}r"+��8��g1Z!��N+ƹ69�&j�"s�F+ �2�!�?���à6�N����Lt��\�ҳ�7��(�6j�����"�B,0�ښi�qv�
wLg��P��@�;�?�m'�/�@F�cs�2��B�����p�}w�j�A����(H�f��q��Ç �Q�VJK�,B.% �fx���V� tPV�)4P�fZ����wR�W�%�f㯏�=�>}k~�1O�s�bDv��a�@�t�4S�M]�$T�D:ߥK��7<.i!r���� �#��I_��*w)���FƓ���������ow�N��N�������Hy�֫�)RŞp�OS��4z2�Sd.�z��E����x����>�'��G�����k��j��?a�AtɧJ�e��DY��fE��l*-G��0m�6�A����ԅD��qV9�F(��i�U�2�e�k�B5d�G����%�֦#�̂���]�4��H]���?�I,V�Kʞt�8\"RпN�f ���vZ�I�֘ڐ���f�?�d�5��*�d.T��/E'�Eヮ��@��)�R�~�@�d��H'�J�~�\������_@($F15�F ��Bsۦ���4Ť.t�b��k��fy�t�������?�!�ea��M��<��"��h�H�ƥ���3"��A2/]���*V b��-�K:��y�A����$��X��+#s�P�\���a�U��Uc��1�H��j�>k&�,F.�?s�p�G�|ܝ�̭�@����C�S�:�#L�Q�\Ȗ.�/9j���;vp��RrBZKiy��L4?r�:�����������ص����XW_l��x:vWXf��x�+5e҇����f׬�x�'�wkJM��@�j�L7di��O]�ŋs�ö́5�M��~�����	Q*iã��'���?�@�3���7oϏ��3�'����#�E)����D�ȅ��zG��p1��q5*/yG�1&�ʯ�f��S����Ћ�W�n��D!�����:���
	C�[���-��Rryb���W�ns&�r�ʪ$� �J�����IM3'��qb�*�{�0���)�pMΪ�/H�0ֶ�Ki��m2��F��q]$g�^-7��n�m�.���6�Dy�h�L�{����z��U��8�|.��/227�ͯ����s�����F�P�R*O=3Gd.԰�Rk�����&��:)h� �n��j�Me	�Le.�"�6� ���� ����q!�Q� �o�B2͌��.�;#~ ��yJ-����l�O��'L��0�`v�}:B�� ��4 �濣�e�ј�2`��'�R��Lt�\�sG3 TELʇ����Y��؋�:M͉�}vN0�Xf�r^_�ᘾ����(�<uN#TU�X���B;ȴ ?�oW��Xw��I�L�����f��S�vCi"ѮF-����9�A�:��XY5ѭv�RT/���所b��i�}7ݺ�S(�-e*d�� ]1U��3"n��������� �����M`�\9���&2ѭM�B�6eN���X
�W���n�m��A9DM�[��V����!�&3֦�Z�4?B����ZT� $?��Xck&�����{��:O}�>�l�~�D+N�|���6-���z�}8a0���3R�q�����5J2
��Wٵ-Ǎ#����8*p%H��*K�ꢭ��r���ֺ�%�d�l��"A�*Hbv��Ǚ#C 	�圓�}�=��\5�w��BԆA Y����_�'�W+sk&.L�	偬9�_\B�j����:/#0�TW���"����%�:L�m �ZK�*��(�?4#��b|�����������Z_~>W��ߟ�h����^P��<���[2� >��!�U��:xq���.��������*��3Zi�� Wj�są�U�Q�y�U1�{�%5�%J@?�L��&m-�D��.Q"5��&h]�kl
�8�/E�as 6M Y��Fy��8�����_W��}�eU�EФT��"M��_ B�L|�����B�84C�c� ��\o�0W�r �7���l$j�����
�� +C�������p�I��:���ov@��V�Lh�M�U��pw�S�P4�[_��#�[�@I@�AC �?��NY��4�u�.���qHQ�X���Lb��ͬ�k��pj�� b�|5A%�
�E<���f�!z/�d���ą�+�}C{%1RKZ&7��#ل�C��ʞK5�)K��c=��	���iZ7���q�5��t�s�j�L(�@a&�=���u�8&�=5�X���b�8i,n����>�4f�E8�q��6	������#��z�w�~��ܝL��sw��V��M�wb�w�¦�Q����~�1TY���qNr�1�5�^©C�÷�9W���4��]xu(����/������՛Q���r�VJh!P_n���c�b0bݻݝ�|�NfzQ�z��z7L�N�L8[cy�����ą���N�0suU�78��<����t�Ju���.�x�qay#JS���L����������0b&|`�2:�ĵ��j��L�vz�؇�ؐ	�ҥ��0FQ�3��t1�ąkD��{	K��}�~���XW0�q�7��}(��\C�{s�&	��}p��!���]����;\��N8�?�\��լ��
�c�n�8|�3�pt�2ҢL��Ο�V�4%�$j���	�D�G�ń��2�l�v*�pa���ߝ�mK����]��kb0v��u�3����uA�dIO�\�ą���.��Ơz}u�/Jc)�}�C+�T�vD:�1q��%GC#�'������'P�F:+g�� UҶ�TN��O�(���$&� ��^��`,�Ь�y��ͨ�r��������������o����B���<Z���?w[�g�h�E��F��F��0K�(o>Xe�*����&>(#.y���Q;>(�/�a��_�E���d[�@R�0�iR�L8l��Kh��@U�> �f{XU�[yW���� �U�i���=	�HN*�d��Q�S 'Wg����9?OG��dhh���f�p�F��eb��G�r���3��'�����k ��F�K�����@a���J
�"&�}I\�_�B&l�ja���vd�ѯ05��u1����.�M� ?R�ģ�.yU��g�m��)-�NP4*,i̘�2V���2�/΋q��h(����'�x�)c���p��'�� Y-J"����|1�	���0���ϰr�O��[�� �����d�.ąyk �U��br��n�y �э+�xq��F�1���/��1���-<>���̂|���q�|��&. J\8���G���v�od���eMxwpTS4M���	!]\��C�'Ku���4Q�Q�_T�mJ&.�N\8I    �V)��cU����O�ܿ6�sU�&&n�f�|x>&�������s��}�
�2D��w�d����%�X���/�guhL�1KMZ)Z���[8��` K��Gl~;���ɱK��0���Z�hpc���%_�OZ������^�?��߿Zt%-
/I-,��M|�0/��CtLE�f��U?�%�Z���spH ���5����S�KO��R@b[`��Q���}�?MV�pZS�B�I�g�k�ZKz�������>%�H��w��w����c��{9�i�?�&�N\X �?�ɮ��޼��$������Wo�|V���d�|��=y�]*�Я��.�#V�|�]���J����~픐%�9n�@�$|荾�n����58�tyj�����֕L�<؅��38ʪz`/ �x(�S5D�P��L�,���`�������b��}�!`B�����ꂅkP=�u�&��НM�-�����'У� ���U�K(6��Ę��*qa�Zk��ݲ��w��b�q�F}tW82]��9��B�W2qGf����Z�O���`���b����-l������j�u17��G�¢MM����[��kՐb�"c�a�>��Q��0�ܳi�{v�2pu��L�]��88�wZ�o`h�n��fu�ă�GDj��-b�rf�@9����/L���U%�68b������=e< z�?մI�pS6�+wa�ڇl'�S��{��	p���5����u�S��ĝ��ӵ��D�U_u�����9� .�G�<��z9�}�5�S�ޅ4��o���gB S2qwa���S
0Cz��	)Z��y��S��`2�85dCn�$p�]X:���eq��k�N�T�C�د^�*Efb�/u��yq�н��Ϫ�C���O�T����XZ��gF����-���L.��˘UY"}폅��_qaWee��Fݨn=d�)$��R�o��ƒ�q��g `nQ��QZN��q�t�<ք�LhG(4�i��]x�Ҩ�ܭ����k��%�wQ��[�T��lW���W+ۈ@�!tu�QfV�RI=�?�a
in��ą;��c3����A������)����R$D�.e���&.l����������)'#�&��ɴ���)O$.��:U���C��c��x؂t���wa��.Èq�xbjnn�����׺I"h8Sv�e/%^!C��ǥg5��e���,�_���@�tR�P�P�9̻�({>�=f���Q`��HR�O�11���D��e�,A�Y�|��o�3�^㠅S�(9�j�l�4���]�Ѳ-�t�zH�v�wH�d*�y$o����B�ҹ�;��<>㌁���]�gƿ�|��֯��r %a�4�"&>{".����?7���b} jgm��-��^_�ww����ը��Ȝ�o��qi6L������'���_l?^�;�1o�@	��`)���ķT��R�)L���@Fp|=�T�O>!�^]�o�� J{>���9h�7�-�)Ek�����5�o���2��}}���q�O5�͔A����(Y&�SȃoN�38/5ΰ�ߌ+��Uxu�̿�=�M\
��p)���c��5̊�����1�/�O:(���)�"-���s�`�:��Ǜ�c����v�I��,'�`!�Pު1*�$����z��#car��ą[��#�ڭpo��eF��3ɠ��&.K\Xɚ�h��߿^� �g>�?�F_�<�m�F�x�zn��G�'�s�0��y�T�ۿ��S�M+�w�;���֡�U0h7�6�������璘p����������������ꯗ�?�_0x�1�)
��_�x�5c���b+F��j�
�JW�
z�zִ>�/��f)qa��>���TT`6� �% e�*�LK8���IR�|��h��21�D=U�ZW���oͺ�5%�#.��"A�_����>Ġlǲ}��jP��/�f���^����×�?�_����NՏ���f�ۯq ��@v_C��� Q��QqZ8����b���^��W�j���/��_���2���q�p�ߴ��S"��Q�ߠ�z�d��#��7����A��8��J/y�`�j�΂BE�
� aP21��ԅag	{����z{"��9��6����gEkJ&n#n'��qN�ق���n�1��tW>-e\&��-��&�� �RQ�g�U��a��p����D�g�).�؈i�J�]؈�G�*a���MJ���L܀"����L)��&�.��g]cￛ�O�Kd��'�BF
׻�ĳ�.��u��Y��0�X����3-P��2�|v'�W�0�8����%�H\�/X�mCz}#����{ӆ��f��"u�ăd����2B�W��f�͗�(q�
k��G�T�'5qE�ą+B5VS!�P�j�7>`_����S*;5ܿ��jŃ#sSֳ�]�J��nr,� $8��w1��s��և�M���r�M\8Y:k��پ��Q1d�_^/֠8ڭv�8	ss�`�� �U��0���!.���#v��b{խ�aV,�R�� �-�]�Cg]21؝ԅ��J���>��Ux�mG(���B:kS��0F���%w�$.Nr\K�0BW��*��f�/��A�)���S��p�s�����8W��0��؇��K~�fF��de�h����es�"d�sf�I����)�,��w����2T63�-/�_��f)3�t2�H�m�3�*�x�>q�N&�M�����f�c_^��n����n��n|Q"`�V�h�?VQی�OL|����r%��:+����,�jx�"��&����%���U��VL?h��7��ٶ�0&>$.܃n���>��r&�z~W��E9ݲ�U�I��Z&Tː/ZfM���>;�΢�'��o�Q|E�镃�S\Ӹ��뒉Y{���3[�<����>��#W��Z��P���S!=b��ȱ�[��*�1�q�Z��e� ����l��}ډ�ikkw�_��n7<�8�`�3Q(��LZ�AB���Q�-��0����m�	�Zoݼ�������s��w�yu�\UP�����Ÿݚ�-���l�F��Yn���ą�[�z4S��T�,m	8�@�� �4���.�U���	3RH	�0��Y��%�D�y�t;��1n�eܿ��v�֭�%w'.�οx��8��������X�8�~��X�xx�V���xx:~?1�<f2�T����%�x .l�A���u>I���Г�e��t>��H>M�4�7�]x���a}_rˀw�y5I7%S��s���"���Aw���\�����(Za�B��äL� �&��g�Q����Lw?��(����57���u�T���&x�؅�HL@�D�~�԰@,���� Z�YY&��ȃV�!�� ����b��L���a�t F�8[2q�ą#?h���&2Œ���U֠M��Ɩ4E��ą[��~27����&�h,�>��T@�@o�~ꒉ;�.�V~#[&|A�~u؞�aC��y��r�N�!2�6�1
gӤ�م-��"�!��u��0֬�l�d�� ��������h�����_/�������ri'�Q4�I� !���gA�T��������x�O��Yab1�Ƥ��[<t0�kcZӈ��	oR�#��J���}����Pt/<�a�ֳ��M�%O#.�3�ԑY���{��q@\IgJ�s"�0�K�A�i���]x��I�����-N�aja
߄+	�6����q0(�d�Ką-6he�Y"7��?�'GL��X	�񒉏 �AXIu���sc�Cg��A��
��ɬhl]2�wq9-O�;��ψU��OO�!����L�Ux�;��	;��-#�M|�F\�|M�!)2��Y��Сt
�!&~5ą]��H=>`���ۂړm����	�.v���m\ͼۮN ��~�x��:ն�d�9�ą�8��A�P�X���Ҳ]�.�}�W�   ���!�]��m[2q���%�WZ)TK�E�rKw�X_��V7�˅���*a,
��ԅY�赜�����RJ�ab�O��!�������ZFyOt���6Y�{�)�$��|�%]M������'.�D��c�2-{�.�t~�p�U��'i#g�	eQef��o1�<7���´{`wi��v�F><�Y���8�˟����T!���	IL�	I\XރҢ�����wcY�H��<���@GK4*��a���0�	:���R��Ж�vq=t}���֡������b+c�k�ą���$-]��ϲ�B�Ȇj/ҌT:����ն-��d���ɪ������nUW���)����X�7���̐!�qn�n�+pJ��%} .�� z?�	��e���6��̀���~ <�*�'-���u��M�%��@�x����1Wf	�85dx�d�(�`��b�/��7s���W����s��&�5}o�Mv�����m��#k�Z]2qkL\�5�$��q�]��@/;��vZp�z;0zu�_$�����4�<��֐���zqW���χ�㿎��������_���4�%],z5��|�ƔL�Z���(d����Ï�����S��������T���:V������Ti䒂:^
-Z��&�N\�p@	Ak�ﻏ���  ��*$��QdhA�Qδ�Œ���h��J������Q�
��嗿�?���[]�L�埸p�XӍ�%�v�p��St��S��ɱS ��g�O�W2��)��b�`2"{��N���rs��>{�*l���-� ��9�?mH�"7q[��p��F�U�8Ol����b1��yge�Je�F8W2��,qa�Y�0�΀�ҭ�þ
�h5L�Ý3,X,LB;��𯖛�>Z�rZ�(X,��DDh��s�����j�; �	LL׊ V0�*�F%���k$`ΆH<!
3���LS�L��q�V�P�}�����RΟ���}Pt6���h�D�U
�
-͢i��]��xژ ����~�eV�:}��������A�:�AS�Q�hf�:�d�¼�%���i�_�����~���OO��������z}����i���ͩ���7�$��k�A���h��ˉK���_Q�� k�X�7�T��� 󆨴�sTl�Zc�Z�L\'&qa:1��.��\]�`"�pS�D�����??��*��~�<>}~x}����|c����4�K�C� ^k�Ηi?bӄ�#va�!RH/箟gj�H�Nw�'�cE�7�| ���(�J��������F*�rl[�+���R�1�,�U�ڤ���xN2qa9���ᬌ���\���T|�U�adm�)���m��	�)\����n�뗋�"V�	![[ ��2F���c��ą����8������
�W�U�����*X�K�z0�y�i2<č��_�L�q� >J(�R�L��G\X@��t���p��a��ZFI/xE0�X�5%_� .l-��_�7xvP�aP�����d]2q�ą�0��/�t|x��7��
��
az6�~���An�WH\�!��r W�2��"e���QA��W\e�L�͡w���G�n|2�V88	���&��eъ�<:�R�i@>�βd�"�K���q�P�Ԕ��"��G�:�N_�".,�QK};�����./[S��.���4qaPp0}�*���⧧3s�!;��诞 �愮q�17q�c��}�B�&�0�;߯�},?@��sed�`ʨ �b]��"k؃�XSZ|�v1��T��nč:��1�:f�����iI�]�f]�v���ne��զ
���P򱗐%�j#.,���M�L�����
��Qu����ۈq-a
��-�k2#7M`\��qu�<�� i��˔��NaK&.H\�H@��\���/m���Cyz]��_k�+'��AbD:^35M���k��	��~����qt���(}�x���Mܻ��pg�x�`~������ �%����hG�	�� ���dc��ą�kGi;����b���A]P�jU���`q%�1��Ĭ�r����q���u묱�Yz|?}d�*MJ]�i��]8jk{���t����������I[ٶ�Ƙ�\��5��V4��߃h�nݽ�:$(�@�_D ����ija뒉���"�ҏ'�ɰ���ݴp������%ӄ�'vᾛV&��D�sL��J��-���LYE&��&��A\��y��i��n}XC�5f��[8Џ���Q֕L�8q�f�S������П� ��V�z�Ы�WeP5�>6ģ�r��$.�W�c�q��)e��c�����0`b���am�눹�LlI�.��?y��Cuw|������궸F-C���iJ�	�3v�τ����������;C�%�w��ƴM��%���v�{gJ&3�n7������k�3��ח�0�e��ft��f�̜�e[��U'��� !����M�;�N��D@Z[jK�! x2vY2�(&�¢�Lc��h�U��Ó85�H��edi�U��63#�vE_�$.l��Xڌ��@i�Y�b������s4�*�4W�r��%.,��O��N���������	��I�0!���<��r_�$.l��ja�h:���M����0��*�S�*X��>���S��&R�q��/�ryu5��X;?��[� � � D�eL"_؅9�P5�7�����?�˃�.���%ö�5S�gZպ�%��	�p ]�[*S���/���2,7�U�������LM��ib�؅]�i2�z
��t{�w��0���\aJ�I ����#���v�kS�&��ڟ��>���'Z3fm1��(�j�.��{�����J��}���*0HW�J�RP����i(��Lܵ��pײQ� !M�����=md�=fO��4F�e��<XԻ��%?�3�x��8me� +��?�$���&��G\��r�+��n7�����:�8���&�>)�i뒉���ol��o�U���K��������M+m]2�:-ą�iI�N�(�Wz����ʟ���2bK���}�/lZ�l��c��4�.v$��c�w1���:J���3\'dp������M\'��s���v��� E>ʊ�*��jL ����b�Ƶ���G ą� L"x��Ɍ��g�<�3�V����V2�k�ê[Y2M@&�^����o�x;��J�g)�{�c�����y�i"�.|
^�$��}����� ж�`H`�Zض�Rw��)%.l@bmWGXL= ��Kyy�lv�O>��������      �      x�̽�V[˶-X��B��l�Z�~�f�0^�#�7p�eeb��H4���o���7�J�e1�"{��$@,�2����� �I�#�+��C�d��I��Q-)U�('�hm�~�x��:m.����l6>����\M��͸s8<�?���Gss��k�[�����eK	�_	�J��p��_�sք`ں�����������^s�g�nnF7��Q�IǮz�T��|-e�9��l�x�}�EOkgml�x^|-EODmLl���Q���a�d�m��sX�^J	�/�<�ڈ��:(ߎ�q�"�)���Y�N��V���������0���|]�o���us;��n����_��M;N� �:��g���f�R �y��kkz�['�R,�a0�:�Y�-N��mn���s���R�gXi�C[�;k(�/D�Sbz:h�P/#�z�0�R�:���A�i�=x�������A��h	9t?�@#��#���?�@+_+�s��ҵ��zi��|�կR6D��z�v9�̒:�����-b/z�j+��0�_��3B{�jؼ64�B��˿�,ax-m/8�oC��_hl�~B(C TXC��i�@��]φH?N��-=ڌ��� ��o`�A�Ax��(`���bcOh����� ��U��ʷ\�1$!46Z}�p��f�lu���E��at6�,�>��&���d��eX�CXj���3�L=/���ذ�UT�o����+׋�*��*�|Ee���8�	�=\,}���)p����E+$X6*ed��V�n�]�:�����'0�=�ǧ�is9)�����f���?ů���	O[!WwA��¥G�ok��
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
���/d>�N$G�A���:����@�_9M�ȩoFg�<���xB1���r�v樜2S�е�E�45����������5��~�ο!=Z\����n� E��~�х2���WXԟ�U����F�VFpr�ͤ%�V�����e����"�W	�oܣA7W: �G� �:�7���	��9��׳�='ePLE����s߶�V�l�L}��e��~�7[�ƥ޲���8/¨m�< ��?�|���32rI��w��롺����+3n9猲�1�zQG��\����]m�#2;Zggq���3��':�Y40v��)���t۾��,頥eQ��v�(�DT���_�
ñ���zR�ZO��Zh�g�<�0�z$7�2�;�����3.�mI�a�q
��\�"�WQ)���qqMQ1�Gt�/�gi���ţz��g14�@�-�}�@��7�Wĉ>�yɋ97����l��_��_�g@	q�����ɗ�
�%�Ǐ�k��y˳��'C���w��9�*L;;f���?s��cJy� ���N�i���_��N�c ��� W�q3�>U��v�?ʍ�.�)KcK{i<��m?�D��2(-N�C�\mi�n�qݫ�/u��W��Z0X�1)hg2J�t���lf�����:��1�[��E�2y^Q�n8�OMd��ϐ���h�0!�C�/���Y��v��t��Y70P���D�.ב��\��~"��ɧ����0�{�i�Z���7	/l,]9��p 6zx�w�G���uc�Z����a�ʡ#,(R��CEn�F�>�4w�pGmqs��=x�:�=CH�_7�Ξ�����}{tgj$��Wsl�3�F�\��ۡ�DӘ�S���	/�tڜ	�b�=�iL��a߽�FĖ¦x��E�tN6�
��|y���]��!��3��h��'dc��`�`�N�'���A����/F�y�����U��!�&}{:���_]~������4�)����=���d"�A������	��ht\9�$_��g+Z$�U�%�~����D��p�G��"T�	�qY�fe�w]}ڇ��^�64����G����j.+E���8��0cE�>��bn-�`ק8��J�\ħ ��<H����,S��C�y_r�:!WN��G��a���0��Մ��:�!����L��l�D��2�
��"��&���eI��ߨ�>G��ŏm�6�qϴ2�� ��]�?����"9BǨ�@�s��.��O��w�T����������~��`�;/�V�� FK��ď ; � ���G��;��R�^$M)�Tf������Qr����"�B�n����D9����@W�F����*����c^��V�#{�ՎG��쀺��ب���h�1q��h}�u�y��u�0p ڂ'K�1Ѩ�zLL&���Y��h��Ĭe�eA��Һ{���(���mܓ����V�<��]�B�A)[���EeL�7y�}�,���X�y>,����ƶ�׻�E��Y0E�0�[����A'�T�n�y~.�U�PYxS�`x2�}�Ew��Zau�{�o(-�����Y�f�V�qO״��wA�	��,�@�`��eWJ�S��A���ܔᛟ� ����dݬx5'">i���=�mr�F�12͉̍�f�@*8̪Pb1�%pWVCC��}�<���h�V��^�����>�v�K������<�! A�*BS�8�V$�<�&#�޷�/�sa�����u�|��fxܹڶl�2�*��Y���6���]�zׄ �!���T���4Mj�n=���[���{�Rl�q��B���,����\r�D�u���Ο�xf�hO�f]�a��}
x�O�ݽ^].x
�5�.=Y~�����h�8�(�T%��4�r�����[AX��b��2Ρ��1C���\I�@hT0-U��S,�S k6��5я�����:V�7oEz`[�m�	�K�XX�,����K�A�&�W��^�Њ���?�͐0,    �i�S�첯�$�����y�L��������l#=4:�B�B$5�bf�^_���a:V�t�bH��7�₃
b�-Ù�ڳR�MYC�^����zA�y�����{uF޼W.o��Eɟ�_��g3FCn�(��q�}P0��������u����]��p˻Y�5�`8}B+0W�v�ҁ�Z��B�Xwl�P��_�L�!:z���xw���(��(}t\f�ŗC�
V���
%C@U4'��1��-e�jE��R>3�)N;�`�g<E��$���6B�u0J�8�cL�Ѹrr�����Q�MI+��!T:�eri�ͣ\���(*�J(�Aڂ�W�i���fBW�y�?�WG�z�W���1��}��WFz���?,.V�Y6���^�/vv4��"_b)n�?�N��ާ�2�
�)p�B�����|��9�H���m%ʐ���]�?h{~\~Ŧ��>������b	Z�~�<Zh�X����Ш)�q��$L�nKfT��K�����V ��8�B�&�=�����s�g1�)@� fUȎѩcXc]m�����.�<f��'ǈ͍�]��b�=e��!֠K���%<�^r���A�"J�%�\8{M��"J��}�&2c
c.z�9�"��ʆ:�{ʆo*���5��LR<��w�!�Xר0 �N[�Q�"1k�Rs�!'
}C��0PM%2��bn���X���[V��8(��[Y��ā�L��Ǻz�o�MU����{�M�s>ǎ�v� ���]�����Z���~�xF�-�Uob���87��Mt�n�!�e8���=��݀Ԣ�^�D�M�;t�L���,��U4x�D��T�iTF��PZ+.v4w�����(1�qTɉ?�5��Z� xJ��42�)zs�=�E�b�o���n��d9�HW7�HU��h�冯����,�6*Z�����2d>dȜX��ߺ�2��$�?�Ȼ�VBd�<��Oq	Z�|�yfl-��[�z�o��L����j����R���X��JZ�s�C�6�o��_2|����A%ӑ����k+��8uow�h��T��nD�$��d+{͐wQG_������v��/���o�[�S��>~]~Y�T,F��~:�^�A����ðF1�K���ΠNw�Iȟ_����� δ3HB�%�kV;n�v�J������-  c�sFN�V`n��!9��~���"Orճ�D2��7�V�?��B�pcX]�
�XK��k5��Aɠ�\#��[Ţ�����pAG�/��i��gU@�Eot^�u����X}�:�X4���[�tۧJ��"��abH��fv�^�h2t���~��7q�s���0'k�-�����iipH�=f�v���{�˃N��Mn%�l�5�M gz��u�@۹�_7��tM���
y��Uв�E�hNQZ�!Ux<���Q8��?�˚�5�-q��F�������頋%Y�|Thh��n��[n�H�'�GH�>�s�J�b���ɸo��x�hsQ^�+X��u\9�K�TAհ��Ǧ3'k#���g�d1+<��1�K�7p��8eQh-}�LCY
�R&������嶒~�&���5�]����g �^υZ_ЮH�lL�M��
4�1E�J7}_'|_8�����P�9�x�F�`gE��y:`�R(	�|����_3ƍ�ṳ����*�ܵ�x(U����o[8��AEq��e��TD�J�@jxN��j����}'���׫��2�oq����ce=�%�kP���|�|�<��3��ۣ�dxX2e�N |f] �*/"�Q��*Hg�BB���Ǉ��@3��mv�-`^u��\�G`-��G���mL���c��L�ߏ�ukb\�,6���-�$�Ps����;��/D�����_���Rv��ĈQ�_����$��oͲ�&G+:��$	8k�}vu��X�!�#�KΒ���`j���^	1E�.�wV������<���	1EK�O��- 2@ĩ�lmx���D[���?"�� ���d��ܦ���*(TK�㋦F�:����uz �Z�b��@^��o$l�Je�R8�XAZ��3��{SE����l(u��?���m�J�aՒd	?�z�&�Y$��땚��?_����A���|���q�n��bjJ�i+DU�&�v4D�T��~	�@7�x1�WTe>�y�=U���|�P��BBр�!Bt��qt}�6hߘMR4���gs��Aۣ�;7���k�cc�W��1=���>%�B:����S�y�gx��<Pf��������eڒ���>�)5��U(��T��7?$���g�����g�	������EQb�^9� HkL�L���GG4��y���(�'�rz��Y��2s�
�#�9�PB����a�*{Qܲ� ��zG��w�BE���A�<#� 9,p�b���b�L� ���(=&�`���UO��m�]����]�_]�n?���јꍙ����]��B2{K9Z1�#�}>8��������v-�m'
3lt�`g�y=m*�.����K9������9����<��8�މ
b��W��h9�±��4��鴃Ń
df��if�M�]�79��dNH-���y/�!�oɈ�K���}ȮCYl�b(/x��*o��)�L�����l�r�rk��!���6�mTv�n��L��$�u�ϑ?(�n6�
�9�?��K]Y��5t(��V\�To�b���׋O��/�DB�uy^�/0&PN.����=y�@w:x\�Ҡ��M�Ԇ�J�-~�Y�<9.wԏGq#⋾�:2ȯ�����JD��U�k��_���@K�h�
�<����E�=�q��0�����S[��Җu&��*�i2[�&��x���8���Q�Z���-� �O�����1gG�2gG�3���Ơ��Ҙ|L�BX�'�B�(���(��a+1Y��l�a@�8�bS�*���ʂB>�ǣ�����F�6��tV?-�]�/C�����Vb��L~��� �˙h��)�=��U5�t~�<��V=�m��"�`��gԼ�Y�A�H�T*k�s�m�߻}�	�`jc3&;�U��6�7�TMmX<ع�	Q���®[@�Tf'��F��4��xX��7�ľ�%#�
<�1��\��@ʔ���68��)��h���T�Ra{�ĝ��K<�!�C�C�i��P ���7Ɨ>��{LE��JC:,C�E��8[��iS�U��w�a��5%�)��BB���yM!k"�U�e���B
�tV�r����k��8�,�~x��%� �HrIU��~��O��)�C�RDW��ת"E���)�#� R���-����;g� ���}ą*ˆ.2T_0t	��!�2Y��Y�/g���� �v=|�����
�G�e<2��Ru��&��C�҇�����t�6��"OT��PW��(�0"E���&�W>��	�>^�K�b�����U�#��xz�)%\i��ހǸ`�@��������Q��0��9�
��#�s�`�A^}�h�����Ą`���e"����W ;k��	1Imwv�����wΥ����u��2$�2'( P8yw��>M��Y{�2κő�-\�w;�u������p4��qUSY:O)�t:,сY���z�t�m���r�<,;u�Tc�XZ���'���Ə{�c�W�t/hú_��r�8��]��kԺDBɉ
ݎP��
��Y�p�)۞����l�G�60��|a0��0�y�aH�.8k5�ִ�{���A;Э��u,�q�b<�;�v]�>0-��B�&��m�s@𸣒ZF{J�����hc�.�(#�j��Å++�z��F䲈9U� ��F������?İ���ac�c6xau��<���f3N�.�&�J�&�[�����?���xMk{�;By��[�9hS���1�#��l���遙����a�}�#sBw3A�1Gܶ[�1�*�1�D�հ&�VQ���lGGT2�����&�`3�F�`R���    ̼_<BU��ډ�s0]],{���Wе�_}��qk]�\��EN�ŋ{� #�Hg�v���8��bL�~�����.V_W���7���Ϭއ��d�Q�ш!��F�U��.���Mh�,~�S<Q;�I�vj��|�=9lD�
��>n�Y�ٛ��=���,:N�[�FK���Fz�YC�U֡��u�^�C ��xJ�Q@0���я��Gҧ�c�Z4و^ Yi2/�\�#BP�  �E
Q1h�gH}?.xh����������{L&c3�	g�ZP�9lfhE(d��]d�:`�X��}]�ye2m %<p:~Vn;XO,l�+F��q%�ʴ˷�V7��ޛ3r��D�������i�*
X�\�;�6��c&tY���<�P^�Yi�2߫;5Г,h� ��Wl��A��beܽ#&�����[�̏�덹������Ƌ�����d����dT�s#�#n� j<����	���D�)P#����C����B�qVpo>��z�N�B��.0��5�"7���W�0��1b�,�8d��삄Vrq��Ȼ���"����v^F{�:'`g�%�%B�v<�b+u�ݶ<��&@Щ4P<�^�p� �|�i%i�١�˗�ނ*��2�������΍��kPa"�g��T�z���lq_�|����J3#YY�s���c�&�w'}*���Vt�fC���\�a��1��.x�*b~6�«�1�AQYX�L�1��=>g|�#�C�����`-/�O�p��L�d���P��*���-kG�+m �!/���R59��H��������g�8L���
#�H �r
���"v�g�.��4�d sF���Q�?ף��j �S�~��b���M� da�ahE��~�Te��!����|T��櫫�P����OU[�������'�v"gp��b��2���N�3_���Q���U�ޅ�B��rn�Y�:����v񧆚ܲ÷�ײ~6�υ�H%-p�#��3w|��28�%H����h����,�&ՊD��@��M�W�7%�{�o=TM�/���:~���/_/eO�.��ĝ�Y�x@�PT�*+�����y�p�j�	<�� �B��g�e&��
:���xxt��u��2�*�g��Sx[|�����gv�h腣���d�܊^�KG�1�{�8�{�ixŕ>����yॻ�x��n�:��iUa(O�;b2�P�������TGU$U�?CY�<��2Sz��#J)ADGKQ��㾫��W�\!�Z�C>�����R��i�����疩?�º<�N�_`�pN�͝��y� c����J0n@�O�$�����V��P���p��}�h"�P�\#�����j&�+y����T�VbR�3����e�$t�\��`վu^�uh F���!Ƀj��C:W����1	�����\�_��_!�i�wL�{t���њ�"�k��=EI�<��ϗ<IG�D&��o����׳���Z�Ҥܶ�3�3ҎポR]��XH5u����`�ю�A�ڮ*�څ�ÕmL����1�9M\�J��9�H�-U�ؔ ��yj54
8�ѐ�Ei'w?�`r��)ͪ�d�AŚ�(�VWͭ�%j���ڰz��Lx�y�V@'R�Z���Ũ�2I#��$���5��y	D+E�j��tuu�&P��etz@�d�· z	�=�˽-k�*�]�P��1#��]�L���K���oW���3���g��yW�����ym�Je��|\��;`�7��R����[���|`��!\O���~�!�^�V���$�:.���s�-���% ?N��nCk�+
x6����쒋�e��]iN-���!<�]a�>�I�Kk��<a��������=��`���:*�r/�^���9�n�N�7�D�H��fc��}J�ˣ5+94��Z��S�W��1�'���P���G�}�{{|x_X�����;T�J2�Ĭ�ʚ�7��;{1�q�3��5wv'�(���ЛN��qcJ px��]? 8oaoowp+��୘p�V�2�ZEv�:3�,�2C:��Ժ�2��Wa�5�U䣾M2����v!# ��U<GH23�k�@JsfJ�����dyh� UNOrR�ɾ^�/9�����2D,����#T#���p�j�g�gU�PF�3+�ꡀa��l�M	xѣ�����/�6��_|Տy�<3C���ٓ7T��[]"�ɶ�4�c뛓7%��)��ѱfg^��(s���cb��xt�~_/�ݓU咻{VM���~1DNm� j��fa�V��y��Z� ��`����E5]��b��s��fz��n1�m�M=�(���L�l�����~.�Њn�Ň�+�&�q��|�qUqs;�����1��`��Qb���"[d�7^n<M�f \7��������\z/�k�N�T������c��mㇴ3���:V���Vx�j{�k/����v��x��ā��<�����L-�m���Y�������<����x؏��%fYd 5��E�����P��J���K��n^�R̔E��#R�r��1V��ݼ���dt:���C��˕�`�����l��9�__Οh�Z��²��B�)^�\*�0��u5�����硡P�`�򧶪٭(��^2��z<�FӶz�3�c�06	�x*�\qʐ_}f�r18�j\GB#��7����c� 7?K���2 �ٌ���֬���qI�sݽ�0�p�CN�����a��1�}@�W\�r]���z)��y��z|�WPu��T�:����s�4&* ���@lxI�o���/�j�^�.����Z�Q%P�B��^�R��TN3IۛA���0�B'v! �<��J s	����'���@�$�� ��ǃ���B��38=�$�ƨ�e��u\ی�k�ο-zoW��q�����A&?
_CY�r#��$8�1E	0��gǧ��������Ќ���Y|z����nȒT�h	,�� ��D�E)��,�w�BW��(�+�3ϴ��3c��T�[���DT���?ߣbwgn�t��3�cpU�k$�b=zY�l������0�jnHdƈV�0�����#}�ɌW�6��5G�����A�y66�}�oĝp�V!a�m�A��{W�b�b�����eVS�az^S-*o��L�-��R����~נv�?\ƞu� ����u�OKo����9k׼�B1Q��D����M~�em�l���#
�,+u8�E�����p<��z3������wo?���{XIaVg�q����Y*6��{@��}�Dw���OYC�"r9�,��0��`�&fN�ǧ���T����u�ty%��S�I|��������슯̀�o>TԵ��ݶM��`9ȳ��f�A )�쨮{�U�<����4w�(�f��ې�o�f�O#����({d�W����1���_M'!`�Ig�8�wV�u<QJ5����M�^�9��3t&��@��+�*C��H���B<K���|B����'�K�����(F���pU �KM��,�A��XŊL���z���f�9U_<�`{F��$e�Q 1NF'��C;z16�k��gsw��*	0�z�:�J*�(�T�{$����/G�p��^%�ʃk�����?��f:r.ނ �Q\����!�C����%%��e�(2�T� �h@��B���N��Ui0�M������-��^�6_poa#��Ne�Ѱ��d"���.zYXZ���Q:�>�RU��b�Չ1��ZtM8m�JVm	'��]�>3�G����V�̂������s�D�_�~����i���v3Pku ���}@��m�{��Pz�|v��>BK���S��O�r@��w_ ��eF�!�6���/!@�ա�2���Zj\��ya������l�Ep.f�w���ƈZ�LQq3�n8�j�����9P�"�er6|��B���͌g*�1(�f�`ju1�q �wi%�Y�a\c������~�߳G�f4�����lGV�?jȻ	Z�)p�����O'�^��ˋ�m��4{�qԎgg�G�.m �  m�m3�߆�.	WG%f����9�7=�J�hL�w���:��U�� 0ru���z՟�#�r��\�����O��+���t����E?�M������﮽�	 ` �/;�(ڟv�DN�3\������3Z�xB�u�X�H'���([)��7���>�>I�~�����W�M����q�eAM��� ��A)2�]��	%i�,�M��dKɉ (���c�$���B���\)	xxl������{�櫽l�]HW%^޼Y�:��leЎJW�WP����H:k.Vg���^�W�0�d3�6��uL�N/�\؉�v����4��C^S*�t�����8<�w����0�h@��5�5��S�YT`n��6�182;\h�*wV%وΚ�_nSQ��Je���d�7	��q�R�Á����ٰ,5���ݚ��AP������Fw.=�A�KڲNu֘�Bx��vp8�G�w���[�D��l�q�}�� �Yn�B�#Z��&���<�R�'{7����8����~r����u��������U[�b;\��:�+G�_D"�M>�R����?��f������j�����Fr��eeuu�tfӺ*9�+WF,��c�Ƈ�3���18�c��7�v+��Mu��3݁�� I�@� ��IA��e��T,EŢ\	�ofW�״<��[�n�-b����a�Fjۏz�D�q�04��g���ɘS��:��m��!��L9H���p͍�%^eJ:�E�ȇ���~��
+n��FA��G�X<nϴ=�=+����/:�q�)�%(E�eR�pz��Q�{N��ƀ"$��{1Z��C1,[�>|���lh��[L�n�BvN�{MFȔw*5L�/8�@OT�{~���5�У�#��]�c�q>H x����ɩ�ٮ��p������E/�����7��nK`�wLߴzMu/=�!ka~)m�G��y��<<e��/ r�U����;�x��<�x������;hTKf��se�<��;�4r!�4��v6�'����vF����0ä�,�@�|av�D1����b\PE`='�@cRt�l�Ǻ�+�ԟ�7<\э�>�n�atnH��7Hj�Xâ;�, ",x�����b������"~�
g�<�3	<�_����_~��K?!|      �   �  x���]o�J��ͯ�{�jfv�˷9*:�I�zQ�2	��GT����F�7"��"?�3�`F@��]F���"����ڳ	�/I�>\\X�_n�x�5NG�S�:+V��߲y�Y.���z1Rw�G�>-W�7�l�Vl�k�O�Z��z���
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