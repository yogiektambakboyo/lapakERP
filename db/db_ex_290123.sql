PGDMP             	             {            ex_template %   12.12 (Ubuntu 12.12-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
       public          postgres    false    206    6            �           0    0    company_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.company_id_seq OWNED BY public.company.id;
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
       public          postgres    false    6    212            �           0    0    failed_jobs_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;
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
       public          postgres    false    6    270                        0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
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
       public          postgres    false    297    6                       0    0    sales_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;
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
       public          postgres    false    6    301                       0    0    sales_trip_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;
          public          postgres    false    300            *           1259    18748    sales_trip_id_seq    SEQUENCE     z   CREATE SEQUENCE public.sales_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.sales_trip_id_seq;
       public          postgres    false    6    299                       0    0    sales_trip_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;
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
       public          postgres    false    307    6                       0    0    sales_visit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;
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
       public         heap    postgres    false    6                       0    0 &   COLUMN setting_document_counter.period    COMMENT     U   COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';
          public          postgres    false    272                       1259    18330    setting_document_counter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.setting_document_counter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.setting_document_counter_id_seq;
       public          postgres    false    6    272                       0    0    setting_document_counter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;
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
       public          postgres    false    275    6                       0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
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
       public          postgres    false    6    278                       0    0    suppliers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;
          public          postgres    false    279            &           1259    18725    sv_login_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sv_login_session_id_seq;
       public          postgres    false    295    6            	           0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
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
       public          postgres    false    282    6            
           0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
          public          postgres    false    283                       1259    18384    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    6    280                       0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
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
       public          postgres    false    6    285                       0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
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
       public          postgres    false    6    287                       0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
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
       public          postgres    false    290    6                       0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
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
       public          postgres    false    303    302    303            B           2604    28176    customers_segment id    DEFAULT     |   ALTER TABLE ONLY public.customers_segment ALTER COLUMN id SET DEFAULT nextval('public.customers_segment_id_seq'::regclass);
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
       public          postgres    false    298    299    299            9           2604    18765    sales_trip_detail id    DEFAULT     |   ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);
 C   ALTER TABLE public.sales_trip_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    301    300    301            @           2604    27183    sales_visit id    DEFAULT     p   ALTER TABLE ONLY public.sales_visit ALTER COLUMN id SET DEFAULT nextval('public.sales_visit_id_seq'::regclass);
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
       public          postgres    false    291    290            p          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    202   p2      r          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    204   �2      �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   33      �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   z3      t          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    206   QI      v          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    208   �I      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    303   �K      �          0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    309   cL      x          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    210   �L      z          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    212   
M      |          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase) FROM stdin;
    public          postgres    false    214   'M      }          0    17984    invoice_master 
   TABLE DATA           W  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type) FROM stdin;
    public          postgres    false    215   �S                0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    217   -Z      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    295   �Z      �          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    219   �^      �          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    221   �c      �          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    222   �c      �          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    223   sd      �          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    224   �h      �          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    226   {l      �          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    227   �l      �          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    228   �m      �          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    230   z|      �          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    231   �      �          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    233   ��      �          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    235   �      �          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    236   f�      �          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    238   ��      �          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    240   !�      �          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    242   �      �          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    244   ǡ      �          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    245   ԧ      �          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    246   �      �          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    247   L�      �          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   ê      �          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    249   �      �          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    250   ��      �          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    252   ��      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    253   k�      �          0    18191    product_type 
   TABLE DATA           J   COPY public.product_type (id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    255   �      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    257   j�      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    260   ��      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    261   Ӿ      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    263   �      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    264   f�      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    266   ��      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    267   �      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    269   2�      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    270   �      �          0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    297   ��      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    299   ��      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    301   ��      �          0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    307   ��      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    272   ��      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    274   �      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    275   i�      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   ��      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    278   v�      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    258   �      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    280   '�      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    281   R�      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   ��      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    285   R�      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    287   `�      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    289   ��      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark) FROM stdin;
    public          postgres    false    290   ��                 0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 12, true);
          public          postgres    false    203                       0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 13, true);
          public          postgres    false    205                       0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 2, true);
          public          postgres    false    292                       0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    304                       0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    207                       0    0    customers_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.customers_id_seq', 32, true);
          public          postgres    false    209                       0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    302                       0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    308                       0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    211                       0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    213                       0    0    invoice_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.invoice_master_id_seq', 123, true);
          public          postgres    false    216                       0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    218                       0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    220                       0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    225                       0    0    period_price_sell_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 885, true);
          public          postgres    false    229                       0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 489, true);
          public          postgres    false    232                       0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    234                        0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    237            !           0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    239            "           0    0    product_brand_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_brand_id_seq', 9, true);
          public          postgres    false    241            #           0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 15, true);
          public          postgres    false    243            $           0    0    product_sku_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_sku_id_seq', 90, true);
          public          postgres    false    251            %           0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 24, true);
          public          postgres    false    254            &           0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    256            '           0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 24, true);
          public          postgres    false    259            (           0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 18, true);
          public          postgres    false    262            )           0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 31, true);
          public          postgres    false    265            *           0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    268            +           0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 11, true);
          public          postgres    false    271            ,           0    0    sales_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sales_id_seq', 1, true);
          public          postgres    false    296            -           0    0    sales_trip_detail_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 21, true);
          public          postgres    false    300            .           0    0    sales_trip_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sales_trip_id_seq', 4, true);
          public          postgres    false    298            /           0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 1, false);
          public          postgres    false    306            0           0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 39, true);
          public          postgres    false    273            1           0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 10, true);
          public          postgres    false    277            2           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 4, true);
          public          postgres    false    279            3           0    0    sv_login_session_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 71, true);
          public          postgres    false    294            4           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    283            5           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 57, true);
          public          postgres    false    284            6           0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 43, true);
          public          postgres    false    286            7           0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    288            8           0    0    voucher_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.voucher_id_seq', 10, true);
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
       public          postgres    false    202    204    3397            �           2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    215    214    3415            �           2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    280    215    3511            �           2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    208    215    3405            �           2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    231    221    3434            �           2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    270    222    3497            �           2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    223    3429    224            �           2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    224    3511    280            �           2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    208    224    3405            �           2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    236    3511    280            �           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    244    250    3461            �           2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    244    202    3397            �           2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    3511    280    244            �           2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    202    3397    246            �           2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    3461    250    246            �           2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    257    3461    250            �           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    260    3479    261            �           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    261    3511    280            �           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    3485    264    263            �           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    264    3511    280            �           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    267    3491    266            �           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    280    3511    267            �           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    208    3405    267            �           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    3434    269    231            �           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    269    3497    270            �           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    280    3511    289            p   V   x�3��putQu
q��J�I�S�J�N,*IT��W0�r8=8���t�t-�L̬L�LL�,�L9c�8�b���� �m<      r   M   x�3�4��T�Up*�K�N�S00�4202�50�50T0��21�21�3032�4���2��p��/J-V00"�!F��� �J�      �   7   x�3�4�?N###]C#]cK+CC+C�\F@FX%���1������� >��      �      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      t   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      v   �  x���ݎ�0��'O�`e�6��(%ِE��)lv�����;�T͏��j��8B:�gc���ô��t����A�&�*1:�)��cD�  G�xqdȭ4��Z'�R��#�0ݿu,۷P���m6��x^���]K�=�HpƵ�����	Z�����b �h(��9Wd��n���$JI���L�9��Haھ��9��8>1�b0��Ky� �P��f��=���2���J&b����WP�k(�D`,�^-� ��8[�̕n����F��+�S��U.�	�c͖��aⲼ���p���I��i!j5A���=�	^-�7�l�b+�W�M`�?Q���{�e���}�m!��!�ܫ�@hX��Eǵ��9Q�h��Wq7Pf��u���6ƫ�X�����+&���{���O�7�i���ŧ��s�w"�Ƒ�	��Ѫ��#Љ�@5)�� #.N�^��Ry�c�*/<��s}J���_��䇴Q��}����0�~���&      �   Y   x�M��	� C���J��t�N�o'��Ӫ
!!�E�_w���P�H�*Zb)	9S;7�X c{5;�	�8������Ƌ[d��@�      �      x������ � �      x   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      z      x������ � �      |   �  x���[o�Hǟ�O1_ �s����R��F��U_\�+�\�����9��lS��(���?�9�$�rO)��s���ä���U�*>�������~����4ty�%hc���z������'n��*ݽ��d�������v)�_��[z<9�0����T�ϡ��	5ܟ�['z��{2�ģ�<=Σ�`�Ff4"�ޓfP(��ݒL�������~��	C	ʅ���D��Y(Y�����t�W���r���V�az�D��y%V�Zk������4L���#,�T�+/ɻ��
aZ����a4��h�|�Bj�i1�'���k��k���_�DO���o��љD��ӈ<����2YD�IL�KfSP'�Ry�LܯQIB!�Bٺd���4Q�+uxA��lT<�0���3�q:$�a�^�d�>�җ�I�xI�8�%�"�������\��unp��'����*'Ȥ
h����=�^pFɁ<$���:P&�m����QT����̒�h"���C�l���t�r�;x����	�q ��&�f:ՇQ�a9�bB`�!�ԫ`@�� ��ݰ
*� �ay��HY� 2R|��GP�1p��-ڌ��\�ʶ5TcO��w��	ޖ�5p]`x� y�Ad�3^������F�
t���Hx��=�'Ϫ���	4|U���i�\u��4��y���a�F�LO�Z�3jo�&ܬ4�'Vi��̶�NKGp�v��Ti�~���Ч�IR �@�ۆR�8������4��)�S�I�Փ�Ja�ʑ��~"�o*��X/@Q(��.�jO]0�
�MI���<l�V��7�+�@�*�.�p�Cu1��)Z��$:0O�����,j������u�' x�B�o�L�P/T!�/=��fs p�q�Re#F�W���AvO�bN����=�q������8} ��(։���!h/{���ۦa�Q�P
i�3�࠭�/��_<�^F�]x�u�j�-@[�j�~���T D��Ň���j�(A[u��0E3�)��т?/>O�����y@K�9�q��R��Sؚ#M5���yM��a�Y�J(���LBM����m���Á�\M®k�2<�^^�G�i�x���	���R���19���ش��l�U�͒���*\�!�1��;�8kas;�:S3�J�h��N�ʹ���j�����eqɨ`�Q�Q�`��e@������b�˦�7��ʵ�f�}eO_Z�}w{�˃:a��^j��j�:�YT]TN?��#�l�H%R�/�fB��7*Ba�����U,x��]���h��I�5�(AȨ�ڃ6�d�X1I�|�Y=�WWh�v�'�%�N+`���9�$��u�k͉ӸזP��aj�S��2�����8T�Y�\wQ���Zz�LY$��ھ^�� ��W�G��+�J��+4f�m^��`�9ٵ4]�t�fd�,,l�����0d0��α��Ձ����� ��{Y����tA�M^e�@����%[���|��_�03.{ _�֪6���̅�Z͋@���Zzu��w��y3T�x��dS���.�d<���(�ǃ�����aם��2G{��p57J��r�ed�C�'�ef�"	�v���B���m7i���Mۅ�.bF�� �.b�@�=�1��8�;�'N��8��������C      }   V  x����nG���O�/ਫ�=w��b[
��H�8b\ �M�?U}>Ԭ��jz������Y���?����RH��G�-ށ���ܤ�`�fT�܈�����Ջ������ן����m�	��͎a ZI������m�F�1���?O�����WFq�-���S����Ի�>}��iiđ"�j���a�a��Qz����w	T{6��m��M����&h�m��X���$ȁR�`nQ��2-KL��(�(}����?9��M�(�t��x��Q�arَ����~=��NXT�P�S@'he,�x��oO�OT��?~����"�
��OQY��rB6ƐB��9(W{	��Ԯ���fy� .�i�5rzK~�oZ5��f�:A�5˱�u	�Vk�X�j&V�!x�t�RA��ž���T���Z�]��:E9j�R۶?�+h	D�1盋F����M���Tgltr�)�@�zJ�Y/-}�2�2��ĺ����f������h�8XQ�µ�� }���&�r��l{N�կ7;�#�	lFC݊�Vo>�hΑ�ռR��)���JK�x�j����Q@e6ZS*8Z+F�)� �"�@;lY~7~�����{��\1�Ȟ�=���~U�UءM*ctB�,�тVt؞zj�nt�ɛ���g��قzDTZC�6��o:�b�D�Nu�XfZh7��G��T�Y���5Ԏ�P���+y��y��a�e�J�!�]�bBГB�_R"4u�<�J�&�a�sJ�?�ΪaR���덨F��SJ}}�.�<?}���*hV���X�`�x{�P�9>x'�;���(M��$͇�w�x��Ҳ���PJ>x���EUx�)CX6��#�	��r�k�n�43�|�m���=w۾#~�P��1�ù��'Q���
�*��ݩF�DD}s��99�g�	-�q�!��^����.qu��e�MKA7�����+XJ�g3��)*�0%\J�"��������Q��&Y1����j0�TI�JS�׋��u�ռ��b*4��Y�jǖp)Q��z���ǹ�i�(z���z��n��2�u���F�u	G{(�Mh���$�}"��X�S�a3I��3�uw����#Ȝ�z1O�b�¾�T��}��Q��4u�������ǹ�@`+@֣���K�==~�|~*�MJ`�U�5�����>ڊ� @��2}����O�%6�_�3g)9z�<r�ʢ�T�������t~~����R���¦Tu�	�i����p��)�O���Cl�o_?���Ye/,�N9��k��f�~�錦�OXW����I?>!|(?��.�c1Հ�߰��0���2&GrĤ����t�z2Q>��/N���p�AV9�ES:��e�&au��#�r۫�j��;N�Q9�1e^��'�qS?�@�9�)�I(3H��V�|>�gM���Rl��}�"0,��h�U=�z3�$9pp�����lJ>����'�|�1���i�}�?N&�&õx�R��M�X�
ͩ��\���vK����RZrviCڧwQ|_����]��L/&�7��{���%�w�N�		�UI�lB-��Q��qU��Kv=P�KI̓Ӣ���i\UP��֖����ｇ~�����?b]�         �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �     x���Kn7���)t���m��Y&� �ߥ8�= ?����ɞ�&%���!����������>���_�8���3��a���h4����f���tA��P�è���jvC=�zB�z����wt<�� �.,2Z�蠧�@��Z�-"�Z(y�tV�mu'��������ᔍ���3IP�Yc� +C2��|�Mք�XWv�=�Т�1@��(��l��������'�p��׎�����K����o낭C �"�9c+{v��v	�{�J�m[WM�u��6+���O1���ZY���M�}p	k^Y���o4��D�&�����{UIT������9^��QH�W����3�`u�)��/���K�<Y�ùK���SW��.������]z��UI�����U(�GJ7���6w�9ԢɸX1�Վ���+EO���Ū:mY��c
��*�)_��S��b|������rce{ߓ���B�8��l�NV���r�Yٚ��"��<�z��IS_Xez=�'�|���X��ʢ���Ҧ����G�9
�@h�+s����9
�(3Xz5VV\X=������]Ah��3f7g��#���X��=Y����f���h��8�����g֕�>Ǵ:�dDг7[t���}�D
V���F�EW�^mug���i�}]��;�<#%��l�UNx��t�RU���� 4ۺd�#��󺋬�Ҽ�Ks���括�u?F9%���s��EVe�I}�ؙc�`���ʎ���<3R�9����
�l۫:G��#W�EU�l�@�6�:(���7v_�dS�����XY,>�{��g�rEm�y�NQ��J�F�X�*�dͻ%�E�|Q��>|��Vut���dn��.�� -�Zy^�}~N֧Gfa޲��Xމ�;;����k�����e�WE'%I��/�������$�KTX,m��	
A��}>ce��:���	3���F���Gd&�c����;g�Ύ�t�g\���5eǢM�2��Z���֙'s+�JҒWt��>���c\���Z�
�gx      �   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      �      x������ � �      �   j   x�m�1
�@D��9��M���Xڥt;A�����c���a{���>��e_�ZUA�̼"�1O�E|�q�c�/��c�Gx��I��Ь.3���c���:*sS��~���      �   h  x����n�H��+OQ/�L-.c|W&�1�LkFs�X8v�"u޾�LL��2�&I����<Z��#����Ð�!�(�w�Es���;)i�����?B6��aZd{���-���l���d�KV)z�v{<H�yk�n�wu���-+�?D���4��\��E�v��Hؠuj��C��o���%٤���d;���D��/�8���<QK�:'.ڢӶ�}�@����5�4Yd�
���Fk��\��L4F��%�AUI}ђqb��;�I�a�vGݦ���&ۍ)��C����9�����$�2�cͧ���y4���$�Y(�$�` ��G�F1r�XG'm����G���h0�X�0࡜��ܤ�cJ|+���o�2罒�rO�J�#h����C�)���P�{r��y�̧�l����t���0�b.&������?��a�wؓ�]~�����uH�a$����$v��t�ns]�R	�+V�Vǰ*;<��2<松JiO�	�:'<�f�I�g�gh��'E��4v�V)$��/ɄO`�y8/S4Ef,�,Ǥg7\��3��+&�"�L�������)�����������2��N���|�mM�xJyH'c�x0��ぶ�	 ��x�3芌U������f��	��>�@@�+������6��s�|c��^ga܏{v0j$�G�m�ڀ�<I��ӟe^�>l�������"�����s�;_�E��٦��މ��ܔ;�O����q(&���[��I�����e<{�4�̇���L�1�b���=��;��i�r��6^�P�s�Mpw�lW)f�"[���Q}汊�0U:k_"���Oh���(˳D%���U���M�d�"`5�0)��v[���w����Yھ��\�)���`I�u�*q�n����e��y�؊@�6���2K<LU:�����bS?�����e�( ��]��\��{M�R#��h�`����K�e��UG'&����v@۝�i�{<3m�������5es���(z���=^�������x���9d�䚞E^�4�����wf��,>f��<q���QiR�o�@��� گ-�' )ӄq�'4dȿ<==���      �   �  x����N1�����H53>�{E�jB↊H�U��:��`���팿�������?o� �& �?�OO*�֠��lܠ��y E-���\����[u���G�X*S.��s;O��^�M��iH�aD���?���׃�1�?����0�V��?�?��B��t�����ȟ?B�^�	<�	:��o�
2N-r�S��7�ר\�[Fs]����%ֶҚ ��^�[<Oe3�#}��[�f\r=���N����s\x�����P9O��TVى�t���g%N��Wm����Էˋf�ܼ^���c�*<H,��R#��Y#�%���;�W�pl�h��?cMa[o�y0"��_�z440�:v��n�+��en���������%/�Zn���ٙ2Z����^��^�|N�3g�t�i��g�RR�M9�ф'���%�O7�y��vR?��u甩u8B:Y�^4��!MɈ�?�Y1'覤*\o�9^'j�Ni�5�x�>��kk�ֵ��,��'(,4� ���ß.f���N�qe���}��r|;N]�<de�cխ��7,�B��8?oa��ΓQ��dJ����Y��:�A>l~lTp�(4�B�f��\iJ�-�%� ��-!�@���:~��b���:�n�����0"sV��)�h�~ȇ� �$삙pi�!�W�Xukn���W��P��.�@��c�tj��C���]Q��)�7M)VM�	ٵj'ŵ��-\��PUV��n�Wd�1H�/1V�_��)���_�Ϊ'�Ej���B�Yq��ʊce�1��+oe}rɯ6L�O�����E�a��k7���Y�S�o��X}k��~s�q:��h�tm��/��-&_�y%�����r��_��n�̧/���?�:��      �      x������ � �      �   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      �   �  x���Q��C��N1�	��D��������TBvT2���:�H�P"�LU��շ�[����~o��k۾�������~����?�����m�j�������0��j����<<2�=�d�T�i��z%��]R�M����h�:%��L4T�Ka�!ݦ>L4
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
f��͞E���?�L��vx����2�7�����K;"�ϯ���_
�&�      �      x����q�8τ���VE�D)�/�7�8>i���x��ٻr��US ��  [1+㣞�����r���;��������V�����aec_��?�
�)��ĳ�����ص�ְo��Fb��c9��c9�-~$bS;6Or�nŏ�p4���س�;�s�� [����ְ�[�8^6/��/�ƣ^e3�a&4̄��܆9�1�:�P��C�o��Cs�cu̡�9�b��C+?_`��C+�Њ9�b��Cgf�=d�|F��QanX�憅�aanX�憅�aanX��H��KzÒް�7,�KzÒި�7*�Jz��ް�7*�Kz��ް�7,�KzÒް�7,�KzÒް�7,�KzÒް�7,�KzÒް�7,�KzÒް�7,�KzÒް�7,�KzÒް�7,�KzÒް�7,�KzÒް�7,�KzÒް�7,�Kz��ީ�w*�Kzǒޱ�w,�Kzǒޱ�w,�Kzǒޱ�w,�Kzǒޱ�w,�Jz��ީ�w*�Kz��ޱ�w*�Kzǒޱ�w,�Kzǒޱ�w,�Kzǒޱ�w,�Kzǒޱ�w,�Kzǒޱ�w,�Kzǒޱ�w,�Kzǒޱ�w,�Kzǒޱ�w,�Kzǒޱ�w,�Kzǒޱ�w,�Kzǒޱ���ꨖz�w��ϸ�(���^��AϡD����e�S����mK_}�� Ν ��"O!�,E� B��m�Įy� )��V�	"$��P�R���=$�~��ŏ�@l�|��Lœ��ȭ���}1�رB�GH� �u�l�P��<��B�Go[+�~��q�j?B�E&�~�īL���� �~��{�P�Q��j?Bb	�!��9$�~��j?Bb	�!1��ڏ��CB�GH�!��#$�P��A�3�O�}�T5��G��G�B�ʚ�	���ɏ�صT�˚��}K���ɏ�طT�˚��}K%��ɏ<�I��T�ɚ� �#4���&?�#رT�˚��A���Z*�eM~���l-���&?B�xI%��ɏ�x�QI/k�#$f���&?
�CT�˚��9D%��ɏ��CT�˚��9D%��ɏ��|�9D%��ɏ��CT�˚�� ř��G%�����?�&?2:V��GH��dM~�Į��^��GH�[*�eM~�ľ��^��GH�[*�eM~�!�H
Ħ­H��H���W5�Q����^��G�\�<��RI/k�#$?`k���5��K*�eM~�ī�JzY�!1���5�Q����^��GH�!*�eM~����^��GH�!*�eM~����!*�eM~����^��G)��>*��ۚ���ש��^�e�n�?�	�&<��Q�db�M��U6AbeT�{dF�O�طU?Abe��{dF�O��Cm>Ar��GR 65��LLœL�ډ[�#��$`�f���Ĺ�y���h��<��m>y+�ڌ6��j/3�|�ċ,��'H��2�|��L�h�	�m>	�Cm>Abe��ɷ@̡�6� 1�2�|���h�	s(��'H̡�6� 1�2�|���h��A�3�/���!S���?�
���б�:�	.�\��=D�u�~��!W?Ab�Ra���� �o�0���O<�I��T��S����H��Ier�*}�Z��ϓJ�\��d�8�Pɚ�� 1o�||�-�>���7��ö����>֑�MF���e���-}[G���xt|�W��ƽ[ݳ��k�c�~x[Z�cdm��9��(����Z�n3/���V�s^��ړ��*�s��$^Tz�*�'H�����U�O��dF�w��}����;W�>AbQ靫t� 1����U�O���G�w���=�'U�>1:6W�>A�%��t� �k�h�U�O�طT��*�'H�[*�s��$�-��J����#)�
��\��{$��T��*�'q;��	r��q�s`kij"W�>A�����&r��$��45��t� �o���U�O�طT��*�'H�5�UF�n�|���*us�$����
�	s�J�\��9D�n�|�L�>*uk�|r�}��G�Ŷ}��sи,��G
��Q�RV߷�r��}1r��sF>��^�����#K?�v+��j�����~��g��������.�}�.V|;��q�6�S�����4x�j��8޿�m��l���F�Z�{�^vK�x�C}���_[/�x?Z_V�����~g�ɭs���9�x)�����"��b[U�(@��)@b��F�Q�;i���T��T�� �9��5��?����<��')��[�#�	.X�ر*_ ��8�9��*_�[��5��8ꩬK��QOe]$�Ax��"� �ߧ�H�s��R�1�Tv)@b��R����.H�!�]
��C*� 1�Tv)@b��R��R٥ �9��K�q�3�Oe�R�0h ��aL���=.�� ��TQC���Zw"H�!*�u'B�ľ�"Yw"�@l*պ�!��x�T��N����W5�'���!�'�$Tx�N� �yKE��N�<�g�A�}��,ȿϟWIi$����s�
V]� 1��`Օ��'��['�I~X_��Z�ب��Ӓj`�L ��Ӓj`�L 1����AL�L��X6h �l&L����.1�L �k�z�����n�L �o�������n�Lx?���p+���#4척 �#رT��f��A���Z�]���[���薀 ��
���-��j`� �o��-�*XuK@�ħ*XuK@����U�H�!*XuK@����U���죂�F-A����G�S������R�|��g�~�*�gm~��?k��.�Yk��Ϛ��<ˏy~��?�'��el�=�IGX�>=���辔��ZC^)V���o��8�<|[zo{{��8�)�@�5���R(v�oC��s�[����?��6�je=�HΒ���OS^G<Yo'��{m�UvC)�TnC��@��%P4Ѩk���@qо���:G�g=��k/���T�g��JUYk �nJj 5U�B�P�P�f��Ҡ�$��ס��ס䕎�t!+q��Ȝ#�a%��F�j c�.i�@<G�u=��ը�Y5���uA�R����F��8j'<��JT�����YUW�j�b ^�t��P�i؀gc]}������To�����A��2t��Hq�!卺6�@�ui��4�Ci��F5�(�t}��q�tZ�?um=z_���I9�>��+�V���������x�_0�>��-7�O|p{2��`��q��c<;�v}	��f-e�.�է���<~�������vX[|���;�+gd�q��G)��e�#7��,�>XԎV+���ʶ%-�ـ�O��W�~b6��r��/r}x�q[��[6���G�ه��pYGr>؞��}��h瀾ؾ��|)O{λ�+�m)�_���x���z�Ж}��H���_�x8���K7��x^�Y�vX]�V�$|�D�9`3��.ܚgWޖ�Z]-�]���t��)7]���t��)7]���xo��L���{�c��5�H-��:]@���9���JvdkCױk �#���"v���:Y��q�N�u����s|�t]/a�R��u��7����SSa6R��k �P镻�u�˘�F��ԅ��C� ���"w�^��:]ᮁx�f�tu�ң
���v�́P׵k e���])s� �����rP �K|U�_?Yo�����g-��?>k�dW=�Bv�+����_%��U���'~U����_=�fe������/S������GݖZ�<հ����=���{C҇�Rm/}��ܸX��j�벎��䀳����u�T���}}>�vzГ	����m��{�~��OG�&͟(~���MI������Q��ę��g�e��m$|:o�Kq�s����)�5��'f�:3j_���K��%�sBz�uk�^�o:���؍7�����=���%N�o1?s�_#gg��];�k��}"~&~+�dZ��Ϝ5c$~���B��ف:~)9;�����f�b���;���c���b'F����4��v�C
��\P��+{ڹ#qԜ�<b$�&x�L�1 b  �H�dB������=4U�q��ke*���!�Y�.�	�2��#�<a,�1���#�<�O�;�H�z꛷<ď�@l*=g��b��U��Iϙ��!v-G��IO���!�'�$��)Z b$���	"Fκ b�"~+P��!B�"�%f��v5FbM�Wc$���1��SDOD�`����dwfWq6 ?�F����w��Klz#��^D�H,��7t7_O������2lo�gG|P�z[���P��f��b��ׯ���A�ؼ��x��]�̹��u3�&�w�����5b-n%kc��r<���e�t} ��A����􈏅v���O�z�
lͼ��>������ױ~]��#�x3_��}-m�F�7m+O6Z;J[��紳�ھn/��yD��Q֬��������ڱ_Cf��=�_M�{ں�jro�4%�b$�:iK4��Ļ
M}�{B ��6���X�41�{�@��H�RD�A���I3�x#1h�l�{?���0������Ͷ�[�5�K�t�!v�:����E+B��;.�H����&ECB���s���DSB�ľ�i3ї#���M��ބ�O44/$�b$�����9D��hR���CT?�>����}T?VժG\���
1W�v��Jf֯'�g�3g��f-�3g=�<��=+�����>�?x���Y���q��l!�ͽ
d��G[n��2�?��WB�,>�����o���u+P������u�g��b��ǧ���zԶ��-���ɤ�����kv�U�q;�vx_�j[M�q�^,���ϫ�sв/c+=})pO�ݦn�����u����>w���̾_
������[������\�      �   �  x���ے�6��9O1/g���&��]Wv];�\�#�3��H*Jr�_P��ԦU�I6?����4E�{ڝ�����e7�5����`B|��w��s�A�\W��_���Ts:����j�cOc��8wa&���w��i�&?H��pv�h��_o�D��o䵧>WͰ{�:��/�QL�������Qڀ�?�`�HL� �4&Dh�Vd�`�2ˌn�b�"��ݰF]�1�fv��k���a�L����c��ʷl������͊���F+'
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
��� �K��a�5�B��z	��.M�H\�%жtr�uex��m�d	�B�������Pn�P*yM�����DN�w0��'��*�����0��E�k�HʲϠ�~�4����r���J�2��Q�j~�,|l])�� _�lNBܸr�cT���B���y1��k��� ���ΕΥJ?���*π)���L�GIS	Z��de�?��D'z �'GE����_�m��P�L�8c�ї�a>\en�W�2��Đ�3e�ψ��ASf����K4eЄxGSn�����4e����P�Ua)����r*S�|�Й����n�	D�h~�|����Қ秀��O�d�?�OSW�mEV��+���ñ;���>��U�����8i+�@�=[U�o	�⢭Y!�lmHw��-q�C�m��bǖ@�	;����U,?S�\�^Гu�UT8^�*"Ǐ�*W�:��@��ܱP�r�cSuW�i@j��/IR�ϽIލ������"�:�      �      x������ � �      �   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      �   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      �   o   x�����0E�e�.P�E����s�S�~�8��@$�%��x�Fp�ֵf��`\�"V�H���!������}��n�ɢpWu���jO���uY�/�m!��:F�      �   �   x�uν�0���)����?���������M 0��/\]����!(' $��d(8�W֓�u�Jhh� ��*�/��+a	�]��z�q��gHXiVCՍ�1U��۠�c�mL@k�[a�0�C�A����x�<���B��qp����+0C�Qz�z�&��:q
���Z�kr��($I�      �   �   x��б��0��z�� ��B��ZqWp�M�7'��ѷW'L���_��j��S�)R�Xf��l�1/����(��n����;��껷�xHP����C�귛Z��TBe�?��%���[׍ɮo��UFj���g�h�n��d�9p��-��e�L�W?]V�TLA��}?� ��: ۦI��!�A,H��1zB�M��DU�Y>�����[      �   �  x���]n#9���S�ư~���!�s�s�wҥ�WP��B����%Z㸵[��������둿㟶����c�������&��,�}>�{����O/<����Ǚj�R��/<���o��{�(�R͠"���ܥ�nE�N���7���M��^�fe�O��M�e�>i+ӜN�VtZ�֞�᥉O$��x�� ��[k�K���q��o�շ�_W���L�=Z߶|	J����J��b?�U�3\�iL�6��ٛ��O�Na
{?��{�+{?�;�)����S�}x��c���Vo��R&=��`҃�N�vH0`��f0�|̵�w�}��w�����Qa�:e/0��g�T�����v@�fa?������d�/�v�Z|eA7����=���[$�"��K�4 �Sj��Rϋ�����+5�XR��@��g�0��F����_a҃I&=��*G(�vF!������V0P��*�3�����uB5YOH�&빌�$�	i��15���4�5�\�W��@j5!�M+�t���YJ��G~e	�%<��X�bI�%=K�(5��1��ڹ�8JF ��oˡ�Msj_����f��G�c̗��L����6��z����x:$�$>W��>g��HC�9�M��������\�y��co{����N�����fLe�';�֕���tzSه�><���Lfz0���鱇�{x�ᱧǞ{z��o';q�W�0L�+�6E�0���I��u#w�}������l�AUe?�"8��6�����aP�fؓ|�VR4J�U_S4J�UK��q;uV}�VL!G�����M��w����#a6/��h�,�&��J�K�h�TaJ�訒�L-M�_��5O�_2v�&:�DC�=��|p^�Ѯ�|��%���Y�u���T+;�5��h���\�횆�TѮ�Vb饚^�饚^�饊����o`g%V�ahxe����ʾ��)���Z���)�CjJ ��(���cYM8֭Y�b�֬}UXz�,�&��f��A�I	�٤�%[�I	���MJx��lR�l�d�f#%��0��%U��&܆�vCs�	��9��Y��	ȋ�+<+Wx�M��'��u#q�罩��B���{x�᱇Ǟ{z�鱧ǎ�-�{�����j��%%х���&,�:=X��'Z�&h�|]��R��)�h��\
:Z*w>of�M||v�&��HU���%+s�����~���:E���=���W<۝�n �e���z(��ܚ��aƧit��n�.m�{�˯R�����r��ŊU�t�X�_�L5�ƯR���8���s}��&苌wc�'��U�inΪdj�j|��xW�J.7�U�T���xXHM��_����(K�yv��_~W�����7g�&��]��IT>qgן�1r$�P�V�4�+�:(��U�1����:W4�.��a.���i.�S+�6�k>E�q��>�'�8}�Q�$�v��^Y`�Q\.�hRQ��||�SQ��      �   #  x���ۉ�0@�o��4�0���
�A^D����L�W0�X2��&�OE��<�m���S$��d�޻9h�	��W�um��X8�p`����� n��p��-�[ � n��%pK���-�[�n	��ub���H!�r:�&�SK��aH)w6S�|a��0�;H����0���M_��V�b���p����u���7�+���:���.���@}���}��ς�2�߲�Ǿ�Vu����GX�L6rF^�������G~�Cǣ�y��z�}�ϰ�z�����(      �   5  x����m�0��*܀|�R����#4���/���<6�L�N�S�0��3�!R�c{~n������ED���3�΂�>���3�Ή;'�	�y'I.�qEh��Hm�XS�M�w��!�$���&錤S��ɠ� ��Si� 0��3�j
B<	�$ēOB<��!ēOB<	�$ċ/B��Z%ċ/B��"ċ�~ݩ�2�Vh��U���.�i�X�c%ﭱ��<��Srk�x�k&���u�����d�]G���2���.�:n�G'�?m�G~��n�K6������?Bs�������=��      �   g   x�m���0D�PEHČ�?�
��rXe7��c>N�"�Yg��ܭo�`	��>ٚB���jP�#��T3���d�'��<lͦ!�����Qs�M7��P�8�#�      �     x����q�0D�o��4��� $��T��눜rƟ���.�����3��<���x�׫���8b����]���da�4Y��4������f��0����������0[�T���66i�����$��c�fZ�,f�ffZ�zm���zm稱]� ���o[�m��
˪�,��s��6���28���}$�NR]���$�������4�4�4��~~��0����������0[�T���66i�����$��c�fZ�,f�ffZ�zm���zm稱]� ���o[�m��
˪��
��]8�aaap���(z���"��J!���~���Lf�a�i�i��+�d�Ɍ4�������X���b�2�e�O��˖�Bd�22=TF��{#E d,ޱ@���mN��i�jM����X��b6�4�K	pd�i�i�7�4�0Ӳ����h�8��Q㰷��o[�m�]�mUXV�eUX���������ߏ+���$�&�K��e����=/��4Y�,���}�|����+���޶��yx�      �   �  x���Q�� D��)r�L���!�s�s,��"١R[�=�/�t��A�%��/��/Y����&����r)f���Mƛ'C �&��QRSi�*	�ĨĎ�
Nc�Z@�.�%��dONc fJ&	��<~Ø�)�丒)Q��/ �����1F�9�IK�l�NgB ;;��5)�"2�P

��0.=�9�vR GJ#��Q�R GF���3�ia�sq�. ���;,
�˄�W@�]eylMYȐ. �e(Q��JX��%<Q�Ȍ����c@^����&��d��I����B�2$����J�P�Bq
��R�1��,3�XI�Hj8D��e���5�:ݜBi�������F�v��L�z;#q}$.�G	��ƀT���P�H4>�?!�6�_���Y�c(b�u��` C�I������̀��N�\D	Y��E}c��3 W��tdg�&��Q(W�Y��(JqT)#��)q�UP�UZ�Uhi�	];��E]�DR	׎�@u�g-�F#0�� -C3�R(��xq(PO��Q�R Gƥ@����)Z��ȡ@�:EK�j��Y!G�S�Y��P���U:�@ ?W���D��C�UF�N
����L
�ȹ�Q#�L�O��!)A����%(���&q��2+(�S�0��ұ����c�1F�:CIe$���[��q�3*�q��qF�0Vq��*�q����4�#/1Đ��2e|����s�.�V�z��o�[�tm�����y�e=�x�+�u��2N�q���8]�鈫I>�<�׫���9VT�8k3n��y�}g������qxo�q+���e��ĭu��U���øۑ�w��:�V:m�/��/�a�m�/��/�Jg���C�x�Ľ�^q�2��x�:�Nq���︳5�/�z���Q��|z��?�e��ڶ�/Ŭ��      �   K  x����r������b�@�a�|'@���$'����NBűSNe��Yb�M����JU$'����P�f��v�M�v�X�sg��,{f�f���r��`�d���v�����y���1���<W ��#���d�fH�l%Dn�o�������[�R�!^�?7g�q	��r^�\l.!dd�	���x�ԗJ��">���8�($4��~�z���:�Z������y����ӳ?�����m���b�RBZ=o���C��A�]�t��2m�ugM�rg�=�����5�O��s��Ia�� g6p����+ �P���LŒ�*N d����_��ת�1�MJUT�{�Mx�
�,[��
x��4�z6_�8�7����y�9{����^��k�a�(����#��}SO_�L�*�H���$*�0�Y��c���̙^j_N_�O�(���D�x�~���Xg!~ޣq��.�2�ߘ^�9hB�����a�N+�8��n��K�`,S���Ǚ2'Mz$���
$��Tc�c=J�1S�a�_����|B�c^R���_���� �D�l挩�Ej���ik��bI(k+z��[.^$m@�3�I&���&���ଞ3�덖 �<��ǽ�+�*��+U`���	�:��4L��!^3���S�,r�b�[�c���zK<7�w-�c490u9�/�Em���	�qS���+���k}iLpIBWK�9g��A�0VqH�q����t�1�//���myAQ�m=��)D�
�e&��#?��k��\�ݫ��Z�CC-d�X(�J���y�u������Zg�N����6���!�^V��76�]#H��!k=��r��e�t�Ӓ~�7vvf�]�:v���J^`n[������&I�Kяe��ܛ�azջ�P����[s��tc^#��A]�;Z�
�)Mx��%=^b�s���g��&���k�wH���M�K�����u���X�8TaH�B��9Cc�w�]�2��X��CH9�1m�zVϤ]����϶�߈8�L{�oz)��������p �Δ��������6/�^��9y� =9��#���)E��b���cW���!��7g�D�Vš;�@F��0Y��_���� ̃@�tz7Ww�:V���U5��h{ y�nN���}z�3���q��ڛ����ܮ�/�:�|�9
��Q��z-w��o�S�f���*��:� �}ڗ~�=n���T�������� �-�)�OƘWm߶{(6�@���@���a?T��j�D���B��%���CK�K�-0�_uin�G�H��l���5r: �����c�٬Ӧ���D��]�)��S���O���{�,vV���j��u���$��A�'��$)�Nn��t"hqs�Q��ލ�ˎ�(�}��T/�#��(.�� 7!�|:�����If�iw��}%��oT�/<sڴI2޺���ｼiI�q��ޮ`=�ˡk���5�c���@6���qt�}/�*�*�ӂ:=��2�b����͕>-H�9�m��}���r��������9�:�`�N�Z$�G�2��$���^��;w����͜��e�
�ϟ?~��?(��      �   \  x����u1D��*Ԁ��Mr�H�J�l'�y�=1��H��e��ǯ���]���}�ڥ����.zͤ�~Q���ئ	FFb��t�c��1sw��1��c751�0u�a����{�K� �_O�|b=\a=3*̨���{ù�B[�F��v�i����#����w�ȱ�i<�XO���i)#����~~]��s)p��fa�{�2:Z����w���]b��y�~V��$|+g@:�LAd)}}>�k����<�@��|�0�Ĳc1sj�֙�L�t/,�cFg����č����nq@7���3�#�&�	�^/�4!oL���84�ci82��R�Ѣ^���o��ѥ�mY>�.����@����'����ߡl����k�8&� �8m�x߈�t����qT�l�k���tn �E��f]ɍO:�W!|.j/���u�����N,�ttE�H��J��fGL��5������O9;(��"yb9��m�l?������ٲ��M�.�Gn�BW�-��h�#�z�=(ҰM�6�]�"1�c�Ƞ��&�"�%����b7����į;V����_�	8�'|�����3J�(���K�=q�g]��X����JX���V���/�|�z�5�C����3�`{������K�9��~����
��5��S��^����b���|��7&z����~��%��jj��7Q{�]mK�a���+��5`��:�4�/J��(�X�K(9 9[��(2�R�g� ����w��\��}����u=L��Gb��s����Y���n1�aH��f>y��6o����>�wQ��U����\�"��V�����z�2E�N      �   h  x���˭�@E��(:��C�D��c���~�i{������A2x�  9!N���#��Z�'�TtBxР���J=xP�a}�<A�cr,�(J�V�[i�%�f:z�&�T���܊�'b�LZVE��0Z��dC�J>��c"�l&�k���Xɢ;��u�))��h�}Cx$�IkF��4�C`�l�@K�!=*/Ru2x�]_Jߡ�ʴe�=W�'JH)1I#t{�V�EJu��nO���_���I�a6�&��!��B�����T��0��c�_�@8��Ў�Yx��T��^=�|�\:�I��:zA��r{�ρ�oj2'iu]���xi�֖/��t=����(;z�k����z�?�8��O*�      �   w   x��̫�@�a=��pK����5�	�4}|H�����1��u*T�k�>�8PV�RqV�\G�&B�D�����Q����i�&���<�U���{�M8��؜�K�j�׈��q02      �     x���͍� F�5T��ml~�x��:��Di$�-9���`"E�6ջ��쒱m��>:��~>ߺ�Q!�d� `H1'�
�iI�T45� f# m$�ˑ4R��F�I�u���|O �� �'� ���Q �� /#G����4�l����3�ЅD)AFP'�	
�Θj"E��D����ݢ�̩T��{G�rT0�:��ύ�~�:[����!�T��,#�1:�W8�WRU�(k��i`j�N�����n�K۶��8��-���8��:/�[c����?����Z �DC      �   *  x����n�0���S���s�rW�%(���n�#��ɢ�bo����Eo�A��|!�?�u#R��l�C,�T��Ǯ�N{X���v�	B�ew:\
�i�� �B��k��Y��LcJ1�$�,Ģu�G��Yt��������].���CÛ���ѡTf^Gg��z�Б��ލ�c7�{���	cf �k�k
���)
S=����C����o�rՔF����Q��E��펪��CmBH9��!a!��U�`�)�f57uSW��kt�G��C=��݂c��_OB,z�DQ�HE��      �     x����n�0Eg�+�2H�eis� ��H�-k��6����Į�V(���8 D�O�,#�\tÔeK$1��_g��}:}�?2<l�{��6�����#��7wpx����B�P�s�D��e�B�ET<�V�a75�vZ�n�Zh��1��p��X���P(��@�Oه0Kd74�U��/^�R�Ҽ�%\{�e�5��Ui*,��=��c^�.4@�j�Z�� ����A����:!y
�1�5l��S�W�eUa}�u?@��      �   g   x�r�500�52022���Ә���GAW�9���W�����1D��?�߇Ӑ���F� P�������g�'�(0O����������S~I~��!W� a\�      �   �   x�36�r�500�52022����34�56�4�4T�UI-.Q.-(��L-R004�42)��?2@ҧ``ie`heb�gllaba	4����E!0�1(�5�3��Z#�1H��A��&
��+F��� D~'�      �      x������ � �      �      x������ � �      �   �  x�-��u�8D�u;�> ��t�q�q�qd}EE���O?)���->�+~��^"�K�Ҿ�/�K�Ҿ�/�G��~��G��~��h������v��<1���s��1�[�ox&քIΗst9�������� _��V�r��L�(C	�/}}���$+W��\�j~���f��U��Y3I��g6�^�;e��>�i�Lz�ڌ�Gq{�mGq���o�� ��+��(�J�|f��g��rf�3�q3�Q����R��D%���ZN�Q����O�,h����'. &_��(,��"�*B�b+�Z�\�^QT��
�������E/��+^�^�<��7��'���%�b�%�x��7�M{�>��C��>��C�R�T�7��c�c�C{h�/#�y�+�[���+Jl��x��b��gK�g�!��VSv��\r.9iɶvٖlK����[}&6g��l���_�%�:��Kў�=��uol�_��#��Q�k[C߫�9Cc���::�t��zH�ա�C_�M��Ck���Ϛ%�n�.�]�`v�փ�Ż.G�������#�Gl��T:;>*�\$�H�`$�I�w3ﵒ���}��l?�j�ͮ����d=�z��$O�k���;ux� ��t����}���P����}3i�G�@����G|E�`l{NY:cKƖ�do�ޒ��x{�����p{±�dl�g�F�-�[��dl���F'{K���-�[��do�{�R��do�goƃ8,��P�{�`*('��	�r:��	�t:��Ϟ�TP�w`*@'��	���	�\t ��N@'�й7@'��	�tB&��yv�����g7i�����%�@ܖò[�	�,�l$L
 �H�rof�I��`R0)�@j�+{_�����P��e�+�(h����lk��|�h�҈����L��BLa��x���d�pp$��5Wj+M68lp�p�Ľ�����Z77����`��8Ki��>�g�.�W�:�B�ͽ�H���������D���\`.0�����W ]�>�%��.`���v��]��oo����l���
�y-�P����gγ��	����C��A�Xoh4dz����k�Ĵ�7cZ�7�tm��Z�h=�z�s�մz��@����	�Z'�N��;��Nk�a���5̳ѯ{+�۫����.��ٛ=�{/��jѺ�Yh���W�5��^c�~~��z �      �   x   x���1
�0��Y:E.�")�	>K���K4�-�!�O�S!��>��>^Va/w	4��)3�5x�4�a�m5�����ۺ��ߨ�Ӫ֥�l��w�7�����9Pd��9����"X?S2      �      x�3�LI��G'�0Ə+F��� ���      �   �   x���K
�@��3��I教C�.���Qi�?)�>�U!��|ɟ�08k2ptĠ�ɀ�#4QS�Ai���#�E����&Q�>%i���c�����k��-�-� l�Kג;�K�5<���������%P�C!�`ȹ�F�*��v��C����l��i�:��1�E2��j�>�JJ��Tr�      �   �  x�ŕKk�@�ך_1�����<�%-M�@KH��f�#R�!�[��{UK��Y�a6b����s���j2c���C��������{}S�����n�þ���s��M���f�t����,���*�Juw=l��"�,�l���a;��Ȋ����*hpX�U�)�_ھo�����;�����xdA�z.�5D޹��z)�56sR�|=ƌ`�� �
3�y�B�"�u*Π2[�D�Jr|t�����Dtpԏ��>zj�{�����Sso�M�xx(��Syi���jq��"/l���#F����a�5}���3��ظ�<(�S@�#`Z��h'	���1��'B��d�)*��;� ���E
AiJ�h$��R4�A!�
g�3��%AI�	ć�|A�����I���\A�������&SN�)�Re3J���2�T��H�TRm2)��P��F\����Lt$�<%8!�ɔ���@38=DԝQJ�k}_|      �      x������ � �      �   b  x����J�@ ���S�Rvfv�t��!m�P
₅!6��Q[�Ҩ�u�Lv~6hM��=DS]��C��ݛ�f�<>d�RĔ|B68��r���$S�]�\�FS�~=�{4��N-����Y����@���e�DS,׃��q`{�s@�"��'.)�}��z����3���iX
œ��&�haV�S��}y{�O�1�Wja��ǻ>�񓼮�gD�銒#+ι$��6$��1��#� ����B臷�O.�?������e����������MN�nf��JAFt�̮�We���J���*>��:@���Q�#X�.1��q��4�.(��j�|o��Iq�,�� ���yS      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   p   x�}�=
�@��z�s��y/�Y�6��I?�@�����N��W��e�6����Wќ`A����c�d[!�ǧmI����Y���#�;�������p'�U�q7%}      �   }   x��б1�Z���!��-{�L��ϑO�A�/��A���/��Q���eX6kkȫ��6m��S��bOh�	4�_�mE��6�*��q'���gY�z��L�R�����#(�'�UU߁�a�      �   �   x���M
�0�ur��@���$MV]A��ZJ�Ċ׷7
"����cuno�����6��K/#�!i��S�z$�jY�U7H���4(,�+l�<zTM�:F�}����YSX��m����]��'�x-h���?�c��M��~�o>      �   �   x����j�0��??E^ Œ���m�����؋L[�%�&�?�lc�|�ӧ?����
[��6���mB��������0v�p��w��6�g�E�N
0�5���'�`?N� #>nW�J[<��L�45'ux�C����P��(���c/e-Z[=��<I�҄Y��;N���ag�D�E��˺�\��"'���2�f�*�u�ES�ͺ[�SX6���|�FQ����'��^�vN>��3��1�� ��      �     x���]W�Lǯ9���s+��^����|Im=k�5��������ĤN7e����0?���=aa�Ҥbo#�1�3����86|(7
�u��h����I��>g�����Mc����n@�_��Eõ1yS֝�ֳp@�� TJ�"DUT!<��
�"�U�T$�HW4Y�5@h�m�#6͖��GȾ(<�%��d!��2� ���7�e�:BH"i�/!��oD3��F�����l*�ǒu�HlƎ8H��l������	�M�a,��O<?ۓ����e�V��<�;	w����DF?��ڊ�O����:`�Fᬾ�׷}�v���a��O�@$�
�*�.lz���	�H�ΘĹ�Ϙ!xt���1��=�9�:{�|G��\B#��"_�hBV>s_�0,@!l� �ʶ�ͮ=����^�%����w�*�k�!��Pjك�lͻa/� �A�y��(�6�#��Џ����e��k4�$���OȌFB�ǯ�a���9�p15%\�,tHD�����cʝ�?�u*�ncф�?�j�lP�@v�w�^�X��򽌃��~$�^�����.m��&p���6��㧌T�H��,)�pw^1#o/d|�B͏���aT�u-��O��l�3�=���%N��G#�-�}T�j�`�����m BȢ�
�Rۥ�0�f$z��JĹ ����iM*��d*#�xt�#J���j2������@����)[�:Pdn��������.�l/����[2��jB@R?���9]��ʣi���R/�z;sݍ�>ZH�ӧWrӐ�g��.�l}v��5G���5���ghf|�P?IΟ�!"P��#�+�i����_=��G\�r�b��)�"��rL�7Yo�@A>t
y"�-�!�����\�Q���M͓�#�*?�6���"K[�D�[9����/YX�������r�W��<񱱯��'��:�� =�տ�4�6~J������h2�u��.��^��l@�XV0b`������i_���rZ�����^qV��Z�c����)v7)Ʉنr(���cW�ؙ�k:V���g;�f��v{Ijf�hj�mk�H��m�M���;���}'� ��"W�M�٘k--��p@�҇m��-~̤K�c�BC�҄��4��n���	�~{���6���*be_�W��c$��g��g�La|x�|��6�f<�D+��V�Y��(7GK�����!r�ޡ�I�4tԠf�j_Y���J�����jٷ{k�J��X�?��]V�.H�dsF��̚�M+�,5�1^�Ρ��o�qzGH/�,�H@�F�iAXX��y 5e>L�kGk����hN�V����G�_��nW�.\�=Z<���v3w�\3���z���~�}U���[ſ�b@��@SWvU�PQ����Ճ:�%���~�y�UUG�
!P��
�iSČ[O�kS�$����J�a�-JW��q�
�!�s*0~��Ƌ^K��긋�f��ln�WcѿoL��]�b�wfЪ���coTr�aGc�ڦp�f�8:)�q9V�������-�2~�9���4�<���41ooe.e%� [+	�I�H!�1��%�'����MK���n�/�؝�#��y 1u�|�r�`�޻ω������Q/aT���5����BB�HH�N>���������f��Ec���'bE|'��m@���	�xP-�oTk���:���y���]�,^ӦD�n�Ty��iI�N��(�ܘ��һ}�
)<9Y��:(�
�O�G\�燿"�����7ڧC����d,;C�'����.��!      �   �   x�����0��s�����Λ����T�Ԩ����/�m�mP���7���2�[��t�qT&k<�L�yvh3�+5+���ԉd�2���y���s�Y��/qLzir����&3xW������u=��L�Lr��~�ܯ��!"/,hY�      �   Q   x�3�4�t,.)J�t��/J��K,�/RN�I-�420��5202����4r��t,t��L��L�L�L��b���� �v�      �   �  x���M��0���)r��l�]u��=A{t���L(��IQC���a<?���$�<��dy07��K6�]���w�\���ܬ��:s��$e��o��\�kS�yW�$:�����1�F.9���j��$5ɬ���[���"F�od8K�MьS������6�8B��1b���%[g�vW$�R#F�Ie�]��tꢒ�wG�x��_՞
��U��#�Iuu0��m�=���k�1���p��Ֆ��1(z'-�1^^"F�lq��xv�6a�t_��<�'F�w2o\#FX�6�̚��#l���w�#��Sùe��<aXl�R�B#F�4���=�+#x�bs!����^̗2�f�`�[��"9��VV2��\#܋Ş�!�D�`�ͅ�l0��}qo�C�D��c��B�i���}|������?��1���vM�Y&�^Ox�6F��JXF=~���'#��ˇLQ�3ׇ�D��K��ƾ-e�]����ED-��
      �   0  x����jA��u�U��������ҍ��Y	���L�w�d,8.Bj��	ڇ��L:iR}H�!�$�ӏ�oN��O_��L��)m&ɗ/>?��N���'�5��������i5_�t�>ɬ���W��"۲������緂��˫�A�i������&������U�)ݧ�/`٪e�\k����B�U7��V�~T�%iK��E%-Kg�,݇eТ������2�h�2o�*�}XZ4���avV����GF�KZ4V������ҳzy��;2h�nK�qK��-���ʪТ��qK��-��qK�,h�Xz�*ˠEc�qK��-���ʪТ�Zx_'c��4Kͯ�X���㐧��0I.P"�t�!T�A�D��~PIJ$R�o�T�D"��nPIJRN��`��@�D��^PI%��Z��g�R������6oK��LV����j0YZ,VIa9��"Т�4��eТ�<,���Ec��"LV���0YZ,V�o>���3h�~'���deh�X%<t��
-���.�ա�b��DVh�X�L�A�����e�2�h��,���"��]9iJ�[B-��ԡ�!�6�F�%I�~�H%��v�HJ$R	��#U(�H-l�ԡ�!IJa0h&I)J�`�1�/%��+'�R#�[J&��ʐb�J"�B��ja6��)JRJR,��� �R,��� �2�X�ƃ���b�❃2�򴨔���qoG"��Aa���������Pa�
o!Pa�"�"Pa�:o$Pa�Rf�^f�jo'Pa���e��W�>      �   =   x�32�4��45�H,.�4202�54�54���4D�+X�ZX�Y��s��qqq }^�      �   �   x�e��N�0Ek�+�Pf5;ٸ3&@D�{SѡHtH���L�l����s��*)�0Gb��������5
��@O�]��.Ԓ�M�|]��������S1���Z ���VϞ�V_��� �qԨ�}��%"4\k�5H���Nۭ�:���wL��OP��)>��|�[�R
���>,5�~��M����Mo��ҡ��}��Y� ���с�j�~ݶD��A� 7�w���=����0=跃����^�     