PGDMP                          {            ex_template %   12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    17913    ex_template    DATABASE     s   CREATE DATABASE ex_template WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE ex_template;
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
       public          postgres    false    6    238            �           0    0    price_adjustment_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.price_adjustment_id_seq OWNED BY public.price_adjustment.id;
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
       public          postgres    false    6    264                        0    0    receive_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;
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
       public          postgres    false    6    267                       0    0    return_sell_master_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;
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
       public          postgres    false    270    6                       0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
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
       public          postgres    false    6    297                       0    0    sales_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;
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
       public          postgres    false    6    301                       0    0    sales_trip_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;
          public          postgres    false    300            *           1259    18748    sales_trip_id_seq    SEQUENCE     z   CREATE SEQUENCE public.sales_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.sales_trip_id_seq;
       public          postgres    false    299    6                       0    0    sales_trip_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;
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
       public          postgres    false    307    6                       0    0    sales_visit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;
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
       public         heap    postgres    false    6                       0    0 &   COLUMN setting_document_counter.period    COMMENT     U   COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';
          public          postgres    false    272                       1259    18330    setting_document_counter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.setting_document_counter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.setting_document_counter_id_seq;
       public          postgres    false    6    272                       0    0    setting_document_counter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;
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
       public          postgres    false    275    6            	           0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
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
       public          postgres    false    6    278            
           0    0    suppliers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;
          public          postgres    false    279            &           1259    18725    sv_login_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sv_login_session_id_seq;
       public          postgres    false    6    295                       0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
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
       public          postgres    false    6    282                       0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
          public          postgres    false    283                       1259    18384    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    6    280                       0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
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
       public          postgres    false    6    285                       0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
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
       public          postgres    false    6    287                       0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
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
       public          postgres    false    6    290                       0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
          public          postgres    false    291            p           2604    18423 	   branch id    DEFAULT     f   ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);
 8   ALTER TABLE public.branch ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    202            s           2604    18424    branch_room id    DEFAULT     p   ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);
 =   ALTER TABLE public.branch_room ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    205    204            -           2604    18723    branch_shift id    DEFAULT     r   ALTER TABLE ONLY public.branch_shift ALTER COLUMN id SET DEFAULT nextval('public.branch_shift_id_seq'::regclass);
 >   ALTER TABLE public.branch_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    292    293    293            ?           2604    26922    calendar id    DEFAULT     j   ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);
 :   ALTER TABLE public.calendar ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    304    305    305            u           2604    18425 
   company id    DEFAULT     h   ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);
 9   ALTER TABLE public.company ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    207    206            w           2604    18426    customers id    DEFAULT     l   ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);
 ;   ALTER TABLE public.customers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    208            ;           2604    18777    customers_registration id    DEFAULT     �   ALTER TABLE ONLY public.customers_registration ALTER COLUMN id SET DEFAULT nextval('public.customers_registration_id_seq'::regclass);
 H   ALTER TABLE public.customers_registration ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    302    303    303            B           2604    28176    customers_segment id    DEFAULT     |   ALTER TABLE ONLY public.customers_segment ALTER COLUMN id SET DEFAULT nextval('public.customers_segment_id_seq'::regclass);
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
       public          postgres    false    297    296    297            3           2604    18753    sales_trip id    DEFAULT     n   ALTER TABLE ONLY public.sales_trip ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_id_seq'::regclass);
 <   ALTER TABLE public.sales_trip ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    299    298    299            9           2604    18765    sales_trip_detail id    DEFAULT     |   ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);
 C   ALTER TABLE public.sales_trip_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    300    301    301            @           2604    27183    sales_visit id    DEFAULT     p   ALTER TABLE ONLY public.sales_visit ALTER COLUMN id SET DEFAULT nextval('public.sales_visit_id_seq'::regclass);
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
       public          postgres    false    291    290            r          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    202   �3      t          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    204   �4      �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   �5      �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   6      v          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    206   �K      x          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    208   �L      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    303   �L      �          0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    309   �L      z          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    210   �L      |          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    212   lM      ~          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase) FROM stdin;
    public          postgres    false    214   �M                0    17984    invoice_master 
   TABLE DATA           W  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type) FROM stdin;
    public          postgres    false    215   �M      �          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    217   �M      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    295   ^N      �          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    219   {N      �          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    221   bS      �          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    222   S      �          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    223   (T      �          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    224   ET      �          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    226   bT      �          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    227   T      �          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    228   �U      �          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    230   &e      �          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    231   My      �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    233   R�      �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    235   o�      �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    236         �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    238   ��      �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    240   �      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    242   �      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    244   ��      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    245   R�      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    246   �      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    247   !�      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   >�      �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    249   ��      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    250   ��      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    252   {�      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    253   �      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    255   *�      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    257   Ҧ      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    260   ��      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    261   ��      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    263   Ӭ      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    264   �      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    266   �      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    267   *�      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    269   G�      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    270   ��      �          0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    297   ��      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    299   ��      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    301   ۵      �          0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    307   ��      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    272   �      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    274   ��      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    275   ط      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   X�      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    278   �      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    258   �      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    280   �      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    281   ��      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   ��      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    285   ��      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    287   ��      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    289   �      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark) FROM stdin;
    public          postgres    false    290   5�                 0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    203                       0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    205                       0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 2, true);
          public          postgres    false    292                       0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    304                       0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    207                       0    0    customers_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.customers_id_seq', 34, true);
          public          postgres    false    209                       0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    302                       0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    308                       0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    211                       0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    213                       0    0    invoice_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.invoice_master_id_seq', 125, true);
          public          postgres    false    216                       0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    218                       0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    220                       0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    225                       0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 1107, true);
          public          postgres    false    229                        0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 489, true);
          public          postgres    false    232            !           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    234            "           0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    237            #           0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    239            $           0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 20, true);
          public          postgres    false    241            %           0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 44, true);
          public          postgres    false    243            &           0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 267, true);
          public          postgres    false    251            '           0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 24, true);
          public          postgres    false    254            (           0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    256            )           0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 43, true);
          public          postgres    false    259            *           0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 18, true);
          public          postgres    false    262            +           0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 31, true);
          public          postgres    false    265            ,           0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    268            -           0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 13, true);
          public          postgres    false    271            .           0    0    sales_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sales_id_seq', 1, true);
          public          postgres    false    296            /           0    0    sales_trip_detail_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 21, true);
          public          postgres    false    300            0           0    0    sales_trip_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sales_trip_id_seq', 4, true);
          public          postgres    false    298            1           0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 1, false);
          public          postgres    false    306            2           0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 39, true);
          public          postgres    false    273            3           0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 10, true);
          public          postgres    false    277            4           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 4, true);
          public          postgres    false    279            5           0    0    sv_login_session_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 71, true);
          public          postgres    false    294            6           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    283            7           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 84, true);
          public          postgres    false    284            8           0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 67, true);
          public          postgres    false    286            9           0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    288            :           0    0    voucher_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.voucher_id_seq', 10, true);
          public          postgres    false    291            E           2606    18459    branch branch_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_pk;
       public            postgres    false    202            I           2606    18461    branch_room branch_room_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_pk;
       public            postgres    false    204            G           2606    18463    branch branch_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_un;
       public            postgres    false    202            �           2606    26927    calendar calendar_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.calendar DROP CONSTRAINT calendar_pk;
       public            postgres    false    305            K           2606    18465    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    206            M           2606    18467    customers customers_pk 
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
       public            postgres    false    309            O           2606    18469    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    212            Q           2606    18471 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    212            S           2606    18473     invoice_detail invoice_detail_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_pk;
       public            postgres    false    214    214            U           2606    18475     invoice_master invoice_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_pk;
       public            postgres    false    215            W           2606    18477     invoice_master invoice_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_un;
       public            postgres    false    215            Y           2606    18479    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    219            \           2606    18481 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public            postgres    false    221    221    221            _           2606    18483 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public            postgres    false    222    222    222            a           2606    18485    order_detail order_detail_pk 
   CONSTRAINT     l   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_pk;
       public            postgres    false    223    223            c           2606    18487    order_master order_master_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_pk;
       public            postgres    false    224            e           2606    18489    order_master order_master_un 
   CONSTRAINT     [   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_un;
       public            postgres    false    224            h           2606    18491    period_stock period_stock_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);
 F   ALTER TABLE ONLY public.period_stock DROP CONSTRAINT period_stock_pk;
       public            postgres    false    230    230    230            j           2606    18493    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    231            l           2606    18495 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public            postgres    false    233            n           2606    18497 :   personal_access_tokens personal_access_tokens_token_unique 
   CONSTRAINT     v   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);
 d   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_token_unique;
       public            postgres    false    233            q           2606    18499 $   point_conversion point_conversion_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);
 N   ALTER TABLE ONLY public.point_conversion DROP CONSTRAINT point_conversion_pk;
       public            postgres    false    235            s           2606    18501    posts posts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    236            u           2606    18503 $   price_adjustment price_adjustment_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_pk;
       public            postgres    false    238    238    238            w           2606    18505 $   price_adjustment price_adjustment_un 
   CONSTRAINT     ]   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_un;
       public            postgres    false    238            y           2606    18507 6   product_commision_by_year product_commision_by_year_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_pk;
       public            postgres    false    244    244    244    244            {           2606    18509 (   product_commisions product_commisions_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);
 R   ALTER TABLE ONLY public.product_commisions DROP CONSTRAINT product_commisions_pk;
       public            postgres    false    245    245            }           2606    18511 ,   product_distribution product_distribution_pk 
   CONSTRAINT     }   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_pk;
       public            postgres    false    246    246                       2606    18513 *   product_ingredients product_ingredients_pk 
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
       public            postgres    false    290    290            Z           1259    18584 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public            postgres    false    221    221            ]           1259    18585 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public            postgres    false    222    222            f           1259    18586    password_resets_email_index    INDEX     X   CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);
 /   DROP INDEX public.password_resets_email_index;
       public            postgres    false    226            o           1259    18587 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    233    233            �           2606    18588    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    204    202    3397            �           2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    214    3415    215            �           2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    3513    215    280            �           2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    208    3405    215            �           2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    3434    221    231            �           2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    270    3499    222            �           2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    3429    223    224            �           2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    3513    224    280            �           2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    208    3405    224            �           2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    3513    236    280            �           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    3461    250    244            �           2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    3397    244    202            �           2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    3513    280    244            �           2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    246    3397    202            �           2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    250    3461    246            �           2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    257    250    3461            �           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    260    261    3481            �           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    280    3513    261            �           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    263    264    3487            �           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    3513    264    280            �           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    266    267    3493            �           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    267    3513    280            �           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    267    3405    208            �           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    3434    231    269            �           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    270    3499    269            �           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    3513    280    289            r   �   x�m��
�0D�7_q?@%�jv�(>�Q���d�b���i�v���p�#����ő�j���{�ϗ��)|�� ��1/b.P�*+ϓ,���a7 ��@���]����\ݰ�Aj�i�LI�#�NO�b�-�8�v��d*�8�8
��?�A$�yp�Pp��T^������6      t   _  x�m�Qj�0����"�$�I����Z:];���1�-C�y��gɖ�;��t>���8���C�(ZJH%���TB�(+Ml��7�k{;l�S's���@ˣiJ�L��@�iΗ"�c�p3_��-UJr��f�%,��L��s4��(-ڐh��>.��d�1�'��w�P�Xxg�>.<��.�����Xeg�Y{N�8{�hϩ)���x����Bv�:��91�2iϼA������p�q:�����654�wo�lN��؛�j��g�W��x�A��L�����z�����A��Rǚ��r��AV�����C��x��P7�HJs�%������Z�#�      �      x������ � �      �      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      v   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      x      x������ � �      �      x������ � �      �      x������ � �      z   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      |      x������ � �      ~      x������ � �            x������ � �      �   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x������ � �      �   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      �      x������ � �      �   �   x�m�11��c�9v����t.����L;Z9�}{�g���>>W��:~�[�6��b|G�xg<,'�ñ8��˝_d�d���_�;��x�lO�1q�����˗s�5��A|=��Rl)�[�-Ŗb�Ŗ˱�5㴾��Q�:4      �      x������ � �      �      x������ � �      �      x������ � �      �   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      �   `  x���]��8���N��Q�D��'���c�v�N�111�5`�!R����ڷ�o�W�jǳm۟m���?�����{�oǯ��������?��վ�{�ؠt�~��,���_m��g3��}ڋ=uv7Yx�/����'�/tȟ�s�,^n���u��B7c�|�"�xh��?���&�>[3Y�f�Z�Q)���M����uO��.�U]<�m�,<g��������lxn�թf�1W���&��1W�K;z�v�,<3W��^&��գ�ٟv�0�3Y���h�x�L6t�L�.�2 �h�8ho��]���kԷ�4Y�f������܋��ui�g!�7��pɧ���,t�[=]��d��d=�Y�/���>0�@���tf+>�&��cs�p}d�")b>��d��ي�����B7�	oy��V$T����p�\]*�xh>����C���Dŵ_<m�݅�����IV>]ʙ�8e���P�dX��.��C�3_q0�p&,�f΄���6�ݾ�0=�W&,LY9���X���f�ph��+����v��W���`�u�,��.�G�+��.�|�W����%/�Ff뒳52[qT��đي�R���h�a%�w&+�g��Ɋ�J��d�Ѭ����i�0ٸ8ݼ���p��VK[.��5Q��򔥳��tg(x�7���HC6C%��`3TZ5����]�����,+-�f�V�`ݪ,�R��ܿ۶�]i얥f[����J�'�p���y��.�f� �h�f�%y�f���qf��Uj�Yȋ�Z�Lx*��K�I���#��zk�v�5i^��i��!ĮhҬ"��g�,#��0�y���p3a$����La6R�2Y�\R�2Y�\�Rs�,$�6c�v#1i�����ҸZ��W�I7��s��j!2����9�	�O�����9�&�1S{���f��6gҏK�9;{q�iv��t�\Hj��i���TΜ�Kة|��y�,)�JV�"<�oƥ��������_,`���QM�ݴ=��	�c�?ԅe��	Oۗ	O������L�7����xŬ�5���߇��4|u�5i^*o������|�N���y�4n����t�ZL?L�qi8���K�[�������k��	w��Y狓�I�.=�sZ$^��p�͜is�	?&���ũτݑl���h�݄�m�L�8M�ӥ���o�W��wk���W;~��?�8�T��M�=�Kb[�����i��|%{~�Ү,���Ca�I�����E�{�$��q��X�)U���������l�Ϲ���G<W�c�=���p1㪕�c��b�U�-��d����b>�`��d���^���
�_h1 [��d�r3W�pm�{�,t3V�P+tx(g����J�1�н2T�<p�{5��n���%�t��B7SU�!W�i��*f�+v�,<3W�G�+���<�\�c3�x����<YZ����3s��lZ����3sU�\WC9�U�kW·�B7�Uu��hU�ޅ뻹0�3\Őx%�M����<_^����sf��.�t�b���]��|
x6�݇��<�^��&]&����Å�:�U��W�e�0�٪��+�va��l�Z��6�m�f����Jw7Y�f����J7��y�BO�c���3+tx(3T�6X������D��B�5�rf�z�a��]ʙ��������P�dUOG�`��+��C�|�
�|U,�=V=!��3aՈ3az<�LX51Y���b�b3`��b�f����
�|Us���*���F�sw�`;������pU��
�pU��
�p_�X���⹕��*��b3[��=VlF�xhe�f���NVl&��/�#�U<��bY?hk��n�qq:x/�孖�\�k����)Kg+�����x�3Tb#�,��Vl�J���2SZ����Vтe��լ`ݪ�[��eU�՝�ӭJ��V���U�Z� ��*�v�\��!`���� Xv��%�Z�f���p`YhiEX�YZ��#��"�l��0�,9������}`^	�Z	,[���Akw��x��l���c�K��ZE��൞(�,�,�*K\Pf� V�����: .�C��je�q��^�; 7���ղpwa�f�ĦʧC�	k�Å���q5܃͏Y\Y��OY\��s7Y�r���J�{��,W��]����W����_�_o�u�t����� <s�/~F��M���&���ŷ'V�O����d�y��<g�>wb%�xh�ڷ忄�a���Gn+�o+-q�Ծ�ʶEU=I�"�.�x�4򭛨��G|��0{��������UA�&پ��޲�*�����U�6�����ݬ��#n�\82���:@�v��O�mO� .�?�7T��,Ls������&�>�#��9=W�p��:o����Pf��a��da���}`/��gfK��M��-q���p(sn�N'�l�6��6�&�\�����ű(�a�x�\�h#U����64?`�^l7Y�����W��k���14�/����|�/a��o���C�0gA����uB{C�i��������/�o���O����?�X(�U�r��5�r��o����ڷ�s�i��=�5�d�[n���;y��z�Œ/��t��|�,t�[o�X��o��lx~}��Z�����;6�l7Y��LU��c�{�,t3V�%:<�3T�&���c��{g��*+ݻ�,t3U��+�n��幪��dO���LU��f���g��S�d��rK͊}6����0W�V�%��,<3W��G%{�,<3W������P�d����·�B7�����ǖ�Z�<Z�[sa(g��]KK�n���p����i���*��Y�2Z�n�����Pf��S�h�Ɇnc��MVK��d��d�������p�٪�v-��da:�����o���V��l%�o&�{f�ލ���M���z/�R7�UnE[����1sUmb[��Ca�����-��C�pg��]�*��\ʙ�Ŧ��rwa(g���ʧC9��خ��Y8���0�z���|-v���#�ز��3a�=gK�	��yd�[��p&�ބ�d3`�6z%��Z�W��Fv%�����+Y6Z�fr{��*��+��b?��p-6�*�W��C%�٪7R.��V��C%�٪�d3Z�.�%�ɪ�A.�LV��l�^��zG��e���M{�������}�T�C��Z�r	,��Z ��,�e��;K����M�P��tȲ�[e�*��Li�.XVZMZe�e��լ`ݪ�[��eU�՝��V��u��`�*x�s �s�V;�e���0OV�E,;��^-� ���J8�,��",�,�H��[x�]��j��}��������}`^	�Z	,[���Akw��x��l���c���f�U4=P6R��]�T� e�%.(�u+�v� �n �f� V��l�վps��^-K w�m&LlZ�|�0��0��<\�y���!�ա���M����l�E��.qU
�n�^�lԻěU��B�2ٸ����Y���\i�<?�g���Eϡ�:^d�b_��O鹛,<&ϧ��s��1�Rvx(^���0���A�r�
^]-�Ű����[/��n��Wa���P�Wc�°�FK� .�,���[	��a����F`�Ɇ�^w �.����(�.e�K��&�̖6��x���x�6�Ϭ�����C��'KP>]ʼ�R����W��/�&,o���V�l�E6^/�xqv7Yx�h��`��g>��K=�k1�x���a���ۭ�_�YY~<4����0�.��7{�Y��2��m�$��}d�� �?��}iGd�������?�_�-�T5��0~<�ե˿�<�py���݄�_mz���%|�𴝿�'�l�/��3b�i�#�|>�	Oۏ	���e��sO�m�cw���N���T{>�X���N����W;�`�'�������,eC      �      x���Y��:E��V�(	���+x�_GK�v�q�~���p�@��V���վ�����������U����������:�cۭL�����~ȎɁ��&WJ.���>������B���?�施���S�꺮�F�������l�e����es[�� }��o� ��ӊH<�j���mDb�Vl[ö5l[�����2l��-԰����m��� ������'�oޑYq��{1��a+�l���� ���bx��G[�h�/;�/;�/;^d��^x�u�	{BǞ��;�c؇���}h`��}h`؇���}h�>4c�����P��}H����>$�~t�➀�O�}I�t>��ܨ07,�s��ܰ07,�s��ܰ07,��'DHl[*�KzÒް�7,�Jz��ި�7*�Kz��ް�7*�KzÒް�7,�KzÒް�7,�KzÒް�7,�KzÒް�7,�KzÒް�7,�KzÒް�7,�KzÒް�7,�KzÒް�7,�KzÒް�7,�KzÒް�7,�KzÒް�oT�7*���K��%}Ò�aI߰�oX�7,���K��%}Ò�aI߰�oX�7,���J�F%}���QI߰�oT�7,���K��%}Ò�aI߰�oX�7,���K��%}Ò�aI߰�oX�7,���K��%}Ò�aI߰�oX�7,���K��%}Ò�aI߰�oX�7,���K��%��ɏH�CT�˜���>D%��ɏ���G%}}����}�ʽe7�V�L�=���{0��2��2��(��ߓU�ضU��Bm���hs���hs���]R5�Nq��'��j��.o1g7���hs����� �6�͝y��f���T�h3��Y�x��hs�ċ,�����6wH�	m��������}(���PF�;$b�hs��>����}(���PF�;$���6wH�Cm�؇2��9HqO�ޗ����T�{�'�A�6��p����[���\�C�!��ضT����ۖ
�\�c!�%�P��N��;��;	�&�ɹ�tǴ��ϓJ�\��3O��Pɚ�wH�T>��/_���T�n��۴�c��l��iѶ˗}����2��e��â�Wy�c܆�-��i��o+{m{�S/u]�c��MzۋM�ͽ�d��g��]���u�s;^�����޹Lw��k�J�\��C��G�w.��!�ɌJ�\��Cb��;���؇���e�;$�!*�s��N�����Ne���}R���P�as��	�X.��!�i�h�e�;$�-��Lw�Ķ��=���ضT��2��.)��
_E�L��$ޡ��Oe�;�6,�2�q_�~�GKC�Lw���<Z��e�;$�/ih"���ضT��2�ۖJ�\�C�W^eT��2��g���e�;$�!*us��}�J�\�Cb�R7��􉽏Jݚ� w��G�oc���m�e[�\ �� h=GR˯ho{Y�2�m�&�(�� �6�� _r�����_Y�^�K��RKn�/AGs�}$��ud[|:��v\����]'�8�1^C�����4x�j;����˼���S�ڹ
��c�[�,�����g]��|�O{�lu<�C���,8|��2�q4�>���Ŗ�A��C�cU1��呂�R1"M�Q@�7i@�y�x�&U�& ��xM@r��.)��*�S�P�$�1#0+�R���5���5��}������ģU�`�x�SQ��Ļ���$߃�ZQI(����$~s��R�McRѥ��>��K�_d؇Tt) ���R@bRѥ��>��K�}HE����.$�!]
�C�����"e��}dC0ThX]��p�����RI	���DHl!*�u%B@b�R��+�.)��J���D���<M*Yu%B`ZN�U��I壮D�w*<u%B@b��"�M%B��]q���+����UR����}��Q��3���:�? y���չNj��i]�\-;��Q��	�%����  ���%����  �Q��	�=�{�>��e1��}d1A0ThX]L�p��b��Ħ��Y$�-�ݺ�  �m�����mKu�.&,��� *|�bM��
vYL�#ذT��b��@�׹����.&H>Z����.	H�T��.	Hl[��uI@@b�R�K�*XuI@@�S	��$  �Q��K���$  �Q��K�>��Q�Z���`��]�'�I�ϣ0��.�?`������������w~�D�s��}�Ω�ϳ���4��\�Ӻ��T'aU��h��}����՚h���EmK�.�1ʽ-�}�N,LɩH���A:T�Рx#h�>;��Y�����������֩Z�=�I�y�m(�-^o�#N�h�'[T�RWS��O;������h�4J�kP� �m���Q�Y�q��.���J>k�.+�e�A��)a�A:T%5H]@�Bҗ��g����X��C	,�ǡ�ޑ�BV�J�Ȍ#�a%�L��Z5�<U��jϑ=E�ϪA�u6����Q'�j�: <;�lT�!��8�YUf�j��EL�Ϫ:U�x-�9�C�N@�s��<��SR_U���������!x�]�?���[��ߨk3R�Q�f��?�F:kT�t��H�w�=����]׽���\_>�"ܜ�j=�ie�c=�����i��"��jk=�^s���n�h�û��Gh��^��K@m,�S�	���A�2���?�t�zۇ�֧����7�)=g���l{)���6�\����`Q�{ݭ�߻*˒�y��b�$��`��r������L��%|��#�l�z^��kr>؞�����e�G�m�mY{�<�s�5x^	-S9����O��CW�#�i���&��)	����p-��_��_�k���U��i뵕d�O/�~48�4h�	�޲+oI4X�Ζ����A���!7���A���!7������@�F0�&��%�L�s�5HG
cu:�^��8���Lv�����5H�cu:�]��`�Nf��!G���p��.A����L]�K���u޺�vo���Pa4R��k�P镻�u�˘n�0��5��*�0Z���5H�
�u:�]��@����vң
���vRρP�k�z�:�]��s� ���G�rP �S�3��ߏv�K�_��r������Ȯz.���|Odן�������q��,�z�����(���9��9�C}��m��2���S��̭?����7$cm�P�K]�?7.Vίڷy��y�d�ޅ�K{ۼ�T���|�op9,ؒߟ��K{���r'�#\{6h�@iG��ې��w�b��?jT�|������5[�|:o�q׃9c�G���Ӌ�5��f>+3�Z���j�%�s@z����[Q���b���uP=�X�zo�t�o1��t�+b�;��$6�׊-�:O�T�`ZL�>��fL����b�b�;mƎ����b�;7��s\���w�MLΘ�OōŶ�CA!�tb/P� #&���F.b�֍]�$�"7�nL &��\���B�؎7\�V\��~�B�Y�b����2Q��|�p/1	W��Y�I<Ozxe1�=���ʅ�K
��s�_�[��j<Mz��i9��&�'=-�2�x�x'��LQ���o�Z���bҫf����Iz�,����1�=Ƚ&�I�f�jC�5�$�K�N����X�"����h ������3��%��&�$^b�}rLbA�h���gx����>�i����m���Ӳ�
Y�j��Nf����sz�������o2�mjc^�e�g�����b-�Jv��vsx����N���y�|W����k����W�/-�|��/�����c�[�����u��z�O��v����c֭��zdS�ciY��T�<���^���f��/�~2��E����1>v��M�}=o��d֎��_�h�o��bk��\�{�W��<��ϊ���ڃ���b7�$&�F�DB�'~M�X�_���>�
!&�`iN"�$��Q��p��j����Q8Q���hίI��� *��E]BH�M����҄xMc�Ҹ��N��}��-   �5����o\|3-��u�wLm�
1��/�4'�bۖ��D�BL�^g4'jb�hh�I�-�$�!h�1�}��GQ��؇�~�q����~���!�qaY1�$���e��W�G��B��O��!��W����2��,�Bר��7o����
�^q����RUp+-��z��c.�^⺿B�g��Lm���������n�mg�}�=?��?�z���^���u,�@qs&�hpL���V����>����̶Դ���r����[9-۴.e�o�������x�5�=�cM��>W����2�e�%ZT� �o�g9G����|~���עU�1 q���" ��* �iU/������OE���)��ɟ���*�v�(���
)���l�6����8a�����H�T�V�₧"cq�U��ě�5�����"/ �j�<�ۡ���D���3r�9ȴ�[���&�( �Kp��xWPQ��Ļ���$>���X@>�&><���V@b۪U@b۪U��F�!�R��� ���
Hx��B��	w>]/�p��z����C�$�*9d�P�%�P�V��B�u���ӤZE���$_�x�T7�z�`�x'�zC�$�[U/�P��z�ੈ[!MbP�����{��SH�f�
G�$�K�6��B�����^(8�SP���d������a�BWg�8��ՕF�'�Ⱥ�  ���Zo�	���������Ke�. Hn!���  �J���Ie�. H�	T����K
���]hozT���`Mc��@�. �}��->����o\|i��u�wL~���/�T����Ķ��\$9�uF��. H|���Q$�!�uA@b��Q$�!�uA�'�>�kP@�0��F|�� �+
�P�H����DAЧ( �	SitAp���1M]@�QO�DCE�AF�̒�bU��'ۓi�:��,�ρ�����k�M���?��W      �   �  x���ے�6��9O1/g���&��]Wv];�\�#�3��H*Jr�_P��ԦU�I6?����4E�{ڝ�����e7�5����`B|��w��s�A�\W��_���Ts:����j�cOc��8wa&���w��i�&?H��pv�h��_o�D��o䵧>WͰ{�:��/�QL�������Qڀ�?�`�HL� �4&Dh�Vd�`�2ˌn�b�"��ݰF]�1�fv��k���a�L����c��ʷl������͊���F+'
�8;+�?�����V�iV'/�7T��& @�֥���i�=��f��� :n;�~��L�p�M+�H�b��� z�f�ǡۮ�1[n� �)��	�f�j��!t�2B�
�j� �A�f�����o�1�4
iti��.c�_�D��9�.%2"5��vo��
��!@�+(@��� ����F�,0��u"�����l��4�E:N)t/ѓ"wc�4��냊��+��O���^���mwZ7a�5�6��H�&�Qh�P���D �'��0"R 32���Q��8u'3�A�!�tG&�f�?96�7o��{|�F
���f�C�ny	#[+J��[Y��Ъ*`�"Z]���f̹���bZW� �׶3l���Pcr�
�e��Aao&4$��d�b�L,�:9�F�1��qfJ}l��02:_����m��m�0�����N��#�x����o��Nۮ����N��L��M.o~<���x�<D�K��{f?h�A��o��6�OCZ��!�th~����~�s:�	��b_ٯ�����6�&�o��a�n<^��Խ��r�U+��R��a���ʶ�A�����J�4h�S8�UrY��Ώ�/��ם�D���&��q�p苚�%���6���,�<b0Q
�� c�yA6,1�G\�Nk�0.|��\sBc�\��v�MDJ�_(����  ��2  �#Յ�Bi����i7lP��6EaM�r��m��]�4����)	�R���Հҁ�mz23iy?��`�Fw���w;1���,@�V�qt�����<�ƨ56���
س�� ��u&V����(��gPȨ�~ElL�u*�ِ]A"C�$Կ�m�GL�I�?��ROb��h���ۘ���؂�ٸѱi `�J�\��ڽ�m����F�+تP�� �dk*DH��V�����U۶���X����U���훗7�qW��ĥ+�U�>Q����R���>p����.d�b3�W�� ���X�DEl�U�Џ���Xwx��$[x��}`4� =p�n�GYP	$-{����և���s�C��|\��q��k����z\�-`��l��t)�%�DY�W�����*�d��,W�W7���y�2���ϛ}� �=��y����ޟ�}���=��:2w	�N�6�^�������5߿�-/������'�gZ�b��(�̹{���cw��.�=��n�Xy3ŧ�օ���j��a���%��?n8�q���p��Ҋ`g��?l��=p�[��#"9����7_oѽ	�r���F�ܸ,YH�6���hH�&�.it��`a&��X,w2X�4�^Ei���R����iS�^�n��l��(�Gi:ޘ7�����e_!Lvk8o����84 ��c��I�uH��A���~C���3;.��i�����T		�C��!��iR���&$��]J��M8�Q~����B��J�Z"G�J�HxO����+����L�\��L����l�E((��)7A覧ډ���f�����
�ܴ�Դ�1��i(��i(���������Wh���n�:d���Ah���d%mF�#��؇�)
2#2�R�LA���� �1:EA�c�BSt���O���D[��jY���Kd�V,�P�Z�Bҳ�D���%�b*8ęX�|ݝVϴu���F]E
�\�g$X'f�zE�H�N%D�N� @��D
�Agga�.m~	���W�Ð���u�RV/S�4X;��Bn�M�`@�l^w���[����IkOS5���af��G%�lIZ��n�J�2OZ�J ��~ؼu���o��m��;����¥���H�FbL:D���Lf���˗�%� e3]���o׻!Z�.�Bd930�v��N��7�O���%�R̡<ʒ��ґ�e�z��N��KO����u:U���GK�5Ȩ�"�hɤ�?�|n��t����<��Ȝ6y�/�0tdא��G�,��/��{��|v��Y��.�k��# �N_��a*)>�h�ǡ[�x�B�RP�l$y�9��oԮIr�d��cΓa��u���lp��7_�D�+F n���i���W,��y�oF!I�Νn$�s���#���1KoD!a9��MP@^D���|}��, �ิQPrC��]���8𜮔� B'u���
������T4��2�绷�w�u��{�~�����4W���������{�{EyE�ą���2�m�]l��(�e��π��KH2�e���rRN�c�Rݢ����R3���=���k3ƖCv`�51b�QbL,����20��0�(��C��3�2ɍ�+3�����?x͜��u�-�l���>dJK9ӳ�y�悅�}4����s�&/��,���U�~�:?�;�3�eg�C��N�+�����0t���C���h'�2�$^��8v�\��(�U��f�%e�&T�I9�E΂�B���Kj��w�y���ө��B����Z�"HnC'�'�G]@�Q���6�1�V2*q�ĘU4f,_�� df�M¡�+�M0Ȭ2M��)ul]dFi��'OI�l҈��G�u�]gҨ�o�4�Tjl�,Ǹٳ)�ֲ�4�-e?��0O+K�3�.���2��!$�&S�0���+p�@ڂ���c�j �ST�N�(�%%2e���*ೝ�@H뙔���q*�W!b�h�DD<�aNT`?E�/�v�p�N0�~���'�s�-�T ��Wx����L�� �ڞ�X�;�_�#�ا�Q�'��Vf��Z}
��\A"��u&�,[W�B��m�P�O�]�"o�b�NE^&� �ѯb�XN'��*i���L�,�]e��B~�ق������ɹ]�sV� s^���h�I'����W��P1� �dn*DHͼ�� )�W�Ԩ��
P�`5�n�����S�b5p:9%*����S�b@7H'�DŎn�NN��5� ����E:9%�� !�P����S�p�gҔ� �
��� �K��a�5�B��z	��.M�H\�%жtr�uex��m�d	�B�������Pn�P*yM�����DN�w0��'��*�����0��E�k�HʲϠ�~�4����r���J�2��Q�j~�,|l])�� _�lNBܸr�cT���B���y1��k��� ���ΕΥJ?���*π)���L�GIS	Z��de�?��D'z �'GE����_�m��P�L�8c�ї�a>\en�W�2��Đ�3e�ψ��ASf����K4eЄxGSn�����4e����P�Ua)����r*S�|�Й����n�	D�h~�|����Қ秀��O�d�?�OSW�mEV��+���ñ;���>��U�����8i+�@�=[U�o	�⢭Y!�lmHw��-q�C�m��bǖ@�	;����U,?S�\�^Гu�UT8^�*"Ǐ�*W�:��@��ܱP�r�cSuW�i@j��/IR�ϽIލ������"�:�      �      x������ � �      �   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      �   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      �      x������ � �      �   �   x�m�=�0Fg��@Q�$��梪J@�n���.����C�L�ʴ�@�|�r�"q�L��� ���M�?�G���K%���\��ٓ�J�O��c�{b�*+M�$�}�>*M\�)�_b�r�jv��JW�$)��ٿ��������!��.�o-v�Fe��֩����r�Z��!O�I��\���|NƘ/WGf�      �   �  x�}��n� ���S�\1�`��5N*/,e��dw�H9�Ծ}q����nX|�|0�V�����{?�~��Qr]r,�JZTwd�&�&΄����`j�� υ���_^����:3�����A��h�����@U����m������ʪ6+���<6�y�M���d��3�f}�)�%��֖Т�2dX���Cs+�eA�ᡝ_�DY���]J�r��g�0��o��4W�_9?,8���m��ӴYs��(�!)�ʒɲ�I�REJ���"��躗e�+K2˂C�_z7&�V��,(���й�7�ۉ,H�$�.=mҖT�������^2�k;��7:��N��ĐU�+��~�I4�$�i)��~�ϋf�g,fn�>,���b��2d�;��7����      �   �  x����m�0���*�@�)k�x��:��%���P�,r�������(�ߒs��?}g�����O.�rC$ז~�=�%?����̽�E>R!$��Y�5��'��'��qP���\�d��jM�*�I��z�Ui!��Z	Yj�Ƭ�ZG��P�f�Yj�Ş�P�-�T%;J�cWyO�#�*?S�y���|��C�E���cR��H���H��HT�jQ�>Ug��*Ŭ�Z��UR��Jj�bV���P7�|�C�&�����i�H(��l6�a79�f;4ń��y����y�]��e�]��e��+Lh��Zڱ�]K�=�m�X/�FjOn;�tංcC�V*�M<��T|�8r[��\��T|�\��k�Ϳ����}��q�bߛ��U|\�ֵ�C���KN�@�C����o/�����>�{�q��×M=-=ʎ��6�*��o�������7������k�������m6��������W)ó��y]���W)Wtc�����U�1����B���8���
��y����U����z��w['���ڪd8�}�S�ϱ�J��{(����q���|WrGV%�m5��^�U>��n�W�,��yf���~5
|���M×P��+���y/<o����޺=)_�����̻�C�X��?��ޫ̾ �kױ�� �=�u�Oq��G	���x<�XN�d      �   �  x����m�0E��)�@
>e�Ct��?G)E@܆��@?�G��R��C��O����@~`���R��A���*��!�KB��n��g�w!x[�V�0���y��?o�B�熯N��] R�����#��ű8V n��/=�B? �-���! [}���I�� T뛷����� ����oU���O�/�'���^"�X7�	��w!����7�V��W��!@k[<�>h#y2 �3���,���l� e״�C����*M�. _�5@�݄߅�yݿ��8�?S��u5�af����B�/m�X��. 5��_��/#~����~] ����g��04I_�)���ny��,6H�x�,� S�v�ޟ���o
�.��n�I�� ��Ŗ�$w�W��.���蔇	Ph��a�d
c���� ~��j      �      x������ � �      �      x������ � �      �   ;   x�%ɹ  ��L�A�Ex2�ρ�U�¢�c8T��Ύ���_�kUFj��N3�;1
z      �     x���ۑ� E��(:��҃�!��`�c��= 4[տ�\[I\)"�A���{0�|!ay`��5�Y��3����ʓ�P���1U\u���;Ҷ�+�*l(�HuIȖ0d`}��L��Q����H�"��S���Y㚠N���4P�k�:*a�T�*e�
E��JeY�eP(��kKRŸ
��� ]r֐Va�@�I�%H4�U�,��˶�tMЊY��G���Y��p��A���q��b�y�J��Z~r[��7�M�(������a>�AA��+Tj\{�S= ��A��F�&C�(���d�vȼ�AY���F��$���|�XG���Ɗ��SBt��F���Uڨ�+AB���)�����F�t�u��c�QUe���e	�jw��i(C�Vj�rP��s;h#�:�Ui��Q��8'iPH���i�5�~Ej"�$��}�z	}�|����?_��v�/�d;)����^���:T]��zv��Ay�P8ǵ��#�sY�@�/���tl����NL��:Q]�{�����L_:;��f��Kg����L�LN����tV��i�f���q޷�L�ι��`��Kg��z��^�s�Ѭ���\e��s|9O|���[6}n�(�[v����,��/�Ų ��{I��������u�w�>�w/b��45*���)������Ҩ��Jҩ�Ce'A���\��jf�B�k�.�z��֝u��� P�6\��qMѠPN�$��'_�goG���٥���;������L�j{x��P����c������A5�k���4O������ �R��      �      x��\[s۸~��
<���/"�Q�D�Y^⺓5q�:qƗN���  )�8 ۵f�+������"��d�w�Ho�9�4*c��=����qM�}���(��>��mf1��>X!�ݵ�Y ����ck/���࿯OO_^�~��
��|��iBy�T�������w͖��n⊗qVlǀzƠW6~� ���j�&���o�4I�#�e��:.y���x2���v8�;\[��	��
ƅ�}Aϻ�f�<˳Z{�h��ؖG6I~�[W|�1&��pd���z�ڱG�� el�,�4tG��0�����MEv0�=e��3BIi��壔Θ2����}R�G�+٤Ѽ�kв�\��Y�Q�c����%P1G���z�Q*x��6���(�ϭ���m���t6�0��ul�*���yķ9��M�<�P��}�3X[�2�`���'���#�p�6�r�PCT\К�_|�UQ�;"�;��]��z脰�@Sk�l�f��R����z�� ܖA�6̣)�.;�y!x��N3��0mp��:��V���9ݺ��q� ��3E�&mJ�+��X����Hz�z�ZqW��^D\ˇ`���mz�:�$��3l`L+��S6�VD�-��/��A��3�{^�3`���q��9ci��%�Z�|X�$��m�^k<��B��L�D��etټ�e�=Ė�kr��sE|��!L�[~���zZ�lWB]0�0�6�H��Y���4�sO�?$P��l<{#�m�-|Fq�D>wdWk�M���N�� }�ҿ�(��"N���ux��a�x��Ϭ~F��uW�AjX����xHl=8�':2���%OU��u��R�Nb�����l�m�����a�ꉤ��b��g��l���M�id�<�i�	�sB(�qN�_��� �9?'���ZkEP�����������"N��J}��9�������m����<���
f�*���B�b�鲅�)	���>��SHN��L=ϑ9�l�Ƞ`T��T�7���]v����Dt�C�S�^�^����7�?��B������=�ʏ�NiYWt�(��0�"d�������0�sؕ���4ƹju����$#Օ���GP�`�(\��t�M�Lxӫ�aA�.2~�Iy�L��!)����[��(pj�L��f~�0s����ƥ�N�'�g-U+�0�Wk��"9�D�?�P�Yд��䞉������[HL�;�ݵ��ie����ڶ��.�5Gp�e|����)�0�X5�����2��c���M��eh&r�G��%w��2T��䊱|�ouT֚ᚇn�1��G�s��24S0������M��U�R'Ŭ<���0�AP��͡UE�s��T��B�2�"�cV��L��E�w���r�
�gZ�`T��D�v*k^�dB]�k�_H �GNk�50���ú�,���c��8iL�ݾ]KӾ��T1BY���s��ފ8K���9�Ye�髇G�TC��j��6y��Ƃ�j�3������~ms
,�4`��m�����j>�
����z�d�t0��Dy�1�>Ϊ�_{����ѥrf*@:��,��`�����)�\�ۼ���t!j�
F��(��5Tp҆��P�m���@��n	��v�{�ˣ�U1l�ד6��`���+r�Y!�Uls�C&m�#˷�p�U]��H9�Ds0?��yyZ6*�=�������{�9=>��ӗ?h����_���"��Bu����L,����T���=ɮ��g�&�7u5̒�8�|L�2L����-�zɹ=�/6J�ҍS�ʲ����@4x�8w�0�v+o`�Iur� ��Qک-1�Y뙮c��6T?����kR^���ph�+VRQF��m?y R(�x6E�X=�w�6X�@��#O��,��.�(�c�<Q~:���1T0��e)��F,�#�+� *eu;���oƍY&�H&	�Li��y-��f���i@0l��F���Qr_'W�BG��5T��"����<I�-�
eXA9�0Het�vq!��hV� .0���=���4��d�1���!�CC,�}d�"�M�%�gd��@������|�\
�\���g3��#�Ҩ�Q��5b�#��q'����
�Vm���QVw�ZŻ�Nv�L�#���~���Ѡ�����Z����ǎGn�x�Xn
�8���\��X�u�ۉ�o�j�T��4���.�����#m�5T�"� ՘�!����L%.$�)��^�(�5f%chF�`�)���:5f�}u��Q��T�8���#ЀF,�T0j!�F�R�O
�@*�u�޽|�o��� BƇ��Q�=���YQ�մ����9�i���]�&a��o98�����Kh���ї`���a�T�5Ur�ڳ|�~���Q>�\�e�R��"�e2aX����~H��Q^�D<�w�f��4������a��'������cV����� F{_���F�}�	X�-��4�*
f�54튮�	E|OY%���%=�������*��[688�l�?�Y�s`i$*���n�\c����Ծλ�w�D�^I��?�l�xT�;z����"�-¯41�}t�%8+����0��4�C#���,�t�:��'�F#��pp����~=�2ۤ�%�bo�
/������g\�5=�CB��
Y�Aǔ<����yo@����6X�߮g\-�[\X�f� 꽼P�b�x��\.�\�|��d��a�رB����]e�Ox]5���!\��!ojx5^}TȂVŁ��3m'�l�Ԗ�C�f�>=\6�(��?~�B�CG�񆸯{|y�Z;��<��ZC�T��&��B*�W�5~1+{��5
F�o���d��:��&l�z�[�Tm5�{�o&�E�Anq�Gl̍C�9Y�fuV�k�V[�td���X
�`�S̛\@[�dÖ1�i��d*��{%ʸ�i�#�1٨�(er�Zq��񝨒dS��BٸP�Q(�`�����'�{e]���Tp���b�1���~U'�pge�e���,���i�A�]C{����a�<�����1gEZ/�6Yє�֧�.Ք�An��0�eO�7�u��v�����bV~�I��C�7�x��$��b���k jLpg� L�թ*���<��b��Aⷀѝf;���4d�lK�f1l�w���
Fy]R�xV��Vme���X��`����,�����E�(���%Pp��ņW�(�)�%� ��Z(Z�¥4U�!��=�<]�of�2_t� ����eV$5��mz��
�{U� !bj�JD�]'�Us��E���^�2�no1`��v��Q^g"��#ǰ^�Y��ބCռ6��๠c��O�$�(�Mv Y� s���Y�W0ʹ��U4u2�Ua���誾�Qޠ�蜑\-D�fl�A��	'�d��N앟�2����~<�[�l:{;�8$�F Rb1Y����%���[Sm��`�g���%Ǵ�� ��Aˁ���_�9{^�z�m�x���q4���.6���~"��Qv���n�I�w:���Z�c�x�;�X����,���-�a�	�ut?�� ���
�9,�p��Ab]9����7��0�`�)l��"��ű	��:�)=H�J	c��[yԲ֨�ĄdÎ�>6'�. ���(��@�غ��QV�����[R�o��!ѿ�O �4���h��=��w�|�����~�V .��>����L�Ƶ_�(�jL�/9��ʵ��og���F�% �Σ�^���\k/�1/0M`��t�W��Yf|��1m�2H��}�J��$���{��
�:���+�_�@����W���~|y���˛:�̷G�������?����<I=�������mN�"TG�HV �����ts�r�1�: ��M^�O߇U]f�=$���������u��������)`Njqz�awK\C!���Ï���vzPnh���ğM\���������������ql��H �~{8�v3dC�}?9��/#��?Ʒ�7t[�.8��{��o?N]���_�S��^i����c導��#�o����Ey����_O�O_ �  �舮�4�)G��p��������S��Y�8�n���sO�����g����Qm���SH�O�`�m�~z��>�����7pa�������C�'��F���u�?O��m�4�&<�z�Uy}����I|z���D�\�ܦ蟑^m]�<����zw����y�<�cUt����%����W9������ʯ&�m�
|B�A�\`�HG�S��/г��3z���	�y���e?�m2�I��`{O� AP�Y�o/�ŵ�^\{�MҷǷgʟ���^G^��4��u�K�ab��	��kQ~�P8�"�%s�q�4.�Kp@��&��n_nRe�h��:]��i��M4[�\��h^���*�SK��.��/T`Tx��I��:OR�{�<������!���x�e�����,�j��3��OW������      �   �   x����� EѵV�t�	�
�?�:�����R����F�A�[d��\P�FB�B�W�_���H��`��D��S�6��?J�L��]4��Z��nBxO��2l�Y�ܿ@�rl��k�?ڒV+      �      x������ � �      �   �   x���1�@��7�i��ݍ��ĕ��D���/�#1��}/iN}�fg�mzvu;�#�,��8Vr*!˅����	�g�6�W���n��zo�7�����-�1�0Y:%�6��F^��q�܈��4T
e�2���U��o�/>;      �   �  x�}�ݱ�(�QL�e�8��`�c?ɗ:5�k��Skz0ɘ���O�J�}��������s�ϟ	�UP(7
�N���z���0�N�}�uF�s�~pZ���iO[ N���5>��|=�qZ3���S����@hO� N��>5�����2���Z��.�e����k�6d@�K~.ñ��P(�R9��a���aw�yiO�y8�1��M/�eLx*��ܰ�c,ܷ�S��"�U� �ܱ�y��C`�Q��Z{0˨UB5ػ�e@����c�	}��P���4�a�X�xˀ2o>�c�s�
��)k[�12��}����J��ı��Fc��Q��6�ܱ�cԧ��etX��5�X��igOT�z�c#�]�*�ð�y�j�Z�X��c:NYħ�wˀ:W�:�c��^��e@�[���m�ߛ�e@�+���f�0���>|�W��x*�ð�	�;�38���>�4(�Sn���TQ�e���7N�S�c��{��r,�ƧR(C:�q�����=�Xƀ1��cPQ
56�����+�22*6��2���^�X�n�^�XFCð��F�}�XƍF�s�cpZ�C�
0˘0��1�;�|�n_��o�9�^�{z���}���W���8s��BO�XF=��'t�ccg�-��r���2���g>6�q��B%~�m,C]t�Σ��`�xn�X�B��<�<Μ[HM��W�8���]���y�'��e��r~ǳ��2�|�ȍe��f!xGm,�r>c��X�8�jZ��nc�P��8ߜ
�:��8�y��ˀ�g�ñ�c��q��-�ڍe@�+�c�w��c4ȇc:!�.s��j'�<��h�2��n��lo)�;����S5�E9��kbcP�
����8�<��3�ˮC����X���Bp���ȇ��p,cŧ�_���8��:�����9��(��t,��S�x�XF=΢o��ʱ�A����T��R����2n�G���X�yB~C�uc�s8�o,�<_Y�aow�J��zC�wˠ�w�W�����5�T��2,��1�=�X�j��չcƘ��˸a��4��a�C�R(p���Ǌ��8�X�P�5�X�G��P��P�\b!8�9��Q3��ˀ�P(ܽn,�C!���T*�n���c���C�ˀ|�E.�+�2��)�3�>�Jl��yc���7�1b�V(�!o,�2�8��e��7�a8�F��U�X�
�ˀ�A���|ܞ��h6�kP>�ʠ���g�#�X��~D�k'�[?Kශ�T�-�Bv���XF�k_�_vF��2�i4��:~��b�4�}0�_,�E��s_}���}~��������`��?�8��e��&{ܽ~��F=O _,#��������rܰ�����a�*ܑ}���8{����G��!?Xƀ1�y����?)�� T3��      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x�-�[��D��rc��B�ྜ���&1�Q��"�r���S���H�ęx'>�+q'�'���hW�+��vE��]Ѯhw�;��vG��������xN��D�+q���%Vb�'��y���v��������73�\�����\�}O��?C���p�2l�,%K�R��,E^�E^�E>�� �>���W�|�7y�7y�z��t-K�7�$��|�MW��|�O����]�&��e��R����ܚ��.�]���!��E���"_�|�/�E��7�
+%V�\��Z�M�ɕ^��R^��J�6���}~oɏ������E)�8��P�C58��P�C58�\)�8��P�C)�8��PuC-�4<�PR��)�(������v(����e�qX��=��VsX�a5���!���w��8���M�%\�\�{�3�_����3�����4���O8��:/�:���<67�1N8�⯱��3���ז��I[ö]��6䥴�h7֖�UIs����-4[h��l��B[ʶ��'X���^RfcȾ�m!�B��������szβ1d_hu�ݡ��]9v�߭�}M�<[}ͯ�|Ms~��+��Ζ�L�1�d(��L�2�d(S	N%8��T�S	N%8��T�ӲN�2�d(��mq��-q��M����ϯ;o�mm�hF���zfJ>g�Y9��L�6܆�L�w����%�#�m�w����<�<ԏ{x\�!_�|��O��K���I�$[�-ɶd[�-ٖl˲eٲlY�,[�2�������������R�R�R�I=��e�6L�mx˰��,%K�R��,�a�,�d���N�e�2dQ<s�2dQms�2d��,-K�Ҳ�,^�lYZ�N�����9�,S��B���	�jN�뤽N�뤼:֑�3MgzΘ:�4��ܴ�'���øҚ���stw6��8U�4-h�>h�ϴ��>�|��L��3�g�δ��:�t��L˙�3g�M��nS����j�45����ѝK�,骋d%�D�^����������V���0ͧ�S���x�;���NM��S˩��p�7���Mͦ^S����h�3���LM�o�|����w|�N|O�-鉕8;q&މ�������>�>�>�>�>�>�>Q��VT;�����&���+��������;1���]�83�V�bw����&ҿL���t�B�;��y掴�-A��󴝧mw�g;��;�.��y,��1<~����u�9���_��ϱ8�ĕ��'�5�D3�:s�:9��u��9��pm��5���0e��1���]�l-����U�
L)�/ffl$p�-�� �V�
P�)�	����;I�	[@d,p�u� E��:�� +�g�|9=��S�g�R���R~���>�Ri�|����R;K[��Oǣ�ilm���5�ՀLi��3���=�6bl��_�Q��F�-�~��A>����z0䉥U,�bf3��Y��*fV1���U̬bf3��Y��*fV1���U̬bf3+��p�BY cA,��X�/����IA��HA��HA�IA��HA��b���X�A���~�$���8M�Ⱦ��2��.��!���83S&!-���`�Yb!,�����W�
Z!+`�����Dl���'���R�C�����$K������t��}�~v�ή���;;yg'������f�7;���͎ov|����RǕ:��C:���|:�χhl`��4�� �^�p�-�� �V�
P�) � xN�	0�%�� 8F��! � �>�!���=�� �p��5�� `�p-�� �P�	0%�� @�� �l �0�� ���
���<@�*}C�o������7T��J�P�*}C�o����f�O�������u]�&�j�      �   �   x���A
� ���x�\�23	��P&�m\�#x��.
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   a  x����J�@ ���S�Rvfv�t��!m�P	u�B���o�X�[J�N ��2��w�M�cr뛍{JU��t�=/�y�1'����1�I!Af��ܪm�o�Gr�寣g�f��ù��S�yE�k$����mr�b���"G�׹ 45�h�qYYRSW�o����(�fL��Z(&�0
�@s�l^S�W��T1R0}�&����<��M'��]iPzd+j�l8皠��@�_�G>�"�e@Aؒ��N9��p�ܡm�۔뻞a;�Àv�a���.�W	��Wu`F�� h�Ac@4��[GM����i���ٗ@�[�aZ\3���D��8>�����.�y _=yV      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   p   x�}�=
�@��z�s��y/�Y�6��I?�@�����N��W��e�6����Wќ`A����c�d[!�ǧmI����Y���#�;�������p'�U�q7%}      �   }   x��б1�Z���!��-{�L��ϑO�A�/��A���/��Q���eX6kkȫ��6m��S��bOh�	4�_�mE��6�*��q'���gY�z��L�R�����#(�'�UU߁�a�      �      x������ � �      �   �   x�m�Mn�0����\ ��?�x�E("lK]����n��X��hl4�S.S$&���isӮa��+��t�c{Em�}�,l�zJ��=f���&j����ژ`+s5VV���$�|�0�u����M��m��D�z�Yz�i��(F�k����e���o`�)��-�{؄���e�pW������偈q�	�e��!`2�z�qEȁ����9M)��!�� �Z4�����q��cz߆��!�.�!Pc����ͦ�      �   }  x���˒����|Wу�&8�(�(�"X����~G��vU[����wE��Zy�Ґg�(�����������W��A� ���;;U�Γ�]�W�0��y��L0��)������4ӗ��n�G �
`+����΀:��F<�1��  �+����{��o�A@rQ4���E���"��C� �Pa4�W��Tv�
���]��7� �ަW��{=��n�/+�8�C
��e�N!�#�Ft�I�#���EL`���jqKYxÖm:L����~�[�94�f��������Ϳ�� 2	��:b� �jd�}4$��P��<�ׅ(Ȑ������� ���&)O&�F\�͹W��$a��т1�z^]͂M`��l��.;9tU/6'ʊ��7?�h�ΰ��;b?�� �)���b B�{('�%���O%'�FR�jE�Yp���hz�w�:�.p:Q� ���򓈡� �j/"|'B���`�k&��Z�W��- �#9Ҹ��9ݟ;�?���'� Πm���S���FF_jF�V��%:������˴�P����s=�
S�;z�W�-��;r�������s��w|��b������v���d��i;H@�E��|J�G�
��>I�@G�+E��)#K$<����zA����X��\�6�`�%���� w�8lzj�e��	�R�	����9��o���3	L��T��S����07��V�e��+Uče�(\�skrl�3��Rȶ�SA�j��j�y���ACb�噂���ȳ�f+O�G���dJϦ��6��@��>X�A��.�wci֘����A��-mw��d��b�,(�^3%{���?�A�S�n�~βo�w�L�X�t�ŋ�r�5S�a��$h���oesH[��|��7�q'V����Yb�\��K�W����Ѻ�Tk���G����
v�S��"e�q �-����l�'�xp�� �3ir��x�*��	�lPSgx�]+2�ۺ�����<1<,���=O��i�?����̔��,�UH�e��Sz��V����J�+��ڻ�`�:�K��O�<O$Q��[�&�v<Y�3YjC��z���}P3��Ƴv�섴c�J{��.٣X��Z��b"N!��"���RCE{u,��I�C9Rk-�x3w�Pu��5kڠ��փ4�k68L'W9X-��|#B�7��e�� 	u��E<���D�M�e�Y���[ Z��>���j��ƽ}�)�T,�#�M;Y)��:��p,��<��\����k�����>rs��$�Pw�����Vwj�eHݐ�$6eZGE\u��m��r�/x����.m�f31���EKYI���k顽��nk��F|Pw��tf����3�D�:��<���ɋc�ք��j����m�������c�i�md��ѥ�;��P(��݁��#w�iJ��\L!��5=b9V�<�#=�8�ǫ�d�����<R�qZ��������0U�~$���{j���)R`��#�� ���b��k��d��Cz0Q�����1il���:�vUf�=	����l6j�0��A�0poRA{M��TA��X�/�,%_S�e����^�czY\���12�8�/�����Yv���rqr�	�D����p���#}��ګ�[�xr(��7(W��f��6�G,�Y�hҾ�l�QO	N6=v!}����]b6�hswX��Sٮ���Q����������v]D�V5?첰u�L	'��l6�Hb/^a9隭��`�6��Yw�B,�����'A�ۇ���!'����xh/��d�	K���(�����XN�]î�f'l]:~��sW��oU����T�˾��eY���l�^�V�����x��-���?�&�W      �   �   x���A�� ��W���m���߱��(Ї�r*��q;�G=�����b�*Q�����ߕv��>�*c0!����n�:Y�?lI	�Q*c0%vU���c0�햗R�`����]���c�_/�nQ�1x%v��2b[�:�����#�v���$�{'cp���ړ�I�*��d�}�d28�R5�cN�Ԝ֚�d$K�N�A��+ںߓalY�\�Ǘ�e[�Y��?c�2+�k�����������ػ      �      x������ � �      �   (  x�u�ۍ�0��U��$�IE\鿎����$௱G�]��u�B�:�~��g�g�G�-sw�Dɸ��f�����q����8��=����m���3�dZ{�|�d�Y�ŞV�˙�ވcЌA;٬=�:2e�Uzҿ��a����؍3�^{��Tɹ�l�u~'�������Cl��Y��N�:/��;t��yQ�ǫ;�5�:/*�}�QZ������^�E�̯s?���΋�{N�(���k�k�N�(��있oz���0Digz��������Sj�#����4P�[      �      x������ � �      �      x������ � �      �      x������ � �     