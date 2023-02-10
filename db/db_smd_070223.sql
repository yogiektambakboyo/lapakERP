PGDMP                          {            smd %   12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
       public          postgres    false    309    6            �           0    0    customers_segment_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.customers_segment_id_seq OWNED BY public.customers_segment.id;
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
       public          postgres    false    231    6            �           0    0    permissions_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;
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
       public          postgres    false    6    233            �           0    0    personal_access_tokens_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;
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
       public          postgres    false    6    261                        0    0    purchase_master_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.purchase_master_id_seq OWNED BY public.purchase_master.id;
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
       public          postgres    false    6    264                       0    0    receive_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;
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
       public          postgres    false    6    267                       0    0    return_sell_master_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;
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
       public          postgres    false    270    6                       0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
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
       public          postgres    false    297    6                       0    0    sales_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;
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
       public          postgres    false    6    301                       0    0    sales_trip_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;
          public          postgres    false    300            *           1259    18748    sales_trip_id_seq    SEQUENCE     z   CREATE SEQUENCE public.sales_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.sales_trip_id_seq;
       public          postgres    false    6    299                       0    0    sales_trip_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;
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
       public          postgres    false    6    307                       0    0    sales_visit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;
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
       public         heap    postgres    false    6                       0    0 &   COLUMN setting_document_counter.period    COMMENT     U   COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';
          public          postgres    false    272                       1259    18330    setting_document_counter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.setting_document_counter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.setting_document_counter_id_seq;
       public          postgres    false    6    272            	           0    0    setting_document_counter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;
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
       public          postgres    false    6    275            
           0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
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
       public          postgres    false    278    6                       0    0    suppliers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;
          public          postgres    false    279            &           1259    18725    sv_login_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sv_login_session_id_seq;
       public          postgres    false    295    6                       0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
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
       public          postgres    false    6    282                       0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
          public          postgres    false    283                       1259    18384    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    280    6                       0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
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
       public          postgres    false    6    285                       0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
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
       public          postgres    false    6    287                       0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
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
       public          postgres    false    290    6                       0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
          public          postgres    false    291            p           2604    18423 	   branch id    DEFAULT     f   ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);
 8   ALTER TABLE public.branch ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    202            s           2604    18424    branch_room id    DEFAULT     p   ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);
 =   ALTER TABLE public.branch_room ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    205    204            -           2604    18723    branch_shift id    DEFAULT     r   ALTER TABLE ONLY public.branch_shift ALTER COLUMN id SET DEFAULT nextval('public.branch_shift_id_seq'::regclass);
 >   ALTER TABLE public.branch_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    292    293    293            @           2604    26922    calendar id    DEFAULT     j   ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);
 :   ALTER TABLE public.calendar ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    304    305    305            u           2604    18425 
   company id    DEFAULT     h   ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);
 9   ALTER TABLE public.company ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    207    206            w           2604    18426    customers id    DEFAULT     l   ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);
 ;   ALTER TABLE public.customers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    208            <           2604    18777    customers_registration id    DEFAULT     �   ALTER TABLE ONLY public.customers_registration ALTER COLUMN id SET DEFAULT nextval('public.customers_registration_id_seq'::regclass);
 H   ALTER TABLE public.customers_registration ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    303    302    303            C           2604    28164    customers_segment id    DEFAULT     |   ALTER TABLE ONLY public.customers_segment ALTER COLUMN id SET DEFAULT nextval('public.customers_segment_id_seq'::regclass);
 C   ALTER TABLE public.customers_segment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    308    309    309            {           2604    18427    departments id    DEFAULT     o   ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);
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
       public          postgres    false    291    290            s          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    202   �4      u          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    204   �5      �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293    6      �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   g6      w          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    206   >L      y          0    17942 	   customers 
   TABLE DATA           w  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_day, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    208   �L      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    303   G�      �          0    28161    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    309   �      {          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    210   _�      }          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    212   ��                0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase) FROM stdin;
    public          postgres    false    214   �      �          0    17984    invoice_master 
   TABLE DATA           W  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type) FROM stdin;
    public          postgres    false    215   #�      �          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    217   @�      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    295   ��      �          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    219   �"      �          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    221   �'      �          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    222   �'      �          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    223   �'      �          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    224   �*      �          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    226   �-      �          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    227   �-      �          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    228   �.      �          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    230   OB      �          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    231   jW      �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    233   Rg      �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    235   og      �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    236   �g      �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    238   �g      �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    240   }h      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    242   'i      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    244   Nj      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    245   kj      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    246   �j      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    247   \p      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   �p      �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    249   �r      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    250   �w      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    252   7~      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    253   �~      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    255   �~      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    257   B      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    260   ��      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    261   ��      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    263   փ      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    264   M�      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    266   ߄      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    267   ��      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    269   �      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    270   )�      �          0    18736    sales 
   TABLE DATA           �   COPY public.sales (id, name, username, password, address, branch_id, active, updated_by, updated_at, created_by, created_at, external_code) FROM stdin;
    public          postgres    false    297   Ë      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    299   ��      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    301   ��      �          0    27167    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    307   �&      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    272   q0      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    274   �1      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    275   C2      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   �2      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    278   P3      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    258   �3      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    280   5      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    281   y6      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   7      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    285   f7      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    287   m9      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    289   �<      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark) FROM stdin;
    public          postgres    false    290   �<                 0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 22, true);
          public          postgres    false    203                       0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 13, true);
          public          postgres    false    205                       0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 2, true);
          public          postgres    false    292                       0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    304                       0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    207                       0    0    customers_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.customers_id_seq', 235, true);
          public          postgres    false    209                       0    0    customers_registration_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.customers_registration_id_seq', 254, true);
          public          postgres    false    302                       0    0    customers_segment_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.customers_segment_id_seq', 2, true);
          public          postgres    false    308                       0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    211                       0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    213                       0    0    invoice_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.invoice_master_id_seq', 106, true);
          public          postgres    false    216                       0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    218                       0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    220                       0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 276, true);
          public          postgres    false    225                        0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 1105, true);
          public          postgres    false    229            !           0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 509, true);
          public          postgres    false    232            "           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    234            #           0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    237            $           0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    239            %           0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 13, true);
          public          postgres    false    241            &           0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 22, true);
          public          postgres    false    243            '           0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 153, true);
          public          postgres    false    251            (           0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 24, true);
          public          postgres    false    254            )           0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    256            *           0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 26, true);
          public          postgres    false    259            +           0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 18, true);
          public          postgres    false    262            ,           0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 31, true);
          public          postgres    false    265            -           0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    268            .           0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 12, true);
          public          postgres    false    271            /           0    0    sales_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.sales_id_seq', 28, true);
          public          postgres    false    296            0           0    0    sales_trip_detail_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 3779, true);
          public          postgres    false    300            1           0    0    sales_trip_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.sales_trip_id_seq', 3645, true);
          public          postgres    false    298            2           0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 38, true);
          public          postgres    false    306            3           0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 39, true);
          public          postgres    false    273            4           0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 10, true);
          public          postgres    false    277            5           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 4, true);
          public          postgres    false    279            6           0    0    sv_login_session_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 1471, true);
          public          postgres    false    294            7           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    283            8           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 56, true);
          public          postgres    false    284            9           0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 42, true);
          public          postgres    false    286            :           0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    288            ;           0    0    voucher_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.voucher_id_seq', 5, true);
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
       public            postgres    false    252    252            �           2606    29120    product_type product_type_pk 
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
       public          postgres    false    3398    202    204            �           2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    214    215    3416            �           2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    280    3514    215            �           2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    215    208    3406            �           2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    221    3435    231            �           2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    3500    222    270            �           2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    224    3430    223            �           2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    224    280    3514            �           2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    208    3406    224            �           2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    3514    236    280            �           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    250    3462    244            �           2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    202    3398    244            �           2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    3514    280    244            �           2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    3398    202    246            �           2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    246    250    3462            �           2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    3462    250    257            �           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    260    261    3482            �           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    280    261    3514            �           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    264    3488    263            �           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    3514    280    264            �           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    267    266    3494            �           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    3514    280    267            �           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    208    267    3406            �           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    3435    231    269            �           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    3500    269    270            �           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    280    289    3514            s   -  x�m��n!�ϳO�hf`�]n�5Z�6�zh�fM�j��з��6� ����&�J�w��v���=�N������
�&0[#�D){8�!	*M>0�����԰_e�`��/�SŢ�IP���T#U����H��ä�Aƶkn�g��4�JCQ���!�7o?�M����E��jwv���[���P��z̗0��K{
e��	�I�2��tGw:��KW��PčMz'aqhZ߆R�<�\�4ȐJz�B�u��󁮪xk�t;-ph�6�y�G���Yt���o�?%��H2��}?˲o,@��      u   M   x�3�4��T�Up*�K�N�S00�4202�50�50T0��21�21�3032�4���2��p��/J-V00"�!F��� �J�      �   7   x�3�4�?N###]C#]cK+CC+C�\F@FX%���1������� >��      �      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      w   �   x�E�=� @�N�`�%�l*=�UZ��H�I���ʙW|�4�z�C�bm�.�cL�%�q����ry�-ֺ��.���� X߹�	�K���FG����)��Yo�ږC@#AK$�Лo�{(!H��[� -Q��s�Y],,      y      x��}Yw9��s���9�2s�fcO@��,ZJq�p_ש��ŒiI���]��o�dn\�.��,�l&��b�&���*��<I���bڿ��A�jA��Q6��^��%�gN�xO�{��*�iO�ʏ,��B����>N�׌���JR��O{�a�������ş�b�>���	�d��?�o$�}Z���G�%��D�����j�yې���\3���e�0m����)�~
/IF����?#�O{��}��~#\Їm�����T���ވ���$3�2�T)F��<���J[�Z��۸�$��X/���h��Q(�iL���M2�ݯ���M���-a���{�S-�?�p~�Q�0��������&��H�F��|Y>���r�e��I^��:�,pTS�l�^��FYu>�X	bI�{Z��1�|{!߁_����X��:LP`.��1�Pѐ/{!t�8��&i�R�?��1c(e�<aSiOP��g�8%����p2�O�\-f�1�g�[87٘\�gY��A�C6����0�Γ
�Y�s%.����G%��6�
?�	7�hr;���I}!�ȧ)������~|��0��*���Z�Va��\v�[�׵�[��<�J��'�	-.��d��{�Sv��Ϧ9OzD�*�v2MXz��t�=+S*;8��e�,��d��Ir{;&����Rm@�8���i���((�H���(�O3��2�N.aw᏿kNL��O�����c�cXX�p�^p�c�2������G )&,�9ʁӅ��U�<y�{VX�H:���O��7��	��b���P��Y>H>�V��5A=��|۽n�7d�!����p��P�oω����.P�$�R7�$�IR<��=a�5O�0w�i�S��k/*����a�y]m�N5�����_G3�;�T���E6�@�)(Fr	z����_!m ��0!`B�E[�l H�D�f��)�m�|]=&�
0kr�]��._��K��1P���䍥Z�Ar�U�_����z:�����'��J��S�ݫ_؆d1Z���LY<�͍J�CCm8YHO�{�	*��i��O���WyJ���J���j:��K.�wNˏw��Vl�X��r�\��Mn�w�P�E�����`����=��zOA$�����$O�������	��yU�������~��w-�텐�e����d�y ��qɊ���������u����~�p���5#����h
�H��!�dR���!�[��]6������޷�%f�, /�v�%F�Ģu�$�EN�d����j��|Zz�;�2���M�
XHx"ڰ
јp`Gr0�Θ��|�L�l�-�wO�.A����כ�Ɵm@�\���GH��`��ڔ)��}E�y��<�+X��4�`\{ėe�1F·+؍��W�$�E�Pb�C�<��_��K�b�A����;�M��:�&q�y�y�c�� r!�ʘ;��i1)�)dTG�Óq6��]�CH�-��b�yr�����G"�"Se�\Hd��
Z�������)Xh���/,��<�Rf�?��:��!@yH�%k	[�D�w�ۓW�r�J��2+QᝤLDl8����/����k�����>|�;�յ2��ԁ��߬+zuѕ�y� �t���/yA���z��;N�*.���y�@�<a�E���I��LV4yy�� Qvgʂ���L��S&��h�
���?]�5^0� e�� �7��.x��棼�9ƣ��*���&+����$�������$o���fC2̦YD�־��O�[س�N�	��(ӊ� ��	&���/���m�ij���2MS8��u��x�����QN@���{ܭ�ȼ��w��^9�Pgi�k�VQBtg@	U������|X>=��rS�5T�.��do��@ ]Zq�O
@|�e7?%xG�W�@���k�T�v�I֝��zҒ@2����R� � R<��)ǵ������J����{�s�y� �a�{� ��ph��P���.@��?M{�i1�"8�<n�������T���r]S�
�'az����OH4��z�y+��1~� ��r���!�d	������d��������[񘼭^��?ߋ/�[����Y?�UϐQ�b80��b��J&�k9M�m&���2�[kD�Τ'^��l�x8d_e���_x�����BPh���T�J������!�����n����Ѽ�>�F�z�e�"����!eM/8�h�r�R�T�
}䪲�<55Z����gF�Ѕ��x_��)��L����������������8�����@N+`w��J&�cl^H.��̓�F9i�{IY��φ������C>@��~�ާ�[v����f��U�e�}˞�1��~�������10��>����>�8�h�n¡ [�f�Ф�?���-��cѤ�i0x�]
&��&��'����	�)`*� ��T_�^Mx*��'��' �p�����` �~�����Q;�5�\`L��X�D;�<�`Hy�|r�����Ꞁ��@�@�?I���\���dƤ�1l&R	�DbB�/��*��h��e�eWd6�>��O��A�����1A�ݴ��_���E���4�s���{���`���;�I��RO�iI�K�F�칣�u��Ha ����%���L,�-,��1Vi/1(K�'P`���fLޑ������{�=P�M��?�p4�洙�CV�y�T�8��z��v�e�ޏzu��-�ߗ�Ҹ��?[Z
�;F) �ܠ?��mW����j�`C���|� �s4c]�a[������bJxrX�
g�F���:����l��@��� �<���)g1��왩#T����9�"#���,��L'3r=��4��b�9�r7!����'��p8��&�q+����5q���t<���L��Q)�(pH�2
���k��,�
��甃�f� ��e����t!'�hL /�hE�4�HTi��s�=^vx��Q.ǅ��.݅�����
��ż?�����ż?ͪ��k���|FL�D�Nũ��1�D�CWTc�+�����I��}���G��p�U���,x��8���K��?s��׾)	}]��p��&0�(����e3�nf�Ǘ����>/��f�
Y3����0 ���}��)��H�ԲA�� �+��M����\A�7=B�_�q8OS���˓����$���!�"��Ј ��@�'_�ِ��vuH��. �����C����Ff������&f�$�| C9����3���!>Γ��7�� ��ˮ�2��@�`3�Ң��]�g ���B��S ���-��ѯ�%A���(�k8��Y�3�Һ�� ��-�齘��&Ҙ:7B������A>,#0���5=!��-������N{�R+C�TvI��[P�<����W`8���gPw��b[�[�C�m WuW9M�����U�T�I��x8��Fs8�>�|� ��Y��Em�T�(�.��t�����| p�Zd�jp���x^S1_"8��褀����׃��)Q�A$Y�z�m+H�W�b�bm �!�m���үl@�c���iv�L��|6t"<�<&��9��kV��| �?ei;[a\l�!�����}�L��秈 ��z�_���]��FeN�����q�l���󗮼�˼��T/eX	�Ε�zz��`D���J0We�ugL��'���Ӻ��O�<rہ˾[nw�������u��A��,R�"ͭ�1��ë�O�]֫�	��`�f�Dw���]2��lx�{��"�B:�(��^��tl U9�*�A%f�A$�'�dWk�]~�t�ǩ�p�<�&� 	rե;���e�y��{�ut��9��D����^�J�U���X��\+���ё�e
C'�5H���Sx�:l7�/��5��=��	 6�c�����s�!3_!�j�� TN[�&�ȉ���7�@K��|�nwj(�    ���Kd,���]�C�	NS�0н|"���j��4�LE�I�Ap���E��$�`�]>���O�vG`I�c�C�{`&G�ߋu �u�Հ��:?��7�mt����tq�W�'�}���{R
��
5�R�VR%tSb%�� ~��4e9�TEIЖE���^�v7���9�E�Q>^\��Rv�f����0݁EC����`jE]<�3d�T\�&S1Ԉ%��6����ٝwDQ��pE۳�R�5
��ټKc�	����`���c�.$f
�s�a)���j�d��)�����eQ3YN�׊;S!1a��zF�S��{��`u0��:���e�qX �1^��(������P��0���61�`�y�h1@^=l�P�����}餴F˴�I+�\V ]��/��z�%��ퟛ=�1T�pԿ��*��]�ʀvP7\)�k���&��eJ�j�3iյ������/�z� ���e%���!HlC9qm���&�R/�'�� pk�cɴ���;�e��|:������s�[nZ�K2w���㛱�X�I?��{W��(z4R��-D��-⤀�r$~f�SW��dܿ�L'���`#������_���{����O`�����}]>2�`�@zL���Z�w�ȿ5t�Xo�g�������iĆY�|�Mf��c~u3i�\?ԧ���T0�{)g��Y�P���c"��Hhy����$�sn��X�,s)l%���|����W��a@u]��`Tf�ɴ��=s�,���^�ֹ���E�
��fI!P껃Ɍ��,�ZK	`)&r��r��A=���a����?VO�]�ʄ���p��f[Uga?@I��8,��;����'��.�> �.��A��V���!��ʰ, %Z�A㾀�0����7q�*�T��Õ1n�%�,[`X�� ���|����)���W4�U�T;X��s�'ao����a��x�Nɻ�ٱ�=7Xvv9��FM�|�ě.o�N�5���&bm�*�fO�'��\���_��~VVg�Q"ǩ7�`��؟ SY�Z�܇6�e�)�������w�@� 1r-���V�:#��<�-����:2�0[� ���q���fR:<�@F閙r4��L\�P罯��0�(ȧ���'��~~��=l{����S��E���j�%Uc\�xhʔ�j���l�n�P2 x=��>���9�v�����A��@���JfZ�g�4��"!�|Q��ZP�%����	(�QL��ϻi�9Ͻ��M��>"|��8����)���Py����#�:��#�1 �u���9f�,�O���Fo&�1�S[�6�����Sݰ(��'_ኝ�Y>�o܉�5R���ϫ��K�4
&��	8sٞ�ӟ~��!�U�e�ԩ�>�J����6c�����Y/;�oOiL��j/�r�R��V�����D��u�OjDrNb~��#�xHkL��� �����n���V�t���{�~�v�|dF���O'��k>������A/��@��s�r،/�dZx(Uwz��+��(�>�k��DvD�׸�X+`��v��U���R֊�H�`��l��k��5�.i�u3�QdH1W�_��$����E��Mx��6���-���wn�U��°��P�>MZ�C�؊ޣ@l�hb�-��o�mU���,E)�?��,��i����Pi���ʒ�ؚԒs��N�_���~����U"4�e�����^]�>ΰ��6˫UN��z����tWU��B��2u��Ђ�WU���a��+�!��we���ع�**4`�s�V����=�'ߊ�+@�OO������<�Lc��%�蹂�jX�l�0X�+w�_��x])H���%�l�� �	�%���u�0�Hө�!rj6qq��p��*G��5�6���zT>q8�{q�"�.:��)�f��w>���b��+�,v���������=ɞ���A$�bj��]X��w�W�����s�L "��U ��ʁXV�	�a��i�	'�]X��=�%ۿ�Z^��eS��^%�n� �	���n����ڨ���섳"�~�K�ѵ�SG���tKS��z�S��D�!�QUu&�\���Ϻ7�
��֏�Hd��3�y,usn�b���0;��ìL��sau���1�a��Ǵ�o�k�}r�V��V��3f�^;;49BZ�q�M��[�+54b�C&Z=d�*�*�h��nc�a�^2N�|@�f �A�F�%`����[u�*���vž]��)�}�7�����0���6Vd�o�֡�vX�V��Њ��ɋ
��>��	�dQ��2>�\>mI|z��>��}jwV��$c2�|}��{mH]&W`�08�\W��UJpp^��V��b�}�̗�opX�m������oQ#�sR�}.P�Ƃ�����·����jx�u�������7׹Avus[�p�G�3vʵ=�n�:��`&�đP��������Ԋ;�"q|E����_\�j�ٸ���t�q����Y,��:���c��hcq�I�$I���_�ŀ��%�
S4C8�pH�7���j���W6G�d���a�Hz_O0�p�w$uk��k4 樰u0�k���Co�	(��d{�c�f�ž&�=�q���Yzp4B!�*�<K^�oXs�nŮ���ւ��b�h�#]]}��US`�d�����),���h&lk?�"������UN��0�j���?�9��5��`�i�*Y�i���]����b)�qXt���@f�(7�&��󤀭|>Iu!��SZ6�6ʕ��(p�8�4@ǟaPH�Ȏ��|����,�g�G��ݜ"����6j_-\�[� �]O��i�w��ѩ�)�BH<DL7f�A�����5Lqsώ���^0�n�v�F��7R��z,Z�*�3�S.x�M��W����^N,(8�o��OC�+p�E��4�
�bm��?Z��@� T�S���7rJ^�$C���K$�d�y��鑷��
SH�X�[�{�Q�Pl�}�W�N���N��s�hE���*L���s�#C܂�Y����&���M��/�|*v���Gh�6��oX�j(� �-���81�*�/D���ʤV�8d�g�)�$ -�S�oݐ��B�)�p��ii8� I�C$y?ڇ����F�Y�^����z��O=V�@ءx��T��'{~��A��	e9����|�ۢ�Kb#[3�M��w�2�jě
���aȓa��-�0�o�9�PWZ�&=2(��7�C��!��q���GO�����8.�W5��H+��鬁�T3I�S�u�y8 �����[�%���np����g\�f�萴MG�LVh�O�0���غ�S߱8�Ӟ�����~�X��k���-�:�Yk��:Z쫇Q7c�@!$�RX*x���cj�I�^<��tS<��q�ڿJ��e�5;�(���r��S��:;�'" $ʧ���KW�L��b�yz[=��]�1�>�-բOtH���V�"��\+{h9��3K��ʞ��-��dӎ@���b��9�v᢭�
����KW�R���O`��sqE�r�0�����q�;dd�1�OAmx��]���r*O"S�qI)8���1�o�2�[>��@%ap��V���<�ԏ��e�dQPjT��|@�2��!)_{���1��![Q_7���{@�����p�����ɝ#+S}j��>����BmU����{���]�>���Ĺt%�-w�^.Z�D�(:G�2�(��O��џ��2^̲���t}�{�T�C�d�*���� ���1i��оT	M"ۄ��)�>����+��`ˌM��'8I8����� ���T����r-������5�F��
��'���|��('�]��o�xzZ�@u�Ȉ�ѽIe���v3s��yN������C%��z[`�f�U݊&8	�t���K� ������S���qǱ(�[6������bK*Ce���O�M�����O    ��w�ܔ���)jW�e�4���m�Gڻ�T?�=a�+P-:2���|Q#p2�t1z:~�l���lO�5���A����q��;SL��sλH��4�U��z�@~�#�P ����>,Y�Gr��>�`a�L����΋?�6���@�g����g�\G���<y�AY��x7�x=F e�D��+qq�!����zR�1/q���������'Z�V��1��O}(�6�Y#΍���{�p^R��Ûl�O�9t�bt6̰��<Ԅ�/����F��Sl��(N�KZ�˄�8���(ei�)����Oh�y���=����b��m9�Q�5�z׻��p����!�t1��S�4*�gC�x���I�#�o�	b��y�<��z2�2e�'�8G[�g5�0M#N��	��(t�p8��x/@�8����Q�}����ق��+�/uR�q���M�Xg��&]���^4t��6�Z0���͒8�r����n�ȓ�^i�������j}���O֣��
9�������_w�����=-o��4��͛8����7 ���d�:�X�'ZlS橻8���ƽ(�&
 .��c���ؽ��G��'�����f�y%X@����)��s����o�J�oPZ�WLx���I�i�𕫌�&���=j�}�A��/�>L"t1�9ֻ��Yc���`i,[�nl
�(�#KU�4�t}���x��b�ف�:e/���8�����@I�F��n���w���q�-m�B�K{���w�]u�e��1� }������R���T	�����[��2-�z6⼱fH��\�~_ݓ��z�A2]{e�D�`�hvyR�TjO��$��7T8���3������)�o�SZbU1e�T�6O(Y��<��XjGy�9�wT]��������#��F �jz���p��9"p��]��G�W_7_
rF�����R<�^c'�+��kD4Nj���}m*v0	e��7���-)/  v�7���`z��ܼl���`��*��2X��-/��A��S�����I�b�bCS[����f����24�K���$��A��5@��lП�_�����,�%P����f.U-�_�������OCc�g>��?���+�� E�pXt���9;ex�ƾ�ϻ�8{�X��uY�Å�sj�:��Cw����g7�j����m�8RWӽA�0t�9�A��0�D���P}��v�ƙ��*��_��s�uE�ԍ������Γ��as!����%�I�h�T�Z���`�Ŷ���gM����q�CkJp>�x��g)� �I�����9�E�b�O�H�M[a�ߊ��v;'1���Y�х�Ϋ�@�S��R烷X�ɹhp�.�hS���/X7�P�C�Ω��(�Z��i1.�8DkPnV%���r~E�1���v֟��\��Hv�teyVh��A��V%Yw�q�c;|q#��H0x��RQe�����f
�I6�������p�Q>&s��J7\7���Tv�7��Rb4���HXK)!S�����W�pץ��_�Q[D�@����['�E�C$Ċ�jz�>��5)�A�pfbO`��j��F�{8"�S�]��~�i(`��R���n���{%J�rSl�<����8ܚa�,����q�	��]��bY�h1̦؂��K����U�!���8 �sI[r���kY;:n%�
����T����c H'�|&����c�q2�r�W �
�~ozF�x�)^}6���k��k�nYl��܍XI{[TZ�c�kR�x���Y0�0Ñ�=���E�$��?CuHG�1>��^R�����3gЁhb�6�����|X���a"��]�Dd�[I]Ѻ�5��L*�+�*���a?Ǧsz^ N���*��v���N)�~vB�I�����F4p���JFx�Nz�c֛^J��7¹!���/s)h��N�b?{%���Щ�jR?|\<��"l���v� \��	�\����W%(â�Nb��[p&tk&�+J;�9�ǭ�~X��Kf�[��Gnv�|��M-E^%��l����n� �D8�Cr9�k��m)pO��hM����j��^��>��U4�u^�h�k���Qɇ�`��5�_���x�<�p����.Q���������_]����އ�[�N�1�\!7T��`q���wg�i�m=�ihq�?h�Vy�k���V�<;��9�;����4~�%�6�o���]DK}�|�k:ށ#yG�{��mr�ˇ����6����_m���ةF�6�|g�/6r�C�����ٯ.H뚪���o�v?c�ԭ�#o��Շo�[AD���5�L����T�ҹ��UI����|�w*��|�3���6�������A�����o���;nfTic:}Ŝ�����}Q�|w�����_��n���yb��V������r1\�}�`s��oҬ�gV�8�0G	�ؤֶn�N�@
�i���J8]mۜx�N>���@*o���x�xh��)Kj/ǁ������f?��lųqr��t7.�X/0H6Z=�j�����gqzպ���`	��O8ig�U?՛A��P!�ИK��wOQ��Q�Q{/,m�S^NUW�e�{쯹�T`���^��$<ʫh��v}f|��r�8������qS�W���ڍv��۳�žU�Aǳ_�[�Wtܒ+"���WW$9&l߳�pK��"o5��g��Ul�f�B{<E\nYe��yq�ƳZ�I�����p�|$��}�w�eir=��%���w!�y�!o�
�M����ʑX�ߧ��y�Rl���MѱX�X��������2S�]Vӕ��йU��\�]�,(��^rT��?��/�����z���{�g�^/O��K�$�7�϶��2�e:��.�F����0��C&3Դ�]��Nš���:�=z����dHn��lA.��s[mq0	��fd�S�Ek�iyS�MX�A�KpiеܐOŷ�=�)^�\=�k�b{K�^��k�dǖ�&)p�X�����n���� ���<N���mn*��FK�YHk����2F�+?l�/}8 �8#G�cl�4����. Z�}	�x�_�zܦ�6�y�W9������?�x�)�Gd����=���F�oVڧ���:]����M�D��c��%dM�\�D�2�+O\�l�,(: ��)�q��r��G�G>ro�	�+e��\�X��wO�A���|�0E��H�Hс��b"oۻf�xy�/Ӂ�8�6B�����ûO2ɤT�d�Y�I�A_TQF��}�/S�5�X���(m
y��~��
��
�T��=��I�zΨd�G��x'Ŀ@ sQf���ڪ�@�������*LT���i�bT�h�y��2Q����.�eD�����[zJ�CWl(��E�߀=��ao<��q�oO�Ew����)��Ћ�y��w�8w��tdW�ޞ��T������~��.�p���JU�D�$�|�1�p6��*)d��E^L]�ɘ��R4�������<q� �`�[� ���$����Vۼ�K��$z�gP�q�.F؈Wea����Y4b��a��#�4�R�����rwUYee`!nY���z��!X�3��6c7@�/ Ob�8�\�6n�"��4'��D�|���.kǾ0��g���R��e���p�y��>8�0�r�p�;��ސ���S�3Ԙ@^t�� �=���8�������_%oYőƊs+;��I\eu����1��V��s�&������"]F/G��y�%i�(�{iC;4���<OՆ��I���/�,y��������1��^|ZG�� x�^Exb���Ў�2y*�P��7i�-�?m!x�i~Y-i�D*�����3j�j��d��$�u�}�]��I�����v�(����	�I���H������y�ϿW���H.Tz������b	1X��_{����݆+�r�`jf���~�~x�Q<���u/Ŭ�H�`�:Dڹt���ͱ�ؽ٦�Q,]���1D�wbCY�w� X4�R�Y�3�`���c�$8�ܭ�Aai�L������X7ɳ.��22�}_�|����q��Y�N��lm�vV J  �j�UIt�� ������N8&���VtŹ�Z�P=����}cI�	�h�3Vj��àos_7�&�	v��0����	:����Ԩ4a�c{�j<E���@��4\M 05ޥ!�2kM�B8�Y�Ƌ!qk�*���x1#�!V~�0_�۱z�U؞�#V���|�Y��R�*��
�|���`�1�l��
�����z�Ԥ-�äan��`���u>%�&�� G�w�19^ݳ�
�q�|�c�m`�>�m@�<�a�b�&.5\h�s���g�U��0����V��'2���F�(~`�6�5���c���$ɍ��i��pW�CA�M���\��;��p��&= �1�CU����9%aJv�;#�8���u7O�%c�I��x�B���g��E\��1gS���*o	w��`�d:�Ԓ�Ɣ���VgK���j�C� ��5��ͧ��f�*�L��);��R2��cv3]\a�,@�P|C��y���:k_?|o��i0����;��c�d��hRh!�������N.u ��t��\.���b�zG�����Sw6D@FoY�V�K9߶��a��k��(w�-O�Mdݻk�i�Mg��ֳ��e7��U�x�$���,ȥ.QlQ_�T�jh͆��X�L��0w��-��ŊјZ�g݃A��~"&� �8Pk�O��3�Cy*(��?��߹=_W@�v>c��jR�phn�.ֈ�Tzڱ�
1��jwoE��j�XE�ொ��{Yb'��wx�l����#WX�DVo�-�Sך4-��gƊU�V��4�p;�ue��X�����Ҫ�n�	��Vw���T�Ŝ�l6�'u? ��ģ�Q��^ 0���_�-�i���m� r�u��*7����?�Ieᢦ[8xȒ��9)��I�}��E0;p`֗0+�݄��O� �j�xB)n:����c��\�Yf\��w8��"�&
�6o�����`��y�����Xv�I�\�����9w.���t���՟V�!�������s�+�x�)���V��EY���.��]��5�a�z玡J��J�!Ǳ�d9^3���&׻5�=|���a�a��V4��&�|Ns-�-JZ��r�LH�n��ʕe�mxc��ӱ��8��T�2�B!��:jߴ�����cEw�بr�v>k�*�ʄQ�>6�܍���g>�_M���$LFw�^z�������ck�p���p2�5aA�4�S�b����,�,�T��?M�w��mx�H^@��iJ`�|X���V��.PV�(P}%���\���<6�r����O'c?�d��fS08p!�)�.�������j��e����F�f��]�02��������Z]$      �      x��}[sǒ�s�_Q�3a	�W�i�$D6q� ����H�)�$���������h��~X����̪��/�e�<gZ�����쮓�?/�X���t��z��'s6��6e}�]|}bI���
�1�ӌ��L�g���&͒_��HF���d�}��M��g�6�~�~}�7��)I�E�jť��G�R:�:SI�u9{{_ξ��K�ȓ�������b����%R�f<�P�﯏�p�+�}\����y��Dr?�6{�����l���z[<,�|��KR-�r�+���O=K�L��4SFK\&�����)�q`�5�	�)�K����|~\.�f������r�=.#,J���\��̊�C,�<����RNZ�jild�΀�vN{4�2aRW�:��'6����+\2y~Y}�,O����t9_-��?LH�K�`iv��7-�Er{�G��Պ�;ؚ�qɤNӴ��g�	�2g��Lp�/��*�뾦�(�ǘ��	mc�}���1��� �S��b>}\,O��|Y�H���qu��#��I�r������y6d\8�أ��ʳg�s��=��Yi%}Lަ/3�����o���K~���=����U���/���z~�Hޖ_�o��r��j�E)�$o��
���3�r�e}���Y�0B���J
%�^x�>/���cM%l햔\�U�xZ��Մ��ާ����X����g�L�
�g���"%���|��#�軆��&0f���1Y� G2�/�{�)xD+�g�V�����:0��c���/^����dP�iq&Uˤ��r~��+A�)�H�Ea�͸�&u.N�pPqP����g+y��N�p��t��*��B
�57iӾ�l�:3X���)�x'���d	!�R��54��ͦF�d��[v�۶~9���Ƞ*�I�!�K&���W�6�?��/��
o�;�W�ܵV�P~��l�fY�vk^��#��$��}W� /�[/��PꙒ�����Il���e/��	{��g�r�ǄIZ����1�U��f���ȫ c_�lIX�p��Fhq���'������[��O�����e��ǂ6)�]�),��%\ǍX3P���[)�ʐ� $p��#�hL*��w��h�{3�g���Oy���s��ߡW���啨|�����ߝ	C��sl��̚�7y���M����yƼ'����_�L[uS����4C�Q�qRT%*��}�e�J8���}d����_�^>����H��m�Pq`� ��(O��V�T��u9����1��S��/ϓ����[�y� �� "�F�� ?��ɠw�wX��~�����l4Y����ّt��v�O׸���(����8
L���u~7�,~���L����^�x���uz�@2;KmK�F ����5ҝ���[�8�pH����L���nAkN��<��'��}��n;�$u&3�8H�k$�I����S��N˓*z���;"��\���t�0}��T͐O�iN��ѣcv��^f��Ҹ8�P*�0��:���� /�ד�5h.�ZG�"2�#�_��[@�����>�t�:�O/�*ɋ�g(�}���+N0���'FU����b�V +�^K��N//QM��K ����1{`�ɷ������w���lt�_'/�w�t�Z�p���^'��9�-�/�� .����	�����hpq�߼@Ms��H��%9��3��a�$n��'��.V_����E�xn����+�e���H+�|e��X�%�)Ѽ.b�����Ӥ���.-�0����a޿��]�@Y�}9�_�bu�6:��:��ݠiԙ��0-��s6�x�M^���Ì���ɔG~+�
��z�K�ThN�q
?%%�L��6yy�<��e�<K"�e��O��J�N�������i���XU �?,൐����o�{�x��=��W�>5�r-t�����	(�Ɏ�{�Ą��  }�u�fG�j5U"��a��_\l�����u�*���Ȫ�gZc�S��C�N��7�z���M��������s���ų�	^8�����c!�+]����p�	�~ny�
k�}"��t}vx������ۜ���Z�<�c��L��:�[�e���r!��~�L>�d�qR�P���?���C�t����8 N��j.��UV�=̾.�L���3y^�/��������=�xPwu��L�r��*�@��P�Q����nf
�4p.b�}�/�.��e�\��3�gp:��L��a80Ac���ZN�`�f�~�\�7V{��l���
��������s�82ԓ��;�}�b��Rf�L`�.0S����� �nq����wy�1��������"#��
v��o�1�)�9�Z��~��B"�i��X���˺y�-�H��M{8��N>w�zI����.�"���0?�J�����������r<j���$:��.���
���4�`�������6Ip�W/���qB�E#=�?��3N�))o������uN�=�7��h��>�Qyi��[]����-��J&�/�ٿ&/���9�d��p�3������ �$�]��G��~��W�#�B���&��%^}`��Τ�ҰEG"R)ץ�MQ��܇����~��Rg�B�ҩ�J��u@��_������@�5E���
�8�"sAmh6�RI
-9��o�pa�L����p1{�ߗW���m~����{�������.��6�T�|�V�x�0�F�0�.:x���f�������z�c� :=�o��M���Yr��_���������s���t��T/���x:!����¡�/ �Y���8t�m�>�T���%�Y���0O��:յ=�/s��Q���wY�f⹻�^Y	�n/Fl�����d�D�d�7���MK�
��w�gJ���p0bW����]�oA8�=`�����3����K7�e����QA� �	}NO��<1I.�z��"!orW��C6_�wu�)��)��)�.e�� Ӱ�k^zx���;n��Q�(�D���j�BZ��_w9��;�����r��:��Z+��������S$�_��w����A	�Q(+%2����d+�C�D����/������~I:�������YZ;[fєo��h�`;���`�X��?Y�mA�q�����3L`#ݩGJ��z;[!��hUMi'R?������$򤟟�<Ă��~��Uf��u#͔T�Ɂ�6YM���D�`�B<�ay���K{ꌕ��.�=�n�5g�	*3����Gz[=��-���a�pw��3%oqbj��>���o��I�����1\2��	�\(]�����}ʻERFn��N)����dMJ���#(���i8�q8+����݁,B�ne*�'P.ɇ$,tP�޿·w�Š�|�	�e.�]�:�Kڹ͊�x�5�e�xn�����ᢝ� �BE�A��%�� ��lI1���e�.����d���Y����N���y �e8͋�R.��P��+�J�g��'��)��/��������	B����F`Q9�F9��M�~��GM�G�`��hl��̎ˋ�P*ʹH��a�ݓ��� l�9��&7 
�����+R޷-��Ssn�ws�z����	��i���c����������G�(�1�|HЅ��X���c�.��5�w8BL&N�����O>pt�~���KV����RY,|+M9����N_fϳ'F�g�o���%���R{��0�, ��$'q���[#���`(zazTΎ�kBQQ{a��o LM�q�
�<���~Z�Tm�����S���f˩��H��j,��!��'�m`�*`d����c��:���K-���9H'�k[
�Ǖ^a�������	֪A��\1�z�brk��&���ﶹ�}��3xi��s�˓v.�*�EPY���q".�����n
OBkX��͊	�~,?ğ��tй/-���Zw`_�z�F�/���i�k׆>����A��Ҿ�8ꥆ�j��਒J��pPD�J������_��r�\o��v9    ��X������6��^���ݗ��\�R��sA�OF0���TR��#ل�	n���!N�6D�S.�w2���OS
;���,X�N6`��L�[L�#�yMś��}� a��H��C��2y��*ߕ%��h2yN:ϭ�z�>L`��XЦc�)'��@Yِk�[�#3_��W5*�E+!R����v��2JR����Al�B��N"�č�s�'�/TȄ/z���؜0�2��\��K��E���(Q&��J�2��W>�y�n,\L�+�� ���4�P=-��e�G��K�$簤ԊRn$���,>���	���c (��b	�q��aQF�(���Ј�cw��U ӂ�N�[����r�P+�5�8�)MU�̀�Ai*H>�\Tq���?c�o��{]�zH*(Fآ�ۤ4| !�7�dj�Q!- �GEUԻ�,�6���~��w�A�ò��U�|H�e|1�ΰ}޾c�;h��}���Q]+w��koО�j�|dq4̯��d�|���ɭ��Rh+��&4"���!�FWeJ��5���.���JN��|�r�Fwu��)���uRĤ�:����u��Рu���!^\�]�������S$;�U����q¾���a�����$%4N\���pe|A���1��vco8㞯Z��qec��/8�����{+���畇�[i�����&ǹmuLxT�U�{�R}ɯs����Y��m�q�<JZ��,����g ���U����Y	И�����{�,CN��݃�7�S�ŸZ����r"�_��M�'��>bp����>����1��W��uA�8_\Q�CB�p��E֩,�������H���]JrqB����sG��r�U)��k��ޏ���BKs�%<+�S��unބ3b� r�2J��.$m��GBPL�R>����������p�l�L��2 �@1��)us��s��D����p�K��>���]>��9��0�S��>�;�����2�ɲ:d��tg�rT���{�����S.�sD�_Z�v�����`t���7G���/�Y��(�8�����g E��WJ���b�:�y�z��݊qW����y`���� ��?��z|y4�N$y������m�}c׭��x���{-փ�;���'�I���E���;�0~]=�^�l
��)'�";����@7O~�D��b��(��H���Ec��X]��	%��tfF��I�����$dk�M^�5������u����0���xxDJ�lj�ܒ�2��hv���q(������!L|Q~��͆h����CA{uB��̸,�TY��]���:-D���p�McG��2z��O�Ԁv�H;d�{������6F���<KU����:)̭����4���q5(-��q �S*�WE��Q��4u
YgSn3aw{��7��%��U	.o��r5ֵ5�	Ҍ� ם/�~�և$ɟ��Q��(*�|j
�D'����i2'�2y�>{`w�/d�Y5�O����pto%�(����EL�4喥ǜZ����,��FL9�]����#^-��\J���
-�/�P|zu�� s�%p1�~����O�(O
�<-lw1(������^f���(�� ���y>t 6.�N��s87�%0�`8���9�p�o��|��=���{�=�C/CW�jȏq�3�u�R'�P�G,�n����u��ErB(j?zd��O���ͧ�;��q����:_��]=T�w粭����iu���[��/rb���v���f �1���!R1jS�Ҁ]�����w���S>�3�cy�S4<�{��ռ�#1K]%������ȴڜ ����>��{ d�琿nѻ�`�"W>rJy�zA����X
=��R�W�n�U��fFE'Ȑ��V쭡�*k����������`Tv����|Hj�O8�֋ݼ.�(�E���Whn��(H��1�֚��~�Z�y�i����+D���Ӱ݆(\��#��*ڥ�2��'�P�B��j�0&@��6f�M�f�� HcE�H����T��9n�Z.kC
����/W//8�jz	?��X�τ���m���Ig�>����A�U�� aāⰒ@�j0N�L��$��&xS-�oc;��r���Ȇ��=U�]\[�&Q'�K�u*H/��a{�)>�*
���e�w�� Y��sx*8;*8�w�~��_]]���g��'�cA����	r���0���~l����R����`���5j�3��J���ˀ��~Y/��};A�e���,��А~�e�4�� '�H,"��6�[+���Ɗ��,<�LR�SN�̒ (�cw)W�@ЯsYe$|ؗ�%���H{f�I��Z���"퍇4������Qq	�3l'a8��\���0�Dic�n0óK�-l�����ʸ�A����}K�C�P���j��˓����-;������{�Q��Wd=6����y,p�S_\>��V!$@c;���I��j��f�ܶG �{��q��$$ v�~{ZA)�l�ue�(�x4TJ�ݿ}~�����?�FEE�����v�T6�����1��@� >���	9:6&ֽe��|��)i�ԠB�7Rb����-��,+�\��84ly�FZv�Z?@���۰F��$�/���_�Ġ�M�nV!|O�PD�c%���\cݡ���u�|�2�ց��$<*'�,����^L[��
��
�^W5(����4��R9�Z��~i�����AVzE�����8
�����N�ڛ�߇��m���亩"K^=����uL+��A�D�) 
M��C��qu�e�/�/�Z����;�z��ߜ�
�|)��n�Y�z��Jm=+Ĭq^��b����vP���[2�����f	D�����V@G��ҦVY4Pb0��N��0Z����"�/s��_�/���[B�u�y#�B���K�iW�Xn�W֠�^���z]�y 9T%�j/"�2�S��1�E�p�E�*��պ.~�$�\3�3*�9e��[\�x0S_�p9�}��V�Ey��p�拖Ms����l��>�S[}�[�EK(�6��oWTi��8��8�.W�\�K=�G��y��ۡ�<S������$M%u޸?�rT-�q��g��ֱ��31���M(�kJ�8��F���X̀&#6�I���$S���d��=Ni�"{z^��jC⌏�ߨ	�n*�����̅�{�B.goc�����t���tVg"llj�
m��*��|h���.9c�ߠc���|b&�'��J�ޮ��JC�����z��:�3���5-XSI9z-�L(񸛽�&�4�,Kj���b���wT�|WԊ�3 ��-oo\r��	�|Qy�N��/�5�"3e���FM|�"q%�Y�Q�%6j��S~�+B���+9��
�0LX��խi�%�lVKz~�|{�����s=�����FY�Xd��K�-��� ����2hAIbF> ��z8��ԬQ�ib�Ha`���TX-�&�[��Ӷ�b�/ӖC^����"�-� ���_fK���>xh�Q�6a�&�	�9_6'5��3"8�'��rU��X?�5T\�ɼaS�GdF�j.��d��@˭�gz�0b�i�+ꕯ��K���	�����[7p�GcJbo�U����D�Y�kw�<̛bO�/� #G*
�r��ԯS��ͪ��jˑS07�O3Iy�$�v��	 $�˿�~�4�딺���5X���PLW��i�%� �D�Ǆ^��N��e4.P�Q!\��('h�&�9 �f���gKh���N�)�y!'eօ3:�i��)�@q�h���+� v��ؤ�������%[)����~�H�z7�OcNl֣��3��+q�b��'���oo��n��� _}���r:��#�H����Yc�.+��+<����yNƨz�?�"����������'�o���p÷Q�zt��͟iAg��M�hh����X˴O����(N��섀1�4<��<(G���0M>� E���s؈w�����A_     pg�|��3s�~���3��|T����v�|��q���������qH6tt�����h�gW�����������{������(~ҿ��D��iԍ�2�D��:]R���߇׵���Ԯ�E��u�l���G�(�\V�/�'�'�ߎ��@N�qC:�)�i\B��~�f����7%�W^�i���UQ[?8V����ay��U]*bh�b^�����2�i7��j�a���t�:�11|��������e1gc?����QC)F�KH�:�Uu���2<�Tʓ�����{����h: ����ry�o��l-�e��^�|��� ��ݴ{��3p+U��Y��O4�R��������䦮sX�}Ը�P%hhx��z���|�5�4f�j<b7���
���r��:�a��˄F���Բ�9�Y��۰���TH�ש�Y��G���ɡ�ޢ�>$�O*=!���IHb!�J�F7�z:'-t��Z�oD6'�3?��ݵ{9���1�0�9����4�&_#�S�s(���i�-Z���[��f�S�8�<H�t�B���,Y����)������A�:m� �H��I}5'W4��S+M�~O*��OP�҅���xxO�����3j� r�53ժ�����>!�GG=���T�PU�)��]��C|�;��l�a�F=7�Q��K�ϩ"�A]o�$�p�ñ�rK�3��+�7���T�O����V�
QV
g5.�i/�)@������O��N����ᠶ�J�O���oE �)h�Ѹ3荻�J���`e�3HӠ����hn5�e�"N����S�-5蕪����
v۾hw�.f���|X��0�i����>��������Ĳ]��9�e�Y�p|�o��C�����?�5!
2�$��j�5���w����9?����$*�o��6��M�R��	R<m���*�!O���C\!��9=̨*Ǯ�P'���M�
�kX�])�2y��ˇ1��C��S�N�C)V��E�M��^[�L� #ëv�����U��:c��a.SS�^�^>��M�'bf���iP��U���E���[H��[�dW������u睜��MN>�R&����ћ*l��F0fm<����?�aZ�����h�MRg����\�п�d+J;i�)��?� _Ļ3��&��I:�@QЭ{)8-_��*n��=MU�
:�+�q�$�������:��0浆���Y�d�4R�p��l�R�ҚG��њ��a��U��]�@d� M���sGo8yEF��Px����B�Q&��Q����������榄=���������mA�6?vm�mr��G����I�@�s$���_��l�"sʖ�O�0t1*�p�{��aJ��y�^��D5+M��������:6��WΚ���Uy� ͥm��9E^���7���&[0wX��Ȥ�wWRm��2G���P�w�_�9�PT�n؎<n>�8>�
��dg�����eJV�β�5%����IA�!?�kӎ�XzNl,_��4F�g$��h%U}O�aF�_˹�T�Nɛ���ǝ��Q��lRᶁcI�؛ΨӎK�����TQ<��y�,����h_u[��-?��-]�Z�'�e��ʻ��݋f3�����f�}�j��i)�:��<�~���3�<�N(װ��]��$*�����ֽ�[�m�:��F���_+����=�>J��_�Ģ�-cPrlP�����7��E��7���"��G�p���u��7����&M*��=-D��ج�r�O�����}�POfF�}�c����yvI�ޘ��E�'���'��#���n3�߱#�u��KW��q�IҊ.A;��z�k�Ƙ�����@|Ϗ�Wj���q����m�5�.����W���Qmϴl������=?���Qi��TiSN�S۲,��U�//?x�_BEd�����bI��V����n�F7A��b���k!�S}^-�#�T�2 �;����lC�R������/���ˈ���k?R��G)v����N\N�aC&F����w�S)�і&�P9�������4�]Yg��2
ld�����Ԥ|���2� ��e�4�Gꓮq`)��f������������gV�V>C�Y�&���p�|-U��7�e.5�����P�+>�|�&�-�˾̀����A-��%�>w����\%3G��2���y�%�?%b�8�1'סV�ar>�l@[ю����L��hSc��-Uk/]`��8Vy\�+Ӕڲ�h����c�Tn�r��?�g�,WO�2�?̖3F`������5���P�(�{qv�ߩ8.�\=��k5{(�sf���3S��6�B���m�XNwEZ=ғnm4K��eN&�/�%��_/��˩g�ьK�[����R���wg�v볡�����:c��`�?���pS���FP{����1�IuJY�G�w`�擯O�ypb�H%R�ӧɒ��PsށEЮxB�Kv�[�+��-ܭ�GM��p�W0�e����>Oj�3�:�'\
AE����vhº�B�	�J�g�a��N��N�>˽��?�VfdOh�ֺZ66U{�b�x�v�l�p�� 9�Zs�4pC<�B�������v�ҮSF����3�fk���k ÍDBRY��	w ��[�@�]��P��U��S(�Zoѩ˞W*o16����ݠˮ��|�Κ��3��4�����01�b�C#�,� ���t�L�WS��3��y~YP5D��O�A�\O�����+��&�+55��4-K�]���dO�w������H(���O���zg�J�0�u���Tt0�a�C`�7��_����=�N��iJ�9�\���|��c�*���iHAz��*���8���&���*6q�����Z��\����T�"��4s�KN�p
���ߵ�3�?`���\�������b��KA�~���WW-K7Ҳ��O��
�1�*?�W�|������S��~bY\�к��@D�/�Zp���|�ch�lj|=���\>Jz��������N%̻|f�%�C`W�gn_�����=��a����E�XΌ`\��ye������c.Ň�;���	ϸ*��%�У��$�'��{�y�e��Kac�X����b�g�\�ˋ��a꽚:o�@f���P������X��z;��5-�2f��E0�+��y����o�uy���Q�\�G}�R��u~S����x�:�8�T�.7n�E�_A��̦�������u*V�Pk��띄ur����|[��Wχ���[YY)ebY~Nw���7�b���Ag8�5���[ �h�PzhFU� ��X��K3٦���X;h�R�ѽ�_�z�ҏu4l�yzy��jАo�34�T����(P�<?��E?ԭM3P�~LUﶨ$�j{&���@��a�	l�\Z!WЕ�����!�а�����
��5��Kv�&X��ICQ�_m����8�]R��q����6Vn�b+�X�ݴ���(�a�����S�����u�U6����FQ�·4�/���t���&�:��x�M3'��ĳ^H��1&58 [���=t�ڀQ.M�+ǡ�z���3|��b
�y��]-���f 
���Fdj{��r6��a�֠!Ӗ�	�ĵ����5�4ԔsC����~���Fw; ��g;����J뻣�K���g5�L[9�;;~=��&kYBeg	��6.�EN%�uF�8j̧@���p{�
��Ҍ'{|��QPi�f;���⓿�0^�p3�҉[(n"� п-S�#����#���޶70F=�t��p�a��-4عgRh�xK����5 r|BpFs؂��meP�eTp���7�o;�2ۖ�Ǘ�S.��������O4�A��m�?�Q�̤�o�7k8Bg��]�B���\�&��ׂTH�d\P��J�j�Q�U��㮴��mܿ��՜��T?R��7�qjȗ�^��n-�k��0f�tr>�M�[-W �>��ϖ�,�U�{!��5��1iG�e�M�և&>�.��֒��8CF%�4眜�.t=u3 �  t�Ş��VJ��a�Y���l�'��O򩏼w^tٸ3�Dȣ�A7�i�Hh �y�R�i#͒j��#h"�7���:���M*t7�gR^*uaM��͓���6�x�Րepb״k#�c���b�K;�oY�����i)BQ皍G�F��������p�o�!\���ӳV2|}
��6��f �{w-�D���I�||Nw�~�{좠2ġ��4┦Y#SjĢi��NeX^�B���s��=�xM$>����2��ʕ7�{�����.�����8��Qq�.�6���y|�Bv.B�P>��;�:�.�����*���f7�|������)��:��ug����IJ��LKS�C�nC�1�>��C'44�o1�ܿ��9��/�c��YGc���a��U��`6-��{�Y��f���s����B�K�HE���5�7 ����N�;��\/GM&���wa��ݰ�eޕ��'ݤ)Bs�����]��Ԁ��s��B�S*�٫�@U���d�4tx�݀���K證�ߝ�Ȕ陏����.B �%�VY�?`۩,�$��$#���-|�;l�8'�e�j<�։�>q�,�.��CPf:t�U��T����,�<{�C���N"-k���0K�L����q�8r��h�#T��|����h�:��z�;���d�5�f���&�;��m��z�*9�o(�q�o)��a�y@��╿T0mAѧ����Q���ШQ����y�1�;iL��IU&���wz0U��ڣ�A;x�X;���,(���}6�Ѱ(r(Fݱ�O��e��FE~���FSTk�n�0aW�:`T�"z4�#����ɨU��*�Qw|U������+�N�(yE�'BXݰQq��~��z �FKCQ\u��e��`Y��S�~�g�@t�:H���̏*�	�6�+m$����M<�JhX3�V>I���"bi%�ُ\��V޻�#�����|��Jk��l�n����Y���.T�W��sf�<���j�7W:��4*�@�S|P�$͓��Ʊ��p�w�sW�T���?�WBR���'{d��v�&���[h�2�SLG*!e%����e�����Ǳ���l"��[��mq�E�Qt	d`lE!�6aP�6�I�J�NH�!�>xvxO�v`�4��h��Xb��_�g����Uܦ}�M��8W
^2]k��:o�;|��O珓o>TP�0�S�o��U��B���:�Y?���W�����
MSj��nl u�!�
\�Se�- +m�{�����n���$�j�$���*Cm,��V�r��H�d�+�K=�%e3�9N�-4v���ciT���Q!�=?�U��AB)�>A�C��C�\O�9|�&�������o�K�O����`�Gqw�w�Rӯ/6-UG3kƗ�J� ٠0�#�K�4�X�I���4���h`*�3���5��l{�@�����)حu�g��y����_�j/8�7PG�Mxϩd���G���Ed_4׍I>�'J浟�߮����>D�+�U�L��(�
�n����>��+�D-���(Ö+��n��W�˰���S�&�.:�-����~���6��ؽZ�/�������9�S���,�|�8]Κ�l��T���(���r�pH��0|7��f9�j��E42�=,��n��YQ�w3Ji�|k�)iv3xwYf�
ݸ�Ƃ�r�1.�Rӌ��%��Y���W49�A�	Y��H����3����	��z[��J"��Z}�X(����$�0�
lǽ~�E	�l�)�2p�,�2����[(��<��Wb��瀲8~캅���5���� ����-������M���5��a?d�rA�B��	�%3�gև�
��~^��*���2=�]Π��v#��!�ρ<=������.HwZծ��z -�i�����p�L����a���٦4ּ���ţ��e��֦���`�@��p89)9[?[-��"\(L)�5�i�)��ъ�p�����]_�p�Jv���2^�5�~�zT�/7���j�qU
EY�,�حI!�r7��YT�Y�h����NUп�� 5P��Nu��%b��]ڊx9�Mq5'�:�} �dr��:Ł�=Ce�h���*m��1����<X��y1�^�	d�gK�k���e�ˮ&��㎨��Y)	�G7_���� �9�-��#$k	�2C-K����+(�M�,�%����a��ʬ3�yA�7��t##u�4���L?�a�$��{N���^���3V�J���F���zȇ-�D�.����޳�G:������F�HJ�x�z��F� ��W��ߪ5�����=v�q']�cm��X?瘖?�؈&�hB����EAe ��T��j��kry�M59�`�����v���de�I$�Y�$��Ռe��R*'m�Ol�ʸ�>���A���9���AL�5\8�X�v��l<�·�
�2�7�&��6IQ�f��Q�I�Y�n�W��76Fd���O�0a��t�Mү[{��oVq�����.s��
v�Ô�N�E���(��{�NA*��>:���I+����В�F��kg܁`~�j�VR-�_�ۈ�.��˭ێ�:�L(JH䲶�����@��!I�Q��~���վDdB��/�d��~����8�M��WtrKΧ4Be5]�Ɏ�R�۹CV�$�_h/����e�D8Ԇ���k��^.źJ}#��2��1#eMj��!��~����������A��i��)�)&5r0������a}�i�s��r�˯kK��e�b�ͨ̕���C�Z�/�0d�<� ����i��ö�6�n
�|l/5�j.���D��R�;^_`6^�c'4��Ÿ�K�����k��s4����|�,���n}HBJF�(���ufl�wY=!n��l*�3d�ƽ۝�l���-�a]���E��<���ᐡ����SJ���f�8�-Se�މ4�:WHxQ�Q�
��`��Q��@����ɥ0t�At┰'(S��(�ۊ>�_:����y�	0�!I��j}0��t,j�Ǩ3�b/P�D'9��]A�tc�NB2e�	����5�y��4�2T� ��)�����3�
H���Q��F��Rg)x�=*�C77�NpV�ovV����1�@���<�0C���}�T,��"2���[k�	��R�th��.��wʠv;~D�Hi���S}�6pa���BQX&�R�g�=|n��W�	(Xgp�%��}pmCq�oPo�WI*)v���o+S+�Z�iJ��'��d�7aW<*��̒�+}���=����D� 4��R���9�>2�$�B�߶;,v�Й��l������2��h�����E��l�Υ��}Umu3�86��O�T�q���.�s��~{�����i�n{�����Ĳ���$�J�N�����L8��2��T%�G���6%�9Ee��'�T��� ����y�.���]ͶE#�����Y֯����+ t��3pF]�L_'�C�xQ�9��T��ͱD�[V�u �L��Ѡ��^�D��:]3l�G_x���$����p�z?���%�U�-y�Ȥ�b��N.lݑ�_������FV+���C�	��������������VWk%�%��kҦ���}������ڇ�Imj�;`�f1<���������A�7هU���u�j���xy�����pY�\q��4ݜ������g�zH!c����A�����g��0����׃KT��-(X����A��h��\j@���
�e�PV؃��ۇ�����LZm8���{�`�G���)��9JN�ȴ��!:�>4��oTF��`����KrEr9.��k�{*���� -�V�ID��3Kb�����"�SD��˰��qv\��H�ԍ�|7|Y�Uծ�C����~�����
]4�����C�A���xH�xl���'@��G�&�CݒM��Lk�$�ڏ���R��1�k������	#B      �   8   x�3�����4�4202�50�5�P04�2��22�377�0��2���ů&F��� .�B      {   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      }      x������ � �            x������ � �      �      x������ � �      �   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x�����lInx]�S�8$����hA��mӞ��1`��l�¼���ؙ�9]�H��8G*�b�{����ZiRje�j�O��_��o�����o���������P�(��2~����Q��e��7��#Tƣ�,�	P�'��_Zk�i�Gߠ6��	j�1F[���;t��W)k����#t�ӯ:5�7t�Rk���_�=��w�;�����ƨ?��uY?��c�%J/�?��;�m�1䧶vT�S��]�,�h�����ތ²O]�clgTy��˰V7���3�ꯢ��zL�Z�O�;k����_t��:�y,�m˱ܶ�h��	�M�֪�������𧮈�ZX#�K[�C]���s��Ǫ�U�i5b�X|���5��?�E��]�?札ϟ��X�V�G���R��x�"߷�V>?�+��f��O���b壂t��_Vm�Z���f����h�^�/����X�����P�}���O��������E�O[7�)�U�m8��k:揔+b%�
�=v!i5���zc+��/��q��֊�ioؖ��c[������]3Z�� ���h��`;`�/)��:������y:V�b���C�I�X���~���~Ȕ;����ɭ�C��Ж�+����Un�Q�P9X���䀕_����G�@���3�����k������w+�aJ4�
�J������R��Y"v��ܩ�`��>ۏ^u����_G
L����X��W��
Ǿb��}��p��"�H�а�G��9�я2Efd��������]|�@+���ͳ[Y����I��)�ӷ�Ek������6s�Z��E��U��3�,� ~7�j⛥k5}B����V-�����Ҩ#�����c��y�2����s���J�]%U΋+U:VY��ØoXM��X����������g>�5X���&U����r+Pr$�v�V��k���'�F9&�����[32_��X��O���tS,uU)m��5`�)~�`ՕG� z�
���]����P�ft{���X�e�?}��t�
�5�����wl��/�h8=�M*�0S2,�ɍA0j�g����f&��*�Z�Ϩ����1�2^wRIY9!��\�#� ?Cް�v�Xjׁc���@*�咾.���-��xf�ؑ^�QucR~�����K�wB�� П1"V��������J������+��C	��+�2h
��|��c#�oϿ?H��R�MV���\H�������"�"K��|QmA��W���w8�0�~�q�~�k�B;T9����~x���ԟقi���L\��k��%�(�J��w�EQ���7	:�y�3 �6�ϴ A��o�AO�ަ��=J�~%����bG���JO�,�=P��)8S~����P��L{���
��_}!?zѣ��|�:�5�$@���Bԁ�:���@I1"�M��}�0�U��\��@Imb���?�����n���Q���,��Y�=����,~;P��_����_�-���q�N���X����zRJ[�������Z��]G����L���)���W�Ӝ��#]����/��K�6�;���,�
��߯�U��q� ��w����'�[�����^#{�w�w�� -z�a�i��KPe~I1��V��[��������_��o����/���@ ??� ܆�7Ѐ�%���6��\�G��pS�_�����?��mI��=�Sqi����?ֶ�~}X��"F|m������o�U$���g��ZϿ��@��Z𛄵b#h��d2��$��z��J��\���ջN�Zk� ��+	���c��'>Dmo"L�a�< ����j�Ӷ x��;<�Z5�3��k�%�k�2�"�>?��5���vp���	#=Q�W:z�����
#�q���?����?�7�Yb7�I��p�vz|i��A�TqT���بձ�Q3�@G�y\B���қ]xAV[`#M�ӆ䍱k|þ( pzYOZ��:��c@��T��'�f�j�U�Rh�R�0�8��wj��*]��į�t�Z�RNn�'�(lBoT� 4~��@E�ʙItNi���x�W[ 㠦:=����0F?U�;޾��f��Z���	�v�� ��7����ւ�n����X�N�
�j��t`E#�j?�>�
,lF�������9����0&���^'�	�$�3���}�%6�7xn)|��c9����<�+�.���. �	/$�[���(�% ��K ���N����'��l:���x���j�*:��WЂ@�/����
�7��W�x=}x���|8�j��w�clE�oL� �dt��@o&�ǳ���ƓLƳ�ů0� �2�>�����C��EЪ��E���հ/�S�D	�ENo�3"
��i7qX��Ɩ �?�Ž�֢)�m�ߟ����l!��`��B1��	��{!������4}"�k!B��Z�fQ���_f\"hr<�F��b��8�|�E��X*䢈����� ���6�z�v���`Ί��آJ��"9����{���O큛������g��e���#=a ��=���&�e�����7�����C�ҩ��.b��	�~�3G�aw��.������/ 2���8���4�=�Dcr�*ҩ���Cߙ �7oU,����	U)�I}F�h��l� ��0
��a-�'o�Pa�o�פ�� >�X�⍗)�����A�W0��fe&��h�Y��_5z��x
�b9�����h���
�8�p�G�Y�T_Q^��LX9|^'ΰʅV6��a�lFw�2O�Wx�%�/�����`�>�RF:��M.|��<OoxӚm8�7��Ϻ
/OF�ݒ�R��Pܤ|�u�o7�ݶ����vF���3oT�	n<�P�c��M<ނV��_�`��84 �7x;�vow^!c��kf$ͲT[� �X�G��Q�:-�~k��_�c���,��=��i�.*;�B�a1I��o�,�W�%��m^Bu7g���̿<�쪟�8��+�q�H����6��ϾJ�����wg�R��r����ơ-�/�Xt+W�+������㱢�t�q��v���br�ee�|c�����0 2z���&��=p��X��Z�~M[=|�J�_C ���
����7' sZ3�@ �����s��MhX����F'8CpZ�f�i%0Pڰ|��T���j���@�����6�6�"J`�h?m��fRy,����?�
�t��1��kV�5�sKg�MDk[��<<��/X=���B+=�.��� &��;%qOp��<&�1��:m'c���Xg�z��G�ɨ�����p^��S���W	�iU��j}�t����P��|50�`tV_i*�2�S�e�ǻ�q�w�����mU#�$7�7f
�5�2�������cR&�.�v��y��s��@�N,5?ވ���$��䀽4�ڀ�,;�<���ǚ�d�V�x���<��ߋ2	���>|�I������)���j��VN�7�˜ڜp���e��޹��0X@���[�u;��Q�⒦�ܕ?�������Z��ƚ�fopm��������õ=:��� ���ȗn\Um[��yp�K��?�#���?�Cm��ff���f��R��v�慱���-0�)l=���o���2Y&���J��9���Yx	�[̟8m��Q�	�xx�;�M M�қ��I����w��ț��_	�Ō���h��� �؝8w�h��<� �A��A@�Fͣ![��	��O�;"ؾ�e�Wx�!^["�I�;� �\�-�p�[<e��|��٦f���-��ˡ2����;���'v�5Fe��t ��_o��q?}o��G�ǻ� �����q��(f��p	p�.;�a�7���O�k���Rp�y���[�z���ujO��@���9�{��    ~�����a�Y������c��.��\XJ<��yI�<�	k�|�yw��%Q�˷`t0:ے�s�z n�E��/2Vǂy;X�w3�;�eF����x%��gQq��KN�'�^�(6�� �ptl��qt,��w�������h�����o��G��ȕ��QT����I��yՠ<�`��)|�/~�`%�\UF5`3��g�ތx�T�^=!,W<�~����4�i�����/���o�[T^i�Jk��5梟���U6;#2��i�-��w��_��2���3�r�Q=������i��į&3O��r�<�x^��;�*s�C�X%��o�! 0������ƍ'��g�xGx�\2����r7����՝`=<���N|�?������@<������o�����<�I�?�T��l	���ޞ^�0�xv��clU�#pj��@�0V�b�F�{��y��k����b���#po
\�\mL-3��t��`����/������n�-�C�|�v:o�'�2P��������O��<7Fs�s�4�����ɪ�c<��l�ο� �1Q:J+���$��!�� �
��k�lL|v�fX�;�A�JϪ_������h(MT�LT�LTޮ���LJo��#Q�i����PI5;l��P�æ��xw�\)����RǦ�`X�� �}���a����D���x��4��8E�m�p�<e���Y�{�Xz����e%��_5
�\�-�{��:)+�o�e	�5����X�_aɛ�g��Y���<<�؆���pI���[��-e�@�X���[r(>�� ��y@�<���2�L��wm�J�p/�e�`#|�\w�\<m�W�q�,��
�Zy�BXp��l��Mɷ.��$��8k@��b�(�?��`9������%���|�M�!��`LI �k���CtM�v#TfV�A��	8��O8���(��Х���p��\.ڎR"�J�Xo7:.��[v<��A���rn���<0�1�(��ƻ�ʌ��#5됆�7�k���"5�OZM�Kgh�>`�������!��[0}�@���U�ï����F�����<j��Ӌ_RC�Bq���j��A���7��)0};W/�N���0��W4�Ek��;� %��}o���'���xg��p���7�,���V�n�5Um?�z}��t�į����J�hu:��~l���m8��Cr�SD���a�����q����uƃ9-!Q�(����^�)���4������e|:��o�b��}�v��"
�rn�;��ٟ%=��ݛt�-N 7|0�31���@O_�N*�;��Y�o-��n��:�������\2��_V3{�a�v���L+�	�6|���W����^�tX:�/`!vj�g��|xP.Q�����M	����pR� o[��5�0���n��r�������Ģ m��ܯF��K[a����e�LɳH]1���-2"��V[��/��tP��>�Q�,�կ<*茱J�ӯ���y�j����^_%�<�Xv���+A������4�.tv\��*�;�0"%wP?nyDf�'�[�+w�4:3��L��IX޹�y�ДwH��ۖ^N:�9�Jo�W�r�4��ط'8]m}��b�����rxs�>��A���h �$͸u8\ml�!�e���g;��~:I�����+�����f�1y�#(��Ӗ�r`�wrQ�Z �`t�NoP���Y��u�x{�Ⱡ�X���/m��n☛����,�Τ���WJ4V��~�@;x
z�t�)�����|=
Xz�����0R��յ�&��[�`�3��r�_I08��1e\�@?(����w���@/>���̝s��0M���ץ��8G�g 	���=p�Cg��{�ca�Ȥ�a��g��| �Ty�6]�c3��y�56�÷�}��t�˻}��^��/��f]'�5��>l4#u{`�hl$��L�?ju۷=0o�������`~#:����Q�N�"b�)L%��Q���d�?E@m.�(c�G`��v*��W��Nf8SѢ���Dxv	EH1O�w.�c3�l�C�D�C��f���ka�"�}
�-�l)	���y
߈���<��O�`����]k���x1R�@�����,��T:���s��$3��H�پ����ս���}�b9��8�X�= �F�X,�EL�uʀ�܁����gf�����r?:��WO�~����k��-⫵��Ekl�&w�"�e��t)`�L^�܁��,�������a�yy�B�vzB���@�/��qF�!Ps�����ҩ��*_7�XH�3����l����@+̰a+�"tx�#*�;�~�W���W�t�j�+���暆޽�x9]��v����ɍB�?�4U�������2�v\m��[<���o��p��蒶���i���`�,��` i�_�M��F|
����`csY3
�C�-��μ:Hwd��4�?ܪl8ﳘ  �G��%-׭
�{z���%��-N�����@y)5�g��w�[�rici�7��/���Բ}a�>�-�������Ee�����2�'D�w'��%�:��Z�7��٧��dp-滈�����r�wҲ�D�k�,�Vf���L����pe^�q �Ɇ�g���䓩,�Ɍ���p�Y��u���U#+y���{����@5C �aT|�9i��D�q���3��A@d���l�l@�l�"z�
8���%��&V/^��8��ʆ�Gի���З�;R��'�~� '��S'M�w���/w��m���"�'��`�V�� 7��x��l���J�� /��@��ީ'4�\�;N2��I���x�S#y�w�d�^$_P[��X@�w����O�.]��a�oY
O6���<m#
X��:[��d�)�S�8Ȥ�~�
>:�9�l��m�	h']p��*��Ɔw*�����B����'	<6 �y�	�8�V)u@H�!��f����c��%�:�Yؼm�¡o~�H`����O�s���$p������y��]H! p��<io��a��Y%0�������:v�ŧ`H``/=�aW�7�����?��c�Z�&�.my�^o춢Z⯟ ��� 0x���4���L��J��˧�}]XF~�|ݓ��B�Ri�[�~��L38�aTq��M?�cJne��z���.�s�P ��s4FZu;��F�y.z�QX,�+��u)�-�;���"�e�%K��Q��Dx�\j�;��RE�z/6xL�E���PD�S/�q��/쌭���
E|���Z��qѢ��履���>��`	`���x��`��ΐ�1���y �V�:��*6I�Ll�x��Oy
Y��q�׃)�Ǹ�w��A/0㧌\q��8Iu~�I9Ζ�Ź��f��O5��fx!7۸�C�%�ס��ہ��p��]F�8��`�䵭���?����?��'ֳ��ԋm�/���d���Vg^}�`3��z����=2���9r��~V����[��~p^�:V\MQY���	߱K����)�mM�������v�G{��F�z�O\��-B/�Q�XG���ֻ��)��-s�b�7ڿ|
��NJ�Q�P��)�x/��Ѣ�u�lt#l7_���k��p�W`)���3@�@���c�8^�tY�F.�kK�y50r�5���c(��y���ݞ_�����K~��!|wL+�lw���v�g0l7����pz�9��	�����,Q@��z�W�=Ǣp�(tGMX&[[��5=�h��30p�9���WQ(g)���p	�����T���
C���쎕p��Йv^I��ٱ����H�8�h~
�`v����>��J�_��j~W �ϛ�.�|�$�'��?�3�h*��\��W�W7��;�����<��@��lwJ(@���y]b���������y��A����$ďC��Ə�8t$
���+o~g    ,.�
[�C����0`ǰ rr�^`!�`����~Ȫ']=
�C�缮 �b#)�f�<��/��5���,l��Uf>;y��<  а1��$���_aх�R� =4����!��*YX� �_0�d=�ڛ��Nr��L�A@`�����a+7ohg��Kl
�(����������W�(`�� >�H^��x�!ި��	�P�$hx���Z9K��1�;��&Dʇ�����;x����~���ͻ���������ciJ���)�̣)��#��3�	����������������m5pO5/�����K@}~��~�	��a8���-
����1���8;
"��}���잤ˢkЅ�4kd ��N�ȢA+(�( dK��AҞ���n�D���j�o��Uq�&���Z` s��O�u{��7�x�8�i��T��D(��"k����@�9C�Ż��0��^|��	NJ�{	0���i|�@�Ή�'�#0)'�0�p�0>}ER��s�rx����j�W3v<���t���<?# pӐ@Ӏ�O��������i��õ��[�I �)ȩ�-��x�=m��Z������:V�˙�+&aC���G�o��^#dy��������-`���I���}}ףw4d�KQ�C{ý��[5�@�w�.&\��.� ����X��~|��ȃ�9���>�Jn�6|����~GC�R�!�u�"1�\;���Y������~��suq������&S�+�p҉���9U�������2��������ęZ�e�A:s�����|(�\���EG�҆U�����L}� ){"���Q ��� [�Oje{K*�;��jم�z����x� ��0'��B�`���J�N�?�
��Ɏ'�O�B�}��	�_��H�$R���gw�P�x��6;���`
��?���]�=�f �����	O�0��Iiwd��u�ý�2������ �UI�����=w�Ŭ�Q�����aý��C}�����9PQ�׺؁6��_�Bx!�WXq�ơ�ͺ���{�
���L��}t��=���T�p��?�����=�Ol�4�5��S5'�C@��C�Ⱥ�V�	�fgY�M�F��P�������@T��u̺��0��=��94���3��L�@}D0m��<�>7Q,d�E�#w]#\�I��+��!(�Lw+`l�7��sO�A���#����W������`���Ӵ��%�/%���Z�e��x�V����1l��G�"��+���'�"|-<k�S:v��S`][�?|���G쇓�t�iqe�s��c���s�
U����up�(�Øol{������PJ�p���?���OoT_����Y���� �1S?f}`ۧl�]}���l^�4�
n��V�tc�g`b�z���
rD/#�e��F��:�+�$�R���8�,�?\'��gNУ�!�5N"�D�ֹ���=:���ۃ�x��88t�q��W�T�h�9���k�=�蝾�'��m��ޱ��?�c����%a�X
��E�v���5Ƒ~�H$�� �֩;^�V��"IXh>"�o��#\o8��&n>����x��
�P�s�e��;����ϡR�
���Ρϊ�Oo9`�����V�Yc�V�
���-�WP�pj�����G����c˶��[������诐_Zֱ��{xvAE���ך׺nꙙC��@@���s��ʳ�έ6��E���p�7蛀���� y���T���㐟�g�ŏ��۸=�>vc�����Z��D! 2��ER�a�8�ԓ] ��Li�=�Z���ֻ�� ��l��&��|��g֖O�A �� ��+n�V���t(��J+װ�<q�Ё�XҚ�E6��8���Y'�R'��![�zw��V|�jQ����K�ߧt(���Q ��O�{�'Ǳ���='-@o�;��4~F|ג�(]�=���I�@A�?�oA�
��`94l���c�>�B|�V�q��)�Z�mZ�����[ _���=܃z�Y��[ Nck'�sҌ7}��>�vM� ��K��#	C�s�n�y��G�`o�����p��#�;�]�т<"x|Ά��>�pt؉ ]�<�c6����Ac��odp��K��<dY&��.�[?&�X}t��b��������i�����w����0-2��I�����9�����k��^���]�*��ᱯ����/~1��c0��A��j?�eD,�~�z���;�:Ыa��O�����W�~����L�Z��Ƣ=�
o LW��/W�-�=r��,��Wp�`]m�ֈ`ۡ��K��+�K�;�'ٳڨs����z7����:s���`�q
�*�E� ,�f��v�[ o�ӵ_||��0���+������^ kL^��WX�`�&<=�ε4Z����p�k�K���xwp�j�����˝a����D���%��p��ӫ�� @J�e�H�=�t�X�x؉-V�1�����,��zH1��|�!��ءu�`^8MˏրY0K�ԫۜ�cX�֠�w�p	`W��[�n�M�e͝�\�$6��7��h���_\�#��B�t�N��O���7(�X�>��#�?@�~��׈�����Y�9,.�A,�����#L{�2����w�z	�e"�B5�Kf�X6ÓOݫ�Y�@��,�y�,�H�4<�T�$k�\�=�P��L�V�	���[i�>#|���sh=p�1ˢ�@B���&��}�M��=৏�`���-�����}�#8Oo<���:�я�&��>H��8X1�G����B���g�GNc�}���(�s�8Fv�Q@�ߴ�X�Շ�5������G�{�|6�}������I��@��~�$y/8���3�����}��SM�
`��϶���R�Y�ˍ�y��'�g/��զ�3h�g�tk��3n�����u܀�?�u���#-�y�ĝX|�(>s�l�ݧpՖ~,���Lڵ��ߧ0|�t���\�&���#x�gwf�yc��~F�6�D�e&��*��n�6��1�Q~��6Q�W�Vz�'���ϕ��y���[�����L˛��6�c9�>�+2�`���������U n,��p�x��Q� �# ;�T5�����9I4�8���=O�S�X���� V���v0˶`.O��w\γLw��`hۼ_t���ӆk���6��~'3T��3��T3�w����o�U����v���=�/�� �a��`�1/�M���S�l�CY�E5�H���h�v�����<�(�[\�5C{�a67X�����=����>4o�Y:�W+�'�؁bl���q,����ao ��5��ݮBV�sD�<#8��O�?�pj�(+�{Nm�j���Z�����l����p ����������n����\,l�7�`��� ���ϧ����a3��k��C.��i�݂ծ�>���)��c-�C� �6K�5�$u����fJ�� ���T�l0����7jd��������"W�E�iM������f
��`L,;`�Q��ؑ������p
p�F��f9���+?s�c��l��R���n�>�׾���2�pǦlc}瘌��#[�Wf��
_��/@��'ċ[��P� ��a@��A��T#�ŀO�\;�c&�`��\�W�9»Y�3%8�����-e����T�%���jĮtO1�9 ����ܽ�ɦ{ ���΄�Lch���v	c7�}�[{vӆ��Â��M�����_d�0����7�}�z�'�s�ϐ��g0,}[�?C�;��Լ��J-l���� nԜ��e��x����܄��_�-9x�P�_G��-+�ӟ6ؼ]&O�c��!Z��f��������/� Κ�l�n�5"��wĀ���u����9��w����}n�s��7�>vxܑ��v    ����Ǿ�|X0��.h�Bw��1ܜ�;���yp����NO�+V�Y*k𰹃R8���Ɛߋ^m����-m�h%Lr+>�VԘ����$��q��Q=Ǆ����h�(�����^���L�\x��>8���;X�B�l�; ,^�F�^��u�X*�x�D�R6�+=���S�d���O�4��C� ?�fUn�{%��U��ȶ��5?���F����a���T�&����;�b��U�n���{ࡼ�#����űi��Ue�l����d[�d�����x�??����H����y����y�$�#׸/�dl���%��J@���q��%lu1F��$��<�����m�ho� ��-�;��מ����}�9���S�/~���/Y
���|����)��ݪ�@hr�!,�:3/�#��"e֤�ņ�b�Q��;��d���G�ke/4Xo�;P�,h(�;,@"'�<�Fs�.��0��v����zX6nx������`�ձ�Wf3�)o���HQ��	�V�(`� ��H?-����2�X`r`����dkL��(�����/��V��ܾ1G0�� ��8��?��y2������'ΰ(�l���"��V�5����X%��!E��#�s��d�@@e�����[��_`��o����0�8�u,y �sd �r�uZ9T[S��w�o�5�(��/y0��lW�ї�5V࠱_Mz�]C�`�Nh1h�8�H�k��i�-?Z!k��[nBm8묇璍���Y��j�<��,�~C4�Q��[�0xt�h�zD{���9���%�Hܧ�-�S��81�����wD�3��v��ٷ�����6-�-�ϔ�9>��W���#߄�~�-�N8��ӛ���\��n��v�������q�Q�H�l��C'� �Y����̄K�y���av�ț�l�ӫ7�����b���˯�wֻ�ʂ$���%N��
�W���y����&�^�ײ�����w�A��vH>���0��}���C�u�qI��3�Bln5�=��k`ƧZ�K��髶w�r��>KԥÕ�9��|�^�f`�(�5s��̻��_^`���^��e�Afxsb�C��/��'�O;)f�G����HO;P� RM�¼#�)i5�^C~���c~����� [ ǺO��¢�y�!����)��3klޡ���ZW�uH��x����`vZ�em5��\Wo8�i>�5���_����_䣽uxxψ�,���~�����m4��
�S��-i2���ѧ�M��+�y�Tg� NZ��f��@<���N[��!ϵ�'�?�gml��y商�m�2>%���Y����{B*k(��t�*���� >�G�D����,���Y�s��q��p�>��2�U����9�����:�.����L/J�2o�����ǜx���&�`.8o���$�04�n0x�x�À�+��Y(�Z���8�`����.�$��ፅ�	���R[�Ax�@��nb��3�F�;la���=�>���r�j��c��L�J,�z��3�O���ȅ�U������
�l����u��Ooξ�
~8�U���:%&�\j�;~������K �T�Ńj�}�O�ς��`$���b��av&=�/�b�ur�$���рWƐa���,Ўm
V�g��[���[`�d�K�y�����ƻ�}��m8 ��F+!�����{���*�3�{=�Zo�mp�#�oE��&~^pF4�N�^"u�}ӓr���ɂ*,^��T�f�W�h������6b�����߁s5�ֳg��d��k��0�qd]>.�7	�깍z�6��u��*װ�����<��S˞)���ޥ��. /�y	��^�@@� \�<�`W���Uo�={d!{I$6��ͿTH��t8��s_c�����wx��K}�o��?�o/���|#0�%
�_gi	�F�;ُ+��\�� ����9"ٙ��)��R�ULGabAZ~r���@�5i�@?��6�_K�j��򄏸z��[ �2@�� �5�����&Ǐ/,u�cŗ�C��]y[�;M&�3����/`~ 4|���5.`;��r���Լf~�@@��L.��Lf_��@A��8i��4�5v�>
*Sr%��xV���5�X>��w�D�Y���qs*��,4�p�nff�T^T���^Zꯙ�l�`�o�f``��jj���߷�Ɓ���v�Bm�~����sb=w`����@�R�=�T��u���i� ��g�
��`���=�	�Wf@�.y`�	`���u�
�Á�d�����Dp`,�Y�`u�Ϯ�2�wT���ռg�y���}�3'p�q���l>��u���=�����-�i)�M_��4�i�#lW��%��+9�G�}�uG6:�Y-3A�u��#ap-�k�u �������=!��	8D��86|0�b�����μ_��"5X�4
�óȠ��� S���"�'�)�܈uG:(��ڟM���*�Z� 79�*-�����Ź�� �������@<x�+
�������6�߰�0Gw2�#�eC2�H}ú� �4�K�'�42�7Y'�IS½J\��%�x;ݶ� � ᨾ0Ps������=º� �f[�x� N�R@�Hf�;���WP��f�g�מ��f��Aء������ζ^R���nYx�_m�K��6�?��5�Z?-^�[��k���?��Oq� ��BV��kC@����( 
�sc�b��g��@k]�K0��β|*6_-�FLZ�ۯy,l�M+�@��+��;�
MY�S`A�;��Y��r��8o�	�%�_̃=I��.ݸrJ��Jq�y�:3R���/4}0��
pp/�@�ӛ�a���v�8kŒ�{\=n�zq��;�����3���_н0�����Y�e\AN*>�gc��ю�M�q�~�v�_� �A��}xji��V�v n��'���5��X:ӕ��>2���Q�����#���T�������0� {�Z-_"�����@Ċ"���׸�~j������=R�;�>ČlkMXo��y�Ÿ���[$+��߇I�g�+��.?b��	$
�#|%�vw��}@ ���+�����%溃��AE��3�i�T�)���~�����cù�����#�:m�����;��x=1h�q��Y�<w dT�������a���l����4����»�~ � n� ��O��ۓ�9�@?o���=�������$��,#�v�;��y
��_�4�K 7�cN���ś�����4�<<-�O�L��9�v��]�,��觼�=�	Ʃ���Y������xݖ�T�ϊ�q��J��^#�U|����M���� �A�߄��&�Р�) ���l4	-
��w��$�+ٰ�]� ���
�w|�xH�,������ ;ރA@ࡕ��2��rVwaY���M�}'��<�)`D5�#r	�^H��E
�"�'��!�Sp�<D��|���ɼ/8��*�;{�A�J�5�.o�A�x�@8kX����c�Yz=غC ��43��u��J�@���!Ni/�a�ʴ���9����ᵍ� �p�����[���p���� ��:�y�7��(��� �R�u^�U�9;��>ë+�ڄr�2�Ke��������r[@�}�p���g����o>�����`C@}P�y!sY����z���>G�[�t�F[w����m>��<����|�qܙ���ޮ�=�,��F=��(��0x����	88�O_	���ӌ�c=���YVÆ%������+�_�@t�~>�����<NMgP=~�����}�_x��9Ⱥx�uG?���
^&|8���w�F�k� ��e;�I��������H<��֊�a|�C{��0�� �K8��=���vx89� ���P=�B�9u�g�E%t    G?feO�����l^3��\���~~�ݠO�!`����3���3�!����$�	��r��ӫ��\�%��)�0�(�E	*-�Ջ�\��ē~o����<��g�Fj^%h�`��}J�2��V�`Q�(y�����t���g�K����y	]}�j�/��G6�M0��Ql���-W=�_g���I��t:��O���v?ԥQ��	�g;É|�8)�[9��x�m�N)�;�V�J2_z�����B��@JkV�+i�nͰ��'�
��ʰ�I7�EI�o_�@I�D��x�k"M�n�B|T��������jB��'JXf��`W&<㐓��6����cZ��Ͽ"z�K��1Cp�`�,l~��8%�>�����V4�s,[g����K�pі���W���F�Dp�1w��e��m�ih��<#�%��[��
��Y���������{�ou�����:���_����FzC����G����N|p�/�ڧ=�=7CO�R�r�J�ߑ�����/t�)/��}B��z�mOA�ʆeD�=EZ�ޞB�1�6���aU/4��\�����SK�:7��UI�����	bE��5�W�<g�����	��m>�4WR˻�w8�Lx���q��Z�ʷ]��̾��J�h՚�뚼�䅉����6g���Hq�z/�²j_�u���?��3�8{�2��/�� ��i�~}��x�~{8S�s.u�� x����a�m��Zڝ��{w�N��� � �&���x*|@8�n����}�Ӊ���pV�����7�
�/<' ?��/�=�~���<K 8f��
�K�V)y�=��C�0#�JH��h�����Z���غ�Y���V�`gƻ�qnf�c�$��$��/�
�I,ҞZ+u���������{,�o�0	o`-��xk{5�-�5�>�ᤶ���@�O�E�̊�.�ǁ9a��=�9��g��yΌ+�!^C>0�]��+Ѝ��*�% ��g�ג��.|�*�������[���F�[���I��,A����jmH�oZZ.�����
#?b$��Ӝ��;�(q��!��Y�2�7޼��"�׈�5I���{�t�.x�Õ5�"�1l��ֶ�=�G9l��Sйz�;�G�`�yx���#m��"��-�[��ds��I�U�Wf'�^�29B7�/���oU��*Ϥ�=��m���7F�2j�_�6�X�M	�.a�ӷ_28�o��|蛌�V/�$�oL��Kio$��}I`.��H�ѣ���
��FUK�.��1�%�7b�&T�k�1� =Z�n���������5H	����0�89kzuI�"|��{��0�������3����Y�W�=p�L�iʛ Ko�^���6�[��HfW~!�{I��E�7�7������Ik>Z]Y��gC�K��<����S���{x^$	����!Sk�Po�˄�&Eh]&�da<^L�x���Ȉ￼G���h�|^�]B:� ;��t*��&��Z��6"��;��%��Ft/	LUh��A��Hz��9��bٻ�t�-|ֹٰz� {�	{J��o1�$�7��9�g�3F��$u��vc�yL�+�|�������[�r���[b�݋S��q-5ʀ���o� B��xQ�궤�Ǟ��68���[}ENoUS��^�'��Mڤ�%03ɾ��^~2൘?��'h�rŰ�T�'�4_�$�!yfKO��k�AU_q� w�[�z��]�2X��2�^� ���Fl}�M\�������3'����Z_qJ�a����K�N�YS_q��v��P�(���%�(a�4�,�ٝL�c[Ly�о��枳A7%y��%6l����9�J.|�4)���w�Pl�.!P���U�[?�����T8s'H��F�k �������iҶX���o��Uu����k/	lD��:���&!O�}I`))���F�����+�61��ZxN,8��w��B��6y�R;}�k��>hEӯ�퍌'C�>�\8=&[��U�N���H�j��a2C%��U��䤫��J�X:�s2��7|>�%�Y�P*n��(��ʿc���^�������6/�'hW�ބ���.�eP�P�1��G򂞫 ���Xj��hK�A��q�'��6�����gu�^$$p��8��t;�c@�H&�^��ڝ�)}
`�����""�5��U�xO>ޓr���6��$�l3�X�|���&�����xM��W!P���ZU���L���e�vT+�3n,̖�D	��I㗍7wJۘ~�U5��36���ԫ�C�Z��Q�e�Iԧ>��9�e�[����ɤ�ԫ�5ۋ󺈿��Z�"���vщ���Cs�n	^�z�m׬�Wp�$�l�8�|4���M�"�a�"H���x]&#��i�h�t���?d��>c/�����ѻ�;a��2?���Ǘ�����O�,��?⟱��m>��'����p<#/�����O��[�f ��������O�lP��-O���ГI�-ay���?���%�y���O|����6V��M:�<�;��U��{�'��/|��=V�A6���8�X�ě�n�'ׇv3��%�S\ް5���[A���`>�P�2�7	�Y�9���!�b��5�>��Ͽ��;[vqz�,��}I�&&�:�p@�	��:K�u\8�A���w��30�׌s	ϔnQ��Z�$P1?8g��$��O.U�LvAjߏ0�d�2A ��}IW{�#�s_H�\��Y
N	����	�k"@=W*#����p����u������HyI��Ĕ�⎀��G<e8+=�ۏ�!QF����/|�/o����,��ySGu�0#�%�1���9L,�#�A�Q7yX.(�,��G $��Ͻe�x��⇱��a�H9�J�n2֦���f����HG/����/ݯdf�#�T�>%��1OD��F�ų^<�t���E	S���:K﫻-��(�L�N�J�2z���m�� ��h98�.��$d���扰4�4��gO2�F�gQ���^�{X�����d����4j��b�tXo��oA#�f�Gu�7	��J�,�	Õ��j�����/	��,e���@I5ͦb=%�w(ۗ�\%����s��ŀ�n���I[���<A�q���~��'Y8�1oa�w�(�*cu���H�[>���� ��0�x�ʃYn���G5� ��J<wIʶ9�z����8w��Jy��q�xNF�3ώ�ox��~ ����?@+��ͯ��'�*SZ	���'n<e���bP]�e��n4^2������\+������s��؍������f_>������%"ed��A���+�[D.·�oVs�a-���A"YɱsX�Q��G8���j������7V��1�d����sC��;jv��j5��s@z����%7[�;>�rя�`�ݥ6�pn
���Y>f��l��Y�˷d�d$��d��0;K�5xT���d�Ǆ��gRj�Yɭ��דb�]��D�o8#~=7eF�����`'�̓�Ł�cZf����1�㇮p���o~U�01ir�V#^��̨^�r���o�h�1o�g���[���ٜ���{h-\�-�p�h��~��� =<���E�~��|�*�����G|��j�zg-����?"~Տi�/����?���������;c�{�E�1y*�~9�y����3��������sCl`̦I�ߢ��?��&@��������q�w�+A���d��p����.��o�a/%C��UZa4���-��p�G���chrӏ��s�S�����:�v����E��!V�*��b�-4+s������𞙎-dL.i����m���:F픠� ��f$r<�w�oI)��5<�̚�-|J`����b\}�pg/ej����-�ȶ�T�H�'۪]>�;]@�F���8lפ&;�� ��^�d[���(��� �����	o�JP��ö;��t�vp���� ��´t3h%�j �  |
h�k$�`��;�B	�,���e��(��;�B	�p��%�t�N�;�Ҙ��uj{
��^�����D�����R�p�[�n$����� ���&`fL��-�]�L��約�蜆�`�n�)�<���y��P��-�?�E%oP�+t^Q��n�@����x����5��� p�Z��=�-;���(l?���_� ~���Q�{�=����e��
�r0�/��-���%�(A����æe��z "�4������Z�n��@C�>8n�v%0|��iDtO�h������Y큈��/>8�2�ɉ���Q]�F�r�������Ө���&�#p�����Y2鑲�������w�����b���}�M�����Nδ>��k��ß.6����z�;^sX�:@/f��x�1�3a�����
�Ϧs�e�ԣ��y�/`�	���'~Wms�o�;���Eb���8�2�!��wl�+P�w�Z��$`m���͢48#W�2���ɮ펬���:��m)W�.�����;�ª�{#W�\�mS�R�v�U�o�l��S�w�u���((>�);��=00�x�Y��O��ʗ �P�aX��A����0�g�,����u|���3��c����43ppi:��)@�G	�}��yGT��ğs}�x�\_xh�o.g$!����<�s�7�V��&��$t/��]���x�x�Ӈd����c����)� ;!Qfo�7�L\���Ծx��-3���X���MV����8�iڶ���7Ⱦ#mc�} �������7O�<���#��w0�������'C��;D.*�X䞚�P&e=l�_rF>[Vu��`��΋���V�<ˡ�����N��@<����ƣ9�Տ�Ŗ�J���+Q5����,,�%>�����ݓ�Q�E� �M�����_a��ʗ���q�t�j�J�}%)��T�'�P�P��X�{�z\�&�%������j�{�H	|��{��n4q�;�%O\��dF&�qBeñ���PӾ��(5pQx�wZE����W�ָ
,�9�J�3[�x�O6��Hv��X\�ĳ����q�Kj�����\�	�᥏2��z�"�*�/����>!�C
��E�:d��5�0�8&�$���]�-A�5��1���EF:+���~��#�R�@���*#��mև�ƺ����=
[r/���&�g�[��M������
z��e��ΐ֢�4��%az�`{,͒h������W�sN���4~�zH�s	��?_�wP��-)�xI��9�qbi��I'�����n�����g����X�5ju��3JX����1���Nj���U�q��\Q�;Z�Y	|�	}����޽y��8�-�����rAf/3MQ$0r��ZV���_��|i�O9L�L.�t��3D#'|����7�����#�0��sGz��>�Ƨu�c��g&Q��
hq>��=u�XXK��!�O	���/U)a�7���+>%pO�;���%��]&m��r�厲8^�=���L��j��1�g	�m�`�/厳�7��¥�l�M�quFz䎳x��4ܮW�F؋�_��3�����^`�-�]9����|G�{a�pHy���q�v����4!�)�f��&}lh�ī���*΄�@G;}GJ��3ĩxZr>��z�;2	����rZ�z[�T��5L����dSgV�	6��|�{�@���w�Z�Zn_K|^��S����d����v	�^w:���;��A�=kh��[	�>�7�|�`�\/��0�h�m�5�q	4�m��@��;j��,p��sk��3�;�:�G\����?�ƫ������:�Vď��pK�il���^Dz�"][��w����k��ￕ��/�[Y� =�����S������ו����9�<�� �y� =���y%��*S��ؚ��p��L6{ʫ�p '����t6GH����CN&ۗ��-LIc�+;e���@'��.aD	����s���e�����1Q	�I��e`v&�p�
����O�>��;��9����걝r��T��-�<'0��|�����W�����Z9�~qƌG䎹t��lI����m�c1��;Ꮊ�y��)I����B��F`��2��y��h>���~V��~�6�˯O(�b�<E�?��c,6����C�ҍ�/���r�]��K�� ^F��s3��P��uĞV�����G�z�>� ?��}�h�s\�ܡv0�i�_5��|��d�L��'����o��f���O���>7���Z�����K��JX�Ġ~%#p��v�f�c�/�e�6%��\��0�Zk��۟�~��'���3H��d�*3�S�'+�tdzW^��W;L-��|��(m���?�n�uN��'`t����<Q�%2��2�s�~�:V3V��
dl-r~�f/��oV #��C��?���J��Ȳw�=���E�{z.R�fY����k��<X#��"�.@}yU�5_��E�,��+�5���͟ 0Qi󞷣wm��g���Z�w*��PH�eÚJ	��z���WZ;��^͟�E�n��s�'V��E��Qs�K>�cuN3���p��,nѯ9�Y������|	��9s6cWj-���S��s&�7P�k-�����_�+��ˋ]F�%����07A3ݯiǠ�K�>ߌ�jt��.\� ���.�.�F	S?6*y�'��Dz�@k�#�,�=q��k�I���K�7	ـ� ��)�%���j��,C�lvVo��CZ�_�@��!K�ᬞŖb�	�p�_:��jV��E|K��(�7'�� ���<��o�*��/.�R}|̷�>���;�2XԲ�˸��bK`��f�;��1�φj������cA��z`p�a�d���ͼ��������� '��ʖ����?Ꮏﶒ��>-z�[a�w�~� �|G���?�UO66�����5A?܁��W�G|�̾��[@�L�C/�&%LWc=��ʞr�Iw���g��7�4�ʚ)��7�Q*M�p��ƤM��.����<�Y��N{Y��`���9��؊_�� wą���iA �e���wą�v�/	>��3����i?� �l>�U����5�-71��}A���kW	,d���\ �>��A����t��u6�0��Sc�-�I��p�)��4w~|zw�|���s�����]"�!��F�e_��w���ׂ޾J5Б�-��мy�'�z���D	r^Ew ����FP�4=�6^�l�b�q�ԏ�3^x�AA��P\l,;���C9��ǂ.6�+=K`&�w�[��%��+�i����o��_QI�J���:Z$#��l�+��-�2,�Q���>+g�F	�([ޫ6
��tŸ��y�����>��Ǖ����]��I8$8<%4Xݥys>��H6��ƳI"Rw7�,��sW|� vdp�d#~�~��kv�����ƒB2vs\F����X�J�!9�)����2�|Wpk/o�k[��O���鈿�Jg�W����Y{�x���$x#�Z�=�=���ҾXER�w[�lL�:�(�ACņ�{�i"��a�2��.��*�G�q/�5�eej��%���%xh�U�y0����q��`���ʵ�(`fCU_pD,:�9O:;��s��?��i��`���J6i{K�K���],��<~~~�?�Μ      �   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      �      x������ � �      �   D   x�3�t,(����OI�)��	-N-�4�2�"jl�e�M����VCLL��6�.l�eh�E�Ԍ+F��� ix;      �   �  x����m�0�+Sd|K�����qI9�ub�5*�J�3uI����,�V�J�@�|@��Ŵ�\��^+�� .�O�.��V'����MX[�U�#O*^����y����T��^i��E� 6��=�`'^ѝoҠ`�����FU�vM#�N7i�KИn{�y�h��<w�z��V����<JvU�~cnb�
FXEGr�29��^;a#�9�zx�ڪ����g4q���~ifL�4ӺI�iK�A"��Ad���s"w�|m�q�D��5�Yxqy�4J���f`	'@B��:�Z���-�$v�M���[�鞷ŉ���<�'J�8U\k��<��i�VH>y�21̞�F��,�*���27̈2p�I�'�v���:�\>F�V������F��{ZF���	�M�]� ��h��/��8��^A��rH�b%������Q���#*�KZQ��`�AC�S� k�];m��OT��d͕T��1�	�k�lfY�S`�yWX��Dn�/�4���� :T9��>1������[�j3?��؇!��@W92d��V�{F���e�9��A��0��iO�cd��OF÷��_!F����;�^��)]�B������FF�&�A�ΧBȡ�E�uS�1�}$��(@���8J�ҭ1���o0*��3�%������W^��[&�V�fw�Q���^��?ڀ/n      �   �  x����N�@��������t@���R.*q(B4�H	\��;ې��8i�XV֙��۝�̒ӂ��"��+D��UXQ,�������8$p�s�<H`W���=�޲=����_qm��턜���[��*��Ca��:C���bm+�`bN��\;<{\�i��7\U� �O�RB�ąбX=�q���B��J:n,��ö>�QbW���R ��e���z}*�g�f�r�s��k4�A��	B�À�."4��E�gJ��RЈ̋������yy��d�}�u/�N�}��xB��h�`��!�����R;`°uz:��<N�;@Km��\Yvvh=�'����PG��p���2s�g-tɸMI�#�X��!Z*w�N��µ���ǐ�|C^|��q���-EZ�fn,��2w�9�����#������H�Ѻ�`�Ȯ���/�w&�s%�:X�`W�����ʄ$n��E݊�t���m�$�᫭Ȫ�9���r����C���6T��Y1J��5��Ĥ�&�EL�i5;��s�Up�p�H��)�ha�D\�S�V���|Q^/~.�ʗ����^>�><�V����a>B=��� )57Ԅ֨Rۑ ׹Z����v;6�W9���{y��6��ɌCJ���Hv������N�ʇ���b>t��'��om�H      �      x������ � �      �   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      �      x���ۑ��C�g���|?�Y��ۡw;�R4*���*��H�Ѭ*d�g^��iY������{��?��������~�����5o?��3��m���k���]����_�G�Y�/r�\�3DK�j�����z����L�._����!Z�����jݦe�*��T�Z�k�C�
��v��t���u�t���}[�)D��n�\t	�*�n��f�]��-��S}o�j�-���2��m��V-_�]~O������i��O�]_�*�U_��{@mS�V���zjxwy[B�T�S��1�-D�`:j7������{ۙ���Ϩ�}Zlw�.�;u��}�R���*�cה���Qx6[߼}Ѫ�����]홲Ur;���w���G;��O��C�T�Q�_���ц�u��`�-#�\��0�##�ZZ�4�+#�Z��v�C�Rv�>�I�b��Kʖn{i�m�-eK��TK��m��vT��.۞���e�U�Z�l���k���W�\ϓu�/����վ�E��m_ժ{zh۪V��C�UXt���jWբ�ީvU���l��V]mOբ���T�������R��ΗǶ���t���Qw;�V]�x��j���x��j�4��S��f���Z>M��S��:O����Z��K�ܘ�nӓ�6�;�����e`���Yz��4=37�=u�n������T^���\���<,)/U�D��F��	'�4�,k�%��4����ž��^���2SC�|Xy�X���ѹ��f4�ei`�My�XfS^$V��s��.�)3+���l�M�)�q@�+��e�`�=��*x�X�
^��ɂ���B�T�V�R�ҽ(S*+ʔ�<>f�`���pp�. >R�n�f6�Ja�̈́�L6
f�����3c0s�K
�l:�LU���0��03�|�0ʦ�._�Ja(�)��:��0gw�*��c,�k
�l&Y^dvY�(�K���!���e���;�1��<��J�ٻC���?�kȢhz����!���-/t{�,j�����w
�2�w7�,e��.�4-��,�f^j?{��Y+�#dq����������U�2�7c^�m,3]Ƽ��Х����[x�`�+;�yK��	��-�w��,�0��x/�_����g�;�5Cw	Y���N7�]�ƛ,j�Cv�f�?��;����Ol��8�7�MZ�}�_�[wgh�d���oS3�7Y�</!��9�5o!����E�m�Z�͒�E�W��`z�6f�_�Q-#}Or��^!բ��gj1*z�P�}���bu�Q��n���f�{�XݹT�+a�Y���/V�.%��Pݺ�����v�n{J�=d�۶�+�D�E�m*�m��wȖ�ѦҝZ�{�!�v���J�5d�ۮ�b��!���U��,�3dQ3}%�˒��dwY���u�'}%;��]B5�W�"�-dQ3}�;�R�Ha(��t;]
_!�v֠�૭5hū��9�����}|)��,t�I�3 ��C5����ԥ����R�4�����-ݛ֒�Rw	Y��YzpA�[
�����z���(��5����¨����-��>M!;��ңRw	Y趷����mk�Q�����+5�!�3CQ0M�D$zg(�ƣ�tSW��s
C�=5L��k
C�]5�j��{
C��5�j�0=�"a&z�D����x���v�`�C��������0ߞK;l0s �v���lL��%����%��t�%���]t�2ђ�pŮL�d7[�m�ACZ�m�AOY�m.��l{K�:%��ҽ]ɶ�tV�m-��l;K�+%�����n�,ݿ�,��l���l-N�}	/
�,�Z�q	,�D/? �G���V��蕡��m*3�.Y�f��M�E�@�)/��Hˋh�2��bV�iT
6�J�2*��βƞF��M��b�"x/s �g�;�����0V�"�����e�x�hy!XZ^��y���r��dK�)���f�e��L�,�q��+�+�e�`&C��;x�X^B�Ƀ�Ѐ�C?4����hJ���� e�e�%@e�J�L��p�: �S�g
�z�ލ, �)\e3�w��s
�7��:�a	�5�Q6f&-P�S�t�� >S���S�w^���<Y��O�<Ѣ�5d��ӿw*��^/X���]��v�w�����m�o���t����� ��5��t��f�![���=�+k�C5!����3B��+96+e���};�[h�ӿ�U������G��Y��;�Q��/������A��=Br���T.y�����ܗ�{<���B����@�Ҫ��)\߸iJa�&%���~����ʎ�O��F�l?�*6�ME��䵽�^!���|2[f�{����R���~���2��5��n!���-���Y�LoyMB�WȢfz�l0�0��.\�웻�I(ǭM(��M�[Ȣhn�g��f[���^n��*�;d����K�]C{X��!_�Rk�������E����רd�W���;C�`���T�0��F�ly�xy���ײO��/f�~�G��������$���J�n0��<��������Z��}���?�y������|�Q(���B��gĞ/V�aF%_!��Ŋs̀����U���%��OA#ty��,3bא�嶫D����,t�V���zf(*nS�������{�����@��C��*1�0�]C�|V}���{Ȣ�v����gȢf���ň��>OY�{
ٺޛ���	�KȢf��s~>b��E����	)�v�+	_!�v�
Y5|Nm-5���>�9�����,#�5d����0#vY����0#]ZK����2��>�y
�ҝi��C8#�%d�Kg����0�no��{�,�no�ɡ|�0�no�����2�l�.�-1�4�]B��-1�4�mk}Y�{��b����=3�T�F蝡�SHt�h�t�9��ܞRZ#�5��ܮR�]#�=����R�]#�����LČ�n�1����Ԥ�n��a�L�����a��7��a�37b�`��6b�_�A6��_��5��_�O5b�h}�5؝���~шms���ns���ns��ˈmo��ˈmo��Ɉmo�Ȉmk����ct#��%F����ce#��w6]�]B����x+
�,�Z�q	,�D/? �G���V��蕡��m*3�.Y�f��M�E�@�)/��Hk�NY`iy1+�4*�F�`�zqgY�L�R�Qi�o��9��ʋ��Wfr�+o����2�w<���,-/H�<���7\�-]��n��y���;ͳ��y`��^�����f��;`<x	X&^B�Y��_fVD�����Y�2˲�����%`�fd8N ǩ�3����:���;��l��n�xN�*�9�� ^Se�af��=��L��1�3�Q6���i�<z'�b�ě'ڪ�I��B��e�J��������K�ś,t��şr���=1]L��� 5��gT���͚K�q���O�sD�=!^�M5o!����3B���ϯ��d���^���TbxP1#x�����x�gP�[o�u���0��b��՘��0�f�ev �)���ۋ�[�U�[�,��![5�e�f��¨��W�=��Lwy��gȢhz�kҀM<U�6x��![53�w�C^S����Y���P�f�M䮷,ޝ廎t��-��U,�x���eo���.!���Z�> ������_��Ō�M5�!������ZϨ�;C�b��Z3���fϠ`F�^&U�f����e�o ��r������b��M��z��ןe����&�'�z�H��T��Bu�S�{gh���w�k�t��*�������ԭQ�n�Km/馪R=2�m&y�V��(������E�i�йж�� +�%C��^ҽc��e(T�\�]g����K�_��+CQ0�$����&٬V蜡u�3�$ۉ
]3�M2�T螡(�nҭu%{�,t�O�+�d�-ե�4H�ۆ��E����mK�I %�e(T�Rz�@�G���v�� P�4� P�wȖ�JK���u�P��PrjA��
U�I�;(vY�܎ң
=3��C��C�J��Qz>C�ns�B��';�ꚡPmG��چ�c�<"��MjD�WD�ZZI�r�"����#ݘ _  P�K�B��4^Q�[�B��4�{Q�G�B��4�zQ,�=��Xfz�D�G�j0;����`�C������b�+ۓG�j�*Sl�Jw�ڶ�+���-'Ŷ�M#Ŷ�t�G�'(ٺQ((�}Qh[j�?Ql[j�Ql[J71ڎ�=���tB��(�IPhJO!)����z���̆B�Oz�F����Z蚡� ]ܕ;A5D����=@��YG�|<�(���A�Y��ḗ�(�q/��V��[�t���eeŨ@AYY(�0��@hZ�$���<Ma����4���a�h�"������t�ֺ�ef�>Pf�en� �J��I��=,�(+ �o�3,�X�2-7�fe�rӨ�M���gC� �Kw����<,S+iyX�V������ͭ��e���&�L��>���wX|`&	^
��i���i���W/��&xI`��&�����9�/!���D�KAx�l:��P�#�e:�K`�
�l�ޭS/��{�ȇ�Y�:��f��趻�3裻e���L�]"Su�}tό���d]��"k���� 53]�>#�2_�j~t��Žb��_��5o�Լg�S�}FO��+�"���"���;BQ0�u=:�*f�n�����~	FV��0��u~��b������S6S,�-��W?e3f�÷��bQ�[�nu$v�اf&�^;ぷ~�f��k�<�G?�t��Jy�+c���-��
{8������y�%c���-��o!�(�[^��Q>B�Q�f�N��xs���p�!�׻z�9cq�o3�V��a׌}jnky����3������5�3��ا�+c����R/�g��� �#tڦ���Ȃ�7ԩv�$�jߛ��������������ni+      �      x���mr��DϞB���C�{�s���Z�F&�l�"l�#�@TL��1����������t����]�S\���i���X��8c����n�?��<(8&L�Y��db�v���m��ƌI��J��J�C�c�oIA<�Or�aŷ��n�;pd�u�x���J�����M�_�x���~9�E6����g3aƙ0�3w�9��Zp-8��C?q-8��CΡ�Њsh�9����C+Ρ�Њsh�9���x&���`��L���<�0,����<�0,����<�0,�/.���>��,�K���>��*�J���>��,�J���>��,�K���>��,�K���>��,�K���>��,�K���>��,�K���>��,�K���>��,�K���>��,�K���>��,�K���>��,�K���>��,�K���>��O*�J�Ē>��O,�K�Ē>��O,�K�Ē>��O,�K�Ē>��O,�K���>��O*�J�Ē>��O,�J�Ē>��O,�K�Ē>��O,�K�Ē>��O,�K�Ē>��O,�K�Ē>��O,�K�Ē>��O,�K�Ē>��O,�K�Ē>��O,�K�Ē>��O,�K�Ē>��O,�K�Ē>��O,��_u4�q����s���oy�}��.%�c�=o�q��9o�e�=�O����P�	�g)���׭#qhE����N�H[Q'p$��P��jߑ8BB�;��ߒ�x��)冊'Yo�.������vX����s���P�n�x�B����G+Ծ[�x�jߑx�	��H�ʄ�w$�����\����sH�}G�jߑ��9$Ծ#q	��H�CB�;�P���9$Ծ#q	��H�CB��)�	8��ڗ����Gy��Pa`�'ߑp�IO�#qh�0��|G��Ra.=��ı��^z��cK%����[REғoH�CSI�<�n����^z�]�x��<����^z��_�h����|G���Jz��w$^eT�KO�#q&PI/=�n��9D%���;���ғ�H�CT�KO�#qQI/=����8�����|G���^z�݋��}T�+O�a|�'�Vz�	����;��Jz��w$�-��ғ�H[*�'ߑ8�T�KO���%�P�Q$=���;4��ʓ��X*�'���:�<Z*�'ߑ�� ��Jz��w$�/����|G�UF%���;g��ғ�6x�CT�KO�#qQI/=���9D%���;���ғ�H�~�s�Jz��w$�!*�'߽H�L��G%�x������ny�錸m�Ĵ|���zvT}A6VYA6VYA� uT�k���Ƕ��G���_�m^�8Bm^�<����Cm�)�P�$[mV|��)V�8�m^�<@<�y��v�y1O<ڎ6/�
mG���m^�x�u�yA�U����3�����m^l�8�:ڼ qu�yA�#�PG�$Ρ�6/H�Cm^�8�:ڼ qu�yA��h��9���ŋ��}m��l9�_�0>-}1T؞� �B���G���� ����$�-�=|A��Ra���·� *��-;{���iR��s���$_�x�T����<�NB%k�!^�8o�|��-�~=����X���9oǾ��޽�\\1��_��.�l�>���?#����B�c<�G7/��cy��y�|�����1V�3����:�Ѽ�VE1��q�x�y��ho>����9��*�{N����J�ӽ ���=�{A��һ�t/H�CTz����s�J�ӽ�'�>*�[N�� �O��^��t/H��zN��ġ����t/H[*�{N��ı����t/H[*�{N�"B���C�GQ�����;4U�-�{�����2A��^��:�<ZZ��9�������D��^�x�����ӽ ql���9�ǖJݞ� �рW��=xA��*u{���9D�n�^�8����9����=xqO�}Tꎮ��r?o��F��s�b;��W }n ��#ӷ��ߦ5�m�^���~�����/������߿rZα���1����GP��r��J��}�^����U���r�b���us���Ŀ�<z�t�݃��~��z����G��
��c������a�~��w����圗�cy�1���Wn]3�n�r]t�����5(�$�}��UՈ)�&C� ��&U�Ȑ�$5$����hR�k�sH�k�c�oIA<T�>e��')^3LX�-��Y�8��^cH ��<�hU����V�k�h񮧪.�Ļ�����Ax�(�!��T5"C�SU��6�sHU��sHU��2�C��dH�C��dH�C��dH�C��dH�C��dH�C��dH�C��d^�x&��S�%E����3TX��`H�Pt�!q�����pY�NC�Q��;�cKE��D0·� *պ��D��x�T��NZN�U��I��D0��;	����8o�|щ�'�w����΂����)�Mb�{G@?>8��`��C�ܣ�U;���?�����﹎�olT�fCⴤX7��=തX7�������<p�Q,�	4�#�	�Pa`u3�!����ġ��Y7ǖ�n�L`H[��u3�!ql����&B���C�G�n&�$ޡ�`��f���J_7� �\�y�GK�����|�xף5�`H�T��i�`H[��uK�!ql��-��k�
V�`H�VB�n	0$�!*XuK�!qQ��[�s�
V�`�
��Z̖��%�O����Gay����_`��������������^��=�{�����/��M㼸i��m��>	�
�ʧ�%c=��M�|�Ѹ��*u���۴_�<s�-�|̟�X��S��Z�t��d�Aq"h�>U;���_�����mL�<���FL�Gz#���P�^�����v,9��UuC�4�TmC����RPi~	���h44J�kP�����O��䳞��q���	���R.k��M	Cҡ*Y�A�Jj�6J�i�n:Jbi�>%�4H��WzG�Y�+}G釕�6�j�e���jϑ=E�g� [��ͪA:G����	 ��U�rt��]U:Qu`�"�S��څ���A���K�6��9�m�k��i�*�������#p���c�����r�!���L�4o�G3��J#�� �8�4��N��U�)��~��,�u|�Iy�����bڴ��~���c��=���(��Ȝ{��r�_.��G����]�Ǐ�~^/�i��P.[̭jí~�k���?���z�K�1�r���!�CY%c���qN�m��X�������sgL�߻���9¨.8�Mq�G���l��2�_����=����->ϯG�9����eݛ�����q��v���Ƕ�͇�t漺����v����=�ϧ��CW�#�۱nco��	�#���}�ޒ����z9��j���c95/�t�����+�ۜݕ�5.8b���m�� =�a�M��5H�yXr�|�b��z�����K��F{�5HG
ku�@�A����]�lmh��a�N��5H �꤃]�rt�l��u	�����u]/aRXԾu����ӡ�j���k�������eL�FX��Fw⭊� ��i��iTa�N;�5�O ��`�N��5H_U`mH[�5H3
@�k� �( ��]�4s� Ԏv}G�rP ���p����hg}��?����ǯ?^���Sϻ����F����G��D�������.����;��rz�����s��������9�ۘrz�돹���Ż�_H�={��/}������W�s������V4�\�X�lո����ܮf����z����~'X޿	���[4*��u��eI��;�)z|�Q��3��㽪{s�O�[�J��b�5��������ĝ��;3�r�i�~T�><��y�f{���?� /���y3�?�+�S|���b������Óx�eg�'��O�RV�|������ϳ,�y���PY���`���ǊoYV�,Y���Á-]���q}�x-�c��n��I�T'_Y��O�.xY�,\yo&���   �\��{��y)��'+u�����~F������v�묬�y?ϲn�I�B�ʙ'�K͊�JY�$>�b�'��,�Y��ϳ,h��S�%-O���Ȃ0>��ȓ0kE3�'�<���D���Styϓ
$�T�I�	T �}E���C�ʪ�-���O�*+�_�C�I�6�<��MF~�x'��H�y�m�i�ɪ�ȓU��*P)��F�ڍ�,q�O�*M��'�c��ȓx/�zL4��*�?-FD���C�[������3����?/y�"�n�'�ȢQ��xqRq-z<�'ע]��<p�Qq]�X�G4x��r�7�I!��u��p���O�yRY.�<�3����ߒ�x�pwm�ě��u'�_�8�� �	|�x��<�����Q�I~��O�����k�c���+�$߿p.Pa.z<�cK��h/�$?�:��\�x��P�(�<�s��G�h�I�CT?�^O���Q��{���q����¢��9�$6U��_���|�ڔDくQ�y��Y��yN4B����K��$�`M�A �Q�,-���O�O���!~V�����]O��8z����_hLo1�%Ϝo��Ѹ���%\��������ƶ��b֠*pRȆģU�|C�� C⇢�M&B�k��'~���eH~O�C��e"DAq����[���&�[�I=XU52�x4�	$����|C⧢���ı�U#ͪڏ!�f����� �īE�)4�!�1ߐ�@R5.��
�!��M�Ļ��7�'�ޤIe�7$^٪jdH�<U�ǐ�y�ڏ!��T�sO��U�G�Ҙ�Am�7$�Zm�7$�'|�ژoH�:�1ߐx�T ic�!q&P�$����C��J�Mt���Ӥ�J�Mh9��&�'U9ژo�w���1ߐ8o�1ߐ��lHa�7O*ei�נ0�Y�R���3H}�7$>���|C⽄�1m�7;T�Ҙo^�)�����pg^���|�H��T�
C��I%�6�/N*��1ߐxqRq����8�����|��hc�!�`�,��|C��<��|C������\��3��ri�7�� *�ݵ1_�xӣz^�͚Ɓ�� m�7��� ���1ߐ��şX�1߬k�c��6���_8�0��|C��Ra�����^gT�kc�!�ՏژoH�CT?jc�!qQ������9D��6�{���qc��qaQI��MUژo��oJ}Ц���&Fo�)��f�o>��y��|M�6�:*��4�2��,_��-����>Lm�I�{����p�      �   �  x���]��6���_1�	�?r�m��n�m�d{U�P�ʌ;3�W����/%S"E�Es^�Ԟ�J�{�C�H4�����������K�G��L����J�;��J�����~���W�9�������SGc��8��=a&����F���!?���Mw<���4��m�'"B�7��Q����?wH����(�9�'L`�E�(>"�"XD <B �	�!ح�2�[��t����f�oP`�DA���!d�73���$R�D��<�{��-�)d�|b@r�"a��ʉ�(�Ί{�N�~�9�S+�4�� �T��f @������i��v���$:n;�~��L�p��X�c1J�s�W�͇���?b� ܌AS��	�f�j��!t�2A�
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
��]8�aaap���(z���"��J!���~���Lf�a�i�i��+�d�Ɍ4�������X���b�2�e�O��˖�Bd�22=TF��{#E d,ޱ@���mN��i�jM����X��b6�4�K	pd�i�i�7�4�0Ӳ����h�8��Q㰷��o[�m�]�mUXV�eUX���������ߏ+���$�&�K��e����=/��4Y�,���}�|����+���޶��yx�      �   �  x������0��(��8i�� ���)���}T~]��u�xmgkm������[o=�Z|��+⽷w��������EopN�@�ɞ8�O`L�E^�ڱ��ÜB?�)d3��aN!�9�Ls
��SHk
9f�e��-���{����ǖ/��������ϱ9�Ϸ���plq\[���L:K}%��ܲkn�5���-�p�.ܲ��Χ�����4�m��?�v�����/�|�Ƅ����1!�%���Z"�1��Ü�bL,Ƅ@�SX�	�4��N!�)Ș0_�dy�˘0_�D�2&<]Ƅ��	η�	�n�5��[v�]�enمYveLv��	�eL�/c�|�-�p�	-cB@K-�D(c��9�ŘX�	�0��iNa1&�BZS�1a����2&̗1a����eLx��	2&�o�ݲkn�5���-�p�.ܲ��ʘ�x�˘0_Ƅ�2&|=Z��5&�DX�	-�D�1��	��c2`1&�bL�9�Řp
iMAƄ�2&�˘0_Ƅ�2&ʗ1��2&dLȘp�eL�wˮ�e�ܲ���-�p�.̲+c��eL�/c�|�˘���MQyƤ@-dL
�Q����D��I��dLȘs
2&Ҝ��I���ʘ4�˘4��oc��mLzz�eL
�1�|ocҼ[v�-��]�enم[va��mLx|��oc��mL���I_����Ƅ����1!�%���Z"�1��Ü�bL,Ƅ@�SX�	�4��N!�)Ș0_�dy�˘0_�D�2&<]Ƅ��	η�	�n�5��[v�]�enمYveLv��	�eL�/c�|�]T�1)��
,���EtQ]T0�ne��Ü�r+ˀ�VaNa���@�SXne�Қ�nea�neY^��0_��0_��(_���t��B@��Э,�o��¼[v��]��o'��[Y+�`e� ����]u+ˎ׭,�׭,�׭,�׭,|=Z��Z"h��Z"h� �%b@�?�),�d�bL�9�ŘHs
�1�Қ��	�eL��1a��	�eL�/c��eLȘ�1�|˘0�]sˮ�enم[v�]�eW�d�˘0_Ƅ�2&̗1�W?�z~j��k�� ��h��#u����H����߭�����x�]
��?�|9�o�_�������l������;��x�'��Y����	ܻ��O`�'������x<� 
##�      �   N  x���Ko�F����c}��O��Hu�ʎj��%�/r(Rr��)�K�� |ѮB�4���즲������S���~��t���#��|c6��j�>h���C��W��.���o4��o��o?����}/�����g�uy�u�~-�י����Q�AYS;_��;L�����MH߱=j�U~s�=ݽ�������������^���J�_�X��o5�=���P�����~h��@��zbV3.�1:�h>Lb�� �YF�Ĭ*�a�� �>N���E�e-���*_晈��q��[�j�K�!�j���b��}~�|P����Ny�ehzdFZY'B�1���e�DTf������~���:t����D��9 j���������;��q����~���� ���D�|�}��V��9�b"3~u���.'D��=���B �@:M#up �Y��k���U������,��l�.D%$�`��)�a�),��tA�1��\��vY�b3�i�E��U��?��M�k]UW�z��]����RY�j�k稪Ize	vN�:XG�l3��	��M�V�. (�I�.3fN�:PO�����cP?ܛ����2HRB/�:�mhh,�,�=C�3Lm��!Hj�*	2�]
�s�6�
#�<ژD��ƈAD�	�-E,��M��~}�&b9l���5�A����Je���\�b���ӊ�BB�C�R銚E��r�`��X��.ƴ��h�^�J=���>ӺZ��9�R��oYA;��'<F�@-Sd��J� S�S�ZA<L��e�D;�+Z�b��2��5�}��hȣ�IV��%ǈ�J`��XR�T$�Q�ؒr�J����v�,暢�
�n�&�F�IGJ�*�)�'T��&�� _cS�E+ή�OV��\�4E=�Ŕky�=S�,�U��i cԽk������O)3�$b_@� �Ҥ�.�����7�eR�:���T˚��Z�Ŕ��E���a�0��[V�?Abe��Ŭb�qq����`��Beh�����3�X�zZT�0kk.M3PoV�bn�x,���0��,O	")�0���փ�L�@���AA�
斞�]
ק�l�\���{m�$��S.�q�狭(��(�Q͒Tjt���ډ�5�V�h���KK�+�}�+VM�n� ���<[9l�1N�.+��( F?w�1�AČ8_b@ECKT�H���������#�T�0��` ��n	I���B7XZ��d�T��'�`���ki��t�s��@�~;�>-�` Ug�
w����0�&i��w-0�4�[0��6�G���zU���^�p�)u(*I`�������ZwQq6l|��X�f�;���3���5���9�)C>,��(�#N�0�	Տ��Q�t�Og����Q8?�HݲS4��붠��"(;~�(��� 89�����`2
�t�J�^ӯ��0�d$�t��/��ۭT�(�U�iQlQO$�3�qYd���gL��Uf�9-%�$H� Kx�p��X�Ft/���_Q�.�x����_�J�xX|{*�<"]�x�w�x� Z��oV��a:���f��&��q܀��K����c��E�~�݃�1���Á;�3�Ͼ^gY�?4�ԛ      �   C   x��4�4�N##c]C]C#+S+�b�f\�@M�8ta��2ǡ��]�`�b���� ��l      �      x������ � �      �   �   x���=�0����WdrK��$m�.N���%��` �ڟ�G��<�ا4�Q��c�h�5��$޴�5\[�pg�Ϟb�0�+�r��snl^��i��)���h��1������i��xr������U��%;5      �   .  x�m�ё� D�Mi 7$q��:nE��O쌿�x��b̐�%�����(y�N����p�6��#۴1����p5�o3�k��i�Q쪜)S��O�p���]����w��I�S����{�>{ �i���O_ޅ���|H��T�aa�=R���w^B!τ�(�p��-�i��!��ʠ�0�Z��҅!l��e�E�atbT,eb8�����_��+�dbI�a1�b8���J�s����0��ndĤ1���İ��v�1�Ac=')�-���b��8�F!��J�0*1�1ðݨ�`7�ш�1� 	bY�F�0H�X�j�p�$��f�p�JD�e�0�����`%	j�y,�$��f�0��S�{,�dn�*1� �[��Յa��?F��1��)�G�0H�fܰe(����\I�vbo"�c$s��pa$s�R�\�5W3R�k�O��0b�^��<ra1s/���a�̽D��/�3�ҹ��/�3�RǑ��� �+#�$o�l�_d��_
b8���O�C�8�~RJ�
      �   *  x����n�0���S���s�rW�%(���n�#��ɢ�bo����Eo�A��|!�?�u#R��l�C,�T��Ǯ�N{X���v�	B�ew:\
�i�� �B��k��Y��LcJ1�$�,Ģu�G��Yt��������].���CÛ���ѡTf^Gg��z�Б��ލ�c7�{���	cf �k�k
���)
S=����C����o�rՔF����Q��E��펪��CmBH9��!a!��U�`�)�f57uSW��kt�G��C=��݂c��_OB,z�DQ�HE��      �     x����n�0Eg�+�2H�eis� ��H�-k��6����Į�V(���8 D�O�,#�\tÔeK$1��_g��}:}�?2<l�{��6�����#��7wpx����B�P�s�D��e�B�ET<�V�a75�vZ�n�Zh��1��p��X���P(��@�Oه0Kd74�U��/^�R�Ҽ�%\{�e�5��Ui*,��=��c^�.4@�j�Z�� ����A����:!y
�1�5l��S�W�eUa}�u?@��      �   g   x�r�500�52022���Ә���GAW�9���W�����1D��?�߇Ӑ���F� P�������g�'�(0O����������S~I~��!W� a\�      �   �   x�36�r�500�52022����34�56�4�4T�UI-.Q.-(��L-R004�42)��?2@ҧ``ie`heb�gllaba	4����E!0�1(�5�3��Z#�1H��A��&
��+F��� D~'�      �      x������ � �      �      x������ � �      �      x�=�I��:�qj19ER������Xu� ,?G�����S�u�8��/����_L��\\\\\\\\�_���ao����7v��?{5o��[|vܫyc�V��F�ꂺ�.��g?�{�[�����~�������#�,�9�9���ü�y��V��,'�	{&��;ϰ7��@=P������㟌7�c������������ɔ���Օ�;?�X�X�X�X����c���_��*Xs�'M��
|�?~?ɒC��w��+'^9�:�,G_�o� �,}�9�vr`S��o������`W�+EZ��J�V*�2�J�V���������^�JG�t�JG*s�2G*CE��[/￭���]�Ϯ�go�=����#�7�;����q�q�����O��H��H�YrVL�$I�I��H��h�O�?�_́7��-�l=;�4���E�I��]�Ϧ�g�3�����e�L�������7x�'kqX�}oe����3n�Ƹ�f	!�1S1�0	S0G��o��F��n�����ܞrg��%�b�!y��dd(�(M�J�F!GuX���d���7��bq�A| 6�	�bq�7�x�ze��>�/��ߒ�Xb�#.�a���=aO���=aO�ꂺ�nonϏ�����1����pv<D�=�ԈK4�.q�8�y��%י4�_C�ՌS{{{б�I��������X�5�l���#���c�c��+��L�_k�/g�V�O�oQ�Zv��uY�:��9��������t�4�􎴎t�4�􍴍7B�vw�1Q(&X\��`��{��ʕ��_]q<(X\��^q���>*���P�]7O).RlD�{�����x:S��L��s�扞�ڼ�J�0�i�Ӭ�c�<��i$�A�k������K}�sW���];�9��w��=�ȇzPn���S�DS��V�_��ؚ�����[��N'L�K�K�K�K�co�ؚ�u�{k���[3�v��ޚ�5{k����[�4Y(����f<��5*7*����ʍʍʍʍʭU5B7B7B7B7*�����/ԕf�ЍЍЍНn�ʍ�� t#t#t#t���fDh��\�Xf��b��2�e�3����>sHYZ��K��x;��`�&>�2�g#��ݏ���Q���Cf44444�\Wr_���][�rq�}55b?���f��KC�C�C����(ɰg0fp����ʝI��8�����Ɋh���-[�H�_#��~m(nn$/�`��p�!�!��7p�A�YYg.t�يm9�A�q0�̃̃̃�̃̃̃̃̃�se��+ϹDʀ؃؃؃؃؃؃؃؃�s�
��g;�;*��OX��k�����|2^N��>���aa�B���5ʬ\�~}s%��܌a�a�B�e��,X4�h`u�հ4�h`�������%,JX��&w����,���b�0�D��[aN,W����{yr�G��>^-�XT�X�r��*5�Ž�{���y���|���.�v��ˇ]���Y�o��?��?b��      �   �   x���K
�0D��)|I�|�Bp�x�؁\�-]���1f�!�{.p��hrZ&�,�C��YRr,�my�rp�߹C������Ĳ�!��6�����I�Wbq��ǐھΗ��&�LJ�r�cx�!��-_�      �   �  x���mo�@�_/�b>���»U<E�.�i�7�I���$��r���Dt9I���~3;��Y�Ů< ��P�@ϸ��l���0�<%�S.�(�c8�0o�{�u�k9'�ݒ����iI�wI�&Yy������v���]�'�����JRfv�3A����9�3�Jӱ�2���b@-XCq��+� .o(���s�\�P<����C��6�^�IW\�D�	�|��I�Wa�۩u+I��R-S�܋PP?�i@��a�R2^GM��c�r��� �� �yd��b�40ޱ�`1@t���Y�B%�L�����v*�Ab�v��L=D	�#�#��z�g(wCo��h�k�XFk2	�<��Lp7����E,C�e���$�U��s�S4�=d���d!�<��n�qf���t���ֹ�)�L��8]ּ��ɛ��:b�p)UDVa��s˹��������]�Q�$�
qOjy�8������@e@)���������g���׾�hF��ku�.�1l�������68�4i��O�ɢ|.���z�~����l8��k��NrU���f�I���(��Kg�B1,�DF!���c�	D�^v�4':����]N3�:���dg��κ'�E��^X���j;d��e�"�6��F�H�#�W�Rܚ��뙆��G���LB%����Ǝ�`)�(�����F��j_�V��dW�������+���U�QH������11k����zsO��4�,��OU      �      x��}[sܸ���+�8��%n�7J*Ktݴu9^w8b����ղJ���==�~3�
	����c)sJ	$���B����_����䫢��� L)DS1&�.�.�������������F�JY5��d������/����������x��P��`M�dU��J�?T�Y��5��c"f��
�JU]�Uv�V��w�y?�E�������2��~����_�2��e%ZS�1Q��\�L5,SU�H��2�������NԊ<=E~�j?��l�n�E��KT�eI!�VUnYn1�y�ꃖ*Q��(�fL�-&Q�^�ԕ��s��.n�y�wz9���ݪ_\M��嬻�|{��]��_r����^D/�-�Y�惔�nyǹ([�2�_�o�V[���Y�芫�t�m`C.�˯�n��_�[u�{���^�/�;��)�]%��'&�2c"fO�*��}ޒ���r��R|�|�浪ɒȚ�)T�]����6c"fM��iMѢ�ʘ�-�����Ïݡ����`-�l������W��M����Z+5&����'���?����tx~}�?����þx��;8֯�_�?�aª��]��ꡀ��R��+�6�Wx>��k��D1��gT���&,^�JTu�g�/����f
kx �ip|l��2%?ȶ�u�/2A��T� ;,�B�c��oW��S���S�v|�v/�_��p�����w"ލ`��}WZ��*['T������^��.�J��?�l�����4�W�Fޱ�U��#���e�gg�g�+aj����ᩘ����a����n��m��P��|ks�{���3��/"�S�����`I�[=&�_�2�y���Z�V��̖�n݃��.>��UѼ��蹖��۲���G$���5�C-��ȡ>�����}��k�O����L8�m�;���[��^�t����i/�1���R;l�N���>��;��
�ޣ��������o��������a���g�rѾS2��.b��惄P� !q.R�2�ڞ-���������x�����2�����N�>nz/	wہy�Z[�vL�-.Qa�%0���nu��nу�����,���f�-K������@jL^ȸ��5&bj�TQ�Fy/�c�i�w�`TKoE�Y���[TtB�_���mm�ǖ�V�t�{^���6�������
g[%l�r���f�&��њ�x?6�C�J�dݥ�([R���G8Eʪp_��<���X������˨���C!��mSKn�.C�A�R�-�FEٛ�U���e��~3�0o&��������{w��p�~�p��M�7ؒ�HK��t5�����~�2�zVDWϪ$W�Q������}�n���z;-���z�pMHI�8b�зtw8�m�&"�9MTN�TG�nB7Y}��au��X$�Qt��( �u!�e�M��J{S�(��J�H��Tm�ݿ�wq�����?O�bY�C*>�����>�T��D�3�BX3�y��̝%u�� �������6��`TU���MT�[�џW��ul��F_�ↇ�a�v,Dm���8�4"����B����?�����߻�ݱ��;��n5�)Ox�ke�ǳ�O:,��X��ж��D�I�U��^WFm�����.��-�r�uFS5�0� ~�NS5Dħj�
�������y{U�B�/�BV_I�q䝠�F�	�Uk���G?�d����VTJ��|y|�����؃�[���|��B��vO�Q���n���c��	�*�vp#���,�G�՛�_��_��c�����*�z��T��w�������<���)*+ulzrr6�Pm8p7��hs/�Wy�\�.ĨD�)�q4`]֢B���i�T�1xi~Wb����B+�ne��z:�<~�oE 'LM|�0��]�V�*{��w�����}����:l��2T���}������c�tM�Jz?���:��s{��s?��p^v��vWsl��&5�� @�q�0���p���G?@��=��c�۶��ul�\��)uU�F���6Ua[�vR4n]�uޭu1>�/��t�l���v�����q�b㞆�H
�l=&��w����f]5��������'��6��p��u�b�_w��t;[.
4]�W��eΙF<e�ÛF������p�W�l��ד����[����S�����������F}��*�]0!�mՎ�ҥ2*�R��[��v�
ql��|���q����9�4�0]�N*�����D\�5Q�6�U; r �k���Z���ظ�K&�
����J6U��D�o��d^"8�F�D�����E��z�~,�����UEv!u��㼼ZE�$+�AD�s��)͎��w�&W�F_
�xі��vD�-%���i��`x�LL?�_�x��:\�#y�%8�j�/mV�Eo�?c.o���o��I��^})&��8����M��vI��l�L�HՒN�*�$��Jk�z�E����\����K����-��Q�!r��+|{o���MU�1Q��*��w�4Q������S���r{u?����Gi*W߉�ܒ�C�MZ�/H�hF���\%{��Q3h�����lQλ+��+XHAl"�?I�� g��4#�Lb�����'K	a�w~&�X�
��˫�
"?�n���C�X iS��Q��U��	I4|^Z[bx1跠]�ɴ혈3=�Jn5�Cy������v�����/D���v�?�zyz|�g���ꝍ��?ĥ�c8������k9&br��J^�o���i?�]v��̓��4�Hj�߮J�m�D܁NTRW��������})>v��~��$y���ni4�Uu�*XJ���g�tb͇
�'�R-�53&�\�D%�	|x��a^w`�o�w�m��߼�nH�ڼ�����EKr���//����_D۫~:T��Q#gH�Հ�,x=�qg(Q�ΐ�����鴼?�_���u/�&g�y�� ��@"�'��d�<�������&�_���_E\�}��Cya�ձ�Q��[𔲥1���1S�MU�[���7��A�~z��?$&�Y(����*�Z:	�J)e�j1&b"�T%_+��:�J�1W���X�lF�l�4�rG-َ��l(QᲡ�xJ���w����<�&����i�F��4��zLėf�J�H��T6 r�T�v�/&�"DX.��뢻A����oj⏥����o%�N�+��|��9n
�r��/�\�mv/��b7֔f�n��ZG����-�ʙ����C&ɶd���z몵��O���c���x�������m�[N���U���QZ���0,Q��l��&��lUw=q��Oݬ�ҽ/��w��qz�y�\]���ζXm�QI�8�����6X�b�(~cDY�-W�2J�c,���]����D1������+4U�dWE��rֻ��n�F�qw{��9Jp��S�?}�O��+j-i��r�"]6M-b�C.��W�
����i,4����Kq7Yͻ��`�;���X}�U�C���%yU���`�u�s	���F�C��z�^λ�c��bb���N9�⮛� ��|K�	������Ca�1MU�B�@C�!�Ɇ�ݤ�)R.���h�D�OTr'l�T��}�W񾘬]������5&�p+BHC��#�`5WI��&"{ň8�[��a�u),xU�,K�����_��=���@�:�Ĺ C�ϨF���2b6�0"���M"\���v�$F6� Z��.�Wh6`�a�D�͓��i^��>��ޭ��n�/�>MV��dQ|@+�δ�7IJ,��|ł�"ηLT���܎�d,~?����.?����H�`p�-1(QzL����
�S3������Kqy�)��(����A�*mUi���@u���Rעu�zD8��9BP`$,����}т���#!�ّ��a}+eS��_3U���Z'|�����׼�m
�e�x<�y��|��4��������(�Ol�Do    �pc��������m9������':���d��h-[�R����Bld��eٽ�������H{=h���P	<p<m<IE\�-QaSm���l�G엸���b�->��eq�\9�Z�/������g �-��x_�˯���r�D[ĐF8���1�j��H�w�_O?~!�F���y0���U�z���Ur�M��)>��W[����NM6�9�`]VhݪQw��Kӆ%^n�j\M����u!�)W"�6��֝S
!"�E_�([m���V�`��r�,�/��3�/c��҇.Y�t�*��T�}�Q�mݚ����aD	�T1\��~h�Q+�SMpJ�F}>�����;��+Z~ݐ<SI3M	QAki�U���F`�]5&�ЬR��7�թR����Vkb � 6����o�R��E�͖xaV��aR���h�
�ϐ����t��GA,B�Zb\k�c�]q4�iD%�m�]�$�s���(���@�Bėe���͘�g*Va�W
�+p�1�W�����o�\QM�`Υ���h�Q��KT�<X���$�P���+j����Ð�b��;D��wAz��֪�Z-GE�5KT�k��M�2beuu��k6*e�ʰ�i[��5~�@T�+%�Z������0�`�ML(w��'�<y�}�aͳ��c�6�$d���RX�[�5'ݕ����'*�f�B
+�Y��b^�mV'�*n������p�Ia,�U.o ���bӔG?43MX�nڳigp������B�Z���I;�'�����1�
���t�=>����'��g���J\)L_c:@ܞȈ�㓨p��O���<����ݭ�5�4+����M�\,�Ų,j]L'w��bگ�y�@C���*\�W�W�R7V�zL�%���or�k1 ��ʥ����-a�T��L*\x�X���Ė�1s�R�,ˬ�j�(f��1_ܒ�(M{��VժmĘ�7=D%kQ���1@�z��@�T���A�P����c"�GT�T��� ���-����Q�~YCo��ٔC�VM��O?ITrěS���;��uw�:����aݖ�&�:e ">."*l\��
!̸�����K�{z1��W�qxm#I�(�Y/��G�5.1\ח�v�Y䥴-�ԈX!]��B�۪F�͘���􎖘�T2p��Z��wo�;��77��>�����o���������D�疨��[�Ԇ��U�r�;��(|�"Q\�)���X��󐌈A��*���J���y�p����ħB�<�O��@�M�T��#V�ʄˤ[l���K� ��E����{f�{�q�D%�AӚ��'���;s�h>�^N]y}���z���t�Ml�1�*\�*K��F�1Q��\%3첁�Oʁ|E�Su|�#�~�J�ZlY����`E�1�UR���'$)8-׽���j����Z�����bq����S#�嗩��z�C��������vL��?�
����K�մ�}ی���-�5'T���	��CHm�m����p�C�����/���c�=�~���{d$(�_aچB�=k��(kk��D�疨�Yc
�����.y��~Ђ���o\m�`��S7c"�;IT��x��7�f�9{e��Z���1�� ����d�Kx�-�@#�ןG?4��dD�]���c���$�pe�E�M�ĉEo���*9G�� V��[�c@T��]�8�j��I�Q?n�J��8㕨�w<�Z�2��M�&��H�\�Ь�.����T��5�I�uӌ��DT�T�d��c��|}x�������������K��cӚ���$X���?���R!*�Α��sjcd�!�aƥ.��ѥ �w���7̠:4��7�(n���_����&Ԍ}W�K��HU�ʘ8ϙ�� <Qa��ʵ6���)�UaBCz[Wm��D\+Q�B]O�֛��3��>u��{�����-(�b�c���S�jD��Eo�#ci2Z�8c��H#�%�U�*���Ն�`�d�/U�Q�����tT|.���E˪P�Tc�D|��pwq���J�����b�<�*|(D��rp5֜�"i>L�g�<w����Ԙ��MT2��*�ڐ%��7`�Bե��X�V��l�t-"��*qݯ�Jn�ж5Qӿ�a7YϙtH��45혈;��
�v���y�Q����Z���?�����_��y��oHӚx�ik�FXC����i����䴔�G?�)�A����p��J�{�^��o�k��[����ՖT|g�p��%\���щJ^}h]
�T}�b���H5[�/�5D�.W��ߙFb�������3w#+bLc��<P4��jCs��3�2�,�Q4���9��`�К�ئ\�%������7juz�>S�d�$�03-��CxJ���~xV��m����>���%���wv��t�0EҌ�8c����B$�Z����ew|�	����Z��/��>�������_��ʝC�Ro��A�.��	�N�1_#*���aȞ/�n�n9D����θ�b�T��d�D|-����6>�6�7V����Oh|y��.�'���f�������dk�eu>�Y�#0��Mݚ�qQN��E9��C�2�w�O�iѶ�ԇ5M�<��6N5��s"}v��`,V��6����|�m
��]�eȌ�^�%�+��C�]��A����
{�C{�/o�s�uJz^KSV*jVaE\�d��tJ��@\r����m�!jG�Zb1atڎ�����0	�yc�n��{�B�&J�4c�7�c���D��ޮU��,�q\�Uy��ͫ�c��� �|U.�|Vi�ꋁ�WfH�]ZGrPXєH4�ԑ����f��XÈ)0f{�5l�	dk��IoX4J�n��p�/��G�Q�����;dY=��;�<K��[cC����L��!pX��p�.��7����P��{�[n�b�E�(���.����6�9��@�z�}��̷��3�����MVc��i�6�SID��HT����Ţ�ݼ�V��܇b�g�n�X�#d�yBt��L��3��. �o���$Dw�p�Cs�;�LS)����c����Uq�q�~��[7$�/�<.��p��I�[9&�-�܈�U(�ǚʶ���~=\����{ײ���ze�W�}1yx:<=�]�,Ĉĥ����YQ*[�&����$*�o��Z�"v��헯�3���ɪw~{#jr0i%Z�႐.�ʊ1%&*\%Z����m�ݧn�Kћ�3�}�{���J��B��R�ׅ8�i�q��D%�+t�Dzn.�ն���:R�P�F>�S���
�j[����|�Uxx�	��1xI�(|)��P{b��Ę�G���kA�>��8�H��������	��荾�X��+��K�0p�
���->#�1cfZ7��c"�-UI�JL�Tz`yr�Ϗ��s.%���5R���F�-�cU�Do$�c���E�M*���<t2.�W8�Cf��l���예s/�8 7����u.���(&6%uqQ�J����H�J����H��)���`Ko��l��K�t;�Eot�*lQ��Cv�y@:����� bF��I� ��M����x'��8IL��
Ƣ���W�ԡ;6����q�Ǌ�D�|F��&V��46����E7@i�j�b�[�X�%����D�}�p�5}{O�o�L\�cX�"�J��
�z�1o��Q!,ʆ>�/�Y�N&<��o���+G�h�*������=U�Of�8vC���z���
���|ӚB^ D���w5��6���4D��c3~[6��9	���!�v�~��o~y_<�|���_�G�0��ї�\���]\���
��U��O�9N\��]�7�����B�M�-��"�fV�V�4$I��ʅ$�^��`�?
�f������]�{��n�~ �߽��,��4'Jg|af�Njd}�p�X��r�T�F��X��q��8M��̡£X!��bL�g�
��Y�j�����=����s    ����
����0X�`�(� ��{��p�,
���� ز_�<4ַ��a\.~n�x7�"���p�����R�fZ����u<!���ӆqp���ib���8^�D%:-&���w]m����8=����IKħ�qW!ͨ)!6�U3&♯�Jn�k7��4�]O>�/V�R�b:q�g���0]l@ڔd<��U���E�X�Ay#������?B3��p����b(�����Qa�H�aNe��OX(L^����J���Yl�8��W�n��D\J'Qɞ��`�׽����w��%ҭ~��ZI�1W�����^��g�A�a�vL��g�
��!���3�6#c�Ԉr�!�D]��,��Ԉp����Z��'��u�C�(����ݠ���&.�0"�� *�ߡ�Sk�f9�#E��P� /��uhK%�0c�7��X��Z�����k��zH�h\m��Q�	݂ʱRմk.��2�����"����Ӏ
��cC��AZ���7�I��|���ʴ6ޖ�����]�W?>N��"OT���'
4�~q��~ݭ�S�P,
c�ș��I�`�B�aM�θ��r&Ճ+����|�Zmb��V5�s����	y.⢢D��j��"�խK=���=$����mM�I�1��K�����N���-��ni�;^W���R�֣"qBT��w���������N��EX��Q����k�嘈Aئ*9�� s�8�Jo�[�v���ﮊ�?��X���y����ԟ�/G�p�I\A� LU*q�"&�����a��Q�N��ph��ì���bt�&��>��8&d�#�U$���4r�]H�����%8��f��A����v�Hk�W�:7XĬJ�T�Љ%"��!*L)��Ձ�=]��?W����k��*Z~ �l��]7q�~{m.�20�ՕI8D�gi�J�5��{�u]�����nx����=��_v�o���{I���s0+���W�D|0LT�]��P#��/������UY̷��|�]�.[a�%IU�TTmO�cD�����tU9V,�f;]/�qO��2d�EL�&I�����K%�����([c������%�&�<�����v54K�"�=�_{��[l��QĉU��5�>pD�Ė��(-i���r��2���q��D%���g����Zmwp���x5�.�(���k
IT�Ft�-ƍ��{�U�����(���1c"��"QaPM�S��p|�p�Z�`N���T$�C�06��AU�Ok�D</Q���
�)�D.˻�8�j,D�$>�m��}ȠOq"=�(#e�f@��Ot}�M���/'���ݗ�j��|�t�Z"��0�'��D<�2Q�T%�����u�Ɇ���b�)Np�<�!Bhe�Es�*�b3p<�)����U�V5�����5�P��1�Fh��(TuYYU[;&z�9�U����P�D�j�Nf�:�î���j������3�L��ސ�혈O/6� ��7O7�>���"OI������t튞��9�\�?H��zy��1��~W�O�i?LqХ�t���6f�ɢ�A`�AjW3&̓MT�'+M=8y��.�L�iA���#-0�5��l��Q�(�Eh�q���JMX�<zO����:1~O���,!�O�a�
��ق8�,.h��(��(bp�ayD�{DeXT���n��n>�0�M	�T����P�3H��H1&�H�W�S9�D�Õ�~*n�~������p< v(�h�S^��x�`(��c"����p�<�L�C)����/�����I���2�p~���Ռ���.Q��e8�� �M[��ñ��O�2c�븡�!E��LѦjGE<�Q�ڑfz�cz�����Ϯ�?ǧ��?�����숝���ku�t6$s/=�)�۬�I�*ɂ]�F��c#�/GX��x�=/�������W��fN�cD\�I[q����ֱ॒\�Cm�´ �Bb��mw�#C�eF�(�V@ʐat���fR�If)3�,����J�S��m��_��[��-g��XŰ��I�;��TUӐae��o�%*L�(�*,ϐ^�ҋ@�.ǒ��M���d~H*��D�Ir³�}����a�ͮ��#ق���PǢ7�c���O	M̻v��6Q��H���ҁұ�~*O���X�*y�g1�a<A=��]�N�L�²E �J3�"�5(��b��Pk��0�p^}۩3�2���.����-8�vL�u��*yw92�6���������l���ط�z�+71����m#�1D��m#��4�r��x�ۄ��l�ȕ����C/���>��R�bCI�fL�%}#�Jև�'���m�_w���}�:b�i��&������)!�l#2F���ܷŬ��۳/'N�J�2�+�ڲ�"N�e�O�NUJE��S�t��H�IFMe�7��#���������v���h�ql�3cl��8�J��8c��p�%�n͙��z���>����׀$�$d�JJ���+
���#.QL5r���j2�hޚ�ٛ�Ņ*�D�P�4ue�Do�0b���bc�"!�ےE:2<_�&n�fL�&����td8�:��OVדi70��	!�N\�\�k��Ǌ��4U�'wWC�Ґ��6���%?�yt��AV�d�e.������o���v5xG�"������'�%�r�HT�D�/���f:A@�1�{Ts�.�SC��V*�)8Þ�0�]HY��K_�]9Έ!sAq��5H��s|�6�qG2QɢǦB�Cp�^!�ڕ�e��R`��;����~�ئe<���'同#�h���H4N��9�n�_��(]�U�8��CY+�mg�$���hdѭ�{^5e|�dY�w�x��}Agڔ�敢I��+�w���т�g�"��OTr,�d�D��m��F1��M9��q�m<c0��r�U��sR��~�y��5�5���]S>*Wem�F��8��DeX���p o3��/��㾸}z��U���1�X��0Ԗ�RSC���U	q݈�7ґk���c�^���i2$YJG3"�Ʊ�bO�Tc"�ᐨ��.V,�i(���y?�h�%y���|�K��:
z2Y�	����U٘ژfLć�D��+sfV�o7=,�#H���b
0B[7A�"�l\lgF�6ȵ�#Ìq��D�+�+QC��3�g���0A���i��t��z�z���O�U&f���|��h��K�(�%*i�ဌ�����v��:���n�B��rq�w���r6�7�-��^N���8y���D����y������RDė��JF�e)Y��v���nT� �s��}-~�
W�z�wܽbd�cӀ��G�Z�keu:�q��8aD˅�zz?�od*�l���?�\�w2n�KL=#��i��2i	���:Q�L[�*bV���3L����n;[�����H�V�uC+��\�v �
�Κ �sW�OT�D�VJŉС�ő�Y=�4�cJ$b7�"~iD�]D����������!I[|�9��� ����D<EQ�o��!�}�p�;sI���ͮt�n8�Ҷ��=�YpJ�����3��臦�v���_5��;�>��oH����l�yDܩ��3&�s>D%?Fx�4��p���'78{�7`�$�:�����nz�p�sk�43	=9��
l�&F(�".��䁠�~�����Ӿ���@p�l\�K刺���u��O������m����IY�*,q ����ݹɛ�2`^cÛG?�t�D�_z��l�������k�ׯ��=��s�׾x~���B�k�4A�]���%�h�@�`&*\w�f�'�7��N��d�/6�g��q�.>THCf]wI��ٶT�70{��q�p�C��X�Y�)������$26��8�hi��H,��8�`���H-u`|�.��ϭ�k�� ���ɜGt��g���u��
��fL�#�
��o�?�
%�ҁY��㰟	���''���0+t9R#�`U+예3,�
S�BJ��)l�ڵ��\�����A;9��@�p������A�]+    �Y����5͘�;��J�0���s�W���?f]��+eD��q��B�Yե�ueGEY,W���G�����C���^*ǌ
�P6vL�F/U���R��U��bխ���ʿc��	�Q���Jk�V�p�QoLT�3������}��w���=��t�����aIj���#�F�#Q�RHT��(<aU�Y!�%DlݐFF�i�q"_9�n1 F6�x]���8�*y�D!]���}hb^ڔ�A��ud�'߀����!�}fN��z<��<�`�_/�����C�'�S�n�����f��pZ1��]㢲�FĻ�D%O�`ܣ�5���f<�rc�3�����Ȳ�����ۋ�
���W\���8��8[ �tk��;f�j�)F萠ӑScS�l�h+s���)����ē�t·GA��*mJv>��".^LT�#~	�wr�,�����Ǎ�q�~�cG�Mlֱ��*3&�� �
ג���9�`Z��C�Ob�lbS��ᬭ������HD%ߝ���L/��yO���Rƽ�9zE:�Yjx}^�q�D�C�#B�k�/Np)I��)i	��YC`!D;&�ћD��/+�~1�x� N�>wi��\�F0Va��2�]v_�`f�7��j:|z��ө竌x�l#��EFՂp��"�K��pg�Qm��κ�s��E:��r�]M���n�����
�pT�����\ė�
WpE�R=�(�'�a+K�IZ��,�WU}f+bE|F����5t'�h�/��	�6����ܶR���h��F�U�v3��{��c��V�M6��r�����H�O&�@�]��e	o������9LT�J����/��=4I����V�ޖu�J��8#��d�@4ͺ��m��7ٿv��R��#�)�)ُ+sV�r=&��S�� W4C�;�x=Ï,	'k2�X:8�.��ǈ�L·��YO�B.ME&8�Z�;l��h��1��^$�_��qo�坋8s���+�]��4�ޮN����U���4��s��4&��3"�- *y&*F��0*Rcm�M��,���;��[�,k<��wE;�q.�LE��fd�۞3��l�#�3�݇���k���|�b��+_S�$�~=CBi+MH�rO�ET���Z)����k�����sE黡d���������������~x=��z��/~�~�.$N~�,աV�0m�D�wKTr���1�z�����yu��������Oh�D|�i�^�=F�S��Y�Y�Fw�Y!O���P��O'�~�W�?&��|�R'l@i�����mj��1_#*l̘�>!}
�]ߞ^�~�zT��nhN8jB�[Dz�c"�2OTrs`Det�D��>��#���ͷ� �	da3h
�7��sLEop��*�I�t8M����≎ެ%MN�����~.d�_!".9���Ny�H�3�����cY�~=��!u�f�jA�y�`��ղ��q �D%�۱U@�*�%�\�lj�Sg�H烐�.D_����6Ǌ��c�*��pL�?w�Av�Y-�we��-7�iY�Z[1EGs[,?/&�"�V[����f9sy�y3Yl������LϜ�q���1(V�1w����+�&\���0�WI�����uu�Y��3l,�{����q��V����?L���]�����b�:��;)+2E<z|���b�"+uǢ���*�qp��&���q����	�������J�@D�T��)L	����|��zV�`&��R>�0�
w�%���@w�4i�I�SƑXW�P�VbL�E��
��r�D�t���Sh���j>)���vV,��d�|}���=V���.h���B[Zۊ�� q_����k/�������D�ϊp1e��8뱆;��1��@T����@�HѰڮa�x�Q`�v1B����!8�^i�x'#��!�
�X{$<��C�i�\�|H<$�I�b�k��Ke��+��)Qa��U����q���L�EU6�I�I�༙���q�D%[�;@*Ԩ/��r^,gk�������ciq��y¹�O��|�a�QU�~=�m:��)ҷ�t���w�4c]"����8u0&aD|�Q� ��������GQ�c�N�v��D.k�DܮKT�]'NM�pBo��þ�z�������3����>FO�'�a����M®����!Qa��`��&�?����~�~�l��̑�:0�M�మ$Dz0�M\�����B`x�vLă��
� �+5t���C�wS����*l�ž����e�<W���N�0~�`<���y��;`?���@O��*�����B@.����Ӷ��������ܜdc�-&v�E\̐�p1���y֦�N�Y�e�;�~�^�o���]�Z���u�ԘGQ�:�1dEo���*�z-,x����Y�f��0Eq4�5��6�Ĉ� Z�Ux�{.�vk�eͩȍA�O�_?�[��F~0�@�Z ���}f� ��W4��������_�G���{� ��/���ĥ�MS�ꢟ �nXX-��~h�V7�A�¯���=҅S��z�{����(��qL�i\�^��р7d�D\ �����F`,��VW�l;�>D ���Gr
'�Y�iS
:^�q$����!L���A��*�I[���������K�����oO�3_���Ԏ��TS��8�`��;��q����o4�a�~��K�xQ���դ�"�<�	�Q��Xj9&��D%�-�
�M��{Dh������a�TR��T���Dp�����2q���&*9�	��i`I�1��p���7����.1cFHE}�^���]=&�.�D��l��NU�Z�+�Hv{�%���y�8�W�֎�xQaq��|���&J�Ӊ���UYO/�EL�3U��^p���>�r}�������*̤�J�W׊��c�\�cÈ
�.��0Κ���N>9�	��i%ŵ�j��&�ps4��"��'��5J�n�wέ��Oȝ9���}P��-5\v�q�C��F���Xc�t�!R�h��w_���]��7 �.7�h ��GE�㟨� �����sQ�i�pZ�߮]�Z��PS��]�V�M&>$"�P'*�V.�q�i��1�w���&�BăG��#J{E�zL�wv�$#�}x���[��e��rկ0�{Ѽ�Œ�?ǔU�g�D��&*,��yb�c'�^9X��e૒U��oH�D���ps�uU�	�Q��u���������]Of�����pxn+H9/���c��<pL����)њ��X}�[	�}?_�&����=WNE�fH���j�ry���y��J���T�eVݭ���>��iV�B�<�O��Eo`sb�,�q)�@EZx��b��x>�~� vh+ʌ�&�U�\q����1�P&*lBYYI0X~|�ǥ�U����*k,�"���ʐ�-qN+^v��6ɘ��?��Zjc��y���d��ϙ��#��q7a������
CI b��?>�<�v�睋s�lF��VӖ�����K�UxX�V����ű�"�S)!�GEo���*�R{�
 YWp+��C$JX��%E���v�����Q��q�	�y����&Sl@J�k�h�w6fy�@a2�v`/>#���%*(L�Z��z���ح�_Ιd<����53����X�6��	-r^JT8�q��䮮������׃�綺SLŢ5��N���P0%&��qnC�148>'�����_a�E���?��-1ک	w?���j��E|Q�L�ƹ��m}��Q"!��d�y.Gǚ��U����mmŘ�`%*y���'�N7[�3(w����I�����4v���
G
;T�Z6#�7jr����r`X�-x��[n�nOPߋ�P����v$�8bX�`�&.��"�"�����2�T�Q�b2�Yw8d�g���.�Ys�%��c3KU�kSc"�c)Qa8��R
I����`��1���aOb�^�Bȶh��k.�:��	��]71:�8�c��C�����+��1�7�4uGD��G��,rD�ژ�H۹�]�}=`2�F|(��M<���Z�Ҭ\7ұēr����Ku3�C�ρ    �f����?q��������é�	���~�q��u��R���\�Տ�F^0l!�0*j>�c����xli�Eob��*�H@U�rԧ�z�ԣT��B����F<���G$\�jpUx^N��W��"����Ƽ���ם�H�8�'I�E:�@_�U葋8��	��e5�
����+x�)�Oa{��n�i��D|Q�kx�빹�R{�q�`w�z=<0�Ʃ��5
!�t��"NU�7H#�\8S�ǚ\b�X?0�N'����L\
r�:��d���b��N.�L}>����D�f#�*�˲idJ𗈸�'Qɭ<� jEF^y3︙TK���(dBSH�a+َ����p�^z��y��_�������]䉂�}�$cc�<�T/kp�$�5*�C��W���yh/21qi�s�0�P%��1�#�]7���n�H�t\1�s�Wcs	|HdS��1�&*�ߕ��*ݐߗ�����^�߻Cq�^��������n� �y�/��> f�a��ɏ>;��|��zB<��Kq���ڒ�0�pw)���RD�ٗeL��#�\�
�We��#n#PV�Tb�[���Ig1���%��$��yźE��ʚ1��OT�6N�������CkiC��TjGW������J~��އ����Uw�NNp�]��}�4��"$w��b�31ċ� �܍~�&�+ED<_Qɗ��w�N���V��ߖ�d�1�EJ7��ܪ.��Q"c"��.Q��
�����)�oP��8����Ә�n�2&���D%����h��������d�X�L�ad,�����E���pY2a�<Nv�0qv�;�d�X�UF���|Va.t<��L��z���C�*7�FR{��1��IT�n�aHעN�iD�o(��H��<7����̥�����K'*�s��n�����������;�bZ^<�K
�WQ�9m�1�I����6Z�L8��nuݻRah:�p����E�n*P;��4p�(;&����<�M�:�<���iL&�8�h�m��৓|׻��t"�t�A��6-_, *���_�S�����7#i�\%&�H-�(�1J�d�"C�r����R�n��)��h��w��p�A{^�#�;RGi�M���1�xLT�����b�oqO���}��-UkD�LD�c%*L�9<oj{������g�Z�C�9lp2�,Jb�ϲ-%��"2�6��ဈ�đ�~hZ	��G:$�w�Cq|�}/�z���	)�:�L���<��4M="�c&��T�@1`�����5 �3����ti��K�Ԯ��LE��x�8Q�{�T��8*ד�r�`��I������
��[��8	9��
s3F6q��q�F��hµ���x��Q\?=�;�~���/�ﻇ�;.<"0�ڈ�sn0�4������� *Y�4NW��y�3_�����&��.���}�_w?q8����Sz|�np��7D*bn�T��!Z]U�7n;��<a;[�&%�'����$-�W�˖nm�Gb��X�� �N����3���Y�L��T9��$"��k�"e�@��4m���N�Eo�	�J�HO�	�/0��R�a�O�]?�뭣J�����tИ��	�*qM�J֦i�1��B2�Y���jy�ڴ��}/���$��v�rcֈ�ߢ�Mݎ��JR��pc�D\q*�}�?����z���A:���Q%��0N��z����X%�
LU�� ���v�y碪[��@F�m:m%�V��cϊ�h-�UҔ��%DZ�^�R\��y�|���^<!%9�sj`�aIR�1��@Tr%�愡����r�l��ʡ�Hݍu"+m#�1O7BT8(�F�q�����bCo��'8لqs
C�[.␓�J��G�5�������7[�A� �g�bp��/���-Y�K&(�w8zj�q�)Q���Y�v��M�&b��+��x�7�aꛬHQCb�1��WTk1&z��dfa�2�KM��y�`^I�z���5N��"�Ϙ�om"*lkSժ��������߻���������?<?����I3r�� #Z����1ߘCT�C&���7Ǖr�d�x��x�ڏc����B������;�m�@�,z3R8�d^,6=�����<RD���v]�Z�1�5e�.W����x����;8�/���O,����	�}1�_�v�������7�Ԗf�i�P�&��P��������m{L�0�k��4�֧���Y��3���3ܔ�GE .Qap��a�Ċ?��-/�����jo�*qb�c".�OTt�D�	�du>h�F���Ab�>~�3+�r�� �nQ'J�r6�N˛����0[�r�ϔ5�#�U�c���X�[���yZ^��.,p���5�ġ�w��d���$�{�5r���ȳO��a�Bvn?��p����޹�$a4��(]ǀ�\���%*\cIU��ġ� �v�?�[���,�w�s��U?תu��`�_��"�p�c�@��F8���#�Z�������{)~]"�;8ȯ���(�(eW�թ  �k��B;&�XC���ȑ��AZi<�_w��4c	h�[M����K@'*\z� M@��v�M�?�sx��yq�rDѾ�U5�oio�H�)jb�&O0s?/)�>C��F�CQ6��[.�۴��'c�<�ϱn�ZZ����	�<^�3�A�sD� i�#MK�`i�m�(UF�L�W��
��������/Hv��k��W�Fߩ����5:�����F��էnҘ���	NP�в:���8$F�±��f�o�����7��^%���!r/�ָc�q,Q�J�c��3��hdv$�'�p��ka�DK���$�L����˲��^��d3����]m�t
�3�(��1�׵�c�
F8��y�YU���� �����s�P���)6�!��3�F�Q9�w%5v���c"�MTX�w5�I^v7�u@�j��Lp��6}��8c��p]R����޵1b�� tU�ࢅW1�1g6U�^h[5p3������(��y�~��{|ɾ��������iB�I��� V��)B�Zs.�.�D%'�BW�>w]��E�v����ly�\�mo��v��^.�l�B4b�@p�|�?�I���p��_�8�M;&⮧D%�Xk��=�G˻�����ٗ�?��}gTLz�/2�I��e۶ƴc�7 (�J�&����pگ��#�w�����5�&��.W	7��5�m�D<$���-�G̈́;�[-?v�~��9�����TPWSsվ&歒1٬�39���ƃ�rwi$*Ƀ�n6�0_�?��g7~�v�m������� �O��Յ�g�YIi�!F�q)�k�c"��MT��:�_�&��@k2r*��S0�J�e-�D\"Q����i���C�=|��',�le̜%D����l�9��G�*y0�:L��QfE���s�ו�)���1x�9��D2/Q���p7�8J�<��0�y��r��ܽ8�"�v�+�C��^�pDS���LO�U��"ĪЄ��O�1A�f3���BTG��t頣����3n?F�z�F�y&��^D���i�@��n��b@�4�L�u�޶�I�3"�1&*!���=}=�[n������U�i�m��n�^"�nǺ�ZWc(W#�T�!�q��D�Cy�ʄ�t�MauWݴ�>�ƙ��p��y��	��#��NV���瀴��8&b0��
��Z!.�2�.ĸ����ӻ��ʄ~N�&��0"��.�Rfhd��/����(c�`d�ҍ���LL*{)|��n	x*�~�i�ú%r3F����iM�����pt*�6�c"�&*)*���P����{xr`H���o����?� ���r���#� ��� �9��w��^�?�?w���������W��u��P�Bz�Tj���e��c�7�W�
���*D���)֫�[�+�����3��x�q��T9'��6�BÈx~'���;��9�:���IVq�n�O�W$�R�cD<I'Q��)���)p�l��8�
f�I#    ����V.1 �Q+���c"f��
�'Z��T2(�8���$	��h\ʴMk�Do` b`i׃;㳛�>�5q��D� /�Il�C�?����8O6Q�
j-�G�~���ߚ��rX���k�wx�Z����lC*��_)QaWZ��\N�;u�2KE"�8:̈��klts�՘���"*,7�����v�$�rMU���Pc��`+GEo��
�#�an\T������:�w�X���ږ���Eo��*yO�&05�}���s��\�7NM����� ۬�<��\�U�	�KM�Q'�w_� ���d��),��Ki۶��D�fMT8�͉�J���%:��Ӳ5Xr��1"�v&*�AR�`:]���a�P�it2L��X���<g�Y[��U|}Q�	G?4Y��N2�Ќ���>ￃ��y���+���N>wMn�d���5vY7���%+��t�:t�ȚNK������Uu�g����c�q�
��3��9��R�V��X���bhK���͘�����������d��)��+D��-Ⱦt�bF�1���pg�K5�*\��@��V��Ŵ@U���q�����5&*L�JT��(و�i�S����FJ0�V'��?'�B��*�J3"��$*9��Y� �.h��{(ֻ{�� .�!Zr�4I�iɀ�c=M[�p��DoP��*\�Wi����c��D�l#��<���P0����]�����[3��>���ldc;&b�R��%�Z�����a�/���)��cA!M�q�+Q��,�w�tJ�b�rq�ܘ�\Q��������d̘����
��ľ�pU/����9��U�p�)�ɧ�g��kti�VY9&�N~���g�d4��[_��]p'7��4zO����K�?f<L<��q��D�ɗ���Y��'�����^8�ܿ0�⚆�o�ş?�����G�)#l��|�ז%�Y����KT��O�u�%�%�?g��d�BK�n&3Z�@������F�*�����t�U�N'J�a������ǭ|�w�2j���h�j?	^e3&�$�JV_m��*����[p�����2Y3BT�#��e��q9*q,�
GT	�@�F���q��};��wz_��焗ۥ-�f�#!)�櫩_��Tؖ�C�]��p�C3w+>:t����n�׎H�o�Ǘ�������9~{���X�ٽw����w��p��ع�����z�H7�r�{}�����XL:���8f ��v�o�_G�&Кڵc"��E�-3*���D%����
���Yl�����vd�������(5Ί���pk_s�$ѻ)�ד;L���vz�s� ��P�&�ŧ	�;�3L.|��Z�c"�w *|���)V�����qHU�71'�ԸZ�@�jU2J�u�h7��k2�(�~h�i�k,��Π���N�qt��iW�&�J�� 6%2Vi�����Q�K�m迸ۮ��g=��'�~���*��}��+/S����Pq��&�ҨK��r�t�Z+�^�����%�g
�>e�m�@b��1f��_EySU�6����Ȕ�5"�g2��v��d��/-��K��y�]N<C��c�P���U�ܠ�]�c�7�]�J�a��	�Ţ[��[^T�B_����>�-�%)�혈��$*L��/�Ӕ���mHX���b�C1~Fc
҃����'��i嘈�)R���ũ�v����,+�J5q���� 3e[cAdL�w4��AHu~��j����\B_��IΖ��ADI!��e0�W�@zLĿl���f��f�����7˅�O�Z��14��č��Y�&����M��k�3".둨�Ax�Z��]�/��.�ecN��K!�BbZ$��/Qa��%�$	w[�!���:�#M�H���b��Y�%`�D\� Q���1��%���v?^;2�.jJt���1�u�$Ze�]���盨0�	J��2ia���#]4�TC`W	�:ѥ��rJ�GD<���$dJ�ĺ'���uG��x`��ŉ�c"�^LTr:�
�°5<��c���3��}C�K�n}7�F�ܞd C.�D%{�p��L���^aGrxórY����]^!�ė�<�ԯP5����6�F��w9�JW���b����]O>w�D��P��粺���J+�D�?Q������~�ż[m� <�a��?%5	v2n�Z�e�e"&�IUr7oJ5�L\�|���6cu�ݺ&3�_6FR�72��
Qoe���>�P}C坧5}�zXǠu���-�&�!�K>�J5jTđ&*\�\�a$_A�A��aZ��I�ӎq�"�o#ȬiDk�D�E���+�)�]�����&T�|ASk#,l�Q��1�uKT23�
a�� �t;Ym�R	�=�pH�tW�RԖ��T�F�g��%?��&���p���Ćp\�����6͘�O$.��T�:���Xn�
vNnqν�\�C��kC #S2���� !|�L(��G58�V՟����p�S���C=5C
LX��O�����K/#���".���0D8X��e����[1�Q��>|%���T�Ѿ��D�� Q6\�T1�O������4m f�G7���M�vţah�<��(�h�Rn��q,z�d��%�&P�xK���u�l������(�g����c"�X%*��BZҰe��\�l���K	��D*��(�ƕ�\ļ�T%u�𕷦�W���_2{_;ܰ�&�4���2U�b�J8M����xQ^�$��7J�m�N�䈈'�#*,��z���>�'��8�~OLXǽ��c�IT8�IkTu~�u:�6�]��ҿpWj��1gO���@TIC��j�d6Yw}�;�l�<RU���E'�!�WS�n=7o�� �#-uΡ���e�NM5�}{������sw�/��o�_8�������}���C�W�8�7�A���,��)�4���E �ɪ� kJV�o�tT��E�?�OTB0��[I�����/�<��!���q{�\ �\jp|Ř��b�Y%m�ZÉs��U&���d��B��\���]�Nj��:rgcʺ�|-yD8���� �-4?���~�0A��������o*�hL	\; /�c�x,z���%p5���DA,�7��8fUV�M���mpݨ�O���Mc�Eِ������`�t5)�0�ܕ��C<pI�tR��
��
Q�=p�x����"��"�U?���/$�Ԕ�mH�j.�韈
��ƞ��ٞBD0�1��3O������SD$�y�W$zu9��Ë��`D���L#]��4���z_�F��"<���ؤѴ��y�F2V�$@%j��;�V�.�/�&�lb�5��`��#]ql�J�@m�%4���n�%<��S Ձ��5���0�M�t�o�b�cs5��P�
l��Mi���L��_���b<z���7-���zD��{�4��,�k��ehK��a�db!6�XWE�e��QvLĵ�$*��+#V���X]O>O��KcNs<�1to���V2���X�ODi�W�m:�$�L���|����`~�X[�1_!*)k!���f���Gp	�8�
����!ex�[]�4��@>[ �m�D<� Q���#�s�sp~��#�N�纀�:/��F\CR��YZ���R�����/�9^��7�At�Źf���/_�ݧI��jmM�t�B(��%���B��-��9M���!kF�s�9�Uc0�>&��d���琁�g�}����Z�E�� �F-�Jlg">l&*���U{I�}��W, �c���o[�_�1� �X�y�5��Z�t����!��箰�(��+�_e����p��"�LT��w�����t:�$��� ��p8"�`D�D��1HH�tp���2qߡ%\M�gj`�5|�&"��x=m�� X�p�Ss'�,ΓI?w�_�h]9�����<�1��sq��o�}=�1�EB�[Zហ�:}�����U�['�7�D��;�'Ŧqݜt4����r�����GE���n�;��%�8h���鶢�)���x�    Q�qZ7p�|{�v��S�'j���tn�rs-6Xf{bW�MTr��r]���:ҹ�
�d���z�9�㑿)=N�FY�%r��P�\���
C��چ;�?�������'�U��T��<S��0����'G�i���KѥhJ[c��荶�X%C�b�l�o�!WWW��ݯ�#f>�)+�L��:�$����͈�s���9W$3�����F~r�)`�*�"Mr��Al�PmSu�"�!;Q�s�H�bCr��%F���C�T�g�Z�PŦlp�^=&�kbD�C�¿*B��U\<L��*|R�um�c�7xyb���*���_l�62)�}O�:Z5Z�1��oC+N���n����m��)*�6Ǭ���[D�|��lk2k�qi�D%�[7��g~?���������q�z���m����{$@0�mx�����Ѷc"n�J�ŕ݄~Vؼ���z�����������B��G�)���qz1q��D�� �m�����������M\��7�\ݴJg�[$y#t�4�ȭ:C��B������<!8s1�2���X�_��'��yw;�^�˓ME*P�� e~)d+�	��5X�?f�����j�eD�;��b��`�Ӊ��ob�'u7QGMjیH8�j0�DL��e�����ý���!o>���V��B��9�@7薶I7­�Ve��D�|D��L�j������5Q	��L3�h[d��*K3��)V�2�����k��n^���X��1�#����~ν������z�ݘR[b�������gfn����;��{nG�M\O�e��ҫ��F=\20?�`h�jL8��L�n��ó~Bb��y*�љV�ϬR%h���L£�c�FSUC�vY�W{l�D�6�q���pcw��<���Zg��7��w0�#�>�LG�8��]�Fc�Z֦jGE|O1Q�=�x���8�]����W�&W>��g����T�'0�CQ����E�1W5HT�@uB�BP���3�YE>��Gg��U;&r�s����Dć�D%kz�QoCI统� ?����P[��	[癚CK.�ʓ���FxM�S"���	���$"X$����uKh�s��f�I��2�n��?�ax�������A�� �^+���O���ˆ���JT�^���ƴ�����|O"�����ЮI�1X4n�(��3���=%*������]�'�,W���6���
�NdY�M<���t<D%��t��%��⺟na���EO�-����.�q$˶X�5�hi��.�
�ŧ�
0�@"8�ȢX��d����W��04���4"Af��n����=�>,�:#����m��-ʵI�y�ڠ����K&���\��9,���b�ߎz�_Uȿ�jV>�f�k���^Ÿ��tJ��3�pZ��-a��TW���g����v��5�ܐ![)��(w����6�MLR9"q�dT ��n�A��f���l:�ޠx�-��cfir��=��bS0I`��E ���r�J���IAoy�G�X�!?�kO��O x�렂I
>���d�A5��$I;�g����f��2���r_-PrX���p����D�#gK}pRP�
�PM�	���jc�"����9&�尚ݞm�����u4���j��/��x�"�5F1~���uLs)���xLB:�����I�V����w̯�A;EÆ�q�6�S4*�^0���&m�\<Þ��U�����%��$��_�	|���� M=�2������ hب�`�>��%�g��Q�a�xo�����GX'���Sml|��y�B 5�Z���d�!w�Eȃc��*��i���UǓ`r��!m6��� Gb9҆����8�dk!%�@į۱o;m�&9�f.���UZ�S��(	ԲӜO�z��Qt�9[2����E�U��	;e~��I���ͤ�\*՜�d�G�"E���Z�����K6�)���3���4ˉ�O�`=�P��(�������%(���x��m�
#��/�0��4&1�мa��Fye����5%����%=8(cS��c5���n�[z7�x��F�/2$�F��s8�huW2ɅO�"!a�L�����C��f}�A��0g�rm���{�-�C7\l:C ��=v�ry�'{j��f��r�&���_�;[uεChp�U7�=6����."׎Uai�}��qSqd���i3i����Rr��J���5RJ5��z�_�׳-�5o+�P[q��sE�i9��i�b����'5�,�L2<�����������{�^��px��u�#T�n`����A���#��HG��#`��\;n���M5_��ӹgf/���B��i�)��4�c)��~M&���Շawu.�v�w��9�P��M�&T�\�y��*��s*�{B�c(dFAkǭٙ.�r�Dƒ��]d��G�LĎ�,N�1�����I\;>���M�|B��V3-��$��R�����6�	̖!͉�c�j�e�X$T��'�ɚX�(7�X$�"b��B<��}K��~~x��w��)e=���D[�5Eә>@�"���ޜ
�*$���&%h�T���)7I[%q��*�R�D`I���Lg�?.���|K(���A&����"��g�!�>u��dQǰ�k"+���a��/�x���́�>ʟX'��5�5J�Ƭ[�I�Y&.�Ճ���U�/�!�SHo���e\ԣn�Ə�bK��:[4eO7wɑ5-q��L1Q��q�t<���g�'l�4�nK&y�0��F�4F�s=R���'�Ѥ��_���L"7	O,u���Q�S��W{��"u��з���}��b%����S�#<�CR?=],WȉPm�S��<Bu�ߞG/>.��b<=��4r�u)�X3��Mb�n��%0��=ͯ˞n��:�	����ٹI�p���ẑ5sXNǉsUwLW�c����VYۖL�%s�j8a�T��}9��I6�NJ%IK�-��u%�\�d.bI�:gA������yD��_�:��>E �����3�d�:(�KV�e�|���T�[yy��oշ���1��/����ۏ����z#C�h��y�B�M�$��R�;�|����|�������t_�/�a(׶���T�R'-��t�tf
*v�Tv�4z7����u����$�+���I�Z76
���.RŹ�h�r����O�i�}��D�~%��IW�!�J&i%.��V�é��ݬ6��$�0��/�D�v@�$/����6l�@��a\W�d,�t���aץe�=3�5]�"�t��'V]�+<y��z.�����%� �[]�H�L��ᖆǒ%NTl��_߳��Dz}�=���p[Wẞ�!6&�LͲq�h��	�5�vu�1����Eh4��	5k=O�o6�jE�Sl�9�J>� p��0�H��I��1�l�A���9K2OO_�F����,��>W�VʫT������7ȘwI�"��	ؾ`�K챇Xa���NY�jYg��խQ}@;�M��d�6�'��[�����RY�_�~���M�K<��E�+�:�l\��M�w�"�q#
>(����L�Ь����P���۔LR*���D,������m���|�fV���l;\Mx�~m�ul�;�E��>��՚�I�J�K^"�"���G�v~=,�q֛a��̂�,u�3Ȁ�[�)���k]2��Њ]$ ,zD�m�k��ן����}x�;B��;F+kX����:$��.f|�&�������m�Ь	���z�����^�yN����g�u���&��!q�õ�������ͦ�/�rnNʎ�jLW�q����y*�1�t��Z�����e�5�8�6�:C8��6&�L��I\���#�� �aP�ĳ&aD�����=��i5N/��s�q��e�)l�v��&n&)�N\��`�B*!�@��=�W�))�:�z��}K��B"-g{�
i��{�/��/�ŏ�����RQ��)8�qXw%�T*J\$Z-���>H��Iüo�(o��d:ӷ�]��6���nh�9W�;����K�ә0,v���,N��D���*�N    �����f��XRn:��.y��b�����%zI>I�Z4`�=(W2�isɇ}pz��!tv,�GA�w���3Ĵ؛/�T�P�v�n��7�Lro����ylr�UrHQ/6�r�a6�=���\�bx�P�HuM�9�q�+s�������U�C�85�C���4ZG�w�_Q���Ӥ�m��3��播�9r�*��٤��m�P��8���L�4�&9(d.e�����H8	p������~��z4r?Y�e�m(\�� ��%�L�\��	�<2�����/$���FDj69�L�LSMg�M���oa�l'���([��l��g�R����w�B��Ѥ���Lɔ-<w��ݾ7a��$Or3ۮ��l�#@��|�>	�c�Sc��t���r��H&.y4�|`.�·�|[ՕgF�W*��c��,���+���5uI��F�[s�C�ȼ��lgp��� #J��E���h~��S>XG�I���l3ɠE��/�v�l�ٞ�]Ts�H�0ݷu��e�&I�\D$Jv����z*t�*�t����s���ʴ��ZIn���п����$&.�zq�J[������۷�j�x��sjEt�z[3����n'.�,?�℻�O�ƽ#+�?0���s�b���"<��#��j�W�#��a;�>\����-��?���d
:1�As�B��3#�y5N���.c� ���(#��M2{s�#��Ø|��D���~�-�#de굅2HaX���mE p��!s���6~n�֞��aG���J�m�Bd�0��Zͦ��z&����,g�P#��A8�q�`]���c�^�U}n�N$QMW2ɕ1�"�n��ԩ}�8�m͸�!�5�|�4	�`:C���	������סzy��.6DϨ�	`q+�Ӏ�A�d���INV4h6���]�C���=5���ϯ���U}�G��o8��O�����?�3}�*T�@ꨘw4�Ȱ��CDU�'X�P�z�ﷷo�2x��U�1�������s��u���BM��*�d�����N������i�Z}���ܫ��l�Z�OM�MiJ� �S�J�`�s1撝��h?R�.��c{����#��?���#�o��?_��=�aynr%�%Q
5ΓrәY��E
��������JҖ��R�ZKz;�U�Q0I-��ED�9�I��Z.!�]@�3l����򖕇� \f5�T���C�I�O\��j{�w����u�"i�v�In2�GXwGFG���8q͸�|˱���׫JM�X�"p��(A��C��1��9���T�E���۾/�����S7JkF!w��vO��p����~x}�7������=�ਦ@]��C�i���%��I�"cOt�=��g�b�A��qd4�[��h:;yrɏ<�l�����v�0[�j�yw��{�Meގ�8V���(��=��PɶIC]f�C]�a ��]�t�>|�GAl�w�ġiFvB<f��!Ʈd��N��@v��Ş��T?��gjQ�G!���	yPb�	٘��3ծ1�<_�.Qe���Y��դΥ]��[X0��;�"V� Յ�t����e4���ף�!:���zI\�v�����#��2�n���
���f8BW�|\i��H���}��&��J\������׸pY�#/���}ݾ�L�1c*x&�er�T����K���b]p�����㧧�;7���/]<���0�0��@d����$v�{�D?����5���;���{��z�4	�F^�"��[m�&�����gR됓.�qc��e���GL��.?�Qc#�b&y����#]XX:n��;3�eb �a��!Z�EKu�r�%���H\��YZG)c2s�)��A��!��iq"�d:�s�]d��(�4G��8'���U����O�'�\�X�J&�/���M|�6�F�'�@S('����7���Q3�Յl�$��x�m� �6�� �{L�1�k	8W��؞[�>��!t��������۠�V~�u�C�������fR���0�n���ݰ��M�U��鎵Y]PR%���a�K�I�UJ\�N�ó]����p=��#��j�Uz�X���.Ul��t�����$�K�|�-܅M}�w��0�os�s���s'Q�ď<�FwMs;�3S�K^&��)�
3��+lW���.&���"q؞t���lW2	��%O!�u.�*a�vp�S�:�\���t`��ϛ�I�&.��k��� ��,/<�/l����}&�=Ql\F� �n�3���%��$.��G|�����ŎG \�닏�L�n���h{��#��O�a����"�)���B�+���(q���Ax>�ry�
�����o��1.�).y�P$W��&�M�$e��K�Ė +}��o�"��q��(�C#�&���u\�93�X �"P�ս���"����$Rj��J�؂?v�Ӡ,�/���R�LF�\����u�g�Ű�·���J�-�[b#FAsV�`�M�nTX�P��gT�T^L\�7nP�C�J�R#��X��c��i�dp�ސz�☀�$�N��;������?IW��4��ç��,<&�(C=��:��%&�u����1��Z�#�˩� k����D�ӱ�Rn����Ej�+�uz��i�Lg�+���[��
�)-�#�X]��d�+��%_e/]s�-��b��v���b��|��Y��i��k�·�ө�d����Eh��N{���h�Pq��TWÿ,d%�`�+�dn撇��`B�hX��c���f�D�GV���I�vS�|Y(�l���td����\�����8��J&��\�H��7��ԥ��T����]�H��{�	�0s�M��������4�J
�I:�	���H�PM�O�Fx>����xHP��[� /T��]KM�M��$�G�(��C�l}9�^�u�n�)
|֍@��}��s�a}=T�Yu��z^@Sw1�9���� �7����d�3sɯ<���B6�o6�wWG� ���X��qy��{��Z$>�RޖLR�2qɻ�X��|Y��g��j���Oո�&f����}x
�3��< Є��b�va@@w���n��=c-y����IW�Lg	�U0h���!����Q�߿<��_�����p�1M����6�I�t\$.R����D)�X�+�u�H�h[��2�tS'.�K!��8m��K�HJ@����P1�k>���>���M2<����{889�7{%�9���v���2�Ng���Y��>:��n����I�J�]�$A����T�Mͦ ��V��k9D����@;�9���I�'.����;>����Hd*3>lOv����_sVZ2�;F�?p�t�+��ǜ��%�
�P9l��w��2b�ݷ�?
⟘�!�F�HB�\�m̭��dn�"r#@��ϱ|��fd�ժ�3��E6��T�$�+q�օ{�	����b��qf_�SE�����m:-�L�s�S���'��V�*(�Q� S�MוL2-s���C
 �!����O��g1�B*85Z�H��ig.RO̜`����4���A����Lr���H��r}=���Ԙ���kI�EsL,�kp�ؾd�8��h���{�T�J�uˣ�Ae=�bs�!���*v�T&�|vbh��Ĉfbޱ�I8�������bd�"#5N��=�`��l����js�Y̶��M���b�A2��}�(�Â4�U�,�8#�s�<f�\R���0&�~�{z�Y�<~��?�hB���k��$�G�2N�c��v$�&	����Ms[w���T>	��/�����?����Ƣkw~��\
a+\��S��&	����b����G�'�LC�z�`���ￍ�_�~�&��ݘ:�D��v��!�Xf2�\`.:��Cui���ί�I��Ib�*��S�w���j�]�"��c	����H,|�������(�ˡ�Ƶ}��5��" ���kJ&��M\����O��N���m{^ �Ye���À,�/��Y�Ϩ�DhsRлXΕ��t�&�2\]W���l��k�X�H0ɫc.��l    $h�v�U�/�[��?�\7���E>��U���IƖ1����pg��!�� <��dç`��l����	~�}_2Iif��A{x�}V����#����h.������w��D�I�FX`�jQ�I
�ib�6�n�����L��1L$ƗKyhn[Hm\L�DD꒝A(vx�'���X��	���9��-
@:��1On�穋�=�Ո�8~��ق��� �豜zJ�l���h��M�$�$.�Ǫ���V�g��Kå��x9Ԥ	�wV,�y�=�Yh�XF����W��Rƅ�R�y{�	���FŚ��If�a.y��c��Gn���wU��4���3����s�5����]�$��@�P;c���0f��0�������bf<�W��?h�b kzx�b�����p��I8hR����~J�Ao����N�I��<�?v^�j����kD�Z�4%�4C��H3d�::^�ī8����b�c�$�؉I�V4JiU,�#��
撟������濍ٝ6�V$?�Q����-<��g&�g.�1n��CZ���B�UJS�e$�5��]���d�B��%ω[���{�j�X����*t~|��3\�mcK&y�0��R�z��#抸���#�>��0^!�"}G�xFw�c"����C���o;�Χ����4���/���Nt��BřE���=�l
 ���n~��D�6��~o���Tx�m���Mr?��H�_�F
�����������:r�^D6�IY[~�~��W��E�qW2�xz�"mQU�	��Ӑ&0:#g]a�5�����.ad��0(�I$]�/o4^��ښ8y��&=�du�$'��El��n�z�����?�u� A�uv�p�u�n�vm�O��tvP��B$󧏣җ��68+�A�c��o��T�����I�蘋���#���1#��,���ڟ�<uD��՝����i�e�1�?�����<�{>��r��7������^�>+&���drI�"�K�ͭǳj����:��4�X(�3�"��������s��7`."���@u���1HV�AcTq��Π�%ә
_�"nxT&8����?��>�ܜ��w��}�Nz$<?=�Lҏ�"n��
�3���%o��j�g�!��y�p1��S����A���I"%.�~ҁ�0��QM���F`�Z_�χ�w���~��:n)$�~� �@/��8A��	$Z�6%�N\$�����Sbs�Y9��� r�&O�"���C�!�K3��n��$
�b���++��L���m�$Õ�K�iʾj}"F�����{�軞A�;[S��pV&�}�v�v/���K�̀�\�a]WS=�qÝ9�[s?�"Z�������د�H.�䷶9�j?i6ܻu�K&i�'.ª�n����r^Ȟ����J)��m�!�$DA⒣9qne�����	������?�~V�+ݛp*�w�I_�_�y�A9t�@��^��d��:�K��4t\��q^�pZ������2���WbC��8SחL� q�%�L�pᩃ��j?=�-5�j�̋��\$�3�Ys�x�`��cQnX�n�,{h�H ��������������&EX8��2]2I���E��FH{����.pP��,wg�5kP��~k���Z��VnR�� �� !.���v��H���wa:UCd��A�㚂E�2c)���ȇ3�S�nf���֎Z%p>�PM4���i���lgכ�m���ﰴ��;����n.�d�$s�3S����h��Z���Toࣞ����Ќ��Y<�G���;y8+��3E��EyPxn@�z���V�_���ٌ~f�a:��li�I�H�<>���j�v����k���pK@T	;��î"�<�Fk�K&	Ȓ��(MT�0�H�Ow�妺B��ݰ��W{;T�=E���I�������N.���T�$eS�K��qT�c2j���B�7'q�k8/��n>EJ�uL��K)�	Y��Pr��I�9%.�	n���t;��w<�:~���t�-f�-���,q� T�v��(p��V�C�{O�Ȫ׶)��Ě��0j!{��*Wp��<�Q9����T�QBib}��?Ʀ3$���t�b�3R��-?i=��n��Ӭ�j[�Z������8�ѣ�&	�����|��0'	��Dj)��瑶�8gN�N�$E���oF������� n>����5'BliP���I�n�)X���{S�
����2��l�_�2������D�Eu�8?�&�1*q�',E��v< ��\g���/g&�Z&����g��H#�Z�<�F|?b�t��	�w��p�>�A�LjK��p��i��d���%�BP���m�ڸ^�A����n��u��LҦM\$�1����p��Ë��{_^���Տ?~\���6&�b�T1�ʾw%���L\�6f��v��aK�����}�M�z��LPDۺ�IFn1��I�8Q��*�K7=L��P���L�Qx��໳�qےI~��E|�v|�,vhk���x7�}�!��!�+������)��PM`��lxG�=q
�%H��Nn�gO��8{�FZ��~5?��¢4�д8q��+����"�`�����ɩM��$�<�-N����S�3�+�f԰�P )�j�Y�ow^��4�^Q�m��@cY�7Q��QEܕLR�"qI�VHǉ�j����/��������ˤ�}%�����Vp������vxB���v��T�=���,����52beO�`�D�h͹�S�L��\r��M�����~�����Jz����;��F\_-�/ߟ>=�~9<Vj��CUe|�q��8==�\*�����r�L��\�?���1$_~�}�rT�N������=���z�?Iն*���%�7,���^������L���\����I�vN����ݗ���w�^��߯��}�	$�!����uTc}�S��Q%e
��I��	۔Lr]��d��Ɔ��Āo1K�n��?�?T/��x���:<��V��"Gp��ב"�}"���$ J�`ߎ�7s�ܰd.�H3���櫨b)���&���9d��VO�Cö%����,lj{B⭇-�4�P��!{��k�v/|iK�e�<��7�Zu�T`	>)�q���o"�A�ھ7ɴtb����%�=�LK��TA.�tB?=�~}��P���=z�r�����|B9�j�\�d�'��8�����>VOo�|�v�<�Ҩ&�=ZV�#���n�juB0��$���%��Y\i@�$Cl�9��/��a�)k�>�3KM_T��a(���3m��E����)�*�O*h��o8�r�4��N=���'F��I��*'
�X��)
���5�&����JFw���o3�{>6���m�$]t�����
�z�v4��sc0��s�;XY�jy22�����J��ۊ?2}���՜$��?��E��i+4,��s�m�u��d���K���rr�����i�}�GO����AڗLR57q����9UWv�wK,j�FeLL�)�%Z<]4��1YJn:ӗ�]���>!��S�t7���5�����.;�b��|G��2�^qƸ+�d�G�"�(�=P���S�I���4��Sh/3��]�"�`O|���9[�IH/���4� 4I(�7�)��_T#ҁ�MZ�j2�8/_0��`��0����x����A�%��]_2ɥ{�"��!U;���wg
��t�p�˂��4�h��\��p���u��;�v���ZP��B)GjkC.d�0\2�s���`0��d5loKЂ�)7i�&�*cU��`�3���E|�F�xw����M/����7<���c�H� �θUb���%ǐ"��Q��{{;%���Ax\sV��3�q��
���Bd⒯�G�a��=P����8�H	ȏMG�d��,�ȫ�8��C�~5���:�->�1W�PhF�d5A���`93 y�Uf�Co�&�5/
5Gؘ�
l�Lҷ��H5c�����?��A�ҧ'���-��>?�x���!A���A�}�C$a)X�����E	�!���B�Fڐ��z    :T{H�FZ���Ɍ)�O�����]$�%���%w��HJ���a�;^��x"j�.��J�����[������CחL��`�fX�\푂.ΰ.�4G�����a�!uI��K�#��nS"`�3��+Xd�m쑯Z�n�|rZ��OO�������߰�{L�ZlI#�(��r�P�H]�u�F"L�|��������(ځ@Y�I���!�H�$�#���rU�箷��x�� ���l��zf�����Ļ=7IȮ�%K���%h�}���Y��*��?`����`+T����3U
?G�\��Q�[0I�#��4��C
��l��Z�n�W�Ƨ�1b��YmrI��c���$W���ج6&L�d�->�7*A�lV��:?̦�en:S��]�Yeԋjç�IQ��z�����ϯ���'�rq��2�BX���}�X[2�C��%�) O�	�H���P����ؘ:6���6P��6�.�d�/�"
#�x��{El�$�� e�يDA���]�U�$��1��
�����R\~�lЭb��+T���+̵u��%���0��I�� ��;��#�f ,�e�H}�6�$��$u ��U�X�jO��ā`:��RM�C�Ӿ/X���{H� ����L��W-����e�v����:�v�s����ئ/X�$G��L.i�z�����xIC�4Zn㎻`���EX�P�A���zXTK�P�/�>�j��T�����P�M��I��1�c)l���<�O}<_8��]g\b�~�����U�X��Y4�y�8�y���ȍg��׀h�!�P���j�I�<H\�(ym��=���@Q\,i�Fq�`�f�C6�`��8�!EqH'�PЗ{�5�3�h ެ7���㝵a���Q⧄q��M�:6�13�3��%;Mp�X�v��Em������$X��W��8xGZs��L\�#��(��&!���v�~7�U����oӴ��(3��1����ܭ����W8��oXYh��a}�'$��*�Y��+�5l26�Zns�Q�g${� Yk�;�^�9���ٿ������(��>#)��7΢�&C��&�����1t��s&|6u<��>I�=�0u�;�z��I�3���D����D,=Q�j"���:��z7���$�`���%E�`�$�v����8��}��?��������g� ����&��k�x���9j�W_�_��8� 騛��0`'���ث��&�����_+h�d��~���c����R����\�R�bP2�h�r��Eȥ�Y�<����ul8d��G$���F;�����&N�r���1��`CW�b���7 s��'d��nf�f�
{*Īc�i5��.�եi?M͉f���.���j�"�)�����M��O�^ĉ���5���U�gh���++Hz�t��(am�$$S� �krnT�\����N��l���d����x⒏�,�ȑ�u��v:_z��p̰��ɩUt(v(д�o��U�*��Yi�
�g�yv4
O��g�F�ꉘ�@P�ME�p�$A����J�8ׯ�χ?���@e�X��{ÊQ��}���)��.YgQ0G���|XV�r�0by�|6	\����	��1R��$se2�+�9�D���YS�Ш-Q�/�.�Og��(1׉`֘�Hk��Is5̏��w��c�66h�F���D��6���Γ{�=TM��8<�n>��r�`&�����+��E��$-)q�����!��N�!b��:�H���Z:�E*p����11�.�g�n����V8���\x�hR�n�:���I�.��B��1|:8��`��v<����,`n��/�/�'�	5���?BF;R'�M�o4�Z^��8_"������d�r��E����
y�r�B����}0ﻘ���	��[<l3Ap�nJ&i����`� N�O���5�b�Y,�ٔS�%�)��4�co�`���EMAr%�/\��r��$}��%�Qn�t�*�|US���8�u��d��+���]�ڱa���X׮�B�T���ps!�D�$�s�L�\�~�l.�)�Ƞ52��>�Ǧ 	Ԅ�T]w�i�&!L]$�D�U��F�f�������d&]B�$��Ehd�_c�̤6�0�Cv�t�=�1K&�k�����麐R����ٶ��<
}�{����̀�=���b"����\M�&H�8a_jJ*��N�m��#BW��z� ���X�o�8�&P��.<�;1I�P�/��!��D1�~?��@?֭~�&��C����4Hn��ǖL2�sɳ&dkp'(��a1N�����{[�\a�#M��V�LBq(uɗ��	���!>=}��v��Ũ��%	u 22�z�t%ә�>v�6�A��nl ��4�j��Aa#����U	&�ې�H(6�CmwX���*�pnd�;�X�{��ڒ��N�"����������������H\?�;8l�$��S���ժ�HH���雌����Q 8�$��%�|�2��E#.
��8F��i"*���IT�$q�%.y��T��7�p�n�Ӭt����퐺 m�$�J3qVڎ�وc?j��ʛ²;i���v}�t�������@Q��}�t|�CŇQM��u7��K�3�۱K�i�Z���DB~vW��F��~	�5���*8��&M7aS2�m�"�U���3l���f�z��2ס�x�$�'����q�vŕ�~@��ݰ�R�%0La}�f����4qyU3G|���AZx ��XHE0I�7q���W�O���x3���O?�G*>�Ԅ�#�o�'i�4�P~�q�`b��C]!���ܯ��}��]�߿��{�A�����ˍ�O�&��k���ژ_0�g%s�+9�5,�V2�$�a;ɠ.��`)Mw�w]�$�&.¤ � j���%3��"��(�������&`�\D�1�0��b�n�uSo���s������)�\� W� Et1�ln�z����/WۖWZ�ݏ�s6^���oQ򮞦 �� �6%��IK\$𤲭���/�������|=�P�r���G�Bl\'��u�ڶ.��Bl⒟��/Uv9u�?�?Up�5�Ƈ�{7�;�;:��X�I�3�|O!�f|��l=R���:^MS�ݤv}k�&����u<E��kc�U��Վi�'oOZ��}�m�EOHNl����IF&3�q�c��dۆ�w�r32M#������~1&�fs��z*�.���i��{HC�Z�0j���T�����"��vEI%#�8�O #N`�D�ǱU�N'uo�,g��gn��鉋�N'�R|���ߎ��6���ԶCDW�Oߩ6�1��c.Rj��V���t^;��ȶ<ۖ��"�B�����p�;�4.��a�ϹI��2�+�a�E�`���6��s���atBޤ<h��=�W�X���a���(����~-�����w'uM��,S��*��s�+Dx�6�Q6'Ѳ��]Eڨ���)өI'K��Mr����Mc�c[j��+~��{�0Fl���#��,�ؒ�*(vI ��E�2I��}�;x���χ�7�/(f͒�8��ǡ���ؒIJ�����&��>��]��QE��k68W������I�v�.����u�]�2M�(J������pî?�����v�nѢ],W�}u�����c�Y���3խic��$��0�x����Xq�گ��v�˅_,=�lӔ ��΃�w�$S4ɐA�"@б�lO5���~vR�'t,$�d:��]�yu쉺�|�e B�d����'F&����dB��e�6E��3��H������Ȩ~���P��Mn"i�1���d���L�ϩ�T�$G|]�&y��H�e���w+�V��f����l��u�+�FL����Z�m1�'�/&���W����^��[bJ ��H�����B��d�*�K�F��s)~F�FId���`��Wtst8Bo]��`�E�ǉ=��N5a������[�������������z�#�{�zGQłR5r�(���ݘ��LM2v�ۻ��&v�����i:�    �'��h�1�j��I��%.B�n&�"�s��ؼ{��[}:NI�b�	,��N��R�`����|�Uj�IBw��E^�s���;��L���`W�Јp��dR��EbK�����"��#YS�G0��>�#M,���t�E�����4�#�*M������tA4%0(�Q�XQ37ɰ�"У`����N��^U|����{G1)�F?d'ﺘ1[0��	�]$�k�F�擞͘V�HfLk�O���[��E*rpa�T)k�p�Uu	_r~P�T�U"�ܤ�ѐ�h��ʘ�HU����4G�Oӗ>2���N Uk��*1ɵ,�"q�@��OJ��� J��L)9�G������ǐ��"n�C@�gs`[���¡6��׿Ϙ0�a�`?ed��Ji�w��d&�}2����\�)w��������7&v��kG��p��Wn���a>S�(�]\I�M�Hs�V�:���:�Ʀ3��E�{�9��e^��ö��|�\�_ S^�!)�N����,�r��*c.BH����8�����HK>R��2�w�����b�0���4���@d�$1sȫ��άC����ß�����O�9�VO�o��������g�m}�{|=<W�s��p�Z/��p�Y��I��2��{����z����=~(����喈�^�JcLOBq�M���t��,v�xj�������9�5���� |�?)�q%әi��%/6�x(&�A��Ř�.�2���ViIeo?�%�]�I.�2~[�����x�(�vh�pp>� K&�\�v(~v\���jX�sC�맧�v��/q�ǵq?P��#>\��Y�	4Ƅ��IΚ���5!�Y��w���3J������A��KFS@�-V����a�F���d�C2�Wq��ٞ��8Z�ƁC�s�D���֖Cpg�Vu��%��31w�q���t��U�O�����'�e��j��:!25�@0I��K~XTw�����_�?م��O�	\ݦŉ�$MgK&�����O{:M��9��4{��b�vF}����Qg�B�`�@��K�~�0伦~���nQ,<U���?���u�|��	1�uV'#�NK<}_4Iu��E
J�;�;��Vs��I�d]͓0��+�b�b4'��M�f.�^�q5*b��<SV��E����t��L� q���#f⎑B��~��k�YH���+�����{��������G[x�}'eOy��]�z�X�l�VŢ�IXc��b���]L��.���%�=MrCr�e�� u(�ħgn�n��%�tp�Y�F#���o������OX�ת��p��g\�G�!��n[N8���G��H��)��f���1��w��Zzv�}��{���tS2I�x�"��p���#{�~7���jX����WBm�(db�T`�l���]�����i��%=��0�x4��c?��x��(E�`t�D����)�����h�8�������_16gG�7�/�f��h9c�F�G����l��䒭GFGF(�RZ#,��0#��C?pkkpf�HinM�><���eh�-���CsxO�����mf�s��a���tÉ��ξ!5ԗK� �En����$� +��Y�ng��=vP�S��Lz�~�zW2I]��E���z�پݯ��܁3,\���s~2
n�I
	�
��1 ���^A�Ԋ5�X\�eAE��)LX]ݷ�Rn���<����T��P4)"܃��O���E�M῿��xGT��t�IO��&N�x�I��iR�O�*A�u5BIk�����I�L$.�	���k�	���v۹���jѱ�Y@<18��T�$A|���	��qZ���/L=�&�w��f��	�P���Q��1A#t��k'M�z^�JM�ɘ�H#�=n�1�ج���r��nF��Hf
I�HWdZ>!�D�@0��=���H�h9�n��Ew��.��n?n��%�cA�:E���b�8�*�9���K�O�|��6�M�re�#��'��:�L��J\��Q�(#ݼ�<�����(G�%{5���UP�(��&���iK&F�\�W������j�����;X�gk�ӹ\�q��v>=)xq(I�d����?��w���|����tSk6���%qf:k,���ū�.�^�ҩR����0X�L���d�����8�},/��1����Cc��,%�%KwS�6�+X��w�!�-ّ�����T�|a�Ŧ�j$�����+X�0+�Ȟ��3���=���L����MQ����k�ĭ��$u��I��!�����Q]ln7�#��n> {ږP�d��S�:�`�f��\�dO�^9ո�IZu�"��H���	v��j��
�R� ;�I�I4����]d^�$����Z�h��vl����w�6���8)�J&	睸�K;��u�;���[�2���b�~��~Q�?��JKG���mJ&����H��޻?�W�|rǀ�=З�um�#��)�ظE�Jӵ1W�`�B��E S����r<�K��`��1V�Ezu/8��[��X;�ͺ�H�L�7���{���oLD4��SO�J����Ő�,��4v�M�+���/qR���o��.fT`V7aDQū�c�U*���v�5�#��;sW��������������� �v�ą��>G�Ø�rC�vҷ���I�*�.�I�c��� ,�1����Ͱ?����TC��zh��`2�I�M��IAN_�t~1"���9Uח|2~��.����X�&m۪֕Lr��+��:N��^���~���l}!TkN~�[����.f��MR�=q�7�`�x�y�W���c����8�fy��Ʉ��Ⱥ��0��x�e�K���=">��g��@]:�����-��dps=a+���!U��H���fBҙ �bb�9�"��I��3��C�䧳��p���8�&��������m�en��P�K� !22�U�ŉ��kB%¾��)����.2��	Q/n}R��
˲xtbU�-���=c��هdwN�#�I�T�͐[�W����g���=�r��z�T���spq�J1�oc��M�F�"�o��b����|W}9<���	RR1HI���9{ƘDu�U2IM��%nuF&���|=�{���v��a\֞���e
��Q�CQ:o��d���K��-B����pu,�C�g�9y=ob�d#�<]Czi�w��_��$X��4�~M��7=���r���v1l�%<���؆�����N��~f����%�8p�Y�>�R�0�k���^��3�nY�E��+�d�)sѦv�~��Ѕ#L���6�<b�H�[�X����1���$wC����6���ow�AalP�C��G�+l�18����ݏ�$q5&.��!����࿀�n�~a�R�AGq�ɺ��%����E��CD��c?����,��q,*���;��غ���ۗ���qW�$����,a�N��~Ka�l;�K�WE ��_��'^�I���K&�BH\��R�G���@�"<P�M�z�)��*�k"�E9�t�oۢ�>v	� �lG�5^û�vx��Q�x������2��.�銇�F�7���dh�3�b�<T�	���y�����+kn*a������}�*ղ��'7�����4P,��T�c��z�Ԩ��ᦊ�C0���B��Vp�z���'0�8"��k�����d��"2�'+lܓ^W�v���F?��6���)�����b"��Uj�55/��"���>�֔LҫI\�"?��'�axl��&��YSC����+av(,��Zxrm�$av��Ia��O̯��*& ��Pٴպd���E������~�7�v~$q����˺�z� ��)���n�"�u!����p5\��±�D�Z��$_ݵ1oD6 ��f���&a�KLRf���H��F��A��!xY���Z,��8��r�1tu��%���M\򺄭����
Õj����X]�
�����v�鉦|�8���=���4��]�$}�����C���6�
�n(��>S�k'����    �-�f(�	��E�r���	�7�^g���;kk��m��"L|XM�S4I/;q�{�����+���H�7\o+������B�呂�_5��=�Iz#�Iζ�� 
@�S��Ώ�fЛ��^�C��^,��N�!�������n��Uixg,�4�<���F�-8�U2Ic{��0�� ��V�/���L+�	q��oҐ��三������&�v�[��5�P��qަm�p���t���a�O���2���-k�c�u�褵(�	g����$�����(�yl���n��B��V�BD1Kb+c�R�V��n��m�A�&y^��H�r����~�		��1⊔���������_4I���E���w�3�Y}�Ŵ���s��`��A��(�%&)5O\�ǅ�������':��ª���z�vM�"��{K"��@�����u�[��k��U}�;]4I7j����F�'Ÿ%Cb���q�'CҢ6�ë�Xt[0�Em�"���F*e�WX���{ݱ�X��];i�:agNMRs%q� JEi����<�D5�\J�F1*��6�1͙�$����{�,�.�	��ѓ/�TX��Q(V*?�r繸&�+�I���j��I��L���y�#n�v�p���[Z�6]��oZ�CF(,�ՎS�&���\r�CL,��0e���~c~Ֆu�����5^w}�$���%o|�gjuB��xIh�[��F��In�1��g���G3_^_鳣چ�\��tF��Q�*X�#9���B�[K:9^,cl�hJ/�@Z�]_���e��`���g���#s8��H�����&��\��o�N���I�ݬ���#�����[n']��ϒI�T�E���6ly�P�#�z�9�������ϑ��r��R�_yo+oi����ƚ6��f&y���H�B��>F���_`�?������zx<x9��q�F��hq�%6�cr��I�$�<��1�8��^��o7k�kUQ�U�4�^ܰ�X·С,�"dƩ����7q�C H.��2���Y�-;��9���Q%�<"�\�5�]`��Z�w3��������Z̖���ob�:e�Ig�t�}_��Yn ���4eԫތO�o���̵��4{�Mj������d�1y�%���)���j����m5��gk�ٷ��Cj��d����d����Z�Ӥ���lg����`~
��������������P�i���ǭV�V����،
�{�@���WאL�_P�q�T�PD�Mz�϶%�T�H\�2��6�Җ�ߏ�b*&\�O��pήk�ƕL���\��>�c�����C(ݾ�g�����wg�P��9��i5�5�5ӛ�Ez��#�ِp C�����8���6F[�b�LGuQă:W2���.2��� ?�0��~؎"a}aY�(�|��兩E���"��T�=�1���a�R')&Mݶq���Աb��պc��oְN%��q�$�����GzbW2I�|�"��}y�C���%RL���Ƿ����$� �[n��x�"��aq�:�?`Q�2~u��R��<��q'��h�zu��4�a��_��|���-vHȻ�4	�↢eMb6�n&��M�de�7��B���G�r*H��/|9ۅ��5+8D�������zq���)7���.���cw��	��؟����n�e���I��%.�+�[@Gxqb�v�Y��>�\�������J�f=��ұ���+�䋔�Hy_����=�t:��%�q1,7�oa���Wng�2�S~n�˔�&�Z�I��]L�����Z�"q���8-:!���H�n�~W�  gj�8.0q��m�t���5p��������S�V��j�+�jw%���S)���J���I��k��m�g[�}/����,�<��We����z��h��7�m��X�%r��1m!1j&
~v�x�%�˦���~�X�����@YD����Ϗ�|�������������?����T������@��������>������c�o���������P������3j��1R�}�J�V��U�7=7)���F�������>��X�+�������OX���������՗�����9V�!��@F53i�?�W��mQE��{����͖����^�����V�:��V����\�J��n˺�m�,��~�-.�BO��g�?�b؅8���5f�u�w%���'.pҲЉ��owCu���,JX���j����Eә��%�p���C�:���'��l��w� ��^���`Xm��P�D:�q!�Ic�	�n3�}��`,�P�7�(�	'��������i�KO�b��6�YS2	qi�"���la�٘}��}Ǚ`R��z�=�Zm_2�p�"�8�Tmh�c'�H䠢u��sT��?m�
®d�f'��?C"�(��E���d��m��q5��Z�d9��F��1��#������[���_������P]��|�������׻7g�pj�Z�-�����k�Lr��\�Vc�fL,p��g�s�%YoVs��R���1���@~����%�I&�`.Z���+��̐Ni�A���t����C�$���j4�f�Vd+�����In�2��3�O�4ad�+�|�����)����݂�դ��P�s]2ɼ�%��C�	��T�b�I:Jb����q���6x)x3���3r�\j�=�u9X�Ho㕻������`�W����`��چdh�X-�����䇵�U�N�1��gQ�CqQ����k�����bP�S��I.�3�4G8��V'�':��Q�������	�:��I�X��BX�<��C+pB4Y�>�~��ҕ3o�5��Tϸ�q�Bc�ŧj\�y�+ ����!V���蠵�"\�5ƔLҡ���7�<pޟ���)	:�Z�j�nqԦ�8��k[E5��Ӧd�G��Kt��v�1Mz������T�Dc�%��a���m��zb:�	�]r��LHق��HM���L�=��S�S�h�<�����{�۱h�n����U�d���t�UM|��&�̞����z}��PC�|�Kt��,�J�3��E�i�F���c���Ң< R8/Xy23)aQ����B�x\�u*�T7�v�]��]�٬ T�'�7Q�W0I�2q�{b����p���9C����?�^����;������%�y������z����|-��Y��Z��u�w	J11ɛ���}>kt$ag�%㣀�}Ў����U��D1,���^B������������l���v3T�aد�R�("�%������K&i�2q�Q
$k���_�Oo���/�o�_Ϥ��b�Tw�@0��&�U�t&��]�I�K���c��ݿ>��Φ����vv�5�L�p�7ɘi�i�u'�k�$Mp%.9Za��0��
�vJ�2;bz�x����Ԑ,n��&i�3q����K�i*o7oo��fu�DB�?�8�t5�D�icU&a�L��`�[W��g�$�1q��f��oL��+�XS�t]�$�rә�4v�?�Zq��e�~��w�&��瓊1���E5��������$=��%��vjF:�7-Qt�7l`"q\_�vs�����zV�������y����J&�����|LƄ"1��
�dC�D6��ވD2u]�X�L2l����H/�0п��9��� <���c
��jZ�u�I:x�|Y���s5��ǧU3�P
,r$ڬ&=���-���6q��E��cK�v>l9��� �b�j٨(�Îh��v�d:3I���$�y4�ѕ� �Y1�7Ԗm���+uX)�H���.���,u�&p�Xs)p�,!cF��&f4�H?Q��
l�v1=]n�H?������G���nf[����"����pE4��= 1�_0�	spE��S�����!"9���s*^OO�� ���`cI�L2!s����ϒ�<�+qV�56�N�;��Q�����I��0�c������t��7ûw�-���@{>�n�D    I����C��ᗹI��'.I�RSCt�7�ˏÔ
�����5��KR�6�`��B�6��Έok������f��m�8e�R �xPU�NZ�l<q���s[<H�y*�(c}F� �9H'}S�J��I&�`.i�H;\�^M����XY��������<�%9�c(_2ɣ��%?�Qs�q�����#&k�bz_���E�\Fg.�F�X=�T�G$�l;��^1:NQ�)�s�Z�MR����>T����>V��c$J����������I^'s�������R��Y�S ����bn:��]d���$E��H��ب3�)�b�n���mJ&�2a.R2�Mo�P�žng+�G�V3<�(���"��a!6mk6��$�H�"�E��	%�����r��������V�4����@����t�~r���6�c���L�H-#�ZP��-*�,��Bʂabaw���f�B�_�m����AtDc�Z�L2A*s��M3jx�Q�&,K��Y��==���mL_2���.y���5�9ase�<:�bX��d����7��b,�ͣ0\\x�M2�s��F[w����f�%,3�6�>+k�"�#�K��`�՗LB:��s�u�G���K{��0��������-��L�$s2�1��Qed��I�=�4���k�3(,��Cf�IL\�AA����_�����?���h�,��X�R5�ZH�S2I�u�"��5��QR��A��%�f��l1����815m��QH0eö�K�V�	Q�Ғ%^u���@��4���<�lB푘�P��.Y��@��������4LX����ț~�Xm�6�/��^B�J
_�����ϚI!pH��9e��I����O��c��Z��_�q1�~�#���"v������I*I%.���l�<~��y�BP��/�W�wO_�'��aM<�E4&�����������|_�����^;9�i��I3fa��)�j��1�kn�Ύ�%������Ct�v��ĳ&Ւ];i,����L2Ԓ�H��
��c�N�k����	s���~cڋ?���=a�3�37�Y�F�LR�1q�X����C�Gg�Lv�r�ڬ�����v������� �f��&y{2��Ȁ�E�b�I#!N&���Ï������ϷQ�0��I_���*�drN�"Г��	B�*^i�R�$�դ��mM�$U�|k������`󩨸A>���&r0�Iʗ�|5$5�N%?����/���:��󾢿'D�],'߱����j'm��E��yJ\򠦫,���K�971Ph��c�s0��~���nt�$w��F7#���d?��<�}��
�֤�T��9S2I�u�"�ְ\s�=V��(o��`��\\xfH;�W��Q�S%�TTH\r��:F���}��e�G.Kj�#`yOS�t���h��2�G��s��OZ|3m�$���K~~�C��~�]���^��jG�����3�P��]��w��^�I��3	�k���s������X��T�+�3�#�~b�{kJ&�A&.:�vF׬��7���rv���q�(�7XL�M?q�<W2I�/q��釜/a�0�6δA4�9�V�i;�K&����9n�{��b��v�%�+�Ȼ������B���mPF71�Q��8|4�W���$�r���q�<���!b��޻���&�qZ�H
z���%��e.�$p��S�y���9%����%U+��1�I�*Q� BĀ�4���2K�dy�A��QZsA��E!b,9k!��!G�Z�ΰ�.2k���ώ�����f3�uaI�Ɯ�4ݳ��`����P߽݁�}��j;��-�T�>q������띟6T��$#��I���^�MW2��K撯�U���D�/8n���Câ]�?'�U0T}є���%�v�G���d��_��w�$R�����,[_���-����*����.9 �Խ�8�t?�b�x'�z�p�~ج7���Ӕb��|��Q:Nj�LR�kf:3��H�{�u�Z��,)�䣦���X�4�.u�af{�j��3%��N\���9��|��}Dq�CR�K�$)���q&�L2����ݜtq���;I�:>�3iE��ǾOߨ�I��3���o�ML:��{�����rn$�&���u����f.%(dd���"F�c٧�hh��0�d�+1�)�.�bl\+�a>�=X̶אi��L=|�|r5��a�o?H
9 [��X;N�=k��N\i�.��5s��q�N�����#���$�F�Z��ۘ�ͽ�(2��,�5u�4q,��$�Y�>hė�&�����A:Ǆ�|���c�[������Z�ci�s�t�s�<���5�z�L ���b�I���8.��)�(c�RO\�5m�$#�%G+ �KL��q��V�N�~�=���'������^({�/�9gu�"cbi�E?C�i�q�~�^�a"��3�V'��]<D����b�/�����Z����b���EG�rȽ4�u%�ԢK\$.O���@���3��j?��<�S�GO���<�&�N�\�:�!�t{�m��"�|k㉎�"]��C"u�����os�	�ngW���n�����[y\��/6њMLr�����W�{xp�e���Y��u��"-}�넼aR��I��|Ә�I&�c.m�ңF�z�}�?�=�l�.�b�-��jH:S2�pe��N�V�.;�����-����~�Ay�&b8I�a5|A�Ng��Iz����G.�cK�8�F�c4祷�.�M����
�����!蒎��X���
~sW�X�r�������`JY�}o�&������^�娕5P�H���������#�P�$������ 	2I>�MgJб�X��H۟oK�Ď�B]o�`˦%����m؄S��ji��V��Mg�qc�|�ӏ�;�l������lMX�����+Xq+fd��-mJ5��u�d��_�K�o�5.BN���pI"�$W���x��F��.2p0�pf����[����>�=���߇��*��w��aC[��xY-8Nt��'K��f�g�Inu2a�)�NW��5�eN����l�x�
cp��iP�B$�6�S���-��!@X��r*���3?�=����u<\[Gsg�I���.�Ƨ��0�q?J���!�5i��Oc�$�؉��E	F�P�x����4�Xk�k�&]k�A����Zc��`R$�z�R�K���q�:]���-X��,��7����^ih��M%>�Iʐ��f�[U�H-%�!~��$mF���.�ۤ�h��$#�sD��ڼ>��!bi�n���a�|5L�a�2�6/f��
r�tZ�En��9X̐ z ���>��Du
�0�0�_����O(p[��m�dw4j{�ڒI�8������s���b㹶�'!q�#�O��
!�u�1j��X���d������H�8|�����zz������H��M{��\2�NT��x�%7���]���OSR�5Y�쉙[$
��6qLrW����2>��y�P���tx������߇��p����YtO��= o��d����E���y
�'��/�ږ��5�0B�K&	���dt�p#�]���ߟ5��"z�wO��~Z)6�-M��OE��lj46���]�Ѻ�g>N�,�~\�a�}�0>z9��<M����Ra�M�?9z��I��&.�-�jV��尪��$C�Aa����5�����Shl�+��G�@���k�QG$ܥ@в-��Hi⫴���@�L2����S�������8�,�g֯���U}Û�Ţ� ����r)��%%b$� �Z�믙�G���et����R�f:"<�m9�	(Ux��.��
_�^� u%��໴�Kji�I��%.�NќH��U?N�Փk�
[.��u�L򚘋�&�������*3��U4����|&�$@�Ed�2��X��� ��L'D��\;�k��v�$}��T}��a��.�=,    zy�h�v(���e��JԱqo7X��~��6۬f67=�	���B�b�F����w�(M�;\���CH���ؾhًU�����A� �Π c�l�96A��O�p��ò�B=s�᩾��Q�^GJ �E�	s�dM��	W��&�t�~�៖u�i%�'���vV�8�m�$=��%��L����KŘQ��a�ή��S�3j6���f�B[hwXb��?��ĺ��nk�|�"f:�D]D0)����J�i��XI�a/�֎�MrZ�\Ĵ��r�~�%7L�9�_"�â
/�I�~L\�e�U�#��ȥ�$�q�|.�/sq��v)!�-�֚)�,��\��-��!��/r;�$��~e��Oۘ2���""7�Ǝl�&�u���Q3X�ŉS&9`.�Sk���ˈ�Sq�=�6)��3WVụ�Mr%���&�K��t����|�dӴSꥇ�iwKWOYd}��C��)u�IS�U�cUMV�a�X��$F�-��$� ���U�`yŶ�ͺ�F�'�35��܆�lC$�[��ȱ�L4y�{P���2:��X��|��u�UY���M�垸�+�6W�}��o���~GG@�������[�k�ڪ��2	`��%_#�0�@��٫���|��K}��P��ת�\���X�R8�����$�%��B�f}6φ������8��Ɣ_�n���<aR���������YmT"a�3o�~in��A�E�*ہϿ�/7��<=cL��t���̥KݖURHHL2����i	�zMTx7#�_�⼢'��-��v�$}B�K�Ac�\�q�n�9�G�%5Ow�������� ���DSS\7�
�R:D3����C�C�J?����uw�:� �ߎ�?(�����������2�Q�dGl:���Ux�GnX���?�D��W8�����FѶϕ���)qsrә ;v�-�N�]��;�S�w/�������G����t+F4�Bx���{��2�'+sɉ��<��ׇ�ZSű��)j��=k�@o�LR�<qɫ5HiTL��<�̘�j�=*��H�� ^i��2I�*q�o��Ηn��g���嚠��PW�d7�$W���IC�� ��K�CvgJN�c���5�rT�1͔IXW�"���S���/��&�G�xVD���.��õ�Pb:K�]�eb:*D\^^r��3,�V1��1u����Q\�/5	���%GN6�А��:������:���,D��YMbS&Im1qɿ����,�SV4�%�a�*[�VɅ	���7�S&i��KNj�UH2�
]�w{��9�U����1!ư� �t�#B�n��a��IN��KN7�P���`1/����7�`iB��g�g��V�����-ǺP�~^�ŷ*��r~�P�-������[m�����������C�&Y����15*�~Ab��?@��F"&!A-	rڒ����y*�-�Uk�
&I�'q�Vm|�����\�
�\���=�<��pDEJʅ���s���)�L�e.")W�!�L�GPɯ��}�N.�bCHkF�L2Ä���G������޿>�I$}��w��OH�8��G���}|x{�8�&���-���ϥAͧ)�TJ\�����j�Rl��^`m�&Ƴ�WV�Kc�ʦ���X0Im��%��(�lBP�9�a�K��8�X��_?�$�$�D�"��!�mTuJ���
U�0f�]��6�$wؘ��V�|{s����g=_���Yv7��OX;����<A�F�4a�AE�G�Q�����'.^���q��PAu��ۏ�'���JAW�q�ssd�WHO�!<pv�$�橋���-��!�!�uF�=�U�?n��B��T.obڽf�.�ȏW�4Qx�$5 ��֥P4�n���~�� ��~�ہ�][�9	���˰�%�?S&��\�QC%#��0�HH�D�e�L�����tf�$�#1A���C|��Mw���ᶿY����+���5{�BT]*?����N�䨚��Q5U!��&f￲�4&İ�;�U�r���%.�h���۳�ܭ/o3�ثW[�m
d,�]��{�CHqm<�X0e{!w�+�%�c ?�<��?�=O���p_����������SM>�4�j�L��I���g�L*���f���.���^�ŹIj[$.�V2N:�p����5�̐%���S��Ѿ8�*�il�v5��F�6l�{n����B�(L�>����_�z!ਊy�,w�9C�$���Y�T�#���u��������7?��v�C�w�@�J�B��q��V���b{`��úLkl���q�<���?�!V�V^�����׷��Y���¾oM_(V� �pN�ՔIz��K�j���ցp3�ݝ�'�v�q�Z1�3�[Ƴܳ_�a܋���7S&��H\�_�e�� l9��k}�����Եn�h���h���CxR��>�C������o$�*�섡^��	��LX�Ӊ{�I}�m̒AK�½�E�X��t�����L��R�Z���u�ԔI��RA]_mh�=@�6�b����ęb����q���l���������S�3��/�'�5��uR4CE-�]��~�&�5H0s�L*�nWI�91�As�1s�8U�{1~#�ܸ,+'�ь��>�x��`�a�"qӔ+ͩ�1fϙi�)t&|d �,\���&���|05��Xv��&�ኅ��n&M�I��&��s�D�q�a�����b������yK��}*"�73�TO���P�V�%ُ>I��W7�~Ċ�X`.�כ�"�).�4��!����ۅם�{��,4����T����I�H\�]�����j����|�i{*6���(0��g�*U���M2���dR0��a̷���.7��ȥ��W��1eշ-���O-�_��2�A�.�f@@�N����i�XL��WW�6N���MI�=���b�������&
�$5x�"�sQW1W0I���%���Ǧ-	k���s�w�w����E��u��r�s,������{<�x��8���iZ0��@d��2xk� i�e�3�L��=��$���~��{��\?�""��=�^GJ���K����UM�$��E>RN��aI�,�4Q�Cֳ�jE�Y��Z%M��$���E��R���V���I�h�x|�{;i26�|V,2��;�Z7R�D�t�$.yd�gıV�n����7��A&_��ڒ������U��,+3VD����%?�j��:�6���b{[\ͯ�Kn;�-�ռ������o�Uq�2���(�� �K���$֑�bp{�'1���[P�g�\�<[v�7��Xߒ�ξ��+6��j|�n�$�v���W`�.�'��y���d	��1=�!��n�57I�F�"�cb���h��a��G�|]l���&�V�8������!�j�j�$��%�ぬ�q-����q�b��ϐ����"C��I�I�&.�"qnF9������D�'d(4&+vT�pv��aP���2���]D8�jC�n��N����k�)�����������2I��EB��F���n������B$���%�i�)9�.�xꪊ�g&��\9�z,+���Jh$�)��U��	�����3]=���D$/�6jX�ϟT���۬����Pb���G�����c��b�<t��5�◽�V�lS�̷�n=_�^��c�`,M"�n��դIFR0I��,+{J6)��/��kq� 6���*j�D�����!ʾTS&�蟸Heo�e�Һ,=ޘ&��筐ۃ�ߺ�\;e���%�uU85�1|���v�h�#�����e�
�L���
�b]%`M����!��q�g
rʚ ��)�/�o#��ws��y$����kZ�ճ
r�6�}3��f._S�a��/��d#�J��(J�6���
��%C �&y�2�<RA�ok�]��l�R��x׌@+80:�����KW��P�X����U��fҤ��0u9��4ӷR��§���©�ᦟ� 㽜og3X��T�nّ�I���V���q,7I�[�    �,��E1Y����!����V٘����ם��1<03�"�_.Adxx��?�z:��dΜ�&j������xj�"*�9�NEȥ�(ƶ�tpsbbM,כqcL�	�me�LR�.qh�%��O�(�@�"� �J�	(1�Ul�])���y���h��H�tD�cw�����m���K?."{���DO�	B��vS&)hN\��Q~:Tewx��	����JD4��y��ClB��a�3�I�c���2���]2hB�]��=4,P������z�����?ƙ�:&��Z��^YΈ@<a�
��C���0��t8(Rj���-�_6����D��64$E)�)��b.��N�����g��[��+��w��C�ɨ��PM���x��W,���ݮ�v_6�����p^G�� Ӛ4�ݬ��-'M�.H\r�*JrԻn�o��x�H��R0 Ӎ-͔I*�$.ByG�n6����)~y^l.��n��@A����&l��tF�"v��.ڀ�
��M����`EK�V�m�-96�YW쒣��ƶ��1&^��'�3Q�L��W*;�S���-`�WQC���r�PK]�J:�|ֺ�D��ybπ�34<`GT:�<�����IT�7H�s�H�6A
f;��!y��m�>�*�1��h�ûgMW��2��h�"���&rJ�!���Jҟ ���*��zST:)O�h�CG6� -i+��q$��s_s�*y�"�+�A�%���=��l\4{��J􆴨Y�M��)�T;O\r�*
�A����H�d�.A�ʠj��ն��I��3Q�����'���-K�{�T'�z�����-�M��2ɱs�6/���V4b�P;�o^b����� ��������!X��v2l�"�3W��5m<�"���CG��Pub�.�ew=���x�vƗ%�=$A����r��I.�1�/K��/
z)$��Z1R�(G762� �hU�BJL)quZ����~M��W��}��͊F|�g�L=3���5d�q�Z0�$Y�"r�!�:��=�?��2�MW���/sָ�3���AX�� D����l�bɘ�W����ʊe�v�$���K�a_�Z�����DGnq6�p��4u��[�(�s҃/��-�x�Df����G~:"�oGH"pA���������$��b��;Vmc�R�q`��m=a��4�#��*<SB��Z����3 b��a����~ �4��t|��&��X/�B�,6�ѱ��Q��z�$ܮv�$�&�K;�H�������#�}���l�]��q80P�YU7$����@�)�������.�2q�."��r�B�è�nY�c�a=3��NM��H �.y�����8خ^��^ۘ6?B?��T'��4	���%{��,[��iY��6��Ɓ@~/��K\�;�jf��N�䛍��)���ڎ��~���c�R��.Z�rC[��TO�$fj�"<9��� oC�+�%⸶�}~HϮ���23�ͻ�U��m3e�b��E�0�!,�Xv$4 苫�@I@�H�B�Uშ`�ج�����N.r��%JO�4�^�+y���T�V��QbH��"'RO�d��"j�@�5&˫N�(ѱԣ���P�Ŵ��$+(2QA����H�Kyr��hpDmS�r�L�c.yg��JEm��cA���Ǚy��l;� ;�x�;UVS&�<����5E���]̗��r'᭺e��3���ͬ��`�;#�E�(;*�l����}/�G\�Bg�OE�=Cq�%&)�J\��'Vy4������fX��ˡ���\e��G�L���Ka��5�2Vn��%_u߲���U�b7���U�Y��'Js���H�8M��s�(��$Q����_���a�D��IB6J������x��"�޸G�֠閥?�i��I������a�v�+���y�1�;:�DDL\$�?��Cy�*�L�|��4<WH-gN"���5�G�ݐ��� �MJh�gkZ;a�Pc��JS�%B�|l8�+���FiΛ�����)r�S�i�(����#2�8�6P)Y�٨���9�#�0A��]�1Y����4p�#3s.�&����͞��OwO��������_�_��_����H�ܞ����9u\\��gTc��8�褹I
������ t��p�72�F����]l�����{aT���#Te�5�vՄE&����xe3^tX��3���E/20�P�*�c������bʙIƔ3S��>�5ï�;�3^�q�#�h�ت� ���Lg��K�0���/�FN��E������C_m�| ���FQf6.(7eZ�����AQ��z��-�����=�?�?o���ԯ��'R���tmk���2�)��.r�ͨS�Ǿg�����ؒ�<�7��gSO�$Pq�"�<��j��|���o�8�M�1M��v�릝6�i0s�n�q�ͬ��r1GFvB�\j�Q<IgX���U\M��D$q��5�_����x��|��zO�,�/*��3F� �T���Ȫ�T��I��4H\��VEh(�tO��q*���`�Bc��D�k2�Mg�D���+Câ��x��_��߿���8�q|��6���bq���W)�L�δic�<(@��R�zΗ�Ӭ��q:|/~y&�كǸ�qFR`��&�Y���{!����2�i��.^Ǟ�P���t���;+�eLd���q��3s�r��2I���%]�)q��޿�_��M�������߿��߱��a�n����Ge��~���ӯ�����WLJE�1�G$���_f���#?e��M���ۏ���.2_Pv10<�T���
G��x/��2sɊ�ߕ����f���Y�)����Q5Z��&���\����0�-�e�7+)k��[W�������ӽo�7%<�%��m��Pqv�G������z�6�3݊�l\zq^�&�%�~��������������/��iBUs^m�T���
�l�w%ĩ�l�,�����p(�\@%>��|�u��8p�%���h�}
�6Xƙ2ID�"�h��u�0!>���}'��f�*D'M2p����>�c6��t���آ|�4{
�b\�JGDO��VU�+�&�j�\�fg��F8�>w��}M�����޿S5���u�q&%E$pY=�D�&Y����DCTa��/f��M�&��ڹ<��6��g��8Yc�����t�6��^ƃ9?���x읍�R�D26Y&3H�d���HuuX�ۢ��#Mn��*6�@�1�,�J�S��w�M�)�Y���"I%j�M��j�bt4�:�#�#��K�@FI.K���D��C�\�2f!��}�Nmж��W!g�;ç�e&�'.�K��p��!��J.���#
�7�S�L�O�p��Y]��
���$��!�"�N��/�����Y!���t�)۪)���D���5�F���5�~����ױfg��&M)�0�nm<0"7��<�"���m�0��l�o�?���جo����p��%�8��M�&Q�w=m�T���Qme̾$�M�����N��O���MG��'7/�[D�4�(�#g{˖xU��I�������*�Ca���q���`9&��h�8������@մl`kj���YٔmY�e2��� ���P����������mF֐h�����d`�P [t��a.��h���k�RA0�0m��$���%�/m�غd��u��;�B�cd��P�u��H�ݬ@H����|��D�{j���4��h�]d��ʜ2����r�!�Z:4����r�5
[�t�[=a��ⱇH���/�x/���` ��!���`���T��dh"s�DZ;�2�)��Ϟ�ߎ�Ï�o�o�������ĵ���N���&�'��e��%g���M;2�_���S_Tpt1�/M׼t����S&!]K]�t��%̫��_����.���<L���_�T
፮ڶNA��t�'���Ɯ�+�z�DM�"*��D��B�L�Z6r�f�$�H�K~�Dc�cfxr�˯��<)� �#`�,VK*��sgB+��    i,�|q&n�&�N�\�H�
�z�å��м�\R���^׺L�rf��r撯FE� *f�9&C,G������2�8J�"1�kr�v�)J�c��� ����4�i��.r+�G�r��o0����c��<w۞�QK�����#�ѸpX5MӚ	�АI<$a�.F�K�+�{ʮ�,���f��+:j���s��֨�Ra`�$��Ed����j�}�5M�Ќ+�{+��g��m��Lrg���-�
��CU��|�]̑TI�������V[6�(7I�C�"� QZdL�1M�K��z��G�mf���)���a."�G�p��N��[�+f)��:��+ݔI��1�g-�����4;�V$�������Z�%`���:f��&��&.��56c��].�9��kT�]�W���|�yu	��1�8A�3)Q�@98ݪ)� J]$T1�zDÕ��E�T��e�j�$�v����1r��kP����U�*ԹƎ�,�N�)R��6\�(�Ȩ��C(����n��_��v����"L����e*7e����E��f�� ������9J�w�y���0S&���%�<��O(���/�A_q�h(��_\.a��P�hkW;7e�@i��$��T�Ā!����lh�zUU14Z0	ai�"���B�0�_��fw�@��q�h��hN�/dB�X�I��I]�M�O�	��n�﯇�o��k��vN7�g,��M���\�ϵ*�M�o�կ�π�,�jSEХ�\�D�)��xGn� ͉� hV����|��s�����0�;�I�Y�g�D�Ɣ�L���W���ʣG�m_�:>�������l���M�e�mU�	&8�\�e"r�T#U��ӽ�j�Au�cq���+���ƙ�߆��D�*�d�gb�O�"�64&�5^�ØO8���3��b�A�������5(Iǧ$D�S/*Wc��5(�4e�3�c�P�n@�S���
~�>`����E��՛��TzVC�Z�)���'.�Voh���C����W#��"����φJ����wn�L1'qХ�U�!޾?����Rk�W���s
)�����2��4��`c	RX�A����J����N�]��|UMY��{�Qٺf]���u�کRq�J��1�P3�BE�E*�([����mx�ݛ���`:HݤI��K~o֤�Z\��nWH˸=l���e㣒�ݏ8�X�XW��Τ���t��Ά�������{�0*�?_���o?��<?�n��(�_��c��b���gY�� 2*&M���\r�3!qC�2�KYU�@l2_���ewٟ�:�6���nHM�_�I
��!�SV�
�]��j.�۽W�+�=�f��=D`:�*U�I��$.�:!���t��Nx��sJ�z�?7ר	�i����>+8��j\mJ5e:Sp�]䂳O������q�+$Y���M�v`&��\$�7���x�Ŋ��6Ta���Z�<�Z�M�=�=H���[�u��ϝO�`{Z�AdS����d�7撗�H*$t�Q���\/�H�O�I�|܁!N7�Me#�`�h��K.7 oq!��]c�5$����fCd<�>��P�vbK:`]�lPzn��d�"mIc�j	��<��ޢ� ��UD.�]�b���]�tG�#��w��0�ֺ�1i{�"ɺ&ݿ	��Mڠ�{!T�۠OǷ� ~�K���� ���$)hUHE�x�,'Mg�bYA��������c���b6�ύjܔI�T���;Qn��u�[��Ll�ඨ,�ꞛ�o=u�/sCe�Ph���y��US��tK�k�L�.q�q����t��__��N�n��Θ��5��ԶixO/5�=w�"���.؉�1�.���N~��v��
 w�ò�s�mܔI�2&.�a�lt���Q��Q���I�<�fV���D����d�v�"��G^^B��:l�'_K?1��@�6e��x���D+9l65��J�E �+��|,���ޞ!��X#���{,F�O�k3e���E�"�Sհ������X�'%�b�D#ӥ��n�)� QK]$�o��h���|���e��)2�B��*�i��d&>�\Dd�҇ͷy�}��,;�m���e�,6e�"��%?��]������=BV�̷=B╟�C�*�Yq�3SW�x���}�\����ڡܾ����<���]���,��:�k5&�g���BJ�R�aY�G�8c?x�.;����	���E�g�$����!�AJaz�����	��l*l�i���r�mñщE�Br���A�*C��bv��m��4��T�����$`mL<�T`���H�����d1s�څb�_� ��ӈ��|\��>����41�=���͊<2v+�f5!kM���^�|�����%�A���n����	���R�~�����X�?=�=�����U�ٰC���-U1���$#z�K��A�^3��#�w����i��v���3(���Rn�	�(9�PQ5j��&9b.�'!�1�
�e��N-��\�K�%�D��Zb�O��Rb���m���٪��8��Ȣ��_���q����)���K�/.��S�z|FAq�C,�^����H����6��L����լ�����I�mH\��u��/�_�2�U��͊&�U3];cܔI:�)ഺǞ_��u����e�F	n�xx8G��
�7K�j�bJ�If�1��fuy
�BJ
D~���rr���f(=Ƥ�2��^�"��4��ٷ���C��#�^ ������t���w�i\�h:��] �B)�*�IQ"|����8�F���Uu�6S&���\��&�	���o�2Q�G�r`i�6���2I���%}�4� [ħ�ZÃP�f��
�6��v�ĳ�똛�X��h����g�����IB%.y���!}^��ͷ;?�����D]� W�3�2�Z��M<�)7�,�]dŲ� �Ջ�z=���P$��flV����L��y3e�$&�<W�U�NXD\h���~,b����i`�dk�8�zf9^���,�9�E5LO�)�I�t0㩾�&�K��L�T�f�$�L����Y*W�s`�թ�|�-�o(�8>A6���B@��2ɲ9�E�ͱ��jc�� Ҥ{���K5sNWS&)O\��1$�Ah�>o�tJ��5��dt�#�(ILg�W�"�d4��z�ɬ�E<�G�ֽ�L�̨�*'�e����jÕ�S��R�"�������C�u��rQ��\���ӡ�x����������z~�c��u�Ly7q��kiJ�0X�[|Ӳm'�!�H[��N�IBd.�>�f�W�;,���|~"1gS�hHs�)Y�/7���]DSU퀌=/�ij��KT���pg�$�OLR��+��r>m�R
Jž<�KB#�
�\�e=e�����:�q�^:���2��AtT�tC3{����u���z�s�z�'(+&�����xn�n"�wi��ml4��Xv�d�?CU9���6S&���\���DA�j����σQS}I�c��¡��Lg�baaX������ȑ�4>�:⸕8�rf�4�){y�K�����t� h����I�O�� �}��N�G8�~;b����y�q_<}�~Ğ���ϗ����Ϊb������!@a*�7�o63�Զ�S&�@M\$
�r����Q�Ё��W�Pα1S&�V�\8w�p����y�#�:)�O��~;�t�CN���h��u2�#3I���%�������a~���T5�e ��8e���E��S�[#_d(�5&>�YC��aSR��5u���$���%o�?��K�Że������M��on��SSs ,<�!b��n�L��\�3\9���?��I���Z�����u��Mi��$�ؙ�T�-m����'�T��B0���v�I�'.ғk�j�����~�ōl G|�k�j*�h��vғ&	5���!5F)6��1�����?��M��Lre���m_�Q�-�n5_F���aβ����ueܔN��ih��}t�i�&����-j��kQ���Ɇ����U��M@    Ƚz��g5!ǦL�)��H�&m��a����'bS<�"����xy�.#�ET���f��5��D��͛pS�a����}�CT9M�i�������������<C����8ΰ��T9�25Iة�%_6^�.�,p@��O��.�ׂڿ�\q��&f�,u]O�$�i�7�઄������%��9�T���s����Ӗ�����m�L2�����e0���;�vS�p��M�w\%:F���6{�lB�{}ׯ6W����mb8T�X��Ԗ����XK]��Z��Fv��#@���f�Ɣ�����1D���tFu!v�hyZף��u�Ͼ�r[힧�/�1^/i0Q*E�%8�-G��&�rJ\$Q*�*���~/�Y���⸱f%#g$Y1&"���)q�?�0������K�tZ!��c�J{l��38zm]O�db-s�a��J����/aWb�ŧv~�ZGcd��� ��;�L�S�LkX�Ԅ�-%N956��r�ԧN\�ЩQ�_���j1��0�(j�wN�x@��2I�]�"w�ؒ��^ο���m�����E��ED&%j�C�Ä]�K[��)D��O\�MѨmK�"��'��$1������É����C������wڭ"�~?��Qq%7Ir���Э"����s����4��[,�4J7U�P5��O!v/�L4��07u�v�������
"���ǻ�H�����5�T�
5q�Jׄ r��։�Tլ&U�xѹq�gfk�SL�fW�?���̶H�`
��k���`�Ґ�j�Lg��K��6%�����O��j�T�~X0�T=��O�?����ߩ�[@�Ѯ�,��?�х+K��U|fg>�coD��*��$&	e��Hh�)|Bk�̷p`w�.�L�0����SI�(�����$v��~��aǲ�R׳�
�ET�ĭ��t^��"+��؁���9Q/fq�n+���Qm�I\j$�f�"mm�!��%�������U���@�h��ڪX�$���(R�ZĮNX$�݁(��h���
"�����������C�x�^�$�	�_VS&�9��mz��Xva_t��"Ⱦc���n��a����[���߳鏖@�p㺶��Թ)۲�K���՚/y�ADFw�S�3��8�aǓ��Ԉ˭�I��3(vɏ'�����o����>��9������;~�qR��gOcʍ�.g�:lj�$�����w%Ƙڭ���9~��؏Ռc��A%B+0`�j�$ſ�K�B�	}\I�YN�O)�� ���ҙD�61ɤY�"�f�;��w��7D�W��V�S�Y8QF�e��X 7I���E ��R�f'Q]7���7�`��PHԷt�D����~��ſD*J鈩�B�dU��&&�WJ\dQ�6l�p��ۯ�o7�e�%|�3~�YF�b!|�J�S&�����'���f�cw�%����v�R�셬����U��Ǿ5�N�z���IL�".-��J��)ľn� � Q�����C=��㷻�UZJ�Z�@�,O1��E.��b;�A� �[����wu��@�ho~W�CҶ��H'0��`8~�)��C�l�!�!��D�w�Nn���S�fcu�Ly����ʩ����bAy���������#6 ��B$	I��x�
.X�9�r{�M��O\�珝�1c����!F�o���p���nZ�n��x��𬆓���ț&������CG���翐�s�v,����7�5�Z��|��ҦI�q˙FZ�!"|Ue�&����_Ԩ@&��pM<����j�"�b�Ak�t�
~n���p/�7���\�v����S�{��t5k�Ze!3�qs�y*ᫀ����������Զ�������P�1�>��@�n-���r�$����V����6���:
<��vXY�I��;үdxXI#��b���$Ę��C���QqhΊ�^
1^ͬ,]�&M��s��ʆ�`Lhg����f	���{ᣢ$��{9�.�J��j��uf��/�#`8Sv����VuVy�nx��ى���kuZ�I�̎`.y�ő�p9���"ϫe��TH�Mw3�,��\��@i[�
�B/���7��<oe�{?�����S&!oM]��}c+^b���uW�?���:��H�:!�T'�v��QU�r��	&.b'� �Ƃ��]wX�S�(�>H]�#.�>��/bQ�v��MZ�MLR+q��X-�D� /c�n`�0F660<��^e32�I�����#��fŘbR����=����G�[�%*���㖛d�7s�:vH�$��}���k�+gW�QmC�1�N|k~�;|�ՙ�$P[⒭e�mh�����,��<�&�#KB��+W炀���_쒿b�9��ޯP�gE{P���}�v�D�j�L�$Ո�%���vm{�u���|}yX��]�T�o�K�Wx�y�XմS&�I\���@Y�U#�Y��ȏ �$nҬ�Lc'M2�����OX%/�Sc���KVM�50j�k_ǖ3��C�z�����W��4w����C¥$>�����j�&)�H\��ġ�S�<���F~!E�D_e�b��}�b�7e���E"#P�\����0���t�8;͒����	�O�d	撯�F�Zx��ڂ2HT�`z/>y356�it<�=7ɩs�F�@j��\�b��u�1�"���¦˖��Mg����ܨx����I��xx\6�«���*����S��f��H�����(�W���+�`��1H>�'���"��#8���~o/o��b����cY�A;-��S92|�~fxe�M1��$��� GF!i#�	!�'�W��F��\� ^8�m�w�rk)r�$� v������������/h�؈�(������m�)�,K�\DY2�3ցx	h��/I���2Q�HtV�ht�$W���X���'Z�[��sku%o�Ƃǔ^���q�SS7S&�L��� ��76*�^m�ю��*NGG8)��ꪲi4�Lr4�\^:�zS'^z�'�AX��G9Xa��y�)������c�\�ܶ�yq{b,3�rk�d����B��2��r�.9d�\.�z�{��2�K�����)�dƑ,r��4L4ɀ撋�� i5L���/�J)t�/��{o����m�4gŵ�ҙ��A�&��O��*s�o)�)5�l\�����Y�+g]���L�s� �g��?�uG����wuϲ��������'Mg�����U����� ]Fhf��1nP�p����|�:K�,B���M��t&��]࠵&��>�������s����Q淭Y�4�fpF��ڪ�j�$EI��%!�qd�Q%R	,K�:�)]��)әP<v��Z7���V8>o�D����|�i���f�4,���M�NX�zS�!��8g;�3�R�n}��CJ8��M�Ad]O�"�ȷU2�/1�	s���u��{ny�&!�%��ͩX�"����Gj�k+���Iz�������?�O/7�|�����3���!������~��q$ž(�aIE5NM-�
;��I�0%.y�kP8l�o������w�p~?>�Oh��2N�e[!%�[C�5|���=f�y��%��!o�	����a����&��m�-i*��#A㼏\cIG�֪�&MRA#q�Z�����.[�Lډcg���P&^����CV�N������Q�)�_�5�|1�������~���ߏ?f���e!g���0!�(����Lg��K�=��.7����*�7(>0�A�]�
��8��Mr�\�<R��-��x��ŷ��w��h���_�|ϯG���N6�|�\�� ��S	_���bә~O�"�0U������P�w+�߃g�A���pS�[�9�3k�+�)�D%.y*I��t)|��(�u{�V�W�[���2�.mb.�P���j֢x��2�Ysk��U����~��y�/�$O��[�J+~:/��I�90��[A8���y�広來�x%Bq-�����Z���@2 ��	#�0
���B#2�_�')Kkէr־Qo�(��)��9I\�o    ��Co���;|&�Ǥg7�EuűL|��Ƭ�ڙE�Z;e���%�@��"�Ҫ�y����P����4L�n�W�lf�̜4IGx⒯b���á�B���]W|9,��h�ZP>srDL��I*�I^$s�d�p���9A|���-�&V��_��2�%�3�B���-d�^��㷣������oG�m�o�$/���SC-{�������B�eM����L��e1qYf�u��k�f��2jrY(ϫf���tU��L�y�k��+�R�%;�Cr�ߧ���NB��t����'r���.������ƛ����Cԣ��3��Mr߉���C8�N��ݲ����hh�7X��+�7k���L½��HwD��ŗ�徣9�~�u���r��}A�s�x�_n�9 �E��2������0l�0��^�5(c�Wn�Ʊ�E�6���+惡6�A�a�H�ye�ĩxP5�ӌݰ�REYŁRn��щK�8�T�bڋ�� �d�B*�D8�Yil�3�,��\D!$5��08�#(5��$r�1��#&!��%&�4��Hre���.3N{�k.Փ�U�V��t3e��*�Eb�h5HӝD�w}q1��/��Y�;��<V(��3^E'��M\��MR�?q��ʴڄ�ɲ[�����D�a>����ur;C��Z���/)wɿ$'��M(�yjr��|�Ѫ��L���\ĝg���2�da���E>1!H!��u�ĝ��$�����p�P��`�Ǉח����8�u|"�l�r�i�\�QbwV��j͔I�a.���
ԁ���O7��5GPqM��f��QH4I_o�cp\�@���zD�!(��R;��L�e�-�۫�|n�0�)�����O҂-c�L����Y���\��o�c��ך����-�NT4j��S&�8������F7��G��%>�}q�:UG2��CT�rW1�%7��A�E8`���Vz=[`�Pӌ!g��n�i+3e:�]d�V�ھ���h��l�5;3St�%�p]9�"�&��\��ù�����1��l:(#����c�I
��|Wz��)`���\��ó�!�q�n���$���AI��&�0�\�d.���%���G��A.P�߮��b(^)e��k��E
�G���*2ħ9f���f?_"f;�
'��7��e�5i���%���<|���n���]�x��y+,���+��Wǣ�rә2O�"tEK8��i*E��|�L<�z҄ad��ח��D!i�T흙��'.�ʵ��6�
��>J�F��Ӥ%�$��Li�4��Kj�I*�&.y8i1u�o//8������'�Տ�7~���ģ$�d�/�OaUT�7���>w�W�׻v��E��2l�W\����c���$}O�K�հ�h�[i�o/��oǧ�A(���lfT��I�F����MRT����S�^,�;t;D��k����q�9�NW)��d�'s�y��y�X�'���&8���x����u�Mrh�\���a₇2Ua��߇	z;����<#C�8v�;R���X�5e���%?�
n�M�C�/��AZޥ�p�����r�$u�	�1�ϋ���,N�S����fjl��U�L����\��y�'�v{H����K�U\Xe�Ҽ�����䰙2I�z�?H��m���ަ��bm��4M����AF�E"��1�˺Xxɿ&$1m�L���:q� M��n(^������x������p2�_����{�<+.ދG?�����T���x:�1��M|�4P?މ���s�Le.T�F�r��v��q�Y:"�`�Bl���t�iZ����i�Xl^2�
, UӦL2Q���B�[�{�����
y>�	yʭ�&����"�2���E���6� ��]�9�4��U>DW%U��DvfT��,�v�H�6*��r�?ҹ�O�o����w�q�����	n�ǋ�=S��;'��H��L۪�i�&�울�O��<@���@B�劋��[���'Afϲ� |�Ք��s�]�E�v���Z���]"���@�DN��W_��B
!A����i�eQq�(��TS&����g��1#�=������A�UW��I�`.���IP����W�����B��I'6�6*3�3�p$��oP����>�(��R�R*{~��W8����]�)�tR%.�B-/~[n��'��b�v7'=jO���:�@�48��-�0Ѧf��$5�����& 3/f��ivY4�̔gv�d#����b��R��%B&�J��ڭ�I�J�԰����u50D��7�K�Xܜu��/�7�}���𢗛/\!w.�^����K��Cѭ᷼8t�����/���£�&�6�����d$�w7���T��MRK6qɉ�ȟ�ՠ�w}{8M8���}�9�/h��ܤI�O3�>�ܠ~���я�J��)oi~,�D�QlQf����K��6l�t�uj�!dw"��8WB2��J���tFX/v��{��a�Mm���Lg2Tp\�cP�N"��V���bu��$w���I�(�\a��!ӛ�)��[��Ow8�PU*R�M�坸H�|Ŭ���W�� Qz���}���j�@JĩK5�(��r�LJd.")�|���~;|�u�
�C�Q�չI�T�I\$�0��×D�v_6'��QO�.ղ,����j�$�f�Ex�X	KMD� ����|����!�:�,��-�v�+�I�tO&.yL�/m�/��h��������UC���������	_��lu��/�A'�SQf^�Xo3�A�͔I�!�|�[vUh����nP�Q<�O&���x%δS�3���%��`��H��٪ۮ�b����A|�I"E�g��(\j��J� Ub3��b.y�[��kdyqX91f1/4����������6�������p�ЗCw*��Iu�]a9b�8p�¥�����9��f�3N5£�Bb=e��s�"���9��-�n[�Hl�@���S�~���
��2IiⒷ�Hr[���;x�D��R�6����b�k~�q�H:ߺ���)��`e.y���rl~/z�y��)l��8;���L$F��뻞�֪�2I�]�"H� pD�V�24�|������@��:5���r�O�fcZr�����5����j{���觝(6�Lh9k�g(�M�ˌ-r�9�������������/����ח��k� >��mjT}q׬
�RS���S&�@���t��>����N_6�U��'!sԧ��lٰo��$|���JW��P0I=��E�I�gC��3=!���N4������F�X>�����[bi$���vn�_�����/f���|��
|x{�i�r�_+��s�.��̔IZk�"�'���b�����͵�n���*W���	�q�q_쎿���^�9��� 3��-mW|s�2c."��H2�T��1fژ��K'��_b����Yf�Hl:n�.��Eц�B���A�����;cucH�bB�F3�v\�45�A��.h��z�f���-̲��u�sL;ńӤ���T�bi�$3m��ȴ�C�
�y���t�hC8����%�x�:W�hkt�&,�W�=}�Ҕe�U^�v�ݶ�|��v���#L���U�F�e���AX���T����Ⱗ/�?�e:P��g�K�k̘jkm>�16I�M⒯��c��wq��w��m'�{|(�Q���NX$R����T�[�/{$c*�6F�J�6:MB$��_�L2�����F��8���z2�&#D3���Q�THk�xrȭ�J��nn�~�"�������_O�psCS��W�����X��2�5s�s%D�a�����m֟6��fN��T�HA6�n'MR������B=��螏OC�4�#����M4���
�4ͫ����$�}������~�n���$�p�z�l)&�2>�M�O�]\�U,!���
.��g�1.��v�M�?l��>U$c-ì"�Q��L��k3e�    yS�E�H���v�[ܞ����?qF�%���Uu���2��O�%ߗ5��1�'���8�Cٸ��ʍ'���[�2�'[�*���&A�$uɋ~8�h�$�`�Aq\YF
O�HΔ�n����30��E��q���l��s
��<�)I���9U���2Ie�"�?��=��?��?{Qo��P/MS�o>�P1�� 2�Nn�w��Έ~�.�rʄ�ݹ�u��:Y��b��ˣI�~�N]�������.�IYz i޴�S�V�m�+5���2��A�"�����4�cqF ���<�|si1'$K%�J�L�-WRGU����Z=e����� �V��6�qD�`[����h��\ϒ����zʔ]=�K�DT�-��uN���s��������	I�2��?7e��$�ED�`��q\�a¹�4[�i)���_��n"���d�s�L�LW�q�N_� &��,�\l�X�'7�"��E 0��P��w���Y����a5kL��r��I�0�cz�B�*#Ǵm9f�������MW�L��J\$���2&�X!F�[��J��3W\�`93�(�$~L��.&��&��\$Pb��`M!~�M��-��5�^�څ��XR/6� �����IV�`.�څi�(#
��Te��P����Lg"��E��"��CS�1/��b��O�WT5�,�@��]�D�z�"�����R׮���l혎S����fkTq��<7I�B⒯�D��-苍Ee m⩑��(n�\�f�"�L�#�}�Bf���=��W�@t�ݏ�aG�����x�@6������1l�Jn����%�^�Sa���Cw��Co/�UG
�+�N| d���-M�',2�2��JM%BQ���@E��w?���}6�P��7��K��Zb��g���?�9*T��)�([�>�a<���9{V;�x�a�.ѺM� 3�{���3U:�O�*�R��룈��o��g�pW�vϯ~ �G��������gƓ>�zV��fH�|��a�L�a�\$5(T�:U�/��]G��B���1�������������KT$�E�dr�|�H�.��b�Í�j�\�6��UC>��l�IF�0���OcG}���-.:�����+.�K/�W�U�L����G*��3��$��ER;�p��c�f����c�d�:<���f1��~tM󼚊�ԩE��b���BY�ʎ��ư-�a�\Ꮓۦ�2���.<H�ċ$}A.��K4�e Lg9������Д,��5e��%�K�X�FTaJ����b��� ��~���W:�%��(=3�e��r�Y՝�EVݩL�������x�{��l�A�� ?]��nU�&&�&����H�M�>q���#lX''9&�_����hk�j�$:�E8)(1BQ>�<�%^WycO���&8>
��2�ۚԄ�Y�)GL'h�W���揻#zx}:>#�'t�l�_rek��)ә'��O�E%v���B�\�"b��i�b�Gt骲��L�J�����Ƙ�������S�'hH|��1����x�E�`6*o��-M�~����q��I*o%.Ry�����~��#o��aps]ϗ��k�:�ðR>+k	X��4���@�t�[��P��fų��כ�~��X�o��贈���M��_R����sՔIF�3�_���x�ubbwXl`�DS,��V����q����"��>��d���(ȈB^����-[��c|=i ��6ob�jO�K��!�]ئ(J9�.{?b�&�����Mq��m���yؤ����W���_|,���P?ΐ�?���
��Pl����ތk�YA҆NLUWe�rLRA2q�
��|�����v�p�jV�:ФI�;K]��@V�Y�^�.�(��R#��4ȇ�,r�5����!s꯺���7��|���%,��Ր���r�� b.R�Gk��Qu�%h�0���p3[W�M;e����%�X@�q�ߺ@ь�Zz`jb��ş<�ĳ��˦5� un����Eз���;S�V.�d���]P$Z5�MYd<i�!�N�6�J�W�]��d���B\Y�Q�)�&x�"0>J��mw�ݠ +�q]YO���{�q|�����M:���A�ńE�������?ή�[�5�s	 ���[޾�@�oH��7�Q���VMڐf&�!�\Ć4���ӧ�%jH�/��4Q>��ip`P�?�E
3e�������T���0ڙi��L���:�rRVuL/�M��sɑ�kB��;���������O)>�!��o�����-�^�m�ɹ�͔I�7�K�hCC���u�}��!N;_�X���т#�bX#	Bͬ�q�:�jL�G���5 �[��_���Ju�� ���'��.�h<���α�Tf���%��pNh0�%}�o����t3�(���q v��Y�Ԟ#�,ʭ�X��>�O������Ίx������a>�3d[��/L�i��H�t����}���p��O� >S߉�
A|�I��',g�w"Yy�X����;T�'0J���ot�7�m�6&�
+&�- �ߠŽAr�=��l�]�m��	"�[ φثaj]�I�����i�_�����xƣu"?��`x��Fń��$����h�c�D%���8SSN��Nc&�m��H�	l$��Q�f�\RI2셭Q�)L��d� sNqʅsu h�)�oR��*%LW=���Gl�)����EVJ���y�y���>t�dn���3�{��ߎO�$k�0	gҖ��un���92:���BuD��F&X|O�Ɏ��d�����0�˾��1�p�on��q]�>Y>�Ya����m�Ӫ�L�'���WH��A��Ǜ�%.vu�o8�S�33\=��s+����2I;4q�p�N�Qx{�t
.-<�Zw\o]Υ�q���5�Y;e:�q]$�*,^��~7����
X��5o��s�2܀繹v�"�b�$TR	7�497P. �ũXCɺ�Ɵ��n���C�+<Q�՘)��C�\DB=2����|�S���O8�߆X��2�TB�_ό�_+�bәh(v�R	WV�� ����҈|
��nb���)I��:[�4\f&9*f."*��f�N�ױ�W��j,�*~��9i�v?�m�LR���D
��^>�f��pn�Z����dz*������5U��R��a�|iK���k��_�(e�eɋK��T���I�~S&9�d.}��zX\v�.������kju�ak*7a�"t��+�H��fJ0��(�e��I0�I�'.�o���8�t��G֬j(�ā��F1�`��U����58ʏݼ��f狴uG��	T��b�I4�A0I�s�"�=���`�O� �h��p��DRii���եe��$}D��bi��*��Э!88��v�e�_$��F0�'8k���A��I��(����(g-D1.7���"���7�ﴅ��P����������h�Xț�_�oC��8JvT�x�/�V�w�w�H-���@l���.�UP�4G��*c�
��7VO��k,qH�JA��
���:<bl��U,���^a)�t��Z��m�&A%(uD�� Xx�SŜ���Y�M+���A��[��i�2��y�2*П�ݶǆ麊��i�o���ڎE3�tF.v�/x�α�%1ل:?�	s�x�:;Y�0[��9۶&;�cә�?v�OV�l]��.��	g^t�/�r��(�L<��o1�1�p�F���2fҔ-<w�?���TTn,NB�ÍU��\A2��c�N4�I��0QAú�|� M���_4;(pU�t �F-��.��2IZ���E0�)\up��?Q~�>�_!���y	����'k�6��{�զ�UAr�TM\�,�Y
����<I��kT�Q��2I���E�*6�}qѝ�>�:$���B,��LR���H�C�!�L�Ç>t9E��#Y��@a�U3��@�?��|v�f&��L]$(�S�s�mW�B�}�����Q��V�E�c�i� �
��IR��Aᜩ�~�|��J��R��bS�����yX�S8�[����:��    E�#p�ލ}t~���~���}�u1��J����tL�1B��m[�!��e��L�7v���MסD���������g�h���Pܼ�����b��v||y��>���ۏ�_��^~�=��_���T___�Z�g�c[ÅQ4ټ���2I%��%�aD�3�b�8A��U���IV�a.�r���~�#� 2���q�l�2@;3Î�N+J�t����D�������a5�F���iS&y5�E\���@������Z9.�����%_�e��F*��k@y$��ee�\n�����P6�u��k#I�*�d��irV���B���v*jC^;3�s���`.";Υ�>@���"�K��8\�I����ŁV^���/3O�i�V��H�_�&th$��I&r�m.I�.��|�Y{jD�8�,þ[\E�꺞4����.փxO��$^�b�8�lX9���ȹ�g�k��M��n?s��M�#8|�ⰾܬ7�=���}��`��L��>�a��L�.su1T�E}EMgX�_s���ت��`��ۀ�l��%\��$CM�K�0F���z��\a`����_��gEzM�f������Q��; ��/?����"���8����dG�a�T�P��ԂL\����n5��V�B ���Oc�����*9�O��C-M��L��('���(Z񬏷)/G�~,x�)ә�*v�����Fl��v��|qϸ�-8+[5���18hhpv��q��t�7��9�|�����e��>i �v
)���$���_o�9	�|)���d�*s��m��!�
�����i6��,�k��V��A�j�ub:�)b��}F�´��;��u�ad������/�л�)`Sͩ���j��-J�v�TZ�S&�ۑ���
E���sO`h���q�.�a�xmځ(T9m&,{Hxmu�O�N����AX��҄�g,ı��2���E��ƍ�ꟻE����qޗ��56<�wh궩�L2���Hl>�z��"Ke3�H$0�Y��I�.�.Bw�*j��]ϊD%�r���|�٦�+���{�]]�S��ǿ�o��|��3t��kܢJ�k#��`�b��E�T�p�t_<���'���b�D�%:G��`��2����<D�?����v7�"�������Ϩ&Y\n��0�������K\�%�%� �hM�L2�����3H��	9�GX���P7�nfm��I�I\�}``%�*���mwD���·<�I�1�V�'�y��Z�U5i���%b�������=�=����ߏ�{�j~(��a��ߎ�b�>u��4��Ԋ�.f��I�`��&.�>�6=��0�9w��̯�T;[����������Q�͔I��$.B�1�&��YlE}슑r��	�|�i���u��$L���;�Ĳ<	���뫅�I�IϏ�ӵ��Gln�LH�J�f{nN����f<][x���,/������fM���*ZU#��w�Qi�,��,2g;��`ܨ�fB����2o�Gn��zS �;��dT��'�P�A6��IԘ��&R4O�ca��(ޤdmjZ֮j��En:�-���"���Q[$ �iy*�����%ecM�֔���uc�|y�׵�N�@��FaW�V���acPϴnZ�93��o�\D}#5�xb���[!�5eLȶ�ӎzӐ�vVa�_O����%�8hܪѡg/���,~�ɾ�$�m�*��tѿQ1�6�T#7S&���\����ƕ�1�-���k$ʲ��+��홒*!rYI�}H%p������-���Ѝ�9a���I��jn�!����k��~|�X��?cĿ����o/�?��z|��bc���s>(��ЬQ��Mg;����4և�aIo�74Md&��a���mk��6�*�2ɐm�"B��0�c�Hz���cF�,�:�0�����'M2������ۨ��p�x�#���ڶf�tr�Ȑ�A�+��n��;q��>��o���`'��.-�3�\fg.b�.	�ɥ��0����D�R#S'3����H],�oC���F�x���1�Sӗ����ƪ)әK?v�/}��x�������w��㏇����JV��M��*���HV�!!Xu���w�nw}���yy���^�Pq�L�d�Q�"���tc�[�ZM��sI�*N�r����EZ�+Q(�������?=��r�U�"nh|�C�ʰb&�a�\$l�6Όp]Ɩ�)�I���j�;�I:�!K@�	�]�~������xl�^)G�m�=�yC��S�����c� '08����� ��J�8�<�MM��I\&	�c�x�-;��F��H���7rb&u?,)Ї]��&~��In�0!�F0�;ՙ�}�n7��9~�:�5�Ie]�j�$]��ko�Ǒ�>K�"��T�f��bQ?�$�7��_R�B�x b4�_?f��n�>��vWI-�5�����[�i҇'��+8��EΞ�;F璭(
6�E�mR�b��4,E8�Խ��	�{�O5[�ob��`w����]�CҺ���WIs�3��di(�ݙ�1�^�?�喆szW
��D�"\)
g�5�����J�7q5[���".�5��Ԥ��B�����B����N��o�6���GX�����wg'C���/��O����T�atĠ�.@�B��R�����������82]��������j��� 'D��ck!$�����׈�S*�}��p�3#�D�:�;]���r�!m˰a���ǁve�t쳁�&Qg�d�y74I�$E(����e�a������5�����������S���8R0-k�(FB�ٚÅ��z��RHj�$)�܃�ց�r�Z�����PI9A��`�&2)IH�(X��\5b�S`��L�߸�O�2�/_�Cʶ�m�[n��eg�-�>_�[̫��^��mrK���k��]zܐW���_�۝ic��,"Ս<#?"a=����mD�$�7��������ڠ��c��7�|$f)9�r�X�[�����Zn���٩��q:��
'��3]�J����Kg�bA��>MhZ�{�KV�b��G��%����� �~�CR�+I�)!4�3���`d�����V(,:���q,YD:��A�F�z�·����Y+)!a��O��>�:�"rmgH��ڞ`�n����'3�z��
�߇��e��s��� qjۙ�{������n7\]ysՆ'�+s4
�Tߴ)͂��c)����X�q���Ӝ��6m��
����!�i�RĦ�3Q"����W6����M�ș�$�"�_�F�"��&ְ�2xƘ�Fs��,t�ŊSd�L���j���8�-8��*��Ѕ)N��)s6�룦3[���c���M�F�G!$[��|C	&�5n����C ;Ŧڊ�Ί�v�ED����<$�e$)�5M=x���U�]�L/���Ej;;�d���3��˔U:��4M]~�Ȥ�a�0[��Ѕ�)N�_&�ϯ���c$�!��%�-�d�!K����η�c�7����+;
�75vZ���ś8ER�A%j+޼	C��?;,X�#�6��L��[��p���8�;����v��� ^V�j~5_���f����1p���i� 0�Cv�q����A)$�:���no�FM*˓8\�
� ���Fc�!�F�l�u���YH�(��|8�_��~Y�x5��,�,���<�e�>[�%��5�CrӒ��U�ԡD:/<�/��
�˰��>�ڮ�	),EX� �Z~��R�JҺ��ug�����I�t1�?���Z&�6������':yE�F��Eօ��gJ�'�8E>y5a�x������������g<k)w/�TT��XӪ�!f	|�3����O��Wl�m�*�H��p�Q?�z����9� 蝮�2!	��4E"�=N*�B_�tU}~~zyx�AB[M���jE�O7���RH*s����N��|&��G"�ӏ��/������v���oh�񲏃�ɳ v,׺>�Y
!��c)�\IObD�����6���    ��}��k0u�A#F�%	/d�Z�>���pNR��Ե��YΧW��~3��4�飂+o�! ��Z�r3-J�zi�
�X8�=�bv-��o�~�a˯w��«�Qᇉ�wW�H��H�\h���$ ��ۏ�n�v����gڂ^Pw7pZgt)$T�i� �{ؤ���L�A��Ujq�s�����U�"��P���E����r��58c�J�:�I�43���Tӛ��1|ؓ�Qt��WWIÞ$Ej AQf����&v�y�U˻����ruX��+�.H�)�T%��s~L�|Ot�=}���W��=����?�|�-�'t�5��B������z��g�>>�g�X�, t�����<$mbI���9=9�/��{�=����������ߎ/���ˑH�E04�H�(��U7&�/�C�7M�I	Z:jf��*m_����Qb�Y���$�;���/�dQ�"�z�i"���./t����V�)��.,tq��Йzj_�D�tLK��>j�7h�ԠGS
	{|��� �>W�9���W����=�E���2b%}cu(n#�����&��U
c��,���L�Ǔ�ӗ�j@@�1̦�]f���pڈ��ń|!tY�d�!˧��{<X|>���J$+O����������*��^s(��n
ڤk���.���S/&�2A��+D�
?,��K�۟�&�b�/��8$�u��B-:I��B$|��+a���������)�R*�lf}Ӷ�T*	Iç$%�R�`t��4�3Fx��/�.��Hv1��5I��g�vu�1�k��$E�B��C3�@�kd���^���|! �����e�}SM6��?�ϑ7j3C�f���MC��H�j=\���n�����1a��
~����kj�dxFC���.2O����g5�L�:�aX����/�LO$�I�'��j�d:��^����	�]W
ɗ�R�{���ӡ�Ѝ;�k&���Mn�I�fW����F��㞏iH�*LR���_Gr&; ]�˰Vx*W�3r2������9�pL�5	��4E����:pZ����#5�U��Y񝴁݃��ml,�����-I�g����,j5'�ѩ�kN��P	<�,-
IG�$EⶡMϩ�n����y���7w���?RW��M"���:�������4E��@��8�������b��DeԄJ4����y��1N���*AC���z�BVmBD�mb��%�#�3k���eXJ~��V�D�}������:q�t��v/���P�΢���'���W��])�J�a�`Ɍ��p;q�9M*Nra��#�T�G�J�Gl(���R$�$\�N����E���k����	d���U�1�I���~�ϡw��y�!�����Z۶f|���������K/h�3��LWN�d�Y��:���g�r�r�|�'�����C笉��lLh�řU��6��P���<#�Zz���*w�bܝ�3�Y��ٯ6���<M��*������X�8��q7*I��$E�Jl90q�}��_���C��cmW��bz�����{]
ɪ,,%�$-:���wԁ+X8^��+T��\�ѩ��3��z�{�׏���g�ި�n[��X����G�[��3)�&�\��D�@�9u �T��t�u|�Ͱv-I:�8l
�OC�.I��ugL�W��x;)#{�η���n�C�+Ԕ��H��Ѿ��-I��$Eb=�g�/ǆ�o~{fpT9[�G�;6�9��j���bH�K�a�&�BVS��'�d�vȔ/4hj�V�.����L*a)���M$����<L9��D�4哠V=�"ϩ���Br����T<�5�t5Խ�XYA�3{�D�wH�z����.])$C�Y�HֳJ��|(�V�#���$-Q.~C]��%r�5h;۔BRG)I�ߐj����lrX�5H��p��8��W#6q�ֱeh�SDZ��῀�U�!�c��H=EX��D�!4�ԹNԆ���V���6��5�*��6V�/�_�P���+�K!���A�t��_���
�x�P���[����ُ���G,���5|��#j���ﺀ�u���j_�ʧ%������B-��}G��Ȓ��u_
I��$%����Z'ʶ%�I�h�����������֛ʺ��=��QFd\����2z�#�]x�kK�!i̙�Hc8I��
D�%]���|K]��������"x~4��W�͜nb���fI�t4ñ���fS��e7����!�`Hr?Ƕ��-�.�!�)�����չ"sq���Ы�}V���l�������4%?s�6o<;s��N"�]�d�l���U0L/3�տ�5C�9ۗB֚8E��*s������F=iԉCͰ���y�vDNO�=a������LPa)"C�;}I�H��¾�t��M�ViuB�菥�7�!k���������I�4.&2�Y�n�[�ᇛ&^��Pѥ)�=�P��Pq�V_�^B�mw����������86�[o&�d�1^7�����RH�h�A:Fծљ��������j�;�i�2Az�iT)$8����&�ܚu���;F���:�a_7�W7�>|��c����giȄC��M)$1����Dc��I���#�Ƨ�?��P7�~]u��C�C�ik�Ӆ��b�!�[Ů~{xo��q}s�b%
{*��wہ���<��CA������qO>"��.�x��<b)�\5�Z�ݰ�%K]a2�͖��$�ɦ�~FG!$�,E,	��]�[/7<za������kb�I�o���;S71�U�Y,%G 7��m�=B�
Š"��v�
c�B'��Am(nޑ���k��h�,����*�q{��:v�?ѵ�c$��iήg�5�IY�,$��YJ~[�R��2�t�R��_>=���n���E��@X(͜�3k6E�C�HqJ���)���/�U��q$:bA�L�ƻ>(x��آM]�)˲ֈJ:���	~�{�?w���ú����{8&���uW
��T��_�E�\ur�|�6�\�4Ww�r�SlQJ�U�!kf}���RH��X�����,��aX��X.9g��4l荁ΔBҋ���̺W.�l�y�N?f̎�n	P����:��!ix���[���fް}��C_���Y�x���{n�����)II��w&��"��8ua`���5�� ����pG���f�R�J!v�R҆�O��Ev]�(hZ�n���Gڶ�g8v.|.����~%l!��T'1O=ݯ�,����;�3D�)�{g�38��M�TN��z�y׷�zG�[�,E�|�bY���D��.���Ԯq�"=bD-��?8�+����@Y�2~RJ��ɉ���-]�?�U(S
ɴt�"��u]��IQ���O�f���[l�t
�Ӕ��B2+����A�u �,n���[�
���ݜt��*B����l͔֩��R��2�a!$�:���	[s��� >5i>̶�v���眍c�P�"(�uu��RH:�')�8���:,��{ro���!��.*�F-T�69��ɇJ�"*����ay;���q9�Q���������O�Ih�3k:vJ�CRM����JxQMP"�9o���[�
��ѓ-Uk�K�b�^Xݷɕ&���8E����T�Ѽ�pX�!q;p���.[@v���i�>��XwI� �C�	7������|�{u=?r/D򨆷).ڔB�Y0Iɫ�%��>̆_g�-a��Q�L��W[
Ir���4�&rv��p�Tm�AߚؙU�!��W?��7�n�@�""� �W�a���s;:I�ѿg�ŎE5N?O4M�uŐ��')9j>�z�rn�ЧG�����?�i�1u�CY�a�m��Զ�K!*�R�*â�D�y<�$F�:�y�r�u�v���B�����&rIJ~�z	�ÿ��>\�?�+��_;�e�}\��t�#Aln���yP�"I��|7�0qe	K�P߷M[
]F�Rdu��ZAQI�;����������ZI3�$%/���+
���H��/gD�ąC0������#�ۑ��������ߪ��/��I�|��mC�9��T�    
�9�@A&L�����M���ʫ��d�J�x�UZ-�-t[7:^���IRr�+���j�G���b1�lp�Š:����<$��ip��-�(��,��r�Z���<�m�
j�h���Y���\
]�G�)�5[�G�	u_}�����bL|a|����g��b�U!$�IIJޕ��ܧ.?��ƥ'U������ߊF��ڗ��jK�)�)��![��7��g�:�ޕ�s��;�e�a�F��RH�P��Ci�H�w����<��a��W�6e��%�[t�ŏ#r�7�1�֜�'&��fY�nq�z	������ׇ���cDf�����KPל�ͧ'�<��J@F�BRŜ��(Y'���a?���/�Kӱ���?��xV���tW'�]���$ERcrF��3��(��է���p3_�3��HO�<RC�Nc�ץ��B���f��p ��TW���8���&�Q�Tz��F�=���j��/��ٮm;U
�x�"�a�m]LBG<Y.!�Ŵ��-�]� 9-��RH�w�)�ҊKS�55�o�z��8�Em��;ϫ�=�Kj�Κ�e�&y�b��"l���r���p;\�����W��Vר��}z�>���t���eM!"�<C@Z��vuBrZ�6�jlEΓ�Y�1a�5��iPw�M7�w ��P����m�m�>���I���(X�x���}�9��%�o���YTÍ�#BH��IJ~���.���8�]���w��	�eX�D}��61-�I�RHB{%)�%"�*։��~Z�q9l	1� G"���̘�U(��8�8C�!Խf�=�R��bP�6���@�&�ݬ�fe)$�u�����ƚ����8��|? ��G�4��O*��*4�FעRHB�$)������}�d�xu^���j;l��)��x�ɤ�-�z��m�[�#2m-��9��	�6�w��z;z�e�z�>܍۴�c���}2��Zӷ��i�,E����nw��F{� �DM65�3jc)��d)"d�d�{�����;�H��w���^wmS
] ��)2yǆ��F��C�v{wHflpG���j|Lh��S��m��w�"]������i��q�s��!w0l���E1=����Ѕj$N�ָ�M��|u���nxs6���0�ٰ�m��U7 �<Gd)�%(�t�j�o�n~K�0��D��D��t�b�U(�]
I|�"|�F35��ö�0�߄����S07�"^l�Z�b(YH�J���.B��]��q�ͻa܎�k�LaS���F��5�C¦��H�R�ZÊ� l<�ߠ��~��[�E��Z�d�C+$��R��d����h�m��?Erk�p��F/�c]z e�� q�7����{Z�c:�!�fO}cb5�L���/k:ƔB�x!I�h��U$@s="�cpD�ҖZ�2%KY�1��6%�Ua)��,C�>5��/?=�7�)@gF���$�>\>��w��L���I�t'�z���؂#��D��UɢzwC�������E��Ӎ��ۅ����};ߡF�Ir N ayC�.$w�N%;�>.���0� P佗�e��DQ��Nd&�8,��u`='w,Q4ɲ=v��j۔p���]vue]_
I�$E����ԝA�;�����5����}mً=y����/�iJ!y�b)����;������j�L�a����J���Y��J�ˋ�)E�I�$1]����&WǗ������q{��
���O�L�l���_I�����c�]�b����a_�!1�k���r�"�bڶ�������V/p�~z���������`��*�'�tf֠�f_
]��)y�P��������y$a]a\p�yc�!�l�R$��R] -�Vo7o���i��v�q�����������Y���!��� ��d�su}y�B$�#$Sݘ蟄d|5K�,L?M�g������n�'wĒ��8!v�!Y ��p#<�N
G�ۏ'�Q,����<���6��B�0K�F��i������DR�_x��|��BD�My�P�*��OLoPK��Xv�oc�o�n�I�/���XHn8��ㄺd�.���S����p=d������NBH.�Y�XޫH��9�D7q�N��H�SMz�=�}W
I��IJ~Q�ǆ=�ݸE�%�$�^�Y�Ux�(X����mS�7ɀo�"<_
Y�Q\�p�톫o*^!�?�8b�a�r�*�8tL�;	<�4�tٱ�j�����Y�f�86H��U�IZ�	�QBv80p'�n�^���lvE �P��'��X��-|8��g��O-��iQ��/ǖ>e_�\��}��Ͽ�VT <W�Uw��P�������5TN���M��IH*v��؅����ax�<ߪ��YL1��UkfV7�$+]�e�)�b
�;u�8�3�plMP�B�F�N1$3�XJ�c�������hDO���5�P=�}��%P���`m����ki���Zݧ���Kp��⹠�B��u ��5�g��*ӗB2
���(d�	 xlù|7��
��o�YZ%�u]N��aKR�G���� ��Fy/����"l��3=�XBU�Pܪ��S��,���|�,E�Pؐ�/t秗�0�|�����%~ �����L��0.(��cu)$�<I��kW��pr��^;J�Vo���a{�{���pͰൈ�2mg�-�.��y>Є���,+,3�TgWh?��k���:jXv��6f��|�,E�X��N�f�&�@���|����bՑ�0Ӱ��z�ȉ!�������	.��~@%��8�,-��6`�o��+D�-�9z�	���]T��f�Y������+�.���j�512(ɳ�"�.�6l��z|u���f2;1��sxPW�*XS�H�|��#}���s�������e��82\.�3(�u�쓇.����g�Jn!����a9��S��}�#��:^Pרu�ۢ��I����`m��S �m�o$���-���(�~X{$��H�ԁٕ�<��J��|������7\���
q�T���t�.�e��&�B�w[U�RHZ��aB���怫c=�����؝�r�u�3��<�e)┷��O��I/�=�37'}�:V�&����c��!IH*C�i"���c�S�?��$/6�^��Ր�Yg��)��W����T\rh�ϫ��r����d��&6kc�HE�F�V3c�>B�	!	4���Ԑ&!���o�M兑>���gSI�F�<���H�"s��m,D*���>Mɛ��Eg��Fv�%^��#9Iu1�!��"��9���tJYg!���Ro��ӄ:�l	��=|\��	ܦJ�t�ƥ��*��D�IR$�5,����W�YҬ�פt�3̓�f"��%&h�錨�����i�*��ۜ���!1Ҷ:�ߣ�$Bb����E6ұZ�-�$2W�"��`Y0~�8\Ww�_~?=~;�?�8>_Rr��*��_i��[��*#�9M!"4j�i(�.$�\�i�h&Ϋ�a���i��nJ!i���5�=��
�(�Y���+��K|2g�M�t���Z��S64o��(�?t�����*�U����#NI_�}GM¯ǿ��&�$���W���}T��8z
�JNr��So�:&�`�׭;�ꉐB=��������M��^��������ꏯx�M<��`�({��^x�3I�U�"�R���4�[V�ޒ
ՔVW�N� 
��'7yXL�}�^=4�E���f�a�YH4JR�׻�joDG�-��Ww�%JLT~y�%���6gg��M�H,��k�S�k���F��T��.:�s���Fθ�Q���iJ��G>eo�p��9�l6����ϯ����������|}d� �M�� �ʐc�I��#M)$Tei�T��	��B���T6��b�Ym&eо+U�ȁ�>-�ʎ�+Ґ<Cd)B�[�0�vWÎ��w�B��8�@m��j��ག�}l�˴6�i�ӥ���8E��l���`Y^S�qE!�_��?k]�ڮ�I��b��y�ڈ�
׊��u�v���/�=�д8�"�4��5��4.�Ѕyx�"��Yp�}��xo/Wk�̨�-E�    �e�!���I��C��Wn�sӕd��o]�:t(kJ!YH�M�r�*�'JUW�Ÿ��(t1��eݖ���.3�uP'��IHn����[ׁ�Dg]��͝IȚD��F�¾�mfʶ�I',t���� Ө��
p k� �QW�Ѫ�29�6��6���2%)��A�r��s��zK<��	���4V�-��m<��C��RDi8Z��_K8}�˃/����R�r
������1�Ѷ���I�D���=C�2@�]��|�%t����v�r56���,-1������4$�Y�Q��N�[RӾ�h�6��,���~���]1$����_��*4����v�+<�w�͵����',Ch���*D�E(�� ;i�M,�Mď�Db�(�g@C'z֘K,4���ж��+8���)�x] O0�O��f�ozf;�T:~b!y��RD̐s'������7�L$]ySݽ��37L��=�&�9�gZ�r�!	n���%��^��p��Zm���%g�3��8�XW]ד}���ܨ� 	'�4%�D:�7c9�n;��q��N<�_��ٵa�<$�ғ�\�����ړ���S��m��>~��qK2g�1�8	$H�H�~0�Ҫ�l)$+$�Q"	'(~_�Z��A�r��?����R������A)F�w�Rɜѡy�A+֖B�z��䗊�y��ZwHz��>=��_O_�>�U�~'�^k���l0���4땎�T��T')y��G�Xsv���O��¼'��/�?-�=�#��a���)��z}�ҺkJ�|�!��"ϥ��$E��wn�%�}����m?���8�bw�ߘ��:�c��<$��$%m5�[t��������!�"�)� !YJ���RbƺI>��)���{�87D�|�mc��T�')�Έ�:��(�l�-�o�&m�z���/���V�"(.��@@:��3�t�h7���T������g���6[r��$�Ⴑ�� #h��:<9���,#�RDA3����S� GWC�SԳVY�Cr땥�W����b��X9'{�����Z�ª����S�'�9�eMM�����?�t0��g��]��gHSY��Il����wy�j�:�Ö������e�lU��"����$E�5Na��|{2�8���S�{����ʹn�&ŧ���Oc)� �j����y�~X�����K�$��E5k>�a��¿m]��B��5I��p��6���0��<�����Q
��N�IJ���� �k�ߢ���d�}�?���U,� y�!��κ���[��$%�$EP�B�{��;����^�K��w$t��*̀=I'�$E��e��#(��,��9�s�󱺡�&x(�M��zb� P�QA���,OS$�go���VW����ߞ~<}�~Q���={2���)�5����i�BHzQ��=�F�t���ay���E��W��d�����A���6��<r`)�!��3�iM�u� ��Ȗ��I�����3и��9�V�fc�յ+�d1@�"p���Ʀ���1�����"QP�Վ^�3{�jzK�*��+���r>>�$���7���m���g!��g)��jp*[�f.�a�(��v1�Fg����7��#��n�h�D}O2��u��Q�8E��\�@p�!{ě7l���k��-�9�i�w"�ЅVd�"�"�pT ��jX%
D�?�ٶ����/����km)t���9Ė0Y�v�Ÿ�78��:k��M���Zu6!CT)���EY
7	���pX]�wg��lI{��ݞ\��S�����V�n�|�Hݬ�[m�RH��q���V�ݼO`��|?��tD2z:�����O�ʡ���V���!����.�?��KL�K_w������ˏ�6Y�jC���QѶ����,E���V��	�����h�9��H(+���u�u�1�����Rr"U�5�n�x�/Uq���̴��])$<��Յ��P�y���Y]�Y)_)��+,R���!Ҵi`�K�YH�@�I��'��pXK���
��E�G�Q*iתRH��')����:�l�Ï8��$�K%KӎN
�7U]���)"���#PK_�C��ǇGo��rin��Ћ�י�7���WHR��5����E�6���;�w��/)�S�� Ƥ�1��F�����P����$;��wXA9o��yg[���:�k�35Vu��t@OR�z�J��y*�nE���� ���`'�J!������v�u��3�|9��f1_�a]}������J���,]��Fɍ8����m���R'��� ��0��t�o{��ɕ����v��a�.S,$�E,%�Z]�u�D^�w��8<_e��T�����^�O&I �$E�;�����}7�\�W䕹�3���������r�V��)�dY?�"��Y5u�?�I$�~h��^�&y弌���a_YH~aYJ>��Pk����ɪ��;z��aQR�ߖB©4M��L�����r��� �8�f=,��HIȌ$E@g��`���on�tpU!�M�H��rN��8쳨<е���vc)(K��l/�������;x�H��
J˰?Aj��7�<$!��		��[�e~����|5.�Ep����j`��l����]
�$1�"	B�'��w�������պ/�.�4���Z�H�&!Y���K�q�B|x�w�r"��x'�޺Fq;��(Dd�w�!R�qoft8��{:Ϋ�� ������Gm8~)�XZ��t�%�">YH�u��}im���J���v��
|5��&�_�m��Z�{����a�x��`,E��֮�T��H]Vp|8��S��35&@g�zֵl�B�� K�g(^JX����������1�3c�ӌ�A��T��!����H�u�z�s=_�׎�����uK?�������T`U��O73�6���q�°/N�{pD�7L܋����Dgu�I���_=�(�(���V�7��!�8E�N?�<Du5�����{�oפ!���	�g#�(��'���j�
�`)�HS8����N��	��#���827}��5����}n�i�iJ!���R��B]v�u�����]H<�<7���n<iW�Κ��a�BHZC���u����D���h�&ζo� �}u��],.XM�v<���*2�Gj�4%�2���S��V;<�^�w�|��������ș�]M#~��k��6�ƶ��o��l,����Q��>O�v,w$�9��P(�C��~���Ӫ��!,Eć�ɍz��ݾ��`r�������a �*JW C�K��V*�MIHZ�iP''K�s��j�	��Ӵ���"��lڇSj���N�\,$��X�4�C�X��mV�-�%?�x�:aw���Z�;Mh�i_�?fCf:R)=k�V'b�IH�a)ҐY��:�+س���M�x����[�~��������q���$y�
	a�����<=�G�������F]_\�M��+R���������<HR�"�'g�KՔ���I�T�{��!�8b�
!��c)b��&K��A.�7�v�����{�#y�]�L��4�6dȬ�ڪRHB�%)i��,:�8ъĉv*���[�q�+����ł�%�Rn����_65�|A�DU�7�Zᶳ����L/8�֤8o�i�-���1I6��Rl#��L�8�k��8d7�55�:��K!Yk���Z��u�7��=�.7�� cw���Q�����c]!$w�X����Ģ����n����oEqM�X�:�m�����b�BH��&)�U:��d��+8�H��mW'4�-�^/모	Yhf5l��o�,%猪�u�;R��0ۈd*���"���q��,$��X��׃s2R�o}iAݞ��7B�aL���T2]�J�)�e�绅U���������r_}F}�����+j#T�ϯ/�������#)��8>?|�~C���l����~jn4��&������MߖB��-I�; Mmk˱�a��vC� m�ƿ�D��#�����l|����$8�$"��B,E��������U�y?��hb|;�`��d���@Ќ��    F�u�gH:	�v|����|��<��4���R35�_z��)�����#i�Bʛf��:�Qc�3]��_�pm��63zI~�&�b|z��$�n���SŐ�:IR�k���v�+D���p��Y�Z�<yc�DQ���c�c�S�M,I	Wѹ���WI��'6Zg�e�`��wc5�c���]�:�ы����bU�@
*�œ�<$���|:��C��r�͋pUhMs�5�#�W^�Q��OZ�����->[�!iҒ�H����~�r�B=p�~�?�To��"���3��+H6�Αl�8;V��JnUŐ���)¶���۶�[�2��jj�\��m��m���-�d�M�"�m�&�?��_?L��Fǔ��ham&�A�تNC���Y����`��M����������X}9��~x��(m��������g�;o3��#�?;3]�jU
I��$E�6�1[�]���Ӥ�����<�T�zgc	zuD^��ѓ�b!X�����rF���_��h�����_����T�<}}���:�-�,�$�Q�� <�H�Z<#����А�t�l�D�t"jX���~�x�IJ~5��Q�m��,R�3���j��o��� x�SD���O�Qd:&���i4�ݶ����d�"�k�DPUp��TֆT�aMP�.���(K����j�U���8��z����'��vN��Hg�"���a��a1s��,��RD�GӺ��fY�E�3�DK͂��;ەB2��<tf$ܫ�a�˖�(�
��|���9�V�ȅ!�������IH��g�	�8
a�X�lhqۭ�����0H�S�A�Ho&��ҭ�#���~�}?_��s�y�J�[�F,eҤcDG:򦭻�����A"K'�n�Aه��7���d"g*b�5��ժ�a�3�HxiJ>�A�1������W{�f{85�vY�A[l@�KQ�MD�U���eI�0�CKO}ҾCǣ�O���O���<���'? �YT�D7�RHɭ�8%;õ�?�аX�h#*ub���z��s<=�?%�����Y4����t����D������p=4�o�
%~��G`�lD���h��[�\�rF�|�Τ6-n7��{|$�EڡjM���~oPgI~��j�v�BR75I��owz�ўbر��
���{�+p>�ȿN�m,Ӓ��_!I�i��He�t=���Q��v���x�}��Sc�+�U�`'@w�XM$e+[���k����\��]���}����ʾ~E��_�G�;���:>��*H�4D��M�f�G��}�)y��G���������W(4(T,�Ա���G�즼�M"B��d�@W�w������Z����k�|h'H~�oZ+s]ĜS�k� 1�4�_�4�H0So����4��G�7)�;M*ͭ3u1$Q[���(����G�B��z}5���.v�)�@[C6��A!e����ik,E���-=�b�C���-j�;���e!2�RDښ6�ynM���!��tom9$skX�pgP�W��>����y	qsX��}d�$�du�"����N�������4�C�l��Y���'�/��	�"�3g��J!y�R�	8v��Tᰭn�� ~鯚Ƚ�8���Ʊ���s=c�*��KY18�p�uo�bW|�T��q�F�D�EB��aYiD*�x�đ�;s$�7a�ݲw/��!����ɤ\)$A��A�����I�f���2�c@f�?���g��1�R�.�iJ!i ���18&p���V�!77W�_��{Vs�r"������!)�I�n�w:�`�f�N<�����_�<=~���?~�����4����~ʤ��'�C!@S
] >�)Y�q�?�|0v����g����?S6��c�O`_�]�])$�a��Q�#$�|��7a
�^+&�;Ab\׌뛇�}'I�Cj���?��c�51O\pZ�	�ՙ�tm)$<��q���'|ְ���a��"��R������w�����Т�{0k�iblV��,EZ��Q��FTm�?��Jj7S�i1e��B'��<��gE��[3�8�Vi�%�y�S�N��խQ��ԕKR�Q�����wb+����<rw\�/��v�&���6�Ѕ|��?��8a�[!�f=��~���8��9���Ѻ�+�d�!�"0Hainmd���j�f2t�F��R!o��OT,$#�X���2]�S�.�!���X���P<~n�Ů�yH������BEĎ�=A�n���a;_��K�ć��d��D�U�"�gH$����Eza�kd�P�bϝj���3̴�A���c.�D��>n�"�!��g�
���mD��AQ�O��q�?J$���bH�����!�Ón��R�Oc5JZ��U?i��
oì���V���wHR�~$�:�������)�����SB���.Q�Z��6��M1t��Sd���-Z���8q������^z_Qui�ֵ��|p��c���7���� �43�ĩ����g�	)rqxʐ���Y ~O��ׯ��֫�V6��%�|��W���|�� 	i����M)$m�IJ�� P��S��ꀽ�:�V8g�K�V׵9��2�4N�f����-kSRq���۞�*�����3�6%��6�W�r���"��d��ߕ:;&C�S����kҥq2n�Ԅ�K���Lr���:���_�����+y��� �ȯ��&����WܮB"qJ.XY���/w��f��T���z;�de�r�:C��9���Z�H�B҄"I��?�h��C����^�f������KT;$EC���q�
'�36I�~�pF(剾wu����'`�&9����TmbC�<$� ��S��S��l=\�����b�|&L�8�E�����!y��R$�&���R4�
��;Z�`��uƝ��O���t�T��ԺNR�Ҫ����症��.���j����aD&B2Ĕ��S���ֽ��I��\�����ׇ/��ˏ������7�J�(6�-7����\R���J4��s�U�:�x8z̫c�0�s�����mK!YΑ��r�uS�b�$0��,�H�����X>n��x�b���+�$,_��7�T��6F�W�?��|x��:>y�ԙ3[&ᡉ���.�-��Ob)�����	��#����e'��d�ݬ�j�	�!�LR�C�C��C�G�p�ێ�zSQ�%f
o�w�mf��T)$��I��v�i�+���k%q��{S�G�l�EJ@+GS]���)�"Y۩9�OS��6�d#�y������]O��ԝKR򞗆jB��Ĵ&.Y��F�')F�w1�Lɷ���кwM�*�Uh��r���}�jT)$|�i� 2�r�-ȔI\zR��R�S"��6�M��mL�:��$�@��_h�'ם�W#��-K��W��0%���X�Gb������<yHb��m\�)�f���!�`�;���eU[I��$%���݄���鮆�5y���W���U:��Ï�h}����rR�"]%*���+	���QP��.����e�P<B�?c�Y�B�����4�8��oF$���{^lԒ�)r?�g5l�N�BU*IԔj�l�ve�H�[����DӲ�:%&¿�8pn4�)�dj"K��FY�ɭ�� �~�i��/-��Y�M���4�KR�{��)���-	�~z<������������-BR�F�S��C�*G�"�
���&��j�,O.��8	1kh�C��Ǧ�d��,Elh嘆�աZ��s3WDrm�4@��h%���K!���R�+v}����Tp�Nڮ�2��U]{#������-j��4U�i�,E��ª�o��,#I��v�;p">�`nE�ѧ��ѱ�x��ˌS����VfWOR ��a�����v\�����WI.������K-�_�\],@�dTm� �,�Ͳ����
G�٧Gm76Al1~���"K��oJ�b�q�,��� *M|p���m�k�z�|8����W�"�v��v�7��_l7+SU̥��(�����h�L�g)"�
.    �`��s�_�!���" x�6��X8���I�#�l1$�<�i �ƕ@�������ns�	ڕ��jޥ6�h�n�RH�R��Km��w�;y@������/� �����P���&h<e;�6]��F�B2���h�FN7��[VA�._��I�����. (�A���m�B�Lh�8?Mǭ��-�.����cp~m{6'�.��F�>�&q�JB�"I�.�̵��V-���j�wJZ54�h�^�yH~�,E$������uI���ƨnfu�M��g!���R�Ϣ�a���+6��%�#����dH�V�	k�{y+K������űXJ~��؄i�v�]�2�g�71���g��hPc��3ke�J!�>&)�SE5�#CS�%�N���2mp��Ő,��R�NZC^��TW'H�mٓc\�����Y�J!�ɥ)���ȁ���[�۷�
Ee��C�-JR��T)ê{��;8 �$ <����F\�a�j#�'�
�����B��/����F��֝=¯��`7�����,�����v���F\�<@~ F�7���fs]��z�����\5-/�9G��"��u�M�ֈy���8N8zd�y&��Ё���s�{�����󿟪��������%�!7:d�8�P�MF�Su�kӗBRі�d�J���P�Ǘj��P�8>>�]6� iƒ�!Wwm��RHZ4��%M�c'��n\�B�ɨ^�4H._"�6]�q�vp�v)����W��������G���.��|0�����c���Z1jꚦ�])$�XJ�C�
}��/ǋ*.��p��Ʊل(E����ac�J�@�8%�a �$�ON6��;I��a�e�@t�mLccy�<�-�yJ~Fw�I5<�
\o�w��M��y�B!���[�7�i��Y	��-:Eg�h,X��9��/�?��������#�Qڮ�q����=k�!�kKR��2;��E���\7��n����Q�4q�.�I{ԁ���U��ԓNR��4��Ky�y��p3ߝܒ�h�"р��8�~����1]��S��+�`�?�x8Q#�ah3�����v�؈�>p��IO�.�,��WC�a2�g��~C�������������@���jfՔ��E!M�K]D%M;���n��#}�\(ɒ�E��>VA�CK4I���`�
���3��z��(���2�F��D�x<q��3r��|�,c��cf�y��C36Z���-�r�����3�ߡ]�������������G������|�-/�8۩F�=�gJ��Cr��R�}O�ʞQ�����UغV���F��hn�P#Z���L)$��IJv�h�P�g4�b|����g����H ��tu1$�d��\��&��~ �����oG�;���V_����	���\0��24�Knd�"��e`N�z�kJR06^�25�? ��Z7})tA!N�	G8mbid�η�u��o������Lu���RH��$E@f �Ȧ��N�ih�I�b/	�/P�����$�3d��@a��-{��u2�rt���7KC���Rr���Q�������(�Ik �hk�ȺbD���� rF��<���Z�ǳ����v������6a��m�6L�І�S�6L��n�g��?�l�iX�L� �
oRk[f̔�䯛��ڢ�bPE�Ϡ�kR����:,��v�Giv��	�!�p֕B>�8E�lll�О���/r���.�j|3)�%�d�-��R��#y���t)$�I�|*�-�����%��\
u���i8�L��I���B�J�R������Mkr3�15��-,��'�u̬5&hB�q�8�t"/��FsOm�.<�;�Pp��k�J!�')�C�q� +j���uP���лf�].�����Z�u!"��x�t�g%��{�w����}�~�||yxz<~E���^���|8���2l�͋���	1v����<rb)	2�&N�dҰ��,����"��P��\W�0�wXW���S�sè)�a#Y��v])$A��	n��x8�t-���`՚EP��,P�7���t�6>��A��hl<����Q#�_;uo�K�qu�gC�	;�b�AacJ��̊�3�JEN���塐������7$��|�Y�nЅk�}�vgp*kUW
IUB�"]6�,GC�.���T�{�:�+���k�����+�D4#��2b�l��J!��R�N�2�n�N�N������!ʵj��f qi���W���8)_y�/ML�q�g�M%�������҈t����Ԅ�!oմ��i!�;V���~��s]Cu��4�KR$�A��&4������4?��f���	�ꄖ���Z�!�Q�|aݹbH����]�>]�?tu7�ج����s�s /b&�{��C����$E*b�(�B����ӌmu�>��6V�C�NR���*�8J��G���[��])$W�,E��(�E���V�nṪ'c �m�K�TӖB�B���|x��T[��eӣ�y/��=N�ἲ"6��-�ˢ�����~��\;۷�����������tӡ;}]
h�o�3M�+�������e\����f���� qI]�o��b�B'0N�r`��x@��w���ԼҺ|�x���C{W
�W�RīT&��=�NT�3����6�Kpu:�b!��R�~�ɉ�WYW���P-�dx�!�Z>Oa�T�� �ou�m�RH��$)���>4d��~����d��HH�[�l�.��}4��[�42ƕB�e&)��93�s;�Pwv?��`�w-ّ;|-vU߷��HS�
���vo�Ǔlg�{[_^��Qݬii��nV�N��d�J���/X�EL-��V+\�L���v>o2�]�'��$�	��)��BA�7	6��n�Z>�qz���P��͐g���XHFi����2������N��Z�Y�?��Ԣ�F��";I�5��DcZ�뵆��)�ddKɷ]���#�ʯ�����j����؊�۾���m>���a�(���;�N�� 2S�L�HӈP���"�D,%�V9�.�D���;.����q�w4+�u����e|�F�qw!I��$E��ڝ������o.�=�-�>�*�n��ZԨ'�d�[�"]^o#��1!�LX_seN3�ɛ��A	��)�d�KDQ�F��z�-M�{�l{�t��6��o�����!�͕�HR�����7��'z삋$�$L�!]Z��ڪR��K�"b�����>�ף|+-�Jԥ<u^*7�]� _�����T�[mK!iMKR�
�3}m�K�0�Io���j\��0��zH�s�8X�KΒ����x�!�$�j���x��s#J��
����� mD��@K�5隙i4O�Bh)M�@K�<NBO�Ǘ�_��+�!RY�����#�1U
I��$E"J!!�+HޏH��z:(��jy��X�p,�w�q})$�8Y�н$�4ixCg6��Z�:�����u�k5��=���4��yâ�eޜ�.�Y���7֏�������4$ݷ$%�U��k�sT�OU#���V��+㛣@5�[�6M)$}�I��7��u|V9�n7W앾1,��_u6j5�)���iԬ���S!Ґ<`)�P�N��nƳ��=Mx!�`�����:(��c*��T�"a������C�o�G�ԡ#t������o�ͻ�1�.��[�3�3l�:��d8>Kɛ�(���������)\����c��������pIJN l��ʜyj��+�?/M��pU1Fe�����[A��͖�P�����í��í���Ʈ���%����ڮʞs��?g�P�5����p7�	|��U��}G���5�.}��!�;JR�����U�����~����=�Xz��D��[���0G�x��L7]`�)�� �ha8\��)d��ַp�޼D�&z��
�n�~��	_0	I�t��?d�|������ǃ_L'����8��:�	XK��������e�"c-����.Ң��M ��Yi�(�.�R��g�ȟ��|���L��B���[�?ޢ�    dך&��&!	�H��bgNv��j���pm�t��Y����1�,E�$��L�W+�s[��K���bj�d�Y�|�����XJ*)@�W�l�`�4,��/����+Ҿ��vQ��	j��[;kqڔB�h?Iɔ�:}|�aK'�O�x���p�$�B��Q�v�	��P>vƕBҝLR�v>J��3tz1�V�
]_o�P�w��'-g�q\�%�]M�v])$��I�  �A��ö���s����v>��Z}wHpE��kx���f���� Ss�.�JF��mS�HtDI��IJN��;��C��,Oé�YY���n"<��PV�)rY٪��O�$�M\Pϯ)D.���u������6�\����XN��3�M��<]@��)"���u�Ks<���A��9�-Y-�j ��Qـ���fg�"����.ڴ�b���"o7���f�P����
5����PkǊ"yH�������,?�m-�+�#�X?T�
2|IJA�p �W
>��.��*��� 8��ae7.�0[Ե�S�hW�Ѱ�v1}���<$�ı��3ۢ��������ue������}��;���f?3X�v������!_�p{��W21��v�8@35]��@�8���,$l�iJ~�d��"�9���f3��cE����|_|������`MR�+ܪ�|�p������j��.��R"�Dq`���1��K�"I��Cn�?����8+ ,,�ɨڗB q��0��y�����2�Ez�d�3�_uS
]���)�vfm5��X��� ��x��U��� ���Ǳ)tO\��H�)�d�;K�1�8>MVnt�u5U, �Yi���xY�pm)$�6IJ^�iT��L?`g����!��z�4�c+f��$%��p�;�q��wm7����,�Z��m�~�t�	��7밼4vSFW��	4�4<1�`�Hf�+Dd��8C���b �|��a���57e�Q�ʮ�D�����IJr��uo㹆�Kj�a#�K����-]���)2��S�Mn�@9����h�~O�oK!�W�RH:C����&U~jE������|� ���f�AdH�W�`P|
.���>�l��T�2�M_�_���>-�,�R�n��a�YP�)}�BڛI�_WWhet����o��#��?>=�鯎 Ϲe�"�-<{�&>��l��S�~}�PE���t��q>�S����P���0�S�ٝ2S�&���;��h43�t�b��уXD��]׶uWI�}��&-��:u�ɹݎ��V9"y�9sZ ��b����t���D�Md��$ʝkG�^�6e��1d7k��<$�J&)��\��uʜ6�� �_N�i�߷m�Y�%�=�m�鐅`��J׈���A��!<�IB�Q��npcZ���!I�4I�Ѥz��'��ps�v�.Ï�)���cJǆ^���i�؉RH&)��J�:Z�iD\�͠�"|�F��C28���lh�$M&����o(V�o�W����>~��5�׼�̎��T�g���w���c)�ӆ����� av�^��M���I�����ׇ�I��ˠ�+�����	�o��9��t����:�2��I�&Ҳ����q�kw�yh)BJ�d�����j��%L�/'<��r$i�O���=�T��1!$�������t��.��-p��\9Lj�О�v���M�8En�� h}5|<T�᰾�~$0�㘘������u��])$ab���f!���pa�5����s������׆6�	���y�4��nL)t�%���i�&4�������~�x�):���?^����Xj>c�3C��j�t����0ǋS��	���s3b��U7M��xL�ɷ���Sk�ޝ��Z�I���QC:�P�w�-�/%��'m�>za��*�/U�N-��Q�,Ej�����b\L���m�G��cKa��Z8a�]�<$}DI����M�����x3��Ń�t@�pg�SߕB����HZ�>m~͙����o�WP�����%�!$]�P�풄��1I�/�+u�����>�Ͽ���I�^�U'S�פO
eUݗBR�����*��lz7nъm}b2i͖��k���Ũ9}�J!iALR�mmu���S��Jx��+��_σ	AI+����ۮ�]!"���P�n�H
�C�tCv�;t�
�!��Xf����Gt�E��46NR�I*_(nA�B��H(��}�������˻����jJ`&�y$Z=��.�dV K��L�K5���]?`��5Rt<Ԍ(��jV��y��;PU��͑YL�e_�{}}ō��3�"���W#����f����X]FI�$%oEB��ƹM�u_�%7O�g8J*�$$K,����}��ُ�<vÇ�q����^��Յ�w��۶���"Vv��\�Ȫ��36�Ц"���)����!	������4ʋ�>��P֝W�`]
5t�7����m:I�
���L�C0������`�qYST֗B��A}T�>�������Z?�?Vp����������ߎթ������3�i-!�qnb�N���,E���}hp�ή8�N�v�%�PT�og�8ߔBBɓ���x'���a��@P8��o���s��)���[�Q�#p7��<�@�H	F�vY�*���K�d�8E�v����5�� w7^oV���92�Q*��j/����P�R+�rlXH�ҰBE�48�6�X�ݠ�K�egf�ga��g-|�	�2	��K��8���^9�UP�c���V��,�`߸ѥ+���q��{�e��(�S�p�(�ȱ�a�k����%N~��qlėu�Q%�k�$$w�Y�ؑ�u8I�QY8F����yO^�|O�ηh�1����RH��Y�X��k�n��8��]효�����qu����)�Kۺ�K!y�g)@��D����x(��*\� ��)��)R�"�*�i�P?w?ލ��̧��pi�1�2��6F�gpҖ<E�Yӷ�љ��T�$)��v���.���*m�*ѱ�m�f����LR������!5�h(b���#�`g������4IR$-C�5���%�Gd���;���\��錂�_�A~y߸��(��OR��IS������Rm��/W�>�}����0�M�xT��L���ϴ�\<��C2����|&xm9�q�����氜gl�D��Fk<@���4��RH>���5��|N^������|��rBr�X�UB��<��UA�"2�<�!�)͕oowX�L,�6v��lք!Pt"��e��P�&�)��F�u���K_��1�Q�Ȟ�4#OQ�ISM)$�˒��R[젇�r�=��*?ӬW$���xж��n���$E*���㍫�q�Ym��P(���:�6��B@�q�
m5����i�݁˰PecC�̜���أǇԕB�'���C_C�}BZ�k�a9D"Q�yu�~��ݩlR�`��6��U��4�NR�I5l�FZ������o�M�\lǐ �Vv��Nj\,�)��77Iɯ���܉c4	
F6b��\$2E�g��d-C��!I�$I����u�D�[b�V$�����j�w�/��&��	�����m�]�'������%��鏃���$JBRe��%Z�r�&���V��t;�	?�6����Jie�5m�,9�t�!Y��W�=�	>2���O�PF\Jnvm�h)�xbD�k5�Hѥ���%)9�����+4��j�"W(m��n��`4g���QllM�Ld⛙A��T��dET����Z�ԓ��-M�59^�	��7Ql~	a+�Xb�$�y�����C��$Ձ$%#�*8g�\��=Y ��^�=T���շ�_���D�n�x��*�٠{��kJ!�T��
g8�'|���B��a�z����i��s��o٧k�GR�\�uۗB򑂥��MN�T�V�v,���q{�g�;ɨ��;x.����$E��k�8�P[V��H���Ml��y�/�k�Iz�IH&F��΋$�p=�+�vֻ��b7�:,�e��-�u>��������fBHq�)�hr&8�D��|�$z    U��N��p�@�v�'��5BH&�In��c���a�+�$���<����U�0HBS�Y�uߔBҥ%)҇���׻���.�8�yCxxo��^��W��u���RHV�c)��� �������Ć5�S�
�)k�|x���8�S$������*��M�e�H

[�1ωv�p��j�I��,$��Y�D�S��J��xr�6&��H�5�cZ8���qDf��"���Pf�PR�v]ϑ��I��7
u�+��Z��������\��2\�'�L�'kv�������cg{1$�a,%�a��5�};)P�yO�>���!p�&�⠾�4s��骺�G�A�����
>���W�ð�̊F��^���k�b�t�j
�l��S�m��*��U�>@�~�|�xQ�����x�m�6�%	�_K�4�>d��b~=�� �d&n����!�T=t1�Zǯ���D,�^L2-�H�&����.$�p��.�����^d��5
�t��Ż�܎\�M�6])$5C����5pSMXQ��L���B�ᾎ���� ;=<k��.��:��H=}��r���n�������=�`��n}@���,��^�F{i����7�����#���.������<�!nu䙌o,uʃm��Nm3i���P��YH>$��\�������_����#	}W��e��o������g�Bm�bH深�߆�E��$�Wm�ѯn9!�E��d���t���d)"2�65�`|�}|}�-����M����Q�wk\�!�!����H�E���� |]�ω�а�v�c���#XJ����]O5��2��Nhɡ�FG�&��򐬅�R$8!"d�m�������������+|0���?����_H�CM�-�d�O�&B��mW]���)��ڸ�3I�����a{\ͨ�C��ݓ[�Z<�(�>��5��<:`)Ӆ��{�oaZ��_��oV�����w[�#7�D�[_O�$On�#��(V�**o�3+�)_����K$��y����@d�O���֥݇DF  ����{���C�|�����������~*/�3 �A�U	�&&�A\X ��`� Á�i{�߅�=��!~|��,;�a�	�Ґ��L#�1q���|
,D��8ޓ�ڇ�t�g�#�ZuG8�Yhx0"�+wCR�t�jO/ȫ���&���n<���k �(
ϢW>�-� ., � �`l���~y�ZO�t���!���](OƐ2����م;�,�v8^O��q>����,��8���L��P*�&.�*��Q���~���G;��w9��/߿|
ł�W�V�Et�"�u}���ZK����<��;Q?>�i�}��?||��!��`*D1kl���閉�.��t2���8�8�w�Udc�@s��F�X~�JT�O�j������״�K�!C'�X���m��C�
"�;��wowE�!?2��dMh6A�w}�gL��p�^<~$�����.!lg��S�]�@�ɝ=Yr��8Wװ�0�ܣ^/��jyV�E���0�f+>Ç����iJR`߫B��*���o<,�`�Z��ܥ�F1|��9u���=��T�����.')��Y�b�i,�e�e�m�K�/���;˴�r,o𒺎-?a��b�@�`%�L�f]�¬��������5N�ٍpE���&k��s����#�2�O����^xȓ�h�(}=ގAE>�^�wj�ď���G:ٜГNQxp
�����\��S��K�)�ǎ�������%g��2��eh�Ã1��`��ĵ-�m)q���_M�15��n��>��~��0A7�q $;C%�[&.:(\�� 4ܩ.�z\燀�B7޵H3#!��Zdm� ,��0�.7���w'�1��Hф
_��n�ވ�1Y�8����@�l����'�ˋ��`�v�Ñ�MӅ�Q����u?^��o�k��| t�Y���t蘻�@����>f�A5�J��q���ʻ��@<D�R�%˖���.�����0���٥"oV�� 8��~���^�".u'2���x�����aD>�'8�J�-/�A\X�3��<"�x�}�(:�$�!��:�M�K�fi[&�AW�p�A�4C���#�Z@uR��m��M��TJFH!����吀���&�ូ���0�ց�o����t�_,pV̨�����b͕0�o��)p[�����k��opN�t������4���_��a{#i}�2] N�.<pڤ*,l}�+�S�GP{M��4���o$��gL\n\�p�Y����14H$�� i	���0�L��+\8��`9�A�{AV��8M�g��ui��E����0@�-c�-�±�=�l����~�W�KB�#@�9�S�1�-�(\�x6�f�.��6��|����\�Nᢸ|�`�gQdM�2K�Lb�.�.ܑ#�M7D5��v3�"�!(4PP kh9Y�B�ڸ��f
Ȋk�CY5C���o��	�G�����x�]ǠQ��~K�oD�b a����3�sD@��U�t�N�S�t����G�Ϝ��3���v�>ˡ�i���Ґǩ��O�� >�
١C�Ѓ�5{�|�`�4qw��5��n(�y�S�s�3
\�z�ȫC;�*?(b�1�����C|�c�Oe�Cf��.�C�]v��н��
T=��7.\�-�'.u#N'xӳ�&*h
 ��� Y48����o��l�p�4��gM����[?�X�3(�Z�0�k�8�m`�L�Zf�IRL�,���O�f���!�Pd�*�'f����&�/\�e��j�:k����HO-�	+�,4�5���^曤6q�`�R/��+�o0乚| [9��l�@8\�µըGW�0"�<���=��f��]�n���a8It_��;|L�1��)b����k@��U�%��pI�R3�P�Ĥy6����Ï�_ޠ&��d�I��XO����W�fQ�͈3Ζ��pzu����l~��"\��Ğ���'�]G�u�0F��ԁ�Øj��� �Ӣ�Z�t��pP�6-Ӆ�H���t�Vs�N3���-�k��O��q�w4���MI�]|Z��ZJS2b/��M/�I\X)M����t�&2 ��A*���+0�
P�4�w�L��^�0`v���4oz�P�'��f4J�j��c�ZԈ����=��_-qaWkg�������XjOHqL�!�o�")L*��_A�i�EЪo��'c��J#��/�b����$.�J5ꓧA!|�������JU�֬�ǠgԀߥ�9	����܃E����E˧I7)J�ҹ� /m�g����k�.\��1s��w\MQ�+ρ��.N��at��N薉��
��뱊�5�t;�o����q۽>������>,�
�1�~�#�9o��6��,t���)��խ�"�\<�]�t�H�]��)m�Y5?�2�:�#<����#��.}6�U�$ �V���$Z����ՌJ��͏�/�����Je�_��2+TI�:w�%HL�fq�w(b�}�m���z<i�z�KK��
�u�X��V��
XB~F�^
9(�%��&G6��2b��#�VF����w-���܅W��W���p���5�,�$2M��]x%��-ߴ .l�B�$ȶYn_�4��V�0c�x9؆��ƩǁWdgc��(c�y!�}=>,cw�S��rx���� Q�8��¥^�	�׼����1.r���U�?RY.��e9��2�}��&�,G\ز�%�(����8WpV�aF�\�ד#ϧX��&*cL<u������(Ӌ_��k�*ސ���)�U %6�J�2q	y�R�b��QйG�����?��~���	+J�$=l<�=�x��39��ZϠ�t{���C��
�������*,T)�I��wx�م�ޖ�G�}g���y�i���K܍C��U6R��o�wcg����7�n���-t�������Cm�,���H03�� ���x���7����v�����l�B�\���1�Y��5q�c    �©��S0�ʙƨ߆��n�K3A �8@IL����dBo�;�ٔ��;��C_B!�T��7��ASD)�nU�U��M��q�׉(�9^���~Zg�$�Цl�&�C�v6�ê-z��C��>)V�����.0 �x��}���c����ߺ�_Qy������O/�z�k�DW���-��/FufeZ&n�.L�X�'��v�ů���Y^���[q-=xwZ}�t�@��ԑ2��Ha����*����\��tI�Y��d�XH�ɀ��Ĉ�.5sH�a��p��O�X���WK��Hmz�����![ùu��x_�_q-\j��Ra�p6��>w���W���Ql	&�&�*8�{<⇖�
7w�1)6�;ɏ�o�a�厫�W������~��~����~���	'�r%5�0s�E�T��7��Zd��+�V�.��C"G�R���۠�G��~a�����K^�Cχ�:�ֻjq�R�j�8����/�(� �yc�.N�s�6ןVY��/\���r��	��廟�Z��(O�K�p-Op&.u�c�9C����n=�NۙN��$d	�'ռr@v\q�i��+��vr�=�ܥ.�k���y@�ô�'��hˑ�[6�h�˝h�T&fc�.7Va�Ǥ�Ç����[���w��x������K��_�6����i�$�*��B�Tlc��0��bh���s�RoO��l{��tW倱��
AyeO���-��Y��16�P&5T�kϩ������ΒQh�P��a�{O�Q�@څ��k���C�Qce)���_?���~|��;_�K%
#�*�r5�'7]���.,
���i\�C�!Y�0��OfCe ���d���,wa3Z�Z3�q=њy��,��`���֪�F��.4�r�	6�~���S�E9�ب�P6v�<�'е�gP��	�[&�V�p�68��9V���w�2T��a ]}ڨ�x��Pdmm��f8�0�:�m�0�b���1Ww#��P5>��*�{�̿��I��I�����/�@w/[&��'.���c��������T�AHMj|蠂jyC�1UQ�R��42��󌴼&x��987������O���o߿>���=�ZO�2X��X��b������,a�)\}z��c7�Dk�%�5�
�xM�ta��KM��αH��lžO��S�Q�b�(���B�Q�8���Kib2�҅�	
ج��ϛ'�7��`A�[����H�j�_�h�)���0H��jŧ�O?���]]���G�C���r���G�FJ�>i�#�@�¸���&>�&.���6�=u�r�ъ�
=% ���pa���/���W$.}�c�!�u6�.�rm��;k��2n����7T@(�\�� q�G�r�J:��B��y�_�ҩB�fZ�q��|kE[�%��鶴+A��t����0wd�&
\��Ƌ����ʓbF	�7AE�&>�".�$)��6=����}2���4e���+\~��7�;�r]m����h�]N�j�_l��qֲ�C�V�p��c�d����plX.�d2%�M܆8^�Fz~$�Q#EA�0B����-�i���".�kn�5|��"��,�)"�o� Z&��B\��	�δW��=�~�>��nJLf�	�XO����<w��)2 �I�t{�w�����S��/X-���n�MS�w�gȳ�(�aaw��`�$���$���@�AZ�ZU��r{�d��~�9�.�Y/�j���9��߉;|���'17] �.u���.�L3�鉁"�ܯ�[��9ލ'~�%@˂�
���FPpOi�d`��N�{�<paoo�۾�0���� ��g� �@�{��7t́*^�
�`/���e�qa�8(g~�a�e�pf�D���A�R�n�tad{���B3�໘}5)�p\U����]���qO�Q)E�ɚu��C
�p�B�2��R�R//ҁ�\�H�^M�iGg��<��Z	�x�6�=J�g�2q�p��9N�����@u:�KkI/.z;IDhB�<!�צz��K�w8r�����KP�]��&�惰*§}�cʱ"p���F���H�9�vW����-W��n3|-��PI��:�_���_BL�{)\� "�����#����(��Z��/ٿ��(������G��P����9piq*���2^��ߎ�j5�<�R3m��+q�%�*��[�����Y��:q���l����f6<��S�qIQdy�5�JsEĭ�a�N�4b�ą�\�cݦ&����4�`Kw����ޓ�����*g}�c*�&*�a��^�����[A5"{�N׻�](�Vb1Ck*�
�K�zkT�ĭ�p�֨NJW�z���j�'�t��ٴ�l���e2ဣ��£{s�\�>}��j4���SM��H�E�vﭨf/D\j\��8��9L��W�pa-��H��hԋ���	׾a��Q�8TD�H��_��ͬ
��|,`t�R�Q"4C)qX&̢��&�B\X�
�'��k�� lz;=����%V.���>J��v��wI��8�u�(�P�t�|�]�L�VM�78�=�O4�q"�ӥF��ڊ� ��l�،$͚��{���&W���ө�cs�7#��lz��OĖ�[X�RC�pk\�`o��a:i9,�<:u���uV�cLH�p�^�}�im����Jn�y�[|�[u"ΣD]%͞�x5qaA�j�??E�ɫ@;A��s��l�(�bm�H�o
��K�������u��\�ZTdĘl	����D� S��s�D]�R����@B�����!��	��V��<Հer�,S&��/\X�=DyFE��(ùH�	�e)���>E>�t+��-�1.5&��6!�H�$@U�I5TՅ(�cc��ӴkV-\�*ҡS���ǯO�h�	R�&U�3�#FP�6�/p�[�f�:g����٥nL�L�.Vp<كU�i�0)��4��'qa�OTX!����3��Y��Í^�*����:�
���bڹg��v�م�{�R��v
��В�-]1�L�\�{�t)/GL<S���L-��R���S+��}~r�Q�QV8Wͪ�7-wp.�[������o���lH"|�Q��ij!0���%�����R88�J�1]���.�H�8w����v\_Og�|V3��J�<�<G�q��b���X�.�cr��(�5��3�#�o�pK��1���ũ/ӏ���G��K�Xm�e��g�����i8�%0�>����:�������&��.L�{��V{Q�����bE�6Q��$e�z���[&>�'.,a+���Hx�0��A������҆ZcZ&�UB\�
�a年��QP���ׄ�BB�[߻��O!sVMC�D�<����?�`e��\?�)�%�ToZ&�~k���&�1F\�Cq:�w`�����]tk�MY��8��շL��^�p�P�:��j��n��
�>���4�|#ӆ�}`�i�򁡵�o���{�׈ ��n��z0�sid@X"6�س-�q%.\����S��n������%Gb^F�c&LB&(�1:��2�*N�]�A`*R0���x��M-	��lf�q���R�d_���C��5�B��Q�V�;Y�y��˰U��#P�H�xYE$�M�B�K����0}QW< ��]l��4 �5�m�q�o��'Y�pO�`xIu'��n� 
�2~�T�~�a��u����b�ч#����kc�Ϭ��:Д2M�>��������'�"�R�uJ����0�	� ���e?؁,�66��j�2�W��U���K�������45R]K>+^{b�9����{T�9�:�i��b�@%��/x4�������d�Y���GRI��+�V�UK}�n�|e$7���D�U�%O䱧	�e�y����=w�@vr�/�o��%}���ˇYQ�Vd�#Tx�/�xH=�'זΆvl�@	�F��d>$#����U�������lfu�g��iu��3:E&�&I�(��j;��rnym��    ĥ��~x�5�������l]�|�>|��-N���L\źp�?q�R*S_����Q�W��v5nç#U�3�/
~���k�M<c������`S�C<^߲�uA�2
���Z�L�U��1�Iqa��A+MQ��`h��3��� ��e�������u��?���*��x�������7-/�C\�\�`�)i�\A��~���负�,�S:F�Gʵb�d���-�aK\���	�pNd]��@���O�@&�(x.M�w[���I$(� ��[�k�<)
�� �@�B�[&�D\��f�R&%��Mw}��7��⹌A�w���Rw���`LL��ta� ��E@��?�v�8�0)��z�x磜��$�K��i�[&�(.\�5b��O
}�z��u\���Ul� 
�A�u�k��Wa�* �Wp����Z�DB���X�$E�2���I/�-\��eօ�Yc����D�����A�=Ϙ��:��q��vh��ԺpaRk��J�����i�-���c*V����^FDz�7�k��=Z�0{{���Qx��Q{?b��T�0��%�4.Njr�a�#��-Q��K����ƭ�W`�<�[�@v�|>"�1�!qa�{.p^�����P�Ȩz����Nɖ���.�"�J��`̸?^��N!{t{��G�G�2O�����e�U����"��R�- Pȥ�~����s�s�~��}����?����O����	��uN���m5��b�>jx^%ک0q��p�x
�)0�	lC�9	��>k0�V>�����n}�j� ��;�Sl{�)�2�!����'%��Fb �:n���T�1�3ew�{ح	ߡϓ/ff���NF�3&&�+]j�����Z!�@6p."�0�f0nh���(q�p.�H�9��_T���1���_xD�TC�s�h�!�,����9�̑��|d����P�.��r���ay�'�{|kJ��Z��D"�Z�o-wa��	v�o�N�]�o&��y���*K���=�+���g�e⎔��S��`-1R��r:n�����0��Z'Iv�Z��vFu[Yr���j=w�Q�*a��f� ZoM8�Ө�����M@�Z�2=�,t����yR��n�uvK�0q���@vZ���Gl���R��DV W��(�������ġ��z����"x�׻�lWV��>;}*�P�����2q�[��I`�<����~��z�����>�"��X���a,�;��-�+\jt���p����ޭ�h+��e�Bw'���d�:��+ .\a�39���ww���7�mD\Ղ�)l\ï�nw�2qк��� ���^ތ�~�n��8��@E���J����u�S�4�Hm��� �Ľ��~*�nX��4�0$��L@BHB�����"� ��H���-�d)\8�ʀjTs��n��q��,�)������DK�6��]ąU�:�Q�e;u�LhKr:�(��B(���)ag_F%.\Wy��M�5�;p#�jJ���_;^�!t}oM�ā��k�Y�f���q�MP�N�-��#�<K>ԻYG�n�x�4q��h�2�r�v|��;2��|�� 8�Ìe1[W��[�pa 8�[���!�p�cxɹ7\���c��'��&N�p��!)��kD��ay��l,�a����&��`,<;�|��t7K�z�NXk)	>�n��>}zz�����//"���FI��O������S�Ǒ���5�Z��p��%RK�9��W�iDxM�����u��JĦ�H!�w���\V�zb��{�PV-��
�Q���Y��ݎ�yୢ4¹JC�pČ�5c��s�!�Ii�tx<ӄP4�Y���TL s�L|9����=��H���A[1�5�c�E�VlVԗ\@���l�.�Ys��j�8[���ǒ�
)6�P�ʡ�=8��"-Ӆ;wa�F(�3��F߿>�|{��R��(�X.c��Cl`����] |=�݆���2h.��T���y����H��O8V=�LV:��
�)~@��|�����V+��ο�;����ǧ���2*R�K�5kMcwP@h����MXk�W�1�&�ֆ!�K��9���-�>_V�%�]�Pl]���ߜą�(x�L�� �Σw���Zk���`�J�ɫ��BT���KĨ�T���77�;ĝ�P�P]�)�v�]�n����k��^"q����{ɩe�yx�r�E�7tǈѶ8�
����Z����d��G��f�u|�R���ڱ��2�uT��N��8�iܬYr�����'+�DZ��x�2q�t��izj8�N�i� ��D��=��I%���r�^��6�Y.�F3�2j���y)�X\�ɀ?��.�*�U�_�PR �����Z��G�HR{���v:���?v(2u<t���Ͳ[�A���ټW�3�k�Hi�1]����yU,P�h�!���浉Kt
�����/HZe��-�;6�%��j ����p��s6he��Vy�+p�W�Z��y��}����8��'�m�9�o!fŔ�ahX��z��C��wAvK�9�w87�$�:?|���5���#'k9B�P ��m����A��o
�FX��1��6&�P�۔wz��~�saLO�$�MT�r�z���gg���f�e�D�IbC� �	(�2�M��6I�ZPk(�����܇���q{9'��A�0�YaߋT�&^��p=����6I����fg��p*V,��.G$�&.,)\8��(�hR�u��l���͇����~{�˾�~O$�$_��a��i�x#q9�y8OA0� �|\,`�ҍ�_z!J�B:a3M�x".�.���-�L����Y�H�t�p��`D0��s�����&���(�59��_0�������0���	<�%����]��ð�Q�����zJ]�$2��B�����EK�>^-r2�
�2�1����;E~���.VG���1�C�ڏ�eP0ʸ޵L<���l<�%�b�y�;t7��NEf��S>�P�!B���P��y�R���3q��%��H�������և�/��5
�-����q��đG��^�uG,�ۆ�[+��xDX�O������SYSyc�R����J?Ȗ�[Y��,;Q���������0�BǇ��ʪ0��m�i�e�icą�
�/�)֏(�����Ww�m����C)(i d�-�'.,���z�S�Ep~�U�~���O⸶��AL|��p5ki�,��0���yN�z(�b�mAdSJ���{pb(�����ޜ��pvoP�s���6h9҆ڸYX=�YFL|툸0�L�I8U=Қ<�o��Z}KX,��eo
�ya�շ���et�_HFB~�V�L�QD�ۋ��W8۹
&�.��Mc�?�٨�x阅�L��~���.�#�4\B?SC�p�g��M.\�CkAE΂$N<z�ǓF{5��d�r�f� ����'����{q�LA�g��TQ�������aJ�01�����O3R*Ck!��a§.��C�4q��¥Zx'g�P��2�����]z1�R��|���Մuh8+��W��o�t�����i?6�KA�Ff5�n�����P+���=ꂙA�h�C�1nGV�:Wv~X���4�S�gf�*��ս,���t������W��p=���CطE�����NZ⑩}Rߌ��,5q�+*�t�&8�b`�2q�b�R�P'��g"{v�2����j��_{}\�O٠2�`��.H�v���p�0��[L1÷�RR.e�u��(<���x5b��ݕ��?(W��4~û7o��ˠ���Ӑe��Xp��Y����̈́aL�ZB�Rw^�T�Kυ\:$P8iB9�$�M<.����t�/}RUL�دO8
϶����y�J�3�����2٣8^��3�#�݁t�g u�p3���ʙ9�Qq�i"���u��"s�{�_����n���!g�U�*��L��
��
F�C@HnN�Y���: ���q5a% �)�U*b�N��Rb���Jqa+Z��,��q    �8&���[�����(��FI�~d�
��JaW�a�e��/�K�V%9�����o�
D)�Z�[5�w­b��T���]Z�Kݙ��I]�P���;�����	��3�$/Ls�r$�!f@�ɖ����!��0O�������&O��&���ZE7|�&�B��Q�,y��a�t`i�ہĥ~ԁc�*X�Q��V��L�� ��pQA	�e�p4�.�"� J����v:p�^кN�!�����@j_�".p"��Dv�s�;�����C}B��(�p٤O���i����hП3�w�;,K�OҒV� �U��P�zls�L�?s�����)FM��$�˷�U�eA��<.H�S�++��Y���J��I�^�
˯��.�o�+�+��Y@4a;�2]h��.���ik�K���=ė�;�)������:�s3P������4�pP����&wa�/�:5��l���B˟s����r��S#B�� hϲ6]���.<(ĥ� 4� LI�ˁ!RQ�i�)��ed�>O�=�4�q��=]���M��r��7�u��*�Ҹ�w��������C"�_☣⪮ Y���Z�e��qr��}­^�B�-�!i�&V+��[Vc<�s�=D�{�Z�X�@��`�J�G��GK����r�'|�lk= g�.��P�r�0Q��Fz����Yj@�f6�8��-�Y��2qŁ+`m�?�pލX9]E�nu��7�&v�^=u�5R�P�)�vS! S�C�x�2��ą��8H�ą:LaD\|��)ɾ�s���깇����5B�L�s/\��d��0��D��������_v���T���O����S�;՘Z�ȅY�� ����6�5&��֘ 8�W���뇟3�!��߆M$�?��Xb
{��Ų��L\lal�m��E����E:P�\��txx܅�������]x���_�Q�j�W�Q�i!��-�.�K���WC����Rj�&�0-��Qamu�NQF(�pX ��.P�W-�,P��c�$�ם��_u��q�����9{"�n��\�,�¦i��sN�G�B��������_nL�C�/�hQ���p��s)�g�A�D��xT��Ϟ<�>��� ���wnm��Z���O����w$TvW������ik��DB����UQhrӅ&w�3�����1�9f�%j��G���!1�q������n��m��3S/�G�I�ϰA��Hk���.L�r.yѐ����x�E����]C|�d[}�1X�x)�Ac��cE��ŏ/_0�F� ����$����3[Dp;xc���E����_E8�H�\b��[�����Z&�G\�O�T�j���f|�n\̊��a�� �R�'� l>ш�����!�n��|�Tm��ʣ���HU�3c2J�B��P-�@Vc�ޛ�C�t!�]�0��S�y�׼fa��s`?yzC���Dq��r�Vmb( �K� �0� >�=D��G߂�=!�����V-+\8Ⱂ�X�� M��>�W*|���Z��������<F�?e;��9�͒a��=d����8����^�G�Т˫|����~����O��_��>w_��
��%��^�����C�sP�qNI�= '�� ?#.,X̘���l�Py�-�L��-�B�®�D+��H���4A�9��������anÀ,��6,\+�z0��0!����~�Zt�ո���$!��T�&�����s��i�.U�8��Y^�����v��؅�OL��O\�"���?���j>VɼٲAt�A�v�ß�6Uk�]�'& D!�tC^:,[@Q\N��YA[@��I�K�;��|/N�
���^^&n�!v��g\���
�S%O���N�d��ԡx�`�Q%�Pz���!;i�(0���x7�Y2GYQr��t��2�!�l�x�q��'�Z�#Y���x:�N5���m��7�1 �髊mn���G��z�OP�w8��4��:R�,el�\ի�,�Q�G�j�ݨy�u�h����~y���4���d�	�OL�Y��a�-'ZZ��8�K9�b<�wD��8z�-?~y���������� ��XJK��\�N�F����R.ղa�𡟎��3�[�%��w;�X��h�VN�7������o�A
9��e�,e��"�5\�-XZ���:Ȁi����pa`i8�6b�� .�+p?����I�"~���|hD�/H�l\�[��_�����vU<�]�+��]�(����p��,`�!�F/�^�L[m��'�]�p �$ښ�~�������0vw�^��S��V:(�wds�/GHw�.L:(q��i���=�ވrC���&��i�������M�0K�*E�i�q���"}�Q9��t�!���'�Rl;'!�E�e��Z�Dj�o��.q��(N(��2n���q���~�ގk�۟�ڪ\�!�թ�1�^�6ue�"q��L1��*��P������Y�)˞f~4���Mڅ�/@�����# w�Q�����������~�]����
���������B��!�� ����Qm��¥�=Z�7gz�nX�H+��w�A8ߘ�0ֻ}����BtT��[RR��<���E����1j9��6�yl���=^Ǿ��	G!�d�5!��%�[5f��}%>����ܣnN�*��'����z���k���l�e�ҥ�D9�a�l�H�����*��P��/��|��!��%Vu\e�ĳ@ �j��T����y�T��cV�K��,�9c!qL�B\���|�������9+�2�Qq�T�p��|���uXn��]OȶC�v�\;���tS)u�u�~���Ō���K�V��w6wyއ�׸����
1�y���|�J�2b�G�Z�J�{��B(�5i���wAB�4���˫DHRO���������)\8R��A�
C#f&�FOOz�# �B�/��-��".�J*o24ND����3`F�W�ޛ~P�|������0B���Zn!T��Ӂ�9�l�ԅ��U��&�	�4�ĥ~�X��9������/f�I��&mbYF�2�)�^X]m�E�R�p���d7�Z��Cw��7JK �t��壪�Pb�'�V������o#&3�x �sdء�[-�Mܠ��&���*1�U������s����H4��m���Uw�hC��;�&��^�pUwi�9����MQ�nĻ�{br�B��L:��ႃH�w�e����]����f��9���WT"�	�Q�8Uf�t$hi��¥.u�;e���8��M�I>� U��0{kѻ�ϙе�S*\��MV�"����qu��Z
�#~/0OJ;����z�a]؜�v����ri>���"����ةrr��1�۔��ږ���k�Z7D	⤡:�1�]������� �P�'��C����V�����=���DAͯ)���T/*��8`�)�2�P	��#��:���f�b>gpz�j��D,l�Đ��aa0��G�^!�C�JA�����O�{��3�	�: Wz���7M<ݙ��k£K{�۷}
K�gpn���S�LI�Ma�ʛ\u�61�t�R�5�B������\��!gڗ�<����J�0�������#9 n�����?'�<t������� ���ϐ<�4�z����vh��C�p��(�h;7�o��&I��q�8)%���7��d� �NQ\�%O����qa%����EuD�&Ά���DXbym�ьąE3������: H�V���?���\��	�<��/d�tAQ,w������L�o��-3����}�re�la�B�[&�IO\��"�==כ�v]�a����HsBr����BC��KsV�Si���ܙ����%�ۯ�"��0K�̑b�ND���뉅4}+i�B)�iD�]�r��'�2���
i���$:���������U�뇧O��_~Cȁ"B�5%�� UZ5M<%����h3����x`��78J8
#�E���j�Tn���    �8�q�d�^^/f��3Jr��pC���Bkk�n�I�e�^�D \5��?�z���炆�=}����~�����?�����@:��XKet��B�(�&,-L����(�W�<qD�s�`u1h@W�b������]�܅���:q�����q�0��jR�u���bZ.��զ"O�K��/�T��ތ�-K��(�t*�������@+�}yH����y)��� �ܥ�����6��i?�RpN�שm?����o嗔�17]@q�.<�ۜ67���Md������wd@�A�L��V�Ԫj6T���#�����˷/�jݟ�=������}�w���Y�����ZP����51�$6�7��MZ.`��?�{����ֿщAe<�͏��O_�2��&��G_�����_��|�����|���ݏ?"�[��	?]e4ԭ��Wd�j�S��}R<C)�5Q�{��˿�>�^�~"WS�B��3S���Ɇ"��zf��g&�)�+�?�Bf��d�Y����/�H��)�-JtxG
�W�_	�m��m��i<Q4�2C� ƀ�s�T����#�
��La��6H��B͐���8��R�k�xP��ʀb�"Ê�/����y���YM(�)�!��3&>i&.��V�Tڠ�.���?�|���k��l�"�@5��z�t�[&�~S��(��o2�:�l��A��<;��̘��pON�N����$pU-ߣ���Z��1]���.l-ߥ������ �4*H���j���Z&�E\8M:-�=�J�x*�+�i��L��5�Ÿ�邘H�����DK�W)�[ra Nx�*�b�``�M5eM\$^�0�U�x󔗿?������çO���ϸ.16��:2�i(R���{��`l�E����q�"'�W��1��8=
�I׷L\NP�p�s%�!m������$@�u��s�+uz��tql5�67q�SwШ�	�(@�'�q�y� �����Z��|����F&&ц[�X�?��#N@��;�[#[�0s��?�j���3r�z�D ����	��>W@-�b�9N�t����4�ek:9w�9a����o��
�a�4<�5$�	�A%�+�EP�� ��pqv���LM�i��,M�(M�`��X"�P眷��A
�zu�ʭVD�����/�ݴ9�M/(�!{�C(�Xb2D�e��R�K���e1i(���-��t�0˼_ 0Z��BS%wa:ݐ1��KǱ��]E	�*[�װ��k�xU6�ª��Y��z<��-��W(�DN̜e�J֠��o��vq��G���P��Mh�Ó
@��>�"�p��L�1q\�¥�RzX�P����v�v/DA.ĺ��Z@����2]h��.l��ۣ8�:�N����2��
�(N(��Se�;>ą������y��Z��ph_R�$*�՚1��l#�7Oj��[3�ݝ����_���
)$4ĥ���`���g0� fb�Z�0K�+�ܻ8C�K��WL�2|�R�v?������!�#k1.\�$��BRg�Ѥ�D�i%�Ua/D����M�L-\x��O��ll�� 7��r��ݑ�إ.N��\��%��K;l���c�9FP��bE�����[=`�?��oW��oY�w�'*2��������K��<P�{�"���O��"�>H�e!}��E��
�ՙ�Ț8�o��a~�WJ����i��d>�C��P�V��e�ALp�<���&.�!t$����G^Wo�#s8K��*�����չ�R�����n��Ap|R��o�=
��V��fס,0TL�F�2(���V�RM��x9��D��K	�|o��C��/�83�i���*�Ú>��ge13&.�+\�|A�4�ǖ�v|ċ*��Ȝ��#���)����2�i.qP�Z&�TH\� ��t����?�gX��|����Ր}񌉯���/�YGr\�r�͌cUYUK�W �b�RC8��ڏ�K]�R«��f�ޥ5��f�d�]��7@�+��[&.G/\�5�*�zՋ�<�ij[Z�ېrf%����Lpg��h'�[����$�����M8ɭoɏ!w<<%��i�P��@�D�T%|;�>�xV�;��+�>Ff�E�Z����#�N�Y���9�J{���S^��e���I|)́�x}�j�Y��#Y�e�1�ąE�n���w.�k�7��6��j8"Ő_���;`��C�(-���³�{�G�TE�"�P�xb�AąU]D����'@Ճz���}�)�c�8Ң�M�R��}����T�V��RAzEg��Hx����lA�2�k$.F�'9Ke�9��6��� 2IHT��$G1H���q*B���0�L<�����48�{V��un�m"��&���7����}>(���0���kOP#.�̆��w���uxs̈��q�<�fȎ�n�
 ��b�[�R�2q�����&N���m��Q��m�|�|c9�E�k�q��i��bx�R#n�b��;�����uƫtiV�	�����8eҐ�x���C&��y�2q�_����(X�y� ��t��~��q�_9�΀J�/��i��O=�E"Nv(�����8֋&�*no�<�Y�^�L|��0�^�$T�;l�)�s,O���w�h.o{۰p�c�Q�+y�`yF,��˥�
�T8���ڷL�9Y�p�3�crAȭE�a��wȅ�!M��
�ya�cU�����
��E�C/��օ��W��_�����:"��uQn^�#�m����S��1۷L<.��Ԙk���������8N ��M��'.���8���fA1�:cQ"?!*Q��U����BL|σ�0�68F�|3�W��]�B�4��
��X��h���2@8Ϭ@0IT�"6h��n�xq�p��s�sp�����	2M�˻]����Ǝ�ws<F)@<����<�{pbIH,9S͏X9,��r�|~(��9�w�y��0p�{Av�>&ȞX��m.�UY��I��aKP�&����L�˷��##��9Y��
��6p�v/L|w����]3�Y�����f���(��8�_Dԣ����8E�*��&^8����š�bV�>�c��hZ���R!�#z.�2�,�ª�?jWN-\8D%��W����5[CV�C�I�E/ܐ��kW*\��Be�J��U�^
�A�Y���b����BM�/*�I��G�&|���@�j��D\X�&-�t��{��f.�8�!u�(�'e�@tcZ&�9R��uS��yt�R5���x�sgdЎ���ئ�c(wa�㨝���g\FztF�-8����D��]Ř��\�R?��p�G������c��`��|��	=�,m��-��.L�֧�mQ��6�Y�\'l����[�
�u&�$�"�]Θx�	���L�>��o�速Ǫ{�}���w���Ε�x��E�x �`� ��Ĝ7�K�u6/�~wq�T|�.W ��K1�׽�F�L�S�0��֧�b�ՙ�ы�_.��R6N|�2q���r�j#��T��0�(��@(�â����&.�-\t��'�,�
g�f!��M>[�"�_8k��6]F$�\��	J�6ͺ�"�	y��[&��_�TUdX��aƙV��wˤ�k$�PΓD�dY�y���)\�V��b��U���b��f������vM�� c���J���ka�g�k��/]D���u����;n��?�q{�C>P��a,Mg��Q�ab.��ǒ\�t!��]�&����O5u����  !.u��N��8%pȮI�
�	"CI8C�Ԧ���.u];�.u�}������ק.Vt]a�b�A��u�@�q��F�}���s-f��~[Sw���Z�}�ѫ!�ؿD@�u�,�����;q�P�J�#f��^���ߡB9,��$�j�<���m��l��$����S7�����ݧ���t?���s�����?�������O/�z�Y�    N��ux~9�����#F.��!'�tSi���]�Ϩ_'�K�D?�1FV�2b�Ją@����X�ǫ���ޝ�V
�����o%���zG �m�.\�53�V�ѳ��.����<f$@�t�=�m}��K�hp|.����o��9�[x�"���u��!���+��î.v����y#��j�Z�Z��Qm.M���"cm�Y�ąe�!�x<��:�︇��-�ܶ_:��3�7�����=�Slp�O��n@m�b�Li�.�¥��O>D�߁�Ї�>���jw~C�_�����'e��2 ��Y����{n�PY�]*����C�#J�/7�C�BⰚ�%�r�����&J�ح�A�gc����م��C��ug8#��_V��J�����R�c�����:׶�M�9F\�sL����k3n�sL�A��2�<6�e��}��C�F��R�{�-�x�š��>���� �P�=T�F��u���e��'��c��X�����v��إB�f��!�x�m�}e{-r�-C~GH�Q�\.`���a���ܣ�Fx9��}s�n�3~F��w��!���*�P9�h �����&.�)\��b�>�N�Y�<]�V`�3
ܜ�{��?+�w�?¥j�+c3���˳���7r.��C!+ԇB�.��Q�J,��n��o��p�Q�*I�����A�#V�r 17�5�Sh�S��(]�uaƫS�>�o��iYv�zjTZ@ai%1��zh�x�$�R��a��7�;x�o�ո?��H��,���F�5޴L\1�p�Jj�E���m�������}yK�X�#o1��F[�����_��M�N���Tm�X���E��ptL��0�K�!qUs�9�0��>i!hK�4�TO�d�ڴL�mX�pR����ø���	b`������#�Mԍ��ph�.(��.,xV�4�d���1֫���[��nC&O*��15�Z*@���z�o�x89q���x��30XOC�z����	|���2�A���xu��~��C��0h��u��X|P-��]��	��L�i��Q.�-��uCޢ���`B-Ӆ"b��7�MJ��,K���^��1�U���nގ��\�pմJ0´3��ۖ���.�>���n�=��l���_�=u�q�h#�h�$���*>h�.�"�9[B���Z���vgZ�sZ��t��OU�v �Ԑ��G(\8� -�G:�P������� H(1����#&�b#.��!��u����;��Ϗ0���Y�/d#w�OK�%�2�D���ݍ��=�>bx�X�Ԑ���;Y��\�-�w-�W��� ��|�ϵ�Lo. �S�HSը�\�p�$h�=�a/M|�M\؄[Z�%ܛ�p=��a��r�N�#trB�@6x_����;��#��&���-�َs���v[�.b��
�(��8l�/ѓy2��g>���f�`"%�>4�Ǉ��p<`#/���DD,�O�|�O�6q�Q��	��f��gp�0^�~>�O�y��f�t"�5�V��
_$�X<)u��wĥ���*Z�7�p7s$���x�\th,�nQ�r�,6��ݻr��t�ӕ��+ǣ�)9����^��P?,��C�s��FCCk��GP��6Z�µфђu�����0dM3}^k:��(���ܗ6�&��J\�2��z��e��ǣ�|F�L����CwE���:�YL�m��6:ޖ9T�#=���#����C��3l*�w���؈�0�~mCa/�n�\~�zAA~���"m,L����ǐ֐�;��E-[���p���]v�V7i���B/Ӕ��b������BS&wa�2Ɯ��24��j���{�~��y��7VoCm9��6M��Q�­��0���a$�b?	��,���{}qho!l���6B���rpdXe��F�]�6��Y��C��>������4FP^B.R�O��E6wa�r��GZ�ybZ������P�$��X	�J7��5�21��t��ꄇ !{��\�L���JCR�V���Icsݔ���]�K��b�`Sia�Խy���{��vQ�;��!���Jr�P��P�MH���-{-\��, �c��>�W�c�����Sȫ�ߐO����AL�޶�C��U��*���Oq�Ig���O:�{���pҭi�xh,qa�P�eO�!�kF�$�8��
"�t �{�^����8������K�Mp�Ga_1��e��]���Q%b:�8���Dڑ��6�)�R�B8\����/�����H.��%"6�*~�mO��}�g=�������H�����<�v�g���ok�����(*����IM�s7E���&1¡H��� %�H�6]�pr�+�I�d�M��&o�Ό�Ȇ���j/��g-�?*C���9�[Dȡ�������?���e� a��?�>=�t����_Ð�>)^�&���a!O�&r������$�X�H��X2j6�_���5?�G��A�xP�VD��\@�d�'�0�m�O�}~-���NمS��`M��Y�pس��z=��f]�&�i El��:Uk+`C�K�r���ĵ��5��D0����У�0��M�$�j���.Aϑ�т� �Q� ^��-_c!.L�5Q���1�;���(���h۝*"
���!p�ԃQD�-�9g�ݏ�"B>� �e�q��]�Z&
[�Ե)���G��S���R���q�\�%�|"�Td��|��h�������H��.�R�T��qTK�z���(ͼ:>L�����=&��;\=���g`Ld����pć��@<C+��R�ԈH+�vD��J�e��⥇�&���|pgE�ⴌ]OY�u�&��Q�pht/��5E����=8�ŧ�,�4	�I�&.�,\^lc!R2��\�i|��#�֛e*��{���4�J��H�T8nM���Y���!qa��������װ�pd}�J��t
��ئ���
N�!��0�|����������ϟ�?v?|���5][-DS�!�!�^m�pm�.��էkN�C\eD4�h�фqP�GiP�i���ąC4���0J%��2�fN��P�sD��6]�/s��#Q����Ìȯ�l���%�Gb���ץr
1�-J�¶(�I��8DA���tD�}��'��b�LYZ����BA��kW�)\��M@\dś7���j(�ki��+31��.O�j��H��3D�y��u��슜�Z(���X@(3�e��ąQ�giԩp����"��
�n(Ɣ�Da0&2c�"�5M6�p����%ͤ���K$�8�	�p���(B93q�sfm�x���s'���Yw5v��~����wW��>?���4i�^������z.��L[z3�Q4�	>��\��{Auג�Y���Q�1�e�g��Ih*�X���N�g��^��w�����[�2��#q�h�
�t�@>���J��0u��P0@�|�,c�%�+Q�xu;.�Ǔ��=BL�77f�)g��D��p�-�ֵLLB^�T�D�!,�,��B���JִI/C�A@ p74M|��p�!v[3��4�,�ׯ')�[�}����U������c؂#Z9U��
��*\88��O�u?�nP;�0�-G@!UU!UUn#�2�:�ĥ �@
��^���W��D.8���I-�A��-/�D\8䂴ҒEnwW��d�`���R���d�0�tp�j�]��7[�K����O�wanf�[��|�U�`�r16�[&.G(\���Vdf���(ݵ�B�Q�k0���k'�S�pb;x���{�߽[n�7��u����˷��ߞ�o^�?==w��N���P�������b�蒨9���c�~����HR���A�9ƚ!��!ǡ𲇻��Փ]/. H&tW���2q�p�� �����i�^��"����n���-�����OqP^��a婰%{�{�[&.�,\�/�K�4�7#x�-�G���N���*���F!��	�Z&^z�    ����j��;�_w�G��fz�,}�y� ����-Ӆ登��S�k!�ĝ���TL0!�1�FҸ؁��ebr�ҥ�Y��?C{nǻ	7ો�U�sU��h�iب�e ��Kj1����p	�J�]��@	A}�{8&&N�$���P��pM����6�εAd�@ف&�%+�_!Va��e�Yiąe��ןxKb�$4J*�SIY�AbMB^a�Z&�D\8ʒ��/��ۇh%�$��|Ji�0�z�cTnZ&>%!.�,9���p-a����ʘ�߾?}���{,̑�d����\�z�4��	��B' �<�����)ӓ͠z8&�o��&�����ȏbb} �����c.��N��{�w�w�3�j�{�m�7pfA��;��N뀉;�@.@�"Q��b�&<nK�T��bP�RK����?�_��P\-�:�#�$���}��e��17v��o�/u^4��IZ��4\@�|�����.�SCE�7������O_C����oO�O!�������;�ۇ��OQ�r�,����l���7|m�������Fˡ�,u�����H��r� ��*���(�S+I�촖��z�Y� �2q��� 0XDJq����.h�����hD���`�HO�?9	g�K� Xu��/(wa٨�L��M�|F�t��k^�b�qUP���p�K�&..\�]�¸�IO�#i��bK~4�Z{�[�[&vR�ԟ�A���[����E�=���}B!��
�8�]��$���lV�$���%R!�N
��s"j�&.�@��Kq9.f�*�ދ7��v���&F��t�3��b e��E���!]7��X��H�����&1�%�G��P�0`ƨBȭn��;�p��[�i����]�Ӏ��<��K���#���S%waKZql� 8�����H��p�3%��Q`��+M���]��'gJ:�9M��V�jZ'��t&;�J�
@B��ڸ��o��ⱘ�p�6c��J�X.�${�{Lk��	��|e[&�.\��$�D�!���ܾ;�������.Ԯ����ۺ����V, c'm��������H~��c�v���ֻ�������/�⊽� ��T��F�
���Wƚ�>U�����L���(:m��'�6�i�
�6DR�8�R�����-�(\��ګ�.{u����IEY��"�@:(�9%�s��5]�w�]���>!J�o���	��Oz�ʜ���$� j�]F�|����%e��.((�.��y:Dl��7�Ʋ� u�QJ��Ki�U�pod8F<[O��\X�|?�X/d_V�Pi�c�\I�#�kc�Ϭ��/��(���ˏ�?��������a����`���fG�z���> �1/�tť����K�a������?��<��	q�#����� �1�P�ujD@����<�뭍�?�Z�V�=bHL����K��?�nBge��Wp�Ҥ���1���ZS����<u���x�G,ev�W2^C��Q�wM'�U�0�7��TK����P�ˁ�q�DB_��i�&�X]�p(K��L2Oc���al�}�
i���=&>�Q�9������-�������+����#&�$H\@�ʦ�0�d�Y�}�e��S�!�-��F\X�6�0uZ�j<���2�J:������>���B���"V�V���1L�Z-Q��0���(���R�z��F��;gs�,fUC��Qm(���Z��d���S�s�d�MX���2m��n�EVj4��8���5�
�*�ʵ��n`�*��_�J��KU"�tA�%w�j�p�'-ُ?^����7�A?~�T\�Cs��{��f�r���oX��nXHb2���y�������^�R��JB�Hπ#z���T�.�r^�gHu��/�6�/8����d����R<8Vb���P>ob�7qa�,Hӧ��:4��bZ,/����[.���j��m����KC;	��ш�%��\�xaW�½/�Y�,��n�k!���^�j֧_�/�(m�[x��(	)��nh�x
qat��T��3o�] ���?��������?�}�rb�'En:k��X�T�/t�q)M|������l��6*D�K�M����r{���?��G&)*\��q
I���-�1�܅"Bl�Q�n�p�E"�o'@�"DT�M��q��e���ą�j�L6��0n���Q�l?�^��P�Q��Q��a:$4�x�m�g8H��L��J\����;�z{� k���?�̥�0y���D����Ma�ta�p��������1F��O�c3*��pcI~Ee�ٌąe3*��8 7��1���yNmT^�x�^?A�j!I�kw3.58M��rJ��W����x��2�F͟�Hl/�`�@���
�2qK.\���9���c��ĝz����b�=������#���e�n�ڥ���pn��j)��ՇI�^kZ&�+*\�
���8�ȤD�y��CZ��� X��#�˪���.�s^R�J߹�ޭ�1�p��V�u8���}���,�>����3���]c����:�+��4*�to5� �C�«���譞?��_��ܒX�P��ayI��K6M�t��v�3H��V{=�Lȿp�!�جҖB:���2tQ��gj�\D�2��!�\�@�sB=� �O��������Ȃ[�LkT��J��6��T��tk��].D[���O�����-��Lװ-��]�e�h��>�m�����;�
�`��'�\�.�mZ��9A���T���/d��n���p�>4�a����#�����ؽ�w2ɓ��;�!0�Ź+�a�ԃ���Y���e/*ά�(�{�2]8hs��oSggM�f�k�
'���ҽ�_a��9�]8 �4�Ƞq3���vf��|6��U���ƻ��%�'T�81�¥;��T~�3�ӕ��:A"���Qx���a�v]�Q�#A�'5�з�������������o��CI��JEV�O�f��S���tQ���RǡA���ør.�Ya�M8�,�
����L.&D��_ml��L'�
�f��<��O�����£~����P�����CL�/��������>t�>��'�')r9@F7
�H�r�em�అK}X�@'��ۛ�z���]�i�R����=,8J�o���p���"TU��+G��ǉ2�򏪉2{2���e��ą��k�SI�f�,�tJ)�d��������&��I\�ǆ<�4�f�8��RN1���"�	�Ҝ�W�8 �� �È���V\ӱ���p,����78�^>��ϟ�����cC�"�jiO��C����e� 홻�Ҟ��z���>�q�oRL����w���o����:�{qR3�`!/��=���ߞ~��ۇ�9�Ҥ���!���r�81�%o���\����D!����;ov��Г��P�' ��QP��0�)��
�������b�̄0��vu*��[,�wd���6>W�6a����8V��܅�x[s>��ߡ�Yw�Xϡ���O����Hԧ��J`�ohY. 2�:��ܥ#:�U	e����M����e�	�ą���%��*+ƣo�b� ���(L�8�-4�оi���.L��le"����ġs�W�֨i�22O�'����|+Uo}��Wc�K�jx����X�k�R�ہ��m�֞��A�=�e.��J��.9n���ѯȧ=�cn->3��*v'����>���^Z��EQsHqg��@VE Q����G�a*	�Ǎ{k��kg.b����m�`PA����_G�`�|Y����iF��n�$*��E"����2f�����堠R��%v������s�zY�o.�ItHL�<u����S&��V�U����T��e0�[&aǖ.U��������n��R��pް���_>O[�I@�|*
�k �W�e�*�K�졤]�;w��q��;���v���E
����p�0a�r��Q�| vl�    n�
�E�4� ���(H:�js8�9Zi��nweL��{e��}
�z}q����j�_�7�"Ng�k.-|1�}e��E�"qiU�YWa/��8=7�k�I��а� �d[&iΧp���d����a^��5�夒�]�F;��Ijj.dY_��AYX�UZT�q@�VC?Z&y�1qǹA�v%�9�-}�w����f������C��y�͠�IdK����F�&9m`.�󄦥�W> ��|�E85��Q�F�@��z �.�Iچ�K�t�E^���F3��t�3��ǬB
U��JkF�2�U�"5� ��>����S�ޡ\A�M�ҭ�
doGEO��$�=��p��c5C�aq%_��ܞOʃ :1�o.`F�5�;(��&��Ș��p���wX@��C���(4@ہt��_CM���
-�T�)\���
�&F<�в'r�uWEArC���i���"4Vt���G��yY0��}C�S�	m��0H�T�A�2�W���I�7կ"��k`�����Rm��E,DĿ]Єx�?Mۧ$)!>iU�@�2��i�u	�dvg�/Ay��P�ܲ�����pU�y�y�v8eI�-~�q;��1}���-�I��{�M��)�?�3/~��?���1`Q	�Gm�S(�����L�+\�7���v`o,���o|���%|�#.����B7��֘���^�Z��;�oIY�:S����\�[:�6��6��c�C�$�a˨\hX�M�=�M��)HfB�= {d�aU0�0ycL9 U��0 ꕗ0 �g�y�-���D��_ەGO4ݨ R��8\ɀ�s�T�`�uw��F,1]�vqӆ���P�C7�X�2Iw�Rc���9d�؃<z.��t���(1���Ǝ���6I���E��he���b��;>3e�[&��\�iS�����@t�v����\��X	�F(�95�fh���K�"�JT�Cf)�@/g7��`�t�hf�4���#���k�Ʊa��L "i�[��i]F&M������L��8��IZe�"-�w˘ي�e�Ykh����}O&�p�~ҿ��t����e�)���X���cY]f�X?�"V�!I���Q��f�0�xCov�#n�����z�o��_��NO�Jr�-@��l�(�����ե��ko��z�!〥N1wT�����yڭ�'�;�/9�}/o��	�@�U)�#�x���C�K�'�#�����t���!�����֦�4�"m8qI	�d_����>=������Zx6����?���t��?^�PF� ]l̡�z�pa�1����ߟQA`�U�n���)n�3�&i�.Rl�:�/����ǻ����'e�_�%��%��L:��9��qɡ�@	d�8C�2�z�E�Ћ�V3�b+S�y�>���!�ud�l�^����=*x�̥���}�U���O����k���w��=;�jӍK]������ պ�����Q]���~�~����I��3����j����ƖI�A)\j����w	���a�Z��~������՗����Ӈ�����?�__�����_#	�&����Q���$a���h�5�� ���"��y���C1Ҙ�P���nUED� J;��q9R:��$���E"���r:��yµ/M�G^mṮ��}��ذH�]h9����н���U����tş�,��
�ϔ�&ye̥�?:��6��mϏ�ns�)ZK�(m>�l35�|�28fi������6�sJ�v@�p%$��ٺ�I�>�pntT=�6	��ҥ�i ���~x7-�1s�SЌZ ����n��[�p�%�����銎�'*�p�ڕ�>H#�W��9���0������|��nγ�qQG�9�jCIk�PG.]�:��c������i�a���i�i�t)1�8b�*���&y\��HPX�%����w�����&��bW#L�5,2��iMb���0��y�$4�N�`�Ł�K�hí6I`��E � �G&<�L�qڝ�rIX�+���6���ڙ�I�W1��0�a����wx��S:�{�K�c�~��ad�F�I9.�g�cKn�Tdo(�ٞ��TZER������k���s)W��bԥ��@�'Q�H=e48k�i���l�$�.�K�N��HU?&��U4�`�Ǹ=�!*����g`���3h����&��X���`�N_�y�����}LD����J��
����7��1�[&����������Ow�Cnm%���I�T�(�C���jvX���OPj�qPR��D�x������u6�=B��;��}��v��VG$�����B
��ҟ�1��ۿ-i\Z��O�	�צ<,�E�a�KL��ۿ�qG_�W�g�����0����Z�tF�����pA?洯�YG���3"����AN��������ׂ�z��fy�0���e��
xK�c��%��+@��~T6��I.�/ -A��N9�b��k8ŏ�n��g�� 0�ԃ�x����<o㕎��\��յԒsف�
Jz���;�B�$�̥n�����fswx�dS��ذX��I�c�l�mXn0�)���/��C�]YH{�떼5�h��7�~4-�ꖅ�Ԛs��K)�8�&�W�י;�U�Nn�Z��*�#q0��b�G�&�V�\�"f��Գ�O��O�w�}�l����*^�L��6Ip�¥�;Hx����>~�����o�������?~�����_���}������x��m�$75������65�s��o��fl=�o�����U�r�Z��:���zX$�D��+ȿ4aR���*5м^��0Ip�¥~�A��UM$���o��� ��C�|&��Hq9�܁��;@��#��|��M�yʓ��5����z��`�ɚ���"�X_�I\��>h)�� |�[��9c��2I$�K���"G2�rQ7M�8z���;�n3 ݬM�-_�H�)}ah�w����4����H�G,4��k�d�7�"a�	z��z��pzW��\b����$� ��й��$�-�D�.B���4��30��~�o!�W�*��3��E$����<^���L�)W! <�b�ѷL���\�� Z��㩜X9&� ���w0^�n~��Y=-Tl,�h��R���R�Hl,1�Q;��ui�����1��अ"����{�	��.>-�hU�$y�"BȁK�������ĝOZ@a���S�$��p&-@�<'�B&
��)������r�-I���#�\�
��\�caeb���=o�JL�v͆��5B�w�Y=jS�7k�zo*��8#�u�N;Z�b�Kf�aeU���I*�.��,��Q�;����;M:ď}�'�v�������;;v����L�o��	A�RU��ρ�tlqx�n�aJ���k�{�$V�<�&e���b6���@k�L�\꺛ç|)5f`���@��2&���[P��{+Lr��\$&�q��[O�cM�i����3�Y��>z�2	��ҥz�0����W��'*^FKނ�U�a�Uيe&��\$fP�yB�
̷�a�a�A�4osi=^��܉��]]����xuV
}���
W:O�n�5y�.0�fH�L�mV��GݷLRR��k \�����·c���>{6�J�����Iz煋���Lk����}���n�����o
߅�sR* |����b,���p�ʄ1�T6�����H�X�WO@��03��D����/䕄���n�c/.2��`/kr���iTb�Ftv� �k�+6�w�&��ʹ(��W+�����k�n`����7 ��ˠkq\�wxU���yՕl�l�1�"��x>��X�a�n����p��~V-2#���8�?�cB�=�w�)u
T�z�E���i�Q�Qi�d�Dz�c����t`K]乒�\�pNT\��tN���T6	v��d�(`�Z�
4>ƖI�M
!iB���>Lo�=����:;`�J���[PmD�r�Rf44��M̭p��U    ����C�}7���4����`Y a~�N�2��n�%�������z{�=s�ߣߕOaZ-�)�W�4��R� ·L�#-\�G:�Q�⑾|��=� �]R��������pv��a��A�Ch#�mW�R�O��b*���O��� ����}�!g�/\��J���2I㤅K�#zd�8W��ܡ���m\0��
�jNm �� �c�l�&iڧp�`{��<LC@���(BM9 �(����5e�"הGK�BMY�ư����
117�e�N�¥��0�/x,#���xc�n��Y�n�d �"��%3�� qܦ�l D�T���6~w��еI�jc.�T�_ I���A.&�`.-�P�d�=�R�G�����T��f�D�	tPn�{Ɯ/�d:�"�w��gZ�<L��1ՈcG/0�T�1W���-��^d.�� M�( ���,TF-j=6�!Tr�[�1v�$ϨI~��E|����a�N<��Sс��N�w��[&��S�Ht`λ,�����)�e��x�).Δ2(��c/��:��<-���=P�d4s�'ˆ��,�w����>�Wa��Q~��o��a�c?fήe���Ԍ��M;0��C����g`=�Z�}��×��K�C��^�����t��.��,\Y9�F��kYBT&�a�<1�+�{.��=\�H{8�n��e��G�9+�=��FY7�{! ��3�Di�1�K<����	�d�O��%T����2��jd�0Ύ%����&s���C�:=��
��ySc)�0Kz��~�зL2���ԄBZc����Ӿ����{=A�~��CLn���w�?��O�DYǶ�ZjM-K�3�%n�"�� Q���WR��=�:��qe�CF$�����>�i��{K�M�$��.��i�ғ���i�ë��"E��x�bI6��&	 ��@V���&�.�&	��c�m�6�n۽��ݲ7�FI��6�f��=f1f��I����7�����s���!��2ĎÊ8>;2DW!���{�W0��&��\N�}���ݹ۝� ��H���5�eޮ�=9L!b���@#8�$��
	��\�~�����ן_>}���4T¸�
f��\��[F�]��t�t��p*-S��wYV�LsU.�o���m��U1qU�σV��e(�6(%������ږIƫ0�#����_��t���j���E�6�2�-Ӎ��""����M�Χ�"lmMA�̎�X#����D-�NM±R�\�v=W�8cR�7��	p���j����zq��ݕ?aߘ�=D��:
�L��t�_)hu�\HYx+k-=���`^�� �Oz3���-����g��,ڸ�2��Y js��� k�����M��u���QFO���Q���ԃƗ�+�RM��<.1(�4�E&*ژ��ǋ��5�t���(Ѭ�s�L0�p�)c�2�.^k�M��<��<%b|�:ֆ�o�����EpT�_7�F/�~���9qR#ƌ2*�l�YB!�P��Z&�|T���:�t��E�hS^k��Уļ^q1���&�E��Hø	�b�m!����7��˘��Q9��R��,�ؔ�$�Q�IU��q�2�!{=�X|�y<MرE��4���Ry�Ӑ�;���2� �Q0��
j���T2���%#���	Xs̕!@4I���0�����=��8��J��X��:o+�5� �P�k�t�׼��搒�k�-u��I��J�3ݘ��."ӎY��{�'*�~����!m�-������x>��(Q&����������v���#~� ��S�M7��EDī�Bor���E�'�������4-��8��pF·�'8R@�űr/�����fe}LtǖI.�2�����C��l?|�����_^>w�|����/X�����׏����R��Nw?���@���( ��WA���I�Ga.�<���&�����^X�9��� `��z�t�$�ߘ�Dg�H�oׂ&���gj�X-�i�\Z�ߤ\�"Ra�:���7/݁�+X�t�S��~z�1
�_�v���@��$S!0��^���}�"w��!����Й�b��٬���ꆆ.�]��#������j6��n��EX=��s�iz���i޾���$I	�Z�G�$Cԫ��[&����c�@�ㅦC��	��[#x�Y�L<M�m��A�"x�Sz�����Y��ǲ�jp�45��e�:����Y<q��̿~}��v(�Z%?蠩c����5�L3G�R�A�l�U��.�+U	��>�Q�
�y*�^���O�"�}br�v� �s�l@Ib�g�^��wcNk��1��r{Je��o���,� ;
J�ĝ����$.RQ���3|��w�}(��0+����o�������//�#���NP��8�ϩMR��p���L��6�aZ�&x��B�}R�KW�%sC�t��B]�
K��R��,��i�J�K8c|GηL��/\�'	�p�7�b�}��S��]�Nep4���k������h͍��W�1�k�ȀS&�Lr���HӇ*�|�q�1��l'̲����0=�ݙ0��<)�PLh�z��6M2���0Tg����B{ҁ��D�G4�M�RoEк^X*�Y���O(\�ۯ:�;q,y-;qp�AFc�"&+Lr'��H�8m�μv�(K����ޱV\��(<YG�&i�.�c��,%7��4}�5��,l�R�e��`���;D�.*G�߿v���K���+�T�y��c���C��*��-� �*]�e�Z]>��gP�U�T�Sa.��R&���\jp��]>tR�GnX�� �aL-�#\0�t�E�#�}���� �~��������_>e�tJ-$�q�ܽ2��Q4�I?s�~k2(%CC��'���r�O?�$�l�80�C�R�Q-�<lC=��ZP��$����T�ΰx��<�ꮔ��[&��Y���J���xu<d�����0`����+� b�G|�ƴL�WR�HD���������g`�Z%U��7�/szZ&����Ht��K�X��x�_w��C��,oe���}����]�rcz�x��j�}��m	[��&y7e6QQ�d�,s!�Ne.�i���K�|�\:��#+4C�e�r��EH��+O�M��c���a9�h��2a��"��&���\�aD�U]�(���a��f�1�R��>[�����"�T��b���U���&	�Yحs��@A!ީ�e��̥�5���g���x�or�?�Mg�	��2ɍW�"6^��]zY���i�6=:���T!���t3�isӂK��2Ju�N��C!V�������Yj�d��"� G�2�9���l���j����&I<��.�f
�<��\�6��=�TL9 >N�)&3��R�r�{ ٴ���!TP\���T��S�|J0�C	B�U9���P��Cpr�Wß
Y�-�#u?�LR�P�H�9�|bU�4=��o����Խn�@HV��޴L7(u�]�r�8�����$����w�:�#7�i�6�Wٱ�<2�C�!�&��L�6�H���<:{i
����iñ����F�nLm���˲8�^/c��l�����_�!QCn��@
���3 	��k�'�S��dΒ;1kPv��Vm�,
��Ӄ9E�Ivb(}��OS5��=��
�͸ɍg�c�O%��ѫ0���Ԧ�8����O���t��Zϛ�.�4eY}�du���������K3Z���I��vz�w��|\,����R�P�($�1t��؛�e��D�.r������p텷�s|a�m}�^C� ����b&�f.����v�'h���k�:Ƣ�No��oe�&��GM4=K}�4�a<���ӾÿN�!�6xg��SC[��#���&���\$���"���v����k �<`�9ݹ �t�6(�^;�2I�Z�R?K��g���tG6$ŴKBw�A|ڍe��M��l�R�q A-��LϘ�C�~:�wM���� 茀�1�zWm�0��KM���e�(���Ww�۹�Qn���Knҍ��    ��e�1�E]�)����suG�a�qV؈'��4e�j�[�2I�B�R6z5^��������RJ3͎�<W1Tb\0ݘJ�.��l�xe���O�w���}�ws&���aŊ��@�~Fmm�$G4�EB�(����ӓy��e*�	��X��$93��`��J�3f�IΘ�Hrf=�Qa�p�y6�[�!Qf6g^�M7�s�EC�C=?­����s��i� ��a��3f��i}[����q���a��,�!}X���c����x)�c�%ŧ��8���&yQ�E\�.���C�-J���U�r8�V�J�yf��q�"�p)w8���lv�1	;MX��vϝ3��ޭ��t)n�}Tp��_�����)Z������������7�����r�y�#��%/����������/���:E��I��2���F�q�}���4D��A��	kO�&*�=���[�IL2g	s���@1]��T%I)����a0� ,$�xfWqT
�6ɉ(sQg�X��ަi�?��t��m�v��u�΃AeU�)Yqm�{�CdT�q$��Ǚ1'������D�B��q�M��u�	����z�If��z����C{|l���Z�{Uyg�����������wL�:�cs 5���f��iJ=3�z�"b�a��Jhw��𯉡���C<,b�y���%Ϣ@�gtO�V%�@��pM{3ڡe�����'������7qF��+5X*�'��s�t��c8w��DSo��d� H���	��%�5��'� 3�E��k���`."�E�lV?����/���f��P� h�Z��y��A�I�m0�����H��1�إ��4��:,8�G�`]���B�`)��6I#��K�F�}js��2�?����6��������cIH��[`�9�Y��?s�����%{{���gdK�5Չ4�\�򋂒&VcC_\J�I��
���Ń�V���P{����� Y�q>�BG���H�?U���BQ�i&=�\���:�-���q�6�ym�<�-ԶW�j-�E>穇x��Բ�-L�_c�t�ø��h�tؤ��S��cx����!����^'ܱ1<�*M7�{�"e� �UH���c��@����+� �OϚ;e U���[��FቺHY��C�xѐ�����~z�o�W�h��!��e @�h$)��QE��$U�
���H�8������ڜ�[�*Y�����P�G�J��eb�ҥ.4�1��~z{�d�bC1]T:�U����-����\D��N�w����@��:�c>e�Q�e��'P������'���A�J%"�@ |[�2�ذ�,ԣ^HĪ,0����6��S1�j��@��4��i��6I���E�Ѯ������p�PB�`(쏑M� �*]���x�^�ޞ/*9��0���>=�6��i��E9B��1�}�2IȾ¥���1��I�S�=�˿BB�G*��Q��X ox㙢]m��Z�.�Z�b2<rt$g@n�G\(X�^=�'~��`��~������
�n�x� �Z��̫M�i�\���
��R�i:�_�3��� 5�ǹõ/���k~���&��UњX�K]�xoC�$sB2��$�h6��,�q�Sq���#�f��j�A�LҬa�"�p�Q_S��RV\ҁ���\Hl 5?M��k��	.uye� å���V����gफ़��18�U��M��'����-�T�,\��f<UG�hMVݛx���}�	F��3�8�ה���H2�!M��,{�@�r�!'��@0>3" ���ū�@���&��"�
F��:�_�0z!߰C���B@��jJ"f��L��Hdb�QM�6���qtRB��l�j�-RX�=hH�E2�������Tɢ���U��k��#�z�9ArWq*�<�|I3�؟-0q��n��ct�If�c.u
Zr��N9��S��:�V.�}�$�$�K����� ��=������n(�h��j��f.5L�wC>�SFh���	���WTR=D�cp�-�n�LQ����wT$W�� �dcȬ�iX�6*���J��`�I�d/�4�+�5/�F�d����[��	�.���A2\��Q�l�I�b~�d y��X�r�#f57��p1�L�2I�Å�4:3.N�T�ۭ0��\컀���`G7�L�'S�H��R�^n��z�;��:�9��a~�_�p&�d����� ��WC��|�$%:�K�^��(d-)=W|�o�un�Ccn��i�t��Ӊ�4���wTVB0	{�t��t08;������l
��p�.���دlEh�6�̥^&(;X]6d��������u��X��x�)E�,
uY����_}��_@B�/__�������˯_?~��O��-F1׫Q+����v!3�(#S���� @�e�v��wR9YԾ��{�ZQ�f���!�kX$�-�!�f�+c�T�Խq�Ck(^! wƕ�%���t�sq�����Y"�E�P:9b�i�HTS�P}Q�Ѧ"B�\Hv�2�N�ʨS4o�/,h{m� [;��v�vI�"�)�H!Ƅ ;�8}hFT�����1&�_ú��r(�?3^���I8�Ki.9���*�a��`����O�@�< w��|lX�IL�Qv�>-��/y�n�S��c�CF.�U�n��E�zE���(/�i�F�*��e(����6��S��>�kvc�x���9��8�LB�Z�����L�MLФ����vyl��Z�^'�"W���i����EZg<�3�j�H{�P����Ǻ=�q���&+�J�Rڅ�,L�U�\ī�Yw�?�S�[�����qAxK�0�7]�00 P��I\%F�1���*3�X+�"c�H��/�I����SːX�*����[&9Zf.b�;C6>�m�i71p�+t�^�=�4i$L�7�+5�#=BkSu��.u 
�	Y/�/(KM���P���s0-��?Q���Z�^s�4�;�U�����X���\`{V>�M�-T�H!�����4��Ayz�9�;�Q'd�<'��5P�ƁR6��-z�!��$���TS��a~NY��`r�����>SQ��!D�"!��&��~�h4)%*ֽ�&B��z1�`T_���%�"V����t��i�p�~}��P5���1���3P�&�|X��(@q�p�輎��\b�����L�=�<L�L��,\�ݩ���14z�R:[A��p~5��?�e�����H�z�<������| ��+��2��6ZO��L�@Z�-�M0��E�"[*ט���b]��ëkT+��XV��$�>� T��-�L��\D�G���R����x:g����Ag�1�~��~�ݯ�,�Pj����p�~2W��ͷ�cw?���/H� ����9�l\��M|ý�E�X���sW1��J.��u��W��nPk��i��1Ƞ1Jm�ԅ�Р�J/�,ssڷj�~qX�����2�(�R�]�/���0o�G<���������\�zC������$��1��2~x�f�|���\���n==�j��S^�b9��(�Ǌ��I���.u�h-�[��g�0'e��sҊ �PЊp�:n-
 �MR�Z�HAk�fӵ q�5��a�(�u�:�8��{���I�W!^�[����A�[$�q��A��:�1UW�$hg&�X*\�c	�9<�λ��)%
�Ѱ�YR��3�c]�$S�0�y+\���P��g��jk�;Rv��G��
�	ZI�!PIb�$�;�	�\ܽ��&�h,<f�~PH���B�$.�_�.�3��1�z��Ǭ�g)Ȗ(O5ĘzE~��A�xr�F7�c	YӓCZ§Ü��_'�8Oa��.�A���ٽZ&9d.u�y��4ρ-rj8�O�o�>�#~�a��.�$�y��0���X�$t(�LV_6X#0Qb�b�jm�N�¥.1�g���~������ǋ������o�?}����?b!���}$��R!��=�~(�R�I�Je.�ba*U�̩��sXhY    @x����0�H���< �����-dI|�!� ��)y@{Y,Q���E]VS0�k�[&�.���w�ޟ�λ��=|=}χ���A���z��T�$�1���0ONA��|x3��z�) ��	z�9cTi�s
�"�\��B{%����t-UK��U�b�Ր5�ң.�Y�R97���1n2*A�GR)b�Q���(z=�:L]N�R׍���o<޺���{o[���_�$
�~d���H)9�2r��f�3�M�3�{�M�S n��(Bz��T�^� �l01��Eb.Bz����*H:��D���)��V�/L�/\��iA\͇<�E�s�´���xjy_ֿ���u�bp����hu�6�-xY �]�x�:�2	Wt�"$[
 ~,����v�|~ ����E�,�.@�9ĳ���&�H�\�"�m��4�q����X� 0��V�0`eJ@�Ʀrk�4`U�L1Up��|�0������a�n�w��ع
�P���cB�t#{�.7�G�����zaU-kl��������J�hu����Y�Ŭ("/�e�ז����,r�el�Rk��a(4�e�c�$� ����0�&�e�IT!��p��)3�-��.RHc�iw��������J/_?����%�߿�C#�����j\�J��o��,s�W���y�뷟_��������Ar�o���^^u����/����O�^�$J�R����9�sCy�0�|i01���B^�,#K�vE����[N�V_vP�����t�[��.�e筗ʡU�����:� ���ه!Xr-
&y����P��A(dp8f�3����'(/A�
�T�P�2�f��Nvm�ڡ���5�q��]K`������8�٩��,%(P��U?�LRQ�HQD���Q.|��KL�����%5Ҹņ�e�q�E�Aă��i��,p����![ "WbަlLؽ"�4�I�%�.��`�����3�:-]e=�Ƨ�J A�J]m�yx����@�N5"��ӏ�7��c���.�4#�<�"/ �C�P�t��6I�W�"q`�qs2��y�B{J�/d��R4PX~m�sC�"&����'HBH�ZacK)�iۚq@�/�l���H�"�C�)�Y@�a�87hq9 .��1��cƖI� d.R_��^�5������_�n��)�S��n�=��j��U�=��w�Hůk��)\�.�5F�)��p-Z��+���z��зL�aU�H��v^��v��� �y�
���֩��@�$�������e<N�%Z���N�Þ �<��,P�q8к�z���&=�I�d.�Y �O���7�i���ډ�D7�ēG
�5O^";��v<�K�5f�M�tq�8��*�6���t��،��*<2lȴL�j���Zey<�yz�N�9��?-T~�M�h6X�ƨn��p��t�M]��(����0����]��y���?�כ��A��*��+��~�n�١�OIU̙���e���EbÉ��.yK���x���g@I6^�v��2��3�E䞹P�C~��Y�ZH�N�7������tsB]�d<�|���˺��7�U,�/0?�Lr_���}�aiWp�1:�"��i�t0\�"�P� �9o�v��I��+0�<:y� ���Ř]a��P��c�#��0���_��J�i���V�06MB\_�ԛ}�q�e�,l�UN�&� �F�MJd(��Q�"��f	�(vP��=�����#��c�i��ao���+��Z�M���S��o� *8��x����0,���$�u�G@n,�G�n���]�"5�G+Boϻ9�>�� ey�[Bό���a�9�Ri�Qi̥~hF�2���@0W�QS�NO �9��[&iz�p�fUP�R�n:/��,�w,ǿn�ϩc��~�0_������I.�3	Oَ"�P ���3�/��n/�d׊p��O3���-�Nf."8��x�(.�qzڜ�nf�������j��Kpž���"�k��mGm����E`�J1��&.�Vu-�*�w&�쒪M�]�H`U��b�En��~��J�Ҋ\]?���`
R�I�2�~�-�)��W��~��S-��=J%_��U��!SLR�p���x�S���$1?}���3�X�3�S(F�&a ��g�
λDD �E�솱���w��P	Mה��( wsGޅ.��]{P*f��4Ua_��4I��¥��r�0�;>eM���3�7DB@���f#�In�3a�q�;���ǿ}ힿ|��o�~ř�LXI;�a��K�X������a%u�	+]�'���2��m%�S�}_}[�$[�E���	���ǅ�w�O���������;r3��`�+LR��p�
LJ��~T�(����E����a�b�I��a."��ʈr�������U�����ߢ�vl��{�p�PF6nF>�wޭ� X����}Ͼ���!��td[&��)\$
Ж�!~��?���fP�M3��ܘ��&F ��2��M�\Uf.bUَ�ĕ+�ΏSb���U5;-�Fb�c��&��Y��N8�x�pY����4FE�ъ�GѸ�1J����$�|.#�s#G�<���6t�ͻ���-J�ZǥʠJ�$��E�J������󢒊�����l$F�y�l��,�� _���I����h$#��8�2ū�K*�}�*�L�to�R_Dхu~s���ü�'��F���}�����^~~��&m[���.  ��b�$�7��)���������q�Ns��J\z����#~n
�fM�\Tb.bQ)��y�o6w��И؁KM�	��ִLr㊹H5h��2����|�9��WCZ�*�Hm���Đ�E�;S���(��͗z��TӤ:�5��}<�F3�f�$ͅ��C����؄�i�!Z���N���R��8�(Ӕ�ߡ�Y�(�0�Ld�p�c 2��<��11�\Fc�<<�2���k��-�p��8���-�&᱖.� o�\�?_o��~ƕX�E�� ��tnL0��s��CK����b� �`?~��9��y��Ϗr����N�,�[���� 
&y��EZ�����#W��aRK� ��5+��Сe�:��K�D��_�v<��gd\���P!ah���U�`��J���eZ&�K=Iòx8^>���z"L���%�u��40k��R�[&�2�kk@�H*�M�n�k�9Z��.L�igJ�)B ��i����"���Y
�MA�;�ݽm������ϦI˭0"�a��na������T�����; ���B�wa�@��3��l�3Ӎ!�"�C���b�H�-��+����ު�E�*+<��2�dA�z�jp1�W�(us�Q�qd��$d�KME	��1箘YM��h��(��:^��ѿB��!��Hi�j�<��\�|��Y���m���K:J58��76��F��I[.\�5�]�;�:v{�ۭ*fOO����!��~�}�$w癋H`�������4߰>?�S���h�(0�h�;$�`�����I&Td.R��LWr���G=���-�Ǜ�F|���7�I�~����Uީt�O��rԐL^*�#R<e{m�Z&96g.RI�(�������5o0�Q�'6ׅת�ղ�t�Q����o�#^t�
����^gK Ma�?
�"BV��ֵ������|e��q*�Y|'0�'01N���]����໶p�f��Fs�^@�l�@�H;��V���b�"�QpR`�4�(���H{�Ui�{�V�v�ٖI*�.Bu9{�#m2I7b¤��J2If�����H&��ƂL2�����)���K�rQK<D@-�M\׶�����x���ڐfG5�y����J�ɇF��e�gG��8;Z���8BF��_� P�/{��,�
A��� q	�=$H�q���p�M�$�h��b�v4�k"Qj�A$J]�[��6��E��p�l�H��5��j4-ӍFu�I��O��L���s��o��R?���V�    �El����@�$#3�K=���S�y����>L�|8�j�{(v`Yv�X�Mw0c��Wm��¥(Á�n����ݹ�e8C�Rɤ���W��\���N<�Ͱ����%5�~�5�K���H���@�j��D*\�TPxYdmqz����_`���������_6˥Y搨J-jVǗ�`|�I���:s ��e�3����!$�}Ω�u��ϙ�&�	l�-�M������ IE���Q�=L�-�޸@E7a) m?�@�+K�4j�DiY��k���1oI|��q��x�h͟�e}����͢
a�8�;3ō]�{O��IIK�z�| fF{eD�����xG�憌�T���R<�3yI�ා��f�H�aߵIJ\#�Ҡ:�7,��*�zm �M�Gi�7>\hQ��c:ٷL҇[�H�v}^����â#W����c{OCMs�M�L)\�祔�^K���/?}���PZ`(� �F}�0ħZ&	;]�H�1����1:�r�ih?B��ӷL�.+\�m����Ռ�MJ�4�ژo��)�dR
�"�R�@W,e�=����Bz��e�����4�h��������4�.s*�":���� ���l��L7Jq�EB���c�ӻ��۾�������cX/4��^*�S�3@b��&i��p��?S�"'Ũ��O��f�aj�=�Ϫ,2��z��638���a�g�ek��%�4t����8�*�tj.���C>		�����8O�G*NǆئD�l�O�����*�I�O
�zS�����h;?e�Еgۨ�⃄�gB%�oXntЈ�X3��	� |$��o�R���@00&��I8W�I2X��!sC�Hl7w�)��~~-����"���MRo�p�?�x˗�� -m�ȇ-�j �x<�]ƶLU��v�;�p�iN�2y��"�;Ȼ�w��
�;�loU�QrbXa�a[&)�-\��]o��u�f�&~��[���jX�~z�*Is���6,RZnOi.�C��*��h',`�+�r�ږI�;.��\x�������Zv�7G��_w���m7�)���ؘ�P/Q83��e����E��.2�i���E��j+9k~�w��qю,X�'��墡bxX-���.��G��A-3��'�O`�Wg��I�Nە���&	�R�û�虋�o>���iN��j>��s��_��[�[&iN�p�5���}~���e\+��	�A�ܜ5HFE���"U�G��H�����e����8u�*�-�p��.��Ms�������x�ϗ.uI�ڕ�Kg}��i_��.i�">��n7�Żc�r�\S�h�`lMY��j��6f."�X/:8��c:�b�ȩ`��]<5�)�b�\ (L7g4�.E��a���w��ya�H��y}~�QQ�xD߽�.�,75�j �j^F���L24��HѠF��#�{߽9���7��:���&��P� >��Ӎ3���g��M���)�n�,N<�ܹ:p4�"�|SJ��$7 ��p���q@���.G 6����G���t�s��E��ra �i�y��l�c��~�*���&$¸��2��Ed�0��͛�_~{���ۇO�2@{���Z����oXd. �!R�q�P�鸷N������xy�����5^�@��B�$�)D~i���Y��~l��C��<����Iʖ
�:0�˜��b�?��1E�M�=哫,7H��4%�����Z�ùi��U���9�6~Z�۟>��[����t|����kVn^-�|K3�b�N��{3��'6JƑ��Dr9����i�Ib'������&��\��E\�wEs��z�ҧ��5��{@�h�;�4I}��E�
��tp^I{����v?�����,mK�&��]�Hm�髐���}RB�*�����F�2��m�"�ZŴ����	h�/��a��P+У�6��d�M��\j���8������zN�S<�a��듢<'2�u���@}�3!�&:^�ԭxP]�"�"��la��w���4g�B�I��MBO�t�F@���Y�ǌ�}�9Nww�4�A��j(# �X#<��Z&9f.�P ,�����V��`����;��e��(ʘ\����O��1��6I��¥>�Ƙ(�F��Fm9d�\���ns�t�����mu��
K�I>���xD�X:���M	�ژ��7��M骫ez�Q�^��)��`��Y�H�o�d�L}��y����N��n�;_DCz��1* jXg��t#U�.2
K��ڻ��9�BԪIn��) kth�$N�"Mr�)��GW�xL�6���-�r<?�wfD�TGFk�a�qc�`�LRɠp��S�F�g�qcT�0ԒZ���V���4ɭC�"����� �BW�6Q�VT�MP�tX��c���-��G�\$4���MF���it��d9�&�x���Bà�Vm:ޥ�����j¤D�ȥ���b���%-t�!�D��T�t:J]d���L���ی��?��.a�}c�-�ia�\�^�h�"��Ev�o�K��g�B���&[ 5���4�~㼒���lT�Y�2�D��E�tjȴ����d�����������4,7��!p��z�^��p5I�U	b�F�H�4ɁD~�I��.u|��n�u��W���@�qLժ�-2���F��N�M��B^x��pm���
�D��a��o$b�Q�|:a�dI0]�x;k�i6���2��s��bt�9��O1փ)�D�6^+'�|��TWH�4�%[�*t5��aԾi�J���4M�}��Suduw>\k��R�	*��bnW�icJ\f�n��E�ԈI��5X,K]�P㥮D�K�A���@.U�$�0�%�r�����@[+�ܽ��>��\R�d�s�7&�R�x�l�E�A�8N��?��/$��+����p�O�S��is U����R�����̀���;>k���`."6�).+����{:v3j��I���Ґ���o%&
"b>6�R.��$���p�CG�38Bq1$��Aֿ�N�<�B���|1���H<fB��4�`�.�|�
�+��wص⤳]��mq�#�
���6M{D�"�G(8�?ּ�c��<�i�i^���sUߔ�Q�iW�s��Z�I+\��0�v<.}�ݰb�;�`F�H[�hp���]�ڷLV�'0��R�d�N���Ж��j"06��t��I]�)F�����i��Ygx(O�$���c�ӏ�Ѕ+Lr(�\�V;p�[}e8�{~�,G,�|���H{���i���:���� �>�]�?��,�BPfY���n,��I�a.�`Vȍ�t��x{��#Sj�%��.��E��_�$<Z�R��,Oh��y�?�/�'�g������ۡL������\V���j�8vw���?�&y��w�,KE�Oqeߙ^7��D!j�] Э^Y$H,��2���!��ƽ�������x�n�`�9`��ˋ�e��{�iX��Qqy�7�1��lL�)]������-�����hhE�6I�k�"1[A������a������mŧ *�+���-�>�"f{�f�(���.!��Xn���ĺ�, �=��M79;�.���C&�����e~Y5�:�YB$���-��tg."�������q��@�7uT��Ѻ�P��0 �
C_ע�I�E3�}���#�۞w�X~�i~Y|b7hx�K�1��$%���P|TW�������`�i�Ya�Q���B�M�$c����yP>��.ad(E2?~�5�p���>�=eCK���!�W�U�2I�T�R�=��귬�#���({�����:d�j.��ї�l��w�Ʊ��*L�yV�HI�R���t�x���'"�	�?cj�)g�f+��� w�*����n�I��
�zŐ8.+6݇4Z|y��؂��!I�8NCf衚(��^���-�T�*\�")�K=w�ӝ���<��Cf�<����C�![�
�wW��$=��Ex�*^%y�;nX�����npw�^8��0�z��1 K��2���
ΑÔ�r-�\�g.�7T�s��D��X� W����Ek '   [&�l(\��!n�^��l�-�=)�\$�`�?�����ʱ��      �      x�̽�V[˶-X��B��l�Z�~�f�0^�#�7p�eeb��H4���o���7�J�e1�"{��$@,�2����� �I�#�+��C�d��I��Q-)U�('�hm�~�x��:m.����l6>����\M��͸s8<�?���Gss��k�[�����eK	�_	�J��p��_�sք`ں�����������^s�g�nnF7��Q�IǮz�T��|-e�9��l�x�}�EOkgml�x^|-EODmLl���Q���a�d�m��sX�^J	�/�<�ڈ��:(ߎ�q�"�)���Y�N��V���������0���|]�o���us;��n����_��M;N� �:��g���f�R �y��kkz�['�R,�a0�:�Y�-N��mn���s���R�gXi�C[�;k(�/D�Sbz:h�P/#�z�0�R�:���A�i�=x�������A��h	9t?�@#��#���?�@+_+�s��ҵ��zi��|�կR6D��z�v9�̒:�����-b/z�j+��0�_��3B{�jؼ64�B��˿�,ax-m/8�oC��_hl�~B(C TXC��i�@��]φH?N��-=ڌ��� ��o`�A�Ax��(`���bcOh����� ��U��ʷ\�1$!46Z}�p��f�lu���E��at6�,�>��&���d��eX�CXj���3�L=/���ذ�UT�o����+׋�*��*�|Ee���8�	�=\,}���)p����E+$X6*ed��V�n�]�:�����'0�=�ǧ�is9)�����f���?ů���	O[!WwA��¥G�ok��
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

2�{�(Z2���mACS�H�����1'��w�_bW�CN��W�L�{�2�n'�#� TPs��JEy�H���w��7��X���?�x<�;Z�s�T;sTN�)����"�	������y��|q�y�� h?O�ߐ-�yhjv7C�"s����B���A�+\�O�܇*���e���z+�@9�fꁒb+Hw�{ttβ�Q�l�9�Ѡ��+� �#����ݶ�J���k�)t��V��Pw6��I��.�.�Qa�<���~�~�~�~�~�^sŊ-!����+k�JN�v�u�5�, p�ç��>����ll��Y���2h���ʃ�eqc����2E���|��X�6�����=�g��OtR�0@���)���t���(�l��eQ��v��DT���_�:�c)��Y��lO��`j�hyf��;��Hn@�n�4-K��"�X��$�a����\�"�WQ)��|9��B���#:�W�Z�3A���d������X&3 zKc=Ь�M<�q��_�b�l�x�,��)\�o��7��n����~'_T
PJ��\1����'C������9�&�����	����u��� �gf��۴���ÖN���!W�q#|�*QF;���`ݘ)lK{ish��j?�M���PZ�<���
Ae���E��!a��FQ���2��y&�L��,]ec�)� ���B���6��$!��5o\t.�@���膃A�D6��90r���:�9���2+b|����g��i:���p�i�w��0<m7m���{�|�{��_Hfu�9�Q�R��&�M3EAW�6f806���u��f\�m+ƒ�C��:e�Ce��L�R���n�N���9#�Q[�%�{����g��������9�;;���{�G RMF��T�����C�)gӘ�������h;m΄V1��̴��^ם�k#b�aS����9���<���̯��pH�<c�bf�	y��Z_f�`�N���?�h39����a��JV�o�(C26���p9Gs�mt�M�cr�����d"����U3=mt��4�r(Ó|J��0��C4T���zM%Z��	���4���TT�	rYχWe��]}��ǣ��m((�7�)ӓ����7M�&�`.&�Hn$�����u��C(�s��0#��@�[�&(�d�.+����UN!WL���<��c�oLB�rWV"����3�d��֒����������>yuM�]K�`7�����1ˊ�0؞et�\S���f�R&�SUG�Ë��rm~��qQ| LC�,�B��h��J�n!��.�)��"t8�w��*����b?O#��н�i+���8d�%�{�'@&�!��a�%��E�p2LK9C�B�J���+]��`�s�b%l_4ڲ��[>��OQ�$hA<Є\I�j��c\ٗ�v>�D������A�/������/;���d8*�=��o<Ǹjt�>���bF��Ox� �2��6c�Q�( ��<L�Ǯ���h��Ĭ�eA��� |���X�!�!�ܐ��a��V�â��]U,��?�Fx�"��"oߪ����WT�����nl[��o^�4�I��! ���/a8�!�B���KC��Z�
 & }�wvO�����_u޿�Cͷ������y�@f��2_�״T��G\��&��_1\v�;��#,Ja�ͭ�?��@�|�m)�ū9��ZhN��RE���R��T���c�.�A�LsV�9���=X>{��:8q8�B�7��lܱ���� X�S���?��#<"�Y�" ���*B���V�<�&# �����`V?Pp����e9<��m[6��f��,�	aBFE�S�lB�͐�mA��{���P)����z��%�f����������"M��o�s$�
L�-��?ű~���=�-�,���L��{���f̊l3<�w\�24��V8���V�"&@�T��� !A0W�9�]\��Q
�}�8��2ΡI	�#߂�^��r�yԑ\�U�5�S0m�    �0E?��o��N�X���U&�e<������i +X��_��:Yn�"���VL��%l��K�F<E�/�JrB�\f�@rB��{0�{%G��m��T�#��+DR�,���G���φ�X�T�� -ݼa�$TV��o�<�Η�Nf1T�y���N6��|<����ysN޼S��yFɟ�_��	g3c��&P�|�LZ˃2�e�T�!p݅�wś��9eS��'4s�|g�%�j���E,�<1o����C̡���B�� 2s?�w�ᰏ��"�G�e�94�!�`e,_��`U����$�:�,�O_!�����ww��)o݃e֛���I5/:v<NY���Q��{L�vON�{��){GX�SҊ-E|���dQQM�y�k�b��졖B���в(�c�>�zK�ȳ�9~���s������Λ���;E^����b���,�%�r�xG\.$(��&����>|
�gީ���+ l��.-|O�S�H��&��(C�Q�?tQ>����~æ�|�у~j��'Z�~�<Z�(�h��k��m�ؔ�8[Oԫے��l��^�H�<��h�ef��GbvN�9؋���0���S�Ñu�mCns;��˘0eM>9Fln4�rU_����Lo�A�X�.a��b���{�)B�E��5J�r��`�E�8<�Z7�R` � �s���̱�\eY��>`Y|_�"���ܘI�z��p���H�F1�{m�ٶF!���9��lBN��)aRM%2��b�с�Xp!|�{V��:�l������O�$��uu��*�eg6����|��mO���	�t9��ٵ&��Ø�v[J�z��`a76qL���ӕj0�P���ܑ�z�3ng�-
y�O����A��g01�t&2!,�~��ˬ�ڊ�����*�z�(1�qTɉ?�e��Z� S�6Qid�1R��{(�R����G���@�� ӸE�ҷD�/7��]ggѶQ��ǅ�_���Q sB`=�u�dzJrN�w㭄�R��˟������*�jl-��;�:��Ǚ�S��j�����Z�ӂ{��JZIx�C�6�o��_H}��GA����EM���|e��ow���T��nD�$��d+ΐwQGߺ���8��1��7�Û�o��;�����6��n
MT,F���:�^�A*-�a�cN?�����^U��I��/��B� ��$!��6�AF�r������[[@PY4;rb�s�	m-��B�<鰗++�V���~�Y<���F�K���V���[�V�m��܁X2蹕�Z�<�����
���?��OG�o=�4l�:�	�ɳ�'|7���6�7��[G�VO;�J=E>p��<Đ\���b�`�d,@=���t|�<]:�}p5��9Y�x�Y1Ѫ8��Pn�CB��wK�'F��ߣ�]��k�3��L�iִ6���k��s7�5��|M�º
���Uв�E�0WQZ�Axxp����jI~.`�4쐶�d<C���!�WK����Ք��>)4��~���-��m���#�	 S|�
5�b����a�ؽg�b�����"W�<�L�!p�� Re���l>0[s�6�K9z�,Ɩ��b��5l�<���}���vʀ.}�LCY
sR&������B������.�M��+&�ގ�_��k�lLM��
#h�c��;�n��NP�pK��o��|��"܍���
5��t�&>�Pܗ���9%6����[������5�k��V�j33c:C�(��O���Ì�[Lo��tʌ`*"N��Lj���;�{6wm�kPH����Ep<�.�6���o���5(̅�S���I}���v�;�ݫ���M'>3/��@����:��*�Ҏ鈀\9����zb�������y�ň���>b�	yĚ����yl2b�����Y�h�&F ��k#��)�ŕ�jN�_{������}�~�YC[_ʮ��xb����#6��m��[��(��hE��0H2�5�1��M��wۑ��gI�[d�=BZ�����k�;��X�[����}�g�tH�)Z~��o È8���/�v��o'�2> ��*�!'�L]=>�

���F�\��g�:=2�Z�b�@^��o$l�
��R8��AZ��C&�{_�����i�y����O�s�ǪU�ް�jI����=X���	�6�b���5>~��c>��иU��G15%x����� �ۏ��Y9�_B8Ѝ}^L�U�/a^`O�`��/�� ґP�$m���?:��K��x
'�y�y�|��f�7}l�=
˱s=�^Cx�
���L��)Y����f��]���f��<@f���5�Ng�mhKVB���Ԭ~�We@)d�jd��!ٔA|�Iq��0n�}� l8��>]x�@����Ɣϔ�xL��(�Cï_�c)�b~F�G1���-#7�@P8���	%l��HB��Fq�H�i�{4x~;\VQ����\����q�b�]c�L�6kjzL<��݁���y���fW�ѻ�Au:���0��FCa�����]��B2{K9Z1�#a"X��s�?I]{��"�`۵ܪ�(̰-�=�������T��>��+.e��cf�G���;���L����NT����J��3)KpJ��a:���K23t��43�&�͛�R/h����F�ݨ����2b�����&�[��LY T1�<TC��I�C������m��))H�1ʭ��pC8�k� �Qٕ�k�e�$�ݬC���N��f�0(#�t���[ްvi[��u
���4��X� `o��ŧ`��/�M�J�9��_���@9��5�{�����r�f��nH���V�h�[���q��n܏K�_�m֑��Po���V"
`(\E��F��u�A���� U�ס̻�_5�wǟG�{�:ձ�,�Xg_QM��:�7!��t��eę�:����!�5r|
ޔ�Q��˜=�$�j�{<�HcV�!0a%�`:GIp�D�w�c&K¶���i�l��9μ��T���zF��� !�r��p�zpݐ���?���ǃ����a�p~�J��ԟ�2k��|����}��պ�������~�����n�E��Q�ff�@ �S�P����qx�6�&S��IV�w�T߸S5�������O��
5�v� �����s-��������~�Ml�P2������u�� �L���'�������\�V��
��KE-ְN��_qa��3��0;ę�q�P��pI.~�@����S*R�@Td�/��ٺ�N���*�������4��x�D�e<���(R��^U^Đ�WR��"���~s�a���s����e0,.�Ɖ$אT�A��7�k��/��;t(�Atp5:x��!���[����2�"���!��B�1y`�{�)@zzgw�>��eC2�kH7��%����6�tq9���?��-$���d�c� �����GF�Uy��&��C�҇�����l�mC���ʇ��^#Q�a���!���|�a�
�>^�K�B�Tzb���Y��S<���.�4�߀����mo��q��q�R����hBّ��p��A���A��ZXn����'&��V.�g�o�a��6��q&���î>Z��U�ι4�6�*	�(RÔ9�����^��t�y�Gx�ڳV9�G޷p9�5�6W%[���n�����ʦ� l=�`��Dd=L���K�k���mі����Ӗ'՘f�^��y"�-��o���xL�j�N=ژaݬGc�u�JϮ��5cԺDBʉ
ݚP�7
�?���n�K���k�o��r3��|AQES
x^{F��tm��y���p�r{e�~��=<�k��]�>��Ɔ�!�YJ��ֶ�� x�QI-�=%�^@����17�p�sI�<^�2��7��kD.��S��i$Pk0KP�>K�]Hmv��`��u�ա&���J��8%��*�n�N����]+�oim�:�(O��5m
�}R>�x�Ѐm��    �Nz@9��{��=��hN��.'h����UGm��JE�M�Y`m%e	��v���O%�oX-�Hy06����-�������#T�} ��p�Q 1;��i�ttKa^����[�2+��J���m��;��"D����"T�d�.V��D��#��lع�_�'�Y�X=��՛0���,3*6�#�_�h����E` �ö	M����z�'jM`6i�N6���'���R!����2j5{S�ú�Z���%S�S�F��t>���l���\����:q��!��Z<��S@0��Y���{�ҧ�c7Z4و^ Yi2/�\�#BP� R5��Π}"����p�����Ϟ:+��L�f�$Δ���s����P��3Z��"u�>Y��}[�yE�6 8?/�́'6�#J��qE3�×����������_�p���'xp����;���MH#B�P�.�x��'��xf��P�;�W=˂y�b���=�J��ȅ������>�r:[Rט[�7��)�O��h����dT�s#�#n� l<����	���H�)`#����C�y����̽�̌��:��0���k'����W��`��-ӳ���=�_�
	�����w��]�wщ�z��0;�/	/<��[��0a�ݖ�C�:�����.�q����<Ik��]]�|�PA�H.2h����<(�nD�_S�
��=��Jד�8��g��Z�����4C^ɪ�D�P��)�5�68<:�R�����@7P�r󗎉v��U*ܰ
�Z���p�hc��{|���G*���	�f@Mo���p��L�d���ã�U
R|[֎�WZ�8�x�?�J�䔾#=�?���?<3�A��N+�p�B�r�)�~V`�X��=�
�zɀ���O�Z�jX^�l �S���c�pO��Ȃ���E�� ʦ�Y4BË�-���?���`����'���
N�v�b�瓋@;�3���b��2���N�3���{��ɨ��tR�wA������b-�*!���?5���j(@�����,x.pD*h�QGVR\�!��p��y.A�_� H�	wmN(�0�V(:?~̏r4����1��9��A�4��_���ntKy6�=5�)������=Z��ڰ`Y�����:N@Q��q�<;H��<�#��g�$XfAǾ�k@Zל,OXx�l�}
o�/7Ëο��q/��%��V���xԟr��g�����W\��/jZу .�e�k�w#��7M�T��<�����oZ��S��H,U�9C��<��2Cz�#J)A%DGKQ������on�B*�6��"a�����R��i������Ձ_aa]�e��/0^8���NI�<��1[�g`&ף�'q��H��rP+��r(g������Yw ���g�wC4��~%O�/xt�*�Z��^L�y�4Cw��T�����2�ڷ���X�`İ?$yP�T}H�
�2&AVWٍ���e���Q@�T���ݦ�{�f����j%�COQR<�o��)+���`>�>�O(���!O���I�j�g�g��;��Hu1��b!���8l���߈v������]��,�lc�9] i� �!���E�l_����\�RE�M	�,Ƽ5k_����*Y�vr�C6&wx��ҬJKVT�Y��i~9���ܚ��>����G�Q΄G�Q���B<�����j%�^�ZH�%	3%�3(nT/"AA�0S��8MPWWnE�[�C�Z�$K�>���'�c��`�Veh�"jr(M�C��q7�z	Y,��a~q1�E?s6�9�.�]�|������k�T*K��ಏ��~��)E���%O���6��4/�����"����8h!��f�(u(\J{X-�	y8[,Qe���8�s�q̹�|(ó��^.g�\�/��w�9��ˇ�����>�I�Kk�<a�������:{���2{�I�Q��{9��<��1馫��1&ʌk�����d�<Z��C���i9�{e�����i����G�}�{|x_P�����:T�:�d\�.+kZ������Ȟ�x/���۝�b����7�{|���R8��[�w����$��v����<@�
ފ�l.ëUd��3����_�N�2��8����*L����ߵIT�>��"$����q�$�!^SR�3C@2M�&�C��Q����TUڷ�)G�M���PLC�D���1n1�abbk$�x�;�KV��3<�*b0#󙃇�{0`�;[tS^t��7���oM=�_�S^2+C����=y�H���%�l�I�{��?��dP9e�1:v���+���e��`~�A,�`�N����*]���YSl���ߌ�S�&�����زu��?İ�&%�' �<�-j����0T�^B���YG�B�� m�M=�(�Lg� �����}��|��Vt�->^�4�����ӌ�����M�g8fO��,3��c���"~�e���D�aƄ�R�p:�~�_H������(�Mg�s̢��6~�;�ˑj�cƬ\l������{������� ���KX�����0Yn ������A1�ْx�/��+_R�s�?��ƃ�%fYh 5��E����t���J���K���-n^�T̔E��#R�r��!���nޅH{z�?=���=�ƛ��`�~9�9�7v�f7�gڮ��� RX�qA�� �K�K�)ZW���{�,
�
v] j��݊Ҏ�%�-�Sv���q[=�5�ϢA6	�I�:��s�S���)�#��uT�!4��|)9��h#��E�W��/���jm�"�I�t>���0W��p�iQ2v����xh�����ˠ_�+t��Z/E0=�3@Zt�Pu��3P��LmY�&����o�b�kHB~�������od�%1�:_�:��YU�ˬ�j���&i{3�4$,tb� bk��Ϩ 2�p�˛z�N�1b��U� �x0A��R��w�*Abk��^F^ǅ�P]{7�>�|�����7��{�G�0�Q���Ȋ��&�� S� sp����i���ti��'���_܎��Z|kI7h���i	,�� ��D��)��,���¶�KaPW��άig�}S�n-�FQ������(���M��.QxFr��v�V�G/�M17U?��Z���3b�U�d��R]X�#}��<��}��k��4��v�楱����h9 �gk%6��t��w%+*V;ۘJYf53L/k�E�Mu���e\*ҝ��������2�|;pX�PjX}ZX�x�DV���]��
ĬOQ���2�o��,kg�eu@Q`�eY�\�;��  (�͔g�w]_o�>}�-z���_���fuf+�\�ޜ�bS^����������g�S������\Nf�]P-.�
���݃���8���s:���b��#��6[�1�]�0��Ǌ��U����I�c�,xV�ܬ2 $e��u/�ʙ�	lQ���=O�7�������mF�4B�E����GF�q��N�]�{x5�DB����:q�	���x��<jBӥ�I�-zi����Й���V7�|���"U�ze���~�|F����'�K����#Q<_�Õ��/5i�3aY>d+2�cLc�}��0���b���4�<AR���$�I�d��g�/�"��z�Z��l.�_\%a�^%�-]%aJ�U��&��f��f�q���}��h�s�_�q3[r.� )��K�@� �A���גm�e(ңT�`� f��o��S��`.*��K�������?��m����F47��Ұ��d ���.zYXZ���Q:=�{��j/�B��<@ku�5ᴹ0Y�%���n+����>�&��@lu��,غ(`
� gJtx���wz;L����E��� �Օ  c�ȵo��I"(�t/���}����ǧ��"��/�3<�}��A(��:�� V�Z�J�j}�qiz��Wӹƕ�ҋ�\��m�%2ҍ'j3E�͐���k�qr�/�� A�t����YF
�67�<S9ΈA!5���\��I�K+��    �%�������w����ɶ�Qk��D�#��5��dZ�)`�w���NN)�L/�Wû#�1�����Q;�O��]��6t�f ��]��J�T�/�sZozd��ј~�G��_�d��TU��xl���Q7/<��hTI�`���r T�x?�c����=z�ݴ2�7�c ���M� ���S���ewJ�_9�e+��Z������ʭ�ZD:�S�G�J��_�qI�g�y�E�������J�	6�32��,�	�3�bx�"�!E�OuO�@�͂m�	X�Ȁ����2 �:VHk�.�JI��uo`�|��7����� uU����Ūs��V�t5�J4���/�D�c���j~>�m�|e;1�lf�𲎩�饙;�#^�΀���vr�k�A���]Yn�Ã9J[
BF=ʼ�A��h��΢�� �p��m�L!�#C���֩bgU���I���6E�oT�o %3�呀��V�T�p� ?�d�,K�id�vM�b/(��4D�d׽ѵK�w��R���S�5��(����~�� <|�]�O/�?�
`��F�+�;Rࡵ�+@�L��TJ���캻Q��_	��&���`���f�#`_GO
Wm��p[#�,�1�!Y��m�Y��ǜw�5�oF���ʺ����`��������s L���@�\�G�m;�K[��a�<ǲ9�i`�j�2�T�ο��aAMJ*0
T�X����RT,ʕ��v8����U�\"[������ɍԶ�����n9@4��g����Щ�K���6B�(=S�-?'\sCk@�WQI��Hyop��MvPǊ ��Uàty�d�홶G}`%� ��#���"X�R[����6�@��I��^����PK�V���M�X������6�����^���N����N(��_0�@v�:b�Q���m�cf9$ ��p����T��+�<ܭ�F��"5}Չ�s��C6�]aVp
�%c��L_�zu/=�]�¼.m�'��GE�2{ޗ �ƪ  wy��k�p��<�x������;pTKf�᫗��Y��;�4r!�0�v6�'���vF��{��0à�,�*��숉b�[��\���zN|�Ơ��ac=��uW��{|f��p�7��̼q�йe:�LR���3�b@�ϻ�|4pT�Wt�3�����3X)�&�Ы1@UU�$��"L��D[6�u��' ���'���\ގgMn�����v>���.;M�>��u61�+��gy i�.�>�`B�S_���e�OD5BM��A��:��8�P��:G۵�z@�h~��2�%8].�>�fh�:�7���I={�C5�hۨ:i�],�	�mi�����}����������_��~|�9}��o�7��9�|��~������{��!i}s��3��:Zu�����^���@�Ȉ�*�Sc8D|A�b���f�����m�2�+�	on! ��S�Qދ�h�� ���#�P�͎1x�= �8 ��(�Y�G��̴)#����l^.�N�0�6Ǽ�讑�8�����RZ�g����0��gE�
��~�_���Kq?G�q�q��/ea�p���!{��+Y�zϥ]�sW�Ka�l֘�d�]X��^�x��#��FK� Сp)ڨ�.��JZr<�rS����l��z;�@l���]�6����֧�F��~ݧ�YPѫ�:�7#"��En!�9��Ȃ�Q���vM��\ĝ�o���'��������/7���)���, �FK-ؤ���T�=�� j,��y	���t��	,�;�o˝+U Lς}��!�$����pS�r$�
;��u��L踨�H�0�ǐ���CMֻ���S�S0֊���RK�k	E�:ǆ�Q&��A�i�6:��j�'�P��=Y ��Q�}���r{/�1f�M�q�ad���2�<<�͕%��Y��c[����Qɭ������`k�+sC6�h�����;�Dכ���l��)�Kr���KX{��O���6;����`��� �Su��*���[kwNvS�{��@�}s>�:gb���l|9�X��?�����T~�LKU�l&�0-f.��LV�"�@;�#b�m�Y�|c�s/hfŢ�@�˂�V��b���:r2-��֯jf�)
��z�s�j@`7#�|�L��-Զn�@�R]߹��8��G��SOgD�dv=�S����o��R�}�6�b����`���;��p�QO�N\J��js���,[{X��f7C:�G{�G�㰿-�ʐ��a.��}lwV�"�ۑ�*��-ֿy�+¥|�ϙ�J����T��1�
�9�Ԝ�`��=�ܽ�Y�0{�4J���a�C��%[g�5��q�`(F/b<�?41�N�klAڀw��������ux���-lj�,����h�'lF��~�$X��9V�Y�G�r�q��Y4%�@2a(�,�G)K��'m�b}��K>���?B t#,'�8QE��A�hB��������l<�ߒ�7����jH��V��z�VQ��'q�i�Ҙt�C�� ��W�52˭���r7|���;l�@�;�gc!Lc�H7�$�P�f�(6Dɤ���Ne�Ѯ=Z���B� ��#|�3e��B��`7v�+���p��=��o
�ly�#k�I+��?�L$n���h�8 ~�<0u�b�ט���A�����ɜ=`�t��]��@��˝�Ř|F`b7���{z�~8�M�}Fū'.����K��1��m��{�=9d�fC����X/��;lkX�H`S�,��[#ĥ�i�jO��#�u!�p.f]"5j:�;w�>�'���u#\�L@��"yLX`��0p8�Y���P�����݆e�8L��\�Ym\)�}fbO�~ @T�F��1�����o���~� 1̀�$A��`j�L�d�6+F�u�+��hJ�B�U ��0��L{�u�,�m�2��*�j,��FH3
����H��yB���o�s�o���;�d�8���Cg�^�ߣ$:LӮ��B��@�b��	����<�����׺���X|���~��	d�˘@�]��BvA�D�:���1���7|�މpBk'�Q�[}S�
�^�{' T�����2��Z�~�\Tx��i�ȗ�:�L?L������0!t�n�X(�M�TH���H	�����~Ӥ���O��	��%2���Kl�9�#t�p�뎻�V�*����zt^��.��r�44�&-P� ���J�	f�3��d@%X p�l�6�=�S�m��P����) VcP@ ��
`�Ɨ�����&n��UW��f	3&@����Ѭ���ח��PE�=FFֆ���dpʹ�x~ߠ�D#��{ĕq�[������G7��;�_��	�Y*YY���:�|_3�M��a1=���0�@���c��c2�RgX��/m�ȉ+��&��Y�sr`M��toC)�q,��F&B�Ϧ�Y�ih��0��v����%�������/DQ�sy#V딗/���,l��0�M����{p�^8v_{�!r`G�ʲc���;F熝��ٔ\�	/��^��v0��ť����Q7����.<G*�偎1= �&�͚�?��y��,$�4�O(&M"菣oh|ܓkyҬ����h1�/�`��Wt�	�F�i������K&RUq���{��G�b�-���%E4���LV
D�,�Q�f���;y��
�YJo#��g�W5R�$�%u�Ȉ|HBuBP�X����N�"|J���at7�a};�1D߳r�����7����z8���6�f�Ҡ d@��L�����?<~����ەh��z��d�k��C{>\il���&���|��3Ɵa\��G���U͠�V����=ۣ|�q���Z��E��SL��Z|�殼蘖om�5��D=o<8zas���2����t�ʞ~v*�?]O/�ߐ��E���BP"�c1M�_��4�)������ `\Si -2�B�Kb�u)A&�6���<����, 0\��Kе���$��/��f�b    J��v=��Na�1FH��F�n�q��&�j�@�K��hYp�P\&��X�����񻻾k�g��N��y���߲�����y7Y��ʿ���M߾c�ܢ,���n|3"��=��!��[����1��V�]x]#�T�:#�2K{A�c�n8�OwlO(����Ԡ{`��q,�wM�j�)*qOT-���l<�WC�<M�\˚w*�Cef�jL��!�,+�w<X���ϣ�X��Lr*;�A�6Q�K�4��אb���ꦓ:���t���B0����\���a�z2�������v��O��A�&׫�grc#�)��t3�B�%��!2�xAJ�M��kRʐ��d~�m���Y�c�����k#r̫� �<V��bcc�+��l��/a�CZ2�]v�^�a-��A��I�]�E��'C�&��OƋ�����?�Y[�J`�Ff��<B>�ld��lz����&�o2,:ܛ���@�)�� ��~�%-:j�a�ׄ�A3��SJ�@C���]{��\�'��<@��# :2���Z@�M2M]W�B��̒��8CK`q�����\��>��>Ͳ�~���$� �Q����}���R�y˴`�o�UCb,1x�m���x�d�Lp�@�/�z%!2�������G_�L��	�	��r��Y�d�E!�� �,"��3X��j�`6�3hL�K�TBs� ��	L>�\	&��ao/��f�I�n�λQ�h�4���H
�$tI���h��J5��a֢%T��~s�Jc~L��������>���Ș�����'3̠e������4���	�6�Mm�A��|^�ލ����;�`��k8��Ǒ��|=�����m*[�S<6�6��r��f2���0�ƺ�?AE���L���R��.j�q�����Y˅bO�kh��M��p�r�}-�N�����j4����o7�(�ZS�Aqh7Yn����`A��@����^��x�������v�$g�:��,D� �p�m�U��Lޣ
���٦��t� J��3�
X���R]j��;IwRL�J�.��]�N��,�Id�g�1����>f�=lbU��
k��%��s*k�O^�/#T@��5���gk/;t�m�9��W花�E���%s��?|��܁2[t��Y�(�^��孁�m�Zo6N;�è����sj�ra��״��ђ��׬����q��K�,�����������!��'� 1��p�9ıo�ms��0��y�T�Q��u���)Q����3�ݽ��erX��7�k @���W�X�����#�
�K
��F�6���b��/�ȑ'4��`.����ÁM��Em�iuhVm�����j2@�Y-�ʏM�Ţ57;�w�7�q���_-��{�aS�
|���< `>P��]��,�Z&/� �`]�|Ίf��k��i���/<�)�{B����ޔ/�F@����`��()� �����pF��Bu0��9ic.��1�X���� 2��������A��N��-2��D����:�w���b��j�'�ɸ�{�nz��L�E�:?��-����%�.��u8�؆���v��%��ª�1��6��
V��t��J:���J��+��=6G��7l��=Zq&�v��Z��k�$}�������È����$����{`B	�Ͽ@=��%��i
%��`q�	k����X����i��WS:~LX��@r�������ݗ��Gd>p���i>,�p�6&%�fް�)� V�X4�vN�1u���V�a�	Jm�~�ˇ�k��*�,��:S�y�u��/����Sp��+���V���[�8�4ˬK#�
�PO�k�e-���"��ފ�< ��=�1��@���@,�,k��`םuO����4��0���`u���	m]*r�̙)�|�S
L��Kz��I��-�p[\Z`�q�М'�� `u���*��J%b��hv�[�t,��!���I�E�3�0��
�d9S�Q��Ŧ�M{"������q(^��`'K651B���	eF{�6>bY���a↩���9j�u��&;�V�ce�%�>@@$��½�
T����L��24���/���!�1��_�is��a�ֻ�o��j��{ەl�^��Mz���D�'��G��Ѭs}��\��5�W���G�+�WI0�-_0��}
�G�5���gJ
}�@F����a�_�����s
�K�<��Շ~�R�+4U4���Het��8�y�`� C�3�Mo;��o���g1��W�3�9o�5Uq*臣�(jy�CJ�ytQ�;Ȥ�B���T��y��<y��)y�~�q< ܜ��$�;Z�+:���d�9�ﭐ-xD��ѐ����t������m�qq�x���VKN�x,��{�]N����O�Xu^SrwE��l{M�`=�!]h����S�(K�k/��O��=��>�1�w3lt������i�)Jx�`��5�8*��-�7��Ƃ"o0��"-�A�O�����(`0�P*�*��ݮ����mI���%{Q)֕q �[!& 1v,�!�@��N�awp�����k*�U�	�����L�-����W�N0�8J�<{vD�n��-��0��A�Yo�8o���:J�(W,;��:0�P-�Ïlo��So{=�C)�ȯ�?j	��}�r��i<��V�&�Pf��T�7�ϗ'8an����Hz`y9OД۠KHyU��[�Ns��I�����	@Y_�q>c����J��;"�;�h�G�2=��x8g����
>����.u��ED�l�xa|��5)DOg@"}&�3ړ�ޖ}� ���s}�ԣM��"�,ѳ+R��
��b���J�i��B_,�b�V�"���e&[$O@o�=� 釃�A6�������tT>)i�(L�$MEs���yh��6W�#Kr��N9Cu��sK���%�-����cFm����w��[g� I"����w���n�^�ȩ�����!�U�*� ��������o�yx�k$���}���:�z���@K��O��ܡ]��0-��2�NJ����OF77�oËy� g��ݬRJt���3�����r0:��['�옣�{ ���ƥ0t�=>8��!T�b�}K�/\XgC�
�3��֕�A>/�Ң��zm��*p]*�:���@�^M�����r�}��t�K4}��t}�� �O!3�M�ɭ<�e%Ό6� �֕��#��T���)����Yw���U�e-Cw��7�����?�xe��)&��Q��&�ډ�I!0��iøi*�Eig۝OsX�70���}�����M�=N��2� f��$��& ��G0�G�`�6��D�yN��i�8�B�e����t�ƃ(+r�
t���� ��C�Iu�q���32�Y�{�GPa��+B"��%V�����0��k�ۭ0;D�����T(���{']���>�-wI䋲S���<��Ϟ8�se&�Q�j�QS��t0z�
�T�њ@!�C>���N�a�u�:�����T�QR]^6|ve�J�\何I��?:�cOg��w�o���\|c���1Th�L��[/�J�I�[ �,v��fsX6���+��/�;��A��q��H[�����ְ�Df9~��[a��!-��d%�[��cW>bu������?����b���6�@(��T�Rt
?k��o����G���e�j�r[����L(ޟ���{����wiqk�����;����>п�O;ڶ�V�jn�/�D�ER�oo�$�V����/�������i7�m����ւg"����g?]q[>E����]3DY(g��x��)i%�К?n�)�.o�@��A�����fĂx�5�0�vK{��s��O�>�Z��W߂�
4��?�����5g�.P�w�w��'|�2�,�w�+�S����ӂ@h	KJSb ���:2 �m���T�+�b쭾��RYrC��vx���(O����҆`�0T
�A8    z�i۴<��ǭy(_�'o��ͦ�M�̴9c;M���+�=y�Hv+�t��_�s�0=��.�-��'���xs��HЦ��= �n�F�V�lY1�W��+�������6�f��=%���C�*U-�?J,"��$�-�s
�q���vi������mE�fs�E����:��k*1)�VX4�1bʃ5?�9[}�����3��
���gE���k�5۟YX1�|� ͭ�M,qvPҩt\��2*��p��`�V�  ���VW�^/zM?ߔ!
��&��}|ͬ
���L�r�[��Q��m��T��1Yu���%D�m;'{��k��nluPv�!�A��w2ܨ�C(�1�P�
9ٚ4���1 A�Ȥ�.�{?kQkDė.��������H��h�� R�����m���L��/���`�q |��Pڑ+�_��ք���?P���v�1Æ/�s��W�/߆W�&yzȘf���'�Ƃ�u |�XEn��^�&@��}�`�3p1�	%��zxx��9�N�W���t�}�7P��9���@��c<��6Vv_^���R���Bކ��7�8L�IQ����m�;��<)Y�����fIz�ӌ6����V3�^A�,��?��~���C�p���A��rAeE)��nI�x5�x�%��S����S�01%��_�`<'�^yÓ�@A��Ȧ�V./7;����:(ɯ�;�|��ui.	��t�M'#o�SYE�ʬ�vAk��� �#���n
4K�M���)��a�2	]3t��Z���4�]@�@%�9;���l�5��ȄY%`P�6�r�L�E�^�Dlv�CX�1��
�G'��9g�/�&�r����;:���0�����^.����h��Q�tND��ꄺ R�CE��:�� ��.�f|!�1���]�b�Q��ij���r�Z��R�����p2!�6o֬=�H鶪�~"UJ�Z�uX�j�E�P�(0������Mۃg@P�,^Q)����S���'7�.�����g����x��<�`6�:���:���z���g���̪ə���S�dx�J@�t.�&�[������Lpz���f7NF7�霸� p�V���[g�-F%7.l�:�fm6�j�6ʝp�;{�a�{
�?���Ƴy`����SK�	8WQ�V�=X��`�40�x������٤ Y���g��Wd�Ϡ�c�j�͢�Rh�-.���h��*8]��Sh�8Q	-!�%���H5�Љ~��hrAYՉ7�?4q�&M�_{��­�V23�.ep\�3&U@��
D��eʢ�f%�b�9dW�V�9sZ<�3ͣG�<:�0h��Xn�Z��MV1�Oȱ�B��r,:��3lvCY\��:G��C~٩�;+�
���T{n\>�uܵ�|�M'�n��TT2�r\�����7�����ɵ��dC�V��hDa��P7U���,m�S���Z�A>�3g��3�O���<4n�ejkw|=�۫{��pv3�ޯ����<�e�9j����^�*\zL�#�{tJ(Lt�"a��1�ŪOo1�D[}��MH��C)��!�����/��H}��������V���ۘ�����d���)Kj��9JU1��oKۣӿ�<�4����N�����˶��#w�Z(�ȭ(��%�;�+� D�*P�0^�e�����<�Տ��b����ҴÒ���ӯp5Ww��1��yR��t���׼A\�<����}����D~.���9�+A&���;$L��wb� ���Sf$/��J����0�n۸f�܀�{�� J���F��L��:T/�Oo�f�o��2��[�Ĝ�Q�| ��D�%ɠ�6, YH��5�./Y����o�+��i�+6��X��Ht�]���H�����XD� P�6�{-�b��s��?��QːO��r��>�Ԫ�W>%�}B�4��i�l?����������
)��g���p��?\:m@�yx�O��>�x�u�����m��c��A֑]A�b�3h���2��R��Z���lP^��-���n4�1[�[��ylg�S�0eȧ@����{��GEKR,T��rZl5�H���Y<����lV�DZ<��YZ����k�E���J9m�h�k�7��΃�A+\2�NxP#,PHiK=HŒ�h}��u�#��t� 8byy�N��ˉ�z�G����@�3�(y���ۤ@])�C&�KIĔ���}�E��iM�F��3旲0�n#Rv���:Qy�&+���RG�Vqvo7i'�����݈��3���!D�v&���.�d�5ʀ#��HW5ݭ�b���c��nе��]Lg�7PƢ���T<���5�o�7���G?pX58#o�\�Ὁ�`$VE��T��BL��d�1ov-QGkV��dXKgJ���F�z��Oo�������hT{��M��L]C+�]t��j�LjZ/����`�{�q��u&�i�l6�T+�B���H��)�U,^/����^�{����XJW�̀�a�P!�]ʛ��?�Pix5��5{)�����8,m&������,�; Kg��d��1��6~��!<�ɏ�� �ېC����U0����@�,sy���<kRUo�?AR[\���w>�1�i鬄&�;�Jh��(��|s��8���DL�����	�:$�n`ڬ���Be�D��҉,|���<��Zl��l�B\J�Ⴥ(Ě�(  ��:������j�^A���+|w��t��0[��)�雲S�Ϙ�exS$v)^��������Ōսl�!a)����3�P<�׬E�>k/�fxl�qȭC��T �MG���p!����79m�OLt`��&���&��1�u
)"w*�Ƌ'x���)��me� �L�����R]�`�]�����_�O2ѱм�xeX������(F���S�&�mԹ���ݬ��7���J���u�ܡ��U=zJ2b�WY)��i?�wM��]��^��n��<�Vpf9c���i5�~DM��B����#�kǳ���?�FZ
�ϐZ6����6���p��`f霐8%�m=|�r|/���ѹ���5oxOPm�,3���C�a(6�-�'��< E֠EJ �x`8��cFK��QW���<�B́�0��^�!'�2�G�8$)p^�A�T����[1�B^,�B���Vr�W�D��bVf�ݸX`���%7��Qט��+���n<��+fJ22�|��W$��n� $<s�-i�>'�rƷA0�o4�X�v X��5L(�sb�GA�23A��N��ك���.l~�y�m�b1≗����uu�����b*#r�Q�ί�����&-z�����a�g0�0���NP����Ց�ú�@�[*{��7��Y��x�P\���ؔi.?��ڳS�<���l�w��+���T��(�:���������s��T�"q��� L �<��̨�v1����:���x�j�[I�N��v���+��S��ֳ �HfW����Դ��ba5)e��i/t����̳9T
��0��W�Y  ^�K�"}1����Q�d��,�����-#1�<�<#*_���\ˉ��p��?��� ��@���ބfւ����v�Q�K�xf��-6Sr��-��;�ǧG�㳃W�=mǧ1�kd��Sn-7a?ђR:|�@�<�~�ϑY�"ga_�f���G��lE4�jT`��T3���'�)����K���ط�-Q��Z�S>�M0�� b��VQF�;�g�{���*%�W��I���2.�)<V;28��vdߴ(Л[h/⊊�|�g)IP2�K+����)+��k��|@�q�g��D�M��B*[�^���|�1p��n:장�
�\��U�׼�N9 �N��Xe��`4�\-�\m��z߶Es�����A��gе��s���0s�9;�����e˾.�B?c���4���h�}�u�T��(Z���8*f�G@4�(YY��4/U:*����� ��*lsa�e����� �>ȼh�K��
����&�J�G���Dv�b���wЮL�D��)���w�G�    ���ڋ��X�E�b?�-%�%9R  �*���`��>Ӊ[t���1���PE#�����C1��l��N==v��?�x�A��+�.����9;���|">%b�3��g�
߂��hɹ{f%7i0���޻ޜO�Mx�:&�Q��O���,~$�r���T�����D_����̄�E�>�h��n���#xA�[�[x�(�,�=T���^]�>�����;;or
<�	�����+XgrA
��ao�t�g�z1��btD�dM�|�@��5$��
�	9N�náwC� |��)��)���{0�cå�2l� #3)LȔ��L�Y�'Ͻ;�<"�eG���XD�yû�S:��S��[��ˮ��[@ںX���E��9[�m���zj�n�R��Cq%:��!�:�Tp�|QfP�@W��\�9;�����w�7��MAWk��1��u��6�1��k����V_:�F��$!�ץZsѱ°=R-0d�kL3���=������R��n�=,�[��w�kT�0���Zm3*c�'Ϗ//�k��
������������y_[��N*��`3�|��Rd��b���� ���K��qx�Œ�enˎ��q�s�0�ɧZ,Q"$0��6}/;fir�Ͳ#�<|��7gÛ�$5U����*=4֚�[���0�X����HJ��;M'�2�`���ȯ�9Ō �I�9�^N�_���]��)?)�Z�#��ى�m0�	�c7d{(=�>�L/��G`�\�v��s�����퀤�A�8a�k���
b
iA��^M�'��m"��r�@��:ig�Ւ�ZN��/e9ڊ�x�9�  ����>k���y��X����\�݂�X�q�'�:�9Z�\�@���'̷C�WEa��L��v���Fn@^���uך�E����t��}@�	`�5�Y%����R�7������	H�Q󬕁K��[�>�|"0�T)�J"	>R��ʨo@���&�����x1�>e�?���|��ci7-r����Os��~,�E!�����@������jo_�V�`�QM؊X$h~���]\f(�z��>��.%sr�'��yU���z:��	'0o� ��^�(��1Z:���@�ez����	��*�]*}������h>�qo껽�m���eDƅ�O�*�z)NFv�:���ZB4��hx��� ���sgq��Lg2�|��n:��6�I_w���m�z�(�[���N��Q	*�TSѓa3�:��4m%�9Gev��=,�21(�����Q��۱�2C�Ѫ�M[ū:�@�`��㞕�;l���Ѷ�󠋰�a0��0B�*9�,Hi�4��S��FL������0�^)Օ�r�T
x�������&a��2��^�A�����*a�Fg�Y�j=2�����w�<P��Z$���+��[�P������Q��'���9��Ja�s<G�a�}Ya�W@��>� s���\@�!�˻>wR
5�*7���e�c]eo_[)ʙ�J����R��R�@Nd�֥��s�U�%���9��{t4���M�uR|���O@.KB�rJ�\y�����dΊ���s�'S�2�qB�EK7���g�{Br�Y��ѓ��Oe������cVHK0�^�	��T�U�-���C4Î��g�TC��[NN��(c1!.��(�n���l������xc*�Q��yI@��5M �d�#^U�y-WF�#�������?=8>�c�-3����dT�E �,���Qkmۊ&_7���Z������e�~ak��l(�6:�^�E��[�����h�'F ����k��mx(e��5��"���f0�Rt��w.�IU[WBz��Z�4�/�|�U,��>����Z]̠���?vM�K���C�-������	3�0v��;)�j���}Z�q~�hg��[�LWn�ݹd�GJ�'��� v��d ��������,�$~���!Op�ݦ���!P���f�A��*ǜt�UNٷ�����E�W�`��F<�tlq��,�4����b�&�\ByQ�s��H�e�WL�/�C<�=�z�l=�H���s@NJ��M6�L)����|��zƪ��#�����Ӈ:�O	�%*B+����������dY�H�'R�l�b�T� ��'B�1u4 ��-C��e�x������%��˻q��iԇY'�^ �{S/� G`�C����Sw��-#���n R��塞��H�,��/��@�(!�.﫾��^�(z/,\�^���Q*�Ryoe[n�Qe�g�����,�M�n����G7�0~�����W���p(@�{�L7��E��K�6�:�l4@ٽ�rqB	���pZ���XbmN�!p��q�Q�i1^�)�o3��/��C[A���㊓��k�P���7�?��d����n�;YJ�P��o�o����{g��RP ��$�����kP*`^b���d�؊{D�*:Z�����V���t��1�uAÅm�9Г�����1l/�c���5&��A,�M[�`u�`oq�J�ࠎ���Fq��''��j�6��ݥ����uo+gr4�1qis��?���ҩ�0_�=�q�͟����Z$w������M���e���N=&����vJ�A��3( ��+��� z�Yz����4�O�_����k���U��a�Vj�c­�dz���*��%i�*��؄���ԇ5�a����V��9Ei{�	ί�W��c���v�N¢m�t�7�G.�8#���eF�b�6�rU�����[�����%�L�]����(��!.G;����Z��c��]����Rz´�Kfn�� �\�2o����`����F3p��5���l���I�bX
4��y s��V��l.��}w�U���?�3����_>�ه�cP���g�zT�>A��o�@�0���kp��r!�&SR�����3���t}<�L�3��_���#�|3��mS��cv1� ��r8{����;���f�2�;]c5��k���1��=\hO�Y ��RB8G��DkL����]{����s{��Z�Ƅ��<�
��G�4�˵�ph�b��k�������(��7�Ԛy.��G��C�eL>�+j���r�57����k�S��Ƨ �I�0/I%�4`�x���}��&�)D5��zm+^dc���ח閥���k>؈F�v*�҅��)}�"����]{��7�vr�e�l+�O�%���C(}�E\B#�r�4��nzG��|F�@�n��o�hy��U�N.�M��*kCL5�1��ߦ�$b>����-,;�����|&�@Ӑ�!H����(��[	a��{�,c���އ�RMmR�������Y�T+��=�L,�C�*�Q|`Ά�k^��^	��@}��ę�ދV}D?��4r��A�h.nu!ͤ�OA�F�K�M�J��&/L3o��\���ǽ��`S`�P� ��լ"��dq��R�hqC����E���ڨ��F���1�GY���V��&��N)Z/oxjUT�uJS!����c�pz��9@�����S�nmm$Y��5�+t�������a�lU#
�2��Rj[� �Ə���^;v�!���L�[�Cu�32b�b���*�?+�8�:.WCٗ�b�UUA���@������ҁ�B������۟0�2S��i�j甂L�Ί�k-n?-�_����������_E�!���*�g�"$R�M���-9E
�*Y,�������*)�\�u
K*�4�*�N�P{0���T�O�� �uW�ua}�]���	߳�O�e7}Ճ"! �V��732�.m���2�-_q��C�6� �8�З�̴]}�IJ��:���X���N������u2H�5�&=s��}��B)��!g��;j�ޫ.�s��Ϝ��~�:(�ʾ��l���y@½(�{&��� :�v������hc����[:��L?!���ֳv*&J�ǼN�v6���������zp��s{oJ_�A?O��;��1�[�x�T�눨�    K?�#Ⱥ!s�¦��h}*��0��>���ܾ��/��u�f��\���1TS�.���%���B�ӵy�� 3 n�7s!ȑv&9�S2I��ՍR���l��O��?��Bo5��Ҙ�3�y?�cjw�R�.�������ԇ�F�K�Ń�J�ℜ������X�K���P"|�)r����[*ͭ�,$�!�ȸOU��������.�z��w�B���!�^�K:�Q3<�Xt|��8��&UE����e���`4H������ q�9n�ȽP!DL�{�xc�x׃�3�>�T|���MF�-����RI�?�&u�7����1T�ɔ�y��x��`�]�2E˧Q�J�g����Zr����=nN��;���&�ד�6+�>M�}-U�[5-av�����>y�X���y�ܘHk�;@T�!����)�/��鳴�@f0�cU�嬫lY)�x���a�×>c�t����ޝ�מ�՝A%-�0\���	�D�$Ę��AD�*�]J}"�DL�ib�7��h��v��<� <�O5�&Oo�=��?�\����xl��ŠB�Ae) ����k����)����l�b�1Vٲ�a?ls�Y�*[ͼ�xl��f	fQ���v8:����-g&�a9Pse	P��!`1Z�Fc���~;���!�ǉȓ�x�,��@�Q�4x�:Io�2ԯ�"�x(O�#��c�n4�p<�N��^ `�>K�o�A[0G���-�΋M���r׽��b=�HOWZ�5�����Vy�k"��>��ł"(��7<djڂ�n�RV��3�A9DV�{�C!⇻T����pyBˊ���g����.H?z��]c��P��`X/���kﷰ�����Ӳ�)��/<�W����3�>��A��h'[�ETݑ��¦�!����3�"�A��t6,���K��RT�u��>|�wav��#o��U:Ԛp+�����S}�BJl�������G�"x���3��-���]�3�l�z�"��A`�䍕7�dR�Bߎ?�?N�����G�����E�Ȁ4[\�Gඃj���%��A��@	�,�#�r���ȫ�� ���	�7���`�;@[�R��n�>Չ^��}���4]#�5���FK@&uT�?f
�1��Qs���P��韴�^��w������hq�h���"��T/���1�GF�����/k4t�wd8����4f�6V	F6��'/m4�v��,��2fb��h)��}��e�|�5U�p�A��� ��3��U�t�"e?�l�)]g�)i�I�9	�wL�"<��F���g0�
��rJ`k ���
bp�Z��rh��C�B�I!
#���mڇD9�ju;_\L�Rޒp�wI����S�(���2�(�Nl(����HB�P��r��^X�z�)���.��?,.O'���Df���f���}��ҷ8�Z�:\����J&]1���"u��-+<�Z\������އ���/�WE�ȷ�PF �=��>m�oGZ�{s러�;J-J>�|����|l�l��f��kik#a �;Th���M�/ڬ�[Kj��.�S��e�e%�0�G�6���<����#:H���۷=���ӵR��&23��O�1p3y��{���%[f�(�P�:�;��:�K����-O��g��M��?e��I�5;��3e����|�&�@K�����Yupp��6��cETƵC*fI�uo��
j0��k0��M��#��S32��W�̆t"�5��0L��"��eL�n-"��������d>� �٤>Ԏ��lM��N���2*D�k'�Y:8[�%ggg���Ŵ��Q�����w���\������~*Z
6z�8�`�<%��ACX��M�ļ��O6[�n���u\�ۏb�3�����dX����A<���V�N�����������{�x֫��n���D�<�Z�����qڊ��=q0.�`O�F��([��C�} �*���EĪAD\
]��8��?*K�ڸ�=:��u��M�lvQ����D��;6'�t�|q���9�LT�tJ_��\�.�������5��,�>�	�����E�լ�����P�Ap�r!.a�P**ܕޱ��7ǉ<G�}Ƣ���gL���Ҍ���Tu�u�*�^�(Ѫ�|]~�忁q��gUQ��l2"��H��CU���}�-�]-����ӓ�>,�!����Q	[���]/����.���l�\�'�'%����Q���� ������S9k�EI�{���+Ɍ��{�ǞqkW���
|��WA��膁�)����x%��@��SY�o��%��@餫�{eT��,��p�7�mW,u tL������EGl�/�9ʴ>�y�F"~	h�Rv"��w��w�lG/�͙�B�};�}Y��trw=<�=����	v��K��^��\�������(}q[>Qp1���~?�H�S��M��N&�Z�:8�b,WW	�'�������Z�/<�5c��ۭG�׺غ����:aT���wP�0��eT���Z��G��UO�G�1��S�F_Ll���)�$�$c
*>���blߒ�(N!EP�p֮TzC"n��f��BD�Ƀ	���9�X��JȀ��t�@G��:��A�"�\# >'a�g�K��\�ȕ���� �r�_.����lJ�N��0�%�|��>��ߩߩw8�8�����?�7���{����-Ӊ��^ߵ^�Zс���R��]�u�����A�=J.�ԕ���U�r}pW{҅o-��}:��g (9��[�m��kU(1H�&D	u�s�����ć;��6�[L�`(<s��Qy�?h]��X��*-�/F�������4��Z'2a�2�F��:���ע'��2��l,��7��W�_�E�W�v�%�6��F��m�rQ�n�&��j��&���1�N?�"�.�O�ԕ��l㲜����zq.r��/����"�ON��|����>߷T��X..��/��h��"����0�+�`�� ��ԩ^r6c�"E+��C���>9F,v;�YU�N���Q�^<���2�� ޠ KAt�-��#�P8�����b|����Z�IwY��iG�����S��,�y
�i�~״,�B���u3<���cb7��b�����buđ�U��3�C��v��c4g�����YQŸrz�,�Ca�-1Ǝ�T�j/�gB�>g�Gfr�{fV�Ҷ�M%�e��Hv�89/R���3�Qs��z�z����A����; ૃ ����Th���g��|vM���\u�]�u	 N߹){p����{u���(�PÅ�p���C��*p�cj�)Q���'Wg}��_��<� qu=�_u�w�*��|r:��a�d�zݝK�o!�ųf�tx�ʳ�0_:G����I��u3Ŏ��z�_�c�Z��c�pp�'�<O��Amt���6v��Vnq����mjkW�mYǡ	(�P�� �	%LZ�KJxG��xv%v�<ʟ|�z>�Q�I�=������9J�_�6ǌ����aH:���Sj�6$�:y�a�|��σ`�)�������)P_�y?���ci����� ֐卵�r˫p_r�>�+ࢼu	d�8�k�Zk_�)��ޟ\�r}���G�<����_������3��p���;вR���AQ
"�A��$A=v�ļ�y��3�eA�I�x��T!��� �p�g`Ӯ�1��O�k��0�g��`;wV�����ꈞ�����@�C�J���m�e��%�F�,�]�XO>��\�H82���f�4���Q����9xud�λR���w�$H;1�+� l��'y)�M}�RV#Q�` ��U��s]���_g����ۚ����pP���a��vHf��qc�e:�zv� ��v�~?�������ۀ���=��M|��"�EH����IU���-O��������"�    ԧ�c��uH�1���-��L#O����ly�d�?[�㯵�{ ���p+�!T'v6 4A"�l��a�"er�� `�ˤ�k�s4L�fx\I(���֗":����g�;�
SL�C�RY���W��gP=9�
��f��d��z,��g0߯����;d�)rg�� Xz\e�҇�F��(���'�v7���p>�*�%��h�#O:o7��傿��ݚʝ'��/��!I И�*����^����6��Fk�=�*��JŅi�;�@�x����b�dC`�i{�4TK�\�� �&*�
R�F�7��g�7�ߜ����� l�~~�Բ����G�ƺ��~B<����D ��W��*Jr�"Q�Q�B�03ȤM��)<٩mX}f�����\�M\ >O^���/�דFґ�7�&+��M�BfJJj<�4	8�+�޵f��MG��}L�x��v��jv���b`C��t��RZp{G����07�	>k��f=M1��ʔuE�|��}ZV�F��e4�^m` /?�zD6�h-���� �dz	��6����f�i��w�gټ�\�+П��xɘ^�w��� Y�Nպk�����L�;����ć��b�'e��.������k��*��F�B�88�V>̇W��P�q�,�c[�U*"yO�U��N>4������X�HY}7�e
���fF�ZuĚ9� ���}h�gi'�G]��Ap�^_ �R�H���f.n(ս㭛w��A^n���/��TMe�o:��x�7�?�;���$�� ��J�(�3m(ˁa�h{�6#7*��s��~Խ�������4����tv�㈪�P��B_Dn��Jt�])���`�3��U(_�$D�Xq�x��3"]�Ζ�2]7��#��;L�͆�3؁��*IA����=~k�1��
ד��e��a>�:k��vr���N�-_Y��N�!���."��ɢ��ȱB�����{Y�[q���Y�p
-����[~���Z_��A@ŷ?	��XQ�d��$p�B�Զ?>�頍R>~�a�	�����lM��DH��alj�*�,��r)��~I	���=4��xª�{���5��<��NwLӏQ���g3#�����`��2�D�̊�WV�F td)Ɉ���\CL���O8�*�>���?�1,<ŧ�����j��WAl�0�����[�&#*�k7r�t����ڈp�q<s��; ᱂�#�5W��Y�7�	���W����([E뤺�`W^��7��Iu�Ł���c��^򯔋���	�Ud�(�f�l���3.Ɛ��ѧ��O� .K�����e���a����ug�m�ҷ�f�׈,(��)Q��GD������F>B�C:��R�C��GØ����e;OA�C��Ww�7��lD!Sk�I&t� Աbأs�
[M�$%ri����ͺ��]�S�<�Wul����&�"s����i�#w�F�$)Ӎ��"Rhiii���	�)e;�+��q<��ذ�fOl͝yL�2��v	�����kX\R	��-�i�9�=�IT�dhzu;Y�T�w�W����J�c���SD࿣��#��(��;N��ah�nmwV�����ҁ�	"t��㍋8!x{ZX#ܑTI�Wm��\yJ.�y7y�ε�sU.�<��(��=��M"..f���Y�;�Jh��7ϖ�5J��c�i��-����͓��áH���@6�Ґ�ϖ��mU����P�� �Ü������k�K;�r��s�Y��T��.��X�%���v���Ѹ������=�Z��=�m��{r؝ٓ;Lz�nD @��i���$��w.�?��K�)�Wc�~����(ʍ~��?�wc���l�k$_2� Y�/�)ܴɘ ��Eh0�H#�$Pg?�Q�)��n@�hR}Jʺ�0�hA�r�F���E�֘K�`Ǖc�O'�N��2۫�WB�c�����g;t��R��y!���G�����������]��_�l�٨!U0U���@�@	X�X��u�򏴮>�\W0�к� ���r#Pe���H2oqٗF����i��|RI-��r��y��9�=���r���@�.�^�#�f�kQ���"���A\�%��c��S֍	��PD>x�\���1e � ɑ�ꢏX�u�>�Z���)T�R��7�0S�}�dE���$8� J�iR�}�8���E�w�O�[��D`�|�P��s���s�ҥ
`��j�tI�~?N���lZHC�O���E{�o���8_���X]���^���?Ŷ�9ڰ� ./?Ȏ9����)���|�y<�ȢU����pa��S�Lq=_)�� 5�!� ���Rμ�S���B�U�}myƲ��8D	[��ac>%@����������r���������88Ͻ6�?�8l�+��hH8+À(Oo��8���?J�[��#�)��*�S��2cGy�~����f���DQ��\��4e�vgp�w��D�~�'x�7P�������t���N�H�P�x}d�� ӱ"�u��d`�ov��.�/&�k��}6Y�ޛ�6lk��>�����1�@;��Ff�0�ԡ���ыD/y7��61+�]�=��_����k�� ����!���HTL���/��4�:��)DΓ��N�M,��zo�ۍ�}��)$c@<N�՜���!e�ڈߧ��k�6g�E�� H��'�D�����r�$�{V7Z�Q��j�C p�z	���4�(*p3�h�1[�W1��
��\��7�����|��{��&��D$25`6#[�OO�#GQ��Tْ� ���߽�h5��c�� Ǌ#��Hފ�(�����b9�D�e?7�����M�7��ם�	zX˿z�unM������&�N@
�
(�p].h�R!�_�(Ǆxf.5܄2�C�2���h�bo�!�G��|���2��/����,ƾ�C��l&:�T��W����US�.2n*�������۴�2�u�e���X�ِ&k73����yt�P�ڈO�ǖ6�ն)��o���+��4u�5P�le�Ii�-h�N��A�)�?���]�Z�r,\�0��*�X���!�ݯ��$��P��.��*�C*�ܞ��"���-��(((~�:8��n�Y���q���0ۗ�f�� �; ��/6;�-L��,CU݂���'��Z
���C$=�h0V�����*/Ef��zxd(���G[�+�L��(��LD"�^w.Խ^���sz<�)�Q9���9*3["m�C)ʖ���"�����Ĺ���r�>r��:V|��Ɣ�o��uR)���͝8�	��y�3Ї��0tU�
2
��6���NZ(�N�[���E��_-=��z7�>�z�qs	��X�ܞ�P˞��@(3eS�Su��NX?�uw'��b\+:.7 Ɏ����L�TDt� ̎5�ذ�Y��k7k��^eѣqQ�T`�Q�㴌Qr;,������}&�Gs��X���r�ꌔ�S=6�����J�8�'L@�17F�@t�3�D]SWp��5q�nM���([H�r�JJ���X��~�3qռng���L�@Pm��H�+��b�� �ȉ�dp��@SG�;��E~�&�m�\6 �Tl��Ti�����~:i��ꎭ�mvu���:�P`"bT��o�\k11���e|�a���	��k-�d&`?���M��}��H�5��az��z�U���/��>g����3L2__�!};9����h|q���g�Of�q��j��*"
�6
E�T��7��Q��f�|YO������4�pS�@�ăd��>�o�l�Ќᴘ�aC|��w^�v�����	渮%ko]\Li\�/���K0����O>
P��#��84u^pa��Ǥ"��6���-E�˾����no�~7*���߇[������P�D;��@d��v��9��K������}��ᝀk�),7��ˍ�~��
�@*!3ki'L/D⳾v�ЙL˧:.�H�F�ڡSr� /�\e�@���a�6ֺȫ汈hԱ4��1���    ẹգҺ�jd�2R��)��$H����� ��\����;�+Gr��*�$`�V��"�T ?��B-k�ݖ�����Ϧ-b�*�����>yZ�{lq��߰I��N6kt���� ��'�I"ڷNW������7�=jN�` ގof��I+���Ι���\u&�b��+�	���D�B4mK+(��~ٽ`Y��������D��%=�����P��<?�OS�/��k ���I �d��@mCnv�y�<�g��'_��`e���i#�����e2��AN�9�L{�>VϺv��}��Cz��,��f���!����J��џ�]}H[�U
��.v<�f��=�޽�Q��
�y�G~�]�>�N�IQ���b|���+\��N?m��0�.@q�/2��I(P2y%s�(a�?7,?.����[�<ڑ����Rw�{@Qec{�)B�NדNOJJ��b�SN	�'�<�횒S�)�;<�?_d�1�谍-��Q�L#e���˵}��}��ccXvc;��}7�a	37�.I��%f�˔�X�܅`&tr9-�U�l�Ɨ��B\P�j3kj��U�-"�Q�lw�z!$��!���� �E列�/����y��X���oX1�^t� .�>z���;ܵ:�u+!��������>DR�2�}�q�����p��}�Au�-F��'@����I�p�`X�-מ��_��S���&�r��v��"Ao8�!W�ڛ��ذkp7+��,M�O�v��D�j���G\,Wx���3�	�6���j���Y2��q��Mʗ�ޕ��R��uZOT���+�Ǣ�]�v�_D���<UN�d�h��Yh�������o�������O�яH���)��1n|�[D�sH?��/�?{��>��7�����w�������J!7�)pWI����Y�xQT��$�}@�C3��h_A[K�3Q��ֈ�h��m�YG:4�t[��3���
/s0x����W�����YR��y�����~DY�9�YK+��*���UP��f�*�Y�������`ۓ0
@�'ȕ�tY.
P�v�K�S��S�~��ُ}�ǛZ�	�s? 3;6*w�Þ��(?;�<��
���v|M�eA��%����O	C��D�I����QnѺ���^j�F�*�U��f�}�)Rm?$��GB@GINnԐ�;yw<;�5Z��k��������{����J �*`�X�;��.��Ǎ�f����LT"FRU�2�>Ă�զm��@����|2�褊7(��9IZ���.A�.ʎ��.fz����< �B�5��
�L;&���bl�T��sZ�R{u�M����[W��W�Ro�KF���4$;">��E��Ռ��E+��ߜN��nfKe��3�opY�^��>��y_���Ƶ�k8��6�O��~F�ǆ#\�1�����_�n�۩(U��3���MG�_Pզ�qt �Q�&NAƧhq���G��ܜ�����-�
H����z�;�ȴ	����������^���������:������Z8|������{A���h���=9�t���`;���5�)@�'��,�51gNg�O-�-�\iG��x������7�ْYۥ|V������kQˑ$/m4���J0/e%ft(�,����O-�AN�
��s�}�F�#����T`���#�_�J(��L>����7������v��^WgG��n)Q7�XP�C�]�' ��PTZJ��� HB`@��/%p�L������טc�������D�+@�͜$�S��r�$����<6��g�*'��C���v
��d~����Єf�}~�T\5�����ɸ����'+��2;�%�^ٯ+Y�{�Պ��i����W5�^38ǳ�P�dE���%�Q�� (���h4�-����+^`J�5�he`����Ch]�L��dfn-���ym�F����J"ٖ'�P<�r`�e�0o�*���܆�)�OL����F&�"�D	�xy�L���q���\M;�%Y�2>���a��+�Dw���k��GR�5'�n��j�6� ��ry��WC�x4A��0��ӭ0�L]f���e���Izd�_ȕ�d*��ue�he3�J �ON�8-0F=qa)s;���7�дx��:�;����ͫ����≑�	�E'���1�D� C�R���RJ@��=��!���$#�t�7�
沁=
��)�p�di��	6�S\_���8��(�?�g�{{qN��.�O��Yu|*�r���1n[���0 jM�W g@r2�@���N�N�4��I@�I��=�F�g��1R% +�� ���W��kL =䢘
g��0�F~m ?X\Pb��_&�Q�țI��h�M6����w�fʗ��`�������X����P���\�ED���Ey�*M�����1����3��X�2.Ց�;��s�& J)�d_ۃ �Tmlqk�?i�?hJ}_�{�c8쇭[���}��Q%3��Lr$J�K��|���(��f7�Z"���Ȃ�O	��*㟄n�6#�	#+�<���&`7�9����hd0�꫔Yg
���TkUI�������^��l���x��g�7����_�'�R���`�+gi��ey�<�ĺ����U�K?C�w���Gk'RU�2��@���:&� ݬS�ڎd�!�s����1���W��F�Ɲ�'��ʏ���=y�9�S#�y��6�f��6
0wK�������E�N�$���с���U���ӂ�]��w����fy�z̅����+�<x�(E��C ���a�PE�f�t����+vI���ac,uF���r	O'����ʿ��-.����4&W�� ��}�?e� v�_�ƌ3��v�$��:��(g�0��Z�$�8>W�b�O�K'��Ͻ���������,�M!���������e!O�\F�Ń~�H>/_��L��T�0>Ō*5����������,i�s<,:�dRR�T:��~pv� �����p|;���:�T����Y�WOY����{.��2���9E�,�u�IP���9�{�y��m���Ǐ<qݫrW{�J1�l�6�|Ǫ͐a�2��Jp�@���U�h�+*7�3�c�a�<|y1��I��*�S�튂��q}T�i$@`H�eף�QXVh���80���ۥ�_�N���IT�b�XJ�ZS��TĮ�UuH9Aë�V���`7�o��m�m�;ѽޛSra`_�R0_2k!�����m��i���?��?xHX��9P�*�]8m5�eP�ʌ�"���*��{�����z��z\�).��f_�24&���10ԎgpAk�̦�#X_z��䊼��v�;��z�V��^iv6�Bs�fk�eP�v[{q�V�6��f�l�06���돸(<��	X ���*��;8|"�Ǌ�v|�q�]�_�-�;��:~ްjrd�)K53%�
�.3@��%�v�.��C=f�������u�5Λ0�a}�t�I�Z��$��V�D�l8��/��/��Y�{�)zDX����Bl!�)� L��> ���訖s�[��^��l~J���}o�E�R����/߽-��9�{�Csm�� �IX> JYv%4)�sY�j�U�1A@A�'�У�+
�t�ɳ/�b�?�POh��ԟb[z�9�4lR�2s��5r��<��w8��ۓ�Ր���8�h �d8R/1�a;��V��w[&� �y���$�$�Ѝ�hC�e�������O9���E�74�h��� I(4|�ȸl6�$�̕�P&;�އ���	H綃Ùӏ?_Yֵ����ͼ�S>h�v, )ָ�"�:C����*;��)��n��j�nAa�τk���ʜzΚ�t?���`�)�z�q/W"���,�@^���kJw��㩑�����>	G�Cv]�6�	$h�n�t�}�6`�S �e���e���B���p�_�+3kɓm���
q���WS��(�8��>��f,0G]J��t�}ʸѤ��������-�`    �pa����D�����+�mo02^,QQ�_
�[�%P<{�)�%?)�� �[��<�� ��Sj!u
>{�ёeN����Nk�!n��y�kJ���*#�*--�8�MM;������Y�c���}�������g����3,��*���B���ܛ`B��G{����.�X�i\�����8>�f���H��T|w �_q^�#�눯�C ����C�Snw��r��$��n'���9b �� ��rM��?T!������w�qʮ�O�-K�\.6�S@���6�1�^���[���W#�����T��F���F�(DnɅ(�Q�N�P�CF"�v��*m۶���l��\?#V�����VV���W�T�yBj�'��!��%_��Qaubд�|���?��E�.|l���_>7����1Z�jN*Y؃�!T�jJ�W
��;�����T-�X���2\�RnJ$a+BF�D�"E,rlNSv+B�&�S��%gj�w�ф����+�L����.��!B�Y�px�m@� K�њ�w���A���x���"�&.��G�O����5�5O� .a4�E�w)������5IT[Z*(�oꪌ�8��>���v�����~w+ܬ�kLfN�0ѩ�;証�볶z̄ё�Z��.�$��kv3�2���l��f�;�����2;XcU���}��C�\riY��pz*�#Ż�ͯu!OWT_�Ǣ����t��t ����f�{��M�RS��A�)��;L���k�K��ډ�K(�ƽ��� �6'���f�k'F9>��~�.�-�ܲ��gas��\^%c���̻�~s< ��ƛ�b_&g��e����Ž��ii��z�FF'@�l�B�r�zX��͐���v��G6��e<����,ި���T�G?V���+��
MnV�$����1A6�n�(��n�a�i��ʰ� �ϕ��t�<Z�w)��һ9�/a�J$�9���P���=Rt�Pu1�����6�:m�N{F���a��a�Y*�2�!V�$��F�L��ɾDW����[R�����n�CH��ڍ�^�brf��{d#�,M.������p��,�O��j�2*��.�x�����=Q��%�Ż��>̠�Uf���/����l��|3��ڕ#�h�V-Ͱ4)Ke,EҦnޜ*����Ҡ�{y��eC�:01d$���m9�ch�9��j�;��&�.%�u�����e��3�o;k� P�t.d$�����J��Y�7��!�h_�r2?K��wkE��S J
^A$�B�m-���TL&����໒ �Qg�;о+��n��������G��e`ݳ^j`')�"\O�1�d��@�0�=���2�ݤ�.v=����g`ݭ����@���0��r��%�Jn�,������ɽ*���#�����tҒ�!Fp,T!�$�uRz
x�A��K�&=�B0Ή�2Uvp�K>A�I��h_w�r�md� ���fY���� R�t�����{����p��ͬ2�l?B��<���躮Y�ha=���.,O2l{a#��,��8 �dvL�>�|O����'�/�&�yN�����(�ɱ�l�ck��Ufv��ޣ����Л�d!6'@b�c�HY�o��+�����ƥ��}�0|鳳�C�1�]E� 0ڳ�,"��M�F�����rW��*�g_rY5,d	u2P�Y�`���~o�_�L��$wp���B��)�Ydf6]�;>*u�����2j��9�w�r5,U�nz��K��QZ�N8� <>�ZZ�[$��vڋ�0���P:��*+�T(��PK���r)_nm#���z�{�K������*��~���
;�Z��\kk�M���?�kq���K��N3�$�b��0�,Td��� �*���,�pW��(}��}�b��,)?����N>O��3��,��ـ�g[�0_	b�C-�q�KT�ۺ�f�@�F�N�`��O�t�����?<\c��͌�o�)iW 鳕Z+*&E���&����
�/�[�q��\�?����|v=;�m�/��G����� &��*�!�X.���5�-z�8xQ_*�\��h)���I-n�g_��r���n�*"���s��>;�.c���4ּ�:z�J��a�
�>����t��g���S�a3�+�hs��ӯ3�S�痥���������0�x|��]\����||y:{�^]3�to�B|��AŪ���.�v��yRl�¿�ϧ�i?̧_&g���'���狤40� ���jѐu��7����Ac��� �_�΂��s˘�ͮ0��w��GD�?;�sȦ���̋�w�AA�Hg���Ӄ�M�0������*],�u,��0"�����:x:8;G��Qs��O&�#��g"�fN�q$�>3���J�%:Ƀ�al�F-��M���Y�� ��B�@�	X�ſ�fw��E�8����C���di�w]��u)z��>o��C	d}f�@�*�Oc�S[�ƙ���Lh�t
�7d���t2�"h���<i�!��}�P���D��rq�y�:��� �Z,�]y3I'C6x3:�}�"�@/�} n���ħ��ᯈ� �Y���-��v����'�����?Χ�F�ʭ3Z̿ԍ�|��v�"�^oM�v&܀C��/�B�s���(b2�n��������T
��,��{ʘO���{0���O�+i���Z@逴�/� &��s ȼ�q(�(�@�fѮD�r]~
�ޠ���n��6�wߜ/�_���d@�kq9�:�!��7���o�T.�«�|���9���æ�w2�����I�)�W�aԜ���.{~C� �tZ�泫�#7�m���k˵�ꞽT ���x��mQ������K�-+�Pt�����"Q2��_��yLE�q�9N��4�����BP�ɲm�2�R ޮPf`�҆)_g!�E5�2[�>���%CA�1V8��<UB�+h���@lTf��wL��N�� ߝ�n�`��8��"coLQ�:j��t���(��� ��C��۠|5��S�3��M���gyn��,t��@ĭ|{J���F́���g�1��Z��Dtݺ��k'����w S�@mQ�N�4�dΖ��[l�x�\d�[;Nz������5��0FZl�<mW�C�e��v�G
c��(ǁ; *;W��>Q�|E��b��&֭�緹5|č�'�N@�*��2d�7a�#�8�U�r�FЮ��BQlD�Y��. X�j�M������7�'��i��=���2���:�#�a�'6Eŕ�V��M�5Jw��s��b��B��V֭3V�~�v�u,5F�:�7xi9��Tvt�r�<`Q����Uf���'�b!P��~ �*�z�4��{���������ї`
Ly�����ܹ�TxD-��s�,v:,!��������e��EoQ�K��[�=�0�X�8f\�PI�H��V>oq7�L#e��0�*�;y��n�����rj���Y�L=�J����-VdR?����m��Dէ�l*�l*Y6��Y��sa
{���qnd��ܽ�yS��^L/O��
����Y����ݟ p,W О��|��=_B.�P��r,
7�S� ��ʜt�w�q��5��㶒8�@�U�Z[f�
G��'3=~��S�l���,`�YX���i\���1����qڨ�c��%
�Fg���J���Q�,b� �f�Ozx�1!�n�7hN�g�����~�#q��WPN�x"�����&�ݽ��쥃Z��(���0�v6��jr�'@�g�}��.��R������a����$UD�+{"���a��9���2Cg �==%_����t���v��`2�:�Y�7��ϕ\"����gfs���5=�cU�m�.o��sc������f�#A�xZ�GgE����x��}��/�p;��j���X�l�އ6\:Qw�.�S���F��@��^��k@�sJ    <Κ�n�ʒX!�������p��~�̖�?N���eZ�x�����^��G�z"�`3B��[��N�2eP�-��V��fQ�G���'B,J�>E��뤧0��լ߫#���r�¶�P+L�g��k@�N�j]�7轕�$��z�;�%� ��2#d��0	]Bi��E&�4
M�Z������b<��t<��~猎糛�Hj!e�Ks#o~��Ti�B
^�@!h��Ԙ��.��&�,��%eN�����Kh�t$�2����<p��O� �ȧ(w]r�0V68��l�)<�}�~^�x3@泰`D�.\G�a��]�k&����=�7����\i)K��3��r����,��c3�N.�]�w�UF;G�8)��u,��0�-t�h0�XZJE�JR7�c�[�9��m�R�)�!N�ؙ���~����P���Q^�}V�F��g�)��˅��%�d�r,F�������>���Q�C{3Jpf_��ܤ�&���pQ�Jxra۠lM���!P����U���hr!ňT���r1 �9ꖗ�_�������)C5�9� �ь"��W�0�`̄b�s�}��A�Qp�:D���)X���׷�:c�'��ZFST��0IV|׬��!���!NN<�F�O�/7z�I�J�![�a0�֧.�ܬ>���3&��(@2��w>���On����ab��}J 3E%��j�cL���O�H	�2t���yz��L:ZZ�=X2�̓Ac���I�n�.k�#;�~[4�X�Tv�[��ۄf���wK|�C/�.>��fs*u��?A"h(�j��e�j0�_Nz�)�;<ֻ��R��� T|�ɥ�
��m�38��`p}WgQ�tEۙ��˥.�l���	|9)�U�OR�av��5�����yr��7*�i�':���7C�>�c��Hk��O>Ν��Xip��3����s��q���3+b�[�����}�+�C��0Y8�%<_sKG�p���L�>:�!���ɀ��C�������]��t,���I��	mc�R�K9D?#a�{p4����� �8�G7Z�M�f�r��\��S���u<�����'��͌���B�Bq7�F� �ȇ݆�j�$ o�;^0����dQ脡���&gw5���J
��a-)�[�����ͻ�"���y����3Pi�S�F�#<y��e2ϝ�{���=.�������ӎ4�����-3Wpڱ/����F�Ltyh�_O��ޛ�7S�*Q�5�bJw���[���K��	Vf�aӭ�S:�"����,U��\q �� ��>�;�����A���/��Í�����~y��<�96����������T�~PE��������"��s8��E��,�à�㑓��v�8�YF�"x~�ĥ ݄��m�=����;��ͮW��y�&�(�B�q)]?r }7�����:��ˢ��ngA-��dg��ßWD:`�p@;\��z8|��.�f]��/n&_�11�	f����&��:�2�9�@ǐ���	'��X��O~��u6u�|w�o�{����H���ޡi�k�ۮh{,��q�E+7nsd�jj��#X�,(]��3�̊�2�Es=��deMHB=����ǅ�r������~���1�c������FLaB�&�l��R��!`��:��2�����_�F�/�ʫ��^=Wg���3����nng�yH��,�%)J6~���#>+���}L ��o{�>+�_���y:��  ��T�4��*��y�z:��'H��&r��<�e��F����GRxH+�>C�6���\���j�z�iz�;*uDZ���@ߏԝ�N}˫qw3DW�s� ie.GE�մ6��� �us�p���wS�8N��_S��.�%�9�GW�ѵ$C!��\�B2�(�k�=�t/;�")EO"a��kwђ�Q{��}�:����//¥�b5�3'X���h�g��}��1��lu�����e	h)���i��n��
���d�K��@��b*��� ��GUc���__����;�ă�oA.�1SA@S"���������f;S)O7�vӜ-�`
mȬ������BbQ�	�U�����S<�t�6i@ r�>%�%'寠ؓyΛ1��.�����V.�$�֞�{�wp�\���6���]��W��v��u������0'z.���G8Uܡ'?�g�ol[��l%И��V��#m>�$���Ϙ�I�(�x�5���-j+Kh���ʿ������+z�h�_u�Z��^�ұ�Z�![��n?�7md�Y����8T'�xc���\v�hx<l�e������_����)0e��� 3�����2[%�@g�`���Q��x��r|��_c\�mjQ=���;����a���g}�<��IW������o6��#O'�t8�>��)AU�A@:�G�&5�nP��z�O����Fyt���L&̄��w9���cw�ϦW01��pr"ܷ/�?n���T�؜)�k�۪�i��Tݱ���޴���r��V��g��&@��N<{A�A������yt2e�$�dd�-�xe�D V�����,���-��3�M�rE��)$��/v�a3:������a¼���&g�Z9�O�|�Q�XZ$�\9G��m{]�<�:�M��J�!�D�F��&_��e����eF��#OL(����l�}�+�#��Ɍu�׫Ǘ�G^�Hv�� >֍���^�`n���-������>����S�+$ɻ&܊Y#+��wh,Oۦmei�1�`�tH">�;֖ ؿ�!�`) ��?�Q���ͪ�<�96A���S4N+Kn���wON�k1rs:��e9�v���GH�q���|8�̷�	a�Kk�h��}ʝ0V�X�6�r7�FBe�e���mh��@��Oq�D���8����N��̉��^c�@����+���|%���E{]�^���&o)�g���]�'���>��)�᫒G�N�ݗ8�՚<�v`)y�����p���&�I��%;��S����א�j�����,���b�X|yUQ�//�d��Ѻ�Ool�4��t���to��+@}���&Z�x�b|+gˤB���ɮ&��(
�4`H���n��6r\�ɥQ��R��w,3<x��w�%����ʨ�^���om`J�����9�.\�� �"/o�T��0�oG�����
(w53��ӟq���6��j\u�d8��'6t�e���鲸��%�B�����0�GlUb���r�r�HGg)�&RFL��\zf���G�:�>�asb*K��i��m�[�Y�*�B����k=���2{a���Ӡm �u�x��G�M��Eh#��[�K�:�:��V��<��QF_*��H"݀Q�����2#�����v|��P�z$�7��ǓY����W[�E��0���tm䌋����5}�������S�G�c�ci"K��ژ�ƍX�ڊ�&@W18�۰��R�q�����zN'��{%\�0���"�<��<�>�w&A���8�P�����J�|����{��Y��Y��5���2U�0�����e�aų�O���1٬���"�TuvJ<�ֆ�a��Lճ�(%#`k� �Ì7�>�܈q�3�(Q=`ֿSl|�M�b���a�1#c<�(������k_�<�k�b�B�Qpȩ��P�X[&,�f �0��&z������1U�����/Ҙ���rr>N�U�]���?]��ԏLN:�5�<��w���Pڀ���t|D(�tV�B9���bV��yR�b�O��>�فX-�A��yC���a��)0�^��o�����n�R�}���|֝�Ia������[ۼ��6j�=��X`�A`a4�qUB�xN��4PυɮL)q��,8��.A�����k� ��5��@� _C��V�u$�Q�� ұ;�7����`�N(zMq��(%=��]�&��SH\=�r�    ���`���~��h�; �xa�ws�d��[)�����*&��e��f�)]�@�[�&%
�<�4!�(�W�D�[��1������xɃ��_a����QA�c4�}�="P��˳�%����{���o/Ƨ�zYH���P|�#�0�w�8i����-�S�z�8K��X���)t�K��1T�v��g���s��5p�]�����n�p�&�ϋ-o ��1ť�c'W�+�+8A$��P�Ϝ?���/��==��^����1���L�e�(��G&)K����a3ʻۺ�+z�����1�2�ڴIWQZ\}�:�@����_2�v0�����C p�M���}\�֭q�T��K_�>�Sw��x-A冲����`�kI�Pϐ6f�s��Ռ��x5��f]�.��1��+�,�����,�#����5�)Wr�w��aڗ�Q]��7�}j����}ʪZ�!,Ο�=S���L�,:!2[Yѯ�'Wg �x>��1U��G,n�o 蒶տ��XhS�g�ּGx�yx3�f���p��Ӹ�4 �jU�Z���&�l��9}Ғ'L��~��-�j1�<���p�`�a���7�a	�6�/��ȮaMH웬u�y��T��2��*\�F���oy�k�01=�?�2�x:�7�d^�#nQN:����;g����O�W��<K���U��W�J���
�޴l�;:Xk��+���,��SU�W� 發�9�O{MJ�t�`ӡ~���L�C#ci	��M2�NaZ�Zɜ�
�]�
�e(��޻�n��`z�츋�O��D����[���׬u�9��u��ژv�~�9:6u��٬�\E��?��WZ:ϛ� ��w(C��𬵩F-0G�Ex�~b.�Օ�n�ֲ��y�%FHҕ�))]�q�`��p77')m�d��J�Yo �ֺ��+U)�mA|{�)��=p�8d�/`�r��[�\��n�ta�*8�~[k��m�k�z�p��-��-��p��B�h���k<�N���r�����b�$'�jKY�FCN'�0yΛ �^NY��UQ�'�G��7t�Ȩ�������j�c����ؚ���XRb̧T\�Z�Ad�zW{�ٵ�MLz>m/F�G�p��k]2�(�E��H`zw�٫�!� �j�� ������u��C���BjÁ�dfe
�����j��\��\���K�=&�t�/pV�c0��|�o%�ȸ��8���k0Qt>�F��M��Up��aN���"��4��+�/gS���r�M��S	f'�g2�e�۵���c|��w�O�D:��ܬ���g�^0B�����S��g�U*T'woA���6C���/[ mׂ��hq)��sx��ϰ`;)2��sm�<����&J�$����\⾋G����άτ�cO@�;^%h��M*����	9�'��n>��]��#YS.�:��j�0j�� ͵��ˣ�_���n�8�����1�/�K��Q�ai+и6��^	
������w`�[��c��#���E�g<�遲v��@A����ݍ?�������6=�D԰���CTl'F�};������\��V��u��Kn�1'ɂfT���O�0���������ExM+���v�y��(`�kjT��{�e��ܙI��zZ5�"5�h4��"fض�������`]�]�,�fІ���~J�l��4�)�Yԟ@ykѨ�O��ym��Q@�4��6o/������r�C���U]b�biafs��0���e�}��r�X18fi�˛0JCiD�+>�����c}�p]9!���P0�1�چ��T��)�L�����L]��j�Q�y�����A�����ռk3�1��� �n"�C� Ppmk����p��q=�ڍ�"�w��ם��/iA>K <�]�M��Ŭ%/��sv����t���W*2 ^�յ@:#�{7���j:f�!�����[:�|�8��I�`miGS(O�������~U��hff��}���E4�^R�b�����T�v/�5�̞��0]�:���j_��kŗ�)���G2����e�+`!���D,`ѵ�eY6h���cL\+��D�c�B;8fW����f���l5Å@<����"p�WE�������Sr�7 e0�nkWo�Ƚz��`D��*B*�l�eO�)Ҡ�?�h<��.Oo��ߴ�?1B�4a3_�Z�� �n���]e�k�����|�1��SE����[�(�]����O����V;�|�y�K��2 x��G�ڄ	�w/С��΢*�'@�ڵ�׀�����=6���KNǸ�����je��p���)��c���
%�T�@B�sSy����B��p�
���}e�B6bk���}��-ԩ�Ј��.���s��&�"J�F��#M�X�o�m�kj�#oc���pr5���r��_	-�������_��^����ҭ�k�J�Pt9�tC��\�t��F"���mI\O�UZ(� ��ދ���S�<��v%����?�q�͖l��w��� P(���9��@n�T��j�ޛJx��
���іn'З�{��#�Ǡ��т�4Pvu|�(?l��-6�����R�R����[�*,K9���P�w_]T���޻��-��7{���Es<��"�F`�ݩ����*U/�Q����vv]U7���=��}
���&|Οwx�'G��G �`ס^�(�K��g�Ň.s���1��|1��E�n���N���X�a��L�����C�������J�
~#�4S��x��� 2�/�6��lL�2��6s@�]��wU`o��*��X���,��b�k��$˲��,�EL
R��^`)aN��E��?��5F�g��CyL�Ws��}D����B��'�b��U��S!��LXi \ע�K[�4��;{#���*lx3��\���t-�s���_�k���G��͖��(V�T.�2��Z���Ce,�
��=_^wgJë�G��b,�>$k= յp8����	/o�(\�Kpq�6z�x�3�n+���j#�E��s��ñ��ȃw^m��c��f�`�dT+ �Z8pѫb��	t���o�U�v)�ʞ<G
�`�T��+��D��uG8ˆTj��F���/�o��{����(1��M.�QCRP�,D�ǜw����g8W�����#�A�8Z?ʝ##$��,����X���:�3�?H�6�Mw�1��
�Umx/�B�d�v����Ti(�Ȝ�I���q6r��Nv�P!{P����\w僃���xLiL�G���2�^������T�T��v�c�nTt��j��[�S��#�u�yi2�|�鷧�NcT/z���.^���F��������nh��ڧ��(���lk6��Cs|�8�d�+��|/��Vu+�ѱ+`ޘ4� ��T�ȳ���]�]I�qA��J��G�_Ne��x�U/F[��9� �xD�|em�=���qTO]�m�/Ӵd@<<LE�IKff�K���M~���||�OP��&���ӎk��'�R!�q![k��E)�����8��^\̺bYa��>O��诫�9��D'㲫�R��"�ٴ(6܎�աVZ�gw�ҟ�砅�L	�7{Q��u�� �o�
�q���3��avH�����qLU=�i/q�����p^���D��k�ǫϓ���[���/�Yg���
ڰ��d�f"'g��b`%N�L�*�_NΦ�[ܹ{p�4ӱX7���eD0���@��;� ��q�	�R���4�GU*��^6�b�K!¹����P�BN�!��A3#�6�ふA$�A�0e^�F	���b���1_�~�1���ؗ�S��Wu�H�/�"��C��s��ɍ�)�U�;;�N���
li����f��P�N��?Ƿ�����GԠ��'��[�ɮs���+Z�L��k2��^�/�X�]6��t�6V��Z�1��c��w��@�KYƉ�)�(�?����iæ��n�ԡ��nw`m������ƅ���@P�    7�^"�����l��w8�]ΞߵC0Ɇ�%���V�ѻ���2�N6��}cߟTj�ϐ=R�BP�����<�f���1l=W?��I����/����P�7�Y�q�9��������[oh	�f+�&L�db�MK.ۈJ7̕�2dC/o.�Ω���ÏЃcj��F*�`;y)뇋����~ćż�K`�� �Ʀ��Z����S��A�j�s\�.�v���x/��L������t�-� �8�`޶�r���+���1[K��z�\BsL�yy��ӕ��b]	��:�	���6��}U>�|�{K�U�(�����7���h���]iZ)�p(o��l�?����v�W�Y��Π��`Ձ�7�cZa��iY6��L�*�Ig^��(�C9���L�����a�~����3�4t��@ �ݨ�R�x���\3�eL�Wr������F�L���CS/��K���C 7��ٗ��3Z	(���Q��nD�NJ>�V�
�׸m$�[	Ǯ���0�P�Y��b}�[ͤc�5��T�B�*�K)�h�C�::�L�����܈�<��Sc\��3X\��at�V�1t$����:�{�e�@�0�yo#Bh	kT.��w��U����5��V1X���޺�&�|�R�`��m�;j��ޫ�TN��g�|��U�NOy��;,eYQ*�X��h!��h��`n:l�Y��֜Ϯ>~l�g������m�NӫƱc�ҍ�/�����~+��G)&:uke`���gEb�o�>a%��6�n�RǄD�l����*@s�!�c?כ@�03 �}��
|��{��~8��O����{>k��r�î7.d���3Q�kr!�����<���7/@��8���E]���W%��ޒ�����Rb�ls���q� ��m���bV�L�̺�ѻ	Kn�@g��q-Ą�"�T4����&�-�u����X3T��M�YV�e�G ���֩���@��	��rBM6���f��-�rL=���U���;�q!�|�%������e@r�9���3t������s��}$�0�FwUE��.)�>������]�u��O
���P���f���~���"�������u����s���&�J�.!�^����Em�T�R,&���I1wJQ���
�V��銴�Na46p9�b�g���o���;��|k!N�e�� �m��qMf�gʰ,X�,@���F�\��!2
����̛��ܑ���H��y]d&�D�����awp|ؖp���B \g@����K&=+�(~Q��逬N�����e?�{�{`j&��dr{
�����6F��s�Y�|!�f(��{+[�w��i.�r���r�$��54)8�+���S>��h/
<��1u{re��
!��]�=nV���۟F��(y�`d�"����6��P&n��cΈ� �Q�}V��hǸr��1�#Q���yt��Vm���3a��Y�j�"r2<�h�6��"2�Y1��OU� ��9f����nr�iqu5�nK(* aTF�_P�QFv\�$pf�"{����ݺM�u���AA?���µ�i__&��~|�^"�Bov4]\�|��Om�1��e�<	tɦ��q!�|Ъ0�u��y2�U\h�o!;w�!,�( ���n�/���O���r���3J8eT[�&�
 ����b�Z4ع��rT���x+s�F�T��<ݻ�F�H~��v��\V�X ��u���d�2��j��������P?�p���V�f��//�r-��]��
<���v_|bbE
�y��ncC#.Ͽ�����R��}$d 8l��XU��#�
�>y�
`�i�*��{�y��
ZI��ʂVJ��"���i%H[�a[7P��E
Oe���9�e�J���,�� <$�9���d�b"M�' j?����$�[� ���H�ȩꚙE��5����i��(i#h"uܑ�Ɂ�&�(9Q��P�'Vc{�\x,�8�����I���Wc�"��bd�M�I�ɞ���nd@��J���9�,g�����IG��M��W�����w(�LPv<�L�WY�ݱxNF��������E��|r>:o���rɗ������>v����\����{��k����[�꣒�L�£�	eƢL�L0x��B�3����QYX��3#�v�I��K񀹛�͠RƊ�d.�w���i���;���w����g˶d.�3��K
��q�;y_��)W7L�L�t%�')�t,mF�l�R�M�8��gD�NW+z��~��d�bS[3�,����S�ʧ�$��Π�B"���3�I1����H��땠!f����C����
�Nήlm^�����e��7_�/q���KN�е�{0<nM��u��	�L�n��g��	>��33����_˰�N�M�~9�|�q�Lߝ�c�[rf w����7ٲ��Ga���l�o����fNk�m7B��)S� �l�<������#}�����i�x���UQ���O�$��R�����CН��]��J��2���%��?X��$qZ��z�8k� ��k�k}ٕ�(�un����)����?7�(�Ps�K(�o��Z`ύo�:`�*�(���<�n>6��� d0�!�Jq5+2t~��s*���z�dA���y�9RFu�$,�3<���I��|�z	*ՒC
��ʾ!�2��&�~�s��"e(�9�.Ι��Q{��9L{���BP��	Ҋ
޻X�c�j���X���������-ۦTfݲa�a,(��s����b�b����X���y9[\����NG�-xDM�R��bK7���P�_�J���O�ݣ�f��h��eH�ؕ�2�9����� MEXT�K�[*�T^���%vS>!��9���:�/��D�D�O�롱��L����&����*�ս�C��݄�.y�VUy��az�n�p�޾�2��C�nBu�@��z����`�av���v{gJBz�"ń��S�΁��e�$�$KQv�Nۖ� ��R4��)��Av>Hh�3$�gz0���c
M�κ(a7e5}S����?�rd	H#1�� X7Q�Ғ3�%>ឞ��,���à�<w�*o�R��[	u����WC)��ҩ� �	�	gdGW���:�²��Wu�'��UA�CуG+����7_��B߈�ϊu�=�:J'Mg�6G���lsٯ� /7Rv�l�&#�1c78���|�4!���%.g�g��ϋ�����s^j���T�Y�������B�v�5h�5즙��)�v�Lc2�n���S�����
�^�gܙv�����~��h�g�O�s4��G�|��ɵ?>9A?o��0:0=���TNz&gb}&��������{�Xe+�Q
Ă���$VL�QG�Z�g�u�8��]�ReY����'��k�����@[�zK���j�7�lq!b�X�-�0qS���BS�R��lV߱a}]���,���[.�����1X�3@����Y� jKZ�����q��pq�Lm�++_R�������.��v3�"���Ŧ("P�+bE��E,
�e,�-ۛ��=e��-�A,c�1O��voCvؿJҗ�W�G�*�Vj0<��ð��QE��^�H9 *��P+�"�*�eM��*�tv�G�:-Ata�s}9��J���i|]8���ڠZf{��������F�v����@�AL�I�1E�t�]r D��"�tw�s-�^j���K̴P�JT\�h~&H��x�Уp���Tˏ�J%�R��K��cg[��[ߐ9r_E%1HpAB�P޻m����{ϼ��s���@�^|:�2掅1o�G��C^Ȫ���o*�&���5�۞�H���UT|��Y�nM�$��0�e�!w��0
����xzZ�-+�ŤC��yޱ倊7Y���F�=�I��H�W�kx����ɰ{P���g���d��&�*�	��|� �7�I�{�(� HsH1��y�Cc�u�g���FH)pc
�@��    [�ig`n#���u��V�L�y�f3E�c������Z�������Ĩ�N�ZQ�v>���f_/��:֋�|�9��w����񉟺=��CH���^��	˛���H�&u��m砷~o0e�ȫ��򽁡͕#US���\�����O�3Ű�}�L�ݗ�d-*��9��M����Z�$ˆ�έ孅�7�x������gƨ���P˓�>�XKԷ��������Ǽ��?P�0 �[Ք�b� ���<��Eu�C�6BnU�JE�%Am�	n	��I�
-�O^��.�B�[Pr���+�O�nߋaZ�ZOr�aI5�(���c.�hnU��Φ���*�W	Ӏ�q�K~�?%�0w����JL/�{w_�iC��"�C�; �m%D�0-Ji+5�.kƮ�M�6������,��[�M"� ��
}/���V��ۗ4m��J�Ir���n+��l��!#����{�0'ug	�ܭ?h�`#O�����ݪ&ϰ<���.��Amc+���#E	x���[aS�!�B5h} ~}g����'�a��_i��֊�F�z��瓆�Ɩ�����k�������������0-� w-�����珞mk��y9�Ts����q1)K�C�i�:8�B�Y�^9��;��e���h}n���2'��ܧ��|+>*2�It8PV����Wu����+>���C���jd��ش[Z��d!t��g!����"��n[�15*��� ��*8˗>Mh"P�J::X���Ȝ�RB��X��tl��C�>��P�yY�}�W���gouZ~J��v<T�����P��P0��,~mC� ]�4����hou�o˔T�����ot�������\�����G�AZ��k4�w5j��v �[�8'%DtP=�ͯ�4< �a�:p+1�fI����i1[�jW��]�US�'I�1y_v8;�q��[#D>%�Ĕ�z�Ǳ{��osJB�����1(�2٦�j��c�L�}�
��4�9�S{@���҃��* �a>����2u>��$dy��x��A��k�`�����r7�-���ӡ�.��:�ҥ��u�i(27���}� �5	��5�yy�dT&� �xtӣ���8��=�L������[�.��6����	�Fkz R��)W�b�g����W� �&I.�mNe�S�򤍔��#x3�K6�r\oM-�Q$��\��P�s`�۾�E�E�68f��
��� ���n&��w`�G`�}����F��t�H���H
�ظi^o�b�a��9`����
�B46���+[AU\��_GW���|q��C&~�؉�v�����k�d6�]���=6�m��wD�P$�&>`�![)o]�5������s�ϥ��ɋ�6�:������YK�T�.�vc1��L�󸎡� �[��X/UD�M����[}�dE��Q�k;��t�8d,�ښa�O�ֺ���Ot�F磂�[���Vi�A>8$[甎y�j]�ـ����)�/'�'�v�3����j`������h���ľ�D1��nw�?��	�-6��a���/�H�SZ�Zy�`]��xCvZ��H�M�5�K��,x�� *���v*��r�S(����пu�9w�١&�c:�$V]>�_��n�ܢ��w�{��;��[� j1�T����"?L�cxިi����5������AA�E,�Q��>���s"؄K\�n>�<;���B���{��aR���0 ��A+��Gv��[@����Jmmw�y��:^\u�)�������᢭_%�-�?7'�KI§Ee���tf�
��e�6"Cǳ���[��Vd�K!��胩�����bfA=�.<b��e�/��S���[W��b�Z��ȩ�N��=�2�%Zъ�^�{�k ķ���L�W
�0�ζ���s=g�G
��b#�[CX+*���2��[�r��[W�	�����7�)WT(��t+����o]�[�N!��Q���Һ�ުU��r
a�"x�a����UE�q��!�i�D\o��a�˰+�@*�Pp>�� ����u�"*��4f8�.�zSD�s�e���@��ry]�,�ϦX6`�-�ETSK;�G@�3�U.k�o}-*�˞y�{ړN��G���l�}����-=g.�,䶯 ���z����pH(���0Xl�"'��Wd�,i��0(�t�V-��<EmrX�(Tn̙�n1�t�.��I����~�K氘���e�~>���I�q���u����zʽB`,����^nT�s� �e����'E�̠,���HA��dW���&�Y ��kx5�lye�h�E�V?7�c	�Rh5X|,� ��/��-�1S*Ǽ��R�H�rd�x��k���>�S�!#p�Yhl1���k��$Kw�����A����fm/c�<OOv��x���L$���<"�ٿ�*?�4��ܛX���y]�p,�-:� �^�
A�-G�����t�L���.`��x�'+�����-���*�hK��m��El��md�b��G7�	��
c���0U
f�#͇��
��*E�ȇ���aa��'��7�-�G����.�}��&��0?8�ec �3�����uO���ó����Z.*�Pf������8�JQBC�\Bb�!]���~)d��d!u|6!}�a��x|��P�~z���zT1�:�aM�Ͳ)�d+�-�խդ�-}徬W5{6 [Y ��RrZ2��32�c{�XB��Tc���;�З}3���ъ�_K)nۂBk�7l���oCu,�TV��b�,�[�Zh�l��NZy�:3�:�����Z.�~ٓ�l2cá�����ۓd�=ӌQ7�LW4n*6n�B�\�`OP
U�r�~�����]/�A�4C:��X�F��*�G!`&݃6�`���\1���pQ6[��R�_k�Ф�jt�5��.�(?i� ~�G� x`_p��C�������r�)��H���՘�%D\�e	YOh�#$����J�D� ��䥄dy�NC��5R.ܮ�NCl�n�q��CX�"�P�(�B����63���lޱ۵j�6�̦bv v +\�xβ3�$`�7_G��>9����L�������"����4�,���v�u2̃�FIHB��C��1cf��w4�(��d�(Zz���m�؃3�{�iM�����z�m��0!E����`>�4�V:����g"����xz^_���u��Uy
E6���.XQ�R�tp
�AV�'�KAye���U��1B��?#,w%k�*��T>L����]whk^Xj eT�������.^�� ��Tjb�,H�:)w��7}�[k����$��{ё$@�V8=G��u�V焦�������)+s� &�A,��Q�q��`�]^������Q�l�����$�;�)fp;�L(B�;��b�5�_�W�nv�����u!����Gɸ+)kʕ�(�;̩��R*��+Q��sW22Lo�d���$y�e�(��7�f5Ɔ~��y7�s��j�$�e���<��L�Ed��S�;�Ⱦ�D)x�T���-ñL&O��ʟ�/(L�9�hO�������e��v	��@U��s�� �	�yc�c��ݓ��`��̟O�g��`�6�@�/��Ra����٭}ُ�czh�a�"�9\ ��������F�6�.�^��3�1�d���}Y{���,�C^���p!�����T����q5����7���j�9��~k���\��\(�Y��8
|b?���]��<k�޵a�xwx�5�h��˔���dLu3%j�z��z�@8�+�=P󫞡���|��*$�e���g�s4����n�17��q2w����K.i��ͮF�{ԍ�X캐<M��m�E�:0����<�TCr2�+sM�-�V��ǆ��_�t���Y&�͂�WC	uF�^B�($>wBǸ����:prw� ��`@�94o�X�F�K!��a�1n�Qd#��x����;6��h} 6у��
SC M���(��B�#����FG�vws��j�7�0c�G�������l�|�n�����F�    .�S=a��!��]9�Ӽ�'�f�j��<3!4��5�2�Y�ʪ���1ʸޏ�'�eMXX���F����~���$��'���%Cy�����!����l��B=:$#�v�����Ua�Fg.����Z�3��g��G>�h�:p�r�����a�S�Py�0��t�|
�xƮk|H�a���C��w���3�->eD�/`:*" >pJҗ�M!NQ)��p�d/���LN�1�=�]�ƒ���ݗ��\�,��:��5c�aN��f��%�u�"��w�i��پ�	M��Mۆ;8L�;�K�'�F#�0g�Ԛ�p���S�oԚ�Bm'�v�U����a<ʃ���Zޗ~����;��a C'��{��ێ� w���=831���S%+%%�;��u��L:6�� ��_�7�ʉ���������%��n���۹d`#.B,�Ä�R_�A�+8K�\��ZLK9����qd�9WR�w�  :a&T�rK>����	����$wR*	̫6�_]�>���q#�|q}��~���A���!�n���08�Y��"��0��ZB���j1��{�y<_\U���f���8��1��	�w�>�N�9'#7�kQ��@O����]Ͼ�V��lE\�@�Ű��E�.G�W���t�O�NN�G�L�}V��e���/���wo��rx �Q������1u�Ɂ@Q�g:�-�ⓞX�pE`��^G��E5R�#��q���)8�����weۑ�Y�#�(��#�	�Kb�(dM�TXK��oIЈ�/�Y�'�	P� }�eV��8ϧ�o�R�� ��B�I�P�zw9�0�\~�"Wy��u�ɡ{��M��сk�2v	�,���������=:$Oʠ��pK���D�!�`sÌ�,�*�U���q�`^��Y�c�`=ܖ���a "��݃��	�6M�(W��Qv>���V�=o�3�A�Z܌��/�V��_<�TH�踲v�t
�Y`֮����꾸�>�Z�2�F��=�<+V���"�J���<<���G��3R|�)����ء`��i�����ɜ���+�T�� ��L������nS�.0x4vp��@�;a>F��"{���پ}�w�&�r=�*] @�?0��Ol6����-9���7��d�8�4���7��ۖ����|�(��/�$��e�=\��	�ڔ��z��L�V������F��R�d�L����?dR?�='m� ���O���4�֩��	F7���U懝W@i@sU�r�$�'s�2�ӽ�Ӳ#�[��kʕ_ZP�!�6����h���q���-��FƆ�#�.����|V�َel8-{���X����z"ÕU+$�����ǈ�aH���< ���U��	�K-l�����rtE���%�I.F+ԷO��N�n�E7a煨�"Ao��PQ9�]_�$��h^�z!�[�g�)=������TN	��'T���������@�2���B593[���,:���7t=F��D�ի����L�;����������C���l�T�JɎ����<�a|~+p�t60�3_��J�{���{4-;�Q�%[0�8^\�RՄ^���P�}�>��7��rfg�=�YY���U�H�hN����r���~
�}�w��������!+q�m+a�V"23��٘<���{����;�b~`�h��ز�	v"�XFl��kPk�g�����6I�Y��5��m�h<V{���������8D2��F�uӾ.�N>p������Y��0��������W�������I�a� H�~��UҀ�U�TIz�f��=��ڽ\\��"�p=�֜`�[l4�)��OV�^=��}i^�MNb�!Y��9"��ꪧ�eq��{�z��*������O �@*�R��Z������u�3:���q�w��V;�0��2���F\e��N���q�;<t�2�&��ܘ(�/c��A�����c��j�o����&$
�(��p>���On:o(�-��+i�������Y��$�Y�;�m����� ��ODn��>�[�F��
`:0�2?ji!/{-])?���9��x*<O�݀�ϫo}]<��?��V�d6C.�=&��΅J����=�,Q_�@7��_�c���j:��Ѵ�i�󁼿6��ʓD�H�R�{~��;��d�x��P��5}�+��3�����AbfNE��c%��)K6��ܝ7�� ��C�.ѯ<�bʇX�@ߵ!���z	�lݳ��@x@���CN�wTv�
|+��D,���|e��S,�h�g��$lb��nŠ�����N>=	��`w׀ݍ�e�9X�º��G�G����Z8�� ���;
zt���	UH`y��v��&[��p#�-��|���I�WG%V�n[��E&է��3���k�!Q#�0�l��Q����at����.Vn����q;��}X�a����f"� ��	��S��ʝ�p9U�5�I(�v��q�����LvH�?�����Y�ƽ�v]b�̚���B�f�e�U�w��Yh�J��	/h��:W���3���0�lŭu��]�SD�2��<u�v磈X��)��;�Җ]BeR��ý���Q�oIn�Q5i�G�r�+T|{�\�`���:Lnp����U٣d��m��M�^ӥ#ge�X^JQRӆ��byǩҦ�y��V�5�LOB�*fh��;�=d����A���m�m�	Oo!C����U�&S4�.�Hp��B���Fuý�ۉ��6�"X!PM!�!����󀤲9���0��}oB%���%�|�K)�����F��.�n;����9g��s'��s\VIVaՍbH����qiʦLF���|H�V��.4[��(��)���ke>~�x����Ņ�{�K��*�f��]��gD�"�H�+����n>mA0��d�{���.��w4�N��� "a֒3V�|�1l7�� �j,@O�D �݅:ګb�
��l�38�=Nau���-�ӫ?}�H�8���Cf��P�QJ�)&Q�	��� ��սA�1֓�������t�~,�F�.u��P7��S� ����VjyC 	,o�(<��5�<"3Paeӂ�7�����C��|U���ٝ�̗��i�q1^�c�d4��+�||G2�L�BE�B�3��U��KΪp�'�֢�ՎG��8�!�4,%܃��=080��2�c&UQ)W���e������/ �R��W>).7�&�Q��,��Yx�~�<��R ��� �;�k
]ǧh,�*+>0�fa��_w�_��O�z��)�ͱn�KCJL{-��HlD�أZ&��z]�K_{�o:!q =F��`�M�]F-" ��d��k� _��-ڜ�b�cSb��Er%[�7��M?�ޕm^��-pv(�1a��N�ՙ���-�V�OF��j��!,{��+����T�;�hh�fo�eA�)���'��0pE��k��H�0��H8Ś��2h�Ȇ��jk,��Bq�bxϭ~��i�۬N?s�@}��`�:�R��L�xS�yԮ�4���YR�]�=�u5�˲��0:�1�鴷�Zp��$JlN�w��)�\�Ep^�Ÿ,v��%iF�z�u Pq֚��>e-tӘ�Y?x^i@��B�- ��RqV�0) ��e���ݽ�u��vo"��=2�<���w�o��9��¤z;O���9釽���D8��j���� �����.�&^A� �ʣ���������"��2m���� }�d�h�Y*☫!���N�i�+ׯf��dEX�1(�P� �%H?�2YdB�h��,yKGr^8/e���	�s]{۟�K���\�Q�{`4���d�d3�6��]��ق絜�
�lo���S�N>���x?kÖ�[�B���R� D�	D�SXEOI{���axZ󖪱oz����<Jk1��<&bp7 ��\~`^3�&%,��`\7�nk�+8㫅��qxe���; Џ:Z��	3�G��2{)��`�/kes����t    i�Nn�7bF����Nye��m����[�p&o�Z�]��X���-�.6ίK���9�gߵXƲ|���`�T�OP 65'�����'K� n�X�rѰA��j �$��)F�*��26�
�}�~�a�x/��9Xp�U�>=r��f1W�e�Ãt��'��ߟ�GWW�s�1 �uA~Q$���#V�=8�A���<ˁp����-AAc��:J@}���G�8�(��U:��=:=~Q�q���ߥ��PM��0���?y%)a�	#���W����_��ף�+��R#���#�K|uT~v� 9K���9��0eiy�Z-߻S�j�3�yÒ�`o��_> Z���#�`�`��&Z��$ew���j��8�D�Emf�.r�}�� "[��ü����b�F�X≯Ä��0m�=��dr�_�0.����Q 	���tQ�-��;�
f�tb�g<R�ݔ��z@�d�}px�5��/����n<9j��'^onc��|��ʫ wߦ ��+�^�Zx�=�!� � ^�z�"&��YT�w�Sv�ǥLҲ� ��W(?��
�=jV�nb�(bƓ��س ��Z5�
��Z�mC|{;�0��7ܠ��n��0�j���KQ;P���nZ?�V�A_���~�������̶xz�`�J_�B�q-9G�V� H����,v�Y�.f�YS�
�m*l[�>��<U��V^���5R2_�x�Ȳ�C��e�����?V�ڄ�]/Ky���.q
<����A���Ȁ�Δ)�O��@�Sl�oՆz��Д=qD4��h|���0pL��e>�&���VhB�Mk��%d( ��& ��+J|��ZF�d	�=@l������)fv���{��N~?a�����"��=F$Y?�m���yÆ����X�X_��Ų	Ή����S��sf!��5 =�M�x���� I�Vj�w[�#��^l��7��@�0�ǘ�~)�ra-(�Ofd�A�4�t�fT�\bwr3^�ǋ�U�F_ǋ����ͪ�����S���Ŋ<�Ci�H�l��<E��`��po�!C�-$�R��+�)[�b�k���" �B�����m���XOf��<~����͏�H*�ā��1q�\ ��&����rl��m�!<��E\���f�k)O���l�!�GW�,D g���wh����.�����wV'�Fן&��Vn>�񓎽�\BWvI�'�o�t��m��Wؾ7�-x�~�Z����F&�k�@�{#�J���`;
�t����F#e�!���)��q�eJ�e[�A����L0ZoE(O��"�k\�+�@s�y ,��e��F�c=�
ǀp�;���V��N�1�e<���\�����������Nw$3�v"r�D;����G�?Ɛ���A��`�@���t�r�C"����@�	��,��~p��8�� �.Hi7�s
:�d|`tm�1|�Z�p$�|���R��*
�k�k�����x��Z�*�:���?�����&]XQQ�� �3�����yM���ϼ��$��h���aB�����ξ�VM��[]�{�u#���)X��*)��@�{�QO����,��L_��3~[���o��<����Pd<�|]7��iv�]�0ՙS�. ��mjLH,��x?�Z�\7��)�D�#��=��! ~�s�j� ��  �vz�IńZ�L���[R���l�|8xp�^��cW$���������]��Ѡ'�xHu/��9/y����[�e�R5���߫�S�u�u
��`���Ͻ3���Z�6$��ugWUv�Q�Ӽk�d�� /�����Vx}!�K����VJz�m ҽs��k���+����^0[Q�&�}��ǆ�j%��-�0��Sh�\�� ޻���k�QsG�y"��'R�y�(@�tN���ʆ{g��([������4�Z4&.B������������ň�(΄�9�},߯�@g2���aZ*���h�7��ƌ�Rħx�X�x¬��b����1e��k�&��ص�3����޻�J5Be�*�T��	�H�� �l�.�XGXɃ�}���G���U,�D��'c9���{}�t!0X��;�w��U���y�,��@�{A�#�J*,�{G�~HF^F��������z����d�������87��ڣ�\&V[4�C`�Q�Ĵ�`����B�5 �]��b�m�[����P^������
�,�=S�q�#/���BpJ�HO�ǈ�}��\̞��O�;u%:�̻����S*%*rS�n
���Z��_F*'��o����+��c�	�v/��A|Yi(����� u�v�]��[��E�!�����U�@a8a�l0R��0�`bQ��aؖ�M��%���Z�<?	���u�=�(�8b�
�"r���~[J�����^�14��}��x�������wĻ��I���bپ�B+X�'O�\�e��^q+�u`bἬњ��q�&�e�>�Hd^)�y�Xs�Ěg�e�����ѧO#�������5A�lr�|I�7H�Kʊ���lY�-B-2%f�^E?dPrפv
x^��= ����)g������`�*v�nO�����#�
����+G���Py�(԰��)�)��i�F��y��Yg�S��t:���V���-j���;�1�n�!6uC���@*�����z<�c?_��qě�R�7��0�`�JG��&�
�e "���D�s��/pw������xު�c�w��SB<����-1I<A�Vwq>��1u�*�e@�9C\�A���Ȇy��M�9�?�M|s���@�<��V���ב�,��<EH@���4�r��H~N���t�ڵ{�ؔD�,8��x��+U4%U)�
�=�yL��l�F"�U8�X�#nU���S��S'��c g�
�S��{Pr؞}�obw���?N�G$[��l�N1%D�H	d���Ԗl�5��Y���w����{��kƽk��u�6+�FF�� ���𻏱��M����IJ���h!����2�m+g��㎄� �D{��;YRd�Y���a�Q�r2�����l�9��F^�-o?�$�B2-��GM�N�S"LV���O����E�h;Z2I�E��Hu�TT�l�~��w�!)��L�G�m)��=���g i��:����톡��F�VW3���
� �{�$�ܼ�-}�wپ����g��6l����m��|��ڿ����1yU,<TE�+`��S�`t�=8>nUD�/��j8Q��}�K�iDd-x��4��P����"س���35t�S�d�H�M��;�{�p^��@���HW!�(�h����xp�oUD�"��9e��������GN��y:%m�?/�ο��M�Y���Q[���LY-�]L�U(E��U3mZ�����+�N0N�Y��t�eFʀ�ȯL�(w���,��Q�	�E+�ߌ�ȰY�=XMʼ��@=}O�
E��	��@����+�v�M]��.���һ�j�v��r��G *���ڝ�P��I����Jg����l2p�αyM���Z���-&#ȧ����Sʡ��1؝���I��:���]!��1��Y�c
��f��%�����L�֋��|]vފtGX�;��E����d:[]��]x}Ż4HhF�x��B���J��t�,�'��9�8����d_%����C멈���mF�6���-T:c�G��
�i��:�������Þ���{w�!#<X|c���M���]C�`��x�f�hƒٹ�`�4#Y��m6,�fF�JeȈ�,E���{�*W�XȶL�c0�c4
���m���5FC�c��{��{t$|�׋)_�%}	��[��#FGד��^����=��d����5���
q�ksX�q*��PN ��S�V�]S��v�_A`�wͳ!��8�0i��1Y����f����;�|2:��n|�y|�-��K΃�=d��Ɂ�W�%�����ğ���`��O;LC*v5�:���d���a�{���렬���r޲sN;�<�k�˸ N  3Eu��x�Y�?������[{Ty������>��w2��AN���6hF�e��;�(x4?��u�I�z9!^���f�e��1%,e���5;L��7F�Q��2HnJ1 �b^?ߌnЪJ�^R��k%c@�,X����V:x�/��0h�)�寖n�>�[;jq]�f;�; &6/��S<���A��a��gD�����w�u���8�?y>�e�O.&��t�瓯��>t�f��X ���^� �0�`��xh_�>��d�yʡݽ�E:�[;L�����ÄI�u_�Ҳ�b��R�"�b�	��R�FJ�$�h�ڦ|	1F��)�w�:�W�ĳ|�!%1�v �@�}#]*��Y��ڕ����`vEฃ �qU�����ϧ��i)�ȟ�
� ps�Ҋ-7IcgB?t����9�g����X��4��'7s29�m�\�Q��5�m rYo�a��hN�~|��p�/��^����ŭ�l�0tzx�q^^!幥Hx`���bsL�Z!H.ˀ�VW�dt�+?A�l�����)�3|p�4�]�p�����߹�勸L��+�6<Gfk*���q)0�T2<��8:�|��n�"bH�G1��x� %�w#�6�?�o��={�g��<�E ��@�7�x��l����'�Ny\Te�ŀ{;�{�r[Vr^5�V��A��$����LFN}0��;0i����דΌ���v��{T�K^l�U�����[>���4�*0�A ��P6&(����d����� �v6�ތW+��9�O���<(f�-���r� �rc��� ���q�t�e�����,�[aʶ^&�b����S���XMV-VLu�棼momܴѺ|J A�6X��O��p�(��<�+�k�̲�s|Y��,;`��`��X�?g�����#g�F�ua06d�2�# ����@{#$��P�ͩ��Ҙ��ה��!S�[����m�Ha+8L� �au�뒫!u��ո��A����l�����1��Zp)���|;���D��ʻ�&�{5�iF�S�Y%���6�ZG� Ҥ������A���S>Fi(Q�{42�7�J�m�[���r2z�p����FXN�#�����9����j������{�k�q<gz�G�LV?:��>l:Q�'n]H��=Я�d �A��>f�|��u����?�[���+ߺ��:!j�XL�sA���l�s�4���G�ᶥ
щ�f��`p� y�"�� n	�p:�S�]sr���0�e�|j�e`��{VQx+\y���F{�
���!��i\�����5(���PC9ͣrX��� ��ӣ������/FWhx�N.7�%.�l��~�,��P4^BZ� Z�di�w +p:�H�� #�}R}�����8/>�� ����bN�k���LH��3|���ѓ�=BL&��Gu�x�����l���f����9�� �w'�Gǋ��oCĴ.��3��x�:��A:�⁅ �$�&M�h�?��T��~�������r�����ܭo��7h�m�"�z#���x����C<�p3ZE<���`�=���L*^��i�z���&����������]      �   �	  x��Z�n�H}V���r�����1^؛x<��$�Xp�R K��{�75�\�`�(P|a��ӧNU5C3V,��&;�p�{���n�u�x�_
����c�é?�
�'���m�p����~ޮ�����X~.�?V�/���[�[��ߪ����Z���������I�v}�Y/�WՌ�K�V9f�]I�VT�]�>X=�v���&�UA�O���=n�U��e,�Fy�)�U�i��BT�W�&��X�)�
�KC��í��Clr�Pn�~a��F��y(,�.�f�f@�x!��u�>�_}R\�?������}����������8��`R>(>���W��V-�D�aF2�\(T�z&)�!�_���Q|r��;~?�K$�eq��]n��r��F-\m�n �����[�sM�� RF�+)d9V��TkAoH'tH�G@JX㻔0=(w(�B�(m�"R��PB�D���6L�D�
��*��c!�9\(�Pp:*�a�.�GV�l�!Q���-=�MP�����`�ߺ��C��+i���M�Ȑ1y�,@f�Z��0���"r~�^�����P}).Vw�����nSm�nR�k�4`�9zg4)�kP���-zQ��V��ѱ�PI^H�7n!�ָ��Bm��0��.g���������W��--��U�*��7�a`�y������r�bǻOA+�w� ��tU!�5NQK@0L ��������w�G�� ]X�t����)��d{@91-tH�9	� h\�tvֱ�<D2%�u�X/<Vi�@є� z=D�,p�d_M����$��XNC�">�(�^���[����2H� P�5>�l��vf`�dM�ٗB)��|�Bk����Sl��TBJ�-�m�Y�@3���C)�q��2P� 3!���w�<�]�LA
��0�D���{)4$"�6��/�$�{�����-����`Vj@�C�W
5:i�=�\p4F?\x��tޘ���5�$�y
�������s�G�R��i��uG/���O$@��	I���ԡ��ҡ��E^��Ze�w��`�1L�;��4����v r�"Gzj5Ƈ�/6�n���1�4z��G �i"�k��6A1�� >�*�Ð��(��|��M]���.���=Y��[�h�k��]�3t������L�����,4G�>ۣ�T�&E�[��,Isjv?Q?�&�e�-e!]��Z���X؍B�a����'�<o�����'@ޚf�ck#A���j���d�k�[���/P#�C�yH���x͒���?�������f@���� 
��� p|wKA't~wvƽ��q����~�&>�B!�;�g�����4�ԟ L��h���xf�dԅ��q�)�Ҟ^e�h��ǳO����鯺]�u�����v�<��pe��?V߁��Y>V�j]@�F����!v�F�0i���?����i�R���@0pH��6��1h���t��\X�s��
[�c���S��?o�֣0hx���v-�%�_lvU<8�����$i�R�!nȂ*����X��>�!X0�|�3�&@��v�[C�:>�� ]w�c�?�_O���f�������M@��H��kt:�3S۟.lz�_-~�ҫ_�'�6U7�~��H6 ��\&�;�󐋇�A q�������ßN}w ��P����w̱8��B�^D��Gr�YHdA���k��xaS���B;�A�ڢW�&|�ئD�ۤ�63��8VBh�;��B�b.��n3_X�8�`�����۰��T��'����[�[��R����j�����G_n�e�Y	�)ijF�Q6
dc�v�/�!�N��Gd���X�ѳx��}��eA����	�C���
��8_>-~��5��v��0���D�:���CG�Q�֊�C>vmh�|��bra׮���ǳ�	�O��?�	+��� ���RS����E��3�"��)�	.�}�@��T6&���ӻ�y����V�j��߭��ڏ����j��En�\���e��9��?�5#*`x��Q3�L�:�@�߱aR6b?7F���R�8��ɸk��&�a��V1G���~W=�:NW����GTJW�#o�us�S��dW�x.?��⁁V`��.�p������L?Ƨboi��"�k�@0����7��W�"�2
��̈$�=�ܭ� ��DP<��\n��4زr���]q�ܬ;e�����n�J�nĉ�r�T�@9ژ�.\�J<�Mi*�#rl���H.�ǿ�.#%_����F.Oj��D=�^�oW����Q��~���jV�^M�A��\Z;�0W@F ��,zytT�I����RGбs������(��`L�0[?,�ㅃjr��X�(�ط�ڸ\}]��=�Ңt�晇��'�}��V��*�*_�z�x�$�      �   p  x����J�@���S�����&�^�C�Z� ꂅR!6��QZ����1���Ng��,�:m�,/V�.���ՠ��F您�`�w��>T�0�E߭�ڗd�_WW�v@a(9}�)r������ng���y���9�R�H9*��J���2��nH�+�
dK��g���)\3[rXGv��Ϝ.� \�89�}�v���m�����<
,�r���G�e��f�=���.���O˘{�ZX yKo�$��HJ����E\8�Tʲ�>/]��I�Z��:�Z�OZF��B�$�N�fL�f[HsSʽH����Nm���0�P5�����>�郼l7�D.��rh̹k�u� S]P��uEY�� �� � �y.      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   p   x�}�=
�@��z�s��y/�Y�6��I?�@�����N��W��e�6����Wќ`A����c�d[!�ǧmI����Y���#�;�������p'�U�q7%}      �   }   x��б1�Z���!��-{�L��ϑO�A�/��A���/��Q���eX6kkȫ��6m��S��bOh�	4�_�mE��6�*��q'���gY�z��L�R�����#(�'�UU߁�a�      �   s   x��=�0@��9�/@d���Ε�Ҏ,VA(R�QJ��C��oz��s���9MI�YW|�O��:���ߐ�k�͋�l���6��6D�C�OH��X�C����8�f�Ƙq��      �   ,  x����n�0�g�)xN�c��I�P��vk�.�������P	C���o��T6{~}���%ʭ�-fd�HpՉ���> ���K�#���Y��H�����}�;��	���c���������|_\�_�����GY'� 5��h V���?b�ya���w���������}NE�H������s?��>X�8��;H�u4�e��A2jnu{馃���0�q���(G����XFE�vp톶�+]�$Q��~�X\4C}}����R`k2�T)���߶�G��2��1��(�      �   Z  x�u�Ks�0���W�p��M������;�t���(����ձ�c�,�ܜ����~��}�_T&�H���b.gT"��҇�t(��\U:s�r����\�P6\���:����O�ㄬ�_��j`0 ��0�1z��m��,�R�U�z"ڨ@���P_�%�&a @(�(���C��ٱ���OF[��=��n/R@��EBI� � �|���Y8��vg?I����ة��z��+�+`r�6w2��ӳ�?\�'���M��:�õ��j)�px�t�?��s?����GP�8ۼ�G���@��m�K�B��b�tg3׽�U��Ҭ�i����a      �   |   x��ѻ�0��:���l����� m��Z�'7�%K��YG�~�O����&��d�lz�ʬewKV��W7w_�	��`� ^%4�%4�%4&4^&4�&4ަu&Nh��o���8~Ny&~�      �   Q   x�3�4�t,.)J�t��/J��K,�/RN�I-�420��5202����4r��t,t��L��L�L�L��b���� �v�      �   �  x���K��0DתS�	ğm���eo���ǔ4��c��eRT����?��|~�����Eo"ݷ.��U�������`��v_�Bd�z�e��_�к��n�1�P�$vTm�j�5c ]g.ݫ4�ZW�Z�V���z�k�Ƃ2�od<�h���X��6Z��>�$���eb�eq�6��ɣ��A��^fc�"c��<uR��gg�Nw��j+N����Zi��AZ1�:�Îm����,Z��1(�y���Z��c����I�d/��"k^$���=f��%�.e�����;Yti��][�=��&����w���ګ�|2pxn��p�f�4���#���=繹"cg��K���M����u�<h_�d*s=x/�{r�;�1�����!&g�d�����d�ؒ1�Ǒ/�b�m�d���{�1�26G�@��VֽL�=�����6f�JDg=~���+m�e����K���W�[��� �>8x@      �   0  x����jA��u�U��������ҍ��Y	���L�w�d,8.Bj��	ڇ��L:iR}H�!�$�ӏ�oN��O_��L��)m&ɗ/>?��N���'�5��������i5_�t�>ɬ���W��"۲������緂��˫�A�i������&������U�)ݧ�/`٪e�\k����B�U7��V�~T�%iK��E%-Kg�,݇eТ������2�h�2o�*�}XZ4���avV����GF�KZ4V������ҳzy��;2h�nK�qK��-���ʪТ��qK��-��qK�,h�Xz�*ˠEc�qK��-���ʪТ�Zx_'c��4Kͯ�X���㐧��0I.P"�t�!T�A�D��~PIJ$R�o�T�D"��nPIJRN��`��@�D��^PI%��Z��g�R������6oK��LV����j0YZ,VIa9��"Т�4��eТ�<,���Ec��"LV���0YZ,V�o>���3h�~'���deh�X%<t��
-���.�ա�b��DVh�X�L�A�����e�2�h��,���"��]9iJ�[B-��ԡ�!�6�F�%I�~�H%��v�HJ$R	��#U(�H-l�ԡ�!IJa0h&I)J�`�1�/%��+'�R#�[J&��ʐb�J"�B��ja6��)JRJR,��� �R,��� �2�X�ƃ���b�❃2�򴨔���qoG"��Aa���������Pa�
o!Pa�"�"Pa�:o$Pa�Rf�^f�jo'Pa���e��W�>      �      x������ � �      �   �   x�e̱�0����)�8B�=mA�aC"q0dr3$n&��oM�������,M?��`Hd\e����9�����K��x���5���ݧ�r���%��<oy���R�>4Qo[%TB�.S83)�B<�ˊ-��:�W�Ai�0�x��c��w�+�>1p8v     