PGDMP     6                    {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    17913    ex_template    DATABASE     s   CREATE DATABASE ex_template WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE ex_template;
                postgres    false            	            2615    34376    pgagent    SCHEMA        CREATE SCHEMA pgagent;
    DROP SCHEMA pgagent;
                postgres    false            �           0    0    SCHEMA pgagent    COMMENT     6   COMMENT ON SCHEMA pgagent IS 'pgAgent system tables';
                   postgres    false    9                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            �           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    7                        3079    34377    pgagent 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgagent WITH SCHEMA pgagent;
    DROP EXTENSION pgagent;
                   false    9            �           0    0    EXTENSION pgagent    COMMENT     >   COMMENT ON EXTENSION pgagent IS 'A PostgreSQL job scheduler';
                        false    2            e           1255    34586    calc_commision_terapist() 	   PROCEDURE     X  CREATE PROCEDURE public.calc_commision_terapist()
    LANGUAGE plpgsql
    AS $$
DECLARE
   begin_date date;
   end_date date;
	begin
		begin_date := (select case when to_char(now()::date,'dd')::int>=26 then (to_char(date_trunc('month', current_date)::date,'YYYYMM')||'26')::date else (to_char(date_trunc('month', current_date - interval '1' month)::date,'YYYYMM')||'26')::date end);
	    end_date := now()::date;
	   
	   	--begin_date := '20230101'::date;
	    --end_date := '20230425'::date;
		delete from terapist_commision where dated between begin_date and end_date;
		insert into terapist_commision 
		select branch_name,dated,invoice_no,product_id,abbr,remark as product_name,type_id,user_id,name as terapist_name,com_type,work_year,price,qty,total,base_commision,commisions,point_qty,point_value,branch_id from ( 
            select b.id as branch_id,id.product_id,u.id as user_id,im.invoice_no as invoice_no,ps.type_id,b.remark as branch_name,'work_commission' as com_type,im.dated,ps.abbr,ps.remark,u.work_year,u.name,id.price,id.qty,id.total,pc.values base_commision,pc.values * id.qty as commisions,coalesce(pp.point,0)*id.qty as point_qty,case when coalesce(pp.point,0)*id.qty>=4 then 8000 else 0 end as point_value
            from invoice_master im 
            join invoice_detail id on id.invoice_no = im.invoice_no
            join product_sku ps on ps.id = id.product_id 
            join customers c on c.id = im.customers_id 
            join branch b on b.id = c.branch_id
            join product_commision_by_year pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
            join (
                select r.id,r.name,r.job_id,case when date_part('year', age(now(),join_date))::int=0 then 1 when date_part('year', age(now(),join_date))::int>10 then 10  else date_part('year', age(now(),join_date)) end as work_year 
                from users r
                ) u on u.id = id.assigned_to and u.job_id = pc.jobs_id  and u.id = id.assigned_to  and u.work_year = pc.years 
            left join product_point pp on pp.product_id=ps.id and pp.branch_id=b.id 
            where pc.values > 0 and im.dated between begin_date and end_date  
            union all            
            select b.id as branch_id,id.product_id,u.id as user_id,im.invoice_no as invoice_no,ps.type_id,b.remark as branch_name,'referral' as com_type,im.dated,ps.abbr,ps.remark,case when date_part('year', age(now(),join_date))::int=0 then 1 when date_part('year', age(now(),join_date))::int>10 then 10  else date_part('year', age(now(),join_date)) end as work_year,u.name,id.price,id.qty,id.total,
            case when pc.referral_fee<=0 then pc.assigned_to_fee else pc.referral_fee end base_commision,
            case when pc.referral_fee<=0 then pc.assigned_to_fee * id.qty else pc.referral_fee * id.qty end as commisions,
            0 as point_qty,
            0 as point_value   
            from invoice_master im 
            join invoice_detail id on id.invoice_no = im.invoice_no 
            join product_sku ps on ps.id = id.product_id 
            join customers c on c.id = im.customers_id 
            join branch b on b.id = c.branch_id
            join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
            join users u on u.job_id = 2  and u.id = id.referral_by  
            where pc.referral_fee+pc.assigned_to_fee+pc.created_by_fee > 0  and im.dated  between begin_date and end_date   
            union all            
            select b.id as branch_id,id.product_id,u.id as user_id,im.invoice_no as invoice_no,ps.type_id,b.remark as branch_name,'extra' as com_type,im.dated,ps.abbr,ps.remark,case when date_part('year', age(now(),join_date))::int=0 then 1 when date_part('year', age(now(),join_date))::int>10 then 10  else date_part('year', age(now(),join_date)) end as work_year,u.name,id.price,id.qty,id.total,
            pc.assigned_to_fee base_commision,
            pc.assigned_to_fee * id.qty commisions,
            0 as point_qty,
            0 as point_value   
            from invoice_master im 
            join invoice_detail id on id.invoice_no = im.invoice_no 
            join product_sku ps on ps.id = id.product_id 
            join customers c on c.id = im.customers_id 
            join branch b on b.id = c.branch_id
            join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
            join users u on u.job_id = 2  and u.id = id.assigned_to  
            where pc.referral_fee+pc.assigned_to_fee+pc.created_by_fee  > 0  and im.dated  between begin_date and end_date  
		) a;
	END;
$$;
 1   DROP PROCEDURE public.calc_commision_terapist();
       public          postgres    false    7            �            1259    17914    branch    TABLE     i  CREATE TABLE public.branch (
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
       public         heap    postgres    false    7            �            1259    17922    branch_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branch_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.branch_id_seq;
       public          postgres    false    206    7            �           0    0    branch_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.branch_id_seq OWNED BY public.branch.id;
          public          postgres    false    207            �            1259    17924    branch_room    TABLE     �   CREATE TABLE public.branch_room (
    id integer NOT NULL,
    branch_id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);
    DROP TABLE public.branch_room;
       public         heap    postgres    false    7            �            1259    17931    branch_room_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branch_room_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.branch_room_id_seq;
       public          postgres    false    208    7            �           0    0    branch_room_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.branch_room_id_seq OWNED BY public.branch_room.id;
          public          postgres    false    209            )           1259    18720    branch_shift    TABLE       CREATE TABLE public.branch_shift (
    id smallint NOT NULL,
    branch_id integer NOT NULL,
    shift_id integer NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
     DROP TABLE public.branch_shift;
       public         heap    postgres    false    7            (           1259    18718    branch_shift_id_seq    SEQUENCE     �   CREATE SEQUENCE public.branch_shift_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.branch_shift_id_seq;
       public          postgres    false    7    297            �           0    0    branch_shift_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.branch_shift_id_seq OWNED BY public.branch_shift.id;
          public          postgres    false    296            5           1259    26919    calendar    TABLE       CREATE TABLE public.calendar (
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
       public         heap    postgres    false    7            4           1259    26917    calendar_id_seq    SEQUENCE     x   CREATE SEQUENCE public.calendar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.calendar_id_seq;
       public          postgres    false    7    309            �           0    0    calendar_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.calendar_id_seq OWNED BY public.calendar.id;
          public          postgres    false    308            �            1259    17933    company    TABLE     r  CREATE TABLE public.company (
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
       public         heap    postgres    false    7            �            1259    17940    company_id_seq    SEQUENCE     �   CREATE SEQUENCE public.company_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.company_id_seq;
       public          postgres    false    210    7            �           0    0    company_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.company_id_seq OWNED BY public.company.id;
          public          postgres    false    211            �            1259    17942 	   customers    TABLE     !  CREATE TABLE public.customers (
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
       public         heap    postgres    false    7            �            1259    17950    customers_id_seq    SEQUENCE     y   CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.customers_id_seq;
       public          postgres    false    212    7            �           0    0    customers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;
          public          postgres    false    213            3           1259    18774    customers_registration    TABLE     �  CREATE TABLE public.customers_registration (
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
       public         heap    postgres    false    7            2           1259    18772    customers_registration_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customers_registration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.customers_registration_id_seq;
       public          postgres    false    307    7            �           0    0    customers_registration_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.customers_registration_id_seq OWNED BY public.customers_registration.id;
          public          postgres    false    306            9           1259    28173    customers_segment    TABLE     �   CREATE TABLE public.customers_segment (
    id integer NOT NULL,
    remark character varying,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
 %   DROP TABLE public.customers_segment;
       public         heap    postgres    false    7            8           1259    28171    customers_segment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.customers_segment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.customers_segment_id_seq;
       public          postgres    false    313    7            �           0    0    customers_segment_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.customers_segment_id_seq OWNED BY public.customers_segment.id;
          public          postgres    false    312            �            1259    17952    departments    TABLE     �   CREATE TABLE public.departments (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    active smallint DEFAULT 1 NOT NULL
);
    DROP TABLE public.departments;
       public         heap    postgres    false    7            �            1259    17960    department_id_seq    SEQUENCE     �   CREATE SEQUENCE public.department_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.department_id_seq;
       public          postgres    false    7    214            �           0    0    department_id_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.department_id_seq OWNED BY public.departments.id;
          public          postgres    false    215            �            1259    17962    failed_jobs    TABLE     &  CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
    DROP TABLE public.failed_jobs;
       public         heap    postgres    false    7            �            1259    17969    failed_jobs_id_seq    SEQUENCE     {   CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.failed_jobs_id_seq;
       public          postgres    false    7    216            �           0    0    failed_jobs_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;
          public          postgres    false    217            �            1259    17971    invoice_detail    TABLE     �  CREATE TABLE public.invoice_detail (
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
       public         heap    postgres    false    7            B           1259    34018    invoice_detail_log    TABLE     �  CREATE TABLE public.invoice_detail_log (
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
       public         heap    postgres    false    7            ?           1259    33377    invoice_log    TABLE     �  CREATE TABLE public.invoice_log (
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
       public         heap    postgres    false    7            �            1259    17984    invoice_master    TABLE     _  CREATE TABLE public.invoice_master (
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
       public         heap    postgres    false    7            �            1259    18001    invoice_master_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.invoice_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.invoice_master_id_seq;
       public          postgres    false    7    219            �           0    0    invoice_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.invoice_master_id_seq OWNED BY public.invoice_master.id;
          public          postgres    false    220            �            1259    18003 	   job_title    TABLE     �   CREATE TABLE public.job_title (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    active smallint DEFAULT 1 NOT NULL
);
    DROP TABLE public.job_title;
       public         heap    postgres    false    7            �            1259    18011    job_title_id_seq    SEQUENCE     �   CREATE SEQUENCE public.job_title_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.job_title_id_seq;
       public          postgres    false    221    7            �           0    0    job_title_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.job_title_id_seq OWNED BY public.job_title.id;
          public          postgres    false    222            +           1259    18727    login_session    TABLE       CREATE TABLE public.login_session (
    id bigint NOT NULL,
    session character varying(50) NOT NULL,
    sellercode character varying(20) NOT NULL,
    description character varying(100) NOT NULL,
    created_date timestamp without time zone DEFAULT now() NOT NULL
);
 !   DROP TABLE public.login_session;
       public         heap    postgres    false    7            �            1259    18013 
   migrations    TABLE     �   CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);
    DROP TABLE public.migrations;
       public         heap    postgres    false    7            �            1259    18016    migrations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.migrations_id_seq;
       public          postgres    false    223    7            �           0    0    migrations_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;
          public          postgres    false    224            �            1259    18018    model_has_permissions    TABLE     �   CREATE TABLE public.model_has_permissions (
    permission_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);
 )   DROP TABLE public.model_has_permissions;
       public         heap    postgres    false    7            �            1259    18021    model_has_roles    TABLE     �   CREATE TABLE public.model_has_roles (
    role_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);
 #   DROP TABLE public.model_has_roles;
       public         heap    postgres    false    7            �            1259    18024    order_detail    TABLE     �  CREATE TABLE public.order_detail (
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
       public         heap    postgres    false    7            �            1259    18036    order_master    TABLE     Q  CREATE TABLE public.order_master (
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
       public         heap    postgres    false    7            �            1259    18053    order_master_id_seq    SEQUENCE     |   CREATE SEQUENCE public.order_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.order_master_id_seq;
       public          postgres    false    7    228            �           0    0    order_master_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.order_master_id_seq OWNED BY public.order_master.id;
          public          postgres    false    229            �            1259    18055    password_resets    TABLE     �   CREATE TABLE public.password_resets (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);
 #   DROP TABLE public.password_resets;
       public         heap    postgres    false    7            �            1259    18061    period    TABLE     �   CREATE TABLE public.period (
    period_no integer NOT NULL,
    remark character varying NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL
);
    DROP TABLE public.period;
       public         heap    postgres    false    7            �            1259    18067    period_price_sell    TABLE     X  CREATE TABLE public.period_price_sell (
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
       public         heap    postgres    false    7            �            1259    18071    period_price_sell_id_seq    SEQUENCE     �   CREATE SEQUENCE public.period_price_sell_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.period_price_sell_id_seq;
       public          postgres    false    7    232            �           0    0    period_price_sell_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.period_price_sell_id_seq OWNED BY public.period_price_sell.id;
          public          postgres    false    233            �            1259    18073    period_stock    TABLE     �  CREATE TABLE public.period_stock (
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
       public         heap    postgres    false    7            �            1259    18083    permissions    TABLE     K  CREATE TABLE public.permissions (
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
       public         heap    postgres    false    7            �            1259    18089    permissions_id_seq    SEQUENCE     {   CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.permissions_id_seq;
       public          postgres    false    235    7            �           0    0    permissions_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;
          public          postgres    false    236            �            1259    18091    personal_access_tokens    TABLE     �  CREATE TABLE public.personal_access_tokens (
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
       public         heap    postgres    false    7            �            1259    18097    personal_access_tokens_id_seq    SEQUENCE     �   CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.personal_access_tokens_id_seq;
       public          postgres    false    237    7            �           0    0    personal_access_tokens_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;
          public          postgres    false    238            <           1259    30744 
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
       public         heap    postgres    false    7            >           1259    30759    petty_cash_detail    TABLE     �  CREATE TABLE public.petty_cash_detail (
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
       public         heap    postgres    false    7            =           1259    30757    petty_cash_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.petty_cash_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.petty_cash_detail_id_seq;
       public          postgres    false    318    7            �           0    0    petty_cash_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.petty_cash_detail_id_seq OWNED BY public.petty_cash_detail.id;
          public          postgres    false    317            ;           1259    30742    petty_cash_id_seq    SEQUENCE     z   CREATE SEQUENCE public.petty_cash_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.petty_cash_id_seq;
       public          postgres    false    7    316            �           0    0    petty_cash_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.petty_cash_id_seq OWNED BY public.petty_cash.id;
          public          postgres    false    315            �            1259    18099    point_conversion    TABLE        CREATE TABLE public.point_conversion (
    point_qty integer DEFAULT 0 NOT NULL,
    point_value integer DEFAULT 0 NOT NULL
);
 $   DROP TABLE public.point_conversion;
       public         heap    postgres    false    7            �            1259    18104    posts    TABLE     $  CREATE TABLE public.posts (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    title character varying(70) NOT NULL,
    description character varying(320) NOT NULL,
    body text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.posts;
       public         heap    postgres    false    7            �            1259    18110    posts_id_seq    SEQUENCE     u   CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.posts_id_seq;
       public          postgres    false    240    7            �           0    0    posts_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;
          public          postgres    false    241            �            1259    18112    price_adjustment    TABLE     k  CREATE TABLE public.price_adjustment (
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
       public         heap    postgres    false    7            �            1259    18117    price_adjustment_id_seq    SEQUENCE     �   CREATE SEQUENCE public.price_adjustment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.price_adjustment_id_seq;
       public          postgres    false    242    7            �           0    0    price_adjustment_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.price_adjustment_id_seq OWNED BY public.price_adjustment.id;
          public          postgres    false    243            �            1259    18119    product_brand    TABLE     �   CREATE TABLE public.product_brand (
    id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);
 !   DROP TABLE public.product_brand;
       public         heap    postgres    false    7            �            1259    18127    product_brand_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_brand_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.product_brand_id_seq;
       public          postgres    false    7    244            �           0    0    product_brand_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.product_brand_id_seq OWNED BY public.product_brand.id;
          public          postgres    false    245            �            1259    18129    product_category    TABLE        CREATE TABLE public.product_category (
    id integer NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);
 $   DROP TABLE public.product_category;
       public         heap    postgres    false    7            �            1259    18137    product_category_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.product_category_id_seq;
       public          postgres    false    7    246            �           0    0    product_category_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;
          public          postgres    false    247            �            1259    18139    product_commision_by_year    TABLE     O  CREATE TABLE public.product_commision_by_year (
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
       public         heap    postgres    false    7            �            1259    18143    product_commisions    TABLE     _  CREATE TABLE public.product_commisions (
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
       public         heap    postgres    false    7            �            1259    18149    product_distribution    TABLE       CREATE TABLE public.product_distribution (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    active smallint DEFAULT 1 NOT NULL
);
 (   DROP TABLE public.product_distribution;
       public         heap    postgres    false    7            �            1259    18154    product_ingredients    TABLE     H  CREATE TABLE public.product_ingredients (
    product_id integer NOT NULL,
    product_id_material integer NOT NULL,
    uom_id integer NOT NULL,
    qty integer DEFAULT 1 NOT NULL,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
 '   DROP TABLE public.product_ingredients;
       public         heap    postgres    false    7            �            1259    18159    product_point    TABLE     �   CREATE TABLE public.product_point (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    point integer DEFAULT 0 NOT NULL,
    created_by integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);
 !   DROP TABLE public.product_point;
       public         heap    postgres    false    7            �            1259    18163    product_price    TABLE     -  CREATE TABLE public.product_price (
    product_id integer NOT NULL,
    price numeric(18,0) DEFAULT 0 NOT NULL,
    branch_id integer NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer NOT NULL,
    created_at timestamp without time zone NOT NULL
);
 !   DROP TABLE public.product_price;
       public         heap    postgres    false    7            :           1259    30122    product_price_level    TABLE     �  CREATE TABLE public.product_price_level (
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
       public         heap    postgres    false    7            �            1259    18167    product_sku    TABLE     f  CREATE TABLE public.product_sku (
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
       public         heap    postgres    false    7            �           0    0    COLUMN product_sku.type_id    COMMENT     G   COMMENT ON COLUMN public.product_sku.type_id IS '''Product/Service''';
          public          postgres    false    254            �            1259    18176    product_sku_id_seq    SEQUENCE     {   CREATE SEQUENCE public.product_sku_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.product_sku_id_seq;
       public          postgres    false    7    254            �           0    0    product_sku_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.product_sku_id_seq OWNED BY public.product_sku.id;
          public          postgres    false    255                        1259    18178    product_stock    TABLE       CREATE TABLE public.product_stock (
    product_id integer NOT NULL,
    branch_id integer NOT NULL,
    qty integer DEFAULT 0 NOT NULL,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer
);
 !   DROP TABLE public.product_stock;
       public         heap    postgres    false    7                       1259    18183    product_stock_detail    TABLE     u  CREATE TABLE public.product_stock_detail (
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
       public         heap    postgres    false    7                       1259    18189    product_stock_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_stock_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.product_stock_detail_id_seq;
       public          postgres    false    257    7            �           0    0    product_stock_detail_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.product_stock_detail_id_seq OWNED BY public.product_stock_detail.id;
          public          postgres    false    258                       1259    18191    product_type    TABLE     �   CREATE TABLE public.product_type (
    id smallint NOT NULL,
    remark character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    abbr character varying
);
     DROP TABLE public.product_type;
       public         heap    postgres    false    7                       1259    18198    product_type_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_type_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.product_type_id_seq;
       public          postgres    false    7    259            �           0    0    product_type_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.product_type_id_seq OWNED BY public.product_type.id;
          public          postgres    false    260                       1259    18200    product_uom    TABLE     �   CREATE TABLE public.product_uom (
    product_id integer NOT NULL,
    uom_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    create_by integer,
    updated_at timestamp without time zone
);
    DROP TABLE public.product_uom;
       public         heap    postgres    false    7                       1259    18204    uom    TABLE       CREATE TABLE public.uom (
    id integer NOT NULL,
    remark character varying NOT NULL,
    conversion integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    type_id integer DEFAULT 1 NOT NULL
);
    DROP TABLE public.uom;
       public         heap    postgres    false    7                       1259    18213    product_uom_id_seq    SEQUENCE     �   CREATE SEQUENCE public.product_uom_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.product_uom_id_seq;
       public          postgres    false    262    7            �           0    0    product_uom_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.product_uom_id_seq OWNED BY public.uom.id;
          public          postgres    false    263                       1259    18215    purchase_detail    TABLE     |  CREATE TABLE public.purchase_detail (
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
       public         heap    postgres    false    7            	           1259    18230    purchase_master    TABLE     �  CREATE TABLE public.purchase_master (
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
       public         heap    postgres    false    7            
           1259    18246    purchase_master_id_seq    SEQUENCE        CREATE SEQUENCE public.purchase_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.purchase_master_id_seq;
       public          postgres    false    265    7            �           0    0    purchase_master_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.purchase_master_id_seq OWNED BY public.purchase_master.id;
          public          postgres    false    266                       1259    18248    receive_detail    TABLE     |  CREATE TABLE public.receive_detail (
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
       public         heap    postgres    false    7                       1259    18262    receive_master    TABLE     �  CREATE TABLE public.receive_master (
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
       public         heap    postgres    false    7                       1259    18278    receive_master_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.receive_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.receive_master_id_seq;
       public          postgres    false    7    268            �           0    0    receive_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;
          public          postgres    false    269                       1259    18280    return_sell_detail    TABLE     �  CREATE TABLE public.return_sell_detail (
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
       public         heap    postgres    false    7                       1259    18292    return_sell_master    TABLE       CREATE TABLE public.return_sell_master (
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
       public         heap    postgres    false    7                       1259    18309    return_sell_master_id_seq    SEQUENCE     �   CREATE SEQUENCE public.return_sell_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.return_sell_master_id_seq;
       public          postgres    false    7    271            �           0    0    return_sell_master_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;
          public          postgres    false    272                       1259    18311    role_has_permissions    TABLE     m   CREATE TABLE public.role_has_permissions (
    permission_id bigint NOT NULL,
    role_id bigint NOT NULL
);
 (   DROP TABLE public.role_has_permissions;
       public         heap    postgres    false    7                       1259    18314    roles    TABLE     �   CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.roles;
       public         heap    postgres    false    7                       1259    18320    roles_id_seq    SEQUENCE     u   CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.roles_id_seq;
       public          postgres    false    7    274            �           0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
          public          postgres    false    275            -           1259    18736    sales    TABLE       CREATE TABLE public.sales (
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
       public         heap    postgres    false    7            ,           1259    18734    sales_id_seq    SEQUENCE     u   CREATE SEQUENCE public.sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.sales_id_seq;
       public          postgres    false    301    7            �           0    0    sales_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;
          public          postgres    false    300            /           1259    18750 
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
       public         heap    postgres    false    7            1           1259    18762    sales_trip_detail    TABLE     b  CREATE TABLE public.sales_trip_detail (
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
       public         heap    postgres    false    7            0           1259    18760    sales_trip_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sales_trip_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.sales_trip_detail_id_seq;
       public          postgres    false    305    7            �           0    0    sales_trip_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;
          public          postgres    false    304            .           1259    18748    sales_trip_id_seq    SEQUENCE     z   CREATE SEQUENCE public.sales_trip_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.sales_trip_id_seq;
       public          postgres    false    303    7            �           0    0    sales_trip_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;
          public          postgres    false    302            7           1259    27180    sales_visit    TABLE       CREATE TABLE public.sales_visit (
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
       public         heap    postgres    false    7            6           1259    27178    sales_visit_id_seq    SEQUENCE     {   CREATE SEQUENCE public.sales_visit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.sales_visit_id_seq;
       public          postgres    false    311    7            �           0    0    sales_visit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;
          public          postgres    false    310                       1259    18322    setting_document_counter    TABLE     �  CREATE TABLE public.setting_document_counter (
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
       public         heap    postgres    false    7            �           0    0 &   COLUMN setting_document_counter.period    COMMENT     U   COMMENT ON COLUMN public.setting_document_counter.period IS 'Yearly,Monthly, Daily';
          public          postgres    false    276                       1259    18330    setting_document_counter_id_seq    SEQUENCE     �   CREATE SEQUENCE public.setting_document_counter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.setting_document_counter_id_seq;
       public          postgres    false    276    7            �           0    0    setting_document_counter_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.setting_document_counter_id_seq OWNED BY public.setting_document_counter.id;
          public          postgres    false    277                       1259    18332    settings    TABLE     	  CREATE TABLE public.settings (
    transaction_date date DEFAULT now() NOT NULL,
    period_no integer NOT NULL,
    company_name character varying NOT NULL,
    app_name character varying NOT NULL,
    version character varying,
    icon_file character varying
);
    DROP TABLE public.settings;
       public         heap    postgres    false    7                       1259    18339    shift    TABLE     �  CREATE TABLE public.shift (
    id integer NOT NULL,
    remark character varying,
    time_start time without time zone DEFAULT '08:00:00'::time without time zone NOT NULL,
    time_end time without time zone DEFAULT '17:00:00'::time without time zone NOT NULL,
    created_by integer,
    updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.shift;
       public         heap    postgres    false    7                       1259    18348    shift_counter    TABLE     $  CREATE TABLE public.shift_counter (
    users_id integer NOT NULL,
    queue_no smallint NOT NULL,
    updated_by integer,
    updated_at timestamp without time zone,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    branch_id integer NOT NULL
);
 !   DROP TABLE public.shift_counter;
       public         heap    postgres    false    7                       1259    18352    shift_id_seq    SEQUENCE     �   CREATE SEQUENCE public.shift_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.shift_id_seq;
       public          postgres    false    7    279            �           0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
          public          postgres    false    281            A           1259    33393 	   stock_log    TABLE     �   CREATE TABLE public.stock_log (
    id bigint NOT NULL,
    product_id integer,
    qty integer,
    branch_id integer,
    doc_no character varying,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    remarks character varying
);
    DROP TABLE public.stock_log;
       public         heap    postgres    false    7            @           1259    33391    stock_log_id_seq    SEQUENCE     y   CREATE SEQUENCE public.stock_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.stock_log_id_seq;
       public          postgres    false    321    7            �           0    0    stock_log_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.stock_log_id_seq OWNED BY public.stock_log.id;
          public          postgres    false    320                       1259    18354 	   suppliers    TABLE     Z  CREATE TABLE public.suppliers (
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
       public         heap    postgres    false    7                       1259    18361    suppliers_id_seq    SEQUENCE     y   CREATE SEQUENCE public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.suppliers_id_seq;
       public          postgres    false    282    7            �           0    0    suppliers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;
          public          postgres    false    283            *           1259    18725    sv_login_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sv_login_session_id_seq;
       public          postgres    false    299    7            �           0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
          public          postgres    false    298            R           1259    34580    terapist_commision    TABLE     +  CREATE TABLE public.terapist_commision (
    branch_name character varying,
    dated date NOT NULL,
    invoice_no character varying,
    product_id integer,
    abbr character varying,
    product_name character varying,
    type_id integer,
    user_id integer,
    terapist_name character varying,
    com_type character varying,
    work_year integer,
    price numeric(18,0),
    qty integer,
    total numeric,
    base_commision numeric(18,0),
    commisions numeric,
    point_qty integer,
    point_value numeric(18,0),
    branch_id integer
);
 &   DROP TABLE public.terapist_commision;
       public         heap    postgres    false    7                       1259    18363    users    TABLE     �  CREATE TABLE public.users (
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
       public         heap    postgres    false    7                       1259    18371    users_branch    TABLE     �   CREATE TABLE public.users_branch (
    user_id integer NOT NULL,
    branch_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone
);
     DROP TABLE public.users_branch;
       public         heap    postgres    false    7                       1259    18375    users_experience    TABLE     P  CREATE TABLE public.users_experience (
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
       public         heap    postgres    false    7                       1259    18382    users_experience_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_experience_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.users_experience_id_seq;
       public          postgres    false    286    7            �           0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
          public          postgres    false    287                        1259    18384    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    284    7            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    288            !           1259    18386    users_mutation    TABLE     K  CREATE TABLE public.users_mutation (
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
       public         heap    postgres    false    7            "           1259    18393    users_mutation_id_seq    SEQUENCE     ~   CREATE SEQUENCE public.users_mutation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.users_mutation_id_seq;
       public          postgres    false    289    7            �           0    0    users_mutation_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.users_mutation_id_seq OWNED BY public.users_mutation.id;
          public          postgres    false    290            #           1259    18395    users_shift    TABLE     �  CREATE TABLE public.users_shift (
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
       public         heap    postgres    false    7            $           1259    18402    users_shift_id_seq    SEQUENCE     {   CREATE SEQUENCE public.users_shift_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.users_shift_id_seq;
       public          postgres    false    7    291            �           0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
          public          postgres    false    292            %           1259    18404    users_skills    TABLE     [  CREATE TABLE public.users_skills (
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
       public         heap    postgres    false    7            &           1259    18412    voucher    TABLE     	  CREATE TABLE public.voucher (
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
       public         heap    postgres    false    7            '           1259    18421    voucher_id_seq    SEQUENCE     w   CREATE SEQUENCE public.voucher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.voucher_id_seq;
       public          postgres    false    294    7            �           0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
          public          postgres    false    295            �           2604    18423 	   branch id    DEFAULT     f   ALTER TABLE ONLY public.branch ALTER COLUMN id SET DEFAULT nextval('public.branch_id_seq'::regclass);
 8   ALTER TABLE public.branch ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    207    206            �           2604    18424    branch_room id    DEFAULT     p   ALTER TABLE ONLY public.branch_room ALTER COLUMN id SET DEFAULT nextval('public.branch_room_id_seq'::regclass);
 =   ALTER TABLE public.branch_room ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    209    208            �           2604    18723    branch_shift id    DEFAULT     r   ALTER TABLE ONLY public.branch_shift ALTER COLUMN id SET DEFAULT nextval('public.branch_shift_id_seq'::regclass);
 >   ALTER TABLE public.branch_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    297    296    297            �           2604    26922    calendar id    DEFAULT     j   ALTER TABLE ONLY public.calendar ALTER COLUMN id SET DEFAULT nextval('public.calendar_id_seq'::regclass);
 :   ALTER TABLE public.calendar ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    308    309    309            �           2604    18425 
   company id    DEFAULT     h   ALTER TABLE ONLY public.company ALTER COLUMN id SET DEFAULT nextval('public.company_id_seq'::regclass);
 9   ALTER TABLE public.company ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    210            �           2604    18426    customers id    DEFAULT     l   ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);
 ;   ALTER TABLE public.customers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    212            �           2604    18777    customers_registration id    DEFAULT     �   ALTER TABLE ONLY public.customers_registration ALTER COLUMN id SET DEFAULT nextval('public.customers_registration_id_seq'::regclass);
 H   ALTER TABLE public.customers_registration ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    306    307    307            �           2604    28176    customers_segment id    DEFAULT     |   ALTER TABLE ONLY public.customers_segment ALTER COLUMN id SET DEFAULT nextval('public.customers_segment_id_seq'::regclass);
 C   ALTER TABLE public.customers_segment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    312    313    313            �           2604    18427    departments id    DEFAULT     o   ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);
 =   ALTER TABLE public.departments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    214            �           2604    18428    failed_jobs id    DEFAULT     p   ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);
 =   ALTER TABLE public.failed_jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    216            �           2604    18429    invoice_master id    DEFAULT     v   ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);
 @   ALTER TABLE public.invoice_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219                       2604    18430    job_title id    DEFAULT     l   ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);
 ;   ALTER TABLE public.job_title ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221            �           2604    18730    login_session id    DEFAULT     w   ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);
 ?   ALTER TABLE public.login_session ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    299    298    299                       2604    18431    migrations id    DEFAULT     n   ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);
 <   ALTER TABLE public.migrations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    223                       2604    18432    order_master id    DEFAULT     r   ALTER TABLE ONLY public.order_master ALTER COLUMN id SET DEFAULT nextval('public.order_master_id_seq'::regclass);
 >   ALTER TABLE public.order_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    228                       2604    18433    period_price_sell id    DEFAULT     |   ALTER TABLE ONLY public.period_price_sell ALTER COLUMN id SET DEFAULT nextval('public.period_price_sell_id_seq'::regclass);
 C   ALTER TABLE public.period_price_sell ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    232            !           2604    18434    permissions id    DEFAULT     p   ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);
 =   ALTER TABLE public.permissions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    235            "           2604    18435    personal_access_tokens id    DEFAULT     �   ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);
 H   ALTER TABLE public.personal_access_tokens ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    238    237            �           2604    30747    petty_cash id    DEFAULT     n   ALTER TABLE ONLY public.petty_cash ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_id_seq'::regclass);
 <   ALTER TABLE public.petty_cash ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    316    315    316            �           2604    30762    petty_cash_detail id    DEFAULT     |   ALTER TABLE ONLY public.petty_cash_detail ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_detail_id_seq'::regclass);
 C   ALTER TABLE public.petty_cash_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    318    317    318            %           2604    18436    posts id    DEFAULT     d   ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);
 7   ALTER TABLE public.posts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    241    240            &           2604    18437    price_adjustment id    DEFAULT     z   ALTER TABLE ONLY public.price_adjustment ALTER COLUMN id SET DEFAULT nextval('public.price_adjustment_id_seq'::regclass);
 B   ALTER TABLE public.price_adjustment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    243    242            )           2604    18438    product_brand id    DEFAULT     t   ALTER TABLE ONLY public.product_brand ALTER COLUMN id SET DEFAULT nextval('public.product_brand_id_seq'::regclass);
 ?   ALTER TABLE public.product_brand ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    245    244            ,           2604    18439    product_category id    DEFAULT     z   ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);
 B   ALTER TABLE public.product_category ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    247    246            6           2604    18440    product_sku id    DEFAULT     p   ALTER TABLE ONLY public.product_sku ALTER COLUMN id SET DEFAULT nextval('public.product_sku_id_seq'::regclass);
 =   ALTER TABLE public.product_sku ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    255    254            <           2604    18441    product_stock_detail id    DEFAULT     �   ALTER TABLE ONLY public.product_stock_detail ALTER COLUMN id SET DEFAULT nextval('public.product_stock_detail_id_seq'::regclass);
 F   ALTER TABLE public.product_stock_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    258    257            @           2604    18442    product_type id    DEFAULT     r   ALTER TABLE ONLY public.product_type ALTER COLUMN id SET DEFAULT nextval('public.product_type_id_seq'::regclass);
 >   ALTER TABLE public.product_type ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    260    259            P           2604    18443    purchase_master id    DEFAULT     x   ALTER TABLE ONLY public.purchase_master ALTER COLUMN id SET DEFAULT nextval('public.purchase_master_id_seq'::regclass);
 A   ALTER TABLE public.purchase_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    266    265            c           2604    18444    receive_master id    DEFAULT     v   ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);
 @   ALTER TABLE public.receive_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    269    268            t           2604    18445    return_sell_master id    DEFAULT     ~   ALTER TABLE ONLY public.return_sell_master ALTER COLUMN id SET DEFAULT nextval('public.return_sell_master_id_seq'::regclass);
 D   ALTER TABLE public.return_sell_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    272    271            �           2604    18446    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    275    274            �           2604    18739    sales id    DEFAULT     d   ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);
 7   ALTER TABLE public.sales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    301    300    301            �           2604    18753    sales_trip id    DEFAULT     n   ALTER TABLE ONLY public.sales_trip ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_id_seq'::regclass);
 <   ALTER TABLE public.sales_trip ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    303    302    303            �           2604    18765    sales_trip_detail id    DEFAULT     |   ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);
 C   ALTER TABLE public.sales_trip_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    304    305    305            �           2604    27183    sales_visit id    DEFAULT     p   ALTER TABLE ONLY public.sales_visit ALTER COLUMN id SET DEFAULT nextval('public.sales_visit_id_seq'::regclass);
 =   ALTER TABLE public.sales_visit ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    311    310    311            �           2604    18447    setting_document_counter id    DEFAULT     �   ALTER TABLE ONLY public.setting_document_counter ALTER COLUMN id SET DEFAULT nextval('public.setting_document_counter_id_seq'::regclass);
 J   ALTER TABLE public.setting_document_counter ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    277    276            �           2604    18448    shift id    DEFAULT     d   ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);
 7   ALTER TABLE public.shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    281    279            �           2604    33396    stock_log id    DEFAULT     l   ALTER TABLE ONLY public.stock_log ALTER COLUMN id SET DEFAULT nextval('public.stock_log_id_seq'::regclass);
 ;   ALTER TABLE public.stock_log ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    320    321    321            �           2604    18449    suppliers id    DEFAULT     l   ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);
 ;   ALTER TABLE public.suppliers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    283    282            C           2604    18450    uom id    DEFAULT     h   ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);
 5   ALTER TABLE public.uom ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    263    262            �           2604    18451    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    288    284            �           2604    18452    users_experience id    DEFAULT     z   ALTER TABLE ONLY public.users_experience ALTER COLUMN id SET DEFAULT nextval('public.users_experience_id_seq'::regclass);
 B   ALTER TABLE public.users_experience ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    287    286            �           2604    18453    users_mutation id    DEFAULT     v   ALTER TABLE ONLY public.users_mutation ALTER COLUMN id SET DEFAULT nextval('public.users_mutation_id_seq'::regclass);
 @   ALTER TABLE public.users_mutation ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    290    289            �           2604    18454    users_shift id    DEFAULT     p   ALTER TABLE ONLY public.users_shift ALTER COLUMN id SET DEFAULT nextval('public.users_shift_id_seq'::regclass);
 =   ALTER TABLE public.users_shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    292    291            �           2604    18455 
   voucher id    DEFAULT     h   ALTER TABLE ONLY public.voucher ALTER COLUMN id SET DEFAULT nextval('public.voucher_id_seq'::regclass);
 9   ALTER TABLE public.voucher ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    295    294            �          0    34378    pga_jobagent 
   TABLE DATA           I   COPY pgagent.pga_jobagent (jagpid, jaglogintime, jagstation) FROM stdin;
    pgagent          postgres    false    323   o�      �          0    34389    pga_jobclass 
   TABLE DATA           7   COPY pgagent.pga_jobclass (jclid, jclname) FROM stdin;
    pgagent          postgres    false    325   ��      �          0    34401    pga_job 
   TABLE DATA           �   COPY pgagent.pga_job (jobid, jobjclid, jobname, jobdesc, jobhostagent, jobenabled, jobcreated, jobchanged, jobagentid, jobnextrun, joblastrun) FROM stdin;
    pgagent          postgres    false    327   փ      �          0    34453    pga_schedule 
   TABLE DATA           �   COPY pgagent.pga_schedule (jscid, jscjobid, jscname, jscdesc, jscenabled, jscstart, jscend, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths) FROM stdin;
    pgagent          postgres    false    331   \�      �          0    34483    pga_exception 
   TABLE DATA           J   COPY pgagent.pga_exception (jexid, jexscid, jexdate, jextime) FROM stdin;
    pgagent          postgres    false    333   ̄      �          0    34498 
   pga_joblog 
   TABLE DATA           X   COPY pgagent.pga_joblog (jlgid, jlgjobid, jlgstatus, jlgstart, jlgduration) FROM stdin;
    pgagent          postgres    false    335   �      �          0    34427    pga_jobstep 
   TABLE DATA           �   COPY pgagent.pga_jobstep (jstid, jstjobid, jstname, jstdesc, jstenabled, jstkind, jstcode, jstconnstr, jstdbname, jstonerror, jscnextrun) FROM stdin;
    pgagent          postgres    false    329   i�      �          0    34515    pga_jobsteplog 
   TABLE DATA           |   COPY pgagent.pga_jobsteplog (jslid, jsljlgid, jsljstid, jslstatus, jslresult, jslstart, jslduration, jsloutput) FROM stdin;
    pgagent          postgres    false    337   3�      ;          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    206   :�      =          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    208   ��      �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    297   h�      �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    309   ��      ?          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    210   ��      A          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    212   "�      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    307   o�      �          0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    313   ��      C          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    214   ��      E          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    216   3�      G          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at) FROM stdin;
    public          postgres    false    218   P�      �          0    34018    invoice_detail_log 
   TABLE DATA             COPY public.invoice_detail_log (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, created_at_insert) FROM stdin;
    public          postgres    false    322   }�      �          0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    319   R      H          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    219   ��      J          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    221   ر      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    299   s�      L          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    223   ��      N          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    225   w�      O          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    226   ��      P          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    227   B�      Q          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    228   _�      S          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    230   |�      T          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    231   ��      U          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    232   й      W          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    234   �      X          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    235   �      Z          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    237   �      �          0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    316   �      �          0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    318   �"      \          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    239   �,      ]          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    240   N-      _          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    242   �-      a          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    244   �-      c          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    246   z.      e          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   �/      f          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    249   @      g          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    250   �A      h          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    251   nF      i          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    252   �H      j          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    253   J      �          0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    314   NO      k          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    254   kO      m          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    256   rd      n          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    257   %k      p          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    259   qk      r          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    261   l      u          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    264   �t      v          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    265   nu      x          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    267   :v      y          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    268   �v      {          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    270   @w      |          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    271   ]w      ~          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    273   zw                0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    274   �      �          0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    301   ��      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    303   ��      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   ƀ      �          0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    311   �      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276    �      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    278   �      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    279   C�      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    280         �          0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    321   O�      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   ��      �          0    34580    terapist_commision 
   TABLE DATA           �   COPY public.terapist_commision (branch_name, dated, invoice_no, product_id, abbr, product_name, type_id, user_id, terapist_name, com_type, work_year, price, qty, total, base_commision, commisions, point_qty, point_value, branch_id) FROM stdin;
    public          postgres    false    338   Ғ      s          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    262   z�      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    284   �      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    285   J�      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    286   ��      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    289   ��      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    291   �      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   4�      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    294   Q�      �           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    207            �           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    209            �           0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    296            �           0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    308            �           0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    211            �           0    0    customers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.customers_id_seq', 1485, true);
          public          postgres    false    213            �           0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    306            �           0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    312            �           0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    215            �           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    217            �           0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 2013, true);
          public          postgres    false    220            �           0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    222            �           0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    224            �           0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    229            �           0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2209, true);
          public          postgres    false    233            �           0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 515, true);
          public          postgres    false    236            �           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    238            �           0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 391, true);
          public          postgres    false    317            �           0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 53, true);
          public          postgres    false    315            �           0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    241            �           0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    243            �           0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 22, true);
          public          postgres    false    245            �           0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 52, true);
          public          postgres    false    247                        0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 338, true);
          public          postgres    false    255                       0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 25, true);
          public          postgres    false    258                       0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    260                       0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 54, true);
          public          postgres    false    263                       0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 21, true);
          public          postgres    false    266                       0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 32, true);
          public          postgres    false    269                       0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    272                       0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 13, true);
          public          postgres    false    275                       0    0    sales_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sales_id_seq', 1, true);
          public          postgres    false    300            	           0    0    sales_trip_detail_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 21, true);
          public          postgres    false    304            
           0    0    sales_trip_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sales_trip_id_seq', 4, true);
          public          postgres    false    302                       0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 1, false);
          public          postgres    false    310                       0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 52, true);
          public          postgres    false    277                       0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 12, true);
          public          postgres    false    281                       0    0    stock_log_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stock_log_id_seq', 5616, true);
          public          postgres    false    320                       0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 5, true);
          public          postgres    false    283                       0    0    sv_login_session_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 71, true);
          public          postgres    false    298                       0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    287                       0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 88, true);
          public          postgres    false    288                       0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 71, true);
          public          postgres    false    290                       0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    292                       0    0    voucher_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.voucher_id_seq', 1226, true);
          public          postgres    false    295            �           2606    18459    branch branch_pk 
   CONSTRAINT     N   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pk PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_pk;
       public            postgres    false    206            �           2606    18461    branch_room branch_room_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_pk;
       public            postgres    false    208            �           2606    18463    branch branch_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_un UNIQUE (remark);
 :   ALTER TABLE ONLY public.branch DROP CONSTRAINT branch_un;
       public            postgres    false    206            }           2606    26927    calendar calendar_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.calendar DROP CONSTRAINT calendar_pk;
       public            postgres    false    309            �           2606    18465    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    210            �           2606    18467    customers customers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pk;
       public            postgres    false    212            {           2606    18784 0   customers_registration customers_registration_pk 
   CONSTRAINT     n   ALTER TABLE ONLY public.customers_registration
    ADD CONSTRAINT customers_registration_pk PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.customers_registration DROP CONSTRAINT customers_registration_pk;
       public            postgres    false    307            �           2606    28182 &   customers_segment customers_segment_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.customers_segment
    ADD CONSTRAINT customers_segment_pk PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.customers_segment DROP CONSTRAINT customers_segment_pk;
       public            postgres    false    313            �           2606    18469    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    216            �           2606    18471 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    216            �           2606    18473     invoice_detail invoice_detail_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_pk;
       public            postgres    false    218    218            �           2606    18475     invoice_master invoice_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_pk;
       public            postgres    false    219            �           2606    18477     invoice_master invoice_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_un;
       public            postgres    false    219                       2606    18479    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    223                       2606    18481 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public            postgres    false    225    225    225                       2606    18483 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public            postgres    false    226    226    226            	           2606    18485    order_detail order_detail_pk 
   CONSTRAINT     l   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_pk;
       public            postgres    false    227    227                       2606    18487    order_master order_master_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_pk;
       public            postgres    false    228                       2606    18489    order_master order_master_un 
   CONSTRAINT     [   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_un;
       public            postgres    false    228                       2606    18491    period_stock period_stock_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);
 F   ALTER TABLE ONLY public.period_stock DROP CONSTRAINT period_stock_pk;
       public            postgres    false    234    234    234                       2606    18493    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    235                       2606    18495 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public            postgres    false    237                       2606    18497 :   personal_access_tokens personal_access_tokens_token_unique 
   CONSTRAINT     v   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);
 d   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_token_unique;
       public            postgres    false    237            �           2606    30771 &   petty_cash_detail petty_cash_detail_pk 
   CONSTRAINT     t   ALTER TABLE ONLY public.petty_cash_detail
    ADD CONSTRAINT petty_cash_detail_pk PRIMARY KEY (doc_no, product_id);
 P   ALTER TABLE ONLY public.petty_cash_detail DROP CONSTRAINT petty_cash_detail_pk;
       public            postgres    false    318    318            �           2606    30754    petty_cash petty_cash_pk 
   CONSTRAINT     V   ALTER TABLE ONLY public.petty_cash
    ADD CONSTRAINT petty_cash_pk PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.petty_cash DROP CONSTRAINT petty_cash_pk;
       public            postgres    false    316            �           2606    30756    petty_cash petty_cash_un 
   CONSTRAINT     U   ALTER TABLE ONLY public.petty_cash
    ADD CONSTRAINT petty_cash_un UNIQUE (doc_no);
 B   ALTER TABLE ONLY public.petty_cash DROP CONSTRAINT petty_cash_un;
       public            postgres    false    316                       2606    18499 $   point_conversion point_conversion_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);
 N   ALTER TABLE ONLY public.point_conversion DROP CONSTRAINT point_conversion_pk;
       public            postgres    false    239                       2606    18501    posts posts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    240                       2606    18503 $   price_adjustment price_adjustment_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_pk;
       public            postgres    false    242    242    242                       2606    18505 $   price_adjustment price_adjustment_un 
   CONSTRAINT     ]   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_un;
       public            postgres    false    242            !           2606    18507 6   product_commision_by_year product_commision_by_year_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_pk;
       public            postgres    false    248    248    248    248            #           2606    18509 (   product_commisions product_commisions_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);
 R   ALTER TABLE ONLY public.product_commisions DROP CONSTRAINT product_commisions_pk;
       public            postgres    false    249    249            %           2606    18511 ,   product_distribution product_distribution_pk 
   CONSTRAINT     }   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_pk;
       public            postgres    false    250    250            '           2606    18513 *   product_ingredients product_ingredients_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pk PRIMARY KEY (product_id, product_id_material);
 T   ALTER TABLE ONLY public.product_ingredients DROP CONSTRAINT product_ingredients_pk;
       public            postgres    false    251    251            )           2606    18515    product_point product_point_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_point DROP CONSTRAINT product_point_pk;
       public            postgres    false    252    252            �           2606    30130 *   product_price_level product_price_level_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_price_level
    ADD CONSTRAINT product_price_level_pk PRIMARY KEY (product_id, branch_id, qty_min);
 T   ALTER TABLE ONLY public.product_price_level DROP CONSTRAINT product_price_level_pk;
       public            postgres    false    314    314    314            +           2606    18517    product_price product_price_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_price DROP CONSTRAINT product_price_pk;
       public            postgres    false    253    253            -           2606    18519    product_sku product_sku_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_pk;
       public            postgres    false    254            /           2606    18521    product_sku product_sku_un 
   CONSTRAINT     U   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_un UNIQUE (abbr);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_un;
       public            postgres    false    254            3           2606    18523 ,   product_stock_detail product_stock_detail_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.product_stock_detail
    ADD CONSTRAINT product_stock_detail_pk PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.product_stock_detail DROP CONSTRAINT product_stock_detail_pk;
       public            postgres    false    257            1           2606    18525    product_stock product_stock_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_stock DROP CONSTRAINT product_stock_pk;
       public            postgres    false    256    256            5           2606    29118    product_type product_type_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.product_type DROP CONSTRAINT product_type_pk;
       public            postgres    false    259            7           2606    18527    product_uom product_uom_pk 
   CONSTRAINT     h   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_pk PRIMARY KEY (product_id, uom_id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_pk;
       public            postgres    false    261    261            =           2606    18529 "   purchase_detail purchase_detail_pk 
   CONSTRAINT     u   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_pk PRIMARY KEY (purchase_no, product_id);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_pk;
       public            postgres    false    264    264            ?           2606    18531 "   purchase_master purchase_master_pk 
   CONSTRAINT     `   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_pk PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_pk;
       public            postgres    false    265            A           2606    18533 "   purchase_master purchase_master_un 
   CONSTRAINT     d   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_un UNIQUE (purchase_no);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_un;
       public            postgres    false    265            C           2606    18535     receive_detail receive_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_pk PRIMARY KEY (receive_no, product_id, expired_at);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_pk;
       public            postgres    false    267    267    267            E           2606    18537     receive_master receive_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_pk;
       public            postgres    false    268            G           2606    18539     receive_master receive_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_un UNIQUE (receive_no);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_un;
       public            postgres    false    268            I           2606    18541 (   return_sell_detail return_sell_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_pk PRIMARY KEY (return_sell_no, product_id);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_pk;
       public            postgres    false    270    270            K           2606    18543 (   return_sell_master return_sell_master_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_pk PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_pk;
       public            postgres    false    271            M           2606    18545 (   return_sell_master return_sell_master_un 
   CONSTRAINT     m   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_un UNIQUE (return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_un;
       public            postgres    false    271            O           2606    18547 .   role_has_permissions role_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);
 X   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_pkey;
       public            postgres    false    273    273            Q           2606    18549 "   roles roles_name_guard_name_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);
 L   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_name_guard_name_unique;
       public            postgres    false    274    274            S           2606    18551    roles roles_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_pkey;
       public            postgres    false    274            s           2606    18745    sales sales_pk 
   CONSTRAINT     L   ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pk PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.sales DROP CONSTRAINT sales_pk;
       public            postgres    false    301            y           2606    18771 &   sales_trip_detail sales_trip_detail_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.sales_trip_detail
    ADD CONSTRAINT sales_trip_detail_pk PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.sales_trip_detail DROP CONSTRAINT sales_trip_detail_pk;
       public            postgres    false    305            w           2606    18759    sales_trip sales_trip_pk 
   CONSTRAINT     V   ALTER TABLE ONLY public.sales_trip
    ADD CONSTRAINT sales_trip_pk PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.sales_trip DROP CONSTRAINT sales_trip_pk;
       public            postgres    false    303            u           2606    18747    sales sales_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_un UNIQUE (username);
 8   ALTER TABLE ONLY public.sales DROP CONSTRAINT sales_un;
       public            postgres    false    301                       2606    27189    sales_visit sales_visit_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.sales_visit
    ADD CONSTRAINT sales_visit_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.sales_visit DROP CONSTRAINT sales_visit_pk;
       public            postgres    false    311            U           2606    18553 4   setting_document_counter setting_document_counter_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_pk PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_pk;
       public            postgres    false    276            W           2606    18555 4   setting_document_counter setting_document_counter_un 
   CONSTRAINT     ~   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_un UNIQUE (doc_type, branch_id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_un;
       public            postgres    false    276    276            Y           2606    18557    settings settings_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (company_name, app_name);
 >   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pk;
       public            postgres    false    278    278            [           2606    18559    shift shift_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pk PRIMARY KEY (time_start, time_end);
 8   ALTER TABLE ONLY public.shift DROP CONSTRAINT shift_pk;
       public            postgres    false    279    279            �           2606    33402    stock_log stock_log_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.stock_log
    ADD CONSTRAINT stock_log_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.stock_log DROP CONSTRAINT stock_log_pk;
       public            postgres    false    321            ]           2606    18561    suppliers suppliers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.suppliers DROP CONSTRAINT suppliers_pk;
       public            postgres    false    282            q           2606    18733 #   login_session sv_login_session_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.login_session
    ADD CONSTRAINT sv_login_session_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY public.login_session DROP CONSTRAINT sv_login_session_pkey;
       public            postgres    false    299            9           2606    18563 
   uom uom_pk 
   CONSTRAINT     H   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_pk;
       public            postgres    false    262            ;           2606    18565 
   uom uom_un 
   CONSTRAINT     G   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_un UNIQUE (remark);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_un;
       public            postgres    false    262            e           2606    18567    users_branch users_branch_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.users_branch
    ADD CONSTRAINT users_branch_pk PRIMARY KEY (user_id, branch_id);
 F   ALTER TABLE ONLY public.users_branch DROP CONSTRAINT users_branch_pk;
       public            postgres    false    285    285            _           2606    18569    users users_email_unique 
   CONSTRAINT     T   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_unique;
       public            postgres    false    284            g           2606    18571 $   users_experience users_experience_pk 
   CONSTRAINT     b   ALTER TABLE ONLY public.users_experience
    ADD CONSTRAINT users_experience_pk PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.users_experience DROP CONSTRAINT users_experience_pk;
       public            postgres    false    286            i           2606    18573     users_mutation users_mutation_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.users_mutation
    ADD CONSTRAINT users_mutation_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.users_mutation DROP CONSTRAINT users_mutation_pk;
       public            postgres    false    289            a           2606    18575    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    284            k           2606    18577    users_shift users_shift_pk 
   CONSTRAINT     z   ALTER TABLE ONLY public.users_shift
    ADD CONSTRAINT users_shift_pk PRIMARY KEY (branch_id, users_id, dated, shift_id);
 D   ALTER TABLE ONLY public.users_shift DROP CONSTRAINT users_shift_pk;
       public            postgres    false    291    291    291    291            m           2606    18579    users_skills users_skills_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_pk PRIMARY KEY (users_id, modul, dated, status);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_pk;
       public            postgres    false    293    293    293    293            c           2606    18581    users users_username_unique 
   CONSTRAINT     Z   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);
 E   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_unique;
       public            postgres    false    284            o           2606    18583    voucher voucher_pk 
   CONSTRAINT     e   ALTER TABLE ONLY public.voucher
    ADD CONSTRAINT voucher_pk PRIMARY KEY (voucher_code, branch_id);
 <   ALTER TABLE ONLY public.voucher DROP CONSTRAINT voucher_pk;
       public            postgres    false    294    294                       1259    18584 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public            postgres    false    225    225                       1259    18585 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public            postgres    false    226    226                       1259    18586    password_resets_email_index    INDEX     X   CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);
 /   DROP INDEX public.password_resets_email_index;
       public            postgres    false    230                       1259    18587 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    237    237            �           2606    18588    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    208    3565    206            �           2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    219    3583    218            �           2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    219    284    3681            �           2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    219    3573    212            �           2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    235    225    3602            �           2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    3667    226    274            �           2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    227    228    3597            �           2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    284    228    3681            �           2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    228    3573    212            �           2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    3681    284    240            �           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    3629    248    254            �           2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    248    3565    206            �           2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    248    3681    284            �           2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    206    250    3565            �           2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    254    250    3629            �           2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    254    3629    261            �           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    264    3649    265            �           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    284    3681    265            �           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    268    3655    267            �           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    268    284    3681            �           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    270    3661    271            �           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    284    3681    271            �           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    271    212    3573            �           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    235    3602    273            �           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    273    274    3667            �           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    3681    293    284            �   :   x�3�0767��4202�50�5�P02�2"S=3#3ccms�0_�����R�=... �
�      �      x������ � �      �   v   x���1�0����+n�����4�Qtur,H�b�-���}����z�>������r���։!�J
���ʀKv�(�u��?:�����]��E�TPwKn9�}-��a�!�7��#9      �   `   x�3�4�t-K-�TpI�T00�20��,�4202�50�5�T00�#ms������!A�B���tH�%$��kQm&�\��$��'�6��+F��� G7b�      �      x������ � �      �   p   x�m�1
�0D��:E�!�d��YR�{X��&���mڮ��j���+�`T�m��x8�+�� ��x����(�A���irJ�G!�?ѣb���i���?��Ҥ�����'b      �   �   x�����0���)\:������MHj�)TZx{��]cn�sߟ�}	p����&϶ J0�P�6�ko]ʓu�����NjJ�oꁬg�|��_.-��gմ�F�^S4�u#U�f�U��r�;�_�YIG�%;!���=�Y~���
�C�?�ܫ���U��#m���ߕi�θ� x ��ld      �   �   x�u�Ok�0������Y��Ƿ����(^�t�����3�)�C��I?=�d��T�����:@�����$�e��+ҭE�h�b}�ҼdxM)&}XΧq�.�]b~�s�#�.�o�z���)��rq�W0���Goǯ���>���y܍���lkYWK\�9���C81z����Rb�����q�TAV��Xc�FwJ�gL�d�L?���u[���F!��qS@�l�<`Űe���?e�c�      ;   �   x�m��
�0D�7_q?@%�jv�(>�Q���d�b���i�v���p�#����ő�j���{�ϗ��)|�� ��1/b.P�*+ϓ,���a7 ��@���]����\ݰ�Aj�i�LI�#�NO�b�-�8�v��d*�8�8
��?�A$�yp�Pp��T^������6      =   _  x�m�Qj�0����"�$�I����Z:];���1�-C�y��gɖ�;��t>���8���C�(ZJH%���TB�(+Ml��7�k{;l�S's���@ˣiJ�L��@�iΗ"�c�p3_��-UJr��f�%,��L��s4��(-ڐh��>.��d�1�'��w�P�Xxg�>.<��.�����Xeg�Y{N�8{�hϩ)���x����Bv�:��91�2iϼA������p�q:�����654�wo�lN��؛�j��g�W��x�A��L�����z�����A��Rǚ��r��AV�����C��x��P7�HJs�%������Z�#�      �   9   x�3�44�44���4202�50�54U04�24�2��!�e�e�U���0W� ���      �      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      ?   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      A      x����vɑ�{�~
��f����� �� TYp�M��^�t�4KR������f	�HK����E�ׅ}���p7�C߽�^�o���w_Ǘ��~���]�~�i߹�o|��Є?������C���v?���[HĲ�ލﮮ�'�ڸ��K����ѫb�w�������P=��&���%��!,=����O��g���-f`�1�o�_���֪� 8Bx��K�C�|^�OA������3\��i�M���! 1��g�pi�g������~�&�j�����L �0� ]xy���R^�ɩ@�q���:��kUAލ��s�,�'w��Y����f?~�>���1-����ϛ��K���nh�O��p}qvB��[UC �>�=R���B����~{���O~�YC��nv���Ç�ܓ�!��ǋKq���dO� ������h��~8�!���w�G0=�V���~��xyk6Y�v�'?i A˻C#B���!������Wy ߳| �!�ygx�y2�i?ިB�}>�.Y�͇���n�!�i[x5��.��ClT!HV?0YK�N4�BЖ����6b�� �+��ޏ��nڌ�B@�������w�z_l�B����a��D��k_{�t���!�!n�CX�R�B@�����2@�~�^����as?>_\����|g��������1��ż�'����� �G|���7\�ln�K��jB�������tf���Ǉ/��M���A��N��/bC���jP�����˻?����馧���i�����v���]O��j�݁���z�Hf��雡���{�ZP��DtW�L��A�>E�n�7���:�����xrS�BC���q���:��>4'�IC�_�1Ζ\��UC��w�[�2�������y�"�Pk�y�\x����t>
��!�]�6���sm�Cjݹ�\�8�¥��3�m�����T��#ծ:S���IC��09��|4�0CS¾�M���4�m򧞋�N���Ta�����vq�����Kܙ��ɿ�>����vXiP5��Â��y�
&�ט@�!0Q�q�s��a�`B~�oӬ!0��v���:����oJ�=N���ZC`�����ߛ�>��-���L��j_y�<ގ�7�W�=w��5��/Ke��x���ֹ҇�M2[�K�j�P.wo������������C�u ar�ݴHBwf��3��A,�Vq%��h�5�N�כ�. gk��ҩD�@�tuӿ}��tƭM��Ԩ�:���N��kCZ�A�t�]z1� �V�@O��m�i�r������5�}���>^�04ݐ�WF���r�6kLo�%;��w�1��3��*eApg�:ô�9�)X�h�z�hyM�p�����%��jB�+���4L�N� N��=?^>�GJ��Ub`�i�^�Hj�`���V:�l-	��A�F�}?��!����}I����0<��z�Vk��Oo�W��<UC<�ɉ��0|��ד5��o޸ěm��#/�k���Ŵ<���Y�x��5,D�M[ZU� ����?�:G� ����m|ؾ�|�?����?�/c�χqK'�8m�i˽��]N-��@�U�j�=m󻙱�����6o�޿����������V��{���{>�n�?m��_�%\�L�i'��������J��<�ׇ�"�ǃ[�&�ԟ�TBCa��5W�� ��ݿ�7��RN�7�A�\o%ɻ��:����B�C3���A �!����"�Wj�������)g8�2�A䅷����s2�mp��G3�hO�X��h����v��G��\�Ay�����Œ�A��i}���3 �KI���i�>}2?��RjH���������t��A�2��8v2x)5�#�˽:�HjN� ���ݎ�|aBisp?�����B��s��-�S5�:y�Ϸ�;�S�[J�jG|��O����������$�.��Q�HR&���;H'oa����A�?�S5�� ��/;���5�������׿��Ͽ�j#q94��A$C&����w+�U5d�n�����Q�@\����c�yl$>��m�� �_2��e��L��8��9'�XQZ��Q����|cŘ>k��A�O����YM�kyB�A$9��~�j���z�T }�Ք9Bu���3ǽ�#}hN8H�8(&�����ѡ-�R���$�9��A �M���r� �ڋ!��y|�؟H��R�@��7�m;�dv�� ����0��� J���X�ul���SB�0ȟ~9<�ͯn��4���G��#Gt�/kGϡ�/��w�XǦ�k9p�A��;���l���RC8:>�?N��Iq�	v��UWq�
Gs�����|�tU�_h�im^�A^yK� /���'��he"�� ڙ��v�A� ��>�/6������aX�@ȏ���7�g�\X��!��"��x-4a���� 8y�*5�����iqT:jA�������b�?u�A�47���0�5�?�W5� ���F�<�5��N�㛭�ؚ���Q5��\�K�ø���GeQ�S^k�k�#+Gz]��q��\�Ѿ� j⠳�WC,c�Iͪq���r0;�L�'�ZC8�8������M��Rk�͇��y�f&NW���
���^>��F����5���Ӹ��fV�� ]kH��a�+��5�5�\�Ն���Hr�@R5��-�Ji�����[�Aݱ��ȑD<�� ��$'��8^���Q���ݐӐ�W5��s�~{g�p��ŝ5�í�p��1kGN��l�m������oȣ����
�c+�Z�8"������IN*k��O���ѵi���9���k���|�2ۜ�o��٬A'���H��A�_5�#bՕ�� ޯ�J:��ay��5��5ǐ���D�����P��PU�Ph�z3�s�[�HM�N�	��r��b����_kJ�n���(C`{C��A� �4�xߪE���۽�Am� >��Y�hor�'�AW�|}#3[��&�� �F�����̉�����"���
O�scy%��b�J�p�~�FgH�5��� ڋR��7��G{~y��5�!��n���� j�jb�jW!�D��6{�!�҄^�jBh�<��Z�]k��χ��d^K�k" ���a<�.TB���aXD�����M{�Nۗ�`�qжr%���	���ռ�9�̍/��A���tV��MJ<��`e�thy����͆�C.4��6�'�r����q�a=�j��6�k?�Z�@ȇ~��+�P]dB!g��t���Ȟ˘�(�t1�g6���tA�D�wv�d~&9�m�dY�@���A� .�.��F���5�����{H_���� ���'�/'���eX�@ȷ~>|��2��Ԟ~pX�HZ� _�����4M>Q�#J�)�����]o���QO�^N6I������o�_��xM��5�c��#�f-V3}j�Hſ�ܬ�����@3G����A�{�{|M|_z$�jI�5m�Ձ_hy؏��~�d�
���Ub�Ip�S�͛�V� ���7�@|P5�\�xu}��z6�/�� �A ������<G��5ɸ� ޽nv��$��wC���A��?�n��ӿ�U��$�A$�����a��_&¿L)o2T�����.�#�q�g]��-�гq�c��[�+��r�h�A�O7?]�!���/C�pI��[m:gk)}8�A|c�v����n�5�5�|����B0,�ųp���[C��\�����EL��ş![��h�Q�8��\��6�����T�]�e��:��� ���`�25���6���y�Y��r����ɆGk�J�D�q��	!U�B��c��e�B�A�'��`@	�׫���=%`"x�T�LП�� _6�� �ڤW5�[7?]�.�@��OD/�fek�����L�zDP��/���v�7Q� �����.?�<��Q5���nS'�x    ��}�1��I������&Ü��^g �D3�o�Z$��y�_��0��vSBC`���4ђ�C�R��T��u���c;��=j�ah�p�%UI4B�Xh����:����Y,a�y�A�Q�7m�.䷑��y�PX��Ц��>gk�.tDP�כ7���*�NhBk��,�B�ȯnL��rm�k{�Z�0�ヰs�#�� ��fي=f��Q5 $pUx^ҩRʒ���X�lt�5ė���2mO�iGxw�b���AD^�-��������Hss$�%U��� �tw0]��n����A�͕�Q5���������Dh��=+,��g�Ӂ%&UCP�����׀��:mEh�[Q�:�<Y��A�'��j����a���0��uNhI���$a����$s{��hގ.	k9�͕)�m�����A%:�}2nDr����sB�H�w�[C���X�"
� �:�]��C��_��YC@�Pi���;�t҃!��Ke����)���.[ZIR�	"�8jJ��.�ˉ"��8��U�P���o�v�^�OUB���ٴ�s�M�tL͙��P�� ����AGk]u�D��i�<�i}�qpMD��A4�R>x.LH����RWmӄ!����a�6u�S�y�w{�j�
���Pq�����~��m��f�)��j�ݧ�j�G�']���T}��!�5�6:T1F�A i�t�I�&��t"����E�;�.w�a��T*4&{�\~]uD��Hw�<�2�P��b��ћ�V��k��u��b"�宫n��!����V��Vc��DBI�+I��Xh	tڨWYg8��w��A��O�}|Ӷ���'(�vW�	��{�ޜ��t�V�bu� ���ssڇ|6�[�;U�LS����h�}VkF*����B�0���fo	H���sq���q�o}xܛ��b�4��P*��x�o���%N2�)4��"{5�:}m���Ԟ��Dy4mU?(4�(5%�S�h��$���m7t��j�!4����ۧ;�YK���E�j��?s�)���r�O%�Fv����ej+O,4��S	�4_�>�!���&夒�"!b�䭽��0�TY�,4����;�ʰ�fP5��㷛��K�J��[�T�A hXG�W�B�H�hj�ގ4�Ѐ�&���uS4$�CQ�I6���D�I�����*q�g4�×v�vW��J&��%7���T|]�@(���`��b��u�|�A������n�%4��囨�7�KK
eD]h�ԧ5���p���W��yp~C�k�4�\�ts�9T�R�!6Y���6��An�f�ǔ�D��TB�����
����5�#X�Am��y�A����9�s`�,\�A�Sm�m&�az7Ǌ�q��`
��U��� ��I�e�Qj��jH?��i+ջ�um��1�����y8��4O�R��4���]P���z�K��������:Z���AP���|m��� O yJ��˰���"�U��a[���l{�A<h�Ʋ�&���U��N���f���p��$x�ַ+�F���櫻�A�4{5����m˞�/IX�H8jk�ar���"4�.���s��N��!<pj�A�f��2�qp����-=fӠjGր��
�	������i�h���� .���S@�W5�#3>L9wl�W�.�A(��/��o]6X7�q�ק��Vg���:5������c�lơ�U#4�c�I�_MW�d4�.W*k Hl(:�[�B��z�	� �zm+B`���ua����M�4�Y�E�����6�g3�PeI	"�~+H�{U�HGԦ�%@�V��JB�H��^IF��4�A �HY�8��˜d�V�*�*4�dX��>[u^�G��z����aq�;jg��T ���q�h��!��U9JB�@�T�'�&��e��?�h/��8S@n�]�Ĕ��4{�����L_�AH�ˋmX[Wf��� �/����N�!b�viB� �&a�0>�X���B�y�l�1�Ѿ
s
ʪ]A����Dh���.S�DGm�]u,4ĭ���
� �G[���v�XhHS5!�.�Ȭ�s0��PL���ikti4{�d�|��׎zV_�Մ��+
��f�"�B�8ؽ�Jg@Z側�)IX��86�W�g�����)߇�Ʀ�q
!	͚{���"u�Ew���x�e�O�Fc��&4�}�v�X\:J��%")e\��#6�/ɬA qMZiG�J�rs4k�֭m����QKhG[j�,�g��Wa�A�٪L#�O�Am�^�Znl�h�G	a�z�h�~`�u�*�! \�u?��W�"�(4���:����D�Wې���j��5��}���!4�t9��U�@"��\�bzl4T�iB�@ث��ގr���A�U￘�5t��p����,m���ᨡ��A<,`c�]Jk�F� �����
��� +�N��jOǀ>��Z�Ѫ��y����������5��>�2����rP5����f?�_�IB��"4��<��t���vs_�^� ʵZ�/EG)s��ݜ�O]*kGϭVw��dtڄ�Q����S�c��d�ب5���b-�5l3Wը���<#�-�ǬAt{�y��Y&yu%��5$p��u ��A q=H��5�����W�/[�
��y�v����1W����&ă�A<�eG����qp��5D�Yf~�@XC8�2���y�n�e����=m�w�jU� x��-;��æ��A |�_G�U�m�A$Q�������������昨Җп)"CFsF�W5�+m�v��־t��#����>���t�b�CՎJhGT׀���a�Ygڗ�i��� :��~�Z�$�hW�	ዪu$C��GhI(�^�"��J�W�x�ͺ��� �Tn�M�gd4խ��PH���;�]X�0�ҐҺ@Z������[m7�l4T��A �]�1��c�q���2�& ��Ԓ�iU"�*kl���b.W	k��޲jg'$��zU�@�[=�Β��� ���j�d�а�Xe["I��)��F�rG2kH˥;�h 6�U��A �]W��fy��5�����y���jY���}:|�n���� �i�\7��&u�����u|9�9Ra�QlL��l��"$B�@���i�{6^��\"٪D�����h%�đ���T�IVsӠj	�����;S>/���d� ��>Zn�z���aP�uFP0��D��Z���h�c=�U���S"~_�8�竣AP0��z��� ���Q�8��ђ�ؗ��ڃ5�����'��d��VY�b�U)MB�8���*���5��]�Qυ���͑"��p��A �Mׂԧ���%�gGlT���Z7�qgJ':ZmU"Y7Qk�z�ZY�H�M��K�{�U"	���&C&Y	"�k:*�F�=�� ެn>Z~���	�h��M~����D�q��Ɋ��jR�� �y�����2�m�-����U]5>KhH)�ZK"�F����q�2>,O��p(��֐���j{$4��Ym	�QyB�uc:N�9-1<��1q���a��v�:���oN@{��2:k=�O����u���usT�(c�M{�٦Ls�A���ޖ�MFc�Gh�[=l?Y�|i��ʗ�X�;�M'Ϥ;m%�����&�f��J
�[<���M�2�|oX�P"'�X��d3,�{	�ԓ��,�[��/+k�֧[k|�+�K�� �xx2ͅ�TST"�˝�J�UB!���q�ۘIr�h�j	�κ2��F�r���pp`�:�1���~� �r�DKf�.������ II8H�;9�9b�[ChG��e�3�Z�šb� v��	͔�3�{M׫�RB+�b:�� �����͸| �1�x
���㝙#,|��pp�գ�Vo(��MR5�����#*�#«���ƽq��;<_EÅ��M��z0�� ��O�R{5��z}5��\�!l�yU�8����T�?��
�3k���'�    �`���A�-p|��0�1�		��������[R���5���`����7�5��
Z��*.�
'�#�g����>�coϐ�Ɋ��p��Z�T")a ӥ�L��Pu� ��bjw2�Eb��8j	E��|�ap�k�e@>:��B�8�r���TR�P࣑����m�!ȷUjB�Vٍ^&h�'Vj�J���U�5�A ���w��᪾R� ���1!��ġ	R_� n�g��ʋ�A<`�?\|t&II� ��ܴ[B��(M�mt����t9�y�R�8�g�ǝ�z�h4xU�@��X�Q���F�b���U�8J��nk����9�D��O�dٛ�^fSI")������h�u�R�@إ,�D��v�ώ�QZV�t�g���ՈR�@J2�J��k	yֻ��ɒ%����׈����b%J������R��6�-�S5��m����l�D=����A(n��Z�ҫ���irb6�>��T!�;��-ME�f������GK��h24�a��*������l��_����e�����h�yU�P�2���s���\5�SjA_R/���|��5����s>N\$p�ABh�#��e<�zY;,5���N��.����Z`"����'�B�Qf(IB�c��i-��S]�ʴ��|�"5���.��\�;q�Y�ڲ."t�h���A|e�y���ܱV\�H"`߸�ZR�	DP.���ᛥ�4�r�+v��R��h�~���ȡ�R�@������*�(�Ab�A$%��R�r4*7�B�@h�ye�Pl�2�Gj�Ε N�n�R�������r���5��Vr8�} ����ԙ�X���Uh	�J�l�c�����P�Z�z~��М͇N��{7�Ӝ ���@�mI�  ����<)D.�C�a�9*Q���$b"� Q�������vLB���gl��K}?��md>�� ��i�'��n�	͙��|�AD�٩"�#��C� �<ȳ�`�qӈ���B�����M�C5^jR���1����ĵ���������%�r~����"EhS�d�{u��\74�o�<���Q5���X���eP��ѶW5��1V�zS��v�ۨQ���;6kg_i^Ȼ�b߷�'�Q.�⧚5(�8PX|ώD�z���R�]�L�1�@y��A@��z��V֐�~z�>�D���%U���Q�=>�Z%�E������s��O�k�p��������}���5��c������~����U]t.�_l����)U' �AH���|xت��C��V��g�N&AJ�"����u�Jn:�M�z�0
M�A� "r�?NԫDD>�e�e���t!�]�~�i��5�����^���Jj���9�<�Q5����}��OT>�i�n "u��T��ޢ20-��AL����d�cs�hy����)��a��:R(0��T�r����.t�y�kSS�Щ��ި�J]�O��ܰZE�=��AH\.�����|iq���A�K__�76�i�߫����l~P5)���e
��ALI0���%����Y�h��Mw�i}��e�S�a�jǨ�(�"R����Z��4!�i��;�y�ᝪAHe�׏���u�<�CE�N���H_ۃQ~��Z�fE�:��.�{G����-�m�Z.D{9h�/�76��W��]CyU��x¢V}�cW��$�J�������b4i1Zg�I|C�W�>M/Y��阯-�+�ߎ�1�%1�Ew��6��i(����v� &�^�q�8�����0z��^;U�J�N� �co�D��!M���S�3v��0͓�~i��X���_�Gm#��e}�:]H�}N��� �ADs�0�3뚡m��7-�]G��DD��#e�k�,�f��(G&�#�� ��e>ZH$�.��O�7Yϟ�%kQz#)�>lm�*D��$�5��"gF�`�r� ���[a�T"�`�V��^摛Z�A<�<��̮6L�\:ݍ���ՒYfB��8�.zPZ~y��0�9�(��e�I�!L4�L����קu�OC}d���B����!����zߝF�z�2T"��ȳXw�59�F��:/�Dn{���
�.��^P5�(rK��n�OO0��u�j\�� "�Q����AD-O%�t�c���"kB�8�Q?�n���R�PZ˟����g<<��J�\��X]���<��6���vB�v��D�9;s5DiN~ڝ�K8��b�1k�h� (��OgѴ��E�A@��Y�*�rd/��T�h��7�Dx\��i�����X!�?ľʖD��z��� 2�/�\������R���������U�� ����M�l3U�B�8�zoT��]��ݡS�d=oP�O�5���P�΀���^h�P2����ݴQ=s,���r��9r��z�{�lڶS7b��^� $�ִ�Ԧ4L�U����wU�� &_�B���wI��#۹�A�jO�vv�n��f�\:��s��}�1�NC�9J��U"��j*��n);jG��Iw���U���?��6�[����ꍥf"�D��)��3���O��]![���B���������M�7}ן�@2=��F�O^�����ۦi��_,�F듅�  w�(j �I� "�����7 ��U�AH���O�3i��X�	∥g��������U5��"�/���(��N�!&U�@:n�tm
[D��5�FTh�-Ƈo�\
��ϫ�OȩQ�Q5��l�MU�"&�:-���ݣ�E[,)�bږ� �|a��)�1TW�B�08tl�]&����*5����ip��ѽA� ��-Q>o��A0�l<}$�A(sF���OFS���jmv��oz�L?}��k�H�h����qŗ%NKrU�T���bU�^hưc��.>ó�`pY��Ғ���x� �ˎ/3F\~�g��ʒ��Pt6��뼪A \P�
$V�b���c��U=��V1(�A(�'�����KJ�.RzT}�+4���S\�m��I�A\�}�E�}N��}�R9F���ab������˟F�c��4մ8�AD������|wz�D�]ݦHh��m�l� n6S�ڏ��{�ݳe�A6���H��=j���F_��q��A���n3�ب�&�I������m�*�IhG�4;�"�Zh��{[+�D��ChGo�W�O"]U�/4��>m��iU�!\��d�ي�Ð�-�!$\��tؿ�n�$h��Fh
hף����k����J�+���z�n�̧:�]hR��������A �eׂ�� ���pc��%���Wh� ��>�� �O���A �gW������S5u��&�B�8�y��|��h��~�ݶD�؅��V���G��
�_f� �Ѷ�0�TR.]P5�f��A���#4N� ��x�~�R�s�zU�8����p�EgYV
bi���ƧB��S�j	{�q7�N�$�>"��>�t���$�ث�����E�w͋��!\��m{g]"=��5��������t	:�DB�u��Α���B�8ȵn>=�ߎT ���Q��I�P���P.����?��8j'�~|��Nt�<aP5��k���q�l\��o��A0�X�äŚ=j�����
��*LBi7�1���P���gh�b)��߾U�W��I��1���$2Mg�y<c�jH(�^n�$�?@U�$4��[�|�7���V�;TdB�Xh#{�S������n�#4��+�������kRsK"��Q�DD�wcʼ&��Q\�
� ��CF��aP��t����4�]��� =�~STu��H�T 8�
�P�Մapr��>�l����qpn����gIhe�d�[��B7j2FhgĮ��q�6����bo�=f�(�r�J$��|B�@�ұ|H���
���颞mօ=BC8�.l��mE��H�w����u���X�0!M|�j�?^UIXnZ��p���-�-=$�A� �X"��PVK��}u�(4��Z�ЪBZ��n�G��u�T����W�{�NBU�,4���v��Dv    ��61B�8�Ըo��GFS�
���pu�:���jB��\�`�ޖ٪�W5��|���n����/C.dT��/��AH������eI�jI\���j�j	�>�>V�z��3�fJ��܋��A(\��h���A�U��� ʇ��f��;�z
���nk
d��PW�
"��c*�iKNlT��vK�S�낏NҖl���`� $��oM�dt��4I� �������o�|���}7�����A,!�����l�p�H�A�π��S�Y�
�H�����c�a�$�r�����׿��+�t�q��A�����A�[��u��O�<jI)���?��� �! \ҵ���ׅ��V��$����G�D�K��3�mv���Q�8(H��c1��]�A�����A��M#�\�UE
�IS�AH�ϰs]��(��]��*o���������?+��|��S����勜fZ.A� ��g��l�LD2�����A(=ߺ�=l��}w(_ru�q�v:�Y��7�BC@ϙ�h�S �1VQI�A ܷ�S�1����	"����v��ѕ[}^R��Mg��t���e�A ���:�^� ��3�2�\�KhHi���c��f����O��������o�D��ԓr��BtM�k���*� 4���m-bl�N����^�^.�D��<�I�e��߉5���~gi`Z|gb������J�\Y!!4�#�ӀR��C�8�z��$Y�uF�� �X��^�ݧ��hv9n��፪AD�|f�Α�{U�8x���T0�L^� �0�yT�Oyq;���>e�AhR_ʝ������N��yKB����m�f�J�^�T��M�u��Hw�At����U�8���8����}O���U�kL�T `�5��+��4�����ku����'�t_%딯�jo}�2�\s�]l��·����\�o�>�Ai~O �"�AP=W���l�[�P��3�^M����Pm�D����`�U[*�]L�2^����X��������>�.��!�tG�3@P5�ȗF�ڇр�$��%dۏ��~��,D4w?�iz׽�h��O���|F�AD\���5y7-��e�N?��t"����-%��Q�Es�A ]���]��%W��	"��Ǖހ:O��.�Ӑ}O��n�C�D��YOʹ��ͨ����~Tk�-L��AL�xR��t��T����p�[��>�C�n�9=jǄ�ʝ<e0��Q���y^ՠjQq�W���ds�f5N� n�x����²>������0�{T�?�^=*�ƻ��Ш{�|���e�q����W7��kR�o/�����w)�I��Ҳ�Ih�P���#N_�i���b��ȣ����HVݔKh�a[�o���p��1�{7za����A���Of���� �A \�{7��y���Y�j	����z��3(ub�� ���AA���V�j%@<����엧�Y�8z��j�h����[U�@(��$UC@�>m7����f��O�Q�8�`SF���j�՟67���#�B�je��䨿3G�=�ˣzu⺡w�k�@äB�ē�\��x:U�x�|⏏{�\���M�j	P�O�l���"�B�q��F
����^�A<����J~�_r���7��w{g*T#��'���B�H�ܿ����B�8���޴U#�1-�ޣq�`�@�٨�U������#���5�#q��
��jd'4��6���흍Ó��qtg��t�bK�a�&5v�T��	� �zc+ a��ҡ����l
A9왃!��Aŝ�9Y�B�8|郹1�0�BCK� ������GS/[2���B�P�����Cu��A����W*�<������7�밡4X���Aw�~6�$�h�pF�@z��Y_޸<a	�P�J��(4�#6s᳕#���Ae�͙I�C�^�Ө�P:q/���\��.�$5U�Yh�^��绦�N��%��y�RX��xÏ9�jQ*�y-ILI��q��A �mm�f�^� �n-F�<f��ѯ�Yr�q�j�<�&�06nPh�h�\"�!,�Y��O��d�5����9NtAݪ�Q����INǫ��q�m���U�h�A���X��9�\�{�(.uG��&��1�Ɏ9>t���+3 �|c��6U�P���N��T��jA��b ��Y� �zx�L0�o]C��lI�'�7��>X�X����h��PJ�>�����WQ�1����9�h�FJ���2B���!�ۼ{Tn'�Z�NI�J!,"GB*���dM�5@9
�)�j��zգw]�}��L'��Q��:�^��H��AH�2�rК.N{��;ܩH!V��B��8_�ZMl�����GA���,m�W�@]�i�,��3���5��I8/֓{�/U��� ��8�RW���"����6�,/:�	�)��Ղ7�������|K�3ג�A@��[?BT��J"j���L���r��$��z�A��0/5�����5��>6Zk6�[�1EjR� u�N]j{�gG(�!L<��z�I`�ۮkb<ر�ܿx��X���M�8�W��o~��B"���}7w�v��R+���D��i�R���kM�Բ���_n>��D����_�ţ����e��\q�A ��~�������D���ϝ�W����� �4�o,/6���+�A �	[b��fu���Q���,�T�	�RZ��n_��a�ɞ5���|� �C�ȸ�� ��kn~�����#O��5�#f�������l����A �6�?�����044>ZMN� j������wG�e�>��ѽ���������nh$|4��A =����ߌ 1���N� �a=���I����i��?����5.WʦY��fcq��������?�A�ߕ�RZ7R���B�����n����槒��U�H�����/��WJ�ћ^�0r��������ʒ�A�0���_�����qv�W5����_�E��{�e�A;�a,� C�|6�R/�^�0n�h*�d��V���J��z��s�Z�k	�=l��vP:K���a,��eZ�RM���B9bצ��h�|�g�%X{$9���=��iu��+��0&�m�q�N�0����Z���h��+5���ց,��a ��0��-T�8��FB��Ƃ�W���5���=o�_�!ǵ���a e ���d2�慎Ŧ�a(�v�?L%�l6_�%U�P���w3GC�?�[U�P8ql�_8��������d{�=�5��G)cz���$5��tw��h�j/[�I#�gIZj��j����r9f���7�FR
 �����>|8�a(��<?���ߔs��L�t�YԻ|�]�H�
D����T����(�aLY������p%���	cI�|~�������*�_j
�pגԋ�a$�c�j�t�T5��F��c+P�sU�P���6��P)�>�ԝ6kg �sW5��>�{K��l��|���>j�<�g��R����ݣi v6r������2��ў�]�P���l5zU�H����x��I�U�W!�a$m�ȶ��5�J���%R�P����f4���V#�JT#
���+�S�� ��$�_&K���ezU�H��"�t a������;^��v�a	��F��B��S�j�nǽ�d���d�a,�e?�N;������wM;$w���>�dWf�aD�m)TBÐ8�1�Q����0��9�p��'��a�)M�woV%���Ww�B���^���?���r�O�)FjC[��|��h�ث{��18.)}8L���Uo8�a������h@�б�0�����$�)�.�M.�&���z���T�(�i����W#�Ȝ�jDɠ���^"�<��|�a�6���e�"��`#�����1���N�0Ι}~�,���h��Ub(�dyEܿY��c��r�F᎗���h��a<��ڀ��hU��YRi��	}�L�LR�ǖ�e��a4��o���� 4�v��� �KMu���Ο�"��    ��NǯӾ�3��'��q��骠��0����![�@�Q�S5��',��.�f:��
�ߐ�jL�<�t�Ű�jOw4��a|��8m7.���d�a��c��|��7�a �K �j�%7��UUh
��oM�)l�]�����$Hg��%�~X�F�r�ͳ)#*��F©YO�K�2����U#�>^�{K3�b���v�����|�j*b�v=����A,����vڒ�ԝ��H�$��<R�`h��q��)&ҥ��ጆ�r���t�hK&]��A�����n{)��&��R�0������e�C���O����pK�0��Q��v�b�R҄�1t�r�.l#�86K�Y��|�_��Rht�(�|��]�����!n�����U�^��p��1�����<_����P:U� 蔿}z��vzʰ�5!�Ѡ&��
Ih��w��'�z�e
'=8ib`Oi��{��jD[ v7�?��ź���0
�F2� ƹ�x�v��q����4�#͑�*/Ih��7�wv��t�����$���.s��mJ���8��6m�Ir��W5��7���)�ޫFJ�V3H�ڨ»ϛ�eoF��U5����GSp���;�^�0�ve�*'rU�H�r*����o�e���a<��qz�'�e����FB��6?^��U��A�LA��7��l�SK����u��f�l#���B�H(djK�"�!.�5��q�q]�� ��a��@����� �u�0��L	�d4���h�0��4�����M�nх��t����"u�0r���f�܍lP5�6���Ll3�El�A<��V��6�"Zj���e�B6��L������ޒ���<���x����4�t������Qh��_��ڤ	�H< ����J�'�,IX�HZ�5}��hrU4[h��L� �Y��(���0���oM�.Ȩ�[m�a 7��?��V�B�@��M����S5��۳����7���zP5�$�~zo�T6쫚�a0x�}�S	�˫\�a ��]R������`9p���ɖ(�a(�k{k*sHԒ��B�B�@�͎�۟�/O�w�qP5������#���Ch��>oL5�d6�}���p����&�)Ta`�a 4�kc��Hs�V�jE���D�U�@x{x6�0R�����f�0�XZ1[wl����Ǚ5�����$�^�0��7l�R]6�-w'���p��)�J����q�v�(�b9T�q�a4ú2����-�����(��Z]lGo��a �b?����\�1�T3ߤ����w4�F�ծ�%F��qI�j	mcӉ�NR��F��}ɨ󪆁��|�YCr���e<�+�֒x]�Hʬo��l4��ewW�6���T")5V_��g�;S,�ɬa$\��X�A踧jH�b�>��A�0np���LM��j�tI#��V+A�Y�@�]�����?�ji�@vs�x�jK[������+P������2�௶���uI�0�>�BkI��j	O'����2�Z���A$}C��~�����ʬa<���_��w�P���;�xz&�P�e�q�0���߿�8�S�b?}�0����_�.yl�[�:G#�ց�P95Wj
{�}7�{O���G�a$�d��_�i[�lu�Pf#�}��ȭf.�����W�Mhel��v���-�6e��� ��z�ﯟ�(�KW�0���[Ss��"9�a$���ɾTr����a	����t8n������B�H(^��J��d7�*4+4����o�of����0�����Z��Y����t?����a(�k}{��ijU!G�o쏤W~��u<Ul�{{r]��B9ۇ��
��>Ph{�5 ��OB^v�����2P��T!'�
��}	I��cJrhK5_hT)1ٽ%Ϗ��:�Zh'��:˷���ޛ5�_�O�³��PD67�1r�:
*4���km�ߌ a9XYh�_�6O�+I���N-B�H|IJ�;�B�Uc	e�hJ�o)h�1U�P8�`|ޛ�G���a(t�u��7�H"�1T	BB�HZ�鞞�� ���h
]{=���-l�r]�j	9ٗ��x=���>����kHrՒ�5��giMgѭ%����z
��0���?�2bZ*�KK�?k��Ԝu$u��a$aE#*2:���Y�@��>o~����TC!'����Q���q�0�)�����^p������?�*F�h.�kT�ׂ�f��f~ ����Oã�֭ę5�6�_m���h�P5����6�Hy��*�a ��=|4r��~�T����@[�Y�@����FK��l5�����Yv�v��a(ܠ`c�u<�
���G)�\����h��	U���0���}�Z��f�^!A_.��l*��m����Uυ^W�-��F��@��a�E^_�������a$��խDTC�8����{Z��:U�PJ��g㎀�z�����x�k�,e6�*���	m`�6�w�Q�A�0��k@�*�MhȺ�kN��O�kH��ؕ$?�~�MR�el�5[
	_K~Š��h������j�{�[A�t#��:�a�9j
����_���'��z�x�0��˖���Iō�a$�v��.'�4��#)�
La6��Q�a �K0~��4ds:�J�&4��+��/���ۭ�T���8�ܱ�8y
d�j��ɐO�/V��W%�B�H����$W��tB�H"ws����j�յ��0���ؚ�w���W�z�a$t׵5}��&eS��A�uG��&B�8Ȼ�S5"��»5����6M['�c�U�H:
<ޘZ����9y$�a ���)�Օ>+ѩ��y�)夣̟:�@h��nM�r2�ꡔB�@�mi	m�*OhHi�e�q�\gi��ޔj�F�j��0�SYsG9.�:��`��`
5vs��F�0����ٮ��nt�ɵ�y"),�٬a sC�e9[m���a$���<A��j߅��N��j]%1��
K�0��m���_��]o�F��)����~���˷g�0��GiRP5���j��ԑ�X�	�W�t�Oo�ṪkH]�)4d`7k�Y�JF�b'=k��:��$Q�y�j9����۷9���f!'��S5�������5������?>YcH9�c�j����p���xk���ّ�V�0���d﷦�2�c��EhJ���HG9n�S�5���FKW��z!�!,�i�Yg�WP����\Ϗ_L�ó�E,i�0�N����f):'��~lB�@8�`g+}���ΡF�s�ց�N�0�|�}�==��	ۍA�0��O�1��f����I���\��ó1j�s�S5����֔oy�ګF2�&źPrT�J�R�u�%�U#!'�i�7���j}�9j	��>��z�Ԫ�B�H(�xgڷ�Ѯ�2;�덥~��~�k�B�ٻ�~k����'U[H�a(-Wߛv�}�Ƒ7�B�H(�h"����Q&v�nS�h����@���ÜT4��OEs�z.*6��,�#�����ԨO`ug.4ĳ/��n��N����a(�L.1œ�j��Eh	tm���7'Р�V�0���O��0YM�:#�ۮ[l��}��"4�o�L�s���ZU�8z~ ���P�BUU&4���a�kS�_O��P����Ԯ��7��-��0�*c�;�ј���0�׶N�=U�֍����pS�����&e	�(IZf�i���a�s�4Znf��b��0���o�e����lTC!��ise&mu�#4��ji����I�0�����3���F�!-��a�U�Y?3=5����qp�m[���.Z�
����fgL�/^�Y�`"jl���դ��́+���@zU�@x�����󞽎5�t 0�h��~��f�yt�����鬟omZU�Xj�;��;f�AAA�GT����t�4�@du�O�5�����&i����a$~�d6Z��)�[�s�S�F9D�h_���*���pC�;c�"��i@:j7�����������Q]?�jf�N!��ຶM�� ��B�@����J�h $  �a�6�0]:��X�y�a ���{|���c����	C)�W[��:7嵣�0����O�:� ��0�Ү�z�`�� ����dac���,�U5��������J�g�&U�H(F�ec*�c�}��Ehmd?[G���'U�P(�:m-��d�wխ�� �����t�E6�E�ڎ�A{Xc�lT������ht�����]�Z�h�q�������/���0�mU�Px��:��V�a(\�ek�AFc}*4����[K������x�0��`Mai6z�)�5d�g_���62�*�EhJρ�U(��~!4��n�n-	�]����Jh	�+�7�����2
����L�Gӥͥ�I�0�c�+g�m�+4�/��wKd5�*+4���k�q3�$�H���p����7�����V�0�'�~s����B�n:�[�IC�c�G�;�χ5Ӽ�R�悪a <����j���ʻB[������c��Gb
ò�v������䍩?Y�@:U�H(;yz[/-6�U	B�P���21�nz�M�5��>ٲ^*��+e�0�h���m.�&��qp-��a6�5$6M����&�ͺF�0nXx3AX#'l�W5�ŗ��u(�d�h4)�b����c멆l�Xܲ7r5�Z�E����WD.�z~|��Y��:�Bh�r=�������e#�J�͍�/퓪a(=o�ב�L��\���h��8[]|g"�]�'�x�B7������k�
%)(`Lt��썇/O��%
k
��~���g��:~r�0����~��F�J:���l���8j�gF���hjU��_A�5��5;���>�Yrk�N�0���
S*m�e� ���m;�Yo!�����sk���V�����0_:<�o-�%g���a(��z�~l4* `�R��d�^r����%?�"4s*C�j�׽)W����jI;7���4\��/5��{=��G�[���җ݀v�k��R�4���*�Z�5����h���b�Q��"�{�,��b��._j	�!�S�&�V���0������R�@B9�IB#�R�H(d�S�_�+�Cjdj��0��?����j\�1�����/ϵek��z�٫�R�tY������ �V�h�e���[�a O)���g�y��rW0kHlʷxI'A���p���4������F�0�C�r+5��cǝ%ҨРjJ���T�����5�$�&y��Ml5U��R�H�Ǿз��''ߔ�X��0J��n���$
2zU�X8H��p��j��0�ҿpkIe�),�ȬA$��P���Ru��J(iI/K4�������4X [���!g�0�p��yqϘ�E�x�0����.�HẮ�73H̓�Ti9��2��˳ͬa �e��^�J#�[�o3}��r�����g]ER�l�DҖ�����l�ˇ�T#��+�\p"6{U���&�l6'𵪆��I?W5�v�߅5��s�6{[�����F�0޵�0�I~At�h��ߝ��$��s�a�TC��Í5rDf����`۾�-W[�j��󳆑���}�i�e��5�gs�������p�بF�[׵(IAA?�ͻ�ܙwC�5���jm,��G�g4���������䔎V�
K�Is�����.C�GCa_���
[��~G#)�vc��)VU�H�Ry�?���l6((����v����h�[�a�y#���_ȏF��TCC�l4��2R�@h;�����ANvgvk~�'AjH,}h֑�����r&6n �jR�	V:���ǿ�ۿ������      �      x������ � �      �      x������ � �      C   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      E      x������ � �      G      x�̽Y�9�,��w���v >�_���.)dU����:�~܏0UN�y��d�
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
DYB}��v.�;�.yN��Q	��=%p4�>��XK�X@0��A�%��P�Q�ra����΢�"C�j�@v[�\�T�춋J�T7N��m�	a瞮�C?�*�X������>��ύ�X�I����+n{�<��p����"bJ�d�C�2��lE�ۅ��Xn��j4�XR6�y!<��o棊u�4�fo�ø��k�UŬ�&ȃT=�F�Q>��nT1ҷ|�!x���'3�8p&5���;�bn���\�"F�����v��y�}c_�k�*�15�-#�<���!K�X�i�65Xll�k�c��sU[5+�U���L�p����o1�f��u$_k��LN�#�65V&4�7�?��z�-�fq���'��7�D�2�>"ͤ�����-�qY����ܽ٩B}󎖸�v(JAJ�qľ�sl�FyN6�9�T�B%���&M����G����/aV���`��8�>���?�}����Y�W��Hu���#�dp�%'7m53�G)�ౚ� ���-/���Y���d��M�,	 ��|�ݩQf�9���tO�0M�Kݝյ � )��i;���Dޔf��wİ�6�g>��hh��ou�Y�s���.���d)��q���˦^\[=�p��D�b�a&��E#��I�¦N_�pc�z�\��}M٦�-�c%"iM���û�e�<�W7�
���6{1�-��sw�s��z��(l��ϸ*F,T�Ш��0�@�5?Q�b�'�]6y��l��Cw�7$݄!sa�TW-�6�0<�����Cg|��<m�9Ǣ�b�Zu5m�9G8Rjn�6��6������?��Va�[\�� ;	�6�)L?��͚̭h`�(�ku� �s<���Nq�4�lڸD*F��Igu�}�3�S��--a��oP�p4Ŗ��t��`�g>�0^]��$�1�M�U�9�P2�T�7c�R,�i�*Ţ�AQ[C�i���0�4�B#π�R+H�����e�p�Q\$Z�p�d0�!5����iS�Ɏe�.+oY�(�:��!42���	��0m�oD8T���5��@�M�MZ��N�R�����g2�6��Ӑ-����    �7�EWXք��7ل+3P���JU�v)�U@gյ�$��������h�����+(�����O_/���8H~,��RRmL������/�#��G%I�#�T�2��sb ��M2����O�¨O��b�뾋ҫ�չ����f���i_l�E	߂Ukܙ�(�����H�eA/Z}3mZq�P:'{�uN���J���
*6�J��9�A��p���#�d�\(o�T�MV�͉�*�\�:j�l���:� ��%l^�8v~ۅ#o�d�Ӹ����a�q��*<�U�򴑂I���-��Œ�a�����Q�a"E�M�,6=�����/�B�݀��.�-�;D:���g���6E��
�NXMt�&���a"i�{�=i�,ǭR��9:ǩڎXp�<�6� s�ZO���e�Bi�������#�H�F{�0G�/J���[,���n>�=�>�O��q��>e?���I���L��$bA)	`����ۇ��I����`*mR�����4�6G�>M���]��pf�����!+�(�.x/X}4m�Ԟ+b�i$�����!޲�������i��`D�3��Q�Hm3�pK���i�Ԗ�G\�hG΁rp�v��?����3��$�������q�-wN|%	h�w�5d��X���&�2�Ơ*�r��)�,(6�u@��$������W~��V��6���H5���or�ԃn�%U��q��ծ��Yđ;�D����·�#v��P�x�M�?�O<E�"?��ɮ&�Pf����7j�)�}0!G�jQ�z㢾�#20d@V��ٻ=��Xq����~�G�j���^BŐO���OG�dz(o{2 �����t譋����O��ѷ�9N���*l��k�*�`��~E��C����Z��9���N�qXs�5����r{�Ɋ��sTdXM�'�I�w��E�Fmo�qD|����Q���մ	���鲡�����8�cds��4)kX͠9m�4�؝�I��"�����@#�{({���y��*c�ܤ�N��N4�L,�(�i�7�_���8y�o1����l����v�p�d��}����M���Y #vm] �흌$�}����q:>�ic+!ę*�J�i�� 9�4S����L�Be��P��*l�h�	ܐ��[\ڦCUyb�<a�i&�~M��ՠ�Mae���A���AmI�}6m��g��m��\(��b�u�t�̎���AcxLM�^b?\�&��l�c��(v�ɛ��c��9G��:���j]�Hc�R�=^ɱRK�l���8B�?�H����!(3�u�vb�/|���rv��g�L�ҁ�7�V��.�����xOK�f���iW��X�����V���mZkiSYj
�\$ZWNM��\k�k��a�5�O�������P󑨩)Ƒ�Lsz���ikG����o~�����??Ri��VQ�P�L�o�y)�!� �uP�ٻ(��ʅ�m�ɩT�6�fN���k����ou-5F8fr��	��:8�~�n�c�#�I,�1�-�W2aL��e��;��Ѿ@�Ú�飠~�Iag��g�w��c��X�d���,:l}4ڛ�8�Ȓ1�c^o�"�M����|] �(�gͯ��3"[ޔ�Z�D��3l�$�iӮ�� s&���$o4��Fa#�S�[����ť�'�#>C�����/u�<�<rz$�;�M��6-��9�0:�x'����@�o������¦Β_p���w�h?ሲ��jVhW�)Ӈ,6Rj����Nu1R���?�{}��lDQo�`h�-�c&R%KER��\�<�6&�N>:6ہ���i�9d
$�`�g�jz�estǳrgX�`ţ��P�S��)}��OacI�k���>ǵ�|x��p��4�`�@N�:�U��*ax����;����=��pL����C�~j]�l����d�u�HN�X�j�9	�N�M�H'��&X��#�*�;�r>='�^��6j�0~d2광���ǳ���L�����铁�i�^^�1�o��73,?���W�xM~Yͅ$>v�C�"���p5������?�iS�;��%�H�-�F�lFRj̗�T�,m���p��DsS:v����[�q���=2?�Ex��ɴq%D�����Y]UB��q�_:��F��1�6G�4�I�{���xkԘ�{9p��9�Yj.9HB����v�Zq!��n����;����ܕg�!�`J_�ɴi�2�������HԆ��}%u�8K��`�B���ş���ֻl:J0����9d>��ͽ���,���G>�]b}��m���4�i�����8:��0�i����T�Ʌ�
��'�T#�4�N��,���t`{R`�մ��K�#Q�~#���:_x����&����2��ê/x lA�����!�Ֆ�x��+Ŧ�F��4� ���NR�I�.�A��&�?�S;�=��8΄�h�'�H��٦�q8�"��Z�0m� ?OTG�e[՝���i#��m/F�; b��0���܊��_��F��c�3T��-]]ڶ�^�}���0B��lH�1�}�ny��F%X�Bl���ZL��$ �NX��-Y�S.q�\��PħB@H��sľ���6qq5�(�D�g`$�oͣ9�,�i���!,��8�D
�w8@�:��
ԇ���
�Qwv�����h�X�I!��`�{>g�q�i���M���b(��6I�k�Ѵɪ,PUy$�k�Pr�`�{�M���)�٬G�V2�Sƅ�t��i�c$!�F��%Pac-�P2�o����g�{yO܇���>ug�1<d�=���b��+Tv�65<�!N�>
��MMr1%��x'}58�&<��Iy��h!Z��iڱ�$�3���w0���W�bS�>���͉�&��u�I�#;��9�n�����ƣ�q�X���8�vk��Z� s�D��R-Hc꧵̊�6]�,^����ҁ��Y0ư;�BV�M)kX�>�/�5�ե��!����ҏl��蔱�)�v��+
��m�]598O+�k�Y٥V'�6_�(���5:0��Q�d]������-v�斌�$ƻӦ�-�ÀF<d�E��I0��LlP��
M{<��7"á9Q����l��2F	�L�����p��/m�Đ�ςS��ܪ�J�i���,E��F-����n���8�6��τ���O�c#ѕf FHj0��[�y4�	�t�\�ΦM<K8�\ ΂�Lv�\�'�V�-y��S=��9N����.q�|�1��o5նt��M[�#��=���IǞ�N�����:N)�*�X���l7Ӧ��0�?x{$�i��zG�/Tc�C�֠P���X�BcDh�U��[�Y�*t�\�PEt+����&V�äGzy�0Oʵ��M����0ϊ�?#v��s�z)_����g!}4�ٷz�W��BC�h���E���d&9�z��w�G�jڸF4�]������Jub!�A��!�c�c����ʹ���}��nc�.�k$�q0�q`�'ҫr
�i�_�q����n5k^������ܛf���Pwӆպ�
FXM�Z\�w0@���7R ��@b��8���*m�r�XZ�h4'�崈T_3�>�J�j6���lA�>�,�APb�L��{Jim���vKnI�p�Ag^�u�G�~��vqxhk���LN0�M�t���|iB�)�_�p6GTd�� &NS��C�.�M0"-�X�Ƶ�(`�A�c�砟%�6��륳�a�&>9LEP����NQclYLO���Q@G���]����I|���u�m�a�M� �Ml�di,8T�̦M{$,����Iҧ�J��6|��df���?l�R���i�:�Cj��p�ӨC��Hʶ�V��9m�s�o��3�h~�5$=;m����`
�."��k��[�M-#&I7UD�C��2�4?WHS|���H��	m����tui�v8�ښ#��.s(3jjY��}�IS���zB�i�n��+�����{]��PB�#����dq(�C��[O�ɴ�    �-�bm�����C�8�|�9˸ֽƧM���p.��k�&�v�p�4���u�<g�ɨ��8d��L;>n�x4^��H�F��AaSU{`wsb�
�;$�����ȸ���o�
�d����0a�k�:�mb��WU�.W-�w�¦ks#�$�H
-��9���e��\+ם6���$a8f<z���l79���VX�O�[]SX!+����$i3Γis���_s�.�E~c!�F�^�Dd�e�V)P�Zud�n1q�=sN��N�F��N��F��~6t�`UIư�} c5m�d"F���$Qz5%�t�I���k4mZ�7�X�������彫�ў���w-/��d'_#X�2"[ڸ��|� ��Q 5:�A�7/�+�E}��K)Ѓ���2_�|\`�W�����ۍ����Q�}������q�)�hN�q�6��dĩ�C=)��8���qoE�i�a2�j�&���S}�Mc_q V;�h�#�p�!ǿ? �cō��?J���NaS
O�� L)��z�j-Ð�Q�h�H]���f��z�.�ݧ�u❸���_g<9�5ʖdi�V�y���M�Gz�;4j� sh3>_!�մ�	uRW��Xl;�~��Li���ųǫ'�T"�ѴI��c%��U��֋���{� �u���3�V,)1�(�ǴOM����+>W��<ե�i�Ԟ����*��2�¦�i���M����6Z���8T ��yK��`�������C�(я8f��^e��}�Y�ŀZ֏�nژ,e�h �Et-�i�u@Le=��0�=�C�qI��W��,�XSa��]euq�=M��M.�ȅ���T������M�W`�WB{(���w�6�#1��Ji#%��HE��@�/�MJK�q"sO�z�8�NKfk�Zq|i����Z|�p,�x<��=���?�Ob�M�K��qgٶ�I�������O������LR��5	���Sjt��v��?2�oX�F��^�-4N�Iű:T	@�i���ö@{�i���qS`,l�>4�/���=#Fa���ٰ�p5V+�n�ͥMӓǧ[B��{u@��jr���@\�iӄ)���c����Ո��b�ċW�s\"�r��H���xt�:G.>|�����_���8�B�#n������r,�Ȼ����_�x*�d5m��894~�%GS0mJh��z#���QȕpXFl��Z7���TϮ�6�u�e������#�C"R�'F�jݯl�C"&
 ��;�k�q���:��'U��is$h�G��\����T:%�4��(J]��6�%c������ʹIϤ�a+7�8�Z�#n�Lvɽ���SΎ�����y�e
�GQ�dlq,��)�l��5 ǰ��|�q��x���L���	�5�R�1�>փ��͡�����SF�pbr(g~+�m���r����PεR�v�mZ(�s�L��ÙJy��1E�#_}��jڨ�2��f��ϥ����͉J �\V��?s[�h��&�쳴ܳ6�2�6M��s�=����Y����f�m��-l�Q[��C��=�L���>z�P��Wi㡮�/%A����^�N�Mk�b�9L��'��~is�i�,ֈ$�i��'�&�i	�Hz���R9�����ad'iq�n��r����$�T����O�-�R��$���\�Z=���b(�isMct��8���_F<�*ٰ���c0mj�/���A��E�]78�8�8�l����q����o��¦���1���΃�J�ô1�e�4￷�,O�³��"�i��
$����J��G>��BF>WMYǇ0���b���#.��?>�=��<���(��O�8���$�@��_K{�q�B\��lM뮃��V7�8�Wʕ=���]�Q��K�8�$�V�wnTI��p��*�҆3?WF�%�P�A�M��/W��</R�i��M�v�4�2�~9@L�VO�8�����7�FB�,o=�յ� �`%M�|Oڲ�iS�i8�b��]�g�IY�T�Ժ����Q����=�(;��sN����z6mݲ��,{8��a�?1�Y�s�^�z.�����ՠK�O�f�Ow�p�'�R���� �**�X�pO�X�&����&'�������k7U<�&,d�Q���e;�i�� t���{��h'0��<3��X������H"������i9�-���4��(�'+�=;4�4Y���i8�Y�_��h��Z�;o��0��ty>|��v�6Ub�}XX:�Ӧ]�8���6�C� L8v������7}>Q&��].lbT=��rB�Zk�EG�&E00Ʊ��Q���C�J��[W<�f�g�ky5,m|�{���$�����,{
.�K��P���x3���e i;��[��oOi�fBGiXF�Wg���_��+���'�C�~���6�Q{ͩAz{	��?�y������MuI:,�	@����@KƀG��A��i��ֻL�)���mdC�\$]�f���M��m>LקDu�u/X�kMc٬_ڌ��rY�>�����F6�6<ll�M�Pܯ��k��T�����l���/1��fFi^N)ܚv%��\��l2��p0.�Z���(��M(�([;H���y�ד���V��g'3�<�����ٙ������E�{^LxX�؅��%��R�]��o��ۑ��Bfm�#ۤ��9ۨ�g�����o}۩;l���s�������R)������$VW�����6WuRs�C*��s�ic������V�L�;���k��bjd�{�,���y�v�I�w0m�%b��z������'S0��>xH��q�֘�*��J��M����3f���D��ݴ�:k�4�5��3���U(̻�Ƃ�����S%J���Ƌ���r�g~��C?��>�;�Z.�y >���?�}���CB."���x�	ܤ����C��g�ch䄯�յ�?��l��aɾ���h���SY5WڔJ���A��e�I�6"�L�6�Q��c�8�(��˰����X�c5~�����s�����o��×��}�����[lb&�XU�xR4w�Ӧ&:q3Q�)n���k���S���hXH�r:����ŢK���� ���:�_+m�M���@*�Cz��m
RaS��a��Ω��tCV��d���|�2�pe�|0��.�;l��n�Ԑ�4,y��-lo^���WL�rvEac��N��-�ٴ;tV�̀�M�����M\�e�6��(,nq��������~+m���a>y0h�׷���M�`!ѵ�`Yn����*"<i�R������������~���!�ecn�Qdy�ݴu~�W��<`p����2c��f�&�����ٵ�b�|G��5a)��~��������Q �8M�Ȅ!�iz�e�;`VSD�����"(>��"ĐP��6-E� �#V�P�s�����&D��p}4�q��'���T�֕6�����d�cAQ��I���|k�.l�g�v�f�[5�c��la~������<�B���C���'�w�i�:6p���s����9��H�a���X=]HV�6)U�j���w����YV���&��2t�W1�ۊ���M{�6^Y/��G36�7?��q������O��_?=~�_��߿���O}��xD���??��_��)�fp�|��rss
��c��'L:����.�X�X�ȈwJl�AQ��x��M�P9�g�p��d���;�J��e
������{AWoЏ�0>��j"�Ys>T����tۼ����O�&��&�_W��)�	-�t��t���C����ͽ9o���,Z�K��gjxl���9�b���!��ۧ3��U0����Eh����'�VL�m��R�m�ǟ62v;~��6�UN� ��!�u-��� �4,�o�2-|BQHI�%�S�l�ؗ����=��d��6K{����!.�j�g��C\(J3�"=�}3�\MϸE
��5�[��!,�a;bָ�{�8L�+b�L*}���g��h#/��2��|���is�tp��I ����i2mL� ��    �F�)�+��w�F� @@B*����-�\�P̰�� =�m1S���!�)��jں)��^S����R�ՠY��k�lbwG���Km~�Ǻ���^6����������mHIa^�k.�L<�0��F����2��]z����a;���or~6�(�e~�32Ϟ��j�BI@�&�Pغ���;jǏG����\E�D�x�����C-MH�|4m�������w#�"��*��e2m��C���S\�dk }�t
Ђ��m�M�OI$�R��/�Oa_нz�����i6mbr�=މ��l���j���6�yբp�����d~}�Ӱ<z8���̉��r���M3h:Oקh4m~�'��c�%2�[`n��!������׋�O����@s�؀>M�iӋ��w���2�w3���ٴ����^I%�2�Ƃ�fI���b�z�f������Ԃכ$���~,�M��y&\�V�\�˚����=��ipZ�:fΕˠ\aS��l�>͏f�l��u0mj�Ђ�����;���o���K��3Ο$��l�9�Lo���A
#k�6���#U�~�<?��~�s�ٴ�~6e!�S�֘cdѶP�:�ۧ+܏��>�J���c=渘6q�F٢z�/n�ʒ�G��i'��������8ި��\�x3��*��9��S�����uG���}�g�q�~�S�L˿.�����ֶ�b�i�c0����r����p�k���9c�)j�5�'ɽ\��-�"�v"u�����8�[�{�a�H�f�ʁ׷�����1��Sn�(�J�����[N���~fG*��LK��Ĵ� }�[����A�΋i{����b�	lty��	�i�KmQ�u�lU����`�������q0m������\9���մ��:����Fl�5�6Vgq��j��7����Ji�r��2�<^k��G�U��6��~'�� 9L[���s��d�j�[{[a{/�N^ShM�1� �@��QBO�Jzu�ځ��K�]��K�����۫W�u��q�|'�~�5&.w��m��\cz��.�ku���FD��OwJ�4h٦Db?])<��4|4�
J��@�ٺ��Ȭ��[�1����/�<R}ɵ�f�ި/�<$-�B�ދ�0������^�6}� >�v�˹H�_N�R����޻}1��ДȆ�Vx��bM/�=k�ᠿ�?��iI����A6�څ���E� �#FQ��P��غ=�7�miП&�v��|9{�7��o脍0�(�i���Bʆ'�Ǚo��ƛ����X��W��F8�`�k�j��.�� �e��Ty��V�R����W�0�Y�u�� Ҫ�)b���L6gp�.�~���QQ�N�4�%�	�����y�@@3�6>K�P��.�2�¦��9�2�j�%�:�s�v��ٸ�5��uNQ��ʗqyiVNgqiV�����	r/m/l�x=)pk�p<� =�A	 �=R�:�;�Z��a� �Ô�U�*K���+���6�V�ev<�˵�&Y�8H��j�����L����4Y�"�*�V�M�4��q0��aO�Fƚ$�hs�B��B^�0m�}��LdnS�AKE,���O�l�!�0���OBa�J�Z_�O��d���y1'�[N#ќ�!E��5�Y5����|�l��h��a�f!����*�v��q�z�䯆Ƣ��HC�ǮNߺF'�%��M���;���k�ٴi��q��,� ���a����?�j�*��>��e�p��}��Z+�eL[��,}�й�Q̳�"m���Q��|'��E� ��CW(z6J�Y]�Op�_��孞ŖD����&gX�<�H�ٵ�bڴ݁�ЇɡP�5�K���Ƈ�����B=]]�Mp��8|�	f�o�4�������ѣY�0�'���Ҡ�Mm_�`~d������sD���'����M�����S!$Rd��!G&0J��`�C�s��{��n�?ayճ��|��s�
�}�����Ǽ�t�F�ϔO2�q��n�|m@L)�(_���5"$-}9��K��&KY�7<���D�}�UU��y3�jNK��0	�ǰ�pk�Q����L����+��H��D���8���6G��E���=��I��u�������\�e�}{W�������s�QRKdQ�Z�����KZ3��ֹ@�39P!�,S�B�?��8p �^S�ۣ�V���6�5|E��E��x�:�6��sL#i�I���gӦ�a,���Z��+-m�͌s(7�Ǜ^%������}o*����:�3ZFxs��Y�]�-R�M�]��|=���rlbqҵj��~qRCrQ�WӦ�(�cǏ�ڪ7��҆Ǚ��`(I�ׂ��H6)IJ9Hj� yxCE�����U,��ן^]{�s}���*P#�g��"=�i��qŻ�}\ �2���?ћ(��H��Q��8���q�L.��,/��;�+w���뼋�j�1&�VoQm�W'�:sA�H� Ԉd�hk��._�6�P�y� %��d]�7{�J����t� ��������t(�N�Z�y+GY�6�HXHj/)ۤ[ ��a�*�s�ڼB��a�S\��HI����b+�T��5��Lt��^��ك�1	G����iS}���N��ByNO�L�;��ϱ.P�q ?>�-����X��U�o��������~�����??7�� %,�� �B��y���jXؘԐH�K�Sgu-��8H?UhI���_��d�O�O�Z]�L�9b4� �˅{`���Aà	���}� %�����-rm�i��j��;e3�Bu�\�k����_�`���(��R�A
-Q�7z�~%%s�i#3���oC	d�@�;�o��q�L���`*9�Hw����ex�x̋ކ�61e�a���Y�q�͒�U�����9�%�u���;kH��!(�8��#���M�� �W	E}��˽vS�F >[�-�� ��\a�5�xs@�͵�Z��8�LX���X�8�Y�(r�_����MX�2?�Hq�k�ѴiMX�c�s�=q�1�N�&6�L�G���G"5�Pr}�I�ٴ�eL�*���U�P�/�c�����3	�T�B]��	?�l�㱚fYڴ��)��Q���X6Ɗ��mr	 ��BA�X��@vSz���ʋne�\i���W	cIR)W�A+�"�
׮}!ͥPliS�2q�]d/�D+z��@��V�݁�f�X0�����;�*�w�p����I������r��������7�1��N�͑]�8jv�����2�cH�o�Ldis�D$n=j:\=)G�8��i��:?�nڄ�r��;<b^��Hy�A\Zc�.���6�z��Hn ���MT�耘�} ]��L���e]8�]�\8�\��������M����~dӨ\$�_�we,ƶ�Ug{,Z� �|.�w�o/�rG�8��d,C��yں�N�^p!' �_�ls:�f��Q]�8	i�jڴQ]��(��1c�!Ō	��:�G�ī���MU���h׃p�Ds�	Ǆg��i���r�/m��S����$uC��*5]J�%��������q�69����ݦB�n�G��M�0`RԝӦΜ%A�t�"��4�C&5q��2��6- �AQ�D	H���}�wa���'����ᅹ9a��d4�61*H9��4���NS��m�.?���8��~x�4:{4m�����������+Ӧ}9��}��=]Z�I_J�R��i�ۓ�ә�HSH?�e,��/@.�Es�jsqOj��`��`F�UP1ʇ"388�] ��?�=C����=�W�z�`6��������	~��Iu}�s�f@H3y����Ӧ9.,2��؞?B<L��Wb�Ȣ���D�+1ǂ[p\?��>΂p+,�m�1�V)���{˞B���. �~�&�]b�9IK��RS*9��{h�YM�|.�c9i�z}M�6�P�s���.�I/��r�����6%����?cP���C�Q9W�gӦꨰG�Q�h:*��8nM>lJC`��{ }5���âf����C8f2M���Oi�5�E����$I�G��h�rM�Ab^M    ]ml�k��~�w4w8�Zi�H�Jc�C�f���fô�hJ�(m�r�����@�a����S}qk�,�i��d��u���G yUP{u���I�}k&O�*�c!H����a�(~wS=+lj^j%=հ|�̦M�6����9�7%��Fƺ�@�%�ť�:�X<].s�;U`�.�����V�>�� ��$�s1h߿γP��;�t�<#\�!��i�cFa�l�bE8�)�Ŋy�ݴ�Ŋ�W](o7Pw�%+0��%�^|r�F#�������H{ ��K�S��aa���`���*�p�Ԏ���qHfӦ]�	�6{&�|u2���Nˌ}��o]$���9Է(�����ggp��l��<t����&'�f����M>1q�A�����U�NJ\1�K\��QS�z�Z�&��H"��0;H�6�l�"��c'u�F�V5s����@>Oˀ�4�8��ޛ�.�**u��gr%:(M�h��p��uڜ+N�0k��i���b�^�HgOZH��bZ����{�?���&���j��6�ؑq8���j��6���p��"w�D;�0G<^�o5=\d]H|�a��)$���^�z*m�

ML�s��T��0��k��;�m� x�6K��Zs��+r�ic*r$ ����i�T�:f��]�^�B��X�� MM�_��Ui�O������8u�ȝ�����C��I65-�����.-,K8ܦ�v�"�Z�䴉�X샍>�>�͉`�DƳ)/XbZv:L�3e���#���V��9��yz�x.�[lݞ1�ݞc�\4�X񨢘����	%���y������4����b�]f3M[��F���qg~��X�WN������B�&i<�(���6�^�
�`��D��C�#�In��?�2��>f2`&%"����B�����1�FK'fr_������&��]��ִ�`V�'n�m��GܛU��isd�7�*��q낑��E��eG��~6����!�<ž�E�K�9�����	����?}�����q��(��Dmla�3Q�Z=��4�]��B�i�\i�����S����6��C��%>[�o&:��m�$ن#�g{
����Bj������{��8� H�_U#镑枫6�ࡻS�yǥbMe@.��O_62�����(�j�>�Q�l��8��fqa(i�uj�C��}���E�`A�ku��8V|ͱޓ���l�5��"��,�8�˒l���@����_��6��mrYƁ]��n J�#�|-�  Ǯ7���U��m��v'>�9��tc�?2z���[��1�7�����_�=�WO\t�p�^�}z�ӧ�����p0y:p�-yZ�TFgZF&����o=;��"q��>����5����B�~�ze�(e��%Q: �CI9l���qIk��v�)l��@�-I��r�'�CB\���Ӹ��Һ�ˣt�nDv��ӈ�9G�cBl�ɴu�
H3�>�6y+0���?�S-��s� �O��&~����2�>㬘�m*PasЀ�`(��C�jU��Q�(�	:	G�kH%Q��:J� 5m[2��baQ
mY8���&�(GlJ[��Z^ul��lۖ�3�?��|�ׇ�U���s~�@��ZC
�1�˛Ty��6�����-2Cq������mR9I�C�����7��Z��N�''�{�z~
�Z�J���L<D��6�D�q�h�Ғ��%��G��Z�k8�g��| rV���`��%�n��!���>߳���M��"�8���MI 1�@T���4W�d[Gm��(x:�@.va(r�&/<�F�6�gp�A��&c��D��V�}�k����Va����!�8�>�����H�y���*��8���‿��0����
�W�˛mb�1u�����d<�^��*8\>���xIA���/0�HS���6!Y�ʞ�ؙ���|8b����΍k�ة�-Yؔ�H�.�ҡYD�=ED��񞈢����Y�E�x��ެӦ���S���H4�s�� �\3�y�i�M)�8�߀�&���S��H�Hc��֥M^�\�>3j3F��l�� L��_3��~��6i���{e®>���@6�&��1�f��"b��\o�l#e�#���y%`�>@�~�W��UHMX+��6i��11R��獺V�z���o����L�zϙ(�X@I�.)����Ҫӽ�����E2���H��"� �j��5E����:m>Y\ƣ޽�V[�9�Ǟ�9�K��2����~�ק/R%�dxᒧ��U�*�t����d� fw������y4�Ϝf�ͦM}�g�S����D{�9�����x\%�#�Z��;{M�:�\3`ﲏD�C2��G��MRDO��}��8���9�յ��9Z實w�C�#���ل�+��Ѵ9�����% &�69��P�̼�V'dO�� Kd�'[�(�x���6�A��aO�͎M����O�wg����Q%�0m��U؁HB}�f������w4~J,���̦�8W�4ׄSLDɺ���qJt�C����b���. G�?FA5���:����S�0Ci�k � ���Z�yᣪ��lD�/����B�a�lR��aT���9�a�%�lT��Ӧ��,8�u]$Z��q��!�%��7$ɦ&%8�Zd�H��ᘉ�a�:�mZDaS�	0_f��"��	��_�6ҚV���&�@15��@D(�!Jbw��Zy���r#_^�.-_�<�4Σ���Jc$�h�'Q��(��ɌO�?�!F���8��8���f�GyG�9PG�N���cXs���
R<0����4H�1�HEƖ�t=������YI��8��Ι�6v�Zp��
o��U�iӾ�C���������2���Uo�lc|}��ūkGo�9�G/�x��~$��h���]���Yw��[���@�ky��e ����T���1����A-{��g��A1C1N��M�.lT{��E 5񗗪/��&&��oQ�xeXM��ł�T���Ȋ|dŝ�m.'����iS�kx�adQ�J�D�*q-��(~(��f��Jfm�1jյ��+��Q�g	�h� e($��������Xa#���㙟�ť (� ��M8i�������ƪ�6r��kX}7mZ0�pl�\�-N����kaS�W�EM_1-}�~�L�z�-�V)�ӦV�-��r���E�U��'��XcZu	�Mzr5��@��g��7��	�C�+n�PgON���`��,�EI���0E}�(�DC�5ea[�S���l�>�U���~#�Z#�\M�V#�8��z��q���d�^�)�~�C��>�ǯ_���_��߿�6��G;`.������y��&��C	m�t�2"D���[���U�6{ذ����lu-��8p��m����A��玜a�_6�q�h�CΡ�ǿ3s���撗~�J��u�l6���[&�o�e�Wo��C{�f���O�m0	��+�J��ɽ�9y|(���bڄ����;(����<6�Aj��d��V�k�Mm&��o�;J�Ds��+m�x{�YU�2�M�(r5��H��"�X��gL��s�|���w�(�h��s�z�Ƌ���u|�!l�]`�X=�6͇���/�xG���TdpdTi��8�+S��OK��8T�^ګW��MK��M�>1��~v&4���g ��k�մ�I�Γ�sx��#����!�_���������/�V�z�S^r�L���i'��bqሩw3ț%F�]�|n�;�?G��EHB��`��)|�BeD��R܄c��ǅ��y�ϕj�1����M��"ay@e&�zO�(8۾Mc�]M�58�'�6pֈouɅ�D�ٶ�5p6m��I�N07H�&�!	�:��ER�~^6-$�8`DQ�6�m��5ќ8n��/*l���5"����iS�Ku������(��}��9�����[�iCx^;<ⵕ�H���sѮ��5��-�޿�R8\�\#�Vu�\6rmXh$�?��ߞ�v�Ƶ�����r�����ן����?�Ln���2v�Qb.B�9���!�8    �/u'pˎ]�&K�N]3{�H�{L�B?���i�rU��?œh2�QA7TB嗍�1�������Z��Ǥ�w�.2����6A]�"�T;����xOؗ���ho�*1B��З��c���=[���"�(v8n~���2(��7\<��a�潱�M'��־���eS�i�Ɩ�meYN
���Rb��Ǣ�dڜ���_���w;��KC��p"Éx���J�ml8��������.ͧ�b��s��Ӱ�oQ؂�&n��X+����~�+ �#c�C��S�>�6���J����c<H`�G<w8����acy��@��#9��=�h�bHE�cJ������O�X\B#z�R�s�ݴI�%�C渧9Z�A��Mn��^K��^����e D�x�Q�znaS����#F:c�eӦ���6V��v�y/lb�i�E��_�n�M��3��H $�^jR��������>��pX'���Uc�M�e�M����"��]�!Ѻ�8�U�Q��v(�
�N��:�Ӝ�J�v�EP��iN�)�2H�eIea�
�	�X���S�2{iՇG1�$٦K��o��w����8<�{����d���,������H���!5t8~@���y���VӦ��E=f�iӎY�!뾥U���/l�
�ʡ����h�8������3�[9ۤ�q�D�����3� ���c���|�����]2xVN�Q
�:,r�C!�a�sԟ��ƴ��0ח��յ��.g��72�q��~-�� ��L�¦��O�c"�ֿ^L���A0�0F��̦M�p��L�>��H��<޺my�ȹR0��2��̞�8\�C�$�C�?�P�����h���2��i�Bk���Ccu�NpD�o�M*�&d�F�ͱi�r�N�z�R�kl����kS�����[�������%L�������ػb%���`�4�<�������
kZ�Uq�i����]��p�nTZ��1��T�¿��7GE ��ƻ�L��8m��Q�ASk�;4Zp�p��ರ5��<�c2m��pu���-�dM���n�X�Mդ��T�
��H�mK8�5o6J���O�i�v�oފz�n�d���9$ɇҭ$+q�.�I����`����'�@ ���MG0v�/ZS.9^9^�8Z��u����S`�>����p�Y�a��5�7N���9�K�մ)�E���n����b(��B|�У�W���J9� �S0,��[���\عq����m�}+6vV�Rӌ�L1�Z�i����M՗�#�#�v�Hе�BXpKO���&q�E���f�Jy
dN}��K��S0ml>��9��յl'�P�����(��N$��d�t��L���d��]$Z��p�Q_�;g%�z�����k;�b{��2ճica���3����i�.����S6/�#c��۠&�����[]Ub��˯	(�11;����tB�X��v�L��d���5�������[��o�x�% �j� �]��>�i#),��WSy�մI)�!)�t0�Pdy��	�Yti(�i���q0D���H����'���b�\�I��'�x�d �ΪM��e����&<�+��y�T/��R��c!���0��6V;�ՐW<�ݵ���LfC[u�W8�ze�E`�8j����1*�"7!�C]+y��g���:$����L�J+��x���e�	?���6��+%����a] گ�88��|�����6e`�]\�19^lH$���G�ٴ��v5���/ x�����oC���溒����P�)���-��9��/F�C�_����W\nsD�3?��GF$I��Z�~s�~�YD�� �Dӄ�8Ht��N�)�Y����T[4���6���c؛&�7�S��H�q�'�$7���q����?ɯ��Em��xc d�T�[Ҳa7mXJ��*�B�����Mڱ��A�����U,���Q�8�wA�Ӧe�J��4o�a���Jn��/,����}0R4�a��y�Iq��<�6cw\�3__�����8��A�O�d���䴩95<�b�ì�bڴ7�p���M"���'�is�+|���O}0򵆣��	������n�̫�	������C��[}���&>m��xwK/qǯ��l. �ae(���ą�*�y��K��Y�K�s�մi�,�!�"�p�9���a��&Q�1�7�˦�ks1e�\�0mZʜq��:VW}|�Ӧ�J8�XN�\u4mZ9�`�����[.��I�YĶ�窓i��.iE���yչyw�[ܢ�P_8a �=�./����5e�e��6����{�U�q��E@
�.�n+A���Xla�R��٦ս�Y3�J�O��o\��_\6���Ws��Q�\�޳��9J�Pk��_u��T���8���6�;���1�����������&�
®���)��K���m�>)'n�����.���\�UB�Ўq�h�J��k��]���WD<�Y�x��]s�Ha5�A���� .:U��˦��s����h�c#5㆏�����I�΅����(��/���p=@���C��:A��Cv#��A�U�]�M�YM�Ȣ�,0�t��pH:�������6��4j��F^6��
��$P��ǀzqN"�f�����Ӧ�{����m0d'�r0Y�wv2�]4���,�䎛+�<U�ഽ���u�������.t���h_������?�T�b���=s/����*���}ToMs��ǯ����?mܯy�ax��sw} �_�C1F��	"Jo���V���]��1�׵:`���V׮����G���p����Nqf��8ml�y@��y.��6�*���7Az?�D���E뵮�/�U��I�˒,�LW��딃��7�Ǫ{�ݽlbb�͖�`���DJLQ��H:�e鴉�U���r��Dʬv8�8��I0�����?D\t6m��R�Q����O_>$)�N�/x�'�v뱄J(�)�c�$�Vy��[J#%!(iU�ˋ�����d�R���+�x�b����џmR�S�h�%���
�̻V�1f���o'����u�0�XE��+Ʊ����+w|�h�����iA��Dvw�y�A�&�¦�)Ɗ{�$>�$�p\��||�@����>���.�{�G1��Ic�7�
�� H(~��uH�I�CRO�p���~�`���YZ�yh�M/���H��ܳ�dl ����d��r�X�t�yV�?4�6�2���Q� �;�$��ܟ�e��}��n2�N���h��C�5���l�=p/��l�Xt�m*l��7R�rتkM��$'n;(F��	pvPP���d�؃v''�o�\lפ%̷�?Xs��,��y3mZ�������f��q�����㢁��	]��I���B��Mᨰi��)���k����)���xolu��er���rY������{v�K�66���������1�մu�]�m�=��=���L�Tb6��nİc�Ƶ��X����םT��~o��:���1��z�pk ��Id��?' �@�~S�(l�S!Ce#��@��L�=�>��D��`���:�,!5���$8�J;`K�ku���s$�hN������h����׷�|���럟Og���t1^x�]6&��חG�յ�<�a�*>�Wi,��J���&�E��4e˪��ico)Ix;�j>��6h1m8�|����k��Y;R�H�CG�P�%�t�.��t�z�Va#�$�{����B���6I��c����L'� S���!�J��z2Bؿ�(�Y]�;�ۀ�x��.��h������J�����i�J�(t��ɼ�6̓�g�6��.m�4e���is����ȣF��Q��a�(��j�Y��Ws�"��^=ۄ�&�pƮB�jr�rq��J'𫰪]QJ s�WM�,��\�%�W*�w�t�[x�yB�k�]��vD������S҄Q ]j=����l����3���g��x� ��a�רgL��}�6R�'���Մn^)�6-�K8R�T��į�    q�A-l�����c�n(�TtC9�D���#�:��lS9�X�BI��_Ɓk}����<�6�R�KG(���PpQM�I/�oԟ���Ƣ���c^	�4���q�o�a��8]�x���^o\�k'	� �Zs��c�|�M��]� E"�zg4�E�q��ꔴ�l����9��~w-~�6�:��)��=N�u�ŴuN�+Q��(G��$�i��s���C�ܝ���d��M����At�0L�E��C����@Z3�~��5s}�f��A�@�Y��ś��͢���(s�-��,<�z������A�m���9���.���h�DK�1���i�m�M>,я�έ��P���f#��	a0R&�`�����&�ɴi^Ȃ��	�Ym��R+B6R}��fmx��kq��axB�qTd�8m���+#���+O�M�s���q�S��,�epdތ�.�K,9m��B{�D���t�pi�d����-�u�.���z�u����y(0�`�&_u�D��mM����Q�)���M����A@���ۿO��&t�o�>���>Qp�6�[���m}4�2���p�����C��m�v��9�+D�8Vɦ��8�$J��xO����Q?1^�(�i@�f	̕d��6��i�2��C�`�uIP02nCk�-�ic���د��H�+5orZ�ā�ɷ��<�}7m,1���>@i��Zb�pL�V˼&6�	��լ��!��7��ߎ q�Y ���ρ4�7o��ߪZ�Ӧ�W���:B����uqx7����#Hz��k�U��Y�0��$?W
�i�⏜CTb��+1P8�y�f��\]��t������͆޺/��ǿɩ���9���is�l�o��������m�C���ul�z�\��7��P�i����_��v	b$����[T����nv��a���<��;wQ�Po��}v
GDK����6v��뫷���dڴ[� z�'`�k�Ӧ�,b�+#[^�����Mw�icW1<�7��^����U�q�,f�ْ*I��d�'C�����D�h��P3D��2D.�"֦�g��$9M�:q�ep��eu�U�S.۴n��]D���q;YV���晜,��#�IU� ~`L�m ۔�u������:�m����M-e�C1�M�t��+m�� h6m�ō�L�k�T�ni�N��e��e	`[�ʪ��+��M���vӍ!�II���?^���Ő��
���� ʇ�<F~���q�?Θ��ۇ��o_n$��H���c�D%@t�	��$^��m`X�����p�Ƞ~�$���(`���3 �ع�9b0�'��ĸ8��,^C� �BbSM�9��8��yJv�7��'Ӧ5�2��٢��TU^6��A��78з:z���?=,�R X6��C�ͤW��SƿsT�M,c'0lUr�t3E,�(o��u��<[�����؇�gp�9���$ݟKaYF�j������i���W�֎��lr�t��p��"䥫��u�x�ʨ�V�L9��EA��{I^�.\w�ؽ���Bg�V�>
�����s�p��U��1w_���>]��,$ k�zi�BU�v�E�X%6�I����6I6��h8�~���սl�5q�8�sa�"���tT�3QW���67�"*Rc��^��u��^gO2�82 Cߡ�X@p���N�[IU���W�=O6���a8��²6��b��ff��JM�>���!�mL1���������V��M9f�0��.��ɦ�دb�O�l{�n��j'Αk�,�������>������?���w'�X=۬�.4�9���p���y��e�nZ���.��*��:��c�/ͧMU���"�XJ�\�vW�����, B�bq��E0�O���2�<d���!C�3uQA�h?����3gyg�,��6���.k",�h��F����M��TԞ2�65 �a1�}$H��5j���Wt�1�A1
�Kۚ"�8#y�*�/�q���/��m\ ��A��a�4.�~�Da!Ѩ&LC-��&و��5䉧υF�&�(
)�j��m)�lb�?6����\$r����(T��	I�m2mZ���������(d���u�:ry�:O�L�vX��s�ٴu�²*�G:���i3��W�4�q=T�rx��=�q?�}�Ёwq��	�ۯ?�jL9I�f�*j��-�X�\�e[g_W��6�9H��)���l�����eQ~3	�$Қ��#�a���b����;Fnx.u�6=vك��7a��I%���${.���q(������61*��� 5*�H�H���Oo�(�I�	��nr���y���㼋i�4G&4x�v������6���v@�%��$({8���Me7�ldQY
��S'OO��V��%�#~�`?�ku9��c��Hd�S���
IT��i��7.�a���)��o�mr�H�E�{�,��=����u�cXf�:�~�>���T'6�M��֪V����#h�E�{���6�ƪ�b�޺Pz��
ɶ��g��q��X�B��#�W��Co�`���S�6=��a1��wY�3W�Պ�iHc��2�T�id��ZE�k�ٴ�*�Q�[�e(Ǣ�6u*�H~)M�G"�:uX������$�f�QF&�M��7�o�D�2�;W�4̵p��Rڈ�Dg}Eu��j��$e!U����󸴉������ȩ��s�_k�ﵖ���u�`�O�Zo��&�J�Pzx�ٵ?u����%��ȷ氉Nx���6�ކ����d�>�M�� ,;�P�'����H,m�%=�Ei����JJ�_}�G���.9yFjӼLi��&e[��j6:0JWUE/ �0$�a�N�Ժ�F�H���`�ô�e
eB��>H[�7�[�Fi;���v���}��8y�|ɻ$Ѡ��'4�K� ��6�29�`�R�+�8H��_�dW���$��Є8�f�L�*�Jj{v���"�;�:,���>;,�Ρ�D�\>�����	����B�`U�Xg$��n�bKou�3��X� uخ�[A����iD��-+�5J�*�ǜ��6�d2m�>���չ�r�^�0�{�jST���h�d�d��YL��!��c�>��[�L�L�W]0��ȯ\Z��w�")N�>Ҡ�L�/Q4������}N�$�m�@�|����-�mN�i<�4"��v䊷32���T�����m�zu6p �R�pRd��Vl祧��u(m�6K����V��#ѵY0�>�����4���uiv���N��y�heZyL��d,D5���G�ʲ�����W15��M�X`(x����͡=����6�<=����P�/��|Gk��S��N�ϔm�'q�(�}������e���Og�Z�/��և�����ټ�������__����]�=���0|��6Ԡ�)ܧ{;��r�ѳ�F�n0<AҺ�/S�db���ң��z�l�.��~���kG�9�M�+�&�׃�%�0�>`����:�#(,��R��##����T� \7v�s��������~�<��xl�Q���F�RrEؿ����n��#�Uz��ܕO{ژh__;����K�Y�F{,��h?�Q����w��V�F�2K��;L����<�+�ku=��Xb�waI�~�L۶<�E�Q~H���4�E��0j�~^K�[D�X���y��6|���<���LX�耧�D�+�e\��|��4Ub6m�r�����M$�]`,.w����xsi:�2�6>�U��pf�ou���Y���q�G�Ob���6���>��Y��TWL���O�8j�����~'��mJX��6=l�X��&P�X�6e����+��g�E 5�ϖw�G�a�8d�N��6Q`�â���c,ĳt�Y6���K�:��y��u�ȥ8��;Vٝ��`X�u�a��'�IO���M��M��i�s0m����O?�׭��1J0�,�г<�E�Ig,?6�^C���m������6q ��9�.9:�Q�2=���׿&�W�O�dg�G��՞6�] �  '+���H@�1���tg@T����0��(ŋm����mj)ނ��Q�x���2K�}̊�q�����6�`����"�q�ٴ�>c���O{�D�!��sN�<��Wn��E�!Yң��#���ڇ�6����o~�����??�ip�˺j<�"��M�j]�wE�I��f���C`9���b��J6�`��ˊ#qx�D�q5�X��u��Tt�z�*���&�oРe ��~��ߠ,���:q6�'K�^-ѳ����VD���<��5��=\Ҫ���� �bn��ؤ���/׮Xq�/��0���ڡ�'�Z͆-�ٍ�'(��C��#: ����e,�D
j��e� G�������}r����KVtr!�'A	���MEm�ح�&��h|Y)����>S���b�v|8�Ȝ�f ��!��@T�I �������+��=��Q����b����g���n�;)L�k<�p\�	L Ì��r�«oϧ�Ո����dַg9>.��0��e����E�rb �G��,d Zݣ�0�6�g9��W	z�&[\�2�0�mO�0��(��=����[�ёڣ��|�6�#�Y_-jJ+-�~9���|�],ι��@��fO��ŴY���W�<,f����j���L���-M{�8mf_���|E$q}p���w�&�$��u�xK�_yB7���qWb�j�>m�zy��:����3<t�-�z,>��J['<�髄"��1�������6��^w��6V��W���J�ٚmz�c�k|"�v'Ӧw\�<�xW�L�㊇�1�lz2u��;�E�2�,�IR0X6R��#�X��M�3���a�f�R�u�Ѵɾ7C�S�Z��H��fӦ�Hq��H�{ c�IU�'
��esՏ8�9��a#�K��Y/���%,��\���������Q<J<(c/{�_1[8�r���L�7�q	AD�<?��8\q?��T��XG����O�k�W���?����۴#ش��Ѧ=����{��-�c���B��R�P���߶Jw�6��	�&�����N��(t��L��~٦��V!�(bV=����R^657FQpn���ǿ3Vb!��;�;�:,bl��j���e!�,��{�;�*Z�lzΰ�#�(�'�@q�T[�8Um���t4��LI��3e!>����7{8�T�����(z���̤=�jg?�X��G��z�g�?��.�)ҫ:�S�s9/G��$/ǖ'5���,�l�j>�t��-�7�D��zǥ+p�m�9l�y��2Ve2����JC3�`���Jd��Ǵ����es(6EJ���<
J#��;,��4Jo@�Hb�z�@���D�-9j�`픺41���q�l��b�ϟ�}���׃����[�1D�~ć�:��oD���C6*�&S�,p�x,A���O�h�wN��<�_`��
o��հt�>��DQ{�+����ƭs2�k�=!w�^fO�����[��5�uĮ�
o�.9��a{'(�{�v5��Qųs�l�a;`�`�u�.����8���i���6"0������`��YƲ���5��V_3N[�#�����8$�� �ô��dƲ��u^�q��M��mF"'�)�5~�9�}�66$��2`�ku99�c1�Έe6m����aQT�-Q���0��杵�e,�&�ӓ���lsF����=�.���T6R�h��e�����:u�W�lu=P�a�=�7Y��I �HBsIH�������<���TA-a �"���J����)��3��d7^�d�R���<��T�@�Tk�ŜO�.�2�^��s��}e#
G&�6xS�$.�iu"��(ڊH�is��t`���.���T2{?��~�8��M�o�.K	i�߽�����%��&�hS�6��b�Lo�([I�*Z�uy�5�w��ˆ��<awz�Z�.���a�_�7Y��J#���>���i�+�u0�8�����,�{�l�ߪ���?��?�?0Sr�      �      x�̽˒7��;�y��3����YRʒXE�2^v������kE�~G8i��]�e�&.~���ӗ��U��U���?)�:���:����E����������*<��yϫ���>����ӏ������ǯ��������_���篿���ǧ/�>l����ck�;:-:�����	��6TC�����~~����>���˷�^�>�~|�����V3��N��U\V�5�W����'�>~ЎVS�UԷ����U�[����/��������^�<���ϟ_����˷ח?�~ل?�n���/߾�~���2X���ÚV���!d��8�?���
h�/`����e�>�PS�g矝�����_?�|���]�:]?���W�8����0>���~{��G�+�̧0���ށ2~P�޶����jB�������Pv�^>zz�����|�������������ݢK�<�i	�)�Q
o-�;�Z`�u�C�-z���9����.��[�2�yIm^J���y�~�������Ϗ���矟~{������/���j�Y7�zVfqj�A�R7�e�[jԨ���;&�����������/���<��i��x���.�E'!#��h~�>e'�����d{~6H���u�*��Ýr��BYw)/*���]!�<�ec���O�_J�u-�
��/N������"?���z�� � ��UDþ�A��6>� e�ws{�^n�:��?k�h���*��h��Yw5�"n-^Mt}�gU��E��揟���7r��?u���]XT��#co���x	=�v>���l	������ˏ݈����U/)�4F]c��u�*"��r�<>����ڝ�_m_��?����_������P�?V��lE��&k��z�t�^3"T�"��]�}����������|��˧�~��_����)l�Z�^��ĩ������ecj��6��MϤ�˺Q�x�/l�F/q�������q�Wπ�&n/���{����ɞ�*xEnd��1\��e�ŻFȫ���C�Ok����I9�N��__�gʵ���>�����9y����7�+����
���g���d���_~���/߿�������?Z��O�����E_���L�5�"j~u��g[�E�/��aa�&}��,�^6B�Ip�'z�&#FܖPՈ�F@_;�u_��+�Bt�J/f{�=���5yr�\��>��t��M)���Av�yt�jH��͖\�1z�n�(t�p�ݻ���m"��~��̲��<�ܾ�$�z����<c��ż��V�;*Y���I�Q�?�<�S�E%��4�����5K(_��k��J���+}��j��	ك�_H�b�n�CG��|>��������+��lʅ�q�{�)�_��Y/"��?�s�&��L���6s_�C��7���4q�~i(���)�C�$��yY���5q"�@Bt�\dv��UH��M�5��,�J��ˬ�_�_��8���^�����^�/�忿fV[;O��"�r�]i����<�1־�~�0��q��beu�2�V9&�l$�Nӿᒴ6+@�n��MT{�HP�{����ǧ?^�����?ߑT�>!'	MS��ޤ^�P^��A�.w�{�}�(�T�w���~+H=�h�X���AE��LIt~�ﲒ�@��Ɓ��o������7�&(����2-�{\�CK�ü������t�t�b�(��X�.�v�{>i1����S?�E&X�=�L�`��ٮK�+��	c�'���<�|=��Q)�;����iY]�8�3���JA٥��3n'hS��p�����BOGm�l��j%�Ã�-����'B��X�	��Y a��C�P&�N*O[����s���2��v�ݍ���Ck=�����?^~����	(9ͭK��'6�̀(�_�WUVιװQ�7���u�"�8��<G��y5�)P��QE�'��܁YĿ�n�g��&z���RMZ�\7A=��g���=����B�p۱[V�i=��X�[0v�-��)_��s�A��
&���UɁ$���]^�L���ے襪�w�Y��~�'p�$:?�lg%hwZ����4P&|h&��X��E{v
���b���I��s&�
bO�TT��3i(��&)ǾM�>�-˲+�&a�ú�#�Ƈ>Mr��!2�	�>�E6�ܙ������>)[����eg9vwU$��W�%��VS��� e��$�c��6,�Ȉ�����o�)�M�q���m�fJ�b�Kq���C�,�sQ{�	����3��돯�?�x����v3�����"z@���6w:e����Ń�|j���UL�^M�/��77�e����� ���geבG�J�/�C����UI�HO�����-����*e�@_o
 NO��c����7�I(ٞ�t��l��R¬���RY�~x�8� �7f�ɲ^�A�|S�uB()��
�W�5��R��l��%�-�TA��fQ����G�A�q)(��d��w{��A��}�3`��
�:�"������C�ս�h��G�C�b��0`�R�Ӽ����?��phTYK��3B-�5�"s��c\�ʛIB>���JU�9�˺U�,�^�`��=��82e�2�9F�%8���ۑ��ߧ" e`�����d���nONF1l+�!*ٛ;��;��T�)'9�P&|���^�ViY�ӮT-b2(�=�2K9�]ʫ��rm ݃�� �bxR��h��Ӭ�d�S��%�|�k�cϟ��O�ޝa�?� �&si1�m(�(r2� ʜ���IZ�P���!I� T4�`�)W��Wb�����*N�d��N��d���,� �h6�_�BӤ�Q����M��6����T��
Px^5���hc3����.��F��J��2Y��a���+<���A6؟���ļu�Ó5R�X����|�ÀMz��2����h*�[V�yTQ��	��dn��N��KW.k��ot�u�~@�V�ڴ9�Z|ma���L��F�x9A�i�r+W����V�7o�~ȉS_�<v߉�����/�/]@'�K)VPֳ���U�2�fny��1���0a��b�)(�t��,�w� ��E)�<Tm��Q^]�>���X>le�c΢�>��RC����)�W	�wc�p���<��Z�O_�'pc>�E�Q�S���iU��d<ؼ�L��|�C�c_㝹��Z˧���y!*�.����PyԆ2$�I���1c:��@&X�-��W�¿�~��ӗߞ>~����߉����ʌ�9DS���;S���z�eg�~��Vu�P��[t����8�ǘ�LT5>I�{�}�->�5A��(��Pɀ[�wZae�󊏁�₳�������b������R@(_GM��ZC٥u��NqI1E���:�/���p{t��[��U.���xJ����?<�����'~Qy���H���OQ��.�tUM�[������^C���9����C��;Y��s��j(���j:��ߠ�v\�W�z7L�:e�4�mǴ�;�	6�~�#(��$�W�C�0�a�{�oU��!���=��Yk�8�U�U삳���[5Q�b-?dw�l�	��mZbJ�w�Vc�2Q	�!��Q�BƆ�P\se��(�{ͥ[sS�7V�U"˺ �@'��;#W����t]�E&��B�#t�r����Kl��2t)�S��|�Y`�T�ijgj�u�eH��������U�p֎�"�d;CI��b3��"�����"�����n�#���Q�fnTf��!�ܴ}(:<Ȯ��,���fE&�"4%]n<��� KM�*w����y�� �S�4#*��M�"*�=�<67��
f��d�ӆ�D	���|bUk>���g�zv-F��0�娴Fs�2�Ԯ�M�7!�Np���9�=@Yo���ʍ]Z�K��A��^L�z���pXs�XJb��ziiZ�a0�mw
<�UƆ�d����_;�8�U��Z�.���
��u73fI:��a��	����%�0�ֳQq6� e'�+9����Ɔ���F��KCzX���v�iS;�'S�    W��vS�cuU�g� ����O��%pVn����ʮ��nF�5:xDHA��	�.��������W��heG�p舜q��+v S+���.�:��}Le(�l�ԊZJ���0d�	�NE��(_��s��Wds��b�s��[���Ȯ�_�qУ�X,z�]�(�[#+�|Z��4�Q
�E�y��ʏ��A����*��U�M���D�����aY���q�c�So�$�]Hm%�>�=�z�e���t��n�b�7�g6�cLV]6��q!5�v��վ�]�ot-O.am��_g]HC`�b��7��ϻ�,���2v��`}��d�B3���a�IJ��H��N��Sd����J
���7:6�<&K��C��������	��R?w�I��6�n���-Ev�e��q��+�F ,�N��6��c (�(7�_��U�Bݱ5�d�@�,L1�ȏ�l,��T}p��,��j����1uX��v_��J��,bq���
S�E6�t�9 �]��l:�E�{l��.BdjP������ͭvJ;�Ju��]6��hT(a�{���5���&��M.D;݅I���S��z�	�����$h/!*m��#O�+<��f���;7��砬�xO��1Tǰ���k��Aq}C�e��ӈ��R�{���"�`>:�yʮ��<�h]�M��#��<�|t&N�G!���	'A�L>�4s�]�����|��z�IF����k��nGjє������8� e2[lQ�S!7�L�S��Ig��P��x)��8�'/�~�x��s&q�����ÑZ�F�%�����\�#���8�d��SKָ�ҳҵ�}�u����Nϥ������:�Ȅ�iF�܎Ʃ���Ip�My� (�u�I���'�X�,�~:�1,�l*�ﲾ��e�\+��-6���X��c�K�����\H)g���Z����Zn���k2��������;^���G�ç�-.�^��P��<t�֒e�ꧺȤ����^�m�:e����N'u͙ź��c�����d��9�Am����+2q.�\�85��4S���HD��Xd�9�d�>��eC���q���a|�A�����*�Px�X<��.��p
�,�����q��9�.�6�ﲁ���2̮��2���/Dq[�e�3�d�ID>٧m�AJh���`5�E��[wR����[#w��8%�G&	S���~��35�	���[ns���]��|I�V�d�L�HN"F>����f����dQ��J���}`�*��0�(�:�v���v_���L^�Ñ��Um;���#���az(��W&!������]��N�[�I�d�ݴJ��&pw�D�yDa���8���s�����+�s�5e���Sk�����Qoq��e����|j����[���ʟ������_�6T`���c��7��~,2i��$��B��E�d��*�?�Y��_�>L[;�:��F;L���=>(I�(�&r��#�W�������ۮimׄ���^�Pvq�����6i.���w�0is��[�p��NI\�f�h��%V��Y�UB��$"��w��5^�v�?|�z���1��(�N������a��Q��d�B� O�B�g�0�	�d>�iD&+dq���-�8Ž���bl�Wst�e� �oS~�0���Ň�V|��	�C�}��"b'LU�k�R1ʄ��r7LJ�Y�V�y�ev�P�2��8�(^��s�@��T��S����B^\�>bg��k���8(����I���L����$��ޘ�SdR�l�R��6��.�e�(����^,d��aq1F�`�憸D��'	��&�{L����FCY��9��\�2.I-�o���ɘ���u��r����=,�+�e[b6Lg�cP�d!�ʥ��49�\�d1�K�r�"΍��dV��p���E������8Q���6	�H&R��S�T}��H�J\�u"j�.���*WV&U�[�2[�u"r�i����>�ߐFeҢ��ӑe��
[���R�?���$�Zn!����G���U�6�z,-N+�[w'6p2*+,�BT��}�ԐzS˟���^�e�κ��H"S�6�$4�);}��?�C��R�9D*D�����\����Lұ�0�	iFFm(����[�U�9#�%W�!���T_�w���1�v�e#l30xd�1~w�ɏ��W��R~bX�+'�p���)[k�h)�A�[S�I˦D�2�����ΎqM��2Bhs�q�3ƾͽg$�9�N�>��5��R�2��{�
���F�MYd�$M8� j���dM8&���=�~�X({K��]/O��_���D��o{�1�v!D*I0?�&�O2v
E��g��-��ܟ[?��1��(��>�+��g\����#����+��i�E�Uy�)��� /x����l��e�ƾ���~q�;|��=�+ƾS���T�v��uٙeq�忢]�U��gN)C�v�cP���y�u&������7��7�a��n��F��m����3y�Y��������RV�9��gS�	��{5OG�ف�Fx�0Ʌ���ߜ�9�(Kr�"ԝ/��NK�be�;ٴ���������&Lش��tyГ$��<}���!��{�i�S���1*>��5�u�fQ;0�L8E� m���D<�S\~���Q0I8�F3�u�٨͒�f�b)�o����G�a�i��lޑ&Bd��C�sm'�ug�jc�湄�@���^�;v��+c~�T�!F�m>Iةl��<�cP6`R���-�v�'e�E9kD*5)
S�����3���D쳴���@Y�gi�VSx
#�dG&uY��d.�YB�"l���o��Sؚ/l�q"���wY'��)��`t�NK�f
0\�D��4!��o�pl���]��13G7��슙��*���!�f(cfyn�8�t���f� ��̩���1�f�9o�3����n.�z(;�X��\�n�@�h�H��êAd�2i'�IĜ�d�ڎ��#����뇏/�?=�|��}��>������o�^_��xm��O�v�F�����t>����L��T]-�+�<E� �Zd��iD�J��KPvy%u\�KG�V�yq%�����a���Q��&��9P�m%�����_O9����rn�|�IѾ:��</i�
�N�"��r�D���7
[6lH�0R�|�2K������������$e�^���2eg>�=��A�`�<�c���gƆ(���IF鸫B��S���f����K1(�oٸ�7e�8���b�0�^�c��LZ��@`1�p�](cH�ѲSHeҖ�S���jj��SuU�]v���؃�=3�M�]768�\�X��d�t�S���k�ߘ�eR�nh�����Zf�&E8��0�6DRfCL"v�G���.&�˄A'p�
�v��M��"#w
�e"��4�xo?���:��qT�qm��W��p��IǉMGمW��jm�i�m�_�Nv:=�W�pLJ�r�|MP66&�Q5��Ҷ���:,C���(2Yu�4"v��!���:�V��΃i7������n4��:�q����o����闗o�>���ٌ�����g��s��֙��:����+�k���6�c_�L�OW��ͻ�����8�����2J�Ɨ��EQ~���|��k�r��C���˚!T4�ׯ*��i��Qz|2��$b�o�&�(�,�I�e�������
dp�+�T���R���~q0�63��wg�rc�ѽ�j�.�\�U���!n^[塟�6[��7��L��TTR������������_~���%,#1 �Ƣ���A6?y�gy��u�ak�~��L�Τ1c`��q����">��"�ctW{}-Q�i[Y�L8%�����h��(�l��v1��.�(gg1��w��"l�����o��39Je�E��|�-�2�4� e|jQi�ݐi
�,�������A�mQd�S�Nء�����.�u(fь�F�    �#4����L֡xq��M�T�qgٵr�@u��Dgq˞�	T�!�+� QxA�/^�H�٣�� /�=�#���瓫4�9̶C�c1��;T�y�?#����:�rk��L	"�fA�R�zqF��٦g39� E����+�$�ٞ_�V�tyg*@n�wg�m�W��z(�:Ȥ������¢�
�q8e���P&�P�C���Yu�P�U�<�
ʀ�����m�Z���8e���8�f�1d�d�A��څ!Ʊt���e��5ٷ�Z=�jd|c�l�$�VL��ˆ��qI��f	�1`U(���� �Ց�O�G�������97;V�E&
�"�M�c}/����r�L�_7p����/֭6�=��>c�Cw��Wp�Xߞ�8�N0���yC͉��)��l�gw-/�}���xQ#�e�ѵEgL��>aYժq�O��;F)L�fDeH�θ>adː�l릣�/�3Ud�����A&���VS��7rӨM�M!Z������2鄓)D�W�׆�f�eg���6��2���y��v�������Vg�<C����:��m��!^��3�Ǹ�g�l�ܹʮ؂�%ǦokV��x�̟��ۂ"D�5��7��\��N�G��(����N����0�J�=ћ#���{a =���&;S	5�ԕ�����C������0zr)��1�;ms�3dh�JP֫�i���?WZ�+�q��VT��3��1�n��,^�����r��d��4"�+B��o�L���9��T�+���st�Y���e�̷c�P
�>]Faǜ)���fli,�<����[�bS���D).گo7��eR�TyQ�3�"^��q��� ����ƃL8����y��AG�_l����2���X6�5z,9<��m�J������5�I�C��6}3��ׁ}�2yxF���.^i.���K2!�i����p�zQ����)���r^�eﱞ�/!nGk����q^_�>e'�d�֔2��^I͑�*X�4���5��Շ��du��������l��������w�K�ܒ���s�Q�^�D������0��4���g���	q9�ΐ�A��yDs/��{�b�|mQ�Q�\M硌�-��	"a�	�vm�`W�N��w�O��L#2�51@٘�[��zNpG��a�v�9�Vb���MK-Ӛ�җ&�K�A��$��s��d��9�$�U�n},]��~��f_s�k�6e�p<􎐠L�!rp�ΎQ�~�NC�tv��[J�lղ�z|Hl��0;��#�\>�7
�2��'\�?gt��Z�,��81�&��'�ɱ�>̓{�L�j��<��k�D\�����'��F�S�:�[��=��S�+Ud�����Ï�ߟ>�|�����,��x���͗����s�eb�C�sg�ÊoEqFd�R�ܛb�T�ť%=>���09�iI����5yL���oj&�j�=6C�2bQ�������wY���4��ޙ���^\�>�x�d�^�`d�<m;6�l�m-�,y&M��B����A�ߢ��&��/����o�Q+��kc^Y/V܌�hԁ*-4�Vhv���,;�(�U�q,�]��Nr'ޙ�jrE)�B�Ly�Tm/dD��^�լ
��:�@�M3�(_��s�>�Evi��X���e�^]�>c����Ɔ��A&p���F-�Z��5?�u�Of!N"�M�<�\ׇ �A&x��U�J>jzt�s�r�L���Ѐ�f���c�l��_3�Jħ:u�v�k���5���ɿ�-��f�pb(�Jՠ�L�D�4��}L�?�N�>`mo��<m*ۚpb��#]');���v۩��C��q�	���Y��Q(�D����	�4d8���C���2�[��$�x���9(���ہOj�؊�����?C�n~qf��0��IdrV���~�䐯�!���!�I8�tǩߣ"�fT�2]����ٱ�c��NҀ�W�LҨ�m�v�>чO��z[��ԹP�<�ɜӈR�B�sa�[wچ5^DK���P��squ}m�s���������10Y��4���=�:��W�Լ���%��1�z,ؕ� ���~�F��*1�
�qެ��@c�A����^G���f.��)�gE��@T�FMj�q�]��:�=f�o�^���N����W؄z�d׏}'�y�]�(�
xĹ�q�̴��>G�ЄV�+�^�#e����~|{x�	G̵�d�L\�3è:y���&fCY/��E�j�Q�ġI]�=0i���j�=�P6�ZxjG`��V屷hH� e��Q-b�U�Lب4�q�зS#J(�;�Usn�Θs4��Y�����[��F����z��1XX������ވӫ��t��%p�e�1�,�f�
|s��.w���>�Nt��=.�%�C�Dȡn([~�C����1�L�!Fa!�$e��t��ܛ6B�8���fI�Ӱ��G�2���)2��5ǨG�.R�6-ʆ2�M����f�>���'W�z`���"D�1�L�'�V>ѻL4���F�f�M��jQ!X��)ry*�ߞD�O��1gԭ��6��<�爃/u�����:Rx�6:�"�_jp��>'��%�Aٕ}v9�X%G����r��XUA��VU&l��s4����+�l�g����?�ޗ�������}��3��d'e�W[5���J����X)+��U�cׄ����2�PZ(*cs�C�X���z(U��ц�s�ÿ+c�+�ؼ2&C\���c�ހ���>�<�܇�����/�~~����бn�"�����g}Ƌl��NU����M˅�kc��8}I�!�YWPv�*�..:��k�b!�!�博�	�r�e���hfggP��I��gE[����tP&���iۭ�4Q��*h}�I"�w?iǇ=�j�d��x��^5h�2�+w�o���;��F�f�24N�0�Q6G�ů6��;�yLV�1�(_��k��]6�z�.�'{��,_�����;-�-�z?�f�N-��s�nR�C���A�(�m��l��>��N`�u�by4��v)%��hv���('fQ�z��٠lb�h\K�����ui�N	ժ���QLx�$9�I������OٱS|�~.�	���O_�fi�Cυ��ϧ�g��%�y���R2�B���'��"*y�����l ��Gݶ�Z���SB:"��,b�Ies������.��hխQ��sF/^�3/ۡrRv��#�x��?܏6Hd"2�s��w������*�疘5� �T=�L��.C���^z�nU����x�����IB~�A�陇Bʄ��m�1��H���*�<2A���$�(��B.�<���?w�Dd�� ��-a�}��O /~g��/��8�<��˛��'�lq����]�����b�����u�	G��l���S��u1�h��"p�iI���!Dv��I1b<<M�����Na���N-�x����k��U0=�0�Q5�(c�u��=�"��Ne�)B�J#"�G=T�d��i)��RX��(�D&;s��z!(މ8�fKo�{Z-<;�mS=D)�4�Ȕ�1��K7�]����y����ZdñGK�օ�2p��g#�C��N"Ӕ���P֦R��};����Gg�L`��gU߮E&�2W�5���NZq��Ƒ��9�A��1�� �b1i���)~��,&r�b!XL,�;ZL2f���2�YL�x��&�#���ʤ�_�IM6���N[b�:J`����2�}4��;+i�Vo���2i�s���~���v��+9)˕�D�p��.�c��A&��m\������$��C{��{q����-u��(�Ig�Nb�frk8�<�6A�ؼc8)�q�T���f6D�)M���4��E�"O��������Cʐ��e��`��TiIQ+�QJc6=FQ�f��c߃O K�2��I��z�R6��ݾFS�t�AʜNӈ�)T'��PMrcC� CTSʏ���"�f�j�Um�:.~C�C'�ï�KPd#%�I�i    h����R*���s̟�cRS���Hy����-�PKw������]]wƱ�	S�/j3�<>[���A��S�ɒ��ត!�������db:C�z�N./�=���&���P֛�Ҵm��mS���6�����1�ɞh2D/-*{�X6r�	���;�J�=��F\7X���Hh�+Hm�{-s��R�l�@Eh4�^6Ǳ|t��)�A֙�h���=O���L��1.aG�IB�{S���� ������9[_�ɞHe�٦�i�������0u�h�2ˤ] �;��k�w�IG=���%-����.'d�zS��iZ��mr���l�@%C��v	���ak�N��`�0�ٕ��U�[�d�M���&?:,nݞ�d��Q
��IFyhړk���eb3�3�L4���e*�i��ll�	��ؐ����\���`U�k]8������?��&&�('�A��|� �ʫ}�w�@o�691s�u��+��rٝ��2qk�ID�B<����t�S������.Oy�P֛��K5Ps��[L!��ol�$��L��F�a8A�0�a�;u����rk� e¸���Li�����љ�p�X�E&���#{5Ο<"\׫Xd2�O3� R6��U>�\���yr��׏O��+0�z����K#�qO֔JP&��������E)�tfH��'�2��$"�i�I��dT���L��"�����wV��E=Hij�&�q��uʉ$�z�u�%w����~�3ˠI���칞F�>�=��u���Jܱ8��]�b�]&��Q�M"�~Ջ�1��_�O����ӌ�\��\�I�o��s�
�l��V���?c�ժ-G��k�8���f	5h-=�����q�>pL�vn������s�*Ԁ����H���-t��+�M����)�-�*� (�I�=<��>��Q8��)�u��I�Ț�~���ɒ+;1���C��$�9���F'��|�#�Iw�yѹ�h]�����)U�{�2�}�Ak���ٯ�!�M:8+Y:�����W	N��s��
�}�y�*��<�@�m"t�*�,ش�.CP��C�˃lFa�ʺ�Y�9��S�r�^�"�֢u�0=�M:���r�A�K[d��pQZ��C�пe�������*5*��]&� a1�Z�^�(^��&p�e	���
��
�9�Ak]=�9?ȮX�����;i�E5d����ֺ�q�Zg���i�\�oTWR��e����fP�Rg6�f1~��V�q��1Sd'��5J��1*���U.��P�����W�F�B����{��.NN�"���yDQvHO�B������JN�o����巧��������`���=.��f�A&��c1�oP��%xl`JG�� J��L���N /TQ�P�Nf��Uv�(���
@���R-I��P�0Ev�	��n�C=E���Av��:�m�����9�D�'�E�9I�̝��9:�0�� fw4-[2�ͩf�{\3k��c��(�$a'g�F�`�d��,)U�ؘ�8�anc�bW�$%_���i"ϯ��n>>�f(NY<:˰3�����"�T��'�q��A&m#�j���;�l��'8��0E^�HC�����e7 :So�]�E���?_���4�ȔԆ�,�v���c;n�!̓��jĶd�R�{�Жd!���%#�{�6��S�E&����xA�Ϻ��,A��Z��&�b���܆@'��G�O�9����19��z���͑ۨ�y�6:��t�k�HMϡ�P6�.�6w��Я�t�̈́�5k�D�Q:(��f԰�Ԉ	Kq�??���׻�����O�@[S����Q�Seg��[�
�|������,,�5���1Ⱦ�{���5���G�j(�TBߠ�V4e�j�߬�6�(�4E�)Ej�zOf�d��q�[
�MJ��,.�A�W�s���,)pV7Ui'�b;q�R�Ki'�Pv���$��5JwI��Ev�����~e�8�]��9��_�爎W�ZKҒ��R��2y�����3�֠4���͆ �]S'��F�oo���N��+���l��]C����~�����e��Y�~��}f	/�s��3���^�nE6`�5=�
ii�j���
��q���I�N+��ұdp� e���Mf������rű9�C���$"���фs��5P�E����Q������ݦV@�eg����f_�L�>c�皘�]&�3f�&^�'H�H�N�vv8JI��FY��ID+m����f]���Y��{�����Z���~�I�>M"��O/��s7z���7O=�~����w��������l����P��M0�N:�sGRP&rl���J6�-e�>�^8�$+��ZbQ�^\\� ���#΃�d�~�?g�C���L�oߴ�p�M���kI�k�Y���^�"����A�nO��>U��.z.=���AzI1�5&��gC��>GGt�H�Y�L^�׆�K���L���(��{��B�)D7�1Bcx��d݌���M�)�fY�	8"��!iꑱ��;_��M�1��!>a$ln���6��D�w呾�$���t�\������L��09�y����U�Ȓ�7<�qU��u�����c��%尧/�l���Y����!0�`��;��b�L����J\��F[Z����{[@�vH�(�@S�YL�d�ʡ@���(�� �{vr��%�(��'�"],�!�n�&� �ȁ������Ђ�fM�=a�2�6�� |�`0�.�R��Xf ����0N"B�"����x�����k<�!w֮q��W���[WA�Tb���,�e>�iDfχ����cq�$�緿ф�/3=d��?t�cUX\��V6�(�!Bi��IDf��;[d���s����sʮ���
aMZ����X(�x������8s��;�M�w$PyV�}y�I�3�����ki��)-�,@�d噓�|���r�e��^�� }�v`�>���(��V1X����M=�(js�x�-�7�|a��mJ��k������{J��(pse��]sU�c��:�IB��l�5�U�#�w�4"�3ni&��Sа58aJ�Jz�2��$�X�"�Cم8����D�V.�"�S��q
��J��8W%��HhG2�s��5A�@f}�</���\횘/���j���2ʱ(�����F��-R-*�#�E�x��(��O����T�5��C��M���}����1���SS�"���υ�I:m��K���uDd�c�b?�}�st�S���	'	j]Ŕ.��tP�vvwb'�fY�6mH8>*O*�XdBG�co�Qc�ܯ�~���]w��E�q	��L���������dV�b�#m���Jua�]6�ʶ�E��Z��B,@�d+[b��rc�&��Ve=��ES~�t�}v�����b'��d������_؇�'�-U?7�Κ`r��K�5AJ{�N!z6�5�S�����)7wC��*�mZVo��8/���1Ehׁ��{y=ވ����A�XC�i:�I��qM(RCtB����Lj<�R�h�ֻhK\��첾W�x��u���Af1�RB��((����l�C}Xr���)�����[6+9��b��b�o�E��$�[�cHC]�������	����4a	�j�7����yD�"�{|wٕEtzY���Y�����"�#���ҡ���2~��c��RJ�������P�ᾱ�ǹ�D�YĎ�Ak�8�.������J݊5�	Mh/w�d��$b�d�=_�-��!����̳#��1��96a��.��o8ψ/�v�.v̪:�ލX��v���s�m�ې��P���#�� E�<����O����V�L��c���}d6�͌��v��D��d���u.��+��n�l�6��=�K+y�����i�Y+�Y�,=wm�'�.y�!EX�n�0=��Qb[��eR����(ړ�L�29�k35#��5�<�ha*���'�R��2/��Ki��q�������~��������<}���緧߾��~���8R&Y����V�k|��d�vk��nõv��'|ĵ    ��	���8��:�S��d\֛]d�,t�K�m���b���b]<C��,�Y�N��LE���+ǩ��
�E8}�8E��N�,e��t�YƎ�����������߾t1��5k�0g�0��r����8�e<U�y-�(o� ����A-�W�.��2���-5��
��P&��Q�x*?�)��lB�����@���j
�&[�*����d�k���}���H��Q�Z����ID
�p�����W�/N�	V�n����P��O�~2�)2Ǧ	�kI��8�� ���4�.֯
jX����Ȳ+�y��y�k��g�����Mx���B�m#��i�g(-�	Ӣ��\�.�r ��:Ȅ��٩����pvF�L�M"��������)�Y�#�O<����ӏ��PT}Bx� Zk��U81���-��2��%M�J�E�`�nn�q�0Yf�4�����B5�$7�en�`�z��dl.�'��L{���'��=����N"vZ��0���X?;E&m��L��c��(mDi���9)+&�D��@cs�a�A&�
1s���i������ e9Γ�#�d�k���7IդKX��-1�M� /}�'��qf�y�u6��	̝�R�q��J��]Vo,�߲�83�~��LV�9��Q�O�+��2i�3�I5˺�d`��e6)G�!v�V�3}��vٕ�p��fl/^��"�F����8���>�����iO��V�Δ����5��[����y��)�ڱ�t���A��r�Q\W����VCY��PM��A��tt+�����N�D�$�����]u�]f�I)�,-�lT��k�%�;S�Z���z����(�yD�]>�*���d��V���2�荇��@�J�&ų�2P՟� �ώr�(Jh���tv�	�LY�D���H?d�d��e�lU���Nؚ�QT6h���倘�qGY���9*��o�Nac����L�9Dja+v�Z�+������WJ"\��B�6��r���dn�I����x��J\CـYcA>X&uf�W��HE��N8�f���d�5��Z��:�Td�WyY��2J��L��a�ֆ e��b���ֿ���7e�~]A==�6,뚔�>��V�AJ{�O!v��M�����w�4Nꢒ�t�Sڹ�o8�d ���s��HF��z�ﲉQ[�R-�T���7Oa�/7+��kW7ERJ/���.�9�N�lc$:�R����ہs�A�_\�]}Tjq�0��$�_���=T�	-��Em��ӄ�fC;ckQd!���7ZE���<t�=�r��a`wR����>/�oڡ<��,�I�NC��m�m�zhqq�I�Wz������_���C�ܳ�� e�+���落�ʤ��?���WO�Y��ƕ8�5Ć(�n�9F�i��Pҥ���3^d�0�'&�9�lg7E��a�5Y}���4X���A������8��<�����mL�{��w�	s��s�SǸF��n�!FQhd�P�3��Э1_d#3�x�s�e���pƒ�<�c�2O�$��2'�+?����.�k�q��G�
�Y/Ao�0C^�����iK�m�+&Q��mo�e��$∞�-��쪞I_+5�N�*U�g�@��Lb'���k�y�l��)2i�rER7Mm�+?�(��y����^d�����,Ghn%i������Gh�l����9)�,v�~��6ᴓP��D䦛���@�Z�"���.J94-�ـ㢝w|}=ـi�T�D�q��Hs��]��>4�h"]I+(�t}8��hn ]�o6�a�'�-8�f-4�i�:�4P�[DY�b��i�x�(���2�z��^l��B���\r�G4����������*BR<a�T*�\��`�&>�ǌ�f�Wf4�gв��Gcq�hd3��f�ӱ�WW� ���:�e��f�u�R��)gf�����ӨR����2�}�7���~�Uh�	V�8�q1�ڊ��!&��s�L蛛C����rU7�]&5�XJG�4W�~�����#���ZY�,���E��U+	3Q��i�p���gQ
����@�j���Xd�ˤɪX堯�/z{�<:�$�^�"�ݕ���uި�:w?x�M�e�e�~���T����&a��PY��I�Ns�Z�$ j1e��<�<��d2�S���J5�9J�v�N���+(��l�^�dLe��3N E9<���OL�\�������LXټ6�i7%~Uz�	S�;��6̙B�TT�F�9M�P�ib�6z�s�k�W���Z��X:&R�f;�[��4�A�8ȄI���]*z��eN����R��L"�N"Y� 7Kʚ�J���̥z�T6���oP��V�52�	�I%c -�����;�@�|��1�d�L��׶5���ˉ��:��p���$'o���%���9��<0�ST}Ke(�[Tи���M��^��d�򛈇����T��i��!���Ev�I�|�V9*�i����p*�l������b�^������2q������]bTv%��1Fa��܌�i͍I��_� z�=wY�{R�rۍL��D�o�K�]=I��S���W�g���ר�1dՓ���Z��2�P��ɜ}���a0�QQ(�I=T��ɘ�2o�vmo�> �a0'�2�$bǛ��3�Ꝭ����Gu{U�P�f�֛?*�}4��{�C��4P&NN�u�pRA�v~�O���!Jq�)�()|�4�dpP6Q��J�v%cL�p����%����m�ۻQ�&��<��|N"v[9 �Kd�J�'�����j�p��8Wi�R��ͯ
�,�I�0��V3l��bҪ`Ia⒎1��l�&\M&��ÔՋέ���|5��	D�򢃬?�9��n�?��4�# 8�顉��$�l�@Ky�:@���n�;J�_���)�`~�c;�Q�ˋfm��iL����(��04ݬ
&ͤ_Eh8L�]S�"���ID����\����p��L�܈�4벙^f��Ժ�1
�Mv"H͹�]l��2p?����;��n��^��MTb�C8(���N"��
��탻l�&dPcN�L�1�!�[ ��l�IĎ�ݸDMv&'(�ݚ::�R��YVmc@�}�mNɀ�Ʀ���T."&h�F�ȍ�UXd]��-{���3�̈́Q㠡�Lu�l�uTQ.�	�0m
qHM˚JO��.�i��t�=8:� �jZ!�PvAM;g�U�7.��J�z-�L�z��x��iI6��_>�(-�� t�
j���ʺW�]�a�lXRR�1x���P����*�=F�9G��a־�4��Vtﲳ�r������BU��9�=�� e��$"�ל��n������r<>�>���˶x��;1�=��V�r�O��!��:���u;�L�Iߔ��za�1�!�֞��� Y���h6�ҔC��������9D������ұir�菝�����qVf��g����{��:��͟[cd{�4��gd�S�-���5OI�v��R	*���|��	ʆ̫iV�}�[d�}5�h��M�)����l�����A��T6��T0����`�\��ɯӨ����,?w�s_A��o8����e���H;�?��#�%��Ҝb[��V =�uЦɤ�M�Kd�L�����-y�uJ��uߠ�2f�!8�h"��Y4������i��T���.�Iľ���uF�<�����������q(�
��qNI��>CX��;���1-.��\V!9�(b�8	�E6�Q����o�{��.%����X���ϲi�uB.x���yT���@wTܸ���8�eS�G�~��ǔ�������:-�j��9�����C=C�~�=�w�PO1�j���EL�������a:�A&�8K=ƶ�J��x��5�I�-�e8���$#���I��bL<��u�A6\���j��L�>�cX�T�OQr|���vSe������8>�W���炶g�)( ���8=}	�|	��T1���Pd�ݾ��~����?�~�@�|� O����u��� ����I���f	������G    t~�&�Jl	���6��مl\�D����]�[��c�[� H�;�ꀻegHY4��(�*�2����t���HE�[�{��H�8�5?�l����<bѯ�D��pL�Z��LX�F�~�4��wKƦ�n8g�0��m]HQu�$��TY>nw��Y�Z�d�2��.B��Q�ꢍ�0���D����LV�3��v�,]���ƃdҞjmu|�z
JԋsVy�!
ߘJ�3���$��&�8�� &�p�ۿ�Zb4^�� a�\�'�"��,��cbr�#W2i��Z_=�ަ .*�' ����RVm0�(�ϑ�*�MP&w�1m�NM���x�0�R��)n+���[?Ĥ2��@��/#ު�Z�Rv%R����S�Sb�P\{�����գ;�J�p�e�:��^�7f��P&�G�BԛBh5ײ���j�o#]��!� ��j�*���xM;�)��km`�g�ҍa�k')����Us��Ģ|R��l��(8�}T��yG�_�\����_�ȥ^�5e�/�����URe׎\�=������l6�P�JP&�m�I�K���yQJ?��죜#�4fn�z�5�e��U,���٘,�"J��Xx�uT��x�PKZ��?�~����)ڑ}�g47rXX����sര��N�"��ks�4�q�P��׽Ķ}]Lnhp�&�	<���!*��Dh>�lle(A�^�ՄdZ�����!/B3���>#�u��0e ��H�?;	�7D'�`�[@��0�+���fZ����X��7͝Z�g�'ȶ�������Tw���v��t$�q�QS=]h9*���Q�2C��X��I�:�RL��(�H������tql��s=���<)lUK���[h༆:7��qLV8�8�z��*������]qְ(�����rIo�������/��V�	�<���~���	?����m)����DZ���3��LZaYA�����3sS��q)m�2��i �x�Lvy7���y=�ɐd�n�v��aE�4�j�L�͛�4|H.6�L~Ŵ���:�xke�)kX��F���c�P6W'/"��X�& K���P��l��I���f<��^qV�Q9�4@����c�W;4M�λ�ή��u�|CTH�V���j�pԪ�X�,ؼU}�8x�lo��Pv��Q���q�c�l��!��^,�w�	 �IS8o�ģ����\�E��v��r��`�d�3�C�i����Ȥ��PE�����]�E�9P�/"�@���M�[@+N��?G�+뿢Ȥ��@�ב�Ӣ�u
�+L�;������b���J��XL�n{5k�����DC��dM�4L3&�m�fer�f vBuVT��e��-��ɧg���6fM6�1)KݚD��,gZ7Q6�45W\��%v���J�����o:���O_�����c��սX3*��f	v�m�2*4���bTe������gQ�j4fM1�(r9����c��2w�X}lݢ�9�4T4�w��;�.�S�#6kVQ]��!��auT4�7��= r����6�I/2��:�ȧ���`G	׮��"��fQ�_THN
���'����4�|5C�eﰚ����s!�W�zi5Om��,8AN=�D9��� ]8�It4�u�k��ײ*���o:I�rY����V,��4����|S��Kt^�4�AK��b��0�9o�	�B�6(Kkꬕ�l0��A�$P���%)c�Jٌ�!Vq y�����|
j(�F�<�dL7��j8��� e�I�Έ�� ��U'(�kf0����Ʃ���1H��zq�獩�n��9��]#�<�y��Pv���P��y�*��]v�^�t�H��R�p��c�����,�	����u��^�N���4�)�i��P�@CY� ��|ktGj$J�fYS�8��_�Az(����t-Y�
���6K�e�R~|���O�|������^��4QL%�Sr����	��k�#�Ej\�>������6���)`�0?iL�s�C��غ�#�e����$t��.y��o�L�!����&�%�����,R1���β�^A�-q2pR��Dl�cu�76�-T�B[�ϰ�Xdb�g�2�ZK�T��eZK���-�.,�F����8�f}���jWӧ1��Doye��$"�`��������,�I�LJ�]6��%���>�!HY��$"?ӧ5�c�iX�E&����Q����+=;�gR:sc�7ܞ���L:+��L�JKc#�)������/"v���!f;�>8���rk��Y�sR�7����x���>��,��lN��K�z�ng%�#~L�����d���0��$�9�OJ=�Y�z���QP�ά9t_oz*U}/>E���S�68�u%��4�����Lօ}r5��߼�P���2�j�5�^b���.�����qDkK�.;=��֒MR��o�����cG�'E4�	�3��%Y(m��ǀ��M�c��&	;�n�U��تy�.�v@`0�󚖸&�ۧyV����>�!�N�j�G�I(���]v��Hm-D�s�6�23:��Ƒ�L�Ƙ�t���p�\����]נG�7�}�LH	G���rLd$�"v
"j뚀�?�	] ��#L�l��]a|��:)r�"��ǧ��Q�]&tKq��j��1�K� ���R��mA>6�>���n�(�銂{K2k��%���*A�ȴ�E�ܼM�	ó�ײ�f���QX�ې�nU�8�:)�C�8�[�ITarXT�i{
�t�(-�ҸRCپ��~����q�-yP���Xb��!<Q�q���YyO�S��*C��IkcC柵�[s����n~p�%9��������	��7=����0YB��t�!�t��yo6�����a�SA���)�L^iB���K���8c��l�I��*��d���,UjH�-����U�??����۷��/?^���f~����ZҺ:́
��w.e�z�i4�.w&1�!ݙ6<���̝��9�HU��7�88Ql��$Be����Ԉ����j��0^3�NL�S��Vp�6�!
?M�1�0�� {�O�z\,V'c9D�iv��}�J٧�e��4t�O�Kw��<AL�=�ҩ���2>���yT�<����J!�ť�-�'����	����b츩���\d�q�܌�5,�L��f>�~�!JY,|�1��2�U�"�fe4�悙rdBmR���2N eY��뽕#�(W���A&�{��&��i2�ܺl���.i��^�i4�7�L�6�(���[��c��_u���	$C��C���S2�&��.m�	�	k�	k���̓���z���LXЎ���p�v\���j̮f�F�jڐ]̀����1�J���A6�!��-M��^E��{|��)b�3d������@�`5�f�dt�5�;�>	��1>�"N!����˽r_�fZG��Ĭ��"�]t��mՊ0%�@$ֺ���P�W���i��R2Q�.Q�IBqZ1f�C��A�+Cc�lXB
�c�JX��C�_[���Ц�.�8�B���#�Q�e�:�(�mF�Y��YѫAl�!�'d�,�Y�4������YO#EW]NLpqI~50�Nh*)&SI'�F�M�s]�w��������J�r\|�+�:F�� �m�lmj�,H5�H%n~�����4������q��8 �oM�*��<�Τ: t�M�3"�u��Wg��5
���I�_�㰁�ll��~��4(h5֨dZ�7Wz�Wp�w�;>KT����iP���*��=���d�q���n[H��@��ޤ Gu!K�nU�U�i�C�ݕ���w�r�����L���b���1�e�\Ł��Az(�%�O"�ؾ�^�m��"��ǒf[_%�q����u�$_��z�Ȼ	0��������q����)�N|�����U�]l,EM�G�����]��E]W%%j6�ً�.ڛg�v���̤�D��[����?�I���\M��B�rsg}B�s"�:Wz�"��$�ȗ���?������n#�(��A~��/�z��<CT�^x�4��]6����fqf���S����� ;E���n�!�����    Nޠ��g@If�[���9F��&He�5��YX�с�փt';}m�r%�@�<y�~x���뮪�.a	]��:c�Ύ�����C�\'r��\�ᡬ��p���Y������<��A���;����[��e�ɉw���%�Smm����0����嚿@�N빎(��U~�<� e3=��L�+uW�v��{�P�}���ޟ��=��������r�W��������h�Ƣ�z��2p�����0h���6����̿6�ؙ+ܪ�6ܬM�";�!ߔ]����f�,F���v���X%�����e�_��St̒��MG>����xJ8�"6!���]^D�}�a���U��b!�ˮ>�ҁ��]����Љ�{���0��u9��fuVck��΄o>���P�d��.�,D6Gȧ���b�m����z��F���ޚ�F��ԑ10�;���n�'(�Aл��H�n|���*���M`Gs`�dus��O�jݥ4���ռ�zIs�0����T��Ý�����q';�J����v���E
q:����:�ui����Q3Vڬ4K�e�4�'��4��C��6��6.a�ۉ�+�S��e��NȥݧhT �DQ)O���sz5���!LYn��J��z�;��1(��^��P��q Y�z�Tʄ�'-�j(m� ek��`A^4�ȩ"�����p���Xd��9J�Q��IK�����z�v3�/�9Jg]�f�`�nFC�g�A�'h�U;k O������He~���0v4:e�h�c��]6�lf��>��9���a�$���3m'Gh\8az�R���1�<����� �f�mgF'�h�u;��|,:���%L��ك���s��jm�1�,��=I�⌱5o��K�!�����P��B'5�ޥɐ�ۮ�"qt���2�]*�l�T:�S�N E������sZ�����ڬ�f㢷keŻ�v�c�<���IĎ��8�6 ��(���tшn1�Y�^;��8&˩�D�-�6��G~(eq/�`��R�8uQ�H�q���l����Hv9M0~l|�d�7��)���v��2mv���ض��4���)'�y���A�7����6�I�T��X�-l����l��~�����r/����x5� %i����9*S�4��
J&W�w���,Q1����ЪԺش���HZ[��g~�	}Bs�[��e��@��x��u$-�;Y�~qi��c��v����v��t/ۧ�����YM��_�"�5�I��E���10�z<6���w��)�70������SΈm�u��g
��:-�jo����0D�K`?�34<�j�4hrǜ_Ai�oS��0����&��K7fe��^޴�v,O�ķ%�`�h��z�mԏ�y����~�_������X(������=t!ey���_B/���lb�H��>Rk��U�3{2<��MHn�͇���{�iLa��.��S�$��;�	(T��v��	�`�ּEE�&,���Ǝ
g�$SO�d>�YF�y�˶��f���N������2��.���9ȷ�2r}��;K'��{B'��E�x�kO?����e���OB���Z����Y��uq�"���̦:lG<�r�2al��ZD�N-��m#Lal�)�-�"��&��s'U]_�E&�vs���G;�4l�<��c����U��{P�M�-b�U�.;Y��tfs{_R�����[��*}/N�/�Ḛrz/�©B5A٘�[�S��~6��I�m.v����u���GF��`�;s�Œα��Y�}��(nyyU}؋�m����l���@.I9��1�:�-g�c8I(�:�0$ޅ<�򋘁_��+~�)3��p�2�3��*vB?�h�/5"0�D|~��c�>C�������{�BY�H�G3iq���F��KPv��W1Y����y5P6��En�C	�#e\�5i�9v�n��2�Z<�)Q�� O����|�أ�t�z�Q?��v�]M��3@IM+���Y��:r]?�9;|o��N�a;|�N�k�.b�WO����������xN�ٽA�LF�Y���r^�1Q\���I�]����Qv�f���<ᛌ��Z\/�O��<]Ϋ��Ә<��!�{�I[�����f��{�3��,��Rl^�bvX���ͱ��Q�q�Ճ��wk	k4�l�*å���{�F)m�Q�l:��?�z	�� q�s:7�O�1���(�q&�v&1��yt�l�in�,H�D7�~�GhI)�8A��s=�y���I���|If�eW����:�0���ĵ�C��i;��YŔ��l���E~N����ܒBD��	�.�QU����<Y�v�Tq|v<Gy���/��Sҍ���#��9��k�(}�蕤؊��8#2�7X�1ϸؼ�C��v�$t��3�kO�)�!�q�]1$�3����[��΀�	�p=��oxz���E;G�9�Q��c��(��eR�`���^�q��9=Yv��IMF��½#���	H�y���Zy�^q���#�hv]|�+6�y�c`��x�3k� ЇNDGZ��A_�یFoW�,�6<v��1Gn��s�������TP��;P���
���������G�7�)� E��F�-2I�/o����b�N��s����Ci���]҈@u���e�%=̴A�d	�%���h�Ĺ��H�?ԋ��䷛3�Ee���jFU0M�,3Z+�9�%��A��|�����ƨ�k����2�f'%4K�J��k�l���8v6I�M����"h��� s��lT��K�8��Ȥ�����x�k�P��Z��Eַx�M�-����MW7���X����C8��5R(�#P:�Y��H�����ʟ��E-ZY�Э��D�8��z�8�Ѥ�vL~oOb�N��F(��	 B��\\l��ab���{d�0�$gn*)�����:3P�+���;�4W���W�A5;�bL��Mbr=�[�&7�������;l��P� �����n$tP?�Q{'�w���_��Jl��������F{�Cf�����c)d[]Hw���a=��F(+Dma�d���1�ճiʿ�Z�U��M5� �M�R@	Z�d-#����}Ǩgt����7���%E��|y�{`�v��R��=ƫ;|Fi��R�.�G�Ye��t�6����.۵h"�.<�Sc������?������o���n���1�7��Oa��0��K�(��i��L.�Sk�0��aJC�q�IN�/gcAPecm��e���3/XJM����f|C���I���%��5�oz�Es4��E(k��~~����o��_~�V�>��F��C�l�y�5@���vU��-��59����ZK�L����"���p��t4(Z��Ύ.�p�qRj ׉���ñ��Q6щ���m��!'|�ŤU%�����Đk(�{�y�R!ﭮ<B>�����d�m�^�"ֽ6�vL�.^Q5�)�/@�j�<�m5�ʪ]��!u�]�- J�G���_��!��m/��	��ۋ�d{�%̲�BJ�$z�&����$��c�|�*��`�w[��~���S�{��Ye�zJΈ���V	%Evd����Lb~)8�M��]�[ʽ�/��)~�pRP&�9�wn�_���:��}^��J��?䬖P�=��ҿ�����D^Yk.%2�뚣�����7R��h`t���V�Rxq���fg�h�'��Sy�� ��3XOӣ?)yǹ%hk�#;otK쾜�d�@r������Dv�����������;��z#FfɤY#��g�L��p��oU>׻lf�y�D-���xR�؞��'��M��=�˛~�IN��o���y��{��'��RL�8��~z佑��h���<Eys�T6ڻ�7������#y��-��IY�}4��	^E+���s�����[k��.�}���DB�x=�R����߲�XC`�opӊ;N�!1FA�|ǩ�o�p���!|0��g�vzi����Ѥy�=0y�t���q��k:BY�f+����g�i칆s'	M�.	���I�NccM�I`+�u��̸Ŭ�]Y6 a  �qKl��Avbd�75�h��2Y�3��$��/хN����1Fy�q�w^x����U-�����?Tmڮ]���.;>��l�3�J�URO9:������i��
�v�[�έ�����!U�~m�I�&�WZ|TIý��{�`j(ߖ������y��j֞+*�U��.�wO��˷�_�=���ב��ܒ���;;��A��=��"�K��*MS�ܲ����`�R&�������`J��Q6�[�>�5X���e�x��o	�2d5�Ƈ�q��C�n����A�������|�hX6�)	���Am ���(�����&�D:��E}I��=A�,k9�TBwt1��q�C�r�      �      x�ܽ�\9r&���|���_T1IF�L�2�Uƞ��R�4W}�Uw����/����q2��.MI��p�De�/~�_�U/η�������P�O��*�"���?I�B��BJ|�B\��߾�����z������B����R�WJ��di�I����}%�+#^x`����o^�����y�����ן�6u��2z������c��F����4������}!T/*�K)2� ���
�Dx�5K�/��/O<����S`���Ǳ%���^X�<�o��R��N0�z�k�Q�3�7w7�o߳P�TZ�Rr���X���#�n��#&
�c)#:[�ł��%��3�w�7��)��+�h:�Ųl�-�����	=W���#[9�I���O�o�_i�)�=�ĳ<-� &13 :��@9�?�́(�J�T2�,���gKЁ���$>���q��|�>�|�ÈzAmF(� ��d�;�D8�������W�?K�%���-�
��S�N���߶���<q��K��	O��1���l}8ߞ&@J��[�@T��ʈleDǳe
OL���DB6%3��z���������~�ן�>���n"B�!X~��l�h�3��0��$�S~ğ3*����q�n߾=π����S���HT��EQ�2:)�$!��R� D.��Y� LbX	�����}e��
<��9�U�; ���|�r��qĿ��_\+�t�:њC��DA4G�0>�ZKR�ŊL��Nq8-L��ڰ8\�C�e�ޯ9����*���v�~�^��̑D�e�xg�/őю�_�Ar=G��6���E�p�Љ�F����6d� N;�Ý�qܞg&D�N�z��o���*K�*+:J��:�0J�4I8�s6$��ɺ�x��������K��a�x�z�f��E$�V$���F�AB�̑�>�O�g�ː�����\�OW�Y)�>�]ѿ1,��@o�
-��,���W���.M
��#D�<y�v[�Y�]�J�l���e���)�x�����~�>�?�ޢ�����"F��u�T�l�u��%�01��'�K
��Q8$rt���9-����]h���:�EY��h�#t�,+�����U���{�2O�=z�,9����ᖗ�	c6��R�$��pD�p�=H��^�aǞ0hNغL��ȝ�  �B�q���|�T�!�g������\�����#�J�=���%y�i��_
�+��Q����'+>���SOV�%��>`<���Q��1~�	@
��bD$�G����o������OaI�E�ӵ����R@x&K��T,a��x��6D�QY�ڲl�����'�{��Lo��+G����]���4b0>لU��e�.պ]6<�����f�9��GpD�+���vl�m�墌@�=��<���Ǩ�
9����$�Rt�a�欏�b��p�6��������+�����B.����̐D$��{d���z˾�~;�>ڑ@A�`���G��mVHV(8B�#<~�F�%1>����Ҟ2� f�����XnYc�rK���t�;;9����z��+�?��[4xV C�$�I����0��Ny��!u:��t;=Y
���:]-ǚCh�a��b.��^�i��{�����89�Nԯ�A�+m����A���/��sO���C|g�@!r��;F���ڌ�����w]�}xa�b��:� [G���u�[�3���[�t�OFG�lZ)�� ]�^�ÄgA�4ƺBb��Y�׺��.���Ad'eb�'�ߢ�"�~
G�0��qģ4<�#2y�r�,���Ҷ�x� �v���P��OE.��em	�]����"j�2��ޯ-@l�r@��.[:@ϱn�����s�����	dH����R�� {Vk�BY�� )�sJ��ru5c
�X*���*��"1%\�����^�'�:�U��=��:��B.�W78KB��4�-��J	�qi�r�.�-U8wz�|t�{���?����-���G�ѳ1�-�t \n+�q@x.a����9?j��G0�+V��V��e�.u�A�����ox+r�1�_ ��"~�BG�X�e[�?�hG���o��Ѳ�)���w�!�tF�eD<.�z J���c�w�Z �ALJ=f�`S�-�ƺZ�@�/��w �8X�gS��E;���/�Ǜ3��"�*-��5��֨iA��~�??Z"��V��+y��C4mч�zw壎!Qf�d��	�u�m�kpk�r$o9�8Q�V����*�ℼ�j��%�k���;a�	wkj��e�����5}EiE�+6�0�.�aNa���m)�d���1('��C7���9r����>L�4cM��]2�	��k��E�����U=�����,9ۉ��Iʇ>
�,�.����9ٲd��(�~��N�O��# s�[4�A��V�:��G���U�oWc����:�}!�G ��GN���`Z�px����z�8��qL|��|���� ��fV��'K�1����,{�����!r��,/JP�Q�Q��A���]����D?.�^��{�!���$���صX.�7�/v����H#�D.!`D29]��L&�!E l,�|d�ʬ2=]� D�@�R�Ǒ����.�8��e�8R��&q�Q�wrV[on����A���mJaz*�`�	�hq������p���r��#8��L0Z��Ŋ��D]�pj�S���eO�|�� +r��-�����Ͽ��_��i>�^�(Kb��'K����ɢ���p�^9���AB�6ku �'�.
�b��w-�E�UC�Vzg��G(D�PN��ܾ=��=�͢b��5+�����,a�X$3`I��|��u�tnD��Kjg��@X��Cd�^__XS�����ꊜ�2��O8,%�z�����l�u��G��U��q�~wp���l&~6��G(���A�P�Aj(���|�B.~���1�<�P*ب�����X���2���]ڍX���(*lѡwm#�I��k(tW�����{zg��MW�����Q(H�������1t��-3J��DV��|z`��[9���e��JNy}�HJ���K��XA> �2\�=�~���v���Ƒ�6���_�t-�Ӕ �'U��!7T�K�������-D�hVp���9B���p�ل�B���"X��~:?\*��ZK	��`'$x�[����L6[AC/�1�q$r����w��D�Ֆ�1��P8a�����堄��� �?r���,˕�P&"�D��9�ދ֩���N�a1���f�Rl¬�\�Ǜ�ͼ�T����`	 �I����ν�����7��(&��M�lc��ϫ��O�`���N.�ɇ/ ��ߢ�����h��U�2G`~U�8�)9�Yr��O3+S5�D�
5by��ÐL��yk;"QuY�#HNI�lI	cyZ$��5.��^YQ�ـDU�f�"l��Q����*X�*X/��=���DL�^��D�H>�����|��5&a�jK�jK/��[
���b�Ö�*8���ć���p�:�D��`$Rp��7�8~#}ϑӈ�u���qrf����`��h���+ú[�u����Hx��iM5��%w��3�`�A�e$ba�l���X��m��%�j8]4��rG�!����k�Dі�͇�n>4/��n)�5�P���O��劜�|w��ĵU
x5�������H�nFBa���\��bB��ɺ�\����3?%��)�9a�_��j�����P���W����#�mS�bdI"g���w��Ơh��Q�E�������&��U��2_�M�sԵ�R�E�=˟-M~��$���	��\Z�@օd��5��\*M����pq�o�����D���r)����|��#?X��X,�7��.��H�c=�B��x{swǦ�G�A�����ړ�4\k8Y,C|4��9Y�}�(���mH��*    -��95�L;3��d��Kp��a���1���>���Ck�;wG����;�]E�8>�!5?����2�`��gq�'H�AN(���������p�/A#(وy�vh�O2���ƚaH"g�1؛ dT����l\�M����eSe9���G C�����'��%}�Ŋ��[�k�Yx눡���\k�
��zެ_i	H��Nk-��l��H��E��Zg��DF�u9s��;Ɣ��PX�&�1�ӗ�iDDF�H(8��fzier㷰_]�~��H��S�-զ�IL����b��,Hd�D"�]���:$;9�G�������y"ɴ�-e��j��\$<��&�~�yO	�>	����mG�u;"�z�ĸ�v솣L
=��~F���~��\��D�Lu��^�i���>7�m�(�B��������D�BGh��ā� ��X'ń�0\Δ����^Hv�8P�E�O�ob��
�m�$ͬX�L_tZ��&�H
�����T5 A	��@��k3N�G���Z���܃*�ْ��ܲ����_��~w:�$�05�UR�gL�`X�Ѷ��_��.`��JQ�0f1��
��M9%c��k>btG����{�@XGض��_w�������cl�%Ɗ@�O��<�(-.FY@bϚFۚư.^��Q��L��'r1�7�rS���9��P��l>E�=���U0v,Ζ�.�y]@�N���ԗ���\����bP��})�2���m@~���V�1��^�xK�+��;=Gam��9�����~�$Ь�	P֚��m[�uے%�K�D�H4���z.e��^�q��'�fI��E �ڪ�}"��hQ�e�?-�s�p	#�D.�"?%}7�l2�jȒ< ��w[
��3���_ش���fAHV.�!���¬I��etVdп���Ś�wu�KB"�Gz��^"֐��}x��Z?��}"��3$�m�X]�3��'��	�4\��QP��p`������$z���*y�y�w�����:������mqȖe{r�F�y�6_�JN�M����|�B�KV��b�*u���0�-%���i�SQ��iG,�S�p��^}]��Uޢ��f[�|��L��\W:��\WX�CT���D8H�oJYM����laȧØ�;vR�J!��dΏ�CZ<XB��I�-� 2,z�њ���
�A�s��58&V1���Y�
¦��Tp�#���C��/,u����kۯ��șrw5�DS�h�*!��}���W(a�1�B����J;�+:���U�;�'��K�(�j]��i�fEp�,zU�.ex����wt�CZ?��� 4�.���Qv�Tw�M���.;ۢ������s����h]�k��/�����ʮ/�X��D���x����ߏH��Ϸ�&<�W�ș'���6�.�ܢ��v�^ ׹(���j���=0�I�:��Io<TqV�̒G�h�)0]�6�{oZ ��m�JmDQ�8 )�R$q��JM+��#.A����޶@�ӁLM%�fz��3G�x�p�]��.��]²��Q!Q����Bޓ���₄��q��x��FRڳ%ץ�4���ln$�!
.��*��3�VHऴ�5��1�KO�����@_��ݽ6O}Up!1���O�����p�+��x�u91��s"'��nt)93��sS�@�- +�,���>�:Xb�P�e/����0Џ?�B�<���}{z7�
��jX'�/v�F��~}����2�q}km���z��x]������B�HC�kx�P��Z�����6O��W!�;���dԣ�C���~W�wկK�iJX�b�n��!�1hM�K��,�BXG���U�L%$�m�6+�s�ma�ȃ���H]�H�uzeӏ��ș+w�ߝ�&rB�q*��@�)ly��W��Hfy
C���U�Ũ<�ĨMXP�$���h�F�X�IH`>���S�V������7|��E6]{K��A�a���

[Y��Y�� +rfʣP��z��|qV%�BY�$ː�Y�e����3��nno���ǣFORZ	��˰�fX�b�}�q��c���E9#���4i�L��Yԛv��-�a��l��Z�*���!OF,�\RE�Ժ1ÂY��M��E�u�e���&��P{Z�.�@��Q�;����7Xck/r��*��*F��J�J�n����'������Ŀ�-t����г��j�
,�˞">����=������'.Kޗ���Rſ��w��Eb��kB�+[��>J�	=�S��zĢq���D�u%e�J���킅�'L/-���\D�t{��p�,M[���eѨ����+>���d� 9��ZK�]�1*r�`7o��2�7`���6��Uت;٪���d��=�-�JQ��=����u2��.U���< �i�3Va��]��U�#��F��5jl��TB;��yr� �;9s����|0�/i�7��#d���r�rYu9��^��v��3�ߝ_ϊ�]V�k�s�4�uW�D�����x<�	���X+�+	�lYT)e��1A��X"�3��a6�6�	8!4DaAe̚I՚IXVa0�o�f��>����_������ǿ���O*m�{"!7�* �* X���s6��iD�(��|���GX$ʠ�y��>�j��`9���xS,��d������ȘymF�V�c�����d�j�bXv,/H�.���T��������e����r��:m�V�X��>���4�G�Ѿ$�@�j1���%m�(Oe�ͺ�6�3.�j��������'g-���Mf�y�q����L�����jBb�7�OE2I����^Lvr�	���x/�D�Mi<�t�r�+N�h$�p���g�.�q���@���a�efͪ8,@?�R��H�m=�;\��8%{�ݨ��bC�)6B1h��������7�_~{�{���7��{B�~�m�+���ͱ�isT�DE.-��\N۷�>}1\��
�e����`\�40��B���\�'3	�� �J���P�P5A(���]j�Y�Bυo��Zr�/?���#�)����8:rl�\�nC4�]w�
�u0].��9b������X���)���\v�F�'i �v��i)��8������{6�w��F�-�<R4���P�+E5�苹j��D�i��NX!�?�Q+#��gQ��t_�YsiD�d]Vਰ��*>9(�B.���@ג�z��]d�-O2��"F>��HOa��z�5�2S�_�@�t��I�ZF{r9[w�m�.ג(��4��+撚wXͅ�K)�L�Z�J!����t7�b�j~S*�/�<��<��H��r�2���o:�D�%���Kr4.�V�X�G��.����fq�T�dbO�W���H�\�r$�e�b�%�x�`Zø:����{br)I�i�D��K&k\��=}g��bNVYҚ�������x�ŋ��$-��d��џ�\��	H�����J��L+�vq>���FO�DS�8��B�=�O<C��b�.�I���������D���J�`��p[~��-5$ �č��w����=���䦨�O�v�Q0����0+3�^*V;m!��ˏ��W��4V

L�AY�4�
�t/:���~z�18�9r{�+�	HTo4�(����0�`[Cb'�|J��<�% ����O���4������?�Ϟ'���p
Kr�	S���du�+Kg����x� ��/L��X�[�`R��Iv�w���2b"(LqG��"pa���D�m�!S<�|i�[`�RJr`ʨ�,fQG��z�8|�7$u�J�:�V]Ŕ��eK�$F~0���2�C�_QM�(*�HX=l=lWo��e]��xy2m=nE.w�7�\���>�i�M�裫�8����7v�q�� k:T�B0Q͵�#ȾA�۩"�#��](��Vm�=�p�d;nC�qe�-���p|=��wP�3_N�ooؕ��*Da����C�-ݕ[�gB�S>�4�WK˪[�J� %�v�diIW{&J�M��R�n�����2�
�,#�B3@l�    ���@�+Y��z�#�ET��8io��8IR����qv��A�7(�"����"�������6~��Va}�w�%�u�W]�x��Z�З{W�̒�qpE�
]���.z,,�J�b�c3h�b�W!g$�y�<�#܆�=�u�]�ڻu�� �p+`4�uT���������zm�m%YF֋t���]��D)x�\?>�"gA�;���$�B0�{�^hb:�6���O.��x5�Ҍ;1b���@<`�׳�]�����ǡz�Ѯ�_�����jOب��O�CY9a*�M(�Mw�	[�P�(,k'���F�z�����H�f"�b�t����[Gcȁ!r�����/�FQ�h���F��o͘[��t�>Ot�|���*r���|�'�<./1�lr[�%�^�_h��ZIH�������7����3W��?d���ـ�/��5���p��=���>˄-���TɈ%�[r��nOQ�4Z�h_Ɏ��ò�����db��9��K!,�n�fG��6����t�N�	���x��rB�j�r����y2���M6e����*���L0�����$kE����
�e��!���`=��V��<���&����mj�:@�`s�8��f���tY��"0���ycp6#�amLhm�_�)�N�F)�2�K���2b�&�c�Y�a��λ_B7s��E��p��̈́Ÿ-*2+��ʹ�����m&��i����+i6���Iv�N���D�D6--���.����T��{,�\\�ɠ��lA��-ّ!��H�Z��_.�ؼ��7��G$��g\�a{��R?a�+5ݴpc6⫵���K�0<r/�AV
�rg�&`��d�����_5����I��ݾ�E���X��sR� =e��K@2X��0-NV�Mc�BZ�DJ�<�̧�X3��D.Vf2v��(����M��E�Ƞ��hj�E��Ӭ ��l�[@�̍ޠ���Te'���#7}��d�D����x5(�Bn�+�,y��8�w@��Q@h�����K1zՒ��B�s��ӗ�=�x�ǌ�i�Ld=؁p}����B䒔y�p7e�$���,�g4�O�fi\��t<d8s��h{Q�F��﮵��ڌJ+T�f�ɻ�| (�������w>z��)XT��O�K�,~Pd�"f�g,b��+��5%7�B
�5��=��J@%�ڻ����YN}f�h����T97��v�4LYWc�L���g�&!�H!�E
<�g7�^��R�|��x�sO�H^Oec�%)dn��=��X��1�����&�I"g$�oر�	���$-���
�^\ȭ��ҝ�gB���5�,���ٌ@9��/,}�o�{����B�Z!�[�mq�-�(C��������7o'I�q��F��h-U�Gk<�/Y9Z9mI�NQ|��u�A��ڊ��*ҮziWG22�*ց�@BU�s�# $�ɏ@ldq���"�q�_UV��F����y�� �tu@�H�u�k�,����UI��M��ș%�!�	n�c�����&�Fܗ/^�a�^z��x? ���M8W��Xr�U|u�[L�B�Y ���5�9K���������X�(��N�I�L&\
�2��^��
�?=Ǽj+�9yË{���	
��Sr��������p����y2��,�_>�%b��ͳ�W�v�InD� h�,V�T@X����NJE�y6`?$F%�8�PQN��J�>	y�Ag�+r�?�^JȽ�&D�Q@SbYiW�e���t��Wy�9������}�����ϖ���N{�A9��nfcDcZ4��Iy��9��B��U9���O1������x�p�V�Sƚ�zPPx�V�+ްw��M@иj��}��; >z�^aC��f�n��5�e<�A���}�kE�`Nw��`1**d�T|�t���ڜSc���4rX����J�)��aJ��л�l���KX�W[�)_h�� ����3+�H��M��n�r�HKX�LJ&�d͕U�<�D�:y'g�|��p)@T���$�.H+)�3�k \�[z.Y �\��t���%������-����lu��~68�r�٢��LPa��\���D��H�ɮ$����p��3K�rD�Q8�0�P]�������H9.�"~��vr��������F��Mykq��F�F�4. �̈�8����s�M����N�/����n���G�H�9,U�8�ۇ��W��$����zװ[�[������m7
y)`4��ᬍ�B<¬?9W�tx-0��2������+�q�N�>r^���}a���ю�Ӡ��V{-B�S=�7%�|tkX+r�1kT�E+�I��%7���lT@$��JsU�*�&H�����B�HP�v�`Tr��x7S��p�w�ݠ��0��w�1c��� *7�p���$DkOj$���J��e�w�."g$�&�G!WZk��'HL��h��d�6��
�����!(�r���� 8/�l���ƍ��=G��S��g�B.ɌCZn�oL�׳�0-?V�m*�����s�{{����|��Ŭ8(Mc�!��v�&;8�����f�F�ou�1n`hDҚ��f�)��e��,W�K,s:�O�2�#qĞ�T ��4�n�d��`nWCRQ��J!�f����]�Tx�~�B�P{�l{���91G}��E,��D%�woy�i�\(0�p1����V���� �D����q�J�G���oW8�Nr��hoK���9��v5�)2��`Q�3G>>|���vv���1��ފ��K	VRl�P�1�%އ>�6�߷�Ml����1�\ȍE�h�=rA8\��1�'E~�g�bQ�Q����9^�wH�m��+5 ��B�@�??����TnZ��	��H�e�xi�`t�W������i�h�~��;-&�)��an%-�i���"�G.�5�A�%���<����B�Miep��F ����M:SY�BI�^���p����G��;"O���2��z�ˢ�665�I"�;��ۉ��7�1��Z��b�x���X�R㘲���8�\��и�͓A��GZ?Q����@�}_�%sq\ș!��lz�dJ�yZj��<�26�y8�xȾru�[u�H! Ҏ��zڤcn"%��h<���sD(��&��KQ��������R�47e��358��ϣ��_m����M�!�7#@Sm۵��Q��s���3r�G�f�EQ��J�c=�,���B)��c,�G���%o��Yv��-��qA)�1\ȏg�h~#y�NK�Hس�ڳ�ֱG��JZ�U��Ef�ُ��Pڷ��,*[�GԒ�&�������/u���lQ���u}��S��܄7����BK?j����$�L�޸�[+rb��ˏ����&\��.8�<��b�O�<*�m��1O/�������g�<���a��FQq��\f�B��,}8�����i�C)�|���p��YR�����P��q��L���r��+�"�"붛;4�P8��Є�K\��S"E��<3�4���vjc
S�B9 �&�(�1�W�`PZ�� �k��k s�P{Rg��>��
B��*n��_j��;��Ψ��Hoa�B�@>�p�?[ІX��a36� �.�Ȼ�ȯf���Rv��b����t}���<-�Kh /�y�#�:��u��z6�p�c:���R�wM|~s��@)���'��Y�\kV
��rw`E(�,) ��)PL�0P����t�4I�[ȝ��.@&�G�jTܼ0ڎW��I�oKrh[0�8�3����Yڎ�7J@j��A)�%������P.'>17�<&r���' �Ƴ�l�<	mfx��� H�9) U������a��/�w��Fgۢ�bM�7��r��81���u*��X��^�J�b���-v���2Ҝ�[�*h9�|!����G�Y-!�ݥ���+������eOR����	����D.\�a��$`���pu�K
���6[d�sܘ�;r�ӎb�۔�\��G�`糎�^�)�q�㲜��W:��}
v�&wraʗ�̐�b�{X    v���U�a��*/��ӣ�e5��N^�LD�n� *�\��_f)I�
v.mV*�{�G�;L��ߧOU<ST �K�R�$:Z3Ua��	 �A�ZY��6h�B���o���	���,8�=�y0R\� �U�庒SⲄ�����Cc,k��~���Q�b�`��6n	��̕�8}�����96�#�D�$(gH�0�����7Q��5H֬~��K�'�A�	�L���~�̥Z3O#B<�N<�d������Eڝ?�@d4�dnb#-gj�����S����F �\��$�6/�4d(9}�k��_Y�q��UM�1yݳd'�w�o�82!���~S16$��9y���w4?��^��rqdz,tR=�B�HJ�*�$��)�,HL~%<�Iw�h���p��Ҙ
��R�=^�=^a�x��Q	*���)�\���peF���6��pW���8ELYKS4H&�1-q�R�;���Ŀ�.��� ����Ț���h�o��Xw���\�|��引����AKO����Beq�A>��4~v�e�5�>]�ȼ���b)��@���d5��F�����r�8Ú�_���������@���,���oa��I�"��_w5�p�-�4m����Ǭ�P���.W��*@L[����x3�cjf%f�78��nZ#삵�2��Y�0�2�=�A��x���Hz��xNQ���)����d-(��pw,�������;�Bk�(݅ZLs^1nek�����Y��ೇ]֥&w6�;_��*ʾӁ����R�~�⎉��r�������B���	B�6c|
����Jiw|�;IHpq�ڐu�粒�=	��`%��\��/ܦ���-8�O�ޟ�@�t&iK<\��0VaJ�x��X�M�tMt>\�.�EI�|���h��䤌.v~����zx�&'�#��ik�jr��1����x����jî�_@��	��L�e�郙:�p��/d������埿��ǉ�Zp�(Ў������E���PB�)S���q&9�����{�P��@��;�a���Z�w� tk>֜/T����H ���Ku�k�(��P�G��r9_����ΗɅ�Jy�V���sR5L�a�X�#A$5���*������o�:E�����7��!Ai�Z�~?ad�I�~"v{�$�,�_��d���W��'U��V&]�ɽ����	+�]�����#�!����
]<J=u���~A�T��yIMI
vr��Ɋ^����0�7t�;��B��_����2�hw����h��g��H���7��]X3��I�?��3���xĤ���L(�ۈ�x�қgl�
T��Nˑ�H�
ks@������'�F$����f
�ѵk<^*��)v���d�beG���W��z���e�����_�| G�Q.�a�z��u7̖ʣ��o�]+5�d[N�\�w���������q=��z�Ֆ����H�)_2BI�bY�q�	�L��(�T���Z�PK@���nu|�u9Xr��x���뙼�}���p{�b��H�ɋ\[����g���� �ۯkr��Ǉ��Ӣ	�����G(��[�wP�]ʣ6�����<�Q9/�N����tX��6'�H�X?B�e=*3A�K�n�fM.l98c	�1w?�q�Έ���2��s1Q|�Y0���f�]ޢ��~��h�,�Mfm�zV����@�@"g0��GbiB�ͅ.lk�4����Y��ȗ�~z��_��?�᧗�s��?����ᆜ}����SZ+�����3���]��?�}���pk�M��ػ)a5ݔ�S����17�ykhz�M��yL����7*0�X��1(����P�;fɵU����C�YڑH5��=��/s$xQ��\GJ�5��3�j=y	�&�`^93������jgq�[P	
;e@�����������`~�*_;����r������A�����mՍm���*�f5KԣjI1�Nv��:i~IXp�l`ejg�	I�����q��?��8��ܐ4���}=:p;9�����S���I���R�.;�F�.9�8�2kˣT�D����DΜ��Պ����x ��Z#M��z��cr�����>��ə'�0@n.����s��ZLv�k�>�lt����)��Q�`�5M��"�v_��7esA���r�`���f~�V��p����ZV�����tݥ#&i��/=��l���w����h1��̟�]n[P4��6X<�*,�HI���%z.i�Ye'�̩f|�Ol�J�c-��'�q{�/�!N�}z����&�������9�8�)8��uŬ�ଵ!7p8�I��ÛD.p~��o=cpy��X��YM�I`+���<�Q�r-�s��������_9 ��#����EhX�_��s�W�:&��zkݷ���ډa�Y��P5���K@,�CfC��V�G`�<-�~��ע"���?��ӏ��$(iE�u����w��D(f5�N��f����f�y��<�f��K���q΀4hcX�_MP�P�o�k(�	�w�}-iE�n�gH��4DQA��P�Z�,&�#������\�rbG�d$��tt<�ݿ��/���w�g�9Z?��SA�8�<91�uq�uY��k0�H��Q�	+���D["�$.��w��ޏ��V�y��ף�b��#���y��9h&�3��N�����N#�#��X笐�9��x���}�+@�����e˗Ź����9z��S#�D�U�O|�,�g�y��R�)t/:0g���� ]��\{�T��������рH���)��|Nr:�'�P��uT�&.MZcuP���=�IS��4Z�x`��H���1�e��5�jL��iL;=B�N_�u��#5|.�ڍ��W<��LI�15oX;⟉%���O��՘F�Jo4������>,� v�����g�2�	�9��Y�%{v�Ġ�	A(E�a������� j(S������$��=$��a�v3�u�*��һ�S�2����P�06`'�>dhBm�|(��b9(�8�FUdq?{��K
��̭BIH�A��R�8�#}gs�rfc��Ζ	�s�v�B�P^bg��'-]��� Er�:8�wp�O}�M.sɬX!g(_>�=����4굊��uoB�ެMV�����x3�j�|��T����GQaUX�T�Y�@ߤe��4H=�J!g(��Nw�q4�8�/}�FG�4v�б&,�yH�y�q6��-��S��ps��F��J� ۄ.�6�EO�.3=�*r������YB�Ҡ\\���ة��Z /h���tc��.��jd`M.���w�$>�]�@G�n�e��y�G���W�sz!\a�|XQz�p��m�Uu�,�Z��j<��^\QmڀGUu\W����i��.�º�r	���4���S�n�'X��5�:�9����uň'��������Jӹ�u�8����կT��e+-���s�9�=�B�X>����?W�֔�9����x�wް�t�
˘p��B!&�APu�3aZ�P^�ajzkG5W�m������ <s4}��
���d?ٌ��:э�$rQg>��I��gm�2F��Y7�%�ɖo�7��p�
y��~wsw������6�͛�R���J6�G�Ų�]F'9(��_
��y}×�A^�j��h����lpRv��~B��0)q��ތ�{`L"_��k/��ך���0�l�6�Ψ�����Ѱik�I�m�J6���ϕ��5��6�/�ڴTk�
FV��1��
H�q᧪g6@�?[�����sA�UaU�/܂��$�K��s��V�sd�b��]J��I�Y$��k���JM��X�ptMx=���s ��I|���=���h^PX�l����}�|�v�2�Ǵlw����go_����±a���C�d,��s5��K����
�E��ieV�U'��s���N/N�!-���$�̜?��s���A�:����e�//�k,SK�+�K��%Q    ��}�-D���O�}���=]�i���et{qV&���J5Q�Zܹp�R��nS&LF�|ss;�
��������8������� 	��>��?fgl5To5o��3郖�R����+���q��&5.�9��M\U��x�_Q֩��mFW�edV�����	V��K!W�����
QN��x��~t]�lu�o�eb#m�g���QB�"o��+Yv4�R�v��'P]LE�WzP_�\�����~*�} [-l����د���o2��$�w�uP
y�BY>>Y��gpv|p�⦕_���4�Q���N�������EC8f�jF�@GH�$���.��S_�q�#9S��d�B��f4��<�y�������c��	��\�Ťo҇���@����"��)w����S}3t��Yۢ����&��d�/{J&���PQ%rB�8��MZ��%�Թ^5�ϧl�GaR&���Ѫ��E�^5��Z\�@���;n�8u]��~^��N]�����R~�:u9 `P�a��S�@�yg-� ��gt��u��pJ:4�
��S���g�󔠤�m,��d; A�&��{�>L,�_2��+��_��H$6x�hy��8
��y����_��j�`�0͜k���by�w���w���-�y6�G%�C5HNz!�%�)��ٌS��C�m�W��?���\��e��ND/8;�������@D4I��Gw�g�ܮA�;��ڎ��4�9{����0�T�}5U���~��ǛX�sF���Â-�Q?;H�úӦM�(�5w���p�܄'F,�\�~�4Pô��S,N<�:�q
�����)���5;W�̔ϓ���g�	<�i��e��2��,��2L��؉���(w��`��r�ssw���yfp��6��N8Ȝ�2�V̉��{󖎙.�~ۙ�C)[����!byC�f]k�P!��<����L��Iї����s��*��T�7SD����h\����!'ρ��兺�	����'���[T=�� ���Κ:��\�>�Y���8(4�"�k��ن�Z:(��M�_1��ݟs�#*_��3�G/@@l�i�a�XkcE�ן��Uj��oi+򞼙�q/P�{&��#Ђ��Z��dq
��,�c3��ʓ"g�������~����t�ߤ��hvX���v	�~2��6=�4����Ȼ�>�������Az,��UOq�ig��1+S���&�+�k?G-F����s�?�9���OR˵��2�ʮQ�CV}M-+L�K�3�A��l��\	w��2go�0GQ�6�B�̹�) ȎZtӜ!�a�X��f�,��\���+D�X�o?O�4:� b%��Z��ZK�XK�8�MWkh&�������;ߝ'�3���q��$���K����]45����� �7�;�b�?�����1^!8��t�����D7�������ӛ��I��2`����T�F=�9�{5���G���e��ǩ�7�D��:@�N�P:$�KC�eS��f*��s�yW��P�c&��;�A9�A1O���6�s��*r�r{�ឋ�unY�l+4�gl'�r�òn��*��gt8�K!_�ܾ�ƚX����;�5;3D9;�Ѣ��g2aƙ	zn՜�W��)6x@]���|����t�}u� �k�!g�wz?���;���Q"_ؔ��R��k$��5V���#2�E�-*dI�L�:�w:yu*zfb0��L"0�}���w.h 6c�Ö:�X���l�b5M�V3g�lf�e�\�L]L����8Lb{Ƃ�ز����T z�e_0_��b��	��#��,�<a�iU�l�tOjhҹI��3�肍ƿ�/a��4�I�pl���XO�l`���]�φES��j��[�.w�A�JsS��y9m:7��B�Ȼg��,�$( �x�r���X��uo�<�m��GC�����y}~?G��"F5֐�agQ��(i��՚9ZC���dlF����yj;	
��9�b v܉򝋆����ސ>1��D�Ŗ��ۛ������%X�94�3���Ŗ4���U���'�nmNwl;���I���i�{�� U�	�',,^9WPfΙ�!��	+䒚yI���"S�� ���z>#��5�z���u�%��k~����)s92c�Av��ZO̖kv9�.��%��E f2���hIc��3C��iAv�2
�Ҕ=}Y03q�&nn����O|�a��OBt��Q�N'+ Y	8d�pC�l�,[�ⳉ#�iNI�rA�w�& �ڀЪ��1��B����GB2�g �H�X�ӻ��s��R������e�4����Ţm�����N�c+�����-�𮿢�]jC�����zc�mʎbbS<�QjE"gO\PA!��
iQ�?^�C�5��i��S�pZ<=��Yښ��%.Ժ��m2��Yj��$�OP,�1��p
U��J�~s�C����%�e��/K4��cQ��H�A��x똼/�i�P��������4;�D���v��?��{�X9K�÷��O�0�����Ƃ��۔�|󦜄s����s���i�\L�͛�:���Q)�İ��P�ǸK�b���W� ��}��ߊ��|y�x�1'}g�l:F,�g7�B����,���2�[J�U_�\���ܝ����I�&@=�=Z� [�R��j����N:7N+b���&@T~F0��g.�h���QKzD`TY�Cf����0
��a;���h2/�j����.&�����`��ayN�J���C�D��~q�f[�n�{&;8/Ҕ��`!�� �⥵�)K�[���rL�X4�I��3�&O���+r�M�p�+-��1X8�@�KAA���xvs��gͼɫ;�f9#�x~�����n��rLk3�Ҥ�X%���� baқ�~cE.�N���@x媌"�ZL7Zg�=����t}4�ї룗X�3�)Xb@�&�'����Ho�p�F�F/4�/뇎��o&�@i}��f,��Es����lc�`�AOrfҗ�-�bh���%a��q?��'���b!���k`o��M�t�R�%����=�L2��Bn�f)+Ʈ2ݩ�Ց�5_&6G�҃�)�=-����LJ` +��ٲ�~��,3����Ԍ�b���	 c�L �@�<gl��f�;�r�lT �pX�C6ch6���4۵��j!���%��r�	��1�=�D���Yk\�b�q)˚����Ȏ3�o��`x�d0{�)����
��/xG�9����%0���{iPVNrŽ&O/Ҍ*K���|��箐Ln`�[���.�k���̦w�i�靇լ�D��E���7Ai�g�F0�3���.��Ӥ��=�B΢���R�XD�HT�>0��gwi΄��0`�I�Ms�
9#y=��J�T4�����^���4I�>��o՛51-��&��2v<]�\�1��� �Y�alg�F{�յ���+��{ ��I�=�Ď¦f��h�
���$��IQ��?k ��❉R�Y��qS�Wx��3�tB�X4f.u"�����,�/�H	_�b���ji��JC�&[���b�5�=�@o�*r�����Ӈ���Mڢi4��݋��( 뮱/�|��(�&Ê��0�|ǔ�e������x	|��:-��c_Ү���nSfEN|yx��ab��:Z���H؊].ܭ��CY�7��ƐH
������_����~�p��@�ل��v|V�Α�U�e�����q�IK���y�����ETwߟOO�$Y@���-q�a[^�u�8�K��l���g(��Q+��r��|�t D9��'Q����5����[�J��d��J��<r��o_�ʹ��aq�+���X�U�A�2b�9�8�[0i�2�V�ο��4[����$Lzo,g�$r��O�苤Z�����Eİ-"�ڨ+��,�tgq�d�;ڡ��}�nYC�Y��Xa��L�\�᳿	c𗘢|�ëI�v!�뢮�s)��e(^�Y�B�P�:��{���P�גw�.�Z��]c��1L��    B~<�
��G��Rz�̑a;]�w�zv�p��q��$*�sm��2H� �G��'D��������jr�<��i=:c�\���Xb�)%.��M^�"����E���{*,�Ov�Q!�������߈�}S���T�'8g?ԭ��Q��MY�l>��خx��i���g���%��>)dڧ�49��
\����f���>]SAA�_7�ݲ3�L�%I��a�p��qh/��XO�����h/�>�b�$r������ԑC+]w���9�;����.��Jz*�f�$������?���_��� ��z�YB~��.�����w6Ê�C����?}��/?N��T�o<.�2l���L�NW���,>��"�!.N���_��� �t������gt ���)�r��$av+W��ǿ���D�T���+X���nVJ��v$Pj�aK"�3�����+�����SaZ4*̯�=r�(�DZ���ɻ�gw����K�6m����8�u�^E.���_L_����x'��2����F�hT����b؆-:?��>	oT�qy����l����(�;���ΰMZ4N$v�,��pLrG��yđȅ#�=	6؈�>�#=����J�3�U@Fm��bv���8�F�g(�9Na��RZER Dc~R���� g�q�ZねN�+n�q*����"g$�N�0u���d�t+��i�Zz%VK)ȑ�O�����p���}KH ;٬�A�ɦEg�W�W�kr-AMO��̗�>j�����?M�/E���b�	3�3�8�����L^��~q�>�K���<�%ZH �p��3�<Z��A����3!y
�pw�4��E��-�3�r��KCB�aKz.�XrI���>��)�)_b���a1N�1�>]��#8Q'��wQ�L��a=dz�~�$r�ny�7��'5`IZ�)�d���z�}5���fK)鹈'Dt@v�n*O�YCōqf��E!�+��^id�_����º������LI�lb�9�E��!KM�0�2\�i��;<�aX-3s<���D·�����)�MI���7[v����ڒ�,V'\�L�Z�3����I�^B4��;K��x��]��ry�JC8䠁2���3Lםag��Ѡ���&�I�k�B�p�N�>N9���v%�8�B���	#�U&��A��L"gEp���P�I�[���]9�땣eѭ���w�sF$r��cP0��:�l(�N�� /�&�ov[����G$y��߲�L��l�+rO�pͭ6w�u/�T)���;���V�cl�{�+ ��Ğ?`���d�"wb�aQ4aD������U��mؠ¸���TA1f�*tTa�u0�q0ݍ�"1G�e	�{$�\lK*Af� �e�	�49�l��FTp���ԗ
��Ko,�R���%��ǚ�$ q��Ơ�ƔXL`$�2ϒټ�A0���������%f�(&�u\�tH�}�	�TJ����i9�C$T���%���#����Q��Ճ���&�a�QrTb�͒՝�h9�����pL�5�B.r����iK�Iah�a�(������ĝ��0�B�H>��4B5���p�'f�n]�Cb�n�m���{�2e�]��śLK�9	��@� �㠝ų�K�(�Ckmի?���2��*�|ɋ���M�/b �����Z�>�}��2G�1��bl}!���ۇ���
���3�-���&��I<ar���^Z�ڗ�ҁq'���	�)f^���t�	��P�F�/*��Q�M�Ӌ�W�V��J���H��A�e�g�M���S����ze.g����yB��%FXbip�#���J�i$߬n��LL�N�QU��?Ei��Ɔ��ۼ�.Vd��u����V��|M��3�,s��)z��3�'$�����6ai���򸑚)��4s�A��I72AB+*�5) �Ki:�ru�vR�G�4��ڸ����-j��#0Fo�KG
�e�yd���r'g�f<�'�����/�l���*̈0��lW�v����"�恳b2��c�����o�qK����~�oi��:�_��6W�`'���̥E!g�����<��n���Y �VƲ{ĴmO�S�\'ӱ���f���Qr9��|��!LH�ӧ��b�۲�-v������wi�q���܉=���w�ĆUg�Qg�	
�<b-���ʝ\�{S��!di�(&��I����u����5�����}��{gvJ�~��H�م[�v^�Z�-�����6��+�ݱ|�~��P�q`��D�ʼkd>��<��ݫ�b��!7V������3�JX����D+��Ц�ɼ8jo�Cd}Ԝo�&��D�Hn>�b�(����i׶���	�yu���E&�Qa�\|K�as$]���|���o�X_�v����O6i���U)�ǆ�ӻ/q� �=9\�jؑ	����z6ܔ��T����i�ǠW� �l����zy�X�VՌ�|�^ƶcjAB��o�݁�v�1����ѵ��99o�6RF���hf��0�Z[*���p��"j�ٚ'��xeSՌ[s��L!g0?���� -��p� (�/�_ƹ�;1w�u79��9i��_��u��*�)�/�D����i߹�x��Vt��#�̀�����%}y��oNX=�R�ToQ�y�lW���v����?Z�J/�tߗP����6�T�fj��uӾ�ΰ~��C��E�����xx��-g�H�[�"O�~���Ӿ��aq�{�dbgh��I!g������}{�wVf6dh^j�o���1XU��׊\Xr��D�SᨊBo=�~�6�j�:(�7b�hJzg��{#S/�?�>����S٨W���ZJ�Y�Ց��ȋ��:�명���ݟ��|��bNM!ۼ�C#�.LR0��1��1��O%̆A���7��\��6���I���Cg�W����)%���JrLo]v�~9��]���Hl��jlp���L�dF-��ʔ+���$r���	W�Û�9D(l����w�A���~�z[�I�rF�������/s0@C8�Q����7L�{��[䋣��y�+=�a�l3�x�g� �|P�@AH�f��wDb���� �D�q:��$rFr��]t��`R���gpZ�I�������`�l\'7�I�=ꟳEӔ׀#k�-����2�EW�U�9� QC�\�/wc����QODЃ�l2[�n����/��K�H1�%;B��%{��ώ�����Z��%�r8`]���۾�gဥ��(��*���՘���ɢ>�o:p,�9ؾZ�"������B�э�T�k�~)Y��'=�$k�B���7>'�X�E��.��}��v�$+�9��+�\��n~�yr!F`���mN	 ϒ݉b�(Ę���y�/���m�w�F����g,޻�\c�;�,[ii�;c�I���N�|�W �A�~eq�É���ʒ�y�.��J^SW�'LE��Ll>>�WZ�`
�$����.v(�"�ep�-�6�y/��0�J���g�[
9#�<��KP4NKAǚ�LV[�\�;�<<NPM_�\��3���ʎ(,1dr��:KS�YF����R#���]�R���<%�r��Ro�H�Y�t����s���!	�8]����Y�?������_Qzz�5[v�1
�.%����&��s���dE.ي�ķ�I�a'�ǒ1�V�ә�(��@b�]�̥"�u�k�]� ���u�gy�����U$���.׷�>V����KR$ �?�I�^�ZϺ��q%��<��7�}c[E��%��<w��S� ��XX�b�t�|��U~��R�%P�x���!�b���a˖!�ےu�~G21���٪�<GBIc�V����F��S%Z�elI!�H>q��		��pU���4ku�4��W��XEzޕ�U��t ��@�w�bY�?^�W�E�����:�F`+�9l�B�g�D�m�-����m^XD(����?��NU����	�䧰u;�4�����h	eS�U��t=D�;�0�rlI�q�٧�\��${�sRȏ�.Gɘ�;� ��t��`�:�����4=���
B�9�\."~w    z7�O(���Z�`XQ���M�5����K���t~7ML���G�x=_T�6���Sj\;5��
�~�n��_Ш�t�j���}����h)#�O�eo"�a�hE�|�����討���@��1���նo����\g)]��c>�>~s�<E���<�S�{;�����w��,�,ؘX����2h|5�����$'�)L|G��� ǎt6�wP��2:���/� �SV������?��gvU��{>j̵�L9v��	��Q���2A)��oo�o>㶅�/??�oO���B�����j:�'�m�CK׏O����}{�k\y�T7�)p;v[�`|�ߨf��o�F|R�3~��G�G|�*!��]�7z4�+���t����^����+��ޮ��]�l�Ď!6Au"�سH`fF�[+,=�$r9��'v�W�B��|p�� ����AY��١L�O��X<�@�Ղ�G�(�Y];vg�	�Cb�6����^v�2-h�$rF�ݻO���&�W	��P�8%q>�c�C��\k%ֆ��px���m�V�����n5���%�;"ڄ���'�9Xd��;`Bs�.m/�O�'c��C:a��ɱ�?&��{:>R���˽��w�?>��>�h8����Zɔ����C��L�"������V?��3�Z)�^,�9}��@��_��-�>��u�}����"������>�$r��8vj�����f�"�_�ؤ=W�o���%%�o�4�	P�)��
;g��sV�b�b���>W+u�0*�Α �'Qh�y�ر׶{��y�SΖ���+����"g�||��}���[P ���m=�,z06�C�Ű:�"g�|z�w���iA&N��K���z��]�I�U?�"g �	%>�}�y��A��`��c�j��L[���sm�U�u\�j��洰x7��"L[a��2kS���X�uƒ��x�J=����g�]1��?��Y;X�)K����t9�b8Y�ҦP9�ƂRepL��deְ0��$�t�,Y��6�Ew2�r�b����ڧ��r>R���_>U䒊>�OD�<���(T`�=]�9]nu�j����"ؚ� ��I���y�%m�%+)��%��Jo"���J�M�vJ��*b�(b�z��/#c&.K��2�˲����3�6�>	4�ZnDvly���{I/��MVx��W,J!3?��i�ܤT���bU��p��F}T՟xf������F��s��f�]{v��U��2���-���9�sIχ�����|>3a�q�����@vX�eE���#�	�=�B�X�N�t�2��l>�yk��P��Qi�0Vς�Ɍ(-^Q��N����*�3候����&>�T�L�1���%x����_`6cHb
W�d4HV��*�2s����,���z�� 
�:o޸vE(li��^�+|U0{����T�����{��s9��w�ֳ���b��ȫC�d�¥����}7OE�XL$�1I�#����uY��=�h`���=!�,`~^���B>� �K�MDeL����:���A�X����u��+N��~/��|�ޝ�2JKo�I�Yu�;�eu�}���z��у�,�9�aW��2�$l.8�Պ�\������Y6��u�.+�$�(�@�(��3��w�@�nY&E��J�0G�|%�ܳE��.�a^T5 Ys��(P2a�{qlX���9^�\��ݙM��|�i�s,��*Sa�	XT�42b���������H%��eb"I[��r��% &�dYlql���./	OG2s�^:�A�9��#H�۔��2��Cr�k��ǋ�d�$Կ'�+JQ�3�n����C�E��(�6a|�D�@�E��$��Zcp����qդ�Ƒy,T\������6#S��c�[�Xm�o����v�d,�6*�����̠8���mF{K��lۈ���d�zȖj���[�d�/��f��# &l��=/����΍\�T���hn�������:Xڹ���u��ڳ�).*4�ť�eJ��_�Y�ǀ�k������,謰��t�0��s�\M�{׵W�O�-T�>�����'��y��#�p��c��[�%�qr�JQKd"��̨�__�wa9�L<b��l���]v�3ye�+;�����Ej!߾�e�sE
�E[����E��E(S'|��~�sENp^��af�i��Bco�?�ֿ7��ڪ�~�y������$r���ͼ{�	���@R?�G�4G,MPZsZ����¡�O]�Kҥ0{��7=It����)����m?��8�J�X�`�xs����x0}��
�*'�~+kBh����v��怫NG@P6�����|����F(J��}p�v��^l}��L�G�c�0hL5����1��a��:U��C���L�^��;�I��33+r�iv3��h�y3��V��#CJU�'k�4)N�#f���➝�lm��u��V�#��RZzN�`����ۇ��o�`d���2�^���6�9��)�	�a=E�U�[
����Zv츑����D2���<*��U�%ˀ����ћY0�?� ��$����x�0"��<�OF��`>ަ].��F�ȃ}��@��:Ӽ���,gy����A���2�?�n�3�<!���Zew��&�������r ��빔1�	يfy��
�b��bw���+��PF�����_��E�{I�0���\���Ϙ�0V�P�n���A���ˣ�R�G���_��[A��=2���S�oW��@&�B�ߡz��>ۂ����N�_Sp����S��){�2�-Iho�W�C\�|�zq$�:T�Wr"Я��_Y�W%��N�����G#.��/O��@a2;�*�W�]J)����g,8p�T���Ս��->� �XF��F{-���;���o8�!�6�P���,�0�GOQ�#Jv�Pr�Z�����I*�y�%?W��w#~��g��[؃��8�9<���%åSt�T{��p�yvna����}���Z�¾���=w8���H���V�_�}�g�2�y�r�K�r+�������Ԑ�^^��-����+��������-يӕ�]x3����{�(�W�+L&�L�~�$�$w-�x�����],����E�Ch��O,��'�Y�b�-e�j�,��81�ډiQ���լ�sv������q��y�dg������w��� YLV����]�1���eqA�����8,�X�ܷ蠙.h�E���0gd���F��#֩%P�GތD��^�d���"@U�"�S�n��J�1���ƫ��� 륆f�%�"���G�����/�U}��^U^o�؈�(���G��ꔞ�Q�P�Bi},�;r�F\��Z���Cᚙ�x���ӕvF=���?�rH��Cj��͠���DД,.����8�T���;+n	p:ݵ����8P�+�<������a�\+q$���ޡ,6Tdk?O�3΁̮{�+iHR'^~��l���{��W��[-��+����Z�ŵ���3"������y�c{����O�Ę��d~�4v7nۈ��$ �#�̣qK����:�k�.d0\�-r)yHR��]�9����{�~�'=�?*�"���$y�h�n��T^��<c	����=�-�A̋�U��P^��ùTq9���Ccy���%[��>��ɣ�Uf��$�,U^�E7����B��QJ
%��~����ꩈ�NY��`�2��`tܢ5:�C��O��v!�X��Кۈ��/����MN^�8i�U����Ȃ�OX��зO6�%���Mt���B��=뾅�\�e�����I���t��*��?n���S�l�{%��m�2���e�/�&C�e�\"O{���.�8�UW���]-�I �]���W�s���1[J2���|u����5K�>]!���ڔ?�.�cǡb|���O_'�Wf�w��^+��` ���ޯ���ڒ��X�xeqA��d�\��(yIn���d@�t�������,86r�2�IMy��ɿd��SXI�D��{N��m���[nz	������Ѕ z  LN�_e���uP4_̿J交#^��v+2Y��%2��
�T���r���fKe�톍�����0ccPF�=�����V����e-FF��ȥ�˱�|�V�e,R�O*�ܓo<�g>�QY�7��SQ/����0�K��F����(1Ɗ�p�6�d�M\>��JZ��X� �yHyN Hכ�+ \wٜOJϾ�����Gf_�y{��&�-,C�U�5��
[b�{��n�Pg�=��/�:H����+o��U\/���9�aj9h�to���`���HX!�UŵJ����2�>%����b���H&����p�x��ӊ��Й����	�V�S���I�Z��qT����:#5���f0�U\��e���L�𙘠$���z���WM��ñ<+���{Y�z�EoA0L� ��'�aY�M���|a��e(~Wq9�_��g���@�)�\5���8�S���σ�،�N�����dq�2�a(I��l
���=TޜL�Rzq�%�(�e&�܊�K#��\y���7%$ �3^�˛���V�zt ��I�0S# �^Vn��B"k\�.��p��۳!6��a�2S^�x�I8�U�FY\俘)��k7M��|+'	�����$�
\�P;���B->�+0rE�R.<.h��t`�o$b]�1��AJ�v��̇�/��Ȍ%`!p��X���òn�,Se�<3�����
�a�l&�p��[�!Y�{�bIiuSéT�Q��1)�e$���U\5�����ʺ��/��ܬ�c�#���2����ĭ�e4�*W+�˒�T�dr��,�[��%s���EM����f$���)SaR� ��ۻSY�+���.�nT����׏�y=c����;�w�OoC�������B�X.����(K�/���A����sSH��������e���ܔ��~�B#>"�k$z߬�1�
������ �Hh����.��:��!���O����������X8<�L�N''w��]���zb-�<�����gp����y�$˘�`�M�w����_`0j��0^����R�F\�奣�L���ؽ��/��_�f�^4��L,ш�� F��8EC��¥�Eɇ#�E0��^e���|���3#h2e�CCfY���8��.&¹[�F-�0��I��/mF�����8/Zd8�6��2G����1��^��=K�5E@m��؀����+I��r\J���%¹[�:���{���K~e7�1��9"�����k�N��1��-ϋ�&i>IKq7�ވ˙��}��k%w�������JX�y޹4�"�C\����ۏ��h��8����K��N}��4���kK��Cz����y�
_�(�ÍWi�-H�oy�.�ߓI�R��O�Y?�}�H܂A�����x���`���}�U�oD|1�p`X֬m�p�F=Op�U.﭅�l��[��4#C)h��xd�<��:������3�y�Nym+����症�GP!�`rsh0�y�d$�5E�|4��ͼ٭���E��֕��U�
��F��8�i);��k��r��]n�	��<b�����)#s�F�Y�ݡ�� �_�N;��s���/,��C8UX�0�`���F8&�1Ɍe��O�nHs�����6����P����p�De��~3.}d��˂�>��k�bl�s���3�����wxm�����A2c��*#����3΋̔'������AmT�x�7$Tc�)��y�^�7+L5��P���ܭ7���o��,_�p�Շ����a�.��g��c����hx=#�=.;[���eY=�����B���ne��G��<K�V|̢��|�¤�r�����c�nъگ�J���Tx%��j��D⦭ׁ?08���9 #����BAYry�+F׋ׇ/WHRjI�Ia�d���h̭�[ (�<b)B��聑�h�����N���u�黾.y�@~��%+�v�<b�5��Ωh�4�[<�tL'����gq��;�z;�$�et��.����Ř��^(`J��3A����}]!�:O
���+��}3X��,�-�g\d��4�܉HP\����h��hYk�u����;ȵ�X~��m����T�}��G��P<BYY`����g7�HX�_i��� ���,�����1)#�A���m�0������椥dR_�[-�I��xJ��쪝�c��%�46�5���dW�7��6I����}��1Q/�6�='��ɠ��Ō�e�^�Ҵ�_��3���W4����88���5�m2�t�d�"!e>}iɜ������S⹐���S^��D����ſp��j�{�����������c,��s�R�c18��)�1���Y=�tcy��'V�5�|���(��`3&����C�Xm���
�B��Wʋ�e�5(J��b�n���َ�ٚO_�̠+U|��%F�`�֞`=ɍ8�	��nH^���b�\~��~#V�Ǳ ��q3eƚ'ۂr����kU�#��u@xwtT��3©ܠN��!��m�8fJ+�_Cͥ���5�C*8�nSl�[�����z v,��~ZE-U\��7� w`1a��3)x�#��8�I��57w��;��6CY����u�D����V�#�L�)ף�c��4ja��d���0U'�F{��=��ԕ*쾴d�e�*փ���˩\"��-8o�D_УP�Q�sX�u/+��<Q(��G(���Xҩ0�G,pIq�.��k�'(�J��k�1���Zg�D�ٝf��_;&6�I{��&u�z�X���c?��P�����ʨ�+���0?R��19�-�$��ԁ�k=c��6�7-NVe�����KZ<������r�.CoI���k�dOX&��Oe���l�+�K,X���l�y3�\C~�1��ogK�N+�>X�g��(���Ȯ5��Xf%>'7�C����Ƽ��-hY7!oU�Oa�5�-�b�T)�qk�X��r,��^�dQ��Sh�H�R�`�2�z�5��Y�%o�:u���"6O����q����El��b�`:���X�����d"D� ������$,z�V����>3@�i:�y�EXe՞��wZ,��7��1y�ߠ{a,�WOh�ic��9������I�CGùT�g��v��C�6����c�6���HOG�s�͉��#��}��}>c���Ri{����t>���c�d��r�/�G,��� ���RY2�x_9��Nz�r�O�N��ϋ'd��!>�#�W�^cR��88�lg��MU(������{~���V\?�O�|�23b$m�.ŕ�
�W�s��/�U��2S����u�խ�s	�7Jk��
'Ă=���<xy��+
�+�O���ۖ2R����4啼ɐ�$�A���ŉ��%�����Zq�����
��[�xUP����{��� �u��      H      x�̽ےIr%���
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
Z=o��!��!{�Y|��S�!w����'�?H�E!^��z��}͏���!C&��b�AхZ<P{	�n��>C�h�=�~6��S��>�΢i\����m����|f}`fv�c��a$OԸ$�9���z�]��I�n���9�cG�����6++Q�����/��5��r?�,��v������G"z��/��V:�Vz�g:�]C@f^�rZ�r�%1�
��{Q�U��f�,��F���~��l�5{r��ғ+���Γ�+ba��M�6�B/k��ˤj�*GXzē�S��Ȉ�������b��s჊́SY;7(�B/W�TT0ͺ��vw��P�C������e!�WL��D�*^`K�s��Iԭ�$Y���{;��.���H/�u�a]LA��5��Yf���D��P2V�K���Kd'�Xy'����0�����V(��k�ix�<(�\=d��B��F����ځ]�L: �2�m��Ӎ��*HX��>�
�6��jT'�8Avj(?�А�=�S�A�4LhC_�m���s�2Y�����þ��c���׉���{�9R�|��D�x�<n-rS	�?�	Ȑ8cm��Y~l�d�1]��X�i,}��wu����!���N4$ȓn���2�y�5��4����Gr�3�w-iF�<�J���� 1�B��@x�*!C{�r�$ȓ&���A�<nE �9�q�p*�6cmi3��%/��w�b$ⴾ]+���ȵR�hm�����m\�"8��CLz}�!D#S��Ϸ��`��a"3m �M�Y!��l�DJ@oMĭH�R�L�ѫ2�
%^������[�4�b�4�!0�fڊ�IO߁a��/�^5&+��!�p���0�H�꿼��ׅ��n	�֖ �7�(�v�޹�Ơ!�Ǻ�fc�sJ�mBX{&5��>���up����a� �ƺ����:w�O��|�*n}S�]�|�,9Wd�X�^7FD�������P�+o��M3Fx���snH���QI�'���J�g�a)�vR���w��p�N�/��k��A��6�|���������T��2�bo�!qк2���f�sB�A�x�tE�V��m�3�0�^�����s]97�a�v�O�R��yx:ˈ���~�B�[�j_�z�Be��8�����G�,� Һ��ubG�r���߱�I;6�vI-���Y��ۤ �ͺ�9̪���m����'����FX4�I��+��Kl�]��zW����)A��<R����},���[�,��:�D=IB+=�(+ z-�#���2OM��3��ϼ�����6+s`��������Zw�L�
1!�݀8�������d�[~��B��"Fgc��iǁD���!x��ky��A��JRV,��^{���g)w`���Az�"��p	:ҡ�r2�f��
"���t����ҿ���\ff4Kی�ݝ>rs�xY�B<5�u9׮������[��4X�|�7�c�| ������	|�:On����S��j/K��>"���:��l2v�I�jb�����m�����o�vC�،�4bߴB�xNV�ع�< U���nD���6�-��ej�}A�pLyI�|?��&R�qo`�cT�ct�R������RX�/`��IȞ���M�H*�۾Uc5���j����M�������<u;7��,�BK�tC��}�u��܌�*n�#�sI>��a�������5�+#�M�
��J�j�f'��=) �*���~���8'�V��S<�gA[�H��2��q�L!N!���!��w�!cAUZ����1t)�w)��8�>N���[1>�KIo`m�~��$�z�z��+ao <p����R+�0����K�?���}۵�΁#*붾��P��Rg���mD�U�%1�7���$�e��	:_	�t\rͽ��b�
���ن��U2�� ܉�l��m?\#�7b� j�NғS�z���u;��LF��R;^�/!��9���{�PO������!��5x��OH�a�Ѳy]���t�[0#㼖�w�ym�=��R��疐$�y�#�]��L#e̙UOh�NS�{�/|6".���������PH�{��"����x�Gb�1tK>�POR�6�F��1��l�Z�.`�� o��/�Ք�w�߬5���Q�9�b ����3�{,������9D/@Ĺ�ɮQ��T ���@�ls�U�L*īCw=����'Ҫ����xy�.\�����׼�I֯�l�t$t#��7)`ĥM����@�o����v��
���������IL>��Cb�l�_I�F���8+���F견u���O矄ՀQ�颺t�q�ǲ��6�!��#lsb4oV;�ڡB�/t̡�;wF'+gS�a�~FL�����^.�z�D
��i���0k��P�2F�� `�+A���Ԝ�����X���@5"�V���g��"�#R�.�7�T�uj���{�(���s�ϋ�\%�\�Z/&¢G��-�]�8אЉ�-"�C<]"c�J����ݺ�X�Q4^��&?�8�BD^t�{�av:�h�� '+$Bb�R���Ý|�0�1}.3{"�<�L�"s��1� ~:�?W����s=YU/>q0+���%'�LFە���%Vh9�8[�vM��õ6gxa�����L%__��������Q� _���?]�9*���1&��d�w���t~Q
�`}q���F��\މ;�9��d-��,�5�l��A�A3��/�d_���x��,���C&]@8�>��iW>�%!'�x{:޴��>�r:)��w�(Hxr�amX>�,{L|�p�E��[��a`e��j�f�Z�Fn�&@e����JCKrs+m��z����%kC�1�OǙ��K���;��
��!�N҃��n1�'���K�92�5����Yڻ���j��At�-h7����A*�έ��P��YHg��TQA�X�0%��8*L!5q$��5��#Xw@L0t��>_��G�I�����ڇ!/�����"�������t}�tĒ_Q��+t���ݒ�ul֍^n�� � ���;mi����F�Ft���=O'p�5%�X��i't��5Z�'��ΈLF��#"�<:<V�w`Dq۷���l77���32��DL�Ϫ��5g��ʙ�+gv�1c-\\%9�"t�K��&����ͪqq�wx��(!�A�O>\�*�%�=$>\#�:*����mŌ����)FsB/sov��[�[�[��i �^��.EI�������K.�D�@T�Ÿ��x���y���\=��B"��F	�c�Ǯ[^yv��6�о��n>�/\]�|��eL�"�r4�\�������q��K]�S�X9�/,�wH�̰\b�Q���Oj�ZC71XJ85^���("M�'�Jt�t�)a����IS�Q5�|�r�q����2��i�{��L�f �(�|���bs���E%��,'˯������r�b�_�=ڏ�Y�!�� ������t70���>3�hk�X��}p��\Hԉ��p���c̈Ԉ.�vZ2��ߪ5�����,!m����5ԏ��G�Mt�(S
���%2n    ��Ev��+�e0t^B��3�Ln��e��5��^��d�K*mM�/�zd���7p�IP�iĝAl�FOO~�=�r:ʙ���`[�����+��Ԉ���;��7L�KwEQ"�9 k_���&I�5"7��)��W�f�a��P;i�n�V�Z�FGt���=�_���`���!�f,����v��Q&�����K����f�$W03�ތ�;m����Y`iDnD7T:��=����4���D#k��3��V��[ z��{�e�u`mN��zA�5 �kLڬ�uO�8BW�p�����Ṱ��D�ٖ�͜g�"�FRt��A쯘��ܠj�˗���vQ����S�o0�7߭�ʅ��J�3�Lt��+i������r�cRĻC�_Z!_e���
9�`Y�چ
��ݽ���.�z������wHTB�6����qӈǆ�t�1]�ʁg��r��c��O�qs/���}���v�2c����Bæ�e�.!NOMDtq�8�?������F�tㅥ��c�Ѩ"Rg7��
]7��<P�PTu��*�	�����t��t�/�.Co���� ��G��g��\l=>�BQDC��:!_[Э���jP�S�[D1a�7�w�ц�b��G�@�zi�[�'�����s�珙����,2Y����}�8α�&@��jK�{b��ms�9�A�x����+��\}��0�7	�=O!����,D����C����*#9UBT�W�Sm��DL|�UĈ6EC��Џ�R,�,p7q*�g�-Yw,g��Kż}��f;0�i3�Z:Q'�2+��� ����Ej�]������"��J�c���1�z����6���He�X�*������?��.c��bz���lqՖ�l+|vVK!el�Yh�mε���$�RKg��h+|�m�{X�ڌ�c�m�"��j��Q �^�!�#�1�o����1�[7S�ց׋Y��44�-��l�Tټe<=pN� �7s0�$̊��e��ʿ��_�GyA��#N��e�� +���k���l���v�&*���H5�E�����Ш��[h�b��"�
����Ic�j䮕���i"S_��S��(r�$��?�8װߍĂY��%�+�4n��m�_w��"���?j�c�Ij���^��rj-צ7򇐍F�>�X78�!��~��e׬>���?T�?4���C!��Ѥ�ʮ�m���|ܦ�:��x��x�s��N��Q�KP�X��:Z�Y�Ѱ��FÔ~� x^�OPӄAs���X�А4L-}���'J�f�n`b-oд��M�;ȐYB�>»�/�L�Kۈ)�,�v_"'*6+�����l�~��?���׿�"Bh�To�&I��h�(�hZ<��R�K���[B�4�,�KY�:���� ��e�IʑC6�ްOU}<�(Ncj���tg?Ԉ@�@�e�񻤿��@v����,��hH�T�;��[D��arD��)��wb-l41ۺ�%-��:J3?8W�ۄ5$��[a�ic�����_�M>>�e龔4"�>||[��m��C�mɲ.��/���߄"C!�N��N�s��0e�YW- �	O�g������4LZ�e���t�y���X�H�h�}��N�����U��~\;~>/��Y��ZH����Q���������f>�z�C{g#���`j�4_!en��(����h��A$h[�]T�����_8d�	u�	S#zb�i�yUs�A�bq��7���v�����pmS�P��#��~骴V��$�?���?�A�A�u��zբ�&�ach�e��-1EA(����w� ��Vƻ��d|T#� �9��A�!�2�b����2��y���~5z���Ae�@��m��٦�Cv���������T�2�1��L��}�1�ˤ6�&�ry�������׿p�Я�@_���2�;�������ܜ��)$dP�����/U0�!;��Dl��5XCv+e�`/���J�[�D5��Oú�M���љyS�,.hH��L�|oF>&Y���܉D�4����^V= ����~u�w= ��S[v�}��r�p#M	�feد.�]3ޱ�ݖx$��A쐘AY�\Tu�0T�f���jFx���������:���X�����c�E�,f���ߎ�;�/��@7e��QטݬH"�HWu����rO5��K�0�,Q���2�z�o���Z�^�f0��PV���D��JN^�t����������ǿ[T��3i��{�
e��y�8���d����H:p%��k�@�,�jp!� �Z��6̚��٥�c��~���_�e�58��Ȁib�����N��3�'��B�e���������ݤl������o��C�	唀<���.������Ls ��������W���8�u�d�ɚ�CW�!o�P2$OQ��&z�U7�p	J�^"��n�>yz���\�Y*�\�6W�dR�7$uN��X%�����ES�?�<���;������P���iDq-!:�����Q���P��̨�?�nṟ`B�1��~PW�A�Y&�c�E�8D���w���=yQ�$7��#eC�B�I��Vȣ��Ԣ?�	ٖ�f d�Y\�Y�%g��5ᅡ�.���R�{���2vO���'9�����̆�'�[	،�I��"y�	L�g�̳Yf��tm�����L�N�t��ቺ��@��;��G��~�OH��2��a���������V�G�)?�!��D��w!H�-w?��O�۟@�`��aFĴ��!�?��|*�3/�z{�78���=e��&���Ob>�@�հ$\�7j��M)��|��x�c��T�K�6�����Y�Oa1�NPhl߻�G���|cP@V��L��_��Ͽ���ĆB*c�Wc����
0/%Ns�2Gf���j��5�C�ll	9�o��r�������g�Ww'��RoP�������MM��=O��j����:��,��N>v�Q˩`��~#�������c�&c����wwCބZ�C��Ϫ�a����_���0�%R5,��!��V���?U� h�S'��R�o��bg��h�d�(�0�n�GA�e��ͮ41%�n-
\&��v���Ì�����a֥�$-d�������[/���Nj/�+::V��~|8?}�ƨ��{8��&�,Co��$n�i�Luu����&W1!u�����U0U�9����/�h�w��]_~'�p�tD��;}�>3X>\�4+x����W��+����� ;t<�;�����ݷ"�;3h�Ǵ�v��5ň��a�aTYT�&�T%ͅUA�u����`Z-e�����&*����Q�;��a�
(8q�����Nj4(Q1��Ʋ���7b�Hm���yx�4�B��pKRa]���`�=�m�R�d�w��w`�m=����t�쁲h�,�9�<�(����@i�Hxh�PaАYF� ��Z7�~��DZA����8#RH�V�2�B:J��N��6ۑ���x���KA���ĩ�9Lw�t�������iN�zGK� O���|�~=�-
�Ud¶����pI�(�o�'�	�����.�"��G��C��7A��]���c��q�R{���ĭOJZ�������'�4N脎[�Ĳ�(��3�c ��Z��Ӣ�d��8~r�rI���P\T��#����Q+�P�bܤ�j�)����Aʖ��vZ���hǩ��.W�.�`5|4�@�측��h~a���O���WN�"��4�ϽU�����K��x��l`�>?S����Փ�0%Y�n�g=�q<E&�t;
��F;8?��l[jeٙ��K\��!�n ������t#J���E/]�m~�n���z�U5��;�H'��Q+� ݀� ���쀔t�-���� =�|>=�<�����׍�:�w�T�W%�6� �7�0A[y�vu����d��|Gmk�ݍ�6�������^gB�������6$��ߧ{�4���ǈV�F��7|��@>��y$��:���/z �n-�y;    �>�:����|yP�gN�a�v�n��/�/i�q�o,`��fiD��e&��=Ufw���4�����r��'���݁�/�M�;�����bAݲF��۫��F��D)�����Z*"'��č��n�vH܃��Ț��Q̏�m��A�۪�GK��!�v��� ��1���*�i��	'�b�����p"Ɣ$���7p���t���E�(�Ռӌ�f3�����~wQ d��-�i�����oM��6|�_�? gY�t�:Gد:�	~b�twM`��|:}}!o��C��p�9��{���T����l��D�f�?ށ\��'ȼ�}ã��py�N�xM���~���Wz�\d�������קr�+u#U��0�gY솜Z�99�i�=O;x��N���H5�z�~|�Nzż��l�d�6�3eS ^T�L���|jR1i��}i?�Jˡ��� �3D�(��W�Nߊ i���B'?���
����y<ow�P�Гk����Tw��j��D�&:��|~8?�j%\yצ���d�n���Ӑ��z�g�eh]�{I�G���a֝a��g^w�{.��,#2K%��	>?=q��{+�Q�e��T�m2k��������Ys�i���fy�$U}+nث��-bK�D*j oȆ�3������K=�v*$���v���-MH��ug��� ��˱h5��<O�gW����/B� ����k��,�X:�;��αðIwa���Ի`Ŧ���ޗ���#:�U H���(�0f��*
��V��>��)צ��dC� ����yW������|B�ɏ�6�F�? !S�n6��"�j��;"1�OH�X��<_�l�k:�fy�e)a��t�J��Gw��4j&AmX��e�)0��b��W@�v4���>���B��3�̙��G��D��BT*����Y�-�1.HB��b�-�P�-�Cvy��eS��d�����#�!dRі!N��W�u�)��g�|��>�m�o�ᴭ�r͆1�a1��	��D�-2�2D����cS���n�8���L32�HA�H�˚'�>�<��DRiz�7I�ھ��ζOx�@�M��gd��1܎L.�6�GuHBm�Ŷ��0'XC��;�v�b�}��b����ls2�ǥ0B&��$�VȤ�m���5��hh�u>�$����)���5�v�^��[?o�&
xxU����<L
,K
.���� ��a�=I�m��^iCa_q��,��-ԚE$����^Ӱ��l��k�Y���\��������;�@�m��ox���E�݊�Tl�"Q�r�"	��R�R�v�&E'��q?N�&
d-�yM��~����<�n 7�v���lL�z	��T<Pմ��p���]eȈ�K������gȚ�E6%����:���L/���X;�m�.��ݮ��ޛ����<�Kڲ�V<������t�z�oe8)r���ҙ�ǯȥC6#m�8$�C�6�h��W+@��_r�BB� my
��7;�������Z��z�}Mfd�K���Ψ�tˈ@
]Cږ�AkƖ�k޴!�������,z+CA��:F�վ�:��':4!x�9œ���
K�.�t��~�pb*�퀺����G�B.�x45�i�}&y��� 0����������?�Gڱ�2^G�l�ӱ���RD𝠇B�Od%w?I���刱��P�o�E���}���OS�mp��@VC��pNZ;4�$�?p�d�C��U1#bZ��;�����[>�ۋ�R�}��n6�9�Sj��x�lKd6}y_�����A�$6��tl=X�Q��dKи��PfE�#ý���o����,sLS����"%�bA��^ۮ�<�b!C�nJ���C��?�D%�6�¼�4�Z4NQ��Ӈ����_Ǉo�V�]kb5�&�@��/w_�ŭ&i�t;;M�'��p�9�^)�䰓�E���Idl2���@O��le:�W@
h�*mڹՏ/?J�0��<T_Wf���M"�����m�%)Jt��īy��R�XG3.�ҵ�������<0�w60H\'�=�Mo�>���4�����wt˼C��(���vv�i+�yY���gY���D������|\�&�0/�Ӥ|-����
U��`X��vmZeXBR',!�T���#Xp��_E��HF���D�C���t'�B����w�|��B�:m����X����)@��m�n��RW ���!����@�Y[�xhE�^�q����ӉC��Up��HkCjx���
�~`t`	�B���)a��2����C��e����.�^��ܮ/��B1`�<C�*&%K�X�����=�iV
ە�Y���D��B��V�y#b�]=(n1?�?֮||;ɽ�kt�V{����TZ}�x��5�7��O_D$ltd��+�o��֏�;��,w���w�Z5��o:2'�I�� �%�H}#�R�'y�Bb)S��*�m�`�Q���t���A,��Б����������t�BKyNI���5:v2���S�.��b���-- \�5��04ܑ�Y�2��+���%-�ؚ�+�������Ha*Ɩ��FFO�f��k���ū��me!�K6v�2������η~�6L�E�ip�eYR��rq j1�(>e�����K�L�cK�xuZ�^I��k���zD�,�-d��k�kl�n�=��sx��&ښƤ|9Ky�td/4m�!��N�06�i>>;��n�F?�>	�C����JM2r��s`��t	��(9n���;n!��^;N��3�vd]M�MA���l�C�v��ѽbC��vn=��O�ȴ�j7�\	ؗi��Ir�k��ev"o�<��3d$cWFu����a �v����)�?��ۨ�,��N��><|Z����i�\7���0�#�N�b��T��;�E_���һ��2�Q���HT�B��,���Tٸt���q�Յ� �#� �k��?q�У����R�I�\&�͠	I�P�Ŷ7��⸵��faNp�N��W:�h�	��Ec��Rd[����3�w9����ʻ.���Hi�M�cN�b�����хZȉb��2��(�M�;�]�&�����Ҟ;&o��ۀ�j@��t�٘�3{v��f+8��Lb�v��L���,�`0��G[cN�3G�iqL���}����NO���,]��|��aN�;J�i�h�s���6-dT2O�&C���"g� 6�r����L ]�Y���͒�[~�Y��C-�8�Ψٕ��#�?!хQ}07��g��A�(�bX�ޱ��9}z!�׫1
���G�A��(T��Uh]g�ZA�_��凇/1��+t��Xȡ�k)f dK�F���_B�O��A6�XuW���}f2��J̩|���фO�,�hN�hN
o=0�Z���F|�!�rH�F8�ܢ� i�.�|x�&�H�b����d�z����e�հ���� ���U�(�)K�]3�ӑP���1��m���#w)���(V�NWW�!���j�D�Q����#�0�S�������5?��v㋑Y���N3��<���i��tr��o�]H@N'��[������;T�?>{䲱 p^�X�C�<6\úL_�C��w�ݾs	�!�jY����S@p���<��q�c)(ݓ��/O/��@��2��w�hSs0�:Oc<GG��D�X=�@��o`��B��Ҷ��'��-jd>
j�Pۦ.z�{���n�Z\���3���
0�r[q��c!g�i9#.�k��h��F /����:�%%��9!�k1-_i��S�V�
bF͑�҃���@=b��B�'����j Ď��$bե��w��B�5Ӓ��w~��8JZ\�8�Va�ҥ��I�� ݮ�h������F��j��4v�n;kf���/�J��.���y]�� �3Ǉ�5nP�>֜�x������FO�<5�1�� p��L�^m�����j�7*4�:*��tN5)-�	��1LГC?�e�Y-�Ɓm�+Tt���.ƃO@    �;c��lP�77��ł�̩�[��Ϝ7�B�cz�m&�t��X��"17��_���ϧ��j@^c:/����D��Ka�c�v�Z�9�?�9Hfw�+���B�?-�A�L'�B�R#B##{ģ+o��ț$�~j�p��1�!(:_a��q�a�8�ڼ	¼{}�M�PeKoo�&�������a��h��ޱ�p��mw��S�Qޯ':��C��N����w �_��|[��ާ��fA�$c&��8��pU���jC������������Q�,D�2�h�S���1H""�
��k�����B�'cY�d瓁��٤�7<�M�M��Cn;��o��k�n������]�3w�����G)f���b4{w ��X"&�CR�ݒ�q��/(�lI�29b{=�Ou߾o��c��LS0=���"�qH0cl��ϒ�:~WJ�e�P�	����O�v�^Г���)!f�e���޹*b��d�f�L�QNyܴ�����4Pf#Җ�@o^Sf;Y;�w���_���^��eo� 1�1�6M��tg�,�1�S7�l<T�e�"i+<�M��e��84�,�&�T��F4�4=5)��0ٝn� �|?��3'x%���6'v��$n�/�r=��
c/��R��>:D��a9�y_�vS	B��.�PɃ�<�u<�x��r�y��t���f5w)���k����]���D�]Y� �s�2L-/}=?�>�]Hc+K�^Ťo����0#W�ڥϻ~�B�㘍ݻ~�#T�--R�E��VT
�[A�d!9��]�G5�CI��d 6�j���R�K���B�&�,K���o<��2`�]y�����A�w0�L����M1�m���]��)G�f8�=a<��GWr��4-!GH�������/��O�喓�<6Ƴ4��У��ф[��o���9y��,6Ƴ*��f�[D=H�2d��iԻN�!���yn�&i�]�G<\�&��ދc��n�0��]�1}j�=�Z��}يSS=dH{�=h��Y\w�[�=�l�T9��ݣ��s�Ƅ.0Wtj}����v+��ũ��l�z�NC_X�7�
�nh��e=���]�e��%D��a
a��g��>���5&0�xq4E�f�$f �� � �b<%�N,"Ou��섓��&v��m��% #[�R����5�J9b�^s/~�փ*i"-S��鞳 ���&2rQ�)@W��s��Vd��dQ�-�;��q:��ob2E7Xq�I�+�n3| �x 8�������=N�r�'YkWX����M�x��?�������/���_�y�AG�?��x���Hϡ�XA�Z���y���!�����}�8S,�AjK�C�M�X<L-2	�)�L`�2ZF����@���	�ID����R���u�ֻ4�0o�Ș��-��I��b�/N����O�t&��|���ȗI������|QĨ����w��(äa��s�X��"İ�Gz��k�A�+�S�`�񠌷��p��k3�C�+Y��c/*>n)�-�y��b^��Yb-@���v&f^�e^��|��n���4�-�C7U�K|*���f+�����h3��<t2Z�v@�~�zP�u���D��^�jB�Q�h�J`r�L�BSHt`��rx==�]s�S�69��v��]#�
�;��x`HI�|#��`�ܠx�ٿ�FZ��jĬ��>Z�<��lS�C�"2P)�}%�������Y�ڍ��?�x�c��A�I鸔��Rl~�5bVn�#v,Y��c)au�7 f���(�ϋ���O���/3�V������i�W����B��b@�4�@���[���=c��~��M�^0A�E����������AC��Kv�{��?s�v$v�Z'q�����lVfe���a�F�jh���n/�����_����4kE�e��du#�q�;����H��Ez�.Ŭ,ZJ�s3*�T�2 ���_�5m!����<ǿ��ou{�u{�N{r]N�'��(�HZuͳ�8���#va�:�ǚ���2]��A�/o�aN~e/9���0
=�҅����Fl;��z�a�	��sh�G*m����T\ V$}L�Y&��$n���y�u��}���v�1&1�z�e��� #Cm��P�e�t�b"�i�����W��	�����\v�]�2:(w�9C!���P煪y{*�Y޹w�êrz�3̄H������n?_l(C��ٲ� ~��������?vaU�+�6=*���.4y��/&�����Q䨱O[���l���|]�g/	��
��"�yja�'oa4�܊�X�YS�Pæ����*5yr��(5�ϻ4����{̔�5���_)��AC��:�Gc�����]��mA.�tQ��|�$�EȖa[����Օ�E=���d��o<���������qB*&�R1%����*e��sB�����_��Oy��޽��!���o��vR�o��B�o�����3X�qp��j�;�l��9$e0n�����v�N?���P�jC���a��ZIEc�	��1�h�Mڈ��ؖ`�~ѓY��J#��pa��nZ�7��Ҿ���%�!�_�d	��e���I���jr��H�����VG9bR�,ei�	�/�m%Tss�>��.��q������U�����M�%8��۱�:�gh��R�ؖ��j���u�1��fM$�ރ|�� ����T�xJ⥰�S*J~�f���8�����m7D}J�~f,m���4H?�v���G������x��	{4����;�$N+�Y����� [��\'Gɫ-͡(d5�8B��^g���B�.�U�w�١��v�+�ۮ�J��F�j,���������~��g��[�Zmx��E��HY�ŧ�㠣q����e� �u7�"�,	�t!]���w}n�\��I�Eul@b4��#��0hk�!t^��(���6r��r�5��&����H}�`�!���p�MЗ���q0|�<|�fj#~\O�0���Y}�|[��:����t����&{��<.�(C�\����ʌ��U:1C�l��Vs=�񠾗[�f�J�Ck�x:3����%�J:c "��2��z~�jȃ`m��Sl���a�ai�C(]3[�S9n��qПˤ|]�6����z��+'��ƝHf7��?����q�u��8��ۅ;Y0PI��}G��2���+��|C�2HWH�� ���f!���^�DB�kY�qq�否n.j��C��,���$�ҙ$�: V���JC&k���rTxd�������3B �o��o=K����Q�z�$Lѕ�I��AZk#�<��lZ�1��Y=��3��pe�<�c2�X��GS�����wI�Z��Ļ��v�{y�3zp�ܺ���-#�m�H�>��\__���K��S�b.�E!�s�lS������q��ĺΉ'�y5�?I��Ի���IO��f�=��<��P����j�]�o3��e���PS�c/�=I]���u�y�[����e=0.M��B�v�t��W��a��X�1��y����6�B6���Ãu��w��=��hәh�F�gF!�HC�2��/ Ҩ��"H=a]�!�i�m�x
d�LI*��p����w�a�k�o�"կt���q�F���/N��:Èα���;���� �jr,��r�B��?���������>A˟�2-g]�>������*��ϲX͝��%L��6I���2��3q���� '� '�u�O�i��$���x��	 �7���ĭ��Kb}W5W�஋��-ogn��[*#�Iٲ�� O�Ƶ�{�$i���K���q.��ЅuD�vŹk�QV-�T��HٕH}�q̞�ܝ^o儁�|*��9V����Y4�,I�����Ɍ�ԉݹ��"����Gھ@�]��bϧ"�$� ����E���|*���%�A�Gy;���I���D�ְ�A������葹~��T��k79��\"E���    z������"��~b�AQ"y��J����E_Y�S������W�-�T�V=e���������'�$0Q��0:�8�%��+/�"�֥A|�9d���C�g�3|�'<�2�D�L�<�L�����r�G<���3վv��'KթQR7��g^�Ć�~�Wrґ�X�<^E�r`"�^L��ƀ�U�S��� pw�C'�r�/��+�D�C&������}`�)HQB_<Q�����'�@�X!x���~��=����A!�������������N^�����1x�[��)]k��w���%p�2?���Y���j5�~� ����<�x���НH�!Сa��&�6=$��Y�����<'t��P�+�0��[��p+�`ibl���p�	|���B�!�Ð{�;µ���_፼$�!3����wf���׫ヺY�Q���a?H��D��!d#������X[��bNMD	�6�>���;E��5��u��s��;d���!{�a�!/������g����|��(Ё���E����c���z��!e����K���|�fm�\�i�#Ԥ�������m�2�2���.6v�	�R-�6����Q\����F��f�����R$�"�lu˽s���0:�<:��=���c9Q�Ȯ. �$��'~��C�����+�~3�� M[�u������I�<d��+�罎��o��ǎ[�C�l��FW�SJ�u�?�j�3��J���������9�ݼ~9ߟ���䠿��˿����w���gL�Y���_�����SؕyF���i���k��gNR��!R�\� �վͶZ�v�d X�j�Xwd[ ��]�9��C�K��G���Q�e*�>sfsY/��W+G�poA|$d��5�t�Y1�n�^r:L͖x�(@Țolӗ�:�o�gy0�C���kt�Us�˽l��P�+��N�~�y愱�7t�+s��ڥЊ|9@�(�|i����9"�d�Ck5'盦��H��������	h
��+��)��Y7oQ�Y���!���b4Vo���3S��� �iՕ�!h�|f�i���3�#��-��\�4Ε���Y:u�WW[� 1d���;�����X_���SW�ˤ�yU�7�d�}y����i��űw��$��E��}���N�kw�Ø���^Y�ۂ����1���r���!��[:��Q�i�3h�U����i�O�/���\�����/"��!N1�����:��H�e�Cˮ��G>�
?	)��ҽN3�i=p6�x�+#�f;��7�I�mx�l�����o���=�1��W�G�H�($qIR�7�"UG�V�@�yK.��ts�(�#��²�����"E�e짓�M-�|8�?|�F�[ؼ�3swZI㵍s�m�� Ȑ�ĵ$&���X͖z�h��_�i�Ԧ9^-5$�q-YOHR�1�Z_����n¶��2���tJcZ,^zH��Z�/B< zb�+Ȉ_͈m�2�u�\�г�+���N2��UbzA���5}̘� �\KU�d�+d|0�@�����^������w|���s�-=����5�����ax��v�u�E���Q2{Hc�Z�<�m=|~Zs����&/�o��t%��+	��ѕ򱐫._���pG�?�g��f�bD={؍�H(��\�v�Z,�yH���pn���ܰ�S����l�2�y�\�#ޥ]Kt�*[
y�*�b�\ؘ4P`��O?� �������z=`
��N%n'$`H��a&b�ũ�k1 [.a�L1kĤ�t�;n� π3���7�!�9�q1Ȋ~55���tå�B3�����Y3��0���ˮ�4����N_��6���K���7@�iANgθ���\y�O/���C��B;&����BC�����i��
Y��fea��^9�qt4j&�ʎ���i'�ۍ���_�3���0�7B�y��r�6���Sԁ35�{�A����.Π��BŰq�,�[�L���R⥥�AQ!�TyN�H�_x}�t�����am�	�������(Q��^�j�����&�6ţ˻�F��޿@kmzk��e�U�m	���'&�DP�>f�6<��!-�3,��g�E��0�7�2o�yw���3��3<��d�h���B@�|n����9sHh�,+j�NdxFS�<0�(�RE#Cj����24w�3w~D���0cvBN��%�4����_p紻��n���\5
�6\(	��g��\�Ʃ�n��m&4��~�[���b�����/����{�q�C^)g��c5�q�X���A��H�V��b�H��<ۙ<3{(ۅ&3���>��#r���3�0�t��t��X�-�Ͱ���l�j.
l��'�A�U�fL����.� �hWC�f@�mY�5"�=p)f��G.�m\�B��wf�O�A*
gXt����Xfm��@7�fC�\y�`��Ϲ�ۚ� wB����e��#�Tr�r�5[i�¤R3}�GH<��r��'��o|������5Q9ߤ�\�!��s����ש�{%O�X��p����{Ȅ�,���n}k���1S^ICm��jH��|������"��ZLF��'���P�PE�ڋ:Nr�d�5��#�'�;��Z�O�Ra9�
qr�)T�Q�E�2�M'Aӎ��>-H�<�pna�'����n2Zi�<��D逈)����t�/�{H��KX�$�}oӤ���\�/�ouR�<�uV�ͻ��4��CI��M��N����9�����`�f�� �4s�x�j���o���8ɱ8it(��;,�ybo�]:QO��dn�.ܘ>"�"
Yr��x�4#b��s�d�`_��g���{8��{*ш���^[�;��?���?̶\�m�e�����������4�?��[�@F繧�O
�+M��*���ֆ�����:�I�1��q�2���
b�M�ۦ�'C���9�殻5��Q��Ό���o(H��|�e��$ k����W#���Cx����K$���/���@�i�]֥i�]���x��ė�$�r��L����{�d�#Zg���i�m�O��7@j�{�H��@�5��*i�ȟG�Z��sF;mw��� Y\`���*�ze����(�i�?y0��4#�M3���d�*/�>}�� 	�\`&y�$�_���ظ_do(���+��t��).���m�A�
b-b�@�t��B�w���Q�Le�+���[T�<m>�E��U=@�.绸)I~�4���w�X�I_Csh�Q�,�G�����V��nB�����,)j������2WM΂�GňN'��\�>\���:�^�d̅D��eT�%�
 ֺ;V%�������C.���ac��dȱ��p� C�X3��0�:�̢�]�K��O��A{:{�@��q�it@h�6�9��{1� 񈋝7����uۼ��Ac���%�PxD�z����Y��O�bo딛�oƲm]Z���:iN�4
?ii\��`�<	���<%@rV�-�ҷ4p�UH��N�ޭ���.dl:��Ќ�0��X����ž�m���H۪f�i��^�|>}�pz昡S�̩���F�u�T#eU"v��}G奂�u��虤�G�w掜J�j�\%Q�f2���w�j@#�<]��KW:����ڑ�Y������_~�a���9-����?t�������?�
����D���������E�?|N�H^��A.�3���;2((iZ��@��ޢ�w���O��Qn�s�%��_�F�2�%,�k��� ̍��}����D���=�k����P��S�-�kߌtދe� �wܪ�뮢5�ڿ�������z���J����Tg�<��dȚ�~���|j @� �Z&l�O������P�@���1���$�i��;n�"�U/W��*����PU�b��������9x�\W�\oA��z� �����:��DCw�|�C��@�#e�����E�*~�(n�u��f����ieU�eP;�8��(G&�.�"���@��ɭ<����e�    dP�L�W�F���<��l�B~�P*+�CVG����`��f��A�����r'"��.�qz�ag���X��+��<�V�	���/]���j��A�B� ����������� �_zi�`C�B�]x��γ]@KTs������@!7�_��L��� WLM�/��o�!+a�iƽ��|�}�� H��W]wZ��6�mڡ3��!�6�%�H�=I��z9��i�(�y�����"��#� ��ķ�񝛥Hm ����X ��|��c�-!L����L26�h����/;b��__��L0$��-�av��"KYRĺ�o��@C0��oπ_"���� ɑoI��佩Fа�@�I��*��E�/��I����<5�ZȐ�5o��4_Ȑ���Kvs+<\���{��Ll�B�p>lEF�,R��}�������
���RK�߅43�M7�$U��b��� h�s�+��x�^��M6��o���hy��(}쒷�iyx8@j#�R�*O��Ų�?4�,����u��b0Du����-�K&i��A�2Z����u�(�%H��cb>$��c|m�9�͑ALMb��le�⚮��I����ug�����j�����o���� b�&X��n�Όg1@�E��,���ɐ%%H��Ko��w���j��� }!�g�:�:��ƺ����w��WV��a��"�8Ty&���v���d�+x��YYW�_���^��d�=6[������hފ�I��˓LS ��W,D;ԋv����*0�ꨮَ�f�h�7�u݃P�nW	����* pݐ���Ϋж3�o]*80s�a�%�J#E�h�b��Nj$�s�C�wX$=r������0?�5��O�$dh643�Kn���&��q���v��H���Y6� +��,!]p;��m&/f��v��q&�� !s����GY��r��/���R�B��jj ��<�*����|+5|�f��Fϖ!���vt�Q�DC3���u�!?�7��^�y��������k��\ӢZ�:݃ub��P�������2���Hb	�p��e��ݧӝ8dy	�f��"/�I׮�﹜u��=�<�S�D��<@*oY�5Z&>p�����D�%T��rqs�M�q�����:��V��W�6Idbk�B�R�C�q!}�7�񋣲ҡ�8��QD�D���^y]�:}<K9y�a�1{�16��� /9�����4�A�&o�'�\2��5m3Rh%���c��Rg�O7�����en�̗��G8�,��-�Lg��n��#�$S�t��^�#�]ƃ�#�lj�7-���X�(������%,�{�o@<�I	���TU�o"ĐZ��Η��X�`�5��J�x�e_��.�e��a�U�}����&~	����hW�2�|�&v�v�[����~gq�\���'��ʕ�i�]o��Q[�@I�qy&��Z�K	4N���N�* σw��A\ש	�v�8�%/�ߴ�ьa�>p�4�+�D�/�a������2�l֧���_8�#�F�N��_)8nY}itc��wY��@Y�JX@O���c>�~��- � l��+�yb=?�nr���&ʼlOyˢs�^~,t��������~��C�nYY��v�� ;C��*�o:G7���:z�9�8ڱ�P���9����Rh��^��C��b��@vl.i�"p,�<$w_7?БBN� ��w����+f�Z[���^vb2ς��+��Rƻ.�N����rh]�n�v�Q�(����q����;V��c�;`�)π��:�e��{��?x��F;�6��=��b�(���s��� X/���Y�+w�o
�������,�V�>y��L!�w�����:��;!Ǥ�pC������T8ޱtlt�� p�A��������tCh�r���7�bS�S�s�o w�2��f�����e��G��g	��f�[P��������e��/4L<K��T�-���D�n��<��W�$2޳:��:.����g�~{Z�3/��'A�!��lk�P+��G8r��x�4Y��on���Z��n�v}x�*Cv��c,d"u&��r�x߹�����j��A���;:e �Q����^Ո�����լi{5I7j��f�m �8 :�[��r�)B�q��NYA�����q��ZY�?����M�T-�w^��ys�Cz�t�؏4(R�H6��2�ցY�+&#�5�qܔo���������A�3�i�K_��ʹ��4��i��-d�ڼ�BPKF�z�C����8|��)/�Wi��Gm^.��'�@z���F��+t?��'V�\��~������G���лC��-�TY���,��992r����J��Ä���������G���$n���o���ǯb�:B�X��ީ\���|�(&��T����˙�FH6��d���
y���	��o��(2���y:P��P�n�E�k�x/�N&]ԎM�'k
���G�aO�C���7���x]�92�4UV3��3Oc��u��*gs�[��å�xS)B�Y�ft���nض�_��w�y	'��:]v���S�DHE�#+G�kGC*�f_�[�)�T�-�#-���γow��w�Ȇ�b��fW���4ҙ�����X��쑪8�Ჳo��/�Ŵ�WR�����9�J����5�m���6�SU���,�'Ȕ�ۅ�5_<E<
�$PX�"�]JȌ�3C�1�Pcn� C��v��MYd��S���:�E34��i9+�f@"%�)��,���#�-��nVYǧi��T"RwI#���-]՚�}O�?��:�XgȞ����<y=?P�}���Gl�c.�M:�:���`��"2�9uw�xz:s���|�=f7��Z�+Ƀ7��P����u��	]��9v�9̞j����яf[�L'ʵ Q�o��H-������aֺ1'%m:6Aq�.�=����%����D7ٜ:�W\��ߘf01R�D����A���vy/& iq<9K�7W[�<|������jh��FV�Y�Pt{��4jc2�u[\dK�1*A��KP�UHRO��z�@_��2���8ZN�d�$s�]�w�� D��S���*��u�\�]����dF.�e�98�C�:�|�3�n��|�u�(��)خl�XQ�\�P7���ksi��
hA|����ӏ��E"��ޥ�6��QH��c��Yq��u�r��q�I�J��lH�5H�QG��5N#�l��~϶n�_����Y���n"�6[)¶<I�����n���!�CX�F�n�8���I�6p�����k���',��*և
mƃ �F� 2E����d��',ܿD��IO��3��:o��K%+]W�`)b��~�!E?��޺m�(�sof�U��,H�t+a�2={y�Ō�5�N/��9W��￞d����9r���ueȲ�Ѩ��/�e�D�B�+����@u��tu�[�bq�^,��4���RŞ��U�u��'��I��u��M5�߉$dK���8�e�ֵV8��M
��}�c���$�?�|������8+"�ɉ�V��Yμ����*3�3
G�b�h8$/�h�}ɲ�}��G���XP<�|�WUk-�7��&(��n�*�q�H�w��~_��z�GB"�}�3��/s]ܵY�=�d�TuV�ؔ�n���&��g2�\l$\�(j!��!h&}Ⴤʽ�J����l��ػ,����Ms&�|'�"#$��E����J��]"!v"2M�R��^@;;s���5�fi�����i@��Q�GkaF�����~8�:�2	��q���}@��n7��x�iD�Ѕ�eF��!%H���]�]U���6{����ގ��u��'w�Z�@�i<W�>�U��߂v�j�+-Ƶ^�<p��#�O���7�Z�����J>��p�|N���6}��FnhXtgX�2Q����붱�1��핹��AT�!+YН����k=�:���>�^ݥ���� �f�p38�i�6w��"t=��u�����,�!��	���tJ�\57�ys�l�y�=��9��j�    ����z�Gԭ����@;N.�r$4����G
ew�q#�FH04Og�#���� m[yW�kY���ӹ����k,{�p[t�V�Qq�a.ۢ=dX#3�F6{�w�{�p�)cviVL`�Хut�*�#�	���FM����}�8
)ѕ����=w��E ��SAs!_�چ�GH�E�?S������N��$f����	��2
�h�\�J�O�����`=r�
���-yy�$�˸+�����nk%ͽ���(Kh�0,��w}]_v�h��`���5K��"v�;!�E��O�����h��!Ă]��_��c��G=#d	�s��_�>��|�d�F��t6��b��^��ˊ��@��p_�Ǐs�,<%q����O'���_�v&|��y��#� ��BQ�b�{�Є[f��I2�1�4f��sZ%�Ñ��Q�4$��˻����A<RV��*��YXm�����|�Y� wE����hGS�k�68wMPd��TH��>��� d���U�E7l9�a��+o}��;�3[����f�+��	��)���an{��[���ŭ��9�Ձ|+��'��Ч�ާ+3�nނ���<�ʠٵ��6��ށ��i&e5m5b� ���u[�0@3βK�S:���AC��=ߔ���`��}F�|3|s{/f �Sp�A���-9��LYΪ���b����>�EW��I���A�54�Dz��H#3~��"ڳ��%�Y&�����h��h��@3lk�j@j��<�<��]��Ĭ�
̺����5�߅����ꕌ�+?�[�\vT�8	"�I���DnKc��
����rDNT�ROtCV|��?�,�s8߬�O2�-��B�:6����Gv@"��"��]����X�zL²n;�NxE�����p�w�f���pC��zrp<z���yK� �CO�;O�S+����z ܍o�e�1A��5���f�%�Q�/��?�������:Fh��|ǎN�g���|�N�~<=��q�r��/�]�\��I���@��늮$������JμY�#ց%�a����/*A�YW�z��R�.�5 �g��#E'i�q-ɧhw��/�Ow���J
���_�
��;}Irַ�x��]!�.�"G�ĞS(o�J��䭸�̧�����g1/�Bơ�Y8�
�Q�c�)*䩤�E��M�5�z���:|�t� jù�2j]�\�f6���a,�Y,��#�\7ޒ��i��g;	���[�1�B��YX;"�K|�	�ɑ*N+������7(0��,�]'~b�9T��!!n�n�@�0�]�S�'��Y���գ
��Q(��Ӷ�^>��ED�+$�	����8]���ѪFl9�V��)|C��N� d�����"ή���c)~�x��\T�x_n�O�����C!t�NSPW�s�W�"�������,k�oL1�<��B���_�����r�r�B��)����D~��,!����rL����2d;�`�bA��Z{���V@�F:tFz�bq��qo=C� �Qe���"�^!�P�)��Z��ND!��}�����o�Bʐ�P��xw	�5�Yh������5&�����]ݔ�?�>މ4Z�'a�z�-)�6m��^"mHЦ�A��
YqBÊ�Q�}j�:��	�K��I���eG}��I�YH,�sqSZ�� t��U���nf�!�Oh��,�j��n�$m�/@�m�\"UV�_�^zh��	y���'Şl�a9��j�*˱�M�?�i�R/��2�W��l"]��E��T��M&����X!aK�L�)h-�K=�cjQ��ڲ��]���BW��瞶��0� ����A�j��e�.*�'q�Ӹ���g�.�o6|DY�s۱Yn�C��ƺ���4Z�@y~zF^���p3�:dσ�e��F�6��_HziV&N��Bz����dI�)��M���x��;A������h��3�!��R�[��2!�B1h��(�^/DsV��Ѧ\!�EX{�3Z�~���������=2SCYN2�B���2=I����y��I7���qm��\�W�	�IW��U�&�~�ؒ܂�������ѥ�󧻥1����Z�;	��F !�Uh�r�0�G�g�k�nt�nBA��7>%��
IE�ҫ�2�.���iNJ�eǆ!�c�Mrs�m�f@!�����L�P1���@1\�{�=�VB{S�+$�	k��<N�!~�U�Mf���s��������g�f J\zg��M��ځ�QU;��6�J̥Q0WH����|�T�^�"ԎXz�R�)E�;~�}�|qa����[�@#�ԭ�LBF	A\����� 2%����;ɝ������K�X�P3r��_F�Z��PU����}��jG4��y��R��2G�^v�>f�a���3�Dq��qs�?ق�a�/cK)�PeKM�f�B0T��U0����Պ�~L��o�W ������!��c��z�?�A�:cNs�B�i����&/w�b@r��:�M����v�9LVB�m��~�ۓ������+$@����,m̙�]��~���p�D�R��?�~��vȍ�WX�rJ5�v̲����v��Ar����%*�Y�>��ѽ�V�qF�ڢR1Lc8�_>=�>K��nP���0wZ-���{4�L�N�B��i�z����]�ءbk����MU��i#	T�M�����]q��\xT�O�)W�ńl�X�N$��V��/R�k�Ǖ�ߍ{���J��y-�.�Fʹ;��nƿR�) �	xZ�L>~�ܜE`
�ңfa^�G݌Ytt�7ׇ5%:z�Edꓲ���l^!9NT�+`��`5bS�������.���@�0h�]Д	���<�߃�ڃj}��B?=��������ݜ��2�VD��������?��B����q�vс�}w� A^��~�Fך��`�B�Y�1yP�S��/�&��D�ه�f���Ϯ�s�F"�9-<���z�fd���3�<(3������0��)m���>G��~����@'$���xɟ�j.g=�s{��9�)rN��Yדɂ|=QG&��VУ^m�����hCr��I��E��<:��1����-G��F��ߦ�����~8q��29Eͼ�h��=
�H�����3{m(4䦍S�ѝ��D��D0��)Y�@V���Xh��B�������䚿�2<e��V�ڙ�6��L���h�F/<;�����:U �n,4�ѥD�H�v�v�:+�}�6�>t#wGW�@O����|DF>��Y`��Z���\�p�(����bQ��r�4Ձ�b���p�(9�WH�3!~�Z�zr�c?�N��v�m���Ѱq�IS����G�
�M��*Cj���N��<�u|0D�e�"iM���È�v��\�ψt�#D���z���1��f����3iD�E��E�뗓�m<8�����n�U{5_��1C��h��L���0c��0{�V�an��_�;���қD�[�W����=��b����lS<}zy��5�����s�;���軜���1�tW�Q�rE�ހ�� H�ۜZ��M�D�֭�x���gs��r��]9z��o/��]|�33v�c(�>FU�s{o�V�v�VX�L�P3r�W YOt,��K[���R�����b:r��)�_^Ju)��:��8��8�K i�d�f b;���A[�l�DL_.�%��
I��Y�VLo4T86͎�m�<6���|����W�g^�>��~I��4�9��;��~���g:;���t(p��o��ü�15ht���E���-�zX�C���+`�,�B��������!A�L�a�����ow�V8�5��L�<fH����I�ɶ�z@�cZ���i�ܯ��0u�Vs���ΐ�K��t9L<h5�U[ã�����\z)_�XɳX).S�[���q��˻���C�!��	��t2D�W]���M���A�X$mᆂ<p���Hnآ��/o��e3 R:E��#��)�j@�AE�uoAӂ�ܶ<I��TM;�wi��ğ#\z��=���Vރ�vt��] �  �\�	���g��U�Yp�9��2EM����E6 	��2�N���5)̘��Bj'Uy��VHw�`F��������s{-}����
��Yy�=��[� ��ڎ�>ނ{{+����S�ܥ�����.�D�U"o2�2G�=�ý9"��0��� �-ӽ���#�γ� �&��Yn:�4�zs�󹛩Ӳ���X�I��Bz��`u�4k�a�Q�F��`�H*���sa�i#H�Cg�R��JY�g�Ʋ��hHYӗ7�v� �a�}$�&Iy:YjN����ֶ���y�AQ���:?F(cUf9���Y��U�q=#�ɸ�	�����6��d`c��-T1�����龲54׾3���F���:R�\,��}y�Ы�գ��r��18	����x��C�C�&䮔y��<���m&+�#�6J������/�����.      J   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x������ � �      L   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      N      x������ � �      O   �   x�u�1�@��1(>;^S� �tW����_�C;Z9����q�s>?��}͹_�wq+��m@G1�#g�2���Á�hN����_d�d���/̝xb<���q���b��K�����Ë��c��u�[�-Ŗb�f�v\��`�g4�i��y3�O�H�      P      x������ � �      Q      x������ � �      S      x������ � �      T   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      U      x���a�与�W��6�K�%�,bV0�_�ٝ>��d
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
-Pl�#�x���Bԩ�E��&r��Z�NM�d:ܖK�/<8T(Fo�&��NMd·��A�Wx���B�m�$�9�C�(�D���~!M��6�����κ\n;8k����ξ����y�^��BM��m'���m'+f�m'k�m'++^xp�P���m�$Q�vpҖ�n;8�j���;Y������S����؅�=\]_r�[���,P�"���p�(���߿�?Qg%a      W      x���k��(��g��L �@<�A����q����4�5UgE�ꪍA��z�q�+|����?n������d��W�����u�Ժ�R�#?Ȉ�	#3F��Y�抿	%��7O	y��?�������V_khtoj����n���-�-�%�PC~�B7�}�@ߟ-�G�#���Bb�z,[��,[��OKH���P�
X��-�$��O)��x����+�d�\�v,X�%빀��s=��xV�Vpo=�m��e��e��eċ,�����5!bM�X">s#֡�u(aJX�֡ď@�C	�P�:��%�C�P�:������-$�!��[H�C
۷.R\��)l_E�T>��\(1L�s��\01L�s��\01L���D�X�����)�`J/����B)�PJ/����B)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J/����)�`J(���J���S��)}��>`J0���L���S��)}��>`J0���L���R�@)}��>`J(���J���S��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0���L���S��)}��>`J0���L���Sz�'�Bb��^�ɷ�X�(�W}�ob������䏀w~=�{��&�I��8 �{����#���Xe��*� ��FX�=r��w�X�#��������n�Ab	�p����qWΔNW� �ڎX�'N��n�;��;H. ��\poG�yg���#ܼ3+��#ܼ���~9��;H��F�y�W�7� �&�p���#ܼ��c��$֡n�A�#��7� ��p���7� ��p���7� ��p���7�\��&`���w�!�{ �ϐ}��P�c~�$\(c~�$���c~�$����;H,[J����;H,[J����;�@�Uʯ���;��;	&��c^��r$_�x����y�wƉwJY�<�;H���>������x���I�bX֚j��-�N���}ʎ[R�Շ��I�~�wЫ�k���E���?q�[�Kt���>�|zݜ,Yr�~��ғb���M�9���}p^�Z��{�ӽ��k�R�1O��?J��<�;H|3��{�ӽ��:D����{�u�R�1O����c��ob���{����3����*옧{	�ؘ�{�EKI���{�eKI���{�eKI���{�eKI���{GB����
��1O�{$ޡ)��t��#X��L0����u����41���A���-5M�y�w�x����1O�˖R�1�˖R�1��x�Q�;��A����c�$�!Ju�<�;H�C��y�w�X�(�� �|k��~����>{k��[�E�Z�1�5 ���x������rXKm�g�}�d9�u��ݻ�����:�����._���[��7�-�>�4����wg��q�/�B�?=�Ǭ��4�g�~���-��	���u�k5�_|��*X��W��@��>�����M}B�bZ��ty��G͂]���%����jR��u��%�@e_1����و�r6H, �F�#5��TNR�ǩ�kt�f�1�X�4{���ş�@�U�>etR�fbşTnpƚƂ��5���:��[�^c��V���Ż�fu1�x�Ӭ.��Ax�hN(ϧf#2���ԬK�6�uH�.H�C�u�@��f]2�X�4뒁�:�Y�$�!ͺd �i�%�uH�.H�C�uɸqM�ڧY�4�à�|���P�z���E�a0�XB�S����Z�D0�XB�$�˖�d=���$�R��F"���&��z$�!Z�����G=�'�I(��#$�[Jo"Ƒ�#���wd��|�~JFb�q�`ݣ�U��7�X�(a�=�$7�<�v���&i�5d/�����z0���jI9�L` ���%��z0���:D9�L`�\��Q��@(5���*�L` �Ӄ	$-e�z0��Ĳ��[&0�X��w��˖�n=����$�£H&Бx���]&0�,X���`C@\׹��R�L` yo�GmzH���K�>N�!˖r`=$�@b�R��H�V(a�C$��Pª�H�C���!�%�zH���:D	�`|k%��
	0���!��?���Ph^�s�7�������?���>��"��k?���>���t�������v��K-Y.q�V3��MJ�RX\���M6������?W�^n�,)�5�p��Tq��D*��]�L:P9t ��v���������n�n��xqy�#c=�O�|v��]�eW�eM���5�����6t �x�A
�8�
T���Q�h�_*7 ]6x��p4����|���'P�>�@��4/kHw7��@�U��@�)ԁ�������F�t ��`�@:��wd��5r��	G��UqL4�S�d�����@<F6��?�d�Q�fՁt���;��@� ��z���8�OxWU=Qu��EL�諸�.T�k��^ruT}�tۀwc��TR]�|Ou�����0B��ZϟO�W���h�f:���h������5������ߩ�q=s��|�b�RZ�K�6�v���\�Rm�vV�Gڻf0P�}������5��:h�{iW�:�оړ͕�	(�"q���í~�k���DM��Öd���*륆�.ʞ2J=0���R�[SkPz=l	���&��r��Pz�NZI��vLZ.�������e��˨�9�瑺�з�\���v�qp6X��7YK���r9s�lOBeq��9<��,_]]{(˚���zxq����o=�)�-�h����k��\��/k��6x9D��`�iPv�FW^hЋ�2�5�#���<4��^�:���䦻��K|6����T�{�D����@�Sh���u �~ݓ]������@:Fh�ӝ�u U h�S=��B�'��u�uH�7h�S]��%LE
m��ߺ.��x�iW�5RwYׁ�@�O�����푺���[Uh�ӝ�u �*����:� taAk��ݮ�Uچt�vH5@ݯ]ŔPwjׁTs �=��/R���7����~?�Y�o~����e���ӗ� {�9�٩��ȞΟ���u�ۍ��/~{����/�t��Gct?cl]}�����n�,�w�a�s�O��xw�B�j3��ŕ�yqײڇ��Sl�����ޚK�q����,�à����z���N��7�u�a��F�%�-�[���wD'c^����<�����K�:���}����wL���-��/���;��"3|Z�ˣ�j�G��A��\��`pZ����N���9��Bt��Nص��H��n|����Ml$m׮eK�v�	��xV��4ɿٻj�H<�]��-[���6mE����ld��h�Og:����㍍��g�k	�e�7�خI�F�����x��Z.l$�m�va#�u�&�k��XB]�n#���d��p�Z�f�U0�p�J����G��`#�8�^�D,�H�R����I/oJ؂�Ě@/o������J���[:|U�a�{��`��#���㤷E%��'�I�-S�d��Xo��6��`#{����l�&{�(�uIm$֠�3���'eJ\���{	�)Jh���A3�3��ؿz�O�5 �P�|�|&X�ĺ��6/��{��Ą�|h;��.���|�R^��1��_*�fK~@�)��h�T�侫<�Ơ��\���Z,�&sZ��r�0jp?�v������F��/���|=��P��t䕊i	�z?��k�5�������D	)��:r|��n�/�����˞�o��m��k����N��b*aT{�M�ɥ�7����x\�{f�EYsuy���]�ܴk{=L��Q9������+R�'��?���VV<�)�{`#�Y�u>���,�1% ��&>��-��`�|�(�;K�pJ ����z��"�H�R�h��I�pJ@    ��Ě@�p������
ww%.�D�M�����	��Ƃ�v?%:��u����֨�(�H~��i%J�^�xǤ�F%P�F�����)�
6˖��x��ΨN�Y���FCMJ؂��:DMJ䂍�:D���`#�Q���/����G���B�ڐ� 	x�0����`[�{��7{���z��7{��8��i����;>��|���8@��uD<C>y�������a��e�or����8lp�������M��p����/{�OR���Eʛ��Z}*���������}Ы�W�X�T�����a1�?�����~[�u�R�Kï����|������\SF������խi���r;P.�p���cn�{^@�Xԁ���@�oj�R�ZH,Z̈́gHHy�6��gE3H�M�l �|~Oq����Jp��W�J}�H�nn��f�3���W >�J���ĳ"���-Θ��c5���ě�iQ��%H��@���~�K�'�cF�����\dȧ��z�^d �!��c �Y�$��4[���W�.f _^^M4떁Ĳ�lT�V�Q�\�>�٨4�/��|�x!	�Cz�����;�/d ���$'�z���Ě@)�/d|�qW)WQ���U��I��/d��#���㤼A�2Ɖw�7�x!��V�2�����BƬ(�B:�x!c�X�4?�5H�S0��d�G�2�x/��H�2v>h|Uㅌ�?j�B/oB���f�~h��#���^����F/NJ�� �'%�z �q2pM��Gɵ@��|� �;Ki�@` �����=��@�qRZ�H�	����')w��z ��ě��j ����`�!@ 0�u���-5>������R 0�5�1��A 0�|�º@��@` �l)1�$?�:��\ 0��FC��@` �Q��H�C�?���z ��M�}�?z#���q�QI 0���kF_%��0�)���7� CFJ ��M%��'t���;�@�#�MS 0�C��J�aF=FI|�<4�~;ۓajq��o&l�O'��;�9������E����u��TIw���Z�S[�ڷ2�oe���s��\�ٚS������k:-D$����j�d$��;���o.�>�n0o).�����?<Bf�{([hI�_��q\|s�v����$��S[����ܮM�����T�ՙ]����g�M��ڷ�kއ��N=S�Tm���y�:�n�ؼ������S��n a�r2����6�LS�w����rs����;�����~����s*SW���!q�,�= ��L�L����}�{�:�n��r�ܦ�0$���K����*H���ƹ漩s������e��2�= �/�T�MS�7M��C&M=���KM�J�>0���B�zԧ�k!O]Sf��0Ͻ�Oշ2�oS����4O]y�Z(s����m곢/SWV�zʔ�r��N���2u-L}*>�.M��i��&iq5� í5u{�&�@�?/[([��;bn�����4j�XŅq��}�Y���:U���U_�t��V���S��|��#թ{H�z��sW�TY�����s���u:��^�>g�T�	��8&S�Vd�׊L5����,��(S�2��X�Z�dꃧL}���~S��d�c�L}��>S�`d��Q�z��T��zS��ϧ2��G�>�N}`��ϧ2��$Sce�_�L}����&2խF��Nun��k2�mW��Nu]����q��M�l������+q�H��C����jd*ws}	�Ze��\��Cd�7��S_��TG�0��:�5V�����,�j'��vK���ڸ�T;R�k�8,�7�cqiaq��я/-�onݒ߼_|�̀8,�r�\٤��f���c�'���Ii�������;͕�e	�B~Zl����s���Z���~�흸mo��~�W�4�����f�ֺ�����5��'.u�i�U��_�T?"��;!S�:�T�^����ͦ�'w�l"ZHv\��4�}<�u�`YV�!�r:<�Y[?{��U�[;^�������usiI����ϡ�y�oS!��}����$�Ǎ�f�vH�߭Ŷ���k�HZW%�Pö�8�>��Lt��PI��d�S+�h ��S�VKojHH��m|ϊ�R�@�o*i�$�ϯnqE�Է3���Y3���J�2C��`�<�R�>f�+�N����ĳ�W4�X�z�R�e5�x3ъ+H%���īE+�h ��R)�h ���ZqE�w-é�Ļ����@⫉�3�@*�$�����@b�j�;���}ZqE�p�oF��������!Q�8H>N����$\czqE��I)�^\�@bM��C-�h|�qW)WQ�+���r�\E/�h ���㤼A���8�NB��^\�@b�Պ+H�T��Ƭ(�u$*��Qb�j8H�AZ�O�p���%�����_���ş��:R)�h�N%��1%xqj�1$^�Zq�'��zqE�'%�zqE�d������k�����ы+H�YJ����K�^\�@�W4�x�����$�J����')w��zqE�7=����ƚƂ�� ���! ��\po��A/�h ���-��ƺ�;&5?��$߿�.Pb�W4�X�����$?�:��\/�h ��G�����:D��^\�@b��Q/�h �Q��W4�����GoW4v\hTҋ+Hh�+jX����Ԋ+�T�+2R�+�T�+ㄮ4�W4�pJqE	m�zqE]��⊆�~u�+�@����Ih�Ջ+�H����T�+��Vq���![�	�^\��%W�'(����u��?���%� u�I�	��p%(!2�V�� ��q-
7����)a�"ߺm��[D5�E�>!Y�+Q�k��O��t�#�_�^�}�BS�ъH�h������h!;6_lW�B�H����#�G&�٠��Ca[W =D��k��O:H6�k��O��Dx)@�I�4"R�Ⱦ����4v���gȳ� ���aټ,5���w�פ����8b�C�A��chqϒZ������m�/��Vg^���jn7��S�(
~��y��l8����0�;�7��{s1������\
2>T9�l��ߛ�m*Z�}^\ͻ��g�o���ޕ�{�Ϭ4�{�dzS>�$������/���x!�k5ڟ��V�i�����t�.4�]ty\xGi��A������[LM|W���=�|�e+G	��s�Rs�>�5�/ݣ����OF�{����.�̝�蝼o,�e+ٹ���=U��z߾O��I]bX�]wx�DT:��-��#��YB���<�Y$tqO�T��T��,���'�+8������}�ݳ2ҍ�t�0�@�?�%�>A�ݦ�q1=D�Q�n��޷"�W$��t��"��h��H+�Ê4�"�����$�"�`fӌ4
Y��M�%a>A���t-��	�ɐh���H�q�Z��d��4v-R�	
i3=�� A�F�+��� AF�k!�OP�q��0>��2i �@o���ゞv=>	����8A��l������|!���`�':�d�X� �����'(�c��ݱ[�ч?��}m=�%Ƕ#/b����8!~)k(e�`zKx���277�pjI�[�ؔ��mX7���4,k]�n��%�|�9:���L�����r�/��i�wyiɱ4�9*;9g�	/���7��&��f�ƻw��o��7& /9�����4ݓ���Ue��1���8�m�gs�e �����7O�i���T/n�.����h��Vƛ)���4��Ҿ%��EcSd�d�dd"i	��6��N���E&tAfRA&���D��a<>�b��D�k1��2��e)�f�ߡ���wp^ٻ��.xd�_R-1^����������~�{[��߽�|'���P)�E����P	u������~�[ֵD�_@%^�|]�/�?3�P������%�G���C83�����oChn^��w\��3�@��.�p�����s�^�ú�5�������������qqչ��P��)�~���j��W0���JL�1�ϫ� �  ���~�e�~�Y֒�fL����̿��������Y]��1D?~�=<��}*�i�ps7�o\a�=���n���+�P%d՘�Tb@��k����T��5����'!έhG�!�aB�j�<ʮ�m�/D������$��=x�*�����!Q ��iڻ�T�l�/����;j����%��w^s���[ʭpKi�4Œ���|=(��$Vk-ӿ�D������%�p���6�G��a=T�p���riHt:>�$��vľ�~����7L�JW�[屼/�ZݨD���T��F�wX���9�h]Mob��;np����� ���bԋ���I=��T^0�T^0�J��?��f~l��4��.ݪ�:�k��Ah�T$�ާa"����+�&����:�9Z��x=�ȇh3k�v��k�K��q���+ͣ��ɸz?��
���������%�OP-��5��J4�����p�0�[b���n�Z�}Z���m-	��ĳ��r1��(hu6�o��ZgCB��u6$dsz��ǉιh��0�p��u6$'58�u6$�jR�l��@�UjjQ�l����Z�Qg�-G���X{4�l��;	%�z���V��a !i��l��$Oӑ���0F�5HK�i �i�<$>��F���ʶ�:�����:�ş�:��a��F��aL	^�Z�T���'�@��I)�^g�@��Iɵ^g�8�&`���:Pr���0���;L��<`Z0-���u6$\)z���Ii�^g�@bM��\��a|�qW����Бxӣ|^��a�i,Xj����0f���-5>�u6$?q��^g�X�xǤ��Ά����J��:˖s�Ά��^g���u6$��P����0�X�(��lH�C�?�u6$�!��:�7��Q��:Ǝ�Jz�	-�V�����0L}J� �J�CFJ��J�c���I��a��::�4�:��a�5T��a�Q�Q�;�Ά�M�Άa��E��a�[ŵ:�l�Sj��ٰP�	-TY�������b�j���Ԥ�P�)YT��{/k�<�ݧ�1Q�Q��>���)�"ݩ0a�hG�X�9�d�����pFY}�C� ��)2a��,�gK3Qh��g�1��T�>ӗ����w��l��f�dx_.�Ty�Q��L�8��#~M��3����>���ݰ	���}G|�o��e����ֵ�Ȋ�[X�[7�2�,UJq�ͅ���w���ǖAǯ��^���#�ws�5��	i���KBK�g{ӌ���zDdI��EZ�ᰎ���\�㽄'�#$�H�"���Zv�,pp����uF���֥�)�ux�r�P�/-���?��Z���X���yToxy_�]�eo������x�����'�*� ��秶��$9�a�9�ټ�h�g�hhQZKt�^���@Z��c�~w�r��g ��|���3�:sS��&�6�-�@\JM��wփ��NڈcK`r���:�L���*=92�DBNqXzgљ��[�r[�..�k^qga�c_�kX��%,!�<��w�B�Kj�}K��*�JL�N�S���>=�5�^�7�k�|�Og���ߙ(�s�F�(t��/a��Av�N��.��#,�}�+�f�>���/�`~��}���>Ǜ)4_��L���,t&
���r&
��}9�f����B�/�`��,�V0Qh�/�`��F�V0QH7�+�($��l�&
I�>M��-"�Na�^5��NaEv�NaE��SX�B!�p����B�q_X�D!΁̒��
&
����|�D��B��̭�	&
���;%LvΤ�v ��)�`�и��I�D��B��"�b&
I�YS��ڋdx_��D�Uy_��D�YF֞N���vj��4�,�a��RC�G�æՖ��ȃ��7a���;�>�$�>��/���8n�>��#g��b�m�������3'�����A0�W�ק�������Y���W��ej�w�m��LP�t��Dr}vYk*��#���}lc���ů�1W����$����OF�w)�������A���o�il븭���p�����ѩr`>"�Sٲ:��q��辂���&6g�� ,�;�f�S���gz�2z��$'7Qȳ݂ϴ�m9�����Ҿϥ��}_�>��������+�#%f���L�Յ�� ���{��*o}<_���Ku�і��=�?[e(���J�~��<���� ���]������յ�{'�:M���C�9O�	c�_B,�;��se3y��>3-UrY��`�`��h=�?BG��}^ܮ;%��ף��������x����y�:2=7�Ò��_��G�(ލ�wsi��ǳ���ANm<CI�>G*���iX�a؜k����Kn�,��G���}����m��/�]2�O1�;����Ih+:��i)[�G��u���6�����x���+V��|˱,ٷ��a�ɧ���=孟߷�\|���e���8�q�����;�XS.�S}>���UO���OՏ/m���j`׫�_V���1Ż���br�K�,Y��]���w�_�(�xK����ç�r"Ԗ+�)�[v�mV�����+��9���~����u���ٵ�k����,��t���0�;��]�$�$y�dگ[L�����v"��k27W��&�{�9S�߶X�����Y(o���d3����q�sLN�%��gO���,LeW9.Q�c��t,�#�r-��-�3��C�K��5o�p��5�:���c�7g���&�-�!�k�ހ�5��&�"��z�&�3�D~�/�a����S������������n��cvq���Ry���O����N��;t���0ܪ?ԳmH~-m�-z|?.~�N>�O:�B��`�a`�Zm'p�7��|`0���t~��?�KG��~|�li��yQ�하�=,[�fe{$�~k��Q�sG��Nsj>/Z��#��#�9���?׎c�v��-������?���L;      X   �  x���]��6��5�b�@~��]�Ţ�Aw���^XhleƝې����Kٔ�!�؞�@��N�P�sH�G�y�=�N�w�~��ޚ���F0!�c�;��� �������w�9���n5�ݱ�1t`����0�y��`�_�+�ƺ?��7��@�כ#!�y����v�=�L����i���wT�zUDb��1!B�@�"��Yft������5���(�7�3�,X�fF��g"��(����@T�e3�l=�OHnVD�7Z9Q��YqO�q?�֧��fu�{C�kml]�!�X���3�m���w�㶓��f�>�۰m�@ �t,!F�x
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
-k6i��:�WR$d��%,H�LXd�Y�y�� ��L0�kfrb����X�f��� g92O�yN�[��@ƪy�3��NC��E3���^�Ma��"n�m�HtO��.̄�Oi���}Z: ��������1�      Z      x������ � �      �   &  x���Mo�6��;�B��6�|�C�HQ�N
�C�\��(����$��F#�=5|�����K�3�5](__1\��~�1�ԋ�%�"|I��(��<���ϗ��uz���o?.(���/׀r]�|�"`C��bW�%R�ϼ��x�������A��KǕ#�L���_�73�����q�q�Z����4c[��,�	��sS��y{\���ck�MDׄ�É',C��	 <Ҩ�)e�4�8i��q��(�5��TO춏��,����f�`hG�,��� ���K�}�$���\�/<T|�� �7*}�(�+Na^�֒_ҳ�A|��Î� Ɖx�8>�����!��YR�FkDO�U��@4�x���bj��L�=��yxm!������|�9��7���e@U`&����*���R|�H-܏������V�!�M�{6��V�n� oPh�R�z�*3�8ˬ6���`
:��ޚ��P��j;�v���ɲ�Pp��JN&����fn�m�X3(�#�	���|�F�խ���1/$^ZR=u͆�� ��V�2T�Id �|���D��6�M)N����S��]��w�	 {�ȌJ�-�$�A�-�\[����	���Ő���&�SҊ�To���4�Ni
��Cs�ҊWCn@�wI�{V�;�A9_~��ӧ/ӻ����O�����?~xx��>Nx��ұ��_G���;S@��W�E��`��~�K4�⬽�>܀s�R�oȃ��t�f���T�D�V��4�+�j_�g�����^hu��-A�8]�����xr��+�75�����B��'_Jq�D�IƼxJ�R|�X%��G��c��dAJqc`1$N���l�^)>g��G6���^G���hJq:�����=Ҫ�,e�tT�~�k�!����ց�d�[ϸ���Թ)��Vq����|�)���A�V�^���}M�m�8}���p�0��Vbg�J�Uw3D���(H���aA�O���� �&q�Gbg�#BT��5�ḃ�Z�s]���4F��,I�B'cJ�c�� �{0��      �   �	  x���[��6���U��@���a^�%���H�]��Iy����A���Y�H���d6g��e�/k���ج+�ߢ1f������å������d���26�:m��M0Χ-lf���T�L�귁����)��_j��B��&(mv�~B�엾����t~�T�N���YϾ�mv�����?���p>-Ǹ���N�sq�2P� s�Ȭ�C��#J��a<Ô��n�@ڿ��e(�PP������\8o���������bAy�<.��c�a�q>��	�� y�8��x��̽#�-c��8- ��J�e��%a��f�w��ܿ�����	��Ǧ#6�
 j�@iw�����������h>-$�. �Ew�fs�0�Mٸs,�U�?��B9�C�H����@͉�,�,�d�<̚j0$W�{m�/li��������&t�����F�H	[�_�Lay��(	)}#pw��x7:P�m.��C)��[f�2Li�ƶ��I �������PA�2�Hk��>����kQZaaW2 z�o������E%_q m5�e��0����e�oV�;��I����� k����Ǹ��B�3`4KW�*(e���}ػ 1�,~Zf���&��W�{�_�2����y�ت�k�뛒��}����2*�u󅻷��k?ߎ����d�B���2A|1�Ӌ��j�Yl)�@xY$B�܋�>*��E�||?��p�"��v_�׼�g�f��]�D-R�r{LHz��G`� 2 ��T����x�%	��Xp�`V%_qWv�F>����c�$�A#��Z�[��'j��{�;p�Sƚð��X$@hnM��+�tG��-B0�&���NR�^��s ��D{D6C�"��$;�䧇#J�c �EP�{�2e�|@yv����D&����3�%����llD�H��W�@|�SzX�WD�P�*@�꼏'k�J\x�A-����ģ)kG$r��B-����_@B&�ѧE��]#.Է8M�~P�������e�� �uXÿ�;){}Y$����TH� ��,"��rl��eb�$�*},!��Z�>+!�V��'%���y����;��	� #���}k�'���~���i�"雦_Q�Ը	)�
�bڐ-�P �e�)iґ�yDx�*}l�i�N{GFz�P{G�ح�g�#1/��#v�>z���t����x���]!���h�G�~؅��_��"i��A��L�2}����ͅ_;R���Ʀ/�1w���%7�}iݖ�>s�$�����Ɲ(�~\E-���@�ƣ�p�>s�~9�P7f9}�؎,&��$XI��H�75}�!�Y����<��/⭇�-��H�����p�ð���s��I�Ʌ�X`^�bی΋.[����ο�g�]ș"�\b�����k��n��u��u[ܖNV�L��n����͖��N�T��r�0��	T����G��s���|�� 몿T&/fXf�,13���������3׾a�~Ep�(�ʙ���*''���$ܫ�VO,�~m��'w�:J�P�����~���}b��u:�Ŵ��Gl���H�[��W��������jT$�#I����w8�C��=>o p��@䩊̵�EB��
��/��D,3q�t����4bP<<�H � 	m%�����ŸN��~[�y�~���U�o�p���'�}J&�\�X$Xh0��yV��˶c�\�E�p�QV��A_XM*����+|*�Ȟ��V�~a�B@:���E"�F �P&�P~ƒ�ab�����G��*}��3��W�0�#�wp�0,�!I��^u����B���7�����M�H��o�
��"�צ�@_�3u�� �t�'���+�?�o9�ܨe�'����-�`��w�/��\:��°�`��W����vg秄QƆr8x�"Z�M.=ܬ]�����Z$@K�ɭ���j�U�V�Zf��._u����i:�����@�곬N�O�8��(��y�Z$@K��e�{�����yg�K��I-3����O�O<xVe��cLoRf�M�"Z�An4ܤ���g��/n!� ���:�
�O[��	+T���-s��X9�H�V�ˌ�]���w�x4��V*q#	�Jr��&=�:}��¯0~��֑г��u$��-s }�.=���
}t��:��,!7q���h~������E"��|��"�O�@_رU��_Q*@�ӆ��c���@��s���{y�~E�k�:@68AܭU�� N��s�~�M-��to��VЭ�����Oj��c�ۥ�,�1��L�7(�㯃D�*Ɨ��m��"�G���KY�
��zt�'�}�⭂ݖ�2ӯ����4�Ű�V�×�H�ķ�����Ы�gg4�"�ZO��r���4�#)حl�Tz�ނl�� �=J?���v �vq(�H�.��/�&����+>?wu�~5�/n}C'��;�E"�F@W������}�<      \   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      ]   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      _      x������ � �      a   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      c   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      e      x��\k�,���]g��;���Qk���c�$(K��t���P�	��T<�Oȟ�	�����������k��1�ɰqP�'eJݿ�*5j�(����a��T(���a�^�5m�D�J�;��{Pj���0P�'%J�ߴ3���4�T[2�Rϱ��NS�kH1P�'�i*�$��$>M�w+{x�d>O�7$���W�mN��`��'S���7�Sl��'S�ϡ��a�ʈs���a���{��L����\؝R�7�kX�^��)�~��^�O��Zܷ6�_��1M��k���ba��o�|1ߪ�?�H���T#>)��n�cVm"�)t��ۿa��4�S�S\�e��������u>�6s.�0P�aK�n�%�)V�6s�h���ĵ�sl�a��^/i1���*m��z@1��8��:�z^��n˰	aN;��ݦxP�v��sl�a�ru���6��:u��)n�u��?����}y��0�z�P�v[�رg]���_�׆Uφ���b�b{udC�t��f[�XV�hX��c��pk�11�R�h��bMC�����-/100�)@��V7���:�8��l��l0ja;�5��zQ�O����܀���7����_U����)>"h=�%6X��3���Kj�R:M!��0Pw�[{3g��U�?��֬|�p�@�Ŗ�Mg`��3�f�}k��nc�|������baxo]���8��\�궬��0�>��v`�9�K���f�."\�ϫ�9�K��z�wuq�t���j6���̹��էQ�a9nV��<n�;���{��|lٛ�^��"f8�%,���<˕n`����A���=�a��O��6���ylp��|`��{YkV���p5�"vkZ�ugɅ��mt�0Muuv>Oq�K�nO����ʺ:�U�p�|��B���OT&s���X��t�Yr#n�Y�t��3#��ȩ���7�RG8�.�Yu�nu*ͤ�fe�%U��y�c��|�͜)�:_sX遁�N������cF0��Қ�%�50Pw�8���R3�^B�KC��n�\��-N�jx��[Ϥ�x�0P��C����9<�syoj:-��גo:���<6���)N�R}��6�1��E��%>֣ΰG�}�u��a�{�_�:-�Ɯ��NK���~5�S0��8��yHfp_ڰj�״�8Ňk��z���޽V�;c.�k+w�V�S���cISL��jȰ���@�d͖�����d����c�ϯ5+C�]%=c��a����U�*9\cм�|U�#-u����Hp	qd�{� "Iqd����)Z\�jm��*��DD�����V/�׆�*���늆�*��c�5j�GjX沴��*�����e�z�����U�2Te�-�YM�0�:�p����^b�k��8Ұ���$�U1��ҩ�b侶�t:e���Nlkz����5� @������@�Fq�i:�4]h����!qM��T�)M��-W�0P��v-�r����N*�6�2պ��a��c�ѕS{��ʈk;���nS1�*j��S4�:b*���k`V�L��ؖ�ؖ�Xr���iR���%h)ARXܗL�� �׃���m�̅�չ\�y$+���ǳaиO�w��>�]��w�����w��a����r�E~�G��}E(P��j�IjW��m�j��t*��6�!RM2�R����$1W��00(:�;��*���$|����`J�K���)�W[��
[=�$Gp�xbf&x�G�>Ef����RE30�J�X���A[Qɵ&Tj~hA���z�w���0I�aө�����]yq���aJ�o��kʯ�����a������z��}#��Ԭ3Rҕ�ޫ[/�m�?��(�@��J�[�0��R�K�=G�mq�T���p�S)?�^1�,<Z������p��D肑ˡo=S5�f^Ю�.�������CD��!5�6���iJ�T6�t����E��1�z(�)y6��<��f��R�^�0P�8oj3��7TU�v2��5�C�Z��ꩌ��!�A�����ͻD�@�Ek����0Pi�Zo�tj� �B��Er`�`X)���=T:��f�6���Y��ֻ��O4챰��L1r ���r��̫2�W�Q.�r5��0:"������Wm�'��	m��J�W��ne�Z>;���׌�w���FD���H�Kh�:�a��2��A�WN�z��j��3.�b�[�^x<{�>]�}Hk��:d�,�fLRc������00E ޔ1gS�.�30�e����Ie��phe'��n�놬��P�0(W�b��h�|1O���ic$��5��Բ�K�3k�u�m5�{H"ׄ�5/f2���H\�f`�Ue�k��2���*�5�00HO�[k������c�Od�|��W8�ǀ���Ɉs�,��Y�t/켓	uo-M�R�[K�IE�{'�׃C���Qc�����x��������-�s�U0���u�*�py�G�[woN�AfP3�I<�9p�q�� �Ҏ�ϓ�g���]���\�D��9 S�=��C~����K��k�70(OR�|�ac�Y6�i{�AR������[�7m�DNd����+/�cRPz���O�YN"�`��<��ۚ�ĳUJ�y9&�r��u��UN7Ԭz���L�@�Մ��W�vK?�H��O�����m����0چ��ȂW��<�q���0\��_���65=D6*F�f��o���J�`J�+��3�w�L���00�|���6���.sy ��d�a�R�X�A ��Ӊ\��a���e�.5��\?jxS���g����z��WX{g�\Bb��u�!�,�a��9�)G�]:�s�f���0�"�R[��a�ԃ����i���`m�{-�^e��=�rߺ���>\�/�.�<�ǒ�*������fy�u����愓���~�_��*�ARq�'�a��=P�Ŝ�y�w(��r���R�vMu:�a��ŕ�����\$�c$�b7�GBC�lٍ8��($�9�Dᆁ*�e�F,�ވ�Gm;��K9�5�#�հ��#LZ��{<�^�|��0P�~"��Գ��,��m[��l��eMu*~���IݕDG�${^���	(�l�ՙ��(N
���0��#frj.&��10��A\�0�Z���fnu{TD}��d8j�b.Dh(ݜP��{-dqJ_�r�x�R:�z��Qt�jS����w��7�A�!�M���0�F>B�Bf�Oü��GHRș��;�?�_:T��oH��JwMa��v��?��p)5�){%��=y�qY��=��Ǹmc��5P�d��]�mV6T.5X3��ˎ�I=�#-���{<����d?5�J�:|}�a`
�������TB��K������43�J�Y\ҍ�O.��ۨ@1P��Z3�;�*�A��\h��E潱��>�s��o��
nӽ&�kz�e�˕���L����3fZ=���Y3�W�s�L������`�����<%3�-�	�yI�7���~X�&��qb��o�[�N�5p���C+�nY�.��_.��zښ�1P�:|�?���G-�7D>z�B�í��}��@�n�I7�r+���ʍ=VU9��3\��4GnGxoF�C��W�퇻�I1���%l0�`��ß���%ӏv��f��uMs��H���<$������S0O:�%�~�����1�^k���U�GZ��>�6Ԩ��C�@M�ݽ��@͚��Z���v��N��:�v�ZV���GA�WN~�ꩩn�ꥨџ��=Lb�\?���0�iN�|�O(wz�PԨ��z�j��y�xa�fE-8_�ES����@]S�ى⅁�*��sza���:=������އ�$6�M�_��q�U�0�����9��3	����00�d��/�"�i�$���%�R��䎸�����/�S2���^���h��%��∛�*���?����    ���RGA      f   �  x����q� E��*��f$�0��T���ȅu6�Z�?�#	�,�I�23oR���<5=X�>�y*.m����,{N.LM��4l�8�͆$��fW�@-��ѯ�]�ڨ��-S�}K���9���l�6�|���l��H��q5�ܻ{d,_� �V�7��!�N�����O�8���F�5��@����g	}'��\I��|EC&��!�$��s�{$���ƥ�5��!���K[�{Gm&�R����te��C �W���u�7�R�u�4�}���m3ڔZ]e<�W�@�����!P�U�X9��Хk�V�!���,*.Md@�ϰ>4�����|:qɰ�C��/Y���wHZ^F^f�����Nqź�u��?���!�N�鬎��u���&���a��ګUr�k����	�`��n��_���N�?D]��ҙ~
�	����ID?Vw      g   ~  x�}�Qr�0D�3���%�e�e����8�Dg����.@��XD>�>�h�*�%�S��>��L^R��
e.P#�kH��FzR	����A�T�{H�\�N"С�2y]$g��R��W�|KM�ϓ#�u��j�<���C.��g�#.v�6�S�ϳ5?q����>o�y�ϳ���R�&�+A����j���&���1J*�d��ϧ1�H�a��)
������=�����֓�T� `��GI&����I�4����h�M�������e��.��I��r�FK!M���+�����nL��`�X�ii>76R�!�+҄�$�6������T��8s�[M�CH,�֡v�5�R0�D�����I�n5���B�|�F���N��q_ ���Y=�C0L;���!�V�k���d�XHdŰ���'�`D`�X;�[�O��z9V7ֽ��  !�1����ȱ6ɕ�ne!�5��k�qA�(�M���D�7��a2$Mn7�K ,����`�K���r�#�B���(,$�/�`�VVi#,<(=%_t���\ ��ԡE�d���p�_��Kn��}D{��:�y!��؈�������V����Ν��v�hD`S�I���C���Ӹ��� Hu�ƭ5nA����7sA��8��jX��w3R�h�����N��ָ��ܘ��f�zik�����=�ƃx8�ǚ��N���%�r8|^(��y8���fȁ%}��n�m#�O)�J������6�`*��AШ��9�� 8��٭�A_^��Sb9����{�)���vV����,��҃��qA*�d�Љ�Z��><T �p��hj�+���J���K����s�u��:p��4?R����"�wE�Ւzɗ��|(z0$�<���T�i܎�f)uke�Ft+�a�񫅇�HH�cM��F�(����?���e���ą�SA�i�$�9�n�F#�X/��}�� H��4�Tiyw��:(�V�n��NI��vK�w��ޓA�*��%p3X�xR��am���������u�b��w��_ut}�޽WA{
��������vWA��F-G���!de�T�{��G�K�E��]ce�����z��9t�      h   0  x�u�ۑ#!E��(��l!	�G,�{�ٙqsU��:FhI[Oړ$�j_پ$�$�|�Z8�tH��)ʩk�F�1�h�^�s���E���4�֍ipzi������_���m�SR����f�9u�����8�f�&T��Z�$dp
�����)��k}�6�q�M��3�M���Ғ����fN��p4l�ʩk��ƹܛB�VQ���`s�J5�r���[��)4@�$��&y-0��[�f�N�Ca�pj��ߩk�6
�g�=���{j���s��7 ��&I��[+T��C�Z曤OSN�IZm�< u�=��[Q��rѭ�`��e[����������y������ZV����֛�
�p���xS�hA@�E8�����<�ҦЂ�3�}��M/㋍�F�߼�R�b{���,
�E�����>��{��GG0\�:��E��_R��gD�e��Z�rs�ڱ���q�ڱn;���R%DI�i��>���+��JFs�hۜ����WmQ�I#�}�_ԟ���v(��1��&˜b+ϴ��KP0�38E����;���%���纮6��      i   S  x�}���!�K����$v� ������6�+f�î�W�>�KE�%���S}�1E3Vt4�X���p�Ռ���Q�u�w�Ǳ'c�3�S���a�r���t�k�)=cp�;�8
g����N_���%��bU���1�̹��{VL�M5q��y��~��tT�=�Mq�{v�a�u�gv�a��v�g��R�MA��a�l��џ`�[�'=��S��~ɾ�`phd�18,��y��w�1g1����I��������ނ!;�>��{�f����-�>8�=�u]s�w��u08�}�aIr-ȵ���܏�-�.��H�g|���Ot�����o)�q�JY      j   -  x���ё)D��(���@��E�����`$��zE/�R��j�ϕ���ߋ"埑~��#őڠv%��~ݮ�҈Z7i��\]!����iH��C�c	��M%S��N����YI'鮇 �6�Ф���+-iT�IC��_o)��?R��gw�yP֟Eh�t�����X��i�~aH��B�!E�PF��W:iH��$���J��jv��G�f���o�s���ߍ�bZ$�s_Δ}�[���5S2�L�G*#Ӡ��,�fW�Qo-e�=W�eO��B��X� �p���2��ۧ[=���2�S��҂����"Jte?Jɖ��)��)�T�Y�b��ׂT*Z�{m\����
9a9�HC���nU(��y�e��ݩP(��Cc+��V2���Ep��9��δQT���U�Rr|U��QUZ��Fq����k�n�K���+W��j��+y�4�hS40[us�H_�P��ec�8 �����$�o�O����Qu���lb�[���tj�H�d���N&�h�B7&�}ӳ������ǅb��XǈĽ>.G)]� E,��2)'?�8�Uc��ˤ�1���ȃ�`�h�B�t���:��1��Q$����2N��R(&=8Z���ͥPH��GӍ�o��"����d}ʄB�m�J@�h��/6���4��ݓ-((�IlF�q֪{�PH���ױcV�h���(p5HIK�BZN�|��B�n���u�a(�By'���L�x�}��Pl�_e߻�B�(��������Q(����Z�h�d%>w=�	N}=1���q�+�\*ʖ���]�;�;��!z�o�ŗ�:�A0K�(.�ݱ3�>��d��n��e�*�ܢUun#��v����ܽv'�s-4P>�,Õ��m�4I�;�P��j�M�q��Ƿ�y�l�r��߲LS���u�
�|<L��Ȥ��H��*B��m%�i1ީ��|����p1����ӏa�&��C�JҖ@("{HȦ��P\*1��J���Ы�\��C$4�vz�yL���vj�������R(��{�y��ƣS�r�Y�f��#4xW���G�)�m�g�Ti+f��?}h���%�����4BaΆ��h=e~��W�b�Z�h�y�r2�}�S��ɠn��L�ߧ���aY(f�Gۓ���F׼LWe=1�z�7�U�k�Z�����^mU(,���i����B��ge���P(��ҳi��Q(|�}�=��(��R��OJ��o����^����F����qh){�\�wK�tK��[/���$�-%n|��=[��(���F"^K|��l4��'��7��-      �      x������ � �      k      x��]]��:�}��<�z�:�b��$TB��4�n���H�6=��i�m /��R�
^)��f{�c�$��4>��}V�����]%�M8D�<ߪ��o�՟O���3�$Nď8��O�ivL
���c����>���׿���~�������$;��l�H6cO��߫.z���";��^v3��uY�I���� �#ϷO2��I�5uS?#ٵ9T�|�� wY[�M��ս�c,���R8�3��:���A���9��0��9�U�!����u��sЅ3y2�Tѣ~R�5���r�,�1�EÐ�\�L�~�4�U�|O2�Ȥ�����1�G��Ő�H�0�OɆYӔ%�`<�x|$�������cl���^���4�}�vX2�,F,���;ߣK���[/�����c� &C���M� %����{��(�[3�.��R�e��Oѵ���PI���O��&%�bD�aD�{�祎��ك����ݳ�5x��T���I^�s�Rd�T 
�>���:�C���t�N��˔��)��1�G��Z�Yv���]��T�M{�f�ڑlz}�:���ϣ�To'��u��أ'%�<�/�G���ǫ���U�팺X�H��\I|L��iqL�"���7�]�	�<��m����q���?�Y��&\7�~NX�&O$eD�I�z�k��C1�Mu"�����h�U;HIo7��<NW��J,������>�aA�����,r1j��������"e�L��-;r��%#—�tڌ�����u����ݩ9�؜8)=ƀ-�J۠��-⹩䳯:�\�K�ZL�k0�;�s�xZ�uC�>�u=ys����li沑;J���lfS��$�[$�gyiٹ;-׶�g���Ycؙe�s���Y\��#��I:7QF
�K�fĥX�zF����L_�<�L�&��<��)�N�6�E�h �o���n��p���=ݛ1nu�p<Aʾ
�lʔ;2]k�oJ��zG��g���l���h�az]�e蝑�)��є�T���3N�ɨz�h�5?��I��U�B� ������؇<W�3�{��|Ę�����������'��@�����C�\�F�B�V1t�e���y�dW���zg�g�ۭ*�F�\�Vs)*�������3�x�V�^�Ӎ���o����
W6r��1Z��>w���U=�+��ї��76ؾ�\I�
�z�"O������նl��{$(�����cǞ�z�2^��\5���,�~=�P	8���r=i��e3lb�P�Dp�mX�ސK�xM��"n��D�aB��UN�)H�����ʌ�=[xs˘jY��1C���e\x�kz�%z�Z>)�VTu�#ʢGìKC�MN�D�q�Ԉܝ��Mߐ���3K��o�e*�(�P�a�x�&������� '�NޟcN�I�Us�f���l+�D�ԛ�ݩ	�N��[Y�$)�|U��4��`�)�L�l 8e��vh�M.a0;�0�f����l��pzs�<K��`�Cd��7pE��n;�S���J��|�ӝHO��£>^���WUߑ��F�Đ�!��d�ҝܣ*b+aS=�M�9]�H�����-�ΖTk�I����I�!ʮQ2:��	��B�CT��!�Ĥ-:$�����L�[0��xۯ��y7��U]To����PZ����|�������V�s�;L�zts��|m�@.�LE�uS鷼�v�2J���>��������~���������gz�J^%7���6�Wdh8Ԅ~�bR桺���:��ic0C�d���1֗�o��+(���3���_)�#'<RW=U��9�F�5Aa�R兑�z|XR��Jf�A���4}�W��Q\,�2�c��G�Rv367����F��:�j�Ī�pk�%��c�Bg�8�4&���UUji�͟6��jy�'/���̎݋����Έi�� ��3O�_�I�%��;�(�R�?^��򿒍۫���w�WO��Oc���3vn�VI؋}���f�Ȇ�Ro��g� �Ӥ�`�2��V��@��v����:l`�T��(��:|����M�BhJ5	�|�i����EX�7�:�D��rv���VW���j�LΚ}�Z�Z�PB�b�F�JT4���˓����H5U���a\;�����|�Ic⮚d۱oV�<��*-���o=5����9$�]mQ�:σ}��O5�R�u��tkF,K���`�W��������*.s�1z����8AN��ITǍ�\`G8	���[�ŋ2�$����ʃ7�k�Y���Y�X�/�8� _�~C�d����U�[;\�r	[��|~�Ig �������5�e�՟r\7�L����L�f3.���ny��q�˨`�!��;�\r3*\d�8I��!��lN�Q[7!�9��AÐ�pE�V/����p��l��
 >��^?�g���%v��o���lj���I�Q���;dФ�>�vP��E77����@�{'WY`Ȑ�]��i�˷6�f�pvX����隵���P_�vA����5���)�C�������n}^k�.g���m}��)����){T=i�G{��dlݚ�
(S���,�%�������@a��g�4�}���fÐ/g��1���Z���A�2s����A&�N�-0d*��l�|��ÈBLC!3Ru�}R��5*~�����vM�_"E|Hi4��z�ٶ���Lʚa'p���',5�$���	�yǖ.0|��}���_��=ƾ�;� _�n0Y`�'�G�=(Rz�jS�Mv5Ʉ�����w�!o�βVw��ͦ���\�nF������mw���G����{�w��"��Ԗ�s�E9&���*���o//6�W�e���X,0d-g
��}M��1b�������!1�6Fw��]n����u����;���i��i<��j��7�V@�)x�j�#|�I��ʮ����]*Z`Ȝ8$�Q�{� �s@��!�phԺ��`#�Cf�zٍj��	�Bx�	��';��U_�]���Hl�=�ǉ�'s��A�|�;�΂�{��0M�>���[�v�P�ƽ�ZA�^�2�b����a���;^]39M}x�v�@x���r1����C?n�;l�B�>QR�4�~=�h��^U; S�[�)�Ӕn���~fX��+[j?>�gjϷ������zc��[�X|����)ƭ��
�γ���^°��0��z�ׇ�C�u�i3ĺe�j�V��]ݙ�n��j��Z)[	����g]Vù�x��l	%W�B`CN5n:2S.l]�Ȇ�1�4FB���/y3��Z+�c`Ȕ23��{t�W�%��Bq,�
�140��!�$�����9k��*
ZW;)�,�OI(�����Y7J}�m;�'�K��%�{��ޥ�	_]yR����jٶ��z�oհ�����9��=(r6��f|��n���Z�J%���F\|&�U�ߧ��9Z���`O�+�{����:��_���3����c���C����|):D�d��{tD

Ƈ/��������aA�N4򦬯^d�#s꽟rp�0�H���9C��;X}�,`�d`Hyp����aN��-<�3
3�L��3Ŷz/��w����ܿ������O�M0����-��d����Ulݲ�vO\lW�,�R(@Κ����G_�x~��vs�#0�V�v=:��6�#l������gf�z:���y�����,�/�_�~��������M� ۑ�ٰ���7�p��a!^�#]�t����X�K}%����kus�ta`șo�z�C���`AY9\�00�-�� �P�0���U�=���	�.����UX,^w7\vL�Ze�P�M�5��C
�����;R;'�&��t�4�⁃�x�L���
?���������;7��z�iP ���p�V8��م�n�!�*�2��
)]`�j��i���*V��dJݣ>�(�1;����zr��s�"A+��=I(��_�SչP�7��r�L�4����jS��[^�aʌB}@�aDI��$���[5��@.|'�2R��XuW�1x �aE�V����޾�CR�o�� �  &u� � ��N���]�wL�c���o
v�(c�T��9����>.�+"�=L/�D��^I�T?�/|�N�/����f���{���v�>�o���Y
F�\*�mեu�;|��>�A*��n�#2�g�[pN(�T|*Jt���ʗ�T�u,~~Um�U����|�ͽ���:R3�n^�lhrZ���qyR�׆���S����<YX�|3hÐ�� %��0Lwǥ�Ħ4��YC�s��������7g�0���{��^�?5�<�t��uӰy*��X�C��9�>�?���c��id�T�30�R�`�,n��;ի�d͝��@�ɶj��<�/v:�a�	�l�$�/����v�EU|_�z��<��A�^Ǳ`ȑ[%��Eެ#ss�5Uj3WS���Yj�yՆbz�;M�;M�w��W$�޶aO��)�&6E�D�R��H5Zs��M��
s�����v��s�aȖ��b�3ѳ]ĵah�r����3h��~��w��� ���[��	�m2el����owr~y��N+�<�DM���^���t��g����Ԫ��b��mb��fl}+\~8�a���f�i�-���)��ah$����Df�����6�Ulg�w(���&�Z�ٔ���o�#kU���/c͕{��rv�,նlG���z;��<>#D�����<_%�k�svC�vC{��0	�F�KO.A>+�-l�D��Q�q��[�n\�^��|��a�X����e
Á�Z��`�<���J�邦�fW���B�����sJ��ǑuB^�_������L`�nU4�_6o�뱭�R6�j4��3�IQ0��n�l���a�kL�r��>�?�G�~�t��$�c(-=x"��<,�U=3�ٹH�1s��:f���U!j`[%�c��C��	���&���,�`� ���0��	�%#�zɞ52(_�] �a)d�c�K� �`�p����`h^b6��m�н��A��]�y�����x�P�5��o[04c1{���N���w�e�
�{WR��M�ڹ����xz�P
0��� b��Ḉέ!��y�燍�������ڃ�'���>������Σ���O�9���=�����r۫�vYѭ��b
c����s�G����]�}'�-V�g�T����Hfmru��-7��<X]���Ep�ck�g��1��ǽXn�l�a�:K'|��q/ZN�>�UY��8_�?������p�      m   �  x��Zۑ#+�މb�-$�� n�$��F��ڧ�_�������_9���r>(~R>#���k��1*��9�a�FT� I��trٮu��\����N�k�d����Oj۵AR� ���|A����6H��$۵N"*o�G�G]4�eSOگu5e�l]7Z�S˹���p򺍭��I\�lk�`���M]�k��9�qQO�$:��!���#��>u�1�6�|��I���)��������S}R<��!|Ϗ�,f����_��je=dq����JCg6R�=�m�p?��zc�%�?ٮu���֋<%�>���īAk������^�`��7 �@.�����~/� Ձ�:�=D�� &T�����/��*�P?p����V`l�^���ADuaP7H�z-$�(�VHh0&�vOh,%�jL�#eԑ
j��*1������7@�P`+��\�p.h8�
�������f�h4��Eߞ:| �Ѳ�ݰ��g���r�H�����Js���>����líq7����*�z9��mH�p�$��xٳ�~t.���$ʅB.OFğ�D)|+���
��Mȧ^h���	WUM`G.�}�A]�-�宫�H�%؇�nd�+Ӌ����Q��EC�F�ֻҔ��9��e�+�$�[W3�|HUV��SV���6u�H����BB�!2�5�*�mL$�t#�v��	�Z�y��#T��I�8���l��Sa�c�}eM`�;6q��U#&�|�/��'z�$+�l��tŞ����$���i_��~$��&`Ja������z/ቴ�k���=!�C�����Q�P�Ӎ���,����,��f�0�Ӥ);30��qi�(8m�#�%7��	��?���$�8���K��C����S;��Q��M�h9��)}9hq���D5�?F�U��BӚ�QKp|tmLg�-]�{E�U9]�%�#ѵ����ܼ�rD���ç�3�@�hKZ�V���HCEh`�(��,�9�e8P��V�l����P3��;�U3:�b�ft�(������&ν9��>i�;.o�����ץ�.�wW�r|��S���m[��^˒��Q&�b��h��wM�s�,y0�u�6Ai�v )�U�/�`<�y㑁r�0:eASkDE��	i)�!G4��Sa��\�j}����1:;�j�z��T`�q	|�Uԁ��ޞ�=.Ɓ�n��^?�m�hQ�Ky%��!���e!�ݸ��$��Sղ,-�;���E`'`A�����ڤ�9\�	�Y�x���,������{y2� c��x*�ꪡ��Ȓ��)nOq��Ƹ�S c�� �0�(�4i�u0F�bMAB���A��"5Zغ_ g{{+��Y�e��'������^�t�f�+�LZiĿd�@T:��9{ ���F��4"�
�h�������6]�m1�x˼f�������G\�L���^����������&��2�#�҇w$��N�b9��6��\�ҒyX�������η�qr){��ic#�(�`��g9*��cq8��7����J���cL7�"�9ѾZ��" ��px3���B�������vK�e���nE
��#\fwn��s}�U�yw�<υ�4�ld049��e�!���A߿N��q1W��������������"I�=����X���������������      n   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
c      p   �   x���1�@��7�i��ݍ��ĕ��D���/�#1��}/iN}�fg�mzvu;�#�,��8Vr*!˅����	�g�6�W���n��zo�7�����-�1�0Y:%�6��F^��q�܈��4T
e�2���U��o�/>;      r   �  x�}�]��(��˧��a�����ϱ)ٔ������od�2��>�~�������Y˹��ϿL�F�@>(��m�sO������[������[�A ��q�Y3T�F�Hv����<�����C�g&�d�6�,� *oi�?%y�q�D�A��7o'�.*��qg�'��@�h�t�ć� $��)��2D%>��;!Tqĕg93Y�� !�ˋ�� :y*�[�� �1hޚ����TPd�&� 1/9D�AdBT�=!TQ>��`��&� %^�W&����O�2�DSb>Tш�A�� H��N��d$�0e�zL��:�H�G2U��
�D��d��	Q������ ��(ge>TQ�^	�A�A�=&�M�b��TX<T�b.|��ګ�V*�A���*�]�A�:��u8�Ad�T�4�s5�uT]���� H��T9Q�8��Ƴ�Y��v��At���v�ARh,*oIHo����R�ܟ8�O%&� ��f�T&�(�`J�Mq��\'Ar��Bw�d��`N�Jv&�W&�H�@���0�(�X/1��J{�� �@��ATJ$�W&�8(Q�\b22-Ն��*���G�>���|�l���9�^�5��u��S{��z� |�/S�SQ�^�&�)��1WS:���)���e*>S�c��_�]�G]G���	Q��>e���C�-5s5�i���2_�)dɔA���8�ON��#�>S!d�-�@NDu����5e,�=v�)�h�TSӈowS�)�v� ��	^�!L�R�)N�)� 1O(�Ad���	?!����SA�&�#_>*�!$&����;\�U����$�	��|���v5	��\d1��L��`1�TbO5X�k|��2R�0Q��Q�;��:_y���eW�&�n��<W�ř2��"a2��
�t����Q�_�u8�A�xd~r�"��Jq�2��f�����d�a�O���"��9�_M�A֑i���Oȗ)ܡN�9�§��Wj��M�r���L,wM�b^y^U�+��%xUd{�2�B�F�A�A�K4�:7D%>:��&�8��~
[�� '��%9�x��)�`���`� ��e
�SA���P�ΐ�\�&2����GIt�3�����A�������-�����&����2�L4��^䒼2�p0ѕ[ya�x�<e,���NS�C�2A��+,���*oYX+}+2�`
�SA��қ��x��G�q�]�Z�s�A4��=ޑM��~�DE&�[�%軁�[�80��:��A�%�ƏΨ��D���E���� �'��0�ۏG!�����ATB����A��?D#D����[v7,��&��^D"D��#��>�2vߞ��e��dB�B�S�;�GQ	�|/yd�G�i�!����<2�NV>x<��A|?�>��ב�y�� !��[��:R���#�(q�e=��-�����ATB���Gq���p� !��|�X��s�ABA���G�s-����]M[z�E/Y@tJ��w_�h��&��Uڵ�J_f��vjm��u$�Y�Kd=�
��@T��WO4���KF�awY����0�k���tO4��71�j�F��W_��u[��AtBw~�d�U����*���%o����_��o�5�}��=�,�E$Dp}�Q�����A,�$����Ȓ�/�r����%R n�{e�xO2�uQ��e���%�ޅ�.���ǡ�ȝ��w��qP��%����b}��%�_�N|����EX^J��~��˫c9�_D��32%
[��PD�u����@����H���0��=DPt��'�sک1
�xh�\^�ġ��������N]��oY�K�L,��ђ3!tl q�2Y��8�_�,�jsw�^b��s�|�Js��+�D�c�/���,I����M$�}I��i`�IOLvkP�)2|w�%7quj�N�!i���WM%�n]��/Q��
F�H��"!K0�E�/�6$�xb=9�7���U	��_�ez��"�H�X;�� 2%��Xd�c�u��[_�ش�b�>�R��B(�>D%�ZQ���oB��u�ϞJl"Á}���"��h��� %vB}���?۶���Nk      u   �   x����� ���)����8�.̈́,K���1����k��问�����(Y�������c�t恣I0�f��8C@Ղ�7�(
q6������qEr��jM��&��z��Е`�<��㖄�r{�k��� D��y��"r��D�E�U�c9����i0�@TZe���/�sU�      v   �   x����
� E��W�ʌ�sא>M(�nK骋����@,���l��p���$��P�*�i��J��~<�HC���%L|�����C���<�]�d=՞��љ�S`��i|�),i�oM������כO��c��x����1�]di�h[J�$]*�V+��i��X�Q��v�)��2�f�ΚW�� M^c�      x   p   x�m�K
�0D��)t���;ǘ�BMȧ�����,+	�y�7ǟ(z�j��5 �A�Vޡ�'M[a�8���*\y	1����l{ `8�m5��N������>_p������3�N'      y   v   x�m�;�@D��S�F�@H�Vi@KB�?Aۤ��4c[���Y�fs�,EN�*h�Ӵ����yG��yZ��In�z�V�&~uh�ӐZ�F}��W��
M����{B8 U$�      {      x������ � �      |      x������ � �      ~   V  x�=�[��(�;3ǒx�e����"��Q���N��x���g�n�C{���6h��hmk�o�fu[݌�W�+��J|%�_���W��6�&�D[hm�-�����B[�͋��ڸ�<<���@;�U�;w���&����-����������=0u�Sƌ1A�ü0-�
�0%���}���������6ތ����f���o=�F/Mw��������a��.��{6�ݴ�Z�l����l;M��>W��z)_ꖺ�@K�V��o���;��������������������������������K|S������iw�~G�z��pa<�]إ]��i��ݱ�K�%�z	�L��$�q���E�/�K����	�A$Bq�c��ڠ%(���`�?�,�GK<\�/�{���)�������9{۠MڢeB�	�&��l����m���/�Jԕl+�Vҭ�[ɷp%�Jĕ�+!WR��\ɹt%�Jԕ�+aWҮ�]ɻx%�J䕴+qW��r&˩,粜�r6��|���&O5[��R͖j�T�����ۼ��6�6���~��nt�v�����m�x&m?�����բ�G-Oc��bBL�5��A�eb�[�LZ�Ll&6ӧX��1������by�L<����$d��X�����χ6hQ��;$C��;$C.��B��.����R$k�,FT�j�
�2����H�#/���C�L�3�ϔ>S�L�3��;S�L	3%�tq����k� ��O��>R��<�<�<g<G-'|���CI8�9����!���ܣ�˻�۝��
(8A�l+`"H\�q%߷d*/S��'h'-�"E�VZ,	�"p��\���:� }t�!QĢ�TN8e���d�������$�'�A�/J~R��vt{�|������.���by���u���3V�P������+�a7�ݶ;vz	��^B/��P�B]�KGHGHM��H-S�r�r�r�r��K�+���R>��C�P7}(ʇ�|*���N�.f���r��٤��u�4\�pQc)_ʗ�|)�ʷ�|+�ʷ�|+�ʏ��(
�(�r�)��8ʏr�+��0��
�(������t ���_)�t3gi���_�����9�q��Ygi�e�%��Ό�4�Ҩ��K*7��X*vy��r������K���N8�7��w�c	��s��Q��T�������Ա�
��0��yL�:�{M�a��u�錧a��uJi(����2QiD��FTQi,���A���+��E���N+W�\�r5��(W�tV.J���{P��<�� �w���:P���sRN��8��ɱ���l/d��d�rA|�D�ܻ��I-�Nz��l���+��%�P �?�'����}�O��=�'����yO��;q'턝�u�N��91'��{�M9'検��q"N�	8�&ޤ�p�m�M�	6�&֤�P�i"M�	4y&Τ�0�e�A�bM�	5�&�$�@�g�L�	32��O�D`�5�&�d�H�hM��3i&�d�(�d�L��1)&���E	")��4o3q#��K݆�̽�[��[��[��A�/�xo"f�,�%�䕸�V�JV�*IE~��Afd�Afd�Afd�Afd�Afd�Afd�Afd�Afd�Afd�! �x���Q6�F�(��|>��|>��EED&�Dd�h��+:Z�*�X��V��ٟ��ܩe�kB�	����:� ��
?cO��h	-�����`�KV�C�c�!��]��|Q�M!�3�<��wv�B����a25��߶����Y�0�fQ�,j�E���7<�g����y�3ox�ϼ�6̢�Y�0��,��E��HZIK#im�;��3�4E�_�͕��E���su΢�Y�9�:gQ�,�E���su΢�c��%+�ՆQHH	� !�$$��d��LnJ�+N��4zg,*0�����&����S�ϻz�R���`�rI,I%�$�D�DH�HqU�j��]#��5n[�pa��F���F啔��_{�EęY���6ރ�f�w�E(�Z]��jm�Ҫ�U��U-�ZU��jMՒ�U��S-�ZM��j-�R��T��Q-�ZE��j��T7��Sw��S���N-�����Z>�zj��ک�S+�N��Z6�jjє����������Я�         �   x���A
� ���x�\�23	��P&�m\�#x��.
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x����j�PƯ���/ࢿ�}n�]�A�e�P(��X�d�%����,��\�f2�V?�ҧO2aZ�Mپ���p�ʺ{~M�oO#sMT�U�Y%+�4�6��@���n�c����ݻ���G�p��H�T#W�Yf��2��--v/?������8l2K��S�Y ΀�g\���K�[?������L��y�7J&3�N�6�u�K��.?��S�ɘ��+�`B`O_�P�ȏ��D��=G	�sO0�6tpΩ�u$j-X�Tв{�e}+��b��_�����<�@�kc��6V���X�kc��8�M9՞k�W����1ޢ@6���`<�4ۈ��H�kw�3�L��Z��ݮ:��Ӏw��ޑ��މ�T�!Oe�&���7A]]��� Q έ���I'�Ԅ��ğQc��.%�\5��B��<Jء��ۄ�\,a,^�qr�L���4���[]&02��GZ\|�����Zkn��H1����� �;sR!      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      �      x���ˮ-�������j@�Z]�ðQ��7��0l�@]�ߤb���Ę�6re~#B�(^~���o�������߿Z���O�O�����o����?M��}��_����?�����G�? }�?���.�?��������������1�cI��e�=ZF�@?���_�S��?���sA�ZПZ?P��������_�������������뿾��O���#b���b�h���*T�Q�i���h��>����h)�b��G�{�f[������]r����?�7�������U�ı��?��������G�7{��~����՞bǃ_����Tmc�x��xX�t����_9�A-{��_@�SЖ�����;��Y�&�O-o��=@w@�(����+�!�U�QB跑�}��W�TnE�/�������*�)����FR���?�ގT��/��FW��  ���7���­�_l{0��B���?�)<	�O��`W(�p�by���g՞����ɟdi*a�5�׉��#��mƿ[��<����v�;��%�:}���Oo��_HM!������J��	��J�7 �!������$�C�(�V͸��P:�/0��As��Ä���yN����/W_'����b�I�-��jv�H��;-�
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
A�T��V�n�8w�̆`�8����4v�&�^�����uV��reJ8��� J�|���{�]�Gh<���~KA���F�僊��Δ��,}9������poR�%�N���4;v��4{q!����\:�N�x��o�-���9����f!q{��w.2���Z%{�`��?5G���vJ���C騇4�;b�Nv�����7C�Q�� ����t�&K��!�kϵ)�?j]~�%$q���1�l�R���1T�>ˣ�Z�9\}���'�/Y�#e |o6]��T�~'�C�t�U6�|ѩt(�w�$+�G�����fs{�P.�b�m|JV	3���e�rE��?�)_��)���l:-_�rc_]�ʦ��r��%;�Bb����L���k����X��L�db^t�_�vg��@E_rMHg5�΃TqLL�qgӜ�����ͦQ��_ٙ�ǲ�j�y�`�Q�˝�8�D�N��p�W��A��W�o�CjS[ ��<J��~틿Cm@F�iL�If2��ջ�
�C(��<�!���
��e�3�gPMw{�|:��ÚGb�����Xu=mT�q��\+��2��	fJ�j��-V�`��,�OcԖ��F?�%�_� ��eoY��r�}�5��`���cr�񄱘�|Ƅ�!+O��d�r�J�-H�L���͖*��W���I�jU�M�{�F/����/[vYa5D�ռ'/��T�WRs�L���5�Mö���������PVG�0l�uy��8�"��2k����c��3�ؖ,Ο�i�/����g�1�2,1�0�M|������5O��w41��dgqm_P��`�Q�w,'��!�տߘY*��.-�4�a�[�em =n����>n�������`���h]0iv�~GA��{���ՠ��ӋȺ6v�C�tx���-x��(�S�K�y�׷`�~Y���.O�)b����XDp8_2����5��.Ћ�r�޼�(�=%�̈(���9U�l��µaGńcF  ���3_֗�w.��o��R��La�P�w�7�E���A���m�a���_��kޘw���f#��yg�3�Ď�G�*%?}�`�[&o�ö\��a<z24���kޖa�
f�)���m6�ap�O���.Д��)�&F��]�/oS��20|����"�}�$���Ɏ���M�},�<`��AӲ����,�t���ml�65c���'~+�2mF͓%GZ9Uy�0�"��_��4�-�V�����#ĂVD���i:�Tk�q�5����Yi-\�I�(�L��c�$
��cf�M�m���u���$-���6JG���⛚w�E4w�{ɒƢ��Cs�9��c�0�C�b����Z���0%���F�/;���Q��iE�<`�!F~w�0h��z)��˕2#ٽ揫���a_��fW���АŦ�`�,�����w�C�Ac���d`�!���?&FZ�]6�UM���k��F y�(�d=�g�~S����g�a;���j��Y���iyF0��^�^1���~P4k�������TkyN0��Z���_J�k1
� 1r�|C�(_��F|8�}	fFgV��6et&Y�0�.��-���}�6��"=@?��J�K��@)%߿Pwʻ�}���vI1�U홺��u��v�X,�t���k����y���z�y�L~�j�ͅ���xbcM�:a6Q�%�[ީ�G�:pga�(�^v��g

�g|�R��}��)*��r��|��!�@��Ч�v�{f=���\)�.Q��1���/�y~�s��gy|kDxbY+�]����.���潯(j�b
�F��^��A�o���3�&�,O�����!EWgb���qտ�Hq�`�����+�?P�����L��5�@�y�.ٸf��Kx����	a&k�P�S�y�:�zn1hI=(&�A��m�Zv�;O-[a��Z�w[>�a�w�bg�nn���"�J�C�Fp�a�_�8?�q���d�g0��?Wʌ0꜂{Z�Jfx�R��咎úcƬl֏�W6�K:.�P�������6�y+�e���N�d\@�f��<r�&H����̺�������n�ȍ��Waj!8q�ߔ�|Y��?����4+kvc���3����5k��
��*J^q��e��+�T.�L!kp���w�F�uΣn�>$����X}[�y��<���:��c-Q�v��)Vږ����;Q��l,�gys"��c9�J.���;eV����&����TX�0��:D�1��j�X~���=a��o]}�K:WC��-��˞����l��K:e�����\v����jAPnoכE�go=J�Q�K>�H!=:M�C���6�Uۍ2\�A�|� Rq��l��I���Mo�])�FfD�_bMZ�e���R��e����r��c3�}��RqɅP���%�AP�)�~S3|���]�#���o钍���VZ�Z�ξd�k�Tg��ْ��a���Tԏࣟ��K����JM?�<�y�hC�t���͡K".��>��A�B���l���#�ͺ��< 	��<rݾ)����=�ܾ)&a�mpI��"�x��~(��:���1#��kC�%w�̦��|ε��-�`S�_l#�R�08��M�çn���o��¼X����3�Ri�.)8���Mp��%�    p������d��/��,�{ r]~Ln:1}z>s��e㎱�P�YD=�Xw��Wճ�/��Q�aN�hvt�w�s�̈"0S�Jn=m�N���G�7[{>�.���on=4���1�jdo�O�&R`�js1� Bo���$;F��S�gD���p��񘼚�Ɔ���ˈ�>�~��16HRw�_���0x��x���Ѡ����0�oUL�UD�0b�4�叡�/i������\?����IA�<.n�(�K.��P�K��F�7EH��[�K[׍b��t�!�~i�0,c�(S��biq/F�[.�m�ts0tm��~I�1��zƶ/Ƙ�c�dcuˈ��K.���(�&�\&2l�)��������eFлҍ�-�~���aq�����r��j�|���f�1bzG`��~�z�F*,9������zU��+�����eF�ݴ�?���(j��[rC�y��Wy_�����0��W/��-K���c��.GZ�vn
���mCn
�z�O=��^6z���KS\@���)얅���:cԱ�cy�ܛ��c����~��b�-`F��V��	R7L�U�Q�� ?�O�j*
�+&oO0X�\-�m��mRai엮� #�K�K��2Q���nb�"�� ��Շ+{����Z�#��M�� �Zf��yxE)���~Ɛ`�e�/�w������.����Q�.K��N;f�P��5�:��D�������y`�a�ط��撕�N���lc���:O�����b%[.���I�M�JVv�����6����]X�\�Mx���p����~I�)��n��%Q�����.�l��ʁ֜�Y���=@��l6t�< !�Q�,�b5]|�g���E+6���[x�2���Z[E-��3q^q���٪�|?��V�P��7�C�}V�*T�'FěbR��:Q�~�� h�~�q�'���`�ȧ�mג����gj.��/ژCX��X���������74���~i�[��5R�貂���(��z�"�Q� qz�ʗ���(_Uhث��7c��q�w^�q��w�a� ��j�?�raLe��T�l��r�0�k[�_�%>b�R��ĝ�u!F`u�/]q�n�0�`����/]qG��xMo�a���v��Ѯ�q/o��wĀ�b�KFcjd&���y���ڻ��̰�e�se���)
�>d��%)wĨ�Sz��P�s8���Ij��\�P�cf������.mq�,��`Y����G�^��DQ[����2#�>-τ���S����an��2#�t�&7���:�%mm�_��Ƥ�Ʋ6yDx�C�3��b��'�ᒖ;b�_�~���Q);fv�u�����r��:����c���t��6�&�0����aRS�J�0uJ�N�em�]al ���@M����X�iH����|q/ˮI�bޠo�g�X�̅�Z�T`ǰ����x�ej�ƪ�|��o�ڜ1h�H�i��hZ�au�|�Z��:ˆ�(C������;R꫚�N�r9��C��fH�D��N&������HA_\_r�d�)���|��K"�P��΄J�?J�� ��ߒG"
Ҡ�)yue@!�)�P�bɴ��t�Cc?�̪�
�C�g�4ą�Jn�N¤�����D�D1��V]�'XB���t��:l���S�P.mqe���M_���P�/%���)�f��dR��p�("ݞ�C�'���X�C��ѥ'.�t͕��T3��=)��"�.�������|Gy"n7���k�7]l�r1�kvu��zX~;�'�l�(�gG��aB�o�]��S(�9n+���sʼ����&"B��\��L}�7B���%ŗz��B�{}iS:�A�l��1����Ch��j�B(���C��3�7G����3�fC(���dA_�ر0�b������a����:�� ��D�OP=3��c���RyU.&5A/���:�K�z�TkYw�v>k/~�/rJ�A�;�/j���w���A>k/�X[���A>k�����A��� dC\0��a3�J8�g�S&S���zN��>y1�U_�|����2�ݛU�,�K���uY�]�S۝�,�����LW�_�o� 3���s�y����ƌ�P�%^��Ϙf����������Qg�@��Q����%��(R��.i)�vּuY�TӰ-���L��՝��i�$���GQ�)�.�]d�ԡ�W�L�_�@���%۱Wgv��Q��H���3�&V񦷤]���bȗ��5�"�%��7�EjDK�#O&R�cC4��3H�`F6��i���~H���Ӱ�r@���;��Գj{��=��	|���:7v�uE�q/����~5�$c;x���e�(X^e�~ ����o!��h-C�C� (m4g�e�e� �^�b�e��]�{���rG�<�Q�F��#�k�W���3�#��g#��:/�Qr��Ns��	��cZ�u��7���Q��iS�|V���փ���4�w�@��#\�7�	Ĉ�F���%��Q;E,�U�����<a�h����7��Xr��D9��>(z15W_����nW�A�6���@��tI|B�Q�~���"�xJZ�����w|P#�D��D���Bn�픐O·���M��&��/�� c�p��l�J�D�Q��%7�����ή*�~�/����c6tk�EsYMjm��&d�J�|�yS_����saMj}��4F����cc�-q���P0�P�\��-���E�w���qWjDa=f�6���f�����n�/�Қg
�
�~�s�5�T�sC?����R�P�n�IQG���:�c��7E���Qr��Fio96�Q������#V��)�|��2�j�����fvw�e�#��|�p�̐�`$��c��wư���N��찢��Sa����BHG�G�a�Ӗ�J�Ϙ:3e�I�v>j�c��A��`��w�X�UZ^x@k�a�L)��cs9����mYSB�ѯ����\Z3�pA`����"C�n'j55R���f �L�ɛhSX�ρ�o�~���}(鈥���N��6>jc�X�s����I�m|fH]$U�
br���c���k����|��^�_��޾޷`#�W��>�o� ���(��U_0�������p����������0��f&������R���y�ޚ��7U���7��2���jRo;��0�R�r�庚F�������!W��s�L.�Q�C�u Mq�G��f�Zc��:>�e5���7/��nEw�u�G�Q��L�K:ٹ�yI���c�v�-V�I����U��Jsxɿ1��-�`8�u�0�+��,�K.��Yj�g/��c0'5S��eH�+kF�<����C �Q�Ԉ�_�wo,�o�����r�(T��d ^�o}=7q�^�,	�*�%wĐ���`.��ꨇZ���/	�#_����Q��������*����%�v��u�$�ꚻ�:)�Q+2|�!׌(leSn�����	��>�>.��7dӭW���'HS�_3w�����js&�ڈ͋=X�h�c~a���;��&�]�}u���)�����{��1�4fdZa�ǆ����b�b�S�S�G�z�ح��a��[���.�&���C*hS=���5q]���� J�M�3�r���{�И��?|$�����NSk�H$�e��5w�p1,m��� 3
.�f�;�5uà�6�OXM~�����6�.O�ƒ�j��ҕ`i�GK�`Q�ν��[�E����K���Z�YΡ��p�tɾ!�5tɾ���S7�Y���n4]Z}G0�>�G��7F!�-����
��.ɷ c�̕rEM��c���5�a�\P3� ��N���������(=7Y}��1��`�Ҧ��������q
-`w�����oo
̮'�4#�޾)&��Q޵G��w��R���͇#E70��l�<p�Sf������iF�0�%W�$��h+�{ˊr5�#3Y�1���c̞yI+}}�� >b��zI��g_����I����7�E�.�d���    ���7۹7�r��7�C�
���^r;��n��:!?�7_e�������a�K.���T�ݔ����XӃR0q3m)��;S,�Z�h�yR��ߙ�h�9r�C�D�;\�4�.�8�u��ɗ���A޿w�足��ˆI�`	ێ�3;���&O�� cE3>�9wy�I��O��_VL�L�0�_���:?�>�IS.�QD]o���vs�g���2��X�s�"��;5x�@\�� ���~v�h��ftɽl���� �y�����\�{0�M���#�L�f�����\�K��Hi�js'܎�����)��w���Kܑ���`�< Q�
���%���yw
���/�K�-����Mg�Rʬ")�_J���h�X8��C�wl/�oG�^����i6����a�c�6#���T��L�߂��^Z��e���xr]�,�d��=�Q�7����]�U�=��'��INo���t8Q̤,~u����,)��Y^�%�p��'=���P�b6�F��9#�������v�ȫٜA|Kn6��L�=P[]��K���L��%��weq�$w�P6L{�(Yc���n�����L��1ݾ��,���p��he� %OS�1��|�J^t�F~��|��<�@�Asl �ue.�oEO�:�V֙�W��4��`�2yY��v2����Ry -�����<T~��`�����v'�5�=y�7�[u����������h���#�J�j�5�\.����ͻ�|ɿ�xϚ/ȗ���"6�<&7	w�{Bz�s�|�;b�4J���s�D�\���sƂ�L<¨oL���|�0��&�b���q�)�IŌy'�������I� ��A�S�(h�lx>vZ�E��`�(�)���Icǀ5��:���\v��ԗ�]���3��r�&7%̠u�%[�i�T1�U�W��5�˅��W]�.��e�����.K��Kٸ=1����xi��K..�`��(���V�(bvͰ��(O��/�n���j����P�B����~S�k�2%�>�'���${wU�|�[MX��Y:3�h��<1��(U=�����~S�x�2����K.�4�^/i�Հ}S�<q�*|I��Ѹn��'F�9<��HvUh�F�w{�2|s�I���`��Tk}gWV�=�!�~0|�m���2�3�j�|Q�&<���b�)FY~�����ß��A,��gK�Mioj����kD1yu'*ʐG��ͲC�D�a?��bRVu���$��b���%?ui?�,?��]�J/�n_��x?l�D�����-�`��N���8��:�@�vĿ���[��2�/�� c�#�M�y�Y�T��a�{yqH�j�V,�J�{�6{ZD�X��c�l����e�/V��&zp�'����zԋ͏��K���RG�&O`0�1[���|��~0ͺ����ߘ7�9�64C�W��K�-��IE>ȔNS�0���t^�S�b{��BLZE	9ca�z��<TB�aP�3<huH)�0����r∱�p_��E ��9clF�/�c�U�L��~m���_+�=?Ԥ�zY��kZ���
��_�7�T?eq�-�,q����X�V��F@���0���I��fcue��]�q�l�����L�0lM2>t�y0Xڎ�Y�H�(t�.��kj~l&[J.{�g� iK�S�Nz�;���,��x�5y��ֶ^�r��gUl>+k�n����t�~|I�s퇒G!6��[��`����K:.��Q]�����}uky��W(�C�d���.�mNs�L���l���䅔�]�m��3�1|"�hQ�h�-n>�n�F�U��̶R���E��H�#��{�#/C�(�W��t�	�w��j��E7�"��4��)��\9Kĩ;�r1��^�Eߒ�%D��2����>��/gEF!�N��jU�=T���o"R�?B�#��[BhO��h�?A��pQ����U�)-��o���	yq���;L�
sl���6t��L0ꂋ�Z1���J:cXW��Ari��3���"�yػ�ri�;a�)���-������i'���Ρ'�7���cwĴ�]1�=C.Mv��C���\�{~*���Yt����zg������C]�� 3V{V.�v~������*��X�b]�1yɨ�����:c�CZLn��Xo�T>lЪ�H�X�gZ?����K?�썡/����.R�FoP��?;���Dbs]r��^�#�^E?M7�^�e�)u��| ���g���8K���3Gޏ��X�K���nus%�`Y�Zb+��cC)�{B�S��K��H�x_/�S�)c!���:,+Mȼ(?	nR�{B����[�F�m_�j=��u}���#zU/�%wO3i��5�0�P�ЄI��L]O��ߑ�5ELJ�}�=�l���o
L]u_�#����"�C̦���ʙ1�ۜKG���f��lD�һ%�� �(>�.S�2>��`�S[M�+��ϔA���($�1ݦ��q6�D[�u�|�@-�g%�����9c�~�At���a�{z;.��E���ш98z������|H��/�W����Kl�� ��b�`^P�+@�\�?}��W��ߔ>u�Q�O��g���8^߀���-�t��"��M!���i]nj�]�#��lX����$���վFT�e9��b7�1������q��?��cf����x���3��R�41¥���"6>jy��u�0�},�h>c��j'���;��>�(���EO�E-@8�?l�~�j�:��\��NV����K�(�=���U��GJ5�"�z�K��p�E����kR"T+�u��čK�1<��;Y��a.[����U[��y�Kml!im��&�K�ݑ�^6��_���9.�S�F_V&o��0�,'֥�n�=Lyk(�h��3]N�3�s[ i�>� vx֩9��vr��3��&�q�35<����Jr��3����|��H������wC�I{L��#Louɸ˸l����Ye�>�,WB�saDM��J��zFX)¼-�Np�orI�"��m����oˬ�@����SL����o�\�2���'���+�~?NA�֭���L��ٙ��'��-��7���(#����=��x8�sDw�)�
�����ߣ;�i,.�:J> 1��=ۖ�̰�Z6�e��T���W��o�i03���m�5�O]�*�
��E�2�	���\�gg���}��2��0�t׹֙���(��5���)�}ӷ�)�s�6�[�\���V�r�(����
<��|SZ�~H託�/��X@�U,��\�g
!�S���&3�k�(}��!��5w���w���\�#�ˬ���#O�E�c��4��u�,�[��uu8L�v�0jށ䍖J�^��S������̝)4{ȝ3�#�a�K�ܜ޺�7ygݙb�"�?�|�n�۬.2́��ŽF�u�(f����x����!]#��i�a?5�ieY!�r���"�i@�i���eE�Wܝ�=���=�I�Ɨ*�ϩ��-"
�t��-i_]DQ�~��=�h�(g*�C�L�ɺ�7�����0r]�cu��{�Y7��a���?-��#O�E�^q��a�E@;f�s�`vK9���=c�2Ns@~�V�0�Κ�T���~��uL��_�y�W�13"V/�V=�16�A����䁇 #�����þop�1�:�����-#��v��#o��c)�һ���ϼ��L�W��FwH�ږ{$eR�7#�[R�7��.nusm�=�2)j����jͥ-#H'��t�<sQW��Wk��!@n��e�1V����曷�c�]���c��7��2��?����[�0m��sQ�v�G�h��Ay�b���B��86+�}�y�-��pO�i(-�?BL�����y8S�4oAP����w*�n��:.��#e�1Omy�|�n'8ؼ�j������+YVG
�0ct󴆉[�M����N%`�#�mR��O�6��G~�7E���C۷+*�6�ӟT�\�#���������g�i���H�Xw�s�Θ1�x�    p2:*���8|�0��������<��`ǰM�O8o�;c��Z�Sr���&<���N���GW�����������oJ��R��p
�C.;�D�Z/���,k��^���3Cr��N�튬��b�_�nG��L�(ج���ΘZ�b�Ikֹю�YL�|f�TW-�`��iA��(��,�YG�1��r��t��`�4�h#/w��[�����x�'�j~�����V{��mK�R:�0��{��(�2|
{�TS����!`"6s1O����K�w��W+f�*{�@�ar�-���"��I1�6�U�A���Y����{�tpC�O�b�Y}�O��R.��2��$?{�!`�;�� ˫��o�a�[����o�;�;V_�ey���0\�A&�����mü�L[�����ηc�����۷���۬�c�������ӧ6{�+\����u�//*�����ڦ����Fp�A��ǲ�i�f���[R�e�+�*v���n\��&A�f
[�6y���Y�%���4����ͣ�rI�)h�.��ܑ��LS�`��*�_�%`J]�S��a��n����v�����f���3�P)���;�K���n͹n����i���q�ts�	ܻOD1%�O A)����q%��ϼ,���/����Ц�<�1�)�D�{���Ds؝�<Z��]�=� ��-���Ņ���S���pΰ��D�Gh�S.go�)���29�m�~�N=`���,p1~m]��E���M��"JGj����E_���@䗅[��.-aئ5��\��3�:�?�!�u�1d���zG,����l�� X�b=�1j��_,��[;�gA��D�`.[��ᗾ߻�S�#�
��a6V�s�\2p�E�;��(B�~e0�A@�(V?iCl������SMȑ��|��ah;��E?����{���|25�&��FO��P�C�N���X���;b�E�J�KcI��5�v̜iEL~���	.¨�I�?(JK(pô�e)A^~M~�b����y8�S�󾆬K��F}n�����'��}�~�P*���*�dM[����%.ϔn�:��h(��Q�&�����eDiNqK)�D�~��p;K���;BL���ݲ�s��Ԍ�|̺=;��K�D�d'v��%��Oɤ��> ����i���R��2(y!Z@��7�	�4�ټ�(�G:/Y8XߴX��*��Wk�o�b}���;J��(Ի,a��\�-ax��$w������PL^��c`VY��,���{��m5�������u1�rQK��c�'j.�)/�(z4������e���o�Q����Z�1�%3�ޱ<\b�`�0P-0�w�χ�E�e�wUF���v�U|���UL~���~�tFc�0��k�[ou�tFW����<T�q���n}��F�I0&`W���k�v��Fd9�k>hWk��<���c�kv�沋ϘQ���c�'�1�Vј�����\v�	�kc)���T�i�kR��umrG.��
Ϻ6i'�l��֢B��[��Is�7u�-e��SG��h❞Zs38��R��VjMux"P���&o�c;f��z^(=5m
�.^�&��0����<�@�,˛�����J���TL0�\-�b�p-7f�BhS4��\j>e.��EW\W��'�>bP��eڋbjZg`*Nh�Ƀ��vN�\wMY~M�0V'�S�5�4w�Ы��oZ���w[G�>�/eTLޓ`�B�QB��Ͼ� C�,�F�c��ꋡ�q=&Ք�0�n��מW�llR�[�;fNL.4��^�r�1��crc�h��[���g�kύ� ]�,+��;f<�V�ߒ������OG�SȂ	���br��Z����++il�6�����Ko\�Q�h,��R�q�#EO�β<��cc_��Ŏ����P�r�]rs'���X�����WԻRY]C?��%7wİ��O�<�aL?t�5�1�&�����}�߁�zI�� �G�@�)7%"�(�P�����&e�D�1$Jɏ��b����\��K�m&�µ|*��Ν)"��+�V��xSfq; ��rq��ˏ�:��O�ۜ�7g"��-�P���)�x�jc�
����z�(��t��:�s���M�t_c>t�LQ7N��?�%��)��q8\r��e�(]/���$�U��=�6m3kX)��]%M�'��%_ɿ�'ѴJ')ݯ�`���d��{w�(�Bf���Dq'&_L�3Eo��
�*_"i�Q���iN��Pڃ��e�_ݛ�'ͅ���vÑbq���wdq�?�f~(�b������xS��9V��?��P�Y���y�"
Y~�x��Pؔ�>��%�w�)�͆���zѡ<R�&��M'y-O iTХ׫�Bh�S�/K�����6SJ�����Dܑa�s�ɰ}(y.�HCt��5��=2)�׬�.�UI5�#J�r6����o@��Ѯ����g�8L��V�n�zJ}��� �p��HǄG"hަy	���R������.�ܑR_u�3w\�����=�I��%�p�@����\��S`V��j��%�p�`�X����d��ٗ��Myl��ۑ�RJ�Ok����2��P�#�K�-��(^[�O�F��D|�`+���}�4�W�{�[l�6�#f��opi�x��i�nܮRr_������������V�|ČW�:�h]��3�1�:� L���L����崙�k�ӗ���M|��8��l�3�61�mS/���
�b��l�&�~z��w��?�ۥ.��A��L�.]�3FM�ږ���~�jM㝚��vɽ��|�&E�1�B��e�̩U2���C���)�U{Fi-/E(z|���R:��P��.F��)4����s-ڥ	�HQk�
�eI�L"�����7ޯml3C0���.MpG�*�R���e�1����?Ȯ���aNX׋�[�P`>�y��Bu�[2-�h=W1Ԋ4�?y�t��Y�9,��A��w$�T?��0k{�Z@Hϑ�J���5��<-F�?�
>3m<���*���3E/��9���g&I���g�O��_~ߨPLoI�Fj�<}X��6��L�&�Q��`��)��Ğ���[>������h�w�J�0s��Y��@l�G�k��h�(5�'tH�!�1�,$����P�ӭ�����t�QW���f�7��3�_p�U�͆�%�� ������թ�7��x�"�)}��)>�K+�C�{8�� /��������FY��E0�/k[�e����C��E����3���Z���b���ƘJZ��9K�r�4�1�ҵ`_���yu�&aaƜ�}�G�4�^��]��l,���ۂ���3ƺViY���0Ê��{��N�n�j}�zaY�����ă���u��~(y�d�&��ԅM��C�c%���}���`�v�ש�aU� .��.���b�B�{"·u���)����#+�5�FY��l�3F�ݾP.��D�!~C|q����]9�w��ֵ�,�8L�}��^����걿�^��T������06D~��8Oo��c�̑���`.���k_���$�X�&���q�#���r��E��� "��ܡ'�܃�bI5�|�AD��
w�\f��aa_f��E53�@���,n�죜��M��Ύ�'
J��=�C�PԲ�<R��V6�ń&tύ�)y�0�����M�&�B(\��&<#�,�j�zͦ�T�,��G�2ԥ�S�������u��x�%o�;-���t��#�]R��tq|�B������o	g�vZ���%Y`��b����߱�s>����7��%]`�1�ل^�\��3f/�@�em�dw��.�$��ɲc�s�W%��������GtN�
wW��K��m��R����%��{���)&
=��iUvX�u��Qr��!��)��:L�K�_�GLU�Sd�Լ�s;���d�y��t�A��z��k8��^��e�MA���C�c���zӍ��\��3EQ~�4������xs%��y�Q[T�=�����-� �  k
(l�q�Y����7Elۻ'��ߍ*Kɽk,*9�����H��y����r�7�TЃʝ��v6L�u���J�(��{���'�~�'xpL}Cl��_�<��9J��	��9���z�I�{6���IAyu�4]A}���(\�OiO,�n�F�n#j�� iNe�O��?���ǚ΀Չ�����@l&z
���)mv^��`���� C�&J�0������6=)S��zX�e2#�(���v�TcЦoxR�Iυ2#LD>��/ٷ�����nK����|(8l�����lR��A}?��#��soG=���tԁ��x�b�!s�ä{���6� iyݩ�+e�.ah P�C]���w�T�k�r f6�Q�M���̀B(���[�-i� ��Ÿ�2��������n7�l��Ƿ�&u�b:=O��1VdG�E2{>�N��Q���s�ş�o�L(y��*ۛ{2�5��M��o���p��G�����nR��m�l���-{�v�0�?�r�L)�3��wݴk�,�&=�#�1�e��Bf+��݇�{.�a�J����%2#^� z�y�Zv���y��Soyr�67E����n��q!c�Qn��uR�F�{5�#G&>D��,{8�Y'�mK����M˯IcgFm&��o�#(�o�c�-�ԗ����y�R�ϛuK��ӹ��uü�?���_ݜj\E�YD�}���"�h^'�K��4��=�@�a��^���5�Zw���륋S�U����UJ~
Q��W�tK�e��v�,�oz�,/;oӋ0P����.�;'�w��\ey�ܒ06�r,�ܝ��cƔ�˥ �)|��giݧ~m�[z�c������xz��)ul{QDؖ�3̌06nn�}y����c�
��ԃ����06�{�1�L[DC��)�4
,����om�?���ug�x���&aL&kY���G�z���0�Z}� �4�c�WLM���w�,W=kڂ��p�Q�}	�M�Kl�*3wPh��<a�<_&�@.�)7��SY[$�m@.�aL���(�>P��2}]��C�����ʵ,k�f3�ц��F%/-	���Ϙ������Íw����c.{����kKyL��aZ��jZ!M6̆Fҽך���D��/�<,�Ǝ�C�F5YH���'�,}˯Ir�1,j̐g䤗�S���	�VZ���I,�����ˠ���46,��9�Q���L�3#.Jm3I�x��xv�[��*p-��FF�^w��bv��!(�����Ӈ�;��o��\~M�0$�4�B���JrLB�u�]|� �E�r���K\�<�	v�O��2#
Y=Ew��"���3����Sr["�0
��3Gӝw���s��\Na�)���d��Q.�𙢶�W�r�)@�J����#wʔ�d����3�ʌ0���+p9��KP�� ���Wc+�6O���5�鹈byi'� Y�%���$N� ��S�l�g�R`�eF�2\�Ǌ`g��C�`��Rs�Y?ьը��q�T#�����u櫔 Ӛ���D�F'Y*�A���|�V5��\�J+/���KB.����&�d�k�_r�̈R��v�e�D�L�̪���;���e2#J/�\y>�m���tf� i-�/��װ��xɓrg������J��۝��}5��'���
5a�T�-���!�@�J�=������\$�Lы����P.�_'�����x@�Q���� �'��o�ur��Ғq��L��n3!$Gɷ�+sj������b���jV��օ/[�L�ы���>8��Ievd����#���(��!^�8��0h���o�Q��gy��Sz���ᒈ;R�պI�8ʣ��7��8�[�ξ)6C�_�<�ޒ�b�p�Esj]b9利%(ǋ��^R���0Rx�Y�%������k���D\����M(t�<�3��p�`p�%P�yGV.�ʐ��ig���R�������T�M��A�jp̜�%�p���`��5��ʵ�)�F���q	6��2fp���B�d�Nu��U���A߀��W�C� ��&���Mm���3�lnNXF�q������( �9.��#F��U- �Ta��?�Iu�[2%�j�˜����އ�Gܰ��Sg?��Q���8�0�R(�y�@�16��%lR�[�G�%S`,k�v�	��6����?��l����M����/��iSöw񊙘+fFhu�Ē��E=&���5���14�1D-"�܀8b��.�/T'���z~�-�l�������� ��z �6|�c�8���M~~.ּ�d��f�R�ВC�K��ok�G`��P�e�e��fD��/֧%��{�N���Z:��/+eH��"Lb�����:�06Unż7q�0jI���`>�.�p#Y�&?��̟ډ���tV]�ч"_�h�|��1����¯�[��g�>��+OϾlfo4���D/�� �ܚ/���zK~�r�Y��w/}"�)[�����Q��:A�)��JuO/ٷ_��{A����8�U'�;�Αl�J^c>�q���;���	Ҏ1%oÐW��|\]�Q�h�u�|\� ��s� ��*����~Q�%ye;�N�kV��w\��	�S�k1��b�KY>Pϛ�+���#��_�B��Q.��%��8%���\�3ja��%��E���y<������u`�Ot1$��3�E1���7�@�)|��Mtp��P�j�$*^c��~x�U)ϔ��@nJ��'������m_�?��>SL$��m^	���������/}qGLSoŦszL��Ieǀ�8Y��b�]rpG��v_����8�;��@�T寓K.��͇pm��t+��u������`�VZ��Df=��慓��pq�i�2ŗ�R���{@=�:�-��H��`X-�����0c�XnZ�qJ�֫���k��2�I|0�(e�Q˕�7��uB�a��5��~�( �-_7��;"��,.��R>Y�����jA����C8�H��㼵3��Z��©I�gGŚ�-���ŵc�HA���)yDx;�&Ճ������(#�t�~q�b����f����ݶ��2�6 r2+v3<����L�����t�[�����(�|�6
�ف�hQ���ǜ0V�m�%�;a��\��K;�F�A�6��������eK}�*NA���}��D�/�8�3����ͯ�%w��	ߏ%h:.��c->=����_Z��˒`Kh撓0\�,��H�E��KHo���?K���W#����e)#Y�����`F���a��h���(s�HQ��[�f�#[~Mˆ�D5��Q����F��L4]�Հ�s��i�$s)�ba�_(�/͙�C��3�1� Ӈ�=A%��c�E�Z�E��J~PWΛ�T�J�q���C��K���Ǵ`�8�(��<7�)v�1u�!K�e�;��h��沉O�r`��\vq��!.������&��       �   @   x�3�v�twt��sWv
��s�44��!##c]#]#C3++C�\1z\\\ �Ej      �      x��}ێ$9��s�W����_�-2;�*��.�̚�a,�����Wx\*��vhNs��k�=s����t:I;v���?�������������O����_�����=��/E��r�[�����jw�=��~��������������wծow�����������������o�������w�l�?��jo�rw����4�旲%��~����s��4��)�RW��i���rxܿ�??���?�>�_?~�[CX}���Ϻ�=�v�OQ������t�] �x[G(�g�NPE�*���������mw�������o����<�����Ǉ������~��n���-@֞Q���i�۳bf�lm�_^�{߽{�<>����p��}շ'�����|��ڽ^�����oO���>�WnY���/�^�M�t��������v���=���2�嗾�=e`��3��?��h� M7ޞB4%�f(v��B0M��=�`���9~��[j��=�P���ov���?N��O�������~�ݧ���C
�T���"��2�=�H��"�ǧ�����u�����p���/_9<��������F Ks�����^�^��ᷗß_^�|8��a�����]7Ӧ=�~���������������a����T��_�F�����{ʠuW�%��"h~^?��"\A�}�>�6�B$'T{��������鯻�v��z9'����:L��V?>������/�U;�m����)�/�ٷ�v:����������_ϣ�/Ms{
G��ɰ<�Z�$�`f���S���S,���ת<��Ϙ.���o~�����*��(�Q���\e9�Z����󽦿=����n{]�q��?�J^A�{Ny{���e�;�߭#Ewq�Yݞ�w? -�-w>b0y�Wm��7���E#�<|�aޏ|�'�2�<�>���'�~SD�+2I��U������f�8Aa/Z>���Q��rS�Թ�C8�'	�:O�5>OO�n�ȵ�X�$����~w��	q|�;����l#�n-��/���0[#��)�Ɂ�$ف��Mk�{c*	�|a��}���x>$�O��u�$<�+�k�b��I4��(�C��w�v��|۝�^��oo(��@������=����V$�r���ܜ�L���t<���
�� �d��Oz�1�f�6}x��5��K�L%���e4�ډ(���D�!C��72%ތ�
���hx��5F`�X�/c,v�������?������/�.�����}����aA�cy�̱�l�P����Vz�y�wR%i����M����mL��qq�H����#+�,D�˙@�F_3}�+���K��?�b�����N"��$�
�Q쭺��)�_@��F�K�O�[R7S�'�x�`f�ǔt<e����M�����([�7�/��Q���.ᮮKv5�52�ڂ�l���X���p�F;��e,<VN9[ ��Fac��-��q���oO!���#��\�~J����z�x�cIĎmaHĎ�6oJ�v��^�"�.LO��
�kWL��{|=��ޯ?��Iq�p�e����Q�G�Q��p/�<���W���>�Z�X�8��X�J��6��W]&7U�8��9����0�T���_>+؊Y!)ϱ�3�B�~�m�b,�SD�C|�pp1����H%� 4�M"����ŠK!��\&X
BDA)AE��8с!�ҕ|���2�c�2��c�2P��)����r=�	�/Hj[�
���1|nUjW2�;f�+C��PjЕ!�oK`����PՕ�Eې1(e����{$�j3��	���>�D��,xE϶����^-�꽮bt�Z�@�\�t�$�(��W����9J�e"�����~?��|8��o_��판���S�#<|t��`���*�%͂�8��W�s���:W$ �C��T\mU��4����S�'�ptn�`��ť�b���j�}��/�E�)��qdVP��1�!��&�h��?i��\C��Ef��:{?������N��:���'�.�-_K1h+��>"xy(Q�4���7͓���)��5PaI��P��h;�k=�w�i����=�0�Hx�\��P�M�h< %~��NF�Q"G��;ޞB0����0�a�����0���Z�EM�i���  �Q�%۠�ߒ�hU�N��^E���8��ֆL�嵫�]�c�iy���5�I9����#�OO������}���{��q�_~�0G"%H����Z*��w�;4�$�^四�R~��3˦+򸌀�;G��9�Ee�"Y�b�:CV��4���H<)u�Y�Ĩ <[3�L�Ά�M� �UD�j�T�  ��sqɽ�R�.�|b�D��{��q/�gEX�e��.�o��tn��uaE�A}Zz��AB��£/�"��W40�L5`���CC���.��")����=��Ŋ��S�hD��̩�2�!��:��H3H�_�/�Ts�p�:�L����w��D�F�gJWdz��t)�1߱�h�tS�y�$���̒F�����h$.IcJ�����W��ʆvak���-��ʻ>�N+mWh��b-,;�8X�6h�,�m��J����f�z�"���L#`�%�5�}��ޞ�yZ�!�o�� ��PS�҈�=�2�
�$-�Hr�$ ��Q0�>��q5��M�P���`��J%��1�V�v��D�/��W8#S dI���#��^�1�#��l*	ڂ�7���iv_���/n�?�t����Q���@�NU��1>�J�(��(��S� �����eNcaZW�Pw��3�Ck�,�ia�X��w�1F,:7Pz^D�����P�|�9B��uXmzt�;�c|[����&S�!8�'	�Z��O�I�/<+�+~o��s
:JV9rV(:D8M�1߻	��l��|�Ɍ��P��=�<c�n�C�CX���kfX����HΔ��M�P�����7T�l{htҜBX�N	�������2R-�� �������zO��P�p���7�@��SH��ء��ۣ�%T ��hG���ۋ�$y�^�F��g��vJL�mH��slUX�mV6�*�/���Zq餗Ch[kxy��KO���#j�]p�2R2����ǡEQ�����Ԥ���ѫ#t8�9@I�fC:���m���N�W��"��JC�\81��̣)���S���ᝫ��
��$A'U�F�ug�%��Y$�T�"�ئ���٦r�d{�SűE� �՘��=��������89��o��;��񏞱�=�~{|x������#�=�����,�� v��X��F}�;N3#n����:���܋)W>��K������}���#���Éj^�I��&yY�sBixU�qc��9����#8�5)�@(a�����$�&J�:�iĭ_�����Bz~2θv)���:��b8�}>>�:8�P�6:�����G���D�G_�a���!פ�҄ moQ����#כS��AP|��NAC	�q��4�`#�d�c������c�{��t��q�r<�?}}=��1'N=�`��0& p�xE���)VWL&�%`�[��G�p����n�0�_�:�+]|�&<������i	���<���i�2
ɣ��a��{[Mg+��k���4�1$��
�(�6Ο���dA�����,��4h-�g��6?��0��v�2��������#
��B����3�z/�!2�2/�N�U&�Y�#wz;���<hx���W�lr�'�N���'������i:��v��y��?�}�����HV��M���ލdw?���񸺾_��'�ڥ�Y��" ��S2����PW����وS�*��eA;O��?a�g�b�h:;n*�Y1��[)��Y�V��C)]�I,%�k��@0e�Ns��:�#��-�%́��Ȃx��)íL%�ӃJ�
=�K8JC��͆�0(;u�AZ�D'7Cb�3��|-�r�]O�fo-ϕ���V�* ���O!�GoR�;x��    ���)����XE�x�D��B/U��j�I,)0B�#EM���{]Š��4�}C������AΖatr0�}Q�0F�|�1� ԿTT������5�K�(ڳ�CÎ�~��|w�I��x�̵H���c�a�A�����/~q��z����[��5�����������{�-v�:�D2e(�]&RM���R���x��,��W%]�������=[��	���8୞���[��5�K=��ׇ����r����,��c1���"+v�ޮ��v夷�> �@&,T�=�d��h�D��EQ-��*9 <t2�B<_+R���Ү�}"��g{��S�n�)k����jjN�`h��Ce��%�t$�����G��ׄ�G��D����i��ߘڄAL�J�@�4�K�WwO�..��q�eOLU��e��6М�1�Y%�
Vq<@���Y�o�j�\�����շ��$GO�d[�aky���8))U���x�F�]�NR�>$���{b1�-k��Y9�u$��F7[�z���=���ު�<�k��#q� �H�S_J\��v�<L�q\"���J�@�_�,�S����-�#2m�]Q��U�����
���$ݢ�vϙil��SŢb��Ɖ|�i�ЧM0���:E̡��ț]��iÜZ*�=�(�7J�;�ѥ�	�z:4=z(�Pc5  �&(°���!h8|jQ�Ié̝p!��A)�;��L�e�ݜ)�Tr�XB�W1=~�j8#C(.J+�5E�VjiCI��g����#m:�E�';Cb3R��=eg�n������B�jx������#��zEx���.6���
q�'?�`����mȀ�6�LX"ahY:��['�Rܯ�Ą'���:넶��炒2���e���p�@W�E=���G�,�!�� 2���uw��"6�J�i��|��R7���>�"G��Tt���gtUu{���d��o�U���������4#{������Y�����*�7̥W�!:�(���F(�4@�6�(]��K�![ǐ����+h� �0�A_�ፚq����}�+vq�]	�;���h����������ha	��mH�)U|vh�.�����V]DC��b(��=���Z|F��kX{
��~�(fs��h�J&3��Q����p�FD�C��P�Y�~����OÉY`�ox��N�}� %�o7��Ua��R���;"����$�,	�ŵ��l%Z.�����.��78�NH�a���1�i�W3ĞJr@i��"����i��W�Xb��xp���K��5�ź�i�;���CBc�h#��(㸬	�6c��a���Gav�5<q���̿,}��A8̵��&��.�%4�i��H��ғ�p�.L� ��(����Y��UJҀ\�4`���l����Dӄѭ�'��m�z�ys�̓wR(�3i<�B)�L���2�|�%]lhe'3+jW>�X�'�q꽛��H���c���M��TQ&�-)ҭ�����*u�P�X䮃����z�d���wb�6Hp:|(Vz�
,tX zp�"[�����<A��8A��:�n��f���&(�B�V��{S��r�"k�wzf�M�.�^��>���?X���S�"E���Ey{�������U�ܞ�8�!7U�I�!\"A������2��!=z�(����K�SjI8��B,��#���"�J]0"/Ða�¤0��m�F�ׯeP7��B$�mc�fL�Hsl�����`0+
�&�u�l�~?6�(p��O'�No��o������-� 7u3�#I��]��[�</���W��6}(?�R�@ ��F��?�2���*� �!K1��q����'F|�����0�����R&��rN@���X襦�p��$s�1H� ��4�����e�0��d,�'�=�p���7��T���=T�4�p�йu�˂!~u2[$�"�H�	_�XpQ�00��!� ��ei�5*�,%�����xs��;'��fJ�������R����ο4��)�#MFc�.AM6!�Ѹ�%�'ՅD�ۣO�
��Y^q�`e�:N����k����}��#����o�����K����Y��B�86����aA$.�_J��*ef��O�S�6�̂n(v<��˽̩������m��&<c,ɸS)���������Y'�F�`�\En����oO!���	��Ly{
w�߱������nY	��\��	%�A���6]M�:�.8l,m�j�a�!i�^	-�ՙS:�t^�X\,� �P������w|/@�H��c�/�G���޹gO��=eO��c4��.1h+D@T3�at�:Rzݸ���Px���{�=0�4 �n��� �&�Jl�ɰёZ�4��/����{�谼+�a�EG8�Fg�������L厖ȅ��RKCaN��~A4�ûd��i`���aGCa��J�bW�L"BD�}�%G_`.���h<j�i$d�J�H��i( 4T�	(��pZ:	)��eH9p���ٙ��������e�}�R;ң3��JWy�gBCa.�**��`�ʒ�p��>Qʺ�,f�0�Te���d4* '����EL��\�V�F�B�Y �S��#<cCG*Q4��4F�fw���ë~Sx�i$.]h(���4�'�aX����.���0�(N�Vdyh >��4O�1�h}��,����y����KB���0q9~�k?�\Hr������U�~����S���� �;QaO%5v���4a�t��=��1\���c��	��l�p��s׊9!*��b��@�Ԉ�v��7L��� ���Z��(�~����y�WV��E�T�DS1$����t�(�*�!s���JA}�)h8^,.�ð�J!��	MT���֚'�y��%�pB�%��=P��E�4�P���	�����I.�P�/��A!�-�
�	�wo��������1�¸N��gB�E�`r�:)����<���J!!%�����x|�:���F��!İ�q�dQh,�9۫8���j�c�dl}TZ@�@J#�)<�s�#�7�v2��v����q}<���˧k���Ep������Q8sR���B'�uV����2�PD(�����4T�\ƙ���{TT��H�*p��ҍp�.G�
6������y��,� �+7�X��$�U˃  蘥�R���x�~���=�:�=�a�q������d�FC	�@�	=�[�r���Y|4�&� t���)$f��̀���)�y�f3K��1k�@�$�l#�)�W,�����5�Bx�*5i{�bC�l�]MN ҏ�x[��Au;�V-`OE&BD.���<�	C��+p���\�s`�U��D���px�2��A�Q�zg��6�^t����Hh���;�-�O�H�@4����-��]n�u!G W�%e��sY�$�6�%�h&���p�������NEE�Ss�`�͡hFљA��XlC�CF��D���R�N% �u���dUw�^i�����d��ʀ5�K�&�9txbň'��_�֏s�p{
�]�)��!u��sZ�г4�4�����A��`��o�X�ݧ�o�O��������I�7`d&#"��Fy{�f���hӣ3��*�K	�Ω�N��8Yx4�%���4&��F��h��^'�ECI��ys9bs{
��F���b������ p�-*�B��as̱4j�G_^�q�wN)]�WT>� g8�A���Ϸ�]~<��I�Z3\�]~�e����Պ�G��#�ԩͦ��N����$,L��ҾLca��T�^�-aB({���p\wwNI� (e<H`�����WSSS�ش���JJ�1��7Χ�Y%j���EK�-�o/Mc�|��`��G�����`��0��L9H(�>tU�7�ˑW!a$��1�0��"%li��z�Go��P����4�K��;���nO�0���|����O�N��F��H�2��A����F��9��{SZ(    W	a�����ƾhqI,^.qS���7!p��;��D�N�s��Ϩ�1�j�H��-E�"T���h�^²-o2'Bwl�Ͽ�ճt2&J�Ia�r���,_�8���3�7O���!�C��C^���FȺ��.C��[{�rrcAW�a+��hL	�N}������� �	���)��D�i�����nO!��K���|Ύ�=�XB�Ka��%,�&�͑1ȴ:2�i�E���)��"��5�ֶE(j�#_�";����f����/�|�\#;]o�����ix���h��4��vZ��^) ���`��)�V�s�Ļ�^��W)l�
�a)PG� ��G�i\GZ����K��P���nA��J#I�84e�iڌG?�X�O�v������f]���x�"0�:H�Knp	C��EEc)�@H�qㅣ3zU�
�ƾ"����Ӹ�C(�R2�8��W� (\GC�ޤ$�J�5�]n�+�<y�X��e�t������VU�\BH\-�ȫ��R)G8x��6_��ɫ5��X�9�RD�h�Z���}��QO��c좧�x�ëh���5Ļ�Ww��	����|�u���!�)eŝ�:�����G�%�N�#CH6x��P��$sO)�H���<5	sq<�p��ĕ�J�e�ux����I��le��¡'#D��0#,{��@ ˿����%�^�t�L-��Z�]�0�jSX.�����~&�Y������X|o�䝾
��D=[n*[@Qsl�R̅�8�\}\�u<,UZC��"QuV'��Ģa�(T�*X��\�P:A�`�t���ksP�2���Cu*�1��G���p&�P�Oĕy��"4��r:� ��& ,��u�ο�8� wOW�ix砓�Rn�B�{��^���ۅ���݋�~J�:�g�Tg:�
��{ߡ��C��q�Fw=���Z񙭓��\'�&���j����F�dKZ�c���{V�_���Z���U1.hT�z"8���$L���(��T8��@�cj��� �:����Q�����E����aT�t�y|{9>_��/������������>?����uʄ��ʝ�A{��؋�y����e܆tvJ�;:��@T����lB�ɶ�ہ��q��:�!��8�n��LꚮA�����0lU��*4*�!�-4=Aq�T��ՊsW��k��V�w(���[8��������(�W͌ռ���3����c��ܐx�ɯ��}�kt�ap[U�z��}�S��-'�Y�In|_ԣ�9A8��@���.�|'�W�D�ˌ�΢AP6()���/Kg�a��Q�'#<��d���t�@4����� 3�d]3���e�LX����u�����&�[5J��Ii�+h6uc�sհlm�Rj�#Ʌ�����]'.����E�������Fo���x�)BX�ha����A$��h4(�\�H ��I͋4��
�J�3�A��V��
ٔ"y�,^����������x��?��ܗu������CHb�d�ʮ�w��h���x���U8^R�6�[si$K�"a�ӔO�w�&*�Y�m;!�N��-��E�I
x+�p=���Fn�K�~'���8뜙��� �{�ğͦ�IPC�=Ev�B�¯'W�m��'oJ��)&tW�Ɠ��v8�p��sS����j��֒���ڰ�hd;���Q��%B�jC	A��x֮��x��n�!��a���>�̔�G�S���l��l��p����{ʡ���Ѣ�w����ؠ58#5�	��-����/��[���b(3&z:� �a0�f\Z�B,ΉE��[E�h��}4h�)���K�����������.ǵ
�.��L�KMLUA|WJE�4]�m���Hυ�J��+����@\ٵ��UE~���j�˽a��ix�#��D;�vIj�SU����M�!S��	��v7:{�;Q�U���7�"E:�ݗС8�]�N1��z?Ũ%�7�Fof��$��32J�e���_Ym�;�J1�0�L	��%Y�$�T9��wՇ�bX[��9��R�^�B�\���q�����}
CiW���-E�)E��aa���_�R�UT��n�'eeG4��}����I�a�3�ƪC�"4�
s� ����jo�+ ��"����U�W1��^`���7�z�da���;[�c'�\٧|�r���t�M�<0'm�B=�'EKsK��D˚f �o��^`�h�I-R��4�%����L鬠�A[�Јf��v�j׳��6#l�<5(�V�5Jb��
w
H!�WT�a�C�$��:�@3_���!��A0�Y��<]��E<ݵp��=�
�8S�s���'jG�\f�"K@8���6_��\蜏Gq���DsD�:��h�\KFD�@P1�*^2����0�2~�Me{�+��E'������`H� CW���pƕ!��Cmح�:�ٰZA'T[��;��$�BX���4,7b�U�r`���#����:�Qd��������:*��Y5���ooь�k�RI�z5R*��E�RWj��F�m'E�ՙ�:V��o��N�V� ��
������a��V��֊K�O�N���3�e���'��NP�~rA(�������)'�a�Fj�֨Y��<�j�yt2l��C��� �9����7��>�)A����S^;f�b�RD����S�:�&��5EI��lc���r�{J�hI`\/*�B�A�X�p1��IR��V���	��U�y�OZhy}�	�x�İ�����Q	�w�]���s��N<�cY,S���feM�LC��@X|��u*��P�Z,�s"7�xS�t"���p��ˍ*�Q�#$�{:3�@,�>I��vi��.Z�V��m'A'Z��ɮ�	�m�*L�'��*�����5�b7�Cz��Lߴ/��a�7�3��$e����YYݞ�Y�b�0��Sڞ��������"�JN�k��ܮ��e�h:��mY6��7�l^1߸)9����U���z�
iѥXA٠qT˔;)�",���t�A@�XJ��Ng:���o-
)xi����席s?LZ����*���)�Щ�BP6h9�z�p��=C���O�T��$%Ռ_�7���]�lg&�!���Бr�E��D]�xCF�̖ι��N�W�M��ꜧ��-�f��(�_����J2��Ra2�ݓڕMO=U��_�<D%�܈e�<Ogʳ�ȡy��qE4��ڔUn�ե(��ְÔ��yʮ���b�۹��q��l���	K�;��A�t��wO�>X�]Q�������)F��/i:��*���2�dd\��Uu.6ht׋����
�����w��²E#�6��t����Z4��a��l�̣�;� ����R[��v�3"O1���m[��&D�'��W�����H����$J@(��B�+��Y�C|���8b(��^�|���>��7I'$Z��B��H-g�a��LiL�q�ѹ	��j�����y5�3(S+��P;+��_� ����H�M��P4��Hz��=�Y8�b�c���`B,[ܗƄoΒ��W摯_��9E�tM��cD��H�Q��eH�8����w��}^Cn\�-%}�m)S
<�|�TC�6�MR������a(D���9n	�'XAhr~f�:{��9�U��X`|���}�����j���>-@2!�L(���[pm���R��9(%��%Rk�iBx�8Mu�}Y�J��}��J[s��1߼!w���8;V�,9��e����{��5E�b�F��Wi
q�^��2m(ue�9�ѪA
M=��:�]�ka�r�~��y�1���r����Z�'{u!y�4R�*f�f�@l��cY0�>��vq'�J� ������{\��ԗBq�M!*A�h|ޮӖbdK'	�Ұ�mR8�t���BTq�B���v��Jϋ������1��ۭ�d��59��R4��~B!��T�wfh��y9�Vf�M @Zҥ8��jò�>%�<    ��}�r��^�-X�'�HQ^a\����-ڃ=Eh��A��g�D�!D��A(�[��s���_�淜0T��FX��o:�l�˂�o�-><Q�V
�y���� ��Vؤ|Nfn�kG���8C���49����ϟ?<<>���[��sM/Ƿʓ�2����TR�'3۩��b�fKq03iz#�8���d,�l������e�L<IT�	n~y��Yi�CP6���z��`��c�*]P�.��	�-�$K �Hma6buČ�>� ���.`0>9c �̰���J�S��*�� ����W��#4�2x ��.�������?~�'U�Z�s��K"�X�#<�R\��YO�\U6H��cr8P_�#@P|u���`(�3�i��4�x;�En��� (�W"���f�&�U�ij�Q-��t�U�z�4D�La�I��6^��s��P|������<��_D%�R�D4�okq+���`3��ˤ Η�ßo__oo����O"'�p�u�y�#�4|���a�%u!ި� ���D�u��H0�Fߞ`��åj�K�NY(�4*�^��o��=Äv�2T�
dK�y筱�a1��S�bު#C��A��W'FP6xx�^OE��w��|i�)�XRH%�|�ӱUq>���Cۖ0Z<;=g��I-��Pe���j8A�ګS
�l�}��Ne{��!ŒՒ�u�������RZGw-�"�x�D�~�e
�b�t�ک'D��i���� ���Ѷw�$�G�o��c4sj��q_�t��Γ`�icxV��@4�S>1q�Lt4*h��5s�q�����Yߺ5)9��Ҍ|��B&��]��I�����zA�4���4��t�p|�N4��G�lC��
)�mڍ'5�1�������W71t�ՔH�.�"��qu,�uĬ{�Jh�S6� �q��o��������.3s�YޞBmu<0չ�#$���#��JG҂��JZH�݂� �
m���J��<z�A(�&��&L��`:�!��:z˝!�Po�Wvf�Y��m"D�g=���@��a��hXm(ʱT�%9<ډ"{73g�����LI�kR��9c�cg�{�BZ/Ay��*λ~)����#�� !�-:�&�
c�S��;X�
Xu���0'�t7T�nh�q�M-�viׁұ��O�����7���Z�L}��V���VKbXq���rҲ�=e������.h|�$2�9�L	��?B���]g{mxd:�$]hP�4���V�1�CP�g�W2�ia�69����RVx�E��X:�����%�4�R��徂����R�4w�l�jt;B�}�2���	��l�'�P��7$l�v���I"�^�&N`*�`_�Y ?�r5N�dHn��S�0�,ΰ�R�l<�S�d{i7E�WT��~��m�������I���u��\��=�Z���Q�L{ ��:*8���24�Vp�x�4�;��xJ~����`�d�]e�&�u<<չ� $�x���)d@P|+`HT=3A�.ֽsm`��&5��,�3t�%�*=���N0R�!(��I���L砇X��"_`+.�XV8�Dt脮c��F�5֡	U�2<�f{]�8?6�,B���ʌ�O� �P\	pб+��P�  *93}�f�!u�Ei��s�X�P\3���yAC��2E1aE��Cۑ��F_.��-#D3Nq͉�����u�����&'��;�7s�2�
��˗
WH��=�B��u��!B9�!�\z/t�ڢ�ڪ�ޙ���S�Zl9E�;SI�b�\K�.�΂���1��O*�1sC�]%'ڤt�ѾR?��\�O���UP�IA�^��X�1����it�b���L�y�w��5"Sଔ�@P6�������o"o9>ȃ��B=����GA�g)�O)�3�ݻ&=�'�yx�"4��r��GUJ�����N�0-)�VB㾒�dDؒ°M`�ingS�ZNPʵPe�h�&�S��#,�����˨����}���y5�������gA3͉����4��O��7Sp7�f8�&e�3�;/	
B�*]�ݼk�����ٶ�Ǖ��ܜC����%�0�$XG���M@�����=��8=��mĦgư�J�����᫂P\�*:/�m:��h��u���c�i������hB��#R��Fh�YdдNN;���Q���4#�3�ܶi=�߲]DR-����	��1� �d�2��ZiXn/U�6�R�A�b�b;�ژ�f4�Q����}
g�`�*��R�b��GJhn��1�CP�X)�䖋��f�,c+�|y����b(��hu{��l$�P�.�_e{��.�fj����a�d��4G�4QJ�#,΍�h:.������{�#G����Ğnk�\��� ��yђ�zFҦfw������~�zx�������a�B9�<ĳ��͘oHf�ކf͖L[�r�k�:��1��(��vqR�X���<�+!V)�m�h���{Jq8��4�� �hH��)YFڄ��e����m��4��Ι�����A/k���X�u@�CCp���M��AK�90�.�����v����l����"e��7�/�ڰ���!��������"5�l��$�*�$�<��Č��6��-㿞O*��l�t�0��4����4UP���AA�o1����9�MXEaNsw��lY�6�I�9']#������̠�������=B�=�ѣ���*�*�k��4>��\��;c|�e�.?��SH��k�W�O�~���/S�WvA�=u�pl�:/k�*��A�*��^)(D�;�Ҍ���k�lKJ[p�lK��;�X�	��3"� �H�a�薢�$VL�2�$P��j�^x�< 4��/�h4��\�Μ�����[4J�dl�����eNq���D�4�=�Y\$P\��IQH`(�E����
"w��f�Â);?���[c�9QI�Ќ)/_�za�s2�&P�νJ>"�}DZ�H�X�K����R�Hq3�3:eK�otR���h��04W������xx���c�..?��S<�M�IXU�e͑dL�t��7C+�R��I�f=Rë��F�b�K��}�
�	e�:�[��tKL���4�j��N?�1���Y��Q@�����g��� 7�lO\h1t^��e����vػڧ���CJ�j�n�&([��v(��������wS>!qqӎ�fI�M�˓�����)-�U`T;ٶ�Z�@���\q��C'�����W91��3`�xK��ܽN�'��BaL�!�/�����0`t���`��G��!��ǫ����a`x^���diD_~�<�δo�__�O-�Eg�(Bj�
t0|하x�r`����w��o/ߦ����˧�"c���.�t��)�Dt��xgE7ՊQ][�U\���\\��IQpE�g�?߾���L�7\�]~vwO�کI@�4��"���ox�R����e$SO-�������������v�����o�/�����C<��&�/���l�Q�Ѧʅ��[�C�n�n�:�8
c����%�;���]���{Y�"XǛQqR��N~�����:�Mh(S��2z��x��("W�8,��$ܥ�ĕ|:f4�ڼ�&�a&S�_�NZ�F�0�k,<�ů}}{
ф�2UؒP:wWv.�m�׷�sTrϦ���|��+9z˷xT���l��2�ǧ������Ox;RJ|үg�.��g�4���?���/|y{�?=}{�'���}���{<4�E`�Wm[q�3�D�?继�%��:�7�hx��p�]�襕g ��J6z�ܺ�,�
FLL��ҹ�ӣ2%�@r�%޿�� Q��S�C��H}T�I��1�J;[O�dV���>��d����zTEnEk�*͂zU�=�3*��G�C��啽�����=�����WA�� a�v����W�~����ڏ��+�,Kh�/��>S�tCBVPL��r�����H���v�(�٦{�N�U���L�+��&!1��4����{�Ǘ����9�U��� �  .�&>�}$pw�l�b?LAW�{�x���9�������K�ݞ��j��O�#�*��ϝIS�Q��?V����)��@�cx"�u<C=瓓`8 �p��>3����:m�xҹ�������rHG�U��##�����8�`i(�64�ԙ}��
Fh��4HOK��D���Y{�o 6��`�� ^p�d8T�����Ŀ4>���4҈�z)%*�=<Lt����^�Dz�X���8����
���ZINOX��߿�LD�eaSW9�R���n��M���Y��&�œ���(L�v
kr�ݓ²\øvXPj��W"Ҋ��碭�jA��xw������7�NP$�J'�0�9�Ff��>@���o��Uc���2o�����g�9[�n��o�3 +����htW�Q�z}ѨJ�ME���7Uߞ�WV'2����Q-�cPcC"�&�4074������>I.u���3>�*daUbw4�� 	��u}xjV��C����W-jG 6��|��]M	 *F��C�#(�M7�j�e$Ӥ��H�6k兆w�E���\d��IS<A���^�4�5��Aq���=�J!������u"x�	���"�Pr� ��Qu@�N�0��č�N����`����1�LP�eh�pW���M�*-[_R����90ur���q垠�¬q4��Ʈ���S����v�����q��������.����$H�A�����=��`�<&��EB$�0�VD���=Am܍Y���ۀ�JW;0�s��.%��t��.^&�ۘ�ӓ&��Pߌ ��!㑲R?Qŷ�(ݍ�)���EP|o�T3�&�����j<ʃ0�V�4��X(al��_3j���������͝F�PT�mp�mΉ�v���~J������_I�S.���Š�~o�H��W��{uɨ���]�Vj \�;��a� ��3l3��&�:�	8��b�b�:!"��"Ҩ�Fb*f�o��t�/���E����������/�_��_���F������/���?�� ,�X;- R�j�b*^j��t<��>�w��>8N��>�<�����?�������K� V�w����T��������:ь]�Q k����˚��[��zYM����ˇ�V�]k����t���v�]�J����y�T��ܽ|x��d,����p��~�OH.|�$����9�'�%�*�R��z������&���ϷI��h7,3Q��Y��݄K7��9�X��F�!��b-�ź`�\�w�"_%5�^-�t�qU��'�Y4% H)�X.���/K��@d��]I�5��ȭ��e//������
>�ׯ�>=��^v���ǻ���ߣO�����'T+:��O-��)ZGw��l�sC6*�1-�e�V�H�#Z X�CeyT ��XT[���r����eK$��X#���xBodN�eW
�����
͸�%��eт�{���Ke*0��!p�;_�n��1o?�\Y��J�8�	����x�Կ����h�]����������ɭ��Ϩ�w�J�\��e��WdKxE���a�I�j��,�H/�N�\��+�F%[�J�JN�!T}���:9?�����E�궅�)���"�ഗv/c�Ѱշ8����&�Jv�d<�IX�&7�Q�
�q��E�ÕQ:a�iG�޺��U|��d�<e~��N��$H�ݞ2��}]��3*y���Å����� *�se�3�� �lw���X�O.����|�N�,�J�_] *Ql��NE���^"Q�[t�h��.��=��30yF�e���L̎J����:����ŋ6Sk�daW>���Oj�V7�aY�g���r>)��h�#@�J��L�����FZ�(�����i���*��U�PU�h�̶�P�Ē>AzYmr�W5�w(yO��k�M�D%��d���H�]�������O-~e5�m(z��"�^���Y���F����6	Q��Li��2	��§|�fD��=iU��n�K��s�=�t*9���uekt�u"T�h��v|&�gң���Ǎ���D�8W���D)��	�b.+�l��gVD$��Z��fڣ��,�OZ?1tp�/�L��g��B�r*)�����χ����������Ç��ù�tx�]�#�8.������q����*�'{^˻ht�
8���n�X�8�(�Q.���b�ӁJ�m����-�1蚰�U�+�D�aF)��-+v�+�uDύ,�+�������)-#�rE��ɢ�e/��|�&�)jϗPș+�	a����(��,�Q�F�^\B���J_u3g�Qy��o0�R�<{*�X?� ��VV%L4f{�4�R6]�I V�[{FT��c��>�P;�����Uy�ЯPxe���ߠs	JV�j��
U	�$74*�T|���5���F����oP��dT�f��et%�!��[�b��_D~�nUR���	X����K9�$,Y$�/���[gK��s%�Qy��/QG�;���l ��Y[x2��>�3&�4*Y�J>��F%��#HT2����%K�oB��|D%F���p���+z��/[4(�9���d��9o�4,�J(�Lx�����&�(Qo=����hH�,8̺c���}_hT�rqڕ��'j�f�`�"`���ZeMƛ�8�����(_tC���vѨ�YZ�s�-��-���ɨ|ĵ��.O�M�.(�'���!�,��m�2jYج\,%3t�o�F%"2n�4,w�d��%�xŢam����ɮ�6-R�'�J3Rd/#�2
4IT2F&�c��Z��!��:x�vY��mO�*	g"�BB��^�)�T��5��7��[V/3�����HHQ��7iT��'�΄���f`��)Р�lp��8�J�ai/,a�T>.�.t��@��P��1�"_���L�w�N��m�7K��1I�jo��J�ȷ7Ѕn�5�:mJ�|���(��Cw����w��^+��R�쵲��3���9�Oe�?�PۥKXu��J���d�� �g�!���z��"Te9ʈ�lW����u�{T���V�yW
�2���nԮ)��;��#(��x���9�"��:r. [���- ��$e�Yɻ�� �E��k�L�X�$�QL����0ך�#�7o1��9�ك��Y�L���RT;LZ�g�HXBW��� ��z0��@�e*��Bי|�&��8�� �GƮ��h�3���d��0t����"#�H�F��h��"S����ڇ�s�pQ�w(�`Yɀ�[��t/ZV�(���.�ٖ����)Y��������[L�rW�""��l��Jp
���k^�s]��j�����b7G\��4�!ܡ2�|�~��i^�s C��F��Mg�r˖U6*\5�M� -�/�k�,��\����6 ���+C��[$*�%4_4J����j.��K������E..a�[�a���#�+���%�<Ծ@�6��|��`�^���Ì���ݵ�;|�2�[��~��j
:�������ϭ�:Y䫟#F�o����֪_�*���1mR�3z� �Sg�����-�"�����i1B��Y��Cߤjɷ�%Z᭳<�����jڼ��[�x:}�D5�ہ�ҩ� h��;�K��hgY^[�0�x�����������������y}���^�#�Ƽy}�f.�6���h�Vv}�g�B���-��hX2�[V;>���R>����	`y�i�L�5�E�ƒ�du���4(�^��ӣ,q�O@��Y�f���@���N���%�^2
���%Ӂߪl��w�����`��3�􌍾�p`?*[��J}hT����3�F块�dG����3���+i.f{)=]�4Ք����&�R!#��;���M���7)��1�-hj�"R�+�<��S6B�K*���_��� �F_      s   ~  x�m�Mn�0F��Sp�T���T(�$�
 u������ԟdY�Ï����47-1m�I��v��|b�X����t�����4ˀL�@c�yi'd��L�H�\_r�$�9+ce�8ù�G��
2ј�snؤK��0t����$�!��w=��A(��rt��n�%'{ �ӈ�-�d����>�s#qv���Vѣ�!�8�D	�D?P�����Ou�$RsKjN�8=�o$y�Dbi�~�N�?n�g��5��
�IWI�@L$�׺N�tY����0S�y�[;t�,�o����)��.Z z��r9��~n
�6|c�E�v�����Tc�jHy�S��ݔؖ�'$���
�ye#8gL�F�7�_�j~ҍ)������e[�Ö��R�A�t      �   2  x���M��J�ל_ы�����ՠ��"�`�(""�*����[�43s�Mm&b=���oʲ�ܟH�B� @���#'��C����`��/@����9��<��d+\�����3��|���n������q.��IPK��|��A���D@7ؘ���ݰ0� � &z����<ϫ�P�����'���/���(�1�|��|���\���l���8:�i�]A�ͼ��v!���ҝ
^t��;:)�u���TD-X,v(�@���,b(�e8�#�?ᕏ?�g_�O�P\��%"�  �$	(�$	�p��D��2����H|w�_����B��j�__�����a$N�_lMa���d��C�����Tu(�pm	�㾴uf}S�(|��7>�ծ��ANϲhu�������]��L��Hu�h��# ˸�[�^>�u��F�)��7IB������w�n�x�����~��k/
<������(��ĉ��23����'�:j��rA�C`����P���骈�I�o�T�2<�F?����+Z=�W�6aϽ�p;"�aĄ�;|��$��mO"�+C����X����U�za*]���3�E��-�^�t���x]�]�}B��i?��.�[�^��44���Qb:�l�=���\f�CbB_~2Q�!}z*�EwGx��t.My��9p�m/΀����n���y[�&���y������N��M�'�D�5揀h����<Ek�W��S���[F��ʑt\�:�qWe��3v���F�Cwq���u)d:���Ƀ`�\O���Ô!*�z'D,QB��"�"U���ޝ�Ag��6Em.�SE�
{���_��.C�/�Pw��	�� ��V?ut�X�{�`��R�:����OW�:���d�@:-��v�A�Yv��+9[Ƒ�y"�3ayQ�x�Jyt��EuЏc�i{e"ЛL&��$W���4�5a�i(���_$>x8�'�t^rz�5��1��z/����O
YC��dmO&X2��7r�-�O�"_;�Ҳ7����n�Cc��ױ�3^`�'���Za�ٕ�#��T�i�?�����5ڞH�6��+��#� �Iʳ/!��/}�*��^`�hc�#���=뙄�����3�&q^-����&�r��~�H\�$m��� �f��0}�%��t��tT@;v&�&qFJ�C<>%`�]eB��� �r����7n���O��l!�h��(��n�=[��������c+�����@!���a\�y�(�I�F��Ax9�z�j�Ŋ�QLW�H��P��� ��Ԙ�@�+t|%�^m�5�"���+��E˩�7�\�(�ud)�U!�I#ݹ=��4����7�,7�X�!���;����]d`� "U�!�h{����oF���+M�����k�����6��MKoh��8�-gY�[�ĹD_Vm�t��=�]�{����W P���o[� �� MbE�.��1a���u�
k�SD�MySM�9 �8�M�x�]v��)�̕#NmW�K����=$��/��q1/Ѫ�j�*�
��Eaq��+�!$�����UTs�̂s*k�v�N���%�j�{ꓗ����.��,����V�
/�����Y���
a�[�bzR�ԡ>]S�+[/�?�CZL�b�f<�&�Ig�z@\,NBϺ�WN%�YN���P��=�*�����O(�����WQY��f��Ao���+;��U�u�`����;�ɜ'N�]{*�צFU��F[-�J%�5��T4fH������*d��*�޹���2������w%z�:�l|:��trs�D�o�G�����:S���(J:`;dթjC��	_q��|RUu��������#���9^�o�I�y'|�ܻ�wP��i�8���m��9��=��	���1�a��	����Ga�ڐK��^���C��*��.�tKٓA���� n�T{E.-�H��03�C�S��T!��2�a{�_Ҝ.�����*P�u��������t{D�Ŕsp�䅾���ۄd�XXw7�{���ť�o��l݆�$`Q��~�s��� U����_�~���'N      �   0  x���An�0E��O��2��Yz�s�DSM�E����,��K^�T��{��h�#EÔ����M��)���Hu�0�j��+y2�q�}Ӗ:�	c�F캪1��ݫLc3��i�1�c���:�a�F�M��G5�1�{�=;x1x'vd[�>��s���I:V�Ӿ|[�38���Z���$K���18�Ҫ[�t.� YZ����diG���^�d)5���0Ēe��g��dY'^c�~���sr�R�&�ۑ}2�����&�:�c�?w�]����&[0��]�T��Y�C����8��z:�������-      �      x������ � �      �   `  x�u�ˍ�0�di ��O*b+H�u,�,�&��&Y0ߣ	, x�����a�-�I+��`�{k�W����q�o⊡8��=����c��AC	0��<~Te�Y��V�0�3o���A+�J`�{�uV��V�	}���0���{s���S�I��b�
νg[��;���ދ=n�;�5��ˑŨj��y��]���.�>/������x���=O�YZ���fi�ϋ�7���d���>/�>�����Eמ������՞�g(���'>��Q��3r��?�,mH�yƱb��-<��f�C+�Yڰ�7�4<�B{��a�6�y���k����,m��"�ǎ͝G^1|� �GR      �      x������ � �      �      x������ � �      �      x�ŝ˒�6�Eו_�?�ep�;���X�i��Lӛ�,���߆d��xd&��K�T�*Ƞ_8��a���Р�#���t)˥�����Ə���U�џ�cy������������������w���/�G�nZ�c��/��.i��PL���!����������'���r28�/��S�r*8�/G�/�� ��b�͟>)@���A���C�>Ad�*��,�Yx]�=��
� {���A�(� �2�exeЍ2�^A��H�{���S�A�3ʠ�3ʠ�eP��2h�� �2h��2h��0�:�`��1X��&��[��;P<܃�O��`G1v���u���w��b����;��33l�}A���{�p�'�x4��Q����|�ae�<*��^�f�lH�.u�<��x��~��Ze�}���1����t�-�vEB;�BF���[%a:����ji�O���{����o�+�z<�pς�<^�ŇP���:�o��\���ȱ�\�h\R4^6���$ō 6�>������lH����� 8�:��XX���%�iKa����w�ｙ'�C|����&|� �����>}tp����#���5X���}t	��	r���wA�<uA�<wA��t�`}��� Jк�G�^�����WWp�Bd�r[.�\,�,&�������E.����2_\ٶ��l���E��\�a�݊=����'���7������:�����Ν���?�[���_�����2�+7��?N�|����7+���k��G8F�pL��͗���`',|p?� O'�3��[u/���U9
^߳�r����w��G\JڸT]��T8Ī��U����h�W48N�8��s��P�6�E�C��x�kcd$��=�={��l�f���$�.@�q$�AW�����vOe����E{�X8�؈:��6g��Fl��"!����	脻ޮOd}å��-�Z6��.7��>hl;ֲ�.�ڵ��kl��R��t��W��@G;�BG'����@G:� mt4$�:�m�Z5�������1i�#�Y�1��Ho~4<қe]Љ��3�,�$|`O�r�	g�Y��p����p�M�p���BC͚�j�$�rЂz���%@��� ������?�<I'���w����c�fs�G��f{�G���lp0����Z6�X�ž\�#�w���0��K�v
���_� ��?v����
j�Q��.q비uJy���e�[���
��^q絹s����NpE͉^��8�>~���<)��$���\c}����NI�j�s���܅��ϒvC�K��V�n��wC`5�R/DĪ/��V��*��T�!��K�"�A5uL>!8����K"�"9����p��z<���'=�����]qE�_E(�b�X���tC8�����0=�n��z7LOS'DA�mi�$̂��"-;�+;vs�����H|-��F.1>��m`��F���e�Q�F�Yl��am�m\�Įе�l�Z�&�W�ZU>�V#�]k��,6t�:�]��φ�m��6t�>�V+�-xѥ~�A��KVZ�ܨ�^w/�w�D��&:������Q��A��O�#.R+�eC��6)�<8v��v�6��n�Ŋ��	p�N�;�~<�N�g��	�x��Ӳ!k���&G��w�S���]���I�b�Gm�ﺇ �B%U�T�VeR�AZ#��=ӫ�ԟ�h/�AO0�
x�Ñ����9�
�Vq�H[R����%� Ǵ-vӶ�	pLےN�cږ|Ӷ���|8r�T�	p(\S&z�Lr����5��<8������pMv?�k��yp(\��σC��
�f���P�6ϟG/fm3�ip�Ll��\9E�f��8D&�	p�L����N�Cdb>���8D&V>����	p��mE&��n!ZE�V�x"cv"c~"c�8D��	p��>U��8�K�I��z�k�3E[u=��x"�v"�~"��8D��	p�����d���)!=���!e&d���V���n����">܁;�+�:��:⮅}��7E�h�޴	�$4��W&�a����t��a\%�тD+Y�b�H-i
ϧ�5�@�
h��:����]�d����5T�X)�����&S��[�/�/;�E�� ځ�tt�������DGW�3�B�m�o�]+Ё��@��#���F"y=�*�����@Gに���pU:��������Hhh�:�DGC�5��Huq-t4Ԭ	����|a�e��\�iD��ߜ����#�k<
!�JGCHc��!���hit:B!���FF��BGCRl�iSǠ���Y�$4����A���ٞ2�c�P3�S}j֞KBC�lO�!h$���)>�jO/�am�����ѐt4�=���]��Ѱk�t4�=����]��ъ=vs6�z��F���l
a���)h��nΦ`��9���F���l
a���)h��jf�њ�j!�#���=�2�]��î@Ǡ1_K��1_��ј�E�h���h��bt4�kq:�
��h�*Hf���ﶧ	�1��'�[����F#�ٽ����]s���vۊG*�'����I�hhx�t44<ONGCRR��!))��H�T�hx�M���:5�{V=5�{V=5�{N�;��{Έ;��{Έ;��{L>��J�{L>��[����ԁcа��h�u:v]����R"/�5+NGC�J���f%��h��M;m	Kv|\.;�!)5�ѐ�f+����T��!)5�ѐ���0	I�NGCRj��!)5��؊�Z�h�Yݨ��h�^�,�@GG���6���v�#��6::�tt:���LF�]R(t� �U�Ϗ�<5�@GC�D�h��(5�HGC���h���98������Ѱ�m�Ӱ,�.��а�m�S
v�BGîU�hصF:vݶ6��#�x�� m�H�����^��b@Ϙ���S����m�L�q(�:�w��������F��-i��!�q�7:\ѽ"�ڮ����F��!�1���ht4�+f6UN):�R�8K_4e?��=���Aîm�yǠa׶紋cаk�s��1hصW���sq���9��4����qqV�)��)�rAϗ�Аt4$Ņ�����ѐ�t4$�)�b�!)�t4$�I��F�q�Ȋ�nhHJ
t4$%	IIJGCRR��!)��hHJr:��II��F�pJ����]��Բ2�����j�5�BGCͲ��P��h�Y6:j���F�pʅ��]�Ʈu9�ږ�Nh�u	t4��.JGîKd���7�BG�5��3I־�ҩ�ƐS����xͪ��x�j��1}Tc�����?Û��mn^��~-���^�}rTkf�wI�����Y���@�@*���!qF�G#�qN�2!��k3��.㣐��xK�=	q|胗�vOu+i���E����/*���4���@�T���OcC�@Ξ��o��k�8}9�ߩ:]���DF;�kܜcֆ��6���O�8�}��Sk�[��k�����:-���l|<W	���~o�l�8��d�����)�5�u�Dֶ�"	����@��V::�����hg��Z�(��M��k������1h��:j���$��f�h�Y�ߒ������P3�t4�̍�������_�Jv=��r�	Ii{(�А�&��BCR��M$4$�m�DBCR��M$4$�m�DBCR��M$4$�m��A#����Hh�YڪYYѽ|3$�T�h�Y�t4�,:j�����e���f9��P�lt4�,;�=�5�5S������1hHJ�t4$�:�R������!)%�ъ���^
��rR�Z���A���
����M/N�]�P�K
�2ik���
���S�?���G��x��#�
]6'�:B����$6��m�섎@�.F�n��ۈR���A�Ƞ�QG�����$�D��LFOg�.��F�L���|
k� �	  +��ӽ�J��3w������l'���H��7yX����fh7��}g�j���
�w�WyY�I�E;���#��� �H�����<̖�mJ��я�xY�������?�V�L�Etz�崄��41����^�ҬlD�n�vCD����(��vC\�'vCd �� �K,X�m��]��¥2�WK�uDl���^䯦��%�:"j7�bz�C7�!��vC$ b7Dº!
������iۺo]rI�%��K7����<�N���.5�J��[��e�v�\����G�Wh���N[(�
m���zI����,�A+˃�X�HM���]�����-������j��*��=n�s�QOY��c8S��>�а��4c��y%���2:��T�,������G�EFڑ =a]h^���яR����'����J������� �\�8沘N���b��='�x��ӈVܗ�np�y[@���-� ���� ����48켍����t��4x�� �µ,8\GiKhp(���ph$%~�¡���	
�fR�'(�I���ph(%~�¡���	
��R�'(�J���ph,%���Ɵ�M@����Iz
��	p(\����N�CdR>�I�8D&U>]�$�����Z~~��Qp�L�s��Qp�L�s��Qp�L����N�Cd�F��Cd򞓌��Cdr��#Z��g$�+33��D�/����G�ƙ�n?�m���w������޽�����o�nBڬ�8qM���v�3ؙ�.`>�|�t6\������,�m�����F�B[+�bC[���Ж��lhK�|6�%:�P���@�t����QY۫��M�`���)�l"�L޶�Ŗ�	[.��Ƞiz)>��mx��4�ɽ�0��ʣ�R�2_��0�
���c��A�L��jL���Lj51�ԭ6ՕZ[j���,�-���[�jaR+��Hh�&�$¤B�D�Th�D&�$ƤB�ęTh�$&�$m��^���ap4�(���pU�u��p�NR�\�T*U��˅F�p�P)U.:��˅R�q��*u.j��9��Õ��8�T��*�~W�Ts����9拖i��W[�7/(ӒMk]���=Z@�Ts>�����K�⥾)R����i��i��a��_��O5�g�xi6D��uL�e�̀d�)��XC��Η�Vkf��˥sm��`*�J��R�%��X��K��j:�~-�
�J�'�H��k�xa�b'��X�8b�%� Gd�99��,,5� ����	�RIA�'��7��Si�o��9d�����k^¦p��,�^`8����{St$�(L�!Ѝ´�(,vC�ES�s4�(�;!<�ҮA(���������B������y$8���
��N���}	l�l��4B3�tC�N�vC�s솀�e놀}e��ax��e��+y�Q�b�`ިvIy0oT�p<v?�pe�;{̺z̺q��{����5̲���~��\!R���S��hʤ���E&�͘T4_4gRя���3I�l��m���}��	���_]V����q ((e�@|�>�_H|� ���O6��@�b������'QCZ��_�&֐�j�q$����qj��ӛ�ưmè�����D0��-�i��b�^�����01�X�G}t����}Jůo�HuLi�T�`.L*&RW&�G&S�;��)��
���9u;��`2�����`&	�n:��7=�/��l���}+�iw�|��ۇ\yaR!W^���J�I�\%aR!WI�T�U�L*L8�
�LΤB$S�Q�1����������� ���4{<��9�"�{�bj��ok`���
���M�k��5��Hr�#��<��?���Ǳ�͋!O�Ǆ��Jcb�{m�@`B³�0���1,�/�LW�ͣ�r�l��y1��k�r�	i-�0 �m�ї��,7�:�G��@3�4e�M�ax����<�3�w#����?��a��YV�~�Y���~���E}�_��;OC�䮇9��S|�O�yL%���Cx2��?�8��R��e�[y=�@��,�C)���(����!W����R�nĕj�@\�Z7����p#k���1ls鷒���^������݃p��R݃��ۺ܃p��"܃��ۊ�cW�<l7�Â8�.P_lۮ
�w�1?W�?�Nwa'-Ȟ�_��88G7���]��꾅�����f�!�i���4��������ʸ\�m�!��M���g�:8��M��A��6����g$ܜaW˕^����H�NF�Xd�bY^��GlH�)���?�z�`	^�Ǆq�13܋��3�5�Lk�����NL߻�W����pAr��0���ҭ?�	�pSr��0|n�8�-�_��i��"ҵZ�;Ø��a�i�E�|gS��n�����^��������a�����/cz7
�Œ�5�2u�ݓPF�������^ny�     