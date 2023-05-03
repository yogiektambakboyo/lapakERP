PGDMP     3    	                {            ex_template %   12.14 (Ubuntu 12.14-0ubuntu0.20.04.1)    15.0 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
    public          postgres    false    210   �      S          0    17942 	   customers 
   TABLE DATA           l  COPY public.customers (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, visit_week, ref_id, external_code, segment_id) FROM stdin;
    public          postgres    false    212   ��      �          0    18774    customers_registration 
   TABLE DATA           ^  COPY public.customers_registration (id, name, address, phone_no, membership_id, abbr, branch_id, created_at, updated_at, sales_id, city, notes, credit_limit, longitude, latitude, email, handphone, whatsapp_no, citizen_id, tax_id, contact_person, type, clasification, contact_person_job_position, contact_person_level, is_approved, photo) FROM stdin;
    public          postgres    false    307    W      �          0    28173    customers_segment 
   TABLE DATA           O   COPY public.customers_segment (id, remark, created_by, created_at) FROM stdin;
    public          postgres    false    313   =W      U          0    17952    departments 
   TABLE DATA           Q   COPY public.departments (id, remark, created_at, updated_at, active) FROM stdin;
    public          postgres    false    214   ZW      W          0    17962    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public          postgres    false    216   �W      Y          0    17971    invoice_detail 
   TABLE DATA           �   COPY public.invoice_detail (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at) FROM stdin;
    public          postgres    false    218   X      �          0    34018    invoice_detail_log 
   TABLE DATA             COPY public.invoice_detail_log (invoice_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name, price_purchase, executed_at, created_at_insert) FROM stdin;
    public          postgres    false    322   ]      �          0    33377    invoice_log 
   TABLE DATA           g  COPY public.invoice_log (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, created_at_insert) FROM stdin;
    public          postgres    false    319   B�      Z          0    17984    invoice_master 
   TABLE DATA           c  COPY public.invoice_master (id, invoice_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count, customer_type, voucher_no) FROM stdin;
    public          postgres    false    219   Hw      \          0    18003 	   job_title 
   TABLE DATA           C   COPY public.job_title (id, remark, created_at, active) FROM stdin;
    public          postgres    false    221   @v      �          0    18727    login_session 
   TABLE DATA           [   COPY public.login_session (id, session, sellercode, description, created_date) FROM stdin;
    public          postgres    false    299   �v      ^          0    18013 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public          postgres    false    223   �v      `          0    18018    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public          postgres    false    225   �{      a          0    18021    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public          postgres    false    226   �{      b          0    18024    order_detail 
   TABLE DATA           �   COPY public.order_detail (order_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, assigned_to_name, referral_by_name, vat, vat_total) FROM stdin;
    public          postgres    false    227   �|      c          0    18036    order_master 
   TABLE DATA           _  COPY public.order_master (id, order_no, dated, customers_id, created_by, created_at, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, printed_at, updated_at, updated_by, scheduled_at, branch_room_id, is_checkout, is_canceled, customers_name, printed_count, queue_no, sales_id, delivery_date) FROM stdin;
    public          postgres    false    228   �|      e          0    18055    password_resets 
   TABLE DATA           C   COPY public.password_resets (email, token, created_at) FROM stdin;
    public          postgres    false    230   �|      f          0    18061    period 
   TABLE DATA           I   COPY public.period (period_no, remark, start_date, end_date) FROM stdin;
    public          postgres    false    231   }      g          0    18067    period_price_sell 
   TABLE DATA           �   COPY public.period_price_sell (id, period, product_id, value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    232   :~      i          0    18073    period_stock 
   TABLE DATA           �   COPY public.period_stock (periode, branch_id, product_id, balance_begin, balance_end, qty_in, qty_out, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    234   x�      j          0    18083    permissions 
   TABLE DATA           h   COPY public.permissions (id, name, guard_name, created_at, updated_at, url, remark, parent) FROM stdin;
    public          postgres    false    235   #�      l          0    18091    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, created_at, updated_at) FROM stdin;
    public          postgres    false    237   ��      �          0    30744 
   petty_cash 
   TABLE DATA           �   COPY public.petty_cash (id, dated, remark, total, updated_at, updated_by, created_by, created_at, type, branch_id, doc_no) FROM stdin;
    public          postgres    false    316   �      �          0    30759    petty_cash_detail 
   TABLE DATA           �   COPY public.petty_cash_detail (id, dated, remark, product_id, qty, price, line_total, updated_at, updated_by, created_by, created_at, doc_no) FROM stdin;
    public          postgres    false    318   ��      n          0    18099    point_conversion 
   TABLE DATA           B   COPY public.point_conversion (point_qty, point_value) FROM stdin;
    public          postgres    false    239   �      o          0    18104    posts 
   TABLE DATA           ^   COPY public.posts (id, user_id, title, description, body, created_at, updated_at) FROM stdin;
    public          postgres    false    240   3      q          0    18112    price_adjustment 
   TABLE DATA           �   COPY public.price_adjustment (id, branch_id, product_id, dated_start, dated_end, value, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    242   o      s          0    18119    product_brand 
   TABLE DATA           T   COPY public.product_brand (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    244   �      u          0    18129    product_category 
   TABLE DATA           W   COPY public.product_category (id, remark, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    246   _      w          0    18139    product_commision_by_year 
   TABLE DATA           �   COPY public.product_commision_by_year (product_id, branch_id, jobs_id, years, "values", created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    248   �      x          0    18143    product_commisions 
   TABLE DATA           �   COPY public.product_commisions (product_id, branch_id, created_by_fee, assigned_to_fee, referral_fee, created_at, created_by, remark, updated_at) FROM stdin;
    public          postgres    false    249   �      y          0    18149    product_distribution 
   TABLE DATA           e   COPY public.product_distribution (product_id, branch_id, created_at, updated_at, active) FROM stdin;
    public          postgres    false    250   �      z          0    18154    product_ingredients 
   TABLE DATA              COPY public.product_ingredients (product_id, product_id_material, uom_id, qty, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    251   q      {          0    18159    product_point 
   TABLE DATA           i   COPY public.product_point (product_id, branch_id, point, created_by, created_at, updated_at) FROM stdin;
    public          postgres    false    252   �!      |          0    18163    product_price 
   TABLE DATA           u   COPY public.product_price (product_id, price, branch_id, updated_by, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    253   #      �          0    30122    product_price_level 
   TABLE DATA           �   COPY public.product_price_level (product_id, branch_id, qty_min, qty_max, value, updated_at, update_by, created_by, created_at) FROM stdin;
    public          postgres    false    314   Q(      }          0    18167    product_sku 
   TABLE DATA           �   COPY public.product_sku (id, remark, abbr, alias_code, barcode, category_id, type_id, brand_id, updated_at, updated_by, created_at, created_by, vat, active, photo, external_code) FROM stdin;
    public          postgres    false    254   n(                0    18178    product_stock 
   TABLE DATA           g   COPY public.product_stock (product_id, branch_id, qty, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    256   u=      �          0    18183    product_stock_detail 
   TABLE DATA           ~   COPY public.product_stock_detail (id, product_id, branch_id, qty, expired_at, updated_at, created_at, created_by) FROM stdin;
    public          postgres    false    257   !D      �          0    18191    product_type 
   TABLE DATA           P   COPY public.product_type (id, remark, created_at, updated_at, abbr) FROM stdin;
    public          postgres    false    259   mD      �          0    18200    product_uom 
   TABLE DATA           \   COPY public.product_uom (product_id, uom_id, created_at, create_by, updated_at) FROM stdin;
    public          postgres    false    261   E      �          0    18215    purchase_detail 
   TABLE DATA           �   COPY public.purchase_detail (purchase_no, product_id, product_remark, uom, seq, qty, price, discount, vat, vat_total, subtotal, subtotal_vat, updated_at, created_at) FROM stdin;
    public          postgres    false    264   �M      �          0    18230    purchase_master 
   TABLE DATA           8  COPY public.purchase_master (id, purchase_no, dated, supplier_id, supplier_name, branch_id, branch_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, ref_no, printed_at, updated_by, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    265   jN      �          0    18248    receive_detail 
   TABLE DATA           �   COPY public.receive_detail (receive_no, product_id, product_remark, qty, price, total, discount, seq, expired_at, batch_no, updated_at, created_at, uom, vat) FROM stdin;
    public          postgres    false    267   6O      �          0    18262    receive_master 
   TABLE DATA           6  COPY public.receive_master (id, receive_no, dated, supplier_id, supplier_name, total, total_vat, total_payment, total_discount, remark, payment_type, payment_nominal, scheduled_at, branch_id, branch_name, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_receive, is_canceled) FROM stdin;
    public          postgres    false    268   �O      �          0    18280    return_sell_detail 
   TABLE DATA           �   COPY public.return_sell_detail (return_sell_no, product_id, qty, price, total, discount, seq, assigned_to, referral_by, updated_at, created_at, uom, product_name, vat, vat_total, assigned_to_name, referral_by_name) FROM stdin;
    public          postgres    false    270   <P      �          0    18292    return_sell_master 
   TABLE DATA           P  COPY public.return_sell_master (id, return_sell_no, dated, customers_id, total, tax, total_payment, total_discount, remark, payment_type, payment_nominal, voucher_code, scheduled_at, branch_room_id, ref_no, updated_by, printed_at, updated_at, created_by, created_at, is_checkout, is_canceled, customers_name, printed_count) FROM stdin;
    public          postgres    false    271   YP      �          0    18311    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public          postgres    false    273   vP      �          0    18314    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public          postgres    false    274   �X      �          0    18736    sales 
   TABLE DATA           h   COPY public.sales (id, name, username, password, address, branch_id, active, external_code) FROM stdin;
    public          postgres    false    301   �Y      �          0    18750 
   sales_trip 
   TABLE DATA           �   COPY public.sales_trip (id, dated, sales_id, time_start, time_end, active, updated_at, updated_by, created_at, photo, notes, created_by) FROM stdin;
    public          postgres    false    303   �Y      �          0    18762    sales_trip_detail 
   TABLE DATA           �   COPY public.sales_trip_detail (id, trip_id, longitude, latitude, georeverse, updated_at, updated_by, created_by, created_at) FROM stdin;
    public          postgres    false    305   �Y      �          0    27180    sales_visit 
   TABLE DATA           �   COPY public.sales_visit (id, dated, sales_id, customer_id, time_start, time_end, updated_at, created_at, created_by, updated_by, georeverse, longitude, latitude, photo, is_checkout) FROM stdin;
    public          postgres    false    311   �Y      �          0    18322    setting_document_counter 
   TABLE DATA           �   COPY public.setting_document_counter (id, doc_type, abbr, period, current_value, updated_at, updated_by, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    276   �Y      �          0    18332    settings 
   TABLE DATA           k   COPY public.settings (transaction_date, period_no, company_name, app_name, version, icon_file) FROM stdin;
    public          postgres    false    278   �[      �          0    18339    shift 
   TABLE DATA           e   COPY public.shift (id, remark, time_start, time_end, created_by, updated_at, created_at) FROM stdin;
    public          postgres    false    279   ;\      �          0    18348    shift_counter 
   TABLE DATA           v   COPY public.shift_counter (users_id, queue_no, updated_by, updated_at, created_by, created_at, branch_id) FROM stdin;
    public          postgres    false    280   �\      �          0    33393 	   stock_log 
   TABLE DATA           `   COPY public.stock_log (id, product_id, qty, branch_id, doc_no, created_at, remarks) FROM stdin;
    public          postgres    false    321   G]      �          0    18354 	   suppliers 
   TABLE DATA           w   COPY public.suppliers (id, name, address, branch_id, email, handphone, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    282   �      �          0    34580    terapist_commision 
   TABLE DATA           �   COPY public.terapist_commision (branch_name, dated, invoice_no, product_id, abbr, product_name, type_id, user_id, terapist_name, com_type, work_year, price, qty, total, base_commision, commisions, point_qty, point_value, branch_id) FROM stdin;
    public          postgres    false    338   1�      �          0    18204    uom 
   TABLE DATA           V   COPY public.uom (id, remark, conversion, created_at, updated_at, type_id) FROM stdin;
    public          postgres    false    262   �	      �          0    18363    users 
   TABLE DATA           U  COPY public.users (id, name, email, username, email_verified_at, password, remember_token, created_at, updated_at, phone_no, address, join_date, join_years, gender, netizen_id, city, employee_id, photo, photo_netizen_id, job_id, branch_id, department_id, referral_id, birth_place, birth_date, employee_status, active, work_year) FROM stdin;
    public          postgres    false    284   0	      �          0    18371    users_branch 
   TABLE DATA           R   COPY public.users_branch (user_id, branch_id, created_at, updated_at) FROM stdin;
    public          postgres    false    285   �	      �          0    18375    users_experience 
   TABLE DATA           z   COPY public.users_experience (id, users_id, company, job_position, years, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    286   9	      �          0    18386    users_mutation 
   TABLE DATA           w   COPY public.users_mutation (id, user_id, branch_id, department_id, job_id, remark, created_at, updated_at) FROM stdin;
    public          postgres    false    289   V	      �          0    18395    users_shift 
   TABLE DATA           �   COPY public.users_shift (branch_id, users_id, dated, shift_id, shift_remark, shift_time_start, shift_time_end, remark, updated_at, created_at, id) FROM stdin;
    public          postgres    false    291   �	      �          0    18404    users_skills 
   TABLE DATA           s   COPY public.users_skills (users_id, modul, trainer, status, dated, updated_at, created_by, created_at) FROM stdin;
    public          postgres    false    293   �	      �          0    18412    voucher 
   TABLE DATA           �   COPY public.voucher (id, voucher_code, branch_id, dated_start, dated_end, is_used, updated_at, created_by, created_at, product_id, value, remark, price, invoice_no) FROM stdin;
    public          postgres    false    294   	      �           0    0    branch_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.branch_id_seq', 14, true);
          public          postgres    false    207            �           0    0    branch_room_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_room_id_seq', 41, true);
          public          postgres    false    209            �           0    0    branch_shift_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.branch_shift_id_seq', 4, true);
          public          postgres    false    296            �           0    0    calendar_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.calendar_id_seq', 1096, true);
          public          postgres    false    308                        0    0    company_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.company_id_seq', 1, true);
          public          postgres    false    211                       0    0    customers_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.customers_id_seq', 1590, true);
          public          postgres    false    213                       0    0    customers_registration_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.customers_registration_id_seq', 1, true);
          public          postgres    false    306                       0    0    customers_segment_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.customers_segment_id_seq', 1, false);
          public          postgres    false    312                       0    0    department_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.department_id_seq', 10, true);
          public          postgres    false    215                       0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public          postgres    false    217                       0    0    invoice_master_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.invoice_master_id_seq', 2246, true);
          public          postgres    false    220                       0    0    job_title_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.job_title_id_seq', 7, true);
          public          postgres    false    222                       0    0    migrations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.migrations_id_seq', 150, true);
          public          postgres    false    224            	           0    0    order_master_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.order_master_id_seq', 124, true);
          public          postgres    false    229            
           0    0    period_price_sell_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.period_price_sell_id_seq', 2652, true);
          public          postgres    false    233                       0    0    permissions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.permissions_id_seq', 515, true);
          public          postgres    false    236                       0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public          postgres    false    238                       0    0    petty_cash_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.petty_cash_detail_id_seq', 419, true);
          public          postgres    false    317                       0    0    petty_cash_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.petty_cash_id_seq', 59, true);
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
          public          postgres    false    281            !           0    0    stock_log_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.stock_log_id_seq', 6375, true);
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
=ͤ(D�DʁB�I<ي�H�H�,O�%}��n{����cP*��ǠT,d�1(��rJC��Rɐ�2��wiC��s�6t�9�����ْ��f�q|�R�}��r������!�����!��N�r��R-G{�+�v�q-G{�+�n�$���u�$�_Ĳ�H��n;�H����N�r$�P-G�����������SO      �      x�՝ˎ�u�ǭ��a2`p��Zr��զ��# @`
`$� 9@��)ޚ�~�v��_�l����}Y{�KU�p�ë��������^�w���?�p>�.�n�Op5�|��������������������_��_��&d����?�}���ۛo߽~y����������������n�G,����	�����������O���VF�J	�E&,fle��U����2�Z�1ai�ħ`��?g���-�����_��	�{X1����~�}����͂����/0�޼�_�V��|��嗯 ��
���3l�"VT��SL� 09I��J�A6�	汮(15-%�eC=V�p=���Ċ��FrX�[,�Mu_p��N,R�$?U�RM�p�d��Y�O���Xf,+���9&̍�~J���Ai~!��p�	F�>�n"M&eSVd��3(7��'��J�L$�
�R����A�8�p�&*��,��f�*4�i�͡q�7/�^n����=��qi��=�{s�������w7�c�|���D����`�߽�M�����훻�OvY~����߿�����[�gF1�Wّ�DB�l��Sm����V�>��kr�Iͤ�MҎ�̆�D���\�I���H��u��DO@5��dv��H�%���}����Yt|_|��LX$~L*��ZP�L2�4Ѡ�4��#
�G&V EO%�]"�r*�t%�MJ!mp)�)h*�*���L
�jt�m�.N�Ǯm�i���K��e�;jEb��|(��Jj��7 ��*��!m�2r��:heqqɢ>�"�8�z�����i��+�&L��ّ�:�
��X�e
)f<)�#�2	*jHK�{����\f|)I�L+�i���{��ƃ4���M���=ǆ�y|E��4	�'&������ҧ=�6��`�հ�M-!C���O&EO$aa*�J�\E�0���r��gy[��������(�&A�e"��!�0� �I���IB�f�(��>$ʉ$M��J��U}�10�UH��� c�0E�0y�D9�ʑd�D�;IA�f(�&k7aB9�Zu_�6��]!u]a.��$��4|L���������D��9ˤ�jmފ��EP�[{�����+7А.7����V�c��D�0����*y��֞����,Pծ���b!��b��뤘)(&Y&�Jw&Mo=iAQ<C���2��2Γ�'�ܴ'f�al�S�0�>��'Eu��G����.���!ɰ "��H���F�wz�BJ�$R�UP�p$7y�e2(�/֜�UP�C��d�ei��I��N��V�aN#nji3�0GM�@�isMs�i�8|����#wS�k���m��+�P�M��҇�"�-ˌ��˖ij���	+�<6>�&�Q�!%VB�I!,L��5b.��v^	>S\"I-g�@��t'��(�QA�^)��H`�\�9�J+�4���ET:��'�q�b&+4�3�Q�>e�FSI!�Q�|�2�<���Ƙ�*C�=��"�z� c�.��LJDY���y��
��UI3�F�\)�:�D�In�r�Vri���c�fR('�$I�@R;�T�*i��Hs�D����}�dq�"B�Fd=���t�]J�Ɍj'zґ�I�5iȌ#U��/��x� 5��gǅʉ�C6��n^�_8��m�_�z��|���gz��f�$2�$�SH�ݓdiD%Q�'Q�\���Bb�JK��Yt�W�#�v�i�8��Vr0Ia#����9�eƱ�0�il�~'7��q�E���jL����-��S7f�+�i�u:�+�Y&)*�%���*�����`O��ȴ�#��܉6*E��h���I@��<�F���B�Q�c��@A]:(zJGY5J(��f��F��̻��bU>�NT4?fb��a��5��N�Q¾���.f�XDx����T	E������j �
aV��⛣���\�H��U�&[
+�9�$�WI`�B��`���������fcp��
h�T=��)�)`#����s�ja
vR('�=Q"a�.�=V#���s�ۡ�Q�Y��nu$]����A��rK-���ڱ&�zԄ�� 	�#u�>��:��t��Xr�_=�{sS������R��$0E;U0mD�yi ��~F���|�k�j}���x�A��ϝnB�jz�I_�oj&ͣ�iub�B9K�W �,[��H�̌�]Փ�`QrY}�ZM�� ���i�}���	U�0ȑf�inK�t��jE�P7� �Z:�l��2L������)������4�ᱷ��݆K2���h�d�a=��2f���6��lc�i~;~N�,�ej[Y�|*�`�ͬ�"����F�2~X��x�+%+�I��`,�o���$7),c�{P�u3�(f�v�������($0(�Q�ɔ�s���ԧ%�P����΄b����1�|Q�)��e��HͣR��8�#U��L�$ˬ�PJ����4GJr?��8�Ԉ�Hj���:uP�'i���C���L��K�"�MNT��sU7��i�P���UO�,�ArX��Z�Vk��T�L
儚�"�F��E�C��.��j�
j��/�J�!:�sX$������ܲq��E�Z�����@�dRoIJ��$aVČ���jxSa������_ms�,S5�۞a�$ou�|$�X���߼o>�]{�`81�I-Ďz�x�������I��m0�ͥ�cO�_�ϕ?a��jh���QMh�U;��J
Mq`)X��>w�{� A�q����MW��I�UH��B��P�V�W��ٶ�B$'��-�j#ի@b�݃���9R^�x.��6T"Z 5X̓t`m�n/2�v�a�q��E`��4���S,�Z���X�억�&�+D��� �=>� ��v��F�a�ƱQ�L��c��H��$�n�)�ҽuP^u�W��#}�$Os�|����i�L*�D˭I��rSDFO*�]d�L�:lW������X�V5f��@5�5���E��P��Pn}�Î�~�L�eG����"���G�u�ꓻ��N�;����i,ړ$��&���,C�#�MY���%�6�I�ls��������Xթ�Ic�.�|��c)A<����``5����Yj��ί5U���'I�DZG躍9�s���M{'u�D>4�m�4v�$���XLH*�ۧ"�ƶ�&(n{@*����%J�j����;&='�2iTI""��"ݓje"I�.I��?*��Sj�I���zY|vfو�W���	�-lO'v=�D�u�V�4���8�۵�QO�2�.j>��R�O����!,�au��H�<W�=>�VF����H��f�22�fQg#�N~�HH�HP�xP�8FX㓒
XFD�[8��N\���-��3���ֲB> C~|@+8/��[	���2au&�Ƅ%.>F&:��X�8�Tdl%t�R|�!��@hȋK�.:�Xk�[bu�$,��T�>�`5&,'����N���[�f�����۷���O�����˷O8>�|΅�|qǴ�;�A�"3r6]$���9~|�Vۂ5��k���H��"&ViHX�#�Ƅ��E����?�|.���C!,��űV`���N<}�8�mY����?��A`��l�,�gFm�B��w�.��X���?����k�z������O+Ӽ��Ow�����(�I�	��j<?��.��q>��|]�����hLk%��J�Z˄U�N�R'��"2���D�݄e�^���[��8�%��,X��`5hldlufl5$o׶�x��=ߟ�����)��,'_��.����+F�SCZ���+jaYN>Y���GX����i� ��Y|�����/)]uHAj-3����3�O`=}�3y�l�(y��<�'}I�j<�kDWG��9�͠�x-ozM+�!�"V�HXy��W�c;�֨�k(,��塙���jLX~�)�ыS�*�b�YEP㖵����-Nmf:1$��$�:���U��J��22�&��tb�LX�+�A`q���-iaN�+9���_�eΖ\���sZXA���aY���L\�<��ƅj���f@�baab+�+Y+����a��
ָ�9q �  ����׊����a��`j�[$'6$����qSG���:� ֱu~�1���xDܰV�DX�E-,É�m���w��e���c��N����g��9�ת�e�Ĵ��8�&Yk��5D�i�����
3��b�*�b60�8j����\��P�����4�(ܙ�C��	 X�3c+"	b�e����N�`�	�~��:4��e+ɉ�����s`�'
XO;����cΓs�Hk����.���		k|P��ykA``�z�[�3�ն`MfY��d��d���1���l`��3�	`=�*���e�6�:�;-kE�Vf�V���.����
�cDB�|��[�k�e���p�W�
˰VkLX	������Z�a�Frb��*[�&�Y1��1^�De�Ӻk:�b<!a��y�Z��n5���2��e��/4aE),Éux��3ae$��[W��^^�D2��z�Ka�NdZkx�s�*X�aQr'�
k��c���ت�	+#a5����z6��9?H����b�6��}N�b����2a���i'�Q�r�2؆���]�XFl�������jcW���c$˷��݄u���!ߙNtL�Zg"'��6�,'"y�6f��Q���Z�����ʉ	k��1t�6k9�-u
�3�@��K[�W�-�MX��ۇ�o��,�z�O��i���i��0�f�aW cEOَ��7mx����%��z(چ����g\-��'K,c��6E�o��QѳM>'��܂u�r�O0�e�rH�"H���N� �+'R0�$I [n��(��*��F�^?YQ#ɧ�k���I`Vn�[��H�$0U���-GKIOI�[A#�=�u"�I�X�D��&�u�QmC��'T�-�`h���e��U��b���f�=�F��G�nԮk��`�$���	��1`��K���2���	6:�GtGB���K��U�T�e:�2}�eF���:}��P������M��C��]�O�b1m�(���DPks���VL]7$L�����U%qO 9����%&z��Y±Af�X�sk�QѪA�KbT�G/ɘ���\(eJ����Nd�(|~7x"����)�]�SX�Ә�Y�T��4��RH�aY`f~5��yL��p�2�q�t��\CI�ma/����G�I���G$0�ٷF�8��.�Z%u��:�IwIi}>S��'Թ��h�A����w��+�9���s�� KlH\g�!]#z扭G��a��i�sR�I�]�]܌R���z�VcW��MCZ��D)���Z\h���L1�k��4��D��1J7�:���I��R��Sϲ�&+�X�Q92l��;,��S�Yh
�4���`�7���F�p��ۍD������	r��[% �Ef�BUuR�W�L�27��P"9�33l�a���Uy�8���$�B@��A�D%�[N�P(3�F��
0�D��M}*��:�Es�4��qnQ?걊���>��b�~i��ROø-��;&�)���6 ��Y1f�g�'i��<�|���w��ܾ|s������{��������Z��)��ir3i�I�E15���g�i��K�BAZ���~lZ�x7�� s͹��6Z���d#3�~��tS�
�Ѝ�bT�l'։~BMǀY�X3��LX�^�zf�D�(��/�tMpGo�2����
�3mĩP�eH`�B���� 0�S��#��q$�3UJ&〫��p��V99Y8�;G/��ۂ��9y���e eS#Mm<�2�#Q2�,nR��󯡗��p��Ar�����X.CI��Q�.`�t�$0�Β�i<3� �`:����M3~�Sf<Д���(����Mɒ��L�7Y>��)�"�44Rbe�e�:�������>zHճ��'�U9�JA�2V�iE��JA���2�a
0��P��q�\Yq��+��ٷ)G��#�`%�êbzbR�M̂�HB0�$2iH�3)�`�Dl���߽�D�\�up��H��x$v��[�`*Q�:��!�B��LY�4��ꎽĉ�}.-]�X �)��zBQ0��"s7I��N�(*���Z�@j�iQ�Pj�T�~'��I�B"��
`RjgR6U� 5������g"�`�z�4���+8�e
�Fփ�����8Go��!8=�� c�i������Jb&p������M�c0X�bނ5���Vq�[��m| i��)'�xSƂC�>ͼVx�^��q ��B�3���z�����@һ$m��אc
�'�c↷Zf8�l�������m�]�Ԍ���,޼_*?���_A�I
$�,�H���V�cO8]书#.L�	���{R�ʛ��>�+�ڌb���{��f��9s��(����ǋ$v���(F�fb)*��W$0�44��b���'�u@)�H�������&���s�a!O��;Ćd"H��~�T=�\D�n�͍嫏�4	O:�ˤ��@I��H��Gi�ͪ>o���"`�&���#i浝߾#\LC�^�a`%RD�]��L'�i 0��J�`:�2��ܔ@`����tR�ԕ�05}��X�i�(u�U�:W��R�(��>|�	 �J=Lp���u���^�U�:(|.j��4�(��(�T�;�rJ������+I�TwTN�L#�6�d94�n�A���$ГZt<�����k|p?�m4�����O����d���/r���Čf�H��M����@��M0V6�8�8#K�'1N�+�$��b�������J,���"�D9�9�>�I�q(2�L2n��I��$��2z�z���T���@U.I�g!�����<���eI�,#Im�x��R9�� ����I�5_;kڈ$J#�~'R��)�=�F��q<i?�P�[�0y�H6Zo�16Z�0���K��J|�e�X��H�0�-�{wF�I4q���6�x�*SI���N���٨�sp�$�1�|,�r?�o_��r���H`2(zj'�!�UMڼ�ƶ��:%�%|8֊�"fe>J�iL�+��҇f�\��ϭb3+��s!��NS2�J���T�yk�hURRUqYፚqT��U>��i$$S��t]&�c'�
��oЖ�4�򤹝g����>��@�:v���I�<��P���:��Τf.	�`P�!�r�+��1itXP3:'	a������.P͵]�3�"��?��Vg��:"����j��`P�M�޲�d��( c�*��>��F�3�H#�-#m����i��V�ȑ���ja;i������Q	L!u�UfWo���i��%r�����\n>��
�8�OcYf|�)�ʆ�Ҹ���h��pl��e�q@�ε4�.�`b��B�^]���L?P�gE�0�G�N&�����I�� c�q��Ի��0��L�1C
�(f�$I��MW�{Y�OL���p�slTI6"�s �s&���P.(ݣP�f#�UA5��yu��n�R�����b.��Ϩt��|����>;l���,��V��(��>J��DʰB�H�S���}CLu���'�P��w#	�H�LF0iܝInJ$0��ɡ,��Wc�w!qqb*�B����$���s���Ƨ%�P5���)�#��ݵ��#1a"�{�[G�>`E5�#0/>;�F�jA��Z �F:��q@s��悉@��%�&���#i�I���M M#*�H�)�Z��Hnj���$0in��["�h֗��5�E]{�������D_#5Q�y�Opؿ��7�|��'�J      Q   �   x�-�;
�0Dk����j����t!�L�4��!����G�L1��qO�����\�ex���;o♶���D�k�.���y_�QD�3
��9��M�-���칰�Ő�F�Q+� Z�D�-(�1���i@�<ʗ�R~��'�      S      x���ۖ�ȑ�{�~
��f~��wHf03��TDFq�knJ-��K�Y��g�<���9����y!��������]�n{sz�y|�}^���ӻ��}�w��U�N�;W9�����n���C�|�N��������#��û����4��P��u��r�S5�x��������˩x�uU��t�������� ��۟��Ϣ1��]2L�*bx�޾|5��UA�	�8�������!��6&���U!��g��#���_!MC Bz/�φP��:�4�~$����}��!���3�
@��	�ewuĴ�c�j y�����3 �u�jB�n�m��gA7<���4�`8V�7�����~(?:ĸ�� XC �>o��_�!�\\��IC-����E�~��kT`?�x6�n�-�4� �����:C�!����0�3���nW��GUC�>W�b���ў�! ���O׽�h��pAC�!~,�`|ލ�! =�����l�6�F�~� ��w�F���IC�w����_�|����X����h ��~�R5����|�]����)���!�i[x3ܝ��	B�!T��D���q'�U!h���� Ќ1UC ��l�GA;n�U! W�y������z_lf!`_x�4�^#p�/��m��F�fqH�5�^����YCh���>���7�T��6����u8���wq���=�޿�����uH�~��U�jyħ��}�%N������ 4�.�n�݌g����qx�r�ݥPZ��T����E�(T�Uj�����~y��?�B�<����>3�b�{���n��v^��h3U���y�P���l7~3t��u�^j JW��J�qwҫ�§����X�ߦ���v4O���Ch�{�2��rQ���Cuf�4����d���J���햿�k���z�l^J1ϗ/�����G�S5������_`�8Gߴ�Ǧ�t�R+.5x��u����a���x������ӑjW�)�ƅPž�t�XY>� ���a�æt\]�&�s�Ev�S��Ua�����~q�vu7������'�RC`�ໞf�a�^����*�X��J�	:L�ۺ�ڶ�5�����4i����p*��m�����j������r}�a�s���n�����5�U��+����{#x5٫�v��0ty�l���h\+�o��|�̖��ҨB��K��[���\s�\Y���vH�m;.�^X��̤k˴U\	ӿ�J��������Z:���x:P,]���kc/����+U�`_��^����tb��<�ϱK/�Ѩ��c�6U5nQ.�t�r����O>����������0�Zn�&��,�d�=�zg^j�~��П�R�����[gw?g?km]o���$��	kA��1 P�P��!x�2��O���iU"�$������?P"_�j;M3D��GRj;��ҩ&k�H�$`"h5�q���Se��KT5������i���R��M~z;�j6��HTAp�&GB�!,_O� ��y�o��F��\�A����\XF&'"�-�ְ];niU��Y���w÷�i�����x�es8=��<��>[:)�qK׏[�%�kSj��B�jV��M�f�:���۴�z��f����s\5���������{��_�%\
���q'Z�3��z����J��<�ק�"���ͷ}�C��N*��0T�UjIކ��dk1�銃�� �t�����RC<����C�y�އ��ςt�|/�R�����G��+�DbBr�������� �������9�����G3�hϐX��h�z܌�w���]�� ��{]�Q�bI�H긅�UV��F�����}�f���O$x����B����_&��.�-kGϿ̳�%�^J��roN���߅5��6���6�@�P�����8�@���h���t�[�d��������Җҩ��}����������l"Iy�Kg:kIL$�����ai�-�� �f5����Uiȟ�����^��J���������/�����H�
N� �>���ۿ����2n7W���^z� �:�����1�<6�B��6Wj	��/	� R'��L���9��9%�XQ��Q����tc�?k��A�O}��Y��kyB�A$)��~�j�hӥzlU }�Ք9|q���1ǣ�#~��8H�8(&�����Ѣ�Ro�O��
�✵�A �M���r� �؋!��yx�؟H��R�@<��o7�m;mev�� ����0��� J��X�ul�)�SB�0ȟ~9=̯�/�4���G��#G��_� ��CC_Ə��±�M��r�R���y�~0���f#3 ��p�|�ߏ��Qq�v�-�UWqt
Gs��t��t������ ��ڼ�1����A^���O����D�A�3]�1�AA=�/6���{��aX�@ȏ����7�g؜_��Y�ȅZbq����F�B�ky�*5�����qqT�5� ������s�֝;	� r����i�Z�>�S5�����F�<��D@'���VKlͥ�X�D@.�%�a\�L�UMeQ�S^j�k�#+G|]��q��\�Ѽ� J⠳�WC,c�Iͪq���r0�m��b�!\�y��z�)�SJ� ��t�=��$��Jup^a�{����ɨU���=��kf�_�K	|?l|e���a�K��p�0I*���4��\)��9B�y+5���m�Q�3J��rr���Z�� �|oo����������3G]-_�I�8���r}Lđ��?��͸|_<0wy���|Z�1�R(5�#�q�����)��l����K��^09�&�m�5�2��� "r�7��V&���m�?�4���$�U�U5�����sD(�������II'���/�3��p���?����u� ��� J�j
�Y��s�q��i��3���5V�ؾ��K @�������2�קa�Ub�Ӊ��Z��^�ݩ�����[��f{�?c bh�"�����Z�_krJ" j$.hyϔș:z(��j`�p�;7�W"m-��k ��mat�X��Ԗ�@{Qj��F�x��'�I�|��6�/�V�� ��v�QRJ�{m�Wj��!M�5/�� �f�S���ݥ!��|��)A浤�� �\v�Q�^� :�[�Edx��o:�v�.�S5����+9�VNh����4��fj|U��������mR��+k��C���ђ+;��Ň\h
9�mjOj�h^S�K��z��j�m��~�����x�e!V�����B�t=��2A+��1�P��j&�d6յ��B#�����h~&)�m�dY�@j��]�ὪA\�?<]�u��Q%Rj��?m-��.7ԑ'v�A�]OG�/F���eX�@ȷ~>}��2��؜pX�H� ߨ��M_UU:Q]"��)������n��QG�^�6I�����<n�_��xM�)5���#�f-3}J�ٿ�ݭ	��R�*f�I�8h���L|�{$�Z� o-j�m6Ł_hy؏��a{�~��np���$�ݝ)����Mb�jH�ߛU ΫB�u���^`=M�KK� ��H���j�٨{M2.5�w���%3�l���򁰆p�|�������j���Z/=	kI�o�~l���	�/�˛U�l3����ȤA�YWq��=��AaN;y+v�R�VN-5�����+1D��e(`� .iڿզs��D�7�o���͵˯ɤA�;O�~�/�4����m��D�r_�.b���ZXD�f"�|�#�c��!4��, Tt�j��w��	����R��
���8k�m���r������[�gk�H�D�r��	!�B��9��:A��G�� ��M�BУ����U�؜��^*]'���k�˛�k \mҩ����W�K�2�B����Y�Z��@��Aq��V��B�e���n�&���p�������T��s�mʄWw    �v·.���
�R�`x��N�`.Ѵ�3 J���7}-�޼�/�t_�)�!0}�G�hIʾ�c���T�ٺ;�X����5}�7����$�A,����R�����,?��<� ��ӛ6�+�mdo<o�-� �<�魪��Z,��������9W��	Bh���A\h�Ս���S��m�ZjF7?;�<���y`���c2*U@<W%�� ��A �,��`�uOF��I�@\�m �&�l��q�w�k ���AhD���ْ��iO�>\� �85G�\R�Q_��
�Iw'���l���A�\��*U�8���ݝ��)�L���ܳ���y2;XBT5�ˑ�nl}Ȩ/�V���+J_'�g��5���d\�Z�e�� ?�3?�P������^I��/kI4�G��������c�ܘr��fX|�g�����ѸIy��	"���n]�f���EDA~ux�1%%����X����p�Ҋ-�Kw���CD����A#I��65��p��J�2�Hh	�Q��Ptm_��YN͆)$U�����K�|y���ΦŜ�v|�C�.<�P����L՞o�����AFhO��Φ��h��ф��hh"��T��x��������\@j�m�� �X�>m�����\��\��0�!T\���?�]��T�y[��Ԕ�W5���q���QCr�u���X|��!�5�6�1F�A i�v�I�F�u"���E�;�6u�a��T*4&�=n�?��8�
"�A��S�s��/�k�1p���I+��]���m���D��ݺ�����"g[�[�vRh	%�$i�`�!$<�i�^e]����Y�8�\>���qU���i������L(4������l-�S���Y�Hh����y��Lj�_�d�b�����u�Y�A1�f��8h��.{��% M6S�����A��i0��t�T���t���J�d�Sh	E
j�u�ڴ�q�9���h��~PhQ�rΧ��ƍIɝ�n�D}��Ch�a���YK��E�j�Կp�����r��9�Fv����ej
O,4��S	.4_u.�>ֽ;Oʉ9�E6B���[�Ma̩.�xYh��w*�a�U�j�o7ӗ*�D�z�R��p�aIW�{"ᢩa{?�шB�*�j
�Mѐ��E�&�Ģ�Nh'��ڎF��i>\� ���A���� �3�o-�9d4���B����&�m��	�q�N��
���� ��o�Nߌ/-5(�u�A �R�/jA�D��q�:�����J� i��>�f���R�!-6Y���6{� �z�f���D�P��B;���~�ɝ5��[�A�6��1kG�%b�E���"Wh�T[g�Ѧߍűb� ��La��(R��7��!2Jm�T�z8m���k�����1�����yث�4M�R���7m�Z�\���X�j	!�	R��B��l+U���|kh�ul�)�B�@��)�/�V�4���V���M�s+��a�;�~�L�O�S5�;�>�������}[׬��Pb�+���qP�����GSԶ�{�$a"ᨭ�I��r�� �3��ir�:V��p����ve������E[/�&�����A XRWE8Mh����O3GSl܄qp��p2�����Aq��0�ܱYW���4��ߺd�l,4��n����V'��+:5���ao�1G6C_̪���ͯ�+k2�J�+�5 $TحX!��Äq�O��!��p���q8���h�,�	���������L�YRB�Hx��
:��N� ���qCd	��r��� ��W�ą�>MhH�-Rց;���2'��ծ��
"�W��OVk�jIM��z�N��~q5��	�a��a�f��p�[*f�h��%�A y*�Ѻ	�f�q���"Ԝ)�7tuW���<{�����L_�AH�ˋmX[�g��� �/����L�!B(viB� �&a�0>�P���B�y�l�1�Ѯs
��]A���Dh���.O'S�DKm���.XhH���R*4���m�6�`�A yLՈ`��"�����B1���qkti4{�l�x|��׎zVW�Մ�4+
��f("�B�8ؽ�J@�4��IX��86��g������)߇����q
!�՚{�6�"�����|�e�O�FC��&4�}�v�X\ZJ�-%"�e\��#6�-ɤA aMZiK�J�rs4i�֭m��t�QKhG�k�,�g��a�A�ŪL#��O�Am���[nl�h,G	a�z�7U?�Ѳ����z��+u_�nuI[\b	"ራm�I�S5�5��}	!�!4��)��*U�@��ܘbzl��iB�@ث��ޖr���A�U���5���pt���,m���QSC]�8xX������j��Ai]���}�V�*'՞?�}\����Q5�����ó��qq�5��>�2�۩�W5�����0<ޚI|��"4��<�~<BX
S۩�Z�j�Z����Y�@�\@�y7%x�s����q�՝i@/7ae�h� r�[cl5�l�YC0��(�rY�6SU��Au��b�|���4��n�>ov;�$�6'����Y�@<�Z]R�1g	�A|��)4$W�2n�ZTh��c�E� ������5!�U���-k8bq�,4����!*�2sK����A.���#uu[.S� ���qc�s�PU��#Vmّ�6�U�C�:��8l"	�����l%4�$N-4� 4�D� �&��M2�2���A mnӵ��v���	,4���_��3��vTB�88��$��kȺо�HS���������֒&�F�"�Hh_T�#�^?B�H|���I��D�A aō7�,;z���۔zFFc��Ph�T���������憔��P|�S5���`�Ad��8���ꝱ��ww���5������U�j	_UYc3��s�JX�H��U;;� )]թ���1u�D7���nW��)B�VC�m-4�$�^`�P"��ɤA �n�L��h[F���w]E��b� N�����uQ�*4�������z�i�s��ĪZs�����{3i����d�E�UhGn�1宲Ѷ���k��v�l*�&��D�Q5������RъW5�#�/�~���$�^� 	<6�S>/�헮d� ���>Zn�:�)�aP�u�W0��D��Z���`�c��v��������)��]���լAx����=��s7kG=0X�|Sz�Y�8�A�:w�<�NF���*k  ]�EJ�� 꺲��-�u�q4�9ʹB�8�y�9Rķu�jyӵ �)b� �>g����!<P�n;�L�D��F� �u�&�g��5�d�D�.��WN� ��}p�k2d��� �����dT�������!���� ����Hʫx�A$x����h,&u��j=���_�A �Ԇܲ��^�.�g	�eVkId֨� �\�:^�g��N� <����Pl����8�-ab2*#�B�@ȻnLǉ>�4�%�C�8F��z>�>ۮ[�i|����h�֘Gg�gqQ� ڽn���}�n���Ay̶i�:ٔi�B�8Ƚ~:�2��h(���r���'�/.C�B�@���3V�Nf��3i�N[��nm�	�ˮ�B�8�Ǘ���I]F��kJ��֕l��w/��zb��ekR���be�`�z����{�r.��
bɁ���i.|����^� �.߹�DqN� �����L��GUCHxv���)�h2��5������/����䐫%Z2����A~�]d�
H�A�������B�8�,[o�>��.���{�Nh�,�>�k֝�A,94��,��a�j��>�������`�>��~y��4�����[�>�gVQ� r�7�+FPVG�WW_=�2Mwx���ɛ�5 �`0�A �������%p���5����!l�v�q�=֗��2��pg�P?�o�O���6    [U�8�[��t0~arc�34.r�������n�5���`��p�7�5��
Z��*.��g�#�g�6��>�co/��Ɋ��p��Z��U"�a ӥٌ��P5kw	x1�;��"�[\	���E�@Q2�/ǤA���z��NeƦ� �.�p�9���(�Q���R���ׂ���*5����F�4�+5�`
�ZrV�Ѣɚ� �O�;�Ө��R� ���1!���F;�.w���l���R�8x<�px��(�L��AM�i��p�Q� [�BaӃ)�2�y�R�8�g���z{6ꝪA }~O,�Ѩ�hl�j�Z�Q{U�8r��nk��֩r�5����hٛg�NfSI"ɓ�=���h�u�R�@إ�,�D��f��f��-�?[�߳���jD�A 9�j%I�5��<��a{�d�$�.�5��A$]��X���A(|῱Tw��tKY���TU��z6]��fC�jJ=ev�e�Tb����491�i�^�����ݝ�{KS��l��`�CME���0�M�J� ��Sevw�s6�My�K� �&�~��|�fk�jJ����}έ� W���D������]='u� ����W	�� !4��&��e8=:Y;,5��Ν?]'H�˵�D����'�BpAf(IB�c��i-��S]�򴪔|�"5����W�_u�;q�Y�����"��h��A|e�9^]	m�X+�t��o�m-�؄"ȗJ����Ro�����;	a��th�|�ɨ��PJ�A s��"e��3�e�XhIN���T��F��Wh�7oL=��F��H�`߹�V@��&G����L*�Z>�I�@�ni%G�p�$��ۚ:�d��8�
"�P�mxL6�~��A *]KRn�g!���|�蛮���Tg@�}��e[T5�.�o7G���M_��}�J�fb.�X��@e�.�AD j��� �����m�Ʈ���6�2EjT��Y��wu��)5�R����SE�G�Ǿ��V�� ��UhP�M#��gԏ-��5گ6���xx�AH���ǐ��Xhײ��-�����uL��*Sh���!L�����N]�}���ʓ�h*U�x8��0Z%�55�v�q�c%�7�u��]4"j��x�&"��+���m��u����)n�SM~�/�g����ig�軺�F�u�4�[�  �u���*k�vn|��.�D���EU���Q?���*SS\�b�[ȧ���R��u�����<}���5��c������~�̺�Q]t*�_l�fA����� $�]>=m���|l�F��'�V&AJ�"����u���xj���a"�,��AD���S5��|��F��s�j}l�V����s�k�%<�o��Ǖ�t���Ҭ�J� �������>R����ju��w�jU���i�.'b��7L&c�sA�0�ko�.O�H���w�ב�@�^��<�K?D״�u�S�65���AH��Y�m����V�H��U5���6w����-�c�j���ח�򍍾v�����Gӥt6׫�r��2�F� �(��^�M�OǤA4�妻i_T5�u�2���U5��c��"򲇈� "��U�&�Haܧ�VuC}�o�Z� �<��G�:UC��j��"�'�qg���^����CD�}��b]��
mP��tC闿�G��5\��rҮ_�o����S�~c{��r��E��*Ů���Փlj(}��"��Ѥ�h�"4$��A�4�d���c��|\�4^|;fbjrb̋�����Z[@)��-~�Y��({�ǑB�j�c��o;�T�+ZU�x��q��1j�8��L����4M�a��cbB"}��l:�u	�|!��)��/*�M����l]�M�Ͽi��:��� "r�)^�e���F��ra��8�
�
\棅Db������{���	[��7�r��֤��B��`K�I��( ratP
�w1uR�\����AD�j��<rS+4���Fq^�����2?�Z2�Lh�ޥAJ�/�\��>T�Ş����7)5��f�飗k?��q]��P��t]�A@5��!5�v�z�>?���4eЫDD!�g5�^ǺJ�4*P��yQ�  r��ÍV�u�(����AD�[b�iw�n|�1�Ǩ�"�q���}�@�u"jx*�����]Y�A��x�9<ZJ5}n-�jk�����<�+Ys�`Bqt�S���lܼ���҈h�vݪ@�Ҙ�WC����ݙ��c�0,v�q.��
��B׸x���0y\�I!����u���:%"�C��͓y�{��d�6T!u4V���+��q����6��N�Tu�������R��"�����W��U�� ����M�l3�B�8�zoP���6���Z	���A]>� �<xBE� ��{�A }�h��εoǍ�caOm�˘5��&}�翧���iZu#���TB�ߚ���1���H����PH5�V�6*y{d;5?�T������M>��ΟKD2��4�G�q��S��G*D5�yt��h5��G�����Ѭiҝ���dU�A$�?�̀Җǻ��~�zC���q{���B��s��|W����� �id���᥸�nb�����] ��J�k�#��QM^rMUU]��/�v���BhP}�(j rQ� "�����7 ��U�AH���G˙4Pw(�ڄq�\��
�9U�@bY�Ѩ�A��agj�CF����A -7T�5�-���b#*4���ӷ�^.�q����ǧԨ�R5�)o�MU�"&�8-�����Ԣ-�G1mKjw�0�����+v�A:��.�M_LD��A���4��m��^�jG��(��� �l6�?� �)#�t�'�1��R5�6���7�J����5U�l�����rŗ%NrrUlU���b�E�^hF�c��.>Ó�`pY��Ғ>���x� ��/'3FX~�'��ʒ��e(:M�uN� .(Y�n�B�@��EU/�4EJhJ�Ɂz��\UG%P(=���D��ݎ)��6��$8kWe?j�x��Cׄ�T���4)h�lX����_�����{��sH����'5����^�� ��k�o��x]�)��~��'��͔��Y�0xO�{�7HF]�)w���8�l���@8ש�����0c����=�A \x=��A��X�<	∜�a�X�]� �hk�)�Tr�������I$��-*�������5 ��A �4�˴��)[qt2�%4����Ë�f1RK��xm��p�v=J�j
�ֻ���R�u��M��X�B�\�r0��b�]�5 4���Z����,߿Hy�~�
M�����n��
2��P�B~v5H�jHw9US��uфYhG�5#O7�/1���O£�ւ��� �܊X;�h�[a��L��8�vg�s�e�U��tP�9�U�jW[�_����՝�A\cqw�P���,
+��4s����h�ةDu؍�+I(�B�H:��4���<�7t�qp���lѥ]���;i��}�>X�HG3�u��[�xk}m:��U"!ߺ�j�e��A�Z7����OoG��a�~��W��$�/�B�H(���@R�_���5��l?$�@�Ui�r�y�>W��ěZ� r��a�b���siw\A��iBCH�0���2�=�싴�A��s�>z7��%����p�����H"��p6��3v�������J��5MB�H�5���y�hl%�}�A&4��6����=�IC�v<B�H��L���n���*V�$����AD�x7��k29��}�� r��0dTXh����-�L��5y� ���75AU�H�Q� �î��eXMh'���f�ߩk���h���V�w\@v���.t�&S`�qpF�:�koc�ޝ.��c� ��*G���ABY�'4���W�ĢK�� ���O�.��fY�#4����6�V�ɍ�]�j�]w�ݝ�����U�����¸H�r�*4�����l�@M�!Q����6��J��KG�A �Xׂ�F� ����vk�8bڮ��jG����ݣtd�A$�c5%    ���P��đ��},'=2CQ� 4���ց4�U�� ڬ�J���&�V�;U�Hȷ~��vj�@��2�BF��B��ęY+�,_�T�������P\����hԛ~�>55�P�t�^l'Bᚮ�u��u�B�8(vc���6�"�)4������)�EV}Y�+4���3��P��9��R5����-�N����.�� �&g�/6�!�=�po*> ��禊���w��������Ͽ�뻉%�v�Tb��?���g+G]�D��h�<e�e��� ���O���?���@R*G�jH�@~��_~�r�G��W5�������s����ѽ�>['����Y�Hr�����Xd 	ᒮu m��.4$��ݮ W�[>� �K?l��d�]�g� ���4��w��媮�'mR7�P�C�*R�Κ�
B�o|����_�^��R�m�� "v����?��g�{���\�\{���t�S��ūD��l����t@$�)^ߨ����æ���k/�K�V�  Ԏ�2��a���_hH�9mw
d4�"*)4��v}JY f�X�>�A$���ٮ�Z�r+��B�@rv���L����,4$7P\�ѩ���~���R�@Fc]4���%��X��I�8������q.(�r[��[�_�u|uT�[j�*͵�y\Nēö�16Y����Z��v/�z��]�ä���������I��40->��1��wg���������i@)Ut���qJI�ʌ*�AD!_�ݧ��`�)n��ᕪAD�rf�Α�;U�8x���T0ٌN� �0�۫�����Zu}]�2ʀ�� �.7��й��R3f�(���<�v�����uT5��.7�9#݅q��J�ګ�Ah{��K6Z�=�W}�y0Y�js�i�m�d�^� �?ܪ;���=:��*Y�|UU��x������b��bK5k7
�~��rq��;_�J�{��T��z}g�x$���2k�H{ٛ��š���8�p��TNc��;e�VG���hY%4���on�Tס)��;�� ��AD.7��>��ZA?	\B�����3׈d��� ��[���H��F�d}�M��3b"�݃֨���Үj�����AD�����t)
�hn"4�͕1��.'���?�A$<�a��P�)_���yȾ���z�CMD��YOʹ��ͨ��>�ޫ5��^� &S��3�W�("�A �5��$�K�]|Ng����Z����.TJ1^7ͫ�U"�n��Ҕ�l�۬�V5���.������iBx�)*L���϶7{�ٸz<��W��'-�t�AD��?���)��ԥ�˿������F]����D������lZ���X8��=�`+��(�U6��n��l.6\�qL�ލ^�lF�j{���d<��K� .�}^�缺��Y�j	�ͥ�z��(eb�� ���AA���V�j%@<��t�얧�I�8:��j�h�M��U�@(��$zUC@�>m7����f�O߬Ay0�)#p�٫�A~��͝m��+ߪ�AYg+9��̬A��}٫W'u�wu8���0)_D���D.W�1�V� *����`��AVc��jT"����h�֙�^� *T�o�pp��������l_�>�׹%��]���B5�:z2Y�,4������8�eF�� �e{4m��f���w� �\ lh5��
B�@���?�t$_r�qD�T]����q�����}�q8rN� ��b����BlQ� �ܤƎ�2�A�P�l$l�_:�IC8|�ݟM!�>�=S0�S5�#�S;�"�]h��}07��Shh	��9����7��%��l0(4%��_�SH��A�Qښz��ͳO�A� |c��s�eת��r�gSL���4�������� 
��y�BC8B5>[9ҁ{��đG�\�����:������1iO�5���MRUD��a��AM��][5�Vrq�z*t^�� "��D�S5�(����$�����ԝ�A �mm�&�N� �v-F�<fM�ѭ�YR�q�j�4�&�06nPh�h�\"�!,�Z����d�4��}��s邺Q5�#�a�����W$D����~G]��qn�cݿ��s��!4�#���r�4i�Th&;�8����N�ا���٫��N�w�E'�2U���@��WM�s_���:�x��t!�:�%A��^�:�����?�Cs��\B���8~�?���*4���d�gϡC�4��06�|��/4����^m��ظзJZXOU
~��5)�ꦒ5�� U+P�N9W�}ի]�F�yj���5�5����%?�Ԫ��)�/'���gqu�R�;ɇ�^h��ު��W���x��v���&z��v���˒�4�o��Y���)	��zrO��(����t Q��ʬA(~*�^l���򢳜� ��M\-��G����uwU��N�kQ� ��߭!*JW�5y�}�tu|��y��h=ݠ;y��D�q���s.TZk6��1EjR� ��N]j{�gG(�!L<��v�I`㚶�B8ر�Կx��X���M�8�S��o~��B"���};w�f��R+���D��i�R���kL�Ԓ���_n>������[��Y�@��~YAB1W\jo���R�l5�?���"���S�*����Ǎe��Fc�x%5$;aKl3�,6RC8r=ٚ��9!R�@rk1��k��/?ٓ�p���}�*w��S��������r��z�q���?����� ���W5�����_�����Ƴ�X�DB�����n��l�yU�8�w����������g��V5�#��}��$���Ъүq�=�� ���*"�Ͽ|��_�˕�i��I�Xjb��_���ڟK/��Jcɭ)�`e��{U�X<7���O�SI�y��a$�d��������%���U�j
��������feIM�jKC�/�e�}�8�����J�˯?��u���ˠ��0�i�!W>m�B�j7n4�z��T+P�R�:����ץ�J�0�{�<��vP:Kt��a,.�eZ�RL���B9b����h�|�'	9X{$)��b�z�)L��hdW�aL\���L��aLO[�����2+WjW��Y��I�@8�a0o[�.xqh�4��s��V�?k	:{�~5��}�k-^�I�@� �[S	�h6�U��M�a(�v�O�j6��Т�a(��Pʻ�Y�P���F�0N[E���0��wr�lﱣ��q�0�<����MR�8�@wgꍖ�v����0�i���f���~<�5����1k��g�Խ�a$� �7�FSox�ႆ�8�����?S��6l4�YgQW���PEj�'�������T^G	c���������0�+ɮ��HhK����o���k�(����Pw-I�hf#iy�V�Ǡ�Ģ1��0�[�R�=�W5%��q����}����f�@y�Aq!ڧ�`i9����/V�Գ��L�x֡�+U�a(���M��Y��D�W5��@���d����l&���FB=���N����)#irG�u(�h�0�\(q2�?dV�lHC�j���`���j�ګF�gC�W2��x-A&��g���w=M��T#��ɦ	��Ŧ�0���.�����K�0�7�}5�;U�@��t?,%��n+۠Hc!/��~ܱ<�T9<���>���~O铵��,5����!��BBh��S������o��7YNyK�0��t|�fU��]q.4�<���c��hu��):�Hbh�O�of{eb��0��KJ�N���:D�Nj%~=m?�]:�𺁽�c��6��%��N������A�4����A�Ҵ�����idNT5"g��o/�SHX>�0r�����S��A��ty����Rw�Z�0Ι}~�,�M�hdݩĐ��Ҋx|�ę-�f��4���/ӯ 4)�QyU�x��!��T��!����ro㻪ߙ�-��F]�h^'߬���YAh�FG�v# ���\+4���>#    %D�M�מ�_Ϧ]qg.4�O�����'�A�a�E��S�~���(j�jNXl9k��<���*LzC��A0y���a��Վ�h:U�0���q�n\��u�1�R�(7�3E�<����oB�@<�@�^
Jjn�8��0Jxܚ�S�h�pg���DHg��%��_g#i8��ٔ�s���#�Ԭ������4;:U�H�������2[m���a$=7;���ؓ]G�l�jK��z.��Į�$!��>�<ɢ/��0ڴ~ܾ}�	t����a.�?<o?]9ڒɺ܉� �������sa�E�W�a|��^�����
��c���g��R�K�0��Q�v�B(R҄�1��r�l�8VK�I��|:\	��\h�u�ȇ|��]�����!�4������=_T�c w��0|y��1�����A�){|��v:ʰ�5��Ѡ&��
Ih��w�ǣa=�2�3���42��4B��LT5�������b�M@h_#�r�Tz�|;X�8���dё��Hp��$4���;H\:�I�@�*'�]�.s��mJ�����Dmڦ��8S�j	o<�+%PƽS5���ޭf���R5�w�w��ތ9b�jCv�{Sp���;�N�0�f
e�*'rxU�H�|*����o�e���a<��鉴�e,�œ��Ё��͏�8:j�k��S�MA92���a(|]���>�H�e���0
�ڒ�Ȧ�oͤay\�g;H{�@X�@?�����2��w�4�����'S�%n�;�4����lo0m��[t�a -7p���z��5�����$u#�U���i"یa��5���v����f/[DK��C�p{�_Hf�b���0>�?Z2p#��9�B�8<��;<�明vS���0
c�8������M��0�����OV�4�eI�F�pݨ�LFc]D��������4"��^�ҙC������ꂌ�����s�Y��M�1.4d]�T��_֪��p{��~C7�F�\������O����r�ʆ]Qs!4�"϶oq́vy�+4�v��@��|�a ����ݝ,.2�<��5�{moMe�Z�5E�Sh���v����	�N=�����v�s��(�������S�,�e_0�A(\6�x2���h�EXhM�ژr1�T�ը�Aс[��1� �^�0�Ğ�M'��bh�짙4�$�V��[긵�q&#�.,+I�S5�����T�����ɤa ��o
Gǜ�[{U�8h�bG����0�~]�_L�ߺ^��'bi(P𰵺ؖ�]�@��~��\�1�3ߤ����w4�F�ն�%F���qI�j	mcO��NR��F�}�h�T�A�鼳���ǁ�xj��ZK�t#ɳ�MwԓQ�k�<ܘ�LVC�jI�����>�ԙb�L&#� uĚB�=U�@r���������p���fj�LVC1�Kj	��Z	��WLB����o�|��WKk��j�[U�X�������\�4n����5��y nUC��/��������t����/�%���D�U���_��]^�L���	~���7� �Aa	���g��[�'C��/�����:�.�ӳ�q����2u�c���ՙ5��[�C���\�a(�e������ޖ�Y�H�����Ӷ`��b�LFB�؛�[�\gi���+|��0�غ?w���ɭ6e��� ��z�Vꥫj
��筩�9[�E���0N��d_*�Zq�밆�xn~�l:7t�AH�a$/H}%lu��"4+4����o�of����0��������Y�����?����a(�k}{��ilT!G{�쏤S~��uUl�{{R]��B9ۧ��
��>Ph{�5 ��OB^v�}���<P�jU!'�
�)}	���cJrhr5��T�1ك%Ϗ��e��0N��u�ora_�7�5�[�ξ��PD65�1r�2
*4���kmߌ ~9XYh�_����J���e��a$.'����S�Q�����<n0��7�	4���a(�\0<L���l�j
]z�lM#��j�E���0��s��gb; r���B�^�ýu�\שFBN�e�7Eχ)6��0EWs��5$��jI�D³�Ƴ�֒HFVc9�GhI���?�2b*��K�?i��Ԝu$e�`�0��Ͽ�Cפa �d�7?m��?�M򪆡��M���(�l�8iJ�<ZÏ�L�ת����=�M�d4�U���tkA\��l����? r��8���QZ�V�;�L�B�ٯ��ol�Y�g�䭛�1R�z凢JDhmdO���DU�8�5�:���d�0���Ǜ�R63Y���a$�E��.��N�0nP�1�:�F�[�Y�@r7�ۭ�<��p|�� 4�%ob�[K��d�)$��å^�M%��M��u\����fx�ŵ�hP�1����֖��VC�S 4��缺�(��a(�}�v�5(u�jJn��l��U���]�]�uk���F�4�#������Ԅ�W5��=����e�n��;��'�95v%���׿�&)�2����z���E�bP�d4xU�@h�z���V�D]�Hx��_pfC!�:z�����d�[ngc��lY��T\�F�r0igJqoS�KU��a$�Y�)"�Fcq#*4�r	�ϖ��l�G_�؄qp���尵��a�e���0��+w�?N�٪�x2�q��J��DRh��{���*�2�NhI�nN��Y��vF�[���ڜ�b_/4���O1٤l
U�8ȿ����Dhy��d�F$��Yx�Y�@ػ�?iӴu�4֯R5��� ����
���o��#aɗ\ǯ��V����Z�0�͋L)'-e���B�@�|vk:��ѺJ)4$LٖV��򄆁�V[v���u�0����M��l�-&�	!�z2�5����C��0��O�Pc;5��Ta��d*�msK�J� ��\�'�ҟM2�14]��զ��F�����\hQ�.4�sJ�W�*	iT�_����nkuk��P���x3kI̧�?<��ն4`>,ߞI�h���^�0���ejRGFC�$4�[Ҟ?���㪮U em�� ��ݬ�f��Y����a5��Y�&�*�U�@��>n�޾I���6i9ٵ ��a <��d��4`�R5�\�a�ƐR*G_�r	C��������#���a(-��>nM�1dօ����0�nE���r(��Ni�0�<xkx�,]�ٮ+ꅄ�����g�u(NAS=s=￘��'��XҤa$ԝ�?��RtNF�؄��p��V���l�C'4���r�q��a %�|����u�v�W5����qx4Fq�lT~0)�W��uz6F-x�B]���~��5�[�V;U�HzޤXJ��ɰB�@򰮵$��a$�d?m�89[-O;���pK�-/��K�� (4��B��Ӿ���Ņ��0����n,�K�C(]��0��>�[SUWG�8��B
Ci���Ѵ���5��FB�ؽ����&RhG��e�M!��l."4�'�sV���>͞빨��J��.,4��g�S�>�ŝ��0Ǿ�v�1�:��6����<��Ob�e��a$\е9n�o��Aa��a$��=����0Y�uq,FB�]w��VG1�2�Eh�v���d3�)5��qt�@Mšd����Lh	'��������8�	"�][3n2��[&�a <U�w$�!1�a �_om��;��-7	�;G[L�Ƒ����F�;U�8h��i��̒��$b�aM��b�<�r�P��B������L��>GhH�k�Ҋ��*b��a=��54�#Ty�X9|\��I�8ȫ~�~f:j��T���۶(#]�@ק�Θ*6^��������q'�Q!�=Wpݞցt����ٽ���Ҟ����;�r��h�ti���t<��y{4u:�[�F�0�����N��ɬWP���q��4�=�?Y]��&#�y_bk�4Y�Q�0�b�-ks�����-ۍ9Y�F#	���lh�
�a$����Hok\�f�fZcԕ��"T2kH�����`�Z+$`�@�\��i{=�E`@hH޿�\	 [  -7lB�@��#�KG2J?/4�v��'[k>6����0�y�u� ��qS^;
#����1�������#��
o�O����zK�0��Z�R7���4��|��XIҌۨj	��lL%vl�+�����gk�>ױ��j
�_ǭ��6������Bs��?�n���x�(]۬a��5fMFe�Qh�[њ��Z�0r�kV+mU��a(�c����i��Oe[^�0��e�U�5���lm<�h(oA������yk���5c��O��),�F�6�������r�FfC[��B�8�
%��/���p���׭%!���W_R	#�v�[��>ݾ�EF��0��7]���T�U��1��r6�Y�B�@���x�DVc,"�B�Hȿ�7#I�\��j	wzl}��j*ooT#�q�7�:�/|ɤa �a��%���:6�|$����_3ͻ�ul�W5�'s�zX�t7�y7B�@h����ar(b�B�@���HLaX6�,_�I�P���3��'�i H�j	�aGOo��f�"�Ah
{��O�#�M/�I���p��'[�KO�[�r�LF�CM����E�d�0��Z�/�&������U��D�ٺR5�ލ��	��Tcq9�q�;[*=M
���v����:�![.���\͵�d?�~���˹��/�;k6Z&Y�Z���t�?[].Y�0�6'���Q��>�����~�WH�t���\ǽm�du��4��gt��@�
�X,Hf#����*����i0�v�`<|9jX-QX�P(��p0�=����Y�H�7�J��=�5�$�t6k��py�1k�g����hlTi��_AR+k�����~{{����ҭ�a,����T�,ʤA ��!��vl��B��Q���xG���E�3�a$.wx~�ZzKNf��a(��z�~l4( `�Rp�d�/�����Γ�)��Q5�����+�V�ŰW5������?�����оE�#�-�	Hc��n@;�U]�cWU}�x�*�Z�5���Ȝh���b�A���{y��,��l��._j	�!��S�&�V���0����8-�R�@|>�I|%�R�H(d�S�_�+��X��X�a�e2ũ�հ|c&#ir_�[��>�u4��S5%��?�F[��A8�`o�e���[�a =O)���'�i��rW0iH��xI+A���p���4������J�0�Cqr+5%�c��%ШP�jJ���T������4�$�&y��Ml5��R�H�Ǿз��''ݔ�X��0J�ڝ�ý�D
2:U�X8H��p��b��0�ܿpkIe��/�ȤA$��P���Rt�R�P�
�N�hJ#��i�@����CΤa$~��yuϘ�E�x�0����,�HẮ�73HH��Ti8��2�)�˳ͤa �e��N�J#�[�o3~��r�����g]ER�l�D�䎅���d�M���U#��+�\q"-6;U�ܚ&�l6%�5���LI?W5����k	�jm��������a,�k�`�������䱿;��I2ۥ��Ъ��N�k��F�6]�[����f��'#᫭�4�n�b;0i
������ݡႡR5����kQ���~�Z<�wk�3�2�4i	7��>YQg�4����������F�
K��S�����.C������=l�k���g�Y�H���/r��^�0�.W�N��4��

�̵]�4{6���,AX�@:�Ȯ"��Y�H�<���P#M�d���0�ή�p��q��ݙݚ[�I�r�u$��a$1���H��g�����Ԍ�47�j��oJ����νE�A�aT-/�q�r��Mf���F�0��Y�|�����,���\j
'�n�\��U��<ʇ2k	�y�"��˥��P��ex��m�ڼ�)5����GK���j���Zj��q_�t�b~01���*5���X*Vت��L]�H⏐�n��0���|��I6Y�k���0����!������\DC�E6hI����p_���0c2�G�UA�T���AR��뙽�0��5$�M6kq�Tj����~�?YM��U�H<��
f��k�R�a$!��7��q�B=��S5&�a���B��4R�0���7r�*�z",5��v����[1k�׍�k���5���i��5�>uip��a}N��U����V� .�:��əW��ݔ�|*�a,����F��r���h���Lu��������_[����{�����j�5��SQ��L��K���';����R�(�:��5`^jum��H��̥�|��a������M�d/MlUc��E����*c��[�R�Hz�����ܒ�j�q��'m�Q��(�I�@�
t{��h֥8��|�j
mVW���;�R�Ph�z�X��{O���}�J�<���`H'����3��0���K�bi����0��~�M�UG�
�ȲR�H( �4�����f�m��0�K���v����)��yU�X��kw5�s��]����#��p4��쥆qp'���r+I_�BN�˸^�$Q4	*5���9���pI��aa%��TjG��k8��a�[���ׯB�jL5u�j	E^6/�G0�V�kZ_�a$ݏ�D��Պ<�k	%�ו�A$<�k{���l�}-�-5��b���&��=�����k�8|4��q�����gݛ�(\�[w��qPc�5q�G&��*���v1�r�xX��0��Eb��B��.Zm$-�;U�H�3�:������0ڶ�>��XARL�jO�:n�V��z����F�)�kGU}��a .�#��v�����^hK���m����VE�jJ�ʥ��`B����,<kJ� >��ڴ[m��Y�P8��j�,ay�5��C���O[C���p�w�ӭE�r1����j���F�s���7z�:E$�#׬A<�k{g��a��b�8k������d��űb�0v����(��v��f������RU����e�<O�����N�0ڽ~�m'Oyh��
C��:�P\�	C�D����b=��Ӗ�0�F�MF��r����/�{�OFS��A <�k�O�����_�?}�\mR8Y��m���Pl`I����������x}�[��D�a$!���Ox
ӈ�R�P(���+�B�P�{��b2�ȴ�C�7�L;E��TW�a$x4��|����r�a ܡ�0�o2�F�������� |g:��tج�"6.4���'���+{d1��+U�(x�us�Fh��*$-N±��a����S�`��Ɛw�?�}��t�+/o��!ļ,��d���1W�a$x��g����0�iT��T�e���0�.�j^L�h2�k�R�Pz��5~{ǃfJ��U"�soB�IF�4 ����������      �      x������ � �      �      x������ � �      U   z   x���1�0@��9 �&I�lri$0U����A��HY��>��ʭ��%m-��K��	��.���f�wQ�E����v��rvB�MZ��Yy�]�?MpV.Zt�������L�ǆ暌17�<3      W      x������ � �      Y      x�̽ے�8�,�\�+��6��o)Uv��u)˔������!�E.\���s��T����<A\q������������}��7����f~3K���o�����������Y�&��L�n�}z�����������קO?�����_�o/�����������_L������|i�l��/�,Of}���N"�!����/��J�8��@����@&Fľ�|��{���������������w5�e�s2UL�}�̳�E�3'߿��.��>��Df2O"F�D�c��on2�G�_�oqN�;�1���<;&�6)�������/�������4=��~}z�������ח����?��l �ŭ�����|��-Y�e�����~���=��K&��%L������HC�����_�?�����/ߟ����_ߟ~������鯗��t�#���8g�[af�󼉘03�_{3��Myօ�����E��g�&�9����������Ϻ
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
��W��o5��YۜA(�y�4Ǵ�p�D��6g����1�U�ڊ�R���(�8��<�����Lo8�H��Ɔt��HF�t�K���:VQ[�8�1�;�킃 `t+b�,�C������-���{G%��9��o�aTM7�)��eW����`<h�&^�T��#�v���3�gX7Q�zm��h��������3��S���>'PPq��2 ��=�Ȫ����(E.l���������jƌ�Q��M�W��P���� C�V��q+��3��[�-p������`+��F�+����E�,�?�����Q/Xr�x����3%���~1�X�?�q�����u# �s5����;f���^7֊�e��>�0l�Q��(]�����!��.���ڎ�%��M�o��t�������.b��F�8r�4T|�a�E�Jz�����34�r&�P�(�b�aj��9֍0�	�8�/�!2:�!�,Q`��O!�R'b_�2�����Oh�~����x ]5)4(��)���R��e7��Ѧ�����M;�58��&Z1m\�U.��t���[Ix��V�g8�T��0f����Ue�g��-"���d��"����44m"z4j��m�P�����hC�P�+PІy�`M���_�T6b��_(^LԴ�]ƹ<6����n�່���{�xflP�z��f�0�U::�������I!V����l���0���*@yq���t�	W�.�gq��|R�5��1"��B�Pa�N͂W�F�9�'�VZ�)��� ��n��O��i�!���wx�������S�Z���lʔBM[�(�c����_��7r��!&�Ciy���!]���eEG��{�uܰ	��V�3L�8�0�Lh"��Q}#��\e5g3����μr,ǆt̠�L�#3�c����ӽ&�%RVy\���b���ᭈ)S�HW��NC�Ŧ������i|�7��yuM���eAV���i��4�+M�Kg1��A�i[��x��I*Lݹ'�0�I�H,��@��躔bV�D���g�Tx/�:�<hp����1&<v��abO��7F)Be�1�ח&��#��S-iE^�<��I"�i��c��\N�(���#��gE�"��`�E���1�z��C,��'�h�'�L@pv��c�;;�$�z$��E�������$-/���3�FJ�Q,/����D�y/r�3L�B��P1N�b�K2�<�x��`F䍘�����դ����FW'ƒUY*�ίtɈ�Z�����T�G������XJC�����V��I��ڜ1ܽ8G2l�m��|���!2�������!�=?-i�j,�B6���|!��aw������I�^��:.�O_~���{���w����؜��S:�<)�hT�-*�'/L�?I��j����:�(��	BG�ڪx�Ĵ�p,����]8��P�iwx<X��M���ܙ5�>�E��c:w,��pp|ht�B�v���J�Z�}W���PƜ�+fƩ�Ct�yb��ja1�1�7�4�2(�	G���,�X�Ea�@��a����b��hc����*����������;nH���|b��sE�i�)�A��g`"!b�����0�����9�f���t��EL��,�l���2�u�1��'�L�bA�D���~B�)>4D��:Yj�E�r��J�}�j���1x�\�4��\~��.�ݙ�VY]�ȅi|�%����S�1jFN����ݱ�O��Cp4JǪ�G�Ѩ$%���H=r���㦭��	���SK�`�_;��Q���躝�B���iK�c�mp�H	�´�!2�<�棓�kM&.�e�R����h`�!�{�� ��^.j*bv�E�q*��GD�n	OBإ����ϳ�u����b��ϭ�D�s#<6m�墷����W�Y?�%A���� �_��mY��X}�_������D���Z�H=b_����2����S *��@�ã(3Y���^���%��8p�_Y����+��9$s����/�+:Vt�O������Vf��hT:�������m�F)m���ލ�\`<���L�ĸH��5�nbj� )��T�!<��4�iq����
����I���$�ݡ�~�_�m
d7�z�1����J�	��tJ�X�������,�8��c&I�V�a�e�G����Ey�ͭOx,X�`m��V��m�� �qQ�B=&j">�%H���}{���Iް�԰3��k���e�ъ|�����HKox1��!bVH��t�^d���_��fO4vpfa�h�&6/������������Q	kj�E��t;�����f��h�:�>:��h���h0��H(��w���l̇��j����Xb,�}B�i_�uEG9mr��m'1�c<���4�X�Vc 3i]�ڒ�F��x9���x��?L�e'+F�ߚ@��<p��=).&��f�,��W�G�O/0�1քk�Գ��.�ʘz�@+ѯk�ϖh�u�.�3'�B�Z���ZǨ�#�ȼ��>w3:��7�����	Cbo����C-��\�r��������B-������Z0�yC�ݍ2�LMuB׉��ᾌD��8]��䉩�,�N�k��Ĵs��H����[��#
,_���|�    \J>!4v�mtSSc�M�j��ȓB/�kt��x�M5_��c61�^�у(C�]3_1���}��`�T�<�<Ԅ9��'1�3P���э7ɽ�}��a���F I7+~&�p��� 6�3c|�,��i9}Q��PQ�x򠋉I�R��4��0O��Rk���ԭ�f�y�n]L4O4᱓Ek��=踙�:';� ��2D��y71�$�8������ĴoDx,()��@I1�諛LLlo��%�CDK@!<vؽõh�OC����+�#�� 1�oW��8fK̊��V)�@��5�$���1Fñ�?Hl�1�jb��R|���_��ׯy�d:H(.��R�oL�����	.�a�6c��$��!#�TBeR�L�8Ez��>31A��g��Qg�G�̬~�J/�Z��7 ���)c>������[p��*b<-�/0VBIB?�\h��Ĵ\�C�q��x���>W���U�b�T�T/�q�B�DG��2�1ȩ����ʛ��s�u�s\��qXG�5[�@0�n*FI�d:v��EG^8|f�ӸC����ZR�d�*w�V>�#��$�
�|��*����4|_:Ɇ���7!�X�V��J�? �l��]D~4+q�{ȩܝ��0�� .0EN���NX�u�����k�<�D�d�<��:����s��S]$1+�y61-+�v5�����J����t��G�H����0��^���[,&�^�%�`��� lZ?Ou����C����qEO�4�D�o�Dhl��v1�I�kF�&�����M��9�h��V��h�oւi��I�������`���މ�=G�䦑,���w~�x��sI��n1#R�����`u�A��5�+��T{�XWN���⬬��d;t�,���.*�7������8-����j��c�o˕�$a $\�jG�6V�.��	��N�
����o�� �z��=	i�A:��Qsc+3�KLO�e\����L�rdN�D�qk?�䪞]p��Ή���H!<���b�O���+�^� \��Dy���LL65�;���ѝ��pHG�QꏔX�����G�� ���:k��c8V�x���O���hXML���]��b��9�����L��ۖ��f�=z��f�b�'���ѷ�9��up*0�G:��Ld��~���އD�Akk�:Z��4c��Sh]Ë����&k�Ϧ�a51�_���D����
�񣺪�=���jb�nk��|d���Y�[P�V݂NL�ρR>�����V_p���ſ�c/.+��Xe�,���ډ��M����*@e41�|cD�ƙ�'�y�OT׸fL˿#�u��M���;���z�]Flں�H�w�<"��ȭE���xiq�1�Zd��A�~s����V��yH�o:<��~ÈŴPYt*��
�$-�v��}�K˔�PE���E�0�i&"�M��u��M��Ձ�=!zFG=Q[�ޟML�~6x�F2�U���x�t�ح�]D�̎���AcXLM�`vb?L�Ʊ�0h1]y;��M���q��9� J�u<���j�]�H��R�{lɱo�0]x���H����C��P��uډ��p#-�r���rqϴ������F��7Eڧ��=i�1�m����%���5�a?H���x���ꖘZ@�BS���b�U����HεFK�q�S�.~bzh
�W�C��DM1��4���_;�XM�m&���?�}���/_~��ˇ�f`ruu���x~;�K�Yr�Q��"{�J/D�����T�z����I��
o(-�]�39c�B��1��Ģ�u���$����fc��VES`��q�&���vqV�Rj�,�h�>�B�w���:6�U�^;�E9�a�c��dƃh>�X���*R`�(ǀ�n��""�r`㌽��q}zd˗r���M�_<�2N�d21���yD�]�B/�)�j��\M�k?�wGF&�F��gt��p�R���@���a��b�}��O�`���p̼<O#n�w�^���{�ɚ�M¤��~ق���@�op�m�i������1�K�ȘG���l��bS2�@8= �y� y�%B.����7�f�M�w�|\�fX��{:��h������j��W�7ӧ,S���vj����O)Y���y__z7'���thh�;��LDf��IHŚs�<'c�S 1,���m�i�U��H���U�s��Du���4ZUs�w�Q��"��S�'�7u�c�����0��5�|x�i���f��r��Ѻh��U���:K�*�q�Ǡ5��1��X	�	�XڐK�y�C�ȗ1�2C��^Ɉ#42#CMdNʷ�������H}L�Z���V��݇/�Joa4~�����4v�bHr	&�n�߁��b*�:���y!�a�����i�������x5E����Yv\��b"'�<<Y�3�W��Ss�.)r��;L4�(��IZ��X�Rw���7q��a�L��S{]<��;'���߇@��U$���<�װd�K���UK�P+��kԙ��9*�Y4�#��H	������y/;���C7�9���"#p�} 9�C}Q�/�:�_u|PwE�'�1��	a�p�ebpL�ƘLL�˸�r�:�Vc���t��OR�w���شi��5��Fl��z��B:�W�67���p{��X�����>���s��0{#�������>b~t���l&��ّiV����~���'�T#�5�\'f��\	V�	�-)0�jbj���ߐ��vJn��p�/܃�t�_�����b˜�����`$�b�Q-������ں0��(�F��2&=�b�6��x�N���S�8���,b������<��ט���#_�<Q	9����%%��LL�/X%�9���a~�|>�� �{�LFT�c�:ԃ��-]Z��|�LW�ԇx�Y���!��eܼ����\����P����OBd#�	�5=�=JK��.{�5�p��8+�q���{�X�v��^i����h����[���:�b��<~����2��� wx�d��ᇍ��G�
��Q��Z���hb,�$���R�Z�a�q[�I��0W�!T�O����5�hb������**9H0�U#��vqC+�1Q�v���EC�q���� ��#�~��
�o���<��[F�MVa�pQ�`w��qPWn�Dz��CK[L�z�Be-Q��N���߂�Q��nbj���P��=?�YɍC����*��[����`L��'a�!��
SyX�j^l���ʈ��4cR^,ѥ�D;�CC�#1��ʷFk�����T��0X(�]`3Q٫�&�8��ZFEKLW��$BGR�鐑�u0�aw�5��K`41��pW�8���@G�N�����x/�H��;iz3V+%V1O�xE�)��ە��㴲0��]j]���
~	I�C�S��fFQ��Py_џp�-y��3c�<7O`��gp��r1��$���l�,��� �$X��7"áQ���
���KS	��X�;��8�p�](1����f�!Z���k���4�5��Q�d�N�e715��&N\�9aLT�.�c#ޕ�uIH:>�_�<jք�t�\��&&�%��\D�	�ٕr��pYM�n�aCOuC�s�t3�ف��>2�IǨ��������nb����T]��'��#�<������8$~�X����e���Z��t��0�ML+�!<�����c���cD4����3�P�N̕��_W1���011=���<)�2�7��cn�GFl2V�g��Rn�c�3�>����_+��B]��!���*��d&1ʺ���v�G�jb\��.��JB�k�:��yxD�1�>�������^}?���[�5u:	m:���
i�\��jb�Vw��R�f�t�h[�� ɽ)6I�v71��pV�0�lz���7�Cd��L�g�FH�-_�%kx3�JL��/㋅�`B���f��Y��EDS|�%j�CЃE��Ȣ��,�A�Ġ�$��A�a��ܒ��`�μ�眏�z�3@Z�����\� ��t3m�}    i6ҭ�q���~��U`�Ȁ� &NS��C�.�M�
�g�N�^0�D҇1�s�g	&�w�{�>l��GCvS*7�kkW��1�,&ƃ�0~Бo�~~)05���X8O��;��ɷ���HƂ�� ��Ĵ)aQ��7G�$]�U@�����*����.��I��g��pR�N��;�:�XIږժ"8'�����0:cl�͏���y���.����Sx-nк$1cj1	���&Z�(�m��s���-�<@���Mh����K���#v�y����2��p��JV7��h�)?��mub�5ི�f}�ɼǣk�Jh�Y�����\��6Ir|�Ic215�ŹX8Er��=ItG:hr�E�2�u�����r���@׮N�1�3v ϑƲ�m��l�ހa��K75lc�Sl9(0U�V7'.Rq��jhc�8����ۢ��<�����&#)�����eLL|�D�Uխ�Y��] ��tmnd�D.��B��`�<�ڜd��\+ם����2I���7��Z��(�M�Ę�
��i��z�k
+��J,��f�����;�k�ЄwQ�w,$����:WY�e
�C��,�-�g�i��I�Ѫ�	'��D����:u0�$Ӱ�}��jb�d��Vsr2Qj5%B�<�ZG]'�hbZ�7᱐&M��c�廫�h����J����0!���pև��Ȗ7�L)�5����P㝗�J4Q_�w)�zd���̯<0�'�O_�|�q����j��|����՛莩F�"E&�QD^���������Pw
91�~m��6@P�b71q"#�vh�zK<��`b�C�h؋�0���F�1r�0��w�Xq���R鷵S`J�iq��B�]�-Uk���F#ymO3�9ChٺHH�>խ�ĝ�#�θsi2j*[����Z����M����;l���ug}��V��$�~!}��Ds��2�]`=Ջg	6�WOШDDF�*�	��,�Z�(g��sK�{�B�v��ѷ3"��XRb����:51&)q�3V|��<ե���3���i�.���J<��-���6M�[��r��o�9���٠� �L̛r�'j�O�ef���@?�1��{�f�if��Բ~wc��ѣ�T@���^�L�1��\4h�@c�c9$j�t�~���r�5��*���i�w�sa�����<�A�W�UK)�^b��+��V���Bcĕ�M�HtA��Rb$%2&�B�(Zh��Ĥ�$�1N�祝�["�aɌ�"���&x��F��K����<D���$=�x��|낗2��ʲ�k&�������_?����kNR���	���ShT��v��?ґoX�F���^�-�N�I�1:T	�f���ò@{�a�8�qS`,0Gj͗�����d�{��ٰ�p�V+Ǜn��%�����-Q��{u�(���=H>Li�.�{�[���01�����o�V	��LL��J`�E+>s�%��$��2�����1��8=��}��<r"��/?��ן���?��tPI�#.����N�`Ā��_
!2�XM��jb��xr4j��ӟ�`bJ4j��~#�9����B`�X̥���A��1���E����"�9+� 7�H!��m�5�2FVL�����y��ȭԁ�˩��O�̠�&�[�sd#��S�x#�	�D��21������G.� 0�LL��[E�ǣ��>�����N�wq����q���?��F�y�H����:\�1�v��]��4Ο�-���H���]`TR֓J�И�Y7�ʘCO�IE=�IO�ѐ�J��qr/�0�V:�6��Kn�k��"c�[�� QgX�E�LZ��h<h�&F-��U�]<�j�K7>+������g�ڜ��$��B�p��4���4�<��YߚU�X��ηf�&�E{<��ڣ�
7�ޣW8�x�w���R5ı&���5�dbZ�4�.�˹e���e���FJ���|21�eL������r�C<��Zo�Nv�G��2q/����L�Ju�ژ�5�?&$w,s��D�jV��<
��&��Ƽ�0n�oF����*	��+��c01����ڠ]�b�=78p9�x�Y�߇�"'Uɋ?ޜ_����1�����Ŭ��Ę�Ϣ����]��D�Y�|��Ĵ�	�/b�T������b!�����S��庘�کt�"jP���D-U��10���$x5�#�܉$I�{-n��}�K&����fkw�}�����0�N{v�7�,�(hG	�
��t�xӑ@�Z\ER�r�i*3�JG~��@��"���$<X�^]��|H�&֕����4(+3��=�$�����xiJ;5o&F\�,_=�ѵ� ��R���tnGS�i�-c��\�gL�JU`jJ����(��{O?�_��I	�S���M���0�i��5��'N@�����/�zȸ�f��.9?M��Ow�p�'
V�J�o�!�g�����R�{2��,�(�Ne;�T��D�=��Tq?�����G�$�-ۮR�-�����Y���D;�	��ӯi�I��hb�_1�`>�ot�M�y��>�~��&J��*n�j�&L�0U��Q"�Q&��<�2��7��	1�c�T�>l��v��*N1�0,c��g����6��"����	�þ�����Eɒ۽\`�W=��r�"��\��&&y00�c%.l#3��,l���ZW�8g��)��k�4,1�O�ͅ�@�̈́Zj��A�βY�x���=�܌�7]*�C-	ތ�aOw�Z��(xBCiXF�Vg��MW��
W���O4�v���31�P{��A�q��/�<VX�D�SM���`��X��&�����b/��%�{Lď����m����tբ%.DSn2�<���ĸV&��XH�{�jkK�3ƿ�e���o�f�kQb��و���_[�@E�R�������[s36>�3�4/�.M;�yt�L�L�r�֧;ʨA�	Ie�b��9_>B��zr�OY�
;��df3��4������1�{�\l|�	��]p~=���\��5Y��o�	��.���fr�d�>�3FG��'Q��VC����Y<��n�_7��b���~�1���<ⲵ,2�ʮb�Ԙ����b�`b���>��蓉���xnF.�FGƸ����#]�ٝ��/A�������_>L�~X{��C�M�y�ƈTQ%Ubz4������FОv�5�0R<�\�Y�Yë��w��N��{<v�(�K�'A_%�0��������g�Z."��|��?�����w#�bp1rڧߊ�N�Mj��l�<ԛ=c��~�O�U�Z`k�����mjɺ����7����̚+1%��5=(��L8��zD�aAc��?Ə����9k\_�ǚ���<�Mc���N�����������}�߿��/7��Lֱ�$�dѼ�OLt�b��S��w���L�tU�wm�R�!՞���n.�+c���)1��9�Z��k��Ĵ
k�cH&ֽ�wH3��:2�ڀk9E.���Ǥ벺��GI�o���+Z�#���®���NkMIH���[��{��=���-��`�+�h;mw27�hS����2Bl���nP���5��i-t����Zjj�y�[��U�f���\����z��6�.Ļ�\�[=`�y\E�O��*7���V�W`��?_���ߌ�.3s��@���M��a^��� ����ˌ��H�ML�Fȼ���6�5�bb�#F�5a)�f[?��~Kb(0Җ��	8�h~�����bVQD���EP
���!��JC��4WH��Tf豺�B�������:�!tj��pO汧�̭+1+���d� �|�aR~�4�ʯ���X�F�L��Q���T�-0�[٠�y8.-�ǡ^�A������!�{cr�}7�ױ�w��k������؁T��������B���Nh�p�ͪI�e�*>1a��������V�m�ab<�>
����oho>��y������}����G��������_��秏�}�ק����?��Sz���	��f���)0�c�ű%L*����]���X�Ȉ    WJ,�A^���L���S$T��,��1��f��1���L�~�< �������< �š��|��!�����a�n�w����t/2,1a]r.$�&�|��ԥ+1�E�c���{s����,J�K��`jx���8���%�H��ә�hU06�+0r@��t�������:�ZsK���b�x���2�UN'��)�u-����E���7^�3�}B��<��&�S�lb�&�+��FjO�8���Ԟ<|gt���9ZuM���P�Ri�d���7c���x�-�H�_#�E����Qv�=f����ڀ��^�gP�ӿ���8��G�DO�X�Q��'�4�`ù%U� ���Ę T��TS4O�#��&F� ���Tj#-���ӹ��ϰ�� -�m1C��}!���jb��/���p�l8�k5�,ce�^�X�����6�1n�^�&VVP.D`���b�~�5L)0a�^-ya]e�cC����)���K��t��cۿ����ܽ0&|��3��	�s5O�$�{�b(�n������cj�s���Ȟ�B��~�M?0~��	I��&�/i�
�?�Q�/������:Շ쮰C\�dk� ��t���·hTnr~Jb�,����H~
�A�js�3�d�����k��>�=f����1Xy�pQ'<W����l�<z8���p��gt9RX�4���*M̯�Dn�=zZ"�q��T<�s6>6{m�|�|[71̉b��ӓ��=t�\�ʺ��h�lb�g��WP	rqa�TsI���bb�L�_zu\�Ar��E�VOˉIv��>�	g��*Wy�2�����ܣ���W��9r�+0% ڏ����hΖ�YS��|���n�wT῿4�K��3��$��,�95�L��S� ���u}��͐*�N�O\D;�9�lb��M��©fi̱
�([(����q�����I���9�c�����,0�-����fV��E8�X���*���JO��x#���JǛi�V�����������Xgrd��݇*pV7�M�J��`b,�����˝�e+�V�}0��������0�k���xN)j�5�'ɼ\��-LK;)ua��1z������H�f�ʁǷ����B)b4�S.�(
�J���ex��j���H	�����8NIL����ߑ��Cz8H�y1���8�#F`�˛N�LLN�ed�2�ke�����Hv��<>���9��R>�����ȩ�'�&���`�����P�VpV`,������	�o����J�Y��g�	��57��z��&&�Z�{�"��uO
x��Wf�V����{1��u�1ՁF��4�%���ho���CA��V;Аw)��>sI����=h��^m����cO�Nd��gL�(��J�<cz��&�kt���O����Ww
�4�2�xb?�nŀB>6���$l�!�f�"#Fze�wy�q_�'����K��7{#��3I�o��zϷ�GnHe����������їs1ѿ�HJi��#����z M�l�s��OO)���x��3�=X��s?��H<nd���.\�\$�U��QT�>�LB,����EY����]�<_���������6��nb��hDH��d|���)0^��7�c�7�ֿ������%�u4"�4惀�R����-����fy��a4�^�j̃H�6�X���3Q`N���M�	u���S�R�+]S��n$���ҕ�Q ���x,�����u��a���\��`�Q�/�0�1#����f�����Q��ʗqx�WNgp�W�1c���=�����z�����c2 i2�H� 2�} �I�Y`�R�����|�*Dզ�R,��J�/�ce�X�aǍ�\�k���)Z&km'7�ly���M�p�z�_��&&�*g<��Hc��v#c�$c��m���B�01�@�L�oSs��$��B;1c&ʲql��ox:��dQY����FI	����ed0&���yHޡs̢WM����3ˇ''�n���f!����*�v��qa=U�W��4��1���3��}�j�X����}�5v�1ר��i���)X	��S�G�?�r�!����L�e�)��u��l��1�N6�����s7S1�:i��x��>��擄C
a�΢���)�+5%&xVWh�MXl�j.�$�w��x�a��E:ήQ�VVC&�B}��/E�
�7�Í?e�z:����<�E���Nbf�k����=#7�GS�+`�''��� ���P0?r��Ť������]w���{�x����S!L$�D����TR�cM�f��!����~²�g'��U���/�*����?��S�N��0����|���m�v�5�>��G��zl�ۈ� a��1$���ڵ��,e�vx�Qi��Ih��b~Hś�sZb��$�Â[���B����c01U�'�-� O������0�_��<z�/"�X�SON
U��LJ��It�	��h�o�N0�r�x�5�TYd��^��aJk�b�u."tND(i�Y�D����8�#�S�ۣ�V����Z�"���E��x�:���݁yL#)��،�a�&�7�a\���5jQWZb�ˌ�P^f=oZ���<���%$��xS�/1�x�h��uf�v��5��V�ޣ"d���H�|��&&']���[����:4$�p51�Da<v<�R�	Ė��38١�I_6ӑ0)HJy�Р��aQ�#�X
*���]���r}�G�rUH�X��^���0�E[%��:��q��a����ޤ��D*/�5ލ�>�����p�Vgx�m�\y��h�_�]���D��-V[{�d�S0�)(��#٣b�5�e��a�/�0���k QcgOc�	Qb,O7bL�<���Z�%B�S��ʼ���KL|R� ��&���1�Hy`7[�9Gm��|����v��r.R��D
B1+�Tw�c��R:J��-t�`fL�#�����T�P9��}��C�n�a~�D�1U'r���y�Uwc5-�N������l1Y���܈ܲ �K��dQ����Zbm�J�G���o_���Ǘ�����8�m����<ܞ��� ��E_�۝ѵ 3�Aj�B�d��>�%Fr�8_�tuF�<]�#�3�eN>h��L��d���}t� U�ɹ[��6}���j��O�8_��j�w{oƤ�����k��ۿ�^�X2>��|p����pE�k	)!n���?�EH���@2��)^h��a211�=��{�"=�;D�@7����W��<�{a�����q�a�U�2jU�sԭ,�-1gU���%�q�!$�*r߳�Ž�"0&'��
�DE�Cy��m�vc��@�ڔI]Tn���ɜxq@��5����xH!���`2��b���@�iS��`	C�" �QGӪ�0���b˼��v+���1����a��4>�s�.�A{�sl<����ƔoLL��8/��R
�c"UiQ��c3gSs�:d�T�-��!����2&���|�IH�;�=.`����{O�A��͙6V-PKL�Eۡ"e�t�(Y!�Q�lt0�6cr�(q�C!1��M��&	0��ŕ%����;���8H�Z�����
��� P����c���烘G��+:�R����b�+���?�DK��<���B��&׷Λ��v�$O�%0��C|a8o�B&�\"�"��sJ�x��;E�O�##G�'MHjLEⓉ9�c��cd���2��t�o��i�9�N�5%�)��x0��:��u~L�nb¼�Q�1E�H�(ʃ����]B�R?1��"~��H0PML�S�1[���t��/2�E��(ړ�^��IrC.z����๬&�g���K�����t�P)O̸˶�M�q�2i8P����~󥹏ɑ<��miBmi�X7U���"�Fʘ#UP	��ZP$~<=Ru�4�J_H��.�i�ţ-�����i��p!_b")�@h�ָ��{ļ��v>1UCj�ϳ]�N2&�s��p�66}^n�)JLo�>с_�M�?D��R!��,��n�4���&�0190ȧBL��!�@�)��ۭ4�SO����y��    u�]L$O-�~�~_��4kv�&�yj;TTO-#�xj{3b�\4|6ʓ�����9a�T�7���$!�<�K�?�I(͘��xg���^<SjD?���a}^?��v�^�y�`b�5�y���A��÷|O��_R��سp�dbr�?��5v��(l��1��
`��8�6�4���X	8U�����N�."��?3{��;����v��U��q��_?~�����bv� �9G�1D����Czw���4Å�ef����#ĳ��T�+YE.�]ɘhv%���6�Ǒ��Cp�9�M�#zC�*�}a0���e�@(�h��1��S��P;�s5��S,���.�*sy��C�����gzƴl^�� u����UΊ���B%�dE0jV�fE`�*�9�<���J�6��J�a��1�pkbsSj��,��Z��.j��1�j�����n��SZo��kS�\ZRQ>�FX.6ZN/�A|^M�u,�l��~�w�85�1���	��5c�>�h72��GS�GE��>>Q�%�.^?�#�swYZ#�Y����!b�� b��@m�e̵�H��Lf��*�MV���HS�n�(%y�,05.����	��&�9����bW��.M�Y�"Owv�� �\���j�?�rL�+���N]���5:��/�R� .��יE���r��j�a�isc6H�a�0G�$�j�訉�y�����IN�W]Tޖ �p3�<,�$��hy�����h�w��Jʦ���}V��'So�%ޫ�É�e�3^3X10�ML{"1�}۬�x����S��۴tߺ�hF��<�jb?�[��+�9
s�zgL\���}�|T��'���	\u�I�+��W���Vdk]_C
�c��Q袒'D��U��J)�Z�)c�S���L�ꪌiNM�c'�Fr�V�{�(!7�2��B͆�Y������V� #��W��Ӹ��R%�wbN͑/�p �`b�=é�r.&��)Z����օ�'��M�D�Eλ|�Z��.�q�Gm̉���݄(���L���ǋh6��E|���~���h��e��T{h��+>"Jr}��"#}Y�C���iȰ���998��d$� ���F�LL�d��0c%����JDR�?��zߟF�$�˹�*��c�{��4��ү1������yh�H	S#�;��v��w1�<Ąǂ���B���W+ɜ�(��.ltQ��HW��L4q�L�%F���Ę60K���ѵ<�#�㧧&�r�b�!�i�Pj�&���#�C��X�[�Pr�ޘ���GBy��fo<�,&�(x����eZ\d�W!�r�8>�[��L��zp\�q��J�cc8�&�����o�|�G��q����2�����ÀJj�0�)
���08&&LQq�@}��T��'��/&���YN,�q1��̈́�!�Y袑���ry|��i��2��|u������o�{�L�f��ğKk]Ë�x"v"��H7��Ef�v�F��&qĵY����#p����#9pϩ���<�hb��9�q�<���ǳ�����Rc�_���z������o7.矰���_+Q�{c3���Ð1�ƌ�B��s��Ĥ����];�S�V!ɘt��sv�s�" M������I�p�$�Jx�HHM��#�1����3-�ⷑ�5ɹ��Q?��]��y�Y}MG�c��_i�����s� ۣ���i)$���r�P�P�ͮ�������2��������X���'{U�ua³�e"1��xt�͒0�pdD����6֒19���&�][�J�{��f�"Q�^�!ʯ��J�5D����f#�n��7��8��Ů<�|cR`=��ը�¸լ�	7�5�M���鿼�(9\r�-�\`�t'��-#ѐs1{\��������I�|�,���E9ZR�4�^E�iek�bD��ɠ$<���[2zi�W���Tϋ-��Ri�r{��dʐ�dKj�`�t�Q�aBL���Ӹ��Ҹ���u�nx���܈EfG\Ge��>ϓ�u� .$��F�ML^
���) ��?��/X������J��Si��.D���s���~a�mB�㖑(P��n�
����������`D��8Z,�AŸ\&�{�`�L�R���� �[Kdn.�c)Q\n�	��|��G,�\_cul���m�sN�_��)-��?]��4"���CC�62#�r��˭�p���?�.v��Y���^ɘ����!����ϵ�FB�w5�`?����Ԅ1��Ҳ�<�Ҹ�[w11\\�D�����}�->�&�fvs.R��5�bbZ�#�A|�K�d-��^NXtQ,�zL�X`�O9�ɨ ���:��5�6�	{}�e�w�ML�h$��ع9LL	32���D�tdM$c��Qp:9e�Q��{y��󼚘Z<bWճ#��d��D+�<,͌F��ã�C�e�O^;�bש{��ӵ��|��U�� ���~��Hd:��T1ԛ7c�� ��8�9�d�G/�G��|\<|��I�v1���6�������1�������]����>H�a�A�����n51�?�i&�h���-7�G�L����/y
�%9}
�wcb�����f�<�&f~�~��	�h�Qlp��1�Ҏ�B%|���Y5�͋�����j�}�����⪭N�S}�D���q��>&�{��mh#\f�r�<�T�'&���a�x����Gh����>y�U<��gFb�d�-�����_�
I�>�~k�V`�Z����� "��Ik�Иp�w�(Q�`�m�H2���A|����C������8�������n$I��ͮ]�k��k�Ҽ��P_01�<Q.bze�֢�o#w{M�N���S�Ϥ.�Aw1Ѽό�ym��)J4W�׉�t��m��hڜ�8��G���*�8��"I��o����)��L>ȱ�@����U������t�ŝ8\T�|dB��&5�gNMTgSw�W
VMr1�v2�!	ftx��뜑#�Z(?+�MLmyD�P!��D
�3���L*���Y۷�c�������J=6
?���V����1����1G)*�����ñ��\ǝ�����e����dˡ�G�Q���;<�*jģY�	�VQ\�Y&� ���,�ab���2��9LB}�fL�>���."�rFN�X��c?�o�x�����f��W���Č3�
�N8J�(�>�ǜ��j�X'h��|�&��8t^0�o��S�~a�T�J�,X��E@>���H����.�4�ën�<Psp%Lr�1�����e������?1��Xp�����h�#�c�s҆��
�0I� �\Ԅ0�D�3����s�Z��Np��e��.&�:a<���z}Ө��~b������Q��Æo���yė�$V`L��d	��~�Ǐ�	/��;Ƶ�`~�f�}����S��`Cn�w
7�Y
�W���2u�u�Tw^�ӆG��<�c�jy��H��:�<�	O�y|М��fl44�A|����y�S-c������w�Q�,5����������؝�v���+oKH.X��EG̛�D,�ރ�^[%���e���G�V�v��[=o��YI��8��N691�"Xp��
#���U�ωi� �!������R��j:QH�^:cv?��q,�Vӕ���(��
��|��<޹��U���f�+���]���u+tǺ�o FD}۞��!�}����ܲ���i��A�������:�Xq5P��y�ڕ�11|O��?-�$�V�����;����꼐Ȋ�)ڈl���.�Sc�	u�Ɔ-6�yh�a��bé���jں�a��~bXմ�דXn���!����x�)�	@/W^�����Az|4����n����n�<�o<0�nb�����v[l�<l7��S�М��fL� 4�6dN���-���MLͿ]pN�
���D˿%<�f�z�ӨK011\����FD
tfĸ�|$��&��r�qɇ:�xbj��m_Y��2Ѣ}��)�죡    4KlHo�&�sKڊ���1l�\�X�?�P3]󀫉i���G|Z/�t'Z��O&�R����g����?~���~������~�qB���h,�qn�s~��\LLh�SD#�ɂ.�#.lu�ɉ���c�����t�3D���]�h�.�ђ1�ٰɺ��lt��x�l��y������d�g�n�?f6�r1�ܙ����d<��a��h�4����+ɝ�$�m؏��^F@~�2*;v��ڃ>c�.7�J�`���CΩ�T°A��v���x���xƯ(^��+��
��6�ӵw5օQ������2�Q�6�&��/��?�⒜j���e25��~ӝ�9aW|/��,����~"���:�����U󉩅e;��nn3&���x�����0l�@wb�_�sQ�Ҍ�旆<��1�2�xlg�@���+>Q�D��w�N=1߉��;��]l�M�3 ��R��F/�PK5�3�W�HI�G� �mqjW���$Ѓ��>G�H�Ĵ�(�!�Р<~ ���rm��ύ*�tb,�7���i7i��Z�Ĵ��c����{v:ڻwBݱ�S����^C�&&�_;3�[V�X��y����/?���ھ��7���I@�Rخ�<�<伙�+�q'�Ns��X8p�����:H�!���v~��Tǘ�ή���r�0�mϊOX(%�\r�q��h�>�����Z�J�
7��I��h~P���Cu�`*�o�U�}~Z��|s"����p�9�o��x��c���@{
�F�lzʃ�:7�(��&�7����] &��I9�G^���2:��[W����+w%e����`������OG*�M��(7��ŕ�m�C=޺��p��ۀ�,"%ё�|71Ցܡ��.*��|q{�o!?r5���g���-�l/R��|]w���|�Fz���E{�?�l�[���SrD��yVEŶ�����+?`��8�4�y63��ib�|:��#�����������G�)c��6")��� �X.�W�rˎ�&N��a��'&r�g��G��Ҍ�Q�Ɋ�hrb��P5¹0�L���d|P���[�tqqA�a�u(){����8>�5�`�bkv�c�БD-`raݏuf%���ra..Rvt���n�6�ѓ�2q�(fj�5�.6�uȣ;�����\y�/Ly{_��WB���d�"J{d-��1�4�����)鏆8x}ogL~40*3�j���<�2���^���8�$���fSqb�s��jX��(�؂�T��{�X+��c_�r����!�C)P"+��6擆����T��a����xh18Jd����ag��̧�L���M()ф�X����b�w���	I����	I�Qw����s��������wL�b��>�b�`���ޱ��Iϲ��7z9�e�MT�	� W�t	��8@�Z�,�^���y�ѕ��絹�i�D��~�����ro�����HF:�;T�<H䱪���Z-�DXor&���f ��I�ሼz���'�T'��2���6��7�K���g"�?���R���i�$e?~z<�ML���w<i���,5�-�����#�?#���=LL3D)��_y�ۭ�V���8.���u31���x�D��`���VŎ��HA�-���p3��y�F����͘����mF.��A��&~�yXY��BI���5�Q&Y��ri�n�
Ll�LgA��<G-k
L�+$<��|/f�J�H�>�]c�$cz�
hЍ�xw1Ѥ(��b�y21�����\�ӝ1�j-9�ֲ����9�1�}�jb�1˹��lu31�e<d��4�����S�2j���c<Շ�?[��RΘ�C�1߯���~eD�cJ��14��)i�4le��K"NFSUㆤ������"�/3*Div4��5}b��tG��%�jgt�x�� 1gF���m�Ż_�}&�_�����3y��^@f11I`��p�44�sy61�Ƅ�@J"��齦�����F�;8�#�Q��ɵ��,�;L�����);,~@��qr�]}!<[[����������޼x�xMU.�#�>�+@^J��LL*��4�@�L7��!y����	��W8����G�کs,J���S]��Z��G���Z��(#�E)��>n�k��GuٝX+��<&�׿��t����$�T_�$���� _)�%��qҵ!â�����/=$�c�2��TTr�ܕ�u�8�W���`ב��������XI?N"����*�G��U"��h�_m��;4U2��Z1N�e��ʉ	�r�n.� V�u�hn>�#ɉ��Ҽ�sW����v�4f���d��4�n2�����P1r��d:L�eKx�̩Y(�3Wʉ��8�Ŵ"�@h71YE�C����M/�,d/��_�͚�|�`b�pn&X��&\�D�#��E�,!�K ǋ�duh���̋x+.��`&ڜp��ѳa%&8�uy�1�7�&��R�O�N:�d,���+��b4���X�g����+���t�y���hm�u+*tFג,�W6�L��럘*A۹&.���b���W���pQ�T�T���������g!,C�H�\�*���TG��a"}�j.����i�p����6��:�M��X[�/�	VB�F��85����JG��4�kzeM&�&1���-��H;��}3���*l#�<����&�T`����s�
�ՒN�z�������ma���A��9�{J]�]^�e(���ʀE#6ܸ����ّz�_����5Q��] ���R�5�(X�q�-�fc�b"�4�G:}11���x�Nͥ�F'����t�m\�||�jf�kW3�AtD��N��N����9�6��F
&��O���ʥvb�K��Q]j���R#D�B܆�Shm��ތ�7�ë1�<�jbR̜Ӑ$2;4޸x�2/?��[�LR�y���a��(h�!"}-F���J��q71��R]X����bDp�r�����J�NL���h�|�<)�F˓"<��`�[��c����R_�<�6��L�^Ku�-��^MY���#�-���nqFE�9������T�'�"�t�h�Μ�i�.�[�$f;u��c�j��'�s�&�0\�@��+1lFin���P��S�Q��1N����P��Vp.�&��j�{)s���������t���u���FɘZL�fAl��a�Ź8-y������Y�9��|�	s��@7[�$I�]��;w�G�D*�D]v��ul�zv2�lg��BbP����&cR1�a/�`$�1"��Õ��G)K6��'5����,Yjg��Z:Lć#Bf7�%vý-^�5��Z���;LLZ���Aڑ5�=ƺ*_���+��<�z	qi11-��{pY�n� ��q�1��/س�H���/��ݸP�l-��K����Dp�&.���^��,�����~fA�\�L�^+����4�e��N&�(=�C]+�h�\���X9j�qw]�`��
[�=�hgW�4=�F�3���A��W�lt�a�x��qs�ޟUI�	 �3i�^Ay��Ĵ+��ذ��}��~q��tb����t���~N�l���e��Aw3����Ö�ヲx�xDye�.�hj�/��nHr�v��29L�?��{�o齮6�F�|K�(0��Ӏ�ʅ���}H�R�fb�)[>�q��HA|�S�[�Q!�m�Չ�U�ǅ��%ܢ;r�K�QW��K������Ͷ���mkrt2�������8�E�z�z���-�x��~��8�z�r���&�\�l�稣�iِ��Jbb�	sT���j;p.b��s��Ĵ"WƃH�6Kun��qsپ����.# ���𢋋�.�&��1�2�:�vq]�m��4@{&�n�f٪�q��3.��͘����+)��=q�:t{a�:��Y��a#�9r�f3�G��]�Z�uV������qL��R笵6 0��N2}����V2�I�@�'R5y�y�P_��I�����mf��f.[��ạ�"��hR"�^��b��~��ӕ�`�
�5)��hk�Ψ��    N����T-0�E���L��.�c#�h�����X�Az���M���! ?H9+�� �6�����I����C������0�Mn���/�DzYtxHM�:<~��*$����G{�7I�����)��7�����"��=�a Ȓ�ϱ���	�ca�|����@|h4���W���_~h��c\ҬD�q@��'"����'F��s��Ĕ�R��x4{wz��Ǧ�N�y2;9�]����QY�15O�)�T��{-ߧ)��_�u�)�����"���� ����0zD̵�.��ZVY٫����t*3ֳ�Ό���щq;󱆡c��LF@�3{T�<C7L�B�h\��^��#�f%�uM���y���5wK����-��ƣ��%R8C��-L1������q^N@,?}�������?ϛDz�Gb��zk[׍�.�ʠ�x%]�ǫܸ��.;(�Մ�h���".L�\ط��r)PHy8ڲ��RW=^OL�t��#�e�L�Hw�Gl�:=���oy���M�X
��������Sj	����$�aMK�d"/Lpj_A��,Y����B������ӫ��S�^M�1M�9r}�gLJ�͋V�Hy���D�E����/F�����I�o��=��Ҝ���H9H�������+פ~ł��ֺ���W�%s�	>���pV�$�c��h �°jf~�Kα^:�&��]�b��~#9�w��4Ėp�:��BS���h���*7���(�W��-���k"����_�c���:�D01:"p��x�N�ߋ>���-��^aX`bq �^�.&R��C�M���No��ar�����{[�����:R�z����ޛ[��Eřlzr�}�|QuS���T7������z��"�bb=�K��tb:㑚g?�u61-�f�=>�D5���-��u����1���TOF�U�k�º���o>`z���V��yH��k��������^aUC�u⮆v�?�.�L�
��X��~-�d���0B2�j�|��v��!~#i�ި��8����c�M�b���\�s.��ބ�̩oA�/[ͽ	u�)J*F$�	u��Hl�"��f6���d�c��[��8�2��󼙘�S;��r���0q�;|��q���^=��ى�ђ����i�i��8��m�#"%�uxH�m�$��'�X.��Z.W9�@n�)~3��ro�V`�S��4Gr���]@c5������i������I��#�XE��p�Q"VISw�u'������v�c=�z��p�����3�1-3��z���7ٺSg���t�H�1+��Xs���g�X��y8����<.u z�ۓ���0@4����!�۞�io�|2F�msy�q��SR�EIt�ԽR��ׂ�c�ι�aC�ǳQ�����P����	;!a����Yt�lqKr(�����3�6�"��Q���&��L���p��t\�k��Gz���ן_F��F���ϯ~���o_����Ǭ����p!����c}���R�MgtM_��0�����UD6V{��wWS�yG�v���,ДjT�'�v)�<v\���9�z11�+�!���tHH���q��["�����0�t�����eB���;�5P=���8�8��/Ki�� �x��B��H�1�b������E���������ڸ[B�0�zd��w�'=�Uï&��wS"�=N���4��ۀ{B����W�N̑�8ↇ��fdl�0#�֌�[�v|>˷��%�z�	�&Y#�).ڭ�y���wtV�]���[�q"0�v�t�{�z���P墋Mׅ�W	��(h�\|*�݃���o����Qkb�*�����׽3�{gDK�dD�R�b����Qj����R�8><W�R�k�`bZ�����*���gt�_=a���)�Q�:nQ���.�p�{_�lc}m��x��ʦ���~t�����4Ly��uju������>����K�h�>��UnR<��lb�fNGL}�dd�fFg<���4�b|�~��_4.�o�1�|�̜$>�f/�Q�y�L̸v�<����}�ѵ��CjNc��&�1�������ϕ�;���[��hx�9%b�85���I,��䗘��������S��b%��q5�oz�&<4.�M��ّ��Fbl47�1:�'Ө�����S��7����'����s�)S��N�w�~��&�eux���ɣ��yq�a`qĻMQL#��]o|��u����]��hI��G ���4�]��Ř1���	P��5��.fD&�.n�9e�g�|otatd���>�����,c�Y�y!�͑�zy`}4� n̗yI�L� .#�+81i��������d�$�lXtc�|���ћ���uO͋,�sa7�pqy�N|��0rZ����	Mm��ͯ(�Xڣ��.�UP]p'���5���HG�22R��И`�Zc��I�p21�\]HKAb�-��� S�'MLMY��;�HtQ�e$
��� m��R�%+0�n���w{�v���O@v���+��y�,��|Ԁly21- �y�u���;u���#]č#��t�<�'���z��07��;D���� ׵���³�[>�������ޒ����2�w���@���/e���/c�bb�
����bb�;�P�H?��m�&5�`b�i���H@}���ŧ)'R1\D|���칫	���X���9�u��I�7�}���eH0"��-�	�U�F^��rc��dL�s�_f|/d�#6�M>�bX��zvx�׃�D\��`�;�Aj4�D��6%0�F�ML���<�Ra��RaJ��[w���e41�:I�2P�����~m�Ǯ� �Q�:tb,ug�'}�ʋ�ѵ��c��̦��)�=1���
i|����=��o$?�k����y ju��آ�\eS���Zɻfڻ�h/��.^��_KS�#H�ޏz�����X�c���	 ��ek��b��()Hy�/)H�a��6�)����c'�ȫ�tԼ�<p������D-9���s��yzb����f�����eN�^�m
6��M���ؖ��y�;����c�G[@�#���A��7������؋c��,v�;G��yH����<���Cu��Q���K��~b����W_y��ĴW�AD��+`�k���t��V:\D��D�}aD�,i��H�{�mؽ4�Ult�)�x� xڒ4_�I2扚a��G��16ZԌ�P�f��D��@��*��s���(�240/;�]Эz�<j}�eL����]<�)7�G5��x&'�⑈��-���1կ��)>��f)��t��l����!²��vŜ�b��%�>+�����2�۲)��R/����+�`Aq[��*��#�&�pvY��}�2Q�R�v؃]�1�3��	W��G�y��������1߿|��O˧_�ޘ�G"9T��n��$�
�):��!��n�|l`c�"���|Iz�Q�*��K��ԽԬ눑���Ѕ���k��ю��#I�7�A-�D���-�q��(
�_����in@�c�����'�1��SO}�L�q�<V	�i�|l�C��,�1��Nb�C/�FbX�Ȑ��|�
���'=Iw���$n�]W�X9nq}7�-{��)����/urI.�JMy21M��ȟFl~�>��g)dHj_����я;�֛��O ��Q���ݝ��YpC�V v��A�P��T)Z(���l�_��2q����E���_����o�4�ܻ�1���O?=�_�'C�����W�#SJv��-'�J��7 Y��]4�i��%�q@l1��9���k.n�3�[���wK����F�Qj=�n���#�X��s_T����+��8��\6������<I=�?�RS/L,�`om�N�"��f�p�Ry�p�Ët����2��,�C�Z��81�2�~.�˂�����g���xX򕠿����P��t�E#p��6�����sb�x�3��D��<�ӢP�ݍ�3|��qa�}��\�F�N�ąx    ��Ԃ���󰚘���U_Lդ�w�B�C�MWj�\$\���
7Ŋt�t����2I�05��[��u�0G*"�d����Ƨ"N�kvT:�b��#I�~n�El�we���<��`����]�m�K)q z�.}�N���..�d�rb+�_�V�j�����(�����㯰���X�bV�,8)�Iˌ�Ϣm�c�S����7:�6'�h����q�l{� .�)���*�z��>s��,�"��?_�ǁ��~�.�{'c,s�-�(�F�z�N.����)���������EFl����^?�OLmx`��
=d�Im�d���D.�C���L��RZ�!i��L�<d(��GS�h{Ag��f�DV�EL�}�ڬ�Cz��\`Rm�q �7�j��6�RQn����T�T��ٙ��u��807�>�S���EM9E���U�߅�����B����E��'�7��qQ�J.�ո	���԰IQc_:��ࣉ�>JF���7���_��鏎h��:
��O�`/T�I����sbZ��CE�W1"j��R�Q�&��ԐY�噅��"f=G�M�;-
�MKļF>����d�@��oP��E�����12��t����օ�d���s�.cb�σtDmPq0��S���l������|3�	�5���P�UO��.��W�\��01�w�#c�7ɸE]	3�q1{Kk�9$cGzL�R�D�����^�ݛ��^�D�������M.�z�����fr��q�<Gd�Ἃa��S74�v���}���oZ�Q���'@٣c_�o�QV�ʍtfn<K�v��鉙�����{V��F��Z=.�a�����S��z�	T��i���.�d�0���`��6̘�)��"
{Q.�{��Y�&*�h��4�����7W���d6=[����E�P����9�jbr�U���E�E��EEa�����t��%T]�.�{>� .i6�ɽ��ֳ�1=���b���rQ��>�0L$����?��c�{��s��llg��rV�,�%�ۼĂ��� ��T�R ��r���Ǿ�Uo��D�
8P*�Rk�'; ��SFd����v5���ث�t���#��w��A�x61W%�CZЌ-��XvS����5��97��EQ��q�NBn�F�ެ�1
\��Ĵ��p�(�i|DԀ���*��$S(L�9h:�+zx��V������	���JL�u�(��9Tכ{[�����D���X����{b�o���Z�	��u]x���db�EN�ﻝ6W�z���g�L��7C����MV�^���%���u��+�J�?���?4d�bx�üc��YV�a�S3�
s1��O�"f�0M��'����NLOm$1�C��v�[�6'���.;>k��|�>^&͵�1~֜���hZ�hK���-}������� �)�� ݨ��7����T���CF)`�Q�s�(b6��<�Vo�HF��a�~���Ʃ�Ch�$[j���|ˌ+��z.��~����OI�#�Il������;;N6��v#�(Z۾�(��4�!9y�LN�e'Q�M�������'̒��.&zQm��-����-R���"
���jA�����<�v����.1V�Μ.�$��]/B�\�����������8Q��2ˊԸS���8�o�L&�(��1L�:��G�j/�p�.��fQ�rO�Q{Φd��YL�U{ޡc�>:�#��C�	���� c���K�&�=�H6		;[�Qf�(�Ίir̐��hS	v��KR���S�.1g�	~�HI1B�P���%�����s{�f�����G!��P5�d6�oj}�S�jY�� c�V��"�8��D���\�pG�h�3Mk�J�ĄUS�g��{�:����`b���q!-�[>6�(�J����Qy���d��2��dsh��uv����d������l,���L���T�����$��j�F�]�.��F:���|�Tl��4>t8m� ��ָH����rztp��r�XbJW�Ӽ��c9�ѣ���`\V�c�Z� c̉��W�<{��N�e;pT��Ϙ�6�P?;2�(�=�BٓYSS푑�T!�0�����>�«��P�13I�h2��>LL���i��U�Z�����n��lP��������!v|�����t��Kf����[�E�����	�瀵n�9�U���1�6>��b�둨�\؂�..��i�(
y��w��m�%
���l�%�7�	[5r8��_�:w�HK�65����Ę���5#|
�F�Cr��{<����o�L��x������k�z��I�}.�H�����*�x��!�o���T��ui�1585�ׁ�X��֒��z5)��>(�x���ED�T��>�O��UK�5:�X'��0�p��F�����<6�k�R�V�_!�;�v?"�"S�1�L����~^����W�m.�/���o�=���楘ڙ.���hn��W�ltݝ��(:�=.�Pr��њ����W<1�܅��}"��f��TL�Q�⩙`p�E��ct��ׄ���Y�LL	1.8�F�#��b����_���D��Mʆw�h]ꏟ3֡�u�:\T�>c�;��:r�Yc��������_�y] �~�l߱�|� ��~6�{���Q��|#������b+��B�������\Q�['v�H�d�E��b\ީ�zZ�܈o���E��*�|bb7�nB����y�T�2=������_3���r��3�@Ƒ:5	�'�7�u�2ˌ���H��Nq�3�7�����\6G����(c�'e�g�e�l&���YR^�Ȑ'�q���������P��8�lb��ϸ�ZK�N{�D�!��s���|t�1��s�$'+rIS3�)��m��������o����˗_����~I����j��*���{9&�ڢ͘��C�r�5a�-�܍͆J��+��b'iЄ�zD��*��V�wb�b��G�ֲU2j%&ʨQ�te &���)�F��4��ٌO��^��3e�SQ�79{�3+��yk�$b[��t��'��]�	S��G���Z3�אƬ�V(�����Sx��
J��˩�!"�;1���2�d}c��C��Ș�m7(a��؏!�z���N���\䓃P	D��x��D�z�d�QT�R:j�2\�Ls�,9�<��qz�tnvB�Z���j<�s1Uf���
A�J\���b|��+R?�3�=,���]
���Y8��L =)�r��_�'��Vr�b�Y��Y��K�,̘�f�E�8dD�K�}�׶��1YgL��,��|��'���e�,�������p.��w��{2�ty��ؓg>L�e����ļ4�Ҭ�CJ������ř�'��Gs��)\�����_�;���;`�����p��-���qbf���N�Gp`���ǒ��t]\����8!!7���1Wb�w��>�N�	�������gt��z���|,�X�X�=��DE̅cD�\8�����	�������Xf_Mw�#�gk��t7�E�S���ڝLL����L��pjN�r�LL�>ɼ@�[��$�n�\��݉B+q3
�a�3�OL��"���f�鼼�|�'�A���1�Hb�����/~�0��>���hb�Q�Meۗ�����&�j�q.���1��G�6[�(T��ʫ=p�w�Q��w�����^��&\bG51�#*3��h^�_�-�f����/vu�2N����&�ڟ^���
��0�?��B�w�XG��$�;��̮V����x�>�<�L�=Y٢E�|��E{R�kvDZ��Q��l��N��d}$�;%�U��|��m�0Љ��_X�9Q�=�q!�H�u�L��1-l��s�"fğ2T��Sc��
�6ލ�s�J���z�z�~����u51��C���W#�Z��|� ��@,�CGt�P2�����5�T��\Xov4.�_�2��
�if}��e߬ᄩ�k2b�R�Ø��L�րϥ6�3�%���?���7<+��uYÖ>ՙ�-���J�<'�J6    <��o�f��i�J���+��	�[pb6a�����
�Z�W��^�[��:���o���U*Ӆ��?�y���Ƞ�l+ݤs(�E��0Y�~D�����p�{���z�L,]G��(��jKFcd��VJ�>�\[�R��3a��ǷO}P�ڴev�m�c�[c��:�������`TRy�4������@�W|���h��N_��V����\u���؇��T��^��mm��P��4��W�SZ�ӿ��x�M� l��
�"�W:\�����;cs�ۨ�\��^�p��:X`n���\0�����ڹi�����^_�����
���L��1�V?yNLԈ�\���&��019�ϸ���� ����.j��1���ў6��ŞM�d:�W�Rv�.j{\��q�M�w;K�6,��z%J���z��|��|ƌ�����d��.c.'-�uw��ޥ��!�I/5V��ԩ'F��:�Nc6��4�p�-�7�H�I ����摐:)�+..�<�_��95a��$����[�M:ڱ�q#i�u�52ٍ�0-��d�m0��ED������jz��d��d"1�979���>Eɑ���)^��hb��F�6�"&���@2�rz����Tf�z�1��D%�nµ�u�LH�_� �k;�ܘ�]��\GOI�y:.���&e)Iİ�Y�\�b~�]������6�7���"���;\�m�&�[IĈ�c�O=^�jb}U�Տ�H�~�{_.;J��[���X�Uj�v�V4(�����)��鞇m<H&\aǞ�%a�%�O��������+�c�7Bc��T�ab�?��Í���4	<*J1#p�}����ĉ��.���bc���dV����Έ~ONr��4Q���W����\U�p�a%��k�ɗ���H�1c�T��ް�>��6|��"A$�l��H��&+�p* ����L�׵�`K�w�n[�����)�t/�"g�c��^o�x%m�������b�w�����oj]�������f�R:���<-�H�z�	R��bbzY"������@�=Fn�jկ������X��ָҷ�OD�Ug\��k�맿�7b�֧v9l���ΰz<�	�~��y119����E��R��8ݼ�ǔhLCKmB]Y����Ow��T����.�B�lX�zk��1������P
�t�j��\d�&���r�[kkVk�sd>(�+NQ�N�r�����4lu��ߐ�ⱇp��n\I�����c�d�D�w�~�.�0*��rs!�x�V�݉	;�*���#�~|��v�dL/��\�M\�\~��k�N<m�����-�������qr�7B�(1M�����	��Ț��{���������!.
����������@�,���]l�^��˄�M���t�;��������zK*�&&�B����p��ƫ~|�/�S���uB���5�u8&�Dcy��p�kt]�r���X�ͻ�����@P���1�S���{bVY쫋:��`yo>�-��rbb!7ubAM[�d31] �q��kc���gc^�9�e�(��O��q�6:i@c}��Ҹcb�p�Sz(�Z}"�Iø��R�wZ^)�wL�"�/5cA�C��r-N��\t���On��񃉋�øo�
G�o[�D�93f�.�'��i��7Mg6�8�����}ǀ���+:v˻ٗf�6���a��.�oU�Z�p6���\�����!�M��Z��Ą�ҥ!�͑(OnƋ�x���1� �0,�޺��C(jm&�^3��8��U{v��lg�g���??��Oa��cSsl�ˤv�����:��{p�>��xy쏇��	�@!Շ���p������:�1 ax��D��\�ھ}.oj�2br��Ic�ML=J858�G�7U���0撶�h���KHC���OC��y\�3�P�k���]��g\�q�Sb�0�K�I�4��2�K�4��Ob��z>Ǭ��9R=�Z�^�6�~�CL91�ƺz�èׁ����jb]��BZ��Q�c���]����T
/O�̚L�f�L@HʼM8$��-+Q&���T�^>���~�T�}��������~�퟿}�ZpсE���b��sqy/o�D��q��\���81��@G^�z��͹�W���3��I|����ٰi�ɠDU��֩Ej�=��ʸgtp��&�;�|'#��sn]��i��N������e�Y�����ND�j��k�s45C�O��*/�p�s.&���q!5"�ᶌu<���.-�F�\�8c�Ǒ �0�rP6$U�{RC��W!�!2'D�`q�\���
�XW��0�����x�)kI�(��1c���6�CD���30�����;#�dj��az��c�wn�騉�y������p�5�����zf2�zޭ�$�U�F��"c�!ɹ�B�>*�RI�ɈϷ��u�W��uϔ�V���&y���� �p���H�a�O&��R���9@S�EC��	OJc��j�:�{blR.k�CD���rb\<��-�8��vΘذ3衁<�jbzh�q!y�M4�1�Qgp�����W�Zlt=�ՙ1�Ÿ��z&�r��A�
K^j�w̑_�����&�ȸҤ��(�Z��:(ybV���� �3�Uioi<���9{?��\�(c�eL|_+�5ASc������0C�d�{|�5.��v_?����iǸ���6�����8L�s��i�8Q��TQ=F��
��v|���a�sQ�ӌ��f\��ES��F�k�%c����a�^2̹ ����d�F�C�)��m��p�*0QM>�I�~�ql��E�-^�V���Ql�EG���\4';c�w��8~�F�T_���(8��� ����H�����nR�OLoc١�F������"v��e}�7e}:�<���^���K��Y��j��H��dT�F�]��'��1P;DN̓���r1���v����]�>��Xg����U��+���>��~���?�*�bt��dÂ�Lr����,���T�r�U~�\&�כ�DEg��W봜�������."�K
bݒ#���a��GC�.91�����]���FG�����n��ᚭ�0�2'�h%&�Q�lu-��I���u ���g��O��[p�����3M8w����îvf����qJ�������#CJ��!
��VC���y�q:�{
���S�
�j>�~�nbz�x��T�2�F��˕�Y����?�����w�y�7�ݑ��FS�p���E�a3&z�s��}UH�0rD�yL�ɻ&�p�N��"��s�1�� �y�e��gu�d3s~��c�������1%m���(0Qy�zX8{�:������6ӳx�%A��zZB�z��qC�F���g�t�ض��/_?��n�@d��k�1�����Č����0{C�b��zD�s�)�7�;Ķ�t�[&���/�������������h���Gr�����1�??����~�#����"F�g�#N���Ds����t�ST	���/�Zv-����������	;$6##� !���A��$�r9�J��uc��g���υ���z⅜�/|����/d\�y���(?�c����9Z@��*�NH#�s;&M��^�q��EQ�e�"&�߫..�'�	�	����V�k(��&��,�L�Dr� o�蘲��ݾ`="�ns�~��i�h��¢��~�q���ǐ����eL�K��C�AeqD�F�$`��Lܹ��g�t�`�a�'WP6z�"�2nx_]'~�|W$,�����q��l]$�buv\pl�D���c5Z�`LC�؝
������8$c�Uͮ�#Gq"1]�9LU��`=B5xBG�#�R6��ȸ���1�B�;�\!3����y٬�xFX"�ژ粫��6&%��G���@{p1�gkPR�]DT��E����QAy�� �tْ��F�z��R{�ß����
�&b�꽢y�LO[Q2~(�y=���ʁᇒ��Ճf$ds��L��L���NN�V�y4a�z��6�r;"���b=���<㶤Ѧ� �  (?�sp1�A���KO�x��G���T�6�q�#ޕ��0������^0�xmp1�..}�I"6�t�rs�^-��A�����AG����1:�@�ޜ�����tʈv�EtC��%@�K�X���V���i�k*bU%�Vu��;�d�k��FR�m�:�w={��ܡk�/7Nu!c�b��>������b����^9	�C�2�<����ߌ~���IS#Y���G��6q��b˖ځu��퇈���.6rV�������@�-S���y�e��N
Ϻ�(1�p�Qc-�R���P�W��.6r�V��n���
}m{�s(D{R>Ɖ��k�׍�K��]g�W#G�D=m͈�Nw���}x�E�>H�������.�X1z5�񬸃��9$��>�.ϡA��<@gt�����+�B2u<1ws�	91���Kyv�0�3C�.�=�����׌�e#c�i4���D��B_������5ɸȹHʥCR9����*u$Ӑ%�E�_3&r���EK�1&��nK����K�)�x2<쾃Zo>��_�:�M2�g���r�J�f��gJyv[�H_0����y����\T��"��Q.Ϧ�0b+�ozF�i"�\�vt��w��R$�PxyM��-Ew���������6�pv���HY���M��,��X�1y3{/��aű�����s�.����_�_����¸�}�^W0�\�]�G���)���񘫸�X{�J.��0����J��
���*ad_6���d��6+�UdA��/�?����XpP�N6���ň(!�B������?���&��x����bO��2Y��Xf����b�����V��Q�[��9�Q�6p���Z���18%���K���Z�O�B�Q�E��H�@�*�F���b����Paxp�Ѓ�{��H/sg����81\����!L�&�w3
���d��T\IQ�c�OۭT��I}k������r�=׺2S;EHPb��CƩk0y8��C4���j�M��>��eb��~��߾���eJt���pe��cǟ�}��#oS�^G�8Hו���$�j��\���G�b��n�g��p�kp)�`�b�a�׌sSNi\L��7����0��<��f]0U*�xs/<��~'+]U0���{��-��,Ow�}W��`=��.��H���$L��k�.�%�	���/_����i      �      x�̽˒7��;�y��3����YRʒXE�2^v������kE�~G8i��]�e�&.~���ӗ��U��U���?)�:���:����E����������*<��yϫ���>����ӏ������ǯ��������_���篿���ǧ/�>l����ck�;:-:�����	��6TC�����~~����>���˷�^�>�~|�����V3��N��U\V�5�W����'�>~ЎVS�UԷ����U�[����/��������^�<���ϟ_����˷ח?�~ل?�n���/߾�~���2X���ÚV���!d��8�?���
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
�F{7��V52wz$����:)빏�u6��he}BC`r�b�vr��!wk�_�e�o0��H���PJБ��[6kL�NbZqǩ<$�((��8U�Mn�R:�fu���N/�!�^�4�4��&�Nbv� 7��<cMG(��l��z 4��4    �=�p�$�I=�"A��#=���bl��2	l����Ò����+��0a���9�N���m�P&�rF�8��t�%��©ё��:�(8Nb���|�����]v���ǀ�M۵k�P�e�s��zf�@)�J�)G�5�5m�U!�.{�ѹ�7>��=��ܯ��O4��$��J��*i���}oLe��r�rZ"}�1����ܹ,�my|=~
=����)�k��d�$+3�y��4p�C���&�$�e����w|�f���b�X%�2�{�������7���ב��ܲE���F�z҇�F��`��6²��'l���u��4�X�r��2��D�1����㐎o�����ԹS�Yv�8?�hh,C���r�FǾ:��2��0��G:
B�OتT�ɧ!0�&.�l�T��8�(���(c����it��{�#v�nrE>���I�'TΌS��:�K����1:(����������&�^ew�7���tq�.Iat�mG<�(x�aRBvP�
s͓M����l�EPn��)�C��v
��)|�q�ϔ���Q���{Бn�S�x���Ԏ���Ƹ��v�+���-Z/����ٹ>�s��te������f���'����Q��ܢ����z�}15ʿGm�1c��V����!��#?s����0��������2I��SFs��� �$���r�m�*%�d	mP6�!n�% �o�~��#����qM�٠:�V�Pv���n�b��C4�KJ�W��AdS%� G��La��|���R�
e��w�%Djɜ7鼛pQ�$z�s��5G��N����T�����>���X�Fs|�b�Q�	xdC��ݛ�1��x�Tzo�,C��O]9![.�N��3D���4�)�me7����&t��MJ�~)���a��fP��g��m���;m���������듔���Y���U���j�SB�M��NV6���\8�!�P����[�{4�����rO��
ʿ��e3_�e����t��Y�_�������΂=�귘#�<Mj�P6q��Ȕ$��k�aF�xz���ɯx���/Y��O��jaۯ��O�%����J�d��'m�~۠Lj��KF���K;3hSj�� �F�fܸ����-h����"{��g�a��,��)c6�]^���1ri�i����=�<�o~5�� �Xeﲙ]�c6z�A9ؗyl���;L��A���Ǵ�j6N%��6[5�nV�ǲ�6.��!p�ҰqR6��ܨ&R�g7k�2�2IK�o�����W���tx�nc�pq���	�S�q����=�[?�E�`T��;�i*�[C�Ƽ���	y�U�`'m��Q�!�/����Fh\)}�v���>#WY����q���; in�b�`6�z�{F{���IN�.�_]�֣Sd��|w�a!�]VC�(8���Bg���@w�IN.�%A6W��)�W����O���b����_����1-l�zÊ��I_������Fa.���A���ƾw.�x=I\���<a�Ϲ�&X�-�wp>0��^R�Hф 5�i�&���S�(�E2���r20����a^e3�w�r�y��f��)-<���@N��4�E�*�j�A�e��bf� ���ct���y9��^�����A:$Y�'I�C��|�`Z�����D�2������^
^DK��U�\\�sBp�
ʆZM���G�:�������,���6W�ɊV��d}���o�@���؈����Q�F@��յ�VY7�>_dw�R{���m���b��D�Fcm��<l��3y�����mm�"��Q�>�NQ	�r1��T�M� �yӓ���1o�
s����4�Lȴb�.�{�ף�H|=���G��z�q=��)�j�y}��l �؃2���kܢ���:�f�0����@�p�	�rP6�g����:*ł�]p�>�E6ꂓ�!ϋa���z^J�B"J8�y���Ru2�Q8i �z�PT-��������rBN�`���$&߱���QA��� 0�N�Yz���a6qJ=ʁ@�$g'�H��/B��z�>3R#�5x�n��3��������"Q=Ԏ�]6�=���l�
�G.�?����>MM��&���R�1i��H%�g⣮��E6���r�eK��I����`,��{~�]	N������=���
��s���|r����}���!w~m��p����S������Q�3��.f��l����(�\�������E���,����=�P[�IR�/��9���Tܳ��\]ż˞��@FR��s�/�o�_;S��ЇzVL�J�z�yS��|Z_J��j�"��2��$N�b�NN~6�L��4��Aܯ�1���Pv���>K~����L�KQZ�J�`7r&;���zMz�Y&c��9L~�]�/����I��U�JCW�V�Z�j�ZL]4�~����>��_zeͺ��<ǹs�e�P�9�%:�nR���rr�y�b�)S�'u���e��Ա���nK�kX��N}c�u�Q���CsD��̲���A��ŭz���6~��L�Mbv$��{���|ِ�ۤ��j�B}��A2�����{�hKs��5�zrh�Im������MrQz�C�*����u<)w7�aZ>��h��赏�!��	�Z��{Y��!F/#������j�&5\�F\�=����C&���1
in���$e����2�8GB���5-?��g���K�须~`M{�?gM���7�ۜ�����vF�	^�#ksk�#լK�Jy|w�[��@�ɥs��זڐq�U��]&X�#h����~u�L��Q����7H��c�s�s�,��k"y��RP�n���_�s�7�zA����6�'O�ô(�K�6oy�L�rf3��uU��i�5���,ب�!B�5X�g�� ���	��!{�F�ASfB��y�F��.y젱1P��`��͞2ڡ���'��n�P��I�@Kp&�=��8{E(�g��|2H��(3t���2<���)�;�R,_���u�Qꍙ��kؤ ��g��?�=؞��V��tS�����(�rz~)kQ����,��4 �!L�6|pĽ�_,��̩���̮Y~��e�i*��]D�����5��=���I�@�
Y�'@�|��irC�`����H���3��)jG�4ie�������1����}c�Ҝ�9H�am�rb�'}���Ά���:ł��E9'8flNIf�-�	���L�&�����)��L��E6�z�6]���f��=�S��=p�*�<�O�}L��_�ZE�r���G�k<�S�ٔŅy�3�����D���)l�N���e�Y�%���i��NU[ʻl&5��u[1�d�&+/�n��jy�z�| I���7�ju��ѿ��!PP)u��^H�Bj�NӜ]D\Ba�za:��x���i)���<2&�7w�T��
=�����+|K��ҡ�v�7���&�W�O.a����ާ|�e�Vy�L_��� �
©���v��=��J>���D����O+S��O�~E�xP�C��@�č�^H��A�YL'�����$E6;JPT��x�Lwhջ��H/�ZO.2a[$���S��B�#׳�l�A]�Kj��3Av�|����^��L9����bM��=ec����Ә�B�.��z�oࠫ��P�H��S���'���p�W�X�̆W����F�sk�2i�f��3�s�=��Ho�xE֟�|T喙�e�	r��%i:@58t��J�=G(�g�f%U^IK�10.�W�y5M���Y�'��h�O�!ζY[�G�%=�LKvϻ��;�6f��E���K(�$m�`sR]v-�ܜ��{�R.ʉT��蓬�҄]3�59w&=���NЮ�VN2����F3�m�ߠ��;�h�2+�$��>��1�Tq�^+|�#�h�c4Pv�hw�Tuꇄ2`/A��&/(tk����dX���O�.���e.`\��Y�h.��I�ϊ�B�j���K�}��[��|.>�~��6�Y��' �  �-c�Y1�b&"�o�Ճ�w�h��X��*�M�>"E��x��U����uQ�ej-���͛�rڀ�2p>�M|���m�J/�]> طߘ,E�s����L�j,��Mq�G�����r���I�6�QvJ���M�~ʤ}65�$i����.�;<�#��[���	��$���t/��:��:� ���)6Z�(��w�<ƈ�*[�C��ș�{�<j�IC*�H]��N��`�+'�u�4Xe�`�Ƈ.�g���a?C;]C]�us&(�5o�we6ʘ�fu7w��I��^�;�^�e(���1�@~6�8lQI����D�N�^�9�)<�,F�$p4{�f|ֺ�.��1uX\箄t�RJ�U��G7������I�S{�\G�F��p�m|H�U�,��枌�	懳�פˍ���b@���Hc�w_��>>T?eJ�_~|�A��O�����25�����T�l��� v:�4:GZ@}��d�E=�[g��W\��y\�F���[ӓ��<����*��C��t(�ޥN���]�wr�ݍ��?v���:w�1�!���zU�^ܾ���Mt��g�w�Px���@�/
9gm��o~����Ny�(�F���`E&����+s�:,��1(��ְ3�y c���L��4�M��b�qIGiE�� f���9��cj�(oÆ�R�Ql����i~������m�n���y���=�멊��2�St��Mw�*3J�O�%�^K����x�\R�N2q�UcWRڒ	�Q��)���:-��2��K��b���H�`P��^��v��Oe�[�* ��Q�{�!�s��Q;����,���|,�y
5�mz�2�ޫ�:6�u��ՔIM�]��J���
���N\:�iT�C���n�;F�N-(��W����������W��\AQ�$��d�[�MW�[U��YK����שj�XM�����+���?�������O��J�'=�=���^����۲O����VG�UP�����Gː���CT����>�b򩸏5�����$�Ze���ʖ6Jr�-�9���op�}��w��jT�q�����r�晜{�/�O2a��&�e���Z�%5��@����P�?�Lp%��]+�25Q+PӦWǇ�[)�=���>;�%`,�j�
����"R����|��D唙����W�!��t�bL���C��!b�\AY/D|��L3J�֒et6�N���e���@/Z%3	��u-�����Q�,���a/�G����\�lm%��8��7���)�ʞ���f^B���R��7ׁa����x�ttVn�TʅL}c���Y�{��b^�D撆�}8�,ܥ6��v�e���/����c���I�3u�@���#�W�n��U,2�lUs�Q-W���cU��
6{KCY_�|~m�G4�Zӝ�.���	��
\�k�c�>���d)]\l�Xi�+iZ��Q���G��&d��la���.��v�o�����8JA�4!�m��c}��@̕(��ǵ��������q"C�D�4@ӗ��L��1�SXX�[��s�̋мl�/���1i�l���#�2��4�tFX��R�U��`�;�bǤ��d:��-Vy��B�������-���֗����Ȃ�����~3��d��Ӽ���l�������a��t������#输��\A.Gd=�ԋ3+Z�h�Ƈ{���G�K��$֤lu�*�%{�e[W�-�
_U]���/<��riW��kpp3v��|�{`�S��1���$h^�^����lb��V3^�nEJ6��7�]�.Z�xp
�Y�-�ݜ�cd8T��=�l�4�4��8i��О�"���X4�an��	U+�7yZc�=dc/qyM���
M]��>s�=ܐ��=L3Jז�/'����̆�����%8����	�>ZW#���Nw]o��N]4\s���0J7�9�{Ƽn|i�6���:(뼍m�ԂF��b7�jHYgdf�{�^�W����Ie@i��M�z���_~��� g��      �      x�ܽ�\9r&���|���_T1IF�L�2�Uƞ��R�4W}�Uw����/����q2��.MI��p�De�/~�_�U/η�������P�O��*�"���?I�B��BJ|�B\��߾�����z������B����R�WJ��di�I����}%�+#^x`����o^�����y�����ן�6u��2z������c��F����4������}!T/*�K)2� ���
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
�����v�̍���)���%wj[�O[��݁���d�A�`0��V�Eq)����&h�9��'������,�\ 4��`aE�D��4��8�r���];�>��!���n���X,̹�XX��:�l¾�PZ'�I�@A2�Ki�]@��hڨ@a����5;�l�{(-Y�AV�5��.�K2�a�X`'W;��C�.E�m�D΀U�P�1b!r�^���(��BPeu�	����׷���[ �KQXߡ �q����Ԍ�w���`w`W8�E_`d�@��±7jd�J& ��O�W�j�%��W|�W��U�#>��O<�|4����>|�,
���Q%$�U��R�.�-��o��+�ǩ���.숱�D�L�5
bv����k�5d���f(����p���W�#۔�ڦ䈱$i	���	I�Q���K�\�	��D,)���VA�q`��\ۇ��N��V�%6���I@��J&�|�bj5��8�N
U��m�tm{$b�{+�r+�3V���Tr�Z.e��(��
*A����sؖ�?=�!X�߇C{;J�%�+Q��b ���k�H�M/�g�<�3i{�z_� q�O�x�쿋e���e�s����e2=1~jZ,sKa\�vr���vm�42�fr5s�z:L~b���\3��P�������vﻶ{�l:+$`Va��a�\�|��xÛ�K�|�&���`Q��dggdƲ����S�S	JP�y1L=���� �l 1�D,��n��
e�Ԙ:Rs�h�+���S1�^��V@�#&���⋛U]���*�_ �q��9�¶y90=�F�D��ыs�cY�>�j��ϴ%������Q-�/�]i{�#�O�C#��8{Hγ�b����`����L.��K�?U ,��%��;ݵ���U�5�[��i�<�#��u��0�Hf�E;�}[bT(�Yگ�sfא�_nٕ4$�,?p��6���bP򻳐[.Y�+9�"f.�d������X����y�m{�i/:mb�UW����ҍ=��6��"	��J���x$�Q@�Ά��2	.N-B(yrR6��ɻ�p&���)F/F�^��Ú
��R�[Y8��矊�r��'�����EBt��{�۹1/:��U��xhXO�B�r/����ҁC�[�;���N�����-��Y����/�E掠�x�����N?����,\ME,��g���˧eƛ��xDktD)ƙ_^t�ڭBh��%��4�!,����<-l�����NFF,'��s��Ɇ\�$���˂��3GH6�޷,�H7`��Ǧ�ca�h̝N�Od
O|�|g��g,0"��K�//��U��t/�~��L���{��E�=L v႓^�I���j�,1�Je�>��F�X�9��a�]XΗ�(� /E��b�CE����v�"ƕ\��~�_8^yھ;��Z��b19��~����і��2�W&$_���O�����i���W�B�Н��c�9��N�\8�a�S������Y���d���m�8��P8��?V'    �
Me�3�l([	��Aѐ�	�qI�`m���Z���t-�"��f�̰�.�X�Z�,�̸ݰ!�Zy
LlҠ�g=05x`����_y-[�'˅��Z~�,#���u�'��ٓ/��e����,�7��[�Oߊö0�K�XF�����c�3>�<�p�D� ���s^u��u�� +��+H&Sf��]�Ӄ�wl�Hu�##�yޞ�����e2��L��=[�K�;vu���
��ޫ��򻍄��r]y;�� 2%�π�pV�5�FX٥Gٵ���W1�."S����7�e,Fl��| ���`ۇ}��"Y��xgS����7ˈ�C���+�Gر:^j>�WZR���F�$��#����3	a"S��4}pw��.p'&H���^�
eߺ'Na��cix��ס�e1�)�`��Qm������{�����'�L�o"�{y���=��MO��`DP`WMz�'u���5��L�Zl�n��]�dr���aE(��<l2�P�{���D��z��%b+ʩ'����L���(b#lJH@���y�]��͐[���}��� f��Խ�P.y�׸D���l7��� 6��agd&�h��9�TH�82�\�;�������V�	�
���ު�����
�����i���L�'����Oa4zk0��H6�>`���`2������HDf,� ,v��
0k,���bY2���a�k�6�C40 �R���[7 ُ{�'lI,u�ӭ�ƿ�-By	�hm%D��^Bo� e_��'�{(ֆ����n{l����P+y����b,�aIۅ%a�î���}a����T3������H`��!��C��w�ne_��	�y����V��\����|�zƒ�/���OoÀſҊ�E�ע�k9�vF�k�Y2�^��c�E!ɖ,�������.�/�dsS�܏�r��ϑhqXc�V�N�+�O 5"Q$v�v�5�3�T2�R\>`9ۇ�������',`&x�������n�����3'+>=���LJ��	��.c^�16]�3P�+ĺ_ 0r��0���S�q)NC&vy�j"���IP/Q�����L^�f��P�hT3+�<�-Ѩ2��%�E�Cc-7X0�ƞy�pl�q1h��D�$��C��2V]� �`�����z7�0rۆ�����̊���⿽[-2���d� ��c�`���{5py��kJ1l��E|���\K�$Y����z7�K��{�޸�#�ٌ��G��J�~�;�֌��������h��+,)��r����.�㵒�L�q�|V�8\J�m�yܹ���X��L������ۚY��~(e�%��N}��4�a7זhMz齤��H)�LV̛�ҜK�໰H���$}�P�'֬�����܂����X[<��d����.o���
ǈC)HL�,kֶf8{��F*�sk~6�ѭT~XC)hp���@x6�qhT�Fx���3�u�N9���	�}�sM����ᎉ�e0�84�a�dT�a�E��\�6�b�rj���'0��+%}�D�*��������q`��+��ܐS>��V,��1\ ����!�.F��k�;\�^)�u��)�V�e���v,0Z0��F�M�7m��B�w#���c���J���R&W������Ƞ��?�K��2��e�Om/�Z�Ͳ�"f�0h2��|�ʦ-૪�$1���2�}�>�ys2e�6]8>pb�n^��Qc�V+���|�ٙT3�MP�m:W�M.��GP��F��Շ8\���*�N��{��k����W�y=#�=.�Y~�Yvo�g��V��\�,��(�0�rG�l��Aǰ/�/�����t��)�����Ҳ={+���z�σD⡭����co�)�W��B���9�e� ����ΐ$�RyЅa;�}�1� o�p�e��'�kn(�6{V V>�3��ו[��z]x�@~����%M�����T����-�x٦��l-+�3����V�U(Izp�ddz�8�b0��Z(L�N9�by>���:Cq�d�%)��6���8#�v[��8�(�i�JDŒ�R>ݼa���ƵJ��Y��bG�˧Zg+�-�'�B��}^�Gm!�Defa�|M>��́�H�)~>!�d��ݳ�I�X/�������bg�\���L�u��s�� K��xmJ�R쪝cv/Kн~46�k$;��Ɏ�5�i��b����\�/�ߣ�W�R";��ӓAQ�Ո�Eux��e���������9h ��[qP�$�K9k,�d��2�^��́��V��$s�R��'���B
�JN~��0O$���A���7��T빧�sHLLj��C��Ǣ$�1'��`��-zAv&��y��S/�0��%�ĈL���O�����$v���P���[#]؁�1Pd�2ەx�9��EbU�耱�d����i��C����cc��x���-.6����f��v� ;&@A򦶴'�����gbD��*@nVybMd;ۂt�4 �iUFG�y@`wt���3�]�Av��C����X(-���b.DΏk1���X�M�U 1l9;,�!f���`j��,g����_ W��pX�a(xd[��|r�1\�����Aw����D.��	F���#��<�ѤܷZꊩ����ɏ����Q��D��=۝���bk�ze�*�3�=�˭�"���#8oZ_�FQ�F�{���_�4R�ϓ3%3���o.����%�
���]R�`�۽��E��A�~v$�Lq�S$��aa��{��6i:��.�w�ZE�K�sW�g�4)a�~Yͤ��L�~�}��#�/Ǥ,�d4*4��ʠPv�f,���i��᪌8_P&ט>��S-_�{9lݑ��eV[�A[ڽm�������0"װ��l]b� o�c���Xr�Xf[?��a�,*�����<��FAy#�W4�bY��f.�x%��c�c�4����ܪ :3ƚ�l�9Y8UBtP>G�2�\��c/��(ӊd�v)c0ci?�J��*���xu��-�F��.T0;��4��d3��1�A���)�T'O;B�`���P~XꙄE,�K<�@gVg�Ag^����+��Nk�k�M��%�U/�E��	��X�X���>��Ĵòɹ�h�"W,�G��h�<J�c�B���kA�'�����DZr5//���:�@�氪������:ߋ�,�JX�	��j��O@QP\)�2?��r���>�m�_I���t�
�I%�9c��%N�1�R��� �a(�$(r�"9(u�9�Y��0TV�dz`� �b
�0]�+�E4�_��H��.�J�2�I��s7�V���)�(�Ũ+�!l������Lg)
�W.LO��5�RZ*nQXN��J�dZ��A�7��fGE��ג���Z2ay{�pE�#Y�2���l�x�E��?���*���8�}�P��P��cÒk2���(1��P�B�Sjy8�}��dq=�°�DQX���S@l8�O+4V���L�F��a��/����O���+K.H����p�GMb�pX�а:�n5"4;>K�RX#��5�f4�\�wP�s���د��_,@K������",�y6��R�%oK\�`װ���G�i'���=)B2^����/!�,I����_:}dp���vK.����/s���@�뱭�.�}aaxaq���nE/�H�9T��R�����J�B�`PJdD(�S\�\�Yvt� e�+���&(�1�N�0�tz`P� z�����R���:�J�W�y�E붿���ˬ#	N�9��;����(��6��=�9�\-��b�"���s(p�GpVG���#�cI�P¾n��M�4E=H"hX2�ʻ�����:�H'N���L�X� gvz�0�'��z91>����v��UH6A{X7�;@�ˀŽ
��G�����XB�O/{br �^�����ڃ(:�����˹)t�1`2��I.�W�r55LC��:Ʊ{b��}14-|��@jlzF�g2]6O�bb�&Vt4/����{����f}�)�4�UP��ز�M)�    �4�vQ�q���E7�ܟ�b�5��IL���({�o�&s�/��,�Y&iFd��O����%����ؘE-�[ى�Wi��QM�C�.# 2��ʗ{fA����QZ9��صMQtV�R;e���=q�����MrYӀ�2�r*Q�H4+}�4�fߗ��4$�;QgmOH,��~c��0��¹aQtnX^:���h4�v��Gb���(�\�<ܼ�x���vXz-a���������m̀j����ޣa��I���J̖�d�%������cKP��>�ϚE���k�c�m�V:�6L��7��4d�1H�2��M�KY��X��T$L��/%n���3	�4�
���<��(	���~�ܭmK��C��tN�C��%=�5�!Z<y�[����pG�!�h(s��(�Ѕ�QesH��|FC�r7w�w����R�݇H�|v+`�η�$��z��
�n����_q�#��4��'֙�W�4|%3������B�c�s���;Q���� I�=��:,a�D3�Ii~}�v�=:��(��;�a �j�� �n�O�=����#�h<dXS�A�T���� �0W 6��p2��oW�?B����A�pf��E�q��[�9�W��g��zr-�L��EW�@Wܡ�5��c�D�4õ��XQ�RsH�������~�r�p(`�K:���/�M�ֿ��~�����%"��V2�-B�Q��|�)[�Ǵ�fӖu��Zm�:0)CS�ł����{Xm�IfY3S��~���^��O�&���W�_<��ʱ���ʲ��*�LM�3�Œy��
��"�%(�(�
D�Z�P��;Q���ﻗ��u�({t<�	�ɒ��ˏ*����a�Ucl�N�}fk�Vd����J����BN�������H�ϊb=����B���#�����'�)��c�� f������X��HQ�&���KXNz�Ps�B���~�����T��_�U����{i�}�U�Q��Zv�+�P�46�e���X2�2���̍���V�X^@�-���]��+���
�{pHd�&�)$ɚ�"ByeBªyݫ��ڷFܟH�<��y_�L���7�Q2�`8Zp�N<�N�^׾��(���eU�L�����w�z��p)��z�Yl:�8n��ӑ�bd���������_��M#GH�h��r�<�$W�>��f�Õ\ׇ�7��ˢ.Ia�O2�a��;ɂC�6��'	/G��dkxclXԝբ�>��9��˧���D&nyH�����h��i�"�wcƻٷ]h_�<ͦ�����d
��y��[�O��ha�U�YU�;U	+,v�/q9]�~n��d�c(����o/���X{8��;�l���g3ߠ8�׋3���IWB��
ۄMS����N�zb\�2��]���E�����#�����v�Dc���-��b�H=���6��}-�X0������f�hzc_m��,,�\�8,�ir�r�l�m�$��;ᲆam}3����e{(�8K�ce-��C��>�
%O�>zd�3�5&��(�
o���	�(�L&���3ߖH� ��1��^f��~��oҙ ��Y�o�`��j��,"�y����J������Qy���lt|0��-�ޝ��P�f2(��	�d�W�d�$�A�Cx�#�+�%{��
����I����$"t�D{2����fL}F%~�X'�2(l'8e�<���C1Z�e@0���z ��'��Ԣ�Vۓɪ|
�VN�na�RF�aιW�o�!p��R�ϸ����?=���L���0�ƕ����n
���W�d]�c�+s<ӻ���v!X��A��=�����35����t\�7?�L.�����%�2�+��]��qhӻ�"S�������\n�	$�OInU�x%�Ql;��%y�O�怳2d�rw-D<N�����!��h��da7F;��v;XB�ꜬRǱB8���__^�<���^
rj�Kv�Qt��W01�oL���c�!����pl��h�5��C�o�.:��Z�`E��-�$V���d]�q�>��x��$��Q.l~l�p����A�9�$䜒�8���f��x��,�Q�O8 a����۲
,��x��g-G���Z2���Oo.VX�?�V��dWFg;,�+TBY��O�[����X��xА����?��/������V����"6^ӄ�Վηh���#ע8������^>����z� ��B'�p��ѹ^zAR�J lȈnM1<�ɔ�:E��7bR�K�-� �:W�;t��q�u�8؏-m�\��1�+%D4"�/�ŕcS���r�!�p���W�/b⡵�0����$uY˒I �j �IB��b�t#��h�n�T�3�
<�F`R�X�w#��ݓ��la)Y��G�b�P�'�IVy�a�	�<f3��Bu�Ʈ)YWޛ���}���z� �!�������0�%�a�_�0zW��j�/�@��+��^|��@TI�$����\}�R�Lg�Z�rH�%&��E�����-�hH����(��$�H���H�Y>E�A�#2EV�UE��y�d��L�� EmC1�P�򏊚v����y�r�ʦ�/k��&�Hv=k��ϕXg�U]˂U�ǝ��\˧ˇ�ŵ����"=^����z��y`%tϥQ�s���L��?<�~f�E��0A8�EJv�g�j��O�BY�/�L4?0"���O���Ͽ����X�1����y��>ȞY`g�X،]>��4ׄŵ��>\��p�!U��;L�|�vif��ܷ�5-�_�1���e��5 �uI*��ɝ��d"��݉�"l_�T �����\��k X���q���P����>�<COM��.��W,��8��&C�#�`�א;)�ICΖ��ŋ��z���N
�g�6��Y2t��m ۷�N�34�����ϫ����>Fo%���v����5��R�,�8�z�d�������(���'��p�J��jqa���g�Ѫt́<"W�����B� �ā�b�N�N"%d���7��_��x51=��Q�I��������&@�dx]�%�.^�^WN��g�&9L��^_>,L��SH�@d�#Jr=��No��_�����p�A_/Ր˥|�;<�c���#�hю|��;�Ym:��/C��WC����pb�'b_t���|b�|r���z��1^;|\�j�A���l���|�V
?�]3�L�	�w�n���\"��d^9�q�'�P�������i�����rry^��U�l��	H9b��k�PB����I�3��Z�k�' ��>1�>+��}D��r�\��z�0|O�(�ܶ^O�=�^ا�_/7+��3h�ڀ}�|㼚,�t�0nd�0���/�\O���7^��q���!�~ع��oc��e��$�ᖝ{�0kzf�/���$׀���z8�v�����Ǟ%!��Z�p2�༹�c��7�����UT�$⶗�̭֞�J�k�pUŪ��b2�������00(�$W��3+��K�l�+�	�s?���Ґ����h�o�t4mpR �\%.�D7P����V���~��h�E�?�Z!m��a��ۈ�Kq�0'}�����s���s��1�!r��������W=؋ƣ��ղ������T$��Xk�!U7�\r���o?�ƾ�`�ـQ�V�,�F�,,�p�eU��=�/�5|�J�Uɕ|㰊������"Z�cv2��s,���0�h�\�'�h�@�bK&k�����{-s-D.P>C��	4vIAJ��\5.NDh��ݨq�����Vӥ�"H�H0�%���pu�	��4��<�,sºLS$rBd����)�qpLI8��V�Dfu�u���,?��L�;y���Op\�eJ���e�,��Ͷb�s�%~�'5Id��}��	�NA,� (���V�W���L�����t1��?s'�2ݏ��H"֬G�"�G�F�Tt���Yޜ?ȟ��z�!S��+_t��B�\�g
/�1�q��k���;#���b�<�����P��5��n[Nb �  �Q�'h�4����*댗.͆TdC&G���B{�y�=��}).ϭ��/E�}�埐���%1������p�-�߇�0�H���W��S*Z$Z-��n�'����M�p')FdR-�p���Ѹ#���Kq� ���{ea��B?�bc��'���U,���?�.�X��ba~��-�%�F���4d�r�����{1
4��<�����r��W؀�f�BYXae#�%�	�;�p4�^l#i�Ph�`Pϊ�g����T�d�d�n&�(l�t>�G?r��}��?>�ѓK(J$�y��;�������kl�-B��q�̀������5���r�r-υR6]ez_p=��������X�	k��!��)֏�܋@Ei�g�%�c�ld/#���E°V�͜Ǝ��vd�BYď��(��^�@��uN8��?����3��      Z      x�̽ےIr%���
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
mn�*B؜��5�C���$����5d7/'�"����vu�G�@z�8l�R�*v~hץV��Pmi�H�׼쁽���c��������ʀ�(����t�I��B�Ø����#�n��!��I&!עa3t}��� ��yi�l��@���q��Dl��p�#k��(����4���`X6~]K���x�p�CM,�T?�p�|���׬�â�0]���c3�}z�x���I�2��։rv�2�_�{OG�[/q�pw��|��q���1�W' �O�b=������"�u3�+g�!'TR}����U�f�aҷ�O����#�wX#*Ŭ~�*��qGX��3��>z���;	�����]�bz\�)"�+� �9�>3ܐ�#��Yt��@U����������%y���rxsл��&���V���j�s.�Ne`�ED�@��.�,�)t��¸��u	ez_��$�� �a{g�|����Ow�ϧ�ar�o�w�X)ڄK��eXh�^~394�r�?��'s��Y�x����oܙ!�V�]�4v�¶��h�V��EMh���yO��iײ�mD��W��K�]����H#��9��N�A�����GU���f�B���z��ة������G]F�\��UX\��%g��e�n����+P��h�5��k�QS>+뀮�
W*��9��=\��XY���n�^�ZȪr��酞����+�7�O�֭�6*��܅�B^�.�%vv��F,��%ԑ�Wb�Mt�DX-%DL����J��5d:�]��4�ގ�X�*�9e>�L�H���,�zqM�1�G�K�qդ(4_�/�5Ý�����aē�m��n���? ��w��F��0졣idc����C��d��^[��)�V�P�灠�Z�V|ge��� e�.�[~vV�c�|�w�������I��M5�����囹�B��wk�Խ����%�R���ݾ<�C�{�~���2�L�4X���m=҄���q�Fƕ��0d䟎j�R�{7þ�ao��>�A|侖8>>�Eȶ�dZ�}H�fh�-�UC��:{�Lp��O,��Kcd;B��<ڲ��y�򔣮m�.v|�ӏ��ŏ"95�"�R�s�	�i)��v�򪽱��'i�p��O�6���Xy����J�l�0�~��N��	H6�G~��a�'� l�u��ϹH�\�ZRb�ڳc�������Mݬ�i���T���_t�A���j�q-��
���?�8G�*j!9�w�в������3i��9O �te��||�/ S���@� ؅=Vk�6* �-�����g��!�-wWY&���\�W�S�:E!� ��/�a�5�Q ���� OU�����M$��x�v)��8)�qU�Q(�{�"�SEK��G��6l~��>2�V�E΃�>"�A���v���������<Ͽ7*�2=����J��K@X�nd�n�ۮ#�YN�G=��8Ռ����I��@J+?�ޘ��ਵ�E�Z���;���Ƀ��|�������#�W�0��8xq Oq�{CeL��ˮ���-�L�'F�[��C%0�fo!�������A�4^��Y��왒]�x*����'��~���$��~%涻�L�0c^k�D�ӓ�mC�3��B�̓��5�*�H���b_��BJ%?�Zk�{��9�F{)���C!� ��Y��F�ݹIk�l�	�=L�-��(?�TP~�G���㭴�m�H
uш�K�*c�g~�O�a����!	rM�-d��e!���by��hXm-U�eX��4�I_!������U�z[��*��$�:�0��T^�vD�+_Í~�e�T��ş;���%ްW��Fڧ�l+�[���o
aІ>�Z���Oo����iІG��5;��swz��F��	�4����Y'�f�Ö0;����Ę�i��4L f�������E�V	�Um����8���������߿����TF��<3�6�ڵ���>��BC�O/�*ǃ1q^jܡI�;a���[,�F�-��˼27f��6�!���ںe��5rd9�]�ZX&����2pW�8�M��>&�]�G<��Q�j�C�C7lBܘ�6z��n��ы�{j|H�m�FTޫҘ�E�@V"�H�=]k׆�2i�D��,��T����Z���Y���+=p��-%z��9&��l 1�_��	��N;304���2F�����5y�_��/u'aM>{�b7$#��#訓��1�!�C�G|輗���JG��4QU2��{}�HHjWşS�R�v���"��y�[��;����`����<�j����~TW����@�=_D]�k2~Ɵ�4jq�n�(.�z-���O~Y���/���ea�N����¢}�_^^倛��8~Y�F����9A�T�&���������
��c,�c,�R "�w�&Sn��� ��T�ϧG�mನ��.�ls��H�����7�h2�n!M��Y��@kE�Y��?��K�<����}�b����*�����U�����O�y?mVh�rr3�Q�H��WG��\{ʭ,�NyR�څn�M������o���We˰B��8冏�@$iU�q-A]�)��K��������� �  ���~8f���y�[!�����p>�rx������:1���V�B�N�Z0/��
�Y���El�6�����Yd�3�Ջ�aL�;�Ta ��_�9_�6�-�}a2_���&���Gi��Zequu�#�n�i�m���߅�Lㆱ{�{��CǦxOe#:ݠ=�2Pw�	�5����@�k�=tƁ^Y��F
7�n&
���*3{�9�0�sF��Yy�%���g�p	6�h'A;Zl�+:�&�,Z��nZ���£!L����F�c��]���n���i7�;����/��1�u�x�/Q��y�I��0��der#p��E�=wuA��ҵQƄC!��3Ga@	��'�y�hX��!/�n�F�����U@�	�Y����p�͍�>��;�.��U�E?R	8ݼ$���Tp�{qȝ�75�F�D�<�C����tz��AzD�pM��^#�'�:?�=��s{z�G�6ىm��	ף� �^�Lf����>�f����/7Ԁ���ϸ߽�7��<t�a�����H�H��c^�va$�c�-H���[Hc9_����A�AĈ�j03`l���\�Pn�qP@��|�zz}T�q1��
?���cnD>�lT6,�2x� ��<^�fnd��.f�#�.N���"���EkG�ƻC���Z��[Ga	�b�c@�l�WnR�c?� ��c,�{�G��n��� C�<��3Lsw����3Bfq��2�{�U�ѹ�Jw��H[�5C�-+��*r� t�OUQ�D�(���74z;��r�PA�I�]~_ڶ�z� K�,����M��JB��1[W�#��+敉̠�.<��Rv�i�����,���"2 %��x�7�*��2� �!W�A�'v�ܽ�K15l����t��r��w7������~������ݶY�D�l��ǲ�v��x�B;����7�΍ [v��R^:i1�=�R������a�T��+O{ŧ�+���8�z��6�!��e!e���	�l���=7aĭL;��:���I�6"B	��A�Q�FГtxQW6�m�jĔc+s���.��C��ث��<�\/���R#� n;X�OA(y��Q�ũ�s��w�g��������ʦah�"����~�&����@Ôò�c�+��%a�0{�穪�_~R	4�2 ~dv�A~iN�g	yF�l�c�I^S@6�T\�s�9^4���,ü����u����؛�)/��Q��Ā8cY`	���rÖ�^�Ӈlk�����#�;X��c�[1���M�!���x��������|�;mQ����sv���!e��s1���p[�q_�U�=O��z 1E�ZKK��n�%�T�A�C6�/���>�2���m�g=e�|;e���k,���kf�F����A���[c��劣��v��!#1�A_��t�?��A|`$2�����c��q]����:�X��=\���M`�j=)�(�	����c���-��Nc��������\{9N��6I��r>���k�8̈޻M\ }G�{lU���7}I����~�DT`��Oyŧ�%X��[�4�;觧�P�v��#N0�گ�ϡ��;�#2�܁/(E1�Y)bA!E	��5������^P�������w�&�N$�s'J���"b]�ͷ� �V]s���=6&�7�#�>�Ѱ��B��βw�6���l��{�� �D�*��#��u����^�c!ϓ�s�ADO$B�ϸ1T���)WmӠwM�I���i���m�K�u �$���/�)�
8\�r��xvs�$�P�[k�h��D:�#�?�/�.�������Bn�Ӷ��2��Cz��Y�M���T�*�a���6�=�Z�6�p��q�)�D=�Hd�1�׀���pEvhbA��Zm=B�5�(DHu����Vԕ|����wn�	q
4�BEZ���Ȫ�k!��G����"an(����Ɗ:�㫞�@�8$Qa�0�G�:�d�^M�'UlE-�"*wz���b!a�
��ڮ�����˕o�Mmg�D���������+ȼ4��#����IL̸�4/ZH��MK�0�L�0��lD�]S�#�ke�"�Wq�W��Fc�5��� &�%���	��!�<�q�EkD�Adb�G��<��Օ	�VBB�$~m��]�A�-����z#g��'���f�����)�p�n@�~�4�)F�^�X�_�Вj���_ϼ;6-Cwwl�2����C�B^@����]<>�+�+�YV0�;gJڼp!"^A�4ndP��҈�*)�r�s�%�&k�A��8ܿr��ՠ� )�y"�q�XEH/��E�t���-H:�I��1,l�藯��O2��Q@�}��N�A�^���7��#�<	ȝC�n�ܩ�	�,�V�������E�'�`Q׈��1����4�g�a����n���"�E�'�R��y���0��΄�*�A�jE�FcZ�V@�u��^���M���eH)��x�8�'i�0�y���ս�yo5!!�)�<a���ȡ�^��^:�)\�ov�*Uwq��B��~<|=k�0-]D��t�o֘�B��˛�s�@̈k��
�
q����	ȣJ8f�`���5�"�ұ`x�}��V�xu�4S�Tr:���*m�1�ӡY�S#r�&wLc��+v����D��³�0�h���2F��2�ݪd	�UG�����nbf��UM�#e1��&|�n���K��㦯��"���" �M'�k��bk�6���BH<��^ �q�57���N�kID��3!�1�v?
��;�x0�-,�5��Z���lQ��XW�$:V�#>�|RF�υe�kxVN�։�z�U*��|� ��	Zt�I��$w�,�F'���&��fg�L��-�Q�ɈVlY���"�{����9���jhl���jw��SeĦF�6���W�k��U��Lm����@�d$��wN���=��;��h�V�]��#���g9E�=����jF>Q�ơ���r¢�hⅮ ���.Q�ph$A>�	1�Z}���)b=��c����H�w��8�qP Ap}��E/�!� f�k�d�k���%4M��?�$�5t	L�;=?<��6�����_�@ȷ۷�(Gȳܟ���^��F�-b�!m~���[Ek4"b1�����q�����gD�A:h;6|�07��ٍ����2�CB����h���F�3�A�I`�?�Y��'��c�֣xC|h1յ�:��Ӹ������!@���f�r/%R���q�s�x�|��.�D�����s�ͤ�Q>�خMG�SYD�7�G��j�ҿD�ủ2�F��-rO��8�F�X�Hԭ�H����Ӿ������[ꭥ�IM>[�tC�����F>��XY+�_�+�S �d�������ÒF�![u�><�TĲ��Z ����4(8�Nv=2e�fu���(�mg�k?��%BD,��1_�M{84c^�����$��,$V0è<ܐ�s���R_y8W��iI����Da	�mĀ���J�F�4	� ��8�m���`�C��$ʭ���e�G�vAOr��%�����䔳E$ɤ��!w7�3d(/� �aDy��C�3�C�9Q�cp���w��`�>f9���VaȽ�"�me��'�9}��jس�2Wn<�| RC���Gy�!R��!��:E�Ï?�����p      \   �   x���=�  �ǯ`rkTJڭ�1q0ю./HC����up��p��#(�T'�NH.�Y�yP��1$S���o�r���!׈��<wO�X������<!Y�|�6ʞ^uS��sّ�ͥP�uu���7=c��NHh      �      x������ � �      ^   �  x��Yێ�6}�|L!*��K��53n;�e��}��"�iwf1 �$�����d�m��L;�f�f��4��9]�/8�0��[3��Sg&;��C�HmTe?#�W�_lg�O><{�?�Ϟ�����d��i���2�����Cjw��h�����k?��8<�g^��:�h�?	�C�
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
5���#�����#����#���5�#�����^8��g��vpQ�\���.���4�],Tiz;��g�c���=|��.����N6���x��40H���������>x�W      i      x���k��(��笢6~@\�8+�����G���w�ɞ��	�O����#�������_����!�~�����gڟ�Z�\��12ad�Ȃ��"�����7���?�)!�|�g��W\y��u���N4z4u��ƻ������3�-�PC���n ǒ3�~<[��F�׭�Ģ�X��e+X�2�OKH���P�
X��-�$⮎w)��x�c�m�r�/Z� �c�z. ��\po����[�{����^Fl/#^d�[/��"ք�5!bM�xύX�֡�u(aJX���%�C	�P�:��e�C�P���C��o!�)޾��:�x��A�k�>��W���O�c.�1�v�;�s���`�\�c.�1��w�
 �l�K/إ��v���B]z�.�P�^�K/إ��v酺�]z�.�`�^�K/إ��v���]z�.�`�^�K/إ��v���]z�.�`�^�K/إ��v���]z�.�`�^�K/إ��v���]z�.�`�^�K/إ��v���]z�.�`�>P�>P�>P�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>P�>P�>P�>P�>`�>P�>`�>P�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�>`�^}�o!�Q�^}�o!�Q�^}�o}ku������_O��O�)�I��pB���		�g��rb���l������3^� �e;���XB3��=r�7 ��f|����qW'��AW� 'L�@������`����$�u���3��`���3��`Vpog|�����r�7 �"���H��f|�ko>@�=w�7x�C3�� �uh�7 ��uh�7 ����$֡�|��:4��X�f|��Ќo>@b���)�	X�f|�;���{ ����AW�`����p�̽� ���{=�~��a�� �eK�w�$�-u����$�?I���Կ�z�>��$x��M�{�>-G�U��I]ֹ�qbKB]ֹ�$�[�>��-/�����)�ö�Ts�m1Z��W�)nK%Wf��G��ý�~��'���^�A�>�������u���?�?�lYr�~��2�b�����s�9[���@]﹗�$^���{�>@��G]﹗�$>�Q�{�� �u���s/�H�C���{�>@b����K��7��Q�{��=�g����P�s/�H���^��X��i�{�>@b�R�}�� �eK�����$�-u��^�$�?I���p+�{�~���z�S/�v��	�^��u���-M̽t �� ���&�^���^����K�˖��s/�H,[��ν  �րWuu�^���<C]ݹ�$�!��ν  �QWw�� �u���s/����G]]?�|`r>{���(����s�kPm=��W4�����a/i��Q����5�4�ɟJ�����I������Ż�>�AIGs�>��CM�-^�w���&.��ӓ}�z����.^�ښ��\������Z[�}��v�h�냿�k����'�gL[�.��s�u��l1�֟&{����bt�U�Heo2�X@Z�HGj1"���S���H-^c �i��e�?I����y��*�r�0Ċ?����5���k$�u���Z��'��1z���u1���iQ�m^+�#��S�H�sj�%�LcҢK�]2�|#�:�E�$�!-�d �i�%�uH�.H�CZt�@bҢK�]2�C\��i�%��0�@(5���*���` �B�s$�����@�e�g"H,!�$�˖:�z&�!!�I
�]�����`H��<L���h9��j<N�>��8�%�����` ��R'�&a�;�`~>g���﫤i$�����=��/�$�=��/�$~_����S�Vk�^f;����d�Ւ��z2������֓	$�!����M䚀����j2���Q�	��B���.1=��@b�R�YO&0�X���֓	$�-���d�eK�n=����$�­HO&Б�BS�]M&0�,���dC@\׹���肞L` yo�գ1=%�@�B/��� �eK}`=%�@b�RXO	0�x�P�UO	0��TBV=%�@b���` �Q�UO	0�X��ê����GVo�&�wJ�<����y(��=���~�?��m��7�����������~~���8�A������VK�K��q��§G���)l.����&[�UY��p���G/��l)�=������H�T��]�B:P�t �-v����������S����������Ϯ��xh����)�8٢�ЁTմ؆�O?H��ϯ�ヮhT4�ï��.<�T8�����|���;P�}ցtYi��u �n�c�iW5�PRМBH7�=Ӂ��h.��ӡ9X:�N��^��.d͹ҿȄ���UqL4��V�4UҪ��,��Yu [��kVH�ώ��TH ��ר�!���U՗��`�"�C�gU��.T�k��r����ـgc�������=Ձ}����[���eh=���BGH�F�6ӁTo�K3H�?t��W�:����;u7
�����g�ϔ��_J�����o�4����J;��3�]+(��C�s�a_�u����hW�8����'OWZ%���ĩ�n�S]��=�/�t=<�<%n��~��E9RF��?��Jp{�sʨ��`Q|F���]�R&{(��?'�� �SD���U��j��c٢�2|��u��2���%��x9�]9��3�M�R��\���ەP���/���3��BW�ʶ���^A������K6�k{��BV.>�o{��M6x�D��`�iP�fW^�hЋ�2�5�C|H�yr�_��@��Ð��_?X⽁�F0�>�WqL4�zH{
cu�z��æ_ɮ���߱�@:F����@� 0V��`�?q��̆��U 5o0Ƨ>]ח0)����u�`���O�
����u�7Tz宿uח15�0�?tׁ�TQ��:����R��:����; ]X0Z��nׁ��cC��vH5:���vH5:���vH5:���v��T�������|˲�o�}�������o�� ��������_����`@��z����^����[_�t珷���غ��?/4���e�.��v�2�7؂w�7$���P�K^��q��}�[�9��G/������K����rH0L|�۫���{������5��/�p��oC҇�N��5����~�՗ u�����]���3?Z�q_6��w80�ef���g/�F�׀t��D���4��p�N���v�!:��v8���H��a~���Ml$�0�eK��	��xV��4ɿ9:j�H<�À�-[��6mE���l���h�Og:M���ፍ��ge	�e;��aH�F�:L�����#6�v���X��A9�	�H,���n#���ζmp�Zz�r��`�(�d	�2%]�F�qB[�d,�H�R����IoJڂ�Ě@o������Jϙ��[:|U�a�s���`��#���㤧E%��'�$���d2�H���\9Jf���l{VF�j����{�X����6k���F❁zJ^��Ķ��)Jj�m�`�3��ĿF�Ov4 ��A>�'X�Ć��6/��}����y����.���|y��U�cL�-��d�-����ڲER�D��by��A?������X'sڷ�r�0p�F;���W��q�}��7�������V�ו�i�z?���Bk���K�(�'�%JHq��0��g��3�m�5�z�3�v�M��upm�ӡ@���J�՞|�}r�ħ�[�A�[<7��53rۢ칺<���RnZ������G
~�Q}����9�{�W�&�ъ�9�Qrl$ދ��Ol$ދiDLI@����)    K� �@(%�F���(���`#���(�6�%�F�q�(���`#�&�(�8'��$�B��%�Hl�h�n��`�i,X�S�lq]�z�{Kc�J����;.��V��u�-&�6*�
6��/�4�$+�H,[�S�l$��:�q8%g�F�4)i6�4)�6�����u���J���M�}��Z
�mqaYIb����GMc��xFyvd��`s��`�h��`s��`��Q	�Q��o޾����+����~=��3�����A_�\�d{\�W�E����t�����5�ߟ���1�|��bۿ�R]..R~���է2(�A�4�6z������3�gH��R������nk~߭��}�ť�[�3@և.��g,;�T��诙&���-Cu{�e�E�� ��Ŗ�by̭~�P�u�p4���Z慁T�V�V�R���o�Y��S9*H>��*��>���`�Uq%��b�r67TV��H�m�+�N%��@�Y�[-g̊�ӱZD�@bcrF��O�Ry�g �j��� >� �����{��}�	o"?ߪ�7ϋ$����Hl�(����O��H|4��b���ěG-�e �l���Ĳ�bT�7wj����T�t ���/d �qH�2�|�����B�1=_�@�qR�C�2�X�ˡ���@�Uꫨ�B�t���ä���/d��#����~��/d�[�o��B뭖/d �������
�HT�Qb��)H�A�;�w����B����B���W5_�8�S��/d��C�����\�F��/N���F/N�"�	/N�\�	���5ku���'H�Y��	�Kꁞ@` �J�$'u���5���j��I
�]��]O Б��Q^M 0�4,�	����s=����=��@�_Z�	ƺ���������	˖:�z���^g�1�$>�P�QO 0�X����'H�C��$�!�?�	�7��Q��	�ŅA%=��@��@`}�#ԧ<�6��$2R�o*	�8�S=��8�)	:�4�#��0$�da�>J��� ��c{2L-O�@:�̈́��9��/����j�� >��F�=S�Ҿ�K����xm-���-�[Yڷ��l�s�ִ\ZٚK������kꈖ"�ZFJL�\*�Y�����ۓR7��)n�����������3�"g�/��8/��S�R킬\�ť��T�}mז�m���~���ʮ��I�+�&�-���5��Juۗ�u����m^�Ψ[)6/+��Z�}i��R�.+'K[[�nK���Ty�A�_*��v�_��k�����jHX:��t�������p���ґ��SHZ۷��ޥs��,W�miC�ځ�<�H^�na��ĥ�7��-�Ӹ4,��|/k��q��4x�joZ��i�H�n2i�朖j�Rp��_�/��[}Z��ҵ��bƯ���#�R}+K���B˯�O�ҵ�����v-,�oK�}Y����]�����u�t-��ka�Uqw�h:�
Hϸ?%m��d���n��d�H����3���N����M�?�� Vqa^nk�d��k�.շ�t�׵#]j����t����K-R]jC���t_���jȾt-���_{9���ӥw���:K�>����c��Պ,}�"Ký��:K�^��s�,�(��3Yz�)K�e�S��Wm��a�,���}������FY��F��\��'UYz}*K_����ӥ���T���d�e�,}�'K/ce�cY��F���.}�$K��һ]Y{��銬���K�mid[��/�һ]�kG�����4V#K}��-��H�,����x�,=����������_X{R]z+K�e�}�,���Ҹ�,M�Kc\ai)��`�����X|��as����/-�on&��~� ���}s�)���E�C��U�W����z�����+-�1�$�:}��������sO��Z��7�~�흸�1ސ��1�7�&-i4<cڪ�[�sZ�����5jk�?��ս��[TY��J��#��o'd黎�4��ހ��q�������?-%;n{	{�O��WnC,�.>�i�)烇?k��fJ�e��~��7���6֧K[�ſ�}~�̓�
�g<V~�\N2��Hm�h�D��Zl��\�!iE\�jC�q�c�Ǟ�vI?@�d�Ԋ�H�M�\�@*e�$�V�Ԑ�R���&�������TʈH>�CrE���}Uʬ}�H�n��zX�Z�R�T3��O�B�h �h��V�S�c�j��\�@*%�$^-���T��B�h rE�7A�\�@b��U85���iuJ$>�h5C�B�h �l�ʟ�V��il���i��7��oA�����@�㐨,��Z>�\�@�5��+H<N�r��ku9TrE���J}�\ѐ_�x��W�����M<N�7�J�h�[�o���F�h ����+��T�֑��+���q8H�A����;�ptrE�m	��trE����J�h�)P#Wԑ
���t*���)��S#�0�xqj�/N�"��/N�\�����5ku�UrE壓+H�Y����K�N�h �J��$'u�urE�5���*���I
�]��]'Wԑ��Q^%W4�4,�䊆���s=�����\�@�_Z��ƺ���trE������˖:�:����^g�1��$>�P�Q'W4�X�����+H�C���$�!�?���7��Q��䊆ŅA%�\�@�E��aurE��+�T�)��7rEc��)����N!Wԑ0���+�꧐+z�1$Wԁ���I���u�F�h rE��8*��+��/_��@]j���B�*�[�Z��+-��KM�wP��;A	��-��ƕnuI��SE�u%m{�[D5�$lo���ɝ(���%$�H�w��W�wPh�!Z�	٧+��;=Dٱ�bVM
I> 
�C�$�4��A�%���LW =D��+��;$F�JX�η�/D��I#"5��[H�H����Ly�o��><E�^���]��c���=w?�oT�-�9���,��(���=l�����6�yqO�Ps;1M����2����p~y�a�w�o����b�o5�'?���d~�r�x�?��m*Z�}�\͇��g�o���ޕ�{�LϬ4�{�M2�(�<%�����/~���A�8���F�4�_��E�Mx�]�^�fxt���q]�S��]��p{�ϗj�S �;��ێ��q~�vҩ�yx��t�.n�Y!]�LK�{'���l%;W�X����3_�W�v���-���u��%r����=:�%����g'���	튙���<;�dvG�UзP�ϳsVF���n�h}��畢��6����!ҍ�t� �`�I�"iT���ioE֦"=�H+Ҩ�4�B��
I~G��¦i��
�^)a�A�t�t%_y�dH�W�N$(8~%Ay�tv]�]IJ�A!�b�gt$Ȼt�$�>HP�J��
]����� �(��t�)(8.�jG�哰�8��t1)(�~%~x���ԯ���<�!�E���
�F���[�ч?�o}m���nv�'��"~�]N���J���d	��p��->�Z��V-6�s��M��'`����ѝn��&Ἁ��±������\�+�z��]~���X��9+;9g�	/��w4�&��g�����7��O /9�a�x�{��f2U9��sL~~2z��wl�l��
�>�8����)>#�����m��]�y���me���۽NCm.&����[4v0E�NA>A�0A!�V ��9�u��^���(�.(L*($�+Q���{����h~-fWZ�Vпl�0�~�*��x���۵�{�^�K��xmЗv�C��?N��Q�e]�m�yO�P7)�E����PIu������~����D��J����u��_x�f��ԩ���C+,��@K�7�pV��5��ӷ!�g�Z�^�Vw\�V3�@���\ ������s�n�þ�=���V�3��4�|q    }�|q58��P]Ŕb?��`���+H�M%�И�ϣS��o?�e�q�����fN�����?���M{�o�Y]��1D?��/��}*�i�ts7o5^|���\fN�MJJ�pCI��Ucb0R�56�EZ�S����&��	�t�s#��1�4�7�G9�M�ő�.��g<��$��=��*���r�zȣ?���*�Oo�o�9�/�'�9]���-��W�����o)7��|�K�Z�]��zP*�H��Z��&�S���.�3����?b(>N�Z�C�VK�@���S ��c�+�q��|�q�]�M�ze�čy,��V7+Q�������h ����̙�G�jz[}�~�KM�}��߯ /A��J���>,�y��¼` ��?8�%uϼ��k�q�n셩N�`��A�VO�@"��L�N���A��ۉ?��c�g5G+�bn�g��ma����ze�4���~��^��5w���B7"�n@{��a_|�뛔�A�3��'ߕ�7r����a0��b��Κm�|�>
�g�@b���1�x��R.��
φ�Mx�Vy6t ��γa �7��lH>N��E�g�@�5��lH<Np�y6$�Ry6�OR �*��<�t����d��h�l��H�6�8���c�ؒP�\��0�Xo5�	�f�gØ�x���@�g�%� ��������4�xg`�g4x6$�%���y6���T���O�φ�i��x6�)��S��j ����H�8����lH�8�s��l;��}ԹԹVy6�/B��&`�<`�<`�<`�\��0�p��<����:φ�Ě@�r�g��$�B��l�Hl��?��lk��<�lr=�����g�@����<ƺ���t������<˖:�:φ��^g�1�y6$>�P�Q��0�X�����lH�C��y6$�!�?�<�7��Q��<�ŅA%�g�@�ųa}�#ԧ��Tx6)<�7�c��γa���	c�:φGmUx6�0j%yy��l�Tx6� 5\(:φ�[�x6��G�qĳa��
Z����������5�@8),�}I�����˚8�p�%{L�m����me~���D&�a��E��LVY���g��{8$��	�f��Z��B徲��-�R�����&��=d�Ō��=]���H��+��(f8��3~M��g���[�}u+�ܰ	�S��@|�o��e����ֱ�WE}Ɏ�-���O�*�lUJq�ͅ�������VA���^�������Қ;~��I��� �%�3��iF�FH�Y�2c��|8�cm�$��x?�_O��E[D|�^��ߒ�Ot�c�Έt��ouO9��c��C�^ZQ_�a���vȱj�n��7<z�q�}9Zku���<����|�TŖd���Ԗ��$�4�5'��K�V�L-Kk���	��HK�}#=ΎR�3��@z�:��Id�L���ܔ碉�Mr++�RSr��|0��IqlLz,����o(W�I�x������Nҙ��K�r[�.n�k�^q'1__�����ü�-�C�����/����շ|�2��d�*������q�ʽ�_C��}�;u_��D!?��0�D���=a��B���#L:��FX��jW&
��}-4uO�`~��=���B�u_�͔��{:�f��
��B���D�Y��c0Qh���L�=���B�|O�`���'V0QH��Lҍ{b�$_��D!�ߗ�6�E$? V0Q�V��+�(b�
&�h�X�B����X�D!ݸ'V0Q��@a����B��<?�H0Qh�Q�u@�`��Q�z@�`z�L��˸E��B�BW'����Ed&
I�ES��L�E2�';0QhUޓ�(4�(�3 ;0�l�F]C�-��R[i�c�(y:��j��:X���f<�xx��^�)����ߵ����1?C܎��,�������[.aۯ �oL������W1����a�J���G�{1�.я|��Ըw���Pݔ�rGr�w�k*��^ѿQgw;�^�]��y?T������W�.��z�䏽�Ϗ:���K��/"��>��w�M\A�<4�-��P0k@=`�mH��1Ml��� ,�;�fz@`~�3�r]y���(���Ϻ�͈tSWӋ-�g��tإ������M~���51cmL2�W7���ƾ����[�*/}<����Ku��V��ݭ?z�2���������J���?H��b���o��e�yBc�ir����z���b�v�����'3y��13�Vr���`zcȟ;�~��z��c^ܡ;%͟4:�@<��@����^��pH�<��R��Oe��נ}g��ݼz�!����K\�;ȩ�'3T�4�(���=~���u��sM�q~��M�,</�į��q���������./2�O1Ϳ2j�_}OJh+:��i)�{������6�+��=�~)�G�f�|+�,ٷ˫i�ɧ��O{�K?�Nm��:�me�i|�{��{�4��D�)�����a����7Y�wv���*�������t�q����?V`tۡ-�1��n_���f���۵���ug���3��c{#D�b���N��d�8���K�o�/_4{�2-��ۼ�����ټ��k�ϝ����|X�T������?�j�z$��N/�[�᝾�b8K?��b��p���H���s�^z,�q��Ob��o-��=����Iss���&�.��TϤ��#���;�a+K�vښ6A�yfm�'����>^����� "���u'�����9_y&̃@�Ŭu�w	1����d8,G���߬��Kg�_m�w����jK�is{�5�i�mC��${������^�kI�%7���|G�'���0���Թ/$�y����7�^�하�.�|5��o�»�a��7,S?H�ß��uJ��w��l%�|�߄Z�H�(�=����y�};ܜz) >n��EI]N�[%�c7��tt�Y=��?R['����s^�j}�]y*$Ժ�d6��ԀZ�(���q�H%;�@�I�H.[���M<+Z�'ɿ�T;0�|>?�|]:P!�1��T�0���JyC��`�rJR)�`�+�N���@�Y��$��^NI�jE�$6&��T2�$^-��T���c ��7A���@b��b2���i�$>�h����c �l�E�V+3dl���i0�7��W9`t ���c �qH�1�|����0�1��@�qR�C�1�X�ˡr���@�Uꫨ0�t���ä���c��#����~��c�[�o�0��c ���s����ӑ�p������5�X��R�����9`$�%�7�9`���*�q�@�����8��1%xqj5|$^�Z_�'u�u�'u�ucg�����:�*����9`$�,u�u�%�@�1�p��0����:��Ě@�r���$�B�s��Hl��?�r�k�tC@\׹������c ���/-uc]c�I�:�����u�u�eKs��@���3��0�h���s�H�C��9`$�!�?�0��u�X������ ��c a���1��
��S�-�o*0���
�1N��F�1�p
���1M�ƈ�6��*0F������8`�o*0F�.���-��k0�l�K�!���瀱Pcy_1�@���&�[��9��Ֆ���Nzy_��@9g��ІT5������`�WOx�����-�Ƶ��{�ɬ�n�X����?`�Fa�(g��{_#�i@�c�14��7A�����^
�h}�IsuO�c~k@�c���2���(�S��:M2*��>淐J�י4{x[!��!�/f��M��=��T�&z$�(�%�̯1C��L���=s���t���O$�q��[���,�JT�q��.h5́!1��j�(�YY�m�/!iIdD�a~�����D��BN�=!��Bf䞐�D�#rJ�&
m���Ꞑ�D�Y�'�P����|�r�(4_�5Mi���4 �  oـ���&
ـ{"�����D!��'�P�Dj��e����=��B�qO b��Ź' 1QH�	@Lҩ{�$_k�Dų���������o��
G�CLT�r���(S�'1Ql���~߯�&M���ν��}�Q�K2�=�'A���k �u�z��r����J�������\�m�{	��h�){bw�-
��-&
��{���SBP��(�A�B��u��b=D2d.^P��6�IY t�3�n1Qh\(<>�n1Qh�P�m@�b���Y�ힺ��^$�{��V�=u��B�����ꩃ[�^x\g�j��X����XX�C{�Y_�|�}O�ь#/�,�_?��'Kd�3LM������=��0g���"`ol�s��^�GC�S������2��R��@�Q��1t>p��(��R����{��;��ÿ�������4ƀG��$1��B+��|#��)\k6�&�$y�`W����ӅF!)�vޱ9	"�����%�-Ԓ���޹@�}������}Ҩ̎�R�~֪6����������ӥ͹��G�
���?w�G���1H*i~�m��w~)��d�����8�|�7c�[qq����ύN~�������;Y;��C����V@�������Y���d��㭟�f�S�B*2���т������J��D����J<Ib�(�i�Wy����W�;�</�F2�Y�Qh����B��A�>��U�H߫�}�O�p+Sq!�7dک�b/�)/�(��_p[�>��E�u|�`�O��~�����jz��I��]��?�`ܾ���:j�kWl�ee�YGys%�}~e6Z�pV�s�%�M7K>Z�֣Ι���t��+�趐�^�-{��i/n�{�/F�s)uz�C��XF������9��&�V9�Kq���O������ѱ�c��淵|��k{�9�yoQ�iK׹a��*o{�D������|����x컥Y�7L�;Y%��\~7���Þ޸%8�&�����\w��Ũ'���|l���b���F;�IU���>����weh4=:�ӭ�H�W����9�1�ڴ�b�6-a/~���'���bl�)����v^�ۡdV�C����)���N脂�<������tv4�'�ݿ��|�ŏ�A��:��w������'��      j   �  x���]��6��5�b�@~��]�Ţ�Aw���^XhleƝې����Kٔ�!�؞�@��N�P�sH�G�y�=�N�w�~��ޚ���F0!�c�;��� �������w�9���n5�ݱ�1t`����0�y��`�_�+�ƺ?��7��@�כ#!�y����v�=�L����i���wT�zUDb��1!B�@�"��Yft������5���(�7�3�,X�fF��g"��(����@T�e3�l=�OHnVD�7Z9Q��YqO�q?�֧��fu�{C�kml]�!�X���3�m���w�㶓��f�>�۰m�@ �t,!F�x
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
-k6i��:�WR$d��%,H�LXd�Y�y�� ��L0�kfrb����X�f��� g92O�yN�[��@ƪy�3��NC��E3���^�Ma��"n�m�HtO��.̄�Oi���}Z: ��������1�      l      x������ � �      �   �  x���Mo�6��;�B��6�|��nZ���� � �)
���/I�+jĵ����+>��.����._�d�B��aQ^�/����������}�N�����������P����64L���,JU?�r�}�����{8ٯ�n>��	S��e�����M@L,�Eu�Z_\
�v5c]��,�	�e�\ՙ��3�i�\�V��V?��.��;*NX�y��9��H���̋��u��6C�/�ݏ��2aY3.L��n�X�]aZ3�ˀ�Ў Y8-�� ,��s�}W'���m��?�P�E�3`w������t
y��Kb��x0�q`w�:0�N�K����G�2��%�j�Z�DZ_X�f�\>��@���0�C-��vٜZ�7�O��`���)��`�`Ɗan[5׻7�N�2P�p;~:�U��Ԅ�lbn�H�M��a{Xu�B]��&vi�+�4+�C;3�����"e+T��R����{ Y�D
�Ӣ��јp>Z���j�@[6V���|��	9��Qhe���V#���K�����z�ª�Bk�2T�Nd����G�v���M��Z�8i��O��e�Ɩo�� @v�i�ě�I,�S| ��@���1�)���C��3*�dN�W��2�v��Qu�S����W��b
5�I��{V�:u�2_~��ӧ/�Oӯֿ�>�1=���qzzx|�8�ER���6�P��w�@_��,b�ݺ�mFz�h��g���Hz���VJh������6*ΰ�lh'R~��)�3�J]�{���cT-��^����*��U����2�t�X�#���Έ��:�9� 0��yzrG���#���vi�jyh��Nq��bH���u�8�}��"�x$Y�q�8"�}F�gd
��!	�#��/��橝�6a8�(�젵�0��V�3n���un���\2�i��n���%���á��R[�}�S�q� ��0S�dK�3O)�ft�[�<
R��9,h_��/0��>��{$v:^���8�����sY��:����Y���N�u�/0݋�z禫p��{16�^q�%�jp�a�K��3/�_������^h7m�-�V����PqFA��YR9�CҪ��J��~9�gAm/H�=T��u�3�4��'�N��C3|�  �
Z      �     x���I�$7����/P�C��Eox��_�%Ő�G*m$U�����B)RR�Mfs��_&��f��ͺ��-c6;��2�8�t�����,��ߟ���N�����&��6�I�e�_���[��B}��R�/�nn�~d�6�P?�~�K83}3�:կ�z��߽ol�� �����k����8��c�n�r�ù�d(w�9[dֵ�!���H�0�aJÌ�Z�i ��~�4��~(�����t��z.����������bAy��|�
������|$
!	v[��g��=��l���G�"�H��;+��yu��ISL�a^a��s���.�;�����+��E�ݽVbc�߭?��M��ּ[$H�] ���n���a^��qg[f����˅r� b�@ew���]Y�YF�@��k�Ɛ\i��M���A��o��S��aX�J,RF`%"%l����b�QR�B��h�66:P�m.��M)��[z�2Li�ƶ��I �����=f����eb��r�}N�+��aQZaaW2 z�o�6�`���E%_�m6�e��0����e�oV�;��I����� k����Ǹ��B�=`4Kg�*(e���|ػ 1�,�[f��6Pū�=ӯ[���W\�]l����EI^�B�
�r����������5��/G_���m�/!ttj� 
���b��Zv[�.�Dh�{��c!����Z�;��� [@,��,��晼������[tE�HQ��1!�髷��Ad@L+�������K,��`;�ƬJ�b��f�|2l���cY'�A#��\�[��'j��{a���)c�aX�G, 4�&��I1]���&o�̯�E x����'��7 �-�h��z�X�؝d��tsD	r��*y�B���(��4���S>��}��;_���"	��j��s*�C@K�H�S�R���dM�M)ÃO;�E"���]�g?Oܚ�vD"wx!�"-ܡa*`�$d�}Zd��5�B}����U����^]��= X�5���I��c��c��]!� X�_����!��cE,3�$�@����jU���dK�N��\���=��
;lO�Z$@n�� �Rj��%�`&d��F���o�~E�P�&��*�3�iM��F��WF>%M:^F\���Gxڤ�ǻ##=^��wG�ح�gwGb^���إ�����K�O�ų���
���G�w������e�*`�I�_�i��[��ܸ/.�ؑZ�L56}ɍ��}�/�q��K�����'���G7�DQ?��*j�Ʒ� B7�
�37�qa��������bb���+��i|S�g��]�Ӓ�'������Zf$v����po�ð۝�}�e�'1'�c�yy�m1:�lY���b8�^��{t�!g��r�1�����#�=�<�鳫��t��z�Xf���v[H<�l���j�S�f�U�"�J���̣��s���|�� �U�LfXf�,13���������3׾a�~Epd+�ʙ���*''��v;H8W1�Z=�H���ԟ�1�((B��O��C���O��e�O���ӎS2���E:ݲM����A���t����U�"YlI��N:}�-�9�J����n�/��"smb�P��t�ţ�.=ˌ@�.ݹ&��F��gM 	� !���P?�>?���o�5/ԯ�?|�j����ӝ3�d��O�$��F\;�*�qb�V���+�H�� <ʪ�=��I�P��§ҏ��YlU��/���pZ$Bn�e��gLy!&I?힞y�I�ҷL?�;�*�Z����e2�"��ӣ�r��[������ /'p����6�p�G-�~m�	�5S�`#��/�Al;@�_A�C����ōZ& o���v�Nߢ>F:}��՜K�vB�L#x6�<`�/wv~Jel(�ÀG-�%����ͮ\2�_9�	В`r��&�Z/<���~���W�~��gk�N���s7����,���7�	4J|����E�$�v�g�-����ov=*WLj���g�x:}���*ӥc�%ev�D-��D�M�L�~����
X��ӯ��iIր����B�oA�\2's��#���jr�q�����^p�G��n��7b� �D �nr�\���<R�� ��Ωu$��O��:��▹��>~����ӿrm�>����N���Dȍ@\��>�or�<���"�ZJ^��H<�S��Vl�~��B�
� �iAz�X�@,3Pfc�R�~a#���W��6�d���Z�oY����K/�nj�H�+��b9�"�[�!����Oj��c�ӥ�,�1��t�7(���F"T��o�5j��i�	���_�`wt�;��g�R�ۖ�2ӯ����4�Ű�f�ç�H�ķ�?�iu��ó=b�H��'�\�Oy����V�p*w�^�l�� �=J?���v >��*PƖ�U\�_p$����+>?wu�~5�/.}C'��Nj�����`�"�\����B~�L���Ơ���������|:@d]�+�K�sj��'� �#��Ϩ߳��d9F��?<@-*6����y��~����M|�H��j}.f���R��1 ��X-�bK`Ri��C��{iܕ� x��uZ�U$���!�&`�%:��wˌ�p��~f��I��>w��^k����`��-��x�k�>��O�	��3�^x���"aJ�8�������G}�5���M�k<���� M�e��Q�E����_�~隨E��p���"���+��A�s��@�g����@=�      n   C   x�5̹�0��Z�@�9�d�9f�Wq�qw-��n�������p � ,�A��99���      o   ,   x�3�4A# ad`d�k`�kd�`hjedied�)fl����� �	�      q      x������ � �      s   �   x�m�;�0@g��@Q�$�xsQiK@@7�B��֋���d��^�de^^@�|�r�"q�L��� ���M�?�G���K�H���X�~ٓ�J�O����{b�*+M�$�}�>*M\�)��bG9v5�Fe��a���o�WZ�ù����!��M6�Z�86���А��L�6�Yl��\��ʙn����n]	�C�3�9c�A{f�      u   h  x�}�ݎ� F����l~�C�ݦZ7�ɚ���cǚ4[d{���80���S�.d�E�m��it(����4�X�,#��%��P�,#����8�w�v��Y����f���r��<9���0���l��#���{��4N�YF���%U�t*�ng�(�_~��\9-���{�k+�Tz���R�p�/�Ok��x���d6i��m��i�e�XB|�5�I��)5Ћ.iZ%��b���˳�)�J�[��Cu��������MT�VJA��}ь�h�.㴾͵�,N�<c������:<S:߆�&��NG?&˘����?�R��|�����q�gL#t�8Pe�gL?��Ә:P�{�c�U�F      w      x��\k�,���]g��;���Qk���c�$(K��t���P�	��T<�Oȟ�	�����������k��1�ɰqP�'eJݿ�*5j�(����a��T(���a�^�5m�D�J�;��{Pj���0P�'%J�ߴ3���4�T[2�Rϱ��NS�kH1P�'�i*�$��$>M�w+{x�d>O�7$���W�mN��`��'S���7�Sl��'S�ϡ��a�ʈs���a���{��L����\؝R�7�kX�^��)�~��^�O��Zܷ6�_��1M��k���ba��o�|1ߪ�?�H���T#>)��n�cVm"�)t��ۿa��4�S�S\�e��������u>�6s.�0P�aK�n�%�)V�6s�h���ĵ�sl�a��^/i1���*m��z@1��8��:�z^��n˰	aN;��ݦxP�v��sl�a�ru���6��:u��)n�u��?����}y��0�z�P�v[�رg]���_�׆Uφ���b�b{udC�t��f[�XV�hX��c��pk�11�R�h��bMC�����-/100�)@��V7���:�8��l��l0ja;�5��zQ�O����܀���7����_U����)>"h=�%6X��3���Kj�R:M!��0Pw�[{3g��U�?��֬|�p�@�Ŗ�Mg`��3�f�}k��nc�|������baxo]���8��\�궬��0�>��v`�9�K���f�."\�ϫ�9�K��z�wuq�t���j6���̹��էQ�a9nV��<n�;���{��|lٛ�^��"f8�%,���<˕n`����A���=�a��O��6���ylp��|`��{YkV���p5�"vkZ�ugɅ��mt�0Muuv>Oq�K�nO����ʺ:�U�p�|��B���OT&s���X��t�Yr#n�Y�t��3#��ȩ���7�RG8�.�Yu�nu*ͤ�fe�%U��y�c��|�͜)�:_sX遁�N������cF0��Қ�%�50Pw�8���R3�^B�KC��n�\��-N�jx��[Ϥ�x�0P��C����9<�syoj:-��גo:���<6���)N�R}��6�1��E��%>֣ΰG�}�u��a�{�_�:-�Ɯ��NK���~5�S0��8��yHfp_ڰj�״�8Ňk��z���޽V�;c.�k+w�V�S���cISL��jȰ���@�d͖�����d����c�ϯ5+C�]%=c��a����U�*9\cм�|U�#-u����Hp	qd�{� "Iqd����)Z\�jm��*��DD�����V/�׆�*���늆�*��c�5j�GjX沴��*�����e�z�����U�2Te�-�YM�0�:�p����^b�k��8Ұ���$�U1��ҩ�b侶�t:e���Nlkz����5� @������@�Fq�i:�4]h����!qM��T�)M��-W�0P��v-�r����N*�6�2պ��a��c�ѕS{��ʈk;���nS1�*j��S4�:b*���k`V�L��ؖ�ؖ�Xr���iR���%h)ARXܗL�� �׃���m�̅�չ\�y$+���ǳaиO�w��>�]��w�����w��a����r�E~�G��}E(P��j�IjW��m�j��t*��6�!RM2�R����$1W��00(:�;��*���$|����`J�K���)�W[��
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
c����s�G����]�}'�-V�g�T����Hfmru��-7��<X]���Ep�ck�g��1��ǽXn�l�a�:K'|��q/ZN�>�UY��8_�?������p�         �  x��Zۑ�(���b��x:����ǂ��ڈٹ�S�_��@oA5|P����x��Ey��Z��'Ǩ4�縇�}R��$͟��e��I�r!�ߓ;����q4�sީ-�I��D$b$�Ir�׵A�$e'Y�uѻ��{trԵACK6u��ZsQ6N�u!�zH9��v����AR ���m���\���r�s1c�.�I_D��=�o�9r��O�j���l���%��D�:�J�v�ة�(�T�~�ꊙ'v������{*�^��f�rc�rY3�΢�}���d��I��e)aV��x��͎�x�9�<�`����Z �n�B���2T�BFO �|��n ;*DAe�r��+�B$�\��xX�m����DT��j	�AB�B̀���:cB�{B})��1���QC*�2*Čz�kNo�j��Z@ݹ��\Pw.��
j=AE�XAod�t��>�K���\��x�̀�W?jMl�Yv��{�ͺhT6�6����cx#��|�+�o���6��Y�İ����[��ă��2خh��n�:= � �]��-Я` ��|s�a��t�n��Z��˚�7.�;4o
iF����U>�6w����U>A���i
qipj�b���o_�����f)yܯ*V*���}��!�y'/�$)�g9�G���B���}h��m�uNW�]�QI�-�Y.�,���'J|��U�gF���+���&�$3�,���⬏��d�Lr���X��즡�`)�N��w�Ɠ��"�;WwT���	s�ե��JS��G��V��<�E�#���I)�ɻJ�۪J�Jy�E�����������o��2��MM8��S�a15	6�h�)��~h^C��f8ŵ^/�٤�ؓ��ҏ�w]�R�������1�QKp|tmLg�-�]�{A��'s�F��FG�k�x5j�}1�`�ռ��<�Q�7U���h7��n��Wh`%�(b���9��| ���f8�Z -����F�gsF�`��ތN��0:I󅍮9��!1����"��kⲈ%�ac��i���6H�h�M���x�Aڲd���V]R-�!Y�E�jOʋ��>�m �'aT�C<�7X�������щ*X#z붐���#j�H�l���M�;,�������'����y����N��Z�C��C�������F���W��1 Oٖ�D�����X߬���nu�h據=�29�	���h������۸�c/���]� 8�̡���k�[&{I�љ��R!Ν�b5IQC��!�Ճ~��Y���J��i�l����/f+#���=
�=�n~�p�-�������C�` _g�I��� {/��6/�C���/��tu��lv7�pЈu������j��eڎz���#��6	��<nF�*R勋u��,15l��a�_6\���#��˙W$C�.���o����PnA{X�꒢�����n�a���P���Až��R��&��˚r#	��aL���@i���-���F�'�2�����b
y�A."�,G_iekL�>I��,!�c9�B؁��L�MoL������G�ue�4�d�49�9�5���J�㉘'>�|nK:fc��CןN:�_A�|�ߵ/��_�x���������|~~��� �      �   <   x�32�425�44�4��4202�50�54����!<K+Cc �36115�4����� ?q
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
n�����#��+&�aFf���i �=Q�)�wM!w��k�T#��e�{�b������%tYkߍG.Y�� �F7��H޺VS�瑳dIϟ5I�<�g�j��i�c�*ER�;?R���E)��po      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x����j�@��w�B/�0�K�ۦ���n	Ÿ1T;���ؕۋ*d��`o�O���a��y�����]�ϛ��%`x�#sMT�V�)J�x�j�FqX����g��w���j�8.6��H5rE�d�Tߦ������n����n�mbI�o�"�����W-����7O'����lg[�<�
%��8��.���s��>��S�II��^0�߰o���������"�ǾD�Q���
q�ϙ��Z�TL�0a,�w�hS1/a���}3� �S����P����4Uk�Ǳjʐ{����M�&*�=��6����̋I�K@<q�݅#N�38�w8�����#�s�ZE
��f'�Sm��?�AZ�Ϳ�jF��O�q6�x̚4�&��K$��ں�]Jv�F_��h�(n���o�3���d�w���ɹ-%-�<W�mu�a��و'���Ƕ;��ݵ�{quʡ��"�� ���R      �   B   x�3202�50�54�42�9��3�K9}�\�8���9s������zy�\1z\\\ ���      �   o   x�]�;�@���>�/�h�^6Yw<R�%�?��H�/FS|tYo��en��y�	$(y�#���{�g���B��c(�Y����aaG�c1�S֖^��i�~ ���      �   }   x����� C�f�.@>I�Y�����Bʅ<����[�zm~5?n����=��f�DW�4��p������ϑ������3}��������  9��$ap��@�0���!�$�s�R^8���      �      x���ˮ-�������j@�Z]�ðQ��7��0l�@]�ߤb���Ę�6re~#B�(^~���o�������߿Z���O�O�����o����?M��}��_����?�����G�? }�?���.�?��������������1�cI��e�=ZF�@?���_�S��?���sA�ZПZ?P��������_�������������뿾��O���#b���b�h���*T�Q�i���h��>����h)�b��G�{�f[������]r����?�7�������U�ı��?��������G�7{��~����՞bǃ_����Tmc�x��xX�t����_9�A-{��_@�SЖ�����;��Y�&�O-o��=@w@�(����+�!�U�QB跑�}��W�TnE�/�������*�)����FR���?�ގT��/��FW��  ���7���­�_l{0��B���?�)<	�O��`W(�p�by���g՞����ɟdi*a�5�׉��#��mƿ[��<����v�;��%�:}���Oo��_HM!������J��	��J�7 �!������$�C�(�V͸��P:�/0��As��Ä���yN����/W_'����b�I�-��jv�H��;-�
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
1�ND��q�_�Z�j��͇�S�_'_��D�5�ɧ��d��7�����;x@��Ŝ)V�{�d!�ںZ�J"Z������r3�:c�����6��������Z��<��ሀ��G�p���Z@����-Y+THl�����w���jk��Y��C�m|^x����#��-��(���®>��G����,2�%�(ޮ�:kt��x4)�g��M�Ԝ̈5�=[/o� �b�(�l��)f���Y6���"��D}�rn��Ol�>?R��;����Ĵ��2w�D-�����s͖��ﾃ����s����ݤN�"�5�o�� ��l.�Q�_�L`ᗒ�^)����/e��p�A�kЍ�|պ���ԇB����: �[��f�M�>�{�6��ަuO��~lm��N��!q�Jއt�T��8C� I�=��;dOV�և��J���@�#tYx�����'Ն�0������iv��~��Gh~����l�0/��w�eg��1� x����y�,��� =��rօ�k�AI����� ��1��]� Qm��8�x�(~W�cG���}�����Ϻ0[��S^mxK���(�_͗�N��s�cjѐѦ�Q�JQ�a�� ���ϝ2�^���E��Z|�=d�d
���u���܍9`3��jzz�z��Jk�d���[�RYa�I�?�(r��h�/d�tY�s�7�	Q�uǈ/A�ya�@�-�0��g�)����i�~�e� �����6����u)p�|w�)��$}MB>p����^�?0-��?b����%�J�#V^����z�a����V�X2�����QԚ9zo���z��h��HzA���U��2�l�zMi��H��ǎ�­u���Ӗ<
^�E��8��ù"�=���"!
"�E��c�����&�������P���-y�D����5u��%�g���:�eH�(���b^iK�s�߆�ܴ'�Q���-%xvF���}`���zT�6fB�P{8���Vs����`�G��0m^+e�;?R��u�4��C��O��a�������&k+������W\Y�s���θ�:�~�C]�u��J��}x4Vo�nO1����E�Q��������@�5	�u����Q0(^�#�d���?.6�헒����w�u��e��-�� ���e�օ��N=��s�_=L�$1�8�;�~�A_�A�#�I�)$��Č?��WƎy/f�����cyۙ�a��rQu���_9�DH�N
~�|ؽ���q�3��%Bw���1��E�C�Ⱦ��[i�)~�:�Td�;k1��#{f�M.�a>�e")�2�� R�����|���aN��"���Qm�kZq���<~��1׼b����w�h%&�]S���%S?`�����<�v��u��������Y�#�%s��������j�T��^�c#�V��s	*WV<��G4݂�CwHXM^S4tǘ�r��A8.3�c�f�j�+^_?�h�1��]|� ׼4y�����4� +  �;u@��}qA��,�~�_J��~�CYּ��䁴��[6kT7�O�d��2e]1<%�"t �k"4��F�V�0�BW��q��w���29�GEy��r���!|(لt1���I���o_m;F-���;V�i��S_�̃?�(0��m�ZL�h����@���m<�Jd{��TC�SKS�0Ն�BR���d�VG����&��(l�+��C���d��,�F��I1瞄�3L�3������Yv�u!�M�C����I��m����6k�?z�$%x �{Óv�X��j�yC5N�G�b�8�/_d���L�1�"=��sC<ۆy+�hc���I�[�?��rU~hӛ}�LK�p�q�6q�\����*�5�����ݕxp˃i�H\�e$�u�p逿75oʺ'4�w��<����l
�آl���	�9vL�%0.�F��
O�1�E�l԰���;e�5l��ä��Zʆ��s��׃�&��p��6�9U�<b0|�7�q�©��cԲ�uh�I]�fY=	���f��1���i�2�����`��9����K���A�Zڎ����)s��>WK�1o���� �gs!ı�m�e�XK��޾�%	�(�����%�	�2v�Z"L-q�0�>a�X�7y�^-�a�F� E�a�R��C[y���r,���� �'× r*���[Z�+�i&���s*�y��e�`$Es�wO�*5PfV�z�,/q���ug��4|ja|kGy0����!��Q�ڴ{JG��g��2��{1
�Pů%��mǶQ�Oΰ2n|������_����h��      �   @   x�3�v�twt��sWv
��s�44��!##c]#]#C3++C�\1z\\\ �Ej      �      x��}ێIr�s�+�q��;q��-��$��X$�2�X�, ��Z���ya&����{���FU�V�O����1����=��~���������]UT�/E�KY����KQ6�����?M���q���m���������wo�/�o�wծow��_�v���?���������������?v�l���K�^��n�����h,�/eK`8,�����хR8X�����RW��a�z�t�߿���G�������O���h����q�Y�o��ST�_��Ι�3��5AY?CW�U4��������_w�?�o�=��O��i�^^���>��o��<e�n���A֞P��~i��bf�lm�M�����vo����C�{�sGw֫�~�������j�zxrG�ݳ=^�����2�ܲ�M��O�O��.ݿ|�������#q��]9��=�җ�o���������7�����7Mɠ�݇ë�q���o$�ʿg�c�B�R������RO�����~;~��__������/��� �H�]Y^��o��H����÷�~{{�߽=~9�����7O�s�9��p���L�RN�r�@/��O�?�>}�t�/��E�\7�=�>~��vw����������n0]��4U����_�4���v7�8h��i��w�����v^"wc���m��E"�B��?>��/��nx?�~}�Z�#�v�q:Q��üq�����������߾�w����7Nɟp�"$����E(vo����?2�cy�N�4��9z�N���r/�8�7߸c|�2̾���Uy��O������Ϗ�>��U�?��+��u��$�T�?S�G|y���o�ҵ�k������i�.����FS����v��8���gu�F�����4#Z�}�`ҚWm��7��址"�@Npb9F����di:��Py0,���Ky�Z/�$��fW]l����fh���&C��A8�5�+5���&���ᬟ$��49�4=ݶI"�2�a+� �����ᷯ*��4��5����-��F~�j��3_Nm�a�G��7zFb�$�=߼��	p@8�A��*�����Y/<E��5��8��CTl�i0W,C$�Pj�0=z3ݚ��~��;���O�(��@��闪�~#q�'�r��in�+SoY��G⡕�B�=<�g����I?:ã�l�cӻ���I�^ZD�h(��T�(���FD��'��	�f4W` d_����k�@?�c,v�������ߦ���g��]��3zE{����a�����̳#�l�P�����6<z�y�oR!i�����M����m��'a8B$��jSӑ����@�J���zI0��-[���/�\.�Y$��Q�>�����"x� �Ʊ����פn���?��,�ǐp<eŃ(M��8��
�(��7��Ye/t�۳k��˖�L`�̥�MaȎ��`'��3���j��ce�pxᜢ66L�[�˰E}�Fbi����.e�ۧ��L��G��;�D����D��\�DlW0��1��w��w�CV(Z�]1ߦ����}��������V���Q�{�lQ��p+�<���W���ֹھY:?�X�J�c�����UW��M�'2z���$���
%|����
�aVH�s,�g�Q��޴��7������"�\,g( !CI%M7A�Ȅ�&ӬbЅ��zUfXBĈT���Wq�E��+���.&d��*t�?��(t����S.̓k�z��_���,��}�ԪԮd�z�FW���Ԡ+]_��(�_QՕ�����q����{$�*���E@q�l���,xG/����˚�T�^W1:Q)F�aL6�	�ʻ�Y�`*�o��AC�ɧn����ݯ����wGW���]ruw�F�p��"5YD�D�Y�'��J��/c"(*| ��r�������H<��#c=���*�;��W��t�l	/��I^�� ���p�'�`���]����>�z=�Ur�Q������v�+9Q��x�.� [!Z��|�6L�D���!D��x<���[���7��k���~ݠ0�^Q>�k=����rNn��0F�{�^���M�h, �o�kz�B�^"{��;^��`8V[�J0@�P��R���2�p0����5�-F� �FQ�l�~M"�uT�20z�17<�q�G�u�M���;]�S�S�Y=V�,gu������,���?<��������������oz\b��_�Q�ă���s+�޺׻L�;4zL0�/�J77~��
ig�K7�ƥ\�9b���\T�)��BlIgH�l!M�2Ά*���:���7bT�Ō-��+��L��.�	��"i ��9���k�%�8-:��9b�@�f;1��$��i�
7�K��?V��T1�ع�6P׹iBD=���I	,���
2}�s��Ź��)F�i +�H�044�߲�)������X�2�h<�8U�F� (ɜH+3Q�S����+i��K|20M��7�^�=���N<����H��L�D�G_I���p��;��FO7u�`�����p��D�V4��1Ž�t����G�U�vek��Q[N�/"�w��������ZXrbqж6h��m��J����f�z�$��/L�#`�5�%�}��^���z!��G_�+�n�)HiDΝ��i��$5���
I@ �K�`T;�ϕ�4�+������P���R+��~4���P�����~�����L�&]v��C� ����esJP�ܬϯv�ٹ:��zq�����Η�qj(��)�2�:�N��6�L�+J�)��W��I�6��0��e�;z�F�M��Ж$rZ�B,B�;�FL!��7'Q����v7�/D��ûjqV����C|�m���Z�d�,��~� ��^�$���³a��u�}�C�Q�ʑ+�"C���s�eH%�6�''��.,]�����nC��?1�x�����&��T`�g�~d
M�P�����*e�=4:Y�B�P���+ ��]e�X\	 %>D���֞a��	�*x���~�
�L^ �0�GW&�GO��@�~��*�o/������QK����)1�Ո��NqQTn�Z�쪬7��۵�褷�[�V�x���'�R����H�.xI))���k�pHQThl}֚���?zw�NeP��������$�(�h�c�+����wv��t&��b��є���	Y`hx�,g:C�MI�	��m�3ҏ�V�,�h�����R�O��R����ͩ�آY��JL��vw��}�&�������in���������i�K�'���{�����3X`C�������w�f�&�a
�[��*�r/�X�X�������[ �Yz ��ǫy�Պ��e}�5��U�����ٵ~�H���9Me 7HB� �gt�J�E�$�V��OAҿCD�==g�v	�tJ��|�]?�B(L��w���Ԣ�Ģ"ك�����y��.�$҄ ��"�/þ�#כS��APl��NAB	���T�`�jɠ�.C+�ǀc����peBr���/�^��̋�_\��٩q�
�
 ptF����3&����-t�G�p����\n�0�_��ӕ�u�f<������i	���<���io�q�E^)øv[MG+���.GgI�cH<�x��Q�m�>~�Ɋd���Y��I�Z�
Mmz�a�7�ev�/�����Bq�p�e5g !�V���i�,����ȳ�nG���<K	y��Ʈ3�5����T�5)e��e=<���c������ZƝ��wʇ3����l�7˖�cx����r8<��~u}�Ͽt7_6�K�Ӫ�� ��������*]]�{
g�Oi�h{ ��<#�Dq<ͅi��lQ�[f��8�p@g�p_g�\18:SJ��'���/�����<��F��@�.o.a	d�~#���W5ߘҽ�D�Azp7<(���Û��4\a_�ٰUNb�Ma��LAb�7�6�V�b�)�8n�V�]����T����	�3��M�܅7�|㠵�e��X�[    "Apn-UEc��bJR`��)j��фO�֕�OKCX��WT����]#6��2l�L�U��艍	B�KE+���Q�8�a'��hϲvv���L�w���V�1�D���|V����`7����w{�<�}E��OW�d�7W k�U���}��e��nu�	%�)]��:�jX�p�\>@�ă�'f�zNU�%�����f�l�&�'X9,0���yNFG���f��K=�������>��51ö�FoJ����en��AoWSz�r��qHB�и��A�>��4n�S�D�Q���
U2@x2�d0�x��dHJ�X'��
�ҁ^�xq�~�ѭ.���n���#=�WĮrl�Kx��8��]��&�Ӟ�{~�F��˿Q-a0�" ��8.@h^�|�t~�L�,���d��+}�As�bL�H �b��(/��[�b�\�������o4���?��l3���5�/SiHH��S{N�s�<�u��j�#�5���!%޲����#�G��kt�bK\ϵ�G���ku��Wc���9�r��<�%d�"8��e�0�[�a���Dn����rٷ��v\�ic��D�S��c$�r+X��%�V��	j��c3�>EJ�C,	ٸ�:�4Mh�&aIG'�"���X�]��iüZ"���;�!���R��A=��ݕn���RaXA�Ȑ4>�(db�p*�J���X`q����zx�ǲ�m�$t
U�X�r�""b0��������(� ��QZ��i$n[�WF�C2�t�Ov���V}�ƽ��{]j^������w3TEE�xv����V[ltiq�N�`����mȀ�6� 7EB�d�0��N��ݏ�O���<뀶��7犔2��,��K˕�'� ��M�z^���@YO#B\28A��D��QJ�f��LӇ۩c%��o���c"rT��
E��*~FWU�/�P��J�����[\*���ِ���K�s'�>�[����HTn�q�XzU�.��s����(i�Ɩ4@G�h�.�`����-S�����h� 7,A_�ᕚq�����<&vq{]�;���?���Wj�Gg裕)��PܥT�ѡ�����Q1r��*����P��� ��k���.Ͱ��������X�IȦ�31�ȈTG)zF��kB��:��F�r���Wf���
�+=-'fE�}E{�k֧81��� �|���V���H�h�>�mD&vsc$�l	��4���J��;�y��+��jZpL��L�
05��X�~_�{"� �(������6�{�JIL8���Nb��h�4LJ� 4S�N�v�b!��X��Pu��_�8L�2}�0RFͧ�u;�*�8���[^�ߖ6�� �,д$��$������`[DI��Tzp�NÅ�H�'�y|�5K�\eL�Kl���Mq��*j�0��D��-POB�75�<�c�^
!;���*���4��)�5�o� ÆVv2�"f�h��?1L�ޛ��=@qX:?��,�$(�*
��ClKʆ��?�;1�J�'�$9sP��<SyMS�},�c�ob�6Hp:l(V��s,dX zp�"[[9~���<A&Qq�3w�����s��]i3Ҥ�b3r��ԅ�\���杞���Р�����W5��:b���HryY墼~7L�����U�\��~"Cn�(��C�E�|y͋�s�2��!=��(�����[�T�0�S
�0χ���~?�IzP�y)�3&̀Ѥm�72�~5��Q��!D��&1zpdSda�4�(���fC� ��.��m��S�f�����+����e^\��~Y��
B1S7#81�[���-d��g�CS:u��ޕK)w  �A#E��2�[ՔZ�G���[��|��#��Q��P��Y���R�rI@��o$0�����EÓ�	�[�"X�K�ZH<n�l敞��$d�g�U�!�2n�J!Ko��������Mo����l�P
7"-&|��b�%"Ba`4TkC!�W���J�(߶��,���^�6'�3�=�h�H�{�<����!E�K���K�\�ѣ[��h,�J�D�McT�l��0ɉ��e�eP o�b{����@�B4�3��ļC�)eb}�YZ��2=��_z��̯�s_k���n���@��+�}����O�Db����|�Pd���?�]��Y�E��XQ�A�.3ʪ��0�y]��q�M2��<�>�|�����eBi4�͕�j\侾~#�\N ~�`��7�VYq�5O� >u�J��u_���\�d�ո����f�֖�&@p�����=���23C�aRǄ�+�I	1��抜r���(�	�p��%��5�A�{A���7��m�a�f���m��j��5��ZF�A����4��R=�t�aC���[#�bU	�D�v%V=2�w$�1M��c5�q���R�F_d�htƞ^5�nO3�;R"�I>,�y����a�x(ڒ}o/d��1E�e;
5�X��e��V@��g[r��eE�R�E�=�d��UȈ��(��Ud
z���L@��cR��2�<8^�z��E�il.�%cL���ZjGzt&�\Ȕ���p&4ƀQ�T�T�LG��`}�ʶ�PV�m���*���+d4" #����E&���Ǫߢ`����	Y���Ƙ��БB�Ť��Ѣ��#�2�h�7�� �Fbҵ����	�05�ݢ�诬g`7ǂ9Dr*��!�C�)8Jc��ӈ��lOr�m�Mnlj)C(T��G�_�ڏ5I��QQz@F�s�Al�)�����e�Ly��(���;I�U�y�P@�]�.{b���@�C#""�}}�ĵaN����X!8�+jD�ݡ��ɜ%g��A\��* �Ϧ�O��]����-¤�$��!Q�6��;z�T����49e�k`�H��X�� ��
Q�4�5aZh$#�kP�3�X"	�-"��У;�39ϙ���e:Aң3��e��4��K�kFP�x���l� ����a�����s?y�^��8�p�hL�R�#EP�|` ��)�(A@HH�;B��+ .B��j�?>��3�1QK6o{�W��)�O���H(H�Ty
�n��fM��T���7d���=|�ri�1�Uw�o��1���:n���(�J9C�X�RB�N�P�c'N�[��aP^�DU�{Քn��v=*��7�i4���me�se�A\����Ъ�wv  �c�ТУ��4}�[�u���N��Ɓ~��gE���}e�&��f<0��-��G�g�@�����@|eU=:��z�~�p5�#L	3M��Qk�@��t=�9��W,��l�aO��k����ej�V�Ć.��g��?A��2ӿAu}�6m`KE&BDna��<�CxM9V��p�Vz�1���U/R�C	?px�/��Q��>Nf�6+*�����[#����|�D���,nWh=(�v�ɳք�PL%�T)Ξ��� ���.YF3A�޻w��|�:w"*"�����m
]@3F��tI���-���(�Q��i熯����j���2Y�o���ɂ/���g{���EE���$E���<2<1������{��c�~#�]��sΗ���7�Z�г4�4���׉��E����~7`�w_^�w_f���}�uu�� ��02��r-g��~�f�Ӓhӣ3��"�K	S�S(�@c1*���s���{�P� �K�a�z��%�\���[���7[�[��:���� �����U�(6�K�p��)�W�|��Ul*��i 8ù�pz���l���t�;>�f8c;���x�C[}�!��G��F,)��MC�?�B7 ��IX�T�{���2I{�-�[Pr߱/���_wc�M ���$0��n���T��T�7-�^B	I9������i`Z�Z0�chIU���ۗ���u6|i0L����tzP�f�FBE9H(�>t��7[ʑ7!�'+�1�0��"�mi z�Go��P��ŉi,���o�����ia.Q� I1n�4/�nK%��˸��!Y���s���a�T)���b[T    e�w��Sb�v�5
x{<'��N4��V�ҁ��u3F�[ �dr˨����d.��BX�В����D������o��ca�`�F���������y��ኮ�S5)��P�)ƐV�5��=d]�� �Ɛv:��^���XЙwÆ,.��+�EC��3�i �f����~#q4�&�8��7G�`�u�dGo��X���¬�KhRML�#e�iu�(�n��Sf��[fVQZ���I�|m��Td㏣�� Ӿ\O��rm��t���zjF��6���AS�L�N�d�az��I�� `H1ò  �z����H�w��W!l��a	PG���b�J�2�2�V\J�Ȼ2�p�VIR�nQV���x��Ǻ����Pw���4��k'�6+���t��0��-*KQ8B*	����Ue2` �n�
�cO��P��dB~:D���AP��$��z���"��\�2�Z1�`ɓ�ŊJ^�5��F�o�q�lU��K�i�%��\VJ"�O�ݦK�;�j�{�>�rI�� �"�V�ht�j����z��g�	l����.� ��`��.r��ধ��UUV\b���b�iyJYq/����Z{�q/��p"�!��)��<-H���X?��<7	3�xᬟ'�+5�^����v:tL:���(x=!�k�nړ� X�|В���Rx��y4�1�D�j����W�r	�_��gr��fq�K@�c��I��r��@=Yl*�CQsl��υ��\}\ֵ�-�C��"QuZ/��Ţa�(D
�!T0;i�:< u���Tg�Q�C(��A�:%L�M�ꘀ������JYT&�P�Oĕx���-�/U��&� 0�\-.St�%�"��iZGs���9��[B�P�R�֗-y��vၨ"���E����N�Y9ՙ�����;t����y����9�~�R|j��8z����dS��`&��(ɂV�X��=�"���A{���!Q�F�2�'�c�t$a��5�D��y�趏����:/��K�ʜ!4���Q�����E��V�è�ٜ�}��O�w�����~}xy��{�}�����'��-�P�L:T�\��M�^t���@H�Εq+��!�R���ޭ"�uG'e[�B�����L������@e�|8Ƞ��$-M�1�
�6Qu��B"��ʡ�1p�+&�ݯV\Vu1{s�"}C1-0e��#(�����|AQ�c� ���������je���ޘ�2�%�e�kht���t�X�B�ݖ:%�0׫�Rq��U���W�I=2�	±U�kG�d�ht[�M.3e?d6����tN��N��.��#$OFx���$��Q�ɰ�h�����:j�ɺf*�*��1a	�>�㖩����:W4AƔU�4���f��f�j̀cL���!�F2�\+BP陹�ą� �o�QT
��BX���ї�?1^j��K�0�pD�A$���hPL.�X!�&%5�����WB�/�	��/ū��I��P���<='�o���������zr'�2A���O$���"���֣��6�&�T^��%uksqk.��YD��G�4������t�v������VPt�"� ��|�����Fn#yC�@`��e�LŴ� �<A�ǉfS� �"�"��M��I�U&�)��6%���z�Iʣ ���\�.`��\2%�\��T+��́tG�1��5Ȕ�DHL�PBP�7 ��ˤ��4�۸men4�m��.f��#�IEGP2LE/�y$�{�#o��PR݈�h��7b�e�@dX��ȸ�J�-.���d�� $�ʄ����!�h7��3&�j!��"Ml��"E4��	��	��[����gA,s�B��1͂��e�����*�s%�4K�ץ��`������_	��
��^�+�ֵ�ʈ@�g�K�&��+���7~"iN��a��9Uu�Fҳ3�Z�b��락ۛ(�Dı��]Q���F�%th�i�%�@���ڧUE��-���W�Z�`����!�?��afu�gVk�ΩB�u�q��RR�,�J��V�Z��(�V�'���ǥ��G�Ƥs�3�b�j�P�%83�_MeH��[X������*�B�6�E��0p�^3�9��+�;��Xe�^��TaN'@3��X^Bc]�
 3*����"���qn/(��ϯ��,��Z��޸T?��*��n#�N�!�;� -��'�⤠����hin	/�f������A��+�!�iR��j�Z�Ԓ鍩Y�� R�.mB#�iS�\�^ϒ��F�RYj6�6@�s�����T��C
�X.Pɺ�J+U����i�9�+^�@��0fy �r��t����V�t��������T`��:ۇ�?Qc�س��2�Y�alb@Xy0�h�&�1��%�@s�x�2E7�੶L�A���x���)�ai�&�6���V\��LtA��͠K� ŪA��LU���jCo�Ă�:�ʡ_8��0��h
a1��Ӱ,�C(��Dc�������W�(�a�[D�T�����(�wꨤW�Z�I=�M32\�bH%���е,��P>4�m;)Z��t(�)���؆*� j�	2|�l�@��jrۍ�b��V�D`��ʤ!(�1SZ���?x����/�bY2��ÔA�0�\v܂��-j�67��"7��m�|R����;�%d�|h�k��+<�k�<v�k�4CL]�(b�_~�U&ބ���(�%%��;��C9�|c�hI`\/*�B��z�O��֗	R��%V���	rU��(����68z�0�D�����H��"j��y�L�����;��f�Lº��55L3�wa�}7@ԩ�RB~j���΁�4DcM-ҁ��ov$��#8�U""�GHL�tdʱ@4�>A��za�.Z$W°m'AZ��׍�%ǲI&��v���7G��5�"��t��!=dt&�mؗD�0͛�s����be������Y�1r�f�	]�h�,K��t	@X�MQ�JN�i�B�\�aː�t8���lp[gYټbθ*9r���U�MlZ�
i�$YAɰpTˤ;	UDX�����`єb3��d�c#(��(��u�*����0i%6�+�@ ,9:=�j!�ᅠdXr�y���y�����GMU��%�
�"4�+���]�tg&�!���Оr�E��E��xC
=\fK�\FH�N�V�M��ʼ����J3��(�_/7�V�
*����d��(tjW�4=��l#�Gpl�UD�a�d�����Ty�9�"��2U��6d��qu!
h5���0�\�<��^�}1�۹��q��d��ሥ��n�p�3��ϛo�=X���x�!��/��7Iv'ip:��*���"Ƥg\��Ue4��a8w=�0�+h��&p���XH�u�L��6_���-�y@(�F��'F��?�hjKW�nz��C���Ѷ���	�XƉ���z�f�͓nx3?A����J�~���?"U1���%���i�u���&�Dk�Q��0��r%=C�!��$�2:6�حz!�*�n�8f�iV9ŠTKY��ꕲ��+����?I�Iq��A����G�C��Qs�B��(�l�K���p�4	�ti������O�W̃�r�DվX�p�N�t�����n�ϫˍ˴�D�gؖ2$�C��!J`hWņ�A�5Ҿ1(
�d�<�KB�	V���,Yg�#0�
s
�;ht[w�D50n��6Fh�_Lp4Bb 8|�b �m��S��;�$�Fj-4MO��T��KsV��7+m�%�����C0�Ƹb͒3��4U�u�r���_T�葯UB�oW��LJ�A�0&6j5H��g�B&�!1M���g��C��j�4�k`��yp�W��6O#īb�j�D��˂��1��yV@Ŵ�/ͼ��kB}� S���H���e�B
��A��T�~�N0�o���BT~�BYT����8(=/�[�^!�1�cۭ�d��%jR�
�@��r��@8�1k@�`���23n&��i��U(���!������    �3%���ᅸ��!�+�+��=V��`O�{�dnX�sQ��0ea��|7@	n~��n~�	C��o�Ř����J�,8z����Uh���w
	��`��&�8�5��͎v�q����a��������Ow��_������ҋ�����̥�Xv*�ݓZ٩�鶢f�
�V�e�
���󛓱��B�k'�Ɋ"0�$Q�&x�����0�BW���"��%'��in�;�tAEHL���HnY&X����VF#67@LH���	�z!j�� �g ��6�U��}Hs_�0`0���b2x��ZDֳqQ�jx}x���[R�%��9%r��|�1�����vz7�� iB��`G}K� A�u�ir�B΂��WD�ɫ�Pc]i�Nrc��A�5�h��a���HV!��Z]�jŹ�)���dXӧY!�Pd
�,�T��$<�B���i�3�yT-~=��B����1,o�߃%�頫��
��d�x��rx}uL����d�����7�e�WZ���R��@ ���h�n3*	����	���ݪ��4됍"Q��Fe��A��w�k�0�����T�� S@DSk�Yk,iXL��)
)�*#C��A&�W�FP2|�
W�'"DC��
�h���[�!��D�|�ӱVr>��ġ˖0Z<==gk��I-��P%G�����8A_�W&#��p�ZPX����8y)ɪ�Қ���Ԥky�����MS����(Q��dB�(n��6�I�d;M1)v>�4stY�;���3,w�1�9�ݍИ�n:l�W�`�i}x6T5�h�S:1q�Ld4*h���9֌8߀�e~N�lo���iF�gs!��n�xل-5��^�FE&̄�df��N��҉����ȣ�Y\H�a$%�g��&0j"⢶;"8��tKCFXM�d�r��0��i�RZG�Vc�f	-{��x̳���M���������<3������;�2f=B��do��W2��V�BV�-�	���FPl�UUe�;B�-QeQ�v�������k��������3���*�n!�~���\B���OF�j]Q���/�£�(�7+���H�^�bΐ�D"%͜3�t������� ����*�v�Z ۫�V�@@��Xr���+�Qv��Gn`�`���ŘX�m(p���acZ7�0��KW(��� �O-��a*��q����]��m�$��WH�M'-��7�<�/2�ue�� #�oD&�SͤP���Bh��qx��aкO�be���	��&���*2���
�́WMLΓ�w��5e�G 9
.O���w��]&/���y�ʉ�{(�,ݖr��[�B������UO@'Þ�C����n�(��`�I"ɯ�]�'0�,X�V�F&���\M��@��n��+�kG�+I�S�T1����ԛ��VT��~�����������x��k��]��Z��$��L� vreTpxc�7-5dh^)���vi�wp�	]8h��7u���2Ev����~�T��AH2�x��Id@Pl3`HT=3A�U�{��.�B�^M�/JY\f��KUzHb��`�6)D����>$�[2R0��bI��G����1�eC% ��v+���A��֡	U�4<�&��|\=6�(Bc���	ʌ�O� �PL	pб+���  *93mI3�!e*��|og�����nf���り�N�ń=O��eG����\4�[z�f�Z���I4���i���hBJ��i��K�+�B�/��V[p���=LW�p堊�ri�e�����Z��ޘ���S�,֜�ޜ�$a1d�f	�.W�7���XS>(%G������$@)]Qh_(��1���d���$����1��ϩW]�8:��1��X���̚�k��$8� �cs�4��7���Aku��ai����i��C�e��A��8�	bVɽ��eC����^�P�c��VKg��b;	�1�It0�mI��&0�5�+S�75'(�,� ��
��	i��뇎G�e�r�Bc~��������B�';]�J��sbZ���N*��*ϯ��n�l8�&��S�;+	
Bc*]��y�J1Mǹ�uG�+�1���J*f /ٸ!!�:�VmZ��К������݆oz[ȣqO�QN�bz�踐÷�LF���կZяM���ck�ф:S�H,���3ɠi�*�@8�WF�~Gӌdϔ�������"�r��8� L�oq�� !%s��G��JC�z��a��:��i��5�P��Y��\�<^��C8k�VyL��{(�>B\s�ؐM18%�L�%��4M�񲄭x��z��P�hu�FC�$�P�&�_%��\n31_����李�d��4G�4
�#,ƍ�h:Ε���٧	v�G�P;4�m{��%cX	���%a���M��	BSO�����rw�����\��~�?>ѳ��Mo�V�u�5k2mm�)�טup�e4�(��6����X�y���X%��Z�Je��a�b�DΊ(�"mR�D%hZ�ǧ����n�����dJChdöVZ�5�u����ACp�;h3}a��҅?��LU�$�.�݊�-tA"<9���;O���;���ڐ��~Z���u84A�Ej�Y��N�f��� ��9}�W(�mcX\#�۹�d�&�LGEhHC	(MS9)XB4z����&�Q�\�"
s��[Q
I�5kC�!	5�sҒ�i���4w�/~&S�!ɯ��hы	B�mQ�㥿su�w����1��<m���I��s&��uI���*ĕ\��O�#9R�Š�WE02ԫmB4�q�U�1_�{�m	i�mi�C�%���VF��S/DXx-��(4��L,	TE?��O/��< 4�շ/�h4��\��������9J�el��C!��*��沑�i�{��(8I��@9����P,� �mI"D�T!̀�	Sz������4s"��S^�&�`�q0�&P��{�� (�i-� l�e����R�@9R�L���%Ŷ?z)L�jt��5�����d.�n2{��3������� ۦ�$����fO0&u�a�a����L��b�ԠL����.D���slqi��O�Caba�P��@��uL���tyLc����3�Ω=+�:� D��� �#� ��+�l\H81t\�阥����:�Mڇ���*��L�A�	����]�)�!�: ,��S���ۦ2| Bb*�+V0�&����V�^T�_O<��ZVA��m7� e�� Jw��h�� ��V�qX��L�p��C�i:������˼>iK�)�����P�b-"$]�e1��Q"�ȃ�3~2�}O����y�C��u�U|���PD8�=�>�|��Z'�N~Q�%��2���U`�ъy���\�j7�NO�O�1���e��0�p^��/]y�F�a<:�[�򳢊�jŨ�5o�ʯ��tb..PN��(�<P�����^���������?��o�ڨI@�4��"���ox"���8���'S�-������}z��?�����������i��Ϗϟ���%}�e�gSg�D�z�"5�6�T�p�FeRq� ��엠�<J������Y�q�ɒ"2N*�#����7[��	e�`�FO/�E:���s���a!�.�ů�)v@#��;i"j25��rd�J4��q_}������7��+S��-	��t��s����+__��`�Q�z6��5�e�Wr��o�(�Ã��m��O;����H<�u$���g�.���?�=�z����׻�����~������r���7�k�����ڶ�36"�����Hn�L�z*�4P�h�T���3 DL�!���*�o1K��Q�F�d�zztG& T$�}M�_�w�H`��¡Gg�>"n���(^��EYO�\����?|�]Ȣ���r�Ty��-N�fE����)�MУ���H�d�+�ǅO���-�_�ť�=ǡ)+�@��]D��0n��	֯�l�x��cL��`�-4����Ϥ�YH���7n�f̊�]$V��n\/�ť{��@	}LqI����aP�R|0�>8��1�a�윒˪]s�y    T�~�m$�v�6i�f��ؽ}��w��^���}������j��O�#�*��ߝYS��Q���c�e���AY��Q|���!�����	(8 �p�=���o��y���$c������g٥��2����e��P,X
��uw{!����T�����o�v��m��|�/���`|� ^�$xT�������4>�%�4҈�|)!*��}Ld����].Dz�X�2BaqKi����fK9i<no%�W��R�R.�T���M���Y��M��'�;1��|�T��@nN�r�$7-WѯV$��^�Ui���h��Z�%A�ߝ��ޡwv6��%f�0�؉"��L��L��DX�뭐�j\��ð,�)����a�V!�a�mr`����nZi�^ۆC4��)�<S���du@"�H�ՊrblBdބ�f��Fp�Wt���O�I�2�b[�F岰"�;ܴ
 	��y}xj67�(2�����׎ dz+U����% �������6� ���4��L�k�<�Z��޸3�X�2MBC&�)	� ��H�o�YH����vI��-*�B(���i���D�*.t�%D(���AQ��"�@�:��<�7JV�f�WM���!o��-C�7-°��
C�֖%�cL��,��~+C\�'��0k����������!e|pO�v��e��q�̗�����O���dp�����
~V��p2���`E�H�Ĵ&ي�3��FOP��,ԀA�m@Q���y��n%��t��Ο&�ۘ��&��PV[FW�֐~OY��(�b�O��F�$B�ԾEPl-~�YT����j,҃0�V�4�^Y(a�����5�����g°��N�rC("�68z�sc��y���B�3]��W�딋 �_4���VFI����tK琌2^+��k��2(���u�4,�9�e�P\�.�/�����*& ,F �""(�."��i$&R,B�������_��v�����t�����������ˋw�����������qϥ�V �h�B1'/��4w���χ�����iB~=|{��<��_��O��]�O���`��������Á]�73�X5c�t�������� �6 ��^VE���j���駝~�Z��q5�l�K��.p�׿TTļl��X�>���b.,t���px~;�g$g����>WN���ښWB�wc��z�	������uR./��BT�}V�_w�^�	Ū�X����7k9o��������]R��b�G7���i2�US��Q˹"��b��,Y��8W�Ț_
J���ͺ�s�V�F�f6�������]{��i���l�	�͟�/�������z�ݣ����G7��lN� lT�c�J��-����h`1��SԣcQ�r��r����u[�5�6�R�;�Й�I�Τ��p<Z�Ќ����9I6-������*�P�y]�t��|��p���ʼ�@sa�+=�X'�����R�RR�U�l3��������f[���'On�~BoC@Tq��y{��*�DF�"M�s��	V<�Q�֓E<�E�Ey:���`gѨ����R9��'��>���L��O��?��QKu��O�����y�;p�[��c�7ѐ�*Q�s�k�F��$|�IXc����'?ZjǨ��B��0�|#緯�r_$5Y%O�_�9.�3	Rv�o�*n��N�	U|���݅��B�n� ��'��^'x����)ݑ���\B���{���04�8��"q�n� TQ�UR��銦[D"?�躨�v�h`q�x%4O��#Xw�/��䨢��W'XCzXQ�x�fJ�U�ە�A��Ą/5+�bX�Y�E�'��Øa�6����4��;=�H�#���.tZ#g��c(TUuu&���Mb�G��VYn��f�w�����tm}i��⌕d�)����?Sw��S�����E'�;K���GhnVl�安��B�ʚ��L��*Ni�Θ���ܧtަG�坴)qB�6�%�e�9��v2�R�ֶ4���z��(T�h�\i;>�3�ا����Ţ��BQ�8U����B�I�R�\V�X*v'/ l�Hhau��莆�>?i����u�N��0ɱ<[M'�sJI��޾>^v���	ķ���ç��ݩ�����]�7v1m�����u�T�q��?q�^���6G�����U~��#�8�uz��/�a:P�\�����:��U7�֘
�`�Z�{�P�B_m��J�>��&.�ʕ������+GB��ɢ�e7Y�h,2�(=_�B�T�N˔�F��(�Tas�qat��)|��\��W��Y�A���L��"ߞ*N��R�TP;��4&[DU7]�I VB�=!���c��>U�v8a.	��NN��0��J�oA��q	*.�U�"�T%���ШLCmp��d3U ^�8N&��.VaYF&i$�0�(KP̵�W���*���0�rӉ��8KA|Ѣ���6(	+ΓH�
�se�������J@��N��1ΏH�*�se�� `Y���e�O}�g,�!L�Ҩ�2T��4�8�P:��D'������Dd��tD%F����;+�R&�t[4��wZxg�e����iX֙P4�8�a��#�ʚ,�D���OFCҠ�ä7̺���T.NW��ɕڸ�7�:	8���^����k���.�&R\�λ�QYG�hT�,-�8�FUFm����(}�4��NO��*YPqG0-C�Y�㷥Ө��f�d�870�A�ɰ��hTqND�˝�e^5���%4�hX24�8�!ݥE��"�҄	)
��#�
4ITq�L��9��j�l�����4���kKk/�C0Vd.
��'�F�$ϸ�J	O����%a�qź����&�����4���'�΄�e]���-�@��d��Y�4��KzcE&J����@�R�v���$t��%��*��e��Ө�.a�2��O��P���h�F�Hw7Љn�9�2mJ��Bm�Q����%nXWD`ys&v���r^��^�n)�:���U��SFj��aEf$4C��Y�	��q�"[�o�_*B%Q�cё�4 g�>����jc�"޻2��P�j���GJo��:�8��;�՜S��`'��+*��M #�I�e:�Rޅ��-�/�Xd�ƚJ��2�Av y�#c��}�X�i�Cf�g��D�~n��LQi7%�B���Y� �@�+=��z QE&e
���Ug�9��`1NC�O��*��d�� $[`���="�_$$I�!�j�7�D��)Oq�ݣҏ�q�`(�W(�`Y�K����-�vpb��dۈ<r�qH�>q����Y�[�iX�J �Dd��6|�g��.���V1�aL�U���V���A0��i�#�J�����qM��Ǝ��:��6�K��8n[%���i\�в��0��j��}�����ݛ���t��*�M�ҷiF(��{|di�8�%�l��+2�-Ͱǥ�#h�ր�AE�<�6 t��A�*�a��ݑ��	a��i�w��qڷd�;���j
:���������DV�H�?G��+��3�[+nFU�D1-c�R�3Z� �3��J����Z�E�Y�㺪Ң�&�Y��C�R�d�����XD�ő�jҼz\m��u���j���8�SX�ZowZ�jM!Е	���Z�a�ǫݯ����?�4/_���N����9�w�y�O7f�듖y\�!en/ES�q�S�B.4���%a9>V��-i9>Xd{�t�ohT�W&�e���Es�AI�X40ka,�*.�6]��e�k����M'	 Aŕ6M�-�S�A�!j|��+�{I(h�'˖L�V�n�t�] Ҿ�0�.��;=c��:�����R}hTqS��g��:.	`�==�um��P�Ѻv%��dp��ӕeQ�8�U�Q��*�dDҝC��ߐe�ah�"�7&u	�:n	��jI�l"�/�P����LSN�Q�=|�s�Md��d�ߪ��v��s�%|��"����
���&����J�+�b�P�D�b�siT�9�$�~��xY�q�4��a\(�F)��"�"K��8�B��� �e���!    b6���
+�\uq��f�����K�v�v�ן#a�_�Z'��se���v���&�+xg��U�d*-���s��l�Q�=���!HT��o�o(�AC(4�,��H�T;9�qK:E%9U�TcMЗc������0Nf��"'Qu�jI/-��Z�����X4Y%��vߟ�N �>^�߾����������������������c������K]_�%7!D�lf�M6H�j<�׻����e�+����i�_>~����YQ]�/�_HPs��|�<�������x�wH�#Sa	���9�|���v�\�׳>7����QS^�qk4O�d������o_���_����џ!�~?>�˱~�@L��Q�1��G�e�����2QY��C�q%?E�u����vo�sR�^���Wб��,��KgN������ڿc/z�%��]����Ʋ~�b`���̘��4E/7S�r��t�����O���lB-���o����!�ԓ4����z��dx���)�ط)9�t�bΕ��9����)��h8��ĕ�������.����2m���=��n�?���3A�pq��>��K0�;I������I��R_q��ɛ~������}�:̓s�Nt�i��2;e���ˮ��,���,����\-��v!�UL�q>����o��o/����/����߼`~�޶RU�*�Γ�x��Z�
9�X�{o��N��/ޞ8�����KF�g���7�~�``�9�!��|�c��{������RMnf�ϛ
�����o}8�����M�esF�kڃf�~����&+n"M����Z������{�"EZey7�\e�z^Ej\N�ff��t_�>�����ybc�g��Μ(��cB�+ݜ̙Nӝ������-���.�!���OQ���W8_"W6'�Lf=��
��ل�_t� j�U@��J>A5�B���N�+��%7��T�uAY���Z>��|b�����h*���=�^�-��2�?���`0i�w%�(:�eU q%�GX��+C�`=aUɐ)�Np�S#S�lDU���
>~E��U!���[�v�32�To��s���0������7��ZZ�^;��B�y��$=�h���Bд}��!�E5��fx
]���*4ٮ���j���jYM<>�C�H�1��0&���Jǜ�ԫ�K��a���KR�g~�24ۂq(�n�
�VL��%ե�l3����M���ڰ6�3����CZ���_��?�N�������$;�}ȇ&��	묲�G���=Lio�t��b�j�d�"�Z�̐�Z1�7zj�xi�M�׬GZf$�lx��2�߰���@��]AUy�FNPc�w7!A}��$��iRM�����6�0Z'�-�Z9����G�܄��i��Re���sc%R��K��8����!Y�nuH�XM`Yw�ohr'�CTL��b�12Ԃ85cd(p�C-���y���ۣ�M���W �a(E�nBi�	tk����[�NB��Ay��/���8'X�i���y.�|WU�Tk��E��^<��v
�)���|Vl�|,55ݐ�Ӆh��ȔΰBfbzi���i�F������Z�m�4�����+�������^!�f@��S�i>m7�f��ߥ�N�!|��;�2�&�܆���9e(3�q�T\f�������Ɋ��B���/^!A�T�UXz�9Y�y��|�l�ut����T3ٺe�M!M��^���js���c�ap�-�Ɛ^�Iv"�#�r��`��+�$�_���V%z�J����y��8�#�p��KNY�̚��ĸD�����Q�_��Xn�xGԴ��[TM1&؄0�b����AQІ.R��LZ�n��Ɍʂ�+���n�n�ٞޟ�g���_�������K;^��N����ȗ���^%��:�ʺ�me]��үoF���׻9����6$?��H�`%�"��\�qXz�����!��f`ltT�u���J���|�dx#�����{/˟��o$��^�ɽ�ѱ�P2��jC3�<�T�S*�}5��!D�����-B�z9��ɪnB��.�����z%I\A=I}3��j�z���� �����	*��
J���ŖOq�r�%�4�P�,H̭��$+�')ai�(���1�������vCx!tg�����屮U��Cl�-�)-
���k9	�1 �)���L3���s���8�W��o����E*])��A�bd_B:�b̵Ѱ&���v�~|��zxz�~w�F���ad[w�FNO��+A������W5�L�&�"RT����"#�DPl�S4*��! �q d����C�2B.��4^E/�[4EL�� �kh`&Q!%7���S�GB����<ZPEH�hL�@#X � ��Lb�LAɐ���np�P0�1ν��c�h������0��u��%+��*�!�C��3���5�I������t�ASЏ�@�I�1�����ǫ5~^M�(�'�i�7L�To���V�E�� ��߆��W�okG��ɦ�{��m���IuG%C�W�R�*�F��+�~2�,'G�Φ�-c�����xЂ�l�4&Y�T;��a8���]qNB�t)�	��ЍW5�ҌWqU�5�Ae�9)C:�`�����`�P얾l�nK�	�q-F=�ƕy(��2��JH�WU�u����AP��U*֌ϏM����I�ܺ>���\oHA��KՓ�4�a��%���p����"g҄09g#��%AI��	�A ���w'��pRg�ud��@�Q��"8��
VVQ(ҀBQ(0楹	�e'��M��ܸ���օ���.��m��x����jǩs����.��Q<=ZS���N��<hF���A1��~4�(����uLy�xOBӨ�{����^~ro�bb���"ɓ���0��ԜN����
Ί�Lb���2�M��%��掙"E�X2Cjڱ�|W��B*���1�|jV�Y֬�=ݢ�jY<`sђ>D��&�:&ʷ��/�����Lۼ^??>������W�����;(��L~��U��UK�S�����|#��/�U�C�'�]�n�(E���R7��Ç��[¤�qn�������su��{�^��i����!"�V#t���F�w!�U��H��9�s~��*R�Z�41��Z?���y:0UE�r0���;cT��[��'������1<���p�E�tp�Ê�RP7B5Rip*F�ZX�E�{��Ihx��IpVlo�2/}MH�E���8���wH�>-*d�-����cH�	��O|% ճ5:QUM�)�)���42U�4c�cH�U-��1ijz�$���+��pB�W=���f��\�z�C��N�y�
�|���0�^��<'_?T������p��鏟?}~���*
֍���n�V��v�j��༫�A�!��Vz�����H�G�ב�H�?8�\�.��9p-{��k1A7�x(�deI'(A�����ଞ.2����.r��]�kF����N�:nt��g�~#'(�G|l=���җ�s󍜞�rz�����1��P}s�FΏy�XV��?�m�Ɛ��V�CWdS9n�b�F\a��S�N����R�X^��j�jٴ�CX,oH33�;�[�p3Hx�<xz'1k�����A��߄Ŗa!Q�LU���bڡ�ms=��A�͟�Q�4�APl����f������ �a�a�sC�쪝p��l�BTfe��/�Q�x�@l��ܿw �����$��o��h�smh`n�(};ݖ��QF���4�B�
jڮJ���Ĥ���c
�v:F_GϐS�JF��7-�J�d��QeW�P��LKy蛭[3c3{�}"����sډ��m��FXP5�%u%t2�B4�ZM`���5}��ը��jk�p��c�P�������M�G!(�R]z���,&>B�R������e��lPf���;ѵ{Bҗ�h��N�*-z1W��RA�q�Vt��>��ɈU�Yzc ���D�gZ�����A!�a�m�|��"��.�ހ���d���zl��]]3H�]]/H[3�b��ap�i=�7FIw�e֎?�Ra!��a�
s    ��;���"��(B/�J;0���[7T��5��D�r�fg�-�hT��C:])���X��k|~���`Q"!�pz2s��<�����i��&,j���m��8'Am���aZb鲍M����66&��m5^zw7��'���2A�_B*�A(NP�v����Y�چ4�S=lL6�b��鮮ɥ�tW�����i�y�(�~:�w[V�.	�����tuf*��I��U�x�g���Fc���h=-�V�����qu#�&r��+�#Ӥ1��g�M�Á 0�Pd(�������u<Fb#W��z�o�nE�=�*��OE�fW�	�:���<�=�x�4$�ˠeZ�*�/!Mpu+�3��A�,:,������ڴb�)cb(��m��糷��!��6$P��g�JkP!}��t�\crM=�3�^&��"R�Svy�f<�������g�`6TцPR�{�q݊�(��.G8T����෪⺄��.��P�u=w���E+��7zn�;�Ѱ�KOMޅX^Z�i�^�r�.��R�k�n����gP��d(��}H0BM�>0�,����N�l}�f�F &P��f��H��Rg^��4eh�t��qR�KL���D����w�p�y��7���������w���6举���4�L���0��{(�Y0���Eǉ	�E�����3�(W���EO�������*�ē!�[WK<�Q��7�/�qs���~�g��VĪa����ws5��>���=S=@1z�',�p��im�g�ڠ_A�*&��Y&��+�6}��NMa��t����}���R���!L���p�I�;0�P\�p��H�Cj���M����瑴xA�������4�K�q��-�Qc��@\�'��Ʉ�� ���$&&Dh�ń��%�wɯ�f��<|��M�QH�s�����s���ˌ��mR��mxJ���6����"�J���bXD-��7CHⱄ�	�2���$Q!l�CO��LF�L)s%U@=݆@�N �
���b>�r�[l�~#�j�VKl��q�#jI�+��!�PFX����0����X2���oPW�#w�d��ktB�Q_�3zL�W���ߜ�<'�·
�̖O��7� Lj����M����mc�4*��
��mÅ�+�^+��d�;8t�<���u�W���+��7��@�Ҫy�F�M��S�VJ���7�?�k-��/�<B��Vv@���n�7a��ߛ�|E<E+s�c�RdG���&�L9N�%��l>�!]?/�2J��D#'i��ɢ��)�D#=�)CI9���_陖V���J~�����_�јG���e>�t�%C��t��˧�j�_>��<ֱ�Gq��؛�7�}�q������tb�?<޽�O��0l�A��
�\����dHX-���43"�|IS�C"����.�����0,Z��X���z��m���r4��*$�V��b:��$!��ӛ�0��8a���ht�}�hM�|z�Mv�>�o�bz�ٖP�x��7������΋�'X냚*kI��bDu�1��霤w-���臝)���@1��ӽ��*��hHKTͨL��A�V,W$��=OahR�U��G�VntO12]��i$J�Ө�X��B�v�N�w�B@hx�B@���Ⱥ4��:���c�k7�EsN��dlP�p����=ʊ�g��4*V�r�9�1�j�yWT(������e}��U׳>�XR�>C��Y��[�B��l�I5L"�P^�e���KZm�*u��s4�>:���6!�;5��bt�z�f3�d!��3*�|BY��N��f~z���݆Պr@�6}��״�k��PK�	����qN��!�����fšW���p��yko����k2�w7!��^MGqs���慸.�h"4�D�Ď��Qر��c�x�.���d��ɺ��v�$�j�1L*��7睖�`�RF� �ޮ�m���8��X��	P�
i����0�Qz��&$5JKs�0��wo�&��l�ɽ>�Qq�(���6$�EOz4ݿ�]$!��DP�������vZ-�u9�@|B2��[?�m��5#�mVY�m�Y��
I�����r�!��$Q�0m*�ع�1M��Q�����HҔF̣S;cH�S�PH�S[����4�9��IM�!~�Z��/����c�cx"Ÿ⨨���:_w�B����$9"H�m'<�~铇x]���0d�h�#9H%NK�B�s����e�Ű�A�"�؅��X����*��]�;��RwLC�~�3���Z�}�<ɢXx��?{���fo�i���d��F�ӿϨ"��^d��e�5	�>O��+��%=S�V�Y���ϰ"V�3siW�]���>$H�����"�=��]A�+�"Ӈ�4��U9^��-Zus� ��<m����ύVh�m��h�^ضc44���δ�0\��KYyb;������BY֧�Q��{�/��C�2#�b���5L�հ��W5���&�e�5�+�Adn麠6�`�b�h��	 �)7)"̀PLKpШz��*B$��(X47IC�, ݴ, @��E��i��J�]HXy�/ ��}P�CX7�8â�SS"�.�e1�iX2�7��ҋW�*���킣�?T����P%x,�C�!�K90�TA�� @�4��<ZCJ�K�M�FW$�ppK)�lB*W U@C�d�<�^qʔ��wPkш���p �N���pt�(xN�� V�¢�ƒ,�n�fXTcg� �}���Xt�I�M�P%s�z�$>Wn�M���T���pa{~cZmCa'h�qp<l���kn(��BDY��C��?��C7��ѡ-��J~�P�hF�g�pL%� Պ�f5�`F�O0�^[B"U��V�
. �ɓI$���&��j���h�x2���­��̣������E�1�Ѳ�,éU���5Lt\�V��N�]f``���F��N~�͡t�/2�A��!���/�&�e�C-��2q k����~����������Hb�~c��%��]���c��
j[}v�^�R7zoc?������Ll���!׿�Q�o>��v��7�h4��|�oTmϊb�����*��^l���P�IT�uH_oE�:�я��e��p�j.Ì&��Gbq�Q��8O3Sg)�j?1�H��P2�@k�{ыJ��,j��s������~;~n�=Q����F�Q���葛3������{���J�1$����'{�	����F<wĒ_8p(�_P��E����
	���+ҁD�2A8Z�������dh�V�]��˫h��FC�/�Q1��C�U�g�j*&�����B�|��?skYihS�9���Vq�x�00��$lH���e�zGkFB�BZ;����';�_1��"��:�׮Ǯ���Y��7G��<=�ʍoj��k90�XL�c囡r���qK�m�J�cs�Cז5x���K�
7uV���<z��v.ܡ���W�}R�
�J='�{vt��&��hZ/���"Wc���n�7֭� ,'F�%kH=�B����a
e*�V����t���Q�^?�H���1ۄ���l���;HյkB�/=;�		i
�Bz��ŰZ�4�N��^�?<�ZCHK>�!�)��g7;cܲ3JK箥c���Nk<��۔��_jRS9�fY��e����*m�5�����J� �S�+i�����Ik�� c�h*RmHM5��ezh	�r�kܤEJ�q��j$n�b�T��U��E�F��W-����l��hOJO�ܚ8����z���Ͷy��p�f�_�e������t�v����ô���?y�i�yjN?���ya6��-ޥ��Na�YWf�GH��B�-���jŊg-��7�۴���/�K�����r+��&D�ܟ.ĻU���W^rѨ�p;�K�0u!��z̻���+҆�&��E�?D��-u�^�{�V&� v!�i� `��+����[xj��]y�F�v��웁e�j t凊ThHOj=*tFaT�[&[1�Ѻr���V몊�X�acI�tKǨ7��}H�X-:�
ov���6;���Ɖ�� >  }H�B��V�z &_�'��O��~ �L�QE@�/���B2uR�/^Hu*5xFq� ��� �X���9�3�����.�3:%��Մ���j��j32�	��w��u�F�[��uʳ�m�&"�����bz��"�S��L�[��	nb��6���|n1�!�:U��aH�*�S$}X��-��v��;5�~ū.PC��0
��m�*�e���i�+�T}1z[�*\<G@*���n�s�����L�-�c��B�'��)^?#o�5�@pr̪_ѦQ�HDp��S̢���7��c,C����a�x��)��_B��R���*��	N�?G"F�b�ҎF���
�{�؆��.f�)K4�a��(]���{�!�iuwS�h ޖ�Q�M�4��1��Q����!
<Le�-<������*�-��,l��������<B � ����4 ��Ң���K�V7�H���='MoW�<��my4UF!�1$�H��?����a̋xje+A��kW�{ѧ.X܋us�F^�!�Pzꂑ'�	�� ��n�G"�=��5�y��f8C��8��?f /��Ϗϟ�������gy��?�	#�	�e��5Cɏ����z�L?��^O{�̄Q�V40�S���i�T�D�b<>=vy�������S�Im�J@��$,@��v��N�rE���!8��0�R:��Ñj��U���~3�5�ҐV�j��qn��9�m�4���7rzB�s�����������|#�'��S{Ϋ|ع1�ۤ;W���g3�E��;2Eu�3�,C�c��r�<PEH-�@%�,:Nl��,"|����ݰ��MB��n��M3gnƒ!�=rr[���%ðH�"?L/J;��/%b,�D��J��!�ק�����I&�N�p�~�]�;-C�B-�4ir�A�'�^�5��P}0���@19��/�p�C���BN�z���g`T2��.d0�b�0��/���4�{����v����Bl2 SˆN�Z�&iF�j'0��u�yz��
��A��u?H8E!�j1����#�?^�M�ի��s�;����ʔ�V��4��>�$ñf��t��:$�Mȯ!��9z��v
��h[��
J*��~X�r��[NK���B�LM��K�A?X�D#�x����'��B�|k	bj�J�� �p�P�U�mƓ#�T��I�hD�U�F4~��f\�	�BqQ��Yq��
��5�k��+P��
�TS�фD��4N���>���%�mB�j��!�4��&���c4�T��wфpQj"���V4��&�[ѳʘ��P���a:�tE�+���h��7r�wrHn�l17Y�N��hz֧�n�����ҹG+�h�^!MTU!m��O��i��:�um��)�f뚱�&ah9���HaF�_��m�[R1�u
�)��ּ��EHe=Ǣ��}�t.���65�0��6$/�a[�Y�3*²� R��l�f��|���u*�u�U_�q���G��=�)�RH�t� ،*���ޒ݆]����Ou�F�hH�0M�z�E�`x1���r(p8�����7C�WrefF���×�%�����܆<��� �nզL�M8I��j�,��U�w�����漥F#o��R�P�aE��PD�[��CP�!yOJ"�r��OR�wZ����^�܎b��j�@2׽������Sᖐ�јУ\��n�DCa��2�%}F}5�gI��~���m�*�����8%z��B�b�<8�j!}:��Fz�b*2�5=z��XF�8�e�C�T\T<+���g���X~$���j7|\��w}�F��Hb_i��)��_��7)���?<2j �􋡅º�n����1��@�W��H��������6!=څ����x�z�������������S�����������aPo���i��@�MC������'��������y��N"�9��I_����	���z��o&eM8���.(�d���r~� Y�pC�2T��}r��� �T �U�[�K 9�� Rf�ʽ
��w�J�I9,����H��P$ӕۖ���w���χ���������������2������R��B�������������͗=����`넪I�j���P����Bu6O��"�dQ��~�	V�x��_L���7W¨�~7@O��~���ޟ�_�>��o���/�	I�k�H�?W�;� ���\`��^0酋����愪N�����Ϧ�	U�U;�9�@u�ʥ檊z��ƥ�T5M�T],��K�~_�]g�V��E��U����D��	oxh��=Ͳ�V�ƽ;Ҩ��J���V�1��KlǴ������P	?�}�k�p#ͺ�t���%�,�̩��ь\e|1Ѩ��sT@j�"�]��2�z�� T/��?�iKw��buQ�β�F&�����Qe`ˑ��84��B�!��L�)���)( �\�D�\�86��G/b��ZY��F�
��UI��3���\��ƙrg��	Րz��մs���ӧ��l�x_B�˗�;ǧ�?C�h�G*�KOLw�e-�����46.
��� =WQ����؉�v�hTq����Ǳ�)��4,�H�����iTq>��=ZšJ���j>�3���宽��{���χ	�͟��E��{��Z�7�h~i�:�w/��I7]��g��OWc:]h��qt�0��HY:.��ƙ���^\<Jڞj�b�q���&fOuq����)�vk�Bf�k����Ҧ��α����7�h��[ �⮂dQj���ڤ��q2�t��*��L���$,c{
�K��N�.M +�Mg�Шjc.l�AY���8r󁬣� X�ՙ�, [<�IN&'��,Ŵ�^�P5�ZRU$͑�ݧaM�ko._�����-��I��*qR�d�&2���`q����!\Lc�̚@��cis�h`��
\ø�J��@�Ö�\BS��y�)U���S�yh	�8�dҘYŰ���Sio�t�Y���9�QE��t� T������0�Q�]Y���X������v��H��Ƹ����!hT���c��I5��i�cڪ��/�� �N���E4M���y����
Dd�z:�A��-�A ~#��=԰�-��.�:��&�a<�W�Uag��������U�      �   ~  x�m�Mn�0F��Sp�T���T(�$�
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