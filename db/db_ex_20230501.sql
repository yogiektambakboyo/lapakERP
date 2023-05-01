PGDMP         4                {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
                        false    2            i           1255    34652    calc_commision_cashier() 	   PROCEDURE     �  CREATE PROCEDURE public.calc_commision_cashier()
    LANGUAGE plpgsql
    AS $$
DECLARE
   begin_date date;
   end_date date;
	begin
		begin_date := (select case when to_char(now()::date,'dd')::int>=26 then (to_char(date_trunc('month', current_date)::date,'YYYYMM')||'26')::date else (to_char(date_trunc('month', current_date - interval '1' month)::date,'YYYYMM')||'26')::date end);
	    end_date := now()::date;
	   
	   	--begin_date := '20230101'::date;
	    --end_date := '20230427'::date;
		delete from cashier_commision where dated between begin_date and end_date;
		insert into cashier_commision
		select branch_name,created_by,name as created_name,invoice_no,dated::date,type_id,id,com_type,product_id,abbr,remark as product_name,price,qty,total,base_commision,commisions,branch_id from (
		        select  id.product_id,b.remark as branch_name,ps.type_id,'0' as id,'work_commission' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,'0' as name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions,b.id  as branch_id  
		        from invoice_master im 
		        join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
		        join product_sku ps on ps.id = id.product_id 
		        join customers c on c.id = im.customers_id 
		        join branch b on b.id = c.branch_id
		        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
		        join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
		        where pc.created_by_fee > 0 and im.dated between begin_date and end_date
		        union 
		        select id.product_id,b.remark as branch_name,ps.type_id,'0' as id,'extra_commision' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,'0' as name,id.price,id.qty,id.total,pc.values as base_commision ,sum(pc.values*id.qty) as commisions,b.id as branch_id
		        from invoice_master im 
		        join invoice_detail id on id.invoice_no = im.invoice_no
		        join product_sku ps on ps.id = id.product_id 
		        join customers c on c.id = im.customers_id 
		        join branch b on b.id = c.branch_id
		        join product_commision_by_year pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
		        join (
		            select r.id,r.name,r.job_id,case when date_part('year', age(now(),join_date))::int=0 then 1 when date_part('year', age(now(),join_date))::int>10 then 10  else date_part('year', age(now(),join_date)) end as work_year 
		            from users r
		            ) u on u.id = im.created_by and u.job_id = pc.jobs_id  and u.id = im.created_by  and u.work_year = pc.years 
		        left join product_point pp on pp.product_id=ps.id and pp.branch_id=b.id 
		        where pc.values > 0 and im.dated between begin_date and end_date 
		        group by  b.id,id.product_id,ps.type_id,b.remark,im.dated,u.work_year,im.invoice_no,ps.abbr,ps.remark,im.created_by,id.price,id.total,pc.values,id.qty 
		        union
		        select id.product_id,b.remark as branch_name,ps.type_id,'0' as id,'referral' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,'0' as name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions,b.id  as branch_id  
		        from invoice_master im 
		        join invoice_detail id on id.invoice_no = im.invoice_no
		        join product_sku ps on ps.id = id.product_id 
		        join customers c on c.id = im.customers_id 
		        join branch b on b.id = c.branch_id
		        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
		        join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
		        where pc.created_by_fee <= 0 and pc.referral_fee > 0 and im.dated  between begin_date and end_date
		) a order by dated;
	END;
$$;
 0   DROP PROCEDURE public.calc_commision_cashier();
       public          postgres    false    7            h           1255    34653    calc_commision_cashier_today() 	   PROCEDURE     �  CREATE PROCEDURE public.calc_commision_cashier_today()
    LANGUAGE plpgsql
    AS $$
DECLARE
   begin_date date;
   end_date date;
	begin
		begin_date := now()::date;
	    end_date := now()::date;
	   
	   	--begin_date := '20230101'::date;
	    --end_date := '20230425'::date;
		delete from cashier_commision where dated between begin_date and end_date;
		insert into cashier_commision
		select branch_name,created_by,name as created_name,invoice_no,dated::date,type_id,id,com_type,product_id,abbr,remark as product_name,price,qty,total,base_commision,commisions,branch_id from (
		        select  id.product_id,b.remark as branch_name,ps.type_id,'0' as id,'work_commission' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,'0' as name,id.price,id.qty,id.total,pc.created_by_fee base_commision,pc.created_by_fee * id.qty as commisions,b.id  as branch_id  
		        from invoice_master im 
		        join invoice_detail id on id.invoice_no = im.invoice_no  and (id.referral_by is null)
		        join product_sku ps on ps.id = id.product_id 
		        join customers c on c.id = im.customers_id 
		        join branch b on b.id = c.branch_id
		        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
		        join users u on u.id = im.created_by and u.job_id = 1  and u.id = im.created_by 
		        where pc.created_by_fee > 0 and im.dated between begin_date and end_date
		        union 
		        select id.product_id,b.remark as branch_name,ps.type_id,'0' as id,'extra_commision' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,'0' as name,id.price,id.qty,id.total,pc.values as base_commision ,sum(pc.values*id.qty) as commisions,b.id as branch_id
		        from invoice_master im 
		        join invoice_detail id on id.invoice_no = im.invoice_no
		        join product_sku ps on ps.id = id.product_id 
		        join customers c on c.id = im.customers_id 
		        join branch b on b.id = c.branch_id
		        join product_commision_by_year pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
		        join (
		            select r.id,r.name,r.job_id,case when date_part('year', age(now(),join_date))::int=0 then 1 when date_part('year', age(now(),join_date))::int>10 then 10  else date_part('year', age(now(),join_date)) end as work_year 
		            from users r
		            ) u on u.id = im.created_by and u.job_id = pc.jobs_id  and u.id = im.created_by  and u.work_year = pc.years 
		        left join product_point pp on pp.product_id=ps.id and pp.branch_id=b.id 
		        where pc.values > 0 and im.dated between begin_date and end_date 
		        group by  b.id,id.product_id,ps.type_id,b.remark,im.dated,u.work_year,im.invoice_no,ps.abbr,ps.remark,im.created_by,id.price,id.total,pc.values,id.qty 
		        union
		        select id.product_id,b.remark as branch_name,ps.type_id,'0' as id,'referral' as com_type,im.dated,im.invoice_no,ps.abbr,ps.remark,im.created_by,'0' as name,id.price,id.qty,id.total,pc.referral_fee base_commision,pc.referral_fee  * id.qty as commisions,b.id  as branch_id  
		        from invoice_master im 
		        join invoice_detail id on id.invoice_no = im.invoice_no
		        join product_sku ps on ps.id = id.product_id 
		        join customers c on c.id = im.customers_id 
		        join branch b on b.id = c.branch_id
		        join product_commisions pc on pc.product_id = id.product_id and pc.branch_id = c.branch_id
		        join users u on u.id = im.created_by and u.job_id = 1 and u.id = id.referral_by 
		        where pc.created_by_fee <= 0 and pc.referral_fee > 0 and im.dated  between begin_date and end_date
		) a order by dated;
	END;
$$;
 6   DROP PROCEDURE public.calc_commision_cashier_today();
       public          postgres    false    7            f           1255    34586    calc_commision_terapist() 	   PROCEDURE     X  CREATE PROCEDURE public.calc_commision_terapist()
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
       public          postgres    false    7            g           1255    34591    calc_commision_terapist_today() 	   PROCEDURE     �  CREATE PROCEDURE public.calc_commision_terapist_today()
    LANGUAGE plpgsql
    AS $$
DECLARE
   begin_date date;
   end_date date;
	begin
		begin_date := now()::date;
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
 7   DROP PROCEDURE public.calc_commision_terapist_today();
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
       public          postgres    false    7    206            �           0    0    branch_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.branch_id_seq OWNED BY public.branch.id;
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
       public          postgres    false    7    208            �           0    0    branch_room_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.branch_room_id_seq OWNED BY public.branch_room.id;
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
       public          postgres    false    297    7            �           0    0    branch_shift_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.branch_shift_id_seq OWNED BY public.branch_shift.id;
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
       public          postgres    false    309    7            �           0    0    calendar_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.calendar_id_seq OWNED BY public.calendar.id;
          public          postgres    false    308            S           1259    34637    cashier_commision    TABLE     g  CREATE TABLE public.cashier_commision (
    branch_name character varying NOT NULL,
    created_by integer,
    created_name character varying,
    invoice_no character varying NOT NULL,
    dated date NOT NULL,
    type_id integer NOT NULL,
    id character varying,
    com_type character varying NOT NULL,
    product_id integer NOT NULL,
    abbr character varying,
    product_name character varying,
    price numeric(18,0) DEFAULT 0,
    qty integer DEFAULT 0,
    total numeric DEFAULT 0,
    base_commision numeric(18,0) DEFAULT 0,
    commisions numeric(18,0) DEFAULT 0,
    branch_id integer NOT NULL
);
 %   DROP TABLE public.cashier_commision;
       public         heap    postgres    false    7            �            1259    17933    company    TABLE     r  CREATE TABLE public.company (
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
       public          postgres    false    7    210            �           0    0    company_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.company_id_seq OWNED BY public.company.id;
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
       public          postgres    false    7    313            �           0    0    customers_segment_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.customers_segment_id_seq OWNED BY public.customers_segment.id;
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
       public          postgres    false    214    7            �           0    0    department_id_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.department_id_seq OWNED BY public.departments.id;
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
       public          postgres    false    7    221            �           0    0    job_title_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.job_title_id_seq OWNED BY public.job_title.id;
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
       public          postgres    false    316    7            �           0    0    petty_cash_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.petty_cash_id_seq OWNED BY public.petty_cash.id;
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
       public          postgres    false    7    240            �           0    0    posts_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;
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
       public          postgres    false    7    242            �           0    0    price_adjustment_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.price_adjustment_id_seq OWNED BY public.price_adjustment.id;
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
       public          postgres    false    246    7            �           0    0    product_category_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;
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
       public          postgres    false    254    7            �           0    0    product_sku_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.product_sku_id_seq OWNED BY public.product_sku.id;
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
       public          postgres    false    7    262            �           0    0    product_uom_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.product_uom_id_seq OWNED BY public.uom.id;
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
       public          postgres    false    268    7            �           0    0    receive_master_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.receive_master_id_seq OWNED BY public.receive_master.id;
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
       public          postgres    false    271    7            �           0    0    return_sell_master_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.return_sell_master_id_seq OWNED BY public.return_sell_master.id;
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
       public          postgres    false    274    7            �           0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
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
       public          postgres    false    7    301            �           0    0    sales_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;
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
       public          postgres    false    7    303            �           0    0    sales_trip_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.sales_trip_id_seq OWNED BY public.sales_trip.id;
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
       public          postgres    false    7    321            �           0    0    stock_log_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.stock_log_id_seq OWNED BY public.stock_log.id;
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
       public          postgres    false    7    282            �           0    0    suppliers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;
          public          postgres    false    283            *           1259    18725    sv_login_session_id_seq    SEQUENCE     �   CREATE SEQUENCE public.sv_login_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.sv_login_session_id_seq;
       public          postgres    false    7    299            �           0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
          public          postgres    false    298            R           1259    34580    terapist_commision    TABLE     a  CREATE TABLE public.terapist_commision (
    branch_name character varying,
    dated date NOT NULL,
    invoice_no character varying NOT NULL,
    product_id integer NOT NULL,
    abbr character varying,
    product_name character varying,
    type_id integer NOT NULL,
    user_id integer NOT NULL,
    terapist_name character varying,
    com_type character varying NOT NULL,
    work_year integer,
    price numeric(18,0),
    qty integer,
    total numeric,
    base_commision numeric(18,0),
    commisions numeric,
    point_qty integer,
    point_value numeric(18,0),
    branch_id integer NOT NULL
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
       public          postgres    false    7    294            �           0    0    voucher_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voucher_id_seq OWNED BY public.voucher.id;
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
       public          postgres    false    307    306    307            �           2604    28176    customers_segment id    DEFAULT     |   ALTER TABLE ONLY public.customers_segment ALTER COLUMN id SET DEFAULT nextval('public.customers_segment_id_seq'::regclass);
 C   ALTER TABLE public.customers_segment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    312    313    313            �           2604    18427    departments id    DEFAULT     o   ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.department_id_seq'::regclass);
 =   ALTER TABLE public.departments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    214            �           2604    18428    failed_jobs id    DEFAULT     p   ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);
 =   ALTER TABLE public.failed_jobs ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    216            �           2604    18429    invoice_master id    DEFAULT     v   ALTER TABLE ONLY public.invoice_master ALTER COLUMN id SET DEFAULT nextval('public.invoice_master_id_seq'::regclass);
 @   ALTER TABLE public.invoice_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219            
           2604    18430    job_title id    DEFAULT     l   ALTER TABLE ONLY public.job_title ALTER COLUMN id SET DEFAULT nextval('public.job_title_id_seq'::regclass);
 ;   ALTER TABLE public.job_title ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221            �           2604    18730    login_session id    DEFAULT     w   ALTER TABLE ONLY public.login_session ALTER COLUMN id SET DEFAULT nextval('public.sv_login_session_id_seq'::regclass);
 ?   ALTER TABLE public.login_session ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    299    298    299                       2604    18431    migrations id    DEFAULT     n   ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);
 <   ALTER TABLE public.migrations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    223                       2604    18432    order_master id    DEFAULT     r   ALTER TABLE ONLY public.order_master ALTER COLUMN id SET DEFAULT nextval('public.order_master_id_seq'::regclass);
 >   ALTER TABLE public.order_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    228                        2604    18433    period_price_sell id    DEFAULT     |   ALTER TABLE ONLY public.period_price_sell ALTER COLUMN id SET DEFAULT nextval('public.period_price_sell_id_seq'::regclass);
 C   ALTER TABLE public.period_price_sell ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    232            )           2604    18434    permissions id    DEFAULT     p   ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);
 =   ALTER TABLE public.permissions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    235            *           2604    18435    personal_access_tokens id    DEFAULT     �   ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);
 H   ALTER TABLE public.personal_access_tokens ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    238    237            �           2604    30747    petty_cash id    DEFAULT     n   ALTER TABLE ONLY public.petty_cash ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_id_seq'::regclass);
 <   ALTER TABLE public.petty_cash ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    316    315    316            �           2604    30762    petty_cash_detail id    DEFAULT     |   ALTER TABLE ONLY public.petty_cash_detail ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_detail_id_seq'::regclass);
 C   ALTER TABLE public.petty_cash_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    318    317    318            -           2604    18436    posts id    DEFAULT     d   ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);
 7   ALTER TABLE public.posts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    241    240            .           2604    18437    price_adjustment id    DEFAULT     z   ALTER TABLE ONLY public.price_adjustment ALTER COLUMN id SET DEFAULT nextval('public.price_adjustment_id_seq'::regclass);
 B   ALTER TABLE public.price_adjustment ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    243    242            1           2604    18438    product_brand id    DEFAULT     t   ALTER TABLE ONLY public.product_brand ALTER COLUMN id SET DEFAULT nextval('public.product_brand_id_seq'::regclass);
 ?   ALTER TABLE public.product_brand ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    245    244            4           2604    18439    product_category id    DEFAULT     z   ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);
 B   ALTER TABLE public.product_category ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    247    246            >           2604    18440    product_sku id    DEFAULT     p   ALTER TABLE ONLY public.product_sku ALTER COLUMN id SET DEFAULT nextval('public.product_sku_id_seq'::regclass);
 =   ALTER TABLE public.product_sku ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    255    254            D           2604    18441    product_stock_detail id    DEFAULT     �   ALTER TABLE ONLY public.product_stock_detail ALTER COLUMN id SET DEFAULT nextval('public.product_stock_detail_id_seq'::regclass);
 F   ALTER TABLE public.product_stock_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    258    257            H           2604    18442    product_type id    DEFAULT     r   ALTER TABLE ONLY public.product_type ALTER COLUMN id SET DEFAULT nextval('public.product_type_id_seq'::regclass);
 >   ALTER TABLE public.product_type ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    260    259            X           2604    18443    purchase_master id    DEFAULT     x   ALTER TABLE ONLY public.purchase_master ALTER COLUMN id SET DEFAULT nextval('public.purchase_master_id_seq'::regclass);
 A   ALTER TABLE public.purchase_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    266    265            k           2604    18444    receive_master id    DEFAULT     v   ALTER TABLE ONLY public.receive_master ALTER COLUMN id SET DEFAULT nextval('public.receive_master_id_seq'::regclass);
 @   ALTER TABLE public.receive_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    269    268            |           2604    18445    return_sell_master id    DEFAULT     ~   ALTER TABLE ONLY public.return_sell_master ALTER COLUMN id SET DEFAULT nextval('public.return_sell_master_id_seq'::regclass);
 D   ALTER TABLE public.return_sell_master ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    272    271            �           2604    18446    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    275    274            �           2604    18739    sales id    DEFAULT     d   ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);
 7   ALTER TABLE public.sales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    300    301    301            �           2604    18753    sales_trip id    DEFAULT     n   ALTER TABLE ONLY public.sales_trip ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_id_seq'::regclass);
 <   ALTER TABLE public.sales_trip ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    303    302    303            �           2604    18765    sales_trip_detail id    DEFAULT     |   ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);
 C   ALTER TABLE public.sales_trip_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    304    305    305            �           2604    27183    sales_visit id    DEFAULT     p   ALTER TABLE ONLY public.sales_visit ALTER COLUMN id SET DEFAULT nextval('public.sales_visit_id_seq'::regclass);
 =   ALTER TABLE public.sales_visit ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    310    311    311            �           2604    18447    setting_document_counter id    DEFAULT     �   ALTER TABLE ONLY public.setting_document_counter ALTER COLUMN id SET DEFAULT nextval('public.setting_document_counter_id_seq'::regclass);
 J   ALTER TABLE public.setting_document_counter ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    277    276            �           2604    18448    shift id    DEFAULT     d   ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);
 7   ALTER TABLE public.shift ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    281    279            �           2604    33396    stock_log id    DEFAULT     l   ALTER TABLE ONLY public.stock_log ALTER COLUMN id SET DEFAULT nextval('public.stock_log_id_seq'::regclass);
 ;   ALTER TABLE public.stock_log ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    320    321    321            �           2604    18449    suppliers id    DEFAULT     l   ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);
 ;   ALTER TABLE public.suppliers ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    283    282            K           2604    18450    uom id    DEFAULT     h   ALTER TABLE ONLY public.uom ALTER COLUMN id SET DEFAULT nextval('public.product_uom_id_seq'::regclass);
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
    pgagent          postgres    false    323   �      �          0    34389    pga_jobclass 
   TABLE DATA           7   COPY pgagent.pga_jobclass (jclid, jclname) FROM stdin;
    pgagent          postgres    false    325   <�      �          0    34401    pga_job 
   TABLE DATA           �   COPY pgagent.pga_job (jobid, jobjclid, jobname, jobdesc, jobhostagent, jobenabled, jobcreated, jobchanged, jobagentid, jobnextrun, joblastrun) FROM stdin;
    pgagent          postgres    false    327   Y�      �          0    34453    pga_schedule 
   TABLE DATA           �   COPY pgagent.pga_schedule (jscid, jscjobid, jscname, jscdesc, jscenabled, jscstart, jscend, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths) FROM stdin;
    pgagent          postgres    false    331   ߾      �          0    34483    pga_exception 
   TABLE DATA           J   COPY pgagent.pga_exception (jexid, jexscid, jexdate, jextime) FROM stdin;
    pgagent          postgres    false    333   O�      �          0    34498 
   pga_joblog 
   TABLE DATA           X   COPY pgagent.pga_joblog (jlgid, jlgjobid, jlgstatus, jlgstart, jlgduration) FROM stdin;
    pgagent          postgres    false    335   l�      �          0    34427    pga_jobstep 
   TABLE DATA           �   COPY pgagent.pga_jobstep (jstid, jstjobid, jstname, jstdesc, jstenabled, jstkind, jstcode, jstconnstr, jstdbname, jstonerror, jscnextrun) FROM stdin;
    pgagent          postgres    false    329   �      �          0    34515    pga_jobsteplog 
   TABLE DATA           |   COPY pgagent.pga_jobsteplog (jslid, jsljlgid, jsljstid, jslstatus, jslresult, jslstart, jslduration, jsloutput) FROM stdin;
    pgagent          postgres    false    337   ��      L          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    206   ��      N          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    208   |�      �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    297   ��      �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    309   4�      �          0    34637    cashier_commision 
   TABLE DATA           �   COPY public.cashier_commision (branch_name, created_by, created_name, invoice_no, dated, type_id, id, com_type, product_id, abbr, product_name, price, qty, total, base_commision, commisions, branch_id) FROM stdin;
    public          postgres    false    339   �      P          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    210   �      R          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    212   ��      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    307   �O      �          0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    313   �O      T          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    214   �O      V          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    216   vP      X          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at) FROM stdin;
    public          postgres    false    218   �P      �          0    34018    invoice_detail_log 
   TABLE DATA             COPY public.invoice_detail_log (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, created_at_insert) FROM stdin;
    public          postgres    false    322   <      �          0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    319   ��      Y          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    219   2-      [          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    221   �      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    299   �      ]          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    223   �      _          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    225   �      `          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    226   �      a          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    227   g      b          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    228   �      d          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    230   �      e          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    231   �      f          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    232   �      h          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    234   3M      i          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    235   ��      k          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    237   ^�      �          0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    316   {�      �          0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    318   Ք      m          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    239   !�      n          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    240   t�      p          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    242   ��      r          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    244   ͟      t          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    246   ��      v          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   �      w          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    249   4�      x          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    250   �      y          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    251   ��      z          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    252   Ժ      {          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    253   7�      �          0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    314   t�      |          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    254   ��      ~          0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    256   ��                0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    257   N�      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    259   ��      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    261   B�      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    264   ��      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    265   ��      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    267   c�      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    268   ��      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    270   i�      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    271   ��      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    273   ��      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    274   	�      �          0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    301   ��      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    303   ��      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   ��      �          0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    311   �      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   )�      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    278   �      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    279   j�      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    280   ��      �          0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    321   v�      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   X      �          0    34580    terapist_commision 
   TABLE DATA           �   COPY public.terapist_commision (branch_name, dated, invoice_no, product_id, abbr, product_name, type_id, user_id, terapist_name, com_type, work_year, price, qty, total, base_commision, commisions, point_qty, point_value, branch_id) FROM stdin;
    public          postgres    false    338   �      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    262   �x      �          0    18363    users 
   TABLE DATA           J  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active) FROM stdin;
    public          postgres    false    284   z      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    285   ��      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    286   �      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    289   "�      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    291   ��      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   ��      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    294   ۅ      �           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    207            �           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    209            �           0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    296            �           0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    308            �           0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    211                        0    0    customers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.customers_id_seq', 1497, true);
          public          postgres    false    213                       0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    306                       0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    312                       0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    215                       0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    217                       0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 2034, true);
          public          postgres    false    220                       0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    222                       0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    224                       0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    229            	           0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2652, true);
          public          postgres    false    233            
           0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 515, true);
          public          postgres    false    236                       0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    238                       0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 397, true);
          public          postgres    false    317                       0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 55, true);
          public          postgres    false    315                       0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    241                       0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    243                       0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 22, true);
          public          postgres    false    245                       0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 52, true);
          public          postgres    false    247                       0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 338, true);
          public          postgres    false    255                       0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 25, true);
          public          postgres    false    258                       0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    260                       0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 54, true);
          public          postgres    false    263                       0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 21, true);
          public          postgres    false    266                       0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 32, true);
          public          postgres    false    269                       0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    272                       0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 13, true);
          public          postgres    false    275                       0    0    sales_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sales_id_seq', 1, true);
          public          postgres    false    300                       0    0    sales_trip_detail_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 21, true);
          public          postgres    false    304                       0    0    sales_trip_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sales_trip_id_seq', 4, true);
          public          postgres    false    302                       0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 1, false);
          public          postgres    false    310                       0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 52, true);
          public          postgres    false    277                       0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 12, true);
          public          postgres    false    281                        0    0    stock_log_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stock_log_id_seq', 5691, true);
          public          postgres    false    320            !           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 5, true);
          public          postgres    false    283            "           0    0    sv_login_session_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 71, true);
          public          postgres    false    298            #           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    287            $           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 89, true);
          public          postgres    false    288            %           0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 72, true);
          public          postgres    false    290            &           0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    292            '           0    0    voucher_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.voucher_id_seq', 1226, true);
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
       public            postgres    false    206            �           2606    26927    calendar calendar_pk 
   CONSTRAINT     R   ALTER TABLE ONLY public.calendar
    ADD CONSTRAINT calendar_pk PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.calendar DROP CONSTRAINT calendar_pk;
       public            postgres    false    309                        2606    18465    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    210                       2606    18467    customers customers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pk;
       public            postgres    false    212            �           2606    18784 0   customers_registration customers_registration_pk 
   CONSTRAINT     n   ALTER TABLE ONLY public.customers_registration
    ADD CONSTRAINT customers_registration_pk PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.customers_registration DROP CONSTRAINT customers_registration_pk;
       public            postgres    false    307            �           2606    28182 &   customers_segment customers_segment_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.customers_segment
    ADD CONSTRAINT customers_segment_pk PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.customers_segment DROP CONSTRAINT customers_segment_pk;
       public            postgres    false    313                       2606    18469    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    216                       2606    18471 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    216                       2606    18473     invoice_detail invoice_detail_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_pk;
       public            postgres    false    218    218            
           2606    18475     invoice_master invoice_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_pk;
       public            postgres    false    219                       2606    18477     invoice_master invoice_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_un;
       public            postgres    false    219                       2606    18479    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    223                       2606    18481 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public            postgres    false    225    225    225                       2606    18483 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public            postgres    false    226    226    226            �           2606    34649    cashier_commision newtable_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.cashier_commision
    ADD CONSTRAINT newtable_pk PRIMARY KEY (branch_name, invoice_no, dated, type_id, com_type, product_id, branch_id);
 G   ALTER TABLE ONLY public.cashier_commision DROP CONSTRAINT newtable_pk;
       public            postgres    false    339    339    339    339    339    339    339                       2606    18485    order_detail order_detail_pk 
   CONSTRAINT     l   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_pk;
       public            postgres    false    227    227                       2606    18487    order_master order_master_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_pk;
       public            postgres    false    228                       2606    18489    order_master order_master_un 
   CONSTRAINT     [   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_un;
       public            postgres    false    228                       2606    18491    period_stock period_stock_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);
 F   ALTER TABLE ONLY public.period_stock DROP CONSTRAINT period_stock_pk;
       public            postgres    false    234    234    234                       2606    18493    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    235            !           2606    18495 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public            postgres    false    237            #           2606    18497 :   personal_access_tokens personal_access_tokens_token_unique 
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
       public            postgres    false    316            &           2606    18499 $   point_conversion point_conversion_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);
 N   ALTER TABLE ONLY public.point_conversion DROP CONSTRAINT point_conversion_pk;
       public            postgres    false    239            (           2606    18501    posts posts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    240            *           2606    18503 $   price_adjustment price_adjustment_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_pk;
       public            postgres    false    242    242    242            ,           2606    18505 $   price_adjustment price_adjustment_un 
   CONSTRAINT     ]   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_un;
       public            postgres    false    242            .           2606    18507 6   product_commision_by_year product_commision_by_year_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_pk;
       public            postgres    false    248    248    248    248            0           2606    18509 (   product_commisions product_commisions_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);
 R   ALTER TABLE ONLY public.product_commisions DROP CONSTRAINT product_commisions_pk;
       public            postgres    false    249    249            2           2606    18511 ,   product_distribution product_distribution_pk 
   CONSTRAINT     }   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_pk;
       public            postgres    false    250    250            4           2606    18513 *   product_ingredients product_ingredients_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pk PRIMARY KEY (product_id, product_id_material);
 T   ALTER TABLE ONLY public.product_ingredients DROP CONSTRAINT product_ingredients_pk;
       public            postgres    false    251    251            6           2606    18515    product_point product_point_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_point DROP CONSTRAINT product_point_pk;
       public            postgres    false    252    252            �           2606    30130 *   product_price_level product_price_level_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_price_level
    ADD CONSTRAINT product_price_level_pk PRIMARY KEY (product_id, branch_id, qty_min);
 T   ALTER TABLE ONLY public.product_price_level DROP CONSTRAINT product_price_level_pk;
       public            postgres    false    314    314    314            8           2606    18517    product_price product_price_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_price DROP CONSTRAINT product_price_pk;
       public            postgres    false    253    253            :           2606    18519    product_sku product_sku_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_pk;
       public            postgres    false    254            <           2606    18521    product_sku product_sku_un 
   CONSTRAINT     U   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_un UNIQUE (abbr);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_un;
       public            postgres    false    254            @           2606    18523 ,   product_stock_detail product_stock_detail_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.product_stock_detail
    ADD CONSTRAINT product_stock_detail_pk PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.product_stock_detail DROP CONSTRAINT product_stock_detail_pk;
       public            postgres    false    257            >           2606    18525    product_stock product_stock_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_stock DROP CONSTRAINT product_stock_pk;
       public            postgres    false    256    256            B           2606    29118    product_type product_type_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.product_type DROP CONSTRAINT product_type_pk;
       public            postgres    false    259            D           2606    18527    product_uom product_uom_pk 
   CONSTRAINT     h   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_pk PRIMARY KEY (product_id, uom_id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_pk;
       public            postgres    false    261    261            J           2606    18529 "   purchase_detail purchase_detail_pk 
   CONSTRAINT     u   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_pk PRIMARY KEY (purchase_no, product_id);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_pk;
       public            postgres    false    264    264            L           2606    18531 "   purchase_master purchase_master_pk 
   CONSTRAINT     `   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_pk PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_pk;
       public            postgres    false    265            N           2606    18533 "   purchase_master purchase_master_un 
   CONSTRAINT     d   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_un UNIQUE (purchase_no);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_un;
       public            postgres    false    265            P           2606    18535     receive_detail receive_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_pk PRIMARY KEY (receive_no, product_id, expired_at);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_pk;
       public            postgres    false    267    267    267            R           2606    18537     receive_master receive_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_pk;
       public            postgres    false    268            T           2606    18539     receive_master receive_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_un UNIQUE (receive_no);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_un;
       public            postgres    false    268            V           2606    18541 (   return_sell_detail return_sell_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_pk PRIMARY KEY (return_sell_no, product_id);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_pk;
       public            postgres    false    270    270            X           2606    18543 (   return_sell_master return_sell_master_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_pk PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_pk;
       public            postgres    false    271            Z           2606    18545 (   return_sell_master return_sell_master_un 
   CONSTRAINT     m   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_un UNIQUE (return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_un;
       public            postgres    false    271            \           2606    18547 .   role_has_permissions role_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);
 X   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_pkey;
       public            postgres    false    273    273            ^           2606    18549 "   roles roles_name_guard_name_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);
 L   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_name_guard_name_unique;
       public            postgres    false    274    274            `           2606    18551    roles roles_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_pkey;
       public            postgres    false    274            �           2606    18745    sales sales_pk 
   CONSTRAINT     L   ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pk PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.sales DROP CONSTRAINT sales_pk;
       public            postgres    false    301            �           2606    18771 &   sales_trip_detail sales_trip_detail_pk 
   CONSTRAINT     d   ALTER TABLE ONLY public.sales_trip_detail
    ADD CONSTRAINT sales_trip_detail_pk PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.sales_trip_detail DROP CONSTRAINT sales_trip_detail_pk;
       public            postgres    false    305            �           2606    18759    sales_trip sales_trip_pk 
   CONSTRAINT     V   ALTER TABLE ONLY public.sales_trip
    ADD CONSTRAINT sales_trip_pk PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.sales_trip DROP CONSTRAINT sales_trip_pk;
       public            postgres    false    303            �           2606    18747    sales sales_un 
   CONSTRAINT     M   ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_un UNIQUE (username);
 8   ALTER TABLE ONLY public.sales DROP CONSTRAINT sales_un;
       public            postgres    false    301            �           2606    27189    sales_visit sales_visit_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.sales_visit
    ADD CONSTRAINT sales_visit_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.sales_visit DROP CONSTRAINT sales_visit_pk;
       public            postgres    false    311            b           2606    18553 4   setting_document_counter setting_document_counter_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_pk PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_pk;
       public            postgres    false    276            d           2606    18555 4   setting_document_counter setting_document_counter_un 
   CONSTRAINT     ~   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_un UNIQUE (doc_type, branch_id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_un;
       public            postgres    false    276    276            f           2606    18557    settings settings_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (company_name, app_name);
 >   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pk;
       public            postgres    false    278    278            h           2606    18559    shift shift_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pk PRIMARY KEY (time_start, time_end);
 8   ALTER TABLE ONLY public.shift DROP CONSTRAINT shift_pk;
       public            postgres    false    279    279            �           2606    33402    stock_log stock_log_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.stock_log
    ADD CONSTRAINT stock_log_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.stock_log DROP CONSTRAINT stock_log_pk;
       public            postgres    false    321            j           2606    18561    suppliers suppliers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.suppliers DROP CONSTRAINT suppliers_pk;
       public            postgres    false    282            ~           2606    18733 #   login_session sv_login_session_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.login_session
    ADD CONSTRAINT sv_login_session_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY public.login_session DROP CONSTRAINT sv_login_session_pkey;
       public            postgres    false    299            �           2606    34590 (   terapist_commision terapist_commision_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.terapist_commision
    ADD CONSTRAINT terapist_commision_pk PRIMARY KEY (dated, invoice_no, product_id, type_id, user_id, com_type, branch_id);
 R   ALTER TABLE ONLY public.terapist_commision DROP CONSTRAINT terapist_commision_pk;
       public            postgres    false    338    338    338    338    338    338    338            F           2606    18563 
   uom uom_pk 
   CONSTRAINT     H   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_pk;
       public            postgres    false    262            H           2606    18565 
   uom uom_un 
   CONSTRAINT     G   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_un UNIQUE (remark);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_un;
       public            postgres    false    262            r           2606    18567    users_branch users_branch_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.users_branch
    ADD CONSTRAINT users_branch_pk PRIMARY KEY (user_id, branch_id);
 F   ALTER TABLE ONLY public.users_branch DROP CONSTRAINT users_branch_pk;
       public            postgres    false    285    285            l           2606    18569    users users_email_unique 
   CONSTRAINT     T   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_unique;
       public            postgres    false    284            t           2606    18571 $   users_experience users_experience_pk 
   CONSTRAINT     b   ALTER TABLE ONLY public.users_experience
    ADD CONSTRAINT users_experience_pk PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.users_experience DROP CONSTRAINT users_experience_pk;
       public            postgres    false    286            v           2606    18573     users_mutation users_mutation_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.users_mutation
    ADD CONSTRAINT users_mutation_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.users_mutation DROP CONSTRAINT users_mutation_pk;
       public            postgres    false    289            n           2606    18575    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    284            x           2606    18577    users_shift users_shift_pk 
   CONSTRAINT     z   ALTER TABLE ONLY public.users_shift
    ADD CONSTRAINT users_shift_pk PRIMARY KEY (branch_id, users_id, dated, shift_id);
 D   ALTER TABLE ONLY public.users_shift DROP CONSTRAINT users_shift_pk;
       public            postgres    false    291    291    291    291            z           2606    18579    users_skills users_skills_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_pk PRIMARY KEY (users_id, modul, dated, status);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_pk;
       public            postgres    false    293    293    293    293            p           2606    18581    users users_username_unique 
   CONSTRAINT     Z   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);
 E   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_unique;
       public            postgres    false    284            |           2606    18583    voucher voucher_pk 
   CONSTRAINT     e   ALTER TABLE ONLY public.voucher
    ADD CONSTRAINT voucher_pk PRIMARY KEY (voucher_code, branch_id);
 <   ALTER TABLE ONLY public.voucher DROP CONSTRAINT voucher_pk;
       public            postgres    false    294    294                       1259    18584 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public            postgres    false    225    225                       1259    18585 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public            postgres    false    226    226                       1259    18586    password_resets_email_index    INDEX     X   CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);
 /   DROP INDEX public.password_resets_email_index;
       public            postgres    false    230            $           1259    18587 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    237    237            �           2606    18588    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    208    3578    206            �           2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    219    218    3596            �           2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    284    219    3694            �           2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    219    212    3586            �           2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    225    235    3615            �           2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    226    274    3680            �           2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    227    228    3610            �           2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    3694    228    284            �           2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    3586    212    228            �           2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    3694    284    240            �           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    248    3642    254            �           2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    206    248    3578            �           2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    3694    284    248            �           2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    3578    250    206            �           2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    250    3642    254            �           2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    254    261    3642            �           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    264    265    3662            �           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    284    3694    265            �           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    268    3668    267            �           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    3694    268    284            �           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    3674    271    270            �           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    271    284    3694            �           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    212    3586    271            �           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    235    3615    273            �           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    3680    273    274            �           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    3694    284    293            �   :   x�3�0767��4202�50�5�P02�2"S=3#3ccms�0_�����R�=... �
�      �      x������ � �      �   v   x���1�0����+n�����4�Qtur,H�b�-���}����z�>������r���։!�J
���ʀKv�(�u��?:�����]��E�TPwKn9�}-��a�!�7��#9      �   `   x�3�4�t-K-�TpI�T00�20��,�4202�50�5�T00�#ms������!A�B���tH�%$��kQm&�\��$��'�6��+F��� G7b�      �      x������ � �      �   p   x�m�1
�0D��:E�!�d��YR�{X��&���mڮ��j���+�`T�m��x8�+�� ��x����(�A���irJ�G!�?ѣb���i���?��Ҥ�����'b      �   �   x�����0���)\:������MHj�)TZx{��]cn�sߟ�}	p����&϶ J0�P�6�ko]ʓu�����NjJ�oꁬg�|��_.-��gմ�F�^S4�u#U�f�U��r�;�_�YIG�%;!���=�Y~���
�C�?�ܫ���U��#m���ߕi�θ� x ��ld      �   �   x�u�Ok�0������Y��Ƿ����(^�t�����3�)�C��I?=�d��T�����:@�����$�e��+ҭE�h�b}�ҼdxM)&}XΧq�.�]b~�s�#�.�o�z���)��rq�W0���Goǯ���>���y܍���lkYWK\�9���C81z����Rb�����q�TAV��Xc�FwJ�gL�d�L?���u[���F!��qS@�l�<`Űe���?e�c�      L   �   x�m��
�0D�7_q?@%�jv�(>�Q���d�b���i�v���p�#����ő�j���{�ϗ��)|�� ��1/b.P�*+ϓ,���a7 ��@���]����\ݰ�Aj�i�LI�#�NO�b�-�8�v��d*�8�8
��?�A$�yp�Pp��T^������6      N   _  x�m�Qj�0����"�$�I����Z:];���1�-C�y��gɖ�;��t>���8���C�(ZJH%���TB�(+Ml��7�k{;l�S's���@ˣiJ�L��@�iΗ"�c�p3_��-UJr��f�%,��L��s4��(-ڐh��>.��d�1�'��w�P�Xxg�>.<��.�����Xeg�Y{N�8{�hϩ)���x����Bv�:��91�2iϼA������p�q:�����654�wo�lN��؛�j��g�W��x�A��L�����z�����A��Rǚ��r��AV�����C��x��P7�HJs�%������Z�#�      �   9   x�3�44�44���4202�50�54U04�24�2��!�e�e�U���0W� ���      �      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      �      x�՝ێ�u��GO1���:r7��1Pd#p #q(��OsH���V7���������}Zk��U���o~�p����n��{x�o�͛������*�_��?��t�鯖�m7m����������_���������������|w������w�������ۛ﾿{��~�[1/���pS?�{o��?�W����M1�4���?��ݛ߄�������ww��-�������߆���=���	���p�����QF�i��L#��?�i�  cY&��c�)d�A`<�2�d��A`|��������<�	�/��w�}����o_/�o������W�߽�����G,����?�.�闯JrR�	�<z�TA�m�Da(��Lw_��QBSV�,��F��jgn�٩�M��8H=���G&V* eE��Y>7����(.��Y I���aӉ����qs��`+�3��1#�Ě�3^��Lz"Y&�K5� I�L�d��4���2�H��'eS%ՙ�A�s�e7�o�]�5�w~\�ʇ�C���o޾�)�1|���~�*�4�#I�HJ�D"�H"3�Q�oe��H�9 $�,�8*su���D UBG����wT�Ȃ$�LӠ2I�TP�e�MX�:��O߾,r�_[��_9>��矿n��%'�rE��#5��4H$0u�L�\^� �/���4�ޱ2�Q/)�i]k���I��u��hB��h���[�lT�c��3F�i`�P�.�,31&�967��Ɖ�O�k�tu\"�RD�&̍�`�î>A���_o�u:�IӃ,�n�^@`ZC�`O*��i#G���mT�$&��jd�
$��y�����h���F����tP����j�PP���A�eP[X:iHW�l�Iщ�YN��ԣք�)���,�b|1@���(��N/�������凇�n_�������q\�ǧ��闯n��%u*���T	�G������j$��B}�`���5>M. ��J�j��T�ϝ�\Lk��#��/UO�!
i
�@���V��W
�052)�s�(�
aݦw���ސ2̑2l��G�f�~wu$]���,
���-�0��kǚ��Qԉ H@_,a����M�����T�,�5!O��'u�an��0{�@��LS�S�F��'��;VV$'�w��fﻐH)@�=����Q!�`S3���t�&�,��yT�ކQ')���a?� xi�f�83#��z�)XDmV�X�_�RN{�_�^�'���9�,1�m	����̡V�	�6R���n�3�r�{Q�)��G�*�1��%��3<4��2m(�z0�ݮ��nj�&��2äWo����Q��L����M��R;����mب���Tq�����M��3�f`��������'TWP�e,0��ܥo����
e}b ��첵�V�n��<n��2=�Ԗ#�v��6���,�)���5ӝT{�"��ڃ�:f��:���ʊ���vnvxZ"��35�>�!e(�$VԆ�>X��Ir'+,c�AYfn^\�iYQ��ن�X���W�e�>I$������2�1�Z�f���I6���HZ��E���$��ϜXE��㙔:W�<���dK���Ț'9,��j�Kb��yR絃�T+�F�LZè��(Ԓ��H�9�&��S��3�2�&�9K���9Rj �bE�V!h2V;�2$�I�^���7������2ms�S=Q+�LXs� �F�a{��[ 	�y(��^\���X������>�$�Z�k���"�:�|l�*+���(�^\�U��b��"�"��($�H+�;�Љ��\=�P�v�v�}��f�Jzm��az�uO6����Ȁ�t����F��)�Þ�Aبn�h⧈-d��@`�&��LX�5[��D�N�V���A6�$�z��0�Tq:�2L��-w4��U��Zt�5�d�$�Q9�ٹ�5���gJ^-����z~d��Tނ���o�[�����7?����7_���8>�|I����c�6�+o�/�.2#g�E��y�I���`�i�j[��>H�����=]A[pA0�JC�zZxa�jLXO�"X�*�t*������_��X+0a�m'^�:��D�e�����ن�*Lc�zz����	�G�¡����=���O������,V7��x�ie�w����������_`�0�2��¯��������qng}� �r!j��ƴVBZ�d��LX��D/u�	+"c�Nt-k�J��
Ɖ-I�e�z:�a�j��*�����jȺ\�v��[��#щax�Gq�h9q��.9�4��ֲ`{�$'i��5\�$��ZX���\Q����*o�|fZ+H�e��nEm�ڗ���:� ��[L��L����p�1��cx���!1���Y���)^3J@��/8(}sțA-�Z���V�q�k�l/	V^���+Ǳ�Yk�
X���C���LLLk5&,����ũg���k	�cܲ�"�b���L'���`ef��7v	� a/�K`�8�ۏ��N��A�jDXi�
��ܺ�-iaN�����Zɯb�2gK��w����rN�*�i-q������L\�<�n���k\�������,k�+Y+����2J�$�y@N�y@��b�`��۰ο����ɉ	+13q<�#��LXY ֱu>�b���S\7��*VvQ�p��A��G`-�e���c��N����gi�2$�kU˲VbZY�8�&Yk��k
զ��N-�f �ŀE��j`8q�(3|ɹ^	֡n!���Z[�ڙ�C��	 X×�P��b�e����N�`��[�J�uh&���V�����q��s`�+
X�;��T�1�ɹV��|F�V[�
���5^T��⺵�@``�zT��gZ�m������fV�Ƭu�c
Xŉ��k�x'���Se����e�6�:�vZ֊L'&�̌����]k�(X�Y 2䓸@X!ߑ����ZFl�C=�C���Ƅ���zaa�V[ˀ5��HNlPXe���5+�2ƫ�PY��e݀5P1���zֆ�e-fl��
XƳ�5�2����MXQ
�pb���`u&���6c���իÃJ$�x�Ǽ��D���{p��`mn�EQ�u��*�e�*�	�#c�&�����v&��n��os~"H����b�6��}N��2o��ʄ%���;��Z���`SH����%���' ky1���Ʈd���H�*߆�w�5�q1B�3��uk������ز���[�1�zXFŖCZk-l8�
HX�'��Z�c��Z�`���N��)�Z�L,C9�m=_���7a�GX���޽[��O��i�����'�`	̶î Ɗ��=���=�6
7��P��h�Շ�x�$�,����`�?�8ʣ'��g����Ws	�h�q$?I��	��CA",�tB�\9q��� I�r�\0GK0��P�=7���ɊI>�\���N�r����ɉ���|n�r�Hz"H��
����í���N$f�$0a���j�=�:oI	����j}<�0�*sZ��q�L�A���Hp��ǵ������L��=A=�����.!\�`�c}Dw$4m|^B?���O%Y��,��Z�`_�ӳ��V�m�!x`���R�XD��T���i�FT�H�6��g�bjސT�]�&�*����	�Za��̝%d�@�e?�#��V�]��Z=��$c:Kn�B�(Sҥ�|`wb���w�'���0T�%=�>�Y�5� +�
2��(��D�f�WP1��d~ �+�:�n��k(i�-�%���Qw!k�#���[#i]A�A��:�5�s�]B�/�Ԩ�ǉ�:W��}4hv�zpG꿂��<|��`���,0�mD�\��(�Z��X�T�aN�:�a������Q�ú#Q�לj�J1�iHGa;&Q���b��!�@��)�⍹F�H	L���t3����O�����O=�F�� c9l|7�rdظ3*wX�f����iƧ��`�
�`R#�Q����F*������`��a���E&c�X����#S�̍�e(�֙��0Ŋ��T�>� �  ��#�ĬЦeP2�T׭�6�̴)z��>ѡvS�
栀�s�4MFfy�K�G=V��^H�g�.�/�S_�i��Pw�$7%T� =@U�3�3ͳe��<�~�.{>��}���������:�ǧ��闗ja"�h�Ӭͤx&U�`(��tj�I�I��/���t8:��ش��n|� s͹��6Z���d#3�~��tS�
�Ў�bT�l'։~BMǀY��"f,0㚰<����1Q�F�}�k�;*xÖQ$�oW�>�F�Z,C�
ݴL�i�^*�M�#������gV0�눳͵��ȉH�l�"�9�x�����ePE��WKqB��lj����X�*�0����D��m�%z8�x��Ar�����X.CI�A�U�.`�t�$0�Β�i\3� �`:�W����)3.h���o?����n:�S�$�v�Q����F��X�D��XYa��V̀��ט��Cb�B��0W��+E�3��"�M�(�},�/�$�)��CId�Ʃse��&��8�o��^�$�J$�U���,9(71	���`DId� 0��3)�`�"�E��o�.�3W{�{5�,-Y	����;�T��uf�C"�B*ՙ4�,��HR�;�%N�����(u�F`��@"��*����g#�4줎����RK\H5�&H�H��Hnj$9H`
��ET �R;���*�	�t�Iz&��v/�f?,t'�L���ed=��jp�v��9z���`���a��SH`��
L��q]a3�<�2�7)1X�bނ5���9�%�c'
>��Mܔg����P�O3�2��$fH湮��Č�U�P|����%i�s_C�!tO*���j��@��GR��3߷v�MR3��*�x��P�	�ד~ER$)�L�L"U?�%��p��sMG\��&���I��75�9}�W�Š#+�Q�����&��+L�Iuؑ΢����`(3�H`"ihP�� �Ss���|b)D�x��w�T44�=��0L�$~�!6$A���R�`sIg�nn,_}�Ix�z^&-�H�ˉ�{�&�d�y��}��)4��EIC0����-�b��1V"E�����bj0��������t�e
LC�)�����tR�ԕ�0��Nr�´V�F�:�*L��v��
�-
�ԇO;��T��	��<��n:��뾊�S�������@*9UrH�I%��T�M�X�|%��J��՟�,�H���R�A�SQAC�tL���%��բ�U��Ƌ�Qm�q_f��r���3�-3n��-#���F���&9��B��M0V6�*pDU���LO�8QBV^I���8s���-W+�$j`R��I�L��C��,�=�=�$r�CF�C��X�X�H�Pm��$ݞUI�g$5��W0�e$�iYF��y��DR {�Xt�$��Κ6"��H��Db)_�rݓlIǓ·J�p�
�W�d���4�Fk��P#wI}��d�@"��rI��4���(=�&�%'�M3���T�e�{�	��9���\0c��4F���)����'�C��a�&���vR^դ�+Kal��S�]c�(!1+�Q�Lc�]٦�>$0��"H�>��fV )�B��NS2�%�vo�8yk�h1))��8���F�8*L�*N�4���R��t]&�N�/RKߠ-=i:�Is;ϬB^��X�ձ�@�IL��M��E��h�;��yH���)��\�|p�YH�Â��9I[����@5�6�+ftE<��<\a��l�;t D��;�O�ȫ��f��sx�F�1Ю� ���d�����$�62?fƑF�[F�F#��A�v���#5���v�<qǺۉ��B�`�̮�ӓ9��n����/��^n>��q牧��,3�n�燲a�4���m4��pl��e�q@�ε4]���6�
{�>6E2�T@��laE:�`
���N
e�G���M$��4e�)���L�$I��MW�{Y�'��*�\��U��H�9��s&���P.(ݣP�&�������&���U�@�lt1�S�gT�o�\�qX�5��/[����4Od��$b5�2���$R�T��Ҿ!�:�IѓA
(v�໑�j$Y&��4��$7%���ɡ,�=���w!���Tȅ4��c���֞�K�4>(���ҁMa.ad�Y��:R%L�t�syt� +�I����ٹ6R�)�+
�  6Ңގ��4L\*� ���P�mi98��]�D�$niQ�Db�j9�#���R;����1s�o��B��d��-��-jۃ=���$����̥�rXO�ZW�����,�`(|�ƃOu��qLa�,M�q��y�-���z��򯹽{���Ⰷ�ݾ~w�������Lq|��~�*MB�ZAi6��l��#�D�h��O㱰Lo��ݔ��Lr���CZ'�R-.�F3�܄a)���&K1��*��T�LE���Ƒ��uG�mӆ���r̴�͢"�M0$j-s9�ؑI�,4$�Hӹ��F�4�Ə3�$��'5�5P�FϾ�B|3"uEӾ��Pf#�I�'�F>$RO�1aj�Ѳ'�LBM�$�}�lS�*�c�T�	Lͻ�#�0�꿆�)fɉ�+�b9k5��Ԁf���ƥ�y�Hԕ$��b��ڂ\)̎H�T�
����4R �Ȭ=$F����Q#R�I�C%�\#��'�r@��(&�&RUΨ�)��G���"-%ұ�'Y�ε��F=���۪t�13���&�|I�&��A���UR!���E��~w�t)�J���@%�biP�)*� ���"iO����6���O]}I�qhu�������7�&�9Fy�f�x�Z��2>�P1�<����g�d$�q��7MVT@�O$09��P��]�N�����B�*���2�`���X.n�O�� .��b��ba.��Q/u�ɨ$�/�?7R��H§*�dJ��̫@�Q&�Z�47�(0��#6�*L�'I�TEИ3AR�)��ɝ�����>3�F�*�d�`9չ��&u�B������$�=��*$��$��q�:�1�FJ�L�N��J�Ş
7�1CʦHZ�i(�CƉ4XW`������|4(������M0�s��iE�]�Kc2=Bw�H�����o�8J(%���vf�1�G$�W
)�=I�G�C�&St�T�Gq:�|ongqtӟ���PcnRY��I�)$*� º8��պ�P4��]�]G�y�,J�����������nG%�S�waR,��bs���~j�rBf���}��7���z�      P   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      R      x���ۖ�ȑ�{�~
��f~��wHf03��TDFq�knJ-��K�Y��g�<���9������E�ׅ}D8��v��wۛ���������r?<n��U]���띯�wu�7�s������}�>T͇�T��~�O�o>�a�0���}1J��u|_�*�!8UC�w�n���:ܿ���ZW�8�����C�5�������-~��}p�a� �P����ŀ��o�jBM�᰽F>T��T!pD�1t\�j��?��!|���
i�{1|6<�:.��!�#ٿ5؏��T�ߐ��	�W z�M /���+ �kUC �3��_����UC�w�n��?���݄�a� ñz��9_���C�a�!��v��~�y���r�����M��h�n�.���\�j ���ó� v�o��!�>������g�4�����fw{���H�=�����q���΍�T �=|��Fk͇B@���`y��nT��78׷f��q7z�#�4�;4"x��.N�P���<]�*��{��5�:�o7GA�㕪!�����uW}O�f�N���t�N��R5� Z��h-�;Q�jA�����f܈�@��f�8<�q3�j��ϛOWH���bc0k�������K�}�g h�/4"4�CҬ!����<��B@���a ��y�j���y����і_����������e��G��CZ����:UC�#>���.q27��]T5��w�v��f<3����ӗ��.��zצ�b�π�/bE��jP�����˻?�����ǿ��i��ݻ�v�w��]G��j�ݞ��r�Hf۸񛡣4�{�RP�*GtW����^�>E�o7���6�����xrU�BCܻ�a����M��3�!��'K��PW��X�h��e\w����e�"�Pj�y�\x����x>�!�]�6�{�9��u>6���Z�p������d����#�W5����T��L�7.�*�]�ä���Ѱ��U�6���b�4ѝ{.�;�j}�j��>��ö��q�����`||=�����4�+����pX�0<�V���5&PjL�aj��u׶}����/ަIC`���N�Sq8�mӍ��W{4_7祆�����w�}@�F[.^�_�^���~���7�W���l'0iC�����x�Ƶ�����7�lُ/��!4}�dܽߟ�5�˕5 ��*m����ٶ�"��՚�L��L[ŕ0�k��� :Y�n޺����3K�j���2�Վ�vm���6�b�jL��P��;���Aq���9v��X� 5=~lڦ��-���C\.R� ��ç�x�|_�}_&T˭ۤA0��l��_��Kb����U��P_8|�����`b���������5a"�5J�^� �W���i 78��A�ĳ{�_?�J��Tb`�i��_�HJ�`���V:�d-	��A�F�\7��>t��}���tӲ0<��z�Vj��Oo�W��R��!����`A�?�������7o\�M��著�5�~�bZ�����A����k�-��A �������ϝ#k���n�6<m�}~��l������!��Ӱ��r�t���^b�6��O t�a5���n&���yx�M����o�����0�=�U��޽?�O�����a�%]¥�x@w�U8�i����N�$�Aȣ}�(�?�|�W>����+
C5��Z���m�፼A�S��8�I"H�z+�H�-5��ө�/=��w�}��,H���� )5)�)�RK$� $���A���QܐI� /�}�ߟ3��i|�^~4���5�v��͸{7>_��J�H��u�-�� ���[�[e�^ idXJjH�ǎk����D��[H�A )���nk�eR��ٲq���<�_������@.��d_ �:�]X�8hS�p?l��	�I�}�k��4
��/YO����A�ɫ~���O!m)��A���?���/�����&��'�t����D�����v�V��HiV���Z� �6�������5��� ��ݟ���_���?�����N���T"��/���?�[AȮ�! �vs5HX�g�ȿ����c#q)t(ns���?�� ur_!���A ����S��QP%]��O�1V��֪�A�ԇ�`���X��'�D�B�F�6]��V� ڧ>QM����As<�9�ꌃ4��b)Ί�*-���.�v�4� )�Y�B����*�⋽�� r�������y+ 5�sL�vcٶ��Vf'J�[+�#K�K ��Ǎ�\�&��<%4���������"MSjyTJ}0r����a��84�e���.�ؔ-.5�<����9�m62RjG����h��GaG�R\uG�pt0��O���Iɺ���;�͋��+o�A�E��d�LĐ�A;�U�nث�A����b�_|����5��hʹ��z����+�5�\�!�k�A=o-��w�RC�H�JG�Y����Oo�?gkݹ�`" ��9�������S�;U�<��m�ڬAt��l���\�.���A�"_R���P�T%>�q��<�r��UYjy�U��	�� :�5�2&�TѬj��-��f|=!����Q����g�"=�� �O�����Lҟ�T����~�~X��zQ_j���p�fV��5�� �����W��k�k�ԛw�����jI�/̕�x�#����R�8ڹ���E<�� �.''�ᘯEK����֏�Oi����� �}0s���ŝ4��^�Q/�ǤA)q���!p?ی����sW�G=ϧs+�R�8�����I�*k��O��s�nb߆^#*s�K""��qs�ne�9~���I�8ZN[�[U�8x�j>G��+Q�A�_=��t���<3iG]�!�#	n�]'B�(�����О�n<�������=����Xcň����� 
�~���o�(C`{}��^� �8�xߪE��۝�AM� >��Yo�7:�3� ��+R��������&�� �F�����L������"���
G�scy%��b�J�p�a�Fg��kNm�A��fo�g{ny��4����n���� j�JbjW!�D��6{�!L҄�_�JBh�<��Z�]j��ϧ��d^K�K" ���aW�.�UB����_D�gA����m���A�;U�8h[��Cn�q8�j^O��l�ƗQ� �\Oj:+��&%�q8���y:���-���Y_|ȅ���ܦ��V��5ս� :��^��ߦy�GXj�Џ�\bE鋋�A(�Lף�/��q�ř�f�LfS]��!(4�h��n��g��ۖK�5����5ޫ��e����\��hU"���]���r�rCyb�A���t��2a�_�_�5�|���W�-Y����5�����Z���UU��%����"���x~���`�u���l�4i	y�����LQ��t�R�8zN8�n�B1ӧ���������| �A u�b��n�{�4��v�����w�G��U"�֢��fS��q����8�G�W���jO��ݙ�_�h�$6��4��Y⼪A �Z����֓�t��aɍ�>_�晍��$�R�@x���Y2��f�-k�Gz������ғ����&�ǆm.� �2���P�6�[�܎L�A�uG��CO�洓�bW.n�d�R�ȟn~�C$k�[�&"����[m:'k1~��A|c�v���\���L�@����`!���I��	���!Nd.G�uA�"����ϐ��E4h� ���<�:IB� ���@E��y~����/*5� � X����A�F�Z8/�!k].}޾5�p�拄H�A-��ޛb��'4��S̮��}J"�>�D�+=Jн^-]%��9k���u��|���y���&��A ܺ�x��))>QhA�ޛ��EԩD�n删.��[v���o��A,;�\i�A�j 9�ݦL�qu    �k�|�L|� -5����4	�M�:�� �i~��r ����0�rN��U���Wy������:��_N%����׈5������Q��}��,�H��B{��.�	����b�S��3� �<�is���F�����Bab�C�ު���Ų�AhA�k�n�:�sE��� ����Yą�_ݘ*
=�������at�s�#�� ��fي=&��R5 �sUx^Ҫ�˒��X�dt�4�����2nϖi�w��/��A^�-��������Ss$�%�E��� �tw2]��v����A�͕�R5�#�������DhH�=+�,��'��%DUCP�����׀��2mEhH���u�y�XY�8O�5�U_�����0�	eNhI���$~����Ds{��hڎ.	k9�͍)�m���� �����g��� �����Ѕo��[D�A�W��SR�ϙ���:i*���t��@:0D�`)�4���oSÿ�-�$)��p��E��U��D��l�BR��A(Ax��N�dϗ�*�Aq�lZ�9o�w:����e(Hh�T��ƌ��Z[d��D<�lZ,�f\M�k��&"�N� �n�)�ڏH���R[lӄ!����i�6�ǧ��P��U_�	���'��i��>��Z�ۚ������A@�w�������u�c/ ��-4ɭ9��Ѿ�1
�H��L�6���kAx�',��1�����R�A0q�qs�q��qTh"ݝ�p��}Q_#4���G�NZ�O���m��/&]��ō�� �.9�j~�j(��B�H(I%I[� !�N�*�G��N��Q��	��ƷN�%�^gB�AD�^�7gk9��հ�E�DB���u����OfRk�Z� �+0t��M6���J��0ct�AChw��,i��z..� �O����(�@�k�R=������T�$ÞB�H(RpPï�צ���͹���G���BC�b�s>�6nL�H��vC'�&B��h�=>�Z�H�-:U������Ӈ�>��S|�97��� $���(SSxb�AL�Jp���s�����yRN�9/��� &N�:�n
cNu���B�@8�0��S1K�zU�88~�9��T1'��˗�5��H���Ch	M���FVyUCP�n��D�u(�4�&5uB�8���v4R%N��q��.�R�������	}k��!�)_� � �L7Ql3�N�/5��w�Wp�͸�q4|u�f|i�A���!�z|Q�
'Z\� ��{�ٞ�7T�a�H���I7�;8�
�hy��
W-�ٳq�S�4[?��'��Z� ��n?����O�A�:r��Y�8/�-rL���Y�B�8ا�:ی6��n,��q4�`
�E��� ��I�e�Qj��jH7��i+��]S7��ϏYMn��^� �ib��Ǿik�z�*��ǲTKhM���~��e[�U�[C��c�M=�$Mi�x��}��A$ܷ��=l�[�m/4�M�Y��d2}���A�I�i��,������ۺfE�Ȇ�\q�/4���fo��?���Mޓ�%	k	Gm�?L
��@�a�%�qvN�ֱR5��N�#(یE^�� .B��z!5��l�U�����*�iB�@�w����9�b�&4���d����u��T�sƇ)�ͺ��%4�y�eo��%�eC`�A-w{=^��:�]ѩYh�{S�9��bV�� ��'m~5]Y��Tb�\�� ����n�
���&4��|꭭�m��ׅ5�ño7E��f9Mh����l�f��ȒD�#�V��<t��D���"K��������4���� .�iB�@Zn��$( �q<p��9ɜ�vE�UhI�*�}�Z;UCHj�֓w*��ެA�M��W5�6����R1CFC]�(	�S��M 5ˎK�^��L}����*��6���-��,g�
B�]^l���<�@�����}9=nwe��B�K�5	��r��� r���gӎ��vE�ShH�W�
�X�'BCHwwy:�R'Zj�]w�B�@�� �R�A d�hհѶ8 �c�F���ue�� �	<�[�K�ٛg���$�vԳ��b�&4�YQ��6C���U�U� �(��HN²�ǱѮh<#4��eg�L�>d5TE�Sh�����yi�\$p����,�|R6��4�A �[��^����R�m9(AhI.����n�H&	k�J[�W����I�@ȵnm�Eئ+�ZB�8�\Ke�?�ͮ�h/Ve��_~z'��h����rcCFc9�Hh�ջ�����������p��pg_����� v��H��Kh	G\mCNڜ�Q����K���M�DW�8����c���M�^������U�`����4���M��S5$'dic�4�������6��%�V�T H�:�`���2�T9���q���ભ���A�����?���o̬A ��ɖ��N���A�P�6����L��A$�Q���R��N}�:U�@(�jH����ϻ)�+��T� ��[��Lz��	+�D���S�c��d�ب���LE������jT��<#�-�ǤAt{�y��Y&y�9������:��9kHX�|M�A �j���q�֢B�0x���(�aL��F?�	q�joY��kg�A\'`Qq��[:��6r�f~���r��q��c���J� ��hˎ즰i�j�ב��a[hI��$eC(�A$qj�i�9&��49�o�ȐєQ�Tis������˝$�H`�A(�O��5���f_�����5 � �|oXC@x@օ�e@���/4���_�_��4I6�iEB�@��jI_��D��׾HB]$�	+n��f��[hG�7ަ�32�ևB�@(���l�h�� �67��.���띪A �V�"���_hmW��hX�������	 Ư/��U�H����馶��U�D⸷���II�N� �V���$�)4�$w��M��lk�A$1�3��h\�H&i�tcg�F�"0"4���*�X-���p���5�p��ZV�A$�_��/��M��� 4 $V՚��.ߤ.ޛI�@ؽ/'3G,"�B�8r���)w���E�Dh][��gS�5YM%���A$�\�_���V��A1�oM��d5%1���pH��9>��y�n�t%��P����r���mH��,4���0���&"O����l�S5d<�?mL��]��T��f��`������A���Y�8���������҃����q���v2�5�VY�b�.R��qPוUn�5��Y�Q΅���͑"���{U�@ț�)O���9�gG�T���Zw�agJ'��6�����5Y=[��A$�&ju���r���U��\�!�����5�'��^hoV7-?�\l��q4o�&�@R^�"�8���d�Fc1�Ch�4U�i���
�6��HO��u1>KhH.�ZK"�F������2<,Op��p(��֐���b{$4$�Ym	�QyB�uc:N���9.1��1r���i��v��O��o�G{��<:k=������u����u��U��c�M{�ɦLs�A������MFC�Gh�[=m?Y�|q�R�/���w2ϞIvڊ\oukM��Xv��1�8����M�2�|oX�P'�X��d�/�{����,�[��/+k���5�ӕs�%WhK<Ms��<մ���t��u%�s�����?�6f��<ڨB³�n��L�F�Ѹ\'�A ���$~���4�$�\-ђ�dU��s�"+HT@"�NNf�P��đg`�z����wq��4��+uB3e���^��Tbɡ�e1Dh{W[W��fX>����<��q�`���ߤ!\�7����>���a�[���X1��:�:���i8�i��sE4\hH޴�)�		�D,�W}.�+�ǬA<=�Ƹa��S5���L���M�p�;����~�|2.�    ٪��������㟑��p���_ݴ%u�/ݬ!<k%�[�1�AT�j=Wqɗ?{=�9��Y{{�$MVT5��ӭ֒�jI�.��f���Y�8�K����IO���J`� .0���~�8&����ˀtt*36�qt���ͩ�uE��J��D�O��/�V�!_X%7z����X�AS(Ւ���M֤��|�ޙ�F]�%����ۍ	��� 5ڑ v����~f������������GAg�UBh�M�%�����J� 
�LA�٦ȃ���>�0��۳Q�T��{b	0�F]E#`+UC@x��J�ګđ��w[��d�N=���A$.�4G��<[u2�JjI����p��F�����.�di&�m66kGnY�������FV#J��T+I��A$�Yۣ%K&Yui�t"�r-�J��TB������m�[�Z� ���r^׳�u6*U�P�)�k-K�j���ɉɨO���U5���tw�[���fk�j*:����l�W�aĜ*������l��_���4y����{6[;U�P�<���snM�bƧ� �.� ���8�k���t��JP�	�!5y�/���@���a�Au�D��:A��[�� ޠ��?�2CIj�Mk1�����U������A|����s߉���D���t�MG��TB�+����JhS�Zq�#5��}�nk!��&\hA�T�o�z�d�O]�d�IhH�C���MF}%�RJ�3�-)�U�Q.��B�Hr
ԭ��e6*7�B�@h�yc걐m62�Gj�Ε ��� 4�8��d�eR9��LBwK+9j�} ����ԙ$[��Uh	�Jol�c�����P�Z�r>k��.�CG�t]=�S���UO�mQ�  ������7}��~�9*Q���$b"r Q����y��-vLB��g�ڷm��?_���|�AP���Od���Օ�.<�P��K"j.NQ���[�N�<�V�A@-7���S�Q?.��+�h��h���!�
�Cj�`�AH\�z:n�T/��6�1�ǫL�).R��0J�zT�;u��U�[*O*��T��4��`h�l��h۩�1o������]�wMЈ�����4����4/���C�5�'��\��O5iP�q ����D�z������cԁ�<n]��(��ns���ڹ�ﻠyjU""G���JܫLMq�/4���n!���2JQ{��n\F����Z> � n�ux��ˎ_�q3�Fuѩ�~�)�5)VR,N@B��hw����U;����u˟ Z�)5�\��ֹ*��m\ף�Q�h�x����q�N� "��/-#�����i[��OCϝ�AD\��4����WRӅ:\bJ��+U��^ޏj�H�ҟ���@��߭�AT�[T����4��>�0��il�� ��ջ<�#Qߏߵ^GJzUC��X.��]����N���ܷ�!�o�fŶ���GjX�"�V� $.��YBz.�8���A�K__N�76���㖿SM���\�jR�I�?��U���`{�k4!,?��4���}Qո֩˨��V� "�Q����"R����V��4"�q��Z��i��jU���%�T!j�i؇�4�ǝ���{%�������uݺ*�A�;��_�nm��p!��I�~���O�����ʩD����j�WO�����:��:
+F�f�e�� ��7Tu����u�����q��x��5��ɉ1/�����jm�4z���fb��G
��AHo��׾��Su�4hU��;���BĨ��x
�.0�2cWh�4I쇑���5���a�6��\�%���ߧ�D4u�?�u�7�?��y��(w�B���]�,x-���mV��	��+4�*p����K'�s�M��'lI�D�Hʡ[���
Q��-�&"��ȅ�A)����=H!r�V���Q0d�}h���M�� �n�yaW��_.��F���j�,3�AH�z�=(-��s���P�_{��w�ߤ�&�U��^�����u��C}d�.�u��|����|ۥ����0B�ӔA�j�D���z�*�Ҩ@�Z�EU���m7ZA����n�q��ͺ�	Ɛ�NT���D�9"j�a��5�����vl�wEdMh9�����h)�����٪	p���{���0�d�%^�	��UhLO���q����NH#�a�u�j QKc�.\Q��wg���ð�uLDĹ Z*H
]��G4���qQh'�|ֺ��)����T�h��7OD�y\��i�P���X!�>��ȖD��z��� �:]R՝���/Z�KB����ߟ_%�W�B����7����X�^���A���8�k%�A��u�dX����	�H(����9�Y�;׾7���=�Q\.c��������2��iՍ��S5�~kZhlb���z�H��"�Sh��C!�Z�ڨ������S5��s;;K7�l�;.�����}�1�N}�Ք�ѩDģ�T��"R6kG��Iw���U���?��6J[������f"�D��)���΍��]![/��B���������������;w�dz\+��!8���G5y�5UUu�k�Xڍ�'�A@�壨��EU���#�7Z�ހ$�W�!y�-g�@	ܡ(j�r	�*�T�dG�jE�_���QWC�����P��������� [O߆{=��ǽ�S_�R��J� ��96Ui���� 4���w{S���SŴ-�A�����/Pʣ/�؅ap��V�L6}1Ujy���"���{��A�[�|�,�`��p�HX�P��ӑ�����K� ��6��*�n�Z+�T����"�OhP�_�8u��U�U5�[��a{�A�J�q��O��e�[KK�l�/_�I�0h/;���a�	�4�+K�O���l4��9U�@��dH(��
	s��U���1(�A(�'���sU�@]����WhQ�w;��ی���A\���E�]J�]�R9F�Ӥ��ab��~qZ�w����#�!Ez�bZ�� ��b{Aj����=�e"�u٦Hh��ml� n6S��g��=���2� u�b�����x��W��@\�j��F8�[Ì%6Z���p��`j�6c��$4�#r��c�v-4�������{� R�!4������'�������C���ր4����.�N2�l��a����.�;�/���H-	������(��A(�Z�6���J�/.ԝR7I�c��.4�s����Ҋ�vEր� �kA.hHN_��|�"�i��+4iok���G+��SC�j��� ��A ��TM���Ef�A=׌<�X��d4tK?i�n["O�B�@r+b��qPo��/3i��h۝iB�)��W5�f��A���#T��A\m��~�b�sWw�qp����B-�β(���̵�ƧB��c�j	{�a7�N�$�<"��>�t��$�Щ�����E�v͋��!\��m�`]"��5��o�������W5��|����#����q�k�|2z�>�ѫ�A�Տ�^1��ľ�;
"�\�II�c� N�����Nt�4�W5��k���a�l\��ojU�`ȱ����5;kL���qI[�	!�´���l�/�N�qL34�1����o�(��d�,��~�N�G�&���4��S5��v/wV����iD­y>ϛGc`+��2�A,��}<=���Hj�[��D�g�mmt���V�:�%���(t""ǻ1e^���(.��a��]�!��B�0��l<ehydݮ��� ��g��	�:FJ$��aPv�/�jB�08��V@6S�N]�88�`G{��D�����ۭ�w�5�#4��3b�qx]�8xk��t����a�V9j���j>�A ]�X�$]B����}�tQ�6���!\�9ض"Mn$�ZU�@h����_��&�R5���W�E◛V�A$ܵ}�d�jr��W5�$��)��PbtW\:
!Ǻ�7��Ѕ�7�[���v�EU�8�<�U���x_�%"��)    ��l��M�� �<5��`9���B�! \ݵ�)����f5U:�F�7y�jݩDB���f�Ss�ԗ!2�H�B� $��Z�d���R5�$�u�l�U5������E���������ҥ#�b�8i
�t��[�4�����A���v��QO�A7��mM�,����^�A$=�qL�:M����!>�n�wJη�w�V�49�}�9�4�﹆{S�?7UT5Ľ�������/���_�M,��C�j�O,���_?[9�r$�� ��g@S�)�,�D�q�w�?��1�0��R9U�@������c<�Խ�A-���˗f� ����:���v�D�Ke����"Hh�t�i��u�A �U�vɸ2����\�a�'���h>k	�p,�A7��4�.Wu�?i��i�ZRU��t��ThR|�3\׭�(��m��*o���������?+��t��b����Ԧ��j\.^� ��g��m��"�M��F� ��o��6}�u]{	(]r��q�v<�Y�-7�BC@"ϙ�h�S �!QI�A ܷ�S�1����	"q���v��ҕ[y^��nMg�6w���e�A ���:�N� ��3���2�)�� ��,q�¯M�1��矴�sA��R?�r�"4�����r�R�PWi����p�� ���\���2=Gh�zm�{�����&(��.'�  v�O����i�Q�4����;[���se��� �OJ���]U׍SH��PfT	"
���2�>�[��Mq۴�T"��3�t��pީ��#|v���ft�qЅ��^�?�8�]ת��җQ�!u��܅΍m��1�D���$4���iضk�6�ﭣ�! mu�ɰα�.4����Vr�^� �@��^�Ѳ�� ��s̓�jU�0(�kM�ms$;�������V�����)�W�:嫪D�[�ǟ�'��m[�Y�@�Q���p�U��sM���W����H\�jT���;c�#m'�Y�@xF���t��(�ODhH��{��r�׆�)�:J�E�*�AH��~s㧺�xH9�ߑ��U"r���a4 �
�I���ǽ���F$˄�M��/�E�u�4Z&��n*,�kW��FM��vU{e�N7��t"���-%�KQ�Es�A m���]�v9W��	"��#Ǎހ:M�ru��C��~��j� *��zR�U$WlF�� �y��^���0��1q��V�� �*F	�	�&]��T��s:kǄ�ʝ4e0v�R��i^U�jQv�7���ds�fU��A�t��p���e�wM�LQa��\���+����	=��R�>�hY��"�8���nHQ� �.�^��O����4b����e��� �>��-G�.g������W�[EG���)�� vöh�ds��4�c��n��d3:U�8�?�� ぷ^���p����b<��-��:U�H�n.5��&�]@)Ӆ�4�
GG}�:U�8(��֨���f�<]N��q�V[G�n�>ިB�ߵ ѫ��i��T�G6cX|�f�ȃqL���^� �?m�l+�G\�V� �:[�Q~gf�=��^�:�۾��y׀��I�"b%4�'r���P����\��U�j	P�GS��d���P��p�~#��S�dv�� Ff���9��-9�p]�*���}0���ѓ�jd�A$�Կ��Q/3�q�-ۣi�F6C\���q�`�@�ɨ�U������#���5�#r��
��hd'4��6���탍Ñ�p�q���t�b��a�&5v�X��	� �zg+ a��ҡN��+��l
A�)왂!��Aٝ�9Y�B�8\1�0�BCK� ϑ�Ǘ���-��e�A�A(a��ڞBҾ8�� �����+�m�}r'����uX�,�V� ���P?�bl4~��A GЬ/oX���qP(`%��c�����ʑ�K� �<���$�>���yT�ϝ�ǈI��xB��|�n��"�,4�g/jbD�ڪ	���K�S��ҥ���%���AD1��$1$���T!okkp4�t�a�k1��1k� �n�ϒ
�+U�@��7i��q�BF��aa�ժ=}Lw$����A5����Hԍ�Aykݟ�t�"!Zh����+8�"-4�#p���5E��t�A٥���ۤI�8�B3�1��6�.v��>����^� �v*��,:��D�5� �e�j� �������	��m�kב-	���*ԩ�%��9�����ϧ��w�ytEGT�An%�?{����\������ˤ|�A�6�j��X�ƅ�U��z�R��HĬAH�V7��)���Z�wʹZ�^���6���P�Lg�ѬAL-O/�a�V� $N�}9iM�=��+�:ܩH>��B��8_�VMl����ų� �Sv�6�+&���<]�̧|����TOI8/֓{�/�E��� ����RWfB�S����b�G�����n�jAL=�_�g����-u�\����n�QQ�*5����������ϓTG����ü� "n��ר�s��Z�y�Ȏ)R��:��u�R���K�8�8BIa�1e��O� ״m�y��ͧ�������n�Ǚ��~�;v�I�T����4�'�Z�L�C%
�L[�D�^��`����F�r�!5�$pǯ5 ��/����
���R�@x#}���g�����i�M��W����� �4?n,/6��+�A �	[b��fq�����,�X�	��[��n_��~�ɞ4���|� �CUɸ�� �jn~�����#M��5�#$�������lI���A �6�?�����044���Z� j������w�Oe�Ϋ�Ѿ���������nh$<���A ����ߌ !��V� �~=���I���UU����?�j\��M�إM�R˟��_����\z9~WjKn�HA+ޫ������JJϫT#!'������_m(15D�:U�P��~��?F��7+K
hzU�XZ��/����}N�0��V�_~���{��^����L� ���hC�:U�@�q��ԓ��Z�Z� �:�1쬇�.�U���P����q����Y�[��'cqy,�*�b���0��5�f�F��<iHȉ��#I�/���MaWG#�"Hc�چgjUcjxڪ�����Y�R�@�zl���N©�y�Bu��C��a$��k,(���qX�Hx�������S\k�ZO��ߚJ@F�鮺_l*gC!���x2�P��t�UC�?�R����~%4���p��*�p����4���d{��5(�����1�f�Ph����;So�l�������L�$-5�l5�����A$>_�Y��<��U#�ǽ16�z��4�q���_���r`N�a���:��:]��*Rè<Q���?���U��:JhE���_��)\Iv}(�GB�X"?�_~���@_S^@��/5�B�kI�E3kI����<�$�)������
���9��a(����me�T����؞7kg �sW5��>K��dե|��5�d�ĳE^�
C�x�no�����%꼪a(>O�}�'�^�0��f�0YN�0��8�,ul�uEHAhI�;��C)?D����B����!��dCj
W����x�d5P��^�0�>�
���4�k	2iH$?�ed�D��i�L�jI=�H6H�l(.6������v�GF��_�����QШ�ةh���`)��v[�Ejyُ���9�����m���>��{J��eWf�aD�m�BÐ8l��(M߄��}S�G��rʓXҰ����7���\슻p�a�qo_˟Gc�S�O�)FjC���|z|�h0�+{��1�\R�t?��!��pR� (��i�qo@�б�0�����,���.�MujM����p§Q�W5"���n�W_O#s��a9��~s0x	��@��Y��a��>_]������5���h��ǐ�ת�Ap�����fio�G� �N� �\O�V��%�l14�/פa�|�~�Ia�ʫ��3�o���R5��%���{�U���tgU}l9]6�F�:�f�/�
B�`h7:z���X�Z�a��    )!�o:߸�|�z6�;s�a8|�Og�?��:C`/:ܝҰ�+-EQ[U�(xp�b�Y{W����Ua�U�ɓǎ�T{u�vtGө������v���[�A�F�!�):�)ϧ,}���*PPRsW�Q���P����T��F��;�5$�@:�-,Yu���8kI�97Ϧ�(�3d�_h	�f�7�Хϥ�ѩF�}����f��jS�#�����TĞ�:zg;U�Xru�s�w%v͸%	�=w���I}y���Ц����SL�K���#p���y���іL��NDhy�o�Ǉ����,��J��c���ڇ��EDPh�?�>Ɨ�^2��1������B��&4���cwec�ƱZ2L������J�%�BK�kD>����
��lT����^��nX����
Gh��/����U��(�U5�N����շ�Q���a>�51�UHB��l��<�!�)�1t�4���=�"�e��aM���]����nB�(�ɔ��������A7�'ӈ�d4E���$�a =��>�A��qNRW9��Bw�0�lS*5�� j�6�$ř:U�Hx�i_)�2a$>�n5������a ����\�f��U��Kݛ�d5��u���4S(۸T9�ëF��S���W~.#mU��y����LO�M.c�-�4���'m~���Q�P]�8\��p�h
ʑ�P��C�������F�/kՅ��P�Ԗ�E6}X~k&���>�A�����l���.��a$Te5<�,�hp��Ѥa Mn.g{�i�\ܢi����׋Ԭa �\?o�� �Y�jm\M��f���A<��V��6{�"Zj��ۓe�B2��L������ђ��<����y����4�t�����Qh�n�/fWl҄�qDu<}����-K�0���FM`2�"�-4��xO�q�,�z��Dh
�E��Vd�uŭ��0����ڟ�o��q�A ������V5��۳���7¤�W5&'�~z�O�T6슚�a0x�}�c�˫\�a ��]R������d9p���ɖ(�a(�k{k*s�Ԓ�)B�B�@���۟�/OHw�W5��������E��0ܵ}ޘjf�l(��	BᲩǓ)LF�/��B�@hr�Ɣ��J�F�0�ܚ7�� �����&��l:a�C�g?ͤa$!�b���Rǭ�3i	waYI✪a$o�L��l�]�N&�DS8:�4�ګ�A;��8�e_ǅ������b
���ro?iKC�����Ŷ���B.��p؏�����&5�彣)7����-��0�7��H:U�Hh{O�v��W��0���+HFk�j�N�5$g?\�SsE�Z�kI��m����z]�@�,���Ԇ`�jU�Hr��׭�����g2i	��#�t:��{�X��l�W5�\��7Sd��]R�H���J�E�b�0j������ϿZZ3��T;ު���>�~��
����q�6�&���aE�p�jJ�~��$�W5������W-YN� ����g��b�p��Je�0�L�����i��
K�X=�u(�2�8i
�~���L�)v���5��g�|���K[m�άa$�:pJ/��JCa/���F�(����F�N��埶�Ve�0����j�:KC�-]�ۄ��P����l�pMn�)�ԅ�P���t}��P/]U�P(f0<oM�٪/�䄆�p��'�RIՊ�_�5�s�g�ḡ���B
#�xA�+a;���P�Y�a,�_0|�~3��=τ��P���dl��P���&4���P�&C��X��ýOc�j9��p�d$���t��bk�ۓ��x��0�1�>OV_��B�@�ˮ��}��0��%P�䁒U�j9�U M��KhH��S�C���|�jH��,y~d�.3����pr���|��ʽɬa �Zw��4�"��a��#�QP�A<\ks�f����B�@h�z�MW�d�.;�#q9)u<옟
�rT5���ip�)忡L��ǨTC����`
T�fU�P���f�h�DV�/����4��=>���_�0��z�[�H�N�0r�/ý�(z>L��}�)���^�!ITK� ��5�E��D2��)<B�Hjn^�ɔ�P�_\��I�H��#)#��������x�]�&a'���ic<�qn�W5��l��oG�g��I�Pr���~�fz�V5���ao�%���R5�[⪥g�4�������?��Z�J�Yg�0��~��~c��"@=k%o�l����+?U"B�@h#{�h��(�&����	ց,�&���p�?�����j�T#�-��(t9\w���p�����q4*��������n���t���a,y{�Z��&�N!A_.��l*��l����Uǅ^7Ë-��F��@��a�E^_�������a$>�խD�UC�8����;�A�[U�Pr��g㎀�:�����x�[�,e6�(���	m`6�w��&���a�a׀�E.��0�u�ה�ѝ?� �ȩ�+I~��=6Iy0����d�+$h|-���'���B�כ�n���$�F�;�u(�"�3k
�������'��r�8k��e���Ф�J�0���I;S�{��]���#��
La6�Q�a �K0|��4ds<�J�&4��+��/����-�T����\�c�q��V�0Ǔ!��/V��%�B�H<����$U��tB�Hws����jpŵ��0���ؚ߷����z�a$t׵5}��&eS��A�uG(�&B�8Ȼ'S5"u�»�����I������~��A$-�w�V0dt|C�	kH��:~5Ŵ��g%Ԫ��8n^dJ9i)��%��[ө����PJ�a aʶ����h�'4$�ڲ���\����4|woJ�d�m1�Mh�֓�����Xʅ�q�o}2�۩�u�j��'S�l�[JW��t�Z�<���l�0����鲜�6�Ņ�0�MF�F��B��w�a �S�ZWIH�����5�$p[�[�׆�}�ǛY�Hb>����֯���a��LF��(M�����T-S�:2�\ �a �j�����=Wu�)k3����fM7Km��Z�'�9�κ5�TaިBN�qc��MJ�_��I�@�ɮiUᩅ'�g��k��a �b��5��R9���Kh
G_���O��oTCi�N�qk*�!�.�_���t+Z���CQ/wJ�����[���`���v]Q/$4��WU>�Cq

��蹘�y��t=<Y]Ē&#�����o��s2���&4��v�҇��`�:�a$<�k�kU�(��������a,�g�ã1��f����I���\��ӳ1j�s�Z�0��ǭ)�r�کF��&źPRT�H���u�%�T#!'�is0���jyڙ5��[r�lyI]j�@�a$��?��ml�-.D���LN�vc�_�B�ڄ���n�axܚ��:�ŉ�RhJÕď�d��q䍨�0����Oė5�B�8��.�m
�es�a (8�������h�\�E�V��ta�a$\8;��	,�̅��8�%�ۍ���t��5���%�x[-;�#Ⴎ�qk|s<
kT#�m��t4}��j��c��0����Ŷ:�ї�/B�@���t<'��N�Q5����h*%��UeB�H8v�5��u���Oh	O�:ؚq�QW�2	�2��#��!�zk�d�QelٸIh7%��9�bR��0���e�7�ީ�A;�O��f�l.&�h��[�i�[��J�0�67�g��9B�@:^��V<�TU��y��ḠA��k����r�N�A^���3�Q�^�j7߶E����0�>mv�T������4&�Ɩ�;Y�
	X�칂����S5���oN���e�h�0�܁����F��K�4���-�ۣ��Y7��4����<�fw2%wLf�����������i����b�6iI��[���j������u�hY�#4$_o�n��j�E0ZhI��޾`CST#ᆰ�Ez[�"�4k7�:�����Y�@򨮟L5��Z!�z�ີM�� �-B�@����J �  �h�a�T�0]:��P�y�a ��}�?�Z��X|�����ȫ�CY����Qh	]lm���=]�E�^hInWx�}2ew��t�[����p�j��Q5��������J�f�FU�H(F�ec*�c�]��Ehmd?[G����EU�P(�:n-��dԵŭ�� �����t�E6�E��f�=�1h2*��B�@܊��d4Ԫ����]�Z�h��UC!;�_L�~*�򪆡�<�u(˭Ҭa(\�ek�AFCy*4����[K������x�0��`Mai6z�)�4��f_��62�"�EhJǁ�U(��~!4��n�n-	�=]����Jh	�+�7����-2
����L��ҏ��R��jO��ݕ�ѦȂ\ƻ%�c�FB�5ոI"�
DU�H���`�LVSy{�jI�X�9�q|�K&!�0�-Ѥ>ױ��#�����i�}�c���a <���ê���ȻB[����H�C��Gb
ò�f��L���䝩?YM@ZU�H(;zz[/-6�	B�P��>~21�nz�M�4��>ٲ^z*��+e�0�h���l.�&��qp-��~6�4$TU����&��֕�a(ܰ�n��FN�n�j��ٍ�P��R��hR��\���5��Q�r�D�eo�j��$��I�;��\�����Y��2�Bh�r=�����rɲ���9	��Έ�Q�0��7��H�B�[.�:�m�'��o�A$<�k�/U��bA2kI=}�W�DL�	��(���Qc�j���B��������d����F½aW����a$1��Y��N��ˌY�`h?�4��@MFc�jH�]�
�ZY�5�f���ۣ�%��nUcᨬ�0��b�f�P&q<�ֶ3`��r�0��?=��;�d�-ڟ	#q������[r2[� gC�����c�AӔ�c'{|I��_���p�_M���a�_�\a��.���a$��,�x�i�E���0���(jX�n1O@jK�w���b������Ti֒�aT<D�Dm,�[�����s���d	�f��t�R�H��dH�J6)�BD0��q8>�X���h����Y�N�+yP�FB!��R���_�?�J��JC`/��)N����3iI����Z��ɬ����a(yH���Y6�* -�i{��(-�J�yJ��?Ms����I�@B���+HZ�*5���fO�qTl5U�W���p�`��[X�a(9;�(�F�zU�P}0%��UϤa$17ɳ4ob��H��F�>���}W>9�\�*��AP���tw�$R�ѩ��A��%���c�������[K([�~�F&"���n7f��3��0�:��V�t�DSj	o]oM���t~Xr&#���Ϋ{�-Z����A�g�/�f1�@j�u���AB�ĥjHÙ��O٨_�m&�-אt2�Pj	�%��������5�=�*�bd�� �&w,4�\&�m:�D�j	�]	�i)�٩���4�e�)��Q5eJ"�ɸB��t��]X�H8Wks��>�ݴ/�Tc�]�su��D�0�&���Y.O��.�V�0�v:�X#Gd6*(h��rp�r���6K??i	_m=��v+PہI�Px6װݝ����a$�u]����rp�Ѽ[K�y�1�I�H����ɒ�:[��a$|���0l�%�t42UXjL��<���dv��5�}�ac\+l�<��F�]��x�������t���p���٬WP��c��2�ٳ�4�f	���FvI���FR����h($e����vv��5�������ܢO��0���Ь#�T#��Ll�@�ը<�t(������f����USU}SR�?Tu�-2�J�jy鎛��n2��?5����̂�����d�g��G�R�P89v���^�����Q>�Y�H��k�L].5���/���nh����H�a$�n?Z�_�V�ׄ�R�H<���rئk��utW�a8��R��V=g�F�dv����4�(���L��j�_#M�����&g���,5����������4�      �      x������ � �      �      x������ � �      T   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      V      x������ � �      X      x�̽Y�9�,��w���v >�_���.)dU����:�~܏0UN�y��d�
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
DYB}��v.�;�.yN��Q	��=%p4�>��XK�X@0��A�%��P�Q�ra����΢�"C�j�@v[�\�T�춋J�T7N��m�	a瞮�C?�*�X������>��ύ�X�I����+n{�<��p����"bJ�d�C�2��lE�ۅ��Xn��j4�XR6�y!<��o棊u�4�fo�ø��k�UŬ�&ȃT=�F�Q>��nT1ҷ|�!x���'3�8p&5���;�bn���\�"F�����v��y�}c_�k�*�15�-#�<���!K�X�i�65Xll�k�c��sU[5+�U���L�p����o1�f��u$_k��LN�#�65V&4�7�?��z�-�fq���'��7�D�2�>"ͤ���ڻ-͍#Y���O��=7�$x֝*K��i�2Mʜ�2��� ��<Tfe�m��?�d����_0�h����<�'�|	�z]�`�6/�����������?n�%x�@��QH�:�@�Yrr��V3�z��	�������.��H�J�k�ݴɒ �i̇ZНe���X�XA��Ӵ�T��Y]Kr�Rqq�����N�Mi&<�qG�ic}�3���f_�VךE9�,��x�H��� +W��l������H�+ �fr-�[4b��4.l���	7V�g˵j�הm��9V"��tX-�9��q]��3yu#��{�0j�C�"0ȼ��1w7:ל�7������b�B��Z�
�	d~Y��,�}��e�w�&�
>q�`�yC�M2Mu��i�������=tqƧ+��Ӧ�s,z.Q�UWӦ�s�c ��FncZo����8h�ť
��� h#Ι���nڬ�܊&���V�	�>��R��)�����M�H���A�:鬮���c�yj߹�%,���:���2ٜn�̼��ƫQ��>&�����8GJ�j��#c�W�e6mZ�X�� (jkH^t1m�VƘfUh�p^j�P7PuB�,7��D����0��7�q3m�3ٱ\�e�-�EY�ݴ9�F�?<A��M��ǂJ=�������ɴ�CKq�IBQ�: ZY���Lצ�~�ew�    ��&��
˚_�&�pe�c��Y����.Ź
謺V�D:c�Ԛ@�b�5W�vzE;��������A��5�0ɏ�[J���yx����es$���#�u`�JP&uz`N$ܴ�O&�}��P���P�z�wQz��:Pu \u�L��<���(�[pb�j�;3�[_�Xcɵ,��B�o�M+n�J�d���I�\I1�VA�&�Pi�]6�1�����w`�c���,��͗���j�9�^%�[G헍���\'@���ā����o�p�ß�twP��8l� ξWłg"�
Z�6R0I���ݷ�X�0�W������B0*5L��ɑŦ���V��R(�pV��e�C|'�H�=��̛��¦�t\A�	�������т��#L$-uO�'-��Uj6G�8U�� ��gӦ�`�aW�i�Y½�_(m�zZ\�y���h/�H�E�ܾ~�Ŵ���G~���1�iZ?N�اl�^Y:�y�IX�D,(� |�;_�v�06)u�L�Mj�������ڧ�5ذ���l�R�����/d�������흔�sE7�d��þ�3�[V�6���2"�x�(x�0b?*�mnI��0m]��2�ˠ�����9P���.��G5b��}�5>�D��^5��1��Ή�$! ��.����+���ޤU��T�UN�8E�� ���t���~�����Ϝ��ʒ�Ҧנ2��C���C�<�z�͸���:2��U�c#�8r��h�����q�N:������G\����Z$��!�6��d����1�BM8��F �(U-J[o\ԏ~D�� �j�:{��1+<ܿ�����hXM����K������\���L�mO$wv3מ�uqS�\�ɂb�39��z#�)V��@�M�|[%�r����}���U�;�6����I<3k.�fյ�XnO@6Y�x���i��5I�NT��Ѩ�M8��/�{=8�Y���6�<=]64T�`��`�l�t3�&e�4�M����a2iB�>]$���b�S�#hD�%c/��<RXe���i�ۉ&��eU e4m���@�3='��-F?Q�T�mZ�ٮ�l��O��Ѵ��w<`Į�D�����CX>N��a1ml`ŀ#��8S�Zi5mZ �f�t8ޛ���bY����R��-�!��}�K۔c�*O�}�'�6�Dگ����t��)l��q �4���Q?�-	�ϦM��l�0` �E��t@쁵.�����ٱ�U<h��i��A쇫���zLW�3y<t}Z=��v['���[M��i_j��+9Vji�M�G��G)qՁ��=e���N���/�B<�Z�.7�L�i�Z:p���A����P�tz�i����a���>������~�Y�w����Mk-mj!KM�`��D�
é���k�x���7L�f�i�SSPj>55�8R�iN�b~�A c5m�ҿ����ï�?����O*��4��"�
�i���4/%6du 䶣��"{��"S��69����f�̉�?z���r������L�X;��Tg��Ob�x̺`d?��7F�e�J&,�i󴌳tt!]4��sXS0}�/8)�l�>�B����ul���̽� ��@���F{�Y2�|��T�����"x��D��㌣��s}Fd˛raSK�H�x�m��d2m�u�pd�����䍦p�(lDvj�zKPW׷�t��a�g�0~<���g�GN��`=����٦��9�F��џ!�����p�P��Y�nv�R�.�#QvvX�
�J6e���FJ-�¶��٩.�C*���G~�/Ք��(�-M��p�D�d�HBj���'����G'�f;�|� �6�>��L�$���\M��l��xV�� L�x4w#�J|*b�4��|��)l,i�`Ͳ��V��!���7��l�I_�|���Z%/�:�|��6�G�5C�	_���}�ՏC��m�tV�̀��.ɉ#y"C2'��ɴ��d>�k}$REz�#^Χ�d��v�F���LF�6�4�x���Z�iS_�7}2P^u2m��9�=�����f�����J��/����ǎ{�\$rY���!S�>��0mjzw�DI��C��H��H�C���2�ꝥM�㐀nBu�hnJ��.uqt�?N��U��@�Gݵ� �<�6���֗�;��J�88��K�UרV:���f1i�c<��o��y/n�6�� ��C�#�I(v ��C}Q+.��M[����z�֕�#����lc;db�L�1�6�]�]z#T�� �ڐ�a���.gIYlZ���޺�s#�|�z��BG	�W��3���p��6�Ó�������K,�����|���2W��#G��1 f3m?Yc����6�0�Pa��ēj�fC�鴙W�bO
���6�x	r�"*�o�R�|1B���_�A���zZ��sX��-�<��0@�"Ĕ��R/{��t�Ht�&��X��I�6���8�3ۄ>�wjg�g�Ǚp�dI=�=۴8�PD�_k����J�H�l�����s0mb�x!���qDL���Ԙ[����T؈vw�s��b򶥫Kۖq���u�FHt�i5F���-o^بd �\�-��R�ic�d#�	+4=��%K�c�%��k���T	��C`���v�&N��#�&%��h���d�y4G��?mb�<�6��1�HA��@]'��_������C!�!�ή��qM+7�#��`;lu���1�9�Ux��	�R��& )�t-=�6Y��*��JNLu�A��՟8��5��H��O�awʸ0�N�>�p�$�����*l��A��m���l�`/�ɀ�P�=��Ǡ�<���"����X��p�ʎ�¦�2�	�G�ݴ�I.ơ�{���g���'���2)�-D���1M;���s\@r�Fyx�j]l������91ۤ�X�n4�~dC�#1�@ڭ�>�5�xT�1N�w�S�n�[]K`��h�U�iL���Y�Ҧk�����Y:0�>�vGYCȊ��i#ek���Ų��t�w8����^����;�2V;%��N�|EaS����&�iey�3+���d��k%8��F��6ʞ���Ay_����.�ܒ1��x�a�Թ%xЈ�̸H�>	r�)��c]�IbO��[�F�a84'�p�!�m�V�(!�I}���n���͚��Yp�V�[�Zi6mZؚ�h�ݨ%�c�~�M�Z��&��0U�	rl$���I��t�6�&2��Βk�ٴ�g	���Yp�ɮ�����jڡ%z��r�6�I7��%O:��s���ږn�i�td}���Z]>��s0"b���W���P�i %�CE���f�Զ��o�d7mZ[�H�jb,v��
����O(bb��h±��3�P%�N�����b�ߵ�a��
t��H/��I��y�	�6�Yq�g�.c�~^/��[���,��&;�V���<Yhh�u����0��$GY���_M׈����R��Z�N,�91z�vL�!Y�"�����4�O���m�݅}���>�=��ģBzU�Ca5m�2�8:<حfͫ�a�^�A2�{�l��nڰZw�UA���]�+�����7�W�F
$�H��ǻ�]�M��_�Kk��\������kF��Y��B����`�-(�炑=JL�I�pO)�͐��n�-I6�����h�/?� �.� m�ߞ�	��i�n���/M�5�����戊���i�4z�݅�i�F���Ӹ��0H�a������w�t�?l�ć!��J�#����)j�-�i�I|�?
��7W��65���X�N��;��ɷ����,����ٴi��e���5I��V	�ӆ/7W�̌u4p�Q��6�Q�sH�:�wu(XIٖ�ժ28�Mqn�-at�� �϶���b��]�L�EdSz-��uKb��e�$馊�vH�bQƁ}���
i�o�"y���7�-�r��.m�G�Q[s�c�eeFm�A-��o4i�T�TOH:m�5�we���zv����Jhx�}���,�E{Hr~�1�    65��Y��29��~HtG����"g׺�������r���@�nN��2_�N��Lc9���ly߀i��M��ksi�h�9(l�j�nN,Rq�Du��R�T�mQAc�L�\��&#�T�r-[��M,|� ������. ]�tmn�DI@�C�%X0�@r�հ�6�k��f��W�$�ǌG�V��s��&Zژ�
��i�z�k
+�c%�R�$m�y2m�7�k�Ѕw��o,�H�k����,�*
�C��l�-&�g�i��	�h�u`�	�������?�:XU�1�`�XM�,�ǟ�ѫ99I�^M	(�g� ���M���M82¤i4{�ky�*m��z��%�]ˋ�0���և��Ȗ6�"<�:"�=@��wP�����JtQ_o�RJ�`~��̷?����|�~c����j��|����p�¦:E�Er�:$�SDn���ũ�qj�PO
9m8N�zuF�� E@�n��w����ڡ��-�T�i���W���.-��9a����Xq���R鷽Sؔ���+ S
1w�^�Z�0�j�0�6R��t�Y0t���Br��n�x'��:��O!C�B��%Y�:��m�7{�~S�����=�ڌ�Wk5mrB���/8�ΰ��(Sڅ��z�l����	:�d4mR'8�XɦmFէ��bki�nHz�;8��@�KJL5��1�S��$%�xƊϕC~"Ou�`��'���i�!�f�J<�í���c�`�|�|;��l"?� G0mޒ�>���~*�2��P;J�#�ٴ�W�af�f�i1���㸛6&K#H]�k�iSYυA+��a��h\�=��2;�=�T�x}WY]`OӾk�{,r�3Dy<�_yvE,��{i���P�^
"�+cĝ�M�HA��R�HId,R�AQ�9��i�Ғ�c���S�?�D�Ӓ�ƚ�V_���ŵ�_"K��!�g�+���瓘oS�R%y�Y��z�~�_~����|x=�ԢzM�#���4ź�d��L��jG��F}��dRq,�UB�l�<���-�޹F,.{������K(�w�H�Q��Gh6,=\�����[qsi�����P��^����3���f�4aJ����(��+g5�/��6����Ȣ�+z$ҽ��1�{�Α��4�}�Ƿ/�����T�q�-{�^S�%y�~���B��� O������!g����h
�M� �PRo�u~>
�ˈTZ�ƙx���U�&�n��<�\Z��pyHDJ��_���mtH�D��xgy�6�@"qR'�r��*0?m������+��J��A�&�E��b��&�dXQ=���{@��6�t8l�&GW�|����.�w1�B{���qӕUr?�,Ba�(
��-���:E�mZ���]��4��7z:�i#���3���S�?���zPT�94�XbR�p��HNC���`Ž-㲱P�_㸾ʹV���M�p�)pq8S)/08�hu��/��XM�Pf�ެr��T�]�9Q	$��j2�gn�-v�$�}�v�{��XӦ��q�g]�=��X��L�ͷ��M8j��t(��G�	���G�Jq�*m<����$��;Z��k�ɴi_,�#�is���/m�0-����0���d��0-AI�q=Y*�UB#V��:��$-���m�Z^N�Bߙ�����i�%[
��ܱ����W�����Qe4m��c,�s� '�6��Ȃ�x@B%����y�M��%s�6�׺H��� GǛ-��~8.r!Ӑ���-�U��x:9f���y�X�|�6���̜���V��)Qxs�_d3mZ^�$��^�����g�Y���)����q]L�:t��eP��G���a���p}���iG[��$�{�kic�1nS��Oc���i�u�����G�
C����vc��A;J�� qIǛ��J2�΍*)�NSYEU�p���ȱJx �ݴi�A�������Ej4m]���ΟUB�/H�i������Q�f�H����Ƿ��$��	��I[v4m�?'T�������=)˗
�Z�~@5�=J2>޽g�o�Ҕa�)���_Ϧ�[�0�e�~4��'& ;�brNы\���t)�iڌ��1 N��`U�45^ �RE��K��k�DQ�:��;��q���gЄ�LC>j���l'9m���>�p�"���&�gF��Ѵ�I�Y�5��յ0-�E�|�f�@��d�g�F�&K6U9�Q"��Q��R�x����qƴÚ.χO}��¦
B��K��`ڴ����&s(�	�.��_>���'ʄܾ˅M���_N(Rk͵�hڤ�8V�6����b�UiSw늇�L��<qc-�����0b�B�Þ�����eOA��%x��j3zo�T��$Mxsb�=}����)m�L�(�H��l �z�K��p����D�oh�O<�f9j�95Hoo!a��8�ֲ���.I�Ş!Hv��h���}4(�2�^�z���#e���,`藋���,��ɠy�͇i�����c!þ��y�i,��K���U.��'�7c��Ȇ҆�����z����q-T�*����4��57�ŝ�2&]��(��)�[Ӯd����M��å\���e֠�	Ee�`�|^> ��z��Y��6��d�����4����#;s�=�y�h|�+�	+���z���\ʶ�a�����v$�ĺ�YG����6��t�6��`d=D}�[�v��gy�ܤ�5�e�=��_��|��#��ꪼⲵ�檮b@jN{H�q�a0m��Y�>���i{���|m\l@���qO�����9o��5���m�D��V������d
����	65��3RE�Tiӳ��VpƬ�6�h���6Yg�����u�=�
�y���Xp����q�D)VX�x��R��O�x�'����W�2/ ��������������~/^v7�C#�s<�P����9�+��Cu�����4�6�hX��c�>��j�c�TV͕6����xPfs�pҷ��<ӂ��EDfT��X?�4J��2�q}�<��X��g��z��������_��5�}��o������>V�$������N�L�b����;�Zg%C�T�w=R�)�����n!��b��)m$$@k(���J�i�:�1�8�J�{/�~��T�ԡwX?i�s�}$ݐ��/%�%~)���8\�*���'�[���55$!K�nCzۛ�5�l������]Q��i��gcKp6����l3 `v�v-v�h٦��%
�[�$�),�eo��J��4�h�O����-m�qG�?XHtm5X�[?`a�O���0x.ǭ���/������/�0�G�q٘�{� Y�j7m��}�j��5��gy�ٴ�zdy.v�c�Gv-��6��pMXJ�y���~+b(ld�3Np2aq��{����Ѥ�;`����Ϻ��1$T:��M�D�*�2È�=�\�>���	�3Bv��ɼ�4��u�ͪu&$��XPT��aR}�4�گ��������VGM7��G�4[؄ߪ��<�⸴<�C�P�*m�P=C���É��`ڸ�ܸ3<�\���i��baR}�k�9VO���MJ��:�3s�]�6�&u�U���	����U��b��q���W��KA<��ь��O4}o"o���}��˧Ǐ������ǇO���ׇO�G��?����%o�2j7O�G�`�-77��	?V1�{¤3zjy��Ջ�x��&����^�Y�	��~oLֹٹs�dj^��J�Y y�t���\ �Cy�F "�5��C�M���0A��;~���to2,m��u%\�I������LG�KW�X=y.�ܛ�f��̢u��)���F��.�^�I�}:�^�y_y��Y�&.�y�|p�k���֚-��V~�i#c��wn#[�	RL�^�L�[��H��r�&j�!��'�ԑ4_�=�!̦�}�ᐈ��Q�;N&ym��'/�Y]�r�V}&O�<ą�4�)҃�7c�մ�[� �_#�Q���Qv�#f����ހô�"fϤ҇���[��m�� zZ�֘��\=mN�y{ �q�#�0M��	@    �a�H7Ese<Rc�n�h HH�v�b|�����g�-f
4�7�<e}XM[7��k�6|a6\ʵ4�Xy��M��Pp��Bb�͏�X7T7��&vVP"�Y�b�~�))l«{���}��������R��K��t�7lǾ�M�����l¯wF��s��\�U(	�ޤ
[�v�GG���hPp���ȑ�B���ԝ~`|��	I�������4�nD]��X�ݼL���}Ⱦv���l� �ϕNZ�]�M����)�dY�x�e#�)��W/wAи�!#ͦM�@��;�����1�W�����#�Z��p�s�̯�x6�G��`6�9�9]�V�iM�����ͯ�D�R{��D�q��t<�s6^6��z�����m��1'��Ӵ�6��}�\+Sy7󙍝M[�Z���T�,#n,�j��L�,��Wi�[��k;H-x�I�����r�$��G�go��U^���*l��ܳ�����c�\��6%!�φ���h6Ζ�YӦ6-�x9�w�y��
���YظT�8���AR���������x��0��ncL|�9R�������g?W�M��gS�8�l�9vAm��s�}���h����m��9�c��iY`�-�����,��p4m�v���Py���J*ʕ�7�ݭ��í?%k�����Xgqd��݇*qV7�:��������B~��lm��!��6=�9!.�h??��n/�3ϑ�VZ�~����^ݲ)bi'R�k��ӻŽ7���l�x}��q��̑+`H��>�ƈ�Q���=���īZ�gv��ʹ��8.IL����ߑ��!=�鼘���8�/F��F�7m�0�6�Ԗ�e\��VE	�H
v��yL|�昏Ky�8˵�S�OXM�K���/z�l�F�[�Yacu��6Nx}�m�˨�6+w�,3a���~�Ye�i�[-�w��ôu/O

<��Of�V�����rp��%05�F�� c	04�%�d���WG�hȻ�����$����?h>��z�.[G^G�w"��\c�rG��V��5���풺V����`D��t��H��mJ$�ӕb��PJ�G�PР$a�ԛ����ʮ���~;�l���#՗\+o�����C�b+��
�ܐ� ���i�'�jG���D��D(e�^���z M�l�k��O)�Ѵ�ٳf�{P��s?���H<ndaS�]8�Y$���A9b`5�5I����a�p�{і�i�mW]ϗ�Gx3m��N�~���6��h �lx2~����)l�Y�0pj��:|q��m�����6ш��X^�*M�W=n�,���,�q5C��ށP��`"�ڜb!f���Das�'�"Lh��>E�tMX⸑`�<���D4�i�#�U-��r+�*lj:��(c�^�6�P���1n�ۛ��Zs�_�{�|��f�t�f��� ����דw�F
�À��`d��2�c ��S��������@>L	
Q���K���icm�X�aǃ�\�k����4��Z���$[>�<N�%,Ҭ�k�ݴI��i�4nd�I��6�-@�/��&��D�65�T�R}�N��$ʶq���oy�$$��d������N)	�s���d0���Rt�\��US����w����ɉ�mVh�Y߯bjg�.���J�jX`,�P��4T�q����ktbYB[���[l��x��V�M�v��GH���^AMƟ��󭆬��<^��������R\ƴu��������<�| ҆�q��>��w"�!8XT�?dq��g��	���G�%,^��YlID�~�)l�q�U��t�]�.�M�X}�
�Y�I*l|h�)+��յ�� �����`�����H��;�<�=��xC�pb�-Z����
�G�ڸH:a�>G@��zbm�����>�*=B"E&:rd��)�;49��������W=;�^^��_>G�����|�'Oq�;L�a$��L�$3ǌ���7�Ĕ��5��h_#�A����cH�a��k1m��z��J�@��'�XU����7í洴�
�PP{��%(�?����Z=�B�4�H��_�è~	os��_D���S?���^wJ��I8ȅYQ�ڷw� ٹۊ<�%�D�����q갤5��n��>�"�2/D���R�5q�=:nEJiS[�W��X��ת�iӪ;0�4�v�P��a,�0m��Ƣ�̮U���Ҧ��8�r3�q��Ub�y@��{/JH����_�x��9�e�7�y����k�"�Pڴ���P���*�(�&']���[a�'u0$�Zp5m���8v�8��z�-m�q�����$}-�<�d��������7Td)K�X�RPi}�9�յ���=�79z��5by�{+�a.��JW�� ����/�:�������T.5ލ�>��ʹ�"����ݼ��r7�a��λ��c"j���~u���0���d@�H�P��ƺ��l�%�G
P�H��x�����(m�NbL J�Noy�N���ꔩE��r�uio��1�%������M�Rf�R?��+4��af;�E9����HI(Ʊ�hA�-\c�z^�DGi��n�=X�p$�Z8�6�G`(;�t+����ʹ����EP��ٲ�K��yLQ��yZ��ʐ�I����?��s��P�b�2*dh��<ܮ���)�A����>uVג����S��d����M�p���T�յ���#FAC��\��:�4�0>=ѧPҘ�o��"�f�vN�ƻ�S6�+T'�e�v�?�������Z�0H�%ʱ�F/ׯ�dn�#m�a&��-b(�����͘>�i�L%G�������y��P��&�L;,R<�C�5K2�Y��Vv��6g�䀺��tg� �U4E��t$�[b���5��*���P^�q��n�R��g���4䖟+l�Fo賹VWk��	�p�k�7kEN �K3�6�	V�')�~�:�6�	�p�x����#�:�ҩ`�Ć��I�Ȣt��H���A��6�8�6���#U�tP��
B=��}L���}&���T�밀��"�g��A��{<V�,K�6V��"%�; J��aAk��XQ�a�M.$�Z(�C+��nJ�7�\yѭ�+mPz�*��b,�A*��0h�\�� _�ڵ�!���-mj]&���,�%��hE�cH"�ު�;p�Lk f���c}|�P��.���z8I�7ظ ��[Ρ���8~b�8�#��&�?��ɴ9�G�.09�@PFu�s᭔�,m�ȁĭGM��G#��?�#��U��#�M��\�x~�G�+P)�@9�Kkl�%����P��7�� �Ѵ�js��+���	0����G���G�����_���մ�׏,`�����⮌�ض��l�E�C���������X��Hg��e��4O[��	��.� ���m�B'x�L�8�+'!��^M�6��%1f�8��1� �<[��x�񴩪7;��z��h.8��6�1}\nb��Mp�~��К�n��P��Ki�$]��^�㰽�0�&�|�����AH�m�Hp�iL���b�ԙ�$���n]$R@�yȄ�&�U�wӦ$;(j@��(�����.�_���P3�07'윚�F�&F%)'"ןƻ��i��M��'�����ϔFg��MQ�=??pp�Q?�y�`ڴ� 簷����۾�K�/��kB�Yjw2mr{2~:3i���ա�e~��Š�HcrAm.�I�wL���
*F�P�`ǿ�y�g�g(�C״����^����ڿ}�������耙T�@:�h�4����]a1m���r!�:���#ĳ���~%�މ,�_�H4�s,����H��,����&�#k�ҽl����)d8(�0��mr�%F���4�-5��Slq��v.��$���� :������l�
59�Z�����*'��j
JiS���AM�35��9d�s�y6m��
{qD�����8����æ4�ٺ�W�:�:,jf��h?�c&ӄ�{���[�ZĪ�L����pt��F+�d$�    ����V���_�}Gs����ƌD�4&14j�+}��n6L��D���-'Z|m�,�\\?;����b �f�J�/[gp
�}�WE �W�m��Dڷf�D\�B:���n��w7ճ¦�V�S��lڴ��`SK�oA��}S�(ld�{��Y�Z\������2ǿS&O�r�����ku�S_pjKb �?����<Eɸ��N��3�EҌ���>0V`T���(V�s��Z���M�\��Q�}Յ�vu��PB��MQB��'Wm4r��o��������9O�q�|��x���M�h���ǀd6m��q��m�g��W'�O���ا]`��E�9-�C}��i��zvG���(�C��M�mr�j�./���CWDM\1��I\u��c���I5��g`��i�M�$����#��n#�6-�H8vR�oT��kU3w����x�H��s����ᮢR�~&W���Ĉ��Wz\�ͩ����
�& (�6ى�(�앋Dq�D��9-��nz>m�W�SoHib����_�lӊ��˫6��lS��	W-,�qGI��s��E�V��Eօ��v9�B��I�娧Ҧ����4:W| JE{CQ�����C���7j����5�:n�"7�6�"G�P��>�6ME��a&(���%(D(1�E��b����\^�v������^+��N�S�ܹ����84��dSӒ;�:����"�²�c�m�mwQ,��UJN�(��>��C��ڜ�Ld<��%�e�ô19SV�;\�k��#^�����r����c���96��Ec��*�y�X�ۑP��޸��,�A9�I�n<�,���e6cѴꑸ`�[!A9w�ǡ��u|����q�9,� m���RϋiSP
���H�{!�8�8���^��,���`&fR"r��Jp�,��	y�Is0m�tb&�uد�Z^l����Q.�nM�f�~�F��&�}ĽY�<�6G6xé��.9�Q�lp^v4m�g�9�8_����S�{]t�4��۟���0�������O�����M���8e��ѳO�~ٕ~.4�6ɕ��:��:Uk9�l�>?�]�E�f�CH�FM�m8���� �� �6��(�����c����Q5�^�`�js�;U��w\*�T��{��e#��)�����c%�6�.�s�i��f�h�P�V�0�zٗ�] Y�ԻV�.��c���=٫���&\s^._�2�Ӽ,�&:��HI���hs	�&�e��a��4?�q�'вr�zcJ�]5(��hLaw�C�Sڡ�N7v�#à����)�|#)l=��5�~���E	w�5ۧ�q8}�ϯ�+
����ޒ��M�`Dq�e�ar����c��+.g�̼�,Q�m-T���wQ�q��R�Q�"9���Vl��fXnw��&�d~В��-�qb:$ą�?�k\-���<J��Fd��=�X�s��0&��q�L[����4S��i����
��3?Ѳm>7y ����l��hn-#��3Ί)ܦ6� x�"�>͡f Q�嫁b���p���4P���á4�QRӶ� �p�+61a��і��I0mR@�rĦ�U	��U��	ɶmy>������}H[���8�wD	�u0�����IUБW]nc/��"38��^�+�&��t8�yZ��<�%�|�Tr�׭称�5�D?
��C$�i�J��v.-�Z���}�ڮe�f�#x8� g�

f�\�&N�����=;Y�nڴZ,2 i���aڔ�D5� �Js5H�u�ȏ��3� �b�"�m���mt|aS{G�x�i2�@�H��A�a��7����l�X��q���a�:
�.�������H��..��(#�꯯y�P���&�S�H����N���q������s�N0�A�����c�4՟�l���Ɉ�y8+ʇ#�q��ܸ&��:���M��T��)ڡ�E�sQD;�(ڛ�H��^d�����:mj`�Ƞ>%��o��D�g9���q�o��0�'��܄��S�8m��8�0e�$�D0f�j]������3�6cTL�6	,� 0����5C!I>�'�o�v
��W&����d3m�^!nFl/�!v�����6R�8���W_�d�g\�Ԅ����o�6�#�xިku�W�p0��ƫϺM����������D�¿�<p/�:�k)�]$S�,��D�.2R��_ST쬎����e<�݋�h���c|칚#���*s�nkQ^���}��!�PMƁ.y�y^u��H�M�~N�bav�XIH@��G���i��l��7y�;�y�H�7�sH�����UR8��ٿ��д�0�5�.�H�<$�9p��$U@��Y���c뻞X]{��U�jz�;?ӻ��ɐM���qM����=X_`�i��mE���ouB����D}��q���窋i�d;�4k����d��J��w��9�U�Ӧ�>Xuq���$��j�i��I}G��B���lڌs�JsM8�D���8��D7;$�:�P,��,0a�pt�cT�j��S]�y�:�3�_��@>O����>����F����j�*/��&��Fu�)�C&Yb�F��=m��ς�XP�E�l��I�_R}C�ljR���E6�DKJ��x֯sܦE6u�`�e���.m�0��o#�i��p?m�CQC�D���$v�k������,7��U����J�<j(��h�4�AB��y�ꍒm���D�CbtѨJQ�C͌3�kf�p�węu鴹�;&�)`�5�X��A� �c�z�A��T�`liK�SyK�m��$ތsx>��ic��י�0�f�^0�6�+�9���������/�ЉJ^���6����׏^��v�v��|�b�w�^�G�J�����UY�uG�κ/+世]"�lO�Lz���Բ�>�i� 1�TY�����F���ZPy��B�mb⏀��%�W�մ��P,h�@�z���AVܩ��rbn��65���F5��H���вJ�⧲JiF��d���P]�zڰ�Yu\q� �qq�P�B��͡�Xx���6 ]qI=���Z\
�2�[݄�֏K�M�,l�Jm#�9�V��wӦ��&�e���a�	�65}�Y��#��W�!Ϥ���b�`�r=mj�ނ�)W�L\$Z��Xp���5�U�`�Ġ'GQ��D
zv���y�A�ϛ �9$��u�䴩9���]�D�YpS�ч��2J4d^ZS�%=��X�6�\�iX�7b�5ry�մi5r�#^��q'Z�aN��%����1����~��뇿���~�q?�8�~�b�e�4�:R�V�O�x�n8,%�} ��0�U�+n�/\�W9�X�a�.�B�յ���9�6X����ɶ�;r��6|y�`<�E��9�>d����F��K^��+���)��p�r�o�@�e2�_��Sd���m��W�?m8t��$��C��"(Q6$���񡈪��i�{�oB$��F���Moܓ=�Z���6��`'���(1�Qb������1gU�ʜ65��YԈ"#�"��c�ߟ1	0V��i�?зߡ��Q��A�m/6�w����Ɔ��w��?`�`�4�s�Z�����gR���Q�M�∯L?m,=��Pxi�^��6-=O86y�S��LG�ٙИ�R�Hc���V�&&�:O"��"H>�.���~{��_}��� 
N� �[1��Ny�y3m�z���"��Ņ#��98�\ o�Q2t���h�w�H1hB!	�i�s��	�]�Kq�~����<W����tgs�6)�����\�=���ll�6�I�w5mV��\����Y#��%�rU�f����ٴ�&�;}��, YL���$�@�;I��yٴ�p��E=��r�Q,~�Ds���6���9��^Ԉ$�����M/uP@Pԅ�;�/�碌�5������[n5��y]����VJ#][{�E��>�l~�d{��J�phsq�([��r�ȵ5`����4�{NX���3�V���G���ϟ�/�������ܞ�e���\�bs9hCp    q�_�N���6M�&���f���R��N�~0���G�&��Q~�'�d��n���/�c>և����-�#�IW�%\,d��a�m���Eʩv8����/����FUb����/[��:k{,�܇�E�Q�p����2eP�o�x����/�{c;�N���}=W!�˦�r�-��ʲ�F)��8�h9ƏE�ɴ9/I�4����v�ɗ�2��D���;͕*��p�˗p����]�O�9����ͧa�ߢ$��RM�ꁱV�����RW �G"���#� +|$m#-��ɕ�x��<�!�x�phI%
����򲳁2�Gr&�{ Z� Ő��:8�*桹�6���F�d��窻i��K(�<�qOs��F��ć��#�:1�@�:�R���8�¦NG'�G"�t�^��M;c)nm�.�y����^�����t��V�L�t�g#� 2H½Ԥ��Y�7p�#�}$Z��Nru/J��R�z�f�*�'�E���C�u�q�£j��P����u��9����6����Ӝ�Se��U˒�¦���:ߋ�Re�Ҫ�b�I�M�R�ߚ�.�בqxN�um�ɴ��XJu�ӝ�h��Cj.�p��6	���)�=��M=f9�z��U7Ӧ��C�}K���-�_�|#��C_ס�<�q����9g��r�I�����3��g l_�:-[����l/�d�D�"uX��B��F�?ӧ�i��a(�/�:�k=���\���d����ZX?,��܅M�?�J�D)�-��6I��`�a�7�M��1a*�"-2�6}C�n�y�u��p�s�`�e���=q�H�D;H8� ԡ���5`Ѳ��eL��P��N)���+����L�TM0� ���c�v厝6�&����؄��="�צhC5I��:9O[+MK�h�~�[��w�$J�]����i�)y#),�2�'�6ִ��
�����5���9�Zݨ��#�#b��4��o�<�@D��wu��Mq����*�� `wh���#�eak�-yd�d��e�ꚛ�[:ɚTi�!�Ա
��I5C����hۖp"k�l��3W����+�߼��ݴ�bsH��[IV�,�]�)�60'U���9tC�O � J�d��` 0�:_��\r�r�$q�f��d[��)�8�0}�;$�3������9k	n�hEsL�L�iSt�p�݈-t 9r�P6�����Gï%U�rRv�`X܅#�3���s� ͅ�ۂ�Vl.쬮���b4�$�R'CO��/�G`Gp�p��kǅ���� �.M�?�6^59)�x��Ȝ�6ϗ��`��$<|v�s�}�k�NΡf;ǿQJm�H8��,��:1�65��'�H�'ဣ�Zw$�J���6�+Z��v�A����e�g���6~mg�1��Ӧ]>Q�l^�5F$��9L�AM����W����Ĉ9H�_P\cbvMW鄾�:c�Z)�6-��8<%�k<4���i��F��2�~K@,z�f�l�}��FRXT7.�� �B�i�RCRd�`����'"l. ���P4�&��`�����~-��On�5Ŵ��H�O2�>�@p�U�\M�VU�Mx2W���^F��z	�B�$a��(l�v�!�x�ku�9��̆2��4��p������q���cTEnB���V��"5!uH���ؕV.�W��/�ˌ~T�8m<�WJ����ú@�_�q,p`��=.��)�m�����8cr�ؐH~�	
�.�iS'�j>��_,@�V�߆z+�u%�iS���SE�;$ZЙsh�_���fY--����6g~O��H����x����г��A4��	lq��R?�lS��zs!1��h�G�mR=+ǰ7M0�o��O�\�O�InN���0�M����_��g����"�@�P�f��e�nڰ��U8�Z���;L��c٭���71�=��X�i�qT��+-�M���Li��ø�-���/�_X�G7�`�h� w�Ɠ>��y0m���g���ǳ�5?�qq�f���U�iSsjx^�
�Y#�Ŵio� �OۛDTS�O���W�.��`�kG1G,['c�ݴ�W������S�b!9��	�M|�L���^�_���\ ���Pp�os���U�󲩗,<�'����窫i�.Y�CE��xs��M�:c�o��M���,b����aڴ�9� �u�$�����M��p����hڴr
��fM['�Q�\6U����m�U'Ӧ�]0Ҋ\	�s����E1��p� �{]^��1|�k�<�.�mjSa������ 7���]�V�RM���
�~q�M�{��f֕4���߸j���l�	�S��4'��r�g�Ns*���,�jw�4�����qLM�mw^k c4�����~)��M�/�]q5AS�����7ۄ}RN܂q�x�]8ݗ�T�������
�(���ͻ;���xƳ�\�����j�xkuYA\t�M���,b�%�
�Fj�i�?�͏�l��{6Q:� _H9���z���� 4�u���D��F
ƭ�d�4�.�x� �đE�Y`�f��t�;?1��бm��i�B��lر�I�I�f/����D~�"5*C��-�M	��0ƣ�+��`�N�3�`����dz�h���Y��7W�)&x���i{mߧ����󞆻d��>��}�2��/�H@S��A�3�@̽�.Ho/�T�n�Q�5�U���f�B+G��q�汇�}����~M�9f('�(��c*W�[m�V|hv�Ƽ_��%wX��Z]��w8�7�
3h�7\��y��.;�y�U.ⴱ�� ����f�īt��y���<�F��׺ľlV��+&�/K��3]]
�S�ߤ���Uv����)6[r�5�.)1E9r�!�tT���&fV��#��S)����l�'�8\���^�q�ٴ�KG����>}����_8����ۭ�*��˦L�=�xZu��o)�����U�./��>�����mJ��k�����+�G�I�N�碵�P��ZK(X3�ZVĘ��{��4����ۅ���(��+� �_1��Ԥ�]���E�oe��M�$���ϳR6�6%�N1V\�;� ��� ن�b�����:�D0m�i��=vq���?�I�Lb[���@P���@B�8l�C"%H:�zz������pd&����C��mz�gG*����垽'ck �P�et'[��;�ʤ#ͳz��ٴi�I��$��qߩ&I���.[7�{�t�yFp���E+-���u�y��g#�{!�f�Ă��nSas������V]k� 9q�A1�M�����%E ���;9)|��b�&-a�����+gf�>Λi�*�د����\7;$��o��NM�?�N��b�n
G�M�H9Վ^k����pH���{c�{��.�m��Țv=���س�]����9X�����@����	`�����rl��9��1]��`ڤ��v#��7���*��.��­�{��q4m�y���{�[��O"۴�9�� �P���EaS�
*aO����d��!�it� j�����֡f	��,�6&�9�T�[Z]�k�D�#�Es�ן__<F+���׿����������x*8;�7�{���{��1�m���8ꬮ��q�W�a(��HciLW*,�w4q�(:$��)[V}�O{KI���q�P�q͵A�iá�/e�]����ځ��F:�8R��-q�w1�ͧ#�#�
�@%��CTռ�G�I:#>��g:�� ��@9WZ���`�!���E�������,ƻ6w��Ec���6V�D�}(p �_M�V�DA��N�ʹi>��vic�)+]�pO�#O� G5��h��2��kF��W;��U��SY���&|5�ƀ3v}�W�s�Đ��U:��_�U�ڈR�k�j��`�w�
.��P񽋦��C��]{�B�����#��o����&��R��UU�eS�^ߝ	wF8{��#~ HU[�Fm8cz�(u�봑j�<���&t�J��i	]�1�
���$~    U�[ja�u�x%5�XtCI��ʁ'4Uyթ�(g����YĺJ�5�2\�ӔH�U�ٴ9��8�X:Bad�0���jڈOZx1~�����45�H��H�y���|�+l����k�L��z�Z];Iq՚����n�W�� (�yԋ8��.�ctT��Ug��/�̑���k�ô��)�Hq4�q��;.��s�\�R<D9���> YM����p�Ü}�0��T�m$��m�`��M���`*,�H��F�pҚٸ�s����37�hh�� �͂-/�,Ȅo��6G��P�m��f��I�L�V��l�<F�aO�va��G�$Z
���L�m[m�a�~Dun�6�"5�7q�L��2!~m��5�XL�M�B�N��j�o�Z����<4kÃU]�K5H����"�X�i��X]y�|^y2mZ�s�E݌㝢�gi.�#�f�wy^�`�i�����$��w@�C�cH#&;$l�ȬtQ�~׳��п��C�� ��6��CP&"p��mkjw����xH�Gn���FM.��}�=w0��x���\�����I�*���vo��@�ɤ}���m�-�j�lp���L��X!�ƱJ6-��9$Q��{���'����E�Lj4K`�� {$0�V�M����j��x�K���q�X�'hM'��~���@J^�y���z$<N�M����ic����J#�V���cµZ�5��M8m�f�]a�-X���v���p]��}�ɿy3���VՊ�65���H�`4� ����۸��t�09@��[\��B���↑`u&��RL����x_����Ϋ6��������H�s5��n6��}�D�8�MN>��Q_OO�{f+|��p�|_�(��n����,�c{ֳ�����M�6�%�m ��h�K� ����ޢ��t�6v�ذ'����9�ݹ�"�z�`�˰S8"Zjm��ﴱ[__�u�&Ӧ�:�0>�^k��6}�0e[^����@d�Դlh��O��Ṿq}�*�V׮b�g1�\ȖTI�$�<���̰&�E�e�8��!b?�!"p��6=>��$�i����.��X,��(�Z�r٦uu8�""G��ɲ�^�7��d�m	�H��c�o٦�دc�E������l��hjY(k�9m��[ܖXi� @�i�/ne"_˦�vK�ujO/�X�/K �jUV�o^i4mZ�/簛n�NJ�4�����p/��c%VH&\P>��1��ӷ���8c~|���o��}���K"9T��n��� �iS$�^�x�k��a�>8,�b�ý#��5�z_���K̀�b����H����x�x�p�M5��8���L�g�)�ŋ�$�W�L��$K8�T��g���SUYxو�����H@���9|�����a��������n&�J��2���*X�lb�;�a�����i(b�Ey�t��E����_���>�>�+�Y�t(%��\
�2�`US,�T�MV�ʶv��_`ې���\4���x�!/]�>���{VFuH��f��},
ʬ�K��w����%�Z`8ӵz�QH,�V���ی��f�����/&����g!�� Y��KS�2���(��*�GL2>n�I�	�F�q�{����es$��X��#�9�?�t���␞��� $M��9�Q��ˍ�򄮳�f7m�:{2��Ƒh�������.�wj?8�J�ڬ���y�Y-GW�����������0+0.Uj��yw��lc��������Ʒ:|m�1s��v1�O6��~mK}�f�{u�=�V;q�\��`��δ��ǯ���@4-_���T�;���9�f=�p�Q�AW�O�γ��(Kwӊ,�w��W����QW̎{}i>m�b6�Y�R�窵��m�Ld2�3m.�}�����X�!�V?�𞩋
R�@��ζޞ9�8�Xf�\�ٽ�tYY`�E��@�7J-�_mr�������������#Aj��Q�$̼����A�Q\�����cU	~�����~�(�o���=��q!�S%
�F5a�j�854�F�د!O<}.4�69F�PH�V_mK�e#�1��X]�"�#��G���LH�m�i��U5_�@�|E!c<���ԑ���y*g��"����Φ��X��hPY?�Q_�O�ݾ¦���٠
��������+�����8O�߾��[Tc�I
7VQkon!�b�.�:�����8�A�@R�O٦�g;,�o�.��I`$�����6����1rc�s�ô����3�	��L*���|w�'�sIFG��C)֧�N_��Q��'��QF"GEz,�~z�E�O"�N �v���p�sE�]LS�92��K�k7����n�*��`DMP2O���c���Qv��F�5����;u���YmU�XR<��w��V��Z=��PZ�D�;��[���D�)��J~㲑J<�`��^���&W�tXD����C�
X7Y1�e���g��.�_IubS��Xl�j�/�89��Zd��窫i�k�:,����{��l;�|�	�G+��/�m<�y%p�<�&&x.Z?�lӳ���}�E9s�]�H��4|+�L��Q�F�ϮU���M��"��U��Z�r,ZiS�����4nz$r�S�Eѹ�������Gbov�ed�nڴ �p�x�F�@� .CٱsuO�\:.���Nt�WT'^+��MNQR%��<�K����(������=��v��^k	�ZG��T���=mr�4��g�]�S�J{,o�Y08�|k���o�i��mH�O��L��q��:²��{�(�������]�3[4������d��79p;�B��g�q��6�˔V^�oR�u��f��tU�P�
C���4O��m�L�4�0�?L�\��Q�!4(郴�{s��k���-n���ק�����׼K�<p�@��	��i�/�#	f(�кR���(���Mv��NR+M�sm�ɴ�R���g�j.�ӫ�"������I��峈Yo�=�@����!�
V��uF���&)��V�;#9��
R��z,���;���A�ܲ�^���"|�i�oH&������Z�k�� W�����6E;m��H�HF�� �Ŵ�";8�����%�D��D{�ucʍ�ʥ�8{�.���#*+���E�JqM<���)@�߶D���!Ql�޲�攙�#N#�og@�x;�!3zO�����&<�WgR/��!�A��j�v^z�J]�Ҧj�,kyh�=]����xm�L�Z�^�6a�\>�/�G�V�������J�BT��|Ԭ,�/J�kz�Qy�ѴɁ���Z.���/�:o����0J�i���b���w�6H8ś�T�L�fxW���W(��Z]QvX�.�tƭ���Q�A�i}p��M��;�������������/�M������7XnCJ�"�}��3�,G=��i��c�$���2�~A�� __)=꭮10�v������ǡ�vd�c�4�2k=Y���Vio�s<��b�,���>2�o�J�p�ucg8�(��\|����#�'�F5K�h�,%gQ��{,?!�O�F\<�^��X�]����������[]Ͼt��0h���`��Cչ�}��lo%! oa$�/��*�ô1����#�r�V�S?�%F}W1���ʹm��Y��X��G3^�	�6��d�EĊA�e;�g�hn�'J�3\�τE�x�@���Y�q��)�'zIS%f��)�.��x�D����rN � �7��#,�i�ciQ��g��Vׯ�E0걼�G��}��$��j�i�?�+Lh�ə5�jMu���9
���Ĉ���+��p�w�	ۦ��U��i�ö����k���oSvJ��z���x�ZP��lyGp���pd��C����i6:,j ���8�B<Kמe��;���s���Q�}�\ꀃL�c�ݹ�A
��Y���{􄏑�����K�V9�v�L�������C��0=��YԚt��s�N�5�۠������i���1������%�+�3�P,{��`xU�DN�q�/�q�NMQ�i�/ 4  �u�����]*+Nw� De]�l�R����q��@٦��-�����ת�y.�$٧�����[lP�]�l��:h;(��M�~�3�y����I�"8W�d0Σ{�q��[$2�%=�9=��z�}(mC�__������?���'�����c�*"x�T�օ|wP���m�9.=&�#�I{l�.fl^�d��ʿ�8�'��@�\gQsA��\P�HE7����(m��:�P ��'N��B��g3~�d��=˚8�Za�@�
��S���[�[@��%�Z{�O�/��،M�l,�r����A��x*��XpR��l�b���|���=�K:�"�X0]Ƃ�L���x[�rd���nP�*�ؗ!���qaEw!�|r���
�TԖ���m�m�Ɨ��y��p�3e�+/�ql������lv�Z��D5���_�N�ٹ��)�C��EX��(���|���������c
�5��2̨	)�*���|�X��J�X,Mf}{���R_��_6��]t-'���B�5Q�=���i3~�3J~��l���,C�C���C8����cyO���E�=��χi#:R��բ�����C*�Y����✻.��˾9a���]L��N��bV�����M?�˄?;��ҴW��f���8�W�A�X}7mB`Ib9]�7���'$p39Yw%�����֩����� \�>��C�۲���c9���u£��I(b-�k�.	ik+�u��ic�|}��-�T��٦��1����'bhw2m��pǅ�3�w���8�x��˦'Sw��YD)C��!�e#ul?B��|��<Á]��m�/u^wM��{3<u��x�4�j6m��gQ��D�0�T�~�P)�]6W��3�3��1¼������9^²��e1�^}�O�ţ�#�2������c/Go��Ԑz�����A���s?����Q�I��u��N���$�fa��q5{�<�L���M;�M�[m����鞽�P�ق�>{�� �+*��
�m]Q�m�t�i���hB��^��X�B������mZz.`҈"f��_�(�eSsc�ƚ[|�;c%rٺ�s<��"�6����M�mP2ɢ��ǿ���˦�;8b(��xB	�L��n�S�Fq�zOGc�ϔD�?S2�����}���MU����:�����Lڳ@l�v����y4An��wx���/겞"��3=E~9��r�zN�rlyR�
�z��ɦ���K'Nܢ[p�K$[�w\�ǡ�����>.cU&s�^/�44�� ���D�xL�Xi�\6�bS�D/�*ϣ�4rȸ�bHs����$�����zI�pߒ�	��N�K�k�ɶ�,�����_(_�Yq=��k��C��G|د�Z�FAd���8d��i2U������\����}��O���V���V�Z\K�P���M�W�bm�:'c�f�r��U`�������y�3����U\����"�4:,b�ey�w®\��6�xVb��M8l�,���!�3��@[�2��q�FF���W�lu9��X<���f=V��k�i�|��~���@r�69��X�A��+7�v��b�5��H��6e!ڣƯ4G�O�Ɔd�[�u�.'G{,���̦��u��6,��%JB���F�޼��ⴌE�$}z��q�m��(�uw����Q���FJ��,u����B���j����j;,�'�&��;	`)Ch.	i�ֽ������� �E"�S$�ñ_�7q�cYc#%�u�3����lZ�5~c����J��j������eQ�Ӌ`�unr���lD��d�o���e4m��Cd�E[I0m�����ޅQ��Jf�'��1�	��e)!����_\6�7xգ���m
���tX��Me+I`XE��.O�&��pp��ouݓ'�NoP�����;,�k�&��[I`D2��§a5m}ų�G`z��b�W��y����[)`��e��+������i���i��e��od �Q!Ŋ��5@�n���$`���H���Mt=�մ��'�Cgdz''\/�+=�])+��j�\�dl�1Ы�p֏�l�D�R[��Nk ���d��F8
��P|�9q]{�������y�q��]��<��9�2L8�Hط���y>*��wR�2Մ)]?Ϧ�3Z��!wX�hӦ�yq�~J�����@�{|}��mb�+��ʼ�>����X�R����O��߈GV�y�`���:S��`%<��m��b���m���.߻���d�آMC�6��sW�шcc�C(WZM�.AX6���5��1�\�w�2��BHZ)���8t�8�<�`��Hf)z������.S��<��'>�F�,����I�1lU�߿�ew\���y~�2�m��djwZ�-.��3ܾ�60�ck����üMxw����nb)�����Kp�n�{:,��q�D�`,d�h�F��)�.��3�L����ԁ�lӛ+9KdH��'F����ۏR�}.W{��f|�/I��* ��L���a���^oW�����S}0���j �۬�/?>u��a~ܵz?������j�k�s�M�p�\�q�50���ej�'W��S���6��M�Ԍݟ�w���.A�Y�D}�w$��',�#����~�d�u���΢�]�w!,;��l^�)cM�mL�6�pL�V׵�˱�*V㗙��}:m¡���� G�X��?b�$�}0S�\��l~����.���|(�͈��->�)�������8��,^��w�e�����E��ꚲB���c{�i{Ś?��9�|���_�����_~���܁Y=��G��:Y���������X��      �      x�̽˒7��;�y��3����YRʒXE�2^v������kE�~G8i��]�e�&.~���ӗ��U��U���?)�:���:����E����������*<��yϫ���>����ӏ������ǯ��������_���篿���ǧ/�>l����ck�;:-:�����	��6TC�����~~����>���˷�^�>�~|�����V3��N��U\V�5�W����'�>~ЎVS�UԷ����U�[����/��������^�<���ϟ_����˷ח?�~ل?�n���/߾�~���2X���ÚV���!d��8�?���
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
���������G�7�)� E��F�-2I�/o����b�N��s����Ci���]҈@u���e�%=̴A�d	�%���h�Ĺ��H�?ԋ��䷛3�Ee���jFU0M�,3Z+�9�%��A��|�����ƨ�k����2�f'%4K�J��k�l���8v6I�M����"h��� s��lT��K�8��Ȥ�����x�k�P��Z��Eַx�M�-����MW7���X����C8��5R(�#P:�Y��H�����ʟ��E-ZY�Э��D�8��z�8�Ѥ�vL~oOb�N��F(��	 B��\\l��ab���{d�0�$gn*)�����:3P�+���;�4W���W�A5;�bL��Mbr=�[�&7�������;l��P� �����n$tP?�Q{'�w���_��Jl��������F{�Cf�����c)d[]Hw���a=��F(+Dma�d���1�ճiʿ�Z�U��M5� �M�R@	Z�d-#����}Ǩgt����7���%E��|y�{`�v��R��=ƫ;|Fi��R�.�G�Ye��t�6����.۵h"�.<�Sc������?������o���n���1�7��Oa��0��K�(��i��L.�Sk�0��aJC�q�IN�/gcAPecm��e���3/XJM����f|C���I���%��5�oz�Es4��E(k��~~����o��_~�V�>��F��C�l�y�5@���vU��-��59����ZK�L����"���p��t4(Z��Ύ.�p�qRj ׉���ñ��Q6щ���m��!'|�ŤU%�����Đk(�{�y�R!ﭮ<B>�����d�m�^�"ֽ6�vL�.^Q5�)�/@�j�<�m5�ʪ]��!u�]�- J�G���_��!��m/��	��ۋ�d{�%̲�BJ�$z�&����$��c�|�*��`�w[��~���S�{��Ye�zJΈ���V	%Evd����Lb~)8�M��]�[ʽ�/��)~�pRP&�9�wn�_���:��}^��J��?䬖P�=��ҿ�����D^Yk.%2�뚣�����7R��h`t���V�Rxq���fg�h�'��Sy�� ��3XOӣ?)yǹ%hk�#;otK쾜�d�@r������Dv�����������;��z#FfɤY#��g�L��p��oU>׻lf�y�D-���xR�؞��'��M��=�˛~�IN��o���y��{��'��RL�8��~z佑��h���<Eys�T6ڻ�7������#y��-��IY�}4��	^E+���s�����[k��.�}���DB�x=�R����߲�XC`�opӊ;N�!1FA�|ǩ�o�p���!|0��g�vzi����Ѥy�=0y�t���q��k:BY�f+����g�i칆s'	M�.	���I�NccM�I`+�u��̸Ŭ�]Y6 Y  �qKl��Avbd�75�h��2Y�3��$��/хN����1Fy�q�w^x����U-�����?Tmڮ]���.;>��l�3�J�URO9:������i��
�v�[�έ�����!U�~m�I�&�WZ|TIý��{�`j(ߖ������y��j֞+*�U��.�wO��˷�_�=���ב��ܒ���K;�$�A��}�`d�˹Ĭ���`��e$f�Uo��#D7v/e+�&>�a�fɷQ>KCĴ�۠��l, ���ܖ@+CmlXwo;$�8_��<����k�S8�"�N��$ؓ��dW2@M}x�,����y�x{*xi�4sa�?���M����%?�TK#��N?b�P���\�Wu���t�yc`<��>�#AM�G1�)��@���V�5��v(�]����eю�ƨX����Bp�r�a�%��jl5[����/SjB�iv�ܾ��{�[��XS�P3�5�����>�ŭxGжnSo$��3F���	gO�Y-����7�R�s�-�B$p)�Y@PS�>=�ì�^�>��W|���G|���EE�qhO7?�9j�e[�\�Y�3����k5�͏��M��_)|      �      x�ܽ�\9r&���|���_T1IF�L�2�Uƞ��R�4W}�Uw����/����q2��.MI��p�De�/~�_�U/η�������P�O��*�"���?I�B��BJ|�B\��߾�����z������B����R�WJ��di�I����}%�+#^x`����o^�����y�����ן�6u��2z������c��F����4������}!T/*�K)2� ���
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
����Zv�ȍ����4�o2;9�3w$[ٞ�F6Y�d �V�!6y��f��0��}�\�XV�*`>^�U.��F�@�}�����vG�*�沜�a̺k�/���|�y���',�x.|��	<���T�~��P&V���PX\�%��N��T4CmT���S�u��5;���疬�!��z��x�.��Kt��l�C�j�u�T���E��6���ʛ�<z,E\���8�B��\*���#!���;��fu�{d�(��; "��ƾͦ�&$Ծ�K����}!��k�L|Kɴ7�W�*.@�<�,	�U�	^hW���,ϫ�M|2�1����ш�������d(DfG�L%��*�)yג���;.ʻ�������R�%$�9a�S|C�}�z�˂-dfЖ#�$~��84y�����6%۶)9p.I����H̀$0�<󒞋�»��K
�3Ҩ���Q`�a�m������w��{	Ms�~2n~�����{�Z�߰��a'vGU��Gڶ=�����M���	+�z�Tq�Z.�U�?��'%U�jɩ��n�%�`]�2�ק�V6�d
W����@�C��#��^\�0��3Z�]I�� ��m�ģ'���B����,�L>n�$.[����[Jt������cڶӬ,���I���0i���q���4�"yf���<�޷m�>#YV�3K���T�#,�3���O7�-NX߷(���+��۝a�-NG������g�$��P���ț����k��:�^��MM�{����])7F��:����`W��%�b�%����������/�U]��^U^|�!�|�rO��R�D��D���D�F/և<��#�j���eJ(\ʙٍ�Q�/��=�f��?
�蹇��=�F/��.�)I���_�eq��<9`�wT�aw�m��û���8P�
�<���ew���~�n�a?7(�鴟�	�@f׈3�_��HՉ�Xo���Ȼ�3�\ȭ�Lܕ�M�G-I�ǻ��׻*���$�^#k���5���%��߅܍ݵ�6�"�dI�hآ��S�����B2\�,R*yR.�̻j�:����{��߱�㚊�%&�2	����q^���X�"(;y\�{Ҡ�kUN8䗦���.E��e>��:��^��6��~�(f����2q"s�`Q���2��+Pd�d
9���nw������NtY�8c�<��.`T؂�*�)��/��/�Z��bQS,Cin#�X>��.:l&yvZ`����2#3�>a~�|_>و3���r��f�;����;�}�E��b
?4M�E����E\�?.?�t�(R���`��u�U��2�~�!ղ�.����#� R��t�KN��������T`���9mt�E�-��j�8h�����>\�0\ѥ(b]��CƸ�3����I�����f�S��t�Dֻu'_�g[�\�$�H�N�ϕ�JF+I�Ӕ8�N���²�5�9ǚ�P�5)�)O��"�$�v�!���H�g��7��� )��¡��\0�N�$�.R V  �`��P�.�^E���[��KZIc��f�;+��e]�n���0��.�X`-h:�t?ݰ��bl�B�����"�U6�F�gQ����s)�,.��7�E*�I!�{�rb쏫2*��j�*��U����a	��(����c��	Ej~Q�����<���.2V7@f��K $����ʻl�E�'[oa�H�Gz_�ys6�&�),��U�%�z��-!׽sW������N�/��H����+M��E\.�π09�&j^xv���ZσU.�钐BgW�,��7�%,�(6\>	Tw���~�e�H&�#��p�X���4�g�u�y���xH��dg�y�Dɂ���,�@Y0Sz�������C��K�57}�5�NZ�G_��ޠ�{�ES`�p���|%uσYO�(IS4Q�yH��G��\GLvXb`��E��姹�'7n1�%� GM:uLN���5��y-4m�Se�� �,I���jXJ�z!6*>��*�G�j��%p+�i$L܊}K#.�y���&%D ���Û���Vºw_�L�ē���:���%ϐ���s!.�&t�xk��B��/�����\*$GI��Ĕ���1����t+;	��q=�I��)!v�E��Z�&g`��<�\T}�q
������H�2`cb�=���&��ۻϓ�Ȅ%:`ޓ�NX�fL�e�,�X��b�g`�o�9BC�DJ�a'�3�C���/��\�&�U)���>I�%$T���5���θʺ�/��T�Mm�#Y������Ĭ�a44*Wi�� Ӓ搖$r�U,
[���>�qɆ����r�x���)��}w��ݪ�ە��>9�yPתֈ�����',i���n��.���ﰸwJ�e���H�,'���s�%��+<zP��qqT}y���9�{�tY�a'���s�O^h��3>G����Ҫ@�o_R~� �=9Ab�c�\3�Y���K-�����������?���{�i﬊F2��������Ě;Y����4�g0�U\��<�0�9m��XM�ya�����X.4g�D�]?�uyiiQ���
2/a���������t��I4��W�yz������ƀE�F���<q�c΢|zm��h�3#h<��FC�2W]�7�LL�}��v>�X�a��I�B/�G�_����=̓	���T�d�1��cV��8�{�4kJ�I�||��������T�N�,��:��K���{^�\�+�э��g��J�~�[��Ƹ�#����<�h�K.)��q^���M�I�Z�\��8k>4�6t��W�q�g.͡ ���ˢ��]�|�+��ԏC���8��5�N��8�D������K|��Ѕ������^h��X�D��A�t/u��n�f�,e��"p]৷���L������WTU8zߤ��I�ݲflk����y�N��ފ��8�=��fd(��^jJ�ф8�F��n_��	ͼv'�����y�s������Ȑ%0�8�k�h�d��1k��ii�Q�y�[~kǃ�0��+E{	�J
��'�8�n):�Qk��M�	9��η��k�1�����!gk��#�[�����i%RzN�V�Ò����]�QF_Y3�a�m��i�LX&��@�6�4��Oϥb��RW��<�
�M$P�h�7m�&#�LB�̻n��]���f�G�^�8s �$.h����Q���1���2�>i��y���6[CL8��h���F2՘܄Q�x�^�7+L5��x	�XnӹZoR��ۼ�<|5�.V�C�,k$��X:�gD��%�3��P�zBBs\v:���V�euU��2��,�<W+<�;�P/�X�1����1p�q��Z���Ƹ][)W�~}UZ���B#��W�D$6e���`�G�L����
���s1
���\��}>CCK��v�p���Z���B��KIt��P�&{V Fm�S0��ݕZ���]�&T�����#�v-�pj��QQf�7[�i�Nzgc�A��ʯ��B���V�gH8�ۅ�#��k��.����|��u���<����,l,vMcqB��$�qQJ�i�JD	�eQ>��¤e�x�A��)R�\�Bo �rc�淕�T�Q)��}��G���"���4_ӅOf~��"��|BCF��$I\rc��0)!1��Ťf:ڠ����I�IK��:���K ���sWR�bWe��ù,^��6��<�`�L�%q91��L��P\�����D�[|�I����!;�U���Q�L���7M������P\�A#(�h�A��/i�6t&�K/�'پHH�VE��d�Uj��E�l)q_HC]�1.���D�����Tſp��j�{�����`�����c,R����|1آ����ы��I=�tc~.�+�K�}���
M;ش����Ph��-�_��@(2B�J~�1��EpU��I�^t��"�1}�)a�D�1M�R�5,�>���x�$߈�v/.����EkiNf˥�4�g8Ċ�.��@47��X`g��721�t�
ld�͎��|ؕ���#:����,Ai��kȹq�\:���s�&�V��a��0/�<�^w�ꀩ��2�k)�&_q\Ţ�f�#R� [���|"9^ ׬f�$���ݭ��~��u�����#�L�e�R�{-u���k��@I�gC{7U��F{H�=���KU�}i���TU��}�U9EB=����X���E��E1k�a��=�TX��D�dWW����W,qU�\�<8�����7k�(�L��k�1�,�g=E�؝fQ���'�4I{S�Du��Z�X�9w�|&�B_���Q�ʨ��wO�)8Dc�E�Q�#[(��@�����K�ӛˣ2¸@I\s��|���ܺ#l>������4k�dX&����2ހqM[��3O�F.�3@�K�!����7���%P��4�>�н�Wݽ�Y+k��R|�o.�|e�y�6�W<n.@�*����o[���������13��yYnq�^"xP�٣kKH�PF��4�z����Y�%M�:T�����`T�l��R��":��`F�;�o�X�[�l1�Q; #[G�ijg"�s)_�yI6�C��;�y�EXa՞�>ʹXl3o��!Z��мA�'�K���ÈR|bq����HNMGúqł#�DY�䑒�0��uw����Fjڂ���O�W��������nh6#s�������n��$����ta?b��=�P$W
#�{�W��؃����KQ�������xDR��;c����kt��}`�;ݼ�c"E���ҝc�B�}WY݊���[��!&��F�RF�J{�T�岪�Vz�T��ۮ���`N��Diog]a��7�_���tvE!�ȅa�q�m�-@[$��Ƹ�&���=��1��Qq���$=�]�^+.X>�=�AQa���"*>,��H������J����3w�xCY�S=\t�5�����%}PpNSndwE@����p���2����%�� ���.^b�c��@S_�3��N���T'O��~y7�8�P��||�A�GMT�g���@Y�4+1K�S�V��#�$��ɱƢ�Qܯ+c\���������2.�y�ڧ/��JN���P������7д�>I���O�>:/��߷����6�V      Y      x�̽ےIr%���
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
Z=o��!��!{�Y|��S�!w����'�?H�E!^��z��}͏���!C&��b�AхZ<P{	�n��>C�h�=�~6��S��>�΢i\����m���|V}�~�g6���v����h^"L1���ٓѕ�������9pll ��ĉ6+�TRy�E���2֬�O���p�C�Bةgg8�G�Ģ���A܋��Z��[���X?t9�yI�i�:0�ɖ�TL+�o�E�WA֚ճ�+^I�G��œ�U���}�+JO� ��;On�p��f�^4�@
���/��b�a�O.O5��##vB��oF��v��̅*6Ne�ܠT
E�\\�SQ�4�^��ݵ�Bu�:?�S��8^1�/P�x�-����GQ�V��d,���e�$���Xn&#����u1y����g��Bs`u?CY�X�/iVC/��Hb�XC��t,Z�Z��ׯ�V�9�}�0s������q��ZT��jv93� ��4���O7�Ϋ a��+ڠc�Q��r�٩��CC��xN��0�}o����=�d�nh�6��fk���_'��#N��H-�q e��-��M%���p' C⌵��/�g��	��t��c����1����֟O"��LWk;ѐ O��2ʼ3��3d�d�o�	2��޵�	�dp+Y�
f���
YTb��᫄�]�� O�h���5�����E�©@ڌ���H�'���[�Y.�M����v��>�#�JAj���J�Lڶq��(r1i0����}�L�n0>�>
��6��̴��6�g�\���)	�5�"�nH53�G��h+�x	;�v�r �nm�0���Ҭ���i+&=}���{՘�lDN�T��
?�L#M{����S^��$@[[��	z��Y z������ڛ���e(��	a�Ԁ6�8h�n��ݏ���������:o��?eF��a���aL=w����\U�Ec]{�=�?��Bi�|�-c7����Ϲ!}���G%��<�+�������I�����J,�y;��D��}(�N��򙎚w �
c�VS�_��4�����A��������	�-�e�A[���ϠÀz�j��tI��@�]�:<]J-j����,#>�C����n��}����aT��l��O�_ٲ��,H��G׉����OTN��&�@�D�%���fMb$o��t7���0����!_�sLWȓ�xn�w7`��'ɦ��6.�qvAT�#�]]ZN�Ǧ���H�������Wn�o9��BDot��$	Y��<����y�P�L���<5I�+̼�>�Z�s�۬́��~�:B�km�uD2�*ĄDw:��q�?��o�Eo�|w�
%�������_��B����;��V�;t�j(UHY�@�V{큦S⟥܁��������f�%�H�"��\s���(� :$:�A�Z�K�V�r���,m3�ww���	�e���$��\�n�wfP�oo��`��i�X�Q�7�K�nJ'��
�h<��ۇ�N�C�#��,��������t�����&��Y�i6rW��ۃ
����b3Z�8x�}�Vy�9Y%b���TT!�
��"N��"����)�1�%��E���H%ǽ���Q���q0J=jfD�fFJa��AK$!{�6"� n�V�ՠb�����79�n��������8b��
-����uS�-n4�Rp3��u���%�t�W�bB"���_�<��6�*��+����xF�� ��R���u�.�`[mFO�S�m9#q�j�4�_�}3�8��>F�x�ߵ#�,�1Ti]B�j@�Х�ޥ�����8!�n	�T�.%����F����P
�Q�������mg� �K��"��ۃ.����.��m�z;�����*�CIK��j.�V-C�0�t߀NN�����S$�|%�3�ip�5��=�a+D�Bg�:,W�@GDp'�U��p�t߈%���;IOrL5�?��$"3�cK�x���tO��B�/t�C=9Fآ>Rj��:�����>!��aG��u�6G�mo����Z���!���K9fh�[B�$�u�pv�3a��1gV=�:Mq���و���7t�'S���#XC!!�eދ���������-�XB=I9ۘ;is�h���ki���C�D���|WS��~��ȳw$Fuh�l��4��*�P��˗�n�� �v�'�Fb8x�R�������W�2����h�ZZf�H�ڗ7VdO�/��ٺp�^" ^�N��&Y��I�ґЍ�jޤ��6��wx��ɿ-n�����+�"�?�K8�O�/'1��6����~%]=�c�L�Ж�˲ֵ��?�VFu����Ǚ��Gې�����͉ѼY�k�
Q��1�NG�����M1��1�R N#7{���M(D�C�u:��z�h�m,TB��5�����7�Ss�zt�7r�cm��Ո�Z�.�9ڋH�H5`�o���$R�שI�������.?��?/�p��s�k�����|�w�F�\CB'Z�����t����*i7� v��`�oF�x���|�
yё��	̇�e�Т�j���M�-K��w���\����쉄�021��u��T��t�,\=�����dU���e���n����2ymW�O��X��`��m�A4���ڜ���~# 3�|}u�2��V��VFN�|��O�zsTd_�cL
D�ɮ���������>�N?����G���wVs �Z@�Y@k��"k�΃fd_�ɾH7��|�Y8#��C�L��pP}�Ӯ|.KBN�� �6t�i��}��tR
���Q����ڰ|�Y�����t�BW�(��������ص��� M�ʂ��������V�<����uKֆ�c���3���f��w�7
"��C ����bNOu��sdkRC5��w���Ԉ��|[�n^=�3G�T,ҝ[�A�3G��ǳ�24ή7Ω��r�N9`Jf�qT�Bj�H)�k�G�`��G|������^��/�1�C^�t~�C����Rt���n���C\�K~E����DGGwK:��]�Y7z�=ڃ��,Nff���i�� <��=֔��b�����A��ha��;#2�����^�����XMށAlt�m�FJ~���HR��,�1�>�r#ל�+g����Iƌ�pq��P�8��.!b���K��6�B�y����n䣄��?�p%���k��T�p��v�T{rķ3��b �s��	�̽�!�n��nevPl�.h��h{�*�%�#�_O��.y�;1Q�w������z8��׎V�s�H3���%����ny���N��B��B���puA�u��1i���� r�k�kD�G:�)�/u1N�j`�`��8p�!��2�r���Fѷ�>�k��`)��x��ϛ��4���*�yӅ��=b��>$M�Gx�|�Q��ǵNzk\��, N �I�c3m`p������A�:��u����볜X,��v*V>>��E�-lm�h?.f��J�L_�����tb��̠��}b!~�q���s!Q'Jg�1/4�1#R#���i���~���n�6³��i^SC��P?B��6�u�L)x��ȸ    �ٕ˯����y	��Έ3�An�S׈?{%
�1w,��5)�`���+���'A�w��w==��k�H��(g�_��m�>򗇯|bS#
"����x0A/�E��� 4@�}apKo�'I���O�`��5��Ɔ�I��u;������5b8�{$���j�nx }N�7cA�痴Sޏ2iD/F�_:���l0�%���1�f��i��_��r K#r#��ҡ����Gt���$Y�T��O����г�޳,��ks��2h�h_c�f5�{������%%lυ�&̶n�<�94␢�/b��t��U#�]��8V.��j<�(�
|�����n-HW.�u�TڝId�S�^I�d_�෗;�"�:��
�*Kצ�P�1�B��6T����]/d�w��;}��X���C��[��o��F<6t.�S��JGU<Ӕ�C��n~R���x�h7�8�[ė�K�SŇM6�.cw)qzj"⠫�K�)����ħ$4"��/,=�6�+���F�:�q^�xU�A'�B�����xW�Nh��u'��o���uz��W�G�o�<J�58�n�b��I�":U�	�ڂnM�V��o͝J�"j�	s�Q�C�64k��8B��K��<���=���=̴�L7g���}e��+'�q��7�W[���Uo��ϑ�*w��,�@��0_������A�I��y
	'���f!b�|E�:��V�ȩ�����jC�$b�k�"F�)ҏ��~��b�g���Sq8#_mɺc9�T�X*����7ہ�N����҉:ٗYQ�'����.R����̔E�1\�U�7�`5|P�Ɉ������a�F*���T��������?r#���+�~g����g[ᳳ�Z�)c���B+ls��v& I�Z:#�G[�xn��â�f�o��W�<��1���ٌ�`C<lWm�y޺����^��흠�ѐlI5dK���](��s1����!'aV|��-c'U�����8b���qb��/�nxX���^�=�f����O��D�������_#�U�v�Pl�9Cd�Q�Q5�?�a�W�ܵ2�=Md꫔y
=v�E���Z�'����X0�R��ve��-R�m����^�ߐ�G-}�4ImںC���a�BN����F���(Շk�g��!�4ҏ�ѵ���=8��f4�x(d=<��!^�5��wc����۴]���u���i�0Jr� 
�\!C��:�1�y�h��o �K�	j�0h�_��$�*4$SK�%��Ǧ��ï[ �X��4m�qS�2d�P���.��)S�f��6b�8K�]Ɨȉ�͊�hif0�_���������<��I��.�#J5��v@�T��������2͆)��R�n��!@<xr�r��7�SUOߋӘ��+��5"8�r?G�.��iFm��n/�>�k"�B)����N����؅QhjJ�7�݄XM̶�>BIK�!����Ε�6a�4w�V�h��؂�������fY�/%�Ȳ��+o��� d[������/��w��PȦr�0���A:LYh�U�t��������_�� �m諺*�y`w4!�-Zm�f������~�ǟ�׎��O�jt֠��ĥ�w������߅fC~(��������m%�Z#�WH�[��?J&�.rt�v�	ږCq���_���=��=ajDOl5m��!�j�7�YL"N���;X�N�p\��a�J�x$:�"]��êB��������?�7��[�Z���=lmⶬ���#�(�?��:��xW]�l��jc\ 3�t;���"�AP�[��<ܽR�!51"oq�ѯF�O�SX<HC�L��u�-;�<�4t�N�SV"�{Y��R�0&5��x�/�#F�`;b�ԦՄ�X.O��?��˟�+�����y�/3��1�]�i������^��BBe�{�/P�R� ���3@A<M�V�!Y�5d�R��B�;����z@Ts��4�ش���7U������:��^�ױ�f�c�Ռ<ϝH�Kc�?��e���)�0�W�y��=�e �w[,w7Ҕ@�hV������5��A�m�G����e�EUgCe�m�+A_��a�W���k�[ۨC=�5����
96Z��bv|�i�혺��"}�qS��u�)�͊$ҌtU�I�K(�T����C�B5I?(3���Mͬ�iS�^�e�oLdy����O����?�����آ��IC}��T(s�4΃ǙǞ�� O�Fҁ+q$]Ce��T�QA�z���a֌�0�.��_����,�%��I��@L;d�$�tZ���=��Ҧ(˜��� �]�=��=��&eSo��>�$�<$�PN	ȓ����2(�j�!h��4p�H��H{u�ʮ�#Y�M��)8t��%C��Xh��KPuC��t�%�g��V����IΥ!��r��hseO&�zCR�����U�z��\4�����=�c^O������&@��h��nN��@Z�0ʌz���&�&�����uu d��eB9�Z�`��@�����{�)_�ޓUMr��9R�0$q,$��n�<��I-�3.��m�`B���u�%^r6Z^Z�r��.��7�J-. c��T��~�#Y��J9��lHy20 ����������(�W�����y��<�e�L��j�I�t�D�NG���{QZ0�ξ���~D�������/!(q��{X{OX:m������HD�|����r�����	�	I�fDL�O�R{�ȧ�<�2��7�q�C�x��S���k��l���� �SdIPK�%q���+є���q�W� ?��?FKu�Dl�������F3������x��	A�7d����T���/����(�&6R��3��W�y)�p�SE�a8�0�d��U���*ecK`ȉ���D�/��?S��;�g o�jx�M��̷mZ�hʶ��x��TCž��e�a�ې�d�_u�ÎZN�^���y�����%v6�6���p�%����&dК2�V�C�������H��,��a���!L�������@@۝:�d��|�5W;�mG['F���t>�Z�,S�nv��)�wkQ�2qn$�s��f�0��-��.��&ah!C��[�����x��wR{�\�ѱ:}�����x��0F�N��q�7y�f�zx4%q��M�f��s=00l�(4��	�>�%����rϩ�ݟnx!�@F�����2�;Y_���#�������2��J�Y������_Q^_'�ء�	��̭����PޙA{>���#&�)F<};���ȢB59/�*i.�
��s�p��j)���6Q��vX�*������U@9���k��O��wR;�A����6�e|���Gj�W��Ãا1�B�Ȱ�kX�2s�ܖ��hs��%���P��o;�1V��f�E#e	��䁮@y.���H�E@������2*�$�*�9�;�$�
�T�n���@r8�2���Q*��vB���َ4������,_^
r�\5�$N��a�����T�-(ȷ/Hsr��;ZJ1x�'�����oQHԨ"�=���K:E�xG|�<1N�צuwQ�=�P<�P�ҵ�	�(�'�"�OS��#��S�]$n}R��^����89�qB't��%�=F9=����E�ʄ�'S6w��#�KjlE�����97o ]�Zy�r��&5W�M)촌R��η�2|{�D;N��@w�2w�����d�5ED�c��~����r��9H|�j�Η4�G�X¬�k�d�6����:T5����)�:uC>+�q��)2��Q@�6����d�R+���|\⺥=9u�v������(�CN�tq���10�F�i�W�����# �4�;G�,t~���w�R�����FH3������H��7W^7���T:܉S�^P������h�m�	��u{���U��u��Y�v72�p�W�ۿ{�	��&�Ƃې����a��f#Z�y���iG�<t�瑠���l���t�����    4�X���B����A=�95������ο���mpǽ���定�	ޖ�L.�T��y��g.v�{t�eDb�l7��v�7)���n�28�u�E�n��b�o�X�J��'nk����S7���!q��#knF1?�!�!n�J-Y�LFؙCH��[�<�ǔ�F��5b&�dlh�aN�S2�pB/L7��Տ��MsO���V3N3��}̘f�����	D��]G��:���*.��h48.���y=�=d��-�a��@'�u�]��5�=4������=G��½�`��-��R��
��)���xr��[� �nt������Q:��5�����^�s���fԆs��^�RX�-s�ԍT��{�\���2P�e�rfh�_��|���<��)::�*�"Մj�}���;E�]�.~�����x�ΔMq xQ-3ajj�5HŤU����+-�.;���y�@�_AC8}+6 ��Ҫ����B+lTl(���j��ݕCYCO��'��SݭB��B�T�О����,��p�]���i�!�fLCBNS�i��AN��u��%]R��Yw��O�y�-�A�D׳��`,� w'�����Cﭸ���FU�5R�Ȭ�ֻ�/�>_d����bҚ卓T���a�f��9,�����!�6�L���c��c.��ک� l�O�9���84i -�֝�ӣ��.Ǣ�@O�v�DH<�]�?��s�	���_�9d�f�,b�`������&݅Mn�#;P�y�zJZ�z_B�z��$W q�6��0;��-�;�(�Z[�����\�������2 k�]�+s$W��	!'?�ڐY���L]�ٌ����d��>!�bmr�|Q��y���Q�q�7�����9*-��ml�Ө�Y�a���q,���V䋁�_1��̦�����/U��\3g>:q�z?=�*Q���f��Ƹ 	�6�A��Bm���=��M)Ɠi�o��R�@�x�IE[�8�O_��ͦl���5��>���m��Ӷ��5�L��L�'$Z=ȶ�D�էғ�M�ZJ�A���z2m�4�p#"d.k�x����OH�M�m�$-dk��:�>�]�4-������v�p;2�P۠�!	����Ü`��h�%�qD������b���������8[e ����S�r�������C��/*R��Gv2�hۅz!n��<�(�M�U1��c�0)�,)������LC���$	�%
{��}��ǳ n0��Pk�\�KS�{M���%��if�rM�ƂbH���W��d6 �S����;��v+�R���D-Rȉ�$��FH2Hi۹���:��8)b�(��P�5%b������(����uF$β1�W�%�v^P�@U�JK�Qs+w�!#�v,IL��J�?�!k�ٔ�z�� ���2	\����b���:�v���zo�lOȿ;���.i˺[�p�s<�j�+��u������Jg�"�ٌ������#���^� �o�~�P
	I���)d����w�6�Zk�/��5��q/���;�#dD�-#)�ui[V��[v�Pxӆ�w���G��8]���W�J��
��Є�o�O�2B*,����]w���=����n��jy�l���Ԡ�=v���e\�N\6ă� +:$�GS�OϷb� ri�r�x��iN��ZH�w�
m?����(=>��#ƾKCi����v�EtrN>M���Y�c�9i���X���n�E��VŌ�Yh��������^�З:�K�w���̑��Rĳf["c������ ��$�%q����L�c��B�z��&[���Ć2+����~K4E�g�c���f0)A�����v}�Jt�PB��X?B���&*!����v��֢q��t�>��M�:>|[ϴ��X��5i~~��r�(n5YH{���iB?9 ������J)&��-�ܝO"c��F��0z��g+��R@kTi�έ~|�^b����	Р"���0�-�mh�p�t<M�o-�XHQ�c�&^�ܔ"���8�q6���5-�'�(-�Ѿ��q@�:!�l�|����M���G$lȼ�[�R�0GaG���C�S�XH[���Z�<�?ˊ��%:�v0��V���7�O�y�&�k9���U�
��_�k�*����8a	)�jN�����*:(~@�0j4��> ������;����������|u:�\��˱Α�S�2 �ۜ�����@^,C>yo��+���S�ЊؽJ)�"��ۻ��C��dw�ֆ��b�������d4�I+S��eX�Ɂ���ˠ�g�]f'���]_b�$!x�8ULJ�`�Jo_	{Ҭ�+$���?�j���:2�V�F�t�zP�b~8�]���$�j,d�ё[����+Si-�qd��JP�߰|>}� d�ёU�<��"X?B�DpB������k���Ȝ��'eZ�(��[ �-�|WH���I��tLe&�l���1GQ���ӅfP���CGf�GWp �#�KӹI,�95$v������N�Oٺ���v��� p�hH:;��pGf�g���p��@v"���bk��b�j�Cdj��"��[�7�=��ׯ�h�V������.��m��X��N�:���V�<H0�W����+�eI��Ł�ń�����vg��/!3��],���i�{%-t�Q�ϧj��� ���iG��������?��	�F�hk���,=<�yӑ�дY�(�;���d��x�@�H溥�t�$�)w���*5��ݾρ��%<�����=��Fz�,8G�C�m�u4�6�ֲ�]�ڽG����ڹ���?5"��Eܸs%`_��7'ɉ,d��k�!�u���(�ΐ��]��NR"����"�ϧ4�ht�n����G�;5����Ah��kg��r�8`��Ð�p;��bS���$}-d2K��gW��F�s��'"P�
)�Sd������Wvă��k�خM�{~z���!C����^Je&�r��6�&$A6@-��?������9��;Y�^94�0��&D�eK�mͶΟ��3��4�c^g+��V#�U6�}�9�G��.?�n^Gj!'�Y:˼���75�4w���V�2�J{.옼��o�i#���gc&����b�R���|3]��ڑZ3u@�Fs����,,m�8�~�A��1)c������;q<�Bb(�tA���F,|(v�99�(1�y�����[ش�Q�,<ٚ<�Ɗ�[ ���5�/�3�t9f�O7KVn��_d����:�fW��� ��DF����f��G -�lS�a�zǆ#����_��(82K����PٲW�t�Aj�;����0*R�Сc!������-9dk�	��?	�D�b�]=?���� �*1���>˗F>I��9Ţ9=(p���,hi�V"�4�3��;�!q\\e��s�2��������'f@���]�n� �ֳ�f eM,���mVN_����Fq}�LYr횩@����4��tl+_��K��|F��t�����>T�%ʘ�j%���1�b��M]���H=�_�̊�t��iD������Lkf��C�~��B� r:A,ޢ��xo^���ݡb���#�����ł(����e��2ܾ3���K��U�2�4׮�����i��KKA�|{yz�ȕ2����Ž[G������yZ�9:*�&j���)j��V,�m1-m	|�yآF棠v�m����얮�卟k1C��1� �+�G�>rF��3�⽖Ɏ��k��a��\�sXR�i�B���fL15�aŮ f��)=8�?�	��#�|-�x�I���B��N"V]�x'-$_3-��{�G+����5�h�,]������ʌ�8!!�i	�m�O�FzIcw足f<@Z�����Ლq���e��>: �h0s|X�Q�6 ��c�y���h!��1�i�$�S�#КN  7��T���0Xj�f~�B�����K�T��b̐P��=9��]Ƙ��m�V�BEW��.��b<��    ��3����}s3�_,�����u���y�,$�1�w�f�O�<�5-s��/�Ux��|�ʭ�1�󂫚lO��6O9&o'!�u�����C�$`�p'�⹟,d9��"D�tO!ġ)5"�022�G<�b���I���v
G�����n��S�͛ ̻7���
U���vor��8�[�[���^���� ���v7� q;���z���?���d��l}������K���u��}�zi$M2va�����W�x�6T��;;_��O�_%~�Bd,�v:�K�d�P "��@�������H-$}2��Nv>��M�~�ۄ�4+/1�����O���|���9zi�i�u?s���|/{D�bƸN-F�w"�Ɍ%b�;D!��-I7���qȖd,s�#�׃�T���-=6���4����O/"�3����,y��wU��-PfK՞p};�o��dl�=��Jy�bFX�ʩ靫!�O�i������M��{Ne6"m���5e���屓J	=�%� k�%�[��s��Qk��-Ogp��BN�:�p���Ce>XF,���ToZ���CA�����i�NE+hDC�A�S�������B���C�=s�Wr��msb7yH�VQ�°/�#�0�� �qL�C�Y���S���mG0�0 tA����<��c\��C�WQ_+��o��Aǈ-� iVs�����h!O�q�NL�/ѕea
R;�-���������؅�0Ʊ���UL��;J_3r��]��{�A,$Z1���ѽ�<Bu��"�X�z�nE��H���%\qT;��kI�`��F�9/���	�-dl2�˲�������.ٕ�a���( ;Hd|� S�t�ΐ������K��ۥ��r�k�����G8_zt%W��@��p�����x�����Mn99�cc<Kc�=
�QM���y�v����;�bc<��nv�Eԃ$+CJ�F�����o����{�p�Õ� Qa�/�8V�����ӧ�ZЃzA�EkoЗ�85�C���wLЃ����u'���#��F�O���=ʭ=i`L��pE�֗hz(l��h:P��kȶ���4�|S_��A��[֓��nۥ^��^B�+���x���1�9�\c�GSDlJb"ߐ�B.�S���"�T7���N89��`b��]�[0��+��A:��ZS��#��%0���!�j=��&�b1*��9Pk�`"� 5�"t��?�L�kE&;Mհ�Q�R������&v!St���d��R�6����c�)q�Y[��4+�|��v�%�8_��W������?�����U�gt�.����7L����ڌ����������[r���Ji����1����d=d�����"��q����(�e�	��
�y_Y�P�Dt�����|/�_�o�K�	�����)܂..��:.v����ɉ\�K�ab��ي�|�4J��˜���E�
�iL`yW:>�ƌf��0���Z�)�@�{��� ����2��1�	�k�xk�	ʼ6��1�2�e\�:������ڑ7J.�Ex�%����������+��kv����MPښ&��~�J�r�OEY�L`�^?�m洘�NFk�ԏ[
�rs�Ȓ��kSMh:��[	LBn��Ph
���Y��Ǽ�b�cJV�&�!���؜�kd�C��c��)iڀo`��l��0���H˴R�����G����m�y(�SD*������?���ϿQC�;��G� p�Z�0�6)�2^[��/�� �F�ʭtĎ%k4t,%����lA"����y�����E`�!����0?�v=-�
���Z�rZ(Ճ&�!4u+3u�g]���Y8����#������/���_8h�R"s)���u����a�x�n��n}Q�$����G.n�feV����mĭ����	Q�!����!��O��\ڰN�vQ�Z��NV7��� ��@����d�_D��R�ʢ�D�97��O.�x��]��N/�s��?������k����t�ؓ�r*H<��F�DҒ�k�u����d����<�\/_��z5P�|ySs��+�x�!���Q�a�.�HL�6j`ہ����M�w���C�8Ri���u�Z�� ��"�c��2Q�$q#�h��3�����[d�e��1����@/��Dj��Z/Ӧ��N[�ܵd�UO�|��0d�K�ʗ�0�A�c_�
9�ǅ:/T��S���ν��V���;�Y`&Dz�g��/t��bCb�hΖ�������6������]y����Qa��v�ɋ��x1y������GM���.<m��J�E>���u��$��*T�:,䩅A����(
p+�bfM9B��ǟ������¢�t>�ZШ����1S����?����_����%_���w�ڷ�,��E�:h���H![�m�2.WW^���:.�yZ�s��\>V�����70�	��lKŔ���"�<��e��	��RȺ/�}~y�?�?�z����_wX���I��s
�i�>����`y���r���L���搔���FL���+�5�:�|�Y�;�B-�A����jj%�a'���T�17i#�	��b[���EOf��*�;�Å�c�i�ߜ>J�3��Ԇ~��%�֖A�2�n$gp2d�5ȕG#�W|2RX�I!���'Hj�p䷕P��I�Xh��2�Ƶ��r�c��V��g�FB6���:oǦ�Lx��mH�c[
0px���EƬ��594l�hz�Qؖ����ZgS�c�)���rO�(���%����Ȣ�����))�����>Z� �p@��c�1z#+#���j&��t����8��f�?�h�0l�?.op��%��4���հ����z������V=�If�/�K�� o�r+�B)�Y��N�F�zN����Fn�3h��uz�H"eu������}[��W�G 8�����$XӅti�w����r���'i`(ձ�	G�Ѭf���à�U��y�R��������*wȡ��<2�l�{�#�Y�����±�6A_������Y��yr����q=a�T��f���ma��tf������_��1s	Њ�+3�WbW��M���Z��pă�^FlyB�l*�7@y�]��̤F���*錁�0�ʰ������!���V�N�������t�l�SL�m�Ab,��u����#��J��|'w"������喫��1��[�hK�o�d�@%���!p�^�ʀJ��"��� ]!�vx����Ч�{1	Y3�e��ű�C������yJ��^�XKg�Dxg�X5z�q+�T�5Lғ�Q���#�2~6t�{�`�m��,V��Ge��f�0-DW
�'��i����i�ܺBd�\ V�l�Õ	�,�]8�Lbm_gM�jwX�%Aka��N����,g���u=�+r[8F��ґ|}.ɹ��r�2::F��\΋B&�<("٦&J���?�� 5�u�O^�j��1Щw����N�fz�yO�^�����!���fK9�Z?��z�^�{��-��,��u߽�z`:\�l���8�|���èñ�ct-�@=l	xmz�l��o��6���=��hәh�F�gF!�HC�2��/ Ҩ��"H=a]�!�i�m�x
d�LI*��p����w�a�k�o�"կt���q�F���/N��:Èα���;���� �jr,��r�B��?���������>A˟�2-g]�>������*��ϲX͝��%L��6I���2��3q���� '� '�u�O�i��$���x��	 �7���ĭ��Kb}W5W�஋��-ogn��[*#�Iٲ�� O�Ƶ�{�$i���K���q.��ЅuD�vŹk�QV-�T��HٕH}�q̞�ܝ^o儁�|*��9V����Y4�,I�����Ɍ�ԉݹ��"����Gھ@�]��bϧ"�$� ����E���|*���%�A�Gy;���I���D�ְ�A������葹~��T��k79��\"E���    z������"��~b�AQ"y��J����E_Y�S������W�-�T�V=e��������o'�$0Q��0:�8�%��+/�"�֥A|�9d���C�g�3|�'<�2�D�L�<�L�����r�G<���3վv��'KթQR7��g^�Ć�~�Wrґ�X�<^E�r`"�^L��ƀ�U�S��� pw�C'�r�/��+�D�C&������}`�)HQB_<Q�����G�@�X!x���~��=����A!�������������N^�����1x�[��)]k��w���%p�2?���Y���j5�~� ����<�x���НH�!Сa��I�mzH>`�&��gyN�V���WNa�7ַ:l��V$�����Ł���"[υ�Bև!�Jw�kDﵿ�yI�Cf��;��,��W�u�T��=z�~�d7*��1�C�FE�����0��������mD}��Nw<���kd�눅�@�w�hy'C�|�<C^*�������1����Q���#F�R1���ۙ���+C�4����+��0P��l����G�I������ve"�e���]l��5�Z2mtU������!ɛ����R!C�HVE
��{��;i3`tyt4?{���r�t�]] xI�O�䁇D	6r�7�MW��f@[���ͷ�ә�vy�HaW6�{�߮���·$���ˍ�^��l���հgߕFW�������s�]�y��r�?����A��w�Qu3�5 ��BsϘ�bm����r��)䧰+�6\�3t�F�/�.�� ��V[C�P����}�m9���� ��-�.��ȶ@B!�2s8:Y3���Ϋ� ����Tf}����^ڵ�V��ނ�H�«k��V� b�%�½�t��-�^Q��5�ئ//�u�?����l9L��r��9�W͡.��!�C��R;U�54��N��a��a�k�B+�� �� ��o���<�[X�={����o�"�#�.�zߗϧ�'�)�ׯ�ק�bfݼE�g�2j�T�&&�M�X�!/�[��LuJDh�4ȧUW���p󙹧����܎@f��.rI�8WB�n2d���^]m�Đ��FfC�B�z�c}EֆN]/�.�UY��$�n��#��7N��/���n� Q�܆(�n�cP�w�]��Ƅ��X���J|��U����)߮�^Fٜ��	=�ZL�A����M�~R�}nO�Zo�?}%dq�yww���$�Q$E:.Zv5�>��V�IH���u��N끳Q�\�4�y̼ѐO�l�Cf�t��&����쉌5��=jE�F!�[XH���I�:�p���b��#Xr�ϧ��G�Qv�����G)B-c?��oj�������4J���圙�;�J�ml�#�l��A�$&�%1����j���E��v�RN뀥6��rh�!Y�k�zB��`�a����|�v��L֐��e�S�b��C�/�~���[�^AF���hFl�����G�:����]�O^vr�9T�3�B̆��c�t��`h�Z��$c�\!�qB��u�����מ~x<��uW̝��dv���8;Ǉ�R�M����G1��!��kil�d?����i͹�j�������ҕ���$�[GW��B��<|}ZL�g�M���W�=�vp�����!`7v#��g sa۱k�L�!y�Ӻp��a�+s�/L�
^�m�4 /�r-�Tx�v-�ѫl)䵫��Gpacv�@�u[w<}�8���Z�7r���Q(T 3:���@��!هӆ�������< l���3Ŭ����ܬA�g:v�o.C:xsf�.b��jj ����K��fj�'�灳f �a��]�i����8��!m�ӝ���o��>��ΜqK�?V��N�^hI����vL�׍����Cc�����
�Б����=$�r���h�L
��aF�N(��c5��<�g0$�3�a�o��-�6�1�mb���gj<�"'� ���]�A{=3��a�vYJ��y?��KKu��B
��摜�� �4�̻6/Y�ڀ�!�3�)^�-P��ݽ �0�ӛM�m�G�w�F{����u��Wy�m$�z���T A]��)�0�P����ΰ�j���i��x� ʼ����3X΀K����c���q�
9����?��!�����1:�q�M���x�z�J���-��B��ܙ�����[�Ì�		8�"�����>�~����:̻˻�r�(d���p�$v�fr��>|��{��Ф"��Yn�&G<�Y;($��\
k��_�4y������;ĝce��+��"uZ5k��#��Bh�lg���Y�l��P�Cf�����>R�� s��������c%s��V4��*n�9��(��Rt�yV��1��i4c����4�]E�ݷe�ֈ�����-��q�[ߙ�>�(�a�]Zv�b����� ��r�Y��>�Jnk6�	u�3tf��/ЎdSɕ�A�l��#
�J��M!���Ο�kο��Rz�R�Du�|�"r����u.��_�"�<1�c�Ñg?�[�!��\�'������Ly%�ibR`�!Y��}*><�����#��"j1�~�P/�CQC�k/�8��eְ֏����cj�>Q>H��+ ����P��F��ȴ6�M;�;�� i�¹�A��&�߻�h����n�"�P{ ���_�����9���I=�ަI!d˹�_N��)x�무�w+=iR����i�
/���!w�s,��������
di�,��r��?I;�$��ѡ�C��扽MDv�\D=!�t�a��pc��p�x(d-�U2⽻Ҍ@t���s��]���}�����B��[�D#~G��{m��|�鿤���m�.�
�r�O��O1H==`>9Zi��o�")���sO3��W�F!U|E�31+�m���u>�4bf��|e�����7:���M1O �6�38��s��]wk"Ns� 1�+ϓ�P������;I@��=�Fxc;�"���k:�Hg�_(���z��K�z��������/�H,�|_�NQ��@�G ��.u��H�n/�nn��*��ޑn�|kt_3TҠ�?�ĵ(�'�v��\����"���U�E��4Y˹QB��<`J;.iF��fG��U^��|�,J����L�:I:F��q��q���P WWx�� �S\`��,�p�	�Z���H��U!�*��#��\�ʆWz����y�|ڋ�$�z��]�wqS���i�{� �,�&����֣LY�r��k=��݄ʋ1jdYR
�?�#���u�e�������Nl˹�}����u`� �ɘ�
�˨�K�@�uw�J���q�%Y��\�{���
��ɐcs���@�.;�f�Ua�;t֙E�e�4�����"t�"��.>���3���(l�s��b%@�;oG���yw݃�&!gK*�����������	������)7�ߌe�ۺ��I�?tҜZi~�Ҹ�c��X�x:-�y&J���[������W!eh�;M{�.�x�����BV@3��4�b�3@j�����z m���C���zm������c�N%2�2:lv���)R��U�ؙf����
���W�g���ߙ;r.(Q��r�D�����Հ6:F�y�گ��t.1�L�#�'�B��?����_�a���9-����?t�������?�
����D���������E��}N�H^��A.�3���;2((iZ��@��ޢ�w���O��Qn�s�%��_�F�2�%,�k��� ̍��}�w���D���=�k����P��S�-�kߌtދe� �wܪ�뮢5�ڿ�������z���J����Tg�<��dȚ�~���|j @� �Z&l�O������P�@���1�����$�i��;n�"�U/W��*����PU�b��������9x�\W�\oA��z� �����:��DCw�|�C��@�#e�����E�*~�(n�u��f����ieU�eP;�8��(G&�.�"���@��ɭ<����e�    dP�L�W�F���<��l�B~�P*+�CVG����`��f��A���~�r'"��.�qz�ag���X��+��<�V�	���/]���j��A�B� ����������� �_zi�`C�B�]x��γ]@KTs������@!7�_��L��� WLM�/��o�!+a�iƽ��|�}�� H��W]wZ��6�mڡ3��!�6�%�H�=I��z9��i�(�y�����"��#� ��ķ�񝛥Hm ����X ��|��c�-!L����L26�h����/;b��__��L0$��-�av��"KYRĺ�o��@C0��oπ_"���� ɑoI��佩Fа�@�I��*��E�/��I����<5�ZȐ�5o��4_Ȑ���Kvs+<\���{��Ll�B�p>lEF�,R��}�������
���RK�߅43�M7�$U��b��� h�s�+��x�^��M6��o���hy��(}쒷�iyx8@j#�R�*O��Ų�?4�,����u��b0Du����-�K&i��A�2Z����u�(�%H��cb>$��c|m�9�͑ALMb��le�⚮��I����ug�����j�����o���� b�&X��n�Όg1@�E��,���ɐ%%H��Ko��w���j��� }!�g�:�:��ƺ����w��WV��a��"�8Ty&���v���d�+x��YYW�_���^��d�=6[������hފ�I��˓LS ��W,D;ԋv����*0�ꨮَ�f�h�7�u݃P�nW	����* pݐ���Ϋж3�o]*80s�a�%�J#E�h�b��Nj$�s�C�wX$=r������0?�5��O�$dh643�Kn���&��q���v��H���Y6� +��,!]p;��m&/f��v��q&�� !s����GY��r��/���I�G�C55�l�n���ts����G��n�gː��{;��(^���va�:̐˛�����Rw�����Eҵxi�iQ��q���:1d�����@�`�e���x$��wJ8rZ�2{����N���f��}��O��kW��\κp��sө]"�Z ��,�-�E_���j"���i��9�&�8Lh�bzqA|�҈�+n�$2��t!c��!۸��ě���QY��|��("u�v`S��.�?�>�����<�0�����]�A��D��`�� c�7ܓO.��暶)�du���z��ק�[QU�D�2�h��J�#x�t�`���z���B�)o��C/��.�A�R6��ԛ���^,x���jx��ѽ�7 Ť�X�t]�*��bH-�m�K�h�� ��WP%R��/Սd��2���0ު޾]��|����JDI��X�K���;��ѭ��]J��8@�Eu����_�J�4����˨�|�$�<�OX-¥'�M\'[���;�� ����w;t����o��hưn��eӕi����Y����uu6�SRGb�/БD�]��ӯ����4�1���,�_�Q�,p%,���e�1o?|�f �� ���<����M	��K^Xe^6���eQ���f�?��U��MaIB?}Сo���`~��q����p��7�����G��}�XM(�Xi�GH�])��s/B١r}�ov ;6��q8�Z�����H!'Y�M�;VSM���z�-��U/;1�g����rH)�]o'����B9��p�|��(B�@_v�8���u�����1�0�g�Vx��2|~�=���gi��O���v1QBRϹa|��R�x�,��;xف7�`T�I��V�pR�}���Y&���Ż�^�hs�؝���cRf	���y�Z��JC*�X:6�oz���to��d�c�!4y����C1�)ǂ�ѹ�7 ��V��g
3�D�]Ӳ|�����ųgt��-���}A���Ʋ�Z��&
�%
v~�b��b
h^�m�aoD�+B�Y�^��Wb���X�=-K�����Y����{6�5I���#9��y�E<I��c�7�@�P�Sk7_�><w�!;~�12�:����d��܌���}�5�̠S�^���2 ݨ�p��r/�jD���}�jִ������ t3�6 m �-�g9�!{���ոIf����@m�M��c���Owb�&B��;/c㼹�!�c���G�K$�hZ��������8n�7bz�y����� �Ҵ�Х/��N�\�F\|���A��Jm�J!�%#d=�O\�u>܍ϔ���4qsף6/[�#O ��]B@��s��CE��?w.yb�R�����@�a�ݡ�זA����N�u���i��nn%p�aB�a�h~�u���A�G�HGֆ7����W1]!݌��Dy�T.SAB�T��u��f����̇P#$��g2�Qj�<��f�
��7�P�
�|��@C�]�ֵ͢�A���s'�.j�&ޓ5���Ⱗ�!�z�nse�.�^�*���	����O�:�9�������R�M��!Ռ��v3:{�j7l[�/}t�;匼���a�.;���)g"�"�#ݵ�!�P�/�-�W*׉���Z�p�ٷ;��udC^1�k���zKk�L�r�H},�J�HU�p�ٷ�Η�b��+)����E�f��z���R�H󏩪S��d����/�"�X(�t�s�.%d��!��n�17w�!��_;���,2z���C�@��Hڴ�R3 ��o��Vj�N���Ėqs7���Ӵ�c*�����U���j�Ǿ��ksRU�3d�K��v���(Ǿ{��#��1�&l��gv�U�Y�?�����K�?=�9	p��O>���lt�͕���w���l��:���.C�;�fO���BI��G���u��Z��ʷDU���f���0kݘ��6���M�]h���t��
��l��+.��oL��)N"����ʠ�k��u������8���훫�_���m��B~��}G#+T�,(��}A�1�-.��?����B�%��*$��|K=E�/�r�уI-'q2��
aω���ڻgy "B�)�RO��C.ɮ[�hz2#w�2r���ȡw\C>�G��W��:PB�lW�]�(�����F]󵹴��{�� >�E������"�KK��G���($��1�n��8���]�V��u�$n�wZ�b6$���l������R6DC�g[���/B���,�V_7�
��a[�$��Mg���g.kH��ѣ۾NFwt{�MEc*F��!ǚ"��	�0����B�� Ⱥ�9�L@A`��y� ��	�/;�n����� ���"�R�J�5�@�����AH�8��n�/J��ܛ�c�{4!�JX��@�^^i1�}���0y�զ���g9�t��&��z]��f4�g�d6�P�J�<Ca8P!,]���D��26��{F2��AA�g8{�wݮ��"�lR#m�i�ES�Q��l	A��'�Lֺ�
!W�I���/}����������?�>sՀ�bE�09���y�9˙��[e�rF�hP,��%0�/Y��R�ȁ�q�'���j�e��Ų����Ce9�i�NTB���4SB��HH��Au�:�e���6ˀ��Ҁ,��������1��@��LƓˀ̓��E-d�:ͤ/|�P�V�ԓ����{��i΄���\d�D�A��t���@��ҺK$�ND�)T*����?�9o~��A�4`tq��4�h�(У�0#L�M�
jQ?�e�r����8r��>��Z���J��4"^���2��}��$hf�.��*������}�loGY׺�O���L-F �4����_Ī`��oA��R�A5���Z��B�u[���'�K֛T�U�d{AwV%�]�G>'o�`�>V[�74,�3,v�����q�u��q�����\q� �,��G��E㵞CU�i��	����V�l C3h���4^�;�c�����:M���t������z:�[����9a6���Ȝ�m�H    ws�Dj=�#��A�`X�'�u[9O���#���͸�Y#$
��3��~�w�6���+uٵ���E�	o��\�pi��5�=�-�n�ϋ����0�m�2��V#���ֽs8ٔ1�4+&0g��::}܋���s�&Gg��>l������������" C橠���[mC��#$�͟)��^A�B'Hh�u�u�k�}�y�E%�'�R�]��9t����ׁ����l�eܕFl��i������Rc�%4p�?�Ќ�/;v��S��Vtؚ��rv;؝���"�Χ��J�[4��b��E�/P��Nሣ�2�۹H�[�jd>H2n#�h:�T�?�J��Z�e��u �{�/��ǹA�������ӧ��s@�`;>}�<�g Yv��(G���=`h�-3��$�|�w3b�9���H��(T�X��]vtf� )��pp�,�6�TG�x��,�f��"X�pc��)��n����(��i*��}w�ru �V�Ū�������և��>��zǌ��\��L��V�_R������0�=Ѝح�A��VP���@�t���g��m�ӕ�\7oA��x@e��ZPm�`���@C���4�����T�Nɺ-p��g٥�)��x⠡�p���o���	h0�V�>#�v������	��)8� �������Q�,g��XC1C��`X�+��$�y�� �j"�_D����l�YB��,�|w`��IW4C[��5tH5 �Fp�a�o�]Mb�|f��T���o�BR���|�J�ڕ�-B�;*�T��I��p�uq]"����n|V��n9"'*v�'�!+�d��B���?�o��'���BO!l�|���; �Ip�a�.��ik,m=&aY��a'�"}��WY8ϻW	3\�e��!�j=98��mg���}�����ѩ�Q��p= �Ʒ�2𘈠{���k3��Ѩ�?�埿���d��B;�΂��*3߱���*5=�8���O��w{�����KjW.׵E�q�A�7е���+	  �a���3oV��u`	s�-lx��J�$B���������E�{����e��H�I�q\K�)ڝk�������A��_������k���#����N@_҄��m:^'dW���ȑ"����[�R/#y+�2�������Y̋��q(x�B����j�
y*�i�ci���;`��{�磫u��5]<��p���Z�C!���`/p�z˪�=׍����hZ���N�n���m���'x֎�!��aC��br����J=!�����
�<�F׉߀r�"wH���/2�cC���EE��vv���r��B�i
8��m��ϾQ�
�{B�"�5NW�+b��[Σ�?f
���O�� d�����"ή���c)~�x��\T�x_n�O�����C!t�NSPW�s�W�"�������,k�oL1�<��B���_�����r�r�B��)����D~��,!����rL����2d;�`�bA��Z{���V@�F:tFz�bq��qo=C� �Qe���"�^!�P�)��Z��ND!��}���'y�d��!��I���k�'��n;���okL�]�����)��}�i��!N�n�[Rm��% �Dڐ�M�<"��℆'���:�� u�a��e����?ʎ�
I�B�,�XN���>m�tW�f�74�� C"����Y�W�0;��Iڦ_��C� �D��.�½����T%��O�=�V�rZ=��U�cכ�Ӫ+�^qe�����D���.ǩ8p�L��N˱B��S�ZʗzP�Ԣ���e��bI���hS�=m-Ia�!#@X{#��U���H��@]T�O�R7�q?n��\]��l�����c�����':�uIq�i������&��+��fPuȞ��z�;�$m2ῐ�ҬL�Dj��>���ɒ�SԵ���e+�"w*0��54}%�
�gBC<��<X��eB�b�%Q�I�^��>�o/�M�B�����g�����-��)#E{d����dp�Daez�:+����ϓn2��� ��,L���^���Md�T�%�%%d7+3�K3�OwKc2�d��.w�Ӎ, B��X�a@�8HϺ�6�2�t���nio|J���ĥW�en]lcӜ��ˎCL�v����̀B^;!��ҡbt��b�H�\16z���� ��WH6�.�sy�dC��f���%�n���k͡����@6����|��Bk���vm���K�`���#.������ܽFE���*��S�Pw���
�"��2��� >z�F$2t�[�)�����t	��9y�AdJ������$w�VH�V.��^`�C5���~UkA�BU�f��I@���0��}v�J}#��{A�9��m��~�rť3t��m�df�5��-�,B�-5����P�BV��:GW+&�1-b4�!^�����/2䆈��A��M0�te�9�-]��&W/���}��!��|6�fΓ�e��0Y	鷑��inOֆ�S��� %�.:��e0g6v�������e-J%��x�A��!7NT�^a��)q԰�1��R�b�=����BΖ�Xf��G��oX�ak�J�0����x�,��A��bv�d�i��6���2:(5��)뽲o[v�c���YF��k4U�;lj��$Piw4�k��Kv��r�Qu.<��\D�r`a;�|�[ݦ�Hi��W�7�A�O�O*��� n�5����O��J�#� T&�i-3���fps�)\J���yi�ut3f����\֔����O�^[��r�y��8Q���$��ՈM1�{�#��4�oj1àIwAS&���\w|Zk�I��z��(G�Jz4,f���.ts�R�L[�Ҫ�R3w���
i,������ER��Ayq����]kv��
ɇ�f���A�N5ƾ0��\h�!�
d���F�>����d����
�U������,��8n�'��l6��Uf ���6�9�o���d(j�%^ī���@��UC$�t��9�6g]Or$��D��疓ZA�z�q;h#0�3����'!g������C�,�7S�Ug��~�v�x������V��5󂣹�7h�(<"�6"3����Q�А�6.L9Fw����@в�d�Y��b�eB��ªJv�k�����Zkg����
_2�kW�����p��_0ht�T̺��2D�.u#)��
G�4��M�|��HЍ�]!U4<!��_c��P�f�Q�k�{n�?sQ�գhX�ﯞ�EI�ʥ�T����������^!	N4̄�k�����(:E&ۙ�=; D��ɫ&]L=���B,�*�7骫�!�W4<:�z�`���,���@|�5�BJ#>�E|zr�?#��2�u^��y
���R�����Ϥ,�����_Nf����������V�u�|����z�e2yc�Ì�c���Z݆�Y�y���^&���$�����0���1u���>f����ˣ�!�P�<����6�@���/�揹��R�j��c(Zn���Aj������&h�%�n��#�` �P�<�[p��H���3ol�}{���[����C��1���{f���c���eb���K���2�����<���c�7�����S����8d뉖a�����K@�����1'��:�y��!\׎���a����Vw�V��55L5�3�����t�n���0f��f�4��8���4!�1��>�%g5X2Wb�9C���MG\�;���b)��]�Y6r@D�7m�U��m�@���k���.^�K��Ÿ���u�w�ˈ�`�#cV\W���z���a�1��QE�\���[@�:H����R�_~�`C/�X%d>l��F�`�G�{����-8��B��X��N�v�A���xu�*�dL���]��a�z9@�xBc�e�*�}$V`�׹�In��,G1�NKP<Ɣ��*{Y���}�P�;��A���AA[�ιm���^ KE���K%��;��[�2�1�h#~�Y����������bh s  �|g�R��֌@MA��b�T�[$$�7|����t��:�e�Q.g�iNSxuMg+���ϧ�,/�@�.=��dZ�z�Z0f;�w��y��0��=:������n��_+� o��nC�CSj��XYCXw1���}j2(�m�y����b�qZb`�v���VK�O҂�&� �fgD�	$]����h_+�6� ��v>BZ)��m�r?�.~2ב>t�QTF.�d>T�'�	�9�����/�A��>h4$D�F�Bv �r�e��c'�.��-�,���)��*��Gtk�6� dH��ۼ���o?c76��l�%5�;~�w9:f�.&Ŗ
��S7�rv��CĨ�ڵ���5G˿��ݲ�a�\�x�GR�!H�Ы�Ϋ������A�Ͼ�X�d��ׂf��aF�Y�C5���Q�m�:Ͳ�P�9&��1�*�a��v�z#�>C|�P$�=툦�&��r*,��OBd�/"�� q'ɠ�óz�9g%t��ag���f�nF~<�ȝ#�_�;�
�6~PZ�����un]Fq."G��~�L&���*�p�p�փ��VI"P_.�5��^G` �e�6���߼]n�R�8n��.��ow'��w��CԱCm�̦p���R�TZM��~yق��[�$�ǝ.�z0��1ہr��p@�v��NB9l{�)U��ً���Ye��=�h.5�y������-�����zȃG��Q����e{�2�qe�g��wȃߎ-��:���I�����Ah�-��0k<���f��7���(��L�N�q������2u��Mqgmʐ���6��ߛT/�9S��݅�,��2L�(����o�(A,�SX�J̶��}<=�G�A�4}����Xٽ�'������z�|����18�.�P��<֡��b5T�L. ����l)�f����Q�j,�6���"��9�j+���Y��dRqe�G���l^�LcB���ř���xN�~��Aʝ�&�yY�ʘ���?�^a�rQ�rN�UH�Wf9֙�b��f�d��2���L_.�F���X���݄�Ѳu������.ͫ	9�@>� �x�g'�,z^�%-��ld�E�r����\����?��_����a      [   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x������ � �      ]   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      _      x������ � �      `   �   x�u�1�@��1(>;^���tW����_�C;Z9����~�s>>��}������V@7ۀ�b�#g�2���Á�hN����_d�d���/̝xb<���q���b��K�����Ë��c��u�[�-Ŗb�f�v\��`�g4�i�i������~L�P3      a      x������ � �      b      x������ � �      d      x������ � �      e   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      f      x�����Ȏ�WYQtA�zo#Ƃ�ߎ+�{1xE�
"��S�&�zd�b^��/}]����m��,����������g��,۟��Y��������\���u~؇����}�_%�����~�s�R��"�Ľۇ�u�Y�y��ǯU;C��AO���{�������g���!���.�wm����"���Vd-n��=�T佬E�↪ڣI1�^d-.�U�x%��Yd-�PU�~��ｋ�s��vU�:d����6����]�wۊ��]]2{Y����;�ݮ*l�CY}�uk��/E���CY]|e08������Va��z��z��"kqC\O*{Y�9�eً�
�:�׳'�T�'�
qɷ��Y�i]��r݊�Ņ��'g>��eڲ�]��Ud-���s������
?Yo��G)�>�^d-nh�Q�w+�7��(T|��BZ�B���5�2���k��Q�*�j��E=�~񶱯U�"����I��Wa��z�E9�Y�-r(k��x�`8�2|�q�t8��\�2
{�f�=�s[��}@a�<�P�saʑCaϥy�l�6�}٥)>����si���}=�����u�,�S]ȟ!��\ŗ�3��\����!/����!k�m=W��J<C[�E)��i=���^���zs�BY�U��e=W���~�֦��nE�y8]x���p�W-m�d,���`,nY:YIo�
^C��^t�-l�Jt��Qiְ�Дf�KK�h����٬�V�Rc�V���J5���n�R�JW��f��pK5��aܯ4��a�K���-K{:�A��>4|-��sΖ��9kK���!/zj��V�=2�-�Ts�.�V��.�[N�Ѩ�LÇ�"�aEh���0#4��`x�m�p+¦P��s��HH���0�$�Y�\�R�i���tّp�lI8}Wi{Z£W�[���aӫ���k���aL�~��{��̡5ю��g���К��8}Wi����l�����5��XHj�_O{-�9t&.a=�^��ä�_(a݋�G���=z`���-0�E��҆�/�*�܋i{������ދ��}aO�,�*O;v=/�b���/�����3�k��!K���r��K��'_����U�3ǣ��R_�=s�bb���J[��������`�;��Z���{ڰ��ʉ�{���Q-/���:��6�E��/V}���,��Z3rx-6T&V�<�^����_���y�Z��������۶}�����"kq�`�m�Y�y/��������|�P�������-&����*d�[-��{��;��J�����?��i�������͏v�^)�]���&5.y��Kj\�m{Y�{XR��Rd����a�d#�PR �k����"ŵQܽ�Zܐ��j��5�2Q���(�]d��G���q�Vd-n���Gq�"kqCU�9b�"k9��HsĞE�r���K�#�z�`�s)���=����҈�E�r���ͦ�Y��"%�Q�
[�P)׎_E�↲�1���+���Z��!.R$^����+�{}y��E�rm���(.�E�ˣ�W���|��"�Ľ!����(n/��"���Ua�:�EJ�#�(��th�U�G�U�-������������-R���E�↶H�7��^��{����מ�z�PK�z�6�w}nP1�q[��94�zF��*l�CU�?by��9�ź#F0��0��8����b���X�������ty�P����P�y���Z���+;�������q�G,�w�~��p�����b��q1�q����#6�E�VFlh�|�1bC[�s��"M+#6�E�NFl(�����"#���6]�����=^2�-,^��咱x&j����e�,d%�Yz�P;�!*ё~�]ecCT�5l(4�ٻ����,Zcaii6��U��تUj,�R��|��W�R�[�J6Y��`,�U��h,t%:��f�=����aa«��0�4�XZ��f,�,�H{Gp�E��^����%���YƖ�,��$�l%c�:�ΐ��4w�X�Cc,�͡1�.��,��k���
/K2K��%.(�� Z�]�ˮ��g~��0�U���
?iÅW��[~҆��%�U�҆�D��"�U�"Ca�Mc�Y����q5�>l�fqeil�eqEk9�E��b���J-�^���b���%i������W�GZ��+�#��5�����Y�^���E�9VX���'F9�E�r>���|ϑ��z�vb���ϯM�	}�ꟷܲ��JK\-����m7�u�~H�E�V�h��N!�ŗ�P$٣H������+B^E����^j^�Es/��ڊ��\�=�|v3z?���s�-K~4���Z@z.إ\}����'��*li��$�P�p.��4�OZ��ث�Z�(>�%�F�\���Q=W�m�Wa�ui�:c�"kIC[Z��أ�Z�ЖV$4�*��3�%������us�:i�˥M�\-m�YK��ރ��X5�,��{���J���E�^C���ƮE��a�=��=���k9E�r��K?¢)_5�2�k�0jA�;,�Nh	�EHi�~�0����?�ì˟v<���������B�O����3s��Y�Y�?K�ӗ�}�i���<��9�X:t��#y|P>t����Ci�W���������\f��?��U���Ol��Zd�熪��Gw/�7dE'zP����q����a�"�ĽBT|@%�{�"kqCU��aw-��*:��{���CU|�&e�"k9CWt�&e�+:R���Rd��{CWt�!e{����+:���[����+>�>��Ee���4�Ud-n(k0����L%Y�K��9�ŧ���k���!.>�{���C[�f���Ni�
[d�K��m)�O�i�!�4n/����Y)�Ua�:��g�R�(��thk0��W��C[|�,ܗ"����->����E�↶�,Z7�EG�Rt���1tņ�R����0D���R���O�+ŧ���k��945�K#�U�"��{i�
[�P�`\/�a8�y�����R8�5�x��-6YK�P�`�,��0]�[(l0¡0>���!0>F�����<
����(���(G��c�G����l�k0ύ�!�� ,
����C�m�Aʔm���(���Q6�ŧ(S6��� S6����2�e�������Mׇ�E�y8x���p�W-m�d,���`,nY:YIo��^5�r�Jt���0�EW���f
Mi��������2��f�[�J��Z���*���Gg�*��U��a��y��^�َ�BW�sh0nV�C�Xx�&�j�CK3ጅ��i���Ҍ��q^d��p�U�`�Y�.犯el��2OB�V2����Asw���94��y�c�"�~_p�5�f}P8��b(�,�,1V���4��hY\v.��U�?0\Ѳ0���O�p�U���V����ëf��k���0�i��{��P�h�|VaK���j�cu��,N���}r�/�7�%�J-�Z����uP�/X�"kq�"�<_`��uh�Е�X�w�=q�ǋ9?qaǋ�s�����|h�k����"k9��sd9���f>4�YC��^5�Q��Xư��Ւ�x�=|X�ɂ��h��WaKC�]�
[�p��ʁ�g��a���d�k�t2ᵒ����>9'^,w�Va��Vb��*l��.��b�Yd-ihK+�[-�<9�����>9ÆW�Cx���+Ky��/[�#w%/^�廎�K��x��JZ7^d��7^,�ۋ�����݊��~���z�b��"k9�E�r����g=����d3^C���ſ�3HV���D�l�ZH�6���/�M�l[>>��	�o�j靊�w�ͳ>^����-`z��p/���?n:��qoE�ӎ��mS>���㷝W��y_E�Ӿ��v[Ba��ònK����^c=����J	ﵠ�p���x�!,~��ph�?o�N~���i�g;������b���|����/�L�IS�b�_��#�?>'��/�s�↿x������ܿ���qR����/��s�_�kf]�    ������������������/ι
{\3k��㚱'Ô�x�/NRO\3��㒙t��y�yY�i�����/�9/k\1��۔?�)}�_��'�2˜��fҭl�������+f�ʊ��k���b�9�y���<�:�=G:.�e�y�p��I�O�IϬ-.�{R��z�s��.��9���1}�_��Y��q�#f����qɬs��Kf�e��g̤�Kf����K���隙t�qʹI
�5����5��9���>�Nq��is�s���朙#]3s��#=f����5�'�j\3}����'�k�ϹS��f��s}�5s���'.�e�Ex�Y'���$���Jf��qŬs��N�eǤØ��&�W�6�p���2_�qι�p�ls�,�I���w�O�m�qL��I�O�m��Q��EÔ��kf��Q)n���(ۢa�_�5��y3C��S�"��&�P�n��3�Sۢa�_�5�ϹfPѶEÔ��kfNᱣ���<];*���?�/���=vT��j�_�53���Qlos��%x[4L���f�)�L_p͜S����kf��������;�����q͜S�\��kf�q�5sιf��s�5��-��E\3s�:��mN=�����G;���r:�/⚹�\3(��Bd�_�5s͹S����4��T��S���͹�Q���Ȕ����9Waj ��\��`N=���9�YG@�ә�S���^O ǜ� mN�CG@�S��� �sR:: ���^O- sZ�:Z ��֣��>��h�s*q}K�ٜ�ٖZ3��)�����;� �߬��ϩ�vt�9͎.�>�-���ϩvt�+����kfN������`N�P�S}fҹ�53�����i����ޚ���T�;� ��&��.�>�2�����tt�9��.�>��] }N���������sJ�=u������s:�:� ���pG@�������v��9��6�>�6�S��>�>�6�S�6I��f&����*��s��=�ls~5� ��jsO} s��=�L���'�=�蓼�+}j6�\㚙��_�S�9���s�H:� �I�B��s�J��X��*�;]3��b�rf��} }R��N�̜��>Ϝ�ރ>�>g��.隙r�%]3S~��>�>�wfE�:�y]��S�{V��9�+� ������ϟSm^��L���s�)w�5��SMY��9٭�X�8�kK�4O:��f�x�vÉ;Ŝ{O0��kMc ����i��ޙ} }N�Ԛ� �Qx0�r��1 s<ҵ��s��O�j��'�?�gY~���_m5�,4��Lw�ye��Ǉ�[�p���|���U�=���w��e�����W�ig����px-���C_|�y/�9F�1s����tȋo���E�"o!/�Y���"�C_|�!y-��/�Q��"�i���6G>����э�8�ѝ�(�/E�~����h8܋����9�ފ����=�x�J{���≇���G�F�S��v����J{��`��^��G����8�aO;T�7��!2�C}Ui�����s)������X<r/��kqz�Ҟx������{ޡ���^����'*�����R�-�*�ۊ�Ƚ{�P�X�G�ѝ�8��XO
cےq����3���4��]c-����d��w��;�5�O��^���}�c��*��Cc��8ۂo��i�|c4N����1z[Bk��8Zl2�ihMW궄�{�p:��7f�pH����P�`�N����p:�Ʒ*�02���2�i�Cf��?82̵�tȌ���p�����p��O��p����p��o������á1���{h���a���v5��n0��%���L[f9�'�fB8��X����Pg��:�%:�&�hZ;�Ҍgg�.�;v�f�:�Lsp���WMX�a�j>�id����j��l~͹p�/��t
�H�q��ù(�xa�����0�4_�ad�5�0�1͚�G�~��p�Ug�i�c�D��?�p�s�Iͤrޅh39�Bs��}��=ÿ����"l
�ӯ�=>���8oLr]��5&�F��w!:N����ޅ�g���%�~��p��Җ9�~�7q�Ui�^��8�Vi�Z=��Wi������g����毭�=4V�ڲ�`����҆�/�9t&�i=�Z��û�_(a���G>��=z`����y�P�f?x�w�TYdx�b����������i�E��ފ���O��
�;���g��_|�X�9��7^dI���U��xT�-�Y�{��E��Vi��J��n�ϯҞ92�@��Y�=s��rOF�[����j#�"li'�_,�8�ViO�$�,��*���3����Y�=o�L�9\-'YڽZNr�aKV�Z���k���P�X���{���x)�M�=��r��ޫ���L+��_��7��~��p/v�L|Spx+6���.��Y�_�=��{�x-c�,��kI���X�~?�j����}g��Z�	�R%٢�g�>H�a8��q�ߐ������(\�C��<�S���]Daϟ���_��g���(�?��E!���QT~>;�|�_�#��UՄa�71�d�/�N^�"
1Y�]EQ�^D5��o�Ɂ�A�A�xV�7���L�j	�{���-
��3.�k2���~��:�Ԩ�ƴ�(��^qg�|O+��[|h�[��r�FCK��nH�o-��c�ۯQHiҕ�g�����`��jФ$Q�p�c{ٯ�t[�"�>�UOk�DV���=�-`�F��D	��$�V��{��hzĉ�����#55Q0�c�կQ�iU�0��5�K��Z;9����k4�IⱤ[�v^�%u��	CM];�ǒ�LT�BM]��S<6��sN�~xl�5
1�j����9��ǎ�_��}�9w��=<�F�sN<�-}���^X߱���h2�#�;6���1 �4����:p�0�F���x��t��_�P�.J���c5��s�a<�vQ��c�ɯQܚv�RO��w�^v�ޔ:�w���wQM���Քz�E��H���4����H��x^S���F��D��H�i��pNs�jJ�iQMi0�)�)��9��5���#��9E!��4�x[��h�ߚ�шjJ�hNQMi�)�)��=�#͠��x�xl��5
5]��`���}_�P�%�x�"G��E3�H�%jx��5��$
1��(�d����LpuI����#��x$�5�����ˈ~���ō.xl$�5��c�''��RO�t�*Fx��Fx���J�^Q�0»h,W��O���.����.z���.V�8�]u�w�@wܩ�W���	�b��HN�X:��7�GNxKHǝ��'��/p»���	�b���E����E���E�����'�	'���	'��E�Nx��39�bI����	'��N�	'����Vx��'��.��'��.:�g���j�	/��N홼�M<��»�K�-}ή�W�I4y��ob��»h��M�3y����Ls^�u�	/��+�3�r��Ox�]tCΞ���+^�**Ξ���#/|{�Nx�XB=פ&M�M�E/��Vչ&5�7�5�\��xᱛ��hR��[��Ą�w��r�_�6�sK-��3'�p}�3p�3uu�&�F���ޙ��E��L��it�vp����S�xr�����p�_�U���������Ŋٙ���Ǚ����ʙ�����3������I����.���4�],T��]�k�/8>X[�,�O[��~}��͞.����}��ҭS<�in[^���r�<���>/�˹������(f��5E�@"r�P�?�o��W��?K��\?{{�����>�h_��9|e����]��*
��m0�f�q�e�#�̇$rx-����D���OI��Q��'����E�*�9F'hP�Zj�%}���lG�a���!y�{���*�#E�#��EGRr�*v�ϳ��aK����<KCat�%��"�
��9�aO
��8|aO
��[�}W�'�����O�ZZ�ȡ��lN��@y�[���!3>?��>��    G�������*��Gi����4tkU�cCf�=�jk���{�#�E�#Cc|h*��*퉇���U�E����VN�*m��P���C�E�#����Xy/�9T�G���!2:*��W����06f���Rc-��b#j9�k��m�t���Ui���屏*��C_�Ѻ<�U�=vhl0Z��l>���-�x[N��j9Z���thm0$���ZA�[hm0u�ӡ5>8��!5>��á���:J��9N���9�!�S�8��r�p�l0���!��05N���<4���<4���H3���T2
!2>�á1>ɘá1>*�á1>՗�01���j�^���u��_2�=0^ɴe��xbj&�ø��0l~��v��X;�0�E����D��ᐗf<;uiޱð�4��aXd���pՄu�j��_�QM#���`�\5a�	�9�����Ca��4n`�#�a8�/�~�t����_���?�Ys����/�����9L��]��.�cN�9��Tûm&��^hN�߰�E��a����p/��`8����_H�����$��YXc�j�ix���tٻp��]�_����.D���^�=sx�o��V�=sx����Q�=shM�l<�U�=6�&:>F��Wi�v�����XYj�R����Ğ�V�=r�L\�z����w!�Pް�E�#�E�=0��;4m8���`i��O�G^�i{��C����a����}aO�*�*O;F7�����k��b8�k9�����y�x���A�d��}x�{��CvTi����K|~���ᐉ
���/Җy2��Ge2�5��ѯ�Fފ���_,�8}TiO�$�,㱯*���3��c0�~��a��!���$O�ZNrx+6T&֢<�Q�=6T&V�<�U�=6^�d��N~��tx'�_����h�E�3^ʴ
��{��Cd⛂�g����O����jX�"li��aK�?�܇f�_c=��z�!/���yO���Q�	�R%��g�>H�������;��6�7��ў������_ը����������e�/����o�(|}A���������
=�O����U:���c��#�(����ON���
�}.� ���>�i��z���E�[>9����2Ĥ��!Q�V�/l{��� m@Ń��}BɀDq������`S�����45N�W\K߮��Z�����R��2 CJ��>$:%޿m����ؙ
)�P=@ӧ��Q
)��S�II��{j����m�u�Ga��M�(nK�D(��>�l�&1�^�}I����@��q�$֤&�CM�#F(��>;����ɦBjz�0@���q�jzC7@��D!n��$�W��dS��������M4(��>M����ɦB�91�=}�/�V:�Th���T�7���;(��>�r�b)��� M�9���&S��r���ŷ��dS�
1����0ԗ&��]}H����&hz�V�0�L��&(��>or�BM�
q�L���;N6�P����[��ذ�����%5«������� ���7�P����
5i�c_R��z3M����h�7��57��Q�&�e}P�I���6��{(��>�q�BM��hR�x���6���P���jz�79@���ߚ&وj�slD5�)6��(Ԥy�
5��X_����l*4@���	�jzA:@���=h�$G���d��f^K�����&"iBlKR�&ĖL��a�M&��\�d��K��l*4@�&�
l��ja��ϻ���҈~^K3i��F�N6�����Q�N6�XӉ��#�l*4@ӚN��`��M�h���V�I\ӵ���'�l*4@�&������M�(�$��p��� M=��yMN�Xjk��#5�%�'�l*4@�&�� N8�T��p�ɦBj}�'�l*4@Ӱ?�'�l*4@�&��mp�ɦBj�ږ�p�$Ӷ���x��N6�P�Xjk��ɦBjM�+�l*4@�&������M�h��W�I�%�p��G��%�x�H^���BjMޖ�p��m�WWW��ɦB4}�.J�HMr���D7��!�bɠ�'�
�P�Th��IN�1j��ɦB4�IESg�x��'�
Ф&�fz��K�/�l*��+�I��WR���&t��+�p��� M-��3^8�Th�BM�������m�!\u�R;��r�vp�4J��bg_�S�xr�����V�I]5�vp�:�R;�X1k�\�q��.VV�p��E����5I��.�r=���������/����k�]���溈��?�l�3@13H\��%�t�?~����;}������g��<����9��l7�X>�����sy�[����C9|aO���t�!g�˧r�.���{苏@��{+�9F'\pv���tȋ�^��"�C^|p#�|a���Sy�[��/:2�í[�k�ϛ��Z�=m(�Λ�0F�Mr�(����0:	��W���0:���R�-�
�c2y�^�=vh��䡷"�Cc��1��&t���*��Cf|�'}a�����pP�"li�2>�G���pPz��2��	�Q�=2DF���W���jJ�c�Җ�*�#Q9܋��*�S��V�=�P���CE�#���(W�*�9T�G���g���r�l����	��1��]k��y����k��m�Yc<�Y�=v�k0��Ǿ��žB_�ѷ4�ժ���F�r�^�i�|�,�Ci����F�r:�6��ih���+�6��G�;���q8��g�q8�6�.��P�`>�Ci|����)m�CF�q8d6����`��Cf|^��%T��q8T�G�q8TƧ�q8D��s84�'s84�G�r84Ƨ�r&���]��p7o���n���f��xbj&�ø�`Lzuv��v�a򋎷y����!/�xv�Ҽc�a�5iyf0L~��u�f�:\5a�	�����^5a=rՄu&��\8����f:��~�Ӹ�i�H��󫖢���DS�id���02͚s��f�٣
N�{d�c�3�4�1]�k�s���_4��w!�LNýМ"�a_hf���/4����B��kn��!96���\ga���Q���·�e���w��Z��i	�_u>�ޫ�g�B�M�>��g�Bt]����e�_�l,6�~���К��8�Vi�o��j�Cce�-K��R[{�g�ȡ3qM���o6n?�z���_�=r/�����7��iCa���i��S呏b��,�~��B��.a�����_�-m��⩲�����wx���/�j������y�x���A�d��wx�W��CvWi�6�Zb����e��~�@��Z�=s���2��y���j#�E�ӆ�/V�������_-ˬF�*���3����Z�=o�L�9\-'y��r��g���2���*m�����,��_�=6^�d�oK~��t���k��x)ӊhE�3^ʴ
��W��Cd⛂���_�-�����(,���"�i㵌m�ó�k�'}�X�9�E���9_���kA-�5�*ɾ=4���������;���`_?r��V���_ը����������e�/����o�(|}A��n������
=�O����U<���!5@S���0����`>��ܶ
�}�� M�nQM0�ɦ?���>Wc@��T¹'��PԸU-��'�����������g�4}��FM7��/�hj���#}�&�V���$�r�sB(��T�)�O���x��|�BJ�ca(���A� M�B�G)��>gR�(}X�dӟ�nK��(nK�xZ��}�xG��N6��IL���t_R+��>�m��G�(�+�I<°�ɦ?jz�m1@���M(��>�a�BM��:(��>&n�&5�B�ҭI=��m1�;5���:��g�BM��4(��>r��9��>�u+�l�3@�n�����Zz%I��9��g���vV�%5�j��}I��ko�������ɦ?ƀ�Ҵ�/��������A���-�4��}� ����AP��}ӟ���#�R��(	x�dӟ�[��X�������^�   7���}���&��M(��>�l�BM���w�f���߇��to�kn|W�BM�˺��w�>�&ۼ��h�k�>#q�BM��hR�x���6���y6�;P��}� MjRk�d#�)ϱՔ�ؼ���h�a#z�{�`#Zc{_#�X�dӟ
5�O��P����
5]����I�x[K�h���K�QX�dӟ��$
1���ð(�$:�{2��%��l�3@�&�
ܓ��� M�w��5}�%��4�F,n�p�ɦ?6�X<�a��Mh��%��`��MhZӉݑ�����4JK��P���;�w��ᄓM(�$V�v8�dӟ
5��N8��g��a�&'\��g��#5�%�N8��g�BM��p��� �����'�l�3@�&�D�Sǹ���p�ɦ?j-�N8��p�ɦ?jK2���^o0p�ɦ?jKm;�p��� ��T�V8��g�BMb5g�N6��葼��M(�$��p��� M_�kw�#y���P�I4y�䅋&pquu�'�����(�����#����nȑ���%�^8��g��&9��'���4
R��IM*�:�ċ^8��=�I����ɦ?�&����IM�oMjRN:��^8��g���K�/�l�3@�&��>����=RC����\t���.�FGj;�x�dӟ�x��
5���#�����#����#���5�#�����^8��g��vpQ�\���.���4�],Tiz;��g�c���=|��.����N6���x��40H���������>x�W      h      x���m��*��W�bO ~@���A���T��2~�>���,B$��8W������_Ǐ�����}�/���Õ��~}��)n)e[s��� #F&�\12cd����77�M(���yI�;_����3.?]|���͗Rݛ����ƻ������3�%�������K� ��lYH<J/�_���c�
��`�J�>YH,!�
XBK(`
\������ߥ���A���%V����hY,X�%빀��s=��xV�Vpo=�m��2b{���x�En��*�X"ք�5!�=7bJX�֡�u(aJ|�:��%�C	�P�:�bZ���|�uH��-$�!�۷�X�o�:HqM�ڧx�*R���	u̅:�s���`�\�c.�1�v�;�s�	Q$�-u���]z�.�`�^�K/ԥ��u���B]z�.�P�^�K/إ��v���]z�.�`�^�K/إ��v���]z�.�`�^�K/إ��v���]z�.�`�^�K/إ��v���]z�.�`�^�K/إ��v���]z�.�`�^�K/إ���������������������������������������������������������������������������������������������������������������������������ҫo�-$�!�ҫo�-$�!�ҫo�ob��.��|�?��롷��=E�,I\��8 �k��W�A��r`�u�X@#^�5rī� �lG��Kh�7�F���$�Јo�Ar��OR ������*䀩�r`�X,�߼����� �v�7��v�7��
��o�Y��^���$^d#�y�Wوo�AbM��;H�����uh�7� ����$�����$֡߼��:4�w�X�F|��Јo�Ab��;H�C#�y� �5k߈o~�zA��zA��*��;�.��w�$�u����w�� ���� �l�c>���Ĳ����;����')w���C��;�����c��;��H���8��:�B�3NlI��:�B���zK�Ƿ����؞~@>=%?cX���ZF[��ek�}�[R^����+����A�}ܒ�mT/R�E���{��q�Η2��^��AoO'�*k�~��ܓb�緧�c�kط��y�k���c/�;H���=�ҽ��돺�c/�;H|2����K��u��^�w�X���=�ҽ��:D]ﱗ�ob�����K�k ���K�NW�`�^�w�p���t� �h��>�ҽ�Ĳ�N��K�˖:�c/�;H,[괏�t�H�qW�V4����-4���^�w�,��t���:��[�{��A���-M��t� ��������$�-uu�^�w�X���{�A��2�ꎽ � �y���c/�;H�C��{�Ab������uu�^�w������~�x���~�2F[�Q�[�����R{��G4��+�[Ö�h��(�['KX�X'+�{��k��o�t��s{.����[��7�#�>�4����w��q�/�B�?=��U���_%��K����*�r=�y�����Z]�u��6h�郿�k����OHϘ�U|:�C��Y���>��Ĵ7Z~�T�TL�T��U�W-Fd ���@bi1"�ň���H<N-^�#�x���:��k$�-�$�*�)��x��1�+��r�3�4��1�\@\׹��j�c���Z���-�zZ��@b��E]$�Ax�h�P$�O-Fd �ΩE�3�uH�.H�CZt�@��]2�X��蒁�:�E�$�!-�d �i�%�uH�.H�CZt�8qM�ڧE�4��à�|���P�z���E�a0�XBڣ	����` �����g"H,[�$����')w���j&�!n�0�˪g"��H���8���g"�Ė�:�z&���zK���L�q�g���|~f����U�0?3��u�:����u�:�����?׭��𔴔V/�������z2���jI}`=��@��VK�������d�&rM��G}`5�@B���FW�`�d	���L` �h���'H,[�w��˖��z2��Ĳ�~��L`H�qW�V�'�Hl��î&v�z�z2�! ��\poitAO&0��������` �R���zJ��Ĳ�>��` �l���H�V�ê�H|*���` �Q�UO	0�X��ê�H�C�a�S�ob����R���0����
ëWO����o�ǯ">�������>�ڏ��M��8��8@�?�;����UNy�V��M��Laq1n�4YC�ʢ����\�{�yI)n��,L�EJt�b�u ���Ёʎ��lh�]8�RG�?�w��R/n�������v�������+ⲥ��`�ZtCRU�b:O<� j>�
T���Q�h�TN �l��S�h�>�����;P�}ցtYi��u �n�c�iW5�PRМBH7�=Ӂ��h.��ӡ9X:�N��^��.d͹ҿȄ���UqL4��V�4UҪ��,��Yu [��kVH�ώ��TH ��ר�!���U՗��`�"�C�gU��.T�k��r����ـgc�������=Ձm����0B�qZ��;@��t�To�k3H�F�4Ӂ��C�H5��ီ���S�q�p��|y���Ҳ���.j�[�=�k0ͥg*�����H{�
J�/��X{����ײF�~�k�:����'O�k%���ġ�n�S]��=�.�t=<�<%.��v��E�SF)�=�[rp[*cJ���`Q|F�W�]��{(��?'�� ��E����U��n��c^��y4���H�e���Z���v�88�ϸ7�r���r�s��WByq��9<��Y>�:�P�m;�����~�aIalI�e���\-d��S��E�`��M4���ea�at����U��F���6Cn�+|H�yrӟ��K�7�������*��FC�iOa�N@��p���/�u [�;vH�cu�#vH �����!����p���
����ԧ���"��A�ݺ.��x�iWa4R���J������2���#���:�*�0Z�?rׁT�0Z��pׁx�F����:�U`lHڮ��@P׮��@PԮ��@PѮ��t }� �_���[��}�����-{پ^o�o �UO{��v������������o���?~n}���?���~�X���?.4���y�.��v�2��4X�w�7$���P�[^��q��}X���)6ػ�xko[s�q����̻�`������{�'H�Nh�{X�h��@	{��eHz���X��F��3��oQ}	R;x:o]�����1����i�q���������K��%�9 ]⚣�`p�A�A'Mob����{��	�F�l$�f7��F��&6��ײ%T:���M<+�`�����5m$��n�ɖ-F�N��"�av�G6�wn�ħ3�z�|xc#W�ĳҍٲ퇂Ll7�c#��&`�Hl����{ۍ]�H�E� ����l$�P�G��XB]g�6�x�t�f�OU0�p�J����[���`#�8�-Q2l$\)J΂��㤇7%m�FbM���~��I
�]���~��-���0�9S�`�Eˑ|m�q�Ӣ��`�[z�T2l$��n.���%3��^6�=+�X����^B�=J�A�KR�5�{Mj#��@�%��Fb[B�%���|0��Jb ������lj�?���X�6�F�%ֽO��ء?.ښ��=�	�U��ϴ.E��h��*YgK~@�*��l�T��Y��`Яm�o}�-��ɜ�%�5K������E�>�����#_�;��u�Z]���P���-�.��^=�������?G	)��:r|��=�_6_��[/{f�ծԩ�����u�H�S�ڳ^d���(���� �-W���lQ���u���V%_�K�=L��Q9���T���e)�s��ޯ��LL��cʣ��H�w��H�ӈ���`o    S4���A0�P>J��ĝ�Q8%�Fr	A=Prl$\)J6����Q8%!�FbM�Q�~N��I
�]��]�K0�����]?5�^�X�4�d'���� �����w\|3�d)��[LmTl$�_XhNIV��X�4��+�H�9�uF�pJ΂��'hR�l$�!hR2l$�!�?*�6������X����������`#����`������~/���f/���Q/���f/����:��o޾����+���~_-���Zp�j�w1�&������[B��8p���}�෧l��}L2z>����T����>}\��S�ΠL�����A{E����3�ŭ������Rok>�V�Fݶ����-� kC�����#���T���ϙ&���-Cq[�d�E�c��Ś�by\k��_��-�@-�h �7����$��3$�\Y�ĳ��$��rT6�|>��U��>�PI0���F_1R9�������r�6��O���a ���3fE���X-�f �19"jקd���3�x���;�ס���h<~�!��A&�D�ުlϋ$����Hl�(����O��H|4��b����ͣ��2�X�Z��@b�j1*��CZ�JC��B:�G�2��8��H>Nh��|!	ט�/d �8�ˡ�H�	��P�OR �*�U�|!C:|U�aR_E�2Dˑ|m�qR�A�2Ɖ-	�7�|!��V�2��S��YQn�t$*�B�(�i�$� 흂��;�p�|!�m	���|!���૚/d�)P�2��!}z�,���=��8[��I]=��@��I]d=��@��I�k=����&`��ε�@��|��;K�r=��@r	A=�$\)z����n��@` �&P�\M 0>I���к�	:=�ϫ	ƚƂ�� =���u���4��'H���KK=��X��b����@` ��º@s=��@b�R�\O 0�|s��:�z���'�?�	����u���z���:D�G=���&�>�?z#����0��'H�����@`������7�CFJ��M%��'|J�'g8%�@G��@`�Q+�DC��#��FI�by��~lO���IHG��pT|]�tҗ�q�v�oտ�>��F�=SXҶ�S����ynm�S[�ڷ<�oy���k��\�ٚS�V��8�kj��"�jFJL%�*�Y͵����R?\�).�����o�����3�"g����8.��S;S��\�ũ��T�mnצ�m���~���̮��I�3�&�M���5��Luۦ�e��ʹm^�Ψ�)6/3��Z�mj��T�.+'S[��nS��0Uy�A��*�0w����s�����jH�:�2u�������p���ԑ��SH�۷��ީs��,g�mjC�܁�<��:U��T�SMo�Λ:�qjXj��^�-��pj�"N��4U{�ԑ��d���9M=Ԥ�.��?w_HS��4u-�S��ԋ?w\�ɧ�[�ڷ�Z~�~�N]�Ե�箅��m굢�SWV����r��N���<u-L�*n�.U������ŕ��V��Q�? )��<C~FY��!����߾I��+�Q�".��m��6u-���V���2w�S�[���N�~�e�E*SmH���nsW�T٦����s/�֩�t�]�L�Β�&d��L}�"S_���p�L�Β�׀2��+S/�ej�L�^x��k@���o�U�L}�$S/<e�{���`dj�Q�����/Wd�IU�^���?2��t��L�>��g$�z+S�����X���D�>�����S7��k2�nW���N}�"soc�T}�ٖ��2�nW�ܑ�=�L=9L���T�9�}K05�(S��25"SϽa��0��=L}��T�����{@�z�%S��25n)S�4��W�G
s#-�}q=�!=CX\�[��KK��۞�?�_|)5�8,�|�\~J��f���s��e�$�ޅ��x�c��rM|��I�_-������Ϲ��q-��Ӎ��^�N�soX���1�7�&5i4<cZ��j�sX�����5jm�?럸����[T���J��#��o'd껎05��ހ��q�������?5%;.[[O�nWn],�&>�a�)ǃ�?k��fJ�d��v��7���6��KKZ���}~�΃�
�g�W���5��v#��٣n���Xz^ײ��Z�U�6T��ه��n��TJ�@��������Rv�@b�j�M	)���o�Y�J�H�M��������%Wԁ
���W�̚�W�T�����)5�J�1C@\��t*�ϊF�h �l�:�:V�6j �1���RR�@�բ�+H�\�@*�R!W4�x��$�
Z�S���V��@⣉V3�@*��V��i �l����֋m�F�h|Z�D�@(Q�$<���` �8����$\c:�����.�N�h �&P�C%W4>I����WQ���U��I}���N�h ����~����8�%���N�h ��j�z*:��1+J�l��
��1J�A�����q8H�3PG'W4�ؖP�H'W4,������5rE��+N�R�ۘ�85r��F�a ��.�N�h ��εN�h�\��Q�Z%WԁP>:���ĝ�n�N�h �������\�@�qR�\'W4�X�[��+��@�Uh�urE����UrEcMc��@�N�h��:��[|��$�q�N�h�kl1i�A'W4��~a]���N�h �l�c��+H�9�uFs�\�@��urE�u���:����:D�G�\�@b���N�h|k��A�hX\T��$��Z�V'Wԑ���M�\ѐ�B�h|S!W4�	�҈J�h��rE	c�:���~
����_]rE��+��X�\QGj�R!W4z�����![��\��T��
}+�o�j���δ�7P��DwP��A	��-�
I�L
7�:%�����a�o�I��|��ƙ��ɚ܈����(!�G
�<��A�)vL�hE$xd��[wz��c�Ŭ� �|@2��I>2i0c��KP��(4�@z�Cg��;$F�LXt�[H�'�;=D҈H#��F"�ؽ��?R��!��O����$q��n�5��G���|�{���=K�5
�{�[��Ͽ=,�g^�ӹ%�����w�F
~N��yW�l8��u+a�w�o����b�������\
2>T9�l���͕:5�~]\Yw����2��{�6�Y���h�dzS>yJ��o�!&^�)���r�?y���ix�����z���.�u\x����\���0�3�*>�����:�o�
B�@�;�/5��S[���m�S��<�>i�]\��B:�3����N��i���\��l�kg�T����[�R��z���ȕNhKh�H�p����G��,:�'�+�dW�(,���geGp4_}��<;g�H7V���Z_(�y�h��B�&�q1=D���nd�,޷!�$��t��"�-�����aAU�F��p�7�,l�"�BAa�3%��^AOg�;(&C���v"A��3	���t5v&)��B�B��>H�w#�I�}�� �H�
]����� �N�I���t�#��IXt]�	��S??�A��B1�3a��G2D^�����P��Yld{���}�#�z�k[��x4�#�1��s�rB�����p�� Kxԅ�n���T�N�j�)՘۰8.�ͿӰle���ps7	�ML���=}�̅��#���gH�su<Ge'�,V�ŷ������R�չ����E�֧?
��5��a�x�����d쪲ׯ1���h�����\��}�q�����S|D����D�n���5��+�-^�u*jqi7�7�Co����;���Hj�|f��։^{�Ң��0���l`�D�j0�^13�|,f�k�Z�?/y7�~�*�x���'۵�{�V�I%�xn��z�C���O��Q�m]nm�qOw�PɥE��խPIu����R�~�[�-G��J�J�ں��/�_3�����U���G���C8*�́o��u�Y�;�ׇ��ׇ��0�h�_$��[���9w��<lK�B:h�����/    �/��/n�:�����R�ǘ��Z}ɿ��s�::�����q����g��Z�0c��Ul0d�խ�n����|�!���n{��S�U����x���+��<rڭRRj�J�����J��9`-�j>�jԼ�:��N��!^+iG�!�a��r�<�u�O�Ds�%>��t&�g���V�45&�ۇв@�Ѵwg���!���;?���➮,������U��r%n��7M1���ڴ���ҿ��j�U�7�h�_?wɟ)ܧ(l5�C�qX�*�0�Z�/����W;b_��Ǖz�7���W�u_��Q�j��T��F�-�Fn`�D�=jWӛ��ӵ\�z8��%�}��<���ydR۰�C 
�T���� ��<�f��4��,]�S6���>����D��
L�F��hA�����]w�1m����h1��#��އְ�egJ93]�ǎ�]z�\�/z������o�+\3���밇Ͼ��J�Z�k�oJ������p7�-1WFͶV>F�Ƴa ��֊�H<[Z)�s��g��&<`�<:�G��0�Л�y6$'����a ��y6$'8�<k�<�')w��ZT�C:|U�a�PK4x6�r$_�x��k�φ1NlI�s��lH��φ��N�γåR<MGb�³a�k�V��@b��yH�30�3<��m�<��Wo*φq�@�gÈ�T	�h<Ɣ�ũ�I5�xqjuR$^��E�y6$^�Թ�y6���k�>�\�\�<��|~�[�[�[�[��lH�Rt���I�r�g�@bM�n�ʳa|�qW�u�y6t$6zԟWy6�5�Kt�c6������γa ���o�u�c]c�I�:φ����u�u��eKs�g�@���3��<�h����lH�C��y6$�!�?�<��u��X������� �γa a����0��
φ�S��o*<����
φ1N��I��0�p
φ��1M�gÈ�V��*<F������x6�o*<F�.�g��-��k<�l����ٰP�-T�Z���zo|�ǚa�:��$���ux/�eM�g��=&�2��@]׶2?�Pd�;ְ�vt�"�Y&��V�}�#�����F�d�D�Y���f��B��lc~��u�/�����f�|1c�dxMa�<Ҩ�
f&�$��_�z�ʱ��]W�����?�w�w��ZO^�x*�o+ZUԷ�X����t�2�R$g7�\�[�Gl�|�t�����)q�j�m������'�E�u;�~d�W͈?)-#Kj�`�R��u����j�Wx��k)�h����«��k�@���w�����ඥli���PT��ZCԗXp5a��r,مR��l��V�EܹA���j��(~o�~N~r�bM��u~J�YM��4�5��[�V|%�����D�ʉ����&�>���gG��~%��Χs�9ӵsq��s��\'���K.)���>��uRGk�VK��29��Yz�*�E"aMqXz�L]�gk]�..�K^q1_[�����ݼ�%��&7��_�?��ݷ|,2��d��*������q�ʽ�_C��u�;u]��D!?��0�D���5a��B���t#L:�_FX��jW&
��u-4uM�`~��5���B�u]�͔��k:�f��
��B���D�Y��c0Qh���L�5���B�|M�`���&V0QH���Lҍkb�$]��D!�_��6�E$�!V0Q�V���+�(b:�
&�ho�X�B��p�X�D!ݸ&V0Q��@a����B��<ߡH0Qh�Q��C�`��QȺC�`z�L��˸E��B�BW'����E:d&
I�ES��L�E2�&;0QhU^��(4�(��!;0�l�F�C�5��Rji�}���ph���ou�j��!̸q���e��S�O{������Z7��q��^��G�V��n9�m����2��6���ŜZ����aɡ�2Ao�țD����ʽ;�G��ħ;���VRU����:�ٱ�v����P�n��R���^��$������?>���7�߲����7l�x���6\`7q=�����hC����9.�!]S��4�9���d���!��5��ʭ�ʣS��D��}�|�%�F�����l�<��L�]*~�q���]���k�\��Ke�I���ͧ�0�����ޚy��qe�.޻T��i����+C>[x/ϐ��=-��������ެ��Á�ŕ-�?O�:U�g��X_Oc�_B���౲��Lޤ��L�����7�n��m���G���?��������I�1���/DZ��u\v�t[�w�V�>�i��u��o�AQ�W��"��~�{��{9��`�
��e�Z���#��/��t�j���/�p��[!��u?�rCw�`k��Sk��O1��2��_}KJ�+zoӒ�1�ʹ�>k�m�W(�{�H�RޏXՔ�ZdYV_/���g=��xړ���}j[�/�g��Q���G��	�#ߥ�w'bKk�j����)�/�~ڿa�R��;�gV!&wG�K[�����ҖZ�~_��-�B�p�p�?�}r�B���f�nWk��6ל�JlV�������e�A�W0:)��jq�7�-��o�/�4{�6-��[�������ټ��k�Ͻ�1:�)�n�S��'Fڶ�h��쑤�;��oɻwz��p�&~H}������g�p��m]����by��D~3���Ѽ����>��/���?�	yw�ߤz$=�ǎ�G���E�ik�mǙ�����+}ܽ~���D�{�kN�{���]���3ab+f��c�K�뛩�9H��r������z�-Wq�z���f�4���nȠ�ě:W��Y�?��mh�-ɖǣ�r����j�_��Ň�7:���	��v�~u15��~�v�z�ո�~{9��O���^�]y7����q�g|}����h�[�%_�7��9R7���Om~k|�;j[v7��
����cQR�S�������J:��ɬ���������s^ij��]�PH�vI�l�w���QS�<3�Jv��D�֐\�JB�xV��O�S�v` �|~u��t�B�c�U�a�#��
��a�j��R$�W >�
��ĳ�10H,[����Պ"HlL4:"�d~H�Z4:"�0�H���@*�?o�A���VA+�d ����)H|4�JH��@b�j�$��Vf��z���8`�oB+�r��@(��@���c �8���9`$\c:����.��c �&P�C�1>I����WQ9`��U��I}��-G��I���'�$���9`$�[��@BOE�1fE)�#1P�1F�5H+5k �i�f$����s�HlK�o�s��_U��O���Wq�5cJ���j�H�8��/N�"�0/N�\�0���5ku�U�s�H�Y��0�K��c �J�9`$'u�u�5���*��I
�]��]�ё��Q^�1�4,�0����s=������@�_Z�0ƺ���t�����0˖:�:���^g�1�9`$>�P�Q�1�X����s�H�C��9`$�!�?�0�7��Q��0�ŅA%��@��c}#ԧP[�T8`)0�7c��)��c��	c�:�G�U8`�0j%y��q��T8`� 5\(:��[�8`�җ�]u�c�з��[��.ߌ���No��\&�[���Np�Uٸ�5wyq,�u.���1p[@C���X��Bm&�
�5���֧$�b���H�V��ț��5�n:�=�ׯ�<p�[���z��q�,Ȝ4GP�dA�:dA&	�(~�,�D!��� j���&2��T�z���˺kf�|1Sک�o��I�̥�4�#�G�.Ld~�*4gҼ�x�t�!52O��hHr��堕qw�~�H�\7"%S+/_Y��(e�La]<\Ǜ_��0���Mb���>�mWaͭ����V�����z�$�א�.Qi��KT�(�`\��(d�	IL:,!��CHb��FMHb��	IL�fw�iL̕��H�� 9  M�5��O�!�(&
i�u�HSLC^�p�kH���ܛ(du��SLҎk����:�B]S�X�-�T���5$�k����r�D!�sM�b��&^S��(�Sה+&
I������GA���B5ׄ�P��j:d-&*@9vh^L�~���D1�ӡy�P(�סy1QH��i^L��P`�C�b�X��E�;4/&��ɐ��PаC�b�"�4�@�6��ƅ�����Z��¿Kc�М]Ę(4g,�uMc�=��5A��B��� �D�YFѷA���D5P������tc���0p��0­���#ߍ�
����܍J�B��Q��l:\"�\����ܟE����bj�n0���p~��gYb��}{�P䫖�-��]mA���g!���b�>6��ϯB����`�x��k��&cjK�P�n�ԲZR���[�I���m��@}��"�7����=��:Ϟ�L;���Q���}�vg���ﾀj%����@�L�F�ȷW>�:|B&���Z���]f�r;�~?;����A_����v%��[��������l�D|���N�Q��I<��m-�*���F�sVZ&�c�쳜�̩/V�����6�=�[��w�0�)�z��o���4��x��0e�����ߺ �G���U��X�;�*��"�� ~��O������E��>�T��gY](': Ӯ��g�mm�\��R��{Q=�8���韒�..%g?,�:������m�>�xd|�*�U��3��l��>�ǧ<�D�?�g�9×���g��Au������S�����Oh>K%5�۽���a'o�������C#�      i   �  x���]��6��5�b�@~��]�Ţ�Aw���^XhleƝې����Kٔ�!�؞�@��N�P�sH�G�y�=�N�w�~��ޚ���F0!�c�;��� �������w�9���n5�ݱ�1t`����0�y��`�_�+�ƺ?��7��@�כ#!�y����v�=�L����i���wT�zUDb��1!B�@�"��Yft������5���(�7�3�,X�fF��g"��(����@T�e3�l=�OHnVD�7Z9Q��YqO�q?�֧��fu�{C�kml]�!�X���3�m���w�㶓��f�>�۰m�@ �t,!F�x
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
-k6i��:�WR$d��%,H�LXd�Y�y�� ��L0�kfrb����X�f��� g92O�yN�[��@ƪy�3��NC��E3���^�Ma��"n�m�HtO��.̄�Oi���}Z: ��������1�      k      x������ � �      �   J  x���Oo�6��;�B��p���nZ��� � �)
���/I)�hč�F�>��}��ҍ�C�L�O��Ԕ�yq´*�·��9ׄ��������0=�����_o(�������;�_UV��_y]y����/�pr<=w�|����������7u0�W�kb���ӌm5:�'̫�U���4T��2��q�Z[���6�\�O'vV����xO �FmM�W!O3J�6�r<�G�eºf^�ꉽ�c���VQ���������uc��|���d��/�z�g*1G<�7*}�(��K���RkI�/��ȧ �����Au"^+�ϩ?+1oȀ�h�T���iSb��&�����[��'�i��Z�G��j.��ȗ��z0�%� �sQLsߪ��{2J� ������V��
6e��K�F�o"�
;lQ�JmQ���h��*�2��CM\A���[��*7Pm�)�Q��5��{���iQ���B8�#��,mr�o[�D>�.��\�Qiu��Ѷ ��$J��LOݲ�a- y�͸�`�<���<.{��0G3J�& �����n�8�]	Dȑ/r��x6�%Bz���;u%�wB �yq$�9��I$�[�y>��S�Rj��ݡ���P��Hz��ѳ�������/��}�~�~}������Ӈ�??>MϏO�o'�I��\|ԯ#T���)`����Yw��H��%:�V	�^u�n@һ$�R�@�y��x���l���U�fG����~!-�J�ڗ������Zݫ�K�*AWpr�I/��r��&b�.��/��x�e��M���d��K:�sG�&��>��7��C�%h��ő8'��۲y�{�Ĝ	�i�9�w�z��F3JЙ�WH��H��T��}�<���oX�e��&?��x�}���΋�oWn@ͷ%6�
��
�ˡ8_��Ƀ�m���dq8\(x��ؕ'�����,�>
R�gsZ��c��1M��:��{$&^�\{Ը���k/u]�3J����y���.ƌ3ƠGs�޹�*ܯ��{1v4�}	�:r����˕W�_��§7 ��r��      �   <
  x���[��8���U�d��ŋh�ü4�/��M�$�e�O��QT� 	+�g]H��\6�����˚��?6���h�����1�8�t��?�~K�����_Ɔ_�m�r~�������l�~�ꗩ�C��0�P�c7���e!  ���-ԏ���f�'��~� g�o��S��u�_������m�3��?�O�XsD��y��vk(v�;��e �@����"��EA��(@Z��Sf�׺N i�=� 2P�=��:'��-��,p���������bAy>\>N��c�a�q>��	�� ��q
�3��Ώ�{"�-c��8- ��J�e��0i�I3��=ׯ�a�"������M��Z$P�ݳ;�n�q��mҾ���"A��@\twk6��,�Ɲm�Ͳ��.���E��%jNteyf%�C��Cr���k�|aK����d�w?�6�ð��X���6JDJ��=(2��5�2�$������mlt� �\6n+�R��Xe���m)œ >�����{�:C���"����^Wxâ"$$��®d ���.mB�&X��J�b�l
��a�a��˺߬�w ?�� >+/j ���ϏqI��{�h>��PUP�m��w$b Y|��01m$��W�{�_�2����x�ت�k�닒��}����2*�u������k?_�����d!ttj� 
���b��Zv[�.^��2�"��BB%���(�w��A�. �X$@�#Y��k���}��L�ޢ+��E�Zn�	I��z�DĴ���_����"A���m̪�+���n��'��{Z�h0�uK4��%�Y>`p�����؁[�2��|�"Bsk�^)�8���m��5�ov�"��
��H}$�#�"�v'��%?�Q��)�Jރ��)k�ʳ3�|%2��=f��.A���bc#��E�Z��
���R�"���T�T�ٞ��)exp�i�H��[�k��������C�Hwh�
�~ 	��F��v��P�b7��A����o�W��w��a�����e��c��]!� X�_����!�ȱ�"��U�|�U�XB
�*}VB��T�OJ.W�R��'O- 7@F K)5��O0�2}S#z�ӈE�7M��~�qRV�Ĵ&[v#B�+#��&	/�#����#<m���ݑ�/�ǻ#B�V鳻#1/��wG�R}�h�rӥ����z�w���ۣ�;Z�����e�*`�I�_�i��[��ܸ/.�ؑZ�L56}ɍ��}�/�q��K�����'���G7�DQ?��*j�Ʒ� B7�
�37�qa��������bb���+��i|S�g��]�Ӓ�'���a}K-3���Bk��?�a����>�2ߓ���
��<Ŷ�]�,l	sw1����=�֐3E^9Řۋ����ݞo����mqY:UX=D,3}vu�-$O�Tt�O��)W3�a�@����?]�Q�xF�9l}�a��\�ݪ�T&3,3}�������������k_��0u�"8��|��|[Q���x�$��v��X$����O�u��rQ�'��!�V���2�'�tr�i�)��xe��"�n٦_A_� P�{:���تQ�,�$�m'��Ö�Z���������U��6�H(�P��p���.=ˌ@�.ݹ&��F��gM 	� !���P?�>?���o�5/ԯ�?|�j����ӝ3�d��O�$��F\;�*�qb�V���+�H�� <ʪ�=��I�P��§ҏ��YlU��/���pZ$Bn�e��gLy!&I?힞y�I�ҷL?�;�*�Z����e2�"��ӣ�r��[������ ��ɋ��|�T8��I�6���d���� ��ӯ���X�pq��	��(��ӷ�ς�N߁�t5�ҩ���E ��5�:����O	���p�E"���z��u�K��+��"ZLN=��T�Q�S!j��gl ;|��|~����+>?w�~0�ϲ:�>q�0�@�ķ�� �H��d���ڂq�=��]/�+&����M<�>��Y��ҏ1��2;m�	�
r��&U�N?���}q����W���$k@��H�X�ҷ�.�����S�Dh59̸�ZX�T/�ƣQm�R���H�V"�C7�C��G)�J ����:z��sjIrq�\C@�K�E��_��B]{�x���x/�Dȍ@\��>�or�<���"�ZJ^��H<�S��Vl�~��B�
� �iAzɱ�Xf��Ɯ�*��F"/կ��cm\�;���J߲��;;�^�{��"����{�崊�n-����Rˌ���.ug��ݤ��Am$BU1^��_�A?���@_��U�� v�A�_���{�
޶���~��瞧�/�=�0[o>��E"�F �]�1O�C�����Dj5<y��"}��T$��`���3Py���	F,3T T�@W*�Ț�Z�]H ����@[�Wq�~��மү����5�Հ����`��wR�D����.�qq��o��3�Z$Rh$$�ۢ����� �u�|�
f��2�O�AlG\��Q�g9��i�3��j�Pq��?���x���      m   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      n   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      p      x������ � �      r   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      t   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      v      x��\k�,���]g��;���Qk���c�$(K��t���P�	��T<�Oȟ�	�����������k��1�ɰqP�'eJݿ�*5j�(����a��T(���a�^�5m�D�J�;��{Pj���0P�'%J�ߴ3���4�T[2�Rϱ��NS�kH1P�'�i*�$��$>M�w+{x�d>O�7$���W�mN��`��'S���7�Sl��'S�ϡ��a�ʈs���a���{��L����\؝R�7�kX�^��)�~��^�O��Zܷ6�_��1M��k���ba��o�|1ߪ�?�H���T#>)��n�cVm"�)t��ۿa��4�S�S\�e��������u>�6s.�0P�aK�n�%�)V�6s�h���ĵ�sl�a��^/i1���*m��z@1��8��:�z^��n˰	aN;��ݦxP�v��sl�a�ru���6��:u��)n�u��?����}y��0�z�P�v[�رg]���_�׆Uφ���b�b{udC�t��f[�XV�hX��c��pk�11�R�h��bMC�����-/100�)@��V7���:�8��l��l0ja;�5��zQ�O����܀���7����_U����)>"h=�%6X��3���Kj�R:M!��0Pw�[{3g��U�?��֬|�p�@�Ŗ�Mg`��3�f�}k��nc�|������baxo]���8��\�궬��0�>��v`�9�K���f�."\�ϫ�9�K��z�wuq�t���j6���̹��էQ�a9nV��<n�;���{��|lٛ�^��"f8�%,���<˕n`����A���=�a��O��6���ylp��|`��{YkV���p5�"vkZ�ugɅ��mt�0Muuv>Oq�K�nO����ʺ:�U�p�|��B���OT&s���X��t�Yr#n�Y�t��3#��ȩ���7�RG8�.�Yu�nu*ͤ�fe�%U��y�c��|�͜)�:_sX遁�N������cF0��Қ�%�50Pw�8���R3�^B�KC��n�\��-N�jx��[Ϥ�x�0P��C����9<�syoj:-��גo:���<6���)N�R}��6�1��E��%>֣ΰG�}�u��a�{�_�:-�Ɯ��NK���~5�S0��8��yHfp_ڰj�״�8Ňk��z���޽V�;c.�k+w�V�S���cISL��jȰ���@�d͖�����d����c�ϯ5+C�]%=c��a����U�*9\cм�|U�#-u����Hp	qd�{� "Iqd����)Z\�jm��*��DD�����V/�׆�*���늆�*��c�5j�GjX沴��*�����e�z�����U�2Te�-�YM�0�:�p����^b�k��8Ұ���$�U1��ҩ�b侶�t:e���Nlkz����5� @������@�Fq�i:�4]h����!qM��T�)M��-W�0P��v-�r����N*�6�2պ��a��c�ѕS{��ʈk;���nS1�*j��S4�:b*���k`V�L��ؖ�ؖ�Xr���iR���%h)ARXܗL�� �׃���m�̅�չ\�y$+���ǳaиO�w��>�]��w�����w��a����r�E~�G��}E(P��j�IjW��m�j��t*��6�!RM2�R����$1W��00(:�;��*���$|����`J�K���)�W[��
[=�$Gp�xbf&x�G�>Ef����RE30�J�X���A[Qɵ&Tj~hA���z�w���0I�aө�����]yq���aJ�o��kʯ�����a������z��}#��Ԭ3Rҕ�ޫ[/�m�?��(�@��J�[�0��R�K�=G�mq�T���p�S)?�^1�,<Z������p��D肑ˡo=S5�f^Ю�.�������CD��!5�6���iJ�T6�t����E��1�z(�)y6��<��f��R�^�0P�8oj3��7TU�v2��5�C�Z��ꩌ��!�A�����ͻD�@�Ek����0Pi�Zo�tj� �B��Er`�`X)���=T:��f�6���Y��ֻ��O4챰��L1r ���r��̫2�W�Q.�r5��0:"������Wm�'��	m��J�W��ne�Z>;���׌�w���FD���H�Kh�:�a��2��A�WN�z��j��3.�b�[�^x<{�>]�}Hk��:d�,�fLRc������00E ޔ1gS�.�30�e����Ie��phe'��n�놬��P�0(W�b��h�|1O���ic$��5��Բ�K�3k�u�m5�{H"ׄ�5/f2���H\�f`�Ue�k��2���*�5�00HO�[k������c�Od�|��W8�ǀ���Ɉs�,��Y�t/켓	uo-M�R�[K�IE�{'�׃C���Qc�����x��������-�s�U0���u�*�py�G�[woN�AfP3�I<�9p�q�� �Ҏ�ϓ�g���]���\�D��9 S�=��C~����K��k�70(OR�|�ac�Y6�i{�AR������[�7m�DNd����+/�cRPz���O�YN"�`��<��ۚ�ĳUJ�y9&�r��u��UN7Ԭz���L�@�Մ��W�vK?�H��O�����m����0چ��ȂW��<�q���0\��_���65=D6*F�f��o���J�`J�+��3�w�L���00�|���6���.sy ��d�a�R�X�A ��Ӊ\��a���e�.5��\?jxS���g����z��WX{g�\Bb��u�!�,�a��9�)G�]:�s�f���0�"�R[��a�ԃ����i���`m�{-�^e��=�rߺ���>\�/�.�<�ǒ�*������fy�u����愓���~�_��*�ARq�'�a��=P�Ŝ�y�w(��r���R�vMu:�a��ŕ�����\$�c$�b7�GBC�lٍ8��($�9�Dᆁ*�e�F,�ވ�Gm;��K9�5�#�հ��#LZ��{<�^�|��0P�~"��Գ��,��m[��l��eMu*~���IݕDG�${^���	(�l�ՙ��(N
���0��#frj.&��10��A\�0�Z���fnu{TD}��d8j�b.Dh(ݜP��{-dqJ_�r�x�R:�z��Qt�jS����w��7�A�!�M���0�F>B�Bf�Oü��GHRș��;�?�_:T��oH��JwMa��v��?��p)5�){%��=y�qY��=��Ǹmc��5P�d��]�mV6T.5X3��ˎ�I=�#-���{<����d?5�J�:|}�a`
�������TB��K������43�J�Y\ҍ�O.��ۨ@1P��Z3�;�*�A��\h��E潱��>�s��o��
nӽ&�kz�e�˕���L����3fZ=���Y3�W�s�L������`�����<%3�-�	�yI�7���~X�&��qb��o�[�N�5p���C+�nY�.��_.��zښ�1P�:|�?���G-�7D>z�B�í��}��@�n�I7�r+���ʍ=VU9��3\��4GnGxoF�C��W�퇻�I1���%l0�`��ß���%ӏv��f��uMs��H���<$������S0O:�%�~�����1�^k���U�GZ��>�6Ԩ��C�@M�ݽ��@͚��Z���v��N��:�v�ZV���GA�WN~�ꩩn�ꥨџ��=Lb�\?���0�iN�|�O(wz�PԨ��z�j��y�xa�fE-8_�ES����@]S�ى⅁�*��sza���:=������އ�$6�M�_��q�U�0�����9��3	����00�d��/�"�i�$���%�R��䎸�����/�S2���^���h��%��∛�*���?����    ���RGA      w   �  x����q� E��*��f$�0��T���ȅu6�Z�?�#	�,�I�23oR���<5=X�>�y*.m����,{N.LM��4l�8�͆$��fW�@-��ѯ�]�ڨ��-S�}K���9���l�6�|���l��H��q5�ܻ{d,_� �V�7��!�N�����O�8���F�5��@����g	}'��\I��|EC&��!�$��s�{$���ƥ�5��!���K[�{Gm&�R����te��C �W���u�7�R�u�4�}���m3ڔZ]e<�W�@�����!P�U�X9��Хk�V�!���,*.Md@�ϰ>4�����|:qɰ�C��/Y���wHZ^F^f�����Nqź�u��?���!�N�鬎��u���&���a��ګUr�k����	�`��n��_���N�?D]��ҙ~
�	����ID?Vw      x   ~  x�}�Qr�0D�3���%�e�e����8�Dg����.@��XD>�>�h�*�%�S��>��L^R��
e.P#�kH��FzR	����A�T�{H�\�N"С�2y]$g��R��W�|KM�ϓ#�u��j�<���C.��g�#.v�6�S�ϳ5?q����>o�y�ϳ���R�&�+A����j���&���1J*�d��ϧ1�H�a��)
������=�����֓�T� `��GI&����I�4����h�M�������e��.��I��r�FK!M���+�����nL��`�X�ii>76R�!�+҄�$�6������T��8s�[M�CH,�֡v�5�R0�D�����I�n5���B�|�F���N��q_ ���Y=�C0L;���!�V�k���d�XHdŰ���'�`D`�X;�[�O��z9V7ֽ��  !�1����ȱ6ɕ�ne!�5��k�qA�(�M���D�7��a2$Mn7�K ,����`�K���r�#�B���(,$�/�`�VVi#,<(=%_t���\ ��ԡE�d���p�_��Kn��}D{��:�y!��؈�������V����Ν��v�hD`S�I���C���Ӹ��� Hu�ƭ5nA����7sA��8��jX��w3R�h�����N��ָ��ܘ��f�zik�����=�ƃx8�ǚ��N���%�r8|^(��y8���fȁ%}��n�m#�O)�J������6�`*��AШ��9�� 8��٭�A_^��Sb9����{�)���vV����,��҃��qA*�d�Љ�Z��><T �p��hj�+���J���K����s�u��:p��4?R����"�wE�Ւzɗ��|(z0$�<���T�i܎�f)uke�Ft+�a�񫅇�HH�cM��F�(����?���e���ą�SA�i�$�9�n�F#�X/��}�� H��4�Tiyw��:(�V�n��NI��vK�w��ޓA�*��%p3X�xR��am���������u�b��w��_ut}�޽WA{
��������vWA��F-G���!de�T�{��G�K�E��]ce�����z��9t�      y   0  x�u�ۑ#!E��(��l!	�G,�{�ٙqsU��:FhI[Oړ$�j_پ$�$�|�Z8�tH��)ʩk�F�1�h�^�s���E���4�֍ipzi������_���m�SR����f�9u�����8�f�&T��Z�$dp
�����)��k}�6�q�M��3�M���Ғ����fN��p4l�ʩk��ƹܛB�VQ���`s�J5�r���[��)4@�$��&y-0��[�f�N�Ca�pj��ߩk�6
�g�=���{j���s��7 ��&I��[+T��C�Z曤OSN�IZm�< u�=��[Q��rѭ�`��e[����������y������ZV����֛�
�p���xS�hA@�E8�����<�ҦЂ�3�}��M/㋍�F�߼�R�b{���,
�E�����>��{��GG0\�:��E��_R��gD�e��Z�rs�ڱ���q�ڱn;���R%DI�i��>���+��JFs�hۜ����WmQ�I#�}�_ԟ���v(��1��&˜b+ϴ��KP0�38E����;���%���纮6��      z   S  x�}���!�K����$v� ������6�+f�î�W�>�KE�%���S}�1E3Vt4�X���p�Ռ���Q�u�w�Ǳ'c�3�S���a�r���t�k�)=cp�;�8
g����N_���%��bU���1�̹��{VL�M5q��y��~��tT�=�Mq�{v�a�u�gv�a��v�g��R�MA��a�l��џ`�[�'=��S��~ɾ�`phd�18,��y��w�1g1����I��������ނ!;�>��{�f����-�>8�=�u]s�w��u08�}�aIr-ȵ���܏�-�.��H�g|���Ot�����o)�q�JY      {   -  x���ё)D��(���@��E�����`$��zE/�R��j�ϕ���ߋ"埑~��#őڠv%��~ݮ�҈Z7i��\]!����iH��C�c	��M%S��N����YI'鮇 �6�Ф���+-iT�IC��_o)��?R��gw�yP֟Eh�t�����X��i�~aH��B�!E�PF��W:iH��$���J��jv��G�f���o�s���ߍ�bZ$�s_Δ}�[���5S2�L�G*#Ӡ��,�fW�Qo-e�=W�eO��B��X� �p���2��ۧ[=���2�S��҂����"Jte?Jɖ��)��)�T�Y�b��ׂT*Z�{m\����
9a9�HC���nU(��y�e��ݩP(��Cc+��V2���Ep��9��δQT���U�Rr|U��QUZ��Fq����k�n�K���+W��j��+y�4�hS40[us�H_�P��ec�8 �����$�o�O����Qu���lb�[���tj�H�d���N&�h�B7&�}ӳ������ǅb��XǈĽ>.G)]� E,��2)'?�8�Uc��ˤ�1���ȃ�`�h�B�t���:��1��Q$����2N��R(&=8Z���ͥPH��GӍ�o��"����d}ʄB�m�J@�h��/6���4��ݓ-((�IlF�q֪{�PH���ױcV�h���(p5HIK�BZN�|��B�n���u�a(�By'���L�x�}��Pl�_e߻�B�(��������Q(����Z�h�d%>w=�	N}=1���q�+�\*ʖ���]�;�;��!z�o�ŗ�:�A0K�(.�ݱ3�>��d��n��e�*�ܢUun#��v����ܽv'�s-4P>�,Õ��m�4I�;�P��j�M�q��Ƿ�y�l�r��߲LS���u�
�|<L��Ȥ��H��*B��m%�i1ީ��|����p1����ӏa�&��C�JҖ@("{HȦ��P\*1��J���Ы�\��C$4�vz�yL���vj�������R(��{�y��ƣS�r�Y�f��#4xW���G�)�m�g�Ti+f��?}h���%�����4BaΆ��h=e~��W�b�Z�h�y�r2�}�S��ɠn��L�ߧ���aY(f�Gۓ���F׼LWe=1�z�7�U�k�Z�����^mU(,���i����B��ge���P(��ҳi��Q(|�}�=��(��R��OJ��o����^����F����qh){�\�wK�tK��[/���$�-%n|��=[��(���F"^K|��l4��'��7��-      �      x������ � �      |      x��]]��:�}��<�z�:�b��$TB��4�n���H�6=��i�m /��R�
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
c����s�G����]�}'�-V�g�T����Hfmru��-7��<X]���Ep�ck�g��1��ǽXn�l�a�:K'|��q/ZN�>�UY��8_�?������p�      ~   �  x��Zkn�:��YE7�ʀ_�"�
���q1x�$��'�T��3����}��> ��	iK�A��zd<�c���Ef�����z"e�\l��TY�~/f�2�;�2d��z�����9"�"�H1痱!�\�v �c,Brt�g�G2�.���X�M�1���rݽUJ:p�FǆH�F$�Z�1������;ƫ�3o'��O�����嚱��ghbZh�%���� ����.;}�@;R�e�*�����Q��3�~⃊��jf=�]e���dr����q�zY�O�䎱Ⱦ���5)�.pw\��� k�ߞ`�H�'X#��A+�I*w'0����:��R�5��`, ������)�D���T��U"D��T/�'[cD��Q7�Q���nP�:(�k�� J�
%�%z��h,���X��T��ԢV�Q%�h4����Q+����ܢ�ܢ�ܢ~Т~Т~У;�Q3�h4��`϶=5�@N�e�]���g�yf:p���ni.��L�t�*�sC-[�ug��E$��z��d�^e�j�]i�U ?sp+>��C�=Z � ���p��4�.9g�=��lo��"kh�"J?F��M�ht��Y����e�&��Y����Qlv�i�PC�|6:c�/��:�:��VΨ���V�:/�+Ţ~,(��w@qӺj��(��i��
d�9j��џ�����ƣ��xՉ\%�Mܓs<T���S^�b�M(�$�
�2�`��H�%kO�Ȉ�Ud��l�CoM1��<���p�h��X"Z����2��晬�	��^�4O4�Z�<E8����Y�Y�̜-�X�ԑ5��Ӂ�ֈ�0�O5�lG6��	8���R%(k��y
H�aM���\���gK�'i���/��c�\E��蹨��|K�����p51��Fu��j^�y�:TK2���`g�K.;}��n�X�9O��4��2R��rd�Z֒��Sɘ�Y��hOڣ���E���`�Q�S����1��)؋`
[!����f������F!k�r`��1�bsn��ݩ��E��qy�R}�h\A��4h�]�[�޹S@j��nY�A����SZ�yr��Dy0�Q�Ա��~��5�ڤ��� /%30Jn"E�d�A��Ȼ�(��9�"��������&�o�0G��0�a�j^ʭ��ч"�+�Gx���e//��w� T�g}J�=܈�E\E���x|[D�V N�^��K
�n������;r"@�lt��Zq�&9�i�@j�����w_��9/�Lϥ����j�ᛜv_�+6��KI�,�)7ܞ}�/�C����yC�Z*�^>�}I��+10�	G_��w�����$ZP� X�u��fyX-�6^�*$v}z{B��Nw-Da�1e�!�*����t�����:мk隦ig�鋺m�F�����������Mjt�:O�D&��	t)�����k3�G��'
'٧�p����z"��k�-Ms	���W����'�����!犺i���y�n���z��T�(��l��[� ˥�l9���qy�L3L��U����י���-9&�HO�;��-:�d��O�8�IhY�Y���3��u��a�a-��(
c�9��WG��S�Hz���x w��g����W�wk/:ɬSv}�M�n��{��gl��W���E��y��������~����x���         <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
c      �   �   x���1�@��7�i��ݍ��ĕ��D���/�#1��}/iN}�fg�mzvu;�#�,��8Vr*!˅����	�g�6�W���n��zo�7�����-�1�0Y:%�6��F^��q�܈��4T
e�2���U��o�/>;      �   �  x�}�]��(��˧��a�����ϱ)ٔ������od�2��>�~�������Y˹��ϿL�F�@>(��m�sO������[������[�A ��q�Y3T�F�Hv����<�����C�g&�d�6�,� *oi�?%y�q�D�A��7o'�.*��qg�'��@�h�t�ć� $��)��2D%>��;!Tqĕg93Y�� !�ˋ�� :y*�[�� �1hޚ����TPd�&� 1/9D�AdBT�=!TQ>��`��&� %^�W&����O�2�DSb>Tш�A�� H��N��d$�0e�zL��:�H�G2U��
�D��d��	Q������ ��(ge>TQ�^	�A�A�=&�M�b��TX<T�b.|��ګ�V*�A���*�]�A�:��u8�Ad�T�4�s5�uT]���� H��T9Q�8��Ƴ�Y��v��At���v�ARh,*oIHo����R�ܟ8�O%&� ��f�T&�(�`J�Mq��\'Ar��Bw�d��`N�Jv&�W&�H�@���0�(�X/1��J{�� �@��ATJ$�W&�8(Q�\b22-Ն��*���G�>���|�l���9�^�5��u��S{��z� |�/S�SQ�^�&�)��1WS:���)���e*>S�c��_�]�G]G���	Q��>e���C�-5s5�i���2_�)dɔA���8�ON��#�>S!d�-�@NDu����5e,�=v�)�h�TSӈowS�)�v� ��	^�!L�R�)N�)� 1O(�Ad���	?!����SA�&�#_>*�!$&����;\�U����$�	��|���v5	��\d1��L��`1�TbO5X�k|��2R�0Q��Q�;��:_y���eW�&�n��<W�ř2��"a2��
�t����Q�_�u8�A�xd~r�"��Jq�2��f�����d�a�O���"��9�_M�A֑i���Oȗ)ܡN�9�§��Wj��M�r���L,wM�b^y^U�+��%xUd{�2�B�F�A�A�K4�:7D%>:��&�8��~
[�� '��%9�x��)�`���`� ��e
�SA���P�ΐ�\�&2����GIt�3�����A�������-�����&����2�L4��^䒼2�p0ѕ[ya�x�<e,���NS�C�2A��+,���*oYX+}+2�`
�SA��қ��x��G�q�]�Z�s�A4��=ޑM��~�DE&�[�%軁�[�80��:��A�%�ƏΨ��D���E���� �'��0�ۏG!�����ATB����A��?D#D����[v7,��&��^D"D��#��>�2vߞ��e��dB�B�S�;�GQ	�|/yd�G�i�!����<2�NV>x<��A|?�>��ב�y�� !��[��:R���#�(q�e=��-�����ATB���Gq���p� !��|�X��s�ABA���G�s-����]M[z�E/Y@tJ��w_�h��&��Uڵ�J_f��vjm��u$�Y�Kd=�
��@T��WO4���KF�awY����0�k���tO4��71�j�F��W_��u[��AtBw~�d�U����*���%o����_��o�5�}��=�,�E$Dp}�Q�����A,�$����Ȓ�/�r����%R n�{e�xO2�uQ��e���%�ޅ�.���ǡ�ȝ��w��qP��%����b}��%�_�N|����EX^J��~��˫c9�_D��32%
[��PD�u����@����H���0��=DPt��'�sک1
�xh�\^�ġ��������N]��oY�K�L,��ђ3!tl q�2Y��8�_�,�jsw�^b��s�|�Js��+�D�c�/���,I����M$�}I��i`�IOLvkP�)2|w�%7quj�N�!i���WM%�n]��/Q��
F�H��"!K0�E�/�6$�xb=9�7���U	��_�ez��"�H�X;�� 2%��Xd�c�u��[_�ش�b�>�R��B(�>D%�ZQ���oB��u�ϞJl"Á}���"��h��� %vB}���?۶���Nk      �   �   x����� ���)����8�.̈́,K���1����k��问�����(Y�������c�t恣I0�f��8C@Ղ�7�(
q6������qEr��jM��&��z��Е`�<��㖄�r{�k��� D��y��"r��D�E�U�c9����i0�@TZe���/�sU�      �   �   x����
� E��W�ʌ�sא>M(�nK骋����@,���l��p���$��P�*�i��J��~<�HC���%L|�����C���<�]�d=՞��љ�S`��i|�),i�oM������כO��c��x����1�]di�h[J�$]*�V+��i��X�Q��v�)��2�f�ΚW�� M^c�      �   p   x�m�K
�0D��)t���;ǘ�BMȧ�����,+	�y�7ǟ(z�j��5 �A�Vޡ�'M[a�8���*\y	1����l{ `8�m5��N������>_p������3�N'      �   v   x�m�;�@D��S�F�@H�Vi@KB�?Aۤ��4c[���Y�fs�,EN�*h�Ӵ����yG��yZ��In�z�V�&~uh�ӐZ�F}��W��
M����{B8 U$�      �      x������ � �      �      x������ � �      �   V  x�=�[��(�;3ǒx�e����"��Q���N��x���g�n�C{���6h��hmk�o�fu[݌�W�+��J|%�_���W��6�&�D[hm�-�����B[�͋��ڸ�<<���@;�U�;w���&����-����������=0u�Sƌ1A�ü0-�
�0%���}���������6ތ����f���o=�F/Mw��������a��.��{6�ݴ�Z�l����l;M��>W��z)_ꖺ�@K�V��o���;��������������������������������K|S������iw�~G�z��pa<�]إ]��i��ݱ�K�%�z	�L��$�q���E�/�K����	�A$Bq�c��ڠ%(���`�?�,�GK<\�/�{���)�������9{۠MڢeB�	�&��l����m���/�Jԕl+�Vҭ�[ɷp%�Jĕ�+!WR��\ɹt%�Jԕ�+aWҮ�]ɻx%�J䕴+qW��r&˩,粜�r6��|���&O5[��R͖j�T�����ۼ��6�6���~��nt�v�����m�x&m?�����բ�G-Oc��bBL�5��A�eb�[�LZ�Ll&6ӧX��1������by�L<����$d��X�����χ6hQ��;$C��;$C.��B��.����R$k�,FT�j�
�2����H�#/���C�L�3�ϔ>S�L�3��;S�L	3%�tq����k� ��O��>R��<�<�<g<G-'|���CI8�9����!���ܣ�˻�۝��
(8A�l+`"H\�q%߷d*/S��'h'-�"E�VZ,	�"p��\���:� }t�!QĢ�TN8e���d�������$�'�A�/J~R��vt{�|������.���by���u���3V�P������+�a7�ݶ;vz	��^B/��P�B]�KGHGHM��H-S�r�r�r�r��K�+���R>��C�P7}(ʇ�|*���N�.f���r��٤��u�4\�pQc)_ʗ�|)�ʷ�|+�ʷ�|+�ʏ��(
�(�r�)��8ʏr�+��0��
�(������t ���_)�t3gi���_�����9�q��Ygi�e�%��Ό�4�Ҩ��K*7��X*vy��r������K���N8�7��w�c	��s��Q��T�������Ա�
��0��yL�:�{M�a��u�錧a��uJi(����2QiD��FTQi,���A���+��E���N+W�\�r5��(W�tV.J���{P��<�� �w���:P���sRN��8��ɱ���l/d��d�rA|�D�ܻ��I-�Nz��l���+��%�P �?�'����}�O��=�'����yO��;q'턝�u�N��91'��{�M9'検��q"N�	8�&ޤ�p�m�M�	6�&֤�P�i"M�	4y&Τ�0�e�A�bM�	5�&�$�@�g�L�	32��O�D`�5�&�d�H�hM��3i&�d�(�d�L��1)&���E	")��4o3q#��K݆�̽�[��[��[��A�/�xo"f�,�%�䕸�V�JV�*IE~��Afd�Afd�Afd�Afd�Afd�Afd�Afd�Afd�Afd�! �x���Q6�F�(��|>��|>��EED&�Dd�h��+:Z�*�X��V��ٟ��ܩe�kB�	����:� ��
?cO��h	-�����`�KV�C�c�!��]��|Q�M!�3�<��wv�B����a25��߶����Y�0�fQ�,j�E���7<�g����y�3ox�ϼ�6̢�Y�0��,��E��HZIK#im�;��3�4E�_�͕��E���su΢�Y�9�:gQ�,�E���su΢�c��%+�ՆQHH	� !�$$��d��LnJ�+N��4zg,*0�����&����S�ϻz�R���`�rI,I%�$�D�DH�HqU�j��]#��5n[�pa��F���F啔��_{�EęY���6ރ�f�w�E(�Z]��jm�Ҫ�U��U-�ZU��jMՒ�U��S-�ZM��j-�R��T��Q-�ZE��j��T7��Sw��S���N-�����Z>�zj��ک�S+�N��Z6�jjє����������Я�      �   �   x���A
� ���x�\�23	��P&�m\�#x��.
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x����j�@ ���S��gǒ���`
��@ P��PCpA�y�N�T�l��:��;?��a�������}xȻ��%`x�>F暨f�S��ը��9�����9l��9��-��-Fj��"N�J�k�a}|�u�簾���M,I�c.�9nF�ZO�?�^�����.[Ƽl��E`���܅��G�����w��0))���� �}�r��|!�w�wD.J�}E�Q���\
j0�N/a��a�,�M��`em����"��o�l�vn,C���
(΍��47V!�T%e8{����M�Tt���7���/&-�-��oW�����F@�q�s��Ko{3�7�*R0�7�_����Ui�U�}��5���D�ȑ�U�S�I'5a�]"��h�;��^��W�F�m��`��uìY�,��;�v��2���-�2/V��e�Ef�s#���W�&��j ���F9Z��"��
 � �'R(      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      �      x���ˮ-�������j@�Z]�ðQ��7��0l�@]�ߤb���Ę�6re~#B�(^~���o�������߿Z���O�O�����o����?M��}��_����?�����G�? }�?���.�?��������������1�cI��e�=ZF�@?���_�S��?���sA�ZПZ?P��������_�������������뿾��O���#b���b�h���*T�Q�i���h��>����h)�b��G�{�f[������]r����?�7�������U�ı��?��������G�7{��~����՞bǃ_����Tmc�x��xX�t����_9�A-{��_@�SЖ�����;��Y�&�O-o��=@w@�(����+�!�U�QB跑�}��W�TnE�/�������*�)����FR���?�ގT��/��FW��  ���7���­�_l{0��B���?�)<	�O��`W(�p�by���g՞����ɟdi*a�5�׉��#��mƿ[��<����v�;��%�:}���Oo��_HM!������J��	��J�7 �!������$�C�(�V͸��P:�/0��As��Ä���yN����/W_'����b�I�-��jv�H��;-�
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
A�T��V�n�8w�̆`�8����4v�&�^�����uV��reJ8��� J�|���{�]�Gh<���~KA���F�僊��Δ��,}9������poR�%�N���4;v��4{q!����\:�N�x��o�-���9����f!q{��w.2���Z%{�`��?5G���vJ���C騇4�;b�Nv�����7C�Q�� ����t�&K��!�kϵ)�?j]~�%$q���1�l�R���1T�>ˣ�Z�9\}���'�/Y�#e |o6]��T�~'�C�t�U6�|ѩt(�w�$+�G�����fs{�P.�b�m|JV	3���e�rE��?�)_��)���l:-_�rc_]�ʦ��r��%;�Bb����L���k����X��L�db^t�_�vg��@E_rMHg5�΃TqLL�qgӜ�����ͦQ��_ٙ�G��j��jg�0h����_�A��0��r��gh���ě��ڦ-��p�I�t����4��Ө�����t�3t�eZHBi���Z�=���:�����F��=�J>����#1t����o,�t=uT�q��\+��2ֹ	VJZk��-V�`��,�McԖ��f~�.�_� ځeoi�Is�����0��{f1��x�hLX>c�֐��?FC2�r�J�-H�L��j͖*��U���I�jUݦɽ� 3/�b���/[via5D�ռ'/��K�X���B�h��kL��m+6/X�ayf:Z�0��aX��{��8�"���j�A��b��3�ؖ8��tƴ���C��#�Y:o�xk�ML�e�1<z�~~��h�-L�+�YEL��<1a��;��ikZ��7f����K��T"s+����Ɗn�1��f���T��0��f���w�5��;\j��0����ѣ8��~��;��}�y^0����]��x����K� ��tyZ�L���Œ ����yw��	Vgt�^̕���ED�l)ieFD!�Ω�e�W��E�����|i_�ݹ���6J]�3��j���1/�@�V`*��o�}���68_�Ƽ3Eu6��P�;���&vt;vR��7��e�<l�}�'C��l ��my�`ƚ�y[�f�)W���z���3e��hB~���卢�c��?�����-ɨ��:l�c��uy���5H�`Z�ax~?Ζ�u2��Ӗf�֙��o�T�-�L���H+�*�FS�����ޗ��eQ@��^ޔw�hЊ��9 8�CG���6������
!��˾#Ƀy��R[L�D�^w�j�鵹�)ZQ�Y�@��N�m�t������Լ+/ �;�K�4���Ҙ+�aG��!�zM]���k1�~Ò�M@;��_v�)���iE�<��#?�;nT��y)��˕2#�f�����a�Wn�+W{yh���GnE,.�7r;��A}�6h8.OF��^���H��ˆъ�e4�6�1`��G9$�>c�7U��HD>���1�_�I]e�?��g#�a��'&�����-4��Q���1�Z��(8����I�k1
� 12�|C�(_�i��pp�̌ά #m��L*�aFu��-���}����y�~�'%/�(�8J���w�(���<bګ�3u���:���XF�Э����u�#gͣ�7���QS��Vco&l?��'6ւL'L'J�{�;�v�k�*��ˮ;�LAa��o��|�B�(u�J�掼��� 3��hP�����yϬ�y��/;W�<c�KT'[�e�iE�w^��\6�C@V_��F�ʫwA㹷KF.�L��V�v1�i��^r���A�o���3E'ø'����!e:��D7��	�b��vI����@�B&¯R���m�a�d�N�5�s��x�i���L��1��������s#��AM�Aq��7AvL����u�<�|l]����+�m��:��c�e��ɺ�-oӋ0T*��ʍ� �*X�8?���qkP�2�g0��?Wʌ0�9�Ծ���0����咎úcƪl���ln�t\��f�NJnc�(��/�Uw;]�q�X�ȑ[���_?g�%P�L�v�Gn�7e0�
S�������t�K��Q��|�7�iY�S-�Y��E�YkEWp�V�P�#5��d^�r�g
i�35�D���7J�kuC�!��7�E��ӷ��7o�Cܟ��{<��:�K6�H�����K6�D�?б���-� 2͹�Pr�LD�)��D�@�����0�Sa�����i�M$O���5����s}��.�8�~�[�o��=sI����tʎ�5<�����3fޒނ��
ޮ7����z�j�<�|ܑB��Tq�咎�|8\WmW�0��/F�H�4
���'yQ��V�s���e�m��P.�wl���-k��g�KdF��m�_��K.�2O��(y��NY��4��V��ٕ=R�����.�8ؿ�Am�����/ٸ#E0��n�l�C���u�Ώࣟ?!���қ��~ y*n�&Q����;/}k]qD��9$/�(�*���<�ݴ;k��[�#����?�}�G��7E%L�.�P[D��%U����0V$� mmh���N��Q�͹���l���ȃ��6��U����6��`�0;K1�VbFq�&풂��>��    Wkq��K.�h��^'#7~i�gQ�����1��p���]��Y/�=�;F�C�B�%�z>��:���~ͣ�Új������R�E`�8?��z �(�����<�����u�����PPu���p��A�aT?��H�����|8c��I�Kn>��YRN�����0�}.����<46�w^F����K��A�s�ص�y
����k/��U�k�c8�h�Uq����~aD�3���C�_�pezښs�Prx3�U�ɣ�/Y���>��W�ܟ��o����f].mq\7�~�Zw������-.���Q�R�D��V���\�ێ��`̵u2Y���;b�:�F�/Ƙ�c@ec�B�$\����l���r�Ȱa� ӫrsj[=�ˌ00�J3�V�4�5�ct>��]�A��2#�ִ�F��!̴cD��@��&��2#�Tp9������z�W6A=�ˌ(\�j/(�%Q�IS�o�a�_u��%�%`��_��n�,EvJȎi�Ƚ��0��ۆ�f�/=��^:z���KS\@���)욅���:c�cY�{�ܛ��c��t��Ӊɷp�aŊ[iF8$H�0mT�F}w�A~�0UU�=&oO0p~����6��6����+.���}�Z&J�1C�M4[dC���`P��pe��2Q���:�+�TK�	�eF�y!�(�V���,����qǰ�H0��7u��g�*�-1�_8형B��7���1�&�\���kGkž~0���v��>g��D�x
��-�2��N�N�o
VҲ����ez�ݴ�u�ڄ7���ֹ�ܑ���v/��w`x��$�t��e��JV����\��Ҿf����	���eA��b+<{>�.�h���v���n˨�{hm�i�|���#�t�V���������������gŨBu~bD�)*�۪��}� ���gw~bA�P����|Z�v-����{�f=���0�������ɟ/������_�/mq�x��k#��MV�_RqE�AMB�_�1#�4@�����e�@26�W�j�D���f���❗t\��n�]�E3��|�͞R�0&��cx�}
6�\�����\�kb]��Gh�]�)Yb��|�u�LC��v�~�;b�WP��&/m���:?n��.]qG�]L�e4�Ff�o��Y���@���%'`��%ΕMl�ޗ(��!��.I�#f�;�[%?�L/�IR�&岇���g�,�pi�04�uK�f�_���,*�ڪ��@.�a�#�{&�oX�$0�/�\-3�0/�`rxȎ�K\R�����0*�6�����/��fl��`�MP�%-w�h�*�=� o��Rv����	�ݗ��"u?����c����a�6�&�0����`RS�J�0uI�.D�6�.�0:�Fi��E��B�V{҇�;Fk4_܋�5�AA����҃���p�\h�ELvkYY�5��`Z��a��Ȗ�������:�Ğ6-��E����C�;<����U�2���?�\RsGJ}Uu��P.��~H����HL�I�r���)h���A�7e������bIj�ݩP��gRV7H'�[�HD@A4,%��(��b-�
>S4�6̛�y(b�'^�U�S̔a�#�L���(����$,�:PӸwOt1!N��lՔz�&��nM����j۫:���P��h���+�H%�R��9>1���\�L�0��.=qE��|(�Đ^-�o�;����N���Xj���溈�	/¥%.��uq�Q���M���Z�.:���g�6���yX~;�'�l�(�WG��aB�o�]��S(�5n+���sʼ��s�UD0��r��3u�1��
�<]R|M�ZZ�r?_ڒ·g�i6H�JK��!���5J!��z��t��ڛ�#�ԋt��3�!��j�����XXc1HKU�������:P� ��D�O�yf 3��w!>=���\Tj<�^Osuȗ�کڲn��|�^�Q�j[�
�փ�v&_:�:�e�6�����m%6���=�S�鿪��aR�'�f��p���#;�L�`mW��Νm
�$b�!����=;e)�7�Nq�K�䌙���]�S۝�,���M�TWܯ�7q���9��z�d�?�1�-�E��+�T��t �N}��|o��L���"
����U�@���%-E�Κ�.�<�i�%�D:S�*lu�a�Z:��;�Qo
�Kw�L�th��=Sd�/.P&ig�v�Օ]҃f�f&A>f�L�	�U��-iW5ٱ�>�ͭ��4��C��%>�d"U�0:D��sIfdCΘ���l�t@�L�0�b\�`�1���U�{?�i\N�3�<и�#��(�����k�W�N2���P��\��UV��rپ����)Nk�bAinК����A�Y�Ӌ�r�.�@��冂y
1�0�j�G0�ܯ��]f�FD1� F��C�M��;e�q#8��&��g�j-�a��0�GU6�{R�N}�YQ�3�g̴t}�Ťѿ#�a�1O F�6�6n~(i���)�Q�ZEl����G+��@�x=��F�[,*���L��a@�S3�U�k�v�����
�|M��a@��'�%�'�((R����H��l|'�5�Ot9�O��-df�.	��|h�(����Ė�%u`4�b��?��b���zl���Ϳ��_���jZ�֗�\V�Q�5ۢ���&��cV��J�ȼ�/�����\X�Z�1}�Q�_�� >b�b�%�c�
�JZk�󞾈B�خ�5"�J�(<�������æY��2�q3�si�3^�M�����P*�������_)r���wQ��J�p]걏�ћ"Z~i(���`���ۼQ������#Z�m)�|��2]5������������y75�1+d5ɺ����1�cp�z�Kz;;�h���Tidk��Q�f��4�Pi=�SW��6�a��G�w��A>�]!	��|g�6�Q%��� Z�e�H����|�h��m�ZB�~͚�%��}�Қ��kZy�)0��mD��F��#3]`���5Ym	k�90�M�ߤ~hJ:b)��b�T�y��Q4ȹtx�}�y_�R���RALN�^v�r�z��ܯ�wo�ё����|�v߂�P^���R�}wlV�`IW�}m@F�ߪs�(7�
SQ-�%OalG'�LkoW5�/�|)�*�5#-��J��oJ�eX�+�դ�v
�aX�w�庚f~����Y!W��3�L.�Q�C�t -q�G�Eg�jc��:>�e5��h7/��ne��뒏���7�
���t�s��.��#F��`sV�I����U��Jsxɿ1�ek�a8�u�0�+�G��%`�q�ԫ��X��*��2$̕5#
i��Rr�!�Ȩfj��/����W]Xb0z�xI��CL2/����M\��6K�ء�xI�1���9����1�h�����K�H�We-#5���~3ŗ��ʤ���D�Δ��Nb���ۭ���"��rq͈�Z6ev���7��!R��������t`��
��!���i�ំ��Fn����5�vڈ͊=h�h�c~a��軄�&�]�}u���*�z���=c�Xm�32�0�c��P��b��é��#ez�ص��`��[��ꋺ_��j�!ԩ�Z[Қ�.h�vy%���3�2���{��X��?|$��𴉍�֪�H��Fyk��34m��� 3
��
+����aP�E��'�_���Fx4{���˓�Ѥ��[�u%h��Ҽ)X�Ug�Sͭ߈"����%��-�*瘎�0�tɾ!�5tɾ�1/�n���w�h����>�Pyn��,$��dM�-�V���tI����e��+j�3T=�1�傚�8;q��Fˣ��ӗh�۾F/mr���o�-�Kh��,4��~{S`u�i������MQI_3ň�=�(��/��77����������NY�jBL��a��p7J��I�;�=�Vj���j�FV��b��dǨ=�V��� >b�	<z����Ͼ�}�����7�E�.�    U�VN���z�-����0�&>b�U������%�S�i�M�V'���,���x62�tI��y917�%���*����LC�L[����M�V;�c���wE+�e��P.ч3E��7M�K+�za�(�A���G���)s��DP�aR9X¶c���������`�h�F9�.�>ɾc@��y����o��ưk�#b_�^���)bʅ4#�LÚ��`���>f�̫&�D�\���=�F^7����2H��_����?�I3���
��Ľ�< ��c�"��B�e�tɽ�і����?&h+H���i\�K��Hi��s'̎�����)��w��xӥ�HA�^��P��(�
���%���yw
��h/�K�-����Lg�Rʬ")�[J���h�h8��C�ul/�oGʼhĔ��j~����:"G�/tF��-�lř2��{i}(�"�[��u-����}��醒��ezn�Ԟiك�zQ����_L�EM��bW7Oo���RP���.��D?�5�"��6����F[wF���#F^M���[r��g�تsk/y�#fL�`��L.`�qW��&�놲a�{D���K�d;8��3�5c�t��?�a.��ã�J�8��c4/�j������(0:�y������ �~e.�oe�2du���3;�h?i��A�e�[��v2��ѝP)�<�``���*?�a��E��}��O��<ӛҵ:�@��� ���	��h��*��֒�ZmM)��>c�r��$_�o;޳�Ċ��-���%���_��^ڜ"_�ߎT�R$��y�hè+Y_���0�i�G���ߜo�F��P�a�,��G-���T����wb�;��k�D0�<h6`�M����NN]�/-pf�V��/
�4vh����r�沋���zv9lG\v�j��ʥ:LnJ�A~�%k�i�T1�U֜�+��fwa��U:f��7�=|�L��P��lܞ�m�yw��صN�%P�2w_Rq� U��]3�C��k��2�pg25E|��(�B����~S���eI�}(OL�/�J�n�����MX��U:3�h��<1��(uz>b�;�MY�q�h�/y��Ҹ[	������zbjU��� ��q�v�O�`ux��I�l�д�����e0��������E���Φ��{�C��`��:���e�g�����Nxh�>��>S:��~��g�
������?[2oJ�xS#�eH�_#�ʫQQ�<�Pt��'��5)*eU�(�'�EU�`�.��K���y֘ ؓ���Pz6Ch��������C&;@�/mo�;���"Z���G��:4��5cn�;_oFEG�M�y�Y�T�s�0߽�ҷ��7G�w�ªbO�@ċ�;��Fh��v+|�zϘ�a�U �|�1��y�ٱ8|I�1�U���a�ӎ�����W�`.� Ӵ{Ⱦ�K��yè��C3�Y5
����4��&��iJf>����k�]�cϲa�]�I^���1vfL�C�!4�=Ã�CJy}�Ѽ���M�#F������@$ks��4[ǜ�H��S3���?b�V��?�I��e��״t��"�_�7��~�s�5�,q����f�~+[� # hkg����$u�t��:��z�t\�!�nw�v�%�*k��p��cp�/8�N��������ɚ��^�3@��xJ�I/}�h}��q�_�!�~am���.>c�b�Y�\Ku�|���)��KB.��X3h?�<
�Y%]�5���_�q��"h��l�[�[��@��%P�P5�mu��f"�P�d���%/��욮������a��D���E�fq�yv�5ҵ2Tg���V�#e�lc����-��*ͦ�N��FZ�/�1�ӥ.�,���i"n�C)s��^�[��z	�4�,�u}�Ϩӗ�"��Z��ժ�������o"R�?B�<F����О���6�ɢ�E���vbUiY7�eMȋK��,ءj�Z��cW����gz��.�خ�N��3���Y?H.-vv��CZd1o���\Z�N����XK@��.�<�pڅi��s�ٚ�r�;b�K�۞!�&� ��C٠�\�{v*���Ut�ӹ���r���y0���X�fx{V.�vv������*��pu��Ϙ��2j�������ɍ;�YʇZ�i���A�絻�"ui'��1�����"u`�J�a���xID 6�%'-�u>R�U�if�K���3����r��іc�j;x����`��k}I�׬nn�,.�%���1:���'�Ui��������-%�2R�����҄̋�����'�����s�:�Lo�V�jkb]!���yU�ߒ;�'���k��Y�܊(Kh¾$~�D*�>O�fߑ�5ETJ�|�=�lر�o
,]u[�#����"`C̪���ʙ1��KC���f��tD��ݒ��e�a|��ovE�ة���~�gʠދ{$�	wL����8v���:�>c����D�|�Ҝ1�~� ��[�0�=�	�5{ѷ<b�D�B4��F��a�zF��0#���ռ����[>#h�F�S0/
(�+@��\�?��j�����)}��c�f�(��(Zegp���+t�[��0EњB����)o��nj�]�#��lps�DKeGrȆ��_#N�ŝ�t��Uȴ���g���1�Pt���Kz�YM�N�T(M�p);F�����r��n����3�x;Q����/��F���(�uj�y�a{���h����ߐ��e@��`duT�>�޸��R���hu�y�T�*�L���:��[��t��&� "�H�^�IKܸ��K�����沅�Z^�Uv�_bhc��Ims.v0�\�펔��yo���G�q��",0�[���.¨g�N�K���=,ym(����3]N�3�ss��E�n=<��r��\�2��U�I�g\h�,)��PI�qyƐv��-�I70�1�n�U�c�Iwp�魺����ޏO\U���w%�:�F�	쮄q�@�3BK�m9���&��^@!�J�����/�f��
�$?p;E�_P��6ɕ.#�v¬�����3�k]{<?�t���)<��zr��ӣ�]�y�#c7��n;�Va7;N��ѝo
����a����ѝo�4k%�P�=��AfXq-E��}���Q��7�4XQ���6M�ڗ�d6��"rP��ЅQ.ѳ3e��}��2��P��3�3#0Q��	3j�=S4�6߮�\�]�(os�NF[u�˹{�h�v��~(�$��Mi��!��^�����V���r	��)�F�S�̀�u��e@���$����`�v��5-0�1]V@g��<�a���1iڍ�~h0dn*��a0i�-�L�l o�T"p����\2x��f^w>`�L��Cn�����^J����M���;���������w��Vu�jԎ&�5�[DQCw��M�sE��4b����S��V�b�[6-1T�L+=-{�(��������/�6�T{N�4oQX�c�oI��"������iE[D�R1
gL�ŽQ��}�X���ZF-����#Ϻq��w���ӽy�-��N�G��혡�u��-e0����A,n���譼a�;��R\C����"�r��$�;��cVD�^,&�z8ct����ݯ�F:;����þop�1�t"����[F<m:;G�d��R�wu���y�ݙ�����ȵ-�Hʢ�;nF����oD=\���ږ{eQ�!S[�5��� ��Z���E���1���C�̮���=c���6m�7o+F���
��wo��eG0y{��a����6�8(�̏0ӣu�����f���l5q�V��$��[D��f�PZ��d_���%�p�Hiւ�<mQ-�R,��a�6�$ގ�1�yj��ݻ���B�fkأ�k�\dY)�Ì���*n7�G�������Eт�y��x?�۾)��pqn;�}�@Ѣ���8�I�ϕ�02[r68w���L�,�y?�-��\�3f,�    vNFGE�i+���̼� �"/6g18�=4�1����'�� ��Θe�grJn �:}Q�g^:>���a��*@U��i�2}(��������e��!�|�h���i���\���iXՙ!���p��vE�����/I�#F}&q�:+4}�3��5��`Қun�cd�5��#�U� ��jdjP$;�
uF+K��Q�0go�c<ݿ+�-Ml���˝)�-A���c<ݿ��5�Fd��|hޞ��v�Ҵ��,�e��0:
���#�T�&;FVE����\��F,��!ƒ�ݖ���Ueo}�L��饈)j����KF��ՠ���Y4)��L�`�<O<�b,�vf�Q>��r1ϔ��`} �������\p�:߿����&߿��T�x��,�U��7�p�2L��oo�-eڪ��w�EM��o��7Jo�&���+NL�����ً]���F�>w�{Q��%w�0��Զ��&7��O{�%N�7#57lib.�w�hiT�-&w�LW	�f0K�2��@��
X.��ઙ5?�Q�<
,�ܑ�ڡh��;rݟ��T�l���u_p�T���Ʒ#m�pL���ӜtL-4�o���r�!�)�#ط���њ�V�k�fK�'JWw����j�DU��&�A�ߔy\I-�3�K.ny��K�>�"�i&|�oJ#�{nAl6�v�%��4��-�#e�������N�%�q8cX��|�h�#�a)����U����a�n��'�<`���,p1~m]��E���͛�'�E������ɋ����@䗆[�Y����0�Ӛ�b.��������к���Zm�#�\��i:_y���Xg�4�m�/�K���ë�c�D�0�-|��k�ۻ�K�#�
�옡6V�s�\2p�E܅��\F!f�2�� �n��ԡ:{�br�ሩ*���n>��0�z�2?o�k�=|���|�4�&��f�X�Q�C�NY��X�wyI�1]�h�إ�$\�� ;fʹ"&;lK�a��Id?(JK(pô��)Av�&?��t���`�<Ў��y_C��vD��>7�}S^�`P�o�o(�V�c�k���ds{��gJ�Y`c4��؈(Z�`M�\�2�4��5)�D�~��pK���;BT���Ͳ�s��Ԍ�|���yv�@�8�����Nl��K"�J'�}@&������3��W�Z����hEg�X'P�pg�
�t�d���i��V [�V[�b�����7�<�P�wqa��\�-a��g��oDP�HHLL^��c`UY��8���=c�m5�[���{����\Ԓa��	�4�k��(�<п�|�b�1���yT��rY�3F�dFu���%V�U3�ns��|�\D�ZYWe��Q�m�h��K�]�a��7���߰{x�3������]��Z�s�3�"��Dd�P����u�E�<�`T�����k�v��F��54w�Ы���ZLFC�1�5�V����3f�"�X�Is��*K_@�A�����.>a��h
�=T��@�1muMN�̯M��U��k��p2ʆi�-*4?"{K�5i.��Θ���l1y*㈡WM��Skn�^ʰ�J��O��P����p�cǬ�^o���S�&���b�4�D�$�[�LF L�7S�)������<`3�Z����i�n̶�ЖhT{��|�\��]1]u�>�w���{r�^&��uv��R�6�<(Lm��2��)��䱈 �u�6�\�Isg�
�}�RE`��cX;���RƉ�{2�Zh6J����w`�A�o$(�0�z;}1�4�Ť�R�[j����ik������Y��t�KV.�4&t?&7&�v
��m���ܘ0�e�[�ܘ �1�๶�~KnJ�Ncؓ��>�N!&�����N��)�^���++il\6�����Ko\����p��R�q�#e�X��=���c_�3hΎ���̘w�]rs'�״������WԻRy��v�1�Kn���k�>�b�F�Q�P�krc�M���uw��k���(�(傹L�)QFG��z��^���}ƐLJ~�$�-���/iI���
��48)w�L6(\1�"|h�MY�� l�ř;S4?n�j>yns��\e� ���p@�v�4K��#p�TTLw>�K_\@i<?@�(߻�q_s �4�uҧ��sg�t�D��]b���5��$W*]����2̘d�괿�Ӗm�+e�ySIS�I8퇢�W���I4��IJ���$��C�Ʀ%yR��=J����:3Q̉���L��l5i�/�4�(�Z&}~(�Ax�2���M��B��v]r��HѸii�;Ҹ̟c3?��1E�Dy�2ޔ>�-k����f~(ܴ��P�<r@�	q�e<�|(��y�E����QHg��lt��P)��\즓��'�4*h��UR!��ҩ�a�%���~M�)5�����Dܑ��s�ʰ}(y.�HC4��6��=�(��<]���j�G���l�=�߀�ӣM1Fy�qX2�����j)�I�㛂���#A��Y�n�%�[�bI5��
~ f�\pGJ}�!`��q	6�o
���&�~(�hÙ�[��r�6�N�U�ګJb|(�`Ù��c�o�k���j_��~4�]RoG
hK)?�]2o�v�X�B�6��.���£Xme�s<��aF�e����.��T�Z/�*�b���1�� l�K��[�PgL6�v'%��x?4)�1�[��J�����Vg��>}�3�Q�i��[��B�C��_����r���q�{�z��g���#���&>ct��6�.;a��* 6�fj2裏j{W�:�#��]�L�l�N��ҵ9c�)S�{�y0��p��4ީYayl��[����W)�x�p���r����Vɀb���w��W�L���-���[�~(���e~	�\P�bD��B+	8�ע]����i-V�,��I��w1�<�����meFq����w�Ы����/{��i}:K���P�6�i����
�s��N�\�L�=Cj�U�"���<�j�U�,��LϠ��;�_:?�y�a8��LՀ�<GB*�3��6��h1����pT��!�	���>CQ��3G>~��$i?�J��=5�7*�[�W#�z�><��6��L�*�Q��`��)��Ğ���[>��Ѡ��h�w�J�0k��Z�h�@t�G�k��iъ-Pj�O萺CVc2iH�ZI��#�k{gi��t���\�f�7����_p�U�M��%�� 3���)���S/
o��E,S��YS|��V�C�{8�� +�:1�=��'�����E0�/m�沋q��w���ܢ�\v����r��E1��~cT%���W��.�zG��Z�-m��:6���0cMB�ζӣ]�����F�=,�{F8��0�=|�h�*���� 3��پ'����V��</,M����xp�|S����%�lw¢h���j(y�$�����Q���T<�
�D��%9PtTH1O�������}-�}�w��2ͨQ�����{�L�;�e��(:�o�-NR?5�+����޺:�E��ɷo��ѫLp��{�U�����Y�8��F��;����h;��	-�梚`�vg�H&}�����2�&��10O��]:L^Y$��iM	 ���9�$�{P4����=�(�Sa�ˬ:9,�K��� ��f�R���-�}����M������ii��PFn�iYXJ��L+�ˢBsύf)y�0�L��6\��MV�P�3MxEBX�U[��NU�FYzR�oʘ.��"5)���8@w��2ݯ5��C�[��NA���o�Wۑ�.�� ��8�y��\a�k����B	;9-�~I����^��;�1���i :Xc�_҅Fc�M�%�u�1c��pk�'��Չ���&ˎQω_��և������8��pZ�P�����^rn�&��-<��y��#EE��98���� 2wa7�\�b�Fi�
=<&�%�/��#�N�s:��+�yi�v ks�
��K����7��aT&z�'��7ym��b<�����mn4���b<�)�D�Qӌ�oʴě)���ȃ�Z����P    �noy_S@a��k�H3����)���<�f�nTiJ�]cQ����奝G��̓n�ǖ���<���p�ngâhw�4R	%?x�T�Dӯ����o�N����g�7GiA��:!�=�q���V�1�z��f���((�>/MSP�/��
�S�K��Q�ۈ���A� 2H�Q�K$��&����3�u"�s�hd�ɂ�B��<vJ[��:=�.�E$3����RL*�*e��UOJUy�S�Lf������j���Cʫ��\(3��Ad�:��}یޮ����4�9�.ɷ��CG�J*�&e?���:zĺy�툁2��j�LL:�@�~<t�Ȑ�5��`�=|�Tu��^wj�JٿKX T�{��>c�/������?3�8�M���̀B(���k�-i� ��1'�f���I�������s�Z��ي��<�v�h������:)�G�_ρ�?�'�"�P���*ۛ{��5�yg����2��L���6O�I�߶6p�6p���y�-�h���52��g��V�j�rq�&=�#�1岅�N!�K�n��=�Ȍ0�Jws��
;!��gޤ�#�FPE����[�A�BN����9~[�ٵR1.d�0ӂsB>�Nj�(]�o��k������Y���uRۆѴ�x������4va�̈́�a4�:�R���5&\Mݽ�4�v�ȫ�2lެk�-�έ5��-������T�*�̛E��4~a�F�:�]�N����I�6���A/`̳L�n�4!�_���^���_��p���U�j��ɷ��ЎY��m^-�e�mz���%u��a�������-� �)����\�3����p����3?K�>�k3���?f���Y=���eJA_6w~悙F�͹ݗ��I+;��l�z�ݯɏ� ��ݏIe�"��i���H�����5�V�@�s/�\wƌW/��0����2Yni�*i���%��2����i�3F�kzLM���w�*W�y�4���p��v#��b���0UV��<a�y�&�@.�)7��Si[$�m@.�aT���(�>P���eں"ՇL7�C�kqk�f3�ц��F%+-	���Ϙ������Íw����b.{��ђkMYL��aZ׉5���&VC#ͽך���D��;L�hcǬ�h��,��\��^���k҄\�iN����ap�0i<��JC��p�Q	��[ZQa��פ�a�uǬ��M��ʄ\03��SjӘI�������5�^�Z����Z������0CPl͉�/��w��*��~M�0$�a���D��%9*�No�e�1���B.��{�뒇�!�&�	�^fD!��膒[Ŀx��{����ܖ �¦rE��t�)��h(�S�v���T26��!|�L[܎+�~9�� �J%�zd�;eIn�F��ٙkeF�xv�
\��3F�l-�<=���XK���ͽ�<=Q4/m�=  ˴D�y9�7�-�ߔ��홬�B������"�Uc��2�������s�O�b5�}2�8�����}S�uf�� Ӛ���D`F'i*�A���|�VU��\�J+��oW�$�\&sa-��&�*v��2��[� �D=�<�&�V)���أ7�Ɍ(�H3��0m��?��P3�Ik��xѢ ���4�K��;S�5�i������aM�W�m�=�%'P�	���rm�W��VR�a�ֈ�0���"�gʼ��y���u��Z��/���"
u��@�$��M�NN{^j2���E��m*�d(��=R��ʚ��C�>��G�Xk<*���=�u���=S`�bo��N�~�AY��f�1<�Ⱥ�:
0Ӄ+���GT���7�(|ƫ<c�S��g�%w�ȫu��1�G��oJ�q>��<��}St����yd�%E�ᦋ�Ժ�r�O;MP��CӼ�<a���Y�%������k��K".����N(4�<�3��p�`0�%P�YGV.�g���i����R������٨�.�����95��*��%P�SM�)�T��L�i���1�`C�)c7��/�K��Ę�tՆ{�<�P:�Jx����$Y!ԉ��4�A� w�����K��7n�_��^�6��%�v��:����"̴q��F�|R����T	�j������[���a�7,��u��Տ�rb1�0��
�1�h;F'�UJ�br����i�nm�8��aP�Լ���m2/�� ����=T��1mi��.V1s���:qI,y)Z��Ǆ5�����;��>�L�,&7 ����n������)8��i˸mSs�!�0�������
�����w,&?�������Ś�l�޴Tjr9��ގ���6y�ƎY�\Fs�&7#��bmZ[������������R��y,�t!�	l騃�S�<潉� g����L��"7�6�I�uǼe����פ��"�|(��*ɗ.���nD~���%>c�#�������[��a`�F��hK��z0̭��\���׸�N[���{�'���K�-����Ϫ��2ԯ�n����}��Q��y/�'j�$�g�	⎩k$z�ķ՝1:n��z���:A�1����1����0�&r�Θ����|n�଒K
.��/�]R�W���P���5�v��e�0�T����x��\J����R��y`�~Q��k����"޿���DU"3��A|�@-����Ѵ��]L !�G��5����,��.�ę��6QF�{�6��M� ,�b
�!��v�<��-#��D�k���*��^�L�����<���+����g��ص�+�q�Z��L��wĴ��tN��;���'�Xt&�%w��\�n˒��Gu�К����urI����.w�n��a�.�ur��\�̼���B�ȬGԬpj.�3�0C����Pj��~LO��yj��)�OK�cҙ_f�վ��D�_U}\ͮ�5N��E)#̴\�Y8Y'��m.Σ��헾��0���9��a����<*K�d��;�׫U~�O��"��ykg@�4#L�K��ώ�6�k k����"eY�������[�ܼ �Y�\�2�H�jW.���)��̐yX��6��<SƼ��̊�.��5����n:�-߀��e�O�[�D��@k�TõC$�1'��$As>��sg"̼$�_{i�#�(:[G�۱��\\@�l�mR�%H�<�3�.�(�%G�c�t5���{��)����M���=c�E���񒒣�kBm|i̅f.9� Õ���F:�+�Hv!���3x�,Q��_�@�ݙ�RF��1���`F���`��h���(k�HQ��[�f�#s��e�p"�4��Q����F��T4]o��5W[�4v�\ʧ�E����9S��P�{�<`��a�'��u��wL�HQk�;��'q����Y��j:C)��;�a05(�1���y�19L~��h6�Mk��c�@u]7�I��p����k���\6�	�ZLí�ebC�Z�_�!J��L�{_��fR�0R�ϠR52糮 �3��hG���W��i���1�!��yO�����!�]\L!u���QZ'��`���dV��C����?H��Ͷ��Znf�1�Sd����1���6 @-/�a�MQc_��D��偺 3h��2��p舡�6�w�Y)�h���z�!�3 ���r��,�0#� �"Ѫ�teN�vv͇tI��Y���N�����e�0���VY\�3�1�ae��򂋟i-���P����&��G�|(���R�z��A+?��k���@��`�y�T[�@̟�ߘ��6�8J���<V�&5U��� ӥ��WM�>x�u���|<SvI�,_@�I[�J:<fM�L�����ԩ�%�P�"������Mi�H�r�O��M�h&��uU��~(�L7A-�$�~F�|CzQ�6&��K�/�tAe&�%� V�,���*��y�<OPzgS�}�~ P
�y�����[UZ¼G?���o�������o
���m�[��|�B�|�0�2�H�cTw��4��<g���GL��d#w }  lR:�@�K�ȹ��+�G�;�G
�Z�ZrDy�#1�	LyŦ��i�]�=ZwK�;����s&��j��� �>V�.��2F<�,c����@�=�ł8a��;I/��#���;�nG�L�(F�i!���b0�.>b���;'�$�V��*	��&�6��cT=}�z,6O�\_��� �Ĺ��h�@܏��
�9Q��DjqK�W\��eL�Ȩ��q'�7q��Q��Ēo� 3�D�d���_
�.�|I��u;�P�j��zYs��v��&&����Т!sK޴?~QV�c�.f�9�x�F���J��꿋j%�\p�O�`���p�����ЎZW�F�ڇ�C)�<a:�b�Pi�Ø#W���׿����p'��      �   @   x�3�v�twt��sWv
��s�44��!##c]#]#C3++C�\1z\\\ �Ej      �      x��}ێIr�s�+�q��;q��-�:I�X$�2�X�, ��Z���ya&����{���FU�V�O���ٱ���=��~����ݧ���]UT�/E�KY����KQ6�����?M���q���m�����������>^�߾�]���������������_�������������ؕ������/U{�����~��4��-�e���_�Ϗ.������o4��w�׻����e�|�?��=|ڿ|<��G�X}���Ϻ�~�(X�蟢b����w�t��mX�	����b'��QE=����p��;�qxx{����~�'Os����~���px~;��)�v���������K[]�3c�@`k�nZ�f���{{|������;��^��˭�_��W��Ó;z�����}��g �i��n�7zz�w�����M����=���<�����~��4f�}�?��hM7^��hJ�P�~=��`Ly�F���{f:�/�*5��)��H(��������������u��0�O�������ڕ�������d���?|�������ij�~���g8��Ï�,�4+�@/7�r��t����׏��2�PP$�u3_����ׯow�?^��^_O�����LS5잿���A���gw��Y�6�y���n�%r1�L=�6_\$/T;���n����������w��9�hw��8�wګ��?��?~����.o���~#��	�/B�k��_�b��i���#�8�����K�\�����dh�I-�`0�c|�;�G(��|y��*�V�	�������㧷������xx�.s��j�g���/����\��{�u�t�|�?�J���;��~���e�;���#Ewq�Y]��k� 5͈�{1���U���͸{y'�H8���C��=�?Y�N愇:T�#��R���3I���U�[c�y�G���!(��в9`�zF�JM96�	(c�C8�'	�:M��>MO�m�Ƚl��$��p��~w���
q?�zM ��}���߷�n�̗S[cX��������3Iq�7�an�D�`�b���7z>b�OQ�r�$<�+�[�b��I4�Z)�C��L�f���߿�a����+�}� Ps�u����H\���	�\�i�����[֧�xh��PxO�h'B(D}�Ï��(6������$�kң��.��"�#�h4�QF��D!B���_dB��M0����z�5F�X��1��~�����o�?�y����Gs���L���=��c������|q�ّq�h(����x=���7�Pj����M"$��4?ȷ1�����k�������\ B�T:�h��K�q�nٚ>H�|��r��I��15�ɏb��₦^.��q�FE#z���5��9��<C0�1$OCY� 
ESi<�o��,J��~cV������e7X#s���fS�cA{;��I��+b����X�l>qN�&n���eآ�~#��0���.�<�O�S�"TB��ww4�ؑ�-�ؑ��U�خ`.zEc�+\�B��
��P�X�b�M����a��v��=&���������%K���X%��pZ�{�%T�:W�7K���O�����:6��s�npS䉃��q91	ktC�B�h�����m�����a2doo�����v�h�q�Ov.�3P���JM7As�	]M��bЅ��z*3,�DĈR���WqI�KW�!C]<L�P�U�JH�Q�J'�O/si\+�C�P�����`��ç�J�J&���lt�K�(�t�K���c�+�Fu�kh+2e\���=]�M`t�"�q�l�Xq��W[{�eMK�z���<Q)F�aL6��J2��W���9B�e&������χ���wGW���]ruw�F�p���4Y$a�F��.N��>.��_�DP,�������ZO�۾�~#�����oLT*)v�?ޯ:�'�p�^4QR��σL
J�1����n��v����@ ��!}����Lf��ݏ��/a����|O��d� D���چ����ZB�;��c�z��e0��~#ͽfy¯2��W���Zxm0m����o$�����W(ͦq4��7�5���Ъ�Hƞ�rǎ�o$��R	h�A�QjZ[&1�j�E��i���  ���K�N�&��:Y�20z�17<�q�G�u�M���;]�#����5�9;r��q�tN���?<��������������oz\b��_�QT&�����V*�u�w�;4zL0ʟz�nn���+R;�\�Q�pi�Q7g��$S��ؒΐ�l!M�2Ά*KE*;��oĨ <9&3�L KO��� �]D�+j�D�  ��sq�k�%�qZt��sĖ���vb��$��i�
��K��?�]�[�a��P��܊4!"��q��,��]	

��ֹ� ��\��#�4�*2�Ƿ�z���o�q8V�	V4'9U�F� ��9�Vf4B�S����+����d`�j�n���=���N<����H��L�D�G_I�I"��0�;��FO7u�`���Y�H8=3�D+�IИ���`�O�`գ����]ٚn��Fh�	�Ed�]�F���+4��d-,9�8h[4]�6�|%��<��f�z�"��/L�#`�5�%�}��^���z!��G_�+�n�e�҈�;Q��r�$5FHrEJ@ �K�`�vx�+�i0+��3B�ϳA���J+���h0���P�����~�����L�&]vԏ�A��cҎ����$(��ܜ�_펳s�t�?�zq���W��/㲡<c���|��N��(��(��S'�����mNcaZW�Pw�
�ܛ
��-E䴰B,B�;�F���Jϋ[��xpJ�] ō��#��n���M�nc�!>ƶ�M^�`2e�Y?I׆F/x�T�|�Y�0���>�!訴ʑ�B�!�iz�9�2$��a���S��{��fs�F���iaEП`<�I�f��?2
���Lُ��4�,|N[�nf�̵�F'�)!���__) I��fF�ŕ 2e��bC�m�ړ",=����MH�����������iq3e�hE���ۋ����`E��g��z���j�Tq��(*��[�lvU�����`t�����U4*ƨ�I��y�'[E�E���2���k�pHQThl}֚���?zw�
�2(��L`H��@P�m�t4�Q��ka@(�]i(�	'��ؾy4��yB޸ʙ�PwKdBEht[uF�Q��EM�ѳ�]*�	X\*7_��9U[4+�Z��Ax�������O�����:��􏞰�>����=�|�������u�r�����P ;&�X��F}�;.g�&�a
�[��U4�^̱�>�s#��/� ��� ��7�7��T+�)/�{�A(�U<]�_�]�wKJ1�S1�I@& Bq�$���L��@�	�Ңx~+D����CDnzz2Ψv	�tJ��|�]?�B(L��w���Ԣ�Ģ��G_���y��.�$҄ eo��a����)C� (����o� �	���T�`%�d�c���M�c����z��2!��?M�o/��W���/�g���8L���_Ѡ�8����d	����Q>C���2ˍ��kڡs��Ywl��쾭���������	����G!YԕB0��!a��t����v9:KbC�q�k,��B8n����[�OV;���
~O�ւxV�Ԧ'Q ��Oq��P�aw�rؿ�]~x!�_VsBo�8D�O[fq�R�ʀ:�v�o�γT"��uF��T:��@��I)S�@�(�Y�x�������'7hw���)���?o�d#o�9m�<�w=�ݏ/������Wח���Kw�eC�48-5U`��3
�Sg�t�j%�S8~J[$�bY��S1�O��i.L�g�E�o-���/���J���bptFJ��'���/Q����:��F��@�.o.a	d�~#���W5ߘҽ�D�Azp7<(���Û��4��/�l���S�bK���#H,�����
�C�<�Ǎ�j�+#[-@U@(n��@8�ބ�w��]�w��7Z�/c    ��b�	�s�T�ժ����c)jR�h§�u僢���V��+f����]#6��2l�L��\}��F�J
B�KE+��ɣ^q\�NjEўe�
v��C��sE2D� �j3f�1T��JÜA��8�_�p��z����W�t5Lf}s�F�`}�;<-��w�U�&`T�L��KR��g��DH<x|b���T��Y�Yk��Ì��ڄ�+��B�6�I��k��0�R�����a:�O�jM̰-��	1ܱL��g�nȷ��|�rη��D�@�,D�=�,�a�и�N!�ڣZ�R2@x2T2�]<[)2�Q�	�Ua�@:�K/���o4�բ�>`��VP��9҃��"v�c.��(G�OxtyM8��=���,����*a0�" ��8. Ѽ�����I�2JY�쉩j�3V�*��<pŘ:d� *��~Q&^f��v�b�`��7�%���h11:�%�fv[�k�_FiH(S�%F{N�s�<�u@"��G�k���!%޲����#_G��kt~�%��ڏ�#�^�����+�1[V����Ez��2p��2q�p��E]��-��7�4�S��V�ڎ�#2mә(�v�"���y�iwI�U�v͙ylF�SD�bI��E�,�4�M�`�%��t��Gc�ovA���j��{�S�$����E�������n��(5AA�T��@��C�B&&�RWPL�� �J�ݡ�gz,���LA�����ʽ�$���/��22�b�i�&O��XؐF��Yqe�8$�N�1��dgH�aAj��o�;�ץ��00�0c�5�n�����n� <��j��.-.B���c�lH/��g2�MtC�-�P�,F�Չ���10�I�\gжs��\QR&Ӄ��|j�2��ĕ�iC�K��(�iD�kA'���!��;*�<2�B�i�p;:VB���UIG��Pt>��gtUu����d���ܪ�J�}�Άb~�nFX��;��a�jhVn�xE��r%�c�U���z��-�dF��F+i��6�(]����![F������*A(n X����+5�����<&vq{]�;���H����������he	ƭ5w)U|th�-��tTL��T]DC&��PĦ�A5���`]�a��9'4��E����MKWb0���R�0�ׄW��0I42�E_�޷+����0������׬Oqb��A(�|���V���H�h�>�mD&vsc$�l	�Ŵ��d%ZΝѼ��*��S'$ӰL�_K��bO$����O�{o)���ޫU$1��+48��z�Ѣi&�H� 4#y'���X$��X,��(Nv��_�8L�2}�0���Oa�v�U|q���L�-m��A8�Y�iI6�Iy	��1#}���Jq�S���G8Q&#�BO���k�d�ʘ0 �:�no+�ⰷU�4at�$y[�=	m��,�,�ĽBv&���T�i�I��k(�0DA����̊��G���0J�73s{��t~,��Y�I �����ؖ���?�;1i�2O(I,r栢�<�����}ڱ���7�N$86+}�92,=8O��U�߾*#O�I(N�`���޺`��+m�B��BlE�������¼�3�/�:�~Q�^��pU��������!��*���a:��:xbTUs�F���)�@����-���k^�c�	E��݌R�����:��t��N)��<2i<���H$�A�&�K�e��0a�&m�������ԍ�z�I�[��������i�- ���fC� ��.��m��#��w+�d��������2/.PN��oq��e7#81�[�
YD�2���)�Zf�wӏ�2w  �A#E���ͭjJ����R�-cj>���I��Ʉ��0�����R�rI@��o$0WKMh��I�c�U4�V�	]-$W/[�y�'cE?	cUoH��۪R��E�[d	�X�[C�ꦷC��D�H(��K|��b�%"Ba`4TkC!�W���J�(߶��,���^G���=�h�H�{�4����!E�K���K�\�ѣ[��h,X%H��&�1*w�D@��D�۲�2(��_�=��dl�X!���Vbޡ�2eb}�YZ��2=��_z��̯�s_k���n���@��g�+�F����@3,��$�KCq�\��9��~J[��Y�E��X�ݠy�UU�X�ؼ�{۸o�&w,ev��|�����eBi4�͕�j\侾~#�\M ~�`��7�VYq�5O� >u�J��u_���\�d�ո����f�֖�&@p�����=���23C�aJǄ�+�����&抜r���(�	�p��%��5N��6���)��o�S�����T�I@T3�a�eR9�}c"jJC��/��Lk$`*>h �!+% �ەX�ȰޑX�4��/��<�=Cth�J�}�I@�3��ʨ�v{��ܑJr������P��/�^cE���-�����40F�Z����0QC!�aѫ_&���=ے���qKi45�4�i�BF$�GQ4��
��8��+8-���D��2�<8^�z��E�il.�%cL���Zَ��L���)Oc1�Lh(�+�%RLRY2����:(�BYͶa\�6J���W�шtp p�x�F�}�8�9�U�%���"OȲGx,r�i,)D!�XL~�P�\4=sdJfM���H����tm��dc�4�&��[������(�C�B�<4 �Q�e�1�h{��$����y	���FKB���0��:8r����Xc���e�Ȥ�\� �ϔ���|t�2f�<�N��SI����U�y�P@�]�.{b��� U�FD6D�8���9�kÜse�"�@NԈ:�C��ɜ%g��A\���gSח��]����-�RI4C��m 
Mw��"2,��ir����,#��c��8�+D�X�D�i���l�y��g�X"	�
�z�ѝ�39ϙণ�t��Gg��e��4���׌���aل��׷�������~�D�0.q��h� ����G�����@�#�(A@HȔw�`CW@<>\�����|"1lgc�(4�l���O=�0MSܟ���H(H��<�G7�tD��Ў�1����������4G_�\�z��b���G�t�%$�E���Y�_�\��P��RB�N�P�c'N�[��aP�4�$6���)���zTpCo`�h����ʐ���	��RӍ50&�U��  N�,�E�Go�e����T�x���Y��!Y5���d�У�5��p(5[�!:���Ϣ�@7諙�@|���<��z�~�pf�F�L��l��+��3�4]l��3�}x6h��h�i!<z��4��=���E6�L�#��'��Vf�7��OЦl����[؇"5O|��)�&8$\���b���E�(0���'+��Q9�^��di�B�E&_����A���+�%B$���=\����ڥ&�ZrB1M���8{.j �C���:y�29��{�h����s'�E�Ss��M�ЌQo�]�g�uE�6��Ã0����8�P�\2^&��MVu3Y�V;�l�_v��XӚ�h�P�'@�'�P�xbz��a}�ðL����9iWa��%�����ļ2�,�&C����ub'a!0����,�������́޽�O��n��~� Ff2<�\��(�߸��R��љ�H��K	��)N��Ix4��%���4&�-F��h��^&�EC	��y�t�����
5c�w�]G��J���9fv�:��1�R��}}�3ĕ��9�t�
�lZ �pn�<����'[�<]��Ϭ���?o"���Vt�j��Q����$K��f�P���@C1q� ��D�^��0Bf"e/��zK�J�;���������!A ��;	L��[�|3�07��M���PBJ�i(��p>L+P�w-)�H<���4���i�K�aj�.^�Ӄ"7�4z� ���T�l����q=Y�S ��_���-dB���R*�B�����y���<��9-�%*�>@R��'M�KF��R	�xW� �<$��2~����JUB��.�E    *��]���_�(���0 �d�N�:Ѥ��\)���g��1����$K��Z�PJ�Z,�%�\2�,N�ll|/���Y:
�Ia��yR0r�~�c_?1�<T|F���x�TM� �5��fq�>���K?����N���K����c�P�E#`Jxe�h(�~�5�� �L��p4�o$���O㬉%������rx�/�ћo$W:B31kt�%4�&�͑2ȴ:RL�n����nWfV1��-ܤ&=�-�S��?��FN L�r���kc���ۺ��f�q�a#0�x���ed;5������&�j�1�R �b=E��u)�x���1�U,BcAX�Q�v U^�#�4.�Z���&��%�n�L��n�IRƮ(�L�f<��c�?|�]^����r+ͺ��	�fE`�u�N����EEc)
'�J�Ⅳ3��20�~7D��'a�C(�R2!?����AP��$�z�AA\��		kֻ�P+�,y�X�䥩�t4��x{P��T��H.!$��K��=���D��ʻMW�w�j�{�>�rI�� �I4Z�N��j����z��g�	l����.� ��`��.r��ধ�Ъ*+N�X&.�o"=����SƎ�Xl�=���Ls8�C��d���0=-(�=�"�~0hynf�xᬟ'�+5�^ǉ��y;�&��i�	<�����5���I*X�|В�����B��hxcj���2���W�r	�_��gj��fq�K@�c��I��r��@=Yl*�CQsl��υ��\}\ֵ�-�C��"QuZ/��Ţa�$P��!T�:i}vx@��Qg��܇PL���uJXN�ձ G��/=Ǖ�P&�P�Oĕx���חR:� ��& ̯����e�N��(� uOS�yxc���Bn�|?�*y�Z?m�ŶD�p��^t9�!��d>+�u&C� (��]��f�<�ht��\?���>9���>96���U̤~B�J��U:ypϳ��G��_��55rHTŸ�Q�����.I�2	��D��y�趏�S�u^!���9Cht�3D�r)-���F7U�è�ٜ�}��O�w�����~}xy��{�}�����G��-u�C&*s.�Ŧ�^t���@H��M�V��C���ٽ�"RuG'Ӷ �E�V@w;�_2*5R6Dc}�e�|8Ƞ��$-M�1y�m�ꐴ
�J~�*����)���v��R�-��Ax̳��i�)��������xAQ�"�4��f�j^uu����
���1��\�x�����m�ktѡc�
�ht[�d�\�F*�o��I^|_�#s� ��@r��.�x'�6}�&���M��d�R:�s'Kf�a��JOFx�ӓIX���'����cCtԲ'�QhU$,kc��}�-�����:W4A��*�Q�MJJ3]A��3��SC��}H��LJ.��P陹�ą� �o�ɨ��BX����K�_/5EK�&���>Db��F�bj�ń ���|ԃF�Sn_	E��3&8hT�_�W3C6�H^"C���9y};���_~�ד;Y�	:�|"IL�����ষM�0��o�8��K����\ISD��G�4�K�;N����]���VPt�I�A�Z�����y���N ��/p�y3!S)4<A�y���ͦ�APE�=$�B�6��'W�l��GmJ��)&t7�Ɠ�G;@8��*]�xB�dJ��d��P�XN4�=�t�� #C����PBP�7 ��ˤ��4�۸men4�m��3e�ʔ�#(����<�=�ޑ7�x(�n�t���1�2D 2�gRd\r%���e2}k�TeCO��@�L��V��q`�&��V�"pt�:�	��[����WA,k�B��1����e�����*�s%T4K�ץ_F��}��\���B(�W�J��ZiUD��3�%T]����?�4'��KP����~#�ـRպ��E��zg��&
1ql��FS�nR���F�%th�i�%S@���ڧUE��-���W��p0������P�?��aeu�WVk�ΩB�:�8S"SR�,J�y�ȵ��YQ��9Nj��ǥ��G�Ƥs�3�b�j�P�83���I�!E��nai��_�R�UT��m�'%��#�a�νf�s��W�w��Xe�^��4Ü.�f.G����Z�
 3��h��~��U�Ÿ�Hmz����IA��w��R�X	4U�)�F����w�ZV7O⤠��/�Iѩ�%�l<�eK3öMB��C��I-B��rRK�7��
D�YAD��6��rS�\�^ϒ��&�����@.�X�l5X�-�BS�F)Dc�D K��W��`��#a��4s�W��,�a��@X�x��*OW���.��������g�dlZ��>�g-�C�c�ʃ�E�ȴ����X�@(��3��D���2Q�
��]�[��=Oa3(�7Q�DP�k7Xq�/2�e��6�.�o�U���U�������� fCkQ��/�w�@(i
a1N�aY�C(�	� ��!�;A���NQ��෈<;��=�?;�Q���QIO�Z�I=�M32\�bH%����ZN��P>4�m;):_��P(#���؆*� j�	2|�lH�0l/���A4ֹb@��*S�����L�4���T\&�� K�@��SBiÔ��0�=5f[�Y��<�*��<:���I��`}� �ٕ�I�C�g��>�TD��Y��)�;�b�BD���S�2�&��4DI
��lc���r����1O�%�q��D����������LP��Z!a�1�͞�!W��F�����G�1 揟(6���iU����˴n��Gw4�e��U���a�i�����N���S���v�!kj�D�|�#�ɰܨb(�{��4���L9�f�'�\X/��ɋ��0l�IЁ�<�uc9b�Q6�y@ۮ������Q_�*��A���C&�A�����y�b<s�ORz]������=+9F��9�����M� �%�Eei�)2�Z�˵ �M�3y[�n�,��+挫��!g\Q�*lt8�Qh*�	D�b%Cᨖ)wRDX�����`�L�f:�Ɉc#(��(d�K�4U,�m��aҙ�L������@�L��L�����<�,ȥ�#4���?�5�tD&()&���X��g�v�ҝ���@B3C{�=N�/����0���e`�t�e��u"�Y�4��^��{���Z�4���Dq�z�����U���V&��GQ�=�]����sU�M�<�c�0QEHn����%�<O�ʳ��C)�,-����յ!�\��ɀVcX�S��!����Yo�fj�mS�M[�#�nwx���!���?o���`�WE��7��7�h$ٝ���,��I<�1&=����*cؠ�M�����9]AS�6�+�%G!��=P2�Zht�z-�n��P2�F��'F��?�h斮����C�n�h���ބH,��t��?=}���)7����B	e�Uq%~?�q��G%�܋�/_�4ჺ�Jp�t@���(��dDj9I�dHc*����M0v�^�
�[%�i�U����uPi���u����F���
$�&�m��3)=�B]H>��;"��ȲI��Xr��ƀ3�I��+�Hׯx�<}���X1���a���"���w��e��n�a�>�.7.Ӗ��a[ʐ)C:��Ю�y�2C�H��@0"��y�KB�%� 4)�Y��^G`�*tp�>rw����j`�f�m��X� ���L%��sL���	9���SJ�kR���	��q�j�|i�Jr��f��9QrO2߲!w���+V�,9�ͥ�_Y�,LkH�*=�Z�!����ՖiC)C� (��F�)4��_�v!$��]���u�^c�گ�M3���^�'{u!i�4B�*f�&�@d�۱,��>��vq���C1���w��P_>Ŕ6��"�F��v��![:H�����o��	��m�8*D��+!��zlw��A��$���bC8�݊If�N!Q�BO($RUOȥV�J ��Ƭ̓U</���̸	K�4��o7�@�,�q�%��}    Fr��^�+X@'�ɼ¸R�ߣZ�{��߃�'sâ�C��o�A(+��Jp�[�/u�[.1T��FX��o:����G�Q-�}Q�v
�x���� V�*lB��Z����hw��?��y9�~z|�xw�������*�-��*O:�\ʊ�SA��d�*�ۊb�-D@M�e蕄k�����X��b��k'�Ɋ"0�$Q�&x��U\bf��A�0#��%'��in�Iv邊��vA�HnY&X��Bj+�� &$���A�5xc���3��t��*��>���@	0�Lz�4x��:$Y��E}�������_nIU���������u��P���/���cP䂤	9&F��-1��Q��9�t%?�&/���Zi�.rc��A�5�h��a���HV!���.D��\��"8j�4+�4��&K���_�'c�C(��=����<��_D%�P�D4�mkq���`�f:h՗9|8��?^��^_���w</�p�u�y��Ff)�J�;��:����J  [}':Y������%̕��U{i�!EB��Fe��A��w��g�N1��T�� # ��k�Y�XҰ��)
o�IC��A��W�FP2|�
7_O$n��F�.���b}!�$���N�Z��ht[��-ar���9[�|N�Բ��Pr���U�	�x�^��P'��j�Aa�4J~��C�$�&Kk^?KS���%RZG7-�I��F���$�jEq댵QO
�&�i�)��Aܐ3G�B8ܡP:>=C��ə������6z�\ SL�óA��I�N钉+'d"���ϯ�c�$���������[��7 ���l-d@��/����ƿ�+ڨȄ���L�U��c��D���}�ɣY\H�a$%���xP�$⢶JvDpl#<h�.�Lb5�$[�+�H�)GhLK�<bV��[%��) 
�W	�՛<��ۍ���?�yf�?��72���ʘ�Iv){��t��IiAPlSZH�݂� �
m��Z%QU�� [`�*`ڙ�GȆb�G��#d���J�l�.�\�M�����s�6 ,�>�u�r43����"{31'GZ����p���%
)i朑�ѓ�=B!�� ���K�]��v�ԊI�� !��w�z�1�s��X�X���A1&d
\74wؘ��
���@iX���}j�����ƥV#S.t#,�Ւ�?Cbm9i�\�q��|���+��4�m�<N5SB%�υ�X{���ɯ u�LEe���	��&���*2�|J~�|%s�U�����jvʹ�#�.O���w��]&/���y�ʉ�{(�,ݖr��[�B������UO@'Þ�C����n�(��`�I"ɯ�]�'0�,X�6]�,��t5Nn�eHn��U�0�,N��R�\<�S${�7E�VT��>x�}><=}�;fi�~ۇ5W���\��$Q�Lk ��2Ypx��o:Ր�y��C���9������p���oꂹ�eDv�Evk�{*c� $R����2 (�0$��� E�޸��е7'��,.3t�%AVzHa�^�Hm"D����>$�[2�`2=Ē����)b�% ��v��e�u���:4�jT���ו��c��!4�]������):v�� De��L[Ҍ2���(��vK��f��^>.�(tZ�dLh�󄹡(;dnH��	��C4�גhn��H�ٸ0�N�T��D"1�����_�\ab|�p�t6�W����ô:���H/��[�Z9&]k�v���p4ʘŚSԛ3�$,��Ք��r�$���EM���55����R�EJW���#<�5�4�̘�2JBJ~ec���z�J���zt�!mo�2��e�$]kD��Y(��d������o"�t|��� K+��OO3�>��O1��4�9=A�ê��1�l�s�߫�?�Xl�`��ӒBl'!4�;�F�-)���z2�~�Ps�B�B�	�eVgO(a1�~�x�?�Z��Ah̯�W:]h�d�+��<'��/L}�<�Zw�d�i7!����Y�� 4�����w���t��0[wt�1/N���b���JXG��f��և�Z���?�v�ܴ��Mςay� ��A7����PLOr�6�d4x~]����d8 8��M�3rDb��M�EMk���^A��M3�=#˭�#j�5�E���q�}� ��D�BJ�(a�^�����R\�"�t(Ɵl�Y� Bm��|l�B���e�>��F0l3��R������\/6d#���X)�䚛��3^��o�8C�������h(����$���䷙���a&�+К,�~�L�`^LsL���<�b܈���ܴ�}�`wz���C�ۊ��m-�J�@X�7-	�gR���N�z�;�o����������g������=+)ф�`j��+֬ɴ�!��^c��}�	�D�h%5�%G��Y_	�J���������ØŦ��QFEڤ�2J�&t�_f�*m�xOc[uɔ�����VZ�s��bE������w�f������?��LU�$�.�݊�-tA"<9j����u��"�Tr����B��o[���	�O�!8gEm�&���� ��|�'�ζ1,���\xP1�fH���bhHC�$P��rJ��"(h�#(n_!M����E2�i�n��.kֆ�!	5�kҒ�i���4w�?�ѷGH�ӷ-z1A(��b �r��w�����յ�3�W������~#�s��d2}��#�@|��
q%O�ԧ����b��WE02�W%��9�hxc�U�1_Q{�m	i�mi�C�%���*#�	�ы>]3)4��L,	TE?�ʧV"M~������7N��#'�d�<|�B�s��~(đ����O`.o��G?������/!�e� `�-�B�Ȝ*�p�`JOO�8|�nL�0'"A�1��פ�1F��_�WHGA�PG��H= a-�ol��ʑ�f�gdʖ��0�0�V��\�\��C�ד�xx����c���?��7zl������5{�1��3�`�ϔz(�H��P���B�=����$:&	e����s`����k`{5|ǟ͘hp���\�(���������,��p!���q!�c�b��6��7��b�S)�A�	����]��r��S���ۦ2| Bb��M+V0�&����VU/���K�ia-���ɶ�}��sh ��[p�s�{ Fw�xD0:�?\�a�Pt�΀��-��r�2�OZ�BaD�!�x]< �k!a��J-���n��G��i��=�����\���#���˯ׇ"����a������ui��/
W�Z�_[���~��v������>S���_���!��2����7��)�╟U�T+&�Z��\�N���闐.�����뷗�뫃��w|��3������6j�0͡�Hl������w8�����sK�9�z��4}���Oﯧ9y}xy��{�������G�gs	D�����Q�ަ�AG�-�!�n�n�2�8
#����%�;��j���*nk\k�������e����͖ioBC�{/�����bQ����\E�D�eF(q�����;����4�45��rd�J4��q_}������7��+S��-�L��ve�mKW��~#�0���z6��5�e�Wr��o�(�Ã��m��O;����H<�u$���g�.���?�=�z����׻�����~������r���7�k�����ڶ�36"�����Hn�L�z*�4P�h�(zI� "�ǅ��Fo��۷�%��(��q#R2f==��& $H��F�W�$
�e�p�љT7�F�|���B֓F2������/�Yt��_n�*�U�ũ�Ѭ�Wս�;��	z��M0�4����q�ӱpq��uqi l�qh
Ʀ�  ��.���0n��	֯P�P�U�1�pŃ�0�xC@��gJޅ,$$ń.����fŭ.S�@ �׋bq��|#'A+PB�D\AҤ $fTN)>i�i�uX<;��jל`�բ�f�    x�f[����U��>M���_����>�Rw�o���$j��O�#�*��ߝ9���F�~����eE>��<����M\NN�� @�ET<�̒'��F�i3ϓ��Kϋ�Nk�e��֫��G&q@�b~�b`��P��POPgqp�	L���� =-�?��k��f��7��Q'�;���%��2|ʿ��K��YrL#�ȩ��r����D&.@����B�'����
��XJ��� /�-��EL���d"�\6t��r��z�'_h���}�JF7Iϟ�ewb��|�Tje �&WY=�-�U�k�����{EZq6|*�j�VtI��wg8y�w蝝�;:C��(�0v���i��:����
	��J��e�N!$E��
Y��m�3 �M����J�p��6�Q��Ly��噪�߸%�
EZ^ШV�1��!�yZ�Y4��^��J>I&u���2>��eaE|w4��
 	��u}xj6��CN���+�# �^�J*_ptSQ��IU���Ӧ`7��FӓiBv��'S���B�w��+C�Ih��4%����M�aZ#�#"(�]R����R)�b�Н{��A�e�ο�$�@(�vP�y���u >;��<�7J*u3Ê�&Eǐ7A䖡��M��B6�0�mmIQr�:�����"(�2ĕz��
��^|Y�Y�i`(�{D��݇�Y��0?�/��O�����dpR�A������d�-����p��iL�Qg��FOP�Wcj@���6 ��³���l���[��Ͷ:� ncR�NOXj>���2������{�B�D�~�t72�JF�A����fdM�.�N��(�Xl[�Ӱz�D#�n�\��&�68C�m7w�B	��������-b���JG_I�S.�~�|�R�[���W��[:�d��Z��^+�� ��J�@ ���MCqp����L��6c�brd\D��E�Q1��D�" ���T_N��E��|xz�~�y藻����Ow�?//���?����7�-<K;� R��
�\�Ԗ�tܽ�>�v����	�|���<�yx9�L���?|����?|�����s�6������Xr`]Ԍ��Q k��[����� ��zYM�����ǟv�Mk����t��.r�]�N����y�T���=}|��,,t���px~;�g$g����>+������U�P��X��~�r�$��x��ˋvŲH��>+�����uS�̈́b�uH�M�Xӛ��7�mr	D�LJ�.���j1���ވK��i2�US��Q�Y��v�bo���BF��Xd�/����ͺ�s�V�F��l�������������q�<�b��?�_�3����/T���G-����n8��� lT�c�J��-������b*ͧd��E�����mH�/h�ح�"���a������ɜt�L
�ǃ�3�q�s4'ɦ1�v��[e�1��.pB��#	�jy���4V�G���u��0�Ey�Կ��yU4�̫�������Vdo�ɓ����P��U/p��繊7��H�\�s�O�@T��dOz�vQ���$&�Y4���~�TN��	:��3.����z�O��u�R]�� 'd�}^�������A�M4亊C���ڤQŽ1	d֘�5�-�ɏ�Z�1�v�P B/L7��������IMV�S�z����L������[��SwB�ihw���P�[.�*ꉹ��	�c +�vJw� ��#��z���d/�*�廤8n7] �(�*�ME�tE�-"Q�[t]ԎO;]4��u��'`�	����obrTQΏʫ�!=��U<�fJ�U�ە�A��Ą/5+�bX�Y�E�'��Øa�6eC%0�iTqwz2���F��˧����8S4�@��ڨ�3�}@mJ�Lp�m��f�j�}'l�x�O�֗&�*�XI���$�v]�����Bj���tnC�ǥ��S���GhnVl�安��B�ʚ��L��*.�,�1	�ŹO�MOnp�wҦ�	����ȗ)�����TrH�[��8�:.���P��1Hs���H��b���FPN���!D��TQ���
	'}N�,�2�zP�;ya�GB'VǱ���h81�듶O�\���&9�g��B�r.)��������n��4��vx�~���;��v���}����.���t�?�Nß�]q�w�e-��ipT_�n�X�:8�=Q��\���e6L*�Kv�VT����Ơk��D7X��&Le���uŎb%~�s�M�JAT��}���#�Ry��dQq�����t�S����D�T�N˔�F��(�Tas�qat����*��"S_e#gqQ��"W0]���Tq��)�
jgU���d�H�*�+]B���jO�*.򘮦�D�;�����UY��K�x%���Wи�W��p�Ff%�K��Q����"�y���hTm\ Px�8���@�X�md���tH�b,B�����W���*���0�j�%	Xq����E=)mPV�'�����:�V��N��Fe]�K/b���U��ʺ���fm��l_�D�X�C��M�Q�U���?hTq)C�U\����� "���T2Bm����L��26�hPq��Ί�lMi�Ӱ�+�hTq��Ɋ� *k��Jꭇ��}2��&��h`ֺ/4*�tqZ�w�'W��-���E�q�g
{i�{hZV�i�����t���:�E�2giiX�5�4�2jc%�OF�#�5-tyr�Tɂ�;�i���B�-]F�6KŹ�	��O�5uE��s"^�4,s�dV$K��Ģae@����L�t���y�&$�(�>��K��I��cd�)�������Ӵ��-��x�XQI��/$���E�q�J	O����%a�qb]�|trER���MU�͓0τ�e�f`ي)Р"��t�8�*��X��R�`�8�T
��)9	�)r	���aY��4���Aز���F )Tma�4A���Hw7Ѕn�5�2mJ�t���(M��Cw�։,o��^)�%l�q�ҹ��9�_e�?edn�0�Ȫ��f(�C3�:�!�8N�Cdk����KEdI��Gt$3������ژ������J����Q�z���돀�l����Z�朊��ȸ�\Qq4�l���$,�W�.�}آ�R��!M�X�$�Q��ckMw����:��>d�u����(���W)*��DJ�'t�HX��I� X��`��DY�)�G�Τs6��b\�H�8v%UD���� $[`���="�/�����5�M���Ȕ�8��Q�Gڸ�0��
*"��‥���tM��V;
81q�q�mD��8$K����X�,��iX�@��ȸ6l�\	�Hs]|�ǭb*Ø���X-���9�`j��4G�����scM��Ǝ�ʺ��6�%ʁ���Q	��4����� ̄���p�jg�� �{`�{Y���"QE��Q�6������Y4�I;[�抌rK3�q%G���5 hP�����n;�W�=�һ;��0!,�}7m��0.�-��N��u6@Z��oq�S��D*Y���#F�
o����֊�Q�=QL�1e��3Z� �3��J����:勼���u�Ң�&�Y�3& ��e֒mKK��[�� �/�,U����E���["����N���z��y���L���U���}><=}��y��}�tw�s�6�ϑ����"�1k^����)k{)���3��	�Р�ޖ�r|4�����r|$���J�ohT�W&�e��Ӣ�q�AI�X40��XU\]m��ʺ�.���M�@���6M�-�S�A������ǽ$Lh�'˖Lz�q7V�g���W�ey�gl���q;>]��*n���L�QY�%���GZ�֘�z��ڕ4��]JOW���qN�<���UɈ�;���ߐe�ahx����Z����D��Jq�A�!��ԗt��MT6��5���o��OO'���O�����Uyv�������/���������L;�l�@ο���[�"��2��wO����45����i��/?�рa�̭���7=s�h�iv������|=�'���ZBh�    ����s�񉛕�X�����׷��M����'���y�����'z֯
�tZ��� ݖe��ڋ��2:۶)���
ضW�};9������{{� Փ<��I��[�B�,����o��{K=E���XNS�r3E/�O�?�>}�x|���L��R5^��B�6��RO�\ܜǃ9!��͜$������L8sT^��{(����RO�\n���|C�-����2���x��wO�߿��3A�pqfI/n��~K0�;I������I���O���Eg�E��M����;�����{{�r8z����gSy�3կ�:���%�ҝ����<`!{�<�a��K�S���I9g�
ױ������f	KnGY]����1���=��WodW��S��.+���b�kZ�~�U�J����4��zv���^g�_��f����Uo��1ʂ�R|>�D���9Q4�Ǆ�Y�9�#��A������ݗ�����A�,C����mW����^U�9������*��R�~�B߫u�Ѱ|� ��J>A5Ԯ�.|j{4�
q6|В[@~�\�uT��Qs-�W�
�|�^�ʿe4�U���얌;x�9҈?�!� ĕ|��K3�[�8]zq�9O2�P�P���e61�2��,����B��#V�i[U��ʤm%�5��]ѹC^w-碝m�Eb��a��y�fw�����eY�aQ^`�~�n��!Ij�E�xƺ�J�k�+%a�L"+C�L�$��&$� j�z�ƂW����IQ�̤H��0���`,I�����kƒ׻�f(�ZA0��PR]��6s[8Q� "u3�3ȓH���Q��_��?�36���io��H�#R�|8�!KN��gk��ft��n����{��+L/�\3��la2Cjla��B뱅U����6!��C72ޅ���!ee8�aM㵁0��4�������Ɩ�mBB�j5��ji��M���W�0��Z'�-�Q��W�,i�MH����1/Uv|;+:�������#OJ��bC1�U�DH�������ohr�Hk�8W1pR�j���12�&u���4i����It�#�M����D�0��bfBi��a�\M��[�+BZ�C^�<�ї�_��8'X�i���y�=���*�5��BF�����eRu�ϊ͜�e�ܠ5n�I��#S:Cy�&���b)[�d�1J+�+�Z�m�b�����+g\5'YսBv̀V��5�9�n@�m�K�jC�.�w�erMN�y�9e��U��vRO�oE��fX�s�=�y�d]�7�8�tEɸnkBTj�_�]�����$��s�9�B����h��W�=#�.���.�S�c��+������sk�u���鹬����GT�T!Ɨ�'�5=��C��!�Q��[헢�E���%`7�^�b �	�zTĵ�ƳbпфQ��L��nȤ)��7��\�:#�:O�1S�-��U��-�Ҍ�!�\*zB����c,��ms��a�+Z7�҇\Ѫ��N���S�c���|�dx#�s8Ĵ�L⥚E}�F!�^&q6)3�CO����B����Ci��!��j>����P�q��H�^���IjFr��@1��7�L�C�]$���$x��a��� 7n#e�-q%���@��P���Pj!)�|���/A�!�bj�ШJ�E9������v����;#8�,���}'cW�_?Ĩ����0
e��#�"d�",�&(�Z������� �=�x��#�#,ƌk���n�����������q�~ۇQJ��9=!6��D{��Y(q �n�8@�8�ɋCPlSOhT.�&b@ �Cȸ�ѽ�Ge2a�P�h�ԃXR`�����dnw:oF�e =>��*R4A:v��p�F�@A�*�rH����!7<+��_Gx��4�����|.�����ѤvB$B8C0�m��m�$~�,z4!$��9���Q�J�d�4�҆�K����\�]T;%F�^�ڳ��W;)0�$WPg$5��S~U���_բߜj�"�Z���+��dR_�����K�!>�R_��4��QHaA�0�U���8'!�u��-���o��p⽚� �^.���4�ay+�<X6hT���MM#c�C�F��4�$�2k����Z�n.��T:�y�J¦h��(Nc�g/�X�Yf�0�+H�<W���^�G�X3��WP�#=��o?(�!�ԈҠ:j��Y���!�Ԭ`��!z��}�5��T���:7^��Bt!��K�s�#(�.D.\�8u�\����Bp�ӣ%B�F��u�\�W3�х����&�Cs�Bx��c:�*��]S���%�i�?��'o��H��:7<��/���:W�S��B�^5j���GXr-t�)�u!3��3������R�j�����g��{���4�e�ry�FNNH��ZL?{���������0�6/��O���������-'i�
�>�n F
T�
�ջ�\EE߼�2E���4i�>��P��z�>X7r���Y�v>�i��x��Շe4�>fIR&�i��h���=�᪘ҘS����7El��F�Q�y��G���.{P� 5�ypr)�:�ZK��:{��hx�pV���Ս�VO�J�9e/�h{+�_��S�zC��ռ�7UP��!�����Ĉ4ͅ�n=sadą4#"cH�H-"���v��H��x����k��e�t/�h�wAp����pR���y��6�.��0D��+18�&�<���j|�踜+�)�c����8Rr��/
I��\S?������o<�TI2I'�}�t�����zY^!-�Բ�F�/е�fDYZ_��c�x��/�
��7r��|���3;�i9=7���	B�c��Ϗ�9]FA��7r~���Ѱz��Ql���Y-t����Pl���ʦM�b|�hX�X�PX a1��iX�J!�A�uKIT%S/Ç#(�|8�l�U9b.jŶ��Fe"v��ئZ�����WDT�)�q0������wb�	��2��E�2S
Apr��F}o�Ж��1{ZN�3&��$��o��h�3&h`�H�L*�֕�QF�4BcJJ�����*���(A#1�zFP2<b��$"�d�7M�!A1ƚ^W������f��dҠѩ�����ic>�(��$%"<9��s�_�srэ%� ��b�����f��[h��X�!JoOx�;.ɇfC2���̷j�)����SԂH"1��F̕$����8A+چ�ղ#Dy�UoV]���F��
e��+Fv]&�A!�a�m�|��"Y
I:{�� �M
� �M��I1��t[-�"ѯ��7��y���Q��N���\�F�V�(2��MhTe�h�+:z�R�h4x���?-EqzBZ��MOf~SH�[E���SS4�{�MK���6�P�����js�0Mt�&ĕѤo�*
%�*��1�/��'��L���%�	jY}�0��͹_9t�D�q.�;��P��iy�GN6�,�y0m���8L[V+n���d$�3����m�m�|����X>k��7K��G�i*�z7ow���DUd��������
�j=�#����A�=Tt/���Y�Sڦx�B���+�����aJյh�PN�u�=rѦ͙K83��?MO�x��<��_~�&mC�U�0)ӞL�m�O�[��iz6A��҉���ѝ���z>V�},O&Br�`n�O��`6�B(��"��݊}��#���J� �X4��
'���(�fj̍���jm���~��Ƹ7�1��
h��-Ӡ�K1��|Y-�ݻ���^_H?XU��g�tm����j6��-mza�2y�v�YD��C���Cz&1<i�W�8)�E0�:�`>�wQ�=�������[�����]���rY�m�}ͭ����!�
jF��V�v�qb�w�`�}d�x�4�R}�f`�3��w���ϭб�Y�|H�Q�$�U�y���7'�����?U�۟aE��z�z�nI�NiG�H�2��5c!���b}>��}����
JS��ϲ�_Q����чd���p�3�7�~}�>�u�)&o�!��D��H��Lv������4��6�o �  �/c��@\�'�Qm�![�F��ƋeF!4�Q$���y2,��X4��.o����[��c"+��O��+�@�̅� 0��bX����!��J"u�2���$Q!l�5��i��QFBIK�a �^���h`2�?��g�h`�~#�jH�K�,�!-۵L��p���&OB(�a1�4�ׇ!��j9�6E�h��KcqK�d(]4�-�K�r�nB,.ݖť��h�O�����wz��?Z��Ѩ��$��G4�i�#J�l��C��n�TTo�F�Z~P_��B� '?Ҫ/�ބF~oB_�*B��������0�N�n?�!�x/�2*3'�w��7��w3��!��4k�L]+��3��C�}H/u��fϴ
�i�!��5C�=�0\��C����K(^>!z�.�r�����!z��ѹ;oV!�>�c�T���]�D�R��}H�p6R�А�
h���h,L�6���6וDU�5-�LTH�`E'���O�IB���%�5��r�h�c����Mz{�n��|ԧI+c�΋�i���2M��zH�p���4���Eh�4�kW�QӴ��ɟ�$�n�rEœ��Q��&�S<�zdO����1�ʺ�3��!�4�*�G����t��Li�Cz�*mj'C���lEg�M�՜��M�X�
��^�GY1vf��F�4�ԍ��taQ�����b�C����-M^�gH==�q�%E�3�'���ٸRC��gH�q=�a��:.A,�w�^�Ѣ]�@�Ѯg�7|�A���ڮ��VLf�^Q�%Y�v�P����P��u�}e�����6�V����UH��M_��b�W�0�4݁����C[F�fšW���p�ko� U4~.�qP;E潚�^ߜ�q��mW��2-G��i\��C"��W��0��z!�&$7Z+d�0Z�Dw�'�F�3��}���2CE�
i������� _NP}�FNP��Umci��!�Z�A��q�6�F׋c�~�B9*��4����B�����튌N�0��cAi}�6ay:��s�-4ɮ���zdW��5#����N��ԄE��vj�Q*F6�N�~��I͐�l���")��k����:�	�b�,���^ج���ug,�2.ƐX��� �����3<��5���w@fZK�� UnG�r�[��.��}���YƐf�z,c�wiY���j,5�[�� ��c�ǭV�%�B���E3�\�g� �J�NVHk6���U�
2��-���k8A���VĚ1Y������t��[jBX+虹�+؁.{��P�FM���yg/�
��׊�y�H�*�I;ķ��0�ύVh�m��h�^ضcrh��]�Z�s7Re���W��;8re)P9�
?�_���
�`�� �X�� ��(m�PL��iT����� K�,���B�P�nZ(	P1qM�B1������t�B�C�x� ���XB���..{�Hu	�=00���+��_�	�T�\��~�b�`�D�D�n��M�F���P%�˜p�0��� ��ʇcX�8	�pht�� �G!\��վxN�\k� 6��1���	ƒ,B�n�fXT�1�`ai�|#�=+�@
D�2��p�J����I|�\u)�P%��TB6�pa��a�d����88b{g�57�BvQ�4�P������xrt�F��M%?�m0k_
��Gk���CP�`%�`(�]%��� �|2p8N�L�/�4�,U˟,E�pj��F���mC���
$d�=����h����S���!�T�2��H���/�7�N(_����_�a(]�B���Z�JdXs�m����u�������H��~c�?�|Fw�FN��N6xF?���@�e�N�l�4�!7��j��lJ�-���|��d�lUnuҍN�:���{)j&4��o:��0U%2����b���A�M��ǦL�PE:c��Gg-y��rXM{}V�������禞�� /M�02d�K�c�GT�H�#*��|�R�CO0���!ih|?�[�,y`���f�35�U����k�o��u�73"��dx��d���=����P�y!�2�%C�b�"��.����%?ζb��FU�g�6*�K/��z\-�?7DBLn@s��LnHc&����=���g'�tB�I��;Z3ҐG���u��?�����_���r���V���x:�\��1��6�z�N�*hk�?k�
��..PN�l'�[���qU����*�$�*ψgm��0��_�|(�28=��y�t�\�C19��J�$Db�J='�{vt��&��hZ/���'mx�@n7��
 ��ӌ�5��^�B�c���$�$D`T��Bzث�^�_^�s�	�g�4TU��	�d�"iݗ_3/gn����O �ly �嶂�Fs����� ��7Z�w���RJB|���әO@*�)�`��*�����[�nS��j�k����+��W�������A�~5�r�ݯ���W�m�a���ޥ�����IWd�WQ1��q��)�g6nb�^P�a���U�Ϊ
�p*)���[xwϓ}p�AܭVѬ�
�֪��v�6���a�r�0m�����d��<5���O�0�����^�jY#����ۈT��iD�ƪvQ]�𬥽���vw��ew����/�I4��N^��ZW��o���6�Q˭�O��0�ݻ"��(ִ�ېx�Z��+r����d��\�(ͨ[P�j��[�X��H������"��N[�yjb�����2�Z	 �)e��cH{?=�qFaT���%[1�g��|HH�J�4�X&��@&#O1ه�h�"�3��~�_⾑C�4�Ҭ��CK�U�ΰ�0�ָ�g}����e�ތ*� B|���hn_��!5xFq� ���QRTv�C�v՜�U�Ƀ�6�J�	|m�MOWu*u�V���n���z���������ӟ�?��?�������o��w�S���j �t�c��z�	��/������yfPI$?'�mG�׫����@�c�\��N 6u�jVA9Ǌ~ Y�p!s�yW퓫�����Z�� ��<r[NG��u�����8�χo����������i�÷��I��9�����?�ٽo�q��G,CTC�b����?�꒣�P	�U���r����������r���px~;���'$ծ9#9���H"� �z���M~~�N��Wl3�:�B8;�'T�[�U;w��@u�RJ��\�����MU��M�%3��L���������"jo��1�t�Y^M�[�p�vq���մQ{^U�\I_�J��={�-��,r<{C*�'��zmn���[���>p��D�e�9u��5Ue��Ш��t�F��-�UjT�侩9E�j��(�\���\5q�C�g��I��YhTQ����7fy��~c��2���ns�7f���ҧn�ZBi3a��8Ϲ�B��"�*H�����d��qD��}>F
�F��$���
����ڨ�QY��HTӟ�������v����b�Wyw��v�o$�����1�!�E�wL�˒�#A5�~=UQ]B#%E����XH
m��}�"|K�Q/���d2��)rU.0�*��D��0�;�#�XQ���2��M����t�<�*��	l�3���V�a�֓����⦧�^�6-�l��&�(}\�.�I��j��^\B�lB\d@���u����A����J�,��b�&��Ҩ��d/�>.��R�|��"=,�LUc��Ш�,L���C��ͥ��|g�����]{��i�8]E���?#���#S��Q赲ꐨ�8�VU\�����Y�S\J���ƅ���� �Y�N�ŋ��K�⑅$	�&V�-%��}1'mLM7�T-޻x�
��s U�U�,^	P_��_Y�d�h}J���
Ÿ{ ��`ť�OVm���5(�?�%3�i���<=�k� ��{��1�:8K�I�j��p#$S��l����UIl�5x�")�W%.�!|�������˺�       �   ~  x�m�Mn�0F��Sp�T���T(�$�
 u������ԟdY�Ï����47-1m�I��v��|b�X����t�����4ˀL�@c�yi'd��L�H�\_r�$�9+ce�8ù�G��
2ј�snؤK��0t����$�!��w=��A(��rt��n�%'{ �ӈ�-�d����>�s#qv���Vѣ�!�8�D	�D?P�����Ou�$RsKjN�8=�o$y�Dbi�~�N�?n�g��5��
�IWI�@L$�׺N�tY����0S�y�[;t�,�o����)��.Z z��r9��~n
�6|c�E�v�����Tc�jHy�S��ݔؖ�'$���
�ye#8gL�F�7�_�j~ҍ)������e[�Ö��R�A�t      �   �  x���Mw�N���O���F�n�ՠ��"���oPAE���h"�03�fN8�X�P?���)X���D  IHq���l�]�������7 ��A�1C����[3�2��P�
�R��irj:��l�lz\D�pD��}q�w�����Z�������;ɼD���E����<H :��<��J�7��e	�;��-< @�����RT�����5hOd+t���_��N'Ic���f����H���3�IҎW�6��}�Q�S	s�;�C�s��J(@��(�	����ܿWp�v�4Sil�]�0�� �&�t.���ԙ�/:p���T7�p� �;�C�-�lPkÐE�Y�#9��#^y�C~b���d��"!��4  R�i�"��U9��/�Dv��w@56{���?-T�W�����v�7#q�8���!a�0TE% S<>!UyRwO����s[�͸+��I��-�1���<�oն���O�hq8��\9��N��<��-H�HPk{.f��;���H�w֋�<��b0� }2Qd*P�ޒk|3Aঊן�inW�p�E��-���U?��E����H!311�E߹(ԢQ����p1$�H:�	E+PwWI�L���<��C��7z�V�ťI�So�_H�1)h�1�~'��	kmO"��C���J�XBQ�2Q�0�/�t>�3�Ex��8Y'U��LO���.�]R��i7[_N�K4?��qh�#?�k�ĴUk{2�E)͗#�&��{��d����*Ҭ�!�Kz��S^��̝�g��m'��y��Qצ����-J�j6Ͷ��ٞH�; �!�Yc�
�=���[C�B�J�3��2��p��)w.YG?n�l��q��vמ����pv"�J{^Bz�yl��؞<̽���� E,�'B�}I�^M�*�Vfo�3m���Q�&�4RE
�k\q��w�[]ل��6��!�-��ڪ���Q�l��;Q�UGQՒwwU�ÀO)F�]�"�l���e�X=�e��'�8��"��T�Fg\S�h���-��핉D?db�/�P���y�_�F��&|4��ݓć�����/���+ެ{�O;��I4s�t)!��݂l����|+�{���O��^;�������Y�����y���Ǒ���TXd�eoϥ}=�d����: �׷Z�)�\~�V�k$Iy�%ľ����D�nG+���:߲�I��p;N=�i�ǅs�p�V�\?l7�Z�ĵ(��V-�;�~X hB�|f	�/�p�@v"��*qJ�]<<$`��e�Eqj�y�LBi��^vGds2�5Z����km� �;(��(��b��P%re���EQ�>�2/�2e�]¨�4O��~U5��]b��h��P�H��P��� ��T��|
y\��K9�j�Ƙ{���ˮ��,��(�G3�#K�,�r��H5������Y:��e����R23�:qW��uN�Y�A
P�&Sy���g�����a�(B����sCa�&z�J�6i��?Ӵ��`��É3���r"N%|Z4#�d�{<��Z�8���ou/G����O[u�/@Ly�.���0��W��g�5�(�դ���N\�H���v#l;��tGSeߠW�3YG�d�ig��ˍq1N"�%[[%[����/��GؼR.B�{)�_I55��$8��k����P��&5��>uZ��a���M����*�gX�xA|4�g����_��t)H��Q9j P���J��zV��9?�C,�SU1U3G#�ę�������Q�Y��̩T�X#�i�B_���Tj؟0!��˼����z�J*k4���1����?�݈[٪qY�k0���
�;�Ȝ'����X��u��Py��ʶ*��_��ʦ!�j"�2�Kʫ�]k����]���٧��^8ޙ����������<�n��^/����[��u�*d���t���ʛ�r���<�#O1��ʪ�Y�ӗQY>��'��ܐ�o����wh��[[�vJ�8�\0�����;j�Ӭf?�|�}s���`
!�~��hb\riT��u�5���gb���Q/Ӆux\f�a�sݩ��r����C?3�]��;s_W!��2�a{�_��ρ���2Q�U���-�\��^t{D�٘s��}�ٱ�	�ڱ�l�����Q�SW�_����5�$`^��J���)y�����Ư_��Ȟ[      �   =  x���An�0D�N��2��Yz�s�D��O<�JY=F�0��%/m�{��M4ۑ��a�K�Y�{ӫb9"��T�>R�1̾��'y2�qS��-ud�0���Uc�Wu�1�1� jO�a�z�m�ooDݳ)cp!�Qc�D=Ӟ��ud[z�N�9]����奄|�&gp⥍u�����fecp�ն��\A�����1�Ҏ���^�x)����b�*��_�X���W,����{NnVJۤn;�O����m"�3�1����w����l��o��S���o����8��z:�C|���&[��j��1|����      �      x������ � �      �   o  x�u�ݭ�0F���4�����El��:��4��y:��X��# �?��s�9� ���b(
ƽ�6{�Pl^W��&���ɯ�_�<6�T1� ����G�P��^�iU�8�֛��b���[g�Pl�����>�8�7����
8���*����{��9����������a^���\Y���x���ӻ��󢼯��m��yQy��f���>/���a����h~���o�Y�������0K}^t�����0K\�|�2�_{��0K�~�}F�s��0K�{�q�fiC�� �l{h�0K���I����cU����˼�^���_�fi�9G\;6wy�0K��9�Y�xT� �?��!N      �      x������ � �      �      x������ � �      �      x�ŝ˒�6�Eו_�?�ep�;���X�i��Lӛ�,���߆d��xd&��K�T�*Ƞ_8��a���Р�#���t)˥�����Ə���U�џ�cy������������������w���/�G�nZ�c��/��.i��PL���!����������'���r28�/��S�r*8�/G�/�� ��b�͟>)@���A���C�>Ad�*��,�Yx]�=��
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