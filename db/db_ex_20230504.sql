PGDMP     '                    {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
       public          postgres    false    7    309            �           0    0    calendar_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.calendar_id_seq OWNED BY public.calendar.id;
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
       public          postgres    false    7    212            �           0    0    customers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;
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
       public          postgres    false    216    7            �           0    0    failed_jobs_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;
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
       public          postgres    false    7    223            �           0    0    migrations_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;
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
       public          postgres    false    7    235            �           0    0    permissions_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;
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
       public          postgres    false    7    237            �           0    0    personal_access_tokens_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;
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
       public          postgres    false    244    7            �           0    0    product_brand_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.product_brand_id_seq OWNED BY public.product_brand.id;
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
       public          postgres    false    259    7            �           0    0    product_type_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.product_type_id_seq OWNED BY public.product_type.id;
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
       public          postgres    false    7    265            �           0    0    purchase_master_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.purchase_master_id_seq OWNED BY public.purchase_master.id;
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
       public          postgres    false    7    305            �           0    0    sales_trip_detail_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.sales_trip_detail_id_seq OWNED BY public.sales_trip_detail.id;
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
       public          postgres    false    7    311            �           0    0    sales_visit_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.sales_visit_id_seq OWNED BY public.sales_visit.id;
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
       public          postgres    false    299    7            �           0    0    sv_login_session_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.sv_login_session_id_seq OWNED BY public.login_session.id;
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
    active smallint DEFAULT 1 NOT NULL,
    work_year integer DEFAULT 1 NOT NULL
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
       public          postgres    false    7    286            �           0    0    users_experience_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.users_experience_id_seq OWNED BY public.users_experience.id;
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
       public          postgres    false    291    7            �           0    0    users_shift_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.users_shift_id_seq OWNED BY public.users_shift.id;
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
       public          postgres    false    309    308    309            �           2604    18425 
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
       public          postgres    false    315    316    316            �           2604    30762    petty_cash_detail id    DEFAULT     |   ALTER TABLE ONLY public.petty_cash_detail ALTER COLUMN id SET DEFAULT nextval('public.petty_cash_detail_id_seq'::regclass);
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
       public          postgres    false    302    303    303            �           2604    18765    sales_trip_detail id    DEFAULT     |   ALTER TABLE ONLY public.sales_trip_detail ALTER COLUMN id SET DEFAULT nextval('public.sales_trip_detail_id_seq'::regclass);
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
    pgagent          postgres    false    323   '�      �          0    34389    pga_jobclass 
   TABLE DATA           7   COPY pgagent.pga_jobclass (jclid, jclname) FROM stdin;
    pgagent          postgres    false    325   q�      �          0    34401    pga_job 
   TABLE DATA           �   COPY pgagent.pga_job (jobid, jobjclid, jobname, jobdesc, jobhostagent, jobenabled, jobcreated, jobchanged, jobagentid, jobnextrun, joblastrun) FROM stdin;
    pgagent          postgres    false    327   ��      �          0    34453    pga_schedule 
   TABLE DATA           �   COPY pgagent.pga_schedule (jscid, jscjobid, jscname, jscdesc, jscenabled, jscstart, jscend, jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths) FROM stdin;
    pgagent          postgres    false    331   �      �          0    34483    pga_exception 
   TABLE DATA           J   COPY pgagent.pga_exception (jexid, jexscid, jexdate, jextime) FROM stdin;
    pgagent          postgres    false    333   ��      �          0    34498 
   pga_joblog 
   TABLE DATA           X   COPY pgagent.pga_joblog (jlgid, jlgjobid, jlgstatus, jlgstart, jlgduration) FROM stdin;
    pgagent          postgres    false    335   ��      �          0    34427    pga_jobstep 
   TABLE DATA           �   COPY pgagent.pga_jobstep (jstid, jstjobid, jstname, jstdesc, jstenabled, jstkind, jstcode, jstconnstr, jstdbname, jstonerror, jscnextrun) FROM stdin;
    pgagent          postgres    false    329   !�      �          0    34515    pga_jobsteplog 
   TABLE DATA           |   COPY pgagent.pga_jobsteplog (jslid, jsljlgid, jsljstid, jslstatus, jslresult, jslstart, jslduration, jsloutput) FROM stdin;
    pgagent          postgres    false    337   ��      M          0    17914    branch 
   TABLE DATA           a   COPY public.branch (id, remark, address, city, abbr, created_at, updated_at, active) FROM stdin;
    public          postgres    false    206   ��      O          0    17924    branch_room 
   TABLE DATA           T   COPY public.branch_room (id, branch_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    208   ��      �          0    18720    branch_shift 
   TABLE DATA           o   COPY public.branch_shift (id, branch_id, shift_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    297    �      �          0    26919    calendar 
   TABLE DATA           k   COPY public.calendar (id, dated, week, period, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    309   i�      �          0    34637    cashier_commision 
   TABLE DATA           �   COPY public.cashier_commision (branch_name, created_by, created_name, invoice_no, dated, type_id, id, com_type, product_id, abbr, product_name, price, qty, total, base_commision, commisions, branch_id) FROM stdin;
    public          postgres    false    339   @�      Q          0    17933    company 
   TABLE DATA           p   COPY public.company (id, remark, address, city, email, phone_no, icon_file, updated_at, created_at) FROM stdin;
    public          postgres    false    210   T�      S          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    212   ��      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    307   �W      �          0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    313   �W      U          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    214   �W      W          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    216   }X      Y          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at) FROM stdin;
    public          postgres    false    218   �X      �          0    34018    invoice_detail_log 
   TABLE DATA             COPY public.invoice_detail_log (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, created_at_insert) FROM stdin;
    public          postgres    false    322   �^      �          0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    319   ��      Z          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    219   U|      \          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    221   �{      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    299   �|      ^          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    223   �|      `          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    225   ��      a          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    226   ��      b          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    227   W�      c          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    228   t�      e          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    230   ��      f          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    231   ��      g          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    232   �      i          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    234   #�      j          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    235   ��      l          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    237   ��      �          0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    316   ��      �          0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    318   �       n          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    239         o          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    240   j      q          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    242   �      s          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    244   �      u          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    246   �      w          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248         x          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    249   *      y          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    250   �       z          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    251   �%      {          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    252   �'      |          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    253   K)      �          0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    314   �.      }          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    254   �.                0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    256   �C      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    257   XJ      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    259   �J      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    261   LK      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    264   �S      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    265   �T      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    267   mU      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    268   �U      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    270   sV      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    271   �V      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    273   �V      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    274   _      �          0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    301   �_      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    303   �_      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   �_      �          0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    311   `      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   3`      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    278   b      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    279   nb      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    280   �b      �          0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    321   zc      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   -�      �          0    34580    terapist_commision 
   TABLE DATA           �   COPY public.terapist_commision (branch_name, dated, invoice_no, product_id, abbr, product_name, type_id, user_id, terapist_name, com_type, work_year, price, qty, total, base_commision, commisions, point_qty, point_value, branch_id) FROM stdin;
    public          postgres    false    338   }�      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    262   �	      �          0    18363    users 
   TABLE DATA           U  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active, work_year) FROM stdin;
    public          postgres    false    284   d	      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    285    !	      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    286   m"	      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    289   �"	      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    291   	$	      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   &$	      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    294   C$	      �           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    207            �           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    209            �           0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    296            �           0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    308                        0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    211                       0    0    customers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.customers_id_seq', 1595, true);
          public          postgres    false    213                       0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    306                       0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    312                       0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    215                       0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    217                       0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 2251, true);
          public          postgres    false    220                       0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    222                       0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    224            	           0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    229            
           0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2652, true);
          public          postgres    false    233                       0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 515, true);
          public          postgres    false    236                       0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    238                       0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 426, true);
          public          postgres    false    317                       0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 61, true);
          public          postgres    false    315                       0    0    posts_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.posts_id_seq', 2, true);
          public          postgres    false    241                       0    0    price_adjustment_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.price_adjustment_id_seq', 8, true);
          public          postgres    false    243                       0    0    product_brand_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.product_brand_id_seq', 22, true);
          public          postgres    false    245                       0    0    product_category_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.product_category_id_seq', 52, true);
          public          postgres    false    247                       0    0    product_sku_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.product_sku_id_seq', 338, true);
          public          postgres    false    255                       0    0    product_stock_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.product_stock_detail_id_seq', 25, true);
          public          postgres    false    258                       0    0    product_type_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_type_id_seq', 8, true);
          public          postgres    false    260                       0    0    product_uom_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.product_uom_id_seq', 54, true);
          public          postgres    false    263                       0    0    purchase_master_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.purchase_master_id_seq', 21, true);
          public          postgres    false    266                       0    0    receive_master_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.receive_master_id_seq', 32, true);
          public          postgres    false    269                       0    0    return_sell_master_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.return_sell_master_id_seq', 1, false);
          public          postgres    false    272                       0    0    roles_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.roles_id_seq', 13, true);
          public          postgres    false    275                       0    0    sales_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.sales_id_seq', 1, true);
          public          postgres    false    300                       0    0    sales_trip_detail_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.sales_trip_detail_id_seq', 21, true);
          public          postgres    false    304                       0    0    sales_trip_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.sales_trip_id_seq', 4, true);
          public          postgres    false    302                       0    0    sales_visit_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.sales_visit_id_seq', 1, false);
          public          postgres    false    310                       0    0    setting_document_counter_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.setting_document_counter_id_seq', 52, true);
          public          postgres    false    277                        0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 12, true);
          public          postgres    false    281            !           0    0    stock_log_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stock_log_id_seq', 6417, true);
          public          postgres    false    320            "           0    0    suppliers_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.suppliers_id_seq', 5, true);
          public          postgres    false    283            #           0    0    sv_login_session_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.sv_login_session_id_seq', 71, true);
          public          postgres    false    298            $           0    0    users_experience_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.users_experience_id_seq', 2, true);
          public          postgres    false    287            %           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 89, true);
          public          postgres    false    288            &           0    0    users_mutation_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.users_mutation_id_seq', 72, true);
          public          postgres    false    290            '           0    0    users_shift_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.users_shift_id_seq', 134, true);
          public          postgres    false    292            (           0    0    voucher_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.voucher_id_seq', 1226, true);
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
       public            postgres    false    309                       2606    18465    company company_pk 
   CONSTRAINT     P   ALTER TABLE ONLY public.company
    ADD CONSTRAINT company_pk PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.company DROP CONSTRAINT company_pk;
       public            postgres    false    210                       2606    18467    customers customers_pk 
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
       public            postgres    false    313                       2606    18469    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public            postgres    false    216                       2606    18471 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public            postgres    false    216            	           2606    18473     invoice_detail invoice_detail_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_pk PRIMARY KEY (invoice_no, product_id);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_pk;
       public            postgres    false    218    218                       2606    18475     invoice_master invoice_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_pk;
       public            postgres    false    219                       2606    18477     invoice_master invoice_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_un UNIQUE (invoice_no);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_un;
       public            postgres    false    219                       2606    18479    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public            postgres    false    223                       2606    18481 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public            postgres    false    225    225    225                       2606    18483 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public            postgres    false    226    226    226            �           2606    34649    cashier_commision newtable_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.cashier_commision
    ADD CONSTRAINT newtable_pk PRIMARY KEY (branch_name, invoice_no, dated, type_id, com_type, product_id, branch_id);
 G   ALTER TABLE ONLY public.cashier_commision DROP CONSTRAINT newtable_pk;
       public            postgres    false    339    339    339    339    339    339    339                       2606    18485    order_detail order_detail_pk 
   CONSTRAINT     l   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_pk PRIMARY KEY (order_no, product_id);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_pk;
       public            postgres    false    227    227                       2606    18487    order_master order_master_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_pk;
       public            postgres    false    228                       2606    18489    order_master order_master_un 
   CONSTRAINT     [   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_un UNIQUE (order_no);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_un;
       public            postgres    false    228                       2606    18491    period_stock period_stock_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.period_stock
    ADD CONSTRAINT period_stock_pk PRIMARY KEY (periode, branch_id, product_id);
 F   ALTER TABLE ONLY public.period_stock DROP CONSTRAINT period_stock_pk;
       public            postgres    false    234    234    234                        2606    18493    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public            postgres    false    235            "           2606    18495 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public            postgres    false    237            $           2606    18497 :   personal_access_tokens personal_access_tokens_token_unique 
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
       public            postgres    false    316            '           2606    18499 $   point_conversion point_conversion_pk 
   CONSTRAINT     i   ALTER TABLE ONLY public.point_conversion
    ADD CONSTRAINT point_conversion_pk PRIMARY KEY (point_qty);
 N   ALTER TABLE ONLY public.point_conversion DROP CONSTRAINT point_conversion_pk;
       public            postgres    false    239            )           2606    18501    posts posts_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_pkey;
       public            postgres    false    240            +           2606    18503 $   price_adjustment price_adjustment_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_pk PRIMARY KEY (branch_id, product_id, dated_start);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_pk;
       public            postgres    false    242    242    242            -           2606    18505 $   price_adjustment price_adjustment_un 
   CONSTRAINT     ]   ALTER TABLE ONLY public.price_adjustment
    ADD CONSTRAINT price_adjustment_un UNIQUE (id);
 N   ALTER TABLE ONLY public.price_adjustment DROP CONSTRAINT price_adjustment_un;
       public            postgres    false    242            /           2606    18507 6   product_commision_by_year product_commision_by_year_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_pk PRIMARY KEY (product_id, branch_id, jobs_id, years);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_pk;
       public            postgres    false    248    248    248    248            1           2606    18509 (   product_commisions product_commisions_pk 
   CONSTRAINT     y   ALTER TABLE ONLY public.product_commisions
    ADD CONSTRAINT product_commisions_pk PRIMARY KEY (product_id, branch_id);
 R   ALTER TABLE ONLY public.product_commisions DROP CONSTRAINT product_commisions_pk;
       public            postgres    false    249    249            3           2606    18511 ,   product_distribution product_distribution_pk 
   CONSTRAINT     }   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_pk PRIMARY KEY (product_id, branch_id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_pk;
       public            postgres    false    250    250            5           2606    18513 *   product_ingredients product_ingredients_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pk PRIMARY KEY (product_id, product_id_material);
 T   ALTER TABLE ONLY public.product_ingredients DROP CONSTRAINT product_ingredients_pk;
       public            postgres    false    251    251            7           2606    18515    product_point product_point_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_point
    ADD CONSTRAINT product_point_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_point DROP CONSTRAINT product_point_pk;
       public            postgres    false    252    252            �           2606    30130 *   product_price_level product_price_level_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.product_price_level
    ADD CONSTRAINT product_price_level_pk PRIMARY KEY (product_id, branch_id, qty_min);
 T   ALTER TABLE ONLY public.product_price_level DROP CONSTRAINT product_price_level_pk;
       public            postgres    false    314    314    314            9           2606    18517    product_price product_price_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_price
    ADD CONSTRAINT product_price_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_price DROP CONSTRAINT product_price_pk;
       public            postgres    false    253    253            ;           2606    18519    product_sku product_sku_pk 
   CONSTRAINT     X   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_pk PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_pk;
       public            postgres    false    254            =           2606    18521    product_sku product_sku_un 
   CONSTRAINT     U   ALTER TABLE ONLY public.product_sku
    ADD CONSTRAINT product_sku_un UNIQUE (abbr);
 D   ALTER TABLE ONLY public.product_sku DROP CONSTRAINT product_sku_un;
       public            postgres    false    254            A           2606    18523 ,   product_stock_detail product_stock_detail_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.product_stock_detail
    ADD CONSTRAINT product_stock_detail_pk PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.product_stock_detail DROP CONSTRAINT product_stock_detail_pk;
       public            postgres    false    257            ?           2606    18525    product_stock product_stock_pk 
   CONSTRAINT     o   ALTER TABLE ONLY public.product_stock
    ADD CONSTRAINT product_stock_pk PRIMARY KEY (product_id, branch_id);
 H   ALTER TABLE ONLY public.product_stock DROP CONSTRAINT product_stock_pk;
       public            postgres    false    256    256            C           2606    29118    product_type product_type_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY public.product_type
    ADD CONSTRAINT product_type_pk PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.product_type DROP CONSTRAINT product_type_pk;
       public            postgres    false    259            E           2606    18527    product_uom product_uom_pk 
   CONSTRAINT     h   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_pk PRIMARY KEY (product_id, uom_id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_pk;
       public            postgres    false    261    261            K           2606    18529 "   purchase_detail purchase_detail_pk 
   CONSTRAINT     u   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_pk PRIMARY KEY (purchase_no, product_id);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_pk;
       public            postgres    false    264    264            M           2606    18531 "   purchase_master purchase_master_pk 
   CONSTRAINT     `   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_pk PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_pk;
       public            postgres    false    265            O           2606    18533 "   purchase_master purchase_master_un 
   CONSTRAINT     d   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_un UNIQUE (purchase_no);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_un;
       public            postgres    false    265            Q           2606    18535     receive_detail receive_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_pk PRIMARY KEY (receive_no, product_id, expired_at);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_pk;
       public            postgres    false    267    267    267            S           2606    18537     receive_master receive_master_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_pk;
       public            postgres    false    268            U           2606    18539     receive_master receive_master_un 
   CONSTRAINT     a   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_un UNIQUE (receive_no);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_un;
       public            postgres    false    268            W           2606    18541 (   return_sell_detail return_sell_detail_pk 
   CONSTRAINT     ~   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_pk PRIMARY KEY (return_sell_no, product_id);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_pk;
       public            postgres    false    270    270            Y           2606    18543 (   return_sell_master return_sell_master_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_pk PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_pk;
       public            postgres    false    271            [           2606    18545 (   return_sell_master return_sell_master_un 
   CONSTRAINT     m   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_un UNIQUE (return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_un;
       public            postgres    false    271            ]           2606    18547 .   role_has_permissions role_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);
 X   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_pkey;
       public            postgres    false    273    273            _           2606    18549 "   roles roles_name_guard_name_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);
 L   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_name_guard_name_unique;
       public            postgres    false    274    274            a           2606    18551    roles roles_pkey 
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
       public            postgres    false    311            c           2606    18553 4   setting_document_counter setting_document_counter_pk 
   CONSTRAINT     r   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_pk PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_pk;
       public            postgres    false    276            e           2606    18555 4   setting_document_counter setting_document_counter_un 
   CONSTRAINT     ~   ALTER TABLE ONLY public.setting_document_counter
    ADD CONSTRAINT setting_document_counter_un UNIQUE (doc_type, branch_id);
 ^   ALTER TABLE ONLY public.setting_document_counter DROP CONSTRAINT setting_document_counter_un;
       public            postgres    false    276    276            g           2606    18557    settings settings_pk 
   CONSTRAINT     f   ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pk PRIMARY KEY (company_name, app_name);
 >   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pk;
       public            postgres    false    278    278            i           2606    18559    shift shift_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pk PRIMARY KEY (time_start, time_end);
 8   ALTER TABLE ONLY public.shift DROP CONSTRAINT shift_pk;
       public            postgres    false    279    279            �           2606    33402    stock_log stock_log_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.stock_log
    ADD CONSTRAINT stock_log_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.stock_log DROP CONSTRAINT stock_log_pk;
       public            postgres    false    321            k           2606    18561    suppliers suppliers_pk 
   CONSTRAINT     T   ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pk PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.suppliers DROP CONSTRAINT suppliers_pk;
       public            postgres    false    282                       2606    18733 #   login_session sv_login_session_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.login_session
    ADD CONSTRAINT sv_login_session_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY public.login_session DROP CONSTRAINT sv_login_session_pkey;
       public            postgres    false    299            �           2606    34590 (   terapist_commision terapist_commision_pk 
   CONSTRAINT     �   ALTER TABLE ONLY public.terapist_commision
    ADD CONSTRAINT terapist_commision_pk PRIMARY KEY (dated, invoice_no, product_id, type_id, user_id, com_type, branch_id);
 R   ALTER TABLE ONLY public.terapist_commision DROP CONSTRAINT terapist_commision_pk;
       public            postgres    false    338    338    338    338    338    338    338            G           2606    18563 
   uom uom_pk 
   CONSTRAINT     H   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_pk;
       public            postgres    false    262            I           2606    18565 
   uom uom_un 
   CONSTRAINT     G   ALTER TABLE ONLY public.uom
    ADD CONSTRAINT uom_un UNIQUE (remark);
 4   ALTER TABLE ONLY public.uom DROP CONSTRAINT uom_un;
       public            postgres    false    262            s           2606    18567    users_branch users_branch_pk 
   CONSTRAINT     j   ALTER TABLE ONLY public.users_branch
    ADD CONSTRAINT users_branch_pk PRIMARY KEY (user_id, branch_id);
 F   ALTER TABLE ONLY public.users_branch DROP CONSTRAINT users_branch_pk;
       public            postgres    false    285    285            m           2606    18569    users users_email_unique 
   CONSTRAINT     T   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_unique;
       public            postgres    false    284            u           2606    18571 $   users_experience users_experience_pk 
   CONSTRAINT     b   ALTER TABLE ONLY public.users_experience
    ADD CONSTRAINT users_experience_pk PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.users_experience DROP CONSTRAINT users_experience_pk;
       public            postgres    false    286            w           2606    18573     users_mutation users_mutation_pk 
   CONSTRAINT     ^   ALTER TABLE ONLY public.users_mutation
    ADD CONSTRAINT users_mutation_pk PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.users_mutation DROP CONSTRAINT users_mutation_pk;
       public            postgres    false    289            o           2606    18575    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    284            y           2606    18577    users_shift users_shift_pk 
   CONSTRAINT     z   ALTER TABLE ONLY public.users_shift
    ADD CONSTRAINT users_shift_pk PRIMARY KEY (branch_id, users_id, dated, shift_id);
 D   ALTER TABLE ONLY public.users_shift DROP CONSTRAINT users_shift_pk;
       public            postgres    false    291    291    291    291            {           2606    18579    users_skills users_skills_pk 
   CONSTRAINT     v   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_pk PRIMARY KEY (users_id, modul, dated, status);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_pk;
       public            postgres    false    293    293    293    293            q           2606    18581    users users_username_unique 
   CONSTRAINT     Z   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_unique UNIQUE (username);
 E   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_unique;
       public            postgres    false    284            }           2606    18583    voucher voucher_pk 
   CONSTRAINT     e   ALTER TABLE ONLY public.voucher
    ADD CONSTRAINT voucher_pk PRIMARY KEY (voucher_code, branch_id);
 <   ALTER TABLE ONLY public.voucher DROP CONSTRAINT voucher_pk;
       public            postgres    false    294    294                       1259    18584 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public            postgres    false    225    225                       1259    18585 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public            postgres    false    226    226                       1259    18586    password_resets_email_index    INDEX     X   CREATE INDEX password_resets_email_index ON public.password_resets USING btree (email);
 /   DROP INDEX public.password_resets_email_index;
       public            postgres    false    230            %           1259    18587 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public            postgres    false    237    237            �           2606    18588    branch_room branch_room_fk_1    FK CONSTRAINT     ~   ALTER TABLE ONLY public.branch_room
    ADD CONSTRAINT branch_room_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 F   ALTER TABLE ONLY public.branch_room DROP CONSTRAINT branch_room_fk_1;
       public          postgres    false    208    206    3579            �           2606    18593     invoice_detail invoice_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_detail
    ADD CONSTRAINT invoice_detail_fk FOREIGN KEY (invoice_no) REFERENCES public.invoice_master(invoice_no);
 J   ALTER TABLE ONLY public.invoice_detail DROP CONSTRAINT invoice_detail_fk;
       public          postgres    false    218    219    3597            �           2606    18598     invoice_master invoice_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk;
       public          postgres    false    219    284    3695            �           2606    18603 "   invoice_master invoice_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_master
    ADD CONSTRAINT invoice_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 L   ALTER TABLE ONLY public.invoice_master DROP CONSTRAINT invoice_master_fk_1;
       public          postgres    false    219    212    3587            �           2606    18608 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public          postgres    false    225    235    3616            �           2606    18613 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public          postgres    false    226    274    3681            �           2606    18618    order_detail order_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_detail
    ADD CONSTRAINT order_detail_fk FOREIGN KEY (order_no) REFERENCES public.order_master(order_no);
 F   ALTER TABLE ONLY public.order_detail DROP CONSTRAINT order_detail_fk;
       public          postgres    false    227    228    3611            �           2606    18623    order_master order_master_fk    FK CONSTRAINT     ~   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk;
       public          postgres    false    228    284    3695            �           2606    18628    order_master order_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_master
    ADD CONSTRAINT order_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 H   ALTER TABLE ONLY public.order_master DROP CONSTRAINT order_master_fk_1;
       public          postgres    false    228    212    3587            �           2606    18633    posts posts_user_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.posts DROP CONSTRAINT posts_user_id_foreign;
       public          postgres    false    240    284    3695            �           2606    18638 6   product_commision_by_year product_commision_by_year_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 `   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk;
       public          postgres    false    248    254    3643            �           2606    18643 8   product_commision_by_year product_commision_by_year_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_1 FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_1;
       public          postgres    false    248    206    3579            �           2606    18648 8   product_commision_by_year product_commision_by_year_fk_2    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_commision_by_year
    ADD CONSTRAINT product_commision_by_year_fk_2 FOREIGN KEY (created_by) REFERENCES public.users(id);
 b   ALTER TABLE ONLY public.product_commision_by_year DROP CONSTRAINT product_commision_by_year_fk_2;
       public          postgres    false    248    284    3695            �           2606    18653 ,   product_distribution product_distribution_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk FOREIGN KEY (branch_id) REFERENCES public.branch(id);
 V   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk;
       public          postgres    false    250    206    3579            �           2606    18658 .   product_distribution product_distribution_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_distribution
    ADD CONSTRAINT product_distribution_fk_1 FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 X   ALTER TABLE ONLY public.product_distribution DROP CONSTRAINT product_distribution_fk_1;
       public          postgres    false    250    254    3643            �           2606    18663    product_uom product_uom_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.product_uom
    ADD CONSTRAINT product_uom_fk FOREIGN KEY (product_id) REFERENCES public.product_sku(id);
 D   ALTER TABLE ONLY public.product_uom DROP CONSTRAINT product_uom_fk;
       public          postgres    false    261    254    3643            �           2606    18668 "   purchase_detail purchase_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_detail
    ADD CONSTRAINT purchase_detail_fk FOREIGN KEY (purchase_no) REFERENCES public.purchase_master(purchase_no);
 L   ALTER TABLE ONLY public.purchase_detail DROP CONSTRAINT purchase_detail_fk;
       public          postgres    false    264    265    3663            �           2606    18673 "   purchase_master purchase_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.purchase_master
    ADD CONSTRAINT purchase_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 L   ALTER TABLE ONLY public.purchase_master DROP CONSTRAINT purchase_master_fk;
       public          postgres    false    265    284    3695            �           2606    18678     receive_detail receive_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_detail
    ADD CONSTRAINT receive_detail_fk FOREIGN KEY (receive_no) REFERENCES public.receive_master(receive_no);
 J   ALTER TABLE ONLY public.receive_detail DROP CONSTRAINT receive_detail_fk;
       public          postgres    false    267    268    3669            �           2606    18683     receive_master receive_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.receive_master
    ADD CONSTRAINT receive_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 J   ALTER TABLE ONLY public.receive_master DROP CONSTRAINT receive_master_fk;
       public          postgres    false    268    284    3695            �           2606    18688 (   return_sell_detail return_sell_detail_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_detail
    ADD CONSTRAINT return_sell_detail_fk FOREIGN KEY (return_sell_no) REFERENCES public.return_sell_master(return_sell_no);
 R   ALTER TABLE ONLY public.return_sell_detail DROP CONSTRAINT return_sell_detail_fk;
       public          postgres    false    270    271    3675            �           2606    18693 (   return_sell_master return_sell_master_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk FOREIGN KEY (created_by) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk;
       public          postgres    false    271    284    3695            �           2606    18698 *   return_sell_master return_sell_master_fk_1    FK CONSTRAINT     �   ALTER TABLE ONLY public.return_sell_master
    ADD CONSTRAINT return_sell_master_fk_1 FOREIGN KEY (customers_id) REFERENCES public.customers(id);
 T   ALTER TABLE ONLY public.return_sell_master DROP CONSTRAINT return_sell_master_fk_1;
       public          postgres    false    271    3587    212            �           2606    18703 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public          postgres    false    273    3616    235            �           2606    18708 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public          postgres    false    3681    274    273            �           2606    18713    users_skills users_skills_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.users_skills
    ADD CONSTRAINT users_skills_fk FOREIGN KEY (users_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.users_skills DROP CONSTRAINT users_skills_fk;
       public          postgres    false    3695    293    284            �   :   x�3�0767��4202�50�5�P02�2"S=3#3ccms�0_�����R�=... �
�      �      x������ � �      �   v   x���1�0����+n�����4�Qtur,H�b�-���}����z�>������r���։!�J
���ʀKv�(�u��?:�����]��E�TPwKn9�}-��a�!�7��#9      �   `   x�3�4�t-K-�TpI�T00�20��,�4202�50�5�T00�#ms������!A�B���tH�%$��kQm&�\��$��'�6��+F��� G7b�      �      x������ � �      �   p   x�m�1
�0D��:E�!�d��YR�{X��&���mڮ��j���+�`T�m��x8�+�� ��x����(�A���irJ�G!�?ѣb���i���?��Ҥ�����'b      �   �   x�����0���)\:������MHj�)TZx{��]cn�sߟ�}	p����&϶ J0�P�6�ko]ʓu�����NjJ�oꁬg�|��_.-��gմ�F�^S4�u#U�f�U��r�;�_�YIG�%;!���=�Y~���
�C�?�ܫ���U��#m���ߕi�θ� x ��ld      �   �   x�u�Ok�0������Y��Ƿ����(^�t�����3�)�C��I?=�d��T�����:@�����$�e��+ҭE�h�b}�ҼdxM)&}XΧq�.�]b~�s�#�.�o�z���)��rq�W0���Goǯ���>���y܍���lkYWK\�9���C81z����Rb�����q�TAV��Xc�FwJ�gL�d�L?���u[���F!��qS@�l�<`Űe���?e�c�      M   �   x�m��
�0D�7_q?@%�jv�(>�Q���d�b���i�v���p�#����ő�j���{�ϗ��)|�� ��1/b.P�*+ϓ,���a7 ��@���]����\ݰ�Aj�i�LI�#�NO�b�-�8�v��d*�8�8
��?�A$�yp�Pp��T^������6      O   _  x�m�Qj�0����"�$�I����Z:];���1�-C�y��gɖ�;��t>���8���C�(ZJH%���TB�(+Ml��7�k{;l�S's���@ˣiJ�L��@�iΗ"�c�p3_��-UJr��f�%,��L��s4��(-ڐh��>.��d�1�'��w�P�Xxg�>.<��.�����Xeg�Y{N�8{�hϩ)���x����Bv�:��91�2iϼA������p�q:�����654�wo�lN��؛�j��g�W��x�A��L�����z�����A��Rǚ��r��AV�����C��x��P7�HJs�%������Z�#�      �   9   x�3�44�44���4202�50�54U04�24�2��!�e�e�U���0W� ���      �      x���ݍ,����]+��
��!��3̯# =��: ��
�y�d��O����ɿ��y���������g���s���������Y��a����a�ɇӂ����C>��i�x����Ldz��|�t$����H���ӑ��gs$	��iI"��Ӓd��#�}��$�~��$�����h?Z�ŧ�?-yG�����)ɆLOvd��@vON���B���ir#�'r[�?���(I�j�ѷ�$C��&�Чo�#�Чo-I�>}kI2D�j�ѷ�$C��$�o5�hsYO�`��-9�h۫��$��Ld�dCvOv���@V�ir"�'r{r#�'OIL���`�$C4�&��I2D�i��`�$C4�&��I2D�i��`�܌��$���4�h�x��3c��!��k�s?����Ldz�!�ו&;�{r �''rzr!�'7r{� �%�y�F��))�0)1�4)9�sEJ�(]��$ZW�D���h0������s���4)�zEJ��^��W�I�i_�ޏǷD��ф�I���C�It�tB�It�tCk�!�=�՟�*S��&�T���2)i�LEJ�(S�v�5�)�fRL����S�"%���H�?e*R�O�������A��cR���27M���S��&��f��&�К��tA�I7t��@�GkQh�zX�Q�)i��5�p�4D�8�2��zX�ğ)�EJ��a����C��.���ݤ�)i��EzӴ^e�4ڠi��i�H��tB�It�tC�It{�֊֫LEʀ��!"e��-��LEE)S��T�ğ2)�LEJ��[]>�?�I�?e*R�D���4Q��D���4Q�"%M-��.�]����_�5ڡi�m&��n�&����d�Q��2�&e�1Mz�ˣ�.�_=,Ҁ�fQzX��?k"R�iR�ͤ��)i��EJ��a��&zX��4���N��4�Ǥ���eZ�F���G��&�������f0"e��&e��L��ݤ:Lz�ӣ�.q^=,Ҁ�F�	=&mE�1)i��EJ��a��&zX���)i��=t�4���"M�LJ��a��&zX����o��L?3s��u�/������W��t@Ӥ�L��ݤ:Lz�w"һ.�ˤ�&%MU�*%MU�*%MU�*%MU�*%Mټ��&%MU�*%MU�mi�2U)i�2U)i�2�]��`P���L��m�=&�E�a�h�tBӤz�!*��n�M�D��4��"%M��HI=,R�TۂTJ�j_�JISmR)i��EJ��a��&zX��4��"�~��	qGҁ��u��W��4�ˤ	�&m�c�^�2��4D��&]�fR�D���4Q��65�D���4Q�"%M���JIS�0�R�D���4Q�"%M��HIe*R�D��������w��-�?�?4M��ͤ�=��.�C�I:M��e����ȴC�IGѻ_I�����LI��a�����2%M��U�I�}}^���>/S�t�-ɔ4��)i�=,S�t{X�����J���˔���eʀ�Y��Ɵ�]ݔ��i�m���&��H:Mڠˤ�M:�Ǥ�(=,R�D��4�7�eJ���*�t߼�)i��EJ��a��&zX���O4`�9��.p.�2���L�?=,���jDi+h�M�nh3��\B���t�4�ˤ�MڡǤ�(�(R�5�)i�EJ�hD��&Q��4ш"%M4�HI�����sx�`�4�H0�(R�O#���ӈ"%��LEJ��Y�������߇N�N�ǆ�I�yt>�nҀ�&t��A�I;��"�c�Y4��&zX���)i��5�H=,R�5)���̀������"%���H�?=,R�O������M��c���*SiOh��&=����@�I:L�К���A�I;t�t@�IgQ�T���2)i�L%:�5)�0)�LEJ�)S��LEJ�)S��T��?��Ѝ ��MJ�)S��&�T���n���M�|����tā�G��4D��&M�0i�N�v�2�n�N��hc�Q��2��&e�qL����"%���H�?=��N��a����C׉���&%M��HI=,R�D��4��"�i����������~���Z4Z�2i@�I:LڠӤ�<:p�4D�8�I0e*��&��c�U�2)�LEJ���]�?�I�?e*R�D���4Q�"%M��HIe*RҔ�{�ij�IIS3˴�����=������E�f҄v�5)�fRݤ:LڡӤ�L:�ۤZ�������߽H"�i��EJ��a��&zX���)i�i=t�!M�LJ�r��4��"%M��HIS��t֢�y����tֺĩ��ez����d�&h�4�ͤ�MڡäZ3�N�2�n��&zX����h#M��HI=,RҔ�{�i�nRҔä��)i��EJ��a��&zX�w]���NC����K|�6����U�"����2h�4�ͤz�!*��a��&%MU�*%MU�*%MU�*%MU�"���ށW)i�{�dJ��LUJ��LUJ��LUJ��LUJ��LEz�%�;��4D�N:�ė�N�4�.�n�6���u��{��NCT��4i�6��&zX���)i��EJ��a���z^����"����ڋ�R�D��4��"%M��HI=�]�{�%ⵡH�N��D�6��C�It�tB�It�tC�I��!����P�Ҁ�IIe*R�D���4Q�"%M��HIS�>�R�T�ϫ�4Q�"%M��F�4Q�"%M��HIe��ƀ��y�2�z}^�<�|�K�x)�Ϻ�M�vh3�v�N�0��NCd��ˤ�=��2�=&����eJ�n˔4��)i���˔4���eJ��6&�����2%M��eJ�n�t����2e���y�2����J'�ۘdJ�o˔�7�L�?쇶u�M�h��H'��tA�I7t��@�G��&�1i�o�˔4�7�eJ���2%M��HI=,R�D��4���8���m�ä��y/S�Ok�zX�7��Uk�e�'�i��Zi�v��0�N�.�2�n���~��ԚHI�&R�D���4Qk"%MԚHI�&R�D�i40�&RL���Sk"%�ԚH�?�&R���R�I��^����E2����<E�=�;4Mڡͤ�M:�ä:M����L��=��1i��EJ��a��&zX����hg�Y��2�L�2�l&%���H�?=,R�O�����"%����n�<&%��1�M�x����s�M�vh3�v�NhMCD��Ӥ�Lz�ۣ�h4^e*�(J���4Q�]8j"R��I0e*R�O����S�"%���H�?e*R��{���eR�O�jt�&�T���2)ibR+қ���aiO��Z��h3�v�.�0�N���h-�W��GMCDʀcY�<8�IzL�E�a�zX�ğ)��f=t�!��MJ�s��4��"%M��F�4��"%M��HIS{����M�䇶��Ԣ�z��H��tB�It�tC�G�GMCDʀc��S�"=���Z�X�2i@�I�(e*R�wɔ�g���S�"%M��HIe*R�D���4Q���)���uҔǤ��2)ijf�֢�~�����Ԣ�~��H'�yt0�i�Hp�Ip4�.h7����h�K�W�4�5iB�I[�|LJ��a��&zX���)i��EJ�rx�$M9=�HS.��&zX���)i��EJ��Y��.q�yj#m'=�.�.y����t@ä�&]�f��&=К�h��%�%/Ӏ.��&zX���)i��EJ��a����i�HIS6����&%M��D�y�E�Z�D��@QŢ�kߍ�w*�m)���.�&v��a�k{�*U�l�vbӵ{g$����ڃ�MrU�*[rU�*[rU�*[rU�*[ru��\�=F�%WU��%Wհ�%WU��%Wձ�m�:V�w��N#m���l7�]�xm��m`�k�\۰۵{\;�ֆ#�Nl�vaӵ�~V-���E;���ZrE?��\վ#ْ��x$[rU;�dK��gՒ+�Y��~V-���E{W1ⵇH��������ڃ���+�}���tmb�k��*�����Q��U-��cUK��XՒ+:V�䊎�&W��l�U�{/[rEǪ�\ѱ�%Wt�j��ZrEǊ�0�z_���^��-cnf��a��g�M��� �  �ϧ�?-ّݓ9<9�ӓ�<��ۓy,9���+� �L�~dx�!ӓ�<9�ݓ9<��Ӓ�~����������@�'�<ِݓ9<9�Ӓ��/����J/�ǳ�ۤz<OQr$Ҁ�I�&m���v�����R��h:M��ˤ�Mz�ǣ�)J$D������Ο��F_�m&�n�	&]�i�]&=���s?^�U�Tz�'NBä�&��f��&��a��͸����J��ҿ�g>�mҀ�fQ�$��vh�t@�G��^�w��J�|�}C�Itzt<�eҀn�&���%M]�����Zo$�o�5�ͤ�M��ä:=z1��S�G�-ڞV�=&��0��k�B[�nτ�I��tC�Itx�E�Z�PiB�I���%M"���W$����l����.h��8E뗯H��&�2iB�I���%"%͌D�<�ӷkq�n�g}T��=Z7��B*ӀN�&t��A�E{ݟ����k�q���f�T�&��4�6��=U�J�H:<Z� ���ڵe�^� ���*�Q��U�&]�4�6�h�h�e��oז�z�e�맯Lt��C�I��t%M"]��h��8��kז�F��8j5D�&M�4i�.�v�6��ֽr�~��~׽r�VCd����{��+M"h7iB�Itz�ގ��]��
���瘔k���H���H��K���x6�`	��{����]��H�7w�4)��>ˤ\�J�D�嫤I�\�J�D�嫤I�|�~��~��7�&���A�I;t��+$I�H�B�4��+$I�x�$���ǣ����j�|�c@Ӥ	m&m�n�&�"���zw#��W�r7�]�)w#V$����D3#q6��[����&m���{�{�VCT�o��Rnx���r�i)7��&��2nx#M"���W$�K�Z�����&�*"!R�""�*"!R�""�*"��:�4ꧯ|?JBä�&��fRn۹i�)���4ɔ�vn�TZ�)f�j��[�҄��Y�=&���$��vh��;CH�Dw�	�^_���'G��刔���r��D9��/G��r�_�H���/G|?���u�o��aR��iR�&M"� k�$�}�֤I�Q�4i�����!�Vܡͤ�K$D�1�DB��K$D�1�DB��K$4Z���ZҐO?���xL�a�&��4)���&�r�(i)���&�L�{*�i�b�l����C숄H9ĎH��CӤ�H$ģ�8��H���q�3L�Q\����(.�$Ҁn�ri)Gq�&�(.z*M��<���4)
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      �      x�՝[oe�q���_���a��_�F��h,jlP3q�@�� H~~����9ai����'?�Ei��VU�������w��{{���o��{x��M�7����z�|z\�/��?�Z���w�Oˍ_~�~��?���~��_�����������四��������n_�>�}x�x������������?����������G3p�:�h�/�����˟?y�#�~�����_�=޽��;��7�|{�����G1 ����/_�G��桐����p�ͷ���޾~������׋��y���~�#����+��>|�/_�d��L�ؓ=L 0�T>&��N�C�w- ���e�tXd։87��Mu��澘դ�^�c	d��6���������P:Hk�m��JH��R��E�ff��l�"�F�1[A5f�T]�Zf_NL]1Z0C��@R�(�1iSζ�ɄQ�	���bET���I�xR�	� ��2���'���`�������������#��ǯ_����m����~�g�Haf�"��$��M.���:)�6̟|�X���
������y�0(&���HE=��Ф��Ie��I!|L*�TI�{E\��8�����d�B�r�,mD��!y(��[I���Z> �u�)?��E�L���9g�i
�4�T�ی�B�I�o�ّJCU�F�Iy&�f7��N>�6A�Z�BKq �f����n��B�2JJ���Hz�6wz����s3��ER8UR���zT�@�L�^��v3SMe{��ŤFZ��$���WB�D${
)�dP3u�����y��[զ���4;M�A`�m~9�4�4��d�e2�3fܑ��^���V����(��r�3=I�ʲQP�ǌ+O�=���	��{���H�+*,cy'yq��UH����{Ud�2H��;IR\��o�S��h#v4X�[�9�FFuR�g����I�LU$�mݞzp1W��{��(f�$)AO
,��aA�+�v�I���i�\�S8��sm�W��ԗ'�X�4��L.GR�'�ê�H�`P���$S��4a#�(7R~>���D�
S�gR��I��Y��J��ZH��$	������T6�heVw�����Tҫ}�!��B��07�vN4"��5+$5�~.����(?i;�m�����9�s.s�A�&2iV�Q�W�b^I�	$�TJR9�ę��/�Z��Ee���,]���RN -�]�rR*��"���Tiы�=u)�̋�5��d���a�)�XKy�d�2�Zn�q>)g�x�%3���`��89��59��\����%�b�)��L4�p2-�W�����37�w�xc��Z�������s�w>����˛��"��ӗ/��=�5sS�),�u����ו��kg�y�fO$�R�N���-��V<���9�3+JBQ��O�dR��H�D!	�A���Q`!M��M��y��B٘�!e��T��]
�I�'��GU1�6c�ƓRb$)���|�,X�s����;�$�eR�$~2S/�OA���l��&��Q��"�ʄ�}�./΍������'Ey&Mp2*�����$���^�_�AN`oX�90����kٳm�
���N!	I�E�Yy��%�P�Qd��~��'V!�m��8�OQ�������&,(7�r��vi�t՟��:��;]���6~���;佮WqH�3N9q�U���٨(fY&)�ζ�i<Ⓝ�b�`ƶ� s�9�i�uX:������z0
*���T��Mf.�[��-Ժ.H����NV�?Ea���*]X�L쥑�����$aQ���~����]���IA$i��P�a�+r�S:*U�f+�B_�Fn.{�I�4�ԘEѿ��I�	��:��Y��(	D�r��1��q���<�F�Τb�@V�2���Nu�ܓ��̩oGZ�)Ε��/�!�dlg�	t�S��lǔ@X�t���֍�x �&E'&�����_���t��*�*Ȟ�B�bb�@'����H�#�Z�uM&8��h9�6u�5�v���;}D~Am�Ŕ�S�����$�DR�s��m�I�8����sj"]i($�x��[�$�8�	NY�/_JQ�E�in�c���*)��q���S��"W�JGM,@G%��׿�����ʏ��@t��P`*h���;�"7�u���qs��1%�pf��z�y$w�Q=�E]}��'s<I�x���B��O������,��"�f8�Ѓ�5(f$�6�쎳�	�0�-�Լ
F��PT6Zw�U�D�Rb �(�"�2S�z�g#�H`�o�aW�l��:֊�u�D+���9���LW�1��zA��y����#�jkW�"���*~����Zf�(��u4�T�LJ���!G0�5XW�`�VH����QwFV%��~V�ܮ2��b�+�@fYg���H��v�[/,�����H��%�	�4���ڠ��Os��3���T�ij����@7)B{ǡ��O�g��s���O��eɩ�^��<L��e
R���?:���Ht��b�[@��I[,en��{ ��-�H�õ)R�	d�I*�D;�0�T3��~n�Y�O�hjCM@���v����3��\*o��iyY}��'U�8�p�4��x�]��C��[Gw���h��b$���a����Hjã"�4檫k��;��sa���6jR�&_-��S�G�K��48h���P5b�M��P$	/�]�qS�ܸ�98�p%B�qQ�\���b]<��V�0�0�I0�����"�L?�*����M�N��ޣ�H��c�	ϡ`,�u�ì�V+ ���Q	��Q�
.�^2@q�u��,0��*A�%���ڽ'��;R:��s2oJ�j0�����j�}6�s��/�R�)$��$n��JB`�|2eXe��3�C����+�2	Tɻ�5Pޚ�2V4I��&�P
Cw�XA�rs�p;GM���Igk a�}!Fy�Nf=ʯzjeB���G�n��P�.��$7���Z���M��Yzq�n���)E�e����"5j�ˌ�����Z�.\����M�p���sy�s�%�L�I�)u5'�{B|۞���'�	�UN�)����zp���TN�W�'���D�m:��Μ�6n��)�,t����XCX��in�9T��̜TR�Π>���S-"j�<�z=s�i�E�N3��H��ho�F`l�I6�s�wΖh;�;��=��	�4'��8 3tk$���x']!�p�J�
K�$�<��L���֓�[��#a���@!��!�UӉ���%�[,Ǵ�cZ+1�Ր��؉O����ť���%a-�.�eQ�j)o9��N�_g��bac�-�h��X�a7�KE����4��x�	d�����'"A��t n�3kQԩ����	�1)?>��U<3Ŕ����T[֊�ֺ���V�Ar�u��+VGFbbZ�#������/?��O�����\�n~��������~�{�������0��'b0�/a��C���g�Ƅ夰����No3��z���ᛳ�������O߾��4�G9�ݗ^]XWqL[ܴl�.2���"	sN�.��@����o^�9'�ۇ���/��_����T9>~��/Oz��q{.8��L�Ґ�N��,X�	�4��z:Q�����RZ<��,��V^w�ὔ�<�4�uu}�O��A`�is�=��W<G[á�tMr�՞�W~ڱ�c/�I�	~��O�������9lY�����엿iLk%��J�Z˄U�N�R'��"�[up����e�^���;��qbKRkY�N�M�`5(�
�[�ɭ��[��u'����.J��gVܐ����e-����t}���Ԑ�:�ʲ`E-,ˉ�uF,?�:<˛��Lk������[Q���E"��)H�er�Y|<������4&38J^�!1ϩ�a���X�) �:���!��Z⵼�5�����Q�"V>�E9W�c;�֨8+�1@a9$,��ĴVc��k�Y��^zV{�*�b�[ւf�3nqj3Ӊ� aef��CmN X	�t-,#K`H'�̄Ո����MlI�pb�D �  X�!����(s���o�ZX�iaY	�0�%N���Y�g����@�p`�k3 X���0�J�J�
#�/���RA�y@N�y@�⵸�3o�uX�_LM�|��Ć����8�ԑ`E&��L��:��	�yKqEܰV�DX�E-,É�����G.�L���Va�ۗ2����kU˲VbZ��8�&Yk5�kժ��^Z�+L"�ŀU����p�Qf��s��]�B.�7`-(�(�3��5�@�Bgr+"�8�9ы�h�'�[�J��5��f+ɉ��ä��O�9�ƕ���X�R�1�ɹV��|Fr���eQ>!a�UA��8omJX�����)����`MfY�ff���u�c
Xŉ��k�x'���S%:-,�Zm�u|�N,LX�ɭ��֦��5�,�L	I�$N�;�[�k�epk��Oa�j�	+#a�2���"��k����ؠ���ɋk���U��,X�n��(�'$��������ְ���e<�X���<4hRX��p��3ae$��ʭ��^T"��C=楰L'2�5܃�Wks#,�B��dTa-VqLXɭ��2V������>��C�t_L.������sj�y+�V&,q>}ډmԢ�W۰�B�5��-�epk�8���Ű��V�B���#a�|v�MX�|�Š|g:�1��y$r���ܲ���[�1K����CZ�\�p����N('$�s-�I���c-'v��N��bFbҩ�h���E�
+��u�p����b�w�GL��ǣ��w�I$0���=e�=ǟ��=�6
7�3��x(چ�E��������X\^�(�㎣�=Ş��s`\�-X{S�#�IưL@���aa���s���L�IB`�Ms��M��ꄊ����'�5�xz�=�O���M���Ɂ	���*�ܾeoi � �r�4����[�?	+�H�!����nګmHS��%)�������T��8��M3�=�F�c�>�ݨ]���`���{��=��t��]B�� 2�F����Hh�����?���O%Y��,��Zf'��O��W	̀�C��|��P����K���C,�-ePBj ����>�S�I���\`⪒rO 9����K {��Y¾Af$.��5b�hՠ�$1�գ��dLg���\(eJ�����>Q��n���s�'L)풞¢Oc&h� �"RAi|�RO$Ұ,0#�����<&�i8^��q�t��XCI�ua/�������Y+��Tf�I��
�j��џ�yN�KJ��35j�q`A�+���>4�
�zpG꿂8�<�>W��Ć�u�6�g��z�� -�^�F��0'e��0{�����(�aݑJ�לjl
1�iHGa&Q����ZC��[��7��#$0�{��͠��|R>^����ԣld��
0���w#*G��;�r���`6�0M!�f|�Nf|�P&5����n�d|ۘ�5>� w�x���Y�PU���#C��e��4�H��[w�b�f|*O�#��H21+�i�L$���ւS6�̴�=Qf��P��O�S@ǹhv�&#�<�-�{=V�U����z��w��M}��aܖB��ܔP��4 ���b̼�4O�=����y�{����������7�w���;��ӗ�ja�S����ͤx&e�`(���0�<>�L�Hm_B
�����c�Zƻ�I(�5��O�h�7�Ff��<��:̮��4(Ҭց~B��c�,�X�̸&,'�Wd=�3�h~�N�&���֌"i}�"��6�T��2$0M��M�d�Ʃ�K�#��q$�*Mf�Wq]�ls���9Y8)	v�2^,3��iT��Ւ�P-)�ij�9��%��&�@�1�=~za'/�7H��R�e(�8h����`� �N�f�Yr7�k&����*��4�y����r0�ۏr0i��v�,���i�&+�c٨�+�JC#VVXƬSg�3�1��C���Ğ0W��+E�3�����e̶*�/�$�)��CId�Ʃse��&��jf_O9
�I+�V�3���,X�$#J"���T=��6Kĺ�9��݅=s��ιW#��⑙�+�϶#�@%j]g6:�B_H�:�F��tIJuùā�}n"�[�H#�@�S ��J����g#�4줎��
8�%����jJM�
C ��DrS#��@SHI/�L
�L����&��b$�HZ"�p�x�e�����2�����`����a�9?,��m4\�Ӄ	
0���ٚL!���3(0��u�e�h��xߤ��������k��|߉�$mW��/e,8�ӌk��L�Č�<��|������^��I�s[C�)螔��j��@��GR��3��v�MR�Gs�Y�yw�|��E���I
$�,�H��ϭ�n8]Ĺ�#.�\@�����W5�1}�Wĵ�bБ���		�as��MQ&��+L�Iyؑ΢�����Pf\��D��4�:��'�8)�J��T�j�H��)�hh"�=��0L���AlH&��J��J՝�E$����\���K���LZ(
$0����=�(M�Z��Ͷ�UL�	�-�H�ym�m	Ӑ��a`%���n�*��I`��Z�LGY���4����z�L'q���	S�σ�0�U��R�Z��s���X!U�B*��G;��T��	��<��n���}�N��E-W�Rʩ��C����rJ������W�ȩ�\�Q�9�2�T�ܒ�S�TiH�T��)5b	�'��d�3���~T�h\���o���d���rˌ�z�H8c�>�Q�q�If�Тw��M�Q8#K�'e�()V\I
��q榿�[�V`IԄ�`R��I�&Yơ�qe&�bO"�'�D�wH�8T���rT��\�n�J���3���W0�e$�Ӳ�$���IH� ��Ic���k>;kڈ$J#�~'R��)�=�F��q<�|ȡ4�^a�ʑlt~"��ѹ��
���$?[�O�L ��rI��et�QzMSNR�f�q���$ˌ���2D�@6�s��<�m�Q>M�����8\U�|,�%�bO�$0���IW��X��U�����ZQRĬ�G	2�i6E�Z����A��s����
$�\H5������a�7U��5�P�*)�GU�#�ިG�)\��aO#�( 3��H�eRr��B!���ғ�S�4���,�5��uj Q����I�<��P���:��Τf���,C�r�+�w�1itXP3:'��U�QCRp��Z��]O�?WX�3������S5�j0�٦�޲�d�i) c�*��>��F�f�H#�-#����⠈��E+l�H�}F���4Oܰ�vਁ��:�*�����d�t��%r��Eq����c<A�y�a`,ˌ����T6l��s9���S��b�²�5�ձ�ƣK5���f�}O�ǦHC��
(޳�Z��GN&��L9���� c&�3^�Ի��0��L��!8)
�Y2I�ƯG�U�^�ø�S�*�<�96�$��s ��LS�T.(ݣP�f#�UA5��qu��n�Rd����b.��Ϩp_�|���k�v���YP��y:�(�R"��&R��DbO՞-mb�ÝĞR@��ߍ$T#�2E`Ҹ;�ܔH`2('����S�)'�B.�)| ��67��\���i@�?T� ��F֞���#e�D
�:��n�`�������k#u� EyE� �FZ�۰@s��悉K�|yJ�M -GҼ+�
B%��@�FT4��S��ɑ��H��I`�\���[")ќo2p�����AbO%Ey!��Fj�:s�=�������� F�{	      Q   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      S      x���ۖ�ȑ�{�~
��f~��wHf03��TDFq�knJ-��K�Y��g�<���9����y!��������]�n{sz�y|�}^���ӻ��}�w��U�N�;W9�����n���C�|�N��������#��û����4��P��u��r�S5�x��������˩x�uU��t�������� ��۟��Ϣ1��]2L�*bx�޾|5��UA�	�8�������!��6&���U!��g��#���_!MC Bz/�φP��:�4�~$����� UC�7dg��h�����
�i��Z� ��ۯ�΀�?ԍ�!��a�}Ο��݄�a� ñz��9_���C�a�!��v���������B����64i��Ex����>|p��! ����[~&!D�������}g?ä!��ov������ܣ�!�>W�b���ў�! �n���F����!����`y��nT��78�]���荞��{�F���IC�w����_����`�Ξ���h ��?^�B��}>��YwՇq�)��YC��[x3ܝ��	B�!T��D�>0Z��'�U!h�k�l hFGL� �
o��ã���qUCh+���t����q�/�YCx/�n���ڗ��m����4kB��!,O)������>���7�T��6����u8���wq���n�_�o��uH�~��N��������-q27��]T5��w�v��f<3����ӗ��.��zצ�b�π�/bE��jP�����˻?��������i��ݻ�v�w��]G�pT5�n���C�
R$�m����Q�W_�� ���ݕ,�wҫ�§����X�ߦ���v4O���Ch�{�2��ڢfS���<i��k�d���J���y�_Ƶpw�|=]6/����˅���~���#ߩB@����+��oZ�cS_�p����p��Lv����g<BzUCh��H�+Δ}�B�b�U:L
�,k L_��aSn\]�&��쎧Z_��B����~q�vu7������'�RC`�ໞf��b�j���nL�_c�����m]wm���O���m�4�����p*��m�����j���s^jm}�a�s��Z7�r�����������~ؽ����g���!]^*���-�J盺>w�ٲ_UCh�|ɸ{+�?�kΗ+k B]U�.	�fێ�ķVk:3��2��+a��@[�A0t��ݼu9YKg�V� O�e���tm��mm<=�J� ��ס��w<58]��ď���.�Ѩ��c�6U5�(`�q�HY�`xO>����������0�Z�n��t�[�ٞ�3/5�A?�_@��W)kB}��3����O��@��������5a"�5J�^� �W���i �V� N��=��%�u�1�i��_�HJ��M���t��Z:,	X�Z���n\�}�ԍ2P�%���M���4��Z�A�M~z;�j6��HTAp�M���CX���A|}��%�dˍ;�r���.��	���LND�.�ְ];����w�[ӿ�?�Y���w÷�i�����x�es8=��<��>[:)�ѥ�G�{��ڔZ4>�Щ�ռ;nӻ������69U���lw���a�=�U��޽?�O�����a�%]¥�x@=�*��i����N�$�A����4<Q�>����|���I�W�j^s�J"�n�፼A�S��8�I"H�z+�H�-5��ө�/=��w�}��,H���� )5)�)�RK$� $ǻ߃r1p���!��A����~|�@���u{�ь'�3$� $�\���{7>_��J�H��:��KjERG�VY�@�����q�?��H�҅��B����_&��.7[� ���g�KZ���h˽9�H��� rj�m��0�4)��uBq|�F���%�閷V5�:�����;�SH.�S5�#��������}��D��D���A$1��������0R�@�� �ߪV5�M ��/;�{��+5��{�����׿��Ͽ�j#�Sh(8U�H�D��o����V��j��n�	_z� �:�����1�<6�B��6Wj	��_��N�W21Bj��,����bEi�FI����e�c����a���0l�Y��kyB�A$)��~�j�hӥzlU� ?��jʍ�8������?Tg�AHYpV�V�hQ�������p���8g�j����U����� �T?O�	�V@j�����ⶳ�Vf'J�[+�#K�K ��Ǎ�\�&��<%4���/�����E��� �Q)������5����З�㿻p�cS���� �t޿L�l���H�!-����a#GT6�o�-�UWqt
Gs�>��1�0� Y��A |��y1cxy�-5�vџ�?�G#1�q�g��c􆽪AA=�/�����~�ð��>�r.�߼�as~����@[�!�k�A=;�_˻W�!T�d%���ҬA����7��|�`"�Mssx;#Y�ӧ�w�x:?��'�Y��?��j���t]+U�h�|IyWv������(�)/5��瑕#���R�8h�\�Ѽ� J⠳�WC,c�Iͪq���r0�m��b�!\�y��z�)�SJ�}��{��I������q������Q/��K�m�8Ư��~M�.5$����q����A[�͆���HR�@T5����Ji�����[�A�\hc�"�QjG����p�ע�q�{{�Gק4��T�p\ u�>�9�j��N�Q�樗�c� ��������m����񀹫hG=ϧs+�R�8�����I�*km���&�B�ľ�FT�ԗDD[���������}[�g�q��$��#��q��j>G��+Q�A�NJ:��~y��4���搏����]'B�(�������z7�s��b��mg��y|>�X1b�z�/5��_����7��^��Ы���[����a�S5�����[��f{�~�@��rE��7b1��P���D@{�� |��A�{�D����@�Wk���scy%�k�|%X� 8���l�3��5��� �E�Y�A�ٞ[�d'b���_D�\�AA튣 ��H��f�� �i�4!�׼�R��5O!��v��@������d^K�K"����î 8j]֫�@'w+B������M����A�;U�8ȭ\�!]9�A����� '���eT5�#ד���.�I	g��u��/�GK��l�r�A(�qnS{R+G��^j�S�V�oӼ�#,5��Џ�\bE鋋�A(���G9_&h%��2��3]��̦�6]CPh������$e�-�,kH͹�k0�W5������ �DJ�������:��.4��v�����˄q�Z�2�A ��~>}��2��؜pX�H� ߨ��M_UU:Q]"��)������n��QG�^Μ�I�Hh��<n�_��xM�)5���#����>��pļ��ݭ	��R�*f���A�>�S��	�V5��[��g�Mq��A;����=Z��d78U�Xx��Δ�BF��ب���f�����:��^/����˥%kHn$��z5�lԽ&����fg�L"��Z>�����x�9<^M�V��N�D�뛬���e����&C<�Lo���4��v�U�҇�4�#�i'oŮ\
��ɢ��~���J���n
�4��K��o�霬���������fs��k2i흏�A��'"�&|ۇ��8����5����ǫ?C�ѠY�8���X$m�;& ��g/�:��_TjAXA�|g"���� �p^�C� �\��}k��l�	�B�Z���7!�"�OhB7��]'h_�(�D��DA��(A�z�t� 6��A��J�	��u�D��z��M:U� �u���w�SR(�D�A�zoV�i P�jA�g��#����n��������4\�|s�a����A �9�6eB�    �;_;�C`�ki�A0<ED�I0�h�� ��L󛾖	�ݼ�/�t_ޔ����#M�$e��1t�r*�lݝ�F�AD�܎�|�����_`�E�� �57�T'��{;��O�"�0H�0�����J~�ϛg�5�!mz��s��B�A9�y�ycp�l�9vB��GfqD@���TQ�)�ֿ�W-5����CɅq�<0�V�1�� ���x��
�V� �\��m�ĺ'���ܤA .���?��	<["�A�����(gxy|���{��݇���H�K*6��[�A <��d�b����W5���+9\�jG�����0e��� ��{V>Y:#Of�K����p9�׍���eڊ� �zE��d�l��q8��k^��,����a���� ����+I���e"�������.	km��S������A9:�=��g��� �����Ѕo��[D�A��7��D�3�+u�.TZ��t��@:0D�`)�4���oSÿ�-�$)��p��E��U��D��l�BR��A(A��o�vɞ/OUB���ٴ�sގ�t�Յ��P�� ����A���8�"��x�ٴX͸>���MD�A4�R>x��|7��Hm�	Bʁ���Vm�Z�Oɥ�����( BťOj���u}�M���5OM�{U��h�=7�?jH.֡�]���O�� $����F�"�(4�#�׮3�ڸ�E]�«���ئn@:LS�J��Ĺ������Q�A<�twJ�q�3�E}�� N�;i�>���޷�?��t�[7ZB���\�l��a��p'��P��J���B��6�U��~�5����j�W5�o��	J[{]�	���:�9[�锭��5k	����\��!�̤����A�)V`�
?�l^ǟ���oa�芃�� 9X�d3�\\�*�A��>��b��#��A �J�8��;�R��{
"�H�A��_��7.6��G�<���B����h�c�Fr��:Q_4�DD>���@8k�"5��T���N>�bTN�1���nxB��ء�Q��؉�1q*�����Ǻw�I91��FB��8y�`�)�9�E/�8�`�N�<,��U�����`�RŜ�R/_*� 4�#�{�A$\45l�?Qh@X�UA�)�֡(�$�X��	"�W[��H�8͇��r�`;H]���s&��%7���T|]�@(��2�D���:a�� �t?��(�q	�h�&�����R�BQB[��E�#( �hqA�@:�Ug{��P���#M6�'��6��P*4����&+8\�p�g⨧~i�~L1O	��A(��n?����O�A�:r��Y�8/�-rL���Y�B�8xO�u�m���X+f�h��6�"e�A�I�e�Qj��jH7��i+��]S7��ϏYMn��^� �ib��Ǿik�z�*��ǲTKhM���~��e[�U�[C�^�F�"z 4�H��l�e�j���p�*����sne��� 4ug��d�;U�0����`�Y �џ�.�ۺfE�Ȇ�\q�/4���fo��?���M�Iܒ�5�����&��Y B�0��8;���X������m�"/Sh!ll����c6���pt`H]�4�A ܻ�q�?�M�	��2��d|q$:U�8��aʹc��8v	Bi�}��u�`�XhD��^�ק�NF}WtjB�����c�l���U#4���I�_MW�d4�.W*k H�(:�[�B�+z�	�=��V��6������xo7E��f9Mh����l�f��ȒD�#�V��<t��D����%@�V��JB�H��^IF��4�A -�HY�8��˜d�V�"�*4��_��>Y���!$5��֓w*��ެA�M��W5��Տ�ao��!��.r���� G�@Ͳ�r?h/�Ps��>���]bl����F^�3}�!�./�amm�I =F�A �þ���2UX���҄ApM�Da| �a+4��6�����cd�]���U��$V������]�N�ԉ��v��]�� �z=H9�ThY?�B5l�-�B�@��t�Ef]��)4�b��ָ���ͳU��U_;�YA\�	iV|��PD��q����*] i���$'a����hW4��粳o�|��"�)4��Wk��<��^.�ct���e>)ER�� �[��/`Ipi)�� 4�$�q�r��h�|$���5i�-�+UK�h� �Z���"l�G-�AM���ğ�fW��q��2u��/?��ap�u{{o��!��U$4��ջ�����������p��pg_����� �Vב��%�� ��چ��9U�>[#hߗrB3H���R5$p�ύ)��F}q�&4�wU���R�ST5��w��/�imn:��A 9!K��q���D� ���.��Z�jEZ�a8|_x���S����ѣ�����r4�q8�~sx6�0..�1��PV�'[&v;U\��qІz�9��f_d�"�u?!,����W�S5�r�ցt�@ѬA y.���������q�՝i@/��2J4km�[cl5�l��!�Tk��a���F� �:�C1rP���yL�A�W�7��e�W����̬A �{��)Ϙ���� ������_�l-*4���1苢j�T�j��5!�U���-k8bq�,4����!*�2s��5��̓\���G��\��A����p����R5�G�>ڲ#�)lګ�u$mq�DD�;+I�JhI�Zh�Ah���A M��"2d4eT9U�@�ܦkg+n�r'	9Xh
��_��3��vTB�88��$��kȺо�HS���������֒&�F�"�Hh_T�#�^?B�H|���I��D�A aō7�,;z���۔zFFc��Ph�T���������憔��P|�S5����v��F}q�B�ꝱ��ww���5������U�j	_UYc3��s�JX�H��U;;� )]թ���1u�D7���nW��)B�VC�m-4�$�^`�P"�K�d� ��K7v�� l�-#B�@xw]E��b� N�����uQ�*4�������p�.�6 �U�溹�7���f� �^����#V�A�A�Ɣ��F�"B"4�����ݳ�𚬦�F� �\�_���V��A1�oM��d5%1���pH��9>��y�n��J&b�H�����ې2�YhZ�axLD��5�?�;��h�j�x�ژ��ũ<_�A��'�9/݃,?w�q���%!���1�2k7X��Ξ��(֜[e����Hi�A]WVq�ŷn� �f5G9Bh74G����U��t-Hy��5��Y<k8B�jԺ�;S:�l�Q5�d�D����je"Y7Q����S5�įj���d%4�$��<���B�@�Y�|��4ds�	�h��M~����D�q�'�Ɋ��bR�� �i������Om�-�HO��u1>KhH.�ZK"�F������2<,Op��p(��֐����=�㬶��ɨ�<��uc:N���9.1��1r���i��v��O��o�G{��<:k=�������y�Zz������q�1�&�u�)Ӝ�q����`��&��l�#4�˭����_������X�;��gϤ;mE�����&�f,�J
�Z_N��&u]�7�A(��j��+����^D;��<=��֤�������[�����ʹ�+4�%�����}�jZ{U�H�|��9U�Ph��?�6f��<ڨB³�n��L�F�Ѹ\'�A ���$~��OD�C��h�d���a��w�$* 	S''3G(zk��3�l�q�\˻8TL��+uB3e���^��Tbɡ�e1Dh﮶��Ͱ| �1y
��������IC8��jo����}fU m�fc������ꫧ�`\����p�A �i]R��Xj��\W��Y�0xz���a��S5���L���M�p��YC�X�m>�    �lU��n������ɍ��H�l���W�nrI��K7k��Z��ok�Z�U\���GD�xmNe}V��^ I�U"�t��$��D�� �K=��šj� ��bjw��Eb���5������d�_>�I�0�ǵ�2 �ʌM�A]��|s*i]Q࣒�����m��˷UjB�Vi�N��O�� �)�j�Y�F�&kR�@\>a�LO�.�H��c��Ƅ����H��pcx?��F^�K��� ���꣠3I��!4����MFil�k�M���lS�AJ��=�0��۳Q�T��{b	0�F]E#`+UC@x��J�ګđ��w[��d�N=���A$.�4G�o��:�M%5�$O��`8Vg�Q�EJ�-�di&�m6��l� �ܲ����=���F����V�D]�Hhg}8l��,�d�%_#�D��Z��(ѩ���Ku�L����MU弮g�%�l6T���Sf�Z�N� >�oM��Q����U5�6���4���

�?�Tt�,�٤�T9Ufwg9g�ٔ��DaBi��[��l�v���y����ܚrŌO�A]NA�_=���qR� 
�W��q�*A]$��Դ�~N��N�K"�s'�O�	���r-������dX.�%�A|�4��Tx�kB�V����"�C�!���J���}'�#kA����U�6��S5���7ǫ+�Mkŕ�� �w[A,�p�A�Ri��Y�M��>u��a'�!,\ ����7��J)5d��\��VyF�"�)P��ʗ٨t|����yc걐m62�Gj�+Aj�Ahrq�q���ˤr���4��Vr�
�@rk���3I����� 
��؆�d��¡ҵ$�>k��.�CG�t]=��:r﫞.ۢ�A@ty�9*D�o������Di&撈5��DQ��D�����7�صo�6v]�����(R��"�=h��ڵ��+_]xL����D�\�*2>�>�M߷
P�y�B��Znqw�<�~\h�W��~�Ѽ/��KB�V?��7�B�����t�h�^��m�cʏW�BS\�a
�l���;u��UڷT�TDS���i����2(٬�ѶS5�cv������]�wMЈ�����4�����]��mۇ�k�OlM�p��j� ���@~�=�5�6�v�����j����q�D��w�[e�΍o|���S���jm���A�Ľ���B��:��i{+��w]��e��!O_��b���X�'������Y�4����NѬ!H�B�bq�D�����V�@���ǶkT�?�2	Rjm��/Z�X���q]�;�BD�ŃW5����'�T"�=�e�e�9_�>6m�~�i��5����Ʒ^ٷǕ�t���Ҭ�J� �������>R����j����U5��}�����.'b��7L&c�sA�0h���]�ґ����Z�#����!Hy,�~���i}�j����ܷ�!�o�fŶ���GjX�"��j��m�,!=�[�Z� ϥ�/'�}������Gӥt6׫�r��2�F� �(���v�&��c� ��r���U�k���:*0lU"�������!"5��o oթI#R�4ת�P��W����|�(Q�jQ[M�>T���8zF��Z�;D��7[(�u���w�J���<�&��B���v�2~c}?�:���5�S5��',j�W)v��}��dSC��u�uV�&�F��A �o��Ч�%�\7���R����1kS�c^�{������������5����~)��!�16�^���NչҠU5���������)���ʌ]�!L�$�FZ>&� $گ��ȦsY�����R���"@h��=L���U�T����鮣�h��v����X���j�Y)G&�#�� ��e>ZH$��.���wo��>aK"� ��FR}ؚ4U��lI4iD.�J��.��A
�K��uT5���![�C{�G:�B�x�i��֏�\<�F���j�,3�AH�z�=(-��s���P�_{��w�ߤ�&�U��^������ڝ���x]��
���S���K����a���)�^� "
�<���:�UJ�Q��΋�Ѷ=<�h]W�RhϫD�%Ɲv7��'Cz�:Q1.Rj爨݇D^� ���X�۱M��5�A�Q�7�GK��ϭ��VM�c�=�3���q%k[��P]�������׾=!���i׭�D-�9�p5DiNn���%Ӈa�uLDĹ Z*H
]��G4�a�(4��B>k]E���u
J*D4�n�7OD�y\��i�P���X!�>��ȖD��z��� �:]R՝���/Z�KB����ߟ_%�W�B����7����X�^���A���8z��� ��A]>� �<xBE� ��{�A }�h�|�ڷ��z�X�S��2f!�i�����S�`�4��q�.8U��귦��&�~<��G�d�-?�1�<R��U��J��N�:U�x<���t��6���с�m=���=��t���H���4�N� "��]�h��Y�8�5M��U���*5�����j3���x7��Wo�5A� "nOy�^�5wn< �{�l�<�
"�FV��^�K�&֮���|$��Z�t�q�+T��\SUU���%o�<Y�/ED.�DD;��y���H�zUh����r&����6�A!��qN� ��AVq4�qP��eؙ��q5��jH��nMa�@���pD��p�bx�6���%?�~N}}|J��+U���sl��1��iAh����m!�<�i[R�8�󅩇_��G_\���б�v�l�b"�� �]L���f����qn��y{���f��#aB�22LG~2S�/U�@��=l��U2���V��e��E�� ��+�,qꐓ�b�jF��/��B�0�����O��e�[KK�l�/_�I�0ȗ^Nf���O���%�'�Pt6��뜪A \P�
$�b���9EA��^@i��� �ȓ���ƹ��J�.PzTy�+4���S\�m��Ip� ��~�"�.%���	Q�#�iR��ٰ1us�8-�ٻ��r��"=U1-NjQ�� 5Ah{מ�2��lS$4�����O 7�)O��a�O�{�7HF]�)��Y�@O6�j| ��T����~k���F�b��� .�L���f,r��qDNðs,Ү�q�~�hk�)�Tr�������I$��-*�������5 ��A �4���IƔ�8n2�%4����Ë�f1RK��xm��p�v=J�j
m�w��A	r���N��$������`ji�F�"k@h��kA.hHN_��|�"�i��+4i������d�SC�j���AU�@�˩�:���&�B�8z�y��|��h����! <�m-�<�ɭ�����A��̤A��mw�a1�\�^� �aK%��Pժqp����勩�]ݩ��5w��(:ˢ�RhK3�z�
�&���A$����;����,4����H��N̓|C�j+��]��IC8�������D:�)�kH�ߚ�[�k��%h�j	��ۯv�X���A[��qg�����A�~�q�$�E�Qh	�XHJ���ap��ǽ�v�����A -_C�>�g�ju�xS�C�z��X����A�W��Ea��.L����q�6�"�Dh�4C���ލ�F�_%�g1�{�p�<��49���񌝪A >�{����� EM�� n��qx�<[�n_d�	b!G�����<#i��oَGh	W����э�w[��<�D�ӣ�5��6ލ)�L�Gqy(4���u2*,4�J��S��G����<� �x�����c�D��j�aW`�2�&4��l�d3���5��s�p��?KD+�;. ��Z�Q�)0B�88#v��5���X��N{��c� ��*G���ABY�'4���W�ĢK�� ���O�.��fY�#4����6�+��FҮU5�|��fwg����5q��A$n��0.�tZ��p���-��=$�^� ��#��PVC��]q�(4�6ֵ �Q5�.����5���uU�h��W�{�N�}Q�,4���v�    �Dv��61B�8�Ըo��GFc(
���pu�:���jB�j�t0�^o�lպS5����ϛ�N��R_�TȨ"Q_U��83k�&˗%��A$a�v�V[U�H(.��~_4�M�O���i(]:r/\�I�P��koua� ڢ�Wh��nl3��fWD=�qt� w�5�Ȫ/�{���|�1�49�?T��p�|���)9߶ޅZ��l��s0i�s���2:~n��j�{��O����_���뿾�Xro�J� �X����~�r��H�A�π��S�Y�
������c�a�$�r4��4	�׿��+�x��{U�8Z���[='�/ͬA�[��u��o�5�$������E��.�Z���B�@r���
�qe��#a"q����N6���|� 
��XL�n~�i�]���&u��:��"鬉�� ���g��[?�U�U�<!U��"������_��|��U���kϟS�.r�q�xU��Z��r�=��d6��U�P:�uS{��u�u�%�t�ժā��Pf�o�h���<g��N���PD%��p߮O)�L��Oh��~o�k������� ��]pk:���k�<-��qt�q�ᰵ�?��XM����f��8�ڤA� z}�I�8�a�-��-��AD�@��ڇ�Js�tW���䰭�B�M��9BC0��k��˥��m��0�@�lv�;��v���Y��I������B?m�++$�q�|PJ�諸n��@���2�JhQ�DǗa�i�6��m��&7�R5�(^ά�9R�y�j��ٙ�&�ѩ�Afw{����w]�[_���2� 4���.tnl�ԌY'��%�AD=Oö]���}oUi��M�u��Hw�At������q���8����}O���U�kLV��A�\kZo�#ٱW5���������G�t_%딯�j���?O�)��,\�Y�@�Q���p�U��sM���W����H\�jT���;c�#m'�Y�@xF���t��(�ODhH��{��r�׆�)�:J�E�*�AH��~s㧺�xH9���z���[�0�j	�$p	���^�g��2!�ADS��m��w�)�����M��3b"�݃֨���Үj�����AD���Rr��X47���ۅh�q���� �0r���Ӕ/W��<d�Q�g���&���YOʹ��
gThR�G�՚oS�j�)�j���b�� �`kХxH�.>��qpLX��ISc*����U���m��Ҕ�l�nVU���MO��ZX�y�4!��&�G�����^y6�O��������e�.#4�������1 E]���t{��?}���i��E�g���'�AD}�[�8]Φ���5���xGleE�ʦ\B�@x�E�&��k� �i޻q&�ѩ�������2x�%k��>/�s^�R��S5����Rc=m���21]hJs���qt�w�S5�� �m�Z:�lv���Awo�u4��㍪A �]��! \��L�zd3�ŧo� �<ǔ8��U�}��͝m��+ߪ�AYg+9��̬A�Ӿ�ի����:�w�i��/"VB�x"�+�O�j�O�q��� ���P5��p�a{4e�LV/h	��7R88�Nf�
��ad��N���ܒ���⎿�S�Yw2Y�,4������8�eF�� �e{4�jd3���;kG. �����Z�A �{��H:�/9X�8"g���h�FvB�8�q==ll���jG{1[I�H!��jFnRcǈE
�� �P�l$l�_n���p���?�B�}
{�`H�jG�N���w�A.���O��%k��������˖�Ʋ��� ��b~mO!i_l�qЎ����+�m�}r'����uX�,�V� ���P?�bl4~��A GЬ/oX���qP(`%��c�����ʑ�K� �<���$�>���yT�ϝ�ǈI��xB��|�n��"�,4�g/jbD�ڪ	���K�S��rKa"�!?JT;U��b��$1$���T�����h2�t�h�bt�c֤A��%W��L#o�c��BF��aa��*�>�;�EH`� �����8�u�jG�a��IJ�+��qx�m���.�B�8�ͱ��)�\�{��[�
�n�&M�1�Ɏ9η�v�Sf ���(�m����S�d�	�G� �<��� �.�U����t�N0�o+]C��lI�&�W�N}�.������\�>��}>=���ϣ+:�
bp+��s��,���"̇�u_&�B�m�a�6܎ul\�[%-��*��D���kuSɚRj��(�S��b_��GW��uއZg:{�fbjyz�#��!q���Ik�8�,��\�p�"�P��B�|�[5��*�r/�5������^1�]���d>��[�o� �zJ�y����}�/�����77��(epe� ?��/��xdy�YNhM�&����~����uwU��N�kQ� ��߭!*JW�5���P�:�\�<Iu��nН<�K"↸�p��9*���w��"5�C�ZY�.5�w�gG(�!L<��v�I`㚶�B8ر�Կx��X��x��q&�0�����k
��z���x�i��J�D����F�-J"�]��`����F����D����n�/����
���R�@ؑ>�J���p�Hڋ��N�@��%5���Ǎ��b��H���7aKl3�,6RC8r=ٚ��9!R�@rk1��k��/?ٓ�p���}�*w��S��������r��z�q���?����� ���W5�����_�����Ƴ�X�DB�����n��l�yU�8�w����������g��V5�#��}��$���Ъүq�=�� ���*"�Ͽ|��_�˕�i^ڤa,5���/���?�ϥ��w����֍t��PὪa,�q�������J�0�d��������%���U�j
m����q����%4��a,-ܿ����I��>�jHK+�/����ֽ�K/�vR�X�A�\�d��^��a ܸ�T��FS�@�jH��v��_�
�*]�H(G�i�W�A�,�-Oē���<�iK1�Gj�ݚz3d���E�4$�D`푤ؗ�u���0����]��1qmÏ3���15<m�R��Fˬ\�a \=�d��N©��m���š}�0J�5��Z]�8�A$<��y���Z�)��x�'��oM% ��tW�/��Y�Ph�}<�J��l�B�����B)�ffC	?�U�P8ql�[l����4��}��ǎ���Y�@�^3G(4I��ݝ�7Z����zR�H�Y���e��E�|� �/Ǭ�s�qS��������M������8���/��M90�۰�d�g�E]����B�aT��~���J`�*Sy%4��"����?���$�>�#�a,���/���r��)/�H���B!ܵ$墙5���q[m�N�ƔR�H�zlJM�^�0����ζ2T��U�clϛ�3 幫Ņh�����t��R�X�R�F2M�Y�"�T���p<w�7�Nf}�u^�0���>ړY�kJX�>LV�S5��z.>'K�[u]RF��l�P�Ѭa(�P�d~Ȭ(ِ��վ���0#Y�*�W5���$�¯d4M�Z�Li��22X"��4Q�S5���Z$�$l6�B�P��]������K�0�7�}5�;U�@��t?,%��n+۠Hc�]����<�T9<���>��~����Zve�FĻ�!��BBh��S������o��7YNyK�0��t|�fU��]q.4�v�ۗ�������St�����9;��,�����a5��>����u��7��0J�z�~��"t,4�Ձ��c��6��%��N������A�4����A�Ҵ�����idNT5"g��o�]§<��|�a�m���KOE\��F��	���cH݁kU� 8g��ex��7٣q�u�jC�'K+���g���k�0�z�L��Ф�G�UC�菷�TFS����%������j|g���>��.u�y�|��g�a0䍎;�ۍ �^��s��0�f�    ���7�o\{>~=�vŝ��0>�3ןH[��!�.:ܝҰ�+-EQ[U�(xp��嬽���@��0������c�S*���V;���T��c���ݸ���c���Q8n�g��y��)K߄��x.�8��
����qT�a(�6�5է��f���y �����~qh�5��᜛gSF��2�/4��S���K������T#�>^�GK3�l�)�v������|�j*bOv����A,�����ftIBlϷ�@�$��<R�`�i��}��R��pA�\�x�~�r�%�u�à�����a{-��&��R�0�������e�}���O���񥨗�a�Q�v�B(R҄�1��r�8��j�%äa]>��\B.����A�C>}ݮ@��F��z�����Uٞ/�p��1�v��0|y��c:JCiU��S���t��t�a�k�ϣAMe��0:��6�G�zHe
g8id����|��jD�!vw�?��Ų���0
�F2� ���x�v��q����4�#M��"/IhH�7�v���8'���@v����N�)�SsG�i�N��L��a$�x�WJ��{�j�Ͻ[� �?j�j{�w��%r�F�0����M�����:U�H�)�m\����U#i�`��+������q�<��~|�'Ҧ-c�OFB��6?^��U��A.OA�4��l(SK����u��n�l#闵�B�H(djK�"�>,�5��q�q]�� ��a	�@����� ��a$Te5<�,�hpK�h�0�&7�����&��B�@Zn�n��"5km���Of�ԍ�W5�W�D&��"69k�������^���������d��̺�4S�a(|��d�F**s��qx��wx4�1��`q�0
c�8������
'MhG�Q��'+I�ز$a#i�n��&��.��B�@x���d��R�G��C������ꂌ�����s�Y��M�1.4d]�T��_֪��p{��~C7�F�\������O����r�ʆ]Qs!4�"϶oq́vy�+4�<�U eq��0v`www'ˁ�̦�l���½���2�H-ɚ"�)4����v����	�N=�����;�9|]~���]�獩f�̆�/�� .�z<���d4�",4�&wmL�q��jT�����q�4 �W5���ӳ�S͟�4����܊�걥�[�g�0�²��9U�Hv�L��l�]z'���p��)s�n�U� v�(�l��q�a4��2���u���'bi(P�n�-�)�����q8��s��S�|���hʍd�mqK.4��g�qI�j	����Dj'){E#�뾂d�v�����t�YCr���e<5WT�%q����Yߦ;�ɨ�5��nLm&��V5�$�X}�Z�I�L�|&���pY�:bM�㞪a �Ǌ�}d���a ������ ��P�FBm�V�,����P�����/���Қ����V�0�&�y���?W�D�۷y4�_m+b�[GU�P���%q��a$<����˸j�jp��t�?��+�k�W*��q�d�����MC=�nPX����虬C閱�I�Px���f�N�z�0����_�.yl�]�:���p��u(���+5�w�}7���roˏ�a$�����Ӷ`��b�LFB~����f��4���{��0�غ?w���ɭ6e��� ��z�Vꥫj
��筩�9[�E���0N��d_*�Zq�밆�xn~�l:7t�AH�a$/H}%lu��"4+4����o�of����0��������Y�����?����a(�k}{��ilT���0�?�I��:��8��Z���4�"^-4��r�OÓ�W�}��0�e׀��>Ah����%P�䁒U�jm��@��ї�0�ȩ9�$�&W��J�0��=X���h]fP��X[g�&���ɬa �Zw��4�"��a��#�QP�A<\ks�f����B�@�=n��+I�Z��Z������:v�O�F9����4�����P&��cT���pr��|0�g���a(t�u�y4�H"��	BB�H����� ��/h
]{=�V6R��S5��6ٗ��x=���>�]�M�א�
�%	k	��Ϣ[K"Y���a$57��dʈi��/.��I�H��#)#��������x�]�&�M�y���x���$�j
m����%�������H��5����|�j
�����b�����J�0�n-���;ۤa ����4�ix�ֺU�΂8����3��6���6� ��a ��u�1F�S��PT�!G�����Q�MT5��[�Y�&���p�?�����j�T#�-��(t9\w���p�����q4*�tag��\o���h���E���0������ɪSHЗ�K�>�J$'�~���|�q����b�k�Ѡ<0c�q��׭-����"�@h��yu+QzU�P(�p?�kP�V�0��*����U���]�]�uk���F�4�#!�ac|�kj�ث��;����e��M���a����d��׿���c�|MV�B��ע[1�~2��a ��lw��$Q�0�`ס� άa(���;��`j{2�-]�Y�X�.[ַ�&W����LڙR�۔�R�.hInV`���X܈
�\���!���WnlB�8��k�r�����ݲLEhK͕;�'M�lUq<��b%�]Q")4������LRq�M'4�$p7'�鏬W\�	#�Jڍ��}KmN\��#�����SL6)�B�0�_�p��7�A��p2U#�Q�,v�Y�@xw�Ҧi�$i�_�jIK����ߐ�G��/��_M1�6�Y	��a(���RNZ��)s	���p���t*'�u9�RhH��-� �)Z�	ɭ�� !,��a �ݛR-�h[L~B{��T��R�K,�B�8xo}2�۩�u�j�O���6���t�hk]�D�_�g���LmM��l�)..���8n2r4��-��}�9���u��4*�/IX�H����~m��wy��5�$�S��m�j[0�oϤa4͏�D�jMN�25�#���ҭiϟ���qU�*��6ShH�۬�f��YOz�0��s謮I�
�F�0�d7�ݾI����m�0�dׂ���������Ҁ�J�0�b��5��R9���Kh
G_���O�6Rߨ������TCf](��C�V�i)��^zJ�����[���`���v]Q/$4��WU>�Cq

��蹘�y��t=<Y]Ē&#�����o��s2���&4��v�҇��`�:�a$<�k�kU�(��������a,���Gc��F���r}ŹZ��gcԂ�,Ե�a(����|��j�jI�N�u���|�+4$�ZKҩFB����'g��ig�0n�}��%ut�U ���P(v�`���h[\�
�6�ۍ�~��~��&4��ه�qk����'.��0��+�Md��q䍨�0����Oė5�B�8��.�m
�es�a (8�������h�\�E�V��ta�a$\8;75�Xܙq���n7�_���F�0�'���Il���"4���6ǭ���4(�Q5������h���X�b�a$t�ug�mu�/3_����m��xN6ӝR�jG���TJV�/�ʄ��p2�pk���(��� ��u�5�&���e�SelqG2b#B�뭭�}G��e�&�a ܔ`c�h�IYB�8r���ctT�S5��<�O��f�l.&�h��[�i�[��J�0�Y?mn�Ϥ)�s���t�V-�x��"6����Z]�qA�8B�׈����Z�4��v�o��LGz��a�|�e$���B�@8����S�&Ë�w�0���["�d5*$`��
���:�N�04���9]����Ѭa ��)G��v�-m�0��G�<o��Ng�tkӨ���P��ɔ�1��

<�2���Ƴ��"�?m�0���[���j������u�hY�#4$_o�n��j�E0ZhI��޾`CST#ᆰ�Ez[�"�4k7�:�����Y�@򨮟L5��Z!�z�ີM�� �-B�@��j� �  J�h�	i*�P�.�h(�y�a ��>�l���l,�~B�Pr���!����My�(4��.����Ӟ���"@/4�$�+��>��;�n:�-YX�X��k5Kݨ�����y{c%I3n��a$#��1�رѮh�"4�����Q}�csQ�0������6������Bs��?�n���x�(��Y�8ȇ5fMFe�Qh�[њ��Z�0�b׬V*ڪjU�Ph��/&G��ʶ��a(<�{��U�5���lm<�h(oA������yk���5c��O�7XSX���9�������r�FfC[��B�8�
%��/���p���׭%!���W_R	#�v�[�s�n_�"�Ph��ޛ.��h*��������]9m�,X�a |�e�["�1�X�a$���7#I�\��j	wzl}��j*ooT#�q�7�:�/��I�@h�}��hR��������~�4�>ױ�^�0��e�a���xS��!v�1�+R��P�>���p'��°l�Y�8���n%yg��OV� �V�0
Î;����m���a(��>~21�nz�&M��U�lY/=nu˕2i	A4��O6a�I�8��kH��L�*W]�ZMf�J�0nXx7BX#'l�S5�����u(�l��h4)�b����c먆l�X"ܲ7p5�Z�E����W.�z޿X��h�d!4�k���M�lu�dY�HڜswgD�K��jJ���:���閁K��{�$����8i	��?��K��X��FRO_�U(QA�`B�2��x�r��Z����P>��`j{6Y-�'���poؕ$�{<kI��l�>����2c�0�g����hlTi󖿂�V�l��٩���hgI��[U�X8*k+L��Y>�I�@C��yl�t!g���so��MVۢ���0�;<?n-�%'��9k��ƨ
��o�ǗTn�uxI�I��Ք�Ш�����+�V�ŰW5������?�����оE�#�-�	Hc�7���.ֱ���o�N�f-�F�CdN4���
���^��<�^N��l���-_j	�!��S�&�V���0����8-�R�@|>�I|%�R�H(d�S�_�W�����R�x�����V��4���}yn-�}2�hDg�jJ�e����
H��pZ��r7�Fˁ�R�@z�Rb)�OF���W0iH��xI+A���p���4������J�0�Cq҅�����ΊhT�W5%��SB*[�~��LFs�<K�&���X�a$�Ǿз��''ݔ�X��0J�ڝ�ý�D
2:U�X8H��p��b��0�ܿpkIe��/�ȤA$��P���Rt�R�P�
�N�hJ#a���4X YM��!g�0?O���3�h���4�vV�Rm����p]��$�I\���4��`������f�0�ܲpI'����p[�����oq�HX�@xg]ER�l�D�䎅���d�M���U#!ߕ@�l"-6;U�ܚ&�l6%�5���LI?W5����k	�jm������J�0�Z'���$� ��a4y���ry��v��0��������9"�QAAC�M��㖫�l�Y�󓆑���c�i�e�L�³����d|wh�`�T#a�u-JTP��_���G���:�.cH���pS��%u�zA�H�~��1]a�KJ�hd���0�8�y���2D?k
﵇�q�����7kI�j7Ƌ�l�W5��˕燓-,�f�������˔f�F�ܚ%kHǎ�*�n �5���S95��4PH�H!wv��5��6ٝy[s�>	R�@B�C���S5�$�3�сd�Qy&`�P�]/��A�Ks#����������[d��F������;�d6�jTCə��ׯ��,�R��ȥ��pr���u_�����Q>�Y�H��k�L].5���/���nh����H�a$��~�������	����x���M�*����R�p�)��b��z*��5�$�ɼ�F�p��/�3�&��~�4�F�r��5$�R��0��h��F-�^�0�k8��bLf���FUCP"�{��{F��h�zf/5��iIl��Z�6����g���_�OVӰ�F�0�$����j���TjIȡ���yctR�wp����<w{=Ch2��C�����F��C�^O���q�7��=��f{ݸy-<�Y���fq�\c�S�ש���D��Q��j*!nU"���K��y5^0�M	�˧�ƒ�hm$�*�K�m�0���`{�ޖt��k�R�X؇����\��:e.ˤa(��Y�~yR��{M�-5�"��h^楆QpQ���T��\j�W���q؏ۏo�O��t�V�0�._DϿ�2��u+5����Y;H�-���p���z�6�鋲 �4�Ω@��[��f]��{��UC!gu%��3(5����Ʋ���T���G��0���)o�t�ɮ�=Kc����*�������P���h�V5+#�J#����px��
;�-�4�a(ܗ��a��zg+��S��󪆱�M��j��dӻ��#4��Gt��h^s�K��N��)��V��V5�6�/�z5�D�$��0��<�k�%��q��r�R�a�����p��q�޺}��~�Vc�)�{U�H(�y�>�i��_��J#�~�$*$�V�!]+H(a��T"�1]���f��kyl�ak�h�6M�IT5��֏�G3�Yj��{���y�N�0j��#.��I�8���p�]��-�k�5���C�������z��6���ȝ�a$�vI�Z�Uj	�����/V�TӨ���ۣuWK=C^srK#����QU_�j���H㟫�ag����ƒ���v�篣UQ���ri;2�P�U]��gC���篶U���f������T�`e	˳�a,����z�φ����n-b�����0�V��w0k	�����������(�\�!��%�m6�q�0�c7/o_�5ǊY�xs�\�F�����l�0�=�-��!U�M��0�<^V���Hj�k�T#!����h;�x�CsE�Uh
�]ס��Oh
'b���i�G_�����p��0bo2�v.�jHn�r�7�d4�q��ր�T^�j����O��M
'�����0��"I��^�0�����a�q��#4�$�9��	OaQ�Qj
�^W�t�/ 4�᡻׫.&��L�a <�{���)��X��
#������s��<����I��4"�U5$�o��;өϧ�f��q�a,u>Q�^��#��__�F�������j���8	�����Oy��-4�!{�?�}��t�+/o��!ļ,��d���1W�a$x��g����0�iT��T�e���0�.�j^L�h2�k�R�Pz��5~{ǃfJ��U"�soB���6.hHͣH�7�b��.~[U�@\.�^AR/��Y�H�R���`��&�~�,�F���P|UܜCɛ��������go� ���?������J*Q.      �      x������ � �      �      x������ � �      U   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      W      x������ � �      Y      x�̽ے�8�,�\�+��6��o)Uv��u)˔������!�E.\���s��T����<A\q������������}��7����f~3K���o�����������Y�&��L�n�}z�����������קO?�����_�o/�����������_L������|i�l��/�,Of}���N"�!����/��J�8��@����@&Fľ�|��{���������������w5�e�s2UL�}�̳�E�3'߿��.��>��Df2O"F�D�c��on2�G�_�oqN�;�1���<;&�6)�������/�������4=��~}z�������ח����?��l �ŭ�����|��-Y�e�����~���=��K&��%L������HC�����_�?�����/ߟ����_ߟ~������鯗��t�#���8g�[af�󼉘03�_{3��Myօ�����E��g�&�9����������Ϻ
d�g����'�����:����ۏo/9��_n�����e{�K�g�G�,b
>��|��'d �m�z��������&�x�4��?[߮��uV�����\<���Ǉ����D��~xB��f���M��暨U�fvo?\��s�>�|��ӷ����?_���������i:�	����_�4���/��o/O?�|{M��󏿇�f7�Ͱ����lkB	V��뿾��Ϗ�?�L����g}6��r�h��8�S��?���8U]} %l^N6?~�̉<�����o����b���'#�ت4 �����MĴ�N�ȋg�Iw�(�H��r���m�3r�`��9���܄5x��.b�~�������O߾|?>��r�ت����ǥ�D��f^�u�,�Ͽm2�f6�Ob�#b�?��)N����]�b`���ۈNĮ�_/�_��>6�__�����ˏ���5#d��W_�a�9���໮���0�[��iᱭ�>��U���_/_*ӆ���|4�1�q��ua���̉��'�EĺG��K�Bij�G���3���4�}����?��v�m�U���ݘ��a���ܙ1�(-��[�K���w�+ɱα�_��~��G��.���5�0��z?q #b�b���6r�+m��L�y/u�țj�I���p���i<�i1��}�u�	i��A6�M�$��!RcFV"v����lN V�<���^��dAB���6���11��}1�a1�2Ҳ��Q�EX���l!b�3���<Z;�<Y=�`�������8�}=�%H�4����tW����+{��Xw o��֫���
|�g}���kx��R/S���lVSY��N' ����f$�L���(����f� �f5�	��T�7m�=�1�{����������
�~�>�%����,M�"�Y�7�=�wt��CKA��(�oA%)�#��Ǌ�[	-��qP�����)���|�"b������ ��h�ƞ�*R8T9��pξx�f�"t��&��<��a�16c�:���ȑ���m��cJ?h���b2��#1�D9m�>R	��]�X�~�a�5��螝����CYa���l"��Ǿ~yz����-\��/k�灁��9Y�n�}����&6����T��4��l��)��+>�E�b>��gvN�|�>cF�pJ,��¡�a�q��N�Y��r4��|Y�1a]1�	�?��߬�%�mLNĄ��$2�'��$�=O��	�_���7�d�8ֱ��1m2�b&+�ц����u�����㟗�ǹ������� ����P���q1H��E�+�z��,Z@�W�т4��nׄ����ِd6�.n��6��=�9���wÈ���>�����c��]�	�18��I&��g[�P'&/�5�^ݝ�{��.�6�Ӽ��)������[.N��T\~Gݿ����_/�\��������@�
#G2?�I�K<O��0m�v�F.ʷQ�>���ۈ���4��9���]q�0-Ζۈ�F8��>��8�.��bg�FL.��[�"�;Ô�����|���m]K̚n��"�~�^	=�o���R�38��"6�@#�v�ԅ#��qN�&�6o;��ܨ�$:3�*����*^HW��z�e�_%�
���S��!q�h��c�Ap ���2����}K�8�M4�,b|m�yL�lW��.���wwS�i��G��PL��\���=���y�o�ݳ%�<��e�O��F�2�\>�2b�fl�/��?��a�$���r�@	�����	�x�%�s�Z�����
%���//����Q ��&�����DŅ��3duDղ>���p�2B���Л�=T#w[F�~]����Y�ի�Ą=�����҆_K�)t܊�U;�؀�h&��IZW|�����HX�N^����͕�i_%�ҥ%�(�\/R���~#����ьI֊����cP>V��t��*N���(�k����k���u�k?x����Ĕ���ۘ�o�N�����;45��^����0��X�����f�/���#5�;�uo]��@������f��w{�܋��:��_������ǘ�����&�#���ᾬ,��/�+4�6yC<�rA��Ěh��c��D/�s��:���Dg�=y'��$X�S8�Q�Ō�G�bƎ8O��*'O�a�01��n�����N����>��)J{���Å}�����I�������t|���,�B�r<G��t����TEh�Ox<9�ĥ�uE7�:-Н��a�
�_w'eU���_�S�>�^�d�r9���m�I'��y�0�sޜp|��T*����_1T��!@�R��'tjR88��$mj����d�\9&�MeW��JH�C
"�>��Q�!g�}�����q��p5Ҏj+Ƙ('��� 0)B�K�g�1��u����i��s2DDW�Cx�DP$� U��y�_�AI����b��E�T�G��\�� u�	&eYr[i�����ţ"���J58m��V�t-���$��ϐ���_�P��)s_�p�jpL�q8�q}��rL�^B��*�ƿcC��y�E'w�lC�wb�L�ѓ�W];�KWv�N��Y��	&�M�q�������H0�����Í#bJ��o�\t��ۨ���}K�q6O���^��/����o�����4�[ł�jio֊�0�/�R���&K8W;�.L�pz'��,l�5~���h�������>�U _�Ip�����	y�4��a��Yrb�Ob��,�u�&���7A��.���㭈i����I�&0q"�P�)#`�H�wFb]��9�f����|��)��\<���c\����ה/�)�kZ�g�^HK^ �@g�R�Xok�H���� ��	�����2F9��σ�l;����^���Xg>�!΃]m�����x�셸J��S�4�=E����UZ#B,��%b��9ǄK��4�ޝ�)a&B�[�U�Iú����["�!���*�7M�F��f�Pv�~,����k��1m0'
G.
�����dFN[|z������%"��KH������Z,B�x�Bsǘ��"�J�I�ԡ��GS�qpLn��ITl^W�c�nt�xMi"��>�tv���X'��A
��rsw|0:77��l�,@��)���S�h�;!А�HS+�!B�����\�Ό@u�������$��QP�Ȭ"F?���FT�����-d1����rF1D�$���Xg��y�8�t��!>P瘪B�.��
|,Z1C����ē^Ӈ�s�,���]�|�O�n��s鬎HO6OW�}�*b#�>�wls!b(�f��㭺 �2�a��vݏ+~;9X1h4�,b��&��3do�A�C�S3K	#��g��%��W��z��1�B�.��Y�Q��Yc���k��ڑ^�8�	���w���>ʖ�:�16	�_��fa��8��g���-$b��՘aڊ�ߌ3~?7��4�֖b\��֞�Út�:�/L�g/oݎcX3�7N�0�R<�2l�#D\��ٚ�[B	�:;p�    �uƑ�ƕ�]�"�c�����
�8�"bc�`"v�!��&Q}Ƥ$cD��]��8��x�RN��E���>HmC}لᶢj��!���<F:d>T���-Xįq@6E~t��(1��ZpACc/���T8;2������͊��H�x��1���2�X�2m֊�]8&|�+��9��J�7rl�P��.L��ø�G��+����Q����ķjJP3�ť�ے��p��b���_^�ފ*�^>���r��O�y�?O��%W<��p�v�DT���qp"6�@�!E����h����ELT�v�?l�34�@v��Ȫ"��˙�۠÷y9�(�bꅔ0�bQ;_o�lگ7�d iHCj��Č��z�]�NE�C��!"�~���M9�-O�1Ҕ���!2����S��͆rL)�7aI8���ƈh��`f�u�gK������[�Ԫg�f�ѣs��¦���ac�^p;E>�4�FW�F*��gQG)��M]�sb�E�a��E���6�.b�EKh�D��TDR�fi�j"�Ʉ�WK�(�C�ج"ƻQ�y��DG*�r�;����/1�����;qEɪ舯�&	hI�=�W�$(]��?�����������=4�~NT�Hy~�,0���1����t���q,c�N>9F3�p�~]�:���]�a�9�v�8���b-�_�^T1S��$K�̰N�	��(Њx���#�GT��ջ�3l�'"�fƎ'��_>e�x���?��y��Y�˕�>96b�aa��瘀��Ec�uȈ�4��f>K8��=�����CALq#�S��4D���|���m�۵�!?֤F��K��:aĿ�_S���_��� ~#�����7�~ �O�I�w���E�p�R8��U����������U��X�É�H%2�8^=��6��qs�)�c�A��f�'bV?�>��b>�����\�{Fkֆt��">1��˛<�;���"�
���?�a�P�1�r�(���r��кIҶIÆlDL���P��i���}�ȫ����*����'Ô��;����\G^8�|}�u�4���:�4�U�����X�+�2�+�>fcWzS��i�q�z��f^�+Ů�5Y�sL�R�k:N�d١�YEZv��H����M���[fm�j;x�E�%#y�`�<z�yN�5`�\\� 1��U�Fx����$��e:��pk�j�T�ܓ���O�_��x�?�C�g����Ǔt��2�7���3fs'Z�s6 �$`x#b�C)���M�P����1�C��Ȃ/Ȧ�&$�N�/�TX�
v�"�-��,�-���Þ*�\����bg]$b�~�j�F7.a��%%|(�0)�C)x�~X�>�=s��ybck7�eHI�O��"�1�8���ƃ��$ḃFR����K=��kz��F�ZM��_��W�!	n��2���f6�Q�2f�Y�4����t,����%�s�o^�V6�]ѓ;K܄yml2
�X���#�s�c��ϋ�)�rz\��g���DEb��
�����~�s��'�(���1`���5��d��,C6P,D��d��Iƞ�����r�c3�F]kGN���1l�^w<I؉�F}�ބ!WS�Be�б����9���`NJ���D��tt��/���J�0}>-��ʧ�����=�O9�����ܴ;�fE��i�]�������=%$�o�9�i��~zt�H��2Vf�:���w�)՜�%���d�Z�Vq	���H�ʰ^���|:|}�Tu�LÆM�����&�	-Э]�
�X9;���IJ�DW���%d��2k6`D�����ܬ�"�"b=����r�G.r`h��#�����j�6Y�&�"�c���Ȫy(8=6�#E;bڎo&��P�1�H<t���k.�*�:tN�#舌	oH�m	�B*'b��^g|A���[�ز�N�3���O�m�R81���Ck!z�AL�������]��cEP���8�}J�:��<�3�����������_O���3�g��/;	��n����ߟB%6�'���Q�_���*�3l ��8���V�m�d��!6t�(yHQ\;�Fq/��q.+�=<=+[C���&��X��јaJ��V�rʕ�L
��!�a=����f'�.7Ƅ�)x�X�i�����q���R	cѦ�s�Evб�xԕR	SFH;D��W���&ҋ{iXY��P��I��Zwf:1\�*G���������}1nDr´���������"�����J$��(m6썊-:�g�H6,.J��l�r�h���+>>�F�E%�*) ��1
0��q �v��%��y�)蚰|�zx!��#a�K(Y��K��X/�3�H&���E}������"�q/ݫ��&�Ǖ0�M��Nj���a�+b��*/��b)5�#4S(��2L��b�^ȉT�5��9�=�5&�ӧ��vF$�ˉ�p�����-��ĄC$���?����ģ���n���Wۉ���c�k��:����[���D��H[B��2����,o�.���/�~2�Xͤ+B��b�~ӄ3tU_'�Vɲ��~����)� �D��^�S<9��\�����ɽ�ڕ���l"��mWT&`'8io�X`!�T�n3����X�&��A�z���6����NR��j��c�s�aD���<��V-=�9�Y�?9�>3Zgx��^v���q�1|�o��U�t�!�!��B.��Vl�,;�u�>��S��"�)J$�&F[�h><�H��zE��o�2.�Y\;�EwG2��~���D�)��\@�����>�D�8;<@��aD����	V�$ֵB�L�^V���Ǜl)�P�U��uT�����0Q���'7����$�Ɋ���a|�v�5�1�v\��@C<iV��������ꛞ�������ԧ0���5�1]7$�c'KtiM�e/�����v�'�˞��j+��s�{�ei��4?P6.6�m�ﯨӴڼ&�SP:<B�c\&va�\�;Ď�䚟�Ͽ~~��cz&r{����S����'\ (���ȉƒj�P��}c���N.�R$��I���߾|��ӿ�6η�}7�
q�x�Kכֿ�%�^��k���{��/��H�\bL��m�#ʰ��3G�,S�G�9YI��VPY���-��i*cA�i�<���~��˽k��	���fg�V3���z��rb
��58�;y]�9��FJl�a~d> Sq�͘E��u��������������wWk+��9���?���'�������Q*b���ʌ�P疊s���S\�?|�qs�-�|{��'��z�KH��z������eɱ�����}9�X�ػ"6X�e"����-��]�hv+n�>K{���B�"�'!�TN`����Ĕ��9ż���d���w��..�I�i�`X'4|_#f7R�W�#��D|]��<�N�H��(k�Y�fph�R5$�J[n�\����S%��Ћ�w����9�b�E������돷/4�Y���5|Gr���=�M�X�7<���v����#u���ڮ�� K]�*b�[����e���;ON�I{��g�»�������sb�������<�1�ZU5KbѴ޺��E�q&T�Kc���j���Yp����
Ю��{o�ch��t�]���Ͳ�؃h�QIo���VM̉���n��ɑ0_m���zw��σd�N�2����p�u弘l�Uta\G�GA��!ʄSn�i�:C.{.ŧp���|�L�>q���ȁ�>�(����.��xX�h�̅ i�)��+��1a���A$s�Y����fSb��v��!����� tb�W��#�˿��d�6F����"bR���@���<2�͆�+����Α�:#E��m���օѧV~�a/y�莏Pe�����8}s2p��{]�t�o��s�ax�oE�n=������}��8�_Z*�@������L������������{v��_��d��\Nbc�v]N�٤ky$�i1� Kf��Q}�fԣ?P���hRrXz�˓�,"��zX�!rAN/L`��#��!�t~&*�BKL������f�>`����1��O    ��^h\b��O�"�0��B>��{����k0���1�Q�ښEF��B���"��~fռ��FՀ�q��1�{��S��	������ō��#��&ӓ�r��K>�w�N@n�r�KL�N�_hŮ�Y�d��~]���W�u�gQX=��%�����4�"vuw]�:+�RR�x�x���0�k�KlD�%QW���4�7�
�|�u;�B[	��P���-�v�9
���s���x�t�)�a������p����ȆZ�pZ�TLl�����������ͷk���E�T��UVd��������ȭt��6�����L�Y�6��8i��p<ؓ��ϼ�{~���O���	Q��%��{���4��7[�CG��0��&Ft5�مW�lEL/��u��\RQE��D슚~:f�����W5���DFKl�!��]�ǩ�!Bɥ��NL�a֧��ի�Q���E��pOш��l�a����q��ELP��m[��}�	pYݸ�v�B#�G(�窆˂Z������>Z� �ޣUAd���r����E��4I��
m�����]?��W�t*�d���y�;���+�O���Nw��7]��X�u��uȉi*d��+Y�2*��uiم
�M�:����<ͺ��4�^<�3l��	�aCt2������2(1���'�.��q�bAJ�M�l�@zwN~9�e"Qyj�?N�4�C��Z���i�،Z�R�+cS��B��R[�	c�4L���׬�ZTF�x�y�C�ޠ�R<Gu�pf�V}s1��l��m&�TbL���T73���M��+����=����J/�	m&DlDN�<|��1}2��ΤW���f����0XPm����0*�v���_xq"�_0��&b���dD��i�d�%6d�<Zc�)�
���g%F�A��$sַ���q2�ǉ ����Cc�.�4���s���e��瑋�b2���~O����Ǩ�^6��A��N��푖0�[u^�=�P�0FJ�)8X�w��nH�Z�.b�bolGK���4��K�1M�e����FcH
�p��>F�Z]����&�� &�u
�%���7V�dI��ݶ�yya}.����0mn��^4c���4�{�Hȏ�w6G�\�f1I���r�;vF�f��dY~p�)=:����g[ЎT4��_�(X��q�����Pn���Յ�io�l�=�+���7`��������F׷-P����r�s�F�azE.��W�˃A�H@T��&''�N� ���T;M��t$�):V��U���X�*F����i��K��ʰ���h�������|�:b�E�?C<��vC�ֵXk
���2l�|�9�A����(P,�~>'b�m��t�B���rw�,|�(:bHpl�tC��-c�v	��S�g.[?��L���b����Ϡ�Jj���n�%6��:ä �fxK�mc��^������<Z�*��Ay�[���eY'bLY+���eL��1��ݣ�%��IQ�J:�L��o�vÉyф@���'�����!d�߳C�a�9�M�ڝ�e89�h��G�Ȧl�5Eu�ú�zY�����)�u��F��N�Kރ-Ǵ�H�i3��x���r̄�"��N�Ǯ���ׯ�?�ؙʊ������	��EgoW��/�1V�S���Z��rH����������?����3	^��D\� ���y����R�����Ͽ�^~��?O��鿿�b��C�C3T�C�/4IF����lv��ח��oz"�zʺ�%T~��9�U-�j���5W�n��9�V���
K���;��U<�#M��N�`��b�q>��&���j��a+��6��L�[vVwr��k���N3�Oc��YE9cQ����k=����W��h)ǚcc�;x����i𳈩S;1����g2f�:�$�N�tR��zw'L��s:�4���8A�f�㡉G��C���8az�L������l#b�e�bcQ�F��=�p�+Ł��aa�t�Đ��i
n5�L�En�Q<�7yd	ӽ�.�*r�ߤGgċӡ<����<g�v�k�G(��hA��EF�݃G#귉�=Jx/V����w�&�㫴�jǓ,�j3N�4����6���$I�	tL~�K�e[
V��{P�	1�J����!b���;���O����f��d�722$Ak�&����x��g"e�M���Z���4��=IǤ��`������q�
�^}4����G��fuov��������G.d�T�=��h�&Sf�T�����})+b��REe�I+R��*���L���P�sM��:|�#m�,%��˥ _Q���p,<�dn4�8�̂�5�V�mT��D�uƗ�F����A����pPd��8| S��s0�w̹`�Wa���6?�H�F��R4̽F5yFg���bD6N�^n�3�s��jh&^��b�l�<E��Z
��V`�Ϻڤc�6�ϺD�J���6E'��c�r����Ě\�h�*�����rL�&N���h���Řb�.c��㥃��['��Qw�� [bq��)����}VCs��(&h%�uڃ>[/b�u�O=�no�5ȅ�Y��b��ˊ_�ks��qg�ˬ*.K�!%�o��	+�?OF���t�4d� S��"��R*RX��Y����	%��y�mD|�s��5���1m�;��.�/~;`��69���=:9��|�zދ�^�_R��������nSqPgDL(`�B;�k�?'�LLŷ�Qk�!��6*.�~��5�D���<���*'�yJ��LS$����謰�
��Y����iEu�k�B�$J��ƈeM11�5����6(�T��¸bC.�\U���AL��!W��Cm�fK���!�cΫ�sL)\jIy����i�qy�p�i$O�W$I~�;:������+���`mgV��%��� !�ۼ�=�/b��t������sI�n����'*ܓt#�L՞2J��D���pO��jHk��DQ-��1^-�9�x��a��|�	������^�fN!��Ž�w�"�p�@�,� �*�	�����A:�0
��-�_T���q�$�S>�Xϯ��4-M��D���VK���1�(�+R��jQp�gr_lBP+4F���NJ5������^���m˼�?Ǻ�����!6���v0?�ɺ�)d!rl@$��2�$��Ϟ�������J�̭<y�Μ
/D�u�!I�R���}0 �����&��f��� ;�hfn�����1�4B�������]��cǖ�"�����Ϩh��n��"`�a�-F�h�5g�1��l���.�w��:|���˒��N�Ƌ�@9��'�[��_NĴ�S:\�o6�d��̾#���W���R���jf�}��P {l�Aك__���䰵W9#�yjt�z=ǿ\�o.m��m\W��f��D���q�����̫�[�tY*^�;j9��C&(�k��kɄ=J�6Xȧ"r_�ŗ���k����o4��@	C�h%��;�O�C�L�X����\�'�X�3_�댮�u�B�PC\>pSbrv#��&]%�KƋ����� p��.��D��Eu�]�@������;	�67�e>��ݕ��(�xlpt�h�bp-��81���ŐI��H����T�t���;��D��6R�����ƬI���vdM�E�o���>�N�c��`9�J��o4c�м��/:1���U���Ŏ�;�hs���0lW�3BO5�QWo����y�_���ӿ�^g����˗:���z��Jl�Ox�>�.h���x {a����~�X��	��`D�A`b"a��$
S2��{�Ĕ�ڳ0p�CL��1���<$������1�u��t3/��}��J���������V秤s���/�T���N��W H���=b�v����H	v����$��>)�凫cB�3��V�i}��)����v��_�rLa_n�2,	��4fG�_K
��N�Ә�1�k���8d��eL|�޶!k�n"Ƥ���6��~8D�K�?a��;�m���AC#�W�"���v7��_bĽ�t6��    y�����]}uS|�6��$p˚���(�p?k�>AU�ln2��$�	��h�5$ъ����9�p,�Bj�w��\<d3�v��*~����cFt����nc�ո�o��E�?�
�9�ӰҁMTBs-�^��uFLLC�Yx�p��)�%&���b��V2����ib�K�m"Ʋ�pCx��軈u=�J.�?�e�a��y�	9��r�K���R�K���r��B�67�6��7��u����M��J��d�r�kY8��(�-�1�z3���呿���<!/bhb�,<I^(y$ﲽ�ƗXg��tl�9]�4k��7"�-]qU�C&��G�%�ߍu;uW��i;n��S� +b�d�t��z_4�B7 ô5K�X5$R�\qܥ>}6��e�#����f
^׷�ʸ�f5m �
攒��Բi�ױ�)e9ؖ�Ǵo�v^�G[&E��L���,�h�s��Yc��h-�4�9��"Ƥ��;.��a���׈�=��d��/�9<⮚�{0�-�0��7��k�݂�gn$�X�]�r��P/PQ�&�TW#b:�D�ca����n�n�1��3aו#}j�E=��'a#o"�d�Fc���
*1u6?!�po�֙�2�Ph�S#��olv���;����%�˓E�M�'�V�UĴ&+ᲀ�,�E�4����r]a���u�F����$Rb�U��'R���Q@��J'6�^��Fs0��/b��hܖ4[F�zo�҃Jx��؈Y����]�yDwE7YM�R;H�
���H'w~�Z$��؀RΊ�vNjyn��m)��Ϥ�Zc.�1Gŉ�6�co����F����^ӧ�3.D��9c���o��i��,�;v�wJn��=C5���L�K�����*W: ���8^ֺ�Ca`��֑�&ͻfR'X�e�p�i���_���Z 7we�[\u�\��we�+�L-�7 ҳU0��Hc6>l��xnY2����{�tZ�D�s��M1��E����f D��4��&�\�v�i��]B/pE���P��Je+�߅i�L�<p7`�DL/#¸�W�С�t��Sx�P]�Щ3"b���
-��~Wj��T�DƦ�X6x@�,bڏŹȩkcLR�4�,� �c�:=����0ACL��"�Ԛ���e�W�0��M�$��6��+�N2Lq3d	Ø��z�ɱNĴ����'PM�p^����G������odZ|KeY���'6���8�>�ir� N4�3sw֒ڰsi�ƅ/2�+8a�K�@�[vEe
[�b\�ӞVSV�U@�h}l��*�jק�̓�9kX�ft�{|R[T�2f���XFĴ���2D��"�,�h Ə%K�},��>v�-�@/��"�W]�i��;>lHߎ�Յ�i�"�M~��m��UYe���a�D�/�l��qk3=��[�ȰN�5t7���]��Y���:tG2J�D���P}bv)aAvDa��Tunf#�īU�/g���Ɯ�ň����m���wL��ba��^�_b�MD0%77q���c�lZ�a��f�{�M���0����Ӿ1'������ZQP��>M�I����~����XS���QTX��̕g/�:����2��o+�Kv���"&��TD�(�m�����9C<��8�I�Z�U��Ĕ��� ��;�*�[�aկ`,�{@�M�~f/���*w�Kճ��6�����#��9)���a���g�г1e*��Q��(���E(�%�1ٻ�a���O��.+6�7a��l�I�XҎ�'�J*�ah��k��k?4�C���@��\bLڌ��kv���k0a��a�l�\(���ڃ5kaU\n���Dm^�����$L���DR�~6E�(�ԑr|�2 �7D�{�kȄg�2����Y´Y�,���\�{S�S6�aTV��MVxI$�/h����*3�CB��D�`}�fC���1U�JFC��1�Px��3X۬�=.&�"����e�[Y�`n�
r7*�ɉ�\��a�0����6h|7��Om�(�a�vz�NE�Һ�:��P�P��Q}�ĒaY���;(m4�F���'#?r��X܇4TQRBVk� ͔���8�brN�m;)Be��V��--�=6�?�/b����m��.!�\��xRT=�/l !�;������,��0e-1�bH.��o���2L���_�n�U�K��=�vS_�	�
.�� w�`LsQ��aJI�	�D�~�����8�"���2l�	��� �t`v�*��o���_�^+�뗧���ޟ~O��?}�y�����Nt�v��8�єc:�8c0��XC�c5��|}����9���|�KȰ�� ���x���H��C��c���T�����8��BV���a$��B#�y��3��2넛!�ԅ��8���Sie�_7)䣖�Ic�"�;�dx�ă�
!cd>VeL�Y,��ŵ���FP�X�����:���(r�:�M�X�0�	H��Vj�5TGL��=VrC��ΐ�Y���$���k��'V�H���'zP��|���	ky��V�����>��k���z1NĆԑ�2����!��@v�6UG��y
���͎���C�G�[�Ew��=z���1���ƕ�!�5�Vd�e{Hu�ﶫ���W#��O�i�ǺܚZ�d�ċbjVm	B��ӗ p6}U�|�z�&�c������6���P7��=�R��k.�*�z��?�&&�ƗM����}8I=c�
=Zt4��X���v1�T��
���zi4�(�a��1�����ׯ�<����w���	!P�U`�k���������<}l��/m�cO\��9�V�>�4��3{��U|��B&c�cڒA\7��,�E^�Mˠ����"�f^��p��������7�p�v&s�H�n��9�h�AC$�)�'��"�rKﱎ����\'sq~U��|s���6X�A(9��P����v����1��2݊�$�;�<DM�q@Y�S@Ҩ[�T�0��!�v�˗��Rk�\��A;�kz�tF�%�+���י�Dl��	S��]Ҽ]m<f]���I�I�WV���i��Խ0e�j*��\4�P:Lo��!\��A3F-�*������B�=<8I��_i��6z�JI��9���� O�ʰ����R|�jf����b��ȅ�U�#����7��"hV�D<��`\A<�>��x�b���5~����z��e��B�#;��m4o����D�T���17cN��潐��0������[���i�#���]�.��S���C�b�}��i��#y�D�C�y�p��c����әa��.K0�|6�m��W�-T�x/L��z#1>{����fI��57A�Tվ,}!�ns��X�S����&�;ɢ4_�������|���)N����J�8��qlfv)%�Mh���?��Ռ%�[�g�u-ä;�V������3yZ�ܪѨ�|@���n�@�l�!.��\bĘ|\Im�%	��<6��H��G��B�����L#r��{	S+��Nn�6b��}�2Lو�Q!��kM%��V�rb��1�&_'m
`j+�+6���0ܪ��cO�\�0Ø;�एU��t�4��z00r�D6�64/���#�g҅#�y���%'b4~��+9e�A
��B�4���god#�
�RtFgEO'��<�s[g"P�k�u��g����!��٫25���O͆����n��p󊘾�%�s��.�R�,K�w�c��WTH��&�����0�~�#�X�����
�N����\Z���4G�/��bv�J��Mch��Q3"6(G��/��4��NQ%ԉ�ȋ`�6�z$��y��t��Ar$u�y(*K!��a�-.���Ǩ|����#YP�Q�lET�I�g0��苈u�*.�F�sr���E��V���q�F��vf\*C"c��Taܭ�g�������J���UP�����+w���=�(�<�9��<v���U���J�De/"��X�7Q���G�m���Oi�u������Qx�Z�Q�>У��    #���X�	{aR\�����'��z��>K~�M��mJ4��Fڑ�{j��O��q�T�Mx�:����^�h�}[���Z�v��eJ�)�l�u#Z[K%�/fk������"��a�F�D�b�z C>Vl����I`X&/B�q�c~���7dv���x�%G�W���l��&�F�";r*#3h��R�9uK�D���a��j��� *0��K)�aC&Yِo9��r��9d���u�r@���k��X{���a���OT{�����[3L�� ��D�tk6���A/bZ����;y*7v��v1}����Xܴe+����Ds�tȱ���]{5=
���#��F�J6�Uѓ�����������J�qf���ؼp���L�'�eݔ���3��S\N�7zC�^�zc��"�El�����@����`]/-U����c�_�_���ىiȺ	r;n�U9�P�;��Qsb��� በ��LH㤸Ƶ"&N�jtR�ט{,��"6$j��
!U-|��P-<&C��k*Tr~�Ӻ�Wb7k�	\BO�,}�s!�SҼl��c�)= �;QXjl�=��5Tv�=�.A���`r��XNI�]Ĕ�8��[����-ƍ�j�<U�Z'bZm[����^ߔɇ
�1��w̭�Ԉ�������1�W'�k��C�iۏ0.�$���@~�0�����9v�e�FGf���*9�C����9h�R��e�@{䙈d4*�p�����R]�6V@N���k�i���]���gS�ӆ���⫐х�[ab.�~�a����^���!��#Q�o�	��Sr���CQ��$g���|���s�v��E|b�L�{�%r>����"���R�Xk_����5�"�mx�k�y�'b�	R������ST(9\I��!CU�\T�gX'JTC*�K�J��	���^���j6jC0�e��A������b�2��]��6�y����_?�>����Tqy���쳲D�?�v��y�Dl�D9��E�j��y��2�M�=Pz0�������Y|���9�i�E��lC��O��a&��])���]:/"6(\��ͼ���[y����5:����Hk-�����O���-rQT[ɞŬF����m�}x	���f��+2�x�Z��
mn�M���E+97K����B8K(ͱ������˲TKh��`.�/"�Z��b�c�a�i�TJ#Z_T8f�ҩ4�t�4yi<*�{�fh����f�,b#��8/h6�8�m��>�F�Ԍ�S7��?����6�7��DdH��09!�X��)� 3�����4m嵍��P=/	�H�^���nIσ��7EQj�1��;�HK����Z�"ܘa������h4~11�%@$�D�%3��	s���lC^��*���LB_yX#ôI��.C��Xi\[�@2L[�Ĺ��!&(����oks�휌Ƨסp�m���ާ�?ꮭ�O"�� N��������T�tf�@̍p��b�|������5��_C5:i��k!�a�,N�KD|q�0�;���0� .q5W�fp��#��EL���U�g;`�qme�]��U���Yc�aK���G�C�qi�0�/Ą3l����mי8tT1�u��X����R��)Y��`N<H,\����n� ��(�/�o�&��v&�%�(=~V\�C$x:}� ͱ{��}�+���>�����Nz/_'����2��é���DL���!�X�Y+�x���s�i/��ٓW�����pF��8ܰj�ʔ)�[�d�C'֗"c����޼��8��V�2�kˣG��1|/GeT��%F��ᵢ����UvHS�h~�A� ���0A�4�"F'��L�J��
� q�R-ǔ�c4Ąʎ/btN<��o�R�ΆkϹ\P*�`B�j�C�>��U��ۀE6C��P>����
��y��b��ŉfa*4��z�^z)��`��
�����`�"v�"Y��ۏ�(v�l�]D͢��-�DB^ٔ�9����pѴ#Zo}@�7p�>֎�#6���YlQl�a&F�M�
��ƚ+������L�#�I���i�JRb��OlS�ڴ=7����0U�M��gؘ	��	�Xz6fGz�
��e+�@d��+U��4DcЬ{�z-r�%P�N���.b�g+1e"��s���Z3:)mj�.�riE�����l̅<�w���|�������a�kJ�����p�*0E{F���4;ʅ��*zbC��P�;D������T�߇�"��
��n�{�]�����c�Œz+bC�e�;s��c@ǉX__�q IJ7�φi�e�U�^�M�գp��7��$�Q
U:RB�-7�I�0�GC8dfȣ��	{<᎒S��%*�=�6X��)�-5�1��GXH+z��~Eky��gu�	][;	S|��Z��ͱџ��lj�'aj��.���f*R*�nq�u��'u�Z��Z':���Mь7�4
�yGM��gNe�xL˛�ĕ����fGO�㣐me���d��z�(ȱ�֕��Y�0"C�}!6��q�B�"��c�V��N��J�2��NCDr�#L��,j�~��"b���0��0�]���aﯪ��E��=p�}�w�3�=�}�-=c�U�aZ!(�e�u��>a��9�Q�D�C�����YEl��)ӆ@+ȓ���HA��y�"&�O�ݠxb�O��S�I�Y�X� p��-RƠ:��M�q�EL-s�%�4�l��1Y�Wx�!2"خ~9%L�DYi�^���~�$L?+*RX���kw�)�,b�����8�nA5�cl>���!�x��F� tG���J��сsD�]p����b{=�4��zd�)��"j�a�ڈ�h��;$,�R?���������
����G�)��\`�[�|�zw�t�ޔɮ�-���hd�6��4��
?�IUwC"��vU�iIe%И�?u��{�)c�I� -��0Bw���(ôU��ns蛯5)��R3�"��n1xE:N�UCd..�B�����������0�z݋c�/\�������T'iܵH��0ŗ��N�0[(�j'��6�!ӛ�U]ݜދR�c�6>�j��98�m=	S�ˑ�+�*��8�k1.�Fڷq�"-.��I�xŚ)�9eC�w�p�0����cTHb�"Pيt�(���H3k:<t�ܻ�c���7 �¹2�m�2l�t�J`g�H�_agͮ�P�0���=�)��܈O��o���ǅ���#�Z�B�P_�]팮���<��$��8en�s^�c�7F
�v��ͼ�>�ؽ������"�i7��X�`^o]W���#��@n����BP� �SC<q�sb@Ѭ[�79�,�6�:;�S
y�ް�f�1Q�u�lKH�������+�&�p?���{[J#F�X
02"���t<Zg���@z,�3��`,&]��I͜�\�?�/����b2[q3�f9�Q�0m3^,y�7l=U�9n���a�*�E�I���jw���bd�V�oɄ&��GJ�6��S��Fz�ɕ
��ԍ�=f#E����ͤD�!�׼�������}�0�}{iА�V?��Z�Q]B*�YD��׮-N��*�~�"�����n޵1��������vQy�b26Q7f�Lav��杻��V��Le�\��N��>;�O�{�Ͻþ	�j��&��7"�y��w��ϙ6����ι&�0����n���xL�Ic՟&a�wK��_`jdj�ףQr+41�(5n�������E���MgS^�_�^�V���[*^A����DV="����֌6�ڨBz�6|Sx"��)��D�|�?�D�(Ѽ]�%x��R�D�!Ѷ:�O���(�({s��p�̻�)�;B� ������3�@�Ӆ1g��q�j���W�@.'#�hu�"��
.�.��y\��);�^#9�p�� w���آ��
+�+#��	s�*�s�b#ˆܓ�I�Z/.��iCv�hC^��@cHLn���*�v��Z� ���ب����,�H���8FO���
Xl|��}ht���Ԫ0U    �ҋ����s?F�iW��s��S���v��ߜ���i7�D%z��!��Օ�=0O.?��.ZZ&�D�쿖�1�D��V:\"!���A:��^�ib���K-���Z��>tx�N�/ǅ���q�������t\Ve��g�*Yn7a���a��;�A�c�w-5ye�QכA"�gBH(��!����bZ �)ø;��#e���$���#�J�]H;Co�:>t%[E�i/	�cܢ�~�e�\E׀^��Y�}R1��~��H����'9&��nu���>��"J�͆N��S����w�Z��V6셰�<�1:�~Pq��}�HBq.��2L3)W<�CH.>�'E�a'Y�֮�\d��K{�N�}B�3`�]ĐR������q���O��4a�8�i[ m��[��_w�*0.L��{"�t�	Y�N3���PM�h�u%�N�-!�	vY|��𻆬7o�Q��V1������@e/�[3�͒�O���C4�����!��Y8���)��DW����2�(!�N;�����^�]X'1���~M�&5W3�������N�k�s�A�ŉ����"!��<�ᝐ[&b��	?��VuK�i��.��Y&�,��]DI�2
za��wEAF���� ��=&
Ǘ����? Q��a�T���zL�xF���ES����5��E,�G��X%��K��L��/s/L���|.�Dr������1e<�r!7�p#�Jɿ0�#�R�����:4z׭�����:ov�M���pf�ڷ��'�ʊ��9���{r�i|�a�j|�i��e��c݆:�D���%�:�4~�o��°�� ��օ��Dd����ox����n�]��c��ߋ\Ter&�29�C�-:X�NQ�hmQdq��?_(�c��\cSO��l���cu���^_U��]r���6��:V��'��2&uG?O|��w9>6�=,t������萒���B���K$�5��'-s_䘶~	'�NN���m{^2�Υ�XrJ����z$��k?��!G��ar��r%6 ���e#�E���h��H޸��w(b�7�cf�.C��� w�M�Ő��������6_�p�t���]l��X�%�f�-�֛y������ҾϡC:jM'a��5�%䌴�s�����c��0j%��Fv.Vsк�)d���G��eBo�X�߽S%�>�[PsӼ�r|���~7�S�/�������=�i�sd��%�Mڐ����v�`���O����]��|tuo�盨��do��Rx�rL���Սن��(���>=���P35�"�,��|����?aC=p��͈1:�$��ª��5]��Ȳ�U0'�n�}����&@�����NlF=�l��&�.�B�4�y�]7��"ڝ����{�����,}��p����!�l� il$l���~�P�EL�5\}ʡHӆ����S9V!cb�D9q�-���-Sf	9�q`�˴`���f�*�A��_�\$�X�\���8��xgt]Y���=��<֘$���zdؕ.@,/b��fm��׸*����|�T��u��1.����ӗ�/�Ʌ�A{͙���\o�� �'�5��zs�W3J��k�����8�aY��r-�������Z�&OF2�mѡ���H����pg�	+b����qeOM��>�1u?���h�1��(X��18ҿ	5�P.�1�ȃ��mj2�Q�_L#�ܨ���t+��DL�q�_ �ڿ*������3Q��)/���7�U8�M��#����6:���\v�V-�7R��sl�Uy�9��N����S��!7�|�G����T�ĭ۵�H�'�E�pM:G�W��-h�f�~9�3�v�5��4�[h��N�8��X��zj��u�ߕc�Kh#��P �"���&#=�]Q��a�����@�zpe��0**f�Ii��_�1�6�s�ɫY:��-�����-�y�LB��&<P>wb��C���(��kkzԋ��C�iL�km|!k��.b�x���0&:��A���U�	�_��c�9P��x��Ex��y)@�q��<|���"�;��D�BD��z�"dS���n�0�Qh�����64�.A�� *�<��q?���K"z�Wث��qJ-k~���u���KBQx��<*V��a�T���$�ݩh���R(���<��ƙ9�'�����пl�^׽�\Fj���v7�j�0�z�d�(s�j�z��*=���:C�� y��3/f�����0��
V�F�צy�]�:�^-��"�H�6���m�*`����8Ǵ��W.`�&��q���ǎ�y�{��9�Ùc*��J�)R�HzI,��I-��y��q|������k;��%��r���va[�����9Q�'�2|�����0Ɏ.�H	��C@뀦Tp�����|�<��C��>ۦ�h�lmP<�b|9���&��r�tF���&̓"_�>����cr;h'U.�ز�)�Z��t��Œ��I�TŔFmJ�VE�O%�U�)�#;Dz�ё�M>��q�3$q\4yϟ��X��(�%�F�&	S�=�hbm=�y��I}R�V�����Rƈ���H���PCLt�G��dQ�vc�Lgg�MĈ	K �Ў]g��xG\roe�u�K4ƣ�EӬ��-�cɉ,n-E0�1�j�A�}��h9�����%Ɠ4a�&4�F��ⒻB�֋�F���I��BA�� �,���EL��oLD^�
ğ1�e1mvFO�_b�ʗ`<6rpN��؊`k����m����ootՃ��KTS��[�:��ѰuU<:W�o�x�ȏ�!�4��Ħ ��ζ���Bep�1M���)�A���c�a���`��(WI��׬{�'S&��v����L)�y1��\^L�c��[�T��U����:3�� {h��#�l��UK�O�}�ʅ��/۳s"�}XčfC�e.J���y�DL��sJ$%ڒ�Q������)e����4���;C��n���؁ƈ�c�by&0���n��c��P��l�n�If�����N�?���T;j.f��,�2��cDL���������t;8�p���;W�*�_�Ω��(�sL�<���N�5���jF:DT3Bh��|��8��y�o��G�a����ړ��D�����W� �aLk
���e����QFz�´�~�Ugtv/SQK�a2D�8�ш�xS����I=�5���&ho8��(<���'R�V�K��!,bZ.$W�5CL�oc�Ä��xD��ǔ����B7o?�y���H#��kw$�p�f�&��DL)�H#%0ko��J���C��<ʣ�Q��8�H=�����i��8��F���I�N=�ǉ�x��$��Cq��ה\^{�ϰ_��%3�c��^�c#Ht��u�P�p���gfXW ��� K�gx��QA*S��hz����5�v���:e('�Q#pQ���0��{<�ϳ�m[��RO�\ �4.M/�����r�9��xX|B��MW�VW�~{�g=%rL������wä�.:ltbЄ�Lܮf�v1QW�[_}��F�%w3��n��F��F'aL����Q�����M�(�}�U��m�@)<Nj�ԏXC��ǉ1�ӳ6�&��a�+�D�P���w����:DTuD"�1f���#��i
�DlD`�v�K&#b���`U ��f�}w��0�M�BdW���&�<v�O�j&kTJ�EL�5��ʌ�E�6:L����TE:ƂV�*X��dx�U�y�۰�ع�J�~}�^�u�%�����0�I�r7�U5^��.'�� 5�ޫY��H)�m�f�	��xŚ�t�1����چt4�1����*��%����A�ȱ��;�Y����	�'n1m�!N�\���4�1�+���m����<�-�H������`�v���-AxLD���d��K���@d�
'��ņȨ#s��&�G��7�ѥ�ity�a��&�>��uQ��l\M[@\���u)\�m�y�h�);�ЏR���De��xȕL��V2)H-���\�>^�K�u"�Ժ�7�\�-�XS��"���M.Bp���S�
�.ܠ!=DE9+��1D۸�7�    ��0"� c�&���:ڔ0� �!���蕏*�%�&��K!��a�FL��F��@��&O�6H�L+~~���\��rr���Z�P덮v����E��P���¡=��1e1[&P*n�����s���n�o����v�=g��g�2�^�v��i]��J`��^���YI��<_O}c�1��S:Ri�@�qy����a4XC`��evy[�SK�1ϫ>�è(��0�bo��sH/�EL����67���p"��	u��f�r�A�$��I/�9=>��v���������H���2?4v�9߻P�r삼�H�)�c�ŀ
-.�l6�jB .4u�V1K����EX��/�/�y��裡S��w����b5��O^�y+"��-<ǅ�v�g�]�9�\iC<�LB-1ُ6D�a\`����Y� E::1�feĢ3�.b�y8�k%87k�:�a:u ��]lU#%��A&�>pJBR�����~bz�뜓C\�D����c�l"6���u���7ɯ1r�&�ƺ,vsb%�!&�X�a�!�wM�M���VĘ7w_�'��)p�s2H�]>'s]��<Tސk�U��0b$@�Ia���PK�%LW��(a����d�h�a�Gi��Y'��h��`�i�u�pKU''C&�p����%����cht�Q�x.�h-�IMC�l�/}F�Agu�3�{�?}�"�����z�V�{Q	��X����I9�2�9�����7EN���R`�m�DL(�~:k���`�73��w���ᢻ/�?ؠo�ǃ�%'��޶�t���Gvjj1���ϗ�'�O��/ow"�*�՗w��6�W�R���Rl��y���w��*��G�x��?e���������=*�i���_?�>���񄧧Ӭx&yxM��=�d�M��=X�����c�>�`��+����g�8Ô���m=r:Q��9ٗ>F��N
��m���xD��(�V.��v�nɫ�rL�&�F�\h> *����d��e��&���&���R_��M,��B�W���� e�mu~vs�ґc��K��� ��M�����V�8�*V�s�d�����9A/��R���졢�7M� v��J��ׯ�����vn�]��ǉ�.��!RbL
KR�P��z�U�.��R�J�0����3�[�&*��"B��Gl��a=�N�q^�$�P6�è{��ᕁ}���_���ۢ�ڈ��s��� ��`;�+�P	�¨r#|�u����*�=xXM
b�DL[ѣ"�.=H��(U�r0�j(,��_�u$���M�.�\a.Øg��D���r�M1�c0� �p��VSE���e�R������c���{<��ǃ<��oT�@��2"6�|�����>�lC:ߨ��#��XI��q慠��j &'b�zF�S���w��Vf	��X�f��G��ƈ�@���6��u,+b*��aXu�඘M��!ØQ+tV([�w�WzM0�ɓ�h�||��7^Ę����k����ZF�A�*A�A6{ ��-O|Í�y?`��J�W��`�������bb��F�W�t�9�VR$'���w��eƨ�����Vj�y�e;f�� 	�
>Zl'�I�~w&8R��3�;�Hc�0�:d�<|��Xv�4B%�y2՛��d�X|� &N�t�5�ǆ۴T���h���&b����I�=aʚ�s༲"Ô�b���cm���W\Χ�Aa�ի�ז��A=�>��qg�p�K��#�.3���6����/fz73�� +b�B`JE�� u��g^�$Up�#Б���MĺYFt�D�1:j�NH�Qy\�sC�F��J�I7ꨫ��f������5�0.�r�ao�@C�P�!�!�HR�� �䤓�ɜ��f�C^�e4�t��Ј�0]������CU����`�#f��3�G
g�x��(�"#bRt@1�f<�X�	��\3l�~�`�S6�<���B TvR�W����E�8tt�M{�k#7�0�1|�^�=��J��CBw�i%P�?��sn瘦��-�t%Q=�I`��*ӕ�0x�J�^���rL�x6�~��1�y:8�T<V4���/W�,E�<�t�X���<�$W˄Qg�n���ƪS���QS���JI��L��z�_*��)�R�^��S��lܖi�Z?���&#��~ ;���zd��8��#�I+w\���o��RV�i���$݊�:Ax ee�f��a�b����ߨV���2����$�
��!&����_�޼���Yz4>�Y��?
�
#b]?�m��l^���$��:�5�t%R�Ē��"� i�vR�/�=�� H�"�KQyZ5����e@���Ţ1��R��V8c�<����H���v��R�F��"bڒ5�N�1&��5�c��>�Bi�3�0�[����2���UO��l@�cDx���Ap��]���`	�z�j�L���F�&�G�Ν�O��]���3��(sg:L�F+��#_G�1�NW�T�-+�1q���]�\�/��8�P�:�D'��y8�ª�Gp�lm	A�&�B��B�񐭢y�ӯ��fr�41�9ԤM����ô�)CT��������-c�ͻfqb]�]�5���� ����1G�h{0�QWSs��m�ʲʊ_c��V5��0n.]��c$*����2�<�I�m�,FĘ�%���-�F�-��[e��k���R}m�Q6��FD�������T��}<˷B�%�XI4,������ ��[m��X63�V�jֈ�\X�����ר^�t�`�c�؁V��~vEyQ�aZ�P��Ⱆg���� ��6��5�%&�ϱ�����.��GF�zI��x�Ta�=F���0�W [!����u1�W���D�a⃃�L"ƭ��
+}Bn�1"�)�<@�u���>9l$(0�3m�Y��azXc���}g<�o"��>���T�y���YP��xc��Ka,_�;/Ly��x��8��:��j�0�I�*&��q��P�X�"�A�l���:����Cz6"����z�	Θk&������a#�A`�S��06����ñ��͡�u�DL���"Z�,����V�T�R���w TV��b��y+�d�����<����P�{k����}=DG�L����kMfϖ��B�)��pF�Ź?CDT�i�Ǝ��:��T���0=y����YI�	�u�B1ô>O\tf�I;�D�6�<@&���L\1��u1曚��E�e�aa���F�D	��Mӣ�ܛ7���d1/e�R��ʖ�����{|hH9Qi˄L�Ϋ�i��!�hk�Ҩ^�tF7�1��j{�$��&b�{+�2�{�CEya��$9��gmJSb(g6"�=<�������k\+bjw �6yܼ��{��Z�:1M�ù|W(�����6�mDxX�&]+&�2�+;�t.�>A����ۡ�@c�A��>�[-mf��J��1o����̡�u+����x<XTL����<� e29���g�)e��5�1�u�y�ڝux<ؾ���ȑ�T�l�.��2L��DD
��c��2���H��<$1&'�#�X㵬y���;�b0���#�#VA��}$B�)3�X?�����M�*�g����h|���-��?��M�̴����]���"��\��E�3p����s����i#�[趰�"�����84���1�*]\f��5��q�h�9}φx<(�M�yR�Z�!�W�.�� �fw����˒Q]�"^���a���I�-s!��aj�f^n��$�!*��ŉ�Y�@(#�<�"79��\�����G�)��=��-5�Hh�q G���I�^-BD�_�}�6,���ҡ�t�"d��1-�k���5q:凨�ݚ��J�C�Q�_K��R��g�ꅉX��B��m�G�g��U]1$0���-�>.���λ�f��߸fF/B�J����ۗ?Nө���Rv�(��q #bz�cX��@��!&*����I��G�2܊ݹ[3>�U:�'F��x��A���    �֗u�DLqne=�ff���1��"�}�C��i������J��YE�kR�*)��I�CLT�Z��1!gQ�zp�j}���ax�cCe�E�Z�>�"b��$\C�ʗ_�yY�"��ao>ɨ^�װV�t�+�|֓
��~_�P7�k�g��v�����]u#�1�Kw��m�Y���C'6P�3c?(�w�Ȩ#�=*=;�G�;h�|������g�񝈍=c�vy�A0���
�Fֱ��&b�bC\X@r{���;ډ���a��av���4HŐn���ϲU-�/L��s
�}�"��N������n�n{
�1�v��cm-f����>s�)�̮�6S���?����ޝ�$�#��� �&p����FyMC����<���/�ʆJ�Ͻhc�a���eIy�Ge�u��,:�cŊ�m3�t�o"F�n�e�m��8��@�o�%ݯv1e]��&�CDT3��F[o���sCȰ�z�P�G����:lT�v=��Ճ<zY!R�ڷ��P����α��áw�26:�(�-v��Mp��-l���3-\�2�\�=ôy���FU�C��F��y7�,8�Dt�]n�&+��i�$Lx|����aN�(�6�Q�>��kC;\��%�}�2�M�Gg3��7:R�4�1����b��f��A�jVvb� �\�>��b&�M�x�6���MS��+~瘰i�j,�	�/Bm�m�U���/���1�B+�r��s���>W�����p��F�t���n�i�������ק���������_��{�k���i����ɴ[�')���Ԅ�qO��X�'�G@�I��%u�|zJ��e1}'%jS�&*c�� {��Ll�ّaD��~�g��^�T�Ҍ��|5g �N"6�/�[J�kT#b:�	o'��=��[�^�9�hO�����&�CB� �x�����٥t�f�6{�ᦕ��`�a��U�Z��o���cd�o�|{�J��t���j���R��E�������Evh<���&�?���8�lD����aH,�/ @��K�R���N��P����R<�����!�M�������R��e�:M]؈��DB��!6���,x^������sl��#��-�,"��W�k�5睍v��E��qv�"C.:�
7 ��Lf�4�]+���S���a��N8a�b�0��$L�8��1v+*�9��6��S,󶫈�ڻ	_B�s���fD4�w="���#�`w��DLW��"9��w�R��:�tb)T��m��J�H�TV�\�HX���2��6�m���f�1ѽ_	���z�o"��?��?�ί�E,��R3��ի+�e~u���z�Q�x�ȣ��Gw�����:���0�[v�4�T8�u��X�X�?F��:E9x���
��W��o5��YۜA(�y�4Ǵ�p�D��6g����1�U�ڊ�R���(�8��<�����Lo8�H��Ɔt��HF�t�K���:VQ[�8�1�;�킃 `t+b�,�C������-���{G%��9��o�aTM7�)��eW����`<h�&^�T��#�v���3�gX7Q�zm��h��������3��S���>'PPq��2 ��=�Ȫ����(E.l���������jƌ�Q��M�W��P���� C�V��q+��3��[�-p������`+��F�+����E�,�?�����Q/Xr�x����3%���~1�X�?�q�����u# �s5����;f���^7֊�e��>�0l�Q��(]�����!��.���ڎ�%��M�o��t�������.b��F�8r�4T|�a�E�Jz�����34�r&�P�(�b�aj��9֍0�	�8�/�!2:�!�,Q`��O!�R'b_�2�����Oh�~����x ]5)4(��)���R��e7��Ѧ�����M;�58��&Z1m\�U.��t���[Ix��V�g8�T��0f����Ue�g��-"���d��"����44m"z4j��m�P�����hC�P�+PІy�`M���_�T6b��_(^LԴ�]ƹ<6����n�່���{�xflP�z��f�0�U::�������I!V����l���0���*@yq���t�	W�.�gq��|R�5��1"��B�Pa�N͂W�F�9�'�VZ�)��� ��n��O��i�!���wx�������S�Z���lʔBM[�(�c����_��7r��!&�Ciy���!]���eEG��{�uܰ	��V�3L�8�0�Lh"��Q}#��\e5g3����μr,ǆt̠�L�#3�c����ӽ&�%RVy\���b���ᭈ)S�HW��NC�Ŧ������i|�7��yuM���eAV���i��4�+M�Kg1��A�i[��x��I*Lݹ'�0�I�H,��@��躔bV�D���g�Tx/�:�<hp����1&<v��abO��7F)Be�1�ח&��#��S-iE^�<��I"�i��c��\N�(���#��gE�"��`�E���1�z��C,��'�h�'�L@pv��c�;;�$�z$��E�������$-/���3�FJ�Q,/����D�y/r�3L�B��P1N�b�K2�<�x��`F䍘�����դ����FW'ƒUY*�ίtɈ�Z�����T�G������XJC�����V��I��ڜ1ܽ8G2l�m��|���!2�������!�=?-i�j,�B6���|!��aw������I�^��:.�O_~���{���w����؜��S:�<)�hT�-*�'/L�?I��j����:�(��	BG�ڪx�Ĵ�p,����]8��P�iwx<X��M���ܙ5�>�E��c:w,��pp|ht�B�v���J�Z�}W���PƜ�+fƩ�Ct�yb��ja1�1�7�4�2(�	G���,�X�Ea�@��a����b��hc����*����������;nH���|b��sE�i�)�A��g`"!b�����0�����9�f���t��EL��,�l���2�u�1��'�L�bA�D���~B�)>4D��:Yj�E�r��J�}�j���1x�\�4��\~��.�ݙ�VY]�ȅi|�%����S�1jFN����ݱ�O��Cp4JǪ�G�Ѩ$%���H=r���㦭��	���SK�`�_;��Q���躝�B���iK�c�mp�H	�´�!2�<�棓�kM&.�e�R����h`�!�{�� ��^.j*bv�E�q*��GD�n	OBإ����ϳ�u����b��ϭ�D�s#<6m�墷����W�Y?�%A���� �_��mY��X}�_������D��F�8R��#����������,$��%3Y���^���%��8p�_Y����+��9$s����/�+:Vt�O������Vf��hT:�������m�F)m���ލ�\`<���L�ĸH��5�nbj� )��T�!<��4�iq����
����I���$�ݡ�~�_�m
d7�z�1����J�	��tJ�X�������,�8��c&I�V�a�e�G����Ey�ͭOx,X�`m��V��m�� �qQ�B=&j">�%H���}{���Iް�԰3��k���e�ъ|�����HKox1��!bVH��t�^d���_��fO4vpfa�h�&6/�����~�����Q	kj�E��t;�����f��h�:�>:��h���h0��H(��w���l̇��j����Xb,�}B�i_�uEG9mr��m'1�c<���4�X�Vc 3i]�ڒ�F��x9���x��?L�e'+F�ߚ@��<p��=).&��f�,��W�G�O/0�1քk�Գ��.�ʘz�@+ѯk�ϖh�u�.�3'�B�Z���ZǨ�#�ȼ��>w3:��7�����	Cbo����C-��\�r��������B-������Z0�yC�ݍ2�LMuB׉��ᾌD��8]��䉩�,�N�k��Ĵs��H����[��#
,_���|�    \J>!4v�mtSSc�M�j��ȓB/�kt��x�M5_��c61�^�у(C�]3_1���}��`�T�<�<Ԅ9��'1�3P���э7ɽ�}��a���F I7+~&�p��� 6�3c|�,��i9}Q��PQ�x򠋉I�R��4��0O��Rk���ԭ�f�y�n]L4O4᱓Ek��=踙�:';� ��2D��y71�$�8������ĴoDx,()��@I1�諛LLlo��%�CDK@!<vؽõh�OC����+�#�� 1�oW��8fK̊��V)�@��5�$���1Fñ�?Hl�1�jb��R|���_�=�o���t�P\<��ߘL��|\���m�IȩCF^��ʤ���q��<01}fb�.�#�%��L���Y�.�^f���o ^u�S�|����9(��8GU�xZ�]_`����~���蛉i���R����^��}�$�{�H�r�P�^���������;d�c�SA)�77�&�B�~�.��.4k���`>�T����t�p����p��H�q�������� U��W�|�'F�7I<��3T{k?88h��t�I�oBv�<�|��@
ـ2��|4+q�{ȩܝ��0�� .0EN���NX�u�����k�<�D�d�<��:����s��S]$1+�y61-+�v5�����J����t��G�H����0��^���[,&�^�%�`��� lZ?Ou����C����qEO�4�D�o�Dhl��v1�I�kF�&�����M��9�h��V��h�oւi��I�������`���މ�=G�䦑,���w~�x��sI��n1#R�����`u�A��5�+��T{�XWN���⬬��d;t�,���.*�7������8-����j��c�o˕�$a $\�jG�6V�.��	��N�
����o�� �z��=	i�A:��Qsc+3�KLO�e\������?92'uK�qI���drU�.�O� ���D{����P1�'Cq�X�BaJ.Rw�<��y&&����ҝH���NIM8���#�(�GJ����G�#]f��jb����1+v<�o���q4�&&Xw��.FI�dz��etvK�G�mKwv3֞�uq�b����q���[����:8��#Vn&2�{�GE~�C"ɠ��5n-K��L��[s�)�����Bd��K�gSѰ��ǯI�w��F��Zm����Q]U��^�i51]���w�	U>2��Mh��y�-(E�nA'���@)���n�b��/��v� ���。����I�2Z�Mx���ꦉD�`Z�2��x�1"y�LO
������'�k\3��ߑ�:���&���ML|��#6m]D��;i�B��"��t����k-2`� v��FZML+K�<��7�u�a�bZ�,:�`F�H;�Y����e�i��S����S��4�&�{���e���D��@��=����-I��&&_?<l#�*�EE�~:D���."]�Ef�R\�1,��j0;��F��N���<�F�&x��8h��G��:��w5�O�N}��=��X��]�.	<���t��U����!Tf(��:��Bd��b���z��g�L�K��ŋ]�����"����O��Ѷ�����uh}@��u�.0��?���%���t6��hUa845�s���y\}�T���������P�1QCS�Gr3�i*��4Vk������������_���Ee30	�:�:���db<��ƥĂ���C���K�"Sy��hmp*e�����ޤ?z�������������v@��Θ�Nb�x̺��v�o`�u�1�q��)0O�8w@��F��8�_���Nv4npT��;GLo���*s�Ģ����v2�A4��v,�zK)0Q�c�K7^v�D90�q���ʸ>=��K����&�/�a'`2�����<��.t��S5f�Z�&ֵ�Ց�	������m$���gx:`�`f�r���S6د|�;&3/�ӈ�������t��p�0)0�_�`�.(��\r`aħ�����R<2��e$.[�}��ԁ��i�C�`�@�{���jj���f�:_�p3,S�=\L�FxD��a5s�+���S��)Eql;5�SFӧ�������/���Qtw:44��c&"3K�$�b͹n��1�)���I��ӶĴ�*Bd
$dy��ʅ9tX�:LUd����֨�Y��)��:S��p����v�Y�]><���x3܍�M9��h]4��*�{a��{����cК���he��Ǆ],m�%ļաV�˘���`e���d����&2'�����Z҃q�Y�>&R-A�Gt�L��×_���0�><m�4����\����w�wষ�ʣN&�m^�c�c�!��h��<>���+1^MQ��!q�W?���	�8OV�L��������K�\$���-J�F��k�:���]-1��C\��|��D3S:<��^�n���%`��!�Fdw�3�2O&�5,����egtU��5�J�8�uf�`b�JwM��.2�EBh0�b�:`��έ%�Ѝdtx����\�DH��P��cT��ĺ�W�]��	{L�zB�?�v�XS�1&��2����U�����$.�����g>%6-D�}oM���>��c�P��N�U���.�9�^�&��2>��|D����8��H��h(�%渏��42��}0;2͊��\4�����Ēj��fC����ԙ+�
:�%F_MLM;�<b���7�N�M���{�.��k�=Zl��2C� ���D�/B9��P�q�WZ[F��4� �����UƤg�A����/�閽[`�g��OВELv��8��"_��0�w䫟'*!G�[��伟�������<g1���GR`y����z�P�zp򲥣K˖��c�骕��4���8dS����{`���j11��I�l�9a����Gi�9ڥb/���Qg�!n�}�+��nbb!�+m�^r-��� Q|���QG�OLt��oC�8zA&�������̢�;�����ңB�z�5y����<�K7����Ծ�`�e���mR��/̕`��!)�t=������Gb���JLu�H���]���{LԼ]�îqr�Pj��l�c$.�F�񈩟%�cś097�o�ր�g�U�'\A�8�];|ԕ�(���������PYKT`�x ��`~`����b<gt��2�!�q��|[��~�Q�������$��"$�]a*K_͋M��XQ��fLʋ%�T�hGvhhv$�1�B���h�9Uc�c���� �}�k��c&*{���gZ˨h��jr�D�H�:2���1쎴��{	�&F��*����҉��!���	�y'Mo�j��*���(0e�~�rrp�VF9��K�+�1_�/�#	�t�x
~��(��*�+�n�%��qfL�g��	,0��n�4��@.&Z�#r����%��BĞ˷�F�`84#�5p]!�1y)c*!��w��n�%f�zy�,8D�u{�4���f!Z�6j���i��&��~��ĉ�:'����ylĻҴ.	IǧV�˘G͚��Βk���ĳ�����3�"3�R.p�.�i��<l�n�rb��n�9;���GF>��o�����M�sґ�J�kt��c�`xĂ�G_�����������l7S�z�N#|�&��ie=�G�Tc�B�V�P`b`,��?Qc���� <V9�oyF�@Љ�2С��*f�]&&f�àG�<��'�Z��&1W`�ͳ��ψM�j��^��[bl|��G=�}��kE�\�k5��qQ%}���$FY7r��_M��{�E_Ih{�T�0��=f�'�0Y�����ثᗟ�yk@xр�F��N#�M�y�Q!m��PXML�*㎽Ã]j�l�m�$"�7�f!i��&�u��
F�M�\�wh��}�I���I���dofW�	7�e|��L�u�ь@�""�u��h���D�sz��Yt��=�4����"h�!��݂[��,Й��Qo~�H��xx[�kd�=���n��/    �F��4.��/S�
�����i�0z�Յ��Q#R��i\ËF�H�0fz�,�Ġ3�t�ևm��h�n*B%�fym��5Ɩ��xƏ:�����/��q�	�u�17�v��X ��X� 2��6%,���標���
��~�\23����6�R����B�C*���x�P�#I۲�ZU���_�Fg���hiH�;l����`
1]�7����K3�����*��a�%�2�Fi>WH�����H�߄�H�AP:��h;<bw�G��.�P�':�duC�&L����V'��P�+�m�ם�{<�f}������o����y�h�$Ƿ�4&S�[����S$gܓDp���!gX�(�Z����a��X�!.רMt�:��@:c��i,{��qȖ�v|�qS�6��:Ŗ��SU{`us�"%w���6V�#���-*h̓�ɉ/�`2��_�ak\���Ld^Uݺ��<��L��F�I�"	(t�h�c �Ъ�Iv�ϵr݉�*��n��q�ت�{����@K�)�����ث7���Bx�Ă_j&I�q�Ḻca��
Mxy�B"I{��q��[�@�9���b�b�~{Ɯ���d���p���G�����o�N�*�4lg����,��gĨ՜�L�ZM�P:Ϥ�Q��5��V�Mx,��ISh��k��*1Zs=�}�����=L���1��a.=�%�MĀ;�G
b�%�z�;T�x��M���]Ji���-������ׯ?�|�q����j��|����՛莩F�"E&�QD^���������Pw
91�~m��6@P�b71q"#�vh�zK<��`b�C�h؋�0���F�1r�0��w�Xq���R鷵S`J�iq��B�]�-Uk���F#ymO3�9ChٺHH�>խ�ĝ�#�θsi2j*[����Z����M����;l���ug}��V��$�~!}��Ds��2�]`=Ջg	6�WOШDDF�*�	��,�Z�(g��sK�{�B�v��ѷ3"��XRb����:51&)q�3V|��<ե���3���i�.���J<��-���6M�[��r��o�9���٠� �L̛r�'j�O�ef���@?�1��{�f�if��Բ~wc��ѣ�T@���^�L�1��\4h�@c�c9$j�t�~���r�5��*���i�w�sa�����<�A�W�UK)�^b��+��V���Bcĕ�M�HtA��Rb$%2&�B�(Zh��Ĥ�$�1N�祝�["�aɌ�"���&x��F��K����<D���$=�x��|낗2��ʲ�k&�������O_����kNR���	���ShT��v����7,D#��X/��j�ɤ���B��yj�aY��r�0X��)0�����KT�{��Q2��G�lXz�j���M�������閨H��:D��jr�$��^��=��-��p����Y��7C��m&��db%�Ǣ�9�����spO��Ey���Ho����qt9��旟�������g:�����{}G�xO0b@���/���&�d51~�<95~��OS01%�By���X�Y!�qG,���H� �T��ʘPF¢s�ps�М�G�V��S�6�d�+&J@�t��<��B�V��`��T��'�f�h�ܭ�9�m�)�J<��ԄU�@v��ZbbyȀ��#P �l&&�I���"����Uq�h�`���8�܌��� �J���[D��<�$z��M.͘V;yۮ�j�O�����`b�WS�.0*)�I�XhLì�Ve̡'ł���T���'�h�n���8���\s+p��%��5R]�1ͭ�y�����3��"[&���E�4V�ʌ��*�.�C5�٥�����]M����Um�NL��g!@�fm�`b�B�֬��o�*���o�[���ڢ=rt�Q���n��+�S��J���~}��X�V|�t21����d�q��ܲJ��2�}a#%�e|>���2&TFR�\w��!��g��j';`��Np�����PRx&N��]mL�n���;�9\p"m5+�Q�YFsuBc�|7t���7#s��f��Y�G�1��ZqLz~mЮu1ў��]<�,���q������oίS���YT�?��b��ab��gQB���.Ke"�,���fbZ\��1w������l����U���)L�r]LL�T:b5(C�c���a��p]�R��Ǒ�V�D�$ս���>�%q�i�O�5���>�n��[J�=;�}]���O�K�x��H e-�"��r9�4�]%�#?WD��P���ML��v��gy>�F�J_�r~��p�`LL�mf<�4���7#.Z�����ZT��`)��|O:�����4�1�j.��3�L�*05%���{��|콧�/�Ҥ��)��x_�&�M{ϴ�S�F�' ������y=d�p���`���&f짻�8�+S��7��3UT^�b��=��Zt�X���T*�d"��^��NXHg�f��mW�햃���v�,�	�a�������״Ĥ�e41֯�K0�7���<lBA�M`��d�g�H&K����(����(�qR{�Ǜe��1k*N6�q;�
L�qM�1L��i�3��yn��C�CLt��a���coj��d��^.0ѫP|9Q��|�AG�<�Ʊ���x�JL]�+n�3���r���|����Bm �fB-�a�zg�,h<p
^�BnF�Ǜ.�����	oF찧�x-wO�u<��4,#Y��A�+Pb�+���'�C;~����e��z� ����q�p+�e"`��&I����0�M��\�q�m{��`��a��=&�G�\P�6r�\L�j��)7lf�ab\+�},���=a5�5��p@��_�l|ҷq3ƿ��(1��l��P����k�"U�����Pn���w�J�t��^��Q
����<:G��M&vM&�S�V��eԠĄ���l�Cɜ/!�|=���,`��{t2����J�Q�z��e��=_.6���ĄɊ��.8��TB{.e욬�}��]��Ua�wi3�X�]�����z�����!O�a�,�ƿE�쯏��[1���?�LbvUq�ZseW1BjL{H��c01�
�o�`����yu<�#P�#c��by�������EɃ����r�~P����_���������8��j���J���h*|�1k��$�=�&&k�a*�x��ܳ�A��W!1�23��5�x�pQ
'�O��J�a��I%�I���ϴ�\D����~����F���b�O���������*y�7{�,'�䟰�����x=O��9�ԒuS�QoXc��S�5WbJ&�kzPds�pз��<Â&�<"3�]��+��sָ�>�5��y֛���ϝ&��O����o1������_n����cUI�ɢy������Dɧ�=~�lk������8̥�!՞���n.�+c���)1��9�Z��k��Ĵ
k�cH&ֽ�wH3��:2�ڀk9E.���Ǥ벺��GI�o���+Z�#���®���NkMIH���[��{��=���-��`�+�h;mw27�hS����2Bl���nP���5��i-t����Zjj�y�[��U�f���\����z��6�.Ļ�\�[=`�y\E�O��*7���V�W`��?�~���ߌ�.3s��@���M��a^��� ����ˌ��H�ML�Fȼ���6�5�bb�#F�5a)�f[?��~Kb(0Җ��	8�h~�����bVQD���EP
���!��JC��4WH��Tf豺�B�������:�!tj��pO汧�̭+1+���d� �|�aR~�4�ʯ���X�F�L��Q���T�-0�[٠�y8.-�ǡ^�A������!�{cr�}7�ױ�w��k������؁T��������B���Nh�p�ͪI�e�*>1a��������V�m�ab<�>
����oho>��y������}���/����o���ǧ/?���/�)��ߟ��ӿ~΋������3̖��S`��*��cK�TFO-��dc��|�    ��Xă������H���3XDyc��ʝc&S��J�fy d/���#��< �š��|��!�����a�n�w����t/2,1a]r.$�&�|��ԥ+1�E�c���{s����,J�K��`jx���8���%�H��ә�hU06�+0r@��t�������:�ZsK���b�x���2�UN'��)�u-����E���7^�3�}B��<��&�S�lb�&�+��FjO�8���Ԟ<|gt���9ZuM���P�Ri�d���7c���x�-�H�_#�E����Qv�=f����ڀ��^�gP�����qv��6�1����4�>WO�i���sJ� A�H)L��1�:l��h��G*��M��2	��FZ�7�s�!�a��Z&�b�@C�B�߇�ĺ!�_^���p*�j�Y��j�0��#@���Km>�c�P�P/L���\��f}��@�vk�R`�ֽZ�º�����х!$RH·�����;lǶs'繹{a.L�z�g����j�BI@�&�P`������� �f#W�=��4^�}�M?0~��	I��&�/i�
�?�Q�/������:Շ쮰C\�dk� ��t���·hTnr~Jb�,����H~
�A�js�3�d�����k��>�=f����1Xy�pQ'<W����l�<z8���p��gt9RX�4���*M̯�Dn�=zZ"�q��T<�s6>6{m�|���nb��t5-&�'=�{���2�u3�����z��ﯠ�2��撔����z�f��긶��׋$��������}>�|�U���eNU��G1֯��s��)W`J@�����,�-e�&�-�x9�=����i�jg??HȱY�sj�5�/���A#k�6���!U`N�O\D;�9�lb��M��©fi̱
�([(�����r��%�$����s��Y`*[T�C��ͬ,)�p4�N9�Ud�������F&啎7�ܭ��í�%k���q�����y�U�8nڛ:�����X�u!�;[�&V��&��`b1'���=���a\���9}�R�Jk�O�y�ڣ[�"�vR�0�.{c�nq�M�����ܕ�o4�ѝ1r�R�h�\Q
������.'V�Z�ّ|7c�q�����/z��#}�!��p���bb�%q�/F��F�7-�0���j��e\��VE	��$�4�y|s�ǥ|p;˵��S�OXM̥����56b�Э��X�Ł;�����w��b��46<^kn�#�*�ML.���$�]D�>�*𜫯̔�z+o+��bp��%b��Rh�K�����(�'�CA��V;Аw)��>sI����=h��^m����cO�Nd��gL�(��J�<cz��&�kt���O����Ww
�4�2�xb�\!܊�4|l
)IضC���EF��ʮ��L��:�0O~	�#�\#o&�F~Ig�4�
%��o��ܐ� ��ŉ����/�b�9���f�G��#� ��P�
/��Rl����3g6�{� ��~0-)�x�,�S�]8��H�&�9����}���X�=&��݋�4hOm��y��5��*a#�m ����ш�����8�-BS`�Xo�5�n\���]KT�hDVi���
S�Q�[>K����jW�hH��;$�&>��VmN�#t�g�����	����#D�F�"W��,��H01O�+�� 6���X
U-�9�rK�*05Ϲ(m�^�6_(ajcF������M����91�b��/��R����R�Bc��;&�{j{����d�+X#�d@�d0���Ad��@
�������HA=L�0%T��M�XR�P_z'�ʪ��Î}�F�$R8�L��Nn:��^屛,�"�*�F�ML�U�x0��`O�FƚI�hq�B	��<�ab�{��Hߦ�BKI,Յvb�L�e��"D��t&$"LYɢ���S��4/fw��`L4#��C�E��{36�!f�ONj��a��B�!��U��#��z�䯂�Ei*�c"5�g<v����:�L�-0��k�(�c�Qg��1��R�0X/�������-����3yl���������_��:��g�����L�<�|D���ajT�x����)�;��F��,�P�l���Y]�Mp�7a�y��ؒ���AS`�q�U��8�F]LL[X}�
�Y�I*0޴7������k�� ����"8���⮑��w��ܼM�J������r��Z<�B���l����#
 �wݱ6F��e��O�JO�0�<�gSI]�=49����pw�g�	˪���^V����F�����x�'Oq�;!.�H����If2��M������6��n#���.ǐ��bj�bb����F�}D$�'�����!o�[�i��
�PP{n��%6(�?���T����Ђ<M>&R����~	o��e���baO=9)T��2)��'�A&̊�վ�+:����V\�9�TRId��Zb�]x�S�)���mֹ��9y�D�Yf��~gk����{NEo��[Q�Rbji��4>%��5�lbZv�1��\>TLb3��={��޸�qQ^fרE]i�i/3�Cy��x�iUbb󀢣�Z�����M���x��٣e�/�y����k�"�PbZ�z�����#"e�Q���t�ZZo�ON�АL�k���4����tXK�&[bx:��d��$}�LG¤ )�AB���5TD)K�T�b)�4�>xtm:<l��M=�U!5by�{)ғ�\m�W��P ��E�?�u*�'z�J�����x7���~6�IZ�᥷ygp�mޣa~�wi�j�Q��Xm����N���x${T�d��Q�X�]��m�P�<R���D]��=�e&D��<܈1P�tz�ky:��N�Z*�V��.1�H���VRƤW ��lU����B�}7�).ʹHA�)�x��[P݅k�Y�K�(�^��ك�1��d#\SmB�8�2��!�����q�T��Z�Vݍմ<;�n&�����dy\s#r˂�/Y��EE��j��Y*Q��߿���_Cs�r�|��%C;_�p{�S�zi|iowF�̌��
-�e.�ԗ�A��d|���]�tuxD�l��ؗ9���N2�M4�<��K�P�����m�m�g�κ��H�����B�T����x3&-T�߅]��o��m�Jƒ���p�|p�ǆ+�\KH	qk���q.B�ͨҐ��N�B�>�������#�1�!"�܍�r��Ao�KL�-w�H������P�J��ne�o�9�JT��(I��!9݈P���=-���)09YT�%*�ʃ6o���hbP֦L�rdO�ċ����dN�C
vx��9�k�nO�M3��Z�K) q�:��V��yn[�]�[����Y����{��񁈞kt��c�c�7����/0�|�`bb��p�y�\�R��J�� >��8�����!#�2u�h�L���^�1yT���LB����p+�ń�{
�Enδ�j�ZbZ/�)+�CD�
a4����`���^���F������i���n��7I�yЭ,�,1����A��A���p��� ��_VXU��]�e ���Su����8�<��\��8�R�%�f�\��E|�Q&Z��$��7��u�L���3 �x�,�)T��yCW2	��1	�h��P��{<�):9�>iBRc*�L��t��##���Qm��x+�NK�!t:�hǨ)���HQfƃ����Ǩ�c�w��u���(�F�FQľ6����9��S}E���hb��J���2�G��V~�	�/oFў���fO�rѳW�g�e51={\"�O�Ť��Jyb��X��nr���I�y��T�w��/�}L��!�n�HjK�ĺ�zhW/8�7R��z�JHՂ"��鑪+��U�r�TEb\t9O���.m!u�_MLk|��1��xH�B���m��#�V��R;~���w�1ў�Ǆ;�����rkMQbz�`���Zl"�!���
I%f	$w�'��-4��ɁA>b
�)�N	��n��I�zZLL��#^'    ��b"yj�����j�Y�{71�Sۡ�zj�Sۛۭ��Q���X���	;�����Dwm 	q�)�X�c�9MBi��.�+8�\���R#�����������#ӮA��^���{��`�����Ǟ��'�����̨A��H?� Ea�t؏1Up � ��Ɖ������d�J��2P�GEt�p"��wq���ӭ�a׈D���^�̍�D���?�/���]7�t��h�f�/��]a11�paq�Yml���l01ծ�JV��jW2&�]�y,����q$1�\ax��ސ��u_�/+t�7�#�|dL.b�T�$��\M>���n���\^�n�����`����1-��� =@]<|'�Dl��"���P�)Y����8�Y���Jt�:�&����#�u�h�D�1ܚ�ܔZ*5K� j�V=j��%dL��5�c&���w���[��Z���+��T�ϰ������x�W�|�=��~��+�EMGgL�tt�#�F�ة�5ڍ�i���QD䠏O��@ɡ��G{dCw�.Kkd6KUWpa�6D,�@������V��Ɍ�\���
qi���$o��ƥV�P �:���4���z 5wA�*ӥ)0K[���؀��\�K^uBc�B���T��c�P3ީt��F�6���@J����A��:s��wx�S�uUm�3!m�b��<L�H��]�5q2����8ɩ������ n����d�-��r������ZIٔ� ���J�C��`a���}���{}81��q�k+�&��iO$ƃ�o�5O�:b��2c�v��[�h�<�]��\M�����2��0�0�q���ՌM^��GE\q"j���H��N
\1n\=��[��u}q)����w�G��J"�EbWM"l*�Xj����NM�f<`�0���2�95	���?���Z��]��,�ܔˀ;
5*g�/[�����^�nO�JjH��މ95GV�|W�������bkȹ�(v�Hh!�V��Z����6MM9��9jmLdL˻d<�]�1'2�wN�X��2ю;�#/��@Y��s��mrڣQ��=�JLS��1rt���(��=���5d}e��od�	'"�ފ"���`bL����;}21M���Ì��ˣ+I��4J�}���/粪���J�I�K�0�wJ�:�����~��	#%L����v�����D�.�j�b>_�$sb�����E�#"U\3��m2�!�c��,iG�F��,8�������˹���<��ԨM �=F<*�ꅱ�5�"��"�1!Y��� -��x>YL�Q�6c��ʴ��ȯBL��cq|l�8�y����d��ו|��pNMz>�����=:`݌��8ė������TR��LQ��($��q01a���cM���X?QW~11���r�`)����n&<��B�\���c�4L��d���嫛�_H�~�ؓ��`b4�e&�XZ�^�����\D��G/2+��7r5�#�ͪ<����G�6x��ȁ{NE��aG{?pϹ���A�?���Eg���Ǘo'��~�������'�-��׊E��^��j��0d�1�����h61驁i,j���T�UH2&]?�]�ܢH�>&$k�f�19+�����.RE���m����B����m$eMrn�s��O0tW��c�qV_�đ�X�y�FZw>�)�܂"����`bZ
	�a��\4�0��w�k%3C�a��<j���5��@f<V����^�x]���z�H̽3� �f�$L4��ağ棍�dLΠ9�	�C���|��o�4�HԿWk��몡�1GytE>���H�{���9�}Go�+�0ߘXϲ5ꁷ0n5�b��z��m��x8m���9J���z.�*݉�p�H4�\L�B�;��b��}3�;K��tQ��T,ͩWQ�xFZ���Q��CD2(	�c�Gp㖌^��U@tǄ#�(���bg6�T�����b&�2�?ْ*X&]cTu���3�4�q�4���p]����57b���Q�$���db�)�KI���g���
���O����,��@�b��.�T�����Q�nn����~�_�h��e$
��1:�[�s�ǁ.(k�5��#��jP1.�I��^=X(���C)��4H:�����˵��XJW���C&��$_#�K+W�טG[�,c�����۷JK���O�w���m�А���ǈEz�\�<�rk?\`$Ᏼ�]`oV4z�W2&e"uxH�;<�s�ð�P��F�*؏wx015a*c����+�4���]L�c�0�g*D��e61�'��
��L�5���i615Ӝ��ά��bbZ�%�A|�K�d-��^�Xtu,��L�X`R9˨ ��Z��G�V�	{}�fS|�ML˰$���I9LL	{2���D��eM$c9�Qp_<9��Q���y��󼚘Z�<b�ٳC�����D+J�<,�F8�ã���n��^;c�{7�ӵ��|�<$U{�� ���~��HdC��]1ԛ7c���YŸ�9�d�G/�H��\<|��I�vy��#2[`L����˘`0�b~#~g��x>:b�y�*�@�Ծ*�3s51�_�i&�h���-��G�L���8y
�%B}
�w�b��u�7O�!>k�������>�xj���O����wǤ�_�O�	?�Gtc�oi��+,�b�F�2:ldUa�CR��xOU�>t�h��	qU7���>r��� mm���y�6���Y.3���Kzq�m��{��0��%�CDR	$4f�o�`�J���3#�T��	Ldd����AF��RX�h���+0q�L�i
�!"��Ik�ИpI|�Q�a�m�H������|����c�������<��������&I���]�k˄kfӼB��a01�]>Q.b�e����o#w�M�N���S��E0։w1Ѽ��	n��)JXW�׉�t��W��h�G|b�<�&^W��i�I�����o�R86��t�� �14�qԹ
I_��C1����S�����M�0U�f�̩��lb�N��J��R.&�N�<$A��x9b�Չg%���-��3*h��H)��Db�6�ʁb����:����y �k��y�R���F��G4�*�q{>F\_��;�(�eS� �`brx�Q�����[�@pb��2�r�Fn�s���4����hVlºU�|��2i�({���}��u` �P��Ӿ��H>��3?-��؇�O����L1?�tǌ3�
O�+M�L�>�ǜ��j�X'� +/Lvqp��`*�j�>�:e��:�?3��Y�*���|�3*r#�<�Q%^i�W�fy���J��6c4�V1��f��N��b�i��=V�w1ќG���,I5�a�05@¹�	j�� !<fb	Y_縵r*0u���"�1\L�u�x`����Q����dYDFEu?3"�,"���0����/�Mi���,"�Z`�}O%�/5�;Ƶ a��f�ō��c�S��&`�r�w
[{Y��J�5���p�K����@�q�r>�ۗ��ܾ�q��M����y�8&�����|lTmM�C��`<��Y�#u.6��=�'�J�ê���u�S�8ˡ���׆ �Aj���U둱��]��V�tV$6�����;N������ �=z�lsb�-�yH]�:<>�Պ�#�[�C'j{�K'c̔���G/];z;� ���;G���������}�Y>��[��B��kx��eDd������1�7>�nA-{�&̘fA1��f�*K��71�F�uW#5H����Ԅi��RIr�a519t�%����GE��DV,P��c�v���	ƭ�#5ʘhP�C��2����j��i똎j�u���am��+M"&������ gT�b�k���+Z`�A}9ix�A�����Ѹ��K��L/0�Q���>��軉i�N�c�;�m�m��$�L�r.j��1�B��ې9ir;��Db615�t���+�-˔�Xp2I�N�.��D�8��:��)ޙ�z�כ@bs�v�%��ډ�1-�}e�N�D�iq�    L���"�,�!f��-),��Zưr�Q� ���ϙ\ML��d<��z���8�b�{2��Nؗ��F����?�����ן��o?�'����v�b�q�V=�O8���ĄV=E��,���:��V�Q��x�o�M�|��H>�A�)�u�v�R-c�����^D�F�|!��h�w[��?H�z���F��cf��!͝�y��L��?Iڈ�N��L���9�NZ؆�����e�W/��cW�q�̡=�3���2]oî��]<��AH%�U�nwNN!�*�������8�Xr���f �јK��,�fQ�m$b���I÷�Eb A�E���}q!��#�R7Vv���o�9L�R_F6TK~|#\���񴿌�;&;�Wl'�v5����ADBz'�I�ѿ�Q���S��v|����1ў��,h��{�2�މ�~z�E��3&���ț���[�d��j`)��M(�(cR7���'�;Q�}�ou�?b��үѫ4ԂQ'�+\���������y+O�[�5��y��/?��ן���?b[�a�����K��HJ�r�]��ʉ��ԃ�^��F&��8��	���PF�w��8G\+U��XJ�7�WS��HU�։i)I��&7�M�t�F������+# 5���ZML�wf"v#���>�E�-��>��o�፻nr�:�+F=�39o&���܉�3�\t�t#Nf."o�URf���3���ֱ�W�q��$l=&F���*m��|���<.��#�:pw������bRJ ��TNt�P}q���ې~K���<�s��}'���=�TY��*='�����ѥ��Ad��}��f�AX#�&� &��I� �G^��?еTߺ��6^�+QhO���T%�\���X�;RQoFD�	(���8�c�������$�����F�$z����&�z�;T@��Eŷ�/n�A?r5���g����-��<R��|]w���|�Fz���E{�?�l�[���SrDԼyVE������+?`ݴ8��2^�tt�G�"e��
I$E\�R����j(Bnٱ����ϩ�*.�TCŌ�l��X0�hbR� �qT~�b&����"T}�.�xy��<ߊ-�%t�nl��2�b���7�YP.R�K���q|<����������H��S����:��{\l�2)����f7\�h!H�8:J����`��ҝNLX�z�<�����ւ�+!��S2J5��=��a�t�L��h���GC���3&?���F���4O���ܜ��#̬8�B���fSqb��s��jX��(�؂�T��{�X+�c_�r����!�C)P"+��6擆����
�<�����w]<�%��m��Ae�Srf��h0���Cx��Cx�q1�;���L)���\�L�稻�I�R��9���Co-�k�1Q.�����Lf{ǚ:G$-�v\�1���l��6Q&n\�\�%�k�ouRo��i�5�[3r���͈��Iك1�bbf�?�3�<�:���D��~���r������HF:�;T��H䱖���Zm��XoBz&���t ~��I�W��zQ��yC��Ή���LLl�`�ĥ���3�%���=5�;���:u�-��뭥��#MP#�ܼ�=LL37)\RQ��ۭ�W���Q.�w�u31ɻ�x�DP�`�I��)��9�H��-��x܌��wm5DGb<�MLLD�!Sb1�vVb�h�}2�� �������a��bpV������tXؖ�Y�ʨ<�i�y�u�+0��5�Q���,�(0��������*$��x�5���;�n�U�b���0��&���dbj.n���7c���rRn��T9�1�B��jb�1˹��lu31�e<d��4��B��k�=A�~�16ځ�x��r�Z꥜1�k�c"�]��ʈ�ǔl�Ch8�HS��i��qb/�8MqXQON^?#��rq�K���;d���>1�q:�����3�V��y�����3�I̶��ݯE[�ǯV��
L��>fE�#)�z�����Gh�`ٝ=��Dc�T � ����fی���`���k#�-,ϑ���� ���l��&�A�y¥.}�\ķv��go�q3���2�K�͋g��T�>1R`�{4�ᥴ�k��Ĥ#H#��vS&��ln����zpɍO�ӭ�:����N=1�E �ϥ���Ӿi����Y�
S!Yd��z���ӗ�T�݉�:���c�~��_Jg���ǁ��N���b�6l7u�36��%ٿ���~��`b�{���X���FH Ff�^�w�￿��pLr�T������+��q*�����#ɜ����f�c"8m2��ol���؊\������l�P�t�T�xǸi���+'&��E�W�4�X��a��!�t����������-��f2��r��8A�H��:�?A.a��y'Y�:;��hv��R�3T0�\�Z�m'�t;k�NZ���xb�d^jĮH~�ML���P1e�|T��%�s$ͬu0�Ilw01G;87��Tj�:c����1&����֐�%���`2�:�ubb"L4}N0mN8�Y��{VHLp�l녞c,vZML�L+|��u"�Lt�nqFeSUv���h� ��I[�0��#��0"��E�mL�.�
׭(w�]��a<H���2��:���T�L�b8q/1��(,��;�������ɧ�5�''Ӱ��BX����lU�����5�z�D���\�',��"�刃�mnE�?8c}+g�(&X�]�0�<���?(��N$��ds��5���W¦�p\L���#�� �f41��B�F3�i�����p�fĮ���
n��Sc����n�BԙQFp�L����\ln�y���䁼�<d�6Z�3������n61�&�R3|{����8�i�Ҝ�ktw��<L�N�ƍ��Wo6�v�0D#�	⤸�4�o;�ף��G
&���OE����Stb����Q=E���)"D����Sm������w��ë��<�jbRt�Ӑ�?;4޸O�b2�ך��L⃵�B�;'b��(��!"}-F��I��q71�g�R=3���aDp:t����
�NL����|Ԍ,�F��"<�3ANq�ze�~��R\q{�8�>xtm��4_7��4�[8c�J��ź���>�]ddo/�"K8�C]�pb�/�s�$:L4GZgN�h߭x�}I��H51���)�/PL�ED�J��;���h�<ԧlƔ���ny��ccCF��&Tf�C|&���!H�5�\�4m�y+M{ơ�6h�E�驶Q2��P�Y��u�h��CK�f,>���` kM���s�"a�L�=�����;��8"�h�Vύ�`�=K=;S���b!1�U	��S�1��ӰM0R�O��J�Σ����?c�qbb>,���F4&�C�!]ۛՒ����/��B-���&&�X�� �֚��C8�/�Č���aP�X9����Tb�@��{7�R���u�W�;,�� ���7-�O,vCe�wj)`��nb�8�����e����;�^Iw��?�Q{+���AS,Wh���H^?F��p����<�)�錯�����{�� �}�y���V5�'���q���E=Y�[��NV�c�ޛ��[��7��9�Z~snȁ�##?9�_��u2�M�<�N�/�E�B�T�7��_��S�k�P솧MA�5�ab�9���/xK�u�n�;��c01�Ӏm��D���>$}�i31�-�}��s� >A)�	ʨ��vVā�*���T�	n���n�稫�in�C�d���f'KF�H�թ'��ݧsaj-�"&�<G=LLK�a<HG���G=^�wL�~r.b��s��Ĵ�5�c%��9*�S�8�J�9�dbZ�&�A4�j�%�:7{�y"_�~��=7tx�sÈ`�M����ˇz�d{n���������D�̮�.Ÿ�� �z�fL�dí�וf��8j��0��{��f������^��ٞE�-���ڕ�M��)�����R���fWkm `MU[�6�����ʶ�&��Op~P�^�����1a���a�i��fv�    �n�{|�Z1.2Z�!%B�5{�.�J�K���0Vh���H�rF�Xku�Pt�<��iq.b�e��,)2l���|�:���mb+��AʩX1����H�ƬO"���HՐu�l�X=p���EY`&�ˢ�C�����^��\v��5��Ŵ�4�
�����V�a`b7!����`_6��F�1�dV��8��ٓQ���#��9�bbJ`�Gc<�U;�M�ch'k'�NNo'�3n{ey)�cu���ʓqb���4�>���C���*�]d�:~q�SJ�]��{�����%�[�*+{5�X9{ef�z�XX��X�$81na=�0|�ﺅ��V���a��Tz��U^A/��]�B���Z|\y���@�蚣������C����)��о��X�[EEN��8��4' �>��LL|�w�؟�M"��#��HM����8f�|��c��&�|��Kn~ʃ(�4��Ǩ{�pab�,}&�E�1&R���ptIM�z�����G�.F�H1��qx�O�pyD��C�Ag;-�£�����)uy�I�������%Trv&�s�p�H�\�O�H�ʃ���)iq����)�௎���� ��>�3&%���E+[�<�K�Ģ�{�2�"������������W3d�B�٣��=���Uv�j��b��rg�1�zU���@��{�$�Z���X���^74�KV����9���ĘZT�y�o$��n`���M�V�P`ZPf ��M6�R��������R��%�|M$c�[���	*~��[�&FgC�NW���{�"��#y�cKo����@H�f�ס��@���Zux�����`�iV����VC/cz�v�����!�&n�f�
tQq�Y��z_._T���5�M~ark�jʘ�Zİ�XO�Rق����w�Џy�MLK䃹Z��B<Q�6�|Kn�c�p9с=F���H��}�^X7>r���ֿL,tq��v8�Ur�y����`����6�N��ma�q�@�DS�*��c]s��\7|��v�~�dj�ƌ�>�����������l���7Q�s��d��Vzn�5BrBL���l�5*(�Y� m��72���d�5��-�kh���y�LL��e_kk�q�u�8\y>`�����U������D��hI��M���f@IS�Ѷ��Ҩ:<�4��wҨ�d,��I-��xe���{3��ro�T`����z���H�����jb�;��cl��pW��9�RwG�%�4l��pWQ"VMw�u'.������x�zn�3�%>�6�KP�g"cZ6!�$�iQ�o�_����?@ɡ��cV ��	�OU����XU���su$\j�{|�o�gH����hhCI�ku���L��E�	��Pp|�s�5�O�E!@Н3�>�e|-�;��6{{<�4-��a6����Z�ʞ��p1y?כE��o�s1�t�	
�ڄ�T2D�e����>~01֏`��?�mq���bs��3�_~�.m߷?�����߿���_���{c��J�G�.�����K�.��55���*>�W�X����]��C��Ѝ5ohJ��c��d�;.�n��̼���^�i�}��*:$�,�A)���-����u��FB�̳Cl1pTOG�$�1N#���R�b��,�� �Z�9�b���f襥�~uQ-�3���yl�L�6�-̩�c9��IU���i9Ք|O��y31͂�g�6�~�m+��U��s$��Z䣆�-��yh�5c�֭���9E��P��1��$c�;�EB�59�3���{��Ā]�%�[�q"0�v�t/_�{�z���P���Mׅ�W���(h:P|*�݃���o���5�Qkb�*�����׽3�{gDK�dD��b����Qj�����8><W��k�`bZr�����ٗ�gt�_�5���i�Q:nQ���.���{_-kH�r�����VMT`�﯀.>V�bq1�u)�����̣N���1UL�ssa)ML�����MZeu�M̡��馔��̨�D���^�o�o���E�2&�o����'���9�O�����^�0�=�w�kt�$�<:|��	v̩5�ab,�s%�N8�����.�J��4NM2tp�:�%&v}���?�f�X�C�q�D��m�	��}`Bt䣺�͍�x����4�l0��X�$��k�����IF�h�5��s
�������$���&��iE�Zcp��5^\f�F�nS���`c���
�{r�:�.&Z)�H�d�0M��s}1f�:�g�@�Bq/���	���zN��6��*mmg�b[�k�� ˘f�sGHfs$�^X�6��e^³"-�ˈ��
CL�Eq;+#e�<6)	3��\P8f�h���"a�S��Kv�\�-
\\ޱ��9��i/�p�s�"��W2b9�6ƺ�WAu������Kv#5���H_Bc�eb���&q���4su!}وA��VGH"H�415e�f$�(#�Eŗ�(0{|.l���K���H�5�'��	��R�9��	�.�w�>1O@v��4����#O&�d9�֒�x���y�3r��q�=�n���ĴfO��{������t�r�v�x[�s�籽��8��[ҝ����A�e���<.�?� �Hv��Ţ�x}�e�Q��^A0� �YLLv�*�ּפ`L�>MqO�H@}���ŧ)'R1\D|���칫	���X���9�u��I�7�}���eH0"��-�	�U�F^���a��dL�s�_f|/d�#6�M>�bX��:�ux����D���`��Aj4�D��6%0�F�ML���<�Ra��RaJ��[w���e41�:I�2P�����~�f�Ǯ*��Q�:tb,ug�'}�j��ѵ��c��̦��)�=1���
i|����=��7���5����<��fgl�J���OLx���3�]L���Q�zɯ���ɑ�q�G��yxb,Ʊaw�{��c�i1�C��<ޗ���@�����s�Uq:j^U�Y�[wc�T�t��~��9G�<=1g��Q��^f���2�b/�6�Q�`�ql�z�<����z�1�#�- ���h� ƃx�[{�"��ab�űaj{��#��<$L{qpꋃ��P�?&G���Ҥ��{u���WGi21���xQ-�
����Ś�N��Kn��E�}aLD�FDn����Dщ��؆�K�^E�Fמb����-I�՟$c�����|Ԩc�E�85j�x| jF�R��T�n��d,EѤ���y���m���Q�S.cZ=n��������rYqT3؋grr�-��b�S�Ș�c��a摂�~@�~�fL�",kQYkW̉)�n�Zb�s���ML~�*�-��-u�-�����%[��<�hbZ��a��(�,���m�=x���=C��pE�}t����_~}��3������i��˷�H$�Js��1��R�<1E��<�vb�m@�����y��|���H�л�VIM\b��_f]G��tEw��ί.�\�WGp@.#I�7:0-�D���
�q��(��_����in@�c�����'�1��SO}�L�q�������l޳�zČC/8�u���a5#Cvrr�e�*���d�y܉SS��w]�`Q�-���d��q&�`b�B��a�%��*5y���4��#���0�y��u �}���w,D?�Zo�"?M@p �G��{b�;���&&� �/���ɉ�R�P%sٶ�(}\☣��ꗟ����?���Ri̹w9Jc������X�~{|�u����ԖUlt;Uu#F�hH��8�(�FGGgI{�s.�o�l&��}��DW�v�ƟsT9�&f��G��p�~3����N������E���9�Eh�!�_�:����D�t?��e��KM>���hb<��ʬ�qF��\L��	8�V[Uy���9�N�홼�a��dQ�iQ��R��G��7X�0�:<��#��ѻS!q!n�:&���~V3�!�*�9vt��\H\p�I�I]r�L�s���nF�����Y&	�F��    ��ʃߟ���!�m�#1���T�x͎J��z�	�!	������ӮtD��'�qlv�Η�/	|�%@H�šo�i\@�����LNl%���J^�}�0�R�
38 ���s0�bb��Y!��l�&�.�3���k{q��U��6���99D�p����C�dӸ��q�Oٌ�WZ�#�6 �#���`a��?������8��֏n�z�d��\��z I��݈�ɥ3�h4��]�"pֻ��Wtƈ����-���G󉩝�p���E��{�Z�+�~0�𐹸83�DbF��V{�@Z�!�F?J�8�뼿���^�뭙3�s3!��6���k"��~��lH�M.�T�	6�=0�!��b��1A-.�ͼ�������dp�y�c�cU�ua����r�P*��q�5��͆�i\����F5n¤�25lFd��׀�(0�hb���Q!�ԍ=�U�&z��c�-0��D��S.���fBR؞LL�Wu���*FD�WQ*8��$O<�R2��<�':\�4�稳�u�E�it��G��>1�eH[��Ѻx��=:FBTx����r���L~��eL��xp���J�&�~ʘ���p1�ٻ\�o&#���y��j��1�e4����k��C&��.{d���&�'a".fo��=�d�Hs �P�%$�ї1�+��2�+�^�{=��EYO"1�� ��L��;�爌\4�w1L�����^®������5�*"�"j����({t��M:�jR�����g)<�N<=1S��s||���?��_��e<l��[\�w
�]�#�J�S0M�Bօ�L�<�`��^ۆ�3E:\DE&��E�>1�a�D�-�a�F?]�v��J��̦�`kUNuab�?j�{s=G]MLα�p��_����_(L�z>ۀn�����Ѕq���%]b6���s�zV2�G�;\�3�].ʙ�'����x����w���}������vqA�j��B�u�X�p�:���4A*;vRg��\�ؐ�j�rb�z�U�j|�p`Cj��d�����c2`ܮfP>���,�N�sdP��n�2(_�&�ʠdtH%��E/�S;�����5��97��E�N�q��t"!�a�foV��	�nbZ�a8��4>"j��Q�I��n�)�K�4��!��H���AKʅd���^�%&��:\�P]����͋��]\|�Z"�GM,�ί��=1ٷ��U`�t���7[Pa21�"'���N����iyS��3G���!dw��&+�Q�M9����:{���5�V��2k1��1��,�̰٩�}����&��}�
=`�ZsOFG}9����Hb���r���mNLO�#\v|��c���}�L�k3c��9�#�і�A[��y8;��EA�S��A�7�oy�ͩ���K��R�ڣ���Q2$�l|�yj�ތ��0��� 3�019#�S��PI��V����Wb��\8����/�7��oy�$6��{��t��'���~��č�m_S�=Y������W&'Დ(v�&�N��dbj�
f�AmB����E����wk�=E.W��F��y���B��[b��9]6I��7�^�ι �0Xu��k���q�$�e��q%�J�3�q@�0�L�Q��!c�juZS�2�^�],�͢r垘���M��"������C�<b}t�GlI�������t���K�&�=�H6	)�Z�Qf�(���ir̐��hS	v�>�Ac�D��z�f��tg�-RRCE��+T���.7�+�1���s�x8!�Q��8T�0����Z���Z��:Ș*���������2X���(m|�i-{ ���j
�C�x�|TG{yLLw�3.D��y�G��Э�\�|ձ�MLv,0*��e�͡=�2��M/K��Q2�{T�/&��t
�3=^�S��2fX����W�q�]vQv���[k�S������J��[�"%S6�����a�˭�[�)�N�v����G�n`6zt�qY]N�ej킌1'_��썮;10���Q�6?c��C��Ș� ��
eOfMM�GFVS�T�0�nK�z
���;ƺ�A��0�$A���k�015cp�n�}�W�k}��SXL���u�A�A��R��#��^0:����9�Z�/N���m&/��b�Gl9��[��Z�r#�k�
s����cZm||5�F�#Q����]\��I�>�Q���25�rK��l�%��$�	[)�X�/y��[
��N��S��abL�v��>�]��!9�%z�W�A�Z�-��m�s.R��S
x������Q�v��!��*&!��d#����_�������w���RͶץ}����L^�b}�[/��դ�z5ր6.��]D�M���#�D�]��&���u9�
��LlD�qq�x��csa��.%n���cj��&r1%^���`���y�������K%���r_���R�ۼS�e01���+���;����38E����}aL.���.}�gBm�]fb8.��B����;�Mz����Z�{�<6i�'��`G�q�H�B���T5L�Q����<�����+���@���m��2��)c\p�@�|�|k�\b�fz�07|AOz�-�Oedp��4<~�Xg,��(���<=����G�k��D]�v�������p���<����U��!)�Vo�S������>�f���ƴ4�R���.���_~��M^�
fo�қ`�EB�s.j���N���h"�F|#�q�-j�T����1/��}D��ϕ��-���:�	�~!'�8�d�SS�pbx]'+�<ͨ=��|�;� Z&�8x�!�esd?oI����2�:�|ƎP��f�y�%Aj�y��[�	�M�����Џ��&���)A5��I�"8Wa�h�G����1�H*�"�45s�����>*��ӟ������߿~����_t6�]k=5�W��S;,��A�ZĤ�h3�x�2�yMtu���c���'�
��w4��=�̹�!g�坐s�i��d�l��\���r�Q]�I�>q��Q.$��:q6�%�����$�TԤVFDNj�̊�tޚo��.����C���،E�0Z�VŊK,��c�5�1+�ʸ�xs����汹��&�ut���W��.zE�L����-��:92&n�*�&*�c�E>�^�N�aEo!�� T�z1 1��^&s�������6S�\�\N�6|t��9����և,f�O��_Lq��9�"�УW#��(���O��a���c���y�c�g<!H��ƥ��������Xx׺{���R?3&��wѕ�d����m��{�a3>��%_%�9�lp�%˨�Lly�L���n���9�E��=�*�c�||5_1��4��rUD.�"vqq�+
�"lҜ0{
�.&f��WB..��}51�|#\&|��C˦}r��)E�S���}71��$q1]�c��+NH���di̕�_��O�S��)��>#�2�,=�f�=��^%�q�~�U�"�2"z� �SB�܄��{]�b,3�������5cz��"��?~Dt�N&�_�D�t&]�pjΞ�r�LL��ɼ@�[��R�n�\��݉p-q3µa�NL�<#��nCg�鼼'�'�A���1�Hb�����/~�0��>���hb�Q��vۗ�����&�Jr.���1��G�6[�(T���ʫ=p�w�Q��w�����^��&\bG51�#*3��h^�_��Vg����/6��2N�)g�&�ڟ^���
��0�?��B�w�XG��$�;��̮����x�>�<�L�=Y٢E��|��E{R�kvD��Q��l��N��d}$�;%����|��m�0Љ��_X;Q�=�q!bQ�u�L��1-l� v�"fğ2T��Sc��
�6ލ�s�J���z-��~����u51��C����W#���|� D�@,�CGt�P2�����5�T��\Xov4.�_�2��
��f}��e߬ᄩ�t2b�R�Ø��L�րϥ6�3ƕ���?�n�7<+��uYڗ>ՙ�/���J�<'�J6<��o�f��i\�    ��+��	�;�b6a�����
�Z�W��^�[�����o���U*Ӆ�
��˘H�D��d�X�I]�C�0�D��*�i�ld�~��ݢ�E�עYdb�]��P�K�E�P[2#���R���8����26�	�_�|��Ӄʷ�[u����m��#�x�I�O�D���P���Tt\U2ͅ_��58o�����_�� +|�W]�=*�a�&�Wx��F[�5����M/��T\����u�<ͦ�_6j|�q��+.b}��^}�����m��4�/L8ll,07�EB.`\V�m��4rs�e��n�0��FT��rD�qYpϪ���y��<'&JgE.p��H`r���g\�A��Gn팉�5�Ϙ�ʅHr_i��&F2��+V)�F��=.�팸�&滝%b�
w�%�c�i�o�Y{>c�E��~Z��q�1���ٺ;XC��Q֐ʍ��+|Y�T�#�h��U�1]ww�ؖ��\��$�HJD�HH&�fȯ�؜����xVzt�-�&�Xָ���:���ƆO���w��6���""�}{\��z5��|�P~2��������W���H������e41Q{#r�y[�`b�t�s9�KFYN*3{=��}$Q���pmg�"R[�{.ȅ���+7&`�&��Sz�N��}2��EYJ1�t�>����zW��0���w����i�H�o�{ۿ�E�V1"��<�S�۰�X_��CC�#0�����W�K����V}b)�k�ڧݾ}����bbJ�}��aw�	WرguIXj%���|�[�������!���>i���O(��p?�}#���R�o��h&8q"o�y�kx��'�u���>`Vt����I���&jWR��5����
��0����ֽ��RF���a�}V1�a�5|��m�E�H��
 �f;%LV��T@�Eŷ��k+�N'n��v�9��9S�_�'D�h������Jڪ%ta=�ë�
J�q�s��7flq����;d2WώD�}G͛RFW�'t���;n��ZM��6o$�l�g.e�̳�y6����� �����MΥ�]��򁆍�� ��_�~�5q)0���J7��OD/�g\�0��|�O�|\mĐ�/�<r0�io���B$|���ȋ�ə.�vq��-�؎��n^��4��&���*��yW�q�H���7�ˆ����Z��K��P`.�g �~�O�!C�ɀ��E�i���,�J���f�v�1�J惒��5"�)m�O:L�q��ys{W��ƕ4ϯ�;F*;H�Î����e�F���n.��ʼ;1a_���}����#מ���կ�K��M��z�@ra�C�~�n�e5�^����#<N�F��l�iyX�a71a]�k6}�t�ѥ� �0�E�����xu~�c��*&>�M����k�}q�`��47���w4�������zK�4&&v����p�fM���<��+�����0���fwMq���1m�@��0j�]��\�w1�o󮽾�jb� ?TG|(�X��Zh�1���W'�*�.o��DHUb��yO��9 �j%b5C��UX;,N̪O����9(;��ߛ7G;�zo���Z���;pL6����6F|y6�_�P�Ds:���>�H�s�nKַ
/ݘ;֫����\��~_0.������W�����K�X��P����\��^?�����Re�`���0�,�����歃)�����՗�P�mlx���3v���Ջ��ܞ�c���6�[C�^	fj����0�ǷJխp]gp.�!���!՟$��;9�	o�K0�F"�z?㲏�x�/�1�-�0,X\���s6
�&��r3��8��U{v��lg�g���??��Oa��=Ysl�ˤߜkO�:�ث~��x?�碉)	�{/��;h���j����&ld�mW�.K��Ӽ^�ț��̰����Jy�!��*<>Q.���>9�å/�����7#&��4�����sQ� ����1=sIǠh��C�a����'��F��f�� c��85Ÿ���Ďa�i�I�i,�e��+�/��D��~�Y>s�~����=mtw�<�:lxbz�cv�@:v��YM�k��THo�c�Z>*rԛS���|T|�J��I[ӳ�Y<P����u�|vKX�J	�c73���I�姯����?�����ן��o?��1w�α>:r�Z�(uqy/C<n�2u��Y��uqb��~����E��3&���s�	g����T3�k����A�ʀ�5/3,\�<���U�����[M�G|�<N&FJp��f����^8��Ry�����\9Z�7��o������lj�����y_`P��M']L�( �B�ƌ�m�ɉ�m������6�D��A.a��uHm*��;�^���J�nӮnI�D��3c���\�c$bd��}�Ws�;�x�������
�^LL~@*a$�S�����n|�x�$o�bg��8��v��G�A�֖��2���1�s��A@~+4z�^2�[���)#��+������k| Q��q��X�#Ϳ.j�Uu41="ɸ�1>RxX���1�um��Юt��oF�e��/���������t��(FC7�O�`���c��3��	6��z� ����'`\H�o��b�P��c=`��j�����:s!��w�\��$B�4Eis�b��K���9a�C���12��2Bg :����P������z��W�����4]�Ҝ���DL.�]�1�2&��$砩����sΩa��Rg��V`�0v�-t|��ã�るNڸ�c��S�0�΁򊪱�Dѳ�Sq��b+Xt��vbj�)�EU3&z��q!j8Mmzy�-��y��
�ɺ.6z�<�lg��;aY['�}^�MҮ��^�N����..J��"�/���.:z	)�y���}$��&�'Y���D9���� ��&&�e���5p�k~bz��5|�>L���̎���輩����+�c
i�(tb.�fm�b%��#��Q�J�w�J3��fZ��󽚘')��QU�=�p	�]�>��X���o7��W=m}\/��1z7�Dd}�@.:�s�aq�+;�� ��ձA~a��T�r�U��ޣ�&�כ��Hg���^���(���ر7��G�\�H;��0�㣡r��o	�w�n�.�Jg���uQ`[K���p��J�n��m���(�Z�Z�Ĥ���:�%<1N�ś�ĥV`�]T�2�!l�l��sԻ�˅���B�N1k�I����l'F��w�9?��,6�Ù�Ȑ*4Þ��H�=�1�*~������d��Uښ�t�P䲛��ޱ����-��re�֕y���Ϗ߿��CgD��A|$5���Լ�_	��	Ę��u���\\��_�	��Ւ�w���2���yq`kf��%�L=Ws9/ ��_hW�O6��W{�;�8
�I|�"*Sܫ���D���a��$�F$)�4��j31=����:8�/��ĸ	$@���76�yl����o_�@����v-;r�@�_�_�H%�r[���rp�K��;,J#���*�۠�]�g����Tw8"���j�t�j���\I��M��S"�1��g�5���9?�	�ҏ���gGy7��?�s�Cz1�hF����� �"֊R.7kE+���F0<
���{���_�?}����o+�R��b���}�C6\��#}����Ǘm��˕���[(�8\N�&������o9�P:ݽ��?\�Ž������ȋ���]�E�/s����C�8d�l"Rt��RҺ42��a��i���1];P1�\L�5 \"�7yDi�hv�1��d�A�L=�	rY��48��鲷OX��K���b��+l���1!ǄSJ���=�7^�'D�>~mFU��9����0]��\�v����Ч�bI��|�e��6Ȣ���^�6;��M2�>rt�h���QE��e�g�.Â�Ζ���W%Ҍ��G�[.�D���^s��v��fy(Ce�i'����mt��˹ ����jfe�nx֑I �� �  �Vg�E|	�WJ|ČV�F7���6�>���!#H=�D���n��0���;�����d��������]L�e+T�jՖ�Qq�Oڨ���� w�Z�����{�g*=���VL�Lx�����#�]�az�����G1F�6�=T6�S���P=���Y�\B7�=Ӽb��Gǣ�y��(bO����ᶅ5���ZBA)G :�I�X�ذ;����X!2L-A���n=F���6�3x��`��y�n<����.�����B$�酠a�QvM�Θ^��4��XJɴ��2:$�������u��0�"�)�L�L6ʥ����x�i��*b
%�� ���-ٴ͕�v����ڎgO}E<��z��-�.�k0�g��Q��g7E����ŕո(-�$b����O��s��6��2s]D��7���%5.�����l��k��Z��½�PJ�DL�;j(�|2֐�L�G릉���W�⯛&.��D�� 
����rb�w��uC*v)b��Sײ�K"��gDt���Ž�rQ��Xҋ�Gz,E�3&������FJ��ru�X��P��O�3�X����Kz����wcy����:R�V�0�3Be�&�9��$���)�E#C�5�ꎽ�~�`���_/ο��Ua��"9I�4Ȅ���2���Dm��\�pQ�׌���pтp��-���lc;�P+�m2&��;�d�O�(���pS��oY�$���������R�AdLL��fhb"'[U��by�˽�P����J(���b�����BX�D���^/��	S�)���>F���P�	c�#i1��F7q�<��bm����9d��ҋ�gH��I��w15�����&�*�*�k�`��t�g�n��#��Sz�m�S�g~�J	��Nw��b��FG�mO*�;����T��>L��NX�V�{�f��$E�0U��#+v�Q�(�h��Ig2�	��<i׸8>
>z2�]o{��iI����Qz���\csTFoL0��#�k����+��j_�,i�3�s�p1Qe�õ�3)c��\��'�Y����|pݜy�X����8ɗ$Uj"��#\-� ��Ld_;��(������#�'k��jp��\���P��z�Ѝ�{��ZsfmÌ��1��u��1��k1{3l����bD0�:�r�Z��%���I5+��Q�U��n{,��2��w��͌�[ar��0'���K;|c5�O�����)�����90g��[��v��n:�ׁ|R�g�$?Tn�S�B��W��m�ݔ�.��&*$a�;t3��?ME
F��XO����%�FT!٨��0:a�0�s�C���զ˘�ts�!����>�U����(G�F���is%�T$8k�vǀ�2�d����0cxgV����u������'[qW      �      x�̽˒7��;�y��3����YRʒXE�2^v������kE�~G8i��]�e�&.~���ӗ��U��U���?)�:���:����E����������*<��yϫ���>����ӏ������ǯ��������_���篿���ǧ/�>l����ck�;:-:�����	��6TC�����~~����>���˷�^�>�~|�����V3��N��U\V�5�W����'�>~ЎVS�UԷ����U�[����/��������^�<���ϟ_����˷ח?�~ل?�n���/߾�~���2X���ÚV���!d��8�?���
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
�Y�� Rk��Ev�"��g(�I�u��������l�f�}���h��?����]���G�&3kY�B�?��(��n�L,��gm���D�|��g5�]�|��P{�d�bQ��ot^� v�̛L�'��Φ"��!�U$�t��v�`U�cu�� OՍ3o�7�e-ͭ$�^8>z���� �.1���Ůگ��'��r*;>��ܼ����wL�Xdײ��RNPMKp6�Hmg�__OE6�՚&���z�b���]�>�z�H{�
�$}(�:�@����*D��|
��Y�����&��Q:�D���5�AJ�?ǻ��1�[�Щ�8����݁�$�f�l(�2�����k"o'׳3j�����g��������� ��X\��\s�Y��tP�U�U6�0?��zwCمф,��v]����Ŏ�B�lđ0�*u$��X�H�D���	G�(u��e��<hi��Fg��	���Ɓ:(z�;��j#��\�_h�I6���t��A+���5�(3��;�o�V�����2q�j�J�L�P�nZ%�4b�qC�²�9�4�>[:>���2i�,V9�+���^s�?ۃ�����dw�$"o�7*�����w�@�[��ߢ�.���Iش�Tִy��n��2	��^@�`5�&Ok)��E��%�C�R�x�ҭ�Ա�S�F�
ʄIEۿ�4S':��HQV�$��S�+W��B�l(�Z�����o�M�_U�b�y�N �-|������NS�1�u�j�ͅ��\���ժ`�c{�����Y�NE�o!�z�12aZ-��hh���xt���9��7�����+�͒��6� ;s��=�M3��T����k��r�d��He}�5�N��*/o%+(�%	��Cn��rj��99�#3�(��%d���!w���1��U�R��4�>2z�n"��&�!�o""�5p�os�)b�`�d�(ߡyO�J�c61�3\�
%[x2*�,5�ع�C��t������L܌��3u�u���}R�k}�Q،m�0��zZsc�G��:Ȁ�vϦV��Թ x#S1��U�v��{Ovժ$���h(뵎o�@�k�9�n��&�q�`2g�$�x<MrT�
eR���G2�̛�]ۛ)��p<�	��C5����7���
,��l�B�F�(T������J�1M!���*��
����u�)�Tb�����oj�R�Uf�1JJ�29�M�ⅧR�]@��2w}�v	y@��}ۿ��n��r>O�d9����V[@�����@�C�Ɂ�&�zh�.\3�)�U��;q�B�e��Ц�V��s���*X�F���d�4��	WS�	kL�0e�s+�:9_͇ii&ұ�� �ϗ�C�[���8M�Nzfzh�33��8�7�R޵P&~��v����9s�:����Ac�₧F۹~�!�Tsʤ9M�����J��0�vM�P&�k&�r��r�f�*2q�%�Ҭ�fz�EG�R��(�4E؉ 5�&��1����W�p�8��mZ��L�#4Q���LV�;�(�Z(@�����A�9�3�����oJ8*�	';v�5ٙ��l�wk�d�J9fY����9�]&��Ο�w����U�"�NV5`�u�·�)Sw�,�6F����3gjR���QE�h'��\�)�!5-k*U<�.���yR������tV�i��C�5휱W�޸@�+a�,2�0 <�!��%ـ�3|]����r���+�U~\k(�^Aw�ųaIIy�d�+c�B%r�R�D�EJ�a��Z��P�Zѽ�����Elj�oP�Ue$c���vU��=ړ�	��wc�w]5���c�}��9�jS΂�	3d2YO��nO�i6��#W/�0F>��34���� �Z�f[�rT�R�!0��5�(>y#����sA:6�R^TXqK��sѣ=B60`�������	�R>Q����s+`�l7�F�����lp�^��Z��))�ԠsU*A%6v��`�5Aِy5�*��z�,��&-�!�ɣ9e�1|�v<8�;H������
f�7�����=�uU������N"z�+h��'����l�9i��G��b���tX���b��
���N�4�Ժ�q���IB>��5�CX�%�N)<��4]�,>�aMd��C`"�f����cZ�3�l�*F��f�o�j��:��v��p�x���îs��:�B�m�S0����if�9�zL���=�UH� F<ٴN�wF��}�%�y����K�k��%V.���lm����{�v}� ��7.�&Na�����k�1��l�c���N��Z+�f�|�=�w�P�P�j�>�SL��ü��vS�-��u|�W{�I,�R���y���<��.fM�AwRbK{���*2I��,ag�o��h�z�W�3��/A;������ e�S����9���Tb�l�"-����o"�����h

@�C�<NO_�*_�z;Uw�%Yp�/�_��?�    ��ϯ_7�?=�ӄ2�qw]E��9@�/a�`ҥ��Y�,�-��_��_�	vņ[3�(��2zv!�-�*eu��r����8 ��ξ:���R�"ʼʳ���"�����56R���^{�3�lk���9�7D(*��C�k'Q�.ӹ�j(V����87�ݒ�i��N�!Lau[RT�6��:U����b֤��Y�Lg����s���h�"�. 4�w�Ch(����!��*KWA�4�%���Z[���R��U��7�R���2zi2I���9Θ?Ȅ�$��o���W(.H�"��	���:�(�����LZm��WO��)��J6����)�68��UL"��s���g�IpbL�S�:f��)�'���)B���<���1�L�!Pk�ˈ�jC�����F�T�!8����$�䟣�sec���R#�uY�������١4�I�ѧ���Z͵�������HW�HF9������7�C5^���FJ��ZX��ٮtc���IJ���v�\EE63Ci�u0[�3
N�U~y�Q�W�&W~y�y�W�8r��{�C��K}��tt��Cٵ#�z��¥~F�;�1�7����I�S�:fR~�ҀF�l�A�ҏ��(�(�;�����~��EC��qi�f6� K��R�=�f��:^$Ԓ�"�O��?)"íEʟvd�����a9�8-,��r�ȧ8�ڜ-�}��2�%�u/�m_����E�Š�rO�d9�s���1��:�FAJ�`5!ق���FmaȋЌ"?��H~ݿ=LCn?���NB�����*���t<���r����A&-l*c�MAs�����	�m�� e+9��;�ݡ�4��,#R{��TOZG���-nD�̘�!֡yR�N���"�!Ri�}r=;]�)�E���7O�[���d��t�P�f�8������V/�W�]�_=�<~�+��U��u`�X.��MҼ>��#��u�*9��g����v<��~��-��2㡑H��yj�]�I+,+ H���<yf�c�2=N �-Y�;���.�ƒ1�1�G?Ҁ,�Í��1̣���fX-���ys�����ɯ�vP6['o��6ck�Јa��r�����E����`�}ju�v<i�Ҍg]��+�j6*ǐ(�<�b��j�����yw���~��o�
	բ�j`���U��Z�"�������/�����.]:*��0.x����9�SߋEv��9�5i
�M�x���R�k۠�`���N��Z.2̒�q{h;�1\s���1�ʣ�q�0�����8��Ed(Ct���sh�)z��hxe�W�t���:R<uZ��N�sb�)z'����C4\L�Z��� ���m�f��۽�h�{��	��i�d�ج�B�۬�Nh�Ί*���L���0=���_4զ��	Æ6� e�[��ԟ��L�&��r���˲�Ď�_^I������MG|���뿿~�p���kF���,����VF���v�[���L`�y�>�,*S�Ƭ)E.'sP}LuP�.���[4<gݗ�����csG�eB�q�p�f�*�KP6d�2�����Ɠ�@n���ܦ>�E&�Y'���6�(���{^d��ܣ�,���
��I�^:�T��F��f(�6��V����b.$�j�@/��	����'ȩ��(�����>��F�nv-��ZV���M')W.Ԋ�@٘�~�2�o��|z��+��0h��W,5��R�!�-5"_�eibM��r���=�����$e��_)�Q<�* OR�����AAe�������f�Y'xv���,B6��1���z��e�a�f���8��B2)sQO"���1U��]�>��Q���kĚ��9/\ʮ���!{=o[垹ˮ����1\
�Pt�upu��2���c���.B���=�i{����08���h(�༙oM��H�D)��,k
�1��8HeBs���%+<B����f)�l_ʏ/���鏗��_~{}�k�&��dpJ���9�}�s���H�k�g׽����� b>1�FP�;���"��|�s��� [{�#��� w�z���6~�%5�i�8�w��y�D��7RE*��Y��+(��%�AN�Q��mr����f]��J�A�c���z�L��LRYk�B��:���Bk��ڹ�ۅ���T�9�� GެoTY�j�4�Ԓ�-�̒�D���q�����2i��Iɸ˦���?Tև9)+3�D�g��&x�=�o�Ȥ~�9�7�p~�g���AJgn� ��`�ۓ���Ig%3��Ziicl�=%�1XC�}�E�N}yc6�lg��r�_�c6krN*�y�A�#�^�b�'7���Wx���tiQo���D{ď�<�X����X��1��I	��3kP���0
�ؙ5���MO%£��ŧ�q8�w�؆ G���֓&Cuaߡ4�ɺ�O�&�\��wp
ur�]&X�㰢��K��4~���X�#�HcmI�e�G��Z�I�r�m����b쨻�㤈��2a{�Ժ$�M�B�P����z�"7�$aG�m�
6[5O�e��y^�פp�4�*�C��ԇ9��IW���2	��U��N����(t�ڦQfC'tc�8������WsN�K�"��5�k��(�����	)��q`_����Y�NADm]��2���y�I��MS�+�ϱCT� E.�YD>U������1J�˄n)n�7SB-�;&�!p�d�2�[j���"��f��@?�M7]QpoIf��d�c�A%(�6������\� ax6�Z�L:�>
r�ҭ��sB'x�\�~kc=�*L�J;mO!��e�E]Wj(�W��o=�2c\ �%����B��;�'
0N"��8+�iz�7�Ce�A6?�cml����zk.�3��O.�$�!�~����{�R�>a��'�x&Kȴ��<D��7������z8L{*h��8��+M(XWp�:;gS��:��]%t�l^B���JɿE���������ߞ~������kU������VKZW�9Pa=�Υ��WO?�&��N�d!�9ġ;ӆ�� ��3�1�����'��ޗD�l��R�q3��\���k�ۉ�p���
N��2D�I?�Ʊd��iR����d,���?�.��OS@)�4������N�iv�.}�'�)�G�B:U��]Ƈ�0������\)䶸����D6�?�5ןC�7���c���l`<���q��e�)8��G�O=D)��O2&qV�]�6�JYdҬ�&�\0S�L�M�taV�	�,+c�`��rd��>�@:�$z�҄47M�[�m���%#�/|���/<�&����¦��\~�A�{l3��.6z<�dh�{��|J&��ץM>!3a-0a�;��yPqZ�t�	�q��c?�N؎��C���ب]-B���y�Z�8�!f]��=�&5D���i1֫�b�o^C<Ey��tu�u(,���L��n�F{��'��3�'[�)D�|�\t�W�+�L�H����[\d����T�m�Zq����Z�A�J���J��6MtSJ&j�s�%j�3I(.C+�l|(�;�zeh,�KH�y�V	��v��k+2Y�b�?��� U�6�qd4��lBU�e�ͨ6�B2+z5�M4���L��7˘�4R��� �i��ˉ	..ɯ��	m@%e�d*�$"߈����a�k���@Լ�֗Q�Q��q�S�U��M��M�"������/�󛞕��1��=��D��)X�ՙT��IuFD8�ΰ|���9"�F[�?���|6p��m�=�����&��L���J��
���v�gI���4=
4�X�t�����2nr;��m��C�Av�ݛt��.d�֭
��?�}���W�.�Unx2�"t�I�YL��>f����8���9He��ID�������_d��X�l뫄�"�p���TZ�y7&��V���6n��Q:%؉�c�2���꼋�����H՞�"�����몤Dͦ7{��E{ᬿ��������|Bv�0����2I�ӛ���_HS�`�O(pN�R�J�S�\�$�2��U�w�;|��m��t2�4�e�@/}�g�J�    ���ܽ�{ᱴ�,ά[?�z�Tq=�d�H���9�qw�������`(�LsK��1�(r�頌�&v:2:��z��d��- _��H�'/�O��~�Uu�%,�k�Xgs��QuC���s��+�DnU�k=<�u��2=W~1���03�ޑ'�@8(�{gYݢ�bK�c�L29�TZ�#�dx�m��Vf5�ޛ�\���i=�E=�ʏ�g�l��W�"��y����Î��{oj��w��sԁ�g��ޟ �]��<^n�JCҁ�1��Z���m�XT�^o�]��?ߞm3 ��S������;s�[U�恛��Pd�:䛲��<�̘����4������s�C_c���l�k�y��Y�3��������O	�^�&�w��ˋ�o;,vհJw�Al"dw��QB:���:��:qyO�}�f�|�.��{¬�jlMtڙ0��'���{ j�LX��咅���ԑ�\̃�m}Yo�c�h>��[�@ܨ���#�:2&�c'���M��:z�u�Ѝ���Q������h�A���c��i_�����չ�wY/i��\���/��
p�ӰU1C`2?�$b�W)�tU�.�X�H!N��O�c[Ǹ.-^��2ja�J��f�lc�f���ޜ�v{�|݆1��%�v;1v�s�2����	�����
D��#*��A�7Y�cN�&S�:�)�M�\I�P�rg�3e�C=��<�JY# k�PϝJC��A�$��_�-� �Lb-r,ȋ�^9UD��\S\��V�L��1Gi:�70i��y}�Y��n��e4G�K�����h��L3��M2�jg�I�2����/0��F���F��M{쑳�ƞ��ܧ_4�^�2엤���z����'LOSJ=�=F��w������"��L����n�`Ґ�EG��^��)U?{�2�s�3C�3�ܖECY�'�[�1��m�tv	>X��jc��X�$��ۻ4�b�UQ�]v2����A�K���R�J�t��	��=��x�cN�tP�{�S�R�l\�v��xw�w��2٣8��QG��� e�!��.�-�:��kǺ��d95���E�Ɠ���l �R*�.
�4�U�<������.�	�������{!�����[\������6s���5�1� 0P6��������F?	�J�k��m627���q�w���Y�%W����$��[�~:Ge���� QA��j���%*ƶP�Z�Z�V��Ik����̯!2�Oh��a�ր�,��S������}'k�/.��As���.���c�.��e�^>\�7�)4��^d�f5�u����8�^��f�sx��� ��f�06�a��͹β�L�[�%Z�-V�;���{��Gy���V���M��+(���a�R&=��Ԅ�u���lp|�˛�֎�)ܔ��,m��Aϱ���>�R��<����t�~�7e�~�Ә¼�.�,�a�K��Eڝv�Sc�M�)���Gj��JpfO��>��	���P��|oC2�)�҅�uJ�D4r'0��5�.�:�LҚ��H�Äecc�\��qB�,�d��	��G=�ȷ orٶ�"�,P����@ז27�Tf�C¥�� �v]Fn�qg�$qO�Dـ��Op��' ]������IH��Y�S08�ӳ��!.Qb����T���V�]&�-�Q�ө�ٸm$�)�-v!E��YD��D�u�+��d�n����hg������ܿc��B>����{J>s�i�EL�JB�e'ky���`n�KJ��V��A6_���i�ż�VN�W8U�&(�{K|��4��F�=i�����q��w"|�h�_�t�/bn�X�9��5�o|�-/��{��m�?����mA������ �#'}�1fY'���u'	E^��Ļ��[~3��x�o�"eƚc�Q&{��T�N�'��Fƛ����c��gh�2�У�[�r�^(���h&-.��u��V�2`	�N�*&�� �<��ƞ����s(!w��K�&�;#ǎӍ!�P&T��1%j���Wp��{ԔnP9�GY���IT(�i�^�2+v_G���#g���^�i:l�щu��E���I ��W�Qvrpv���6�7h����6��<]Ϋ�4&�K�t5)�+?6�;�N�,�X��'|�Q\�Z��e�iVC���y�3vӂ��<y�2i˰ڣu�����zoq�w�%�A�͋Y�N+���9�:�:��zpb!��n-a��c���_e�����(��2
�M�6�GY/� NN���i�!F��e�2�����$f��4�n��?�͓ei������-)�'��s��8O�:���/��L����Y��Q��16]���u��4mc��U"���Q^���)qVQ�[R�(30Aم�#��S��'�Ү�*��ώ�!�Pv���ObJ���A�~W1G^�|�� e����[���gD�k?��7x���.��NR@zFw��<�5$R3��+��y�]�xkW��0��!9#�OO��»h�8G�"j�y�e��L���b�ҋ�;�q6�'�N��#���hrR��c��58)?�44�uR+��+��^{$ͮ�Ov�&#;�t�t�bvf �Љ�(C+�6�As���튛��Æ���W�"���|�]��R�
�6{�=7ParP�7��Tx�H��:#����Y���(�E&i ��M}cVuS��Ӊ�!pζ1Rq(mӲK�����L����6��,a�D�8�����zS��vsF�c�ȣL�XCWͨ
�əeFk�<��3Hq�o���Uv�U��]���D�fiX��ִbm��y���&)��)za���WdMѱ�bn��������y�g�A�4{c�2�osJ�]������a�I�%������&qw�b�{�0�ѠF
�qJG4+������U�S�����E+��u2���\��4�������IL��i��R~�eݡ0D�2���M��3Ll�0}�L����B%E��s>_g�zE�x'C��j���
3�f'X��u�IL�zk��F��B�`7����w�m�����ލ��G7j����n���k�P��ـ>�~��h�sȬ�#U�S�U},�l��.v4�gp�(�`��-�����1F�z6M�7XK��Բ������Z
(AK��eD������������5��H3�/�p���SJw��xu��(-�Y��%��5k��p!Ѓ�C���e�MD�łg�sjp��>����?^�������2�3��F��)�0�ut�:e�0��ښ�zjMF�#?Lir :����l,�l�������{�Ki�)_߬�o�Q� 2������ۼ��MCo�h�F��em5���?�=�����ˏ���ǀ���#2�u��6ϰ(xҮ�J]��E��&'1y_Zk��)q�7ZdҞ����E�<s���EC��9NJ�:Ѵ6y8v7<�&:ѼY��0�ﴘ��uv�y�re��`=�S
#�ՕG�'1;}�̱�MԋYdº�f������+�&c0����^�"���Mb�&^Y��>��`�˰DI������68����w;�w{��l��Y�SHi�Do��us�d�xl\�oP��,��n+���ϟ�z�w��?�UB�q����*���Ȏ�#���IL�/�ǹ)��zK���e#5ŏN
ʄx!�����K�_g���kX�Q	V���������Z@�7qV����+kͥD�x]st�����F�����1x��=S
/������Lm��Ԣ�~*�2�{�iz��"%�8��am}d獎a�ݗs�l��Anߵ�P6߁�ÎT�ր�!�x}�Yo��,�4k������n{����z��l;���e�3O*���Ğ��I7�vy�O0ɩ��#�mR�����!��z��D}aS�I��u��O��7�{M�����(�a��
�F{7��V52wz$����:)빏�u6��he}BC`r�b�vr��!wk�_�e�o0��H���PJБ��[6kL�NbZqǩ<$�((��8U�Mn�R:�fu���N/�!�^�4�4��&�Nbv� 7��<cMG(��l��z 4��4    �=�p�$�I=�"A��#=���bl��2	l����Ò����+��0a���9�N���m�P&�rF�8��t�%��©ё��:�(8Nb���|�����]v���ǀ�M۵k�P�e�s��zf�@)�J�)G�5�5m�U!�.{�ѹ�7>��=��ܯ��O4��$��J��*i���}oLe��r�rZ"}�1����ܹ$[nix�ZE��A���UۊV�T�C�r�����F�<$�'� o��ҹ�A<�񽚵犊�b�8v���I��˟�����o��n{����-[Ը{it�'}�o�a�f�o#,K�&�/@Y�lL���-GK`+��N����=��8�^N@�;��e7��ӈ��2$�<��)`m`t��@j(��y��� ����J�|�i�b͆K%��C�b}|�2vΜ�F���W?bg��&W����꜄Q~B��8�X�#���>���2y?�IL~p}� �ir�Uv�x��J�F��v�c����&%�`��0�<��H���\�?�R;ĝn��l���� ��L�l �q�����V<��G�^�M�Hξm��ll'�r�_ޢ����M���i!87əA�P&�
��i��\�{ҁ\�9�������-*l�'����S��{��3F�m�Z���BA�<�3���i �{����,��(9e4��@��L2;,���R�J��e#��Q�����:�>������soeew�;�v/�9�9D���Dy�{D6Ubr�+�&?H�7J�.5�Pv���QB���y�λ	��M��8�|_s��dk�JUZ�P\����m�h4�',6��G�1�ؽi����7�8A����2���ԕ���$8�@4}�La�l@Ø��Vv qs�[*�jB�lPݤ�뗲i/��Wi�]Lp�[��������>}��K��>Ii��ޚŹ^\(��9%�0�T���d�a��ͅre0��ϯ�%�G�zzK*�4̯���{�~Y6��Yf�I�O�<n�5��Y��.@��,�ӯ~�9r�Ӥ�e�<�LI�˺F�Pf�硇�x����^������ڬ�����.ٿ�'�P�%+�=is��eR��]2
�߈�]ڙAX�@�R��)7z�0�ƽ���nAS̥v�ك�=KGf�L�9����ݍ�K[�Ncއ�!�)|�)���*[x�����K����c;�G�x�aJw@�v@���8�L�_�l�,�Y�#�bڸ�.��aJ��=Hy�x
s�\\�H��ݬ�ʼ�$-��<<ȭoĽ������vpۆ�P&OП�dT���Q���9-���,�	NS���0�M��N`�k���;�h34�z��~��ݐ�07B�J��#��x���z��o��m�Is��aד�3�C��Nr*v1=��ڵ�"�-�ki��jD�A�v:��'���Mrr�-	��JW�NI�����~���/M�t�����ia3P�V�@F�M������f�p7
s���*��P6��s���Ir�ͅ�	;}�7�"l���{��y���<@�&�ANs7!h��^O�*0F).���ė��	�4�*�I����c6��d��3Zd�9-<�Ӝ�<��}��r��]|8|�|g�{��U6����HC{�nKPz�=�dy�8$E�I�CR�i��4gAl0���s�{)x=-�
V�sqe�	�!*(jE4I:��:N_d�Y��1l��������Wx�D�j0`#"�lx�G%�WצZeM���|�ݕJ�VX�����IdU0���Vd�t�9�����'������6G���;E%H�� S	S�7݃��MObʯǼ�+�]�q�ci$��i��]t=���G��z�Q^�"2����zt=�S*>�զ���(@�@ڱe!�׸E�uCu*�:�aeO���rR�l�Ύ���uT���
V}ȋl�'!C��r�%����D�D�p.��3?�-��dp�p� ��:��Z&saqI7���6�f����IL�c{�;����+� `�@��]q�l�*z���I�N��R_����<"}f�F�k�6���g 7(�$'1�E�z�+�l0�'��fZ�-*h�x�Pj��45A�:����>KM�Ǥ�s"����Ϻ�*ِJ��]�-}:&E2��sd��T���w%8="��F*���F*���a2��!ȡN����E#������Sd���cN	�����CD)7�\�#f�Ll�MR��*7o��s��ﲧ� ��Y��ֳ肶���Cm�'I����`[�)Rq�
�ru�.{ҳI���Y����LeC�Y1�*͛��MMr�i}m(5Pf��I�l$�ˠR�8h�:9��lh�2y�w�P�Fq���lˇ�C����,}����#�/Ei9*�"��ș�̢��4�g������0�qwf�tһ�$��V�*]mLZLX�j�;X�Qk1uѨ����O�������-�Q֬���#p�;�YVe��sX���&5�{+'7�'1� V�2�{RWn�]&�O��Pi��D��^H�ԇ1FqZ�%O?D1G��,y�T��Xܪ7��m�)0����$f�A�(!�Ǻ��w��K�M�+�V/��$�:H���ـ�4��[#�'����F�.�;��I�#JO}�V�u���a��� ��9L��[��t��Q<d�>[�}�/�p:�h�ed9���\-�ä��҈+���Ut���2F�"���V������ұW��H�u�T����"�}Ě�m�4���ִ��1k�%5����l����3�L�Y�[�)�f]bT��S��*O.�ô��Ԇ��Z��2��A㭵���3d����-l��ArT۞ä��fq5^��C,����p�/��2��Șc�9��h��d�\�!>yb��E�]��y��f��3˘������O���E8XlX�`�Fuڀ���=�5�F^�KPu�C6R��2����5�w�c���ʽ���Wm�����w�=Ʉ�v���g NJZ�3��a8��ً(B��8���AOG�a������]oO�ޙ�bq�zd=�C�Ro�,e`_�&(�� _=�������� ������R��Z�w��<Gi���KY����אf���0a��H��#��b٠ldN��ev��;d-3MS�]�"���̮�>��evOj�V�
'=���L���vF�����)�NQ8J�I[(�%�p�T���������C���A:vk����>�lpt6|����)l�-�8�1csJ2n�L�$�f�4�И�.�ؘ�_O�6H�e��,��m�C��J�4�� O�!{�U�	x��}L��_�ZE�r���G�k<�S�ٔŅy�3�����D���)l�N���e�Y�%���i��NU[ʻl&5��u[1�d�&+/�n��jy�z�| I���7�ju��ѿ��!PP)u��^H�Bj�NӜ]D\Ba�za:��x���i)���<2&�7w�T��
=�����+|K��ҡ�v�7���&�W�O.a����ާ|�e�Vy�L_��� �
©���v��=��J>���D����O+S��O�~E�xP�C��@�č�^H��A�YL'�����$E6;JPT��x�Lwhջ��H/�ZO.2a[$���S��B�#׳�l�A]�Kj��3Av�|����^��L9����bM��=ec����Ә�B�.��z�oࠫ��P�H��S���'���p�W�X�̆W����F�sk�2i�f��3�s�=��Ho�xE֟�|T喙�e�	r��%i:@58t��J�=G(�g�f%U^IK�10.�W�y5M���Y�'��h�/�!ζY[�G�%=�LKvϻ��;�6f��E���K(�$m�`sR]v-�ܜ��{�R.ʉT��蓬�҄]3�59w&=���NЮ�VN2����F3�m�ߠ��;�h�2+�$��>��1�Tq�^+|�#�h�c4Pv�hw�Tuꇄ2`/A��&/(tk����dX���O�.���e.`\��Y�h.��I�ϊ�B�j���K�}��[��|.>�>�c
�,Zk�� �	  h������u@1ɷ_�����e4l�G��d��&W�"�s<��F��ݺ��2���q���S9m�C8�&>��_ض�J��Ů��oL��չ�]�e&w5�l�8w�#|����{9q�
ʤc��(;%K��R�e�>�\�4N��j�������c��e�t�]j:��߉t�Gk��zW���-��I»cD[�-���~N�L�=T5Ԥ!�}�.Uu'�h0╓�:[�2e0R�C↳�o������!�����ݺ��uǚ7ӻ2e̅t����;��$�f�Ҁ�z��2}��Z ?�
��S������_"z'Y���A�	�?�u8��G3>k]r���֘:,�sWB�})%�*x£P{M�e�$멽Z��[��V��6>�تD�҉lsOF���Y�k��F�f	i�? R�PM�1뻯�b���2�w��~�����_���ۗ������KRղ���������i����	��;l���_=pUz|��q�͋oMOv��P�ۚ�D>5��1�Dz�:}ܛ�{tU��]v7"r�ء&����PG��^t{�Uqzq�*6�ʞ=��C�u�� ��(䜵1����Ş�[;i�ͣ�i�z���O��P�갤�Ǡ�rZ��T�恌y̞�2ik�6�F���%��?����*��.{�����>K�F��g�2p+��!�wn`0�{n���f�)j��H��*���O�q�7�E���(Yl>閨z-��NT�>�9npI:���V�]IhK&�F�:��?�c&���xʄ�/a6��rz#��]@5Bz��7�R?��n骀�G��놔ύ�ND�,J�/ܲ\��\�)T�ܶ�y���z��2��|�-�VS&59w�
*z��*d�:�:q�4�Qq=�ǻ��;��W^	߾�������_9WsE����l5P6]A�nU]�f-�΂��^��b5U7�G믴k��?_���/W<.+!���� �z*ڲftl�>]�N�xX�WAY?��Z;�-C��KQi�����ɧ�>��J6|k��W�[�P(���x猆���y�M���S�QE�-�C:��ʕ�gr�<Ʉ-��ɮ>j͖�<jF );�K7@����2��tw1����D�@M�^��n��s�hj(���@3���x�=*�Jh\�:6�H]�.��I6��Sf^�S_��|V��	�1I��Ǉ�9re���3�(][K��ٰ;�f֖e�r�h��$x��ֵF({��Fe��4�������O�|�q����,���O�\�:�<({��c6��y	A{�~t|J�\��zv�M�i�Y��S)2����~g��M��y���K:��d�p�ڼST�q��o_��ӯ?��t7HR���2̎��t�֯b�Ig�2�[�jٸz���RVV��#X��*�;�kk?���֚�u1��O���T�Z\kc��1o'K��bC�J�_yH�B掲Pև<�0�6!3$e�E�t�@�C~#t�-M�Q
ʤ	q�h���c�b�Da�>����]/�ߙ�Z'�����/�dҜ(�I��¢݊7��g^��e��5��ISg�H��X���I�3�j� ���j������;&��';���n��{�|v�l�w����ddطfG�������Y��$�Ο�N?g��e���ķۄ��oд_�8gWA��<��
r9"�l�^�Y�2�F��806>�[դ�<8"^"'��&e��T�'(�#.ۺlyGT������S�x�l��Ր�H�4]�����]䛯�C��?��0�&A����Ve땶��
v+*P���7`����zu�:���S��Zm���#+�1���d��eΠ	�i�IC�`���Y�7ƢQs���N�Z���y8��+7�!{��khM�Ph���%��[���\��a�Q���ux)�8�f֖g6\��,��u-��O��Ѻ
A5Pv��z[w�ᚣ%ĄQ�!̱(�3�u�H���մ�AY�ml��42d�yTC��:#3kݻ����އl�M*J�m����d��|?W�?'ٳ&��X�	�1�zL3��W��ʟ�L諚��c_���蚘w��-oQ l �p�k��*]r��2��n�8��/l�|�	#�M��B�Ϙ���4ҭ���8�(�
PF��ec0)cv�(Y��	���f �ݾT�0Պ�9�5�_qyecG�e��ݚp	�sȽ��d�0OlG�g����n���Y:�X�x�-��>xsN��x�y5��`��4�2I�E�u\�ݷY�\��LH��t�1SY��d�H}��Sv�⮥FI��]K�~d��X��i�	�<��6r�sq�9�G�Y�#���)��M]M�1���mD����x���R6���{zc�bJ/����s�§�(�P�nԤ%(��&V�>K��0�-�D�쩅/�[�,�Z�����ws�z�6:H�m��;Lq���{]룳˄�V&u�H�j�u�͵ݡs"���n��$l(�V�ܻA� �V��[������[~�����]�      �      x�ܽ�\9r&���|���_T1IF�L�2�Uƞ��R�4W}�Uw����/����q2��.MI��p�De�/~�_�U/η�������P�O��*�"���?I�B��BJ|�B\��߾�����z������B����R�WJ��di�I����}%�+#^x`����o^�����y�����ן�6u��2z������c��F����4������}!T/*�K)2� ���
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
�����v켑��~����][jI�j���䁄�x&�`�A����bs)��<=q` �:gt�5Y�F`�^�U.�F��}�����ywLx�e���pꮝx��Őy{s���g,�\���,�Tv�T6a_�U(-���c� ��.��V4mT
��R�R슚�x6�=���� ����?c��%��0l,�����ꌡ
c���6v"g�*o����z/o���~c!��:y�����}����E�-�ť(����8j��jjF�;�q0�;��+��/0��Z �R��52}%���'W��C��o��+��+������t�'�z>ryZ�o>�]���A�(���*~p)qז����7\������La�v�XF�q&��1;v��������L�V3�L~�K8X�ѫ���mJvmSr�X���ĎH�$�(�u�%.ǄwC~"���H�� ��8�}x���K�K'�r+����W�$���%�k�{1�A�a'������G��=���K����+�z�X*�X-�2Ut`�M��Fa��l�Ɵ����Ï���%�ܕ�]x1�n}�5x$Φ��3Lܙ���
�/v��k�'K<l���2Vv��9p���2��?5-���0�Z;���vL��c�e3��9x=&?�i�qC��k(
w���`�X`��]۽�H6�0��	S͈�L.H>�����%b�E��fm���u2�3��2cYXC~Z�)�%�d��	����d��|�U6�h"�j7[z�2FjL�9u4�NzɩtK�`G+ �����⋛U]���*�_ �q��9�¶y90=�F�D��ыs�cY�>�j��ϴ%������Q-�/�]i{�#�O��F�q���gŦы��JG�)�\��5�,�� X�;K(	lw�k��㫸k�88_%�xyG&��:�a�\�v$��ĨP6*��_;��4̮!�ܲ+iHb'X~��El8%�Š�wg!�\�0Wr4E�\��ǻ��0��=BA��6����&^t�Ę��d����{h�mȅE�ŕ�ɣ�H检b���3.d\�Z�P��l.��w��L,ϋS�^��1�B�5�����p��?K7�r+Ob�9c	���;���sb^tx-���������^�������v���F����[,#�Dy,�`_.��AQ�P�)D���~����X���X���&��Oˌ7�����R�3����/�[��b�K,SinC.X>>u/&6)y4Z�N{/�ߝ��XN�	��:���`I.�/��zg��lx�oYv�n��M���pј;�x����~��n7�X`D����_^v/����^f��'�B-�����{� ��'���~3��bYbP��h}"?��αs$'� ���/;�P\A^��ź+����E��8E�+� ��p�p��}wX����brp�����ϣ-y/�e�L.H�,��џJ%-	��8b' x�=�p�f�;Y�s(ӝ�p�â��	��!&�R=���9�%�pLo�p�)(~�    N��.�dg��P�^σ�!1�(�N�ڀ?�Z���t-�"��f�̰�.�X�Z�,�̸ݰ!�Zy
LlҠ�g=05x`����_y-[�'˅��Z~�,#���u�'��ٓ/��e����,�7��[�Oߊö0�K�XF�����c�3>�<�p�D� ���s^u��u�� +��+H&Sf��]�Ӄ�wl�Hu�##�yޞ�����e2��L��=[�K�;vu���
��ޫ��򻍄��r]y;�� 2%�π�pV�5�FX٥Gٵ���W1�."S����7�e,Fl��| ���`ۇ}��"Y��xgS����7ˈ�C���+�Gر:^j>�WZR���F�$��#����'3	a"S��4}pw��.p'&H���^�
eߺ'Na��cix��ס�e1�)�`��Qm������{�����'�L�o"�{y���=��MO��`DP`WMz�'u���5��L�Zl�n��]�dr���aE(��<l2�P�{���D��z��%b+ʩ'����L���(b#lJH@���y�]��͐[���}��� f��Խ�P.y�׸D���l7��� 6��agd&�h��9�TH�82�\�;�������V�	�
���ު�����
�����i���L�'����Oa4zk0��H6�>`���`2������HDf,� ,v��
0k,���bY2���a�k�6�C40 �R���[7 ُ{�'lI,u�ӭ�ƿ�-By	�hm%D��^Bo� e_��'�{(ֆ����n{l����P+y����b,�aIۅ%a�î���}a����T3������H`��!��C��w�ne_��	�y����V��\����|�zƒ�/���OoÀſҊ�E�ע�k9�vF�k�Y2�^��c�E!ɖ,�������.�/�dsS�܏�r��ϑhqXc�V�N�+�O 5"Q$v�v�5�3�T2�R\>`9ۇ��㟿��NX�<:L�N'%��ݠ�1=�gNV0|z8����d%��\Ƽcl�g�:/
V�u� `�v�a<k%ʧ��R��L����D�+���^�`�7�/�����$�ѨfV�y�[�QeH�K�ć�Z0n�`�5�=���ؐ�bШǉ�I��Ɖe���A��P1����n�a�SW�-\8��%W�{�Zd8VJ'�kǸ�����j�,�,yהb�&���x��*,4�BI�,����nЗr;��x1�q	Gv�Sɏ�)���;v�/��;3F����qQ���WXR<t�7�r'?]1
�k%u�������wq���ی�si���+�.�����5�h�8P��Kd��f�i��n�-����{I��E+�0R,���7X�9� �wa�.��I���O�Y?}�9��%�󩱶x��t1��]��U��R��8�Y֬m�p�Z=;8�T.��8�l��[����R��xc���l��Ш��bK�g4�ڝrl���X�.����!�`rqh0J�zɨXì	�櫹�m��n���O`|WJ���*U(04z	3�#�-���4z/�W~i�!�|.0��Xr�c�@L���C&]�0�5*�"v���R���e%R�"����Gӟ�*,X`�`��>�l��o�$3����F�- ����ϕƁ�#�L�Ls����7�AS��e��˂��^ڵ�eE>6��a�d2����M[�WU�?HbLCYed��}���dʎm�:p|��6��������!�V0w��|�3�f曠(�t��\�珠._�l�q���!�U,��32��ג����\�zF{\H� ����J�,�(*幚Yp�Qzaz)䎎�����a_F_��18}#�/�Sj���o�e{�V`%��l���C[�<0����� Sz�쭅�y��sX1�@A2%^o?�!I���&��v��[cn/@��\�jK)N��P�m��@�>| g�ů+�H_���$P���ׅ+��K�1�5��A�h�Տ[4�M'��ZVg2A���z�P��2:���.��q��`v�P�.�rf��|&��u��<� K
R�m,�McqF���d�q�Q*����%ӥ|�y�-3�k"�N����>�
r/6�O��VV[POJ�����֏0�BB/�����.|P�+��
R�|B���g�2�^LG5k�����8i˙�'�V��
�(�\E�ڔ4��U;8��^��{�hl��Hv.+�.j��6IŒ陽�|_��G���Dv*=�'���/����K�09���g3Os� ��=��BI�r�X��l�eP�$�)��SI搥&�O�GM���0Е��b'a�Hd�Ãt%T�o$`��sO�琘��>��(?�EIxcNHi�c[��L�9�8��^�a,�K��|�۟ء�
l;8�I���P���[#]؁�1Pd�2ەx�9��EbU�耱�d����i��C����cc��x���-.6����f��v� ;&@A򦶴'�����gbD��*@nVybMd;ۂt�2 �iUFG�y@`wt���3�]�Av��C����X(-���b.DΏk1���X�M�U 1l9;,�!f���`j��,g����_ W��pX�a(xd[��|r�1\�����Aw����D.��	F���#��<�ѤܷZꊩ����ɏ����Q��D��=۝���bk�ze�*�3�=�˭�"���#8oZ_�FQ�F�{���_�4R�ϓ3%3���o.����%�
���]R�`�۽��E��A�~v$�Lq�S$��aa���mb��lb�X��C�%ɹ+�3����t��fRFD&H?�>��ʗcR�G2bleP(�W3����4��pUF�/(�kL�⩖�����HW�2�-ՠ-��6���~q�T��k��g�.�`	�7�1� �b,9��,���O�0���V��`Q�qy������+k��B|3�S����1O�1���EvnU�c�~�Ŝ,�*!:(�#c�\��߱��H\�iE2m	��1�1��x��e{�[���ז\#bk*�TX�\��]�̠��ޔ�z��'�!Z0`Tk(?,�L¢��%�W�3�3͠3�H��T�Hy�5��5��n�ª�"a���y,b�Gi� ��\b�aY���t4��+ޣ�@��J�@��m����� ��eb��}"-����O_y�X CsXU���^�`����X^%�\����E�y�'�((��V�`_9�u|Ͷѯ$u���:pc�����1���טd)�����tv�0M9B��:��,�y*�[2=�w�uY	1�e�.ٕ�"֯t}��o�U�S����j�[r�
l��bԕ��c��~�r����+�'F�m)-�(,'M~%l2-�� �br�����kI��}{-����}8���,^db|�H<�"q�o��wB��?y��>g(�s��K�a�5�?�~�_��T�F��)�<�྆k�L���XaXl�(,v��) 6�'�	���v�|#Ɉ�0�����է����%$���n�棊&�J8�w�
hXY����y)�Vњt3�L.�;(ɹƂ�h��U�/�%���PKC�<���)Ғ�7�%.P�kXr�r�3Ӵ��	S���!/���җ�G�$���}�/�>28I�Q��%�G���9GQ ���Vk�¾�0���SFM��q$���G~�d�r��\%V�D0(�2"�)�E��,;:r�2�zf�I٘a'PG:=0�H ����؉c)�N��i��+Լ�b��u�����e֑���R�`aud�S���G����I1a�ME�9��#8��JPؑ����G(a_���E��$4,�n�݅�ZL_�^{�'��p�~�K�3;�����|������l;X�*$���=�����e@���^
V��#	c��OL,�����=19�t/Vi`}v�A�Ə[[����:�0�\�$ګ_������g��=1i�ؾ�>OO 56=��3�.��x1�1a�
:�c���=����@��܅�^��*(xilYu����    �K�U;�����8�}¢�a�OA1�G�$��t���[����b}�,�4#2q����B_ڒ�wI[Z|hl̢�ҭ��ë�Z̨�ϡZ� �\n��=3����]�(�xb�ڦ(:+F����F�8����[�&��i@G]9�(T$��>zF��K���(���'$�fm?�1�KN�GN�ܰ(:7,/��{]4u�V�#��xd�L.Hn����o;,����Sb�mr	���6f@5������0O��$��N%f�u�ǒ�E{����%(v�b���g͢ih�����6�� �S&���v2��T���&B����c,�p*����7B�͙W�TC�z��J��]G?]�ֶ%f���U:'Î��쒞��-���-C��o�#�A4���E}��(��9$�|>�!r���ۻU��k���C$t>�0�N�[{�U�e=r`�r����ͯ8���`d�y����^����K�E}!�1�9��솝({�_l��ӞGa��L��Ȥ4��Y;���d����0 v5fo p7�ç�˞��z�U42��)� v�z�a X�+ �ZG8�\��+��@�O� @8�{¢�8Gʭ��+[�3�b=��D&y�X�+�����M"Q��ZvZw,�(��Z�9$C������n?�}8��%B����&M�_rn���I�|���P+���pɋ(� E�Ҕ��c�R�i˺P`�6N������b�d�		N�=����$���)�d?~��
/���'rA���	
���/F`�X��Je�Iev��Й�b�<�Q��nÒ�fD"q�W(����(������Z��p�=:����d�\��GGz\�0�*�1�'�>��]���Vz\%� ��r!�@`�q��h$p�gE�Eq�va!Yx��PSZݓ��v����q��Gp�[p,�N��z�ߋm�%,'�W�9g�Xry]?�z�j*FƯ�D��꽴��*��p-;�t(uǲXif,�L��O_�F�
ECo�J,/ ��G݇�����Bv�=8$�Y��dMz��2!aռ���V�[#�O�WNϼ�L&����(�Q0-8P'�U'��k�c	O[Dܲ�g��db�ۻU=`q�Ai��,6�Y����Hf12��EH~@R�Uɯq঑#$�
4c`���������҇�3��J.�������eQ����'�ɰ���^���d��i�\ړ�����~2�5�1�?,��jQq���ׅI���v�{"�<$ge��g4Z�4o��ٻ1����.��b�f��m�u{2ſݼ�-�'xL��J�����ԝ���ɗ��.V?7XA2�1K�J���`�=t��q�Y�Ӌ��oP��ř�^Ť+��n�mB����k��j�f=1.r����.y�"�H`]���B�g�v������r1f���Wb�	���P,����Vl3U4����v��XL�W�4�}�a6�6P�w�pYð����R�=�Q��������@ׂ!dfe��'�Z=�
k����jg� ���r�e�e&�ęoK$�U�������W/3b`?U�7�L�����7}�Bn5��h׼���Vr%S�b��Ũ�k�p6:>��M�Nj�(K3��U2�+r2�G�$�!���쒽h�x��YGY�$�qot�a�=�����3����x����2s�c�����2 V�[=���?��`pj�M���dU>�n+�Q��[)��0��+�7�8�A)�g\{�y���J�{�VD���d��c7�F��+b2��ű����9��]�Ju���ڀ f�F���ؙ�B��:.ӛ�V&������]
�b�o�.�h����]�d�)�]vjzYD.7���$�*D��(��Q쒍��@s�Y�R���"������yP��Am��`����]r�,!YuNV��X!����/�W�
TUA/95��%��(�F�+��7&q��������8��J4����7a�uB�R�������E��GE2�.�8\�ey<��qF���(���6Z8b�F��L�SrNId�`}3� <\�C��(�'������mY�	��ďH<�Dĳ�#�\M���\�˧7�+,���C+��]�����*�����'ܭԎ|Ng�jl<h������o���?���V����"6^ӄ�Վηh���#ע8������^>����z� ��B'�p��ѹ^zAR�J lȈnM1<�ɔ�:E��7bR�K�-� �:W�;t��q�u�8؏-m�\��1�+%D4"�/�ŕcS���r�!�p���W�/b⡵�0����$uY˒I �j �IB��b�t#��h�n�T�3�
<�F`R�X�w#��ݓ��la)Y��G�b�P�'�IVy�a�	�<f3��Bu�Ʈ)YWޛ���}���z� �!�������0�%�a�_�0zW��j�/�@��+��^|��@TI�$����\}�R�Lg�Z�rH�%&��E����,�hH����(��$�H���H�Y>E�A�#2EV�UE��y�d��L�� EmC1�P�򏊚v����y�r�ʦ�/k��&�Hv=k��ϕXg�U]˂U�ǝ��\˧ˇ�ŵ����"=^����z��y`%tϥQ�s���L��?<�~f�E��0A8�EJv�g�j��O�BY�/�L4?0"���/�������X�1����y��>ȞY`g�X،]>��4ׄŵ��>\��p�!U��;L�|�vif��ܷ�5-�_�1���e��5 �uI*��ɝ��d"��݉�"l_�T �����\��k X���q���P����>�<COM��.��W,��8��&C�#�`�א;)�ICΖ��ŋ��z���N
�g�6��Y2t��m ۷�N�34�����ϫ����>Fo%���v����5��R�,�8�z�d�������(���'��p�J��jqa���g�Ѫt́<"W�����B� �ā�b�N�N"%d���7��_��x51=��Q�I��������&@�dx]�%�.^�^WN��g�&9L��^_>,L��SH�@d�#Jr=��No��_�����p�A_/Ր˥|�;<�c���#�hю|��;�Ym:��/C��WC����pb�'b_t���|b�|r���z��1^;|\�j�A���l���|�V
?�]3�L�	�w�n���\"��d^9�q�'�P�������i�����rry^��U�l��	H9b��k�PB����I�3��Z�k�' ��>1�>+��}D��r�\��z�0|O�(�ܶ^O�=�^ا�_/7+��3h�ڀ}�|㼚,�t�0nd�0���/�\O���7^��q���!�~ع��oc��e��$�ᖝ{�0kzf�/���$׀���z8�v�����Ǟ%!��Z�p2�༹�c��7�����UT�$⶗�̭֞�J�k�pUŪ��b2�������00(�$W��3+��J�l�+�	�s?���Ґ����h�o�t4mpR �\%.�D7P����V���~��h�E�?�Z!m��a��ۈ�Kq�0'}�����s���s��1�!r��������W=؋ƣ��ղ������T$��Xk�!U7�\r���o?�ƾ�`�ـQ�V�,�F�,,�p�eU��=�/�5|�J�Uɕ|㰊������"Z�cv2��s,���0�h�\�'�h�@�bK&k�����{-s-D.P>C��	4vIAJ��\5.NDh��ݨq�����Vӥ�"H�H0�%���pu�	��4��<�,sºLS$rBd����)�qpLI8��V�Dfu�u���,?��L�;y���Op\�eJ���e�,��Ͷb�s�%~�'5Id��}��	�NA,� (���V�W���L�����t1¿?s'�2ݏ��H"֬G�"�G�F�Tt���Yޜ?ȟ��z�!S��+_t��B�\�g
/�1�q��k���;#���b�<�����P��5��n[N z  b�Q�'h�4����*댗.͆TdC&G���B{�y�=��}).ϭ��/E�}�埐���%1������p�-�߇�0�H���W��S*Z$Z-��n�'����M�p')FdR-�p���Ѹ#���Kq� ���{ea��B?�bc��'���U,���?�.�X��ba~��-�%�F���4d�r�����{1
4��<�����r��W؀�f�BYXae#�%�	�;�p4�^l#i�Ph�`Pϊ�g����T�d�d�n&�(l�t>�G?r��}��?>�ѓK(J$�y��;�������kl�-B��q�̀������5���r�r-υR6]ez_p=��������X�	k��!��)֏�܋@Ei�g�%�c�ld/#���E°V�͜Ǝ��vd�BYď��(��^�@��uN8`��i�h�|�(���PΌc�KWGI\�d�-�a�ʴ����ΊݍDq5���O�ՆL��I�'�] ��z>v7�[⢛9'�<5R,�L���0p8^g�]��� Н^��¾��aq�_�q@Q��a�=��l%�����ʣ恔�����\�7�V��L�8b
�����z8����qM);MK�^m9)"�{y{���%c`�ċ[{$E�R������2\>t�λ�&4�q��v�3-�/��W�M�N@��k�^�9�q�^C�,/*I� ����8��<^J��0�rO��,�ώ�>��QP<l�0��3:�y�I��2�DhZKj���������"ŸH�a��]f!�ld�`=�	��tqX�L8�/�s��zQ�&VrۿX&VT^9ّD&;��W/�!׭|������ߏ~���$�      Z      x�̽ےIr%���
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
Z=o��!��!{�Y|��S�!w����'�?H�E!^��z��}͏���!C&��b�AхZ<P{	�n��>C�h�=�~6��S��>�΢i\���mɎ#�}�_��N�=Bo���B�.����R�Ns�j���s��ן��+�*6e66�����[��k��r?y,��0v~�3��������A�E_l�t���t��
C@f^�r>�r�%1�*��{1�U��&y�s�k+�tĪ_39;e-��7����
��$�er{EB�,0���Il9���^7U;��9��#�<�j�GA�?���[�!�)<�>��$�ԥA��x��;硂iν�Wݵ���zw~q|bR�@M��l�vNw?�����$)���-c#����c2�n7��)�3�B?h�e�
��$z�� #�\Ҝ�^*;��*�;�B���t-�/��B�_��^����̓���C��/��oę��Pi���¤�+�h[ߟnĜWA�+�A�QcO��AdRC�9��9?8H��m�gx���7d�Q'KqC#ж9|�.[{�0<��:�]qz�0Gz"?D�R��<�O�f'���p' C����/�g��	��t��c����c�z�߶�r4d�J�FC�<��[Ȩ�.��1Ȧ�?�>Rd�a�kI32���(�dQ�8��2��dQ�	􇇯2�w-L�<���>x ��@Q�:5r3��i3RK��Oy�o}��\� ���}2��E����@��ʈLڶr��(r10��cB�cj�����Qt9Ld��|i>k�:׀�*����&�:$��f���]]�/a���QD��m�c$���C�mEˤ�� 0��c����ȉ��k8:�g�i�i+�_�*���b��h�%@����A���7n�1h���R6���P��Lg��t��A��澸�����T�B#��7�|�sG��q��Vq}�1���˗ϒsUA��z�=�R?�6Bk'��V��f�����ܐ>*��Q٧'�P�N�g�a��vҧ��u�2�p�N�_",ES_���Vgm�LG�; oE�14���_�(4�}���A)����0�A8!��E|��"h���^�3谠N]Am�����.����v�OJ��Ϳ<<�eŇXc�~��B�;�j��t���2*�q6����/��XDA����:��#�������h��M�]��-`�M��mR��&���I
�K�(�n�'#8����nV:���O�M]�k\b�슨�Wֻ���\�������?��2�6�y���B
���Ag�I��������9
=����d���J}畮[s���A���\%|��km�|D2�*ĄD�p4�8�_���͢��|'d���E���J�Ӯ��/bc!B�����2+��:B5�*�X �վ��f)���� ���Az~"��p	:��A=�k�پ����C"����>^�o��"����6+zw��<� ^�@h��Gr]��u��ޅA)����:�m�X�(�BB��%���|p:ZOn������!��*K��}D�C�:��n2v�I�jb��<�����`��oH��AlFGb�h+���$�عF���*�UAQ-�|ok!b�[��B�pLyI�|��qe��qo`�cT�ct�R�3"fFNaW���$![�6"� n�֍�`b�j��4 or��>Ϸ'�ϳ�`��#�����8it��ۢnq�E���1P���Ho\�O��DX!&$b�op�e@���JaS�B*�Z��ٙgtk
@��(�Hޯw��i3�_ʋ�-g$.�V�����7S�S��1:���]b��XC�ֵ���DS��SJ~U�9'ĝ�@L��R�7��m��o?	��E��@%��i� � �^��*��=Hpi�Ϥwa��6��9pE%��L��~,����b]Qa�2D	CL��L�4	zI]�"A�`�@��%��|�V���d�:,W�@GDpg�$q�~�F�oĒA�来'9����i�Dd!��ز�x���tO@sD!��{�PO������!��{�|�c��Oò�e�t�����`F�9��w�95��~)��sKH���g�.�	k�����	��y�s��E�Fą����lQ�_�2`u����y/F����{dfXC��c�$�l�`�Q��}.ᮥ����v��*zg�f���wdFu�l��4�Ϫ�Po��˗��� �v�'_��p�8� �be�Wq2���z4x-3O�U�7vdO�/�˳��5��� �w�����M���4R��&�������{]H�mq��5��/V�Ea؎p>��_Nb�];g�J�6�Ȏ�3�B[^l�W���]��������3]U�Ug�X_mC��DlΌ��i'8;T����:�s2:�9�a+�b2�@�Wn�q��'�P�`��u:��z�h�m,\Bee�������7������o��Gj^g��iED�"s���k���t�ɤگS��������K��a.��� WI�לv�D8�(p�W}Ӻ�:�t���H��kd�<UI{a���k]�X�7�h�l+M~9q�?���H�����th�r5�QH�&Ė���ۇ;���^���̬DBxX��E����T��t�,R=������T���e���V�%'�LYFۜ���%V�8�8[�vPM�rÕ�A��Wb�1�����^U0��>ʨ��/���O�To���icR�z�q}��O�'P��
��w��\q��|4` ���;sg5���0�.Z3_�V[$Z�-�x��"�D����g��	�t�`�4ڧM|/KBΌ��6$޴��>�r:)��wH�<y����^ �� ��(��%`XXپ��ՌM�~�(��8ZZihInnẽ�]�^'X����oxg�_�Eؾ��(T����@:K�#��Ҟ6�.����7����}���FlD�ۂv���Z�H:���.2Gaw�gae�]��D�b�s���v먰��đ,ZH�����1���G|~�����^��_��ԶyA���,��Rt��[�n��ᇸ�#�����G�t��S�I+��V�A�A'w��,3�X�؍H���=(O'p�=%pQ���i#t��5:�'��.�Lޤ�A��� "�<ۛwDq۷���|nn,��2��LL�����3g��ə�'gv�1#U.��JR�&����Uh�*D�G\���V>j�yP�SWb�`��f+IE׈k�D�:ؓ+�����c1s �#�h$�
�f��ߧ��E��*h��h{�+�\%�"�_O��/}�(;1Q�w��w5�����PO����w21W�JH?�����W�]�#��#��/�+W�O�}��Is�]E(���ɏt�s_�b��������8H�!����r��w��o�|R#���`-��zi��"��OL�H�t�-a����/Is�Q5�|�r�1���
��i�{���<f �(R>� _G��V}�m��>ˉ����n�ʏ�r�b�_�z���Y�!�h�i�gt��t�0���>3��j�X��}\p0u.d�L�l8�ւ�1fDjDJ���L���n�s�Jn#2Kȗ�{k���G��#k]�ʔ����D�-n�(�    \�
�1�����8��f0u���Q���cɥ���s�����nqg�z��ӛ�G���E@9|Z�v}�/_�ƦF4D��!D��b�^:E��� 4@�}ep���7I���t�`��5�-�Ɓ�Ɉ�u�������5b8"=��|�:�`��9!�f-����o��U&���H��s�I��3<���So��I��rw�X���J�z�.љԞ�h�R�N}�
�r@���̲L��F��
h�h�פ�i\�)�G�fn���14���M�m]�,}rh�!E�/b��t��]#�[��8�\n�x�Y&�F��w�"M��i�TڛI�󛽒!:�~��������Kk�"]�~C#�\,#[�P!�Wݻ�Ȱ�節w�����6v���oA�SS��
7�xlH.�s��I��x��8���9����7g���|�o_�.UwL_6Uhٴ��-� ��S�".�����ߒЈx�4^X{x-lH1Va+Q�*"uv�񪐺Ag�C���[��x�L't�Ҧ�������}f��O�G�o�<j�5�H�\�.>�JQDCRE������� jP�yR)WD1a�7�����%ڥG���zi�[@&������|/?fZ^����dὲj�3�8�Λ�Ֆ���~������l;w������0_������A�Z��<��3�_hb�01b�"-��ǭUA,z�������Z+����w#��GTC?BN�`Y�n�T�cՖ�;��H��üm��f��Z-��s|�5�&�6@l��w��lS�3S�Z���V�>`��i�`S�a̿n��<��Q������/�����l���9�;[S��9ۊ�]���_H۵D^a���2I���9?�
�s��=z�A�1��Ց�u���Q �Y�!���1W쯈��U+b޷��&����|{'hh4$[R���y�zz���A,���`�IXÁ�G��u���ʿ����GyA��#���c�5 '�����\���v�&&���H5�E������h��Eh�c�.�������F�j宵�(�i"SO����r49�$���q��~fY*��&6i\+%�ο�n�E�y���J�Ԧm:DoAk:���iy�F���(՗�I����r^�G�h��f5������5YE�Vĉ��7�Y<��n�u�a�P}�Hs��Γ�U��P�X��:F�E�Ѳ��A�����rT!>AM����7qV�!i�Z�/|O�8V�
��`f-ߠi��Cw�!���}�w�_L�*6	[ۈ-�b��_"'*6+>EK;�%�����x�������O�o�d������^M��G7 k�u)A��/���2φ-��Z��koh ^���9dC��V��ӏBS�S|����FV����%�:��- �ӭ��PѐJ�.wgvJ׊t�������Vx��M�����l���P�Rjȡ�4˃sc��XC"��1�n0�b:|���ȏvY�%�Ȳ?������� ��e]>���?�C824��\t&�3WH�-��j�$<��}�巿����aӢ-}իJ���E�v�N�����!��������x�ǵc��[��쨅�-q��������7�ِJi�ï�<�w6��AW	f��R�V ��ҁz��^�6��V���k���o��C��P��0?DO\5��!�j�7�YL"�o�w��N��\��aJ�q�]�����aU%{�F���~���7��KW���>���}e�GLu*���;L0���R�l��fc\ �t��¿Eȃ����}�{eLCnbD���Ez��"�Ae�@�����l��!;}AL������4�6�5������Bb��!�Mm>M����)��Ͽ��������y�x���ם�A�H�CtZ���9݋5RHȠO/�j_�`5�@v8����=zH�`٭�튽���o��j.���u���?F2�f7�\АZG���:ނ|L�Z����|i"��ӽ�z@�3e��1o: .���������F��Mbد��o��nk=��� vH̠,�H.�:#U@���}�چ^�Vר���Fb�i�a��tUɱ�!\1��N�ߎ�o~_d��4nʲ\��	%�9�D��Uu������Z��%dX�XV���J���)��hz�Z�_�f1��PV���L��jO�����������?�NlQ���K}ݷ�P��8>β���

��&4���H��$ʲ��
QEU:��Z1k�WX~�.�ș�׹�K��/A$��0Ml�������.�{��/�MQ�%M=����b{{���f�>{�|�&�<$�PN	ȓ��v�2�jzC���i�2̑�ˑ����#[�KQ��\���-%C��Xi��GP��A���?���rۈ<=�Hr.�,�c)G�+�dr�7$uο�I�`��T��)�^� v����z:���Px��iDq/!:�����Q���P�+����ݔ�c��@+b~��Aݾ �_�2�K-z��y`�M�b��i�W���EU���a��1,I+I&�[#��kr�^�e5������0��.��K�Kk�Kk]���R�u�O��l������r%�[)Z�)o���:Z��3Er�L�g�³Yf���60S�f&��:�>5<Q�b�`�}��~D}ٯ���_̄��m�{���=w`Yڊ�t����@"B�$/�V�O�'��@�?��"�7�i�����	�SQ�e���7���f�!O�V�k`�5��l��� �SdIPK¥q�G�W�)Eky�7_E8\��,��%����}���2��q'(4�߻�G���1( +]��d�׿���_�����PH��j�pR�aN �R[ἧ� �r�aV)����):9t�Ɩ���v�+���_������N�@� ��e�*:��i��-�
�g�)?�*�M>�A��oC�S��c�=9U�z��4��������aMذ�����|��ݐ7���\�t���m����o��.V2d�TK����S}e+~�P�v�N�����U�.|���ɀQ>c2݁��<��������껍(�+7�s�9��3j*�^tŬ�,�iZȐ�A�-^7s(��� ��wv{�\��ؾ}������!a�
����\o���a1��xJ�6���VW�z`a�0NQirR|K8;SU�i_��?��A���&*����e�w���tO"�M��̙�2��ʤ��G�x�3���~�x`��'��3w>_~�uH�����5m����f���t#b8�
#�
�侔�Is�TP�/�O�e1me��a�MTdŷV�Iw	��#1�fp8q�����Nz(Q1��ֲ���7b�H�����yx�4�B��pKRaS�[�`�=K�6��/��]4������Aae��쁳h�,�M�
�w�����<\4<�o��0h�,�b�Nr���üCN"���S�f�9	$�S��̷����G�����vd(tD�/>�����<�H�b�0�%_��=g�?T�뿐�䰩wt�j�<O�����3��0��QEfl{XZ�K:G�xG|��1��S�uwq�=�R<�R�ҵ�	���'袧�?�ZG�!��J]%n}v�
��N���qsL�N��%%��F9=��V���"*1��C�ɖ�p��
��[Q���<���ܛ7�.G%^�\�*�Z��ͦ4v>F-[9��h�?|���K`�L,]��i�h� ��"���1֮��U_9Ehi2�{�ڳ�%��0�0k�5z���5����^�8j8=I�9I�Ґ/z��x�LD�vT���;8?��l[*�����%�;ڃ��k �����t���z�颗��6�7��|ÈA=������;�H'��Q�U�n��r���nw@Z���{�i��^>��s��E`�E�u��j�J�7q��U G)����6l�oЮ���#��������b�FA^������!������$���g=LZ���ǈVg���o����|������us6���t�Z��v�    �X~�݌�����|��^���:���Ҷ��^c�]5G#��;���y2��<f�����(��ˈ�>�������ܤ�˟tu���Q-�[�(�t{U�X|�(�W~���'@�����Q��-��{0�Es�0����15s[U��r4(d�]8�y�%�3eMij��pZ#��Ɔ���,�NĚ���za���~��n=]�e֙q���ǌi��n�ߝ@�utˮC���bj���Gӂ����������!�nY��Ur ����&�5�=4������=G��³����-��Z�
ۊ��)���xz��[� �n$V�������t"�k�����K�"��ͨ���|Ja#�̱�7��􀹑��e�8�a7��Њ����f��Oё4��i&��ާxR��E���'�pJZ�ݙz) /�e&̏�|kR1i��}�>��ȡ�� �3D�(����!�� �^iՕN~�f�566Tck5�zޖʡ�a&�,��ɭ�֡�С�M:th�|~8?�i%<yצ���d�n���YӐ��z^�g�3e�~����G��a`�]`��2�[�=(�H=ˈ��pK���OO0�ފg�4���q�
�u!@v�v�=|y���bk�7m �֬o���o��j6s��Ò�Ȏ��!h��t��}�\{̥^\;D���:G�-�&�EӺ�xz$��:�*�~�W�a�|6�p{��"$Қ|�F�����XĒ`����;��&ݕMn�Fv���6�Դ ������I�@�m�Dav��Dlw4Q ���%��$N��%!ri�u �̧rW�H�<P�F�y��!7r�	���f39v5�)��}B�Ejz�(��<��txͨ�8��Q���I�J�O�t��i��Y�a���q�R`�+�b��O@�*��LQ�^���pe��5K�#�ԛ@�0�,D�">��a�z�`���i�d�jK�p(.o5�`lJ5�l[|C���d��T�e�3��Ϻ%��o���x~�G?�m����i=��k&�j�Y	�6D�-
ѲD�y��c3���i�8��7��ft����
�{�x���ĥ��
�&��o���}�X]b��.�X�'��_P�q��82yP۠�!	���&Ü���h�5�qD������k�f���{\*#d��OB��@&m�O��]PS���A[!� �_\d�r��\�mW�8��y;x�7Q��������aS`YSp����2��$ؖ(<�D
ۉ��gA�` o�֬"��������ŷ`K_��e��ƂaHދ�U��d7 �S��꾡f����w���E�i��E�L#����RM�Nf��&N�&*d-�9�FlӮ}�(E���Ю"q��ɼB/aVyA�UM'-Gͭ�U��ڱ&1G�+!�x���_�P�E�mQ��?��I�b�e$�J����2x��������c[C�Ùw^�tI[��/8ǫ��Q��د�V��&Wk(�4<~E)�i��!1&ȷ�GD;�J �o�~�P	I���-d��^�:b+z-��Z��z�sMad�F�����2"����i[O�O3��\;��-��N�珴d�GqX
���c`^}WbTG��D�&�}��x��Rai׵��:�����"��{��s{|�u,�юWS���8����0;s��HHv��n��o���8Ҏ���::e�H��:H�w�*m?����,3>��#ƾ�Ki0��v�E$9'?M��������ڱ�|vhjH����nPD܄
N�bF�,tfk7����ӷ"�ۛ�R�siz�����3�A=k�#2���v�7�m!��nIl��t�.X��*��ڠq7���l"ý�a�o��(�,sLS����"��bA�1��W_)�b!C�nJ���Cȷ?��J�m�y�
4�}h��,�-yA����2������jMڅ�_^?
�&i�t�;M�'��pٹ�N�br�9��C���Itl2���@O>�ٝ���T�Uڴ{�_~��a1�y4���&,r{�D4:�����DG6R��ع�W�7uH5�(�v\D$����'Jy`��b`��N{ ��-�I��-M据Gdlȼ�[�r�0GaG���C���XX[���>�<�?ˉ��%:�q�H�^k������� O���8���U�
��_wk�:� ��8	��jN�����*:(~@�0zh��> ���e�&��]����O����B�:m���U�s�{H
P�zݳ۲��ȫ��e�'���p"k�>/��ݫ�".澿�{:qȰ�
�Avk�H8��FA� �!�H�3e �0Y��0O.<T�]�~v�ev"K������Y8l�g��Ĥv	����G�T��+����d1��'1����@G��j>���V�[��kO>���]���5:�=8�}e+��>�L<?	*����ϧ/��6:������-�A�#�N'���� l/��C�7Y��RR��>�b	�V_��w��IJBXH,�C`.39e��9�b��8]h�e)>td�{��s �Q6X��]@Ib���K!{��������ݏ~�0Ю�� ޗ5��0ܑ�Y�2ܭ����%-=�5WW1d5�!27�G�"��G�7�Y=��ׯ���Wg���B�l�\e,GM��f�o�x+b$�ЉU�yq�cYr��qq j1�(>w���K�L�cWK�xu[�^i��5
�E�vQ8��vt�r��ם�������;����	)_�2�C�7��/�EtgsX�l4���\�T��n���!�N��R�����9���X�Dfw�7�������H�.��r��2�]Y����]���YV��N����ޱaZO]Z�'�S+2-��[ĕ;W�u�{M����B�����A!�ȣ*�@F6vuU�$I�"�+D��oi���]W]�菘w�Z����0N�.N��u�⭇%�v�Ħ����8����,}J�=!�+��A���t�*��r���5P��"}���.l�%!� �MM�{~z���!Ì�ؓ^ne&�r��6�GH�l�[,��?qkY��N��Uf��h梱��re�w[�O�g��r�1��ɻ���A��m�Ϳ�c���������B-�D1K�S�O��坂�.v��ʿ��Ҟ;�l�6m@5 m�Y��l̤̞]C��l% ̬ý#?���7B��B
��n|t5v��5s�Ǥ��n�gnN��x���Pf�h��k�X�P�sN�Qb��F����;ش�Q�,�ٚ�ncG.�- l����<�@��tէ�%+�\�E��C-�8�Q�9��GPB���bn�2��"��'�s�a�{ǆ#����_�ƨ82K_����
��ݫ�
Rg�^A�/v������VE�:�`-�0��3��a#�l�^�_J�O"�A6��tW�/���3`Ns�m�|y5�˰�S��Ӄ�[@�2��!.���A;CȺ�2�ŵU�?�*C|����|x�&�H�b����d�]����e�װ���� ���U�(����)��=3ȳH(m��N�v�u�����gIg��+�[�C7Y���hvP�ы�pX�)�������5��S��bdql����?���\ôfa:'��o�=H@���[�����5�t������eA�x� ���emx/�
}Y^ߙ���eȇ���C�k�K�cG�4�k�ҏ�tk���<�|�N�[L���ޥѥ�`r�>-�������c�=��?Ҷ����>�xآFᣢv�m����얮ŕ��k1C��0'��Um�ѥ����匸d�e�E��gP��0�s�Х,���	!_�i�Z�3&���pbW3j����78�?��0#�|-�x���S����D��6��N2 ZH�fZ�5�ΏNGM�k�),E�\9	��mΌ�8!!�i	�]�O�F����Э�f|�t�%N�;;�c5�:;�ep�> p��9�v�p�s��c�<��m��D��<z��q�hM  f2�]�;,�Z��?����bv �9մ�3$�2�0CO.���1f�p+�_�"����t	|� R��    S����f|�X1;�9Os�#�3�M��`Ƙ>q�I>���0tH��FQ��s�����+��WƘ.&5�<Q沈yB�1g;	9����
$3�'���~����O�xP9�$�B�C3jD�aedb�x�b���I�����8'ƭE�^��[�5� �[6���
W���m���3�q��2���ݽ�v��x��V�,��T#���D��?���l��|�n�,_���x�o�#�����Y�4�؅��:�<<������c���z��|���(�C"cY~��-�~�1h"��	��f�����B�'cY�d盁�0�d���fĦ9yA�a>�]>�~R��~烳g�����MǮ������|#�3�un1ڽ;0qOf,�!*��I���ԈC�$cY���ԧ��ߠ����3���t��Ӌh�!���}3>K�긮*���l�����'�����j��'��[+�SB��\��޸*b��d�f�L�Q)Nyݴ����s8�mKa�7�93��,����PG��9K��ܲ=� 3��Z��oy:�29A��\Í6����Zڊn�iY�NO�O�:��iM��4tl��N7gP�]~?�ڳ$x%��[/'���,n=_��w��<{\�
�8f�i18L�U*�US� B
�v3���A~�r��޵���[�v�1b"H��ܬ|���-�1���Ʌ��KDteŘ��έ�0�x������o�Bz��XzV�~���/��B�}޽pE�V�c1z�w���P>i�{,�=�b��H���5\q4;��kI�`��F~s^��'l�������ң��[ *�XtW���v�F�A� �0�L�����b�6D���3����Q�r�p�{�x�Ώ]�U)<ж�!��o���_?���+'yl�gm��G�=��	����n�s�bYl�gSޑf�[L=h�
d��y�{�C�a��<�M�Z�]�.x�z$&L���6��t{߀��
�i���`^��Z�������!�B�;f������u��2�a�C�ϓ���{�W{�����ኗZ_�顱]�t�:u��Z��i���w���Z��XO�C���z�Խ��	S�PM<���1z'r����/������L�"��\��d߉��yn���I89��`b��]�,�`����t����Y)G�K`���C��z0%ͤŠb
4<�z�֐;�DA.n>E�v6�R2y���4GT�~����;��q:x�obW2E78q*M�+��2| �x 8�������;N���盬��$⢾)'�������������ϰ�]��G�o����9�	���D������[r���F���
٘qZ[��l
��a�!��q����(�c�	����^E�P�H�����|/�_��z�����S1����u�ӗ'NN����]��t��N\�I������~QԨ����we�Y�0İS��9e��
lbX�*����� �	��)o0]�x0�K�&\8sj��b�se"��u�E5�-�uKxG�(���i�� _�;�;��:��C>ǥ���5m|��͔��R��&�����~��=��i1����9 �{\:�:��e"kfզ��t�V���������E��׼���ǔ����C!�ݱ9�jd}B��c��)iڂo��l��a��[��m9�1���G����m�y��SD*�������z��?�*L�F��E���{�E�����qj)6��	�1�G�K�h�XjY]��قF �gԗϋ���/��ۯ3,�����G�޴�W��_��a@�4�@�a�K,������t���&�,�EP}5����_��o�r�0�D�RF���<���a�x�n��n}u�l����'nn�fe�^f�}s�a�3$!*<$k/�������έ�4���ղ\'Y�X�t\��ko9P��Bҥ�Ī�L�9��R�
�A<���Դ��3�K�9�������۩��e$�6��J�A&��*�hZ2��g�?=p.B�G��bu�ǚ{��u�^\�0_�)�9_��]����p����KWzd��k���v�����$`�-->�Ҵ�\�.�~��T\ Q$����LT3I�(3ڥˌih���AY� ;����.���Nt�Q��K��2:��p��䩥�ը]����p���.}*_F�@��0gh��<.�y�i�֊�:��cX�C����3!��;3�~!��Ke�u�9[�'�??����A���)ޕ���G�봶C^���K������w^5A����:*���j*�:�{�ȷS��!t8�S�>���8
\p��bfM=�^6��?��7�)(�ۅU�Y>�Z��e-��B������=hH�bU�h-���|�.��mE.��(�/�|�$�EȖa[��ˏ�+�E=���d��x�?��ߞ����'�b�-S���[�hRV�{�'D?�K����������q�0���0��:a�?|N*�-�S(�M�5����|�;ޕ[�}g���7BR��+1y���h�����/��ajYm�u3��c�SR�&\~L5s�/⟀��*�%X��_�d�_��(�.,?������G_`�Вڐ�/q���2�Z�܍��N�L�y��������VG9bR�be�	���$T�p�,4��2�Ƶ��r1��S��e�FF6y��;�bS�Nx١mH�c[
�px������-�xrh� ��䣰-�ŵ�f��A�$^
�3���w�,y<}"�^���B��l�g��V��H���k�ӻ���9�oV3c��;������i�5��c[���+��������_�jK#���"�ۏ��_8^��e���N2;4x�^7��ɭ�i��f�R�܍��8����An!�����,�7�D��>����}[���� � p�o�_ bȒ`MW���������E~�O� P,�c���Y�ɕ mT����R�������5*w�a�ּ2�|,��F����O�*�~�}�?��g����e�����3pik�ӗϷ�I��i�M�/�o��%�� �3� �h�}gF�J�*��ah6<_��7��`�W[���� �<�.�tg�W��/3T����0��a����#TCk{�I��������f��[LUܶ��`>1�Y���ے��+�%J'N�S�;�̮�q�r�����놿-pt%�W�;90P�蛾#ӋI�`���o�U�
���s���>�ދ�HȚa-�=.��
i�FQ�RJ��^�XK2I��3$ ��x��L*�f����(�`Y?���:B �o��o=K�U~�1��,L�;֓���F�y0�Y�cnS!�z.��g���	�,�.d&���3��
C�;�w�w���~zy�;z��ܺ����	-#���H~}.�y����SoeXt8Vt���\�E!�s�l3������8HMb]��sּ� �d!�z��:��t�6`F�]F�T�ո\�as(.o��c+G9�%�<��FuOҗadv]d�V���7[B�˛mb����n�W��8�:�:Fj��a�J� k�Wȶ��*<�_S���ݓ��`�6]��yu|f��4�`,�i�*���|tZ�'�=d?���Oa�,S�n/\ dhe�a����+����+�^��lT�)�����3����/W�&��H0��ǂ�-'(�+�æg����ݝL����\��������: ;�U�N��r�L_�.a���iR�`V�T�����l��7r�	rY�唘��kR�ώ�� z��L�J$�wS�pE�
z ����Uh��2��D�-ۺ��i\���AE���U\��Ay�ၾ]YG�hW�]���j���;��]����?�ٚ������0�O����ʓ<]3��E#k�:��,�-@�ٝ;�/��0z�>z�����K�S��T�����~���|ql��!���}v	��׫��rg�I�����a��a��]�ѣp��ǭ עnrt�r��C6�Y    	�'5v�N�0���yE������v��(�� ���E������cˠ�SO9t}+������;	l={	#Nxɠ�*G�Ƚu}� �P�2���!׳���L�h#B�]�F��b�S~r�#�wY�k_�eu̿S���Ԏ(��U��3��xHUbC�ӕ�t-�1�W��\�(?�+�܂pk@�&�����"pK�C'�r�/����	@"�!��~����}éHQ�_<Qn_����ϨH��6�A�,	1������֫8K�`׍���������N^Ѷ�z�1�:	�,es��P�o���F��#���J���Ff�5�����ސ}���� ���Nh`i�@����\���|�MF�g}N�N����0�+�۾l��V4�����Ձ��'�ն����K�D:"���ھ��$�!3���;��,��U�s�<�9=z�� 9n� 2�@!Ye�~����-��(��������tǫ(X�FV��Xx�y���w
d�/��egy{y��Ù#�91��8:bt(U3z,�ʬ�|�0�L����2wż7�ś-�p^�{S��������M�ĳLz���Ɖ;CN��b��kO�?
%?I�ld�o�zX:E�*��V��;�?Ș��ȫ�����ICș�@v��Kf��%����$7]��2c �
�t��o�|?=�9i���6�}��8O��&>NܺI�Q�ݮN)��=d��ɰ�0��]��ߟ��3������������?�p�/�nǽ�į��yf̄Yq>y���;s�Oaˌ6\�g趍��<�,�$�ZD*���#�~ ٷŖ�h�� ��B�%��H(d�#ɚ1d�tY}Y��(И��3�{�ziS?�-½�EVפ�3dA�(K��g��2�D�m� !k~�M�zQmb�v~���r���z��«�PW�l��P�+��N��Z�,cgo�0K��ڣ��r�|Q �Ҽ�����e ��"{V��ܜ��">G�]��}_>���\�X����̹y��j����L���{C^����甈Ф(h�O�nA��sOSmߝy�� n�S䒷q��<��2��^��t
C�7Y��	����[��Y&+�����&�n��#��?������n_����1DѽpC�:ux��ڛ�0&d|%��WN��z���g�1���r���!��[:���ӸgЪ����m��o_�۳\�����/���!N������:����e�CǮf��|�yR:���:��� ٨���X���f�x�'A��!��[�TC���G�Dր��ʭjE�F%�[XI�����:�p���b��#X{�ϧ��G�=���-�;��1�P�&R�Z�~:���Ò���/�Ҩ=pۗsfNw��4>�X1G��6�IL\Kb�왅��Ǉ&!���ցHm�r�!Y�k�zB��`�a��U~�1�MXO3ك�XI:�aZ^zH��Z�/B< zb�VP+~,Z�jez�-�r�_��Ҟ��,;��v�3�B̖��ǌ�?	�0ʵT%��~����
�8'�(���מ~z<��sO̝��dw^>�qwV���|���+���b��C�����������Ok�}_\C������A��ҕ�wi�R>6���ïO�m����ߟ�ɳ��N�p1��=��i$T�.l�v-��<$�pZ��7,xeo���-V�kA@�͘��<R��
��%�*�B�]���qVfX�s�ӏ���,o�ey�����J�
�ѩ����>�6,DLqj鞘�-�0�LkĤ�t�k�g��·��7W |sf�.b�����篧ne�������Κ���q\ۯ�n�|vO�wB|�C���,mGo��>��e�x�(?�s�>�Бb혙�[o��iO��o+d!�͝�	{Hz�LWđh�LU��F�M(�������>�%1H���~#�o���)��[=E/pf��^�Fd�q��3�g�P1��.K}�@!D��zi�Ӡ��B�<�y%�<�>M�yw ��h�?�	�����)^y-P��-� �0��-!�6ã�w��}~�����:�e�S�����'&�DQ���k(��!-�3���g�����7�2o��n��g�#@gx�1�F�$�ф���Ҍ��J���Y6�IddFS�<t(�RE+Cj����2w�w~D���0cvBNR�x^��V�/�K��C�}�a}wX�Z���6<(	��w��\o�S>�޽[Chv�,�~�+5�2_	?.�5dˈ/B�C^)g��#����q�
Ԭr�g/ҧUs��9��WC��B���*q���?��\�l+�Y����v�.^_+��c���Oqs�Q���JK�erX�Y�{���O��>����i(���-k�F$�)Ŭ=�(���K]���.�=��0HE�����Ǭm|��lȖ��l��Lr۰�M��]�3���n$�I�tR��q�(Lvj��R��C�.g�|�՜��g8jY�3��&�#��{5�p�K�$X���W��@�E�G��@��C&,g�oO�ַ�z�5�+�MS��@���[���.⎨뫩�fD��]����M���$H�Y�Z?
|���S˞E��TXαB��~
;qШ�"^��fI�|c��O�&y)�[��k��{7�y����耈)�V��t����w9�?I�G��i�B�r���/��)x�뢴�O+=ir����6^���!w�s����σ��	�T�2�Y�9�ǥ�|�q�I��I#��C��p扽MTvY.b��
:Ȱ�p]�1-"�"Yr��x{]iV :�0�9��.��������Z!��p�Z�iD#���շ���������c�n�u�VX�+��)���X�O�N��?��[�@F�y��o
�+�F!O|��gfVHm��鑽|fk"�,j��ɘ;��ent�Qo�a�@c�g1p��s��]�5�Q��d����5��q��2�N�5xGC«������څ.�e����������]Υ�]m��x��ď�$�r��L��
=P����K_��Ҷŋ�[�� ���}v$m<�o��5�N4�瑸E��Ĝ�n۝�yc�,.��?�k�uQ��'k�7JhZ�'��|�wd�mưr�lY���/��b� a�,$�I�1�K?X�+��|
d�=��B:@�X�?�6� �D�� R��T!���;���(W��ᕷ��[L�<]>mC��U=@�.绺)[~64���w�X�I3_C#��([� ��\`�ZV�Fg7a��=d9R
�8~tG ��
˼\5��-#:��V��m����u`oAD�1WU~��d�+�X�N�J���q�5Y�B.�{�ÇģS �F���@�);����w�����vi�����E��ET_>���K�B�J�,ظ��ދ� �G\�IU����-u6	9;R	�Gt�'=�Ο��O��4.��N����XO�q�˧�t�#@g��'�"BZy�1X�oB��1�D-����uK��-/�V���wi���ی�CG1����!���RӸؿ{�+ ��i=Ռ2���j�ϧ�N�3L*�%���فk�W��5rW%jg�1�nT^vнo��=���j���QzA�Z��Uul6��~Q����i�^�ѹ�L2�xG~�(���������2��c_?�9_�����������l�É_�9f�ڼ��,Z53�������|@)�\�w&�J�wd0P�t\a�����w���O��Q.�=���_�J�2�KXt�H�ƿn4	7�5?Կ��OsQR�3�vKYoEi��l^�f��^�Ƚ�f��SEk�+t]���w���f�dz'����Vg�<��Ț�~��*a��%�%ˌ��4a���i�Bƶ�ōin���p�� IO��q���^�������CW)��+�ϧ�Z���arM<�4ނ�5;f�F�i''~y�t���������.f.���G�w/���uUq壸���7˿O���/��Ʉ��F58
�vi�?�<�H.�f    zEN�{�� 3�N��;o��Y��H!�.	��<du����l�21��?��ɀK�ԕb1N/1l�6�ւkQp���O�7z��+]���Rp3(RH	R/ �kH\?�>�pm� Y����K�گ�l��t��^�q���w����0~ai3��\17Y������m
d%b6���|6o� 6���U�Ik7ֆ�MtF�cHC�����o�?�sO������ E�>
|�,�w���~}#� ��ķ�񝛥Hm ���
�X �i�	�(1��&��g6���\��G�M������ח{�I?|K�A�&�(V��q�e������������;�� I�|KrD�'��CçB�I�EѴИez?|�#oHr�V�ɧ�y<�&�N����=���a7�"��]��/�҉MN㾜�"#m)��G?�]���¡a�Ԓ<�w!o�L~��[v��a�m1J�ytW�9q�� Il�� ';x&��o�@A�~�L�~�ҷ��Rx8@j#�R�+O���z�?(4�-A�+��&��%`��<$t�-�[�K&k��A\-O~�Ⱥ�(Ē$���13@�5�v���Ƞ�&�[��J`qͫ��I��x�u���-��k�����ߢ;,9�
Ĥ&�/�=�>��b�<���Y$�L	R KJ��9�Jo[��q�p5��� s!�g�+:B�lg�~����� ����L�a��"�:Tyf���v����	|�����<������3��7��\�<�׀�D�U��>�<�6�Iy�J���ء_���(�cP��(~���d;򚕢��qm���vU%��[7�� uC27���B��(�u�� ����(*�4u�M؆�;��H��.�i��a��(Z�~A�P���y��$!ð�Y�)�����Z�^�U%T�0�H���Y>AV�YC8Rp;��m6/f��v�kp&�� !s��,揲"����_~��S�J��jj`��<�:����|+5��򇃞�Kr���H�Q|��v�E��0C~,o��7T�ye�����Ij�2\ӡھ�u��Đ5�V���F#.���+���S"���٦w�NwB��R�!̾�1D^>Y��n�﹝u��=沦��I�� ��e���� -�Z�\#A�pO�ō���㰡5���u�K#b��^���֒BƲ��|ƅ�%�t�/��J���@ӣ�ԉف�o�������Y����s�Y����2�r� x��7��m26y�3��ylԴ�ȡ� ���O/�����VL� ��,-�����2Kֽ�I�Zo�Y~��dʛ����|���xPy��M-����s��=|��ް�e��ģ��˙��S�M�!��R�v�Ď�j ���
�D�7@\�u����Y�ސ�[�Ƿ��8#��C�/%�U�*��%_oAȀ��e��H+�����,�k1�q�&�Wy�/ͽ��2zV>p�p<�)V�H)���tS�ɧ
�����fP�un˻:nk���7�o4kX�<��1���4��KzX#�����e�ٜOI���p�G2�����J��!p��K#��׿�z�5X*W"z�^�����wa`��_I�wY�Aٔqkл��51�e{@�x�[V���h�Z�c�^��T��l��w �v��
����,WI�y9�Y�8z��m�����j���Nc�:B�꠽Ƚg�9��þم��(i�!p,�<�t�_~ �BN� ��wl���+v��X���^������<�CJ�z;S4Ύ�к¯��(Q	�l�q����;6��k�`�R^ [�uZe��-��#�𞵍v�mL�o�b���7�1��A�^H����W������'_[9��O����/�y�|,�u�(�ͽ��NB�ٙ%����e}�gQR�x�ڱ���AẁF۽4[�����˥־_�9pXL9VL��6� �Z������{oˊ�G��g�H��-���}E��dc�G݋�6
�5
v~�b��b*h�D�^��<���Id�gs{u\�<�������,?̼<���B���޳u�IB���>Ӹ��.ⓤ��}����u`n��gׇrW��ꏱ���;ɠ���K��.�ذj�o{7��^
Z�R�s ��s\���KQ�|��RM��k�t���n�����C{���,�"d�7��T�Y���t����*��t'�n"�j��26·��0;f�^?��~D����a�,Z_�Yդ�uSш�1�;`�%ƻ�tgH��C׾��u���.���K�k"�`�U~��)�d��'>�K��Ç���Lyn�K7�.j�r��?� ����5��;�^��5T�8����R� 6���Ob�C���v����[��Q������V�&tF��g_ǽ	J>��E>���Ϸ�_�vu�t3>����S��zP�塘���D84g/�/g��!ٌ����Rwȃ�h֗P��F| U��!·.��@ZB�^;�.�~�7��
p�d��vl�=9S��->*{J9�R���u�͑ᥭ���:;��4v�i>G��v6��p�;\�aT��j�G6��޾�����wt�;��|�S��]v���S�DHE�#G�kWCv�CϾ ��S\�\gZ�G: h�Ûg��<�wiC^	٩��@oK)�t�c�~��~,�J�JUrFx���c���b���-���){�D�zcq���0����T{R��d����B*���G� �
�9�ϥ��8�3D?�j���`�>�S�hʢ��K=zz������M�Y!=)��H)�c��Yl?��u|�����D��W��|KW������#5��hb] {>bO�<�.?Pž{�0#��1�&���3l�fVD�0���-%ޟ�Μ8B�'c��M>t�F%y�� 1�m�NoEwap�]p�B-`tPR3��k�Ӊz-HT�[�*r��~�>L�/椥M�&(��"���]F�ŏ� �)��0�в��&���4'����$jX�%}$�1�Ҫ�����O.���j뗇���6Bb!�,m���
M#�?T�^��jc2�.��?�1Am��KQ�UXRO��z�@_��uG6q���) �'H��4��ju�R "B�)�ROU��C.ɮ[�h{� �o�m� r��c�=�H�<�ׁ�P��b{g�Ŏ�`�qp@�4z5O��6��U�6��T7ݏ����RzX��>�$W!9&��vdũ�Ӫr��u�zI�Z޴�bH�5X�QG�U��+��ߺ����ad�f��ۈk���V��-/E���e��gnkH���#m߃$�;�=��桁�1#7��kMr���g����С�x$�d�PD�s�<�N R���痈�b��	s�&�>(��Š�T����,B ELX��"����K����by��j�{�!�JX��@�*���ѽF���<��G��_�2J�a����	�u��5�q��_!˲�(�v���g(�#���#�?�����b1�Ʀ�t��Ɛ:((�Ϊ��U5vkf�;�LC-�g?�$dK�}q��$�g�p2�&����c��o[Hx�����3wXq(6D�M������!۹uflgT����pH^�� 3��ei�Aj9�3�jA�I�_�Gk9��D7A�n`��,�#�މIH��2͖г	���!�.TG�̽��p�\^�e[�Žc3ֻ�"v� HP��x��� �Fu98��f�~�й6�ԓ��m�g�Z�idB�wr/2B�٠Xe:K�I���h�eb'*�\*՗��o�ogΛ!�FЬ)ξ�T�ztfD谙]Am%ꇳ��A.����G����Yi��V�;�+�.<3���)A�f����Uux��� f��^8��Uִ��C�pJ���X>��o���q*!�[�}��n0~�1�꣐.�<r�d�e�]���*�l/�.�1�?�{�s���(�����Q����WT�H�=�;NC�lߙ+��������0{h�v9��ԝ����.�l5�& 0�����K���ȏM,�z����d��Ng�B���Y^�R�U��4���Hy��9    ���H�ts�D�y�G�Z�+�a�v�<�m�<hh<��9��bƍ�!�Pм���P7i�A����e�
YE�	o��R��h� 5�;x-����EL@\��h����ͪ����n6�.�	̅�>��
��yA���Q�����>|8
�ѕ�����w��E ��SAs#_wږ�����g�BYf�	�gP:AB�`X�Kױ��#dT����T���޵*���a*4�?��u����&Z��7��֝4���FYC���a�H��uٰ�S��]>E���N�.f�S2Z��t;8	|��!V�ZL�=?�[8B�3B�`�i�u�S��mA�m�7�e�)��[�u YK�lX�?��۱<�8W�"SѾ�����$�9 �W�]�V</�wÈ3�,_��(G1��0ᖅ�4I&�"�/����O	�r$�.I,���.;�8�G�i<<�0��Mt {�|<�|C3�],O8�5��~گ��]�(��y+d/��>��� d���U��7l���\��J��~�ٱ`f'��c���ʧi�/)Bʇ���k���F��� f�T0�z:P���~��s��s�2���-h�����ж)V?<�h�Q�fVV�Q#�	�)I�����p��ʟ�����s����Ɵ�. h��	���������M��N�)Y_ogtpT��D���UCc�9F�a�H_1n{Hb��1����H�QiƯ�[Dw���$8��<�:�y�����-��:��Z#8�0�?�n&1k~�V6�]����ȁ�T#�� _}����� �E�ueG%��� 2��.�����vp4֭��	Y�3 r�b�~���K�(�!d�����ǺM�iA���ֱ�W�>ʲ�����jm=�����c���;�����UV����:�̐y���G���Y"oi p�i|�it~ʨx� � wc-�<f"������1�R�Ѫ�?�������Y�Ag�� \ՙoؑ}������}3������c���5��H���v�0n�<x������J�,��̇��bD�Rf�i�b'H%k���!��/?�"�����"����:�+8�{I��ݸ&�|>ݝotH���Pvpu�r~:b(���%o�Y߶c���
!t�%Rd���@{�W�edo�Sf���O��>�}���g�`��A{��������9���}����g~>R�;L��yŃ��Z+��.rɚ%����g�����3��%AE���v2t����b0A��YY;"�[|�	jȑ.N+������(������1���E�7�/2�cCW������Uv|��r�hB�i
$�|m���~|Ul��=!tU����1:�/�-��*?f*����7 fu��_���]|l�����J��������]|�q(����y�sn��QDN4$�*͒�}c����W��=!��������#��$K3乽�|��,!��9���r̵���d;z3 ��ł g��V���V@�A:tAz�bq�5�����F��z�%v��C!�����k}�{X�;Q�h:��
�oR�$Aʐ�P��zw	�5��Y��݁����3&��W�]݌�?�>މ6F�'c�z�-��6���^"]HЦ�A�j��8�a�)�犾�?@�o��V�d����E=AҤ�d�ӹ����@[ :�j�]�m73Ȑ�'4�s��U3�η�n���`��>�\*U6�O�.=4w�<O��y�3�O��0��NO��*���j��Ŷj��!&��]�դˑ��*NŁ��t���pZ�	[Bd�Ek_��S�9�Жm���%����.��>I� Bꃸ6W-��Az;� �
��1M��p{���f�GT�>w[�6�8?�y�K�;o����g�5aO,���ԡd�.w��0��)����Ks2qOP	����ާX:NQ׮�n�����SA4����(�$�	�L���ܪ˄�+Š|�Dq'�z!������"�)����=�������"e�����,'L��"$�'�e�f}�y�&��<�-RP��`b�`�Н�p�J]EߤA�O�XR���G	��Bb�o�4s�tw4!�܁A����F�}��@H`��1��Y�5�K�:��R�-�Ƨd�K�T$.�k,s�b���I����0�$��47��Fx4rꌬGdJ�����p��c����Ali'H6RW���N�"~���j���h��[xt�w���g�f J\�d��m��ށ�Q�w�m���K�`���#.�������^�!ԆXf�:�C�;�� _D\X'6�a~�/ЈF���uۂIȨ!�K�����[*SB�@̰��웼	K�D5$^.���&��{`F	P��� hXz��6;�O2<툆%@?���:�E�H�"�я�v��g�L Q\�@g���O�`f8�+�r�"\�ңt�v!�d��p�Z1��"F��+����.�@Ȑ"*0eh�7�����漷,|���ܮl�r�Q8$�����D�9OnW���f%俍,�y<I��$N� %��:�te066������"e-�N�������Cn��X�":W)q�`�a��rŶe����?AΖ�Xg��&D��߰:�3��,*�4�������tj�����q��⵱�͠S!i@9���M��}_��;tl�:�<]���*���F�H�vG�g�tW<�U���yʕEt!+!6��w��6�)�5����W������~_��G�Q3����4�_s�\��<�e���n΢0�G�Q�2//ѣ݂Y���\ΔH�R���ggߟ���bs��8Q�W;h��c4z�#�"����o�
b�E�B 7W�N|Fk�I�c���Q�(���hX����]��<������2�S�e��=p��i,���������;Ayq ���5z��I�ɇ�f�Ǥ�Z��\��Sh{!�
d���F�>�6�)�i�	=�woFa~fa�c���~�>:�fcn[e��c��~.���B'$���x9�W�jng=�s�j��u����za#�z�+Y��'��=w��z�VWA�9ˌ6$'������Z4��#ᇂY䯡n9�ΐ�y�n��x������dr��e��^�<zT�G���g��(ph�M�#���F�U"ZΔ,M w���Dh��¬�����Sr-��2�2YA+��:�޾B���h�G/�;���W��_� f�Dh�KW������;+�}�/��t#oGd���7�W�k�9� ��,��p-y���njxz�����@�:�ѸT��@S�-T�}���	��D�B��V��n؏�S��i�g�a�hX�8�j��ԃio���"ѨJ�U]eI������՛��v��|��G��\��a�g��OO��D�9��.�=OA�1��������������/';�x ����UWЪUG-�=f��-�I��3N��ggu+��������ln!�I�}qE`N��1�*�Y���m��O/�����B��~|�rg5��}�s�[~�-�J1��B��hy���q�C���)�Hк�����C��n`���sp"�9Gϼ�b��2��%�<�`9���kT5��{fp��a�"�b��#�yv/&1����{xG�xo�<j���߉p��-+>�2�7�K@����c��3O㾨y��%<׎���a����N7�V|�)?
�=<#̐c(:�R�n���V:`��0;��vi��8�X��4!ѱ�uꑳ�+q�\����M"��N��c��?��.�,��9 ��m�U��mtM x��5iy�G��:L1�K1:M���b?��(���l���\2cI��*:�bFb,o�� ��&=������YƱI�|ٴ�m�-�Q�{W��@)A��X��h;ԃ�Z�c<��ko
&GS��f��C��v�
�5�~U�h��Æ��u�f�d��Q����c�_�){=���}�2�&o�;̃US�����s[�Qw�z�,�w!/� gt��o���Ǡأ���w���wՁ��	��    0��.��7�+Z}����}���g����cz��+��+�:,�����r� �{�"�k�����~9}e}�:L�M'�q|�����1�!�뎙���&����<���+�H�f^�x0�F�pk�݆�C3j��X[���b���cn2��y�����N��2(��J��ks��?I:������&�t%�.�S�}���B{ \�E�t�D�ڮ�~�]�d�#}����\$�"T�5��09���K���A��>h�$D�F�Bv��r�e��c�v�0�x֎�eJ��E<�J�"�ݚ�� dH��۲���o���?ÈX���5�7~�w9:�.!��	��[7�r6��C�h�ڳ���35,G뿢�ö�a�\�z�G�C��aVw]Vw�7�F5�+0�9�}��b�uj9����K��g���j��T[�u�e?,� sLܘc��<*O��;���^�H���"���F4����_�����I���E�"�$n� t�by�B�.笄�==�Y�c��r#?���үč~�p?�N��C܁�un]Wq.&G��oL&���&�p�p��;-��D�$�*�5���G`!��6��m�y{܌�|I��]��w'��wA���{����Kہ���2��.��$,m[��<ʾ�!kL�Xc
���Ӡ)�n�FxG�v�[�Uj"�(�yf�T~�q�Z1簜$f��>��?sƕ��9t�ع�13g�s�L�0���a�q�>.;]�'V!�A&n�7���{��Hw6�� ��t=��@>����1L�10ϸb��b�E����<V��<���̣4d����v��u��qj��Ë0�΁p'C�~z�ֆ�.�x��?lm7��B	�i�5�6�A�k|;��|�~ڨ��9ъK�Cc�?�e�	��}�"_�ݤ�J7�U����7n��E�V�1|Z��/m#�/�B6�ݛ����{6��!�{K�{���$w���3[!�o�ʈ�.[y~a�k~M>?p���1�NSW���-�ޣ��[Դg!=��F.��ҹ4%�Y~�'F���h���\�]����' �w��NZ��㖫C`էU��CNnE�����w�w�X�$j1�@2<<(��+���\���m=���x�g�"��u��t���i^Ǣ���$jf��/��ty<}�z�z���I���2�<y�_�+��Ȕ�I�q[ y,a�GE�4��%M��X������(�oK��\a��
�i�¹s��I�7� �5w��9�|~)�gS^25������i�D�ysV;��^t��({3�=��_�$�Zt煓��=7p�`S�e�ePYQyn	��/�y��f�ͥ�1`�����i��p�V�0�є���M#T�]Ov��/����民O��OW�+T�f�
mn�*B؜��5�C���$����5d7/'�"����vu�G�@z�8l�R�*v~hץV��Pmi�H�׼쁽���c��������ʀ�(����t�I��B�Ø����#�n��!��I&!עa3t}��� ��yi�l��@���q��Dl��p�#k��(����4���`X6~]K���x�p�CM,�T?�p�|���׬�â�0]���c3�}z�x���I�2��։rv�2�_�{OG�[/q�pw��|��q���1�W' �O�b=������"�u3�+g�!'TR}����U�f�aҷ�O����#�wX#*Ŭ~�*��qGX��3��>z���;	�����]�bz\�)"�+� �9�>3ܐ�#��Yt��@U����������%y���rxsл��&���V���j�s.�Ne`�ED�@��.�,�)t��¸��u	ez_��$�� �a{g�|����Ow�ϧ�ar�o�w�X)ڄK��eXh�^~394�r�?��'s��Y�x����oܙ!�V�]�4v�¶��h�V��EMh���yO��iW�׍C��_�_�����6�����������v��@�X,���#��J$�n�	��瘡(�"ρ�*�xȨP�7dTʅ�Z]�ѻ�� �kd7�
:�~M|�:t�ԃ��;`��"ԅ�2E�����(r�,}Rx��΂ /},dUk�q�BO�|��yǛ��'~��S�q��܅�B��.�%vfk�#������+1�$:X"̌�"�uCm�о���Lgޱ�؛J��s�Xţ2'�\�<�)��"q11̒�ǰ����݆s��4+�����ښ�������0���6�l�0�W����;�]��FG����5r�>�������`�;Y0���sʠ7T�~ h�V�_�������2}߀-?;���-����"p�Y����{S,���;��a�����\%u/��dsY�?c0�w/O��p�׏�4�\&�I�
��� �M�G��8~?.��{%� t+�۽�(���ލ±�~؛y�E�	�ܗ���[�lK��G��=�$j�Jݲ@�5�Ȩ����8��n�q��lG��G]��p�^Z9���b��{��)]|/�SS)�!)e�cI��]�H����K�W�=�o�S�a~?���.`�c-l���Z�dä��4����tZmO@���hl���t�	��%o��{�Y��Rג��П��)��6��Wu�V�N��X�}8���x���<V[M���U~�I!�8�UQ�ټc���ͼl�w�ICT�<��#�y�}����^@�0ߋ��Z�	�/�6!lT �o��?�o�'��!��-WY&���\�W�S�:Y!b'��/�a���Q ���� E����+`�HB�q��RB�~P���#S2(z��E����&��=/l��h�}��k%8w2����V���r������8~�X��l����� �09��k��A��f��\fkR]1u�šd�x��;�j?RZ����LeG�U-
�*f���am�Ѡ�44��{��p5N��@�D<�y�	�͌�� r���*��c�`;\vū|�޲Մz`t�E��3h�2Z��	nT�I��)���̞)٥/w]��{�p���0���A�Wb��;ϔW�sI��A�|z�mhb6�ӫ�r�З�fT��tֶا��<��R�������^��-�r(�� ��y���R|snҚ*�E|@}�@3k0�O!����i�.��x-�v�;�B�5�����ʘ Ù��gXe~�xH�\�C�h�GyHA�~�X�/!V[SQm���B+i�GH���/mi�c��ޖD��"B:ȵ9�4������p�_�m�+դf���fF�7�U%�Q����m%y��X��p���]@�}z�����?��t���^��|��Y:������o��	�4����Y'�f�Ö0;����Ę�k��5L f����������E��H	��:���o����|��_('���82�6�ڵ���>���@v]�O/w*ǃw�8��C��;a���[,�F�-�/�qfa$̺�����n��-[6 �Y#G�#�)����}�C�e>u<TW,�(�����q�6�Ľ+�Q��1d�1$p�&ĕ)k�����O����Ƈ��6hD�{�AS�(�J�'��k�ڰY&���t�ا⑼��]��+�d��C \h))��P�1��f�9�ăM@^g핁���1��=��)r��Ou&aM>z�b7$#��#��)���͐���#>t����A�#hs��*�{�׽�t$$U�����Q��v���"��y�{������`������b��m��WG����@�#_DC��2~���?��kV��z-���O~�D�h�_e�-�f�\}���E��J��r�n2��i�+	�{ �7�yP�K��*��O����R�cbc��1<{6�r%4��@���}><��h�E�~d��E:}�,��A�&#��f�$p� ����hm�H�p���Wr��Ϳ��W*?��g�E7����2ƵH$�|���i�BǸH��6Þ�됁O~f�H�k�\�2�ʃ��]�uѕ�����߿��U�2�� �\�q�Ij�x\KP�o-�ܟ9?� ;  �A3�*��;���g��<�o������Qz3�3�cX"hĜBk�
82h�<���Y�����n�����Wu�
�:g��Ø:w��@&-?Kw�:mv�5���}�6_��O�=�{��j���ս�w%Nn�t����e7��g~wO�yh_�)|D������� ���ó��ڏb)��l�U?���f��D!ݚ�e�a�����jg��K7K ��u�А��{vN��]�$h��[�N��.K_-�KE7-����oC�&y�'p�Ǧ�]���.���i�S8Y����/��3�u�xl/Q��y-H��p��de�F:�>7���{�*ʵ�k��	�B<�g��0���O��=P�#O�n�z���� ���,ߘ�s8���i��Y��,y�b)�n�;I�o ��^�q��D\ɐȓ;`�n*����#"���k���U�}��#�#�,0w�'ib��Nl�O�����frc�\L��Ս��������X�����z򺍓�l�3_ :y��DX8��jg�Nb�0�т�Y��4�ף���@3��1��:���9�4�kE`���>�!ߜ�'u�!.&�_�f��7s��#�FU�aâX!�f7i�p���m�Jv!��b$:�5��63"]$��h��x7��^�8b��l#�\LG���ʕBj3bl��YG��vo��׻ןd�;�t�i��z;錐�[\<9�������Ct.���F{=Rm]!��s9��QU"�!
����*��ט9w���͠A�.��m[I=c�%i�p3��@b���;`f�y�Feâ2�4��g�V�/��N �4����h"��HɁ�m��U9�o�\"�&EH��b���,o�RLu˟�?>_��������ψ��ᗻ��0�8���b@�Zd�F��~�͇�I���GBܕ7�l�Q�Ky��b7F��S�=>��*`�T��+�=ck�Jj���.�L����,�R��������i��s�"���kG9�\g���o#"��ڽ���+ek=Ȁue׾�+B��rlge�ܞԭ���и�"�j��ǐ뭻@�����0���vV��DJ�#h�<��ԕ�9�V�w�g���������j�"����+~�$����@Ôò���+��&a�0{�硨�_~Q	4�2 ~df� �4&ȣ�<"3�o�s���=���cx��fD�e;�0O��Yj�z�_�'�fe�`[����g,�X���F��rܫw�ȶԿ�A7������܊	�p�l�������
Z�����^�D%b;���.u�;��nd/��9��K�m��}�*�{��Oz 1E�ZKKǫ�n�%�T�A�������%d"�]�[��Z�X&�6�X���X^y���\�!�3��������Gc���-CFb`�>F3���_vZy� >0������c��r]����:�X��9���+�)����zR$Q�j��Ƭ�9[� �Ơ��^�N��B
p�1D�8�j�$����嬏!�0#z�4q�e��c�'���Kb]t��&�#� n�[�K�n�hi:w0N]�x�8*�G�`ĵ_ C��;�#2�܁/(E1�Y)bA!E	��U�o:����^P����<��7�&�N$�c#J���"b]�ͷ� �^]r���=֧��/_зa�I��;�޹[�Ks��A�="�*7������~G{#�y����S"z"n��P�7��\�M��5�"�+S�d�?�_6�J�@�I$/R ��uSjp�r��M���IЮ�����Z=�t�&��/�.�������Bn�Ӿ��0��Cz��A�M���T�
�a���4�-�Z�֛p�s��r�zR�� nbt/O����<��$Ă2:����z��kQ���B����)�py[	���"�hZ�체���Ȫ�k!�G*���"an(�琖Ʋ:���Y�r n��(0�Ax�G��'ȶ.�� �؊ZtYT��|/�%�"B�b�:�]"F�=��+�n��^1b33Bf� ���$���_'m01��Ҽh&>-���e�CWf#�W�:���H��9<�#?��Wӵ��0�p.AvF�H�e٭S�_��A��QP@&�y����r���<�[KBH�C(�ď�Ű+ �7����7�����s�n yPʎ�c��b�^��7�#%�����N��-�������gZ��N����wǆ�k��K7��8Q�##�r���`3�
�7�LI��"D�3ș��*�\1bQ%%P�x������Zc0x�{�_�e��Sg��V�u"�����^���u��7[�d�A]�}X����/���2��^@�m��N�A�^�D뛂uB�7�8ȍC�n�ܨ�	�<�V�������E�'�`Qֈ���۬�i8�(�y����n��OH����k�)0��΄٪�A�jY�FcZ�V@�e�5_���M���eH���q����h�u���r���Ǹ�����o�0O�B�0JO"JO��.��;L���8.{!���v�N3LK'Q!N��%fķ�0;����3�!���B��߶�zBr���(�W�ŚjG�X0���cd+��:A)A�9��}b�>Q�����L��rs��&wL�U3����Y"��n��s~4���H�
�Yp\��U���*O����nbf)�UM�#ew`�O�ݰ��K��㦏��,�wT7 �M'�ku6;��ҭ
Fs��x�s�@�o@�Y@<�܍+dͯ)��G΄X�ٴ���]����W�Į��SPm���-
8� �J�D��p��˭r
�}N,��órZ�NX��=XW�XV�e��'h}ЭO�ǃ�ųh��J����_r�Z�L4�F�C$#Z�e��+��zH졌C�lR2UWق��u���q�SeĦF�6�؍W;����U��Hm�5qN��H�#n����t}f-!v*��.�-4�t8F�7D��r��{�;b[-Ռ|���뻢�����	��+Hцy.� m��u�=w�e:�9y�͡�5�D����HS�;t��9H�K@��؄��~#�Q��ǈn��fs-�d!�~n���"�vU�ՈX��ď���8qr�"�-b� "���+���+�^��z�ٕmf��3K;iּ1np�+��'�/f�ʙ��A�Z�A������I�w�r/��c��I,�� �m�����*W���*+��^,h'�^cG1�s̍�S䬦ί����
��De<�N;YC!�R�㘛`ƌ���04��79�a�ڱ�X����:�rBs��R�'��&����|v����t��
#�-��.ϊB�[��{.� ���=.-�)0�ȍ|%�`�6�D�잰�wL=e֍Wdkx�xѱ��������sr��%U�����Eܧ$��!7��V�P5*A\���.CzY���ܸ���ZbW\�W�i�)_��{jJ�F���6�ϥ�&ari�\z(�G��3�}����b�
�j�Rm�Ry�c�Q��u�g�9�
_�����޹����-d�	�Fܗ/wx�M�R��j�2<W�^��i�b�`�vD%t����]+/nyѐv�Md
�/�Iू�I�����G��5S�n��V����hk@��M��MU`�}X��Ρ"G�n.&3tidL�rо�5o�E�)!�"�ɢ��P'��埦�g����l�etز�Y#v4��rfRo�$N����D#�n��Jĕ�9"V���V�r��!C�cą��R062*��M�����-$B
r�7
�ǣ�Y!��1��!h�^ig(Q�@��Z.Z~=�N>$$3�
�}��N	�RgG��5�\M����������P���      \   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x������ � �      ^   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
t�w(( �sV���Мաv�rVP1T�y�b�Eɥ�Ǥ򀣰�F"������fx�9��Fǵ�,��0��:�J�_��;�k3/�7@ԇv����F$Z�H��ǤD�3aY$:硲Ht�#c�u�g�����c��]�����"9
��"9J�Oc����ϫ�hǟ�f�<B"��h�/��t� ��v�s�yL�w��y��Ӻ|�(�ަ��!����� w��'q�]���dӟ��N!�Nws���=�h�2���;����o;T��[3-W;*��*a�~�����j|�@�S'�ui"�3��v�����L"�uA�x��㯳Oc��?@����{|(�*��/c{���0�|Ƿ��o��\��}zT�r�bב�~��t���z�]���|�ϋ�7*�<����		��e?�F�A�پ�?���THT�S�:��B*�o�F �Ջ[3�Z^��oّ8ٮ��F!���*V���E/5�}��(�i��|����s����e�ARRl-�9J������2I��|]�T0it��(�fҰd�/���M�n_RMI�#՗Tg��V]R	�K�e��+�Tǩ�J��&�^2��ګ=��V���Իj���W�"SK*,B�!.W�H,� �5!��Lj0����=����R
�r���d\�j,���%�V珅����Jⓥ����e-Q��j���`VK�s�(��d�%p-kP����@=�@	l'�?(���Jb?9���!�ĀJ�CjB%���h��0M,�=H*2�� C�� [��k
;(`�1q��k�i$m�m����_}4& v��E��ޣa�ט� 8 �c�!��1�&�ӑ�|��~[B���w��qA�F"����{�a1@���d$H �m@\��e��6 �cHj4��i7A ����[@H�~���Sr{�W�Rr+�c �%�L������������ �m�ۊ�br���O�8�[��9�A�֊�11E9t���Cs��X�[`#�3S_���^W�ۺ�>�_��@G�����/�o�`      `      x������ � �      a   �   x�u�1�@��1(>;^���tW����_�C;Z9����~�s>>��}������V@7ۀ�b�#g�2���Á�hN����_d�d���/̝xb<���q���b��K�����Ë��c��u�[�-Ŗb�f�v\��`�g4�i�i������~L�P3      b      x������ � �      c      x������ � �      e      x������ � �      f   '  x�e��j�0���}I㋼�.m�v���$�v�o_9�̑TaB>N~g�3V��2L�w�����V_r���i�z�i�)u��r~����i��6	�d�V���y�`XWd6�����F�Z�_N!e-X+k]d��ot`��y�[ޗ�9����k������{����2��Z#4��]k����:�Rԉ'�:��u⹭Rќ��	�	ͩh�ԁrsʚ3$@�ʹ9���SҜY���3k�ZYCsfX'kis��,�39�oT��Sќ)�Hs*�3E�����"��      g      x�����Ȏ�WYQtA�zo#Ƃ�ߎ+�{1xE�
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
5���#�����#����#���5�#�����^8��g��vpQ�\���.���4�],Tiz;��g�c���=|��.����N6���x��40H���������>x�W      i      x���k��(��笢6~@\�8+�����G���w�ɞ���	I�8W?�G���������C�?~�����gڟ�Z�\��12ad�Ȃ��"�����7�����SB���Ϯ����t��v_k�h�h��5�w��s�3�g,[ʡ��� �%g �x�,$���[�E�l�V�le�?YH,!�
XBK(`
\�����:>����A�7oK����s���`=������ �6�Y�[��������/��w/��"ք�5!bM��̍X�֡�u(aJX�?�%�C	�P�:��e�C�P���C��o!�)־��:�X��E�k�>��W���O�a.�0l�6��s���`�\�a.�0l�˷�
 �l�I/ؤl�6���BMz�&�P�^�I/ؤj�6酚�Mz�&�`�^�I/ؤl�6���Mz�&�`�^�I/ؤl�6���Mz�&�`�^�I/ؤl�6���Mz�&�`�^�I/ؤl�6���Mz�&�`�^�I/ؤl�6���Mz�&�`�>P�>P�>P�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>P�>P�>P�>P�>`�>P�>`�>P�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�^�ɷ�X��I���[H�CԤWc�ob��&���ɟ��T�}rO��H�~�½NH�8c���l��Xe$ЌU����H,��~������3�� �%4c��\�����:q���9��Ċ?9q�v,��|����� �v�6��v�6�
��m>X�x����H��fl����|�Ě0c���̝��<֡�|��:4c����:4c��X�fl��Ќm>@b���H�C3�� �uh�6 ���惋��}3��r*���3A?�*�\� 	�\� �%D��8�nsq�$�-5����H,[j����$�?I���Ծ�
gH��$x��L��J��#����&�\��`�x'�&�\�� �����/����<��A>=�<c���j��-�A����>��m�������H�~�W�O�$~�Ջ4hѧ�><Cܢ���q������-K��O6XFR����9��h�����=�>@�@M�H��?jz�E���fFM�H��5��"�H�C����t �Q�{.�}�M�}����t�B�LE��
;�>@�%6�>@b�R�}.�}�Ĳ�F�\�� �eK���H�˖�s��	�OR �*<��"��x����T��`���n��H�����s=������H��_po�kb.�}���%uM�E��X��ԝ�  �l��;>@��2j��E���>CMݹ��5u�"�H�C�ԝ�  �QSw.|�M�}������-�糷>����I��>� �& ���~�@cx�����f�yi_:YCNs����������/�t��K�/����J:����dj�m�r��sv��7q����c��x���D?�h��քX���=Ϻ�/1jm��}���e�Ů�~��CrS���1mY|��C��Yp��1���t4Z�T�{�lI:P�W���j>"��MH��H�Gd ���@�qj���k$�!�_c �l�')wU�O]ŃT��X�'�����`5������ �V���Ľ��5Fo�y]$��4����{^+Z������$>95McҼK��]2�� �:�y�$�!ͻd �i�%�uH�.H�C�w�@bҼK��]2�C\��i�%��0�@(5���*���` �B�s$���` ��3$�5��L�eK�d=���$�R[W�D0���<Lj���h9��j<Nj>��8�NBO=�@b��F�M&�<�w���|��,����OI�H��0/�{�`�#�$�=j����;��[�I�)i�5d/������d�Ւ��z2������֓	$�!j��ƞ�5k���d�&]��Փ	$\bz2��Ģ�ֳ�L` �l�ݭ'H,[jw��˖��z2�!!�I
�]�G��L�#�Mv5���G�`���'��� ��z�d�{�w=�#�S$^*�qZO	0�X���S$�-���� ��
5X�� �o%�`�S$�!j��)�5X�� �u��zJ��M�}�`�VJ����N	�G�	���B��](����w���S�����o������X��o������5�oP�����9�Ւ�'a\a5��Ѥ�g
��q�~���bU�<������g([Jq�?8ea�8�S��ZҮj.��:�Ά�;ЅSou��]�y���)u���a����j�gW^[<�^E��|�lQ�n�@�j�oC≧�@��W���AW4*��ׁ�@��~*�|��X�΂���f>�@���(kHw7�0ԁ���Y��
hF����f��@��h&��ӡX:�N�f^�;2]Țq��	G��UqL4zP�d�����@<F6�z<�d�Q�fՁt�����@� ��F���8�OxWU#Qu��EL��z�.T�k��^r� T}�tۀwc=�TR]�bOu`_����0B��Z�� )��R�ў�t ���L���FzԨ�4���N}���\���3�gJ[�/%]��A{�7g�K�T[�������w_�!Ĺ�°�/�Oz�~�+�Ehړ�+�PHE�T��[��A�26��5�C�$O�[��_8tQ��Qj��O�ܞ�\�2�a+X��?ŵzW���ʨ���I�$�������G��l�X�(��:��}��}{p�ur^.lW�����G�a���89)�3���$T6w���!����յ�����:��� ��=��Ú�ܒ~�m/�V��ŧ�m�>��/�h<L7�!����+z�Y��F�ׁ���.7=
_�c���|�b��zA��~��h�zH{
}uz ���aӯG��@�6�8vH�}uz��
 }uj��A���d{�����}|j躾��H�oP�[�e��O?�*�F�!�:���]�uח1��?Rtׁx��* �uz���R��:=�]��.,�ӣ�u ��@ߐڮ��@P�kׁTs����@�9� �#��/R���o�W${����ڿ����g,{�?>c�� �����N�@�t�x��Pg������W�?����Kw�xk��{���?���A#�O_6İ돹���漻!I5̹�^������kU�C�r�)N68z�xio�%L��_����C�a����^������&�=�q�i~q����|�>���d��kQ#љO��^}	R';x�oݹ���i>��I���uq��[f�O[py�Qm�HpuHטK4Nc:���Ml�A�����t1�C���W�����Fb��Z��������ge�L����������9t8ٲ���m�V<̡��F���t�s����Ȍ�xV�� [�cW���tl$^���7����F��}6k��	a"�>�%4��m$���ض7\�V�V���*�@8J%Y�F£LIW��|�p/Q2l$\)J΂��㤗7%m�FbM���q��I
�]���q��-���0�=S�`�Eˑ|m�q�ۢ��`��$���d2�H���\9Jf���l{VF�j����{�X����6k���FⓁZJ^���{	�S��{�n��$���?�� �ɮ���`��&�H�Ć��6��C[p{g������Ve�1Ͷ���m��ԞBj�IuI���v���奏���8�Ӿ����Yǀ�޴ӟ>~��]7����rx����7�ju�z]���P���-�,��_Z<@����(!���@��-��������e�̗��6��g����N��b*aV{�M�ɥ��.n1�n�<�����m�����lv�r�b���0�&g�8R�S����7W�NO�y�{}"�31�V<�)��{`#�Y<>���,�1%��&>��/m��`�    |�,�;K�pJ"����z��"�H�R�l��I�pJB��Ě@�p�����
ww%/�D�M���Ʃ	��Ƃ�~?%;��u����ר�(�H~��i%K�^�xǤ�F%Q�F�����)�
6˖��|��ΨN�Y���FCMJڂ��:DMJ悍�:D�G%y�Fb�����`k����`�Ї�$1�H����1�o<�<۳?Jd��9�d�e4Je��9�e��騄N���/o_�	D���W�R���U�Z��CԠ�b.]�ݯ�˅�<�nu�q��~S����O�[�}L2�z����E�.)?}���S�u���L�?���A{E���3��e)~Z���bi�5��V�Fݾ����+�� �C�����ӗ�k��}��L����󕡺=�2ѢF�q ��bK���<�V����:Ps8H�M-��@*W+�E���	)O��7�hnCɿ�\�$�Ϗ����PI0���F_1R��������r�6��O���a ���3fE���Xͣf �frz��o�R��3�x���8��K�;�>�����|_d��X��&��@�C0)V��Ļ���3�x��|q_M4������x�j�y�$���2�X������N�!�G�!�|!��Hx��$'���|!	ט�/d �8�ɡ�H�	��P�OR �*�U�|!C:|U�aR[E�2Dˑ|m�qR�A�2Ɖwjo��B뭖/d �������
�HT�Qb��$� -N�@ⓁZ8z����{	���|!c��W5_ȸ�S��/d��C�����t\�F��/Nj��F/Nj"�	/Nj\�	���5k5���'H�Yj��	�Kꁞ@` �J�$'5���5���j��I
�]����@�#�G�y5��X�X���'��� ��:��O\�h�'�����'H�a]����@` �l�a�'H~8�uFs=��@����u�ڏz���:D�G=��@b����@`|k���@`�Щ�'H�����@`����o�J�!#%�����@`����	�NI БЧ�'~Ԇ!�P%��p��Q�X,�_��d�Z���t��	{�s��I#�a��j�� >��F�=S�Ҿ�K���?�����֖��,�[�W��9okZ.�l͇�rk}{\�5uDKI-#%�Z.ɬ��Y��-�����g��.��}���{�=e浇�����K�>΋o�ԮT� +��wqik+�x_۵�b[���_*���k�t�ʾIuK��r���R���gj]�m+�6/Kgԭ���b�Kw�}i���$,]VN���Vݖ�	a��.��x�Tna�9�V{מ�K��/Ր�tNe��K5$�����R}��#������ok/�K�ԭ�X���R���]y���T��R�K�޸֝�tN�R�������ZƵ�R�E\��i����#]{Ȥ��sZz�IKM��~�����i�Z�K��҇���k��K��,���-��<�K�B^��ڵ�t[����ҕU��2e��֮ӥk�,]K��{�ţ��+ =�����C��֚�=Z�� ���g(�(�w>�:ݚ��7��|#4j�XŅy��}�ٗ���T���U_׎t��V���K��|]�#ե{H]z��kW�Rٗ����k���u���^�>g�Ҁ	Y�8&K�VdiԊ,u����,Y�(Kｲ��X�z�d郧,}���~K��di`�,}��>K�`d��Q�F����YzS��ϧ�4�G�>�.}`��ϧ��$Kcei\�,}����&�4�F־�.n��k��mW־�.]����q��-�l���Y��+q�H��C����jd����,�4�R?�,����{oXk/,}aK��ڛ���XY�(K߳d��\��-ei�FX��
K�Ha��{�o���3�g�+e�~~i�}s�3������9�%W�+O���,:�|�bb�흔ֻ}�O}~�\i��Q� )����������{:��b%����m��=������{5iI���V����Z�>_�Q[s��~ǭ�5M�����+YG$Kc'di\GX��K_@�Z������n��ODKɎ�^�S����p�m���)g�ß���gJ�e�����7���6֧K[�ſ�}~�̓�
�g<V~�\N2}�H�6{�C��n-���\��FҊ�*Ն�m�A�ag��%� ��A:P+�j �75rE���2�X�ZySCBJ}o�xV����S)#f �|~�u��og�U)�f�#��e��a�juJ�R}�W >�
���ĳ��+H,[�N��ժ�H��h�R)�d �j���B�h rE��+H|j��
Z�S�w?�N���W�f��T�$��V��@b�j�;���}���M��7'
B����` �uHT��	w>�\�@�5��+H<Njr��k59TrE���Jm�\ѐ_�x��Vl�����M<Nj7�J�h��$����$�[�\�@BKE'W4fE���#1P!W4F�5H�p0�X�4�Oj����%�6����:_UrE��O����T��S��mL	^�9��ċS#�0�xqRY'W4�xqR�Z'W4N�	X��q��+�@(�\�@��R�\'W4�\BPtrE	W�N�h �8�Y��+H�	�,W��OR �*��urE�7=jϫ�ƚƂ�� �\��u�������+H~��GK�\�X�xǤ��\�@���5�urE�eKs�\�@���3j����h����+H�C�~��$�!j?����urE�X����rEcǅN%�\�@B��E��aurE��+�T�)��7rEc�0�FTrE���+�H����u�S����+�@�\��$t���:R#W4�
���[�����H�Wr�7P�Z��з
�֥��<�JK��R����NPBdxe�{��q%��G]������a�o]I���Q�+	�"$kr'Jx�;{G	I=R�����@��b�D�Vd@�G�ӕb�����|�]M
I> 
�C�$�4�f��KP�mQh\��]��G�t�l�W¢w��Dx! z��H�ad�B�HD����gʳ|#����)����$��m^��ΐ���!|��oy�1��gI�F�t}�a���Ok��tn5�����I��)����?�Z�緐��{����xm.F�Vs��_�KA�*g��~�ڦ�e����|�ozv���x�]9�����JS�G?$Ӌ��S�[	1ɼ��wi�Dp���.�hDM����\�޻Є���y�uj�G7��ׅ�15�I������|�V:�ѹc�����n'�z�����HG��v�҅���	z��uc�,[���7���z�Η�U|�>��S������%2�:�:=��%d� ��g7��.�	�������<��dvG�Uз��ϳ{VF���n�h}!�畢��m
�C��FA���};�|EҨH7*�!�ފv����"=�H�*Ҩ�;($��s�f�Q��/�mz��yE�W��ӕ|��!�^A'� ��������4v%)y�4����{� �F�+��� AN�+��;(�8���W�w<�LH7�[� 縠�A�O¼��)N�ä ������/�S�6���H������*��b;6�{���}�ӏ�����.��ێ����ϵ�	�[�C)�ӓ,�����S+:ݪŦ�|n��q7�8Lö׽���ݼ$�/1��[8��<�\?��_O׿�ϐ�K3<ge'�,6�ŗ������V���|�����{����%�c�����=���CU����������[?�+���>οt��u�O�n�zq[ty�}^x��G[/�����P�Kǖ�F{(�]L��S��O�#L����g�::Q�W`&-r�r�
r�fJTi��(�/&�_�ٕV���/[96K?��g�n���޵�w�^�K��xmЗ��C{�?n��U�e]����,�Cݤ����׎B%�%>���j{�Mn����*�*c�����~�����R�������>-U��Y����NO߆��*ܵ0�>��>�f��D��@B��ŏ�/箽��}K{HS�����0���4�    ����>BuS����Z��` �7��Bc?�N�����u��Ǎg�Knw�9}�*62��n7�gu�����u�G(��Tb����nb5^l���\fn�MJJ�pCI��Ucb0R�5�EZ�S����&���4�s#��1�4m7�G9�M�Ő�&��g<��$��=y�*�����!�,�G���*�Ok�o��/�'�9]���-��W�洮�o)7��l�K�Z�]��zP*�H��Z��&�S�gp����c��ޜ1��P�¡C��a ���)�O�1����8Vb>θ���M�2T��<��EQ����Fn`HEIi4�x���̙�G�jz[}�~�KM�>{��(ȋS/�Rf&�Ka^0�0/H�y�@�`I�2�B�5��K7��T��`��A�VO�@"��tL�N���N��ۈ?�]�1�����h1��ӏ��C�[�3�^�.�k���WZD�]�q�~>����7y���ŷ��I��T+0cM|�]�{#���zFt[L���m[+��B��0�x�֊�H<[Z)�r��g��&�`�<:�G��0�К�y6$':���a ��y6$'u8�<ku�<�')w��ZT�C:|U�a2WK4x6�r$_�x��j�φ1N��P�\��0�Xo5�	�f�gØ�x���@�g�%� ��������4��d`�g4x6$�K����l;|zSy6��?j<��a��F��0�/N�N��ċS��j ��&�γa ��Ƶγa�\��Q�:P�Z��0��p8L�fy�fy�fy�f�γa �J�y6$'5�u��5���*φ�I
�]���γ�#�G�y�g�X�X���#@��0f���-u>�<�����_��0�5�1��A��0�|�º@s�g�@b�R�\��0��p���:φ��7j?�<��u��u�ڏ:φ��:D�G�g��&�>j?z�g��q�SI��0���k�lN_�g�p�)��7�CF
φ�M�g�'�s�y6�;�³�#�OS��0��C��
φ�F��$�wφ�M�g�pPÅ��l��^q�gÐ-J�#�u_P�B��}���G�j�Ia��K��V��6_��y��/�c�n�X�}m+�SE&z�0a�hǀ,e��ZE�G8����!q��L�(4����LZ(��m�o!����e��6���!�/�� ��E�*�4꾂��b��}Ư�B=�̱y�(��nem7l��Tl?_5�[=y��x�u��UQ_�cbKkw�ӵ�([�R�ts�o-����U���悫��=��~��n����!m��~)�c	��bo��R{F����X�%N�X[;�5?ޏ�d��S�{���ת��d�n���3"����[�S�����P4��VC��oXp-�r�ŅZ�����^�EܵA_��Z��(>�7�E?'�9U�%ٷ:?��&�)Mk�If�?DC��ڢs�BB`��t�H�����L&��Χk�9ӭs17�hbi���
ĭԔ�t{'̯u�F[�^K��29��Uz�+�E"!�8-��t���ҳ�V����Z�W�I���e������^�����}��_R��[
>V�Wbr�rLGW���|ָF��̯��������/g���{Oa����0�D!C�A�&
]��	#,�}�+�f�����'q0������D�����fJ��=��B�|_��D�UyO�`��,��1�(4��t&
��X�D�Y�'V0Qh�'V0QH��Lҍ{b�$_��D!�ߗ�6�E$? V0Q�U��+�(��L�����B����B�qO�`��́ܒb����}~@�`��,#w�"�D!"���"��Ι4���	&
�=�(L�/���($y�M�';0�����D�UyOv`��,#oπ�����uuM7�cxJm���ӣ�i�j����`�F�]����aL��z�t��B��k��z7c~���v��+g/[��\ܶ_N`ߘhe�����bN�C}�ð�PK����b�]�����q��;��Y��)������T�]ս�����Xzyv����P�n��R���^��$�닓?�??�|��/Y�~�h/l�����6�`7q�yh�Wt�!gրz�:��)��4�9���d���!��5���e��1�Nn�Ph��uI�&ҷ��^�by��LǾT}~���v���Ϯ�zM�X�L��M>���oq_{�5������:o޻T�mi����;+C���^���agZ�����i��_vci��{�Oh:M�W��آ'Ί��o!����v�\��f&/R<f��J.[9Lo�������C�z̋;t����Fg�g �Dz��u��t��'P/�܂x�+;��;sP��ջE��bԏ�.q�w�SOf� i>(���=~���u��sM�q��M�,</�įA��fyCw�`[��Kk����SL�QF����I	mE��2-�c����6�f�B9��G�/��z�j[�oE�%��x5�>�T�3������֖���w��Qvl����~����?��=�2=���?�]�[������F��ݾs	�
1�w���5݃5.;mmE��v(DswL7���#,�il���Z���1҈���8����l1H�
f'�}�Z���m�%�7Η/�=y�ֿmV�q�wu�nއ��5���6���|�ީ��#����r�HRם^����:}��p�&~H�b��0���H���s��ݗ�8n�'1S�7��c�=����Iss���&�&��TϤ�u"�n�'�W�*��5��睵����V>�xX�.��+z Djg��F�k���]s��L��؋Y���b~�*�/���9�tG}���{��4q�z��u��n:��ސAm�7m�bw��?��c(;�^�'�r{���Z�_��͇r4:��39�\�?��:��D?�w�z�ms/��J��'_��۞��|l��;S�H�Þ�-:%�������K��B-s��ɿ�����<ԾfN�7�Ƣ�.�̭��q��F:��Ȭ������������t�>�<�j]R2��]j@�f�����8���o Ѥu$��R���&�����T�H>�C�.���}U�A}�H����zX�Z9%�I0��O���d �hL�V/��c��Ho&��T2�$^-��T���c ��A���@�]A+�d �S2��j��62�
��Ĳ�
H,[�̐q��O�1�	wy�FB��0^�t��	w>��@�5�s�H<Njr�0k59T���Jm�Ɛ_�x��V�9`�r$_�x��n�9`�q❄�:���z�q�Hh��0Ƭ(��t$*0�(�i�f$� �Ԭ��'�pt��j�0����*�q�@�ư����1%xqj5|$^�Z_�'5�u�'5�u�d������*����9`$�,5�u�%�@�1�p��0����:��Ě@�r���$���]�ёxӣ���c�i,X��9`q]�z�{K�:���'.~��9`�u�wL�~�9`$߿�.P�\�1�X��0�9`$?�:����c �ڏ:���:D�G��@b����c �Q�Q�1����ڏ���1v\�T�9`$��Z0��W�1\}
���M�Ɛ��c|S�1�	Cit��p��H���9`?j�o��c�Q�(I,��c|S�1�p��0Fo�W\�1dK#�0��B�9`,�}�x��v��n�Z��~V[~�{;��}�+5�1p{@CR�X��"h&��^=���rK�4�rHR�'���-2`u\b/����������N�}���ю%���8��^c��ߋ���������ր���!�e4��1QH��ku�(�������B*u_g���m�4��l���<��o����̥�4�#�G�/!d~�mThΤ�}��;׀~ȼOJ'y���D2��u[h��P�j5�����90$�{Z�?++��\�%$-��9̯�-�D���/�h��pO�a��6rO�a���B���{BuO�a��,�rX�{B�[h��	9L�����4�|}n �  o��E�M��<LҎ{"�����B�yX�=|ח}�kH� &
i�=��B;�=��B�xO b��N���($��Z�&*��e�۷0掸/_o~9Ԑ;b@b���t�D!��=鈉bg����~�4iZO��w�>���\���I=	Jݕ_� I�s�kF��쿔U2�|0�ح��n�K�/E;Mٓ}g@�b���o@�b��ڼ�n1Q�:E.�u��b�4.�P��(�C$C��B��u���1i� =��[Lr��[L�/�{P��($y�w��n1����D�UyO�b��,#�����B�z�������n+.��<<��ؙ�|@U{}��/hȀa������#������s�9,��F����6L]F��ՀP�!O��_g��w#+���Tb�x��uݲ� &���`n�*���,�N	��o�S�����Y#�qu��P��i���2m/�On�G�W�k��<]h���o�m���l/�;��B-�O[ޝ��8��YH^Zl�%���h.���V�����4�S�b��J��bi��{\�`ȡ&y����b���~3�ï�N�9��K�����cI~��n�����7�����p��흐��X���;�I��?N�����qJ���v?�:���~��������Q�we^/�+4�}�>~�غ<}cGi��NJ��g#����ug�^~uo�9��Wy��G�ϴߊ4�U>�hjQz�����c��hm�sn��g}�C��v��lF�y�;z�c���R�����wۯ���e�a�Ӵ�������J:i]ܾ��P�V_��t����Ey���.u��Fn�z�/K���V�dW´f6*�vju�����P��'�sδ�ه�&�K��ƙR�g8VυI�\?�A��h�������a�?�/�g4���{�o�s�C���\�߈���;�������9��'��8N��Ɨ��<Eiӓ�yC��ѓ:y���m�����![����Ǳx�Vc�Ӵ����8��x����ӕ>Ĝ��^���r,~o����:Iw����;L�X?���ICr,�~L�����j~c���@����D?7��3����=���� �3LĻ۱'�̏��=Α�n���1���܇�����q�e?}<��4xZփ����G�N�&=���+��5-�����6�������?�'�`      j   �  x���]��6��5�b�@~��]�Ţ�Aw���^XhleƝې����Kٔ�!�؞�@��N�P�sH�G�y�=�N�w�~��ޚ���F0!�c�;��� �������w�9���n5�ݱ�1t`����0�y��`�_�+�ƺ?��7��@�כ#!�y����v�=�L����i���wT�zUDb��1!B�@�"��Yft������5���(�7�3�,X�fF��g"��(����@T�e3�l=�OHnVD�7Z9Q��YqO�q?�֧��fu�{C�kml]�!�X���3�m���w�㶓��f�>�۰m�@ �t,!F�x
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
-k6i��:�WR$d��%,H�LXd�Y�y�� ��L0�kfrb����X�f��� g92O�yN�[��@ƪy�3��NC��E3���^�Ma��"n�m�HtO��.̄�Oi���}Z: ��������1�      l      x������ � �      �   �  x����n�6��g�B��pn����E���"]�&@�J�)��%)��x��}�#~�ɹIt�D�������5�d>�0�ʫ�-�_�������?>}��w���������燄�}}�!`Gâ]�ʪ��+�+ϼ_�}�v� ��s��g�<a����73����t�B\UG�M��R��W3����b�0�ZW]�:�P	�P�˥jm=6���D�r��|:������{�i�֔y�4�i3,��|���LX��+S=��}l�n0m��-���� Y���AX�1���=�"1����R����J�π�F����q锖Uj.��%=6�)_�E��u�:���?+1oȀ�h�T���Ҧ�l	 �M<es�0�QOF�p���-4�\z�w!_zԃQ��(1o�$��4�����;�Qb��,܏�ζZ����)�M\zl��&RͰ��Aݠ��y��&ͬL�Z8��K��
z+R�B���0E�!*��uO��:-���]��ok��9З�-��|�]�r��J�[���bYI�����-6<�@^i3.C%�d��ytn��=��50G3J�& ���%䗺]��J(@$��E�U�M�AF���^-��A]����^Iz�Q�$wJV	���k�ϣꔧ�Z;Dq3�U���p��%i��ju2�r����������_�l}z������Ϗ憐���Nx���9���#T���.`��E�Ԭ;�f���y�s���7 �]�[)e�cB@0޻���d�m���.��G�_HK8ө��goqv���U�)h���89؀�WF	��:��F����@�fċ/�'&�C�1O/�a��;6���>ߠև&2J��#qNn'�e� �s&��x��8u��?�%�L��+$�{�M�Y*��>h��y�րCaG� m����֞qo����[���F��Y���r��m8��5yз��5�,��O����b/�[@���Q����iE�R�*1c�@�u��H�xEP3<�P��;��
^�g��1e��$I+]�%f�A��ݹ�*�G��^��*A_���F���p��J���*���������%�j��0*Aw�8�'ճ�eHڔ��:�������C�z�Q��f��ф�8)�p��@6���>r}FJd���� �#�G��Ue�VW����K�27 ��I.      �   b  x���I��6���*����ƋjP� �d��(Y��C�&���<$���Ր�$�6�����˚�?���h�Yl��c�q~sisy�]�[����26�:l�/�W�,�8����E�!����a~"�c7����D���.n"?�J���O��~� g�7���C~���[����w����?�l�o��t�AǸ�&w!w8��ӄ,ʻ�9Zd�ȡ��[��@�'�Li2���uZ ��o�gD&�~�P�v�|L�<�粠�Hp��E'ku���bAy~\>N��c�f�v<!I$���ȧ�S�8:���sOd�0�n1��E���Ro���$�4�I#�'x{�_{��S�-��M[l�
B�"	��=+����߭?�m�M�wk�I$�.����j����<��qG[F�l�Ŏe��E*�KL�9љ�i*T>���1$W��{m�/,�+��7Y�ݏ������ئQ%,�Y��5�2RI��/���	e��e�2�)�)���L��Dc���I �������u�
:��E��u�t�}�70,*��
mcag
d�3;�	�`�]T��h�)L���a��˺���;����z&6�7�;/j�Y���F�o���X28CUA)[�hˇ�6@�$�o�HơL	�ū����R�=��.�.����틒��}%�+�˥������v�0�&����WBl�6����N-���=�쭖�Ŗ�
�ERh�{��c�B%�᯵(�����l�\@b���r��k�����L�ޢ+*Q���*�}�
��ÝT����x�%Iį�`;���
_�gv3���F#cY'�A�wl.�������Zx/��>0�l�m��EͭI��SL p�~��"�kb�YI�`�^�H�H�[d=D,R�J��?<Q
9&��*���)k���A���|�c����|.66��HBy��	�uN%�P`K�H��
!K9��dM璉�����")���S��<O<���G"�y!�"-ܡ�T��/ !���&�^�'�-v�T�>�:��{ $���w~'e��E����S!�X�/���p ��XG�H��$�@����.jU|��dK��O�\���{H�vؙ<�H�	d`)��o-�3� �jD/x�H|���-��EHYU2ΠLk�e
,��4锰xDq�Gxڤ�c�HO�'�vD��*>��y*�׎ة|�h����!_�[o|W�_-�h��]x�(�U�R$��i���wn�/.�ڑZ�L56����;�Kn|i]���q���{>��(�?��i|�
 t�^U8���x����ǅYC_�[���"�%	V�_i|S�َ��J̓?�E<<��R�H��u�����y2��3�����J�Ʌ�X%��<Ŷ]�Ll	sw1��g�]kȑ"Ϝb�����k~D���:>+������C�2�����x��R)��ڻ���AWu�$T����b���?��/e��7dU�'e00�2��\̨��3oS7O�3�>a�~���Q�3�cEUNN\�U$ܫVVO,�6~@���Q�AEع��	�<�_~�O,#>���[L�o�|ĒٷE�ݲ�_�/(�������jTJ[���I�w��C���/ p�U@䮊̵�E�rM*�A�-n+z"��q�t��RT�1(n�5�X$�
��&�3��Ÿ�_��fk�ȯ�?|�j�� ���t�L>p���sqb��B#��G;�~c�V���+�H�	8�QV���f����_�S�#{~[U���B@�`G
�ER�M��C�C��S^ȇ�E���;�2�T|��������-����fX&C,���^u����D~�翊�g	<N�/��mR���Z$~m�|a��	d`#��� v��W�ج?8\ܨe �v;��-�Y0���Ҝ�S7;P�A!����P�Sx����B�Ɔ�9x�")���\z�Q������Z$���[7��z(x+D-#~���W���5Mǯ���4�`�ϲ:��qM��ŷ�y�Z$��d��w���||^�uS<���2��C<�x�h��ҏ1{�2�m�I�m<ȍ��2u��~��&
`�L��Ӓ��G��
��X2s�ՑS����8�2�kaAS)x�0��v�*q#I�m�%�Ԑ����=��)����=�N	=��=�NIrq�\C!�>~m='�ӿrm]{�xGr��")�@\�<>r��yB��HJmJ^�9�xʧ��+������H �iA�ql�@,#��Ɯ�*~a#���+��X�	d���Zŷ�q�������Z$��+���vZ��n-������2R`���.���ûAw}#E|�>H�]E��^�O-?��O���~�@FV۠�� ���C�jKj�+>?�<����l�8|
��`�����yZ���yvFC,�R�Ów^N�Oy�JɣR�KY��<� =@6��e$@j�@W*~dMI-�NH �iW	el	_�U��#�]]ů����5�j�/.}��z'�H
�)����D���Ƿ�|?����A-�RhJ��i���%|��	D�U��=�Ωe�O�A�D\���߳�xg9F��?<@-�TlR�g�_�~�����߻e�h��"�ۮ�.̺�l��ƀ�0�j�,�&���1P��8�x*� ����i�.TQ�H
�)D���Px[F
	����3s�$N�o�ܝ�{;�@��Ƿ������|�ş��g:��J��"ɔ&�@f�ׅf���P5���&L��x4U�� Mo
v�2�g�h:z�o���[�H�D-�L�"��E�?�X�P�?(v,�a��#��;�{�_V{�9���"�i||����y���{�O8cU�����?���o`����E��M*��� ��_�Y���>�J      n   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      o   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      q      x������ � �      s   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      u   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      w      x��\k�,���]g��;���Qk���c�$(K��t���P�	��T<�Oȟ�	�����������k��1�ɰqP�'eJݿ�*5j�(����a��T(���a�^�5m�D�J�;��{Pj���0P�'%J�ߴ3���4�T[2�Rϱ��NS�kH1P�'�i*�$��$>M�w+{x�d>O�7$���W�mN��`��'S���7�Sl��'S�ϡ��a�ʈs���a���{��L����\؝R�7�kX�^��)�~��^�O��Zܷ6�_��1M��k���ba��o�|1ߪ�?�H���T#>)��n�cVm"�)t��ۿa��4�S�S\�e��������u>�6s.�0P�aK�n�%�)V�6s�h���ĵ�sl�a��^/i1���*m��z@1��8��:�z^��n˰	aN;��ݦxP�v��sl�a�ru���6��:u��)n�u��?����}y��0�z�P�v[�رg]���_�׆Uφ���b�b{udC�t��f[�XV�hX��c��pk�11�R�h��bMC�����-/100�)@��V7���:�8��l��l0ja;�5��zQ�O����܀���7����_U����)>"h=�%6X��3���Kj�R:M!��0Pw�[{3g��U�?��֬|�p�@�Ŗ�Mg`��3�f�}k��nc�|������baxo]���8��\�궬��0�>��v`�9�K���f�."\�ϫ�9�K��z�wuq�t���j6���̹��էQ�a9nV��<n�;���{��|lٛ�^��"f8�%,���<˕n`����A���=�a��O��6���ylp��|`��{YkV���p5�"vkZ�ugɅ��mt�0Muuv>Oq�K�nO����ʺ:�U�p�|��B���OT&s���X��t�Yr#n�Y�t��3#��ȩ���7�RG8�.�Yu�nu*ͤ�fe�%U��y�c��|�͜)�:_sX遁�N������cF0��Қ�%�50Pw�8���R3�^B�KC��n�\��-N�jx��[Ϥ�x�0P��C����9<�syoj:-��גo:���<6���)N�R}��6�1��E��%>֣ΰG�}�u��a�{�_�:-�Ɯ��NK���~5�S0��8��yHfp_ڰj�״�8Ňk��z���޽V�;c.�k+w�V�S���cISL��jȰ���@�d͖�����d����c�ϯ5+C�]%=c��a����U�*9\cм�|U�#-u����Hp	qd�{� "Iqd����)Z\�jm��*��DD�����V/�׆�*���늆�*��c�5j�GjX沴��*�����e�z�����U�2Te�-�YM�0�:�p����^b�k��8Ұ���$�U1��ҩ�b侶�t:e���Nlkz����5� @������@�Fq�i:�4]h����!qM��T�)M��-W�0P��v-�r����N*�6�2պ��a��c�ѕS{��ʈk;���nS1�*j��S4�:b*���k`V�L��ؖ�ؖ�Xr���iR���%h)ARXܗL�� �׃���m�̅�չ\�y$+���ǳaиO�w��>�]��w�����w��a����r�E~�G��}E(P��j�IjW��m�j��t*��6�!RM2�R����$1W��00(:�;��*���$|����`J�K���)�W[��
[=�$Gp�xbf&x�G�>Ef����RE30�J�X���A[Qɵ&Tj~hA���z�w���0I�aө�����]yq���aJ�o��kʯ�����a������z��}#��Ԭ3Rҕ�ޫ[/�m�?��(�@��J�[�0��R�K�=G�mq�T���p�S)?�^1�,<Z������p��D肑ˡo=S5�f^Ю�.�������CD��!5�6���iJ�T6�t����E��1�z(�)y6��<��f��R�^�0P�8oj3��7TU�v2��5�C�Z��ꩌ��!�A�����ͻD�@�Ek����0Pi�Zo�tj� �B��Er`�`X)���=T:��f�6���Y��ֻ��O4챰��L1r ���r��̫2�W�Q.�r5��0:"������Wm�'��	m��J�W��ne�Z>;���׌�w���FD���H�Kh�:�a��2��A�WN�z��j��3.�b�[�^x<{�>]�}Hk��:d�,�fLRc������00E ޔ1gS�.�30�e����Ie��phe'��n�놬��P�0(W�b��h�|1O���ic$��5��Բ�K�3k�u�m5�{H"ׄ�5/f2���H\�f`�Ue�k��2���*�5�00HO�[k������c�Od�|��W8�ǀ���Ɉs�,��Y�t/켓	uo-M�R�[K�IE�{'�׃C���Qc�����x��������-�s�U0���u�*�py�G�[woN�AfP3�I<�9p�q�� �Ҏ�ϓ�g���]���\�D��9 S�=��C~����K��k�70(OR�|�ac�Y6�i{�AR������[�7m�DNd����+/�cRPz���O�YN"�`��<��ۚ�ĳUJ�y9&�r��u��UN7Ԭz���L�@�Մ��W�vK?�H��O�����m����0چ��ȂW��<�q���0\��_���65=D6*F�f��o���J�`J�+��3�w�L���00�|���6���.sy ��d�a�R�X�A ��Ӊ\��a���e�.5��\?jxS���g����z��WX{g�\Bb��u�!�,�a��9�)G�]:�s�f���0�"�R[��a�ԃ����i���`m�{-�^e��=�rߺ���>\�/�.�<�ǒ�*������fy�u����愓���~�_��*�ARq�'�a��=P�Ŝ�y�w(��r���R�vMu:�a��ŕ�����\$�c$�b7�GBC�lٍ8��($�9�Dᆁ*�e�F,�ވ�Gm;��K9�5�#�հ��#LZ��{<�^�|��0P�~"��Գ��,��m[��l��eMu*~���IݕDG�${^���	(�l�ՙ��(N
���0��#frj.&��10��A\�0�Z���fnu{TD}��d8j�b.Dh(ݜP��{-dqJ_�r�x�R:�z��Qt�jS����w��7�A�!�M���0�F>B�Bf�Oü��GHRș��;�?�_:T��oH��JwMa��v��?��p)5�){%��=y�qY��=��Ǹmc��5P�d��]�mV6T.5X3��ˎ�I=�#-���{<����d?5�J�:|}�a`
�������TB��K������43�J�Y\ҍ�O.��ۨ@1P��Z3�;�*�A��\h��E潱��>�s��o��
nӽ&�kz�e�˕���L����3fZ=���Y3�W�s�L������`�����<%3�-�	�yI�7���~X�&��qb��o�[�N�5p���C+�nY�.��_.��zښ�1P�:|�?���G-�7D>z�B�í��}��@�n�I7�r+���ʍ=VU9��3\��4GnGxoF�C��W�퇻�I1���%l0�`��ß���%ӏv��f��uMs��H���<$������S0O:�%�~�����1�^k���U�GZ��>�6Ԩ��C�@M�ݽ��@͚��Z���v��N��:�v�ZV���GA�WN~�ꩩn�ꥨџ��=Lb�\?���0�iN�|�O(wz�PԨ��z�j��y�xa�fE-8_�ES����@]S�ى⅁�*��sza���:=������އ�$6�M�_��q�U�0�����9��3	����00�d��/�"�i�$���%�R��䎸�����/�S2���^���h��%��∛�*���?����    ���RGA      x   �  x����q� E��*��f$�0��T���ȅu6�Z�?�#	�,�I�23oR���<5=X�>�y*.m����,{N.LM��4l�8�͆$��fW�@-��ѯ�]�ڨ��-S�}K���9���l�6�|���l��H��q5�ܻ{d,_� �V�7��!�N�����O�8���F�5��@����g	}'��\I��|EC&��!�$��s�{$���ƥ�5��!���K[�{Gm&�R����te��C �W���u�7�R�u�4�}���m3ڔZ]e<�W�@�����!P�U�X9��Хk�V�!���,*.Md@�ϰ>4�����|:qɰ�C��/Y���wHZ^F^f�����Nqź�u��?���!�N�鬎��u���&���a��ګUr�k����	�`��n��_���N�?D]��ҙ~
�	����ID?Vw      y   �  x�}�Qr%!E��V�dJ�m�2�_�p�u���T���7�����-Z��~I��6�=(��T.�B�Ԉ��(��Q���A@B�2~a(�R0��th�L^��m�����~�R@���d�je�Z0O���ꐋ2y�٩�����-����lE�W�2���������'l�T��<��JІ��'sl��h)����ep��J0�;���i��[�cgh�B�(��&s+�94��d���3�"�Q��� `e�C�*M��f!u2�=FS*�ٿ�k��$}E�z���RH�!i���(����4�S�A@67�}�A@�ύ���fHl�4!!I���%-$$y��6U76���V�<���A�u(��-kͽ!�ypc:�!iҭfy��,$�gm�\ l�|�@0�7ˡ�y��c���<s��*}����� �\1�}�Г{0"�����ͧk?�A@�Սu�t0HHnL't0�Y�&���Э,$rMj�5ɸ��R�����D�7��a2$Mv7�M ,��/��  ��5�0F����P0XH��`�VVi#,<(]%��$��@X�C�:����x��Kn��}D{��:��B!��k�~E��X���Eu�)ٱ�F#�M,��� H���mDoA��4n�q3R�X�ָ���i�DPC��Ng�� Hup��#z3�7[%�[�f�^rc���ɫj�i��C��3z�sڍ�p��5�ȝF#�M��p��P�p�ן�!������ۍL>��-�R�.Dp.����PA��F���ंg�>J}9v��r���PSH=��Y��{?<����K��p��C'�k�-�`�pP���M\����x���*}s/ݿ�:�!����=4�|�����E���%��_���P�`H:y�E��Ӹ-��R��06��!��4V����W����˚ZÍ�����e�0xH�N������j䐺u�,r`�$��҃A���il����VauPҭ�Z���.�vK��F��'��UZ�M�f�:��W��5'f[������u�~�]??�WA]F��|߽WA{
�������_�+��SA#��#j�yY'|߽W���%ۢ��]ce.���n�?O�?3�2�
�$�����ne�����z�F���      z   0  x�u�ۑ#!E��(��l!	�G,�{�ٙqsU��:FhI[Oړ$�j_پ$�$�|�Z8�tH��)ʩk�F�1�h�^�s���E���4�֍ipzi������_���m�SR����f�9u�����8�f�&T��Z�$dp
�����)��k}�6�q�M��3�M���Ғ����fN��p4l�ʩk��ƹܛB�VQ���`s�J5�r���[��)4@�$��&y-0��[�f�N�Ca�pj��ߩk�6
�g�=���{j���s��7 ��&I��[+T��C�Z曤OSN�IZm�< u�=��[Q��rѭ�`��e[����������y������ZV����֛�
�p���xS�hA@�E8�����<�ҦЂ�3�}��M/㋍�F�߼�R�b{���,
�E�����>��{��GG0\�:��E��_R��gD�e��Z�rs�ڱ���q�ڱn;���R%DI�i��>���+��JFs�hۜ����WmQ�I#�}�_ԟ���v(��1��&˜b+ϴ��KP0�38E����;���%���纮6��      {   S  x�}���!�K����$v� ������6�+f�î�W�>�KE�%���S}�1E3Vt4�X���p�Ռ���Q�u�w�Ǳ'c�3�S���a�r���t�k�)=cp�;�8
g����N_���%��bU���1�̹��{VL�M5q��y��~��tT�=�Mq�{v�a�u�gv�a��v�g��R�MA��a�l��џ`�[�'=��S��~ɾ�`phd�18,��y��w�1g1����I��������ނ!;�>��{�f����-�>8�=�u]s�w��u08�}�aIr-ȵ���܏�-�.��H�g|���Ot�����o)�q�JY      |   -  x���ё)D��(���@��E�����`$��zE/�R��j�ϕ���ߋ"埑~��#őڠv%��~ݮ�҈Z7i��\]!����iH��C�c	��M%S��N����YI'鮇 �6�Ф���+-iT�IC��_o)��?R��gw�yP֟Eh�t�����X��i�~aH��B�!E�PF��W:iH��$���J��jv��G�f���o�s���ߍ�bZ$�s_Δ}�[���5S2�L�G*#Ӡ��,�fW�Qo-e�=W�eO��B��X� �p���2��ۧ[=���2�S��҂����"Jte?Jɖ��)��)�T�Y�b��ׂT*Z�{m\����
9a9�HC���nU(��y�e��ݩP(��Cc+��V2���Ep��9��δQT���U�Rr|U��QUZ��Fq����k�n�K���+W��j��+y�4�hS40[us�H_�P��ec�8 �����$�o�O����Qu���lb�[���tj�H�d���N&�h�B7&�}ӳ������ǅb��XǈĽ>.G)]� E,��2)'?�8�Uc��ˤ�1���ȃ�`�h�B�t���:��1��Q$����2N��R(&=8Z���ͥPH��GӍ�o��"����d}ʄB�m�J@�h��/6���4��ݓ-((�IlF�q֪{�PH���ױcV�h���(p5HIK�BZN�|��B�n���u�a(�By'���L�x�}��Pl�_e߻�B�(��������Q(����Z�h�d%>w=�	N}=1���q�+�\*ʖ���]�;�;��!z�o�ŗ�:�A0K�(.�ݱ3�>��d��n��e�*�ܢUun#��v����ܽv'�s-4P>�,Õ��m�4I�;�P��j�M�q��Ƿ�y�l�r��߲LS���u�
�|<L��Ȥ��H��*B��m%�i1ީ��|����p1����ӏa�&��C�JҖ@("{HȦ��P\*1��J���Ы�\��C$4�vz�yL���vj�������R(��{�y��ƣS�r�Y�f��#4xW���G�)�m�g�Ti+f��?}h���%�����4BaΆ��h=e~��W�b�Z�h�y�r2�}�S��ɠn��L�ߧ���aY(f�Gۓ���F׼LWe=1�z�7�U�k�Z�����^mU(,���i����B��ge���P(��ҳi��Q(|�}�=��(��R��OJ��o����^����F����qh){�\�wK�tK��[/���$�-%n|��=[��(���F"^K|��l4��'��7��-      �      x������ � �      }      x��]]��:�}��<�z�:�b��$TB��4�n���H�6=��i�m /��R�
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
c����s�G����]�}'�-V�g�T����Hfmru��-7��<X]���Ep�ck�g��1��ǽXn�l�a�:K'|��q/ZN�>�UY��8_�?������p�         �  x��Zۑ#+�G1	��xv7��?���F��ڧ�_�z#A5|P�������I��|ڮуcT��s<�~�T� I��trٮu������q�k�3N��}�'��� )?�ȆD�D~ IN~]$aKRN��Z'��7ߣӣ��SOگu5=�ٺn�\��s۝����6�6H�$qղ�u�xJ7uݮ�S̙��z�'�)��Kb����i��@��C�'q�NE�S�o��N�I�r����\1�r\�1�/]�q\и(�qܩ�PI�S)	���H��p��Ge�z�m�E�?ٮu���ԋV�����x��7 ZC���L��kļ�hr���\�{�T�� �"d�0�`"�L�Ձ�^U"�~ખ�7�����Bu���0�"�n�P$�ZH�PB���`L���XJ�՘PGʨ#�
UbF�ѵ5/o�Z��V@ù��\�p.��
�堢f�`4�U���9��|F���vz 	� �����߾������Y�e��[�p�ҦY�Aq#���I�֤�Im4ţ�Q��U�I'[oNWd�əx���B�Y��+�j�k� {�D}j�6�Y0x�X]�9��G�:Mw��׫z��7cZqĮ`3��+-����E�9��nG�O;ƭ��_�!�-[S��h)y��*D*!�D{��O�a��x��I�<����@<0'���f&0��6P����^��PGR�	UKi�Iو��RU��zP�%��21S�[;�J#�8�AAck�i%��J2�˖��T�n�憦\���q�K4��H��j=MzW�2�`d�[0j��A���!AT�9��bc<Q��j����C��hZa[��tx�T�����%�p�O%���$�4�iR��?��A����S]��Q�����Q{2�S�q��ѵ�y�e�Fބf��D3�l&-���kc8�n���+����隭/����ݤe$�͐#Z�IW�6�Z�l&m�^��mM+ڒ4�%i�,��}9��8��9�-	�
�'2
�3�fD�w&��ft��(r��(�Q���q���
L����[	�;q���J�P�X��taM���٫��^�ɾ4�3H��V!8֭ �\}���n]Ԫ�r���voȽ���A��Jۣ���@� ��EY��Q��B^j�������a�%W�Z�o�8��G'H�N�������>��}b�jNEh6�V"�H��;����7pCY5�B"��~���#�j���n���>W!�1!|�����j��xk��K�J�q�ǾQ<�~�( �g7��\ߟx^�m��D�!�������HO�z7h%|����<����� �0�H�=������A��E�4^��a vg��I^"�7�{/��%�*����S��
+~�ԓ�ؤ�`D
y�p�8�F��Gd/
v�%o�6���m���n�W����>�%�q�3:F3zT=n�>�U��}���=3�A��d��5;�;����n[�4P{g��
�[/������a�jg�){T��%����� t���`��r��eL�#w��7����s�f������֙�릙x	��m����xX��^:�λ��@I��\B'zb��Y���&���! �,��!���ً�)�N����s���,�lp��_���{�q���K����xe��:����X����������x�5� $      �   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
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
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x����j�@��w�B/�0����m/L!q��qj.�v o߉k]�*DQG���i�g��!L��+���6n�]�v��	����02�D5[ŘU��UcjKK�i}�v?��JZ߼�z9�Z@���Fj��"β�fo������s�+iu};��&�d��q
����U�ñt���w��}6���c��B�,`�Y�ܦ��{�����W��a2F0�d�@���˩���q��ȣ��X��(�>�#c�@}�Dr!Z�R�9� RPO�r<>�����e"�6Sk��Z+`8�V�hj�_?���=׼���h^4��Ɇ_�~:�<�6�_���]�"�#��q�Sw�zCl>d�ꊌp�g'�S��x*�񿃼��r�CO3����n��8�A&�M�#@��d�I���6���L���"��D�M,��-a{��o�a	c���y�=Nζ0�aP�g	�%Af�E�����Q����.�R      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      �      x���ˮ-�������j@�Z]�ðQ��7��0l�@]�ߤb���Ę�6re~#B�(^~���o�������߿Z���O�O�����o����?M��}��_����?�����G�? }�?���.�?��������������1�cI��e�=ZF�@?���_�S��?���sA�ZПZ?P��������_�������������뿾��O���#b���b�h���*T�Q�i���h��>����h)�b��G�{�f[������]r����?�7�������U�ı��?��������G�7{��~����՞bǃ_����Tmc�x��xX�t����_9�A-{��_@�SЖ�����;��Y�&�O-o��=@w@�(����+�!�U�QB跑�}��W�TnE�/�������*�)����FR���?�ގT��/��FW��  ���7���­�_l{0��B���?�)<	�O��`W(�p�by���g՞����ɟdi*a�5�׉��#��mƿ[��<����v�;��%�:}���Oo��_HM!������J��	��J�7 �!������$�C�(�V͸��P:�/0��As��Ä���yN����/W_'����b�I�-��jv�H��;-�
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
A�T��V�n�8w�̆`�8����4v�&�^�����uV��reJ8��� J�|���{�]�Gh<���~KA���F�僊��Δ��,}9������poR�%�N���4;v��4{q!����\:�N�x��o�-���9����f!q{��w.2���Z%{�`��?5G���vJ���C騇4�;b�Nv�����7C�Q�� ����t�&K��!�kϵ)�?j]~�%$q���1�l�R���1T�>ˣ�Z�9\}���'�/Y�#e |o6]��T�~'�C�t�U6�|ѩt(�w�$+�G�����fs{�P.�b�m|JV	3���e�rE��?�)_��)���l:-_�rc_]�ʦ��r��%;�Bb����L���k����X��L�db^t�_�vg��@E_rMHg5�΃TqLL�qgӜ�����ͦQ���ٙeG��X�;w�+��	S�a�%9H��~K�7��8`|�s�M}Hmj@4�G�z@ׯu�w�H�h:�):��L�Ӝ�z�Y!q�9��>�Z��C!U��z����t��PΧ�$�<C�6G�~ca��i��ctF͵2��+#��P�LI[M���j��0��i��r�1��V_B�5�
�X�Ơ�,�ܗ_����z�<&�O���Ϙ�9d�鏱��^��B�aC�|�XwIu�fK��+����$~��ˢɽ� ��L��c�%<vZa6 �ռ'/��T�WRs�L����5�Lö���������PV��0d�uy��8�"��2k��)ıǤ�Eg̘b[�`(�3�	��<T�>������[D,1�0�E|Ɛ�����'��;��^g��2���Q��`�Q�W��o��!�տߘY*�.-�4�a�Z��݌����o�����~K��c�Ѻ`��6���e��⇫��'#L/�뻱�8�m?��;�4ڲ��`DPOݿ��x���B�ea��n�<-x��	f�sT�bIq�dޝ�{7��]F/���{�" W�2#� ��s�pY�˅kÎ�	�H�� �Ӂg��/ͯ\���66J��3�t��}�7�E�ѻX����}��>8_�Ƽ3�t6��P�;��;�	����(B�/��-�rپ����и6��y[^�+��tޖ��h���?���\�)o�;S�&F#��^�/mS�}3C|����"�m_�Q��u�x����&�.&�ls��ô�8�Ŗ�u2�ɆiS3��L|�R*�a�<Yr��R��c)R^�e	ﯦ�eQ��9����)���bCw@P��(��m�uMy9F/;eBZ��F���h&J�1iz�1���׶\M�к��m��8-��6J���⛚w�E0w�{ɜƢ���s�9��c�0���b����Z���cJ�K@/Nwv�a.R�����"��Xl���L4V���şz�Rf�A���q%iY���mv�Z/
/6��VD��e��InGt�1`�e���d`�A���?&$-����*���X�w�����Q
g=�g��Ry�D��ˎ�U�:��0-�F�!����m�E�k�z�|L���#
�������#��CGɗ�(�+��ֈ�/����
0ܦ��ä"+F�R;�r���Gh�a���iWJ^P�,�|���S�M�R�?��%-xĴW�g���u��c�b���ͽ�Ϯ�0C9o��Yo7�����{sa{�Ol�	Q'�&J�{�;�v�[�,���c׋q� }�7(%_��o�:E�AF[����� #L~�0��׌�Y�z����+e�1�%j��=沀aôb�;͍�0�|��@/�o�Ol#k嵋� 繷KF.��y�+�Z��¸Q�]r/�փ�o���3�&�,OD�Y��C�:�����	��Ź�풎(ꯈ�\!Ư2������<l�l�	3g~�o=�p��?�5u�٩��o�m=7�����(&���;����w�Z>�.��a��|l�1��N��ܖ��E,ׇʍ� C&X���������2l�����o�\)3¨s:|���V2�3���\,�t�#��Y7��ln�t\����*%7��m�Vtg���N�d\@�f��<r�&f����ϙu��&�s��Gn�7Eh�
S������t����Q�|�7�YY�S<Z>�n�X�֌�����G
X�}"H����gl��.k�o�^�<��Cr-o΋0�Է��7o�؟���x�%��.ٸ#��C۲�/ٸ�[��ƒ^onA=`,��C�E2`��j����\\�6ֿ�|X ��D��DC�_s9{O��[W�������/yK�}Y3�t\�a�F����w��᰿��
>c��\-̭��z�(���>�s��)�G��C}(�t�����j�Q��4��g� ,�Q��m8ɓb[��6ܕ�kdF�%֤��\֯l�:�-k��6�%2#�����/K�%v@�ӷ/�<�e���M���+����)��FZ��%7����&
� ܝ}��)ր�κ��9�}_ש2��ࣟ��K����JM?�<�y�`C�t���͡K".��>����B��Bd���#�ͺ��< 2��<rݾ)��#�'z�}SL�����
�Ey��~(��:���2#�8�׆�K
M���k��-�@S�_l��m�e����S�M��`�-�b>�.�HY*M�%��}�	�ֲ.    ��b_�Hn��~��������ӧw�3g�\�0�+�
�%A��ugL}U=+��k��T�fG�����KeF3������F�줺:z{���#�"��R���[L��{�H���������\̇3f �7�z����Sʩ��ψ~���A]_����<(�;/���L�%w�� I]5���<�A��Fs/���k�c8�X�UY0yW�°g��?�^����zږs�Prx3�'L�ɣ�_�p�քJ�]r6�)����{���Q�(����b� C,˦L�2#��Žio�4�����w��d�K
�����[0�|!��3L6V��Z�$���i���e�3�^�ڢ��s��3��tcxƌ�f�v��ǰ��Rz�s��c5m>��{~�6��a��~�z���Xr�=V��[�U>��
�z.�Q�v�^�PrK8��IS�o�a��2������4\�Q��zA�nY����澔6p�ڹ)`���=rS���|ꑗ���#��\���M��Na�,%G���e��ro�ˎ�b���	��ɗp��!ŋ[YF8$p�0mT�F���9|�TSQ`Z1y{r���b��j��m���&u,���`�h�}�Z&p�1b�&�-��~i�0�P}���j���5;�+�T���=Wˌ0z!�W��+��g2\^�eÎ!3��P_��e�1$���)��cf
�o^��CnM}�uq �1d�Vt��\�r��7��m�!V�)`�_P�d�Eb;>:��)P��?��V����k��1m����a�/	�#���ʹ|$̿u�!!_I��ˆ3Y)`��sY�H�����$�7��Y�������غcŦ>���b/K����Ck+�e�y&�+"��9[�C��=�io%�e<�?]gũBuzbD�)&�۪��}� ���wzbA�P�	�PD>�n��Lܟ�;cs��~��L\\�J�m���{H���~i�[��5R�NtY�~I��u	�~ƌ(j�8=S���X6�W��D:��FoxX❗t\� �����0f�!��͟R�0&H�14�>��\���PmK�kb]􊏘a)X�N�Ⱥ�cu�/]qR7�zV0mig뗮�#FO����0yA���s��n��K]�⎘���ј�ɺ�;f�n&���.9� #V����\�DƆ�}��Y�f�$��wJ/�|��0��E�zXR.{(�1�}��B�A1.mqe,��òrٯُb�,������+#ˌ0�H�<�?�6ʘ�$C�/��Zf�!����&����S\����kr#8����,�&��z1�9c{X�������W�~#o��Rv����	�՗��"�u����rXꎙC�UC˻Iq�0�)&5���S����A\�M��#���Q�QS�"�@���z҇�;�j4_�˲j҃8��7��;GK�3��`	掖Z�XƎ!+++c��q����G�6�e,f�����E�O��F�"�#�������l�Y�"����3.��#���9��(�sx?$�l��I$.�dR9L�o
��e�A�7El|����bIl�ݙP��G)��{p��䑈�((��WW�A��r	�)�L��{����kcV��1ܔ��/Fę�`���ۻ�0)�@�q�<�ń8QL�UW�9,!�wk�M}2���)~(����"���KWܑ�J������mf�L&E���1.=q���|(�!=)V��`�}t�(��ҕ1���lGO����L.�8.-qE�˲��D�n��)ע_�� ��b8�!����a��ܞ��y��>;:-�|[ŭ=�R��Bh�:����o�DCh�/׹?S���:�{�Jᥞ5�P�^?ڔ�Ϡj6p��S��!��n5J!��z��t��ڛ�#�ԋt�j3�G(�?,hɂ~~ٱc��@+U9KǏ9@O�_�T�� ��D�OP=3��b��R~U*&5A/���:�K�z�TkYw�v>k/~�/r�փ�v�_:�6�E�u���cm%>�6�Y{觔M�j�`���O�"�p#���~LO��n�9�:��ȓ�����A��씩�ެ:e�\�'g���E�ePj����51�Y�������8�� /�=��'��o�����-�<�x�4@���J}��x/u�]����"
 ٿ���Uo�sZ���5o]V=�4l%�D:S����05-�D��(�7ߥ��L�:���=SX�%P�ig�v�ՙ]��Fjs�F>f�L�	�����iW5����>jͭ m	h��}��ȓ�Xǆ�!�U�@^0�m8c�i.��1�db�iP�r@���Cs�Y�����r�!���+iGD�s�~�\^s��l��$s@��rY�
�W�E��e���[ȧ,Z�#�!F���Ѳ߲n�9�W��n٠e��h�1��Q O!FB�^|ra����A�9`}D�bDaP�E%7�+���F@��L�'��Z��� ���7�{R�M}�YQ�3�g�Z�~�c���3���!O F�&�7?�4��Uv
[��Vf_�y�0�ti����7��Xr��D9��>(z15W_���nW�A�6���@�n�$�>��(i?ID�Z<%�E���� l��r �(6;��ʹ�����~Q�y�z��/!�K�0�X,����Pi1��?j���C[?R�W��R������j�1fC��[ ����v�lB֥�ˎ̛�"�Xj/ ���wL�Ac྾�� >b�bll�8�A�~�1�P�|7?K8��((�w���qWjD!=f�6���f�����n�/�Қg�x�~�s�5��1�~(O�/|�<p�<]����*:�u��>�Fo
[�����o�����F���C�"[y����"�0,�(S/0�����j˼GȻ�����!+!@��C��wƐ��e�N������Sa�������J�0b�Ӗ�J�Ϙ:3e�I�v>l�c�rAZ
I o�;c�I+.<�5�0�L�a�<�r�1�!�۲��У_3�E	���\Z3�P`����"Cw������t3��L�ɛhSX�ρ�o��I�hJ:b)���S�����lrN��lɼ�/��ERe� &'y/;f�^��і_��� c#���k�����v��8ʫw&�̗o���KL骿��a�́ouq�07�
a1-�%OalG瘙�ޮ�b_��
>R�UzkNZ�T��ߔZ�x�+����v
�aX��r�庚F��J���Wϐ���c&�Ռ(֡�:��8Σ�b3e�1�]䲚g�����K��[D�Ձ���#���b&���\�|�K�툱i;�+��$r���U҅��\�oG�~l˃,J�D6L�7��,�K.��Yj�g/��ccNj(�,�ː W֌(hy&O�� �R�Ԉ�_�wo}X��ta���˅K.�`v�@����zn����Yr�����&n�ڂ���;����8]o-\pG
�*Y�����)>�O�U&}y��ڙ�ױ���k�v뤘F-���C.�Q�ʦ�����w��e��\�__��[��r9zO���f������js&�ڈ͋=X�h�c~a���;��&�]���625S�]1�����2�4F2�0�al����c�ñ��#E=l�V��0y�-�T�E�_��j�!���V[��.h�vy%���R
:���=SP�$����)�6��Ԛ5�{e��5wa1,m��� #��
3����a��E���XM~�&i�v�I�'�ƒ�j��ҕ`i�G��M��V��N5�~#
_7���[��bf9�:���}(��;j�}(��S7�Y���n8]Z�Fc
|(�<�oʐ��[�dN�-j+�NX�$��u|�2W�5q�#���h�悚�,v��g?fl+��s�ԗh�۾�.m\~�xr���4N��γ�p܃��M���I+��߯�o�I��)F�w�ဍb���E\�כ�G�.`leYxy�l�N��0̄v�\M3�p��(��&�1\���0Wӌ0<�U����w��3/n����G���ҫ����x�+����OZpU�Ǽy/�t    �%[5m����zÑ�{S/�-�|1����сs�%�S�i�&y�s���L���xr2�xI���
����\kz�B
Ba7����3�ҭՏ��'����I��f�#G?�K��L�3��M��Ҋ�^P7�l�|��m�	���3E��M]L*��vL�١ޗ6y���+��Qιʳ-�w�0R���b��`��1�������^�f�N�s!͈��bxs<l���4��d�y�Ś0�kQ�Gة��z��P�?P���Cf@[�c�4�K�-�@k��/�  v�[$W/_抗�[��6�&�@�}3�6��MN�z]roGJ{U�;�V̥n�[�&�ۈ�e�7^Z�����`����V�ߏ���̻ؗS�w �]Ro�7��J)�����$� ����z�pȋ��wl/�oG�^�4ؕ��l~���C6"��/lF��-�lř��
��{i}(�B�[Ɠ�g!'�}g�鎒��E=��jϬ���m=)�MrR�B��D1�J�����ƛ�³�t����.��Ķ����C�ـ���l���;�K��ïfs��͹� �3��@Qhuqk/y�#F�!�22�K=���q�o��Q6x��s��;8��3�5�c����e,���pƐ��x��'����K�ZE/�����eHG�#���p?h� u}3�ַ���z�i+���+�Okx�jZ^M^;`��E�%���&�X*?�a��E��{�����<ӛҭ:�A��� 2���@�h��U֑m%c�2��R*�|�`��]I���p��5�^4�.�o�m�/zLn�"����"�s�t�;b�4J�7��7������ؐ��&x�Q���M��;a,(8*,�<���ch&��J�<&3>`��/��Q͓�Fσ��tQ�D�0�]��qQ�K\�)�+R�EAe�k~�uV˯���3�/=���C*;f6�S�RLnJ�u�%Y�i�T1�U�W��5L˅��W]���e�����.K��K٨=1����xi��K..�@tw]Rq�j6�F�C�;�k���K���"��g������=����کLI��)�E1	��]U3]z�V�(2Kg�J��!�E���(���'v�2��i�.y��Ҩ{	���V�M�!��U�K.����u˥?1���)6'�� W�fm�(B�7��D���/J��wreu��2����V����W3��6�U�D�L�C��[�?5�����#9���lɼ)��M]ܖF*�QL^݉���#h�fف��ᰟQJ1)����|�]D1U��%?uq?�,?O���4��^������~0��!� C�����;m���������C�u.Xt�jƖ��tI�Yl2�k��`�����!}��[�x��P��{�����b ���;��Fh��^����=c��� N�;$�1}^�z���8tI�1�*Uz_0y�p��l�.l�U>�K�-�4����~#�0���n^��.�� �&�d a:M)���.�yiN��u�7�xb�*JH��#����Ɇ~����!ż�>�X����M�#Ʋ�L}Y7�H��c3�|QQ�"`�M�����}��Z^����&}�˒�_��W`�i�5y}��S��rq�+0TV����^q����kg�����u�t��:IY�z�t\�A��W�u�%�*Y��P�c`�/�X:��`�35?6�,%�}�3F�%��y'=�c�u�m���<q��j[/_���3+4�!εT��wb�t�~tI��9��Cɣ�Uҭ�ׂhC�i��%P�?�d�h�������\�qE�Ko��\-�b%۵�[�B�ͮ�6	�ڙ��C��"�����ϳۭ�n��6���%hu��<R��6��eh���t��:��nYͷ}�T��O�F��2��+g�85b�(s��^�+��`^B$�Sh�>�3��rVdR�T��ϠV��C��9�������V�B{��@��i$/u\T�a�nkJ˶�[ 8�sB^\j�g����[a��y�݆���F]p�]+&ܝZIg��~_Z����7��Bo�&_Z�N�n��xK���.�<�pډi��S�D�f1_z쎘��+Ʒg��.�t}(�K~�O��>��@�;_�̗�^�ѣ�hy��u`d�g��h�ǋM̘�X�2�C]��3�-5��^�Pg�uH�ɍ?덙ʇm��&�.�����W�E��O*{c�K�u}���e�����N�AS"��.9ny�󑂯�[�Ͷ�vY�gJ�-"��b-=��v�̑���&�"���f#�{���`�,A-�7��cC)�{B�S��K��H�x_/�S�)c!�:�:,+Mȼ(?	nR�{B����[�F�m_�j=��u}����zU/�%wO3i��5�br+"�L�	�����$����#Nk4
�����=�l���oʘ��Ⱦ$��	y��1�2N�V��ns.%�el��β�K�_.��;O}���(�Om5�tO�)����0$�1ݦ��q&~���:�|ƌZ��Jb��e����Q��"o)�a�{z; ,��E���Ѱ98z������|H�|����Ͼ�Kl��@��b'C^Pt �����~Zv�+y��oJ�:�а�'��3�U��.�o@�:��-�t����M!��ڄv�[��.75���f6,s��JeGRx�@��j�,g8^�3�2}��9����3E�&���������T�h�2��*e��T��Q�C��[�A�����9*��h�R���\#cz�F=m� �<��}��m�����7�"pP*�p�:�_�\oT�F�������=R�Qa�3^j��R�-¨��_�Z��Z	�ä%nT���)���b�sY�L-��*-�]bh�al���9?��/�vGJ{ټ7��#樌��,C��f�f�c��rb]����Ô籆�
60�=��>S:����S�b�g��CKl'���0�^_]0i��
��E�*�5.��.r������B;f�zM��c�az�KƝ岄��f�����\	��e�a5��+A.����R�y[��T����(�^i�<������Y!����*�SL��5
�&¹�e�A�fY�J���SP�u���<�%zv��Ps���ӣ�;!zĉ���r1��N�Y�C͏�3?�At�B���a�M����p#v�V)��Ā��l[hd�ղQ,ܧ�����������u���m3Ь�}�JV&WP.�ˀ����.H�D��u����"߯�	���\���"
w�HM#�g�e���z���ō�1���i�J���'��l���2�DS�)�T?$T�%�K�)l��-�� �)�a�еn�>h�H�'����[���}�NjZ`Lu?b:��N�(y�-�@Y1iڍ�~X0D���p�4�aԼ>�'-�ܽl36�^/��ϝ�;Sp��;#F�#�a�K�ܜ޺�7����L�Nߟ/-_���6��Ls�vpq/ɳn�]�/7�Q@�kĔ���S��V�b,�l>Z.b���V*=-{�(l�������O�5�TfN�4oQȤc�oI��"������iE[D����2	&���(S���^���亖�
�|��Y7��a�]�Zt�%O�E�^a��a�E�;F̹ncvK9���=c �2NSF~�V�0�Κ�TKC���uf�r��$�;��cfDfX<{LZ�p����ޗ_�wZ��e\���)�4ԉ��^.oQl��씼�n��LJ��^x�=vg�x�mt�D�m�GR&e��f�Kj�F�a��{����G�5dj!o��Җ�#To:@�����0�Wk��!@n��e�1V�������ʆ1�.��V��`��`z���L�^G�n�6Y���(
���F=�E�U0O^l�����%���s[2O�E���E�G�iA�Y���\"g
��-����˝���i��%�v���ؖ�W�v��R-[+��_s�"��HAfn����e�TQjp*B��I��>��|<��m��!�.�m��/�Q����<NR�s�"���K΄rǭ��4�E��#�b]��ʝ12�    h�P2:*���(>�m�y]�D^|�B(�=��c�&�떄� ��Θi������ �u��	ϼl|��g����U �$��i�2}(����mS�w�P,|Y�'��z���fY���
(ū���C��2�Im���$ݎ�xQ.�Y��3�1��)��֬S�ó���4�H��A���ȴ�Hv��^�Ҭ��Ŝ1��r�<]�3�͍}������J�y}x���wR���ɀ���C[�y�n�-�J�܋����F�)l�TS���!�Dl<�b��06`|1�<�6ůV��*{�@�ar�-���®�I1�7�U�A���Y����{���<+d<�bL�ufu)�rs�\��3E��$?{�!òw6a,�:_���n�&_���0�X}I��S��7�PQ��뷷�2m��C�o�9ˏɗo���Y�G�����#�Om���pMk#Lו�|�\ؒ��0c��m�99LnЭ-�+N�7#�eؒb.�v[iT�<&w�L7	��0S�2����7+@�d�ھ�M3K��T7��%w��u(��RrG��g0NՃ9[���ܗ\��Q���Ʒ�m�p;L����mL�h&^�>�r�!�)���_)��-�9׭��ؘfO�'J7w���=���(��	 (�A��=�����%�<S���>�"�i&|�oJCf��{nAl6�vg%��t��-�#EW�~��rq�x��w�8�3���>Q��q4���[v�,��L����/�É��xe\̇_K�-yQX����d����p�e�ɋ��d��@/�.g]>Z.Mk"��Xg�ut��<��yǠ��������GL��ʂcy���pƨ	��~�\�o]v͂��`�\��	C/�2�w��Gr��c�.l����A�d�1/v.rQ����<1�F��I�`��=&���jB�$~�A��G�1Î=)���_���f��㩉�0�0zb���£�Yy��xٗ�$��-�V�5���[i�3gZ!�6%o��0js"��i	%�0m6EYJ��_���;�}�0yn����y_��+�� �>5��1/�	0`�ۯL���X圬i���޹���mV��1LglD�I�&c.pQ����K"c�uM��L���%}I�!�[GD��s��Ԍ�|̺=;��K�D�dGr��%���d��v��c@���L����
�?��-����Z�l^@��G:/Y��~i��U {��Z�b����w�<�P�w^�D_9�@[0��j�q�&'!����g����
�y�\N�3Fo+�����gc�����ZҐ3=������2ʀ�G�*_�PvO�f����\��.�Kx��p�uÌj��ۖ�x>d.�p-��U�T7�����~Y�+/���0��'~K:���ox�ݵܭ�:%��a�&"/�j@�1��[_v��� cvey��Ǝ�a^���;c����@=&����]낹��3F��"�P�Is�U$S_��A�����*>a��X
ly�<��c��T�l}7�#`L�g}7i'o�֢����-U礹dO�1b���1y*��W����57�L/E��Rk��a�Q��ɛ�d�̴^o�JOM������W�KA\~K�� B������Xv
O�E^�Z*&�!��L1y8��M!�)�0��\j>e.��EW\W��'�
>b@��eڋbjZg`*Lh�Ƀ��vL�\WMY~M�0V'�S�5�4w�� �eݴT����� } _ʨ��'#���棄V)��� �m^��56��ު/����TS*�uK}����2-�@#�r�ܚ@�1sbrAY��z���Fˏɍ	ĝ2���>�^{nL��Yxyù1��cf�smu�-�)@:�����>�NA&��ʊɝ�#�Rj��K/��D�00m>ޓ�5�޸ �Ƒ,��R�q�#EO�N�<��	*;��&�t�Ŏ����(d9�.���Km,^�Kn��+�]����u���;bH�էyL�׈0����ܘ�"y��n{�;�V/����@�(�k�M��"�J^�3~-�I�:�g�R�#8��$��)������D�	�P-�A�J��sg
���p�܊XCo�,n��o�8sg���]A�'�m����q��-�P���)�x�jc�
ם��P�t��:�s���M�t�1:w���L����ߔn�8�\�xY�'J�Eܘd�괿�Ӧmf+E׼����$��C��+�o�$��C�ȥ���$��C�\K�R�z�FA3[mf"��.�Ù��lui�.�4�(@V�8'}~(�Ax�"�W���Is!�E�/��p�Xܴ4��,.�����ZL�?Q�XoJW?�ʚ�o���
5+#w�<�PX!�o����L9�C�Q�~7�B �l8����#�l��_t�����\z�r*�Q:�Z�\�״�R��\t�$����M��C��p��;t���!�I1�f=t�+�{DiV��s�(6=�cT�kx��ÔYlE7t��S���7�����	� ��y�N��-h1�{1��n�\pGJ}U���\��7l?�I��%�p��B���r�6�N�ڵW���P.��3z���%��;̾�w�є�vI�)�ZJ��i�y��Sd���0b�$�
I���`�x275�Hc�e����.��L�_���n�]�����g0|�K��[�PgLcr�v���j�������ͭ����W�u�����g:c��0�w0�Q����k��VV�Ul<N_�^����x�e�1���_6�.;a꫌Y@�0���$�OO���Vu�G�A�4��&�|�����wsƨ)S����:`ڏ�^�i�c����.�� c��nR���#�/��A\vʜZ�2�:�Kܑ�^����(��hE�o�[���Ԇ�(�����ň���3	(Ԝk�.MpG�Z���-��I��$ϸ�~mC�)K/h�4�1��8����/k��i]�%�!��ׂ9M`]/�o�B�9΃]��%�b�P빊�V�Y��'PK�)���1��3�5�J�Ku��5�X�3�Bz��T�O�Sk�i1����pT�i�!�ǄP�����zq�L�����⇟	?]S~��QG1�%�����a���L�3�3�@bD��2�s��2�4�{�l�|�cA=�;�F�i�e���Of�����ٯ9bԢe_��F>������h!io%]�2��n흥-��G���rm�5��4�v̔~)�W�6R�7�.?S�W�^�0���-ȋX&�3��`/�,��� Â^�U1�5<6L{Od�����`�S_�:����*�����<s�sY�g酵쩋b���ƘJZ��9K�r�4�1��|�k��Ց�����9	�:�N�vi�0�]5��a� P�3±�sY�g�u���frG3��;����
����²į�0ɉw�7����P�`�v'L�ũ�F��J�ɫ� ����0�S�ê��p��vIR�Q>�#��-_O�,��Y-�%e9�|��w�B���ņ�	��$�S��R�o��ֵ�,�8L�|K�K`��`��ߩW;:��/���Q����_,,����vL�9���E53�P�5�y�D�Ny끵i2;L'9b���/L^YĿ�iN	@���z��=(�T���=�(�S��ˬ:>������|Q�(�sqrL�|�)g�wS������qj��P$���ZVcxJ��L+��bB��yJ�)(j=��kS�ɪ
��	�H��Z�^��*�)K+������~��R���8@w�����o���ҲS�bﺧ{��*0�����&�f�J0+���%�/�� �X�|��j���p�}xc�_҅�c�M�%�u���h<�w�'��H]�Iz��yǘ�D����C{����Pk�Q(��
(��]UO/���J�s	�Np��~��;RLZ��iUvX]u�Qr�
���zH&�%�/��#��ͩ��5/��`k.�a�$]}P�y�^@��Ne�Wxr|S���P.ƃlx_o�І�-��L�E�,���1���%�\I��Flj�
��ӎ�p{��    �
�t\�D�!������-{�D�!��Qe)�w�EE����v)67ot�[n��:��rg�%C���bݥj��p���=R��]���<8��!6�ҿ�<��9J2ޭ�s7(f�:���<l��I���zi���~UPpP�?�=���M���yHt �ܜ�P�"�6͏5��q����@l&x
��YvJ���6=�.�E$3� ��R9L*��e�Ц'e�<}Q�Lf�����l��jڔ�3އԪF�s����u�%������mciw�]�o�F�;J*��e?��3q@=�݁<�vČ��]��T��:��-2�2gP:L��Ϙj� �ϝZ�\�}9f��Xdy��>c����\���W��F?�����"�P��vK�%-��~w[�?Wu�����������N^L�牷3Ɗ�px�̞���oJ�x>h�g��[�AJ^0�����q�E�lw�K�b?�)���o���k['Y'{q˞��"�2�?�r�L.�3��wݴk�,�&=�#̨"岄e��ي�S�a��KdF�Ry��s��3
-B=ϼq-;��`�<~	穷�
9uL��"���}�g�JŸ�1¨�\��:�u�t˿�̑��"�eq�5�Ϭ��6����5t��k��Y�Q�	d�X�-t��sL�������ïZ���Y��[<��j\7�[��
���M��U�ћ�yY7i�,� J�:���N'�7�{R���ν�4�=k�k��F ���.L�W}���]��)`X�J_��-����1�\��ղ|�M/��wDtN�9��c�F�� )�C�D�����`rw��)��$˥��)|�趴�S�nt/=�1z~����xz���U6�P�Ж�3̌06nnY}y���c�
���}�5�1`lB��cR���"�N��
�F���Cs����^>�W/ �`�ѡ�d��W�V�p[�9��&�P���<w��x�+���e�;f��=kڂ��p�Q�|	�M�K��0�g��R<�4\���|�$2r�Ln�aL���"�����2#��w�u3J�a��L_Wd���">c�R-˻I��p���x�R�KK�zY�g����F���F;�ފ���1�5|�Xɵ��<&�x�0���qԴ�o�1Q�^k�FzGZ0yX�Ɏ�CѤ�,��\�_��˯Ir��XԘG���^6L&�'�Z���5`L�`Y�-���0Te�5il�{�1s����_�#̌08`Qj��I���[�f���د��8����u7m-fg_��5'ֿ�>T�1d~�0����䑉 ��K#�h�=�ǆ���P����U|� �E�u䂙�_q��P6$�%?G��Q��)����<�����������U��9���3����r
�Ny�&CF�r9��������/g�2�R��Y|��N���d�2v�Z��:��{e\��3���-�<=����J���m�Lyz.�X^�I{�1�LKD�ˉ����%��Rg�=���PfD���>V;k�R��/<K��=0g�D3V�������7E�3_�4 ��(�8��$K�?��М�bڪ�q�K0�@i��vuI�d�!�I1��Zٯ�\&3��A^;�2Q"O�IfUJE���2��n�<�m���t3�?���}�M
�Kl��;^�ܙ�/���������Yھ�o;�'���
6��)�\[D��C�����{X��5"�'z5r��3E/�w^�C��~�t4_���N�c�}p����I��b�����d���;�bo�����K�Hѷ�sj������"���jV���]��2��}p���n�iءi�:�c����� �{��Aip�s��C��g4�3��ңǟ�Dܑ¯�MB�QϾ)������(v�M����'�zK"��]јS��y?�,A)/����Hy.�p�%g5.����lЧ&^�� �$���w6��a�D�o�̙���6�%PF�,_<�����W��j�ݥt����٩�.������9���+ΎK.��S]��T��L5����!�`C�)2�����K���PI]5Y�'����~�p{i������F� w���A�	K�n�?��^�2�o������\�#�Ta��~6��'��ؿ�)�T+X��%�`�>�>�%w�F�1u��{L��-�Ґw��h;�&�LJ�cr����dʐ�ݤp<��S�j��d6\Ro�&���Py�w�Ӧ�m��3!W̌0��E\J^�a����"Լ�r������j���#F�`uY}��:���)���2˲���`�`�������3������$0�a���5/��az�R))��P��{;b���w�G���P@Eڲlr3"���iIh���Sl �������J����'t���"�M�[1�E8�Z�gb �Ua�!��&?��̟ډc�5鬺�����$��W|��2��Ro�+>c��������l/@�0c�F�t�%�pI���|���[�k���Z��{����K�-�3��Ϫc;E̯T7a����}��1�@��?��Yu�c����5����7����|\�S�6z����E��Yg���1Ў�>�bX��K
.��Z.��W��a�q�j����5|��T�Z�q����`�R�����J�������W�}s��E����S"s��A|��Z��oɣi�:� ,�<1����t�� �Ot1$��3�E!���7e� �C.���6��-�Ci�ed��x� �~x�U)ϔ��ݔ.�O�w��1۾���.f�b"�����?��z�}i2�K_���[���7vb�1�Z��cq1�.9�#��v_���8�;�@�T寓K.����C����t+�u����_ͥ1.�譴8+8��B��'����>�#<ŗS��{@=�:�-�쀹�`H-�����0"C�����$N��zT�q-�^�8�&��0j�b�&p>��6��\ԣf��/}qei��tzG��R���1Y�'o���{�ZP�����(��r�Q��P��愩`jR��Q�fv`�gq���+RF�);�J��I���(���z�����������Bf��a�n�\��L��̊�.��5��a��o@1���'�-_č2��@k���[�H�cN�Im�9�;a��\��K;�F�A�6��������eK}�*LA������D�/�8�3����Ϳ�K>�Ha��%h*�������KJ���,��$�����U*��&����u�ғ<�A��+�5�؝�,e�Ak[>x: ,°u�9����3x���#�Xr+8��qd˯i�0��&��DX�r�A)�)�M��j��9Wی4Z���O��0�/�_͙�C��3�1� Ӆ�wO`�뀩�f���hQ�Ē��f�+�MF����8�����Ǝ��ѓ�p��Gq�QF�yn�S�cxԥ�-)�=���}�v��">a�ʁQ�wsY���}(�
�k6Di7�t��ZH�`&�
�!���B !S�u��AE�hG���+�W��d$6�>��9�	�A[�>����1��|�l����-��d�?��3��/�Wf��t���a��� #REfly��C�����¡���3&�ċ��<P`��-����|Y�_0�ő�5A�����?�~(c�T���ea��a��U��o愱n��/i��!+?�����x����^6��� [�+}�3�2��|����gZ�ļ�Y)��^�w�/�#F
�{{J^o�3h��,b�,�(� ��L��	x�����yK![3�Bɗp@�c|��R��0����jI���N������.��(6i�VGI���ɔ��~�$�N/Y��" ��o��ӛ�lpO�x�'��I��"IVW���釢f�j�%��3J�ҋY����^�|�3,Qf�<Q����)7!`���g��$�wržV�����2JAr_ZM���!�X��S�E�{�#��׮���8~�w|SƘ��M�W�@�o���˗�(�$�7�t������y����zK    6\�MLG0�{�979{�y��sx�૕UK1�pDYL`�+6�6L��li}y5�s`HW�b�a��f�1�r���,u1 ��1Z�+�c�,;�fǆ��C],�^��E�)��06�Ϋ��%�'e��@2+�3Z&_�G�>����3ɡ`�I�,�&�6K�1�����O��%�`�����\K[چ�*_ǂ�x��ǜ(VCµ,�&������Ә6�Q�㎔/� CR���9_�F��D�d�d�����B�l����ź���j��z�s��u"�&&����Xѐ��9oڗ_���߈�3��_<D#�Xi���꿋j%����,>΃G���muO�������9��?�J��ӡ_���c�0C��,Ӱz�P0Gx�>\{9N	���޼ <J��P��"p�E3��Z��c/��	0,ˡ���4�ۓ�.�#�^�\0�v�#x3�&e���ɷ�\̈3E����D�d����g)������0}�;�����z�
��w���4�_s��8t�Rɝ� �m�K�r �F�s�����䑈#F^�,�1y�/�u
�L%�8�#��,.�6�	���'
��%>�]��6�qRtO���sӥ�.��p���7���f�ы���j*�*���@��
;��jj>DX���*�R~}#x�v�� 6�=�5'���wAM�Rڎ���c�I�����PMcifT\$(ｓ�7L��0����h��|�Ь_N��Ƃ#Lc`1	�GߩÌ�2\H��t\Da����g�B
���Dʳq�ׂ���^p���d\D�d5排���<��@S�2�����³�WV�k�{�Θ�[r��\���3�>w���zX��S�#J7��#�E���7�*cU��Q��'�E=����v�[���Vn��j�g�[����g�"J/��\��B���#k��oڈ"�#�˹{��W���
�3p����Fy.�XѾ�����"�e��[�#� K��bRb���ϡ�0��`L#����&S���vϔ�7��.k�LuX�Ӈ��0�����)�z5Vy9w�r�1,K)�}���N�am\�S�|9�J�al�u��\��~�spg������ಂy�L�M5����Z%R�0S6�a�!�Fj[ff���n� #�Lm���N����*<{R&u�"��]v���s�Զf"�&P�.w��7�N��e@&��,����B��3u�Dy��H���r5���P�N�9ZOP֏��nƮ��VAH��[�n�R}��c��R'�������潢���gy�]D�6��&�ဂ���)��پ%��!>l(��t���)(��H]Bgg�N�h��=�1)6�Q�x4�U/#��K���'Q�I1	q1�lG��N�.����oQ۷v��%�;S�K��{�׶�V$h�:mͩ2_��Ū	\ݘ�?0e�)�f�}(��L�9�~/r*�"������w�P�iaP���:��Yj�1�o��ih�r�)���B����h͊��I6]M|&��r�0�/<D���l���T��"���������7Ŕ"�Oa&�O��ߔQ��2�9����o
�9>�C�d-�m0�wV���߂O҈o��� v)l�K��LizSWO����ť�(�9���s`R�S�ޕ�r�{QL�ڥW�������ݪ���įP���>��y�-�X{'�ߒ���+B~�ƽ��yw]D�.���A?��Mβ����|S�J��Q.>��b�j~���ٶ�����Ϲ�w�8,�
��F9ϵE����:�gɾ�aַ��t,�\��15G�yLs���BH���X0��0���Wo�ab/���F;f��ջ�xY>��ێ�Cu�����񎁩�\��A&Χ�E������O��0��%�Ǥ^�T�0u^K������|��C/���C�p+;l3�t�=&_�G�s�?�Z�q�X������o�;E���"ԍ���|1U_o���]��6LsԬ5���tI��N},��k��c��^r���\F����ऍC��}�7�pgZi�L;L:k�cLtجE���\��'��פU;Fo����w?p�˘�x�¤���ET/�͛�[�m���02�_�&����%�E�L[(��ۙ���}(�I��M��X�n��T||�^�i�C�x�^���؅�\L�����k~������g��N��%.������S-�C���3��3����߃;4��ea.���y�[DaS�po��x��q7�y����K�-� ��?��$�>)����q.rQ�����|��w���z(��g}b�jCpy��$��M1=a3�ʸ�1��MA�C���߳���sᇒ�[�>��M�!�,��G�^GB��S�<ᶻ:<�X��(��Kn6)�2�97�o*�����誫���n�ݱ`Sy5�!�:����E�F��Z򊇀���q��|˵�N�>N����rmgJ�V�[ty�����j�Y��՘�E�a����陘�ѭ�;
9O��1&&�K�������YWH2�z��܎�E�>]����=cz��W�>�Xs6� �L
�ɫvھ�BQ3�|5_yl��?c�JKD�s����2
/a"έ��o)(_�V��9Ln>�D��Ĺ��ˎ�sʋy����G
��XV�p�;f�Qd)��|��b�1ex�0���Io;f��Z�YZ�vn����e$U.��wZ�BQ_x��In��QjYB*�z+��u�{��H'��%,a8ɗp�i����<�5m�&)�)7p.rQD��{�;ޤ�N�ck����]��H�\ty�-�p�Җϔ��:��M-2l��F.�� #����Y$���0j�Ay���p�5�|�Xy�M9��TM:�6��UM��[��"��CA&2(]v̰�ikD��L�3� ���䉌Qv�h�i�����a� #6��=�bK,�=���������-Z�� g�yv!(y#�����bg���F�����f}(��刢�\u3U䒉[�����O���]Rg�~ q�����lҼ)6S�;����;SĒ;^?j:k�h�5FԚo�)#�Da�~��bwfo�|���g/��"�X'�k��)�<~=�L�T����$�Loc��Kn��쵣��K.�(c�'[�|G�1S'	G����-���������է4pj�|��"n^��rI-�X�˥R�fɖ��)��hV���$��~��?�%�6`�X�G�l�\�oG�����Yj� L̇���a�/ܽ�*���#�'��'��~�~1Y��+�u1�;syy���a��3�"�`�9s�R���H�As2��R}\���~t���"�V���<K�_�U	�yR�����\�2°�.���R`�L��D]��Py�c��\x���ƞ�Z���G.Mp������#�	�z���p��w�境�0c��V�W��挱���!�<�`h�I�1��',6r�M��v�Gk������@^�~�X����1ȏ�#�ꀑ�u	��z�o��T�o%?�H�R���wh����w�J.CQt��鏂錂�E~S��	CrI��W-����c� ��ӷ2Ŀ��q��Umy
<����r��S�d�6���3v��i�G�7e�xF^��YV��2!m�?r��3�^������L�:��UwQG�zQ��(XЗ���LvvG�qXHb�M�E�����e�(�U��~+�#۷~Y]l���<2}�)��F�\n�eۦ�Yy�Tp_w&��� #u�s��v�SYd4�������f�Z��y�!�X����b8c���Aɧ�	����� �y��%'#��ݸ8(���G�ګ�x�g�)��;f��
�>[0��{��4��`����ZhǈyٵB�˻��� 3x�O ��0��1�|�`A����3�C1=:����3f@cy�Gv�T4���%]і�#����V��.����ȬS��G�\�e+��r"y��7k��@g�����K��L��:�E.~�~`)e��Nv�%P~����g.�z�0�/iϮ8�X��H����߀�j�}�Д���R=�tؿsӒ��    bUJ��l�(`�`uqŤC>#L���f��.6ǺYtݴqM���7��PB)��]�Kx
c��.i� ���(n�ռyh��LJ�f�ѧ�KM��#
�Dt��$��MQ����-y��L'����ܯ�Q-������{I��aJ#~�Z�[��^j�tOL+--��͌)��|��K��c�^j�ߍ�޲�:a��xj��S��gF��@5����K�-���
��[�B�G�&Է�6��ׇ�g�
Vq1��;�,h��e����(�b��)]�d�~fͿ)zͶ�d�,����9�i���~\Z��E�/�~Y�gL����z�;��^0;�h����~Y�g�-o<��p�P�˒����Hh��pF�(�fW�%�9��P�ّ��
m��J�e?�L5�X9dr>F��J-�xi�o�����r�Ԃä��=�J�j��R%\ �aG�7�z�<��tN�=c�O���@������;�yƬ60QB�n"�;{�T���#�m)5F�g��-~v����ه�5�GL�����1���1�tM�9�m��2�p'���<�`�&���:[gi�3[W�2Hޠ�hf1&�:p�5�偰a�̸4�f O� zH-3&*/���sq���0�c�\V�]8	�%[��cȬwZ�7�]Y��b�%��yeǈU�������9R�<d�����f���Q�Q+�,�t���S���y��2�r�P�bZ�dQ�1`o�V6=h����¼�}�v�ε���	��R�l�zG�~l�br��i�J��EcW�ߟ�Z ��K�x����"�w��'G���F�ۀ�����	�C�|7��D��E�HG�aQ��_����Ȳ�)���13��&w���!��7�jEҠ�}����	���l+aG�%��ҿ����KL����Rr���J��^f��2����S�'L�F��tȧ��w�{�$ڨ���ȓ团�:��Z�����!�����=%7
!��D��� L�ߙ����6'7��"A��i�>y-ݺ�_V��|���{����]��҉���4����s;_&E�ֆO+\Z�����d�L⎺�V&�F1]]rU]<�]:�h_�C�0C���E�+=I6ԩc`�0���$I����K�p��۴ƋJ��\,3�Xó��E�y�g
X���X�^��xݎ�ߜ��sX����lp�18kK�����ێ�Q�����;���g���.�>-՗�?0JI�^��F��35(���z�2�97G:W��K���4�c6J��A-��k��~c�d�tc���h�K��}�OU�R�Z9^��9�P�6wu?�G��<�wL�*&��1y�����{�F��l�U���)S����t��k~K�18�4��n\4��Sw��Y����l�HgJ�0�*�<{��$\c��텍����#�a���Jn���D0{�F/��c���ݎ�I��������eH�	���0C���@���|M���q�X/3�����?u���vv�@��&���ݷny�a;:a���E��=VJ���6X�ޥ	�)������ld4��b���������������8�<�l2����B;f�y"\�	���C�ad��zi��18�P�O�Ֆ{o�l���5=����wg[���'W�[��ۈ��bp��k�=�L9���PJ��[)e��I1���H���gk��Rw̜O���_�rً��~��VbTWV{��[)m��$��D����N��F�ױULfBL]�cZ�6����~�38�ЫT߾�udFp+e�)�R��bl�d�c�8>l[GfB�R`ü�xi沂��d�v��n��������Y���/�VLv
���<�t#���S�� "/��Έ�f�0��J���b�T���98�Ȇ�3cP�jj=&D�Rˎ�F���~�A6m��Z7�(Ŵ��0a�ԤR'�t=���2G���6��kC��@6w&�X'�X*��03�#6L�1����JSۨ��� ����KX��	�_����6��wB�XӁu�^)���j��n�z/+x�1+�;�bafD̑�+�-���Z����̈h��yK�6\�4���݈��f�ul|�p��y�5a���zp$A��V^���1?���4)V�3��sv�VD��"f���x��\�3�ͬ����o�UvʌC�T��8L�h��3,�'3E��P�ǵ��NAK�Vy��Ӊu!fH�ԅ��뷵3u�L��_�/��7L��0kl7�I�ɍ�6v�]9FY)�	P�0��+)_�v�],�n$}y��n�a̡]����PnF4�0&0�)/J{o���t��VD۷�z���<�.6#g�Vھ/M��Y����̑k���҄��~�ߗ��#�����L�ů�����o��ݚ��R��fQ���Y~+}���n�bI��;e�!Ƣucy�܎��!�6�y���:��}�#F������V�zHX�i���m	�JV�b��� ���p�CoUE5jL��c�嬑��a�^(/����n �5'LUK����JU4[�c��2Ȋ�&�
1�ND��q�_�Z�j��͇�S�_'_��D�5�ɧ��d��7�����;x@��Ŝ)V�{�d!�ںZ�J"Z������r3�:c�����6��������Z��<��ሀ��G�p���Z@����-Y+THl�����w���jk��Y��C�m|^x����#��-��(���®>��G����,2�%�(ޮ�:kt��x4)�g��M�Ԝ̈5�=[/o� �b�(�l��)f���Y6���"��D}�rn��Ol�>?R��;����Ĵ��2w�D-�������v�W���b�$����_�e�s� �"����2�k��9��E�,�)�Ы#�d�?��;ـn��u�&'
!d��:0跞�͵MG�=T�γ���?������:ib�đ*��*/L�����@�=�Zٓ'U�!=|R�2Xhs�������
i~R}�c�ݽ�|f����t`��yǾ�w�ü�Jߣ�I�-��Ǵ��/^�Q�cnG�I"�R���.�^��R�!��[����#&����,�i�G����{&�!qJ�t��D!��>ٗ�`�ua���%�����u�Q*z�Zl�#�\���ԢKE�Z�TD%N�r#���)u���"�_�O{�L-Q�E_*�qd
��؛��<M��0��[������CS�;�Ջy����Me�ET�L��E�S�FC����[��2�\��l��^w����u6L������j4���>��m�ゃ?��`����bAA����NqA����4 �����a�5�LKF�1uȒ��T�G��o����^�r~�Fao_���@���(�b��[4Q���Z���^TI1��>�#g�^S�DI~���1޸e���/;����E]O��|�W$�#o1X�!�dA$$��1�`7^���dʐѐ,z�	1`*�;P&��8�]�m'�!�g�bɛ2�l��_��RI��ʿ-s�pSM�����m{I��0U'��8����m�>�B�˽��`�4�,�Z���y��ͫa��%�GI0���&���z�%H�0�������&�������Ϳ+�-�ҽzGJg�����>��bw��t�އG���=a�Q�h�(�(y$�����g�тH�\��ϗ�E��x�����~��B����7%���~v�+כ٪��������q�U�r�S@_j���=�l�1��W?���i����"���k��\?j�����0c�h~g������9���b�|�@t��P�������齧`d�C�ʼ��l7�c����!sBd�YT�dJ<x�O*2w�ߵX�]�=3iӇK���1���2�w�E������Ru���3�GL^G�a�mŽ���P�Kp�����%oDL~�G�0h1��ol.�4������p�3iL��2�ŨH�?�o�/�sy��!�Q;o}y��x�����U��e�\�++//<���j&Ԃ5u��4yO����!�kl����c�o��m�^����e�"0Lv�=�\����'�.�h D  Z��u@��=~)f@��{Sړ���bּ.ϒ'�>�ߪ�Y���|�o s��)bDJ�E���X���0���VXi�4O]	��)b�(�S�8.6dr�P���NAp���#b*Մ�a�1�Iǭ�_m;F=�a�,O�i��S_��C��(O0���6eS*�ZO��@���Xd<�Jdg��T�N?�<���a�/��HŶ<M6���2ׇ�{�ul���tZ�C���d��<�F�86I1瞄�3|�3vψ�����+ �M��{��'A^�s�Y�{�s�Y�P��%)���7<iǈw��.s�Ѝ�}Q��&���3�?��;�Hσ�ǹ!�m��L���Q��_�r��>��vU�"ӛ}�L/�p_�q�r��ոmNV魅,�<!|��o�Ń[�L[��E1#!�G�5F�����X��|������h,bϲ��7/ẖc��(�q�6��Vx��Yd�WJ�	ϹS�_P��JL��R6L���N^_| �����=F|�`�^�tJ���[Q��=�N���^U�C��4�+|Փ�~���B;�')�A���=��e1|מ@�G��-���I�Zڎ��ʞ)�4���ى-����<P����/�Xv�K��}���4%|��j�\��%�	�2v�z!L�p0�>a�0�/��\�W�nL#mE���KGe�	0�=�K(˱|��'I>���A���7���f�|9��2�jF"P4�{��R��ZVO�ghN���������	��L,�������S:���������)�B��,y>m���b>9�ʄ�;�N������9���x�@H1�A��G�9a��(�����C����t��ȏ��%5ژt�պ�m�yb�ƨ�pj*��ȫ��bR�^��aPb����E���>`f�5E�i:�c�=V�/�4�V+�r�5�h�ܠ0Wϗ�c�m��?�!���P;e}�A�2�D�כ�ȁp
a��,A�����R�٣�I'f�����6�L����J�P�M<�ʭ��E!s��0(��{���Z������<��e��`fs⏔FZ5��/��=��,."�s��DA����<�8�:��V]��s�[v����X��7c��#�/�e���7%��z�(�p�@I��'
VM�T�wO1?�E	�/Gw�@���I�^⿛&��)�I�]e(_��n�~��o������怰o�옞�#�/_��{
߇*Q�ق�#��YC���_ ��r#�X[* � /����(Ij���?�2=Jr��d��j�o�����gP�V���-[bt�ű?2�4��d^ki�K�<�69-� *_6t�b5o�{��^���?d�)      �   @   x�3�v�twt��sWv
��s�44��!##c]#]#C3++C�\1z\\\ �Ej      �      x�ͽ[�$Ir����(=̷q��-�&��g�/�����@�DX
�~���ٙn�����̹�����_͎3���ǧ?�?��������χ�j�_����:|���_��������Ӎ�f��=�~��������?�>�^���<4��??~>�z������������ۿ���ǿ���>ԇ�_���/M�և�����t��=�eⰌ�_�_>�P*K�޾�X�f><_�O�Ǘ㗇�T������ˇ�O4�����x��V�o����ST�|z=:Hg�.�v��%|� ��	jhTU�.�x}8=>�N?=}�������O�������Ǉ/�ӗ��q���p�󻃬Gq���K�ܾ3c�D`��aY����vx����:�T^���ѝ�jo_n����v��9�����[�lϷo���=�,;�n˿������.=�|�|�����'�@χz��{�e�o�40]Ł����h&�0߾�hj�T~=��`:L}�&�i�{f9�/�*u��o�D(����������������ᴮO�||Y���9�����d�9<>}[���ۧϧ��y����3^���~|��`�Y��z�[���oϧ�}���_��g
�Ĺ��K{:���������^N��������,S5�|�+��������m�0m ���y���K�b�v�m>�H$^�~�Ǘ���˟�_w|���Z�3����r��O�u�.{��/?}���no���}���	�/B�k�__����q���'�q����/]w�&�޲���&��K��l���7���L�/��ӯM}���1]܁叿|�������KU]�<Y׹��L��3�ķw�x�&.]���q�q���J���;��}�Ѵ�p8���#�pq��ܾ�k� 5͈�{1���U?���|x�N@�p 8)�#�{�'~�4��u�<6Gj��<%��g�ާ���,���P�j3��CPX��es� �pF��M9v�	(c�C8�q�O��~��a�$�{ر�I C�p�����W�~<xM ��}���߷�n�ʗS[c����M����3Ii·�an�D�`�f���7y>R�OQ�r�$<�+�{�b��I4�V)�C��-�fx<>��a����W�������f�}q�'�r��en�+��Y��G⡕�B�=<�g�����I?;ã�l�c3����I�^[D�h(��T�(�ѴFD��'��	�f4W` d_����k�@?�c��������?����G�]��3zE{l���)���|q'�ّq�h(����x;=���7����r���F���P��6�ݓ0!����Z��tdC��h�t����iF�/	ƕ�e[� U��_�e��dǳ4��G�VuuESE/@�9v��=�C������!������<�B�T��[�E����o�*{��ߞᮮ[v7�53�Z�5�Ð�+���N^og��j��sc�pxᜢ6wL�[�۰E{�&b顮��ne�����L��G��;�D����D��\�D�P1��10T�w���CV(Z�C�ަ����t|}�����
���^���Q�{��Q��p:+�<���W���޹ڿY?�X�J�c������P��M�'2z���$���
%|���g�1+$�9W�3�(d�o���v�h�q�Ov.�3�����曠UdBg�iV1b�{�*+,!bB*AC�k8с"�2�|�P2�c���c��Q��)����b=�5�5w��`>�*u�����1�.ţ(5j���%0j��W�F�kh+2u��?���)&0�BP�g�(�8�ћ������%��74�NT��h�MF}@Bi��.�0�
��#�z�PV�i8���������gW����r�p�&�p���,"X�����$�����˘H ��
@i��*�������7����X�`�ΤJ%����U'�.[&*c���:Ȭ�4�Ź!��οi���8�	�C�Peg�e��ݏ����C\ىR^�u�D�2Q�^�A�1U�P�C�z��xl_�Fw�o���A��'��Ca��r|�v�k�i���}a��(\���M��, �o�kz�B�^"{��;߾�`8V[�J0@�P��R���2�p0����u�-F� �FQ��~M"�wT�20z�17<�q�G�w�M���;]�S�S�Y=W׬Wu��ק��E�p|z��p\���=��ᯟ����5v|�%�%)A<� �?�R�{��T�C����ҫ|s�W�H;�\�I5.=���Sݜ墲LQZ�b�:CZei"�q6T�XP�Թ�*x#F�)Q��3,�2�}�I�"�0��I�p���J��֔�p��m��Ĵ��x��}+ܴ/EW�\�2�R�S��@��f�	����'%���w+H�PPx�P��l�sES�T� �H�044�߲�I=�}�p聄+�#N��! J2'�ʌ�@���a���J�Az��LSm����`�*G��މ�"���	�����t)�)��ih�tS��>I �A1K	W�LDhE#1	�P�L�)��z�y�Peh[��}؈�rB~�����u��ka`ى�I�ڠ�2��!�+!4��:�1Փ8 �z�0���iB�k���}��)x!��G_�m7��4"�N����B��SH2@���(��s�0��&~E(�yv��`��J!��)n-��Bc�4���w��I Ҥ���#K�^�1�#=�lM	*Ay@�[����<;�ϧ��Z/n�_�t����9M偘:eT������F�IxU��?�q��9���4�u�uG��̽��ړdAN[�E�}�׈)�"c�����$*�ڢ�.�����zxW-.�jӣ��x���m�B�WL�̂!8�q�h�'I�����������U�\)"�����.CB (��<9��wa�jv�o"�qʐ�V����t�L7�G�#=8��#Sh��b>�-_W(s�������__) I��*#��J )Y��!Z��]���EO Wy�����C�2y����]��=-�QF�EWtj����NJ��VD-}��ĤW#%�;�EѸ	�j`��n�÷k��Io�l����0FO���͛=j�]�RR2�÷�ᐢ��"���-5)&���p+��<�$�2�!rAɶQ��t��W^BI��JCL81��ͣ)M�������Y�t���� *B��Vg�%��Y$�Ԟ={ߥ���ͥr�e{�SɱU��JL�ӟ�pz||}^&������_��Y��wl�O/��W����]���u�r���,�� ��X��F}�N3���0�-txM�Wk�|nߍ������{ ��z ��ǫy�ժ��%�������b��ŵ~�H���9Me 7HB� �gt�J�G�$�V��OAҿCD�=?g�v	�tJ��|�]?�B(L��;}�Ej��bQ�����hh^���5Ʉ4! Ų���+�o���攡v[j�FŷS�P�}�F=/�N�Z2��PƊ��9��?>�AY�<������+��W�stvj�J�ݟѠ�8���h�tz+��Q>S��e-7vZ�e���J��c+���-�{D0-����1=��7�B��+�`7C�nk�he�����,�}�ǀ�X��p����p�$;��N �'AkA<���$
D�$�)n��<_N�׷�/��
��K0g !�V���i�,�����ȳ�nG���<K	y��Ʈ3�5����T�5)e��e�<^��s�����w7hw���)�.�.?�D����*[���]Ot������������}x�e����]�V5U`-�g���V��j%�S8~J[D����T����4�����E��-���_����}�r���La(!���Rsn�D�S{�d0g��'q���y��-���M�j�1�{������nxP�U��7qGi(�¾D�a/��:Đ��D7���Bo<m|�b�)�8n�V�]i���T����	�3��]�܍7�}Ӡ    ��e��X�["Apn-UEc�RJR`��)Z��тO�֕�OKC��+*D�ܮ�l�@&�׋�\}��F��������u���k�Im(ڳn݂��!��=�E2D*A��f�"b�!���9�2~%�i�~������?DG_p���a1���r>���l{�W�Z�Q"�ڕ솉T�J��"$<>)[�s�R�,��u��@�0�g�5�<��a�YL��s�1:bͷ`5_��p:�<<-��������7zWB�� w,#p���z����իގ;@�%��X�lz�� ��.�q�B%Zh�* �+T� �)�����ٖ�!(�b�@�*�Izi��|�MF\��,}�*j7ugz�-��]�����Iq��'<�FyM8��=���l�����Z&�`R7D ��q\�м����"|�JY ��j�3VƦ��<pŘ<d� *��~Q&^f��v�b�`��7�%jo�d)1:�%�fv[�k�_�Ґ�R�%�����8x��!��Gr��kC,J�eK5?�g>�D���Ŗ��k?n�,{u��:�0�l	�9"�r��<�%d�"8��e�0�[�a���Dn����rٷ��vZ�ic��D�S��c$�r+X��%���5gֱ�j�"%�!��l\R�e�&�i��䣿�N�ha,��.h�c^-s�~���Xt��`ܠ��A��J7�X@�	
�0P=2$�-
��4�F�.�b"VX�$(!v��鱬w�3	�BUw �ܫ����a%*#C(&J+�5y�VbaC���'���qHf�Nc���ΐÆ�joߴ7vv�K͋a6`~�b�5�n�����n�"<��k��.-.B���c�쐗��p�&�!�H(�,�f�Չ�T��12�I��gѶs��H)����̼�\N8q�nZ�����J8�q� ����?D��wG)A��SfV(2Mn���P膾�b����Q!�&�ϫ�]�ܾ�CE����ڊVnSq��>wgG2?|7,Mϝx���54�W�"Uи%�c�M���z��=J2#��F�Z� m�Q�ȃ.�C�LAJzt&�/�U�P�@�}�Wj�	F������uYE���[�D��/\�9:���S0�K��C�����0r��*����P��� ��k���nͰ��M�������I̦�31�ȈTG)zF��kB��:��F�r���Wf��m ו��Pt_���)N�~� �-߮h�5�� ���O~�����1[c1�C���=��h^�m@�PM���iX��_K��kbO$�����<�޶���{�U)�	G����$�F���`R��阒w2�[ 1�Ţ�,�⨣����aڔ郎�2j>���1V���D|��2������0f��%ٍ&�%4ƌT��*I��ң�p�.L�@
=Q��ïY��S\�0`���l���7Iӄ��'���zڼ�Y��Rٙ4�S!L�	xFN鯡|�E6����1��D3W��a*�����J�2���gf�&C��XQ&R[Rvd���߉�U�<�$�ș��U��k���s��(}�A��aC����`!�у�Yh����2��D�	��a����V�=�w��PH�BH�ȁv��r�"{�wzf�6B�ο_�.?\������W�"y��m�����1ފ:xb6TUw�&���)"�@HT�q��5/���ʄ���订T&:G?,n�RM:��N)��<22��`J$�Ai+F��2�X�0F��M�����t�f�z�ɠ����QL����[�X��J0��T�Ƕ��uϏNI8���'_��T�vƖyu���Kx�+�L݌�o�U����yϢ��t�2�+?�R�@ ��f��?Wd6��)�G��X[��|��#��Q��P��Y���RG�rK@��o"0�����EÓ�	ƐZ�"Х	]-$�^��JOF@?	c�oH��۪R��E�[�i,�!cu�ۂ!~e"[$�ʍH�	_��DD(��jm� $�J��T��ۖ)��������F�'��o��=~bH��&{���n���-�d4\%H��&�1+w�D@��D�۲�2(��߰=��d�X!���c+3�0p
E�X_Gm���L�(�޾.��ܷZ�/=��oCf/У�
yeߨ���h���i(.�+�!�?�Oi���`�����4�2��j��uo;���$�Ω���ח?׿�-g�P�ms�7ylo�D4���-���M�Uα������nY	��\���ԃ��#�m�:�u��s�lm�l�a�!�Ծ��
����:&�^�XLJ�,�0W����|/@!O���/�Go�������iOk�c4�R�" ����1:j)�oL���Px�K�<�50�4 �n��U% �ەX�ȰޑX�4��O��<�#Cth�J�}���{:0j�ߞf2w�D.4�|X
���D�x(ڒ�h/d��1E�e;
5�X��e��V@��g{r��"n)��"ǞF {2"i<�ECi nA��=�Ӓ	H�pL�!�P���k]oޜ��7�ͥ�d�ir�YK�H�����4΄���"*��`�������Aٷ@J0ۆq��ڨR�� ��� ��(�f.�0q��<V�&@�'d�#<cCG
Q4��4F��g��Lʌ���Ul�I�J1&L�ԤSt�:�����ݝ�ɩ(���(��RsL#�߲=�u��{^7�����PypCr9~�k?B�{����L窃�?S��O�ѩ딙� �;QnO%1v���tn�t��=��3\���sW�T�FD6D�8zx�ĵcN����
�5���4��d���l׎e�
�����y����k�8� ��aHT�D��^<�"C��;�BN��)h8V,.�ð�B!��qMD����G��)�H�q�q=���L�s��rt�N���Ly��2ů��2�!� �0����v:~~x��<.���u"�F8Z4&f)�"(x>0����v�  $��!������y5��D�ǔ(
������S��i���)�#��R+U�£w:��YSh�1������Y���2GO_?_�z��b���F��%$�E����,b���Q�PD(�UJ��44�X�;'3�{�W���FU�^5��G7�6������y���Oĕ�nl�1	��tg p:f	-
=z�O������Z�o�D�i�g�V�ʪ�P�7PFmB�n��á��B�Q|4~D �I��)�WVգ#� i��7W�L1"��0��:;��
��L M�[�~Ųώ�4�FZ�^�&�  ��� vt�=�� �	�Y����k[*2"r�P����kʱ���`�)��:�V�H%
%����ʼpS�F�[�8�E�Tz�ы��fB3(4<��/�|�D���,nW(^���YoB�@(�K���E�zH�XzG�,���G�;F�_~t�;�L�e�m�C��Io�]�g�w�$(2�}R��a޹�k�h*��5d�NV㛬�n� �+�v��߾�tQ��7IѤ�0O�O�(�����a}�ðaL�o��A�<�|i�}!1��=KC�QH�X�z��I����w��������ʁ>�~_~n��~� ff2<R��lԷo�lZmzt&3RDwI#a�s
�h,F%�ΒP{o
��ai4�]/���Ĕ�y[9bw�&c5c�w�]G������KTv�
��s������q��w�I]Ŧ� *�� �3\� O�������y���Y3]�]~�E�ӡt�j��Q��ǉK��f�P���@C1q� &�D�^��0��D�^h���0!��w+�-�����1A ��;	L��{�|7հ6��M���PbR�i(�}�|�V��ZR�"����il�M_���w�2���уPQʹ��A��Ͷr��D����iLi LdDF�HCq[Ȅ��{�4T4�Eqbˀ%��}{<��7qZ�KTF>@R��'M�KF��R	d�2.�AfyHV�g���{kX(W
a���    U����X�]�E�"����F�$�M:��+�t�hxF݌�$��$��2i}(Be���Fh��2�d4��8���}�=�g�\�(Z'���`�&|�c_?3�<5�"\�u<s�&� �5��&�>����?����N���K���+:�cؑ�E#`Rxe�h(�~�5�� �L��pt�o"���Oc���p�&�� �η���7�[:BS�5;b	M��is�� 2��e�}�^�z��r��*Jk��5鑯}帝�l�yt5r@`ڗ�	�{������wYO�h�:<�F`4��/h
�)۩�,<-�4)� ���0, "P���[�n�$�y�i�}���X� u�P;�� �晩4.#-CPlťt��+C�	���m��$e�e�iڌG_|�ǧχ���ܗf�vbj�"0�:H�npC	ۢ��T�#���x��^U&���0=�$�pşJ&�C4�J��H�X�7*�+<!a��.��N�<y_T�Ҭ�t6��x{���d���\BHLK.����R!G8x.�6_�߹V�߻���[
 &��h�:E��VkG==�F��'�y�]�VM���]���MO9Q��n�:�2q	��x���^N;b�����^3��DBR�S:ByZ��=&"�~0hymfR��	�'�+7�ަ����~��tO�Q&�,z2B$��p3ܴ')~�|в���Rx��y4�1�D�����W�r	�_��gr��fu�KD�c��I��q��@=[l*�C�rl��υ��\}\���-�C��"QZ/��Ţa�(D
�!T0;)\�:A�`�3�(�!��`�2���CuN�Q��G/q�,*�A(�qe���r��KU:� ��& �_)�A����S�T�4���o�t�A�-��C�J)��˖<Pl��@T	�c�����IU'����L�TAPl�:I�U�<�ht��\?n)>�}r��}rn��YW0���V�lA�|,��g��n뿠�kj䐨�9�Q�����.I�2vM=�{�D8���@�cZ��� ��2g�n{�hT.�%�s��U�0�j5g_����������������y�YN_>}����m�	C�ʜ�Aw��؋�Y<Iy�3�2nE:;�Q��=��@D����lB�ȶ"�����R#�`C4ַ��[�5]����?FW��&���UHd�CT%4=Nq�d��Պ۪n1f�c�V�o(��L�pŴZ8X��/(*� BpLD43��UW�ǫVV��I+s]�]&��F����I���*dz��m�S�s�)'�X�I^|��#s� [u �v��K&މF��/��2S�Cf� (JJ��|�d��"�!x8B�d��X�LU��/������l[�B�"a����c8n�Zx��sEdLY1J��Ii�KhV��81���lm�j$#Ʌ�����N\�
���E�P�/�Ÿ}I�㥦a)��	SG�>DbY��䂋�hrR�I�N�}%�����Q��R��
٘$y	�,���s��v:~~x��<.�'w����s��I$1]�[��C���z4��Ԇ��x��Ëp��nm-nͅ�4��U����|��4Q�Nh���:]\/��SaF)����Z=6r��;�� ӟ�,�fB(������	"H>N4��A��مm
OO.�2�Niϵ)������#OR�p �̿�t�=�!(�ծ�Z1�h�;z�	�~�A�%BbZ�����]'-�]�	��mC(sà�m�}t1S��L*:�R`*z�q�#�ݳ�y�M���F�G��#/C������@�%GPJlq�o_&ӷ!��Pf8��$����1iU�ib�m)��G�MРU�L�^/�z�_�.G8b�s�\�i\.��L�KKLUE�+��Y����e��7Oυ�Jd]W%xu ��Z�F+#_`/���r��>h����9��]��4��H�F̐j��XB�w��o�S���7�"tE2�ݖС8�]�L1�bj�bT	%��ԓF_j��In�Gd���J����Y��;��)֡ƙJIM� J*)�Z�k5����[s���R��J b�p��������cC�����5E�1I��nam[����%f�j*��OJiG4���{�|稃����Wc��zS�9� �\�by5�u�+ ̨D D����b,ƹ��Ԧ�>�b׳�Rj�;F�R��h��S��4:r���t��n����6h�^�����5�l<�eO3öMB�C�ӤV1��4�5�S�
D�YA�
]� �FTӦ�\�^ϒ�)F��Xj6�6W@�s�����T��C
�X.Pɺ�J+DU����i�9��C$˃`�<V=_y����5A<�5q��}�~�N����O��'�l���0F��p�V�/�G�	t��"9B)0�\9��L�M4x�-�D�@P>�*�2��y�s�A�I�M��v���"]FPlm3�R�&H�*CT~8S�!c�����Am����ΨJ��;� $�BX���4,�j��� ���=$sG"(���)�u���gU���gg5����:*�ճVjRG/o��׫R��z%B*t-G�.Ԁ�n�N�֫3
eJ�"(��J:��`�_8;D#��C�Z�v#�Dc�%�>�2�_�m̔��3����:AU���X����0%D�7L����'�l�����̓���ͣ�a�/�2�{��nI !�����J%O�e����1��� J������b��7!$�!J�@I�6����P�w�T<�"Z׋JD=����.��e���j����{4{��\�j5�W-����^b �?Ql6�B�5� ���;xޮ�v�����?���,�ư�jiM�LC��@Xl�u�����Z��s$7�XS�t j��p�N��FC���S�=�r,ͰOT��^�ǣ���0l�IЁ�<�uc9c)�lR�	�]�x�M�Qb}ͦ*��#cH�	�b�%QuL�f�x�ڟ��6������<+%F��9��_d	|�.K�)JRi�)2�Z��kA0l2�gt[�n�"+�7�W%�cθb�����Á�B�P!M �$� (��t'����q>:�b�,�Rl�әLql�6���N�P�t�޸&��fr`���DbdR-d2��K�3ς�4�1������������X�W��z�@?S�˗��D5��S�H��;o��@�����l�ˈ)։`ت�i���P�����Ri�������7Q��T�L�ł�Q�J���]��m���`�J(��/L�MP7�<�*�#�R�Yz�*�"W���r5�.F�ư���K�����k������MM1m�X����
�`� ����&ރ��*�WR����}��w�&�����x^+bLzƭ�YUưA��6�sף+  s����mWK���{�@��k��m�h�ݢ��R`1�f��|�`��31.���4�v�+DS�V����M��2NL���3v�o�tû��J��P��B�+��Y͓��Tq�P��^�|���	��V����UG!�� Rϕ�PA�4��x���c�� �(�U☑�Y��R-e��W�:����F���$�&�}��3��BC��G��)��Ȳ`B,%�Ksę�$��y��W<F�>��n\1�*�aT�bR��;��e��n�a�>�.7.Ӗ�^`[ʘ�:�t(��]�F)C�H�Π`(DR���/	!'XAhr�l�����*tp�)| ���m��ĸ�b���~-@0��L���%���}BN)�b씒�o��Zh����uϗ欴1�KoV��+J��mr�<`�q�
�%gjsi����i�����3_�4��߯X�6�2��R`Ll�j�BS����LbBb��E/���P7�5�T�ռi&����+��d�.!o�F�W�lՌ�{;�#�cjWw�0�i�_�y��ׄ��A(��)D��6ꟷ�����k���6ʝ`��&G���|%���;ܾiPF^��^1�1�cۭ�d��%jr���@��r��@8�1k@�`���23n&��i��U(�Ō1������    �3%���酸��U1�+�+��=W��`O�{�lnX�sQ��0ec��}w@�n~���n~�	C��o�Ř����J�,8z����Uh���w
	��`��.�8�5�]͎���2Cǧ�:9/�׏��|xx�������,�=��,O:�\ʊe���=���j�n+�a��� jEZ�Q�p��9�k>Z,$�Fp���$Ok��_ފK�,t�!(*�^r2;�����HT�Ĵ*]���e�%
YH-0��bF�?M�Q�'0_:c �L����Nc��
�� ������#4�2x �^�����ׯ/���T�{i˩�N�\-0_Gx��By�e?�c�\�4!�����'F���:�49g!g�P�+�ӕUi���4D'�1l��σ�ؚD4K��zM$���T�.Dp�d
�"8���D�LaWd��ޟ�'c�C(��=-f4��ů'"�T�y"޶�8���{�$3t՗U>�����~{9��:����x^��������̲�+-wv[u���J  ��N�X���sh��su�nU�^�m�F�(�@�2�e����еg�NQ�j}�@d�) ��5�5�4,�¿��o����� ��+�
#(>^������M�h4_�rJ�-֧RI�x>��X+9�nk��eK-����7�sҤ�EF(�R"}��]U�����+�
��^�?(,ӂC)O�<Ŕd�di��gijҵ�DR��覩u@d�o���O���V������h����;��9�,��
�����;͜��Fh�w7�ѫ�0ɴ><;��@4�)���qB&24xy�[F�o��:?��o���iF~ds!#����x��-5��h�"fBp
3MVJ'�V�D���}���l.�{�0�/��xT5q�Z��Z���!#��D�m�D"L9BcZ�����ؽYB۞�B!�,!�z��z��7|�g����g}�&j�����Y��'ٛf�󕌤A�����w+f�d2�[k�D�X�N�Pl� CTE��i�l��}��;B��_�Wvf�wY��m"D�o=���@(�a���hX�+��T�EUx�E�f�|�i!�+S����H���s���^�3��Đ��R�ծ��jj�d.@���ʻQ��e���ּV�OxP��Eن��v�uS+�
�tՁ�0��0����;�����L~��U���fKbX~�Dh:i�ݾi��z�����#�4�m�<N-�B%V������S^�A�>���M��.$(f��fz���CP�+�W3^51�L��fה��(�|O��g�:y�O,ͣ4N��C��`)�趔;��2�ݎ�X?��̭�z"8��*�5U<pS�E�w�&�N�Iy��:?�)d�"(�r52~v�j"��tː�\�_;�\aLZ�b����x4�(����������o���O��>�U�ߎq͕��7Q+��$���nB��� o������+�B4��!M�Nna<�_`����;Y��.�R`����ʘ>I�/3=2��m�jd&H���h��X�֫I�E)�����A��X�'iM
!(��I�֌L桇X�=�Iu�!,�Dc�Q	�&��J�2�u�超uhB�(�)�+W�M,
�И;:t�2��!�!St�!7. ��@�L[�LeH�ʢ4�;d,a(����z���b��:F1�E��bّ(sC�/M������Dsw�&��y���u��'��#zZo��R�
��K�+���\!Bbz��!\9�"�\[odj�(�����7��h��1�5�h4g*IX��Y�;���+����(֔�J�Q�>��v�*	�EJ
���#<�9�4�̘�2�����<���9��+�G'��!������Y�|��g��R`b-�fV�!���8h�.ԃ8,�>r<=M�}L⟢��4�9=A��*��1�l�s�߫*�؊`��ӒBl'!4�;�F�-)�F��ze��f��Ř�"D�Ya�=!>�b|�����Z��Ah̯�W:]h�l�+_	�uNL˾0�I�R�Q����]W����~j��`%AAhL��t5�V�!��8�a���~�1�^�C����%;7�!$XG�۪M@�õZwx<>�q�ܵ��Mφa�y� ��A7����PLOr�6���h���5��d8 8��M�3�Ĳ��2��ި��czaT�w4�H�LYnݰ����."*_��+��'�@r2G{�:�44��&�I��C1~��fnLT��	Z��ȅ���m�>��F0l��t�N��C1���ņl��!(%f�8/���ʌ�elś/�0r�(��1F��7J!!�f6	�"(�m�r{���
tM?E&{2� �9��Pxa1n�G�q��E��>M�;=r��ۡ�m���m-�J�@X�7-	kd$mb�N�v�;�o��������/�+����O��dD3�b��UD��b͚L[c
�5f���@� -@ Jk�M*�A,%�h^�+!V�s�6�R=�}Sq��4�eT�M�(�mB���4S���}��4�U�Li��`���A�U�渭��4������-]��ρ�tQEH��:ln��)���8x�P�/�2^�jC��3�]h����e���W�#8g��:]ԛ!Rs�d���_�t��au����£�i4�@2-E�1-$D�4M�`	EP��%FPܾB�<Gs	�(�i�.��.k��Cj�I��%��3y3h��_�L��=BR^}�٢�b�*���k��<>�����;c|�e�.?��7�<��,&�g�>���1�U�+� S�:G8J�ΫI[��`�W%��9�hxカ4c�{�m�i�m��C�%_��VF��S/DXx-��(4��L�	T�8��O���< 4�շ��h4��\��������%J_el��C!��*ʜ�沑�i�{��(8I��By�%F!��X&	 �ے*D�̩B�w���ɟ�/э��D$hC3��|Mj��`$M��+�
�AP
�#�[H@�D�.��ۥh�J����32iK�m�R������k.������\<��e��1����<�M�IXM�e͞`L�p�
�6C+�T��Q�j=R]S]�pC�����"u��C����"�������}�����^���gD3&�S{V.uH�{A�G�D�W.�%��pb��1K��o_�u8���Q1�U��R�z�B)��.S�C�u@X���4���Me�@��T�MW�`�7Mz���Z�<�ܿ�x:�����j'�Wn�A�Ρ��n����ݭ�#Ⰰљ��"#���t��o)5Շ�u}��
S��I�����ZDH0�R�b0�ۣD��;f�bZ��=����Q.{LԑF����ᡈp�{{:�����W�,:�Eᖠ�@÷V�i�G+��_sA��r;=��SǗ���A�!��2\~��7��)�⍟U�TFu�y�6~��su���K���ezGq��뷗�뫃��w|�������5j�0͡�Hl������w8���ɴkK�5�����|�?=����������Ǉ��?}���߳��/���lڂ�(]oSĠ��ۦ␪�ۨL*��D�~�����Z�e���Ś�`-��qҸ�L|�����2�Mh(k��4zzY,�� � �U�O[�1`���4��O����U契p��� �ɑ	+�H:�}��G�ulo�D4n�L�&�N����6ڶ�|{�&�a�G���4�ȗ1_��{�ţ�fcf���?��~�}�֑P��^�ջX�������,Ч�|}}8>=}8.�𷇿<��ӛ�5�x`�wm�p����|�M\$7�A��=O(^�!��� ��B�`�����[��`��ĸ)��ݑ		$G����	�2Y8���Gč���ūt�(�I#Y���ǧχ+Y���;U�h�SE�	�Wս���	z��i��cC����ظ���˺�4 ��84S%> 󴋨� ��W4�ƀ����8�$�x^f�Bo(��Lʻ���JA1�x�k�����Eb�> �����\�w��I�
��Ǆ1H���
�Ҕ⃑��Y�O��g�=��9t�0    �j�O��� ޮ�&-���tU�����?�����|����o����U�'Ǚi��Y���Ϊ)�ɨ�v��ݱ�2�}Ӡ�q_��G��o�vr"
 4\D�s�ly�ob�6�<ɘ���8��Yv�h���qf�z�+���hC=A����_H�b�&2��i����p��w��D�:1�!�^���T���F���F��/%D�У���L\���˅HOS&B(,Nb����8|�l� '��Mb���,�jY��U�S�e��ݟ|�)�9���Iz��Zv'�2�ϙ�]���U����*��S@"����$�V�������.	z��
������qGW()��NQ�gYFf�� �b\o����J��e�N!&E��
Y��m�3 ˕��܈ht�J�p��6�Q��Ly���joߴ%k#EZ^Ш�1��!�yZ��
�	��qe�$��eŶ2>��eaE|w4�i@T������(nQ85n=_1�(�2V��G7-J P1RUZA1m�v��i4=�.f��y2�Z+/4�qg(z��1d���LJS<A���^�4�5��A1��?[T*�Pl����׉�T]'��K�PBɵ���;DE�1�tu:h?�y!n����<WM���1o��-C�7-ð��
C�֖%�j`L��,���!��46�5���������Ƙ�2>��^��e��qZ̗���O_>\Jx�������҃Nc�����-����p��iL��`Ry����_�Y��bۀ��W;0����J�-��f[�?M �1��'N���[FW�֐~OY��(�b�O��F�$B�ԾEPl-~�YU�����,҃0�V�4�QY(a����[5�����g°��N�rC("�68z�s�b��y���b�3]��W�딋 �/�Z�u����|fx��sHF�n�BP�� �ܺ�R��?���i(.q�ЗQL��m ��q[�F�4)�؆_�J���Z5��O���u��������?����?����?�����q/���4�Z�Z���z�������������˄�~���˂���t���Z����R�� k�7��7ؚ������������� ������=�ذXC�����07���?����Z����nC]˥�;����"�u�������gka��/�ӗ��qEr�~ Y��K崟*����J{������OPΗ��>~�M��E�aو*��J;�k�n��k�����I�[z���f�&�@�ݤ��V�?�델*�'�� �N�X.	�+�f���$dĹJE��RQ"�����=[����_������χO�/�-�`��3���@����B�Io�{Բ?�I�����ͩ����q�[)��r����� V��h>@=:WM)k��!����p�"���c�����.dN�0��>��`h�B7���Ds�lZs����*;�P�y���m>OI���1o?�\Y��J�q�	���Ey���ԔyUu�̫�����϶"{#/���U�Q����}��t�J4�/�;��I�j��,�I��!�ӹ��;�F���/��;�t���̟�����^��0|��T�+��2�?/iNzk�i��&�J]�)�~�xmҨ�ޘ�2	k.�Ӗ�ݏ�Z�9�v�R B/̰��������IMV�S��|����L�����I[��S��*=������&�ʷ\ U�se�3�� V����XIG.��`�=|�^U��w�8�7] �$�*�MEKtE�-"��[CҎ�;]4��u�����#ؘv�o��쨒��Wﰦ���V�͔��4�+�P�=�_jV�����M�'��Øa�v��2��4��;=�H����.tZ#�f��c(TM�tuf���]b�G��VEn��e�wJ����tk}i��Ҍ�l�)�azɟ��M���%kimC5���.R��������5�{AH�}rY����Q�)���X������h����v%N���D�L2���N&�C��ڗƱ�qA�ߐ�*�A�+��Gb~F����4�z�X�^_!i犺 TMRH8�sB����4 �A����	-�Ncu3��pb���O�\�a|�IN��Z:�^SJ��������p|z^@|;}��������K�}~����I�Z6�����u����+�⎽���6g����� ?����u������*��*m����[ЍA�u�B7����f���W[X��XI�G�ܤE`s�R�up�~��H�\��2YT\��&+���%���+Qș+�	a���՜d�*l�9-�.����қ+Q�*9K;�·������R��Ӥ��s
�*jg5���l�H��Ӧ+� 	��h�gD�y̗�G�J�g��!a5��)��9^��-�4N!A�%�*\����|��i�.b�ךM`F�����+���dT��*l#��$M�C2&ce	���~����R�O#-�0�H�J��-���i����<�|� =W�
8[i�G��4*�_z���|�2=W֙ �5k_f��'z��|n*�*-C%�A�J��#HTiRy�k+-<(~A$VZ�G4Pb�ֺ��
(eBO���E�J{��wVZfkN+��e�	E�JfK:���"J��Nia�l4$*�9�zc����ШL��tU����m���I�iU��Ҝ��d��(X˴�w!t��|���:�E�2giiX�9�4�:ice�OF�#�9-tzr�TɂJ;�y���B�-�F��6'K�����O�5uE�Js"2^�4,��$�D�(��E�*�������.-Rݗx�f,HHQ�cٗQ�I�Jcd�U̡7V�d;d4�������m��t��$�IO$���I�i5�2�&����sK�ӊu����M�HQ��7iTi7OF�	˺�-�e[L�����iTi���JL����Ɂ�� ��(���L�K��U&��M�Q�]e��1I��+k��*M��n��,seڔ�Յ�ۣ4CE�K�VD`{sfv���r^��^��n9�:���U��S&j��a%fd4C��E�	O��q�"{��_B%Q�sё�4 g�>����Zc�!޻:��P�j���GJo��:�8��;쭀jιHj���H��F�&�Ή�$�2i)������D�2E#�����b�@��Xk�CF_>�b���كCf,Q���)-ST�MI,şѩ#a%V%�j���Jf�HT�I��opbՙ|�&0X��P �Ʈ�h�7ٺ8�X�a�l����D�iHk���&Q�ed�S�i���#m����
B X7i���xz�CK���4�8�6"��h��O\�k,m��B`��$�f�_*��h�����U�e�s������6GLms��H��2�|�}n\�,��#C���F��M���?N�V٨`j����� ̄���p��`_��/��h�&134߽E�J4B�y��mZ�J���Y4��;[��J�rK3�i)G����5 hP�%��&v��J{��wwb�aFX��n���a��-��N����� v����:��J���Ȁ�u�7p��rk�ͨƞ(�eLEJsf�}s��Y��=zcYK��;ky\�*-�Nhv��X18�"UK�--���A�_���&ͫ��]^�o��F�:H3:� ��v�u��]� - /�U���9�~z~��������?wo���{�y�O7f�듖yZ�!gn/ES�i�S�B.4���%c9>V��-k9>Xb{�|�ohT�W&�e���EsӴAY�X40ka,�*-�6_��e�k������'	 A��6��-�SU@�!j|��+�{�(h�'˖L�V�n�|�] Ҿ�0�.��;=c��:�M���R}hTiS��g��:.	`�==�um��P�Ѻv%��p���UdQ�4�U�Q+�*MdD�C���Td�i��"�7&w	�6m	��jI�l�/�P��T�/_�k�{��=�~����^`��������Ū�8�����?��������������N����/m{����۹�Vׯ$k��������x|Y�?��yY��ˇ�O4aX?��mu��ۇ�    �V���p:�<<-��zƛѳ-�ny��!���|���v�ZT³>w����QW߾ik�N�\����׷�,���Ǐ��/�N?>���G ����\0�o�a�&񟡫��@���~���;��޾��꽲nw��c=�3r�}m��9i��7qNZ���rh[,��>�훌%|�b`���Zhw��)z�����oϧ�}����8^��-��]���M|cv1ĕ{�֜�2��I���ݞ�k�Ӝ��^;w��7R1�j��\(��v�Էo2���q�>?��A�8����mZ��1��Ǹ����gWqq(.�Ze����@���NR�&��!b� ��Wܺ����x|���y�||}=~8��sQ�8w�2N}��:rv�e��u!�(<[C��}W��]	�a^������������ۧϧw@O_�y�����=����O��	��s�1����n�T'^4�=q	���V�/=�cY7�2X�����sSQ����5�أᾸ�R�nf�ϛ
�����o�z"��=���P�4�ʢ̶�esf�kڃ&x?CX�I���H�3�s��Vs��#�v��>��H�V�b�=W����H����lt��+6c5�T3Ol�!|���ٙE7}��v囓U��9�����u��h�ṷ��SԼ�|��Η�Շ���7�ɬg6� 5������/Ciĸ�OP��'p������>hٍ1�;�;jCDPV塀���+��X>j�|��2�
�&b��W0A�}���/��#8L^�]�p��pC@\�-B�֤��7XOXU3d��\���Ȕ�QUm)����DQ=bM���wĚ�V��ĸ�L;����\<��F1<�t��[K�����݈�4���]�Mؾ���o�6F��fߴO��v�1T�&�U�QPM�xC-����݂�c�|�iN�Z����_߈�d�{֗�@s���B�&Z�0k��jQ}Pr]��6s_91H���-���N#�3��l�CZ��߾~};�N�����8�}*�&���	ۢ��g���=Lyo�|��c�Z�d�"���̐��0�7zj�xi�]�׬GZ$��x��2�߰���@���AM}�&NPg�ww1A}��$��iR]�����6�0Z'���Z9���+G��Ť�i��R���k�OR��Kϯ8ʤ���!Y�nmL�XM`�v�|Cۘ�8{��b�|�8m����i#C1����j���[�W�nw�^����4�]��&�m�^bl:�(@�c�y�>��iγ��2M�Y+�>4����nSa��O���{ʤ���[9KM�0��1�4=2e0���Ř^Z,eo���#F)�T�^k�Ϙ&��Q�ce�Wq�U��)�`�h�~�]3ͧ����О�ߩ>��R{�z�!�����<?�e�7.�a������?.23D�"{1��z��$���K�='k�=�ǻo��P�@7�z��L5��{�����e�U�rn���[h=�G��o��X�'r<���+	V�H��F����?~�U�׮�O�{^G/�C=��g-1��e̬�H�K�H�L1.�5��u��V��wDM޹E�c�]� S-&ػm�}L�"5�AϤE�Fo���h�,������������������c�9=]�\~���7ѩ7��R�Ӄ߫���TY������AE��}�T�z7'P3x����p���$cل׻�7��<^���1����͎
�����\)�0^o�o��4t�r�m����M�|b�+=�w1:�J����Qmh����wjAe����7�>ռ����%S�A/'rb2Y5��S�����wS��W�1�$�+h$�o���@-[�p[��>A1!8	��2H�����l_l�TW(�D���������N2�z�2�vL��*S�I=Now���pAp�Y߾�����[�_?�����Ң@�����Pr.�b��4S�H�8GX��sz�*�Ɓ	�_Ĩҕ	4(F�%Ġ#,�\k�:����o���O��>����c�6ܾ��c�J�m��w��U(S�	,�Ȅ&Aq[������ʬB}��e���"(�*2����� ���J�C��oQBb���- #�OB �u40����'���*�f��gB
��bTuL�t͸@3X � ��L��L<A)0��� �l?���c��J�
n3�3:E�aZ�����6�^կ'��CYA�$`�N˳�E���s��5��(�D�T�Ҥ_c�Pq^A�����Q��(�4[tFDH�c\;?��DU��tQ:&����b*�����IU��c
�y��#��$��Jd=�[פ�'�R�v�+��H	GFU��� 	��p�)�׵iv�����*�(��,j�IP*⏠hn�H���tpS�F����j�����k�\�
�s"�|��
˛�����2}��dd#,��$$���(z>�+ R���	����J視u������A�T�^��U�寓,��u�(�?�o�A�Ŕ�� u�a��e�Şq����"gӞ2;g���%AI��	�A ���w'c�pr�9E�ꓨM@�2�Fp
$� VVQ(ӚDQ(0��@��r(��O�ܸ���6����.��mĤx����$j�ip�a���!��Q<=Z�t���N��<hF���A1��~4�(�¾���j�x�CӨ�{�-?�o~ro�|d���")��4=��G�nmoE^f��z�x�Ѧ!�Rb���L��vl��!5�X��+r{1����c9���"����>bX�-+������Q�C�K(��^��N+m�rz���ˇ��O_���꿁����x��o T�l��:�x�6u�o������aLem��Э*�H�E�fG�P�sc�5�mt+�j8�Rݼq�W �y��|cL�H�	`d��忐a�m����+�%W������;�'>�]��`g�S2�����dL}x=k}b���	1���,��Q�*���i[
���;��M�^�)�;����W�5��t�ݮ��~{H�WK��+�Vd��������WQ>ՍVM>1��BC��B��b{��e	�b��(J:&��Q�bZܨqW3�6�v�cJI�и(u�y�ܺ���]L=nf�*j}瘰�Z�w`�
�.�Iq�P0N���Q��Cȅ��<Q�*����r�?�9��)Φ��T.gs�꼪��Lλ���bbjQ��q�(�Q͹�KC�k��8`��rN\�m����Ȩ�:A��� ��Z�zB֘^�jB֙�/t��Q��W�x�8��m�u�}'��G|�=���ҷ�s�M����z�<���1�[mEw�&Ώy�g���?��昈�V��PS�o�b)G\a[N{�U��W����U�ַob�B#��M�α鬉�Xނ��f�������D�S�@)�S�wS�X(B���>4,�jR��APl�U͔4�	3!(�)��i�&#��w��n)��b�J�2iㅠئh�G�y1l��X�X��KiX�<u��E9�m�h�ʬ��S�%4��Q�-E�Z;ԏ�uVΟ��j���$]~��h�s�h`n�3E[��Q;J�u4��(�И��HPM��)��o�F#1i\������߄�Fk6Ni6Iܴ1M��WG��exL�D$4-	<�o��͌`"r,nM+��Z'C+�r�\ ��$�ݙ��5e��t~(�y����i6����ѝ��ժ|C ���I�+�)�]����r|�5�M�Wa�%�����A����}od�bu��Ҝ���ŴsQN�\ƻi�T�>4;���v��t�Ә�;=�+�s��Ȑ�F̕$�聠�8A|��\�+��L�ͲK���V�+�6�F�h����B����&�E69h���A&����0��X�։�h�ۘ��`z�0���6�i�L�l�w��묝���c��7�i�vҫy����c3�q�%Qi?��@��s�+^���hTnҷ�0м!������z��D���+[��_�~
m6��$� )pz
s��2����Lj�Nژ�Oj®�mר8'�i^�N0-�t��.���d;�^Ŷ�5��y�?��å��
"B(NP�v�+�[���4    U=lL2�b���SŚ\zg��FeY�!2/@CE3߿�n�B��!1���;�Π-L�6.E�ӠX���=-��w�~�޸8}����ir�G������ 0�Pd(	����W�]��}	l�����ٿ����Lz<�ci�T��-(��C����L���e8���2������KL�m�FLƼ�ACP������%c���1�>�X9�Eʘ�>{a����=S�G1���
��L{M*����Ny`�pM}������*"�8�P&[0`�����N~-0�|fGx%��'7�F)��9á��63ث�2��ϸH�6BUs4�ܩ
m�Ww�o��7<�a1����|����Ӂ1��C��&�� ]�o,����P��ǘ`���}bbY^��=����:w}��@L�d�?�;�z�μ�i�����ާ��טH㋉4w1�����.�o�,=�����p5+�����cx���;h�.C%�a��PT�k��˷����< ��#�g4�ϳ�3�K(r坽��c�+65��'S����x���?o_���GU�ҩ�+��U� s/���j�c��G�z�b�d�X�,���c4�Q���	�c�	�c@◢�f�Qө)lƕN������u�)jk�&QMh�����h���S9�h�f�!5��v�����Z��LZ<� L��FHL�oԀ�ԸR��(�>7W��aD`2��64@�b�6��	s1!�5B��]��y�=�p�k4�*g�
�l�9G�Kͱ�������u�=`l����$�M{����$D�ȼ�/F�,�6Q���M��x,!yB���r8I�BA;���/8��/S�B�PϷa&P�ȽB���ϫ����n�Ľ����2[�ceܥ
�ڒ�n/CE)�c�2�>��8E+��h����ȝ�,B��P�v``%<��Tz��_����k�.|�p�l�T�}��I����#Mbvv��eht�0&�ʡʅ"�ht��%� �7��>�p�>,�+d�5[��Q9��2��hpӒ4(��+htۊ�v��J)����J,t��� ��HH���* HT��o�&�0�{Ɗ/�'����fg ���+S�sIo#N�zL{T�K�NR�F
Q���qR��`�d�#(L�TO�2r��1��A�JyR��鮥(�Y��'���S�R��y�f�_q�H��P
�Kj�.Q�|��&��X�sI]@{�O[���}���G�>�~_N̗_?=�~_~�a�Q��^� �\��X�HX�-���=+"��MS[D"���O��՚�
5,;���X�.�zZ��m��qs4��&&�W�nR���$1����0��9a��ht�}�ߚ�P,Cscͧ4ꅣV4Ņ�Ƙʊ���AB�����`a�pDKX�:ro��.��elˊP�EF�Z���޵�7N��
F��I��)ӹk�r��pLoX͘P��B�V�*�=O�h�M��G�6nlQ1.��D�$j�Ө�B��hb���QN�{��Hhx�H�����4y�6����[7�GsN�b	�TpT�t���=ʊqo��4*z�r�;�C�j�{m^VL*�'���ҕe}���׳>;�XR�>c�%�Y��[D����uLF�P7b�%x��e�vj%K��%����i�џO�0�H�hZ3AL>J>�Ċ�/��P6�νd�&�b�L�ob|�۰	���k�71��6}�>�R�6�N<߁?ω?1%B׿���z�K��($z�Gw\�5�븋����j18��3=�_���
�d��P��;�Ga�z�O�w��NP,:Z�F�ƞ� ZI��&�c��
˧2r� n��s�Z�m5_��z��������b���t7S
N1Z��$*�E�zz�O~S�?L9f���9ѓ�,7�~KI��8!P�h�5}�>��U�=�]?[3��8�z����=j�1b?�hb_T^v_j^v �V�:��Pn'Đ�(�3&.�#�W4��X1�)=ƺwT9��utj�b�wj�*�vj�f�)����ќLn����S��G�~5f�����(ƾ�GE-�=����+��Ɛ�?�A6o;�A��<��v�v���EF�9�@.�V�r�[�D��������jY�!FT��2~�V��"�Y5�z`����_�X�uԊq{ �I�����ٻGw{{L�t��aE��_Q%�����-���k8c��V�5<F�6���<�)_a%��g��� Z�+��cL�D��_�%�{��˻�n_Ef��*�0+�z�.Z�[����A|�e�.?��7���ێ1�
����hh���i�_�n�����v��+����������?�_깇�]F�zKwk���a�׼�>�MF�M�|H��I74tv��ݶ���d���h�i �)�("�PL�`ШF��.��B$��,X47MB��$%$�TL^$���F9 ��ʉ��o��e	����l0��Ys�M3k?1&Rl�5���g.ʲ��,BX��w���?����gx��#�!��Z0�\��@Ŵ���r�ئ� Xn�IBV�����&��� �PEt�S&�%��B,�m�0,��X�-4��U ��a���5Q��,Aj� �c*�pK6	B�%ZaQm�1�Tg
"��b�j�&g�:�B�̵�E��\�58e� �{R��CÅ�@�I����u���p38����2,�\���n��݊�D��!�4���X�-�5��!��1��Ti�j<���8�`��������`\ n�^$��n�T���O��u��)��*�'�"?��n�x��])*f��c�,��%�Y��cb�"u��v�]�2+ k; 6��pʋmN��đ��G7�xN�~Qd0A.��jY����Xk�����o���O��>�I��o�3�嘆�7qzL;�@qq_�?��x6���H�s+nf�r�9U�6�}�ј���R���Q��:|�1$�@���?TX}��.�Y��qS�4}ژN�>-X��5�84��)���2��-�7B6�4%R��L-jU�f�h�̴1֠�ߺM�4�Cm�r����֊��
�@z�u=+����8���۽�d�������� �'"�u�r�(0"V�=�uER\��Twx���[�����AY�>�����lb���q��X�UN5�<�?�;O��8C1�'��/ qJ���S��P�y-�Z�K�h��E8�����o2��B/SPZ1��xvZa�a��z��&&!ZK����EQ������ 1�x7�'F�aH��N��!�_F<�w�V$�!� ��������G�+�h�CBp�F�z<���w̬-��iܖ+�ځ�_�M3JՖX#hj�6Ez�Rc�N��#��e��u��§�M��+���^��n�w�g�Ui�����r�I�]륋9>��K篊��¾{ ��u�- ˉ�iFɺRDO���9옂����.cd&�q=�������(�����XI՟�bl=㸋��h������Z�w�!M�R_��E�@�g1���_cr�5Zu�3�=;����z�*:��ތ���4���˥̹+��'5�
}�z&;_/��X�p���M����;����˫�V��� 0�Ũ�_���U��{�%�f��>&ޡ��\��"�޹p5Y	���b�y����BM���+�}vV��DT[�n�'f���4���j�m>T��L;���?�~Z����t|yxZ���/�j��25�?���ya6��->�+$�O�3X�j�GH�b�-�wH�S�g-ﵷ��ǧχk񑇿��^�M��	7C�w�5譯�>�Q�����9�$0�1������H�P��U11�!����4�R���!F�� �Z�s��=�|SMt�!��HС�~+�B�����O�
�iحG����j��l+�v�W��Ӈ^U1�K8l,i�o�ɤb0t�	�CWT��1��N��IQ3mz��d��6�_B��k�⬫����ȼ�U����/��Q8u��Ŕ�Rs�WT	G�˾x��M��w����s��J8y_��A�<�S��_-Xjj���/�"�@�F���Psn4��-�Y�2��n��H�Sz��榪H���<�>MD�7��i &  [V���|�1�ai\~j�4��G�j���a����S8}XlKa���P« 7�1� �q�c0�K經HH�n��Õ�#�>����.����yW����hPͨ��8��5�2>���3���P��Ĭ���2F"����`6}�2c
?�� SfT�xr� $4��-4�������EpR�R���1��4i�n�p���$�(��iT�<A!������b�8�D_<�[��P�>f7�w�c!��1
�-��r��i��s!��ϕê��h�lt\|b���p�P6�{w�&��L�'!k�����iZ��yiQ������7уiy7S�����/bô����b����X�w�~Y@۲�4��T!sL��Z�|���OsY�nTsk	B�^�?!>���	i��7�-�II���<��8�9�bI�oqd
�d�Q�����
g��-h�O������/?}�����|�Od�`g�+��gzl�
�<�n�:�>�U��A;�3�9����j��upSi!�q����9���5W�4U�}�m�	�
ͯ0�Y�;��,u5Cp�i�+��!��1׼|���4%��Xϔ`�uj��1�:�4���cҩ��ak�O�o��Ęj��۰����}�'�(T�,�r��9��Qظ�"�<�K��<3%Fu�+�"�s�Vv�<PULe'�@e�ONO��l��훸�]1��y��;�~e�f튥@�}��z�J����HE��
������s�� �P�?��G� �ɖ�����@�ƭc�B-�6iy�AS&�_����)P1׼B10��)/�vnC��jbN�z廫W`TGB�Ԟ�0&�����7UǴ�{��[����L���R�� �Z6t^a��$d��2�)!Pu-X��U�L��N��)m��,�(�^�Z�hE�xW� ����7�Ց����/���^g���2ʡ5O�a1i��.V�)�b���H�};E^L����Q'��I��~�b*x���ـt�#���4n�CE渉Ѻ1�qF�m�a���*�a����� Tphn��U��i#"hz�L[V��O�_���4DmL�\-@���o���.fI��iC/�)V���.u����O.i�\���]�ˢ��b�)zb�vƽ
�Ŝ<ߘ$51g�P����.���㻺 �R���b�J5�N�0o��jü�٪L�E���W�6�׾�"�jp�MXm��э�QDA��~DWdǏ���s������z%74M���ߪ�Y&Wή��1BW5���w�V���1t�f&�?є�t'���C+���}��ъ���SmQ9��f)�5}�e�����L��kHvw��h��Ȁ�1��ϯXQ~�[��0̚>���)ש��	#�,T{��!`Z#xܜ��X�8JC�A�UBv��e��:R��5_7Ҵ��M\ј:�v�������}�FO�(�p���M�7c�.Wve�e������54���5<�Ö��o����8I���,�74�w��7���'fo��R������!yoM&]G�v�IT~���t��ʠu'�	a��(�M�6	$<��O��!=.5�'��+��ۚ�LL���Ι����n��gb�6�X��������^^d!�$���m�+梇���@/��� �`Hσ� ��Aׅ��^���O���9wl�d=�}�P0�cE�jSq��L�Q���2UX������no��a��B�4m3� ��4�&�����GF�E��~�P��ޭ|	hU8fe]H8s@:�����	<}�<mҳ]�\.ϟ���_~yx���������S�������r����h~�y~"��s{x|~�	�y~��������сD�sdg?�����	���a���&%$����V�qꂠ\��H���9!�LM�On��`���p0��M�]���U�8�!�R�^�5)g�%��p��d˕e@�\�}}x���z|�xz;<~����e����������y���������������?����`o���}ك=���Nv���Q9�w�Z�E;T�j�P]��wTu���$X��֐y��_L��Ք6W¨��@��~����?y��r:}y;~Iޑ4����3�\�I�=��~���I/\�&��7���ڴ;�b���s���&/	�.!��j��q)4U]�6UW������Wi��ų:�}U�i�y9tI/`�Z�iO����i�4����� �@;�={��~5��;{S*�'pLzmn���N�+�^"��:ɜ�Ra������ ���2߹�Q��y�}�å�i�A�ۀf��H��F��7�9�
����gpM4/o�4G+��B�J�?��w4���]z	�:�=޾|���{3��@�]�F��9H-ٔ��PS�\I�S�ƒ6�����"��
��UZ(Dx�*��������K�U�*���I�^.k�4�Eس�MW�i>D���wV�\e��IaMmm�Ө�U$��O������g�sM�J����p�q\~���*��p冐�6�4?*����*�5�YS���(�#��LB��"�!˼Z$�j�/�1��g�Ѩ��$�3�x���P�^al$���$�o}�gr��L��L
��Z�D�* �O��,Ha�~*���+�Ӕ�Ɖet0�uLs0�=}�"�A��������0m���1�I0���}��rɲ|G5��9c��n��%Iu+�J#��'&�I��P�6m�d)��\F�U�uM�;q֢U��@�]�t�9�^hXֹ$���+�Q��T��h��*_T��W�!\c/�??��������it�g��yy��p��^+Ә=L0�v�໗���.��L�~�+�~>sc] �*-W"�I���Lb�g/-#Aڞ�ӂ�q���RL̞JJ��*ii�&Q�+��c��.m�/��ol����9(b�- TiWA6U@e|m��V�=��O4�4�3���p�S�bN��������lUk���>)��%3�\ÊP��X ,���g�-��$g?Ti
�j�[�r�:�j4�D�#�O�Z\��ܾ*��i0N�Q%-¯J��-�6����
�(��v��aG���`Y7�JS��^E3�V��MW>��iI��%4����gZT��Ӷ{.?�覅�rI\�ƚ�$�Y#Edס��E���-�QY�4���!�N�U�3�U'�H�Ѩ�.�lV]����	���̼\ɁB���^M�m.'DU��>�Պ�6?�4�:��@[�i�%|E��$2��XX��LK\����	Dt'δ�h��Vb�Y�G�O�_�ߞ��s�X�U�j�{�S[6N��P_I���q��΂[5v��������g�K�      �   ~  x�m�Mn�0F��Sp�T���T(�$�
 u������ԟdY�Ï����47-1m�I��v��|b�X����t�����4ˀL�@c�yi'd��L�H�\_r�$�9+ce�8ù�G��
2ј�snؤK��0t����$�!��w=��A(��rt��n�%'{ �ӈ�-�d����>�s#qv���Vѣ�!�8�D	�D?P�����Ou�$RsKjN�8=�o$y�Dbi�~�N�?n�g��5��
�IWI�@L$�׺N�tY����0S�y�[;t�,�o����)��.Z z��r9��~n
�6|c�E�v�����Tc�jHy�S��ݔؖ�'$���
�ye#8gL�F�7�_�j~ҍ)������e[�Ö��R�A�t      �   �  x���M��H���+jq�*��	�QT@8�AED��_ߠ�o13]է8�2!"3�X���D  IHq���;7�6����B���_������Ӷ�[�~ͤ��RC�+�KI�'��g�=��q;��#����K�IT'�ɵ l!\i�N}��:��"XB�v����y� t��y���o�`k,K�ݑD�l� �-a=|��ڧ��wnA{"[���g��6Ot2�=�7+G��F�mp���M�v���Y��@-�Z Wؘ"L���0��c�Wzb� ��.�7�,�<���.v�2il\�8�. �&�t����ԙ�ow��;:*�e�n��!�:̂�-�lPiÐE�Y�#9��#^��C~b���d��<!��4  R�i�"��U:��/�Dz��:�����?��Q^�G��-��c���DA�ggR5L���d�G� �J���)�!�=cnK�u��;隺E7�|�G���}=��I�[/�1?W��Sd'���d�-T�^K��s(�{>�����:��s5���W铊� S���d��7U��tMkp�j�Kox���\���A���2���+�Z4����A�32�$I�?�h a	��*������'��6aht�No=���q��6I{���i�� "��4Ʒ�L4�"a��ń�T��wjA�k�%�,�����VV�3>UY�׍��v�����k��b�%��)���yq���~��ȏ�L1-DU�^Tl^V�EI����1T��͠�^!��f��]����n`�4�(�n;�����픺55o�0�.oQ�U��h��ݿ����ꀬC��|��1����'Q�(ʵ"��������v�s�@�s�:�Q[e�sw�#���l?%�ǋ�S���Ť���VQ��E�<�Ί�҄j,�%C�	��&��&U���ޜf�^g��6FM.n$�86v߸���F+|�ܷ��	��}z��b[������gq�t��;Q��GQ���p��ĀO(F�}�"�t����H���e�'�(��"F�D��.����t}Y|�;�~L�_P�L��sſQ�z]M�h
(��g��A#��#_:��7�Y��tx�k���RBZ�+��Jۋ
�Tٖ��� k���M���7*�Ӌ��i��1j���P�/0O#MTs���l�ށK�z"����fE�@(+v��U&�� 2�}*Pc1��W�B�[�z�
��V`�ne�wdö.��c��:܎�l��i��E/ܨ�Վh��_���ZYi+����'�������҆��$��݁�h�1X��@aQ�dV<�PZ��U���ٜ̄/�d��E�J�+DX��_e2�������D����X*׊aY F�D���n3�<��a��TM�s�H�<��6T'ɻP��� �����lJ� \����n+G�y�M�OW_~�̧�(6G3�#M�,�2�H5������Y:�ᥩ��FR23�:s7��u��Y
�AP�"[Yg���W� �(��lQ�·������e���`m�fY�i���x�g����D�J��hF��Z�xķ��iď�_�`A�ن?m�e��2����|\��)4+��N�t`��"ZM�k����yMl7¶�ޝ��h��j� 눝t9��A<{�5�GNļe�d+e,�_��8��b)R�[}�
��q&�)��H��G�t
��w1��=����O6kg�o�.������������*��c���[�"al�����e������g�˙#��(�b2US5��n��8��=��s�8
=�\8��*D;�[����i{Q��T��Eߗy��Q����\�h���S����[.�;ne��u���Hk�f+�H�d#s�8�m�c��T5�\�U�J�+W�ߨ�o��TH��ې/)�"w�-n�;w]ZZj���z�x�#/���Ƿ���ː�Ǣox��>��/�0虲��GV�ۢJתּQ���*�9b25!�,1�o���lt��"=�#�k���=j��X)����xq��.`�S�wԶ�ižB�j�s~����E.�~�P���qi�YP.���Qؘ+�7��ɚ�G�T��i���E
�m��ʱ�F���Ԉ�!O��CU��Jܧ���/�;Ξ?ѻE� �z��[���%���6�gc�m�G/��f�^�kG²���w]�������x=�xy�r��$|�^���Q+K�O�`��F�V��Oa�      �   =  x���An�0D�N��2��Yz�s�D��O<�JY=F�0��%/m�{��M4ۑ��a�K�Y�{ӫb9"��T�>R�1̾��'y2�qS��-ud�0���Uc�Wu�1�1� jO�a�z�m�ooDݳ)cp!�Qc�D=Ӟ��ud[z�N�9]����奄|�&gp⥍u�����fecp�ն��\A�����1�Ҏ���^�x)����b�*��_�X���W,����{NnVJۤn;�O����m"�3�1����w����l��o��S���o����8��z:�C|���&[��j��1|����      �      x������ � �      �   o  x�u�ݭ�0F���4�����El��:��4��y:��X��# �?��s�9� ���b(
ƽ�6{�Pl^W��&���ɯ�_�<6�T1� ����G�P��^�iU�8�֛��b���[g�Pl�����>�8�7����
8���*����{��9����������a^���\Y���x���ӻ��󢼯��m��yQy��f���>/���a����h~���o�Y�������0K}^t�����0K\�|�2�_{��0K�~�}F�s��0K�{�q�fiC�� �l{h�0K���I����cU����˼�^���_�fi�9G\;6wy�0K��9�Y�xT� �?��!N      �      x������ � �      �      x������ � �      �      x�ŝK��6��ו��d�	����1m��izӚ�`��6$��Gf2�pʴ��T���_H?�������G���钖K����?�����L����g2I)O�~�������_��ُ��c�N�A:�E�H����;��t�BN�����`�O��G�_���������\8���dpr_N���Tpj_�4^�@�4��t�?}
b��3H �� H���!����
�G^Ah�,��.�]xa�=��
�@{��Cx�2��2�F�����ă�=h��)���e`��2�vA�:����@�d�APΝAP.}A�	+�3V�	���?�|y���=h��)�H�3�H�3�H�3�H�3�Hrg摔� ��R��VS_�k���=��;��>�C�S��e�����|�{����!�;���8��d"^?�C�����?��ʌ�k8Zt��
B�����������Ϫ>	�x�����߿��7�p>.�K8�2�=�߂�w�!��G}������u��� ݀�-@�e#��H�l���)��Jg�} zz�#Pj�A0,�;�`Xh�H�IM��R��a����{k�	� [�e�<��h��ɑ��ӧ���־w��#��� A�}�A�L:� A��A� �� H�yg$�rg$�Jg&�홰/�Z�{��%	Z��|5g+��/������A�gQ��!�zg���T./�|qe벳��2]?'��rI��v+���g�[J�6ܰ<������<�����Ν���?�[ԏ�_���Y�2�+7��?F�|��O��7;���k��G8��pL� ����nwx�6>�� w��x�{��c��=^����=~�����.��Apĥ��K�U�jO�C���XU�6~�±� �µq�08��}���pm<,�kcdAp��_�1���O�1��C�tz�q��{J۷<�/ڃ��1h�F���isF�Ј��Y$Ah�Fn�� �㮷�Z�p����%W����vs�샆۱����:��߼�ۮ���k8z1�jM�h���4��3��.@k8�R-7b����������/bфEz���@�"���E�a��l��5��h�͖��|ʗ�Nh�͆/
c�k8fa����1��lF��fM�Hj�$�Ơ	�.D��GH� 50D|�C��p��� ���8x7��8x7΍8B7�8�d���7dղI��n������V�Q_��P��O�~A?�t����
j��"�dk��uIy`���e�[���
��^q絹s����NpF�	_��j�	��|�	����;�k��{�)��;���}f.8�>s��{˵�D�n��{!�>����Uvw^�!������:���[�|�ȾH�|�kw� �j���"y�IG �����UQ�!��j��P ��nB�!0�X�!0�غ!0��;!
�lK��J�,H�/Բ%]���.��/�F�k�x6r��Ƴ��������o��Ql�Q�(6�ڰv�m\;�]�k5ų�kmd;(��B�*ǳ�kU��е6�ņ�U�gCתǳ�k��v�VK<�Vk8��S��A��KVZ�ܨ_���˻�?�R�݀�`4a~S��a���FP���������D���88��i����[�h�IN�+�z� ���� π�����Ak�����	A�;�mSz��q�TJS㨍��{)TT)�
oh�H*�U"��^-��TF{!N|�t���x8Җ��+g^��*.iKL|�6�	p,ۤ'��l�� ǲM~�6��X��� ��P��#g�9� ��5ea���$��np(\����5��qp(\����5��qp(\���µ9�ap(\���µy�Qp�b�6�?��f{�+����"'�!2�'�!2b'�!2�'�!2�O�Cd�� ��H���4k:�ѭȤ�-D����*'�!2�'�!2j'�!2�'�!2�O�Cd���Q���N�c�d��{�W8wK1c�u`�����������'�!2VN�Ò�wGz@�������p4����6qX����w�]W�u�k�]S�]g��G#��MXBc^���Ah��b�����1�JF�hM����Z4bOϗ�5���
h��:����]e���'�Z��5T�h)�����M���[�/�/;�E��� �-�hZ��hG�=]���hA
��}��N�h��8�_�m$�׃�r{ ��h<pN�h<p�p44�9g	GC��FwAhh8[8����s�F#�Ÿ���fM |���{mC`�l�
2l����w-ȯ1�p4�T8!	GCHE��R�p4�T<!��FF�I	GCRt�iSǠ���Y�Ah��>5�=e�Ǡ�f��
�4Ԭ=+65�=5Ї���b���4&W{zi�Hk���ŷ����X
Gc^����1���ј�&�h��� � 4�Y0�ѢGoΦ���/;��9�"�0���h��nΦ�@#�ws6Ea���)"��ݜM�F���h4Z�h-�hAU��GQ���v:���R8�5Q8�5q8�5I8�5i8�5Y8^�p4�
�����7�����<�,�][�F#�٬�����s���vs�#�؜���p�p44�%wGC���ѐ�p4$�s4)`�%��i����]Ǡ�fy���Ǡ�fy���Ǡ�fy��xǠ1��3�Ac^�=g��Ƽ�{L>��J�{L>�y���ZW�S�Ac^��Ƽ.�Ƽ.���R$+�h8jV,5+�����F�|k�iSZ��e�섆�����4��(4$�r8�R%Ii�!)��ѐ���hHJ��h�⭖p4ԬnԌW4wC/j�)��h
G+��6�%�@k8:m�����+�9��v�T���V�>?V�4ԌR8jF������f$�h�i8jF{�=M��T�ј��&�i��].;�1��-NCИ�L�h�k�p4�5K8�mm�4N��� m|�k��T\�CJ�~1�g����^�(/0(��q([��;�=��9��6����ʶot��{E�].���
��!�"�h��h8�Kr4UN.%cI6��MُAc^�~�Ǡ1�u�yǠ1�u�iǠ1�u�YǠ1�U��0t�9Ǡa*�S.�AC�t���Q`�M�M	�z�섆�X
GCR��ѐ�p4$�$Ii
��А�p4$�<I��F;b���Њ�nhH��p4$�)IqGCR\�ѐ�p4$�-IqGCR<G��?�^��P�k��L-+Ϝ/;��f9���f���P���h�Y�p4�,k8j�-��a�%�y��y���׺\vBc^����*���*�F�]/%�ߺnY�S��Eb�W
G�5���kV%��F��{��7G|����<��Z�Q���NL4���&�����`��:3��@Ҿ��� ��!��a��+l���W�f���GA�}�|{�d|hF�uln�0�;�0��EY���F�q(S��4�1��_DS�<��b��������#�췇1^���@�Z���$p���x��	�U6g�����#�X���Td��Nm�o��aj�|׾�{D�y�9]��yz��{�����@�sԱ������#���kH��m�� �b�TM�h���4��3��.@k8�m�h$��&��V릇���<l�rj�%5k{]��f���P���ejf�������f��h��Y4��k�OI���_.;�!)m?� 4$�	�F�!)m+� 4$�m��������А���S�Ҷr
BCR�VN1h$�ֶ�Sj�[5++��m�D��%5��������e
GC�2���fY��P���h�Y�h4\�5{8j�7j�zE���1hHJ��hHJI�hHJ�p4$�p8�R$͈i��RBN0G����<G^��M%�PPk]G1-{�|j�'��$�(���,�q���0�=���?|~��π�p��Uh�95�;���LNM~�,���e'� M�ht4򺉥n#JM,5��d}�M����ʛ�JN :
  ��+�9=����K4%35��KX��1�nexT>�����w7�7E㝜������a�&Vӛ��PN��a�L�������w�yz#Z�I�E;Y�!?~)�JT�h#�4��r�Yc�8��e�����\����Y�L҉xz��֤7_����Sy~���I��n�A��7_dF�1$6��i$#w��}YeƗ+uC I@��n��,�n��vC �b�)S�M�k�^�T��
b	���mC���մ_�#�vC,S/Y�P ��nB�!2�Q��nL=�^���ˈ�֒�K��/!0��tC`v�5�#0�=uB(Z�z��;x}R��@�K���c��Km ������F"�؄�1������<��U��u�g8���s�Wx�;g�X��Y��!�1pC�f����aL].���1�j��9�8"�mS��] Gxi6�!�\��j�=N"җi�~��Dpuk?J!?ʷ��[N'�����U����'����� �Z&~SMj<Qx�t,��h�}���<oK����*'�1�UO�c��ap��6NGĴ-2���	p(\[h��Hm�A
g'(�S���phOEv�¡A�	
�Ud'(�T���phSEv�¡Q�	
�VUd'(�U���pp��o
1>(8C��8��8��8D��8D��	p������pt΢�N�Cd�6j��YG�!2y��DG�!2y��DG�!2YO�Cd�� ���=�����=�#����,o�]�W>8�f�^4�S_L3-�� �1wu?�m�+�w�A��(�w����2�����[L\���x�����v�g�K<��p6L��S<y����^l����l�-�5�QlhK�x6�%{<ڒs<ڒK8[�)�e{�
�L�A��<�Ն���ذk;�C�∮��m�.��\��#��}z.?�_�� ��BEro-��
j���R%3_R	T��2���j���=��*�TU#��ERT��fP��TWjm�u*�S�O[j���I���@*A�(ER�MD�Thq$�DI�6�FR�Md�Thy$�Dm��^��1�ݙ,?�<���nl�.ԉJ,�D5��*�˅F1�r�Ṟ\�K,��˅j�?�6�T�ʈ����W���T�6b���Pl��Mn])�!u�PFsRߴ"��nN������ ��j7��f�[���k>?��'p��٧�<�s�T�OV�#;��n�FZ�F��Eb��}*���b��ԏ���.�W�y{z"Jd��_+?S����"�6vt0Et%uB^*�*ܐ�Z�S�)��#�UU�[U�� *|��"'��.z	��N�#�^�8��͡$ap��T�	pL��=�=�z��H�����u/͎.��I��)�!��O�d�8v`8��Mё��7�BG"РB�*��!РB�*�*��hP��	a��"Q�	)g�o�8��.I8�i�p4��$�Fg쯒�]��y۪@��Vq�
43S7�i�n��,��wY�!0��uC`e�P�Q�6���<ިv�y0oT��<�7��8�@�]Z[��3�3o������ �F^�ъ�B�6�+�T8��z�*�;*GR�iQ%��拪�T�cT���E�zǝR�4D���N�N�n�����x�J�1���W"o��dT��������#p��.¯��L���4��_�&��S��8��N텸5h���D[۶��W�2ȑ����+��I�z�y!����d��[���}�G��m,�S*~}��TÒf)���(����8����$��%�,��%�<�
���9u��ؠ4�����`%I�n��6�/-�t���}-�Aw�|��ۇ\Y��B��Rr�)�
�r��B��#��+�H*��k$"�I�H��Q�11�e��d���<"�)�iZ=~z�����.�6^|�[.�6*|�[N���5��Ht�#ٸ=��?���Ǳ�͋!�Ǆ�{cfL����6����b�U�R�n�9_6g��'d�F��C��22��|9�q���Q�_ ����h��SV�d4��~��a(�À�f�1�<ؓ�o�0$�?
�/�㣞�(D�
N5,G�(���n�z��;O��dƦ9��� ���4L�,;����d{�qe,�����L��Wu�ӘV�i0�2}�Cz2S^��9v�l20�'%𯟔�-y*�9 �vC �YS7�O��!}����S�nD��vC�ج�c�z/��i�q�]�~��Wk7���`Ƕ��`�����`���z�`���T�X�u}N[�|Z��&�����;�|���J��Є#hO��CN�`��Û�mk�.h����z=��*�nhq74���|�LBY�ʔ����3�������g�tԦ��9P�#؃chP�n����̥^���KIFj]h�uY^�떇�g|J�����*pH�cbrcf�9?g6�<��?��NL���`����0Ar��0���ҭ?Ƽ����뷆asGő�����04M���5u��4����(�E
}gS���n�`�\/c
oM���]x�0�`O^��1��b�o�LmeF�$Ճ��do�|{{���.     