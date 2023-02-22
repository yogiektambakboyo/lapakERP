PGDMP     0    ,                {            ex_template %   12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
       public          postgres    false    6    233                        0    0    personal_access_tokens_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;
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
       public          postgres    false    236    6                       0    0    posts_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;
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
       public          postgres    false    238    6                       0    0    price_adjustment_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.price_adjustment_id_seq OWNED BY public.price_adjustment.id;
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
       public          postgres    false    240    6                       0    0    product_brand_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.product_brand_id_seq OWNED BY public.product_brand.id;
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
       public          postgres    false    6    242                       0    0    product_category_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;
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
       public         heap    postgres    false    6                       0    0    COLUMN product_sku.type_id    COMMENT     G   COMMENT ON COLUMN public.product_sku.type_id IS '''Product/Service''';
          public          postgres    false    250            �            1259    18176    product_sku_id_seq    SEQUENCE     {   CREATE SEQUENCE public.product_sku_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.product_sku_id_seq;
       public          postgres    false    6    250                       0    0    product_sku_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.product_sku_id_seq OWNED BY public.product_sku.id;
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
       public          postgres    false    253    6                       0    0    product_stock_detail_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.product_stock_detail_id_seq OWNED BY public.product_stock_detail.id;
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
       public          postgres    false    6    255                       0    0    product_type_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.product_type_id_seq OWNED BY public.product_type.id;
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
       public          postgres    false    258    6            	           0    0    product_uom_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.product_uom_id_seq OWNED BY public.uom.id;
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
       public          postgres    false    261    6            
           0    0    purchase_master_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.purchase_master_id_seq OWNED BY public.purchase_master.id;
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
       public          postgres    false    6    264                       0    0    receive_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;
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
       public          postgres    false    6    267                       0    0    return_sell_master_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;
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
       public          postgres    false    270    6                       0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
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
       public          postgres    false    297    6                       0    0    sales_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;
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
       public          postgres    false    301    6                       0    0    sales_trip_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;
          public          postgres    false    300            *           1259    18748    sales_trip_id_seq    SEQUENCE     z   CREATE SEQUENCE public.sales_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.sales_trip_id_seq;
       public          postgres    false    299    6                       0    0    sales_trip_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;
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
       public          postgres    false    307    6                       0    0    sales_visit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;
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
       public         heap    postgres    false    6                       0    0 &   COLUMN setting_document_counter.period    COMMENT     U   COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';
          public          postgres    false    272                       1259    18330    setting_document_counter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.setting_document_counter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.setting_document_counter_id_seq;
       public          postgres    false    272    6                       0    0    setting_document_counter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;
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
       public          postgres    false    275    6                       0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
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
       public          postgres    false    278    6                       0    0    suppliers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;
          public          postgres    false    279            &           1259    18725    sv_login_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sv_login_session_id_seq;
       public          postgres    false    295    6                       0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
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
       public          postgres    false    6    282                       0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
          public          postgres    false    283                       1259    18384    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    6    280                       0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
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
       public          postgres    false    6    285                       0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
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
       public          postgres    false    6    287                       0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
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
       public          postgres    false    6    290                       0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
          public          postgres    false    291            t           2604    18423 	   branch id    DEFAULT     f   ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);
 8   ALTER TABLE public.branch ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    202            w           2604    18424    branch_room id    DEFAULT     p   ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);
 =   ALTER TABLE public.branch_room ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    205    204            1           2604    18723    branch_shift id    DEFAULT     r   ALTER TABLE ONLY public.branch_shift ALTER COLUMN id SET DEFAULT nextval('public.branch_shift_id_seq'::regclass);
 >   ALTER TABLE public.branch_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    292    293    293            C           2604    26922    calendar id    DEFAULT     j   ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);
 :   ALTER TABLE public.calendar ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    305    304    305            y           2604    18425 
   company id    DEFAULT     h   ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);
 9   ALTER TABLE public.company ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    207    206            {           2604    18426    customers id    DEFAULT     l   ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);
 ;   ALTER TABLE public.customers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    208            ?           2604    18777    customers_registration id    DEFAULT     �   ALTER TABLE ONLY public.customers_registration ALTER COLUMN id SET DEFAULT nextval('public.customers_registration_id_seq'::regclass);
 H   ALTER TABLE public.customers_registration ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    302    303    303            F           2604    28176    customers_segment id    DEFAULT     |   ALTER TABLE ONLY public.customers_segment ALTER COLUMN id SET DEFAULT nextval('public.customers_segment_id_seq'::regclass);
 C   ALTER TABLE public.customers_segment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    309    308    309                       2604    18427    departments id    DEFAULT     o   ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);
 =   ALTER TABLE public.departments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    210            �           2604    18428    failed_jobs id    DEFAULT     p   ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);
 =   ALTER TABLE public.failed_jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    212            �           2604    18429    invoice_master id    DEFAULT     v   ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);
 @   ALTER TABLE public.invoice_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215            �           2604    18430    job_title id    DEFAULT     l   ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);
 ;   ALTER TABLE public.job_title ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217            3           2604    18730    login_session id    DEFAULT     w   ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);
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
       public          postgres    false    265    264            	           2604    18445    return_sell_master id    DEFAULT     ~   ALTER TABLE ONLY public.return_sell_master ALTER COLUMN id SET DEFAULT nextval('public.return_sell_master_id_seq'::regclass);
 D   ALTER TABLE public.return_sell_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    268    267                       2604    18446    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    271    270            5           2604    18739    sales id    DEFAULT     d   ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);
 7   ALTER TABLE public.sales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    297    296    297            7           2604    18753    sales_trip id    DEFAULT     n   ALTER TABLE ONLY public.sales_trip ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_id_seq'::regclass);
 <   ALTER TABLE public.sales_trip ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    299    298    299            =           2604    18765    sales_trip_detail id    DEFAULT     |   ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);
 C   ALTER TABLE public.sales_trip_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    300    301    301            D           2604    27183    sales_visit id    DEFAULT     p   ALTER TABLE ONLY public.sales_visit ALTER COLUMN id SET DEFAULT nextval('public.sales_visit_id_seq'::regclass);
 =   ALTER TABLE public.sales_visit ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    307    306    307                       2604    18447    setting_document_counter id    DEFAULT     �   ALTER TABLE ONLY public.setting_document_counter ALTER COLUMN id SET DEFAULT nextval('public.setting_document_counter_id_seq'::regclass);
 J   ALTER TABLE public.setting_document_counter ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    273    272                       2604    18448    shift id    DEFAULT     d   ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);
 7   ALTER TABLE public.shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    277    275                       2604    18449    suppliers id    DEFAULT     l   ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);
 ;   ALTER TABLE public.suppliers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    279    278            �           2604    18450    uom id    DEFAULT     h   ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);
 5   ALTER TABLE public.uom ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    259    258            !           2604    18451    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    284    280            %           2604    18452    users_experience id    DEFAULT     z   ALTER TABLE ONLY public.users_experience ALTER COLUMN id SET DEFAULT nextval('public.users_experience_id_seq'::regclass);
 B   ALTER TABLE public.users_experience ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    283    282            '           2604    18453    users_mutation id    DEFAULT     v   ALTER TABLE ONLY public.users_mutation ALTER COLUMN id SET DEFAULT nextval('public.users_mutation_id_seq'::regclass);
 @   ALTER TABLE public.users_mutation ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    286    285            *           2604    18454    users_shift id    DEFAULT     p   ALTER TABLE ONLY public.users_shift ALTER COLUMN id SET DEFAULT nextval('public.users_shift_id_seq'::regclass);
 =   ALTER TABLE public.users_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    288    287            -           2604    18455 
   voucher id    DEFAULT     h   ALTER TABLE ONLY public.voucher ALTER COLUMN id SET DEFAULT nextval('public.voucher_id_seq'::regclass);
 9   ALTER TABLE public.voucher ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    291    290            |          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    202   �8      ~          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    204   �9      �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   ';      �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   p;      �          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    206   GQ      �          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    208   �Q      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    303   dT      �          0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    309   �T      �          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    210   �T      �          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    212   (U      �          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase) FROM stdin;
    public          postgres    false    214   EU      �          0    17984    invoice_master 
   TABLE DATA           W  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type) FROM stdin;
    public          postgres    false    215   bZ      �          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    217   �_      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    295   \`      �          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    219   y`      �          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    221   `e      �          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    222   }e      �          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    223   'f      �          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    224   Df      �          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    226   af      �          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    227   ~f      �          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    228   �g      �          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    230   �|      �          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    231   ɔ      �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    233   գ      �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    235   �      �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    236   E�      �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    238   ��      �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    240   ��      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    242   q�      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    244   �      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    245   M�      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    246   �      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    247   I�      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   f�      �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    249   ɽ      �          0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    310   ��      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    250   ��      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    252   ��      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    253   "�      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    255   ?�      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    257   ��      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    260   ��      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    261   ��      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    263   ��      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    264   �      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    266   +�      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    267   H�      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    269   e�      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    270   �      �          0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    297   ��      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    299   ��      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    301   ��      �          0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    307   �      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    272   3�      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    274   ��      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    275   %�      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   ��      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    278   %�      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    258   B�      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    280   ��      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    281   K�      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   f�      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    285   ��      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    287   ��      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    289   ��      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price) FROM stdin;
    public          postgres    false    290   �                 0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    203                       0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    205                       0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    292                       0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    304                        0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    207            !           0    0    customers_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.customers_id_seq', 73, true);
          public          postgres    false    209            "           0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    302            #           0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    308            $           0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    211            %           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    213            &           0    0    invoice_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.invoice_master_id_seq', 169, true);
          public          postgres    false    216            '           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    218            (           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    220            )           0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    225            *           0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 1323, true);
          public          postgres    false    229            +           0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 489, true);
          public          postgres    false    232            ,           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    234            -           0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    237            .           0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    239            /           0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 22, true);
          public          postgres    false    241            0           0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 52, true);
          public          postgres    false    243            1           0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 323, true);
          public          postgres    false    251            2           0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 24, true);
          public          postgres    false    254            3           0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    256            4           0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 54, true);
          public          postgres    false    259            5           0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 18, true);
          public          postgres    false    262            6           0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 31, true);
          public          postgres    false    265            7           0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    268            8           0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 13, true);
          public          postgres    false    271            9           0    0    sales_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sales_id_seq', 1, true);
          public          postgres    false    296            :           0    0    sales_trip_detail_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 21, true);
          public          postgres    false    300            ;           0    0    sales_trip_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sales_trip_id_seq', 4, true);
          public          postgres    false    298            <           0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 1, false);
          public          postgres    false    306            =           0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 46, true);
          public          postgres    false    273            >           0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 12, true);
          public          postgres    false    277            ?           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 4, true);
          public          postgres    false    279            @           0    0    sv_login_session_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 71, true);
          public          postgres    false    294            A           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    283            B           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 85, true);
          public          postgres    false    284            C           0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 68, true);
          public          postgres    false    286            D           0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    288            E           0    0    voucher_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.voucher_id_seq', 60, true);
          public          postgres    false    291            M           2606    18459    branch branch_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_pk;
       public            postgres    false    202            Q           2606    18461    branch_room branch_room_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_pk;
       public            postgres    false    204            O           2606    18463    branch branch_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_un;
       public            postgres    false    202            �           2606    26927    calendar calendar_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.calendar DROP CONSTRAINT calendar_pk;
       public            postgres    false    305            S           2606    18465    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    206            U           2606    18467    customers customers_pk 
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
       public            postgres    false    309            W           2606    18469    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    212            Y           2606    18471 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    212            [           2606    18473     invoice_detail invoice_detail_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_pk;
       public            postgres    false    214    214            ]           2606    18475     invoice_master invoice_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_pk;
       public            postgres    false    215            _           2606    18477     invoice_master invoice_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_un;
       public            postgres    false    215            a           2606    18479    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    219            d           2606    18481 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public            postgres    false    221    221    221            g           2606    18483 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public            postgres    false    222    222    222            i           2606    18485    order_detail order_detail_pk 
   CONSTRAINT     l   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_pk;
       public            postgres    false    223    223            k           2606    18487    order_master order_master_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_pk;
       public            postgres    false    224            m           2606    18489    order_master order_master_un 
   CONSTRAINT     [   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_un;
       public            postgres    false    224            p           2606    18491    period_stock period_stock_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);
 F   ALTER TABLE ONLY public.period_stock DROP CONSTRAINT period_stock_pk;
       public            postgres    false    230    230    230            r           2606    18493    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    231            t           2606    18495 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public            postgres    false    233            v           2606    18497 :   personal_access_tokens personal_access_tokens_token_unique 
   CONSTRAINT     v   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);
 d   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_token_unique;
       public            postgres    false    233            y           2606    18499 $   point_conversion point_conversion_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);
 N   ALTER TABLE ONLY public.point_conversion DROP CONSTRAINT point_conversion_pk;
       public            postgres    false    235            {           2606    18501    posts posts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    236            }           2606    18503 $   price_adjustment price_adjustment_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_pk;
       public            postgres    false    238    238    238                       2606    18505 $   price_adjustment price_adjustment_un 
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
       public            postgres    false    290    290            b           1259    18584 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public            postgres    false    221    221            e           1259    18585 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public            postgres    false    222    222            n           1259    18586    password_resets_email_index    INDEX     X   CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);
 /   DROP INDEX public.password_resets_email_index;
       public            postgres    false    226            w           1259    18587 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    233    233            �           2606    18588    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    202    3405    204            �           2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    215    214    3423            �           2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    3521    280    215            �           2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    208    215    3413            �           2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    221    231    3442            �           2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    222    270    3507            �           2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    3437    223    224            �           2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    3521    280    224            �           2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    224    3413    208            �           2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    236    3521    280            �           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    3469    244    250            �           2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    202    3405    244            �           2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    3521    244    280            �           2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    3405    202    246            �           2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    246    3469    250            �           2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    3469    250    257            �           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    260    3489    261            �           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    3521    280    261            �           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    264    3495    263            �           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    280    264    3521            �           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    267    266    3501            �           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    267    280    3521            �           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    3413    267    208            �           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    231    3442    269            �           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    270    269    3507            �           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    3521    289    280            |   �   x�m��
�0D�7_q?@%�jv�(>�Q���d�b���i�v���p�#����ő�j���{�ϗ��)|�� ��1/b.P�*+ϓ,���a7 ��@���]����\ݰ�Aj�i�LI�#�NO�b�-�8�v��d*�8�8
��?�A$�yp�Pp��T^������6      ~   _  x�m�Qj�0����"�$�I����Z:];���1�-C�y��gɖ�;��t>���8���C�(ZJH%���TB�(+Ml��7�k{;l�S's���@ˣiJ�L��@�iΗ"�c�p3_��-UJr��f�%,��L��s4��(-ڐh��>.��d�1�'��w�P�Xxg�>.<��.�����Xeg�Y{N�8{�hϩ)���x����Bv�:��91�2iϼA������p�q:�����654�wo�lN��؛�j��g�W��x�A��L�����z�����A��Rǚ��r��AV�����C��x��P7�HJs�%������Z�#�      �   9   x�3�44�44���4202�50�54U04�24�2��!�e�e�U���0W� ���      �      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      �   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      �   s  x���Mr�0F��)|���H;� �l�)��T��a���S�L'Y���"5�P����Ζ�Њ��WN�x����=c�r#9Ⱦ���c;Q����f������h[�y�KN��?���F���A\Z���?m nx;�� iph]}�P��� �(��p��KHC�d�&ˠ2\�c א�i��	2����{�8 ��9\&_��:#_�� ��!��Ѐ��
����� 5�b ��f\}�}��0� FAۻ��Z��}��8xa�`E����]���� K�q{�XFb����{J�4\�5�2�C8��!,��� �,=x9����+��`p�Z�v��|���aB���
���@�QX����QԆs�2�@�C7|��ȧ�/c
�=��?�d�`���̧�m��C�v�� D�^\F����oe�'>��aҗͰn����dANS�J����y���a��Zx���5m ��d��>M�MT�cP<V�1C����0�
��m�A�q�aB����g~ޣ�`c�����S|~��xc��х�
E���1���C��R6�1b�Η���w^�# H״vLΡ��2D���n��j��      �      x������ � �      �      x������ � �      �   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      �      x������ � �      �     x��YY��0��O�2����ĝ�C b�Hs�s��l��LH'2����x.��E�~o2�74�l��?���$Č��v��"O����-ݐ<%��2�	���'��c����4��:ݪ�N�����~ڦ�^�v���^]�$�>j@�Hh�wO+�z��24IM�n�Ʃn=�^u�VX+���WRbI��e�A�zL�S{Pm���S�n�]��)=*���'w=n�5Ɗ
�"�T���V|NM��d<�^�/�f'��A�)g��}U�:gn�nWXY��S��
b���7f!����$�e[��ק��B	��vv��o��k�F���5��")ŭ/@b,"�-<��tV�U�p��P��UxlAE?����,A��2)���x�ޗ`�����s,�.!�� 6N[�����i0K�I�s�G��=,dmb��A���<dй�B�Rb�͆���N��%=�aP��er��0�������^F�U��uc���F���pYT`�WxM�PcRBa.c���Ȋ�����V�cM}8>�BlI�91B���2_[Xcݢ(ZD���f�+���j�X6(�,ӕ��\<�)���Ԙ��CK��W�"O&�+������R����PHB@�.a��&|�s|� ��cb/����D4�¤\IF�` ���-k|d%c4�"�%{���sqi�J [�=���U�(�=>���q�1���M���ǩ��
��N����e�(#� &Y	b@��]f�<�#]w���o��<��L�(�A�~蚽ZJ3/}�<o�o��g��c�W|F#�rG]<�`� �8���J�����]w~ABx� v�� ��#ŋ��²$"�n�-Uxue% ��u��s�H#;� �s)8�-<�:��Ӏ�e�tg�JI�2x���2ii[ۗ���EF�qlKhn�{����^a��&�$-A��xm��v�*�u� �����PΊ�;��Yf�7�����"�����<�� 1��H��b$��Y9��������v�g��`q�	 ��Q�h6f�����c��� � �v*l!L
g��r�-
*�R��(�[lUc*�ӹ���m�U'�y;�g�K��,��K2��{�Y��v���~�ྯ�����q�)�k�
��	ҵz�-"����(
�D�'
7���m��2�x�mi��ls)��W����q��o��>/�J�K�rq��>�s�'�n-}) zc
���=��j�m�e�ٱn��~w>��#�}2�χX k��Zb.䎝z���ٖ��{����������      �   O  x����n�8��������O��m�8N�.z��A7�n
d��C��5��[e�\8���r<<s����|��/���Rt��,���%����/���릸z�,.��oO��:VO?� �p������WNW���l����갸9��}�����?�<]�oc��6���vx1���xliy��Ip`�ر��Շ��j��j-9jDQ+S��jO�o��#|OYD�T'��xV�4r�*�%޶�T``�D`��E�7D�W��*khFٮ�m��ѿz|���YYY%�Ք�g�(�P�_�a�ʁ�ݾk6cX��Z[���.+{�:���0�]9�~in��4[��L�5SekzX��U�P��/�.�6�f��fa��B!!z��%� ������2�Pz%�E'�,��9ۯ�{*�a%���V��y���E-�%#qW��S���s�5��"*SV���,ۺ�s֗��/Ww-��0� ���2r�SВ'g{ ��S�8��(�r���K�V�hMNs��F=3������k(���9l�f��y�3�u�Mu U��#��K?�p�N���y08��]~F��b��o?�<<��l�Q$�Xė&&�����&�0'-~։�� |ռ?����v�$��7w(��c �h؛u�Y}9���-_�_��/kfO�AZ�Jkخ�˙yk��U�qm&Ȝ������:32C9��e�'ʲIF�$cK޷zXַ���*'9خ��]7kB�FE����	u�LFČ���X�7�w[�`����[�ڒM���{g߼���آ�б����Y����?=������E�A)�/u� <^����<����	��^�V"vvsN!�JL8��b��A��Pʹ��a�TY\�X�qEC�M{{O����̌rNj��n�͠u�Æ���պٓS�X��~��g9���a��Uj��:���N6��f��ss}<��Þ6 �ͯ�QN>��2���p� }��K�to���o��=sA������L ������w�(�)�[�t���Ƹ�\Hn?��l�;���d���k��?^,j�3������~�m>��E3�Z6��cz���X�:���Z-�����7�V`� �ml�r6��f���A��3ڮ�bC���uAA��$ǰ��Jn���p�w+
�N]A��ά�1u���3�av5ϼn�2�ؙd��̞For��C�)����֖�?��]�E�u�:zY}B�gZͰ��O5��H�-���!�K*/��x�����52�W��������N�a�[g��?�^�g2������LZ�m;I����u��߆)vL2&t&���9ȼ9t)&ŕN������}}sqq�/��      �   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x������ � �      �   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      �      x������ � �      �   �   x�u�1�@k���}�K����2t�@�)����avϗ�y��>>���s��kq+��:�V�������%��p`8���r�/�{�{���N<1x�ӂnt�B\|���b�co���g�Ƙu�:b�bK���r��p\g4����he�af?P8:4      �      x������ � �      �      x������ � �      �      x������ � �      �   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      �      x���]��:���3Wq7P��o.bV��_�(��0���Lh4�>�>�V�V���e��;�W۟m��n����i���g�?�������g{���\��}���a-�6��������|���]���%��i��YK�ȹ��kW��?�%_��H�8]Wխǽ�,⺬��CD�ھ�?��İ�֒,⺨���� ��'Y�uU��I1�d���.V³]I9�������}��ȹQW���F]�2kIv�o���/�z��'Y�L]�2{&Y�L]=��iwFdW�m_�vƶ%��\Y&�2 vi� ��e=#��kF���$��.����^I9�����[QZ��z6�-�ȝ�oݒ,�RZ�z��{�E\*�9�𙅑�kL+�~'Y$��׺�g�oYxd����RD}�d׵5T��ݓ,⺶�B�W�ݥ5�]��ʡȘ�:U�ɡ#ტ�T��Б�AE�g�x�8zFd��('9��U5jQ�|eaDve�X����C�ᓎîî�Q�2�
�,î�Q�m�~�
��y��Faʑ]a�4/�u���<E����L��k���s]��Q�b����)�t�.u!��F]v���rq��l���Ny�t��NY[�kkT��J�\[�(E]^.�QV"{��F=�9߮�QUj\W֨f�����M�`�$;N7��%+a���-����`y��Y�Jz�(x?2xёFX��*�uQi�0PjJ�w����,Z���4�l�*��J��*��N�nۖ�J;�Y��tK5��y�Ҭ���D��y���/L�A�����h�4�-͍{aZ[������5�-	���m���K���%ڲ�������Q�^�>���4���ya��k�޼hۼpK�P(�y͹yӑ������%�(/K�K\j�4	��x�#��iK⥟,��%=z��x閥�9mz�y鞥��iL�~�KY�͜Z�7�����Ԛ������9={qٌ����5�s!�-~ߴ{~#���%��H��Ӥ�_(i݋��N�x�о?�5V�h��fҦ�/^�7�%�~#�$��&��.,|$�7�3	�i_�K���
�ǋ��ɱ8cZ�����߻�!i:��*������������Y�͜���K}|�~3�-&�^����|���G�d�k0��|����=	�i��;'/}d�7qv�������ol�L�ۼ𓄑7}}����ٖҾ�=��I�M�*;No�#K�o����
� ���?v������l�߶;V*��$����Sb�`�$���$��Og�ߞ���������G1���<��B��r!����{Y�.�@���?��i������?�x�ۮ6���A�+���ׇz\�{'Y�}>l�[�ǖdG�G���7�V�}РA�b{��麮���*�d�e��j�^9�����*�dG��E�qϖd�U�Wq{�E\WUЇ\�G�Eή����b�$�����[�+������`�-Ɏ󽨫�;K+֒,r��~7�V�d�3u�\W��,�Ȯ��]�
|'Y�ueE��]ZQ�w��ݲ0"���&�*pO���W����+�H��ٵt�Wq)����
|gaD���[��%����~�i��Z�E\*+h���=#k�V�J_�g�EҮ�����,��][A?|l[�m�um��U\K����
Z���.��;�+�ȡȘ��uf`�^9	ST�N��'����ҋ��eaDvME3��=#��*��XE>�0"����L�!oX�t��������¢	��
�Z�+�
��i���c��]aA�cź���Ŋu}Em�����+��8�+��������t�~w�W��+��W��+�W��+��cź������
>�X����s���
�VV�++;Y������`wWV0��bi?hk�>XK����=^2���Z�r	,��� ��,����7K�wŏ�����*�uQi�0PjJ�w����,Z���4�l�*��J��*���!�#k�"n�*�d�k�Xޫ4�,u%:��y���`�9�wX�����f���i`�giF�xх��.����%����Y`�~`>	5[	,]�L�Asw��x��t4��d�,��k�K^�Y��˒�����%`��e8�: N���,<��4�U��G�t�U�p��#m��Y�ga�M��N"Y��0Ѧ|ea�>��W�}�~�ŕ%X���9�$��\�k�R�=�����-�V�jc��V�jC��V���V��s0r��_�F�kɜ�'��[q�|=���H���L���J^#����ۉU�'������:��?��2�VZ�j�}��-ܨh��C�^T0J�C���>��PA�g��o�������d����м
��ý�w�-�����g7���'��۶,<4����@���OH;�}�ga�����B�ƹ�"iv����;�"g6�Ėـ�=W�5��j��-#2ե5���IIS[Z��d�3��5	��I9S[b�qf�\�Gd����$"�[���mm�ݓ,���F���m.�E�^I��ō�R�$Y����%��$�wX~�~�=���149�I9��?�
S�s(2~r�H����;�p��&TȖm -$>��a�e��/�a��O;�3�����X(*Z|>3�=����l��m?��Ӯ��u�W{��Æ�.���<?h��b�^6�t1L�N���|�x�ƈ�|Y.�#�χ��*h���wlٞdq���x��0�d�e���WE�.�x��0�dG��EoPŽ[�E\WU0���ۓ,��^n��G�Eή�xS͐��,r���=5C��
�Ԍ�gK��|�*��0d-�"g�*��(d�$����x�0�ٕ���,⺲��𵹴;�Y_[���w-�$��.�x�Ӑ=�,rvm�0���V��i��Lq����mIv�m�V��jג,�RY���!�gad�ڊ�v�3�"i��b[���0�vm�[�F�mK�#�����hø�d׵�E�ui�[ц�C�1umb�WE�U��m�>9t$ܩ�x��(noY�]S�Mw��=#��j�ao����Zl��4��vC��C�an��;�F��
[lY®�Ş�!L����]a�-�B�o��.�x��u}-��a��b#�v}�[х,�p3��=�h������k��[��a���+��C!�ڊ7RY�V���Bֵ����uiŻ(��++�9d]Y�>�{����C����6탵$;N'��%+a���-����`y��Y�Jz�z�P��.*ёai���2X�f��4{,-�&������lV�Y�l�*K�T�;�4��U��Y�t���y`y��lG�ԕ���J{����ai«`Z�	���f�����i�qD^dG\���~���'�g�M�Y��$�l%�tDg0}��K�Ash��y��O�m�7]x͢��� �,@�eIf	PZY�0]Ѳ �v �]�W��u-�OiӅW��-���ëf	����6&:-�|daD��D�𕅑6���0su��,K'^\ю��ċ,⺺�U)������렾%޴�Eq�$;�/4�㿬�L]i�r~��hĥ/�<�Ҏ��[э���O�sO��yO���H^#��
��O�ʡ8�;�"aU����i���%�|��'�z��Ex�Z��Ui�a���уWa�MGK� ��0Ҧ	/?'^cGғ	��,��$;r�<x���gad���+A�##2ե5Z�^IIS[Z�l��3r>��-Ɏ�ië�!�Y��-����GFd�l���=y��,�}f_���eKki�n�Ȏ�/���Z�E�.-�= �d�3����g�,�/���J�ș�[�~ֳJ�ɡ#c��:����=��i���1�*۞�l疡��Lw�hGd�����?B��8����N�O���x���@~��px��aK�8珛~����$���qO���/|&�7m�X|���>�;	�i?Ix��6WXxn[˱�r웳�+��9�+%|䂾	����^��+��Ű�ƺ�%?D;�i�g�~��mǸ[_m:�o���#><�Yr����&��xĢ����;�x�q���#��m�K�x�E9�<�c�䈬�qS/9��L�j��y��Vs��x �  Ě�6�Y�\k�<bM��L��#z��YSrēG,R���S���LQ��s��.�+�ULo<b�u�^1ㅰ�^0Pz�w�tQ��Cf�9"��Vֽ`p�K�Ȋ�yC�|/�kԸ{�<5�{�<5σ�(���,����,+�.|�=�v/��(ũ^j���#���>=b��1[�>b�������5?���)�cz���,�^�<����S�]k�L+R8k�ը�d���k}�f��Nq�fZ�zN��^seΩfj��35z<Y3Vt֬+��d��Ț��;�Ś��k}y�<5'}�d��"�X2�(G/�"���J�(:"+�׼�]��΢�qz3+R#+f�y&ܬ����n�k��͒�k�7-���M�����Sf/���ѵ�Sf�Q8;�X4��5S��a�=	ِƢ�䈬���͌�k,J��7����ܭ�9��7%Gd�55�9%Gd��4���V�t5���_r��9S�Gc?�T%Gd��4p���V�66��h(9"k�,�c����#N5Sr4��[Mk����:�䈬����em���ߑ5s��Lc�\55��?�%Gd��=����el���������Ӓ#�fa���#�f�;���f�Ŧ�MΦ��]S�l�c!Rrĩfj�p xj�p ��g�4 Pc� Z�d�M 5�=�& Κ��@��{0N XM'�8`5)�	 ����4P3zd���#�����! ����>�f5w�}ͬ�Sp�j���! ��͌S V��5NXMG�8`5ca�) ��� �J^rD�LM�8`53W6MԌ�1�g��5k�f �8`5�=�) +zk���t��S V3$e���ΰq
�j�
�S V�6NXѻ� ���l���YJ��մ�m����1NX��q
�jz��) ��3�X��q�j���1 ���4P3�c���ްMs {�Y3E~8� ��S�9 ��6�4�ל5� ���l�@M�٦9�"O�s V��p����{�Ԭ�Z�f�<�{�Ԭ���9�^3Eb��E�B����R�s �fVў�f��8}9Ss7��u|��fj����yf�{� �f�ٷ�fJ~ǾM5Sr֝s V3;�9�kf��6}�Y���9`5��s Vӵ���5��>mPӋ��6 5=�>mP�M��6 5�u�������ߑ5S���w��{ϴ@�,W����K��6 5�3�s V3'��m j>mP�9��6 5i�i댊�������� ��F      �      x����q�:���D��"R�č`��J�~t{7�+̙r�<	� Ʌ�Z�Ho����~����������ꛜ��GR��z����������|#Fv�\1r��A�[�s�xN�����Z�����mGi��E�:�zu�3��������h�h��W�� �Jw�s�9�:�-�WY#�~�!�j+֭`�
֭��'�5$XC�5�XC�mH�n��E��R��x����S+�r~/z�VlŚ�\A�ֹ`i�`iK[����ˆ�ˆ�ˆ����{YÖа%4l	߹�P�6ԱulC�P�W ���m�c�؆:���Њmh��lC���؆��!�l�{HqK��g�})o���s��\01L�s��\01L�s��\01��@b�RJ/����)�`J/����B)�PJ/����)�PJ/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�RJ���+��)�bJ���+��)�bJ���+��)�bJ���+��)�bJ���+��J)�RJ���+��)�RJ���+��)�bJ���+��)�bJ���+��)�bJ���+��)�bJ���+��)�bJ���+��)�bJ���+��)�bJ���+��)�bJ���+��)�bJo��{HlC�қ5����fM�7'�>J��˚���ס��^�e�.�� �}h�50��'Ȁ�M�/� ��"��52��'H���� ��"��52��'H��7� �n��E�)Q�"G�D�x��-69�b#�|��
��� K��ubi#�|�+X�7�x5>/#�|��N��$��7� �%D�����7��؆"�|��6��$��E���m(��'HlCn>Ab�p�	�P��O�؆"�|��6�擇�l}n�
����	U�OD�����O��Qbu�$��ױ:�	�:�	��X��uK�y�~�!<%bQ)���O��O�LJ�cU��r$�j�NJYc�uⓄR�X�����ǧ����~=}�j?d;�.��c��dD�o_��N�ҷuT����F�[y�ȸw�{�.�d��ߥUmK+u����?�E�U�Vkp�m�E}��!���Uϫ=�/�(��U�O��(��U�O���(��U�O��eF�w��}��6D�w��}��6D�w��}��6D�w��}2'�>J�C�P?�J���P��J�	�X��}�Ī��=V�>Ab�R��t� �n)i�U�O�X����*�'�SR ^E�J��H|BS��t��#X�4L�t�(��:�,-M�*�'H�<����D��}���%M�*�'H�[Juc�$�-���
�	�_��(ՍU�O��=C�n�|��6D�n�|��6D�n�|��6D�n�|2'�>Juk�|r��L�2F;�&�l��c���qIR˯hӣ����o=:�,J�$�еǄ���{-����$d�G�n��[-1�>������Hr�ѣ#>��^�O��E�n��AW[�{��VcI����K���^o�FC�5j��el{�%0���뽮�^��h}Y���<D��f�i[�
���s��3�q��@�H��ƹ∊e�bDҸ�$V�#��V��A7�����56Ҋ�8HlCV��Ar��))�j��Q�"�g��V<��s|+֊�8H� n����V��Y'�֊�8��Sϊ�8H|�YQ�� �+V����iň$�9��sLc��Kې]r��"�6dE�$�!+�� �Y�%�mȊ.9HlCVt�Ab��Kې]r�C���Y�%i�0�@����*��ap��Q��5d58H��v'����$��Dp�X��$۝����E�\��Dp����LJY�NG�ɽ���G��Y'>I(�;$�[J_t"đ�;����� ���SIa$�����%�v心ĶG	�]�� y��;�:I'�!}C�*Qa��F9��L� �YRl78H�z�fI9��L� �Ql78g"�l}���6��l&pD����	$t1���Ab�R�l78H�[ʻ�f�uKy��L� �n)ﶛ	�))�
�"���F��v���9G�b)ӷ�	q[�v�������Ari�GcvK��ĮB��vK��ĺ��n	p�X���-�
%�vK��įJX� �m�V�%�Ab���n	p�؆(a�[�9��Q�Z�� ����G�S�����R�x��w�~<�6?>�����~�����]S_g���o��^�q�J]ƶ�C���§琲]���^k`�+�j8�|��^�)���{���pLgEJl�q@�@*����ƍ`�nX�[9㥍����2�*e=�HL��i���<�xZ�����]k�hE7l 55+�a���	)���&�x>؆FUc~h� l����ʱ賽���.���Ԣ�6���Uem��fCHE�h��&`�BH/���@z�X�������a�+�D��l�+{F����1��E�6�Y�]�j��.���6�y�]�j����.H��� ��ѬF�'�8*'|�����b��%·�]�j+�/�5�G�]�j���mlW��@j�V�����v��'`��{2t���Hq]!�+mf��XI3H�H��QHH���N����ӊ��q���}Y��']���x�^��ҏ>�/��F�{����Ӫ�b��T��ױ�}?ֵ��?B�3�e���}��.��_ԗ1=~�������rH[t����*g�(�ُR�M��Gl@�Ix}���R��]�mJ(��{��'	Z?1�H�]��\_^�-M�-|n��#���z%\�t����o�܎v����h�My�s^x������ex�?�����G	e�׭��>A�+���1�~�O��!����ު����h;�/�S�[Ө�m���UBVc��@z�Ð�]�o�5Cnv	����w��`��,�7qL5v����X�]@o�r��ە�6���]�n�a��.b��� `�ά`�'�8*';���uH�7�3K�m�*��A�n��6o��TT��K�m �Pi�ݮu�ݘ�0i��@|TQ��:���R��h�]�n�@F���vH�*06d���@j9� �u�6�Z$�vQ���	�]�n�HM�z1��J���N�ۜN�|ֲ������@����[�������)دHد2�?��U�^��4�M�r��5��5^�����	ݏ�-�hy�a����{�+x�:C҇�BmO}��d\�\_��uY��[p�YB�i�}�4�~j_����`��{�q�9O�o9���p�h��!����ː�yv�"�?jTl�3�YoQ}QA�[�B���\1�s�`����q�Y�Ό�-k4�6K<�G[������=AEnvӮtP=�X�8�]\�4��#���
9{��H��i\��И���xW��4��=5}$��i���-F�^��!�eN�G>r�n�ķ�ߏ��wፏ\1��4��v
r�Ӑ���:m����F.|$�v��؊�A9�	�H��)G��XCS����W���A�[\ \�Ѭ�#�Uf�+�H�Nx�>z�ѳ�#�:���h[����m޹�OI�XT�Μw/���^��IߙF��Z�侉�I_�F��N|��W����#��N{|䬙�Gκ�]�Ū]$��Ub�&I}$��i��G⛁����GⳄ����?�`볉�Ŀf�'?�����z��7�b�f�}$v�i>�GbBO��|�@�����e��Z���c��n�7�J���[��E���_y��A?g��$�5�v�&s���&��C��#�׈������3sx���Ϝ�t}���]������?�vի��O�z��oM���:������ױ~e����2�qmu�Y��k��i@�h�F�g}�}� ������*��W��y9���(kTƟSe{1bW��_CF�83������l2�s�=���٘�g�[�x�����i��w1���������y���1�|$�F�F�5���E��S�n��I�pFC��Ė@�p�J
   Ģ����Kp��У�yk���X�4�gt'�
��� KKc�F����7.�L]
�_��F�F��/l4g4+�H�[�3�|$����8�ѳ�#�����m�����m��G�y�Gb����_����G�c�Z�Ɛ�&	<f����1���Y#�?笓��Ѭ���s��௳Pݣϼ}�'��)���d~o����ւ�$j�}}���[\�W����EǾ�p���7���u?d�
�[�x���l��(�C⢯Gm�>jߢ�b�,�g���s�{�.�j܎�ڗ��V�jܿ�����έ���}[��,�=@v[���o�ǲ��GX���i�ot��ee�F�~��GiW;��k�m����4�Eh$���p����Ab�Z!<GCF�ڙ�6t�|N�� �~��Rq���? �� GV�J8�b��6wL+֊�9H��(��N���A�],��svŌ��X+�� �ar���~%;H�
�Aboi�u���� o;����ܾ2�G�g������A�K���A�S���9H|�Y�8��&V\�A�TM��ibE�$֭�r�X�V�ʙs�����f�������$|��B���|v����>f�9H�NJ9�~!�-�R�_ș�������B�v�W�eR�b�9��H�x��7��B�:�IB���/� ��Z�B2�_��#+d#1��rV�-ȪSp�؂�:�o�p�~!��ʍ�~!���W�_�y�S��/���C}��Y�\؝F��;'%�v�����I)��@� �sRrm787�l}�\�6��n p�XXJ���5��n p��S���Ii��@� �%PZn68SR ��v��ć��f���X�4`78
��� KK�v���7.NZ��_������/l����s���A���%�v���/���m��G���Ab���n p�؆(��9��Q�X��ąA%���A��@�}�'�g�;s���gN���Y',���7��@`#aL�n p��DC��'�z[%�Ū0 �UlO�i�I8�B��8*��x;i%`;��}��/@�ׇ�Z9�.}��ç�^�����5u�TٶTٶ=s��}�MK��j��.�>��tC\-"��Hi}l_$����*)������۲K����ۀ���g	���#gK�z�-��ܭ�4;�L������i�{�h�jK��ZS�62E��M����(��e�|�Ls�S�ԑjm���<(���G�܃*�{PS��=U4M=�4�G����kn���o�{��T�i�!�zs��[S-DS�TR���ZH�݅�0��$u����鹲徠S���R3�������G���榩�R�ޖL�Ӗ�J}�K�Ӳ�^�����j�=�z{�Js/��z9��GMO���ي�{/�ԫ�����Y��{��O�T{�ReK͎���tM��5��\_H=�Rs�uK��-���r��맩����Bj��V��q��3�m?�/e4U	�&�G;��G]�q"t�47%��Z�H����#w��'�H�S�Ou��!#��G���zV��쩾����Mg��~��������KHj:KR�V$�hER������ĝ��T%5�+�1.IMQJj�Nr+�R�c�Z�$�)J�-�I�\��ؠ���Hj����T%5�)�5:���LM�Kj�SR�H��>�Բ<IM�Jjy���Hn�4�IRK�$5+����b�͟�T{K�EKjF@R���rW��I}9��j$�;kn�?5�(��mI��H�Ws�BjN\SK�4����?��̝�f�$5N.�qKI������Ƒ47�q�l�HA�C����m�[���4���Q�RǸ�a�m���׏��RU㭊���|�vI���x���p����dQ�:��@-�t���r�z��ZS��|})���\�������V_���3�G�˨��[ݭg�:N�i�z%>�-c}������wWj���VbhjLOS3 �7K�(�R_�}�ud�e�t���[�mz˲K�>3�^���o}��2v��v˴��}~�f�8J_���?4�ߗz�C}�
�����.e��n�V�q]����u�o�:V� ������?�K8�      �   �  x���ے�6��9O1/g���&��]Wv]�^�#�3��H*Jr�_P��ԦU�I6?���4E�{ڝ�����e7�5����`B|��w��s�A�\W��_���Ts:����j�cOc��8wa&���w��i�&W��u8�o4�ү7G"B�7��S+�U3�^{���P��w�#&0��J����HcB���nEv+����/&�!"1��k�3QofgY��͌�V�DJ;Q�?����|�f
�z,��ܬ��o�r� ������~حO+��1��������(غ�C�0ͳg��l��D�m'�O���} �a�� �XB���D��l�8t��3f���0E�` 7!�̡?)f�������)�{��Y��n8��[pL&M�B]��4��X��W,��x��@���A�c��&�i|�g���
��. ��n'��5�y�H����y6tUz��"������I���j���A��˕�ç��g/�nu�춇;��0�Ě_��A�h�(�K(�T�E" ��[)�����~Ԩ�A�����ߐS	�#�L�Ο��p�����=�R#�Q��a��!e������%�n��,XPhU0D�.`�N[����ڂFw1�+Q��k�6vk�19c��2^Р�7�g���p�
`��E#���83%�>
�aK�/l~9uۧn�<�~z�t��a�H �/l>�ۧ�Ӷk�3~��m6�"`�˛ϟ{�%�1�m<���}��������Ӑ>�
�n:4?�C��|
��9����|�د����<m�M��6��8�%�x����{�����Q|�̖�E�0�U�r��4�Ur��A�����˒t~��l��|'�M�87�h�ۄC_��.� =i�� �#�)	0�gd�"#�pą�`ആ���g*�5'4��E{�@m'�A�$���Z��y)p?R]�/��Y���v�5	iS��.GAަ,��KA@�+�� 	(�� !(���Q((ئ'3S���s�itH{�hj�jeGw��������Z^�{��$�u��=PS�BV���3(dTI��"6��:�lȮ �!m���6�#��$�ht�'1��4nt��mLA�TmlA��l܂��ش�e%Q���]���6�_[Y#�lU����
R�5"�fk+DH��U���m[A�v��C��*�~����Ӹ�h|�ҕ�*J����]E���UT��N���� W����؁��A ��V�a�"6Ѫf����d�;<oz�-�����>0_��8�C���,��	�a�=��_P�����s�C��|\��q��k����z\�-`��l��t)�%�DY�W�����*�d��,W�W7���l�(�Xw+P������\�������VQ��%:]���{9������|���mu;�O���1��;�,
��hzl��fh~���wԕ&�Ic��k'Ɲ�� ��d	Îe�{J�/����l���C�kOh����;O�w���h�-��w+�#uD$g��V���-�7�yAC�qQ���%��ƣ����%���)X��v�| wr�-h����\E)`�ZŴ��[��C��n�OT��Έ�4o�C��E[꺯&�5���,��8� ��s��Q�uH��aƾ�~C���3;.��i�����T		�C��!��iR���&$��]J��M8�Y~����B��J�Z"��JIxO�����y'��ع<�0�V�7_��l� �����j'bv�
dr~�(ts�"00S�r� f�U�@&�u�fN���˟ӆ\�M�>������]�����	Ȏ�2b��(�H��PtK12a�bT�l����Mѵn��>��7PmHW�e`F�/y��[�B�k�IϪ���D$���gb]�uwZ=��N9t	;)�r�1�`��9X�9s y:�pU:=� 1:)���9�N���o��2��%ܜ�˗�z�J���9arKmr�ȸ
��;���r���HZ�x�����33,T�L�%i���+�'�P<i�,�g �a��u���uC�}�W%�c�
�6?t�#9�1��z�3�e�?�/_��]�Y�Bf`���[8u��~ꆧ.Y�b�Q֞/���/���O�p:t�]z�S����)�I��d<ZL�XAFES�"��F����ӱ��'?�l�#sڤ�_�a��&��~GO�,��/��{��|6����{Z	J$3ʔ~��y��c������ ������:H��� �C�z��5JAq���E���Q;'�ՒE"�iO�͚��Jn����)��c&�\1 q��O��п�bi��+3
ɳw�v#����xA��G��z#

�1[o�R#����&g��Ž����L��ⴔ���Gu��:�+e�W`�/e&WlX-�������q��{;xG_�q�����?�*]��*�����M%������+�+�$.5%'��sS��<ƹ.�1�~4�]Z@��-;���r�×�?]nG����\����\��1�� 㮉��cb9Y@����$��E��dL��in,�\�s �f��g��k��X�+�&hqgkXԎ���(-�Lu�S)���hBq���DM^��Y�������u~�w+g��n��ӝט����0t���C�v�R�h.!��w���TIjI�	-+%ǭ�9'U9��.�*.ߩ�.WOg��o����������������Q��H<ؐ��� �JF%X�ؕ�v�e/��L�I8�)��	��)r�靎��L�L�����)	��AX���n�LUV�LS8q@�Ɩ,�r�+`�=��a-kYA��IP���!XQ� �d!>��R�+��@���a1�]� ����-X��;���p<EAO߉�2D�,๻l�
�l�3�z&%A��le����U��,�*Q��S,�QOA�ˡ�8�Vv9!�d\P�dd.u��f�S�>���ٲJ&��
��V�x����^���p��u�Gh���¨���^<4i�( 
s���֙��n]
y鶭C��>1v����:y����܊%#x8��b���s�3]�����2b�=f��2�
&�vACt�Y��y�B��Ee����xݞ�� s]BJ�B���k�GHѼGU�V�����u�$� ����S�)Q�<���AJ9%*vt��rJT��)唨��-R�)q}�	���u� ���EX=��$� �V E�_�%���%��K �tij@D��.�������#A�+�:�}[��Nع���x�v��r��RɫR�g~v'r�Ǹ�y���dbL��ϗ�2I��ص��3e�gPy?uCMRJ\���@�dZ���X5�f>����X��T6'!n\���1��YtO�YF¼��y͵�XP_�|�s�J�R��J�h������[&ƣ���q�]�� ���q]�=����Q�e�,���a�ag.�.�#�Xd��o�W����U�̉;�r~�L#�t?h�t�3s��L+�p�h�=�3r���Z:c���\�*,�2���P�AeJ���:���|�=������4�=[Z�\x��DJ���#�4ue�^de����O=�����]��/+����r	DܳU�`]�!.ښ%r��V�t�l��9d�ֈ�+vl	����K �~]�R�Cu�U�=Z�\E��U�"r�<�r�c����u(W�;6Uw��۟��$��ܛ��ȯ�����'�<�      �      x������ � �      �   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      �   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      �      x������ � �      �   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      �   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      �   T  x��\m��(���{��2_��Y���X����dvfޚ�.��B-���+��+m�������-�;�m������^)S���(֨yRc���*�@�_�P����@��5m�D�F���{Pjx��0P�+%J��3���4��Z2�QϹ��NSjkH1P�+�i*�$�x%>M�{+{x{e>O�;$�����S��0��������������sh;�a�2���`X�5~߰9��1�x/�N��ׅ5�Q�wsʻ�:���㕣����K�9�)�u[\,��͂�+������{,N3�r���>�c�&Ҝ�@�Nټ�ֺM�;%:ŭY�zm�+��0Pw�[3�b�����Z�a��buZ3g���Z�'n͜c33��zI�9MTi%��am�����yֺ-�&�9�d�w��IMlۍfα���9H��X��cu�sS�1P�s����9��9ba�툡X��رg[���W�kǚgCP�M�{��92��W�c[��E,�S4�M�1�m�����N�I�fi������E���������k��`Xo��O�zo�����ޛUB���Uh��?7`��R�#�⍿/��W�0�Z_�G���Ħk�������F��ڬ�NS��p2ԝ�����a�$c�7+���1Pw���zә��L�Yr�ڱ���0���tz|tZY>�E��a'ΤvW��-�v5>Ā�%��Xc��bfg�3q*鳎>o���V���p���@�M�~�a��a�Om͜�0��|5���fb�z��u�1�^�����[�f����k3��N�f�b���J7�v@޷A�c���0P˫ЏM��L�5�}lp��|b��{Yo����p5�"vkZ�ugɅ��mt�0Mmuv>Oq�K'�nO���ʺ:�5�}���'�j1��L�8�9�c5~ҵfɍ�c�fqҥvH���0���"�6��ܱF��0���f�����4�2��5�0Tu��ͯ�a���5s�h��|�a	�'�:%[3Hw�Q�;��w��,.y������i�\@`�U��z	�.�_�as�W�8k��~�rx&��Æ���b���3?�{S��i�d�K�ib�T�7J��C��8%K�ڱ��65���X�:����:����5�~�����s{["�����a`�����1�C2��Ҏ5㯷E��)>\3�S�0e��Ű6�;����r�a�yk2�y,i����7\�u�]�|���2�×���8����/����f�bH���g,^1B�Rs⺪U%�[�ל�a�*q�ǠN��#���G6��7"�G�8ob�*���e��f�RkKDDJ"���ڥ���1P�ֶ{]�0P��v,���A�Q�H�\��0P��VɺV[��k�V��0P�%�(g5	ð�31t[���#:q�c�)V�K\�:bD�Sw��}m���Q��;��c�U
���d� �vl^3?U�A���Th���L�!qM��T�)M��=W�0P��v=�r�����Trm�d�u]�4)�֢+��Q��v^���&nŌ��-�rN�0Pۈ���b��AX�2E&b[b[��:���M���N���C	���d'!�P��&�a�^X�]�˵yb�G����?���}��L�	�R�1P����ib�vs���ǧ��*����!C���@߫a`&�]��aX�Iө\bڰ�8H5�`J��6[�'��\�Z7�Ġ�v�S�\B|���qnv�b�)U.Ef����^m-�+l�<s��9�;3�k<B�)2�@m��*��A�PZŪ�OڊJ�u��P�C&��+�f��k�$Uv�
�S��1�-R����LoӔ�o��kʯ�����a�J��e=��s��3Rҕ��:��ҟ\]�a�ja%��j\��!�A�Qb[\��U~�\{�Bʏ�WG5��r����C0r9�md�n��W�+�K�o#�{A�""ݷ!5�6����4%r*�i:�I���u��o=�����^y��Hw��R�^�0P�8oZ3��7TU�v2��c��R]��&ꩌ���� S4��
��]�a�Ң����j��hm4s:�a�N����"9�G0���D�*�����Hw�6���Y��ֻ��O4챰��L1r _�G�Pk�U�<����\��ot�����51710E��Z�	>m�g@�_�ҟ��ڭlR�k���E��#�n��i"��%��y�0PU�]	� À��[�gj�Wi�;.�b�[�Qx|�Z_]�}Hk��6d�,�fLRc������00E ޕ1gS�.�31�e����Ie�U8���u7�uCVMr]�f�+Q��S4�y~0O����1�W�]rj�6��;k�u�m5�{H"ׅ�5/f2���H\�fb�Ue�[��2���*�5�01HO�[[������c�Od�|��W8�ǀ���Ɉ��]�'�=���Z��N&Խ�4ub�Juo-9�$��D<?��}ވ�5�1�GHa)��*}��9�ZS(�o7��2���H~����0�j�3Ɂ�+��<.��]�1B��d���~�r׹��:�.��rD�4�D��cq�Ï||<�"��Mʓ�E6_z`�%F���A�>� )G\�k���ʛ�r"'2�a��+/�cRPF@��'�,']0]�>��ۚ�ĳUJ�y9&'�r��u��UN7Ԭz���L�@�Մ��W�vK?�H��O��\��m����0چ��Jd�:bD|+�f�>05f�׮��MM�����ٶ��a�RE1�R�Ƕk���;g&_Ln�E>|ry��T���<�ٮ2��0�u,a��  e懃�D���0X���2I��^Q�5|R���g����F��[X{e�\Bb��:ܐ|�ְ��a������!�~��F3W�n��Ai���0|���B��LN�4T�d�5󽖏^e��?�rߺ���>\�/�*r��c�s�@UosZ���:�@Uos�I|�o_��uŠ)���I�a�z�u1����%�\�!s�>T�]S��`��~q奧`�>�Gb8F�~)�x$4�Ζ݈㨉Bb�SIn��Q[&o���1��m'S�)�vM���Dz5�!������ρ���6�|4Ԩ���6�l�v�]�׶=	At��P���:���MݕDG�${^���(�l�չ�Q�|��aP7�G�$�2�$\L^bb0��
&���a��o������z��)�>p2�,4�\��P�9����Z�┱88�U���1�t���31���զN��*\�:�o2:��C���M�^���C>�]E=B�Bν����~�P����*V+�5��n���~r�K�1N�+�Cٓ�����Ck�z��6���^%oJ����u�f5`�@�R�5�/��H���p���~�a��@���짢n���_g�B�u?�210�PV})�arԒ~���̻�q�ta�Kl�6*PT�����N��gR�:z�c�y/l~j��7�\��{���t�����F��r��00�d.����̂�V�a`���U����%�g���C0Webb`��܊���ɬ��;��V�I��X������V�S{�������[�}H����fy.T���a����"�B!�p+�z�0P�[qA҅���Jp?�ra�UU��n�W�9�������u(X�j��pU"��3�>�]�&3	�<���Y2�h����l����a`�	3>��d:_6�`7��ӟN��Y%����1C=L�uM�\ؤ��Hk��Gچ�5�8c��IP��W\�YS�^��^C�NQݩGAg@�NQ�jq�(H@�ʩ���@=5�mT�@����j��$6��Sl�
�������'u|�      �   �  x���ɍ�0E�f�@\e�E���_�P��xZ_>�HQ\�7�Mq����ǟ�����ͥ8�����*��!�CB|7S�=���y+n��C^�<Y��7�!�}�W'N�. )_���ɑR��X+�����KϿP�Hx�k�@�f���9y�S ���[����� �������I�O�/�'���/�~���E���|Y�v�C���+�T���%�{��<��?;��,=��l� e�������#U��] �>@V av~��y�Ƙ�d��Bį��3�D�|�i�ǘ��w��"�r��ڿ���`��u��w
�ˤ�����O�>�1�5��)@��f�9'�?X�>z��xu�ڿG�RB$@�-w��j��PLPt��Q���&_K�J_������ x��      �   5  x�}�[� E�;��Za0	a-��:j㉔��J�u�+�	�!����~��K�O鳎Yd��-�LPה���D����sAEA�C
f�~���ڐ�炜ͦ�=����Z̞��6�޵`�@��ڔ�|�9P��A��E%�)�=OU�82{������<̈́Ξ:��%ܩ}JJx1s@곧�s��1Kj�b�����sT�c*3��s�4u�����|Κ�z1�����ǎ�>a��;)T�1K
i1P�ƔT��<$�a�.��ei�x�>�f��*]�*��5{
i1O<h�e��`.�m0c�t0��dƶ7.�`Z��!��B�3UB��vJZ $��D��;3�@�5�t0�r�6:�\@emy��yH�fLo�`�4L�jއ`����>3U��q�1��Fއ`�qT���!�	��5KJz1?($����NRO�� �U��q����'�\ e5c�;����̫e�;̧�B�{U��Uʂ�/P0@z�׌`>Kp̘�%�y�pj�1�\@9�|��8�XS���RH���s����̧�:��A�C�*��(yX�B}�Ї}�'	������Kf��}�xW�>���C��k�~��!Ѵڡ��.���5��@��&��c�f.H�^�mEo�ԇe�F�f.H}0c�G�f&��(�������N︛� �������|��J����\�fɌin&�V�,-cKz���GzO�� Ƿ��_�2*4��}A��p�ן�y���l��	���������C@p�n3悂�������i}0T��k���J�Ø�`.`-�4��P�a�N�s��x�҃�eAj�b�a��z�y}0�p�@R�s,�i����S���m̳t���C��u��=ti}�h����b�ZI�d������`�t���R��q+��<�4�a���CZ�el�����
��!�oY�h���\@!�O �����si��8�� ��26�EiZ�QA��͒�>H=��1��=uZ��*ԇ
�ZcZ�P���+߃�����Q��\@���!p3P�x"��{4�ߘ���}0�����|�"h?�      �      x������ � �      �   S  x�}���!�K����$v� ������6�+f�î�W�>�KE�%���S}�1E3Vt4�X���p�Ռ���Q�u�w�Ǳ'c�3�S���a�r���t�k�)=cp�;�8
g����N_���%��bU���1�̹��{VL�M5q��y��~��tT�=�Mq�{v�a�u�gv�a��v�g��R�MA��a�l��џ`�[�'=��S��~ɾ�`phd�18,��y��w�1g1����I��������ނ!;�>��{�f����-�>8�=�u]s�w��u08�}�aIr-ȵ���܏�-�.��H�g|���Ot�����o)�q�JY      �   �  x����� ���*�@2 �6�
�Y͍���=~� ��<
~G�ǟ�n?�,�G-�ދ�z��q�:��Xݦ��m�B^�Z�P���C��	�E�L�����r�v�֌tS��H��5l�6%fᡴ�5l�6�:{�޶j]m��Ji�p�mq�Ǣ�&gp�M�X�
�g�ܫ�V(�jAУ 5���R�&�td�U
%-��{���;��<��W��7
�i���yS�UO{&J�q��:s����x��T���jk�V*����;V��P(�/tn��^��N�v�ku�R��$5{(��:V�)��G��ԑl�J�BzeƠ��*{��^;R�[�P���fHe��SUJ�b9���:Y�ުRHO�����S�P���Wv\-�J��nV�#��r؉�5�Ml���{!�/�R��G ��
�zg^�Tk�$��c����AQ��)���A�V]l�g���=(��=�"�J�Rm5�ɱ��{P�:i�h�Gl�<8wa�#�B��y5놛�{Udn���K��&#xP�o���8����w��"�zbj��2�^��T����㆞E�"w3w�(��U��:l�U
)���1���*u�fƄf�V*Ҟ�p��E�����;�$�3�T�J�"J%�|��&�[�G���.�0�v\�11b�a�������j�RC��;$�;|���=�}�y!Lt��D='����l�L�O���L��z��)���]6G(�f�V@���
%I�ؖ�Kq\T(l�����M��^I����:��M���>P��_Jb��Ҥ�R�#\.�z�)%4 I_x��{����U���ߏ��f��`qJ�p_���Ʊ3����̩��c#����U
��J[dT("�a�+�U���J�v�I�R�����wű2������
��LM���>����eyP��R/k�W�b�%t�m�^;)�M:�m��5�.�4�C��lU)|0^��ʯ'��B9r�x��R(��F��˄R���|�      �      x������ � �      �      x��\ˎ�:�]�~�V�iT]QoyG�J[i���Qy�Q�z7=��?0AR�)���2ţ��"FQ��yz^�3��_�3�T}-�M8��n�Ȫ�r��)��q�C�Q�#�~�e��S���B�6���F������?���������ҟ��;��	D;��ý��.���D�?^�-��$����M
�;�|�&��$�m����{���ū�����MJ^n�]����{Jc᳌U���Lc^{y�Sj����'��W�h�g��>΁
򤬭�G�$���̒A��ŀE���ܘL�}�4�u�~�2��l��m��)�8��)!��qj����&	�L�x�����`�.��Զ���|�MZ�7�8����(��1�����[v�A\��3�0L
�L9��AFpU��K���)���<=S��ʆ��������X�{fJ����>1�T0��1{��	�i�؃���g�����a�b�T�(�Y\�s��R��$
�:�������UJ{Hq�٫�Tz� �e�+.�l��1x�M���_C�c��Q�m:�	C�J�l�clu@}�������a`�x�VE@��܀-PR�"��x�l|Еƪ��q�Xz��0��H��*f����u���w�);��ٶe���n�N�S�i��s���,F��Vj����x?�(ʐćƣ��A)��֌�S��s[m���h��!�;X���ժ��s�{�^�t�XY1$#�'���<9��鞒ʸ��M����lIj���O���<]ؤU�/'~u��t����)�ř�ns�*�,���wT����w��-��r�Pq� �iq)�������7S�O�D$߹��-�8/,���EܨG�o�Tk����N� ܡC�Q��F��x��d�[gj�P�ܒ�ڐ�S��,����<KG/��4�G׍��2.}ߌ�t� ���С����N�����Ǚ�^�S#����m�,��@\WR)�U���P7�k��>��pD�q>f�+J�V��u��E�!���N�B1!�0���������R�����ק��Vk`'G���r)��٪����ȔpG���֐A�`04}sc���VزQ��R`�Q�.�Ł���wMm�%>ō��X�;H.%�K_�GKgn���:��v�H���PK��8�H7ڻL�]���b�z!�N� �pt���o���㈶�#-��l{�#e_��+�-7<�2E�յZذ��ɥ � =��\i2�?��Me|��p+	1[�e��ʦ�tg浗3��osҨ�1g�ծu{W���g��uR�B7��̰�/A�L���~�߳`1��L�t�cpJf��ص��^cfP��6�^�Rv[���7�5���Ź�B��}d����Ek*2�+�S�P$u�\�ى�޸#��0t��둒^Y�~Fe���]����;L%�K���f~��%@�̤���i-��������	�o���~�Ǒ�Pf�~H61[�
��k��XZ�z�z}5ϻ���{}�
�!�NQ�����|�?����ذ���K��O�J�`�P��|�k'F5��Qٴ���{��+�DG�p��I��o5���w���L5�g�t�Ė<<U�(y�\3.���N���O�<=F�X��ss�3�$����!O���=5�`�ċ���+��US����(�Ax"U=e�9�V�5C~�9
#��cX��$}��f�&���*����IE?���:�	��ĩ��Q|*�"�c��N~@��4��)K4�b�m�6��\�j�5Ǚ[
�Pen8)���h�U�r.�-�M�x߫B\��\��9S�����-�nh��#�.s_���-��A����㉝4�w�bs�s
�':UIe�S�?eU7R�H�^�K�ڳ�\�	ù�ȕ,B�-�N��<]�쭱�E</���+]	mX�p0���s��J��E�{r�34���V0$����iy]2E��7U6j�N��rv��_���I�4L&k����Y�s��mBQ���
2���`w��~y"��i�#K6��:��T�=~��f��&��G��0qF���z�Oq^����m-�T�P�9����5W^M&{7b�08[jDd��P���.4���8�*eD2ԵC��1rJGTfJ� 7�b���`�8&,y��ؐ<46�=Q޽C�XS̊}&'�2��~��j{�RXg�0�y��.u�mp�o�a������St��"6C�d���|�i��2e��&�R6WO.�(�|q��q���`; �`t�0$�lr�+l�8I��!��l��A״!�9�'�A����E��/9� �p�p�M� >���<�g���%\KWa*I6��L٤Z����2��J�Kˤsy������v3��B�����0d��ߓ�>��_��I�N��8`��EV�&[֡�6cso���r{�~�᠔1����&�>�����FH�c�cP���Iē'�Qd%��*��mk�*�L�>3`�K�#r��Lϑ�r�/�nxu�_�e/g-��)�U#���d��4��Eo�ᛆ�)��u+��y��$^�0�S��BȍԽ>��V��ԽW��w���#Rć�F�P��m�[�lVXw��7�.aߋ�60c/a���/����K3܃�44w���K�+�b�����^]/cQ�7$�f��f�t�
CޔU��O_�ͮ�ۘ���
;�XaȖ�k�_���˫�b��܀��s5�;��A����(���Uf���tM�Ŏ�����
:`�����B�F������O�1s��5����"��6F���f+���J�m���-+�Ԛ�yI�y:��z���vڝ�����-+��sKLz[vzE�����̑Er�T��{٭��c�F��a�����0d�l�$WO�J���o��3�)���z���Zb��@GN��R����@��	�vXW6kBW涭.�qg�VP�׽tQl�^F�ϕ`g�8���&�҇>`G	�s/WW9�1Ӿy�=D��%�M���G�hU�� L�k~��6Ls�i"���b�R�l�v�x���n�����j���jU{|���)(�m��m6p�nxe/aX�a}Ǭ~6ׇ�C�y�y�Ŷe�j�^�ܞݙ�n��rI��)� ��J�6��a-=��6��F|��C!��!��7=��96�dCe��Uƈ�3���%nZ�m�1#a1qh1�L	��?����,I55��c��S�����u�(�� �0d�YKګe(h\p$H�ȱM$�p�J��~�����/��U�(�)���"�����$0_�0���ms�D�ߦa2�͢��`C�X�q�����ߵ~�a{�b��e�߇�j���y�v��«i�qd���)��1��i����؄��>v���h�/Y�I>H�8��A� a�	�ǋ���2C�7#�˛�B��!o�E><�ۼ�9��3�T4�S���`y�OY�IÐ2��Re0'���ݦ�Z�Z�AE��ZK4C�!�ҕ��`���Y��w��_��;ҷ�&����?^�ȶ-ӡ�����~V̀/�4X�����142��;ļj.q�Z�ɍ��У��yC�x���+�Kq�K��.�@T����y�_�_�?s:6NŻ����;}� ;��Z��7�q�a>�G��3ҍ266������J�� �E���`�BÐ3�����f/�Ƽ�r8g�a�[��T�P0�Z��Ⴊ�=��\	�>gD.��1x��p�)�Z�C�K6�k����K���6#�0f���ڹ�‽�v�jg��Z�i(�;�[��n��b�7ql	-'p������������qZ*j2���Fh�����mb�Ml^���Z��B�S�/6А/PD�a%��.�ë���'o��&4h2�si�U���][ހ~ʔB}@�`DI��,�.�mGL �];�#rRsy����I;< �����!+��yS��N�Y�$�����: %��v��ﶿc�����`�2�@��$�{��؇�~FĀ����!I�^��m�C�p��ol�ue��=�Ҭ%���vwp��.�����R0@�z�il��/��>���l�r �  d��q�^f<��&�#
)冢��y��Kn���=����<���)B��|�ÝGs�'-0zx��i�ҾP,�#�H��Z�:V��o������&�P"<�˯���,�xw*�	ê�\��^����ͪ� �]`��X.��{��m-��:�g��l�#�rp:�C�L�_�!��c=�#
���:M�X J��QU�M�2vh.O��+���CV�-���V�c����8���/����W�c)V݋��%>��%��ՄM$Fu}s��㽯L�xwt�<SK����0��qL�����zЗ���;�f-g��U}Pe�� �0�:9S;P�����}2|Zb��RrC[z�l�vWy�`��T��M2�l����Ϸ/�^�d��Ǆ!O9�?���ۃ��q��f�Lz�\�=��~G�wKL�ɔm���C�I.0��V�u��p�
�L:��qX�Lf�]}�]��\�l���C�.7n6:r����u"W�l��5�� om���a��U-9n[���V���rMڰW�&w�Xn�cPM�����דE�[y��#��ٲ2����;�N*M���`�q��'�����;\V�֕�d��jk�$��b��R7F���!Y��*�9�ឍx&�1����4υ4�56���X���ykh�S������tP�5�H@�Y[^�sY`�Z"�����<k�W�t_55a��S���Չ��ǳ����%?�0c״�l��[8��R0�I7崭�4!/k�/z0tc!{t����6��e���vN��	뛜ʿLr?�^�v�Ph6���'^���s̯�%�A��.���:�K:O���ڰt���96?���=��J�Lm屆^;V�lOy2�ߝ;����[��&H�=w%?�ڼs,�>�8�f֣�q�������K{�G      �   y  x��ZY�!�Μ"�'l0�Yr�s�(��H�J��bx\M���������M�'ՙ�,#��5d����uJ1zQ�2���6���X%u_~\Q�Q�2�h�~�[��-"��)�TR7��Cl��q����
���-iR�-�H�5��*���v�i�5,�4["=m��/�gr2S�����x�.&[2e˜����[fc˙��ڔ�bl��������t��0զG1��]��D��3�Lq����|��$����H�ɁH6�|#��0I�HB�Yhr����0Le(\�1�-f8[����3W�&a���1�rLm�2c��S�)#+ϥS�~#�J�aK���h�0LE�drH��0��h���Wô��X�~��0-�9Jgia����J����a�N�*��UXBL�	|�f� �ox�fEr���vlwG�)A	�+��vM���[(+��v�f�;��	�+?+�sp��N!��g���&�Ge�`k�q�4�I��w*_���u��r:���	謐�'�U8s��|�҇j"�Dg�=���yj=��Fr��	���x�)�6H�N ��Ïw f#�BA'��5bFm஺�U@�Hh����	`/�و�T�0(����@�sEТ,�MFA��撠g���T�@j�*jĊf�{4?� �B����sCӹ����8hh44U��q��t���~ӷg`���	�æ(ߟb�x~�o�0����p��vA�g��ۭ �8�fck�[$��\<`��gz�4�uz�ec*bD��@�o�2-���1�;���|�������j�?��ñFcz�6�ta�y{���?Fl�1K�����M�Yk���B�$�d�q��նe�-]zH�p@4Y�ЮW�eN3������f�@���0-y�1�m��/��M;�}k�0m枥�cj9P�������s��k+�vQ-~�cLy3���\l�פmhU2��lc*�q�H@�QzT%̛R~�^��ܲ`�4��bC��9�"B�PpE�h�;Ĕ:��Z�P������ׂ��kk��:x�]���|Ӄ��n���q�������>�R�1	Ym�H"L����~��٘����o4N6�i�1���9���� K��S�8��d�����{o�&�ɩ��͡�^���
��f3'��	��3Jq�1�`/���(k���m�3�ozF<F��R����Ҡ�>���sE݈���9��\PPҀ�F�u��z�-�-��F���zA�	��������%R���<Њ2�8�;x3���l���W����0]L��3�o��Іi�����="�ς�~����*Z;����R��o�x�A��k���?���1�iף��(\��0�P�'Y�l�p`��^��o ���      �      x������ � �      �   �   x���1�@��7�i��ݍ��ĕ��D���/�#1��}/iN}�fg�mzvu;�#�,��8Vr*!˅����	�g�6�W���n��zo�7�����-�1�0Y:%�6��F^��q�܈��4T
e�2���U��o�/>;      �   �  x�}��q�6E�WU|$���H�
���V�8�?]�$A� �U^u�껶������S�9����!y[��#P�m���]Ξ<|�m�W{GK=���Gޖ����~�������~�
���:^�Ky����f�P�YaH.ok��6 0y+����h��R�0Y�~���uj�2a���WV?�@�" ڵ�o�ᲈ�}�T`�\1��V���"�<���
�pY��~jz�0YĄQi]h�&�X�c�uy+E[dSS��]1oM{�ET ���E��2!�:�]�E@�����"��G�$��Tȇ�"��,Ҽ�qT.����T����m�죰��>���Lv��"*��nD˫ەls�Et���A>L1`�:��"�W�5Q&��.�8�ޕ�Q<LA1�V�Z�����A��"yT���" �e�
粈���C�e��f�y�Gb�s�e��2&�;�8x�����8��dVwbepYĂ�PѠx����]�Ae��y<qw%.���>*��e-�J�9貈=���	�9貈|t\]�E@F�ԙ�"��L��\Q�P�A~�,2J&�%.���XK\сPB>L1�(��\�#1�/qYtK��Y��"&���c^>(�w��ݾS̹{W���P}�N�w�Է,"��2��x�"ZX��)��EĘ���5��-���ej1�,"��L5_�nY����&�G��1�h�o�e�A�0y+G���T4⾺e1�/S�%�,�b>r��"tr�����ef~��-��T3�Q�,�b>s��eG8�̴���EL$R�޲�xrʤKu���7�4�e�D�x�,����'b�l&8koY�L�^>���E�C��p֖+k'ļ(�ȇ�"bm7S��+����,�y�Quբ��|��e��2��q�h�c��3�>s{�*ل���s3�+�-��x��˄�"V�~T��j�Q�^�*��" �ON�ETUɽ�-�h��L�V.���	GU�QA<j��W�,b�yT��.���eJo��,�b]�-�����:�v���^�.�]�EP����J�vK����V&�h@x�,B9ز���e|L��.����<;��d�C}I�x��e��_nYD��\��jp�" ?W�vU�
}����sY�G+���,�C���z�" ?d��������<wYD7��D;�e{ȅ}��p2�̛ϼQ{~u�e��ߐoYđ+�L���EP;ǣ_��& L�j���,z��;�-����=zS<v���~&&���x��A��,”8��-��x�G@$�vbz��^�.o5���d�.�(_�j��5e�#�����P��=���i�����"z&F���E �x�d;���#�8�H�?y��e}�Ɇ��GQ�h�xd)�g\����5��\�q�
��":�*��=���k�#����|�F��Gq��� YĄ�/�Ǻ��Ǌ��#o�x�y�t�?��D����E�<���g��E�<�����#���Ŏ�E �-��E�@�Y���>�����Q�x>����.��|�����S���0���@�1-���z�Y_�f��4�!���lࣇ�1�4��J>�%s���D�HX-�;���W?�e�<^���<����_�#�?~�b�B����x����@�̧�8�b����C�N\�FkeI%�A<���ㇰ��HT���*� �=�'�v�=��F岈#��}]Ɲ貈	D�/Y�z�M=�L����e%��%.�H����#�2�,"�����dZ�LX]�E�G/�e�,b����Z���Jʏ�f��p+�©�,�C�%�h9�#vK�d�pWg�tgb`�rYĞg>�^��5Ehu{$(����Z@��_/?�NΦ�~��ob�;g�&-n9����ڻ �Ce�Zl��}�ɘi��a)�YD��G1�B~g�#���J�?f��G�uc1������ۿo��#�̗      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x�-�[��D��rc��B�ྜ���&1�Q��"�r���S���H�ęx'>�+q'�'���hW�+��vE��]Ѯhw�;��vG��������xN��D�+q���%Vb�'��y���v��������73�\�����\�}O��?C���p�2l�,%K�R��,E^�E^�E>�� �>���W�|�7y�7y�z��t-K�7�$��|�MW��|�O����]�&��e��R����ܚ��.�]���!��E���"_�|�/�E��7�
+%V�\��Z�M�ɕ^��R^��J�6���}~oɏ������E)�8��P�C58��P�C58�\)�8��P�C)�8��PuC-�4<�PR��)�(������v(����e�qX��=��VsX�a5���!���w��8���M�%\�\�{�3�_����3�����4���O8��:/�:���<67�1N8�⯱��3���ז��I[ö]��6䥴�h7֖�UIs����-4[h��l��B[ʶ��'X���^RfcȾ�m!�B��������szβ1d_hu�ݡ��]9v�߭�}M�<[}ͯ�|Ms~��+��Ζ�L�1�d(��L�2�d(S	N%8��T�S	N%8��T�ӲN�2�d(��mq��-q��M����ϯ;o�mm�hF���zfJ>g�Y9��L�6܆�L�w����%�#�m�w����<�<ԏ{x\�!_�|��O��K���I�$[�-ɶd[�-ٖl˲eٲlY�,[�2�������������R�R�R�I=��e�6L�mx˰��,%K�R��,�a�,�d���N�e�2dQ<s�2dQms�2d��,-K�Ҳ�,^�lYZ�N�����9�,S��B���	�jN�뤽N�뤼:֑�3MgzΘ:�4��ܴ�'���øҚ���stw6��8U�4-h�>h�ϴ��>�|��L��3�g�δ��:�t��L˙�3g�M��nS����j�45����ѝK�,骋d%�D�^����������V���0ͧ�S���x�;���NM��S˩��p�7���Mͦ^S����h�3���LM�o�|����w|�N|O�-鉕8;q&މ�������>�>�>�>�>�>�>Q��VT;�����&���+��������;1���]�83�V�bw����&ҿL���t�B�;��y掴�-A��󴝧mw�g;��;�.��y,��1<~����u�9���_��ϱ8�ĕ��'�5�D3�:s�:9��u��9��pm��5���0e��1���]�l-����U�
L)�/ffl$p�-�� �V�
P�)�	����;I�	[@d,p�u� E��:�� +�g�|9=��S�g�R���R~���>�Ri�|����R;K[��Oǣ�ilm���5�ՀLi��3���=�6bl��_�Q��F�-�~��A>����z0䉥U,�bf3��Y��*fV1���U̬bf3��Y��*fV1���U̬bf3+��p�BY cA,��X�/����IA��HA��HA�IA��HA��b���X�A���~�$���8M�Ⱦ��2��.��!���83S&!-���`�Yb!,�����W�
Z!+`�����Dl���'���R�C�����$K������t��}�~v�ή���;;yg'������f�7;���͎ov|����RǕ:��C:���|:�χhl`��4�� �^�p�-�� �V�
P�) � xN�	0�%�� 8F��! � �>�!���=�� �p��5�� `�p-�� �P�	0%�� @�� �l �0�� ���
���<@�*}C�o������7T��J�P�*}C�o����f�O�������u]�&�j�      �   �   x���A
� ���x�\�23	��P&�m\�#x��.
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x����j�@ ���S�"�q�m��ւPJ�$��}��Vo�v9:����,�[�M��[ޭ�K��ݗC���F�(�1F/��>L�c v��ټW��-濎��=Z�wk��H9rFeC��ppe}��n�+g�N��osxl��Ʌ��z�������y���1k�d��� � OݼyK�{^<^�SŤO��/�� B?��S��t"���{�Ƕ��(�s�	Z�� �s�=�=�f�)R�5�Aֹ�/�1fTD�1����XrzzcC.�er4Un�6uv)��cz�j��G������[��U)�U���U��)@d�1Lmט�u����i���٧E߷0ô�f�t��f{����#�:4���P���7�̖�V=`1*k<(G2����� ���q      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   c   x�34���tQ0Tpt��4��20 "NC�����X��H��P(mhD�ĸ��f)����0adlej�f����������1�Y@d����� mf�      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      �      x������ � �      �   g  x�}�I��0E��SpZ.`{-��$$b�z��?GdC�$ˋg5�l<-k���Ɩڔ�l��1cejj��v���C�,2�����[��2�"�ks��l�쌕�⌗a���k�Dc.�a�� �Э_�	I�C&��g37#�A(��rt[�~�%'�@&���[�d�T��M����8+jg��4�w��(A��*2Q"����@jnK�i���"�c&�+t��q��q��{�>���t�$	�D�{m��ܶ�Ⱥ`��,����-���/�'?�0S���[̔���O^8��S.R}��mLyM�c�Aڀ�ڮO��YcB�~��FPaL�G���Oļ�S.Pu���ml{�L���R�Bj
      �   �  x���˒����|Wу�&8�(�(�"X����~G��vU[�۲�w�&k��
�g�(�����������W��A� ���;;U�Γ�]�W�0��y��L0��)������4ӗ��n�G �
`+����΀:��F<�1��  �+����{��o�A@�h���f!D4�� ��hȯ(���$HW����oLA��M��%��z����_V�Eq�����5�BF.���G������]�▲��-�t�j7��x��rhF<�6���;}m�/�o]d�u��,����hH"<ᡄ�-y�� Cޞ������ qTw45Iy2�4�
P�h�5�ڜ$	#-������jl� ;Pg�Nv�ɡ�z�9QV��ƨ���E�u�-�޹�	(M1�'*@�C9�,�\~*9Y5�zV+r��:�S��G�s����Yt�Ӊ�HXV��D]�T{�;"U'�_3є���pl�ɑƍ%���ܙ��)_�?�qmӝ��j�o42�R3�j�-ѡe����N�^����
���W@��ѓ�����n��'�ؑce͞��h�W�C7t��{=o{lw�m��#pܟ&�N�A��<,���S��x8"W &��I�j8R_)"?��t�LY"�Qf�W�Wt���2�W�ڵ![-��Ǟ����a�S�(C%L� �j�L�%L����~K��I`���7X�:�b���톗t���D��,���X�"n,;G��[�cc��u�B���
�US��T{��v/����G�84[y��>R�g4'��Sz6�u���W���*jMw�мK��|}ݴz|li�3�'��&[gA���)��p��Ib��t;�s�}��[(g��b��,^T����jsl&A��~(�C�������;q��=5��3��,]��j��� �����ZC-�>�.��=T��Ҝ)ێ�l�l%�e�X?�ǃc�XI�I��&��T�lN�d�b�:����Z�	���gL5(��a���y�|M���.Wmg��Xf�:@�.[ݝ�ǷR��dV�]���ޕx#�_����x�0�y"�z�%��4i���򰜉�R���3M.��j��n�4���`'�3U���v�Ų��J�q
��(�]�� !5T�W'��o��=�#���7s�U�9]���zo=H�f��tr���R��7"d}s�^�z	�P��[�C+Z�PA�g��P��%� \ �r�%?�a�x]��m��'p��"MŲ<� ٴ�������Z*����#���\��&����<�#7�8Ju�h���ou��[����JbS�uT�U'��ڦ*�����Ҧh6�^OZ���$�����+I趖Ho�uHOg�Hߺ=�H�ˡ�����ؚ�x0lMH��&,��V/I8�0��>v�V�F�]ʺ#��R��Ȭ?r��4����ńb�[�#�c5�����0�3ہ�y�N��j9�#�5�I8Y��Ȋ�qP�A�G�H�1ߛ��V,>�q�a�"v;:�[���)&�̱�KMvjL00��Ejح����_�#mWe�ۓ�����f����ۅ�$��!��4oL����b	�+jy�Gof���T#k�C�7b����!�)�ɦ�� ���0]r�K�0ڜ�֥�T�C�:�~,|h�d��]��?ڡEں�`��"�=�3%��v��x"��x��t�k�nǃ�j�8gm��
���皞�nJ�#�t�ߏ��Ŕ��>ab)����@��#�S9jװk���	[����6��խ��[@ը��s6U��/�zY�2}*ۤn�P����,E�������˾=jQ�w�[���*�g����Y1�'��ϲ�<ės��SO�&rh��݅�g҅sE�������.Ux$�<A�`����ϟ�X��R      �     x���A��0�ӯ��l��-��w��j��+�T�,DA��/�]r���J�Rc�/�g��bWū�Rga$}�%c���=?�<��ҹ���e�$=�����l�C�����X�]o�2��t+1ƐJ�}�1��t�?'x1d#�Q��}2$�sZ�!���3}1d��gH�����Őĥ�T����9����a�>��`�����sc/���Թ���2�����?cq9+9ׂ1������M�ʦ�G�`�&�jY�8cx� �� �      �      x������ � �      �   5  x�u�ˍ�0�di ��Gb[A��cig� 6	�4�Ȃ��D�H`��x�|~{��� ���q��`�������S⊡8��=����#XbP�P��^.?*�����rO�b�˙���cЊ���=�Ce��zB_��0��|�ތ�Cp�=�qUU���,�:���������an���Y\C]�}^4��w2���E9�Ww�6������y2��z�ՌG�0K�}^4��:��a�v�y�u���0K����y���0K���'�� ~��Y�U�/�o�:��Y�%��Ǌa�vi�>��-�V_?�����I      �      x������ � �      �      x������ � �      �     x���;n�@��Z�6@�>��.p� M� H�6+����4�A�4�[U�+q�i~
dݯ�^Db�4:�^�WY��/e�[ov�6�̮�^Nm�NE��߾��?��{�~[�X>oWȺ�<,u��a;mw�u;�'I��{���u�M�#�WnG�^�۾��<Y���t<�azydbDā8	 ADH��!��Dd2����,���Ҽ�s�:L�D����
��J�e�k%�e?�T��k�����~YA�Z)�� }��_VоVگ*����~YA��оٻ�,O��ge�^+hߌ��}s���-�
ڷd*h�ZM�K%?PоL���TоMD�ѾSA�~hy,��-��Iis�Y٦�
�wc*hߝ��}���=�
���TоL���TоOD%�~SA�����^M<(�鵂�Ø
�g*h?���^�ڏd*h?SA�12TQIT��TPe>Tiӻb�Y�y}ؽ�^+�2����t��*3�
��d*�2S�?rL���T�~ND���&D���v���&tz     